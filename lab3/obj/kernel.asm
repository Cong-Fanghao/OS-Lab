
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
ffffffffc020006c:	65f010ef          	jal	ra,ffffffffc0201eca <memset>
    dtb_init();
ffffffffc0200070:	40a000ef          	jal	ra,ffffffffc020047a <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	3f8000ef          	jal	ra,ffffffffc020046c <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00002517          	auipc	a0,0x2
ffffffffc020007c:	e6850513          	addi	a0,a0,-408 # ffffffffc0201ee0 <etext+0x4>
ffffffffc0200080:	08c000ef          	jal	ra,ffffffffc020010c <cputs>

    print_kerninfo();
ffffffffc0200084:	0d8000ef          	jal	ra,ffffffffc020015c <print_kerninfo>

    // grade_backtrace();
    // idt_init();  // init interrupt descriptor table

    pmm_init();  // init physical memory management
ffffffffc0200088:	6c6010ef          	jal	ra,ffffffffc020174e <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc020008c:	7aa000ef          	jal	ra,ffffffffc0200836 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200090:	39a000ef          	jal	ra,ffffffffc020042a <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200094:	796000ef          	jal	ra,ffffffffc020082a <intr_enable>

    /* do nothing */
    while (1)
ffffffffc0200098:	a001                	j	ffffffffc0200098 <kern_init+0x44>

ffffffffc020009a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc020009a:	1141                	addi	sp,sp,-16
ffffffffc020009c:	e022                	sd	s0,0(sp)
ffffffffc020009e:	e406                	sd	ra,8(sp)
ffffffffc02000a0:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc02000a2:	3cc000ef          	jal	ra,ffffffffc020046e <cons_putc>
    (*cnt) ++;
ffffffffc02000a6:	401c                	lw	a5,0(s0)
}
ffffffffc02000a8:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc02000aa:	2785                	addiw	a5,a5,1
ffffffffc02000ac:	c01c                	sw	a5,0(s0)
}
ffffffffc02000ae:	6402                	ld	s0,0(sp)
ffffffffc02000b0:	0141                	addi	sp,sp,16
ffffffffc02000b2:	8082                	ret

ffffffffc02000b4 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000b4:	1101                	addi	sp,sp,-32
ffffffffc02000b6:	862a                	mv	a2,a0
ffffffffc02000b8:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ba:	00000517          	auipc	a0,0x0
ffffffffc02000be:	fe050513          	addi	a0,a0,-32 # ffffffffc020009a <cputch>
ffffffffc02000c2:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000c4:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000c6:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c8:	0d3010ef          	jal	ra,ffffffffc020199a <vprintfmt>
    return cnt;
}
ffffffffc02000cc:	60e2                	ld	ra,24(sp)
ffffffffc02000ce:	4532                	lw	a0,12(sp)
ffffffffc02000d0:	6105                	addi	sp,sp,32
ffffffffc02000d2:	8082                	ret

ffffffffc02000d4 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000d4:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000d6:	02810313          	addi	t1,sp,40 # ffffffffc0205028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000da:	8e2a                	mv	t3,a0
ffffffffc02000dc:	f42e                	sd	a1,40(sp)
ffffffffc02000de:	f832                	sd	a2,48(sp)
ffffffffc02000e0:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000e2:	00000517          	auipc	a0,0x0
ffffffffc02000e6:	fb850513          	addi	a0,a0,-72 # ffffffffc020009a <cputch>
ffffffffc02000ea:	004c                	addi	a1,sp,4
ffffffffc02000ec:	869a                	mv	a3,t1
ffffffffc02000ee:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000f0:	ec06                	sd	ra,24(sp)
ffffffffc02000f2:	e0ba                	sd	a4,64(sp)
ffffffffc02000f4:	e4be                	sd	a5,72(sp)
ffffffffc02000f6:	e8c2                	sd	a6,80(sp)
ffffffffc02000f8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02000fa:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02000fc:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000fe:	09d010ef          	jal	ra,ffffffffc020199a <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc0200102:	60e2                	ld	ra,24(sp)
ffffffffc0200104:	4512                	lw	a0,4(sp)
ffffffffc0200106:	6125                	addi	sp,sp,96
ffffffffc0200108:	8082                	ret

ffffffffc020010a <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc020010a:	a695                	j	ffffffffc020046e <cons_putc>

ffffffffc020010c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc020010c:	1101                	addi	sp,sp,-32
ffffffffc020010e:	e822                	sd	s0,16(sp)
ffffffffc0200110:	ec06                	sd	ra,24(sp)
ffffffffc0200112:	e426                	sd	s1,8(sp)
ffffffffc0200114:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200116:	00054503          	lbu	a0,0(a0)
ffffffffc020011a:	c51d                	beqz	a0,ffffffffc0200148 <cputs+0x3c>
ffffffffc020011c:	0405                	addi	s0,s0,1
ffffffffc020011e:	4485                	li	s1,1
ffffffffc0200120:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200122:	34c000ef          	jal	ra,ffffffffc020046e <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200126:	00044503          	lbu	a0,0(s0)
ffffffffc020012a:	008487bb          	addw	a5,s1,s0
ffffffffc020012e:	0405                	addi	s0,s0,1
ffffffffc0200130:	f96d                	bnez	a0,ffffffffc0200122 <cputs+0x16>
    (*cnt) ++;
ffffffffc0200132:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200136:	4529                	li	a0,10
ffffffffc0200138:	336000ef          	jal	ra,ffffffffc020046e <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020013c:	60e2                	ld	ra,24(sp)
ffffffffc020013e:	8522                	mv	a0,s0
ffffffffc0200140:	6442                	ld	s0,16(sp)
ffffffffc0200142:	64a2                	ld	s1,8(sp)
ffffffffc0200144:	6105                	addi	sp,sp,32
ffffffffc0200146:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc0200148:	4405                	li	s0,1
ffffffffc020014a:	b7f5                	j	ffffffffc0200136 <cputs+0x2a>

ffffffffc020014c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc020014c:	1141                	addi	sp,sp,-16
ffffffffc020014e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200150:	326000ef          	jal	ra,ffffffffc0200476 <cons_getc>
ffffffffc0200154:	dd75                	beqz	a0,ffffffffc0200150 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200156:	60a2                	ld	ra,8(sp)
ffffffffc0200158:	0141                	addi	sp,sp,16
ffffffffc020015a:	8082                	ret

ffffffffc020015c <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc020015c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020015e:	00002517          	auipc	a0,0x2
ffffffffc0200162:	da250513          	addi	a0,a0,-606 # ffffffffc0201f00 <etext+0x24>
void print_kerninfo(void) {
ffffffffc0200166:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200168:	f6dff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc020016c:	00000597          	auipc	a1,0x0
ffffffffc0200170:	ee858593          	addi	a1,a1,-280 # ffffffffc0200054 <kern_init>
ffffffffc0200174:	00002517          	auipc	a0,0x2
ffffffffc0200178:	dac50513          	addi	a0,a0,-596 # ffffffffc0201f20 <etext+0x44>
ffffffffc020017c:	f59ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc0200180:	00002597          	auipc	a1,0x2
ffffffffc0200184:	d5c58593          	addi	a1,a1,-676 # ffffffffc0201edc <etext>
ffffffffc0200188:	00002517          	auipc	a0,0x2
ffffffffc020018c:	db850513          	addi	a0,a0,-584 # ffffffffc0201f40 <etext+0x64>
ffffffffc0200190:	f45ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc0200194:	00006597          	auipc	a1,0x6
ffffffffc0200198:	e9458593          	addi	a1,a1,-364 # ffffffffc0206028 <free_area>
ffffffffc020019c:	00002517          	auipc	a0,0x2
ffffffffc02001a0:	dc450513          	addi	a0,a0,-572 # ffffffffc0201f60 <etext+0x84>
ffffffffc02001a4:	f31ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc02001a8:	00006597          	auipc	a1,0x6
ffffffffc02001ac:	2f858593          	addi	a1,a1,760 # ffffffffc02064a0 <end>
ffffffffc02001b0:	00002517          	auipc	a0,0x2
ffffffffc02001b4:	dd050513          	addi	a0,a0,-560 # ffffffffc0201f80 <etext+0xa4>
ffffffffc02001b8:	f1dff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc02001bc:	00006597          	auipc	a1,0x6
ffffffffc02001c0:	6e358593          	addi	a1,a1,1763 # ffffffffc020689f <end+0x3ff>
ffffffffc02001c4:	00000797          	auipc	a5,0x0
ffffffffc02001c8:	e9078793          	addi	a5,a5,-368 # ffffffffc0200054 <kern_init>
ffffffffc02001cc:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d0:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02001d4:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001d6:	3ff5f593          	andi	a1,a1,1023
ffffffffc02001da:	95be                	add	a1,a1,a5
ffffffffc02001dc:	85a9                	srai	a1,a1,0xa
ffffffffc02001de:	00002517          	auipc	a0,0x2
ffffffffc02001e2:	dc250513          	addi	a0,a0,-574 # ffffffffc0201fa0 <etext+0xc4>
}
ffffffffc02001e6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02001e8:	b5f5                	j	ffffffffc02000d4 <cprintf>

ffffffffc02001ea <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc02001ea:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02001ec:	00002617          	auipc	a2,0x2
ffffffffc02001f0:	de460613          	addi	a2,a2,-540 # ffffffffc0201fd0 <etext+0xf4>
ffffffffc02001f4:	04d00593          	li	a1,77
ffffffffc02001f8:	00002517          	auipc	a0,0x2
ffffffffc02001fc:	df050513          	addi	a0,a0,-528 # ffffffffc0201fe8 <etext+0x10c>
void print_stackframe(void) {
ffffffffc0200200:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200202:	1cc000ef          	jal	ra,ffffffffc02003ce <__panic>

ffffffffc0200206 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200206:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200208:	00002617          	auipc	a2,0x2
ffffffffc020020c:	df860613          	addi	a2,a2,-520 # ffffffffc0202000 <etext+0x124>
ffffffffc0200210:	00002597          	auipc	a1,0x2
ffffffffc0200214:	e1058593          	addi	a1,a1,-496 # ffffffffc0202020 <etext+0x144>
ffffffffc0200218:	00002517          	auipc	a0,0x2
ffffffffc020021c:	e1050513          	addi	a0,a0,-496 # ffffffffc0202028 <etext+0x14c>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200220:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200222:	eb3ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
ffffffffc0200226:	00002617          	auipc	a2,0x2
ffffffffc020022a:	e1260613          	addi	a2,a2,-494 # ffffffffc0202038 <etext+0x15c>
ffffffffc020022e:	00002597          	auipc	a1,0x2
ffffffffc0200232:	e3258593          	addi	a1,a1,-462 # ffffffffc0202060 <etext+0x184>
ffffffffc0200236:	00002517          	auipc	a0,0x2
ffffffffc020023a:	df250513          	addi	a0,a0,-526 # ffffffffc0202028 <etext+0x14c>
ffffffffc020023e:	e97ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
ffffffffc0200242:	00002617          	auipc	a2,0x2
ffffffffc0200246:	e2e60613          	addi	a2,a2,-466 # ffffffffc0202070 <etext+0x194>
ffffffffc020024a:	00002597          	auipc	a1,0x2
ffffffffc020024e:	e4658593          	addi	a1,a1,-442 # ffffffffc0202090 <etext+0x1b4>
ffffffffc0200252:	00002517          	auipc	a0,0x2
ffffffffc0200256:	dd650513          	addi	a0,a0,-554 # ffffffffc0202028 <etext+0x14c>
ffffffffc020025a:	e7bff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    }
    return 0;
}
ffffffffc020025e:	60a2                	ld	ra,8(sp)
ffffffffc0200260:	4501                	li	a0,0
ffffffffc0200262:	0141                	addi	sp,sp,16
ffffffffc0200264:	8082                	ret

ffffffffc0200266 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200266:	1141                	addi	sp,sp,-16
ffffffffc0200268:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020026a:	ef3ff0ef          	jal	ra,ffffffffc020015c <print_kerninfo>
    return 0;
}
ffffffffc020026e:	60a2                	ld	ra,8(sp)
ffffffffc0200270:	4501                	li	a0,0
ffffffffc0200272:	0141                	addi	sp,sp,16
ffffffffc0200274:	8082                	ret

ffffffffc0200276 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200276:	1141                	addi	sp,sp,-16
ffffffffc0200278:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020027a:	f71ff0ef          	jal	ra,ffffffffc02001ea <print_stackframe>
    return 0;
}
ffffffffc020027e:	60a2                	ld	ra,8(sp)
ffffffffc0200280:	4501                	li	a0,0
ffffffffc0200282:	0141                	addi	sp,sp,16
ffffffffc0200284:	8082                	ret

