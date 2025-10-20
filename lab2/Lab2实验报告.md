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

### 一.Buddy System 内存管理算法设计文档

#### 基础实现

Buddy System 是一种高效的物理内存管理算法，使用二次幂分块（2^k pages）来管理内存。它通过将内存划分为不同阶（order）的块，实现快速分配、释放和合并，同时尽量减少内存碎片。

在实现Buddy System的过程中，我们尝试了两种方法，第一种存在“伙伴系统.c”文件中，使用地址顺序排序。它的设计思路如下：

考虑这样一个情况，一个已经实现了这个算法的内部，它对它的分配函数和释放函数有什么要求？举个例子，如果你需要的是一个大小27页的，他会直接给你一个32的，不会对32拆成27+1+4，如果找不到32的，能够找到128的，他会拆成64+32+32。

因为伙伴系统的设计难点是在合并部分，选择物理排序的方式对合并设计更为有利，然后对后面一种情况（128），考虑分配算法，分配算法的实现最为简单，找到一个满足要求的块，把它拆了即可。

考虑释放算法，我们不妨先按照物理地址，把这个块加进来，然后再考虑合并的事，这个加进来的过程是不需要改变原有代码逻辑的，合并的时候要注意，如果加上这个块，它的形状是64.32.这个块，32的话，我们需要确定它的合并逻辑，不会出错。

因此就需要判断，只有成为伙伴才能合并，成为伙伴，就是按照地址逻辑去判断的，互为伙伴的两个块，他们一定是只有确定某一位不同，(想象一个编号为1的大块，它拆成两个子块，一个是10，一个是11，11释放回来的时候一定会和10合并，而不会去找01)
从而判断好了是否为伙伴的逻辑。

当确定两个块是伙伴之后进行合并，因为合并之后产生的新块可能和原来的老的大小相同的块也是伙伴，所以要不断的do while循环，直到没有伙伴继续合并了。

考虑如果实现了这两个函数的设计逻辑，他们执行的操作都不会把一个稳定的地址对齐的链表结构给破坏掉，也就是说如果做好初始化，实现这两个函数的逻辑之后，就不需要增加新的内容了，于是接下来去设计初始化函数：

传过来的一片连续空间，把它进行地址对齐之后，按照2的整数次幂进行切分，然后把他们依次排进链表当中，这个实现就是正确的，尽可能大的对块进行划分，规定一个起点，然后在这片空间中拿到最大的切分块，然后划分标准除以2，直到分割变成只有一页。

事实上，如果初始化时没有地址检查，他也不一定会有逻辑问题，因为很可能它是一个很大的整的连续的地址空间，链接器它在排列各个段落的时候是按照地址对齐的，传进来的大小为128m的这个给我们自由规划的地址，它的起始位置也是比较好的，不是零碎并且起始位置很丑陋的，所以我怀疑不进行物理对齐，这个代码也是可以正确运行的，但为了逻辑的严谨性，这个工作还是要做的。

这种方式的伙伴系统是为了实现而实现，并没有很多效率上的提升，于是我们在一个buddy_system框架中实现多级链表的伙伴系统，引入了阶的概念，下面的设计文档介绍这种伙伴系统的实现思路。

#### 核心数据结构

##### 空闲区域结构
```c
#define MAX_ORDER 11
static free_area_t free_area[MAX_ORDER];
```

每个阶数对应一个空闲链表，存储该阶数的空闲内存块：
- order 0: 1页 (4KB)
- order 1: 2页 (8KB)
- ...
- order 10: 1024页 (4MB)

#### 核心功能实现

##### 1. 系统初始化

###### `buddy_init()`
- **功能**：初始化所有阶数的空闲链表
- **实现**：
  - 遍历所有阶数（0到MAX_ORDER-1）
  - 初始化每个阶数的空闲链表
  - 设置每个阶数的空闲页面计数为0
  - 把传过来的整片内存尽可能分割为高阶的块，直到大小为1页的块

##### 2. 内存映射初始化

###### `buddy_init_memmap(struct Page *base, size_t n)`
- **功能**：将物理内存初始化为伙伴系统可管理的结构
- **算法步骤**：
  1. 验证输入参数有效性
  2. 初始化所有页面的标志位和引用计数
  3. 将整个内存区域分割成最大可能的对齐块：
     - 从最高阶开始向下查找
     - 检查地址对齐条件：`(addr % (block_size * PGSIZE)) == 0`
     - 找到满足条件且不超过剩余内存的最大块
  4. 将找到的块添加到对应阶数的空闲链表

##### 3. 页面分配

