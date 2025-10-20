#include <pmm.h>
#include <list.h>
#include <string.h>
#include <buddy_system.h>
#include <stdio.h>
#include <assert.h>

#define MAX_ORDER 11             
static free_area_t free_area[MAX_ORDER];

static void
buddy_init(void)
{
    for (int i = 0; i < MAX_ORDER; i++)
    {
        list_init(&free_area[i].free_list);
        free_area[i].nr_free = 0;       
    }
}

static void
buddy_init_memmap(struct Page *base, size_t n)
{
    assert(n > 0); 

    struct Page *p = base;
    for (; p != base + n; p++)
    {
        assert(PageReserved(p));  
        p->flags = p->property = 0;
        set_page_ref(p, 0);   
    }

    size_t remaining = n;
    struct Page *current = base;

    while (remaining > 0)
    {
        int order = MAX_ORDER - 1;
        while (order >= 0)
        {
            size_t block_size = 1 << order; 
            uintptr_t addr = page2pa(current);
            if (block_size <= remaining && (addr % (block_size * PGSIZE)) == 0)
            {
                break;
            }
            order--;
        }

        if (order < 0)
        {
            order = 0;
        }

        size_t block_size = 1 << order;
        current->property = block_size;                    
        SetPageProperty(current);                             
        list_add(&(free_area[order].free_list), &(current->page_link)); 
        free_area[order].nr_free++;                   

        remaining -= block_size;
        current += block_size;
    }
}

static struct Page *
buddy_alloc_pages(size_t n)
{
    assert(n > 0);

    int order = 0;
    while ((1 << order) < n)
    {
        order++;
    }

    if (order >= MAX_ORDER)
    {
        return NULL;
    }

    if (free_area[order].nr_free == 0)
    {
        int current_order = order;
        while (current_order < MAX_ORDER && free_area[current_order].nr_free == 0)
        {
            current_order++;
        }

        if (current_order >= MAX_ORDER)
        {
            return NULL;
        }

        list_entry_t *le = list_next(&(free_area[current_order].free_list));
        struct Page *page = le2page(le, page_link);
        list_del(le);
        free_area[current_order].nr_free--;

        while (current_order > order)
        {
            current_order--;
            size_t half_size = 1 << current_order;

            struct Page *buddy = page + half_size;
            buddy->property = half_size;
            SetPageProperty(buddy);

            list_add(&(free_area[current_order].free_list), &(page->page_link));
            list_add(&(free_area[current_order].free_list), &(buddy->page_link));
            free_area[current_order].nr_free += 2;

            page->property = half_size;
        }
    }

    if (free_area[order].nr_free == 0)
    {
        return NULL;
    }

    list_entry_t *le = list_next(&(free_area[order].free_list));
    struct Page *page = le2page(le, page_link);
    list_del(le);
    free_area[order].nr_free--;
    ClearPageProperty(page);

    return page;
}

