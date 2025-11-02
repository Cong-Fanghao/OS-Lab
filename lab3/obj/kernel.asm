
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00006297          	auipc	t0,0x6
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0206000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00006297          	auipc	t0,0x6
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0206008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02052b7          	lui	t0,0xc0205
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c0205137          	lui	sp,0xc0205

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 1. 使用临时寄存器 t1 计算栈顶的精确地址
    lui t1, %hi(bootstacktop)
ffffffffc0200040:	c0205337          	lui	t1,0xc0205
    addi t1, t1, %lo(bootstacktop)
ffffffffc0200044:	00030313          	mv	t1,t1
    # 2. 将精确地址一次性地、安全地传给 sp
    mv sp, t1
ffffffffc0200048:	811a                	mv	sp,t1
    # 现在栈指针已经完美设置，可以安全地调用任何C函数了
    # 然后跳转到 kern_init (不再返回)
    lui t0, %hi(kern_init)
ffffffffc020004a:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020004e:	05428293          	addi	t0,t0,84 # ffffffffc0200054 <kern_init>
    jr t0
ffffffffc0200052:	8282                	jr	t0

ffffffffc0200054 <kern_init>:
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    // 先清零 BSS，再读取并保存 DTB 的内存信息，避免被清零覆盖（为了解释变化 正式上传时我觉得应该删去这句话）
    memset(edata, 0, end - edata);
ffffffffc0200054:	00006517          	auipc	a0,0x6
ffffffffc0200058:	fd450513          	addi	a0,a0,-44 # ffffffffc0206028 <free_area>
ffffffffc020005c:	00006617          	auipc	a2,0x6
ffffffffc0200060:	44460613          	addi	a2,a2,1092 # ffffffffc02064a0 <end>
int kern_init(void) {
ffffffffc0200064:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200066:	8e09                	sub	a2,a2,a0
ffffffffc0200068:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020006a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020006c:	663010ef          	jal	ra,ffffffffc0201ece <memset>
    dtb_init();
ffffffffc0200070:	410000ef          	jal	ra,ffffffffc0200480 <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	3fe000ef          	jal	ra,ffffffffc0200472 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00002517          	auipc	a0,0x2
ffffffffc020007c:	e6850513          	addi	a0,a0,-408 # ffffffffc0201ee0 <etext>
ffffffffc0200080:	092000ef          	jal	ra,ffffffffc0200112 <cputs>

    print_kerninfo();
ffffffffc0200084:	0de000ef          	jal	ra,ffffffffc0200162 <print_kerninfo>

    // grade_backtrace();
    // idt_init();  // init interrupt descriptor table

    pmm_init();  // init physical memory management
ffffffffc0200088:	6ca010ef          	jal	ra,ffffffffc0201752 <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020008c:	7b0000ef          	jal	ra,ffffffffc020083c <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200090:	3a0000ef          	jal	ra,ffffffffc0200430 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200094:	79c000ef          	jal	ra,ffffffffc0200830 <intr_enable>

    asm volatile("ebreak");
ffffffffc0200098:	9002                	ebreak
ffffffffc020009a:	0000                	unimp
ffffffffc020009c:	0000                	unimp
    asm volatile(".word 0x00000000");

    /* do nothing */
    while (1)
ffffffffc020009e:	a001                	j	ffffffffc020009e <kern_init+0x4a>

ffffffffc02000a0 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc02000a0:	1141                	addi	sp,sp,-16
ffffffffc02000a2:	e022                	sd	s0,0(sp)
ffffffffc02000a4:	e406                	sd	ra,8(sp)
ffffffffc02000a6:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc02000a8:	3cc000ef          	jal	ra,ffffffffc0200474 <cons_putc>
    (*cnt) ++;
ffffffffc02000ac:	401c                	lw	a5,0(s0)
}
ffffffffc02000ae:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc02000b0:	2785                	addiw	a5,a5,1
ffffffffc02000b2:	c01c                	sw	a5,0(s0)
}
ffffffffc02000b4:	6402                	ld	s0,0(sp)
ffffffffc02000b6:	0141                	addi	sp,sp,16
ffffffffc02000b8:	8082                	ret

ffffffffc02000ba <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000ba:	1101                	addi	sp,sp,-32
ffffffffc02000bc:	862a                	mv	a2,a0
ffffffffc02000be:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c0:	00000517          	auipc	a0,0x0
ffffffffc02000c4:	fe050513          	addi	a0,a0,-32 # ffffffffc02000a0 <cputch>
ffffffffc02000c8:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000ca:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000cc:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ce:	0d1010ef          	jal	ra,ffffffffc020199e <vprintfmt>
    return cnt;
}
ffffffffc02000d2:	60e2                	ld	ra,24(sp)
ffffffffc02000d4:	4532                	lw	a0,12(sp)
ffffffffc02000d6:	6105                	addi	sp,sp,32
ffffffffc02000d8:	8082                	ret

ffffffffc02000da <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000da:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000dc:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000e0:	8e2a                	mv	t3,a0
ffffffffc02000e2:	f42e                	sd	a1,40(sp)
ffffffffc02000e4:	f832                	sd	a2,48(sp)
ffffffffc02000e6:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e8:	00000517          	auipc	a0,0x0
ffffffffc02000ec:	fb850513          	addi	a0,a0,-72 # ffffffffc02000a0 <cputch>
ffffffffc02000f0:	004c                	addi	a1,sp,4
ffffffffc02000f2:	869a                	mv	a3,t1
ffffffffc02000f4:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000f6:	ec06                	sd	ra,24(sp)
ffffffffc02000f8:	e0ba                	sd	a4,64(sp)
ffffffffc02000fa:	e4be                	sd	a5,72(sp)
ffffffffc02000fc:	e8c2                	sd	a6,80(sp)
ffffffffc02000fe:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200100:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200102:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200104:	09b010ef          	jal	ra,ffffffffc020199e <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200108:	60e2                	ld	ra,24(sp)
ffffffffc020010a:	4512                	lw	a0,4(sp)
ffffffffc020010c:	6125                	addi	sp,sp,96
ffffffffc020010e:	8082                	ret

ffffffffc0200110 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc0200110:	a695                	j	ffffffffc0200474 <cons_putc>

ffffffffc0200112 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200112:	1101                	addi	sp,sp,-32
ffffffffc0200114:	e822                	sd	s0,16(sp)
ffffffffc0200116:	ec06                	sd	ra,24(sp)
ffffffffc0200118:	e426                	sd	s1,8(sp)
ffffffffc020011a:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc020011c:	00054503          	lbu	a0,0(a0)
ffffffffc0200120:	c51d                	beqz	a0,ffffffffc020014e <cputs+0x3c>
ffffffffc0200122:	0405                	addi	s0,s0,1
ffffffffc0200124:	4485                	li	s1,1
ffffffffc0200126:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200128:	34c000ef          	jal	ra,ffffffffc0200474 <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc020012c:	00044503          	lbu	a0,0(s0)
ffffffffc0200130:	008487bb          	addw	a5,s1,s0
ffffffffc0200134:	0405                	addi	s0,s0,1
ffffffffc0200136:	f96d                	bnez	a0,ffffffffc0200128 <cputs+0x16>
    (*cnt) ++;
ffffffffc0200138:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc020013c:	4529                	li	a0,10
ffffffffc020013e:	336000ef          	jal	ra,ffffffffc0200474 <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200142:	60e2                	ld	ra,24(sp)
ffffffffc0200144:	8522                	mv	a0,s0
ffffffffc0200146:	6442                	ld	s0,16(sp)
ffffffffc0200148:	64a2                	ld	s1,8(sp)
ffffffffc020014a:	6105                	addi	sp,sp,32
ffffffffc020014c:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc020014e:	4405                	li	s0,1
ffffffffc0200150:	b7f5                	j	ffffffffc020013c <cputs+0x2a>

ffffffffc0200152 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200152:	1141                	addi	sp,sp,-16
ffffffffc0200154:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200156:	326000ef          	jal	ra,ffffffffc020047c <cons_getc>
ffffffffc020015a:	dd75                	beqz	a0,ffffffffc0200156 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc020015c:	60a2                	ld	ra,8(sp)
ffffffffc020015e:	0141                	addi	sp,sp,16
ffffffffc0200160:	8082                	ret

ffffffffc0200162 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc0200162:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc0200164:	00002517          	auipc	a0,0x2
ffffffffc0200168:	d9c50513          	addi	a0,a0,-612 # ffffffffc0201f00 <etext+0x20>
void print_kerninfo(void) {
ffffffffc020016c:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc020016e:	f6dff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc0200172:	00000597          	auipc	a1,0x0
ffffffffc0200176:	ee258593          	addi	a1,a1,-286 # ffffffffc0200054 <kern_init>
ffffffffc020017a:	00002517          	auipc	a0,0x2
ffffffffc020017e:	da650513          	addi	a0,a0,-602 # ffffffffc0201f20 <etext+0x40>
ffffffffc0200182:	f59ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc0200186:	00002597          	auipc	a1,0x2
ffffffffc020018a:	d5a58593          	addi	a1,a1,-678 # ffffffffc0201ee0 <etext>
ffffffffc020018e:	00002517          	auipc	a0,0x2
ffffffffc0200192:	db250513          	addi	a0,a0,-590 # ffffffffc0201f40 <etext+0x60>
ffffffffc0200196:	f45ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc020019a:	00006597          	auipc	a1,0x6
ffffffffc020019e:	e8e58593          	addi	a1,a1,-370 # ffffffffc0206028 <free_area>
ffffffffc02001a2:	00002517          	auipc	a0,0x2
ffffffffc02001a6:	dbe50513          	addi	a0,a0,-578 # ffffffffc0201f60 <etext+0x80>
ffffffffc02001aa:	f31ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001ae:	00006597          	auipc	a1,0x6
ffffffffc02001b2:	2f258593          	addi	a1,a1,754 # ffffffffc02064a0 <end>
ffffffffc02001b6:	00002517          	auipc	a0,0x2
ffffffffc02001ba:	dca50513          	addi	a0,a0,-566 # ffffffffc0201f80 <etext+0xa0>
ffffffffc02001be:	f1dff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001c2:	00006597          	auipc	a1,0x6
ffffffffc02001c6:	6dd58593          	addi	a1,a1,1757 # ffffffffc020689f <end+0x3ff>
ffffffffc02001ca:	00000797          	auipc	a5,0x0
ffffffffc02001ce:	e8a78793          	addi	a5,a5,-374 # ffffffffc0200054 <kern_init>
ffffffffc02001d2:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d6:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001da:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001dc:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001e0:	95be                	add	a1,a1,a5
ffffffffc02001e2:	85a9                	srai	a1,a1,0xa
ffffffffc02001e4:	00002517          	auipc	a0,0x2
ffffffffc02001e8:	dbc50513          	addi	a0,a0,-580 # ffffffffc0201fa0 <etext+0xc0>
}
ffffffffc02001ec:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001ee:	b5f5                	j	ffffffffc02000da <cprintf>

ffffffffc02001f0 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001f0:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02001f2:	00002617          	auipc	a2,0x2
ffffffffc02001f6:	dde60613          	addi	a2,a2,-546 # ffffffffc0201fd0 <etext+0xf0>
ffffffffc02001fa:	04d00593          	li	a1,77
ffffffffc02001fe:	00002517          	auipc	a0,0x2
ffffffffc0200202:	dea50513          	addi	a0,a0,-534 # ffffffffc0201fe8 <etext+0x108>
void print_stackframe(void) {
ffffffffc0200206:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200208:	1cc000ef          	jal	ra,ffffffffc02003d4 <__panic>

ffffffffc020020c <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020020c:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020020e:	00002617          	auipc	a2,0x2
ffffffffc0200212:	df260613          	addi	a2,a2,-526 # ffffffffc0202000 <etext+0x120>
ffffffffc0200216:	00002597          	auipc	a1,0x2
ffffffffc020021a:	e0a58593          	addi	a1,a1,-502 # ffffffffc0202020 <etext+0x140>
ffffffffc020021e:	00002517          	auipc	a0,0x2
ffffffffc0200222:	e0a50513          	addi	a0,a0,-502 # ffffffffc0202028 <etext+0x148>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200226:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200228:	eb3ff0ef          	jal	ra,ffffffffc02000da <cprintf>
ffffffffc020022c:	00002617          	auipc	a2,0x2
ffffffffc0200230:	e0c60613          	addi	a2,a2,-500 # ffffffffc0202038 <etext+0x158>
ffffffffc0200234:	00002597          	auipc	a1,0x2
ffffffffc0200238:	e2c58593          	addi	a1,a1,-468 # ffffffffc0202060 <etext+0x180>
ffffffffc020023c:	00002517          	auipc	a0,0x2
ffffffffc0200240:	dec50513          	addi	a0,a0,-532 # ffffffffc0202028 <etext+0x148>
ffffffffc0200244:	e97ff0ef          	jal	ra,ffffffffc02000da <cprintf>
ffffffffc0200248:	00002617          	auipc	a2,0x2
ffffffffc020024c:	e2860613          	addi	a2,a2,-472 # ffffffffc0202070 <etext+0x190>
ffffffffc0200250:	00002597          	auipc	a1,0x2
ffffffffc0200254:	e4058593          	addi	a1,a1,-448 # ffffffffc0202090 <etext+0x1b0>
ffffffffc0200258:	00002517          	auipc	a0,0x2
ffffffffc020025c:	dd050513          	addi	a0,a0,-560 # ffffffffc0202028 <etext+0x148>
ffffffffc0200260:	e7bff0ef          	jal	ra,ffffffffc02000da <cprintf>
    }
    return 0;
}
ffffffffc0200264:	60a2                	ld	ra,8(sp)
ffffffffc0200266:	4501                	li	a0,0
ffffffffc0200268:	0141                	addi	sp,sp,16
ffffffffc020026a:	8082                	ret

ffffffffc020026c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc020026c:	1141                	addi	sp,sp,-16
ffffffffc020026e:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200270:	ef3ff0ef          	jal	ra,ffffffffc0200162 <print_kerninfo>
    return 0;
}
ffffffffc0200274:	60a2                	ld	ra,8(sp)
ffffffffc0200276:	4501                	li	a0,0
ffffffffc0200278:	0141                	addi	sp,sp,16
ffffffffc020027a:	8082                	ret

ffffffffc020027c <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc020027c:	1141                	addi	sp,sp,-16
ffffffffc020027e:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200280:	f71ff0ef          	jal	ra,ffffffffc02001f0 <print_stackframe>
    return 0;
}
ffffffffc0200284:	60a2                	ld	ra,8(sp)
ffffffffc0200286:	4501                	li	a0,0
ffffffffc0200288:	0141                	addi	sp,sp,16
ffffffffc020028a:	8082                	ret