ffffffffc0200286 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200286:	7115                	addi	sp,sp,-224
ffffffffc0200288:	ed5e                	sd	s7,152(sp)
ffffffffc020028a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020028c:	00002517          	auipc	a0,0x2
ffffffffc0200290:	e1450513          	addi	a0,a0,-492 # ffffffffc02020a0 <etext+0x1c4>
kmonitor(struct trapframe *tf) {
ffffffffc0200294:	ed86                	sd	ra,216(sp)
ffffffffc0200296:	e9a2                	sd	s0,208(sp)
ffffffffc0200298:	e5a6                	sd	s1,200(sp)
ffffffffc020029a:	e1ca                	sd	s2,192(sp)
ffffffffc020029c:	fd4e                	sd	s3,184(sp)
ffffffffc020029e:	f952                	sd	s4,176(sp)
ffffffffc02002a0:	f556                	sd	s5,168(sp)
ffffffffc02002a2:	f15a                	sd	s6,160(sp)
ffffffffc02002a4:	e962                	sd	s8,144(sp)
ffffffffc02002a6:	e566                	sd	s9,136(sp)
ffffffffc02002a8:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002aa:	e2bff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc02002ae:	00002517          	auipc	a0,0x2
ffffffffc02002b2:	e1a50513          	addi	a0,a0,-486 # ffffffffc02020c8 <etext+0x1ec>
ffffffffc02002b6:	e1fff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    if (tf != NULL) {
ffffffffc02002ba:	000b8563          	beqz	s7,ffffffffc02002c4 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc02002be:	855e                	mv	a0,s7
ffffffffc02002c0:	756000ef          	jal	ra,ffffffffc0200a16 <print_trapframe>
ffffffffc02002c4:	00002c17          	auipc	s8,0x2
ffffffffc02002c8:	e74c0c13          	addi	s8,s8,-396 # ffffffffc0202138 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002cc:	00002917          	auipc	s2,0x2
ffffffffc02002d0:	e2490913          	addi	s2,s2,-476 # ffffffffc02020f0 <etext+0x214>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002d4:	00002497          	auipc	s1,0x2
ffffffffc02002d8:	e2448493          	addi	s1,s1,-476 # ffffffffc02020f8 <etext+0x21c>
        if (argc == MAXARGS - 1) {
ffffffffc02002dc:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02002de:	00002b17          	auipc	s6,0x2
ffffffffc02002e2:	e22b0b13          	addi	s6,s6,-478 # ffffffffc0202100 <etext+0x224>
        argv[argc ++] = buf;
ffffffffc02002e6:	00002a17          	auipc	s4,0x2
ffffffffc02002ea:	d3aa0a13          	addi	s4,s4,-710 # ffffffffc0202020 <etext+0x144>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02002ee:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02002f0:	854a                	mv	a0,s2
ffffffffc02002f2:	22b010ef          	jal	ra,ffffffffc0201d1c <readline>
ffffffffc02002f6:	842a                	mv	s0,a0
ffffffffc02002f8:	dd65                	beqz	a0,ffffffffc02002f0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02002fa:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02002fe:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200300:	e1bd                	bnez	a1,ffffffffc0200366 <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc0200302:	fe0c87e3          	beqz	s9,ffffffffc02002f0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200306:	6582                	ld	a1,0(sp)
ffffffffc0200308:	00002d17          	auipc	s10,0x2
ffffffffc020030c:	e30d0d13          	addi	s10,s10,-464 # ffffffffc0202138 <commands>
        argv[argc ++] = buf;
ffffffffc0200310:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200312:	4401                	li	s0,0
ffffffffc0200314:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200316:	35b010ef          	jal	ra,ffffffffc0201e70 <strcmp>
ffffffffc020031a:	c919                	beqz	a0,ffffffffc0200330 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020031c:	2405                	addiw	s0,s0,1
ffffffffc020031e:	0b540063          	beq	s0,s5,ffffffffc02003be <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200322:	000d3503          	ld	a0,0(s10)
ffffffffc0200326:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200328:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020032a:	347010ef          	jal	ra,ffffffffc0201e70 <strcmp>
ffffffffc020032e:	f57d                	bnez	a0,ffffffffc020031c <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200330:	00141793          	slli	a5,s0,0x1
ffffffffc0200334:	97a2                	add	a5,a5,s0
ffffffffc0200336:	078e                	slli	a5,a5,0x3
ffffffffc0200338:	97e2                	add	a5,a5,s8
ffffffffc020033a:	6b9c                	ld	a5,16(a5)
ffffffffc020033c:	865e                	mv	a2,s7
ffffffffc020033e:	002c                	addi	a1,sp,8
ffffffffc0200340:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200344:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200346:	fa0555e3          	bgez	a0,ffffffffc02002f0 <kmonitor+0x6a>
}
ffffffffc020034a:	60ee                	ld	ra,216(sp)
ffffffffc020034c:	644e                	ld	s0,208(sp)
ffffffffc020034e:	64ae                	ld	s1,200(sp)
ffffffffc0200350:	690e                	ld	s2,192(sp)
ffffffffc0200352:	79ea                	ld	s3,184(sp)
ffffffffc0200354:	7a4a                	ld	s4,176(sp)
ffffffffc0200356:	7aaa                	ld	s5,168(sp)
ffffffffc0200358:	7b0a                	ld	s6,160(sp)
ffffffffc020035a:	6bea                	ld	s7,152(sp)
ffffffffc020035c:	6c4a                	ld	s8,144(sp)
ffffffffc020035e:	6caa                	ld	s9,136(sp)
ffffffffc0200360:	6d0a                	ld	s10,128(sp)
ffffffffc0200362:	612d                	addi	sp,sp,224
ffffffffc0200364:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200366:	8526                	mv	a0,s1
ffffffffc0200368:	34d010ef          	jal	ra,ffffffffc0201eb4 <strchr>
ffffffffc020036c:	c901                	beqz	a0,ffffffffc020037c <kmonitor+0xf6>
ffffffffc020036e:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc0200372:	00040023          	sb	zero,0(s0)
ffffffffc0200376:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200378:	d5c9                	beqz	a1,ffffffffc0200302 <kmonitor+0x7c>
ffffffffc020037a:	b7f5                	j	ffffffffc0200366 <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc020037c:	00044783          	lbu	a5,0(s0)
ffffffffc0200380:	d3c9                	beqz	a5,ffffffffc0200302 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc0200382:	033c8963          	beq	s9,s3,ffffffffc02003b4 <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc0200386:	003c9793          	slli	a5,s9,0x3
ffffffffc020038a:	0118                	addi	a4,sp,128
ffffffffc020038c:	97ba                	add	a5,a5,a4
ffffffffc020038e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200392:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200396:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200398:	e591                	bnez	a1,ffffffffc02003a4 <kmonitor+0x11e>
ffffffffc020039a:	b7b5                	j	ffffffffc0200306 <kmonitor+0x80>
ffffffffc020039c:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc02003a0:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003a2:	d1a5                	beqz	a1,ffffffffc0200302 <kmonitor+0x7c>
ffffffffc02003a4:	8526                	mv	a0,s1
ffffffffc02003a6:	30f010ef          	jal	ra,ffffffffc0201eb4 <strchr>
ffffffffc02003aa:	d96d                	beqz	a0,ffffffffc020039c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ac:	00044583          	lbu	a1,0(s0)
ffffffffc02003b0:	d9a9                	beqz	a1,ffffffffc0200302 <kmonitor+0x7c>
ffffffffc02003b2:	bf55                	j	ffffffffc0200366 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003b4:	45c1                	li	a1,16
ffffffffc02003b6:	855a                	mv	a0,s6
ffffffffc02003b8:	d1dff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
ffffffffc02003bc:	b7e9                	j	ffffffffc0200386 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02003be:	6582                	ld	a1,0(sp)
ffffffffc02003c0:	00002517          	auipc	a0,0x2
ffffffffc02003c4:	d6050513          	addi	a0,a0,-672 # ffffffffc0202120 <etext+0x244>
ffffffffc02003c8:	d0dff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    return 0;
ffffffffc02003cc:	b715                	j	ffffffffc02002f0 <kmonitor+0x6a>

ffffffffc02003ce <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02003ce:	00006317          	auipc	t1,0x6
ffffffffc02003d2:	07230313          	addi	t1,t1,114 # ffffffffc0206440 <is_panic>
ffffffffc02003d6:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02003da:	715d                	addi	sp,sp,-80
ffffffffc02003dc:	ec06                	sd	ra,24(sp)
ffffffffc02003de:	e822                	sd	s0,16(sp)
ffffffffc02003e0:	f436                	sd	a3,40(sp)
ffffffffc02003e2:	f83a                	sd	a4,48(sp)
ffffffffc02003e4:	fc3e                	sd	a5,56(sp)
ffffffffc02003e6:	e0c2                	sd	a6,64(sp)
ffffffffc02003e8:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02003ea:	020e1a63          	bnez	t3,ffffffffc020041e <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02003ee:	4785                	li	a5,1
ffffffffc02003f0:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02003f4:	8432                	mv	s0,a2
ffffffffc02003f6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02003f8:	862e                	mv	a2,a1
ffffffffc02003fa:	85aa                	mv	a1,a0
ffffffffc02003fc:	00002517          	auipc	a0,0x2
ffffffffc0200400:	d8450513          	addi	a0,a0,-636 # ffffffffc0202180 <commands+0x48>
    va_start(ap, fmt);
ffffffffc0200404:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200406:	ccfff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020040a:	65a2                	ld	a1,8(sp)
ffffffffc020040c:	8522                	mv	a0,s0
ffffffffc020040e:	ca7ff0ef          	jal	ra,ffffffffc02000b4 <vcprintf>
    cprintf("\n");
ffffffffc0200412:	00002517          	auipc	a0,0x2
ffffffffc0200416:	bb650513          	addi	a0,a0,-1098 # ffffffffc0201fc8 <etext+0xec>
ffffffffc020041a:	cbbff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020041e:	412000ef          	jal	ra,ffffffffc0200830 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200422:	4501                	li	a0,0
ffffffffc0200424:	e63ff0ef          	jal	ra,ffffffffc0200286 <kmonitor>
    while (1) {
ffffffffc0200428:	bfed                	j	ffffffffc0200422 <__panic+0x54>

ffffffffc020042a <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc020042a:	1141                	addi	sp,sp,-16
ffffffffc020042c:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc020042e:	02000793          	li	a5,32
ffffffffc0200432:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200436:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020043a:	67e1                	lui	a5,0x18
ffffffffc020043c:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200440:	953e                	add	a0,a0,a5
ffffffffc0200442:	1a9010ef          	jal	ra,ffffffffc0201dea <sbi_set_timer>
}
ffffffffc0200446:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200448:	00006797          	auipc	a5,0x6
ffffffffc020044c:	0007b023          	sd	zero,0(a5) # ffffffffc0206448 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200450:	00002517          	auipc	a0,0x2
ffffffffc0200454:	d5050513          	addi	a0,a0,-688 # ffffffffc02021a0 <commands+0x68>
}
ffffffffc0200458:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc020045a:	b9ad                	j	ffffffffc02000d4 <cprintf>

ffffffffc020045c <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc020045c:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200460:	67e1                	lui	a5,0x18
ffffffffc0200462:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200466:	953e                	add	a0,a0,a5
ffffffffc0200468:	1830106f          	j	ffffffffc0201dea <sbi_set_timer>

ffffffffc020046c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020046c:	8082                	ret

ffffffffc020046e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020046e:	0ff57513          	zext.b	a0,a0
ffffffffc0200472:	15f0106f          	j	ffffffffc0201dd0 <sbi_console_putchar>

ffffffffc0200476 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200476:	18f0106f          	j	ffffffffc0201e04 <sbi_console_getchar>

ffffffffc020047a <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc020047a:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc020047c:	00002517          	auipc	a0,0x2
ffffffffc0200480:	d4450513          	addi	a0,a0,-700 # ffffffffc02021c0 <commands+0x88>
void dtb_init(void) {
ffffffffc0200484:	fc86                	sd	ra,120(sp)
ffffffffc0200486:	f8a2                	sd	s0,112(sp)
ffffffffc0200488:	e8d2                	sd	s4,80(sp)
ffffffffc020048a:	f4a6                	sd	s1,104(sp)
ffffffffc020048c:	f0ca                	sd	s2,96(sp)
ffffffffc020048e:	ecce                	sd	s3,88(sp)
ffffffffc0200490:	e4d6                	sd	s5,72(sp)
ffffffffc0200492:	e0da                	sd	s6,64(sp)
ffffffffc0200494:	fc5e                	sd	s7,56(sp)
ffffffffc0200496:	f862                	sd	s8,48(sp)
ffffffffc0200498:	f466                	sd	s9,40(sp)
ffffffffc020049a:	f06a                	sd	s10,32(sp)
ffffffffc020049c:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc020049e:	c37ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02004a2:	00006597          	auipc	a1,0x6
ffffffffc02004a6:	b5e5b583          	ld	a1,-1186(a1) # ffffffffc0206000 <boot_hartid>
ffffffffc02004aa:	00002517          	auipc	a0,0x2
ffffffffc02004ae:	d2650513          	addi	a0,a0,-730 # ffffffffc02021d0 <commands+0x98>
ffffffffc02004b2:	c23ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02004b6:	00006417          	auipc	s0,0x6
ffffffffc02004ba:	b5240413          	addi	s0,s0,-1198 # ffffffffc0206008 <boot_dtb>
ffffffffc02004be:	600c                	ld	a1,0(s0)
ffffffffc02004c0:	00002517          	auipc	a0,0x2
ffffffffc02004c4:	d2050513          	addi	a0,a0,-736 # ffffffffc02021e0 <commands+0xa8>
ffffffffc02004c8:	c0dff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02004cc:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02004d0:	00002517          	auipc	a0,0x2
ffffffffc02004d4:	d2850513          	addi	a0,a0,-728 # ffffffffc02021f8 <commands+0xc0>
    if (boot_dtb == 0) {
ffffffffc02004d8:	120a0463          	beqz	s4,ffffffffc0200600 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02004dc:	57f5                	li	a5,-3
ffffffffc02004de:	07fa                	slli	a5,a5,0x1e
ffffffffc02004e0:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02004e4:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e6:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ea:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ec:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02004f0:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f4:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f8:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200500:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200502:	8ec9                	or	a3,a3,a0
ffffffffc0200504:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200508:	1b7d                	addi	s6,s6,-1
ffffffffc020050a:	0167f7b3          	and	a5,a5,s6
ffffffffc020050e:	8dd5                	or	a1,a1,a3
ffffffffc0200510:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200512:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200516:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200518:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed9a4d>
ffffffffc020051c:	10f59163          	bne	a1,a5,ffffffffc020061e <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc0200520:	471c                	lw	a5,8(a4)
ffffffffc0200522:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc0200524:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200526:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020052a:	0086d51b          	srliw	a0,a3,0x8
ffffffffc020052e:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200532:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200536:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020053a:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020053e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200542:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200546:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020054a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020054e:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200550:	01146433          	or	s0,s0,a7
ffffffffc0200554:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200558:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020055c:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020055e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200562:	8c49                	or	s0,s0,a0
ffffffffc0200564:	0166f6b3          	and	a3,a3,s6
ffffffffc0200568:	00ca6a33          	or	s4,s4,a2
ffffffffc020056c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200570:	8c55                	or	s0,s0,a3
ffffffffc0200572:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200576:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200578:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020057a:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020057c:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200580:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200582:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200584:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200588:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020058a:	00002917          	auipc	s2,0x2
ffffffffc020058e:	cbe90913          	addi	s2,s2,-834 # ffffffffc0202248 <commands+0x110>
ffffffffc0200592:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200594:	4d91                	li	s11,4
ffffffffc0200596:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200598:	00002497          	auipc	s1,0x2
ffffffffc020059c:	ca848493          	addi	s1,s1,-856 # ffffffffc0202240 <commands+0x108>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02005a0:	000a2703          	lw	a4,0(s4)
ffffffffc02005a4:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a8:	0087569b          	srliw	a3,a4,0x8
ffffffffc02005ac:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b0:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005b4:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b8:	0107571b          	srliw	a4,a4,0x10
ffffffffc02005bc:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005be:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c2:	0087171b          	slliw	a4,a4,0x8
ffffffffc02005c6:	8fd5                	or	a5,a5,a3
ffffffffc02005c8:	00eb7733          	and	a4,s6,a4
ffffffffc02005cc:	8fd9                	or	a5,a5,a4
ffffffffc02005ce:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc02005d0:	09778c63          	beq	a5,s7,ffffffffc0200668 <dtb_init+0x1ee>
ffffffffc02005d4:	00fbea63          	bltu	s7,a5,ffffffffc02005e8 <dtb_init+0x16e>
ffffffffc02005d8:	07a78663          	beq	a5,s10,ffffffffc0200644 <dtb_init+0x1ca>
ffffffffc02005dc:	4709                	li	a4,2
ffffffffc02005de:	00e79763          	bne	a5,a4,ffffffffc02005ec <dtb_init+0x172>
ffffffffc02005e2:	4c81                	li	s9,0
ffffffffc02005e4:	8a56                	mv	s4,s5
ffffffffc02005e6:	bf6d                	j	ffffffffc02005a0 <dtb_init+0x126>
ffffffffc02005e8:	ffb78ee3          	beq	a5,s11,ffffffffc02005e4 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02005ec:	00002517          	auipc	a0,0x2
ffffffffc02005f0:	cd450513          	addi	a0,a0,-812 # ffffffffc02022c0 <commands+0x188>
ffffffffc02005f4:	ae1ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02005f8:	00002517          	auipc	a0,0x2
ffffffffc02005fc:	d0050513          	addi	a0,a0,-768 # ffffffffc02022f8 <commands+0x1c0>
}
ffffffffc0200600:	7446                	ld	s0,112(sp)
ffffffffc0200602:	70e6                	ld	ra,120(sp)
ffffffffc0200604:	74a6                	ld	s1,104(sp)
ffffffffc0200606:	7906                	ld	s2,96(sp)
ffffffffc0200608:	69e6                	ld	s3,88(sp)
ffffffffc020060a:	6a46                	ld	s4,80(sp)
ffffffffc020060c:	6aa6                	ld	s5,72(sp)
ffffffffc020060e:	6b06                	ld	s6,64(sp)
ffffffffc0200610:	7be2                	ld	s7,56(sp)
ffffffffc0200612:	7c42                	ld	s8,48(sp)
ffffffffc0200614:	7ca2                	ld	s9,40(sp)
ffffffffc0200616:	7d02                	ld	s10,32(sp)
ffffffffc0200618:	6de2                	ld	s11,24(sp)
ffffffffc020061a:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020061c:	bc65                	j	ffffffffc02000d4 <cprintf>
}
ffffffffc020061e:	7446                	ld	s0,112(sp)
ffffffffc0200620:	70e6                	ld	ra,120(sp)
ffffffffc0200622:	74a6                	ld	s1,104(sp)
ffffffffc0200624:	7906                	ld	s2,96(sp)
ffffffffc0200626:	69e6                	ld	s3,88(sp)
ffffffffc0200628:	6a46                	ld	s4,80(sp)
ffffffffc020062a:	6aa6                	ld	s5,72(sp)
ffffffffc020062c:	6b06                	ld	s6,64(sp)
ffffffffc020062e:	7be2                	ld	s7,56(sp)
ffffffffc0200630:	7c42                	ld	s8,48(sp)
ffffffffc0200632:	7ca2                	ld	s9,40(sp)
ffffffffc0200634:	7d02                	ld	s10,32(sp)
ffffffffc0200636:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200638:	00002517          	auipc	a0,0x2
ffffffffc020063c:	be050513          	addi	a0,a0,-1056 # ffffffffc0202218 <commands+0xe0>
}
ffffffffc0200640:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200642:	bc49                	j	ffffffffc02000d4 <cprintf>
                int name_len = strlen(name);
ffffffffc0200644:	8556                	mv	a0,s5
ffffffffc0200646:	7f4010ef          	jal	ra,ffffffffc0201e3a <strlen>
ffffffffc020064a:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020064c:	4619                	li	a2,6
ffffffffc020064e:	85a6                	mv	a1,s1
ffffffffc0200650:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200652:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200654:	03b010ef          	jal	ra,ffffffffc0201e8e <strncmp>
ffffffffc0200658:	e111                	bnez	a0,ffffffffc020065c <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc020065a:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020065c:	0a91                	addi	s5,s5,4
ffffffffc020065e:	9ad2                	add	s5,s5,s4
ffffffffc0200660:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200664:	8a56                	mv	s4,s5
ffffffffc0200666:	bf2d                	j	ffffffffc02005a0 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200668:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020066c:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200674:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200684:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200688:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020068c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200690:	00eaeab3          	or	s5,s5,a4
ffffffffc0200694:	00fb77b3          	and	a5,s6,a5
ffffffffc0200698:	00faeab3          	or	s5,s5,a5
ffffffffc020069c:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020069e:	000c9c63          	bnez	s9,ffffffffc02006b6 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006a2:	1a82                	slli	s5,s5,0x20
ffffffffc02006a4:	00368793          	addi	a5,a3,3
ffffffffc02006a8:	020ada93          	srli	s5,s5,0x20
ffffffffc02006ac:	9abe                	add	s5,s5,a5
ffffffffc02006ae:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02006b2:	8a56                	mv	s4,s5
ffffffffc02006b4:	b5f5                	j	ffffffffc02005a0 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006b6:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006ba:	85ca                	mv	a1,s2
ffffffffc02006bc:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006be:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c2:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c6:	0187971b          	slliw	a4,a5,0x18
ffffffffc02006ca:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02006d2:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d4:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d8:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006dc:	8d59                	or	a0,a0,a4
ffffffffc02006de:	00fb77b3          	and	a5,s6,a5
ffffffffc02006e2:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02006e4:	1502                	slli	a0,a0,0x20
ffffffffc02006e6:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006e8:	9522                	add	a0,a0,s0
ffffffffc02006ea:	786010ef          	jal	ra,ffffffffc0201e70 <strcmp>
ffffffffc02006ee:	66a2                	ld	a3,8(sp)
ffffffffc02006f0:	f94d                	bnez	a0,ffffffffc02006a2 <dtb_init+0x228>
ffffffffc02006f2:	fb59f8e3          	bgeu	s3,s5,ffffffffc02006a2 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02006f6:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02006fa:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02006fe:	00002517          	auipc	a0,0x2
ffffffffc0200702:	b5250513          	addi	a0,a0,-1198 # ffffffffc0202250 <commands+0x118>
           fdt32_to_cpu(x >> 32);
ffffffffc0200706:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020070a:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020070e:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200712:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200716:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020071a:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020071e:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200722:	0187d693          	srli	a3,a5,0x18
ffffffffc0200726:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020072a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020072e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200732:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200736:	010f6f33          	or	t5,t5,a6
ffffffffc020073a:	0187529b          	srliw	t0,a4,0x18
ffffffffc020073e:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020074a:	0186f6b3          	and	a3,a3,s8
ffffffffc020074e:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200752:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200756:	0107581b          	srliw	a6,a4,0x10
ffffffffc020075a:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020075e:	8361                	srli	a4,a4,0x18
ffffffffc0200760:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200764:	0105d59b          	srliw	a1,a1,0x10
ffffffffc0200768:	01e6e6b3          	or	a3,a3,t5
ffffffffc020076c:	00cb7633          	and	a2,s6,a2
ffffffffc0200770:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200774:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200778:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020077c:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200780:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200784:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200788:	0088989b          	slliw	a7,a7,0x8
ffffffffc020078c:	011b78b3          	and	a7,s6,a7
ffffffffc0200790:	005eeeb3          	or	t4,t4,t0
ffffffffc0200794:	00c6e733          	or	a4,a3,a2
ffffffffc0200798:	006c6c33          	or	s8,s8,t1
ffffffffc020079c:	010b76b3          	and	a3,s6,a6
ffffffffc02007a0:	00bb7b33          	and	s6,s6,a1
ffffffffc02007a4:	01d7e7b3          	or	a5,a5,t4
ffffffffc02007a8:	016c6b33          	or	s6,s8,s6
ffffffffc02007ac:	01146433          	or	s0,s0,a7
ffffffffc02007b0:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc02007b2:	1702                	slli	a4,a4,0x20
ffffffffc02007b4:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007b6:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007b8:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007ba:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007bc:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007c0:	0167eb33          	or	s6,a5,s6
ffffffffc02007c4:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007c6:	90fff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02007ca:	85a2                	mv	a1,s0
ffffffffc02007cc:	00002517          	auipc	a0,0x2
ffffffffc02007d0:	aa450513          	addi	a0,a0,-1372 # ffffffffc0202270 <commands+0x138>
ffffffffc02007d4:	901ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02007d8:	014b5613          	srli	a2,s6,0x14
ffffffffc02007dc:	85da                	mv	a1,s6
ffffffffc02007de:	00002517          	auipc	a0,0x2
ffffffffc02007e2:	aaa50513          	addi	a0,a0,-1366 # ffffffffc0202288 <commands+0x150>
ffffffffc02007e6:	8efff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02007ea:	008b05b3          	add	a1,s6,s0
ffffffffc02007ee:	15fd                	addi	a1,a1,-1
ffffffffc02007f0:	00002517          	auipc	a0,0x2
ffffffffc02007f4:	ab850513          	addi	a0,a0,-1352 # ffffffffc02022a8 <commands+0x170>
ffffffffc02007f8:	8ddff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02007fc:	00002517          	auipc	a0,0x2
ffffffffc0200800:	afc50513          	addi	a0,a0,-1284 # ffffffffc02022f8 <commands+0x1c0>
        memory_base = mem_base;
ffffffffc0200804:	00006797          	auipc	a5,0x6
ffffffffc0200808:	c487b623          	sd	s0,-948(a5) # ffffffffc0206450 <memory_base>
        memory_size = mem_size;
ffffffffc020080c:	00006797          	auipc	a5,0x6
ffffffffc0200810:	c567b623          	sd	s6,-948(a5) # ffffffffc0206458 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200814:	b3f5                	j	ffffffffc0200600 <dtb_init+0x186>

ffffffffc0200816 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200816:	00006517          	auipc	a0,0x6
ffffffffc020081a:	c3a53503          	ld	a0,-966(a0) # ffffffffc0206450 <memory_base>
ffffffffc020081e:	8082                	ret

ffffffffc0200820 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc0200820:	00006517          	auipc	a0,0x6
ffffffffc0200824:	c3853503          	ld	a0,-968(a0) # ffffffffc0206458 <memory_size>
ffffffffc0200828:	8082                	ret

ffffffffc020082a <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020082a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020082e:	8082                	ret

ffffffffc0200830 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200830:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200834:	8082                	ret

ffffffffc0200836 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200836:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc020083a:	00000797          	auipc	a5,0x0
ffffffffc020083e:	39a78793          	addi	a5,a5,922 # ffffffffc0200bd4 <__alltraps>
ffffffffc0200842:	10579073          	csrw	stvec,a5
}
ffffffffc0200846:	8082                	ret

