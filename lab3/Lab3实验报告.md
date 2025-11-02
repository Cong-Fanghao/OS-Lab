# Lab3 物理内存与页表 实验报告
**小组成员：丛方昊_2310682、钱展飞_2312479、李泽昊_2312594**

## 任务描述
- 练习1：完善中断处理 
请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写kern/trap/trap.c函数中处理时钟中断的部分，使操作系统每遇到100次时钟中断后，调用print_ticks子程序，向屏幕上打印一行文字”100 ticks”，在打印完10行后调用sbi.h中的shut_down()函数关机。
要求完成问题1提出的相关函数实现，提交改进后的源代码包（可以编译执行），并在实验报告中简要说明实现过程和定时器中断中断处理的流程。实现要求的部分代码后，运行整个系统，大约每1秒会输出一次”100 ticks”，输出10行。

- 扩展练习 Challenge1：描述与理解中断流程
回答：描述ucore中处理中断异常的流程（从异常的产生开始），其中mov a0，sp的目的是什么？SAVE_ALL中寄寄存器保存在栈中的位置是什么确定的？对于任何中断，__alltraps 中都需要保存所有寄存器吗？请说明理由。

- 扩增练习 Challenge2：理解上下文切换机制
回答：在trapentry.S中汇编代码 csrw sscratch, sp；csrrw s0, sscratch, x0实现了什么操作，目的是什么？save all里面保存了stval scause这些csr，而在restore all里面却不还原它们？那这样store的意义何在呢？

- 扩展练习Challenge3：完善异常中断
编程完善在触发一条非法指令异常和断点异常，在 kern/trap/trap.c的异常处理函数中捕获，并对其进行处理，简单输出异常类型和异常指令触发地址，即“Illegal instruction caught at 0x(地址)”，“ebreak caught at 0x（地址）”与“Exception type:Illegal instruction"，“Exception type: breakpoint”。

## 中断处理
### 中断和异常处理的核心要点：
时钟中断：处理函数必须重新设置下一次中断 (clock_set_next_event())，才能实现周期性。
异常处理：处理函数必须手动修改tf->epc来跳过导致异常的指令，以避免死循环。
指令长度：epc增加的步长取决于导致异常的指令的实际长度

### 时钟中断处理 
目的与作用：
这段代码是操作系统的“心跳”。时钟中断是唯一一个能够周期性地、强制地将CPU控制权从当前运行的任何程序（无论是用户程序
计时：通过ticks++来记录时间的流逝。
任务调度：在更复杂的OS中，时钟中断是实现进程/线程切换（分时复用）的基础。
定时任务：执行需要周期性检查或运行的任务。
```
 clock_set_next_event();
    ticks++;
    if (ticks == TICK_NUM) {
        print_ticks();
        ticks = 0;
        num++;
        if (num == 10) {
            sbi_shutdown();
        }
    }
    break;
```
代码逐行解析
clock_set_next_event();
RISC-V架构中的时钟定时器通常是“一次性”的。也就是说，当你设置一个定时器在未来某个时间点触发中断后，它触发一次就结束了。为了实现周期性的中断，我们必须在每次中断处理的开始，就立即“预约”下一次中断。clock_set_next_event()函数的作用就是通过SBI调用（向更高权限的M-Mode固件发出请求），设置下一次时钟中断的触发时间。如果不调用它，系统将只会收到一次时钟中断，然后就再也没有了。

ticks++;
ticks 是一个全局变量，作为系统的“心跳计数器”。每次时钟中断发生，就意味着一个基本时间单位过去了，所以我们把它加一。

if (ticks == TICK_NUM)
这里的 TICK_NUM 是 100。这个判断语句检查“心跳”是否已经跳了100次。这是一种将多个小的时间单位聚合成一个大的时间单位的常用方法。

print_ticks();
当100次心跳的条件满足时，调用这个函数打印 "100 ticks"。

ticks = 0;
在完成一次100次的计数周期后，必须将 ticks 计数器清零。这样，下一个100次的计数才能从0开始，保证了周期的正确性。

num++; 和 if (num == 10)
num 是另一个计数器，但它计的不是心跳次数，而是 "100 ticks" 这个消息被打印的次数。
根据实验要求，当这个消息打印了10次之后，就触发关机。

sbi_shutdown();
这是一个SBI调用，它请求M-Mode的固件关闭整个系统。这是实验的最终目标。

### 异常处理 
异常与中断不同，它是由CPU执行指令时同步产生的错误或特殊事件。

非法指令异常
```
case CAUSE_ILLEGAL_INSTRUCTION:
    cprintf("Exception type: Illegal instruction\n");
    cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
    tf->epc += 4;   // 跳过非法指令，防止陷入死循环
    break;
```
发生场景：当CPU取到一条指令，但其操作码不是任何一个已定义的合法指令时，就会触发此异常。