ffffffffc020028c <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc020028c:	7115                	addi	sp,sp,-224
ffffffffc020028e:	ed5e                	sd	s7,152(sp)
ffffffffc0200290:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200292:	00002517          	auipc	a0,0x2
ffffffffc0200296:	e0e50513          	addi	a0,a0,-498 # ffffffffc02020a0 <etext+0x1c0>
kmonitor(struct trapframe *tf) {
ffffffffc020029a:	ed86                	sd	ra,216(sp)
ffffffffc020029c:	e9a2                	sd	s0,208(sp)
ffffffffc020029e:	e5a6                	sd	s1,200(sp)
ffffffffc02002a0:	e1ca                	sd	s2,192(sp)
ffffffffc02002a2:	fd4e                	sd	s3,184(sp)
ffffffffc02002a4:	f952                	sd	s4,176(sp)
ffffffffc02002a6:	f556                	sd	s5,168(sp)
ffffffffc02002a8:	f15a                	sd	s6,160(sp)
ffffffffc02002aa:	e962                	sd	s8,144(sp)
ffffffffc02002ac:	e566                	sd	s9,136(sp)
ffffffffc02002ae:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002b0:	e2bff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002b4:	00002517          	auipc	a0,0x2
ffffffffc02002b8:	e1450513          	addi	a0,a0,-492 # ffffffffc02020c8 <etext+0x1e8>
ffffffffc02002bc:	e1fff0ef          	jal	ra,ffffffffc02000da <cprintf>
    if (tf != NULL) {
ffffffffc02002c0:	000b8563          	beqz	s7,ffffffffc02002ca <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002c4:	855e                	mv	a0,s7
ffffffffc02002c6:	756000ef          	jal	ra,ffffffffc0200a1c <print_trapframe>
ffffffffc02002ca:	00002c17          	auipc	s8,0x2
ffffffffc02002ce:	e6ec0c13          	addi	s8,s8,-402 # ffffffffc0202138 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002d2:	00002917          	auipc	s2,0x2
ffffffffc02002d6:	e1e90913          	addi	s2,s2,-482 # ffffffffc02020f0 <etext+0x210>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002da:	00002497          	auipc	s1,0x2
ffffffffc02002de:	e1e48493          	addi	s1,s1,-482 # ffffffffc02020f8 <etext+0x218>
        if (argc == MAXARGS - 1) {
ffffffffc02002e2:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002e4:	00002b17          	auipc	s6,0x2
ffffffffc02002e8:	e1cb0b13          	addi	s6,s6,-484 # ffffffffc0202100 <etext+0x220>
        argv[argc ++] = buf;
ffffffffc02002ec:	00002a17          	auipc	s4,0x2
ffffffffc02002f0:	d34a0a13          	addi	s4,s4,-716 # ffffffffc0202020 <etext+0x140>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002f4:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002f6:	854a                	mv	a0,s2
ffffffffc02002f8:	229010ef          	jal	ra,ffffffffc0201d20 <readline>
ffffffffc02002fc:	842a                	mv	s0,a0
ffffffffc02002fe:	dd65                	beqz	a0,ffffffffc02002f6 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200300:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200304:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200306:	e1bd                	bnez	a1,ffffffffc020036c <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc0200308:	fe0c87e3          	beqz	s9,ffffffffc02002f6 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020030c:	6582                	ld	a1,0(sp)
ffffffffc020030e:	00002d17          	auipc	s10,0x2
ffffffffc0200312:	e2ad0d13          	addi	s10,s10,-470 # ffffffffc0202138 <commands>
        argv[argc ++] = buf;
ffffffffc0200316:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200318:	4401                	li	s0,0
ffffffffc020031a:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020031c:	359010ef          	jal	ra,ffffffffc0201e74 <strcmp>
ffffffffc0200320:	c919                	beqz	a0,ffffffffc0200336 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200322:	2405                	addiw	s0,s0,1
ffffffffc0200324:	0b540063          	beq	s0,s5,ffffffffc02003c4 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200328:	000d3503          	ld	a0,0(s10)
ffffffffc020032c:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020032e:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200330:	345010ef          	jal	ra,ffffffffc0201e74 <strcmp>
ffffffffc0200334:	f57d                	bnez	a0,ffffffffc0200322 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200336:	00141793          	slli	a5,s0,0x1
ffffffffc020033a:	97a2                	add	a5,a5,s0
ffffffffc020033c:	078e                	slli	a5,a5,0x3
ffffffffc020033e:	97e2                	add	a5,a5,s8
ffffffffc0200340:	6b9c                	ld	a5,16(a5)
ffffffffc0200342:	865e                	mv	a2,s7
ffffffffc0200344:	002c                	addi	a1,sp,8
ffffffffc0200346:	fffc851b          	addiw	a0,s9,-1
ffffffffc020034a:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc020034c:	fa0555e3          	bgez	a0,ffffffffc02002f6 <kmonitor+0x6a>
}
ffffffffc0200350:	60ee                	ld	ra,216(sp)
ffffffffc0200352:	644e                	ld	s0,208(sp)
ffffffffc0200354:	64ae                	ld	s1,200(sp)
ffffffffc0200356:	690e                	ld	s2,192(sp)
ffffffffc0200358:	79ea                	ld	s3,184(sp)
ffffffffc020035a:	7a4a                	ld	s4,176(sp)
ffffffffc020035c:	7aaa                	ld	s5,168(sp)
ffffffffc020035e:	7b0a                	ld	s6,160(sp)
ffffffffc0200360:	6bea                	ld	s7,152(sp)
ffffffffc0200362:	6c4a                	ld	s8,144(sp)
ffffffffc0200364:	6caa                	ld	s9,136(sp)
ffffffffc0200366:	6d0a                	ld	s10,128(sp)
ffffffffc0200368:	612d                	addi	sp,sp,224
ffffffffc020036a:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020036c:	8526                	mv	a0,s1
ffffffffc020036e:	34b010ef          	jal	ra,ffffffffc0201eb8 <strchr>
ffffffffc0200372:	c901                	beqz	a0,ffffffffc0200382 <kmonitor+0xf6>
ffffffffc0200374:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200378:	00040023          	sb	zero,0(s0)
ffffffffc020037c:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020037e:	d5c9                	beqz	a1,ffffffffc0200308 <kmonitor+0x7c>
ffffffffc0200380:	b7f5                	j	ffffffffc020036c <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc0200382:	00044783          	lbu	a5,0(s0)
ffffffffc0200386:	d3c9                	beqz	a5,ffffffffc0200308 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200388:	033c8963          	beq	s9,s3,ffffffffc02003ba <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc020038c:	003c9793          	slli	a5,s9,0x3
ffffffffc0200390:	0118                	addi	a4,sp,128
ffffffffc0200392:	97ba                	add	a5,a5,a4
ffffffffc0200394:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200398:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc020039c:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020039e:	e591                	bnez	a1,ffffffffc02003aa <kmonitor+0x11e>
ffffffffc02003a0:	b7b5                	j	ffffffffc020030c <kmonitor+0x80>
ffffffffc02003a2:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003a6:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a8:	d1a5                	beqz	a1,ffffffffc0200308 <kmonitor+0x7c>
ffffffffc02003aa:	8526                	mv	a0,s1
ffffffffc02003ac:	30d010ef          	jal	ra,ffffffffc0201eb8 <strchr>
ffffffffc02003b0:	d96d                	beqz	a0,ffffffffc02003a2 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003b2:	00044583          	lbu	a1,0(s0)
ffffffffc02003b6:	d9a9                	beqz	a1,ffffffffc0200308 <kmonitor+0x7c>
ffffffffc02003b8:	bf55                	j	ffffffffc020036c <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003ba:	45c1                	li	a1,16
ffffffffc02003bc:	855a                	mv	a0,s6
ffffffffc02003be:	d1dff0ef          	jal	ra,ffffffffc02000da <cprintf>
ffffffffc02003c2:	b7e9                	j	ffffffffc020038c <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003c4:	6582                	ld	a1,0(sp)
ffffffffc02003c6:	00002517          	auipc	a0,0x2
ffffffffc02003ca:	d5a50513          	addi	a0,a0,-678 # ffffffffc0202120 <etext+0x240>
ffffffffc02003ce:	d0dff0ef          	jal	ra,ffffffffc02000da <cprintf>
    return 0;
ffffffffc02003d2:	b715                	j	ffffffffc02002f6 <kmonitor+0x6a>

ffffffffc02003d4 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02003d4:	00006317          	auipc	t1,0x6
ffffffffc02003d8:	06c30313          	addi	t1,t1,108 # ffffffffc0206440 <is_panic>
ffffffffc02003dc:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02003e0:	715d                	addi	sp,sp,-80
ffffffffc02003e2:	ec06                	sd	ra,24(sp)
ffffffffc02003e4:	e822                	sd	s0,16(sp)
ffffffffc02003e6:	f436                	sd	a3,40(sp)
ffffffffc02003e8:	f83a                	sd	a4,48(sp)
ffffffffc02003ea:	fc3e                	sd	a5,56(sp)
ffffffffc02003ec:	e0c2                	sd	a6,64(sp)
ffffffffc02003ee:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02003f0:	020e1a63          	bnez	t3,ffffffffc0200424 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02003f4:	4785                	li	a5,1
ffffffffc02003f6:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003fa:	8432                	mv	s0,a2
ffffffffc02003fc:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003fe:	862e                	mv	a2,a1
ffffffffc0200400:	85aa                	mv	a1,a0
ffffffffc0200402:	00002517          	auipc	a0,0x2
ffffffffc0200406:	d7e50513          	addi	a0,a0,-642 # ffffffffc0202180 <commands+0x48>
    va_start(ap, fmt);
ffffffffc020040a:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020040c:	ccfff0ef          	jal	ra,ffffffffc02000da <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200410:	65a2                	ld	a1,8(sp)
ffffffffc0200412:	8522                	mv	a0,s0
ffffffffc0200414:	ca7ff0ef          	jal	ra,ffffffffc02000ba <vcprintf>
    cprintf("\n");
ffffffffc0200418:	00002517          	auipc	a0,0x2
ffffffffc020041c:	bb050513          	addi	a0,a0,-1104 # ffffffffc0201fc8 <etext+0xe8>
ffffffffc0200420:	cbbff0ef          	jal	ra,ffffffffc02000da <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc0200424:	412000ef          	jal	ra,ffffffffc0200836 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200428:	4501                	li	a0,0
ffffffffc020042a:	e63ff0ef          	jal	ra,ffffffffc020028c <kmonitor>
    while (1) {
ffffffffc020042e:	bfed                	j	ffffffffc0200428 <__panic+0x54>

ffffffffc0200430 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc0200430:	1141                	addi	sp,sp,-16
ffffffffc0200432:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc0200434:	02000793          	li	a5,32
ffffffffc0200438:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020043c:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200440:	67e1                	lui	a5,0x18
ffffffffc0200442:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200446:	953e                	add	a0,a0,a5
ffffffffc0200448:	1a7010ef          	jal	ra,ffffffffc0201dee <sbi_set_timer>
}
ffffffffc020044c:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc020044e:	00006797          	auipc	a5,0x6
ffffffffc0200452:	fe07bd23          	sd	zero,-6(a5) # ffffffffc0206448 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200456:	00002517          	auipc	a0,0x2
ffffffffc020045a:	d4a50513          	addi	a0,a0,-694 # ffffffffc02021a0 <commands+0x68>
}
ffffffffc020045e:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200460:	b9ad                	j	ffffffffc02000da <cprintf>

ffffffffc0200462 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200462:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200466:	67e1                	lui	a5,0x18
ffffffffc0200468:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020046c:	953e                	add	a0,a0,a5
ffffffffc020046e:	1810106f          	j	ffffffffc0201dee <sbi_set_timer>

ffffffffc0200472 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200472:	8082                	ret

ffffffffc0200474 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc0200474:	0ff57513          	zext.b	a0,a0
ffffffffc0200478:	15d0106f          	j	ffffffffc0201dd4 <sbi_console_putchar>

ffffffffc020047c <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc020047c:	18d0106f          	j	ffffffffc0201e08 <sbi_console_getchar>

ffffffffc0200480 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200480:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200482:	00002517          	auipc	a0,0x2
ffffffffc0200486:	d3e50513          	addi	a0,a0,-706 # ffffffffc02021c0 <commands+0x88>
void dtb_init(void) {
ffffffffc020048a:	fc86                	sd	ra,120(sp)
ffffffffc020048c:	f8a2                	sd	s0,112(sp)
ffffffffc020048e:	e8d2                	sd	s4,80(sp)
ffffffffc0200490:	f4a6                	sd	s1,104(sp)
ffffffffc0200492:	f0ca                	sd	s2,96(sp)
ffffffffc0200494:	ecce                	sd	s3,88(sp)
ffffffffc0200496:	e4d6                	sd	s5,72(sp)
ffffffffc0200498:	e0da                	sd	s6,64(sp)
ffffffffc020049a:	fc5e                	sd	s7,56(sp)
ffffffffc020049c:	f862                	sd	s8,48(sp)
ffffffffc020049e:	f466                	sd	s9,40(sp)
ffffffffc02004a0:	f06a                	sd	s10,32(sp)
ffffffffc02004a2:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc02004a4:	c37ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02004a8:	00006597          	auipc	a1,0x6
ffffffffc02004ac:	b585b583          	ld	a1,-1192(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc02004b0:	00002517          	auipc	a0,0x2
ffffffffc02004b4:	d2050513          	addi	a0,a0,-736 # ffffffffc02021d0 <commands+0x98>
ffffffffc02004b8:	c23ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02004bc:	00006417          	auipc	s0,0x6
ffffffffc02004c0:	b4c40413          	addi	s0,s0,-1204 # ffffffffc0206008 <boot_dtb>
ffffffffc02004c4:	600c                	ld	a1,0(s0)
ffffffffc02004c6:	00002517          	auipc	a0,0x2
ffffffffc02004ca:	d1a50513          	addi	a0,a0,-742 # ffffffffc02021e0 <commands+0xa8>
ffffffffc02004ce:	c0dff0ef          	jal	ra,ffffffffc02000da <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02004d2:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02004d6:	00002517          	auipc	a0,0x2
ffffffffc02004da:	d2250513          	addi	a0,a0,-734 # ffffffffc02021f8 <commands+0xc0>
    if (boot_dtb == 0) {
ffffffffc02004de:	120a0463          	beqz	s4,ffffffffc0200606 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02004e2:	57f5                	li	a5,-3
ffffffffc02004e4:	07fa                	slli	a5,a5,0x1e
ffffffffc02004e6:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02004ea:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ec:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f0:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f2:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02004f6:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fa:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004fe:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200502:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200506:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200508:	8ec9                	or	a3,a3,a0
ffffffffc020050a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020050e:	1b7d                	addi	s6,s6,-1
ffffffffc0200510:	0167f7b3          	and	a5,a5,s6
ffffffffc0200514:	8dd5                	or	a1,a1,a3
ffffffffc0200516:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200518:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020051c:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020051e:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed9a4d>
ffffffffc0200522:	10f59163          	bne	a1,a5,ffffffffc0200624 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc0200526:	471c                	lw	a5,8(a4)
ffffffffc0200528:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc020052a:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052c:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200530:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200534:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200538:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020053c:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200540:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200544:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200548:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020054c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200550:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200554:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200556:	01146433          	or	s0,s0,a7
ffffffffc020055a:	0086969b          	slliw	a3,a3,0x8
ffffffffc020055e:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200562:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200564:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200568:	8c49                	or	s0,s0,a0
ffffffffc020056a:	0166f6b3          	and	a3,a3,s6
ffffffffc020056e:	00ca6a33          	or	s4,s4,a2
ffffffffc0200572:	0167f7b3          	and	a5,a5,s6
ffffffffc0200576:	8c55                	or	s0,s0,a3
ffffffffc0200578:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020057c:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020057e:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200580:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200582:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200586:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200588:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020058a:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020058e:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200590:	00002917          	auipc	s2,0x2
ffffffffc0200594:	cb890913          	addi	s2,s2,-840 # ffffffffc0202248 <commands+0x110>
ffffffffc0200598:	49bd                	li	s3,15
        switch (token) {
ffffffffc020059a:	4d91                	li	s11,4
ffffffffc020059c:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020059e:	00002497          	auipc	s1,0x2
ffffffffc02005a2:	ca248493          	addi	s1,s1,-862 # ffffffffc0202240 <commands+0x108>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02005a6:	000a2703          	lw	a4,0(s4)
ffffffffc02005aa:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ae:	0087569b          	srliw	a3,a4,0x8
ffffffffc02005b2:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b6:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ba:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005be:	0107571b          	srliw	a4,a4,0x10
ffffffffc02005c2:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c4:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c8:	0087171b          	slliw	a4,a4,0x8
ffffffffc02005cc:	8fd5                	or	a5,a5,a3
ffffffffc02005ce:	00eb7733          	and	a4,s6,a4
ffffffffc02005d2:	8fd9                	or	a5,a5,a4
ffffffffc02005d4:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc02005d6:	09778c63          	beq	a5,s7,ffffffffc020066e <dtb_init+0x1ee>
ffffffffc02005da:	00fbea63          	bltu	s7,a5,ffffffffc02005ee <dtb_init+0x16e>
ffffffffc02005de:	07a78663          	beq	a5,s10,ffffffffc020064a <dtb_init+0x1ca>
ffffffffc02005e2:	4709                	li	a4,2
ffffffffc02005e4:	00e79763          	bne	a5,a4,ffffffffc02005f2 <dtb_init+0x172>
ffffffffc02005e8:	4c81                	li	s9,0
ffffffffc02005ea:	8a56                	mv	s4,s5
ffffffffc02005ec:	bf6d                	j	ffffffffc02005a6 <dtb_init+0x126>
ffffffffc02005ee:	ffb78ee3          	beq	a5,s11,ffffffffc02005ea <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02005f2:	00002517          	auipc	a0,0x2
ffffffffc02005f6:	cce50513          	addi	a0,a0,-818 # ffffffffc02022c0 <commands+0x188>
ffffffffc02005fa:	ae1ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02005fe:	00002517          	auipc	a0,0x2
ffffffffc0200602:	cfa50513          	addi	a0,a0,-774 # ffffffffc02022f8 <commands+0x1c0>
}
ffffffffc0200606:	7446                	ld	s0,112(sp)
ffffffffc0200608:	70e6                	ld	ra,120(sp)
ffffffffc020060a:	74a6                	ld	s1,104(sp)
ffffffffc020060c:	7906                	ld	s2,96(sp)
ffffffffc020060e:	69e6                	ld	s3,88(sp)
ffffffffc0200610:	6a46                	ld	s4,80(sp)
ffffffffc0200612:	6aa6                	ld	s5,72(sp)
ffffffffc0200614:	6b06                	ld	s6,64(sp)
ffffffffc0200616:	7be2                	ld	s7,56(sp)
ffffffffc0200618:	7c42                	ld	s8,48(sp)
ffffffffc020061a:	7ca2                	ld	s9,40(sp)
ffffffffc020061c:	7d02                	ld	s10,32(sp)
ffffffffc020061e:	6de2                	ld	s11,24(sp)
ffffffffc0200620:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc0200622:	bc65                	j	ffffffffc02000da <cprintf>
}
ffffffffc0200624:	7446                	ld	s0,112(sp)
ffffffffc0200626:	70e6                	ld	ra,120(sp)
ffffffffc0200628:	74a6                	ld	s1,104(sp)
ffffffffc020062a:	7906                	ld	s2,96(sp)
ffffffffc020062c:	69e6                	ld	s3,88(sp)
ffffffffc020062e:	6a46                	ld	s4,80(sp)
ffffffffc0200630:	6aa6                	ld	s5,72(sp)
ffffffffc0200632:	6b06                	ld	s6,64(sp)
ffffffffc0200634:	7be2                	ld	s7,56(sp)
ffffffffc0200636:	7c42                	ld	s8,48(sp)
ffffffffc0200638:	7ca2                	ld	s9,40(sp)
ffffffffc020063a:	7d02                	ld	s10,32(sp)
ffffffffc020063c:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc020063e:	00002517          	auipc	a0,0x2
ffffffffc0200642:	bda50513          	addi	a0,a0,-1062 # ffffffffc0202218 <commands+0xe0>
}
ffffffffc0200646:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200648:	bc49                	j	ffffffffc02000da <cprintf>
                int name_len = strlen(name);
ffffffffc020064a:	8556                	mv	a0,s5
ffffffffc020064c:	7f2010ef          	jal	ra,ffffffffc0201e3e <strlen>
ffffffffc0200650:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200652:	4619                	li	a2,6
ffffffffc0200654:	85a6                	mv	a1,s1
ffffffffc0200656:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200658:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020065a:	039010ef          	jal	ra,ffffffffc0201e92 <strncmp>
ffffffffc020065e:	e111                	bnez	a0,ffffffffc0200662 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200660:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200662:	0a91                	addi	s5,s5,4
ffffffffc0200664:	9ad2                	add	s5,s5,s4
ffffffffc0200666:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020066a:	8a56                	mv	s4,s5
ffffffffc020066c:	bf2d                	j	ffffffffc02005a6 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020066e:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200672:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200676:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020067a:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067e:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200682:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020068a:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068e:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200692:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200696:	00eaeab3          	or	s5,s5,a4
ffffffffc020069a:	00fb77b3          	and	a5,s6,a5
ffffffffc020069e:	00faeab3          	or	s5,s5,a5
ffffffffc02006a2:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006a4:	000c9c63          	bnez	s9,ffffffffc02006bc <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006a8:	1a82                	slli	s5,s5,0x20
ffffffffc02006aa:	00368793          	addi	a5,a3,3
ffffffffc02006ae:	020ada93          	srli	s5,s5,0x20
ffffffffc02006b2:	9abe                	add	s5,s5,a5
ffffffffc02006b4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02006b8:	8a56                	mv	s4,s5
ffffffffc02006ba:	b5f5                	j	ffffffffc02005a6 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006bc:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006c0:	85ca                	mv	a1,s2
ffffffffc02006c2:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c8:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006cc:	0187971b          	slliw	a4,a5,0x18
ffffffffc02006d0:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02006d8:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006da:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006de:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e2:	8d59                	or	a0,a0,a4
ffffffffc02006e4:	00fb77b3          	and	a5,s6,a5
ffffffffc02006e8:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02006ea:	1502                	slli	a0,a0,0x20
ffffffffc02006ec:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006ee:	9522                	add	a0,a0,s0
ffffffffc02006f0:	784010ef          	jal	ra,ffffffffc0201e74 <strcmp>
ffffffffc02006f4:	66a2                	ld	a3,8(sp)
ffffffffc02006f6:	f94d                	bnez	a0,ffffffffc02006a8 <dtb_init+0x228>
ffffffffc02006f8:	fb59f8e3          	bgeu	s3,s5,ffffffffc02006a8 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02006fc:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200700:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200704:	00002517          	auipc	a0,0x2
ffffffffc0200708:	b4c50513          	addi	a0,a0,-1204 # ffffffffc0202250 <commands+0x118>
           fdt32_to_cpu(x >> 32);
ffffffffc020070c:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200710:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200714:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200718:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020071c:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200720:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200724:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200728:	0187d693          	srli	a3,a5,0x18
ffffffffc020072c:	01861f1b          	slliw	t5,a2,0x18
ffffffffc0200730:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200734:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200738:	0106561b          	srliw	a2,a2,0x10
ffffffffc020073c:	010f6f33          	or	t5,t5,a6
ffffffffc0200740:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200744:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200748:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020074c:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200750:	0186f6b3          	and	a3,a3,s8
ffffffffc0200754:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200758:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020075c:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200760:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200764:	8361                	srli	a4,a4,0x18
ffffffffc0200766:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020076a:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020076e:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200772:	00cb7633          	and	a2,s6,a2
ffffffffc0200776:	0088181b          	slliw	a6,a6,0x8
ffffffffc020077a:	0085959b          	slliw	a1,a1,0x8
ffffffffc020077e:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200782:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200786:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020078a:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020078e:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200792:	011b78b3          	and	a7,s6,a7
ffffffffc0200796:	005eeeb3          	or	t4,t4,t0
ffffffffc020079a:	00c6e733          	or	a4,a3,a2
ffffffffc020079e:	006c6c33          	or	s8,s8,t1
ffffffffc02007a2:	010b76b3          	and	a3,s6,a6
ffffffffc02007a6:	00bb7b33          	and	s6,s6,a1
ffffffffc02007aa:	01d7e7b3          	or	a5,a5,t4
ffffffffc02007ae:	016c6b33          	or	s6,s8,s6
ffffffffc02007b2:	01146433          	or	s0,s0,a7
ffffffffc02007b6:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc02007b8:	1702                	slli	a4,a4,0x20
ffffffffc02007ba:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007bc:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007be:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007c0:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007c2:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007c6:	0167eb33          	or	s6,a5,s6
ffffffffc02007ca:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007cc:	90fff0ef          	jal	ra,ffffffffc02000da <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02007d0:	85a2                	mv	a1,s0
ffffffffc02007d2:	00002517          	auipc	a0,0x2
ffffffffc02007d6:	a9e50513          	addi	a0,a0,-1378 # ffffffffc0202270 <commands+0x138>
ffffffffc02007da:	901ff0ef          	jal	ra,ffffffffc02000da <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02007de:	014b5613          	srli	a2,s6,0x14
ffffffffc02007e2:	85da                	mv	a1,s6
ffffffffc02007e4:	00002517          	auipc	a0,0x2
ffffffffc02007e8:	aa450513          	addi	a0,a0,-1372 # ffffffffc0202288 <commands+0x150>
ffffffffc02007ec:	8efff0ef          	jal	ra,ffffffffc02000da <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02007f0:	008b05b3          	add	a1,s6,s0
ffffffffc02007f4:	15fd                	addi	a1,a1,-1
ffffffffc02007f6:	00002517          	auipc	a0,0x2
ffffffffc02007fa:	ab250513          	addi	a0,a0,-1358 # ffffffffc02022a8 <commands+0x170>
ffffffffc02007fe:	8ddff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200802:	00002517          	auipc	a0,0x2
ffffffffc0200806:	af650513          	addi	a0,a0,-1290 # ffffffffc02022f8 <commands+0x1c0>
        memory_base = mem_base;
ffffffffc020080a:	00006797          	auipc	a5,0x6
ffffffffc020080e:	c487b323          	sd	s0,-954(a5) # ffffffffc0206450 <memory_base>
        memory_size = mem_size;
ffffffffc0200812:	00006797          	auipc	a5,0x6
ffffffffc0200816:	c567b323          	sd	s6,-954(a5) # ffffffffc0206458 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc020081a:	b3f5                	j	ffffffffc0200606 <dtb_init+0x186>

ffffffffc020081c <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020081c:	00006517          	auipc	a0,0x6
ffffffffc0200820:	c3453503          	ld	a0,-972(a0) # ffffffffc0206450 <memory_base>
ffffffffc0200824:	8082                	ret

ffffffffc0200826 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc0200826:	00006517          	auipc	a0,0x6
ffffffffc020082a:	c3253503          	ld	a0,-974(a0) # ffffffffc0206458 <memory_size>
ffffffffc020082e:	8082                	ret

ffffffffc0200830 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200830:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200834:	8082                	ret

ffffffffc0200836 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200836:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020083a:	8082                	ret

ffffffffc020083c <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020083c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200840:	00000797          	auipc	a5,0x0
ffffffffc0200844:	39878793          	addi	a5,a5,920 # ffffffffc0200bd8 <__alltraps>
ffffffffc0200848:	10579073          	csrw	stvec,a5
}
ffffffffc020084c:	8082                	ret

ffffffffc020084e <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020084e:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200850:	1141                	addi	sp,sp,-16
ffffffffc0200852:	e022                	sd	s0,0(sp)
ffffffffc0200854:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200856:	00002517          	auipc	a0,0x2
ffffffffc020085a:	aba50513          	addi	a0,a0,-1350 # ffffffffc0202310 <commands+0x1d8>
void print_regs(struct pushregs *gpr) {
ffffffffc020085e:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200860:	87bff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200864:	640c                	ld	a1,8(s0)
ffffffffc0200866:	00002517          	auipc	a0,0x2
ffffffffc020086a:	ac250513          	addi	a0,a0,-1342 # ffffffffc0202328 <commands+0x1f0>
ffffffffc020086e:	86dff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200872:	680c                	ld	a1,16(s0)
ffffffffc0200874:	00002517          	auipc	a0,0x2
ffffffffc0200878:	acc50513          	addi	a0,a0,-1332 # ffffffffc0202340 <commands+0x208>
ffffffffc020087c:	85fff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200880:	6c0c                	ld	a1,24(s0)
ffffffffc0200882:	00002517          	auipc	a0,0x2
ffffffffc0200886:	ad650513          	addi	a0,a0,-1322 # ffffffffc0202358 <commands+0x220>
ffffffffc020088a:	851ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc020088e:	700c                	ld	a1,32(s0)
ffffffffc0200890:	00002517          	auipc	a0,0x2
ffffffffc0200894:	ae050513          	addi	a0,a0,-1312 # ffffffffc0202370 <commands+0x238>
ffffffffc0200898:	843ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc020089c:	740c                	ld	a1,40(s0)
ffffffffc020089e:	00002517          	auipc	a0,0x2
ffffffffc02008a2:	aea50513          	addi	a0,a0,-1302 # ffffffffc0202388 <commands+0x250>
ffffffffc02008a6:	835ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02008aa:	780c                	ld	a1,48(s0)
ffffffffc02008ac:	00002517          	auipc	a0,0x2
ffffffffc02008b0:	af450513          	addi	a0,a0,-1292 # ffffffffc02023a0 <commands+0x268>
ffffffffc02008b4:	827ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02008b8:	7c0c                	ld	a1,56(s0)
ffffffffc02008ba:	00002517          	auipc	a0,0x2
ffffffffc02008be:	afe50513          	addi	a0,a0,-1282 # ffffffffc02023b8 <commands+0x280>
ffffffffc02008c2:	819ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02008c6:	602c                	ld	a1,64(s0)
ffffffffc02008c8:	00002517          	auipc	a0,0x2
ffffffffc02008cc:	b0850513          	addi	a0,a0,-1272 # ffffffffc02023d0 <commands+0x298>
ffffffffc02008d0:	80bff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02008d4:	642c                	ld	a1,72(s0)
ffffffffc02008d6:	00002517          	auipc	a0,0x2
ffffffffc02008da:	b1250513          	addi	a0,a0,-1262 # ffffffffc02023e8 <commands+0x2b0>
ffffffffc02008de:	ffcff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02008e2:	682c                	ld	a1,80(s0)
ffffffffc02008e4:	00002517          	auipc	a0,0x2
ffffffffc02008e8:	b1c50513          	addi	a0,a0,-1252 # ffffffffc0202400 <commands+0x2c8>
ffffffffc02008ec:	feeff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02008f0:	6c2c                	ld	a1,88(s0)
ffffffffc02008f2:	00002517          	auipc	a0,0x2
ffffffffc02008f6:	b2650513          	addi	a0,a0,-1242 # ffffffffc0202418 <commands+0x2e0>
ffffffffc02008fa:	fe0ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02008fe:	702c                	ld	a1,96(s0)
ffffffffc0200900:	00002517          	auipc	a0,0x2
ffffffffc0200904:	b3050513          	addi	a0,a0,-1232 # ffffffffc0202430 <commands+0x2f8>
ffffffffc0200908:	fd2ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc020090c:	742c                	ld	a1,104(s0)
ffffffffc020090e:	00002517          	auipc	a0,0x2
ffffffffc0200912:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0202448 <commands+0x310>
ffffffffc0200916:	fc4ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc020091a:	782c                	ld	a1,112(s0)
ffffffffc020091c:	00002517          	auipc	a0,0x2
ffffffffc0200920:	b4450513          	addi	a0,a0,-1212 # ffffffffc0202460 <commands+0x328>
ffffffffc0200924:	fb6ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200928:	7c2c                	ld	a1,120(s0)
ffffffffc020092a:	00002517          	auipc	a0,0x2
ffffffffc020092e:	b4e50513          	addi	a0,a0,-1202 # ffffffffc0202478 <commands+0x340>
ffffffffc0200932:	fa8ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200936:	604c                	ld	a1,128(s0)
ffffffffc0200938:	00002517          	auipc	a0,0x2
ffffffffc020093c:	b5850513          	addi	a0,a0,-1192 # ffffffffc0202490 <commands+0x358>
ffffffffc0200940:	f9aff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200944:	644c                	ld	a1,136(s0)
ffffffffc0200946:	00002517          	auipc	a0,0x2
ffffffffc020094a:	b6250513          	addi	a0,a0,-1182 # ffffffffc02024a8 <commands+0x370>
ffffffffc020094e:	f8cff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200952:	684c                	ld	a1,144(s0)
ffffffffc0200954:	00002517          	auipc	a0,0x2
ffffffffc0200958:	b6c50513          	addi	a0,a0,-1172 # ffffffffc02024c0 <commands+0x388>
ffffffffc020095c:	f7eff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200960:	6c4c                	ld	a1,152(s0)
ffffffffc0200962:	00002517          	auipc	a0,0x2
ffffffffc0200966:	b7650513          	addi	a0,a0,-1162 # ffffffffc02024d8 <commands+0x3a0>
ffffffffc020096a:	f70ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc020096e:	704c                	ld	a1,160(s0)
ffffffffc0200970:	00002517          	auipc	a0,0x2
ffffffffc0200974:	b8050513          	addi	a0,a0,-1152 # ffffffffc02024f0 <commands+0x3b8>
ffffffffc0200978:	f62ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc020097c:	744c                	ld	a1,168(s0)
ffffffffc020097e:	00002517          	auipc	a0,0x2
ffffffffc0200982:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0202508 <commands+0x3d0>
ffffffffc0200986:	f54ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc020098a:	784c                	ld	a1,176(s0)
ffffffffc020098c:	00002517          	auipc	a0,0x2
ffffffffc0200990:	b9450513          	addi	a0,a0,-1132 # ffffffffc0202520 <commands+0x3e8>
ffffffffc0200994:	f46ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200998:	7c4c                	ld	a1,184(s0)
ffffffffc020099a:	00002517          	auipc	a0,0x2
ffffffffc020099e:	b9e50513          	addi	a0,a0,-1122 # ffffffffc0202538 <commands+0x400>
ffffffffc02009a2:	f38ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02009a6:	606c                	ld	a1,192(s0)
ffffffffc02009a8:	00002517          	auipc	a0,0x2
ffffffffc02009ac:	ba850513          	addi	a0,a0,-1112 # ffffffffc0202550 <commands+0x418>
ffffffffc02009b0:	f2aff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02009b4:	646c                	ld	a1,200(s0)
ffffffffc02009b6:	00002517          	auipc	a0,0x2
ffffffffc02009ba:	bb250513          	addi	a0,a0,-1102 # ffffffffc0202568 <commands+0x430>
ffffffffc02009be:	f1cff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02009c2:	686c                	ld	a1,208(s0)
ffffffffc02009c4:	00002517          	auipc	a0,0x2
ffffffffc02009c8:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0202580 <commands+0x448>
ffffffffc02009cc:	f0eff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02009d0:	6c6c                	ld	a1,216(s0)
ffffffffc02009d2:	00002517          	auipc	a0,0x2
ffffffffc02009d6:	bc650513          	addi	a0,a0,-1082 # ffffffffc0202598 <commands+0x460>
ffffffffc02009da:	f00ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02009de:	706c                	ld	a1,224(s0)
ffffffffc02009e0:	00002517          	auipc	a0,0x2
ffffffffc02009e4:	bd050513          	addi	a0,a0,-1072 # ffffffffc02025b0 <commands+0x478>
ffffffffc02009e8:	ef2ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02009ec:	746c                	ld	a1,232(s0)
ffffffffc02009ee:	00002517          	auipc	a0,0x2
ffffffffc02009f2:	bda50513          	addi	a0,a0,-1062 # ffffffffc02025c8 <commands+0x490>
ffffffffc02009f6:	ee4ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc02009fa:	786c                	ld	a1,240(s0)
ffffffffc02009fc:	00002517          	auipc	a0,0x2
ffffffffc0200a00:	be450513          	addi	a0,a0,-1052 # ffffffffc02025e0 <commands+0x4a8>
ffffffffc0200a04:	ed6ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a08:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200a0a:	6402                	ld	s0,0(sp)
ffffffffc0200a0c:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a0e:	00002517          	auipc	a0,0x2
ffffffffc0200a12:	bea50513          	addi	a0,a0,-1046 # ffffffffc02025f8 <commands+0x4c0>
}
ffffffffc0200a16:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a18:	ec2ff06f          	j	ffffffffc02000da <cprintf>

ffffffffc0200a1c <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a1c:	1141                	addi	sp,sp,-16
ffffffffc0200a1e:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a20:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a22:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a24:	00002517          	auipc	a0,0x2
ffffffffc0200a28:	bec50513          	addi	a0,a0,-1044 # ffffffffc0202610 <commands+0x4d8>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a2c:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a2e:	eacff0ef          	jal	ra,ffffffffc02000da <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200a32:	8522                	mv	a0,s0
ffffffffc0200a34:	e1bff0ef          	jal	ra,ffffffffc020084e <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200a38:	10043583          	ld	a1,256(s0)
ffffffffc0200a3c:	00002517          	auipc	a0,0x2
ffffffffc0200a40:	bec50513          	addi	a0,a0,-1044 # ffffffffc0202628 <commands+0x4f0>
ffffffffc0200a44:	e96ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200a48:	10843583          	ld	a1,264(s0)
ffffffffc0200a4c:	00002517          	auipc	a0,0x2
ffffffffc0200a50:	bf450513          	addi	a0,a0,-1036 # ffffffffc0202640 <commands+0x508>
ffffffffc0200a54:	e86ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200a58:	11043583          	ld	a1,272(s0)
ffffffffc0200a5c:	00002517          	auipc	a0,0x2
ffffffffc0200a60:	bfc50513          	addi	a0,a0,-1028 # ffffffffc0202658 <commands+0x520>
ffffffffc0200a64:	e76ff0ef          	jal	ra,ffffffffc02000da <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a68:	11843583          	ld	a1,280(s0)
}
ffffffffc0200a6c:	6402                	ld	s0,0(sp)
ffffffffc0200a6e:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a70:	00002517          	auipc	a0,0x2
ffffffffc0200a74:	c0050513          	addi	a0,a0,-1024 # ffffffffc0202670 <commands+0x538>
}
ffffffffc0200a78:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a7a:	e60ff06f          	j	ffffffffc02000da <cprintf>

