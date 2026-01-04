# Lab8 文件系统 实验报告
**小组成员：丛方昊_2310682、钱展飞_2312479、李泽昊_2312594**

## 任务管理
- 练习0：填写已有实验
本实验依赖实验2/3/4/5/6/7。请把你做的实验2/3/4/5/6/7的代码填入本实验中代码中有“LAB2”/“LAB3”/“LAB4”/“LAB5”/“LAB6” /“LAB7”的注释相应部分。并确保编译通过。注意：为了能够正确执行lab8的测试应用程序，可能需对已完成的实验2/3/4/5/6/7的代码进行进一步改进。

- 练习1: 完成读文件操作的实现（需要编码）
首先了解打开文件的处理流程，然后参考本实验后续的文件读写操作的过程分析，填写在 kern/fs/sfs/sfs_inode.c中 的sfs_io_nolock()函数，实现读文件中数据的代码。

- 练习2: 完成基于文件系统的执行程序机制的实现（需要编码）
改写proc.c中的load_icode函数和其他相关函数，实现基于文件系统的执行程序机制。执行：make qemu。如果能看看到sh用户程序的执行界面，则基本成功了。如果在sh用户界面上可以执行exit, hello（更多用户程序放在user目录下）等其他放置在sfs文件系统中的其他执行程序，则可以认为本实验基本成功。

- 扩展练习 Challenge1：完成基于“UNIX的PIPE机制”的设计方案
如果要在ucore里加入UNIX的管道（Pipe）机制，至少需要定义哪些数据结构和接口？（接口给出语义即可，不必具体实现。数据结构的设计应当给出一个（或多个）具体的C语言struct定义。在网络上查找相关的Linux资料和实现，请在实验报告中给出设计实现”UNIX的PIPE机制“的概要设方案，你的设计应当体现出对可能出现的同步互斥问题的处理。）

- 扩展练习 Challenge2：完成基于“UNIX的软连接和硬连接机制”的设计方案
如果要在ucore里加入UNIX的软连接和硬连接机制，至少需要定义哪些数据结构和接口？（接口给出语义即可，不必具体实现。数据结构的设计应当给出一个（或多个）具体的C语言struct定义。在网络上查找相关的Linux资料和实现，请在实验报告中给出设计实现”UNIX的软连接和硬连接机制“的概要设方案，你的设计应当体现出对可能出现的同步互斥问题的处理。）

练习1: 完成读文件操作的实现
1. 实验目的
理解 uCore 文件系统中文件读写操作的实现原理，通过填写 sfs_io_nolock() 函数，完成对文件数据的读取功能。

2. 设计思路
在 SFS 文件系统中，文件数据以块（block）为单位存储。读取文件时需要考虑三种情况：
首块不对齐：	offset 不在块边界，需读取首块部分数据	(sfs_buf_op)
中间完整块：	读取若干完整的数据块	(sfs_block_op)
尾块不对齐：	endpos 不在块边界，需读取尾块部分数据	(sfs_buf_op)
3. 代码实现
// (1) 处理首块：如果 offset 不与块边界对齐
blkoff = offset % SFS_BLKSIZE;
if (blkoff != 0) {
    // 计算首块需要读取的大小
    size = (nblks != 0) ? (SFS_BLKSIZE - blkoff) : (endpos - offset);
    // 获取逻辑块号对应的物理块号
    if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
        goto out;
    }
    // 读取部分块数据
    if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
        goto out;
    }
    alen += size;
    if ((offset += size) == endpos) {
        goto out;
    }
    buf = (char *)buf + size;
    blkno++;
    nblks = endpos / SFS_BLKSIZE - blkno;
}

// (2) 处理中间对齐的完整块
while (nblks > 0) {
    // 获取逻辑块号对应的物理块号
    if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
        goto out;
    }
    // 读取整块数据
    if ((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
        goto out;
    }
    alen += SFS_BLKSIZE;
    offset += SFS_BLKSIZE;
    if (offset == endpos) {
        goto out;
    }
    buf = (char *)buf + SFS_BLKSIZE;
    blkno++;
    nblks--;
}

