#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_system.h>
#include <stdio.h>
#include <assert.h>

#define MAX_ORDER 11                     // 最大阶数 (2^10 = 1024页 = 4MB)
static free_area_t free_area[MAX_ORDER]; // 每个阶数一个空闲列表

static void
buddy_init(void)
{
    for (int i = 0; i < MAX_ORDER; i++)
    {
        list_init(&free_area[i].free_list); // 初始化每个阶的空闲列表
        free_area[i].nr_free = 0;           // 初始化每个阶的空闲页面计数
    }
}

static void
buddy_init_memmap(struct Page *base, size_t n)
{
    assert(n > 0); // 确保请求的页面数量大于 0

    struct Page *p = base;
    for (; p != base + n; p++)
    {
        assert(PageReserved(p));    // 确保页面是保留的
        p->flags = p->property = 0; // 清除标志和属性
        set_page_ref(p, 0);         // 设置引用计数为 0
    }

    // 将整个内存区域分割成最大可能的块
    size_t remaining = n;
    struct Page *current = base;

    while (remaining > 0)
    {
        // 找到最大可能的阶数
        int order = MAX_ORDER - 1;
        while (order >= 0)
        {
            size_t block_size = 1 << order; // 2^order 页
            // 检查地址对齐和大小是否满足
            uintptr_t addr = page2pa(current);
            if (block_size <= remaining && (addr % (block_size * PGSIZE)) == 0)
            {
                break;
            }
            order--;
        }

        if (order < 0)
        {
            // 找不到合适的块，使用最小阶
            order = 0;
        }

        size_t block_size = 1 << order;
        current->property = block_size;                                 // 设置块大小
        SetPageProperty(current);                                       // 标记为属性页
        list_add(&(free_area[order].free_list), &(current->page_link)); // 添加到空闲列表
        free_area[order].nr_free++;                                     // 增加空闲计数

        remaining -= block_size;
        current += block_size;
    }
}

static struct Page *
buddy_alloc_pages(size_t n)
{
    assert(n > 0);

    // 计算所需的最小阶数
    int order = 0;
    while ((1 << order) < n)
    {
        order++;
    }

    if (order >= MAX_ORDER)
    {
        return NULL; // 请求太大
    }

    // 如果当前阶没有空闲块，尝试分割更大的块
    if (free_area[order].nr_free == 0)
    {
        // 分割逻辑开始
        int current_order = order;
        while (current_order < MAX_ORDER && free_area[current_order].nr_free == 0)
        {
            current_order++;
        }

        if (current_order >= MAX_ORDER)
        {
            return NULL; // 没有可用块
        }

        // 取出一个块
        list_entry_t *le = list_next(&(free_area[current_order].free_list));
        struct Page *page = le2page(le, page_link);
        list_del(le); // 从列表中移除
        free_area[current_order].nr_free--;

        // 分割块
        while (current_order > order)
        {
            current_order--;
            size_t half_size = 1 << current_order;

            // 创建伙伴块
            struct Page *buddy = page + half_size;
            buddy->property = half_size;
            SetPageProperty(buddy);

            // 将两个半块添加到当前阶的空闲列表
            list_add(&(free_area[current_order].free_list), &(page->page_link));
            list_add(&(free_area[current_order].free_list), &(buddy->page_link));
            free_area[current_order].nr_free += 2;

            // 设置原块的大小
            page->property = half_size;
        }
        // 分割逻辑结束
    }

    // 再次检查是否有空闲块
    if (free_area[order].nr_free == 0)
    {
        return NULL; // 仍然没有可用块
    }

    // 取出一个块
    list_entry_t *le = list_next(&(free_area[order].free_list));
    struct Page *page = le2page(le, page_link);
    list_del(le); // 从列表中移除
    free_area[order].nr_free--;
    ClearPageProperty(page); // 清除属性标记

    return page;
}

static void
buddy_free_pages(struct Page *base, size_t n)
{
    assert(n > 0);

    // 计算块的阶数
    int order = 0;
    while ((1 << order) < n)
    {
        order++;
    }

    // 设置块属性
    base->property = 1 << order;
    SetPageProperty(base);

    // 添加到空闲列表
    list_add(&(free_area[order].free_list), &(base->page_link));
    free_area[order].nr_free++;

    // 合并逻辑开始
    struct Page *current = base;
    int current_order = order;

    while (current_order < MAX_ORDER - 1)
    {
        // 计算伙伴地址
        uintptr_t base_addr = page2pa(current);
        size_t block_size = (1 << current_order) * PGSIZE;
        uintptr_t buddy_addr = base_addr ^ block_size;
        struct Page *buddy = pa2page(buddy_addr);

        // 检查伙伴是否有效
        if (!PageProperty(buddy) || buddy->property != (1 << current_order))
        {
            break; // 伙伴不可用或大小不匹配
        }

        // 验证伙伴关系
        if ((base_addr ^ block_size) != buddy_addr)
        {
            break;
        }

        // 从空闲列表移除当前块和伙伴
        list_del(&(current->page_link));
        list_del(&(buddy->page_link));
        free_area[current_order].nr_free -= 2;

        // 创建合并后的块
        current = (current < buddy) ? current : buddy;
        current_order++;
        current->property = 1 << current_order;
        SetPageProperty(current);

        // 添加到更高阶的空闲列表
        list_add(&(free_area[current_order].free_list), &(current->page_link));
        free_area[current_order].nr_free++;
    }
    // 合并逻辑结束
}

static size_t
buddy_nr_free_pages(void)
{
    size_t total = 0;
    for (int i = 0; i < MAX_ORDER; i++)
    {
        total += free_area[i].nr_free * (1 << i);
    }
    return total;
}

static void
buddy_check(void)
{
    // 简单的检查函数
    cprintf("Buddy system check:\n");
    cprintf("Total free pages: %d\n", buddy_nr_free_pages());

    // 分配测试
    struct Page *p1 = buddy_alloc_pages(1);
    cprintf("Allocated 1 page at %p\n", p1);

    struct Page *p2 = buddy_alloc_pages(2);
    cprintf("Allocated 2 pages at %p\n", p2);

    struct Page *p3 = buddy_alloc_pages(4);
    cprintf("Allocated 4 pages at %p\n", p3);

    // 释放测试
    buddy_free_pages(p1, 1);
    cprintf("Freed 1 page\n");

    buddy_free_pages(p2, 2);
    cprintf("Freed 2 pages\n");

    buddy_free_pages(p3, 4);
    cprintf("Freed 4 pages\n");

    cprintf("Total free pages after free: %d\n", buddy_nr_free_pages());
}

const struct pmm_manager buddy_system_pmm_manager = {
    .name = "buddy_system_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};