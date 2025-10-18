# Lab2 物理内存与页表 实验报告
**小组成员：丛方昊_2310682、钱展飞_2312479、李泽昊_2312594**

## 任务描述
- 练习1：理解first-fit 连续物理内存分配算法
first-fit 连续物理内存分配算法作为物理内存分配一个很基础的方法，需要同学们理解它的实现过程。请大家仔细阅读实验手册的教程并结合kern/mm/default_pmm.c中的相关代码，认真分析default_init，default_init_memmap，default_alloc_pages， default_free_pages等相关函数，并描述程序在进行物理内存分配的过程以及各个函数的作用。 请在实验报告中简要说明你的设计实现过程。请回答如下问题：
你的first fit算法是否有进一步的改进空间？

- 练习2：实现 Best-Fit 连续物理内存分配算法
在完成练习一后，参考kern/mm/default_pmm.c对First Fit算法的实现，编程实现Best Fit页面分配算法，算法的时空复杂度不做要求，能通过测试即可。 请在实验报告中简要说明你的设计实现过程，阐述代码是如何对物理内存进行分配和释放，并回答如下问题：
你的 Best-Fit 算法是否有进一步的改进空间？

## first-fit连续物理分配算法分析
### 程序进行物理分配的过程
物理内存的分配不是从default_pmm.c中开始的，操作系统是在一开始的入口点就在规划实现物理内存管理。首先在链接脚本kernel.ld中定义好了一个“基址”，这让内核以为自己是在高地址，enter.S完成的任务就是把预设的顶级页表的位置交给satp寄存器，通过mmu的翻译进入到init.c，执行内核初始化。

作为内核初始化的一部分，kern_init会调用pmm_init执行物理内存初始化，pmm_init会选择一种算法，这里默认的就是first-fit算法建立页表，初始化空闲页链表，再把控制权交给page_init负责初始化物理内存页，它从设备树里获得物理内内存信息，对可用的物理内存，它会调用init_memmap函数对这个区域进行初始化，它类似于一个函数指针，由pmm_manager结构体中的指针决定，使用first算法就意味着指向default_intit_memmap这个函数，这样就把控制权交给了这个页面分配算法文件。

----------------------

dedault_pmm.c代码内部主要的函数有 `default_init`，`default_init_memmap`，`default_alloc_pages`，`default_free_pages` 四个，简单来说四个函数的作用就是初始化、分配以及释放页，接下来我们详细分析一下各个函数的具体作用。

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
  1. **降低链表遍历开销**：每次分配都要从链表头部开始扫描，每次的分配都是分配靠近链表头的，这会导致遍历路径更长，可使用 Next-Fit，从上次分配位置继续搜索，来减少遍历开销。
  2. **减少内存碎片**：虽然first-fit可以迅速找到一个满足要求的块，但是会导致大量内存碎片，这是算法本身带来的，使用 Best-Fit 或结合 Buddy System是一个重要思路。
  3. **多级空闲链表**：按空闲块大小分级，快速定位合适块，虽然需要去维护这个链表，但是能大大减少分配用时。
  4. **优化合并策略**：延迟合并或合并策略优化以减少释放操作开销。


## Best-Fit 实现过程
Best-Fit 主要功能由三个函数来实现：
- best_fit_init_memmap
- best_fit_alloc_pages
- best_fit_free_pages

分别实现空闲链表的初始化，页的分配，页的释放与合并功能，下面将详细对每个函数实现进行说明