ffffffffc0200848 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200848:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc020084a:	1141                	addi	sp,sp,-16
ffffffffc020084c:	e022                	sd	s0,0(sp)
ffffffffc020084e:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200850:	00002517          	auipc	a0,0x2
ffffffffc0200854:	ac050513          	addi	a0,a0,-1344 # ffffffffc0202310 <commands+0x1d8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200858:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020085a:	87bff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020085e:	640c                	ld	a1,8(s0)
ffffffffc0200860:	00002517          	auipc	a0,0x2
ffffffffc0200864:	ac850513          	addi	a0,a0,-1336 # ffffffffc0202328 <commands+0x1f0>
ffffffffc0200868:	86dff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020086c:	680c                	ld	a1,16(s0)
ffffffffc020086e:	00002517          	auipc	a0,0x2
ffffffffc0200872:	ad250513          	addi	a0,a0,-1326 # ffffffffc0202340 <commands+0x208>
ffffffffc0200876:	85fff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc020087a:	6c0c                	ld	a1,24(s0)
ffffffffc020087c:	00002517          	auipc	a0,0x2
ffffffffc0200880:	adc50513          	addi	a0,a0,-1316 # ffffffffc0202358 <commands+0x220>
ffffffffc0200884:	851ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200888:	700c                	ld	a1,32(s0)
ffffffffc020088a:	00002517          	auipc	a0,0x2
ffffffffc020088e:	ae650513          	addi	a0,a0,-1306 # ffffffffc0202370 <commands+0x238>
ffffffffc0200892:	843ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200896:	740c                	ld	a1,40(s0)
ffffffffc0200898:	00002517          	auipc	a0,0x2
ffffffffc020089c:	af050513          	addi	a0,a0,-1296 # ffffffffc0202388 <commands+0x250>
ffffffffc02008a0:	835ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02008a4:	780c                	ld	a1,48(s0)
ffffffffc02008a6:	00002517          	auipc	a0,0x2
ffffffffc02008aa:	afa50513          	addi	a0,a0,-1286 # ffffffffc02023a0 <commands+0x268>
ffffffffc02008ae:	827ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02008b2:	7c0c                	ld	a1,56(s0)
ffffffffc02008b4:	00002517          	auipc	a0,0x2
ffffffffc02008b8:	b0450513          	addi	a0,a0,-1276 # ffffffffc02023b8 <commands+0x280>
ffffffffc02008bc:	819ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02008c0:	602c                	ld	a1,64(s0)
ffffffffc02008c2:	00002517          	auipc	a0,0x2
ffffffffc02008c6:	b0e50513          	addi	a0,a0,-1266 # ffffffffc02023d0 <commands+0x298>
ffffffffc02008ca:	80bff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02008ce:	642c                	ld	a1,72(s0)
ffffffffc02008d0:	00002517          	auipc	a0,0x2
ffffffffc02008d4:	b1850513          	addi	a0,a0,-1256 # ffffffffc02023e8 <commands+0x2b0>
ffffffffc02008d8:	ffcff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02008dc:	682c                	ld	a1,80(s0)
ffffffffc02008de:	00002517          	auipc	a0,0x2
ffffffffc02008e2:	b2250513          	addi	a0,a0,-1246 # ffffffffc0202400 <commands+0x2c8>
ffffffffc02008e6:	feeff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02008ea:	6c2c                	ld	a1,88(s0)
ffffffffc02008ec:	00002517          	auipc	a0,0x2
ffffffffc02008f0:	b2c50513          	addi	a0,a0,-1236 # ffffffffc0202418 <commands+0x2e0>
ffffffffc02008f4:	fe0ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc02008f8:	702c                	ld	a1,96(s0)
ffffffffc02008fa:	00002517          	auipc	a0,0x2
ffffffffc02008fe:	b3650513          	addi	a0,a0,-1226 # ffffffffc0202430 <commands+0x2f8>
ffffffffc0200902:	fd2ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200906:	742c                	ld	a1,104(s0)
ffffffffc0200908:	00002517          	auipc	a0,0x2
ffffffffc020090c:	b4050513          	addi	a0,a0,-1216 # ffffffffc0202448 <commands+0x310>
ffffffffc0200910:	fc4ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200914:	782c                	ld	a1,112(s0)
ffffffffc0200916:	00002517          	auipc	a0,0x2
ffffffffc020091a:	b4a50513          	addi	a0,a0,-1206 # ffffffffc0202460 <commands+0x328>
ffffffffc020091e:	fb6ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200922:	7c2c                	ld	a1,120(s0)
ffffffffc0200924:	00002517          	auipc	a0,0x2
ffffffffc0200928:	b5450513          	addi	a0,a0,-1196 # ffffffffc0202478 <commands+0x340>
ffffffffc020092c:	fa8ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200930:	604c                	ld	a1,128(s0)
ffffffffc0200932:	00002517          	auipc	a0,0x2
ffffffffc0200936:	b5e50513          	addi	a0,a0,-1186 # ffffffffc0202490 <commands+0x358>
ffffffffc020093a:	f9aff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020093e:	644c                	ld	a1,136(s0)
ffffffffc0200940:	00002517          	auipc	a0,0x2
ffffffffc0200944:	b6850513          	addi	a0,a0,-1176 # ffffffffc02024a8 <commands+0x370>
ffffffffc0200948:	f8cff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc020094c:	684c                	ld	a1,144(s0)
ffffffffc020094e:	00002517          	auipc	a0,0x2
ffffffffc0200952:	b7250513          	addi	a0,a0,-1166 # ffffffffc02024c0 <commands+0x388>
ffffffffc0200956:	f7eff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc020095a:	6c4c                	ld	a1,152(s0)
ffffffffc020095c:	00002517          	auipc	a0,0x2
ffffffffc0200960:	b7c50513          	addi	a0,a0,-1156 # ffffffffc02024d8 <commands+0x3a0>
ffffffffc0200964:	f70ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200968:	704c                	ld	a1,160(s0)
ffffffffc020096a:	00002517          	auipc	a0,0x2
ffffffffc020096e:	b8650513          	addi	a0,a0,-1146 # ffffffffc02024f0 <commands+0x3b8>
ffffffffc0200972:	f62ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200976:	744c                	ld	a1,168(s0)
ffffffffc0200978:	00002517          	auipc	a0,0x2
ffffffffc020097c:	b9050513          	addi	a0,a0,-1136 # ffffffffc0202508 <commands+0x3d0>
ffffffffc0200980:	f54ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200984:	784c                	ld	a1,176(s0)
ffffffffc0200986:	00002517          	auipc	a0,0x2
ffffffffc020098a:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0202520 <commands+0x3e8>
ffffffffc020098e:	f46ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200992:	7c4c                	ld	a1,184(s0)
ffffffffc0200994:	00002517          	auipc	a0,0x2
ffffffffc0200998:	ba450513          	addi	a0,a0,-1116 # ffffffffc0202538 <commands+0x400>
ffffffffc020099c:	f38ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02009a0:	606c                	ld	a1,192(s0)
ffffffffc02009a2:	00002517          	auipc	a0,0x2
ffffffffc02009a6:	bae50513          	addi	a0,a0,-1106 # ffffffffc0202550 <commands+0x418>
ffffffffc02009aa:	f2aff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02009ae:	646c                	ld	a1,200(s0)
ffffffffc02009b0:	00002517          	auipc	a0,0x2
ffffffffc02009b4:	bb850513          	addi	a0,a0,-1096 # ffffffffc0202568 <commands+0x430>
ffffffffc02009b8:	f1cff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02009bc:	686c                	ld	a1,208(s0)
ffffffffc02009be:	00002517          	auipc	a0,0x2
ffffffffc02009c2:	bc250513          	addi	a0,a0,-1086 # ffffffffc0202580 <commands+0x448>
ffffffffc02009c6:	f0eff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02009ca:	6c6c                	ld	a1,216(s0)
ffffffffc02009cc:	00002517          	auipc	a0,0x2
ffffffffc02009d0:	bcc50513          	addi	a0,a0,-1076 # ffffffffc0202598 <commands+0x460>
ffffffffc02009d4:	f00ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02009d8:	706c                	ld	a1,224(s0)
ffffffffc02009da:	00002517          	auipc	a0,0x2
ffffffffc02009de:	bd650513          	addi	a0,a0,-1066 # ffffffffc02025b0 <commands+0x478>
ffffffffc02009e2:	ef2ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02009e6:	746c                	ld	a1,232(s0)
ffffffffc02009e8:	00002517          	auipc	a0,0x2
ffffffffc02009ec:	be050513          	addi	a0,a0,-1056 # ffffffffc02025c8 <commands+0x490>
ffffffffc02009f0:	ee4ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc02009f4:	786c                	ld	a1,240(s0)
ffffffffc02009f6:	00002517          	auipc	a0,0x2
ffffffffc02009fa:	bea50513          	addi	a0,a0,-1046 # ffffffffc02025e0 <commands+0x4a8>
ffffffffc02009fe:	ed6ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a02:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200a04:	6402                	ld	s0,0(sp)
ffffffffc0200a06:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a08:	00002517          	auipc	a0,0x2
ffffffffc0200a0c:	bf050513          	addi	a0,a0,-1040 # ffffffffc02025f8 <commands+0x4c0>
}
ffffffffc0200a10:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a12:	ec2ff06f          	j	ffffffffc02000d4 <cprintf>

ffffffffc0200a16 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a16:	1141                	addi	sp,sp,-16
ffffffffc0200a18:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a1a:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a1c:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a1e:	00002517          	auipc	a0,0x2
ffffffffc0200a22:	bf250513          	addi	a0,a0,-1038 # ffffffffc0202610 <commands+0x4d8>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a26:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a28:	eacff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200a2c:	8522                	mv	a0,s0
ffffffffc0200a2e:	e1bff0ef          	jal	ra,ffffffffc0200848 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200a32:	10043583          	ld	a1,256(s0)
ffffffffc0200a36:	00002517          	auipc	a0,0x2
ffffffffc0200a3a:	bf250513          	addi	a0,a0,-1038 # ffffffffc0202628 <commands+0x4f0>
ffffffffc0200a3e:	e96ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200a42:	10843583          	ld	a1,264(s0)
ffffffffc0200a46:	00002517          	auipc	a0,0x2
ffffffffc0200a4a:	bfa50513          	addi	a0,a0,-1030 # ffffffffc0202640 <commands+0x508>
ffffffffc0200a4e:	e86ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200a52:	11043583          	ld	a1,272(s0)
ffffffffc0200a56:	00002517          	auipc	a0,0x2
ffffffffc0200a5a:	c0250513          	addi	a0,a0,-1022 # ffffffffc0202658 <commands+0x520>
ffffffffc0200a5e:	e76ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a62:	11843583          	ld	a1,280(s0)
}
ffffffffc0200a66:	6402                	ld	s0,0(sp)
ffffffffc0200a68:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a6a:	00002517          	auipc	a0,0x2
ffffffffc0200a6e:	c0650513          	addi	a0,a0,-1018 # ffffffffc0202670 <commands+0x538>
}
ffffffffc0200a72:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a74:	e60ff06f          	j	ffffffffc02000d4 <cprintf>

ffffffffc0200a78 <interrupt_handler>:


volatile size_t num=0;

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200a78:	11853783          	ld	a5,280(a0)
ffffffffc0200a7c:	472d                	li	a4,11
ffffffffc0200a7e:	0786                	slli	a5,a5,0x1
ffffffffc0200a80:	8385                	srli	a5,a5,0x1
ffffffffc0200a82:	08f76263          	bltu	a4,a5,ffffffffc0200b06 <interrupt_handler+0x8e>
ffffffffc0200a86:	00002717          	auipc	a4,0x2
ffffffffc0200a8a:	cca70713          	addi	a4,a4,-822 # ffffffffc0202750 <commands+0x618>
ffffffffc0200a8e:	078a                	slli	a5,a5,0x2
ffffffffc0200a90:	97ba                	add	a5,a5,a4
ffffffffc0200a92:	439c                	lw	a5,0(a5)
ffffffffc0200a94:	97ba                	add	a5,a5,a4
ffffffffc0200a96:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200a98:	00002517          	auipc	a0,0x2
ffffffffc0200a9c:	c5050513          	addi	a0,a0,-944 # ffffffffc02026e8 <commands+0x5b0>
ffffffffc0200aa0:	e34ff06f          	j	ffffffffc02000d4 <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200aa4:	00002517          	auipc	a0,0x2
ffffffffc0200aa8:	c2450513          	addi	a0,a0,-988 # ffffffffc02026c8 <commands+0x590>
ffffffffc0200aac:	e28ff06f          	j	ffffffffc02000d4 <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200ab0:	00002517          	auipc	a0,0x2
ffffffffc0200ab4:	bd850513          	addi	a0,a0,-1064 # ffffffffc0202688 <commands+0x550>
ffffffffc0200ab8:	e1cff06f          	j	ffffffffc02000d4 <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200abc:	00002517          	auipc	a0,0x2
ffffffffc0200ac0:	c4c50513          	addi	a0,a0,-948 # ffffffffc0202708 <commands+0x5d0>
ffffffffc0200ac4:	e10ff06f          	j	ffffffffc02000d4 <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200ac8:	1141                	addi	sp,sp,-16
ffffffffc0200aca:	e406                	sd	ra,8(sp)
            /*(1)设置下次时钟中断- clock_set_next_event()
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
            clock_set_next_event();
ffffffffc0200acc:	991ff0ef          	jal	ra,ffffffffc020045c <clock_set_next_event>
            ticks++;
ffffffffc0200ad0:	00006797          	auipc	a5,0x6
ffffffffc0200ad4:	97878793          	addi	a5,a5,-1672 # ffffffffc0206448 <ticks>
ffffffffc0200ad8:	6398                	ld	a4,0(a5)
            if(ticks==TICK_NUM){
ffffffffc0200ada:	06400693          	li	a3,100
            ticks++;
ffffffffc0200ade:	0705                	addi	a4,a4,1
ffffffffc0200ae0:	e398                	sd	a4,0(a5)
            if(ticks==TICK_NUM){
ffffffffc0200ae2:	639c                	ld	a5,0(a5)
ffffffffc0200ae4:	02d78263          	beq	a5,a3,ffffffffc0200b08 <interrupt_handler+0x90>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200ae8:	60a2                	ld	ra,8(sp)
ffffffffc0200aea:	0141                	addi	sp,sp,16
ffffffffc0200aec:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200aee:	00002517          	auipc	a0,0x2
ffffffffc0200af2:	c4250513          	addi	a0,a0,-958 # ffffffffc0202730 <commands+0x5f8>
ffffffffc0200af6:	ddeff06f          	j	ffffffffc02000d4 <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200afa:	00002517          	auipc	a0,0x2
ffffffffc0200afe:	bae50513          	addi	a0,a0,-1106 # ffffffffc02026a8 <commands+0x570>
ffffffffc0200b02:	dd2ff06f          	j	ffffffffc02000d4 <cprintf>
            print_trapframe(tf);
ffffffffc0200b06:	bf01                	j	ffffffffc0200a16 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200b08:	06400593          	li	a1,100
ffffffffc0200b0c:	00002517          	auipc	a0,0x2
ffffffffc0200b10:	c1450513          	addi	a0,a0,-1004 # ffffffffc0202720 <commands+0x5e8>
ffffffffc0200b14:	dc0ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
                ticks=0;
ffffffffc0200b18:	00006797          	auipc	a5,0x6
ffffffffc0200b1c:	9207b823          	sd	zero,-1744(a5) # ffffffffc0206448 <ticks>
                num++;
ffffffffc0200b20:	00006797          	auipc	a5,0x6
ffffffffc0200b24:	94078793          	addi	a5,a5,-1728 # ffffffffc0206460 <num>
ffffffffc0200b28:	6398                	ld	a4,0(a5)
                if(num==10){
ffffffffc0200b2a:	46a9                	li	a3,10
                num++;
ffffffffc0200b2c:	0705                	addi	a4,a4,1
ffffffffc0200b2e:	e398                	sd	a4,0(a5)
                if(num==10){
ffffffffc0200b30:	639c                	ld	a5,0(a5)
ffffffffc0200b32:	fad79be3          	bne	a5,a3,ffffffffc0200ae8 <interrupt_handler+0x70>
}
ffffffffc0200b36:	60a2                	ld	ra,8(sp)
ffffffffc0200b38:	0141                	addi	sp,sp,16
                    sbi_shutdown();
ffffffffc0200b3a:	2e60106f          	j	ffffffffc0201e20 <sbi_shutdown>

ffffffffc0200b3e <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200b3e:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200b42:	1141                	addi	sp,sp,-16
ffffffffc0200b44:	e022                	sd	s0,0(sp)
ffffffffc0200b46:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
ffffffffc0200b48:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200b4a:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc0200b4c:	04e78663          	beq	a5,a4,ffffffffc0200b98 <exception_handler+0x5a>
ffffffffc0200b50:	02f76c63          	bltu	a4,a5,ffffffffc0200b88 <exception_handler+0x4a>
ffffffffc0200b54:	4709                	li	a4,2
ffffffffc0200b56:	02e79563          	bne	a5,a4,ffffffffc0200b80 <exception_handler+0x42>
             /* LAB3 CHALLENGE3   YOUR CODE :  */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("Exception type: Illegal instruction\n");
ffffffffc0200b5a:	00002517          	auipc	a0,0x2
ffffffffc0200b5e:	c2650513          	addi	a0,a0,-986 # ffffffffc0202780 <commands+0x648>
ffffffffc0200b62:	d72ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
            cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
ffffffffc0200b66:	10843583          	ld	a1,264(s0)
ffffffffc0200b6a:	00002517          	auipc	a0,0x2
ffffffffc0200b6e:	c3e50513          	addi	a0,a0,-962 # ffffffffc02027a8 <commands+0x670>
ffffffffc0200b72:	d62ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
            tf->epc += 4;   // 跳过非法指令，防止陷入死循环
ffffffffc0200b76:	10843783          	ld	a5,264(s0)
ffffffffc0200b7a:	0791                	addi	a5,a5,4
ffffffffc0200b7c:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b80:	60a2                	ld	ra,8(sp)
ffffffffc0200b82:	6402                	ld	s0,0(sp)
ffffffffc0200b84:	0141                	addi	sp,sp,16
ffffffffc0200b86:	8082                	ret
    switch (tf->cause) {
ffffffffc0200b88:	17f1                	addi	a5,a5,-4
ffffffffc0200b8a:	471d                	li	a4,7
ffffffffc0200b8c:	fef77ae3          	bgeu	a4,a5,ffffffffc0200b80 <exception_handler+0x42>
}
ffffffffc0200b90:	6402                	ld	s0,0(sp)
ffffffffc0200b92:	60a2                	ld	ra,8(sp)
ffffffffc0200b94:	0141                	addi	sp,sp,16
            print_trapframe(tf);
ffffffffc0200b96:	b541                	j	ffffffffc0200a16 <print_trapframe>
            cprintf("Exception type: breakpoint\n");
ffffffffc0200b98:	00002517          	auipc	a0,0x2
ffffffffc0200b9c:	c3850513          	addi	a0,a0,-968 # ffffffffc02027d0 <commands+0x698>
ffffffffc0200ba0:	d34ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
            cprintf("ebreak caught at 0x%08x\n", tf->epc);
ffffffffc0200ba4:	10843583          	ld	a1,264(s0)
ffffffffc0200ba8:	00002517          	auipc	a0,0x2
ffffffffc0200bac:	c4850513          	addi	a0,a0,-952 # ffffffffc02027f0 <commands+0x6b8>
ffffffffc0200bb0:	d24ff0ef          	jal	ra,ffffffffc02000d4 <cprintf>
            tf->epc += 2;//ebreak是2字节指令
ffffffffc0200bb4:	10843783          	ld	a5,264(s0)
}
ffffffffc0200bb8:	60a2                	ld	ra,8(sp)
            tf->epc += 2;//ebreak是2字节指令
ffffffffc0200bba:	0789                	addi	a5,a5,2
ffffffffc0200bbc:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200bc0:	6402                	ld	s0,0(sp)
ffffffffc0200bc2:	0141                	addi	sp,sp,16
ffffffffc0200bc4:	8082                	ret

ffffffffc0200bc6 <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200bc6:	11853783          	ld	a5,280(a0)
ffffffffc0200bca:	0007c363          	bltz	a5,ffffffffc0200bd0 <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200bce:	bf85                	j	ffffffffc0200b3e <exception_handler>
        interrupt_handler(tf);
ffffffffc0200bd0:	b565                	j	ffffffffc0200a78 <interrupt_handler>
	...

ffffffffc0200bd4 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200bd4:	14011073          	csrw	sscratch,sp
ffffffffc0200bd8:	712d                	addi	sp,sp,-288
ffffffffc0200bda:	e002                	sd	zero,0(sp)
ffffffffc0200bdc:	e406                	sd	ra,8(sp)
ffffffffc0200bde:	ec0e                	sd	gp,24(sp)
ffffffffc0200be0:	f012                	sd	tp,32(sp)
ffffffffc0200be2:	f416                	sd	t0,40(sp)
ffffffffc0200be4:	f81a                	sd	t1,48(sp)
ffffffffc0200be6:	fc1e                	sd	t2,56(sp)
ffffffffc0200be8:	e0a2                	sd	s0,64(sp)
ffffffffc0200bea:	e4a6                	sd	s1,72(sp)
ffffffffc0200bec:	e8aa                	sd	a0,80(sp)
ffffffffc0200bee:	ecae                	sd	a1,88(sp)
ffffffffc0200bf0:	f0b2                	sd	a2,96(sp)
ffffffffc0200bf2:	f4b6                	sd	a3,104(sp)
ffffffffc0200bf4:	f8ba                	sd	a4,112(sp)
ffffffffc0200bf6:	fcbe                	sd	a5,120(sp)
ffffffffc0200bf8:	e142                	sd	a6,128(sp)
ffffffffc0200bfa:	e546                	sd	a7,136(sp)
ffffffffc0200bfc:	e94a                	sd	s2,144(sp)
ffffffffc0200bfe:	ed4e                	sd	s3,152(sp)
ffffffffc0200c00:	f152                	sd	s4,160(sp)
ffffffffc0200c02:	f556                	sd	s5,168(sp)
ffffffffc0200c04:	f95a                	sd	s6,176(sp)
ffffffffc0200c06:	fd5e                	sd	s7,184(sp)
ffffffffc0200c08:	e1e2                	sd	s8,192(sp)
ffffffffc0200c0a:	e5e6                	sd	s9,200(sp)
ffffffffc0200c0c:	e9ea                	sd	s10,208(sp)
ffffffffc0200c0e:	edee                	sd	s11,216(sp)
ffffffffc0200c10:	f1f2                	sd	t3,224(sp)
ffffffffc0200c12:	f5f6                	sd	t4,232(sp)
ffffffffc0200c14:	f9fa                	sd	t5,240(sp)
ffffffffc0200c16:	fdfe                	sd	t6,248(sp)
ffffffffc0200c18:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c1c:	100024f3          	csrr	s1,sstatus
ffffffffc0200c20:	14102973          	csrr	s2,sepc
ffffffffc0200c24:	143029f3          	csrr	s3,stval
ffffffffc0200c28:	14202a73          	csrr	s4,scause
ffffffffc0200c2c:	e822                	sd	s0,16(sp)
ffffffffc0200c2e:	e226                	sd	s1,256(sp)
ffffffffc0200c30:	e64a                	sd	s2,264(sp)
ffffffffc0200c32:	ea4e                	sd	s3,272(sp)
ffffffffc0200c34:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200c36:	850a                	mv	a0,sp
    jal trap
