# Lab1实验报告
## 理解内核启动中的程序入口操作
clone完网站上的labcode文件，在对应的lab1中，找的entry.S文件，阅读代码如下
```
#include <mmu.h>
#include <memlayout.h>

    .section .text,"ax",%progbits
    .globl kern_entry
kern_entry:
    la sp, bootstacktop

    tail kern_init

.section .data
    # .align 2^12
    .align PGSHIFT
    .global bootstack
bootstack:
    .space KSTACKSIZE
    .global bootstacktop
bootstacktop:
```
la的作用是将某个符号地址加载到寄存器中，sp是栈指针寄存器，bootstacktop定义在.data段中，la sp,bootstacktop的作用是将bootstacktop的启动栈顶地址装到栈指针寄存器中，建立内核执行时所需要的栈环境。
kern_init 是内核的 C 语言入口函数，负责后续的内存管理初始化、设备初始化、中断设置等。而tail 是RISC-V的伪指令，等价于jump无条件跳转，意味着程序运行这句代码会直接跳转到kern_init，而不会回到kern_entry。
在上电复位后，BIOS/OpenSBI会完成基本的硬件初始化，然后跳转到内核的入口点，就会执行该代码。代码全部的作用就是定义了内核启动栈，并在入口kern_entry设置栈指针，然后将控制权交给c语言的kern_init，开始内核初始化流程。

## 使用GDB验证启动流程
### 基础硬件初始化阶段
首先，使用make debug和make gdb指令在qemu上模拟riscv硬件加电。

使用x/10i 0x1000指令，查看0x1000往后的十条指令，它们是加电后最初执行的指令，如下：

```
0x1000 : auipc  t0, 0x0
0x1004 : addi   a1, t0, 32
0x1008 : csrr   a0, mhartid
0x100c : ld     t0, 24(t0)
0x1010 : jr     t0
0x1014 : unimp
0x1018 : unimp
0x101a : unimp
0x101c : 0x8000
```


**0x1000~0x1010 是 RISC-V 启动时最早执行的指令**，完成从硬件复位到 OpenSBI 初始化的最初跳转。
aupic t0,0x0将当前PC高20位加载到寄存器t0中，为后续地址计算准备基址（PC相对寻址），然后执行addi a1,t0,32，计算地址t0+32并保存到a1中，用来传递OpenSBI的参数或结构体地址。csrr a0, mhartid读取当前硬件线程（hart）的 ID 到寄存器 a0，表明每个 CPU 核从复位开始会获得自己的 hart ID。ld t0, 24(t0)从地址 [t0 + 24] 处加载 64 位数据到寄存器 t0，加载跳转目标地址（即后续执行的入口）。jr t0，无条件跳转到寄存器 t0 指定的地址将控制权转移给下一阶（OpenSBI 主代码）。

值得注意的是，执行过程中出现大量的"??"符号，说明执行的指令地址没有对应的符号名称，这是因为这部分指令属于引导固件的代码，不属于操作系统内核，没有符号信息。

### SBI固件主初始化阶段
接下来，再次输入x/10i $pc,仿照上一步查看分析0x80000000附近的代码:

```
0x80000000: csrr   a6, mhartid
0x80000004: bgtz   a6, 0x80000108
0x80000008: auipc  t0, 0x0
0x8000000c: addi   t0, t0, 1032
0x80000010: auipc  t1, 0x0
0x80000014: addi   t1, t1, -16
0x80000018: sd     t1, 0(t0)
0x8000001c: auipc  t0, 0x0
0x80000020: addi   t0, t0, 1020
0x80000024: ld     t0, 0(t0)

```
这段代码是多核启动初始化代码的一部分，csrr a6, mhartid将读取当前硬件线程（hart）ID 到寄存器 a6，然后为hart0执行初始化等操作，是操作系统内核启动早期的多核初始化与内存地址设置部分。

### 控制权移交阶段
跳过观看冗长的主初始化阶段，使用watch *0x80200000指令，设置观察点，监视内核的加载过程,但是这里单独使用观察点输入continue之后，程序一直处于运行状态，无法进行下一步操作。

这里，改为使用b *0x80200000指令设置断点进行研究，这个地址的指令是la sp, bootstacktop，也就是entry.s要执行的内核的第一条指令，说明抵达了操作系统内核的入口。

输入c开始执行，命令行出现
```
Breakpoint 1, kern_entry () at kern/init/entry.S:7
7           la sp, bootstacktop
```
说明成功在断点处停止运行，此时输入 p/x,$sp 命令，得到$1 = 0x8001bd80，再次输入相同命令得到$2 = 0x80203000。
$1是在进入 kern_entry 之前的栈指针，是 OpenSBI 或启动代码提供的临时栈。执行 la sp, bootstacktop 后的$2说明指令 la sp, bootstacktop 成功执行。现在 $sp 指向 内核启动栈顶（bootstacktop）。内核启动阶段，所有函数调用和局部变量都会使用这个栈。

此时再次进行几步单词执行后，输入x/10i $pc命令，得到如下代码：
```
0x8020000e <kern_init+4>:    addi    a0,a0,-2
   0x80200012 <kern_init+8>:    auipc   a2,0x3
   0x80200016 <kern_init+12>:   addi    a2,a2,-10
   0x8020001a <kern_init+16>:   addi    sp,sp,-16
   0x8020001c <kern_init+18>:   li      a1,0
   0x8020001e <kern_init+20>:   sub     a2,a2,a0
   0x80200020 <kern_init+22>:   sd      ra,8(sp)
   0x80200022 <kern_init+24>:   jal     ra,0x802004ae <memset>
   0x80200026 <kern_init+28>:   auipc   a1,0x0
   0x8020002a <kern_init+32>:   addi    a1,a1,1178
```
都利用kern_init+num的符号信息，在kern_init函数内偏移调用指令，证明内核开始运行