###### `buddy_alloc_pages(size_t n)`
- **功能**：分配指定数量的连续物理页面
- **算法步骤**：
  1. **计算所需阶数**：找到满足 `2^order >= n` 的最小order
  2. **检查可用性**：
     - 如果当前阶有可用块，直接分配
     - 否则向上查找更高阶的可用块
  3. **块分割**：
     - 从高阶获取一个大块
     - 递归分割直到达到目标阶数
     - 每次分割产生两个伙伴块，都加入对应阶的空闲链表
  4. **分配完成**：清除分配块的属性标记

##### 4. 页面释放

###### `buddy_free_pages(struct Page *base, size_t n)`
- **功能**：释放已分配的物理页面并合并伙伴块
- **算法步骤**：
  1. **计算块阶数**：找到满足 `2^order >= n` 的最小order
  2. **初始释放**：将块添加到对应阶的空闲链表
  3. **伙伴合并**：
     - 循环检查当前块是否可以与伙伴合并
     - 计算伙伴地址：`buddy_addr = base_addr ^ block_size`
     - 检查伙伴条件：
       - 伙伴必须空闲（PageProperty标志）
       - 伙伴大小必须匹配
       - 地址对齐验证
     - 如果满足条件，合并两个块形成更高阶的块
     - 重复直到无法合并或达到最大阶数

##### 5. 辅助功能

###### `buddy_nr_free_pages()`
- **功能**：计算系统总空闲页面数
- **实现**：遍历所有阶数，累加 `阶空闲块数 × 块大小`

###### `buddy_check()`
- **功能**：系统自检和调试功能
- **测试内容**：
  - 分配不同大小的块（1页、2页、4页）
  - 验证分配和释放功能
  - 检查合并机制的正确性

#### 性能特点

##### 优点
- **分配速度快**：O(log n)时间复杂度
- **外部碎片少**：通过伙伴合并机制
- **实现简单**：数据结构清晰，算法直观

##### 局限性
- **内部碎片**：由于二次幂对齐，可能产生最多50%的内部碎片
- **固定粒度**：分配大小受限为2的幂次方

##### 进一步改进
- 在检查块合并时，需要比较与释放块大小相同的块与其的伙伴关系，可以在低级链表内部维护按地址顺序排序，那么就可以只比较其前后两个块，减少合并检测开销。

#### 接口定义

```c
const struct pmm_manager buddy_system_pmm_manager = {
    .name = "buddy_system_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};
```

仿照best_first_pmm_manger结构，该实现提供了完整的内存管理接口，可以集成到操作系统的物理内存管理子系统中。

#### 测试用例
这里我们使用ppm.c中的check_alloc_page函数的输出用来检测，根据其修改grade.sh，相应的check函数，首先简单检测调用函数的功能，然后进行反复的不同规模大小的块的分配和释放，尽量增加操作的复杂性最终检测函数执行正常。其中，为了检测伙伴系统的功能，我们特别申请了大小为8的空间，然后释放首端的两页，再释放第4位的一页，这样缓慢申请与释放，对伙伴系统的功能进行检测，如下：

```
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
```

这样，我们就得到了多级链表的高效的伙伴系统。

**核心模块说明**：
1. **空闲区管理 (`free_area_t free_area[MAX_ORDER]`)**  
   - 每个阶（order）对应一个空闲链表  
   - 存储该阶的空闲块数量  

2. **页面描述符 (`struct Page`)**  
   - 记录每个物理页的状态：`flags`, `property`, `ref`  
   - `property` 标记该页属于的块大小（阶数）  

3. **最大阶数 (`MAX_ORDER`)**  
   - 控制系统支持的最大块大小  
   - 2^10 页 = 4MB，可根据系统需求调整  