ffffffffc0200a7e <interrupt_handler>:


volatile size_t num=0;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200a7e:	11853783          	ld	a5,280(a0)
ffffffffc0200a82:	472d                	li	a4,11
ffffffffc0200a84:	0786                	slli	a5,a5,0x1
ffffffffc0200a86:	8385                	srli	a5,a5,0x1
ffffffffc0200a88:	08f76263          	bltu	a4,a5,ffffffffc0200b0c <interrupt_handler+0x8e>
ffffffffc0200a8c:	00002717          	auipc	a4,0x2
ffffffffc0200a90:	cc470713          	addi	a4,a4,-828 # ffffffffc0202750 <commands+0x618>
ffffffffc0200a94:	078a                	slli	a5,a5,0x2
ffffffffc0200a96:	97ba                	add	a5,a5,a4
ffffffffc0200a98:	439c                	lw	a5,0(a5)
ffffffffc0200a9a:	97ba                	add	a5,a5,a4
ffffffffc0200a9c:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200a9e:	00002517          	auipc	a0,0x2
ffffffffc0200aa2:	c4a50513          	addi	a0,a0,-950 # ffffffffc02026e8 <commands+0x5b0>
ffffffffc0200aa6:	e34ff06f          	j	ffffffffc02000da <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200aaa:	00002517          	auipc	a0,0x2
ffffffffc0200aae:	c1e50513          	addi	a0,a0,-994 # ffffffffc02026c8 <commands+0x590>
ffffffffc0200ab2:	e28ff06f          	j	ffffffffc02000da <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200ab6:	00002517          	auipc	a0,0x2
ffffffffc0200aba:	bd250513          	addi	a0,a0,-1070 # ffffffffc0202688 <commands+0x550>
ffffffffc0200abe:	e1cff06f          	j	ffffffffc02000da <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200ac2:	00002517          	auipc	a0,0x2
ffffffffc0200ac6:	c4650513          	addi	a0,a0,-954 # ffffffffc0202708 <commands+0x5d0>
ffffffffc0200aca:	e10ff06f          	j	ffffffffc02000da <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200ace:	1141                	addi	sp,sp,-16
ffffffffc0200ad0:	e406                	sd	ra,8(sp)
            /*(1)设置下次时钟中断- clock_set_next_event()
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            clock_set_next_event();
ffffffffc0200ad2:	991ff0ef          	jal	ra,ffffffffc0200462 <clock_set_next_event>
            ticks++;
ffffffffc0200ad6:	00006797          	auipc	a5,0x6
ffffffffc0200ada:	97278793          	addi	a5,a5,-1678 # ffffffffc0206448 <ticks>
ffffffffc0200ade:	6398                	ld	a4,0(a5)
            if(ticks==TICK_NUM){
ffffffffc0200ae0:	06400693          	li	a3,100
            ticks++;
ffffffffc0200ae4:	0705                	addi	a4,a4,1
ffffffffc0200ae6:	e398                	sd	a4,0(a5)
            if(ticks==TICK_NUM){
ffffffffc0200ae8:	639c                	ld	a5,0(a5)
ffffffffc0200aea:	02d78263          	beq	a5,a3,ffffffffc0200b0e <interrupt_handler+0x90>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200aee:	60a2                	ld	ra,8(sp)
ffffffffc0200af0:	0141                	addi	sp,sp,16
ffffffffc0200af2:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200af4:	00002517          	auipc	a0,0x2
ffffffffc0200af8:	c3c50513          	addi	a0,a0,-964 # ffffffffc0202730 <commands+0x5f8>
ffffffffc0200afc:	ddeff06f          	j	ffffffffc02000da <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200b00:	00002517          	auipc	a0,0x2
ffffffffc0200b04:	ba850513          	addi	a0,a0,-1112 # ffffffffc02026a8 <commands+0x570>
ffffffffc0200b08:	dd2ff06f          	j	ffffffffc02000da <cprintf>
            print_trapframe(tf);
ffffffffc0200b0c:	bf01                	j	ffffffffc0200a1c <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200b0e:	06400593          	li	a1,100
ffffffffc0200b12:	00002517          	auipc	a0,0x2
ffffffffc0200b16:	c0e50513          	addi	a0,a0,-1010 # ffffffffc0202720 <commands+0x5e8>
ffffffffc0200b1a:	dc0ff0ef          	jal	ra,ffffffffc02000da <cprintf>
                ticks=0;
ffffffffc0200b1e:	00006797          	auipc	a5,0x6
ffffffffc0200b22:	9207b523          	sd	zero,-1750(a5) # ffffffffc0206448 <ticks>
                num++;
ffffffffc0200b26:	00006797          	auipc	a5,0x6
ffffffffc0200b2a:	93a78793          	addi	a5,a5,-1734 # ffffffffc0206460 <num>
ffffffffc0200b2e:	6398                	ld	a4,0(a5)
                if(num==10){
ffffffffc0200b30:	46a9                	li	a3,10
                num++;
ffffffffc0200b32:	0705                	addi	a4,a4,1
ffffffffc0200b34:	e398                	sd	a4,0(a5)
                if(num==10){
ffffffffc0200b36:	639c                	ld	a5,0(a5)
ffffffffc0200b38:	fad79be3          	bne	a5,a3,ffffffffc0200aee <interrupt_handler+0x70>
}
ffffffffc0200b3c:	60a2                	ld	ra,8(sp)
ffffffffc0200b3e:	0141                	addi	sp,sp,16
                    sbi_shutdown();
ffffffffc0200b40:	2e40106f          	j	ffffffffc0201e24 <sbi_shutdown>

ffffffffc0200b44 <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200b44:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200b48:	1141                	addi	sp,sp,-16
ffffffffc0200b4a:	e022                	sd	s0,0(sp)
ffffffffc0200b4c:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
ffffffffc0200b4e:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200b50:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc0200b52:	04e78663          	beq	a5,a4,ffffffffc0200b9e <exception_handler+0x5a>
ffffffffc0200b56:	02f76c63          	bltu	a4,a5,ffffffffc0200b8e <exception_handler+0x4a>
ffffffffc0200b5a:	4709                	li	a4,2
ffffffffc0200b5c:	02e79563          	bne	a5,a4,ffffffffc0200b86 <exception_handler+0x42>
             /* LAB3 CHALLENGE3   2312479  */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("Exception type: Illegal instruction\n");
ffffffffc0200b60:	00002517          	auipc	a0,0x2
ffffffffc0200b64:	c2050513          	addi	a0,a0,-992 # ffffffffc0202780 <commands+0x648>
ffffffffc0200b68:	d72ff0ef          	jal	ra,ffffffffc02000da <cprintf>
            cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
ffffffffc0200b6c:	10843583          	ld	a1,264(s0)
ffffffffc0200b70:	00002517          	auipc	a0,0x2
ffffffffc0200b74:	c3850513          	addi	a0,a0,-968 # ffffffffc02027a8 <commands+0x670>
ffffffffc0200b78:	d62ff0ef          	jal	ra,ffffffffc02000da <cprintf>
            tf->epc += 4;   // 跳过非法指令，防止陷入死循环
ffffffffc0200b7c:	10843783          	ld	a5,264(s0)
ffffffffc0200b80:	0791                	addi	a5,a5,4
ffffffffc0200b82:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b86:	60a2                	ld	ra,8(sp)
ffffffffc0200b88:	6402                	ld	s0,0(sp)
ffffffffc0200b8a:	0141                	addi	sp,sp,16
ffffffffc0200b8c:	8082                	ret
    switch (tf->cause) {
ffffffffc0200b8e:	17f1                	addi	a5,a5,-4
ffffffffc0200b90:	471d                	li	a4,7
ffffffffc0200b92:	fef77ae3          	bgeu	a4,a5,ffffffffc0200b86 <exception_handler+0x42>
}
ffffffffc0200b96:	6402                	ld	s0,0(sp)
ffffffffc0200b98:	60a2                	ld	ra,8(sp)
ffffffffc0200b9a:	0141                	addi	sp,sp,16
            print_trapframe(tf);
ffffffffc0200b9c:	b541                	j	ffffffffc0200a1c <print_trapframe>
            cprintf("Exception type: breakpoint\n");///
ffffffffc0200b9e:	00002517          	auipc	a0,0x2
ffffffffc0200ba2:	c3250513          	addi	a0,a0,-974 # ffffffffc02027d0 <commands+0x698>
ffffffffc0200ba6:	d34ff0ef          	jal	ra,ffffffffc02000da <cprintf>
            cprintf("ebreak caught at 0x%08x\n", tf->epc);
ffffffffc0200baa:	10843583          	ld	a1,264(s0)
ffffffffc0200bae:	00002517          	auipc	a0,0x2
ffffffffc0200bb2:	c4250513          	addi	a0,a0,-958 # ffffffffc02027f0 <commands+0x6b8>
ffffffffc0200bb6:	d24ff0ef          	jal	ra,ffffffffc02000da <cprintf>
            tf->epc += 2;//ebreak是2字节指令
ffffffffc0200bba:	10843783          	ld	a5,264(s0)
}
ffffffffc0200bbe:	60a2                	ld	ra,8(sp)
            tf->epc += 2;//ebreak是2字节指令
ffffffffc0200bc0:	0789                	addi	a5,a5,2
ffffffffc0200bc2:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200bc6:	6402                	ld	s0,0(sp)
ffffffffc0200bc8:	0141                	addi	sp,sp,16
ffffffffc0200bca:	8082                	ret

