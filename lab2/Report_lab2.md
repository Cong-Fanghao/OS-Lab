# Lab2 物理内存与页表 实验报告

## 任务描述
- 练习1：理解first-fit 连续物理内存分配算法
first-fit 连续物理内存分配算法作为物理内存分配一个很基础的方法，需要同学们理解它的实现过程。请大家仔细阅读实验手册的教程并结合kern/mm/default_pmm.c中的相关代码，认真分析default_init，default_init_memmap，default_alloc_pages， default_free_pages等相关函数，并描述程序在进行物理内存分配的过程以及各个函数的作用。 请在实验报告中简要说明你的设计实现过程。请回答如下问题：
你的first fit算法是否有进一步的改进空间？

- 练习2：实现 Best-Fit 连续物理内存分配算法
在完成练习一后，参考kern/mm/default_pmm.c对First Fit算法的实现，编程实现Best Fit页面分配算法，算法的时空复杂度不做要求，能通过测试即可。 请在实验报告中简要说明你的设计实现过程，阐述代码是如何对物理内存进行分配和释放，并回答如下问题：
你的 Best-Fit 算法是否有进一步的改进空间？

## first-fit连续物理分配算法分析
代码内部主要的函数有 `default_init`，`default_init_memmap`，`default_alloc_pages`，`default_free_pages` 四个，简单来说四个函数的作用就是初始化、分配以及释放页，接下来我们详细分析一下各个函数的具体作用。

### 1. 初始化阶段

#### `default_init`
- 作用：初始化空闲页链表 `free_list`，并将总空闲页数 `nr_free` 设置为 0。
- 说明：这是 First-Fit 算法的准备工作，为后续管理空闲页做准备。

#### `default_init_memmap(struct Page *base, size_t n)`
- 作用：将 `[base, base+n)` 范围内的连续物理页标记为可分配，并插入空闲链表。
- 具体操作：
  - 对每页初始化：
    - `ref = 0`，表示当前页没有被引用。
    - `flags` 和 `property` 用于标记页的状态和空闲块大小。
  - 将空闲块按照物理地址顺序插入 `free_list`。
  - 更新总空闲页数 `nr_free += n`。

### 2. 分配阶段

#### `default_alloc_pages(size_t n)`
- 作用：分配 `n` 页连续内存。
- 工作流程：
  1. 遍历空闲链表，寻找第一个满足 `property >= n` 的空闲块。
  2. 找到块后：
     - 将前 `n` 页分配给请求，设置 `PG_reserved = 1`，`PG_property = 0`。
     - 如果空闲块大于 `n` 页，将剩余部分重新标记为新的空闲块并插入链表。
  3. 更新总空闲页数 `nr_free -= n`。
- 若链表中没有足够大的块，则返回 `NULL`。

### 3. 释放阶段

#### `default_free_pages(struct Page *base, size_t n)`
- 作用：释放 `n` 页连续内存，并尝试与相邻空闲块合并。
- 工作流程：
  1. 将释放的页重新插入空闲链表，保持按物理地址升序排列。
  2. 标记页为可分配：
     - `ref = 0`
     - `PG_property = 1`（若是空闲块起始页）
  3. 尝试与前后空闲块合并，形成更大的连续空闲块。
  4. 更新总空闲页数 `nr_free += n`。

### 4. 查询空闲页数

#### `default_nr_free_pages`
- 作用：直接返回当前总空闲页数 `nr_free`。

### 5.功能测试
#### `basic_check(void)` 和 `default_check(void)`
- `basic_check(void)`：功能测试，验证页分配与释放是否正常
- `default_check(void)`：针对First-Fit分配算法的完整功能检查

### 6. First-Fit 算法特点与改进空间
- **特点**：
  - 简单易实现，直接遍历空闲链表找到第一个可满足请求的块。
  - 适合小规模内存管理。
- **改进空间**：
  1. **降低链表遍历开销**：可使用 Next-Fit，从上次分配位置继续搜索。
  2. **减少内存碎片**：
     - 使用 Best-Fit（选择最小满足请求的块）或 Buddy System。
  3. **多级空闲链表**：按空闲块大小分级，快速定位合适块。
  4. **优化合并策略**：延迟合并或合并策略优化以减少释放操作开销。


## Best-Fit 实现过程
Best-Fit 主要功能由三个函数来实现：
- best_fit_init_memmap
- best_fit_alloc_pages
- best_fit_nr_free_pages

分别实现空闲链表的初始化，页的分配，页的释放与合并功能，下面将详细对每个函数实现进行说明

### best_fit_init_memmap
这个函数主要实现了初始化页的标志属性，设置内存页的属性，以及将页插入空闲链表合适位置的操作。
下列代码与原来的first_fit保持一致，清空了页框的标志和属性，将页框的引用计数设置为0：
```
p->flags = p->property = 0;
set_page_ref(p, 0);
```
下列代码则实现了对空闲链表的处理，在判断完列表不为空后，采用best_fit策略来插入base：
遍历链表，查找第一个页框的大小大于当前 base->property 的位置，如果找到了合适位置，插入到链表中，如果遍历到链表尾部，说明 base 是最大的页框，将它插入到尾部。这里与first_fit有着关键的不同点，原来的代码‘base < page’比较的是物理地址的大小，也就是在内存上的先后顺序，而比较property则可以对页进行大小的排序。
```
if (base->property < page->property) {
   list_add_before(le, &(base->page_link));
   break;}
else if (list_next(le) == &free_list) {
list_add(le, &(base->page_link));
}
```


## 拓展练习

## 总结