### 1.best_fit_init_memmap
这个函数主要实现了初始化页的标志属性，设置内存页的属性，以及将页插入空闲链表合适位置的操作。
下列代码与原来的first_fit保持一致，清空了页框的标志和属性，将页框的引用计数设置为0：
```
p->flags = p->property = 0;
set_page_ref(p, 0);
```
下列代码则实现了对空闲链表的处理，在判断完列表不为空后，采用best_fit策略来插入base：
遍历链表，按照物理地址排序，把块插入到链表中，如果遍历到链表尾部，说明 base 是最大的页框，将它插入到尾部。这里根据注释部分的要求，保持和first_fit相同的视线方式，使用‘base < page’直接比较的是物理地址的大小，也就是在内存上的先后顺序，在分配的过程中，它需要遍历整个链表，时间复杂度会比较大，但是，这样的排序对合并是友好。我们先使用以下的代码，稍后会在改良中使用另一种优化方法。
```
if (base->property < page->property) {
   list_add_before(le, &(base->page_link));
   break;}
else if (list_next(le) == &free_list) {
list_add(le, &(base->page_link));
}
```

### 2.best_fit_alloc_pages
这个函数主要实现best-fit算法的分配策略，找到满足需求的最小空闲块进行分配。

first-fit找到第一个满足块即停止，但是best-fit必须遍历整个链表找到最小满足块，因此break跳出的条件不同。在遍历过程中，记录最小满足要求的块大小并不断更新，直到遍历完全得到满足要求的最小块。

```
while ((le = list_next(le)) != &free_list){
    struct Page *p = le2page(le, page_link);
    if (p->property >= n && p->property < min_size) {
        min_size = p->property;
        page = p;
    }
}
```

在得到最小块后，又面临一个新的问题，这个块的可能会面对拆分，如果不需要拆分，让上一个块首指向下一个块首就可以了，而如果需要拆分，那么就需要把剩余部分仍然按照物理地址排序的方式放在相应位置，而拆下这个块的时候，作为原块的一部分，剩余部分的首地址仍然在原块的前后两块之间，因此需要做的就是计算剩余块的大小和剩余页目的大小，把剩余部分仍然放到原块的前后块之间，我们用下面的代码实现：

```
if (page != NULL) {
    list_entry_t* prev = list_prev(&(page->page_link));
    list_del(&(page->page_link));
    if (page->property > n) {
        struct Page *p = page + n;
        p->property = page->property - n;
        SetPageProperty(p);
        list_add(prev, &(p->page_link));
    }
    nr_free -= n;
    ClearPageProperty(page);
}
```

### 3.best_fit_free_pages
这个函数需要处理页面的释放，也就是把块重新接入到链表中。这时，首先需要设置释放块的属性，包括大小和标记，然后按照物理地址的顺序，把它插入到物理页表之中，除去这个新插入的块，链表是物理地址顺序排序的，因此第一次找到比它物理地址大的块首时，就已经找到了这个释放块的位置：

```
if (list_empty(&free_list)) {
    list_add(&free_list, &(base->page_link));
} else {
    list_entry_t* le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page* page = le2page(le, page_link);
        if (base < page) {
            list_add_before(le, &(base->page_link));
            break;
        } else if (list_next(le) == &free_list) {
            list_add(le, &(base->page_link));
        }
    }
}
```

最后就是要完成块的合并：在原来的链表没有需要合并的块的时候（这里原来的链表也是由经过若干次分配和释放得到的，因此数学归纳也满足相同的性质），只需要考虑新插入链表的块的合并即可。因为本身链表中的块就是物理地址排序的，只需要考虑新插入的块与前后块的合并即可，如果紧邻就合并，实现这个功能的代码如下：

```
if (p + p->property == base) {
    p->property += base->property;
    ClearPageProperty(base);
    list_del(&(base->page_link));
    base = p;
}
```