ffffffffc0200bcc <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200bcc:	11853783          	ld	a5,280(a0)
ffffffffc0200bd0:	0007c363          	bltz	a5,ffffffffc0200bd6 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200bd4:	bf85                	j	ffffffffc0200b44 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200bd6:	b565                	j	ffffffffc0200a7e <interrupt_handler>

ffffffffc0200bd8 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200bd8:	14011073          	csrw	sscratch,sp
ffffffffc0200bdc:	712d                	addi	sp,sp,-288
ffffffffc0200bde:	e002                	sd	zero,0(sp)
ffffffffc0200be0:	e406                	sd	ra,8(sp)
ffffffffc0200be2:	ec0e                	sd	gp,24(sp)
ffffffffc0200be4:	f012                	sd	tp,32(sp)
ffffffffc0200be6:	f416                	sd	t0,40(sp)
ffffffffc0200be8:	f81a                	sd	t1,48(sp)
ffffffffc0200bea:	fc1e                	sd	t2,56(sp)
ffffffffc0200bec:	e0a2                	sd	s0,64(sp)
ffffffffc0200bee:	e4a6                	sd	s1,72(sp)
ffffffffc0200bf0:	e8aa                	sd	a0,80(sp)
ffffffffc0200bf2:	ecae                	sd	a1,88(sp)
ffffffffc0200bf4:	f0b2                	sd	a2,96(sp)
ffffffffc0200bf6:	f4b6                	sd	a3,104(sp)
ffffffffc0200bf8:	f8ba                	sd	a4,112(sp)
ffffffffc0200bfa:	fcbe                	sd	a5,120(sp)
ffffffffc0200bfc:	e142                	sd	a6,128(sp)
ffffffffc0200bfe:	e546                	sd	a7,136(sp)
ffffffffc0200c00:	e94a                	sd	s2,144(sp)
ffffffffc0200c02:	ed4e                	sd	s3,152(sp)
ffffffffc0200c04:	f152                	sd	s4,160(sp)
ffffffffc0200c06:	f556                	sd	s5,168(sp)
ffffffffc0200c08:	f95a                	sd	s6,176(sp)
ffffffffc0200c0a:	fd5e                	sd	s7,184(sp)
ffffffffc0200c0c:	e1e2                	sd	s8,192(sp)
ffffffffc0200c0e:	e5e6                	sd	s9,200(sp)
ffffffffc0200c10:	e9ea                	sd	s10,208(sp)
ffffffffc0200c12:	edee                	sd	s11,216(sp)
ffffffffc0200c14:	f1f2                	sd	t3,224(sp)
ffffffffc0200c16:	f5f6                	sd	t4,232(sp)
ffffffffc0200c18:	f9fa                	sd	t5,240(sp)
ffffffffc0200c1a:	fdfe                	sd	t6,248(sp)
ffffffffc0200c1c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c20:	100024f3          	csrr	s1,sstatus
ffffffffc0200c24:	14102973          	csrr	s2,sepc
ffffffffc0200c28:	143029f3          	csrr	s3,stval
ffffffffc0200c2c:	14202a73          	csrr	s4,scause
ffffffffc0200c30:	e822                	sd	s0,16(sp)
ffffffffc0200c32:	e226                	sd	s1,256(sp)
ffffffffc0200c34:	e64a                	sd	s2,264(sp)
ffffffffc0200c36:	ea4e                	sd	s3,272(sp)
ffffffffc0200c38:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200c3a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200c3c:	f91ff0ef          	jal	ra,ffffffffc0200bcc <trap>

ffffffffc0200c40 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200c40:	6492                	ld	s1,256(sp)
ffffffffc0200c42:	6932                	ld	s2,264(sp)
ffffffffc0200c44:	10049073          	csrw	sstatus,s1
ffffffffc0200c48:	14191073          	csrw	sepc,s2
ffffffffc0200c4c:	60a2                	ld	ra,8(sp)
ffffffffc0200c4e:	61e2                	ld	gp,24(sp)
ffffffffc0200c50:	7202                	ld	tp,32(sp)
ffffffffc0200c52:	72a2                	ld	t0,40(sp)
ffffffffc0200c54:	7342                	ld	t1,48(sp)
ffffffffc0200c56:	73e2                	ld	t2,56(sp)
ffffffffc0200c58:	6406                	ld	s0,64(sp)
ffffffffc0200c5a:	64a6                	ld	s1,72(sp)
ffffffffc0200c5c:	6546                	ld	a0,80(sp)
ffffffffc0200c5e:	65e6                	ld	a1,88(sp)
ffffffffc0200c60:	7606                	ld	a2,96(sp)
ffffffffc0200c62:	76a6                	ld	a3,104(sp)
ffffffffc0200c64:	7746                	ld	a4,112(sp)
ffffffffc0200c66:	77e6                	ld	a5,120(sp)
ffffffffc0200c68:	680a                	ld	a6,128(sp)
ffffffffc0200c6a:	68aa                	ld	a7,136(sp)
ffffffffc0200c6c:	694a                	ld	s2,144(sp)
ffffffffc0200c6e:	69ea                	ld	s3,152(sp)
ffffffffc0200c70:	7a0a                	ld	s4,160(sp)
ffffffffc0200c72:	7aaa                	ld	s5,168(sp)
ffffffffc0200c74:	7b4a                	ld	s6,176(sp)
ffffffffc0200c76:	7bea                	ld	s7,184(sp)
ffffffffc0200c78:	6c0e                	ld	s8,192(sp)
ffffffffc0200c7a:	6cae                	ld	s9,200(sp)
ffffffffc0200c7c:	6d4e                	ld	s10,208(sp)
ffffffffc0200c7e:	6dee                	ld	s11,216(sp)
ffffffffc0200c80:	7e0e                	ld	t3,224(sp)
ffffffffc0200c82:	7eae                	ld	t4,232(sp)
ffffffffc0200c84:	7f4e                	ld	t5,240(sp)
ffffffffc0200c86:	7fee                	ld	t6,248(sp)
ffffffffc0200c88:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200c8a:	10200073          	sret

ffffffffc0200c8e <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200c8e:	00005797          	auipc	a5,0x5
ffffffffc0200c92:	39a78793          	addi	a5,a5,922 # ffffffffc0206028 <free_area>
ffffffffc0200c96:	e79c                	sd	a5,8(a5)
ffffffffc0200c98:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200c9a:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200c9e:	8082                	ret

ffffffffc0200ca0 <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200ca0:	00005517          	auipc	a0,0x5
ffffffffc0200ca4:	39856503          	lwu	a0,920(a0) # ffffffffc0206038 <free_area+0x10>
ffffffffc0200ca8:	8082                	ret

ffffffffc0200caa <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc0200caa:	c14d                	beqz	a0,ffffffffc0200d4c <best_fit_alloc_pages+0xa2>
    if (n > nr_free) {
ffffffffc0200cac:	00005617          	auipc	a2,0x5
ffffffffc0200cb0:	37c60613          	addi	a2,a2,892 # ffffffffc0206028 <free_area>
ffffffffc0200cb4:	01062803          	lw	a6,16(a2)
ffffffffc0200cb8:	86aa                	mv	a3,a0
ffffffffc0200cba:	02081793          	slli	a5,a6,0x20
ffffffffc0200cbe:	9381                	srli	a5,a5,0x20
ffffffffc0200cc0:	08a7e463          	bltu	a5,a0,ffffffffc0200d48 <best_fit_alloc_pages+0x9e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200cc4:	661c                	ld	a5,8(a2)
    size_t min_size = nr_free + 1;
ffffffffc0200cc6:	0018059b          	addiw	a1,a6,1
ffffffffc0200cca:	1582                	slli	a1,a1,0x20
ffffffffc0200ccc:	9181                	srli	a1,a1,0x20
    struct Page *page = NULL;
ffffffffc0200cce:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list)
ffffffffc0200cd0:	06c78b63          	beq	a5,a2,ffffffffc0200d46 <best_fit_alloc_pages+0x9c>
        if (p->property >= n && p->property < min_size)
ffffffffc0200cd4:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0200cd8:	00d76763          	bltu	a4,a3,ffffffffc0200ce6 <best_fit_alloc_pages+0x3c>
ffffffffc0200cdc:	00b77563          	bgeu	a4,a1,ffffffffc0200ce6 <best_fit_alloc_pages+0x3c>
        struct Page *p = le2page(le, page_link);