ffffffffc0200c38:	f8fff0ef          	jal	ra,ffffffffc0200bc6 <trap>

ffffffffc0200c3c <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200c3c:	6492                	ld	s1,256(sp)
ffffffffc0200c3e:	6932                	ld	s2,264(sp)
ffffffffc0200c40:	10049073          	csrw	sstatus,s1
ffffffffc0200c44:	14191073          	csrw	sepc,s2
ffffffffc0200c48:	60a2                	ld	ra,8(sp)
ffffffffc0200c4a:	61e2                	ld	gp,24(sp)
ffffffffc0200c4c:	7202                	ld	tp,32(sp)
ffffffffc0200c4e:	72a2                	ld	t0,40(sp)
ffffffffc0200c50:	7342                	ld	t1,48(sp)
ffffffffc0200c52:	73e2                	ld	t2,56(sp)
ffffffffc0200c54:	6406                	ld	s0,64(sp)
ffffffffc0200c56:	64a6                	ld	s1,72(sp)
ffffffffc0200c58:	6546                	ld	a0,80(sp)
ffffffffc0200c5a:	65e6                	ld	a1,88(sp)
ffffffffc0200c5c:	7606                	ld	a2,96(sp)
ffffffffc0200c5e:	76a6                	ld	a3,104(sp)
ffffffffc0200c60:	7746                	ld	a4,112(sp)
ffffffffc0200c62:	77e6                	ld	a5,120(sp)
ffffffffc0200c64:	680a                	ld	a6,128(sp)
ffffffffc0200c66:	68aa                	ld	a7,136(sp)
ffffffffc0200c68:	694a                	ld	s2,144(sp)
ffffffffc0200c6a:	69ea                	ld	s3,152(sp)
ffffffffc0200c6c:	7a0a                	ld	s4,160(sp)
ffffffffc0200c6e:	7aaa                	ld	s5,168(sp)
ffffffffc0200c70:	7b4a                	ld	s6,176(sp)
ffffffffc0200c72:	7bea                	ld	s7,184(sp)
ffffffffc0200c74:	6c0e                	ld	s8,192(sp)
ffffffffc0200c76:	6cae                	ld	s9,200(sp)
ffffffffc0200c78:	6d4e                	ld	s10,208(sp)
ffffffffc0200c7a:	6dee                	ld	s11,216(sp)
ffffffffc0200c7c:	7e0e                	ld	t3,224(sp)
ffffffffc0200c7e:	7eae                	ld	t4,232(sp)
ffffffffc0200c80:	7f4e                	ld	t5,240(sp)
ffffffffc0200c82:	7fee                	ld	t6,248(sp)
ffffffffc0200c84:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200c86:	10200073          	sret

ffffffffc0200c8a <best_fit_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200c8a:	00005797          	auipc	a5,0x5
ffffffffc0200c8e:	39e78793          	addi	a5,a5,926 # ffffffffc0206028 <free_area>
ffffffffc0200c92:	e79c                	sd	a5,8(a5)
ffffffffc0200c94:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
best_fit_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200c96:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200c9a:	8082                	ret

ffffffffc0200c9c <best_fit_nr_free_pages>:
}

static size_t
best_fit_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200c9c:	00005517          	auipc	a0,0x5
ffffffffc0200ca0:	39c56503          	lwu	a0,924(a0) # ffffffffc0206038 <free_area+0x10>
ffffffffc0200ca4:	8082                	ret

ffffffffc0200ca6 <best_fit_alloc_pages>:
    assert(n > 0);