代码解析：
cprintf(...)：这两行是诊断信息，告诉开发者发生了什么非法指令以及在哪里发生的。tf->epc寄存器在异常发生时，由硬件自动保存了导致异常的那条指令的地址。打印这个地址对于调试至关重要。
tf->epc += 4;：这是异常处理后能够继续运行的关键。当异常处理函数返回后，CPU会从epc寄存器指向的地址继续执行。如果我们不对epc做任何修改，CPU会再次尝试执行那条非法的指令，然后再次触发异常，陷入一个死循环。
为什么是 +4？ 因为RISC-V的标准指令长度是32位，即4个字节。将epc加4，意味着我们告诉CPU：“跳过这条4字节长的坏指令，从下一条指令开始继续执行吧。”

断点异常
```
case CAUSE_BREAKPOINT:
    cprintf("Exception type: breakpoint\n");
    cprintf("ebreak caught at 0x%08x\n", tf->epc);
    tf->epc += 2;//ebreak是2字节指令
    break;
```
发生场景：当CPU执行到ebreak指令时，会故意触发一个断点异常。这个指令是为调试器设计的。调试器在一个程序的某行设置断点时，实际上就是把那里的原始指令替换成一条ebreak指令。
代码解析：
cprintf(...)：同样是打印诊断信息，报告在tf->epc地址处捕获了一个ebreak指令。
tf->epc += 2;
为什么是 +2？ ebreak指令属于RISC-V的“C”扩展。压缩指令的长度是16位，即2个字节。为了正确地跳过ebreak指令并执行下一条指令，我们必须将程序计数器epc增加2。如果错误地加了4，那么不仅跳过了ebreak，还可能跳过了它后面的另一条合法的2字节压缩指令，导致程序逻辑错误。

### 实验结果
ubuntu@LAPTOP-0JC6F6L3:/mnt/d/大三上/操作系统/homework/OS-Lab/lab3$ make qemu

OpenSBI v0.4 (Jul  2 2019 11:53:53)
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name          : QEMU Virt Machine
Platform HART Features : RV64ACDFIMSU
Platform Max HARTs     : 8
Current Hart           : 0
Firmware Base          : 0x80000000
Firmware Size          : 112 KB
Runtime SBI Version    : 0.1

PMP0: 0x0000000080000000-0x000000008001ffff (A)
PMP1: 0x0000000000000000-0xffffffffffffffff (A,R,W,X)
DTB Init
HartID: 0
DTB Address: 0x82200000
Physical Memory from DTB:
  Base: 0x0000000080000000
  Size: 0x0000000008000000 (128 MB)
  End:  0x0000000087ffffff
DTB init completed
(THU.CST) os is loading ...
Special kernel symbols:
  entry  0xffffffffc0200054 (virtual)
  etext  0xffffffffc0201fac (virtual)
  edata  0xffffffffc0207028 (virtual)
  end    0xffffffffc02074a0 (virtual)
Kernel executable memory footprint: 30KB
physcial memory map:
  memory: 0x0000000008000000, [0x0000000080000000, 0x0000000087ffffff].
check_alloc_page() succeeded!
satp virtual address: 0xffffffffc0206000
satp physical address: 0x0000000080206000
++ setup timer interrupts
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks
100 ticks

## 描述与理解中断流程
中断产生时，CPU自动保存当前寄存器的关键信息，包括：保存PC至sepc，保存原因至scause，保存附加信息到stval，保存特权级到sstatus.SPP，而后切换到S模式，关闭中断，接下来跳转到中断向量表基址开始处理中断，也就是进入到了__alltraps。

首先SAVE_ALL保存所有寄存器，然后使用mov a0, sp。这里sp指向内核栈上的trapframe结构，RISC-V调用约定中，a0寄存器用于传递第一个参数，C函数原型是void trap(struct trapframe *tf)，这样C代码就能访问完整的寄存器状态进行诊断和处理。接下来就是jal trap调用函数。

trap函数使用trap_dispatch分发处理，处理完成后用__trapret:RESTORE_ALL恢复寄存器，最后使用sret恢复PC和特权级。

SAVE_ALL中寄存器保存位置由trapframe结构体定义和trapentry.S中设置的汇编偏移确定，其也必须保存所有寄存器，因为中断可能出现在任何位置，所有寄存器都可能有重要数据，而中断不应该改变被中断程序的任何状态。

## 理解上下文切换机制
csrw sscratch, sp将当前栈指针保存到sscratch寄存器，也就是此时sscratch包含进入陷阱时的栈指针值；csrrw s0, sscratch, x0读取sscratch到s0，同时将x0（0）写入sscratch，结果是s0= 原栈指针，sscratch= 0。这样，就将进入陷阱时的栈指针安全保存到s0寄存器，将sscratch清零，作为"来自内核态"的标志，如果发生嵌套陷阱，可以通过检查sscratch判断来源。

保存CSR是为了进行中断的分析和逻辑判断，不恢复的原因是这些CSR寄存器在陷阱发生时由硬件自动设置，在陷阱返回时由硬件自动失效或由软件显式处理。