ffffffffc0200ce0:	fe878513          	addi	a0,a5,-24
ffffffffc0200ce4:	85ba                	mv	a1,a4
ffffffffc0200ce6:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0200ce8:	fec796e3          	bne	a5,a2,ffffffffc0200cd4 <best_fit_alloc_pages+0x2a>
    if (page != NULL) {
ffffffffc0200cec:	cd29                	beqz	a0,ffffffffc0200d46 <best_fit_alloc_pages+0x9c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200cee:	711c                	ld	a5,32(a0)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc0200cf0:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
ffffffffc0200cf2:	490c                	lw	a1,16(a0)
            p->property = page->property - n;
ffffffffc0200cf4:	0006889b          	sext.w	a7,a3
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200cf8:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200cfa:	e398                	sd	a4,0(a5)
        if (page->property > n) {
ffffffffc0200cfc:	02059793          	slli	a5,a1,0x20
ffffffffc0200d00:	9381                	srli	a5,a5,0x20
ffffffffc0200d02:	02f6f863          	bgeu	a3,a5,ffffffffc0200d32 <best_fit_alloc_pages+0x88>
            struct Page *p = page + n;
ffffffffc0200d06:	00269793          	slli	a5,a3,0x2
ffffffffc0200d0a:	97b6                	add	a5,a5,a3
ffffffffc0200d0c:	078e                	slli	a5,a5,0x3
ffffffffc0200d0e:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
ffffffffc0200d10:	411585bb          	subw	a1,a1,a7
ffffffffc0200d14:	cb8c                	sw	a1,16(a5)
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200d16:	4689                	li	a3,2
ffffffffc0200d18:	00878593          	addi	a1,a5,8
ffffffffc0200d1c:	40d5b02f          	amoor.d	zero,a3,(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200d20:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc0200d22:	01878593          	addi	a1,a5,24
        nr_free -= n;
ffffffffc0200d26:	01062803          	lw	a6,16(a2)
    prev->next = next->prev = elm;
ffffffffc0200d2a:	e28c                	sd	a1,0(a3)
ffffffffc0200d2c:	e70c                	sd	a1,8(a4)
    elm->next = next;
ffffffffc0200d2e:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc0200d30:	ef98                	sd	a4,24(a5)
ffffffffc0200d32:	4118083b          	subw	a6,a6,a7
ffffffffc0200d36:	01062823          	sw	a6,16(a2)
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void clear_bit(int nr, volatile void *addr) {
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200d3a:	57f5                	li	a5,-3
ffffffffc0200d3c:	00850713          	addi	a4,a0,8
ffffffffc0200d40:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc0200d44:	8082                	ret
}
ffffffffc0200d46:	8082                	ret
        return NULL;
ffffffffc0200d48:	4501                	li	a0,0
ffffffffc0200d4a:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc0200d4c:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200d4e:	00002697          	auipc	a3,0x2
ffffffffc0200d52:	ac268693          	addi	a3,a3,-1342 # ffffffffc0202810 <commands+0x6d8>
ffffffffc0200d56:	00002617          	auipc	a2,0x2
ffffffffc0200d5a:	ac260613          	addi	a2,a2,-1342 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0200d5e:	06800593          	li	a1,104
ffffffffc0200d62:	00002517          	auipc	a0,0x2
ffffffffc0200d66:	ace50513          	addi	a0,a0,-1330 # ffffffffc0202830 <commands+0x6f8>
best_fit_alloc_pages(size_t n) {
ffffffffc0200d6a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200d6c:	e68ff0ef          	jal	ra,ffffffffc02003d4 <__panic>

ffffffffc0200d70 <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200d70:	715d                	addi	sp,sp,-80
ffffffffc0200d72:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0200d74:	00005417          	auipc	s0,0x5
ffffffffc0200d78:	2b440413          	addi	s0,s0,692 # ffffffffc0206028 <free_area>
ffffffffc0200d7c:	641c                	ld	a5,8(s0)
ffffffffc0200d7e:	e486                	sd	ra,72(sp)
ffffffffc0200d80:	fc26                	sd	s1,56(sp)
ffffffffc0200d82:	f84a                	sd	s2,48(sp)
ffffffffc0200d84:	f44e                	sd	s3,40(sp)
ffffffffc0200d86:	f052                	sd	s4,32(sp)
ffffffffc0200d88:	ec56                	sd	s5,24(sp)
ffffffffc0200d8a:	e85a                	sd	s6,16(sp)
ffffffffc0200d8c:	e45e                	sd	s7,8(sp)
ffffffffc0200d8e:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d90:	26878b63          	beq	a5,s0,ffffffffc0201006 <best_fit_check+0x296>
    int count = 0, total = 0;
ffffffffc0200d94:	4481                	li	s1,0
ffffffffc0200d96:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200d98:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200d9c:	8b09                	andi	a4,a4,2
ffffffffc0200d9e:	26070863          	beqz	a4,ffffffffc020100e <best_fit_check+0x29e>
        count ++, total += p->property;
ffffffffc0200da2:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200da6:	679c                	ld	a5,8(a5)
ffffffffc0200da8:	2905                	addiw	s2,s2,1
ffffffffc0200daa:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200dac:	fe8796e3          	bne	a5,s0,ffffffffc0200d98 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200db0:	89a6                	mv	s3,s1
ffffffffc0200db2:	167000ef          	jal	ra,ffffffffc0201718 <nr_free_pages>
ffffffffc0200db6:	33351c63          	bne	a0,s3,ffffffffc02010ee <best_fit_check+0x37e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200dba:	4505                	li	a0,1
ffffffffc0200dbc:	0df000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200dc0:	8a2a                	mv	s4,a0
ffffffffc0200dc2:	36050663          	beqz	a0,ffffffffc020112e <best_fit_check+0x3be>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200dc6:	4505                	li	a0,1
ffffffffc0200dc8:	0d3000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200dcc:	89aa                	mv	s3,a0
ffffffffc0200dce:	34050063          	beqz	a0,ffffffffc020110e <best_fit_check+0x39e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200dd2:	4505                	li	a0,1
ffffffffc0200dd4:	0c7000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200dd8:	8aaa                	mv	s5,a0
ffffffffc0200dda:	2c050a63          	beqz	a0,ffffffffc02010ae <best_fit_check+0x33e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200dde:	253a0863          	beq	s4,s3,ffffffffc020102e <best_fit_check+0x2be>
ffffffffc0200de2:	24aa0663          	beq	s4,a0,ffffffffc020102e <best_fit_check+0x2be>
ffffffffc0200de6:	24a98463          	beq	s3,a0,ffffffffc020102e <best_fit_check+0x2be>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200dea:	000a2783          	lw	a5,0(s4)
ffffffffc0200dee:	26079063          	bnez	a5,ffffffffc020104e <best_fit_check+0x2de>
ffffffffc0200df2:	0009a783          	lw	a5,0(s3)
ffffffffc0200df6:	24079c63          	bnez	a5,ffffffffc020104e <best_fit_check+0x2de>
ffffffffc0200dfa:	411c                	lw	a5,0(a0)
ffffffffc0200dfc:	24079963          	bnez	a5,ffffffffc020104e <best_fit_check+0x2de>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200e00:	00005797          	auipc	a5,0x5
ffffffffc0200e04:	6707b783          	ld	a5,1648(a5) # ffffffffc0206470 <pages>
ffffffffc0200e08:	40fa0733          	sub	a4,s4,a5
ffffffffc0200e0c:	870d                	srai	a4,a4,0x3
ffffffffc0200e0e:	00002597          	auipc	a1,0x2
ffffffffc0200e12:	1125b583          	ld	a1,274(a1) # ffffffffc0202f20 <error_string+0x38>
ffffffffc0200e16:	02b70733          	mul	a4,a4,a1
ffffffffc0200e1a:	00002617          	auipc	a2,0x2
ffffffffc0200e1e:	10e63603          	ld	a2,270(a2) # ffffffffc0202f28 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200e22:	00005697          	auipc	a3,0x5
ffffffffc0200e26:	6466b683          	ld	a3,1606(a3) # ffffffffc0206468 <npage>
ffffffffc0200e2a:	06b2                	slli	a3,a3,0xc
ffffffffc0200e2c:	9732                	add	a4,a4,a2

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e2e:	0732                	slli	a4,a4,0xc
ffffffffc0200e30:	22d77f63          	bgeu	a4,a3,ffffffffc020106e <best_fit_check+0x2fe>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200e34:	40f98733          	sub	a4,s3,a5
ffffffffc0200e38:	870d                	srai	a4,a4,0x3
ffffffffc0200e3a:	02b70733          	mul	a4,a4,a1
ffffffffc0200e3e:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e40:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200e42:	3ed77663          	bgeu	a4,a3,ffffffffc020122e <best_fit_check+0x4be>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200e46:	40f507b3          	sub	a5,a0,a5
ffffffffc0200e4a:	878d                	srai	a5,a5,0x3
ffffffffc0200e4c:	02b787b3          	mul	a5,a5,a1
ffffffffc0200e50:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e52:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200e54:	3ad7fd63          	bgeu	a5,a3,ffffffffc020120e <best_fit_check+0x49e>
    assert(alloc_page() == NULL);
ffffffffc0200e58:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e5a:	00043c03          	ld	s8,0(s0)
ffffffffc0200e5e:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200e62:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200e66:	e400                	sd	s0,8(s0)
ffffffffc0200e68:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200e6a:	00005797          	auipc	a5,0x5
ffffffffc0200e6e:	1c07a723          	sw	zero,462(a5) # ffffffffc0206038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200e72:	029000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200e76:	36051c63          	bnez	a0,ffffffffc02011ee <best_fit_check+0x47e>
    free_page(p0);
ffffffffc0200e7a:	4585                	li	a1,1
ffffffffc0200e7c:	8552                	mv	a0,s4
ffffffffc0200e7e:	05b000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    free_page(p1);
ffffffffc0200e82:	4585                	li	a1,1
ffffffffc0200e84:	854e                	mv	a0,s3
ffffffffc0200e86:	053000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    free_page(p2);
ffffffffc0200e8a:	4585                	li	a1,1
ffffffffc0200e8c:	8556                	mv	a0,s5
ffffffffc0200e8e:	04b000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    assert(nr_free == 3);
ffffffffc0200e92:	4818                	lw	a4,16(s0)
ffffffffc0200e94:	478d                	li	a5,3
ffffffffc0200e96:	32f71c63          	bne	a4,a5,ffffffffc02011ce <best_fit_check+0x45e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e9a:	4505                	li	a0,1
ffffffffc0200e9c:	7fe000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200ea0:	89aa                	mv	s3,a0
ffffffffc0200ea2:	30050663          	beqz	a0,ffffffffc02011ae <best_fit_check+0x43e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ea6:	4505                	li	a0,1
ffffffffc0200ea8:	7f2000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200eac:	8aaa                	mv	s5,a0
ffffffffc0200eae:	2e050063          	beqz	a0,ffffffffc020118e <best_fit_check+0x41e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200eb2:	4505                	li	a0,1
ffffffffc0200eb4:	7e6000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200eb8:	8a2a                	mv	s4,a0
ffffffffc0200eba:	2a050a63          	beqz	a0,ffffffffc020116e <best_fit_check+0x3fe>
    assert(alloc_page() == NULL);
ffffffffc0200ebe:	4505                	li	a0,1
ffffffffc0200ec0:	7da000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200ec4:	28051563          	bnez	a0,ffffffffc020114e <best_fit_check+0x3de>
    free_page(p0);
ffffffffc0200ec8:	4585                	li	a1,1
ffffffffc0200eca:	854e                	mv	a0,s3
ffffffffc0200ecc:	00d000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200ed0:	641c                	ld	a5,8(s0)
ffffffffc0200ed2:	1a878e63          	beq	a5,s0,ffffffffc020108e <best_fit_check+0x31e>
    assert((p = alloc_page()) == p0);
ffffffffc0200ed6:	4505                	li	a0,1
ffffffffc0200ed8:	7c2000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200edc:	52a99963          	bne	s3,a0,ffffffffc020140e <best_fit_check+0x69e>
    assert(alloc_page() == NULL);
ffffffffc0200ee0:	4505                	li	a0,1
ffffffffc0200ee2:	7b8000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200ee6:	50051463          	bnez	a0,ffffffffc02013ee <best_fit_check+0x67e>
    assert(nr_free == 0);
ffffffffc0200eea:	481c                	lw	a5,16(s0)
ffffffffc0200eec:	4e079163          	bnez	a5,ffffffffc02013ce <best_fit_check+0x65e>
    free_page(p);
ffffffffc0200ef0:	854e                	mv	a0,s3
ffffffffc0200ef2:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200ef4:	01843023          	sd	s8,0(s0)
ffffffffc0200ef8:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200efc:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200f00:	7d8000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    free_page(p1);
ffffffffc0200f04:	4585                	li	a1,1
ffffffffc0200f06:	8556                	mv	a0,s5
ffffffffc0200f08:	7d0000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    free_page(p2);
ffffffffc0200f0c:	4585                	li	a1,1
ffffffffc0200f0e:	8552                	mv	a0,s4
ffffffffc0200f10:	7c8000ef          	jal	ra,ffffffffc02016d8 <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200f14:	4515                	li	a0,5
ffffffffc0200f16:	784000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200f1a:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200f1c:	48050963          	beqz	a0,ffffffffc02013ae <best_fit_check+0x63e>
ffffffffc0200f20:	651c                	ld	a5,8(a0)
ffffffffc0200f22:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200f24:	8b85                	andi	a5,a5,1
ffffffffc0200f26:	46079463          	bnez	a5,ffffffffc020138e <best_fit_check+0x61e>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200f2a:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f2c:	00043a83          	ld	s5,0(s0)
ffffffffc0200f30:	00843a03          	ld	s4,8(s0)
ffffffffc0200f34:	e000                	sd	s0,0(s0)
ffffffffc0200f36:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200f38:	762000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200f3c:	42051963          	bnez	a0,ffffffffc020136e <best_fit_check+0x5fe>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200f40:	4589                	li	a1,2
ffffffffc0200f42:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200f46:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
ffffffffc0200f4a:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc0200f4e:	00005797          	auipc	a5,0x5
ffffffffc0200f52:	0e07a523          	sw	zero,234(a5) # ffffffffc0206038 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200f56:	782000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200f5a:	8562                	mv	a0,s8
ffffffffc0200f5c:	4585                	li	a1,1
ffffffffc0200f5e:	77a000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200f62:	4511                	li	a0,4
ffffffffc0200f64:	736000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200f68:	3e051363          	bnez	a0,ffffffffc020134e <best_fit_check+0x5de>
ffffffffc0200f6c:	0309b783          	ld	a5,48(s3)
ffffffffc0200f70:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200f72:	8b85                	andi	a5,a5,1
ffffffffc0200f74:	3a078d63          	beqz	a5,ffffffffc020132e <best_fit_check+0x5be>
ffffffffc0200f78:	0389a703          	lw	a4,56(s3)
ffffffffc0200f7c:	4789                	li	a5,2
ffffffffc0200f7e:	3af71863          	bne	a4,a5,ffffffffc020132e <best_fit_check+0x5be>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200f82:	4505                	li	a0,1
ffffffffc0200f84:	716000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200f88:	8baa                	mv	s7,a0
ffffffffc0200f8a:	38050263          	beqz	a0,ffffffffc020130e <best_fit_check+0x59e>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200f8e:	4509                	li	a0,2
ffffffffc0200f90:	70a000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200f94:	34050d63          	beqz	a0,ffffffffc02012ee <best_fit_check+0x57e>
    assert(p0 + 4 == p1);
ffffffffc0200f98:	337c1b63          	bne	s8,s7,ffffffffc02012ce <best_fit_check+0x55e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200f9c:	854e                	mv	a0,s3
ffffffffc0200f9e:	4595                	li	a1,5
ffffffffc0200fa0:	738000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200fa4:	4515                	li	a0,5
ffffffffc0200fa6:	6f4000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200faa:	89aa                	mv	s3,a0
ffffffffc0200fac:	30050163          	beqz	a0,ffffffffc02012ae <best_fit_check+0x53e>
    assert(alloc_page() == NULL);
ffffffffc0200fb0:	4505                	li	a0,1
ffffffffc0200fb2:	6e8000ef          	jal	ra,ffffffffc020169a <alloc_pages>
ffffffffc0200fb6:	2c051c63          	bnez	a0,ffffffffc020128e <best_fit_check+0x51e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200fba:	481c                	lw	a5,16(s0)
ffffffffc0200fbc:	2a079963          	bnez	a5,ffffffffc020126e <best_fit_check+0x4fe>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200fc0:	4595                	li	a1,5
ffffffffc0200fc2:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200fc4:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
ffffffffc0200fc8:	01543023          	sd	s5,0(s0)
ffffffffc0200fcc:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
ffffffffc0200fd0:	708000ef          	jal	ra,ffffffffc02016d8 <free_pages>
    return listelm->next;
ffffffffc0200fd4:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fd6:	00878963          	beq	a5,s0,ffffffffc0200fe8 <best_fit_check+0x278>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200fda:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200fde:	679c                	ld	a5,8(a5)
ffffffffc0200fe0:	397d                	addiw	s2,s2,-1
ffffffffc0200fe2:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fe4:	fe879be3          	bne	a5,s0,ffffffffc0200fda <best_fit_check+0x26a>
    }
    assert(count == 0);
ffffffffc0200fe8:	26091363          	bnez	s2,ffffffffc020124e <best_fit_check+0x4de>
    assert(total == 0);
ffffffffc0200fec:	e0ed                	bnez	s1,ffffffffc02010ce <best_fit_check+0x35e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200fee:	60a6                	ld	ra,72(sp)
ffffffffc0200ff0:	6406                	ld	s0,64(sp)
ffffffffc0200ff2:	74e2                	ld	s1,56(sp)
ffffffffc0200ff4:	7942                	ld	s2,48(sp)
ffffffffc0200ff6:	79a2                	ld	s3,40(sp)
ffffffffc0200ff8:	7a02                	ld	s4,32(sp)
ffffffffc0200ffa:	6ae2                	ld	s5,24(sp)
ffffffffc0200ffc:	6b42                	ld	s6,16(sp)
ffffffffc0200ffe:	6ba2                	ld	s7,8(sp)
ffffffffc0201000:	6c02                	ld	s8,0(sp)
ffffffffc0201002:	6161                	addi	sp,sp,80
ffffffffc0201004:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201006:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201008:	4481                	li	s1,0
ffffffffc020100a:	4901                	li	s2,0
ffffffffc020100c:	b35d                	j	ffffffffc0200db2 <best_fit_check+0x42>
        assert(PageProperty(p));
ffffffffc020100e:	00002697          	auipc	a3,0x2
ffffffffc0201012:	83a68693          	addi	a3,a3,-1990 # ffffffffc0202848 <commands+0x710>
ffffffffc0201016:	00002617          	auipc	a2,0x2
ffffffffc020101a:	80260613          	addi	a2,a2,-2046 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020101e:	10800593          	li	a1,264
ffffffffc0201022:	00002517          	auipc	a0,0x2
ffffffffc0201026:	80e50513          	addi	a0,a0,-2034 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020102a:	baaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020102e:	00002697          	auipc	a3,0x2
ffffffffc0201032:	8aa68693          	addi	a3,a3,-1878 # ffffffffc02028d8 <commands+0x7a0>
ffffffffc0201036:	00001617          	auipc	a2,0x1
ffffffffc020103a:	7e260613          	addi	a2,a2,2018 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020103e:	0d400593          	li	a1,212
ffffffffc0201042:	00001517          	auipc	a0,0x1
ffffffffc0201046:	7ee50513          	addi	a0,a0,2030 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020104a:	b8aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020104e:	00002697          	auipc	a3,0x2
ffffffffc0201052:	8b268693          	addi	a3,a3,-1870 # ffffffffc0202900 <commands+0x7c8>
ffffffffc0201056:	00001617          	auipc	a2,0x1
ffffffffc020105a:	7c260613          	addi	a2,a2,1986 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020105e:	0d500593          	li	a1,213
ffffffffc0201062:	00001517          	auipc	a0,0x1
ffffffffc0201066:	7ce50513          	addi	a0,a0,1998 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020106a:	b6aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020106e:	00002697          	auipc	a3,0x2
ffffffffc0201072:	8d268693          	addi	a3,a3,-1838 # ffffffffc0202940 <commands+0x808>
ffffffffc0201076:	00001617          	auipc	a2,0x1
ffffffffc020107a:	7a260613          	addi	a2,a2,1954 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020107e:	0d700593          	li	a1,215
ffffffffc0201082:	00001517          	auipc	a0,0x1
ffffffffc0201086:	7ae50513          	addi	a0,a0,1966 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020108a:	b4aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(!list_empty(&free_list));
ffffffffc020108e:	00002697          	auipc	a3,0x2
ffffffffc0201092:	93a68693          	addi	a3,a3,-1734 # ffffffffc02029c8 <commands+0x890>
ffffffffc0201096:	00001617          	auipc	a2,0x1
ffffffffc020109a:	78260613          	addi	a2,a2,1922 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020109e:	0f000593          	li	a1,240
ffffffffc02010a2:	00001517          	auipc	a0,0x1
ffffffffc02010a6:	78e50513          	addi	a0,a0,1934 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02010aa:	b2aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010ae:	00002697          	auipc	a3,0x2
ffffffffc02010b2:	80a68693          	addi	a3,a3,-2038 # ffffffffc02028b8 <commands+0x780>
ffffffffc02010b6:	00001617          	auipc	a2,0x1
ffffffffc02010ba:	76260613          	addi	a2,a2,1890 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02010be:	0d200593          	li	a1,210
ffffffffc02010c2:	00001517          	auipc	a0,0x1
ffffffffc02010c6:	76e50513          	addi	a0,a0,1902 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02010ca:	b0aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(total == 0);
ffffffffc02010ce:	00002697          	auipc	a3,0x2
ffffffffc02010d2:	a2a68693          	addi	a3,a3,-1494 # ffffffffc0202af8 <commands+0x9c0>
ffffffffc02010d6:	00001617          	auipc	a2,0x1
ffffffffc02010da:	74260613          	addi	a2,a2,1858 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02010de:	14a00593          	li	a1,330
ffffffffc02010e2:	00001517          	auipc	a0,0x1
ffffffffc02010e6:	74e50513          	addi	a0,a0,1870 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02010ea:	aeaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(total == nr_free_pages());
ffffffffc02010ee:	00001697          	auipc	a3,0x1
ffffffffc02010f2:	76a68693          	addi	a3,a3,1898 # ffffffffc0202858 <commands+0x720>
ffffffffc02010f6:	00001617          	auipc	a2,0x1
ffffffffc02010fa:	72260613          	addi	a2,a2,1826 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02010fe:	10b00593          	li	a1,267
ffffffffc0201102:	00001517          	auipc	a0,0x1
ffffffffc0201106:	72e50513          	addi	a0,a0,1838 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020110a:	acaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020110e:	00001697          	auipc	a3,0x1
ffffffffc0201112:	78a68693          	addi	a3,a3,1930 # ffffffffc0202898 <commands+0x760>
ffffffffc0201116:	00001617          	auipc	a2,0x1
ffffffffc020111a:	70260613          	addi	a2,a2,1794 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020111e:	0d100593          	li	a1,209
ffffffffc0201122:	00001517          	auipc	a0,0x1
ffffffffc0201126:	70e50513          	addi	a0,a0,1806 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020112a:	aaaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020112e:	00001697          	auipc	a3,0x1
ffffffffc0201132:	74a68693          	addi	a3,a3,1866 # ffffffffc0202878 <commands+0x740>
ffffffffc0201136:	00001617          	auipc	a2,0x1
ffffffffc020113a:	6e260613          	addi	a2,a2,1762 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020113e:	0d000593          	li	a1,208
ffffffffc0201142:	00001517          	auipc	a0,0x1
ffffffffc0201146:	6ee50513          	addi	a0,a0,1774 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020114a:	a8aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020114e:	00002697          	auipc	a3,0x2
ffffffffc0201152:	85268693          	addi	a3,a3,-1966 # ffffffffc02029a0 <commands+0x868>
ffffffffc0201156:	00001617          	auipc	a2,0x1
ffffffffc020115a:	6c260613          	addi	a2,a2,1730 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020115e:	0ed00593          	li	a1,237
ffffffffc0201162:	00001517          	auipc	a0,0x1
ffffffffc0201166:	6ce50513          	addi	a0,a0,1742 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020116a:	a6aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020116e:	00001697          	auipc	a3,0x1
ffffffffc0201172:	74a68693          	addi	a3,a3,1866 # ffffffffc02028b8 <commands+0x780>
ffffffffc0201176:	00001617          	auipc	a2,0x1
ffffffffc020117a:	6a260613          	addi	a2,a2,1698 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020117e:	0eb00593          	li	a1,235
ffffffffc0201182:	00001517          	auipc	a0,0x1
ffffffffc0201186:	6ae50513          	addi	a0,a0,1710 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020118a:	a4aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020118e:	00001697          	auipc	a3,0x1
ffffffffc0201192:	70a68693          	addi	a3,a3,1802 # ffffffffc0202898 <commands+0x760>
ffffffffc0201196:	00001617          	auipc	a2,0x1
ffffffffc020119a:	68260613          	addi	a2,a2,1666 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020119e:	0ea00593          	li	a1,234
ffffffffc02011a2:	00001517          	auipc	a0,0x1
ffffffffc02011a6:	68e50513          	addi	a0,a0,1678 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02011aa:	a2aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011ae:	00001697          	auipc	a3,0x1
ffffffffc02011b2:	6ca68693          	addi	a3,a3,1738 # ffffffffc0202878 <commands+0x740>
ffffffffc02011b6:	00001617          	auipc	a2,0x1
ffffffffc02011ba:	66260613          	addi	a2,a2,1634 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02011be:	0e900593          	li	a1,233
ffffffffc02011c2:	00001517          	auipc	a0,0x1
ffffffffc02011c6:	66e50513          	addi	a0,a0,1646 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02011ca:	a0aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(nr_free == 3);
ffffffffc02011ce:	00001697          	auipc	a3,0x1
ffffffffc02011d2:	7ea68693          	addi	a3,a3,2026 # ffffffffc02029b8 <commands+0x880>
ffffffffc02011d6:	00001617          	auipc	a2,0x1
ffffffffc02011da:	64260613          	addi	a2,a2,1602 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02011de:	0e700593          	li	a1,231
ffffffffc02011e2:	00001517          	auipc	a0,0x1
ffffffffc02011e6:	64e50513          	addi	a0,a0,1614 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02011ea:	9eaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011ee:	00001697          	auipc	a3,0x1
ffffffffc02011f2:	7b268693          	addi	a3,a3,1970 # ffffffffc02029a0 <commands+0x868>
ffffffffc02011f6:	00001617          	auipc	a2,0x1
ffffffffc02011fa:	62260613          	addi	a2,a2,1570 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02011fe:	0e200593          	li	a1,226
ffffffffc0201202:	00001517          	auipc	a0,0x1
ffffffffc0201206:	62e50513          	addi	a0,a0,1582 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020120a:	9caff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020120e:	00001697          	auipc	a3,0x1
ffffffffc0201212:	77268693          	addi	a3,a3,1906 # ffffffffc0202980 <commands+0x848>
ffffffffc0201216:	00001617          	auipc	a2,0x1
ffffffffc020121a:	60260613          	addi	a2,a2,1538 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020121e:	0d900593          	li	a1,217
ffffffffc0201222:	00001517          	auipc	a0,0x1
ffffffffc0201226:	60e50513          	addi	a0,a0,1550 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020122a:	9aaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020122e:	00001697          	auipc	a3,0x1
ffffffffc0201232:	73268693          	addi	a3,a3,1842 # ffffffffc0202960 <commands+0x828>
ffffffffc0201236:	00001617          	auipc	a2,0x1
ffffffffc020123a:	5e260613          	addi	a2,a2,1506 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020123e:	0d800593          	li	a1,216
ffffffffc0201242:	00001517          	auipc	a0,0x1
ffffffffc0201246:	5ee50513          	addi	a0,a0,1518 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020124a:	98aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(count == 0);
ffffffffc020124e:	00002697          	auipc	a3,0x2
ffffffffc0201252:	89a68693          	addi	a3,a3,-1894 # ffffffffc0202ae8 <commands+0x9b0>
ffffffffc0201256:	00001617          	auipc	a2,0x1
ffffffffc020125a:	5c260613          	addi	a2,a2,1474 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020125e:	14900593          	li	a1,329
ffffffffc0201262:	00001517          	auipc	a0,0x1
ffffffffc0201266:	5ce50513          	addi	a0,a0,1486 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020126a:	96aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(nr_free == 0);
ffffffffc020126e:	00001697          	auipc	a3,0x1
ffffffffc0201272:	79268693          	addi	a3,a3,1938 # ffffffffc0202a00 <commands+0x8c8>
ffffffffc0201276:	00001617          	auipc	a2,0x1
ffffffffc020127a:	5a260613          	addi	a2,a2,1442 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020127e:	13e00593          	li	a1,318
ffffffffc0201282:	00001517          	auipc	a0,0x1
ffffffffc0201286:	5ae50513          	addi	a0,a0,1454 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020128a:	94aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020128e:	00001697          	auipc	a3,0x1
ffffffffc0201292:	71268693          	addi	a3,a3,1810 # ffffffffc02029a0 <commands+0x868>
ffffffffc0201296:	00001617          	auipc	a2,0x1
ffffffffc020129a:	58260613          	addi	a2,a2,1410 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020129e:	13800593          	li	a1,312
ffffffffc02012a2:	00001517          	auipc	a0,0x1
ffffffffc02012a6:	58e50513          	addi	a0,a0,1422 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02012aa:	92aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02012ae:	00002697          	auipc	a3,0x2
ffffffffc02012b2:	81a68693          	addi	a3,a3,-2022 # ffffffffc0202ac8 <commands+0x990>
ffffffffc02012b6:	00001617          	auipc	a2,0x1
ffffffffc02012ba:	56260613          	addi	a2,a2,1378 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02012be:	13700593          	li	a1,311
ffffffffc02012c2:	00001517          	auipc	a0,0x1
ffffffffc02012c6:	56e50513          	addi	a0,a0,1390 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02012ca:	90aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(p0 + 4 == p1);
ffffffffc02012ce:	00001697          	auipc	a3,0x1
ffffffffc02012d2:	7ea68693          	addi	a3,a3,2026 # ffffffffc0202ab8 <commands+0x980>
ffffffffc02012d6:	00001617          	auipc	a2,0x1
ffffffffc02012da:	54260613          	addi	a2,a2,1346 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02012de:	12f00593          	li	a1,303
ffffffffc02012e2:	00001517          	auipc	a0,0x1
ffffffffc02012e6:	54e50513          	addi	a0,a0,1358 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02012ea:	8eaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc02012ee:	00001697          	auipc	a3,0x1
ffffffffc02012f2:	7b268693          	addi	a3,a3,1970 # ffffffffc0202aa0 <commands+0x968>
ffffffffc02012f6:	00001617          	auipc	a2,0x1
ffffffffc02012fa:	52260613          	addi	a2,a2,1314 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02012fe:	12e00593          	li	a1,302
ffffffffc0201302:	00001517          	auipc	a0,0x1
ffffffffc0201306:	52e50513          	addi	a0,a0,1326 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020130a:	8caff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc020130e:	00001697          	auipc	a3,0x1
ffffffffc0201312:	77268693          	addi	a3,a3,1906 # ffffffffc0202a80 <commands+0x948>
ffffffffc0201316:	00001617          	auipc	a2,0x1
ffffffffc020131a:	50260613          	addi	a2,a2,1282 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020131e:	12d00593          	li	a1,301
ffffffffc0201322:	00001517          	auipc	a0,0x1
ffffffffc0201326:	50e50513          	addi	a0,a0,1294 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020132a:	8aaff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc020132e:	00001697          	auipc	a3,0x1
ffffffffc0201332:	72268693          	addi	a3,a3,1826 # ffffffffc0202a50 <commands+0x918>
ffffffffc0201336:	00001617          	auipc	a2,0x1
ffffffffc020133a:	4e260613          	addi	a2,a2,1250 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020133e:	12b00593          	li	a1,299
ffffffffc0201342:	00001517          	auipc	a0,0x1
ffffffffc0201346:	4ee50513          	addi	a0,a0,1262 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020134a:	88aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020134e:	00001697          	auipc	a3,0x1
ffffffffc0201352:	6ea68693          	addi	a3,a3,1770 # ffffffffc0202a38 <commands+0x900>
ffffffffc0201356:	00001617          	auipc	a2,0x1
ffffffffc020135a:	4c260613          	addi	a2,a2,1218 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020135e:	12a00593          	li	a1,298
ffffffffc0201362:	00001517          	auipc	a0,0x1
ffffffffc0201366:	4ce50513          	addi	a0,a0,1230 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020136a:	86aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020136e:	00001697          	auipc	a3,0x1
ffffffffc0201372:	63268693          	addi	a3,a3,1586 # ffffffffc02029a0 <commands+0x868>
ffffffffc0201376:	00001617          	auipc	a2,0x1
ffffffffc020137a:	4a260613          	addi	a2,a2,1186 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020137e:	11e00593          	li	a1,286
ffffffffc0201382:	00001517          	auipc	a0,0x1
ffffffffc0201386:	4ae50513          	addi	a0,a0,1198 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020138a:	84aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(!PageProperty(p0));
ffffffffc020138e:	00001697          	auipc	a3,0x1
ffffffffc0201392:	69268693          	addi	a3,a3,1682 # ffffffffc0202a20 <commands+0x8e8>
ffffffffc0201396:	00001617          	auipc	a2,0x1
ffffffffc020139a:	48260613          	addi	a2,a2,1154 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020139e:	11500593          	li	a1,277
ffffffffc02013a2:	00001517          	auipc	a0,0x1
ffffffffc02013a6:	48e50513          	addi	a0,a0,1166 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02013aa:	82aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(p0 != NULL);
ffffffffc02013ae:	00001697          	auipc	a3,0x1
ffffffffc02013b2:	66268693          	addi	a3,a3,1634 # ffffffffc0202a10 <commands+0x8d8>
ffffffffc02013b6:	00001617          	auipc	a2,0x1
ffffffffc02013ba:	46260613          	addi	a2,a2,1122 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02013be:	11400593          	li	a1,276
ffffffffc02013c2:	00001517          	auipc	a0,0x1
ffffffffc02013c6:	46e50513          	addi	a0,a0,1134 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02013ca:	80aff0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(nr_free == 0);
ffffffffc02013ce:	00001697          	auipc	a3,0x1
ffffffffc02013d2:	63268693          	addi	a3,a3,1586 # ffffffffc0202a00 <commands+0x8c8>
ffffffffc02013d6:	00001617          	auipc	a2,0x1
ffffffffc02013da:	44260613          	addi	a2,a2,1090 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02013de:	0f600593          	li	a1,246
ffffffffc02013e2:	00001517          	auipc	a0,0x1
ffffffffc02013e6:	44e50513          	addi	a0,a0,1102 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02013ea:	febfe0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013ee:	00001697          	auipc	a3,0x1
ffffffffc02013f2:	5b268693          	addi	a3,a3,1458 # ffffffffc02029a0 <commands+0x868>
ffffffffc02013f6:	00001617          	auipc	a2,0x1
ffffffffc02013fa:	42260613          	addi	a2,a2,1058 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02013fe:	0f400593          	li	a1,244
ffffffffc0201402:	00001517          	auipc	a0,0x1
ffffffffc0201406:	42e50513          	addi	a0,a0,1070 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020140a:	fcbfe0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020140e:	00001697          	auipc	a3,0x1
ffffffffc0201412:	5d268693          	addi	a3,a3,1490 # ffffffffc02029e0 <commands+0x8a8>
ffffffffc0201416:	00001617          	auipc	a2,0x1
ffffffffc020141a:	40260613          	addi	a2,a2,1026 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020141e:	0f300593          	li	a1,243
ffffffffc0201422:	00001517          	auipc	a0,0x1
ffffffffc0201426:	40e50513          	addi	a0,a0,1038 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020142a:	fabfe0ef          	jal	ra,ffffffffc02003d4 <__panic>

ffffffffc020142e <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc020142e:	1141                	addi	sp,sp,-16
ffffffffc0201430:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201432:	14058a63          	beqz	a1,ffffffffc0201586 <best_fit_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc0201436:	00259693          	slli	a3,a1,0x2
ffffffffc020143a:	96ae                	add	a3,a3,a1
ffffffffc020143c:	068e                	slli	a3,a3,0x3
ffffffffc020143e:	96aa                	add	a3,a3,a0
ffffffffc0201440:	87aa                	mv	a5,a0
ffffffffc0201442:	02d50263          	beq	a0,a3,ffffffffc0201466 <best_fit_free_pages+0x38>
ffffffffc0201446:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201448:	8b05                	andi	a4,a4,1
ffffffffc020144a:	10071e63          	bnez	a4,ffffffffc0201566 <best_fit_free_pages+0x138>
ffffffffc020144e:	6798                	ld	a4,8(a5)
ffffffffc0201450:	8b09                	andi	a4,a4,2
ffffffffc0201452:	10071a63          	bnez	a4,ffffffffc0201566 <best_fit_free_pages+0x138>
        p->flags = 0;
ffffffffc0201456:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020145a:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020145e:	02878793          	addi	a5,a5,40
ffffffffc0201462:	fed792e3          	bne	a5,a3,ffffffffc0201446 <best_fit_free_pages+0x18>
    base->property = n;
ffffffffc0201466:	2581                	sext.w	a1,a1
ffffffffc0201468:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020146a:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020146e:	4789                	li	a5,2
ffffffffc0201470:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201474:	00005697          	auipc	a3,0x5
ffffffffc0201478:	bb468693          	addi	a3,a3,-1100 # ffffffffc0206028 <free_area>
ffffffffc020147c:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020147e:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201480:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201484:	9db9                	addw	a1,a1,a4
ffffffffc0201486:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201488:	0ad78863          	beq	a5,a3,ffffffffc0201538 <best_fit_free_pages+0x10a>
            struct Page *page = le2page(le, page_link);
ffffffffc020148c:	fe878713          	addi	a4,a5,-24
ffffffffc0201490:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201494:	4581                	li	a1,0
            if (base < page)
ffffffffc0201496:	00e56a63          	bltu	a0,a4,ffffffffc02014aa <best_fit_free_pages+0x7c>
    return listelm->next;
ffffffffc020149a:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020149c:	06d70263          	beq	a4,a3,ffffffffc0201500 <best_fit_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc02014a0:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02014a2:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02014a6:	fee57ae3          	bgeu	a0,a4,ffffffffc020149a <best_fit_free_pages+0x6c>
ffffffffc02014aa:	c199                	beqz	a1,ffffffffc02014b0 <best_fit_free_pages+0x82>
ffffffffc02014ac:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02014b0:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02014b2:	e390                	sd	a2,0(a5)
ffffffffc02014b4:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02014b6:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02014b8:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc02014ba:	02d70063          	beq	a4,a3,ffffffffc02014da <best_fit_free_pages+0xac>
        if (p + p->property == base)
ffffffffc02014be:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02014c2:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base)
ffffffffc02014c6:	02081613          	slli	a2,a6,0x20
ffffffffc02014ca:	9201                	srli	a2,a2,0x20
ffffffffc02014cc:	00261793          	slli	a5,a2,0x2
ffffffffc02014d0:	97b2                	add	a5,a5,a2
ffffffffc02014d2:	078e                	slli	a5,a5,0x3
ffffffffc02014d4:	97ae                	add	a5,a5,a1
ffffffffc02014d6:	02f50f63          	beq	a0,a5,ffffffffc0201514 <best_fit_free_pages+0xe6>
    return listelm->next;
ffffffffc02014da:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc02014dc:	00d70f63          	beq	a4,a3,ffffffffc02014fa <best_fit_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc02014e0:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc02014e2:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc02014e6:	02059613          	slli	a2,a1,0x20
ffffffffc02014ea:	9201                	srli	a2,a2,0x20
ffffffffc02014ec:	00261793          	slli	a5,a2,0x2
ffffffffc02014f0:	97b2                	add	a5,a5,a2
ffffffffc02014f2:	078e                	slli	a5,a5,0x3
ffffffffc02014f4:	97aa                	add	a5,a5,a0
ffffffffc02014f6:	04f68863          	beq	a3,a5,ffffffffc0201546 <best_fit_free_pages+0x118>
}
ffffffffc02014fa:	60a2                	ld	ra,8(sp)
ffffffffc02014fc:	0141                	addi	sp,sp,16
ffffffffc02014fe:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201500:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201502:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201504:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201506:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201508:	02d70563          	beq	a4,a3,ffffffffc0201532 <best_fit_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc020150c:	8832                	mv	a6,a2
ffffffffc020150e:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201510:	87ba                	mv	a5,a4
ffffffffc0201512:	bf41                	j	ffffffffc02014a2 <best_fit_free_pages+0x74>
            p->property += base->property;
ffffffffc0201514:	491c                	lw	a5,16(a0)
ffffffffc0201516:	0107883b          	addw	a6,a5,a6
ffffffffc020151a:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020151e:	57f5                	li	a5,-3
ffffffffc0201520:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201524:	6d10                	ld	a2,24(a0)
ffffffffc0201526:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201528:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc020152a:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc020152c:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc020152e:	e390                	sd	a2,0(a5)
ffffffffc0201530:	b775                	j	ffffffffc02014dc <best_fit_free_pages+0xae>
ffffffffc0201532:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201534:	873e                	mv	a4,a5
ffffffffc0201536:	b761                	j	ffffffffc02014be <best_fit_free_pages+0x90>
}
ffffffffc0201538:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020153a:	e390                	sd	a2,0(a5)
ffffffffc020153c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020153e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201540:	ed1c                	sd	a5,24(a0)
ffffffffc0201542:	0141                	addi	sp,sp,16
ffffffffc0201544:	8082                	ret
            base->property += p->property;