### 运行结果
当完成上面的代码修改后，使用make grade指令执行代码，得到如下的输出：
```
>>>>>>>>>> here_make>>>>>>>>>>>
gmake[1]: 进入目录“/home/cong/OS/labcode/lab2” + cc kern/init/entry.S + cc kern/init/init.c + cc kern/libs/stdio.c + cc kern/debug/panic.c + cc kern/driver/console.c + cc kern/driver/dtb.c + cc kern/mm/best_fit_pmm.c + cc kern/mm/default_pmm.c + cc kern/mm/pmm.c + cc libs/printfmt.c + cc libs/readline.c + cc libs/sbi.c + cc libs/string.c + ld bin/kernel riscv64-unknown-elf-objcopy bin/kernel --strip-all -O binary bin/ucore.img gmake[1]: 离开目录“/home/cong/OS/labcode/lab2”
>>>>>>>>>> here_make>>>>>>>>>>>
<<<<<<<<<<<<<<< here_run_qemu <<<<<<<<<<<<<<<<<<
try to run qemu
qemu pid=5270
<<<<<<<<<<<<<<< here_run_check <<<<<<<<<<<<<<<<<<
  -check physical_memory_map_information:    OK
  -check_best_fit:                           OK
Total Score: 25/25
```
说明顺利实现best-fit代码。

### 算法的改进
#### 按照块大小排序方式的视线
改变链表排序策略，使用块大小从小到大排序，这样在分配内存时，找到的第一个满足要求的块即是目标块，相应的，合并算法则需要遍历整体代码，这里在下面给出需要更改的lab2：exercise代码部分：

- part 1：将比较page和base的地址大小改为比较它们的property属性，按照释放块的大小把块放回到链表之中：

```
if (base->property < page->property) {
    list_add_before(le, &(base->page_link));
    break;
}
```

- part 2：在分配页表时，遇到的第一个块就是符合要求的块，可以停止，如果遇到了需要拆分的块，原本地址排序的代码只需要把剩余部分放到原本块的位置即可，现在需要对链表进行遍历从而把它放在合适的位置：

```
while ((le = list_next(le)) != &free_list) {
    struct Page *p = le2page(le, page_link);
    if (p->property >= n) {
        page = p;
        break;
    }
}

if (list_empty(&free_list)) {
    list_add(&free_list, &(p->page_link));
} else {
    list_entry_t* le = &free_list;
    while ((le = list_next(le)) != &free_list) {
        struct Page* page = le2page(le, page_link);
        if (p->property < page->property) {
            list_add_before(le, &(p->page_link));
            break;
        } else if (list_next(le) == &free_list) {
            list_add(le, &(p->page_link));
        }
    }
}
```

- part 3：合并时，原本的物理地址排序方式只需要对考虑插入块与相邻块的合并可能，现在需要遍历整个链表去找到离插入块最临近的物理地址的块，再判断是否有无向前或向后合并可能：

```
while ((le = list_next(le)) != &free_list) {
    struct Page* candidate = le2page(le, page_link);
    if (candidate == base) continue;
    
    if (candidate + candidate->property == base) {
        candidate->property += base->property;
        ClearPageProperty(base);
        list_del(&(base->page_link));
        base = candidate;
        merged = true;
        break;
    }
    if (base + base->property == candidate) {
        base->property += candidate->property;
        ClearPageProperty(candidate);
        list_del(&(candidate->page_link));
        merged = true;
        break;
    }
}
```

#### 进一步优化
我们注意到，使用块排序后主要开销从分配时的遍历变成了合并时的遍历，因此我们可以选择更好的合并策略，如延迟合并，去降低这一部分的平均损耗。

此外，可以使用多级链表，链表的每一项都是一个链表头，第一个链表头连着所有块大小等于1页的块，第二个链表头连着所有块大小等于2页的块，以此类推，对块大小的可能性加以限制之后，这样就可以一步实现块的分配与释放，大大减少遍历带来的消耗。

## 拓展练习
### 硬件的可用物理内存范围的获取方法
在 ucore中，操作系统获取可用物理内存的方式是通过解析QEMU提供的DTB（Device Tree Blob），DTB中包含内存起始地址和大小信息。内核启动时，会根据DTB初始化空闲页链表，构建物理内存管理器（PMM）。
如果没有DTB或固件提供信息，操作系统可以通过逐页探测内存或读取特定硬件寄存器的方法来获取物理内存范围，但这种方法在实验环境中不推荐，因为可能访问非法地址造成异常。

## 总结