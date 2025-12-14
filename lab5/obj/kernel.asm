
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
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
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000b1517          	auipc	a0,0xb1
ffffffffc020004e:	b4e50513          	addi	a0,a0,-1202 # ffffffffc02b0b98 <buf>
ffffffffc0200052:	000b5617          	auipc	a2,0xb5
ffffffffc0200056:	ffa60613          	addi	a2,a2,-6 # ffffffffc02b504c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	163050ef          	jal	ra,ffffffffc02059c4 <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00006597          	auipc	a1,0x6
ffffffffc0200072:	98258593          	addi	a1,a1,-1662 # ffffffffc02059f0 <etext+0x2>
ffffffffc0200076:	00006517          	auipc	a0,0x6
ffffffffc020007a:	99a50513          	addi	a0,a0,-1638 # ffffffffc0205a10 <etext+0x22>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	74c020ef          	jal	ra,ffffffffc02027d2 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	249030ef          	jal	ra,ffffffffc0203ada <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	080050ef          	jal	ra,ffffffffc0205116 <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	20c050ef          	jal	ra,ffffffffc02052ae <cpu_idle>

ffffffffc02000a6 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc02000a6:	715d                	addi	sp,sp,-80
ffffffffc02000a8:	e486                	sd	ra,72(sp)
ffffffffc02000aa:	e0a6                	sd	s1,64(sp)
ffffffffc02000ac:	fc4a                	sd	s2,56(sp)
ffffffffc02000ae:	f84e                	sd	s3,48(sp)
ffffffffc02000b0:	f452                	sd	s4,40(sp)
ffffffffc02000b2:	f056                	sd	s5,32(sp)
ffffffffc02000b4:	ec5a                	sd	s6,24(sp)
ffffffffc02000b6:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc02000b8:	c901                	beqz	a0,ffffffffc02000c8 <readline+0x22>
ffffffffc02000ba:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc02000bc:	00006517          	auipc	a0,0x6
ffffffffc02000c0:	95c50513          	addi	a0,a0,-1700 # ffffffffc0205a18 <etext+0x2a>
ffffffffc02000c4:	0d0000ef          	jal	ra,ffffffffc0200194 <cprintf>
readline(const char *prompt) {
ffffffffc02000c8:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000ca:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc02000cc:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc02000ce:	4aa9                	li	s5,10
ffffffffc02000d0:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc02000d2:	000b1b97          	auipc	s7,0xb1
ffffffffc02000d6:	ac6b8b93          	addi	s7,s7,-1338 # ffffffffc02b0b98 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	12e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	11e000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	10c000ef          	jal	ra,ffffffffc020020c <getchar>
        if (c < 0) {
ffffffffc0200104:	fe0549e3          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0200108:	fea959e3          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc020010c:	4481                	li	s1,0
            cputchar(c);
ffffffffc020010e:	e42a                	sd	a0,8(sp)
ffffffffc0200110:	0ba000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i ++] = c;
ffffffffc0200114:	6522                	ld	a0,8(sp)
ffffffffc0200116:	009b87b3          	add	a5,s7,s1
ffffffffc020011a:	2485                	addiw	s1,s1,1
ffffffffc020011c:	00a78023          	sb	a0,0(a5)
ffffffffc0200120:	bf7d                	j	ffffffffc02000de <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0200122:	01550463          	beq	a0,s5,ffffffffc020012a <readline+0x84>
ffffffffc0200126:	fb651ce3          	bne	a0,s6,ffffffffc02000de <readline+0x38>
            cputchar(c);
ffffffffc020012a:	0a0000ef          	jal	ra,ffffffffc02001ca <cputchar>
            buf[i] = '\0';
ffffffffc020012e:	000b1517          	auipc	a0,0xb1
ffffffffc0200132:	a6a50513          	addi	a0,a0,-1430 # ffffffffc02b0b98 <buf>
ffffffffc0200136:	94aa                	add	s1,s1,a0
ffffffffc0200138:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc020013c:	60a6                	ld	ra,72(sp)
ffffffffc020013e:	6486                	ld	s1,64(sp)
ffffffffc0200140:	7962                	ld	s2,56(sp)
ffffffffc0200142:	79c2                	ld	s3,48(sp)
ffffffffc0200144:	7a22                	ld	s4,40(sp)
ffffffffc0200146:	7a82                	ld	s5,32(sp)
ffffffffc0200148:	6b62                	ld	s6,24(sp)
ffffffffc020014a:	6bc2                	ld	s7,16(sp)
ffffffffc020014c:	6161                	addi	sp,sp,80
ffffffffc020014e:	8082                	ret
            cputchar(c);
ffffffffc0200150:	4521                	li	a0,8
ffffffffc0200152:	078000ef          	jal	ra,ffffffffc02001ca <cputchar>
            i --;
ffffffffc0200156:	34fd                	addiw	s1,s1,-1
ffffffffc0200158:	b759                	j	ffffffffc02000de <readline+0x38>

ffffffffc020015a <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e022                	sd	s0,0(sp)
ffffffffc020015e:	e406                	sd	ra,8(sp)
ffffffffc0200160:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc0200162:	42c000ef          	jal	ra,ffffffffc020058e <cons_putc>
    (*cnt)++;
ffffffffc0200166:	401c                	lw	a5,0(s0)
}
ffffffffc0200168:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc020016a:	2785                	addiw	a5,a5,1
ffffffffc020016c:	c01c                	sw	a5,0(s0)
}
ffffffffc020016e:	6402                	ld	s0,0(sp)
ffffffffc0200170:	0141                	addi	sp,sp,16
ffffffffc0200172:	8082                	ret

ffffffffc0200174 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc0200174:	1101                	addi	sp,sp,-32
ffffffffc0200176:	862a                	mv	a2,a0
ffffffffc0200178:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020017a:	00000517          	auipc	a0,0x0
ffffffffc020017e:	fe050513          	addi	a0,a0,-32 # ffffffffc020015a <cputch>
ffffffffc0200182:	006c                	addi	a1,sp,12
{
ffffffffc0200184:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc0200186:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc0200188:	418050ef          	jal	ra,ffffffffc02055a0 <vprintfmt>
    return cnt;
}
ffffffffc020018c:	60e2                	ld	ra,24(sp)
ffffffffc020018e:	4532                	lw	a0,12(sp)
ffffffffc0200190:	6105                	addi	sp,sp,32
ffffffffc0200192:	8082                	ret

ffffffffc0200194 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc0200194:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc020019a:	8e2a                	mv	t3,a0
ffffffffc020019c:	f42e                	sd	a1,40(sp)
ffffffffc020019e:	f832                	sd	a2,48(sp)
ffffffffc02001a0:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001a2:	00000517          	auipc	a0,0x0
ffffffffc02001a6:	fb850513          	addi	a0,a0,-72 # ffffffffc020015a <cputch>
ffffffffc02001aa:	004c                	addi	a1,sp,4
ffffffffc02001ac:	869a                	mv	a3,t1
ffffffffc02001ae:	8672                	mv	a2,t3
{
ffffffffc02001b0:	ec06                	sd	ra,24(sp)
ffffffffc02001b2:	e0ba                	sd	a4,64(sp)
ffffffffc02001b4:	e4be                	sd	a5,72(sp)
ffffffffc02001b6:	e8c2                	sd	a6,80(sp)
ffffffffc02001b8:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc02001ba:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc02001bc:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02001be:	3e2050ef          	jal	ra,ffffffffc02055a0 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc02001c2:	60e2                	ld	ra,24(sp)
ffffffffc02001c4:	4512                	lw	a0,4(sp)
ffffffffc02001c6:	6125                	addi	sp,sp,96
ffffffffc02001c8:	8082                	ret

ffffffffc02001ca <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc02001ca:	a6d1                	j	ffffffffc020058e <cons_putc>

ffffffffc02001cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc02001cc:	1101                	addi	sp,sp,-32
ffffffffc02001ce:	e822                	sd	s0,16(sp)
ffffffffc02001d0:	ec06                	sd	ra,24(sp)
ffffffffc02001d2:	e426                	sd	s1,8(sp)
ffffffffc02001d4:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc02001d6:	00054503          	lbu	a0,0(a0)
ffffffffc02001da:	c51d                	beqz	a0,ffffffffc0200208 <cputs+0x3c>
ffffffffc02001dc:	0405                	addi	s0,s0,1
ffffffffc02001de:	4485                	li	s1,1
ffffffffc02001e0:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc02001e2:	3ac000ef          	jal	ra,ffffffffc020058e <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc02001e6:	00044503          	lbu	a0,0(s0)
ffffffffc02001ea:	008487bb          	addw	a5,s1,s0
ffffffffc02001ee:	0405                	addi	s0,s0,1
ffffffffc02001f0:	f96d                	bnez	a0,ffffffffc02001e2 <cputs+0x16>
    (*cnt)++;
ffffffffc02001f2:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc02001f6:	4529                	li	a0,10
ffffffffc02001f8:	396000ef          	jal	ra,ffffffffc020058e <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc02001fc:	60e2                	ld	ra,24(sp)
ffffffffc02001fe:	8522                	mv	a0,s0
ffffffffc0200200:	6442                	ld	s0,16(sp)
ffffffffc0200202:	64a2                	ld	s1,8(sp)
ffffffffc0200204:	6105                	addi	sp,sp,32
ffffffffc0200206:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200208:	4405                	li	s0,1
ffffffffc020020a:	b7f5                	j	ffffffffc02001f6 <cputs+0x2a>

ffffffffc020020c <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020020c:	1141                	addi	sp,sp,-16
ffffffffc020020e:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc0200210:	3b2000ef          	jal	ra,ffffffffc02005c2 <cons_getc>
ffffffffc0200214:	dd75                	beqz	a0,ffffffffc0200210 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200216:	60a2                	ld	ra,8(sp)
ffffffffc0200218:	0141                	addi	sp,sp,16
ffffffffc020021a:	8082                	ret

ffffffffc020021c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020021c:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020021e:	00006517          	auipc	a0,0x6
ffffffffc0200222:	80250513          	addi	a0,a0,-2046 # ffffffffc0205a20 <etext+0x32>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00006517          	auipc	a0,0x6
ffffffffc0200238:	80c50513          	addi	a0,a0,-2036 # ffffffffc0205a40 <etext+0x52>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	7ae58593          	addi	a1,a1,1966 # ffffffffc02059ee <etext>
ffffffffc0200248:	00006517          	auipc	a0,0x6
ffffffffc020024c:	81850513          	addi	a0,a0,-2024 # ffffffffc0205a60 <etext+0x72>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000b1597          	auipc	a1,0xb1
ffffffffc0200258:	94458593          	addi	a1,a1,-1724 # ffffffffc02b0b98 <buf>
ffffffffc020025c:	00006517          	auipc	a0,0x6
ffffffffc0200260:	82450513          	addi	a0,a0,-2012 # ffffffffc0205a80 <etext+0x92>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000b5597          	auipc	a1,0xb5
ffffffffc020026c:	de458593          	addi	a1,a1,-540 # ffffffffc02b504c <end>
ffffffffc0200270:	00006517          	auipc	a0,0x6
ffffffffc0200274:	83050513          	addi	a0,a0,-2000 # ffffffffc0205aa0 <etext+0xb2>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000b5597          	auipc	a1,0xb5
ffffffffc0200280:	1cf58593          	addi	a1,a1,463 # ffffffffc02b544b <end+0x3ff>
ffffffffc0200284:	00000797          	auipc	a5,0x0
ffffffffc0200288:	dc678793          	addi	a5,a5,-570 # ffffffffc020004a <kern_init>
ffffffffc020028c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200290:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200294:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200296:	3ff5f593          	andi	a1,a1,1023
ffffffffc020029a:	95be                	add	a1,a1,a5
ffffffffc020029c:	85a9                	srai	a1,a1,0xa
ffffffffc020029e:	00006517          	auipc	a0,0x6
ffffffffc02002a2:	82250513          	addi	a0,a0,-2014 # ffffffffc0205ac0 <etext+0xd2>
}
ffffffffc02002a6:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002a8:	b5f5                	j	ffffffffc0200194 <cprintf>

ffffffffc02002aa <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002aa:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ac:	00006617          	auipc	a2,0x6
ffffffffc02002b0:	84460613          	addi	a2,a2,-1980 # ffffffffc0205af0 <etext+0x102>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00006517          	auipc	a0,0x6
ffffffffc02002bc:	85050513          	addi	a0,a0,-1968 # ffffffffc0205b08 <etext+0x11a>
{
ffffffffc02002c0:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002c2:	1cc000ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02002c6 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02002c6:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002c8:	00006617          	auipc	a2,0x6
ffffffffc02002cc:	85860613          	addi	a2,a2,-1960 # ffffffffc0205b20 <etext+0x132>
ffffffffc02002d0:	00006597          	auipc	a1,0x6
ffffffffc02002d4:	87058593          	addi	a1,a1,-1936 # ffffffffc0205b40 <etext+0x152>
ffffffffc02002d8:	00006517          	auipc	a0,0x6
ffffffffc02002dc:	87050513          	addi	a0,a0,-1936 # ffffffffc0205b48 <etext+0x15a>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00006617          	auipc	a2,0x6
ffffffffc02002ea:	87260613          	addi	a2,a2,-1934 # ffffffffc0205b58 <etext+0x16a>
ffffffffc02002ee:	00006597          	auipc	a1,0x6
ffffffffc02002f2:	89258593          	addi	a1,a1,-1902 # ffffffffc0205b80 <etext+0x192>
ffffffffc02002f6:	00006517          	auipc	a0,0x6
ffffffffc02002fa:	85250513          	addi	a0,a0,-1966 # ffffffffc0205b48 <etext+0x15a>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00006617          	auipc	a2,0x6
ffffffffc0200306:	88e60613          	addi	a2,a2,-1906 # ffffffffc0205b90 <etext+0x1a2>
ffffffffc020030a:	00006597          	auipc	a1,0x6
ffffffffc020030e:	8a658593          	addi	a1,a1,-1882 # ffffffffc0205bb0 <etext+0x1c2>
ffffffffc0200312:	00006517          	auipc	a0,0x6
ffffffffc0200316:	83650513          	addi	a0,a0,-1994 # ffffffffc0205b48 <etext+0x15a>
ffffffffc020031a:	e7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc020031e:	60a2                	ld	ra,8(sp)
ffffffffc0200320:	4501                	li	a0,0
ffffffffc0200322:	0141                	addi	sp,sp,16
ffffffffc0200324:	8082                	ret

ffffffffc0200326 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200326:	1141                	addi	sp,sp,-16
ffffffffc0200328:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc020032a:	ef3ff0ef          	jal	ra,ffffffffc020021c <print_kerninfo>
    return 0;
}
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc020033a:	f71ff0ef          	jal	ra,ffffffffc02002aa <print_stackframe>
    return 0;
}
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <kmonitor>:
{
ffffffffc0200346:	7115                	addi	sp,sp,-224
ffffffffc0200348:	ed5e                	sd	s7,152(sp)
ffffffffc020034a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020034c:	00006517          	auipc	a0,0x6
ffffffffc0200350:	87450513          	addi	a0,a0,-1932 # ffffffffc0205bc0 <etext+0x1d2>
{
ffffffffc0200354:	ed86                	sd	ra,216(sp)
ffffffffc0200356:	e9a2                	sd	s0,208(sp)
ffffffffc0200358:	e5a6                	sd	s1,200(sp)
ffffffffc020035a:	e1ca                	sd	s2,192(sp)
ffffffffc020035c:	fd4e                	sd	s3,184(sp)
ffffffffc020035e:	f952                	sd	s4,176(sp)
ffffffffc0200360:	f556                	sd	s5,168(sp)
ffffffffc0200362:	f15a                	sd	s6,160(sp)
ffffffffc0200364:	e962                	sd	s8,144(sp)
ffffffffc0200366:	e566                	sd	s9,136(sp)
ffffffffc0200368:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	e2bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020036e:	00006517          	auipc	a0,0x6
ffffffffc0200372:	87a50513          	addi	a0,a0,-1926 # ffffffffc0205be8 <etext+0x1fa>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00006c17          	auipc	s8,0x6
ffffffffc0200388:	8d4c0c13          	addi	s8,s8,-1836 # ffffffffc0205c58 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00006917          	auipc	s2,0x6
ffffffffc0200390:	88490913          	addi	s2,s2,-1916 # ffffffffc0205c10 <etext+0x222>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00006497          	auipc	s1,0x6
ffffffffc0200398:	88448493          	addi	s1,s1,-1916 # ffffffffc0205c18 <etext+0x22a>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00006b17          	auipc	s6,0x6
ffffffffc02003a2:	882b0b13          	addi	s6,s6,-1918 # ffffffffc0205c20 <etext+0x232>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	79aa0a13          	addi	s4,s4,1946 # ffffffffc0205b40 <etext+0x152>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003ae:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc02003b0:	854a                	mv	a0,s2
ffffffffc02003b2:	cf5ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc02003b6:	842a                	mv	s0,a0
ffffffffc02003b8:	dd65                	beqz	a0,ffffffffc02003b0 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003ba:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003be:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02003c0:	e1bd                	bnez	a1,ffffffffc0200426 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc02003c2:	fe0c87e3          	beqz	s9,ffffffffc02003b0 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003c6:	6582                	ld	a1,0(sp)
ffffffffc02003c8:	00006d17          	auipc	s10,0x6
ffffffffc02003cc:	890d0d13          	addi	s10,s10,-1904 # ffffffffc0205c58 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	594050ef          	jal	ra,ffffffffc020596a <strcmp>
ffffffffc02003da:	c919                	beqz	a0,ffffffffc02003f0 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003dc:	2405                	addiw	s0,s0,1
ffffffffc02003de:	0b540063          	beq	s0,s5,ffffffffc020047e <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003e2:	000d3503          	ld	a0,0(s10)
ffffffffc02003e6:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003e8:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003ea:	580050ef          	jal	ra,ffffffffc020596a <strcmp>
ffffffffc02003ee:	f57d                	bnez	a0,ffffffffc02003dc <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003f0:	00141793          	slli	a5,s0,0x1
ffffffffc02003f4:	97a2                	add	a5,a5,s0
ffffffffc02003f6:	078e                	slli	a5,a5,0x3
ffffffffc02003f8:	97e2                	add	a5,a5,s8
ffffffffc02003fa:	6b9c                	ld	a5,16(a5)
ffffffffc02003fc:	865e                	mv	a2,s7
ffffffffc02003fe:	002c                	addi	a1,sp,8
ffffffffc0200400:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200404:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc0200406:	fa0555e3          	bgez	a0,ffffffffc02003b0 <kmonitor+0x6a>
}
ffffffffc020040a:	60ee                	ld	ra,216(sp)
ffffffffc020040c:	644e                	ld	s0,208(sp)
ffffffffc020040e:	64ae                	ld	s1,200(sp)
ffffffffc0200410:	690e                	ld	s2,192(sp)
ffffffffc0200412:	79ea                	ld	s3,184(sp)
ffffffffc0200414:	7a4a                	ld	s4,176(sp)
ffffffffc0200416:	7aaa                	ld	s5,168(sp)
ffffffffc0200418:	7b0a                	ld	s6,160(sp)
ffffffffc020041a:	6bea                	ld	s7,152(sp)
ffffffffc020041c:	6c4a                	ld	s8,144(sp)
ffffffffc020041e:	6caa                	ld	s9,136(sp)
ffffffffc0200420:	6d0a                	ld	s10,128(sp)
ffffffffc0200422:	612d                	addi	sp,sp,224
ffffffffc0200424:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200426:	8526                	mv	a0,s1
ffffffffc0200428:	586050ef          	jal	ra,ffffffffc02059ae <strchr>
ffffffffc020042c:	c901                	beqz	a0,ffffffffc020043c <kmonitor+0xf6>
ffffffffc020042e:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc0200432:	00040023          	sb	zero,0(s0)
ffffffffc0200436:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200438:	d5c9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc020043a:	b7f5                	j	ffffffffc0200426 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc020043c:	00044783          	lbu	a5,0(s0)
ffffffffc0200440:	d3c9                	beqz	a5,ffffffffc02003c2 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc0200442:	033c8963          	beq	s9,s3,ffffffffc0200474 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc0200446:	003c9793          	slli	a5,s9,0x3
ffffffffc020044a:	0118                	addi	a4,sp,128
ffffffffc020044c:	97ba                	add	a5,a5,a4
ffffffffc020044e:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200452:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200456:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200458:	e591                	bnez	a1,ffffffffc0200464 <kmonitor+0x11e>
ffffffffc020045a:	b7b5                	j	ffffffffc02003c6 <kmonitor+0x80>
ffffffffc020045c:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200462:	d1a5                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200464:	8526                	mv	a0,s1
ffffffffc0200466:	548050ef          	jal	ra,ffffffffc02059ae <strchr>
ffffffffc020046a:	d96d                	beqz	a0,ffffffffc020045c <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046c:	00044583          	lbu	a1,0(s0)
ffffffffc0200470:	d9a9                	beqz	a1,ffffffffc02003c2 <kmonitor+0x7c>
ffffffffc0200472:	bf55                	j	ffffffffc0200426 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200474:	45c1                	li	a1,16
ffffffffc0200476:	855a                	mv	a0,s6
ffffffffc0200478:	d1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020047c:	b7e9                	j	ffffffffc0200446 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020047e:	6582                	ld	a1,0(sp)
ffffffffc0200480:	00005517          	auipc	a0,0x5
ffffffffc0200484:	7c050513          	addi	a0,a0,1984 # ffffffffc0205c40 <etext+0x252>
ffffffffc0200488:	d0dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc020048c:	b715                	j	ffffffffc02003b0 <kmonitor+0x6a>

ffffffffc020048e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020048e:	000b5317          	auipc	t1,0xb5
ffffffffc0200492:	b3230313          	addi	t1,t1,-1230 # ffffffffc02b4fc0 <is_panic>
ffffffffc0200496:	00033e03          	ld	t3,0(t1)
{
ffffffffc020049a:	715d                	addi	sp,sp,-80
ffffffffc020049c:	ec06                	sd	ra,24(sp)
ffffffffc020049e:	e822                	sd	s0,16(sp)
ffffffffc02004a0:	f436                	sd	a3,40(sp)
ffffffffc02004a2:	f83a                	sd	a4,48(sp)
ffffffffc02004a4:	fc3e                	sd	a5,56(sp)
ffffffffc02004a6:	e0c2                	sd	a6,64(sp)
ffffffffc02004a8:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc02004aa:	020e1a63          	bnez	t3,ffffffffc02004de <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02004ae:	4785                	li	a5,1
ffffffffc02004b0:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc02004b4:	8432                	mv	s0,a2
ffffffffc02004b6:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004b8:	862e                	mv	a2,a1
ffffffffc02004ba:	85aa                	mv	a1,a0
ffffffffc02004bc:	00005517          	auipc	a0,0x5
ffffffffc02004c0:	7e450513          	addi	a0,a0,2020 # ffffffffc0205ca0 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00007517          	auipc	a0,0x7
ffffffffc02004d6:	91e50513          	addi	a0,a0,-1762 # ffffffffc0206df0 <default_pmm_manager+0x578>
ffffffffc02004da:	cbbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02004de:	4501                	li	a0,0
ffffffffc02004e0:	4581                	li	a1,0
ffffffffc02004e2:	4601                	li	a2,0
ffffffffc02004e4:	48a1                	li	a7,8
ffffffffc02004e6:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc02004ea:	4ca000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	e57ff0ef          	jal	ra,ffffffffc0200346 <kmonitor>
    while (1)
ffffffffc02004f4:	bfed                	j	ffffffffc02004ee <__panic+0x60>

ffffffffc02004f6 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc02004f6:	715d                	addi	sp,sp,-80
ffffffffc02004f8:	832e                	mv	t1,a1
ffffffffc02004fa:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02004fc:	85aa                	mv	a1,a0
{
ffffffffc02004fe:	8432                	mv	s0,a2
ffffffffc0200500:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200502:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200504:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200506:	00005517          	auipc	a0,0x5
ffffffffc020050a:	7ba50513          	addi	a0,a0,1978 # ffffffffc0205cc0 <commands+0x68>
{
ffffffffc020050e:	ec06                	sd	ra,24(sp)
ffffffffc0200510:	f436                	sd	a3,40(sp)
ffffffffc0200512:	f83a                	sd	a4,48(sp)
ffffffffc0200514:	e0c2                	sd	a6,64(sp)
ffffffffc0200516:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0200518:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020051a:	c7bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020051e:	65a2                	ld	a1,8(sp)
ffffffffc0200520:	8522                	mv	a0,s0
ffffffffc0200522:	c53ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc0200526:	00007517          	auipc	a0,0x7
ffffffffc020052a:	8ca50513          	addi	a0,a0,-1846 # ffffffffc0206df0 <default_pmm_manager+0x578>
ffffffffc020052e:	c67ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);
}
ffffffffc0200532:	60e2                	ld	ra,24(sp)
ffffffffc0200534:	6442                	ld	s0,16(sp)
ffffffffc0200536:	6161                	addi	sp,sp,80
ffffffffc0200538:	8082                	ret

ffffffffc020053a <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc020053a:	67e1                	lui	a5,0x18
ffffffffc020053c:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd580>
ffffffffc0200540:	000b5717          	auipc	a4,0xb5
ffffffffc0200544:	a8f73823          	sd	a5,-1392(a4) # ffffffffc02b4fd0 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200548:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020054c:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020054e:	953e                	add	a0,a0,a5
ffffffffc0200550:	4601                	li	a2,0
ffffffffc0200552:	4881                	li	a7,0
ffffffffc0200554:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200558:	02000793          	li	a5,32
ffffffffc020055c:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200560:	00005517          	auipc	a0,0x5
ffffffffc0200564:	78050513          	addi	a0,a0,1920 # ffffffffc0205ce0 <commands+0x88>
    ticks = 0;
ffffffffc0200568:	000b5797          	auipc	a5,0xb5
ffffffffc020056c:	a607b023          	sd	zero,-1440(a5) # ffffffffc02b4fc8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200570:	b115                	j	ffffffffc0200194 <cprintf>

ffffffffc0200572 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200572:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200576:	000b5797          	auipc	a5,0xb5
ffffffffc020057a:	a5a7b783          	ld	a5,-1446(a5) # ffffffffc02b4fd0 <timebase>
ffffffffc020057e:	953e                	add	a0,a0,a5
ffffffffc0200580:	4581                	li	a1,0
ffffffffc0200582:	4601                	li	a2,0
ffffffffc0200584:	4881                	li	a7,0
ffffffffc0200586:	00000073          	ecall
ffffffffc020058a:	8082                	ret

ffffffffc020058c <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc020058c:	8082                	ret

ffffffffc020058e <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020058e:	100027f3          	csrr	a5,sstatus
ffffffffc0200592:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200594:	0ff57513          	zext.b	a0,a0
ffffffffc0200598:	e799                	bnez	a5,ffffffffc02005a6 <cons_putc+0x18>
ffffffffc020059a:	4581                	li	a1,0
ffffffffc020059c:	4601                	li	a2,0
ffffffffc020059e:	4885                	li	a7,1
ffffffffc02005a0:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc02005a4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02005a6:	1101                	addi	sp,sp,-32
ffffffffc02005a8:	ec06                	sd	ra,24(sp)
ffffffffc02005aa:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02005ac:	408000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005b0:	6522                	ld	a0,8(sp)
ffffffffc02005b2:	4581                	li	a1,0
ffffffffc02005b4:	4601                	li	a2,0
ffffffffc02005b6:	4885                	li	a7,1
ffffffffc02005b8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02005bc:	60e2                	ld	ra,24(sp)
ffffffffc02005be:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc02005c0:	a6fd                	j	ffffffffc02009ae <intr_enable>

ffffffffc02005c2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02005c2:	100027f3          	csrr	a5,sstatus
ffffffffc02005c6:	8b89                	andi	a5,a5,2
ffffffffc02005c8:	eb89                	bnez	a5,ffffffffc02005da <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02005ca:	4501                	li	a0,0
ffffffffc02005cc:	4581                	li	a1,0
ffffffffc02005ce:	4601                	li	a2,0
ffffffffc02005d0:	4889                	li	a7,2
ffffffffc02005d2:	00000073          	ecall
ffffffffc02005d6:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc02005d8:	8082                	ret
int cons_getc(void) {
ffffffffc02005da:	1101                	addi	sp,sp,-32
ffffffffc02005dc:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc02005de:	3d6000ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02005e2:	4501                	li	a0,0
ffffffffc02005e4:	4581                	li	a1,0
ffffffffc02005e6:	4601                	li	a2,0
ffffffffc02005e8:	4889                	li	a7,2
ffffffffc02005ea:	00000073          	ecall
ffffffffc02005ee:	2501                	sext.w	a0,a0
ffffffffc02005f0:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02005f2:	3bc000ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc02005f6:	60e2                	ld	ra,24(sp)
ffffffffc02005f8:	6522                	ld	a0,8(sp)
ffffffffc02005fa:	6105                	addi	sp,sp,32
ffffffffc02005fc:	8082                	ret

ffffffffc02005fe <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02005fe:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200600:	00005517          	auipc	a0,0x5
ffffffffc0200604:	70050513          	addi	a0,a0,1792 # ffffffffc0205d00 <commands+0xa8>
void dtb_init(void) {
ffffffffc0200608:	fc86                	sd	ra,120(sp)
ffffffffc020060a:	f8a2                	sd	s0,112(sp)
ffffffffc020060c:	e8d2                	sd	s4,80(sp)
ffffffffc020060e:	f4a6                	sd	s1,104(sp)
ffffffffc0200610:	f0ca                	sd	s2,96(sp)
ffffffffc0200612:	ecce                	sd	s3,88(sp)
ffffffffc0200614:	e4d6                	sd	s5,72(sp)
ffffffffc0200616:	e0da                	sd	s6,64(sp)
ffffffffc0200618:	fc5e                	sd	s7,56(sp)
ffffffffc020061a:	f862                	sd	s8,48(sp)
ffffffffc020061c:	f466                	sd	s9,40(sp)
ffffffffc020061e:	f06a                	sd	s10,32(sp)
ffffffffc0200620:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200622:	b73ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200626:	0000b597          	auipc	a1,0xb
ffffffffc020062a:	9da5b583          	ld	a1,-1574(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020062e:	00005517          	auipc	a0,0x5
ffffffffc0200632:	6e250513          	addi	a0,a0,1762 # ffffffffc0205d10 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	6dc50513          	addi	a0,a0,1756 # ffffffffc0205d20 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	6e450513          	addi	a0,a0,1764 # ffffffffc0205d38 <commands+0xe0>
    if (boot_dtb == 0) {
ffffffffc020065c:	120a0463          	beqz	s4,ffffffffc0200784 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200660:	57f5                	li	a5,-3
ffffffffc0200662:	07fa                	slli	a5,a5,0x1e
ffffffffc0200664:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200668:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020066e:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200670:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200674:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200678:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020067c:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200680:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200686:	8ec9                	or	a3,a3,a0
ffffffffc0200688:	0087979b          	slliw	a5,a5,0x8
ffffffffc020068c:	1b7d                	addi	s6,s6,-1
ffffffffc020068e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200692:	8dd5                	or	a1,a1,a3
ffffffffc0200694:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200696:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020069a:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe2aea1>
ffffffffc02006a0:	10f59163          	bne	a1,a5,ffffffffc02007a2 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02006a4:	471c                	lw	a5,8(a4)
ffffffffc02006a6:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02006a8:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006aa:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02006ae:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02006b2:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c2:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c6:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ca:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ce:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d2:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d4:	01146433          	or	s0,s0,a7
ffffffffc02006d8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02006dc:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006e0:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006e2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006e6:	8c49                	or	s0,s0,a0
ffffffffc02006e8:	0166f6b3          	and	a3,a3,s6
ffffffffc02006ec:	00ca6a33          	or	s4,s4,a2
ffffffffc02006f0:	0167f7b3          	and	a5,a5,s6
ffffffffc02006f4:	8c55                	or	s0,s0,a3
ffffffffc02006f6:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fa:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02006fc:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02006fe:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200700:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200704:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200706:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200708:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020070c:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020070e:	00005917          	auipc	s2,0x5
ffffffffc0200712:	67a90913          	addi	s2,s2,1658 # ffffffffc0205d88 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	66448493          	addi	s1,s1,1636 # ffffffffc0205d80 <commands+0x128>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200724:	000a2703          	lw	a4,0(s4)
ffffffffc0200728:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020072c:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200730:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200734:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200738:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200740:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200742:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200746:	0087171b          	slliw	a4,a4,0x8
ffffffffc020074a:	8fd5                	or	a5,a5,a3
ffffffffc020074c:	00eb7733          	and	a4,s6,a4
ffffffffc0200750:	8fd9                	or	a5,a5,a4
ffffffffc0200752:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200754:	09778c63          	beq	a5,s7,ffffffffc02007ec <dtb_init+0x1ee>
ffffffffc0200758:	00fbea63          	bltu	s7,a5,ffffffffc020076c <dtb_init+0x16e>
ffffffffc020075c:	07a78663          	beq	a5,s10,ffffffffc02007c8 <dtb_init+0x1ca>
ffffffffc0200760:	4709                	li	a4,2
ffffffffc0200762:	00e79763          	bne	a5,a4,ffffffffc0200770 <dtb_init+0x172>
ffffffffc0200766:	4c81                	li	s9,0
ffffffffc0200768:	8a56                	mv	s4,s5
ffffffffc020076a:	bf6d                	j	ffffffffc0200724 <dtb_init+0x126>
ffffffffc020076c:	ffb78ee3          	beq	a5,s11,ffffffffc0200768 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc0200770:	00005517          	auipc	a0,0x5
ffffffffc0200774:	69050513          	addi	a0,a0,1680 # ffffffffc0205e00 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	6bc50513          	addi	a0,a0,1724 # ffffffffc0205e38 <commands+0x1e0>
}
ffffffffc0200784:	7446                	ld	s0,112(sp)
ffffffffc0200786:	70e6                	ld	ra,120(sp)
ffffffffc0200788:	74a6                	ld	s1,104(sp)
ffffffffc020078a:	7906                	ld	s2,96(sp)
ffffffffc020078c:	69e6                	ld	s3,88(sp)
ffffffffc020078e:	6a46                	ld	s4,80(sp)
ffffffffc0200790:	6aa6                	ld	s5,72(sp)
ffffffffc0200792:	6b06                	ld	s6,64(sp)
ffffffffc0200794:	7be2                	ld	s7,56(sp)
ffffffffc0200796:	7c42                	ld	s8,48(sp)
ffffffffc0200798:	7ca2                	ld	s9,40(sp)
ffffffffc020079a:	7d02                	ld	s10,32(sp)
ffffffffc020079c:	6de2                	ld	s11,24(sp)
ffffffffc020079e:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02007a0:	bad5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc02007a2:	7446                	ld	s0,112(sp)
ffffffffc02007a4:	70e6                	ld	ra,120(sp)
ffffffffc02007a6:	74a6                	ld	s1,104(sp)
ffffffffc02007a8:	7906                	ld	s2,96(sp)
ffffffffc02007aa:	69e6                	ld	s3,88(sp)
ffffffffc02007ac:	6a46                	ld	s4,80(sp)
ffffffffc02007ae:	6aa6                	ld	s5,72(sp)
ffffffffc02007b0:	6b06                	ld	s6,64(sp)
ffffffffc02007b2:	7be2                	ld	s7,56(sp)
ffffffffc02007b4:	7c42                	ld	s8,48(sp)
ffffffffc02007b6:	7ca2                	ld	s9,40(sp)
ffffffffc02007b8:	7d02                	ld	s10,32(sp)
ffffffffc02007ba:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007bc:	00005517          	auipc	a0,0x5
ffffffffc02007c0:	59c50513          	addi	a0,a0,1436 # ffffffffc0205d58 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	158050ef          	jal	ra,ffffffffc0205922 <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	1b0050ef          	jal	ra,ffffffffc0205988 <strncmp>
ffffffffc02007dc:	e111                	bnez	a0,ffffffffc02007e0 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc02007de:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc02007e0:	0a91                	addi	s5,s5,4
ffffffffc02007e2:	9ad2                	add	s5,s5,s4
ffffffffc02007e4:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007e8:	8a56                	mv	s4,s5
ffffffffc02007ea:	bf2d                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007ec:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007f0:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007f4:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02007f8:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007fc:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200800:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200804:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200808:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200810:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200814:	00eaeab3          	or	s5,s5,a4
ffffffffc0200818:	00fb77b3          	and	a5,s6,a5
ffffffffc020081c:	00faeab3          	or	s5,s5,a5
ffffffffc0200820:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200822:	000c9c63          	bnez	s9,ffffffffc020083a <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200826:	1a82                	slli	s5,s5,0x20
ffffffffc0200828:	00368793          	addi	a5,a3,3
ffffffffc020082c:	020ada93          	srli	s5,s5,0x20
ffffffffc0200830:	9abe                	add	s5,s5,a5
ffffffffc0200832:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200836:	8a56                	mv	s4,s5
ffffffffc0200838:	b5f5                	j	ffffffffc0200724 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020083a:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020083e:	85ca                	mv	a1,s2
ffffffffc0200840:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0187971b          	slliw	a4,a5,0x18
ffffffffc020084e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200852:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200856:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200858:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020085c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200860:	8d59                	or	a0,a0,a4
ffffffffc0200862:	00fb77b3          	and	a5,s6,a5
ffffffffc0200866:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200868:	1502                	slli	a0,a0,0x20
ffffffffc020086a:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020086c:	9522                	add	a0,a0,s0
ffffffffc020086e:	0fc050ef          	jal	ra,ffffffffc020596a <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	50e50513          	addi	a0,a0,1294 # ffffffffc0205d90 <commands+0x138>
           fdt32_to_cpu(x >> 32);
ffffffffc020088a:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020088e:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc0200892:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200896:	0187de1b          	srliw	t3,a5,0x18
ffffffffc020089a:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020089e:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008a2:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008a6:	0187d693          	srli	a3,a5,0x18
ffffffffc02008aa:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02008ae:	0087579b          	srliw	a5,a4,0x8
ffffffffc02008b2:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008b6:	0106561b          	srliw	a2,a2,0x10
ffffffffc02008ba:	010f6f33          	or	t5,t5,a6
ffffffffc02008be:	0187529b          	srliw	t0,a4,0x18
ffffffffc02008c2:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008c6:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008ca:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008ce:	0186f6b3          	and	a3,a3,s8
ffffffffc02008d2:	01859e1b          	slliw	t3,a1,0x18
ffffffffc02008d6:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008da:	0107581b          	srliw	a6,a4,0x10
ffffffffc02008de:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02008e2:	8361                	srli	a4,a4,0x18
ffffffffc02008e4:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02008e8:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02008ec:	01e6e6b3          	or	a3,a3,t5
ffffffffc02008f0:	00cb7633          	and	a2,s6,a2
ffffffffc02008f4:	0088181b          	slliw	a6,a6,0x8
ffffffffc02008f8:	0085959b          	slliw	a1,a1,0x8
ffffffffc02008fc:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200900:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200904:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200908:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020090c:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200910:	011b78b3          	and	a7,s6,a7
ffffffffc0200914:	005eeeb3          	or	t4,t4,t0
ffffffffc0200918:	00c6e733          	or	a4,a3,a2
ffffffffc020091c:	006c6c33          	or	s8,s8,t1
ffffffffc0200920:	010b76b3          	and	a3,s6,a6
ffffffffc0200924:	00bb7b33          	and	s6,s6,a1
ffffffffc0200928:	01d7e7b3          	or	a5,a5,t4
ffffffffc020092c:	016c6b33          	or	s6,s8,s6
ffffffffc0200930:	01146433          	or	s0,s0,a7
ffffffffc0200934:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200936:	1702                	slli	a4,a4,0x20
ffffffffc0200938:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093a:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020093c:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020093e:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200940:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200944:	0167eb33          	or	s6,a5,s6
ffffffffc0200948:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc020094a:	84bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020094e:	85a2                	mv	a1,s0
ffffffffc0200950:	00005517          	auipc	a0,0x5
ffffffffc0200954:	46050513          	addi	a0,a0,1120 # ffffffffc0205db0 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	46650513          	addi	a0,a0,1126 # ffffffffc0205dc8 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	47450513          	addi	a0,a0,1140 # ffffffffc0205de8 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	4b850513          	addi	a0,a0,1208 # ffffffffc0205e38 <commands+0x1e0>
        memory_base = mem_base;
ffffffffc0200988:	000b4797          	auipc	a5,0xb4
ffffffffc020098c:	6487b823          	sd	s0,1616(a5) # ffffffffc02b4fd8 <memory_base>
        memory_size = mem_size;
ffffffffc0200990:	000b4797          	auipc	a5,0xb4
ffffffffc0200994:	6567b823          	sd	s6,1616(a5) # ffffffffc02b4fe0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200998:	b3f5                	j	ffffffffc0200784 <dtb_init+0x186>

ffffffffc020099a <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc020099a:	000b4517          	auipc	a0,0xb4
ffffffffc020099e:	63e53503          	ld	a0,1598(a0) # ffffffffc02b4fd8 <memory_base>
ffffffffc02009a2:	8082                	ret

ffffffffc02009a4 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02009a4:	000b4517          	auipc	a0,0xb4
ffffffffc02009a8:	63c53503          	ld	a0,1596(a0) # ffffffffc02b4fe0 <memory_size>
ffffffffc02009ac:	8082                	ret

ffffffffc02009ae <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ae:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009ba:	8082                	ret

ffffffffc02009bc <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009bc:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c0:	00000797          	auipc	a5,0x0
ffffffffc02009c4:	54078793          	addi	a5,a5,1344 # ffffffffc0200f00 <__alltraps>
ffffffffc02009c8:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009cc:	000407b7          	lui	a5,0x40
ffffffffc02009d0:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d4:	8082                	ret

ffffffffc02009d6 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009d6:	610c                	ld	a1,0(a0)
{
ffffffffc02009d8:	1141                	addi	sp,sp,-16
ffffffffc02009da:	e022                	sd	s0,0(sp)
ffffffffc02009dc:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009de:	00005517          	auipc	a0,0x5
ffffffffc02009e2:	47250513          	addi	a0,a0,1138 # ffffffffc0205e50 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	47a50513          	addi	a0,a0,1146 # ffffffffc0205e68 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	48450513          	addi	a0,a0,1156 # ffffffffc0205e80 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	48e50513          	addi	a0,a0,1166 # ffffffffc0205e98 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	49850513          	addi	a0,a0,1176 # ffffffffc0205eb0 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	4a250513          	addi	a0,a0,1186 # ffffffffc0205ec8 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	4ac50513          	addi	a0,a0,1196 # ffffffffc0205ee0 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	4b650513          	addi	a0,a0,1206 # ffffffffc0205ef8 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	4c050513          	addi	a0,a0,1216 # ffffffffc0205f10 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	4ca50513          	addi	a0,a0,1226 # ffffffffc0205f28 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	4d450513          	addi	a0,a0,1236 # ffffffffc0205f40 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	4de50513          	addi	a0,a0,1246 # ffffffffc0205f58 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	4e850513          	addi	a0,a0,1256 # ffffffffc0205f70 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	4f250513          	addi	a0,a0,1266 # ffffffffc0205f88 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	4fc50513          	addi	a0,a0,1276 # ffffffffc0205fa0 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	50650513          	addi	a0,a0,1286 # ffffffffc0205fb8 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	51050513          	addi	a0,a0,1296 # ffffffffc0205fd0 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	51a50513          	addi	a0,a0,1306 # ffffffffc0205fe8 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	52450513          	addi	a0,a0,1316 # ffffffffc0206000 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	52e50513          	addi	a0,a0,1326 # ffffffffc0206018 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	53850513          	addi	a0,a0,1336 # ffffffffc0206030 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	54250513          	addi	a0,a0,1346 # ffffffffc0206048 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	54c50513          	addi	a0,a0,1356 # ffffffffc0206060 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	55650513          	addi	a0,a0,1366 # ffffffffc0206078 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	56050513          	addi	a0,a0,1376 # ffffffffc0206090 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	56a50513          	addi	a0,a0,1386 # ffffffffc02060a8 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	57450513          	addi	a0,a0,1396 # ffffffffc02060c0 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	57e50513          	addi	a0,a0,1406 # ffffffffc02060d8 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	58850513          	addi	a0,a0,1416 # ffffffffc02060f0 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	59250513          	addi	a0,a0,1426 # ffffffffc0206108 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	59c50513          	addi	a0,a0,1436 # ffffffffc0206120 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	5a250513          	addi	a0,a0,1442 # ffffffffc0206138 <commands+0x4e0>
}
ffffffffc0200b9e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba0:	df4ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200ba4 <print_trapframe>:
{
ffffffffc0200ba4:	1141                	addi	sp,sp,-16
ffffffffc0200ba6:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200ba8:	85aa                	mv	a1,a0
{
ffffffffc0200baa:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	00005517          	auipc	a0,0x5
ffffffffc0200bb0:	5a450513          	addi	a0,a0,1444 # ffffffffc0206150 <commands+0x4f8>
{
ffffffffc0200bb4:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb6:	ddeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bba:	8522                	mv	a0,s0
ffffffffc0200bbc:	e1bff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc0:	10043583          	ld	a1,256(s0)
ffffffffc0200bc4:	00005517          	auipc	a0,0x5
ffffffffc0200bc8:	5a450513          	addi	a0,a0,1444 # ffffffffc0206168 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	5ac50513          	addi	a0,a0,1452 # ffffffffc0206180 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	5b450513          	addi	a0,a0,1460 # ffffffffc0206198 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	5b050513          	addi	a0,a0,1456 # ffffffffc02061a8 <commands+0x550>
}
ffffffffc0200c00:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c02:	d92ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200c06 <interrupt_handler>:
extern struct mm_struct *check_mm_struct;
volatile size_t num = 0;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c06:	11853783          	ld	a5,280(a0)
ffffffffc0200c0a:	472d                	li	a4,11
ffffffffc0200c0c:	0786                	slli	a5,a5,0x1
ffffffffc0200c0e:	8385                	srli	a5,a5,0x1
ffffffffc0200c10:	08f76463          	bltu	a4,a5,ffffffffc0200c98 <interrupt_handler+0x92>
ffffffffc0200c14:	00005717          	auipc	a4,0x5
ffffffffc0200c18:	68c70713          	addi	a4,a4,1676 # ffffffffc02062a0 <commands+0x648>
ffffffffc0200c1c:	078a                	slli	a5,a5,0x2
ffffffffc0200c1e:	97ba                	add	a5,a5,a4
ffffffffc0200c20:	439c                	lw	a5,0(a5)
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c26:	00005517          	auipc	a0,0x5
ffffffffc0200c2a:	5fa50513          	addi	a0,a0,1530 # ffffffffc0206220 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	5ce50513          	addi	a0,a0,1486 # ffffffffc0206200 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	58250513          	addi	a0,a0,1410 # ffffffffc02061c0 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	59650513          	addi	a0,a0,1430 # ffffffffc02061e0 <commands+0x588>
ffffffffc0200c52:	d42ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200c56:	1141                	addi	sp,sp,-16
ffffffffc0200c58:	e406                	sd	ra,8(sp)
        /* 时间片轮转：
         *(1) 设置下一次时钟中断（clock_set_next_event）
         *(2) ticks 计数器自增
         *(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，如果有则标记该进程需要被重新调度（current->need_resched）
        */
        clock_set_next_event();
ffffffffc0200c5a:	919ff0ef          	jal	ra,ffffffffc0200572 <clock_set_next_event>
        ticks++;
ffffffffc0200c5e:	000b4797          	auipc	a5,0xb4
ffffffffc0200c62:	36a78793          	addi	a5,a5,874 # ffffffffc02b4fc8 <ticks>
ffffffffc0200c66:	6398                	ld	a4,0(a5)
ffffffffc0200c68:	0705                	addi	a4,a4,1
ffffffffc0200c6a:	e398                	sd	a4,0(a5)
        if (ticks % TICK_NUM == 0)
ffffffffc0200c6c:	639c                	ld	a5,0(a5)
ffffffffc0200c6e:	06400713          	li	a4,100
ffffffffc0200c72:	02e7f7b3          	remu	a5,a5,a4
ffffffffc0200c76:	eb81                	bnez	a5,ffffffffc0200c86 <interrupt_handler+0x80>
        {
            assert(current != NULL);
ffffffffc0200c78:	000b4797          	auipc	a5,0xb4
ffffffffc0200c7c:	3b87b783          	ld	a5,952(a5) # ffffffffc02b5030 <current>
ffffffffc0200c80:	cf89                	beqz	a5,ffffffffc0200c9a <interrupt_handler+0x94>
            current->need_resched = 1;
ffffffffc0200c82:	4705                	li	a4,1
ffffffffc0200c84:	ef98                	sd	a4,24(a5)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c86:	60a2                	ld	ra,8(sp)
ffffffffc0200c88:	0141                	addi	sp,sp,16
ffffffffc0200c8a:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c8c:	00005517          	auipc	a0,0x5
ffffffffc0200c90:	5f450513          	addi	a0,a0,1524 # ffffffffc0206280 <commands+0x628>
ffffffffc0200c94:	d00ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c98:	b731                	j	ffffffffc0200ba4 <print_trapframe>
            assert(current != NULL);
ffffffffc0200c9a:	00005697          	auipc	a3,0x5
ffffffffc0200c9e:	5a668693          	addi	a3,a3,1446 # ffffffffc0206240 <commands+0x5e8>
ffffffffc0200ca2:	00005617          	auipc	a2,0x5
ffffffffc0200ca6:	5ae60613          	addi	a2,a2,1454 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0200caa:	08300593          	li	a1,131
ffffffffc0200cae:	00005517          	auipc	a0,0x5
ffffffffc0200cb2:	5ba50513          	addi	a0,a0,1466 # ffffffffc0206268 <commands+0x610>
ffffffffc0200cb6:	fd8ff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0200cba <exception_handler>:
    return do_pgfault(mm, tf->cause, tf->tval);
}
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200cba:	11853783          	ld	a5,280(a0)
{
ffffffffc0200cbe:	1101                	addi	sp,sp,-32
ffffffffc0200cc0:	e822                	sd	s0,16(sp)
ffffffffc0200cc2:	ec06                	sd	ra,24(sp)
ffffffffc0200cc4:	e426                	sd	s1,8(sp)
ffffffffc0200cc6:	473d                	li	a4,15
ffffffffc0200cc8:	842a                	mv	s0,a0
ffffffffc0200cca:	10f76b63          	bltu	a4,a5,ffffffffc0200de0 <exception_handler+0x126>
ffffffffc0200cce:	00005717          	auipc	a4,0x5
ffffffffc0200cd2:	7be70713          	addi	a4,a4,1982 # ffffffffc020648c <commands+0x834>
ffffffffc0200cd6:	078a                	slli	a5,a5,0x2
ffffffffc0200cd8:	97ba                	add	a5,a5,a4
ffffffffc0200cda:	439c                	lw	a5,0(a5)
ffffffffc0200cdc:	97ba                	add	a5,a5,a4
ffffffffc0200cde:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200ce0:	00005517          	auipc	a0,0x5
ffffffffc0200ce4:	6c050513          	addi	a0,a0,1728 # ffffffffc02063a0 <commands+0x748>
ffffffffc0200ce8:	cacff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cec:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cf0:	60e2                	ld	ra,24(sp)
ffffffffc0200cf2:	64a2                	ld	s1,8(sp)
        tf->epc += 4;
ffffffffc0200cf4:	0791                	addi	a5,a5,4
ffffffffc0200cf6:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cfa:	6442                	ld	s0,16(sp)
ffffffffc0200cfc:	6105                	addi	sp,sp,32
        syscall();
ffffffffc0200cfe:	7a00406f          	j	ffffffffc020549e <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200d02:	00005517          	auipc	a0,0x5
ffffffffc0200d06:	6be50513          	addi	a0,a0,1726 # ffffffffc02063c0 <commands+0x768>
}
ffffffffc0200d0a:	6442                	ld	s0,16(sp)
ffffffffc0200d0c:	60e2                	ld	ra,24(sp)
ffffffffc0200d0e:	64a2                	ld	s1,8(sp)
ffffffffc0200d10:	6105                	addi	sp,sp,32
        cprintf("Instruction access fault\n");
ffffffffc0200d12:	c82ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d16:	00005517          	auipc	a0,0x5
ffffffffc0200d1a:	6ca50513          	addi	a0,a0,1738 # ffffffffc02063e0 <commands+0x788>
ffffffffc0200d1e:	b7f5                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Instruction page fault\n");
ffffffffc0200d20:	00005517          	auipc	a0,0x5
ffffffffc0200d24:	6e050513          	addi	a0,a0,1760 # ffffffffc0206400 <commands+0x7a8>
ffffffffc0200d28:	b7cd                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Load page fault\n");
ffffffffc0200d2a:	00005517          	auipc	a0,0x5
ffffffffc0200d2e:	6ee50513          	addi	a0,a0,1774 # ffffffffc0206418 <commands+0x7c0>
ffffffffc0200d32:	bfe1                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d34:	00005517          	auipc	a0,0x5
ffffffffc0200d38:	6fc50513          	addi	a0,a0,1788 # ffffffffc0206430 <commands+0x7d8>
ffffffffc0200d3c:	c58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (check_mm_struct != NULL)
ffffffffc0200d40:	000b4517          	auipc	a0,0xb4
ffffffffc0200d44:	2e053503          	ld	a0,736(a0) # ffffffffc02b5020 <check_mm_struct>
        assert(current == NULL);
ffffffffc0200d48:	000b4797          	auipc	a5,0xb4
ffffffffc0200d4c:	2e87b783          	ld	a5,744(a5) # ffffffffc02b5030 <current>
    if (check_mm_struct != NULL)
ffffffffc0200d50:	c955                	beqz	a0,ffffffffc0200e04 <exception_handler+0x14a>
        assert(current == NULL);
ffffffffc0200d52:	0e079063          	bnez	a5,ffffffffc0200e32 <exception_handler+0x178>
    return do_pgfault(mm, tf->cause, tf->tval);
ffffffffc0200d56:	11043603          	ld	a2,272(s0)
ffffffffc0200d5a:	11842583          	lw	a1,280(s0)
ffffffffc0200d5e:	134030ef          	jal	ra,ffffffffc0203e92 <do_pgfault>
ffffffffc0200d62:	84aa                	mv	s1,a0
        if ((ret = pgfault_handler(tf)) != 0)
ffffffffc0200d64:	c931                	beqz	a0,ffffffffc0200db8 <exception_handler+0xfe>
            print_trapframe(tf);
ffffffffc0200d66:	8522                	mv	a0,s0
ffffffffc0200d68:	e3dff0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
ffffffffc0200d6c:	86a6                	mv	a3,s1
ffffffffc0200d6e:	00005617          	auipc	a2,0x5
ffffffffc0200d72:	70260613          	addi	a2,a2,1794 # ffffffffc0206470 <commands+0x818>
ffffffffc0200d76:	0f400593          	li	a1,244
ffffffffc0200d7a:	00005517          	auipc	a0,0x5
ffffffffc0200d7e:	4ee50513          	addi	a0,a0,1262 # ffffffffc0206268 <commands+0x610>
ffffffffc0200d82:	f0cff0ef          	jal	ra,ffffffffc020048e <__panic>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d86:	00005517          	auipc	a0,0x5
ffffffffc0200d8a:	54a50513          	addi	a0,a0,1354 # ffffffffc02062d0 <commands+0x678>
ffffffffc0200d8e:	bfb5                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Instruction access fault\n");
ffffffffc0200d90:	00005517          	auipc	a0,0x5
ffffffffc0200d94:	56050513          	addi	a0,a0,1376 # ffffffffc02062f0 <commands+0x698>
ffffffffc0200d98:	bf8d                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Illegal instruction\n");
ffffffffc0200d9a:	00005517          	auipc	a0,0x5
ffffffffc0200d9e:	57650513          	addi	a0,a0,1398 # ffffffffc0206310 <commands+0x6b8>
ffffffffc0200da2:	b7a5                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Breakpoint\n");
ffffffffc0200da4:	00005517          	auipc	a0,0x5
ffffffffc0200da8:	58450513          	addi	a0,a0,1412 # ffffffffc0206328 <commands+0x6d0>
ffffffffc0200dac:	be8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200db0:	6458                	ld	a4,136(s0)
ffffffffc0200db2:	47a9                	li	a5,10
ffffffffc0200db4:	04f70b63          	beq	a4,a5,ffffffffc0200e0a <exception_handler+0x150>
}
ffffffffc0200db8:	60e2                	ld	ra,24(sp)
ffffffffc0200dba:	6442                	ld	s0,16(sp)
ffffffffc0200dbc:	64a2                	ld	s1,8(sp)
ffffffffc0200dbe:	6105                	addi	sp,sp,32
ffffffffc0200dc0:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200dc2:	00005517          	auipc	a0,0x5
ffffffffc0200dc6:	57650513          	addi	a0,a0,1398 # ffffffffc0206338 <commands+0x6e0>
ffffffffc0200dca:	b781                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Load access fault\n");
ffffffffc0200dcc:	00005517          	auipc	a0,0x5
ffffffffc0200dd0:	58c50513          	addi	a0,a0,1420 # ffffffffc0206358 <commands+0x700>
ffffffffc0200dd4:	bf1d                	j	ffffffffc0200d0a <exception_handler+0x50>
        cprintf("Store/AMO access fault\n");
ffffffffc0200dd6:	00005517          	auipc	a0,0x5
ffffffffc0200dda:	5b250513          	addi	a0,a0,1458 # ffffffffc0206388 <commands+0x730>
ffffffffc0200dde:	b735                	j	ffffffffc0200d0a <exception_handler+0x50>
        print_trapframe(tf);
ffffffffc0200de0:	8522                	mv	a0,s0
}
ffffffffc0200de2:	6442                	ld	s0,16(sp)
ffffffffc0200de4:	60e2                	ld	ra,24(sp)
ffffffffc0200de6:	64a2                	ld	s1,8(sp)
ffffffffc0200de8:	6105                	addi	sp,sp,32
        print_trapframe(tf);
ffffffffc0200dea:	bb6d                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200dec:	00005617          	auipc	a2,0x5
ffffffffc0200df0:	58460613          	addi	a2,a2,1412 # ffffffffc0206370 <commands+0x718>
ffffffffc0200df4:	0d400593          	li	a1,212
ffffffffc0200df8:	00005517          	auipc	a0,0x5
ffffffffc0200dfc:	47050513          	addi	a0,a0,1136 # ffffffffc0206268 <commands+0x610>
ffffffffc0200e00:	e8eff0ef          	jal	ra,ffffffffc020048e <__panic>
        if (current == NULL)
ffffffffc0200e04:	c7b9                	beqz	a5,ffffffffc0200e52 <exception_handler+0x198>
        mm = current->mm;
ffffffffc0200e06:	7788                	ld	a0,40(a5)
ffffffffc0200e08:	b7b9                	j	ffffffffc0200d56 <exception_handler+0x9c>
            tf->epc += 4;
ffffffffc0200e0a:	10843783          	ld	a5,264(s0)
ffffffffc0200e0e:	0791                	addi	a5,a5,4
ffffffffc0200e10:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200e14:	68a040ef          	jal	ra,ffffffffc020549e <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e18:	000b4797          	auipc	a5,0xb4
ffffffffc0200e1c:	2187b783          	ld	a5,536(a5) # ffffffffc02b5030 <current>
ffffffffc0200e20:	6b9c                	ld	a5,16(a5)
ffffffffc0200e22:	8522                	mv	a0,s0
}
ffffffffc0200e24:	6442                	ld	s0,16(sp)
ffffffffc0200e26:	60e2                	ld	ra,24(sp)
ffffffffc0200e28:	64a2                	ld	s1,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e2a:	6589                	lui	a1,0x2
ffffffffc0200e2c:	95be                	add	a1,a1,a5
}
ffffffffc0200e2e:	6105                	addi	sp,sp,32
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200e30:	aa79                	j	ffffffffc0200fce <kernel_execve_ret>
        assert(current == NULL);
ffffffffc0200e32:	00005697          	auipc	a3,0x5
ffffffffc0200e36:	61668693          	addi	a3,a3,1558 # ffffffffc0206448 <commands+0x7f0>
ffffffffc0200e3a:	00005617          	auipc	a2,0x5
ffffffffc0200e3e:	41660613          	addi	a2,a2,1046 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0200e42:	0a600593          	li	a1,166
ffffffffc0200e46:	00005517          	auipc	a0,0x5
ffffffffc0200e4a:	42250513          	addi	a0,a0,1058 # ffffffffc0206268 <commands+0x610>
ffffffffc0200e4e:	e40ff0ef          	jal	ra,ffffffffc020048e <__panic>
            print_trapframe(tf);
ffffffffc0200e52:	8522                	mv	a0,s0
ffffffffc0200e54:	d51ff0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
            print_regs(&tf->gpr);
ffffffffc0200e58:	8522                	mv	a0,s0
ffffffffc0200e5a:	b7dff0ef          	jal	ra,ffffffffc02009d6 <print_regs>
            panic("unhandled page fault.\n");
ffffffffc0200e5e:	00005617          	auipc	a2,0x5
ffffffffc0200e62:	5fa60613          	addi	a2,a2,1530 # ffffffffc0206458 <commands+0x800>
ffffffffc0200e66:	0af00593          	li	a1,175
ffffffffc0200e6a:	00005517          	auipc	a0,0x5
ffffffffc0200e6e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0206268 <commands+0x610>
ffffffffc0200e72:	e1cff0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0200e76 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200e76:	1101                	addi	sp,sp,-32
ffffffffc0200e78:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200e7a:	000b4417          	auipc	s0,0xb4
ffffffffc0200e7e:	1b640413          	addi	s0,s0,438 # ffffffffc02b5030 <current>
ffffffffc0200e82:	6018                	ld	a4,0(s0)
{
ffffffffc0200e84:	ec06                	sd	ra,24(sp)
ffffffffc0200e86:	e426                	sd	s1,8(sp)
ffffffffc0200e88:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e8a:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200e8e:	cf1d                	beqz	a4,ffffffffc0200ecc <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e90:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200e94:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200e98:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200e9a:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e9e:	0206c463          	bltz	a3,ffffffffc0200ec6 <trap+0x50>
        exception_handler(tf);
ffffffffc0200ea2:	e19ff0ef          	jal	ra,ffffffffc0200cba <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200ea6:	601c                	ld	a5,0(s0)
ffffffffc0200ea8:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200eac:	e499                	bnez	s1,ffffffffc0200eba <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200eae:	0b07a703          	lw	a4,176(a5)
ffffffffc0200eb2:	8b05                	andi	a4,a4,1
ffffffffc0200eb4:	e329                	bnez	a4,ffffffffc0200ef6 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200eb6:	6f9c                	ld	a5,24(a5)
ffffffffc0200eb8:	eb85                	bnez	a5,ffffffffc0200ee8 <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200eba:	60e2                	ld	ra,24(sp)
ffffffffc0200ebc:	6442                	ld	s0,16(sp)
ffffffffc0200ebe:	64a2                	ld	s1,8(sp)
ffffffffc0200ec0:	6902                	ld	s2,0(sp)
ffffffffc0200ec2:	6105                	addi	sp,sp,32
ffffffffc0200ec4:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200ec6:	d41ff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200eca:	bff1                	j	ffffffffc0200ea6 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200ecc:	0006c863          	bltz	a3,ffffffffc0200edc <trap+0x66>
}
ffffffffc0200ed0:	6442                	ld	s0,16(sp)
ffffffffc0200ed2:	60e2                	ld	ra,24(sp)
ffffffffc0200ed4:	64a2                	ld	s1,8(sp)
ffffffffc0200ed6:	6902                	ld	s2,0(sp)
ffffffffc0200ed8:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200eda:	b3c5                	j	ffffffffc0200cba <exception_handler>
}
ffffffffc0200edc:	6442                	ld	s0,16(sp)
ffffffffc0200ede:	60e2                	ld	ra,24(sp)
ffffffffc0200ee0:	64a2                	ld	s1,8(sp)
ffffffffc0200ee2:	6902                	ld	s2,0(sp)
ffffffffc0200ee4:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200ee6:	b305                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200ee8:	6442                	ld	s0,16(sp)
ffffffffc0200eea:	60e2                	ld	ra,24(sp)
ffffffffc0200eec:	64a2                	ld	s1,8(sp)
ffffffffc0200eee:	6902                	ld	s2,0(sp)
ffffffffc0200ef0:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200ef2:	4c00406f          	j	ffffffffc02053b2 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200ef6:	555d                	li	a0,-9
ffffffffc0200ef8:	001030ef          	jal	ra,ffffffffc02046f8 <do_exit>
            if (current->need_resched)
ffffffffc0200efc:	601c                	ld	a5,0(s0)
ffffffffc0200efe:	bf65                	j	ffffffffc0200eb6 <trap+0x40>

ffffffffc0200f00 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200f00:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200f04:	00011463          	bnez	sp,ffffffffc0200f0c <__alltraps+0xc>
ffffffffc0200f08:	14002173          	csrr	sp,sscratch
ffffffffc0200f0c:	712d                	addi	sp,sp,-288
ffffffffc0200f0e:	e002                	sd	zero,0(sp)
ffffffffc0200f10:	e406                	sd	ra,8(sp)
ffffffffc0200f12:	ec0e                	sd	gp,24(sp)
ffffffffc0200f14:	f012                	sd	tp,32(sp)
ffffffffc0200f16:	f416                	sd	t0,40(sp)
ffffffffc0200f18:	f81a                	sd	t1,48(sp)
ffffffffc0200f1a:	fc1e                	sd	t2,56(sp)
ffffffffc0200f1c:	e0a2                	sd	s0,64(sp)
ffffffffc0200f1e:	e4a6                	sd	s1,72(sp)
ffffffffc0200f20:	e8aa                	sd	a0,80(sp)
ffffffffc0200f22:	ecae                	sd	a1,88(sp)
ffffffffc0200f24:	f0b2                	sd	a2,96(sp)
ffffffffc0200f26:	f4b6                	sd	a3,104(sp)
ffffffffc0200f28:	f8ba                	sd	a4,112(sp)
ffffffffc0200f2a:	fcbe                	sd	a5,120(sp)
ffffffffc0200f2c:	e142                	sd	a6,128(sp)
ffffffffc0200f2e:	e546                	sd	a7,136(sp)
ffffffffc0200f30:	e94a                	sd	s2,144(sp)
ffffffffc0200f32:	ed4e                	sd	s3,152(sp)
ffffffffc0200f34:	f152                	sd	s4,160(sp)
ffffffffc0200f36:	f556                	sd	s5,168(sp)
ffffffffc0200f38:	f95a                	sd	s6,176(sp)
ffffffffc0200f3a:	fd5e                	sd	s7,184(sp)
ffffffffc0200f3c:	e1e2                	sd	s8,192(sp)
ffffffffc0200f3e:	e5e6                	sd	s9,200(sp)
ffffffffc0200f40:	e9ea                	sd	s10,208(sp)
ffffffffc0200f42:	edee                	sd	s11,216(sp)
ffffffffc0200f44:	f1f2                	sd	t3,224(sp)
ffffffffc0200f46:	f5f6                	sd	t4,232(sp)
ffffffffc0200f48:	f9fa                	sd	t5,240(sp)
ffffffffc0200f4a:	fdfe                	sd	t6,248(sp)
ffffffffc0200f4c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200f50:	100024f3          	csrr	s1,sstatus
ffffffffc0200f54:	14102973          	csrr	s2,sepc
ffffffffc0200f58:	143029f3          	csrr	s3,stval
ffffffffc0200f5c:	14202a73          	csrr	s4,scause
ffffffffc0200f60:	e822                	sd	s0,16(sp)
ffffffffc0200f62:	e226                	sd	s1,256(sp)
ffffffffc0200f64:	e64a                	sd	s2,264(sp)
ffffffffc0200f66:	ea4e                	sd	s3,272(sp)
ffffffffc0200f68:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200f6a:	850a                	mv	a0,sp
    jal trap
ffffffffc0200f6c:	f0bff0ef          	jal	ra,ffffffffc0200e76 <trap>

ffffffffc0200f70 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200f70:	6492                	ld	s1,256(sp)
ffffffffc0200f72:	6932                	ld	s2,264(sp)
ffffffffc0200f74:	1004f413          	andi	s0,s1,256
ffffffffc0200f78:	e401                	bnez	s0,ffffffffc0200f80 <__trapret+0x10>
ffffffffc0200f7a:	1200                	addi	s0,sp,288
ffffffffc0200f7c:	14041073          	csrw	sscratch,s0
ffffffffc0200f80:	10049073          	csrw	sstatus,s1
ffffffffc0200f84:	14191073          	csrw	sepc,s2
ffffffffc0200f88:	60a2                	ld	ra,8(sp)
ffffffffc0200f8a:	61e2                	ld	gp,24(sp)
ffffffffc0200f8c:	7202                	ld	tp,32(sp)
ffffffffc0200f8e:	72a2                	ld	t0,40(sp)
ffffffffc0200f90:	7342                	ld	t1,48(sp)
ffffffffc0200f92:	73e2                	ld	t2,56(sp)
ffffffffc0200f94:	6406                	ld	s0,64(sp)
ffffffffc0200f96:	64a6                	ld	s1,72(sp)
ffffffffc0200f98:	6546                	ld	a0,80(sp)
ffffffffc0200f9a:	65e6                	ld	a1,88(sp)
ffffffffc0200f9c:	7606                	ld	a2,96(sp)
ffffffffc0200f9e:	76a6                	ld	a3,104(sp)
ffffffffc0200fa0:	7746                	ld	a4,112(sp)
ffffffffc0200fa2:	77e6                	ld	a5,120(sp)
ffffffffc0200fa4:	680a                	ld	a6,128(sp)
ffffffffc0200fa6:	68aa                	ld	a7,136(sp)
ffffffffc0200fa8:	694a                	ld	s2,144(sp)
ffffffffc0200faa:	69ea                	ld	s3,152(sp)
ffffffffc0200fac:	7a0a                	ld	s4,160(sp)
ffffffffc0200fae:	7aaa                	ld	s5,168(sp)
ffffffffc0200fb0:	7b4a                	ld	s6,176(sp)
ffffffffc0200fb2:	7bea                	ld	s7,184(sp)
ffffffffc0200fb4:	6c0e                	ld	s8,192(sp)
ffffffffc0200fb6:	6cae                	ld	s9,200(sp)
ffffffffc0200fb8:	6d4e                	ld	s10,208(sp)
ffffffffc0200fba:	6dee                	ld	s11,216(sp)
ffffffffc0200fbc:	7e0e                	ld	t3,224(sp)
ffffffffc0200fbe:	7eae                	ld	t4,232(sp)
ffffffffc0200fc0:	7f4e                	ld	t5,240(sp)
ffffffffc0200fc2:	7fee                	ld	t6,248(sp)
ffffffffc0200fc4:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200fc6:	10200073          	sret

ffffffffc0200fca <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200fca:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200fcc:	b755                	j	ffffffffc0200f70 <__trapret>

ffffffffc0200fce <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200fce:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200fd2:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200fd6:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200fda:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200fde:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200fe2:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200fe6:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200fea:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200fee:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200ff2:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200ff4:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200ff6:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200ff8:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200ffa:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200ffc:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200ffe:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0201000:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0201002:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0201004:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0201006:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0201008:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc020100a:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc020100c:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc020100e:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0201010:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0201012:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0201014:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0201016:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0201018:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc020101a:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc020101c:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc020101e:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0201020:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0201022:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0201024:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0201026:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0201028:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc020102a:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc020102c:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc020102e:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0201030:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0201032:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0201034:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0201036:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0201038:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc020103a:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc020103c:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc020103e:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0201040:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0201042:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0201044:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0201046:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0201048:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc020104a:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc020104c:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc020104e:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0201050:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0201052:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0201054:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0201056:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0201058:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc020105a:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc020105c:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc020105e:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0201060:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0201062:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0201064:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0201066:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0201068:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc020106a:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc020106c:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc020106e:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0201070:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0201072:	812e                	mv	sp,a1
ffffffffc0201074:	bdf5                	j	ffffffffc0200f70 <__trapret>

ffffffffc0201076 <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0201076:	000b0797          	auipc	a5,0xb0
ffffffffc020107a:	f2278793          	addi	a5,a5,-222 # ffffffffc02b0f98 <free_area>
ffffffffc020107e:	e79c                	sd	a5,8(a5)
ffffffffc0201080:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0201082:	0007a823          	sw	zero,16(a5)
}
ffffffffc0201086:	8082                	ret

ffffffffc0201088 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0201088:	000b0517          	auipc	a0,0xb0
ffffffffc020108c:	f2056503          	lwu	a0,-224(a0) # ffffffffc02b0fa8 <free_area+0x10>
ffffffffc0201090:	8082                	ret

ffffffffc0201092 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0201092:	715d                	addi	sp,sp,-80
ffffffffc0201094:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201096:	000b0417          	auipc	s0,0xb0
ffffffffc020109a:	f0240413          	addi	s0,s0,-254 # ffffffffc02b0f98 <free_area>
ffffffffc020109e:	641c                	ld	a5,8(s0)
ffffffffc02010a0:	e486                	sd	ra,72(sp)
ffffffffc02010a2:	fc26                	sd	s1,56(sp)
ffffffffc02010a4:	f84a                	sd	s2,48(sp)
ffffffffc02010a6:	f44e                	sd	s3,40(sp)
ffffffffc02010a8:	f052                	sd	s4,32(sp)
ffffffffc02010aa:	ec56                	sd	s5,24(sp)
ffffffffc02010ac:	e85a                	sd	s6,16(sp)
ffffffffc02010ae:	e45e                	sd	s7,8(sp)
ffffffffc02010b0:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02010b2:	2a878d63          	beq	a5,s0,ffffffffc020136c <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc02010b6:	4481                	li	s1,0
ffffffffc02010b8:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02010ba:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02010be:	8b09                	andi	a4,a4,2
ffffffffc02010c0:	2a070a63          	beqz	a4,ffffffffc0201374 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc02010c4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010c8:	679c                	ld	a5,8(a5)
ffffffffc02010ca:	2905                	addiw	s2,s2,1
ffffffffc02010cc:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02010ce:	fe8796e3          	bne	a5,s0,ffffffffc02010ba <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02010d2:	89a6                	mv	s3,s1
ffffffffc02010d4:	6df000ef          	jal	ra,ffffffffc0201fb2 <nr_free_pages>
ffffffffc02010d8:	6f351e63          	bne	a0,s3,ffffffffc02017d4 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02010dc:	4505                	li	a0,1
ffffffffc02010de:	657000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02010e2:	8aaa                	mv	s5,a0
ffffffffc02010e4:	42050863          	beqz	a0,ffffffffc0201514 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02010e8:	4505                	li	a0,1
ffffffffc02010ea:	64b000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02010ee:	89aa                	mv	s3,a0
ffffffffc02010f0:	70050263          	beqz	a0,ffffffffc02017f4 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02010f4:	4505                	li	a0,1
ffffffffc02010f6:	63f000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02010fa:	8a2a                	mv	s4,a0
ffffffffc02010fc:	48050c63          	beqz	a0,ffffffffc0201594 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201100:	293a8a63          	beq	s5,s3,ffffffffc0201394 <default_check+0x302>
ffffffffc0201104:	28aa8863          	beq	s5,a0,ffffffffc0201394 <default_check+0x302>
ffffffffc0201108:	28a98663          	beq	s3,a0,ffffffffc0201394 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020110c:	000aa783          	lw	a5,0(s5)
ffffffffc0201110:	2a079263          	bnez	a5,ffffffffc02013b4 <default_check+0x322>
ffffffffc0201114:	0009a783          	lw	a5,0(s3)
ffffffffc0201118:	28079e63          	bnez	a5,ffffffffc02013b4 <default_check+0x322>
ffffffffc020111c:	411c                	lw	a5,0(a0)
ffffffffc020111e:	28079b63          	bnez	a5,ffffffffc02013b4 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201122:	000b4797          	auipc	a5,0xb4
ffffffffc0201126:	ee67b783          	ld	a5,-282(a5) # ffffffffc02b5008 <pages>
ffffffffc020112a:	40fa8733          	sub	a4,s5,a5
ffffffffc020112e:	00007617          	auipc	a2,0x7
ffffffffc0201132:	bea63603          	ld	a2,-1046(a2) # ffffffffc0207d18 <nbase>
ffffffffc0201136:	8719                	srai	a4,a4,0x6
ffffffffc0201138:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020113a:	000b4697          	auipc	a3,0xb4
ffffffffc020113e:	ec66b683          	ld	a3,-314(a3) # ffffffffc02b5000 <npage>
ffffffffc0201142:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0201144:	0732                	slli	a4,a4,0xc
ffffffffc0201146:	28d77763          	bgeu	a4,a3,ffffffffc02013d4 <default_check+0x342>
    return page - pages + nbase;
ffffffffc020114a:	40f98733          	sub	a4,s3,a5
ffffffffc020114e:	8719                	srai	a4,a4,0x6
ffffffffc0201150:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201152:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201154:	4cd77063          	bgeu	a4,a3,ffffffffc0201614 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0201158:	40f507b3          	sub	a5,a0,a5
ffffffffc020115c:	8799                	srai	a5,a5,0x6
ffffffffc020115e:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201160:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201162:	30d7f963          	bgeu	a5,a3,ffffffffc0201474 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0201166:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201168:	00043c03          	ld	s8,0(s0)
ffffffffc020116c:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0201170:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0201174:	e400                	sd	s0,8(s0)
ffffffffc0201176:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201178:	000b0797          	auipc	a5,0xb0
ffffffffc020117c:	e207a823          	sw	zero,-464(a5) # ffffffffc02b0fa8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0201180:	5b5000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc0201184:	2c051863          	bnez	a0,ffffffffc0201454 <default_check+0x3c2>
    free_page(p0);
ffffffffc0201188:	4585                	li	a1,1
ffffffffc020118a:	8556                	mv	a0,s5
ffffffffc020118c:	5e7000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    free_page(p1);
ffffffffc0201190:	4585                	li	a1,1
ffffffffc0201192:	854e                	mv	a0,s3
ffffffffc0201194:	5df000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    free_page(p2);
ffffffffc0201198:	4585                	li	a1,1
ffffffffc020119a:	8552                	mv	a0,s4
ffffffffc020119c:	5d7000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    assert(nr_free == 3);
ffffffffc02011a0:	4818                	lw	a4,16(s0)
ffffffffc02011a2:	478d                	li	a5,3
ffffffffc02011a4:	28f71863          	bne	a4,a5,ffffffffc0201434 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02011a8:	4505                	li	a0,1
ffffffffc02011aa:	58b000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02011ae:	89aa                	mv	s3,a0
ffffffffc02011b0:	26050263          	beqz	a0,ffffffffc0201414 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02011b4:	4505                	li	a0,1
ffffffffc02011b6:	57f000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02011ba:	8aaa                	mv	s5,a0
ffffffffc02011bc:	3a050c63          	beqz	a0,ffffffffc0201574 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02011c0:	4505                	li	a0,1
ffffffffc02011c2:	573000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02011c6:	8a2a                	mv	s4,a0
ffffffffc02011c8:	38050663          	beqz	a0,ffffffffc0201554 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc02011cc:	4505                	li	a0,1
ffffffffc02011ce:	567000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02011d2:	36051163          	bnez	a0,ffffffffc0201534 <default_check+0x4a2>
    free_page(p0);
ffffffffc02011d6:	4585                	li	a1,1
ffffffffc02011d8:	854e                	mv	a0,s3
ffffffffc02011da:	599000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02011de:	641c                	ld	a5,8(s0)
ffffffffc02011e0:	20878a63          	beq	a5,s0,ffffffffc02013f4 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc02011e4:	4505                	li	a0,1
ffffffffc02011e6:	54f000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02011ea:	30a99563          	bne	s3,a0,ffffffffc02014f4 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc02011ee:	4505                	li	a0,1
ffffffffc02011f0:	545000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02011f4:	2e051063          	bnez	a0,ffffffffc02014d4 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc02011f8:	481c                	lw	a5,16(s0)
ffffffffc02011fa:	2a079d63          	bnez	a5,ffffffffc02014b4 <default_check+0x422>
    free_page(p);
ffffffffc02011fe:	854e                	mv	a0,s3
ffffffffc0201200:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201202:	01843023          	sd	s8,0(s0)
ffffffffc0201206:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020120a:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc020120e:	565000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    free_page(p1);
ffffffffc0201212:	4585                	li	a1,1
ffffffffc0201214:	8556                	mv	a0,s5
ffffffffc0201216:	55d000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    free_page(p2);
ffffffffc020121a:	4585                	li	a1,1
ffffffffc020121c:	8552                	mv	a0,s4
ffffffffc020121e:	555000ef          	jal	ra,ffffffffc0201f72 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201222:	4515                	li	a0,5
ffffffffc0201224:	511000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc0201228:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020122a:	26050563          	beqz	a0,ffffffffc0201494 <default_check+0x402>
ffffffffc020122e:	651c                	ld	a5,8(a0)
ffffffffc0201230:	8385                	srli	a5,a5,0x1
ffffffffc0201232:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201234:	54079063          	bnez	a5,ffffffffc0201774 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201238:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020123a:	00043b03          	ld	s6,0(s0)
ffffffffc020123e:	00843a83          	ld	s5,8(s0)
ffffffffc0201242:	e000                	sd	s0,0(s0)
ffffffffc0201244:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201246:	4ef000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc020124a:	50051563          	bnez	a0,ffffffffc0201754 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc020124e:	08098a13          	addi	s4,s3,128
ffffffffc0201252:	8552                	mv	a0,s4
ffffffffc0201254:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201256:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc020125a:	000b0797          	auipc	a5,0xb0
ffffffffc020125e:	d407a723          	sw	zero,-690(a5) # ffffffffc02b0fa8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0201262:	511000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201266:	4511                	li	a0,4
ffffffffc0201268:	4cd000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc020126c:	4c051463          	bnez	a0,ffffffffc0201734 <default_check+0x6a2>
ffffffffc0201270:	0889b783          	ld	a5,136(s3)
ffffffffc0201274:	8385                	srli	a5,a5,0x1
ffffffffc0201276:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201278:	48078e63          	beqz	a5,ffffffffc0201714 <default_check+0x682>
ffffffffc020127c:	0909a703          	lw	a4,144(s3)
ffffffffc0201280:	478d                	li	a5,3
ffffffffc0201282:	48f71963          	bne	a4,a5,ffffffffc0201714 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201286:	450d                	li	a0,3
ffffffffc0201288:	4ad000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc020128c:	8c2a                	mv	s8,a0
ffffffffc020128e:	46050363          	beqz	a0,ffffffffc02016f4 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0201292:	4505                	li	a0,1
ffffffffc0201294:	4a1000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc0201298:	42051e63          	bnez	a0,ffffffffc02016d4 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc020129c:	418a1c63          	bne	s4,s8,ffffffffc02016b4 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc02012a0:	4585                	li	a1,1
ffffffffc02012a2:	854e                	mv	a0,s3
ffffffffc02012a4:	4cf000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    free_pages(p1, 3);
ffffffffc02012a8:	458d                	li	a1,3
ffffffffc02012aa:	8552                	mv	a0,s4
ffffffffc02012ac:	4c7000ef          	jal	ra,ffffffffc0201f72 <free_pages>
ffffffffc02012b0:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc02012b4:	04098c13          	addi	s8,s3,64
ffffffffc02012b8:	8385                	srli	a5,a5,0x1
ffffffffc02012ba:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02012bc:	3c078c63          	beqz	a5,ffffffffc0201694 <default_check+0x602>
ffffffffc02012c0:	0109a703          	lw	a4,16(s3)
ffffffffc02012c4:	4785                	li	a5,1
ffffffffc02012c6:	3cf71763          	bne	a4,a5,ffffffffc0201694 <default_check+0x602>
ffffffffc02012ca:	008a3783          	ld	a5,8(s4)
ffffffffc02012ce:	8385                	srli	a5,a5,0x1
ffffffffc02012d0:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02012d2:	3a078163          	beqz	a5,ffffffffc0201674 <default_check+0x5e2>
ffffffffc02012d6:	010a2703          	lw	a4,16(s4)
ffffffffc02012da:	478d                	li	a5,3
ffffffffc02012dc:	38f71c63          	bne	a4,a5,ffffffffc0201674 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02012e0:	4505                	li	a0,1
ffffffffc02012e2:	453000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02012e6:	36a99763          	bne	s3,a0,ffffffffc0201654 <default_check+0x5c2>
    free_page(p0);
ffffffffc02012ea:	4585                	li	a1,1
ffffffffc02012ec:	487000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02012f0:	4509                	li	a0,2
ffffffffc02012f2:	443000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc02012f6:	32aa1f63          	bne	s4,a0,ffffffffc0201634 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc02012fa:	4589                	li	a1,2
ffffffffc02012fc:	477000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    free_page(p2);
ffffffffc0201300:	4585                	li	a1,1
ffffffffc0201302:	8562                	mv	a0,s8
ffffffffc0201304:	46f000ef          	jal	ra,ffffffffc0201f72 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201308:	4515                	li	a0,5
ffffffffc020130a:	42b000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc020130e:	89aa                	mv	s3,a0
ffffffffc0201310:	48050263          	beqz	a0,ffffffffc0201794 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201314:	4505                	li	a0,1
ffffffffc0201316:	41f000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc020131a:	2c051d63          	bnez	a0,ffffffffc02015f4 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc020131e:	481c                	lw	a5,16(s0)
ffffffffc0201320:	2a079a63          	bnez	a5,ffffffffc02015d4 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201324:	4595                	li	a1,5
ffffffffc0201326:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0201328:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc020132c:	01643023          	sd	s6,0(s0)
ffffffffc0201330:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201334:	43f000ef          	jal	ra,ffffffffc0201f72 <free_pages>
    return listelm->next;
ffffffffc0201338:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020133a:	00878963          	beq	a5,s0,ffffffffc020134c <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc020133e:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201342:	679c                	ld	a5,8(a5)
ffffffffc0201344:	397d                	addiw	s2,s2,-1
ffffffffc0201346:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201348:	fe879be3          	bne	a5,s0,ffffffffc020133e <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc020134c:	26091463          	bnez	s2,ffffffffc02015b4 <default_check+0x522>
    assert(total == 0);
ffffffffc0201350:	46049263          	bnez	s1,ffffffffc02017b4 <default_check+0x722>
}
ffffffffc0201354:	60a6                	ld	ra,72(sp)
ffffffffc0201356:	6406                	ld	s0,64(sp)
ffffffffc0201358:	74e2                	ld	s1,56(sp)
ffffffffc020135a:	7942                	ld	s2,48(sp)
ffffffffc020135c:	79a2                	ld	s3,40(sp)
ffffffffc020135e:	7a02                	ld	s4,32(sp)
ffffffffc0201360:	6ae2                	ld	s5,24(sp)
ffffffffc0201362:	6b42                	ld	s6,16(sp)
ffffffffc0201364:	6ba2                	ld	s7,8(sp)
ffffffffc0201366:	6c02                	ld	s8,0(sp)
ffffffffc0201368:	6161                	addi	sp,sp,80
ffffffffc020136a:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc020136c:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc020136e:	4481                	li	s1,0
ffffffffc0201370:	4901                	li	s2,0
ffffffffc0201372:	b38d                	j	ffffffffc02010d4 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0201374:	00005697          	auipc	a3,0x5
ffffffffc0201378:	15c68693          	addi	a3,a3,348 # ffffffffc02064d0 <commands+0x878>
ffffffffc020137c:	00005617          	auipc	a2,0x5
ffffffffc0201380:	ed460613          	addi	a2,a2,-300 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201384:	11000593          	li	a1,272
ffffffffc0201388:	00005517          	auipc	a0,0x5
ffffffffc020138c:	15850513          	addi	a0,a0,344 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201390:	8feff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201394:	00005697          	auipc	a3,0x5
ffffffffc0201398:	1e468693          	addi	a3,a3,484 # ffffffffc0206578 <commands+0x920>
ffffffffc020139c:	00005617          	auipc	a2,0x5
ffffffffc02013a0:	eb460613          	addi	a2,a2,-332 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02013a4:	0db00593          	li	a1,219
ffffffffc02013a8:	00005517          	auipc	a0,0x5
ffffffffc02013ac:	13850513          	addi	a0,a0,312 # ffffffffc02064e0 <commands+0x888>
ffffffffc02013b0:	8deff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02013b4:	00005697          	auipc	a3,0x5
ffffffffc02013b8:	1ec68693          	addi	a3,a3,492 # ffffffffc02065a0 <commands+0x948>
ffffffffc02013bc:	00005617          	auipc	a2,0x5
ffffffffc02013c0:	e9460613          	addi	a2,a2,-364 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02013c4:	0dc00593          	li	a1,220
ffffffffc02013c8:	00005517          	auipc	a0,0x5
ffffffffc02013cc:	11850513          	addi	a0,a0,280 # ffffffffc02064e0 <commands+0x888>
ffffffffc02013d0:	8beff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02013d4:	00005697          	auipc	a3,0x5
ffffffffc02013d8:	20c68693          	addi	a3,a3,524 # ffffffffc02065e0 <commands+0x988>
ffffffffc02013dc:	00005617          	auipc	a2,0x5
ffffffffc02013e0:	e7460613          	addi	a2,a2,-396 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02013e4:	0de00593          	li	a1,222
ffffffffc02013e8:	00005517          	auipc	a0,0x5
ffffffffc02013ec:	0f850513          	addi	a0,a0,248 # ffffffffc02064e0 <commands+0x888>
ffffffffc02013f0:	89eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc02013f4:	00005697          	auipc	a3,0x5
ffffffffc02013f8:	27468693          	addi	a3,a3,628 # ffffffffc0206668 <commands+0xa10>
ffffffffc02013fc:	00005617          	auipc	a2,0x5
ffffffffc0201400:	e5460613          	addi	a2,a2,-428 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201404:	0f700593          	li	a1,247
ffffffffc0201408:	00005517          	auipc	a0,0x5
ffffffffc020140c:	0d850513          	addi	a0,a0,216 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201410:	87eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201414:	00005697          	auipc	a3,0x5
ffffffffc0201418:	10468693          	addi	a3,a3,260 # ffffffffc0206518 <commands+0x8c0>
ffffffffc020141c:	00005617          	auipc	a2,0x5
ffffffffc0201420:	e3460613          	addi	a2,a2,-460 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201424:	0f000593          	li	a1,240
ffffffffc0201428:	00005517          	auipc	a0,0x5
ffffffffc020142c:	0b850513          	addi	a0,a0,184 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201430:	85eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc0201434:	00005697          	auipc	a3,0x5
ffffffffc0201438:	22468693          	addi	a3,a3,548 # ffffffffc0206658 <commands+0xa00>
ffffffffc020143c:	00005617          	auipc	a2,0x5
ffffffffc0201440:	e1460613          	addi	a2,a2,-492 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201444:	0ee00593          	li	a1,238
ffffffffc0201448:	00005517          	auipc	a0,0x5
ffffffffc020144c:	09850513          	addi	a0,a0,152 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201450:	83eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201454:	00005697          	auipc	a3,0x5
ffffffffc0201458:	1ec68693          	addi	a3,a3,492 # ffffffffc0206640 <commands+0x9e8>
ffffffffc020145c:	00005617          	auipc	a2,0x5
ffffffffc0201460:	df460613          	addi	a2,a2,-524 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201464:	0e900593          	li	a1,233
ffffffffc0201468:	00005517          	auipc	a0,0x5
ffffffffc020146c:	07850513          	addi	a0,a0,120 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201470:	81eff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0201474:	00005697          	auipc	a3,0x5
ffffffffc0201478:	1ac68693          	addi	a3,a3,428 # ffffffffc0206620 <commands+0x9c8>
ffffffffc020147c:	00005617          	auipc	a2,0x5
ffffffffc0201480:	dd460613          	addi	a2,a2,-556 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201484:	0e000593          	li	a1,224
ffffffffc0201488:	00005517          	auipc	a0,0x5
ffffffffc020148c:	05850513          	addi	a0,a0,88 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201490:	ffffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc0201494:	00005697          	auipc	a3,0x5
ffffffffc0201498:	21c68693          	addi	a3,a3,540 # ffffffffc02066b0 <commands+0xa58>
ffffffffc020149c:	00005617          	auipc	a2,0x5
ffffffffc02014a0:	db460613          	addi	a2,a2,-588 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02014a4:	11800593          	li	a1,280
ffffffffc02014a8:	00005517          	auipc	a0,0x5
ffffffffc02014ac:	03850513          	addi	a0,a0,56 # ffffffffc02064e0 <commands+0x888>
ffffffffc02014b0:	fdffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02014b4:	00005697          	auipc	a3,0x5
ffffffffc02014b8:	1ec68693          	addi	a3,a3,492 # ffffffffc02066a0 <commands+0xa48>
ffffffffc02014bc:	00005617          	auipc	a2,0x5
ffffffffc02014c0:	d9460613          	addi	a2,a2,-620 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02014c4:	0fd00593          	li	a1,253
ffffffffc02014c8:	00005517          	auipc	a0,0x5
ffffffffc02014cc:	01850513          	addi	a0,a0,24 # ffffffffc02064e0 <commands+0x888>
ffffffffc02014d0:	fbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014d4:	00005697          	auipc	a3,0x5
ffffffffc02014d8:	16c68693          	addi	a3,a3,364 # ffffffffc0206640 <commands+0x9e8>
ffffffffc02014dc:	00005617          	auipc	a2,0x5
ffffffffc02014e0:	d7460613          	addi	a2,a2,-652 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02014e4:	0fb00593          	li	a1,251
ffffffffc02014e8:	00005517          	auipc	a0,0x5
ffffffffc02014ec:	ff850513          	addi	a0,a0,-8 # ffffffffc02064e0 <commands+0x888>
ffffffffc02014f0:	f9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02014f4:	00005697          	auipc	a3,0x5
ffffffffc02014f8:	18c68693          	addi	a3,a3,396 # ffffffffc0206680 <commands+0xa28>
ffffffffc02014fc:	00005617          	auipc	a2,0x5
ffffffffc0201500:	d5460613          	addi	a2,a2,-684 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201504:	0fa00593          	li	a1,250
ffffffffc0201508:	00005517          	auipc	a0,0x5
ffffffffc020150c:	fd850513          	addi	a0,a0,-40 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201510:	f7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201514:	00005697          	auipc	a3,0x5
ffffffffc0201518:	00468693          	addi	a3,a3,4 # ffffffffc0206518 <commands+0x8c0>
ffffffffc020151c:	00005617          	auipc	a2,0x5
ffffffffc0201520:	d3460613          	addi	a2,a2,-716 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201524:	0d700593          	li	a1,215
ffffffffc0201528:	00005517          	auipc	a0,0x5
ffffffffc020152c:	fb850513          	addi	a0,a0,-72 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201530:	f5ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201534:	00005697          	auipc	a3,0x5
ffffffffc0201538:	10c68693          	addi	a3,a3,268 # ffffffffc0206640 <commands+0x9e8>
ffffffffc020153c:	00005617          	auipc	a2,0x5
ffffffffc0201540:	d1460613          	addi	a2,a2,-748 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201544:	0f400593          	li	a1,244
ffffffffc0201548:	00005517          	auipc	a0,0x5
ffffffffc020154c:	f9850513          	addi	a0,a0,-104 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201550:	f3ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201554:	00005697          	auipc	a3,0x5
ffffffffc0201558:	00468693          	addi	a3,a3,4 # ffffffffc0206558 <commands+0x900>
ffffffffc020155c:	00005617          	auipc	a2,0x5
ffffffffc0201560:	cf460613          	addi	a2,a2,-780 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201564:	0f200593          	li	a1,242
ffffffffc0201568:	00005517          	auipc	a0,0x5
ffffffffc020156c:	f7850513          	addi	a0,a0,-136 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201570:	f1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201574:	00005697          	auipc	a3,0x5
ffffffffc0201578:	fc468693          	addi	a3,a3,-60 # ffffffffc0206538 <commands+0x8e0>
ffffffffc020157c:	00005617          	auipc	a2,0x5
ffffffffc0201580:	cd460613          	addi	a2,a2,-812 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201584:	0f100593          	li	a1,241
ffffffffc0201588:	00005517          	auipc	a0,0x5
ffffffffc020158c:	f5850513          	addi	a0,a0,-168 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201590:	efffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201594:	00005697          	auipc	a3,0x5
ffffffffc0201598:	fc468693          	addi	a3,a3,-60 # ffffffffc0206558 <commands+0x900>
ffffffffc020159c:	00005617          	auipc	a2,0x5
ffffffffc02015a0:	cb460613          	addi	a2,a2,-844 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02015a4:	0d900593          	li	a1,217
ffffffffc02015a8:	00005517          	auipc	a0,0x5
ffffffffc02015ac:	f3850513          	addi	a0,a0,-200 # ffffffffc02064e0 <commands+0x888>
ffffffffc02015b0:	edffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc02015b4:	00005697          	auipc	a3,0x5
ffffffffc02015b8:	24c68693          	addi	a3,a3,588 # ffffffffc0206800 <commands+0xba8>
ffffffffc02015bc:	00005617          	auipc	a2,0x5
ffffffffc02015c0:	c9460613          	addi	a2,a2,-876 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02015c4:	14600593          	li	a1,326
ffffffffc02015c8:	00005517          	auipc	a0,0x5
ffffffffc02015cc:	f1850513          	addi	a0,a0,-232 # ffffffffc02064e0 <commands+0x888>
ffffffffc02015d0:	ebffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc02015d4:	00005697          	auipc	a3,0x5
ffffffffc02015d8:	0cc68693          	addi	a3,a3,204 # ffffffffc02066a0 <commands+0xa48>
ffffffffc02015dc:	00005617          	auipc	a2,0x5
ffffffffc02015e0:	c7460613          	addi	a2,a2,-908 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02015e4:	13a00593          	li	a1,314
ffffffffc02015e8:	00005517          	auipc	a0,0x5
ffffffffc02015ec:	ef850513          	addi	a0,a0,-264 # ffffffffc02064e0 <commands+0x888>
ffffffffc02015f0:	e9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02015f4:	00005697          	auipc	a3,0x5
ffffffffc02015f8:	04c68693          	addi	a3,a3,76 # ffffffffc0206640 <commands+0x9e8>
ffffffffc02015fc:	00005617          	auipc	a2,0x5
ffffffffc0201600:	c5460613          	addi	a2,a2,-940 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201604:	13800593          	li	a1,312
ffffffffc0201608:	00005517          	auipc	a0,0x5
ffffffffc020160c:	ed850513          	addi	a0,a0,-296 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201610:	e7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201614:	00005697          	auipc	a3,0x5
ffffffffc0201618:	fec68693          	addi	a3,a3,-20 # ffffffffc0206600 <commands+0x9a8>
ffffffffc020161c:	00005617          	auipc	a2,0x5
ffffffffc0201620:	c3460613          	addi	a2,a2,-972 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201624:	0df00593          	li	a1,223
ffffffffc0201628:	00005517          	auipc	a0,0x5
ffffffffc020162c:	eb850513          	addi	a0,a0,-328 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201630:	e5ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201634:	00005697          	auipc	a3,0x5
ffffffffc0201638:	18c68693          	addi	a3,a3,396 # ffffffffc02067c0 <commands+0xb68>
ffffffffc020163c:	00005617          	auipc	a2,0x5
ffffffffc0201640:	c1460613          	addi	a2,a2,-1004 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201644:	13200593          	li	a1,306
ffffffffc0201648:	00005517          	auipc	a0,0x5
ffffffffc020164c:	e9850513          	addi	a0,a0,-360 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201650:	e3ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201654:	00005697          	auipc	a3,0x5
ffffffffc0201658:	14c68693          	addi	a3,a3,332 # ffffffffc02067a0 <commands+0xb48>
ffffffffc020165c:	00005617          	auipc	a2,0x5
ffffffffc0201660:	bf460613          	addi	a2,a2,-1036 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201664:	13000593          	li	a1,304
ffffffffc0201668:	00005517          	auipc	a0,0x5
ffffffffc020166c:	e7850513          	addi	a0,a0,-392 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201670:	e1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201674:	00005697          	auipc	a3,0x5
ffffffffc0201678:	10468693          	addi	a3,a3,260 # ffffffffc0206778 <commands+0xb20>
ffffffffc020167c:	00005617          	auipc	a2,0x5
ffffffffc0201680:	bd460613          	addi	a2,a2,-1068 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201684:	12e00593          	li	a1,302
ffffffffc0201688:	00005517          	auipc	a0,0x5
ffffffffc020168c:	e5850513          	addi	a0,a0,-424 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201690:	dfffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201694:	00005697          	auipc	a3,0x5
ffffffffc0201698:	0bc68693          	addi	a3,a3,188 # ffffffffc0206750 <commands+0xaf8>
ffffffffc020169c:	00005617          	auipc	a2,0x5
ffffffffc02016a0:	bb460613          	addi	a2,a2,-1100 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02016a4:	12d00593          	li	a1,301
ffffffffc02016a8:	00005517          	auipc	a0,0x5
ffffffffc02016ac:	e3850513          	addi	a0,a0,-456 # ffffffffc02064e0 <commands+0x888>
ffffffffc02016b0:	ddffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc02016b4:	00005697          	auipc	a3,0x5
ffffffffc02016b8:	08c68693          	addi	a3,a3,140 # ffffffffc0206740 <commands+0xae8>
ffffffffc02016bc:	00005617          	auipc	a2,0x5
ffffffffc02016c0:	b9460613          	addi	a2,a2,-1132 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02016c4:	12800593          	li	a1,296
ffffffffc02016c8:	00005517          	auipc	a0,0x5
ffffffffc02016cc:	e1850513          	addi	a0,a0,-488 # ffffffffc02064e0 <commands+0x888>
ffffffffc02016d0:	dbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016d4:	00005697          	auipc	a3,0x5
ffffffffc02016d8:	f6c68693          	addi	a3,a3,-148 # ffffffffc0206640 <commands+0x9e8>
ffffffffc02016dc:	00005617          	auipc	a2,0x5
ffffffffc02016e0:	b7460613          	addi	a2,a2,-1164 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02016e4:	12700593          	li	a1,295
ffffffffc02016e8:	00005517          	auipc	a0,0x5
ffffffffc02016ec:	df850513          	addi	a0,a0,-520 # ffffffffc02064e0 <commands+0x888>
ffffffffc02016f0:	d9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02016f4:	00005697          	auipc	a3,0x5
ffffffffc02016f8:	02c68693          	addi	a3,a3,44 # ffffffffc0206720 <commands+0xac8>
ffffffffc02016fc:	00005617          	auipc	a2,0x5
ffffffffc0201700:	b5460613          	addi	a2,a2,-1196 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201704:	12600593          	li	a1,294
ffffffffc0201708:	00005517          	auipc	a0,0x5
ffffffffc020170c:	dd850513          	addi	a0,a0,-552 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201710:	d7ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201714:	00005697          	auipc	a3,0x5
ffffffffc0201718:	fdc68693          	addi	a3,a3,-36 # ffffffffc02066f0 <commands+0xa98>
ffffffffc020171c:	00005617          	auipc	a2,0x5
ffffffffc0201720:	b3460613          	addi	a2,a2,-1228 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201724:	12500593          	li	a1,293
ffffffffc0201728:	00005517          	auipc	a0,0x5
ffffffffc020172c:	db850513          	addi	a0,a0,-584 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201730:	d5ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201734:	00005697          	auipc	a3,0x5
ffffffffc0201738:	fa468693          	addi	a3,a3,-92 # ffffffffc02066d8 <commands+0xa80>
ffffffffc020173c:	00005617          	auipc	a2,0x5
ffffffffc0201740:	b1460613          	addi	a2,a2,-1260 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201744:	12400593          	li	a1,292
ffffffffc0201748:	00005517          	auipc	a0,0x5
ffffffffc020174c:	d9850513          	addi	a0,a0,-616 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201750:	d3ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201754:	00005697          	auipc	a3,0x5
ffffffffc0201758:	eec68693          	addi	a3,a3,-276 # ffffffffc0206640 <commands+0x9e8>
ffffffffc020175c:	00005617          	auipc	a2,0x5
ffffffffc0201760:	af460613          	addi	a2,a2,-1292 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201764:	11e00593          	li	a1,286
ffffffffc0201768:	00005517          	auipc	a0,0x5
ffffffffc020176c:	d7850513          	addi	a0,a0,-648 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201770:	d1ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc0201774:	00005697          	auipc	a3,0x5
ffffffffc0201778:	f4c68693          	addi	a3,a3,-180 # ffffffffc02066c0 <commands+0xa68>
ffffffffc020177c:	00005617          	auipc	a2,0x5
ffffffffc0201780:	ad460613          	addi	a2,a2,-1324 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201784:	11900593          	li	a1,281
ffffffffc0201788:	00005517          	auipc	a0,0x5
ffffffffc020178c:	d5850513          	addi	a0,a0,-680 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201790:	cfffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0201794:	00005697          	auipc	a3,0x5
ffffffffc0201798:	04c68693          	addi	a3,a3,76 # ffffffffc02067e0 <commands+0xb88>
ffffffffc020179c:	00005617          	auipc	a2,0x5
ffffffffc02017a0:	ab460613          	addi	a2,a2,-1356 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02017a4:	13700593          	li	a1,311
ffffffffc02017a8:	00005517          	auipc	a0,0x5
ffffffffc02017ac:	d3850513          	addi	a0,a0,-712 # ffffffffc02064e0 <commands+0x888>
ffffffffc02017b0:	cdffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc02017b4:	00005697          	auipc	a3,0x5
ffffffffc02017b8:	05c68693          	addi	a3,a3,92 # ffffffffc0206810 <commands+0xbb8>
ffffffffc02017bc:	00005617          	auipc	a2,0x5
ffffffffc02017c0:	a9460613          	addi	a2,a2,-1388 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02017c4:	14700593          	li	a1,327
ffffffffc02017c8:	00005517          	auipc	a0,0x5
ffffffffc02017cc:	d1850513          	addi	a0,a0,-744 # ffffffffc02064e0 <commands+0x888>
ffffffffc02017d0:	cbffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc02017d4:	00005697          	auipc	a3,0x5
ffffffffc02017d8:	d2468693          	addi	a3,a3,-732 # ffffffffc02064f8 <commands+0x8a0>
ffffffffc02017dc:	00005617          	auipc	a2,0x5
ffffffffc02017e0:	a7460613          	addi	a2,a2,-1420 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02017e4:	11300593          	li	a1,275
ffffffffc02017e8:	00005517          	auipc	a0,0x5
ffffffffc02017ec:	cf850513          	addi	a0,a0,-776 # ffffffffc02064e0 <commands+0x888>
ffffffffc02017f0:	c9ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02017f4:	00005697          	auipc	a3,0x5
ffffffffc02017f8:	d4468693          	addi	a3,a3,-700 # ffffffffc0206538 <commands+0x8e0>
ffffffffc02017fc:	00005617          	auipc	a2,0x5
ffffffffc0201800:	a5460613          	addi	a2,a2,-1452 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201804:	0d800593          	li	a1,216
ffffffffc0201808:	00005517          	auipc	a0,0x5
ffffffffc020180c:	cd850513          	addi	a0,a0,-808 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201810:	c7ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201814 <default_free_pages>:
{
ffffffffc0201814:	1141                	addi	sp,sp,-16
ffffffffc0201816:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201818:	14058463          	beqz	a1,ffffffffc0201960 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc020181c:	00659693          	slli	a3,a1,0x6
ffffffffc0201820:	96aa                	add	a3,a3,a0
ffffffffc0201822:	87aa                	mv	a5,a0
ffffffffc0201824:	02d50263          	beq	a0,a3,ffffffffc0201848 <default_free_pages+0x34>
ffffffffc0201828:	6798                	ld	a4,8(a5)
ffffffffc020182a:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020182c:	10071a63          	bnez	a4,ffffffffc0201940 <default_free_pages+0x12c>
ffffffffc0201830:	6798                	ld	a4,8(a5)
ffffffffc0201832:	8b09                	andi	a4,a4,2
ffffffffc0201834:	10071663          	bnez	a4,ffffffffc0201940 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0201838:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc020183c:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201840:	04078793          	addi	a5,a5,64
ffffffffc0201844:	fed792e3          	bne	a5,a3,ffffffffc0201828 <default_free_pages+0x14>
    base->property = n;
ffffffffc0201848:	2581                	sext.w	a1,a1
ffffffffc020184a:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020184c:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201850:	4789                	li	a5,2
ffffffffc0201852:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201856:	000af697          	auipc	a3,0xaf
ffffffffc020185a:	74268693          	addi	a3,a3,1858 # ffffffffc02b0f98 <free_area>
ffffffffc020185e:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201860:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201862:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201866:	9db9                	addw	a1,a1,a4
ffffffffc0201868:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc020186a:	0ad78463          	beq	a5,a3,ffffffffc0201912 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc020186e:	fe878713          	addi	a4,a5,-24
ffffffffc0201872:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201876:	4581                	li	a1,0
            if (base < page)
ffffffffc0201878:	00e56a63          	bltu	a0,a4,ffffffffc020188c <default_free_pages+0x78>
    return listelm->next;
ffffffffc020187c:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc020187e:	04d70c63          	beq	a4,a3,ffffffffc02018d6 <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc0201882:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201884:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201888:	fee57ae3          	bgeu	a0,a4,ffffffffc020187c <default_free_pages+0x68>
ffffffffc020188c:	c199                	beqz	a1,ffffffffc0201892 <default_free_pages+0x7e>
ffffffffc020188e:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201892:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201894:	e390                	sd	a2,0(a5)
ffffffffc0201896:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201898:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020189a:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc020189c:	00d70d63          	beq	a4,a3,ffffffffc02018b6 <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc02018a0:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc02018a4:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc02018a8:	02059813          	slli	a6,a1,0x20
ffffffffc02018ac:	01a85793          	srli	a5,a6,0x1a
ffffffffc02018b0:	97b2                	add	a5,a5,a2
ffffffffc02018b2:	02f50c63          	beq	a0,a5,ffffffffc02018ea <default_free_pages+0xd6>
    return listelm->next;
ffffffffc02018b6:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc02018b8:	00d78c63          	beq	a5,a3,ffffffffc02018d0 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc02018bc:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc02018be:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc02018c2:	02061593          	slli	a1,a2,0x20
ffffffffc02018c6:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02018ca:	972a                	add	a4,a4,a0
ffffffffc02018cc:	04e68a63          	beq	a3,a4,ffffffffc0201920 <default_free_pages+0x10c>
}
ffffffffc02018d0:	60a2                	ld	ra,8(sp)
ffffffffc02018d2:	0141                	addi	sp,sp,16
ffffffffc02018d4:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02018d6:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02018d8:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02018da:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02018dc:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc02018de:	02d70763          	beq	a4,a3,ffffffffc020190c <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc02018e2:	8832                	mv	a6,a2
ffffffffc02018e4:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc02018e6:	87ba                	mv	a5,a4
ffffffffc02018e8:	bf71                	j	ffffffffc0201884 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc02018ea:	491c                	lw	a5,16(a0)
ffffffffc02018ec:	9dbd                	addw	a1,a1,a5
ffffffffc02018ee:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02018f2:	57f5                	li	a5,-3
ffffffffc02018f4:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02018f8:	01853803          	ld	a6,24(a0)
ffffffffc02018fc:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc02018fe:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201900:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201904:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0201906:	0105b023          	sd	a6,0(a1)
ffffffffc020190a:	b77d                	j	ffffffffc02018b8 <default_free_pages+0xa4>
ffffffffc020190c:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc020190e:	873e                	mv	a4,a5
ffffffffc0201910:	bf41                	j	ffffffffc02018a0 <default_free_pages+0x8c>
}
ffffffffc0201912:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201914:	e390                	sd	a2,0(a5)
ffffffffc0201916:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201918:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020191a:	ed1c                	sd	a5,24(a0)
ffffffffc020191c:	0141                	addi	sp,sp,16
ffffffffc020191e:	8082                	ret
            base->property += p->property;
ffffffffc0201920:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201924:	ff078693          	addi	a3,a5,-16
ffffffffc0201928:	9e39                	addw	a2,a2,a4
ffffffffc020192a:	c910                	sw	a2,16(a0)
ffffffffc020192c:	5775                	li	a4,-3
ffffffffc020192e:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201932:	6398                	ld	a4,0(a5)
ffffffffc0201934:	679c                	ld	a5,8(a5)
}
ffffffffc0201936:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0201938:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020193a:	e398                	sd	a4,0(a5)
ffffffffc020193c:	0141                	addi	sp,sp,16
ffffffffc020193e:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201940:	00005697          	auipc	a3,0x5
ffffffffc0201944:	ee868693          	addi	a3,a3,-280 # ffffffffc0206828 <commands+0xbd0>
ffffffffc0201948:	00005617          	auipc	a2,0x5
ffffffffc020194c:	90860613          	addi	a2,a2,-1784 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201950:	09400593          	li	a1,148
ffffffffc0201954:	00005517          	auipc	a0,0x5
ffffffffc0201958:	b8c50513          	addi	a0,a0,-1140 # ffffffffc02064e0 <commands+0x888>
ffffffffc020195c:	b33fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201960:	00005697          	auipc	a3,0x5
ffffffffc0201964:	ec068693          	addi	a3,a3,-320 # ffffffffc0206820 <commands+0xbc8>
ffffffffc0201968:	00005617          	auipc	a2,0x5
ffffffffc020196c:	8e860613          	addi	a2,a2,-1816 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201970:	09000593          	li	a1,144
ffffffffc0201974:	00005517          	auipc	a0,0x5
ffffffffc0201978:	b6c50513          	addi	a0,a0,-1172 # ffffffffc02064e0 <commands+0x888>
ffffffffc020197c:	b13fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201980 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201980:	c941                	beqz	a0,ffffffffc0201a10 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0201982:	000af597          	auipc	a1,0xaf
ffffffffc0201986:	61658593          	addi	a1,a1,1558 # ffffffffc02b0f98 <free_area>
ffffffffc020198a:	0105a803          	lw	a6,16(a1)
ffffffffc020198e:	872a                	mv	a4,a0
ffffffffc0201990:	02081793          	slli	a5,a6,0x20
ffffffffc0201994:	9381                	srli	a5,a5,0x20
ffffffffc0201996:	00a7ee63          	bltu	a5,a0,ffffffffc02019b2 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc020199a:	87ae                	mv	a5,a1
ffffffffc020199c:	a801                	j	ffffffffc02019ac <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc020199e:	ff87a683          	lw	a3,-8(a5)
ffffffffc02019a2:	02069613          	slli	a2,a3,0x20
ffffffffc02019a6:	9201                	srli	a2,a2,0x20
ffffffffc02019a8:	00e67763          	bgeu	a2,a4,ffffffffc02019b6 <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc02019ac:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc02019ae:	feb798e3          	bne	a5,a1,ffffffffc020199e <default_alloc_pages+0x1e>
        return NULL;
ffffffffc02019b2:	4501                	li	a0,0
}
ffffffffc02019b4:	8082                	ret
    return listelm->prev;
ffffffffc02019b6:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02019ba:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02019be:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc02019c2:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc02019c6:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc02019ca:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc02019ce:	02c77863          	bgeu	a4,a2,ffffffffc02019fe <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc02019d2:	071a                	slli	a4,a4,0x6
ffffffffc02019d4:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02019d6:	41c686bb          	subw	a3,a3,t3
ffffffffc02019da:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019dc:	00870613          	addi	a2,a4,8
ffffffffc02019e0:	4689                	li	a3,2
ffffffffc02019e2:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02019e6:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02019ea:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc02019ee:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02019f2:	e290                	sd	a2,0(a3)
ffffffffc02019f4:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02019f8:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc02019fa:	01173c23          	sd	a7,24(a4)
ffffffffc02019fe:	41c8083b          	subw	a6,a6,t3
ffffffffc0201a02:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201a06:	5775                	li	a4,-3
ffffffffc0201a08:	17c1                	addi	a5,a5,-16
ffffffffc0201a0a:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201a0e:	8082                	ret
{
ffffffffc0201a10:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201a12:	00005697          	auipc	a3,0x5
ffffffffc0201a16:	e0e68693          	addi	a3,a3,-498 # ffffffffc0206820 <commands+0xbc8>
ffffffffc0201a1a:	00005617          	auipc	a2,0x5
ffffffffc0201a1e:	83660613          	addi	a2,a2,-1994 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201a22:	06c00593          	li	a1,108
ffffffffc0201a26:	00005517          	auipc	a0,0x5
ffffffffc0201a2a:	aba50513          	addi	a0,a0,-1350 # ffffffffc02064e0 <commands+0x888>
{
ffffffffc0201a2e:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a30:	a5ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a34 <default_init_memmap>:
{
ffffffffc0201a34:	1141                	addi	sp,sp,-16
ffffffffc0201a36:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201a38:	c5f1                	beqz	a1,ffffffffc0201b04 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0201a3a:	00659693          	slli	a3,a1,0x6
ffffffffc0201a3e:	96aa                	add	a3,a3,a0
ffffffffc0201a40:	87aa                	mv	a5,a0
ffffffffc0201a42:	00d50f63          	beq	a0,a3,ffffffffc0201a60 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201a46:	6798                	ld	a4,8(a5)
ffffffffc0201a48:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0201a4a:	cf49                	beqz	a4,ffffffffc0201ae4 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0201a4c:	0007a823          	sw	zero,16(a5)
ffffffffc0201a50:	0007b423          	sd	zero,8(a5)
ffffffffc0201a54:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0201a58:	04078793          	addi	a5,a5,64
ffffffffc0201a5c:	fed795e3          	bne	a5,a3,ffffffffc0201a46 <default_init_memmap+0x12>
    base->property = n;
ffffffffc0201a60:	2581                	sext.w	a1,a1
ffffffffc0201a62:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201a64:	4789                	li	a5,2
ffffffffc0201a66:	00850713          	addi	a4,a0,8
ffffffffc0201a6a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0201a6e:	000af697          	auipc	a3,0xaf
ffffffffc0201a72:	52a68693          	addi	a3,a3,1322 # ffffffffc02b0f98 <free_area>
ffffffffc0201a76:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201a78:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201a7a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201a7e:	9db9                	addw	a1,a1,a4
ffffffffc0201a80:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0201a82:	04d78a63          	beq	a5,a3,ffffffffc0201ad6 <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0201a86:	fe878713          	addi	a4,a5,-24
ffffffffc0201a8a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0201a8e:	4581                	li	a1,0
            if (base < page)
ffffffffc0201a90:	00e56a63          	bltu	a0,a4,ffffffffc0201aa4 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0201a94:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0201a96:	02d70263          	beq	a4,a3,ffffffffc0201aba <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0201a9a:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a9c:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201aa0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201a94 <default_init_memmap+0x60>
ffffffffc0201aa4:	c199                	beqz	a1,ffffffffc0201aaa <default_init_memmap+0x76>
ffffffffc0201aa6:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201aaa:	6398                	ld	a4,0(a5)
}
ffffffffc0201aac:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201aae:	e390                	sd	a2,0(a5)
ffffffffc0201ab0:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201ab2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201ab4:	ed18                	sd	a4,24(a0)
ffffffffc0201ab6:	0141                	addi	sp,sp,16
ffffffffc0201ab8:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201aba:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201abc:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201abe:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201ac0:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201ac2:	00d70663          	beq	a4,a3,ffffffffc0201ace <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201ac6:	8832                	mv	a6,a2
ffffffffc0201ac8:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201aca:	87ba                	mv	a5,a4
ffffffffc0201acc:	bfc1                	j	ffffffffc0201a9c <default_init_memmap+0x68>
}
ffffffffc0201ace:	60a2                	ld	ra,8(sp)
ffffffffc0201ad0:	e290                	sd	a2,0(a3)
ffffffffc0201ad2:	0141                	addi	sp,sp,16
ffffffffc0201ad4:	8082                	ret
ffffffffc0201ad6:	60a2                	ld	ra,8(sp)
ffffffffc0201ad8:	e390                	sd	a2,0(a5)
ffffffffc0201ada:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201adc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201ade:	ed1c                	sd	a5,24(a0)
ffffffffc0201ae0:	0141                	addi	sp,sp,16
ffffffffc0201ae2:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201ae4:	00005697          	auipc	a3,0x5
ffffffffc0201ae8:	d6c68693          	addi	a3,a3,-660 # ffffffffc0206850 <commands+0xbf8>
ffffffffc0201aec:	00004617          	auipc	a2,0x4
ffffffffc0201af0:	76460613          	addi	a2,a2,1892 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201af4:	04b00593          	li	a1,75
ffffffffc0201af8:	00005517          	auipc	a0,0x5
ffffffffc0201afc:	9e850513          	addi	a0,a0,-1560 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201b00:	98ffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201b04:	00005697          	auipc	a3,0x5
ffffffffc0201b08:	d1c68693          	addi	a3,a3,-740 # ffffffffc0206820 <commands+0xbc8>
ffffffffc0201b0c:	00004617          	auipc	a2,0x4
ffffffffc0201b10:	74460613          	addi	a2,a2,1860 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201b14:	04700593          	li	a1,71
ffffffffc0201b18:	00005517          	auipc	a0,0x5
ffffffffc0201b1c:	9c850513          	addi	a0,a0,-1592 # ffffffffc02064e0 <commands+0x888>
ffffffffc0201b20:	96ffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201b24 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201b24:	c94d                	beqz	a0,ffffffffc0201bd6 <slob_free+0xb2>
{
ffffffffc0201b26:	1141                	addi	sp,sp,-16
ffffffffc0201b28:	e022                	sd	s0,0(sp)
ffffffffc0201b2a:	e406                	sd	ra,8(sp)
ffffffffc0201b2c:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201b2e:	e9c1                	bnez	a1,ffffffffc0201bbe <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b30:	100027f3          	csrr	a5,sstatus
ffffffffc0201b34:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b36:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b38:	ebd9                	bnez	a5,ffffffffc0201bce <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b3a:	000af617          	auipc	a2,0xaf
ffffffffc0201b3e:	04e60613          	addi	a2,a2,78 # ffffffffc02b0b88 <slobfree>
ffffffffc0201b42:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b44:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201b46:	679c                	ld	a5,8(a5)
ffffffffc0201b48:	02877a63          	bgeu	a4,s0,ffffffffc0201b7c <slob_free+0x58>
ffffffffc0201b4c:	00f46463          	bltu	s0,a5,ffffffffc0201b54 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b50:	fef76ae3          	bltu	a4,a5,ffffffffc0201b44 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201b54:	400c                	lw	a1,0(s0)
ffffffffc0201b56:	00459693          	slli	a3,a1,0x4
ffffffffc0201b5a:	96a2                	add	a3,a3,s0
ffffffffc0201b5c:	02d78a63          	beq	a5,a3,ffffffffc0201b90 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201b60:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201b62:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b64:	00469793          	slli	a5,a3,0x4
ffffffffc0201b68:	97ba                	add	a5,a5,a4
ffffffffc0201b6a:	02f40e63          	beq	s0,a5,ffffffffc0201ba6 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201b6e:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201b70:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201b72:	e129                	bnez	a0,ffffffffc0201bb4 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201b74:	60a2                	ld	ra,8(sp)
ffffffffc0201b76:	6402                	ld	s0,0(sp)
ffffffffc0201b78:	0141                	addi	sp,sp,16
ffffffffc0201b7a:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201b7c:	fcf764e3          	bltu	a4,a5,ffffffffc0201b44 <slob_free+0x20>
ffffffffc0201b80:	fcf472e3          	bgeu	s0,a5,ffffffffc0201b44 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201b84:	400c                	lw	a1,0(s0)
ffffffffc0201b86:	00459693          	slli	a3,a1,0x4
ffffffffc0201b8a:	96a2                	add	a3,a3,s0
ffffffffc0201b8c:	fcd79ae3          	bne	a5,a3,ffffffffc0201b60 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201b90:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201b92:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201b94:	9db5                	addw	a1,a1,a3
ffffffffc0201b96:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201b98:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201b9a:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b9c:	00469793          	slli	a5,a3,0x4
ffffffffc0201ba0:	97ba                	add	a5,a5,a4
ffffffffc0201ba2:	fcf416e3          	bne	s0,a5,ffffffffc0201b6e <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201ba6:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201ba8:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201baa:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201bac:	9ebd                	addw	a3,a3,a5
ffffffffc0201bae:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201bb0:	e70c                	sd	a1,8(a4)
ffffffffc0201bb2:	d169                	beqz	a0,ffffffffc0201b74 <slob_free+0x50>
}
ffffffffc0201bb4:	6402                	ld	s0,0(sp)
ffffffffc0201bb6:	60a2                	ld	ra,8(sp)
ffffffffc0201bb8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201bba:	df5fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201bbe:	25bd                	addiw	a1,a1,15
ffffffffc0201bc0:	8191                	srli	a1,a1,0x4
ffffffffc0201bc2:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bc4:	100027f3          	csrr	a5,sstatus
ffffffffc0201bc8:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201bca:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bcc:	d7bd                	beqz	a5,ffffffffc0201b3a <slob_free+0x16>
        intr_disable();
ffffffffc0201bce:	de7fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201bd2:	4505                	li	a0,1
ffffffffc0201bd4:	b79d                	j	ffffffffc0201b3a <slob_free+0x16>
ffffffffc0201bd6:	8082                	ret

ffffffffc0201bd8 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bd8:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201bda:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201bdc:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201be0:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201be2:	352000ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
	if (!page)
ffffffffc0201be6:	c91d                	beqz	a0,ffffffffc0201c1c <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201be8:	000b3697          	auipc	a3,0xb3
ffffffffc0201bec:	4206b683          	ld	a3,1056(a3) # ffffffffc02b5008 <pages>
ffffffffc0201bf0:	8d15                	sub	a0,a0,a3
ffffffffc0201bf2:	8519                	srai	a0,a0,0x6
ffffffffc0201bf4:	00006697          	auipc	a3,0x6
ffffffffc0201bf8:	1246b683          	ld	a3,292(a3) # ffffffffc0207d18 <nbase>
ffffffffc0201bfc:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201bfe:	00c51793          	slli	a5,a0,0xc
ffffffffc0201c02:	83b1                	srli	a5,a5,0xc
ffffffffc0201c04:	000b3717          	auipc	a4,0xb3
ffffffffc0201c08:	3fc73703          	ld	a4,1020(a4) # ffffffffc02b5000 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201c0c:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201c0e:	00e7fa63          	bgeu	a5,a4,ffffffffc0201c22 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201c12:	000b3697          	auipc	a3,0xb3
ffffffffc0201c16:	4066b683          	ld	a3,1030(a3) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0201c1a:	9536                	add	a0,a0,a3
}
ffffffffc0201c1c:	60a2                	ld	ra,8(sp)
ffffffffc0201c1e:	0141                	addi	sp,sp,16
ffffffffc0201c20:	8082                	ret
ffffffffc0201c22:	86aa                	mv	a3,a0
ffffffffc0201c24:	00005617          	auipc	a2,0x5
ffffffffc0201c28:	c8c60613          	addi	a2,a2,-884 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc0201c2c:	07100593          	li	a1,113
ffffffffc0201c30:	00005517          	auipc	a0,0x5
ffffffffc0201c34:	ca850513          	addi	a0,a0,-856 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0201c38:	857fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c3c <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201c3c:	1101                	addi	sp,sp,-32
ffffffffc0201c3e:	ec06                	sd	ra,24(sp)
ffffffffc0201c40:	e822                	sd	s0,16(sp)
ffffffffc0201c42:	e426                	sd	s1,8(sp)
ffffffffc0201c44:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c46:	01050713          	addi	a4,a0,16
ffffffffc0201c4a:	6785                	lui	a5,0x1
ffffffffc0201c4c:	0cf77363          	bgeu	a4,a5,ffffffffc0201d12 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201c50:	00f50493          	addi	s1,a0,15
ffffffffc0201c54:	8091                	srli	s1,s1,0x4
ffffffffc0201c56:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c58:	10002673          	csrr	a2,sstatus
ffffffffc0201c5c:	8a09                	andi	a2,a2,2
ffffffffc0201c5e:	e25d                	bnez	a2,ffffffffc0201d04 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201c60:	000af917          	auipc	s2,0xaf
ffffffffc0201c64:	f2890913          	addi	s2,s2,-216 # ffffffffc02b0b88 <slobfree>
ffffffffc0201c68:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c6c:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201c6e:	4398                	lw	a4,0(a5)
ffffffffc0201c70:	08975e63          	bge	a4,s1,ffffffffc0201d0c <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201c74:	00f68b63          	beq	a3,a5,ffffffffc0201c8a <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c78:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c7a:	4018                	lw	a4,0(s0)
ffffffffc0201c7c:	02975a63          	bge	a4,s1,ffffffffc0201cb0 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201c80:	00093683          	ld	a3,0(s2)
ffffffffc0201c84:	87a2                	mv	a5,s0
ffffffffc0201c86:	fef699e3          	bne	a3,a5,ffffffffc0201c78 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201c8a:	ee31                	bnez	a2,ffffffffc0201ce6 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201c8c:	4501                	li	a0,0
ffffffffc0201c8e:	f4bff0ef          	jal	ra,ffffffffc0201bd8 <__slob_get_free_pages.constprop.0>
ffffffffc0201c92:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201c94:	cd05                	beqz	a0,ffffffffc0201ccc <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201c96:	6585                	lui	a1,0x1
ffffffffc0201c98:	e8dff0ef          	jal	ra,ffffffffc0201b24 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c9c:	10002673          	csrr	a2,sstatus
ffffffffc0201ca0:	8a09                	andi	a2,a2,2
ffffffffc0201ca2:	ee05                	bnez	a2,ffffffffc0201cda <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201ca4:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201ca8:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201caa:	4018                	lw	a4,0(s0)
ffffffffc0201cac:	fc974ae3          	blt	a4,s1,ffffffffc0201c80 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201cb0:	04e48763          	beq	s1,a4,ffffffffc0201cfe <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201cb4:	00449693          	slli	a3,s1,0x4
ffffffffc0201cb8:	96a2                	add	a3,a3,s0
ffffffffc0201cba:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201cbc:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201cbe:	9f05                	subw	a4,a4,s1
ffffffffc0201cc0:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201cc2:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201cc4:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201cc6:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201cca:	e20d                	bnez	a2,ffffffffc0201cec <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201ccc:	60e2                	ld	ra,24(sp)
ffffffffc0201cce:	8522                	mv	a0,s0
ffffffffc0201cd0:	6442                	ld	s0,16(sp)
ffffffffc0201cd2:	64a2                	ld	s1,8(sp)
ffffffffc0201cd4:	6902                	ld	s2,0(sp)
ffffffffc0201cd6:	6105                	addi	sp,sp,32
ffffffffc0201cd8:	8082                	ret
        intr_disable();
ffffffffc0201cda:	cdbfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201cde:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201ce2:	4605                	li	a2,1
ffffffffc0201ce4:	b7d1                	j	ffffffffc0201ca8 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201ce6:	cc9fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201cea:	b74d                	j	ffffffffc0201c8c <slob_alloc.constprop.0+0x50>
ffffffffc0201cec:	cc3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201cf0:	60e2                	ld	ra,24(sp)
ffffffffc0201cf2:	8522                	mv	a0,s0
ffffffffc0201cf4:	6442                	ld	s0,16(sp)
ffffffffc0201cf6:	64a2                	ld	s1,8(sp)
ffffffffc0201cf8:	6902                	ld	s2,0(sp)
ffffffffc0201cfa:	6105                	addi	sp,sp,32
ffffffffc0201cfc:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201cfe:	6418                	ld	a4,8(s0)
ffffffffc0201d00:	e798                	sd	a4,8(a5)
ffffffffc0201d02:	b7d1                	j	ffffffffc0201cc6 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201d04:	cb1fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201d08:	4605                	li	a2,1
ffffffffc0201d0a:	bf99                	j	ffffffffc0201c60 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201d0c:	843e                	mv	s0,a5
ffffffffc0201d0e:	87b6                	mv	a5,a3
ffffffffc0201d10:	b745                	j	ffffffffc0201cb0 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201d12:	00005697          	auipc	a3,0x5
ffffffffc0201d16:	bd668693          	addi	a3,a3,-1066 # ffffffffc02068e8 <default_pmm_manager+0x70>
ffffffffc0201d1a:	00004617          	auipc	a2,0x4
ffffffffc0201d1e:	53660613          	addi	a2,a2,1334 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0201d22:	06300593          	li	a1,99
ffffffffc0201d26:	00005517          	auipc	a0,0x5
ffffffffc0201d2a:	be250513          	addi	a0,a0,-1054 # ffffffffc0206908 <default_pmm_manager+0x90>
ffffffffc0201d2e:	f60fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201d32 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201d32:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201d34:	00005517          	auipc	a0,0x5
ffffffffc0201d38:	bec50513          	addi	a0,a0,-1044 # ffffffffc0206920 <default_pmm_manager+0xa8>
{
ffffffffc0201d3c:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201d3e:	c56fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201d42:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d44:	00005517          	auipc	a0,0x5
ffffffffc0201d48:	bf450513          	addi	a0,a0,-1036 # ffffffffc0206938 <default_pmm_manager+0xc0>
}
ffffffffc0201d4c:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201d4e:	c46fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201d52 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201d52:	4501                	li	a0,0
ffffffffc0201d54:	8082                	ret

ffffffffc0201d56 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201d56:	1101                	addi	sp,sp,-32
ffffffffc0201d58:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d5a:	6905                	lui	s2,0x1
{
ffffffffc0201d5c:	e822                	sd	s0,16(sp)
ffffffffc0201d5e:	ec06                	sd	ra,24(sp)
ffffffffc0201d60:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d62:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bb9>
{
ffffffffc0201d66:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201d68:	04a7f963          	bgeu	a5,a0,ffffffffc0201dba <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201d6c:	4561                	li	a0,24
ffffffffc0201d6e:	ecfff0ef          	jal	ra,ffffffffc0201c3c <slob_alloc.constprop.0>
ffffffffc0201d72:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201d74:	c929                	beqz	a0,ffffffffc0201dc6 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201d76:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201d7a:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201d7c:	00f95763          	bge	s2,a5,ffffffffc0201d8a <kmalloc+0x34>
ffffffffc0201d80:	6705                	lui	a4,0x1
ffffffffc0201d82:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201d84:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201d86:	fef74ee3          	blt	a4,a5,ffffffffc0201d82 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201d8a:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201d8c:	e4dff0ef          	jal	ra,ffffffffc0201bd8 <__slob_get_free_pages.constprop.0>
ffffffffc0201d90:	e488                	sd	a0,8(s1)
ffffffffc0201d92:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201d94:	c525                	beqz	a0,ffffffffc0201dfc <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d96:	100027f3          	csrr	a5,sstatus
ffffffffc0201d9a:	8b89                	andi	a5,a5,2
ffffffffc0201d9c:	ef8d                	bnez	a5,ffffffffc0201dd6 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201d9e:	000b3797          	auipc	a5,0xb3
ffffffffc0201da2:	24a78793          	addi	a5,a5,586 # ffffffffc02b4fe8 <bigblocks>
ffffffffc0201da6:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201da8:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201daa:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201dac:	60e2                	ld	ra,24(sp)
ffffffffc0201dae:	8522                	mv	a0,s0
ffffffffc0201db0:	6442                	ld	s0,16(sp)
ffffffffc0201db2:	64a2                	ld	s1,8(sp)
ffffffffc0201db4:	6902                	ld	s2,0(sp)
ffffffffc0201db6:	6105                	addi	sp,sp,32
ffffffffc0201db8:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201dba:	0541                	addi	a0,a0,16
ffffffffc0201dbc:	e81ff0ef          	jal	ra,ffffffffc0201c3c <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201dc0:	01050413          	addi	s0,a0,16
ffffffffc0201dc4:	f565                	bnez	a0,ffffffffc0201dac <kmalloc+0x56>
ffffffffc0201dc6:	4401                	li	s0,0
}
ffffffffc0201dc8:	60e2                	ld	ra,24(sp)
ffffffffc0201dca:	8522                	mv	a0,s0
ffffffffc0201dcc:	6442                	ld	s0,16(sp)
ffffffffc0201dce:	64a2                	ld	s1,8(sp)
ffffffffc0201dd0:	6902                	ld	s2,0(sp)
ffffffffc0201dd2:	6105                	addi	sp,sp,32
ffffffffc0201dd4:	8082                	ret
        intr_disable();
ffffffffc0201dd6:	bdffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201dda:	000b3797          	auipc	a5,0xb3
ffffffffc0201dde:	20e78793          	addi	a5,a5,526 # ffffffffc02b4fe8 <bigblocks>
ffffffffc0201de2:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201de4:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201de6:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201de8:	bc7fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201dec:	6480                	ld	s0,8(s1)
}
ffffffffc0201dee:	60e2                	ld	ra,24(sp)
ffffffffc0201df0:	64a2                	ld	s1,8(sp)
ffffffffc0201df2:	8522                	mv	a0,s0
ffffffffc0201df4:	6442                	ld	s0,16(sp)
ffffffffc0201df6:	6902                	ld	s2,0(sp)
ffffffffc0201df8:	6105                	addi	sp,sp,32
ffffffffc0201dfa:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201dfc:	45e1                	li	a1,24
ffffffffc0201dfe:	8526                	mv	a0,s1
ffffffffc0201e00:	d25ff0ef          	jal	ra,ffffffffc0201b24 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201e04:	b765                	j	ffffffffc0201dac <kmalloc+0x56>

ffffffffc0201e06 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201e06:	c169                	beqz	a0,ffffffffc0201ec8 <kfree+0xc2>
{
ffffffffc0201e08:	1101                	addi	sp,sp,-32
ffffffffc0201e0a:	e822                	sd	s0,16(sp)
ffffffffc0201e0c:	ec06                	sd	ra,24(sp)
ffffffffc0201e0e:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201e10:	03451793          	slli	a5,a0,0x34
ffffffffc0201e14:	842a                	mv	s0,a0
ffffffffc0201e16:	e3d9                	bnez	a5,ffffffffc0201e9c <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e18:	100027f3          	csrr	a5,sstatus
ffffffffc0201e1c:	8b89                	andi	a5,a5,2
ffffffffc0201e1e:	e7d9                	bnez	a5,ffffffffc0201eac <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e20:	000b3797          	auipc	a5,0xb3
ffffffffc0201e24:	1c87b783          	ld	a5,456(a5) # ffffffffc02b4fe8 <bigblocks>
    return 0;
ffffffffc0201e28:	4601                	li	a2,0
ffffffffc0201e2a:	cbad                	beqz	a5,ffffffffc0201e9c <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201e2c:	000b3697          	auipc	a3,0xb3
ffffffffc0201e30:	1bc68693          	addi	a3,a3,444 # ffffffffc02b4fe8 <bigblocks>
ffffffffc0201e34:	a021                	j	ffffffffc0201e3c <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e36:	01048693          	addi	a3,s1,16
ffffffffc0201e3a:	c3a5                	beqz	a5,ffffffffc0201e9a <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201e3c:	6798                	ld	a4,8(a5)
ffffffffc0201e3e:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201e40:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201e42:	fe871ae3          	bne	a4,s0,ffffffffc0201e36 <kfree+0x30>
				*last = bb->next;
ffffffffc0201e46:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201e48:	ee2d                	bnez	a2,ffffffffc0201ec2 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201e4a:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201e4e:	4098                	lw	a4,0(s1)
ffffffffc0201e50:	08f46963          	bltu	s0,a5,ffffffffc0201ee2 <kfree+0xdc>
ffffffffc0201e54:	000b3697          	auipc	a3,0xb3
ffffffffc0201e58:	1c46b683          	ld	a3,452(a3) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0201e5c:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201e5e:	8031                	srli	s0,s0,0xc
ffffffffc0201e60:	000b3797          	auipc	a5,0xb3
ffffffffc0201e64:	1a07b783          	ld	a5,416(a5) # ffffffffc02b5000 <npage>
ffffffffc0201e68:	06f47163          	bgeu	s0,a5,ffffffffc0201eca <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201e6c:	00006517          	auipc	a0,0x6
ffffffffc0201e70:	eac53503          	ld	a0,-340(a0) # ffffffffc0207d18 <nbase>
ffffffffc0201e74:	8c09                	sub	s0,s0,a0
ffffffffc0201e76:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201e78:	000b3517          	auipc	a0,0xb3
ffffffffc0201e7c:	19053503          	ld	a0,400(a0) # ffffffffc02b5008 <pages>
ffffffffc0201e80:	4585                	li	a1,1
ffffffffc0201e82:	9522                	add	a0,a0,s0
ffffffffc0201e84:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201e88:	0ea000ef          	jal	ra,ffffffffc0201f72 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201e8c:	6442                	ld	s0,16(sp)
ffffffffc0201e8e:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e90:	8526                	mv	a0,s1
}
ffffffffc0201e92:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201e94:	45e1                	li	a1,24
}
ffffffffc0201e96:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e98:	b171                	j	ffffffffc0201b24 <slob_free>
ffffffffc0201e9a:	e20d                	bnez	a2,ffffffffc0201ebc <kfree+0xb6>
ffffffffc0201e9c:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201ea0:	6442                	ld	s0,16(sp)
ffffffffc0201ea2:	60e2                	ld	ra,24(sp)
ffffffffc0201ea4:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201ea6:	4581                	li	a1,0
}
ffffffffc0201ea8:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201eaa:	b9ad                	j	ffffffffc0201b24 <slob_free>
        intr_disable();
ffffffffc0201eac:	b09fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201eb0:	000b3797          	auipc	a5,0xb3
ffffffffc0201eb4:	1387b783          	ld	a5,312(a5) # ffffffffc02b4fe8 <bigblocks>
        return 1;
ffffffffc0201eb8:	4605                	li	a2,1
ffffffffc0201eba:	fbad                	bnez	a5,ffffffffc0201e2c <kfree+0x26>
        intr_enable();
ffffffffc0201ebc:	af3fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201ec0:	bff1                	j	ffffffffc0201e9c <kfree+0x96>
ffffffffc0201ec2:	aedfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201ec6:	b751                	j	ffffffffc0201e4a <kfree+0x44>
ffffffffc0201ec8:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201eca:	00005617          	auipc	a2,0x5
ffffffffc0201ece:	ab660613          	addi	a2,a2,-1354 # ffffffffc0206980 <default_pmm_manager+0x108>
ffffffffc0201ed2:	06900593          	li	a1,105
ffffffffc0201ed6:	00005517          	auipc	a0,0x5
ffffffffc0201eda:	a0250513          	addi	a0,a0,-1534 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0201ede:	db0fe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201ee2:	86a2                	mv	a3,s0
ffffffffc0201ee4:	00005617          	auipc	a2,0x5
ffffffffc0201ee8:	a7460613          	addi	a2,a2,-1420 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc0201eec:	07700593          	li	a1,119
ffffffffc0201ef0:	00005517          	auipc	a0,0x5
ffffffffc0201ef4:	9e850513          	addi	a0,a0,-1560 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0201ef8:	d96fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201efc <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201efc:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201efe:	00005617          	auipc	a2,0x5
ffffffffc0201f02:	a8260613          	addi	a2,a2,-1406 # ffffffffc0206980 <default_pmm_manager+0x108>
ffffffffc0201f06:	06900593          	li	a1,105
ffffffffc0201f0a:	00005517          	auipc	a0,0x5
ffffffffc0201f0e:	9ce50513          	addi	a0,a0,-1586 # ffffffffc02068d8 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201f12:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201f14:	d7afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201f18 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201f18:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201f1a:	00005617          	auipc	a2,0x5
ffffffffc0201f1e:	a8660613          	addi	a2,a2,-1402 # ffffffffc02069a0 <default_pmm_manager+0x128>
ffffffffc0201f22:	07f00593          	li	a1,127
ffffffffc0201f26:	00005517          	auipc	a0,0x5
ffffffffc0201f2a:	9b250513          	addi	a0,a0,-1614 # ffffffffc02068d8 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201f2e:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201f30:	d5efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201f34 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f34:	100027f3          	csrr	a5,sstatus
ffffffffc0201f38:	8b89                	andi	a5,a5,2
ffffffffc0201f3a:	e799                	bnez	a5,ffffffffc0201f48 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f3c:	000b3797          	auipc	a5,0xb3
ffffffffc0201f40:	0d47b783          	ld	a5,212(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f44:	6f9c                	ld	a5,24(a5)
ffffffffc0201f46:	8782                	jr	a5
{
ffffffffc0201f48:	1141                	addi	sp,sp,-16
ffffffffc0201f4a:	e406                	sd	ra,8(sp)
ffffffffc0201f4c:	e022                	sd	s0,0(sp)
ffffffffc0201f4e:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201f50:	a65fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f54:	000b3797          	auipc	a5,0xb3
ffffffffc0201f58:	0bc7b783          	ld	a5,188(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f5c:	6f9c                	ld	a5,24(a5)
ffffffffc0201f5e:	8522                	mv	a0,s0
ffffffffc0201f60:	9782                	jalr	a5
ffffffffc0201f62:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f64:	a4bfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201f68:	60a2                	ld	ra,8(sp)
ffffffffc0201f6a:	8522                	mv	a0,s0
ffffffffc0201f6c:	6402                	ld	s0,0(sp)
ffffffffc0201f6e:	0141                	addi	sp,sp,16
ffffffffc0201f70:	8082                	ret

ffffffffc0201f72 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f72:	100027f3          	csrr	a5,sstatus
ffffffffc0201f76:	8b89                	andi	a5,a5,2
ffffffffc0201f78:	e799                	bnez	a5,ffffffffc0201f86 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201f7a:	000b3797          	auipc	a5,0xb3
ffffffffc0201f7e:	0967b783          	ld	a5,150(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f82:	739c                	ld	a5,32(a5)
ffffffffc0201f84:	8782                	jr	a5
{
ffffffffc0201f86:	1101                	addi	sp,sp,-32
ffffffffc0201f88:	ec06                	sd	ra,24(sp)
ffffffffc0201f8a:	e822                	sd	s0,16(sp)
ffffffffc0201f8c:	e426                	sd	s1,8(sp)
ffffffffc0201f8e:	842a                	mv	s0,a0
ffffffffc0201f90:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201f92:	a23fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f96:	000b3797          	auipc	a5,0xb3
ffffffffc0201f9a:	07a7b783          	ld	a5,122(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f9e:	739c                	ld	a5,32(a5)
ffffffffc0201fa0:	85a6                	mv	a1,s1
ffffffffc0201fa2:	8522                	mv	a0,s0
ffffffffc0201fa4:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201fa6:	6442                	ld	s0,16(sp)
ffffffffc0201fa8:	60e2                	ld	ra,24(sp)
ffffffffc0201faa:	64a2                	ld	s1,8(sp)
ffffffffc0201fac:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201fae:	a01fe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201fb2 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201fb2:	100027f3          	csrr	a5,sstatus
ffffffffc0201fb6:	8b89                	andi	a5,a5,2
ffffffffc0201fb8:	e799                	bnez	a5,ffffffffc0201fc6 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201fba:	000b3797          	auipc	a5,0xb3
ffffffffc0201fbe:	0567b783          	ld	a5,86(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201fc2:	779c                	ld	a5,40(a5)
ffffffffc0201fc4:	8782                	jr	a5
{
ffffffffc0201fc6:	1141                	addi	sp,sp,-16
ffffffffc0201fc8:	e406                	sd	ra,8(sp)
ffffffffc0201fca:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201fcc:	9e9fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201fd0:	000b3797          	auipc	a5,0xb3
ffffffffc0201fd4:	0407b783          	ld	a5,64(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201fd8:	779c                	ld	a5,40(a5)
ffffffffc0201fda:	9782                	jalr	a5
ffffffffc0201fdc:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201fde:	9d1fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201fe2:	60a2                	ld	ra,8(sp)
ffffffffc0201fe4:	8522                	mv	a0,s0
ffffffffc0201fe6:	6402                	ld	s0,0(sp)
ffffffffc0201fe8:	0141                	addi	sp,sp,16
ffffffffc0201fea:	8082                	ret

ffffffffc0201fec <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201fec:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201ff0:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201ff4:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201ff6:	078e                	slli	a5,a5,0x3
{
ffffffffc0201ff8:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201ffa:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201ffe:	6094                	ld	a3,0(s1)
{
ffffffffc0202000:	f04a                	sd	s2,32(sp)
ffffffffc0202002:	ec4e                	sd	s3,24(sp)
ffffffffc0202004:	e852                	sd	s4,16(sp)
ffffffffc0202006:	fc06                	sd	ra,56(sp)
ffffffffc0202008:	f822                	sd	s0,48(sp)
ffffffffc020200a:	e456                	sd	s5,8(sp)
ffffffffc020200c:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc020200e:	0016f793          	andi	a5,a3,1
{
ffffffffc0202012:	892e                	mv	s2,a1
ffffffffc0202014:	8a32                	mv	s4,a2
ffffffffc0202016:	000b3997          	auipc	s3,0xb3
ffffffffc020201a:	fea98993          	addi	s3,s3,-22 # ffffffffc02b5000 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc020201e:	efbd                	bnez	a5,ffffffffc020209c <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202020:	14060c63          	beqz	a2,ffffffffc0202178 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202024:	100027f3          	csrr	a5,sstatus
ffffffffc0202028:	8b89                	andi	a5,a5,2
ffffffffc020202a:	14079963          	bnez	a5,ffffffffc020217c <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc020202e:	000b3797          	auipc	a5,0xb3
ffffffffc0202032:	fe27b783          	ld	a5,-30(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0202036:	6f9c                	ld	a5,24(a5)
ffffffffc0202038:	4505                	li	a0,1
ffffffffc020203a:	9782                	jalr	a5
ffffffffc020203c:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc020203e:	12040d63          	beqz	s0,ffffffffc0202178 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202042:	000b3b17          	auipc	s6,0xb3
ffffffffc0202046:	fc6b0b13          	addi	s6,s6,-58 # ffffffffc02b5008 <pages>
ffffffffc020204a:	000b3503          	ld	a0,0(s6)
ffffffffc020204e:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202052:	000b3997          	auipc	s3,0xb3
ffffffffc0202056:	fae98993          	addi	s3,s3,-82 # ffffffffc02b5000 <npage>
ffffffffc020205a:	40a40533          	sub	a0,s0,a0
ffffffffc020205e:	8519                	srai	a0,a0,0x6
ffffffffc0202060:	9556                	add	a0,a0,s5
ffffffffc0202062:	0009b703          	ld	a4,0(s3)
ffffffffc0202066:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc020206a:	4685                	li	a3,1
ffffffffc020206c:	c014                	sw	a3,0(s0)
ffffffffc020206e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202070:	0532                	slli	a0,a0,0xc
ffffffffc0202072:	16e7f763          	bgeu	a5,a4,ffffffffc02021e0 <get_pte+0x1f4>
ffffffffc0202076:	000b3797          	auipc	a5,0xb3
ffffffffc020207a:	fa27b783          	ld	a5,-94(a5) # ffffffffc02b5018 <va_pa_offset>
ffffffffc020207e:	6605                	lui	a2,0x1
ffffffffc0202080:	4581                	li	a1,0
ffffffffc0202082:	953e                	add	a0,a0,a5
ffffffffc0202084:	141030ef          	jal	ra,ffffffffc02059c4 <memset>
    return page - pages + nbase;
ffffffffc0202088:	000b3683          	ld	a3,0(s6)
ffffffffc020208c:	40d406b3          	sub	a3,s0,a3
ffffffffc0202090:	8699                	srai	a3,a3,0x6
ffffffffc0202092:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202094:	06aa                	slli	a3,a3,0xa
ffffffffc0202096:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020209a:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020209c:	77fd                	lui	a5,0xfffff
ffffffffc020209e:	068a                	slli	a3,a3,0x2
ffffffffc02020a0:	0009b703          	ld	a4,0(s3)
ffffffffc02020a4:	8efd                	and	a3,a3,a5
ffffffffc02020a6:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020aa:	10e7ff63          	bgeu	a5,a4,ffffffffc02021c8 <get_pte+0x1dc>
ffffffffc02020ae:	000b3a97          	auipc	s5,0xb3
ffffffffc02020b2:	f6aa8a93          	addi	s5,s5,-150 # ffffffffc02b5018 <va_pa_offset>
ffffffffc02020b6:	000ab403          	ld	s0,0(s5)
ffffffffc02020ba:	01595793          	srli	a5,s2,0x15
ffffffffc02020be:	1ff7f793          	andi	a5,a5,511
ffffffffc02020c2:	96a2                	add	a3,a3,s0
ffffffffc02020c4:	00379413          	slli	s0,a5,0x3
ffffffffc02020c8:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc02020ca:	6014                	ld	a3,0(s0)
ffffffffc02020cc:	0016f793          	andi	a5,a3,1
ffffffffc02020d0:	ebad                	bnez	a5,ffffffffc0202142 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020d2:	0a0a0363          	beqz	s4,ffffffffc0202178 <get_pte+0x18c>
ffffffffc02020d6:	100027f3          	csrr	a5,sstatus
ffffffffc02020da:	8b89                	andi	a5,a5,2
ffffffffc02020dc:	efcd                	bnez	a5,ffffffffc0202196 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020de:	000b3797          	auipc	a5,0xb3
ffffffffc02020e2:	f327b783          	ld	a5,-206(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc02020e6:	6f9c                	ld	a5,24(a5)
ffffffffc02020e8:	4505                	li	a0,1
ffffffffc02020ea:	9782                	jalr	a5
ffffffffc02020ec:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02020ee:	c4c9                	beqz	s1,ffffffffc0202178 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02020f0:	000b3b17          	auipc	s6,0xb3
ffffffffc02020f4:	f18b0b13          	addi	s6,s6,-232 # ffffffffc02b5008 <pages>
ffffffffc02020f8:	000b3503          	ld	a0,0(s6)
ffffffffc02020fc:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202100:	0009b703          	ld	a4,0(s3)
ffffffffc0202104:	40a48533          	sub	a0,s1,a0
ffffffffc0202108:	8519                	srai	a0,a0,0x6
ffffffffc020210a:	9552                	add	a0,a0,s4
ffffffffc020210c:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202110:	4685                	li	a3,1
ffffffffc0202112:	c094                	sw	a3,0(s1)
ffffffffc0202114:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202116:	0532                	slli	a0,a0,0xc
ffffffffc0202118:	0ee7f163          	bgeu	a5,a4,ffffffffc02021fa <get_pte+0x20e>
ffffffffc020211c:	000ab783          	ld	a5,0(s5)
ffffffffc0202120:	6605                	lui	a2,0x1
ffffffffc0202122:	4581                	li	a1,0
ffffffffc0202124:	953e                	add	a0,a0,a5
ffffffffc0202126:	09f030ef          	jal	ra,ffffffffc02059c4 <memset>
    return page - pages + nbase;
ffffffffc020212a:	000b3683          	ld	a3,0(s6)
ffffffffc020212e:	40d486b3          	sub	a3,s1,a3
ffffffffc0202132:	8699                	srai	a3,a3,0x6
ffffffffc0202134:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202136:	06aa                	slli	a3,a3,0xa
ffffffffc0202138:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020213c:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020213e:	0009b703          	ld	a4,0(s3)
ffffffffc0202142:	068a                	slli	a3,a3,0x2
ffffffffc0202144:	757d                	lui	a0,0xfffff
ffffffffc0202146:	8ee9                	and	a3,a3,a0
ffffffffc0202148:	00c6d793          	srli	a5,a3,0xc
ffffffffc020214c:	06e7f263          	bgeu	a5,a4,ffffffffc02021b0 <get_pte+0x1c4>
ffffffffc0202150:	000ab503          	ld	a0,0(s5)
ffffffffc0202154:	00c95913          	srli	s2,s2,0xc
ffffffffc0202158:	1ff97913          	andi	s2,s2,511
ffffffffc020215c:	96aa                	add	a3,a3,a0
ffffffffc020215e:	00391513          	slli	a0,s2,0x3
ffffffffc0202162:	9536                	add	a0,a0,a3
}
ffffffffc0202164:	70e2                	ld	ra,56(sp)
ffffffffc0202166:	7442                	ld	s0,48(sp)
ffffffffc0202168:	74a2                	ld	s1,40(sp)
ffffffffc020216a:	7902                	ld	s2,32(sp)
ffffffffc020216c:	69e2                	ld	s3,24(sp)
ffffffffc020216e:	6a42                	ld	s4,16(sp)
ffffffffc0202170:	6aa2                	ld	s5,8(sp)
ffffffffc0202172:	6b02                	ld	s6,0(sp)
ffffffffc0202174:	6121                	addi	sp,sp,64
ffffffffc0202176:	8082                	ret
            return NULL;
ffffffffc0202178:	4501                	li	a0,0
ffffffffc020217a:	b7ed                	j	ffffffffc0202164 <get_pte+0x178>
        intr_disable();
ffffffffc020217c:	839fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202180:	000b3797          	auipc	a5,0xb3
ffffffffc0202184:	e907b783          	ld	a5,-368(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0202188:	6f9c                	ld	a5,24(a5)
ffffffffc020218a:	4505                	li	a0,1
ffffffffc020218c:	9782                	jalr	a5
ffffffffc020218e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202190:	81ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202194:	b56d                	j	ffffffffc020203e <get_pte+0x52>
        intr_disable();
ffffffffc0202196:	81ffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc020219a:	000b3797          	auipc	a5,0xb3
ffffffffc020219e:	e767b783          	ld	a5,-394(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc02021a2:	6f9c                	ld	a5,24(a5)
ffffffffc02021a4:	4505                	li	a0,1
ffffffffc02021a6:	9782                	jalr	a5
ffffffffc02021a8:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc02021aa:	805fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02021ae:	b781                	j	ffffffffc02020ee <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02021b0:	00004617          	auipc	a2,0x4
ffffffffc02021b4:	70060613          	addi	a2,a2,1792 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc02021b8:	0fa00593          	li	a1,250
ffffffffc02021bc:	00005517          	auipc	a0,0x5
ffffffffc02021c0:	80c50513          	addi	a0,a0,-2036 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02021c4:	acafe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02021c8:	00004617          	auipc	a2,0x4
ffffffffc02021cc:	6e860613          	addi	a2,a2,1768 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc02021d0:	0ed00593          	li	a1,237
ffffffffc02021d4:	00004517          	auipc	a0,0x4
ffffffffc02021d8:	7f450513          	addi	a0,a0,2036 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02021dc:	ab2fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021e0:	86aa                	mv	a3,a0
ffffffffc02021e2:	00004617          	auipc	a2,0x4
ffffffffc02021e6:	6ce60613          	addi	a2,a2,1742 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc02021ea:	0e900593          	li	a1,233
ffffffffc02021ee:	00004517          	auipc	a0,0x4
ffffffffc02021f2:	7da50513          	addi	a0,a0,2010 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02021f6:	a98fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02021fa:	86aa                	mv	a3,a0
ffffffffc02021fc:	00004617          	auipc	a2,0x4
ffffffffc0202200:	6b460613          	addi	a2,a2,1716 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc0202204:	0f700593          	li	a1,247
ffffffffc0202208:	00004517          	auipc	a0,0x4
ffffffffc020220c:	7c050513          	addi	a0,a0,1984 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202210:	a7efe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202214 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202214:	1141                	addi	sp,sp,-16
ffffffffc0202216:	e022                	sd	s0,0(sp)
ffffffffc0202218:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020221a:	4601                	li	a2,0
{
ffffffffc020221c:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020221e:	dcfff0ef          	jal	ra,ffffffffc0201fec <get_pte>
    if (ptep_store != NULL)
ffffffffc0202222:	c011                	beqz	s0,ffffffffc0202226 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202224:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202226:	c511                	beqz	a0,ffffffffc0202232 <get_page+0x1e>
ffffffffc0202228:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020222a:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020222c:	0017f713          	andi	a4,a5,1
ffffffffc0202230:	e709                	bnez	a4,ffffffffc020223a <get_page+0x26>
}
ffffffffc0202232:	60a2                	ld	ra,8(sp)
ffffffffc0202234:	6402                	ld	s0,0(sp)
ffffffffc0202236:	0141                	addi	sp,sp,16
ffffffffc0202238:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020223a:	078a                	slli	a5,a5,0x2
ffffffffc020223c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020223e:	000b3717          	auipc	a4,0xb3
ffffffffc0202242:	dc273703          	ld	a4,-574(a4) # ffffffffc02b5000 <npage>
ffffffffc0202246:	00e7ff63          	bgeu	a5,a4,ffffffffc0202264 <get_page+0x50>
ffffffffc020224a:	60a2                	ld	ra,8(sp)
ffffffffc020224c:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc020224e:	fff80537          	lui	a0,0xfff80
ffffffffc0202252:	97aa                	add	a5,a5,a0
ffffffffc0202254:	079a                	slli	a5,a5,0x6
ffffffffc0202256:	000b3517          	auipc	a0,0xb3
ffffffffc020225a:	db253503          	ld	a0,-590(a0) # ffffffffc02b5008 <pages>
ffffffffc020225e:	953e                	add	a0,a0,a5
ffffffffc0202260:	0141                	addi	sp,sp,16
ffffffffc0202262:	8082                	ret
ffffffffc0202264:	c99ff0ef          	jal	ra,ffffffffc0201efc <pa2page.part.0>

ffffffffc0202268 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0202268:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020226a:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020226e:	f486                	sd	ra,104(sp)
ffffffffc0202270:	f0a2                	sd	s0,96(sp)
ffffffffc0202272:	eca6                	sd	s1,88(sp)
ffffffffc0202274:	e8ca                	sd	s2,80(sp)
ffffffffc0202276:	e4ce                	sd	s3,72(sp)
ffffffffc0202278:	e0d2                	sd	s4,64(sp)
ffffffffc020227a:	fc56                	sd	s5,56(sp)
ffffffffc020227c:	f85a                	sd	s6,48(sp)
ffffffffc020227e:	f45e                	sd	s7,40(sp)
ffffffffc0202280:	f062                	sd	s8,32(sp)
ffffffffc0202282:	ec66                	sd	s9,24(sp)
ffffffffc0202284:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202286:	17d2                	slli	a5,a5,0x34
ffffffffc0202288:	e3ed                	bnez	a5,ffffffffc020236a <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc020228a:	002007b7          	lui	a5,0x200
ffffffffc020228e:	842e                	mv	s0,a1
ffffffffc0202290:	0ef5ed63          	bltu	a1,a5,ffffffffc020238a <unmap_range+0x122>
ffffffffc0202294:	8932                	mv	s2,a2
ffffffffc0202296:	0ec5fa63          	bgeu	a1,a2,ffffffffc020238a <unmap_range+0x122>
ffffffffc020229a:	4785                	li	a5,1
ffffffffc020229c:	07fe                	slli	a5,a5,0x1f
ffffffffc020229e:	0ec7e663          	bltu	a5,a2,ffffffffc020238a <unmap_range+0x122>
ffffffffc02022a2:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc02022a4:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc02022a6:	000b3c97          	auipc	s9,0xb3
ffffffffc02022aa:	d5ac8c93          	addi	s9,s9,-678 # ffffffffc02b5000 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02022ae:	000b3c17          	auipc	s8,0xb3
ffffffffc02022b2:	d5ac0c13          	addi	s8,s8,-678 # ffffffffc02b5008 <pages>
ffffffffc02022b6:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc02022ba:	000b3d17          	auipc	s10,0xb3
ffffffffc02022be:	d56d0d13          	addi	s10,s10,-682 # ffffffffc02b5010 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02022c2:	00200b37          	lui	s6,0x200
ffffffffc02022c6:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc02022ca:	4601                	li	a2,0
ffffffffc02022cc:	85a2                	mv	a1,s0
ffffffffc02022ce:	854e                	mv	a0,s3
ffffffffc02022d0:	d1dff0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc02022d4:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc02022d6:	cd29                	beqz	a0,ffffffffc0202330 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc02022d8:	611c                	ld	a5,0(a0)
ffffffffc02022da:	e395                	bnez	a5,ffffffffc02022fe <unmap_range+0x96>
        start += PGSIZE;
ffffffffc02022dc:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02022de:	ff2466e3          	bltu	s0,s2,ffffffffc02022ca <unmap_range+0x62>
}
ffffffffc02022e2:	70a6                	ld	ra,104(sp)
ffffffffc02022e4:	7406                	ld	s0,96(sp)
ffffffffc02022e6:	64e6                	ld	s1,88(sp)
ffffffffc02022e8:	6946                	ld	s2,80(sp)
ffffffffc02022ea:	69a6                	ld	s3,72(sp)
ffffffffc02022ec:	6a06                	ld	s4,64(sp)
ffffffffc02022ee:	7ae2                	ld	s5,56(sp)
ffffffffc02022f0:	7b42                	ld	s6,48(sp)
ffffffffc02022f2:	7ba2                	ld	s7,40(sp)
ffffffffc02022f4:	7c02                	ld	s8,32(sp)
ffffffffc02022f6:	6ce2                	ld	s9,24(sp)
ffffffffc02022f8:	6d42                	ld	s10,16(sp)
ffffffffc02022fa:	6165                	addi	sp,sp,112
ffffffffc02022fc:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02022fe:	0017f713          	andi	a4,a5,1
ffffffffc0202302:	df69                	beqz	a4,ffffffffc02022dc <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202304:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202308:	078a                	slli	a5,a5,0x2
ffffffffc020230a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020230c:	08e7ff63          	bgeu	a5,a4,ffffffffc02023aa <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202310:	000c3503          	ld	a0,0(s8)
ffffffffc0202314:	97de                	add	a5,a5,s7
ffffffffc0202316:	079a                	slli	a5,a5,0x6
ffffffffc0202318:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020231a:	411c                	lw	a5,0(a0)
ffffffffc020231c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202320:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202322:	cf11                	beqz	a4,ffffffffc020233e <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202324:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202328:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc020232c:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020232e:	bf45                	j	ffffffffc02022de <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202330:	945a                	add	s0,s0,s6
ffffffffc0202332:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc0202336:	d455                	beqz	s0,ffffffffc02022e2 <unmap_range+0x7a>
ffffffffc0202338:	f92469e3          	bltu	s0,s2,ffffffffc02022ca <unmap_range+0x62>
ffffffffc020233c:	b75d                	j	ffffffffc02022e2 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020233e:	100027f3          	csrr	a5,sstatus
ffffffffc0202342:	8b89                	andi	a5,a5,2
ffffffffc0202344:	e799                	bnez	a5,ffffffffc0202352 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc0202346:	000d3783          	ld	a5,0(s10)
ffffffffc020234a:	4585                	li	a1,1
ffffffffc020234c:	739c                	ld	a5,32(a5)
ffffffffc020234e:	9782                	jalr	a5
    if (flag)
ffffffffc0202350:	bfd1                	j	ffffffffc0202324 <unmap_range+0xbc>
ffffffffc0202352:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202354:	e60fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202358:	000d3783          	ld	a5,0(s10)
ffffffffc020235c:	6522                	ld	a0,8(sp)
ffffffffc020235e:	4585                	li	a1,1
ffffffffc0202360:	739c                	ld	a5,32(a5)
ffffffffc0202362:	9782                	jalr	a5
        intr_enable();
ffffffffc0202364:	e4afe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202368:	bf75                	j	ffffffffc0202324 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020236a:	00004697          	auipc	a3,0x4
ffffffffc020236e:	66e68693          	addi	a3,a3,1646 # ffffffffc02069d8 <default_pmm_manager+0x160>
ffffffffc0202372:	00004617          	auipc	a2,0x4
ffffffffc0202376:	ede60613          	addi	a2,a2,-290 # ffffffffc0206250 <commands+0x5f8>
ffffffffc020237a:	12000593          	li	a1,288
ffffffffc020237e:	00004517          	auipc	a0,0x4
ffffffffc0202382:	64a50513          	addi	a0,a0,1610 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202386:	908fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc020238a:	00004697          	auipc	a3,0x4
ffffffffc020238e:	67e68693          	addi	a3,a3,1662 # ffffffffc0206a08 <default_pmm_manager+0x190>
ffffffffc0202392:	00004617          	auipc	a2,0x4
ffffffffc0202396:	ebe60613          	addi	a2,a2,-322 # ffffffffc0206250 <commands+0x5f8>
ffffffffc020239a:	12100593          	li	a1,289
ffffffffc020239e:	00004517          	auipc	a0,0x4
ffffffffc02023a2:	62a50513          	addi	a0,a0,1578 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02023a6:	8e8fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc02023aa:	b53ff0ef          	jal	ra,ffffffffc0201efc <pa2page.part.0>

ffffffffc02023ae <exit_range>:
{
ffffffffc02023ae:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023b0:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02023b4:	fc86                	sd	ra,120(sp)
ffffffffc02023b6:	f8a2                	sd	s0,112(sp)
ffffffffc02023b8:	f4a6                	sd	s1,104(sp)
ffffffffc02023ba:	f0ca                	sd	s2,96(sp)
ffffffffc02023bc:	ecce                	sd	s3,88(sp)
ffffffffc02023be:	e8d2                	sd	s4,80(sp)
ffffffffc02023c0:	e4d6                	sd	s5,72(sp)
ffffffffc02023c2:	e0da                	sd	s6,64(sp)
ffffffffc02023c4:	fc5e                	sd	s7,56(sp)
ffffffffc02023c6:	f862                	sd	s8,48(sp)
ffffffffc02023c8:	f466                	sd	s9,40(sp)
ffffffffc02023ca:	f06a                	sd	s10,32(sp)
ffffffffc02023cc:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02023ce:	17d2                	slli	a5,a5,0x34
ffffffffc02023d0:	20079a63          	bnez	a5,ffffffffc02025e4 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc02023d4:	002007b7          	lui	a5,0x200
ffffffffc02023d8:	24f5e463          	bltu	a1,a5,ffffffffc0202620 <exit_range+0x272>
ffffffffc02023dc:	8ab2                	mv	s5,a2
ffffffffc02023de:	24c5f163          	bgeu	a1,a2,ffffffffc0202620 <exit_range+0x272>
ffffffffc02023e2:	4785                	li	a5,1
ffffffffc02023e4:	07fe                	slli	a5,a5,0x1f
ffffffffc02023e6:	22c7ed63          	bltu	a5,a2,ffffffffc0202620 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02023ea:	c00009b7          	lui	s3,0xc0000
ffffffffc02023ee:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02023f2:	ffe00937          	lui	s2,0xffe00
ffffffffc02023f6:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc02023fa:	5cfd                	li	s9,-1
ffffffffc02023fc:	8c2a                	mv	s8,a0
ffffffffc02023fe:	0125f933          	and	s2,a1,s2
ffffffffc0202402:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202404:	000b3d17          	auipc	s10,0xb3
ffffffffc0202408:	bfcd0d13          	addi	s10,s10,-1028 # ffffffffc02b5000 <npage>
    return KADDR(page2pa(page));
ffffffffc020240c:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202410:	000b3717          	auipc	a4,0xb3
ffffffffc0202414:	bf870713          	addi	a4,a4,-1032 # ffffffffc02b5008 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc0202418:	000b3d97          	auipc	s11,0xb3
ffffffffc020241c:	bf8d8d93          	addi	s11,s11,-1032 # ffffffffc02b5010 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202420:	c0000437          	lui	s0,0xc0000
ffffffffc0202424:	944e                	add	s0,s0,s3
ffffffffc0202426:	8079                	srli	s0,s0,0x1e
ffffffffc0202428:	1ff47413          	andi	s0,s0,511
ffffffffc020242c:	040e                	slli	s0,s0,0x3
ffffffffc020242e:	9462                	add	s0,s0,s8
ffffffffc0202430:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
        if (pde1 & PTE_V)
ffffffffc0202434:	001a7793          	andi	a5,s4,1
ffffffffc0202438:	eb99                	bnez	a5,ffffffffc020244e <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc020243a:	12098463          	beqz	s3,ffffffffc0202562 <exit_range+0x1b4>
ffffffffc020243e:	400007b7          	lui	a5,0x40000
ffffffffc0202442:	97ce                	add	a5,a5,s3
ffffffffc0202444:	894e                	mv	s2,s3
ffffffffc0202446:	1159fe63          	bgeu	s3,s5,ffffffffc0202562 <exit_range+0x1b4>
ffffffffc020244a:	89be                	mv	s3,a5
ffffffffc020244c:	bfd1                	j	ffffffffc0202420 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc020244e:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202452:	0a0a                	slli	s4,s4,0x2
ffffffffc0202454:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0202458:	1cfa7263          	bgeu	s4,a5,ffffffffc020261c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020245c:	fff80637          	lui	a2,0xfff80
ffffffffc0202460:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0202462:	000806b7          	lui	a3,0x80
ffffffffc0202466:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202468:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020246c:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020246e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202470:	18f5fa63          	bgeu	a1,a5,ffffffffc0202604 <exit_range+0x256>
ffffffffc0202474:	000b3817          	auipc	a6,0xb3
ffffffffc0202478:	ba480813          	addi	a6,a6,-1116 # ffffffffc02b5018 <va_pa_offset>
ffffffffc020247c:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc0202480:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0202482:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0202486:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0202488:	00080337          	lui	t1,0x80
ffffffffc020248c:	6885                	lui	a7,0x1
ffffffffc020248e:	a819                	j	ffffffffc02024a4 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc0202490:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0202492:	002007b7          	lui	a5,0x200
ffffffffc0202496:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202498:	08090c63          	beqz	s2,ffffffffc0202530 <exit_range+0x182>
ffffffffc020249c:	09397a63          	bgeu	s2,s3,ffffffffc0202530 <exit_range+0x182>
ffffffffc02024a0:	0f597063          	bgeu	s2,s5,ffffffffc0202580 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc02024a4:	01595493          	srli	s1,s2,0x15
ffffffffc02024a8:	1ff4f493          	andi	s1,s1,511
ffffffffc02024ac:	048e                	slli	s1,s1,0x3
ffffffffc02024ae:	94da                	add	s1,s1,s6
ffffffffc02024b0:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc02024b2:	0017f693          	andi	a3,a5,1
ffffffffc02024b6:	dee9                	beqz	a3,ffffffffc0202490 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc02024b8:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024bc:	078a                	slli	a5,a5,0x2
ffffffffc02024be:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024c0:	14b7fe63          	bgeu	a5,a1,ffffffffc020261c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02024c4:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc02024c6:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc02024ca:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02024ce:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02024d2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02024d4:	12bef863          	bgeu	t4,a1,ffffffffc0202604 <exit_range+0x256>
ffffffffc02024d8:	00083783          	ld	a5,0(a6)
ffffffffc02024dc:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024de:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc02024e2:	629c                	ld	a5,0(a3)
ffffffffc02024e4:	8b85                	andi	a5,a5,1
ffffffffc02024e6:	f7d5                	bnez	a5,ffffffffc0202492 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02024e8:	06a1                	addi	a3,a3,8
ffffffffc02024ea:	fed59ce3          	bne	a1,a3,ffffffffc02024e2 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc02024ee:	631c                	ld	a5,0(a4)
ffffffffc02024f0:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024f2:	100027f3          	csrr	a5,sstatus
ffffffffc02024f6:	8b89                	andi	a5,a5,2
ffffffffc02024f8:	e7d9                	bnez	a5,ffffffffc0202586 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc02024fa:	000db783          	ld	a5,0(s11)
ffffffffc02024fe:	4585                	li	a1,1
ffffffffc0202500:	e032                	sd	a2,0(sp)
ffffffffc0202502:	739c                	ld	a5,32(a5)
ffffffffc0202504:	9782                	jalr	a5
    if (flag)
ffffffffc0202506:	6602                	ld	a2,0(sp)
ffffffffc0202508:	000b3817          	auipc	a6,0xb3
ffffffffc020250c:	b1080813          	addi	a6,a6,-1264 # ffffffffc02b5018 <va_pa_offset>
ffffffffc0202510:	fff80e37          	lui	t3,0xfff80
ffffffffc0202514:	00080337          	lui	t1,0x80
ffffffffc0202518:	6885                	lui	a7,0x1
ffffffffc020251a:	000b3717          	auipc	a4,0xb3
ffffffffc020251e:	aee70713          	addi	a4,a4,-1298 # ffffffffc02b5008 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202522:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc0202526:	002007b7          	lui	a5,0x200
ffffffffc020252a:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc020252c:	f60918e3          	bnez	s2,ffffffffc020249c <exit_range+0xee>
            if (free_pd0)
ffffffffc0202530:	f00b85e3          	beqz	s7,ffffffffc020243a <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202534:	000d3783          	ld	a5,0(s10)
ffffffffc0202538:	0efa7263          	bgeu	s4,a5,ffffffffc020261c <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020253c:	6308                	ld	a0,0(a4)
ffffffffc020253e:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202540:	100027f3          	csrr	a5,sstatus
ffffffffc0202544:	8b89                	andi	a5,a5,2
ffffffffc0202546:	efad                	bnez	a5,ffffffffc02025c0 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0202548:	000db783          	ld	a5,0(s11)
ffffffffc020254c:	4585                	li	a1,1
ffffffffc020254e:	739c                	ld	a5,32(a5)
ffffffffc0202550:	9782                	jalr	a5
ffffffffc0202552:	000b3717          	auipc	a4,0xb3
ffffffffc0202556:	ab670713          	addi	a4,a4,-1354 # ffffffffc02b5008 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020255a:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc020255e:	ee0990e3          	bnez	s3,ffffffffc020243e <exit_range+0x90>
}
ffffffffc0202562:	70e6                	ld	ra,120(sp)
ffffffffc0202564:	7446                	ld	s0,112(sp)
ffffffffc0202566:	74a6                	ld	s1,104(sp)
ffffffffc0202568:	7906                	ld	s2,96(sp)
ffffffffc020256a:	69e6                	ld	s3,88(sp)
ffffffffc020256c:	6a46                	ld	s4,80(sp)
ffffffffc020256e:	6aa6                	ld	s5,72(sp)
ffffffffc0202570:	6b06                	ld	s6,64(sp)
ffffffffc0202572:	7be2                	ld	s7,56(sp)
ffffffffc0202574:	7c42                	ld	s8,48(sp)
ffffffffc0202576:	7ca2                	ld	s9,40(sp)
ffffffffc0202578:	7d02                	ld	s10,32(sp)
ffffffffc020257a:	6de2                	ld	s11,24(sp)
ffffffffc020257c:	6109                	addi	sp,sp,128
ffffffffc020257e:	8082                	ret
            if (free_pd0)
ffffffffc0202580:	ea0b8fe3          	beqz	s7,ffffffffc020243e <exit_range+0x90>
ffffffffc0202584:	bf45                	j	ffffffffc0202534 <exit_range+0x186>
ffffffffc0202586:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0202588:	e42a                	sd	a0,8(sp)
ffffffffc020258a:	c2afe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020258e:	000db783          	ld	a5,0(s11)
ffffffffc0202592:	6522                	ld	a0,8(sp)
ffffffffc0202594:	4585                	li	a1,1
ffffffffc0202596:	739c                	ld	a5,32(a5)
ffffffffc0202598:	9782                	jalr	a5
        intr_enable();
ffffffffc020259a:	c14fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020259e:	6602                	ld	a2,0(sp)
ffffffffc02025a0:	000b3717          	auipc	a4,0xb3
ffffffffc02025a4:	a6870713          	addi	a4,a4,-1432 # ffffffffc02b5008 <pages>
ffffffffc02025a8:	6885                	lui	a7,0x1
ffffffffc02025aa:	00080337          	lui	t1,0x80
ffffffffc02025ae:	fff80e37          	lui	t3,0xfff80
ffffffffc02025b2:	000b3817          	auipc	a6,0xb3
ffffffffc02025b6:	a6680813          	addi	a6,a6,-1434 # ffffffffc02b5018 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02025ba:	0004b023          	sd	zero,0(s1)
ffffffffc02025be:	b7a5                	j	ffffffffc0202526 <exit_range+0x178>
ffffffffc02025c0:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc02025c2:	bf2fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02025c6:	000db783          	ld	a5,0(s11)
ffffffffc02025ca:	6502                	ld	a0,0(sp)
ffffffffc02025cc:	4585                	li	a1,1
ffffffffc02025ce:	739c                	ld	a5,32(a5)
ffffffffc02025d0:	9782                	jalr	a5
        intr_enable();
ffffffffc02025d2:	bdcfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02025d6:	000b3717          	auipc	a4,0xb3
ffffffffc02025da:	a3270713          	addi	a4,a4,-1486 # ffffffffc02b5008 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02025de:	00043023          	sd	zero,0(s0)
ffffffffc02025e2:	bfb5                	j	ffffffffc020255e <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02025e4:	00004697          	auipc	a3,0x4
ffffffffc02025e8:	3f468693          	addi	a3,a3,1012 # ffffffffc02069d8 <default_pmm_manager+0x160>
ffffffffc02025ec:	00004617          	auipc	a2,0x4
ffffffffc02025f0:	c6460613          	addi	a2,a2,-924 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02025f4:	13500593          	li	a1,309
ffffffffc02025f8:	00004517          	auipc	a0,0x4
ffffffffc02025fc:	3d050513          	addi	a0,a0,976 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202600:	e8ffd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202604:	00004617          	auipc	a2,0x4
ffffffffc0202608:	2ac60613          	addi	a2,a2,684 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc020260c:	07100593          	li	a1,113
ffffffffc0202610:	00004517          	auipc	a0,0x4
ffffffffc0202614:	2c850513          	addi	a0,a0,712 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0202618:	e77fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020261c:	8e1ff0ef          	jal	ra,ffffffffc0201efc <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202620:	00004697          	auipc	a3,0x4
ffffffffc0202624:	3e868693          	addi	a3,a3,1000 # ffffffffc0206a08 <default_pmm_manager+0x190>
ffffffffc0202628:	00004617          	auipc	a2,0x4
ffffffffc020262c:	c2860613          	addi	a2,a2,-984 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202630:	13600593          	li	a1,310
ffffffffc0202634:	00004517          	auipc	a0,0x4
ffffffffc0202638:	39450513          	addi	a0,a0,916 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020263c:	e53fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202640 <page_remove>:
{
ffffffffc0202640:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202642:	4601                	li	a2,0
{
ffffffffc0202644:	ec26                	sd	s1,24(sp)
ffffffffc0202646:	f406                	sd	ra,40(sp)
ffffffffc0202648:	f022                	sd	s0,32(sp)
ffffffffc020264a:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020264c:	9a1ff0ef          	jal	ra,ffffffffc0201fec <get_pte>
    if (ptep != NULL)
ffffffffc0202650:	c511                	beqz	a0,ffffffffc020265c <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0202652:	611c                	ld	a5,0(a0)
ffffffffc0202654:	842a                	mv	s0,a0
ffffffffc0202656:	0017f713          	andi	a4,a5,1
ffffffffc020265a:	e711                	bnez	a4,ffffffffc0202666 <page_remove+0x26>
}
ffffffffc020265c:	70a2                	ld	ra,40(sp)
ffffffffc020265e:	7402                	ld	s0,32(sp)
ffffffffc0202660:	64e2                	ld	s1,24(sp)
ffffffffc0202662:	6145                	addi	sp,sp,48
ffffffffc0202664:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202666:	078a                	slli	a5,a5,0x2
ffffffffc0202668:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020266a:	000b3717          	auipc	a4,0xb3
ffffffffc020266e:	99673703          	ld	a4,-1642(a4) # ffffffffc02b5000 <npage>
ffffffffc0202672:	06e7f363          	bgeu	a5,a4,ffffffffc02026d8 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0202676:	fff80537          	lui	a0,0xfff80
ffffffffc020267a:	97aa                	add	a5,a5,a0
ffffffffc020267c:	079a                	slli	a5,a5,0x6
ffffffffc020267e:	000b3517          	auipc	a0,0xb3
ffffffffc0202682:	98a53503          	ld	a0,-1654(a0) # ffffffffc02b5008 <pages>
ffffffffc0202686:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202688:	411c                	lw	a5,0(a0)
ffffffffc020268a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020268e:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202690:	cb11                	beqz	a4,ffffffffc02026a4 <page_remove+0x64>
        *ptep = 0;
ffffffffc0202692:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202696:	12048073          	sfence.vma	s1
}
ffffffffc020269a:	70a2                	ld	ra,40(sp)
ffffffffc020269c:	7402                	ld	s0,32(sp)
ffffffffc020269e:	64e2                	ld	s1,24(sp)
ffffffffc02026a0:	6145                	addi	sp,sp,48
ffffffffc02026a2:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026a4:	100027f3          	csrr	a5,sstatus
ffffffffc02026a8:	8b89                	andi	a5,a5,2
ffffffffc02026aa:	eb89                	bnez	a5,ffffffffc02026bc <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc02026ac:	000b3797          	auipc	a5,0xb3
ffffffffc02026b0:	9647b783          	ld	a5,-1692(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc02026b4:	739c                	ld	a5,32(a5)
ffffffffc02026b6:	4585                	li	a1,1
ffffffffc02026b8:	9782                	jalr	a5
    if (flag)
ffffffffc02026ba:	bfe1                	j	ffffffffc0202692 <page_remove+0x52>
        intr_disable();
ffffffffc02026bc:	e42a                	sd	a0,8(sp)
ffffffffc02026be:	af6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02026c2:	000b3797          	auipc	a5,0xb3
ffffffffc02026c6:	94e7b783          	ld	a5,-1714(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc02026ca:	739c                	ld	a5,32(a5)
ffffffffc02026cc:	6522                	ld	a0,8(sp)
ffffffffc02026ce:	4585                	li	a1,1
ffffffffc02026d0:	9782                	jalr	a5
        intr_enable();
ffffffffc02026d2:	adcfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02026d6:	bf75                	j	ffffffffc0202692 <page_remove+0x52>
ffffffffc02026d8:	825ff0ef          	jal	ra,ffffffffc0201efc <pa2page.part.0>

ffffffffc02026dc <page_insert>:
{
ffffffffc02026dc:	7139                	addi	sp,sp,-64
ffffffffc02026de:	e852                	sd	s4,16(sp)
ffffffffc02026e0:	8a32                	mv	s4,a2
ffffffffc02026e2:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026e4:	4605                	li	a2,1
{
ffffffffc02026e6:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026e8:	85d2                	mv	a1,s4
{
ffffffffc02026ea:	f426                	sd	s1,40(sp)
ffffffffc02026ec:	fc06                	sd	ra,56(sp)
ffffffffc02026ee:	f04a                	sd	s2,32(sp)
ffffffffc02026f0:	ec4e                	sd	s3,24(sp)
ffffffffc02026f2:	e456                	sd	s5,8(sp)
ffffffffc02026f4:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02026f6:	8f7ff0ef          	jal	ra,ffffffffc0201fec <get_pte>
    if (ptep == NULL)
ffffffffc02026fa:	c961                	beqz	a0,ffffffffc02027ca <page_insert+0xee>
    page->ref += 1;
ffffffffc02026fc:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc02026fe:	611c                	ld	a5,0(a0)
ffffffffc0202700:	89aa                	mv	s3,a0
ffffffffc0202702:	0016871b          	addiw	a4,a3,1
ffffffffc0202706:	c018                	sw	a4,0(s0)
ffffffffc0202708:	0017f713          	andi	a4,a5,1
ffffffffc020270c:	ef05                	bnez	a4,ffffffffc0202744 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc020270e:	000b3717          	auipc	a4,0xb3
ffffffffc0202712:	8fa73703          	ld	a4,-1798(a4) # ffffffffc02b5008 <pages>
ffffffffc0202716:	8c19                	sub	s0,s0,a4
ffffffffc0202718:	000807b7          	lui	a5,0x80
ffffffffc020271c:	8419                	srai	s0,s0,0x6
ffffffffc020271e:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202720:	042a                	slli	s0,s0,0xa
ffffffffc0202722:	8cc1                	or	s1,s1,s0
ffffffffc0202724:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0202728:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020272c:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202730:	4501                	li	a0,0
}
ffffffffc0202732:	70e2                	ld	ra,56(sp)
ffffffffc0202734:	7442                	ld	s0,48(sp)
ffffffffc0202736:	74a2                	ld	s1,40(sp)
ffffffffc0202738:	7902                	ld	s2,32(sp)
ffffffffc020273a:	69e2                	ld	s3,24(sp)
ffffffffc020273c:	6a42                	ld	s4,16(sp)
ffffffffc020273e:	6aa2                	ld	s5,8(sp)
ffffffffc0202740:	6121                	addi	sp,sp,64
ffffffffc0202742:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0202744:	078a                	slli	a5,a5,0x2
ffffffffc0202746:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202748:	000b3717          	auipc	a4,0xb3
ffffffffc020274c:	8b873703          	ld	a4,-1864(a4) # ffffffffc02b5000 <npage>
ffffffffc0202750:	06e7ff63          	bgeu	a5,a4,ffffffffc02027ce <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0202754:	000b3a97          	auipc	s5,0xb3
ffffffffc0202758:	8b4a8a93          	addi	s5,s5,-1868 # ffffffffc02b5008 <pages>
ffffffffc020275c:	000ab703          	ld	a4,0(s5)
ffffffffc0202760:	fff80937          	lui	s2,0xfff80
ffffffffc0202764:	993e                	add	s2,s2,a5
ffffffffc0202766:	091a                	slli	s2,s2,0x6
ffffffffc0202768:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc020276a:	01240c63          	beq	s0,s2,ffffffffc0202782 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020276e:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fccafb4>
ffffffffc0202772:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202776:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc020277a:	c691                	beqz	a3,ffffffffc0202786 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020277c:	120a0073          	sfence.vma	s4
}
ffffffffc0202780:	bf59                	j	ffffffffc0202716 <page_insert+0x3a>
ffffffffc0202782:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0202784:	bf49                	j	ffffffffc0202716 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202786:	100027f3          	csrr	a5,sstatus
ffffffffc020278a:	8b89                	andi	a5,a5,2
ffffffffc020278c:	ef91                	bnez	a5,ffffffffc02027a8 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020278e:	000b3797          	auipc	a5,0xb3
ffffffffc0202792:	8827b783          	ld	a5,-1918(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0202796:	739c                	ld	a5,32(a5)
ffffffffc0202798:	4585                	li	a1,1
ffffffffc020279a:	854a                	mv	a0,s2
ffffffffc020279c:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020279e:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027a2:	120a0073          	sfence.vma	s4
ffffffffc02027a6:	bf85                	j	ffffffffc0202716 <page_insert+0x3a>
        intr_disable();
ffffffffc02027a8:	a0cfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027ac:	000b3797          	auipc	a5,0xb3
ffffffffc02027b0:	8647b783          	ld	a5,-1948(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc02027b4:	739c                	ld	a5,32(a5)
ffffffffc02027b6:	4585                	li	a1,1
ffffffffc02027b8:	854a                	mv	a0,s2
ffffffffc02027ba:	9782                	jalr	a5
        intr_enable();
ffffffffc02027bc:	9f2fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02027c0:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02027c4:	120a0073          	sfence.vma	s4
ffffffffc02027c8:	b7b9                	j	ffffffffc0202716 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc02027ca:	5571                	li	a0,-4
ffffffffc02027cc:	b79d                	j	ffffffffc0202732 <page_insert+0x56>
ffffffffc02027ce:	f2eff0ef          	jal	ra,ffffffffc0201efc <pa2page.part.0>

ffffffffc02027d2 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02027d2:	00004797          	auipc	a5,0x4
ffffffffc02027d6:	0a678793          	addi	a5,a5,166 # ffffffffc0206878 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027da:	638c                	ld	a1,0(a5)
{
ffffffffc02027dc:	7159                	addi	sp,sp,-112
ffffffffc02027de:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02027e0:	00004517          	auipc	a0,0x4
ffffffffc02027e4:	24050513          	addi	a0,a0,576 # ffffffffc0206a20 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc02027e8:	000b3b17          	auipc	s6,0xb3
ffffffffc02027ec:	828b0b13          	addi	s6,s6,-2008 # ffffffffc02b5010 <pmm_manager>
{
ffffffffc02027f0:	f486                	sd	ra,104(sp)
ffffffffc02027f2:	e8ca                	sd	s2,80(sp)
ffffffffc02027f4:	e4ce                	sd	s3,72(sp)
ffffffffc02027f6:	f0a2                	sd	s0,96(sp)
ffffffffc02027f8:	eca6                	sd	s1,88(sp)
ffffffffc02027fa:	e0d2                	sd	s4,64(sp)
ffffffffc02027fc:	fc56                	sd	s5,56(sp)
ffffffffc02027fe:	f45e                	sd	s7,40(sp)
ffffffffc0202800:	f062                	sd	s8,32(sp)
ffffffffc0202802:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202804:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202808:	98dfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc020280c:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202810:	000b3997          	auipc	s3,0xb3
ffffffffc0202814:	80898993          	addi	s3,s3,-2040 # ffffffffc02b5018 <va_pa_offset>
    pmm_manager->init();
ffffffffc0202818:	679c                	ld	a5,8(a5)
ffffffffc020281a:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc020281c:	57f5                	li	a5,-3
ffffffffc020281e:	07fa                	slli	a5,a5,0x1e
ffffffffc0202820:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202824:	976fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc0202828:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020282a:	97afe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc020282e:	200505e3          	beqz	a0,ffffffffc0203238 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202832:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202834:	00004517          	auipc	a0,0x4
ffffffffc0202838:	22450513          	addi	a0,a0,548 # ffffffffc0206a58 <default_pmm_manager+0x1e0>
ffffffffc020283c:	959fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202840:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0202844:	fff40693          	addi	a3,s0,-1
ffffffffc0202848:	864a                	mv	a2,s2
ffffffffc020284a:	85a6                	mv	a1,s1
ffffffffc020284c:	00004517          	auipc	a0,0x4
ffffffffc0202850:	22450513          	addi	a0,a0,548 # ffffffffc0206a70 <default_pmm_manager+0x1f8>
ffffffffc0202854:	941fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0202858:	c8000737          	lui	a4,0xc8000
ffffffffc020285c:	87a2                	mv	a5,s0
ffffffffc020285e:	54876163          	bltu	a4,s0,ffffffffc0202da0 <pmm_init+0x5ce>
ffffffffc0202862:	757d                	lui	a0,0xfffff
ffffffffc0202864:	000b3617          	auipc	a2,0xb3
ffffffffc0202868:	7e760613          	addi	a2,a2,2023 # ffffffffc02b604b <end+0xfff>
ffffffffc020286c:	8e69                	and	a2,a2,a0
ffffffffc020286e:	000b2497          	auipc	s1,0xb2
ffffffffc0202872:	79248493          	addi	s1,s1,1938 # ffffffffc02b5000 <npage>
ffffffffc0202876:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020287a:	000b2b97          	auipc	s7,0xb2
ffffffffc020287e:	78eb8b93          	addi	s7,s7,1934 # ffffffffc02b5008 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0202882:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202884:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202888:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020288c:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020288e:	02f50863          	beq	a0,a5,ffffffffc02028be <pmm_init+0xec>
ffffffffc0202892:	4781                	li	a5,0
ffffffffc0202894:	4585                	li	a1,1
ffffffffc0202896:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc020289a:	00679513          	slli	a0,a5,0x6
ffffffffc020289e:	9532                	add	a0,a0,a2
ffffffffc02028a0:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd49fbc>
ffffffffc02028a4:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028a8:	6088                	ld	a0,0(s1)
ffffffffc02028aa:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc02028ac:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02028b0:	00d50733          	add	a4,a0,a3
ffffffffc02028b4:	fee7e3e3          	bltu	a5,a4,ffffffffc020289a <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028b8:	071a                	slli	a4,a4,0x6
ffffffffc02028ba:	00e606b3          	add	a3,a2,a4
ffffffffc02028be:	c02007b7          	lui	a5,0xc0200
ffffffffc02028c2:	2ef6ece3          	bltu	a3,a5,ffffffffc02033ba <pmm_init+0xbe8>
ffffffffc02028c6:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02028ca:	77fd                	lui	a5,0xfffff
ffffffffc02028cc:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02028ce:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02028d0:	5086eb63          	bltu	a3,s0,ffffffffc0202de6 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02028d4:	00004517          	auipc	a0,0x4
ffffffffc02028d8:	1c450513          	addi	a0,a0,452 # ffffffffc0206a98 <default_pmm_manager+0x220>
ffffffffc02028dc:	8b9fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02028e0:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028e4:	000b2917          	auipc	s2,0xb2
ffffffffc02028e8:	71490913          	addi	s2,s2,1812 # ffffffffc02b4ff8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02028ec:	7b9c                	ld	a5,48(a5)
ffffffffc02028ee:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02028f0:	00004517          	auipc	a0,0x4
ffffffffc02028f4:	1c050513          	addi	a0,a0,448 # ffffffffc0206ab0 <default_pmm_manager+0x238>
ffffffffc02028f8:	89dfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02028fc:	00007697          	auipc	a3,0x7
ffffffffc0202900:	70468693          	addi	a3,a3,1796 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202904:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202908:	c02007b7          	lui	a5,0xc0200
ffffffffc020290c:	28f6ebe3          	bltu	a3,a5,ffffffffc02033a2 <pmm_init+0xbd0>
ffffffffc0202910:	0009b783          	ld	a5,0(s3)
ffffffffc0202914:	8e9d                	sub	a3,a3,a5
ffffffffc0202916:	000b2797          	auipc	a5,0xb2
ffffffffc020291a:	6cd7bd23          	sd	a3,1754(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020291e:	100027f3          	csrr	a5,sstatus
ffffffffc0202922:	8b89                	andi	a5,a5,2
ffffffffc0202924:	4a079763          	bnez	a5,ffffffffc0202dd2 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202928:	000b3783          	ld	a5,0(s6)
ffffffffc020292c:	779c                	ld	a5,40(a5)
ffffffffc020292e:	9782                	jalr	a5
ffffffffc0202930:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202932:	6098                	ld	a4,0(s1)
ffffffffc0202934:	c80007b7          	lui	a5,0xc8000
ffffffffc0202938:	83b1                	srli	a5,a5,0xc
ffffffffc020293a:	66e7e363          	bltu	a5,a4,ffffffffc0202fa0 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020293e:	00093503          	ld	a0,0(s2)
ffffffffc0202942:	62050f63          	beqz	a0,ffffffffc0202f80 <pmm_init+0x7ae>
ffffffffc0202946:	03451793          	slli	a5,a0,0x34
ffffffffc020294a:	62079b63          	bnez	a5,ffffffffc0202f80 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020294e:	4601                	li	a2,0
ffffffffc0202950:	4581                	li	a1,0
ffffffffc0202952:	8c3ff0ef          	jal	ra,ffffffffc0202214 <get_page>
ffffffffc0202956:	60051563          	bnez	a0,ffffffffc0202f60 <pmm_init+0x78e>
ffffffffc020295a:	100027f3          	csrr	a5,sstatus
ffffffffc020295e:	8b89                	andi	a5,a5,2
ffffffffc0202960:	44079e63          	bnez	a5,ffffffffc0202dbc <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202964:	000b3783          	ld	a5,0(s6)
ffffffffc0202968:	4505                	li	a0,1
ffffffffc020296a:	6f9c                	ld	a5,24(a5)
ffffffffc020296c:	9782                	jalr	a5
ffffffffc020296e:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202970:	00093503          	ld	a0,0(s2)
ffffffffc0202974:	4681                	li	a3,0
ffffffffc0202976:	4601                	li	a2,0
ffffffffc0202978:	85d2                	mv	a1,s4
ffffffffc020297a:	d63ff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc020297e:	26051ae3          	bnez	a0,ffffffffc02033f2 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202982:	00093503          	ld	a0,0(s2)
ffffffffc0202986:	4601                	li	a2,0
ffffffffc0202988:	4581                	li	a1,0
ffffffffc020298a:	e62ff0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc020298e:	240502e3          	beqz	a0,ffffffffc02033d2 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0202992:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202994:	0017f713          	andi	a4,a5,1
ffffffffc0202998:	5a070263          	beqz	a4,ffffffffc0202f3c <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020299c:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc020299e:	078a                	slli	a5,a5,0x2
ffffffffc02029a0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02029a2:	58e7fb63          	bgeu	a5,a4,ffffffffc0202f38 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02029a6:	000bb683          	ld	a3,0(s7)
ffffffffc02029aa:	fff80637          	lui	a2,0xfff80
ffffffffc02029ae:	97b2                	add	a5,a5,a2
ffffffffc02029b0:	079a                	slli	a5,a5,0x6
ffffffffc02029b2:	97b6                	add	a5,a5,a3
ffffffffc02029b4:	14fa17e3          	bne	s4,a5,ffffffffc0203302 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc02029b8:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc02029bc:	4785                	li	a5,1
ffffffffc02029be:	12f692e3          	bne	a3,a5,ffffffffc02032e2 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02029c2:	00093503          	ld	a0,0(s2)
ffffffffc02029c6:	77fd                	lui	a5,0xfffff
ffffffffc02029c8:	6114                	ld	a3,0(a0)
ffffffffc02029ca:	068a                	slli	a3,a3,0x2
ffffffffc02029cc:	8efd                	and	a3,a3,a5
ffffffffc02029ce:	00c6d613          	srli	a2,a3,0xc
ffffffffc02029d2:	0ee67ce3          	bgeu	a2,a4,ffffffffc02032ca <pmm_init+0xaf8>
ffffffffc02029d6:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029da:	96e2                	add	a3,a3,s8
ffffffffc02029dc:	0006ba83          	ld	s5,0(a3)
ffffffffc02029e0:	0a8a                	slli	s5,s5,0x2
ffffffffc02029e2:	00fafab3          	and	s5,s5,a5
ffffffffc02029e6:	00cad793          	srli	a5,s5,0xc
ffffffffc02029ea:	0ce7f3e3          	bgeu	a5,a4,ffffffffc02032b0 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029ee:	4601                	li	a2,0
ffffffffc02029f0:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029f2:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029f4:	df8ff0ef          	jal	ra,ffffffffc0201fec <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02029f8:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02029fa:	55551363          	bne	a0,s5,ffffffffc0202f40 <pmm_init+0x76e>
ffffffffc02029fe:	100027f3          	csrr	a5,sstatus
ffffffffc0202a02:	8b89                	andi	a5,a5,2
ffffffffc0202a04:	3a079163          	bnez	a5,ffffffffc0202da6 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202a08:	000b3783          	ld	a5,0(s6)
ffffffffc0202a0c:	4505                	li	a0,1
ffffffffc0202a0e:	6f9c                	ld	a5,24(a5)
ffffffffc0202a10:	9782                	jalr	a5
ffffffffc0202a12:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202a14:	00093503          	ld	a0,0(s2)
ffffffffc0202a18:	46d1                	li	a3,20
ffffffffc0202a1a:	6605                	lui	a2,0x1
ffffffffc0202a1c:	85e2                	mv	a1,s8
ffffffffc0202a1e:	cbfff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc0202a22:	060517e3          	bnez	a0,ffffffffc0203290 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a26:	00093503          	ld	a0,0(s2)
ffffffffc0202a2a:	4601                	li	a2,0
ffffffffc0202a2c:	6585                	lui	a1,0x1
ffffffffc0202a2e:	dbeff0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc0202a32:	02050fe3          	beqz	a0,ffffffffc0203270 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0202a36:	611c                	ld	a5,0(a0)
ffffffffc0202a38:	0107f713          	andi	a4,a5,16
ffffffffc0202a3c:	7c070e63          	beqz	a4,ffffffffc0203218 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0202a40:	8b91                	andi	a5,a5,4
ffffffffc0202a42:	7a078b63          	beqz	a5,ffffffffc02031f8 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202a46:	00093503          	ld	a0,0(s2)
ffffffffc0202a4a:	611c                	ld	a5,0(a0)
ffffffffc0202a4c:	8bc1                	andi	a5,a5,16
ffffffffc0202a4e:	78078563          	beqz	a5,ffffffffc02031d8 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0202a52:	000c2703          	lw	a4,0(s8)
ffffffffc0202a56:	4785                	li	a5,1
ffffffffc0202a58:	76f71063          	bne	a4,a5,ffffffffc02031b8 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202a5c:	4681                	li	a3,0
ffffffffc0202a5e:	6605                	lui	a2,0x1
ffffffffc0202a60:	85d2                	mv	a1,s4
ffffffffc0202a62:	c7bff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc0202a66:	72051963          	bnez	a0,ffffffffc0203198 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0202a6a:	000a2703          	lw	a4,0(s4)
ffffffffc0202a6e:	4789                	li	a5,2
ffffffffc0202a70:	70f71463          	bne	a4,a5,ffffffffc0203178 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0202a74:	000c2783          	lw	a5,0(s8)
ffffffffc0202a78:	6e079063          	bnez	a5,ffffffffc0203158 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202a7c:	00093503          	ld	a0,0(s2)
ffffffffc0202a80:	4601                	li	a2,0
ffffffffc0202a82:	6585                	lui	a1,0x1
ffffffffc0202a84:	d68ff0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc0202a88:	6a050863          	beqz	a0,ffffffffc0203138 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202a8c:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202a8e:	00177793          	andi	a5,a4,1
ffffffffc0202a92:	4a078563          	beqz	a5,ffffffffc0202f3c <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202a96:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202a98:	00271793          	slli	a5,a4,0x2
ffffffffc0202a9c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a9e:	48d7fd63          	bgeu	a5,a3,ffffffffc0202f38 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202aa2:	000bb683          	ld	a3,0(s7)
ffffffffc0202aa6:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202aaa:	97d6                	add	a5,a5,s5
ffffffffc0202aac:	079a                	slli	a5,a5,0x6
ffffffffc0202aae:	97b6                	add	a5,a5,a3
ffffffffc0202ab0:	66fa1463          	bne	s4,a5,ffffffffc0203118 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202ab4:	8b41                	andi	a4,a4,16
ffffffffc0202ab6:	64071163          	bnez	a4,ffffffffc02030f8 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202aba:	00093503          	ld	a0,0(s2)
ffffffffc0202abe:	4581                	li	a1,0
ffffffffc0202ac0:	b81ff0ef          	jal	ra,ffffffffc0202640 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202ac4:	000a2c83          	lw	s9,0(s4)
ffffffffc0202ac8:	4785                	li	a5,1
ffffffffc0202aca:	60fc9763          	bne	s9,a5,ffffffffc02030d8 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202ace:	000c2783          	lw	a5,0(s8)
ffffffffc0202ad2:	5e079363          	bnez	a5,ffffffffc02030b8 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202ad6:	00093503          	ld	a0,0(s2)
ffffffffc0202ada:	6585                	lui	a1,0x1
ffffffffc0202adc:	b65ff0ef          	jal	ra,ffffffffc0202640 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202ae0:	000a2783          	lw	a5,0(s4)
ffffffffc0202ae4:	52079a63          	bnez	a5,ffffffffc0203018 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202ae8:	000c2783          	lw	a5,0(s8)
ffffffffc0202aec:	50079663          	bnez	a5,ffffffffc0202ff8 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202af0:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202af4:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202af6:	000a3683          	ld	a3,0(s4)
ffffffffc0202afa:	068a                	slli	a3,a3,0x2
ffffffffc0202afc:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202afe:	42b6fd63          	bgeu	a3,a1,ffffffffc0202f38 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b02:	000bb503          	ld	a0,0(s7)
ffffffffc0202b06:	96d6                	add	a3,a3,s5
ffffffffc0202b08:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202b0a:	00d507b3          	add	a5,a0,a3
ffffffffc0202b0e:	439c                	lw	a5,0(a5)
ffffffffc0202b10:	4d979463          	bne	a5,s9,ffffffffc0202fd8 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202b14:	8699                	srai	a3,a3,0x6
ffffffffc0202b16:	00080637          	lui	a2,0x80
ffffffffc0202b1a:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202b1c:	00c69713          	slli	a4,a3,0xc
ffffffffc0202b20:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202b22:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202b24:	48b77e63          	bgeu	a4,a1,ffffffffc0202fc0 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202b28:	0009b703          	ld	a4,0(s3)
ffffffffc0202b2c:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b2e:	629c                	ld	a5,0(a3)
ffffffffc0202b30:	078a                	slli	a5,a5,0x2
ffffffffc0202b32:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b34:	40b7f263          	bgeu	a5,a1,ffffffffc0202f38 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b38:	8f91                	sub	a5,a5,a2
ffffffffc0202b3a:	079a                	slli	a5,a5,0x6
ffffffffc0202b3c:	953e                	add	a0,a0,a5
ffffffffc0202b3e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b42:	8b89                	andi	a5,a5,2
ffffffffc0202b44:	30079963          	bnez	a5,ffffffffc0202e56 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202b48:	000b3783          	ld	a5,0(s6)
ffffffffc0202b4c:	4585                	li	a1,1
ffffffffc0202b4e:	739c                	ld	a5,32(a5)
ffffffffc0202b50:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b52:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202b56:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202b58:	078a                	slli	a5,a5,0x2
ffffffffc0202b5a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202b5c:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202f38 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202b60:	000bb503          	ld	a0,0(s7)
ffffffffc0202b64:	fff80737          	lui	a4,0xfff80
ffffffffc0202b68:	97ba                	add	a5,a5,a4
ffffffffc0202b6a:	079a                	slli	a5,a5,0x6
ffffffffc0202b6c:	953e                	add	a0,a0,a5
ffffffffc0202b6e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b72:	8b89                	andi	a5,a5,2
ffffffffc0202b74:	2c079563          	bnez	a5,ffffffffc0202e3e <pmm_init+0x66c>
ffffffffc0202b78:	000b3783          	ld	a5,0(s6)
ffffffffc0202b7c:	4585                	li	a1,1
ffffffffc0202b7e:	739c                	ld	a5,32(a5)
ffffffffc0202b80:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202b82:	00093783          	ld	a5,0(s2)
ffffffffc0202b86:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd49fb4>
    asm volatile("sfence.vma");
ffffffffc0202b8a:	12000073          	sfence.vma
ffffffffc0202b8e:	100027f3          	csrr	a5,sstatus
ffffffffc0202b92:	8b89                	andi	a5,a5,2
ffffffffc0202b94:	28079b63          	bnez	a5,ffffffffc0202e2a <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b98:	000b3783          	ld	a5,0(s6)
ffffffffc0202b9c:	779c                	ld	a5,40(a5)
ffffffffc0202b9e:	9782                	jalr	a5
ffffffffc0202ba0:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202ba2:	4b441b63          	bne	s0,s4,ffffffffc0203058 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202ba6:	00004517          	auipc	a0,0x4
ffffffffc0202baa:	23250513          	addi	a0,a0,562 # ffffffffc0206dd8 <default_pmm_manager+0x560>
ffffffffc0202bae:	de6fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202bb2:	100027f3          	csrr	a5,sstatus
ffffffffc0202bb6:	8b89                	andi	a5,a5,2
ffffffffc0202bb8:	24079f63          	bnez	a5,ffffffffc0202e16 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202bbc:	000b3783          	ld	a5,0(s6)
ffffffffc0202bc0:	779c                	ld	a5,40(a5)
ffffffffc0202bc2:	9782                	jalr	a5
ffffffffc0202bc4:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bc6:	6098                	ld	a4,0(s1)
ffffffffc0202bc8:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bcc:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202bce:	00c71793          	slli	a5,a4,0xc
ffffffffc0202bd2:	6a05                	lui	s4,0x1
ffffffffc0202bd4:	02f47c63          	bgeu	s0,a5,ffffffffc0202c0c <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202bd8:	00c45793          	srli	a5,s0,0xc
ffffffffc0202bdc:	00093503          	ld	a0,0(s2)
ffffffffc0202be0:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202ede <pmm_init+0x70c>
ffffffffc0202be4:	0009b583          	ld	a1,0(s3)
ffffffffc0202be8:	4601                	li	a2,0
ffffffffc0202bea:	95a2                	add	a1,a1,s0
ffffffffc0202bec:	c00ff0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc0202bf0:	32050463          	beqz	a0,ffffffffc0202f18 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202bf4:	611c                	ld	a5,0(a0)
ffffffffc0202bf6:	078a                	slli	a5,a5,0x2
ffffffffc0202bf8:	0157f7b3          	and	a5,a5,s5
ffffffffc0202bfc:	2e879e63          	bne	a5,s0,ffffffffc0202ef8 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202c00:	6098                	ld	a4,0(s1)
ffffffffc0202c02:	9452                	add	s0,s0,s4
ffffffffc0202c04:	00c71793          	slli	a5,a4,0xc
ffffffffc0202c08:	fcf468e3          	bltu	s0,a5,ffffffffc0202bd8 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202c0c:	00093783          	ld	a5,0(s2)
ffffffffc0202c10:	639c                	ld	a5,0(a5)
ffffffffc0202c12:	42079363          	bnez	a5,ffffffffc0203038 <pmm_init+0x866>
ffffffffc0202c16:	100027f3          	csrr	a5,sstatus
ffffffffc0202c1a:	8b89                	andi	a5,a5,2
ffffffffc0202c1c:	24079963          	bnez	a5,ffffffffc0202e6e <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202c20:	000b3783          	ld	a5,0(s6)
ffffffffc0202c24:	4505                	li	a0,1
ffffffffc0202c26:	6f9c                	ld	a5,24(a5)
ffffffffc0202c28:	9782                	jalr	a5
ffffffffc0202c2a:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202c2c:	00093503          	ld	a0,0(s2)
ffffffffc0202c30:	4699                	li	a3,6
ffffffffc0202c32:	10000613          	li	a2,256
ffffffffc0202c36:	85d2                	mv	a1,s4
ffffffffc0202c38:	aa5ff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc0202c3c:	44051e63          	bnez	a0,ffffffffc0203098 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202c40:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc0202c44:	4785                	li	a5,1
ffffffffc0202c46:	42f71963          	bne	a4,a5,ffffffffc0203078 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202c4a:	00093503          	ld	a0,0(s2)
ffffffffc0202c4e:	6405                	lui	s0,0x1
ffffffffc0202c50:	4699                	li	a3,6
ffffffffc0202c52:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8aa8>
ffffffffc0202c56:	85d2                	mv	a1,s4
ffffffffc0202c58:	a85ff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc0202c5c:	72051363          	bnez	a0,ffffffffc0203382 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202c60:	000a2703          	lw	a4,0(s4)
ffffffffc0202c64:	4789                	li	a5,2
ffffffffc0202c66:	6ef71e63          	bne	a4,a5,ffffffffc0203362 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202c6a:	00004597          	auipc	a1,0x4
ffffffffc0202c6e:	2b658593          	addi	a1,a1,694 # ffffffffc0206f20 <default_pmm_manager+0x6a8>
ffffffffc0202c72:	10000513          	li	a0,256
ffffffffc0202c76:	4e3020ef          	jal	ra,ffffffffc0205958 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202c7a:	10040593          	addi	a1,s0,256
ffffffffc0202c7e:	10000513          	li	a0,256
ffffffffc0202c82:	4e9020ef          	jal	ra,ffffffffc020596a <strcmp>
ffffffffc0202c86:	6a051e63          	bnez	a0,ffffffffc0203342 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202c8a:	000bb683          	ld	a3,0(s7)
ffffffffc0202c8e:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202c92:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202c94:	40da06b3          	sub	a3,s4,a3
ffffffffc0202c98:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202c9a:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202c9c:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202c9e:	8031                	srli	s0,s0,0xc
ffffffffc0202ca0:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202ca4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202ca6:	30f77d63          	bgeu	a4,a5,ffffffffc0202fc0 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202caa:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202cae:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202cb2:	96be                	add	a3,a3,a5
ffffffffc0202cb4:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202cb8:	46b020ef          	jal	ra,ffffffffc0205922 <strlen>
ffffffffc0202cbc:	66051363          	bnez	a0,ffffffffc0203322 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202cc0:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202cc4:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cc6:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd49fb4>
ffffffffc0202cca:	068a                	slli	a3,a3,0x2
ffffffffc0202ccc:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cce:	26f6f563          	bgeu	a3,a5,ffffffffc0202f38 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202cd2:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202cd4:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202cd6:	2ef47563          	bgeu	s0,a5,ffffffffc0202fc0 <pmm_init+0x7ee>
ffffffffc0202cda:	0009b403          	ld	s0,0(s3)
ffffffffc0202cde:	9436                	add	s0,s0,a3
ffffffffc0202ce0:	100027f3          	csrr	a5,sstatus
ffffffffc0202ce4:	8b89                	andi	a5,a5,2
ffffffffc0202ce6:	1e079163          	bnez	a5,ffffffffc0202ec8 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202cea:	000b3783          	ld	a5,0(s6)
ffffffffc0202cee:	4585                	li	a1,1
ffffffffc0202cf0:	8552                	mv	a0,s4
ffffffffc0202cf2:	739c                	ld	a5,32(a5)
ffffffffc0202cf4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cf6:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202cf8:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202cfa:	078a                	slli	a5,a5,0x2
ffffffffc0202cfc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202cfe:	22e7fd63          	bgeu	a5,a4,ffffffffc0202f38 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d02:	000bb503          	ld	a0,0(s7)
ffffffffc0202d06:	fff80737          	lui	a4,0xfff80
ffffffffc0202d0a:	97ba                	add	a5,a5,a4
ffffffffc0202d0c:	079a                	slli	a5,a5,0x6
ffffffffc0202d0e:	953e                	add	a0,a0,a5
ffffffffc0202d10:	100027f3          	csrr	a5,sstatus
ffffffffc0202d14:	8b89                	andi	a5,a5,2
ffffffffc0202d16:	18079d63          	bnez	a5,ffffffffc0202eb0 <pmm_init+0x6de>
ffffffffc0202d1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d1e:	4585                	li	a1,1
ffffffffc0202d20:	739c                	ld	a5,32(a5)
ffffffffc0202d22:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d24:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202d28:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202d2a:	078a                	slli	a5,a5,0x2
ffffffffc0202d2c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202d2e:	20e7f563          	bgeu	a5,a4,ffffffffc0202f38 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202d32:	000bb503          	ld	a0,0(s7)
ffffffffc0202d36:	fff80737          	lui	a4,0xfff80
ffffffffc0202d3a:	97ba                	add	a5,a5,a4
ffffffffc0202d3c:	079a                	slli	a5,a5,0x6
ffffffffc0202d3e:	953e                	add	a0,a0,a5
ffffffffc0202d40:	100027f3          	csrr	a5,sstatus
ffffffffc0202d44:	8b89                	andi	a5,a5,2
ffffffffc0202d46:	14079963          	bnez	a5,ffffffffc0202e98 <pmm_init+0x6c6>
ffffffffc0202d4a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d4e:	4585                	li	a1,1
ffffffffc0202d50:	739c                	ld	a5,32(a5)
ffffffffc0202d52:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202d54:	00093783          	ld	a5,0(s2)
ffffffffc0202d58:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202d5c:	12000073          	sfence.vma
ffffffffc0202d60:	100027f3          	csrr	a5,sstatus
ffffffffc0202d64:	8b89                	andi	a5,a5,2
ffffffffc0202d66:	10079f63          	bnez	a5,ffffffffc0202e84 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d6a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d6e:	779c                	ld	a5,40(a5)
ffffffffc0202d70:	9782                	jalr	a5
ffffffffc0202d72:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202d74:	4c8c1e63          	bne	s8,s0,ffffffffc0203250 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202d78:	00004517          	auipc	a0,0x4
ffffffffc0202d7c:	22050513          	addi	a0,a0,544 # ffffffffc0206f98 <default_pmm_manager+0x720>
ffffffffc0202d80:	c14fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202d84:	7406                	ld	s0,96(sp)
ffffffffc0202d86:	70a6                	ld	ra,104(sp)
ffffffffc0202d88:	64e6                	ld	s1,88(sp)
ffffffffc0202d8a:	6946                	ld	s2,80(sp)
ffffffffc0202d8c:	69a6                	ld	s3,72(sp)
ffffffffc0202d8e:	6a06                	ld	s4,64(sp)
ffffffffc0202d90:	7ae2                	ld	s5,56(sp)
ffffffffc0202d92:	7b42                	ld	s6,48(sp)
ffffffffc0202d94:	7ba2                	ld	s7,40(sp)
ffffffffc0202d96:	7c02                	ld	s8,32(sp)
ffffffffc0202d98:	6ce2                	ld	s9,24(sp)
ffffffffc0202d9a:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d9c:	f97fe06f          	j	ffffffffc0201d32 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202da0:	c80007b7          	lui	a5,0xc8000
ffffffffc0202da4:	bc7d                	j	ffffffffc0202862 <pmm_init+0x90>
        intr_disable();
ffffffffc0202da6:	c0ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202daa:	000b3783          	ld	a5,0(s6)
ffffffffc0202dae:	4505                	li	a0,1
ffffffffc0202db0:	6f9c                	ld	a5,24(a5)
ffffffffc0202db2:	9782                	jalr	a5
ffffffffc0202db4:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202db6:	bf9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dba:	b9a9                	j	ffffffffc0202a14 <pmm_init+0x242>
        intr_disable();
ffffffffc0202dbc:	bf9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202dc0:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc4:	4505                	li	a0,1
ffffffffc0202dc6:	6f9c                	ld	a5,24(a5)
ffffffffc0202dc8:	9782                	jalr	a5
ffffffffc0202dca:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202dcc:	be3fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dd0:	b645                	j	ffffffffc0202970 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202dd2:	be3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dd6:	000b3783          	ld	a5,0(s6)
ffffffffc0202dda:	779c                	ld	a5,40(a5)
ffffffffc0202ddc:	9782                	jalr	a5
ffffffffc0202dde:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202de0:	bcffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202de4:	b6b9                	j	ffffffffc0202932 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202de6:	6705                	lui	a4,0x1
ffffffffc0202de8:	177d                	addi	a4,a4,-1
ffffffffc0202dea:	96ba                	add	a3,a3,a4
ffffffffc0202dec:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202dee:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202df2:	14a77363          	bgeu	a4,a0,ffffffffc0202f38 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202df6:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202dfa:	fff80537          	lui	a0,0xfff80
ffffffffc0202dfe:	972a                	add	a4,a4,a0
ffffffffc0202e00:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202e02:	8c1d                	sub	s0,s0,a5
ffffffffc0202e04:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202e08:	00c45593          	srli	a1,s0,0xc
ffffffffc0202e0c:	9532                	add	a0,a0,a2
ffffffffc0202e0e:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202e10:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202e14:	b4c1                	j	ffffffffc02028d4 <pmm_init+0x102>
        intr_disable();
ffffffffc0202e16:	b9ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e1e:	779c                	ld	a5,40(a5)
ffffffffc0202e20:	9782                	jalr	a5
ffffffffc0202e22:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202e24:	b8bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e28:	bb79                	j	ffffffffc0202bc6 <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202e2a:	b8bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e2e:	000b3783          	ld	a5,0(s6)
ffffffffc0202e32:	779c                	ld	a5,40(a5)
ffffffffc0202e34:	9782                	jalr	a5
ffffffffc0202e36:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202e38:	b77fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e3c:	b39d                	j	ffffffffc0202ba2 <pmm_init+0x3d0>
ffffffffc0202e3e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e40:	b75fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e44:	000b3783          	ld	a5,0(s6)
ffffffffc0202e48:	6522                	ld	a0,8(sp)
ffffffffc0202e4a:	4585                	li	a1,1
ffffffffc0202e4c:	739c                	ld	a5,32(a5)
ffffffffc0202e4e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e50:	b5ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e54:	b33d                	j	ffffffffc0202b82 <pmm_init+0x3b0>
ffffffffc0202e56:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e58:	b5dfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e5c:	000b3783          	ld	a5,0(s6)
ffffffffc0202e60:	6522                	ld	a0,8(sp)
ffffffffc0202e62:	4585                	li	a1,1
ffffffffc0202e64:	739c                	ld	a5,32(a5)
ffffffffc0202e66:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e68:	b47fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e6c:	b1dd                	j	ffffffffc0202b52 <pmm_init+0x380>
        intr_disable();
ffffffffc0202e6e:	b47fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202e72:	000b3783          	ld	a5,0(s6)
ffffffffc0202e76:	4505                	li	a0,1
ffffffffc0202e78:	6f9c                	ld	a5,24(a5)
ffffffffc0202e7a:	9782                	jalr	a5
ffffffffc0202e7c:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202e7e:	b31fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e82:	b36d                	j	ffffffffc0202c2c <pmm_init+0x45a>
        intr_disable();
ffffffffc0202e84:	b31fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202e88:	000b3783          	ld	a5,0(s6)
ffffffffc0202e8c:	779c                	ld	a5,40(a5)
ffffffffc0202e8e:	9782                	jalr	a5
ffffffffc0202e90:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202e92:	b1dfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e96:	bdf9                	j	ffffffffc0202d74 <pmm_init+0x5a2>
ffffffffc0202e98:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e9a:	b1bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e9e:	000b3783          	ld	a5,0(s6)
ffffffffc0202ea2:	6522                	ld	a0,8(sp)
ffffffffc0202ea4:	4585                	li	a1,1
ffffffffc0202ea6:	739c                	ld	a5,32(a5)
ffffffffc0202ea8:	9782                	jalr	a5
        intr_enable();
ffffffffc0202eaa:	b05fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202eae:	b55d                	j	ffffffffc0202d54 <pmm_init+0x582>
ffffffffc0202eb0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202eb2:	b03fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202eb6:	000b3783          	ld	a5,0(s6)
ffffffffc0202eba:	6522                	ld	a0,8(sp)
ffffffffc0202ebc:	4585                	li	a1,1
ffffffffc0202ebe:	739c                	ld	a5,32(a5)
ffffffffc0202ec0:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ec2:	aedfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202ec6:	bdb9                	j	ffffffffc0202d24 <pmm_init+0x552>
        intr_disable();
ffffffffc0202ec8:	aedfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202ecc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ed0:	4585                	li	a1,1
ffffffffc0202ed2:	8552                	mv	a0,s4
ffffffffc0202ed4:	739c                	ld	a5,32(a5)
ffffffffc0202ed6:	9782                	jalr	a5
        intr_enable();
ffffffffc0202ed8:	ad7fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202edc:	bd29                	j	ffffffffc0202cf6 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202ede:	86a2                	mv	a3,s0
ffffffffc0202ee0:	00004617          	auipc	a2,0x4
ffffffffc0202ee4:	9d060613          	addi	a2,a2,-1584 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc0202ee8:	25d00593          	li	a1,605
ffffffffc0202eec:	00004517          	auipc	a0,0x4
ffffffffc0202ef0:	adc50513          	addi	a0,a0,-1316 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202ef4:	d9afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202ef8:	00004697          	auipc	a3,0x4
ffffffffc0202efc:	f4068693          	addi	a3,a3,-192 # ffffffffc0206e38 <default_pmm_manager+0x5c0>
ffffffffc0202f00:	00003617          	auipc	a2,0x3
ffffffffc0202f04:	35060613          	addi	a2,a2,848 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202f08:	25e00593          	li	a1,606
ffffffffc0202f0c:	00004517          	auipc	a0,0x4
ffffffffc0202f10:	abc50513          	addi	a0,a0,-1348 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202f14:	d7afd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202f18:	00004697          	auipc	a3,0x4
ffffffffc0202f1c:	ee068693          	addi	a3,a3,-288 # ffffffffc0206df8 <default_pmm_manager+0x580>
ffffffffc0202f20:	00003617          	auipc	a2,0x3
ffffffffc0202f24:	33060613          	addi	a2,a2,816 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202f28:	25d00593          	li	a1,605
ffffffffc0202f2c:	00004517          	auipc	a0,0x4
ffffffffc0202f30:	a9c50513          	addi	a0,a0,-1380 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202f34:	d5afd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202f38:	fc5fe0ef          	jal	ra,ffffffffc0201efc <pa2page.part.0>
ffffffffc0202f3c:	fddfe0ef          	jal	ra,ffffffffc0201f18 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202f40:	00004697          	auipc	a3,0x4
ffffffffc0202f44:	cb068693          	addi	a3,a3,-848 # ffffffffc0206bf0 <default_pmm_manager+0x378>
ffffffffc0202f48:	00003617          	auipc	a2,0x3
ffffffffc0202f4c:	30860613          	addi	a2,a2,776 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202f50:	22d00593          	li	a1,557
ffffffffc0202f54:	00004517          	auipc	a0,0x4
ffffffffc0202f58:	a7450513          	addi	a0,a0,-1420 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202f5c:	d32fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202f60:	00004697          	auipc	a3,0x4
ffffffffc0202f64:	bd068693          	addi	a3,a3,-1072 # ffffffffc0206b30 <default_pmm_manager+0x2b8>
ffffffffc0202f68:	00003617          	auipc	a2,0x3
ffffffffc0202f6c:	2e860613          	addi	a2,a2,744 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202f70:	22000593          	li	a1,544
ffffffffc0202f74:	00004517          	auipc	a0,0x4
ffffffffc0202f78:	a5450513          	addi	a0,a0,-1452 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202f7c:	d12fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202f80:	00004697          	auipc	a3,0x4
ffffffffc0202f84:	b7068693          	addi	a3,a3,-1168 # ffffffffc0206af0 <default_pmm_manager+0x278>
ffffffffc0202f88:	00003617          	auipc	a2,0x3
ffffffffc0202f8c:	2c860613          	addi	a2,a2,712 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202f90:	21f00593          	li	a1,543
ffffffffc0202f94:	00004517          	auipc	a0,0x4
ffffffffc0202f98:	a3450513          	addi	a0,a0,-1484 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202f9c:	cf2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202fa0:	00004697          	auipc	a3,0x4
ffffffffc0202fa4:	b3068693          	addi	a3,a3,-1232 # ffffffffc0206ad0 <default_pmm_manager+0x258>
ffffffffc0202fa8:	00003617          	auipc	a2,0x3
ffffffffc0202fac:	2a860613          	addi	a2,a2,680 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202fb0:	21e00593          	li	a1,542
ffffffffc0202fb4:	00004517          	auipc	a0,0x4
ffffffffc0202fb8:	a1450513          	addi	a0,a0,-1516 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202fbc:	cd2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202fc0:	00004617          	auipc	a2,0x4
ffffffffc0202fc4:	8f060613          	addi	a2,a2,-1808 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc0202fc8:	07100593          	li	a1,113
ffffffffc0202fcc:	00004517          	auipc	a0,0x4
ffffffffc0202fd0:	90c50513          	addi	a0,a0,-1780 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0202fd4:	cbafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202fd8:	00004697          	auipc	a3,0x4
ffffffffc0202fdc:	da868693          	addi	a3,a3,-600 # ffffffffc0206d80 <default_pmm_manager+0x508>
ffffffffc0202fe0:	00003617          	auipc	a2,0x3
ffffffffc0202fe4:	27060613          	addi	a2,a2,624 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0202fe8:	24600593          	li	a1,582
ffffffffc0202fec:	00004517          	auipc	a0,0x4
ffffffffc0202ff0:	9dc50513          	addi	a0,a0,-1572 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0202ff4:	c9afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202ff8:	00004697          	auipc	a3,0x4
ffffffffc0202ffc:	d4068693          	addi	a3,a3,-704 # ffffffffc0206d38 <default_pmm_manager+0x4c0>
ffffffffc0203000:	00003617          	auipc	a2,0x3
ffffffffc0203004:	25060613          	addi	a2,a2,592 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203008:	24400593          	li	a1,580
ffffffffc020300c:	00004517          	auipc	a0,0x4
ffffffffc0203010:	9bc50513          	addi	a0,a0,-1604 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203014:	c7afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0203018:	00004697          	auipc	a3,0x4
ffffffffc020301c:	d5068693          	addi	a3,a3,-688 # ffffffffc0206d68 <default_pmm_manager+0x4f0>
ffffffffc0203020:	00003617          	auipc	a2,0x3
ffffffffc0203024:	23060613          	addi	a2,a2,560 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203028:	24300593          	li	a1,579
ffffffffc020302c:	00004517          	auipc	a0,0x4
ffffffffc0203030:	99c50513          	addi	a0,a0,-1636 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203034:	c5afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0203038:	00004697          	auipc	a3,0x4
ffffffffc020303c:	e1868693          	addi	a3,a3,-488 # ffffffffc0206e50 <default_pmm_manager+0x5d8>
ffffffffc0203040:	00003617          	auipc	a2,0x3
ffffffffc0203044:	21060613          	addi	a2,a2,528 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203048:	26100593          	li	a1,609
ffffffffc020304c:	00004517          	auipc	a0,0x4
ffffffffc0203050:	97c50513          	addi	a0,a0,-1668 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203054:	c3afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203058:	00004697          	auipc	a3,0x4
ffffffffc020305c:	d5868693          	addi	a3,a3,-680 # ffffffffc0206db0 <default_pmm_manager+0x538>
ffffffffc0203060:	00003617          	auipc	a2,0x3
ffffffffc0203064:	1f060613          	addi	a2,a2,496 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203068:	24e00593          	li	a1,590
ffffffffc020306c:	00004517          	auipc	a0,0x4
ffffffffc0203070:	95c50513          	addi	a0,a0,-1700 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203074:	c1afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0203078:	00004697          	auipc	a3,0x4
ffffffffc020307c:	e3068693          	addi	a3,a3,-464 # ffffffffc0206ea8 <default_pmm_manager+0x630>
ffffffffc0203080:	00003617          	auipc	a2,0x3
ffffffffc0203084:	1d060613          	addi	a2,a2,464 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203088:	26600593          	li	a1,614
ffffffffc020308c:	00004517          	auipc	a0,0x4
ffffffffc0203090:	93c50513          	addi	a0,a0,-1732 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203094:	bfafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0203098:	00004697          	auipc	a3,0x4
ffffffffc020309c:	dd068693          	addi	a3,a3,-560 # ffffffffc0206e68 <default_pmm_manager+0x5f0>
ffffffffc02030a0:	00003617          	auipc	a2,0x3
ffffffffc02030a4:	1b060613          	addi	a2,a2,432 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02030a8:	26500593          	li	a1,613
ffffffffc02030ac:	00004517          	auipc	a0,0x4
ffffffffc02030b0:	91c50513          	addi	a0,a0,-1764 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02030b4:	bdafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030b8:	00004697          	auipc	a3,0x4
ffffffffc02030bc:	c8068693          	addi	a3,a3,-896 # ffffffffc0206d38 <default_pmm_manager+0x4c0>
ffffffffc02030c0:	00003617          	auipc	a2,0x3
ffffffffc02030c4:	19060613          	addi	a2,a2,400 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02030c8:	24000593          	li	a1,576
ffffffffc02030cc:	00004517          	auipc	a0,0x4
ffffffffc02030d0:	8fc50513          	addi	a0,a0,-1796 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02030d4:	bbafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02030d8:	00004697          	auipc	a3,0x4
ffffffffc02030dc:	b0068693          	addi	a3,a3,-1280 # ffffffffc0206bd8 <default_pmm_manager+0x360>
ffffffffc02030e0:	00003617          	auipc	a2,0x3
ffffffffc02030e4:	17060613          	addi	a2,a2,368 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02030e8:	23f00593          	li	a1,575
ffffffffc02030ec:	00004517          	auipc	a0,0x4
ffffffffc02030f0:	8dc50513          	addi	a0,a0,-1828 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02030f4:	b9afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02030f8:	00004697          	auipc	a3,0x4
ffffffffc02030fc:	c5868693          	addi	a3,a3,-936 # ffffffffc0206d50 <default_pmm_manager+0x4d8>
ffffffffc0203100:	00003617          	auipc	a2,0x3
ffffffffc0203104:	15060613          	addi	a2,a2,336 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203108:	23c00593          	li	a1,572
ffffffffc020310c:	00004517          	auipc	a0,0x4
ffffffffc0203110:	8bc50513          	addi	a0,a0,-1860 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203114:	b7afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203118:	00004697          	auipc	a3,0x4
ffffffffc020311c:	aa868693          	addi	a3,a3,-1368 # ffffffffc0206bc0 <default_pmm_manager+0x348>
ffffffffc0203120:	00003617          	auipc	a2,0x3
ffffffffc0203124:	13060613          	addi	a2,a2,304 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203128:	23b00593          	li	a1,571
ffffffffc020312c:	00004517          	auipc	a0,0x4
ffffffffc0203130:	89c50513          	addi	a0,a0,-1892 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203134:	b5afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203138:	00004697          	auipc	a3,0x4
ffffffffc020313c:	b2868693          	addi	a3,a3,-1240 # ffffffffc0206c60 <default_pmm_manager+0x3e8>
ffffffffc0203140:	00003617          	auipc	a2,0x3
ffffffffc0203144:	11060613          	addi	a2,a2,272 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203148:	23a00593          	li	a1,570
ffffffffc020314c:	00004517          	auipc	a0,0x4
ffffffffc0203150:	87c50513          	addi	a0,a0,-1924 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203154:	b3afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0203158:	00004697          	auipc	a3,0x4
ffffffffc020315c:	be068693          	addi	a3,a3,-1056 # ffffffffc0206d38 <default_pmm_manager+0x4c0>
ffffffffc0203160:	00003617          	auipc	a2,0x3
ffffffffc0203164:	0f060613          	addi	a2,a2,240 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203168:	23900593          	li	a1,569
ffffffffc020316c:	00004517          	auipc	a0,0x4
ffffffffc0203170:	85c50513          	addi	a0,a0,-1956 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203174:	b1afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0203178:	00004697          	auipc	a3,0x4
ffffffffc020317c:	ba868693          	addi	a3,a3,-1112 # ffffffffc0206d20 <default_pmm_manager+0x4a8>
ffffffffc0203180:	00003617          	auipc	a2,0x3
ffffffffc0203184:	0d060613          	addi	a2,a2,208 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203188:	23800593          	li	a1,568
ffffffffc020318c:	00004517          	auipc	a0,0x4
ffffffffc0203190:	83c50513          	addi	a0,a0,-1988 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203194:	afafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0203198:	00004697          	auipc	a3,0x4
ffffffffc020319c:	b5868693          	addi	a3,a3,-1192 # ffffffffc0206cf0 <default_pmm_manager+0x478>
ffffffffc02031a0:	00003617          	auipc	a2,0x3
ffffffffc02031a4:	0b060613          	addi	a2,a2,176 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02031a8:	23700593          	li	a1,567
ffffffffc02031ac:	00004517          	auipc	a0,0x4
ffffffffc02031b0:	81c50513          	addi	a0,a0,-2020 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02031b4:	adafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc02031b8:	00004697          	auipc	a3,0x4
ffffffffc02031bc:	b2068693          	addi	a3,a3,-1248 # ffffffffc0206cd8 <default_pmm_manager+0x460>
ffffffffc02031c0:	00003617          	auipc	a2,0x3
ffffffffc02031c4:	09060613          	addi	a2,a2,144 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02031c8:	23500593          	li	a1,565
ffffffffc02031cc:	00003517          	auipc	a0,0x3
ffffffffc02031d0:	7fc50513          	addi	a0,a0,2044 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02031d4:	abafd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02031d8:	00004697          	auipc	a3,0x4
ffffffffc02031dc:	ae068693          	addi	a3,a3,-1312 # ffffffffc0206cb8 <default_pmm_manager+0x440>
ffffffffc02031e0:	00003617          	auipc	a2,0x3
ffffffffc02031e4:	07060613          	addi	a2,a2,112 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02031e8:	23400593          	li	a1,564
ffffffffc02031ec:	00003517          	auipc	a0,0x3
ffffffffc02031f0:	7dc50513          	addi	a0,a0,2012 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02031f4:	a9afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc02031f8:	00004697          	auipc	a3,0x4
ffffffffc02031fc:	ab068693          	addi	a3,a3,-1360 # ffffffffc0206ca8 <default_pmm_manager+0x430>
ffffffffc0203200:	00003617          	auipc	a2,0x3
ffffffffc0203204:	05060613          	addi	a2,a2,80 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203208:	23300593          	li	a1,563
ffffffffc020320c:	00003517          	auipc	a0,0x3
ffffffffc0203210:	7bc50513          	addi	a0,a0,1980 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203214:	a7afd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc0203218:	00004697          	auipc	a3,0x4
ffffffffc020321c:	a8068693          	addi	a3,a3,-1408 # ffffffffc0206c98 <default_pmm_manager+0x420>
ffffffffc0203220:	00003617          	auipc	a2,0x3
ffffffffc0203224:	03060613          	addi	a2,a2,48 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203228:	23200593          	li	a1,562
ffffffffc020322c:	00003517          	auipc	a0,0x3
ffffffffc0203230:	79c50513          	addi	a0,a0,1948 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203234:	a5afd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc0203238:	00004617          	auipc	a2,0x4
ffffffffc020323c:	80060613          	addi	a2,a2,-2048 # ffffffffc0206a38 <default_pmm_manager+0x1c0>
ffffffffc0203240:	06500593          	li	a1,101
ffffffffc0203244:	00003517          	auipc	a0,0x3
ffffffffc0203248:	78450513          	addi	a0,a0,1924 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020324c:	a42fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0203250:	00004697          	auipc	a3,0x4
ffffffffc0203254:	b6068693          	addi	a3,a3,-1184 # ffffffffc0206db0 <default_pmm_manager+0x538>
ffffffffc0203258:	00003617          	auipc	a2,0x3
ffffffffc020325c:	ff860613          	addi	a2,a2,-8 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203260:	27800593          	li	a1,632
ffffffffc0203264:	00003517          	auipc	a0,0x3
ffffffffc0203268:	76450513          	addi	a0,a0,1892 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020326c:	a22fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0203270:	00004697          	auipc	a3,0x4
ffffffffc0203274:	9f068693          	addi	a3,a3,-1552 # ffffffffc0206c60 <default_pmm_manager+0x3e8>
ffffffffc0203278:	00003617          	auipc	a2,0x3
ffffffffc020327c:	fd860613          	addi	a2,a2,-40 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203280:	23100593          	li	a1,561
ffffffffc0203284:	00003517          	auipc	a0,0x3
ffffffffc0203288:	74450513          	addi	a0,a0,1860 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020328c:	a02fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0203290:	00004697          	auipc	a3,0x4
ffffffffc0203294:	99068693          	addi	a3,a3,-1648 # ffffffffc0206c20 <default_pmm_manager+0x3a8>
ffffffffc0203298:	00003617          	auipc	a2,0x3
ffffffffc020329c:	fb860613          	addi	a2,a2,-72 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02032a0:	23000593          	li	a1,560
ffffffffc02032a4:	00003517          	auipc	a0,0x3
ffffffffc02032a8:	72450513          	addi	a0,a0,1828 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02032ac:	9e2fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02032b0:	86d6                	mv	a3,s5
ffffffffc02032b2:	00003617          	auipc	a2,0x3
ffffffffc02032b6:	5fe60613          	addi	a2,a2,1534 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc02032ba:	22c00593          	li	a1,556
ffffffffc02032be:	00003517          	auipc	a0,0x3
ffffffffc02032c2:	70a50513          	addi	a0,a0,1802 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02032c6:	9c8fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02032ca:	00003617          	auipc	a2,0x3
ffffffffc02032ce:	5e660613          	addi	a2,a2,1510 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc02032d2:	22b00593          	li	a1,555
ffffffffc02032d6:	00003517          	auipc	a0,0x3
ffffffffc02032da:	6f250513          	addi	a0,a0,1778 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02032de:	9b0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02032e2:	00004697          	auipc	a3,0x4
ffffffffc02032e6:	8f668693          	addi	a3,a3,-1802 # ffffffffc0206bd8 <default_pmm_manager+0x360>
ffffffffc02032ea:	00003617          	auipc	a2,0x3
ffffffffc02032ee:	f6660613          	addi	a2,a2,-154 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02032f2:	22900593          	li	a1,553
ffffffffc02032f6:	00003517          	auipc	a0,0x3
ffffffffc02032fa:	6d250513          	addi	a0,a0,1746 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02032fe:	990fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203302:	00004697          	auipc	a3,0x4
ffffffffc0203306:	8be68693          	addi	a3,a3,-1858 # ffffffffc0206bc0 <default_pmm_manager+0x348>
ffffffffc020330a:	00003617          	auipc	a2,0x3
ffffffffc020330e:	f4660613          	addi	a2,a2,-186 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203312:	22800593          	li	a1,552
ffffffffc0203316:	00003517          	auipc	a0,0x3
ffffffffc020331a:	6b250513          	addi	a0,a0,1714 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020331e:	970fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203322:	00004697          	auipc	a3,0x4
ffffffffc0203326:	c4e68693          	addi	a3,a3,-946 # ffffffffc0206f70 <default_pmm_manager+0x6f8>
ffffffffc020332a:	00003617          	auipc	a2,0x3
ffffffffc020332e:	f2660613          	addi	a2,a2,-218 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203332:	26f00593          	li	a1,623
ffffffffc0203336:	00003517          	auipc	a0,0x3
ffffffffc020333a:	69250513          	addi	a0,a0,1682 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020333e:	950fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0203342:	00004697          	auipc	a3,0x4
ffffffffc0203346:	bf668693          	addi	a3,a3,-1034 # ffffffffc0206f38 <default_pmm_manager+0x6c0>
ffffffffc020334a:	00003617          	auipc	a2,0x3
ffffffffc020334e:	f0660613          	addi	a2,a2,-250 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203352:	26c00593          	li	a1,620
ffffffffc0203356:	00003517          	auipc	a0,0x3
ffffffffc020335a:	67250513          	addi	a0,a0,1650 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020335e:	930fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc0203362:	00004697          	auipc	a3,0x4
ffffffffc0203366:	ba668693          	addi	a3,a3,-1114 # ffffffffc0206f08 <default_pmm_manager+0x690>
ffffffffc020336a:	00003617          	auipc	a2,0x3
ffffffffc020336e:	ee660613          	addi	a2,a2,-282 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203372:	26800593          	li	a1,616
ffffffffc0203376:	00003517          	auipc	a0,0x3
ffffffffc020337a:	65250513          	addi	a0,a0,1618 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020337e:	910fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0203382:	00004697          	auipc	a3,0x4
ffffffffc0203386:	b3e68693          	addi	a3,a3,-1218 # ffffffffc0206ec0 <default_pmm_manager+0x648>
ffffffffc020338a:	00003617          	auipc	a2,0x3
ffffffffc020338e:	ec660613          	addi	a2,a2,-314 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203392:	26700593          	li	a1,615
ffffffffc0203396:	00003517          	auipc	a0,0x3
ffffffffc020339a:	63250513          	addi	a0,a0,1586 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020339e:	8f0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02033a2:	00003617          	auipc	a2,0x3
ffffffffc02033a6:	5b660613          	addi	a2,a2,1462 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc02033aa:	0c900593          	li	a1,201
ffffffffc02033ae:	00003517          	auipc	a0,0x3
ffffffffc02033b2:	61a50513          	addi	a0,a0,1562 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02033b6:	8d8fd0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02033ba:	00003617          	auipc	a2,0x3
ffffffffc02033be:	59e60613          	addi	a2,a2,1438 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc02033c2:	08100593          	li	a1,129
ffffffffc02033c6:	00003517          	auipc	a0,0x3
ffffffffc02033ca:	60250513          	addi	a0,a0,1538 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02033ce:	8c0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02033d2:	00003697          	auipc	a3,0x3
ffffffffc02033d6:	7be68693          	addi	a3,a3,1982 # ffffffffc0206b90 <default_pmm_manager+0x318>
ffffffffc02033da:	00003617          	auipc	a2,0x3
ffffffffc02033de:	e7660613          	addi	a2,a2,-394 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02033e2:	22700593          	li	a1,551
ffffffffc02033e6:	00003517          	auipc	a0,0x3
ffffffffc02033ea:	5e250513          	addi	a0,a0,1506 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02033ee:	8a0fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02033f2:	00003697          	auipc	a3,0x3
ffffffffc02033f6:	76e68693          	addi	a3,a3,1902 # ffffffffc0206b60 <default_pmm_manager+0x2e8>
ffffffffc02033fa:	00003617          	auipc	a2,0x3
ffffffffc02033fe:	e5660613          	addi	a2,a2,-426 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203402:	22400593          	li	a1,548
ffffffffc0203406:	00003517          	auipc	a0,0x3
ffffffffc020340a:	5c250513          	addi	a0,a0,1474 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020340e:	880fd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203412 <copy_range>:
{
ffffffffc0203412:	7119                	addi	sp,sp,-128
ffffffffc0203414:	f4a6                	sd	s1,104(sp)
ffffffffc0203416:	84b6                	mv	s1,a3
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203418:	8ed1                	or	a3,a3,a2
{
ffffffffc020341a:	fc86                	sd	ra,120(sp)
ffffffffc020341c:	f8a2                	sd	s0,112(sp)
ffffffffc020341e:	f0ca                	sd	s2,96(sp)
ffffffffc0203420:	ecce                	sd	s3,88(sp)
ffffffffc0203422:	e8d2                	sd	s4,80(sp)
ffffffffc0203424:	e4d6                	sd	s5,72(sp)
ffffffffc0203426:	e0da                	sd	s6,64(sp)
ffffffffc0203428:	fc5e                	sd	s7,56(sp)
ffffffffc020342a:	f862                	sd	s8,48(sp)
ffffffffc020342c:	f466                	sd	s9,40(sp)
ffffffffc020342e:	f06a                	sd	s10,32(sp)
ffffffffc0203430:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203432:	16d2                	slli	a3,a3,0x34
{
ffffffffc0203434:	e43a                	sd	a4,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203436:	24069663          	bnez	a3,ffffffffc0203682 <copy_range+0x270>
    assert(USER_ACCESS(start, end));
ffffffffc020343a:	00200737          	lui	a4,0x200
ffffffffc020343e:	8db2                	mv	s11,a2
ffffffffc0203440:	22e66163          	bltu	a2,a4,ffffffffc0203662 <copy_range+0x250>
ffffffffc0203444:	20967f63          	bgeu	a2,s1,ffffffffc0203662 <copy_range+0x250>
ffffffffc0203448:	4705                	li	a4,1
ffffffffc020344a:	077e                	slli	a4,a4,0x1f
ffffffffc020344c:	20976b63          	bltu	a4,s1,ffffffffc0203662 <copy_range+0x250>
ffffffffc0203450:	5bfd                	li	s7,-1
ffffffffc0203452:	8a2a                	mv	s4,a0
ffffffffc0203454:	842e                	mv	s0,a1
        start += PGSIZE;
ffffffffc0203456:	6985                	lui	s3,0x1
    if (PPN(pa) >= npage)
ffffffffc0203458:	000b2b17          	auipc	s6,0xb2
ffffffffc020345c:	ba8b0b13          	addi	s6,s6,-1112 # ffffffffc02b5000 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0203460:	000b2a97          	auipc	s5,0xb2
ffffffffc0203464:	ba8a8a93          	addi	s5,s5,-1112 # ffffffffc02b5008 <pages>
    return KADDR(page2pa(page));
ffffffffc0203468:	00cbdb93          	srli	s7,s7,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc020346c:	000b2d17          	auipc	s10,0xb2
ffffffffc0203470:	ba4d0d13          	addi	s10,s10,-1116 # ffffffffc02b5010 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0203474:	4601                	li	a2,0
ffffffffc0203476:	85ee                	mv	a1,s11
ffffffffc0203478:	8522                	mv	a0,s0
ffffffffc020347a:	b73fe0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc020347e:	892a                	mv	s2,a0
        if (ptep == NULL)
ffffffffc0203480:	c951                	beqz	a0,ffffffffc0203514 <copy_range+0x102>
        if (*ptep & PTE_V)
ffffffffc0203482:	6118                	ld	a4,0(a0)
ffffffffc0203484:	8b05                	andi	a4,a4,1
ffffffffc0203486:	e705                	bnez	a4,ffffffffc02034ae <copy_range+0x9c>
        start += PGSIZE;
ffffffffc0203488:	9dce                	add	s11,s11,s3
    } while (start != 0 && start < end);
ffffffffc020348a:	fe9de5e3          	bltu	s11,s1,ffffffffc0203474 <copy_range+0x62>
    return 0;
ffffffffc020348e:	4501                	li	a0,0
}
ffffffffc0203490:	70e6                	ld	ra,120(sp)
ffffffffc0203492:	7446                	ld	s0,112(sp)
ffffffffc0203494:	74a6                	ld	s1,104(sp)
ffffffffc0203496:	7906                	ld	s2,96(sp)
ffffffffc0203498:	69e6                	ld	s3,88(sp)
ffffffffc020349a:	6a46                	ld	s4,80(sp)
ffffffffc020349c:	6aa6                	ld	s5,72(sp)
ffffffffc020349e:	6b06                	ld	s6,64(sp)
ffffffffc02034a0:	7be2                	ld	s7,56(sp)
ffffffffc02034a2:	7c42                	ld	s8,48(sp)
ffffffffc02034a4:	7ca2                	ld	s9,40(sp)
ffffffffc02034a6:	7d02                	ld	s10,32(sp)
ffffffffc02034a8:	6de2                	ld	s11,24(sp)
ffffffffc02034aa:	6109                	addi	sp,sp,128
ffffffffc02034ac:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc02034ae:	4605                	li	a2,1
ffffffffc02034b0:	85ee                	mv	a1,s11
ffffffffc02034b2:	8552                	mv	a0,s4
ffffffffc02034b4:	b39fe0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc02034b8:	10050e63          	beqz	a0,ffffffffc02035d4 <copy_range+0x1c2>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc02034bc:	00093703          	ld	a4,0(s2)
    if (!(pte & PTE_V))
ffffffffc02034c0:	00177693          	andi	a3,a4,1
ffffffffc02034c4:	0007091b          	sext.w	s2,a4
ffffffffc02034c8:	18068163          	beqz	a3,ffffffffc020364a <copy_range+0x238>
    if (PPN(pa) >= npage)
ffffffffc02034cc:	000b3683          	ld	a3,0(s6)
    return pa2page(PTE_ADDR(pte));
ffffffffc02034d0:	070a                	slli	a4,a4,0x2
ffffffffc02034d2:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc02034d4:	14d77f63          	bgeu	a4,a3,ffffffffc0203632 <copy_range+0x220>
    return &pages[PPN(pa) - nbase];
ffffffffc02034d8:	000ab583          	ld	a1,0(s5)
ffffffffc02034dc:	fff807b7          	lui	a5,0xfff80
ffffffffc02034e0:	973e                	add	a4,a4,a5
ffffffffc02034e2:	071a                	slli	a4,a4,0x6
ffffffffc02034e4:	00e58cb3          	add	s9,a1,a4
            assert(page != NULL);
ffffffffc02034e8:	120c8563          	beqz	s9,ffffffffc0203612 <copy_range+0x200>
            if (share)
ffffffffc02034ec:	67a2                	ld	a5,8(sp)
ffffffffc02034ee:	c3a1                	beqz	a5,ffffffffc020352e <copy_range+0x11c>
                if ((ret = page_insert(to, page, start, perm & ~PTE_W)) != 0)
ffffffffc02034f0:	01b97913          	andi	s2,s2,27
ffffffffc02034f4:	86ca                	mv	a3,s2
ffffffffc02034f6:	866e                	mv	a2,s11
ffffffffc02034f8:	85e6                	mv	a1,s9
ffffffffc02034fa:	8552                	mv	a0,s4
ffffffffc02034fc:	9e0ff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc0203500:	f941                	bnez	a0,ffffffffc0203490 <copy_range+0x7e>
                if ((ret = page_insert(from, page, start, perm & ~PTE_W)) != 0)
ffffffffc0203502:	86ca                	mv	a3,s2
ffffffffc0203504:	866e                	mv	a2,s11
ffffffffc0203506:	85e6                	mv	a1,s9
ffffffffc0203508:	8522                	mv	a0,s0
ffffffffc020350a:	9d2ff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc020350e:	f149                	bnez	a0,ffffffffc0203490 <copy_range+0x7e>
        start += PGSIZE;
ffffffffc0203510:	9dce                	add	s11,s11,s3
    } while (start != 0 && start < end);
ffffffffc0203512:	bfa5                	j	ffffffffc020348a <copy_range+0x78>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203514:	00200637          	lui	a2,0x200
ffffffffc0203518:	00cd87b3          	add	a5,s11,a2
ffffffffc020351c:	ffe00637          	lui	a2,0xffe00
ffffffffc0203520:	00c7fdb3          	and	s11,a5,a2
    } while (start != 0 && start < end);
ffffffffc0203524:	f60d85e3          	beqz	s11,ffffffffc020348e <copy_range+0x7c>
ffffffffc0203528:	f49de6e3          	bltu	s11,s1,ffffffffc0203474 <copy_range+0x62>
ffffffffc020352c:	b78d                	j	ffffffffc020348e <copy_range+0x7c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020352e:	10002773          	csrr	a4,sstatus
ffffffffc0203532:	8b09                	andi	a4,a4,2
ffffffffc0203534:	e749                	bnez	a4,ffffffffc02035be <copy_range+0x1ac>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203536:	000d3703          	ld	a4,0(s10)
ffffffffc020353a:	4505                	li	a0,1
ffffffffc020353c:	6f18                	ld	a4,24(a4)
ffffffffc020353e:	9702                	jalr	a4
ffffffffc0203540:	8c2a                	mv	s8,a0
                assert(npage != NULL);
ffffffffc0203542:	0a0c0863          	beqz	s8,ffffffffc02035f2 <copy_range+0x1e0>
    return page - pages + nbase;
ffffffffc0203546:	000ab703          	ld	a4,0(s5)
ffffffffc020354a:	000808b7          	lui	a7,0x80
    return KADDR(page2pa(page));
ffffffffc020354e:	000b3603          	ld	a2,0(s6)
    return page - pages + nbase;
ffffffffc0203552:	40ec86b3          	sub	a3,s9,a4
ffffffffc0203556:	8699                	srai	a3,a3,0x6
ffffffffc0203558:	96c6                	add	a3,a3,a7
    return KADDR(page2pa(page));
ffffffffc020355a:	0176f5b3          	and	a1,a3,s7
    return page2ppn(page) << PGSHIFT;
ffffffffc020355e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203560:	06c5fd63          	bgeu	a1,a2,ffffffffc02035da <copy_range+0x1c8>
    return page - pages + nbase;
ffffffffc0203564:	40ec0733          	sub	a4,s8,a4
    return KADDR(page2pa(page));
ffffffffc0203568:	000b2797          	auipc	a5,0xb2
ffffffffc020356c:	ab078793          	addi	a5,a5,-1360 # ffffffffc02b5018 <va_pa_offset>
ffffffffc0203570:	6388                	ld	a0,0(a5)
    return page - pages + nbase;
ffffffffc0203572:	8719                	srai	a4,a4,0x6
ffffffffc0203574:	9746                	add	a4,a4,a7
    return KADDR(page2pa(page));
ffffffffc0203576:	017778b3          	and	a7,a4,s7
ffffffffc020357a:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc020357e:	0732                	slli	a4,a4,0xc
    return KADDR(page2pa(page));
ffffffffc0203580:	04c8fc63          	bgeu	a7,a2,ffffffffc02035d8 <copy_range+0x1c6>
                memcpy((void *)dst_kvaddr, (void *)src_kvaddr, PGSIZE);
ffffffffc0203584:	6605                	lui	a2,0x1
ffffffffc0203586:	953a                	add	a0,a0,a4
ffffffffc0203588:	44e020ef          	jal	ra,ffffffffc02059d6 <memcpy>
                ret = page_insert(to, npage, start, perm);
ffffffffc020358c:	01f97693          	andi	a3,s2,31
ffffffffc0203590:	866e                	mv	a2,s11
ffffffffc0203592:	85e2                	mv	a1,s8
ffffffffc0203594:	8552                	mv	a0,s4
ffffffffc0203596:	946ff0ef          	jal	ra,ffffffffc02026dc <page_insert>
                assert(ret == 0);
ffffffffc020359a:	ee0507e3          	beqz	a0,ffffffffc0203488 <copy_range+0x76>
ffffffffc020359e:	00004697          	auipc	a3,0x4
ffffffffc02035a2:	a3a68693          	addi	a3,a3,-1478 # ffffffffc0206fd8 <default_pmm_manager+0x760>
ffffffffc02035a6:	00003617          	auipc	a2,0x3
ffffffffc02035aa:	caa60613          	addi	a2,a2,-854 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02035ae:	1bb00593          	li	a1,443
ffffffffc02035b2:	00003517          	auipc	a0,0x3
ffffffffc02035b6:	41650513          	addi	a0,a0,1046 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc02035ba:	ed5fc0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc02035be:	bf6fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02035c2:	000d3703          	ld	a4,0(s10)
ffffffffc02035c6:	4505                	li	a0,1
ffffffffc02035c8:	6f18                	ld	a4,24(a4)
ffffffffc02035ca:	9702                	jalr	a4
ffffffffc02035cc:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02035ce:	be0fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02035d2:	bf85                	j	ffffffffc0203542 <copy_range+0x130>
                return -E_NO_MEM;
ffffffffc02035d4:	5571                	li	a0,-4
ffffffffc02035d6:	bd6d                	j	ffffffffc0203490 <copy_range+0x7e>
ffffffffc02035d8:	86ba                	mv	a3,a4
ffffffffc02035da:	00003617          	auipc	a2,0x3
ffffffffc02035de:	2d660613          	addi	a2,a2,726 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc02035e2:	07100593          	li	a1,113
ffffffffc02035e6:	00003517          	auipc	a0,0x3
ffffffffc02035ea:	2f250513          	addi	a0,a0,754 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc02035ee:	ea1fc0ef          	jal	ra,ffffffffc020048e <__panic>
                assert(npage != NULL);
ffffffffc02035f2:	00004697          	auipc	a3,0x4
ffffffffc02035f6:	9d668693          	addi	a3,a3,-1578 # ffffffffc0206fc8 <default_pmm_manager+0x750>
ffffffffc02035fa:	00003617          	auipc	a2,0x3
ffffffffc02035fe:	c5660613          	addi	a2,a2,-938 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203602:	1b600593          	li	a1,438
ffffffffc0203606:	00003517          	auipc	a0,0x3
ffffffffc020360a:	3c250513          	addi	a0,a0,962 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020360e:	e81fc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc0203612:	00004697          	auipc	a3,0x4
ffffffffc0203616:	9a668693          	addi	a3,a3,-1626 # ffffffffc0206fb8 <default_pmm_manager+0x740>
ffffffffc020361a:	00003617          	auipc	a2,0x3
ffffffffc020361e:	c3660613          	addi	a2,a2,-970 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203622:	19300593          	li	a1,403
ffffffffc0203626:	00003517          	auipc	a0,0x3
ffffffffc020362a:	3a250513          	addi	a0,a0,930 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020362e:	e61fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203632:	00003617          	auipc	a2,0x3
ffffffffc0203636:	34e60613          	addi	a2,a2,846 # ffffffffc0206980 <default_pmm_manager+0x108>
ffffffffc020363a:	06900593          	li	a1,105
ffffffffc020363e:	00003517          	auipc	a0,0x3
ffffffffc0203642:	29a50513          	addi	a0,a0,666 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0203646:	e49fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc020364a:	00003617          	auipc	a2,0x3
ffffffffc020364e:	35660613          	addi	a2,a2,854 # ffffffffc02069a0 <default_pmm_manager+0x128>
ffffffffc0203652:	07f00593          	li	a1,127
ffffffffc0203656:	00003517          	auipc	a0,0x3
ffffffffc020365a:	28250513          	addi	a0,a0,642 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc020365e:	e31fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0203662:	00003697          	auipc	a3,0x3
ffffffffc0203666:	3a668693          	addi	a3,a3,934 # ffffffffc0206a08 <default_pmm_manager+0x190>
ffffffffc020366a:	00003617          	auipc	a2,0x3
ffffffffc020366e:	be660613          	addi	a2,a2,-1050 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203672:	17c00593          	li	a1,380
ffffffffc0203676:	00003517          	auipc	a0,0x3
ffffffffc020367a:	35250513          	addi	a0,a0,850 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020367e:	e11fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203682:	00003697          	auipc	a3,0x3
ffffffffc0203686:	35668693          	addi	a3,a3,854 # ffffffffc02069d8 <default_pmm_manager+0x160>
ffffffffc020368a:	00003617          	auipc	a2,0x3
ffffffffc020368e:	bc660613          	addi	a2,a2,-1082 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203692:	17b00593          	li	a1,379
ffffffffc0203696:	00003517          	auipc	a0,0x3
ffffffffc020369a:	33250513          	addi	a0,a0,818 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc020369e:	df1fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036a2 <pgdir_alloc_page>:
{
ffffffffc02036a2:	7179                	addi	sp,sp,-48
ffffffffc02036a4:	ec26                	sd	s1,24(sp)
ffffffffc02036a6:	e84a                	sd	s2,16(sp)
ffffffffc02036a8:	e052                	sd	s4,0(sp)
ffffffffc02036aa:	f406                	sd	ra,40(sp)
ffffffffc02036ac:	f022                	sd	s0,32(sp)
ffffffffc02036ae:	e44e                	sd	s3,8(sp)
ffffffffc02036b0:	8a2a                	mv	s4,a0
ffffffffc02036b2:	84ae                	mv	s1,a1
ffffffffc02036b4:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02036b6:	100027f3          	csrr	a5,sstatus
ffffffffc02036ba:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc02036bc:	000b2997          	auipc	s3,0xb2
ffffffffc02036c0:	95498993          	addi	s3,s3,-1708 # ffffffffc02b5010 <pmm_manager>
ffffffffc02036c4:	ef8d                	bnez	a5,ffffffffc02036fe <pgdir_alloc_page+0x5c>
ffffffffc02036c6:	0009b783          	ld	a5,0(s3)
ffffffffc02036ca:	4505                	li	a0,1
ffffffffc02036cc:	6f9c                	ld	a5,24(a5)
ffffffffc02036ce:	9782                	jalr	a5
ffffffffc02036d0:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc02036d2:	cc09                	beqz	s0,ffffffffc02036ec <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc02036d4:	86ca                	mv	a3,s2
ffffffffc02036d6:	8626                	mv	a2,s1
ffffffffc02036d8:	85a2                	mv	a1,s0
ffffffffc02036da:	8552                	mv	a0,s4
ffffffffc02036dc:	800ff0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc02036e0:	e915                	bnez	a0,ffffffffc0203714 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc02036e2:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc02036e4:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc02036e6:	4785                	li	a5,1
ffffffffc02036e8:	04f71e63          	bne	a4,a5,ffffffffc0203744 <pgdir_alloc_page+0xa2>
}
ffffffffc02036ec:	70a2                	ld	ra,40(sp)
ffffffffc02036ee:	8522                	mv	a0,s0
ffffffffc02036f0:	7402                	ld	s0,32(sp)
ffffffffc02036f2:	64e2                	ld	s1,24(sp)
ffffffffc02036f4:	6942                	ld	s2,16(sp)
ffffffffc02036f6:	69a2                	ld	s3,8(sp)
ffffffffc02036f8:	6a02                	ld	s4,0(sp)
ffffffffc02036fa:	6145                	addi	sp,sp,48
ffffffffc02036fc:	8082                	ret
        intr_disable();
ffffffffc02036fe:	ab6fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203702:	0009b783          	ld	a5,0(s3)
ffffffffc0203706:	4505                	li	a0,1
ffffffffc0203708:	6f9c                	ld	a5,24(a5)
ffffffffc020370a:	9782                	jalr	a5
ffffffffc020370c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020370e:	aa0fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203712:	b7c1                	j	ffffffffc02036d2 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203714:	100027f3          	csrr	a5,sstatus
ffffffffc0203718:	8b89                	andi	a5,a5,2
ffffffffc020371a:	eb89                	bnez	a5,ffffffffc020372c <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc020371c:	0009b783          	ld	a5,0(s3)
ffffffffc0203720:	8522                	mv	a0,s0
ffffffffc0203722:	4585                	li	a1,1
ffffffffc0203724:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc0203726:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc0203728:	9782                	jalr	a5
    if (flag)
ffffffffc020372a:	b7c9                	j	ffffffffc02036ec <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc020372c:	a88fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203730:	0009b783          	ld	a5,0(s3)
ffffffffc0203734:	8522                	mv	a0,s0
ffffffffc0203736:	4585                	li	a1,1
ffffffffc0203738:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020373a:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020373c:	9782                	jalr	a5
        intr_enable();
ffffffffc020373e:	a70fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203742:	b76d                	j	ffffffffc02036ec <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc0203744:	00004697          	auipc	a3,0x4
ffffffffc0203748:	8a468693          	addi	a3,a3,-1884 # ffffffffc0206fe8 <default_pmm_manager+0x770>
ffffffffc020374c:	00003617          	auipc	a2,0x3
ffffffffc0203750:	b0460613          	addi	a2,a2,-1276 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203754:	20500593          	li	a1,517
ffffffffc0203758:	00003517          	auipc	a0,0x3
ffffffffc020375c:	27050513          	addi	a0,a0,624 # ffffffffc02069c8 <default_pmm_manager+0x150>
ffffffffc0203760:	d2ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203764 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203764:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0203766:	00004697          	auipc	a3,0x4
ffffffffc020376a:	89a68693          	addi	a3,a3,-1894 # ffffffffc0207000 <default_pmm_manager+0x788>
ffffffffc020376e:	00003617          	auipc	a2,0x3
ffffffffc0203772:	ae260613          	addi	a2,a2,-1310 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203776:	07600593          	li	a1,118
ffffffffc020377a:	00004517          	auipc	a0,0x4
ffffffffc020377e:	8a650513          	addi	a0,a0,-1882 # ffffffffc0207020 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0203782:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0203784:	d0bfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203788 <mm_create>:
{
ffffffffc0203788:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020378a:	04000513          	li	a0,64
{
ffffffffc020378e:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203790:	dc6fe0ef          	jal	ra,ffffffffc0201d56 <kmalloc>
    if (mm != NULL)
ffffffffc0203794:	cd19                	beqz	a0,ffffffffc02037b2 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc0203796:	e508                	sd	a0,8(a0)
ffffffffc0203798:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc020379a:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020379e:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc02037a2:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc02037a6:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc02037aa:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc02037ae:	02053c23          	sd	zero,56(a0)
}
ffffffffc02037b2:	60a2                	ld	ra,8(sp)
ffffffffc02037b4:	0141                	addi	sp,sp,16
ffffffffc02037b6:	8082                	ret

ffffffffc02037b8 <find_vma>:
{
ffffffffc02037b8:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc02037ba:	c505                	beqz	a0,ffffffffc02037e2 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc02037bc:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02037be:	c501                	beqz	a0,ffffffffc02037c6 <find_vma+0xe>
ffffffffc02037c0:	651c                	ld	a5,8(a0)
ffffffffc02037c2:	02f5f263          	bgeu	a1,a5,ffffffffc02037e6 <find_vma+0x2e>
    return listelm->next;
ffffffffc02037c6:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc02037c8:	00f68d63          	beq	a3,a5,ffffffffc02037e2 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc02037cc:	fe87b703          	ld	a4,-24(a5)
ffffffffc02037d0:	00e5e663          	bltu	a1,a4,ffffffffc02037dc <find_vma+0x24>
ffffffffc02037d4:	ff07b703          	ld	a4,-16(a5)
ffffffffc02037d8:	00e5ec63          	bltu	a1,a4,ffffffffc02037f0 <find_vma+0x38>
ffffffffc02037dc:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc02037de:	fef697e3          	bne	a3,a5,ffffffffc02037cc <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc02037e2:	4501                	li	a0,0
}
ffffffffc02037e4:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc02037e6:	691c                	ld	a5,16(a0)
ffffffffc02037e8:	fcf5ffe3          	bgeu	a1,a5,ffffffffc02037c6 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc02037ec:	ea88                	sd	a0,16(a3)
ffffffffc02037ee:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc02037f0:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc02037f4:	ea88                	sd	a0,16(a3)
ffffffffc02037f6:	8082                	ret

ffffffffc02037f8 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037f8:	6590                	ld	a2,8(a1)
ffffffffc02037fa:	0105b803          	ld	a6,16(a1)
{
ffffffffc02037fe:	1141                	addi	sp,sp,-16
ffffffffc0203800:	e406                	sd	ra,8(sp)
ffffffffc0203802:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203804:	01066763          	bltu	a2,a6,ffffffffc0203812 <insert_vma_struct+0x1a>
ffffffffc0203808:	a085                	j	ffffffffc0203868 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020380a:	fe87b703          	ld	a4,-24(a5)
ffffffffc020380e:	04e66863          	bltu	a2,a4,ffffffffc020385e <insert_vma_struct+0x66>
ffffffffc0203812:	86be                	mv	a3,a5
ffffffffc0203814:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0203816:	fef51ae3          	bne	a0,a5,ffffffffc020380a <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020381a:	02a68463          	beq	a3,a0,ffffffffc0203842 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc020381e:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203822:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203826:	08e8f163          	bgeu	a7,a4,ffffffffc02038a8 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020382a:	04e66f63          	bltu	a2,a4,ffffffffc0203888 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc020382e:	00f50a63          	beq	a0,a5,ffffffffc0203842 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203832:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203836:	05076963          	bltu	a4,a6,ffffffffc0203888 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020383a:	ff07b603          	ld	a2,-16(a5)
ffffffffc020383e:	02c77363          	bgeu	a4,a2,ffffffffc0203864 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0203842:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0203844:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0203846:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc020384a:	e390                	sd	a2,0(a5)
ffffffffc020384c:	e690                	sd	a2,8(a3)
}
ffffffffc020384e:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0203850:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0203852:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0203854:	0017079b          	addiw	a5,a4,1
ffffffffc0203858:	d11c                	sw	a5,32(a0)
}
ffffffffc020385a:	0141                	addi	sp,sp,16
ffffffffc020385c:	8082                	ret
    if (le_prev != list)
ffffffffc020385e:	fca690e3          	bne	a3,a0,ffffffffc020381e <insert_vma_struct+0x26>
ffffffffc0203862:	bfd1                	j	ffffffffc0203836 <insert_vma_struct+0x3e>
ffffffffc0203864:	f01ff0ef          	jal	ra,ffffffffc0203764 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203868:	00003697          	auipc	a3,0x3
ffffffffc020386c:	7c868693          	addi	a3,a3,1992 # ffffffffc0207030 <default_pmm_manager+0x7b8>
ffffffffc0203870:	00003617          	auipc	a2,0x3
ffffffffc0203874:	9e060613          	addi	a2,a2,-1568 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203878:	07c00593          	li	a1,124
ffffffffc020387c:	00003517          	auipc	a0,0x3
ffffffffc0203880:	7a450513          	addi	a0,a0,1956 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203884:	c0bfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0203888:	00003697          	auipc	a3,0x3
ffffffffc020388c:	7e868693          	addi	a3,a3,2024 # ffffffffc0207070 <default_pmm_manager+0x7f8>
ffffffffc0203890:	00003617          	auipc	a2,0x3
ffffffffc0203894:	9c060613          	addi	a2,a2,-1600 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203898:	07500593          	li	a1,117
ffffffffc020389c:	00003517          	auipc	a0,0x3
ffffffffc02038a0:	78450513          	addi	a0,a0,1924 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc02038a4:	bebfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc02038a8:	00003697          	auipc	a3,0x3
ffffffffc02038ac:	7a868693          	addi	a3,a3,1960 # ffffffffc0207050 <default_pmm_manager+0x7d8>
ffffffffc02038b0:	00003617          	auipc	a2,0x3
ffffffffc02038b4:	9a060613          	addi	a2,a2,-1632 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02038b8:	07400593          	li	a1,116
ffffffffc02038bc:	00003517          	auipc	a0,0x3
ffffffffc02038c0:	76450513          	addi	a0,a0,1892 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc02038c4:	bcbfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02038c8 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc02038c8:	591c                	lw	a5,48(a0)
{
ffffffffc02038ca:	1141                	addi	sp,sp,-16
ffffffffc02038cc:	e406                	sd	ra,8(sp)
ffffffffc02038ce:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc02038d0:	e78d                	bnez	a5,ffffffffc02038fa <mm_destroy+0x32>
ffffffffc02038d2:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc02038d4:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc02038d6:	00a40c63          	beq	s0,a0,ffffffffc02038ee <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc02038da:	6118                	ld	a4,0(a0)
ffffffffc02038dc:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc02038de:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc02038e0:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc02038e2:	e398                	sd	a4,0(a5)
ffffffffc02038e4:	d22fe0ef          	jal	ra,ffffffffc0201e06 <kfree>
    return listelm->next;
ffffffffc02038e8:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc02038ea:	fea418e3          	bne	s0,a0,ffffffffc02038da <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc02038ee:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc02038f0:	6402                	ld	s0,0(sp)
ffffffffc02038f2:	60a2                	ld	ra,8(sp)
ffffffffc02038f4:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc02038f6:	d10fe06f          	j	ffffffffc0201e06 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc02038fa:	00003697          	auipc	a3,0x3
ffffffffc02038fe:	79668693          	addi	a3,a3,1942 # ffffffffc0207090 <default_pmm_manager+0x818>
ffffffffc0203902:	00003617          	auipc	a2,0x3
ffffffffc0203906:	94e60613          	addi	a2,a2,-1714 # ffffffffc0206250 <commands+0x5f8>
ffffffffc020390a:	0a000593          	li	a1,160
ffffffffc020390e:	00003517          	auipc	a0,0x3
ffffffffc0203912:	71250513          	addi	a0,a0,1810 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203916:	b79fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020391a <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc020391a:	7139                	addi	sp,sp,-64
ffffffffc020391c:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020391e:	6405                	lui	s0,0x1
ffffffffc0203920:	147d                	addi	s0,s0,-1
ffffffffc0203922:	77fd                	lui	a5,0xfffff
ffffffffc0203924:	9622                	add	a2,a2,s0
ffffffffc0203926:	962e                	add	a2,a2,a1
{
ffffffffc0203928:	f426                	sd	s1,40(sp)
ffffffffc020392a:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc020392c:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203930:	f04a                	sd	s2,32(sp)
ffffffffc0203932:	ec4e                	sd	s3,24(sp)
ffffffffc0203934:	e852                	sd	s4,16(sp)
ffffffffc0203936:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc0203938:	002005b7          	lui	a1,0x200
ffffffffc020393c:	00f67433          	and	s0,a2,a5
ffffffffc0203940:	06b4e363          	bltu	s1,a1,ffffffffc02039a6 <mm_map+0x8c>
ffffffffc0203944:	0684f163          	bgeu	s1,s0,ffffffffc02039a6 <mm_map+0x8c>
ffffffffc0203948:	4785                	li	a5,1
ffffffffc020394a:	07fe                	slli	a5,a5,0x1f
ffffffffc020394c:	0487ed63          	bltu	a5,s0,ffffffffc02039a6 <mm_map+0x8c>
ffffffffc0203950:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc0203952:	cd21                	beqz	a0,ffffffffc02039aa <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc0203954:	85a6                	mv	a1,s1
ffffffffc0203956:	8ab6                	mv	s5,a3
ffffffffc0203958:	8a3a                	mv	s4,a4
ffffffffc020395a:	e5fff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
ffffffffc020395e:	c501                	beqz	a0,ffffffffc0203966 <mm_map+0x4c>
ffffffffc0203960:	651c                	ld	a5,8(a0)
ffffffffc0203962:	0487e263          	bltu	a5,s0,ffffffffc02039a6 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203966:	03000513          	li	a0,48
ffffffffc020396a:	becfe0ef          	jal	ra,ffffffffc0201d56 <kmalloc>
ffffffffc020396e:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc0203970:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0203972:	02090163          	beqz	s2,ffffffffc0203994 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0203976:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0203978:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc020397c:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0203980:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0203984:	85ca                	mv	a1,s2
ffffffffc0203986:	e73ff0ef          	jal	ra,ffffffffc02037f8 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc020398a:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc020398c:	000a0463          	beqz	s4,ffffffffc0203994 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0203990:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc0203994:	70e2                	ld	ra,56(sp)
ffffffffc0203996:	7442                	ld	s0,48(sp)
ffffffffc0203998:	74a2                	ld	s1,40(sp)
ffffffffc020399a:	7902                	ld	s2,32(sp)
ffffffffc020399c:	69e2                	ld	s3,24(sp)
ffffffffc020399e:	6a42                	ld	s4,16(sp)
ffffffffc02039a0:	6aa2                	ld	s5,8(sp)
ffffffffc02039a2:	6121                	addi	sp,sp,64
ffffffffc02039a4:	8082                	ret
        return -E_INVAL;
ffffffffc02039a6:	5575                	li	a0,-3
ffffffffc02039a8:	b7f5                	j	ffffffffc0203994 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc02039aa:	00003697          	auipc	a3,0x3
ffffffffc02039ae:	6fe68693          	addi	a3,a3,1790 # ffffffffc02070a8 <default_pmm_manager+0x830>
ffffffffc02039b2:	00003617          	auipc	a2,0x3
ffffffffc02039b6:	89e60613          	addi	a2,a2,-1890 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02039ba:	0b500593          	li	a1,181
ffffffffc02039be:	00003517          	auipc	a0,0x3
ffffffffc02039c2:	66250513          	addi	a0,a0,1634 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc02039c6:	ac9fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02039ca <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc02039ca:	7139                	addi	sp,sp,-64
ffffffffc02039cc:	fc06                	sd	ra,56(sp)
ffffffffc02039ce:	f822                	sd	s0,48(sp)
ffffffffc02039d0:	f426                	sd	s1,40(sp)
ffffffffc02039d2:	f04a                	sd	s2,32(sp)
ffffffffc02039d4:	ec4e                	sd	s3,24(sp)
ffffffffc02039d6:	e852                	sd	s4,16(sp)
ffffffffc02039d8:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc02039da:	c52d                	beqz	a0,ffffffffc0203a44 <dup_mmap+0x7a>
ffffffffc02039dc:	892a                	mv	s2,a0
ffffffffc02039de:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc02039e0:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc02039e2:	e595                	bnez	a1,ffffffffc0203a0e <dup_mmap+0x44>
ffffffffc02039e4:	a085                	j	ffffffffc0203a44 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc02039e6:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc02039e8:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ee8>
        vma->vm_end = vm_end;
ffffffffc02039ec:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc02039f0:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc02039f4:	e05ff0ef          	jal	ra,ffffffffc02037f8 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc02039f8:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc02039fc:	fe843603          	ld	a2,-24(s0)
ffffffffc0203a00:	6c8c                	ld	a1,24(s1)
ffffffffc0203a02:	01893503          	ld	a0,24(s2)
ffffffffc0203a06:	4701                	li	a4,0
ffffffffc0203a08:	a0bff0ef          	jal	ra,ffffffffc0203412 <copy_range>
ffffffffc0203a0c:	e105                	bnez	a0,ffffffffc0203a2c <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203a0e:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203a10:	02848863          	beq	s1,s0,ffffffffc0203a40 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a14:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0203a18:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203a1c:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203a20:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a24:	b32fe0ef          	jal	ra,ffffffffc0201d56 <kmalloc>
ffffffffc0203a28:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0203a2a:	fd55                	bnez	a0,ffffffffc02039e6 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203a2c:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203a2e:	70e2                	ld	ra,56(sp)
ffffffffc0203a30:	7442                	ld	s0,48(sp)
ffffffffc0203a32:	74a2                	ld	s1,40(sp)
ffffffffc0203a34:	7902                	ld	s2,32(sp)
ffffffffc0203a36:	69e2                	ld	s3,24(sp)
ffffffffc0203a38:	6a42                	ld	s4,16(sp)
ffffffffc0203a3a:	6aa2                	ld	s5,8(sp)
ffffffffc0203a3c:	6121                	addi	sp,sp,64
ffffffffc0203a3e:	8082                	ret
    return 0;
ffffffffc0203a40:	4501                	li	a0,0
ffffffffc0203a42:	b7f5                	j	ffffffffc0203a2e <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0203a44:	00003697          	auipc	a3,0x3
ffffffffc0203a48:	67468693          	addi	a3,a3,1652 # ffffffffc02070b8 <default_pmm_manager+0x840>
ffffffffc0203a4c:	00003617          	auipc	a2,0x3
ffffffffc0203a50:	80460613          	addi	a2,a2,-2044 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203a54:	0d100593          	li	a1,209
ffffffffc0203a58:	00003517          	auipc	a0,0x3
ffffffffc0203a5c:	5c850513          	addi	a0,a0,1480 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203a60:	a2ffc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a64 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0203a64:	1101                	addi	sp,sp,-32
ffffffffc0203a66:	ec06                	sd	ra,24(sp)
ffffffffc0203a68:	e822                	sd	s0,16(sp)
ffffffffc0203a6a:	e426                	sd	s1,8(sp)
ffffffffc0203a6c:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203a6e:	c531                	beqz	a0,ffffffffc0203aba <exit_mmap+0x56>
ffffffffc0203a70:	591c                	lw	a5,48(a0)
ffffffffc0203a72:	84aa                	mv	s1,a0
ffffffffc0203a74:	e3b9                	bnez	a5,ffffffffc0203aba <exit_mmap+0x56>
    return listelm->next;
ffffffffc0203a76:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0203a78:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0203a7c:	02850663          	beq	a0,s0,ffffffffc0203aa8 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203a80:	ff043603          	ld	a2,-16(s0)
ffffffffc0203a84:	fe843583          	ld	a1,-24(s0)
ffffffffc0203a88:	854a                	mv	a0,s2
ffffffffc0203a8a:	fdefe0ef          	jal	ra,ffffffffc0202268 <unmap_range>
ffffffffc0203a8e:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203a90:	fe8498e3          	bne	s1,s0,ffffffffc0203a80 <exit_mmap+0x1c>
ffffffffc0203a94:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0203a96:	00848c63          	beq	s1,s0,ffffffffc0203aae <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0203a9a:	ff043603          	ld	a2,-16(s0)
ffffffffc0203a9e:	fe843583          	ld	a1,-24(s0)
ffffffffc0203aa2:	854a                	mv	a0,s2
ffffffffc0203aa4:	90bfe0ef          	jal	ra,ffffffffc02023ae <exit_range>
ffffffffc0203aa8:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203aaa:	fe8498e3          	bne	s1,s0,ffffffffc0203a9a <exit_mmap+0x36>
    }
}
ffffffffc0203aae:	60e2                	ld	ra,24(sp)
ffffffffc0203ab0:	6442                	ld	s0,16(sp)
ffffffffc0203ab2:	64a2                	ld	s1,8(sp)
ffffffffc0203ab4:	6902                	ld	s2,0(sp)
ffffffffc0203ab6:	6105                	addi	sp,sp,32
ffffffffc0203ab8:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203aba:	00003697          	auipc	a3,0x3
ffffffffc0203abe:	61e68693          	addi	a3,a3,1566 # ffffffffc02070d8 <default_pmm_manager+0x860>
ffffffffc0203ac2:	00002617          	auipc	a2,0x2
ffffffffc0203ac6:	78e60613          	addi	a2,a2,1934 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203aca:	0ea00593          	li	a1,234
ffffffffc0203ace:	00003517          	auipc	a0,0x3
ffffffffc0203ad2:	55250513          	addi	a0,a0,1362 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203ad6:	9b9fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203ada <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203ada:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203adc:	04000513          	li	a0,64
{
ffffffffc0203ae0:	fc06                	sd	ra,56(sp)
ffffffffc0203ae2:	f822                	sd	s0,48(sp)
ffffffffc0203ae4:	f426                	sd	s1,40(sp)
ffffffffc0203ae6:	f04a                	sd	s2,32(sp)
ffffffffc0203ae8:	ec4e                	sd	s3,24(sp)
ffffffffc0203aea:	e852                	sd	s4,16(sp)
ffffffffc0203aec:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203aee:	a68fe0ef          	jal	ra,ffffffffc0201d56 <kmalloc>
    if (mm != NULL)
ffffffffc0203af2:	2e050663          	beqz	a0,ffffffffc0203dde <vmm_init+0x304>
ffffffffc0203af6:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203af8:	e508                	sd	a0,8(a0)
ffffffffc0203afa:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203afc:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203b00:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203b04:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203b08:	02053423          	sd	zero,40(a0)
ffffffffc0203b0c:	02052823          	sw	zero,48(a0)
ffffffffc0203b10:	02053c23          	sd	zero,56(a0)
ffffffffc0203b14:	03200413          	li	s0,50
ffffffffc0203b18:	a811                	j	ffffffffc0203b2c <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203b1a:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203b1c:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b1e:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203b22:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b24:	8526                	mv	a0,s1
ffffffffc0203b26:	cd3ff0ef          	jal	ra,ffffffffc02037f8 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203b2a:	c80d                	beqz	s0,ffffffffc0203b5c <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b2c:	03000513          	li	a0,48
ffffffffc0203b30:	a26fe0ef          	jal	ra,ffffffffc0201d56 <kmalloc>
ffffffffc0203b34:	85aa                	mv	a1,a0
ffffffffc0203b36:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203b3a:	f165                	bnez	a0,ffffffffc0203b1a <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203b3c:	00003697          	auipc	a3,0x3
ffffffffc0203b40:	73468693          	addi	a3,a3,1844 # ffffffffc0207270 <default_pmm_manager+0x9f8>
ffffffffc0203b44:	00002617          	auipc	a2,0x2
ffffffffc0203b48:	70c60613          	addi	a2,a2,1804 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203b4c:	12e00593          	li	a1,302
ffffffffc0203b50:	00003517          	auipc	a0,0x3
ffffffffc0203b54:	4d050513          	addi	a0,a0,1232 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203b58:	937fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203b5c:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b60:	1f900913          	li	s2,505
ffffffffc0203b64:	a819                	j	ffffffffc0203b7a <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203b66:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203b68:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203b6a:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b6e:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203b70:	8526                	mv	a0,s1
ffffffffc0203b72:	c87ff0ef          	jal	ra,ffffffffc02037f8 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203b76:	03240a63          	beq	s0,s2,ffffffffc0203baa <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203b7a:	03000513          	li	a0,48
ffffffffc0203b7e:	9d8fe0ef          	jal	ra,ffffffffc0201d56 <kmalloc>
ffffffffc0203b82:	85aa                	mv	a1,a0
ffffffffc0203b84:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203b88:	fd79                	bnez	a0,ffffffffc0203b66 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203b8a:	00003697          	auipc	a3,0x3
ffffffffc0203b8e:	6e668693          	addi	a3,a3,1766 # ffffffffc0207270 <default_pmm_manager+0x9f8>
ffffffffc0203b92:	00002617          	auipc	a2,0x2
ffffffffc0203b96:	6be60613          	addi	a2,a2,1726 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203b9a:	13500593          	li	a1,309
ffffffffc0203b9e:	00003517          	auipc	a0,0x3
ffffffffc0203ba2:	48250513          	addi	a0,a0,1154 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203ba6:	8e9fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203baa:	649c                	ld	a5,8(s1)
ffffffffc0203bac:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203bae:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203bb2:	16f48663          	beq	s1,a5,ffffffffc0203d1e <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203bb6:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd49f9c>
ffffffffc0203bba:	ffe70693          	addi	a3,a4,-2 # 1ffffe <_binary_obj___user_exit_out_size+0x1f4ede>
ffffffffc0203bbe:	10d61063          	bne	a2,a3,ffffffffc0203cbe <vmm_init+0x1e4>
ffffffffc0203bc2:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203bc6:	0ed71c63          	bne	a4,a3,ffffffffc0203cbe <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203bca:	0715                	addi	a4,a4,5
ffffffffc0203bcc:	679c                	ld	a5,8(a5)
ffffffffc0203bce:	feb712e3          	bne	a4,a1,ffffffffc0203bb2 <vmm_init+0xd8>
ffffffffc0203bd2:	4a1d                	li	s4,7
ffffffffc0203bd4:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203bd6:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203bda:	85a2                	mv	a1,s0
ffffffffc0203bdc:	8526                	mv	a0,s1
ffffffffc0203bde:	bdbff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
ffffffffc0203be2:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203be4:	16050d63          	beqz	a0,ffffffffc0203d5e <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203be8:	00140593          	addi	a1,s0,1
ffffffffc0203bec:	8526                	mv	a0,s1
ffffffffc0203bee:	bcbff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
ffffffffc0203bf2:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203bf4:	14050563          	beqz	a0,ffffffffc0203d3e <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203bf8:	85d2                	mv	a1,s4
ffffffffc0203bfa:	8526                	mv	a0,s1
ffffffffc0203bfc:	bbdff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
        assert(vma3 == NULL);
ffffffffc0203c00:	16051f63          	bnez	a0,ffffffffc0203d7e <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203c04:	00340593          	addi	a1,s0,3
ffffffffc0203c08:	8526                	mv	a0,s1
ffffffffc0203c0a:	bafff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
        assert(vma4 == NULL);
ffffffffc0203c0e:	1a051863          	bnez	a0,ffffffffc0203dbe <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203c12:	00440593          	addi	a1,s0,4
ffffffffc0203c16:	8526                	mv	a0,s1
ffffffffc0203c18:	ba1ff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
        assert(vma5 == NULL);
ffffffffc0203c1c:	18051163          	bnez	a0,ffffffffc0203d9e <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c20:	00893783          	ld	a5,8(s2)
ffffffffc0203c24:	0a879d63          	bne	a5,s0,ffffffffc0203cde <vmm_init+0x204>
ffffffffc0203c28:	01093783          	ld	a5,16(s2)
ffffffffc0203c2c:	0b479963          	bne	a5,s4,ffffffffc0203cde <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c30:	0089b783          	ld	a5,8(s3)
ffffffffc0203c34:	0c879563          	bne	a5,s0,ffffffffc0203cfe <vmm_init+0x224>
ffffffffc0203c38:	0109b783          	ld	a5,16(s3)
ffffffffc0203c3c:	0d479163          	bne	a5,s4,ffffffffc0203cfe <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203c40:	0415                	addi	s0,s0,5
ffffffffc0203c42:	0a15                	addi	s4,s4,5
ffffffffc0203c44:	f9541be3          	bne	s0,s5,ffffffffc0203bda <vmm_init+0x100>
ffffffffc0203c48:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203c4a:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203c4c:	85a2                	mv	a1,s0
ffffffffc0203c4e:	8526                	mv	a0,s1
ffffffffc0203c50:	b69ff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
ffffffffc0203c54:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203c58:	c90d                	beqz	a0,ffffffffc0203c8a <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203c5a:	6914                	ld	a3,16(a0)
ffffffffc0203c5c:	6510                	ld	a2,8(a0)
ffffffffc0203c5e:	00003517          	auipc	a0,0x3
ffffffffc0203c62:	59a50513          	addi	a0,a0,1434 # ffffffffc02071f8 <default_pmm_manager+0x980>
ffffffffc0203c66:	d2efc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203c6a:	00003697          	auipc	a3,0x3
ffffffffc0203c6e:	5b668693          	addi	a3,a3,1462 # ffffffffc0207220 <default_pmm_manager+0x9a8>
ffffffffc0203c72:	00002617          	auipc	a2,0x2
ffffffffc0203c76:	5de60613          	addi	a2,a2,1502 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203c7a:	15b00593          	li	a1,347
ffffffffc0203c7e:	00003517          	auipc	a0,0x3
ffffffffc0203c82:	3a250513          	addi	a0,a0,930 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203c86:	809fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203c8a:	147d                	addi	s0,s0,-1
ffffffffc0203c8c:	fd2410e3          	bne	s0,s2,ffffffffc0203c4c <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203c90:	8526                	mv	a0,s1
ffffffffc0203c92:	c37ff0ef          	jal	ra,ffffffffc02038c8 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203c96:	00003517          	auipc	a0,0x3
ffffffffc0203c9a:	5a250513          	addi	a0,a0,1442 # ffffffffc0207238 <default_pmm_manager+0x9c0>
ffffffffc0203c9e:	cf6fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203ca2:	7442                	ld	s0,48(sp)
ffffffffc0203ca4:	70e2                	ld	ra,56(sp)
ffffffffc0203ca6:	74a2                	ld	s1,40(sp)
ffffffffc0203ca8:	7902                	ld	s2,32(sp)
ffffffffc0203caa:	69e2                	ld	s3,24(sp)
ffffffffc0203cac:	6a42                	ld	s4,16(sp)
ffffffffc0203cae:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203cb0:	00003517          	auipc	a0,0x3
ffffffffc0203cb4:	5a850513          	addi	a0,a0,1448 # ffffffffc0207258 <default_pmm_manager+0x9e0>
}
ffffffffc0203cb8:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203cba:	cdafc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203cbe:	00003697          	auipc	a3,0x3
ffffffffc0203cc2:	45268693          	addi	a3,a3,1106 # ffffffffc0207110 <default_pmm_manager+0x898>
ffffffffc0203cc6:	00002617          	auipc	a2,0x2
ffffffffc0203cca:	58a60613          	addi	a2,a2,1418 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203cce:	13f00593          	li	a1,319
ffffffffc0203cd2:	00003517          	auipc	a0,0x3
ffffffffc0203cd6:	34e50513          	addi	a0,a0,846 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203cda:	fb4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203cde:	00003697          	auipc	a3,0x3
ffffffffc0203ce2:	4ba68693          	addi	a3,a3,1210 # ffffffffc0207198 <default_pmm_manager+0x920>
ffffffffc0203ce6:	00002617          	auipc	a2,0x2
ffffffffc0203cea:	56a60613          	addi	a2,a2,1386 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203cee:	15000593          	li	a1,336
ffffffffc0203cf2:	00003517          	auipc	a0,0x3
ffffffffc0203cf6:	32e50513          	addi	a0,a0,814 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203cfa:	f94fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203cfe:	00003697          	auipc	a3,0x3
ffffffffc0203d02:	4ca68693          	addi	a3,a3,1226 # ffffffffc02071c8 <default_pmm_manager+0x950>
ffffffffc0203d06:	00002617          	auipc	a2,0x2
ffffffffc0203d0a:	54a60613          	addi	a2,a2,1354 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203d0e:	15100593          	li	a1,337
ffffffffc0203d12:	00003517          	auipc	a0,0x3
ffffffffc0203d16:	30e50513          	addi	a0,a0,782 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203d1a:	f74fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203d1e:	00003697          	auipc	a3,0x3
ffffffffc0203d22:	3da68693          	addi	a3,a3,986 # ffffffffc02070f8 <default_pmm_manager+0x880>
ffffffffc0203d26:	00002617          	auipc	a2,0x2
ffffffffc0203d2a:	52a60613          	addi	a2,a2,1322 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203d2e:	13d00593          	li	a1,317
ffffffffc0203d32:	00003517          	auipc	a0,0x3
ffffffffc0203d36:	2ee50513          	addi	a0,a0,750 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203d3a:	f54fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203d3e:	00003697          	auipc	a3,0x3
ffffffffc0203d42:	41a68693          	addi	a3,a3,1050 # ffffffffc0207158 <default_pmm_manager+0x8e0>
ffffffffc0203d46:	00002617          	auipc	a2,0x2
ffffffffc0203d4a:	50a60613          	addi	a2,a2,1290 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203d4e:	14800593          	li	a1,328
ffffffffc0203d52:	00003517          	auipc	a0,0x3
ffffffffc0203d56:	2ce50513          	addi	a0,a0,718 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203d5a:	f34fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203d5e:	00003697          	auipc	a3,0x3
ffffffffc0203d62:	3ea68693          	addi	a3,a3,1002 # ffffffffc0207148 <default_pmm_manager+0x8d0>
ffffffffc0203d66:	00002617          	auipc	a2,0x2
ffffffffc0203d6a:	4ea60613          	addi	a2,a2,1258 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203d6e:	14600593          	li	a1,326
ffffffffc0203d72:	00003517          	auipc	a0,0x3
ffffffffc0203d76:	2ae50513          	addi	a0,a0,686 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203d7a:	f14fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203d7e:	00003697          	auipc	a3,0x3
ffffffffc0203d82:	3ea68693          	addi	a3,a3,1002 # ffffffffc0207168 <default_pmm_manager+0x8f0>
ffffffffc0203d86:	00002617          	auipc	a2,0x2
ffffffffc0203d8a:	4ca60613          	addi	a2,a2,1226 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203d8e:	14a00593          	li	a1,330
ffffffffc0203d92:	00003517          	auipc	a0,0x3
ffffffffc0203d96:	28e50513          	addi	a0,a0,654 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203d9a:	ef4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203d9e:	00003697          	auipc	a3,0x3
ffffffffc0203da2:	3ea68693          	addi	a3,a3,1002 # ffffffffc0207188 <default_pmm_manager+0x910>
ffffffffc0203da6:	00002617          	auipc	a2,0x2
ffffffffc0203daa:	4aa60613          	addi	a2,a2,1194 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203dae:	14e00593          	li	a1,334
ffffffffc0203db2:	00003517          	auipc	a0,0x3
ffffffffc0203db6:	26e50513          	addi	a0,a0,622 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203dba:	ed4fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203dbe:	00003697          	auipc	a3,0x3
ffffffffc0203dc2:	3ba68693          	addi	a3,a3,954 # ffffffffc0207178 <default_pmm_manager+0x900>
ffffffffc0203dc6:	00002617          	auipc	a2,0x2
ffffffffc0203dca:	48a60613          	addi	a2,a2,1162 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203dce:	14c00593          	li	a1,332
ffffffffc0203dd2:	00003517          	auipc	a0,0x3
ffffffffc0203dd6:	24e50513          	addi	a0,a0,590 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203dda:	eb4fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203dde:	00003697          	auipc	a3,0x3
ffffffffc0203de2:	2ca68693          	addi	a3,a3,714 # ffffffffc02070a8 <default_pmm_manager+0x830>
ffffffffc0203de6:	00002617          	auipc	a2,0x2
ffffffffc0203dea:	46a60613          	addi	a2,a2,1130 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0203dee:	12600593          	li	a1,294
ffffffffc0203df2:	00003517          	auipc	a0,0x3
ffffffffc0203df6:	22e50513          	addi	a0,a0,558 # ffffffffc0207020 <default_pmm_manager+0x7a8>
ffffffffc0203dfa:	e94fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203dfe <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203dfe:	7179                	addi	sp,sp,-48
ffffffffc0203e00:	f022                	sd	s0,32(sp)
ffffffffc0203e02:	f406                	sd	ra,40(sp)
ffffffffc0203e04:	ec26                	sd	s1,24(sp)
ffffffffc0203e06:	e84a                	sd	s2,16(sp)
ffffffffc0203e08:	e44e                	sd	s3,8(sp)
ffffffffc0203e0a:	e052                	sd	s4,0(sp)
ffffffffc0203e0c:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203e0e:	c135                	beqz	a0,ffffffffc0203e72 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203e10:	002007b7          	lui	a5,0x200
ffffffffc0203e14:	04f5e663          	bltu	a1,a5,ffffffffc0203e60 <user_mem_check+0x62>
ffffffffc0203e18:	00c584b3          	add	s1,a1,a2
ffffffffc0203e1c:	0495f263          	bgeu	a1,s1,ffffffffc0203e60 <user_mem_check+0x62>
ffffffffc0203e20:	4785                	li	a5,1
ffffffffc0203e22:	07fe                	slli	a5,a5,0x1f
ffffffffc0203e24:	0297ee63          	bltu	a5,s1,ffffffffc0203e60 <user_mem_check+0x62>
ffffffffc0203e28:	892a                	mv	s2,a0
ffffffffc0203e2a:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e2c:	6a05                	lui	s4,0x1
ffffffffc0203e2e:	a821                	j	ffffffffc0203e46 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e30:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e34:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e36:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e38:	c685                	beqz	a3,ffffffffc0203e60 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203e3a:	c399                	beqz	a5,ffffffffc0203e40 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203e3c:	02e46263          	bltu	s0,a4,ffffffffc0203e60 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203e40:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203e42:	04947663          	bgeu	s0,s1,ffffffffc0203e8e <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203e46:	85a2                	mv	a1,s0
ffffffffc0203e48:	854a                	mv	a0,s2
ffffffffc0203e4a:	96fff0ef          	jal	ra,ffffffffc02037b8 <find_vma>
ffffffffc0203e4e:	c909                	beqz	a0,ffffffffc0203e60 <user_mem_check+0x62>
ffffffffc0203e50:	6518                	ld	a4,8(a0)
ffffffffc0203e52:	00e46763          	bltu	s0,a4,ffffffffc0203e60 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203e56:	4d1c                	lw	a5,24(a0)
ffffffffc0203e58:	fc099ce3          	bnez	s3,ffffffffc0203e30 <user_mem_check+0x32>
ffffffffc0203e5c:	8b85                	andi	a5,a5,1
ffffffffc0203e5e:	f3ed                	bnez	a5,ffffffffc0203e40 <user_mem_check+0x42>
            return 0;
ffffffffc0203e60:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203e62:	70a2                	ld	ra,40(sp)
ffffffffc0203e64:	7402                	ld	s0,32(sp)
ffffffffc0203e66:	64e2                	ld	s1,24(sp)
ffffffffc0203e68:	6942                	ld	s2,16(sp)
ffffffffc0203e6a:	69a2                	ld	s3,8(sp)
ffffffffc0203e6c:	6a02                	ld	s4,0(sp)
ffffffffc0203e6e:	6145                	addi	sp,sp,48
ffffffffc0203e70:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203e72:	c02007b7          	lui	a5,0xc0200
ffffffffc0203e76:	4501                	li	a0,0
ffffffffc0203e78:	fef5e5e3          	bltu	a1,a5,ffffffffc0203e62 <user_mem_check+0x64>
ffffffffc0203e7c:	962e                	add	a2,a2,a1
ffffffffc0203e7e:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203e62 <user_mem_check+0x64>
ffffffffc0203e82:	c8000537          	lui	a0,0xc8000
ffffffffc0203e86:	0505                	addi	a0,a0,1
ffffffffc0203e88:	00a63533          	sltu	a0,a2,a0
ffffffffc0203e8c:	bfd9                	j	ffffffffc0203e62 <user_mem_check+0x64>
        return 1;
ffffffffc0203e8e:	4505                	li	a0,1
ffffffffc0203e90:	bfc9                	j	ffffffffc0203e62 <user_mem_check+0x64>

ffffffffc0203e92 <do_pgfault>:

int do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr)
{
ffffffffc0203e92:	715d                	addi	sp,sp,-80
ffffffffc0203e94:	fc26                	sd	s1,56(sp)
ffffffffc0203e96:	84ae                	mv	s1,a1
    int ret = -E_INVAL;
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203e98:	85b2                	mv	a1,a2
{
ffffffffc0203e9a:	e0a2                	sd	s0,64(sp)
ffffffffc0203e9c:	f84a                	sd	s2,48(sp)
ffffffffc0203e9e:	e486                	sd	ra,72(sp)
ffffffffc0203ea0:	f44e                	sd	s3,40(sp)
ffffffffc0203ea2:	f052                	sd	s4,32(sp)
ffffffffc0203ea4:	ec56                	sd	s5,24(sp)
ffffffffc0203ea6:	e85a                	sd	s6,16(sp)
ffffffffc0203ea8:	e45e                	sd	s7,8(sp)
ffffffffc0203eaa:	8432                	mv	s0,a2
ffffffffc0203eac:	892a                	mv	s2,a0
    struct vma_struct *vma = find_vma(mm, addr);
ffffffffc0203eae:	90bff0ef          	jal	ra,ffffffffc02037b8 <find_vma>

    pgfault_num++;
ffffffffc0203eb2:	000b1797          	auipc	a5,0xb1
ffffffffc0203eb6:	1767a783          	lw	a5,374(a5) # ffffffffc02b5028 <pgfault_num>
ffffffffc0203eba:	2785                	addiw	a5,a5,1
ffffffffc0203ebc:	000b1717          	auipc	a4,0xb1
ffffffffc0203ec0:	16f72623          	sw	a5,364(a4) # ffffffffc02b5028 <pgfault_num>
    if (vma == NULL || vma->vm_start > addr)
ffffffffc0203ec4:	18050a63          	beqz	a0,ffffffffc0204058 <do_pgfault+0x1c6>
ffffffffc0203ec8:	651c                	ld	a5,8(a0)
ffffffffc0203eca:	18f46763          	bltu	s0,a5,ffffffffc0204058 <do_pgfault+0x1c6>
    {
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
        goto failed;
    }

    switch (error_code & 3)
ffffffffc0203ece:	0034f793          	andi	a5,s1,3
ffffffffc0203ed2:	c7d1                	beqz	a5,ffffffffc0203f5e <do_pgfault+0xcc>
ffffffffc0203ed4:	4705                	li	a4,1
ffffffffc0203ed6:	04e78663          	beq	a5,a4,ffffffffc0203f22 <do_pgfault+0x90>
    {
    default:
    case 2:
        if (!(vma->vm_flags & VM_WRITE))
ffffffffc0203eda:	4d1c                	lw	a5,24(a0)
ffffffffc0203edc:	0027f713          	andi	a4,a5,2
ffffffffc0203ee0:	18070e63          	beqz	a4,ffffffffc020407c <do_pgfault+0x1ea>
            goto failed;
        }
    }

    uint32_t perm = PTE_U;
    if (vma->vm_flags & VM_READ)
ffffffffc0203ee4:	8b85                	andi	a5,a5,1
ffffffffc0203ee6:	49d9                	li	s3,22
ffffffffc0203ee8:	cbd1                	beqz	a5,ffffffffc0203f7c <do_pgfault+0xea>
    }
    if (vma->vm_flags & VM_WRITE)
    {
        perm |= PTE_W;
    }
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203eea:	767d                	lui	a2,0xfffff
    ret = -E_NO_MEM;

    pte_t *ptep = NULL;

    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
ffffffffc0203eec:	01893503          	ld	a0,24(s2)
    addr = ROUNDDOWN(addr, PGSIZE);
ffffffffc0203ef0:	8c71                	and	s0,s0,a2
    if ((ptep = get_pte(mm->pgdir, addr, 1)) == NULL)
ffffffffc0203ef2:	85a2                	mv	a1,s0
ffffffffc0203ef4:	4605                	li	a2,1
ffffffffc0203ef6:	8f6fe0ef          	jal	ra,ffffffffc0201fec <get_pte>
ffffffffc0203efa:	18050a63          	beqz	a0,ffffffffc020408e <do_pgfault+0x1fc>
    {
        cprintf("get_pte in do_pgfault failed\n");
        goto failed;
    }

    if ((*ptep & PTE_V) && (error_code & 2) && !(*ptep & PTE_W))
ffffffffc0203efe:	6110                	ld	a2,0(a0)
ffffffffc0203f00:	00167793          	andi	a5,a2,1
ffffffffc0203f04:	c3b1                	beqz	a5,ffffffffc0203f48 <do_pgfault+0xb6>
ffffffffc0203f06:	8889                	andi	s1,s1,2
ffffffffc0203f08:	c481                	beqz	s1,ffffffffc0203f10 <do_pgfault+0x7e>
ffffffffc0203f0a:	00467793          	andi	a5,a2,4
ffffffffc0203f0e:	cbbd                	beqz	a5,ffffffffc0203f84 <do_pgfault+0xf2>
            goto failed;
        }
    }
    else
    {
        cprintf("do_pgfault error: PTE exists but not COW. addr=%x, *ptep=%x\n", addr, *ptep);
ffffffffc0203f10:	85a2                	mv	a1,s0
ffffffffc0203f12:	00003517          	auipc	a0,0x3
ffffffffc0203f16:	4ce50513          	addi	a0,a0,1230 # ffffffffc02073e0 <default_pmm_manager+0xb68>
ffffffffc0203f1a:	a7afc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0203f1e:	5571                	li	a0,-4
        goto failed;
ffffffffc0203f20:	a809                	j	ffffffffc0203f32 <do_pgfault+0xa0>
        cprintf("do_pgfault failed: read present error, addr=%x\n", addr);
ffffffffc0203f22:	85a2                	mv	a1,s0
ffffffffc0203f24:	00003517          	auipc	a0,0x3
ffffffffc0203f28:	3bc50513          	addi	a0,a0,956 # ffffffffc02072e0 <default_pmm_manager+0xa68>
ffffffffc0203f2c:	a68fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc0203f30:	5575                	li	a0,-3
    }

    ret = 0;
failed:
    return ret;
}
ffffffffc0203f32:	60a6                	ld	ra,72(sp)
ffffffffc0203f34:	6406                	ld	s0,64(sp)
ffffffffc0203f36:	74e2                	ld	s1,56(sp)
ffffffffc0203f38:	7942                	ld	s2,48(sp)
ffffffffc0203f3a:	79a2                	ld	s3,40(sp)
ffffffffc0203f3c:	7a02                	ld	s4,32(sp)
ffffffffc0203f3e:	6ae2                	ld	s5,24(sp)
ffffffffc0203f40:	6b42                	ld	s6,16(sp)
ffffffffc0203f42:	6ba2                	ld	s7,8(sp)
ffffffffc0203f44:	6161                	addi	sp,sp,80
ffffffffc0203f46:	8082                	ret
    if (*ptep == 0)
ffffffffc0203f48:	f661                	bnez	a2,ffffffffc0203f10 <do_pgfault+0x7e>
        if (pgdir_alloc_page(mm->pgdir, addr, perm) == NULL)
ffffffffc0203f4a:	01893503          	ld	a0,24(s2)
ffffffffc0203f4e:	864e                	mv	a2,s3
ffffffffc0203f50:	85a2                	mv	a1,s0
ffffffffc0203f52:	f50ff0ef          	jal	ra,ffffffffc02036a2 <pgdir_alloc_page>
ffffffffc0203f56:	0e050963          	beqz	a0,ffffffffc0204048 <do_pgfault+0x1b6>
        return 0;
ffffffffc0203f5a:	4501                	li	a0,0
ffffffffc0203f5c:	bfd9                	j	ffffffffc0203f32 <do_pgfault+0xa0>
        if (!(vma->vm_flags & (VM_READ | VM_EXEC)))
ffffffffc0203f5e:	4d1c                	lw	a5,24(a0)
ffffffffc0203f60:	0057f713          	andi	a4,a5,5
ffffffffc0203f64:	10070363          	beqz	a4,ffffffffc020406a <do_pgfault+0x1d8>
    if (vma->vm_flags & VM_READ)
ffffffffc0203f68:	0017f713          	andi	a4,a5,1
    uint32_t perm = PTE_U;
ffffffffc0203f6c:	49c1                	li	s3,16
        if (!(vma->vm_flags & VM_WRITE))
ffffffffc0203f6e:	8b89                	andi	a5,a5,2
    if (vma->vm_flags & VM_READ)
ffffffffc0203f70:	c311                	beqz	a4,ffffffffc0203f74 <do_pgfault+0xe2>
        perm |= PTE_R;
ffffffffc0203f72:	49c9                	li	s3,18
    if (vma->vm_flags & VM_WRITE)
ffffffffc0203f74:	dbbd                	beqz	a5,ffffffffc0203eea <do_pgfault+0x58>
        perm |= PTE_W;
ffffffffc0203f76:	0049e993          	ori	s3,s3,4
ffffffffc0203f7a:	bf85                	j	ffffffffc0203eea <do_pgfault+0x58>
    uint32_t perm = PTE_U;
ffffffffc0203f7c:	49c1                	li	s3,16
        perm |= PTE_W;
ffffffffc0203f7e:	0049e993          	ori	s3,s3,4
ffffffffc0203f82:	b7a5                	j	ffffffffc0203eea <do_pgfault+0x58>
    if (PPN(pa) >= npage)
ffffffffc0203f84:	000b1b17          	auipc	s6,0xb1
ffffffffc0203f88:	07cb0b13          	addi	s6,s6,124 # ffffffffc02b5000 <npage>
ffffffffc0203f8c:	000b3783          	ld	a5,0(s6)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203f90:	060a                	slli	a2,a2,0x2
ffffffffc0203f92:	8231                	srli	a2,a2,0xc
    if (PPN(pa) >= npage)
ffffffffc0203f94:	12f67a63          	bgeu	a2,a5,ffffffffc02040c8 <do_pgfault+0x236>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f98:	000b1b97          	auipc	s7,0xb1
ffffffffc0203f9c:	070b8b93          	addi	s7,s7,112 # ffffffffc02b5008 <pages>
ffffffffc0203fa0:	000bb483          	ld	s1,0(s7)
ffffffffc0203fa4:	00004a97          	auipc	s5,0x4
ffffffffc0203fa8:	d74aba83          	ld	s5,-652(s5) # ffffffffc0207d18 <nbase>
ffffffffc0203fac:	41560633          	sub	a2,a2,s5
ffffffffc0203fb0:	061a                	slli	a2,a2,0x6
ffffffffc0203fb2:	94b2                	add	s1,s1,a2
        if (page_ref(page) == 1)
ffffffffc0203fb4:	4098                	lw	a4,0(s1)
ffffffffc0203fb6:	4785                	li	a5,1
ffffffffc0203fb8:	06f70e63          	beq	a4,a5,ffffffffc0204034 <do_pgfault+0x1a2>
        struct Page *npage = alloc_page();
ffffffffc0203fbc:	4505                	li	a0,1
ffffffffc0203fbe:	f77fd0ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc0203fc2:	8a2a                	mv	s4,a0
        if (npage == NULL)
ffffffffc0203fc4:	0c050d63          	beqz	a0,ffffffffc020409e <do_pgfault+0x20c>
    return page - pages + nbase;
ffffffffc0203fc8:	000bb703          	ld	a4,0(s7)
    return KADDR(page2pa(page));
ffffffffc0203fcc:	567d                	li	a2,-1
ffffffffc0203fce:	000b3803          	ld	a6,0(s6)
    return page - pages + nbase;
ffffffffc0203fd2:	40e486b3          	sub	a3,s1,a4
ffffffffc0203fd6:	8699                	srai	a3,a3,0x6
ffffffffc0203fd8:	96d6                	add	a3,a3,s5
    return KADDR(page2pa(page));
ffffffffc0203fda:	8231                	srli	a2,a2,0xc
ffffffffc0203fdc:	00c6f7b3          	and	a5,a3,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0203fe0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203fe2:	0d07f763          	bgeu	a5,a6,ffffffffc02040b0 <do_pgfault+0x21e>
    return page - pages + nbase;
ffffffffc0203fe6:	40e507b3          	sub	a5,a0,a4
ffffffffc0203fea:	8799                	srai	a5,a5,0x6
ffffffffc0203fec:	97d6                	add	a5,a5,s5
    return KADDR(page2pa(page));
ffffffffc0203fee:	000b1517          	auipc	a0,0xb1
ffffffffc0203ff2:	02a53503          	ld	a0,42(a0) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0203ff6:	8e7d                	and	a2,a2,a5
ffffffffc0203ff8:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc0203ffc:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc0203ffe:	0b067863          	bgeu	a2,a6,ffffffffc02040ae <do_pgfault+0x21c>
        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
ffffffffc0204002:	6605                	lui	a2,0x1
ffffffffc0204004:	953e                	add	a0,a0,a5
ffffffffc0204006:	1d1010ef          	jal	ra,ffffffffc02059d6 <memcpy>
        if (page_insert(mm->pgdir, npage, addr, perm | PTE_W) != 0)
ffffffffc020400a:	01893503          	ld	a0,24(s2)
ffffffffc020400e:	0049e693          	ori	a3,s3,4
ffffffffc0204012:	8622                	mv	a2,s0
ffffffffc0204014:	85d2                	mv	a1,s4
ffffffffc0204016:	ec6fe0ef          	jal	ra,ffffffffc02026dc <page_insert>
ffffffffc020401a:	d121                	beqz	a0,ffffffffc0203f5a <do_pgfault+0xc8>
            cprintf("page_insert in do_pgfault failed\n");
ffffffffc020401c:	00003517          	auipc	a0,0x3
ffffffffc0204020:	37450513          	addi	a0,a0,884 # ffffffffc0207390 <default_pmm_manager+0xb18>
ffffffffc0204024:	970fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
            free_page(npage);
ffffffffc0204028:	8552                	mv	a0,s4
ffffffffc020402a:	4585                	li	a1,1
ffffffffc020402c:	f47fd0ef          	jal	ra,ffffffffc0201f72 <free_pages>
    ret = -E_NO_MEM;
ffffffffc0204030:	5571                	li	a0,-4
            goto failed;
ffffffffc0204032:	b701                	j	ffffffffc0203f32 <do_pgfault+0xa0>
            page_insert(mm->pgdir, page, addr, perm | PTE_W);
ffffffffc0204034:	01893503          	ld	a0,24(s2)
ffffffffc0204038:	0049e693          	ori	a3,s3,4
ffffffffc020403c:	8622                	mv	a2,s0
ffffffffc020403e:	85a6                	mv	a1,s1
ffffffffc0204040:	e9cfe0ef          	jal	ra,ffffffffc02026dc <page_insert>
            return 0;
ffffffffc0204044:	4501                	li	a0,0
ffffffffc0204046:	b5f5                	j	ffffffffc0203f32 <do_pgfault+0xa0>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
ffffffffc0204048:	00003517          	auipc	a0,0x3
ffffffffc020404c:	37050513          	addi	a0,a0,880 # ffffffffc02073b8 <default_pmm_manager+0xb40>
ffffffffc0204050:	944fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    ret = -E_NO_MEM;
ffffffffc0204054:	5571                	li	a0,-4
            goto failed;
ffffffffc0204056:	bdf1                	j	ffffffffc0203f32 <do_pgfault+0xa0>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
ffffffffc0204058:	85a2                	mv	a1,s0
ffffffffc020405a:	00003517          	auipc	a0,0x3
ffffffffc020405e:	22650513          	addi	a0,a0,550 # ffffffffc0207280 <default_pmm_manager+0xa08>
ffffffffc0204062:	932fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc0204066:	5575                	li	a0,-3
        goto failed;
ffffffffc0204068:	b5e9                	j	ffffffffc0203f32 <do_pgfault+0xa0>
            cprintf("do_pgfault failed: read no-present error, addr=%x\n", addr);
ffffffffc020406a:	85a2                	mv	a1,s0
ffffffffc020406c:	00003517          	auipc	a0,0x3
ffffffffc0204070:	2a450513          	addi	a0,a0,676 # ffffffffc0207310 <default_pmm_manager+0xa98>
ffffffffc0204074:	920fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc0204078:	5575                	li	a0,-3
            goto failed;
ffffffffc020407a:	bd65                	j	ffffffffc0203f32 <do_pgfault+0xa0>
            cprintf("do_pgfault failed: write error, addr=%x\n", addr);
ffffffffc020407c:	85a2                	mv	a1,s0
ffffffffc020407e:	00003517          	auipc	a0,0x3
ffffffffc0204082:	23250513          	addi	a0,a0,562 # ffffffffc02072b0 <default_pmm_manager+0xa38>
ffffffffc0204086:	90efc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    int ret = -E_INVAL;
ffffffffc020408a:	5575                	li	a0,-3
            goto failed;
ffffffffc020408c:	b55d                	j	ffffffffc0203f32 <do_pgfault+0xa0>
        cprintf("get_pte in do_pgfault failed\n");
ffffffffc020408e:	00003517          	auipc	a0,0x3
ffffffffc0204092:	2ba50513          	addi	a0,a0,698 # ffffffffc0207348 <default_pmm_manager+0xad0>
ffffffffc0204096:	8fefc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    ret = -E_NO_MEM;
ffffffffc020409a:	5571                	li	a0,-4
        goto failed;
ffffffffc020409c:	bd59                	j	ffffffffc0203f32 <do_pgfault+0xa0>
            cprintf("alloc_page in do_pgfault failed\n");
ffffffffc020409e:	00003517          	auipc	a0,0x3
ffffffffc02040a2:	2ca50513          	addi	a0,a0,714 # ffffffffc0207368 <default_pmm_manager+0xaf0>
ffffffffc02040a6:	8eefc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    ret = -E_NO_MEM;
ffffffffc02040aa:	5571                	li	a0,-4
            goto failed;
ffffffffc02040ac:	b559                	j	ffffffffc0203f32 <do_pgfault+0xa0>
ffffffffc02040ae:	86be                	mv	a3,a5
ffffffffc02040b0:	00003617          	auipc	a2,0x3
ffffffffc02040b4:	80060613          	addi	a2,a2,-2048 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc02040b8:	07100593          	li	a1,113
ffffffffc02040bc:	00003517          	auipc	a0,0x3
ffffffffc02040c0:	81c50513          	addi	a0,a0,-2020 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc02040c4:	bcafc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02040c8:	00003617          	auipc	a2,0x3
ffffffffc02040cc:	8b860613          	addi	a2,a2,-1864 # ffffffffc0206980 <default_pmm_manager+0x108>
ffffffffc02040d0:	06900593          	li	a1,105
ffffffffc02040d4:	00003517          	auipc	a0,0x3
ffffffffc02040d8:	80450513          	addi	a0,a0,-2044 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc02040dc:	bb2fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02040e0 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc02040e0:	8526                	mv	a0,s1
	jalr s0
ffffffffc02040e2:	9402                	jalr	s0

	jal do_exit
ffffffffc02040e4:	614000ef          	jal	ra,ffffffffc02046f8 <do_exit>

ffffffffc02040e8 <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc02040e8:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02040ea:	10800513          	li	a0,264
{
ffffffffc02040ee:	e022                	sd	s0,0(sp)
ffffffffc02040f0:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc02040f2:	c65fd0ef          	jal	ra,ffffffffc0201d56 <kmalloc>
ffffffffc02040f6:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc02040f8:	c525                	beqz	a0,ffffffffc0204160 <alloc_proc+0x78>
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->state = PROC_UNINIT;
ffffffffc02040fa:	57fd                	li	a5,-1
ffffffffc02040fc:	1782                	slli	a5,a5,0x20
ffffffffc02040fe:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->need_resched = 0; 

        proc->kstack = 0;
        proc->mm = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0204100:	000b1797          	auipc	a5,0xb1
ffffffffc0204104:	ef07b783          	ld	a5,-272(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
ffffffffc0204108:	f55c                	sd	a5,168(a0)
        proc->parent = NULL;
        proc->flags = 0;
        proc->wait_state = 0;
        proc->exit_code = 0;
        proc->cptr = proc->optr = proc->yptr = NULL;
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc020410a:	4641                	li	a2,16
ffffffffc020410c:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc020410e:	00052423          	sw	zero,8(a0)
        proc->need_resched = 0; 
ffffffffc0204112:	00053c23          	sd	zero,24(a0)
        proc->kstack = 0;
ffffffffc0204116:	00053823          	sd	zero,16(a0)
        proc->mm = NULL;
ffffffffc020411a:	02053423          	sd	zero,40(a0)
        proc->parent = NULL;
ffffffffc020411e:	02053023          	sd	zero,32(a0)
        proc->flags = 0;
ffffffffc0204122:	0a052823          	sw	zero,176(a0)
        proc->exit_code = 0;
ffffffffc0204126:	0e053423          	sd	zero,232(a0)
        proc->cptr = proc->optr = proc->yptr = NULL;
ffffffffc020412a:	0e053823          	sd	zero,240(a0)
ffffffffc020412e:	0e053c23          	sd	zero,248(a0)
ffffffffc0204132:	10053023          	sd	zero,256(a0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204136:	0b450513          	addi	a0,a0,180
ffffffffc020413a:	08b010ef          	jal	ra,ffffffffc02059c4 <memset>

        memset(&proc->context, 0, sizeof(proc->context));
ffffffffc020413e:	07000613          	li	a2,112
ffffffffc0204142:	4581                	li	a1,0
ffffffffc0204144:	03040513          	addi	a0,s0,48
ffffffffc0204148:	07d010ef          	jal	ra,ffffffffc02059c4 <memset>
        proc->tf = NULL;
        list_init(&(proc->list_link));
ffffffffc020414c:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0204150:	0d840793          	addi	a5,s0,216
        proc->tf = NULL;
ffffffffc0204154:	0a043023          	sd	zero,160(s0)
    elm->prev = elm->next = elm;
ffffffffc0204158:	e878                	sd	a4,208(s0)
ffffffffc020415a:	e478                	sd	a4,200(s0)
ffffffffc020415c:	f07c                	sd	a5,224(s0)
ffffffffc020415e:	ec7c                	sd	a5,216(s0)
    }
    return proc;
}
ffffffffc0204160:	60a2                	ld	ra,8(sp)
ffffffffc0204162:	8522                	mv	a0,s0
ffffffffc0204164:	6402                	ld	s0,0(sp)
ffffffffc0204166:	0141                	addi	sp,sp,16
ffffffffc0204168:	8082                	ret

ffffffffc020416a <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc020416a:	000b1797          	auipc	a5,0xb1
ffffffffc020416e:	ec67b783          	ld	a5,-314(a5) # ffffffffc02b5030 <current>
ffffffffc0204172:	73c8                	ld	a0,160(a5)
ffffffffc0204174:	e57fc06f          	j	ffffffffc0200fca <forkrets>

ffffffffc0204178 <user_main>:
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
ffffffffc0204178:	000b1797          	auipc	a5,0xb1
ffffffffc020417c:	eb87b783          	ld	a5,-328(a5) # ffffffffc02b5030 <current>
ffffffffc0204180:	43cc                	lw	a1,4(a5)
{
ffffffffc0204182:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE(exit);
ffffffffc0204184:	00003617          	auipc	a2,0x3
ffffffffc0204188:	29c60613          	addi	a2,a2,668 # ffffffffc0207420 <default_pmm_manager+0xba8>
ffffffffc020418c:	00003517          	auipc	a0,0x3
ffffffffc0204190:	29c50513          	addi	a0,a0,668 # ffffffffc0207428 <default_pmm_manager+0xbb0>
{
ffffffffc0204194:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE(exit);
ffffffffc0204196:	ffffb0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020419a:	3fe07797          	auipc	a5,0x3fe07
ffffffffc020419e:	f8678793          	addi	a5,a5,-122 # b120 <_binary_obj___user_exit_out_size>
ffffffffc02041a2:	e43e                	sd	a5,8(sp)
ffffffffc02041a4:	00003517          	auipc	a0,0x3
ffffffffc02041a8:	27c50513          	addi	a0,a0,636 # ffffffffc0207420 <default_pmm_manager+0xba8>
ffffffffc02041ac:	00031797          	auipc	a5,0x31
ffffffffc02041b0:	c5478793          	addi	a5,a5,-940 # ffffffffc0234e00 <_binary_obj___user_exit_out_start>
ffffffffc02041b4:	f03e                	sd	a5,32(sp)
ffffffffc02041b6:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc02041b8:	e802                	sd	zero,16(sp)
ffffffffc02041ba:	768010ef          	jal	ra,ffffffffc0205922 <strlen>
ffffffffc02041be:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc02041c0:	4511                	li	a0,4
ffffffffc02041c2:	55a2                	lw	a1,40(sp)
ffffffffc02041c4:	4662                	lw	a2,24(sp)
ffffffffc02041c6:	5682                	lw	a3,32(sp)
ffffffffc02041c8:	4722                	lw	a4,8(sp)
ffffffffc02041ca:	48a9                	li	a7,10
ffffffffc02041cc:	9002                	ebreak
ffffffffc02041ce:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc02041d0:	65c2                	ld	a1,16(sp)
ffffffffc02041d2:	00003517          	auipc	a0,0x3
ffffffffc02041d6:	27e50513          	addi	a0,a0,638 # ffffffffc0207450 <default_pmm_manager+0xbd8>
ffffffffc02041da:	fbbfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
    panic("user_main execve failed.\n");
ffffffffc02041de:	00003617          	auipc	a2,0x3
ffffffffc02041e2:	28260613          	addi	a2,a2,642 # ffffffffc0207460 <default_pmm_manager+0xbe8>
ffffffffc02041e6:	3b300593          	li	a1,947
ffffffffc02041ea:	00003517          	auipc	a0,0x3
ffffffffc02041ee:	29650513          	addi	a0,a0,662 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc02041f2:	a9cfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02041f6 <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc02041f6:	6d14                	ld	a3,24(a0)
{
ffffffffc02041f8:	1141                	addi	sp,sp,-16
ffffffffc02041fa:	e406                	sd	ra,8(sp)
ffffffffc02041fc:	c02007b7          	lui	a5,0xc0200
ffffffffc0204200:	02f6ee63          	bltu	a3,a5,ffffffffc020423c <put_pgdir+0x46>
ffffffffc0204204:	000b1517          	auipc	a0,0xb1
ffffffffc0204208:	e1453503          	ld	a0,-492(a0) # ffffffffc02b5018 <va_pa_offset>
ffffffffc020420c:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc020420e:	82b1                	srli	a3,a3,0xc
ffffffffc0204210:	000b1797          	auipc	a5,0xb1
ffffffffc0204214:	df07b783          	ld	a5,-528(a5) # ffffffffc02b5000 <npage>
ffffffffc0204218:	02f6fe63          	bgeu	a3,a5,ffffffffc0204254 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc020421c:	00004517          	auipc	a0,0x4
ffffffffc0204220:	afc53503          	ld	a0,-1284(a0) # ffffffffc0207d18 <nbase>
}
ffffffffc0204224:	60a2                	ld	ra,8(sp)
ffffffffc0204226:	8e89                	sub	a3,a3,a0
ffffffffc0204228:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc020422a:	000b1517          	auipc	a0,0xb1
ffffffffc020422e:	dde53503          	ld	a0,-546(a0) # ffffffffc02b5008 <pages>
ffffffffc0204232:	4585                	li	a1,1
ffffffffc0204234:	9536                	add	a0,a0,a3
}
ffffffffc0204236:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0204238:	d3bfd06f          	j	ffffffffc0201f72 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc020423c:	00002617          	auipc	a2,0x2
ffffffffc0204240:	71c60613          	addi	a2,a2,1820 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc0204244:	07700593          	li	a1,119
ffffffffc0204248:	00002517          	auipc	a0,0x2
ffffffffc020424c:	69050513          	addi	a0,a0,1680 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0204250:	a3efc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204254:	00002617          	auipc	a2,0x2
ffffffffc0204258:	72c60613          	addi	a2,a2,1836 # ffffffffc0206980 <default_pmm_manager+0x108>
ffffffffc020425c:	06900593          	li	a1,105
ffffffffc0204260:	00002517          	auipc	a0,0x2
ffffffffc0204264:	67850513          	addi	a0,a0,1656 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0204268:	a26fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020426c <proc_run>:
{
ffffffffc020426c:	7179                	addi	sp,sp,-48
ffffffffc020426e:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0204270:	000b1917          	auipc	s2,0xb1
ffffffffc0204274:	dc090913          	addi	s2,s2,-576 # ffffffffc02b5030 <current>
{
ffffffffc0204278:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc020427a:	00093483          	ld	s1,0(s2)
{
ffffffffc020427e:	f406                	sd	ra,40(sp)
ffffffffc0204280:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0204282:	02a48863          	beq	s1,a0,ffffffffc02042b2 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204286:	100027f3          	csrr	a5,sstatus
ffffffffc020428a:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020428c:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020428e:	ef9d                	bnez	a5,ffffffffc02042cc <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0204290:	755c                	ld	a5,168(a0)
ffffffffc0204292:	577d                	li	a4,-1
ffffffffc0204294:	177e                	slli	a4,a4,0x3f
ffffffffc0204296:	83b1                	srli	a5,a5,0xc
        current = proc;
ffffffffc0204298:	00a93023          	sd	a0,0(s2)
ffffffffc020429c:	8fd9                	or	a5,a5,a4
ffffffffc020429e:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(current->context));
ffffffffc02042a2:	03050593          	addi	a1,a0,48
ffffffffc02042a6:	03048513          	addi	a0,s1,48
ffffffffc02042aa:	01e010ef          	jal	ra,ffffffffc02052c8 <switch_to>
    if (flag)
ffffffffc02042ae:	00099863          	bnez	s3,ffffffffc02042be <proc_run+0x52>
}
ffffffffc02042b2:	70a2                	ld	ra,40(sp)
ffffffffc02042b4:	7482                	ld	s1,32(sp)
ffffffffc02042b6:	6962                	ld	s2,24(sp)
ffffffffc02042b8:	69c2                	ld	s3,16(sp)
ffffffffc02042ba:	6145                	addi	sp,sp,48
ffffffffc02042bc:	8082                	ret
ffffffffc02042be:	70a2                	ld	ra,40(sp)
ffffffffc02042c0:	7482                	ld	s1,32(sp)
ffffffffc02042c2:	6962                	ld	s2,24(sp)
ffffffffc02042c4:	69c2                	ld	s3,16(sp)
ffffffffc02042c6:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02042c8:	ee6fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc02042cc:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02042ce:	ee6fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02042d2:	6522                	ld	a0,8(sp)
ffffffffc02042d4:	4985                	li	s3,1
ffffffffc02042d6:	bf6d                	j	ffffffffc0204290 <proc_run+0x24>

ffffffffc02042d8 <do_fork>:
{
ffffffffc02042d8:	7119                	addi	sp,sp,-128
ffffffffc02042da:	e8d2                	sd	s4,80(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02042dc:	000b1a17          	auipc	s4,0xb1
ffffffffc02042e0:	d6ca0a13          	addi	s4,s4,-660 # ffffffffc02b5048 <nr_process>
ffffffffc02042e4:	000a2703          	lw	a4,0(s4)
{
ffffffffc02042e8:	fc86                	sd	ra,120(sp)
ffffffffc02042ea:	f8a2                	sd	s0,112(sp)
ffffffffc02042ec:	f4a6                	sd	s1,104(sp)
ffffffffc02042ee:	f0ca                	sd	s2,96(sp)
ffffffffc02042f0:	ecce                	sd	s3,88(sp)
ffffffffc02042f2:	e4d6                	sd	s5,72(sp)
ffffffffc02042f4:	e0da                	sd	s6,64(sp)
ffffffffc02042f6:	fc5e                	sd	s7,56(sp)
ffffffffc02042f8:	f862                	sd	s8,48(sp)
ffffffffc02042fa:	f466                	sd	s9,40(sp)
ffffffffc02042fc:	f06a                	sd	s10,32(sp)
ffffffffc02042fe:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204300:	6785                	lui	a5,0x1
ffffffffc0204302:	32f75263          	bge	a4,a5,ffffffffc0204626 <do_fork+0x34e>
ffffffffc0204306:	892a                	mv	s2,a0
ffffffffc0204308:	89ae                	mv	s3,a1
ffffffffc020430a:	84b2                	mv	s1,a2
    if ((proc = alloc_proc()) == NULL)
ffffffffc020430c:	dddff0ef          	jal	ra,ffffffffc02040e8 <alloc_proc>
ffffffffc0204310:	842a                	mv	s0,a0
ffffffffc0204312:	2e050763          	beqz	a0,ffffffffc0204600 <do_fork+0x328>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0204316:	4509                	li	a0,2
ffffffffc0204318:	c1dfd0ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
    if (page != NULL)
ffffffffc020431c:	2c050f63          	beqz	a0,ffffffffc02045fa <do_fork+0x322>
    return page - pages + nbase;
ffffffffc0204320:	000b1a97          	auipc	s5,0xb1
ffffffffc0204324:	ce8a8a93          	addi	s5,s5,-792 # ffffffffc02b5008 <pages>
ffffffffc0204328:	000ab683          	ld	a3,0(s5)
ffffffffc020432c:	00004797          	auipc	a5,0x4
ffffffffc0204330:	9ec78793          	addi	a5,a5,-1556 # ffffffffc0207d18 <nbase>
ffffffffc0204334:	6390                	ld	a2,0(a5)
ffffffffc0204336:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc020433a:	000b1b97          	auipc	s7,0xb1
ffffffffc020433e:	cc6b8b93          	addi	s7,s7,-826 # ffffffffc02b5000 <npage>
    return page - pages + nbase;
ffffffffc0204342:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204344:	57fd                	li	a5,-1
ffffffffc0204346:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020434a:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc020434c:	00c7db13          	srli	s6,a5,0xc
ffffffffc0204350:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0204354:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204356:	32e5fd63          	bgeu	a1,a4,ffffffffc0204690 <do_fork+0x3b8>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc020435a:	000b1c17          	auipc	s8,0xb1
ffffffffc020435e:	cd6c0c13          	addi	s8,s8,-810 # ffffffffc02b5030 <current>
ffffffffc0204362:	000c3583          	ld	a1,0(s8)
ffffffffc0204366:	000b1c97          	auipc	s9,0xb1
ffffffffc020436a:	cb2c8c93          	addi	s9,s9,-846 # ffffffffc02b5018 <va_pa_offset>
ffffffffc020436e:	000cb703          	ld	a4,0(s9)
ffffffffc0204372:	0285bd83          	ld	s11,40(a1)
ffffffffc0204376:	e432                	sd	a2,8(sp)
ffffffffc0204378:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020437a:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc020437c:	020d8763          	beqz	s11,ffffffffc02043aa <do_fork+0xd2>
    if (clone_flags & CLONE_VM)
ffffffffc0204380:	10097913          	andi	s2,s2,256
ffffffffc0204384:	1a090a63          	beqz	s2,ffffffffc0204538 <do_fork+0x260>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc0204388:	030da783          	lw	a5,48(s11)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020438c:	018db683          	ld	a3,24(s11)
ffffffffc0204390:	c0200737          	lui	a4,0xc0200
ffffffffc0204394:	2785                	addiw	a5,a5,1
ffffffffc0204396:	02fda823          	sw	a5,48(s11)
    proc->mm = mm;
ffffffffc020439a:	03b43423          	sd	s11,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc020439e:	2ce6e163          	bltu	a3,a4,ffffffffc0204660 <do_fork+0x388>
ffffffffc02043a2:	000cb783          	ld	a5,0(s9)
ffffffffc02043a6:	8e9d                	sub	a3,a3,a5
ffffffffc02043a8:	f454                	sd	a3,168(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043aa:	100027f3          	csrr	a5,sstatus
ffffffffc02043ae:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02043b0:	4a81                	li	s5,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02043b2:	26079163          	bnez	a5,ffffffffc0204614 <do_fork+0x33c>
    if (++last_pid >= MAX_PID)
ffffffffc02043b6:	000ac817          	auipc	a6,0xac
ffffffffc02043ba:	7da80813          	addi	a6,a6,2010 # ffffffffc02b0b90 <last_pid.1>
    proc->parent = current;
ffffffffc02043be:	000c3703          	ld	a4,0(s8)
    if (++last_pid >= MAX_PID)
ffffffffc02043c2:	00082783          	lw	a5,0(a6)
ffffffffc02043c6:	6689                	lui	a3,0x2
    proc->parent = current;
ffffffffc02043c8:	f018                	sd	a4,32(s0)
    if (++last_pid >= MAX_PID)
ffffffffc02043ca:	0017851b          	addiw	a0,a5,1
    current->wait_state = 0;
ffffffffc02043ce:	0e072623          	sw	zero,236(a4) # ffffffffc02000ec <readline+0x46>
    if (++last_pid >= MAX_PID)
ffffffffc02043d2:	00a82023          	sw	a0,0(a6)
ffffffffc02043d6:	0ed55863          	bge	a0,a3,ffffffffc02044c6 <do_fork+0x1ee>
    if (last_pid >= next_safe)
ffffffffc02043da:	000ac317          	auipc	t1,0xac
ffffffffc02043de:	7ba30313          	addi	t1,t1,1978 # ffffffffc02b0b94 <next_safe.0>
ffffffffc02043e2:	00032783          	lw	a5,0(t1)
ffffffffc02043e6:	000b1917          	auipc	s2,0xb1
ffffffffc02043ea:	bca90913          	addi	s2,s2,-1078 # ffffffffc02b4fb0 <proc_list>
ffffffffc02043ee:	0ef55463          	bge	a0,a5,ffffffffc02044d6 <do_fork+0x1fe>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02043f2:	6818                	ld	a4,16(s0)
ffffffffc02043f4:	6789                	lui	a5,0x2
ffffffffc02043f6:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc8>
ffffffffc02043fa:	973e                	add	a4,a4,a5
    *(proc->tf) = *tf;
ffffffffc02043fc:	8626                	mv	a2,s1
    proc->pid = get_pid();
ffffffffc02043fe:	c048                	sw	a0,4(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204400:	f058                	sd	a4,160(s0)
    *(proc->tf) = *tf;
ffffffffc0204402:	87ba                	mv	a5,a4
ffffffffc0204404:	12048313          	addi	t1,s1,288
ffffffffc0204408:	00063883          	ld	a7,0(a2)
ffffffffc020440c:	00863803          	ld	a6,8(a2)
ffffffffc0204410:	6a0c                	ld	a1,16(a2)
ffffffffc0204412:	6e14                	ld	a3,24(a2)
ffffffffc0204414:	0117b023          	sd	a7,0(a5)
ffffffffc0204418:	0107b423          	sd	a6,8(a5)
ffffffffc020441c:	eb8c                	sd	a1,16(a5)
ffffffffc020441e:	ef94                	sd	a3,24(a5)
ffffffffc0204420:	02060613          	addi	a2,a2,32
ffffffffc0204424:	02078793          	addi	a5,a5,32
ffffffffc0204428:	fe6610e3          	bne	a2,t1,ffffffffc0204408 <do_fork+0x130>
    proc->tf->gpr.a0 = 0;
ffffffffc020442c:	04073823          	sd	zero,80(a4)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204430:	10098263          	beqz	s3,ffffffffc0204534 <do_fork+0x25c>
ffffffffc0204434:	01373823          	sd	s3,16(a4)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204438:	00000797          	auipc	a5,0x0
ffffffffc020443c:	d3278793          	addi	a5,a5,-718 # ffffffffc020416a <forkret>
ffffffffc0204440:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204442:	fc18                	sd	a4,56(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204444:	45a9                	li	a1,10
ffffffffc0204446:	2501                	sext.w	a0,a0
ffffffffc0204448:	0d6010ef          	jal	ra,ffffffffc020551e <hash32>
ffffffffc020444c:	02051793          	slli	a5,a0,0x20
ffffffffc0204450:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204454:	000ad797          	auipc	a5,0xad
ffffffffc0204458:	b5c78793          	addi	a5,a5,-1188 # ffffffffc02b0fb0 <hash_list>
ffffffffc020445c:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc020445e:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204460:	7014                	ld	a3,32(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204462:	0d840793          	addi	a5,s0,216
    prev->next = next->prev = elm;
ffffffffc0204466:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc0204468:	00893603          	ld	a2,8(s2)
    prev->next = next->prev = elm;
ffffffffc020446c:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020446e:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204470:	0c840793          	addi	a5,s0,200
    elm->next = next;
ffffffffc0204474:	f06c                	sd	a1,224(s0)
    elm->prev = prev;
ffffffffc0204476:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc0204478:	e21c                	sd	a5,0(a2)
ffffffffc020447a:	00f93423          	sd	a5,8(s2)
    elm->next = next;
ffffffffc020447e:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc0204480:	0d243423          	sd	s2,200(s0)
    proc->yptr = NULL;
ffffffffc0204484:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204488:	10e43023          	sd	a4,256(s0)
ffffffffc020448c:	c311                	beqz	a4,ffffffffc0204490 <do_fork+0x1b8>
        proc->optr->yptr = proc;
ffffffffc020448e:	ff60                	sd	s0,248(a4)
    nr_process++;
ffffffffc0204490:	000a2783          	lw	a5,0(s4)
    proc->parent->cptr = proc;
ffffffffc0204494:	fae0                	sd	s0,240(a3)
    wakeup_proc(proc);
ffffffffc0204496:	8522                	mv	a0,s0
    nr_process++;
ffffffffc0204498:	2785                	addiw	a5,a5,1
ffffffffc020449a:	00fa2023          	sw	a5,0(s4)
    wakeup_proc(proc);
ffffffffc020449e:	695000ef          	jal	ra,ffffffffc0205332 <wakeup_proc>
    if (flag)
ffffffffc02044a2:	160a9163          	bnez	s5,ffffffffc0204604 <do_fork+0x32c>
    ret = proc->pid;
ffffffffc02044a6:	4048                	lw	a0,4(s0)
}
ffffffffc02044a8:	70e6                	ld	ra,120(sp)
ffffffffc02044aa:	7446                	ld	s0,112(sp)
ffffffffc02044ac:	74a6                	ld	s1,104(sp)
ffffffffc02044ae:	7906                	ld	s2,96(sp)
ffffffffc02044b0:	69e6                	ld	s3,88(sp)
ffffffffc02044b2:	6a46                	ld	s4,80(sp)
ffffffffc02044b4:	6aa6                	ld	s5,72(sp)
ffffffffc02044b6:	6b06                	ld	s6,64(sp)
ffffffffc02044b8:	7be2                	ld	s7,56(sp)
ffffffffc02044ba:	7c42                	ld	s8,48(sp)
ffffffffc02044bc:	7ca2                	ld	s9,40(sp)
ffffffffc02044be:	7d02                	ld	s10,32(sp)
ffffffffc02044c0:	6de2                	ld	s11,24(sp)
ffffffffc02044c2:	6109                	addi	sp,sp,128
ffffffffc02044c4:	8082                	ret
        last_pid = 1;
ffffffffc02044c6:	4785                	li	a5,1
ffffffffc02044c8:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02044cc:	4505                	li	a0,1
ffffffffc02044ce:	000ac317          	auipc	t1,0xac
ffffffffc02044d2:	6c630313          	addi	t1,t1,1734 # ffffffffc02b0b94 <next_safe.0>
    return listelm->next;
ffffffffc02044d6:	000b1917          	auipc	s2,0xb1
ffffffffc02044da:	ada90913          	addi	s2,s2,-1318 # ffffffffc02b4fb0 <proc_list>
ffffffffc02044de:	00893e03          	ld	t3,8(s2)
        next_safe = MAX_PID;
ffffffffc02044e2:	6789                	lui	a5,0x2
ffffffffc02044e4:	00f32023          	sw	a5,0(t1)
ffffffffc02044e8:	86aa                	mv	a3,a0
ffffffffc02044ea:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02044ec:	6e89                	lui	t4,0x2
ffffffffc02044ee:	132e0763          	beq	t3,s2,ffffffffc020461c <do_fork+0x344>
ffffffffc02044f2:	88ae                	mv	a7,a1
ffffffffc02044f4:	87f2                	mv	a5,t3
ffffffffc02044f6:	6609                	lui	a2,0x2
ffffffffc02044f8:	a811                	j	ffffffffc020450c <do_fork+0x234>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02044fa:	00e6d663          	bge	a3,a4,ffffffffc0204506 <do_fork+0x22e>
ffffffffc02044fe:	00c75463          	bge	a4,a2,ffffffffc0204506 <do_fork+0x22e>
ffffffffc0204502:	863a                	mv	a2,a4
ffffffffc0204504:	4885                	li	a7,1
ffffffffc0204506:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204508:	01278d63          	beq	a5,s2,ffffffffc0204522 <do_fork+0x24a>
            if (proc->pid == last_pid)
ffffffffc020450c:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c6c>
ffffffffc0204510:	fed715e3          	bne	a4,a3,ffffffffc02044fa <do_fork+0x222>
                if (++last_pid >= next_safe)
ffffffffc0204514:	2685                	addiw	a3,a3,1
ffffffffc0204516:	0ec6da63          	bge	a3,a2,ffffffffc020460a <do_fork+0x332>
ffffffffc020451a:	679c                	ld	a5,8(a5)
ffffffffc020451c:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020451e:	ff2797e3          	bne	a5,s2,ffffffffc020450c <do_fork+0x234>
ffffffffc0204522:	c581                	beqz	a1,ffffffffc020452a <do_fork+0x252>
ffffffffc0204524:	00d82023          	sw	a3,0(a6)
ffffffffc0204528:	8536                	mv	a0,a3
ffffffffc020452a:	ec0884e3          	beqz	a7,ffffffffc02043f2 <do_fork+0x11a>
ffffffffc020452e:	00c32023          	sw	a2,0(t1)
ffffffffc0204532:	b5c1                	j	ffffffffc02043f2 <do_fork+0x11a>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204534:	89ba                	mv	s3,a4
ffffffffc0204536:	bdfd                	j	ffffffffc0204434 <do_fork+0x15c>
    if ((mm = mm_create()) == NULL)
ffffffffc0204538:	a50ff0ef          	jal	ra,ffffffffc0203788 <mm_create>
ffffffffc020453c:	8d2a                	mv	s10,a0
ffffffffc020453e:	c159                	beqz	a0,ffffffffc02045c4 <do_fork+0x2ec>
    if ((page = alloc_page()) == NULL)
ffffffffc0204540:	4505                	li	a0,1
ffffffffc0204542:	9f3fd0ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc0204546:	cd25                	beqz	a0,ffffffffc02045be <do_fork+0x2e6>
    return page - pages + nbase;
ffffffffc0204548:	000ab683          	ld	a3,0(s5)
ffffffffc020454c:	6622                	ld	a2,8(sp)
    return KADDR(page2pa(page));
ffffffffc020454e:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204552:	40d506b3          	sub	a3,a0,a3
ffffffffc0204556:	8699                	srai	a3,a3,0x6
ffffffffc0204558:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc020455a:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020455e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204560:	12e7f863          	bgeu	a5,a4,ffffffffc0204690 <do_fork+0x3b8>
ffffffffc0204564:	000cb903          	ld	s2,0(s9)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204568:	6605                	lui	a2,0x1
ffffffffc020456a:	000b1597          	auipc	a1,0xb1
ffffffffc020456e:	a8e5b583          	ld	a1,-1394(a1) # ffffffffc02b4ff8 <boot_pgdir_va>
ffffffffc0204572:	9936                	add	s2,s2,a3
ffffffffc0204574:	854a                	mv	a0,s2
ffffffffc0204576:	460010ef          	jal	ra,ffffffffc02059d6 <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc020457a:	038d8b13          	addi	s6,s11,56
    mm->pgdir = pgdir;
ffffffffc020457e:	012d3c23          	sd	s2,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204582:	4785                	li	a5,1
ffffffffc0204584:	40fb37af          	amoor.d	a5,a5,(s6)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc0204588:	8b85                	andi	a5,a5,1
ffffffffc020458a:	4905                	li	s2,1
ffffffffc020458c:	c799                	beqz	a5,ffffffffc020459a <do_fork+0x2c2>
    {
        schedule();
ffffffffc020458e:	625000ef          	jal	ra,ffffffffc02053b2 <schedule>
ffffffffc0204592:	412b37af          	amoor.d	a5,s2,(s6)
    while (!try_lock(lock))
ffffffffc0204596:	8b85                	andi	a5,a5,1
ffffffffc0204598:	fbfd                	bnez	a5,ffffffffc020458e <do_fork+0x2b6>
        ret = dup_mmap(mm, oldmm);
ffffffffc020459a:	85ee                	mv	a1,s11
ffffffffc020459c:	856a                	mv	a0,s10
ffffffffc020459e:	c2cff0ef          	jal	ra,ffffffffc02039ca <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02045a2:	57f9                	li	a5,-2
ffffffffc02045a4:	60fb37af          	amoand.d	a5,a5,(s6)
ffffffffc02045a8:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02045aa:	c3d9                	beqz	a5,ffffffffc0204630 <do_fork+0x358>
good_mm:
ffffffffc02045ac:	8dea                	mv	s11,s10
    if (ret != 0)
ffffffffc02045ae:	dc050de3          	beqz	a0,ffffffffc0204388 <do_fork+0xb0>
    exit_mmap(mm);
ffffffffc02045b2:	856a                	mv	a0,s10
ffffffffc02045b4:	cb0ff0ef          	jal	ra,ffffffffc0203a64 <exit_mmap>
    put_pgdir(mm);
ffffffffc02045b8:	856a                	mv	a0,s10
ffffffffc02045ba:	c3dff0ef          	jal	ra,ffffffffc02041f6 <put_pgdir>
    mm_destroy(mm);
ffffffffc02045be:	856a                	mv	a0,s10
ffffffffc02045c0:	b08ff0ef          	jal	ra,ffffffffc02038c8 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02045c4:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02045c6:	c02007b7          	lui	a5,0xc0200
ffffffffc02045ca:	0af6e763          	bltu	a3,a5,ffffffffc0204678 <do_fork+0x3a0>
ffffffffc02045ce:	000cb783          	ld	a5,0(s9)
    if (PPN(pa) >= npage)
ffffffffc02045d2:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02045d6:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02045da:	83b1                	srli	a5,a5,0xc
ffffffffc02045dc:	06e7f663          	bgeu	a5,a4,ffffffffc0204648 <do_fork+0x370>
    return &pages[PPN(pa) - nbase];
ffffffffc02045e0:	00003717          	auipc	a4,0x3
ffffffffc02045e4:	73870713          	addi	a4,a4,1848 # ffffffffc0207d18 <nbase>
ffffffffc02045e8:	6318                	ld	a4,0(a4)
ffffffffc02045ea:	000ab503          	ld	a0,0(s5)
ffffffffc02045ee:	4589                	li	a1,2
ffffffffc02045f0:	8f99                	sub	a5,a5,a4
ffffffffc02045f2:	079a                	slli	a5,a5,0x6
ffffffffc02045f4:	953e                	add	a0,a0,a5
ffffffffc02045f6:	97dfd0ef          	jal	ra,ffffffffc0201f72 <free_pages>
    kfree(proc);
ffffffffc02045fa:	8522                	mv	a0,s0
ffffffffc02045fc:	80bfd0ef          	jal	ra,ffffffffc0201e06 <kfree>
    ret = -E_NO_MEM;
ffffffffc0204600:	5571                	li	a0,-4
    return ret;
ffffffffc0204602:	b55d                	j	ffffffffc02044a8 <do_fork+0x1d0>
        intr_enable();
ffffffffc0204604:	baafc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204608:	bd79                	j	ffffffffc02044a6 <do_fork+0x1ce>
                    if (last_pid >= MAX_PID)
ffffffffc020460a:	01d6c363          	blt	a3,t4,ffffffffc0204610 <do_fork+0x338>
                        last_pid = 1;
ffffffffc020460e:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204610:	4585                	li	a1,1
ffffffffc0204612:	bdf1                	j	ffffffffc02044ee <do_fork+0x216>
        intr_disable();
ffffffffc0204614:	ba0fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204618:	4a85                	li	s5,1
ffffffffc020461a:	bb71                	j	ffffffffc02043b6 <do_fork+0xde>
ffffffffc020461c:	c599                	beqz	a1,ffffffffc020462a <do_fork+0x352>
ffffffffc020461e:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204622:	8536                	mv	a0,a3
ffffffffc0204624:	b3f9                	j	ffffffffc02043f2 <do_fork+0x11a>
    int ret = -E_NO_FREE_PROC;
ffffffffc0204626:	556d                	li	a0,-5
ffffffffc0204628:	b541                	j	ffffffffc02044a8 <do_fork+0x1d0>
    return last_pid;
ffffffffc020462a:	00082503          	lw	a0,0(a6)
ffffffffc020462e:	b3d1                	j	ffffffffc02043f2 <do_fork+0x11a>
    {
        panic("Unlock failed.\n");
ffffffffc0204630:	00003617          	auipc	a2,0x3
ffffffffc0204634:	e6860613          	addi	a2,a2,-408 # ffffffffc0207498 <default_pmm_manager+0xc20>
ffffffffc0204638:	03f00593          	li	a1,63
ffffffffc020463c:	00003517          	auipc	a0,0x3
ffffffffc0204640:	e6c50513          	addi	a0,a0,-404 # ffffffffc02074a8 <default_pmm_manager+0xc30>
ffffffffc0204644:	e4bfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204648:	00002617          	auipc	a2,0x2
ffffffffc020464c:	33860613          	addi	a2,a2,824 # ffffffffc0206980 <default_pmm_manager+0x108>
ffffffffc0204650:	06900593          	li	a1,105
ffffffffc0204654:	00002517          	auipc	a0,0x2
ffffffffc0204658:	28450513          	addi	a0,a0,644 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc020465c:	e33fb0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204660:	00002617          	auipc	a2,0x2
ffffffffc0204664:	2f860613          	addi	a2,a2,760 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc0204668:	18e00593          	li	a1,398
ffffffffc020466c:	00003517          	auipc	a0,0x3
ffffffffc0204670:	e1450513          	addi	a0,a0,-492 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204674:	e1bfb0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0204678:	00002617          	auipc	a2,0x2
ffffffffc020467c:	2e060613          	addi	a2,a2,736 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc0204680:	07700593          	li	a1,119
ffffffffc0204684:	00002517          	auipc	a0,0x2
ffffffffc0204688:	25450513          	addi	a0,a0,596 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc020468c:	e03fb0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204690:	00002617          	auipc	a2,0x2
ffffffffc0204694:	22060613          	addi	a2,a2,544 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc0204698:	07100593          	li	a1,113
ffffffffc020469c:	00002517          	auipc	a0,0x2
ffffffffc02046a0:	23c50513          	addi	a0,a0,572 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc02046a4:	debfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02046a8 <kernel_thread>:
{
ffffffffc02046a8:	7129                	addi	sp,sp,-320
ffffffffc02046aa:	fa22                	sd	s0,304(sp)
ffffffffc02046ac:	f626                	sd	s1,296(sp)
ffffffffc02046ae:	f24a                	sd	s2,288(sp)
ffffffffc02046b0:	84ae                	mv	s1,a1
ffffffffc02046b2:	892a                	mv	s2,a0
ffffffffc02046b4:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046b6:	4581                	li	a1,0
ffffffffc02046b8:	12000613          	li	a2,288
ffffffffc02046bc:	850a                	mv	a0,sp
{
ffffffffc02046be:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02046c0:	304010ef          	jal	ra,ffffffffc02059c4 <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02046c4:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02046c6:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02046c8:	100027f3          	csrr	a5,sstatus
ffffffffc02046cc:	edd7f793          	andi	a5,a5,-291
ffffffffc02046d0:	1207e793          	ori	a5,a5,288
ffffffffc02046d4:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046d6:	860a                	mv	a2,sp
ffffffffc02046d8:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046dc:	00000797          	auipc	a5,0x0
ffffffffc02046e0:	a0478793          	addi	a5,a5,-1532 # ffffffffc02040e0 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046e4:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02046e6:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02046e8:	bf1ff0ef          	jal	ra,ffffffffc02042d8 <do_fork>
}
ffffffffc02046ec:	70f2                	ld	ra,312(sp)
ffffffffc02046ee:	7452                	ld	s0,304(sp)
ffffffffc02046f0:	74b2                	ld	s1,296(sp)
ffffffffc02046f2:	7912                	ld	s2,288(sp)
ffffffffc02046f4:	6131                	addi	sp,sp,320
ffffffffc02046f6:	8082                	ret

ffffffffc02046f8 <do_exit>:
{
ffffffffc02046f8:	7179                	addi	sp,sp,-48
ffffffffc02046fa:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc02046fc:	000b1417          	auipc	s0,0xb1
ffffffffc0204700:	93440413          	addi	s0,s0,-1740 # ffffffffc02b5030 <current>
ffffffffc0204704:	601c                	ld	a5,0(s0)
{
ffffffffc0204706:	f406                	sd	ra,40(sp)
ffffffffc0204708:	ec26                	sd	s1,24(sp)
ffffffffc020470a:	e84a                	sd	s2,16(sp)
ffffffffc020470c:	e44e                	sd	s3,8(sp)
ffffffffc020470e:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204710:	000b1717          	auipc	a4,0xb1
ffffffffc0204714:	92873703          	ld	a4,-1752(a4) # ffffffffc02b5038 <idleproc>
ffffffffc0204718:	0ce78c63          	beq	a5,a4,ffffffffc02047f0 <do_exit+0xf8>
    if (current == initproc)
ffffffffc020471c:	000b1497          	auipc	s1,0xb1
ffffffffc0204720:	92448493          	addi	s1,s1,-1756 # ffffffffc02b5040 <initproc>
ffffffffc0204724:	6098                	ld	a4,0(s1)
ffffffffc0204726:	0ee78b63          	beq	a5,a4,ffffffffc020481c <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc020472a:	0287b983          	ld	s3,40(a5)
ffffffffc020472e:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204730:	02098663          	beqz	s3,ffffffffc020475c <do_exit+0x64>
ffffffffc0204734:	000b1797          	auipc	a5,0xb1
ffffffffc0204738:	8bc7b783          	ld	a5,-1860(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
ffffffffc020473c:	577d                	li	a4,-1
ffffffffc020473e:	177e                	slli	a4,a4,0x3f
ffffffffc0204740:	83b1                	srli	a5,a5,0xc
ffffffffc0204742:	8fd9                	or	a5,a5,a4
ffffffffc0204744:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204748:	0309a783          	lw	a5,48(s3)
ffffffffc020474c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204750:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204754:	cb55                	beqz	a4,ffffffffc0204808 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204756:	601c                	ld	a5,0(s0)
ffffffffc0204758:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc020475c:	601c                	ld	a5,0(s0)
ffffffffc020475e:	470d                	li	a4,3
ffffffffc0204760:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204762:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204766:	100027f3          	csrr	a5,sstatus
ffffffffc020476a:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020476c:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020476e:	e3f9                	bnez	a5,ffffffffc0204834 <do_exit+0x13c>
        proc = current->parent;
ffffffffc0204770:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204772:	800007b7          	lui	a5,0x80000
ffffffffc0204776:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204778:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc020477a:	0ec52703          	lw	a4,236(a0)
ffffffffc020477e:	0af70f63          	beq	a4,a5,ffffffffc020483c <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc0204782:	6018                	ld	a4,0(s0)
ffffffffc0204784:	7b7c                	ld	a5,240(a4)
ffffffffc0204786:	c3a1                	beqz	a5,ffffffffc02047c6 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204788:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc020478c:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc020478e:	0985                	addi	s3,s3,1
ffffffffc0204790:	a021                	j	ffffffffc0204798 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc0204792:	6018                	ld	a4,0(s0)
ffffffffc0204794:	7b7c                	ld	a5,240(a4)
ffffffffc0204796:	cb85                	beqz	a5,ffffffffc02047c6 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc0204798:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fe0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc020479c:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc020479e:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02047a0:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02047a2:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02047a6:	10e7b023          	sd	a4,256(a5)
ffffffffc02047aa:	c311                	beqz	a4,ffffffffc02047ae <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02047ac:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047ae:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02047b0:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02047b2:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02047b4:	fd271fe3          	bne	a4,s2,ffffffffc0204792 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02047b8:	0ec52783          	lw	a5,236(a0)
ffffffffc02047bc:	fd379be3          	bne	a5,s3,ffffffffc0204792 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02047c0:	373000ef          	jal	ra,ffffffffc0205332 <wakeup_proc>
ffffffffc02047c4:	b7f9                	j	ffffffffc0204792 <do_exit+0x9a>
    if (flag)
ffffffffc02047c6:	020a1263          	bnez	s4,ffffffffc02047ea <do_exit+0xf2>
    schedule();
ffffffffc02047ca:	3e9000ef          	jal	ra,ffffffffc02053b2 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02047ce:	601c                	ld	a5,0(s0)
ffffffffc02047d0:	00003617          	auipc	a2,0x3
ffffffffc02047d4:	d1060613          	addi	a2,a2,-752 # ffffffffc02074e0 <default_pmm_manager+0xc68>
ffffffffc02047d8:	23700593          	li	a1,567
ffffffffc02047dc:	43d4                	lw	a3,4(a5)
ffffffffc02047de:	00003517          	auipc	a0,0x3
ffffffffc02047e2:	ca250513          	addi	a0,a0,-862 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc02047e6:	ca9fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc02047ea:	9c4fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02047ee:	bff1                	j	ffffffffc02047ca <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02047f0:	00003617          	auipc	a2,0x3
ffffffffc02047f4:	cd060613          	addi	a2,a2,-816 # ffffffffc02074c0 <default_pmm_manager+0xc48>
ffffffffc02047f8:	20300593          	li	a1,515
ffffffffc02047fc:	00003517          	auipc	a0,0x3
ffffffffc0204800:	c8450513          	addi	a0,a0,-892 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204804:	c8bfb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc0204808:	854e                	mv	a0,s3
ffffffffc020480a:	a5aff0ef          	jal	ra,ffffffffc0203a64 <exit_mmap>
            put_pgdir(mm);
ffffffffc020480e:	854e                	mv	a0,s3
ffffffffc0204810:	9e7ff0ef          	jal	ra,ffffffffc02041f6 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204814:	854e                	mv	a0,s3
ffffffffc0204816:	8b2ff0ef          	jal	ra,ffffffffc02038c8 <mm_destroy>
ffffffffc020481a:	bf35                	j	ffffffffc0204756 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc020481c:	00003617          	auipc	a2,0x3
ffffffffc0204820:	cb460613          	addi	a2,a2,-844 # ffffffffc02074d0 <default_pmm_manager+0xc58>
ffffffffc0204824:	20700593          	li	a1,519
ffffffffc0204828:	00003517          	auipc	a0,0x3
ffffffffc020482c:	c5850513          	addi	a0,a0,-936 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204830:	c5ffb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc0204834:	980fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0204838:	4a05                	li	s4,1
ffffffffc020483a:	bf1d                	j	ffffffffc0204770 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc020483c:	2f7000ef          	jal	ra,ffffffffc0205332 <wakeup_proc>
ffffffffc0204840:	b789                	j	ffffffffc0204782 <do_exit+0x8a>

ffffffffc0204842 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204842:	715d                	addi	sp,sp,-80
ffffffffc0204844:	f84a                	sd	s2,48(sp)
ffffffffc0204846:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204848:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc020484c:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc020484e:	fc26                	sd	s1,56(sp)
ffffffffc0204850:	f052                	sd	s4,32(sp)
ffffffffc0204852:	ec56                	sd	s5,24(sp)
ffffffffc0204854:	e85a                	sd	s6,16(sp)
ffffffffc0204856:	e45e                	sd	s7,8(sp)
ffffffffc0204858:	e486                	sd	ra,72(sp)
ffffffffc020485a:	e0a2                	sd	s0,64(sp)
ffffffffc020485c:	84aa                	mv	s1,a0
ffffffffc020485e:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0204860:	000b0b97          	auipc	s7,0xb0
ffffffffc0204864:	7d0b8b93          	addi	s7,s7,2000 # ffffffffc02b5030 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204868:	00050b1b          	sext.w	s6,a0
ffffffffc020486c:	fff50a9b          	addiw	s5,a0,-1
ffffffffc0204870:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204872:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc0204874:	ccbd                	beqz	s1,ffffffffc02048f2 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204876:	0359e863          	bltu	s3,s5,ffffffffc02048a6 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc020487a:	45a9                	li	a1,10
ffffffffc020487c:	855a                	mv	a0,s6
ffffffffc020487e:	4a1000ef          	jal	ra,ffffffffc020551e <hash32>
ffffffffc0204882:	02051793          	slli	a5,a0,0x20
ffffffffc0204886:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020488a:	000ac797          	auipc	a5,0xac
ffffffffc020488e:	72678793          	addi	a5,a5,1830 # ffffffffc02b0fb0 <hash_list>
ffffffffc0204892:	953e                	add	a0,a0,a5
ffffffffc0204894:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc0204896:	a029                	j	ffffffffc02048a0 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc0204898:	f2c42783          	lw	a5,-212(s0)
ffffffffc020489c:	02978163          	beq	a5,s1,ffffffffc02048be <do_wait.part.0+0x7c>
ffffffffc02048a0:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02048a2:	fe851be3          	bne	a0,s0,ffffffffc0204898 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02048a6:	5579                	li	a0,-2
}
ffffffffc02048a8:	60a6                	ld	ra,72(sp)
ffffffffc02048aa:	6406                	ld	s0,64(sp)
ffffffffc02048ac:	74e2                	ld	s1,56(sp)
ffffffffc02048ae:	7942                	ld	s2,48(sp)
ffffffffc02048b0:	79a2                	ld	s3,40(sp)
ffffffffc02048b2:	7a02                	ld	s4,32(sp)
ffffffffc02048b4:	6ae2                	ld	s5,24(sp)
ffffffffc02048b6:	6b42                	ld	s6,16(sp)
ffffffffc02048b8:	6ba2                	ld	s7,8(sp)
ffffffffc02048ba:	6161                	addi	sp,sp,80
ffffffffc02048bc:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02048be:	000bb683          	ld	a3,0(s7)
ffffffffc02048c2:	f4843783          	ld	a5,-184(s0)
ffffffffc02048c6:	fed790e3          	bne	a5,a3,ffffffffc02048a6 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02048ca:	f2842703          	lw	a4,-216(s0)
ffffffffc02048ce:	478d                	li	a5,3
ffffffffc02048d0:	0ef70b63          	beq	a4,a5,ffffffffc02049c6 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02048d4:	4785                	li	a5,1
ffffffffc02048d6:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02048d8:	0f26a623          	sw	s2,236(a3) # 20ec <_binary_obj___user_faultread_out_size-0x7abc>
        schedule();
ffffffffc02048dc:	2d7000ef          	jal	ra,ffffffffc02053b2 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02048e0:	000bb783          	ld	a5,0(s7)
ffffffffc02048e4:	0b07a783          	lw	a5,176(a5)
ffffffffc02048e8:	8b85                	andi	a5,a5,1
ffffffffc02048ea:	d7c9                	beqz	a5,ffffffffc0204874 <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc02048ec:	555d                	li	a0,-9
ffffffffc02048ee:	e0bff0ef          	jal	ra,ffffffffc02046f8 <do_exit>
        proc = current->cptr;
ffffffffc02048f2:	000bb683          	ld	a3,0(s7)
ffffffffc02048f6:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc02048f8:	d45d                	beqz	s0,ffffffffc02048a6 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02048fa:	470d                	li	a4,3
ffffffffc02048fc:	a021                	j	ffffffffc0204904 <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc02048fe:	10043403          	ld	s0,256(s0)
ffffffffc0204902:	d869                	beqz	s0,ffffffffc02048d4 <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204904:	401c                	lw	a5,0(s0)
ffffffffc0204906:	fee79ce3          	bne	a5,a4,ffffffffc02048fe <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc020490a:	000b0797          	auipc	a5,0xb0
ffffffffc020490e:	72e7b783          	ld	a5,1838(a5) # ffffffffc02b5038 <idleproc>
ffffffffc0204912:	0c878963          	beq	a5,s0,ffffffffc02049e4 <do_wait.part.0+0x1a2>
ffffffffc0204916:	000b0797          	auipc	a5,0xb0
ffffffffc020491a:	72a7b783          	ld	a5,1834(a5) # ffffffffc02b5040 <initproc>
ffffffffc020491e:	0cf40363          	beq	s0,a5,ffffffffc02049e4 <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204922:	000a0663          	beqz	s4,ffffffffc020492e <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204926:	0e842783          	lw	a5,232(s0)
ffffffffc020492a:	00fa2023          	sw	a5,0(s4)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020492e:	100027f3          	csrr	a5,sstatus
ffffffffc0204932:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204934:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204936:	e7c1                	bnez	a5,ffffffffc02049be <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204938:	6c70                	ld	a2,216(s0)
ffffffffc020493a:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc020493c:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204940:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204942:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204944:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204946:	6470                	ld	a2,200(s0)
ffffffffc0204948:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc020494a:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020494c:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc020494e:	c319                	beqz	a4,ffffffffc0204954 <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204950:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204952:	7c7c                	ld	a5,248(s0)
ffffffffc0204954:	c3b5                	beqz	a5,ffffffffc02049b8 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204956:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc020495a:	000b0717          	auipc	a4,0xb0
ffffffffc020495e:	6ee70713          	addi	a4,a4,1774 # ffffffffc02b5048 <nr_process>
ffffffffc0204962:	431c                	lw	a5,0(a4)
ffffffffc0204964:	37fd                	addiw	a5,a5,-1
ffffffffc0204966:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204968:	e5a9                	bnez	a1,ffffffffc02049b2 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc020496a:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc020496c:	c02007b7          	lui	a5,0xc0200
ffffffffc0204970:	04f6ee63          	bltu	a3,a5,ffffffffc02049cc <do_wait.part.0+0x18a>
ffffffffc0204974:	000b0797          	auipc	a5,0xb0
ffffffffc0204978:	6a47b783          	ld	a5,1700(a5) # ffffffffc02b5018 <va_pa_offset>
ffffffffc020497c:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc020497e:	82b1                	srli	a3,a3,0xc
ffffffffc0204980:	000b0797          	auipc	a5,0xb0
ffffffffc0204984:	6807b783          	ld	a5,1664(a5) # ffffffffc02b5000 <npage>
ffffffffc0204988:	06f6fa63          	bgeu	a3,a5,ffffffffc02049fc <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc020498c:	00003517          	auipc	a0,0x3
ffffffffc0204990:	38c53503          	ld	a0,908(a0) # ffffffffc0207d18 <nbase>
ffffffffc0204994:	8e89                	sub	a3,a3,a0
ffffffffc0204996:	069a                	slli	a3,a3,0x6
ffffffffc0204998:	000b0517          	auipc	a0,0xb0
ffffffffc020499c:	67053503          	ld	a0,1648(a0) # ffffffffc02b5008 <pages>
ffffffffc02049a0:	9536                	add	a0,a0,a3
ffffffffc02049a2:	4589                	li	a1,2
ffffffffc02049a4:	dcefd0ef          	jal	ra,ffffffffc0201f72 <free_pages>
    kfree(proc);
ffffffffc02049a8:	8522                	mv	a0,s0
ffffffffc02049aa:	c5cfd0ef          	jal	ra,ffffffffc0201e06 <kfree>
    return 0;
ffffffffc02049ae:	4501                	li	a0,0
ffffffffc02049b0:	bde5                	j	ffffffffc02048a8 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02049b2:	ffdfb0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02049b6:	bf55                	j	ffffffffc020496a <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02049b8:	701c                	ld	a5,32(s0)
ffffffffc02049ba:	fbf8                	sd	a4,240(a5)
ffffffffc02049bc:	bf79                	j	ffffffffc020495a <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02049be:	ff7fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02049c2:	4585                	li	a1,1
ffffffffc02049c4:	bf95                	j	ffffffffc0204938 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02049c6:	f2840413          	addi	s0,s0,-216
ffffffffc02049ca:	b781                	j	ffffffffc020490a <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02049cc:	00002617          	auipc	a2,0x2
ffffffffc02049d0:	f8c60613          	addi	a2,a2,-116 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc02049d4:	07700593          	li	a1,119
ffffffffc02049d8:	00002517          	auipc	a0,0x2
ffffffffc02049dc:	f0050513          	addi	a0,a0,-256 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc02049e0:	aaffb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02049e4:	00003617          	auipc	a2,0x3
ffffffffc02049e8:	b1c60613          	addi	a2,a2,-1252 # ffffffffc0207500 <default_pmm_manager+0xc88>
ffffffffc02049ec:	35b00593          	li	a1,859
ffffffffc02049f0:	00003517          	auipc	a0,0x3
ffffffffc02049f4:	a9050513          	addi	a0,a0,-1392 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc02049f8:	a97fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02049fc:	00002617          	auipc	a2,0x2
ffffffffc0204a00:	f8460613          	addi	a2,a2,-124 # ffffffffc0206980 <default_pmm_manager+0x108>
ffffffffc0204a04:	06900593          	li	a1,105
ffffffffc0204a08:	00002517          	auipc	a0,0x2
ffffffffc0204a0c:	ed050513          	addi	a0,a0,-304 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0204a10:	a7ffb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204a14 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc0204a14:	1141                	addi	sp,sp,-16
ffffffffc0204a16:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204a18:	d9afd0ef          	jal	ra,ffffffffc0201fb2 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204a1c:	b36fd0ef          	jal	ra,ffffffffc0201d52 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204a20:	4601                	li	a2,0
ffffffffc0204a22:	4581                	li	a1,0
ffffffffc0204a24:	fffff517          	auipc	a0,0xfffff
ffffffffc0204a28:	75450513          	addi	a0,a0,1876 # ffffffffc0204178 <user_main>
ffffffffc0204a2c:	c7dff0ef          	jal	ra,ffffffffc02046a8 <kernel_thread>
    if (pid <= 0)
ffffffffc0204a30:	00a04563          	bgtz	a0,ffffffffc0204a3a <init_main+0x26>
ffffffffc0204a34:	a071                	j	ffffffffc0204ac0 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204a36:	17d000ef          	jal	ra,ffffffffc02053b2 <schedule>
    if (code_store != NULL)
ffffffffc0204a3a:	4581                	li	a1,0
ffffffffc0204a3c:	4501                	li	a0,0
ffffffffc0204a3e:	e05ff0ef          	jal	ra,ffffffffc0204842 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204a42:	d975                	beqz	a0,ffffffffc0204a36 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc0204a44:	00003517          	auipc	a0,0x3
ffffffffc0204a48:	afc50513          	addi	a0,a0,-1284 # ffffffffc0207540 <default_pmm_manager+0xcc8>
ffffffffc0204a4c:	f48fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204a50:	000b0797          	auipc	a5,0xb0
ffffffffc0204a54:	5f07b783          	ld	a5,1520(a5) # ffffffffc02b5040 <initproc>
ffffffffc0204a58:	7bf8                	ld	a4,240(a5)
ffffffffc0204a5a:	e339                	bnez	a4,ffffffffc0204aa0 <init_main+0x8c>
ffffffffc0204a5c:	7ff8                	ld	a4,248(a5)
ffffffffc0204a5e:	e329                	bnez	a4,ffffffffc0204aa0 <init_main+0x8c>
ffffffffc0204a60:	1007b703          	ld	a4,256(a5)
ffffffffc0204a64:	ef15                	bnez	a4,ffffffffc0204aa0 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204a66:	000b0697          	auipc	a3,0xb0
ffffffffc0204a6a:	5e26a683          	lw	a3,1506(a3) # ffffffffc02b5048 <nr_process>
ffffffffc0204a6e:	4709                	li	a4,2
ffffffffc0204a70:	0ae69463          	bne	a3,a4,ffffffffc0204b18 <init_main+0x104>
    return listelm->next;
ffffffffc0204a74:	000b0697          	auipc	a3,0xb0
ffffffffc0204a78:	53c68693          	addi	a3,a3,1340 # ffffffffc02b4fb0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204a7c:	6698                	ld	a4,8(a3)
ffffffffc0204a7e:	0c878793          	addi	a5,a5,200
ffffffffc0204a82:	06f71b63          	bne	a4,a5,ffffffffc0204af8 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204a86:	629c                	ld	a5,0(a3)
ffffffffc0204a88:	04f71863          	bne	a4,a5,ffffffffc0204ad8 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204a8c:	00003517          	auipc	a0,0x3
ffffffffc0204a90:	b9c50513          	addi	a0,a0,-1124 # ffffffffc0207628 <default_pmm_manager+0xdb0>
ffffffffc0204a94:	f00fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc0204a98:	60a2                	ld	ra,8(sp)
ffffffffc0204a9a:	4501                	li	a0,0
ffffffffc0204a9c:	0141                	addi	sp,sp,16
ffffffffc0204a9e:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204aa0:	00003697          	auipc	a3,0x3
ffffffffc0204aa4:	ac868693          	addi	a3,a3,-1336 # ffffffffc0207568 <default_pmm_manager+0xcf0>
ffffffffc0204aa8:	00001617          	auipc	a2,0x1
ffffffffc0204aac:	7a860613          	addi	a2,a2,1960 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0204ab0:	3c900593          	li	a1,969
ffffffffc0204ab4:	00003517          	auipc	a0,0x3
ffffffffc0204ab8:	9cc50513          	addi	a0,a0,-1588 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204abc:	9d3fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc0204ac0:	00003617          	auipc	a2,0x3
ffffffffc0204ac4:	a6060613          	addi	a2,a2,-1440 # ffffffffc0207520 <default_pmm_manager+0xca8>
ffffffffc0204ac8:	3c000593          	li	a1,960
ffffffffc0204acc:	00003517          	auipc	a0,0x3
ffffffffc0204ad0:	9b450513          	addi	a0,a0,-1612 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204ad4:	9bbfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204ad8:	00003697          	auipc	a3,0x3
ffffffffc0204adc:	b2068693          	addi	a3,a3,-1248 # ffffffffc02075f8 <default_pmm_manager+0xd80>
ffffffffc0204ae0:	00001617          	auipc	a2,0x1
ffffffffc0204ae4:	77060613          	addi	a2,a2,1904 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0204ae8:	3cc00593          	li	a1,972
ffffffffc0204aec:	00003517          	auipc	a0,0x3
ffffffffc0204af0:	99450513          	addi	a0,a0,-1644 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204af4:	99bfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204af8:	00003697          	auipc	a3,0x3
ffffffffc0204afc:	ad068693          	addi	a3,a3,-1328 # ffffffffc02075c8 <default_pmm_manager+0xd50>
ffffffffc0204b00:	00001617          	auipc	a2,0x1
ffffffffc0204b04:	75060613          	addi	a2,a2,1872 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0204b08:	3cb00593          	li	a1,971
ffffffffc0204b0c:	00003517          	auipc	a0,0x3
ffffffffc0204b10:	97450513          	addi	a0,a0,-1676 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204b14:	97bfb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc0204b18:	00003697          	auipc	a3,0x3
ffffffffc0204b1c:	aa068693          	addi	a3,a3,-1376 # ffffffffc02075b8 <default_pmm_manager+0xd40>
ffffffffc0204b20:	00001617          	auipc	a2,0x1
ffffffffc0204b24:	73060613          	addi	a2,a2,1840 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0204b28:	3ca00593          	li	a1,970
ffffffffc0204b2c:	00003517          	auipc	a0,0x3
ffffffffc0204b30:	95450513          	addi	a0,a0,-1708 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204b34:	95bfb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204b38 <do_execve>:
{
ffffffffc0204b38:	7171                	addi	sp,sp,-176
ffffffffc0204b3a:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b3c:	000b0d97          	auipc	s11,0xb0
ffffffffc0204b40:	4f4d8d93          	addi	s11,s11,1268 # ffffffffc02b5030 <current>
ffffffffc0204b44:	000db783          	ld	a5,0(s11)
{
ffffffffc0204b48:	e54e                	sd	s3,136(sp)
ffffffffc0204b4a:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204b4c:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204b50:	e94a                	sd	s2,144(sp)
ffffffffc0204b52:	f4de                	sd	s7,104(sp)
ffffffffc0204b54:	892a                	mv	s2,a0
ffffffffc0204b56:	8bb2                	mv	s7,a2
ffffffffc0204b58:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b5a:	862e                	mv	a2,a1
ffffffffc0204b5c:	4681                	li	a3,0
ffffffffc0204b5e:	85aa                	mv	a1,a0
ffffffffc0204b60:	854e                	mv	a0,s3
{
ffffffffc0204b62:	f506                	sd	ra,168(sp)
ffffffffc0204b64:	f122                	sd	s0,160(sp)
ffffffffc0204b66:	e152                	sd	s4,128(sp)
ffffffffc0204b68:	fcd6                	sd	s5,120(sp)
ffffffffc0204b6a:	f8da                	sd	s6,112(sp)
ffffffffc0204b6c:	f0e2                	sd	s8,96(sp)
ffffffffc0204b6e:	ece6                	sd	s9,88(sp)
ffffffffc0204b70:	e8ea                	sd	s10,80(sp)
ffffffffc0204b72:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204b74:	a8aff0ef          	jal	ra,ffffffffc0203dfe <user_mem_check>
ffffffffc0204b78:	40050a63          	beqz	a0,ffffffffc0204f8c <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204b7c:	4641                	li	a2,16
ffffffffc0204b7e:	4581                	li	a1,0
ffffffffc0204b80:	1808                	addi	a0,sp,48
ffffffffc0204b82:	643000ef          	jal	ra,ffffffffc02059c4 <memset>
    memcpy(local_name, name, len);
ffffffffc0204b86:	47bd                	li	a5,15
ffffffffc0204b88:	8626                	mv	a2,s1
ffffffffc0204b8a:	1e97e263          	bltu	a5,s1,ffffffffc0204d6e <do_execve+0x236>
ffffffffc0204b8e:	85ca                	mv	a1,s2
ffffffffc0204b90:	1808                	addi	a0,sp,48
ffffffffc0204b92:	645000ef          	jal	ra,ffffffffc02059d6 <memcpy>
    if (mm != NULL)
ffffffffc0204b96:	1e098363          	beqz	s3,ffffffffc0204d7c <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc0204b9a:	00002517          	auipc	a0,0x2
ffffffffc0204b9e:	50e50513          	addi	a0,a0,1294 # ffffffffc02070a8 <default_pmm_manager+0x830>
ffffffffc0204ba2:	e2afb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc0204ba6:	000b0797          	auipc	a5,0xb0
ffffffffc0204baa:	44a7b783          	ld	a5,1098(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
ffffffffc0204bae:	577d                	li	a4,-1
ffffffffc0204bb0:	177e                	slli	a4,a4,0x3f
ffffffffc0204bb2:	83b1                	srli	a5,a5,0xc
ffffffffc0204bb4:	8fd9                	or	a5,a5,a4
ffffffffc0204bb6:	18079073          	csrw	satp,a5
ffffffffc0204bba:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b78>
ffffffffc0204bbe:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204bc2:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc0204bc6:	2c070463          	beqz	a4,ffffffffc0204e8e <do_execve+0x356>
        current->mm = NULL;
ffffffffc0204bca:	000db783          	ld	a5,0(s11)
ffffffffc0204bce:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc0204bd2:	bb7fe0ef          	jal	ra,ffffffffc0203788 <mm_create>
ffffffffc0204bd6:	84aa                	mv	s1,a0
ffffffffc0204bd8:	1c050d63          	beqz	a0,ffffffffc0204db2 <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc0204bdc:	4505                	li	a0,1
ffffffffc0204bde:	b56fd0ef          	jal	ra,ffffffffc0201f34 <alloc_pages>
ffffffffc0204be2:	3a050963          	beqz	a0,ffffffffc0204f94 <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc0204be6:	000b0c97          	auipc	s9,0xb0
ffffffffc0204bea:	422c8c93          	addi	s9,s9,1058 # ffffffffc02b5008 <pages>
ffffffffc0204bee:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204bf2:	000b0c17          	auipc	s8,0xb0
ffffffffc0204bf6:	40ec0c13          	addi	s8,s8,1038 # ffffffffc02b5000 <npage>
    return page - pages + nbase;
ffffffffc0204bfa:	00003717          	auipc	a4,0x3
ffffffffc0204bfe:	11e73703          	ld	a4,286(a4) # ffffffffc0207d18 <nbase>
ffffffffc0204c02:	40d506b3          	sub	a3,a0,a3
ffffffffc0204c06:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204c08:	5afd                	li	s5,-1
ffffffffc0204c0a:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204c0e:	96ba                	add	a3,a3,a4
ffffffffc0204c10:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c12:	00cad713          	srli	a4,s5,0xc
ffffffffc0204c16:	ec3a                	sd	a4,24(sp)
ffffffffc0204c18:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c1a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c1c:	38f77063          	bgeu	a4,a5,ffffffffc0204f9c <do_execve+0x464>
ffffffffc0204c20:	000b0b17          	auipc	s6,0xb0
ffffffffc0204c24:	3f8b0b13          	addi	s6,s6,1016 # ffffffffc02b5018 <va_pa_offset>
ffffffffc0204c28:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204c2c:	6605                	lui	a2,0x1
ffffffffc0204c2e:	000b0597          	auipc	a1,0xb0
ffffffffc0204c32:	3ca5b583          	ld	a1,970(a1) # ffffffffc02b4ff8 <boot_pgdir_va>
ffffffffc0204c36:	9936                	add	s2,s2,a3
ffffffffc0204c38:	854a                	mv	a0,s2
ffffffffc0204c3a:	59d000ef          	jal	ra,ffffffffc02059d6 <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c3e:	7782                	ld	a5,32(sp)
ffffffffc0204c40:	4398                	lw	a4,0(a5)
ffffffffc0204c42:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204c46:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204c4a:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b945f>
ffffffffc0204c4e:	14f71863          	bne	a4,a5,ffffffffc0204d9e <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c52:	7682                	ld	a3,32(sp)
ffffffffc0204c54:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c58:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c5c:	00371793          	slli	a5,a4,0x3
ffffffffc0204c60:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204c62:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204c64:	078e                	slli	a5,a5,0x3
ffffffffc0204c66:	97ce                	add	a5,a5,s3
ffffffffc0204c68:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204c6a:	00f9fc63          	bgeu	s3,a5,ffffffffc0204c82 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204c6e:	0009a783          	lw	a5,0(s3)
ffffffffc0204c72:	4705                	li	a4,1
ffffffffc0204c74:	14e78163          	beq	a5,a4,ffffffffc0204db6 <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc0204c78:	77a2                	ld	a5,40(sp)
ffffffffc0204c7a:	03898993          	addi	s3,s3,56
ffffffffc0204c7e:	fef9e8e3          	bltu	s3,a5,ffffffffc0204c6e <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204c82:	4701                	li	a4,0
ffffffffc0204c84:	46ad                	li	a3,11
ffffffffc0204c86:	00100637          	lui	a2,0x100
ffffffffc0204c8a:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204c8e:	8526                	mv	a0,s1
ffffffffc0204c90:	c8bfe0ef          	jal	ra,ffffffffc020391a <mm_map>
ffffffffc0204c94:	8a2a                	mv	s4,a0
ffffffffc0204c96:	1e051263          	bnez	a0,ffffffffc0204e7a <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204c9a:	6c88                	ld	a0,24(s1)
ffffffffc0204c9c:	467d                	li	a2,31
ffffffffc0204c9e:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0204ca2:	a01fe0ef          	jal	ra,ffffffffc02036a2 <pgdir_alloc_page>
ffffffffc0204ca6:	38050363          	beqz	a0,ffffffffc020502c <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204caa:	6c88                	ld	a0,24(s1)
ffffffffc0204cac:	467d                	li	a2,31
ffffffffc0204cae:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0204cb2:	9f1fe0ef          	jal	ra,ffffffffc02036a2 <pgdir_alloc_page>
ffffffffc0204cb6:	34050b63          	beqz	a0,ffffffffc020500c <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cba:	6c88                	ld	a0,24(s1)
ffffffffc0204cbc:	467d                	li	a2,31
ffffffffc0204cbe:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0204cc2:	9e1fe0ef          	jal	ra,ffffffffc02036a2 <pgdir_alloc_page>
ffffffffc0204cc6:	32050363          	beqz	a0,ffffffffc0204fec <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cca:	6c88                	ld	a0,24(s1)
ffffffffc0204ccc:	467d                	li	a2,31
ffffffffc0204cce:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0204cd2:	9d1fe0ef          	jal	ra,ffffffffc02036a2 <pgdir_alloc_page>
ffffffffc0204cd6:	2e050b63          	beqz	a0,ffffffffc0204fcc <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc0204cda:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc0204cdc:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204ce0:	6c94                	ld	a3,24(s1)
ffffffffc0204ce2:	2785                	addiw	a5,a5,1
ffffffffc0204ce4:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc0204ce6:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204ce8:	c02007b7          	lui	a5,0xc0200
ffffffffc0204cec:	2cf6e463          	bltu	a3,a5,ffffffffc0204fb4 <do_execve+0x47c>
ffffffffc0204cf0:	000b3783          	ld	a5,0(s6)
ffffffffc0204cf4:	577d                	li	a4,-1
ffffffffc0204cf6:	177e                	slli	a4,a4,0x3f
ffffffffc0204cf8:	8e9d                	sub	a3,a3,a5
ffffffffc0204cfa:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204cfe:	f654                	sd	a3,168(a2)
ffffffffc0204d00:	8fd9                	or	a5,a5,a4
ffffffffc0204d02:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204d06:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d08:	4581                	li	a1,0
ffffffffc0204d0a:	12000613          	li	a2,288
ffffffffc0204d0e:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204d10:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204d14:	4b1000ef          	jal	ra,ffffffffc02059c4 <memset>
    tf->epc = elf->e_entry;
ffffffffc0204d18:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d1a:	000db903          	ld	s2,0(s11)
    tf->status &= ~SSTATUS_SPP;
ffffffffc0204d1e:	eff4f493          	andi	s1,s1,-257
    tf->epc = elf->e_entry;
ffffffffc0204d22:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d24:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d26:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f94>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d2a:	07fe                	slli	a5,a5,0x1f
    tf->status |= SSTATUS_SPIE;
ffffffffc0204d2c:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d30:	4641                	li	a2,16
ffffffffc0204d32:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204d34:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204d36:	10e43423          	sd	a4,264(s0)
    tf->status |= SSTATUS_SPIE;
ffffffffc0204d3a:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204d3e:	854a                	mv	a0,s2
ffffffffc0204d40:	485000ef          	jal	ra,ffffffffc02059c4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204d44:	463d                	li	a2,15
ffffffffc0204d46:	180c                	addi	a1,sp,48
ffffffffc0204d48:	854a                	mv	a0,s2
ffffffffc0204d4a:	48d000ef          	jal	ra,ffffffffc02059d6 <memcpy>
}
ffffffffc0204d4e:	70aa                	ld	ra,168(sp)
ffffffffc0204d50:	740a                	ld	s0,160(sp)
ffffffffc0204d52:	64ea                	ld	s1,152(sp)
ffffffffc0204d54:	694a                	ld	s2,144(sp)
ffffffffc0204d56:	69aa                	ld	s3,136(sp)
ffffffffc0204d58:	7ae6                	ld	s5,120(sp)
ffffffffc0204d5a:	7b46                	ld	s6,112(sp)
ffffffffc0204d5c:	7ba6                	ld	s7,104(sp)
ffffffffc0204d5e:	7c06                	ld	s8,96(sp)
ffffffffc0204d60:	6ce6                	ld	s9,88(sp)
ffffffffc0204d62:	6d46                	ld	s10,80(sp)
ffffffffc0204d64:	6da6                	ld	s11,72(sp)
ffffffffc0204d66:	8552                	mv	a0,s4
ffffffffc0204d68:	6a0a                	ld	s4,128(sp)
ffffffffc0204d6a:	614d                	addi	sp,sp,176
ffffffffc0204d6c:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204d6e:	463d                	li	a2,15
ffffffffc0204d70:	85ca                	mv	a1,s2
ffffffffc0204d72:	1808                	addi	a0,sp,48
ffffffffc0204d74:	463000ef          	jal	ra,ffffffffc02059d6 <memcpy>
    if (mm != NULL)
ffffffffc0204d78:	e20991e3          	bnez	s3,ffffffffc0204b9a <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204d7c:	000db783          	ld	a5,0(s11)
ffffffffc0204d80:	779c                	ld	a5,40(a5)
ffffffffc0204d82:	e40788e3          	beqz	a5,ffffffffc0204bd2 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204d86:	00003617          	auipc	a2,0x3
ffffffffc0204d8a:	8c260613          	addi	a2,a2,-1854 # ffffffffc0207648 <default_pmm_manager+0xdd0>
ffffffffc0204d8e:	24300593          	li	a1,579
ffffffffc0204d92:	00002517          	auipc	a0,0x2
ffffffffc0204d96:	6ee50513          	addi	a0,a0,1774 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204d9a:	ef4fb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204d9e:	8526                	mv	a0,s1
ffffffffc0204da0:	c56ff0ef          	jal	ra,ffffffffc02041f6 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204da4:	8526                	mv	a0,s1
ffffffffc0204da6:	b23fe0ef          	jal	ra,ffffffffc02038c8 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204daa:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204dac:	8552                	mv	a0,s4
ffffffffc0204dae:	94bff0ef          	jal	ra,ffffffffc02046f8 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204db2:	5a71                	li	s4,-4
ffffffffc0204db4:	bfe5                	j	ffffffffc0204dac <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204db6:	0289b603          	ld	a2,40(s3)
ffffffffc0204dba:	0209b783          	ld	a5,32(s3)
ffffffffc0204dbe:	1cf66d63          	bltu	a2,a5,ffffffffc0204f98 <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204dc2:	0049a783          	lw	a5,4(s3)
ffffffffc0204dc6:	0017f693          	andi	a3,a5,1
ffffffffc0204dca:	c291                	beqz	a3,ffffffffc0204dce <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204dcc:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204dce:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204dd2:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204dd4:	e779                	bnez	a4,ffffffffc0204ea2 <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204dd6:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204dd8:	c781                	beqz	a5,ffffffffc0204de0 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204dda:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204dde:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204de0:	0026f793          	andi	a5,a3,2
ffffffffc0204de4:	e3f1                	bnez	a5,ffffffffc0204ea8 <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204de6:	0046f793          	andi	a5,a3,4
ffffffffc0204dea:	c399                	beqz	a5,ffffffffc0204df0 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204dec:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204df0:	0109b583          	ld	a1,16(s3)
ffffffffc0204df4:	4701                	li	a4,0
ffffffffc0204df6:	8526                	mv	a0,s1
ffffffffc0204df8:	b23fe0ef          	jal	ra,ffffffffc020391a <mm_map>
ffffffffc0204dfc:	8a2a                	mv	s4,a0
ffffffffc0204dfe:	ed35                	bnez	a0,ffffffffc0204e7a <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e00:	0109bb83          	ld	s7,16(s3)
ffffffffc0204e04:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204e06:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e0a:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204e0e:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e12:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204e14:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204e16:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204e18:	054be963          	bltu	s7,s4,ffffffffc0204e6a <do_execve+0x332>
ffffffffc0204e1c:	aa95                	j	ffffffffc0204f90 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204e1e:	6785                	lui	a5,0x1
ffffffffc0204e20:	415b8533          	sub	a0,s7,s5
ffffffffc0204e24:	9abe                	add	s5,s5,a5
ffffffffc0204e26:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204e2a:	015a7463          	bgeu	s4,s5,ffffffffc0204e32 <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204e2e:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204e32:	000cb683          	ld	a3,0(s9)
ffffffffc0204e36:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204e38:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204e3c:	40d406b3          	sub	a3,s0,a3
ffffffffc0204e40:	8699                	srai	a3,a3,0x6
ffffffffc0204e42:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204e44:	67e2                	ld	a5,24(sp)
ffffffffc0204e46:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204e4a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204e4c:	14b87863          	bgeu	a6,a1,ffffffffc0204f9c <do_execve+0x464>
ffffffffc0204e50:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e54:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204e56:	9bb2                	add	s7,s7,a2
ffffffffc0204e58:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e5a:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204e5c:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204e5e:	379000ef          	jal	ra,ffffffffc02059d6 <memcpy>
            start += size, from += size;
ffffffffc0204e62:	6622                	ld	a2,8(sp)
ffffffffc0204e64:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204e66:	054bf363          	bgeu	s7,s4,ffffffffc0204eac <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204e6a:	6c88                	ld	a0,24(s1)
ffffffffc0204e6c:	866a                	mv	a2,s10
ffffffffc0204e6e:	85d6                	mv	a1,s5
ffffffffc0204e70:	833fe0ef          	jal	ra,ffffffffc02036a2 <pgdir_alloc_page>
ffffffffc0204e74:	842a                	mv	s0,a0
ffffffffc0204e76:	f545                	bnez	a0,ffffffffc0204e1e <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204e78:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204e7a:	8526                	mv	a0,s1
ffffffffc0204e7c:	be9fe0ef          	jal	ra,ffffffffc0203a64 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204e80:	8526                	mv	a0,s1
ffffffffc0204e82:	b74ff0ef          	jal	ra,ffffffffc02041f6 <put_pgdir>
    mm_destroy(mm);
ffffffffc0204e86:	8526                	mv	a0,s1
ffffffffc0204e88:	a41fe0ef          	jal	ra,ffffffffc02038c8 <mm_destroy>
    return ret;
ffffffffc0204e8c:	b705                	j	ffffffffc0204dac <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204e8e:	854e                	mv	a0,s3
ffffffffc0204e90:	bd5fe0ef          	jal	ra,ffffffffc0203a64 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204e94:	854e                	mv	a0,s3
ffffffffc0204e96:	b60ff0ef          	jal	ra,ffffffffc02041f6 <put_pgdir>
            mm_destroy(mm);
ffffffffc0204e9a:	854e                	mv	a0,s3
ffffffffc0204e9c:	a2dfe0ef          	jal	ra,ffffffffc02038c8 <mm_destroy>
ffffffffc0204ea0:	b32d                	j	ffffffffc0204bca <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204ea2:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ea6:	fb95                	bnez	a5,ffffffffc0204dda <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204ea8:	4d5d                	li	s10,23
ffffffffc0204eaa:	bf35                	j	ffffffffc0204de6 <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204eac:	0109b683          	ld	a3,16(s3)
ffffffffc0204eb0:	0289b903          	ld	s2,40(s3)
ffffffffc0204eb4:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204eb6:	075bfd63          	bgeu	s7,s5,ffffffffc0204f30 <do_execve+0x3f8>
            if (start == end)
ffffffffc0204eba:	db790fe3          	beq	s2,s7,ffffffffc0204c78 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204ebe:	6785                	lui	a5,0x1
ffffffffc0204ec0:	00fb8533          	add	a0,s7,a5
ffffffffc0204ec4:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204ec8:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204ecc:	0b597d63          	bgeu	s2,s5,ffffffffc0204f86 <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204ed0:	000cb683          	ld	a3,0(s9)
ffffffffc0204ed4:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204ed6:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204eda:	40d406b3          	sub	a3,s0,a3
ffffffffc0204ede:	8699                	srai	a3,a3,0x6
ffffffffc0204ee0:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204ee2:	67e2                	ld	a5,24(sp)
ffffffffc0204ee4:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204ee8:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204eea:	0ac5f963          	bgeu	a1,a2,ffffffffc0204f9c <do_execve+0x464>
ffffffffc0204eee:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204ef2:	8652                	mv	a2,s4
ffffffffc0204ef4:	4581                	li	a1,0
ffffffffc0204ef6:	96c2                	add	a3,a3,a6
ffffffffc0204ef8:	9536                	add	a0,a0,a3
ffffffffc0204efa:	2cb000ef          	jal	ra,ffffffffc02059c4 <memset>
            start += size;
ffffffffc0204efe:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204f02:	03597463          	bgeu	s2,s5,ffffffffc0204f2a <do_execve+0x3f2>
ffffffffc0204f06:	d6e909e3          	beq	s2,a4,ffffffffc0204c78 <do_execve+0x140>
ffffffffc0204f0a:	00002697          	auipc	a3,0x2
ffffffffc0204f0e:	76668693          	addi	a3,a3,1894 # ffffffffc0207670 <default_pmm_manager+0xdf8>
ffffffffc0204f12:	00001617          	auipc	a2,0x1
ffffffffc0204f16:	33e60613          	addi	a2,a2,830 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0204f1a:	2ac00593          	li	a1,684
ffffffffc0204f1e:	00002517          	auipc	a0,0x2
ffffffffc0204f22:	56250513          	addi	a0,a0,1378 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204f26:	d68fb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204f2a:	ff5710e3          	bne	a4,s5,ffffffffc0204f0a <do_execve+0x3d2>
ffffffffc0204f2e:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204f30:	d52bf4e3          	bgeu	s7,s2,ffffffffc0204c78 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204f34:	6c88                	ld	a0,24(s1)
ffffffffc0204f36:	866a                	mv	a2,s10
ffffffffc0204f38:	85d6                	mv	a1,s5
ffffffffc0204f3a:	f68fe0ef          	jal	ra,ffffffffc02036a2 <pgdir_alloc_page>
ffffffffc0204f3e:	842a                	mv	s0,a0
ffffffffc0204f40:	dd05                	beqz	a0,ffffffffc0204e78 <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204f42:	6785                	lui	a5,0x1
ffffffffc0204f44:	415b8533          	sub	a0,s7,s5
ffffffffc0204f48:	9abe                	add	s5,s5,a5
ffffffffc0204f4a:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204f4e:	01597463          	bgeu	s2,s5,ffffffffc0204f56 <do_execve+0x41e>
                size -= la - end;
ffffffffc0204f52:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204f56:	000cb683          	ld	a3,0(s9)
ffffffffc0204f5a:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204f5c:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204f60:	40d406b3          	sub	a3,s0,a3
ffffffffc0204f64:	8699                	srai	a3,a3,0x6
ffffffffc0204f66:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204f68:	67e2                	ld	a5,24(sp)
ffffffffc0204f6a:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204f6e:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204f70:	02b87663          	bgeu	a6,a1,ffffffffc0204f9c <do_execve+0x464>
ffffffffc0204f74:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f78:	4581                	li	a1,0
            start += size;
ffffffffc0204f7a:	9bb2                	add	s7,s7,a2
ffffffffc0204f7c:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204f7e:	9536                	add	a0,a0,a3
ffffffffc0204f80:	245000ef          	jal	ra,ffffffffc02059c4 <memset>
ffffffffc0204f84:	b775                	j	ffffffffc0204f30 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204f86:	417a8a33          	sub	s4,s5,s7
ffffffffc0204f8a:	b799                	j	ffffffffc0204ed0 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204f8c:	5a75                	li	s4,-3
ffffffffc0204f8e:	b3c1                	j	ffffffffc0204d4e <do_execve+0x216>
        while (start < end)
ffffffffc0204f90:	86de                	mv	a3,s7
ffffffffc0204f92:	bf39                	j	ffffffffc0204eb0 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204f94:	5a71                	li	s4,-4
ffffffffc0204f96:	bdc5                	j	ffffffffc0204e86 <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204f98:	5a61                	li	s4,-8
ffffffffc0204f9a:	b5c5                	j	ffffffffc0204e7a <do_execve+0x342>
ffffffffc0204f9c:	00002617          	auipc	a2,0x2
ffffffffc0204fa0:	91460613          	addi	a2,a2,-1772 # ffffffffc02068b0 <default_pmm_manager+0x38>
ffffffffc0204fa4:	07100593          	li	a1,113
ffffffffc0204fa8:	00002517          	auipc	a0,0x2
ffffffffc0204fac:	93050513          	addi	a0,a0,-1744 # ffffffffc02068d8 <default_pmm_manager+0x60>
ffffffffc0204fb0:	cdefb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204fb4:	00002617          	auipc	a2,0x2
ffffffffc0204fb8:	9a460613          	addi	a2,a2,-1628 # ffffffffc0206958 <default_pmm_manager+0xe0>
ffffffffc0204fbc:	2cb00593          	li	a1,715
ffffffffc0204fc0:	00002517          	auipc	a0,0x2
ffffffffc0204fc4:	4c050513          	addi	a0,a0,1216 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204fc8:	cc6fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204fcc:	00002697          	auipc	a3,0x2
ffffffffc0204fd0:	7bc68693          	addi	a3,a3,1980 # ffffffffc0207788 <default_pmm_manager+0xf10>
ffffffffc0204fd4:	00001617          	auipc	a2,0x1
ffffffffc0204fd8:	27c60613          	addi	a2,a2,636 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0204fdc:	2c600593          	li	a1,710
ffffffffc0204fe0:	00002517          	auipc	a0,0x2
ffffffffc0204fe4:	4a050513          	addi	a0,a0,1184 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0204fe8:	ca6fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204fec:	00002697          	auipc	a3,0x2
ffffffffc0204ff0:	75468693          	addi	a3,a3,1876 # ffffffffc0207740 <default_pmm_manager+0xec8>
ffffffffc0204ff4:	00001617          	auipc	a2,0x1
ffffffffc0204ff8:	25c60613          	addi	a2,a2,604 # ffffffffc0206250 <commands+0x5f8>
ffffffffc0204ffc:	2c500593          	li	a1,709
ffffffffc0205000:	00002517          	auipc	a0,0x2
ffffffffc0205004:	48050513          	addi	a0,a0,1152 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0205008:	c86fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc020500c:	00002697          	auipc	a3,0x2
ffffffffc0205010:	6ec68693          	addi	a3,a3,1772 # ffffffffc02076f8 <default_pmm_manager+0xe80>
ffffffffc0205014:	00001617          	auipc	a2,0x1
ffffffffc0205018:	23c60613          	addi	a2,a2,572 # ffffffffc0206250 <commands+0x5f8>
ffffffffc020501c:	2c400593          	li	a1,708
ffffffffc0205020:	00002517          	auipc	a0,0x2
ffffffffc0205024:	46050513          	addi	a0,a0,1120 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0205028:	c66fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc020502c:	00002697          	auipc	a3,0x2
ffffffffc0205030:	68468693          	addi	a3,a3,1668 # ffffffffc02076b0 <default_pmm_manager+0xe38>
ffffffffc0205034:	00001617          	auipc	a2,0x1
ffffffffc0205038:	21c60613          	addi	a2,a2,540 # ffffffffc0206250 <commands+0x5f8>
ffffffffc020503c:	2c300593          	li	a1,707
ffffffffc0205040:	00002517          	auipc	a0,0x2
ffffffffc0205044:	44050513          	addi	a0,a0,1088 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0205048:	c46fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020504c <do_yield>:
    current->need_resched = 1;
ffffffffc020504c:	000b0797          	auipc	a5,0xb0
ffffffffc0205050:	fe47b783          	ld	a5,-28(a5) # ffffffffc02b5030 <current>
ffffffffc0205054:	4705                	li	a4,1
ffffffffc0205056:	ef98                	sd	a4,24(a5)
}
ffffffffc0205058:	4501                	li	a0,0
ffffffffc020505a:	8082                	ret

ffffffffc020505c <do_wait>:
{
ffffffffc020505c:	1101                	addi	sp,sp,-32
ffffffffc020505e:	e822                	sd	s0,16(sp)
ffffffffc0205060:	e426                	sd	s1,8(sp)
ffffffffc0205062:	ec06                	sd	ra,24(sp)
ffffffffc0205064:	842e                	mv	s0,a1
ffffffffc0205066:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0205068:	c999                	beqz	a1,ffffffffc020507e <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc020506a:	000b0797          	auipc	a5,0xb0
ffffffffc020506e:	fc67b783          	ld	a5,-58(a5) # ffffffffc02b5030 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0205072:	7788                	ld	a0,40(a5)
ffffffffc0205074:	4685                	li	a3,1
ffffffffc0205076:	4611                	li	a2,4
ffffffffc0205078:	d87fe0ef          	jal	ra,ffffffffc0203dfe <user_mem_check>
ffffffffc020507c:	c909                	beqz	a0,ffffffffc020508e <do_wait+0x32>
ffffffffc020507e:	85a2                	mv	a1,s0
}
ffffffffc0205080:	6442                	ld	s0,16(sp)
ffffffffc0205082:	60e2                	ld	ra,24(sp)
ffffffffc0205084:	8526                	mv	a0,s1
ffffffffc0205086:	64a2                	ld	s1,8(sp)
ffffffffc0205088:	6105                	addi	sp,sp,32
ffffffffc020508a:	fb8ff06f          	j	ffffffffc0204842 <do_wait.part.0>
ffffffffc020508e:	60e2                	ld	ra,24(sp)
ffffffffc0205090:	6442                	ld	s0,16(sp)
ffffffffc0205092:	64a2                	ld	s1,8(sp)
ffffffffc0205094:	5575                	li	a0,-3
ffffffffc0205096:	6105                	addi	sp,sp,32
ffffffffc0205098:	8082                	ret

ffffffffc020509a <do_kill>:
{
ffffffffc020509a:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc020509c:	6789                	lui	a5,0x2
{
ffffffffc020509e:	e406                	sd	ra,8(sp)
ffffffffc02050a0:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc02050a2:	fff5071b          	addiw	a4,a0,-1
ffffffffc02050a6:	17f9                	addi	a5,a5,-2
ffffffffc02050a8:	02e7e963          	bltu	a5,a4,ffffffffc02050da <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02050ac:	842a                	mv	s0,a0
ffffffffc02050ae:	45a9                	li	a1,10
ffffffffc02050b0:	2501                	sext.w	a0,a0
ffffffffc02050b2:	46c000ef          	jal	ra,ffffffffc020551e <hash32>
ffffffffc02050b6:	02051793          	slli	a5,a0,0x20
ffffffffc02050ba:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02050be:	000ac797          	auipc	a5,0xac
ffffffffc02050c2:	ef278793          	addi	a5,a5,-270 # ffffffffc02b0fb0 <hash_list>
ffffffffc02050c6:	953e                	add	a0,a0,a5
ffffffffc02050c8:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc02050ca:	a029                	j	ffffffffc02050d4 <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc02050cc:	f2c7a703          	lw	a4,-212(a5)
ffffffffc02050d0:	00870b63          	beq	a4,s0,ffffffffc02050e6 <do_kill+0x4c>
ffffffffc02050d4:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02050d6:	fef51be3          	bne	a0,a5,ffffffffc02050cc <do_kill+0x32>
    return -E_INVAL;
ffffffffc02050da:	5475                	li	s0,-3
}
ffffffffc02050dc:	60a2                	ld	ra,8(sp)
ffffffffc02050de:	8522                	mv	a0,s0
ffffffffc02050e0:	6402                	ld	s0,0(sp)
ffffffffc02050e2:	0141                	addi	sp,sp,16
ffffffffc02050e4:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc02050e6:	fd87a703          	lw	a4,-40(a5)
ffffffffc02050ea:	00177693          	andi	a3,a4,1
ffffffffc02050ee:	e295                	bnez	a3,ffffffffc0205112 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc02050f0:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc02050f2:	00176713          	ori	a4,a4,1
ffffffffc02050f6:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc02050fa:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc02050fc:	fe06d0e3          	bgez	a3,ffffffffc02050dc <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0205100:	f2878513          	addi	a0,a5,-216
ffffffffc0205104:	22e000ef          	jal	ra,ffffffffc0205332 <wakeup_proc>
}
ffffffffc0205108:	60a2                	ld	ra,8(sp)
ffffffffc020510a:	8522                	mv	a0,s0
ffffffffc020510c:	6402                	ld	s0,0(sp)
ffffffffc020510e:	0141                	addi	sp,sp,16
ffffffffc0205110:	8082                	ret
        return -E_KILLED;
ffffffffc0205112:	545d                	li	s0,-9
ffffffffc0205114:	b7e1                	j	ffffffffc02050dc <do_kill+0x42>

ffffffffc0205116 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0205116:	1101                	addi	sp,sp,-32
ffffffffc0205118:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc020511a:	000b0797          	auipc	a5,0xb0
ffffffffc020511e:	e9678793          	addi	a5,a5,-362 # ffffffffc02b4fb0 <proc_list>
ffffffffc0205122:	ec06                	sd	ra,24(sp)
ffffffffc0205124:	e822                	sd	s0,16(sp)
ffffffffc0205126:	e04a                	sd	s2,0(sp)
ffffffffc0205128:	000ac497          	auipc	s1,0xac
ffffffffc020512c:	e8848493          	addi	s1,s1,-376 # ffffffffc02b0fb0 <hash_list>
ffffffffc0205130:	e79c                	sd	a5,8(a5)
ffffffffc0205132:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0205134:	000b0717          	auipc	a4,0xb0
ffffffffc0205138:	e7c70713          	addi	a4,a4,-388 # ffffffffc02b4fb0 <proc_list>
ffffffffc020513c:	87a6                	mv	a5,s1
ffffffffc020513e:	e79c                	sd	a5,8(a5)
ffffffffc0205140:	e39c                	sd	a5,0(a5)
ffffffffc0205142:	07c1                	addi	a5,a5,16
ffffffffc0205144:	fef71de3          	bne	a4,a5,ffffffffc020513e <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0205148:	fa1fe0ef          	jal	ra,ffffffffc02040e8 <alloc_proc>
ffffffffc020514c:	000b0917          	auipc	s2,0xb0
ffffffffc0205150:	eec90913          	addi	s2,s2,-276 # ffffffffc02b5038 <idleproc>
ffffffffc0205154:	00a93023          	sd	a0,0(s2)
ffffffffc0205158:	0e050f63          	beqz	a0,ffffffffc0205256 <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020515c:	4789                	li	a5,2
ffffffffc020515e:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0205160:	00003797          	auipc	a5,0x3
ffffffffc0205164:	ea078793          	addi	a5,a5,-352 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205168:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020516c:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc020516e:	4785                	li	a5,1
ffffffffc0205170:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205172:	4641                	li	a2,16
ffffffffc0205174:	4581                	li	a1,0
ffffffffc0205176:	8522                	mv	a0,s0
ffffffffc0205178:	04d000ef          	jal	ra,ffffffffc02059c4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020517c:	463d                	li	a2,15
ffffffffc020517e:	00002597          	auipc	a1,0x2
ffffffffc0205182:	66a58593          	addi	a1,a1,1642 # ffffffffc02077e8 <default_pmm_manager+0xf70>
ffffffffc0205186:	8522                	mv	a0,s0
ffffffffc0205188:	04f000ef          	jal	ra,ffffffffc02059d6 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc020518c:	000b0717          	auipc	a4,0xb0
ffffffffc0205190:	ebc70713          	addi	a4,a4,-324 # ffffffffc02b5048 <nr_process>
ffffffffc0205194:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0205196:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020519a:	4601                	li	a2,0
    nr_process++;
ffffffffc020519c:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc020519e:	4581                	li	a1,0
ffffffffc02051a0:	00000517          	auipc	a0,0x0
ffffffffc02051a4:	87450513          	addi	a0,a0,-1932 # ffffffffc0204a14 <init_main>
    nr_process++;
ffffffffc02051a8:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02051aa:	000b0797          	auipc	a5,0xb0
ffffffffc02051ae:	e8d7b323          	sd	a3,-378(a5) # ffffffffc02b5030 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc02051b2:	cf6ff0ef          	jal	ra,ffffffffc02046a8 <kernel_thread>
ffffffffc02051b6:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc02051b8:	08a05363          	blez	a0,ffffffffc020523e <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc02051bc:	6789                	lui	a5,0x2
ffffffffc02051be:	fff5071b          	addiw	a4,a0,-1
ffffffffc02051c2:	17f9                	addi	a5,a5,-2
ffffffffc02051c4:	2501                	sext.w	a0,a0
ffffffffc02051c6:	02e7e363          	bltu	a5,a4,ffffffffc02051ec <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc02051ca:	45a9                	li	a1,10
ffffffffc02051cc:	352000ef          	jal	ra,ffffffffc020551e <hash32>
ffffffffc02051d0:	02051793          	slli	a5,a0,0x20
ffffffffc02051d4:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02051d8:	96a6                	add	a3,a3,s1
ffffffffc02051da:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02051dc:	a029                	j	ffffffffc02051e6 <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc02051de:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c7c>
ffffffffc02051e2:	04870b63          	beq	a4,s0,ffffffffc0205238 <proc_init+0x122>
    return listelm->next;
ffffffffc02051e6:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02051e8:	fef69be3          	bne	a3,a5,ffffffffc02051de <proc_init+0xc8>
    return NULL;
ffffffffc02051ec:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051ee:	0b478493          	addi	s1,a5,180
ffffffffc02051f2:	4641                	li	a2,16
ffffffffc02051f4:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02051f6:	000b0417          	auipc	s0,0xb0
ffffffffc02051fa:	e4a40413          	addi	s0,s0,-438 # ffffffffc02b5040 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02051fe:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0205200:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0205202:	7c2000ef          	jal	ra,ffffffffc02059c4 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0205206:	463d                	li	a2,15
ffffffffc0205208:	00002597          	auipc	a1,0x2
ffffffffc020520c:	60858593          	addi	a1,a1,1544 # ffffffffc0207810 <default_pmm_manager+0xf98>
ffffffffc0205210:	8526                	mv	a0,s1
ffffffffc0205212:	7c4000ef          	jal	ra,ffffffffc02059d6 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0205216:	00093783          	ld	a5,0(s2)
ffffffffc020521a:	cbb5                	beqz	a5,ffffffffc020528e <proc_init+0x178>
ffffffffc020521c:	43dc                	lw	a5,4(a5)
ffffffffc020521e:	eba5                	bnez	a5,ffffffffc020528e <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0205220:	601c                	ld	a5,0(s0)
ffffffffc0205222:	c7b1                	beqz	a5,ffffffffc020526e <proc_init+0x158>
ffffffffc0205224:	43d8                	lw	a4,4(a5)
ffffffffc0205226:	4785                	li	a5,1
ffffffffc0205228:	04f71363          	bne	a4,a5,ffffffffc020526e <proc_init+0x158>
}
ffffffffc020522c:	60e2                	ld	ra,24(sp)
ffffffffc020522e:	6442                	ld	s0,16(sp)
ffffffffc0205230:	64a2                	ld	s1,8(sp)
ffffffffc0205232:	6902                	ld	s2,0(sp)
ffffffffc0205234:	6105                	addi	sp,sp,32
ffffffffc0205236:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0205238:	f2878793          	addi	a5,a5,-216
ffffffffc020523c:	bf4d                	j	ffffffffc02051ee <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc020523e:	00002617          	auipc	a2,0x2
ffffffffc0205242:	5b260613          	addi	a2,a2,1458 # ffffffffc02077f0 <default_pmm_manager+0xf78>
ffffffffc0205246:	3ef00593          	li	a1,1007
ffffffffc020524a:	00002517          	auipc	a0,0x2
ffffffffc020524e:	23650513          	addi	a0,a0,566 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc0205252:	a3cfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0205256:	00002617          	auipc	a2,0x2
ffffffffc020525a:	57a60613          	addi	a2,a2,1402 # ffffffffc02077d0 <default_pmm_manager+0xf58>
ffffffffc020525e:	3e000593          	li	a1,992
ffffffffc0205262:	00002517          	auipc	a0,0x2
ffffffffc0205266:	21e50513          	addi	a0,a0,542 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc020526a:	a24fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020526e:	00002697          	auipc	a3,0x2
ffffffffc0205272:	5d268693          	addi	a3,a3,1490 # ffffffffc0207840 <default_pmm_manager+0xfc8>
ffffffffc0205276:	00001617          	auipc	a2,0x1
ffffffffc020527a:	fda60613          	addi	a2,a2,-38 # ffffffffc0206250 <commands+0x5f8>
ffffffffc020527e:	3f600593          	li	a1,1014
ffffffffc0205282:	00002517          	auipc	a0,0x2
ffffffffc0205286:	1fe50513          	addi	a0,a0,510 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc020528a:	a04fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020528e:	00002697          	auipc	a3,0x2
ffffffffc0205292:	58a68693          	addi	a3,a3,1418 # ffffffffc0207818 <default_pmm_manager+0xfa0>
ffffffffc0205296:	00001617          	auipc	a2,0x1
ffffffffc020529a:	fba60613          	addi	a2,a2,-70 # ffffffffc0206250 <commands+0x5f8>
ffffffffc020529e:	3f500593          	li	a1,1013
ffffffffc02052a2:	00002517          	auipc	a0,0x2
ffffffffc02052a6:	1de50513          	addi	a0,a0,478 # ffffffffc0207480 <default_pmm_manager+0xc08>
ffffffffc02052aa:	9e4fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02052ae <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02052ae:	1141                	addi	sp,sp,-16
ffffffffc02052b0:	e022                	sd	s0,0(sp)
ffffffffc02052b2:	e406                	sd	ra,8(sp)
ffffffffc02052b4:	000b0417          	auipc	s0,0xb0
ffffffffc02052b8:	d7c40413          	addi	s0,s0,-644 # ffffffffc02b5030 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02052bc:	6018                	ld	a4,0(s0)
ffffffffc02052be:	6f1c                	ld	a5,24(a4)
ffffffffc02052c0:	dffd                	beqz	a5,ffffffffc02052be <cpu_idle+0x10>
        {
            schedule();
ffffffffc02052c2:	0f0000ef          	jal	ra,ffffffffc02053b2 <schedule>
ffffffffc02052c6:	bfdd                	j	ffffffffc02052bc <cpu_idle+0xe>

ffffffffc02052c8 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc02052c8:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc02052cc:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc02052d0:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc02052d2:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc02052d4:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc02052d8:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc02052dc:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc02052e0:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc02052e4:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc02052e8:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc02052ec:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc02052f0:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc02052f4:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc02052f8:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc02052fc:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205300:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0205304:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0205306:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0205308:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc020530c:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205310:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0205314:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0205318:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc020531c:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205320:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0205324:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0205328:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc020532c:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205330:	8082                	ret

ffffffffc0205332 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205332:	4118                	lw	a4,0(a0)
{
ffffffffc0205334:	1101                	addi	sp,sp,-32
ffffffffc0205336:	ec06                	sd	ra,24(sp)
ffffffffc0205338:	e822                	sd	s0,16(sp)
ffffffffc020533a:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc020533c:	478d                	li	a5,3
ffffffffc020533e:	04f70b63          	beq	a4,a5,ffffffffc0205394 <wakeup_proc+0x62>
ffffffffc0205342:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205344:	100027f3          	csrr	a5,sstatus
ffffffffc0205348:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020534a:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020534c:	ef9d                	bnez	a5,ffffffffc020538a <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc020534e:	4789                	li	a5,2
ffffffffc0205350:	02f70163          	beq	a4,a5,ffffffffc0205372 <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0205354:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0205356:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc020535a:	e491                	bnez	s1,ffffffffc0205366 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020535c:	60e2                	ld	ra,24(sp)
ffffffffc020535e:	6442                	ld	s0,16(sp)
ffffffffc0205360:	64a2                	ld	s1,8(sp)
ffffffffc0205362:	6105                	addi	sp,sp,32
ffffffffc0205364:	8082                	ret
ffffffffc0205366:	6442                	ld	s0,16(sp)
ffffffffc0205368:	60e2                	ld	ra,24(sp)
ffffffffc020536a:	64a2                	ld	s1,8(sp)
ffffffffc020536c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020536e:	e40fb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205372:	00002617          	auipc	a2,0x2
ffffffffc0205376:	52e60613          	addi	a2,a2,1326 # ffffffffc02078a0 <default_pmm_manager+0x1028>
ffffffffc020537a:	45d1                	li	a1,20
ffffffffc020537c:	00002517          	auipc	a0,0x2
ffffffffc0205380:	50c50513          	addi	a0,a0,1292 # ffffffffc0207888 <default_pmm_manager+0x1010>
ffffffffc0205384:	972fb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc0205388:	bfc9                	j	ffffffffc020535a <wakeup_proc+0x28>
        intr_disable();
ffffffffc020538a:	e2afb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020538e:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc0205390:	4485                	li	s1,1
ffffffffc0205392:	bf75                	j	ffffffffc020534e <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205394:	00002697          	auipc	a3,0x2
ffffffffc0205398:	4d468693          	addi	a3,a3,1236 # ffffffffc0207868 <default_pmm_manager+0xff0>
ffffffffc020539c:	00001617          	auipc	a2,0x1
ffffffffc02053a0:	eb460613          	addi	a2,a2,-332 # ffffffffc0206250 <commands+0x5f8>
ffffffffc02053a4:	45a5                	li	a1,9
ffffffffc02053a6:	00002517          	auipc	a0,0x2
ffffffffc02053aa:	4e250513          	addi	a0,a0,1250 # ffffffffc0207888 <default_pmm_manager+0x1010>
ffffffffc02053ae:	8e0fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02053b2 <schedule>:

void schedule(void)
{
ffffffffc02053b2:	1141                	addi	sp,sp,-16
ffffffffc02053b4:	e406                	sd	ra,8(sp)
ffffffffc02053b6:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02053b8:	100027f3          	csrr	a5,sstatus
ffffffffc02053bc:	8b89                	andi	a5,a5,2
ffffffffc02053be:	4401                	li	s0,0
ffffffffc02053c0:	efbd                	bnez	a5,ffffffffc020543e <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02053c2:	000b0897          	auipc	a7,0xb0
ffffffffc02053c6:	c6e8b883          	ld	a7,-914(a7) # ffffffffc02b5030 <current>
ffffffffc02053ca:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02053ce:	000b0517          	auipc	a0,0xb0
ffffffffc02053d2:	c6a53503          	ld	a0,-918(a0) # ffffffffc02b5038 <idleproc>
ffffffffc02053d6:	04a88e63          	beq	a7,a0,ffffffffc0205432 <schedule+0x80>
ffffffffc02053da:	0c888693          	addi	a3,a7,200
ffffffffc02053de:	000b0617          	auipc	a2,0xb0
ffffffffc02053e2:	bd260613          	addi	a2,a2,-1070 # ffffffffc02b4fb0 <proc_list>
        le = last;
ffffffffc02053e6:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02053e8:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc02053ea:	4809                	li	a6,2
ffffffffc02053ec:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc02053ee:	00c78863          	beq	a5,a2,ffffffffc02053fe <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc02053f2:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc02053f6:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc02053fa:	03070163          	beq	a4,a6,ffffffffc020541c <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc02053fe:	fef697e3          	bne	a3,a5,ffffffffc02053ec <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205402:	ed89                	bnez	a1,ffffffffc020541c <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc0205404:	451c                	lw	a5,8(a0)
ffffffffc0205406:	2785                	addiw	a5,a5,1
ffffffffc0205408:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc020540a:	00a88463          	beq	a7,a0,ffffffffc0205412 <schedule+0x60>
        {
            proc_run(next);
ffffffffc020540e:	e5ffe0ef          	jal	ra,ffffffffc020426c <proc_run>
    if (flag)
ffffffffc0205412:	e819                	bnez	s0,ffffffffc0205428 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205414:	60a2                	ld	ra,8(sp)
ffffffffc0205416:	6402                	ld	s0,0(sp)
ffffffffc0205418:	0141                	addi	sp,sp,16
ffffffffc020541a:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020541c:	4198                	lw	a4,0(a1)
ffffffffc020541e:	4789                	li	a5,2
ffffffffc0205420:	fef712e3          	bne	a4,a5,ffffffffc0205404 <schedule+0x52>
ffffffffc0205424:	852e                	mv	a0,a1
ffffffffc0205426:	bff9                	j	ffffffffc0205404 <schedule+0x52>
}
ffffffffc0205428:	6402                	ld	s0,0(sp)
ffffffffc020542a:	60a2                	ld	ra,8(sp)
ffffffffc020542c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020542e:	d80fb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205432:	000b0617          	auipc	a2,0xb0
ffffffffc0205436:	b7e60613          	addi	a2,a2,-1154 # ffffffffc02b4fb0 <proc_list>
ffffffffc020543a:	86b2                	mv	a3,a2
ffffffffc020543c:	b76d                	j	ffffffffc02053e6 <schedule+0x34>
        intr_disable();
ffffffffc020543e:	d76fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205442:	4405                	li	s0,1
ffffffffc0205444:	bfbd                	j	ffffffffc02053c2 <schedule+0x10>

ffffffffc0205446 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc0205446:	000b0797          	auipc	a5,0xb0
ffffffffc020544a:	bea7b783          	ld	a5,-1046(a5) # ffffffffc02b5030 <current>
}
ffffffffc020544e:	43c8                	lw	a0,4(a5)
ffffffffc0205450:	8082                	ret

ffffffffc0205452 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205452:	4501                	li	a0,0
ffffffffc0205454:	8082                	ret

ffffffffc0205456 <sys_putc>:
    cputchar(c);
ffffffffc0205456:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc0205458:	1141                	addi	sp,sp,-16
ffffffffc020545a:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc020545c:	d6ffa0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc0205460:	60a2                	ld	ra,8(sp)
ffffffffc0205462:	4501                	li	a0,0
ffffffffc0205464:	0141                	addi	sp,sp,16
ffffffffc0205466:	8082                	ret

ffffffffc0205468 <sys_kill>:
    return do_kill(pid);
ffffffffc0205468:	4108                	lw	a0,0(a0)
ffffffffc020546a:	c31ff06f          	j	ffffffffc020509a <do_kill>

ffffffffc020546e <sys_yield>:
    return do_yield();
ffffffffc020546e:	bdfff06f          	j	ffffffffc020504c <do_yield>

ffffffffc0205472 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205472:	6d14                	ld	a3,24(a0)
ffffffffc0205474:	6910                	ld	a2,16(a0)
ffffffffc0205476:	650c                	ld	a1,8(a0)
ffffffffc0205478:	6108                	ld	a0,0(a0)
ffffffffc020547a:	ebeff06f          	j	ffffffffc0204b38 <do_execve>

ffffffffc020547e <sys_wait>:
    return do_wait(pid, store);
ffffffffc020547e:	650c                	ld	a1,8(a0)
ffffffffc0205480:	4108                	lw	a0,0(a0)
ffffffffc0205482:	bdbff06f          	j	ffffffffc020505c <do_wait>

ffffffffc0205486 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205486:	000b0797          	auipc	a5,0xb0
ffffffffc020548a:	baa7b783          	ld	a5,-1110(a5) # ffffffffc02b5030 <current>
ffffffffc020548e:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc0205490:	4501                	li	a0,0
ffffffffc0205492:	6a0c                	ld	a1,16(a2)
ffffffffc0205494:	e45fe06f          	j	ffffffffc02042d8 <do_fork>

ffffffffc0205498 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205498:	4108                	lw	a0,0(a0)
ffffffffc020549a:	a5eff06f          	j	ffffffffc02046f8 <do_exit>

ffffffffc020549e <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020549e:	715d                	addi	sp,sp,-80
ffffffffc02054a0:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02054a2:	000b0497          	auipc	s1,0xb0
ffffffffc02054a6:	b8e48493          	addi	s1,s1,-1138 # ffffffffc02b5030 <current>
ffffffffc02054aa:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02054ac:	e0a2                	sd	s0,64(sp)
ffffffffc02054ae:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02054b0:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02054b2:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02054b4:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02054b6:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02054ba:	0327ee63          	bltu	a5,s2,ffffffffc02054f6 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02054be:	00391713          	slli	a4,s2,0x3
ffffffffc02054c2:	00002797          	auipc	a5,0x2
ffffffffc02054c6:	44678793          	addi	a5,a5,1094 # ffffffffc0207908 <syscalls>
ffffffffc02054ca:	97ba                	add	a5,a5,a4
ffffffffc02054cc:	639c                	ld	a5,0(a5)
ffffffffc02054ce:	c785                	beqz	a5,ffffffffc02054f6 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02054d0:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02054d2:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02054d4:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02054d6:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02054d8:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02054da:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02054dc:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02054de:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02054e0:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02054e2:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02054e4:	0028                	addi	a0,sp,8
ffffffffc02054e6:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02054e8:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02054ea:	e828                	sd	a0,80(s0)
}
ffffffffc02054ec:	6406                	ld	s0,64(sp)
ffffffffc02054ee:	74e2                	ld	s1,56(sp)
ffffffffc02054f0:	7942                	ld	s2,48(sp)
ffffffffc02054f2:	6161                	addi	sp,sp,80
ffffffffc02054f4:	8082                	ret
    print_trapframe(tf);
ffffffffc02054f6:	8522                	mv	a0,s0
ffffffffc02054f8:	eacfb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc02054fc:	609c                	ld	a5,0(s1)
ffffffffc02054fe:	86ca                	mv	a3,s2
ffffffffc0205500:	00002617          	auipc	a2,0x2
ffffffffc0205504:	3c060613          	addi	a2,a2,960 # ffffffffc02078c0 <default_pmm_manager+0x1048>
ffffffffc0205508:	43d8                	lw	a4,4(a5)
ffffffffc020550a:	06200593          	li	a1,98
ffffffffc020550e:	0b478793          	addi	a5,a5,180
ffffffffc0205512:	00002517          	auipc	a0,0x2
ffffffffc0205516:	3de50513          	addi	a0,a0,990 # ffffffffc02078f0 <default_pmm_manager+0x1078>
ffffffffc020551a:	f75fa0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020551e <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc020551e:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205522:	2785                	addiw	a5,a5,1
ffffffffc0205524:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0205528:	02000793          	li	a5,32
ffffffffc020552c:	9f8d                	subw	a5,a5,a1
}
ffffffffc020552e:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205532:	8082                	ret

ffffffffc0205534 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205534:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205538:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020553a:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020553e:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205540:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205544:	f022                	sd	s0,32(sp)
ffffffffc0205546:	ec26                	sd	s1,24(sp)
ffffffffc0205548:	e84a                	sd	s2,16(sp)
ffffffffc020554a:	f406                	sd	ra,40(sp)
ffffffffc020554c:	e44e                	sd	s3,8(sp)
ffffffffc020554e:	84aa                	mv	s1,a0
ffffffffc0205550:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205552:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0205556:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0205558:	03067e63          	bgeu	a2,a6,ffffffffc0205594 <printnum+0x60>
ffffffffc020555c:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc020555e:	00805763          	blez	s0,ffffffffc020556c <printnum+0x38>
ffffffffc0205562:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0205564:	85ca                	mv	a1,s2
ffffffffc0205566:	854e                	mv	a0,s3
ffffffffc0205568:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc020556a:	fc65                	bnez	s0,ffffffffc0205562 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020556c:	1a02                	slli	s4,s4,0x20
ffffffffc020556e:	00002797          	auipc	a5,0x2
ffffffffc0205572:	49a78793          	addi	a5,a5,1178 # ffffffffc0207a08 <syscalls+0x100>
ffffffffc0205576:	020a5a13          	srli	s4,s4,0x20
ffffffffc020557a:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc020557c:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020557e:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205582:	70a2                	ld	ra,40(sp)
ffffffffc0205584:	69a2                	ld	s3,8(sp)
ffffffffc0205586:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205588:	85ca                	mv	a1,s2
ffffffffc020558a:	87a6                	mv	a5,s1
}
ffffffffc020558c:	6942                	ld	s2,16(sp)
ffffffffc020558e:	64e2                	ld	s1,24(sp)
ffffffffc0205590:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205592:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0205594:	03065633          	divu	a2,a2,a6
ffffffffc0205598:	8722                	mv	a4,s0
ffffffffc020559a:	f9bff0ef          	jal	ra,ffffffffc0205534 <printnum>
ffffffffc020559e:	b7f9                	j	ffffffffc020556c <printnum+0x38>

ffffffffc02055a0 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02055a0:	7119                	addi	sp,sp,-128
ffffffffc02055a2:	f4a6                	sd	s1,104(sp)
ffffffffc02055a4:	f0ca                	sd	s2,96(sp)
ffffffffc02055a6:	ecce                	sd	s3,88(sp)
ffffffffc02055a8:	e8d2                	sd	s4,80(sp)
ffffffffc02055aa:	e4d6                	sd	s5,72(sp)
ffffffffc02055ac:	e0da                	sd	s6,64(sp)
ffffffffc02055ae:	fc5e                	sd	s7,56(sp)
ffffffffc02055b0:	f06a                	sd	s10,32(sp)
ffffffffc02055b2:	fc86                	sd	ra,120(sp)
ffffffffc02055b4:	f8a2                	sd	s0,112(sp)
ffffffffc02055b6:	f862                	sd	s8,48(sp)
ffffffffc02055b8:	f466                	sd	s9,40(sp)
ffffffffc02055ba:	ec6e                	sd	s11,24(sp)
ffffffffc02055bc:	892a                	mv	s2,a0
ffffffffc02055be:	84ae                	mv	s1,a1
ffffffffc02055c0:	8d32                	mv	s10,a2
ffffffffc02055c2:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055c4:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02055c8:	5b7d                	li	s6,-1
ffffffffc02055ca:	00002a97          	auipc	s5,0x2
ffffffffc02055ce:	46aa8a93          	addi	s5,s5,1130 # ffffffffc0207a34 <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02055d2:	00002b97          	auipc	s7,0x2
ffffffffc02055d6:	67eb8b93          	addi	s7,s7,1662 # ffffffffc0207c50 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055da:	000d4503          	lbu	a0,0(s10)
ffffffffc02055de:	001d0413          	addi	s0,s10,1
ffffffffc02055e2:	01350a63          	beq	a0,s3,ffffffffc02055f6 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02055e6:	c121                	beqz	a0,ffffffffc0205626 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02055e8:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055ea:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc02055ec:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02055ee:	fff44503          	lbu	a0,-1(s0)
ffffffffc02055f2:	ff351ae3          	bne	a0,s3,ffffffffc02055e6 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02055f6:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc02055fa:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc02055fe:	4c81                	li	s9,0
ffffffffc0205600:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205602:	5c7d                	li	s8,-1
ffffffffc0205604:	5dfd                	li	s11,-1
ffffffffc0205606:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020560a:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020560c:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205610:	0ff5f593          	zext.b	a1,a1
ffffffffc0205614:	00140d13          	addi	s10,s0,1
ffffffffc0205618:	04b56263          	bltu	a0,a1,ffffffffc020565c <vprintfmt+0xbc>
ffffffffc020561c:	058a                	slli	a1,a1,0x2
ffffffffc020561e:	95d6                	add	a1,a1,s5
ffffffffc0205620:	4194                	lw	a3,0(a1)
ffffffffc0205622:	96d6                	add	a3,a3,s5
ffffffffc0205624:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205626:	70e6                	ld	ra,120(sp)
ffffffffc0205628:	7446                	ld	s0,112(sp)
ffffffffc020562a:	74a6                	ld	s1,104(sp)
ffffffffc020562c:	7906                	ld	s2,96(sp)
ffffffffc020562e:	69e6                	ld	s3,88(sp)
ffffffffc0205630:	6a46                	ld	s4,80(sp)
ffffffffc0205632:	6aa6                	ld	s5,72(sp)
ffffffffc0205634:	6b06                	ld	s6,64(sp)
ffffffffc0205636:	7be2                	ld	s7,56(sp)
ffffffffc0205638:	7c42                	ld	s8,48(sp)
ffffffffc020563a:	7ca2                	ld	s9,40(sp)
ffffffffc020563c:	7d02                	ld	s10,32(sp)
ffffffffc020563e:	6de2                	ld	s11,24(sp)
ffffffffc0205640:	6109                	addi	sp,sp,128
ffffffffc0205642:	8082                	ret
            padc = '0';
ffffffffc0205644:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205646:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020564a:	846a                	mv	s0,s10
ffffffffc020564c:	00140d13          	addi	s10,s0,1
ffffffffc0205650:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205654:	0ff5f593          	zext.b	a1,a1
ffffffffc0205658:	fcb572e3          	bgeu	a0,a1,ffffffffc020561c <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc020565c:	85a6                	mv	a1,s1
ffffffffc020565e:	02500513          	li	a0,37
ffffffffc0205662:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0205664:	fff44783          	lbu	a5,-1(s0)
ffffffffc0205668:	8d22                	mv	s10,s0
ffffffffc020566a:	f73788e3          	beq	a5,s3,ffffffffc02055da <vprintfmt+0x3a>
ffffffffc020566e:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205672:	1d7d                	addi	s10,s10,-1
ffffffffc0205674:	ff379de3          	bne	a5,s3,ffffffffc020566e <vprintfmt+0xce>
ffffffffc0205678:	b78d                	j	ffffffffc02055da <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc020567a:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc020567e:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205682:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0205684:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0205688:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc020568c:	02d86463          	bltu	a6,a3,ffffffffc02056b4 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0205690:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0205694:	002c169b          	slliw	a3,s8,0x2
ffffffffc0205698:	0186873b          	addw	a4,a3,s8
ffffffffc020569c:	0017171b          	slliw	a4,a4,0x1
ffffffffc02056a0:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02056a2:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02056a6:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02056a8:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02056ac:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02056b0:	fed870e3          	bgeu	a6,a3,ffffffffc0205690 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02056b4:	f40ddce3          	bgez	s11,ffffffffc020560c <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02056b8:	8de2                	mv	s11,s8
ffffffffc02056ba:	5c7d                	li	s8,-1
ffffffffc02056bc:	bf81                	j	ffffffffc020560c <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02056be:	fffdc693          	not	a3,s11
ffffffffc02056c2:	96fd                	srai	a3,a3,0x3f
ffffffffc02056c4:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056c8:	00144603          	lbu	a2,1(s0)
ffffffffc02056cc:	2d81                	sext.w	s11,s11
ffffffffc02056ce:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02056d0:	bf35                	j	ffffffffc020560c <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02056d2:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056d6:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02056da:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02056dc:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02056de:	bfd9                	j	ffffffffc02056b4 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02056e0:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02056e2:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02056e6:	01174463          	blt	a4,a7,ffffffffc02056ee <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc02056ea:	1a088e63          	beqz	a7,ffffffffc02058a6 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc02056ee:	000a3603          	ld	a2,0(s4)
ffffffffc02056f2:	46c1                	li	a3,16
ffffffffc02056f4:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc02056f6:	2781                	sext.w	a5,a5
ffffffffc02056f8:	876e                	mv	a4,s11
ffffffffc02056fa:	85a6                	mv	a1,s1
ffffffffc02056fc:	854a                	mv	a0,s2
ffffffffc02056fe:	e37ff0ef          	jal	ra,ffffffffc0205534 <printnum>
            break;
ffffffffc0205702:	bde1                	j	ffffffffc02055da <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205704:	000a2503          	lw	a0,0(s4)
ffffffffc0205708:	85a6                	mv	a1,s1
ffffffffc020570a:	0a21                	addi	s4,s4,8
ffffffffc020570c:	9902                	jalr	s2
            break;
ffffffffc020570e:	b5f1                	j	ffffffffc02055da <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205710:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205712:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205716:	01174463          	blt	a4,a7,ffffffffc020571e <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc020571a:	18088163          	beqz	a7,ffffffffc020589c <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc020571e:	000a3603          	ld	a2,0(s4)
ffffffffc0205722:	46a9                	li	a3,10
ffffffffc0205724:	8a2e                	mv	s4,a1
ffffffffc0205726:	bfc1                	j	ffffffffc02056f6 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205728:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020572c:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020572e:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205730:	bdf1                	j	ffffffffc020560c <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205732:	85a6                	mv	a1,s1
ffffffffc0205734:	02500513          	li	a0,37
ffffffffc0205738:	9902                	jalr	s2
            break;
ffffffffc020573a:	b545                	j	ffffffffc02055da <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020573c:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205740:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205742:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205744:	b5e1                	j	ffffffffc020560c <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205746:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205748:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020574c:	01174463          	blt	a4,a7,ffffffffc0205754 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0205750:	14088163          	beqz	a7,ffffffffc0205892 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0205754:	000a3603          	ld	a2,0(s4)
ffffffffc0205758:	46a1                	li	a3,8
ffffffffc020575a:	8a2e                	mv	s4,a1
ffffffffc020575c:	bf69                	j	ffffffffc02056f6 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc020575e:	03000513          	li	a0,48
ffffffffc0205762:	85a6                	mv	a1,s1
ffffffffc0205764:	e03e                	sd	a5,0(sp)
ffffffffc0205766:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0205768:	85a6                	mv	a1,s1
ffffffffc020576a:	07800513          	li	a0,120
ffffffffc020576e:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205770:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205772:	6782                	ld	a5,0(sp)
ffffffffc0205774:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205776:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc020577a:	bfb5                	j	ffffffffc02056f6 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc020577c:	000a3403          	ld	s0,0(s4)
ffffffffc0205780:	008a0713          	addi	a4,s4,8
ffffffffc0205784:	e03a                	sd	a4,0(sp)
ffffffffc0205786:	14040263          	beqz	s0,ffffffffc02058ca <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc020578a:	0fb05763          	blez	s11,ffffffffc0205878 <vprintfmt+0x2d8>
ffffffffc020578e:	02d00693          	li	a3,45
ffffffffc0205792:	0cd79163          	bne	a5,a3,ffffffffc0205854 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205796:	00044783          	lbu	a5,0(s0)
ffffffffc020579a:	0007851b          	sext.w	a0,a5
ffffffffc020579e:	cf85                	beqz	a5,ffffffffc02057d6 <vprintfmt+0x236>
ffffffffc02057a0:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057a4:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057a8:	000c4563          	bltz	s8,ffffffffc02057b2 <vprintfmt+0x212>
ffffffffc02057ac:	3c7d                	addiw	s8,s8,-1
ffffffffc02057ae:	036c0263          	beq	s8,s6,ffffffffc02057d2 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02057b2:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02057b4:	0e0c8e63          	beqz	s9,ffffffffc02058b0 <vprintfmt+0x310>
ffffffffc02057b8:	3781                	addiw	a5,a5,-32
ffffffffc02057ba:	0ef47b63          	bgeu	s0,a5,ffffffffc02058b0 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02057be:	03f00513          	li	a0,63
ffffffffc02057c2:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02057c4:	000a4783          	lbu	a5,0(s4)
ffffffffc02057c8:	3dfd                	addiw	s11,s11,-1
ffffffffc02057ca:	0a05                	addi	s4,s4,1
ffffffffc02057cc:	0007851b          	sext.w	a0,a5
ffffffffc02057d0:	ffe1                	bnez	a5,ffffffffc02057a8 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02057d2:	01b05963          	blez	s11,ffffffffc02057e4 <vprintfmt+0x244>
ffffffffc02057d6:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02057d8:	85a6                	mv	a1,s1
ffffffffc02057da:	02000513          	li	a0,32
ffffffffc02057de:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02057e0:	fe0d9be3          	bnez	s11,ffffffffc02057d6 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02057e4:	6a02                	ld	s4,0(sp)
ffffffffc02057e6:	bbd5                	j	ffffffffc02055da <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02057e8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02057ea:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc02057ee:	01174463          	blt	a4,a7,ffffffffc02057f6 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc02057f2:	08088d63          	beqz	a7,ffffffffc020588c <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc02057f6:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc02057fa:	0a044d63          	bltz	s0,ffffffffc02058b4 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc02057fe:	8622                	mv	a2,s0
ffffffffc0205800:	8a66                	mv	s4,s9
ffffffffc0205802:	46a9                	li	a3,10
ffffffffc0205804:	bdcd                	j	ffffffffc02056f6 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205806:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020580a:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc020580c:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc020580e:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205812:	8fb5                	xor	a5,a5,a3
ffffffffc0205814:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205818:	02d74163          	blt	a4,a3,ffffffffc020583a <vprintfmt+0x29a>
ffffffffc020581c:	00369793          	slli	a5,a3,0x3
ffffffffc0205820:	97de                	add	a5,a5,s7
ffffffffc0205822:	639c                	ld	a5,0(a5)
ffffffffc0205824:	cb99                	beqz	a5,ffffffffc020583a <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205826:	86be                	mv	a3,a5
ffffffffc0205828:	00000617          	auipc	a2,0x0
ffffffffc020582c:	1f060613          	addi	a2,a2,496 # ffffffffc0205a18 <etext+0x2a>
ffffffffc0205830:	85a6                	mv	a1,s1
ffffffffc0205832:	854a                	mv	a0,s2
ffffffffc0205834:	0ce000ef          	jal	ra,ffffffffc0205902 <printfmt>
ffffffffc0205838:	b34d                	j	ffffffffc02055da <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020583a:	00002617          	auipc	a2,0x2
ffffffffc020583e:	1ee60613          	addi	a2,a2,494 # ffffffffc0207a28 <syscalls+0x120>
ffffffffc0205842:	85a6                	mv	a1,s1
ffffffffc0205844:	854a                	mv	a0,s2
ffffffffc0205846:	0bc000ef          	jal	ra,ffffffffc0205902 <printfmt>
ffffffffc020584a:	bb41                	j	ffffffffc02055da <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020584c:	00002417          	auipc	s0,0x2
ffffffffc0205850:	1d440413          	addi	s0,s0,468 # ffffffffc0207a20 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205854:	85e2                	mv	a1,s8
ffffffffc0205856:	8522                	mv	a0,s0
ffffffffc0205858:	e43e                	sd	a5,8(sp)
ffffffffc020585a:	0e2000ef          	jal	ra,ffffffffc020593c <strnlen>
ffffffffc020585e:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205862:	01b05b63          	blez	s11,ffffffffc0205878 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0205866:	67a2                	ld	a5,8(sp)
ffffffffc0205868:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020586c:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc020586e:	85a6                	mv	a1,s1
ffffffffc0205870:	8552                	mv	a0,s4
ffffffffc0205872:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205874:	fe0d9ce3          	bnez	s11,ffffffffc020586c <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205878:	00044783          	lbu	a5,0(s0)
ffffffffc020587c:	00140a13          	addi	s4,s0,1
ffffffffc0205880:	0007851b          	sext.w	a0,a5
ffffffffc0205884:	d3a5                	beqz	a5,ffffffffc02057e4 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205886:	05e00413          	li	s0,94
ffffffffc020588a:	bf39                	j	ffffffffc02057a8 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc020588c:	000a2403          	lw	s0,0(s4)
ffffffffc0205890:	b7ad                	j	ffffffffc02057fa <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0205892:	000a6603          	lwu	a2,0(s4)
ffffffffc0205896:	46a1                	li	a3,8
ffffffffc0205898:	8a2e                	mv	s4,a1
ffffffffc020589a:	bdb1                	j	ffffffffc02056f6 <vprintfmt+0x156>
ffffffffc020589c:	000a6603          	lwu	a2,0(s4)
ffffffffc02058a0:	46a9                	li	a3,10
ffffffffc02058a2:	8a2e                	mv	s4,a1
ffffffffc02058a4:	bd89                	j	ffffffffc02056f6 <vprintfmt+0x156>
ffffffffc02058a6:	000a6603          	lwu	a2,0(s4)
ffffffffc02058aa:	46c1                	li	a3,16
ffffffffc02058ac:	8a2e                	mv	s4,a1
ffffffffc02058ae:	b5a1                	j	ffffffffc02056f6 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02058b0:	9902                	jalr	s2
ffffffffc02058b2:	bf09                	j	ffffffffc02057c4 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02058b4:	85a6                	mv	a1,s1
ffffffffc02058b6:	02d00513          	li	a0,45
ffffffffc02058ba:	e03e                	sd	a5,0(sp)
ffffffffc02058bc:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02058be:	6782                	ld	a5,0(sp)
ffffffffc02058c0:	8a66                	mv	s4,s9
ffffffffc02058c2:	40800633          	neg	a2,s0
ffffffffc02058c6:	46a9                	li	a3,10
ffffffffc02058c8:	b53d                	j	ffffffffc02056f6 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02058ca:	03b05163          	blez	s11,ffffffffc02058ec <vprintfmt+0x34c>
ffffffffc02058ce:	02d00693          	li	a3,45
ffffffffc02058d2:	f6d79de3          	bne	a5,a3,ffffffffc020584c <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02058d6:	00002417          	auipc	s0,0x2
ffffffffc02058da:	14a40413          	addi	s0,s0,330 # ffffffffc0207a20 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02058de:	02800793          	li	a5,40
ffffffffc02058e2:	02800513          	li	a0,40
ffffffffc02058e6:	00140a13          	addi	s4,s0,1
ffffffffc02058ea:	bd6d                	j	ffffffffc02057a4 <vprintfmt+0x204>
ffffffffc02058ec:	00002a17          	auipc	s4,0x2
ffffffffc02058f0:	135a0a13          	addi	s4,s4,309 # ffffffffc0207a21 <syscalls+0x119>
ffffffffc02058f4:	02800513          	li	a0,40
ffffffffc02058f8:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02058fc:	05e00413          	li	s0,94
ffffffffc0205900:	b565                	j	ffffffffc02057a8 <vprintfmt+0x208>

ffffffffc0205902 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205902:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205904:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205908:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020590a:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020590c:	ec06                	sd	ra,24(sp)
ffffffffc020590e:	f83a                	sd	a4,48(sp)
ffffffffc0205910:	fc3e                	sd	a5,56(sp)
ffffffffc0205912:	e0c2                	sd	a6,64(sp)
ffffffffc0205914:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205916:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205918:	c89ff0ef          	jal	ra,ffffffffc02055a0 <vprintfmt>
}
ffffffffc020591c:	60e2                	ld	ra,24(sp)
ffffffffc020591e:	6161                	addi	sp,sp,80
ffffffffc0205920:	8082                	ret

ffffffffc0205922 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205922:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0205926:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0205928:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc020592a:	cb81                	beqz	a5,ffffffffc020593a <strlen+0x18>
        cnt ++;
ffffffffc020592c:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc020592e:	00a707b3          	add	a5,a4,a0
ffffffffc0205932:	0007c783          	lbu	a5,0(a5)
ffffffffc0205936:	fbfd                	bnez	a5,ffffffffc020592c <strlen+0xa>
ffffffffc0205938:	8082                	ret
    }
    return cnt;
}
ffffffffc020593a:	8082                	ret

ffffffffc020593c <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc020593c:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc020593e:	e589                	bnez	a1,ffffffffc0205948 <strnlen+0xc>
ffffffffc0205940:	a811                	j	ffffffffc0205954 <strnlen+0x18>
        cnt ++;
ffffffffc0205942:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205944:	00f58863          	beq	a1,a5,ffffffffc0205954 <strnlen+0x18>
ffffffffc0205948:	00f50733          	add	a4,a0,a5
ffffffffc020594c:	00074703          	lbu	a4,0(a4)
ffffffffc0205950:	fb6d                	bnez	a4,ffffffffc0205942 <strnlen+0x6>
ffffffffc0205952:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0205954:	852e                	mv	a0,a1
ffffffffc0205956:	8082                	ret

ffffffffc0205958 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0205958:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc020595a:	0005c703          	lbu	a4,0(a1)
ffffffffc020595e:	0785                	addi	a5,a5,1
ffffffffc0205960:	0585                	addi	a1,a1,1
ffffffffc0205962:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0205966:	fb75                	bnez	a4,ffffffffc020595a <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205968:	8082                	ret

ffffffffc020596a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020596a:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020596e:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205972:	cb89                	beqz	a5,ffffffffc0205984 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0205974:	0505                	addi	a0,a0,1
ffffffffc0205976:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205978:	fee789e3          	beq	a5,a4,ffffffffc020596a <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020597c:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205980:	9d19                	subw	a0,a0,a4
ffffffffc0205982:	8082                	ret
ffffffffc0205984:	4501                	li	a0,0
ffffffffc0205986:	bfed                	j	ffffffffc0205980 <strcmp+0x16>

ffffffffc0205988 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205988:	c20d                	beqz	a2,ffffffffc02059aa <strncmp+0x22>
ffffffffc020598a:	962e                	add	a2,a2,a1
ffffffffc020598c:	a031                	j	ffffffffc0205998 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc020598e:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205990:	00e79a63          	bne	a5,a4,ffffffffc02059a4 <strncmp+0x1c>
ffffffffc0205994:	00b60b63          	beq	a2,a1,ffffffffc02059aa <strncmp+0x22>
ffffffffc0205998:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc020599c:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020599e:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02059a2:	f7f5                	bnez	a5,ffffffffc020598e <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059a4:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02059a8:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02059aa:	4501                	li	a0,0
ffffffffc02059ac:	8082                	ret

ffffffffc02059ae <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02059ae:	00054783          	lbu	a5,0(a0)
ffffffffc02059b2:	c799                	beqz	a5,ffffffffc02059c0 <strchr+0x12>
        if (*s == c) {
ffffffffc02059b4:	00f58763          	beq	a1,a5,ffffffffc02059c2 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02059b8:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02059bc:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02059be:	fbfd                	bnez	a5,ffffffffc02059b4 <strchr+0x6>
    }
    return NULL;
ffffffffc02059c0:	4501                	li	a0,0
}
ffffffffc02059c2:	8082                	ret

ffffffffc02059c4 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02059c4:	ca01                	beqz	a2,ffffffffc02059d4 <memset+0x10>
ffffffffc02059c6:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02059c8:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02059ca:	0785                	addi	a5,a5,1
ffffffffc02059cc:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02059d0:	fec79de3          	bne	a5,a2,ffffffffc02059ca <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02059d4:	8082                	ret

ffffffffc02059d6 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02059d6:	ca19                	beqz	a2,ffffffffc02059ec <memcpy+0x16>
ffffffffc02059d8:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02059da:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02059dc:	0005c703          	lbu	a4,0(a1)
ffffffffc02059e0:	0585                	addi	a1,a1,1
ffffffffc02059e2:	0785                	addi	a5,a5,1
ffffffffc02059e4:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02059e8:	fec59ae3          	bne	a1,a2,ffffffffc02059dc <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc02059ec:	8082                	ret