ffffffffc0201546:	ff872783          	lw	a5,-8(a4)
ffffffffc020154a:	ff070693          	addi	a3,a4,-16
ffffffffc020154e:	9dbd                	addw	a1,a1,a5
ffffffffc0201550:	c90c                	sw	a1,16(a0)
ffffffffc0201552:	57f5                	li	a5,-3
ffffffffc0201554:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201558:	6314                	ld	a3,0(a4)
ffffffffc020155a:	671c                	ld	a5,8(a4)
}
ffffffffc020155c:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020155e:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0201560:	e394                	sd	a3,0(a5)
ffffffffc0201562:	0141                	addi	sp,sp,16
ffffffffc0201564:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201566:	00001697          	auipc	a3,0x1
ffffffffc020156a:	5a268693          	addi	a3,a3,1442 # ffffffffc0202b08 <commands+0x9d0>
ffffffffc020156e:	00001617          	auipc	a2,0x1
ffffffffc0201572:	2aa60613          	addi	a2,a2,682 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0201576:	08f00593          	li	a1,143
ffffffffc020157a:	00001517          	auipc	a0,0x1
ffffffffc020157e:	2b650513          	addi	a0,a0,694 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201582:	e53fe0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(n > 0);
ffffffffc0201586:	00001697          	auipc	a3,0x1
ffffffffc020158a:	28a68693          	addi	a3,a3,650 # ffffffffc0202810 <commands+0x6d8>
ffffffffc020158e:	00001617          	auipc	a2,0x1
ffffffffc0201592:	28a60613          	addi	a2,a2,650 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0201596:	08c00593          	li	a1,140
ffffffffc020159a:	00001517          	auipc	a0,0x1
ffffffffc020159e:	29650513          	addi	a0,a0,662 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02015a2:	e33fe0ef          	jal	ra,ffffffffc02003d4 <__panic>

ffffffffc02015a6 <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc02015a6:	1141                	addi	sp,sp,-16
ffffffffc02015a8:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02015aa:	c9e1                	beqz	a1,ffffffffc020167a <best_fit_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02015ac:	00259693          	slli	a3,a1,0x2
ffffffffc02015b0:	96ae                	add	a3,a3,a1
ffffffffc02015b2:	068e                	slli	a3,a3,0x3
ffffffffc02015b4:	96aa                	add	a3,a3,a0
ffffffffc02015b6:	87aa                	mv	a5,a0
ffffffffc02015b8:	00d50f63          	beq	a0,a3,ffffffffc02015d6 <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02015bc:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02015be:	8b05                	andi	a4,a4,1
ffffffffc02015c0:	cf49                	beqz	a4,ffffffffc020165a <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02015c2:	0007a823          	sw	zero,16(a5)
ffffffffc02015c6:	0007b423          	sd	zero,8(a5)
ffffffffc02015ca:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015ce:	02878793          	addi	a5,a5,40
ffffffffc02015d2:	fed795e3          	bne	a5,a3,ffffffffc02015bc <best_fit_init_memmap+0x16>
    base->property = n;
ffffffffc02015d6:	2581                	sext.w	a1,a1
ffffffffc02015d8:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015da:	4789                	li	a5,2
ffffffffc02015dc:	00850713          	addi	a4,a0,8
ffffffffc02015e0:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02015e4:	00005697          	auipc	a3,0x5
ffffffffc02015e8:	a4468693          	addi	a3,a3,-1468 # ffffffffc0206028 <free_area>
ffffffffc02015ec:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02015ee:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02015f0:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02015f4:	9db9                	addw	a1,a1,a4
ffffffffc02015f6:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02015f8:	04d78a63          	beq	a5,a3,ffffffffc020164c <best_fit_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc02015fc:	fe878713          	addi	a4,a5,-24
ffffffffc0201600:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201604:	4581                	li	a1,0
            if (base < page)
ffffffffc0201606:	00e56a63          	bltu	a0,a4,ffffffffc020161a <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc020160a:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020160c:	02d70263          	beq	a4,a3,ffffffffc0201630 <best_fit_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc0201610:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201612:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201616:	fee57ae3          	bgeu	a0,a4,ffffffffc020160a <best_fit_init_memmap+0x64>
ffffffffc020161a:	c199                	beqz	a1,ffffffffc0201620 <best_fit_init_memmap+0x7a>
ffffffffc020161c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201620:	6398                	ld	a4,0(a5)
}
ffffffffc0201622:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201624:	e390                	sd	a2,0(a5)
ffffffffc0201626:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201628:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020162a:	ed18                	sd	a4,24(a0)
ffffffffc020162c:	0141                	addi	sp,sp,16
ffffffffc020162e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201630:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201632:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201634:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201636:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201638:	00d70663          	beq	a4,a3,ffffffffc0201644 <best_fit_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc020163c:	8832                	mv	a6,a2
ffffffffc020163e:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0201640:	87ba                	mv	a5,a4
ffffffffc0201642:	bfc1                	j	ffffffffc0201612 <best_fit_init_memmap+0x6c>
}
ffffffffc0201644:	60a2                	ld	ra,8(sp)
ffffffffc0201646:	e290                	sd	a2,0(a3)
ffffffffc0201648:	0141                	addi	sp,sp,16
ffffffffc020164a:	8082                	ret
ffffffffc020164c:	60a2                	ld	ra,8(sp)
ffffffffc020164e:	e390                	sd	a2,0(a5)
ffffffffc0201650:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201652:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201654:	ed1c                	sd	a5,24(a0)
ffffffffc0201656:	0141                	addi	sp,sp,16
ffffffffc0201658:	8082                	ret
        assert(PageReserved(p));
ffffffffc020165a:	00001697          	auipc	a3,0x1
ffffffffc020165e:	4d668693          	addi	a3,a3,1238 # ffffffffc0202b30 <commands+0x9f8>
ffffffffc0201662:	00001617          	auipc	a2,0x1
ffffffffc0201666:	1b660613          	addi	a2,a2,438 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020166a:	04a00593          	li	a1,74
ffffffffc020166e:	00001517          	auipc	a0,0x1
ffffffffc0201672:	1c250513          	addi	a0,a0,450 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201676:	d5ffe0ef          	jal	ra,ffffffffc02003d4 <__panic>
    assert(n > 0);
ffffffffc020167a:	00001697          	auipc	a3,0x1
ffffffffc020167e:	19668693          	addi	a3,a3,406 # ffffffffc0202810 <commands+0x6d8>
ffffffffc0201682:	00001617          	auipc	a2,0x1
ffffffffc0201686:	19660613          	addi	a2,a2,406 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020168a:	04700593          	li	a1,71
ffffffffc020168e:	00001517          	auipc	a0,0x1
ffffffffc0201692:	1a250513          	addi	a0,a0,418 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201696:	d3ffe0ef          	jal	ra,ffffffffc02003d4 <__panic>