### 二.硬件的可用物理内存范围的获取方法
#### 1.通过 BIOS 或 UEFI 获取内存信息
在系统启动过程中，操作系统可以通过与系统固件如常见的 BIOS 或者是 OPENSBI 进行交互，获的可用的物理内存信息。这通常是在通电以后在引导加载程序阶段完成的。具体来说的话就是操作系统可以使用 BIOS 中断 INT 0x15，特别是函数 E820h，来获取内存布局。此调用返回内存范围列表，包括可用的、保留的以及其他特定用途的内存区域。
#### 2.使用内存映射寄存器
操作系统可以通过读取内存映射寄存器来获取内存信息。它是由固件生成的，包含有关系统硬件、内存布局等的信息。具体来说的话操作系统可以读取内存映射寄存器中的 SRAT 或 SPCR 表。这些表提供关于内存范围的描述，以及内存是可用的还是用于其他目的。
#### 3.内存探测
操作系统页可以通过直接访问物理内存地址并进行读写测试来探测可用的物理内存范围。但这种方法通常不是首选，因为它可能不够准确，而且效率会很低，并且有可能会与硬件保留的内存区域冲突。具体来说的话就是操作系统可以尝试逐页写入某个物理地址并观察是否会导致页面错误或崩溃，以此确定物理内存的最大范围。
#### 4.通过虚拟化层获取内存信息
如果操作系统运行在虚拟化环境下，如 KVM、VMware、Xen 等 上，它可以通过接口，如 VMware Tools、XenStore 等来获取虚拟机的内存配置信息。虚拟化层通常会告知虚拟机操作系统它能够使用的物理内存范围。
## 总结
### 工作内容汇总
- 对first-fit算法进行分析，理解了物理内存分配的基本流程，探讨了first-fit算法的改进空间
- 基于first-fit框架实现了best-fit算法，实现了按物理地址排序的分配、释放机制，并在改进处完成了按块大小排序的算法实现
- 实现了按地址排序和根据阶使用多级链表的伙伴系统，实现高效的分割合并算法，重点解决了伙伴块的识别和合并问题，完成设计文档，并设计了较为全面的测试用例进行验证
### 心得体会
- 一个算法的上限很大程度上是由它的结构决定的，按物理排序、按块排序、多级链表三种方法之间的差距不是延迟合并等小策略就可以弥补的
- 虽然物理地址排序代表的first-fit整体效率不高，但是根据它的实现逻辑去设计伙伴系统等更高效的方法也是可以的，物理地址空间上的连续为合并等地址敏感的操作也是很利好的，是有借鉴之处的
- 初始化satp的时候整个设计真的很精妙，假设的虚拟地址刚刚好是0xffffffffc00000000，在划分之后12+9+9=30，而前34位都是1，那么内核虚拟地址翻译的时候刚好会根据PPN[2]进行一次定义映射到第511位，然后使用单独的大页映射，很完美的对为内存管理设置了一个最初的跳板
### 本实验中重要的知识点
- 虚实地址转换机制。课堂中讲授的对物理地址的处理是32位的，在这种情况下，32位被拆分成了10+10+12，其中12是页内偏移量，两个10是指向的是目标页表项在二级页表和一级页表的偏移量。同时，1页的大小仍然为4K，因此就一页就可以存储1024个页表项，所能支持的空间是10*4K。而在实验中，是对64位地址进行操作的，其物理地址划分为25+9+9+9+12，前25位保留，这里使用了一个三级页表，因为一个4K的页中只能存放512个页表项了，因此每一级的PPN大小占用位为9。在实际操作系统中，页表项结构可以达到5级以上。
- satp寄存器结构。satp寄存器的低44位用来存储三级PPN，高四位对翻译机制进行选择，剩余16位属于ASID。
- 页表项结构。课堂讲授32位页表项，划分为了10+10+12，两个10代表两级PPN，标志位放在最后12位中，而实验中的页表项结构更为细致，因为物理内存是56位的，其中有12位偏移量，因此需要44位来存储页表的“序号”，尽管虚拟内存的设计决定了它只需要27位来表示这个序号。实验中的页表项前10位用来保留，后10位为标志位，中间44位用来存储三级PPN。
- 快表TLB。组成原理中已经学习过，相较于CPU而言，访存操作是非常非常慢的，而想要提高访存速度，就要利用空间局部性，也就是快表TLB。虽然实验没有实现TLB，但是原理中提到过，想要提高访存速度，就要选择一些策略去维护这样的一个类似于cache命中的快表，使用LRU算法、时钟周期算法等策略来维护。
- 以块为基准的内存管控。虽然在OS的课程中一直在对页表进行研究，但是真正访问数据、申请空间的时候，是以块为单位的。实际上，使用多级链表实现内存管理系统时，除了各个阶的块，还有一个零号空表，用来存储最大的一批块。
- 链表结构体。可以利用在结构体内的一个双向链表结构，实现对结构体的链接。同时，结构体内的各变量是顺序存储排布在一片连续内存中的，因此可以利用这样的链表结构去获得结构体的地址信息。
- 一些页面分配算法。最简单的分配算法first-fit在分配时返回第一个遇到的满足要求的块；best-fit在分配时返回整个链表中大小最合适的块；buddy_system则是可以有效管理分配后的碎片，提高内存的分配能力。
- 一些OS原理中重要但是实验未涉及的知识点：虚拟内存的维护、内存保护机制的设计、页面置换算法、工作集等内容。