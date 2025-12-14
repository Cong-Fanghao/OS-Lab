
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
ffffffffc0200056:	fea60613          	addi	a2,a2,-22 # ffffffffc02b503c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	678050ef          	jal	ra,ffffffffc02056da <memset>
    dtb_init();
ffffffffc0200066:	598000ef          	jal	ra,ffffffffc02005fe <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	522000ef          	jal	ra,ffffffffc020058c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	69a58593          	addi	a1,a1,1690 # ffffffffc0205708 <etext+0x4>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	6b250513          	addi	a0,a0,1714 # ffffffffc0205728 <etext+0x24>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	19a000ef          	jal	ra,ffffffffc020021c <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	6b0020ef          	jal	ra,ffffffffc0202736 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	131000ef          	jal	ra,ffffffffc02009ba <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	12f000ef          	jal	ra,ffffffffc02009bc <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	1ad030ef          	jal	ra,ffffffffc0203a3e <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	597040ef          	jal	ra,ffffffffc0204e2c <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	4a0000ef          	jal	ra,ffffffffc020053a <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	111000ef          	jal	ra,ffffffffc02009ae <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	723040ef          	jal	ra,ffffffffc0204fc4 <cpu_idle>

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
ffffffffc02000bc:	00005517          	auipc	a0,0x5
ffffffffc02000c0:	67450513          	addi	a0,a0,1652 # ffffffffc0205730 <etext+0x2c>
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
ffffffffc0200188:	12e050ef          	jal	ra,ffffffffc02052b6 <vprintfmt>
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
ffffffffc02001be:	0f8050ef          	jal	ra,ffffffffc02052b6 <vprintfmt>
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
ffffffffc020021e:	00005517          	auipc	a0,0x5
ffffffffc0200222:	51a50513          	addi	a0,a0,1306 # ffffffffc0205738 <etext+0x34>
{
ffffffffc0200226:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200228:	f6dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020022c:	00000597          	auipc	a1,0x0
ffffffffc0200230:	e1e58593          	addi	a1,a1,-482 # ffffffffc020004a <kern_init>
ffffffffc0200234:	00005517          	auipc	a0,0x5
ffffffffc0200238:	52450513          	addi	a0,a0,1316 # ffffffffc0205758 <etext+0x54>
ffffffffc020023c:	f59ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200240:	00005597          	auipc	a1,0x5
ffffffffc0200244:	4c458593          	addi	a1,a1,1220 # ffffffffc0205704 <etext>
ffffffffc0200248:	00005517          	auipc	a0,0x5
ffffffffc020024c:	53050513          	addi	a0,a0,1328 # ffffffffc0205778 <etext+0x74>
ffffffffc0200250:	f45ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200254:	000b1597          	auipc	a1,0xb1
ffffffffc0200258:	94458593          	addi	a1,a1,-1724 # ffffffffc02b0b98 <buf>
ffffffffc020025c:	00005517          	auipc	a0,0x5
ffffffffc0200260:	53c50513          	addi	a0,a0,1340 # ffffffffc0205798 <etext+0x94>
ffffffffc0200264:	f31ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200268:	000b5597          	auipc	a1,0xb5
ffffffffc020026c:	dd458593          	addi	a1,a1,-556 # ffffffffc02b503c <end>
ffffffffc0200270:	00005517          	auipc	a0,0x5
ffffffffc0200274:	54850513          	addi	a0,a0,1352 # ffffffffc02057b8 <etext+0xb4>
ffffffffc0200278:	f1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020027c:	000b5597          	auipc	a1,0xb5
ffffffffc0200280:	1bf58593          	addi	a1,a1,447 # ffffffffc02b543b <end+0x3ff>
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
ffffffffc020029e:	00005517          	auipc	a0,0x5
ffffffffc02002a2:	53a50513          	addi	a0,a0,1338 # ffffffffc02057d8 <etext+0xd4>
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
ffffffffc02002ac:	00005617          	auipc	a2,0x5
ffffffffc02002b0:	55c60613          	addi	a2,a2,1372 # ffffffffc0205808 <etext+0x104>
ffffffffc02002b4:	04f00593          	li	a1,79
ffffffffc02002b8:	00005517          	auipc	a0,0x5
ffffffffc02002bc:	56850513          	addi	a0,a0,1384 # ffffffffc0205820 <etext+0x11c>
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
ffffffffc02002c8:	00005617          	auipc	a2,0x5
ffffffffc02002cc:	57060613          	addi	a2,a2,1392 # ffffffffc0205838 <etext+0x134>
ffffffffc02002d0:	00005597          	auipc	a1,0x5
ffffffffc02002d4:	58858593          	addi	a1,a1,1416 # ffffffffc0205858 <etext+0x154>
ffffffffc02002d8:	00005517          	auipc	a0,0x5
ffffffffc02002dc:	58850513          	addi	a0,a0,1416 # ffffffffc0205860 <etext+0x15c>
{
ffffffffc02002e0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e2:	eb3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002e6:	00005617          	auipc	a2,0x5
ffffffffc02002ea:	58a60613          	addi	a2,a2,1418 # ffffffffc0205870 <etext+0x16c>
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	5aa58593          	addi	a1,a1,1450 # ffffffffc0205898 <etext+0x194>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	56a50513          	addi	a0,a0,1386 # ffffffffc0205860 <etext+0x15c>
ffffffffc02002fe:	e97ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200302:	00005617          	auipc	a2,0x5
ffffffffc0200306:	5a660613          	addi	a2,a2,1446 # ffffffffc02058a8 <etext+0x1a4>
ffffffffc020030a:	00005597          	auipc	a1,0x5
ffffffffc020030e:	5be58593          	addi	a1,a1,1470 # ffffffffc02058c8 <etext+0x1c4>
ffffffffc0200312:	00005517          	auipc	a0,0x5
ffffffffc0200316:	54e50513          	addi	a0,a0,1358 # ffffffffc0205860 <etext+0x15c>
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
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	58c50513          	addi	a0,a0,1420 # ffffffffc02058d8 <etext+0x1d4>
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
ffffffffc020036e:	00005517          	auipc	a0,0x5
ffffffffc0200372:	59250513          	addi	a0,a0,1426 # ffffffffc0205900 <etext+0x1fc>
ffffffffc0200376:	e1fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL)
ffffffffc020037a:	000b8563          	beqz	s7,ffffffffc0200384 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020037e:	855e                	mv	a0,s7
ffffffffc0200380:	025000ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
ffffffffc0200384:	00005c17          	auipc	s8,0x5
ffffffffc0200388:	5ecc0c13          	addi	s8,s8,1516 # ffffffffc0205970 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020038c:	00005917          	auipc	s2,0x5
ffffffffc0200390:	59c90913          	addi	s2,s2,1436 # ffffffffc0205928 <etext+0x224>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200394:	00005497          	auipc	s1,0x5
ffffffffc0200398:	59c48493          	addi	s1,s1,1436 # ffffffffc0205930 <etext+0x22c>
        if (argc == MAXARGS - 1)
ffffffffc020039c:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020039e:	00005b17          	auipc	s6,0x5
ffffffffc02003a2:	59ab0b13          	addi	s6,s6,1434 # ffffffffc0205938 <etext+0x234>
        argv[argc++] = buf;
ffffffffc02003a6:	00005a17          	auipc	s4,0x5
ffffffffc02003aa:	4b2a0a13          	addi	s4,s4,1202 # ffffffffc0205858 <etext+0x154>
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
ffffffffc02003c8:	00005d17          	auipc	s10,0x5
ffffffffc02003cc:	5a8d0d13          	addi	s10,s10,1448 # ffffffffc0205970 <commands>
        argv[argc++] = buf;
ffffffffc02003d0:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc02003d2:	4401                	li	s0,0
ffffffffc02003d4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc02003d6:	2aa050ef          	jal	ra,ffffffffc0205680 <strcmp>
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
ffffffffc02003ea:	296050ef          	jal	ra,ffffffffc0205680 <strcmp>
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
ffffffffc0200428:	29c050ef          	jal	ra,ffffffffc02056c4 <strchr>
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
ffffffffc0200466:	25e050ef          	jal	ra,ffffffffc02056c4 <strchr>
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
ffffffffc0200484:	4d850513          	addi	a0,a0,1240 # ffffffffc0205958 <etext+0x254>
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
ffffffffc02004c0:	4fc50513          	addi	a0,a0,1276 # ffffffffc02059b8 <commands+0x48>
    va_start(ap, fmt);
ffffffffc02004c4:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc02004c6:	ccfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02004ca:	65a2                	ld	a1,8(sp)
ffffffffc02004cc:	8522                	mv	a0,s0
ffffffffc02004ce:	ca7ff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc02004d2:	00006517          	auipc	a0,0x6
ffffffffc02004d6:	5ee50513          	addi	a0,a0,1518 # ffffffffc0206ac0 <default_pmm_manager+0x578>
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
ffffffffc020050a:	4d250513          	addi	a0,a0,1234 # ffffffffc02059d8 <commands+0x68>
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
ffffffffc0200526:	00006517          	auipc	a0,0x6
ffffffffc020052a:	59a50513          	addi	a0,a0,1434 # ffffffffc0206ac0 <default_pmm_manager+0x578>
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
ffffffffc0200564:	49850513          	addi	a0,a0,1176 # ffffffffc02059f8 <commands+0x88>
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
ffffffffc0200604:	41850513          	addi	a0,a0,1048 # ffffffffc0205a18 <commands+0xa8>
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
ffffffffc0200632:	3fa50513          	addi	a0,a0,1018 # ffffffffc0205a28 <commands+0xb8>
ffffffffc0200636:	b5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc020063a:	0000b417          	auipc	s0,0xb
ffffffffc020063e:	9ce40413          	addi	s0,s0,-1586 # ffffffffc020b008 <boot_dtb>
ffffffffc0200642:	600c                	ld	a1,0(s0)
ffffffffc0200644:	00005517          	auipc	a0,0x5
ffffffffc0200648:	3f450513          	addi	a0,a0,1012 # ffffffffc0205a38 <commands+0xc8>
ffffffffc020064c:	b49ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200650:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200654:	00005517          	auipc	a0,0x5
ffffffffc0200658:	3fc50513          	addi	a0,a0,1020 # ffffffffc0205a50 <commands+0xe0>
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
ffffffffc020069c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe2aeb1>
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
ffffffffc0200712:	39290913          	addi	s2,s2,914 # ffffffffc0205aa0 <commands+0x130>
ffffffffc0200716:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200718:	4d91                	li	s11,4
ffffffffc020071a:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020071c:	00005497          	auipc	s1,0x5
ffffffffc0200720:	37c48493          	addi	s1,s1,892 # ffffffffc0205a98 <commands+0x128>
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
ffffffffc0200774:	3a850513          	addi	a0,a0,936 # ffffffffc0205b18 <commands+0x1a8>
ffffffffc0200778:	a1dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc020077c:	00005517          	auipc	a0,0x5
ffffffffc0200780:	3d450513          	addi	a0,a0,980 # ffffffffc0205b50 <commands+0x1e0>
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
ffffffffc02007c0:	2b450513          	addi	a0,a0,692 # ffffffffc0205a70 <commands+0x100>
}
ffffffffc02007c4:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02007c6:	b2f9                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc02007c8:	8556                	mv	a0,s5
ffffffffc02007ca:	66f040ef          	jal	ra,ffffffffc0205638 <strlen>
ffffffffc02007ce:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d0:	4619                	li	a2,6
ffffffffc02007d2:	85a6                	mv	a1,s1
ffffffffc02007d4:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc02007d6:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02007d8:	6c7040ef          	jal	ra,ffffffffc020569e <strncmp>
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
ffffffffc020086e:	613040ef          	jal	ra,ffffffffc0205680 <strcmp>
ffffffffc0200872:	66a2                	ld	a3,8(sp)
ffffffffc0200874:	f94d                	bnez	a0,ffffffffc0200826 <dtb_init+0x228>
ffffffffc0200876:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200826 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc020087a:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc020087e:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200882:	00005517          	auipc	a0,0x5
ffffffffc0200886:	22650513          	addi	a0,a0,550 # ffffffffc0205aa8 <commands+0x138>
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
ffffffffc0200954:	17850513          	addi	a0,a0,376 # ffffffffc0205ac8 <commands+0x158>
ffffffffc0200958:	83dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020095c:	014b5613          	srli	a2,s6,0x14
ffffffffc0200960:	85da                	mv	a1,s6
ffffffffc0200962:	00005517          	auipc	a0,0x5
ffffffffc0200966:	17e50513          	addi	a0,a0,382 # ffffffffc0205ae0 <commands+0x170>
ffffffffc020096a:	82bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc020096e:	008b05b3          	add	a1,s6,s0
ffffffffc0200972:	15fd                	addi	a1,a1,-1
ffffffffc0200974:	00005517          	auipc	a0,0x5
ffffffffc0200978:	18c50513          	addi	a0,a0,396 # ffffffffc0205b00 <commands+0x190>
ffffffffc020097c:	819ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc0200980:	00005517          	auipc	a0,0x5
ffffffffc0200984:	1d050513          	addi	a0,a0,464 # ffffffffc0205b50 <commands+0x1e0>
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
ffffffffc02009c4:	4a478793          	addi	a5,a5,1188 # ffffffffc0200e64 <__alltraps>
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
ffffffffc02009e2:	18a50513          	addi	a0,a0,394 # ffffffffc0205b68 <commands+0x1f8>
{
ffffffffc02009e6:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e8:	facff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009ec:	640c                	ld	a1,8(s0)
ffffffffc02009ee:	00005517          	auipc	a0,0x5
ffffffffc02009f2:	19250513          	addi	a0,a0,402 # ffffffffc0205b80 <commands+0x210>
ffffffffc02009f6:	f9eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fa:	680c                	ld	a1,16(s0)
ffffffffc02009fc:	00005517          	auipc	a0,0x5
ffffffffc0200a00:	19c50513          	addi	a0,a0,412 # ffffffffc0205b98 <commands+0x228>
ffffffffc0200a04:	f90ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a08:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0a:	00005517          	auipc	a0,0x5
ffffffffc0200a0e:	1a650513          	addi	a0,a0,422 # ffffffffc0205bb0 <commands+0x240>
ffffffffc0200a12:	f82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a16:	700c                	ld	a1,32(s0)
ffffffffc0200a18:	00005517          	auipc	a0,0x5
ffffffffc0200a1c:	1b050513          	addi	a0,a0,432 # ffffffffc0205bc8 <commands+0x258>
ffffffffc0200a20:	f74ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a24:	740c                	ld	a1,40(s0)
ffffffffc0200a26:	00005517          	auipc	a0,0x5
ffffffffc0200a2a:	1ba50513          	addi	a0,a0,442 # ffffffffc0205be0 <commands+0x270>
ffffffffc0200a2e:	f66ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a32:	780c                	ld	a1,48(s0)
ffffffffc0200a34:	00005517          	auipc	a0,0x5
ffffffffc0200a38:	1c450513          	addi	a0,a0,452 # ffffffffc0205bf8 <commands+0x288>
ffffffffc0200a3c:	f58ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a40:	7c0c                	ld	a1,56(s0)
ffffffffc0200a42:	00005517          	auipc	a0,0x5
ffffffffc0200a46:	1ce50513          	addi	a0,a0,462 # ffffffffc0205c10 <commands+0x2a0>
ffffffffc0200a4a:	f4aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a4e:	602c                	ld	a1,64(s0)
ffffffffc0200a50:	00005517          	auipc	a0,0x5
ffffffffc0200a54:	1d850513          	addi	a0,a0,472 # ffffffffc0205c28 <commands+0x2b8>
ffffffffc0200a58:	f3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a5c:	642c                	ld	a1,72(s0)
ffffffffc0200a5e:	00005517          	auipc	a0,0x5
ffffffffc0200a62:	1e250513          	addi	a0,a0,482 # ffffffffc0205c40 <commands+0x2d0>
ffffffffc0200a66:	f2eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6a:	682c                	ld	a1,80(s0)
ffffffffc0200a6c:	00005517          	auipc	a0,0x5
ffffffffc0200a70:	1ec50513          	addi	a0,a0,492 # ffffffffc0205c58 <commands+0x2e8>
ffffffffc0200a74:	f20ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a78:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7a:	00005517          	auipc	a0,0x5
ffffffffc0200a7e:	1f650513          	addi	a0,a0,502 # ffffffffc0205c70 <commands+0x300>
ffffffffc0200a82:	f12ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a86:	702c                	ld	a1,96(s0)
ffffffffc0200a88:	00005517          	auipc	a0,0x5
ffffffffc0200a8c:	20050513          	addi	a0,a0,512 # ffffffffc0205c88 <commands+0x318>
ffffffffc0200a90:	f04ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a94:	742c                	ld	a1,104(s0)
ffffffffc0200a96:	00005517          	auipc	a0,0x5
ffffffffc0200a9a:	20a50513          	addi	a0,a0,522 # ffffffffc0205ca0 <commands+0x330>
ffffffffc0200a9e:	ef6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa2:	782c                	ld	a1,112(s0)
ffffffffc0200aa4:	00005517          	auipc	a0,0x5
ffffffffc0200aa8:	21450513          	addi	a0,a0,532 # ffffffffc0205cb8 <commands+0x348>
ffffffffc0200aac:	ee8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab0:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab2:	00005517          	auipc	a0,0x5
ffffffffc0200ab6:	21e50513          	addi	a0,a0,542 # ffffffffc0205cd0 <commands+0x360>
ffffffffc0200aba:	edaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200abe:	604c                	ld	a1,128(s0)
ffffffffc0200ac0:	00005517          	auipc	a0,0x5
ffffffffc0200ac4:	22850513          	addi	a0,a0,552 # ffffffffc0205ce8 <commands+0x378>
ffffffffc0200ac8:	eccff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200acc:	644c                	ld	a1,136(s0)
ffffffffc0200ace:	00005517          	auipc	a0,0x5
ffffffffc0200ad2:	23250513          	addi	a0,a0,562 # ffffffffc0205d00 <commands+0x390>
ffffffffc0200ad6:	ebeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ada:	684c                	ld	a1,144(s0)
ffffffffc0200adc:	00005517          	auipc	a0,0x5
ffffffffc0200ae0:	23c50513          	addi	a0,a0,572 # ffffffffc0205d18 <commands+0x3a8>
ffffffffc0200ae4:	eb0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200ae8:	6c4c                	ld	a1,152(s0)
ffffffffc0200aea:	00005517          	auipc	a0,0x5
ffffffffc0200aee:	24650513          	addi	a0,a0,582 # ffffffffc0205d30 <commands+0x3c0>
ffffffffc0200af2:	ea2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200af6:	704c                	ld	a1,160(s0)
ffffffffc0200af8:	00005517          	auipc	a0,0x5
ffffffffc0200afc:	25050513          	addi	a0,a0,592 # ffffffffc0205d48 <commands+0x3d8>
ffffffffc0200b00:	e94ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b04:	744c                	ld	a1,168(s0)
ffffffffc0200b06:	00005517          	auipc	a0,0x5
ffffffffc0200b0a:	25a50513          	addi	a0,a0,602 # ffffffffc0205d60 <commands+0x3f0>
ffffffffc0200b0e:	e86ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b12:	784c                	ld	a1,176(s0)
ffffffffc0200b14:	00005517          	auipc	a0,0x5
ffffffffc0200b18:	26450513          	addi	a0,a0,612 # ffffffffc0205d78 <commands+0x408>
ffffffffc0200b1c:	e78ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b20:	7c4c                	ld	a1,184(s0)
ffffffffc0200b22:	00005517          	auipc	a0,0x5
ffffffffc0200b26:	26e50513          	addi	a0,a0,622 # ffffffffc0205d90 <commands+0x420>
ffffffffc0200b2a:	e6aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b2e:	606c                	ld	a1,192(s0)
ffffffffc0200b30:	00005517          	auipc	a0,0x5
ffffffffc0200b34:	27850513          	addi	a0,a0,632 # ffffffffc0205da8 <commands+0x438>
ffffffffc0200b38:	e5cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b3c:	646c                	ld	a1,200(s0)
ffffffffc0200b3e:	00005517          	auipc	a0,0x5
ffffffffc0200b42:	28250513          	addi	a0,a0,642 # ffffffffc0205dc0 <commands+0x450>
ffffffffc0200b46:	e4eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4a:	686c                	ld	a1,208(s0)
ffffffffc0200b4c:	00005517          	auipc	a0,0x5
ffffffffc0200b50:	28c50513          	addi	a0,a0,652 # ffffffffc0205dd8 <commands+0x468>
ffffffffc0200b54:	e40ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b58:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5a:	00005517          	auipc	a0,0x5
ffffffffc0200b5e:	29650513          	addi	a0,a0,662 # ffffffffc0205df0 <commands+0x480>
ffffffffc0200b62:	e32ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b66:	706c                	ld	a1,224(s0)
ffffffffc0200b68:	00005517          	auipc	a0,0x5
ffffffffc0200b6c:	2a050513          	addi	a0,a0,672 # ffffffffc0205e08 <commands+0x498>
ffffffffc0200b70:	e24ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b74:	746c                	ld	a1,232(s0)
ffffffffc0200b76:	00005517          	auipc	a0,0x5
ffffffffc0200b7a:	2aa50513          	addi	a0,a0,682 # ffffffffc0205e20 <commands+0x4b0>
ffffffffc0200b7e:	e16ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b82:	786c                	ld	a1,240(s0)
ffffffffc0200b84:	00005517          	auipc	a0,0x5
ffffffffc0200b88:	2b450513          	addi	a0,a0,692 # ffffffffc0205e38 <commands+0x4c8>
ffffffffc0200b8c:	e08ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b90:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b92:	6402                	ld	s0,0(sp)
ffffffffc0200b94:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b96:	00005517          	auipc	a0,0x5
ffffffffc0200b9a:	2ba50513          	addi	a0,a0,698 # ffffffffc0205e50 <commands+0x4e0>
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
ffffffffc0200bb0:	2bc50513          	addi	a0,a0,700 # ffffffffc0205e68 <commands+0x4f8>
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
ffffffffc0200bc8:	2bc50513          	addi	a0,a0,700 # ffffffffc0205e80 <commands+0x510>
ffffffffc0200bcc:	dc8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd0:	10843583          	ld	a1,264(s0)
ffffffffc0200bd4:	00005517          	auipc	a0,0x5
ffffffffc0200bd8:	2c450513          	addi	a0,a0,708 # ffffffffc0205e98 <commands+0x528>
ffffffffc0200bdc:	db8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be0:	11043583          	ld	a1,272(s0)
ffffffffc0200be4:	00005517          	auipc	a0,0x5
ffffffffc0200be8:	2cc50513          	addi	a0,a0,716 # ffffffffc0205eb0 <commands+0x540>
ffffffffc0200bec:	da8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf0:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf4:	6402                	ld	s0,0(sp)
ffffffffc0200bf6:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf8:	00005517          	auipc	a0,0x5
ffffffffc0200bfc:	2c850513          	addi	a0,a0,712 # ffffffffc0205ec0 <commands+0x550>
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
ffffffffc0200c18:	3a470713          	addi	a4,a4,932 # ffffffffc0205fb8 <commands+0x648>
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
ffffffffc0200c2a:	31250513          	addi	a0,a0,786 # ffffffffc0205f38 <commands+0x5c8>
ffffffffc0200c2e:	d66ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c32:	00005517          	auipc	a0,0x5
ffffffffc0200c36:	2e650513          	addi	a0,a0,742 # ffffffffc0205f18 <commands+0x5a8>
ffffffffc0200c3a:	d5aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c3e:	00005517          	auipc	a0,0x5
ffffffffc0200c42:	29a50513          	addi	a0,a0,666 # ffffffffc0205ed8 <commands+0x568>
ffffffffc0200c46:	d4eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4a:	00005517          	auipc	a0,0x5
ffffffffc0200c4e:	2ae50513          	addi	a0,a0,686 # ffffffffc0205ef8 <commands+0x588>
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
ffffffffc0200c7c:	3a87b783          	ld	a5,936(a5) # ffffffffc02b5020 <current>
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
ffffffffc0200c90:	30c50513          	addi	a0,a0,780 # ffffffffc0205f98 <commands+0x628>
ffffffffc0200c94:	d00ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c98:	b731                	j	ffffffffc0200ba4 <print_trapframe>
            assert(current != NULL);
ffffffffc0200c9a:	00005697          	auipc	a3,0x5
ffffffffc0200c9e:	2be68693          	addi	a3,a3,702 # ffffffffc0205f58 <commands+0x5e8>
ffffffffc0200ca2:	00005617          	auipc	a2,0x5
ffffffffc0200ca6:	2c660613          	addi	a2,a2,710 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0200caa:	08200593          	li	a1,130
ffffffffc0200cae:	00005517          	auipc	a0,0x5
ffffffffc0200cb2:	2d250513          	addi	a0,a0,722 # ffffffffc0205f80 <commands+0x610>
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
ffffffffc0200cbe:	1141                	addi	sp,sp,-16
ffffffffc0200cc0:	e022                	sd	s0,0(sp)
ffffffffc0200cc2:	e406                	sd	ra,8(sp)
ffffffffc0200cc4:	473d                	li	a4,15
ffffffffc0200cc6:	842a                	mv	s0,a0
ffffffffc0200cc8:	0cf76463          	bltu	a4,a5,ffffffffc0200d90 <exception_handler+0xd6>
ffffffffc0200ccc:	00005717          	auipc	a4,0x5
ffffffffc0200cd0:	49470713          	addi	a4,a4,1172 # ffffffffc0206160 <commands+0x7f0>
ffffffffc0200cd4:	078a                	slli	a5,a5,0x2
ffffffffc0200cd6:	97ba                	add	a5,a5,a4
ffffffffc0200cd8:	439c                	lw	a5,0(a5)
ffffffffc0200cda:	97ba                	add	a5,a5,a4
ffffffffc0200cdc:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cde:	00005517          	auipc	a0,0x5
ffffffffc0200ce2:	3da50513          	addi	a0,a0,986 # ffffffffc02060b8 <commands+0x748>
ffffffffc0200ce6:	caeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        tf->epc += 4;
ffffffffc0200cea:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cee:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200cf0:	0791                	addi	a5,a5,4
ffffffffc0200cf2:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cf6:	6402                	ld	s0,0(sp)
ffffffffc0200cf8:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200cfa:	4ba0406f          	j	ffffffffc02051b4 <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200cfe:	00005517          	auipc	a0,0x5
ffffffffc0200d02:	3da50513          	addi	a0,a0,986 # ffffffffc02060d8 <commands+0x768>
}
ffffffffc0200d06:	6402                	ld	s0,0(sp)
ffffffffc0200d08:	60a2                	ld	ra,8(sp)
ffffffffc0200d0a:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200d0c:	c88ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200d10:	00005517          	auipc	a0,0x5
ffffffffc0200d14:	3e850513          	addi	a0,a0,1000 # ffffffffc02060f8 <commands+0x788>
ffffffffc0200d18:	b7fd                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200d1a:	00005517          	auipc	a0,0x5
ffffffffc0200d1e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0206118 <commands+0x7a8>
ffffffffc0200d22:	b7d5                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d24:	00005517          	auipc	a0,0x5
ffffffffc0200d28:	40c50513          	addi	a0,a0,1036 # ffffffffc0206130 <commands+0x7c0>
ffffffffc0200d2c:	bfe9                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d2e:	00005517          	auipc	a0,0x5
ffffffffc0200d32:	41a50513          	addi	a0,a0,1050 # ffffffffc0206148 <commands+0x7d8>
ffffffffc0200d36:	bfc1                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d38:	00005517          	auipc	a0,0x5
ffffffffc0200d3c:	2b050513          	addi	a0,a0,688 # ffffffffc0205fe8 <commands+0x678>
ffffffffc0200d40:	b7d9                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d42:	00005517          	auipc	a0,0x5
ffffffffc0200d46:	2c650513          	addi	a0,a0,710 # ffffffffc0206008 <commands+0x698>
ffffffffc0200d4a:	bf75                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d4c:	00005517          	auipc	a0,0x5
ffffffffc0200d50:	2dc50513          	addi	a0,a0,732 # ffffffffc0206028 <commands+0x6b8>
ffffffffc0200d54:	bf4d                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d56:	00005517          	auipc	a0,0x5
ffffffffc0200d5a:	2ea50513          	addi	a0,a0,746 # ffffffffc0206040 <commands+0x6d0>
ffffffffc0200d5e:	c36ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d62:	6458                	ld	a4,136(s0)
ffffffffc0200d64:	47a9                	li	a5,10
ffffffffc0200d66:	04f70663          	beq	a4,a5,ffffffffc0200db2 <exception_handler+0xf8>
}
ffffffffc0200d6a:	60a2                	ld	ra,8(sp)
ffffffffc0200d6c:	6402                	ld	s0,0(sp)
ffffffffc0200d6e:	0141                	addi	sp,sp,16
ffffffffc0200d70:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200d72:	00005517          	auipc	a0,0x5
ffffffffc0200d76:	2de50513          	addi	a0,a0,734 # ffffffffc0206050 <commands+0x6e0>
ffffffffc0200d7a:	b771                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d7c:	00005517          	auipc	a0,0x5
ffffffffc0200d80:	2f450513          	addi	a0,a0,756 # ffffffffc0206070 <commands+0x700>
ffffffffc0200d84:	b749                	j	ffffffffc0200d06 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d86:	00005517          	auipc	a0,0x5
ffffffffc0200d8a:	31a50513          	addi	a0,a0,794 # ffffffffc02060a0 <commands+0x730>
ffffffffc0200d8e:	bfa5                	j	ffffffffc0200d06 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d90:	8522                	mv	a0,s0
}
ffffffffc0200d92:	6402                	ld	s0,0(sp)
ffffffffc0200d94:	60a2                	ld	ra,8(sp)
ffffffffc0200d96:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200d98:	b531                	j	ffffffffc0200ba4 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d9a:	00005617          	auipc	a2,0x5
ffffffffc0200d9e:	2ee60613          	addi	a2,a2,750 # ffffffffc0206088 <commands+0x718>
ffffffffc0200da2:	0d300593          	li	a1,211
ffffffffc0200da6:	00005517          	auipc	a0,0x5
ffffffffc0200daa:	1da50513          	addi	a0,a0,474 # ffffffffc0205f80 <commands+0x610>
ffffffffc0200dae:	ee0ff0ef          	jal	ra,ffffffffc020048e <__panic>
            tf->epc += 4;
ffffffffc0200db2:	10843783          	ld	a5,264(s0)
ffffffffc0200db6:	0791                	addi	a5,a5,4
ffffffffc0200db8:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200dbc:	3f8040ef          	jal	ra,ffffffffc02051b4 <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dc0:	000b4797          	auipc	a5,0xb4
ffffffffc0200dc4:	2607b783          	ld	a5,608(a5) # ffffffffc02b5020 <current>
ffffffffc0200dc8:	6b9c                	ld	a5,16(a5)
ffffffffc0200dca:	8522                	mv	a0,s0
}
ffffffffc0200dcc:	6402                	ld	s0,0(sp)
ffffffffc0200dce:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dd0:	6589                	lui	a1,0x2
ffffffffc0200dd2:	95be                	add	a1,a1,a5
}
ffffffffc0200dd4:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200dd6:	aab1                	j	ffffffffc0200f32 <kernel_execve_ret>

ffffffffc0200dd8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200dd8:	1101                	addi	sp,sp,-32
ffffffffc0200dda:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200ddc:	000b4417          	auipc	s0,0xb4
ffffffffc0200de0:	24440413          	addi	s0,s0,580 # ffffffffc02b5020 <current>
ffffffffc0200de4:	6018                	ld	a4,0(s0)
{
ffffffffc0200de6:	ec06                	sd	ra,24(sp)
ffffffffc0200de8:	e426                	sd	s1,8(sp)
ffffffffc0200dea:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dec:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200df0:	cf1d                	beqz	a4,ffffffffc0200e2e <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200df2:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200df6:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200dfa:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dfc:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e00:	0206c463          	bltz	a3,ffffffffc0200e28 <trap+0x50>
        exception_handler(tf);
ffffffffc0200e04:	eb7ff0ef          	jal	ra,ffffffffc0200cba <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200e08:	601c                	ld	a5,0(s0)
ffffffffc0200e0a:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200e0e:	e499                	bnez	s1,ffffffffc0200e1c <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200e10:	0b07a703          	lw	a4,176(a5)
ffffffffc0200e14:	8b05                	andi	a4,a4,1
ffffffffc0200e16:	e329                	bnez	a4,ffffffffc0200e58 <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200e18:	6f9c                	ld	a5,24(a5)
ffffffffc0200e1a:	eb85                	bnez	a5,ffffffffc0200e4a <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200e1c:	60e2                	ld	ra,24(sp)
ffffffffc0200e1e:	6442                	ld	s0,16(sp)
ffffffffc0200e20:	64a2                	ld	s1,8(sp)
ffffffffc0200e22:	6902                	ld	s2,0(sp)
ffffffffc0200e24:	6105                	addi	sp,sp,32
ffffffffc0200e26:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e28:	ddfff0ef          	jal	ra,ffffffffc0200c06 <interrupt_handler>
ffffffffc0200e2c:	bff1                	j	ffffffffc0200e08 <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e2e:	0006c863          	bltz	a3,ffffffffc0200e3e <trap+0x66>
}
ffffffffc0200e32:	6442                	ld	s0,16(sp)
ffffffffc0200e34:	60e2                	ld	ra,24(sp)
ffffffffc0200e36:	64a2                	ld	s1,8(sp)
ffffffffc0200e38:	6902                	ld	s2,0(sp)
ffffffffc0200e3a:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e3c:	bdbd                	j	ffffffffc0200cba <exception_handler>
}
ffffffffc0200e3e:	6442                	ld	s0,16(sp)
ffffffffc0200e40:	60e2                	ld	ra,24(sp)
ffffffffc0200e42:	64a2                	ld	s1,8(sp)
ffffffffc0200e44:	6902                	ld	s2,0(sp)
ffffffffc0200e46:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e48:	bb7d                	j	ffffffffc0200c06 <interrupt_handler>
}
ffffffffc0200e4a:	6442                	ld	s0,16(sp)
ffffffffc0200e4c:	60e2                	ld	ra,24(sp)
ffffffffc0200e4e:	64a2                	ld	s1,8(sp)
ffffffffc0200e50:	6902                	ld	s2,0(sp)
ffffffffc0200e52:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e54:	2740406f          	j	ffffffffc02050c8 <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e58:	555d                	li	a0,-9
ffffffffc0200e5a:	5b4030ef          	jal	ra,ffffffffc020440e <do_exit>
            if (current->need_resched)
ffffffffc0200e5e:	601c                	ld	a5,0(s0)
ffffffffc0200e60:	bf65                	j	ffffffffc0200e18 <trap+0x40>
	...

ffffffffc0200e64 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e64:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e68:	00011463          	bnez	sp,ffffffffc0200e70 <__alltraps+0xc>
ffffffffc0200e6c:	14002173          	csrr	sp,sscratch
ffffffffc0200e70:	712d                	addi	sp,sp,-288
ffffffffc0200e72:	e002                	sd	zero,0(sp)
ffffffffc0200e74:	e406                	sd	ra,8(sp)
ffffffffc0200e76:	ec0e                	sd	gp,24(sp)
ffffffffc0200e78:	f012                	sd	tp,32(sp)
ffffffffc0200e7a:	f416                	sd	t0,40(sp)
ffffffffc0200e7c:	f81a                	sd	t1,48(sp)
ffffffffc0200e7e:	fc1e                	sd	t2,56(sp)
ffffffffc0200e80:	e0a2                	sd	s0,64(sp)
ffffffffc0200e82:	e4a6                	sd	s1,72(sp)
ffffffffc0200e84:	e8aa                	sd	a0,80(sp)
ffffffffc0200e86:	ecae                	sd	a1,88(sp)
ffffffffc0200e88:	f0b2                	sd	a2,96(sp)
ffffffffc0200e8a:	f4b6                	sd	a3,104(sp)
ffffffffc0200e8c:	f8ba                	sd	a4,112(sp)
ffffffffc0200e8e:	fcbe                	sd	a5,120(sp)
ffffffffc0200e90:	e142                	sd	a6,128(sp)
ffffffffc0200e92:	e546                	sd	a7,136(sp)
ffffffffc0200e94:	e94a                	sd	s2,144(sp)
ffffffffc0200e96:	ed4e                	sd	s3,152(sp)
ffffffffc0200e98:	f152                	sd	s4,160(sp)
ffffffffc0200e9a:	f556                	sd	s5,168(sp)
ffffffffc0200e9c:	f95a                	sd	s6,176(sp)
ffffffffc0200e9e:	fd5e                	sd	s7,184(sp)
ffffffffc0200ea0:	e1e2                	sd	s8,192(sp)
ffffffffc0200ea2:	e5e6                	sd	s9,200(sp)
ffffffffc0200ea4:	e9ea                	sd	s10,208(sp)
ffffffffc0200ea6:	edee                	sd	s11,216(sp)
ffffffffc0200ea8:	f1f2                	sd	t3,224(sp)
ffffffffc0200eaa:	f5f6                	sd	t4,232(sp)
ffffffffc0200eac:	f9fa                	sd	t5,240(sp)
ffffffffc0200eae:	fdfe                	sd	t6,248(sp)
ffffffffc0200eb0:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200eb4:	100024f3          	csrr	s1,sstatus
ffffffffc0200eb8:	14102973          	csrr	s2,sepc
ffffffffc0200ebc:	143029f3          	csrr	s3,stval
ffffffffc0200ec0:	14202a73          	csrr	s4,scause
ffffffffc0200ec4:	e822                	sd	s0,16(sp)
ffffffffc0200ec6:	e226                	sd	s1,256(sp)
ffffffffc0200ec8:	e64a                	sd	s2,264(sp)
ffffffffc0200eca:	ea4e                	sd	s3,272(sp)
ffffffffc0200ecc:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200ece:	850a                	mv	a0,sp
    jal trap
ffffffffc0200ed0:	f09ff0ef          	jal	ra,ffffffffc0200dd8 <trap>

ffffffffc0200ed4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200ed4:	6492                	ld	s1,256(sp)
ffffffffc0200ed6:	6932                	ld	s2,264(sp)
ffffffffc0200ed8:	1004f413          	andi	s0,s1,256
ffffffffc0200edc:	e401                	bnez	s0,ffffffffc0200ee4 <__trapret+0x10>
ffffffffc0200ede:	1200                	addi	s0,sp,288
ffffffffc0200ee0:	14041073          	csrw	sscratch,s0
ffffffffc0200ee4:	10049073          	csrw	sstatus,s1
ffffffffc0200ee8:	14191073          	csrw	sepc,s2
ffffffffc0200eec:	60a2                	ld	ra,8(sp)
ffffffffc0200eee:	61e2                	ld	gp,24(sp)
ffffffffc0200ef0:	7202                	ld	tp,32(sp)
ffffffffc0200ef2:	72a2                	ld	t0,40(sp)
ffffffffc0200ef4:	7342                	ld	t1,48(sp)
ffffffffc0200ef6:	73e2                	ld	t2,56(sp)
ffffffffc0200ef8:	6406                	ld	s0,64(sp)
ffffffffc0200efa:	64a6                	ld	s1,72(sp)
ffffffffc0200efc:	6546                	ld	a0,80(sp)
ffffffffc0200efe:	65e6                	ld	a1,88(sp)
ffffffffc0200f00:	7606                	ld	a2,96(sp)
ffffffffc0200f02:	76a6                	ld	a3,104(sp)
ffffffffc0200f04:	7746                	ld	a4,112(sp)
ffffffffc0200f06:	77e6                	ld	a5,120(sp)
ffffffffc0200f08:	680a                	ld	a6,128(sp)
ffffffffc0200f0a:	68aa                	ld	a7,136(sp)
ffffffffc0200f0c:	694a                	ld	s2,144(sp)
ffffffffc0200f0e:	69ea                	ld	s3,152(sp)
ffffffffc0200f10:	7a0a                	ld	s4,160(sp)
ffffffffc0200f12:	7aaa                	ld	s5,168(sp)
ffffffffc0200f14:	7b4a                	ld	s6,176(sp)
ffffffffc0200f16:	7bea                	ld	s7,184(sp)
ffffffffc0200f18:	6c0e                	ld	s8,192(sp)
ffffffffc0200f1a:	6cae                	ld	s9,200(sp)
ffffffffc0200f1c:	6d4e                	ld	s10,208(sp)
ffffffffc0200f1e:	6dee                	ld	s11,216(sp)
ffffffffc0200f20:	7e0e                	ld	t3,224(sp)
ffffffffc0200f22:	7eae                	ld	t4,232(sp)
ffffffffc0200f24:	7f4e                	ld	t5,240(sp)
ffffffffc0200f26:	7fee                	ld	t6,248(sp)
ffffffffc0200f28:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f2a:	10200073          	sret

ffffffffc0200f2e <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f2e:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f30:	b755                	j	ffffffffc0200ed4 <__trapret>

ffffffffc0200f32 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f32:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc8>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f36:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f3a:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f3e:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f42:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f46:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f4a:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f4e:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f52:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f56:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f58:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f5a:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f5c:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f5e:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f60:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f62:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f64:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f66:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f68:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f6a:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f6c:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f6e:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f70:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f72:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f74:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f76:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f78:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f7a:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f7c:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f7e:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f80:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f82:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f84:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f86:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f88:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f8a:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f8c:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f8e:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f90:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f92:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f94:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f96:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f98:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f9a:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200f9c:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200f9e:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200fa0:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200fa2:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200fa4:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200fa6:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200fa8:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200faa:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200fac:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200fae:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200fb0:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200fb2:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200fb4:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200fb6:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200fb8:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200fba:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200fbc:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200fbe:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fc0:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fc2:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fc4:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fc6:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fc8:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200fca:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fcc:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fce:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fd0:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fd2:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200fd4:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200fd6:	812e                	mv	sp,a1
ffffffffc0200fd8:	bdf5                	j	ffffffffc0200ed4 <__trapret>

ffffffffc0200fda <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200fda:	000b0797          	auipc	a5,0xb0
ffffffffc0200fde:	fbe78793          	addi	a5,a5,-66 # ffffffffc02b0f98 <free_area>
ffffffffc0200fe2:	e79c                	sd	a5,8(a5)
ffffffffc0200fe4:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200fe6:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200fea:	8082                	ret

ffffffffc0200fec <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc0200fec:	000b0517          	auipc	a0,0xb0
ffffffffc0200ff0:	fbc56503          	lwu	a0,-68(a0) # ffffffffc02b0fa8 <free_area+0x10>
ffffffffc0200ff4:	8082                	ret

ffffffffc0200ff6 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0200ff6:	715d                	addi	sp,sp,-80
ffffffffc0200ff8:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200ffa:	000b0417          	auipc	s0,0xb0
ffffffffc0200ffe:	f9e40413          	addi	s0,s0,-98 # ffffffffc02b0f98 <free_area>
ffffffffc0201002:	641c                	ld	a5,8(s0)
ffffffffc0201004:	e486                	sd	ra,72(sp)
ffffffffc0201006:	fc26                	sd	s1,56(sp)
ffffffffc0201008:	f84a                	sd	s2,48(sp)
ffffffffc020100a:	f44e                	sd	s3,40(sp)
ffffffffc020100c:	f052                	sd	s4,32(sp)
ffffffffc020100e:	ec56                	sd	s5,24(sp)
ffffffffc0201010:	e85a                	sd	s6,16(sp)
ffffffffc0201012:	e45e                	sd	s7,8(sp)
ffffffffc0201014:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0201016:	2a878d63          	beq	a5,s0,ffffffffc02012d0 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc020101a:	4481                	li	s1,0
ffffffffc020101c:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020101e:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0201022:	8b09                	andi	a4,a4,2
ffffffffc0201024:	2a070a63          	beqz	a4,ffffffffc02012d8 <default_check+0x2e2>
        count++, total += p->property;
ffffffffc0201028:	ff87a703          	lw	a4,-8(a5)
ffffffffc020102c:	679c                	ld	a5,8(a5)
ffffffffc020102e:	2905                	addiw	s2,s2,1
ffffffffc0201030:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0201032:	fe8796e3          	bne	a5,s0,ffffffffc020101e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0201036:	89a6                	mv	s3,s1
ffffffffc0201038:	6df000ef          	jal	ra,ffffffffc0201f16 <nr_free_pages>
ffffffffc020103c:	6f351e63          	bne	a0,s3,ffffffffc0201738 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201040:	4505                	li	a0,1
ffffffffc0201042:	657000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc0201046:	8aaa                	mv	s5,a0
ffffffffc0201048:	42050863          	beqz	a0,ffffffffc0201478 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020104c:	4505                	li	a0,1
ffffffffc020104e:	64b000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc0201052:	89aa                	mv	s3,a0
ffffffffc0201054:	70050263          	beqz	a0,ffffffffc0201758 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201058:	4505                	li	a0,1
ffffffffc020105a:	63f000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020105e:	8a2a                	mv	s4,a0
ffffffffc0201060:	48050c63          	beqz	a0,ffffffffc02014f8 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0201064:	293a8a63          	beq	s5,s3,ffffffffc02012f8 <default_check+0x302>
ffffffffc0201068:	28aa8863          	beq	s5,a0,ffffffffc02012f8 <default_check+0x302>
ffffffffc020106c:	28a98663          	beq	s3,a0,ffffffffc02012f8 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201070:	000aa783          	lw	a5,0(s5)
ffffffffc0201074:	2a079263          	bnez	a5,ffffffffc0201318 <default_check+0x322>
ffffffffc0201078:	0009a783          	lw	a5,0(s3)
ffffffffc020107c:	28079e63          	bnez	a5,ffffffffc0201318 <default_check+0x322>
ffffffffc0201080:	411c                	lw	a5,0(a0)
ffffffffc0201082:	28079b63          	bnez	a5,ffffffffc0201318 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0201086:	000b4797          	auipc	a5,0xb4
ffffffffc020108a:	f827b783          	ld	a5,-126(a5) # ffffffffc02b5008 <pages>
ffffffffc020108e:	40fa8733          	sub	a4,s5,a5
ffffffffc0201092:	00006617          	auipc	a2,0x6
ffffffffc0201096:	7be63603          	ld	a2,1982(a2) # ffffffffc0207850 <nbase>
ffffffffc020109a:	8719                	srai	a4,a4,0x6
ffffffffc020109c:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020109e:	000b4697          	auipc	a3,0xb4
ffffffffc02010a2:	f626b683          	ld	a3,-158(a3) # ffffffffc02b5000 <npage>
ffffffffc02010a6:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc02010a8:	0732                	slli	a4,a4,0xc
ffffffffc02010aa:	28d77763          	bgeu	a4,a3,ffffffffc0201338 <default_check+0x342>
    return page - pages + nbase;
ffffffffc02010ae:	40f98733          	sub	a4,s3,a5
ffffffffc02010b2:	8719                	srai	a4,a4,0x6
ffffffffc02010b4:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010b6:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02010b8:	4cd77063          	bgeu	a4,a3,ffffffffc0201578 <default_check+0x582>
    return page - pages + nbase;
ffffffffc02010bc:	40f507b3          	sub	a5,a0,a5
ffffffffc02010c0:	8799                	srai	a5,a5,0x6
ffffffffc02010c2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02010c4:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02010c6:	30d7f963          	bgeu	a5,a3,ffffffffc02013d8 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02010ca:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02010cc:	00043c03          	ld	s8,0(s0)
ffffffffc02010d0:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02010d4:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02010d8:	e400                	sd	s0,8(s0)
ffffffffc02010da:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02010dc:	000b0797          	auipc	a5,0xb0
ffffffffc02010e0:	ec07a623          	sw	zero,-308(a5) # ffffffffc02b0fa8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc02010e4:	5b5000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc02010e8:	2c051863          	bnez	a0,ffffffffc02013b8 <default_check+0x3c2>
    free_page(p0);
ffffffffc02010ec:	4585                	li	a1,1
ffffffffc02010ee:	8556                	mv	a0,s5
ffffffffc02010f0:	5e7000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    free_page(p1);
ffffffffc02010f4:	4585                	li	a1,1
ffffffffc02010f6:	854e                	mv	a0,s3
ffffffffc02010f8:	5df000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    free_page(p2);
ffffffffc02010fc:	4585                	li	a1,1
ffffffffc02010fe:	8552                	mv	a0,s4
ffffffffc0201100:	5d7000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    assert(nr_free == 3);
ffffffffc0201104:	4818                	lw	a4,16(s0)
ffffffffc0201106:	478d                	li	a5,3
ffffffffc0201108:	28f71863          	bne	a4,a5,ffffffffc0201398 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020110c:	4505                	li	a0,1
ffffffffc020110e:	58b000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc0201112:	89aa                	mv	s3,a0
ffffffffc0201114:	26050263          	beqz	a0,ffffffffc0201378 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201118:	4505                	li	a0,1
ffffffffc020111a:	57f000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020111e:	8aaa                	mv	s5,a0
ffffffffc0201120:	3a050c63          	beqz	a0,ffffffffc02014d8 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0201124:	4505                	li	a0,1
ffffffffc0201126:	573000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020112a:	8a2a                	mv	s4,a0
ffffffffc020112c:	38050663          	beqz	a0,ffffffffc02014b8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0201130:	4505                	li	a0,1
ffffffffc0201132:	567000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc0201136:	36051163          	bnez	a0,ffffffffc0201498 <default_check+0x4a2>
    free_page(p0);
ffffffffc020113a:	4585                	li	a1,1
ffffffffc020113c:	854e                	mv	a0,s3
ffffffffc020113e:	599000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0201142:	641c                	ld	a5,8(s0)
ffffffffc0201144:	20878a63          	beq	a5,s0,ffffffffc0201358 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0201148:	4505                	li	a0,1
ffffffffc020114a:	54f000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020114e:	30a99563          	bne	s3,a0,ffffffffc0201458 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0201152:	4505                	li	a0,1
ffffffffc0201154:	545000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc0201158:	2e051063          	bnez	a0,ffffffffc0201438 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc020115c:	481c                	lw	a5,16(s0)
ffffffffc020115e:	2a079d63          	bnez	a5,ffffffffc0201418 <default_check+0x422>
    free_page(p);
ffffffffc0201162:	854e                	mv	a0,s3
ffffffffc0201164:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0201166:	01843023          	sd	s8,0(s0)
ffffffffc020116a:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc020116e:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0201172:	565000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    free_page(p1);
ffffffffc0201176:	4585                	li	a1,1
ffffffffc0201178:	8556                	mv	a0,s5
ffffffffc020117a:	55d000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    free_page(p2);
ffffffffc020117e:	4585                	li	a1,1
ffffffffc0201180:	8552                	mv	a0,s4
ffffffffc0201182:	555000ef          	jal	ra,ffffffffc0201ed6 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0201186:	4515                	li	a0,5
ffffffffc0201188:	511000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020118c:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc020118e:	26050563          	beqz	a0,ffffffffc02013f8 <default_check+0x402>
ffffffffc0201192:	651c                	ld	a5,8(a0)
ffffffffc0201194:	8385                	srli	a5,a5,0x1
ffffffffc0201196:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc0201198:	54079063          	bnez	a5,ffffffffc02016d8 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020119c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020119e:	00043b03          	ld	s6,0(s0)
ffffffffc02011a2:	00843a83          	ld	s5,8(s0)
ffffffffc02011a6:	e000                	sd	s0,0(s0)
ffffffffc02011a8:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02011aa:	4ef000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc02011ae:	50051563          	bnez	a0,ffffffffc02016b8 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02011b2:	08098a13          	addi	s4,s3,128
ffffffffc02011b6:	8552                	mv	a0,s4
ffffffffc02011b8:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02011ba:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02011be:	000b0797          	auipc	a5,0xb0
ffffffffc02011c2:	de07a523          	sw	zero,-534(a5) # ffffffffc02b0fa8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02011c6:	511000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02011ca:	4511                	li	a0,4
ffffffffc02011cc:	4cd000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc02011d0:	4c051463          	bnez	a0,ffffffffc0201698 <default_check+0x6a2>
ffffffffc02011d4:	0889b783          	ld	a5,136(s3)
ffffffffc02011d8:	8385                	srli	a5,a5,0x1
ffffffffc02011da:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02011dc:	48078e63          	beqz	a5,ffffffffc0201678 <default_check+0x682>
ffffffffc02011e0:	0909a703          	lw	a4,144(s3)
ffffffffc02011e4:	478d                	li	a5,3
ffffffffc02011e6:	48f71963          	bne	a4,a5,ffffffffc0201678 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02011ea:	450d                	li	a0,3
ffffffffc02011ec:	4ad000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc02011f0:	8c2a                	mv	s8,a0
ffffffffc02011f2:	46050363          	beqz	a0,ffffffffc0201658 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc02011f6:	4505                	li	a0,1
ffffffffc02011f8:	4a1000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc02011fc:	42051e63          	bnez	a0,ffffffffc0201638 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201200:	418a1c63          	bne	s4,s8,ffffffffc0201618 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201204:	4585                	li	a1,1
ffffffffc0201206:	854e                	mv	a0,s3
ffffffffc0201208:	4cf000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    free_pages(p1, 3);
ffffffffc020120c:	458d                	li	a1,3
ffffffffc020120e:	8552                	mv	a0,s4
ffffffffc0201210:	4c7000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
ffffffffc0201214:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201218:	04098c13          	addi	s8,s3,64
ffffffffc020121c:	8385                	srli	a5,a5,0x1
ffffffffc020121e:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201220:	3c078c63          	beqz	a5,ffffffffc02015f8 <default_check+0x602>
ffffffffc0201224:	0109a703          	lw	a4,16(s3)
ffffffffc0201228:	4785                	li	a5,1
ffffffffc020122a:	3cf71763          	bne	a4,a5,ffffffffc02015f8 <default_check+0x602>
ffffffffc020122e:	008a3783          	ld	a5,8(s4)
ffffffffc0201232:	8385                	srli	a5,a5,0x1
ffffffffc0201234:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201236:	3a078163          	beqz	a5,ffffffffc02015d8 <default_check+0x5e2>
ffffffffc020123a:	010a2703          	lw	a4,16(s4)
ffffffffc020123e:	478d                	li	a5,3
ffffffffc0201240:	38f71c63          	bne	a4,a5,ffffffffc02015d8 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201244:	4505                	li	a0,1
ffffffffc0201246:	453000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020124a:	36a99763          	bne	s3,a0,ffffffffc02015b8 <default_check+0x5c2>
    free_page(p0);
ffffffffc020124e:	4585                	li	a1,1
ffffffffc0201250:	487000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201254:	4509                	li	a0,2
ffffffffc0201256:	443000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020125a:	32aa1f63          	bne	s4,a0,ffffffffc0201598 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020125e:	4589                	li	a1,2
ffffffffc0201260:	477000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    free_page(p2);
ffffffffc0201264:	4585                	li	a1,1
ffffffffc0201266:	8562                	mv	a0,s8
ffffffffc0201268:	46f000ef          	jal	ra,ffffffffc0201ed6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020126c:	4515                	li	a0,5
ffffffffc020126e:	42b000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc0201272:	89aa                	mv	s3,a0
ffffffffc0201274:	48050263          	beqz	a0,ffffffffc02016f8 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201278:	4505                	li	a0,1
ffffffffc020127a:	41f000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020127e:	2c051d63          	bnez	a0,ffffffffc0201558 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201282:	481c                	lw	a5,16(s0)
ffffffffc0201284:	2a079a63          	bnez	a5,ffffffffc0201538 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201288:	4595                	li	a1,5
ffffffffc020128a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc020128c:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201290:	01643023          	sd	s6,0(s0)
ffffffffc0201294:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201298:	43f000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    return listelm->next;
ffffffffc020129c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc020129e:	00878963          	beq	a5,s0,ffffffffc02012b0 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02012a2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02012a6:	679c                	ld	a5,8(a5)
ffffffffc02012a8:	397d                	addiw	s2,s2,-1
ffffffffc02012aa:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02012ac:	fe879be3          	bne	a5,s0,ffffffffc02012a2 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02012b0:	26091463          	bnez	s2,ffffffffc0201518 <default_check+0x522>
    assert(total == 0);
ffffffffc02012b4:	46049263          	bnez	s1,ffffffffc0201718 <default_check+0x722>
}
ffffffffc02012b8:	60a6                	ld	ra,72(sp)
ffffffffc02012ba:	6406                	ld	s0,64(sp)
ffffffffc02012bc:	74e2                	ld	s1,56(sp)
ffffffffc02012be:	7942                	ld	s2,48(sp)
ffffffffc02012c0:	79a2                	ld	s3,40(sp)
ffffffffc02012c2:	7a02                	ld	s4,32(sp)
ffffffffc02012c4:	6ae2                	ld	s5,24(sp)
ffffffffc02012c6:	6b42                	ld	s6,16(sp)
ffffffffc02012c8:	6ba2                	ld	s7,8(sp)
ffffffffc02012ca:	6c02                	ld	s8,0(sp)
ffffffffc02012cc:	6161                	addi	sp,sp,80
ffffffffc02012ce:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02012d0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02012d2:	4481                	li	s1,0
ffffffffc02012d4:	4901                	li	s2,0
ffffffffc02012d6:	b38d                	j	ffffffffc0201038 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02012d8:	00005697          	auipc	a3,0x5
ffffffffc02012dc:	ec868693          	addi	a3,a3,-312 # ffffffffc02061a0 <commands+0x830>
ffffffffc02012e0:	00005617          	auipc	a2,0x5
ffffffffc02012e4:	c8860613          	addi	a2,a2,-888 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02012e8:	11000593          	li	a1,272
ffffffffc02012ec:	00005517          	auipc	a0,0x5
ffffffffc02012f0:	ec450513          	addi	a0,a0,-316 # ffffffffc02061b0 <commands+0x840>
ffffffffc02012f4:	99aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02012f8:	00005697          	auipc	a3,0x5
ffffffffc02012fc:	f5068693          	addi	a3,a3,-176 # ffffffffc0206248 <commands+0x8d8>
ffffffffc0201300:	00005617          	auipc	a2,0x5
ffffffffc0201304:	c6860613          	addi	a2,a2,-920 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201308:	0db00593          	li	a1,219
ffffffffc020130c:	00005517          	auipc	a0,0x5
ffffffffc0201310:	ea450513          	addi	a0,a0,-348 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201314:	97aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201318:	00005697          	auipc	a3,0x5
ffffffffc020131c:	f5868693          	addi	a3,a3,-168 # ffffffffc0206270 <commands+0x900>
ffffffffc0201320:	00005617          	auipc	a2,0x5
ffffffffc0201324:	c4860613          	addi	a2,a2,-952 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201328:	0dc00593          	li	a1,220
ffffffffc020132c:	00005517          	auipc	a0,0x5
ffffffffc0201330:	e8450513          	addi	a0,a0,-380 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201334:	95aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201338:	00005697          	auipc	a3,0x5
ffffffffc020133c:	f7868693          	addi	a3,a3,-136 # ffffffffc02062b0 <commands+0x940>
ffffffffc0201340:	00005617          	auipc	a2,0x5
ffffffffc0201344:	c2860613          	addi	a2,a2,-984 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201348:	0de00593          	li	a1,222
ffffffffc020134c:	00005517          	auipc	a0,0x5
ffffffffc0201350:	e6450513          	addi	a0,a0,-412 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201354:	93aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201358:	00005697          	auipc	a3,0x5
ffffffffc020135c:	fe068693          	addi	a3,a3,-32 # ffffffffc0206338 <commands+0x9c8>
ffffffffc0201360:	00005617          	auipc	a2,0x5
ffffffffc0201364:	c0860613          	addi	a2,a2,-1016 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201368:	0f700593          	li	a1,247
ffffffffc020136c:	00005517          	auipc	a0,0x5
ffffffffc0201370:	e4450513          	addi	a0,a0,-444 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201374:	91aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201378:	00005697          	auipc	a3,0x5
ffffffffc020137c:	e7068693          	addi	a3,a3,-400 # ffffffffc02061e8 <commands+0x878>
ffffffffc0201380:	00005617          	auipc	a2,0x5
ffffffffc0201384:	be860613          	addi	a2,a2,-1048 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201388:	0f000593          	li	a1,240
ffffffffc020138c:	00005517          	auipc	a0,0x5
ffffffffc0201390:	e2450513          	addi	a0,a0,-476 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201394:	8faff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 3);
ffffffffc0201398:	00005697          	auipc	a3,0x5
ffffffffc020139c:	f9068693          	addi	a3,a3,-112 # ffffffffc0206328 <commands+0x9b8>
ffffffffc02013a0:	00005617          	auipc	a2,0x5
ffffffffc02013a4:	bc860613          	addi	a2,a2,-1080 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02013a8:	0ee00593          	li	a1,238
ffffffffc02013ac:	00005517          	auipc	a0,0x5
ffffffffc02013b0:	e0450513          	addi	a0,a0,-508 # ffffffffc02061b0 <commands+0x840>
ffffffffc02013b4:	8daff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013b8:	00005697          	auipc	a3,0x5
ffffffffc02013bc:	f5868693          	addi	a3,a3,-168 # ffffffffc0206310 <commands+0x9a0>
ffffffffc02013c0:	00005617          	auipc	a2,0x5
ffffffffc02013c4:	ba860613          	addi	a2,a2,-1112 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02013c8:	0e900593          	li	a1,233
ffffffffc02013cc:	00005517          	auipc	a0,0x5
ffffffffc02013d0:	de450513          	addi	a0,a0,-540 # ffffffffc02061b0 <commands+0x840>
ffffffffc02013d4:	8baff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02013d8:	00005697          	auipc	a3,0x5
ffffffffc02013dc:	f1868693          	addi	a3,a3,-232 # ffffffffc02062f0 <commands+0x980>
ffffffffc02013e0:	00005617          	auipc	a2,0x5
ffffffffc02013e4:	b8860613          	addi	a2,a2,-1144 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02013e8:	0e000593          	li	a1,224
ffffffffc02013ec:	00005517          	auipc	a0,0x5
ffffffffc02013f0:	dc450513          	addi	a0,a0,-572 # ffffffffc02061b0 <commands+0x840>
ffffffffc02013f4:	89aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 != NULL);
ffffffffc02013f8:	00005697          	auipc	a3,0x5
ffffffffc02013fc:	f8868693          	addi	a3,a3,-120 # ffffffffc0206380 <commands+0xa10>
ffffffffc0201400:	00005617          	auipc	a2,0x5
ffffffffc0201404:	b6860613          	addi	a2,a2,-1176 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201408:	11800593          	li	a1,280
ffffffffc020140c:	00005517          	auipc	a0,0x5
ffffffffc0201410:	da450513          	addi	a0,a0,-604 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201414:	87aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201418:	00005697          	auipc	a3,0x5
ffffffffc020141c:	f5868693          	addi	a3,a3,-168 # ffffffffc0206370 <commands+0xa00>
ffffffffc0201420:	00005617          	auipc	a2,0x5
ffffffffc0201424:	b4860613          	addi	a2,a2,-1208 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201428:	0fd00593          	li	a1,253
ffffffffc020142c:	00005517          	auipc	a0,0x5
ffffffffc0201430:	d8450513          	addi	a0,a0,-636 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201434:	85aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201438:	00005697          	auipc	a3,0x5
ffffffffc020143c:	ed868693          	addi	a3,a3,-296 # ffffffffc0206310 <commands+0x9a0>
ffffffffc0201440:	00005617          	auipc	a2,0x5
ffffffffc0201444:	b2860613          	addi	a2,a2,-1240 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201448:	0fb00593          	li	a1,251
ffffffffc020144c:	00005517          	auipc	a0,0x5
ffffffffc0201450:	d6450513          	addi	a0,a0,-668 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201454:	83aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201458:	00005697          	auipc	a3,0x5
ffffffffc020145c:	ef868693          	addi	a3,a3,-264 # ffffffffc0206350 <commands+0x9e0>
ffffffffc0201460:	00005617          	auipc	a2,0x5
ffffffffc0201464:	b0860613          	addi	a2,a2,-1272 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201468:	0fa00593          	li	a1,250
ffffffffc020146c:	00005517          	auipc	a0,0x5
ffffffffc0201470:	d4450513          	addi	a0,a0,-700 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201474:	81aff0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201478:	00005697          	auipc	a3,0x5
ffffffffc020147c:	d7068693          	addi	a3,a3,-656 # ffffffffc02061e8 <commands+0x878>
ffffffffc0201480:	00005617          	auipc	a2,0x5
ffffffffc0201484:	ae860613          	addi	a2,a2,-1304 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201488:	0d700593          	li	a1,215
ffffffffc020148c:	00005517          	auipc	a0,0x5
ffffffffc0201490:	d2450513          	addi	a0,a0,-732 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201494:	ffbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201498:	00005697          	auipc	a3,0x5
ffffffffc020149c:	e7868693          	addi	a3,a3,-392 # ffffffffc0206310 <commands+0x9a0>
ffffffffc02014a0:	00005617          	auipc	a2,0x5
ffffffffc02014a4:	ac860613          	addi	a2,a2,-1336 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02014a8:	0f400593          	li	a1,244
ffffffffc02014ac:	00005517          	auipc	a0,0x5
ffffffffc02014b0:	d0450513          	addi	a0,a0,-764 # ffffffffc02061b0 <commands+0x840>
ffffffffc02014b4:	fdbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014b8:	00005697          	auipc	a3,0x5
ffffffffc02014bc:	d7068693          	addi	a3,a3,-656 # ffffffffc0206228 <commands+0x8b8>
ffffffffc02014c0:	00005617          	auipc	a2,0x5
ffffffffc02014c4:	aa860613          	addi	a2,a2,-1368 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02014c8:	0f200593          	li	a1,242
ffffffffc02014cc:	00005517          	auipc	a0,0x5
ffffffffc02014d0:	ce450513          	addi	a0,a0,-796 # ffffffffc02061b0 <commands+0x840>
ffffffffc02014d4:	fbbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02014d8:	00005697          	auipc	a3,0x5
ffffffffc02014dc:	d3068693          	addi	a3,a3,-720 # ffffffffc0206208 <commands+0x898>
ffffffffc02014e0:	00005617          	auipc	a2,0x5
ffffffffc02014e4:	a8860613          	addi	a2,a2,-1400 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02014e8:	0f100593          	li	a1,241
ffffffffc02014ec:	00005517          	auipc	a0,0x5
ffffffffc02014f0:	cc450513          	addi	a0,a0,-828 # ffffffffc02061b0 <commands+0x840>
ffffffffc02014f4:	f9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02014f8:	00005697          	auipc	a3,0x5
ffffffffc02014fc:	d3068693          	addi	a3,a3,-720 # ffffffffc0206228 <commands+0x8b8>
ffffffffc0201500:	00005617          	auipc	a2,0x5
ffffffffc0201504:	a6860613          	addi	a2,a2,-1432 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201508:	0d900593          	li	a1,217
ffffffffc020150c:	00005517          	auipc	a0,0x5
ffffffffc0201510:	ca450513          	addi	a0,a0,-860 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201514:	f7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(count == 0);
ffffffffc0201518:	00005697          	auipc	a3,0x5
ffffffffc020151c:	fb868693          	addi	a3,a3,-72 # ffffffffc02064d0 <commands+0xb60>
ffffffffc0201520:	00005617          	auipc	a2,0x5
ffffffffc0201524:	a4860613          	addi	a2,a2,-1464 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201528:	14600593          	li	a1,326
ffffffffc020152c:	00005517          	auipc	a0,0x5
ffffffffc0201530:	c8450513          	addi	a0,a0,-892 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201534:	f5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free == 0);
ffffffffc0201538:	00005697          	auipc	a3,0x5
ffffffffc020153c:	e3868693          	addi	a3,a3,-456 # ffffffffc0206370 <commands+0xa00>
ffffffffc0201540:	00005617          	auipc	a2,0x5
ffffffffc0201544:	a2860613          	addi	a2,a2,-1496 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201548:	13a00593          	li	a1,314
ffffffffc020154c:	00005517          	auipc	a0,0x5
ffffffffc0201550:	c6450513          	addi	a0,a0,-924 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201554:	f3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201558:	00005697          	auipc	a3,0x5
ffffffffc020155c:	db868693          	addi	a3,a3,-584 # ffffffffc0206310 <commands+0x9a0>
ffffffffc0201560:	00005617          	auipc	a2,0x5
ffffffffc0201564:	a0860613          	addi	a2,a2,-1528 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201568:	13800593          	li	a1,312
ffffffffc020156c:	00005517          	auipc	a0,0x5
ffffffffc0201570:	c4450513          	addi	a0,a0,-956 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201574:	f1bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201578:	00005697          	auipc	a3,0x5
ffffffffc020157c:	d5868693          	addi	a3,a3,-680 # ffffffffc02062d0 <commands+0x960>
ffffffffc0201580:	00005617          	auipc	a2,0x5
ffffffffc0201584:	9e860613          	addi	a2,a2,-1560 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201588:	0df00593          	li	a1,223
ffffffffc020158c:	00005517          	auipc	a0,0x5
ffffffffc0201590:	c2450513          	addi	a0,a0,-988 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201594:	efbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201598:	00005697          	auipc	a3,0x5
ffffffffc020159c:	ef868693          	addi	a3,a3,-264 # ffffffffc0206490 <commands+0xb20>
ffffffffc02015a0:	00005617          	auipc	a2,0x5
ffffffffc02015a4:	9c860613          	addi	a2,a2,-1592 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02015a8:	13200593          	li	a1,306
ffffffffc02015ac:	00005517          	auipc	a0,0x5
ffffffffc02015b0:	c0450513          	addi	a0,a0,-1020 # ffffffffc02061b0 <commands+0x840>
ffffffffc02015b4:	edbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02015b8:	00005697          	auipc	a3,0x5
ffffffffc02015bc:	eb868693          	addi	a3,a3,-328 # ffffffffc0206470 <commands+0xb00>
ffffffffc02015c0:	00005617          	auipc	a2,0x5
ffffffffc02015c4:	9a860613          	addi	a2,a2,-1624 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02015c8:	13000593          	li	a1,304
ffffffffc02015cc:	00005517          	auipc	a0,0x5
ffffffffc02015d0:	be450513          	addi	a0,a0,-1052 # ffffffffc02061b0 <commands+0x840>
ffffffffc02015d4:	ebbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02015d8:	00005697          	auipc	a3,0x5
ffffffffc02015dc:	e7068693          	addi	a3,a3,-400 # ffffffffc0206448 <commands+0xad8>
ffffffffc02015e0:	00005617          	auipc	a2,0x5
ffffffffc02015e4:	98860613          	addi	a2,a2,-1656 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02015e8:	12e00593          	li	a1,302
ffffffffc02015ec:	00005517          	auipc	a0,0x5
ffffffffc02015f0:	bc450513          	addi	a0,a0,-1084 # ffffffffc02061b0 <commands+0x840>
ffffffffc02015f4:	e9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02015f8:	00005697          	auipc	a3,0x5
ffffffffc02015fc:	e2868693          	addi	a3,a3,-472 # ffffffffc0206420 <commands+0xab0>
ffffffffc0201600:	00005617          	auipc	a2,0x5
ffffffffc0201604:	96860613          	addi	a2,a2,-1688 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201608:	12d00593          	li	a1,301
ffffffffc020160c:	00005517          	auipc	a0,0x5
ffffffffc0201610:	ba450513          	addi	a0,a0,-1116 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201614:	e7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201618:	00005697          	auipc	a3,0x5
ffffffffc020161c:	df868693          	addi	a3,a3,-520 # ffffffffc0206410 <commands+0xaa0>
ffffffffc0201620:	00005617          	auipc	a2,0x5
ffffffffc0201624:	94860613          	addi	a2,a2,-1720 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201628:	12800593          	li	a1,296
ffffffffc020162c:	00005517          	auipc	a0,0x5
ffffffffc0201630:	b8450513          	addi	a0,a0,-1148 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201634:	e5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201638:	00005697          	auipc	a3,0x5
ffffffffc020163c:	cd868693          	addi	a3,a3,-808 # ffffffffc0206310 <commands+0x9a0>
ffffffffc0201640:	00005617          	auipc	a2,0x5
ffffffffc0201644:	92860613          	addi	a2,a2,-1752 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201648:	12700593          	li	a1,295
ffffffffc020164c:	00005517          	auipc	a0,0x5
ffffffffc0201650:	b6450513          	addi	a0,a0,-1180 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201654:	e3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201658:	00005697          	auipc	a3,0x5
ffffffffc020165c:	d9868693          	addi	a3,a3,-616 # ffffffffc02063f0 <commands+0xa80>
ffffffffc0201660:	00005617          	auipc	a2,0x5
ffffffffc0201664:	90860613          	addi	a2,a2,-1784 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201668:	12600593          	li	a1,294
ffffffffc020166c:	00005517          	auipc	a0,0x5
ffffffffc0201670:	b4450513          	addi	a0,a0,-1212 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201674:	e1bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201678:	00005697          	auipc	a3,0x5
ffffffffc020167c:	d4868693          	addi	a3,a3,-696 # ffffffffc02063c0 <commands+0xa50>
ffffffffc0201680:	00005617          	auipc	a2,0x5
ffffffffc0201684:	8e860613          	addi	a2,a2,-1816 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201688:	12500593          	li	a1,293
ffffffffc020168c:	00005517          	auipc	a0,0x5
ffffffffc0201690:	b2450513          	addi	a0,a0,-1244 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201694:	dfbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201698:	00005697          	auipc	a3,0x5
ffffffffc020169c:	d1068693          	addi	a3,a3,-752 # ffffffffc02063a8 <commands+0xa38>
ffffffffc02016a0:	00005617          	auipc	a2,0x5
ffffffffc02016a4:	8c860613          	addi	a2,a2,-1848 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02016a8:	12400593          	li	a1,292
ffffffffc02016ac:	00005517          	auipc	a0,0x5
ffffffffc02016b0:	b0450513          	addi	a0,a0,-1276 # ffffffffc02061b0 <commands+0x840>
ffffffffc02016b4:	ddbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02016b8:	00005697          	auipc	a3,0x5
ffffffffc02016bc:	c5868693          	addi	a3,a3,-936 # ffffffffc0206310 <commands+0x9a0>
ffffffffc02016c0:	00005617          	auipc	a2,0x5
ffffffffc02016c4:	8a860613          	addi	a2,a2,-1880 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02016c8:	11e00593          	li	a1,286
ffffffffc02016cc:	00005517          	auipc	a0,0x5
ffffffffc02016d0:	ae450513          	addi	a0,a0,-1308 # ffffffffc02061b0 <commands+0x840>
ffffffffc02016d4:	dbbfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(!PageProperty(p0));
ffffffffc02016d8:	00005697          	auipc	a3,0x5
ffffffffc02016dc:	cb868693          	addi	a3,a3,-840 # ffffffffc0206390 <commands+0xa20>
ffffffffc02016e0:	00005617          	auipc	a2,0x5
ffffffffc02016e4:	88860613          	addi	a2,a2,-1912 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02016e8:	11900593          	li	a1,281
ffffffffc02016ec:	00005517          	auipc	a0,0x5
ffffffffc02016f0:	ac450513          	addi	a0,a0,-1340 # ffffffffc02061b0 <commands+0x840>
ffffffffc02016f4:	d9bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02016f8:	00005697          	auipc	a3,0x5
ffffffffc02016fc:	db868693          	addi	a3,a3,-584 # ffffffffc02064b0 <commands+0xb40>
ffffffffc0201700:	00005617          	auipc	a2,0x5
ffffffffc0201704:	86860613          	addi	a2,a2,-1944 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201708:	13700593          	li	a1,311
ffffffffc020170c:	00005517          	auipc	a0,0x5
ffffffffc0201710:	aa450513          	addi	a0,a0,-1372 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201714:	d7bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == 0);
ffffffffc0201718:	00005697          	auipc	a3,0x5
ffffffffc020171c:	dc868693          	addi	a3,a3,-568 # ffffffffc02064e0 <commands+0xb70>
ffffffffc0201720:	00005617          	auipc	a2,0x5
ffffffffc0201724:	84860613          	addi	a2,a2,-1976 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201728:	14700593          	li	a1,327
ffffffffc020172c:	00005517          	auipc	a0,0x5
ffffffffc0201730:	a8450513          	addi	a0,a0,-1404 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201734:	d5bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(total == nr_free_pages());
ffffffffc0201738:	00005697          	auipc	a3,0x5
ffffffffc020173c:	a9068693          	addi	a3,a3,-1392 # ffffffffc02061c8 <commands+0x858>
ffffffffc0201740:	00005617          	auipc	a2,0x5
ffffffffc0201744:	82860613          	addi	a2,a2,-2008 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201748:	11300593          	li	a1,275
ffffffffc020174c:	00005517          	auipc	a0,0x5
ffffffffc0201750:	a6450513          	addi	a0,a0,-1436 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201754:	d3bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201758:	00005697          	auipc	a3,0x5
ffffffffc020175c:	ab068693          	addi	a3,a3,-1360 # ffffffffc0206208 <commands+0x898>
ffffffffc0201760:	00005617          	auipc	a2,0x5
ffffffffc0201764:	80860613          	addi	a2,a2,-2040 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201768:	0d800593          	li	a1,216
ffffffffc020176c:	00005517          	auipc	a0,0x5
ffffffffc0201770:	a4450513          	addi	a0,a0,-1468 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201774:	d1bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201778 <default_free_pages>:
{
ffffffffc0201778:	1141                	addi	sp,sp,-16
ffffffffc020177a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020177c:	14058463          	beqz	a1,ffffffffc02018c4 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0201780:	00659693          	slli	a3,a1,0x6
ffffffffc0201784:	96aa                	add	a3,a3,a0
ffffffffc0201786:	87aa                	mv	a5,a0
ffffffffc0201788:	02d50263          	beq	a0,a3,ffffffffc02017ac <default_free_pages+0x34>
ffffffffc020178c:	6798                	ld	a4,8(a5)
ffffffffc020178e:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201790:	10071a63          	bnez	a4,ffffffffc02018a4 <default_free_pages+0x12c>
ffffffffc0201794:	6798                	ld	a4,8(a5)
ffffffffc0201796:	8b09                	andi	a4,a4,2
ffffffffc0201798:	10071663          	bnez	a4,ffffffffc02018a4 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc020179c:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02017a0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02017a4:	04078793          	addi	a5,a5,64
ffffffffc02017a8:	fed792e3          	bne	a5,a3,ffffffffc020178c <default_free_pages+0x14>
    base->property = n;
ffffffffc02017ac:	2581                	sext.w	a1,a1
ffffffffc02017ae:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02017b0:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017b4:	4789                	li	a5,2
ffffffffc02017b6:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02017ba:	000af697          	auipc	a3,0xaf
ffffffffc02017be:	7de68693          	addi	a3,a3,2014 # ffffffffc02b0f98 <free_area>
ffffffffc02017c2:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02017c4:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02017c6:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017ca:	9db9                	addw	a1,a1,a4
ffffffffc02017cc:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02017ce:	0ad78463          	beq	a5,a3,ffffffffc0201876 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc02017d2:	fe878713          	addi	a4,a5,-24
ffffffffc02017d6:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02017da:	4581                	li	a1,0
            if (base < page)
ffffffffc02017dc:	00e56a63          	bltu	a0,a4,ffffffffc02017f0 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02017e0:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02017e2:	04d70c63          	beq	a4,a3,ffffffffc020183a <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc02017e6:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc02017e8:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc02017ec:	fee57ae3          	bgeu	a0,a4,ffffffffc02017e0 <default_free_pages+0x68>
ffffffffc02017f0:	c199                	beqz	a1,ffffffffc02017f6 <default_free_pages+0x7e>
ffffffffc02017f2:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02017f6:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02017f8:	e390                	sd	a2,0(a5)
ffffffffc02017fa:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02017fc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02017fe:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0201800:	00d70d63          	beq	a4,a3,ffffffffc020181a <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0201804:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201808:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc020180c:	02059813          	slli	a6,a1,0x20
ffffffffc0201810:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201814:	97b2                	add	a5,a5,a2
ffffffffc0201816:	02f50c63          	beq	a0,a5,ffffffffc020184e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020181a:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc020181c:	00d78c63          	beq	a5,a3,ffffffffc0201834 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0201820:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201822:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0201826:	02061593          	slli	a1,a2,0x20
ffffffffc020182a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020182e:	972a                	add	a4,a4,a0
ffffffffc0201830:	04e68a63          	beq	a3,a4,ffffffffc0201884 <default_free_pages+0x10c>
}
ffffffffc0201834:	60a2                	ld	ra,8(sp)
ffffffffc0201836:	0141                	addi	sp,sp,16
ffffffffc0201838:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020183a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020183c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020183e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201840:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201842:	02d70763          	beq	a4,a3,ffffffffc0201870 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201846:	8832                	mv	a6,a2
ffffffffc0201848:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc020184a:	87ba                	mv	a5,a4
ffffffffc020184c:	bf71                	j	ffffffffc02017e8 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020184e:	491c                	lw	a5,16(a0)
ffffffffc0201850:	9dbd                	addw	a1,a1,a5
ffffffffc0201852:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201856:	57f5                	li	a5,-3
ffffffffc0201858:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020185c:	01853803          	ld	a6,24(a0)
ffffffffc0201860:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201862:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201864:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201868:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020186a:	0105b023          	sd	a6,0(a1)
ffffffffc020186e:	b77d                	j	ffffffffc020181c <default_free_pages+0xa4>
ffffffffc0201870:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201872:	873e                	mv	a4,a5
ffffffffc0201874:	bf41                	j	ffffffffc0201804 <default_free_pages+0x8c>
}
ffffffffc0201876:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201878:	e390                	sd	a2,0(a5)
ffffffffc020187a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020187c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020187e:	ed1c                	sd	a5,24(a0)
ffffffffc0201880:	0141                	addi	sp,sp,16
ffffffffc0201882:	8082                	ret
            base->property += p->property;
ffffffffc0201884:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201888:	ff078693          	addi	a3,a5,-16
ffffffffc020188c:	9e39                	addw	a2,a2,a4
ffffffffc020188e:	c910                	sw	a2,16(a0)
ffffffffc0201890:	5775                	li	a4,-3
ffffffffc0201892:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201896:	6398                	ld	a4,0(a5)
ffffffffc0201898:	679c                	ld	a5,8(a5)
}
ffffffffc020189a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020189c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020189e:	e398                	sd	a4,0(a5)
ffffffffc02018a0:	0141                	addi	sp,sp,16
ffffffffc02018a2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02018a4:	00005697          	auipc	a3,0x5
ffffffffc02018a8:	c5468693          	addi	a3,a3,-940 # ffffffffc02064f8 <commands+0xb88>
ffffffffc02018ac:	00004617          	auipc	a2,0x4
ffffffffc02018b0:	6bc60613          	addi	a2,a2,1724 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02018b4:	09400593          	li	a1,148
ffffffffc02018b8:	00005517          	auipc	a0,0x5
ffffffffc02018bc:	8f850513          	addi	a0,a0,-1800 # ffffffffc02061b0 <commands+0x840>
ffffffffc02018c0:	bcffe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc02018c4:	00005697          	auipc	a3,0x5
ffffffffc02018c8:	c2c68693          	addi	a3,a3,-980 # ffffffffc02064f0 <commands+0xb80>
ffffffffc02018cc:	00004617          	auipc	a2,0x4
ffffffffc02018d0:	69c60613          	addi	a2,a2,1692 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02018d4:	09000593          	li	a1,144
ffffffffc02018d8:	00005517          	auipc	a0,0x5
ffffffffc02018dc:	8d850513          	addi	a0,a0,-1832 # ffffffffc02061b0 <commands+0x840>
ffffffffc02018e0:	baffe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02018e4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02018e4:	c941                	beqz	a0,ffffffffc0201974 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc02018e6:	000af597          	auipc	a1,0xaf
ffffffffc02018ea:	6b258593          	addi	a1,a1,1714 # ffffffffc02b0f98 <free_area>
ffffffffc02018ee:	0105a803          	lw	a6,16(a1)
ffffffffc02018f2:	872a                	mv	a4,a0
ffffffffc02018f4:	02081793          	slli	a5,a6,0x20
ffffffffc02018f8:	9381                	srli	a5,a5,0x20
ffffffffc02018fa:	00a7ee63          	bltu	a5,a0,ffffffffc0201916 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02018fe:	87ae                	mv	a5,a1
ffffffffc0201900:	a801                	j	ffffffffc0201910 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0201902:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201906:	02069613          	slli	a2,a3,0x20
ffffffffc020190a:	9201                	srli	a2,a2,0x20
ffffffffc020190c:	00e67763          	bgeu	a2,a4,ffffffffc020191a <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201910:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0201912:	feb798e3          	bne	a5,a1,ffffffffc0201902 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201916:	4501                	li	a0,0
}
ffffffffc0201918:	8082                	ret
    return listelm->prev;
ffffffffc020191a:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020191e:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201922:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201926:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020192a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020192e:	01133023          	sd	a7,0(t1)
        if (page->property > n)
ffffffffc0201932:	02c77863          	bgeu	a4,a2,ffffffffc0201962 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201936:	071a                	slli	a4,a4,0x6
ffffffffc0201938:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020193a:	41c686bb          	subw	a3,a3,t3
ffffffffc020193e:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201940:	00870613          	addi	a2,a4,8
ffffffffc0201944:	4689                	li	a3,2
ffffffffc0201946:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020194a:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020194e:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201952:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201956:	e290                	sd	a2,0(a3)
ffffffffc0201958:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020195c:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020195e:	01173c23          	sd	a7,24(a4)
ffffffffc0201962:	41c8083b          	subw	a6,a6,t3
ffffffffc0201966:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020196a:	5775                	li	a4,-3
ffffffffc020196c:	17c1                	addi	a5,a5,-16
ffffffffc020196e:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201972:	8082                	ret
{
ffffffffc0201974:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201976:	00005697          	auipc	a3,0x5
ffffffffc020197a:	b7a68693          	addi	a3,a3,-1158 # ffffffffc02064f0 <commands+0xb80>
ffffffffc020197e:	00004617          	auipc	a2,0x4
ffffffffc0201982:	5ea60613          	addi	a2,a2,1514 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201986:	06c00593          	li	a1,108
ffffffffc020198a:	00005517          	auipc	a0,0x5
ffffffffc020198e:	82650513          	addi	a0,a0,-2010 # ffffffffc02061b0 <commands+0x840>
{
ffffffffc0201992:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201994:	afbfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201998 <default_init_memmap>:
{
ffffffffc0201998:	1141                	addi	sp,sp,-16
ffffffffc020199a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020199c:	c5f1                	beqz	a1,ffffffffc0201a68 <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc020199e:	00659693          	slli	a3,a1,0x6
ffffffffc02019a2:	96aa                	add	a3,a3,a0
ffffffffc02019a4:	87aa                	mv	a5,a0
ffffffffc02019a6:	00d50f63          	beq	a0,a3,ffffffffc02019c4 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02019aa:	6798                	ld	a4,8(a5)
ffffffffc02019ac:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc02019ae:	cf49                	beqz	a4,ffffffffc0201a48 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02019b0:	0007a823          	sw	zero,16(a5)
ffffffffc02019b4:	0007b423          	sd	zero,8(a5)
ffffffffc02019b8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc02019bc:	04078793          	addi	a5,a5,64
ffffffffc02019c0:	fed795e3          	bne	a5,a3,ffffffffc02019aa <default_init_memmap+0x12>
    base->property = n;
ffffffffc02019c4:	2581                	sext.w	a1,a1
ffffffffc02019c6:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02019c8:	4789                	li	a5,2
ffffffffc02019ca:	00850713          	addi	a4,a0,8
ffffffffc02019ce:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02019d2:	000af697          	auipc	a3,0xaf
ffffffffc02019d6:	5c668693          	addi	a3,a3,1478 # ffffffffc02b0f98 <free_area>
ffffffffc02019da:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02019dc:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02019de:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02019e2:	9db9                	addw	a1,a1,a4
ffffffffc02019e4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc02019e6:	04d78a63          	beq	a5,a3,ffffffffc0201a3a <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc02019ea:	fe878713          	addi	a4,a5,-24
ffffffffc02019ee:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc02019f2:	4581                	li	a1,0
            if (base < page)
ffffffffc02019f4:	00e56a63          	bltu	a0,a4,ffffffffc0201a08 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02019f8:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc02019fa:	02d70263          	beq	a4,a3,ffffffffc0201a1e <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc02019fe:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0201a00:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0201a04:	fee57ae3          	bgeu	a0,a4,ffffffffc02019f8 <default_init_memmap+0x60>
ffffffffc0201a08:	c199                	beqz	a1,ffffffffc0201a0e <default_init_memmap+0x76>
ffffffffc0201a0a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201a0e:	6398                	ld	a4,0(a5)
}
ffffffffc0201a10:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201a12:	e390                	sd	a2,0(a5)
ffffffffc0201a14:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201a16:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a18:	ed18                	sd	a4,24(a0)
ffffffffc0201a1a:	0141                	addi	sp,sp,16
ffffffffc0201a1c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0201a1e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a20:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201a22:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201a24:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0201a26:	00d70663          	beq	a4,a3,ffffffffc0201a32 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0201a2a:	8832                	mv	a6,a2
ffffffffc0201a2c:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0201a2e:	87ba                	mv	a5,a4
ffffffffc0201a30:	bfc1                	j	ffffffffc0201a00 <default_init_memmap+0x68>
}
ffffffffc0201a32:	60a2                	ld	ra,8(sp)
ffffffffc0201a34:	e290                	sd	a2,0(a3)
ffffffffc0201a36:	0141                	addi	sp,sp,16
ffffffffc0201a38:	8082                	ret
ffffffffc0201a3a:	60a2                	ld	ra,8(sp)
ffffffffc0201a3c:	e390                	sd	a2,0(a5)
ffffffffc0201a3e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201a40:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201a42:	ed1c                	sd	a5,24(a0)
ffffffffc0201a44:	0141                	addi	sp,sp,16
ffffffffc0201a46:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201a48:	00005697          	auipc	a3,0x5
ffffffffc0201a4c:	ad868693          	addi	a3,a3,-1320 # ffffffffc0206520 <commands+0xbb0>
ffffffffc0201a50:	00004617          	auipc	a2,0x4
ffffffffc0201a54:	51860613          	addi	a2,a2,1304 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201a58:	04b00593          	li	a1,75
ffffffffc0201a5c:	00004517          	auipc	a0,0x4
ffffffffc0201a60:	75450513          	addi	a0,a0,1876 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201a64:	a2bfe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(n > 0);
ffffffffc0201a68:	00005697          	auipc	a3,0x5
ffffffffc0201a6c:	a8868693          	addi	a3,a3,-1400 # ffffffffc02064f0 <commands+0xb80>
ffffffffc0201a70:	00004617          	auipc	a2,0x4
ffffffffc0201a74:	4f860613          	addi	a2,a2,1272 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201a78:	04700593          	li	a1,71
ffffffffc0201a7c:	00004517          	auipc	a0,0x4
ffffffffc0201a80:	73450513          	addi	a0,a0,1844 # ffffffffc02061b0 <commands+0x840>
ffffffffc0201a84:	a0bfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201a88 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201a88:	c94d                	beqz	a0,ffffffffc0201b3a <slob_free+0xb2>
{
ffffffffc0201a8a:	1141                	addi	sp,sp,-16
ffffffffc0201a8c:	e022                	sd	s0,0(sp)
ffffffffc0201a8e:	e406                	sd	ra,8(sp)
ffffffffc0201a90:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201a92:	e9c1                	bnez	a1,ffffffffc0201b22 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a94:	100027f3          	csrr	a5,sstatus
ffffffffc0201a98:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201a9a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201a9c:	ebd9                	bnez	a5,ffffffffc0201b32 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201a9e:	000af617          	auipc	a2,0xaf
ffffffffc0201aa2:	0ea60613          	addi	a2,a2,234 # ffffffffc02b0b88 <slobfree>
ffffffffc0201aa6:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201aa8:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0201aaa:	679c                	ld	a5,8(a5)
ffffffffc0201aac:	02877a63          	bgeu	a4,s0,ffffffffc0201ae0 <slob_free+0x58>
ffffffffc0201ab0:	00f46463          	bltu	s0,a5,ffffffffc0201ab8 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ab4:	fef76ae3          	bltu	a4,a5,ffffffffc0201aa8 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0201ab8:	400c                	lw	a1,0(s0)
ffffffffc0201aba:	00459693          	slli	a3,a1,0x4
ffffffffc0201abe:	96a2                	add	a3,a3,s0
ffffffffc0201ac0:	02d78a63          	beq	a5,a3,ffffffffc0201af4 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0201ac4:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0201ac6:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201ac8:	00469793          	slli	a5,a3,0x4
ffffffffc0201acc:	97ba                	add	a5,a5,a4
ffffffffc0201ace:	02f40e63          	beq	s0,a5,ffffffffc0201b0a <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0201ad2:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0201ad4:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0201ad6:	e129                	bnez	a0,ffffffffc0201b18 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0201ad8:	60a2                	ld	ra,8(sp)
ffffffffc0201ada:	6402                	ld	s0,0(sp)
ffffffffc0201adc:	0141                	addi	sp,sp,16
ffffffffc0201ade:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0201ae0:	fcf764e3          	bltu	a4,a5,ffffffffc0201aa8 <slob_free+0x20>
ffffffffc0201ae4:	fcf472e3          	bgeu	s0,a5,ffffffffc0201aa8 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0201ae8:	400c                	lw	a1,0(s0)
ffffffffc0201aea:	00459693          	slli	a3,a1,0x4
ffffffffc0201aee:	96a2                	add	a3,a3,s0
ffffffffc0201af0:	fcd79ae3          	bne	a5,a3,ffffffffc0201ac4 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0201af4:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0201af6:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0201af8:	9db5                	addw	a1,a1,a3
ffffffffc0201afa:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0201afc:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0201afe:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201b00:	00469793          	slli	a5,a3,0x4
ffffffffc0201b04:	97ba                	add	a5,a5,a4
ffffffffc0201b06:	fcf416e3          	bne	s0,a5,ffffffffc0201ad2 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0201b0a:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0201b0c:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0201b0e:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201b10:	9ebd                	addw	a3,a3,a5
ffffffffc0201b12:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201b14:	e70c                	sd	a1,8(a4)
ffffffffc0201b16:	d169                	beqz	a0,ffffffffc0201ad8 <slob_free+0x50>
}
ffffffffc0201b18:	6402                	ld	s0,0(sp)
ffffffffc0201b1a:	60a2                	ld	ra,8(sp)
ffffffffc0201b1c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0201b1e:	e91fe06f          	j	ffffffffc02009ae <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201b22:	25bd                	addiw	a1,a1,15
ffffffffc0201b24:	8191                	srli	a1,a1,0x4
ffffffffc0201b26:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b28:	100027f3          	csrr	a5,sstatus
ffffffffc0201b2c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0201b2e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201b30:	d7bd                	beqz	a5,ffffffffc0201a9e <slob_free+0x16>
        intr_disable();
ffffffffc0201b32:	e83fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201b36:	4505                	li	a0,1
ffffffffc0201b38:	b79d                	j	ffffffffc0201a9e <slob_free+0x16>
ffffffffc0201b3a:	8082                	ret

ffffffffc0201b3c <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b3c:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b3e:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b40:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201b44:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201b46:	352000ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
	if (!page)
ffffffffc0201b4a:	c91d                	beqz	a0,ffffffffc0201b80 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0201b4c:	000b3697          	auipc	a3,0xb3
ffffffffc0201b50:	4bc6b683          	ld	a3,1212(a3) # ffffffffc02b5008 <pages>
ffffffffc0201b54:	8d15                	sub	a0,a0,a3
ffffffffc0201b56:	8519                	srai	a0,a0,0x6
ffffffffc0201b58:	00006697          	auipc	a3,0x6
ffffffffc0201b5c:	cf86b683          	ld	a3,-776(a3) # ffffffffc0207850 <nbase>
ffffffffc0201b60:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201b62:	00c51793          	slli	a5,a0,0xc
ffffffffc0201b66:	83b1                	srli	a5,a5,0xc
ffffffffc0201b68:	000b3717          	auipc	a4,0xb3
ffffffffc0201b6c:	49873703          	ld	a4,1176(a4) # ffffffffc02b5000 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201b70:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201b72:	00e7fa63          	bgeu	a5,a4,ffffffffc0201b86 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201b76:	000b3697          	auipc	a3,0xb3
ffffffffc0201b7a:	4a26b683          	ld	a3,1186(a3) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0201b7e:	9536                	add	a0,a0,a3
}
ffffffffc0201b80:	60a2                	ld	ra,8(sp)
ffffffffc0201b82:	0141                	addi	sp,sp,16
ffffffffc0201b84:	8082                	ret
ffffffffc0201b86:	86aa                	mv	a3,a0
ffffffffc0201b88:	00005617          	auipc	a2,0x5
ffffffffc0201b8c:	9f860613          	addi	a2,a2,-1544 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0201b90:	07100593          	li	a1,113
ffffffffc0201b94:	00005517          	auipc	a0,0x5
ffffffffc0201b98:	a1450513          	addi	a0,a0,-1516 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0201b9c:	8f3fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201ba0 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0201ba0:	1101                	addi	sp,sp,-32
ffffffffc0201ba2:	ec06                	sd	ra,24(sp)
ffffffffc0201ba4:	e822                	sd	s0,16(sp)
ffffffffc0201ba6:	e426                	sd	s1,8(sp)
ffffffffc0201ba8:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201baa:	01050713          	addi	a4,a0,16
ffffffffc0201bae:	6785                	lui	a5,0x1
ffffffffc0201bb0:	0cf77363          	bgeu	a4,a5,ffffffffc0201c76 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc0201bb4:	00f50493          	addi	s1,a0,15
ffffffffc0201bb8:	8091                	srli	s1,s1,0x4
ffffffffc0201bba:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201bbc:	10002673          	csrr	a2,sstatus
ffffffffc0201bc0:	8a09                	andi	a2,a2,2
ffffffffc0201bc2:	e25d                	bnez	a2,ffffffffc0201c68 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc0201bc4:	000af917          	auipc	s2,0xaf
ffffffffc0201bc8:	fc490913          	addi	s2,s2,-60 # ffffffffc02b0b88 <slobfree>
ffffffffc0201bcc:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bd0:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc0201bd2:	4398                	lw	a4,0(a5)
ffffffffc0201bd4:	08975e63          	bge	a4,s1,ffffffffc0201c70 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0201bd8:	00f68b63          	beq	a3,a5,ffffffffc0201bee <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201bdc:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201bde:	4018                	lw	a4,0(s0)
ffffffffc0201be0:	02975a63          	bge	a4,s1,ffffffffc0201c14 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc0201be4:	00093683          	ld	a3,0(s2)
ffffffffc0201be8:	87a2                	mv	a5,s0
ffffffffc0201bea:	fef699e3          	bne	a3,a5,ffffffffc0201bdc <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0201bee:	ee31                	bnez	a2,ffffffffc0201c4a <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0201bf0:	4501                	li	a0,0
ffffffffc0201bf2:	f4bff0ef          	jal	ra,ffffffffc0201b3c <__slob_get_free_pages.constprop.0>
ffffffffc0201bf6:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0201bf8:	cd05                	beqz	a0,ffffffffc0201c30 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0201bfa:	6585                	lui	a1,0x1
ffffffffc0201bfc:	e8dff0ef          	jal	ra,ffffffffc0201a88 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201c00:	10002673          	csrr	a2,sstatus
ffffffffc0201c04:	8a09                	andi	a2,a2,2
ffffffffc0201c06:	ee05                	bnez	a2,ffffffffc0201c3e <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201c08:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201c0c:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201c0e:	4018                	lw	a4,0(s0)
ffffffffc0201c10:	fc974ae3          	blt	a4,s1,ffffffffc0201be4 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201c14:	04e48763          	beq	s1,a4,ffffffffc0201c62 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201c18:	00449693          	slli	a3,s1,0x4
ffffffffc0201c1c:	96a2                	add	a3,a3,s0
ffffffffc0201c1e:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201c20:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201c22:	9f05                	subw	a4,a4,s1
ffffffffc0201c24:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201c26:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201c28:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201c2a:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc0201c2e:	e20d                	bnez	a2,ffffffffc0201c50 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201c30:	60e2                	ld	ra,24(sp)
ffffffffc0201c32:	8522                	mv	a0,s0
ffffffffc0201c34:	6442                	ld	s0,16(sp)
ffffffffc0201c36:	64a2                	ld	s1,8(sp)
ffffffffc0201c38:	6902                	ld	s2,0(sp)
ffffffffc0201c3a:	6105                	addi	sp,sp,32
ffffffffc0201c3c:	8082                	ret
        intr_disable();
ffffffffc0201c3e:	d77fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
			cur = slobfree;
ffffffffc0201c42:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201c46:	4605                	li	a2,1
ffffffffc0201c48:	b7d1                	j	ffffffffc0201c0c <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201c4a:	d65fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201c4e:	b74d                	j	ffffffffc0201bf0 <slob_alloc.constprop.0+0x50>
ffffffffc0201c50:	d5ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
}
ffffffffc0201c54:	60e2                	ld	ra,24(sp)
ffffffffc0201c56:	8522                	mv	a0,s0
ffffffffc0201c58:	6442                	ld	s0,16(sp)
ffffffffc0201c5a:	64a2                	ld	s1,8(sp)
ffffffffc0201c5c:	6902                	ld	s2,0(sp)
ffffffffc0201c5e:	6105                	addi	sp,sp,32
ffffffffc0201c60:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201c62:	6418                	ld	a4,8(s0)
ffffffffc0201c64:	e798                	sd	a4,8(a5)
ffffffffc0201c66:	b7d1                	j	ffffffffc0201c2a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201c68:	d4dfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0201c6c:	4605                	li	a2,1
ffffffffc0201c6e:	bf99                	j	ffffffffc0201bc4 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201c70:	843e                	mv	s0,a5
ffffffffc0201c72:	87b6                	mv	a5,a3
ffffffffc0201c74:	b745                	j	ffffffffc0201c14 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201c76:	00005697          	auipc	a3,0x5
ffffffffc0201c7a:	94268693          	addi	a3,a3,-1726 # ffffffffc02065b8 <default_pmm_manager+0x70>
ffffffffc0201c7e:	00004617          	auipc	a2,0x4
ffffffffc0201c82:	2ea60613          	addi	a2,a2,746 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0201c86:	06300593          	li	a1,99
ffffffffc0201c8a:	00005517          	auipc	a0,0x5
ffffffffc0201c8e:	94e50513          	addi	a0,a0,-1714 # ffffffffc02065d8 <default_pmm_manager+0x90>
ffffffffc0201c92:	ffcfe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201c96 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201c96:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201c98:	00005517          	auipc	a0,0x5
ffffffffc0201c9c:	95850513          	addi	a0,a0,-1704 # ffffffffc02065f0 <default_pmm_manager+0xa8>
{
ffffffffc0201ca0:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201ca2:	cf2fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201ca6:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201ca8:	00005517          	auipc	a0,0x5
ffffffffc0201cac:	96050513          	addi	a0,a0,-1696 # ffffffffc0206608 <default_pmm_manager+0xc0>
}
ffffffffc0201cb0:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201cb2:	ce2fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201cb6 <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc0201cb6:	4501                	li	a0,0
ffffffffc0201cb8:	8082                	ret

ffffffffc0201cba <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201cba:	1101                	addi	sp,sp,-32
ffffffffc0201cbc:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cbe:	6905                	lui	s2,0x1
{
ffffffffc0201cc0:	e822                	sd	s0,16(sp)
ffffffffc0201cc2:	ec06                	sd	ra,24(sp)
ffffffffc0201cc4:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201cc6:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bb9>
{
ffffffffc0201cca:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201ccc:	04a7f963          	bgeu	a5,a0,ffffffffc0201d1e <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201cd0:	4561                	li	a0,24
ffffffffc0201cd2:	ecfff0ef          	jal	ra,ffffffffc0201ba0 <slob_alloc.constprop.0>
ffffffffc0201cd6:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201cd8:	c929                	beqz	a0,ffffffffc0201d2a <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201cda:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201cde:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201ce0:	00f95763          	bge	s2,a5,ffffffffc0201cee <kmalloc+0x34>
ffffffffc0201ce4:	6705                	lui	a4,0x1
ffffffffc0201ce6:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201ce8:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201cea:	fef74ee3          	blt	a4,a5,ffffffffc0201ce6 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201cee:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201cf0:	e4dff0ef          	jal	ra,ffffffffc0201b3c <__slob_get_free_pages.constprop.0>
ffffffffc0201cf4:	e488                	sd	a0,8(s1)
ffffffffc0201cf6:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201cf8:	c525                	beqz	a0,ffffffffc0201d60 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201cfa:	100027f3          	csrr	a5,sstatus
ffffffffc0201cfe:	8b89                	andi	a5,a5,2
ffffffffc0201d00:	ef8d                	bnez	a5,ffffffffc0201d3a <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201d02:	000b3797          	auipc	a5,0xb3
ffffffffc0201d06:	2e678793          	addi	a5,a5,742 # ffffffffc02b4fe8 <bigblocks>
ffffffffc0201d0a:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d0c:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d0e:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201d10:	60e2                	ld	ra,24(sp)
ffffffffc0201d12:	8522                	mv	a0,s0
ffffffffc0201d14:	6442                	ld	s0,16(sp)
ffffffffc0201d16:	64a2                	ld	s1,8(sp)
ffffffffc0201d18:	6902                	ld	s2,0(sp)
ffffffffc0201d1a:	6105                	addi	sp,sp,32
ffffffffc0201d1c:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201d1e:	0541                	addi	a0,a0,16
ffffffffc0201d20:	e81ff0ef          	jal	ra,ffffffffc0201ba0 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201d24:	01050413          	addi	s0,a0,16
ffffffffc0201d28:	f565                	bnez	a0,ffffffffc0201d10 <kmalloc+0x56>
ffffffffc0201d2a:	4401                	li	s0,0
}
ffffffffc0201d2c:	60e2                	ld	ra,24(sp)
ffffffffc0201d2e:	8522                	mv	a0,s0
ffffffffc0201d30:	6442                	ld	s0,16(sp)
ffffffffc0201d32:	64a2                	ld	s1,8(sp)
ffffffffc0201d34:	6902                	ld	s2,0(sp)
ffffffffc0201d36:	6105                	addi	sp,sp,32
ffffffffc0201d38:	8082                	ret
        intr_disable();
ffffffffc0201d3a:	c7bfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201d3e:	000b3797          	auipc	a5,0xb3
ffffffffc0201d42:	2aa78793          	addi	a5,a5,682 # ffffffffc02b4fe8 <bigblocks>
ffffffffc0201d46:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201d48:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201d4a:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201d4c:	c63fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
		return bb->pages;
ffffffffc0201d50:	6480                	ld	s0,8(s1)
}
ffffffffc0201d52:	60e2                	ld	ra,24(sp)
ffffffffc0201d54:	64a2                	ld	s1,8(sp)
ffffffffc0201d56:	8522                	mv	a0,s0
ffffffffc0201d58:	6442                	ld	s0,16(sp)
ffffffffc0201d5a:	6902                	ld	s2,0(sp)
ffffffffc0201d5c:	6105                	addi	sp,sp,32
ffffffffc0201d5e:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201d60:	45e1                	li	a1,24
ffffffffc0201d62:	8526                	mv	a0,s1
ffffffffc0201d64:	d25ff0ef          	jal	ra,ffffffffc0201a88 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201d68:	b765                	j	ffffffffc0201d10 <kmalloc+0x56>

ffffffffc0201d6a <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201d6a:	c169                	beqz	a0,ffffffffc0201e2c <kfree+0xc2>
{
ffffffffc0201d6c:	1101                	addi	sp,sp,-32
ffffffffc0201d6e:	e822                	sd	s0,16(sp)
ffffffffc0201d70:	ec06                	sd	ra,24(sp)
ffffffffc0201d72:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201d74:	03451793          	slli	a5,a0,0x34
ffffffffc0201d78:	842a                	mv	s0,a0
ffffffffc0201d7a:	e3d9                	bnez	a5,ffffffffc0201e00 <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201d7c:	100027f3          	csrr	a5,sstatus
ffffffffc0201d80:	8b89                	andi	a5,a5,2
ffffffffc0201d82:	e7d9                	bnez	a5,ffffffffc0201e10 <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d84:	000b3797          	auipc	a5,0xb3
ffffffffc0201d88:	2647b783          	ld	a5,612(a5) # ffffffffc02b4fe8 <bigblocks>
    return 0;
ffffffffc0201d8c:	4601                	li	a2,0
ffffffffc0201d8e:	cbad                	beqz	a5,ffffffffc0201e00 <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201d90:	000b3697          	auipc	a3,0xb3
ffffffffc0201d94:	25868693          	addi	a3,a3,600 # ffffffffc02b4fe8 <bigblocks>
ffffffffc0201d98:	a021                	j	ffffffffc0201da0 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201d9a:	01048693          	addi	a3,s1,16
ffffffffc0201d9e:	c3a5                	beqz	a5,ffffffffc0201dfe <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201da0:	6798                	ld	a4,8(a5)
ffffffffc0201da2:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201da4:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201da6:	fe871ae3          	bne	a4,s0,ffffffffc0201d9a <kfree+0x30>
				*last = bb->next;
ffffffffc0201daa:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0201dac:	ee2d                	bnez	a2,ffffffffc0201e26 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201dae:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201db2:	4098                	lw	a4,0(s1)
ffffffffc0201db4:	08f46963          	bltu	s0,a5,ffffffffc0201e46 <kfree+0xdc>
ffffffffc0201db8:	000b3697          	auipc	a3,0xb3
ffffffffc0201dbc:	2606b683          	ld	a3,608(a3) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0201dc0:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201dc2:	8031                	srli	s0,s0,0xc
ffffffffc0201dc4:	000b3797          	auipc	a5,0xb3
ffffffffc0201dc8:	23c7b783          	ld	a5,572(a5) # ffffffffc02b5000 <npage>
ffffffffc0201dcc:	06f47163          	bgeu	s0,a5,ffffffffc0201e2e <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201dd0:	00006517          	auipc	a0,0x6
ffffffffc0201dd4:	a8053503          	ld	a0,-1408(a0) # ffffffffc0207850 <nbase>
ffffffffc0201dd8:	8c09                	sub	s0,s0,a0
ffffffffc0201dda:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0201ddc:	000b3517          	auipc	a0,0xb3
ffffffffc0201de0:	22c53503          	ld	a0,556(a0) # ffffffffc02b5008 <pages>
ffffffffc0201de4:	4585                	li	a1,1
ffffffffc0201de6:	9522                	add	a0,a0,s0
ffffffffc0201de8:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201dec:	0ea000ef          	jal	ra,ffffffffc0201ed6 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201df0:	6442                	ld	s0,16(sp)
ffffffffc0201df2:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201df4:	8526                	mv	a0,s1
}
ffffffffc0201df6:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201df8:	45e1                	li	a1,24
}
ffffffffc0201dfa:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201dfc:	b171                	j	ffffffffc0201a88 <slob_free>
ffffffffc0201dfe:	e20d                	bnez	a2,ffffffffc0201e20 <kfree+0xb6>
ffffffffc0201e00:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201e04:	6442                	ld	s0,16(sp)
ffffffffc0201e06:	60e2                	ld	ra,24(sp)
ffffffffc0201e08:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e0a:	4581                	li	a1,0
}
ffffffffc0201e0c:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201e0e:	b9ad                	j	ffffffffc0201a88 <slob_free>
        intr_disable();
ffffffffc0201e10:	ba5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201e14:	000b3797          	auipc	a5,0xb3
ffffffffc0201e18:	1d47b783          	ld	a5,468(a5) # ffffffffc02b4fe8 <bigblocks>
        return 1;
ffffffffc0201e1c:	4605                	li	a2,1
ffffffffc0201e1e:	fbad                	bnez	a5,ffffffffc0201d90 <kfree+0x26>
        intr_enable();
ffffffffc0201e20:	b8ffe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e24:	bff1                	j	ffffffffc0201e00 <kfree+0x96>
ffffffffc0201e26:	b89fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0201e2a:	b751                	j	ffffffffc0201dae <kfree+0x44>
ffffffffc0201e2c:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201e2e:	00005617          	auipc	a2,0x5
ffffffffc0201e32:	82260613          	addi	a2,a2,-2014 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0201e36:	06900593          	li	a1,105
ffffffffc0201e3a:	00004517          	auipc	a0,0x4
ffffffffc0201e3e:	76e50513          	addi	a0,a0,1902 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0201e42:	e4cfe0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201e46:	86a2                	mv	a3,s0
ffffffffc0201e48:	00004617          	auipc	a2,0x4
ffffffffc0201e4c:	7e060613          	addi	a2,a2,2016 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0201e50:	07700593          	li	a1,119
ffffffffc0201e54:	00004517          	auipc	a0,0x4
ffffffffc0201e58:	75450513          	addi	a0,a0,1876 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0201e5c:	e32fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e60 <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201e60:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201e62:	00004617          	auipc	a2,0x4
ffffffffc0201e66:	7ee60613          	addi	a2,a2,2030 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0201e6a:	06900593          	li	a1,105
ffffffffc0201e6e:	00004517          	auipc	a0,0x4
ffffffffc0201e72:	73a50513          	addi	a0,a0,1850 # ffffffffc02065a8 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201e76:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201e78:	e16fe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e7c <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201e7c:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201e7e:	00004617          	auipc	a2,0x4
ffffffffc0201e82:	7f260613          	addi	a2,a2,2034 # ffffffffc0206670 <default_pmm_manager+0x128>
ffffffffc0201e86:	07f00593          	li	a1,127
ffffffffc0201e8a:	00004517          	auipc	a0,0x4
ffffffffc0201e8e:	71e50513          	addi	a0,a0,1822 # ffffffffc02065a8 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201e92:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201e94:	dfafe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0201e98 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201e98:	100027f3          	csrr	a5,sstatus
ffffffffc0201e9c:	8b89                	andi	a5,a5,2
ffffffffc0201e9e:	e799                	bnez	a5,ffffffffc0201eac <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ea0:	000b3797          	auipc	a5,0xb3
ffffffffc0201ea4:	1707b783          	ld	a5,368(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201ea8:	6f9c                	ld	a5,24(a5)
ffffffffc0201eaa:	8782                	jr	a5
{
ffffffffc0201eac:	1141                	addi	sp,sp,-16
ffffffffc0201eae:	e406                	sd	ra,8(sp)
ffffffffc0201eb0:	e022                	sd	s0,0(sp)
ffffffffc0201eb2:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201eb4:	b01fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201eb8:	000b3797          	auipc	a5,0xb3
ffffffffc0201ebc:	1587b783          	ld	a5,344(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201ec0:	6f9c                	ld	a5,24(a5)
ffffffffc0201ec2:	8522                	mv	a0,s0
ffffffffc0201ec4:	9782                	jalr	a5
ffffffffc0201ec6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ec8:	ae7fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201ecc:	60a2                	ld	ra,8(sp)
ffffffffc0201ece:	8522                	mv	a0,s0
ffffffffc0201ed0:	6402                	ld	s0,0(sp)
ffffffffc0201ed2:	0141                	addi	sp,sp,16
ffffffffc0201ed4:	8082                	ret

ffffffffc0201ed6 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201ed6:	100027f3          	csrr	a5,sstatus
ffffffffc0201eda:	8b89                	andi	a5,a5,2
ffffffffc0201edc:	e799                	bnez	a5,ffffffffc0201eea <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201ede:	000b3797          	auipc	a5,0xb3
ffffffffc0201ee2:	1327b783          	ld	a5,306(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201ee6:	739c                	ld	a5,32(a5)
ffffffffc0201ee8:	8782                	jr	a5
{
ffffffffc0201eea:	1101                	addi	sp,sp,-32
ffffffffc0201eec:	ec06                	sd	ra,24(sp)
ffffffffc0201eee:	e822                	sd	s0,16(sp)
ffffffffc0201ef0:	e426                	sd	s1,8(sp)
ffffffffc0201ef2:	842a                	mv	s0,a0
ffffffffc0201ef4:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201ef6:	abffe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201efa:	000b3797          	auipc	a5,0xb3
ffffffffc0201efe:	1167b783          	ld	a5,278(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f02:	739c                	ld	a5,32(a5)
ffffffffc0201f04:	85a6                	mv	a1,s1
ffffffffc0201f06:	8522                	mv	a0,s0
ffffffffc0201f08:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201f0a:	6442                	ld	s0,16(sp)
ffffffffc0201f0c:	60e2                	ld	ra,24(sp)
ffffffffc0201f0e:	64a2                	ld	s1,8(sp)
ffffffffc0201f10:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201f12:	a9dfe06f          	j	ffffffffc02009ae <intr_enable>

ffffffffc0201f16 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f16:	100027f3          	csrr	a5,sstatus
ffffffffc0201f1a:	8b89                	andi	a5,a5,2
ffffffffc0201f1c:	e799                	bnez	a5,ffffffffc0201f2a <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f1e:	000b3797          	auipc	a5,0xb3
ffffffffc0201f22:	0f27b783          	ld	a5,242(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f26:	779c                	ld	a5,40(a5)
ffffffffc0201f28:	8782                	jr	a5
{
ffffffffc0201f2a:	1141                	addi	sp,sp,-16
ffffffffc0201f2c:	e406                	sd	ra,8(sp)
ffffffffc0201f2e:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201f30:	a85fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f34:	000b3797          	auipc	a5,0xb3
ffffffffc0201f38:	0dc7b783          	ld	a5,220(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f3c:	779c                	ld	a5,40(a5)
ffffffffc0201f3e:	9782                	jalr	a5
ffffffffc0201f40:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f42:	a6dfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201f46:	60a2                	ld	ra,8(sp)
ffffffffc0201f48:	8522                	mv	a0,s0
ffffffffc0201f4a:	6402                	ld	s0,0(sp)
ffffffffc0201f4c:	0141                	addi	sp,sp,16
ffffffffc0201f4e:	8082                	ret

ffffffffc0201f50 <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f50:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201f54:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201f58:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f5a:	078e                	slli	a5,a5,0x3
{
ffffffffc0201f5c:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201f5e:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201f62:	6094                	ld	a3,0(s1)
{
ffffffffc0201f64:	f04a                	sd	s2,32(sp)
ffffffffc0201f66:	ec4e                	sd	s3,24(sp)
ffffffffc0201f68:	e852                	sd	s4,16(sp)
ffffffffc0201f6a:	fc06                	sd	ra,56(sp)
ffffffffc0201f6c:	f822                	sd	s0,48(sp)
ffffffffc0201f6e:	e456                	sd	s5,8(sp)
ffffffffc0201f70:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201f72:	0016f793          	andi	a5,a3,1
{
ffffffffc0201f76:	892e                	mv	s2,a1
ffffffffc0201f78:	8a32                	mv	s4,a2
ffffffffc0201f7a:	000b3997          	auipc	s3,0xb3
ffffffffc0201f7e:	08698993          	addi	s3,s3,134 # ffffffffc02b5000 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201f82:	efbd                	bnez	a5,ffffffffc0202000 <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201f84:	14060c63          	beqz	a2,ffffffffc02020dc <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201f88:	100027f3          	csrr	a5,sstatus
ffffffffc0201f8c:	8b89                	andi	a5,a5,2
ffffffffc0201f8e:	14079963          	bnez	a5,ffffffffc02020e0 <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f92:	000b3797          	auipc	a5,0xb3
ffffffffc0201f96:	07e7b783          	ld	a5,126(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0201f9a:	6f9c                	ld	a5,24(a5)
ffffffffc0201f9c:	4505                	li	a0,1
ffffffffc0201f9e:	9782                	jalr	a5
ffffffffc0201fa0:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201fa2:	12040d63          	beqz	s0,ffffffffc02020dc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201fa6:	000b3b17          	auipc	s6,0xb3
ffffffffc0201faa:	062b0b13          	addi	s6,s6,98 # ffffffffc02b5008 <pages>
ffffffffc0201fae:	000b3503          	ld	a0,0(s6)
ffffffffc0201fb2:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201fb6:	000b3997          	auipc	s3,0xb3
ffffffffc0201fba:	04a98993          	addi	s3,s3,74 # ffffffffc02b5000 <npage>
ffffffffc0201fbe:	40a40533          	sub	a0,s0,a0
ffffffffc0201fc2:	8519                	srai	a0,a0,0x6
ffffffffc0201fc4:	9556                	add	a0,a0,s5
ffffffffc0201fc6:	0009b703          	ld	a4,0(s3)
ffffffffc0201fca:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201fce:	4685                	li	a3,1
ffffffffc0201fd0:	c014                	sw	a3,0(s0)
ffffffffc0201fd2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201fd4:	0532                	slli	a0,a0,0xc
ffffffffc0201fd6:	16e7f763          	bgeu	a5,a4,ffffffffc0202144 <get_pte+0x1f4>
ffffffffc0201fda:	000b3797          	auipc	a5,0xb3
ffffffffc0201fde:	03e7b783          	ld	a5,62(a5) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0201fe2:	6605                	lui	a2,0x1
ffffffffc0201fe4:	4581                	li	a1,0
ffffffffc0201fe6:	953e                	add	a0,a0,a5
ffffffffc0201fe8:	6f2030ef          	jal	ra,ffffffffc02056da <memset>
    return page - pages + nbase;
ffffffffc0201fec:	000b3683          	ld	a3,0(s6)
ffffffffc0201ff0:	40d406b3          	sub	a3,s0,a3
ffffffffc0201ff4:	8699                	srai	a3,a3,0x6
ffffffffc0201ff6:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201ff8:	06aa                	slli	a3,a3,0xa
ffffffffc0201ffa:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201ffe:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0202000:	77fd                	lui	a5,0xfffff
ffffffffc0202002:	068a                	slli	a3,a3,0x2
ffffffffc0202004:	0009b703          	ld	a4,0(s3)
ffffffffc0202008:	8efd                	and	a3,a3,a5
ffffffffc020200a:	00c6d793          	srli	a5,a3,0xc
ffffffffc020200e:	10e7ff63          	bgeu	a5,a4,ffffffffc020212c <get_pte+0x1dc>
ffffffffc0202012:	000b3a97          	auipc	s5,0xb3
ffffffffc0202016:	006a8a93          	addi	s5,s5,6 # ffffffffc02b5018 <va_pa_offset>
ffffffffc020201a:	000ab403          	ld	s0,0(s5)
ffffffffc020201e:	01595793          	srli	a5,s2,0x15
ffffffffc0202022:	1ff7f793          	andi	a5,a5,511
ffffffffc0202026:	96a2                	add	a3,a3,s0
ffffffffc0202028:	00379413          	slli	s0,a5,0x3
ffffffffc020202c:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc020202e:	6014                	ld	a3,0(s0)
ffffffffc0202030:	0016f793          	andi	a5,a3,1
ffffffffc0202034:	ebad                	bnez	a5,ffffffffc02020a6 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202036:	0a0a0363          	beqz	s4,ffffffffc02020dc <get_pte+0x18c>
ffffffffc020203a:	100027f3          	csrr	a5,sstatus
ffffffffc020203e:	8b89                	andi	a5,a5,2
ffffffffc0202040:	efcd                	bnez	a5,ffffffffc02020fa <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202042:	000b3797          	auipc	a5,0xb3
ffffffffc0202046:	fce7b783          	ld	a5,-50(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc020204a:	6f9c                	ld	a5,24(a5)
ffffffffc020204c:	4505                	li	a0,1
ffffffffc020204e:	9782                	jalr	a5
ffffffffc0202050:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0202052:	c4c9                	beqz	s1,ffffffffc02020dc <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0202054:	000b3b17          	auipc	s6,0xb3
ffffffffc0202058:	fb4b0b13          	addi	s6,s6,-76 # ffffffffc02b5008 <pages>
ffffffffc020205c:	000b3503          	ld	a0,0(s6)
ffffffffc0202060:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202064:	0009b703          	ld	a4,0(s3)
ffffffffc0202068:	40a48533          	sub	a0,s1,a0
ffffffffc020206c:	8519                	srai	a0,a0,0x6
ffffffffc020206e:	9552                	add	a0,a0,s4
ffffffffc0202070:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0202074:	4685                	li	a3,1
ffffffffc0202076:	c094                	sw	a3,0(s1)
ffffffffc0202078:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020207a:	0532                	slli	a0,a0,0xc
ffffffffc020207c:	0ee7f163          	bgeu	a5,a4,ffffffffc020215e <get_pte+0x20e>
ffffffffc0202080:	000ab783          	ld	a5,0(s5)
ffffffffc0202084:	6605                	lui	a2,0x1
ffffffffc0202086:	4581                	li	a1,0
ffffffffc0202088:	953e                	add	a0,a0,a5
ffffffffc020208a:	650030ef          	jal	ra,ffffffffc02056da <memset>
    return page - pages + nbase;
ffffffffc020208e:	000b3683          	ld	a3,0(s6)
ffffffffc0202092:	40d486b3          	sub	a3,s1,a3
ffffffffc0202096:	8699                	srai	a3,a3,0x6
ffffffffc0202098:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc020209a:	06aa                	slli	a3,a3,0xa
ffffffffc020209c:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02020a0:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02020a2:	0009b703          	ld	a4,0(s3)
ffffffffc02020a6:	068a                	slli	a3,a3,0x2
ffffffffc02020a8:	757d                	lui	a0,0xfffff
ffffffffc02020aa:	8ee9                	and	a3,a3,a0
ffffffffc02020ac:	00c6d793          	srli	a5,a3,0xc
ffffffffc02020b0:	06e7f263          	bgeu	a5,a4,ffffffffc0202114 <get_pte+0x1c4>
ffffffffc02020b4:	000ab503          	ld	a0,0(s5)
ffffffffc02020b8:	00c95913          	srli	s2,s2,0xc
ffffffffc02020bc:	1ff97913          	andi	s2,s2,511
ffffffffc02020c0:	96aa                	add	a3,a3,a0
ffffffffc02020c2:	00391513          	slli	a0,s2,0x3
ffffffffc02020c6:	9536                	add	a0,a0,a3
}
ffffffffc02020c8:	70e2                	ld	ra,56(sp)
ffffffffc02020ca:	7442                	ld	s0,48(sp)
ffffffffc02020cc:	74a2                	ld	s1,40(sp)
ffffffffc02020ce:	7902                	ld	s2,32(sp)
ffffffffc02020d0:	69e2                	ld	s3,24(sp)
ffffffffc02020d2:	6a42                	ld	s4,16(sp)
ffffffffc02020d4:	6aa2                	ld	s5,8(sp)
ffffffffc02020d6:	6b02                	ld	s6,0(sp)
ffffffffc02020d8:	6121                	addi	sp,sp,64
ffffffffc02020da:	8082                	ret
            return NULL;
ffffffffc02020dc:	4501                	li	a0,0
ffffffffc02020de:	b7ed                	j	ffffffffc02020c8 <get_pte+0x178>
        intr_disable();
ffffffffc02020e0:	8d5fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02020e4:	000b3797          	auipc	a5,0xb3
ffffffffc02020e8:	f2c7b783          	ld	a5,-212(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc02020ec:	6f9c                	ld	a5,24(a5)
ffffffffc02020ee:	4505                	li	a0,1
ffffffffc02020f0:	9782                	jalr	a5
ffffffffc02020f2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02020f4:	8bbfe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02020f8:	b56d                	j	ffffffffc0201fa2 <get_pte+0x52>
        intr_disable();
ffffffffc02020fa:	8bbfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02020fe:	000b3797          	auipc	a5,0xb3
ffffffffc0202102:	f127b783          	ld	a5,-238(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0202106:	6f9c                	ld	a5,24(a5)
ffffffffc0202108:	4505                	li	a0,1
ffffffffc020210a:	9782                	jalr	a5
ffffffffc020210c:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020210e:	8a1fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202112:	b781                	j	ffffffffc0202052 <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0202114:	00004617          	auipc	a2,0x4
ffffffffc0202118:	46c60613          	addi	a2,a2,1132 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc020211c:	0fa00593          	li	a1,250
ffffffffc0202120:	00004517          	auipc	a0,0x4
ffffffffc0202124:	57850513          	addi	a0,a0,1400 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202128:	b66fe0ef          	jal	ra,ffffffffc020048e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020212c:	00004617          	auipc	a2,0x4
ffffffffc0202130:	45460613          	addi	a2,a2,1108 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202134:	0ed00593          	li	a1,237
ffffffffc0202138:	00004517          	auipc	a0,0x4
ffffffffc020213c:	56050513          	addi	a0,a0,1376 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202140:	b4efe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0202144:	86aa                	mv	a3,a0
ffffffffc0202146:	00004617          	auipc	a2,0x4
ffffffffc020214a:	43a60613          	addi	a2,a2,1082 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc020214e:	0e900593          	li	a1,233
ffffffffc0202152:	00004517          	auipc	a0,0x4
ffffffffc0202156:	54650513          	addi	a0,a0,1350 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020215a:	b34fe0ef          	jal	ra,ffffffffc020048e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020215e:	86aa                	mv	a3,a0
ffffffffc0202160:	00004617          	auipc	a2,0x4
ffffffffc0202164:	42060613          	addi	a2,a2,1056 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202168:	0f700593          	li	a1,247
ffffffffc020216c:	00004517          	auipc	a0,0x4
ffffffffc0202170:	52c50513          	addi	a0,a0,1324 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202174:	b1afe0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0202178 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0202178:	1141                	addi	sp,sp,-16
ffffffffc020217a:	e022                	sd	s0,0(sp)
ffffffffc020217c:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020217e:	4601                	li	a2,0
{
ffffffffc0202180:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0202182:	dcfff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
    if (ptep_store != NULL)
ffffffffc0202186:	c011                	beqz	s0,ffffffffc020218a <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0202188:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020218a:	c511                	beqz	a0,ffffffffc0202196 <get_page+0x1e>
ffffffffc020218c:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020218e:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0202190:	0017f713          	andi	a4,a5,1
ffffffffc0202194:	e709                	bnez	a4,ffffffffc020219e <get_page+0x26>
}
ffffffffc0202196:	60a2                	ld	ra,8(sp)
ffffffffc0202198:	6402                	ld	s0,0(sp)
ffffffffc020219a:	0141                	addi	sp,sp,16
ffffffffc020219c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020219e:	078a                	slli	a5,a5,0x2
ffffffffc02021a0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02021a2:	000b3717          	auipc	a4,0xb3
ffffffffc02021a6:	e5e73703          	ld	a4,-418(a4) # ffffffffc02b5000 <npage>
ffffffffc02021aa:	00e7ff63          	bgeu	a5,a4,ffffffffc02021c8 <get_page+0x50>
ffffffffc02021ae:	60a2                	ld	ra,8(sp)
ffffffffc02021b0:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc02021b2:	fff80537          	lui	a0,0xfff80
ffffffffc02021b6:	97aa                	add	a5,a5,a0
ffffffffc02021b8:	079a                	slli	a5,a5,0x6
ffffffffc02021ba:	000b3517          	auipc	a0,0xb3
ffffffffc02021be:	e4e53503          	ld	a0,-434(a0) # ffffffffc02b5008 <pages>
ffffffffc02021c2:	953e                	add	a0,a0,a5
ffffffffc02021c4:	0141                	addi	sp,sp,16
ffffffffc02021c6:	8082                	ret
ffffffffc02021c8:	c99ff0ef          	jal	ra,ffffffffc0201e60 <pa2page.part.0>

ffffffffc02021cc <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc02021cc:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021ce:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc02021d2:	f486                	sd	ra,104(sp)
ffffffffc02021d4:	f0a2                	sd	s0,96(sp)
ffffffffc02021d6:	eca6                	sd	s1,88(sp)
ffffffffc02021d8:	e8ca                	sd	s2,80(sp)
ffffffffc02021da:	e4ce                	sd	s3,72(sp)
ffffffffc02021dc:	e0d2                	sd	s4,64(sp)
ffffffffc02021de:	fc56                	sd	s5,56(sp)
ffffffffc02021e0:	f85a                	sd	s6,48(sp)
ffffffffc02021e2:	f45e                	sd	s7,40(sp)
ffffffffc02021e4:	f062                	sd	s8,32(sp)
ffffffffc02021e6:	ec66                	sd	s9,24(sp)
ffffffffc02021e8:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02021ea:	17d2                	slli	a5,a5,0x34
ffffffffc02021ec:	e3ed                	bnez	a5,ffffffffc02022ce <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc02021ee:	002007b7          	lui	a5,0x200
ffffffffc02021f2:	842e                	mv	s0,a1
ffffffffc02021f4:	0ef5ed63          	bltu	a1,a5,ffffffffc02022ee <unmap_range+0x122>
ffffffffc02021f8:	8932                	mv	s2,a2
ffffffffc02021fa:	0ec5fa63          	bgeu	a1,a2,ffffffffc02022ee <unmap_range+0x122>
ffffffffc02021fe:	4785                	li	a5,1
ffffffffc0202200:	07fe                	slli	a5,a5,0x1f
ffffffffc0202202:	0ec7e663          	bltu	a5,a2,ffffffffc02022ee <unmap_range+0x122>
ffffffffc0202206:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0202208:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc020220a:	000b3c97          	auipc	s9,0xb3
ffffffffc020220e:	df6c8c93          	addi	s9,s9,-522 # ffffffffc02b5000 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc0202212:	000b3c17          	auipc	s8,0xb3
ffffffffc0202216:	df6c0c13          	addi	s8,s8,-522 # ffffffffc02b5008 <pages>
ffffffffc020221a:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc020221e:	000b3d17          	auipc	s10,0xb3
ffffffffc0202222:	df2d0d13          	addi	s10,s10,-526 # ffffffffc02b5010 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202226:	00200b37          	lui	s6,0x200
ffffffffc020222a:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc020222e:	4601                	li	a2,0
ffffffffc0202230:	85a2                	mv	a1,s0
ffffffffc0202232:	854e                	mv	a0,s3
ffffffffc0202234:	d1dff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
ffffffffc0202238:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020223a:	cd29                	beqz	a0,ffffffffc0202294 <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc020223c:	611c                	ld	a5,0(a0)
ffffffffc020223e:	e395                	bnez	a5,ffffffffc0202262 <unmap_range+0x96>
        start += PGSIZE;
ffffffffc0202240:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202242:	ff2466e3          	bltu	s0,s2,ffffffffc020222e <unmap_range+0x62>
}
ffffffffc0202246:	70a6                	ld	ra,104(sp)
ffffffffc0202248:	7406                	ld	s0,96(sp)
ffffffffc020224a:	64e6                	ld	s1,88(sp)
ffffffffc020224c:	6946                	ld	s2,80(sp)
ffffffffc020224e:	69a6                	ld	s3,72(sp)
ffffffffc0202250:	6a06                	ld	s4,64(sp)
ffffffffc0202252:	7ae2                	ld	s5,56(sp)
ffffffffc0202254:	7b42                	ld	s6,48(sp)
ffffffffc0202256:	7ba2                	ld	s7,40(sp)
ffffffffc0202258:	7c02                	ld	s8,32(sp)
ffffffffc020225a:	6ce2                	ld	s9,24(sp)
ffffffffc020225c:	6d42                	ld	s10,16(sp)
ffffffffc020225e:	6165                	addi	sp,sp,112
ffffffffc0202260:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc0202262:	0017f713          	andi	a4,a5,1
ffffffffc0202266:	df69                	beqz	a4,ffffffffc0202240 <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc0202268:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc020226c:	078a                	slli	a5,a5,0x2
ffffffffc020226e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202270:	08e7ff63          	bgeu	a5,a4,ffffffffc020230e <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc0202274:	000c3503          	ld	a0,0(s8)
ffffffffc0202278:	97de                	add	a5,a5,s7
ffffffffc020227a:	079a                	slli	a5,a5,0x6
ffffffffc020227c:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc020227e:	411c                	lw	a5,0(a0)
ffffffffc0202280:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202284:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc0202286:	cf11                	beqz	a4,ffffffffc02022a2 <unmap_range+0xd6>
        *ptep = 0;
ffffffffc0202288:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020228c:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc0202290:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc0202292:	bf45                	j	ffffffffc0202242 <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202294:	945a                	add	s0,s0,s6
ffffffffc0202296:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc020229a:	d455                	beqz	s0,ffffffffc0202246 <unmap_range+0x7a>
ffffffffc020229c:	f92469e3          	bltu	s0,s2,ffffffffc020222e <unmap_range+0x62>
ffffffffc02022a0:	b75d                	j	ffffffffc0202246 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02022a2:	100027f3          	csrr	a5,sstatus
ffffffffc02022a6:	8b89                	andi	a5,a5,2
ffffffffc02022a8:	e799                	bnez	a5,ffffffffc02022b6 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc02022aa:	000d3783          	ld	a5,0(s10)
ffffffffc02022ae:	4585                	li	a1,1
ffffffffc02022b0:	739c                	ld	a5,32(a5)
ffffffffc02022b2:	9782                	jalr	a5
    if (flag)
ffffffffc02022b4:	bfd1                	j	ffffffffc0202288 <unmap_range+0xbc>
ffffffffc02022b6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02022b8:	efcfe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc02022bc:	000d3783          	ld	a5,0(s10)
ffffffffc02022c0:	6522                	ld	a0,8(sp)
ffffffffc02022c2:	4585                	li	a1,1
ffffffffc02022c4:	739c                	ld	a5,32(a5)
ffffffffc02022c6:	9782                	jalr	a5
        intr_enable();
ffffffffc02022c8:	ee6fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02022cc:	bf75                	j	ffffffffc0202288 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02022ce:	00004697          	auipc	a3,0x4
ffffffffc02022d2:	3da68693          	addi	a3,a3,986 # ffffffffc02066a8 <default_pmm_manager+0x160>
ffffffffc02022d6:	00004617          	auipc	a2,0x4
ffffffffc02022da:	c9260613          	addi	a2,a2,-878 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02022de:	12000593          	li	a1,288
ffffffffc02022e2:	00004517          	auipc	a0,0x4
ffffffffc02022e6:	3b650513          	addi	a0,a0,950 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02022ea:	9a4fe0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02022ee:	00004697          	auipc	a3,0x4
ffffffffc02022f2:	3ea68693          	addi	a3,a3,1002 # ffffffffc02066d8 <default_pmm_manager+0x190>
ffffffffc02022f6:	00004617          	auipc	a2,0x4
ffffffffc02022fa:	c7260613          	addi	a2,a2,-910 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02022fe:	12100593          	li	a1,289
ffffffffc0202302:	00004517          	auipc	a0,0x4
ffffffffc0202306:	39650513          	addi	a0,a0,918 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020230a:	984fe0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc020230e:	b53ff0ef          	jal	ra,ffffffffc0201e60 <pa2page.part.0>

ffffffffc0202312 <exit_range>:
{
ffffffffc0202312:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202314:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0202318:	fc86                	sd	ra,120(sp)
ffffffffc020231a:	f8a2                	sd	s0,112(sp)
ffffffffc020231c:	f4a6                	sd	s1,104(sp)
ffffffffc020231e:	f0ca                	sd	s2,96(sp)
ffffffffc0202320:	ecce                	sd	s3,88(sp)
ffffffffc0202322:	e8d2                	sd	s4,80(sp)
ffffffffc0202324:	e4d6                	sd	s5,72(sp)
ffffffffc0202326:	e0da                	sd	s6,64(sp)
ffffffffc0202328:	fc5e                	sd	s7,56(sp)
ffffffffc020232a:	f862                	sd	s8,48(sp)
ffffffffc020232c:	f466                	sd	s9,40(sp)
ffffffffc020232e:	f06a                	sd	s10,32(sp)
ffffffffc0202330:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202332:	17d2                	slli	a5,a5,0x34
ffffffffc0202334:	20079a63          	bnez	a5,ffffffffc0202548 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0202338:	002007b7          	lui	a5,0x200
ffffffffc020233c:	24f5e463          	bltu	a1,a5,ffffffffc0202584 <exit_range+0x272>
ffffffffc0202340:	8ab2                	mv	s5,a2
ffffffffc0202342:	24c5f163          	bgeu	a1,a2,ffffffffc0202584 <exit_range+0x272>
ffffffffc0202346:	4785                	li	a5,1
ffffffffc0202348:	07fe                	slli	a5,a5,0x1f
ffffffffc020234a:	22c7ed63          	bltu	a5,a2,ffffffffc0202584 <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc020234e:	c00009b7          	lui	s3,0xc0000
ffffffffc0202352:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc0202356:	ffe00937          	lui	s2,0xffe00
ffffffffc020235a:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc020235e:	5cfd                	li	s9,-1
ffffffffc0202360:	8c2a                	mv	s8,a0
ffffffffc0202362:	0125f933          	and	s2,a1,s2
ffffffffc0202366:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc0202368:	000b3d17          	auipc	s10,0xb3
ffffffffc020236c:	c98d0d13          	addi	s10,s10,-872 # ffffffffc02b5000 <npage>
    return KADDR(page2pa(page));
ffffffffc0202370:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc0202374:	000b3717          	auipc	a4,0xb3
ffffffffc0202378:	c9470713          	addi	a4,a4,-876 # ffffffffc02b5008 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc020237c:	000b3d97          	auipc	s11,0xb3
ffffffffc0202380:	c94d8d93          	addi	s11,s11,-876 # ffffffffc02b5010 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc0202384:	c0000437          	lui	s0,0xc0000
ffffffffc0202388:	944e                	add	s0,s0,s3
ffffffffc020238a:	8079                	srli	s0,s0,0x1e
ffffffffc020238c:	1ff47413          	andi	s0,s0,511
ffffffffc0202390:	040e                	slli	s0,s0,0x3
ffffffffc0202392:	9462                	add	s0,s0,s8
ffffffffc0202394:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
        if (pde1 & PTE_V)
ffffffffc0202398:	001a7793          	andi	a5,s4,1
ffffffffc020239c:	eb99                	bnez	a5,ffffffffc02023b2 <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc020239e:	12098463          	beqz	s3,ffffffffc02024c6 <exit_range+0x1b4>
ffffffffc02023a2:	400007b7          	lui	a5,0x40000
ffffffffc02023a6:	97ce                	add	a5,a5,s3
ffffffffc02023a8:	894e                	mv	s2,s3
ffffffffc02023aa:	1159fe63          	bgeu	s3,s5,ffffffffc02024c6 <exit_range+0x1b4>
ffffffffc02023ae:	89be                	mv	s3,a5
ffffffffc02023b0:	bfd1                	j	ffffffffc0202384 <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc02023b2:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc02023b6:	0a0a                	slli	s4,s4,0x2
ffffffffc02023b8:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc02023bc:	1cfa7263          	bgeu	s4,a5,ffffffffc0202580 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02023c0:	fff80637          	lui	a2,0xfff80
ffffffffc02023c4:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc02023c6:	000806b7          	lui	a3,0x80
ffffffffc02023ca:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02023cc:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc02023d0:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc02023d2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02023d4:	18f5fa63          	bgeu	a1,a5,ffffffffc0202568 <exit_range+0x256>
ffffffffc02023d8:	000b3817          	auipc	a6,0xb3
ffffffffc02023dc:	c4080813          	addi	a6,a6,-960 # ffffffffc02b5018 <va_pa_offset>
ffffffffc02023e0:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc02023e4:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc02023e6:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc02023ea:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc02023ec:	00080337          	lui	t1,0x80
ffffffffc02023f0:	6885                	lui	a7,0x1
ffffffffc02023f2:	a819                	j	ffffffffc0202408 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc02023f4:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc02023f6:	002007b7          	lui	a5,0x200
ffffffffc02023fa:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02023fc:	08090c63          	beqz	s2,ffffffffc0202494 <exit_range+0x182>
ffffffffc0202400:	09397a63          	bgeu	s2,s3,ffffffffc0202494 <exit_range+0x182>
ffffffffc0202404:	0f597063          	bgeu	s2,s5,ffffffffc02024e4 <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0202408:	01595493          	srli	s1,s2,0x15
ffffffffc020240c:	1ff4f493          	andi	s1,s1,511
ffffffffc0202410:	048e                	slli	s1,s1,0x3
ffffffffc0202412:	94da                	add	s1,s1,s6
ffffffffc0202414:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0202416:	0017f693          	andi	a3,a5,1
ffffffffc020241a:	dee9                	beqz	a3,ffffffffc02023f4 <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc020241c:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202420:	078a                	slli	a5,a5,0x2
ffffffffc0202422:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202424:	14b7fe63          	bgeu	a5,a1,ffffffffc0202580 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0202428:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc020242a:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc020242e:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc0202432:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0202436:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202438:	12bef863          	bgeu	t4,a1,ffffffffc0202568 <exit_range+0x256>
ffffffffc020243c:	00083783          	ld	a5,0(a6)
ffffffffc0202440:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc0202442:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc0202446:	629c                	ld	a5,0(a3)
ffffffffc0202448:	8b85                	andi	a5,a5,1
ffffffffc020244a:	f7d5                	bnez	a5,ffffffffc02023f6 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020244c:	06a1                	addi	a3,a3,8
ffffffffc020244e:	fed59ce3          	bne	a1,a3,ffffffffc0202446 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc0202452:	631c                	ld	a5,0(a4)
ffffffffc0202454:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202456:	100027f3          	csrr	a5,sstatus
ffffffffc020245a:	8b89                	andi	a5,a5,2
ffffffffc020245c:	e7d9                	bnez	a5,ffffffffc02024ea <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc020245e:	000db783          	ld	a5,0(s11)
ffffffffc0202462:	4585                	li	a1,1
ffffffffc0202464:	e032                	sd	a2,0(sp)
ffffffffc0202466:	739c                	ld	a5,32(a5)
ffffffffc0202468:	9782                	jalr	a5
    if (flag)
ffffffffc020246a:	6602                	ld	a2,0(sp)
ffffffffc020246c:	000b3817          	auipc	a6,0xb3
ffffffffc0202470:	bac80813          	addi	a6,a6,-1108 # ffffffffc02b5018 <va_pa_offset>
ffffffffc0202474:	fff80e37          	lui	t3,0xfff80
ffffffffc0202478:	00080337          	lui	t1,0x80
ffffffffc020247c:	6885                	lui	a7,0x1
ffffffffc020247e:	000b3717          	auipc	a4,0xb3
ffffffffc0202482:	b8a70713          	addi	a4,a4,-1142 # ffffffffc02b5008 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0202486:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc020248a:	002007b7          	lui	a5,0x200
ffffffffc020248e:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0202490:	f60918e3          	bnez	s2,ffffffffc0202400 <exit_range+0xee>
            if (free_pd0)
ffffffffc0202494:	f00b85e3          	beqz	s7,ffffffffc020239e <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc0202498:	000d3783          	ld	a5,0(s10)
ffffffffc020249c:	0efa7263          	bgeu	s4,a5,ffffffffc0202580 <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02024a0:	6308                	ld	a0,0(a4)
ffffffffc02024a2:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02024a4:	100027f3          	csrr	a5,sstatus
ffffffffc02024a8:	8b89                	andi	a5,a5,2
ffffffffc02024aa:	efad                	bnez	a5,ffffffffc0202524 <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc02024ac:	000db783          	ld	a5,0(s11)
ffffffffc02024b0:	4585                	li	a1,1
ffffffffc02024b2:	739c                	ld	a5,32(a5)
ffffffffc02024b4:	9782                	jalr	a5
ffffffffc02024b6:	000b3717          	auipc	a4,0xb3
ffffffffc02024ba:	b5270713          	addi	a4,a4,-1198 # ffffffffc02b5008 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc02024be:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc02024c2:	ee0990e3          	bnez	s3,ffffffffc02023a2 <exit_range+0x90>
}
ffffffffc02024c6:	70e6                	ld	ra,120(sp)
ffffffffc02024c8:	7446                	ld	s0,112(sp)
ffffffffc02024ca:	74a6                	ld	s1,104(sp)
ffffffffc02024cc:	7906                	ld	s2,96(sp)
ffffffffc02024ce:	69e6                	ld	s3,88(sp)
ffffffffc02024d0:	6a46                	ld	s4,80(sp)
ffffffffc02024d2:	6aa6                	ld	s5,72(sp)
ffffffffc02024d4:	6b06                	ld	s6,64(sp)
ffffffffc02024d6:	7be2                	ld	s7,56(sp)
ffffffffc02024d8:	7c42                	ld	s8,48(sp)
ffffffffc02024da:	7ca2                	ld	s9,40(sp)
ffffffffc02024dc:	7d02                	ld	s10,32(sp)
ffffffffc02024de:	6de2                	ld	s11,24(sp)
ffffffffc02024e0:	6109                	addi	sp,sp,128
ffffffffc02024e2:	8082                	ret
            if (free_pd0)
ffffffffc02024e4:	ea0b8fe3          	beqz	s7,ffffffffc02023a2 <exit_range+0x90>
ffffffffc02024e8:	bf45                	j	ffffffffc0202498 <exit_range+0x186>
ffffffffc02024ea:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc02024ec:	e42a                	sd	a0,8(sp)
ffffffffc02024ee:	cc6fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02024f2:	000db783          	ld	a5,0(s11)
ffffffffc02024f6:	6522                	ld	a0,8(sp)
ffffffffc02024f8:	4585                	li	a1,1
ffffffffc02024fa:	739c                	ld	a5,32(a5)
ffffffffc02024fc:	9782                	jalr	a5
        intr_enable();
ffffffffc02024fe:	cb0fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202502:	6602                	ld	a2,0(sp)
ffffffffc0202504:	000b3717          	auipc	a4,0xb3
ffffffffc0202508:	b0470713          	addi	a4,a4,-1276 # ffffffffc02b5008 <pages>
ffffffffc020250c:	6885                	lui	a7,0x1
ffffffffc020250e:	00080337          	lui	t1,0x80
ffffffffc0202512:	fff80e37          	lui	t3,0xfff80
ffffffffc0202516:	000b3817          	auipc	a6,0xb3
ffffffffc020251a:	b0280813          	addi	a6,a6,-1278 # ffffffffc02b5018 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc020251e:	0004b023          	sd	zero,0(s1)
ffffffffc0202522:	b7a5                	j	ffffffffc020248a <exit_range+0x178>
ffffffffc0202524:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0202526:	c8efe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020252a:	000db783          	ld	a5,0(s11)
ffffffffc020252e:	6502                	ld	a0,0(sp)
ffffffffc0202530:	4585                	li	a1,1
ffffffffc0202532:	739c                	ld	a5,32(a5)
ffffffffc0202534:	9782                	jalr	a5
        intr_enable();
ffffffffc0202536:	c78fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020253a:	000b3717          	auipc	a4,0xb3
ffffffffc020253e:	ace70713          	addi	a4,a4,-1330 # ffffffffc02b5008 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0202542:	00043023          	sd	zero,0(s0)
ffffffffc0202546:	bfb5                	j	ffffffffc02024c2 <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202548:	00004697          	auipc	a3,0x4
ffffffffc020254c:	16068693          	addi	a3,a3,352 # ffffffffc02066a8 <default_pmm_manager+0x160>
ffffffffc0202550:	00004617          	auipc	a2,0x4
ffffffffc0202554:	a1860613          	addi	a2,a2,-1512 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202558:	13500593          	li	a1,309
ffffffffc020255c:	00004517          	auipc	a0,0x4
ffffffffc0202560:	13c50513          	addi	a0,a0,316 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202564:	f2bfd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202568:	00004617          	auipc	a2,0x4
ffffffffc020256c:	01860613          	addi	a2,a2,24 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202570:	07100593          	li	a1,113
ffffffffc0202574:	00004517          	auipc	a0,0x4
ffffffffc0202578:	03450513          	addi	a0,a0,52 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc020257c:	f13fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202580:	8e1ff0ef          	jal	ra,ffffffffc0201e60 <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc0202584:	00004697          	auipc	a3,0x4
ffffffffc0202588:	15468693          	addi	a3,a3,340 # ffffffffc02066d8 <default_pmm_manager+0x190>
ffffffffc020258c:	00004617          	auipc	a2,0x4
ffffffffc0202590:	9dc60613          	addi	a2,a2,-1572 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202594:	13600593          	li	a1,310
ffffffffc0202598:	00004517          	auipc	a0,0x4
ffffffffc020259c:	10050513          	addi	a0,a0,256 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02025a0:	eeffd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02025a4 <page_remove>:
{
ffffffffc02025a4:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025a6:	4601                	li	a2,0
{
ffffffffc02025a8:	ec26                	sd	s1,24(sp)
ffffffffc02025aa:	f406                	sd	ra,40(sp)
ffffffffc02025ac:	f022                	sd	s0,32(sp)
ffffffffc02025ae:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02025b0:	9a1ff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
    if (ptep != NULL)
ffffffffc02025b4:	c511                	beqz	a0,ffffffffc02025c0 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc02025b6:	611c                	ld	a5,0(a0)
ffffffffc02025b8:	842a                	mv	s0,a0
ffffffffc02025ba:	0017f713          	andi	a4,a5,1
ffffffffc02025be:	e711                	bnez	a4,ffffffffc02025ca <page_remove+0x26>
}
ffffffffc02025c0:	70a2                	ld	ra,40(sp)
ffffffffc02025c2:	7402                	ld	s0,32(sp)
ffffffffc02025c4:	64e2                	ld	s1,24(sp)
ffffffffc02025c6:	6145                	addi	sp,sp,48
ffffffffc02025c8:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02025ca:	078a                	slli	a5,a5,0x2
ffffffffc02025cc:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02025ce:	000b3717          	auipc	a4,0xb3
ffffffffc02025d2:	a3273703          	ld	a4,-1486(a4) # ffffffffc02b5000 <npage>
ffffffffc02025d6:	06e7f363          	bgeu	a5,a4,ffffffffc020263c <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc02025da:	fff80537          	lui	a0,0xfff80
ffffffffc02025de:	97aa                	add	a5,a5,a0
ffffffffc02025e0:	079a                	slli	a5,a5,0x6
ffffffffc02025e2:	000b3517          	auipc	a0,0xb3
ffffffffc02025e6:	a2653503          	ld	a0,-1498(a0) # ffffffffc02b5008 <pages>
ffffffffc02025ea:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02025ec:	411c                	lw	a5,0(a0)
ffffffffc02025ee:	fff7871b          	addiw	a4,a5,-1
ffffffffc02025f2:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02025f4:	cb11                	beqz	a4,ffffffffc0202608 <page_remove+0x64>
        *ptep = 0;
ffffffffc02025f6:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02025fa:	12048073          	sfence.vma	s1
}
ffffffffc02025fe:	70a2                	ld	ra,40(sp)
ffffffffc0202600:	7402                	ld	s0,32(sp)
ffffffffc0202602:	64e2                	ld	s1,24(sp)
ffffffffc0202604:	6145                	addi	sp,sp,48
ffffffffc0202606:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202608:	100027f3          	csrr	a5,sstatus
ffffffffc020260c:	8b89                	andi	a5,a5,2
ffffffffc020260e:	eb89                	bnez	a5,ffffffffc0202620 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202610:	000b3797          	auipc	a5,0xb3
ffffffffc0202614:	a007b783          	ld	a5,-1536(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0202618:	739c                	ld	a5,32(a5)
ffffffffc020261a:	4585                	li	a1,1
ffffffffc020261c:	9782                	jalr	a5
    if (flag)
ffffffffc020261e:	bfe1                	j	ffffffffc02025f6 <page_remove+0x52>
        intr_disable();
ffffffffc0202620:	e42a                	sd	a0,8(sp)
ffffffffc0202622:	b92fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202626:	000b3797          	auipc	a5,0xb3
ffffffffc020262a:	9ea7b783          	ld	a5,-1558(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc020262e:	739c                	ld	a5,32(a5)
ffffffffc0202630:	6522                	ld	a0,8(sp)
ffffffffc0202632:	4585                	li	a1,1
ffffffffc0202634:	9782                	jalr	a5
        intr_enable();
ffffffffc0202636:	b78fe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020263a:	bf75                	j	ffffffffc02025f6 <page_remove+0x52>
ffffffffc020263c:	825ff0ef          	jal	ra,ffffffffc0201e60 <pa2page.part.0>

ffffffffc0202640 <page_insert>:
{
ffffffffc0202640:	7139                	addi	sp,sp,-64
ffffffffc0202642:	e852                	sd	s4,16(sp)
ffffffffc0202644:	8a32                	mv	s4,a2
ffffffffc0202646:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202648:	4605                	li	a2,1
{
ffffffffc020264a:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020264c:	85d2                	mv	a1,s4
{
ffffffffc020264e:	f426                	sd	s1,40(sp)
ffffffffc0202650:	fc06                	sd	ra,56(sp)
ffffffffc0202652:	f04a                	sd	s2,32(sp)
ffffffffc0202654:	ec4e                	sd	s3,24(sp)
ffffffffc0202656:	e456                	sd	s5,8(sp)
ffffffffc0202658:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020265a:	8f7ff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
    if (ptep == NULL)
ffffffffc020265e:	c961                	beqz	a0,ffffffffc020272e <page_insert+0xee>
    page->ref += 1;
ffffffffc0202660:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202662:	611c                	ld	a5,0(a0)
ffffffffc0202664:	89aa                	mv	s3,a0
ffffffffc0202666:	0016871b          	addiw	a4,a3,1
ffffffffc020266a:	c018                	sw	a4,0(s0)
ffffffffc020266c:	0017f713          	andi	a4,a5,1
ffffffffc0202670:	ef05                	bnez	a4,ffffffffc02026a8 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202672:	000b3717          	auipc	a4,0xb3
ffffffffc0202676:	99673703          	ld	a4,-1642(a4) # ffffffffc02b5008 <pages>
ffffffffc020267a:	8c19                	sub	s0,s0,a4
ffffffffc020267c:	000807b7          	lui	a5,0x80
ffffffffc0202680:	8419                	srai	s0,s0,0x6
ffffffffc0202682:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0202684:	042a                	slli	s0,s0,0xa
ffffffffc0202686:	8cc1                	or	s1,s1,s0
ffffffffc0202688:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc020268c:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202690:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0202694:	4501                	li	a0,0
}
ffffffffc0202696:	70e2                	ld	ra,56(sp)
ffffffffc0202698:	7442                	ld	s0,48(sp)
ffffffffc020269a:	74a2                	ld	s1,40(sp)
ffffffffc020269c:	7902                	ld	s2,32(sp)
ffffffffc020269e:	69e2                	ld	s3,24(sp)
ffffffffc02026a0:	6a42                	ld	s4,16(sp)
ffffffffc02026a2:	6aa2                	ld	s5,8(sp)
ffffffffc02026a4:	6121                	addi	sp,sp,64
ffffffffc02026a6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02026a8:	078a                	slli	a5,a5,0x2
ffffffffc02026aa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026ac:	000b3717          	auipc	a4,0xb3
ffffffffc02026b0:	95473703          	ld	a4,-1708(a4) # ffffffffc02b5000 <npage>
ffffffffc02026b4:	06e7ff63          	bgeu	a5,a4,ffffffffc0202732 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02026b8:	000b3a97          	auipc	s5,0xb3
ffffffffc02026bc:	950a8a93          	addi	s5,s5,-1712 # ffffffffc02b5008 <pages>
ffffffffc02026c0:	000ab703          	ld	a4,0(s5)
ffffffffc02026c4:	fff80937          	lui	s2,0xfff80
ffffffffc02026c8:	993e                	add	s2,s2,a5
ffffffffc02026ca:	091a                	slli	s2,s2,0x6
ffffffffc02026cc:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02026ce:	01240c63          	beq	s0,s2,ffffffffc02026e6 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02026d2:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fccafc4>
ffffffffc02026d6:	fff7869b          	addiw	a3,a5,-1
ffffffffc02026da:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc02026de:	c691                	beqz	a3,ffffffffc02026ea <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02026e0:	120a0073          	sfence.vma	s4
}
ffffffffc02026e4:	bf59                	j	ffffffffc020267a <page_insert+0x3a>
ffffffffc02026e6:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc02026e8:	bf49                	j	ffffffffc020267a <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02026ea:	100027f3          	csrr	a5,sstatus
ffffffffc02026ee:	8b89                	andi	a5,a5,2
ffffffffc02026f0:	ef91                	bnez	a5,ffffffffc020270c <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc02026f2:	000b3797          	auipc	a5,0xb3
ffffffffc02026f6:	91e7b783          	ld	a5,-1762(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc02026fa:	739c                	ld	a5,32(a5)
ffffffffc02026fc:	4585                	li	a1,1
ffffffffc02026fe:	854a                	mv	a0,s2
ffffffffc0202700:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202702:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202706:	120a0073          	sfence.vma	s4
ffffffffc020270a:	bf85                	j	ffffffffc020267a <page_insert+0x3a>
        intr_disable();
ffffffffc020270c:	aa8fe0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202710:	000b3797          	auipc	a5,0xb3
ffffffffc0202714:	9007b783          	ld	a5,-1792(a5) # ffffffffc02b5010 <pmm_manager>
ffffffffc0202718:	739c                	ld	a5,32(a5)
ffffffffc020271a:	4585                	li	a1,1
ffffffffc020271c:	854a                	mv	a0,s2
ffffffffc020271e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202720:	a8efe0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202724:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202728:	120a0073          	sfence.vma	s4
ffffffffc020272c:	b7b9                	j	ffffffffc020267a <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc020272e:	5571                	li	a0,-4
ffffffffc0202730:	b79d                	j	ffffffffc0202696 <page_insert+0x56>
ffffffffc0202732:	f2eff0ef          	jal	ra,ffffffffc0201e60 <pa2page.part.0>

ffffffffc0202736 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0202736:	00004797          	auipc	a5,0x4
ffffffffc020273a:	e1278793          	addi	a5,a5,-494 # ffffffffc0206548 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020273e:	638c                	ld	a1,0(a5)
{
ffffffffc0202740:	7159                	addi	sp,sp,-112
ffffffffc0202742:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202744:	00004517          	auipc	a0,0x4
ffffffffc0202748:	fac50513          	addi	a0,a0,-84 # ffffffffc02066f0 <default_pmm_manager+0x1a8>
    pmm_manager = &default_pmm_manager;
ffffffffc020274c:	000b3b17          	auipc	s6,0xb3
ffffffffc0202750:	8c4b0b13          	addi	s6,s6,-1852 # ffffffffc02b5010 <pmm_manager>
{
ffffffffc0202754:	f486                	sd	ra,104(sp)
ffffffffc0202756:	e8ca                	sd	s2,80(sp)
ffffffffc0202758:	e4ce                	sd	s3,72(sp)
ffffffffc020275a:	f0a2                	sd	s0,96(sp)
ffffffffc020275c:	eca6                	sd	s1,88(sp)
ffffffffc020275e:	e0d2                	sd	s4,64(sp)
ffffffffc0202760:	fc56                	sd	s5,56(sp)
ffffffffc0202762:	f45e                	sd	s7,40(sp)
ffffffffc0202764:	f062                	sd	s8,32(sp)
ffffffffc0202766:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0202768:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020276c:	a29fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202770:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202774:	000b3997          	auipc	s3,0xb3
ffffffffc0202778:	8a498993          	addi	s3,s3,-1884 # ffffffffc02b5018 <va_pa_offset>
    pmm_manager->init();
ffffffffc020277c:	679c                	ld	a5,8(a5)
ffffffffc020277e:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202780:	57f5                	li	a5,-3
ffffffffc0202782:	07fa                	slli	a5,a5,0x1e
ffffffffc0202784:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc0202788:	a12fe0ef          	jal	ra,ffffffffc020099a <get_memory_base>
ffffffffc020278c:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc020278e:	a16fe0ef          	jal	ra,ffffffffc02009a4 <get_memory_size>
    if (mem_size == 0)
ffffffffc0202792:	200505e3          	beqz	a0,ffffffffc020319c <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc0202796:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc0202798:	00004517          	auipc	a0,0x4
ffffffffc020279c:	f9050513          	addi	a0,a0,-112 # ffffffffc0206728 <default_pmm_manager+0x1e0>
ffffffffc02027a0:	9f5fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02027a4:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02027a8:	fff40693          	addi	a3,s0,-1
ffffffffc02027ac:	864a                	mv	a2,s2
ffffffffc02027ae:	85a6                	mv	a1,s1
ffffffffc02027b0:	00004517          	auipc	a0,0x4
ffffffffc02027b4:	f9050513          	addi	a0,a0,-112 # ffffffffc0206740 <default_pmm_manager+0x1f8>
ffffffffc02027b8:	9ddfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02027bc:	c8000737          	lui	a4,0xc8000
ffffffffc02027c0:	87a2                	mv	a5,s0
ffffffffc02027c2:	54876163          	bltu	a4,s0,ffffffffc0202d04 <pmm_init+0x5ce>
ffffffffc02027c6:	757d                	lui	a0,0xfffff
ffffffffc02027c8:	000b4617          	auipc	a2,0xb4
ffffffffc02027cc:	87360613          	addi	a2,a2,-1933 # ffffffffc02b603b <end+0xfff>
ffffffffc02027d0:	8e69                	and	a2,a2,a0
ffffffffc02027d2:	000b3497          	auipc	s1,0xb3
ffffffffc02027d6:	82e48493          	addi	s1,s1,-2002 # ffffffffc02b5000 <npage>
ffffffffc02027da:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027de:	000b3b97          	auipc	s7,0xb3
ffffffffc02027e2:	82ab8b93          	addi	s7,s7,-2006 # ffffffffc02b5008 <pages>
    npage = maxpa / PGSIZE;
ffffffffc02027e6:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027e8:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027ec:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc02027f0:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02027f2:	02f50863          	beq	a0,a5,ffffffffc0202822 <pmm_init+0xec>
ffffffffc02027f6:	4781                	li	a5,0
ffffffffc02027f8:	4585                	li	a1,1
ffffffffc02027fa:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02027fe:	00679513          	slli	a0,a5,0x6
ffffffffc0202802:	9532                	add	a0,a0,a2
ffffffffc0202804:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd49fcc>
ffffffffc0202808:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020280c:	6088                	ld	a0,0(s1)
ffffffffc020280e:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202810:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202814:	00d50733          	add	a4,a0,a3
ffffffffc0202818:	fee7e3e3          	bltu	a5,a4,ffffffffc02027fe <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020281c:	071a                	slli	a4,a4,0x6
ffffffffc020281e:	00e606b3          	add	a3,a2,a4
ffffffffc0202822:	c02007b7          	lui	a5,0xc0200
ffffffffc0202826:	2ef6ece3          	bltu	a3,a5,ffffffffc020331e <pmm_init+0xbe8>
ffffffffc020282a:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc020282e:	77fd                	lui	a5,0xfffff
ffffffffc0202830:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202832:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202834:	5086eb63          	bltu	a3,s0,ffffffffc0202d4a <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202838:	00004517          	auipc	a0,0x4
ffffffffc020283c:	f3050513          	addi	a0,a0,-208 # ffffffffc0206768 <default_pmm_manager+0x220>
ffffffffc0202840:	955fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202844:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202848:	000b2917          	auipc	s2,0xb2
ffffffffc020284c:	7b090913          	addi	s2,s2,1968 # ffffffffc02b4ff8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202850:	7b9c                	ld	a5,48(a5)
ffffffffc0202852:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202854:	00004517          	auipc	a0,0x4
ffffffffc0202858:	f2c50513          	addi	a0,a0,-212 # ffffffffc0206780 <default_pmm_manager+0x238>
ffffffffc020285c:	939fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202860:	00007697          	auipc	a3,0x7
ffffffffc0202864:	7a068693          	addi	a3,a3,1952 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc0202868:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc020286c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202870:	28f6ebe3          	bltu	a3,a5,ffffffffc0203306 <pmm_init+0xbd0>
ffffffffc0202874:	0009b783          	ld	a5,0(s3)
ffffffffc0202878:	8e9d                	sub	a3,a3,a5
ffffffffc020287a:	000b2797          	auipc	a5,0xb2
ffffffffc020287e:	76d7bb23          	sd	a3,1910(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202882:	100027f3          	csrr	a5,sstatus
ffffffffc0202886:	8b89                	andi	a5,a5,2
ffffffffc0202888:	4a079763          	bnez	a5,ffffffffc0202d36 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc020288c:	000b3783          	ld	a5,0(s6)
ffffffffc0202890:	779c                	ld	a5,40(a5)
ffffffffc0202892:	9782                	jalr	a5
ffffffffc0202894:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202896:	6098                	ld	a4,0(s1)
ffffffffc0202898:	c80007b7          	lui	a5,0xc8000
ffffffffc020289c:	83b1                	srli	a5,a5,0xc
ffffffffc020289e:	66e7e363          	bltu	a5,a4,ffffffffc0202f04 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02028a2:	00093503          	ld	a0,0(s2)
ffffffffc02028a6:	62050f63          	beqz	a0,ffffffffc0202ee4 <pmm_init+0x7ae>
ffffffffc02028aa:	03451793          	slli	a5,a0,0x34
ffffffffc02028ae:	62079b63          	bnez	a5,ffffffffc0202ee4 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028b2:	4601                	li	a2,0
ffffffffc02028b4:	4581                	li	a1,0
ffffffffc02028b6:	8c3ff0ef          	jal	ra,ffffffffc0202178 <get_page>
ffffffffc02028ba:	60051563          	bnez	a0,ffffffffc0202ec4 <pmm_init+0x78e>
ffffffffc02028be:	100027f3          	csrr	a5,sstatus
ffffffffc02028c2:	8b89                	andi	a5,a5,2
ffffffffc02028c4:	44079e63          	bnez	a5,ffffffffc0202d20 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02028c8:	000b3783          	ld	a5,0(s6)
ffffffffc02028cc:	4505                	li	a0,1
ffffffffc02028ce:	6f9c                	ld	a5,24(a5)
ffffffffc02028d0:	9782                	jalr	a5
ffffffffc02028d2:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02028d4:	00093503          	ld	a0,0(s2)
ffffffffc02028d8:	4681                	li	a3,0
ffffffffc02028da:	4601                	li	a2,0
ffffffffc02028dc:	85d2                	mv	a1,s4
ffffffffc02028de:	d63ff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc02028e2:	26051ae3          	bnez	a0,ffffffffc0203356 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc02028e6:	00093503          	ld	a0,0(s2)
ffffffffc02028ea:	4601                	li	a2,0
ffffffffc02028ec:	4581                	li	a1,0
ffffffffc02028ee:	e62ff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
ffffffffc02028f2:	240502e3          	beqz	a0,ffffffffc0203336 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc02028f6:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc02028f8:	0017f713          	andi	a4,a5,1
ffffffffc02028fc:	5a070263          	beqz	a4,ffffffffc0202ea0 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202900:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202902:	078a                	slli	a5,a5,0x2
ffffffffc0202904:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202906:	58e7fb63          	bgeu	a5,a4,ffffffffc0202e9c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020290a:	000bb683          	ld	a3,0(s7)
ffffffffc020290e:	fff80637          	lui	a2,0xfff80
ffffffffc0202912:	97b2                	add	a5,a5,a2
ffffffffc0202914:	079a                	slli	a5,a5,0x6
ffffffffc0202916:	97b6                	add	a5,a5,a3
ffffffffc0202918:	14fa17e3          	bne	s4,a5,ffffffffc0203266 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc020291c:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc0202920:	4785                	li	a5,1
ffffffffc0202922:	12f692e3          	bne	a3,a5,ffffffffc0203246 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202926:	00093503          	ld	a0,0(s2)
ffffffffc020292a:	77fd                	lui	a5,0xfffff
ffffffffc020292c:	6114                	ld	a3,0(a0)
ffffffffc020292e:	068a                	slli	a3,a3,0x2
ffffffffc0202930:	8efd                	and	a3,a3,a5
ffffffffc0202932:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202936:	0ee67ce3          	bgeu	a2,a4,ffffffffc020322e <pmm_init+0xaf8>
ffffffffc020293a:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020293e:	96e2                	add	a3,a3,s8
ffffffffc0202940:	0006ba83          	ld	s5,0(a3)
ffffffffc0202944:	0a8a                	slli	s5,s5,0x2
ffffffffc0202946:	00fafab3          	and	s5,s5,a5
ffffffffc020294a:	00cad793          	srli	a5,s5,0xc
ffffffffc020294e:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0203214 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202952:	4601                	li	a2,0
ffffffffc0202954:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202956:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202958:	df8ff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020295c:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020295e:	55551363          	bne	a0,s5,ffffffffc0202ea4 <pmm_init+0x76e>
ffffffffc0202962:	100027f3          	csrr	a5,sstatus
ffffffffc0202966:	8b89                	andi	a5,a5,2
ffffffffc0202968:	3a079163          	bnez	a5,ffffffffc0202d0a <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc020296c:	000b3783          	ld	a5,0(s6)
ffffffffc0202970:	4505                	li	a0,1
ffffffffc0202972:	6f9c                	ld	a5,24(a5)
ffffffffc0202974:	9782                	jalr	a5
ffffffffc0202976:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202978:	00093503          	ld	a0,0(s2)
ffffffffc020297c:	46d1                	li	a3,20
ffffffffc020297e:	6605                	lui	a2,0x1
ffffffffc0202980:	85e2                	mv	a1,s8
ffffffffc0202982:	cbfff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc0202986:	060517e3          	bnez	a0,ffffffffc02031f4 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020298a:	00093503          	ld	a0,0(s2)
ffffffffc020298e:	4601                	li	a2,0
ffffffffc0202990:	6585                	lui	a1,0x1
ffffffffc0202992:	dbeff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
ffffffffc0202996:	02050fe3          	beqz	a0,ffffffffc02031d4 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc020299a:	611c                	ld	a5,0(a0)
ffffffffc020299c:	0107f713          	andi	a4,a5,16
ffffffffc02029a0:	7c070e63          	beqz	a4,ffffffffc020317c <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02029a4:	8b91                	andi	a5,a5,4
ffffffffc02029a6:	7a078b63          	beqz	a5,ffffffffc020315c <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02029aa:	00093503          	ld	a0,0(s2)
ffffffffc02029ae:	611c                	ld	a5,0(a0)
ffffffffc02029b0:	8bc1                	andi	a5,a5,16
ffffffffc02029b2:	78078563          	beqz	a5,ffffffffc020313c <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02029b6:	000c2703          	lw	a4,0(s8)
ffffffffc02029ba:	4785                	li	a5,1
ffffffffc02029bc:	76f71063          	bne	a4,a5,ffffffffc020311c <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02029c0:	4681                	li	a3,0
ffffffffc02029c2:	6605                	lui	a2,0x1
ffffffffc02029c4:	85d2                	mv	a1,s4
ffffffffc02029c6:	c7bff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc02029ca:	72051963          	bnez	a0,ffffffffc02030fc <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02029ce:	000a2703          	lw	a4,0(s4)
ffffffffc02029d2:	4789                	li	a5,2
ffffffffc02029d4:	70f71463          	bne	a4,a5,ffffffffc02030dc <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02029d8:	000c2783          	lw	a5,0(s8)
ffffffffc02029dc:	6e079063          	bnez	a5,ffffffffc02030bc <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02029e0:	00093503          	ld	a0,0(s2)
ffffffffc02029e4:	4601                	li	a2,0
ffffffffc02029e6:	6585                	lui	a1,0x1
ffffffffc02029e8:	d68ff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
ffffffffc02029ec:	6a050863          	beqz	a0,ffffffffc020309c <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc02029f0:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc02029f2:	00177793          	andi	a5,a4,1
ffffffffc02029f6:	4a078563          	beqz	a5,ffffffffc0202ea0 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc02029fa:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02029fc:	00271793          	slli	a5,a4,0x2
ffffffffc0202a00:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a02:	48d7fd63          	bgeu	a5,a3,ffffffffc0202e9c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a06:	000bb683          	ld	a3,0(s7)
ffffffffc0202a0a:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202a0e:	97d6                	add	a5,a5,s5
ffffffffc0202a10:	079a                	slli	a5,a5,0x6
ffffffffc0202a12:	97b6                	add	a5,a5,a3
ffffffffc0202a14:	66fa1463          	bne	s4,a5,ffffffffc020307c <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a18:	8b41                	andi	a4,a4,16
ffffffffc0202a1a:	64071163          	bnez	a4,ffffffffc020305c <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202a1e:	00093503          	ld	a0,0(s2)
ffffffffc0202a22:	4581                	li	a1,0
ffffffffc0202a24:	b81ff0ef          	jal	ra,ffffffffc02025a4 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0202a28:	000a2c83          	lw	s9,0(s4)
ffffffffc0202a2c:	4785                	li	a5,1
ffffffffc0202a2e:	60fc9763          	bne	s9,a5,ffffffffc020303c <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202a32:	000c2783          	lw	a5,0(s8)
ffffffffc0202a36:	5e079363          	bnez	a5,ffffffffc020301c <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0202a3a:	00093503          	ld	a0,0(s2)
ffffffffc0202a3e:	6585                	lui	a1,0x1
ffffffffc0202a40:	b65ff0ef          	jal	ra,ffffffffc02025a4 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202a44:	000a2783          	lw	a5,0(s4)
ffffffffc0202a48:	52079a63          	bnez	a5,ffffffffc0202f7c <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202a4c:	000c2783          	lw	a5,0(s8)
ffffffffc0202a50:	50079663          	bnez	a5,ffffffffc0202f5c <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202a54:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202a58:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a5a:	000a3683          	ld	a3,0(s4)
ffffffffc0202a5e:	068a                	slli	a3,a3,0x2
ffffffffc0202a60:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a62:	42b6fd63          	bgeu	a3,a1,ffffffffc0202e9c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a66:	000bb503          	ld	a0,0(s7)
ffffffffc0202a6a:	96d6                	add	a3,a3,s5
ffffffffc0202a6c:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202a6e:	00d507b3          	add	a5,a0,a3
ffffffffc0202a72:	439c                	lw	a5,0(a5)
ffffffffc0202a74:	4d979463          	bne	a5,s9,ffffffffc0202f3c <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0202a78:	8699                	srai	a3,a3,0x6
ffffffffc0202a7a:	00080637          	lui	a2,0x80
ffffffffc0202a7e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0202a80:	00c69713          	slli	a4,a3,0xc
ffffffffc0202a84:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0202a86:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202a88:	48b77e63          	bgeu	a4,a1,ffffffffc0202f24 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0202a8c:	0009b703          	ld	a4,0(s3)
ffffffffc0202a90:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0202a92:	629c                	ld	a5,0(a3)
ffffffffc0202a94:	078a                	slli	a5,a5,0x2
ffffffffc0202a96:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202a98:	40b7f263          	bgeu	a5,a1,ffffffffc0202e9c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202a9c:	8f91                	sub	a5,a5,a2
ffffffffc0202a9e:	079a                	slli	a5,a5,0x6
ffffffffc0202aa0:	953e                	add	a0,a0,a5
ffffffffc0202aa2:	100027f3          	csrr	a5,sstatus
ffffffffc0202aa6:	8b89                	andi	a5,a5,2
ffffffffc0202aa8:	30079963          	bnez	a5,ffffffffc0202dba <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0202aac:	000b3783          	ld	a5,0(s6)
ffffffffc0202ab0:	4585                	li	a1,1
ffffffffc0202ab2:	739c                	ld	a5,32(a5)
ffffffffc0202ab4:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202ab6:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0202aba:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202abc:	078a                	slli	a5,a5,0x2
ffffffffc0202abe:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202ac0:	3ce7fe63          	bgeu	a5,a4,ffffffffc0202e9c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202ac4:	000bb503          	ld	a0,0(s7)
ffffffffc0202ac8:	fff80737          	lui	a4,0xfff80
ffffffffc0202acc:	97ba                	add	a5,a5,a4
ffffffffc0202ace:	079a                	slli	a5,a5,0x6
ffffffffc0202ad0:	953e                	add	a0,a0,a5
ffffffffc0202ad2:	100027f3          	csrr	a5,sstatus
ffffffffc0202ad6:	8b89                	andi	a5,a5,2
ffffffffc0202ad8:	2c079563          	bnez	a5,ffffffffc0202da2 <pmm_init+0x66c>
ffffffffc0202adc:	000b3783          	ld	a5,0(s6)
ffffffffc0202ae0:	4585                	li	a1,1
ffffffffc0202ae2:	739c                	ld	a5,32(a5)
ffffffffc0202ae4:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202ae6:	00093783          	ld	a5,0(s2)
ffffffffc0202aea:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd49fc4>
    asm volatile("sfence.vma");
ffffffffc0202aee:	12000073          	sfence.vma
ffffffffc0202af2:	100027f3          	csrr	a5,sstatus
ffffffffc0202af6:	8b89                	andi	a5,a5,2
ffffffffc0202af8:	28079b63          	bnez	a5,ffffffffc0202d8e <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202afc:	000b3783          	ld	a5,0(s6)
ffffffffc0202b00:	779c                	ld	a5,40(a5)
ffffffffc0202b02:	9782                	jalr	a5
ffffffffc0202b04:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202b06:	4b441b63          	bne	s0,s4,ffffffffc0202fbc <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0202b0a:	00004517          	auipc	a0,0x4
ffffffffc0202b0e:	f9e50513          	addi	a0,a0,-98 # ffffffffc0206aa8 <default_pmm_manager+0x560>
ffffffffc0202b12:	e82fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0202b16:	100027f3          	csrr	a5,sstatus
ffffffffc0202b1a:	8b89                	andi	a5,a5,2
ffffffffc0202b1c:	24079f63          	bnez	a5,ffffffffc0202d7a <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202b20:	000b3783          	ld	a5,0(s6)
ffffffffc0202b24:	779c                	ld	a5,40(a5)
ffffffffc0202b26:	9782                	jalr	a5
ffffffffc0202b28:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b2a:	6098                	ld	a4,0(s1)
ffffffffc0202b2c:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b30:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b32:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b36:	6a05                	lui	s4,0x1
ffffffffc0202b38:	02f47c63          	bgeu	s0,a5,ffffffffc0202b70 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202b3c:	00c45793          	srli	a5,s0,0xc
ffffffffc0202b40:	00093503          	ld	a0,0(s2)
ffffffffc0202b44:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202e42 <pmm_init+0x70c>
ffffffffc0202b48:	0009b583          	ld	a1,0(s3)
ffffffffc0202b4c:	4601                	li	a2,0
ffffffffc0202b4e:	95a2                	add	a1,a1,s0
ffffffffc0202b50:	c00ff0ef          	jal	ra,ffffffffc0201f50 <get_pte>
ffffffffc0202b54:	32050463          	beqz	a0,ffffffffc0202e7c <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202b58:	611c                	ld	a5,0(a0)
ffffffffc0202b5a:	078a                	slli	a5,a5,0x2
ffffffffc0202b5c:	0157f7b3          	and	a5,a5,s5
ffffffffc0202b60:	2e879e63          	bne	a5,s0,ffffffffc0202e5c <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202b64:	6098                	ld	a4,0(s1)
ffffffffc0202b66:	9452                	add	s0,s0,s4
ffffffffc0202b68:	00c71793          	slli	a5,a4,0xc
ffffffffc0202b6c:	fcf468e3          	bltu	s0,a5,ffffffffc0202b3c <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202b70:	00093783          	ld	a5,0(s2)
ffffffffc0202b74:	639c                	ld	a5,0(a5)
ffffffffc0202b76:	42079363          	bnez	a5,ffffffffc0202f9c <pmm_init+0x866>
ffffffffc0202b7a:	100027f3          	csrr	a5,sstatus
ffffffffc0202b7e:	8b89                	andi	a5,a5,2
ffffffffc0202b80:	24079963          	bnez	a5,ffffffffc0202dd2 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202b84:	000b3783          	ld	a5,0(s6)
ffffffffc0202b88:	4505                	li	a0,1
ffffffffc0202b8a:	6f9c                	ld	a5,24(a5)
ffffffffc0202b8c:	9782                	jalr	a5
ffffffffc0202b8e:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202b90:	00093503          	ld	a0,0(s2)
ffffffffc0202b94:	4699                	li	a3,6
ffffffffc0202b96:	10000613          	li	a2,256
ffffffffc0202b9a:	85d2                	mv	a1,s4
ffffffffc0202b9c:	aa5ff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc0202ba0:	44051e63          	bnez	a0,ffffffffc0202ffc <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0202ba4:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc0202ba8:	4785                	li	a5,1
ffffffffc0202baa:	42f71963          	bne	a4,a5,ffffffffc0202fdc <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202bae:	00093503          	ld	a0,0(s2)
ffffffffc0202bb2:	6405                	lui	s0,0x1
ffffffffc0202bb4:	4699                	li	a3,6
ffffffffc0202bb6:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8aa8>
ffffffffc0202bba:	85d2                	mv	a1,s4
ffffffffc0202bbc:	a85ff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc0202bc0:	72051363          	bnez	a0,ffffffffc02032e6 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0202bc4:	000a2703          	lw	a4,0(s4)
ffffffffc0202bc8:	4789                	li	a5,2
ffffffffc0202bca:	6ef71e63          	bne	a4,a5,ffffffffc02032c6 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0202bce:	00004597          	auipc	a1,0x4
ffffffffc0202bd2:	02258593          	addi	a1,a1,34 # ffffffffc0206bf0 <default_pmm_manager+0x6a8>
ffffffffc0202bd6:	10000513          	li	a0,256
ffffffffc0202bda:	295020ef          	jal	ra,ffffffffc020566e <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202bde:	10040593          	addi	a1,s0,256
ffffffffc0202be2:	10000513          	li	a0,256
ffffffffc0202be6:	29b020ef          	jal	ra,ffffffffc0205680 <strcmp>
ffffffffc0202bea:	6a051e63          	bnez	a0,ffffffffc02032a6 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202bee:	000bb683          	ld	a3,0(s7)
ffffffffc0202bf2:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0202bf6:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0202bf8:	40da06b3          	sub	a3,s4,a3
ffffffffc0202bfc:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202bfe:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202c00:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202c02:	8031                	srli	s0,s0,0xc
ffffffffc0202c04:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c08:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c0a:	30f77d63          	bgeu	a4,a5,ffffffffc0202f24 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c0e:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c12:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202c16:	96be                	add	a3,a3,a5
ffffffffc0202c18:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202c1c:	21d020ef          	jal	ra,ffffffffc0205638 <strlen>
ffffffffc0202c20:	66051363          	bnez	a0,ffffffffc0203286 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202c24:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0202c28:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c2a:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd49fc4>
ffffffffc0202c2e:	068a                	slli	a3,a3,0x2
ffffffffc0202c30:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c32:	26f6f563          	bgeu	a3,a5,ffffffffc0202e9c <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0202c36:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0202c38:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0202c3a:	2ef47563          	bgeu	s0,a5,ffffffffc0202f24 <pmm_init+0x7ee>
ffffffffc0202c3e:	0009b403          	ld	s0,0(s3)
ffffffffc0202c42:	9436                	add	s0,s0,a3
ffffffffc0202c44:	100027f3          	csrr	a5,sstatus
ffffffffc0202c48:	8b89                	andi	a5,a5,2
ffffffffc0202c4a:	1e079163          	bnez	a5,ffffffffc0202e2c <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202c4e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c52:	4585                	li	a1,1
ffffffffc0202c54:	8552                	mv	a0,s4
ffffffffc0202c56:	739c                	ld	a5,32(a5)
ffffffffc0202c58:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c5a:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202c5c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c5e:	078a                	slli	a5,a5,0x2
ffffffffc0202c60:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c62:	22e7fd63          	bgeu	a5,a4,ffffffffc0202e9c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c66:	000bb503          	ld	a0,0(s7)
ffffffffc0202c6a:	fff80737          	lui	a4,0xfff80
ffffffffc0202c6e:	97ba                	add	a5,a5,a4
ffffffffc0202c70:	079a                	slli	a5,a5,0x6
ffffffffc0202c72:	953e                	add	a0,a0,a5
ffffffffc0202c74:	100027f3          	csrr	a5,sstatus
ffffffffc0202c78:	8b89                	andi	a5,a5,2
ffffffffc0202c7a:	18079d63          	bnez	a5,ffffffffc0202e14 <pmm_init+0x6de>
ffffffffc0202c7e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c82:	4585                	li	a1,1
ffffffffc0202c84:	739c                	ld	a5,32(a5)
ffffffffc0202c86:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c88:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0202c8c:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202c8e:	078a                	slli	a5,a5,0x2
ffffffffc0202c90:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202c92:	20e7f563          	bgeu	a5,a4,ffffffffc0202e9c <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0202c96:	000bb503          	ld	a0,0(s7)
ffffffffc0202c9a:	fff80737          	lui	a4,0xfff80
ffffffffc0202c9e:	97ba                	add	a5,a5,a4
ffffffffc0202ca0:	079a                	slli	a5,a5,0x6
ffffffffc0202ca2:	953e                	add	a0,a0,a5
ffffffffc0202ca4:	100027f3          	csrr	a5,sstatus
ffffffffc0202ca8:	8b89                	andi	a5,a5,2
ffffffffc0202caa:	14079963          	bnez	a5,ffffffffc0202dfc <pmm_init+0x6c6>
ffffffffc0202cae:	000b3783          	ld	a5,0(s6)
ffffffffc0202cb2:	4585                	li	a1,1
ffffffffc0202cb4:	739c                	ld	a5,32(a5)
ffffffffc0202cb6:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0202cb8:	00093783          	ld	a5,0(s2)
ffffffffc0202cbc:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0202cc0:	12000073          	sfence.vma
ffffffffc0202cc4:	100027f3          	csrr	a5,sstatus
ffffffffc0202cc8:	8b89                	andi	a5,a5,2
ffffffffc0202cca:	10079f63          	bnez	a5,ffffffffc0202de8 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202cce:	000b3783          	ld	a5,0(s6)
ffffffffc0202cd2:	779c                	ld	a5,40(a5)
ffffffffc0202cd4:	9782                	jalr	a5
ffffffffc0202cd6:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0202cd8:	4c8c1e63          	bne	s8,s0,ffffffffc02031b4 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202cdc:	00004517          	auipc	a0,0x4
ffffffffc0202ce0:	f8c50513          	addi	a0,a0,-116 # ffffffffc0206c68 <default_pmm_manager+0x720>
ffffffffc0202ce4:	cb0fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0202ce8:	7406                	ld	s0,96(sp)
ffffffffc0202cea:	70a6                	ld	ra,104(sp)
ffffffffc0202cec:	64e6                	ld	s1,88(sp)
ffffffffc0202cee:	6946                	ld	s2,80(sp)
ffffffffc0202cf0:	69a6                	ld	s3,72(sp)
ffffffffc0202cf2:	6a06                	ld	s4,64(sp)
ffffffffc0202cf4:	7ae2                	ld	s5,56(sp)
ffffffffc0202cf6:	7b42                	ld	s6,48(sp)
ffffffffc0202cf8:	7ba2                	ld	s7,40(sp)
ffffffffc0202cfa:	7c02                	ld	s8,32(sp)
ffffffffc0202cfc:	6ce2                	ld	s9,24(sp)
ffffffffc0202cfe:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202d00:	f97fe06f          	j	ffffffffc0201c96 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202d04:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d08:	bc7d                	j	ffffffffc02027c6 <pmm_init+0x90>
        intr_disable();
ffffffffc0202d0a:	cabfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202d0e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d12:	4505                	li	a0,1
ffffffffc0202d14:	6f9c                	ld	a5,24(a5)
ffffffffc0202d16:	9782                	jalr	a5
ffffffffc0202d18:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d1a:	c95fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d1e:	b9a9                	j	ffffffffc0202978 <pmm_init+0x242>
        intr_disable();
ffffffffc0202d20:	c95fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d24:	000b3783          	ld	a5,0(s6)
ffffffffc0202d28:	4505                	li	a0,1
ffffffffc0202d2a:	6f9c                	ld	a5,24(a5)
ffffffffc0202d2c:	9782                	jalr	a5
ffffffffc0202d2e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d30:	c7ffd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d34:	b645                	j	ffffffffc02028d4 <pmm_init+0x19e>
        intr_disable();
ffffffffc0202d36:	c7ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d3a:	000b3783          	ld	a5,0(s6)
ffffffffc0202d3e:	779c                	ld	a5,40(a5)
ffffffffc0202d40:	9782                	jalr	a5
ffffffffc0202d42:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202d44:	c6bfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d48:	b6b9                	j	ffffffffc0202896 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0202d4a:	6705                	lui	a4,0x1
ffffffffc0202d4c:	177d                	addi	a4,a4,-1
ffffffffc0202d4e:	96ba                	add	a3,a3,a4
ffffffffc0202d50:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202d52:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202d56:	14a77363          	bgeu	a4,a0,ffffffffc0202e9c <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0202d5a:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202d5e:	fff80537          	lui	a0,0xfff80
ffffffffc0202d62:	972a                	add	a4,a4,a0
ffffffffc0202d64:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0202d66:	8c1d                	sub	s0,s0,a5
ffffffffc0202d68:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202d6c:	00c45593          	srli	a1,s0,0xc
ffffffffc0202d70:	9532                	add	a0,a0,a2
ffffffffc0202d72:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202d74:	0009b583          	ld	a1,0(s3)
}
ffffffffc0202d78:	b4c1                	j	ffffffffc0202838 <pmm_init+0x102>
        intr_disable();
ffffffffc0202d7a:	c3bfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202d7e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d82:	779c                	ld	a5,40(a5)
ffffffffc0202d84:	9782                	jalr	a5
ffffffffc0202d86:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0202d88:	c27fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202d8c:	bb79                	j	ffffffffc0202b2a <pmm_init+0x3f4>
        intr_disable();
ffffffffc0202d8e:	c27fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202d92:	000b3783          	ld	a5,0(s6)
ffffffffc0202d96:	779c                	ld	a5,40(a5)
ffffffffc0202d98:	9782                	jalr	a5
ffffffffc0202d9a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202d9c:	c13fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202da0:	b39d                	j	ffffffffc0202b06 <pmm_init+0x3d0>
ffffffffc0202da2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202da4:	c11fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202da8:	000b3783          	ld	a5,0(s6)
ffffffffc0202dac:	6522                	ld	a0,8(sp)
ffffffffc0202dae:	4585                	li	a1,1
ffffffffc0202db0:	739c                	ld	a5,32(a5)
ffffffffc0202db2:	9782                	jalr	a5
        intr_enable();
ffffffffc0202db4:	bfbfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202db8:	b33d                	j	ffffffffc0202ae6 <pmm_init+0x3b0>
ffffffffc0202dba:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dbc:	bf9fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202dc0:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc4:	6522                	ld	a0,8(sp)
ffffffffc0202dc6:	4585                	li	a1,1
ffffffffc0202dc8:	739c                	ld	a5,32(a5)
ffffffffc0202dca:	9782                	jalr	a5
        intr_enable();
ffffffffc0202dcc:	be3fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dd0:	b1dd                	j	ffffffffc0202ab6 <pmm_init+0x380>
        intr_disable();
ffffffffc0202dd2:	be3fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202dd6:	000b3783          	ld	a5,0(s6)
ffffffffc0202dda:	4505                	li	a0,1
ffffffffc0202ddc:	6f9c                	ld	a5,24(a5)
ffffffffc0202dde:	9782                	jalr	a5
ffffffffc0202de0:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202de2:	bcdfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202de6:	b36d                	j	ffffffffc0202b90 <pmm_init+0x45a>
        intr_disable();
ffffffffc0202de8:	bcdfd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202dec:	000b3783          	ld	a5,0(s6)
ffffffffc0202df0:	779c                	ld	a5,40(a5)
ffffffffc0202df2:	9782                	jalr	a5
ffffffffc0202df4:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202df6:	bb9fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202dfa:	bdf9                	j	ffffffffc0202cd8 <pmm_init+0x5a2>
ffffffffc0202dfc:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202dfe:	bb7fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202e02:	000b3783          	ld	a5,0(s6)
ffffffffc0202e06:	6522                	ld	a0,8(sp)
ffffffffc0202e08:	4585                	li	a1,1
ffffffffc0202e0a:	739c                	ld	a5,32(a5)
ffffffffc0202e0c:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e0e:	ba1fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e12:	b55d                	j	ffffffffc0202cb8 <pmm_init+0x582>
ffffffffc0202e14:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202e16:	b9ffd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e1a:	000b3783          	ld	a5,0(s6)
ffffffffc0202e1e:	6522                	ld	a0,8(sp)
ffffffffc0202e20:	4585                	li	a1,1
ffffffffc0202e22:	739c                	ld	a5,32(a5)
ffffffffc0202e24:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e26:	b89fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e2a:	bdb9                	j	ffffffffc0202c88 <pmm_init+0x552>
        intr_disable();
ffffffffc0202e2c:	b89fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0202e30:	000b3783          	ld	a5,0(s6)
ffffffffc0202e34:	4585                	li	a1,1
ffffffffc0202e36:	8552                	mv	a0,s4
ffffffffc0202e38:	739c                	ld	a5,32(a5)
ffffffffc0202e3a:	9782                	jalr	a5
        intr_enable();
ffffffffc0202e3c:	b73fd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0202e40:	bd29                	j	ffffffffc0202c5a <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e42:	86a2                	mv	a3,s0
ffffffffc0202e44:	00003617          	auipc	a2,0x3
ffffffffc0202e48:	73c60613          	addi	a2,a2,1852 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202e4c:	25d00593          	li	a1,605
ffffffffc0202e50:	00004517          	auipc	a0,0x4
ffffffffc0202e54:	84850513          	addi	a0,a0,-1976 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202e58:	e36fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202e5c:	00004697          	auipc	a3,0x4
ffffffffc0202e60:	cac68693          	addi	a3,a3,-852 # ffffffffc0206b08 <default_pmm_manager+0x5c0>
ffffffffc0202e64:	00003617          	auipc	a2,0x3
ffffffffc0202e68:	10460613          	addi	a2,a2,260 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202e6c:	25e00593          	li	a1,606
ffffffffc0202e70:	00004517          	auipc	a0,0x4
ffffffffc0202e74:	82850513          	addi	a0,a0,-2008 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202e78:	e16fd0ef          	jal	ra,ffffffffc020048e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202e7c:	00004697          	auipc	a3,0x4
ffffffffc0202e80:	c4c68693          	addi	a3,a3,-948 # ffffffffc0206ac8 <default_pmm_manager+0x580>
ffffffffc0202e84:	00003617          	auipc	a2,0x3
ffffffffc0202e88:	0e460613          	addi	a2,a2,228 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202e8c:	25d00593          	li	a1,605
ffffffffc0202e90:	00004517          	auipc	a0,0x4
ffffffffc0202e94:	80850513          	addi	a0,a0,-2040 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202e98:	df6fd0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0202e9c:	fc5fe0ef          	jal	ra,ffffffffc0201e60 <pa2page.part.0>
ffffffffc0202ea0:	fddfe0ef          	jal	ra,ffffffffc0201e7c <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202ea4:	00004697          	auipc	a3,0x4
ffffffffc0202ea8:	a1c68693          	addi	a3,a3,-1508 # ffffffffc02068c0 <default_pmm_manager+0x378>
ffffffffc0202eac:	00003617          	auipc	a2,0x3
ffffffffc0202eb0:	0bc60613          	addi	a2,a2,188 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202eb4:	22d00593          	li	a1,557
ffffffffc0202eb8:	00003517          	auipc	a0,0x3
ffffffffc0202ebc:	7e050513          	addi	a0,a0,2016 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202ec0:	dcefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0202ec4:	00004697          	auipc	a3,0x4
ffffffffc0202ec8:	93c68693          	addi	a3,a3,-1732 # ffffffffc0206800 <default_pmm_manager+0x2b8>
ffffffffc0202ecc:	00003617          	auipc	a2,0x3
ffffffffc0202ed0:	09c60613          	addi	a2,a2,156 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202ed4:	22000593          	li	a1,544
ffffffffc0202ed8:	00003517          	auipc	a0,0x3
ffffffffc0202edc:	7c050513          	addi	a0,a0,1984 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202ee0:	daefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202ee4:	00004697          	auipc	a3,0x4
ffffffffc0202ee8:	8dc68693          	addi	a3,a3,-1828 # ffffffffc02067c0 <default_pmm_manager+0x278>
ffffffffc0202eec:	00003617          	auipc	a2,0x3
ffffffffc0202ef0:	07c60613          	addi	a2,a2,124 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202ef4:	21f00593          	li	a1,543
ffffffffc0202ef8:	00003517          	auipc	a0,0x3
ffffffffc0202efc:	7a050513          	addi	a0,a0,1952 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f00:	d8efd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202f04:	00004697          	auipc	a3,0x4
ffffffffc0202f08:	89c68693          	addi	a3,a3,-1892 # ffffffffc02067a0 <default_pmm_manager+0x258>
ffffffffc0202f0c:	00003617          	auipc	a2,0x3
ffffffffc0202f10:	05c60613          	addi	a2,a2,92 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202f14:	21e00593          	li	a1,542
ffffffffc0202f18:	00003517          	auipc	a0,0x3
ffffffffc0202f1c:	78050513          	addi	a0,a0,1920 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f20:	d6efd0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc0202f24:	00003617          	auipc	a2,0x3
ffffffffc0202f28:	65c60613          	addi	a2,a2,1628 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0202f2c:	07100593          	li	a1,113
ffffffffc0202f30:	00003517          	auipc	a0,0x3
ffffffffc0202f34:	67850513          	addi	a0,a0,1656 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0202f38:	d56fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202f3c:	00004697          	auipc	a3,0x4
ffffffffc0202f40:	b1468693          	addi	a3,a3,-1260 # ffffffffc0206a50 <default_pmm_manager+0x508>
ffffffffc0202f44:	00003617          	auipc	a2,0x3
ffffffffc0202f48:	02460613          	addi	a2,a2,36 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202f4c:	24600593          	li	a1,582
ffffffffc0202f50:	00003517          	auipc	a0,0x3
ffffffffc0202f54:	74850513          	addi	a0,a0,1864 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f58:	d36fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202f5c:	00004697          	auipc	a3,0x4
ffffffffc0202f60:	aac68693          	addi	a3,a3,-1364 # ffffffffc0206a08 <default_pmm_manager+0x4c0>
ffffffffc0202f64:	00003617          	auipc	a2,0x3
ffffffffc0202f68:	00460613          	addi	a2,a2,4 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202f6c:	24400593          	li	a1,580
ffffffffc0202f70:	00003517          	auipc	a0,0x3
ffffffffc0202f74:	72850513          	addi	a0,a0,1832 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f78:	d16fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0202f7c:	00004697          	auipc	a3,0x4
ffffffffc0202f80:	abc68693          	addi	a3,a3,-1348 # ffffffffc0206a38 <default_pmm_manager+0x4f0>
ffffffffc0202f84:	00003617          	auipc	a2,0x3
ffffffffc0202f88:	fe460613          	addi	a2,a2,-28 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202f8c:	24300593          	li	a1,579
ffffffffc0202f90:	00003517          	auipc	a0,0x3
ffffffffc0202f94:	70850513          	addi	a0,a0,1800 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202f98:	cf6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0202f9c:	00004697          	auipc	a3,0x4
ffffffffc0202fa0:	b8468693          	addi	a3,a3,-1148 # ffffffffc0206b20 <default_pmm_manager+0x5d8>
ffffffffc0202fa4:	00003617          	auipc	a2,0x3
ffffffffc0202fa8:	fc460613          	addi	a2,a2,-60 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202fac:	26100593          	li	a1,609
ffffffffc0202fb0:	00003517          	auipc	a0,0x3
ffffffffc0202fb4:	6e850513          	addi	a0,a0,1768 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202fb8:	cd6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202fbc:	00004697          	auipc	a3,0x4
ffffffffc0202fc0:	ac468693          	addi	a3,a3,-1340 # ffffffffc0206a80 <default_pmm_manager+0x538>
ffffffffc0202fc4:	00003617          	auipc	a2,0x3
ffffffffc0202fc8:	fa460613          	addi	a2,a2,-92 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202fcc:	24e00593          	li	a1,590
ffffffffc0202fd0:	00003517          	auipc	a0,0x3
ffffffffc0202fd4:	6c850513          	addi	a0,a0,1736 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202fd8:	cb6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202fdc:	00004697          	auipc	a3,0x4
ffffffffc0202fe0:	b9c68693          	addi	a3,a3,-1124 # ffffffffc0206b78 <default_pmm_manager+0x630>
ffffffffc0202fe4:	00003617          	auipc	a2,0x3
ffffffffc0202fe8:	f8460613          	addi	a2,a2,-124 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0202fec:	26600593          	li	a1,614
ffffffffc0202ff0:	00003517          	auipc	a0,0x3
ffffffffc0202ff4:	6a850513          	addi	a0,a0,1704 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0202ff8:	c96fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202ffc:	00004697          	auipc	a3,0x4
ffffffffc0203000:	b3c68693          	addi	a3,a3,-1220 # ffffffffc0206b38 <default_pmm_manager+0x5f0>
ffffffffc0203004:	00003617          	auipc	a2,0x3
ffffffffc0203008:	f6460613          	addi	a2,a2,-156 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020300c:	26500593          	li	a1,613
ffffffffc0203010:	00003517          	auipc	a0,0x3
ffffffffc0203014:	68850513          	addi	a0,a0,1672 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203018:	c76fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc020301c:	00004697          	auipc	a3,0x4
ffffffffc0203020:	9ec68693          	addi	a3,a3,-1556 # ffffffffc0206a08 <default_pmm_manager+0x4c0>
ffffffffc0203024:	00003617          	auipc	a2,0x3
ffffffffc0203028:	f4460613          	addi	a2,a2,-188 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020302c:	24000593          	li	a1,576
ffffffffc0203030:	00003517          	auipc	a0,0x3
ffffffffc0203034:	66850513          	addi	a0,a0,1640 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203038:	c56fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc020303c:	00004697          	auipc	a3,0x4
ffffffffc0203040:	86c68693          	addi	a3,a3,-1940 # ffffffffc02068a8 <default_pmm_manager+0x360>
ffffffffc0203044:	00003617          	auipc	a2,0x3
ffffffffc0203048:	f2460613          	addi	a2,a2,-220 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020304c:	23f00593          	li	a1,575
ffffffffc0203050:	00003517          	auipc	a0,0x3
ffffffffc0203054:	64850513          	addi	a0,a0,1608 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203058:	c36fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc020305c:	00004697          	auipc	a3,0x4
ffffffffc0203060:	9c468693          	addi	a3,a3,-1596 # ffffffffc0206a20 <default_pmm_manager+0x4d8>
ffffffffc0203064:	00003617          	auipc	a2,0x3
ffffffffc0203068:	f0460613          	addi	a2,a2,-252 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020306c:	23c00593          	li	a1,572
ffffffffc0203070:	00003517          	auipc	a0,0x3
ffffffffc0203074:	62850513          	addi	a0,a0,1576 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203078:	c16fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc020307c:	00004697          	auipc	a3,0x4
ffffffffc0203080:	81468693          	addi	a3,a3,-2028 # ffffffffc0206890 <default_pmm_manager+0x348>
ffffffffc0203084:	00003617          	auipc	a2,0x3
ffffffffc0203088:	ee460613          	addi	a2,a2,-284 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020308c:	23b00593          	li	a1,571
ffffffffc0203090:	00003517          	auipc	a0,0x3
ffffffffc0203094:	60850513          	addi	a0,a0,1544 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203098:	bf6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020309c:	00004697          	auipc	a3,0x4
ffffffffc02030a0:	89468693          	addi	a3,a3,-1900 # ffffffffc0206930 <default_pmm_manager+0x3e8>
ffffffffc02030a4:	00003617          	auipc	a2,0x3
ffffffffc02030a8:	ec460613          	addi	a2,a2,-316 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02030ac:	23a00593          	li	a1,570
ffffffffc02030b0:	00003517          	auipc	a0,0x3
ffffffffc02030b4:	5e850513          	addi	a0,a0,1512 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02030b8:	bd6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02030bc:	00004697          	auipc	a3,0x4
ffffffffc02030c0:	94c68693          	addi	a3,a3,-1716 # ffffffffc0206a08 <default_pmm_manager+0x4c0>
ffffffffc02030c4:	00003617          	auipc	a2,0x3
ffffffffc02030c8:	ea460613          	addi	a2,a2,-348 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02030cc:	23900593          	li	a1,569
ffffffffc02030d0:	00003517          	auipc	a0,0x3
ffffffffc02030d4:	5c850513          	addi	a0,a0,1480 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02030d8:	bb6fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc02030dc:	00004697          	auipc	a3,0x4
ffffffffc02030e0:	91468693          	addi	a3,a3,-1772 # ffffffffc02069f0 <default_pmm_manager+0x4a8>
ffffffffc02030e4:	00003617          	auipc	a2,0x3
ffffffffc02030e8:	e8460613          	addi	a2,a2,-380 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02030ec:	23800593          	li	a1,568
ffffffffc02030f0:	00003517          	auipc	a0,0x3
ffffffffc02030f4:	5a850513          	addi	a0,a0,1448 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02030f8:	b96fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02030fc:	00004697          	auipc	a3,0x4
ffffffffc0203100:	8c468693          	addi	a3,a3,-1852 # ffffffffc02069c0 <default_pmm_manager+0x478>
ffffffffc0203104:	00003617          	auipc	a2,0x3
ffffffffc0203108:	e6460613          	addi	a2,a2,-412 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020310c:	23700593          	li	a1,567
ffffffffc0203110:	00003517          	auipc	a0,0x3
ffffffffc0203114:	58850513          	addi	a0,a0,1416 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203118:	b76fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc020311c:	00004697          	auipc	a3,0x4
ffffffffc0203120:	88c68693          	addi	a3,a3,-1908 # ffffffffc02069a8 <default_pmm_manager+0x460>
ffffffffc0203124:	00003617          	auipc	a2,0x3
ffffffffc0203128:	e4460613          	addi	a2,a2,-444 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020312c:	23500593          	li	a1,565
ffffffffc0203130:	00003517          	auipc	a0,0x3
ffffffffc0203134:	56850513          	addi	a0,a0,1384 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203138:	b56fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020313c:	00004697          	auipc	a3,0x4
ffffffffc0203140:	84c68693          	addi	a3,a3,-1972 # ffffffffc0206988 <default_pmm_manager+0x440>
ffffffffc0203144:	00003617          	auipc	a2,0x3
ffffffffc0203148:	e2460613          	addi	a2,a2,-476 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020314c:	23400593          	li	a1,564
ffffffffc0203150:	00003517          	auipc	a0,0x3
ffffffffc0203154:	54850513          	addi	a0,a0,1352 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203158:	b36fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_W);
ffffffffc020315c:	00004697          	auipc	a3,0x4
ffffffffc0203160:	81c68693          	addi	a3,a3,-2020 # ffffffffc0206978 <default_pmm_manager+0x430>
ffffffffc0203164:	00003617          	auipc	a2,0x3
ffffffffc0203168:	e0460613          	addi	a2,a2,-508 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020316c:	23300593          	li	a1,563
ffffffffc0203170:	00003517          	auipc	a0,0x3
ffffffffc0203174:	52850513          	addi	a0,a0,1320 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203178:	b16fd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(*ptep & PTE_U);
ffffffffc020317c:	00003697          	auipc	a3,0x3
ffffffffc0203180:	7ec68693          	addi	a3,a3,2028 # ffffffffc0206968 <default_pmm_manager+0x420>
ffffffffc0203184:	00003617          	auipc	a2,0x3
ffffffffc0203188:	de460613          	addi	a2,a2,-540 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020318c:	23200593          	li	a1,562
ffffffffc0203190:	00003517          	auipc	a0,0x3
ffffffffc0203194:	50850513          	addi	a0,a0,1288 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203198:	af6fd0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("DTB memory info not available");
ffffffffc020319c:	00003617          	auipc	a2,0x3
ffffffffc02031a0:	56c60613          	addi	a2,a2,1388 # ffffffffc0206708 <default_pmm_manager+0x1c0>
ffffffffc02031a4:	06500593          	li	a1,101
ffffffffc02031a8:	00003517          	auipc	a0,0x3
ffffffffc02031ac:	4f050513          	addi	a0,a0,1264 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02031b0:	adefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02031b4:	00004697          	auipc	a3,0x4
ffffffffc02031b8:	8cc68693          	addi	a3,a3,-1844 # ffffffffc0206a80 <default_pmm_manager+0x538>
ffffffffc02031bc:	00003617          	auipc	a2,0x3
ffffffffc02031c0:	dac60613          	addi	a2,a2,-596 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02031c4:	27800593          	li	a1,632
ffffffffc02031c8:	00003517          	auipc	a0,0x3
ffffffffc02031cc:	4d050513          	addi	a0,a0,1232 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02031d0:	abefd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02031d4:	00003697          	auipc	a3,0x3
ffffffffc02031d8:	75c68693          	addi	a3,a3,1884 # ffffffffc0206930 <default_pmm_manager+0x3e8>
ffffffffc02031dc:	00003617          	auipc	a2,0x3
ffffffffc02031e0:	d8c60613          	addi	a2,a2,-628 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02031e4:	23100593          	li	a1,561
ffffffffc02031e8:	00003517          	auipc	a0,0x3
ffffffffc02031ec:	4b050513          	addi	a0,a0,1200 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02031f0:	a9efd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc02031f4:	00003697          	auipc	a3,0x3
ffffffffc02031f8:	6fc68693          	addi	a3,a3,1788 # ffffffffc02068f0 <default_pmm_manager+0x3a8>
ffffffffc02031fc:	00003617          	auipc	a2,0x3
ffffffffc0203200:	d6c60613          	addi	a2,a2,-660 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203204:	23000593          	li	a1,560
ffffffffc0203208:	00003517          	auipc	a0,0x3
ffffffffc020320c:	49050513          	addi	a0,a0,1168 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203210:	a7efd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0203214:	86d6                	mv	a3,s5
ffffffffc0203216:	00003617          	auipc	a2,0x3
ffffffffc020321a:	36a60613          	addi	a2,a2,874 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc020321e:	22c00593          	li	a1,556
ffffffffc0203222:	00003517          	auipc	a0,0x3
ffffffffc0203226:	47650513          	addi	a0,a0,1142 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020322a:	a64fd0ef          	jal	ra,ffffffffc020048e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020322e:	00003617          	auipc	a2,0x3
ffffffffc0203232:	35260613          	addi	a2,a2,850 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0203236:	22b00593          	li	a1,555
ffffffffc020323a:	00003517          	auipc	a0,0x3
ffffffffc020323e:	45e50513          	addi	a0,a0,1118 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203242:	a4cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0203246:	00003697          	auipc	a3,0x3
ffffffffc020324a:	66268693          	addi	a3,a3,1634 # ffffffffc02068a8 <default_pmm_manager+0x360>
ffffffffc020324e:	00003617          	auipc	a2,0x3
ffffffffc0203252:	d1a60613          	addi	a2,a2,-742 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203256:	22900593          	li	a1,553
ffffffffc020325a:	00003517          	auipc	a0,0x3
ffffffffc020325e:	43e50513          	addi	a0,a0,1086 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203262:	a2cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0203266:	00003697          	auipc	a3,0x3
ffffffffc020326a:	62a68693          	addi	a3,a3,1578 # ffffffffc0206890 <default_pmm_manager+0x348>
ffffffffc020326e:	00003617          	auipc	a2,0x3
ffffffffc0203272:	cfa60613          	addi	a2,a2,-774 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203276:	22800593          	li	a1,552
ffffffffc020327a:	00003517          	auipc	a0,0x3
ffffffffc020327e:	41e50513          	addi	a0,a0,1054 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203282:	a0cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0203286:	00004697          	auipc	a3,0x4
ffffffffc020328a:	9ba68693          	addi	a3,a3,-1606 # ffffffffc0206c40 <default_pmm_manager+0x6f8>
ffffffffc020328e:	00003617          	auipc	a2,0x3
ffffffffc0203292:	cda60613          	addi	a2,a2,-806 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203296:	26f00593          	li	a1,623
ffffffffc020329a:	00003517          	auipc	a0,0x3
ffffffffc020329e:	3fe50513          	addi	a0,a0,1022 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02032a2:	9ecfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc02032a6:	00004697          	auipc	a3,0x4
ffffffffc02032aa:	96268693          	addi	a3,a3,-1694 # ffffffffc0206c08 <default_pmm_manager+0x6c0>
ffffffffc02032ae:	00003617          	auipc	a2,0x3
ffffffffc02032b2:	cba60613          	addi	a2,a2,-838 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02032b6:	26c00593          	li	a1,620
ffffffffc02032ba:	00003517          	auipc	a0,0x3
ffffffffc02032be:	3de50513          	addi	a0,a0,990 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02032c2:	9ccfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_ref(p) == 2);
ffffffffc02032c6:	00004697          	auipc	a3,0x4
ffffffffc02032ca:	91268693          	addi	a3,a3,-1774 # ffffffffc0206bd8 <default_pmm_manager+0x690>
ffffffffc02032ce:	00003617          	auipc	a2,0x3
ffffffffc02032d2:	c9a60613          	addi	a2,a2,-870 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02032d6:	26800593          	li	a1,616
ffffffffc02032da:	00003517          	auipc	a0,0x3
ffffffffc02032de:	3be50513          	addi	a0,a0,958 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02032e2:	9acfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02032e6:	00004697          	auipc	a3,0x4
ffffffffc02032ea:	8aa68693          	addi	a3,a3,-1878 # ffffffffc0206b90 <default_pmm_manager+0x648>
ffffffffc02032ee:	00003617          	auipc	a2,0x3
ffffffffc02032f2:	c7a60613          	addi	a2,a2,-902 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02032f6:	26700593          	li	a1,615
ffffffffc02032fa:	00003517          	auipc	a0,0x3
ffffffffc02032fe:	39e50513          	addi	a0,a0,926 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203302:	98cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0203306:	00003617          	auipc	a2,0x3
ffffffffc020330a:	32260613          	addi	a2,a2,802 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc020330e:	0c900593          	li	a1,201
ffffffffc0203312:	00003517          	auipc	a0,0x3
ffffffffc0203316:	38650513          	addi	a0,a0,902 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020331a:	974fd0ef          	jal	ra,ffffffffc020048e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020331e:	00003617          	auipc	a2,0x3
ffffffffc0203322:	30a60613          	addi	a2,a2,778 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0203326:	08100593          	li	a1,129
ffffffffc020332a:	00003517          	auipc	a0,0x3
ffffffffc020332e:	36e50513          	addi	a0,a0,878 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203332:	95cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0203336:	00003697          	auipc	a3,0x3
ffffffffc020333a:	52a68693          	addi	a3,a3,1322 # ffffffffc0206860 <default_pmm_manager+0x318>
ffffffffc020333e:	00003617          	auipc	a2,0x3
ffffffffc0203342:	c2a60613          	addi	a2,a2,-982 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203346:	22700593          	li	a1,551
ffffffffc020334a:	00003517          	auipc	a0,0x3
ffffffffc020334e:	34e50513          	addi	a0,a0,846 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203352:	93cfd0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0203356:	00003697          	auipc	a3,0x3
ffffffffc020335a:	4da68693          	addi	a3,a3,1242 # ffffffffc0206830 <default_pmm_manager+0x2e8>
ffffffffc020335e:	00003617          	auipc	a2,0x3
ffffffffc0203362:	c0a60613          	addi	a2,a2,-1014 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203366:	22400593          	li	a1,548
ffffffffc020336a:	00003517          	auipc	a0,0x3
ffffffffc020336e:	32e50513          	addi	a0,a0,814 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203372:	91cfd0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203376 <copy_range>:
{
ffffffffc0203376:	7119                	addi	sp,sp,-128
ffffffffc0203378:	f4a6                	sd	s1,104(sp)
ffffffffc020337a:	84b6                	mv	s1,a3
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020337c:	8ed1                	or	a3,a3,a2
{
ffffffffc020337e:	fc86                	sd	ra,120(sp)
ffffffffc0203380:	f8a2                	sd	s0,112(sp)
ffffffffc0203382:	f0ca                	sd	s2,96(sp)
ffffffffc0203384:	ecce                	sd	s3,88(sp)
ffffffffc0203386:	e8d2                	sd	s4,80(sp)
ffffffffc0203388:	e4d6                	sd	s5,72(sp)
ffffffffc020338a:	e0da                	sd	s6,64(sp)
ffffffffc020338c:	fc5e                	sd	s7,56(sp)
ffffffffc020338e:	f862                	sd	s8,48(sp)
ffffffffc0203390:	f466                	sd	s9,40(sp)
ffffffffc0203392:	f06a                	sd	s10,32(sp)
ffffffffc0203394:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0203396:	16d2                	slli	a3,a3,0x34
{
ffffffffc0203398:	e43a                	sd	a4,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020339a:	24069663          	bnez	a3,ffffffffc02035e6 <copy_range+0x270>
    assert(USER_ACCESS(start, end));
ffffffffc020339e:	00200737          	lui	a4,0x200
ffffffffc02033a2:	8db2                	mv	s11,a2
ffffffffc02033a4:	22e66163          	bltu	a2,a4,ffffffffc02035c6 <copy_range+0x250>
ffffffffc02033a8:	20967f63          	bgeu	a2,s1,ffffffffc02035c6 <copy_range+0x250>
ffffffffc02033ac:	4705                	li	a4,1
ffffffffc02033ae:	077e                	slli	a4,a4,0x1f
ffffffffc02033b0:	20976b63          	bltu	a4,s1,ffffffffc02035c6 <copy_range+0x250>
ffffffffc02033b4:	5bfd                	li	s7,-1
ffffffffc02033b6:	8a2a                	mv	s4,a0
ffffffffc02033b8:	842e                	mv	s0,a1
        start += PGSIZE;
ffffffffc02033ba:	6985                	lui	s3,0x1
    if (PPN(pa) >= npage)
ffffffffc02033bc:	000b2b17          	auipc	s6,0xb2
ffffffffc02033c0:	c44b0b13          	addi	s6,s6,-956 # ffffffffc02b5000 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc02033c4:	000b2a97          	auipc	s5,0xb2
ffffffffc02033c8:	c44a8a93          	addi	s5,s5,-956 # ffffffffc02b5008 <pages>
    return KADDR(page2pa(page));
ffffffffc02033cc:	00cbdb93          	srli	s7,s7,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc02033d0:	000b2d17          	auipc	s10,0xb2
ffffffffc02033d4:	c40d0d13          	addi	s10,s10,-960 # ffffffffc02b5010 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc02033d8:	4601                	li	a2,0
ffffffffc02033da:	85ee                	mv	a1,s11
ffffffffc02033dc:	8522                	mv	a0,s0
ffffffffc02033de:	b73fe0ef          	jal	ra,ffffffffc0201f50 <get_pte>
ffffffffc02033e2:	892a                	mv	s2,a0
        if (ptep == NULL)
ffffffffc02033e4:	c951                	beqz	a0,ffffffffc0203478 <copy_range+0x102>
        if (*ptep & PTE_V)
ffffffffc02033e6:	6118                	ld	a4,0(a0)
ffffffffc02033e8:	8b05                	andi	a4,a4,1
ffffffffc02033ea:	e705                	bnez	a4,ffffffffc0203412 <copy_range+0x9c>
        start += PGSIZE;
ffffffffc02033ec:	9dce                	add	s11,s11,s3
    } while (start != 0 && start < end);
ffffffffc02033ee:	fe9de5e3          	bltu	s11,s1,ffffffffc02033d8 <copy_range+0x62>
    return 0;
ffffffffc02033f2:	4501                	li	a0,0
}
ffffffffc02033f4:	70e6                	ld	ra,120(sp)
ffffffffc02033f6:	7446                	ld	s0,112(sp)
ffffffffc02033f8:	74a6                	ld	s1,104(sp)
ffffffffc02033fa:	7906                	ld	s2,96(sp)
ffffffffc02033fc:	69e6                	ld	s3,88(sp)
ffffffffc02033fe:	6a46                	ld	s4,80(sp)
ffffffffc0203400:	6aa6                	ld	s5,72(sp)
ffffffffc0203402:	6b06                	ld	s6,64(sp)
ffffffffc0203404:	7be2                	ld	s7,56(sp)
ffffffffc0203406:	7c42                	ld	s8,48(sp)
ffffffffc0203408:	7ca2                	ld	s9,40(sp)
ffffffffc020340a:	7d02                	ld	s10,32(sp)
ffffffffc020340c:	6de2                	ld	s11,24(sp)
ffffffffc020340e:	6109                	addi	sp,sp,128
ffffffffc0203410:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc0203412:	4605                	li	a2,1
ffffffffc0203414:	85ee                	mv	a1,s11
ffffffffc0203416:	8552                	mv	a0,s4
ffffffffc0203418:	b39fe0ef          	jal	ra,ffffffffc0201f50 <get_pte>
ffffffffc020341c:	10050e63          	beqz	a0,ffffffffc0203538 <copy_range+0x1c2>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc0203420:	00093703          	ld	a4,0(s2)
    if (!(pte & PTE_V))
ffffffffc0203424:	00177693          	andi	a3,a4,1
ffffffffc0203428:	0007091b          	sext.w	s2,a4
ffffffffc020342c:	18068163          	beqz	a3,ffffffffc02035ae <copy_range+0x238>
    if (PPN(pa) >= npage)
ffffffffc0203430:	000b3683          	ld	a3,0(s6)
    return pa2page(PTE_ADDR(pte));
ffffffffc0203434:	070a                	slli	a4,a4,0x2
ffffffffc0203436:	8331                	srli	a4,a4,0xc
    if (PPN(pa) >= npage)
ffffffffc0203438:	14d77f63          	bgeu	a4,a3,ffffffffc0203596 <copy_range+0x220>
    return &pages[PPN(pa) - nbase];
ffffffffc020343c:	000ab583          	ld	a1,0(s5)
ffffffffc0203440:	fff807b7          	lui	a5,0xfff80
ffffffffc0203444:	973e                	add	a4,a4,a5
ffffffffc0203446:	071a                	slli	a4,a4,0x6
ffffffffc0203448:	00e58cb3          	add	s9,a1,a4
            assert(page != NULL);
ffffffffc020344c:	120c8563          	beqz	s9,ffffffffc0203576 <copy_range+0x200>
            if (share)
ffffffffc0203450:	67a2                	ld	a5,8(sp)
ffffffffc0203452:	c3a1                	beqz	a5,ffffffffc0203492 <copy_range+0x11c>
                if ((ret = page_insert(to, page, start, perm & ~PTE_W)) != 0)
ffffffffc0203454:	01b97913          	andi	s2,s2,27
ffffffffc0203458:	86ca                	mv	a3,s2
ffffffffc020345a:	866e                	mv	a2,s11
ffffffffc020345c:	85e6                	mv	a1,s9
ffffffffc020345e:	8552                	mv	a0,s4
ffffffffc0203460:	9e0ff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc0203464:	f941                	bnez	a0,ffffffffc02033f4 <copy_range+0x7e>
                if ((ret = page_insert(from, page, start, perm & ~PTE_W)) != 0)
ffffffffc0203466:	86ca                	mv	a3,s2
ffffffffc0203468:	866e                	mv	a2,s11
ffffffffc020346a:	85e6                	mv	a1,s9
ffffffffc020346c:	8522                	mv	a0,s0
ffffffffc020346e:	9d2ff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc0203472:	f149                	bnez	a0,ffffffffc02033f4 <copy_range+0x7e>
        start += PGSIZE;
ffffffffc0203474:	9dce                	add	s11,s11,s3
    } while (start != 0 && start < end);
ffffffffc0203476:	bfa5                	j	ffffffffc02033ee <copy_range+0x78>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0203478:	00200637          	lui	a2,0x200
ffffffffc020347c:	00cd87b3          	add	a5,s11,a2
ffffffffc0203480:	ffe00637          	lui	a2,0xffe00
ffffffffc0203484:	00c7fdb3          	and	s11,a5,a2
    } while (start != 0 && start < end);
ffffffffc0203488:	f60d85e3          	beqz	s11,ffffffffc02033f2 <copy_range+0x7c>
ffffffffc020348c:	f49de6e3          	bltu	s11,s1,ffffffffc02033d8 <copy_range+0x62>
ffffffffc0203490:	b78d                	j	ffffffffc02033f2 <copy_range+0x7c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203492:	10002773          	csrr	a4,sstatus
ffffffffc0203496:	8b09                	andi	a4,a4,2
ffffffffc0203498:	e749                	bnez	a4,ffffffffc0203522 <copy_range+0x1ac>
        page = pmm_manager->alloc_pages(n);
ffffffffc020349a:	000d3703          	ld	a4,0(s10)
ffffffffc020349e:	4505                	li	a0,1
ffffffffc02034a0:	6f18                	ld	a4,24(a4)
ffffffffc02034a2:	9702                	jalr	a4
ffffffffc02034a4:	8c2a                	mv	s8,a0
                assert(npage != NULL);
ffffffffc02034a6:	0a0c0863          	beqz	s8,ffffffffc0203556 <copy_range+0x1e0>
    return page - pages + nbase;
ffffffffc02034aa:	000ab703          	ld	a4,0(s5)
ffffffffc02034ae:	000808b7          	lui	a7,0x80
    return KADDR(page2pa(page));
ffffffffc02034b2:	000b3603          	ld	a2,0(s6)
    return page - pages + nbase;
ffffffffc02034b6:	40ec86b3          	sub	a3,s9,a4
ffffffffc02034ba:	8699                	srai	a3,a3,0x6
ffffffffc02034bc:	96c6                	add	a3,a3,a7
    return KADDR(page2pa(page));
ffffffffc02034be:	0176f5b3          	and	a1,a3,s7
    return page2ppn(page) << PGSHIFT;
ffffffffc02034c2:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02034c4:	06c5fd63          	bgeu	a1,a2,ffffffffc020353e <copy_range+0x1c8>
    return page - pages + nbase;
ffffffffc02034c8:	40ec0733          	sub	a4,s8,a4
    return KADDR(page2pa(page));
ffffffffc02034cc:	000b2797          	auipc	a5,0xb2
ffffffffc02034d0:	b4c78793          	addi	a5,a5,-1204 # ffffffffc02b5018 <va_pa_offset>
ffffffffc02034d4:	6388                	ld	a0,0(a5)
    return page - pages + nbase;
ffffffffc02034d6:	8719                	srai	a4,a4,0x6
ffffffffc02034d8:	9746                	add	a4,a4,a7
    return KADDR(page2pa(page));
ffffffffc02034da:	017778b3          	and	a7,a4,s7
ffffffffc02034de:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02034e2:	0732                	slli	a4,a4,0xc
    return KADDR(page2pa(page));
ffffffffc02034e4:	04c8fc63          	bgeu	a7,a2,ffffffffc020353c <copy_range+0x1c6>
                memcpy((void *)dst_kvaddr, (void *)src_kvaddr, PGSIZE);
ffffffffc02034e8:	6605                	lui	a2,0x1
ffffffffc02034ea:	953a                	add	a0,a0,a4
ffffffffc02034ec:	200020ef          	jal	ra,ffffffffc02056ec <memcpy>
                ret = page_insert(to, npage, start, perm);
ffffffffc02034f0:	01f97693          	andi	a3,s2,31
ffffffffc02034f4:	866e                	mv	a2,s11
ffffffffc02034f6:	85e2                	mv	a1,s8
ffffffffc02034f8:	8552                	mv	a0,s4
ffffffffc02034fa:	946ff0ef          	jal	ra,ffffffffc0202640 <page_insert>
                assert(ret == 0);
ffffffffc02034fe:	ee0507e3          	beqz	a0,ffffffffc02033ec <copy_range+0x76>
ffffffffc0203502:	00003697          	auipc	a3,0x3
ffffffffc0203506:	7a668693          	addi	a3,a3,1958 # ffffffffc0206ca8 <default_pmm_manager+0x760>
ffffffffc020350a:	00003617          	auipc	a2,0x3
ffffffffc020350e:	a5e60613          	addi	a2,a2,-1442 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203512:	1bb00593          	li	a1,443
ffffffffc0203516:	00003517          	auipc	a0,0x3
ffffffffc020351a:	18250513          	addi	a0,a0,386 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc020351e:	f71fc0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc0203522:	c92fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203526:	000d3703          	ld	a4,0(s10)
ffffffffc020352a:	4505                	li	a0,1
ffffffffc020352c:	6f18                	ld	a4,24(a4)
ffffffffc020352e:	9702                	jalr	a4
ffffffffc0203530:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0203532:	c7cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203536:	bf85                	j	ffffffffc02034a6 <copy_range+0x130>
                return -E_NO_MEM;
ffffffffc0203538:	5571                	li	a0,-4
ffffffffc020353a:	bd6d                	j	ffffffffc02033f4 <copy_range+0x7e>
ffffffffc020353c:	86ba                	mv	a3,a4
ffffffffc020353e:	00003617          	auipc	a2,0x3
ffffffffc0203542:	04260613          	addi	a2,a2,66 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0203546:	07100593          	li	a1,113
ffffffffc020354a:	00003517          	auipc	a0,0x3
ffffffffc020354e:	05e50513          	addi	a0,a0,94 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0203552:	f3dfc0ef          	jal	ra,ffffffffc020048e <__panic>
                assert(npage != NULL);
ffffffffc0203556:	00003697          	auipc	a3,0x3
ffffffffc020355a:	74268693          	addi	a3,a3,1858 # ffffffffc0206c98 <default_pmm_manager+0x750>
ffffffffc020355e:	00003617          	auipc	a2,0x3
ffffffffc0203562:	a0a60613          	addi	a2,a2,-1526 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203566:	1b600593          	li	a1,438
ffffffffc020356a:	00003517          	auipc	a0,0x3
ffffffffc020356e:	12e50513          	addi	a0,a0,302 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203572:	f1dfc0ef          	jal	ra,ffffffffc020048e <__panic>
            assert(page != NULL);
ffffffffc0203576:	00003697          	auipc	a3,0x3
ffffffffc020357a:	71268693          	addi	a3,a3,1810 # ffffffffc0206c88 <default_pmm_manager+0x740>
ffffffffc020357e:	00003617          	auipc	a2,0x3
ffffffffc0203582:	9ea60613          	addi	a2,a2,-1558 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203586:	19300593          	li	a1,403
ffffffffc020358a:	00003517          	auipc	a0,0x3
ffffffffc020358e:	10e50513          	addi	a0,a0,270 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203592:	efdfc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203596:	00003617          	auipc	a2,0x3
ffffffffc020359a:	0ba60613          	addi	a2,a2,186 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc020359e:	06900593          	li	a1,105
ffffffffc02035a2:	00003517          	auipc	a0,0x3
ffffffffc02035a6:	00650513          	addi	a0,a0,6 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02035aa:	ee5fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02035ae:	00003617          	auipc	a2,0x3
ffffffffc02035b2:	0c260613          	addi	a2,a2,194 # ffffffffc0206670 <default_pmm_manager+0x128>
ffffffffc02035b6:	07f00593          	li	a1,127
ffffffffc02035ba:	00003517          	auipc	a0,0x3
ffffffffc02035be:	fee50513          	addi	a0,a0,-18 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02035c2:	ecdfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02035c6:	00003697          	auipc	a3,0x3
ffffffffc02035ca:	11268693          	addi	a3,a3,274 # ffffffffc02066d8 <default_pmm_manager+0x190>
ffffffffc02035ce:	00003617          	auipc	a2,0x3
ffffffffc02035d2:	99a60613          	addi	a2,a2,-1638 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02035d6:	17c00593          	li	a1,380
ffffffffc02035da:	00003517          	auipc	a0,0x3
ffffffffc02035de:	0be50513          	addi	a0,a0,190 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02035e2:	eadfc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02035e6:	00003697          	auipc	a3,0x3
ffffffffc02035ea:	0c268693          	addi	a3,a3,194 # ffffffffc02066a8 <default_pmm_manager+0x160>
ffffffffc02035ee:	00003617          	auipc	a2,0x3
ffffffffc02035f2:	97a60613          	addi	a2,a2,-1670 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02035f6:	17b00593          	li	a1,379
ffffffffc02035fa:	00003517          	auipc	a0,0x3
ffffffffc02035fe:	09e50513          	addi	a0,a0,158 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc0203602:	e8dfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203606 <pgdir_alloc_page>:
{
ffffffffc0203606:	7179                	addi	sp,sp,-48
ffffffffc0203608:	ec26                	sd	s1,24(sp)
ffffffffc020360a:	e84a                	sd	s2,16(sp)
ffffffffc020360c:	e052                	sd	s4,0(sp)
ffffffffc020360e:	f406                	sd	ra,40(sp)
ffffffffc0203610:	f022                	sd	s0,32(sp)
ffffffffc0203612:	e44e                	sd	s3,8(sp)
ffffffffc0203614:	8a2a                	mv	s4,a0
ffffffffc0203616:	84ae                	mv	s1,a1
ffffffffc0203618:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020361a:	100027f3          	csrr	a5,sstatus
ffffffffc020361e:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc0203620:	000b2997          	auipc	s3,0xb2
ffffffffc0203624:	9f098993          	addi	s3,s3,-1552 # ffffffffc02b5010 <pmm_manager>
ffffffffc0203628:	ef8d                	bnez	a5,ffffffffc0203662 <pgdir_alloc_page+0x5c>
ffffffffc020362a:	0009b783          	ld	a5,0(s3)
ffffffffc020362e:	4505                	li	a0,1
ffffffffc0203630:	6f9c                	ld	a5,24(a5)
ffffffffc0203632:	9782                	jalr	a5
ffffffffc0203634:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0203636:	cc09                	beqz	s0,ffffffffc0203650 <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0203638:	86ca                	mv	a3,s2
ffffffffc020363a:	8626                	mv	a2,s1
ffffffffc020363c:	85a2                	mv	a1,s0
ffffffffc020363e:	8552                	mv	a0,s4
ffffffffc0203640:	800ff0ef          	jal	ra,ffffffffc0202640 <page_insert>
ffffffffc0203644:	e915                	bnez	a0,ffffffffc0203678 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0203646:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0203648:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc020364a:	4785                	li	a5,1
ffffffffc020364c:	04f71e63          	bne	a4,a5,ffffffffc02036a8 <pgdir_alloc_page+0xa2>
}
ffffffffc0203650:	70a2                	ld	ra,40(sp)
ffffffffc0203652:	8522                	mv	a0,s0
ffffffffc0203654:	7402                	ld	s0,32(sp)
ffffffffc0203656:	64e2                	ld	s1,24(sp)
ffffffffc0203658:	6942                	ld	s2,16(sp)
ffffffffc020365a:	69a2                	ld	s3,8(sp)
ffffffffc020365c:	6a02                	ld	s4,0(sp)
ffffffffc020365e:	6145                	addi	sp,sp,48
ffffffffc0203660:	8082                	ret
        intr_disable();
ffffffffc0203662:	b52fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0203666:	0009b783          	ld	a5,0(s3)
ffffffffc020366a:	4505                	li	a0,1
ffffffffc020366c:	6f9c                	ld	a5,24(a5)
ffffffffc020366e:	9782                	jalr	a5
ffffffffc0203670:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0203672:	b3cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0203676:	b7c1                	j	ffffffffc0203636 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203678:	100027f3          	csrr	a5,sstatus
ffffffffc020367c:	8b89                	andi	a5,a5,2
ffffffffc020367e:	eb89                	bnez	a5,ffffffffc0203690 <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc0203680:	0009b783          	ld	a5,0(s3)
ffffffffc0203684:	8522                	mv	a0,s0
ffffffffc0203686:	4585                	li	a1,1
ffffffffc0203688:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020368a:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc020368c:	9782                	jalr	a5
    if (flag)
ffffffffc020368e:	b7c9                	j	ffffffffc0203650 <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc0203690:	b24fd0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
ffffffffc0203694:	0009b783          	ld	a5,0(s3)
ffffffffc0203698:	8522                	mv	a0,s0
ffffffffc020369a:	4585                	li	a1,1
ffffffffc020369c:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc020369e:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02036a0:	9782                	jalr	a5
        intr_enable();
ffffffffc02036a2:	b0cfd0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02036a6:	b76d                	j	ffffffffc0203650 <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc02036a8:	00003697          	auipc	a3,0x3
ffffffffc02036ac:	61068693          	addi	a3,a3,1552 # ffffffffc0206cb8 <default_pmm_manager+0x770>
ffffffffc02036b0:	00003617          	auipc	a2,0x3
ffffffffc02036b4:	8b860613          	addi	a2,a2,-1864 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02036b8:	20500593          	li	a1,517
ffffffffc02036bc:	00003517          	auipc	a0,0x3
ffffffffc02036c0:	fdc50513          	addi	a0,a0,-36 # ffffffffc0206698 <default_pmm_manager+0x150>
ffffffffc02036c4:	dcbfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036c8 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036c8:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02036ca:	00003697          	auipc	a3,0x3
ffffffffc02036ce:	60668693          	addi	a3,a3,1542 # ffffffffc0206cd0 <default_pmm_manager+0x788>
ffffffffc02036d2:	00003617          	auipc	a2,0x3
ffffffffc02036d6:	89660613          	addi	a2,a2,-1898 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02036da:	07400593          	li	a1,116
ffffffffc02036de:	00003517          	auipc	a0,0x3
ffffffffc02036e2:	61250513          	addi	a0,a0,1554 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02036e6:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc02036e8:	da7fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02036ec <mm_create>:
{
ffffffffc02036ec:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036ee:	04000513          	li	a0,64
{
ffffffffc02036f2:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc02036f4:	dc6fe0ef          	jal	ra,ffffffffc0201cba <kmalloc>
    if (mm != NULL)
ffffffffc02036f8:	cd19                	beqz	a0,ffffffffc0203716 <mm_create+0x2a>
    elm->prev = elm->next = elm;
ffffffffc02036fa:	e508                	sd	a0,8(a0)
ffffffffc02036fc:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc02036fe:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203702:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203706:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020370a:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc020370e:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc0203712:	02053c23          	sd	zero,56(a0)
}
ffffffffc0203716:	60a2                	ld	ra,8(sp)
ffffffffc0203718:	0141                	addi	sp,sp,16
ffffffffc020371a:	8082                	ret

ffffffffc020371c <find_vma>:
{
ffffffffc020371c:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc020371e:	c505                	beqz	a0,ffffffffc0203746 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0203720:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0203722:	c501                	beqz	a0,ffffffffc020372a <find_vma+0xe>
ffffffffc0203724:	651c                	ld	a5,8(a0)
ffffffffc0203726:	02f5f263          	bgeu	a1,a5,ffffffffc020374a <find_vma+0x2e>
    return listelm->next;
ffffffffc020372a:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc020372c:	00f68d63          	beq	a3,a5,ffffffffc0203746 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0203730:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203734:	00e5e663          	bltu	a1,a4,ffffffffc0203740 <find_vma+0x24>
ffffffffc0203738:	ff07b703          	ld	a4,-16(a5)
ffffffffc020373c:	00e5ec63          	bltu	a1,a4,ffffffffc0203754 <find_vma+0x38>
ffffffffc0203740:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0203742:	fef697e3          	bne	a3,a5,ffffffffc0203730 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0203746:	4501                	li	a0,0
}
ffffffffc0203748:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020374a:	691c                	ld	a5,16(a0)
ffffffffc020374c:	fcf5ffe3          	bgeu	a1,a5,ffffffffc020372a <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0203750:	ea88                	sd	a0,16(a3)
ffffffffc0203752:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0203754:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0203758:	ea88                	sd	a0,16(a3)
ffffffffc020375a:	8082                	ret

ffffffffc020375c <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc020375c:	6590                	ld	a2,8(a1)
ffffffffc020375e:	0105b803          	ld	a6,16(a1)
{
ffffffffc0203762:	1141                	addi	sp,sp,-16
ffffffffc0203764:	e406                	sd	ra,8(sp)
ffffffffc0203766:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0203768:	01066763          	bltu	a2,a6,ffffffffc0203776 <insert_vma_struct+0x1a>
ffffffffc020376c:	a085                	j	ffffffffc02037cc <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc020376e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203772:	04e66863          	bltu	a2,a4,ffffffffc02037c2 <insert_vma_struct+0x66>
ffffffffc0203776:	86be                	mv	a3,a5
ffffffffc0203778:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc020377a:	fef51ae3          	bne	a0,a5,ffffffffc020376e <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc020377e:	02a68463          	beq	a3,a0,ffffffffc02037a6 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0203782:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0203786:	fe86b883          	ld	a7,-24(a3)
ffffffffc020378a:	08e8f163          	bgeu	a7,a4,ffffffffc020380c <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020378e:	04e66f63          	bltu	a2,a4,ffffffffc02037ec <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0203792:	00f50a63          	beq	a0,a5,ffffffffc02037a6 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0203796:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc020379a:	05076963          	bltu	a4,a6,ffffffffc02037ec <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc020379e:	ff07b603          	ld	a2,-16(a5)
ffffffffc02037a2:	02c77363          	bgeu	a4,a2,ffffffffc02037c8 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02037a6:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02037a8:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02037aa:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc02037ae:	e390                	sd	a2,0(a5)
ffffffffc02037b0:	e690                	sd	a2,8(a3)
}
ffffffffc02037b2:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02037b4:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02037b6:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02037b8:	0017079b          	addiw	a5,a4,1
ffffffffc02037bc:	d11c                	sw	a5,32(a0)
}
ffffffffc02037be:	0141                	addi	sp,sp,16
ffffffffc02037c0:	8082                	ret
    if (le_prev != list)
ffffffffc02037c2:	fca690e3          	bne	a3,a0,ffffffffc0203782 <insert_vma_struct+0x26>
ffffffffc02037c6:	bfd1                	j	ffffffffc020379a <insert_vma_struct+0x3e>
ffffffffc02037c8:	f01ff0ef          	jal	ra,ffffffffc02036c8 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02037cc:	00003697          	auipc	a3,0x3
ffffffffc02037d0:	53468693          	addi	a3,a3,1332 # ffffffffc0206d00 <default_pmm_manager+0x7b8>
ffffffffc02037d4:	00002617          	auipc	a2,0x2
ffffffffc02037d8:	79460613          	addi	a2,a2,1940 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02037dc:	07a00593          	li	a1,122
ffffffffc02037e0:	00003517          	auipc	a0,0x3
ffffffffc02037e4:	51050513          	addi	a0,a0,1296 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc02037e8:	ca7fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02037ec:	00003697          	auipc	a3,0x3
ffffffffc02037f0:	55468693          	addi	a3,a3,1364 # ffffffffc0206d40 <default_pmm_manager+0x7f8>
ffffffffc02037f4:	00002617          	auipc	a2,0x2
ffffffffc02037f8:	77460613          	addi	a2,a2,1908 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02037fc:	07300593          	li	a1,115
ffffffffc0203800:	00003517          	auipc	a0,0x3
ffffffffc0203804:	4f050513          	addi	a0,a0,1264 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203808:	c87fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020380c:	00003697          	auipc	a3,0x3
ffffffffc0203810:	51468693          	addi	a3,a3,1300 # ffffffffc0206d20 <default_pmm_manager+0x7d8>
ffffffffc0203814:	00002617          	auipc	a2,0x2
ffffffffc0203818:	75460613          	addi	a2,a2,1876 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020381c:	07200593          	li	a1,114
ffffffffc0203820:	00003517          	auipc	a0,0x3
ffffffffc0203824:	4d050513          	addi	a0,a0,1232 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203828:	c67fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020382c <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc020382c:	591c                	lw	a5,48(a0)
{
ffffffffc020382e:	1141                	addi	sp,sp,-16
ffffffffc0203830:	e406                	sd	ra,8(sp)
ffffffffc0203832:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc0203834:	e78d                	bnez	a5,ffffffffc020385e <mm_destroy+0x32>
ffffffffc0203836:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0203838:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc020383a:	00a40c63          	beq	s0,a0,ffffffffc0203852 <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc020383e:	6118                	ld	a4,0(a0)
ffffffffc0203840:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203842:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203844:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203846:	e398                	sd	a4,0(a5)
ffffffffc0203848:	d22fe0ef          	jal	ra,ffffffffc0201d6a <kfree>
    return listelm->next;
ffffffffc020384c:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc020384e:	fea418e3          	bne	s0,a0,ffffffffc020383e <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc0203852:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc0203854:	6402                	ld	s0,0(sp)
ffffffffc0203856:	60a2                	ld	ra,8(sp)
ffffffffc0203858:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc020385a:	d10fe06f          	j	ffffffffc0201d6a <kfree>
    assert(mm_count(mm) == 0);
ffffffffc020385e:	00003697          	auipc	a3,0x3
ffffffffc0203862:	50268693          	addi	a3,a3,1282 # ffffffffc0206d60 <default_pmm_manager+0x818>
ffffffffc0203866:	00002617          	auipc	a2,0x2
ffffffffc020386a:	70260613          	addi	a2,a2,1794 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020386e:	09e00593          	li	a1,158
ffffffffc0203872:	00003517          	auipc	a0,0x3
ffffffffc0203876:	47e50513          	addi	a0,a0,1150 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc020387a:	c15fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020387e <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc020387e:	7139                	addi	sp,sp,-64
ffffffffc0203880:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203882:	6405                	lui	s0,0x1
ffffffffc0203884:	147d                	addi	s0,s0,-1
ffffffffc0203886:	77fd                	lui	a5,0xfffff
ffffffffc0203888:	9622                	add	a2,a2,s0
ffffffffc020388a:	962e                	add	a2,a2,a1
{
ffffffffc020388c:	f426                	sd	s1,40(sp)
ffffffffc020388e:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc0203890:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc0203894:	f04a                	sd	s2,32(sp)
ffffffffc0203896:	ec4e                	sd	s3,24(sp)
ffffffffc0203898:	e852                	sd	s4,16(sp)
ffffffffc020389a:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc020389c:	002005b7          	lui	a1,0x200
ffffffffc02038a0:	00f67433          	and	s0,a2,a5
ffffffffc02038a4:	06b4e363          	bltu	s1,a1,ffffffffc020390a <mm_map+0x8c>
ffffffffc02038a8:	0684f163          	bgeu	s1,s0,ffffffffc020390a <mm_map+0x8c>
ffffffffc02038ac:	4785                	li	a5,1
ffffffffc02038ae:	07fe                	slli	a5,a5,0x1f
ffffffffc02038b0:	0487ed63          	bltu	a5,s0,ffffffffc020390a <mm_map+0x8c>
ffffffffc02038b4:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02038b6:	cd21                	beqz	a0,ffffffffc020390e <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc02038b8:	85a6                	mv	a1,s1
ffffffffc02038ba:	8ab6                	mv	s5,a3
ffffffffc02038bc:	8a3a                	mv	s4,a4
ffffffffc02038be:	e5fff0ef          	jal	ra,ffffffffc020371c <find_vma>
ffffffffc02038c2:	c501                	beqz	a0,ffffffffc02038ca <mm_map+0x4c>
ffffffffc02038c4:	651c                	ld	a5,8(a0)
ffffffffc02038c6:	0487e263          	bltu	a5,s0,ffffffffc020390a <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02038ca:	03000513          	li	a0,48
ffffffffc02038ce:	becfe0ef          	jal	ra,ffffffffc0201cba <kmalloc>
ffffffffc02038d2:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02038d4:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc02038d6:	02090163          	beqz	s2,ffffffffc02038f8 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc02038da:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc02038dc:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc02038e0:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc02038e4:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc02038e8:	85ca                	mv	a1,s2
ffffffffc02038ea:	e73ff0ef          	jal	ra,ffffffffc020375c <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc02038ee:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc02038f0:	000a0463          	beqz	s4,ffffffffc02038f8 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc02038f4:	012a3023          	sd	s2,0(s4)

out:
    return ret;
}
ffffffffc02038f8:	70e2                	ld	ra,56(sp)
ffffffffc02038fa:	7442                	ld	s0,48(sp)
ffffffffc02038fc:	74a2                	ld	s1,40(sp)
ffffffffc02038fe:	7902                	ld	s2,32(sp)
ffffffffc0203900:	69e2                	ld	s3,24(sp)
ffffffffc0203902:	6a42                	ld	s4,16(sp)
ffffffffc0203904:	6aa2                	ld	s5,8(sp)
ffffffffc0203906:	6121                	addi	sp,sp,64
ffffffffc0203908:	8082                	ret
        return -E_INVAL;
ffffffffc020390a:	5575                	li	a0,-3
ffffffffc020390c:	b7f5                	j	ffffffffc02038f8 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc020390e:	00003697          	auipc	a3,0x3
ffffffffc0203912:	46a68693          	addi	a3,a3,1130 # ffffffffc0206d78 <default_pmm_manager+0x830>
ffffffffc0203916:	00002617          	auipc	a2,0x2
ffffffffc020391a:	65260613          	addi	a2,a2,1618 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020391e:	0b300593          	li	a1,179
ffffffffc0203922:	00003517          	auipc	a0,0x3
ffffffffc0203926:	3ce50513          	addi	a0,a0,974 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc020392a:	b65fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020392e <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc020392e:	7139                	addi	sp,sp,-64
ffffffffc0203930:	fc06                	sd	ra,56(sp)
ffffffffc0203932:	f822                	sd	s0,48(sp)
ffffffffc0203934:	f426                	sd	s1,40(sp)
ffffffffc0203936:	f04a                	sd	s2,32(sp)
ffffffffc0203938:	ec4e                	sd	s3,24(sp)
ffffffffc020393a:	e852                	sd	s4,16(sp)
ffffffffc020393c:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc020393e:	c52d                	beqz	a0,ffffffffc02039a8 <dup_mmap+0x7a>
ffffffffc0203940:	892a                	mv	s2,a0
ffffffffc0203942:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0203944:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0203946:	e595                	bnez	a1,ffffffffc0203972 <dup_mmap+0x44>
ffffffffc0203948:	a085                	j	ffffffffc02039a8 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc020394a:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc020394c:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ee8>
        vma->vm_end = vm_end;
ffffffffc0203950:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0203954:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0203958:	e05ff0ef          	jal	ra,ffffffffc020375c <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc020395c:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bb8>
ffffffffc0203960:	fe843603          	ld	a2,-24(s0)
ffffffffc0203964:	6c8c                	ld	a1,24(s1)
ffffffffc0203966:	01893503          	ld	a0,24(s2)
ffffffffc020396a:	4701                	li	a4,0
ffffffffc020396c:	a0bff0ef          	jal	ra,ffffffffc0203376 <copy_range>
ffffffffc0203970:	e105                	bnez	a0,ffffffffc0203990 <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0203972:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0203974:	02848863          	beq	s1,s0,ffffffffc02039a4 <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203978:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc020397c:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203980:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203984:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203988:	b32fe0ef          	jal	ra,ffffffffc0201cba <kmalloc>
ffffffffc020398c:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc020398e:	fd55                	bnez	a0,ffffffffc020394a <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0203990:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0203992:	70e2                	ld	ra,56(sp)
ffffffffc0203994:	7442                	ld	s0,48(sp)
ffffffffc0203996:	74a2                	ld	s1,40(sp)
ffffffffc0203998:	7902                	ld	s2,32(sp)
ffffffffc020399a:	69e2                	ld	s3,24(sp)
ffffffffc020399c:	6a42                	ld	s4,16(sp)
ffffffffc020399e:	6aa2                	ld	s5,8(sp)
ffffffffc02039a0:	6121                	addi	sp,sp,64
ffffffffc02039a2:	8082                	ret
    return 0;
ffffffffc02039a4:	4501                	li	a0,0
ffffffffc02039a6:	b7f5                	j	ffffffffc0203992 <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc02039a8:	00003697          	auipc	a3,0x3
ffffffffc02039ac:	3e068693          	addi	a3,a3,992 # ffffffffc0206d88 <default_pmm_manager+0x840>
ffffffffc02039b0:	00002617          	auipc	a2,0x2
ffffffffc02039b4:	5b860613          	addi	a2,a2,1464 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02039b8:	0cf00593          	li	a1,207
ffffffffc02039bc:	00003517          	auipc	a0,0x3
ffffffffc02039c0:	33450513          	addi	a0,a0,820 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc02039c4:	acbfc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02039c8 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc02039c8:	1101                	addi	sp,sp,-32
ffffffffc02039ca:	ec06                	sd	ra,24(sp)
ffffffffc02039cc:	e822                	sd	s0,16(sp)
ffffffffc02039ce:	e426                	sd	s1,8(sp)
ffffffffc02039d0:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc02039d2:	c531                	beqz	a0,ffffffffc0203a1e <exit_mmap+0x56>
ffffffffc02039d4:	591c                	lw	a5,48(a0)
ffffffffc02039d6:	84aa                	mv	s1,a0
ffffffffc02039d8:	e3b9                	bnez	a5,ffffffffc0203a1e <exit_mmap+0x56>
    return listelm->next;
ffffffffc02039da:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc02039dc:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc02039e0:	02850663          	beq	a0,s0,ffffffffc0203a0c <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039e4:	ff043603          	ld	a2,-16(s0)
ffffffffc02039e8:	fe843583          	ld	a1,-24(s0)
ffffffffc02039ec:	854a                	mv	a0,s2
ffffffffc02039ee:	fdefe0ef          	jal	ra,ffffffffc02021cc <unmap_range>
ffffffffc02039f2:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc02039f4:	fe8498e3          	bne	s1,s0,ffffffffc02039e4 <exit_mmap+0x1c>
ffffffffc02039f8:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc02039fa:	00848c63          	beq	s1,s0,ffffffffc0203a12 <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc02039fe:	ff043603          	ld	a2,-16(s0)
ffffffffc0203a02:	fe843583          	ld	a1,-24(s0)
ffffffffc0203a06:	854a                	mv	a0,s2
ffffffffc0203a08:	90bfe0ef          	jal	ra,ffffffffc0202312 <exit_range>
ffffffffc0203a0c:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0203a0e:	fe8498e3          	bne	s1,s0,ffffffffc02039fe <exit_mmap+0x36>
    }
}
ffffffffc0203a12:	60e2                	ld	ra,24(sp)
ffffffffc0203a14:	6442                	ld	s0,16(sp)
ffffffffc0203a16:	64a2                	ld	s1,8(sp)
ffffffffc0203a18:	6902                	ld	s2,0(sp)
ffffffffc0203a1a:	6105                	addi	sp,sp,32
ffffffffc0203a1c:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0203a1e:	00003697          	auipc	a3,0x3
ffffffffc0203a22:	38a68693          	addi	a3,a3,906 # ffffffffc0206da8 <default_pmm_manager+0x860>
ffffffffc0203a26:	00002617          	auipc	a2,0x2
ffffffffc0203a2a:	54260613          	addi	a2,a2,1346 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203a2e:	0e800593          	li	a1,232
ffffffffc0203a32:	00003517          	auipc	a0,0x3
ffffffffc0203a36:	2be50513          	addi	a0,a0,702 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203a3a:	a55fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203a3e <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0203a3e:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a40:	04000513          	li	a0,64
{
ffffffffc0203a44:	fc06                	sd	ra,56(sp)
ffffffffc0203a46:	f822                	sd	s0,48(sp)
ffffffffc0203a48:	f426                	sd	s1,40(sp)
ffffffffc0203a4a:	f04a                	sd	s2,32(sp)
ffffffffc0203a4c:	ec4e                	sd	s3,24(sp)
ffffffffc0203a4e:	e852                	sd	s4,16(sp)
ffffffffc0203a50:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0203a52:	a68fe0ef          	jal	ra,ffffffffc0201cba <kmalloc>
    if (mm != NULL)
ffffffffc0203a56:	2e050663          	beqz	a0,ffffffffc0203d42 <vmm_init+0x304>
ffffffffc0203a5a:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0203a5c:	e508                	sd	a0,8(a0)
ffffffffc0203a5e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0203a60:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0203a64:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0203a68:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0203a6c:	02053423          	sd	zero,40(a0)
ffffffffc0203a70:	02052823          	sw	zero,48(a0)
ffffffffc0203a74:	02053c23          	sd	zero,56(a0)
ffffffffc0203a78:	03200413          	li	s0,50
ffffffffc0203a7c:	a811                	j	ffffffffc0203a90 <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0203a7e:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203a80:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203a82:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0203a86:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203a88:	8526                	mv	a0,s1
ffffffffc0203a8a:	cd3ff0ef          	jal	ra,ffffffffc020375c <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0203a8e:	c80d                	beqz	s0,ffffffffc0203ac0 <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203a90:	03000513          	li	a0,48
ffffffffc0203a94:	a26fe0ef          	jal	ra,ffffffffc0201cba <kmalloc>
ffffffffc0203a98:	85aa                	mv	a1,a0
ffffffffc0203a9a:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203a9e:	f165                	bnez	a0,ffffffffc0203a7e <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0203aa0:	00003697          	auipc	a3,0x3
ffffffffc0203aa4:	4a068693          	addi	a3,a3,1184 # ffffffffc0206f40 <default_pmm_manager+0x9f8>
ffffffffc0203aa8:	00002617          	auipc	a2,0x2
ffffffffc0203aac:	4c060613          	addi	a2,a2,1216 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203ab0:	12c00593          	li	a1,300
ffffffffc0203ab4:	00003517          	auipc	a0,0x3
ffffffffc0203ab8:	23c50513          	addi	a0,a0,572 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203abc:	9d3fc0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0203ac0:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ac4:	1f900913          	li	s2,505
ffffffffc0203ac8:	a819                	j	ffffffffc0203ade <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0203aca:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0203acc:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0203ace:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ad2:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0203ad4:	8526                	mv	a0,s1
ffffffffc0203ad6:	c87ff0ef          	jal	ra,ffffffffc020375c <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0203ada:	03240a63          	beq	s0,s2,ffffffffc0203b0e <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0203ade:	03000513          	li	a0,48
ffffffffc0203ae2:	9d8fe0ef          	jal	ra,ffffffffc0201cba <kmalloc>
ffffffffc0203ae6:	85aa                	mv	a1,a0
ffffffffc0203ae8:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0203aec:	fd79                	bnez	a0,ffffffffc0203aca <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0203aee:	00003697          	auipc	a3,0x3
ffffffffc0203af2:	45268693          	addi	a3,a3,1106 # ffffffffc0206f40 <default_pmm_manager+0x9f8>
ffffffffc0203af6:	00002617          	auipc	a2,0x2
ffffffffc0203afa:	47260613          	addi	a2,a2,1138 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203afe:	13300593          	li	a1,307
ffffffffc0203b02:	00003517          	auipc	a0,0x3
ffffffffc0203b06:	1ee50513          	addi	a0,a0,494 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203b0a:	985fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return listelm->next;
ffffffffc0203b0e:	649c                	ld	a5,8(s1)
ffffffffc0203b10:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0203b12:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0203b16:	16f48663          	beq	s1,a5,ffffffffc0203c82 <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203b1a:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd49fac>
ffffffffc0203b1e:	ffe70693          	addi	a3,a4,-2 # 1ffffe <_binary_obj___user_exit_out_size+0x1f4ede>
ffffffffc0203b22:	10d61063          	bne	a2,a3,ffffffffc0203c22 <vmm_init+0x1e4>
ffffffffc0203b26:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203b2a:	0ed71c63          	bne	a4,a3,ffffffffc0203c22 <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0203b2e:	0715                	addi	a4,a4,5
ffffffffc0203b30:	679c                	ld	a5,8(a5)
ffffffffc0203b32:	feb712e3          	bne	a4,a1,ffffffffc0203b16 <vmm_init+0xd8>
ffffffffc0203b36:	4a1d                	li	s4,7
ffffffffc0203b38:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203b3a:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0203b3e:	85a2                	mv	a1,s0
ffffffffc0203b40:	8526                	mv	a0,s1
ffffffffc0203b42:	bdbff0ef          	jal	ra,ffffffffc020371c <find_vma>
ffffffffc0203b46:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0203b48:	16050d63          	beqz	a0,ffffffffc0203cc2 <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0203b4c:	00140593          	addi	a1,s0,1
ffffffffc0203b50:	8526                	mv	a0,s1
ffffffffc0203b52:	bcbff0ef          	jal	ra,ffffffffc020371c <find_vma>
ffffffffc0203b56:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0203b58:	14050563          	beqz	a0,ffffffffc0203ca2 <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0203b5c:	85d2                	mv	a1,s4
ffffffffc0203b5e:	8526                	mv	a0,s1
ffffffffc0203b60:	bbdff0ef          	jal	ra,ffffffffc020371c <find_vma>
        assert(vma3 == NULL);
ffffffffc0203b64:	16051f63          	bnez	a0,ffffffffc0203ce2 <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0203b68:	00340593          	addi	a1,s0,3
ffffffffc0203b6c:	8526                	mv	a0,s1
ffffffffc0203b6e:	bafff0ef          	jal	ra,ffffffffc020371c <find_vma>
        assert(vma4 == NULL);
ffffffffc0203b72:	1a051863          	bnez	a0,ffffffffc0203d22 <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0203b76:	00440593          	addi	a1,s0,4
ffffffffc0203b7a:	8526                	mv	a0,s1
ffffffffc0203b7c:	ba1ff0ef          	jal	ra,ffffffffc020371c <find_vma>
        assert(vma5 == NULL);
ffffffffc0203b80:	18051163          	bnez	a0,ffffffffc0203d02 <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203b84:	00893783          	ld	a5,8(s2)
ffffffffc0203b88:	0a879d63          	bne	a5,s0,ffffffffc0203c42 <vmm_init+0x204>
ffffffffc0203b8c:	01093783          	ld	a5,16(s2)
ffffffffc0203b90:	0b479963          	bne	a5,s4,ffffffffc0203c42 <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203b94:	0089b783          	ld	a5,8(s3)
ffffffffc0203b98:	0c879563          	bne	a5,s0,ffffffffc0203c62 <vmm_init+0x224>
ffffffffc0203b9c:	0109b783          	ld	a5,16(s3)
ffffffffc0203ba0:	0d479163          	bne	a5,s4,ffffffffc0203c62 <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0203ba4:	0415                	addi	s0,s0,5
ffffffffc0203ba6:	0a15                	addi	s4,s4,5
ffffffffc0203ba8:	f9541be3          	bne	s0,s5,ffffffffc0203b3e <vmm_init+0x100>
ffffffffc0203bac:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203bae:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203bb0:	85a2                	mv	a1,s0
ffffffffc0203bb2:	8526                	mv	a0,s1
ffffffffc0203bb4:	b69ff0ef          	jal	ra,ffffffffc020371c <find_vma>
ffffffffc0203bb8:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203bbc:	c90d                	beqz	a0,ffffffffc0203bee <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203bbe:	6914                	ld	a3,16(a0)
ffffffffc0203bc0:	6510                	ld	a2,8(a0)
ffffffffc0203bc2:	00003517          	auipc	a0,0x3
ffffffffc0203bc6:	30650513          	addi	a0,a0,774 # ffffffffc0206ec8 <default_pmm_manager+0x980>
ffffffffc0203bca:	dcafc0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203bce:	00003697          	auipc	a3,0x3
ffffffffc0203bd2:	32268693          	addi	a3,a3,802 # ffffffffc0206ef0 <default_pmm_manager+0x9a8>
ffffffffc0203bd6:	00002617          	auipc	a2,0x2
ffffffffc0203bda:	39260613          	addi	a2,a2,914 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203bde:	15900593          	li	a1,345
ffffffffc0203be2:	00003517          	auipc	a0,0x3
ffffffffc0203be6:	10e50513          	addi	a0,a0,270 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203bea:	8a5fc0ef          	jal	ra,ffffffffc020048e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203bee:	147d                	addi	s0,s0,-1
ffffffffc0203bf0:	fd2410e3          	bne	s0,s2,ffffffffc0203bb0 <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0203bf4:	8526                	mv	a0,s1
ffffffffc0203bf6:	c37ff0ef          	jal	ra,ffffffffc020382c <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0203bfa:	00003517          	auipc	a0,0x3
ffffffffc0203bfe:	30e50513          	addi	a0,a0,782 # ffffffffc0206f08 <default_pmm_manager+0x9c0>
ffffffffc0203c02:	d92fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc0203c06:	7442                	ld	s0,48(sp)
ffffffffc0203c08:	70e2                	ld	ra,56(sp)
ffffffffc0203c0a:	74a2                	ld	s1,40(sp)
ffffffffc0203c0c:	7902                	ld	s2,32(sp)
ffffffffc0203c0e:	69e2                	ld	s3,24(sp)
ffffffffc0203c10:	6a42                	ld	s4,16(sp)
ffffffffc0203c12:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c14:	00003517          	auipc	a0,0x3
ffffffffc0203c18:	31450513          	addi	a0,a0,788 # ffffffffc0206f28 <default_pmm_manager+0x9e0>
}
ffffffffc0203c1c:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0203c1e:	d76fc06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0203c22:	00003697          	auipc	a3,0x3
ffffffffc0203c26:	1be68693          	addi	a3,a3,446 # ffffffffc0206de0 <default_pmm_manager+0x898>
ffffffffc0203c2a:	00002617          	auipc	a2,0x2
ffffffffc0203c2e:	33e60613          	addi	a2,a2,830 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203c32:	13d00593          	li	a1,317
ffffffffc0203c36:	00003517          	auipc	a0,0x3
ffffffffc0203c3a:	0ba50513          	addi	a0,a0,186 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c3e:	851fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0203c42:	00003697          	auipc	a3,0x3
ffffffffc0203c46:	22668693          	addi	a3,a3,550 # ffffffffc0206e68 <default_pmm_manager+0x920>
ffffffffc0203c4a:	00002617          	auipc	a2,0x2
ffffffffc0203c4e:	31e60613          	addi	a2,a2,798 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203c52:	14e00593          	li	a1,334
ffffffffc0203c56:	00003517          	auipc	a0,0x3
ffffffffc0203c5a:	09a50513          	addi	a0,a0,154 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c5e:	831fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203c62:	00003697          	auipc	a3,0x3
ffffffffc0203c66:	23668693          	addi	a3,a3,566 # ffffffffc0206e98 <default_pmm_manager+0x950>
ffffffffc0203c6a:	00002617          	auipc	a2,0x2
ffffffffc0203c6e:	2fe60613          	addi	a2,a2,766 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203c72:	14f00593          	li	a1,335
ffffffffc0203c76:	00003517          	auipc	a0,0x3
ffffffffc0203c7a:	07a50513          	addi	a0,a0,122 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c7e:	811fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203c82:	00003697          	auipc	a3,0x3
ffffffffc0203c86:	14668693          	addi	a3,a3,326 # ffffffffc0206dc8 <default_pmm_manager+0x880>
ffffffffc0203c8a:	00002617          	auipc	a2,0x2
ffffffffc0203c8e:	2de60613          	addi	a2,a2,734 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203c92:	13b00593          	li	a1,315
ffffffffc0203c96:	00003517          	auipc	a0,0x3
ffffffffc0203c9a:	05a50513          	addi	a0,a0,90 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203c9e:	ff0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma2 != NULL);
ffffffffc0203ca2:	00003697          	auipc	a3,0x3
ffffffffc0203ca6:	18668693          	addi	a3,a3,390 # ffffffffc0206e28 <default_pmm_manager+0x8e0>
ffffffffc0203caa:	00002617          	auipc	a2,0x2
ffffffffc0203cae:	2be60613          	addi	a2,a2,702 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203cb2:	14600593          	li	a1,326
ffffffffc0203cb6:	00003517          	auipc	a0,0x3
ffffffffc0203cba:	03a50513          	addi	a0,a0,58 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203cbe:	fd0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma1 != NULL);
ffffffffc0203cc2:	00003697          	auipc	a3,0x3
ffffffffc0203cc6:	15668693          	addi	a3,a3,342 # ffffffffc0206e18 <default_pmm_manager+0x8d0>
ffffffffc0203cca:	00002617          	auipc	a2,0x2
ffffffffc0203cce:	29e60613          	addi	a2,a2,670 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203cd2:	14400593          	li	a1,324
ffffffffc0203cd6:	00003517          	auipc	a0,0x3
ffffffffc0203cda:	01a50513          	addi	a0,a0,26 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203cde:	fb0fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma3 == NULL);
ffffffffc0203ce2:	00003697          	auipc	a3,0x3
ffffffffc0203ce6:	15668693          	addi	a3,a3,342 # ffffffffc0206e38 <default_pmm_manager+0x8f0>
ffffffffc0203cea:	00002617          	auipc	a2,0x2
ffffffffc0203cee:	27e60613          	addi	a2,a2,638 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203cf2:	14800593          	li	a1,328
ffffffffc0203cf6:	00003517          	auipc	a0,0x3
ffffffffc0203cfa:	ffa50513          	addi	a0,a0,-6 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203cfe:	f90fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma5 == NULL);
ffffffffc0203d02:	00003697          	auipc	a3,0x3
ffffffffc0203d06:	15668693          	addi	a3,a3,342 # ffffffffc0206e58 <default_pmm_manager+0x910>
ffffffffc0203d0a:	00002617          	auipc	a2,0x2
ffffffffc0203d0e:	25e60613          	addi	a2,a2,606 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203d12:	14c00593          	li	a1,332
ffffffffc0203d16:	00003517          	auipc	a0,0x3
ffffffffc0203d1a:	fda50513          	addi	a0,a0,-38 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203d1e:	f70fc0ef          	jal	ra,ffffffffc020048e <__panic>
        assert(vma4 == NULL);
ffffffffc0203d22:	00003697          	auipc	a3,0x3
ffffffffc0203d26:	12668693          	addi	a3,a3,294 # ffffffffc0206e48 <default_pmm_manager+0x900>
ffffffffc0203d2a:	00002617          	auipc	a2,0x2
ffffffffc0203d2e:	23e60613          	addi	a2,a2,574 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203d32:	14a00593          	li	a1,330
ffffffffc0203d36:	00003517          	auipc	a0,0x3
ffffffffc0203d3a:	fba50513          	addi	a0,a0,-70 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203d3e:	f50fc0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(mm != NULL);
ffffffffc0203d42:	00003697          	auipc	a3,0x3
ffffffffc0203d46:	03668693          	addi	a3,a3,54 # ffffffffc0206d78 <default_pmm_manager+0x830>
ffffffffc0203d4a:	00002617          	auipc	a2,0x2
ffffffffc0203d4e:	21e60613          	addi	a2,a2,542 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0203d52:	12400593          	li	a1,292
ffffffffc0203d56:	00003517          	auipc	a0,0x3
ffffffffc0203d5a:	f9a50513          	addi	a0,a0,-102 # ffffffffc0206cf0 <default_pmm_manager+0x7a8>
ffffffffc0203d5e:	f30fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203d62 <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0203d62:	7179                	addi	sp,sp,-48
ffffffffc0203d64:	f022                	sd	s0,32(sp)
ffffffffc0203d66:	f406                	sd	ra,40(sp)
ffffffffc0203d68:	ec26                	sd	s1,24(sp)
ffffffffc0203d6a:	e84a                	sd	s2,16(sp)
ffffffffc0203d6c:	e44e                	sd	s3,8(sp)
ffffffffc0203d6e:	e052                	sd	s4,0(sp)
ffffffffc0203d70:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0203d72:	c135                	beqz	a0,ffffffffc0203dd6 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0203d74:	002007b7          	lui	a5,0x200
ffffffffc0203d78:	04f5e663          	bltu	a1,a5,ffffffffc0203dc4 <user_mem_check+0x62>
ffffffffc0203d7c:	00c584b3          	add	s1,a1,a2
ffffffffc0203d80:	0495f263          	bgeu	a1,s1,ffffffffc0203dc4 <user_mem_check+0x62>
ffffffffc0203d84:	4785                	li	a5,1
ffffffffc0203d86:	07fe                	slli	a5,a5,0x1f
ffffffffc0203d88:	0297ee63          	bltu	a5,s1,ffffffffc0203dc4 <user_mem_check+0x62>
ffffffffc0203d8c:	892a                	mv	s2,a0
ffffffffc0203d8e:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d90:	6a05                	lui	s4,0x1
ffffffffc0203d92:	a821                	j	ffffffffc0203daa <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d94:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203d98:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d9a:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203d9c:	c685                	beqz	a3,ffffffffc0203dc4 <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0203d9e:	c399                	beqz	a5,ffffffffc0203da4 <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0203da0:	02e46263          	bltu	s0,a4,ffffffffc0203dc4 <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0203da4:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0203da6:	04947663          	bgeu	s0,s1,ffffffffc0203df2 <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0203daa:	85a2                	mv	a1,s0
ffffffffc0203dac:	854a                	mv	a0,s2
ffffffffc0203dae:	96fff0ef          	jal	ra,ffffffffc020371c <find_vma>
ffffffffc0203db2:	c909                	beqz	a0,ffffffffc0203dc4 <user_mem_check+0x62>
ffffffffc0203db4:	6518                	ld	a4,8(a0)
ffffffffc0203db6:	00e46763          	bltu	s0,a4,ffffffffc0203dc4 <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0203dba:	4d1c                	lw	a5,24(a0)
ffffffffc0203dbc:	fc099ce3          	bnez	s3,ffffffffc0203d94 <user_mem_check+0x32>
ffffffffc0203dc0:	8b85                	andi	a5,a5,1
ffffffffc0203dc2:	f3ed                	bnez	a5,ffffffffc0203da4 <user_mem_check+0x42>
            return 0;
ffffffffc0203dc4:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
}
ffffffffc0203dc6:	70a2                	ld	ra,40(sp)
ffffffffc0203dc8:	7402                	ld	s0,32(sp)
ffffffffc0203dca:	64e2                	ld	s1,24(sp)
ffffffffc0203dcc:	6942                	ld	s2,16(sp)
ffffffffc0203dce:	69a2                	ld	s3,8(sp)
ffffffffc0203dd0:	6a02                	ld	s4,0(sp)
ffffffffc0203dd2:	6145                	addi	sp,sp,48
ffffffffc0203dd4:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0203dd6:	c02007b7          	lui	a5,0xc0200
ffffffffc0203dda:	4501                	li	a0,0
ffffffffc0203ddc:	fef5e5e3          	bltu	a1,a5,ffffffffc0203dc6 <user_mem_check+0x64>
ffffffffc0203de0:	962e                	add	a2,a2,a1
ffffffffc0203de2:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203dc6 <user_mem_check+0x64>
ffffffffc0203de6:	c8000537          	lui	a0,0xc8000
ffffffffc0203dea:	0505                	addi	a0,a0,1
ffffffffc0203dec:	00a63533          	sltu	a0,a2,a0
ffffffffc0203df0:	bfd9                	j	ffffffffc0203dc6 <user_mem_check+0x64>
        return 1;
ffffffffc0203df2:	4505                	li	a0,1
ffffffffc0203df4:	bfc9                	j	ffffffffc0203dc6 <user_mem_check+0x64>

ffffffffc0203df6 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203df6:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203df8:	9402                	jalr	s0

	jal do_exit
ffffffffc0203dfa:	614000ef          	jal	ra,ffffffffc020440e <do_exit>

ffffffffc0203dfe <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203dfe:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203e00:	10800513          	li	a0,264
{
ffffffffc0203e04:	e022                	sd	s0,0(sp)
ffffffffc0203e06:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203e08:	eb3fd0ef          	jal	ra,ffffffffc0201cba <kmalloc>
ffffffffc0203e0c:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203e0e:	c525                	beqz	a0,ffffffffc0203e76 <alloc_proc+0x78>
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
        proc->state = PROC_UNINIT;
ffffffffc0203e10:	57fd                	li	a5,-1
ffffffffc0203e12:	1782                	slli	a5,a5,0x20
ffffffffc0203e14:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->need_resched = 0; 

        proc->kstack = 0;
        proc->mm = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203e16:	000b1797          	auipc	a5,0xb1
ffffffffc0203e1a:	1da7b783          	ld	a5,474(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
ffffffffc0203e1e:	f55c                	sd	a5,168(a0)
        proc->parent = NULL;
        proc->flags = 0;
        proc->wait_state = 0;
        proc->exit_code = 0;
        proc->cptr = proc->optr = proc->yptr = NULL;
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203e20:	4641                	li	a2,16
ffffffffc0203e22:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203e24:	00052423          	sw	zero,8(a0) # ffffffffc8000008 <end+0x7d4afcc>
        proc->need_resched = 0; 
ffffffffc0203e28:	00053c23          	sd	zero,24(a0)
        proc->kstack = 0;
ffffffffc0203e2c:	00053823          	sd	zero,16(a0)
        proc->mm = NULL;
ffffffffc0203e30:	02053423          	sd	zero,40(a0)
        proc->parent = NULL;
ffffffffc0203e34:	02053023          	sd	zero,32(a0)
        proc->flags = 0;
ffffffffc0203e38:	0a052823          	sw	zero,176(a0)
        proc->exit_code = 0;
ffffffffc0203e3c:	0e053423          	sd	zero,232(a0)
        proc->cptr = proc->optr = proc->yptr = NULL;
ffffffffc0203e40:	0e053823          	sd	zero,240(a0)
ffffffffc0203e44:	0e053c23          	sd	zero,248(a0)
ffffffffc0203e48:	10053023          	sd	zero,256(a0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203e4c:	0b450513          	addi	a0,a0,180
ffffffffc0203e50:	08b010ef          	jal	ra,ffffffffc02056da <memset>

        memset(&proc->context, 0, sizeof(proc->context));
ffffffffc0203e54:	07000613          	li	a2,112
ffffffffc0203e58:	4581                	li	a1,0
ffffffffc0203e5a:	03040513          	addi	a0,s0,48
ffffffffc0203e5e:	07d010ef          	jal	ra,ffffffffc02056da <memset>
        proc->tf = NULL;
        list_init(&(proc->list_link));
ffffffffc0203e62:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203e66:	0d840793          	addi	a5,s0,216
        proc->tf = NULL;
ffffffffc0203e6a:	0a043023          	sd	zero,160(s0)
    elm->prev = elm->next = elm;
ffffffffc0203e6e:	e878                	sd	a4,208(s0)
ffffffffc0203e70:	e478                	sd	a4,200(s0)
ffffffffc0203e72:	f07c                	sd	a5,224(s0)
ffffffffc0203e74:	ec7c                	sd	a5,216(s0)
    }
    return proc;
}
ffffffffc0203e76:	60a2                	ld	ra,8(sp)
ffffffffc0203e78:	8522                	mv	a0,s0
ffffffffc0203e7a:	6402                	ld	s0,0(sp)
ffffffffc0203e7c:	0141                	addi	sp,sp,16
ffffffffc0203e7e:	8082                	ret

ffffffffc0203e80 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203e80:	000b1797          	auipc	a5,0xb1
ffffffffc0203e84:	1a07b783          	ld	a5,416(a5) # ffffffffc02b5020 <current>
ffffffffc0203e88:	73c8                	ld	a0,160(a5)
ffffffffc0203e8a:	8a4fd06f          	j	ffffffffc0200f2e <forkrets>

ffffffffc0203e8e <user_main>:
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(forktest);
ffffffffc0203e8e:	000b1797          	auipc	a5,0xb1
ffffffffc0203e92:	1927b783          	ld	a5,402(a5) # ffffffffc02b5020 <current>
ffffffffc0203e96:	43cc                	lw	a1,4(a5)
{
ffffffffc0203e98:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE(forktest);
ffffffffc0203e9a:	00003617          	auipc	a2,0x3
ffffffffc0203e9e:	0b660613          	addi	a2,a2,182 # ffffffffc0206f50 <default_pmm_manager+0xa08>
ffffffffc0203ea2:	00003517          	auipc	a0,0x3
ffffffffc0203ea6:	0be50513          	addi	a0,a0,190 # ffffffffc0206f60 <default_pmm_manager+0xa18>
{
ffffffffc0203eaa:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE(forktest);
ffffffffc0203eac:	ae8fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0203eb0:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0203eb4:	ab878793          	addi	a5,a5,-1352 # a968 <_binary_obj___user_forktest_out_size>
ffffffffc0203eb8:	e43e                	sd	a5,8(sp)
ffffffffc0203eba:	00003517          	auipc	a0,0x3
ffffffffc0203ebe:	09650513          	addi	a0,a0,150 # ffffffffc0206f50 <default_pmm_manager+0xa08>
ffffffffc0203ec2:	00050797          	auipc	a5,0x50
ffffffffc0203ec6:	11e78793          	addi	a5,a5,286 # ffffffffc0253fe0 <_binary_obj___user_forktest_out_start>
ffffffffc0203eca:	f03e                	sd	a5,32(sp)
ffffffffc0203ecc:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203ece:	e802                	sd	zero,16(sp)
ffffffffc0203ed0:	768010ef          	jal	ra,ffffffffc0205638 <strlen>
ffffffffc0203ed4:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203ed6:	4511                	li	a0,4
ffffffffc0203ed8:	55a2                	lw	a1,40(sp)
ffffffffc0203eda:	4662                	lw	a2,24(sp)
ffffffffc0203edc:	5682                	lw	a3,32(sp)
ffffffffc0203ede:	4722                	lw	a4,8(sp)
ffffffffc0203ee0:	48a9                	li	a7,10
ffffffffc0203ee2:	9002                	ebreak
ffffffffc0203ee4:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203ee6:	65c2                	ld	a1,16(sp)
ffffffffc0203ee8:	00003517          	auipc	a0,0x3
ffffffffc0203eec:	0a050513          	addi	a0,a0,160 # ffffffffc0206f88 <default_pmm_manager+0xa40>
ffffffffc0203ef0:	aa4fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
#endif
    panic("user_main execve failed.\n");
ffffffffc0203ef4:	00003617          	auipc	a2,0x3
ffffffffc0203ef8:	0a460613          	addi	a2,a2,164 # ffffffffc0206f98 <default_pmm_manager+0xa50>
ffffffffc0203efc:	3b300593          	li	a1,947
ffffffffc0203f00:	00003517          	auipc	a0,0x3
ffffffffc0203f04:	0b850513          	addi	a0,a0,184 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0203f08:	d86fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f0c <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203f0c:	6d14                	ld	a3,24(a0)
{
ffffffffc0203f0e:	1141                	addi	sp,sp,-16
ffffffffc0203f10:	e406                	sd	ra,8(sp)
ffffffffc0203f12:	c02007b7          	lui	a5,0xc0200
ffffffffc0203f16:	02f6ee63          	bltu	a3,a5,ffffffffc0203f52 <put_pgdir+0x46>
ffffffffc0203f1a:	000b1517          	auipc	a0,0xb1
ffffffffc0203f1e:	0fe53503          	ld	a0,254(a0) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0203f22:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203f24:	82b1                	srli	a3,a3,0xc
ffffffffc0203f26:	000b1797          	auipc	a5,0xb1
ffffffffc0203f2a:	0da7b783          	ld	a5,218(a5) # ffffffffc02b5000 <npage>
ffffffffc0203f2e:	02f6fe63          	bgeu	a3,a5,ffffffffc0203f6a <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f32:	00004517          	auipc	a0,0x4
ffffffffc0203f36:	91e53503          	ld	a0,-1762(a0) # ffffffffc0207850 <nbase>
}
ffffffffc0203f3a:	60a2                	ld	ra,8(sp)
ffffffffc0203f3c:	8e89                	sub	a3,a3,a0
ffffffffc0203f3e:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203f40:	000b1517          	auipc	a0,0xb1
ffffffffc0203f44:	0c853503          	ld	a0,200(a0) # ffffffffc02b5008 <pages>
ffffffffc0203f48:	4585                	li	a1,1
ffffffffc0203f4a:	9536                	add	a0,a0,a3
}
ffffffffc0203f4c:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203f4e:	f89fd06f          	j	ffffffffc0201ed6 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203f52:	00002617          	auipc	a2,0x2
ffffffffc0203f56:	6d660613          	addi	a2,a2,1750 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0203f5a:	07700593          	li	a1,119
ffffffffc0203f5e:	00002517          	auipc	a0,0x2
ffffffffc0203f62:	64a50513          	addi	a0,a0,1610 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0203f66:	d28fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203f6a:	00002617          	auipc	a2,0x2
ffffffffc0203f6e:	6e660613          	addi	a2,a2,1766 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0203f72:	06900593          	li	a1,105
ffffffffc0203f76:	00002517          	auipc	a0,0x2
ffffffffc0203f7a:	63250513          	addi	a0,a0,1586 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0203f7e:	d10fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0203f82 <proc_run>:
{
ffffffffc0203f82:	7179                	addi	sp,sp,-48
ffffffffc0203f84:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203f86:	000b1917          	auipc	s2,0xb1
ffffffffc0203f8a:	09a90913          	addi	s2,s2,154 # ffffffffc02b5020 <current>
{
ffffffffc0203f8e:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203f90:	00093483          	ld	s1,0(s2)
{
ffffffffc0203f94:	f406                	sd	ra,40(sp)
ffffffffc0203f96:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203f98:	02a48863          	beq	s1,a0,ffffffffc0203fc8 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203f9c:	100027f3          	csrr	a5,sstatus
ffffffffc0203fa0:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203fa2:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203fa4:	ef9d                	bnez	a5,ffffffffc0203fe2 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203fa6:	755c                	ld	a5,168(a0)
ffffffffc0203fa8:	577d                	li	a4,-1
ffffffffc0203faa:	177e                	slli	a4,a4,0x3f
ffffffffc0203fac:	83b1                	srli	a5,a5,0xc
        current = proc;
ffffffffc0203fae:	00a93023          	sd	a0,0(s2)
ffffffffc0203fb2:	8fd9                	or	a5,a5,a4
ffffffffc0203fb4:	18079073          	csrw	satp,a5
        switch_to(&(prev->context), &(current->context));
ffffffffc0203fb8:	03050593          	addi	a1,a0,48
ffffffffc0203fbc:	03048513          	addi	a0,s1,48
ffffffffc0203fc0:	01e010ef          	jal	ra,ffffffffc0204fde <switch_to>
    if (flag)
ffffffffc0203fc4:	00099863          	bnez	s3,ffffffffc0203fd4 <proc_run+0x52>
}
ffffffffc0203fc8:	70a2                	ld	ra,40(sp)
ffffffffc0203fca:	7482                	ld	s1,32(sp)
ffffffffc0203fcc:	6962                	ld	s2,24(sp)
ffffffffc0203fce:	69c2                	ld	s3,16(sp)
ffffffffc0203fd0:	6145                	addi	sp,sp,48
ffffffffc0203fd2:	8082                	ret
ffffffffc0203fd4:	70a2                	ld	ra,40(sp)
ffffffffc0203fd6:	7482                	ld	s1,32(sp)
ffffffffc0203fd8:	6962                	ld	s2,24(sp)
ffffffffc0203fda:	69c2                	ld	s3,16(sp)
ffffffffc0203fdc:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203fde:	9d1fc06f          	j	ffffffffc02009ae <intr_enable>
ffffffffc0203fe2:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203fe4:	9d1fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0203fe8:	6522                	ld	a0,8(sp)
ffffffffc0203fea:	4985                	li	s3,1
ffffffffc0203fec:	bf6d                	j	ffffffffc0203fa6 <proc_run+0x24>

ffffffffc0203fee <do_fork>:
{
ffffffffc0203fee:	7119                	addi	sp,sp,-128
ffffffffc0203ff0:	e8d2                	sd	s4,80(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203ff2:	000b1a17          	auipc	s4,0xb1
ffffffffc0203ff6:	046a0a13          	addi	s4,s4,70 # ffffffffc02b5038 <nr_process>
ffffffffc0203ffa:	000a2703          	lw	a4,0(s4)
{
ffffffffc0203ffe:	fc86                	sd	ra,120(sp)
ffffffffc0204000:	f8a2                	sd	s0,112(sp)
ffffffffc0204002:	f4a6                	sd	s1,104(sp)
ffffffffc0204004:	f0ca                	sd	s2,96(sp)
ffffffffc0204006:	ecce                	sd	s3,88(sp)
ffffffffc0204008:	e4d6                	sd	s5,72(sp)
ffffffffc020400a:	e0da                	sd	s6,64(sp)
ffffffffc020400c:	fc5e                	sd	s7,56(sp)
ffffffffc020400e:	f862                	sd	s8,48(sp)
ffffffffc0204010:	f466                	sd	s9,40(sp)
ffffffffc0204012:	f06a                	sd	s10,32(sp)
ffffffffc0204014:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204016:	6785                	lui	a5,0x1
ffffffffc0204018:	32f75263          	bge	a4,a5,ffffffffc020433c <do_fork+0x34e>
ffffffffc020401c:	892a                	mv	s2,a0
ffffffffc020401e:	89ae                	mv	s3,a1
ffffffffc0204020:	84b2                	mv	s1,a2
    if ((proc = alloc_proc()) == NULL)
ffffffffc0204022:	dddff0ef          	jal	ra,ffffffffc0203dfe <alloc_proc>
ffffffffc0204026:	842a                	mv	s0,a0
ffffffffc0204028:	2e050763          	beqz	a0,ffffffffc0204316 <do_fork+0x328>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020402c:	4509                	li	a0,2
ffffffffc020402e:	e6bfd0ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
    if (page != NULL)
ffffffffc0204032:	2c050f63          	beqz	a0,ffffffffc0204310 <do_fork+0x322>
    return page - pages + nbase;
ffffffffc0204036:	000b1a97          	auipc	s5,0xb1
ffffffffc020403a:	fd2a8a93          	addi	s5,s5,-46 # ffffffffc02b5008 <pages>
ffffffffc020403e:	000ab683          	ld	a3,0(s5)
ffffffffc0204042:	00004797          	auipc	a5,0x4
ffffffffc0204046:	80e78793          	addi	a5,a5,-2034 # ffffffffc0207850 <nbase>
ffffffffc020404a:	6390                	ld	a2,0(a5)
ffffffffc020404c:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204050:	000b1b97          	auipc	s7,0xb1
ffffffffc0204054:	fb0b8b93          	addi	s7,s7,-80 # ffffffffc02b5000 <npage>
    return page - pages + nbase;
ffffffffc0204058:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020405a:	57fd                	li	a5,-1
ffffffffc020405c:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204060:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0204062:	00c7db13          	srli	s6,a5,0xc
ffffffffc0204066:	0166f5b3          	and	a1,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc020406a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020406c:	32e5fd63          	bgeu	a1,a4,ffffffffc02043a6 <do_fork+0x3b8>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc0204070:	000b1c17          	auipc	s8,0xb1
ffffffffc0204074:	fb0c0c13          	addi	s8,s8,-80 # ffffffffc02b5020 <current>
ffffffffc0204078:	000c3583          	ld	a1,0(s8)
ffffffffc020407c:	000b1c97          	auipc	s9,0xb1
ffffffffc0204080:	f9cc8c93          	addi	s9,s9,-100 # ffffffffc02b5018 <va_pa_offset>
ffffffffc0204084:	000cb703          	ld	a4,0(s9)
ffffffffc0204088:	0285bd83          	ld	s11,40(a1)
ffffffffc020408c:	e432                	sd	a2,8(sp)
ffffffffc020408e:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc0204090:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc0204092:	020d8763          	beqz	s11,ffffffffc02040c0 <do_fork+0xd2>
    if (clone_flags & CLONE_VM)
ffffffffc0204096:	10097913          	andi	s2,s2,256
ffffffffc020409a:	1a090a63          	beqz	s2,ffffffffc020424e <do_fork+0x260>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc020409e:	030da783          	lw	a5,48(s11)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040a2:	018db683          	ld	a3,24(s11)
ffffffffc02040a6:	c0200737          	lui	a4,0xc0200
ffffffffc02040aa:	2785                	addiw	a5,a5,1
ffffffffc02040ac:	02fda823          	sw	a5,48(s11)
    proc->mm = mm;
ffffffffc02040b0:	03b43423          	sd	s11,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040b4:	2ce6e163          	bltu	a3,a4,ffffffffc0204376 <do_fork+0x388>
ffffffffc02040b8:	000cb783          	ld	a5,0(s9)
ffffffffc02040bc:	8e9d                	sub	a3,a3,a5
ffffffffc02040be:	f454                	sd	a3,168(s0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040c0:	100027f3          	csrr	a5,sstatus
ffffffffc02040c4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc02040c6:	4a81                	li	s5,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02040c8:	26079163          	bnez	a5,ffffffffc020432a <do_fork+0x33c>
    if (++last_pid >= MAX_PID)
ffffffffc02040cc:	000ad817          	auipc	a6,0xad
ffffffffc02040d0:	ac480813          	addi	a6,a6,-1340 # ffffffffc02b0b90 <last_pid.1>
    proc->parent = current;
ffffffffc02040d4:	000c3703          	ld	a4,0(s8)
    if (++last_pid >= MAX_PID)
ffffffffc02040d8:	00082783          	lw	a5,0(a6)
ffffffffc02040dc:	6689                	lui	a3,0x2
    proc->parent = current;
ffffffffc02040de:	f018                	sd	a4,32(s0)
    if (++last_pid >= MAX_PID)
ffffffffc02040e0:	0017851b          	addiw	a0,a5,1
    current->wait_state = 0;
ffffffffc02040e4:	0e072623          	sw	zero,236(a4) # ffffffffc02000ec <readline+0x46>
    if (++last_pid >= MAX_PID)
ffffffffc02040e8:	00a82023          	sw	a0,0(a6)
ffffffffc02040ec:	0ed55863          	bge	a0,a3,ffffffffc02041dc <do_fork+0x1ee>
    if (last_pid >= next_safe)
ffffffffc02040f0:	000ad317          	auipc	t1,0xad
ffffffffc02040f4:	aa430313          	addi	t1,t1,-1372 # ffffffffc02b0b94 <next_safe.0>
ffffffffc02040f8:	00032783          	lw	a5,0(t1)
ffffffffc02040fc:	000b1917          	auipc	s2,0xb1
ffffffffc0204100:	eb490913          	addi	s2,s2,-332 # ffffffffc02b4fb0 <proc_list>
ffffffffc0204104:	0ef55463          	bge	a0,a5,ffffffffc02041ec <do_fork+0x1fe>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204108:	6818                	ld	a4,16(s0)
ffffffffc020410a:	6789                	lui	a5,0x2
ffffffffc020410c:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cc8>
ffffffffc0204110:	973e                	add	a4,a4,a5
    *(proc->tf) = *tf;
ffffffffc0204112:	8626                	mv	a2,s1
    proc->pid = get_pid();
ffffffffc0204114:	c048                	sw	a0,4(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc0204116:	f058                	sd	a4,160(s0)
    *(proc->tf) = *tf;
ffffffffc0204118:	87ba                	mv	a5,a4
ffffffffc020411a:	12048313          	addi	t1,s1,288
ffffffffc020411e:	00063883          	ld	a7,0(a2)
ffffffffc0204122:	00863803          	ld	a6,8(a2)
ffffffffc0204126:	6a0c                	ld	a1,16(a2)
ffffffffc0204128:	6e14                	ld	a3,24(a2)
ffffffffc020412a:	0117b023          	sd	a7,0(a5)
ffffffffc020412e:	0107b423          	sd	a6,8(a5)
ffffffffc0204132:	eb8c                	sd	a1,16(a5)
ffffffffc0204134:	ef94                	sd	a3,24(a5)
ffffffffc0204136:	02060613          	addi	a2,a2,32
ffffffffc020413a:	02078793          	addi	a5,a5,32
ffffffffc020413e:	fe6610e3          	bne	a2,t1,ffffffffc020411e <do_fork+0x130>
    proc->tf->gpr.a0 = 0;
ffffffffc0204142:	04073823          	sd	zero,80(a4)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204146:	10098263          	beqz	s3,ffffffffc020424a <do_fork+0x25c>
ffffffffc020414a:	01373823          	sd	s3,16(a4)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc020414e:	00000797          	auipc	a5,0x0
ffffffffc0204152:	d3278793          	addi	a5,a5,-718 # ffffffffc0203e80 <forkret>
ffffffffc0204156:	f81c                	sd	a5,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204158:	fc18                	sd	a4,56(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020415a:	45a9                	li	a1,10
ffffffffc020415c:	2501                	sext.w	a0,a0
ffffffffc020415e:	0d6010ef          	jal	ra,ffffffffc0205234 <hash32>
ffffffffc0204162:	02051793          	slli	a5,a0,0x20
ffffffffc0204166:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020416a:	000ad797          	auipc	a5,0xad
ffffffffc020416e:	e4678793          	addi	a5,a5,-442 # ffffffffc02b0fb0 <hash_list>
ffffffffc0204172:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204174:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204176:	7014                	ld	a3,32(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204178:	0d840793          	addi	a5,s0,216
    prev->next = next->prev = elm;
ffffffffc020417c:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020417e:	00893603          	ld	a2,8(s2)
    prev->next = next->prev = elm;
ffffffffc0204182:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204184:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204186:	0c840793          	addi	a5,s0,200
    elm->next = next;
ffffffffc020418a:	f06c                	sd	a1,224(s0)
    elm->prev = prev;
ffffffffc020418c:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc020418e:	e21c                	sd	a5,0(a2)
ffffffffc0204190:	00f93423          	sd	a5,8(s2)
    elm->next = next;
ffffffffc0204194:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc0204196:	0d243423          	sd	s2,200(s0)
    proc->yptr = NULL;
ffffffffc020419a:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc020419e:	10e43023          	sd	a4,256(s0)
ffffffffc02041a2:	c311                	beqz	a4,ffffffffc02041a6 <do_fork+0x1b8>
        proc->optr->yptr = proc;
ffffffffc02041a4:	ff60                	sd	s0,248(a4)
    nr_process++;
ffffffffc02041a6:	000a2783          	lw	a5,0(s4)
    proc->parent->cptr = proc;
ffffffffc02041aa:	fae0                	sd	s0,240(a3)
    wakeup_proc(proc);
ffffffffc02041ac:	8522                	mv	a0,s0
    nr_process++;
ffffffffc02041ae:	2785                	addiw	a5,a5,1
ffffffffc02041b0:	00fa2023          	sw	a5,0(s4)
    wakeup_proc(proc);
ffffffffc02041b4:	695000ef          	jal	ra,ffffffffc0205048 <wakeup_proc>
    if (flag)
ffffffffc02041b8:	160a9163          	bnez	s5,ffffffffc020431a <do_fork+0x32c>
    ret = proc->pid;
ffffffffc02041bc:	4048                	lw	a0,4(s0)
}
ffffffffc02041be:	70e6                	ld	ra,120(sp)
ffffffffc02041c0:	7446                	ld	s0,112(sp)
ffffffffc02041c2:	74a6                	ld	s1,104(sp)
ffffffffc02041c4:	7906                	ld	s2,96(sp)
ffffffffc02041c6:	69e6                	ld	s3,88(sp)
ffffffffc02041c8:	6a46                	ld	s4,80(sp)
ffffffffc02041ca:	6aa6                	ld	s5,72(sp)
ffffffffc02041cc:	6b06                	ld	s6,64(sp)
ffffffffc02041ce:	7be2                	ld	s7,56(sp)
ffffffffc02041d0:	7c42                	ld	s8,48(sp)
ffffffffc02041d2:	7ca2                	ld	s9,40(sp)
ffffffffc02041d4:	7d02                	ld	s10,32(sp)
ffffffffc02041d6:	6de2                	ld	s11,24(sp)
ffffffffc02041d8:	6109                	addi	sp,sp,128
ffffffffc02041da:	8082                	ret
        last_pid = 1;
ffffffffc02041dc:	4785                	li	a5,1
ffffffffc02041de:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02041e2:	4505                	li	a0,1
ffffffffc02041e4:	000ad317          	auipc	t1,0xad
ffffffffc02041e8:	9b030313          	addi	t1,t1,-1616 # ffffffffc02b0b94 <next_safe.0>
    return listelm->next;
ffffffffc02041ec:	000b1917          	auipc	s2,0xb1
ffffffffc02041f0:	dc490913          	addi	s2,s2,-572 # ffffffffc02b4fb0 <proc_list>
ffffffffc02041f4:	00893e03          	ld	t3,8(s2)
        next_safe = MAX_PID;
ffffffffc02041f8:	6789                	lui	a5,0x2
ffffffffc02041fa:	00f32023          	sw	a5,0(t1)
ffffffffc02041fe:	86aa                	mv	a3,a0
ffffffffc0204200:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204202:	6e89                	lui	t4,0x2
ffffffffc0204204:	132e0763          	beq	t3,s2,ffffffffc0204332 <do_fork+0x344>
ffffffffc0204208:	88ae                	mv	a7,a1
ffffffffc020420a:	87f2                	mv	a5,t3
ffffffffc020420c:	6609                	lui	a2,0x2
ffffffffc020420e:	a811                	j	ffffffffc0204222 <do_fork+0x234>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204210:	00e6d663          	bge	a3,a4,ffffffffc020421c <do_fork+0x22e>
ffffffffc0204214:	00c75463          	bge	a4,a2,ffffffffc020421c <do_fork+0x22e>
ffffffffc0204218:	863a                	mv	a2,a4
ffffffffc020421a:	4885                	li	a7,1
ffffffffc020421c:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020421e:	01278d63          	beq	a5,s2,ffffffffc0204238 <do_fork+0x24a>
            if (proc->pid == last_pid)
ffffffffc0204222:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c6c>
ffffffffc0204226:	fed715e3          	bne	a4,a3,ffffffffc0204210 <do_fork+0x222>
                if (++last_pid >= next_safe)
ffffffffc020422a:	2685                	addiw	a3,a3,1
ffffffffc020422c:	0ec6da63          	bge	a3,a2,ffffffffc0204320 <do_fork+0x332>
ffffffffc0204230:	679c                	ld	a5,8(a5)
ffffffffc0204232:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0204234:	ff2797e3          	bne	a5,s2,ffffffffc0204222 <do_fork+0x234>
ffffffffc0204238:	c581                	beqz	a1,ffffffffc0204240 <do_fork+0x252>
ffffffffc020423a:	00d82023          	sw	a3,0(a6)
ffffffffc020423e:	8536                	mv	a0,a3
ffffffffc0204240:	ec0884e3          	beqz	a7,ffffffffc0204108 <do_fork+0x11a>
ffffffffc0204244:	00c32023          	sw	a2,0(t1)
ffffffffc0204248:	b5c1                	j	ffffffffc0204108 <do_fork+0x11a>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020424a:	89ba                	mv	s3,a4
ffffffffc020424c:	bdfd                	j	ffffffffc020414a <do_fork+0x15c>
    if ((mm = mm_create()) == NULL)
ffffffffc020424e:	c9eff0ef          	jal	ra,ffffffffc02036ec <mm_create>
ffffffffc0204252:	8d2a                	mv	s10,a0
ffffffffc0204254:	c159                	beqz	a0,ffffffffc02042da <do_fork+0x2ec>
    if ((page = alloc_page()) == NULL)
ffffffffc0204256:	4505                	li	a0,1
ffffffffc0204258:	c41fd0ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc020425c:	cd25                	beqz	a0,ffffffffc02042d4 <do_fork+0x2e6>
    return page - pages + nbase;
ffffffffc020425e:	000ab683          	ld	a3,0(s5)
ffffffffc0204262:	6622                	ld	a2,8(sp)
    return KADDR(page2pa(page));
ffffffffc0204264:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204268:	40d506b3          	sub	a3,a0,a3
ffffffffc020426c:	8699                	srai	a3,a3,0x6
ffffffffc020426e:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0204270:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc0204274:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204276:	12e7f863          	bgeu	a5,a4,ffffffffc02043a6 <do_fork+0x3b8>
ffffffffc020427a:	000cb903          	ld	s2,0(s9)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc020427e:	6605                	lui	a2,0x1
ffffffffc0204280:	000b1597          	auipc	a1,0xb1
ffffffffc0204284:	d785b583          	ld	a1,-648(a1) # ffffffffc02b4ff8 <boot_pgdir_va>
ffffffffc0204288:	9936                	add	s2,s2,a3
ffffffffc020428a:	854a                	mv	a0,s2
ffffffffc020428c:	460010ef          	jal	ra,ffffffffc02056ec <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204290:	038d8b13          	addi	s6,s11,56
    mm->pgdir = pgdir;
ffffffffc0204294:	012d3c23          	sd	s2,24(s10)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0204298:	4785                	li	a5,1
ffffffffc020429a:	40fb37af          	amoor.d	a5,a5,(s6)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc020429e:	8b85                	andi	a5,a5,1
ffffffffc02042a0:	4905                	li	s2,1
ffffffffc02042a2:	c799                	beqz	a5,ffffffffc02042b0 <do_fork+0x2c2>
    {
        schedule();
ffffffffc02042a4:	625000ef          	jal	ra,ffffffffc02050c8 <schedule>
ffffffffc02042a8:	412b37af          	amoor.d	a5,s2,(s6)
    while (!try_lock(lock))
ffffffffc02042ac:	8b85                	andi	a5,a5,1
ffffffffc02042ae:	fbfd                	bnez	a5,ffffffffc02042a4 <do_fork+0x2b6>
        ret = dup_mmap(mm, oldmm);
ffffffffc02042b0:	85ee                	mv	a1,s11
ffffffffc02042b2:	856a                	mv	a0,s10
ffffffffc02042b4:	e7aff0ef          	jal	ra,ffffffffc020392e <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02042b8:	57f9                	li	a5,-2
ffffffffc02042ba:	60fb37af          	amoand.d	a5,a5,(s6)
ffffffffc02042be:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02042c0:	c3d9                	beqz	a5,ffffffffc0204346 <do_fork+0x358>
good_mm:
ffffffffc02042c2:	8dea                	mv	s11,s10
    if (ret != 0)
ffffffffc02042c4:	dc050de3          	beqz	a0,ffffffffc020409e <do_fork+0xb0>
    exit_mmap(mm);
ffffffffc02042c8:	856a                	mv	a0,s10
ffffffffc02042ca:	efeff0ef          	jal	ra,ffffffffc02039c8 <exit_mmap>
    put_pgdir(mm);
ffffffffc02042ce:	856a                	mv	a0,s10
ffffffffc02042d0:	c3dff0ef          	jal	ra,ffffffffc0203f0c <put_pgdir>
    mm_destroy(mm);
ffffffffc02042d4:	856a                	mv	a0,s10
ffffffffc02042d6:	d56ff0ef          	jal	ra,ffffffffc020382c <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02042da:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02042dc:	c02007b7          	lui	a5,0xc0200
ffffffffc02042e0:	0af6e763          	bltu	a3,a5,ffffffffc020438e <do_fork+0x3a0>
ffffffffc02042e4:	000cb783          	ld	a5,0(s9)
    if (PPN(pa) >= npage)
ffffffffc02042e8:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02042ec:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02042f0:	83b1                	srli	a5,a5,0xc
ffffffffc02042f2:	06e7f663          	bgeu	a5,a4,ffffffffc020435e <do_fork+0x370>
    return &pages[PPN(pa) - nbase];
ffffffffc02042f6:	00003717          	auipc	a4,0x3
ffffffffc02042fa:	55a70713          	addi	a4,a4,1370 # ffffffffc0207850 <nbase>
ffffffffc02042fe:	6318                	ld	a4,0(a4)
ffffffffc0204300:	000ab503          	ld	a0,0(s5)
ffffffffc0204304:	4589                	li	a1,2
ffffffffc0204306:	8f99                	sub	a5,a5,a4
ffffffffc0204308:	079a                	slli	a5,a5,0x6
ffffffffc020430a:	953e                	add	a0,a0,a5
ffffffffc020430c:	bcbfd0ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    kfree(proc);
ffffffffc0204310:	8522                	mv	a0,s0
ffffffffc0204312:	a59fd0ef          	jal	ra,ffffffffc0201d6a <kfree>
    ret = -E_NO_MEM;
ffffffffc0204316:	5571                	li	a0,-4
    return ret;
ffffffffc0204318:	b55d                	j	ffffffffc02041be <do_fork+0x1d0>
        intr_enable();
ffffffffc020431a:	e94fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc020431e:	bd79                	j	ffffffffc02041bc <do_fork+0x1ce>
                    if (last_pid >= MAX_PID)
ffffffffc0204320:	01d6c363          	blt	a3,t4,ffffffffc0204326 <do_fork+0x338>
                        last_pid = 1;
ffffffffc0204324:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204326:	4585                	li	a1,1
ffffffffc0204328:	bdf1                	j	ffffffffc0204204 <do_fork+0x216>
        intr_disable();
ffffffffc020432a:	e8afc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020432e:	4a85                	li	s5,1
ffffffffc0204330:	bb71                	j	ffffffffc02040cc <do_fork+0xde>
ffffffffc0204332:	c599                	beqz	a1,ffffffffc0204340 <do_fork+0x352>
ffffffffc0204334:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc0204338:	8536                	mv	a0,a3
ffffffffc020433a:	b3f9                	j	ffffffffc0204108 <do_fork+0x11a>
    int ret = -E_NO_FREE_PROC;
ffffffffc020433c:	556d                	li	a0,-5
ffffffffc020433e:	b541                	j	ffffffffc02041be <do_fork+0x1d0>
    return last_pid;
ffffffffc0204340:	00082503          	lw	a0,0(a6)
ffffffffc0204344:	b3d1                	j	ffffffffc0204108 <do_fork+0x11a>
    {
        panic("Unlock failed.\n");
ffffffffc0204346:	00003617          	auipc	a2,0x3
ffffffffc020434a:	c8a60613          	addi	a2,a2,-886 # ffffffffc0206fd0 <default_pmm_manager+0xa88>
ffffffffc020434e:	03f00593          	li	a1,63
ffffffffc0204352:	00003517          	auipc	a0,0x3
ffffffffc0204356:	c8e50513          	addi	a0,a0,-882 # ffffffffc0206fe0 <default_pmm_manager+0xa98>
ffffffffc020435a:	934fc0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc020435e:	00002617          	auipc	a2,0x2
ffffffffc0204362:	2f260613          	addi	a2,a2,754 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc0204366:	06900593          	li	a1,105
ffffffffc020436a:	00002517          	auipc	a0,0x2
ffffffffc020436e:	23e50513          	addi	a0,a0,574 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0204372:	91cfc0ef          	jal	ra,ffffffffc020048e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204376:	00002617          	auipc	a2,0x2
ffffffffc020437a:	2b260613          	addi	a2,a2,690 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc020437e:	18e00593          	li	a1,398
ffffffffc0204382:	00003517          	auipc	a0,0x3
ffffffffc0204386:	c3650513          	addi	a0,a0,-970 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020438a:	904fc0ef          	jal	ra,ffffffffc020048e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020438e:	00002617          	auipc	a2,0x2
ffffffffc0204392:	29a60613          	addi	a2,a2,666 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0204396:	07700593          	li	a1,119
ffffffffc020439a:	00002517          	auipc	a0,0x2
ffffffffc020439e:	20e50513          	addi	a0,a0,526 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02043a2:	8ecfc0ef          	jal	ra,ffffffffc020048e <__panic>
    return KADDR(page2pa(page));
ffffffffc02043a6:	00002617          	auipc	a2,0x2
ffffffffc02043aa:	1da60613          	addi	a2,a2,474 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc02043ae:	07100593          	li	a1,113
ffffffffc02043b2:	00002517          	auipc	a0,0x2
ffffffffc02043b6:	1f650513          	addi	a0,a0,502 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02043ba:	8d4fc0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02043be <kernel_thread>:
{
ffffffffc02043be:	7129                	addi	sp,sp,-320
ffffffffc02043c0:	fa22                	sd	s0,304(sp)
ffffffffc02043c2:	f626                	sd	s1,296(sp)
ffffffffc02043c4:	f24a                	sd	s2,288(sp)
ffffffffc02043c6:	84ae                	mv	s1,a1
ffffffffc02043c8:	892a                	mv	s2,a0
ffffffffc02043ca:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043cc:	4581                	li	a1,0
ffffffffc02043ce:	12000613          	li	a2,288
ffffffffc02043d2:	850a                	mv	a0,sp
{
ffffffffc02043d4:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043d6:	304010ef          	jal	ra,ffffffffc02056da <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02043da:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02043dc:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02043de:	100027f3          	csrr	a5,sstatus
ffffffffc02043e2:	edd7f793          	andi	a5,a5,-291
ffffffffc02043e6:	1207e793          	ori	a5,a5,288
ffffffffc02043ea:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043ec:	860a                	mv	a2,sp
ffffffffc02043ee:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043f2:	00000797          	auipc	a5,0x0
ffffffffc02043f6:	a0478793          	addi	a5,a5,-1532 # ffffffffc0203df6 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043fa:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043fc:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043fe:	bf1ff0ef          	jal	ra,ffffffffc0203fee <do_fork>
}
ffffffffc0204402:	70f2                	ld	ra,312(sp)
ffffffffc0204404:	7452                	ld	s0,304(sp)
ffffffffc0204406:	74b2                	ld	s1,296(sp)
ffffffffc0204408:	7912                	ld	s2,288(sp)
ffffffffc020440a:	6131                	addi	sp,sp,320
ffffffffc020440c:	8082                	ret

ffffffffc020440e <do_exit>:
{
ffffffffc020440e:	7179                	addi	sp,sp,-48
ffffffffc0204410:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204412:	000b1417          	auipc	s0,0xb1
ffffffffc0204416:	c0e40413          	addi	s0,s0,-1010 # ffffffffc02b5020 <current>
ffffffffc020441a:	601c                	ld	a5,0(s0)
{
ffffffffc020441c:	f406                	sd	ra,40(sp)
ffffffffc020441e:	ec26                	sd	s1,24(sp)
ffffffffc0204420:	e84a                	sd	s2,16(sp)
ffffffffc0204422:	e44e                	sd	s3,8(sp)
ffffffffc0204424:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc0204426:	000b1717          	auipc	a4,0xb1
ffffffffc020442a:	c0273703          	ld	a4,-1022(a4) # ffffffffc02b5028 <idleproc>
ffffffffc020442e:	0ce78c63          	beq	a5,a4,ffffffffc0204506 <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204432:	000b1497          	auipc	s1,0xb1
ffffffffc0204436:	bfe48493          	addi	s1,s1,-1026 # ffffffffc02b5030 <initproc>
ffffffffc020443a:	6098                	ld	a4,0(s1)
ffffffffc020443c:	0ee78b63          	beq	a5,a4,ffffffffc0204532 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204440:	0287b983          	ld	s3,40(a5)
ffffffffc0204444:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc0204446:	02098663          	beqz	s3,ffffffffc0204472 <do_exit+0x64>
ffffffffc020444a:	000b1797          	auipc	a5,0xb1
ffffffffc020444e:	ba67b783          	ld	a5,-1114(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
ffffffffc0204452:	577d                	li	a4,-1
ffffffffc0204454:	177e                	slli	a4,a4,0x3f
ffffffffc0204456:	83b1                	srli	a5,a5,0xc
ffffffffc0204458:	8fd9                	or	a5,a5,a4
ffffffffc020445a:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc020445e:	0309a783          	lw	a5,48(s3)
ffffffffc0204462:	fff7871b          	addiw	a4,a5,-1
ffffffffc0204466:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc020446a:	cb55                	beqz	a4,ffffffffc020451e <do_exit+0x110>
        current->mm = NULL;
ffffffffc020446c:	601c                	ld	a5,0(s0)
ffffffffc020446e:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204472:	601c                	ld	a5,0(s0)
ffffffffc0204474:	470d                	li	a4,3
ffffffffc0204476:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc0204478:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020447c:	100027f3          	csrr	a5,sstatus
ffffffffc0204480:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204482:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204484:	e3f9                	bnez	a5,ffffffffc020454a <do_exit+0x13c>
        proc = current->parent;
ffffffffc0204486:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204488:	800007b7          	lui	a5,0x80000
ffffffffc020448c:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc020448e:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204490:	0ec52703          	lw	a4,236(a0)
ffffffffc0204494:	0af70f63          	beq	a4,a5,ffffffffc0204552 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc0204498:	6018                	ld	a4,0(s0)
ffffffffc020449a:	7b7c                	ld	a5,240(a4)
ffffffffc020449c:	c3a1                	beqz	a5,ffffffffc02044dc <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc020449e:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044a2:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044a4:	0985                	addi	s3,s3,1
ffffffffc02044a6:	a021                	j	ffffffffc02044ae <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc02044a8:	6018                	ld	a4,0(s0)
ffffffffc02044aa:	7b7c                	ld	a5,240(a4)
ffffffffc02044ac:	cb85                	beqz	a5,ffffffffc02044dc <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02044ae:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fe0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044b2:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02044b4:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044b6:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02044b8:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044bc:	10e7b023          	sd	a4,256(a5)
ffffffffc02044c0:	c311                	beqz	a4,ffffffffc02044c4 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02044c2:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044c4:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02044c6:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02044c8:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044ca:	fd271fe3          	bne	a4,s2,ffffffffc02044a8 <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044ce:	0ec52783          	lw	a5,236(a0)
ffffffffc02044d2:	fd379be3          	bne	a5,s3,ffffffffc02044a8 <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02044d6:	373000ef          	jal	ra,ffffffffc0205048 <wakeup_proc>
ffffffffc02044da:	b7f9                	j	ffffffffc02044a8 <do_exit+0x9a>
    if (flag)
ffffffffc02044dc:	020a1263          	bnez	s4,ffffffffc0204500 <do_exit+0xf2>
    schedule();
ffffffffc02044e0:	3e9000ef          	jal	ra,ffffffffc02050c8 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02044e4:	601c                	ld	a5,0(s0)
ffffffffc02044e6:	00003617          	auipc	a2,0x3
ffffffffc02044ea:	b3260613          	addi	a2,a2,-1230 # ffffffffc0207018 <default_pmm_manager+0xad0>
ffffffffc02044ee:	23700593          	li	a1,567
ffffffffc02044f2:	43d4                	lw	a3,4(a5)
ffffffffc02044f4:	00003517          	auipc	a0,0x3
ffffffffc02044f8:	ac450513          	addi	a0,a0,-1340 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc02044fc:	f93fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_enable();
ffffffffc0204500:	caefc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc0204504:	bff1                	j	ffffffffc02044e0 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc0204506:	00003617          	auipc	a2,0x3
ffffffffc020450a:	af260613          	addi	a2,a2,-1294 # ffffffffc0206ff8 <default_pmm_manager+0xab0>
ffffffffc020450e:	20300593          	li	a1,515
ffffffffc0204512:	00003517          	auipc	a0,0x3
ffffffffc0204516:	aa650513          	addi	a0,a0,-1370 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020451a:	f75fb0ef          	jal	ra,ffffffffc020048e <__panic>
            exit_mmap(mm);
ffffffffc020451e:	854e                	mv	a0,s3
ffffffffc0204520:	ca8ff0ef          	jal	ra,ffffffffc02039c8 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204524:	854e                	mv	a0,s3
ffffffffc0204526:	9e7ff0ef          	jal	ra,ffffffffc0203f0c <put_pgdir>
            mm_destroy(mm);
ffffffffc020452a:	854e                	mv	a0,s3
ffffffffc020452c:	b00ff0ef          	jal	ra,ffffffffc020382c <mm_destroy>
ffffffffc0204530:	bf35                	j	ffffffffc020446c <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204532:	00003617          	auipc	a2,0x3
ffffffffc0204536:	ad660613          	addi	a2,a2,-1322 # ffffffffc0207008 <default_pmm_manager+0xac0>
ffffffffc020453a:	20700593          	li	a1,519
ffffffffc020453e:	00003517          	auipc	a0,0x3
ffffffffc0204542:	a7a50513          	addi	a0,a0,-1414 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204546:	f49fb0ef          	jal	ra,ffffffffc020048e <__panic>
        intr_disable();
ffffffffc020454a:	c6afc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc020454e:	4a05                	li	s4,1
ffffffffc0204550:	bf1d                	j	ffffffffc0204486 <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204552:	2f7000ef          	jal	ra,ffffffffc0205048 <wakeup_proc>
ffffffffc0204556:	b789                	j	ffffffffc0204498 <do_exit+0x8a>

ffffffffc0204558 <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc0204558:	715d                	addi	sp,sp,-80
ffffffffc020455a:	f84a                	sd	s2,48(sp)
ffffffffc020455c:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc020455e:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204562:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204564:	fc26                	sd	s1,56(sp)
ffffffffc0204566:	f052                	sd	s4,32(sp)
ffffffffc0204568:	ec56                	sd	s5,24(sp)
ffffffffc020456a:	e85a                	sd	s6,16(sp)
ffffffffc020456c:	e45e                	sd	s7,8(sp)
ffffffffc020456e:	e486                	sd	ra,72(sp)
ffffffffc0204570:	e0a2                	sd	s0,64(sp)
ffffffffc0204572:	84aa                	mv	s1,a0
ffffffffc0204574:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc0204576:	000b1b97          	auipc	s7,0xb1
ffffffffc020457a:	aaab8b93          	addi	s7,s7,-1366 # ffffffffc02b5020 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc020457e:	00050b1b          	sext.w	s6,a0
ffffffffc0204582:	fff50a9b          	addiw	s5,a0,-1
ffffffffc0204586:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc0204588:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc020458a:	ccbd                	beqz	s1,ffffffffc0204608 <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc020458c:	0359e863          	bltu	s3,s5,ffffffffc02045bc <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204590:	45a9                	li	a1,10
ffffffffc0204592:	855a                	mv	a0,s6
ffffffffc0204594:	4a1000ef          	jal	ra,ffffffffc0205234 <hash32>
ffffffffc0204598:	02051793          	slli	a5,a0,0x20
ffffffffc020459c:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02045a0:	000ad797          	auipc	a5,0xad
ffffffffc02045a4:	a1078793          	addi	a5,a5,-1520 # ffffffffc02b0fb0 <hash_list>
ffffffffc02045a8:	953e                	add	a0,a0,a5
ffffffffc02045aa:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02045ac:	a029                	j	ffffffffc02045b6 <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02045ae:	f2c42783          	lw	a5,-212(s0)
ffffffffc02045b2:	02978163          	beq	a5,s1,ffffffffc02045d4 <do_wait.part.0+0x7c>
ffffffffc02045b6:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02045b8:	fe851be3          	bne	a0,s0,ffffffffc02045ae <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02045bc:	5579                	li	a0,-2
}
ffffffffc02045be:	60a6                	ld	ra,72(sp)
ffffffffc02045c0:	6406                	ld	s0,64(sp)
ffffffffc02045c2:	74e2                	ld	s1,56(sp)
ffffffffc02045c4:	7942                	ld	s2,48(sp)
ffffffffc02045c6:	79a2                	ld	s3,40(sp)
ffffffffc02045c8:	7a02                	ld	s4,32(sp)
ffffffffc02045ca:	6ae2                	ld	s5,24(sp)
ffffffffc02045cc:	6b42                	ld	s6,16(sp)
ffffffffc02045ce:	6ba2                	ld	s7,8(sp)
ffffffffc02045d0:	6161                	addi	sp,sp,80
ffffffffc02045d2:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045d4:	000bb683          	ld	a3,0(s7)
ffffffffc02045d8:	f4843783          	ld	a5,-184(s0)
ffffffffc02045dc:	fed790e3          	bne	a5,a3,ffffffffc02045bc <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045e0:	f2842703          	lw	a4,-216(s0)
ffffffffc02045e4:	478d                	li	a5,3
ffffffffc02045e6:	0ef70b63          	beq	a4,a5,ffffffffc02046dc <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02045ea:	4785                	li	a5,1
ffffffffc02045ec:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02045ee:	0f26a623          	sw	s2,236(a3) # 20ec <_binary_obj___user_faultread_out_size-0x7abc>
        schedule();
ffffffffc02045f2:	2d7000ef          	jal	ra,ffffffffc02050c8 <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02045f6:	000bb783          	ld	a5,0(s7)
ffffffffc02045fa:	0b07a783          	lw	a5,176(a5)
ffffffffc02045fe:	8b85                	andi	a5,a5,1
ffffffffc0204600:	d7c9                	beqz	a5,ffffffffc020458a <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc0204602:	555d                	li	a0,-9
ffffffffc0204604:	e0bff0ef          	jal	ra,ffffffffc020440e <do_exit>
        proc = current->cptr;
ffffffffc0204608:	000bb683          	ld	a3,0(s7)
ffffffffc020460c:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc020460e:	d45d                	beqz	s0,ffffffffc02045bc <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204610:	470d                	li	a4,3
ffffffffc0204612:	a021                	j	ffffffffc020461a <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204614:	10043403          	ld	s0,256(s0)
ffffffffc0204618:	d869                	beqz	s0,ffffffffc02045ea <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020461a:	401c                	lw	a5,0(s0)
ffffffffc020461c:	fee79ce3          	bne	a5,a4,ffffffffc0204614 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204620:	000b1797          	auipc	a5,0xb1
ffffffffc0204624:	a087b783          	ld	a5,-1528(a5) # ffffffffc02b5028 <idleproc>
ffffffffc0204628:	0c878963          	beq	a5,s0,ffffffffc02046fa <do_wait.part.0+0x1a2>
ffffffffc020462c:	000b1797          	auipc	a5,0xb1
ffffffffc0204630:	a047b783          	ld	a5,-1532(a5) # ffffffffc02b5030 <initproc>
ffffffffc0204634:	0cf40363          	beq	s0,a5,ffffffffc02046fa <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc0204638:	000a0663          	beqz	s4,ffffffffc0204644 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc020463c:	0e842783          	lw	a5,232(s0)
ffffffffc0204640:	00fa2023          	sw	a5,0(s4)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204644:	100027f3          	csrr	a5,sstatus
ffffffffc0204648:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020464a:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020464c:	e7c1                	bnez	a5,ffffffffc02046d4 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc020464e:	6c70                	ld	a2,216(s0)
ffffffffc0204650:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204652:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc0204656:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc0204658:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020465a:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc020465c:	6470                	ld	a2,200(s0)
ffffffffc020465e:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204660:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204662:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204664:	c319                	beqz	a4,ffffffffc020466a <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc0204666:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc0204668:	7c7c                	ld	a5,248(s0)
ffffffffc020466a:	c3b5                	beqz	a5,ffffffffc02046ce <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc020466c:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204670:	000b1717          	auipc	a4,0xb1
ffffffffc0204674:	9c870713          	addi	a4,a4,-1592 # ffffffffc02b5038 <nr_process>
ffffffffc0204678:	431c                	lw	a5,0(a4)
ffffffffc020467a:	37fd                	addiw	a5,a5,-1
ffffffffc020467c:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc020467e:	e5a9                	bnez	a1,ffffffffc02046c8 <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204680:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc0204682:	c02007b7          	lui	a5,0xc0200
ffffffffc0204686:	04f6ee63          	bltu	a3,a5,ffffffffc02046e2 <do_wait.part.0+0x18a>
ffffffffc020468a:	000b1797          	auipc	a5,0xb1
ffffffffc020468e:	98e7b783          	ld	a5,-1650(a5) # ffffffffc02b5018 <va_pa_offset>
ffffffffc0204692:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204694:	82b1                	srli	a3,a3,0xc
ffffffffc0204696:	000b1797          	auipc	a5,0xb1
ffffffffc020469a:	96a7b783          	ld	a5,-1686(a5) # ffffffffc02b5000 <npage>
ffffffffc020469e:	06f6fa63          	bgeu	a3,a5,ffffffffc0204712 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc02046a2:	00003517          	auipc	a0,0x3
ffffffffc02046a6:	1ae53503          	ld	a0,430(a0) # ffffffffc0207850 <nbase>
ffffffffc02046aa:	8e89                	sub	a3,a3,a0
ffffffffc02046ac:	069a                	slli	a3,a3,0x6
ffffffffc02046ae:	000b1517          	auipc	a0,0xb1
ffffffffc02046b2:	95a53503          	ld	a0,-1702(a0) # ffffffffc02b5008 <pages>
ffffffffc02046b6:	9536                	add	a0,a0,a3
ffffffffc02046b8:	4589                	li	a1,2
ffffffffc02046ba:	81dfd0ef          	jal	ra,ffffffffc0201ed6 <free_pages>
    kfree(proc);
ffffffffc02046be:	8522                	mv	a0,s0
ffffffffc02046c0:	eaafd0ef          	jal	ra,ffffffffc0201d6a <kfree>
    return 0;
ffffffffc02046c4:	4501                	li	a0,0
ffffffffc02046c6:	bde5                	j	ffffffffc02045be <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02046c8:	ae6fc0ef          	jal	ra,ffffffffc02009ae <intr_enable>
ffffffffc02046cc:	bf55                	j	ffffffffc0204680 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02046ce:	701c                	ld	a5,32(s0)
ffffffffc02046d0:	fbf8                	sd	a4,240(a5)
ffffffffc02046d2:	bf79                	j	ffffffffc0204670 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02046d4:	ae0fc0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc02046d8:	4585                	li	a1,1
ffffffffc02046da:	bf95                	j	ffffffffc020464e <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02046dc:	f2840413          	addi	s0,s0,-216
ffffffffc02046e0:	b781                	j	ffffffffc0204620 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02046e2:	00002617          	auipc	a2,0x2
ffffffffc02046e6:	f4660613          	addi	a2,a2,-186 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc02046ea:	07700593          	li	a1,119
ffffffffc02046ee:	00002517          	auipc	a0,0x2
ffffffffc02046f2:	eba50513          	addi	a0,a0,-326 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc02046f6:	d99fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02046fa:	00003617          	auipc	a2,0x3
ffffffffc02046fe:	93e60613          	addi	a2,a2,-1730 # ffffffffc0207038 <default_pmm_manager+0xaf0>
ffffffffc0204702:	35b00593          	li	a1,859
ffffffffc0204706:	00003517          	auipc	a0,0x3
ffffffffc020470a:	8b250513          	addi	a0,a0,-1870 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020470e:	d81fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204712:	00002617          	auipc	a2,0x2
ffffffffc0204716:	f3e60613          	addi	a2,a2,-194 # ffffffffc0206650 <default_pmm_manager+0x108>
ffffffffc020471a:	06900593          	li	a1,105
ffffffffc020471e:	00002517          	auipc	a0,0x2
ffffffffc0204722:	e8a50513          	addi	a0,a0,-374 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0204726:	d69fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020472a <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020472a:	1141                	addi	sp,sp,-16
ffffffffc020472c:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc020472e:	fe8fd0ef          	jal	ra,ffffffffc0201f16 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204732:	d84fd0ef          	jal	ra,ffffffffc0201cb6 <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc0204736:	4601                	li	a2,0
ffffffffc0204738:	4581                	li	a1,0
ffffffffc020473a:	fffff517          	auipc	a0,0xfffff
ffffffffc020473e:	75450513          	addi	a0,a0,1876 # ffffffffc0203e8e <user_main>
ffffffffc0204742:	c7dff0ef          	jal	ra,ffffffffc02043be <kernel_thread>
    if (pid <= 0)
ffffffffc0204746:	00a04563          	bgtz	a0,ffffffffc0204750 <init_main+0x26>
ffffffffc020474a:	a071                	j	ffffffffc02047d6 <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc020474c:	17d000ef          	jal	ra,ffffffffc02050c8 <schedule>
    if (code_store != NULL)
ffffffffc0204750:	4581                	li	a1,0
ffffffffc0204752:	4501                	li	a0,0
ffffffffc0204754:	e05ff0ef          	jal	ra,ffffffffc0204558 <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc0204758:	d975                	beqz	a0,ffffffffc020474c <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc020475a:	00003517          	auipc	a0,0x3
ffffffffc020475e:	91e50513          	addi	a0,a0,-1762 # ffffffffc0207078 <default_pmm_manager+0xb30>
ffffffffc0204762:	a33fb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc0204766:	000b1797          	auipc	a5,0xb1
ffffffffc020476a:	8ca7b783          	ld	a5,-1846(a5) # ffffffffc02b5030 <initproc>
ffffffffc020476e:	7bf8                	ld	a4,240(a5)
ffffffffc0204770:	e339                	bnez	a4,ffffffffc02047b6 <init_main+0x8c>
ffffffffc0204772:	7ff8                	ld	a4,248(a5)
ffffffffc0204774:	e329                	bnez	a4,ffffffffc02047b6 <init_main+0x8c>
ffffffffc0204776:	1007b703          	ld	a4,256(a5)
ffffffffc020477a:	ef15                	bnez	a4,ffffffffc02047b6 <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc020477c:	000b1697          	auipc	a3,0xb1
ffffffffc0204780:	8bc6a683          	lw	a3,-1860(a3) # ffffffffc02b5038 <nr_process>
ffffffffc0204784:	4709                	li	a4,2
ffffffffc0204786:	0ae69463          	bne	a3,a4,ffffffffc020482e <init_main+0x104>
    return listelm->next;
ffffffffc020478a:	000b1697          	auipc	a3,0xb1
ffffffffc020478e:	82668693          	addi	a3,a3,-2010 # ffffffffc02b4fb0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204792:	6698                	ld	a4,8(a3)
ffffffffc0204794:	0c878793          	addi	a5,a5,200
ffffffffc0204798:	06f71b63          	bne	a4,a5,ffffffffc020480e <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc020479c:	629c                	ld	a5,0(a3)
ffffffffc020479e:	04f71863          	bne	a4,a5,ffffffffc02047ee <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc02047a2:	00003517          	auipc	a0,0x3
ffffffffc02047a6:	9be50513          	addi	a0,a0,-1602 # ffffffffc0207160 <default_pmm_manager+0xc18>
ffffffffc02047aa:	9ebfb0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02047ae:	60a2                	ld	ra,8(sp)
ffffffffc02047b0:	4501                	li	a0,0
ffffffffc02047b2:	0141                	addi	sp,sp,16
ffffffffc02047b4:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02047b6:	00003697          	auipc	a3,0x3
ffffffffc02047ba:	8ea68693          	addi	a3,a3,-1814 # ffffffffc02070a0 <default_pmm_manager+0xb58>
ffffffffc02047be:	00001617          	auipc	a2,0x1
ffffffffc02047c2:	7aa60613          	addi	a2,a2,1962 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02047c6:	3c900593          	li	a1,969
ffffffffc02047ca:	00002517          	auipc	a0,0x2
ffffffffc02047ce:	7ee50513          	addi	a0,a0,2030 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc02047d2:	cbdfb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("create user_main failed.\n");
ffffffffc02047d6:	00003617          	auipc	a2,0x3
ffffffffc02047da:	88260613          	addi	a2,a2,-1918 # ffffffffc0207058 <default_pmm_manager+0xb10>
ffffffffc02047de:	3c000593          	li	a1,960
ffffffffc02047e2:	00002517          	auipc	a0,0x2
ffffffffc02047e6:	7d650513          	addi	a0,a0,2006 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc02047ea:	ca5fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02047ee:	00003697          	auipc	a3,0x3
ffffffffc02047f2:	94268693          	addi	a3,a3,-1726 # ffffffffc0207130 <default_pmm_manager+0xbe8>
ffffffffc02047f6:	00001617          	auipc	a2,0x1
ffffffffc02047fa:	77260613          	addi	a2,a2,1906 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02047fe:	3cc00593          	li	a1,972
ffffffffc0204802:	00002517          	auipc	a0,0x2
ffffffffc0204806:	7b650513          	addi	a0,a0,1974 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020480a:	c85fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc020480e:	00003697          	auipc	a3,0x3
ffffffffc0204812:	8f268693          	addi	a3,a3,-1806 # ffffffffc0207100 <default_pmm_manager+0xbb8>
ffffffffc0204816:	00001617          	auipc	a2,0x1
ffffffffc020481a:	75260613          	addi	a2,a2,1874 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020481e:	3cb00593          	li	a1,971
ffffffffc0204822:	00002517          	auipc	a0,0x2
ffffffffc0204826:	79650513          	addi	a0,a0,1942 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020482a:	c65fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(nr_process == 2);
ffffffffc020482e:	00003697          	auipc	a3,0x3
ffffffffc0204832:	8c268693          	addi	a3,a3,-1854 # ffffffffc02070f0 <default_pmm_manager+0xba8>
ffffffffc0204836:	00001617          	auipc	a2,0x1
ffffffffc020483a:	73260613          	addi	a2,a2,1842 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc020483e:	3ca00593          	li	a1,970
ffffffffc0204842:	00002517          	auipc	a0,0x2
ffffffffc0204846:	77650513          	addi	a0,a0,1910 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc020484a:	c45fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc020484e <do_execve>:
{
ffffffffc020484e:	7171                	addi	sp,sp,-176
ffffffffc0204850:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204852:	000b0d97          	auipc	s11,0xb0
ffffffffc0204856:	7ced8d93          	addi	s11,s11,1998 # ffffffffc02b5020 <current>
ffffffffc020485a:	000db783          	ld	a5,0(s11)
{
ffffffffc020485e:	e54e                	sd	s3,136(sp)
ffffffffc0204860:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204862:	0287b983          	ld	s3,40(a5)
{
ffffffffc0204866:	e94a                	sd	s2,144(sp)
ffffffffc0204868:	f4de                	sd	s7,104(sp)
ffffffffc020486a:	892a                	mv	s2,a0
ffffffffc020486c:	8bb2                	mv	s7,a2
ffffffffc020486e:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204870:	862e                	mv	a2,a1
ffffffffc0204872:	4681                	li	a3,0
ffffffffc0204874:	85aa                	mv	a1,a0
ffffffffc0204876:	854e                	mv	a0,s3
{
ffffffffc0204878:	f506                	sd	ra,168(sp)
ffffffffc020487a:	f122                	sd	s0,160(sp)
ffffffffc020487c:	e152                	sd	s4,128(sp)
ffffffffc020487e:	fcd6                	sd	s5,120(sp)
ffffffffc0204880:	f8da                	sd	s6,112(sp)
ffffffffc0204882:	f0e2                	sd	s8,96(sp)
ffffffffc0204884:	ece6                	sd	s9,88(sp)
ffffffffc0204886:	e8ea                	sd	s10,80(sp)
ffffffffc0204888:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020488a:	cd8ff0ef          	jal	ra,ffffffffc0203d62 <user_mem_check>
ffffffffc020488e:	40050a63          	beqz	a0,ffffffffc0204ca2 <do_execve+0x454>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204892:	4641                	li	a2,16
ffffffffc0204894:	4581                	li	a1,0
ffffffffc0204896:	1808                	addi	a0,sp,48
ffffffffc0204898:	643000ef          	jal	ra,ffffffffc02056da <memset>
    memcpy(local_name, name, len);
ffffffffc020489c:	47bd                	li	a5,15
ffffffffc020489e:	8626                	mv	a2,s1
ffffffffc02048a0:	1e97e263          	bltu	a5,s1,ffffffffc0204a84 <do_execve+0x236>
ffffffffc02048a4:	85ca                	mv	a1,s2
ffffffffc02048a6:	1808                	addi	a0,sp,48
ffffffffc02048a8:	645000ef          	jal	ra,ffffffffc02056ec <memcpy>
    if (mm != NULL)
ffffffffc02048ac:	1e098363          	beqz	s3,ffffffffc0204a92 <do_execve+0x244>
        cputs("mm != NULL");
ffffffffc02048b0:	00002517          	auipc	a0,0x2
ffffffffc02048b4:	4c850513          	addi	a0,a0,1224 # ffffffffc0206d78 <default_pmm_manager+0x830>
ffffffffc02048b8:	915fb0ef          	jal	ra,ffffffffc02001cc <cputs>
ffffffffc02048bc:	000b0797          	auipc	a5,0xb0
ffffffffc02048c0:	7347b783          	ld	a5,1844(a5) # ffffffffc02b4ff0 <boot_pgdir_pa>
ffffffffc02048c4:	577d                	li	a4,-1
ffffffffc02048c6:	177e                	slli	a4,a4,0x3f
ffffffffc02048c8:	83b1                	srli	a5,a5,0xc
ffffffffc02048ca:	8fd9                	or	a5,a5,a4
ffffffffc02048cc:	18079073          	csrw	satp,a5
ffffffffc02048d0:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b78>
ffffffffc02048d4:	fff7871b          	addiw	a4,a5,-1
ffffffffc02048d8:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02048dc:	2c070463          	beqz	a4,ffffffffc0204ba4 <do_execve+0x356>
        current->mm = NULL;
ffffffffc02048e0:	000db783          	ld	a5,0(s11)
ffffffffc02048e4:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02048e8:	e05fe0ef          	jal	ra,ffffffffc02036ec <mm_create>
ffffffffc02048ec:	84aa                	mv	s1,a0
ffffffffc02048ee:	1c050d63          	beqz	a0,ffffffffc0204ac8 <do_execve+0x27a>
    if ((page = alloc_page()) == NULL)
ffffffffc02048f2:	4505                	li	a0,1
ffffffffc02048f4:	da4fd0ef          	jal	ra,ffffffffc0201e98 <alloc_pages>
ffffffffc02048f8:	3a050963          	beqz	a0,ffffffffc0204caa <do_execve+0x45c>
    return page - pages + nbase;
ffffffffc02048fc:	000b0c97          	auipc	s9,0xb0
ffffffffc0204900:	70cc8c93          	addi	s9,s9,1804 # ffffffffc02b5008 <pages>
ffffffffc0204904:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc0204908:	000b0c17          	auipc	s8,0xb0
ffffffffc020490c:	6f8c0c13          	addi	s8,s8,1784 # ffffffffc02b5000 <npage>
    return page - pages + nbase;
ffffffffc0204910:	00003717          	auipc	a4,0x3
ffffffffc0204914:	f4073703          	ld	a4,-192(a4) # ffffffffc0207850 <nbase>
ffffffffc0204918:	40d506b3          	sub	a3,a0,a3
ffffffffc020491c:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020491e:	5afd                	li	s5,-1
ffffffffc0204920:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204924:	96ba                	add	a3,a3,a4
ffffffffc0204926:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204928:	00cad713          	srli	a4,s5,0xc
ffffffffc020492c:	ec3a                	sd	a4,24(sp)
ffffffffc020492e:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204930:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204932:	38f77063          	bgeu	a4,a5,ffffffffc0204cb2 <do_execve+0x464>
ffffffffc0204936:	000b0b17          	auipc	s6,0xb0
ffffffffc020493a:	6e2b0b13          	addi	s6,s6,1762 # ffffffffc02b5018 <va_pa_offset>
ffffffffc020493e:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204942:	6605                	lui	a2,0x1
ffffffffc0204944:	000b0597          	auipc	a1,0xb0
ffffffffc0204948:	6b45b583          	ld	a1,1716(a1) # ffffffffc02b4ff8 <boot_pgdir_va>
ffffffffc020494c:	9936                	add	s2,s2,a3
ffffffffc020494e:	854a                	mv	a0,s2
ffffffffc0204950:	59d000ef          	jal	ra,ffffffffc02056ec <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204954:	7782                	ld	a5,32(sp)
ffffffffc0204956:	4398                	lw	a4,0(a5)
ffffffffc0204958:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc020495c:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204960:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b945f>
ffffffffc0204964:	14f71863          	bne	a4,a5,ffffffffc0204ab4 <do_execve+0x266>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204968:	7682                	ld	a3,32(sp)
ffffffffc020496a:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020496e:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204972:	00371793          	slli	a5,a4,0x3
ffffffffc0204976:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204978:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020497a:	078e                	slli	a5,a5,0x3
ffffffffc020497c:	97ce                	add	a5,a5,s3
ffffffffc020497e:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204980:	00f9fc63          	bgeu	s3,a5,ffffffffc0204998 <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204984:	0009a783          	lw	a5,0(s3)
ffffffffc0204988:	4705                	li	a4,1
ffffffffc020498a:	14e78163          	beq	a5,a4,ffffffffc0204acc <do_execve+0x27e>
    for (; ph < ph_end; ph++)
ffffffffc020498e:	77a2                	ld	a5,40(sp)
ffffffffc0204990:	03898993          	addi	s3,s3,56
ffffffffc0204994:	fef9e8e3          	bltu	s3,a5,ffffffffc0204984 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc0204998:	4701                	li	a4,0
ffffffffc020499a:	46ad                	li	a3,11
ffffffffc020499c:	00100637          	lui	a2,0x100
ffffffffc02049a0:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02049a4:	8526                	mv	a0,s1
ffffffffc02049a6:	ed9fe0ef          	jal	ra,ffffffffc020387e <mm_map>
ffffffffc02049aa:	8a2a                	mv	s4,a0
ffffffffc02049ac:	1e051263          	bnez	a0,ffffffffc0204b90 <do_execve+0x342>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02049b0:	6c88                	ld	a0,24(s1)
ffffffffc02049b2:	467d                	li	a2,31
ffffffffc02049b4:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02049b8:	c4ffe0ef          	jal	ra,ffffffffc0203606 <pgdir_alloc_page>
ffffffffc02049bc:	38050363          	beqz	a0,ffffffffc0204d42 <do_execve+0x4f4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049c0:	6c88                	ld	a0,24(s1)
ffffffffc02049c2:	467d                	li	a2,31
ffffffffc02049c4:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02049c8:	c3ffe0ef          	jal	ra,ffffffffc0203606 <pgdir_alloc_page>
ffffffffc02049cc:	34050b63          	beqz	a0,ffffffffc0204d22 <do_execve+0x4d4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049d0:	6c88                	ld	a0,24(s1)
ffffffffc02049d2:	467d                	li	a2,31
ffffffffc02049d4:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02049d8:	c2ffe0ef          	jal	ra,ffffffffc0203606 <pgdir_alloc_page>
ffffffffc02049dc:	32050363          	beqz	a0,ffffffffc0204d02 <do_execve+0x4b4>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049e0:	6c88                	ld	a0,24(s1)
ffffffffc02049e2:	467d                	li	a2,31
ffffffffc02049e4:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049e8:	c1ffe0ef          	jal	ra,ffffffffc0203606 <pgdir_alloc_page>
ffffffffc02049ec:	2e050b63          	beqz	a0,ffffffffc0204ce2 <do_execve+0x494>
    mm->mm_count += 1;
ffffffffc02049f0:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc02049f2:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049f6:	6c94                	ld	a3,24(s1)
ffffffffc02049f8:	2785                	addiw	a5,a5,1
ffffffffc02049fa:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc02049fc:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049fe:	c02007b7          	lui	a5,0xc0200
ffffffffc0204a02:	2cf6e463          	bltu	a3,a5,ffffffffc0204cca <do_execve+0x47c>
ffffffffc0204a06:	000b3783          	ld	a5,0(s6)
ffffffffc0204a0a:	577d                	li	a4,-1
ffffffffc0204a0c:	177e                	slli	a4,a4,0x3f
ffffffffc0204a0e:	8e9d                	sub	a3,a3,a5
ffffffffc0204a10:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204a14:	f654                	sd	a3,168(a2)
ffffffffc0204a16:	8fd9                	or	a5,a5,a4
ffffffffc0204a18:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204a1c:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a1e:	4581                	li	a1,0
ffffffffc0204a20:	12000613          	li	a2,288
ffffffffc0204a24:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204a26:	10043483          	ld	s1,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a2a:	4b1000ef          	jal	ra,ffffffffc02056da <memset>
    tf->epc = elf->e_entry;
ffffffffc0204a2e:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a30:	000db903          	ld	s2,0(s11)
    tf->status &= ~SSTATUS_SPP;
ffffffffc0204a34:	eff4f493          	andi	s1,s1,-257
    tf->epc = elf->e_entry;
ffffffffc0204a38:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a3a:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a3c:	0b490913          	addi	s2,s2,180 # ffffffff800000b4 <_binary_obj___user_exit_out_size+0xffffffff7fff4f94>
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a40:	07fe                	slli	a5,a5,0x1f
    tf->status |= SSTATUS_SPIE;
ffffffffc0204a42:	0204e493          	ori	s1,s1,32
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a46:	4641                	li	a2,16
ffffffffc0204a48:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a4a:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204a4c:	10e43423          	sd	a4,264(s0)
    tf->status |= SSTATUS_SPIE;
ffffffffc0204a50:	10943023          	sd	s1,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a54:	854a                	mv	a0,s2
ffffffffc0204a56:	485000ef          	jal	ra,ffffffffc02056da <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a5a:	463d                	li	a2,15
ffffffffc0204a5c:	180c                	addi	a1,sp,48
ffffffffc0204a5e:	854a                	mv	a0,s2
ffffffffc0204a60:	48d000ef          	jal	ra,ffffffffc02056ec <memcpy>
}
ffffffffc0204a64:	70aa                	ld	ra,168(sp)
ffffffffc0204a66:	740a                	ld	s0,160(sp)
ffffffffc0204a68:	64ea                	ld	s1,152(sp)
ffffffffc0204a6a:	694a                	ld	s2,144(sp)
ffffffffc0204a6c:	69aa                	ld	s3,136(sp)
ffffffffc0204a6e:	7ae6                	ld	s5,120(sp)
ffffffffc0204a70:	7b46                	ld	s6,112(sp)
ffffffffc0204a72:	7ba6                	ld	s7,104(sp)
ffffffffc0204a74:	7c06                	ld	s8,96(sp)
ffffffffc0204a76:	6ce6                	ld	s9,88(sp)
ffffffffc0204a78:	6d46                	ld	s10,80(sp)
ffffffffc0204a7a:	6da6                	ld	s11,72(sp)
ffffffffc0204a7c:	8552                	mv	a0,s4
ffffffffc0204a7e:	6a0a                	ld	s4,128(sp)
ffffffffc0204a80:	614d                	addi	sp,sp,176
ffffffffc0204a82:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204a84:	463d                	li	a2,15
ffffffffc0204a86:	85ca                	mv	a1,s2
ffffffffc0204a88:	1808                	addi	a0,sp,48
ffffffffc0204a8a:	463000ef          	jal	ra,ffffffffc02056ec <memcpy>
    if (mm != NULL)
ffffffffc0204a8e:	e20991e3          	bnez	s3,ffffffffc02048b0 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204a92:	000db783          	ld	a5,0(s11)
ffffffffc0204a96:	779c                	ld	a5,40(a5)
ffffffffc0204a98:	e40788e3          	beqz	a5,ffffffffc02048e8 <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204a9c:	00002617          	auipc	a2,0x2
ffffffffc0204aa0:	6e460613          	addi	a2,a2,1764 # ffffffffc0207180 <default_pmm_manager+0xc38>
ffffffffc0204aa4:	24300593          	li	a1,579
ffffffffc0204aa8:	00002517          	auipc	a0,0x2
ffffffffc0204aac:	51050513          	addi	a0,a0,1296 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204ab0:	9dffb0ef          	jal	ra,ffffffffc020048e <__panic>
    put_pgdir(mm);
ffffffffc0204ab4:	8526                	mv	a0,s1
ffffffffc0204ab6:	c56ff0ef          	jal	ra,ffffffffc0203f0c <put_pgdir>
    mm_destroy(mm);
ffffffffc0204aba:	8526                	mv	a0,s1
ffffffffc0204abc:	d71fe0ef          	jal	ra,ffffffffc020382c <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204ac0:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204ac2:	8552                	mv	a0,s4
ffffffffc0204ac4:	94bff0ef          	jal	ra,ffffffffc020440e <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204ac8:	5a71                	li	s4,-4
ffffffffc0204aca:	bfe5                	j	ffffffffc0204ac2 <do_execve+0x274>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204acc:	0289b603          	ld	a2,40(s3)
ffffffffc0204ad0:	0209b783          	ld	a5,32(s3)
ffffffffc0204ad4:	1cf66d63          	bltu	a2,a5,ffffffffc0204cae <do_execve+0x460>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204ad8:	0049a783          	lw	a5,4(s3)
ffffffffc0204adc:	0017f693          	andi	a3,a5,1
ffffffffc0204ae0:	c291                	beqz	a3,ffffffffc0204ae4 <do_execve+0x296>
            vm_flags |= VM_EXEC;
ffffffffc0204ae2:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ae4:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ae8:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204aea:	e779                	bnez	a4,ffffffffc0204bb8 <do_execve+0x36a>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204aec:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204aee:	c781                	beqz	a5,ffffffffc0204af6 <do_execve+0x2a8>
            vm_flags |= VM_READ;
ffffffffc0204af0:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204af4:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204af6:	0026f793          	andi	a5,a3,2
ffffffffc0204afa:	e3f1                	bnez	a5,ffffffffc0204bbe <do_execve+0x370>
        if (vm_flags & VM_EXEC)
ffffffffc0204afc:	0046f793          	andi	a5,a3,4
ffffffffc0204b00:	c399                	beqz	a5,ffffffffc0204b06 <do_execve+0x2b8>
            perm |= PTE_X;
ffffffffc0204b02:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204b06:	0109b583          	ld	a1,16(s3)
ffffffffc0204b0a:	4701                	li	a4,0
ffffffffc0204b0c:	8526                	mv	a0,s1
ffffffffc0204b0e:	d71fe0ef          	jal	ra,ffffffffc020387e <mm_map>
ffffffffc0204b12:	8a2a                	mv	s4,a0
ffffffffc0204b14:	ed35                	bnez	a0,ffffffffc0204b90 <do_execve+0x342>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b16:	0109bb83          	ld	s7,16(s3)
ffffffffc0204b1a:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b1c:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b20:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b24:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b28:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b2a:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b2c:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204b2e:	054be963          	bltu	s7,s4,ffffffffc0204b80 <do_execve+0x332>
ffffffffc0204b32:	aa95                	j	ffffffffc0204ca6 <do_execve+0x458>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204b34:	6785                	lui	a5,0x1
ffffffffc0204b36:	415b8533          	sub	a0,s7,s5
ffffffffc0204b3a:	9abe                	add	s5,s5,a5
ffffffffc0204b3c:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204b40:	015a7463          	bgeu	s4,s5,ffffffffc0204b48 <do_execve+0x2fa>
                size -= la - end;
ffffffffc0204b44:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204b48:	000cb683          	ld	a3,0(s9)
ffffffffc0204b4c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b4e:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204b52:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b56:	8699                	srai	a3,a3,0x6
ffffffffc0204b58:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b5a:	67e2                	ld	a5,24(sp)
ffffffffc0204b5c:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b60:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b62:	14b87863          	bgeu	a6,a1,ffffffffc0204cb2 <do_execve+0x464>
ffffffffc0204b66:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b6a:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204b6c:	9bb2                	add	s7,s7,a2
ffffffffc0204b6e:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b70:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204b72:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b74:	379000ef          	jal	ra,ffffffffc02056ec <memcpy>
            start += size, from += size;
ffffffffc0204b78:	6622                	ld	a2,8(sp)
ffffffffc0204b7a:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204b7c:	054bf363          	bgeu	s7,s4,ffffffffc0204bc2 <do_execve+0x374>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b80:	6c88                	ld	a0,24(s1)
ffffffffc0204b82:	866a                	mv	a2,s10
ffffffffc0204b84:	85d6                	mv	a1,s5
ffffffffc0204b86:	a81fe0ef          	jal	ra,ffffffffc0203606 <pgdir_alloc_page>
ffffffffc0204b8a:	842a                	mv	s0,a0
ffffffffc0204b8c:	f545                	bnez	a0,ffffffffc0204b34 <do_execve+0x2e6>
        ret = -E_NO_MEM;
ffffffffc0204b8e:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204b90:	8526                	mv	a0,s1
ffffffffc0204b92:	e37fe0ef          	jal	ra,ffffffffc02039c8 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204b96:	8526                	mv	a0,s1
ffffffffc0204b98:	b74ff0ef          	jal	ra,ffffffffc0203f0c <put_pgdir>
    mm_destroy(mm);
ffffffffc0204b9c:	8526                	mv	a0,s1
ffffffffc0204b9e:	c8ffe0ef          	jal	ra,ffffffffc020382c <mm_destroy>
    return ret;
ffffffffc0204ba2:	b705                	j	ffffffffc0204ac2 <do_execve+0x274>
            exit_mmap(mm);
ffffffffc0204ba4:	854e                	mv	a0,s3
ffffffffc0204ba6:	e23fe0ef          	jal	ra,ffffffffc02039c8 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204baa:	854e                	mv	a0,s3
ffffffffc0204bac:	b60ff0ef          	jal	ra,ffffffffc0203f0c <put_pgdir>
            mm_destroy(mm);
ffffffffc0204bb0:	854e                	mv	a0,s3
ffffffffc0204bb2:	c7bfe0ef          	jal	ra,ffffffffc020382c <mm_destroy>
ffffffffc0204bb6:	b32d                	j	ffffffffc02048e0 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204bb8:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204bbc:	fb95                	bnez	a5,ffffffffc0204af0 <do_execve+0x2a2>
            perm |= (PTE_W | PTE_R);
ffffffffc0204bbe:	4d5d                	li	s10,23
ffffffffc0204bc0:	bf35                	j	ffffffffc0204afc <do_execve+0x2ae>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204bc2:	0109b683          	ld	a3,16(s3)
ffffffffc0204bc6:	0289b903          	ld	s2,40(s3)
ffffffffc0204bca:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204bcc:	075bfd63          	bgeu	s7,s5,ffffffffc0204c46 <do_execve+0x3f8>
            if (start == end)
ffffffffc0204bd0:	db790fe3          	beq	s2,s7,ffffffffc020498e <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204bd4:	6785                	lui	a5,0x1
ffffffffc0204bd6:	00fb8533          	add	a0,s7,a5
ffffffffc0204bda:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204bde:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204be2:	0b597d63          	bgeu	s2,s5,ffffffffc0204c9c <do_execve+0x44e>
    return page - pages + nbase;
ffffffffc0204be6:	000cb683          	ld	a3,0(s9)
ffffffffc0204bea:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204bec:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204bf0:	40d406b3          	sub	a3,s0,a3
ffffffffc0204bf4:	8699                	srai	a3,a3,0x6
ffffffffc0204bf6:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204bf8:	67e2                	ld	a5,24(sp)
ffffffffc0204bfa:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bfe:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c00:	0ac5f963          	bgeu	a1,a2,ffffffffc0204cb2 <do_execve+0x464>
ffffffffc0204c04:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c08:	8652                	mv	a2,s4
ffffffffc0204c0a:	4581                	li	a1,0
ffffffffc0204c0c:	96c2                	add	a3,a3,a6
ffffffffc0204c0e:	9536                	add	a0,a0,a3
ffffffffc0204c10:	2cb000ef          	jal	ra,ffffffffc02056da <memset>
            start += size;
ffffffffc0204c14:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204c18:	03597463          	bgeu	s2,s5,ffffffffc0204c40 <do_execve+0x3f2>
ffffffffc0204c1c:	d6e909e3          	beq	s2,a4,ffffffffc020498e <do_execve+0x140>
ffffffffc0204c20:	00002697          	auipc	a3,0x2
ffffffffc0204c24:	58868693          	addi	a3,a3,1416 # ffffffffc02071a8 <default_pmm_manager+0xc60>
ffffffffc0204c28:	00001617          	auipc	a2,0x1
ffffffffc0204c2c:	34060613          	addi	a2,a2,832 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0204c30:	2ac00593          	li	a1,684
ffffffffc0204c34:	00002517          	auipc	a0,0x2
ffffffffc0204c38:	38450513          	addi	a0,a0,900 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204c3c:	853fb0ef          	jal	ra,ffffffffc020048e <__panic>
ffffffffc0204c40:	ff5710e3          	bne	a4,s5,ffffffffc0204c20 <do_execve+0x3d2>
ffffffffc0204c44:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204c46:	d52bf4e3          	bgeu	s7,s2,ffffffffc020498e <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c4a:	6c88                	ld	a0,24(s1)
ffffffffc0204c4c:	866a                	mv	a2,s10
ffffffffc0204c4e:	85d6                	mv	a1,s5
ffffffffc0204c50:	9b7fe0ef          	jal	ra,ffffffffc0203606 <pgdir_alloc_page>
ffffffffc0204c54:	842a                	mv	s0,a0
ffffffffc0204c56:	dd05                	beqz	a0,ffffffffc0204b8e <do_execve+0x340>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c58:	6785                	lui	a5,0x1
ffffffffc0204c5a:	415b8533          	sub	a0,s7,s5
ffffffffc0204c5e:	9abe                	add	s5,s5,a5
ffffffffc0204c60:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204c64:	01597463          	bgeu	s2,s5,ffffffffc0204c6c <do_execve+0x41e>
                size -= la - end;
ffffffffc0204c68:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204c6c:	000cb683          	ld	a3,0(s9)
ffffffffc0204c70:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c72:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204c76:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c7a:	8699                	srai	a3,a3,0x6
ffffffffc0204c7c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c7e:	67e2                	ld	a5,24(sp)
ffffffffc0204c80:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c84:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c86:	02b87663          	bgeu	a6,a1,ffffffffc0204cb2 <do_execve+0x464>
ffffffffc0204c8a:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c8e:	4581                	li	a1,0
            start += size;
ffffffffc0204c90:	9bb2                	add	s7,s7,a2
ffffffffc0204c92:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c94:	9536                	add	a0,a0,a3
ffffffffc0204c96:	245000ef          	jal	ra,ffffffffc02056da <memset>
ffffffffc0204c9a:	b775                	j	ffffffffc0204c46 <do_execve+0x3f8>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c9c:	417a8a33          	sub	s4,s5,s7
ffffffffc0204ca0:	b799                	j	ffffffffc0204be6 <do_execve+0x398>
        return -E_INVAL;
ffffffffc0204ca2:	5a75                	li	s4,-3
ffffffffc0204ca4:	b3c1                	j	ffffffffc0204a64 <do_execve+0x216>
        while (start < end)
ffffffffc0204ca6:	86de                	mv	a3,s7
ffffffffc0204ca8:	bf39                	j	ffffffffc0204bc6 <do_execve+0x378>
    int ret = -E_NO_MEM;
ffffffffc0204caa:	5a71                	li	s4,-4
ffffffffc0204cac:	bdc5                	j	ffffffffc0204b9c <do_execve+0x34e>
            ret = -E_INVAL_ELF;
ffffffffc0204cae:	5a61                	li	s4,-8
ffffffffc0204cb0:	b5c5                	j	ffffffffc0204b90 <do_execve+0x342>
ffffffffc0204cb2:	00002617          	auipc	a2,0x2
ffffffffc0204cb6:	8ce60613          	addi	a2,a2,-1842 # ffffffffc0206580 <default_pmm_manager+0x38>
ffffffffc0204cba:	07100593          	li	a1,113
ffffffffc0204cbe:	00002517          	auipc	a0,0x2
ffffffffc0204cc2:	8ea50513          	addi	a0,a0,-1814 # ffffffffc02065a8 <default_pmm_manager+0x60>
ffffffffc0204cc6:	fc8fb0ef          	jal	ra,ffffffffc020048e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cca:	00002617          	auipc	a2,0x2
ffffffffc0204cce:	95e60613          	addi	a2,a2,-1698 # ffffffffc0206628 <default_pmm_manager+0xe0>
ffffffffc0204cd2:	2cb00593          	li	a1,715
ffffffffc0204cd6:	00002517          	auipc	a0,0x2
ffffffffc0204cda:	2e250513          	addi	a0,a0,738 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204cde:	fb0fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204ce2:	00002697          	auipc	a3,0x2
ffffffffc0204ce6:	5de68693          	addi	a3,a3,1502 # ffffffffc02072c0 <default_pmm_manager+0xd78>
ffffffffc0204cea:	00001617          	auipc	a2,0x1
ffffffffc0204cee:	27e60613          	addi	a2,a2,638 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0204cf2:	2c600593          	li	a1,710
ffffffffc0204cf6:	00002517          	auipc	a0,0x2
ffffffffc0204cfa:	2c250513          	addi	a0,a0,706 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204cfe:	f90fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d02:	00002697          	auipc	a3,0x2
ffffffffc0204d06:	57668693          	addi	a3,a3,1398 # ffffffffc0207278 <default_pmm_manager+0xd30>
ffffffffc0204d0a:	00001617          	auipc	a2,0x1
ffffffffc0204d0e:	25e60613          	addi	a2,a2,606 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0204d12:	2c500593          	li	a1,709
ffffffffc0204d16:	00002517          	auipc	a0,0x2
ffffffffc0204d1a:	2a250513          	addi	a0,a0,674 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204d1e:	f70fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d22:	00002697          	auipc	a3,0x2
ffffffffc0204d26:	50e68693          	addi	a3,a3,1294 # ffffffffc0207230 <default_pmm_manager+0xce8>
ffffffffc0204d2a:	00001617          	auipc	a2,0x1
ffffffffc0204d2e:	23e60613          	addi	a2,a2,574 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0204d32:	2c400593          	li	a1,708
ffffffffc0204d36:	00002517          	auipc	a0,0x2
ffffffffc0204d3a:	28250513          	addi	a0,a0,642 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204d3e:	f50fb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d42:	00002697          	auipc	a3,0x2
ffffffffc0204d46:	4a668693          	addi	a3,a3,1190 # ffffffffc02071e8 <default_pmm_manager+0xca0>
ffffffffc0204d4a:	00001617          	auipc	a2,0x1
ffffffffc0204d4e:	21e60613          	addi	a2,a2,542 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0204d52:	2c300593          	li	a1,707
ffffffffc0204d56:	00002517          	auipc	a0,0x2
ffffffffc0204d5a:	26250513          	addi	a0,a0,610 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204d5e:	f30fb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204d62 <do_yield>:
    current->need_resched = 1;
ffffffffc0204d62:	000b0797          	auipc	a5,0xb0
ffffffffc0204d66:	2be7b783          	ld	a5,702(a5) # ffffffffc02b5020 <current>
ffffffffc0204d6a:	4705                	li	a4,1
ffffffffc0204d6c:	ef98                	sd	a4,24(a5)
}
ffffffffc0204d6e:	4501                	li	a0,0
ffffffffc0204d70:	8082                	ret

ffffffffc0204d72 <do_wait>:
{
ffffffffc0204d72:	1101                	addi	sp,sp,-32
ffffffffc0204d74:	e822                	sd	s0,16(sp)
ffffffffc0204d76:	e426                	sd	s1,8(sp)
ffffffffc0204d78:	ec06                	sd	ra,24(sp)
ffffffffc0204d7a:	842e                	mv	s0,a1
ffffffffc0204d7c:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204d7e:	c999                	beqz	a1,ffffffffc0204d94 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204d80:	000b0797          	auipc	a5,0xb0
ffffffffc0204d84:	2a07b783          	ld	a5,672(a5) # ffffffffc02b5020 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d88:	7788                	ld	a0,40(a5)
ffffffffc0204d8a:	4685                	li	a3,1
ffffffffc0204d8c:	4611                	li	a2,4
ffffffffc0204d8e:	fd5fe0ef          	jal	ra,ffffffffc0203d62 <user_mem_check>
ffffffffc0204d92:	c909                	beqz	a0,ffffffffc0204da4 <do_wait+0x32>
ffffffffc0204d94:	85a2                	mv	a1,s0
}
ffffffffc0204d96:	6442                	ld	s0,16(sp)
ffffffffc0204d98:	60e2                	ld	ra,24(sp)
ffffffffc0204d9a:	8526                	mv	a0,s1
ffffffffc0204d9c:	64a2                	ld	s1,8(sp)
ffffffffc0204d9e:	6105                	addi	sp,sp,32
ffffffffc0204da0:	fb8ff06f          	j	ffffffffc0204558 <do_wait.part.0>
ffffffffc0204da4:	60e2                	ld	ra,24(sp)
ffffffffc0204da6:	6442                	ld	s0,16(sp)
ffffffffc0204da8:	64a2                	ld	s1,8(sp)
ffffffffc0204daa:	5575                	li	a0,-3
ffffffffc0204dac:	6105                	addi	sp,sp,32
ffffffffc0204dae:	8082                	ret

ffffffffc0204db0 <do_kill>:
{
ffffffffc0204db0:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204db2:	6789                	lui	a5,0x2
{
ffffffffc0204db4:	e406                	sd	ra,8(sp)
ffffffffc0204db6:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204db8:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204dbc:	17f9                	addi	a5,a5,-2
ffffffffc0204dbe:	02e7e963          	bltu	a5,a4,ffffffffc0204df0 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204dc2:	842a                	mv	s0,a0
ffffffffc0204dc4:	45a9                	li	a1,10
ffffffffc0204dc6:	2501                	sext.w	a0,a0
ffffffffc0204dc8:	46c000ef          	jal	ra,ffffffffc0205234 <hash32>
ffffffffc0204dcc:	02051793          	slli	a5,a0,0x20
ffffffffc0204dd0:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204dd4:	000ac797          	auipc	a5,0xac
ffffffffc0204dd8:	1dc78793          	addi	a5,a5,476 # ffffffffc02b0fb0 <hash_list>
ffffffffc0204ddc:	953e                	add	a0,a0,a5
ffffffffc0204dde:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204de0:	a029                	j	ffffffffc0204dea <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204de2:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204de6:	00870b63          	beq	a4,s0,ffffffffc0204dfc <do_kill+0x4c>
ffffffffc0204dea:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204dec:	fef51be3          	bne	a0,a5,ffffffffc0204de2 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204df0:	5475                	li	s0,-3
}
ffffffffc0204df2:	60a2                	ld	ra,8(sp)
ffffffffc0204df4:	8522                	mv	a0,s0
ffffffffc0204df6:	6402                	ld	s0,0(sp)
ffffffffc0204df8:	0141                	addi	sp,sp,16
ffffffffc0204dfa:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204dfc:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204e00:	00177693          	andi	a3,a4,1
ffffffffc0204e04:	e295                	bnez	a3,ffffffffc0204e28 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e06:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204e08:	00176713          	ori	a4,a4,1
ffffffffc0204e0c:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204e10:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e12:	fe06d0e3          	bgez	a3,ffffffffc0204df2 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204e16:	f2878513          	addi	a0,a5,-216
ffffffffc0204e1a:	22e000ef          	jal	ra,ffffffffc0205048 <wakeup_proc>
}
ffffffffc0204e1e:	60a2                	ld	ra,8(sp)
ffffffffc0204e20:	8522                	mv	a0,s0
ffffffffc0204e22:	6402                	ld	s0,0(sp)
ffffffffc0204e24:	0141                	addi	sp,sp,16
ffffffffc0204e26:	8082                	ret
        return -E_KILLED;
ffffffffc0204e28:	545d                	li	s0,-9
ffffffffc0204e2a:	b7e1                	j	ffffffffc0204df2 <do_kill+0x42>

ffffffffc0204e2c <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204e2c:	1101                	addi	sp,sp,-32
ffffffffc0204e2e:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204e30:	000b0797          	auipc	a5,0xb0
ffffffffc0204e34:	18078793          	addi	a5,a5,384 # ffffffffc02b4fb0 <proc_list>
ffffffffc0204e38:	ec06                	sd	ra,24(sp)
ffffffffc0204e3a:	e822                	sd	s0,16(sp)
ffffffffc0204e3c:	e04a                	sd	s2,0(sp)
ffffffffc0204e3e:	000ac497          	auipc	s1,0xac
ffffffffc0204e42:	17248493          	addi	s1,s1,370 # ffffffffc02b0fb0 <hash_list>
ffffffffc0204e46:	e79c                	sd	a5,8(a5)
ffffffffc0204e48:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204e4a:	000b0717          	auipc	a4,0xb0
ffffffffc0204e4e:	16670713          	addi	a4,a4,358 # ffffffffc02b4fb0 <proc_list>
ffffffffc0204e52:	87a6                	mv	a5,s1
ffffffffc0204e54:	e79c                	sd	a5,8(a5)
ffffffffc0204e56:	e39c                	sd	a5,0(a5)
ffffffffc0204e58:	07c1                	addi	a5,a5,16
ffffffffc0204e5a:	fef71de3          	bne	a4,a5,ffffffffc0204e54 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204e5e:	fa1fe0ef          	jal	ra,ffffffffc0203dfe <alloc_proc>
ffffffffc0204e62:	000b0917          	auipc	s2,0xb0
ffffffffc0204e66:	1c690913          	addi	s2,s2,454 # ffffffffc02b5028 <idleproc>
ffffffffc0204e6a:	00a93023          	sd	a0,0(s2)
ffffffffc0204e6e:	0e050f63          	beqz	a0,ffffffffc0204f6c <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204e72:	4789                	li	a5,2
ffffffffc0204e74:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e76:	00003797          	auipc	a5,0x3
ffffffffc0204e7a:	18a78793          	addi	a5,a5,394 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e7e:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e82:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204e84:	4785                	li	a5,1
ffffffffc0204e86:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e88:	4641                	li	a2,16
ffffffffc0204e8a:	4581                	li	a1,0
ffffffffc0204e8c:	8522                	mv	a0,s0
ffffffffc0204e8e:	04d000ef          	jal	ra,ffffffffc02056da <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e92:	463d                	li	a2,15
ffffffffc0204e94:	00002597          	auipc	a1,0x2
ffffffffc0204e98:	48c58593          	addi	a1,a1,1164 # ffffffffc0207320 <default_pmm_manager+0xdd8>
ffffffffc0204e9c:	8522                	mv	a0,s0
ffffffffc0204e9e:	04f000ef          	jal	ra,ffffffffc02056ec <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204ea2:	000b0717          	auipc	a4,0xb0
ffffffffc0204ea6:	19670713          	addi	a4,a4,406 # ffffffffc02b5038 <nr_process>
ffffffffc0204eaa:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204eac:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204eb0:	4601                	li	a2,0
    nr_process++;
ffffffffc0204eb2:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204eb4:	4581                	li	a1,0
ffffffffc0204eb6:	00000517          	auipc	a0,0x0
ffffffffc0204eba:	87450513          	addi	a0,a0,-1932 # ffffffffc020472a <init_main>
    nr_process++;
ffffffffc0204ebe:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204ec0:	000b0797          	auipc	a5,0xb0
ffffffffc0204ec4:	16d7b023          	sd	a3,352(a5) # ffffffffc02b5020 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ec8:	cf6ff0ef          	jal	ra,ffffffffc02043be <kernel_thread>
ffffffffc0204ecc:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204ece:	08a05363          	blez	a0,ffffffffc0204f54 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ed2:	6789                	lui	a5,0x2
ffffffffc0204ed4:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204ed8:	17f9                	addi	a5,a5,-2
ffffffffc0204eda:	2501                	sext.w	a0,a0
ffffffffc0204edc:	02e7e363          	bltu	a5,a4,ffffffffc0204f02 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204ee0:	45a9                	li	a1,10
ffffffffc0204ee2:	352000ef          	jal	ra,ffffffffc0205234 <hash32>
ffffffffc0204ee6:	02051793          	slli	a5,a0,0x20
ffffffffc0204eea:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204eee:	96a6                	add	a3,a3,s1
ffffffffc0204ef0:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204ef2:	a029                	j	ffffffffc0204efc <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204ef4:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c7c>
ffffffffc0204ef8:	04870b63          	beq	a4,s0,ffffffffc0204f4e <proc_init+0x122>
    return listelm->next;
ffffffffc0204efc:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204efe:	fef69be3          	bne	a3,a5,ffffffffc0204ef4 <proc_init+0xc8>
    return NULL;
ffffffffc0204f02:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f04:	0b478493          	addi	s1,a5,180
ffffffffc0204f08:	4641                	li	a2,16
ffffffffc0204f0a:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204f0c:	000b0417          	auipc	s0,0xb0
ffffffffc0204f10:	12440413          	addi	s0,s0,292 # ffffffffc02b5030 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f14:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204f16:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f18:	7c2000ef          	jal	ra,ffffffffc02056da <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f1c:	463d                	li	a2,15
ffffffffc0204f1e:	00002597          	auipc	a1,0x2
ffffffffc0204f22:	42a58593          	addi	a1,a1,1066 # ffffffffc0207348 <default_pmm_manager+0xe00>
ffffffffc0204f26:	8526                	mv	a0,s1
ffffffffc0204f28:	7c4000ef          	jal	ra,ffffffffc02056ec <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f2c:	00093783          	ld	a5,0(s2)
ffffffffc0204f30:	cbb5                	beqz	a5,ffffffffc0204fa4 <proc_init+0x178>
ffffffffc0204f32:	43dc                	lw	a5,4(a5)
ffffffffc0204f34:	eba5                	bnez	a5,ffffffffc0204fa4 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f36:	601c                	ld	a5,0(s0)
ffffffffc0204f38:	c7b1                	beqz	a5,ffffffffc0204f84 <proc_init+0x158>
ffffffffc0204f3a:	43d8                	lw	a4,4(a5)
ffffffffc0204f3c:	4785                	li	a5,1
ffffffffc0204f3e:	04f71363          	bne	a4,a5,ffffffffc0204f84 <proc_init+0x158>
}
ffffffffc0204f42:	60e2                	ld	ra,24(sp)
ffffffffc0204f44:	6442                	ld	s0,16(sp)
ffffffffc0204f46:	64a2                	ld	s1,8(sp)
ffffffffc0204f48:	6902                	ld	s2,0(sp)
ffffffffc0204f4a:	6105                	addi	sp,sp,32
ffffffffc0204f4c:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204f4e:	f2878793          	addi	a5,a5,-216
ffffffffc0204f52:	bf4d                	j	ffffffffc0204f04 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204f54:	00002617          	auipc	a2,0x2
ffffffffc0204f58:	3d460613          	addi	a2,a2,980 # ffffffffc0207328 <default_pmm_manager+0xde0>
ffffffffc0204f5c:	3ef00593          	li	a1,1007
ffffffffc0204f60:	00002517          	auipc	a0,0x2
ffffffffc0204f64:	05850513          	addi	a0,a0,88 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204f68:	d26fb0ef          	jal	ra,ffffffffc020048e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204f6c:	00002617          	auipc	a2,0x2
ffffffffc0204f70:	39c60613          	addi	a2,a2,924 # ffffffffc0207308 <default_pmm_manager+0xdc0>
ffffffffc0204f74:	3e000593          	li	a1,992
ffffffffc0204f78:	00002517          	auipc	a0,0x2
ffffffffc0204f7c:	04050513          	addi	a0,a0,64 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204f80:	d0efb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f84:	00002697          	auipc	a3,0x2
ffffffffc0204f88:	3f468693          	addi	a3,a3,1012 # ffffffffc0207378 <default_pmm_manager+0xe30>
ffffffffc0204f8c:	00001617          	auipc	a2,0x1
ffffffffc0204f90:	fdc60613          	addi	a2,a2,-36 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0204f94:	3f600593          	li	a1,1014
ffffffffc0204f98:	00002517          	auipc	a0,0x2
ffffffffc0204f9c:	02050513          	addi	a0,a0,32 # ffffffffc0206fb8 <default_pmm_manager+0xa70>
ffffffffc0204fa0:	ceefb0ef          	jal	ra,ffffffffc020048e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204fa4:	00002697          	auipc	a3,0x2
ffffffffc0204fa8:	3ac68693          	addi	a3,a3,940 # ffffffffc0207350 <default_pmm_manager+0xe08>
ffffffffc0204fac:	00001617          	auipc	a2,0x1
ffffffffc0204fb0:	fbc60613          	addi	a2,a2,-68 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc0204fb4:	3f500593          	li	a1,1013
ffffffffc0204fb8:	00002517          	auipc	a0,0x2
ffffffffc0204fbc:	00050513          	mv	a0,a0
ffffffffc0204fc0:	ccefb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0204fc4 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204fc4:	1141                	addi	sp,sp,-16
ffffffffc0204fc6:	e022                	sd	s0,0(sp)
ffffffffc0204fc8:	e406                	sd	ra,8(sp)
ffffffffc0204fca:	000b0417          	auipc	s0,0xb0
ffffffffc0204fce:	05640413          	addi	s0,s0,86 # ffffffffc02b5020 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204fd2:	6018                	ld	a4,0(s0)
ffffffffc0204fd4:	6f1c                	ld	a5,24(a4)
ffffffffc0204fd6:	dffd                	beqz	a5,ffffffffc0204fd4 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204fd8:	0f0000ef          	jal	ra,ffffffffc02050c8 <schedule>
ffffffffc0204fdc:	bfdd                	j	ffffffffc0204fd2 <cpu_idle+0xe>

ffffffffc0204fde <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0204fde:	00153023          	sd	ra,0(a0) # ffffffffc0206fb8 <default_pmm_manager+0xa70>
    STORE sp, 1*REGBYTES(a0)
ffffffffc0204fe2:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0204fe6:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0204fe8:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0204fea:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0204fee:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0204ff2:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0204ff6:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0204ffa:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0204ffe:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0205002:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0205006:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020500a:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc020500e:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0205012:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0205016:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020501a:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc020501c:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc020501e:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0205022:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0205026:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020502a:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc020502e:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0205032:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0205036:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020503a:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc020503e:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0205042:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0205046:	8082                	ret

ffffffffc0205048 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205048:	4118                	lw	a4,0(a0)
{
ffffffffc020504a:	1101                	addi	sp,sp,-32
ffffffffc020504c:	ec06                	sd	ra,24(sp)
ffffffffc020504e:	e822                	sd	s0,16(sp)
ffffffffc0205050:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205052:	478d                	li	a5,3
ffffffffc0205054:	04f70b63          	beq	a4,a5,ffffffffc02050aa <wakeup_proc+0x62>
ffffffffc0205058:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc020505a:	100027f3          	csrr	a5,sstatus
ffffffffc020505e:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0205060:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205062:	ef9d                	bnez	a5,ffffffffc02050a0 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0205064:	4789                	li	a5,2
ffffffffc0205066:	02f70163          	beq	a4,a5,ffffffffc0205088 <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc020506a:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc020506c:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0205070:	e491                	bnez	s1,ffffffffc020507c <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0205072:	60e2                	ld	ra,24(sp)
ffffffffc0205074:	6442                	ld	s0,16(sp)
ffffffffc0205076:	64a2                	ld	s1,8(sp)
ffffffffc0205078:	6105                	addi	sp,sp,32
ffffffffc020507a:	8082                	ret
ffffffffc020507c:	6442                	ld	s0,16(sp)
ffffffffc020507e:	60e2                	ld	ra,24(sp)
ffffffffc0205080:	64a2                	ld	s1,8(sp)
ffffffffc0205082:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0205084:	92bfb06f          	j	ffffffffc02009ae <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc0205088:	00002617          	auipc	a2,0x2
ffffffffc020508c:	35060613          	addi	a2,a2,848 # ffffffffc02073d8 <default_pmm_manager+0xe90>
ffffffffc0205090:	45d1                	li	a1,20
ffffffffc0205092:	00002517          	auipc	a0,0x2
ffffffffc0205096:	32e50513          	addi	a0,a0,814 # ffffffffc02073c0 <default_pmm_manager+0xe78>
ffffffffc020509a:	c5cfb0ef          	jal	ra,ffffffffc02004f6 <__warn>
ffffffffc020509e:	bfc9                	j	ffffffffc0205070 <wakeup_proc+0x28>
        intr_disable();
ffffffffc02050a0:	915fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc02050a4:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc02050a6:	4485                	li	s1,1
ffffffffc02050a8:	bf75                	j	ffffffffc0205064 <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc02050aa:	00002697          	auipc	a3,0x2
ffffffffc02050ae:	2f668693          	addi	a3,a3,758 # ffffffffc02073a0 <default_pmm_manager+0xe58>
ffffffffc02050b2:	00001617          	auipc	a2,0x1
ffffffffc02050b6:	eb660613          	addi	a2,a2,-330 # ffffffffc0205f68 <commands+0x5f8>
ffffffffc02050ba:	45a5                	li	a1,9
ffffffffc02050bc:	00002517          	auipc	a0,0x2
ffffffffc02050c0:	30450513          	addi	a0,a0,772 # ffffffffc02073c0 <default_pmm_manager+0xe78>
ffffffffc02050c4:	bcafb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc02050c8 <schedule>:

void schedule(void)
{
ffffffffc02050c8:	1141                	addi	sp,sp,-16
ffffffffc02050ca:	e406                	sd	ra,8(sp)
ffffffffc02050cc:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02050ce:	100027f3          	csrr	a5,sstatus
ffffffffc02050d2:	8b89                	andi	a5,a5,2
ffffffffc02050d4:	4401                	li	s0,0
ffffffffc02050d6:	efbd                	bnez	a5,ffffffffc0205154 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc02050d8:	000b0897          	auipc	a7,0xb0
ffffffffc02050dc:	f488b883          	ld	a7,-184(a7) # ffffffffc02b5020 <current>
ffffffffc02050e0:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02050e4:	000b0517          	auipc	a0,0xb0
ffffffffc02050e8:	f4453503          	ld	a0,-188(a0) # ffffffffc02b5028 <idleproc>
ffffffffc02050ec:	04a88e63          	beq	a7,a0,ffffffffc0205148 <schedule+0x80>
ffffffffc02050f0:	0c888693          	addi	a3,a7,200
ffffffffc02050f4:	000b0617          	auipc	a2,0xb0
ffffffffc02050f8:	ebc60613          	addi	a2,a2,-324 # ffffffffc02b4fb0 <proc_list>
        le = last;
ffffffffc02050fc:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc02050fe:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205100:	4809                	li	a6,2
ffffffffc0205102:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc0205104:	00c78863          	beq	a5,a2,ffffffffc0205114 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc0205108:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc020510c:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205110:	03070163          	beq	a4,a6,ffffffffc0205132 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc0205114:	fef697e3          	bne	a3,a5,ffffffffc0205102 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205118:	ed89                	bnez	a1,ffffffffc0205132 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc020511a:	451c                	lw	a5,8(a0)
ffffffffc020511c:	2785                	addiw	a5,a5,1
ffffffffc020511e:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc0205120:	00a88463          	beq	a7,a0,ffffffffc0205128 <schedule+0x60>
        {
            proc_run(next);
ffffffffc0205124:	e5ffe0ef          	jal	ra,ffffffffc0203f82 <proc_run>
    if (flag)
ffffffffc0205128:	e819                	bnez	s0,ffffffffc020513e <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020512a:	60a2                	ld	ra,8(sp)
ffffffffc020512c:	6402                	ld	s0,0(sp)
ffffffffc020512e:	0141                	addi	sp,sp,16
ffffffffc0205130:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc0205132:	4198                	lw	a4,0(a1)
ffffffffc0205134:	4789                	li	a5,2
ffffffffc0205136:	fef712e3          	bne	a4,a5,ffffffffc020511a <schedule+0x52>
ffffffffc020513a:	852e                	mv	a0,a1
ffffffffc020513c:	bff9                	j	ffffffffc020511a <schedule+0x52>
}
ffffffffc020513e:	6402                	ld	s0,0(sp)
ffffffffc0205140:	60a2                	ld	ra,8(sp)
ffffffffc0205142:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0205144:	86bfb06f          	j	ffffffffc02009ae <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0205148:	000b0617          	auipc	a2,0xb0
ffffffffc020514c:	e6860613          	addi	a2,a2,-408 # ffffffffc02b4fb0 <proc_list>
ffffffffc0205150:	86b2                	mv	a3,a2
ffffffffc0205152:	b76d                	j	ffffffffc02050fc <schedule+0x34>
        intr_disable();
ffffffffc0205154:	861fb0ef          	jal	ra,ffffffffc02009b4 <intr_disable>
        return 1;
ffffffffc0205158:	4405                	li	s0,1
ffffffffc020515a:	bfbd                	j	ffffffffc02050d8 <schedule+0x10>

ffffffffc020515c <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc020515c:	000b0797          	auipc	a5,0xb0
ffffffffc0205160:	ec47b783          	ld	a5,-316(a5) # ffffffffc02b5020 <current>
}
ffffffffc0205164:	43c8                	lw	a0,4(a5)
ffffffffc0205166:	8082                	ret

ffffffffc0205168 <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc0205168:	4501                	li	a0,0
ffffffffc020516a:	8082                	ret

ffffffffc020516c <sys_putc>:
    cputchar(c);
ffffffffc020516c:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc020516e:	1141                	addi	sp,sp,-16
ffffffffc0205170:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc0205172:	858fb0ef          	jal	ra,ffffffffc02001ca <cputchar>
}
ffffffffc0205176:	60a2                	ld	ra,8(sp)
ffffffffc0205178:	4501                	li	a0,0
ffffffffc020517a:	0141                	addi	sp,sp,16
ffffffffc020517c:	8082                	ret

ffffffffc020517e <sys_kill>:
    return do_kill(pid);
ffffffffc020517e:	4108                	lw	a0,0(a0)
ffffffffc0205180:	c31ff06f          	j	ffffffffc0204db0 <do_kill>

ffffffffc0205184 <sys_yield>:
    return do_yield();
ffffffffc0205184:	bdfff06f          	j	ffffffffc0204d62 <do_yield>

ffffffffc0205188 <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc0205188:	6d14                	ld	a3,24(a0)
ffffffffc020518a:	6910                	ld	a2,16(a0)
ffffffffc020518c:	650c                	ld	a1,8(a0)
ffffffffc020518e:	6108                	ld	a0,0(a0)
ffffffffc0205190:	ebeff06f          	j	ffffffffc020484e <do_execve>

ffffffffc0205194 <sys_wait>:
    return do_wait(pid, store);
ffffffffc0205194:	650c                	ld	a1,8(a0)
ffffffffc0205196:	4108                	lw	a0,0(a0)
ffffffffc0205198:	bdbff06f          	j	ffffffffc0204d72 <do_wait>

ffffffffc020519c <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc020519c:	000b0797          	auipc	a5,0xb0
ffffffffc02051a0:	e847b783          	ld	a5,-380(a5) # ffffffffc02b5020 <current>
ffffffffc02051a4:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc02051a6:	4501                	li	a0,0
ffffffffc02051a8:	6a0c                	ld	a1,16(a2)
ffffffffc02051aa:	e45fe06f          	j	ffffffffc0203fee <do_fork>

ffffffffc02051ae <sys_exit>:
    return do_exit(error_code);
ffffffffc02051ae:	4108                	lw	a0,0(a0)
ffffffffc02051b0:	a5eff06f          	j	ffffffffc020440e <do_exit>

ffffffffc02051b4 <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc02051b4:	715d                	addi	sp,sp,-80
ffffffffc02051b6:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc02051b8:	000b0497          	auipc	s1,0xb0
ffffffffc02051bc:	e6848493          	addi	s1,s1,-408 # ffffffffc02b5020 <current>
ffffffffc02051c0:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc02051c2:	e0a2                	sd	s0,64(sp)
ffffffffc02051c4:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc02051c6:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc02051c8:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051ca:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc02051cc:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc02051d0:	0327ee63          	bltu	a5,s2,ffffffffc020520c <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc02051d4:	00391713          	slli	a4,s2,0x3
ffffffffc02051d8:	00002797          	auipc	a5,0x2
ffffffffc02051dc:	26878793          	addi	a5,a5,616 # ffffffffc0207440 <syscalls>
ffffffffc02051e0:	97ba                	add	a5,a5,a4
ffffffffc02051e2:	639c                	ld	a5,0(a5)
ffffffffc02051e4:	c785                	beqz	a5,ffffffffc020520c <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc02051e6:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc02051e8:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc02051ea:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc02051ec:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc02051ee:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc02051f0:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc02051f2:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc02051f4:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc02051f6:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc02051f8:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc02051fa:	0028                	addi	a0,sp,8
ffffffffc02051fc:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc02051fe:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205200:	e828                	sd	a0,80(s0)
}
ffffffffc0205202:	6406                	ld	s0,64(sp)
ffffffffc0205204:	74e2                	ld	s1,56(sp)
ffffffffc0205206:	7942                	ld	s2,48(sp)
ffffffffc0205208:	6161                	addi	sp,sp,80
ffffffffc020520a:	8082                	ret
    print_trapframe(tf);
ffffffffc020520c:	8522                	mv	a0,s0
ffffffffc020520e:	997fb0ef          	jal	ra,ffffffffc0200ba4 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205212:	609c                	ld	a5,0(s1)
ffffffffc0205214:	86ca                	mv	a3,s2
ffffffffc0205216:	00002617          	auipc	a2,0x2
ffffffffc020521a:	1e260613          	addi	a2,a2,482 # ffffffffc02073f8 <default_pmm_manager+0xeb0>
ffffffffc020521e:	43d8                	lw	a4,4(a5)
ffffffffc0205220:	06200593          	li	a1,98
ffffffffc0205224:	0b478793          	addi	a5,a5,180
ffffffffc0205228:	00002517          	auipc	a0,0x2
ffffffffc020522c:	20050513          	addi	a0,a0,512 # ffffffffc0207428 <default_pmm_manager+0xee0>
ffffffffc0205230:	a5efb0ef          	jal	ra,ffffffffc020048e <__panic>

ffffffffc0205234 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205234:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205238:	2785                	addiw	a5,a5,1
ffffffffc020523a:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc020523e:	02000793          	li	a5,32
ffffffffc0205242:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205244:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205248:	8082                	ret

ffffffffc020524a <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc020524a:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020524e:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0205250:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205254:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205256:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020525a:	f022                	sd	s0,32(sp)
ffffffffc020525c:	ec26                	sd	s1,24(sp)
ffffffffc020525e:	e84a                	sd	s2,16(sp)
ffffffffc0205260:	f406                	sd	ra,40(sp)
ffffffffc0205262:	e44e                	sd	s3,8(sp)
ffffffffc0205264:	84aa                	mv	s1,a0
ffffffffc0205266:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0205268:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc020526c:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc020526e:	03067e63          	bgeu	a2,a6,ffffffffc02052aa <printnum+0x60>
ffffffffc0205272:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0205274:	00805763          	blez	s0,ffffffffc0205282 <printnum+0x38>
ffffffffc0205278:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc020527a:	85ca                	mv	a1,s2
ffffffffc020527c:	854e                	mv	a0,s3
ffffffffc020527e:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0205280:	fc65                	bnez	s0,ffffffffc0205278 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205282:	1a02                	slli	s4,s4,0x20
ffffffffc0205284:	00002797          	auipc	a5,0x2
ffffffffc0205288:	2bc78793          	addi	a5,a5,700 # ffffffffc0207540 <syscalls+0x100>
ffffffffc020528c:	020a5a13          	srli	s4,s4,0x20
ffffffffc0205290:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc0205292:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0205294:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0205298:	70a2                	ld	ra,40(sp)
ffffffffc020529a:	69a2                	ld	s3,8(sp)
ffffffffc020529c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc020529e:	85ca                	mv	a1,s2
ffffffffc02052a0:	87a6                	mv	a5,s1
}
ffffffffc02052a2:	6942                	ld	s2,16(sp)
ffffffffc02052a4:	64e2                	ld	s1,24(sp)
ffffffffc02052a6:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02052a8:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02052aa:	03065633          	divu	a2,a2,a6
ffffffffc02052ae:	8722                	mv	a4,s0
ffffffffc02052b0:	f9bff0ef          	jal	ra,ffffffffc020524a <printnum>
ffffffffc02052b4:	b7f9                	j	ffffffffc0205282 <printnum+0x38>

ffffffffc02052b6 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02052b6:	7119                	addi	sp,sp,-128
ffffffffc02052b8:	f4a6                	sd	s1,104(sp)
ffffffffc02052ba:	f0ca                	sd	s2,96(sp)
ffffffffc02052bc:	ecce                	sd	s3,88(sp)
ffffffffc02052be:	e8d2                	sd	s4,80(sp)
ffffffffc02052c0:	e4d6                	sd	s5,72(sp)
ffffffffc02052c2:	e0da                	sd	s6,64(sp)
ffffffffc02052c4:	fc5e                	sd	s7,56(sp)
ffffffffc02052c6:	f06a                	sd	s10,32(sp)
ffffffffc02052c8:	fc86                	sd	ra,120(sp)
ffffffffc02052ca:	f8a2                	sd	s0,112(sp)
ffffffffc02052cc:	f862                	sd	s8,48(sp)
ffffffffc02052ce:	f466                	sd	s9,40(sp)
ffffffffc02052d0:	ec6e                	sd	s11,24(sp)
ffffffffc02052d2:	892a                	mv	s2,a0
ffffffffc02052d4:	84ae                	mv	s1,a1
ffffffffc02052d6:	8d32                	mv	s10,a2
ffffffffc02052d8:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052da:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc02052de:	5b7d                	li	s6,-1
ffffffffc02052e0:	00002a97          	auipc	s5,0x2
ffffffffc02052e4:	28ca8a93          	addi	s5,s5,652 # ffffffffc020756c <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc02052e8:	00002b97          	auipc	s7,0x2
ffffffffc02052ec:	4a0b8b93          	addi	s7,s7,1184 # ffffffffc0207788 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc02052f0:	000d4503          	lbu	a0,0(s10)
ffffffffc02052f4:	001d0413          	addi	s0,s10,1
ffffffffc02052f8:	01350a63          	beq	a0,s3,ffffffffc020530c <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc02052fc:	c121                	beqz	a0,ffffffffc020533c <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc02052fe:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205300:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0205302:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205304:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205308:	ff351ae3          	bne	a0,s3,ffffffffc02052fc <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020530c:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0205310:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0205314:	4c81                	li	s9,0
ffffffffc0205316:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205318:	5c7d                	li	s8,-1
ffffffffc020531a:	5dfd                	li	s11,-1
ffffffffc020531c:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0205320:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205322:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205326:	0ff5f593          	zext.b	a1,a1
ffffffffc020532a:	00140d13          	addi	s10,s0,1
ffffffffc020532e:	04b56263          	bltu	a0,a1,ffffffffc0205372 <vprintfmt+0xbc>
ffffffffc0205332:	058a                	slli	a1,a1,0x2
ffffffffc0205334:	95d6                	add	a1,a1,s5
ffffffffc0205336:	4194                	lw	a3,0(a1)
ffffffffc0205338:	96d6                	add	a3,a3,s5
ffffffffc020533a:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc020533c:	70e6                	ld	ra,120(sp)
ffffffffc020533e:	7446                	ld	s0,112(sp)
ffffffffc0205340:	74a6                	ld	s1,104(sp)
ffffffffc0205342:	7906                	ld	s2,96(sp)
ffffffffc0205344:	69e6                	ld	s3,88(sp)
ffffffffc0205346:	6a46                	ld	s4,80(sp)
ffffffffc0205348:	6aa6                	ld	s5,72(sp)
ffffffffc020534a:	6b06                	ld	s6,64(sp)
ffffffffc020534c:	7be2                	ld	s7,56(sp)
ffffffffc020534e:	7c42                	ld	s8,48(sp)
ffffffffc0205350:	7ca2                	ld	s9,40(sp)
ffffffffc0205352:	7d02                	ld	s10,32(sp)
ffffffffc0205354:	6de2                	ld	s11,24(sp)
ffffffffc0205356:	6109                	addi	sp,sp,128
ffffffffc0205358:	8082                	ret
            padc = '0';
ffffffffc020535a:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc020535c:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205360:	846a                	mv	s0,s10
ffffffffc0205362:	00140d13          	addi	s10,s0,1
ffffffffc0205366:	fdd6059b          	addiw	a1,a2,-35
ffffffffc020536a:	0ff5f593          	zext.b	a1,a1
ffffffffc020536e:	fcb572e3          	bgeu	a0,a1,ffffffffc0205332 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0205372:	85a6                	mv	a1,s1
ffffffffc0205374:	02500513          	li	a0,37
ffffffffc0205378:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc020537a:	fff44783          	lbu	a5,-1(s0)
ffffffffc020537e:	8d22                	mv	s10,s0
ffffffffc0205380:	f73788e3          	beq	a5,s3,ffffffffc02052f0 <vprintfmt+0x3a>
ffffffffc0205384:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0205388:	1d7d                	addi	s10,s10,-1
ffffffffc020538a:	ff379de3          	bne	a5,s3,ffffffffc0205384 <vprintfmt+0xce>
ffffffffc020538e:	b78d                	j	ffffffffc02052f0 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0205390:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0205394:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205398:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc020539a:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc020539e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02053a2:	02d86463          	bltu	a6,a3,ffffffffc02053ca <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02053a6:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02053aa:	002c169b          	slliw	a3,s8,0x2
ffffffffc02053ae:	0186873b          	addw	a4,a3,s8
ffffffffc02053b2:	0017171b          	slliw	a4,a4,0x1
ffffffffc02053b6:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02053b8:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02053bc:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02053be:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02053c2:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02053c6:	fed870e3          	bgeu	a6,a3,ffffffffc02053a6 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc02053ca:	f40ddce3          	bgez	s11,ffffffffc0205322 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc02053ce:	8de2                	mv	s11,s8
ffffffffc02053d0:	5c7d                	li	s8,-1
ffffffffc02053d2:	bf81                	j	ffffffffc0205322 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc02053d4:	fffdc693          	not	a3,s11
ffffffffc02053d8:	96fd                	srai	a3,a3,0x3f
ffffffffc02053da:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053de:	00144603          	lbu	a2,1(s0)
ffffffffc02053e2:	2d81                	sext.w	s11,s11
ffffffffc02053e4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc02053e6:	bf35                	j	ffffffffc0205322 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc02053e8:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053ec:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc02053f0:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053f2:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc02053f4:	bfd9                	j	ffffffffc02053ca <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc02053f6:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc02053f8:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc02053fc:	01174463          	blt	a4,a7,ffffffffc0205404 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0205400:	1a088e63          	beqz	a7,ffffffffc02055bc <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0205404:	000a3603          	ld	a2,0(s4)
ffffffffc0205408:	46c1                	li	a3,16
ffffffffc020540a:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc020540c:	2781                	sext.w	a5,a5
ffffffffc020540e:	876e                	mv	a4,s11
ffffffffc0205410:	85a6                	mv	a1,s1
ffffffffc0205412:	854a                	mv	a0,s2
ffffffffc0205414:	e37ff0ef          	jal	ra,ffffffffc020524a <printnum>
            break;
ffffffffc0205418:	bde1                	j	ffffffffc02052f0 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc020541a:	000a2503          	lw	a0,0(s4)
ffffffffc020541e:	85a6                	mv	a1,s1
ffffffffc0205420:	0a21                	addi	s4,s4,8
ffffffffc0205422:	9902                	jalr	s2
            break;
ffffffffc0205424:	b5f1                	j	ffffffffc02052f0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205426:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205428:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020542c:	01174463          	blt	a4,a7,ffffffffc0205434 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0205430:	18088163          	beqz	a7,ffffffffc02055b2 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0205434:	000a3603          	ld	a2,0(s4)
ffffffffc0205438:	46a9                	li	a3,10
ffffffffc020543a:	8a2e                	mv	s4,a1
ffffffffc020543c:	bfc1                	j	ffffffffc020540c <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020543e:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0205442:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205444:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205446:	bdf1                	j	ffffffffc0205322 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205448:	85a6                	mv	a1,s1
ffffffffc020544a:	02500513          	li	a0,37
ffffffffc020544e:	9902                	jalr	s2
            break;
ffffffffc0205450:	b545                	j	ffffffffc02052f0 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205452:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205456:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205458:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc020545a:	b5e1                	j	ffffffffc0205322 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc020545c:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020545e:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205462:	01174463          	blt	a4,a7,ffffffffc020546a <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0205466:	14088163          	beqz	a7,ffffffffc02055a8 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc020546a:	000a3603          	ld	a2,0(s4)
ffffffffc020546e:	46a1                	li	a3,8
ffffffffc0205470:	8a2e                	mv	s4,a1
ffffffffc0205472:	bf69                	j	ffffffffc020540c <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0205474:	03000513          	li	a0,48
ffffffffc0205478:	85a6                	mv	a1,s1
ffffffffc020547a:	e03e                	sd	a5,0(sp)
ffffffffc020547c:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc020547e:	85a6                	mv	a1,s1
ffffffffc0205480:	07800513          	li	a0,120
ffffffffc0205484:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0205486:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0205488:	6782                	ld	a5,0(sp)
ffffffffc020548a:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc020548c:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0205490:	bfb5                	j	ffffffffc020540c <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205492:	000a3403          	ld	s0,0(s4)
ffffffffc0205496:	008a0713          	addi	a4,s4,8
ffffffffc020549a:	e03a                	sd	a4,0(sp)
ffffffffc020549c:	14040263          	beqz	s0,ffffffffc02055e0 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02054a0:	0fb05763          	blez	s11,ffffffffc020558e <vprintfmt+0x2d8>
ffffffffc02054a4:	02d00693          	li	a3,45
ffffffffc02054a8:	0cd79163          	bne	a5,a3,ffffffffc020556a <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054ac:	00044783          	lbu	a5,0(s0)
ffffffffc02054b0:	0007851b          	sext.w	a0,a5
ffffffffc02054b4:	cf85                	beqz	a5,ffffffffc02054ec <vprintfmt+0x236>
ffffffffc02054b6:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054ba:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054be:	000c4563          	bltz	s8,ffffffffc02054c8 <vprintfmt+0x212>
ffffffffc02054c2:	3c7d                	addiw	s8,s8,-1
ffffffffc02054c4:	036c0263          	beq	s8,s6,ffffffffc02054e8 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc02054c8:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054ca:	0e0c8e63          	beqz	s9,ffffffffc02055c6 <vprintfmt+0x310>
ffffffffc02054ce:	3781                	addiw	a5,a5,-32
ffffffffc02054d0:	0ef47b63          	bgeu	s0,a5,ffffffffc02055c6 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc02054d4:	03f00513          	li	a0,63
ffffffffc02054d8:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054da:	000a4783          	lbu	a5,0(s4)
ffffffffc02054de:	3dfd                	addiw	s11,s11,-1
ffffffffc02054e0:	0a05                	addi	s4,s4,1
ffffffffc02054e2:	0007851b          	sext.w	a0,a5
ffffffffc02054e6:	ffe1                	bnez	a5,ffffffffc02054be <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc02054e8:	01b05963          	blez	s11,ffffffffc02054fa <vprintfmt+0x244>
ffffffffc02054ec:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc02054ee:	85a6                	mv	a1,s1
ffffffffc02054f0:	02000513          	li	a0,32
ffffffffc02054f4:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc02054f6:	fe0d9be3          	bnez	s11,ffffffffc02054ec <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02054fa:	6a02                	ld	s4,0(sp)
ffffffffc02054fc:	bbd5                	j	ffffffffc02052f0 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc02054fe:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205500:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0205504:	01174463          	blt	a4,a7,ffffffffc020550c <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205508:	08088d63          	beqz	a7,ffffffffc02055a2 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc020550c:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0205510:	0a044d63          	bltz	s0,ffffffffc02055ca <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0205514:	8622                	mv	a2,s0
ffffffffc0205516:	8a66                	mv	s4,s9
ffffffffc0205518:	46a9                	li	a3,10
ffffffffc020551a:	bdcd                	j	ffffffffc020540c <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc020551c:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205520:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc0205522:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205524:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205528:	8fb5                	xor	a5,a5,a3
ffffffffc020552a:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020552e:	02d74163          	blt	a4,a3,ffffffffc0205550 <vprintfmt+0x29a>
ffffffffc0205532:	00369793          	slli	a5,a3,0x3
ffffffffc0205536:	97de                	add	a5,a5,s7
ffffffffc0205538:	639c                	ld	a5,0(a5)
ffffffffc020553a:	cb99                	beqz	a5,ffffffffc0205550 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc020553c:	86be                	mv	a3,a5
ffffffffc020553e:	00000617          	auipc	a2,0x0
ffffffffc0205542:	1f260613          	addi	a2,a2,498 # ffffffffc0205730 <etext+0x2c>
ffffffffc0205546:	85a6                	mv	a1,s1
ffffffffc0205548:	854a                	mv	a0,s2
ffffffffc020554a:	0ce000ef          	jal	ra,ffffffffc0205618 <printfmt>
ffffffffc020554e:	b34d                	j	ffffffffc02052f0 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0205550:	00002617          	auipc	a2,0x2
ffffffffc0205554:	01060613          	addi	a2,a2,16 # ffffffffc0207560 <syscalls+0x120>
ffffffffc0205558:	85a6                	mv	a1,s1
ffffffffc020555a:	854a                	mv	a0,s2
ffffffffc020555c:	0bc000ef          	jal	ra,ffffffffc0205618 <printfmt>
ffffffffc0205560:	bb41                	j	ffffffffc02052f0 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0205562:	00002417          	auipc	s0,0x2
ffffffffc0205566:	ff640413          	addi	s0,s0,-10 # ffffffffc0207558 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020556a:	85e2                	mv	a1,s8
ffffffffc020556c:	8522                	mv	a0,s0
ffffffffc020556e:	e43e                	sd	a5,8(sp)
ffffffffc0205570:	0e2000ef          	jal	ra,ffffffffc0205652 <strnlen>
ffffffffc0205574:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0205578:	01b05b63          	blez	s11,ffffffffc020558e <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc020557c:	67a2                	ld	a5,8(sp)
ffffffffc020557e:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0205582:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0205584:	85a6                	mv	a1,s1
ffffffffc0205586:	8552                	mv	a0,s4
ffffffffc0205588:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc020558a:	fe0d9ce3          	bnez	s11,ffffffffc0205582 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc020558e:	00044783          	lbu	a5,0(s0)
ffffffffc0205592:	00140a13          	addi	s4,s0,1
ffffffffc0205596:	0007851b          	sext.w	a0,a5
ffffffffc020559a:	d3a5                	beqz	a5,ffffffffc02054fa <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020559c:	05e00413          	li	s0,94
ffffffffc02055a0:	bf39                	j	ffffffffc02054be <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02055a2:	000a2403          	lw	s0,0(s4)
ffffffffc02055a6:	b7ad                	j	ffffffffc0205510 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02055a8:	000a6603          	lwu	a2,0(s4)
ffffffffc02055ac:	46a1                	li	a3,8
ffffffffc02055ae:	8a2e                	mv	s4,a1
ffffffffc02055b0:	bdb1                	j	ffffffffc020540c <vprintfmt+0x156>
ffffffffc02055b2:	000a6603          	lwu	a2,0(s4)
ffffffffc02055b6:	46a9                	li	a3,10
ffffffffc02055b8:	8a2e                	mv	s4,a1
ffffffffc02055ba:	bd89                	j	ffffffffc020540c <vprintfmt+0x156>
ffffffffc02055bc:	000a6603          	lwu	a2,0(s4)
ffffffffc02055c0:	46c1                	li	a3,16
ffffffffc02055c2:	8a2e                	mv	s4,a1
ffffffffc02055c4:	b5a1                	j	ffffffffc020540c <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc02055c6:	9902                	jalr	s2
ffffffffc02055c8:	bf09                	j	ffffffffc02054da <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc02055ca:	85a6                	mv	a1,s1
ffffffffc02055cc:	02d00513          	li	a0,45
ffffffffc02055d0:	e03e                	sd	a5,0(sp)
ffffffffc02055d2:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc02055d4:	6782                	ld	a5,0(sp)
ffffffffc02055d6:	8a66                	mv	s4,s9
ffffffffc02055d8:	40800633          	neg	a2,s0
ffffffffc02055dc:	46a9                	li	a3,10
ffffffffc02055de:	b53d                	j	ffffffffc020540c <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc02055e0:	03b05163          	blez	s11,ffffffffc0205602 <vprintfmt+0x34c>
ffffffffc02055e4:	02d00693          	li	a3,45
ffffffffc02055e8:	f6d79de3          	bne	a5,a3,ffffffffc0205562 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc02055ec:	00002417          	auipc	s0,0x2
ffffffffc02055f0:	f6c40413          	addi	s0,s0,-148 # ffffffffc0207558 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055f4:	02800793          	li	a5,40
ffffffffc02055f8:	02800513          	li	a0,40
ffffffffc02055fc:	00140a13          	addi	s4,s0,1
ffffffffc0205600:	bd6d                	j	ffffffffc02054ba <vprintfmt+0x204>
ffffffffc0205602:	00002a17          	auipc	s4,0x2
ffffffffc0205606:	f57a0a13          	addi	s4,s4,-169 # ffffffffc0207559 <syscalls+0x119>
ffffffffc020560a:	02800513          	li	a0,40
ffffffffc020560e:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205612:	05e00413          	li	s0,94
ffffffffc0205616:	b565                	j	ffffffffc02054be <vprintfmt+0x208>

ffffffffc0205618 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205618:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc020561a:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020561e:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0205620:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205622:	ec06                	sd	ra,24(sp)
ffffffffc0205624:	f83a                	sd	a4,48(sp)
ffffffffc0205626:	fc3e                	sd	a5,56(sp)
ffffffffc0205628:	e0c2                	sd	a6,64(sp)
ffffffffc020562a:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc020562c:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020562e:	c89ff0ef          	jal	ra,ffffffffc02052b6 <vprintfmt>
}
ffffffffc0205632:	60e2                	ld	ra,24(sp)
ffffffffc0205634:	6161                	addi	sp,sp,80
ffffffffc0205636:	8082                	ret

ffffffffc0205638 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0205638:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc020563c:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc020563e:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0205640:	cb81                	beqz	a5,ffffffffc0205650 <strlen+0x18>
        cnt ++;
ffffffffc0205642:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0205644:	00a707b3          	add	a5,a4,a0
ffffffffc0205648:	0007c783          	lbu	a5,0(a5)
ffffffffc020564c:	fbfd                	bnez	a5,ffffffffc0205642 <strlen+0xa>
ffffffffc020564e:	8082                	ret
    }
    return cnt;
}
ffffffffc0205650:	8082                	ret

ffffffffc0205652 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0205652:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0205654:	e589                	bnez	a1,ffffffffc020565e <strnlen+0xc>
ffffffffc0205656:	a811                	j	ffffffffc020566a <strnlen+0x18>
        cnt ++;
ffffffffc0205658:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc020565a:	00f58863          	beq	a1,a5,ffffffffc020566a <strnlen+0x18>
ffffffffc020565e:	00f50733          	add	a4,a0,a5
ffffffffc0205662:	00074703          	lbu	a4,0(a4)
ffffffffc0205666:	fb6d                	bnez	a4,ffffffffc0205658 <strnlen+0x6>
ffffffffc0205668:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc020566a:	852e                	mv	a0,a1
ffffffffc020566c:	8082                	ret

ffffffffc020566e <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc020566e:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0205670:	0005c703          	lbu	a4,0(a1)
ffffffffc0205674:	0785                	addi	a5,a5,1
ffffffffc0205676:	0585                	addi	a1,a1,1
ffffffffc0205678:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020567c:	fb75                	bnez	a4,ffffffffc0205670 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc020567e:	8082                	ret

ffffffffc0205680 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205680:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205684:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205688:	cb89                	beqz	a5,ffffffffc020569a <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020568a:	0505                	addi	a0,a0,1
ffffffffc020568c:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020568e:	fee789e3          	beq	a5,a4,ffffffffc0205680 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205692:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205696:	9d19                	subw	a0,a0,a4
ffffffffc0205698:	8082                	ret
ffffffffc020569a:	4501                	li	a0,0
ffffffffc020569c:	bfed                	j	ffffffffc0205696 <strcmp+0x16>

ffffffffc020569e <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc020569e:	c20d                	beqz	a2,ffffffffc02056c0 <strncmp+0x22>
ffffffffc02056a0:	962e                	add	a2,a2,a1
ffffffffc02056a2:	a031                	j	ffffffffc02056ae <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc02056a4:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02056a6:	00e79a63          	bne	a5,a4,ffffffffc02056ba <strncmp+0x1c>
ffffffffc02056aa:	00b60b63          	beq	a2,a1,ffffffffc02056c0 <strncmp+0x22>
ffffffffc02056ae:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc02056b2:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc02056b4:	fff5c703          	lbu	a4,-1(a1)
ffffffffc02056b8:	f7f5                	bnez	a5,ffffffffc02056a4 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02056ba:	40e7853b          	subw	a0,a5,a4
}
ffffffffc02056be:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02056c0:	4501                	li	a0,0
ffffffffc02056c2:	8082                	ret

ffffffffc02056c4 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc02056c4:	00054783          	lbu	a5,0(a0)
ffffffffc02056c8:	c799                	beqz	a5,ffffffffc02056d6 <strchr+0x12>
        if (*s == c) {
ffffffffc02056ca:	00f58763          	beq	a1,a5,ffffffffc02056d8 <strchr+0x14>
    while (*s != '\0') {
ffffffffc02056ce:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc02056d2:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc02056d4:	fbfd                	bnez	a5,ffffffffc02056ca <strchr+0x6>
    }
    return NULL;
ffffffffc02056d6:	4501                	li	a0,0
}
ffffffffc02056d8:	8082                	ret

ffffffffc02056da <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc02056da:	ca01                	beqz	a2,ffffffffc02056ea <memset+0x10>
ffffffffc02056dc:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc02056de:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc02056e0:	0785                	addi	a5,a5,1
ffffffffc02056e2:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc02056e6:	fec79de3          	bne	a5,a2,ffffffffc02056e0 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc02056ea:	8082                	ret

ffffffffc02056ec <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc02056ec:	ca19                	beqz	a2,ffffffffc0205702 <memcpy+0x16>
ffffffffc02056ee:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc02056f0:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc02056f2:	0005c703          	lbu	a4,0(a1)
ffffffffc02056f6:	0585                	addi	a1,a1,1
ffffffffc02056f8:	0785                	addi	a5,a5,1
ffffffffc02056fa:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc02056fe:	fec59ae3          	bne	a1,a2,ffffffffc02056f2 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205702:	8082                	ret