ffffffffc0200ca6:	c14d                	beqz	a0,ffffffffc0200d48 <best_fit_alloc_pages+0xa2>
    if (n > nr_free) {
ffffffffc0200ca8:	00005617          	auipc	a2,0x5
ffffffffc0200cac:	38060613          	addi	a2,a2,896 # ffffffffc0206028 <free_area>
ffffffffc0200cb0:	01062803          	lw	a6,16(a2)
ffffffffc0200cb4:	86aa                	mv	a3,a0
ffffffffc0200cb6:	02081793          	slli	a5,a6,0x20
ffffffffc0200cba:	9381                	srli	a5,a5,0x20
ffffffffc0200cbc:	08a7e463          	bltu	a5,a0,ffffffffc0200d44 <best_fit_alloc_pages+0x9e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200cc0:	661c                	ld	a5,8(a2)
    size_t min_size = nr_free + 1;
ffffffffc0200cc2:	0018059b          	addiw	a1,a6,1
ffffffffc0200cc6:	1582                	slli	a1,a1,0x20
ffffffffc0200cc8:	9181                	srli	a1,a1,0x20
    struct Page *page = NULL;
ffffffffc0200cca:	4501                	li	a0,0
    while ((le = list_next(le)) != &free_list)
ffffffffc0200ccc:	06c78b63          	beq	a5,a2,ffffffffc0200d42 <best_fit_alloc_pages+0x9c>
        if (p->property >= n && p->property < min_size)
ffffffffc0200cd0:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0200cd4:	00d76763          	bltu	a4,a3,ffffffffc0200ce2 <best_fit_alloc_pages+0x3c>
ffffffffc0200cd8:	00b77563          	bgeu	a4,a1,ffffffffc0200ce2 <best_fit_alloc_pages+0x3c>
        struct Page *p = le2page(le, page_link);
ffffffffc0200cdc:	fe878513          	addi	a0,a5,-24
ffffffffc0200ce0:	85ba                	mv	a1,a4
ffffffffc0200ce2:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0200ce4:	fec796e3          	bne	a5,a2,ffffffffc0200cd0 <best_fit_alloc_pages+0x2a>
    if (page != NULL) {
ffffffffc0200ce8:	cd29                	beqz	a0,ffffffffc0200d42 <best_fit_alloc_pages+0x9c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0200cea:	711c                	ld	a5,32(a0)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
ffffffffc0200cec:	6d18                	ld	a4,24(a0)
        if (page->property > n) {
ffffffffc0200cee:	490c                	lw	a1,16(a0)
            p->property = page->property - n;
ffffffffc0200cf0:	0006889b          	sext.w	a7,a3
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0200cf4:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0200cf6:	e398                	sd	a4,0(a5)
        if (page->property > n) {
ffffffffc0200cf8:	02059793          	slli	a5,a1,0x20
ffffffffc0200cfc:	9381                	srli	a5,a5,0x20
ffffffffc0200cfe:	02f6f863          	bgeu	a3,a5,ffffffffc0200d2e <best_fit_alloc_pages+0x88>
            struct Page *p = page + n;
ffffffffc0200d02:	00269793          	slli	a5,a3,0x2
ffffffffc0200d06:	97b6                	add	a5,a5,a3
ffffffffc0200d08:	078e                	slli	a5,a5,0x3
ffffffffc0200d0a:	97aa                	add	a5,a5,a0
            p->property = page->property - n;
ffffffffc0200d0c:	411585bb          	subw	a1,a1,a7
ffffffffc0200d10:	cb8c                	sw	a1,16(a5)
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200d12:	4689                	li	a3,2
ffffffffc0200d14:	00878593          	addi	a1,a5,8
ffffffffc0200d18:	40d5b02f          	amoor.d	zero,a3,(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0200d1c:	6714                	ld	a3,8(a4)
            list_add(prev, &(p->page_link));
ffffffffc0200d1e:	01878593          	addi	a1,a5,24
        nr_free -= n;
ffffffffc0200d22:	01062803          	lw	a6,16(a2)
    prev->next = next->prev = elm;
ffffffffc0200d26:	e28c                	sd	a1,0(a3)
ffffffffc0200d28:	e70c                	sd	a1,8(a4)
    elm->next = next;
ffffffffc0200d2a:	f394                	sd	a3,32(a5)
    elm->prev = prev;
ffffffffc0200d2c:	ef98                	sd	a4,24(a5)
ffffffffc0200d2e:	4118083b          	subw	a6,a6,a7
ffffffffc0200d32:	01062823          	sw	a6,16(a2)
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void clear_bit(int nr, volatile void *addr) {
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0200d36:	57f5                	li	a5,-3
ffffffffc0200d38:	00850713          	addi	a4,a0,8
ffffffffc0200d3c:	60f7302f          	amoand.d	zero,a5,(a4)
}
ffffffffc0200d40:	8082                	ret
}
ffffffffc0200d42:	8082                	ret
        return NULL;
ffffffffc0200d44:	4501                	li	a0,0
ffffffffc0200d46:	8082                	ret
best_fit_alloc_pages(size_t n) {
ffffffffc0200d48:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0200d4a:	00002697          	auipc	a3,0x2
ffffffffc0200d4e:	ac668693          	addi	a3,a3,-1338 # ffffffffc0202810 <commands+0x6d8>
ffffffffc0200d52:	00002617          	auipc	a2,0x2
ffffffffc0200d56:	ac660613          	addi	a2,a2,-1338 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0200d5a:	06800593          	li	a1,104
ffffffffc0200d5e:	00002517          	auipc	a0,0x2
ffffffffc0200d62:	ad250513          	addi	a0,a0,-1326 # ffffffffc0202830 <commands+0x6f8>
best_fit_alloc_pages(size_t n) {
ffffffffc0200d66:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0200d68:	e66ff0ef          	jal	ra,ffffffffc02003ce <__panic>

ffffffffc0200d6c <best_fit_check>:
}

// LAB2: below code is used to check the best fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
best_fit_check(void) {
ffffffffc0200d6c:	715d                	addi	sp,sp,-80
ffffffffc0200d6e:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc0200d70:	00005417          	auipc	s0,0x5
ffffffffc0200d74:	2b840413          	addi	s0,s0,696 # ffffffffc0206028 <free_area>
ffffffffc0200d78:	641c                	ld	a5,8(s0)
ffffffffc0200d7a:	e486                	sd	ra,72(sp)
ffffffffc0200d7c:	fc26                	sd	s1,56(sp)
ffffffffc0200d7e:	f84a                	sd	s2,48(sp)
ffffffffc0200d80:	f44e                	sd	s3,40(sp)
ffffffffc0200d82:	f052                	sd	s4,32(sp)
ffffffffc0200d84:	ec56                	sd	s5,24(sp)
ffffffffc0200d86:	e85a                	sd	s6,16(sp)
ffffffffc0200d88:	e45e                	sd	s7,8(sp)
ffffffffc0200d8a:	e062                	sd	s8,0(sp)
    int score = 0 ,sumscore = 6;
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200d8c:	26878b63          	beq	a5,s0,ffffffffc0201002 <best_fit_check+0x296>
    int count = 0, total = 0;
ffffffffc0200d90:	4481                	li	s1,0
ffffffffc0200d92:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200d94:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200d98:	8b09                	andi	a4,a4,2
ffffffffc0200d9a:	26070863          	beqz	a4,ffffffffc020100a <best_fit_check+0x29e>
        count ++, total += p->property;
ffffffffc0200d9e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200da2:	679c                	ld	a5,8(a5)
ffffffffc0200da4:	2905                	addiw	s2,s2,1
ffffffffc0200da6:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200da8:	fe8796e3          	bne	a5,s0,ffffffffc0200d94 <best_fit_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200dac:	89a6                	mv	s3,s1
ffffffffc0200dae:	167000ef          	jal	ra,ffffffffc0201714 <nr_free_pages>
ffffffffc0200db2:	33351c63          	bne	a0,s3,ffffffffc02010ea <best_fit_check+0x37e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200db6:	4505                	li	a0,1
ffffffffc0200db8:	0df000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200dbc:	8a2a                	mv	s4,a0
ffffffffc0200dbe:	36050663          	beqz	a0,ffffffffc020112a <best_fit_check+0x3be>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200dc2:	4505                	li	a0,1
ffffffffc0200dc4:	0d3000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200dc8:	89aa                	mv	s3,a0
ffffffffc0200dca:	34050063          	beqz	a0,ffffffffc020110a <best_fit_check+0x39e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200dce:	4505                	li	a0,1
ffffffffc0200dd0:	0c7000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200dd4:	8aaa                	mv	s5,a0
ffffffffc0200dd6:	2c050a63          	beqz	a0,ffffffffc02010aa <best_fit_check+0x33e>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200dda:	253a0863          	beq	s4,s3,ffffffffc020102a <best_fit_check+0x2be>
ffffffffc0200dde:	24aa0663          	beq	s4,a0,ffffffffc020102a <best_fit_check+0x2be>
ffffffffc0200de2:	24a98463          	beq	s3,a0,ffffffffc020102a <best_fit_check+0x2be>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200de6:	000a2783          	lw	a5,0(s4)
ffffffffc0200dea:	26079063          	bnez	a5,ffffffffc020104a <best_fit_check+0x2de>
ffffffffc0200dee:	0009a783          	lw	a5,0(s3)
ffffffffc0200df2:	24079c63          	bnez	a5,ffffffffc020104a <best_fit_check+0x2de>
ffffffffc0200df6:	411c                	lw	a5,0(a0)
ffffffffc0200df8:	24079963          	bnez	a5,ffffffffc020104a <best_fit_check+0x2de>
extern struct Page *pages;
extern size_t npage;
extern const size_t nbase;
extern uint64_t va_pa_offset;

static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200dfc:	00005797          	auipc	a5,0x5
ffffffffc0200e00:	6747b783          	ld	a5,1652(a5) # ffffffffc0206470 <pages>
ffffffffc0200e04:	40fa0733          	sub	a4,s4,a5
ffffffffc0200e08:	870d                	srai	a4,a4,0x3
ffffffffc0200e0a:	00002597          	auipc	a1,0x2
ffffffffc0200e0e:	1165b583          	ld	a1,278(a1) # ffffffffc0202f20 <error_string+0x38>
ffffffffc0200e12:	02b70733          	mul	a4,a4,a1
ffffffffc0200e16:	00002617          	auipc	a2,0x2
ffffffffc0200e1a:	11263603          	ld	a2,274(a2) # ffffffffc0202f28 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200e1e:	00005697          	auipc	a3,0x5
ffffffffc0200e22:	64a6b683          	ld	a3,1610(a3) # ffffffffc0206468 <npage>
ffffffffc0200e26:	06b2                	slli	a3,a3,0xc
ffffffffc0200e28:	9732                	add	a4,a4,a2

static inline uintptr_t page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e2a:	0732                	slli	a4,a4,0xc
ffffffffc0200e2c:	22d77f63          	bgeu	a4,a3,ffffffffc020106a <best_fit_check+0x2fe>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200e30:	40f98733          	sub	a4,s3,a5
ffffffffc0200e34:	870d                	srai	a4,a4,0x3
ffffffffc0200e36:	02b70733          	mul	a4,a4,a1
ffffffffc0200e3a:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e3c:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200e3e:	3ed77663          	bgeu	a4,a3,ffffffffc020122a <best_fit_check+0x4be>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200e42:	40f507b3          	sub	a5,a0,a5
ffffffffc0200e46:	878d                	srai	a5,a5,0x3
ffffffffc0200e48:	02b787b3          	mul	a5,a5,a1
ffffffffc0200e4c:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200e4e:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200e50:	3ad7fd63          	bgeu	a5,a3,ffffffffc020120a <best_fit_check+0x49e>
    assert(alloc_page() == NULL);
ffffffffc0200e54:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200e56:	00043c03          	ld	s8,0(s0)
ffffffffc0200e5a:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200e5e:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200e62:	e400                	sd	s0,8(s0)
ffffffffc0200e64:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200e66:	00005797          	auipc	a5,0x5
ffffffffc0200e6a:	1c07a923          	sw	zero,466(a5) # ffffffffc0206038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200e6e:	029000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200e72:	36051c63          	bnez	a0,ffffffffc02011ea <best_fit_check+0x47e>
    free_page(p0);
ffffffffc0200e76:	4585                	li	a1,1
ffffffffc0200e78:	8552                	mv	a0,s4
ffffffffc0200e7a:	05b000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    free_page(p1);
ffffffffc0200e7e:	4585                	li	a1,1
ffffffffc0200e80:	854e                	mv	a0,s3
ffffffffc0200e82:	053000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    free_page(p2);
ffffffffc0200e86:	4585                	li	a1,1
ffffffffc0200e88:	8556                	mv	a0,s5
ffffffffc0200e8a:	04b000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    assert(nr_free == 3);
ffffffffc0200e8e:	4818                	lw	a4,16(s0)
ffffffffc0200e90:	478d                	li	a5,3
ffffffffc0200e92:	32f71c63          	bne	a4,a5,ffffffffc02011ca <best_fit_check+0x45e>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e96:	4505                	li	a0,1
ffffffffc0200e98:	7fe000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200e9c:	89aa                	mv	s3,a0
ffffffffc0200e9e:	30050663          	beqz	a0,ffffffffc02011aa <best_fit_check+0x43e>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200ea2:	4505                	li	a0,1
ffffffffc0200ea4:	7f2000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200ea8:	8aaa                	mv	s5,a0
ffffffffc0200eaa:	2e050063          	beqz	a0,ffffffffc020118a <best_fit_check+0x41e>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200eae:	4505                	li	a0,1
ffffffffc0200eb0:	7e6000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200eb4:	8a2a                	mv	s4,a0
ffffffffc0200eb6:	2a050a63          	beqz	a0,ffffffffc020116a <best_fit_check+0x3fe>
    assert(alloc_page() == NULL);
ffffffffc0200eba:	4505                	li	a0,1
ffffffffc0200ebc:	7da000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200ec0:	28051563          	bnez	a0,ffffffffc020114a <best_fit_check+0x3de>
    free_page(p0);
ffffffffc0200ec4:	4585                	li	a1,1
ffffffffc0200ec6:	854e                	mv	a0,s3
ffffffffc0200ec8:	00d000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200ecc:	641c                	ld	a5,8(s0)
ffffffffc0200ece:	1a878e63          	beq	a5,s0,ffffffffc020108a <best_fit_check+0x31e>
    assert((p = alloc_page()) == p0);
ffffffffc0200ed2:	4505                	li	a0,1
ffffffffc0200ed4:	7c2000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200ed8:	52a99963          	bne	s3,a0,ffffffffc020140a <best_fit_check+0x69e>
    assert(alloc_page() == NULL);
ffffffffc0200edc:	4505                	li	a0,1
ffffffffc0200ede:	7b8000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200ee2:	50051463          	bnez	a0,ffffffffc02013ea <best_fit_check+0x67e>
    assert(nr_free == 0);
ffffffffc0200ee6:	481c                	lw	a5,16(s0)
ffffffffc0200ee8:	4e079163          	bnez	a5,ffffffffc02013ca <best_fit_check+0x65e>
    free_page(p);
ffffffffc0200eec:	854e                	mv	a0,s3
ffffffffc0200eee:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200ef0:	01843023          	sd	s8,0(s0)
ffffffffc0200ef4:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200ef8:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200efc:	7d8000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    free_page(p1);
ffffffffc0200f00:	4585                	li	a1,1
ffffffffc0200f02:	8556                	mv	a0,s5
ffffffffc0200f04:	7d0000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    free_page(p2);
ffffffffc0200f08:	4585                	li	a1,1
ffffffffc0200f0a:	8552                	mv	a0,s4
ffffffffc0200f0c:	7c8000ef          	jal	ra,ffffffffc02016d4 <free_pages>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200f10:	4515                	li	a0,5
ffffffffc0200f12:	784000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200f16:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200f18:	48050963          	beqz	a0,ffffffffc02013aa <best_fit_check+0x63e>
ffffffffc0200f1c:	651c                	ld	a5,8(a0)
ffffffffc0200f1e:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200f20:	8b85                	andi	a5,a5,1
ffffffffc0200f22:	46079463          	bnez	a5,ffffffffc020138a <best_fit_check+0x61e>
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200f26:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f28:	00043a83          	ld	s5,0(s0)
ffffffffc0200f2c:	00843a03          	ld	s4,8(s0)
ffffffffc0200f30:	e000                	sd	s0,0(s0)
ffffffffc0200f32:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200f34:	762000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200f38:	42051963          	bnez	a0,ffffffffc020136a <best_fit_check+0x5fe>
    #endif
    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    // * - - * -
    free_pages(p0 + 1, 2);
ffffffffc0200f3c:	4589                	li	a1,2
ffffffffc0200f3e:	02898513          	addi	a0,s3,40
    unsigned int nr_free_store = nr_free;
ffffffffc0200f42:	01042b03          	lw	s6,16(s0)
    free_pages(p0 + 4, 1);
ffffffffc0200f46:	0a098c13          	addi	s8,s3,160
    nr_free = 0;
ffffffffc0200f4a:	00005797          	auipc	a5,0x5
ffffffffc0200f4e:	0e07a723          	sw	zero,238(a5) # ffffffffc0206038 <free_area+0x10>
    free_pages(p0 + 1, 2);
ffffffffc0200f52:	782000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    free_pages(p0 + 4, 1);
ffffffffc0200f56:	8562                	mv	a0,s8
ffffffffc0200f58:	4585                	li	a1,1
ffffffffc0200f5a:	77a000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200f5e:	4511                	li	a0,4
ffffffffc0200f60:	736000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200f64:	3e051363          	bnez	a0,ffffffffc020134a <best_fit_check+0x5de>
ffffffffc0200f68:	0309b783          	ld	a5,48(s3)
ffffffffc0200f6c:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc0200f6e:	8b85                	andi	a5,a5,1
ffffffffc0200f70:	3a078d63          	beqz	a5,ffffffffc020132a <best_fit_check+0x5be>
ffffffffc0200f74:	0389a703          	lw	a4,56(s3)
ffffffffc0200f78:	4789                	li	a5,2
ffffffffc0200f7a:	3af71863          	bne	a4,a5,ffffffffc020132a <best_fit_check+0x5be>
    // * - - * *
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc0200f7e:	4505                	li	a0,1
ffffffffc0200f80:	716000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200f84:	8baa                	mv	s7,a0
ffffffffc0200f86:	38050263          	beqz	a0,ffffffffc020130a <best_fit_check+0x59e>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc0200f8a:	4509                	li	a0,2
ffffffffc0200f8c:	70a000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200f90:	34050d63          	beqz	a0,ffffffffc02012ea <best_fit_check+0x57e>
    assert(p0 + 4 == p1);
ffffffffc0200f94:	337c1b63          	bne	s8,s7,ffffffffc02012ca <best_fit_check+0x55e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    p2 = p0 + 1;
    free_pages(p0, 5);
ffffffffc0200f98:	854e                	mv	a0,s3
ffffffffc0200f9a:	4595                	li	a1,5
ffffffffc0200f9c:	738000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0200fa0:	4515                	li	a0,5
ffffffffc0200fa2:	6f4000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200fa6:	89aa                	mv	s3,a0
ffffffffc0200fa8:	30050163          	beqz	a0,ffffffffc02012aa <best_fit_check+0x53e>
    assert(alloc_page() == NULL);
ffffffffc0200fac:	4505                	li	a0,1
ffffffffc0200fae:	6e8000ef          	jal	ra,ffffffffc0201696 <alloc_pages>
ffffffffc0200fb2:	2c051c63          	bnez	a0,ffffffffc020128a <best_fit_check+0x51e>

    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
    assert(nr_free == 0);
ffffffffc0200fb6:	481c                	lw	a5,16(s0)
ffffffffc0200fb8:	2a079963          	bnez	a5,ffffffffc020126a <best_fit_check+0x4fe>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0200fbc:	4595                	li	a1,5
ffffffffc0200fbe:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0200fc0:	01642823          	sw	s6,16(s0)
    free_list = free_list_store;
ffffffffc0200fc4:	01543023          	sd	s5,0(s0)
ffffffffc0200fc8:	01443423          	sd	s4,8(s0)
    free_pages(p0, 5);
ffffffffc0200fcc:	708000ef          	jal	ra,ffffffffc02016d4 <free_pages>
    return listelm->next;
ffffffffc0200fd0:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fd2:	00878963          	beq	a5,s0,ffffffffc0200fe4 <best_fit_check+0x278>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0200fd6:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200fda:	679c                	ld	a5,8(a5)
ffffffffc0200fdc:	397d                	addiw	s2,s2,-1
ffffffffc0200fde:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200fe0:	fe879be3          	bne	a5,s0,ffffffffc0200fd6 <best_fit_check+0x26a>
    }
    assert(count == 0);
ffffffffc0200fe4:	26091363          	bnez	s2,ffffffffc020124a <best_fit_check+0x4de>
    assert(total == 0);
ffffffffc0200fe8:	e0ed                	bnez	s1,ffffffffc02010ca <best_fit_check+0x35e>
    #ifdef ucore_test
    score += 1;
    cprintf("grading: %d / %d points\n",score, sumscore);
    #endif
}
ffffffffc0200fea:	60a6                	ld	ra,72(sp)
ffffffffc0200fec:	6406                	ld	s0,64(sp)
ffffffffc0200fee:	74e2                	ld	s1,56(sp)
ffffffffc0200ff0:	7942                	ld	s2,48(sp)
ffffffffc0200ff2:	79a2                	ld	s3,40(sp)
ffffffffc0200ff4:	7a02                	ld	s4,32(sp)
ffffffffc0200ff6:	6ae2                	ld	s5,24(sp)
ffffffffc0200ff8:	6b42                	ld	s6,16(sp)
ffffffffc0200ffa:	6ba2                	ld	s7,8(sp)
ffffffffc0200ffc:	6c02                	ld	s8,0(sp)
ffffffffc0200ffe:	6161                	addi	sp,sp,80
ffffffffc0201000:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201002:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201004:	4481                	li	s1,0
ffffffffc0201006:	4901                	li	s2,0
ffffffffc0201008:	b35d                	j	ffffffffc0200dae <best_fit_check+0x42>
        assert(PageProperty(p));
ffffffffc020100a:	00002697          	auipc	a3,0x2
ffffffffc020100e:	83e68693          	addi	a3,a3,-1986 # ffffffffc0202848 <commands+0x710>
ffffffffc0201012:	00002617          	auipc	a2,0x2
ffffffffc0201016:	80660613          	addi	a2,a2,-2042 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020101a:	10800593          	li	a1,264
ffffffffc020101e:	00002517          	auipc	a0,0x2
ffffffffc0201022:	81250513          	addi	a0,a0,-2030 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201026:	ba8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020102a:	00002697          	auipc	a3,0x2
ffffffffc020102e:	8ae68693          	addi	a3,a3,-1874 # ffffffffc02028d8 <commands+0x7a0>
ffffffffc0201032:	00001617          	auipc	a2,0x1
ffffffffc0201036:	7e660613          	addi	a2,a2,2022 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020103a:	0d400593          	li	a1,212
ffffffffc020103e:	00001517          	auipc	a0,0x1
ffffffffc0201042:	7f250513          	addi	a0,a0,2034 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201046:	b88ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020104a:	00002697          	auipc	a3,0x2
ffffffffc020104e:	8b668693          	addi	a3,a3,-1866 # ffffffffc0202900 <commands+0x7c8>
ffffffffc0201052:	00001617          	auipc	a2,0x1
ffffffffc0201056:	7c660613          	addi	a2,a2,1990 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020105a:	0d500593          	li	a1,213
ffffffffc020105e:	00001517          	auipc	a0,0x1
ffffffffc0201062:	7d250513          	addi	a0,a0,2002 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201066:	b68ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020106a:	00002697          	auipc	a3,0x2
ffffffffc020106e:	8d668693          	addi	a3,a3,-1834 # ffffffffc0202940 <commands+0x808>
ffffffffc0201072:	00001617          	auipc	a2,0x1
ffffffffc0201076:	7a660613          	addi	a2,a2,1958 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020107a:	0d700593          	li	a1,215
ffffffffc020107e:	00001517          	auipc	a0,0x1
ffffffffc0201082:	7b250513          	addi	a0,a0,1970 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201086:	b48ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(!list_empty(&free_list));
ffffffffc020108a:	00002697          	auipc	a3,0x2
ffffffffc020108e:	93e68693          	addi	a3,a3,-1730 # ffffffffc02029c8 <commands+0x890>
ffffffffc0201092:	00001617          	auipc	a2,0x1
ffffffffc0201096:	78660613          	addi	a2,a2,1926 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020109a:	0f000593          	li	a1,240
ffffffffc020109e:	00001517          	auipc	a0,0x1
ffffffffc02010a2:	79250513          	addi	a0,a0,1938 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02010a6:	b28ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010aa:	00002697          	auipc	a3,0x2
ffffffffc02010ae:	80e68693          	addi	a3,a3,-2034 # ffffffffc02028b8 <commands+0x780>
ffffffffc02010b2:	00001617          	auipc	a2,0x1
ffffffffc02010b6:	76660613          	addi	a2,a2,1894 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02010ba:	0d200593          	li	a1,210
ffffffffc02010be:	00001517          	auipc	a0,0x1
ffffffffc02010c2:	77250513          	addi	a0,a0,1906 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02010c6:	b08ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(total == 0);
ffffffffc02010ca:	00002697          	auipc	a3,0x2
ffffffffc02010ce:	a2e68693          	addi	a3,a3,-1490 # ffffffffc0202af8 <commands+0x9c0>
ffffffffc02010d2:	00001617          	auipc	a2,0x1
ffffffffc02010d6:	74660613          	addi	a2,a2,1862 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02010da:	14a00593          	li	a1,330
ffffffffc02010de:	00001517          	auipc	a0,0x1
ffffffffc02010e2:	75250513          	addi	a0,a0,1874 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02010e6:	ae8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(total == nr_free_pages());
ffffffffc02010ea:	00001697          	auipc	a3,0x1
ffffffffc02010ee:	76e68693          	addi	a3,a3,1902 # ffffffffc0202858 <commands+0x720>
ffffffffc02010f2:	00001617          	auipc	a2,0x1
ffffffffc02010f6:	72660613          	addi	a2,a2,1830 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02010fa:	10b00593          	li	a1,267
ffffffffc02010fe:	00001517          	auipc	a0,0x1
ffffffffc0201102:	73250513          	addi	a0,a0,1842 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201106:	ac8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020110a:	00001697          	auipc	a3,0x1
ffffffffc020110e:	78e68693          	addi	a3,a3,1934 # ffffffffc0202898 <commands+0x760>
ffffffffc0201112:	00001617          	auipc	a2,0x1
ffffffffc0201116:	70660613          	addi	a2,a2,1798 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020111a:	0d100593          	li	a1,209
ffffffffc020111e:	00001517          	auipc	a0,0x1
ffffffffc0201122:	71250513          	addi	a0,a0,1810 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201126:	aa8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020112a:	00001697          	auipc	a3,0x1
ffffffffc020112e:	74e68693          	addi	a3,a3,1870 # ffffffffc0202878 <commands+0x740>
ffffffffc0201132:	00001617          	auipc	a2,0x1
ffffffffc0201136:	6e660613          	addi	a2,a2,1766 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020113a:	0d000593          	li	a1,208
ffffffffc020113e:	00001517          	auipc	a0,0x1
ffffffffc0201142:	6f250513          	addi	a0,a0,1778 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201146:	a88ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(alloc_page() == NULL);
ffffffffc020114a:	00002697          	auipc	a3,0x2
ffffffffc020114e:	85668693          	addi	a3,a3,-1962 # ffffffffc02029a0 <commands+0x868>
ffffffffc0201152:	00001617          	auipc	a2,0x1
ffffffffc0201156:	6c660613          	addi	a2,a2,1734 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020115a:	0ed00593          	li	a1,237
ffffffffc020115e:	00001517          	auipc	a0,0x1
ffffffffc0201162:	6d250513          	addi	a0,a0,1746 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201166:	a68ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020116a:	00001697          	auipc	a3,0x1
ffffffffc020116e:	74e68693          	addi	a3,a3,1870 # ffffffffc02028b8 <commands+0x780>
ffffffffc0201172:	00001617          	auipc	a2,0x1
ffffffffc0201176:	6a660613          	addi	a2,a2,1702 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020117a:	0eb00593          	li	a1,235
ffffffffc020117e:	00001517          	auipc	a0,0x1
ffffffffc0201182:	6b250513          	addi	a0,a0,1714 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201186:	a48ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020118a:	00001697          	auipc	a3,0x1
ffffffffc020118e:	70e68693          	addi	a3,a3,1806 # ffffffffc0202898 <commands+0x760>
ffffffffc0201192:	00001617          	auipc	a2,0x1
ffffffffc0201196:	68660613          	addi	a2,a2,1670 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020119a:	0ea00593          	li	a1,234
ffffffffc020119e:	00001517          	auipc	a0,0x1
ffffffffc02011a2:	69250513          	addi	a0,a0,1682 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02011a6:	a28ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011aa:	00001697          	auipc	a3,0x1
ffffffffc02011ae:	6ce68693          	addi	a3,a3,1742 # ffffffffc0202878 <commands+0x740>
ffffffffc02011b2:	00001617          	auipc	a2,0x1
ffffffffc02011b6:	66660613          	addi	a2,a2,1638 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02011ba:	0e900593          	li	a1,233
ffffffffc02011be:	00001517          	auipc	a0,0x1
ffffffffc02011c2:	67250513          	addi	a0,a0,1650 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02011c6:	a08ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(nr_free == 3);
ffffffffc02011ca:	00001697          	auipc	a3,0x1
ffffffffc02011ce:	7ee68693          	addi	a3,a3,2030 # ffffffffc02029b8 <commands+0x880>
ffffffffc02011d2:	00001617          	auipc	a2,0x1
ffffffffc02011d6:	64660613          	addi	a2,a2,1606 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02011da:	0e700593          	li	a1,231
ffffffffc02011de:	00001517          	auipc	a0,0x1
ffffffffc02011e2:	65250513          	addi	a0,a0,1618 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02011e6:	9e8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011ea:	00001697          	auipc	a3,0x1
ffffffffc02011ee:	7b668693          	addi	a3,a3,1974 # ffffffffc02029a0 <commands+0x868>
ffffffffc02011f2:	00001617          	auipc	a2,0x1
ffffffffc02011f6:	62660613          	addi	a2,a2,1574 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02011fa:	0e200593          	li	a1,226
ffffffffc02011fe:	00001517          	auipc	a0,0x1
ffffffffc0201202:	63250513          	addi	a0,a0,1586 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201206:	9c8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020120a:	00001697          	auipc	a3,0x1
ffffffffc020120e:	77668693          	addi	a3,a3,1910 # ffffffffc0202980 <commands+0x848>
ffffffffc0201212:	00001617          	auipc	a2,0x1
ffffffffc0201216:	60660613          	addi	a2,a2,1542 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020121a:	0d900593          	li	a1,217
ffffffffc020121e:	00001517          	auipc	a0,0x1
ffffffffc0201222:	61250513          	addi	a0,a0,1554 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201226:	9a8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020122a:	00001697          	auipc	a3,0x1
ffffffffc020122e:	73668693          	addi	a3,a3,1846 # ffffffffc0202960 <commands+0x828>
ffffffffc0201232:	00001617          	auipc	a2,0x1
ffffffffc0201236:	5e660613          	addi	a2,a2,1510 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020123a:	0d800593          	li	a1,216
ffffffffc020123e:	00001517          	auipc	a0,0x1
ffffffffc0201242:	5f250513          	addi	a0,a0,1522 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201246:	988ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(count == 0);
ffffffffc020124a:	00002697          	auipc	a3,0x2
ffffffffc020124e:	89e68693          	addi	a3,a3,-1890 # ffffffffc0202ae8 <commands+0x9b0>
ffffffffc0201252:	00001617          	auipc	a2,0x1
ffffffffc0201256:	5c660613          	addi	a2,a2,1478 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020125a:	14900593          	li	a1,329
ffffffffc020125e:	00001517          	auipc	a0,0x1
ffffffffc0201262:	5d250513          	addi	a0,a0,1490 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201266:	968ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(nr_free == 0);
ffffffffc020126a:	00001697          	auipc	a3,0x1
ffffffffc020126e:	79668693          	addi	a3,a3,1942 # ffffffffc0202a00 <commands+0x8c8>
ffffffffc0201272:	00001617          	auipc	a2,0x1
ffffffffc0201276:	5a660613          	addi	a2,a2,1446 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020127a:	13e00593          	li	a1,318
ffffffffc020127e:	00001517          	auipc	a0,0x1
ffffffffc0201282:	5b250513          	addi	a0,a0,1458 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201286:	948ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(alloc_page() == NULL);
ffffffffc020128a:	00001697          	auipc	a3,0x1
ffffffffc020128e:	71668693          	addi	a3,a3,1814 # ffffffffc02029a0 <commands+0x868>
ffffffffc0201292:	00001617          	auipc	a2,0x1
ffffffffc0201296:	58660613          	addi	a2,a2,1414 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020129a:	13800593          	li	a1,312
ffffffffc020129e:	00001517          	auipc	a0,0x1
ffffffffc02012a2:	59250513          	addi	a0,a0,1426 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02012a6:	928ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02012aa:	00002697          	auipc	a3,0x2
ffffffffc02012ae:	81e68693          	addi	a3,a3,-2018 # ffffffffc0202ac8 <commands+0x990>
ffffffffc02012b2:	00001617          	auipc	a2,0x1
ffffffffc02012b6:	56660613          	addi	a2,a2,1382 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02012ba:	13700593          	li	a1,311
ffffffffc02012be:	00001517          	auipc	a0,0x1
ffffffffc02012c2:	57250513          	addi	a0,a0,1394 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02012c6:	908ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(p0 + 4 == p1);
ffffffffc02012ca:	00001697          	auipc	a3,0x1
ffffffffc02012ce:	7ee68693          	addi	a3,a3,2030 # ffffffffc0202ab8 <commands+0x980>
ffffffffc02012d2:	00001617          	auipc	a2,0x1
ffffffffc02012d6:	54660613          	addi	a2,a2,1350 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02012da:	12f00593          	li	a1,303
ffffffffc02012de:	00001517          	auipc	a0,0x1
ffffffffc02012e2:	55250513          	addi	a0,a0,1362 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02012e6:	8e8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(alloc_pages(2) != NULL);      // best fit feature
ffffffffc02012ea:	00001697          	auipc	a3,0x1
ffffffffc02012ee:	7b668693          	addi	a3,a3,1974 # ffffffffc0202aa0 <commands+0x968>
ffffffffc02012f2:	00001617          	auipc	a2,0x1
ffffffffc02012f6:	52660613          	addi	a2,a2,1318 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02012fa:	12e00593          	li	a1,302
ffffffffc02012fe:	00001517          	auipc	a0,0x1
ffffffffc0201302:	53250513          	addi	a0,a0,1330 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201306:	8c8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p1 = alloc_pages(1)) != NULL);
ffffffffc020130a:	00001697          	auipc	a3,0x1
ffffffffc020130e:	77668693          	addi	a3,a3,1910 # ffffffffc0202a80 <commands+0x948>
ffffffffc0201312:	00001617          	auipc	a2,0x1
ffffffffc0201316:	50660613          	addi	a2,a2,1286 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020131a:	12d00593          	li	a1,301
ffffffffc020131e:	00001517          	auipc	a0,0x1
ffffffffc0201322:	51250513          	addi	a0,a0,1298 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201326:	8a8ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(PageProperty(p0 + 1) && p0[1].property == 2);
ffffffffc020132a:	00001697          	auipc	a3,0x1
ffffffffc020132e:	72668693          	addi	a3,a3,1830 # ffffffffc0202a50 <commands+0x918>
ffffffffc0201332:	00001617          	auipc	a2,0x1
ffffffffc0201336:	4e660613          	addi	a2,a2,1254 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020133a:	12b00593          	li	a1,299
ffffffffc020133e:	00001517          	auipc	a0,0x1
ffffffffc0201342:	4f250513          	addi	a0,a0,1266 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201346:	888ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc020134a:	00001697          	auipc	a3,0x1
ffffffffc020134e:	6ee68693          	addi	a3,a3,1774 # ffffffffc0202a38 <commands+0x900>
ffffffffc0201352:	00001617          	auipc	a2,0x1
ffffffffc0201356:	4c660613          	addi	a2,a2,1222 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020135a:	12a00593          	li	a1,298
ffffffffc020135e:	00001517          	auipc	a0,0x1
ffffffffc0201362:	4d250513          	addi	a0,a0,1234 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201366:	868ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(alloc_page() == NULL);
ffffffffc020136a:	00001697          	auipc	a3,0x1
ffffffffc020136e:	63668693          	addi	a3,a3,1590 # ffffffffc02029a0 <commands+0x868>
ffffffffc0201372:	00001617          	auipc	a2,0x1
ffffffffc0201376:	4a660613          	addi	a2,a2,1190 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020137a:	11e00593          	li	a1,286
ffffffffc020137e:	00001517          	auipc	a0,0x1
ffffffffc0201382:	4b250513          	addi	a0,a0,1202 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201386:	848ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(!PageProperty(p0));
ffffffffc020138a:	00001697          	auipc	a3,0x1
ffffffffc020138e:	69668693          	addi	a3,a3,1686 # ffffffffc0202a20 <commands+0x8e8>
ffffffffc0201392:	00001617          	auipc	a2,0x1
ffffffffc0201396:	48660613          	addi	a2,a2,1158 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020139a:	11500593          	li	a1,277
ffffffffc020139e:	00001517          	auipc	a0,0x1
ffffffffc02013a2:	49250513          	addi	a0,a0,1170 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02013a6:	828ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(p0 != NULL);
ffffffffc02013aa:	00001697          	auipc	a3,0x1
ffffffffc02013ae:	66668693          	addi	a3,a3,1638 # ffffffffc0202a10 <commands+0x8d8>
ffffffffc02013b2:	00001617          	auipc	a2,0x1
ffffffffc02013b6:	46660613          	addi	a2,a2,1126 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02013ba:	11400593          	li	a1,276
ffffffffc02013be:	00001517          	auipc	a0,0x1
ffffffffc02013c2:	47250513          	addi	a0,a0,1138 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02013c6:	808ff0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(nr_free == 0);
ffffffffc02013ca:	00001697          	auipc	a3,0x1
ffffffffc02013ce:	63668693          	addi	a3,a3,1590 # ffffffffc0202a00 <commands+0x8c8>
ffffffffc02013d2:	00001617          	auipc	a2,0x1
ffffffffc02013d6:	44660613          	addi	a2,a2,1094 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02013da:	0f600593          	li	a1,246
ffffffffc02013de:	00001517          	auipc	a0,0x1
ffffffffc02013e2:	45250513          	addi	a0,a0,1106 # ffffffffc0202830 <commands+0x6f8>
ffffffffc02013e6:	fe9fe0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013ea:	00001697          	auipc	a3,0x1
ffffffffc02013ee:	5b668693          	addi	a3,a3,1462 # ffffffffc02029a0 <commands+0x868>
ffffffffc02013f2:	00001617          	auipc	a2,0x1
ffffffffc02013f6:	42660613          	addi	a2,a2,1062 # ffffffffc0202818 <commands+0x6e0>
ffffffffc02013fa:	0f400593          	li	a1,244
ffffffffc02013fe:	00001517          	auipc	a0,0x1
ffffffffc0201402:	43250513          	addi	a0,a0,1074 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201406:	fc9fe0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020140a:	00001697          	auipc	a3,0x1
ffffffffc020140e:	5d668693          	addi	a3,a3,1494 # ffffffffc02029e0 <commands+0x8a8>
ffffffffc0201412:	00001617          	auipc	a2,0x1
ffffffffc0201416:	40660613          	addi	a2,a2,1030 # ffffffffc0202818 <commands+0x6e0>
ffffffffc020141a:	0f300593          	li	a1,243
ffffffffc020141e:	00001517          	auipc	a0,0x1
ffffffffc0201422:	41250513          	addi	a0,a0,1042 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201426:	fa9fe0ef          	jal	ra,ffffffffc02003ce <__panic>

ffffffffc020142a <best_fit_free_pages>:
best_fit_free_pages(struct Page *base, size_t n) {
ffffffffc020142a:	1141                	addi	sp,sp,-16
ffffffffc020142c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020142e:	14058a63          	beqz	a1,ffffffffc0201582 <best_fit_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc0201432:	00259693          	slli	a3,a1,0x2
ffffffffc0201436:	96ae                	add	a3,a3,a1
ffffffffc0201438:	068e                	slli	a3,a3,0x3
ffffffffc020143a:	96aa                	add	a3,a3,a0
ffffffffc020143c:	87aa                	mv	a5,a0
ffffffffc020143e:	02d50263          	beq	a0,a3,ffffffffc0201462 <best_fit_free_pages+0x38>
ffffffffc0201442:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201444:	8b05                	andi	a4,a4,1
ffffffffc0201446:	10071e63          	bnez	a4,ffffffffc0201562 <best_fit_free_pages+0x138>
ffffffffc020144a:	6798                	ld	a4,8(a5)
ffffffffc020144c:	8b09                	andi	a4,a4,2
ffffffffc020144e:	10071a63          	bnez	a4,ffffffffc0201562 <best_fit_free_pages+0x138>
        p->flags = 0;
ffffffffc0201452:	0007b423          	sd	zero,8(a5)



static inline int page_ref(struct Page *page) { return page->ref; }

static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc0201456:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020145a:	02878793          	addi	a5,a5,40
ffffffffc020145e:	fed792e3          	bne	a5,a3,ffffffffc0201442 <best_fit_free_pages+0x18>
    base->property = n;
ffffffffc0201462:	2581                	sext.w	a1,a1
ffffffffc0201464:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0201466:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020146a:	4789                	li	a5,2
ffffffffc020146c:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201470:	00005697          	auipc	a3,0x5
ffffffffc0201474:	bb868693          	addi	a3,a3,-1096 # ffffffffc0206028 <free_area>
ffffffffc0201478:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020147a:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020147c:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201480:	9db9                	addw	a1,a1,a4
ffffffffc0201482:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201484:	0ad78863          	beq	a5,a3,ffffffffc0201534 <best_fit_free_pages+0x10a>
            struct Page *page = le2page(le, page_link);
ffffffffc0201488:	fe878713          	addi	a4,a5,-24
ffffffffc020148c:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201490:	4581                	li	a1,0
            if (base < page)
ffffffffc0201492:	00e56a63          	bltu	a0,a4,ffffffffc02014a6 <best_fit_free_pages+0x7c>
    return listelm->next;
ffffffffc0201496:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201498:	06d70263          	beq	a4,a3,ffffffffc02014fc <best_fit_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc020149c:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc020149e:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02014a2:	fee57ae3          	bgeu	a0,a4,ffffffffc0201496 <best_fit_free_pages+0x6c>
ffffffffc02014a6:	c199                	beqz	a1,ffffffffc02014ac <best_fit_free_pages+0x82>
ffffffffc02014a8:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02014ac:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc02014ae:	e390                	sd	a2,0(a5)
ffffffffc02014b0:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02014b2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02014b4:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc02014b6:	02d70063          	beq	a4,a3,ffffffffc02014d6 <best_fit_free_pages+0xac>
        if (p + p->property == base)
ffffffffc02014ba:	ff872803          	lw	a6,-8(a4)
        p = le2page(le, page_link);
ffffffffc02014be:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base)
ffffffffc02014c2:	02081613          	slli	a2,a6,0x20
ffffffffc02014c6:	9201                	srli	a2,a2,0x20
ffffffffc02014c8:	00261793          	slli	a5,a2,0x2
ffffffffc02014cc:	97b2                	add	a5,a5,a2
ffffffffc02014ce:	078e                	slli	a5,a5,0x3
ffffffffc02014d0:	97ae                	add	a5,a5,a1
ffffffffc02014d2:	02f50f63          	beq	a0,a5,ffffffffc0201510 <best_fit_free_pages+0xe6>
    return listelm->next;
ffffffffc02014d6:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc02014d8:	00d70f63          	beq	a4,a3,ffffffffc02014f6 <best_fit_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc02014dc:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc02014de:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc02014e2:	02059613          	slli	a2,a1,0x20
ffffffffc02014e6:	9201                	srli	a2,a2,0x20
ffffffffc02014e8:	00261793          	slli	a5,a2,0x2
ffffffffc02014ec:	97b2                	add	a5,a5,a2
ffffffffc02014ee:	078e                	slli	a5,a5,0x3
ffffffffc02014f0:	97aa                	add	a5,a5,a0
ffffffffc02014f2:	04f68863          	beq	a3,a5,ffffffffc0201542 <best_fit_free_pages+0x118>
}
ffffffffc02014f6:	60a2                	ld	ra,8(sp)
ffffffffc02014f8:	0141                	addi	sp,sp,16
ffffffffc02014fa:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02014fc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02014fe:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201500:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201502:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201504:	02d70563          	beq	a4,a3,ffffffffc020152e <best_fit_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc0201508:	8832                	mv	a6,a2
ffffffffc020150a:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020150c:	87ba                	mv	a5,a4
ffffffffc020150e:	bf41                	j	ffffffffc020149e <best_fit_free_pages+0x74>
            p->property += base->property;
ffffffffc0201510:	491c                	lw	a5,16(a0)
ffffffffc0201512:	0107883b          	addw	a6,a5,a6
ffffffffc0201516:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020151a:	57f5                	li	a5,-3
ffffffffc020151c:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201520:	6d10                	ld	a2,24(a0)
ffffffffc0201522:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc0201524:	852e                	mv	a0,a1
    prev->next = next;
ffffffffc0201526:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc0201528:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc020152a:	e390                	sd	a2,0(a5)
ffffffffc020152c:	b775                	j	ffffffffc02014d8 <best_fit_free_pages+0xae>
ffffffffc020152e:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201530:	873e                	mv	a4,a5
ffffffffc0201532:	b761                	j	ffffffffc02014ba <best_fit_free_pages+0x90>
}
ffffffffc0201534:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201536:	e390                	sd	a2,0(a5)
ffffffffc0201538:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020153a:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020153c:	ed1c                	sd	a5,24(a0)
ffffffffc020153e:	0141                	addi	sp,sp,16
ffffffffc0201540:	8082                	ret
            base->property += p->property;