static void
buddy_free_pages(struct Page *base, size_t n)
{
    assert(n > 0);

    int order = 0;
    while ((1 << order) < n)
    {
        order++;
    }

    base->property = 1 << order;
    SetPageProperty(base);

    list_add(&(free_area[order].free_list), &(base->page_link));
    free_area[order].nr_free++;

    struct Page *current = base;
    int current_order = order;

    while (current_order < MAX_ORDER - 1)
    {
        uintptr_t base_addr = page2pa(current);
        size_t block_size = (1 << current_order) * PGSIZE;
        uintptr_t buddy_addr = base_addr ^ block_size;
        struct Page *buddy = pa2page(buddy_addr);

        if (!PageProperty(buddy) || buddy->property != (1 << current_order))
        {
            break;
        }

        if ((base_addr ^ block_size) != buddy_addr)
        {
            break;
        }

        list_del(&(current->page_link));
        list_del(&(buddy->page_link));
        free_area[current_order].nr_free -= 2;

        current = (current < buddy) ? current : buddy;
        current_order++;
        current->property = 1 << current_order;
        SetPageProperty(current);

        list_add(&(free_area[current_order].free_list), &(current->page_link));
        free_area[current_order].nr_free++;
    }
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
basic_check(void)
{
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;

    assert((p0 = buddy_alloc_pages(1)) != NULL);
    assert((p1 = buddy_alloc_pages(1)) != NULL);
    assert((p2 = buddy_alloc_pages(1)) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);

    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    free_area_t free_area_store[MAX_ORDER];
    for (int i = 0; i < MAX_ORDER; i++)
    {
        free_area_store[i] = free_area[i];
        list_init(&free_area[i].free_list);
        free_area[i].nr_free = 0;
    }

    assert(buddy_alloc_pages(1) == NULL);

    buddy_free_pages(p0, 1);
    buddy_free_pages(p1, 1);
    buddy_free_pages(p2, 1);
    assert(buddy_nr_free_pages() == 3);

    assert((p0 = buddy_alloc_pages(1)) != NULL);
    assert((p1 = buddy_alloc_pages(1)) != NULL);
    assert((p2 = buddy_alloc_pages(1)) != NULL);

    assert(buddy_alloc_pages(1) == NULL);

    buddy_free_pages(p0, 1);
    assert(!list_empty(&free_area[0].free_list));

    assert((p0 = buddy_alloc_pages(1)) != NULL);
    assert(buddy_alloc_pages(1) == NULL);

    for (int i = 0; i < MAX_ORDER; i++)
    {
        free_area[i] = free_area_store[i];
    }

    buddy_free_pages(p0, 1);
    buddy_free_pages(p1, 1);
    buddy_free_pages(p2, 1);
}

static void
buddy_check(void)
{
    int score = 0, sumscore = 6;
    int count = 0, total = 0;

    for (int i = 0; i < MAX_ORDER; i++)
    {
        list_entry_t *le = &free_area[i].free_list;
        while ((le = list_next(le)) != &free_area[i].free_list)
        {
            struct Page *p = le2page(le, page_link);
            assert(PageProperty(p));
            count++, total += p->property;
        }
    }
    assert(total == buddy_nr_free_pages());

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif

    basic_check();

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif

    struct Page *p0 = buddy_alloc_pages(8);
    assert(p0 != NULL);
    assert(!PageProperty(p0));

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif

    free_area_t free_area_store[MAX_ORDER];
    for (int i = 0; i < MAX_ORDER; i++)
    {
        free_area_store[i] = free_area[i];
        list_init(&free_area[i].free_list);
        free_area[i].nr_free = 0;
    }
    assert(buddy_alloc_pages(1) == NULL);

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif

    buddy_free_pages(p0 + 1, 2);
    buddy_free_pages(p0 + 4, 1);

    assert(PageProperty(p0 + 1) && p0[1].property == 2);
    assert(PageProperty(p0 + 4) && p0[4].property == 1);

    assert(buddy_alloc_pages(4) == NULL);

    struct Page *p1 = buddy_alloc_pages(1);
    assert(p1 != NULL);

    struct Page *p2 = buddy_alloc_pages(2);
    assert(p2 != NULL);

    assert(p0 + 4 == p1);

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif
    buddy_free_pages(p0, 8);
    buddy_free_pages(p1, 1);
    buddy_free_pages(p2, 2);

    assert((p0 = buddy_alloc_pages(8)) != NULL);
    assert(buddy_alloc_pages(1) == NULL);

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif

    for (int i = 0; i < MAX_ORDER; i++)
    {
        free_area[i] = free_area_store[i];
    }

    buddy_free_pages(p0, 8);

    count = 0;
    total = 0;
    for (int i = 0; i < MAX_ORDER; i++)
    {
        list_entry_t *le = &free_area[i].free_list;
        while ((le = list_next(le)) != &free_area[i].free_list)
        {
            struct Page *p = le2page(le, page_link);
            count--, total -= p->property;
        }
    }
    assert(count == 0);
    assert(total == 0);

#ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n", score, sumscore);
#endif
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