ffffffffc020169a <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020169a:	100027f3          	csrr	a5,sstatus
ffffffffc020169e:	8b89                	andi	a5,a5,2
ffffffffc02016a0:	e799                	bnez	a5,ffffffffc02016ae <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc02016a2:	00005797          	auipc	a5,0x5
ffffffffc02016a6:	dd67b783          	ld	a5,-554(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc02016aa:	6f9c                	ld	a5,24(a5)
ffffffffc02016ac:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc02016ae:	1141                	addi	sp,sp,-16
ffffffffc02016b0:	e406                	sd	ra,8(sp)
ffffffffc02016b2:	e022                	sd	s0,0(sp)
ffffffffc02016b4:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02016b6:	980ff0ef          	jal	ra,ffffffffc0200836 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02016ba:	00005797          	auipc	a5,0x5
ffffffffc02016be:	dbe7b783          	ld	a5,-578(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc02016c2:	6f9c                	ld	a5,24(a5)
ffffffffc02016c4:	8522                	mv	a0,s0
ffffffffc02016c6:	9782                	jalr	a5
ffffffffc02016c8:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc02016ca:	966ff0ef          	jal	ra,ffffffffc0200830 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02016ce:	60a2                	ld	ra,8(sp)
ffffffffc02016d0:	8522                	mv	a0,s0
ffffffffc02016d2:	6402                	ld	s0,0(sp)
ffffffffc02016d4:	0141                	addi	sp,sp,16
ffffffffc02016d6:	8082                	ret

ffffffffc02016d8 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016d8:	100027f3          	csrr	a5,sstatus
ffffffffc02016dc:	8b89                	andi	a5,a5,2
ffffffffc02016de:	e799                	bnez	a5,ffffffffc02016ec <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02016e0:	00005797          	auipc	a5,0x5
ffffffffc02016e4:	d987b783          	ld	a5,-616(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc02016e8:	739c                	ld	a5,32(a5)
ffffffffc02016ea:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc02016ec:	1101                	addi	sp,sp,-32
ffffffffc02016ee:	ec06                	sd	ra,24(sp)
ffffffffc02016f0:	e822                	sd	s0,16(sp)
ffffffffc02016f2:	e426                	sd	s1,8(sp)
ffffffffc02016f4:	842a                	mv	s0,a0
ffffffffc02016f6:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02016f8:	93eff0ef          	jal	ra,ffffffffc0200836 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02016fc:	00005797          	auipc	a5,0x5
ffffffffc0201700:	d7c7b783          	ld	a5,-644(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc0201704:	739c                	ld	a5,32(a5)
ffffffffc0201706:	85a6                	mv	a1,s1
ffffffffc0201708:	8522                	mv	a0,s0
ffffffffc020170a:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc020170c:	6442                	ld	s0,16(sp)
ffffffffc020170e:	60e2                	ld	ra,24(sp)
ffffffffc0201710:	64a2                	ld	s1,8(sp)
ffffffffc0201712:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201714:	91cff06f          	j	ffffffffc0200830 <intr_enable>

ffffffffc0201718 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201718:	100027f3          	csrr	a5,sstatus
ffffffffc020171c:	8b89                	andi	a5,a5,2
ffffffffc020171e:	e799                	bnez	a5,ffffffffc020172c <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201720:	00005797          	auipc	a5,0x5
ffffffffc0201724:	d587b783          	ld	a5,-680(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc0201728:	779c                	ld	a5,40(a5)
ffffffffc020172a:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc020172c:	1141                	addi	sp,sp,-16
ffffffffc020172e:	e406                	sd	ra,8(sp)
ffffffffc0201730:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201732:	904ff0ef          	jal	ra,ffffffffc0200836 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201736:	00005797          	auipc	a5,0x5
ffffffffc020173a:	d427b783          	ld	a5,-702(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc020173e:	779c                	ld	a5,40(a5)
ffffffffc0201740:	9782                	jalr	a5
ffffffffc0201742:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201744:	8ecff0ef          	jal	ra,ffffffffc0200830 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201748:	60a2                	ld	ra,8(sp)
ffffffffc020174a:	8522                	mv	a0,s0
ffffffffc020174c:	6402                	ld	s0,0(sp)
ffffffffc020174e:	0141                	addi	sp,sp,16
ffffffffc0201750:	8082                	ret

ffffffffc0201752 <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0201752:	00001797          	auipc	a5,0x1
ffffffffc0201756:	40678793          	addi	a5,a5,1030 # ffffffffc0202b58 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020175a:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc020175c:	7179                	addi	sp,sp,-48
ffffffffc020175e:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201760:	00001517          	auipc	a0,0x1
ffffffffc0201764:	43050513          	addi	a0,a0,1072 # ffffffffc0202b90 <best_fit_pmm_manager+0x38>
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0201768:	00005417          	auipc	s0,0x5
ffffffffc020176c:	d1040413          	addi	s0,s0,-752 # ffffffffc0206478 <pmm_manager>
void pmm_init(void) {
ffffffffc0201770:	f406                	sd	ra,40(sp)
ffffffffc0201772:	ec26                	sd	s1,24(sp)
ffffffffc0201774:	e44e                	sd	s3,8(sp)
ffffffffc0201776:	e84a                	sd	s2,16(sp)
ffffffffc0201778:	e052                	sd	s4,0(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc020177a:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020177c:	95ffe0ef          	jal	ra,ffffffffc02000da <cprintf>
    pmm_manager->init();
ffffffffc0201780:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201782:	00005497          	auipc	s1,0x5
ffffffffc0201786:	d0e48493          	addi	s1,s1,-754 # ffffffffc0206490 <va_pa_offset>
    pmm_manager->init();
ffffffffc020178a:	679c                	ld	a5,8(a5)
ffffffffc020178c:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020178e:	57f5                	li	a5,-3
ffffffffc0201790:	07fa                	slli	a5,a5,0x1e
ffffffffc0201792:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201794:	888ff0ef          	jal	ra,ffffffffc020081c <get_memory_base>
ffffffffc0201798:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc020179a:	88cff0ef          	jal	ra,ffffffffc0200826 <get_memory_size>
    if (mem_size == 0) {
ffffffffc020179e:	16050163          	beqz	a0,ffffffffc0201900 <pmm_init+0x1ae>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02017a2:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc02017a4:	00001517          	auipc	a0,0x1
ffffffffc02017a8:	43450513          	addi	a0,a0,1076 # ffffffffc0202bd8 <best_fit_pmm_manager+0x80>
ffffffffc02017ac:	92ffe0ef          	jal	ra,ffffffffc02000da <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02017b0:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02017b4:	864e                	mv	a2,s3
ffffffffc02017b6:	fffa0693          	addi	a3,s4,-1
ffffffffc02017ba:	85ca                	mv	a1,s2
ffffffffc02017bc:	00001517          	auipc	a0,0x1
ffffffffc02017c0:	43450513          	addi	a0,a0,1076 # ffffffffc0202bf0 <best_fit_pmm_manager+0x98>
ffffffffc02017c4:	917fe0ef          	jal	ra,ffffffffc02000da <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02017c8:	c80007b7          	lui	a5,0xc8000
ffffffffc02017cc:	8652                	mv	a2,s4
ffffffffc02017ce:	0d47e863          	bltu	a5,s4,ffffffffc020189e <pmm_init+0x14c>
ffffffffc02017d2:	00006797          	auipc	a5,0x6
ffffffffc02017d6:	ccd78793          	addi	a5,a5,-819 # ffffffffc020749f <end+0xfff>
ffffffffc02017da:	757d                	lui	a0,0xfffff
ffffffffc02017dc:	8d7d                	and	a0,a0,a5
ffffffffc02017de:	8231                	srli	a2,a2,0xc
ffffffffc02017e0:	00005597          	auipc	a1,0x5
ffffffffc02017e4:	c8858593          	addi	a1,a1,-888 # ffffffffc0206468 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017e8:	00005817          	auipc	a6,0x5
ffffffffc02017ec:	c8880813          	addi	a6,a6,-888 # ffffffffc0206470 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02017f0:	e190                	sd	a2,0(a1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017f2:	00a83023          	sd	a0,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02017f6:	000807b7          	lui	a5,0x80
ffffffffc02017fa:	02f60663          	beq	a2,a5,ffffffffc0201826 <pmm_init+0xd4>
ffffffffc02017fe:	4701                	li	a4,0
ffffffffc0201800:	4781                	li	a5,0
ffffffffc0201802:	4305                	li	t1,1
ffffffffc0201804:	fff808b7          	lui	a7,0xfff80
        SetPageReserved(pages + i);
ffffffffc0201808:	953a                	add	a0,a0,a4
ffffffffc020180a:	00850693          	addi	a3,a0,8 # fffffffffffff008 <end+0x3fdf8b68>
ffffffffc020180e:	4066b02f          	amoor.d	zero,t1,(a3)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201812:	6190                	ld	a2,0(a1)
ffffffffc0201814:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0201816:	00083503          	ld	a0,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020181a:	011606b3          	add	a3,a2,a7
ffffffffc020181e:	02870713          	addi	a4,a4,40
ffffffffc0201822:	fed7e3e3          	bltu	a5,a3,ffffffffc0201808 <pmm_init+0xb6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201826:	00261693          	slli	a3,a2,0x2
ffffffffc020182a:	96b2                	add	a3,a3,a2
ffffffffc020182c:	fec007b7          	lui	a5,0xfec00
ffffffffc0201830:	97aa                	add	a5,a5,a0
ffffffffc0201832:	068e                	slli	a3,a3,0x3
ffffffffc0201834:	96be                	add	a3,a3,a5
ffffffffc0201836:	c02007b7          	lui	a5,0xc0200
ffffffffc020183a:	0af6e763          	bltu	a3,a5,ffffffffc02018e8 <pmm_init+0x196>
ffffffffc020183e:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0201840:	77fd                	lui	a5,0xfffff
ffffffffc0201842:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201846:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0201848:	04b6ee63          	bltu	a3,a1,ffffffffc02018a4 <pmm_init+0x152>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc020184c:	601c                	ld	a5,0(s0)
ffffffffc020184e:	7b9c                	ld	a5,48(a5)
ffffffffc0201850:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0201852:	00001517          	auipc	a0,0x1
ffffffffc0201856:	42650513          	addi	a0,a0,1062 # ffffffffc0202c78 <best_fit_pmm_manager+0x120>
ffffffffc020185a:	881fe0ef          	jal	ra,ffffffffc02000da <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020185e:	00003597          	auipc	a1,0x3
ffffffffc0201862:	7a258593          	addi	a1,a1,1954 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0201866:	00005797          	auipc	a5,0x5
ffffffffc020186a:	c2b7b123          	sd	a1,-990(a5) # ffffffffc0206488 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc020186e:	c02007b7          	lui	a5,0xc0200
ffffffffc0201872:	0af5e363          	bltu	a1,a5,ffffffffc0201918 <pmm_init+0x1c6>
ffffffffc0201876:	6090                	ld	a2,0(s1)
}
ffffffffc0201878:	7402                	ld	s0,32(sp)
ffffffffc020187a:	70a2                	ld	ra,40(sp)
ffffffffc020187c:	64e2                	ld	s1,24(sp)
ffffffffc020187e:	6942                	ld	s2,16(sp)
ffffffffc0201880:	69a2                	ld	s3,8(sp)
ffffffffc0201882:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201884:	40c58633          	sub	a2,a1,a2
ffffffffc0201888:	00005797          	auipc	a5,0x5
ffffffffc020188c:	bec7bc23          	sd	a2,-1032(a5) # ffffffffc0206480 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201890:	00001517          	auipc	a0,0x1
ffffffffc0201894:	40850513          	addi	a0,a0,1032 # ffffffffc0202c98 <best_fit_pmm_manager+0x140>
}
ffffffffc0201898:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020189a:	841fe06f          	j	ffffffffc02000da <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc020189e:	c8000637          	lui	a2,0xc8000
ffffffffc02018a2:	bf05                	j	ffffffffc02017d2 <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02018a4:	6705                	lui	a4,0x1
ffffffffc02018a6:	177d                	addi	a4,a4,-1
ffffffffc02018a8:	96ba                	add	a3,a3,a4
ffffffffc02018aa:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02018ac:	00c6d793          	srli	a5,a3,0xc
ffffffffc02018b0:	02c7f063          	bgeu	a5,a2,ffffffffc02018d0 <pmm_init+0x17e>
    pmm_manager->init_memmap(base, n);
ffffffffc02018b4:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02018b6:	fff80737          	lui	a4,0xfff80
ffffffffc02018ba:	973e                	add	a4,a4,a5
ffffffffc02018bc:	00271793          	slli	a5,a4,0x2
ffffffffc02018c0:	97ba                	add	a5,a5,a4
ffffffffc02018c2:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02018c4:	8d95                	sub	a1,a1,a3
ffffffffc02018c6:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02018c8:	81b1                	srli	a1,a1,0xc
ffffffffc02018ca:	953e                	add	a0,a0,a5
ffffffffc02018cc:	9702                	jalr	a4
}
ffffffffc02018ce:	bfbd                	j	ffffffffc020184c <pmm_init+0xfa>
        panic("pa2page called with invalid pa");
ffffffffc02018d0:	00001617          	auipc	a2,0x1
ffffffffc02018d4:	37860613          	addi	a2,a2,888 # ffffffffc0202c48 <best_fit_pmm_manager+0xf0>
ffffffffc02018d8:	06b00593          	li	a1,107
ffffffffc02018dc:	00001517          	auipc	a0,0x1
ffffffffc02018e0:	38c50513          	addi	a0,a0,908 # ffffffffc0202c68 <best_fit_pmm_manager+0x110>
ffffffffc02018e4:	af1fe0ef          	jal	ra,ffffffffc02003d4 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018e8:	00001617          	auipc	a2,0x1
ffffffffc02018ec:	33860613          	addi	a2,a2,824 # ffffffffc0202c20 <best_fit_pmm_manager+0xc8>
ffffffffc02018f0:	07100593          	li	a1,113
ffffffffc02018f4:	00001517          	auipc	a0,0x1
ffffffffc02018f8:	2d450513          	addi	a0,a0,724 # ffffffffc0202bc8 <best_fit_pmm_manager+0x70>
ffffffffc02018fc:	ad9fe0ef          	jal	ra,ffffffffc02003d4 <__panic>
        panic("DTB memory info not available");
ffffffffc0201900:	00001617          	auipc	a2,0x1
ffffffffc0201904:	2a860613          	addi	a2,a2,680 # ffffffffc0202ba8 <best_fit_pmm_manager+0x50>
ffffffffc0201908:	05a00593          	li	a1,90
ffffffffc020190c:	00001517          	auipc	a0,0x1
ffffffffc0201910:	2bc50513          	addi	a0,a0,700 # ffffffffc0202bc8 <best_fit_pmm_manager+0x70>
ffffffffc0201914:	ac1fe0ef          	jal	ra,ffffffffc02003d4 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201918:	86ae                	mv	a3,a1
ffffffffc020191a:	00001617          	auipc	a2,0x1
ffffffffc020191e:	30660613          	addi	a2,a2,774 # ffffffffc0202c20 <best_fit_pmm_manager+0xc8>
ffffffffc0201922:	08c00593          	li	a1,140
ffffffffc0201926:	00001517          	auipc	a0,0x1
ffffffffc020192a:	2a250513          	addi	a0,a0,674 # ffffffffc0202bc8 <best_fit_pmm_manager+0x70>
ffffffffc020192e:	aa7fe0ef          	jal	ra,ffffffffc02003d4 <__panic>

ffffffffc0201932 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201932:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201936:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201938:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020193c:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020193e:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201942:	f022                	sd	s0,32(sp)
ffffffffc0201944:	ec26                	sd	s1,24(sp)
ffffffffc0201946:	e84a                	sd	s2,16(sp)
ffffffffc0201948:	f406                	sd	ra,40(sp)
ffffffffc020194a:	e44e                	sd	s3,8(sp)
ffffffffc020194c:	84aa                	mv	s1,a0
ffffffffc020194e:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201950:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201954:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201956:	03067e63          	bgeu	a2,a6,ffffffffc0201992 <printnum+0x60>
ffffffffc020195a:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020195c:	00805763          	blez	s0,ffffffffc020196a <printnum+0x38>
ffffffffc0201960:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201962:	85ca                	mv	a1,s2
ffffffffc0201964:	854e                	mv	a0,s3
ffffffffc0201966:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201968:	fc65                	bnez	s0,ffffffffc0201960 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020196a:	1a02                	slli	s4,s4,0x20
ffffffffc020196c:	00001797          	auipc	a5,0x1
ffffffffc0201970:	36c78793          	addi	a5,a5,876 # ffffffffc0202cd8 <best_fit_pmm_manager+0x180>
ffffffffc0201974:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201978:	9a3e                	add	s4,s4,a5
}
ffffffffc020197a:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020197c:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201980:	70a2                	ld	ra,40(sp)
ffffffffc0201982:	69a2                	ld	s3,8(sp)
ffffffffc0201984:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201986:	85ca                	mv	a1,s2
ffffffffc0201988:	87a6                	mv	a5,s1
}
ffffffffc020198a:	6942                	ld	s2,16(sp)
ffffffffc020198c:	64e2                	ld	s1,24(sp)
ffffffffc020198e:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201990:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201992:	03065633          	divu	a2,a2,a6
ffffffffc0201996:	8722                	mv	a4,s0
ffffffffc0201998:	f9bff0ef          	jal	ra,ffffffffc0201932 <printnum>
ffffffffc020199c:	b7f9                	j	ffffffffc020196a <printnum+0x38>

ffffffffc020199e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020199e:	7119                	addi	sp,sp,-128
ffffffffc02019a0:	f4a6                	sd	s1,104(sp)
ffffffffc02019a2:	f0ca                	sd	s2,96(sp)
ffffffffc02019a4:	ecce                	sd	s3,88(sp)
ffffffffc02019a6:	e8d2                	sd	s4,80(sp)
ffffffffc02019a8:	e4d6                	sd	s5,72(sp)
ffffffffc02019aa:	e0da                	sd	s6,64(sp)
ffffffffc02019ac:	fc5e                	sd	s7,56(sp)
ffffffffc02019ae:	f06a                	sd	s10,32(sp)
ffffffffc02019b0:	fc86                	sd	ra,120(sp)
ffffffffc02019b2:	f8a2                	sd	s0,112(sp)
ffffffffc02019b4:	f862                	sd	s8,48(sp)
ffffffffc02019b6:	f466                	sd	s9,40(sp)
ffffffffc02019b8:	ec6e                	sd	s11,24(sp)
ffffffffc02019ba:	892a                	mv	s2,a0
ffffffffc02019bc:	84ae                	mv	s1,a1
ffffffffc02019be:	8d32                	mv	s10,a2
ffffffffc02019c0:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019c2:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02019c6:	5b7d                	li	s6,-1
ffffffffc02019c8:	00001a97          	auipc	s5,0x1
ffffffffc02019cc:	344a8a93          	addi	s5,s5,836 # ffffffffc0202d0c <best_fit_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02019d0:	00001b97          	auipc	s7,0x1
ffffffffc02019d4:	518b8b93          	addi	s7,s7,1304 # ffffffffc0202ee8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019d8:	000d4503          	lbu	a0,0(s10)
ffffffffc02019dc:	001d0413          	addi	s0,s10,1
ffffffffc02019e0:	01350a63          	beq	a0,s3,ffffffffc02019f4 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02019e4:	c121                	beqz	a0,ffffffffc0201a24 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02019e6:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019e8:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02019ea:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019ec:	fff44503          	lbu	a0,-1(s0)
ffffffffc02019f0:	ff351ae3          	bne	a0,s3,ffffffffc02019e4 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02019f4:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02019f8:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02019fc:	4c81                	li	s9,0
ffffffffc02019fe:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0201a00:	5c7d                	li	s8,-1
ffffffffc0201a02:	5dfd                	li	s11,-1
ffffffffc0201a04:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0201a08:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a0a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201a0e:	0ff5f593          	zext.b	a1,a1
ffffffffc0201a12:	00140d13          	addi	s10,s0,1
ffffffffc0201a16:	04b56263          	bltu	a0,a1,ffffffffc0201a5a <vprintfmt+0xbc>
ffffffffc0201a1a:	058a                	slli	a1,a1,0x2
ffffffffc0201a1c:	95d6                	add	a1,a1,s5
ffffffffc0201a1e:	4194                	lw	a3,0(a1)
ffffffffc0201a20:	96d6                	add	a3,a3,s5
ffffffffc0201a22:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201a24:	70e6                	ld	ra,120(sp)
ffffffffc0201a26:	7446                	ld	s0,112(sp)
ffffffffc0201a28:	74a6                	ld	s1,104(sp)
ffffffffc0201a2a:	7906                	ld	s2,96(sp)
ffffffffc0201a2c:	69e6                	ld	s3,88(sp)
ffffffffc0201a2e:	6a46                	ld	s4,80(sp)
ffffffffc0201a30:	6aa6                	ld	s5,72(sp)
ffffffffc0201a32:	6b06                	ld	s6,64(sp)
ffffffffc0201a34:	7be2                	ld	s7,56(sp)
ffffffffc0201a36:	7c42                	ld	s8,48(sp)
ffffffffc0201a38:	7ca2                	ld	s9,40(sp)
ffffffffc0201a3a:	7d02                	ld	s10,32(sp)
ffffffffc0201a3c:	6de2                	ld	s11,24(sp)
ffffffffc0201a3e:	6109                	addi	sp,sp,128
ffffffffc0201a40:	8082                	ret
            padc = '0';
ffffffffc0201a42:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0201a44:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a48:	846a                	mv	s0,s10
ffffffffc0201a4a:	00140d13          	addi	s10,s0,1
ffffffffc0201a4e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201a52:	0ff5f593          	zext.b	a1,a1
ffffffffc0201a56:	fcb572e3          	bgeu	a0,a1,ffffffffc0201a1a <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201a5a:	85a6                	mv	a1,s1
ffffffffc0201a5c:	02500513          	li	a0,37
ffffffffc0201a60:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201a62:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201a66:	8d22                	mv	s10,s0
ffffffffc0201a68:	f73788e3          	beq	a5,s3,ffffffffc02019d8 <vprintfmt+0x3a>
ffffffffc0201a6c:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201a70:	1d7d                	addi	s10,s10,-1
ffffffffc0201a72:	ff379de3          	bne	a5,s3,ffffffffc0201a6c <vprintfmt+0xce>
ffffffffc0201a76:	b78d                	j	ffffffffc02019d8 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201a78:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201a7c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a80:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201a82:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201a86:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201a8a:	02d86463          	bltu	a6,a3,ffffffffc0201ab2 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201a8e:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201a92:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201a96:	0186873b          	addw	a4,a3,s8
ffffffffc0201a9a:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201a9e:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201aa0:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201aa4:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201aa6:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201aaa:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201aae:	fed870e3          	bgeu	a6,a3,ffffffffc0201a8e <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201ab2:	f40ddce3          	bgez	s11,ffffffffc0201a0a <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201ab6:	8de2                	mv	s11,s8
ffffffffc0201ab8:	5c7d                	li	s8,-1
ffffffffc0201aba:	bf81                	j	ffffffffc0201a0a <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201abc:	fffdc693          	not	a3,s11
ffffffffc0201ac0:	96fd                	srai	a3,a3,0x3f
ffffffffc0201ac2:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ac6:	00144603          	lbu	a2,1(s0)
ffffffffc0201aca:	2d81                	sext.w	s11,s11
ffffffffc0201acc:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201ace:	bf35                	j	ffffffffc0201a0a <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201ad0:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ad4:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201ad8:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ada:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201adc:	bfd9                	j	ffffffffc0201ab2 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201ade:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201ae0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201ae4:	01174463          	blt	a4,a7,ffffffffc0201aec <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201ae8:	1a088e63          	beqz	a7,ffffffffc0201ca4 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201aec:	000a3603          	ld	a2,0(s4)
ffffffffc0201af0:	46c1                	li	a3,16
ffffffffc0201af2:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201af4:	2781                	sext.w	a5,a5
ffffffffc0201af6:	876e                	mv	a4,s11
ffffffffc0201af8:	85a6                	mv	a1,s1
ffffffffc0201afa:	854a                	mv	a0,s2
ffffffffc0201afc:	e37ff0ef          	jal	ra,ffffffffc0201932 <printnum>
            break;
ffffffffc0201b00:	bde1                	j	ffffffffc02019d8 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201b02:	000a2503          	lw	a0,0(s4)
ffffffffc0201b06:	85a6                	mv	a1,s1
ffffffffc0201b08:	0a21                	addi	s4,s4,8
ffffffffc0201b0a:	9902                	jalr	s2
            break;
ffffffffc0201b0c:	b5f1                	j	ffffffffc02019d8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201b0e:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b10:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b14:	01174463          	blt	a4,a7,ffffffffc0201b1c <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201b18:	18088163          	beqz	a7,ffffffffc0201c9a <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201b1c:	000a3603          	ld	a2,0(s4)
ffffffffc0201b20:	46a9                	li	a3,10
ffffffffc0201b22:	8a2e                	mv	s4,a1
ffffffffc0201b24:	bfc1                	j	ffffffffc0201af4 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b26:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201b2a:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b2c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201b2e:	bdf1                	j	ffffffffc0201a0a <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201b30:	85a6                	mv	a1,s1
ffffffffc0201b32:	02500513          	li	a0,37
ffffffffc0201b36:	9902                	jalr	s2
            break;
ffffffffc0201b38:	b545                	j	ffffffffc02019d8 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b3a:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201b3e:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b40:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201b42:	b5e1                	j	ffffffffc0201a0a <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201b44:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b46:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b4a:	01174463          	blt	a4,a7,ffffffffc0201b52 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201b4e:	14088163          	beqz	a7,ffffffffc0201c90 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201b52:	000a3603          	ld	a2,0(s4)
ffffffffc0201b56:	46a1                	li	a3,8
ffffffffc0201b58:	8a2e                	mv	s4,a1
ffffffffc0201b5a:	bf69                	j	ffffffffc0201af4 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201b5c:	03000513          	li	a0,48
ffffffffc0201b60:	85a6                	mv	a1,s1
ffffffffc0201b62:	e03e                	sd	a5,0(sp)
ffffffffc0201b64:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201b66:	85a6                	mv	a1,s1
ffffffffc0201b68:	07800513          	li	a0,120
ffffffffc0201b6c:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b6e:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201b70:	6782                	ld	a5,0(sp)
ffffffffc0201b72:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b74:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201b78:	bfb5                	j	ffffffffc0201af4 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201b7a:	000a3403          	ld	s0,0(s4)
ffffffffc0201b7e:	008a0713          	addi	a4,s4,8
ffffffffc0201b82:	e03a                	sd	a4,0(sp)
ffffffffc0201b84:	14040263          	beqz	s0,ffffffffc0201cc8 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201b88:	0fb05763          	blez	s11,ffffffffc0201c76 <vprintfmt+0x2d8>
ffffffffc0201b8c:	02d00693          	li	a3,45
ffffffffc0201b90:	0cd79163          	bne	a5,a3,ffffffffc0201c52 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b94:	00044783          	lbu	a5,0(s0)
ffffffffc0201b98:	0007851b          	sext.w	a0,a5
ffffffffc0201b9c:	cf85                	beqz	a5,ffffffffc0201bd4 <vprintfmt+0x236>
ffffffffc0201b9e:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201ba2:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201ba6:	000c4563          	bltz	s8,ffffffffc0201bb0 <vprintfmt+0x212>
ffffffffc0201baa:	3c7d                	addiw	s8,s8,-1
ffffffffc0201bac:	036c0263          	beq	s8,s6,ffffffffc0201bd0 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201bb0:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201bb2:	0e0c8e63          	beqz	s9,ffffffffc0201cae <vprintfmt+0x310>
ffffffffc0201bb6:	3781                	addiw	a5,a5,-32
ffffffffc0201bb8:	0ef47b63          	bgeu	s0,a5,ffffffffc0201cae <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201bbc:	03f00513          	li	a0,63
ffffffffc0201bc0:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201bc2:	000a4783          	lbu	a5,0(s4)
ffffffffc0201bc6:	3dfd                	addiw	s11,s11,-1
ffffffffc0201bc8:	0a05                	addi	s4,s4,1
ffffffffc0201bca:	0007851b          	sext.w	a0,a5
ffffffffc0201bce:	ffe1                	bnez	a5,ffffffffc0201ba6 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201bd0:	01b05963          	blez	s11,ffffffffc0201be2 <vprintfmt+0x244>
ffffffffc0201bd4:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201bd6:	85a6                	mv	a1,s1
ffffffffc0201bd8:	02000513          	li	a0,32
ffffffffc0201bdc:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201bde:	fe0d9be3          	bnez	s11,ffffffffc0201bd4 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201be2:	6a02                	ld	s4,0(sp)
ffffffffc0201be4:	bbd5                	j	ffffffffc02019d8 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201be6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201be8:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201bec:	01174463          	blt	a4,a7,ffffffffc0201bf4 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201bf0:	08088d63          	beqz	a7,ffffffffc0201c8a <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201bf4:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201bf8:	0a044d63          	bltz	s0,ffffffffc0201cb2 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201bfc:	8622                	mv	a2,s0
ffffffffc0201bfe:	8a66                	mv	s4,s9
ffffffffc0201c00:	46a9                	li	a3,10
ffffffffc0201c02:	bdcd                	j	ffffffffc0201af4 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201c04:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c08:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201c0a:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201c0c:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201c10:	8fb5                	xor	a5,a5,a3
ffffffffc0201c12:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c16:	02d74163          	blt	a4,a3,ffffffffc0201c38 <vprintfmt+0x29a>
ffffffffc0201c1a:	00369793          	slli	a5,a3,0x3
ffffffffc0201c1e:	97de                	add	a5,a5,s7
ffffffffc0201c20:	639c                	ld	a5,0(a5)
ffffffffc0201c22:	cb99                	beqz	a5,ffffffffc0201c38 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201c24:	86be                	mv	a3,a5
ffffffffc0201c26:	00001617          	auipc	a2,0x1
ffffffffc0201c2a:	0e260613          	addi	a2,a2,226 # ffffffffc0202d08 <best_fit_pmm_manager+0x1b0>
ffffffffc0201c2e:	85a6                	mv	a1,s1
ffffffffc0201c30:	854a                	mv	a0,s2
ffffffffc0201c32:	0ce000ef          	jal	ra,ffffffffc0201d00 <printfmt>
ffffffffc0201c36:	b34d                	j	ffffffffc02019d8 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201c38:	00001617          	auipc	a2,0x1
ffffffffc0201c3c:	0c060613          	addi	a2,a2,192 # ffffffffc0202cf8 <best_fit_pmm_manager+0x1a0>
ffffffffc0201c40:	85a6                	mv	a1,s1
ffffffffc0201c42:	854a                	mv	a0,s2
ffffffffc0201c44:	0bc000ef          	jal	ra,ffffffffc0201d00 <printfmt>
ffffffffc0201c48:	bb41                	j	ffffffffc02019d8 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201c4a:	00001417          	auipc	s0,0x1
ffffffffc0201c4e:	0a640413          	addi	s0,s0,166 # ffffffffc0202cf0 <best_fit_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c52:	85e2                	mv	a1,s8
ffffffffc0201c54:	8522                	mv	a0,s0
ffffffffc0201c56:	e43e                	sd	a5,8(sp)
ffffffffc0201c58:	200000ef          	jal	ra,ffffffffc0201e58 <strnlen>
ffffffffc0201c5c:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201c60:	01b05b63          	blez	s11,ffffffffc0201c76 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201c64:	67a2                	ld	a5,8(sp)
ffffffffc0201c66:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c6a:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201c6c:	85a6                	mv	a1,s1
ffffffffc0201c6e:	8552                	mv	a0,s4
ffffffffc0201c70:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c72:	fe0d9ce3          	bnez	s11,ffffffffc0201c6a <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c76:	00044783          	lbu	a5,0(s0)
ffffffffc0201c7a:	00140a13          	addi	s4,s0,1
ffffffffc0201c7e:	0007851b          	sext.w	a0,a5
ffffffffc0201c82:	d3a5                	beqz	a5,ffffffffc0201be2 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c84:	05e00413          	li	s0,94
ffffffffc0201c88:	bf39                	j	ffffffffc0201ba6 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201c8a:	000a2403          	lw	s0,0(s4)
ffffffffc0201c8e:	b7ad                	j	ffffffffc0201bf8 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201c90:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c94:	46a1                	li	a3,8
ffffffffc0201c96:	8a2e                	mv	s4,a1
ffffffffc0201c98:	bdb1                	j	ffffffffc0201af4 <vprintfmt+0x156>
ffffffffc0201c9a:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c9e:	46a9                	li	a3,10
ffffffffc0201ca0:	8a2e                	mv	s4,a1
ffffffffc0201ca2:	bd89                	j	ffffffffc0201af4 <vprintfmt+0x156>
ffffffffc0201ca4:	000a6603          	lwu	a2,0(s4)
ffffffffc0201ca8:	46c1                	li	a3,16
ffffffffc0201caa:	8a2e                	mv	s4,a1
ffffffffc0201cac:	b5a1                	j	ffffffffc0201af4 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201cae:	9902                	jalr	s2
ffffffffc0201cb0:	bf09                	j	ffffffffc0201bc2 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201cb2:	85a6                	mv	a1,s1
ffffffffc0201cb4:	02d00513          	li	a0,45
ffffffffc0201cb8:	e03e                	sd	a5,0(sp)
ffffffffc0201cba:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201cbc:	6782                	ld	a5,0(sp)
ffffffffc0201cbe:	8a66                	mv	s4,s9
ffffffffc0201cc0:	40800633          	neg	a2,s0
ffffffffc0201cc4:	46a9                	li	a3,10
ffffffffc0201cc6:	b53d                	j	ffffffffc0201af4 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0201cc8:	03b05163          	blez	s11,ffffffffc0201cea <vprintfmt+0x34c>
ffffffffc0201ccc:	02d00693          	li	a3,45
ffffffffc0201cd0:	f6d79de3          	bne	a5,a3,ffffffffc0201c4a <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201cd4:	00001417          	auipc	s0,0x1
ffffffffc0201cd8:	01c40413          	addi	s0,s0,28 # ffffffffc0202cf0 <best_fit_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201cdc:	02800793          	li	a5,40
ffffffffc0201ce0:	02800513          	li	a0,40
ffffffffc0201ce4:	00140a13          	addi	s4,s0,1
ffffffffc0201ce8:	bd6d                	j	ffffffffc0201ba2 <vprintfmt+0x204>
ffffffffc0201cea:	00001a17          	auipc	s4,0x1
ffffffffc0201cee:	007a0a13          	addi	s4,s4,7 # ffffffffc0202cf1 <best_fit_pmm_manager+0x199>
ffffffffc0201cf2:	02800513          	li	a0,40
ffffffffc0201cf6:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201cfa:	05e00413          	li	s0,94
ffffffffc0201cfe:	b565                	j	ffffffffc0201ba6 <vprintfmt+0x208>

ffffffffc0201d00 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d00:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201d02:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d06:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d08:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d0a:	ec06                	sd	ra,24(sp)
ffffffffc0201d0c:	f83a                	sd	a4,48(sp)
ffffffffc0201d0e:	fc3e                	sd	a5,56(sp)
ffffffffc0201d10:	e0c2                	sd	a6,64(sp)
ffffffffc0201d12:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201d14:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d16:	c89ff0ef          	jal	ra,ffffffffc020199e <vprintfmt>
}
ffffffffc0201d1a:	60e2                	ld	ra,24(sp)
ffffffffc0201d1c:	6161                	addi	sp,sp,80
ffffffffc0201d1e:	8082                	ret

ffffffffc0201d20 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201d20:	715d                	addi	sp,sp,-80
ffffffffc0201d22:	e486                	sd	ra,72(sp)
ffffffffc0201d24:	e0a6                	sd	s1,64(sp)
ffffffffc0201d26:	fc4a                	sd	s2,56(sp)
ffffffffc0201d28:	f84e                	sd	s3,48(sp)
ffffffffc0201d2a:	f452                	sd	s4,40(sp)
ffffffffc0201d2c:	f056                	sd	s5,32(sp)
ffffffffc0201d2e:	ec5a                	sd	s6,24(sp)
ffffffffc0201d30:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0201d32:	c901                	beqz	a0,ffffffffc0201d42 <readline+0x22>
ffffffffc0201d34:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0201d36:	00001517          	auipc	a0,0x1
ffffffffc0201d3a:	fd250513          	addi	a0,a0,-46 # ffffffffc0202d08 <best_fit_pmm_manager+0x1b0>
ffffffffc0201d3e:	b9cfe0ef          	jal	ra,ffffffffc02000da <cprintf>
readline(const char *prompt) {
ffffffffc0201d42:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d44:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201d46:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201d48:	4aa9                	li	s5,10
ffffffffc0201d4a:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201d4c:	00004b97          	auipc	s7,0x4
ffffffffc0201d50:	2f4b8b93          	addi	s7,s7,756 # ffffffffc0206040 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d54:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0201d58:	bfafe0ef          	jal	ra,ffffffffc0200152 <getchar>
        if (c < 0) {
ffffffffc0201d5c:	00054a63          	bltz	a0,ffffffffc0201d70 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d60:	00a95a63          	bge	s2,a0,ffffffffc0201d74 <readline+0x54>
ffffffffc0201d64:	029a5263          	bge	s4,s1,ffffffffc0201d88 <readline+0x68>
        c = getchar();
ffffffffc0201d68:	beafe0ef          	jal	ra,ffffffffc0200152 <getchar>
        if (c < 0) {
ffffffffc0201d6c:	fe055ae3          	bgez	a0,ffffffffc0201d60 <readline+0x40>
            return NULL;
ffffffffc0201d70:	4501                	li	a0,0
ffffffffc0201d72:	a091                	j	ffffffffc0201db6 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0201d74:	03351463          	bne	a0,s3,ffffffffc0201d9c <readline+0x7c>
ffffffffc0201d78:	e8a9                	bnez	s1,ffffffffc0201dca <readline+0xaa>
        c = getchar();
ffffffffc0201d7a:	bd8fe0ef          	jal	ra,ffffffffc0200152 <getchar>
        if (c < 0) {
ffffffffc0201d7e:	fe0549e3          	bltz	a0,ffffffffc0201d70 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d82:	fea959e3          	bge	s2,a0,ffffffffc0201d74 <readline+0x54>
ffffffffc0201d86:	4481                	li	s1,0
            cputchar(c);
ffffffffc0201d88:	e42a                	sd	a0,8(sp)
ffffffffc0201d8a:	b86fe0ef          	jal	ra,ffffffffc0200110 <cputchar>
            buf[i ++] = c;
ffffffffc0201d8e:	6522                	ld	a0,8(sp)
ffffffffc0201d90:	009b87b3          	add	a5,s7,s1
ffffffffc0201d94:	2485                	addiw	s1,s1,1
ffffffffc0201d96:	00a78023          	sb	a0,0(a5)
ffffffffc0201d9a:	bf7d                	j	ffffffffc0201d58 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201d9c:	01550463          	beq	a0,s5,ffffffffc0201da4 <readline+0x84>
ffffffffc0201da0:	fb651ce3          	bne	a0,s6,ffffffffc0201d58 <readline+0x38>
            cputchar(c);
ffffffffc0201da4:	b6cfe0ef          	jal	ra,ffffffffc0200110 <cputchar>
            buf[i] = '\0';
ffffffffc0201da8:	00004517          	auipc	a0,0x4
ffffffffc0201dac:	29850513          	addi	a0,a0,664 # ffffffffc0206040 <buf>
ffffffffc0201db0:	94aa                	add	s1,s1,a0
ffffffffc0201db2:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0201db6:	60a6                	ld	ra,72(sp)
ffffffffc0201db8:	6486                	ld	s1,64(sp)
ffffffffc0201dba:	7962                	ld	s2,56(sp)
ffffffffc0201dbc:	79c2                	ld	s3,48(sp)
ffffffffc0201dbe:	7a22                	ld	s4,40(sp)
ffffffffc0201dc0:	7a82                	ld	s5,32(sp)
ffffffffc0201dc2:	6b62                	ld	s6,24(sp)
ffffffffc0201dc4:	6bc2                	ld	s7,16(sp)
ffffffffc0201dc6:	6161                	addi	sp,sp,80
ffffffffc0201dc8:	8082                	ret
            cputchar(c);
ffffffffc0201dca:	4521                	li	a0,8
ffffffffc0201dcc:	b44fe0ef          	jal	ra,ffffffffc0200110 <cputchar>
            i --;
ffffffffc0201dd0:	34fd                	addiw	s1,s1,-1
ffffffffc0201dd2:	b759                	j	ffffffffc0201d58 <readline+0x38>

ffffffffc0201dd4 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201dd4:	4781                	li	a5,0
ffffffffc0201dd6:	00004717          	auipc	a4,0x4
ffffffffc0201dda:	24273703          	ld	a4,578(a4) # ffffffffc0206018 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201dde:	88ba                	mv	a7,a4
ffffffffc0201de0:	852a                	mv	a0,a0
ffffffffc0201de2:	85be                	mv	a1,a5
ffffffffc0201de4:	863e                	mv	a2,a5
ffffffffc0201de6:	00000073          	ecall
ffffffffc0201dea:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201dec:	8082                	ret

ffffffffc0201dee <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201dee:	4781                	li	a5,0
ffffffffc0201df0:	00004717          	auipc	a4,0x4
ffffffffc0201df4:	6a873703          	ld	a4,1704(a4) # ffffffffc0206498 <SBI_SET_TIMER>
ffffffffc0201df8:	88ba                	mv	a7,a4
ffffffffc0201dfa:	852a                	mv	a0,a0
ffffffffc0201dfc:	85be                	mv	a1,a5
ffffffffc0201dfe:	863e                	mv	a2,a5
ffffffffc0201e00:	00000073          	ecall
ffffffffc0201e04:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201e06:	8082                	ret

ffffffffc0201e08 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201e08:	4501                	li	a0,0
ffffffffc0201e0a:	00004797          	auipc	a5,0x4
ffffffffc0201e0e:	2067b783          	ld	a5,518(a5) # ffffffffc0206010 <SBI_CONSOLE_GETCHAR>
ffffffffc0201e12:	88be                	mv	a7,a5
ffffffffc0201e14:	852a                	mv	a0,a0
ffffffffc0201e16:	85aa                	mv	a1,a0
ffffffffc0201e18:	862a                	mv	a2,a0
ffffffffc0201e1a:	00000073          	ecall
ffffffffc0201e1e:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201e20:	2501                	sext.w	a0,a0
ffffffffc0201e22:	8082                	ret

ffffffffc0201e24 <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201e24:	4781                	li	a5,0
ffffffffc0201e26:	00004717          	auipc	a4,0x4
ffffffffc0201e2a:	1fa73703          	ld	a4,506(a4) # ffffffffc0206020 <SBI_SHUTDOWN>
ffffffffc0201e2e:	88ba                	mv	a7,a4
ffffffffc0201e30:	853e                	mv	a0,a5
ffffffffc0201e32:	85be                	mv	a1,a5
ffffffffc0201e34:	863e                	mv	a2,a5
ffffffffc0201e36:	00000073          	ecall
ffffffffc0201e3a:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201e3c:	8082                	ret

ffffffffc0201e3e <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201e3e:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201e42:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201e44:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201e46:	cb81                	beqz	a5,ffffffffc0201e56 <strlen+0x18>
        cnt ++;
ffffffffc0201e48:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201e4a:	00a707b3          	add	a5,a4,a0
ffffffffc0201e4e:	0007c783          	lbu	a5,0(a5)
ffffffffc0201e52:	fbfd                	bnez	a5,ffffffffc0201e48 <strlen+0xa>
ffffffffc0201e54:	8082                	ret
    }
    return cnt;
}
ffffffffc0201e56:	8082                	ret

ffffffffc0201e58 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201e58:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e5a:	e589                	bnez	a1,ffffffffc0201e64 <strnlen+0xc>
ffffffffc0201e5c:	a811                	j	ffffffffc0201e70 <strnlen+0x18>
        cnt ++;
ffffffffc0201e5e:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e60:	00f58863          	beq	a1,a5,ffffffffc0201e70 <strnlen+0x18>
ffffffffc0201e64:	00f50733          	add	a4,a0,a5
ffffffffc0201e68:	00074703          	lbu	a4,0(a4)
ffffffffc0201e6c:	fb6d                	bnez	a4,ffffffffc0201e5e <strnlen+0x6>
ffffffffc0201e6e:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201e70:	852e                	mv	a0,a1
ffffffffc0201e72:	8082                	ret

ffffffffc0201e74 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e74:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e78:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e7c:	cb89                	beqz	a5,ffffffffc0201e8e <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201e7e:	0505                	addi	a0,a0,1
ffffffffc0201e80:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e82:	fee789e3          	beq	a5,a4,ffffffffc0201e74 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e86:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201e8a:	9d19                	subw	a0,a0,a4
ffffffffc0201e8c:	8082                	ret
ffffffffc0201e8e:	4501                	li	a0,0
ffffffffc0201e90:	bfed                	j	ffffffffc0201e8a <strcmp+0x16>

ffffffffc0201e92 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e92:	c20d                	beqz	a2,ffffffffc0201eb4 <strncmp+0x22>
ffffffffc0201e94:	962e                	add	a2,a2,a1
ffffffffc0201e96:	a031                	j	ffffffffc0201ea2 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0201e98:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e9a:	00e79a63          	bne	a5,a4,ffffffffc0201eae <strncmp+0x1c>
ffffffffc0201e9e:	00b60b63          	beq	a2,a1,ffffffffc0201eb4 <strncmp+0x22>
ffffffffc0201ea2:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201ea6:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201ea8:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0201eac:	f7f5                	bnez	a5,ffffffffc0201e98 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201eae:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0201eb2:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201eb4:	4501                	li	a0,0
ffffffffc0201eb6:	8082                	ret

ffffffffc0201eb8 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201eb8:	00054783          	lbu	a5,0(a0)
ffffffffc0201ebc:	c799                	beqz	a5,ffffffffc0201eca <strchr+0x12>
        if (*s == c) {
ffffffffc0201ebe:	00f58763          	beq	a1,a5,ffffffffc0201ecc <strchr+0x14>
    while (*s != '\0') {
ffffffffc0201ec2:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0201ec6:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201ec8:	fbfd                	bnez	a5,ffffffffc0201ebe <strchr+0x6>
    }
    return NULL;
ffffffffc0201eca:	4501                	li	a0,0
}
ffffffffc0201ecc:	8082                	ret

ffffffffc0201ece <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201ece:	ca01                	beqz	a2,ffffffffc0201ede <memset+0x10>
ffffffffc0201ed0:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201ed2:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201ed4:	0785                	addi	a5,a5,1
ffffffffc0201ed6:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201eda:	fec79de3          	bne	a5,a2,ffffffffc0201ed4 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201ede:	8082                	ret