ffffffffc0201542:	ff872783          	lw	a5,-8(a4)
ffffffffc0201546:	ff070693          	addi	a3,a4,-16
ffffffffc020154a:	9dbd                	addw	a1,a1,a5
ffffffffc020154c:	c90c                	sw	a1,16(a0)
ffffffffc020154e:	57f5                	li	a5,-3
ffffffffc0201550:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201554:	6314                	ld	a3,0(a4)
ffffffffc0201556:	671c                	ld	a5,8(a4)
}
ffffffffc0201558:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020155a:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc020155c:	e394                	sd	a3,0(a5)
ffffffffc020155e:	0141                	addi	sp,sp,16
ffffffffc0201560:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201562:	00001697          	auipc	a3,0x1
ffffffffc0201566:	5a668693          	addi	a3,a3,1446 # ffffffffc0202b08 <commands+0x9d0>
ffffffffc020156a:	00001617          	auipc	a2,0x1
ffffffffc020156e:	2ae60613          	addi	a2,a2,686 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0201572:	08f00593          	li	a1,143
ffffffffc0201576:	00001517          	auipc	a0,0x1
ffffffffc020157a:	2ba50513          	addi	a0,a0,698 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020157e:	e51fe0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(n > 0);
ffffffffc0201582:	00001697          	auipc	a3,0x1
ffffffffc0201586:	28e68693          	addi	a3,a3,654 # ffffffffc0202810 <commands+0x6d8>
ffffffffc020158a:	00001617          	auipc	a2,0x1
ffffffffc020158e:	28e60613          	addi	a2,a2,654 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0201592:	08c00593          	li	a1,140
ffffffffc0201596:	00001517          	auipc	a0,0x1
ffffffffc020159a:	29a50513          	addi	a0,a0,666 # ffffffffc0202830 <commands+0x6f8>
ffffffffc020159e:	e31fe0ef          	jal	ra,ffffffffc02003ce <__panic>

ffffffffc02015a2 <best_fit_init_memmap>:
best_fit_init_memmap(struct Page *base, size_t n) {
ffffffffc02015a2:	1141                	addi	sp,sp,-16
ffffffffc02015a4:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02015a6:	c9e1                	beqz	a1,ffffffffc0201676 <best_fit_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc02015a8:	00259693          	slli	a3,a1,0x2
ffffffffc02015ac:	96ae                	add	a3,a3,a1
ffffffffc02015ae:	068e                	slli	a3,a3,0x3
ffffffffc02015b0:	96aa                	add	a3,a3,a0
ffffffffc02015b2:	87aa                	mv	a5,a0
ffffffffc02015b4:	00d50f63          	beq	a0,a3,ffffffffc02015d2 <best_fit_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02015b8:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02015ba:	8b05                	andi	a4,a4,1
ffffffffc02015bc:	cf49                	beqz	a4,ffffffffc0201656 <best_fit_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc02015be:	0007a823          	sw	zero,16(a5)
ffffffffc02015c2:	0007b423          	sd	zero,8(a5)
ffffffffc02015c6:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015ca:	02878793          	addi	a5,a5,40
ffffffffc02015ce:	fed795e3          	bne	a5,a3,ffffffffc02015b8 <best_fit_init_memmap+0x16>
    base->property = n;
ffffffffc02015d2:	2581                	sext.w	a1,a1
ffffffffc02015d4:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015d6:	4789                	li	a5,2
ffffffffc02015d8:	00850713          	addi	a4,a0,8
ffffffffc02015dc:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02015e0:	00005697          	auipc	a3,0x5
ffffffffc02015e4:	a4868693          	addi	a3,a3,-1464 # ffffffffc0206028 <free_area>
ffffffffc02015e8:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02015ea:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02015ec:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02015f0:	9db9                	addw	a1,a1,a4
ffffffffc02015f2:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02015f4:	04d78a63          	beq	a5,a3,ffffffffc0201648 <best_fit_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc02015f8:	fe878713          	addi	a4,a5,-24
ffffffffc02015fc:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201600:	4581                	li	a1,0
            if (base < page)
ffffffffc0201602:	00e56a63          	bltu	a0,a4,ffffffffc0201616 <best_fit_init_memmap+0x74>
    return listelm->next;
ffffffffc0201606:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201608:	02d70263          	beq	a4,a3,ffffffffc020162c <best_fit_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc020160c:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020160e:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201612:	fee57ae3          	bgeu	a0,a4,ffffffffc0201606 <best_fit_init_memmap+0x64>
ffffffffc0201616:	c199                	beqz	a1,ffffffffc020161c <best_fit_init_memmap+0x7a>
ffffffffc0201618:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020161c:	6398                	ld	a4,0(a5)
}
ffffffffc020161e:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201620:	e390                	sd	a2,0(a5)
ffffffffc0201622:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201624:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201626:	ed18                	sd	a4,24(a0)
ffffffffc0201628:	0141                	addi	sp,sp,16
ffffffffc020162a:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020162c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020162e:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201630:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201632:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201634:	00d70663          	beq	a4,a3,ffffffffc0201640 <best_fit_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc0201638:	8832                	mv	a6,a2
ffffffffc020163a:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020163c:	87ba                	mv	a5,a4
ffffffffc020163e:	bfc1                	j	ffffffffc020160e <best_fit_init_memmap+0x6c>
}
ffffffffc0201640:	60a2                	ld	ra,8(sp)
ffffffffc0201642:	e290                	sd	a2,0(a3)
ffffffffc0201644:	0141                	addi	sp,sp,16
ffffffffc0201646:	8082                	ret
ffffffffc0201648:	60a2                	ld	ra,8(sp)
ffffffffc020164a:	e390                	sd	a2,0(a5)
ffffffffc020164c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020164e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201650:	ed1c                	sd	a5,24(a0)
ffffffffc0201652:	0141                	addi	sp,sp,16
ffffffffc0201654:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201656:	00001697          	auipc	a3,0x1
ffffffffc020165a:	4da68693          	addi	a3,a3,1242 # ffffffffc0202b30 <commands+0x9f8>
ffffffffc020165e:	00001617          	auipc	a2,0x1
ffffffffc0201662:	1ba60613          	addi	a2,a2,442 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0201666:	04a00593          	li	a1,74
ffffffffc020166a:	00001517          	auipc	a0,0x1
ffffffffc020166e:	1c650513          	addi	a0,a0,454 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201672:	d5dfe0ef          	jal	ra,ffffffffc02003ce <__panic>
    assert(n > 0);
ffffffffc0201676:	00001697          	auipc	a3,0x1
ffffffffc020167a:	19a68693          	addi	a3,a3,410 # ffffffffc0202810 <commands+0x6d8>
ffffffffc020167e:	00001617          	auipc	a2,0x1
ffffffffc0201682:	19a60613          	addi	a2,a2,410 # ffffffffc0202818 <commands+0x6e0>
ffffffffc0201686:	04700593          	li	a1,71
ffffffffc020168a:	00001517          	auipc	a0,0x1
ffffffffc020168e:	1a650513          	addi	a0,a0,422 # ffffffffc0202830 <commands+0x6f8>
ffffffffc0201692:	d3dfe0ef          	jal	ra,ffffffffc02003ce <__panic>