// (3) 处理尾块：如果结束位置不与块边界对齐
blkoff = endpos % SFS_BLKSIZE;
if (blkoff != 0) {
    size = blkoff;
    // 获取逻辑块号对应的物理块号
    if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
        goto out;
    }
    // 读取部分块数据（从块起始位置开始）
    if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
        goto out;
    }
    alen += size;
}
4. 关键函数说明
sfs_bmap_load_nolock(sfs, sin, blkno, &ino)：将文件的逻辑块号 blkno 转换为磁盘物理块号 ino
sfs_buf_op(sfs, buf, size, ino, offset)：对部分块进行读写操作，读取 ino 块中从 offset 开始的 size 字节
sfs_block_op(sfs, buf, ino, nblks)：对完整块进行读写操作，读取从 ino 开始的 nblks 个块
5. 变量说明
offset：读取的起始位置（字节偏移）
endpos：读取的结束位置
blkno：当前处理的逻辑块号
blkoff：块内偏移
nblks：剩余需要处理的完整块数
ino：物理块号
size：当前操作的数据大小
alen：实际读取的总字节数
6. 实验结果
编译并运行 uCore，执行 make grade 验证实验结果正确。

7. 问题回答：UNIX的PIPE机制概要设计方案
数据结构设计：
创建环形缓冲区作为管道数据存储
维护读写指针和数据计数器
添加读写等待队列

创建管道：
分配内核缓冲区
创建两个文件描述符（读端和写端）
初始化同步机制（信号量/条件变量）

读写操作：
写操作：若缓冲区满则阻塞，否则写入数据并唤醒读者
读操作：若缓冲区空则阻塞，否则读取数据并唤醒写者

关闭管道：
关闭读端：唤醒所有等待的写者，返回错误
关闭写端：唤醒所有等待的读者，返回 EOF

练习2: 完成基于文件系统的执行程序机制的实现
1. 实验目的
改写 proc.c 中的 load_icode 函数，实现基于文件系统的执行程序机制，使得用户程序可以从文件系统中加载并执行。

2. 设计思路
与 LAB5 不同，LAB8 中的 load_icode 需要从文件系统中读取 ELF 文件，而不是从内存中直接获取。主要步骤如下：