ffffffffc0201696 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201696:	100027f3          	csrr	a5,sstatus
ffffffffc020169a:	8b89                	andi	a5,a5,2
ffffffffc020169c:	e799                	bnez	a5,ffffffffc02016aa <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc020169e:	00005797          	auipc	a5,0x5
ffffffffc02016a2:	dda7b783          	ld	a5,-550(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc02016a6:	6f9c                	ld	a5,24(a5)
ffffffffc02016a8:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc02016aa:	1141                	addi	sp,sp,-16
ffffffffc02016ac:	e406                	sd	ra,8(sp)
ffffffffc02016ae:	e022                	sd	s0,0(sp)
ffffffffc02016b0:	842a                	mv	s0,a0
        intr_disable();
ffffffffc02016b2:	97eff0ef          	jal	ra,ffffffffc0200830 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02016b6:	00005797          	auipc	a5,0x5
ffffffffc02016ba:	dc27b783          	ld	a5,-574(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc02016be:	6f9c                	ld	a5,24(a5)
ffffffffc02016c0:	8522                	mv	a0,s0
ffffffffc02016c2:	9782                	jalr	a5
ffffffffc02016c4:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc02016c6:	964ff0ef          	jal	ra,ffffffffc020082a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc02016ca:	60a2                	ld	ra,8(sp)
ffffffffc02016cc:	8522                	mv	a0,s0
ffffffffc02016ce:	6402                	ld	s0,0(sp)
ffffffffc02016d0:	0141                	addi	sp,sp,16
ffffffffc02016d2:	8082                	ret

ffffffffc02016d4 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02016d4:	100027f3          	csrr	a5,sstatus
ffffffffc02016d8:	8b89                	andi	a5,a5,2
ffffffffc02016da:	e799                	bnez	a5,ffffffffc02016e8 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc02016dc:	00005797          	auipc	a5,0x5
ffffffffc02016e0:	d9c7b783          	ld	a5,-612(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc02016e4:	739c                	ld	a5,32(a5)
ffffffffc02016e6:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc02016e8:	1101                	addi	sp,sp,-32
ffffffffc02016ea:	ec06                	sd	ra,24(sp)
ffffffffc02016ec:	e822                	sd	s0,16(sp)
ffffffffc02016ee:	e426                	sd	s1,8(sp)
ffffffffc02016f0:	842a                	mv	s0,a0
ffffffffc02016f2:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc02016f4:	93cff0ef          	jal	ra,ffffffffc0200830 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02016f8:	00005797          	auipc	a5,0x5
ffffffffc02016fc:	d807b783          	ld	a5,-640(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc0201700:	739c                	ld	a5,32(a5)
ffffffffc0201702:	85a6                	mv	a1,s1
ffffffffc0201704:	8522                	mv	a0,s0
ffffffffc0201706:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201708:	6442                	ld	s0,16(sp)
ffffffffc020170a:	60e2                	ld	ra,24(sp)
ffffffffc020170c:	64a2                	ld	s1,8(sp)
ffffffffc020170e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201710:	91aff06f          	j	ffffffffc020082a <intr_enable>

ffffffffc0201714 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201714:	100027f3          	csrr	a5,sstatus
ffffffffc0201718:	8b89                	andi	a5,a5,2
ffffffffc020171a:	e799                	bnez	a5,ffffffffc0201728 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc020171c:	00005797          	auipc	a5,0x5
ffffffffc0201720:	d5c7b783          	ld	a5,-676(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc0201724:	779c                	ld	a5,40(a5)
ffffffffc0201726:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0201728:	1141                	addi	sp,sp,-16
ffffffffc020172a:	e406                	sd	ra,8(sp)
ffffffffc020172c:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc020172e:	902ff0ef          	jal	ra,ffffffffc0200830 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201732:	00005797          	auipc	a5,0x5
ffffffffc0201736:	d467b783          	ld	a5,-698(a5) # ffffffffc0206478 <pmm_manager>
ffffffffc020173a:	779c                	ld	a5,40(a5)
ffffffffc020173c:	9782                	jalr	a5
ffffffffc020173e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201740:	8eaff0ef          	jal	ra,ffffffffc020082a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201744:	60a2                	ld	ra,8(sp)
ffffffffc0201746:	8522                	mv	a0,s0
ffffffffc0201748:	6402                	ld	s0,0(sp)
ffffffffc020174a:	0141                	addi	sp,sp,16
ffffffffc020174c:	8082                	ret

ffffffffc020174e <pmm_init>:
    pmm_manager = &best_fit_pmm_manager;
ffffffffc020174e:	00001797          	auipc	a5,0x1
ffffffffc0201752:	40a78793          	addi	a5,a5,1034 # ffffffffc0202b58 <best_fit_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201756:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0201758:	7179                	addi	sp,sp,-48
ffffffffc020175a:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020175c:	00001517          	auipc	a0,0x1
ffffffffc0201760:	43450513          	addi	a0,a0,1076 # ffffffffc0202b90 <best_fit_pmm_manager+0x38>
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0201764:	00005417          	auipc	s0,0x5
ffffffffc0201768:	d1440413          	addi	s0,s0,-748 # ffffffffc0206478 <pmm_manager>
void pmm_init(void) {
ffffffffc020176c:	f406                	sd	ra,40(sp)
ffffffffc020176e:	ec26                	sd	s1,24(sp)
ffffffffc0201770:	e44e                	sd	s3,8(sp)
ffffffffc0201772:	e84a                	sd	s2,16(sp)
ffffffffc0201774:	e052                	sd	s4,0(sp)
    pmm_manager = &best_fit_pmm_manager;
ffffffffc0201776:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201778:	95dfe0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    pmm_manager->init();
ffffffffc020177c:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020177e:	00005497          	auipc	s1,0x5
ffffffffc0201782:	d1248493          	addi	s1,s1,-750 # ffffffffc0206490 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201786:	679c                	ld	a5,8(a5)
ffffffffc0201788:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020178a:	57f5                	li	a5,-3
ffffffffc020178c:	07fa                	slli	a5,a5,0x1e
ffffffffc020178e:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0201790:	886ff0ef          	jal	ra,ffffffffc0200816 <get_memory_base>
ffffffffc0201794:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201796:	88aff0ef          	jal	ra,ffffffffc0200820 <get_memory_size>
    if (mem_size == 0) {
ffffffffc020179a:	16050163          	beqz	a0,ffffffffc02018fc <pmm_init+0x1ae>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020179e:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc02017a0:	00001517          	auipc	a0,0x1
ffffffffc02017a4:	43850513          	addi	a0,a0,1080 # ffffffffc0202bd8 <best_fit_pmm_manager+0x80>
ffffffffc02017a8:	92dfe0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02017ac:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc02017b0:	864e                	mv	a2,s3
ffffffffc02017b2:	fffa0693          	addi	a3,s4,-1
ffffffffc02017b6:	85ca                	mv	a1,s2
ffffffffc02017b8:	00001517          	auipc	a0,0x1
ffffffffc02017bc:	43850513          	addi	a0,a0,1080 # ffffffffc0202bf0 <best_fit_pmm_manager+0x98>
ffffffffc02017c0:	915fe0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02017c4:	c80007b7          	lui	a5,0xc8000
ffffffffc02017c8:	8652                	mv	a2,s4
ffffffffc02017ca:	0d47e863          	bltu	a5,s4,ffffffffc020189a <pmm_init+0x14c>
ffffffffc02017ce:	00006797          	auipc	a5,0x6
ffffffffc02017d2:	cd178793          	addi	a5,a5,-815 # ffffffffc020749f <end+0xfff>
ffffffffc02017d6:	757d                	lui	a0,0xfffff
ffffffffc02017d8:	8d7d                	and	a0,a0,a5
ffffffffc02017da:	8231                	srli	a2,a2,0xc
ffffffffc02017dc:	00005597          	auipc	a1,0x5
ffffffffc02017e0:	c8c58593          	addi	a1,a1,-884 # ffffffffc0206468 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017e4:	00005817          	auipc	a6,0x5
ffffffffc02017e8:	c8c80813          	addi	a6,a6,-884 # ffffffffc0206470 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02017ec:	e190                	sd	a2,0(a1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02017ee:	00a83023          	sd	a0,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc02017f2:	000807b7          	lui	a5,0x80
ffffffffc02017f6:	02f60663          	beq	a2,a5,ffffffffc0201822 <pmm_init+0xd4>
ffffffffc02017fa:	4701                	li	a4,0
ffffffffc02017fc:	4781                	li	a5,0
ffffffffc02017fe:	4305                	li	t1,1
ffffffffc0201800:	fff808b7          	lui	a7,0xfff80
        SetPageReserved(pages + i);
ffffffffc0201804:	953a                	add	a0,a0,a4
ffffffffc0201806:	00850693          	addi	a3,a0,8 # fffffffffffff008 <end+0x3fdf8b68>
ffffffffc020180a:	4066b02f          	amoor.d	zero,t1,(a3)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc020180e:	6190                	ld	a2,0(a1)
ffffffffc0201810:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0201812:	00083503          	ld	a0,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0201816:	011606b3          	add	a3,a2,a7
ffffffffc020181a:	02870713          	addi	a4,a4,40
ffffffffc020181e:	fed7e3e3          	bltu	a5,a3,ffffffffc0201804 <pmm_init+0xb6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201822:	00261693          	slli	a3,a2,0x2
ffffffffc0201826:	96b2                	add	a3,a3,a2
ffffffffc0201828:	fec007b7          	lui	a5,0xfec00
ffffffffc020182c:	97aa                	add	a5,a5,a0
ffffffffc020182e:	068e                	slli	a3,a3,0x3
ffffffffc0201830:	96be                	add	a3,a3,a5
ffffffffc0201832:	c02007b7          	lui	a5,0xc0200
ffffffffc0201836:	0af6e763          	bltu	a3,a5,ffffffffc02018e4 <pmm_init+0x196>
ffffffffc020183a:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020183c:	77fd                	lui	a5,0xfffff
ffffffffc020183e:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201842:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0201844:	04b6ee63          	bltu	a3,a1,ffffffffc02018a0 <pmm_init+0x152>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0201848:	601c                	ld	a5,0(s0)
ffffffffc020184a:	7b9c                	ld	a5,48(a5)
ffffffffc020184c:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc020184e:	00001517          	auipc	a0,0x1
ffffffffc0201852:	42a50513          	addi	a0,a0,1066 # ffffffffc0202c78 <best_fit_pmm_manager+0x120>
ffffffffc0201856:	87ffe0ef          	jal	ra,ffffffffc02000d4 <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc020185a:	00003597          	auipc	a1,0x3
ffffffffc020185e:	7a658593          	addi	a1,a1,1958 # ffffffffc0205000 <boot_page_table_sv39>
ffffffffc0201862:	00005797          	auipc	a5,0x5
ffffffffc0201866:	c2b7b323          	sd	a1,-986(a5) # ffffffffc0206488 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc020186a:	c02007b7          	lui	a5,0xc0200
ffffffffc020186e:	0af5e363          	bltu	a1,a5,ffffffffc0201914 <pmm_init+0x1c6>
ffffffffc0201872:	6090                	ld	a2,0(s1)
}
ffffffffc0201874:	7402                	ld	s0,32(sp)
ffffffffc0201876:	70a2                	ld	ra,40(sp)
ffffffffc0201878:	64e2                	ld	s1,24(sp)
ffffffffc020187a:	6942                	ld	s2,16(sp)
ffffffffc020187c:	69a2                	ld	s3,8(sp)
ffffffffc020187e:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0201880:	40c58633          	sub	a2,a1,a2
ffffffffc0201884:	00005797          	auipc	a5,0x5
ffffffffc0201888:	bec7be23          	sd	a2,-1028(a5) # ffffffffc0206480 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc020188c:	00001517          	auipc	a0,0x1
ffffffffc0201890:	40c50513          	addi	a0,a0,1036 # ffffffffc0202c98 <best_fit_pmm_manager+0x140>
}
ffffffffc0201894:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0201896:	83ffe06f          	j	ffffffffc02000d4 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc020189a:	c8000637          	lui	a2,0xc8000
ffffffffc020189e:	bf05                	j	ffffffffc02017ce <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02018a0:	6705                	lui	a4,0x1
ffffffffc02018a2:	177d                	addi	a4,a4,-1
ffffffffc02018a4:	96ba                	add	a3,a3,a4
ffffffffc02018a6:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc02018a8:	00c6d793          	srli	a5,a3,0xc
ffffffffc02018ac:	02c7f063          	bgeu	a5,a2,ffffffffc02018cc <pmm_init+0x17e>
    pmm_manager->init_memmap(base, n);
ffffffffc02018b0:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc02018b2:	fff80737          	lui	a4,0xfff80
ffffffffc02018b6:	973e                	add	a4,a4,a5
ffffffffc02018b8:	00271793          	slli	a5,a4,0x2
ffffffffc02018bc:	97ba                	add	a5,a5,a4
ffffffffc02018be:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc02018c0:	8d95                	sub	a1,a1,a3
ffffffffc02018c2:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc02018c4:	81b1                	srli	a1,a1,0xc
ffffffffc02018c6:	953e                	add	a0,a0,a5
ffffffffc02018c8:	9702                	jalr	a4
}
ffffffffc02018ca:	bfbd                	j	ffffffffc0201848 <pmm_init+0xfa>
        panic("pa2page called with invalid pa");
ffffffffc02018cc:	00001617          	auipc	a2,0x1
ffffffffc02018d0:	37c60613          	addi	a2,a2,892 # ffffffffc0202c48 <best_fit_pmm_manager+0xf0>
ffffffffc02018d4:	06b00593          	li	a1,107
ffffffffc02018d8:	00001517          	auipc	a0,0x1
ffffffffc02018dc:	39050513          	addi	a0,a0,912 # ffffffffc0202c68 <best_fit_pmm_manager+0x110>
ffffffffc02018e0:	aeffe0ef          	jal	ra,ffffffffc02003ce <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02018e4:	00001617          	auipc	a2,0x1
ffffffffc02018e8:	33c60613          	addi	a2,a2,828 # ffffffffc0202c20 <best_fit_pmm_manager+0xc8>
ffffffffc02018ec:	07100593          	li	a1,113
ffffffffc02018f0:	00001517          	auipc	a0,0x1
ffffffffc02018f4:	2d850513          	addi	a0,a0,728 # ffffffffc0202bc8 <best_fit_pmm_manager+0x70>
ffffffffc02018f8:	ad7fe0ef          	jal	ra,ffffffffc02003ce <__panic>
        panic("DTB memory info not available");
ffffffffc02018fc:	00001617          	auipc	a2,0x1
ffffffffc0201900:	2ac60613          	addi	a2,a2,684 # ffffffffc0202ba8 <best_fit_pmm_manager+0x50>
ffffffffc0201904:	05a00593          	li	a1,90
ffffffffc0201908:	00001517          	auipc	a0,0x1
ffffffffc020190c:	2c050513          	addi	a0,a0,704 # ffffffffc0202bc8 <best_fit_pmm_manager+0x70>
ffffffffc0201910:	abffe0ef          	jal	ra,ffffffffc02003ce <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0201914:	86ae                	mv	a3,a1
ffffffffc0201916:	00001617          	auipc	a2,0x1
ffffffffc020191a:	30a60613          	addi	a2,a2,778 # ffffffffc0202c20 <best_fit_pmm_manager+0xc8>
ffffffffc020191e:	08c00593          	li	a1,140
ffffffffc0201922:	00001517          	auipc	a0,0x1
ffffffffc0201926:	2a650513          	addi	a0,a0,678 # ffffffffc0202bc8 <best_fit_pmm_manager+0x70>
ffffffffc020192a:	aa5fe0ef          	jal	ra,ffffffffc02003ce <__panic>

ffffffffc020192e <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020192e:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201932:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201934:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201938:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc020193a:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020193e:	f022                	sd	s0,32(sp)
ffffffffc0201940:	ec26                	sd	s1,24(sp)
ffffffffc0201942:	e84a                	sd	s2,16(sp)
ffffffffc0201944:	f406                	sd	ra,40(sp)
ffffffffc0201946:	e44e                	sd	s3,8(sp)
ffffffffc0201948:	84aa                	mv	s1,a0
ffffffffc020194a:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc020194c:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201950:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201952:	03067e63          	bgeu	a2,a6,ffffffffc020198e <printnum+0x60>
ffffffffc0201956:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201958:	00805763          	blez	s0,ffffffffc0201966 <printnum+0x38>
ffffffffc020195c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020195e:	85ca                	mv	a1,s2
ffffffffc0201960:	854e                	mv	a0,s3
ffffffffc0201962:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201964:	fc65                	bnez	s0,ffffffffc020195c <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201966:	1a02                	slli	s4,s4,0x20
ffffffffc0201968:	00001797          	auipc	a5,0x1
ffffffffc020196c:	37078793          	addi	a5,a5,880 # ffffffffc0202cd8 <best_fit_pmm_manager+0x180>
ffffffffc0201970:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201974:	9a3e                	add	s4,s4,a5
}
ffffffffc0201976:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201978:	000a4503          	lbu	a0,0(s4)
}
ffffffffc020197c:	70a2                	ld	ra,40(sp)
ffffffffc020197e:	69a2                	ld	s3,8(sp)
ffffffffc0201980:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201982:	85ca                	mv	a1,s2
ffffffffc0201984:	87a6                	mv	a5,s1
}
ffffffffc0201986:	6942                	ld	s2,16(sp)
ffffffffc0201988:	64e2                	ld	s1,24(sp)
ffffffffc020198a:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020198c:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc020198e:	03065633          	divu	a2,a2,a6
ffffffffc0201992:	8722                	mv	a4,s0
ffffffffc0201994:	f9bff0ef          	jal	ra,ffffffffc020192e <printnum>
ffffffffc0201998:	b7f9                	j	ffffffffc0201966 <printnum+0x38>

ffffffffc020199a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc020199a:	7119                	addi	sp,sp,-128
ffffffffc020199c:	f4a6                	sd	s1,104(sp)
ffffffffc020199e:	f0ca                	sd	s2,96(sp)
ffffffffc02019a0:	ecce                	sd	s3,88(sp)
ffffffffc02019a2:	e8d2                	sd	s4,80(sp)
ffffffffc02019a4:	e4d6                	sd	s5,72(sp)
ffffffffc02019a6:	e0da                	sd	s6,64(sp)
ffffffffc02019a8:	fc5e                	sd	s7,56(sp)
ffffffffc02019aa:	f06a                	sd	s10,32(sp)
ffffffffc02019ac:	fc86                	sd	ra,120(sp)
ffffffffc02019ae:	f8a2                	sd	s0,112(sp)
ffffffffc02019b0:	f862                	sd	s8,48(sp)
ffffffffc02019b2:	f466                	sd	s9,40(sp)
ffffffffc02019b4:	ec6e                	sd	s11,24(sp)
ffffffffc02019b6:	892a                	mv	s2,a0
ffffffffc02019b8:	84ae                	mv	s1,a1
ffffffffc02019ba:	8d32                	mv	s10,a2
ffffffffc02019bc:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019be:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02019c2:	5b7d                	li	s6,-1
ffffffffc02019c4:	00001a97          	auipc	s5,0x1
ffffffffc02019c8:	348a8a93          	addi	s5,s5,840 # ffffffffc0202d0c <best_fit_pmm_manager+0x1b4>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02019cc:	00001b97          	auipc	s7,0x1
ffffffffc02019d0:	51cb8b93          	addi	s7,s7,1308 # ffffffffc0202ee8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019d4:	000d4503          	lbu	a0,0(s10)
ffffffffc02019d8:	001d0413          	addi	s0,s10,1
ffffffffc02019dc:	01350a63          	beq	a0,s3,ffffffffc02019f0 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02019e0:	c121                	beqz	a0,ffffffffc0201a20 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02019e2:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019e4:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02019e6:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02019e8:	fff44503          	lbu	a0,-1(s0)
ffffffffc02019ec:	ff351ae3          	bne	a0,s3,ffffffffc02019e0 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02019f0:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02019f4:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02019f8:	4c81                	li	s9,0
ffffffffc02019fa:	4881                	li	a7,0
        width = precision = -1;
ffffffffc02019fc:	5c7d                	li	s8,-1
ffffffffc02019fe:	5dfd                	li	s11,-1
ffffffffc0201a00:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0201a04:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a06:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201a0a:	0ff5f593          	zext.b	a1,a1
ffffffffc0201a0e:	00140d13          	addi	s10,s0,1
ffffffffc0201a12:	04b56263          	bltu	a0,a1,ffffffffc0201a56 <vprintfmt+0xbc>
ffffffffc0201a16:	058a                	slli	a1,a1,0x2
ffffffffc0201a18:	95d6                	add	a1,a1,s5
ffffffffc0201a1a:	4194                	lw	a3,0(a1)
ffffffffc0201a1c:	96d6                	add	a3,a3,s5
ffffffffc0201a1e:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201a20:	70e6                	ld	ra,120(sp)
ffffffffc0201a22:	7446                	ld	s0,112(sp)
ffffffffc0201a24:	74a6                	ld	s1,104(sp)
ffffffffc0201a26:	7906                	ld	s2,96(sp)
ffffffffc0201a28:	69e6                	ld	s3,88(sp)
ffffffffc0201a2a:	6a46                	ld	s4,80(sp)
ffffffffc0201a2c:	6aa6                	ld	s5,72(sp)
ffffffffc0201a2e:	6b06                	ld	s6,64(sp)
ffffffffc0201a30:	7be2                	ld	s7,56(sp)
ffffffffc0201a32:	7c42                	ld	s8,48(sp)
ffffffffc0201a34:	7ca2                	ld	s9,40(sp)
ffffffffc0201a36:	7d02                	ld	s10,32(sp)
ffffffffc0201a38:	6de2                	ld	s11,24(sp)
ffffffffc0201a3a:	6109                	addi	sp,sp,128
ffffffffc0201a3c:	8082                	ret
            padc = '0';
ffffffffc0201a3e:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0201a40:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a44:	846a                	mv	s0,s10
ffffffffc0201a46:	00140d13          	addi	s10,s0,1
ffffffffc0201a4a:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201a4e:	0ff5f593          	zext.b	a1,a1
ffffffffc0201a52:	fcb572e3          	bgeu	a0,a1,ffffffffc0201a16 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201a56:	85a6                	mv	a1,s1
ffffffffc0201a58:	02500513          	li	a0,37
ffffffffc0201a5c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201a5e:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201a62:	8d22                	mv	s10,s0
ffffffffc0201a64:	f73788e3          	beq	a5,s3,ffffffffc02019d4 <vprintfmt+0x3a>
ffffffffc0201a68:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201a6c:	1d7d                	addi	s10,s10,-1
ffffffffc0201a6e:	ff379de3          	bne	a5,s3,ffffffffc0201a68 <vprintfmt+0xce>
ffffffffc0201a72:	b78d                	j	ffffffffc02019d4 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201a74:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201a78:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201a7c:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201a7e:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201a82:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201a86:	02d86463          	bltu	a6,a3,ffffffffc0201aae <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201a8a:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201a8e:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201a92:	0186873b          	addw	a4,a3,s8
ffffffffc0201a96:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201a9a:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201a9c:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201aa0:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201aa2:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201aa6:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201aaa:	fed870e3          	bgeu	a6,a3,ffffffffc0201a8a <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201aae:	f40ddce3          	bgez	s11,ffffffffc0201a06 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201ab2:	8de2                	mv	s11,s8
ffffffffc0201ab4:	5c7d                	li	s8,-1
ffffffffc0201ab6:	bf81                	j	ffffffffc0201a06 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201ab8:	fffdc693          	not	a3,s11
ffffffffc0201abc:	96fd                	srai	a3,a3,0x3f
ffffffffc0201abe:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ac2:	00144603          	lbu	a2,1(s0)
ffffffffc0201ac6:	2d81                	sext.w	s11,s11
ffffffffc0201ac8:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201aca:	bf35                	j	ffffffffc0201a06 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201acc:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ad0:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201ad4:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ad6:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201ad8:	bfd9                	j	ffffffffc0201aae <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201ada:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201adc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201ae0:	01174463          	blt	a4,a7,ffffffffc0201ae8 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201ae4:	1a088e63          	beqz	a7,ffffffffc0201ca0 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201ae8:	000a3603          	ld	a2,0(s4)
ffffffffc0201aec:	46c1                	li	a3,16
ffffffffc0201aee:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201af0:	2781                	sext.w	a5,a5
ffffffffc0201af2:	876e                	mv	a4,s11
ffffffffc0201af4:	85a6                	mv	a1,s1
ffffffffc0201af6:	854a                	mv	a0,s2
ffffffffc0201af8:	e37ff0ef          	jal	ra,ffffffffc020192e <printnum>
            break;
ffffffffc0201afc:	bde1                	j	ffffffffc02019d4 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201afe:	000a2503          	lw	a0,0(s4)
ffffffffc0201b02:	85a6                	mv	a1,s1
ffffffffc0201b04:	0a21                	addi	s4,s4,8
ffffffffc0201b06:	9902                	jalr	s2
            break;
ffffffffc0201b08:	b5f1                	j	ffffffffc02019d4 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201b0a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b0c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b10:	01174463          	blt	a4,a7,ffffffffc0201b18 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201b14:	18088163          	beqz	a7,ffffffffc0201c96 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201b18:	000a3603          	ld	a2,0(s4)
ffffffffc0201b1c:	46a9                	li	a3,10
ffffffffc0201b1e:	8a2e                	mv	s4,a1
ffffffffc0201b20:	bfc1                	j	ffffffffc0201af0 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b22:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201b26:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b28:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201b2a:	bdf1                	j	ffffffffc0201a06 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201b2c:	85a6                	mv	a1,s1
ffffffffc0201b2e:	02500513          	li	a0,37
ffffffffc0201b32:	9902                	jalr	s2
            break;
ffffffffc0201b34:	b545                	j	ffffffffc02019d4 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b36:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201b3a:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b3c:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201b3e:	b5e1                	j	ffffffffc0201a06 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201b40:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201b42:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201b46:	01174463          	blt	a4,a7,ffffffffc0201b4e <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201b4a:	14088163          	beqz	a7,ffffffffc0201c8c <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201b4e:	000a3603          	ld	a2,0(s4)
ffffffffc0201b52:	46a1                	li	a3,8
ffffffffc0201b54:	8a2e                	mv	s4,a1
ffffffffc0201b56:	bf69                	j	ffffffffc0201af0 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201b58:	03000513          	li	a0,48
ffffffffc0201b5c:	85a6                	mv	a1,s1
ffffffffc0201b5e:	e03e                	sd	a5,0(sp)
ffffffffc0201b60:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201b62:	85a6                	mv	a1,s1
ffffffffc0201b64:	07800513          	li	a0,120
ffffffffc0201b68:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b6a:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201b6c:	6782                	ld	a5,0(sp)
ffffffffc0201b6e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201b70:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201b74:	bfb5                	j	ffffffffc0201af0 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201b76:	000a3403          	ld	s0,0(s4)
ffffffffc0201b7a:	008a0713          	addi	a4,s4,8
ffffffffc0201b7e:	e03a                	sd	a4,0(sp)
ffffffffc0201b80:	14040263          	beqz	s0,ffffffffc0201cc4 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201b84:	0fb05763          	blez	s11,ffffffffc0201c72 <vprintfmt+0x2d8>
ffffffffc0201b88:	02d00693          	li	a3,45
ffffffffc0201b8c:	0cd79163          	bne	a5,a3,ffffffffc0201c4e <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201b90:	00044783          	lbu	a5,0(s0)
ffffffffc0201b94:	0007851b          	sext.w	a0,a5
ffffffffc0201b98:	cf85                	beqz	a5,ffffffffc0201bd0 <vprintfmt+0x236>
ffffffffc0201b9a:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201b9e:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201ba2:	000c4563          	bltz	s8,ffffffffc0201bac <vprintfmt+0x212>
ffffffffc0201ba6:	3c7d                	addiw	s8,s8,-1
ffffffffc0201ba8:	036c0263          	beq	s8,s6,ffffffffc0201bcc <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201bac:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201bae:	0e0c8e63          	beqz	s9,ffffffffc0201caa <vprintfmt+0x310>
ffffffffc0201bb2:	3781                	addiw	a5,a5,-32
ffffffffc0201bb4:	0ef47b63          	bgeu	s0,a5,ffffffffc0201caa <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201bb8:	03f00513          	li	a0,63
ffffffffc0201bbc:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201bbe:	000a4783          	lbu	a5,0(s4)
ffffffffc0201bc2:	3dfd                	addiw	s11,s11,-1
ffffffffc0201bc4:	0a05                	addi	s4,s4,1
ffffffffc0201bc6:	0007851b          	sext.w	a0,a5
ffffffffc0201bca:	ffe1                	bnez	a5,ffffffffc0201ba2 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201bcc:	01b05963          	blez	s11,ffffffffc0201bde <vprintfmt+0x244>
ffffffffc0201bd0:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201bd2:	85a6                	mv	a1,s1
ffffffffc0201bd4:	02000513          	li	a0,32
ffffffffc0201bd8:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201bda:	fe0d9be3          	bnez	s11,ffffffffc0201bd0 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201bde:	6a02                	ld	s4,0(sp)
ffffffffc0201be0:	bbd5                	j	ffffffffc02019d4 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201be2:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201be4:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201be8:	01174463          	blt	a4,a7,ffffffffc0201bf0 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201bec:	08088d63          	beqz	a7,ffffffffc0201c86 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201bf0:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201bf4:	0a044d63          	bltz	s0,ffffffffc0201cae <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201bf8:	8622                	mv	a2,s0
ffffffffc0201bfa:	8a66                	mv	s4,s9
ffffffffc0201bfc:	46a9                	li	a3,10
ffffffffc0201bfe:	bdcd                	j	ffffffffc0201af0 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201c00:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c04:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201c06:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201c08:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201c0c:	8fb5                	xor	a5,a5,a3
ffffffffc0201c0e:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201c12:	02d74163          	blt	a4,a3,ffffffffc0201c34 <vprintfmt+0x29a>
ffffffffc0201c16:	00369793          	slli	a5,a3,0x3
ffffffffc0201c1a:	97de                	add	a5,a5,s7
ffffffffc0201c1c:	639c                	ld	a5,0(a5)
ffffffffc0201c1e:	cb99                	beqz	a5,ffffffffc0201c34 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201c20:	86be                	mv	a3,a5
ffffffffc0201c22:	00001617          	auipc	a2,0x1
ffffffffc0201c26:	0e660613          	addi	a2,a2,230 # ffffffffc0202d08 <best_fit_pmm_manager+0x1b0>
ffffffffc0201c2a:	85a6                	mv	a1,s1
ffffffffc0201c2c:	854a                	mv	a0,s2
ffffffffc0201c2e:	0ce000ef          	jal	ra,ffffffffc0201cfc <printfmt>
ffffffffc0201c32:	b34d                	j	ffffffffc02019d4 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201c34:	00001617          	auipc	a2,0x1
ffffffffc0201c38:	0c460613          	addi	a2,a2,196 # ffffffffc0202cf8 <best_fit_pmm_manager+0x1a0>
ffffffffc0201c3c:	85a6                	mv	a1,s1
ffffffffc0201c3e:	854a                	mv	a0,s2
ffffffffc0201c40:	0bc000ef          	jal	ra,ffffffffc0201cfc <printfmt>
ffffffffc0201c44:	bb41                	j	ffffffffc02019d4 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201c46:	00001417          	auipc	s0,0x1
ffffffffc0201c4a:	0aa40413          	addi	s0,s0,170 # ffffffffc0202cf0 <best_fit_pmm_manager+0x198>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c4e:	85e2                	mv	a1,s8
ffffffffc0201c50:	8522                	mv	a0,s0
ffffffffc0201c52:	e43e                	sd	a5,8(sp)
ffffffffc0201c54:	200000ef          	jal	ra,ffffffffc0201e54 <strnlen>
ffffffffc0201c58:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201c5c:	01b05b63          	blez	s11,ffffffffc0201c72 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201c60:	67a2                	ld	a5,8(sp)
ffffffffc0201c62:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c66:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201c68:	85a6                	mv	a1,s1
ffffffffc0201c6a:	8552                	mv	a0,s4
ffffffffc0201c6c:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201c6e:	fe0d9ce3          	bnez	s11,ffffffffc0201c66 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201c72:	00044783          	lbu	a5,0(s0)
ffffffffc0201c76:	00140a13          	addi	s4,s0,1
ffffffffc0201c7a:	0007851b          	sext.w	a0,a5
ffffffffc0201c7e:	d3a5                	beqz	a5,ffffffffc0201bde <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201c80:	05e00413          	li	s0,94
ffffffffc0201c84:	bf39                	j	ffffffffc0201ba2 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201c86:	000a2403          	lw	s0,0(s4)
ffffffffc0201c8a:	b7ad                	j	ffffffffc0201bf4 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201c8c:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c90:	46a1                	li	a3,8
ffffffffc0201c92:	8a2e                	mv	s4,a1
ffffffffc0201c94:	bdb1                	j	ffffffffc0201af0 <vprintfmt+0x156>
ffffffffc0201c96:	000a6603          	lwu	a2,0(s4)
ffffffffc0201c9a:	46a9                	li	a3,10
ffffffffc0201c9c:	8a2e                	mv	s4,a1
ffffffffc0201c9e:	bd89                	j	ffffffffc0201af0 <vprintfmt+0x156>
ffffffffc0201ca0:	000a6603          	lwu	a2,0(s4)
ffffffffc0201ca4:	46c1                	li	a3,16
ffffffffc0201ca6:	8a2e                	mv	s4,a1
ffffffffc0201ca8:	b5a1                	j	ffffffffc0201af0 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201caa:	9902                	jalr	s2
ffffffffc0201cac:	bf09                	j	ffffffffc0201bbe <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201cae:	85a6                	mv	a1,s1
ffffffffc0201cb0:	02d00513          	li	a0,45
ffffffffc0201cb4:	e03e                	sd	a5,0(sp)
ffffffffc0201cb6:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201cb8:	6782                	ld	a5,0(sp)
ffffffffc0201cba:	8a66                	mv	s4,s9
ffffffffc0201cbc:	40800633          	neg	a2,s0
ffffffffc0201cc0:	46a9                	li	a3,10
ffffffffc0201cc2:	b53d                	j	ffffffffc0201af0 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0201cc4:	03b05163          	blez	s11,ffffffffc0201ce6 <vprintfmt+0x34c>
ffffffffc0201cc8:	02d00693          	li	a3,45
ffffffffc0201ccc:	f6d79de3          	bne	a5,a3,ffffffffc0201c46 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201cd0:	00001417          	auipc	s0,0x1
ffffffffc0201cd4:	02040413          	addi	s0,s0,32 # ffffffffc0202cf0 <best_fit_pmm_manager+0x198>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201cd8:	02800793          	li	a5,40
ffffffffc0201cdc:	02800513          	li	a0,40
ffffffffc0201ce0:	00140a13          	addi	s4,s0,1
ffffffffc0201ce4:	bd6d                	j	ffffffffc0201b9e <vprintfmt+0x204>
ffffffffc0201ce6:	00001a17          	auipc	s4,0x1
ffffffffc0201cea:	00ba0a13          	addi	s4,s4,11 # ffffffffc0202cf1 <best_fit_pmm_manager+0x199>
ffffffffc0201cee:	02800513          	li	a0,40
ffffffffc0201cf2:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201cf6:	05e00413          	li	s0,94
ffffffffc0201cfa:	b565                	j	ffffffffc0201ba2 <vprintfmt+0x208>

ffffffffc0201cfc <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201cfc:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201cfe:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d02:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d04:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201d06:	ec06                	sd	ra,24(sp)
ffffffffc0201d08:	f83a                	sd	a4,48(sp)
ffffffffc0201d0a:	fc3e                	sd	a5,56(sp)
ffffffffc0201d0c:	e0c2                	sd	a6,64(sp)
ffffffffc0201d0e:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201d10:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201d12:	c89ff0ef          	jal	ra,ffffffffc020199a <vprintfmt>
}
ffffffffc0201d16:	60e2                	ld	ra,24(sp)
ffffffffc0201d18:	6161                	addi	sp,sp,80
ffffffffc0201d1a:	8082                	ret

ffffffffc0201d1c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201d1c:	715d                	addi	sp,sp,-80
ffffffffc0201d1e:	e486                	sd	ra,72(sp)
ffffffffc0201d20:	e0a6                	sd	s1,64(sp)
ffffffffc0201d22:	fc4a                	sd	s2,56(sp)
ffffffffc0201d24:	f84e                	sd	s3,48(sp)
ffffffffc0201d26:	f452                	sd	s4,40(sp)
ffffffffc0201d28:	f056                	sd	s5,32(sp)
ffffffffc0201d2a:	ec5a                	sd	s6,24(sp)
ffffffffc0201d2c:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0201d2e:	c901                	beqz	a0,ffffffffc0201d3e <readline+0x22>
ffffffffc0201d30:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0201d32:	00001517          	auipc	a0,0x1
ffffffffc0201d36:	fd650513          	addi	a0,a0,-42 # ffffffffc0202d08 <best_fit_pmm_manager+0x1b0>
ffffffffc0201d3a:	b9afe0ef          	jal	ra,ffffffffc02000d4 <cprintf>
readline(const char *prompt) {
ffffffffc0201d3e:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d40:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201d42:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201d44:	4aa9                	li	s5,10
ffffffffc0201d46:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201d48:	00004b97          	auipc	s7,0x4
ffffffffc0201d4c:	2f8b8b93          	addi	s7,s7,760 # ffffffffc0206040 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d50:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0201d54:	bf8fe0ef          	jal	ra,ffffffffc020014c <getchar>
        if (c < 0) {
ffffffffc0201d58:	00054a63          	bltz	a0,ffffffffc0201d6c <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d5c:	00a95a63          	bge	s2,a0,ffffffffc0201d70 <readline+0x54>
ffffffffc0201d60:	029a5263          	bge	s4,s1,ffffffffc0201d84 <readline+0x68>
        c = getchar();
ffffffffc0201d64:	be8fe0ef          	jal	ra,ffffffffc020014c <getchar>
        if (c < 0) {
ffffffffc0201d68:	fe055ae3          	bgez	a0,ffffffffc0201d5c <readline+0x40>
            return NULL;
ffffffffc0201d6c:	4501                	li	a0,0
ffffffffc0201d6e:	a091                	j	ffffffffc0201db2 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0201d70:	03351463          	bne	a0,s3,ffffffffc0201d98 <readline+0x7c>
ffffffffc0201d74:	e8a9                	bnez	s1,ffffffffc0201dc6 <readline+0xaa>
        c = getchar();
ffffffffc0201d76:	bd6fe0ef          	jal	ra,ffffffffc020014c <getchar>
        if (c < 0) {
ffffffffc0201d7a:	fe0549e3          	bltz	a0,ffffffffc0201d6c <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201d7e:	fea959e3          	bge	s2,a0,ffffffffc0201d70 <readline+0x54>
ffffffffc0201d82:	4481                	li	s1,0
            cputchar(c);
ffffffffc0201d84:	e42a                	sd	a0,8(sp)
ffffffffc0201d86:	b84fe0ef          	jal	ra,ffffffffc020010a <cputchar>
            buf[i ++] = c;
ffffffffc0201d8a:	6522                	ld	a0,8(sp)
ffffffffc0201d8c:	009b87b3          	add	a5,s7,s1
ffffffffc0201d90:	2485                	addiw	s1,s1,1
ffffffffc0201d92:	00a78023          	sb	a0,0(a5)
ffffffffc0201d96:	bf7d                	j	ffffffffc0201d54 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201d98:	01550463          	beq	a0,s5,ffffffffc0201da0 <readline+0x84>
ffffffffc0201d9c:	fb651ce3          	bne	a0,s6,ffffffffc0201d54 <readline+0x38>
            cputchar(c);
ffffffffc0201da0:	b6afe0ef          	jal	ra,ffffffffc020010a <cputchar>
            buf[i] = '\0';
ffffffffc0201da4:	00004517          	auipc	a0,0x4
ffffffffc0201da8:	29c50513          	addi	a0,a0,668 # ffffffffc0206040 <buf>
ffffffffc0201dac:	94aa                	add	s1,s1,a0
ffffffffc0201dae:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0201db2:	60a6                	ld	ra,72(sp)
ffffffffc0201db4:	6486                	ld	s1,64(sp)
ffffffffc0201db6:	7962                	ld	s2,56(sp)
ffffffffc0201db8:	79c2                	ld	s3,48(sp)
ffffffffc0201dba:	7a22                	ld	s4,40(sp)
ffffffffc0201dbc:	7a82                	ld	s5,32(sp)
ffffffffc0201dbe:	6b62                	ld	s6,24(sp)
ffffffffc0201dc0:	6bc2                	ld	s7,16(sp)
ffffffffc0201dc2:	6161                	addi	sp,sp,80
ffffffffc0201dc4:	8082                	ret
            cputchar(c);
ffffffffc0201dc6:	4521                	li	a0,8
ffffffffc0201dc8:	b42fe0ef          	jal	ra,ffffffffc020010a <cputchar>
            i --;
ffffffffc0201dcc:	34fd                	addiw	s1,s1,-1
ffffffffc0201dce:	b759                	j	ffffffffc0201d54 <readline+0x38>

ffffffffc0201dd0 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201dd0:	4781                	li	a5,0
ffffffffc0201dd2:	00004717          	auipc	a4,0x4
ffffffffc0201dd6:	24673703          	ld	a4,582(a4) # ffffffffc0206018 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201dda:	88ba                	mv	a7,a4
ffffffffc0201ddc:	852a                	mv	a0,a0
ffffffffc0201dde:	85be                	mv	a1,a5
ffffffffc0201de0:	863e                	mv	a2,a5
ffffffffc0201de2:	00000073          	ecall
ffffffffc0201de6:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201de8:	8082                	ret

ffffffffc0201dea <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201dea:	4781                	li	a5,0
ffffffffc0201dec:	00004717          	auipc	a4,0x4
ffffffffc0201df0:	6ac73703          	ld	a4,1708(a4) # ffffffffc0206498 <SBI_SET_TIMER>
ffffffffc0201df4:	88ba                	mv	a7,a4
ffffffffc0201df6:	852a                	mv	a0,a0
ffffffffc0201df8:	85be                	mv	a1,a5
ffffffffc0201dfa:	863e                	mv	a2,a5
ffffffffc0201dfc:	00000073          	ecall
ffffffffc0201e00:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201e02:	8082                	ret

ffffffffc0201e04 <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201e04:	4501                	li	a0,0
ffffffffc0201e06:	00004797          	auipc	a5,0x4
ffffffffc0201e0a:	20a7b783          	ld	a5,522(a5) # ffffffffc0206010 <SBI_CONSOLE_GETCHAR>
ffffffffc0201e0e:	88be                	mv	a7,a5
ffffffffc0201e10:	852a                	mv	a0,a0
ffffffffc0201e12:	85aa                	mv	a1,a0
ffffffffc0201e14:	862a                	mv	a2,a0
ffffffffc0201e16:	00000073          	ecall
ffffffffc0201e1a:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201e1c:	2501                	sext.w	a0,a0
ffffffffc0201e1e:	8082                	ret

ffffffffc0201e20 <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201e20:	4781                	li	a5,0
ffffffffc0201e22:	00004717          	auipc	a4,0x4
ffffffffc0201e26:	1fe73703          	ld	a4,510(a4) # ffffffffc0206020 <SBI_SHUTDOWN>
ffffffffc0201e2a:	88ba                	mv	a7,a4
ffffffffc0201e2c:	853e                	mv	a0,a5
ffffffffc0201e2e:	85be                	mv	a1,a5
ffffffffc0201e30:	863e                	mv	a2,a5
ffffffffc0201e32:	00000073          	ecall
ffffffffc0201e36:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201e38:	8082                	ret

ffffffffc0201e3a <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201e3a:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201e3e:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201e40:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201e42:	cb81                	beqz	a5,ffffffffc0201e52 <strlen+0x18>
        cnt ++;
ffffffffc0201e44:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201e46:	00a707b3          	add	a5,a4,a0
ffffffffc0201e4a:	0007c783          	lbu	a5,0(a5)
ffffffffc0201e4e:	fbfd                	bnez	a5,ffffffffc0201e44 <strlen+0xa>
ffffffffc0201e50:	8082                	ret
    }
    return cnt;
}
ffffffffc0201e52:	8082                	ret

ffffffffc0201e54 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201e54:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e56:	e589                	bnez	a1,ffffffffc0201e60 <strnlen+0xc>
ffffffffc0201e58:	a811                	j	ffffffffc0201e6c <strnlen+0x18>
        cnt ++;
ffffffffc0201e5a:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201e5c:	00f58863          	beq	a1,a5,ffffffffc0201e6c <strnlen+0x18>
ffffffffc0201e60:	00f50733          	add	a4,a0,a5
ffffffffc0201e64:	00074703          	lbu	a4,0(a4)
ffffffffc0201e68:	fb6d                	bnez	a4,ffffffffc0201e5a <strnlen+0x6>
ffffffffc0201e6a:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201e6c:	852e                	mv	a0,a1
ffffffffc0201e6e:	8082                	ret

ffffffffc0201e70 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e70:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e74:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e78:	cb89                	beqz	a5,ffffffffc0201e8a <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201e7a:	0505                	addi	a0,a0,1
ffffffffc0201e7c:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201e7e:	fee789e3          	beq	a5,a4,ffffffffc0201e70 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201e82:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201e86:	9d19                	subw	a0,a0,a4
ffffffffc0201e88:	8082                	ret
ffffffffc0201e8a:	4501                	li	a0,0
ffffffffc0201e8c:	bfed                	j	ffffffffc0201e86 <strcmp+0x16>

ffffffffc0201e8e <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e8e:	c20d                	beqz	a2,ffffffffc0201eb0 <strncmp+0x22>
ffffffffc0201e90:	962e                	add	a2,a2,a1
ffffffffc0201e92:	a031                	j	ffffffffc0201e9e <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0201e94:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201e96:	00e79a63          	bne	a5,a4,ffffffffc0201eaa <strncmp+0x1c>
ffffffffc0201e9a:	00b60b63          	beq	a2,a1,ffffffffc0201eb0 <strncmp+0x22>
ffffffffc0201e9e:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201ea2:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201ea4:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0201ea8:	f7f5                	bnez	a5,ffffffffc0201e94 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201eaa:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0201eae:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201eb0:	4501                	li	a0,0
ffffffffc0201eb2:	8082                	ret

ffffffffc0201eb4 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201eb4:	00054783          	lbu	a5,0(a0)
ffffffffc0201eb8:	c799                	beqz	a5,ffffffffc0201ec6 <strchr+0x12>
        if (*s == c) {
ffffffffc0201eba:	00f58763          	beq	a1,a5,ffffffffc0201ec8 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0201ebe:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0201ec2:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201ec4:	fbfd                	bnez	a5,ffffffffc0201eba <strchr+0x6>
    }
    return NULL;
ffffffffc0201ec6:	4501                	li	a0,0
}
ffffffffc0201ec8:	8082                	ret

ffffffffc0201eca <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201eca:	ca01                	beqz	a2,ffffffffc0201eda <memset+0x10>
ffffffffc0201ecc:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201ece:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201ed0:	0785                	addi	a5,a5,1
ffffffffc0201ed2:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201ed6:	fec79de3          	bne	a5,a2,ffffffffc0201ed0 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201eda:	8082                	ret