步骤	描述
1	创建新的内存管理结构 mm
2	创建页目录表 PDT
3	从文件读取 ELF 头和程序段，加载到内存
4	建立用户栈
5	设置当前进程的 mm 和页目录
6	在用户栈中设置 argc 和 argv
7	设置 trapframe 以便返回用户态
3. 代码实现
static int
load_icode(int fd, int argc, char **kargv)
{
    /* LAB8:EXERCISE2 2312479 */
    
    if (current->mm != NULL)
    {
        panic("load_icode: current->mm must be empty.\n");
    }

    int ret = -E_NO_MEM;
    struct mm_struct *mm = NULL;
    struct Page *page = NULL;
    struct elfhdr elf;
    struct proghdr ph;

    // (1) create a new mm for current process
    if ((mm = mm_create()) == NULL)
    {
        goto bad_mm;
    }
    
    // (2) create a new PDT
    if (setup_pgdir(mm) != 0)
    {
        goto bad_pgdir_cleanup_mm;
    }

    // (3.1) read elf header from file
    if ((ret = load_icode_read(fd, &elf, sizeof(elf), 0)) != 0)
    {
        goto bad_elf_cleanup_pgdir;
    }
    if (elf.e_magic != ELF_MAGIC)
    {
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }

    // (3.2) read program headers and load segments
    uint32_t vm_flags, perm;
    int i;
    for (i = 0; i < elf.e_phnum; i++)
    {
        // read program header
        off_t phoff = elf.e_phoff + i * sizeof(struct proghdr);
        if ((ret = load_icode_read(fd, &ph, sizeof(ph), phoff)) != 0)
        {
            goto bad_cleanup_mmap;
        }
        if (ph.p_type != ELF_PT_LOAD)
        {
            continue;
        }
        if (ph.p_filesz > ph.p_memsz)
        {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }

        // setup vm_flags and permissions
        vm_flags = 0, perm = PTE_U | PTE_V;
        if (ph.p_flags & ELF_PF_X)
            vm_flags |= VM_EXEC;
        if (ph.p_flags & ELF_PF_W)
            vm_flags |= VM_WRITE;
        if (ph.p_flags & ELF_PF_R)
            vm_flags |= VM_READ;
        if (vm_flags & VM_READ)
            perm |= PTE_R;
        if (vm_flags & VM_WRITE)
            perm |= (PTE_W | PTE_R);
        if (vm_flags & VM_EXEC)
            perm |= PTE_X;

        // (3.3) call mm_map to build vma
        if ((ret = mm_map(mm, ph.p_va, ph.p_memsz, vm_flags, NULL)) != 0)
        {
            goto bad_cleanup_mmap;
        }

        // (3.4) allocate pages and copy TEXT/DATA from file
        size_t off, size;
        uintptr_t start = ph.p_va, end, la = ROUNDDOWN(start, PGSIZE);
        off_t file_off = ph.p_offset;
        ret = -E_NO_MEM;

        end = ph.p_va + ph.p_filesz;
        while (start < end)
        {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
            {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la)
            {
                size -= la - end;
            }
            if ((ret = load_icode_read(fd, page2kva(page) + off, size, file_off + (start - ph.p_va))) != 0)
            {
                goto bad_cleanup_mmap;
            }
            start += size;
        }

        // (3.5) build BSS section and memset zero
        end = ph.p_va + ph.p_memsz;
        if (start < la)
        {
            if (start == end)
            {
                continue;
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
            if (end < la)
            {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end)
        {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
            {
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
            if (end < la)
            {
                size -= la - end;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }

    // (4) setup user stack
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
    {
        goto bad_cleanup_mmap;
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);

    // (5) set current process's mm and pgdir
    mm_count_inc(mm);
    current->mm = mm;
    current->pgdir = PADDR(mm->pgdir);
    lsatp(PADDR(mm->pgdir));

    // (6) setup argc/argv on user stack
    uintptr_t sp = USTACKTOP;
    uintptr_t uargv[EXEC_MAX_ARG_NUM + 1];
    for (i = argc - 1; i >= 0; i--)
    {
        size_t len = strlen(kargv[i]) + 1;
        sp -= len;
        sp = ROUNDDOWN(sp, sizeof(uintptr_t));
        if (!copy_to_user(mm, (void *)sp, kargv[i], len))
        {
            ret = -E_INVAL;
            goto bad_cleanup_mmap;
        }
        uargv[i] = sp;
    }
    uargv[argc] = 0;

    sp -= (argc + 1) * sizeof(uintptr_t);
    sp = ROUNDDOWN(sp, sizeof(uintptr_t));
    uintptr_t uargv_ptr = sp;
    if (!copy_to_user(mm, (void *)uargv_ptr, uargv, (argc + 1) * sizeof(uintptr_t)))
    {
        ret = -E_INVAL;
        goto bad_cleanup_mmap;
    }

    // (7) setup trapframe for user environment
    struct trapframe *tf = current->tf;
    uintptr_t sstatus = tf->status;
    memset(tf, 0, sizeof(struct trapframe));
    tf->gpr.sp = sp;
    tf->gpr.a0 = argc;
    tf->gpr.a1 = uargv_ptr;
    tf->epc = elf.e_entry;
    tf->status = (sstatus & ~SSTATUS_SPP) | SSTATUS_SPIE;

    sysfile_close(fd);
    ret = 0;
    return ret;

bad_cleanup_mmap:
    sysfile_close(fd);
    exit_mmap(mm);
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    return ret;
}
4. 与LAB5的主要区别
对比项	          LAB5	                LAB8
数据来源	内存中的二进制数据	    文件系统中的ELF文件
读取方式       直接内存拷贝	   通过 load_icode_read 读取文件
参数传递	      无参数	       需要设置 argc/argv
文件描述符	        无	         需要处理 fd 的打开和关闭
5. 关键函数说明
mm_create()：创建进程的内存管理结构
setup_pgdir(mm)：创建页目录表
load_icode_read(fd, buf, len, offset)：从文件中读取数据
mm_map(mm, addr, len, flags, NULL)：建立虚拟内存映射
pgdir_alloc_page(pgdir, la, perm)：分配物理页并建立映射
copy_to_user(mm, dst, src, len)：将数据拷贝到用户空间
6. 用户栈参数布局
用户栈中参数的布局如下（从高地址到低地址）：
USTACKTOP：栈顶
argv[0], argv[1], ...：参数字符串
uargv[0], uargv[1], ..., NULL：参数指针数组
sp：最终栈指针位置
trapframe 中的寄存器设置：
a0 = argc：参数个数
a1 = uargv_ptr：参数数组指针
sp：用户栈指针
epc：程序入口地址
7. 实验结果
执行 make qemu 后，可以看到 sh 用户程序的执行界面，在 sh 中可以执行 hello、exit 等用户程序，说明基于文件系统的执行程序机制实现成功。

扩展练习 Challenge1：完成基于"UNIX的PIPE机制"的设计方案
1. PIPE机制概述
管道（Pipe）是UNIX系统中最古老的进程间通信机制，它提供了一个单向的数据流通道，一个进程向管道写入数据，另一个进程从管道读取数据。管道具有以下特点：

单向通信：数据只能从写端流向读端
基于文件描述符：使用标准的read/write接口
有限缓冲区：当缓冲区满时写者阻塞，缓冲区空时读者阻塞
同步机制：自动处理读写同步问题
2. 数据结构设计
2.1 管道核心结构体
#define PIPE_BUF_SIZE 4096  // 管道缓冲区大小

// 管道结构体
struct pipe_struct {
    char buffer[PIPE_BUF_SIZE];     // 环形缓冲区
    uint32_t read_pos;               // 读指针位置
    uint32_t write_pos;              // 写指针位置
    uint32_t data_size;              // 当前缓冲区中的数据量
    
    int read_open;                   // 读端是否打开 (1: 打开, 0: 关闭)
    int write_open;                  // 写端是否打开 (1: 打开, 0: 关闭)
    
    // 同步互斥相关
    semaphore_t mutex;               // 互斥信号量，保护管道数据结构
    semaphore_t read_sem;            // 读信号量，用于读者等待数据
    semaphore_t write_sem;           // 写信号量，用于写者等待空间
    
    wait_queue_t read_queue;         // 读等待队列
    wait_queue_t write_queue;        // 写等待队列
    
    int ref_count;                   // 引用计数
};
2.2 管道文件结构体
// 管道文件类型定义
#define FILE_TYPE_PIPE_READ  3       // 管道读端
#define FILE_TYPE_PIPE_WRITE 4       // 管道写端

// 管道文件结构体（扩展现有的file结构体）
struct pipe_file {
    struct file base;                // 基础文件结构
    struct pipe_struct *pipe;        // 指向管道结构
    int pipe_type;                   // PIPE_READ 或 PIPE_WRITE
};

// 或者在现有file结构体中添加字段
struct file {
    enum {
        FD_NONE,
        FD_INODE,
        FD_PIPE_READ,                // 新增：管道读端
        FD_PIPE_WRITE,               // 新增：管道写端
    } type;
    int ref;
    bool readable;
    bool writable;
    struct inode *node;              // 用于普通文件
    struct pipe_struct *pipe;        // 用于管道文件
    off_t pos;
};
2.3 管道inode结构体（可选方案）
// 将管道作为一种特殊的inode类型
struct pipe_inode {
    struct inode base;               // 基础inode结构
    struct pipe_struct pipe_data;    // 管道数据
};

// 在inode类型中添加管道类型
#define SFS_TYPE_PIPE 4              // 管道类型标识
3. 接口设计
3.1 管道创建接口
int pipe(int fd[2]);
int pipe_create(struct file **read_file, struct file **write_file);
3.2 管道读取接口
ssize_t pipe_read(struct pipe_struct *pipe, void *buf, size_t count);
3.3 管道写入接口
ssize_t pipe_write(struct pipe_struct *pipe, const void *buf, size_t count);
3.4 管道关闭接口
int pipe_close(struct pipe_struct *pipe, int is_write_end);
void pipe_release(struct pipe_struct *pipe);
3.5 管道状态查询接口
int pipe_poll(struct pipe_struct *pipe, int is_write_end);
int pipe_ioctl(struct pipe_struct *pipe, int cmd, unsigned long arg);
4. 同步互斥问题处理
4.1 互斥访问
// 使用互斥锁保护管道数据结构的访问
void pipe_lock(struct pipe_struct *pipe) {
    down(&pipe->mutex);
}
void pipe_unlock(struct pipe_struct *pipe) {
    up(&pipe->mutex);
}
4.2 读写同步（生产者-消费者模型）
// 读操作的同步处理
ssize_t pipe_read(struct pipe_struct *pipe, void *buf, size_t count) {
    pipe_lock(pipe);
    
    // 等待数据可用
    while (pipe->data_size == 0) {
        if (!pipe->write_open) {
            // 写端已关闭，返回EOF
            pipe_unlock(pipe);
            return 0;
        }
        // 释放锁并等待
        pipe_unlock(pipe);
        down(&pipe->read_sem);  // 阻塞等待数据
        pipe_lock(pipe);
    }
    
    // 读取数据
    size_t bytes_read = min(count, pipe->data_size);
    // ... 从buffer中读取数据 ...
    
    // 唤醒可能等待的写者
    if (pipe->data_size < PIPE_BUF_SIZE) {
        up(&pipe->write_sem);
    }
    
    pipe_unlock(pipe);
    return bytes_read;
}

// 写操作的同步处理
ssize_t pipe_write(struct pipe_struct *pipe, const void *buf, size_t count) {
    pipe_lock(pipe);
    
    // 检查读端是否关闭
    if (!pipe->read_open) {
        pipe_unlock(pipe);
        return -E_PIPE;  // 返回EPIPE错误
    }
    
    // 等待空间可用
    while (pipe->data_size == PIPE_BUF_SIZE) {
        if (!pipe->read_open) {
            pipe_unlock(pipe);
            return -E_PIPE;
        }
        pipe_unlock(pipe);
        down(&pipe->write_sem);  // 阻塞等待空间
        pipe_lock(pipe);
    }
    
    // 写入数据
    size_t bytes_written = min(count, PIPE_BUF_SIZE - pipe->data_size);
    // ... 向buffer中写入数据 ...
    
    // 唤醒可能等待的读者
    if (pipe->data_size > 0) {
        up(&pipe->read_sem);
    }
    
    pipe_unlock(pipe);
    return bytes_written;
}
4.3 原子性保证
// 保证小于PIPE_BUF的写入是原子的
ssize_t pipe_write_atomic(struct pipe_struct *pipe, const void *buf, size_t count) {
    if (count <= PIPE_BUF_SIZE) {
        pipe_lock(pipe);
        
        // 等待足够的空间（原子写入需要一次性写完）
        while (PIPE_BUF_SIZE - pipe->data_size < count) {
            if (!pipe->read_open) {
                pipe_unlock(pipe);
                return -E_PIPE;
            }
            pipe_unlock(pipe);
            down(&pipe->write_sem);
            pipe_lock(pipe);
        }
        
        pipe_unlock(pipe);
    } else {
        // 大于PIPE_BUF的写入可能被分割
        // 使用普通写入方式
    }
}
4.4 关闭时的同步处理
int pipe_close(struct pipe_struct *pipe, int is_write_end) {
    pipe_lock(pipe);
    
    if (is_write_end) {
        pipe->write_open = 0;
        // 唤醒所有等待读取的进程（让它们检测到EOF）
        wakeup_all(&pipe->read_queue);
    } else {
        pipe->read_open = 0;
        // 唤醒所有等待写入的进程（让它们检测到EPIPE）
        wakeup_all(&pipe->write_queue);
    }
    
    pipe->ref_count--;
    
    if (pipe->ref_count == 0) {
        // 两端都已关闭，释放资源
        pipe_unlock(pipe);
        pipe_release(pipe);
        return 0;
    }
    
    pipe_unlock(pipe);
    return 0;
}
5. 系统调用集成
// 在syscall.c中添加管道相关系统调用
static int sys_pipe(uint64_t arg[]) {
    int *fd = (int *)arg[0];
    return do_pipe(fd);
}

// 在sysfile.c中实现do_pipe
int do_pipe(int fd[2]) {
    struct file *read_file, *write_file;
    int ret;
    
    // 创建管道
    if ((ret = pipe_create(&read_file, &write_file)) != 0) {
        return ret;
    }
    
    // 分配文件描述符
    int read_fd = fdalloc(read_file);
    int write_fd = fdalloc(write_file);
    
    if (read_fd < 0 || write_fd < 0) {
        pipe_release(read_file->pipe);
        return -E_NFILE;
    }
    
    fd[0] = read_fd;
    fd[1] = write_fd;
    return 0;
}


扩展练习 Challenge2：完成基于"UNIX的软连接和硬连接机制"的设计方案
1. 链接机制概述
1.1 硬链接
硬链接是指多个目录项（文件名）指向同一个inode。特点：
所有硬链接地位平等，没有"原始文件"和"链接"的区别
不能跨文件系统
不能链接目录（防止循环）
删除一个链接不影响其他链接，直到链接计数为0才删除文件
1.2 软链接（
软链接是一个特殊的文件，其内容是目标文件的路径名。特点：
可以跨文件系统
可以链接目录
如果目标被删除，软链接成为"悬空链接"
有自己独立的inode
2. 数据结构设计
2.1 扩展的inode结构
// 文件类型定义（扩展现有类型）
#define SFS_TYPE_FILE   1    // 普通文件
#define SFS_TYPE_DIR    2    // 目录
#define SFS_TYPE_LINK   3    // 软链接（符号链接）

// 扩展的磁盘inode结构
struct sfs_disk_inode {
    uint32_t size;                      // 文件大小
    uint16_t type;                      // 文件类型 (SFS_TYPE_FILE/DIR/LINK)
    uint16_t nlinks;                    // 硬链接计数
    uint32_t blocks;                    // 使用的数据块数
    uint32_t direct[SFS_NDIRECT];       // 直接块索引
    uint32_t indirect;                  // 间接块索引
    // 对于软链接，数据块中存储目标路径
};

// 内存中的inode结构（扩展）
struct sfs_inode {
    struct sfs_disk_inode *din;         // 磁盘inode指针
    uint32_t ino;                       // inode编号
    bool dirty;                         // 是否被修改
    int reclaim_count;                  // 回收计数
    semaphore_t sem;                    // inode信号量
    // 链接相关字段
    char *symlink_target;               // 软链接目标路径（缓存）
};
2.2 软链接专用结构
#define MAX_SYMLINK_LEN 1024             // 软链接最大路径长度
#define MAX_SYMLINK_DEPTH 8              // 软链接解析最大深度（防止循环）

// 软链接inode结构
struct sfs_symlink_inode {
    struct sfs_disk_inode base;          // 基础inode结构
    // type = SFS_TYPE_LINK
    // size = 目标路径字符串长度
    // 数据块中存储目标路径字符串
};

// 软链接解析上下文
struct symlink_context {
    int depth;                           // 当前解析深度
    char resolved_path[MAX_PATH_LEN];    // 解析后的路径
    struct inode *current_dir;           // 当前目录inode
};
2.3 目录项结构

// 目录项结构（现有结构，无需修改）
struct sfs_disk_entry {
    uint32_t ino;                        // inode编号
    char name[SFS_MAX_FNAME_LEN + 1];    // 文件名
};

// 硬链接本质上就是多个目录项指向同一个ino
// 软链接是一个独立的目录项，指向类型为SFS_TYPE_LINK的inode
2.4 链接操作锁结构

// 用于保护链接操作的锁结构
struct link_lock {
    semaphore_t inode_lock;              // inode级别的锁
    semaphore_t dir_lock;                // 目录级别的锁
    semaphore_t nlinks_lock;             // 链接计数的锁
};

// 全局符号链接解析锁（防止竞态条件）
struct symlink_resolve_lock {
    semaphore_t resolve_sem;             // 解析信号量
    int active_resolves;                 // 当前活跃的解析数
};
3. 接口设计
3.1 硬链接接口
int sfs_link(const char *old_path, const char *new_path);
int do_link(const char *old_path, const char *new_path);
3.2 软链接接口
int sfs_symlink(const char *target, const char *link_path);
int do_symlink(const char *target, const char *link_path);
3.3 读取软链接接口
ssize_t sfs_readlink(const char *path, char *buf, size_t size);
ssize_t do_readlink(const char *path, char *buf, size_t size);
3.4 删除链接接口
int sfs_unlink(const char *path);
int do_unlink(const char *path);
3.5 路径解析接口（支持软链接）
int sfs_resolve_path(const char *path, char *resolved, bool follow_final);
int sfs_namei(const char *path, bool follow, struct inode **inode);
3.6 链接状态查询接口
int sfs_lstat(const char *path, struct stat *stat);
int sfs_stat(const char *path, struct stat *stat);
4. 同步互斥问题处理
4.1 硬链接的同步处理
int sfs_link(const char *old_path, const char *new_path) {
    struct inode *src_inode = NULL;
    struct inode *parent_inode = NULL;
    int ret;
    
    // 获取源inode并加锁
    if ((ret = sfs_namei(old_path, true, &src_inode)) != 0) {
        return ret;
    }
    
    down(&src_inode->sem);  // 锁定源inode
    
    // 检查是否为目录
    if (src_inode->type == SFS_TYPE_DIR) {
        up(&src_inode->sem);
        inode_put(src_inode);
        return -E_ISDIR;
    }
    
    // 获取目标父目录并加锁
    char parent_path[MAX_PATH_LEN];
    char name[SFS_MAX_FNAME_LEN + 1];
    split_path(new_path, parent_path, name);
    
    if ((ret = sfs_namei(parent_path, true, &parent_inode)) != 0) {
        up(&src_inode->sem);
        inode_put(src_inode);
        return ret;
    }
    
    down(&parent_inode->sem);  // 锁定父目录
    
    // 检查目标是否已存在
    struct inode *existing = NULL;
    if (sfs_lookup(parent_inode, name, &existing) == 0) {
        inode_put(existing);
        ret = -E_EXISTS;
        goto out;
    }
    
    // 原子性地增加链接计数并创建目录项
    src_inode->din->nlinks++;
    src_inode->dirty = true;
    
    if ((ret = sfs_create_entry(parent_inode, name, src_inode->ino)) != 0) {
        src_inode->din->nlinks--;  // 回滚
        goto out;
    }
    
    ret = 0;
    
out:
    up(&parent_inode->sem);
    up(&src_inode->sem);
    inode_put(parent_inode);
    inode_put(src_inode);
    return ret;
}
4.2 软链接的同步处理
int sfs_symlink(const char *target, const char *link_path) {
    struct inode *parent_inode = NULL;
    struct inode *link_inode = NULL;
    int ret;
    
    // 检查目标路径长度
    if (strlen(target) >= MAX_SYMLINK_LEN) {
        return -E_NAMETOOLONG;
    }
    
    // 获取父目录
    char parent_path[MAX_PATH_LEN];
    char name[SFS_MAX_FNAME_LEN + 1];
    split_path(link_path, parent_path, name);
    
    if ((ret = sfs_namei(parent_path, true, &parent_inode)) != 0) {
        return ret;
    }
    
    down(&parent_inode->sem);  // 锁定父目录
    
    // 检查是否已存在
    struct inode *existing = NULL;
    if (sfs_lookup(parent_inode, name, &existing) == 0) {
        inode_put(existing);
        up(&parent_inode->sem);
        inode_put(parent_inode);
        return -E_EXISTS;
    }
    
    // 分配新的inode（类型为软链接）
    if ((ret = sfs_alloc_inode(SFS_TYPE_LINK, &link_inode)) != 0) {
        up(&parent_inode->sem);
        inode_put(parent_inode);
        return ret;
    }
    
    down(&link_inode->sem);  // 锁定新inode
    
    // 写入目标路径
    size_t target_len = strlen(target);
    if ((ret = sfs_write_symlink(link_inode, target, target_len)) != 0) {
        up(&link_inode->sem);
        sfs_free_inode(link_inode);
        up(&parent_inode->sem);
        inode_put(parent_inode);
        return ret;
    }
    
    // 创建目录项
    if ((ret = sfs_create_entry(parent_inode, name, link_inode->ino)) != 0) {
        up(&link_inode->sem);
        sfs_free_inode(link_inode);
        up(&parent_inode->sem);
        inode_put(parent_inode);
        return ret;
    }
    
    up(&link_inode->sem);
    up(&parent_inode->sem);
    inode_put(link_inode);
    inode_put(parent_inode);
    
    return 0;
}
4.3 软链接解析的同步处理（防止循环）
int sfs_resolve_symlink(const char *path, char *resolved, int depth) {
    struct inode *inode = NULL;
    int ret;
    
    // 检查递归深度，防止循环
    if (depth >= MAX_SYMLINK_DEPTH) {
        return -E_LOOP;
    }
    
    // 获取inode（不跟随最后的软链接）
    if ((ret = sfs_namei(path, false, &inode)) != 0) {
        return ret;
    }
    
    down(&inode->sem);  // 锁定inode
    
    // 检查是否为软链接
    if (inode->din->type != SFS_TYPE_LINK) {
        // 不是软链接，直接返回原路径
        strcpy(resolved, path);
        up(&inode->sem);
        inode_put(inode);
        return 0;
    }
    
    // 读取软链接目标
    char target[MAX_SYMLINK_LEN];
    if ((ret = sfs_read_symlink(inode, target, MAX_SYMLINK_LEN)) < 0) {
        up(&inode->sem);
        inode_put(inode);
        return ret;
    }
    
    up(&inode->sem);
    inode_put(inode);
    
    // 处理相对路径和绝对路径
    char new_path[MAX_PATH_LEN];
    if (target[0] == '/') {
        // 绝对路径
        strcpy(new_path, target);
    } else {
        // 相对路径，基于软链接所在目录
        char dir[MAX_PATH_LEN];
        get_parent_dir(path, dir);
        snprintf(new_path, MAX_PATH_LEN, "%s/%s", dir, target);
    }
    
    // 递归解析
    return sfs_resolve_symlink(new_path, resolved, depth + 1);
}
4.4 unlink操作的同步处理
int sfs_unlink(const char *path) {
    struct inode *inode = NULL;
    struct inode *parent = NULL;
    int ret;
    
    // 获取文件inode和父目录
    char parent_path[MAX_PATH_LEN];
    char name[SFS_MAX_FNAME_LEN + 1];
    split_path(path, parent_path, name);
    
    if ((ret = sfs_namei(path, false, &inode)) != 0) {
        return ret;
    }
    
    if ((ret = sfs_namei(parent_path, true, &parent)) != 0) {
        inode_put(inode);
        return ret;
    }
    
    // 按照固定顺序加锁，避免死锁（先父目录，后文件）
    if (parent->ino < inode->ino) {
        down(&parent->sem);
        down(&inode->sem);
    } else {
        down(&inode->sem);
        down(&parent->sem);
    }
    
    // 检查是否为目录
    if (inode->din->type == SFS_TYPE_DIR) {
        ret = -E_ISDIR;
        goto out;
    }
    
    // 删除目录项
    if ((ret = sfs_remove_entry(parent, name)) != 0) {
        goto out;
    }
    
    // 减少链接计数
    inode->din->nlinks--;
    inode->dirty = true;
    
    // 如果链接计数为0，标记inode可回收
    if (inode->din->nlinks == 0) {
        // 实际释放延迟到所有文件描述符关闭
        inode->reclaim_count++;
    }
    
    ret = 0;
    
out:
    up(&inode->sem);
    up(&parent->sem);
    inode_put(inode);
    inode_put(parent);
    return ret;
}
4.5 链接计数的原子操作

// 原子增加链接计数
static inline void nlinks_inc(struct sfs_disk_inode *din, semaphore_t *lock) {
    down(lock);
    din->nlinks++;
    up(lock);
}

// 原子减少链接计数，返回减少后的值
static inline uint16_t nlinks_dec(struct sfs_disk_inode *din, semaphore_t *lock) {
    uint16_t val;
    down(lock);
    val = --din->nlinks;
    up(lock);
    return val;
}
5. 系统调用集成
C

// 在syscall.c中添加链接相关系统调用
static int sys_link(uint64_t arg[]) {
    const char *old_path = (const char *)arg[0];
    const char *new_path = (const char *)arg[1];
    return do_link(old_path, new_path);
}

static int sys_symlink(uint64_t arg[]) {
    const char *target = (const char *)arg[0];
    const char *link_path = (const char *)arg[1];
    return do_symlink(target, link_path);
}

static int sys_readlink(uint64_t arg[]) {
    const char *path = (const char *)arg[0];
    char *buf = (char *)arg[1];
    size_t size = (size_t)arg[2];
    return do_readlink(path, buf, size);
}

static int sys_unlink(uint64_t arg[]) {
    const char *path = (const char *)arg[0];
    return do_unlink(path);
}

static int sys_lstat(uint64_t arg[]) {
    const char *path = (const char *)arg[0];
    struct stat *stat = (struct stat *)arg[1];
    return do_lstat(path, stat);
}