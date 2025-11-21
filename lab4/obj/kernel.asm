
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
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
ffffffffc020003c:	c0208137          	lui	sp,0xc0208

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
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49a60613          	addi	a2,a2,1178 # ffffffffc020d4ec <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	5db030ef          	jal	ra,ffffffffc0203e3c <memset>
    dtb_init();
ffffffffc0200066:	514000ef          	jal	ra,ffffffffc020057a <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	49e000ef          	jal	ra,ffffffffc0200508 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	e2258593          	addi	a1,a1,-478 # ffffffffc0203e90 <etext+0x6>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	e3a50513          	addi	a0,a0,-454 # ffffffffc0203eb0 <etext+0x26>
ffffffffc020007e:	116000ef          	jal	ra,ffffffffc0200194 <cprintf>

    print_kerninfo();
ffffffffc0200082:	15a000ef          	jal	ra,ffffffffc02001dc <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	0d4020ef          	jal	ra,ffffffffc020215a <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	0ad000ef          	jal	ra,ffffffffc0200936 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	0ab000ef          	jal	ra,ffffffffc0200938 <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	63d020ef          	jal	ra,ffffffffc0202ece <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	566030ef          	jal	ra,ffffffffc02035fc <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	41c000ef          	jal	ra,ffffffffc02004b6 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	08d000ef          	jal	ra,ffffffffc020092a <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	7a8030ef          	jal	ra,ffffffffc020384a <cpu_idle>

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
ffffffffc02000bc:	00004517          	auipc	a0,0x4
ffffffffc02000c0:	dfc50513          	addi	a0,a0,-516 # ffffffffc0203eb8 <etext+0x2e>
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
ffffffffc02000d2:	00009b97          	auipc	s7,0x9
ffffffffc02000d6:	f5eb8b93          	addi	s7,s7,-162 # ffffffffc0209030 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000da:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02000de:	0ee000ef          	jal	ra,ffffffffc02001cc <getchar>
        if (c < 0) {
ffffffffc02000e2:	00054a63          	bltz	a0,ffffffffc02000f6 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02000e6:	00a95a63          	bge	s2,a0,ffffffffc02000fa <readline+0x54>
ffffffffc02000ea:	029a5263          	bge	s4,s1,ffffffffc020010e <readline+0x68>
        c = getchar();
ffffffffc02000ee:	0de000ef          	jal	ra,ffffffffc02001cc <getchar>
        if (c < 0) {
ffffffffc02000f2:	fe055ae3          	bgez	a0,ffffffffc02000e6 <readline+0x40>
            return NULL;
ffffffffc02000f6:	4501                	li	a0,0
ffffffffc02000f8:	a091                	j	ffffffffc020013c <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02000fa:	03351463          	bne	a0,s3,ffffffffc0200122 <readline+0x7c>
ffffffffc02000fe:	e8a9                	bnez	s1,ffffffffc0200150 <readline+0xaa>
        c = getchar();
ffffffffc0200100:	0cc000ef          	jal	ra,ffffffffc02001cc <getchar>
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
ffffffffc020012e:	00009517          	auipc	a0,0x9
ffffffffc0200132:	f0250513          	addi	a0,a0,-254 # ffffffffc0209030 <buf>
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
ffffffffc0200162:	3a8000ef          	jal	ra,ffffffffc020050a <cons_putc>
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
ffffffffc0200188:	091030ef          	jal	ra,ffffffffc0203a18 <vprintfmt>
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
ffffffffc0200196:	02810313          	addi	t1,sp,40 # ffffffffc0208028 <boot_page_table_sv39+0x28>
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
ffffffffc02001be:	05b030ef          	jal	ra,ffffffffc0203a18 <vprintfmt>
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
ffffffffc02001ca:	a681                	j	ffffffffc020050a <cons_putc>

ffffffffc02001cc <getchar>:
}

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc02001cc:	1141                	addi	sp,sp,-16
ffffffffc02001ce:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc02001d0:	36e000ef          	jal	ra,ffffffffc020053e <cons_getc>
ffffffffc02001d4:	dd75                	beqz	a0,ffffffffc02001d0 <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc02001d6:	60a2                	ld	ra,8(sp)
ffffffffc02001d8:	0141                	addi	sp,sp,16
ffffffffc02001da:	8082                	ret

ffffffffc02001dc <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc02001dc:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001de:	00004517          	auipc	a0,0x4
ffffffffc02001e2:	ce250513          	addi	a0,a0,-798 # ffffffffc0203ec0 <etext+0x36>
{
ffffffffc02001e6:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001e8:	fadff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02001ec:	00000597          	auipc	a1,0x0
ffffffffc02001f0:	e5e58593          	addi	a1,a1,-418 # ffffffffc020004a <kern_init>
ffffffffc02001f4:	00004517          	auipc	a0,0x4
ffffffffc02001f8:	cec50513          	addi	a0,a0,-788 # ffffffffc0203ee0 <etext+0x56>
ffffffffc02001fc:	f99ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc0200200:	00004597          	auipc	a1,0x4
ffffffffc0200204:	c8a58593          	addi	a1,a1,-886 # ffffffffc0203e8a <etext>
ffffffffc0200208:	00004517          	auipc	a0,0x4
ffffffffc020020c:	cf850513          	addi	a0,a0,-776 # ffffffffc0203f00 <etext+0x76>
ffffffffc0200210:	f85ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200214:	00009597          	auipc	a1,0x9
ffffffffc0200218:	e1c58593          	addi	a1,a1,-484 # ffffffffc0209030 <buf>
ffffffffc020021c:	00004517          	auipc	a0,0x4
ffffffffc0200220:	d0450513          	addi	a0,a0,-764 # ffffffffc0203f20 <etext+0x96>
ffffffffc0200224:	f71ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200228:	0000d597          	auipc	a1,0xd
ffffffffc020022c:	2c458593          	addi	a1,a1,708 # ffffffffc020d4ec <end>
ffffffffc0200230:	00004517          	auipc	a0,0x4
ffffffffc0200234:	d1050513          	addi	a0,a0,-752 # ffffffffc0203f40 <etext+0xb6>
ffffffffc0200238:	f5dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020023c:	0000d597          	auipc	a1,0xd
ffffffffc0200240:	6af58593          	addi	a1,a1,1711 # ffffffffc020d8eb <end+0x3ff>
ffffffffc0200244:	00000797          	auipc	a5,0x0
ffffffffc0200248:	e0678793          	addi	a5,a5,-506 # ffffffffc020004a <kern_init>
ffffffffc020024c:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200250:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200254:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200256:	3ff5f593          	andi	a1,a1,1023
ffffffffc020025a:	95be                	add	a1,a1,a5
ffffffffc020025c:	85a9                	srai	a1,a1,0xa
ffffffffc020025e:	00004517          	auipc	a0,0x4
ffffffffc0200262:	d0250513          	addi	a0,a0,-766 # ffffffffc0203f60 <etext+0xd6>
}
ffffffffc0200266:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200268:	b735                	j	ffffffffc0200194 <cprintf>

ffffffffc020026a <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc020026a:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc020026c:	00004617          	auipc	a2,0x4
ffffffffc0200270:	d2460613          	addi	a2,a2,-732 # ffffffffc0203f90 <etext+0x106>
ffffffffc0200274:	04900593          	li	a1,73
ffffffffc0200278:	00004517          	auipc	a0,0x4
ffffffffc020027c:	d3050513          	addi	a0,a0,-720 # ffffffffc0203fa8 <etext+0x11e>
{
ffffffffc0200280:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200282:	1d8000ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0200286 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200286:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200288:	00004617          	auipc	a2,0x4
ffffffffc020028c:	d3860613          	addi	a2,a2,-712 # ffffffffc0203fc0 <etext+0x136>
ffffffffc0200290:	00004597          	auipc	a1,0x4
ffffffffc0200294:	d5058593          	addi	a1,a1,-688 # ffffffffc0203fe0 <etext+0x156>
ffffffffc0200298:	00004517          	auipc	a0,0x4
ffffffffc020029c:	d5050513          	addi	a0,a0,-688 # ffffffffc0203fe8 <etext+0x15e>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002a0:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002a2:	ef3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002a6:	00004617          	auipc	a2,0x4
ffffffffc02002aa:	d5260613          	addi	a2,a2,-686 # ffffffffc0203ff8 <etext+0x16e>
ffffffffc02002ae:	00004597          	auipc	a1,0x4
ffffffffc02002b2:	d7258593          	addi	a1,a1,-654 # ffffffffc0204020 <etext+0x196>
ffffffffc02002b6:	00004517          	auipc	a0,0x4
ffffffffc02002ba:	d3250513          	addi	a0,a0,-718 # ffffffffc0203fe8 <etext+0x15e>
ffffffffc02002be:	ed7ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc02002c2:	00004617          	auipc	a2,0x4
ffffffffc02002c6:	d6e60613          	addi	a2,a2,-658 # ffffffffc0204030 <etext+0x1a6>
ffffffffc02002ca:	00004597          	auipc	a1,0x4
ffffffffc02002ce:	d8658593          	addi	a1,a1,-634 # ffffffffc0204050 <etext+0x1c6>
ffffffffc02002d2:	00004517          	auipc	a0,0x4
ffffffffc02002d6:	d1650513          	addi	a0,a0,-746 # ffffffffc0203fe8 <etext+0x15e>
ffffffffc02002da:	ebbff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    return 0;
}
ffffffffc02002de:	60a2                	ld	ra,8(sp)
ffffffffc02002e0:	4501                	li	a0,0
ffffffffc02002e2:	0141                	addi	sp,sp,16
ffffffffc02002e4:	8082                	ret

ffffffffc02002e6 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e6:	1141                	addi	sp,sp,-16
ffffffffc02002e8:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002ea:	ef3ff0ef          	jal	ra,ffffffffc02001dc <print_kerninfo>
    return 0;
}
ffffffffc02002ee:	60a2                	ld	ra,8(sp)
ffffffffc02002f0:	4501                	li	a0,0
ffffffffc02002f2:	0141                	addi	sp,sp,16
ffffffffc02002f4:	8082                	ret

ffffffffc02002f6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002f6:	1141                	addi	sp,sp,-16
ffffffffc02002f8:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002fa:	f71ff0ef          	jal	ra,ffffffffc020026a <print_stackframe>
    return 0;
}
ffffffffc02002fe:	60a2                	ld	ra,8(sp)
ffffffffc0200300:	4501                	li	a0,0
ffffffffc0200302:	0141                	addi	sp,sp,16
ffffffffc0200304:	8082                	ret

ffffffffc0200306 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200306:	7115                	addi	sp,sp,-224
ffffffffc0200308:	ed5e                	sd	s7,152(sp)
ffffffffc020030a:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020030c:	00004517          	auipc	a0,0x4
ffffffffc0200310:	d5450513          	addi	a0,a0,-684 # ffffffffc0204060 <etext+0x1d6>
kmonitor(struct trapframe *tf) {
ffffffffc0200314:	ed86                	sd	ra,216(sp)
ffffffffc0200316:	e9a2                	sd	s0,208(sp)
ffffffffc0200318:	e5a6                	sd	s1,200(sp)
ffffffffc020031a:	e1ca                	sd	s2,192(sp)
ffffffffc020031c:	fd4e                	sd	s3,184(sp)
ffffffffc020031e:	f952                	sd	s4,176(sp)
ffffffffc0200320:	f556                	sd	s5,168(sp)
ffffffffc0200322:	f15a                	sd	s6,160(sp)
ffffffffc0200324:	e962                	sd	s8,144(sp)
ffffffffc0200326:	e566                	sd	s9,136(sp)
ffffffffc0200328:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020032a:	e6bff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020032e:	00004517          	auipc	a0,0x4
ffffffffc0200332:	d5a50513          	addi	a0,a0,-678 # ffffffffc0204088 <etext+0x1fe>
ffffffffc0200336:	e5fff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    if (tf != NULL) {
ffffffffc020033a:	000b8563          	beqz	s7,ffffffffc0200344 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020033e:	855e                	mv	a0,s7
ffffffffc0200340:	7e0000ef          	jal	ra,ffffffffc0200b20 <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200344:	4501                	li	a0,0
ffffffffc0200346:	4581                	li	a1,0
ffffffffc0200348:	4601                	li	a2,0
ffffffffc020034a:	48a1                	li	a7,8
ffffffffc020034c:	00000073          	ecall
ffffffffc0200350:	00004c17          	auipc	s8,0x4
ffffffffc0200354:	da8c0c13          	addi	s8,s8,-600 # ffffffffc02040f8 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200358:	00004917          	auipc	s2,0x4
ffffffffc020035c:	d5890913          	addi	s2,s2,-680 # ffffffffc02040b0 <etext+0x226>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200360:	00004497          	auipc	s1,0x4
ffffffffc0200364:	d5848493          	addi	s1,s1,-680 # ffffffffc02040b8 <etext+0x22e>
        if (argc == MAXARGS - 1) {
ffffffffc0200368:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020036a:	00004b17          	auipc	s6,0x4
ffffffffc020036e:	d56b0b13          	addi	s6,s6,-682 # ffffffffc02040c0 <etext+0x236>
        argv[argc ++] = buf;
ffffffffc0200372:	00004a17          	auipc	s4,0x4
ffffffffc0200376:	c6ea0a13          	addi	s4,s4,-914 # ffffffffc0203fe0 <etext+0x156>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020037a:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc020037c:	854a                	mv	a0,s2
ffffffffc020037e:	d29ff0ef          	jal	ra,ffffffffc02000a6 <readline>
ffffffffc0200382:	842a                	mv	s0,a0
ffffffffc0200384:	dd65                	beqz	a0,ffffffffc020037c <kmonitor+0x76>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200386:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020038a:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020038c:	e1bd                	bnez	a1,ffffffffc02003f2 <kmonitor+0xec>
    if (argc == 0) {
ffffffffc020038e:	fe0c87e3          	beqz	s9,ffffffffc020037c <kmonitor+0x76>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	00004d17          	auipc	s10,0x4
ffffffffc0200398:	d64d0d13          	addi	s10,s10,-668 # ffffffffc02040f8 <commands>
        argv[argc ++] = buf;
ffffffffc020039c:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020039e:	4401                	li	s0,0
ffffffffc02003a0:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003a2:	241030ef          	jal	ra,ffffffffc0203de2 <strcmp>
ffffffffc02003a6:	c919                	beqz	a0,ffffffffc02003bc <kmonitor+0xb6>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003a8:	2405                	addiw	s0,s0,1
ffffffffc02003aa:	0b540063          	beq	s0,s5,ffffffffc020044a <kmonitor+0x144>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003ae:	000d3503          	ld	a0,0(s10)
ffffffffc02003b2:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003b4:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003b6:	22d030ef          	jal	ra,ffffffffc0203de2 <strcmp>
ffffffffc02003ba:	f57d                	bnez	a0,ffffffffc02003a8 <kmonitor+0xa2>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc02003bc:	00141793          	slli	a5,s0,0x1
ffffffffc02003c0:	97a2                	add	a5,a5,s0
ffffffffc02003c2:	078e                	slli	a5,a5,0x3
ffffffffc02003c4:	97e2                	add	a5,a5,s8
ffffffffc02003c6:	6b9c                	ld	a5,16(a5)
ffffffffc02003c8:	865e                	mv	a2,s7
ffffffffc02003ca:	002c                	addi	a1,sp,8
ffffffffc02003cc:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003d0:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003d2:	fa0555e3          	bgez	a0,ffffffffc020037c <kmonitor+0x76>
}
ffffffffc02003d6:	60ee                	ld	ra,216(sp)
ffffffffc02003d8:	644e                	ld	s0,208(sp)
ffffffffc02003da:	64ae                	ld	s1,200(sp)
ffffffffc02003dc:	690e                	ld	s2,192(sp)
ffffffffc02003de:	79ea                	ld	s3,184(sp)
ffffffffc02003e0:	7a4a                	ld	s4,176(sp)
ffffffffc02003e2:	7aaa                	ld	s5,168(sp)
ffffffffc02003e4:	7b0a                	ld	s6,160(sp)
ffffffffc02003e6:	6bea                	ld	s7,152(sp)
ffffffffc02003e8:	6c4a                	ld	s8,144(sp)
ffffffffc02003ea:	6caa                	ld	s9,136(sp)
ffffffffc02003ec:	6d0a                	ld	s10,128(sp)
ffffffffc02003ee:	612d                	addi	sp,sp,224
ffffffffc02003f0:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003f2:	8526                	mv	a0,s1
ffffffffc02003f4:	233030ef          	jal	ra,ffffffffc0203e26 <strchr>
ffffffffc02003f8:	c901                	beqz	a0,ffffffffc0200408 <kmonitor+0x102>
ffffffffc02003fa:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003fe:	00040023          	sb	zero,0(s0)
ffffffffc0200402:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200404:	d5c9                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc0200406:	b7f5                	j	ffffffffc02003f2 <kmonitor+0xec>
        if (*buf == '\0') {
ffffffffc0200408:	00044783          	lbu	a5,0(s0)
ffffffffc020040c:	d3c9                	beqz	a5,ffffffffc020038e <kmonitor+0x88>
        if (argc == MAXARGS - 1) {
ffffffffc020040e:	033c8963          	beq	s9,s3,ffffffffc0200440 <kmonitor+0x13a>
        argv[argc ++] = buf;
ffffffffc0200412:	003c9793          	slli	a5,s9,0x3
ffffffffc0200416:	0118                	addi	a4,sp,128
ffffffffc0200418:	97ba                	add	a5,a5,a4
ffffffffc020041a:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020041e:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200422:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200424:	e591                	bnez	a1,ffffffffc0200430 <kmonitor+0x12a>
ffffffffc0200426:	b7b5                	j	ffffffffc0200392 <kmonitor+0x8c>
ffffffffc0200428:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020042c:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020042e:	d1a5                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc0200430:	8526                	mv	a0,s1
ffffffffc0200432:	1f5030ef          	jal	ra,ffffffffc0203e26 <strchr>
ffffffffc0200436:	d96d                	beqz	a0,ffffffffc0200428 <kmonitor+0x122>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200438:	00044583          	lbu	a1,0(s0)
ffffffffc020043c:	d9a9                	beqz	a1,ffffffffc020038e <kmonitor+0x88>
ffffffffc020043e:	bf55                	j	ffffffffc02003f2 <kmonitor+0xec>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200440:	45c1                	li	a1,16
ffffffffc0200442:	855a                	mv	a0,s6
ffffffffc0200444:	d51ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc0200448:	b7e9                	j	ffffffffc0200412 <kmonitor+0x10c>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020044a:	6582                	ld	a1,0(sp)
ffffffffc020044c:	00004517          	auipc	a0,0x4
ffffffffc0200450:	c9450513          	addi	a0,a0,-876 # ffffffffc02040e0 <etext+0x256>
ffffffffc0200454:	d41ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
ffffffffc0200458:	b715                	j	ffffffffc020037c <kmonitor+0x76>

ffffffffc020045a <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc020045a:	0000d317          	auipc	t1,0xd
ffffffffc020045e:	00e30313          	addi	t1,t1,14 # ffffffffc020d468 <is_panic>
ffffffffc0200462:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200466:	715d                	addi	sp,sp,-80
ffffffffc0200468:	ec06                	sd	ra,24(sp)
ffffffffc020046a:	e822                	sd	s0,16(sp)
ffffffffc020046c:	f436                	sd	a3,40(sp)
ffffffffc020046e:	f83a                	sd	a4,48(sp)
ffffffffc0200470:	fc3e                	sd	a5,56(sp)
ffffffffc0200472:	e0c2                	sd	a6,64(sp)
ffffffffc0200474:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200476:	020e1a63          	bnez	t3,ffffffffc02004aa <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020047a:	4785                	li	a5,1
ffffffffc020047c:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200480:	8432                	mv	s0,a2
ffffffffc0200482:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200484:	862e                	mv	a2,a1
ffffffffc0200486:	85aa                	mv	a1,a0
ffffffffc0200488:	00004517          	auipc	a0,0x4
ffffffffc020048c:	cb850513          	addi	a0,a0,-840 # ffffffffc0204140 <commands+0x48>
    va_start(ap, fmt);
ffffffffc0200490:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200492:	d03ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    vcprintf(fmt, ap);
ffffffffc0200496:	65a2                	ld	a1,8(sp)
ffffffffc0200498:	8522                	mv	a0,s0
ffffffffc020049a:	cdbff0ef          	jal	ra,ffffffffc0200174 <vcprintf>
    cprintf("\n");
ffffffffc020049e:	00005517          	auipc	a0,0x5
ffffffffc02004a2:	d5250513          	addi	a0,a0,-686 # ffffffffc02051f0 <default_pmm_manager+0x530>
ffffffffc02004a6:	cefff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc02004aa:	486000ef          	jal	ra,ffffffffc0200930 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02004ae:	4501                	li	a0,0
ffffffffc02004b0:	e57ff0ef          	jal	ra,ffffffffc0200306 <kmonitor>
    while (1) {
ffffffffc02004b4:	bfed                	j	ffffffffc02004ae <__panic+0x54>

ffffffffc02004b6 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02004b6:	67e1                	lui	a5,0x18
ffffffffc02004b8:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02004bc:	0000d717          	auipc	a4,0xd
ffffffffc02004c0:	faf73e23          	sd	a5,-68(a4) # ffffffffc020d478 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004c4:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02004c8:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004ca:	953e                	add	a0,a0,a5
ffffffffc02004cc:	4601                	li	a2,0
ffffffffc02004ce:	4881                	li	a7,0
ffffffffc02004d0:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc02004d4:	02000793          	li	a5,32
ffffffffc02004d8:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc02004dc:	00004517          	auipc	a0,0x4
ffffffffc02004e0:	c8450513          	addi	a0,a0,-892 # ffffffffc0204160 <commands+0x68>
    ticks = 0;
ffffffffc02004e4:	0000d797          	auipc	a5,0xd
ffffffffc02004e8:	f807b623          	sd	zero,-116(a5) # ffffffffc020d470 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc02004ec:	b165                	j	ffffffffc0200194 <cprintf>

ffffffffc02004ee <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02004ee:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02004f2:	0000d797          	auipc	a5,0xd
ffffffffc02004f6:	f867b783          	ld	a5,-122(a5) # ffffffffc020d478 <timebase>
ffffffffc02004fa:	953e                	add	a0,a0,a5
ffffffffc02004fc:	4581                	li	a1,0
ffffffffc02004fe:	4601                	li	a2,0
ffffffffc0200500:	4881                	li	a7,0
ffffffffc0200502:	00000073          	ecall
ffffffffc0200506:	8082                	ret

ffffffffc0200508 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200508:	8082                	ret

ffffffffc020050a <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020050a:	100027f3          	csrr	a5,sstatus
ffffffffc020050e:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200510:	0ff57513          	zext.b	a0,a0
ffffffffc0200514:	e799                	bnez	a5,ffffffffc0200522 <cons_putc+0x18>
ffffffffc0200516:	4581                	li	a1,0
ffffffffc0200518:	4601                	li	a2,0
ffffffffc020051a:	4885                	li	a7,1
ffffffffc020051c:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc0200520:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc0200522:	1101                	addi	sp,sp,-32
ffffffffc0200524:	ec06                	sd	ra,24(sp)
ffffffffc0200526:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200528:	408000ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020052c:	6522                	ld	a0,8(sp)
ffffffffc020052e:	4581                	li	a1,0
ffffffffc0200530:	4601                	li	a2,0
ffffffffc0200532:	4885                	li	a7,1
ffffffffc0200534:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200538:	60e2                	ld	ra,24(sp)
ffffffffc020053a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020053c:	a6fd                	j	ffffffffc020092a <intr_enable>

ffffffffc020053e <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020053e:	100027f3          	csrr	a5,sstatus
ffffffffc0200542:	8b89                	andi	a5,a5,2
ffffffffc0200544:	eb89                	bnez	a5,ffffffffc0200556 <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc0200546:	4501                	li	a0,0
ffffffffc0200548:	4581                	li	a1,0
ffffffffc020054a:	4601                	li	a2,0
ffffffffc020054c:	4889                	li	a7,2
ffffffffc020054e:	00000073          	ecall
ffffffffc0200552:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200554:	8082                	ret
int cons_getc(void) {
ffffffffc0200556:	1101                	addi	sp,sp,-32
ffffffffc0200558:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020055a:	3d6000ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020055e:	4501                	li	a0,0
ffffffffc0200560:	4581                	li	a1,0
ffffffffc0200562:	4601                	li	a2,0
ffffffffc0200564:	4889                	li	a7,2
ffffffffc0200566:	00000073          	ecall
ffffffffc020056a:	2501                	sext.w	a0,a0
ffffffffc020056c:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc020056e:	3bc000ef          	jal	ra,ffffffffc020092a <intr_enable>
}
ffffffffc0200572:	60e2                	ld	ra,24(sp)
ffffffffc0200574:	6522                	ld	a0,8(sp)
ffffffffc0200576:	6105                	addi	sp,sp,32
ffffffffc0200578:	8082                	ret

ffffffffc020057a <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc020057a:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc020057c:	00004517          	auipc	a0,0x4
ffffffffc0200580:	c0450513          	addi	a0,a0,-1020 # ffffffffc0204180 <commands+0x88>
void dtb_init(void) {
ffffffffc0200584:	fc86                	sd	ra,120(sp)
ffffffffc0200586:	f8a2                	sd	s0,112(sp)
ffffffffc0200588:	e8d2                	sd	s4,80(sp)
ffffffffc020058a:	f4a6                	sd	s1,104(sp)
ffffffffc020058c:	f0ca                	sd	s2,96(sp)
ffffffffc020058e:	ecce                	sd	s3,88(sp)
ffffffffc0200590:	e4d6                	sd	s5,72(sp)
ffffffffc0200592:	e0da                	sd	s6,64(sp)
ffffffffc0200594:	fc5e                	sd	s7,56(sp)
ffffffffc0200596:	f862                	sd	s8,48(sp)
ffffffffc0200598:	f466                	sd	s9,40(sp)
ffffffffc020059a:	f06a                	sd	s10,32(sp)
ffffffffc020059c:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc020059e:	bf7ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02005a2:	00009597          	auipc	a1,0x9
ffffffffc02005a6:	a5e5b583          	ld	a1,-1442(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc02005aa:	00004517          	auipc	a0,0x4
ffffffffc02005ae:	be650513          	addi	a0,a0,-1050 # ffffffffc0204190 <commands+0x98>
ffffffffc02005b2:	be3ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02005b6:	00009417          	auipc	s0,0x9
ffffffffc02005ba:	a5240413          	addi	s0,s0,-1454 # ffffffffc0209008 <boot_dtb>
ffffffffc02005be:	600c                	ld	a1,0(s0)
ffffffffc02005c0:	00004517          	auipc	a0,0x4
ffffffffc02005c4:	be050513          	addi	a0,a0,-1056 # ffffffffc02041a0 <commands+0xa8>
ffffffffc02005c8:	bcdff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc02005cc:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc02005d0:	00004517          	auipc	a0,0x4
ffffffffc02005d4:	be850513          	addi	a0,a0,-1048 # ffffffffc02041b8 <commands+0xc0>
    if (boot_dtb == 0) {
ffffffffc02005d8:	120a0463          	beqz	s4,ffffffffc0200700 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc02005dc:	57f5                	li	a5,-3
ffffffffc02005de:	07fa                	slli	a5,a5,0x1e
ffffffffc02005e0:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02005e4:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e6:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ea:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ec:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005f0:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f4:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f8:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005fc:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200600:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200602:	8ec9                	or	a3,a3,a0
ffffffffc0200604:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200608:	1b7d                	addi	s6,s6,-1
ffffffffc020060a:	0167f7b3          	and	a5,a5,s6
ffffffffc020060e:	8dd5                	or	a1,a1,a3
ffffffffc0200610:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200612:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200616:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200618:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed2a01>
ffffffffc020061c:	10f59163          	bne	a1,a5,ffffffffc020071e <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc0200620:	471c                	lw	a5,8(a4)
ffffffffc0200622:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc0200624:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200626:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020062a:	0086d51b          	srliw	a0,a3,0x8
ffffffffc020062e:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200632:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200636:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020063a:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020063e:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200642:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200646:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020064a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020064e:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200650:	01146433          	or	s0,s0,a7
ffffffffc0200654:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200658:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020065c:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020065e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200662:	8c49                	or	s0,s0,a0
ffffffffc0200664:	0166f6b3          	and	a3,a3,s6
ffffffffc0200668:	00ca6a33          	or	s4,s4,a2
ffffffffc020066c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200670:	8c55                	or	s0,s0,a3
ffffffffc0200672:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200676:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200678:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020067a:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020067c:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200680:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200682:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200684:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200688:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020068a:	00004917          	auipc	s2,0x4
ffffffffc020068e:	b7e90913          	addi	s2,s2,-1154 # ffffffffc0204208 <commands+0x110>
ffffffffc0200692:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200694:	4d91                	li	s11,4
ffffffffc0200696:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200698:	00004497          	auipc	s1,0x4
ffffffffc020069c:	b6848493          	addi	s1,s1,-1176 # ffffffffc0204200 <commands+0x108>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006a0:	000a2703          	lw	a4,0(s4)
ffffffffc02006a4:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006a8:	0087569b          	srliw	a3,a4,0x8
ffffffffc02006ac:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b0:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006b4:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b8:	0107571b          	srliw	a4,a4,0x10
ffffffffc02006bc:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006be:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006c2:	0087171b          	slliw	a4,a4,0x8
ffffffffc02006c6:	8fd5                	or	a5,a5,a3
ffffffffc02006c8:	00eb7733          	and	a4,s6,a4
ffffffffc02006cc:	8fd9                	or	a5,a5,a4
ffffffffc02006ce:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc02006d0:	09778c63          	beq	a5,s7,ffffffffc0200768 <dtb_init+0x1ee>
ffffffffc02006d4:	00fbea63          	bltu	s7,a5,ffffffffc02006e8 <dtb_init+0x16e>
ffffffffc02006d8:	07a78663          	beq	a5,s10,ffffffffc0200744 <dtb_init+0x1ca>
ffffffffc02006dc:	4709                	li	a4,2
ffffffffc02006de:	00e79763          	bne	a5,a4,ffffffffc02006ec <dtb_init+0x172>
ffffffffc02006e2:	4c81                	li	s9,0
ffffffffc02006e4:	8a56                	mv	s4,s5
ffffffffc02006e6:	bf6d                	j	ffffffffc02006a0 <dtb_init+0x126>
ffffffffc02006e8:	ffb78ee3          	beq	a5,s11,ffffffffc02006e4 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006ec:	00004517          	auipc	a0,0x4
ffffffffc02006f0:	b9450513          	addi	a0,a0,-1132 # ffffffffc0204280 <commands+0x188>
ffffffffc02006f4:	aa1ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006f8:	00004517          	auipc	a0,0x4
ffffffffc02006fc:	bc050513          	addi	a0,a0,-1088 # ffffffffc02042b8 <commands+0x1c0>
}
ffffffffc0200700:	7446                	ld	s0,112(sp)
ffffffffc0200702:	70e6                	ld	ra,120(sp)
ffffffffc0200704:	74a6                	ld	s1,104(sp)
ffffffffc0200706:	7906                	ld	s2,96(sp)
ffffffffc0200708:	69e6                	ld	s3,88(sp)
ffffffffc020070a:	6a46                	ld	s4,80(sp)
ffffffffc020070c:	6aa6                	ld	s5,72(sp)
ffffffffc020070e:	6b06                	ld	s6,64(sp)
ffffffffc0200710:	7be2                	ld	s7,56(sp)
ffffffffc0200712:	7c42                	ld	s8,48(sp)
ffffffffc0200714:	7ca2                	ld	s9,40(sp)
ffffffffc0200716:	7d02                	ld	s10,32(sp)
ffffffffc0200718:	6de2                	ld	s11,24(sp)
ffffffffc020071a:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020071c:	bca5                	j	ffffffffc0200194 <cprintf>
}
ffffffffc020071e:	7446                	ld	s0,112(sp)
ffffffffc0200720:	70e6                	ld	ra,120(sp)
ffffffffc0200722:	74a6                	ld	s1,104(sp)
ffffffffc0200724:	7906                	ld	s2,96(sp)
ffffffffc0200726:	69e6                	ld	s3,88(sp)
ffffffffc0200728:	6a46                	ld	s4,80(sp)
ffffffffc020072a:	6aa6                	ld	s5,72(sp)
ffffffffc020072c:	6b06                	ld	s6,64(sp)
ffffffffc020072e:	7be2                	ld	s7,56(sp)
ffffffffc0200730:	7c42                	ld	s8,48(sp)
ffffffffc0200732:	7ca2                	ld	s9,40(sp)
ffffffffc0200734:	7d02                	ld	s10,32(sp)
ffffffffc0200736:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200738:	00004517          	auipc	a0,0x4
ffffffffc020073c:	aa050513          	addi	a0,a0,-1376 # ffffffffc02041d8 <commands+0xe0>
}
ffffffffc0200740:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200742:	bc89                	j	ffffffffc0200194 <cprintf>
                int name_len = strlen(name);
ffffffffc0200744:	8556                	mv	a0,s5
ffffffffc0200746:	654030ef          	jal	ra,ffffffffc0203d9a <strlen>
ffffffffc020074a:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020074c:	4619                	li	a2,6
ffffffffc020074e:	85a6                	mv	a1,s1
ffffffffc0200750:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200752:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200754:	6ac030ef          	jal	ra,ffffffffc0203e00 <strncmp>
ffffffffc0200758:	e111                	bnez	a0,ffffffffc020075c <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc020075a:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020075c:	0a91                	addi	s5,s5,4
ffffffffc020075e:	9ad2                	add	s5,s5,s4
ffffffffc0200760:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200764:	8a56                	mv	s4,s5
ffffffffc0200766:	bf2d                	j	ffffffffc02006a0 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200768:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020076c:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200770:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200774:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200778:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020077c:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200780:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200784:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200788:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020078c:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200790:	00eaeab3          	or	s5,s5,a4
ffffffffc0200794:	00fb77b3          	and	a5,s6,a5
ffffffffc0200798:	00faeab3          	or	s5,s5,a5
ffffffffc020079c:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020079e:	000c9c63          	bnez	s9,ffffffffc02007b6 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02007a2:	1a82                	slli	s5,s5,0x20
ffffffffc02007a4:	00368793          	addi	a5,a3,3
ffffffffc02007a8:	020ada93          	srli	s5,s5,0x20
ffffffffc02007ac:	9abe                	add	s5,s5,a5
ffffffffc02007ae:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02007b2:	8a56                	mv	s4,s5
ffffffffc02007b4:	b5f5                	j	ffffffffc02006a0 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02007b6:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007ba:	85ca                	mv	a1,s2
ffffffffc02007bc:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007be:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c2:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c6:	0187971b          	slliw	a4,a5,0x18
ffffffffc02007ca:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007ce:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02007d2:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007d4:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d8:	0087979b          	slliw	a5,a5,0x8
ffffffffc02007dc:	8d59                	or	a0,a0,a4
ffffffffc02007de:	00fb77b3          	and	a5,s6,a5
ffffffffc02007e2:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007e4:	1502                	slli	a0,a0,0x20
ffffffffc02007e6:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007e8:	9522                	add	a0,a0,s0
ffffffffc02007ea:	5f8030ef          	jal	ra,ffffffffc0203de2 <strcmp>
ffffffffc02007ee:	66a2                	ld	a3,8(sp)
ffffffffc02007f0:	f94d                	bnez	a0,ffffffffc02007a2 <dtb_init+0x228>
ffffffffc02007f2:	fb59f8e3          	bgeu	s3,s5,ffffffffc02007a2 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007f6:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007fa:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007fe:	00004517          	auipc	a0,0x4
ffffffffc0200802:	a1250513          	addi	a0,a0,-1518 # ffffffffc0204210 <commands+0x118>
           fdt32_to_cpu(x >> 32);
ffffffffc0200806:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080a:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020080e:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200812:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200816:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020081a:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020081e:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200822:	0187d693          	srli	a3,a5,0x18
ffffffffc0200826:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020082a:	0087579b          	srliw	a5,a4,0x8
ffffffffc020082e:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200832:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200836:	010f6f33          	or	t5,t5,a6
ffffffffc020083a:	0187529b          	srliw	t0,a4,0x18
ffffffffc020083e:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200842:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200846:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020084a:	0186f6b3          	and	a3,a3,s8
ffffffffc020084e:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200852:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200856:	0107581b          	srliw	a6,a4,0x10
ffffffffc020085a:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020085e:	8361                	srli	a4,a4,0x18
ffffffffc0200860:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200864:	0105d59b          	srliw	a1,a1,0x10
ffffffffc0200868:	01e6e6b3          	or	a3,a3,t5
ffffffffc020086c:	00cb7633          	and	a2,s6,a2
ffffffffc0200870:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200874:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200878:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020087c:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200880:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200884:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200888:	0088989b          	slliw	a7,a7,0x8
ffffffffc020088c:	011b78b3          	and	a7,s6,a7
ffffffffc0200890:	005eeeb3          	or	t4,t4,t0
ffffffffc0200894:	00c6e733          	or	a4,a3,a2
ffffffffc0200898:	006c6c33          	or	s8,s8,t1
ffffffffc020089c:	010b76b3          	and	a3,s6,a6
ffffffffc02008a0:	00bb7b33          	and	s6,s6,a1
ffffffffc02008a4:	01d7e7b3          	or	a5,a5,t4
ffffffffc02008a8:	016c6b33          	or	s6,s8,s6
ffffffffc02008ac:	01146433          	or	s0,s0,a7
ffffffffc02008b0:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc02008b2:	1702                	slli	a4,a4,0x20
ffffffffc02008b4:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02008b6:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02008b8:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02008ba:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02008bc:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02008c0:	0167eb33          	or	s6,a5,s6
ffffffffc02008c4:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc02008c6:	8cfff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc02008ca:	85a2                	mv	a1,s0
ffffffffc02008cc:	00004517          	auipc	a0,0x4
ffffffffc02008d0:	96450513          	addi	a0,a0,-1692 # ffffffffc0204230 <commands+0x138>
ffffffffc02008d4:	8c1ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc02008d8:	014b5613          	srli	a2,s6,0x14
ffffffffc02008dc:	85da                	mv	a1,s6
ffffffffc02008de:	00004517          	auipc	a0,0x4
ffffffffc02008e2:	96a50513          	addi	a0,a0,-1686 # ffffffffc0204248 <commands+0x150>
ffffffffc02008e6:	8afff0ef          	jal	ra,ffffffffc0200194 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008ea:	008b05b3          	add	a1,s6,s0
ffffffffc02008ee:	15fd                	addi	a1,a1,-1
ffffffffc02008f0:	00004517          	auipc	a0,0x4
ffffffffc02008f4:	97850513          	addi	a0,a0,-1672 # ffffffffc0204268 <commands+0x170>
ffffffffc02008f8:	89dff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02008fc:	00004517          	auipc	a0,0x4
ffffffffc0200900:	9bc50513          	addi	a0,a0,-1604 # ffffffffc02042b8 <commands+0x1c0>
        memory_base = mem_base;
ffffffffc0200904:	0000d797          	auipc	a5,0xd
ffffffffc0200908:	b687be23          	sd	s0,-1156(a5) # ffffffffc020d480 <memory_base>
        memory_size = mem_size;
ffffffffc020090c:	0000d797          	auipc	a5,0xd
ffffffffc0200910:	b767be23          	sd	s6,-1156(a5) # ffffffffc020d488 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200914:	b3f5                	j	ffffffffc0200700 <dtb_init+0x186>

ffffffffc0200916 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200916:	0000d517          	auipc	a0,0xd
ffffffffc020091a:	b6a53503          	ld	a0,-1174(a0) # ffffffffc020d480 <memory_base>
ffffffffc020091e:	8082                	ret

ffffffffc0200920 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc0200920:	0000d517          	auipc	a0,0xd
ffffffffc0200924:	b6853503          	ld	a0,-1176(a0) # ffffffffc020d488 <memory_size>
ffffffffc0200928:	8082                	ret

ffffffffc020092a <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc020092a:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020092e:	8082                	ret

ffffffffc0200930 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200930:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200934:	8082                	ret

ffffffffc0200936 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc0200936:	8082                	ret

ffffffffc0200938 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200938:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc020093c:	00000797          	auipc	a5,0x0
ffffffffc0200940:	3e478793          	addi	a5,a5,996 # ffffffffc0200d20 <__alltraps>
ffffffffc0200944:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc0200948:	000407b7          	lui	a5,0x40
ffffffffc020094c:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200950:	8082                	ret

ffffffffc0200952 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200952:	610c                	ld	a1,0(a0)
{
ffffffffc0200954:	1141                	addi	sp,sp,-16
ffffffffc0200956:	e022                	sd	s0,0(sp)
ffffffffc0200958:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020095a:	00004517          	auipc	a0,0x4
ffffffffc020095e:	97650513          	addi	a0,a0,-1674 # ffffffffc02042d0 <commands+0x1d8>
{
ffffffffc0200962:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200964:	831ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc0200968:	640c                	ld	a1,8(s0)
ffffffffc020096a:	00004517          	auipc	a0,0x4
ffffffffc020096e:	97e50513          	addi	a0,a0,-1666 # ffffffffc02042e8 <commands+0x1f0>
ffffffffc0200972:	823ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200976:	680c                	ld	a1,16(s0)
ffffffffc0200978:	00004517          	auipc	a0,0x4
ffffffffc020097c:	98850513          	addi	a0,a0,-1656 # ffffffffc0204300 <commands+0x208>
ffffffffc0200980:	815ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200984:	6c0c                	ld	a1,24(s0)
ffffffffc0200986:	00004517          	auipc	a0,0x4
ffffffffc020098a:	99250513          	addi	a0,a0,-1646 # ffffffffc0204318 <commands+0x220>
ffffffffc020098e:	807ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200992:	700c                	ld	a1,32(s0)
ffffffffc0200994:	00004517          	auipc	a0,0x4
ffffffffc0200998:	99c50513          	addi	a0,a0,-1636 # ffffffffc0204330 <commands+0x238>
ffffffffc020099c:	ff8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02009a0:	740c                	ld	a1,40(s0)
ffffffffc02009a2:	00004517          	auipc	a0,0x4
ffffffffc02009a6:	9a650513          	addi	a0,a0,-1626 # ffffffffc0204348 <commands+0x250>
ffffffffc02009aa:	feaff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02009ae:	780c                	ld	a1,48(s0)
ffffffffc02009b0:	00004517          	auipc	a0,0x4
ffffffffc02009b4:	9b050513          	addi	a0,a0,-1616 # ffffffffc0204360 <commands+0x268>
ffffffffc02009b8:	fdcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02009bc:	7c0c                	ld	a1,56(s0)
ffffffffc02009be:	00004517          	auipc	a0,0x4
ffffffffc02009c2:	9ba50513          	addi	a0,a0,-1606 # ffffffffc0204378 <commands+0x280>
ffffffffc02009c6:	fceff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02009ca:	602c                	ld	a1,64(s0)
ffffffffc02009cc:	00004517          	auipc	a0,0x4
ffffffffc02009d0:	9c450513          	addi	a0,a0,-1596 # ffffffffc0204390 <commands+0x298>
ffffffffc02009d4:	fc0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009d8:	642c                	ld	a1,72(s0)
ffffffffc02009da:	00004517          	auipc	a0,0x4
ffffffffc02009de:	9ce50513          	addi	a0,a0,-1586 # ffffffffc02043a8 <commands+0x2b0>
ffffffffc02009e2:	fb2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009e6:	682c                	ld	a1,80(s0)
ffffffffc02009e8:	00004517          	auipc	a0,0x4
ffffffffc02009ec:	9d850513          	addi	a0,a0,-1576 # ffffffffc02043c0 <commands+0x2c8>
ffffffffc02009f0:	fa4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009f4:	6c2c                	ld	a1,88(s0)
ffffffffc02009f6:	00004517          	auipc	a0,0x4
ffffffffc02009fa:	9e250513          	addi	a0,a0,-1566 # ffffffffc02043d8 <commands+0x2e0>
ffffffffc02009fe:	f96ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a02:	702c                	ld	a1,96(s0)
ffffffffc0200a04:	00004517          	auipc	a0,0x4
ffffffffc0200a08:	9ec50513          	addi	a0,a0,-1556 # ffffffffc02043f0 <commands+0x2f8>
ffffffffc0200a0c:	f88ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a10:	742c                	ld	a1,104(s0)
ffffffffc0200a12:	00004517          	auipc	a0,0x4
ffffffffc0200a16:	9f650513          	addi	a0,a0,-1546 # ffffffffc0204408 <commands+0x310>
ffffffffc0200a1a:	f7aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a1e:	782c                	ld	a1,112(s0)
ffffffffc0200a20:	00004517          	auipc	a0,0x4
ffffffffc0200a24:	a0050513          	addi	a0,a0,-1536 # ffffffffc0204420 <commands+0x328>
ffffffffc0200a28:	f6cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a2c:	7c2c                	ld	a1,120(s0)
ffffffffc0200a2e:	00004517          	auipc	a0,0x4
ffffffffc0200a32:	a0a50513          	addi	a0,a0,-1526 # ffffffffc0204438 <commands+0x340>
ffffffffc0200a36:	f5eff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a3a:	604c                	ld	a1,128(s0)
ffffffffc0200a3c:	00004517          	auipc	a0,0x4
ffffffffc0200a40:	a1450513          	addi	a0,a0,-1516 # ffffffffc0204450 <commands+0x358>
ffffffffc0200a44:	f50ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a48:	644c                	ld	a1,136(s0)
ffffffffc0200a4a:	00004517          	auipc	a0,0x4
ffffffffc0200a4e:	a1e50513          	addi	a0,a0,-1506 # ffffffffc0204468 <commands+0x370>
ffffffffc0200a52:	f42ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a56:	684c                	ld	a1,144(s0)
ffffffffc0200a58:	00004517          	auipc	a0,0x4
ffffffffc0200a5c:	a2850513          	addi	a0,a0,-1496 # ffffffffc0204480 <commands+0x388>
ffffffffc0200a60:	f34ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a64:	6c4c                	ld	a1,152(s0)
ffffffffc0200a66:	00004517          	auipc	a0,0x4
ffffffffc0200a6a:	a3250513          	addi	a0,a0,-1486 # ffffffffc0204498 <commands+0x3a0>
ffffffffc0200a6e:	f26ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a72:	704c                	ld	a1,160(s0)
ffffffffc0200a74:	00004517          	auipc	a0,0x4
ffffffffc0200a78:	a3c50513          	addi	a0,a0,-1476 # ffffffffc02044b0 <commands+0x3b8>
ffffffffc0200a7c:	f18ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a80:	744c                	ld	a1,168(s0)
ffffffffc0200a82:	00004517          	auipc	a0,0x4
ffffffffc0200a86:	a4650513          	addi	a0,a0,-1466 # ffffffffc02044c8 <commands+0x3d0>
ffffffffc0200a8a:	f0aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a8e:	784c                	ld	a1,176(s0)
ffffffffc0200a90:	00004517          	auipc	a0,0x4
ffffffffc0200a94:	a5050513          	addi	a0,a0,-1456 # ffffffffc02044e0 <commands+0x3e8>
ffffffffc0200a98:	efcff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200a9c:	7c4c                	ld	a1,184(s0)
ffffffffc0200a9e:	00004517          	auipc	a0,0x4
ffffffffc0200aa2:	a5a50513          	addi	a0,a0,-1446 # ffffffffc02044f8 <commands+0x400>
ffffffffc0200aa6:	eeeff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200aaa:	606c                	ld	a1,192(s0)
ffffffffc0200aac:	00004517          	auipc	a0,0x4
ffffffffc0200ab0:	a6450513          	addi	a0,a0,-1436 # ffffffffc0204510 <commands+0x418>
ffffffffc0200ab4:	ee0ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200ab8:	646c                	ld	a1,200(s0)
ffffffffc0200aba:	00004517          	auipc	a0,0x4
ffffffffc0200abe:	a6e50513          	addi	a0,a0,-1426 # ffffffffc0204528 <commands+0x430>
ffffffffc0200ac2:	ed2ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200ac6:	686c                	ld	a1,208(s0)
ffffffffc0200ac8:	00004517          	auipc	a0,0x4
ffffffffc0200acc:	a7850513          	addi	a0,a0,-1416 # ffffffffc0204540 <commands+0x448>
ffffffffc0200ad0:	ec4ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200ad4:	6c6c                	ld	a1,216(s0)
ffffffffc0200ad6:	00004517          	auipc	a0,0x4
ffffffffc0200ada:	a8250513          	addi	a0,a0,-1406 # ffffffffc0204558 <commands+0x460>
ffffffffc0200ade:	eb6ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ae2:	706c                	ld	a1,224(s0)
ffffffffc0200ae4:	00004517          	auipc	a0,0x4
ffffffffc0200ae8:	a8c50513          	addi	a0,a0,-1396 # ffffffffc0204570 <commands+0x478>
ffffffffc0200aec:	ea8ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200af0:	746c                	ld	a1,232(s0)
ffffffffc0200af2:	00004517          	auipc	a0,0x4
ffffffffc0200af6:	a9650513          	addi	a0,a0,-1386 # ffffffffc0204588 <commands+0x490>
ffffffffc0200afa:	e9aff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200afe:	786c                	ld	a1,240(s0)
ffffffffc0200b00:	00004517          	auipc	a0,0x4
ffffffffc0200b04:	aa050513          	addi	a0,a0,-1376 # ffffffffc02045a0 <commands+0x4a8>
ffffffffc0200b08:	e8cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b0c:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b0e:	6402                	ld	s0,0(sp)
ffffffffc0200b10:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b12:	00004517          	auipc	a0,0x4
ffffffffc0200b16:	aa650513          	addi	a0,a0,-1370 # ffffffffc02045b8 <commands+0x4c0>
}
ffffffffc0200b1a:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b1c:	e78ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b20 <print_trapframe>:
{
ffffffffc0200b20:	1141                	addi	sp,sp,-16
ffffffffc0200b22:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b24:	85aa                	mv	a1,a0
{
ffffffffc0200b26:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b28:	00004517          	auipc	a0,0x4
ffffffffc0200b2c:	aa850513          	addi	a0,a0,-1368 # ffffffffc02045d0 <commands+0x4d8>
{
ffffffffc0200b30:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b32:	e62ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b36:	8522                	mv	a0,s0
ffffffffc0200b38:	e1bff0ef          	jal	ra,ffffffffc0200952 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b3c:	10043583          	ld	a1,256(s0)
ffffffffc0200b40:	00004517          	auipc	a0,0x4
ffffffffc0200b44:	aa850513          	addi	a0,a0,-1368 # ffffffffc02045e8 <commands+0x4f0>
ffffffffc0200b48:	e4cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b4c:	10843583          	ld	a1,264(s0)
ffffffffc0200b50:	00004517          	auipc	a0,0x4
ffffffffc0200b54:	ab050513          	addi	a0,a0,-1360 # ffffffffc0204600 <commands+0x508>
ffffffffc0200b58:	e3cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200b5c:	11043583          	ld	a1,272(s0)
ffffffffc0200b60:	00004517          	auipc	a0,0x4
ffffffffc0200b64:	ab850513          	addi	a0,a0,-1352 # ffffffffc0204618 <commands+0x520>
ffffffffc0200b68:	e2cff0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b6c:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b70:	6402                	ld	s0,0(sp)
ffffffffc0200b72:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b74:	00004517          	auipc	a0,0x4
ffffffffc0200b78:	abc50513          	addi	a0,a0,-1348 # ffffffffc0204630 <commands+0x538>
}
ffffffffc0200b7c:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b7e:	e16ff06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0200b82 <interrupt_handler>:

volatile size_t num = 0;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200b82:	11853783          	ld	a5,280(a0)
ffffffffc0200b86:	472d                	li	a4,11
ffffffffc0200b88:	0786                	slli	a5,a5,0x1
ffffffffc0200b8a:	8385                	srli	a5,a5,0x1
ffffffffc0200b8c:	06f76c63          	bltu	a4,a5,ffffffffc0200c04 <interrupt_handler+0x82>
ffffffffc0200b90:	00004717          	auipc	a4,0x4
ffffffffc0200b94:	b6870713          	addi	a4,a4,-1176 # ffffffffc02046f8 <commands+0x600>
ffffffffc0200b98:	078a                	slli	a5,a5,0x2
ffffffffc0200b9a:	97ba                	add	a5,a5,a4
ffffffffc0200b9c:	439c                	lw	a5,0(a5)
ffffffffc0200b9e:	97ba                	add	a5,a5,a4
ffffffffc0200ba0:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200ba2:	00004517          	auipc	a0,0x4
ffffffffc0200ba6:	b0650513          	addi	a0,a0,-1274 # ffffffffc02046a8 <commands+0x5b0>
ffffffffc0200baa:	deaff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200bae:	00004517          	auipc	a0,0x4
ffffffffc0200bb2:	ada50513          	addi	a0,a0,-1318 # ffffffffc0204688 <commands+0x590>
ffffffffc0200bb6:	ddeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200bba:	00004517          	auipc	a0,0x4
ffffffffc0200bbe:	a8e50513          	addi	a0,a0,-1394 # ffffffffc0204648 <commands+0x550>
ffffffffc0200bc2:	dd2ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200bc6:	00004517          	auipc	a0,0x4
ffffffffc0200bca:	aa250513          	addi	a0,a0,-1374 # ffffffffc0204668 <commands+0x570>
ffffffffc0200bce:	dc6ff06f          	j	ffffffffc0200194 <cprintf>
{
ffffffffc0200bd2:	1141                	addi	sp,sp,-16
ffffffffc0200bd4:	e406                	sd	ra,8(sp)
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // clear_csr(sip, SIP_STIP);

        /*LAB3 请补充你在lab3中的代码 */
        clock_set_next_event();
ffffffffc0200bd6:	919ff0ef          	jal	ra,ffffffffc02004ee <clock_set_next_event>
        ticks++;
ffffffffc0200bda:	0000d797          	auipc	a5,0xd
ffffffffc0200bde:	89678793          	addi	a5,a5,-1898 # ffffffffc020d470 <ticks>
ffffffffc0200be2:	6398                	ld	a4,0(a5)
        if (ticks == TICK_NUM)
ffffffffc0200be4:	06400693          	li	a3,100
        ticks++;
ffffffffc0200be8:	0705                	addi	a4,a4,1
ffffffffc0200bea:	e398                	sd	a4,0(a5)
        if (ticks == TICK_NUM)
ffffffffc0200bec:	639c                	ld	a5,0(a5)
ffffffffc0200bee:	00d78c63          	beq	a5,a3,ffffffffc0200c06 <interrupt_handler+0x84>
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200bf2:	60a2                	ld	ra,8(sp)
ffffffffc0200bf4:	0141                	addi	sp,sp,16
ffffffffc0200bf6:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200bf8:	00004517          	auipc	a0,0x4
ffffffffc0200bfc:	ae050513          	addi	a0,a0,-1312 # ffffffffc02046d8 <commands+0x5e0>
ffffffffc0200c00:	d94ff06f          	j	ffffffffc0200194 <cprintf>
        print_trapframe(tf);
ffffffffc0200c04:	bf31                	j	ffffffffc0200b20 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c06:	06400593          	li	a1,100
ffffffffc0200c0a:	00004517          	auipc	a0,0x4
ffffffffc0200c0e:	abe50513          	addi	a0,a0,-1346 # ffffffffc02046c8 <commands+0x5d0>
ffffffffc0200c12:	d82ff0ef          	jal	ra,ffffffffc0200194 <cprintf>
            ticks = 0;
ffffffffc0200c16:	0000d797          	auipc	a5,0xd
ffffffffc0200c1a:	8407bd23          	sd	zero,-1958(a5) # ffffffffc020d470 <ticks>
            num++;
ffffffffc0200c1e:	0000d797          	auipc	a5,0xd
ffffffffc0200c22:	87278793          	addi	a5,a5,-1934 # ffffffffc020d490 <num>
ffffffffc0200c26:	6398                	ld	a4,0(a5)
            if (num == 10)
ffffffffc0200c28:	46a9                	li	a3,10
            num++;
ffffffffc0200c2a:	0705                	addi	a4,a4,1
ffffffffc0200c2c:	e398                	sd	a4,0(a5)
            if (num == 10)
ffffffffc0200c2e:	639c                	ld	a5,0(a5)
ffffffffc0200c30:	fcd791e3          	bne	a5,a3,ffffffffc0200bf2 <interrupt_handler+0x70>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c34:	4501                	li	a0,0
ffffffffc0200c36:	4581                	li	a1,0
ffffffffc0200c38:	4601                	li	a2,0
ffffffffc0200c3a:	48a1                	li	a7,8
ffffffffc0200c3c:	00000073          	ecall
}
ffffffffc0200c40:	bf4d                	j	ffffffffc0200bf2 <interrupt_handler+0x70>

ffffffffc0200c42 <exception_handler>:

void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c42:	11853783          	ld	a5,280(a0)
ffffffffc0200c46:	473d                	li	a4,15
ffffffffc0200c48:	0cf76563          	bltu	a4,a5,ffffffffc0200d12 <exception_handler+0xd0>
ffffffffc0200c4c:	00004717          	auipc	a4,0x4
ffffffffc0200c50:	c7470713          	addi	a4,a4,-908 # ffffffffc02048c0 <commands+0x7c8>
ffffffffc0200c54:	078a                	slli	a5,a5,0x2
ffffffffc0200c56:	97ba                	add	a5,a5,a4
ffffffffc0200c58:	439c                	lw	a5,0(a5)
ffffffffc0200c5a:	97ba                	add	a5,a5,a4
ffffffffc0200c5c:	8782                	jr	a5
        break;
    case CAUSE_LOAD_PAGE_FAULT:
        cprintf("Load page fault\n");
        break;
    case CAUSE_STORE_PAGE_FAULT:
        cprintf("Store/AMO page fault\n");
ffffffffc0200c5e:	00004517          	auipc	a0,0x4
ffffffffc0200c62:	c4a50513          	addi	a0,a0,-950 # ffffffffc02048a8 <commands+0x7b0>
ffffffffc0200c66:	d2eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Instruction address misaligned\n");
ffffffffc0200c6a:	00004517          	auipc	a0,0x4
ffffffffc0200c6e:	abe50513          	addi	a0,a0,-1346 # ffffffffc0204728 <commands+0x630>
ffffffffc0200c72:	d22ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Instruction access fault\n");
ffffffffc0200c76:	00004517          	auipc	a0,0x4
ffffffffc0200c7a:	ad250513          	addi	a0,a0,-1326 # ffffffffc0204748 <commands+0x650>
ffffffffc0200c7e:	d16ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Illegal instruction\n");
ffffffffc0200c82:	00004517          	auipc	a0,0x4
ffffffffc0200c86:	ae650513          	addi	a0,a0,-1306 # ffffffffc0204768 <commands+0x670>
ffffffffc0200c8a:	d0aff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Breakpoint\n");
ffffffffc0200c8e:	00004517          	auipc	a0,0x4
ffffffffc0200c92:	af250513          	addi	a0,a0,-1294 # ffffffffc0204780 <commands+0x688>
ffffffffc0200c96:	cfeff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Load address misaligned\n");
ffffffffc0200c9a:	00004517          	auipc	a0,0x4
ffffffffc0200c9e:	af650513          	addi	a0,a0,-1290 # ffffffffc0204790 <commands+0x698>
ffffffffc0200ca2:	cf2ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Load access fault\n");
ffffffffc0200ca6:	00004517          	auipc	a0,0x4
ffffffffc0200caa:	b0a50513          	addi	a0,a0,-1270 # ffffffffc02047b0 <commands+0x6b8>
ffffffffc0200cae:	ce6ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("AMO address misaligned\n");
ffffffffc0200cb2:	00004517          	auipc	a0,0x4
ffffffffc0200cb6:	b1650513          	addi	a0,a0,-1258 # ffffffffc02047c8 <commands+0x6d0>
ffffffffc0200cba:	cdaff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Store/AMO access fault\n");
ffffffffc0200cbe:	00004517          	auipc	a0,0x4
ffffffffc0200cc2:	b2250513          	addi	a0,a0,-1246 # ffffffffc02047e0 <commands+0x6e8>
ffffffffc0200cc6:	cceff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from U-mode\n");
ffffffffc0200cca:	00004517          	auipc	a0,0x4
ffffffffc0200cce:	b2e50513          	addi	a0,a0,-1234 # ffffffffc02047f8 <commands+0x700>
ffffffffc0200cd2:	cc2ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from S-mode\n");
ffffffffc0200cd6:	00004517          	auipc	a0,0x4
ffffffffc0200cda:	b4250513          	addi	a0,a0,-1214 # ffffffffc0204818 <commands+0x720>
ffffffffc0200cde:	cb6ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from H-mode\n");
ffffffffc0200ce2:	00004517          	auipc	a0,0x4
ffffffffc0200ce6:	b5650513          	addi	a0,a0,-1194 # ffffffffc0204838 <commands+0x740>
ffffffffc0200cea:	caaff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200cee:	00004517          	auipc	a0,0x4
ffffffffc0200cf2:	b6a50513          	addi	a0,a0,-1174 # ffffffffc0204858 <commands+0x760>
ffffffffc0200cf6:	c9eff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Instruction page fault\n");
ffffffffc0200cfa:	00004517          	auipc	a0,0x4
ffffffffc0200cfe:	b7e50513          	addi	a0,a0,-1154 # ffffffffc0204878 <commands+0x780>
ffffffffc0200d02:	c92ff06f          	j	ffffffffc0200194 <cprintf>
        cprintf("Load page fault\n");
ffffffffc0200d06:	00004517          	auipc	a0,0x4
ffffffffc0200d0a:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0204890 <commands+0x798>
ffffffffc0200d0e:	c86ff06f          	j	ffffffffc0200194 <cprintf>
        break;
    default:
        print_trapframe(tf);
ffffffffc0200d12:	b539                	j	ffffffffc0200b20 <print_trapframe>

ffffffffc0200d14 <trap>:
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d14:	11853783          	ld	a5,280(a0)
ffffffffc0200d18:	0007c363          	bltz	a5,ffffffffc0200d1e <trap+0xa>
        interrupt_handler(tf);
    }
    else
    {
        // exceptions
        exception_handler(tf);
ffffffffc0200d1c:	b71d                	j	ffffffffc0200c42 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200d1e:	b595                	j	ffffffffc0200b82 <interrupt_handler>

ffffffffc0200d20 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200d20:	14011073          	csrw	sscratch,sp
ffffffffc0200d24:	712d                	addi	sp,sp,-288
ffffffffc0200d26:	e406                	sd	ra,8(sp)
ffffffffc0200d28:	ec0e                	sd	gp,24(sp)
ffffffffc0200d2a:	f012                	sd	tp,32(sp)
ffffffffc0200d2c:	f416                	sd	t0,40(sp)
ffffffffc0200d2e:	f81a                	sd	t1,48(sp)
ffffffffc0200d30:	fc1e                	sd	t2,56(sp)
ffffffffc0200d32:	e0a2                	sd	s0,64(sp)
ffffffffc0200d34:	e4a6                	sd	s1,72(sp)
ffffffffc0200d36:	e8aa                	sd	a0,80(sp)
ffffffffc0200d38:	ecae                	sd	a1,88(sp)
ffffffffc0200d3a:	f0b2                	sd	a2,96(sp)
ffffffffc0200d3c:	f4b6                	sd	a3,104(sp)
ffffffffc0200d3e:	f8ba                	sd	a4,112(sp)
ffffffffc0200d40:	fcbe                	sd	a5,120(sp)
ffffffffc0200d42:	e142                	sd	a6,128(sp)
ffffffffc0200d44:	e546                	sd	a7,136(sp)
ffffffffc0200d46:	e94a                	sd	s2,144(sp)
ffffffffc0200d48:	ed4e                	sd	s3,152(sp)
ffffffffc0200d4a:	f152                	sd	s4,160(sp)
ffffffffc0200d4c:	f556                	sd	s5,168(sp)
ffffffffc0200d4e:	f95a                	sd	s6,176(sp)
ffffffffc0200d50:	fd5e                	sd	s7,184(sp)
ffffffffc0200d52:	e1e2                	sd	s8,192(sp)
ffffffffc0200d54:	e5e6                	sd	s9,200(sp)
ffffffffc0200d56:	e9ea                	sd	s10,208(sp)
ffffffffc0200d58:	edee                	sd	s11,216(sp)
ffffffffc0200d5a:	f1f2                	sd	t3,224(sp)
ffffffffc0200d5c:	f5f6                	sd	t4,232(sp)
ffffffffc0200d5e:	f9fa                	sd	t5,240(sp)
ffffffffc0200d60:	fdfe                	sd	t6,248(sp)
ffffffffc0200d62:	14002473          	csrr	s0,sscratch
ffffffffc0200d66:	100024f3          	csrr	s1,sstatus
ffffffffc0200d6a:	14102973          	csrr	s2,sepc
ffffffffc0200d6e:	143029f3          	csrr	s3,stval
ffffffffc0200d72:	14202a73          	csrr	s4,scause
ffffffffc0200d76:	e822                	sd	s0,16(sp)
ffffffffc0200d78:	e226                	sd	s1,256(sp)
ffffffffc0200d7a:	e64a                	sd	s2,264(sp)
ffffffffc0200d7c:	ea4e                	sd	s3,272(sp)
ffffffffc0200d7e:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d80:	850a                	mv	a0,sp
    jal trap
ffffffffc0200d82:	f93ff0ef          	jal	ra,ffffffffc0200d14 <trap>

ffffffffc0200d86 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200d86:	6492                	ld	s1,256(sp)
ffffffffc0200d88:	6932                	ld	s2,264(sp)
ffffffffc0200d8a:	10049073          	csrw	sstatus,s1
ffffffffc0200d8e:	14191073          	csrw	sepc,s2
ffffffffc0200d92:	60a2                	ld	ra,8(sp)
ffffffffc0200d94:	61e2                	ld	gp,24(sp)
ffffffffc0200d96:	7202                	ld	tp,32(sp)
ffffffffc0200d98:	72a2                	ld	t0,40(sp)
ffffffffc0200d9a:	7342                	ld	t1,48(sp)
ffffffffc0200d9c:	73e2                	ld	t2,56(sp)
ffffffffc0200d9e:	6406                	ld	s0,64(sp)
ffffffffc0200da0:	64a6                	ld	s1,72(sp)
ffffffffc0200da2:	6546                	ld	a0,80(sp)
ffffffffc0200da4:	65e6                	ld	a1,88(sp)
ffffffffc0200da6:	7606                	ld	a2,96(sp)
ffffffffc0200da8:	76a6                	ld	a3,104(sp)
ffffffffc0200daa:	7746                	ld	a4,112(sp)
ffffffffc0200dac:	77e6                	ld	a5,120(sp)
ffffffffc0200dae:	680a                	ld	a6,128(sp)
ffffffffc0200db0:	68aa                	ld	a7,136(sp)
ffffffffc0200db2:	694a                	ld	s2,144(sp)
ffffffffc0200db4:	69ea                	ld	s3,152(sp)
ffffffffc0200db6:	7a0a                	ld	s4,160(sp)
ffffffffc0200db8:	7aaa                	ld	s5,168(sp)
ffffffffc0200dba:	7b4a                	ld	s6,176(sp)
ffffffffc0200dbc:	7bea                	ld	s7,184(sp)
ffffffffc0200dbe:	6c0e                	ld	s8,192(sp)
ffffffffc0200dc0:	6cae                	ld	s9,200(sp)
ffffffffc0200dc2:	6d4e                	ld	s10,208(sp)
ffffffffc0200dc4:	6dee                	ld	s11,216(sp)
ffffffffc0200dc6:	7e0e                	ld	t3,224(sp)
ffffffffc0200dc8:	7eae                	ld	t4,232(sp)
ffffffffc0200dca:	7f4e                	ld	t5,240(sp)
ffffffffc0200dcc:	7fee                	ld	t6,248(sp)
ffffffffc0200dce:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200dd0:	10200073          	sret

ffffffffc0200dd4 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200dd4:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200dd6:	bf45                	j	ffffffffc0200d86 <__trapret>
	...

ffffffffc0200dda <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200dda:	00008797          	auipc	a5,0x8
ffffffffc0200dde:	65678793          	addi	a5,a5,1622 # ffffffffc0209430 <free_area>
ffffffffc0200de2:	e79c                	sd	a5,8(a5)
ffffffffc0200de4:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200de6:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200dea:	8082                	ret

ffffffffc0200dec <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200dec:	00008517          	auipc	a0,0x8
ffffffffc0200df0:	65456503          	lwu	a0,1620(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0200df4:	8082                	ret

ffffffffc0200df6 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200df6:	715d                	addi	sp,sp,-80
ffffffffc0200df8:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200dfa:	00008417          	auipc	s0,0x8
ffffffffc0200dfe:	63640413          	addi	s0,s0,1590 # ffffffffc0209430 <free_area>
ffffffffc0200e02:	641c                	ld	a5,8(s0)
ffffffffc0200e04:	e486                	sd	ra,72(sp)
ffffffffc0200e06:	fc26                	sd	s1,56(sp)
ffffffffc0200e08:	f84a                	sd	s2,48(sp)
ffffffffc0200e0a:	f44e                	sd	s3,40(sp)
ffffffffc0200e0c:	f052                	sd	s4,32(sp)
ffffffffc0200e0e:	ec56                	sd	s5,24(sp)
ffffffffc0200e10:	e85a                	sd	s6,16(sp)
ffffffffc0200e12:	e45e                	sd	s7,8(sp)
ffffffffc0200e14:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e16:	2a878d63          	beq	a5,s0,ffffffffc02010d0 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc0200e1a:	4481                	li	s1,0
ffffffffc0200e1c:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200e1e:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200e22:	8b09                	andi	a4,a4,2
ffffffffc0200e24:	2a070a63          	beqz	a4,ffffffffc02010d8 <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc0200e28:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200e2c:	679c                	ld	a5,8(a5)
ffffffffc0200e2e:	2905                	addiw	s2,s2,1
ffffffffc0200e30:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200e32:	fe8796e3          	bne	a5,s0,ffffffffc0200e1e <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200e36:	89a6                	mv	s3,s1
ffffffffc0200e38:	6db000ef          	jal	ra,ffffffffc0201d12 <nr_free_pages>
ffffffffc0200e3c:	6f351e63          	bne	a0,s3,ffffffffc0201538 <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200e40:	4505                	li	a0,1
ffffffffc0200e42:	653000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200e46:	8aaa                	mv	s5,a0
ffffffffc0200e48:	42050863          	beqz	a0,ffffffffc0201278 <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200e4c:	4505                	li	a0,1
ffffffffc0200e4e:	647000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200e52:	89aa                	mv	s3,a0
ffffffffc0200e54:	70050263          	beqz	a0,ffffffffc0201558 <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200e58:	4505                	li	a0,1
ffffffffc0200e5a:	63b000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200e5e:	8a2a                	mv	s4,a0
ffffffffc0200e60:	48050c63          	beqz	a0,ffffffffc02012f8 <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200e64:	293a8a63          	beq	s5,s3,ffffffffc02010f8 <default_check+0x302>
ffffffffc0200e68:	28aa8863          	beq	s5,a0,ffffffffc02010f8 <default_check+0x302>
ffffffffc0200e6c:	28a98663          	beq	s3,a0,ffffffffc02010f8 <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200e70:	000aa783          	lw	a5,0(s5)
ffffffffc0200e74:	2a079263          	bnez	a5,ffffffffc0201118 <default_check+0x322>
ffffffffc0200e78:	0009a783          	lw	a5,0(s3)
ffffffffc0200e7c:	28079e63          	bnez	a5,ffffffffc0201118 <default_check+0x322>
ffffffffc0200e80:	411c                	lw	a5,0(a0)
ffffffffc0200e82:	28079b63          	bnez	a5,ffffffffc0201118 <default_check+0x322>
extern uint_t va_pa_offset;

static inline ppn_t
page2ppn(struct Page *page)
{
    return page - pages + nbase;
ffffffffc0200e86:	0000c797          	auipc	a5,0xc
ffffffffc0200e8a:	6327b783          	ld	a5,1586(a5) # ffffffffc020d4b8 <pages>
ffffffffc0200e8e:	40fa8733          	sub	a4,s5,a5
ffffffffc0200e92:	00005617          	auipc	a2,0x5
ffffffffc0200e96:	b4663603          	ld	a2,-1210(a2) # ffffffffc02059d8 <nbase>
ffffffffc0200e9a:	8719                	srai	a4,a4,0x6
ffffffffc0200e9c:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200e9e:	0000c697          	auipc	a3,0xc
ffffffffc0200ea2:	6126b683          	ld	a3,1554(a3) # ffffffffc020d4b0 <npage>
ffffffffc0200ea6:	06b2                	slli	a3,a3,0xc
}

static inline uintptr_t
page2pa(struct Page *page)
{
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ea8:	0732                	slli	a4,a4,0xc
ffffffffc0200eaa:	28d77763          	bgeu	a4,a3,ffffffffc0201138 <default_check+0x342>
    return page - pages + nbase;
ffffffffc0200eae:	40f98733          	sub	a4,s3,a5
ffffffffc0200eb2:	8719                	srai	a4,a4,0x6
ffffffffc0200eb4:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200eb6:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0200eb8:	4cd77063          	bgeu	a4,a3,ffffffffc0201378 <default_check+0x582>
    return page - pages + nbase;
ffffffffc0200ebc:	40f507b3          	sub	a5,a0,a5
ffffffffc0200ec0:	8799                	srai	a5,a5,0x6
ffffffffc0200ec2:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ec4:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0200ec6:	30d7f963          	bgeu	a5,a3,ffffffffc02011d8 <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc0200eca:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200ecc:	00043c03          	ld	s8,0(s0)
ffffffffc0200ed0:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0200ed4:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc0200ed8:	e400                	sd	s0,8(s0)
ffffffffc0200eda:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0200edc:	00008797          	auipc	a5,0x8
ffffffffc0200ee0:	5607a223          	sw	zero,1380(a5) # ffffffffc0209440 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0200ee4:	5b1000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200ee8:	2c051863          	bnez	a0,ffffffffc02011b8 <default_check+0x3c2>
    free_page(p0);
ffffffffc0200eec:	4585                	li	a1,1
ffffffffc0200eee:	8556                	mv	a0,s5
ffffffffc0200ef0:	5e3000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    free_page(p1);
ffffffffc0200ef4:	4585                	li	a1,1
ffffffffc0200ef6:	854e                	mv	a0,s3
ffffffffc0200ef8:	5db000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    free_page(p2);
ffffffffc0200efc:	4585                	li	a1,1
ffffffffc0200efe:	8552                	mv	a0,s4
ffffffffc0200f00:	5d3000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    assert(nr_free == 3);
ffffffffc0200f04:	4818                	lw	a4,16(s0)
ffffffffc0200f06:	478d                	li	a5,3
ffffffffc0200f08:	28f71863          	bne	a4,a5,ffffffffc0201198 <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f0c:	4505                	li	a0,1
ffffffffc0200f0e:	587000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200f12:	89aa                	mv	s3,a0
ffffffffc0200f14:	26050263          	beqz	a0,ffffffffc0201178 <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f18:	4505                	li	a0,1
ffffffffc0200f1a:	57b000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200f1e:	8aaa                	mv	s5,a0
ffffffffc0200f20:	3a050c63          	beqz	a0,ffffffffc02012d8 <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200f24:	4505                	li	a0,1
ffffffffc0200f26:	56f000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200f2a:	8a2a                	mv	s4,a0
ffffffffc0200f2c:	38050663          	beqz	a0,ffffffffc02012b8 <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0200f30:	4505                	li	a0,1
ffffffffc0200f32:	563000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200f36:	36051163          	bnez	a0,ffffffffc0201298 <default_check+0x4a2>
    free_page(p0);
ffffffffc0200f3a:	4585                	li	a1,1
ffffffffc0200f3c:	854e                	mv	a0,s3
ffffffffc0200f3e:	595000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0200f42:	641c                	ld	a5,8(s0)
ffffffffc0200f44:	20878a63          	beq	a5,s0,ffffffffc0201158 <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc0200f48:	4505                	li	a0,1
ffffffffc0200f4a:	54b000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200f4e:	30a99563          	bne	s3,a0,ffffffffc0201258 <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0200f52:	4505                	li	a0,1
ffffffffc0200f54:	541000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200f58:	2e051063          	bnez	a0,ffffffffc0201238 <default_check+0x442>
    assert(nr_free == 0);
ffffffffc0200f5c:	481c                	lw	a5,16(s0)
ffffffffc0200f5e:	2a079d63          	bnez	a5,ffffffffc0201218 <default_check+0x422>
    free_page(p);
ffffffffc0200f62:	854e                	mv	a0,s3
ffffffffc0200f64:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0200f66:	01843023          	sd	s8,0(s0)
ffffffffc0200f6a:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0200f6e:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0200f72:	561000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    free_page(p1);
ffffffffc0200f76:	4585                	li	a1,1
ffffffffc0200f78:	8556                	mv	a0,s5
ffffffffc0200f7a:	559000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    free_page(p2);
ffffffffc0200f7e:	4585                	li	a1,1
ffffffffc0200f80:	8552                	mv	a0,s4
ffffffffc0200f82:	551000ef          	jal	ra,ffffffffc0201cd2 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0200f86:	4515                	li	a0,5
ffffffffc0200f88:	50d000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200f8c:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0200f8e:	26050563          	beqz	a0,ffffffffc02011f8 <default_check+0x402>
ffffffffc0200f92:	651c                	ld	a5,8(a0)
ffffffffc0200f94:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0200f96:	8b85                	andi	a5,a5,1
ffffffffc0200f98:	54079063          	bnez	a5,ffffffffc02014d8 <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0200f9c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0200f9e:	00043b03          	ld	s6,0(s0)
ffffffffc0200fa2:	00843a83          	ld	s5,8(s0)
ffffffffc0200fa6:	e000                	sd	s0,0(s0)
ffffffffc0200fa8:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0200faa:	4eb000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200fae:	50051563          	bnez	a0,ffffffffc02014b8 <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0200fb2:	08098a13          	addi	s4,s3,128
ffffffffc0200fb6:	8552                	mv	a0,s4
ffffffffc0200fb8:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0200fba:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0200fbe:	00008797          	auipc	a5,0x8
ffffffffc0200fc2:	4807a123          	sw	zero,1154(a5) # ffffffffc0209440 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0200fc6:	50d000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0200fca:	4511                	li	a0,4
ffffffffc0200fcc:	4c9000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200fd0:	4c051463          	bnez	a0,ffffffffc0201498 <default_check+0x6a2>
ffffffffc0200fd4:	0889b783          	ld	a5,136(s3)
ffffffffc0200fd8:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0200fda:	8b85                	andi	a5,a5,1
ffffffffc0200fdc:	48078e63          	beqz	a5,ffffffffc0201478 <default_check+0x682>
ffffffffc0200fe0:	0909a703          	lw	a4,144(s3)
ffffffffc0200fe4:	478d                	li	a5,3
ffffffffc0200fe6:	48f71963          	bne	a4,a5,ffffffffc0201478 <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0200fea:	450d                	li	a0,3
ffffffffc0200fec:	4a9000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200ff0:	8c2a                	mv	s8,a0
ffffffffc0200ff2:	46050363          	beqz	a0,ffffffffc0201458 <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0200ff6:	4505                	li	a0,1
ffffffffc0200ff8:	49d000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0200ffc:	42051e63          	bnez	a0,ffffffffc0201438 <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0201000:	418a1c63          	bne	s4,s8,ffffffffc0201418 <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0201004:	4585                	li	a1,1
ffffffffc0201006:	854e                	mv	a0,s3
ffffffffc0201008:	4cb000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    free_pages(p1, 3);
ffffffffc020100c:	458d                	li	a1,3
ffffffffc020100e:	8552                	mv	a0,s4
ffffffffc0201010:	4c3000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
ffffffffc0201014:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc0201018:	04098c13          	addi	s8,s3,64
ffffffffc020101c:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020101e:	8b85                	andi	a5,a5,1
ffffffffc0201020:	3c078c63          	beqz	a5,ffffffffc02013f8 <default_check+0x602>
ffffffffc0201024:	0109a703          	lw	a4,16(s3)
ffffffffc0201028:	4785                	li	a5,1
ffffffffc020102a:	3cf71763          	bne	a4,a5,ffffffffc02013f8 <default_check+0x602>
ffffffffc020102e:	008a3783          	ld	a5,8(s4)
ffffffffc0201032:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0201034:	8b85                	andi	a5,a5,1
ffffffffc0201036:	3a078163          	beqz	a5,ffffffffc02013d8 <default_check+0x5e2>
ffffffffc020103a:	010a2703          	lw	a4,16(s4)
ffffffffc020103e:	478d                	li	a5,3
ffffffffc0201040:	38f71c63          	bne	a4,a5,ffffffffc02013d8 <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0201044:	4505                	li	a0,1
ffffffffc0201046:	44f000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc020104a:	36a99763          	bne	s3,a0,ffffffffc02013b8 <default_check+0x5c2>
    free_page(p0);
ffffffffc020104e:	4585                	li	a1,1
ffffffffc0201050:	483000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201054:	4509                	li	a0,2
ffffffffc0201056:	43f000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc020105a:	32aa1f63          	bne	s4,a0,ffffffffc0201398 <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc020105e:	4589                	li	a1,2
ffffffffc0201060:	473000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    free_page(p2);
ffffffffc0201064:	4585                	li	a1,1
ffffffffc0201066:	8562                	mv	a0,s8
ffffffffc0201068:	46b000ef          	jal	ra,ffffffffc0201cd2 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020106c:	4515                	li	a0,5
ffffffffc020106e:	427000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc0201072:	89aa                	mv	s3,a0
ffffffffc0201074:	48050263          	beqz	a0,ffffffffc02014f8 <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc0201078:	4505                	li	a0,1
ffffffffc020107a:	41b000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
ffffffffc020107e:	2c051d63          	bnez	a0,ffffffffc0201358 <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0201082:	481c                	lw	a5,16(s0)
ffffffffc0201084:	2a079a63          	bnez	a5,ffffffffc0201338 <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0201088:	4595                	li	a1,5
ffffffffc020108a:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc020108c:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0201090:	01643023          	sd	s6,0(s0)
ffffffffc0201094:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0201098:	43b000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
    return listelm->next;
ffffffffc020109c:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc020109e:	00878963          	beq	a5,s0,ffffffffc02010b0 <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc02010a2:	ff87a703          	lw	a4,-8(a5)
ffffffffc02010a6:	679c                	ld	a5,8(a5)
ffffffffc02010a8:	397d                	addiw	s2,s2,-1
ffffffffc02010aa:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010ac:	fe879be3          	bne	a5,s0,ffffffffc02010a2 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02010b0:	26091463          	bnez	s2,ffffffffc0201318 <default_check+0x522>
    assert(total == 0);
ffffffffc02010b4:	46049263          	bnez	s1,ffffffffc0201518 <default_check+0x722>
}
ffffffffc02010b8:	60a6                	ld	ra,72(sp)
ffffffffc02010ba:	6406                	ld	s0,64(sp)
ffffffffc02010bc:	74e2                	ld	s1,56(sp)
ffffffffc02010be:	7942                	ld	s2,48(sp)
ffffffffc02010c0:	79a2                	ld	s3,40(sp)
ffffffffc02010c2:	7a02                	ld	s4,32(sp)
ffffffffc02010c4:	6ae2                	ld	s5,24(sp)
ffffffffc02010c6:	6b42                	ld	s6,16(sp)
ffffffffc02010c8:	6ba2                	ld	s7,8(sp)
ffffffffc02010ca:	6c02                	ld	s8,0(sp)
ffffffffc02010cc:	6161                	addi	sp,sp,80
ffffffffc02010ce:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc02010d0:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02010d2:	4481                	li	s1,0
ffffffffc02010d4:	4901                	li	s2,0
ffffffffc02010d6:	b38d                	j	ffffffffc0200e38 <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02010d8:	00004697          	auipc	a3,0x4
ffffffffc02010dc:	82868693          	addi	a3,a3,-2008 # ffffffffc0204900 <commands+0x808>
ffffffffc02010e0:	00004617          	auipc	a2,0x4
ffffffffc02010e4:	83060613          	addi	a2,a2,-2000 # ffffffffc0204910 <commands+0x818>
ffffffffc02010e8:	0f000593          	li	a1,240
ffffffffc02010ec:	00004517          	auipc	a0,0x4
ffffffffc02010f0:	83c50513          	addi	a0,a0,-1988 # ffffffffc0204928 <commands+0x830>
ffffffffc02010f4:	b66ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02010f8:	00004697          	auipc	a3,0x4
ffffffffc02010fc:	8c868693          	addi	a3,a3,-1848 # ffffffffc02049c0 <commands+0x8c8>
ffffffffc0201100:	00004617          	auipc	a2,0x4
ffffffffc0201104:	81060613          	addi	a2,a2,-2032 # ffffffffc0204910 <commands+0x818>
ffffffffc0201108:	0bd00593          	li	a1,189
ffffffffc020110c:	00004517          	auipc	a0,0x4
ffffffffc0201110:	81c50513          	addi	a0,a0,-2020 # ffffffffc0204928 <commands+0x830>
ffffffffc0201114:	b46ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0201118:	00004697          	auipc	a3,0x4
ffffffffc020111c:	8d068693          	addi	a3,a3,-1840 # ffffffffc02049e8 <commands+0x8f0>
ffffffffc0201120:	00003617          	auipc	a2,0x3
ffffffffc0201124:	7f060613          	addi	a2,a2,2032 # ffffffffc0204910 <commands+0x818>
ffffffffc0201128:	0be00593          	li	a1,190
ffffffffc020112c:	00003517          	auipc	a0,0x3
ffffffffc0201130:	7fc50513          	addi	a0,a0,2044 # ffffffffc0204928 <commands+0x830>
ffffffffc0201134:	b26ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0201138:	00004697          	auipc	a3,0x4
ffffffffc020113c:	8f068693          	addi	a3,a3,-1808 # ffffffffc0204a28 <commands+0x930>
ffffffffc0201140:	00003617          	auipc	a2,0x3
ffffffffc0201144:	7d060613          	addi	a2,a2,2000 # ffffffffc0204910 <commands+0x818>
ffffffffc0201148:	0c000593          	li	a1,192
ffffffffc020114c:	00003517          	auipc	a0,0x3
ffffffffc0201150:	7dc50513          	addi	a0,a0,2012 # ffffffffc0204928 <commands+0x830>
ffffffffc0201154:	b06ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(!list_empty(&free_list));
ffffffffc0201158:	00004697          	auipc	a3,0x4
ffffffffc020115c:	95868693          	addi	a3,a3,-1704 # ffffffffc0204ab0 <commands+0x9b8>
ffffffffc0201160:	00003617          	auipc	a2,0x3
ffffffffc0201164:	7b060613          	addi	a2,a2,1968 # ffffffffc0204910 <commands+0x818>
ffffffffc0201168:	0d900593          	li	a1,217
ffffffffc020116c:	00003517          	auipc	a0,0x3
ffffffffc0201170:	7bc50513          	addi	a0,a0,1980 # ffffffffc0204928 <commands+0x830>
ffffffffc0201174:	ae6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201178:	00003697          	auipc	a3,0x3
ffffffffc020117c:	7e868693          	addi	a3,a3,2024 # ffffffffc0204960 <commands+0x868>
ffffffffc0201180:	00003617          	auipc	a2,0x3
ffffffffc0201184:	79060613          	addi	a2,a2,1936 # ffffffffc0204910 <commands+0x818>
ffffffffc0201188:	0d200593          	li	a1,210
ffffffffc020118c:	00003517          	auipc	a0,0x3
ffffffffc0201190:	79c50513          	addi	a0,a0,1948 # ffffffffc0204928 <commands+0x830>
ffffffffc0201194:	ac6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free == 3);
ffffffffc0201198:	00004697          	auipc	a3,0x4
ffffffffc020119c:	90868693          	addi	a3,a3,-1784 # ffffffffc0204aa0 <commands+0x9a8>
ffffffffc02011a0:	00003617          	auipc	a2,0x3
ffffffffc02011a4:	77060613          	addi	a2,a2,1904 # ffffffffc0204910 <commands+0x818>
ffffffffc02011a8:	0d000593          	li	a1,208
ffffffffc02011ac:	00003517          	auipc	a0,0x3
ffffffffc02011b0:	77c50513          	addi	a0,a0,1916 # ffffffffc0204928 <commands+0x830>
ffffffffc02011b4:	aa6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02011b8:	00004697          	auipc	a3,0x4
ffffffffc02011bc:	8d068693          	addi	a3,a3,-1840 # ffffffffc0204a88 <commands+0x990>
ffffffffc02011c0:	00003617          	auipc	a2,0x3
ffffffffc02011c4:	75060613          	addi	a2,a2,1872 # ffffffffc0204910 <commands+0x818>
ffffffffc02011c8:	0cb00593          	li	a1,203
ffffffffc02011cc:	00003517          	auipc	a0,0x3
ffffffffc02011d0:	75c50513          	addi	a0,a0,1884 # ffffffffc0204928 <commands+0x830>
ffffffffc02011d4:	a86ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02011d8:	00004697          	auipc	a3,0x4
ffffffffc02011dc:	89068693          	addi	a3,a3,-1904 # ffffffffc0204a68 <commands+0x970>
ffffffffc02011e0:	00003617          	auipc	a2,0x3
ffffffffc02011e4:	73060613          	addi	a2,a2,1840 # ffffffffc0204910 <commands+0x818>
ffffffffc02011e8:	0c200593          	li	a1,194
ffffffffc02011ec:	00003517          	auipc	a0,0x3
ffffffffc02011f0:	73c50513          	addi	a0,a0,1852 # ffffffffc0204928 <commands+0x830>
ffffffffc02011f4:	a66ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(p0 != NULL);
ffffffffc02011f8:	00004697          	auipc	a3,0x4
ffffffffc02011fc:	90068693          	addi	a3,a3,-1792 # ffffffffc0204af8 <commands+0xa00>
ffffffffc0201200:	00003617          	auipc	a2,0x3
ffffffffc0201204:	71060613          	addi	a2,a2,1808 # ffffffffc0204910 <commands+0x818>
ffffffffc0201208:	0f800593          	li	a1,248
ffffffffc020120c:	00003517          	auipc	a0,0x3
ffffffffc0201210:	71c50513          	addi	a0,a0,1820 # ffffffffc0204928 <commands+0x830>
ffffffffc0201214:	a46ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free == 0);
ffffffffc0201218:	00004697          	auipc	a3,0x4
ffffffffc020121c:	8d068693          	addi	a3,a3,-1840 # ffffffffc0204ae8 <commands+0x9f0>
ffffffffc0201220:	00003617          	auipc	a2,0x3
ffffffffc0201224:	6f060613          	addi	a2,a2,1776 # ffffffffc0204910 <commands+0x818>
ffffffffc0201228:	0df00593          	li	a1,223
ffffffffc020122c:	00003517          	auipc	a0,0x3
ffffffffc0201230:	6fc50513          	addi	a0,a0,1788 # ffffffffc0204928 <commands+0x830>
ffffffffc0201234:	a26ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201238:	00004697          	auipc	a3,0x4
ffffffffc020123c:	85068693          	addi	a3,a3,-1968 # ffffffffc0204a88 <commands+0x990>
ffffffffc0201240:	00003617          	auipc	a2,0x3
ffffffffc0201244:	6d060613          	addi	a2,a2,1744 # ffffffffc0204910 <commands+0x818>
ffffffffc0201248:	0dd00593          	li	a1,221
ffffffffc020124c:	00003517          	auipc	a0,0x3
ffffffffc0201250:	6dc50513          	addi	a0,a0,1756 # ffffffffc0204928 <commands+0x830>
ffffffffc0201254:	a06ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0201258:	00004697          	auipc	a3,0x4
ffffffffc020125c:	87068693          	addi	a3,a3,-1936 # ffffffffc0204ac8 <commands+0x9d0>
ffffffffc0201260:	00003617          	auipc	a2,0x3
ffffffffc0201264:	6b060613          	addi	a2,a2,1712 # ffffffffc0204910 <commands+0x818>
ffffffffc0201268:	0dc00593          	li	a1,220
ffffffffc020126c:	00003517          	auipc	a0,0x3
ffffffffc0201270:	6bc50513          	addi	a0,a0,1724 # ffffffffc0204928 <commands+0x830>
ffffffffc0201274:	9e6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201278:	00003697          	auipc	a3,0x3
ffffffffc020127c:	6e868693          	addi	a3,a3,1768 # ffffffffc0204960 <commands+0x868>
ffffffffc0201280:	00003617          	auipc	a2,0x3
ffffffffc0201284:	69060613          	addi	a2,a2,1680 # ffffffffc0204910 <commands+0x818>
ffffffffc0201288:	0b900593          	li	a1,185
ffffffffc020128c:	00003517          	auipc	a0,0x3
ffffffffc0201290:	69c50513          	addi	a0,a0,1692 # ffffffffc0204928 <commands+0x830>
ffffffffc0201294:	9c6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201298:	00003697          	auipc	a3,0x3
ffffffffc020129c:	7f068693          	addi	a3,a3,2032 # ffffffffc0204a88 <commands+0x990>
ffffffffc02012a0:	00003617          	auipc	a2,0x3
ffffffffc02012a4:	67060613          	addi	a2,a2,1648 # ffffffffc0204910 <commands+0x818>
ffffffffc02012a8:	0d600593          	li	a1,214
ffffffffc02012ac:	00003517          	auipc	a0,0x3
ffffffffc02012b0:	67c50513          	addi	a0,a0,1660 # ffffffffc0204928 <commands+0x830>
ffffffffc02012b4:	9a6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02012b8:	00003697          	auipc	a3,0x3
ffffffffc02012bc:	6e868693          	addi	a3,a3,1768 # ffffffffc02049a0 <commands+0x8a8>
ffffffffc02012c0:	00003617          	auipc	a2,0x3
ffffffffc02012c4:	65060613          	addi	a2,a2,1616 # ffffffffc0204910 <commands+0x818>
ffffffffc02012c8:	0d400593          	li	a1,212
ffffffffc02012cc:	00003517          	auipc	a0,0x3
ffffffffc02012d0:	65c50513          	addi	a0,a0,1628 # ffffffffc0204928 <commands+0x830>
ffffffffc02012d4:	986ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02012d8:	00003697          	auipc	a3,0x3
ffffffffc02012dc:	6a868693          	addi	a3,a3,1704 # ffffffffc0204980 <commands+0x888>
ffffffffc02012e0:	00003617          	auipc	a2,0x3
ffffffffc02012e4:	63060613          	addi	a2,a2,1584 # ffffffffc0204910 <commands+0x818>
ffffffffc02012e8:	0d300593          	li	a1,211
ffffffffc02012ec:	00003517          	auipc	a0,0x3
ffffffffc02012f0:	63c50513          	addi	a0,a0,1596 # ffffffffc0204928 <commands+0x830>
ffffffffc02012f4:	966ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02012f8:	00003697          	auipc	a3,0x3
ffffffffc02012fc:	6a868693          	addi	a3,a3,1704 # ffffffffc02049a0 <commands+0x8a8>
ffffffffc0201300:	00003617          	auipc	a2,0x3
ffffffffc0201304:	61060613          	addi	a2,a2,1552 # ffffffffc0204910 <commands+0x818>
ffffffffc0201308:	0bb00593          	li	a1,187
ffffffffc020130c:	00003517          	auipc	a0,0x3
ffffffffc0201310:	61c50513          	addi	a0,a0,1564 # ffffffffc0204928 <commands+0x830>
ffffffffc0201314:	946ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(count == 0);
ffffffffc0201318:	00004697          	auipc	a3,0x4
ffffffffc020131c:	93068693          	addi	a3,a3,-1744 # ffffffffc0204c48 <commands+0xb50>
ffffffffc0201320:	00003617          	auipc	a2,0x3
ffffffffc0201324:	5f060613          	addi	a2,a2,1520 # ffffffffc0204910 <commands+0x818>
ffffffffc0201328:	12500593          	li	a1,293
ffffffffc020132c:	00003517          	auipc	a0,0x3
ffffffffc0201330:	5fc50513          	addi	a0,a0,1532 # ffffffffc0204928 <commands+0x830>
ffffffffc0201334:	926ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free == 0);
ffffffffc0201338:	00003697          	auipc	a3,0x3
ffffffffc020133c:	7b068693          	addi	a3,a3,1968 # ffffffffc0204ae8 <commands+0x9f0>
ffffffffc0201340:	00003617          	auipc	a2,0x3
ffffffffc0201344:	5d060613          	addi	a2,a2,1488 # ffffffffc0204910 <commands+0x818>
ffffffffc0201348:	11a00593          	li	a1,282
ffffffffc020134c:	00003517          	auipc	a0,0x3
ffffffffc0201350:	5dc50513          	addi	a0,a0,1500 # ffffffffc0204928 <commands+0x830>
ffffffffc0201354:	906ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201358:	00003697          	auipc	a3,0x3
ffffffffc020135c:	73068693          	addi	a3,a3,1840 # ffffffffc0204a88 <commands+0x990>
ffffffffc0201360:	00003617          	auipc	a2,0x3
ffffffffc0201364:	5b060613          	addi	a2,a2,1456 # ffffffffc0204910 <commands+0x818>
ffffffffc0201368:	11800593          	li	a1,280
ffffffffc020136c:	00003517          	auipc	a0,0x3
ffffffffc0201370:	5bc50513          	addi	a0,a0,1468 # ffffffffc0204928 <commands+0x830>
ffffffffc0201374:	8e6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0201378:	00003697          	auipc	a3,0x3
ffffffffc020137c:	6d068693          	addi	a3,a3,1744 # ffffffffc0204a48 <commands+0x950>
ffffffffc0201380:	00003617          	auipc	a2,0x3
ffffffffc0201384:	59060613          	addi	a2,a2,1424 # ffffffffc0204910 <commands+0x818>
ffffffffc0201388:	0c100593          	li	a1,193
ffffffffc020138c:	00003517          	auipc	a0,0x3
ffffffffc0201390:	59c50513          	addi	a0,a0,1436 # ffffffffc0204928 <commands+0x830>
ffffffffc0201394:	8c6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0201398:	00004697          	auipc	a3,0x4
ffffffffc020139c:	87068693          	addi	a3,a3,-1936 # ffffffffc0204c08 <commands+0xb10>
ffffffffc02013a0:	00003617          	auipc	a2,0x3
ffffffffc02013a4:	57060613          	addi	a2,a2,1392 # ffffffffc0204910 <commands+0x818>
ffffffffc02013a8:	11200593          	li	a1,274
ffffffffc02013ac:	00003517          	auipc	a0,0x3
ffffffffc02013b0:	57c50513          	addi	a0,a0,1404 # ffffffffc0204928 <commands+0x830>
ffffffffc02013b4:	8a6ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02013b8:	00004697          	auipc	a3,0x4
ffffffffc02013bc:	83068693          	addi	a3,a3,-2000 # ffffffffc0204be8 <commands+0xaf0>
ffffffffc02013c0:	00003617          	auipc	a2,0x3
ffffffffc02013c4:	55060613          	addi	a2,a2,1360 # ffffffffc0204910 <commands+0x818>
ffffffffc02013c8:	11000593          	li	a1,272
ffffffffc02013cc:	00003517          	auipc	a0,0x3
ffffffffc02013d0:	55c50513          	addi	a0,a0,1372 # ffffffffc0204928 <commands+0x830>
ffffffffc02013d4:	886ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02013d8:	00003697          	auipc	a3,0x3
ffffffffc02013dc:	7e868693          	addi	a3,a3,2024 # ffffffffc0204bc0 <commands+0xac8>
ffffffffc02013e0:	00003617          	auipc	a2,0x3
ffffffffc02013e4:	53060613          	addi	a2,a2,1328 # ffffffffc0204910 <commands+0x818>
ffffffffc02013e8:	10e00593          	li	a1,270
ffffffffc02013ec:	00003517          	auipc	a0,0x3
ffffffffc02013f0:	53c50513          	addi	a0,a0,1340 # ffffffffc0204928 <commands+0x830>
ffffffffc02013f4:	866ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02013f8:	00003697          	auipc	a3,0x3
ffffffffc02013fc:	7a068693          	addi	a3,a3,1952 # ffffffffc0204b98 <commands+0xaa0>
ffffffffc0201400:	00003617          	auipc	a2,0x3
ffffffffc0201404:	51060613          	addi	a2,a2,1296 # ffffffffc0204910 <commands+0x818>
ffffffffc0201408:	10d00593          	li	a1,269
ffffffffc020140c:	00003517          	auipc	a0,0x3
ffffffffc0201410:	51c50513          	addi	a0,a0,1308 # ffffffffc0204928 <commands+0x830>
ffffffffc0201414:	846ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(p0 + 2 == p1);
ffffffffc0201418:	00003697          	auipc	a3,0x3
ffffffffc020141c:	77068693          	addi	a3,a3,1904 # ffffffffc0204b88 <commands+0xa90>
ffffffffc0201420:	00003617          	auipc	a2,0x3
ffffffffc0201424:	4f060613          	addi	a2,a2,1264 # ffffffffc0204910 <commands+0x818>
ffffffffc0201428:	10800593          	li	a1,264
ffffffffc020142c:	00003517          	auipc	a0,0x3
ffffffffc0201430:	4fc50513          	addi	a0,a0,1276 # ffffffffc0204928 <commands+0x830>
ffffffffc0201434:	826ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc0201438:	00003697          	auipc	a3,0x3
ffffffffc020143c:	65068693          	addi	a3,a3,1616 # ffffffffc0204a88 <commands+0x990>
ffffffffc0201440:	00003617          	auipc	a2,0x3
ffffffffc0201444:	4d060613          	addi	a2,a2,1232 # ffffffffc0204910 <commands+0x818>
ffffffffc0201448:	10700593          	li	a1,263
ffffffffc020144c:	00003517          	auipc	a0,0x3
ffffffffc0201450:	4dc50513          	addi	a0,a0,1244 # ffffffffc0204928 <commands+0x830>
ffffffffc0201454:	806ff0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201458:	00003697          	auipc	a3,0x3
ffffffffc020145c:	71068693          	addi	a3,a3,1808 # ffffffffc0204b68 <commands+0xa70>
ffffffffc0201460:	00003617          	auipc	a2,0x3
ffffffffc0201464:	4b060613          	addi	a2,a2,1200 # ffffffffc0204910 <commands+0x818>
ffffffffc0201468:	10600593          	li	a1,262
ffffffffc020146c:	00003517          	auipc	a0,0x3
ffffffffc0201470:	4bc50513          	addi	a0,a0,1212 # ffffffffc0204928 <commands+0x830>
ffffffffc0201474:	fe7fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201478:	00003697          	auipc	a3,0x3
ffffffffc020147c:	6c068693          	addi	a3,a3,1728 # ffffffffc0204b38 <commands+0xa40>
ffffffffc0201480:	00003617          	auipc	a2,0x3
ffffffffc0201484:	49060613          	addi	a2,a2,1168 # ffffffffc0204910 <commands+0x818>
ffffffffc0201488:	10500593          	li	a1,261
ffffffffc020148c:	00003517          	auipc	a0,0x3
ffffffffc0201490:	49c50513          	addi	a0,a0,1180 # ffffffffc0204928 <commands+0x830>
ffffffffc0201494:	fc7fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0201498:	00003697          	auipc	a3,0x3
ffffffffc020149c:	68868693          	addi	a3,a3,1672 # ffffffffc0204b20 <commands+0xa28>
ffffffffc02014a0:	00003617          	auipc	a2,0x3
ffffffffc02014a4:	47060613          	addi	a2,a2,1136 # ffffffffc0204910 <commands+0x818>
ffffffffc02014a8:	10400593          	li	a1,260
ffffffffc02014ac:	00003517          	auipc	a0,0x3
ffffffffc02014b0:	47c50513          	addi	a0,a0,1148 # ffffffffc0204928 <commands+0x830>
ffffffffc02014b4:	fa7fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014b8:	00003697          	auipc	a3,0x3
ffffffffc02014bc:	5d068693          	addi	a3,a3,1488 # ffffffffc0204a88 <commands+0x990>
ffffffffc02014c0:	00003617          	auipc	a2,0x3
ffffffffc02014c4:	45060613          	addi	a2,a2,1104 # ffffffffc0204910 <commands+0x818>
ffffffffc02014c8:	0fe00593          	li	a1,254
ffffffffc02014cc:	00003517          	auipc	a0,0x3
ffffffffc02014d0:	45c50513          	addi	a0,a0,1116 # ffffffffc0204928 <commands+0x830>
ffffffffc02014d4:	f87fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(!PageProperty(p0));
ffffffffc02014d8:	00003697          	auipc	a3,0x3
ffffffffc02014dc:	63068693          	addi	a3,a3,1584 # ffffffffc0204b08 <commands+0xa10>
ffffffffc02014e0:	00003617          	auipc	a2,0x3
ffffffffc02014e4:	43060613          	addi	a2,a2,1072 # ffffffffc0204910 <commands+0x818>
ffffffffc02014e8:	0f900593          	li	a1,249
ffffffffc02014ec:	00003517          	auipc	a0,0x3
ffffffffc02014f0:	43c50513          	addi	a0,a0,1084 # ffffffffc0204928 <commands+0x830>
ffffffffc02014f4:	f67fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02014f8:	00003697          	auipc	a3,0x3
ffffffffc02014fc:	73068693          	addi	a3,a3,1840 # ffffffffc0204c28 <commands+0xb30>
ffffffffc0201500:	00003617          	auipc	a2,0x3
ffffffffc0201504:	41060613          	addi	a2,a2,1040 # ffffffffc0204910 <commands+0x818>
ffffffffc0201508:	11700593          	li	a1,279
ffffffffc020150c:	00003517          	auipc	a0,0x3
ffffffffc0201510:	41c50513          	addi	a0,a0,1052 # ffffffffc0204928 <commands+0x830>
ffffffffc0201514:	f47fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(total == 0);
ffffffffc0201518:	00003697          	auipc	a3,0x3
ffffffffc020151c:	74068693          	addi	a3,a3,1856 # ffffffffc0204c58 <commands+0xb60>
ffffffffc0201520:	00003617          	auipc	a2,0x3
ffffffffc0201524:	3f060613          	addi	a2,a2,1008 # ffffffffc0204910 <commands+0x818>
ffffffffc0201528:	12600593          	li	a1,294
ffffffffc020152c:	00003517          	auipc	a0,0x3
ffffffffc0201530:	3fc50513          	addi	a0,a0,1020 # ffffffffc0204928 <commands+0x830>
ffffffffc0201534:	f27fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(total == nr_free_pages());
ffffffffc0201538:	00003697          	auipc	a3,0x3
ffffffffc020153c:	40868693          	addi	a3,a3,1032 # ffffffffc0204940 <commands+0x848>
ffffffffc0201540:	00003617          	auipc	a2,0x3
ffffffffc0201544:	3d060613          	addi	a2,a2,976 # ffffffffc0204910 <commands+0x818>
ffffffffc0201548:	0f300593          	li	a1,243
ffffffffc020154c:	00003517          	auipc	a0,0x3
ffffffffc0201550:	3dc50513          	addi	a0,a0,988 # ffffffffc0204928 <commands+0x830>
ffffffffc0201554:	f07fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0201558:	00003697          	auipc	a3,0x3
ffffffffc020155c:	42868693          	addi	a3,a3,1064 # ffffffffc0204980 <commands+0x888>
ffffffffc0201560:	00003617          	auipc	a2,0x3
ffffffffc0201564:	3b060613          	addi	a2,a2,944 # ffffffffc0204910 <commands+0x818>
ffffffffc0201568:	0ba00593          	li	a1,186
ffffffffc020156c:	00003517          	auipc	a0,0x3
ffffffffc0201570:	3bc50513          	addi	a0,a0,956 # ffffffffc0204928 <commands+0x830>
ffffffffc0201574:	ee7fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201578 <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0201578:	1141                	addi	sp,sp,-16
ffffffffc020157a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020157c:	14058463          	beqz	a1,ffffffffc02016c4 <default_free_pages+0x14c>
    for (; p != base + n; p ++) {
ffffffffc0201580:	00659693          	slli	a3,a1,0x6
ffffffffc0201584:	96aa                	add	a3,a3,a0
ffffffffc0201586:	87aa                	mv	a5,a0
ffffffffc0201588:	02d50263          	beq	a0,a3,ffffffffc02015ac <default_free_pages+0x34>
ffffffffc020158c:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc020158e:	8b05                	andi	a4,a4,1
ffffffffc0201590:	10071a63          	bnez	a4,ffffffffc02016a4 <default_free_pages+0x12c>
ffffffffc0201594:	6798                	ld	a4,8(a5)
ffffffffc0201596:	8b09                	andi	a4,a4,2
ffffffffc0201598:	10071663          	bnez	a4,ffffffffc02016a4 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc020159c:	0007b423          	sd	zero,8(a5)
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc02015a0:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02015a4:	04078793          	addi	a5,a5,64
ffffffffc02015a8:	fed792e3          	bne	a5,a3,ffffffffc020158c <default_free_pages+0x14>
    base->property = n;
ffffffffc02015ac:	2581                	sext.w	a1,a1
ffffffffc02015ae:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc02015b0:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02015b4:	4789                	li	a5,2
ffffffffc02015b6:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc02015ba:	00008697          	auipc	a3,0x8
ffffffffc02015be:	e7668693          	addi	a3,a3,-394 # ffffffffc0209430 <free_area>
ffffffffc02015c2:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02015c4:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02015c6:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02015ca:	9db9                	addw	a1,a1,a4
ffffffffc02015cc:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02015ce:	0ad78463          	beq	a5,a3,ffffffffc0201676 <default_free_pages+0xfe>
            struct Page* page = le2page(le, page_link);
ffffffffc02015d2:	fe878713          	addi	a4,a5,-24
ffffffffc02015d6:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02015da:	4581                	li	a1,0
            if (base < page) {
ffffffffc02015dc:	00e56a63          	bltu	a0,a4,ffffffffc02015f0 <default_free_pages+0x78>
    return listelm->next;
ffffffffc02015e0:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02015e2:	04d70c63          	beq	a4,a3,ffffffffc020163a <default_free_pages+0xc2>
    for (; p != base + n; p ++) {
ffffffffc02015e6:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc02015e8:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc02015ec:	fee57ae3          	bgeu	a0,a4,ffffffffc02015e0 <default_free_pages+0x68>
ffffffffc02015f0:	c199                	beqz	a1,ffffffffc02015f6 <default_free_pages+0x7e>
ffffffffc02015f2:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc02015f6:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02015f8:	e390                	sd	a2,0(a5)
ffffffffc02015fa:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc02015fc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02015fe:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0201600:	00d70d63          	beq	a4,a3,ffffffffc020161a <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc0201604:	ff872583          	lw	a1,-8(a4)
        p = le2page(le, page_link);
ffffffffc0201608:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc020160c:	02059813          	slli	a6,a1,0x20
ffffffffc0201610:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201614:	97b2                	add	a5,a5,a2
ffffffffc0201616:	02f50c63          	beq	a0,a5,ffffffffc020164e <default_free_pages+0xd6>
    return listelm->next;
ffffffffc020161a:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc020161c:	00d78c63          	beq	a5,a3,ffffffffc0201634 <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0201620:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0201622:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0201626:	02061593          	slli	a1,a2,0x20
ffffffffc020162a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc020162e:	972a                	add	a4,a4,a0
ffffffffc0201630:	04e68a63          	beq	a3,a4,ffffffffc0201684 <default_free_pages+0x10c>
}
ffffffffc0201634:	60a2                	ld	ra,8(sp)
ffffffffc0201636:	0141                	addi	sp,sp,16
ffffffffc0201638:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020163a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020163c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020163e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201640:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201642:	02d70763          	beq	a4,a3,ffffffffc0201670 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0201646:	8832                	mv	a6,a2
ffffffffc0201648:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020164a:	87ba                	mv	a5,a4
ffffffffc020164c:	bf71                	j	ffffffffc02015e8 <default_free_pages+0x70>
            p->property += base->property;
ffffffffc020164e:	491c                	lw	a5,16(a0)
ffffffffc0201650:	9dbd                	addw	a1,a1,a5
ffffffffc0201652:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0201656:	57f5                	li	a5,-3
ffffffffc0201658:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc020165c:	01853803          	ld	a6,24(a0)
ffffffffc0201660:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0201662:	8532                	mv	a0,a2
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0201664:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0201668:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc020166a:	0105b023          	sd	a6,0(a1)
ffffffffc020166e:	b77d                	j	ffffffffc020161c <default_free_pages+0xa4>
ffffffffc0201670:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201672:	873e                	mv	a4,a5
ffffffffc0201674:	bf41                	j	ffffffffc0201604 <default_free_pages+0x8c>
}
ffffffffc0201676:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201678:	e390                	sd	a2,0(a5)
ffffffffc020167a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020167c:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020167e:	ed1c                	sd	a5,24(a0)
ffffffffc0201680:	0141                	addi	sp,sp,16
ffffffffc0201682:	8082                	ret
            base->property += p->property;
ffffffffc0201684:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201688:	ff078693          	addi	a3,a5,-16
ffffffffc020168c:	9e39                	addw	a2,a2,a4
ffffffffc020168e:	c910                	sw	a2,16(a0)
ffffffffc0201690:	5775                	li	a4,-3
ffffffffc0201692:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201696:	6398                	ld	a4,0(a5)
ffffffffc0201698:	679c                	ld	a5,8(a5)
}
ffffffffc020169a:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020169c:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020169e:	e398                	sd	a4,0(a5)
ffffffffc02016a0:	0141                	addi	sp,sp,16
ffffffffc02016a2:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02016a4:	00003697          	auipc	a3,0x3
ffffffffc02016a8:	5cc68693          	addi	a3,a3,1484 # ffffffffc0204c70 <commands+0xb78>
ffffffffc02016ac:	00003617          	auipc	a2,0x3
ffffffffc02016b0:	26460613          	addi	a2,a2,612 # ffffffffc0204910 <commands+0x818>
ffffffffc02016b4:	08300593          	li	a1,131
ffffffffc02016b8:	00003517          	auipc	a0,0x3
ffffffffc02016bc:	27050513          	addi	a0,a0,624 # ffffffffc0204928 <commands+0x830>
ffffffffc02016c0:	d9bfe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(n > 0);
ffffffffc02016c4:	00003697          	auipc	a3,0x3
ffffffffc02016c8:	5a468693          	addi	a3,a3,1444 # ffffffffc0204c68 <commands+0xb70>
ffffffffc02016cc:	00003617          	auipc	a2,0x3
ffffffffc02016d0:	24460613          	addi	a2,a2,580 # ffffffffc0204910 <commands+0x818>
ffffffffc02016d4:	08000593          	li	a1,128
ffffffffc02016d8:	00003517          	auipc	a0,0x3
ffffffffc02016dc:	25050513          	addi	a0,a0,592 # ffffffffc0204928 <commands+0x830>
ffffffffc02016e0:	d7bfe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc02016e4 <default_alloc_pages>:
    assert(n > 0);
ffffffffc02016e4:	c941                	beqz	a0,ffffffffc0201774 <default_alloc_pages+0x90>
    if (n > nr_free) {
ffffffffc02016e6:	00008597          	auipc	a1,0x8
ffffffffc02016ea:	d4a58593          	addi	a1,a1,-694 # ffffffffc0209430 <free_area>
ffffffffc02016ee:	0105a803          	lw	a6,16(a1)
ffffffffc02016f2:	872a                	mv	a4,a0
ffffffffc02016f4:	02081793          	slli	a5,a6,0x20
ffffffffc02016f8:	9381                	srli	a5,a5,0x20
ffffffffc02016fa:	00a7ee63          	bltu	a5,a0,ffffffffc0201716 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc02016fe:	87ae                	mv	a5,a1
ffffffffc0201700:	a801                	j	ffffffffc0201710 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201702:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201706:	02069613          	slli	a2,a3,0x20
ffffffffc020170a:	9201                	srli	a2,a2,0x20
ffffffffc020170c:	00e67763          	bgeu	a2,a4,ffffffffc020171a <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201710:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201712:	feb798e3          	bne	a5,a1,ffffffffc0201702 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201716:	4501                	li	a0,0
}
ffffffffc0201718:	8082                	ret
    return listelm->prev;
ffffffffc020171a:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc020171e:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201722:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201726:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc020172a:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc020172e:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc0201732:	02c77863          	bgeu	a4,a2,ffffffffc0201762 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0201736:	071a                	slli	a4,a4,0x6
ffffffffc0201738:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc020173a:	41c686bb          	subw	a3,a3,t3
ffffffffc020173e:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201740:	00870613          	addi	a2,a4,8
ffffffffc0201744:	4689                	li	a3,2
ffffffffc0201746:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc020174a:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc020174e:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0201752:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0201756:	e290                	sd	a2,0(a3)
ffffffffc0201758:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc020175c:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc020175e:	01173c23          	sd	a7,24(a4)
ffffffffc0201762:	41c8083b          	subw	a6,a6,t3
ffffffffc0201766:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc020176a:	5775                	li	a4,-3
ffffffffc020176c:	17c1                	addi	a5,a5,-16
ffffffffc020176e:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0201772:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc0201774:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0201776:	00003697          	auipc	a3,0x3
ffffffffc020177a:	4f268693          	addi	a3,a3,1266 # ffffffffc0204c68 <commands+0xb70>
ffffffffc020177e:	00003617          	auipc	a2,0x3
ffffffffc0201782:	19260613          	addi	a2,a2,402 # ffffffffc0204910 <commands+0x818>
ffffffffc0201786:	06200593          	li	a1,98
ffffffffc020178a:	00003517          	auipc	a0,0x3
ffffffffc020178e:	19e50513          	addi	a0,a0,414 # ffffffffc0204928 <commands+0x830>
default_alloc_pages(size_t n) {
ffffffffc0201792:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201794:	cc7fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201798 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201798:	1141                	addi	sp,sp,-16
ffffffffc020179a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020179c:	c5f1                	beqz	a1,ffffffffc0201868 <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc020179e:	00659693          	slli	a3,a1,0x6
ffffffffc02017a2:	96aa                	add	a3,a3,a0
ffffffffc02017a4:	87aa                	mv	a5,a0
ffffffffc02017a6:	00d50f63          	beq	a0,a3,ffffffffc02017c4 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02017aa:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc02017ac:	8b05                	andi	a4,a4,1
ffffffffc02017ae:	cf49                	beqz	a4,ffffffffc0201848 <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc02017b0:	0007a823          	sw	zero,16(a5)
ffffffffc02017b4:	0007b423          	sd	zero,8(a5)
ffffffffc02017b8:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc02017bc:	04078793          	addi	a5,a5,64
ffffffffc02017c0:	fed795e3          	bne	a5,a3,ffffffffc02017aa <default_init_memmap+0x12>
    base->property = n;
ffffffffc02017c4:	2581                	sext.w	a1,a1
ffffffffc02017c6:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02017c8:	4789                	li	a5,2
ffffffffc02017ca:	00850713          	addi	a4,a0,8
ffffffffc02017ce:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc02017d2:	00008697          	auipc	a3,0x8
ffffffffc02017d6:	c5e68693          	addi	a3,a3,-930 # ffffffffc0209430 <free_area>
ffffffffc02017da:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc02017dc:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc02017de:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc02017e2:	9db9                	addw	a1,a1,a4
ffffffffc02017e4:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc02017e6:	04d78a63          	beq	a5,a3,ffffffffc020183a <default_init_memmap+0xa2>
            struct Page* page = le2page(le, page_link);
ffffffffc02017ea:	fe878713          	addi	a4,a5,-24
ffffffffc02017ee:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc02017f2:	4581                	li	a1,0
            if (base < page) {
ffffffffc02017f4:	00e56a63          	bltu	a0,a4,ffffffffc0201808 <default_init_memmap+0x70>
    return listelm->next;
ffffffffc02017f8:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc02017fa:	02d70263          	beq	a4,a3,ffffffffc020181e <default_init_memmap+0x86>
    for (; p != base + n; p ++) {
ffffffffc02017fe:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201800:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201804:	fee57ae3          	bgeu	a0,a4,ffffffffc02017f8 <default_init_memmap+0x60>
ffffffffc0201808:	c199                	beqz	a1,ffffffffc020180e <default_init_memmap+0x76>
ffffffffc020180a:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020180e:	6398                	ld	a4,0(a5)
}
ffffffffc0201810:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0201812:	e390                	sd	a2,0(a5)
ffffffffc0201814:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201816:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201818:	ed18                	sd	a4,24(a0)
ffffffffc020181a:	0141                	addi	sp,sp,16
ffffffffc020181c:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020181e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201820:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0201822:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0201824:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0201826:	00d70663          	beq	a4,a3,ffffffffc0201832 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc020182a:	8832                	mv	a6,a2
ffffffffc020182c:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc020182e:	87ba                	mv	a5,a4
ffffffffc0201830:	bfc1                	j	ffffffffc0201800 <default_init_memmap+0x68>
}
ffffffffc0201832:	60a2                	ld	ra,8(sp)
ffffffffc0201834:	e290                	sd	a2,0(a3)
ffffffffc0201836:	0141                	addi	sp,sp,16
ffffffffc0201838:	8082                	ret
ffffffffc020183a:	60a2                	ld	ra,8(sp)
ffffffffc020183c:	e390                	sd	a2,0(a5)
ffffffffc020183e:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0201840:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201842:	ed1c                	sd	a5,24(a0)
ffffffffc0201844:	0141                	addi	sp,sp,16
ffffffffc0201846:	8082                	ret
        assert(PageReserved(p));
ffffffffc0201848:	00003697          	auipc	a3,0x3
ffffffffc020184c:	45068693          	addi	a3,a3,1104 # ffffffffc0204c98 <commands+0xba0>
ffffffffc0201850:	00003617          	auipc	a2,0x3
ffffffffc0201854:	0c060613          	addi	a2,a2,192 # ffffffffc0204910 <commands+0x818>
ffffffffc0201858:	04900593          	li	a1,73
ffffffffc020185c:	00003517          	auipc	a0,0x3
ffffffffc0201860:	0cc50513          	addi	a0,a0,204 # ffffffffc0204928 <commands+0x830>
ffffffffc0201864:	bf7fe0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(n > 0);
ffffffffc0201868:	00003697          	auipc	a3,0x3
ffffffffc020186c:	40068693          	addi	a3,a3,1024 # ffffffffc0204c68 <commands+0xb70>
ffffffffc0201870:	00003617          	auipc	a2,0x3
ffffffffc0201874:	0a060613          	addi	a2,a2,160 # ffffffffc0204910 <commands+0x818>
ffffffffc0201878:	04600593          	li	a1,70
ffffffffc020187c:	00003517          	auipc	a0,0x3
ffffffffc0201880:	0ac50513          	addi	a0,a0,172 # ffffffffc0204928 <commands+0x830>
ffffffffc0201884:	bd7fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201888 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0201888:	c94d                	beqz	a0,ffffffffc020193a <slob_free+0xb2>
{
ffffffffc020188a:	1141                	addi	sp,sp,-16
ffffffffc020188c:	e022                	sd	s0,0(sp)
ffffffffc020188e:	e406                	sd	ra,8(sp)
ffffffffc0201890:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0201892:	e9c1                	bnez	a1,ffffffffc0201922 <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201894:	100027f3          	csrr	a5,sstatus
ffffffffc0201898:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020189a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020189c:	ebd9                	bnez	a5,ffffffffc0201932 <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020189e:	00007617          	auipc	a2,0x7
ffffffffc02018a2:	78260613          	addi	a2,a2,1922 # ffffffffc0209020 <slobfree>
ffffffffc02018a6:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018a8:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02018aa:	679c                	ld	a5,8(a5)
ffffffffc02018ac:	02877a63          	bgeu	a4,s0,ffffffffc02018e0 <slob_free+0x58>
ffffffffc02018b0:	00f46463          	bltu	s0,a5,ffffffffc02018b8 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018b4:	fef76ae3          	bltu	a4,a5,ffffffffc02018a8 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc02018b8:	400c                	lw	a1,0(s0)
ffffffffc02018ba:	00459693          	slli	a3,a1,0x4
ffffffffc02018be:	96a2                	add	a3,a3,s0
ffffffffc02018c0:	02d78a63          	beq	a5,a3,ffffffffc02018f4 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc02018c4:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc02018c6:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02018c8:	00469793          	slli	a5,a3,0x4
ffffffffc02018cc:	97ba                	add	a5,a5,a4
ffffffffc02018ce:	02f40e63          	beq	s0,a5,ffffffffc020190a <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc02018d2:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc02018d4:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc02018d6:	e129                	bnez	a0,ffffffffc0201918 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02018d8:	60a2                	ld	ra,8(sp)
ffffffffc02018da:	6402                	ld	s0,0(sp)
ffffffffc02018dc:	0141                	addi	sp,sp,16
ffffffffc02018de:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02018e0:	fcf764e3          	bltu	a4,a5,ffffffffc02018a8 <slob_free+0x20>
ffffffffc02018e4:	fcf472e3          	bgeu	s0,a5,ffffffffc02018a8 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc02018e8:	400c                	lw	a1,0(s0)
ffffffffc02018ea:	00459693          	slli	a3,a1,0x4
ffffffffc02018ee:	96a2                	add	a3,a3,s0
ffffffffc02018f0:	fcd79ae3          	bne	a5,a3,ffffffffc02018c4 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc02018f4:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02018f6:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02018f8:	9db5                	addw	a1,a1,a3
ffffffffc02018fa:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc02018fc:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc02018fe:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0201900:	00469793          	slli	a5,a3,0x4
ffffffffc0201904:	97ba                	add	a5,a5,a4
ffffffffc0201906:	fcf416e3          	bne	s0,a5,ffffffffc02018d2 <slob_free+0x4a>
		cur->units += b->units;
ffffffffc020190a:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc020190c:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc020190e:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0201910:	9ebd                	addw	a3,a3,a5
ffffffffc0201912:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0201914:	e70c                	sd	a1,8(a4)
ffffffffc0201916:	d169                	beqz	a0,ffffffffc02018d8 <slob_free+0x50>
}
ffffffffc0201918:	6402                	ld	s0,0(sp)
ffffffffc020191a:	60a2                	ld	ra,8(sp)
ffffffffc020191c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020191e:	80cff06f          	j	ffffffffc020092a <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0201922:	25bd                	addiw	a1,a1,15
ffffffffc0201924:	8191                	srli	a1,a1,0x4
ffffffffc0201926:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201928:	100027f3          	csrr	a5,sstatus
ffffffffc020192c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020192e:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201930:	d7bd                	beqz	a5,ffffffffc020189e <slob_free+0x16>
        intr_disable();
ffffffffc0201932:	ffffe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc0201936:	4505                	li	a0,1
ffffffffc0201938:	b79d                	j	ffffffffc020189e <slob_free+0x16>
ffffffffc020193a:	8082                	ret

ffffffffc020193c <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc020193c:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020193e:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201940:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0201944:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0201946:	34e000ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
	if (!page)
ffffffffc020194a:	c91d                	beqz	a0,ffffffffc0201980 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc020194c:	0000c697          	auipc	a3,0xc
ffffffffc0201950:	b6c6b683          	ld	a3,-1172(a3) # ffffffffc020d4b8 <pages>
ffffffffc0201954:	8d15                	sub	a0,a0,a3
ffffffffc0201956:	8519                	srai	a0,a0,0x6
ffffffffc0201958:	00004697          	auipc	a3,0x4
ffffffffc020195c:	0806b683          	ld	a3,128(a3) # ffffffffc02059d8 <nbase>
ffffffffc0201960:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0201962:	00c51793          	slli	a5,a0,0xc
ffffffffc0201966:	83b1                	srli	a5,a5,0xc
ffffffffc0201968:	0000c717          	auipc	a4,0xc
ffffffffc020196c:	b4873703          	ld	a4,-1208(a4) # ffffffffc020d4b0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0201970:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc0201972:	00e7fa63          	bgeu	a5,a4,ffffffffc0201986 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201976:	0000c697          	auipc	a3,0xc
ffffffffc020197a:	b526b683          	ld	a3,-1198(a3) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc020197e:	9536                	add	a0,a0,a3
}
ffffffffc0201980:	60a2                	ld	ra,8(sp)
ffffffffc0201982:	0141                	addi	sp,sp,16
ffffffffc0201984:	8082                	ret
ffffffffc0201986:	86aa                	mv	a3,a0
ffffffffc0201988:	00003617          	auipc	a2,0x3
ffffffffc020198c:	37060613          	addi	a2,a2,880 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0201990:	07100593          	li	a1,113
ffffffffc0201994:	00003517          	auipc	a0,0x3
ffffffffc0201998:	38c50513          	addi	a0,a0,908 # ffffffffc0204d20 <default_pmm_manager+0x60>
ffffffffc020199c:	abffe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc02019a0 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc02019a0:	1101                	addi	sp,sp,-32
ffffffffc02019a2:	ec06                	sd	ra,24(sp)
ffffffffc02019a4:	e822                	sd	s0,16(sp)
ffffffffc02019a6:	e426                	sd	s1,8(sp)
ffffffffc02019a8:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc02019aa:	01050713          	addi	a4,a0,16
ffffffffc02019ae:	6785                	lui	a5,0x1
ffffffffc02019b0:	0cf77363          	bgeu	a4,a5,ffffffffc0201a76 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc02019b4:	00f50493          	addi	s1,a0,15
ffffffffc02019b8:	8091                	srli	s1,s1,0x4
ffffffffc02019ba:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02019bc:	10002673          	csrr	a2,sstatus
ffffffffc02019c0:	8a09                	andi	a2,a2,2
ffffffffc02019c2:	e25d                	bnez	a2,ffffffffc0201a68 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc02019c4:	00007917          	auipc	s2,0x7
ffffffffc02019c8:	65c90913          	addi	s2,s2,1628 # ffffffffc0209020 <slobfree>
ffffffffc02019cc:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02019d0:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc02019d2:	4398                	lw	a4,0(a5)
ffffffffc02019d4:	08975e63          	bge	a4,s1,ffffffffc0201a70 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc02019d8:	00d78b63          	beq	a5,a3,ffffffffc02019ee <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02019dc:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc02019de:	4018                	lw	a4,0(s0)
ffffffffc02019e0:	02975a63          	bge	a4,s1,ffffffffc0201a14 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc02019e4:	00093683          	ld	a3,0(s2)
ffffffffc02019e8:	87a2                	mv	a5,s0
ffffffffc02019ea:	fed799e3          	bne	a5,a3,ffffffffc02019dc <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc02019ee:	ee31                	bnez	a2,ffffffffc0201a4a <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc02019f0:	4501                	li	a0,0
ffffffffc02019f2:	f4bff0ef          	jal	ra,ffffffffc020193c <__slob_get_free_pages.constprop.0>
ffffffffc02019f6:	842a                	mv	s0,a0
			if (!cur)
ffffffffc02019f8:	cd05                	beqz	a0,ffffffffc0201a30 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc02019fa:	6585                	lui	a1,0x1
ffffffffc02019fc:	e8dff0ef          	jal	ra,ffffffffc0201888 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201a00:	10002673          	csrr	a2,sstatus
ffffffffc0201a04:	8a09                	andi	a2,a2,2
ffffffffc0201a06:	ee05                	bnez	a2,ffffffffc0201a3e <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0201a08:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0201a0c:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0201a0e:	4018                	lw	a4,0(s0)
ffffffffc0201a10:	fc974ae3          	blt	a4,s1,ffffffffc02019e4 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0201a14:	04e48763          	beq	s1,a4,ffffffffc0201a62 <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0201a18:	00449693          	slli	a3,s1,0x4
ffffffffc0201a1c:	96a2                	add	a3,a3,s0
ffffffffc0201a1e:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc0201a20:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc0201a22:	9f05                	subw	a4,a4,s1
ffffffffc0201a24:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0201a26:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0201a28:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0201a2a:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc0201a2e:	e20d                	bnez	a2,ffffffffc0201a50 <slob_alloc.constprop.0+0xb0>
}
ffffffffc0201a30:	60e2                	ld	ra,24(sp)
ffffffffc0201a32:	8522                	mv	a0,s0
ffffffffc0201a34:	6442                	ld	s0,16(sp)
ffffffffc0201a36:	64a2                	ld	s1,8(sp)
ffffffffc0201a38:	6902                	ld	s2,0(sp)
ffffffffc0201a3a:	6105                	addi	sp,sp,32
ffffffffc0201a3c:	8082                	ret
        intr_disable();
ffffffffc0201a3e:	ef3fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
			cur = slobfree;
ffffffffc0201a42:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0201a46:	4605                	li	a2,1
ffffffffc0201a48:	b7d1                	j	ffffffffc0201a0c <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0201a4a:	ee1fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201a4e:	b74d                	j	ffffffffc02019f0 <slob_alloc.constprop.0+0x50>
ffffffffc0201a50:	edbfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
}
ffffffffc0201a54:	60e2                	ld	ra,24(sp)
ffffffffc0201a56:	8522                	mv	a0,s0
ffffffffc0201a58:	6442                	ld	s0,16(sp)
ffffffffc0201a5a:	64a2                	ld	s1,8(sp)
ffffffffc0201a5c:	6902                	ld	s2,0(sp)
ffffffffc0201a5e:	6105                	addi	sp,sp,32
ffffffffc0201a60:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc0201a62:	6418                	ld	a4,8(s0)
ffffffffc0201a64:	e798                	sd	a4,8(a5)
ffffffffc0201a66:	b7d1                	j	ffffffffc0201a2a <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0201a68:	ec9fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc0201a6c:	4605                	li	a2,1
ffffffffc0201a6e:	bf99                	j	ffffffffc02019c4 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0201a70:	843e                	mv	s0,a5
ffffffffc0201a72:	87b6                	mv	a5,a3
ffffffffc0201a74:	b745                	j	ffffffffc0201a14 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0201a76:	00003697          	auipc	a3,0x3
ffffffffc0201a7a:	2ba68693          	addi	a3,a3,698 # ffffffffc0204d30 <default_pmm_manager+0x70>
ffffffffc0201a7e:	00003617          	auipc	a2,0x3
ffffffffc0201a82:	e9260613          	addi	a2,a2,-366 # ffffffffc0204910 <commands+0x818>
ffffffffc0201a86:	06300593          	li	a1,99
ffffffffc0201a8a:	00003517          	auipc	a0,0x3
ffffffffc0201a8e:	2c650513          	addi	a0,a0,710 # ffffffffc0204d50 <default_pmm_manager+0x90>
ffffffffc0201a92:	9c9fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201a96 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0201a96:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0201a98:	00003517          	auipc	a0,0x3
ffffffffc0201a9c:	2d050513          	addi	a0,a0,720 # ffffffffc0204d68 <default_pmm_manager+0xa8>
{
ffffffffc0201aa0:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc0201aa2:	ef2fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc0201aa6:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201aa8:	00003517          	auipc	a0,0x3
ffffffffc0201aac:	2d850513          	addi	a0,a0,728 # ffffffffc0204d80 <default_pmm_manager+0xc0>
}
ffffffffc0201ab0:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0201ab2:	ee2fe06f          	j	ffffffffc0200194 <cprintf>

ffffffffc0201ab6 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0201ab6:	1101                	addi	sp,sp,-32
ffffffffc0201ab8:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201aba:	6905                	lui	s2,0x1
{
ffffffffc0201abc:	e822                	sd	s0,16(sp)
ffffffffc0201abe:	ec06                	sd	ra,24(sp)
ffffffffc0201ac0:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201ac2:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
{
ffffffffc0201ac6:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0201ac8:	04a7f963          	bgeu	a5,a0,ffffffffc0201b1a <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0201acc:	4561                	li	a0,24
ffffffffc0201ace:	ed3ff0ef          	jal	ra,ffffffffc02019a0 <slob_alloc.constprop.0>
ffffffffc0201ad2:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0201ad4:	c929                	beqz	a0,ffffffffc0201b26 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0201ad6:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0201ada:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0201adc:	00f95763          	bge	s2,a5,ffffffffc0201aea <kmalloc+0x34>
ffffffffc0201ae0:	6705                	lui	a4,0x1
ffffffffc0201ae2:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0201ae4:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0201ae6:	fef74ee3          	blt	a4,a5,ffffffffc0201ae2 <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0201aea:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0201aec:	e51ff0ef          	jal	ra,ffffffffc020193c <__slob_get_free_pages.constprop.0>
ffffffffc0201af0:	e488                	sd	a0,8(s1)
ffffffffc0201af2:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0201af4:	c525                	beqz	a0,ffffffffc0201b5c <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201af6:	100027f3          	csrr	a5,sstatus
ffffffffc0201afa:	8b89                	andi	a5,a5,2
ffffffffc0201afc:	ef8d                	bnez	a5,ffffffffc0201b36 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc0201afe:	0000c797          	auipc	a5,0xc
ffffffffc0201b02:	99a78793          	addi	a5,a5,-1638 # ffffffffc020d498 <bigblocks>
ffffffffc0201b06:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201b08:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201b0a:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0201b0c:	60e2                	ld	ra,24(sp)
ffffffffc0201b0e:	8522                	mv	a0,s0
ffffffffc0201b10:	6442                	ld	s0,16(sp)
ffffffffc0201b12:	64a2                	ld	s1,8(sp)
ffffffffc0201b14:	6902                	ld	s2,0(sp)
ffffffffc0201b16:	6105                	addi	sp,sp,32
ffffffffc0201b18:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0201b1a:	0541                	addi	a0,a0,16
ffffffffc0201b1c:	e85ff0ef          	jal	ra,ffffffffc02019a0 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc0201b20:	01050413          	addi	s0,a0,16
ffffffffc0201b24:	f565                	bnez	a0,ffffffffc0201b0c <kmalloc+0x56>
ffffffffc0201b26:	4401                	li	s0,0
}
ffffffffc0201b28:	60e2                	ld	ra,24(sp)
ffffffffc0201b2a:	8522                	mv	a0,s0
ffffffffc0201b2c:	6442                	ld	s0,16(sp)
ffffffffc0201b2e:	64a2                	ld	s1,8(sp)
ffffffffc0201b30:	6902                	ld	s2,0(sp)
ffffffffc0201b32:	6105                	addi	sp,sp,32
ffffffffc0201b34:	8082                	ret
        intr_disable();
ffffffffc0201b36:	dfbfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
		bb->next = bigblocks;
ffffffffc0201b3a:	0000c797          	auipc	a5,0xc
ffffffffc0201b3e:	95e78793          	addi	a5,a5,-1698 # ffffffffc020d498 <bigblocks>
ffffffffc0201b42:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0201b44:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0201b46:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0201b48:	de3fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
		return bb->pages;
ffffffffc0201b4c:	6480                	ld	s0,8(s1)
}
ffffffffc0201b4e:	60e2                	ld	ra,24(sp)
ffffffffc0201b50:	64a2                	ld	s1,8(sp)
ffffffffc0201b52:	8522                	mv	a0,s0
ffffffffc0201b54:	6442                	ld	s0,16(sp)
ffffffffc0201b56:	6902                	ld	s2,0(sp)
ffffffffc0201b58:	6105                	addi	sp,sp,32
ffffffffc0201b5a:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0201b5c:	45e1                	li	a1,24
ffffffffc0201b5e:	8526                	mv	a0,s1
ffffffffc0201b60:	d29ff0ef          	jal	ra,ffffffffc0201888 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0201b64:	b765                	j	ffffffffc0201b0c <kmalloc+0x56>

ffffffffc0201b66 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0201b66:	c169                	beqz	a0,ffffffffc0201c28 <kfree+0xc2>
{
ffffffffc0201b68:	1101                	addi	sp,sp,-32
ffffffffc0201b6a:	e822                	sd	s0,16(sp)
ffffffffc0201b6c:	ec06                	sd	ra,24(sp)
ffffffffc0201b6e:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc0201b70:	03451793          	slli	a5,a0,0x34
ffffffffc0201b74:	842a                	mv	s0,a0
ffffffffc0201b76:	e3d9                	bnez	a5,ffffffffc0201bfc <kfree+0x96>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201b78:	100027f3          	csrr	a5,sstatus
ffffffffc0201b7c:	8b89                	andi	a5,a5,2
ffffffffc0201b7e:	e7d9                	bnez	a5,ffffffffc0201c0c <kfree+0xa6>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201b80:	0000c797          	auipc	a5,0xc
ffffffffc0201b84:	9187b783          	ld	a5,-1768(a5) # ffffffffc020d498 <bigblocks>
    return 0;
ffffffffc0201b88:	4601                	li	a2,0
ffffffffc0201b8a:	cbad                	beqz	a5,ffffffffc0201bfc <kfree+0x96>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0201b8c:	0000c697          	auipc	a3,0xc
ffffffffc0201b90:	90c68693          	addi	a3,a3,-1780 # ffffffffc020d498 <bigblocks>
ffffffffc0201b94:	a021                	j	ffffffffc0201b9c <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201b96:	01048693          	addi	a3,s1,16
ffffffffc0201b9a:	c3a5                	beqz	a5,ffffffffc0201bfa <kfree+0x94>
		{
			if (bb->pages == block)
ffffffffc0201b9c:	6798                	ld	a4,8(a5)
ffffffffc0201b9e:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc0201ba0:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc0201ba2:	fe871ae3          	bne	a4,s0,ffffffffc0201b96 <kfree+0x30>
				*last = bb->next;
ffffffffc0201ba6:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc0201ba8:	ee2d                	bnez	a2,ffffffffc0201c22 <kfree+0xbc>
    return pa2page(PADDR(kva));
ffffffffc0201baa:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc0201bae:	4098                	lw	a4,0(s1)
ffffffffc0201bb0:	08f46963          	bltu	s0,a5,ffffffffc0201c42 <kfree+0xdc>
ffffffffc0201bb4:	0000c697          	auipc	a3,0xc
ffffffffc0201bb8:	9146b683          	ld	a3,-1772(a3) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201bbc:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc0201bbe:	8031                	srli	s0,s0,0xc
ffffffffc0201bc0:	0000c797          	auipc	a5,0xc
ffffffffc0201bc4:	8f07b783          	ld	a5,-1808(a5) # ffffffffc020d4b0 <npage>
ffffffffc0201bc8:	06f47163          	bgeu	s0,a5,ffffffffc0201c2a <kfree+0xc4>
    return &pages[PPN(pa) - nbase];
ffffffffc0201bcc:	00004517          	auipc	a0,0x4
ffffffffc0201bd0:	e0c53503          	ld	a0,-500(a0) # ffffffffc02059d8 <nbase>
ffffffffc0201bd4:	8c09                	sub	s0,s0,a0
ffffffffc0201bd6:	041a                	slli	s0,s0,0x6
	free_pages(kva2page((void *)kva), 1 << order);
ffffffffc0201bd8:	0000c517          	auipc	a0,0xc
ffffffffc0201bdc:	8e053503          	ld	a0,-1824(a0) # ffffffffc020d4b8 <pages>
ffffffffc0201be0:	4585                	li	a1,1
ffffffffc0201be2:	9522                	add	a0,a0,s0
ffffffffc0201be4:	00e595bb          	sllw	a1,a1,a4
ffffffffc0201be8:	0ea000ef          	jal	ra,ffffffffc0201cd2 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0201bec:	6442                	ld	s0,16(sp)
ffffffffc0201bee:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bf0:	8526                	mv	a0,s1
}
ffffffffc0201bf2:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0201bf4:	45e1                	li	a1,24
}
ffffffffc0201bf6:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201bf8:	b941                	j	ffffffffc0201888 <slob_free>
ffffffffc0201bfa:	e20d                	bnez	a2,ffffffffc0201c1c <kfree+0xb6>
ffffffffc0201bfc:	ff040513          	addi	a0,s0,-16
}
ffffffffc0201c00:	6442                	ld	s0,16(sp)
ffffffffc0201c02:	60e2                	ld	ra,24(sp)
ffffffffc0201c04:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c06:	4581                	li	a1,0
}
ffffffffc0201c08:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0201c0a:	b9bd                	j	ffffffffc0201888 <slob_free>
        intr_disable();
ffffffffc0201c0c:	d25fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0201c10:	0000c797          	auipc	a5,0xc
ffffffffc0201c14:	8887b783          	ld	a5,-1912(a5) # ffffffffc020d498 <bigblocks>
        return 1;
ffffffffc0201c18:	4605                	li	a2,1
ffffffffc0201c1a:	fbad                	bnez	a5,ffffffffc0201b8c <kfree+0x26>
        intr_enable();
ffffffffc0201c1c:	d0ffe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201c20:	bff1                	j	ffffffffc0201bfc <kfree+0x96>
ffffffffc0201c22:	d09fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201c26:	b751                	j	ffffffffc0201baa <kfree+0x44>
ffffffffc0201c28:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc0201c2a:	00003617          	auipc	a2,0x3
ffffffffc0201c2e:	19e60613          	addi	a2,a2,414 # ffffffffc0204dc8 <default_pmm_manager+0x108>
ffffffffc0201c32:	06900593          	li	a1,105
ffffffffc0201c36:	00003517          	auipc	a0,0x3
ffffffffc0201c3a:	0ea50513          	addi	a0,a0,234 # ffffffffc0204d20 <default_pmm_manager+0x60>
ffffffffc0201c3e:	81dfe0ef          	jal	ra,ffffffffc020045a <__panic>
    return pa2page(PADDR(kva));
ffffffffc0201c42:	86a2                	mv	a3,s0
ffffffffc0201c44:	00003617          	auipc	a2,0x3
ffffffffc0201c48:	15c60613          	addi	a2,a2,348 # ffffffffc0204da0 <default_pmm_manager+0xe0>
ffffffffc0201c4c:	07700593          	li	a1,119
ffffffffc0201c50:	00003517          	auipc	a0,0x3
ffffffffc0201c54:	0d050513          	addi	a0,a0,208 # ffffffffc0204d20 <default_pmm_manager+0x60>
ffffffffc0201c58:	803fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c5c <pa2page.part.0>:
pa2page(uintptr_t pa)
ffffffffc0201c5c:	1141                	addi	sp,sp,-16
        panic("pa2page called with invalid pa");
ffffffffc0201c5e:	00003617          	auipc	a2,0x3
ffffffffc0201c62:	16a60613          	addi	a2,a2,362 # ffffffffc0204dc8 <default_pmm_manager+0x108>
ffffffffc0201c66:	06900593          	li	a1,105
ffffffffc0201c6a:	00003517          	auipc	a0,0x3
ffffffffc0201c6e:	0b650513          	addi	a0,a0,182 # ffffffffc0204d20 <default_pmm_manager+0x60>
pa2page(uintptr_t pa)
ffffffffc0201c72:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0201c74:	fe6fe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c78 <pte2page.part.0>:
pte2page(pte_t pte)
ffffffffc0201c78:	1141                	addi	sp,sp,-16
        panic("pte2page called with invalid pte");
ffffffffc0201c7a:	00003617          	auipc	a2,0x3
ffffffffc0201c7e:	16e60613          	addi	a2,a2,366 # ffffffffc0204de8 <default_pmm_manager+0x128>
ffffffffc0201c82:	07f00593          	li	a1,127
ffffffffc0201c86:	00003517          	auipc	a0,0x3
ffffffffc0201c8a:	09a50513          	addi	a0,a0,154 # ffffffffc0204d20 <default_pmm_manager+0x60>
pte2page(pte_t pte)
ffffffffc0201c8e:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0201c90:	fcafe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201c94 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201c94:	100027f3          	csrr	a5,sstatus
ffffffffc0201c98:	8b89                	andi	a5,a5,2
ffffffffc0201c9a:	e799                	bnez	a5,ffffffffc0201ca8 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0201c9c:	0000c797          	auipc	a5,0xc
ffffffffc0201ca0:	8247b783          	ld	a5,-2012(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201ca4:	6f9c                	ld	a5,24(a5)
ffffffffc0201ca6:	8782                	jr	a5
{
ffffffffc0201ca8:	1141                	addi	sp,sp,-16
ffffffffc0201caa:	e406                	sd	ra,8(sp)
ffffffffc0201cac:	e022                	sd	s0,0(sp)
ffffffffc0201cae:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0201cb0:	c81fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201cb4:	0000c797          	auipc	a5,0xc
ffffffffc0201cb8:	80c7b783          	ld	a5,-2036(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201cbc:	6f9c                	ld	a5,24(a5)
ffffffffc0201cbe:	8522                	mv	a0,s0
ffffffffc0201cc0:	9782                	jalr	a5
ffffffffc0201cc2:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201cc4:	c67fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201cc8:	60a2                	ld	ra,8(sp)
ffffffffc0201cca:	8522                	mv	a0,s0
ffffffffc0201ccc:	6402                	ld	s0,0(sp)
ffffffffc0201cce:	0141                	addi	sp,sp,16
ffffffffc0201cd0:	8082                	ret

ffffffffc0201cd2 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201cd2:	100027f3          	csrr	a5,sstatus
ffffffffc0201cd6:	8b89                	andi	a5,a5,2
ffffffffc0201cd8:	e799                	bnez	a5,ffffffffc0201ce6 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201cda:	0000b797          	auipc	a5,0xb
ffffffffc0201cde:	7e67b783          	ld	a5,2022(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201ce2:	739c                	ld	a5,32(a5)
ffffffffc0201ce4:	8782                	jr	a5
{
ffffffffc0201ce6:	1101                	addi	sp,sp,-32
ffffffffc0201ce8:	ec06                	sd	ra,24(sp)
ffffffffc0201cea:	e822                	sd	s0,16(sp)
ffffffffc0201cec:	e426                	sd	s1,8(sp)
ffffffffc0201cee:	842a                	mv	s0,a0
ffffffffc0201cf0:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201cf2:	c3ffe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201cf6:	0000b797          	auipc	a5,0xb
ffffffffc0201cfa:	7ca7b783          	ld	a5,1994(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201cfe:	739c                	ld	a5,32(a5)
ffffffffc0201d00:	85a6                	mv	a1,s1
ffffffffc0201d02:	8522                	mv	a0,s0
ffffffffc0201d04:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201d06:	6442                	ld	s0,16(sp)
ffffffffc0201d08:	60e2                	ld	ra,24(sp)
ffffffffc0201d0a:	64a2                	ld	s1,8(sp)
ffffffffc0201d0c:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0201d0e:	c1dfe06f          	j	ffffffffc020092a <intr_enable>

ffffffffc0201d12 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d12:	100027f3          	csrr	a5,sstatus
ffffffffc0201d16:	8b89                	andi	a5,a5,2
ffffffffc0201d18:	e799                	bnez	a5,ffffffffc0201d26 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201d1a:	0000b797          	auipc	a5,0xb
ffffffffc0201d1e:	7a67b783          	ld	a5,1958(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d22:	779c                	ld	a5,40(a5)
ffffffffc0201d24:	8782                	jr	a5
{
ffffffffc0201d26:	1141                	addi	sp,sp,-16
ffffffffc0201d28:	e406                	sd	ra,8(sp)
ffffffffc0201d2a:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0201d2c:	c05fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201d30:	0000b797          	auipc	a5,0xb
ffffffffc0201d34:	7907b783          	ld	a5,1936(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d38:	779c                	ld	a5,40(a5)
ffffffffc0201d3a:	9782                	jalr	a5
ffffffffc0201d3c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201d3e:	bedfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0201d42:	60a2                	ld	ra,8(sp)
ffffffffc0201d44:	8522                	mv	a0,s0
ffffffffc0201d46:	6402                	ld	s0,0(sp)
ffffffffc0201d48:	0141                	addi	sp,sp,16
ffffffffc0201d4a:	8082                	ret

ffffffffc0201d4c <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201d4c:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0201d50:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0201d54:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201d56:	078e                	slli	a5,a5,0x3
{
ffffffffc0201d58:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0201d5a:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0201d5e:	6094                	ld	a3,0(s1)
{
ffffffffc0201d60:	f04a                	sd	s2,32(sp)
ffffffffc0201d62:	ec4e                	sd	s3,24(sp)
ffffffffc0201d64:	e852                	sd	s4,16(sp)
ffffffffc0201d66:	fc06                	sd	ra,56(sp)
ffffffffc0201d68:	f822                	sd	s0,48(sp)
ffffffffc0201d6a:	e456                	sd	s5,8(sp)
ffffffffc0201d6c:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0201d6e:	0016f793          	andi	a5,a3,1
{
ffffffffc0201d72:	892e                	mv	s2,a1
ffffffffc0201d74:	8a32                	mv	s4,a2
ffffffffc0201d76:	0000b997          	auipc	s3,0xb
ffffffffc0201d7a:	73a98993          	addi	s3,s3,1850 # ffffffffc020d4b0 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0201d7e:	efbd                	bnez	a5,ffffffffc0201dfc <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201d80:	14060c63          	beqz	a2,ffffffffc0201ed8 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201d84:	100027f3          	csrr	a5,sstatus
ffffffffc0201d88:	8b89                	andi	a5,a5,2
ffffffffc0201d8a:	14079963          	bnez	a5,ffffffffc0201edc <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201d8e:	0000b797          	auipc	a5,0xb
ffffffffc0201d92:	7327b783          	ld	a5,1842(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201d96:	6f9c                	ld	a5,24(a5)
ffffffffc0201d98:	4505                	li	a0,1
ffffffffc0201d9a:	9782                	jalr	a5
ffffffffc0201d9c:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201d9e:	12040d63          	beqz	s0,ffffffffc0201ed8 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201da2:	0000bb17          	auipc	s6,0xb
ffffffffc0201da6:	716b0b13          	addi	s6,s6,1814 # ffffffffc020d4b8 <pages>
ffffffffc0201daa:	000b3503          	ld	a0,0(s6)
ffffffffc0201dae:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201db2:	0000b997          	auipc	s3,0xb
ffffffffc0201db6:	6fe98993          	addi	s3,s3,1790 # ffffffffc020d4b0 <npage>
ffffffffc0201dba:	40a40533          	sub	a0,s0,a0
ffffffffc0201dbe:	8519                	srai	a0,a0,0x6
ffffffffc0201dc0:	9556                	add	a0,a0,s5
ffffffffc0201dc2:	0009b703          	ld	a4,0(s3)
ffffffffc0201dc6:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201dca:	4685                	li	a3,1
ffffffffc0201dcc:	c014                	sw	a3,0(s0)
ffffffffc0201dce:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201dd0:	0532                	slli	a0,a0,0xc
ffffffffc0201dd2:	16e7f763          	bgeu	a5,a4,ffffffffc0201f40 <get_pte+0x1f4>
ffffffffc0201dd6:	0000b797          	auipc	a5,0xb
ffffffffc0201dda:	6f27b783          	ld	a5,1778(a5) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201dde:	6605                	lui	a2,0x1
ffffffffc0201de0:	4581                	li	a1,0
ffffffffc0201de2:	953e                	add	a0,a0,a5
ffffffffc0201de4:	058020ef          	jal	ra,ffffffffc0203e3c <memset>
    return page - pages + nbase;
ffffffffc0201de8:	000b3683          	ld	a3,0(s6)
ffffffffc0201dec:	40d406b3          	sub	a3,s0,a3
ffffffffc0201df0:	8699                	srai	a3,a3,0x6
ffffffffc0201df2:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201df4:	06aa                	slli	a3,a3,0xa
ffffffffc0201df6:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201dfa:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201dfc:	77fd                	lui	a5,0xfffff
ffffffffc0201dfe:	068a                	slli	a3,a3,0x2
ffffffffc0201e00:	0009b703          	ld	a4,0(s3)
ffffffffc0201e04:	8efd                	and	a3,a3,a5
ffffffffc0201e06:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201e0a:	10e7ff63          	bgeu	a5,a4,ffffffffc0201f28 <get_pte+0x1dc>
ffffffffc0201e0e:	0000ba97          	auipc	s5,0xb
ffffffffc0201e12:	6baa8a93          	addi	s5,s5,1722 # ffffffffc020d4c8 <va_pa_offset>
ffffffffc0201e16:	000ab403          	ld	s0,0(s5)
ffffffffc0201e1a:	01595793          	srli	a5,s2,0x15
ffffffffc0201e1e:	1ff7f793          	andi	a5,a5,511
ffffffffc0201e22:	96a2                	add	a3,a3,s0
ffffffffc0201e24:	00379413          	slli	s0,a5,0x3
ffffffffc0201e28:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201e2a:	6014                	ld	a3,0(s0)
ffffffffc0201e2c:	0016f793          	andi	a5,a3,1
ffffffffc0201e30:	ebad                	bnez	a5,ffffffffc0201ea2 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e32:	0a0a0363          	beqz	s4,ffffffffc0201ed8 <get_pte+0x18c>
ffffffffc0201e36:	100027f3          	csrr	a5,sstatus
ffffffffc0201e3a:	8b89                	andi	a5,a5,2
ffffffffc0201e3c:	efcd                	bnez	a5,ffffffffc0201ef6 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e3e:	0000b797          	auipc	a5,0xb
ffffffffc0201e42:	6827b783          	ld	a5,1666(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201e46:	6f9c                	ld	a5,24(a5)
ffffffffc0201e48:	4505                	li	a0,1
ffffffffc0201e4a:	9782                	jalr	a5
ffffffffc0201e4c:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201e4e:	c4c9                	beqz	s1,ffffffffc0201ed8 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201e50:	0000bb17          	auipc	s6,0xb
ffffffffc0201e54:	668b0b13          	addi	s6,s6,1640 # ffffffffc020d4b8 <pages>
ffffffffc0201e58:	000b3503          	ld	a0,0(s6)
ffffffffc0201e5c:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201e60:	0009b703          	ld	a4,0(s3)
ffffffffc0201e64:	40a48533          	sub	a0,s1,a0
ffffffffc0201e68:	8519                	srai	a0,a0,0x6
ffffffffc0201e6a:	9552                	add	a0,a0,s4
ffffffffc0201e6c:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0201e70:	4685                	li	a3,1
ffffffffc0201e72:	c094                	sw	a3,0(s1)
ffffffffc0201e74:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201e76:	0532                	slli	a0,a0,0xc
ffffffffc0201e78:	0ee7f163          	bgeu	a5,a4,ffffffffc0201f5a <get_pte+0x20e>
ffffffffc0201e7c:	000ab783          	ld	a5,0(s5)
ffffffffc0201e80:	6605                	lui	a2,0x1
ffffffffc0201e82:	4581                	li	a1,0
ffffffffc0201e84:	953e                	add	a0,a0,a5
ffffffffc0201e86:	7b7010ef          	jal	ra,ffffffffc0203e3c <memset>
    return page - pages + nbase;
ffffffffc0201e8a:	000b3683          	ld	a3,0(s6)
ffffffffc0201e8e:	40d486b3          	sub	a3,s1,a3
ffffffffc0201e92:	8699                	srai	a3,a3,0x6
ffffffffc0201e94:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201e96:	06aa                	slli	a3,a3,0xa
ffffffffc0201e98:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201e9c:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201e9e:	0009b703          	ld	a4,0(s3)
ffffffffc0201ea2:	068a                	slli	a3,a3,0x2
ffffffffc0201ea4:	757d                	lui	a0,0xfffff
ffffffffc0201ea6:	8ee9                	and	a3,a3,a0
ffffffffc0201ea8:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201eac:	06e7f263          	bgeu	a5,a4,ffffffffc0201f10 <get_pte+0x1c4>
ffffffffc0201eb0:	000ab503          	ld	a0,0(s5)
ffffffffc0201eb4:	00c95913          	srli	s2,s2,0xc
ffffffffc0201eb8:	1ff97913          	andi	s2,s2,511
ffffffffc0201ebc:	96aa                	add	a3,a3,a0
ffffffffc0201ebe:	00391513          	slli	a0,s2,0x3
ffffffffc0201ec2:	9536                	add	a0,a0,a3
}
ffffffffc0201ec4:	70e2                	ld	ra,56(sp)
ffffffffc0201ec6:	7442                	ld	s0,48(sp)
ffffffffc0201ec8:	74a2                	ld	s1,40(sp)
ffffffffc0201eca:	7902                	ld	s2,32(sp)
ffffffffc0201ecc:	69e2                	ld	s3,24(sp)
ffffffffc0201ece:	6a42                	ld	s4,16(sp)
ffffffffc0201ed0:	6aa2                	ld	s5,8(sp)
ffffffffc0201ed2:	6b02                	ld	s6,0(sp)
ffffffffc0201ed4:	6121                	addi	sp,sp,64
ffffffffc0201ed6:	8082                	ret
            return NULL;
ffffffffc0201ed8:	4501                	li	a0,0
ffffffffc0201eda:	b7ed                	j	ffffffffc0201ec4 <get_pte+0x178>
        intr_disable();
ffffffffc0201edc:	a55fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ee0:	0000b797          	auipc	a5,0xb
ffffffffc0201ee4:	5e07b783          	ld	a5,1504(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201ee8:	6f9c                	ld	a5,24(a5)
ffffffffc0201eea:	4505                	li	a0,1
ffffffffc0201eec:	9782                	jalr	a5
ffffffffc0201eee:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201ef0:	a3bfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201ef4:	b56d                	j	ffffffffc0201d9e <get_pte+0x52>
        intr_disable();
ffffffffc0201ef6:	a3bfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0201efa:	0000b797          	auipc	a5,0xb
ffffffffc0201efe:	5c67b783          	ld	a5,1478(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0201f02:	6f9c                	ld	a5,24(a5)
ffffffffc0201f04:	4505                	li	a0,1
ffffffffc0201f06:	9782                	jalr	a5
ffffffffc0201f08:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0201f0a:	a21fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0201f0e:	b781                	j	ffffffffc0201e4e <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201f10:	00003617          	auipc	a2,0x3
ffffffffc0201f14:	de860613          	addi	a2,a2,-536 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0201f18:	0fb00593          	li	a1,251
ffffffffc0201f1c:	00003517          	auipc	a0,0x3
ffffffffc0201f20:	ef450513          	addi	a0,a0,-268 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0201f24:	d36fe0ef          	jal	ra,ffffffffc020045a <__panic>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201f28:	00003617          	auipc	a2,0x3
ffffffffc0201f2c:	dd060613          	addi	a2,a2,-560 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0201f30:	0ee00593          	li	a1,238
ffffffffc0201f34:	00003517          	auipc	a0,0x3
ffffffffc0201f38:	edc50513          	addi	a0,a0,-292 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0201f3c:	d1efe0ef          	jal	ra,ffffffffc020045a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f40:	86aa                	mv	a3,a0
ffffffffc0201f42:	00003617          	auipc	a2,0x3
ffffffffc0201f46:	db660613          	addi	a2,a2,-586 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0201f4a:	0eb00593          	li	a1,235
ffffffffc0201f4e:	00003517          	auipc	a0,0x3
ffffffffc0201f52:	ec250513          	addi	a0,a0,-318 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0201f56:	d04fe0ef          	jal	ra,ffffffffc020045a <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201f5a:	86aa                	mv	a3,a0
ffffffffc0201f5c:	00003617          	auipc	a2,0x3
ffffffffc0201f60:	d9c60613          	addi	a2,a2,-612 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0201f64:	0f800593          	li	a1,248
ffffffffc0201f68:	00003517          	auipc	a0,0x3
ffffffffc0201f6c:	ea850513          	addi	a0,a0,-344 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0201f70:	ceafe0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0201f74 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc0201f74:	1141                	addi	sp,sp,-16
ffffffffc0201f76:	e022                	sd	s0,0(sp)
ffffffffc0201f78:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201f7a:	4601                	li	a2,0
{
ffffffffc0201f7c:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201f7e:	dcfff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
    if (ptep_store != NULL)
ffffffffc0201f82:	c011                	beqz	s0,ffffffffc0201f86 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0201f84:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0201f86:	c511                	beqz	a0,ffffffffc0201f92 <get_page+0x1e>
ffffffffc0201f88:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc0201f8a:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0201f8c:	0017f713          	andi	a4,a5,1
ffffffffc0201f90:	e709                	bnez	a4,ffffffffc0201f9a <get_page+0x26>
}
ffffffffc0201f92:	60a2                	ld	ra,8(sp)
ffffffffc0201f94:	6402                	ld	s0,0(sp)
ffffffffc0201f96:	0141                	addi	sp,sp,16
ffffffffc0201f98:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201f9a:	078a                	slli	a5,a5,0x2
ffffffffc0201f9c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201f9e:	0000b717          	auipc	a4,0xb
ffffffffc0201fa2:	51273703          	ld	a4,1298(a4) # ffffffffc020d4b0 <npage>
ffffffffc0201fa6:	00e7ff63          	bgeu	a5,a4,ffffffffc0201fc4 <get_page+0x50>
ffffffffc0201faa:	60a2                	ld	ra,8(sp)
ffffffffc0201fac:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc0201fae:	fff80537          	lui	a0,0xfff80
ffffffffc0201fb2:	97aa                	add	a5,a5,a0
ffffffffc0201fb4:	079a                	slli	a5,a5,0x6
ffffffffc0201fb6:	0000b517          	auipc	a0,0xb
ffffffffc0201fba:	50253503          	ld	a0,1282(a0) # ffffffffc020d4b8 <pages>
ffffffffc0201fbe:	953e                	add	a0,a0,a5
ffffffffc0201fc0:	0141                	addi	sp,sp,16
ffffffffc0201fc2:	8082                	ret
ffffffffc0201fc4:	c99ff0ef          	jal	ra,ffffffffc0201c5c <pa2page.part.0>

ffffffffc0201fc8 <page_remove>:
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
ffffffffc0201fc8:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201fca:	4601                	li	a2,0
{
ffffffffc0201fcc:	ec26                	sd	s1,24(sp)
ffffffffc0201fce:	f406                	sd	ra,40(sp)
ffffffffc0201fd0:	f022                	sd	s0,32(sp)
ffffffffc0201fd2:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201fd4:	d79ff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
    if (ptep != NULL)
ffffffffc0201fd8:	c511                	beqz	a0,ffffffffc0201fe4 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0201fda:	611c                	ld	a5,0(a0)
ffffffffc0201fdc:	842a                	mv	s0,a0
ffffffffc0201fde:	0017f713          	andi	a4,a5,1
ffffffffc0201fe2:	e711                	bnez	a4,ffffffffc0201fee <page_remove+0x26>
    {
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0201fe4:	70a2                	ld	ra,40(sp)
ffffffffc0201fe6:	7402                	ld	s0,32(sp)
ffffffffc0201fe8:	64e2                	ld	s1,24(sp)
ffffffffc0201fea:	6145                	addi	sp,sp,48
ffffffffc0201fec:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201fee:	078a                	slli	a5,a5,0x2
ffffffffc0201ff0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201ff2:	0000b717          	auipc	a4,0xb
ffffffffc0201ff6:	4be73703          	ld	a4,1214(a4) # ffffffffc020d4b0 <npage>
ffffffffc0201ffa:	06e7f363          	bgeu	a5,a4,ffffffffc0202060 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0201ffe:	fff80537          	lui	a0,0xfff80
ffffffffc0202002:	97aa                	add	a5,a5,a0
ffffffffc0202004:	079a                	slli	a5,a5,0x6
ffffffffc0202006:	0000b517          	auipc	a0,0xb
ffffffffc020200a:	4b253503          	ld	a0,1202(a0) # ffffffffc020d4b8 <pages>
ffffffffc020200e:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0202010:	411c                	lw	a5,0(a0)
ffffffffc0202012:	fff7871b          	addiw	a4,a5,-1
ffffffffc0202016:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0202018:	cb11                	beqz	a4,ffffffffc020202c <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020201a:	00043023          	sd	zero,0(s0)
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020201e:	12048073          	sfence.vma	s1
}
ffffffffc0202022:	70a2                	ld	ra,40(sp)
ffffffffc0202024:	7402                	ld	s0,32(sp)
ffffffffc0202026:	64e2                	ld	s1,24(sp)
ffffffffc0202028:	6145                	addi	sp,sp,48
ffffffffc020202a:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020202c:	100027f3          	csrr	a5,sstatus
ffffffffc0202030:	8b89                	andi	a5,a5,2
ffffffffc0202032:	eb89                	bnez	a5,ffffffffc0202044 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc0202034:	0000b797          	auipc	a5,0xb
ffffffffc0202038:	48c7b783          	ld	a5,1164(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc020203c:	739c                	ld	a5,32(a5)
ffffffffc020203e:	4585                	li	a1,1
ffffffffc0202040:	9782                	jalr	a5
    if (flag) {
ffffffffc0202042:	bfe1                	j	ffffffffc020201a <page_remove+0x52>
        intr_disable();
ffffffffc0202044:	e42a                	sd	a0,8(sp)
ffffffffc0202046:	8ebfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020204a:	0000b797          	auipc	a5,0xb
ffffffffc020204e:	4767b783          	ld	a5,1142(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc0202052:	739c                	ld	a5,32(a5)
ffffffffc0202054:	6522                	ld	a0,8(sp)
ffffffffc0202056:	4585                	li	a1,1
ffffffffc0202058:	9782                	jalr	a5
        intr_enable();
ffffffffc020205a:	8d1fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020205e:	bf75                	j	ffffffffc020201a <page_remove+0x52>
ffffffffc0202060:	bfdff0ef          	jal	ra,ffffffffc0201c5c <pa2page.part.0>

ffffffffc0202064 <page_insert>:
{
ffffffffc0202064:	7139                	addi	sp,sp,-64
ffffffffc0202066:	e852                	sd	s4,16(sp)
ffffffffc0202068:	8a32                	mv	s4,a2
ffffffffc020206a:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020206c:	4605                	li	a2,1
{
ffffffffc020206e:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc0202070:	85d2                	mv	a1,s4
{
ffffffffc0202072:	f426                	sd	s1,40(sp)
ffffffffc0202074:	fc06                	sd	ra,56(sp)
ffffffffc0202076:	f04a                	sd	s2,32(sp)
ffffffffc0202078:	ec4e                	sd	s3,24(sp)
ffffffffc020207a:	e456                	sd	s5,8(sp)
ffffffffc020207c:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc020207e:	ccfff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
    if (ptep == NULL)
ffffffffc0202082:	c961                	beqz	a0,ffffffffc0202152 <page_insert+0xee>
    page->ref += 1;
ffffffffc0202084:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0202086:	611c                	ld	a5,0(a0)
ffffffffc0202088:	89aa                	mv	s3,a0
ffffffffc020208a:	0016871b          	addiw	a4,a3,1
ffffffffc020208e:	c018                	sw	a4,0(s0)
ffffffffc0202090:	0017f713          	andi	a4,a5,1
ffffffffc0202094:	ef05                	bnez	a4,ffffffffc02020cc <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0202096:	0000b717          	auipc	a4,0xb
ffffffffc020209a:	42273703          	ld	a4,1058(a4) # ffffffffc020d4b8 <pages>
ffffffffc020209e:	8c19                	sub	s0,s0,a4
ffffffffc02020a0:	000807b7          	lui	a5,0x80
ffffffffc02020a4:	8419                	srai	s0,s0,0x6
ffffffffc02020a6:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02020a8:	042a                	slli	s0,s0,0xa
ffffffffc02020aa:	8cc1                	or	s1,s1,s0
ffffffffc02020ac:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02020b0:	0099b023          	sd	s1,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02020b4:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02020b8:	4501                	li	a0,0
}
ffffffffc02020ba:	70e2                	ld	ra,56(sp)
ffffffffc02020bc:	7442                	ld	s0,48(sp)
ffffffffc02020be:	74a2                	ld	s1,40(sp)
ffffffffc02020c0:	7902                	ld	s2,32(sp)
ffffffffc02020c2:	69e2                	ld	s3,24(sp)
ffffffffc02020c4:	6a42                	ld	s4,16(sp)
ffffffffc02020c6:	6aa2                	ld	s5,8(sp)
ffffffffc02020c8:	6121                	addi	sp,sp,64
ffffffffc02020ca:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02020cc:	078a                	slli	a5,a5,0x2
ffffffffc02020ce:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02020d0:	0000b717          	auipc	a4,0xb
ffffffffc02020d4:	3e073703          	ld	a4,992(a4) # ffffffffc020d4b0 <npage>
ffffffffc02020d8:	06e7ff63          	bgeu	a5,a4,ffffffffc0202156 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc02020dc:	0000ba97          	auipc	s5,0xb
ffffffffc02020e0:	3dca8a93          	addi	s5,s5,988 # ffffffffc020d4b8 <pages>
ffffffffc02020e4:	000ab703          	ld	a4,0(s5)
ffffffffc02020e8:	fff80937          	lui	s2,0xfff80
ffffffffc02020ec:	993e                	add	s2,s2,a5
ffffffffc02020ee:	091a                	slli	s2,s2,0x6
ffffffffc02020f0:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc02020f2:	01240c63          	beq	s0,s2,ffffffffc020210a <page_insert+0xa6>
    page->ref -= 1;
ffffffffc02020f6:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fd72b14>
ffffffffc02020fa:	fff7869b          	addiw	a3,a5,-1
ffffffffc02020fe:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0202102:	c691                	beqz	a3,ffffffffc020210e <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0202104:	120a0073          	sfence.vma	s4
}
ffffffffc0202108:	bf59                	j	ffffffffc020209e <page_insert+0x3a>
ffffffffc020210a:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc020210c:	bf49                	j	ffffffffc020209e <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020210e:	100027f3          	csrr	a5,sstatus
ffffffffc0202112:	8b89                	andi	a5,a5,2
ffffffffc0202114:	ef91                	bnez	a5,ffffffffc0202130 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0202116:	0000b797          	auipc	a5,0xb
ffffffffc020211a:	3aa7b783          	ld	a5,938(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc020211e:	739c                	ld	a5,32(a5)
ffffffffc0202120:	4585                	li	a1,1
ffffffffc0202122:	854a                	mv	a0,s2
ffffffffc0202124:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc0202126:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020212a:	120a0073          	sfence.vma	s4
ffffffffc020212e:	bf85                	j	ffffffffc020209e <page_insert+0x3a>
        intr_disable();
ffffffffc0202130:	801fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202134:	0000b797          	auipc	a5,0xb
ffffffffc0202138:	38c7b783          	ld	a5,908(a5) # ffffffffc020d4c0 <pmm_manager>
ffffffffc020213c:	739c                	ld	a5,32(a5)
ffffffffc020213e:	4585                	li	a1,1
ffffffffc0202140:	854a                	mv	a0,s2
ffffffffc0202142:	9782                	jalr	a5
        intr_enable();
ffffffffc0202144:	fe6fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202148:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020214c:	120a0073          	sfence.vma	s4
ffffffffc0202150:	b7b9                	j	ffffffffc020209e <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0202152:	5571                	li	a0,-4
ffffffffc0202154:	b79d                	j	ffffffffc02020ba <page_insert+0x56>
ffffffffc0202156:	b07ff0ef          	jal	ra,ffffffffc0201c5c <pa2page.part.0>

ffffffffc020215a <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc020215a:	00003797          	auipc	a5,0x3
ffffffffc020215e:	b6678793          	addi	a5,a5,-1178 # ffffffffc0204cc0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202162:	638c                	ld	a1,0(a5)
{
ffffffffc0202164:	7159                	addi	sp,sp,-112
ffffffffc0202166:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202168:	00003517          	auipc	a0,0x3
ffffffffc020216c:	cb850513          	addi	a0,a0,-840 # ffffffffc0204e20 <default_pmm_manager+0x160>
    pmm_manager = &default_pmm_manager;
ffffffffc0202170:	0000bb17          	auipc	s6,0xb
ffffffffc0202174:	350b0b13          	addi	s6,s6,848 # ffffffffc020d4c0 <pmm_manager>
{
ffffffffc0202178:	f486                	sd	ra,104(sp)
ffffffffc020217a:	e8ca                	sd	s2,80(sp)
ffffffffc020217c:	e4ce                	sd	s3,72(sp)
ffffffffc020217e:	f0a2                	sd	s0,96(sp)
ffffffffc0202180:	eca6                	sd	s1,88(sp)
ffffffffc0202182:	e0d2                	sd	s4,64(sp)
ffffffffc0202184:	fc56                	sd	s5,56(sp)
ffffffffc0202186:	f45e                	sd	s7,40(sp)
ffffffffc0202188:	f062                	sd	s8,32(sp)
ffffffffc020218a:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020218c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0202190:	804fe0ef          	jal	ra,ffffffffc0200194 <cprintf>
    pmm_manager->init();
ffffffffc0202194:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0202198:	0000b997          	auipc	s3,0xb
ffffffffc020219c:	33098993          	addi	s3,s3,816 # ffffffffc020d4c8 <va_pa_offset>
    pmm_manager->init();
ffffffffc02021a0:	679c                	ld	a5,8(a5)
ffffffffc02021a2:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02021a4:	57f5                	li	a5,-3
ffffffffc02021a6:	07fa                	slli	a5,a5,0x1e
ffffffffc02021a8:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02021ac:	f6afe0ef          	jal	ra,ffffffffc0200916 <get_memory_base>
ffffffffc02021b0:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc02021b2:	f6efe0ef          	jal	ra,ffffffffc0200920 <get_memory_size>
    if (mem_size == 0) {
ffffffffc02021b6:	200505e3          	beqz	a0,ffffffffc0202bc0 <pmm_init+0xa66>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02021ba:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02021bc:	00003517          	auipc	a0,0x3
ffffffffc02021c0:	c9c50513          	addi	a0,a0,-868 # ffffffffc0204e58 <default_pmm_manager+0x198>
ffffffffc02021c4:	fd1fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc02021c8:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc02021cc:	fff40693          	addi	a3,s0,-1
ffffffffc02021d0:	864a                	mv	a2,s2
ffffffffc02021d2:	85a6                	mv	a1,s1
ffffffffc02021d4:	00003517          	auipc	a0,0x3
ffffffffc02021d8:	c9c50513          	addi	a0,a0,-868 # ffffffffc0204e70 <default_pmm_manager+0x1b0>
ffffffffc02021dc:	fb9fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc02021e0:	c8000737          	lui	a4,0xc8000
ffffffffc02021e4:	87a2                	mv	a5,s0
ffffffffc02021e6:	54876163          	bltu	a4,s0,ffffffffc0202728 <pmm_init+0x5ce>
ffffffffc02021ea:	757d                	lui	a0,0xfffff
ffffffffc02021ec:	0000c617          	auipc	a2,0xc
ffffffffc02021f0:	2ff60613          	addi	a2,a2,767 # ffffffffc020e4eb <end+0xfff>
ffffffffc02021f4:	8e69                	and	a2,a2,a0
ffffffffc02021f6:	0000b497          	auipc	s1,0xb
ffffffffc02021fa:	2ba48493          	addi	s1,s1,698 # ffffffffc020d4b0 <npage>
ffffffffc02021fe:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202202:	0000bb97          	auipc	s7,0xb
ffffffffc0202206:	2b6b8b93          	addi	s7,s7,694 # ffffffffc020d4b8 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020220a:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020220c:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202210:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0202214:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202216:	02f50863          	beq	a0,a5,ffffffffc0202246 <pmm_init+0xec>
ffffffffc020221a:	4781                	li	a5,0
ffffffffc020221c:	4585                	li	a1,1
ffffffffc020221e:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0202222:	00679513          	slli	a0,a5,0x6
ffffffffc0202226:	9532                	add	a0,a0,a2
ffffffffc0202228:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fdf1b1c>
ffffffffc020222c:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202230:	6088                	ld	a0,0(s1)
ffffffffc0202232:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0202234:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0202238:	00d50733          	add	a4,a0,a3
ffffffffc020223c:	fee7e3e3          	bltu	a5,a4,ffffffffc0202222 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202240:	071a                	slli	a4,a4,0x6
ffffffffc0202242:	00e606b3          	add	a3,a2,a4
ffffffffc0202246:	c02007b7          	lui	a5,0xc0200
ffffffffc020224a:	2ef6ece3          	bltu	a3,a5,ffffffffc0202d42 <pmm_init+0xbe8>
ffffffffc020224e:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0202252:	77fd                	lui	a5,0xfffff
ffffffffc0202254:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202256:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc0202258:	5086eb63          	bltu	a3,s0,ffffffffc020276e <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc020225c:	00003517          	auipc	a0,0x3
ffffffffc0202260:	c3c50513          	addi	a0,a0,-964 # ffffffffc0204e98 <default_pmm_manager+0x1d8>
ffffffffc0202264:	f31fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc0202268:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc020226c:	0000b917          	auipc	s2,0xb
ffffffffc0202270:	23c90913          	addi	s2,s2,572 # ffffffffc020d4a8 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc0202274:	7b9c                	ld	a5,48(a5)
ffffffffc0202276:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0202278:	00003517          	auipc	a0,0x3
ffffffffc020227c:	c3850513          	addi	a0,a0,-968 # ffffffffc0204eb0 <default_pmm_manager+0x1f0>
ffffffffc0202280:	f15fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0202284:	00006697          	auipc	a3,0x6
ffffffffc0202288:	d7c68693          	addi	a3,a3,-644 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc020228c:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202290:	c02007b7          	lui	a5,0xc0200
ffffffffc0202294:	28f6ebe3          	bltu	a3,a5,ffffffffc0202d2a <pmm_init+0xbd0>
ffffffffc0202298:	0009b783          	ld	a5,0(s3)
ffffffffc020229c:	8e9d                	sub	a3,a3,a5
ffffffffc020229e:	0000b797          	auipc	a5,0xb
ffffffffc02022a2:	20d7b123          	sd	a3,514(a5) # ffffffffc020d4a0 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02022a6:	100027f3          	csrr	a5,sstatus
ffffffffc02022aa:	8b89                	andi	a5,a5,2
ffffffffc02022ac:	4a079763          	bnez	a5,ffffffffc020275a <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc02022b0:	000b3783          	ld	a5,0(s6)
ffffffffc02022b4:	779c                	ld	a5,40(a5)
ffffffffc02022b6:	9782                	jalr	a5
ffffffffc02022b8:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02022ba:	6098                	ld	a4,0(s1)
ffffffffc02022bc:	c80007b7          	lui	a5,0xc8000
ffffffffc02022c0:	83b1                	srli	a5,a5,0xc
ffffffffc02022c2:	66e7e363          	bltu	a5,a4,ffffffffc0202928 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02022c6:	00093503          	ld	a0,0(s2)
ffffffffc02022ca:	62050f63          	beqz	a0,ffffffffc0202908 <pmm_init+0x7ae>
ffffffffc02022ce:	03451793          	slli	a5,a0,0x34
ffffffffc02022d2:	62079b63          	bnez	a5,ffffffffc0202908 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02022d6:	4601                	li	a2,0
ffffffffc02022d8:	4581                	li	a1,0
ffffffffc02022da:	c9bff0ef          	jal	ra,ffffffffc0201f74 <get_page>
ffffffffc02022de:	60051563          	bnez	a0,ffffffffc02028e8 <pmm_init+0x78e>
ffffffffc02022e2:	100027f3          	csrr	a5,sstatus
ffffffffc02022e6:	8b89                	andi	a5,a5,2
ffffffffc02022e8:	44079e63          	bnez	a5,ffffffffc0202744 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc02022ec:	000b3783          	ld	a5,0(s6)
ffffffffc02022f0:	4505                	li	a0,1
ffffffffc02022f2:	6f9c                	ld	a5,24(a5)
ffffffffc02022f4:	9782                	jalr	a5
ffffffffc02022f6:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02022f8:	00093503          	ld	a0,0(s2)
ffffffffc02022fc:	4681                	li	a3,0
ffffffffc02022fe:	4601                	li	a2,0
ffffffffc0202300:	85d2                	mv	a1,s4
ffffffffc0202302:	d63ff0ef          	jal	ra,ffffffffc0202064 <page_insert>
ffffffffc0202306:	26051ae3          	bnez	a0,ffffffffc0202d7a <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020230a:	00093503          	ld	a0,0(s2)
ffffffffc020230e:	4601                	li	a2,0
ffffffffc0202310:	4581                	li	a1,0
ffffffffc0202312:	a3bff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
ffffffffc0202316:	240502e3          	beqz	a0,ffffffffc0202d5a <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc020231a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc020231c:	0017f713          	andi	a4,a5,1
ffffffffc0202320:	5a070263          	beqz	a4,ffffffffc02028c4 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0202324:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202326:	078a                	slli	a5,a5,0x2
ffffffffc0202328:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020232a:	58e7fb63          	bgeu	a5,a4,ffffffffc02028c0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020232e:	000bb683          	ld	a3,0(s7)
ffffffffc0202332:	fff80637          	lui	a2,0xfff80
ffffffffc0202336:	97b2                	add	a5,a5,a2
ffffffffc0202338:	079a                	slli	a5,a5,0x6
ffffffffc020233a:	97b6                	add	a5,a5,a3
ffffffffc020233c:	14fa17e3          	bne	s4,a5,ffffffffc0202c8a <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0202340:	000a2683          	lw	a3,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc0202344:	4785                	li	a5,1
ffffffffc0202346:	12f692e3          	bne	a3,a5,ffffffffc0202c6a <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc020234a:	00093503          	ld	a0,0(s2)
ffffffffc020234e:	77fd                	lui	a5,0xfffff
ffffffffc0202350:	6114                	ld	a3,0(a0)
ffffffffc0202352:	068a                	slli	a3,a3,0x2
ffffffffc0202354:	8efd                	and	a3,a3,a5
ffffffffc0202356:	00c6d613          	srli	a2,a3,0xc
ffffffffc020235a:	0ee67ce3          	bgeu	a2,a4,ffffffffc0202c52 <pmm_init+0xaf8>
ffffffffc020235e:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202362:	96e2                	add	a3,a3,s8
ffffffffc0202364:	0006ba83          	ld	s5,0(a3)
ffffffffc0202368:	0a8a                	slli	s5,s5,0x2
ffffffffc020236a:	00fafab3          	and	s5,s5,a5
ffffffffc020236e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202372:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0202c38 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202376:	4601                	li	a2,0
ffffffffc0202378:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020237a:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc020237c:	9d1ff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202380:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0202382:	55551363          	bne	a0,s5,ffffffffc02028c8 <pmm_init+0x76e>
ffffffffc0202386:	100027f3          	csrr	a5,sstatus
ffffffffc020238a:	8b89                	andi	a5,a5,2
ffffffffc020238c:	3a079163          	bnez	a5,ffffffffc020272e <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202390:	000b3783          	ld	a5,0(s6)
ffffffffc0202394:	4505                	li	a0,1
ffffffffc0202396:	6f9c                	ld	a5,24(a5)
ffffffffc0202398:	9782                	jalr	a5
ffffffffc020239a:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020239c:	00093503          	ld	a0,0(s2)
ffffffffc02023a0:	46d1                	li	a3,20
ffffffffc02023a2:	6605                	lui	a2,0x1
ffffffffc02023a4:	85e2                	mv	a1,s8
ffffffffc02023a6:	cbfff0ef          	jal	ra,ffffffffc0202064 <page_insert>
ffffffffc02023aa:	060517e3          	bnez	a0,ffffffffc0202c18 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02023ae:	00093503          	ld	a0,0(s2)
ffffffffc02023b2:	4601                	li	a2,0
ffffffffc02023b4:	6585                	lui	a1,0x1
ffffffffc02023b6:	997ff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
ffffffffc02023ba:	02050fe3          	beqz	a0,ffffffffc0202bf8 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc02023be:	611c                	ld	a5,0(a0)
ffffffffc02023c0:	0107f713          	andi	a4,a5,16
ffffffffc02023c4:	7c070e63          	beqz	a4,ffffffffc0202ba0 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc02023c8:	8b91                	andi	a5,a5,4
ffffffffc02023ca:	7a078b63          	beqz	a5,ffffffffc0202b80 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc02023ce:	00093503          	ld	a0,0(s2)
ffffffffc02023d2:	611c                	ld	a5,0(a0)
ffffffffc02023d4:	8bc1                	andi	a5,a5,16
ffffffffc02023d6:	78078563          	beqz	a5,ffffffffc0202b60 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc02023da:	000c2703          	lw	a4,0(s8) # ff0000 <kern_entry-0xffffffffbf210000>
ffffffffc02023de:	4785                	li	a5,1
ffffffffc02023e0:	76f71063          	bne	a4,a5,ffffffffc0202b40 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc02023e4:	4681                	li	a3,0
ffffffffc02023e6:	6605                	lui	a2,0x1
ffffffffc02023e8:	85d2                	mv	a1,s4
ffffffffc02023ea:	c7bff0ef          	jal	ra,ffffffffc0202064 <page_insert>
ffffffffc02023ee:	72051963          	bnez	a0,ffffffffc0202b20 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc02023f2:	000a2703          	lw	a4,0(s4)
ffffffffc02023f6:	4789                	li	a5,2
ffffffffc02023f8:	70f71463          	bne	a4,a5,ffffffffc0202b00 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc02023fc:	000c2783          	lw	a5,0(s8)
ffffffffc0202400:	6e079063          	bnez	a5,ffffffffc0202ae0 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202404:	00093503          	ld	a0,0(s2)
ffffffffc0202408:	4601                	li	a2,0
ffffffffc020240a:	6585                	lui	a1,0x1
ffffffffc020240c:	941ff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
ffffffffc0202410:	6a050863          	beqz	a0,ffffffffc0202ac0 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0202414:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0202416:	00177793          	andi	a5,a4,1
ffffffffc020241a:	4a078563          	beqz	a5,ffffffffc02028c4 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020241e:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0202420:	00271793          	slli	a5,a4,0x2
ffffffffc0202424:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202426:	48d7fd63          	bgeu	a5,a3,ffffffffc02028c0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020242a:	000bb683          	ld	a3,0(s7)
ffffffffc020242e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202432:	97d6                	add	a5,a5,s5
ffffffffc0202434:	079a                	slli	a5,a5,0x6
ffffffffc0202436:	97b6                	add	a5,a5,a3
ffffffffc0202438:	66fa1463          	bne	s4,a5,ffffffffc0202aa0 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc020243c:	8b41                	andi	a4,a4,16
ffffffffc020243e:	64071163          	bnez	a4,ffffffffc0202a80 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0202442:	00093503          	ld	a0,0(s2)
ffffffffc0202446:	4581                	li	a1,0
ffffffffc0202448:	b81ff0ef          	jal	ra,ffffffffc0201fc8 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc020244c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202450:	4785                	li	a5,1
ffffffffc0202452:	60fc9763          	bne	s9,a5,ffffffffc0202a60 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0202456:	000c2783          	lw	a5,0(s8)
ffffffffc020245a:	5e079363          	bnez	a5,ffffffffc0202a40 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc020245e:	00093503          	ld	a0,0(s2)
ffffffffc0202462:	6585                	lui	a1,0x1
ffffffffc0202464:	b65ff0ef          	jal	ra,ffffffffc0201fc8 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0202468:	000a2783          	lw	a5,0(s4)
ffffffffc020246c:	52079a63          	bnez	a5,ffffffffc02029a0 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0202470:	000c2783          	lw	a5,0(s8)
ffffffffc0202474:	50079663          	bnez	a5,ffffffffc0202980 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202478:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc020247c:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020247e:	000a3683          	ld	a3,0(s4)
ffffffffc0202482:	068a                	slli	a3,a3,0x2
ffffffffc0202484:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202486:	42b6fd63          	bgeu	a3,a1,ffffffffc02028c0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020248a:	000bb503          	ld	a0,0(s7)
ffffffffc020248e:	96d6                	add	a3,a3,s5
ffffffffc0202490:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0202492:	00d507b3          	add	a5,a0,a3
ffffffffc0202496:	439c                	lw	a5,0(a5)
ffffffffc0202498:	4d979463          	bne	a5,s9,ffffffffc0202960 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc020249c:	8699                	srai	a3,a3,0x6
ffffffffc020249e:	00080637          	lui	a2,0x80
ffffffffc02024a2:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc02024a4:	00c69713          	slli	a4,a3,0xc
ffffffffc02024a8:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02024aa:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02024ac:	48b77e63          	bgeu	a4,a1,ffffffffc0202948 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc02024b0:	0009b703          	ld	a4,0(s3)
ffffffffc02024b4:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc02024b6:	629c                	ld	a5,0(a3)
ffffffffc02024b8:	078a                	slli	a5,a5,0x2
ffffffffc02024ba:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024bc:	40b7f263          	bgeu	a5,a1,ffffffffc02028c0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02024c0:	8f91                	sub	a5,a5,a2
ffffffffc02024c2:	079a                	slli	a5,a5,0x6
ffffffffc02024c4:	953e                	add	a0,a0,a5
ffffffffc02024c6:	100027f3          	csrr	a5,sstatus
ffffffffc02024ca:	8b89                	andi	a5,a5,2
ffffffffc02024cc:	30079963          	bnez	a5,ffffffffc02027de <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc02024d0:	000b3783          	ld	a5,0(s6)
ffffffffc02024d4:	4585                	li	a1,1
ffffffffc02024d6:	739c                	ld	a5,32(a5)
ffffffffc02024d8:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02024da:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc02024de:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02024e0:	078a                	slli	a5,a5,0x2
ffffffffc02024e2:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02024e4:	3ce7fe63          	bgeu	a5,a4,ffffffffc02028c0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02024e8:	000bb503          	ld	a0,0(s7)
ffffffffc02024ec:	fff80737          	lui	a4,0xfff80
ffffffffc02024f0:	97ba                	add	a5,a5,a4
ffffffffc02024f2:	079a                	slli	a5,a5,0x6
ffffffffc02024f4:	953e                	add	a0,a0,a5
ffffffffc02024f6:	100027f3          	csrr	a5,sstatus
ffffffffc02024fa:	8b89                	andi	a5,a5,2
ffffffffc02024fc:	2c079563          	bnez	a5,ffffffffc02027c6 <pmm_init+0x66c>
ffffffffc0202500:	000b3783          	ld	a5,0(s6)
ffffffffc0202504:	4585                	li	a1,1
ffffffffc0202506:	739c                	ld	a5,32(a5)
ffffffffc0202508:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020250a:	00093783          	ld	a5,0(s2)
ffffffffc020250e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b14>
    asm volatile("sfence.vma");
ffffffffc0202512:	12000073          	sfence.vma
ffffffffc0202516:	100027f3          	csrr	a5,sstatus
ffffffffc020251a:	8b89                	andi	a5,a5,2
ffffffffc020251c:	28079b63          	bnez	a5,ffffffffc02027b2 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202520:	000b3783          	ld	a5,0(s6)
ffffffffc0202524:	779c                	ld	a5,40(a5)
ffffffffc0202526:	9782                	jalr	a5
ffffffffc0202528:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc020252a:	4b441b63          	bne	s0,s4,ffffffffc02029e0 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc020252e:	00003517          	auipc	a0,0x3
ffffffffc0202532:	caa50513          	addi	a0,a0,-854 # ffffffffc02051d8 <default_pmm_manager+0x518>
ffffffffc0202536:	c5ffd0ef          	jal	ra,ffffffffc0200194 <cprintf>
ffffffffc020253a:	100027f3          	csrr	a5,sstatus
ffffffffc020253e:	8b89                	andi	a5,a5,2
ffffffffc0202540:	24079f63          	bnez	a5,ffffffffc020279e <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202544:	000b3783          	ld	a5,0(s6)
ffffffffc0202548:	779c                	ld	a5,40(a5)
ffffffffc020254a:	9782                	jalr	a5
ffffffffc020254c:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc020254e:	6098                	ld	a4,0(s1)
ffffffffc0202550:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202554:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202556:	00c71793          	slli	a5,a4,0xc
ffffffffc020255a:	6a05                	lui	s4,0x1
ffffffffc020255c:	02f47c63          	bgeu	s0,a5,ffffffffc0202594 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202560:	00c45793          	srli	a5,s0,0xc
ffffffffc0202564:	00093503          	ld	a0,0(s2)
ffffffffc0202568:	2ee7ff63          	bgeu	a5,a4,ffffffffc0202866 <pmm_init+0x70c>
ffffffffc020256c:	0009b583          	ld	a1,0(s3)
ffffffffc0202570:	4601                	li	a2,0
ffffffffc0202572:	95a2                	add	a1,a1,s0
ffffffffc0202574:	fd8ff0ef          	jal	ra,ffffffffc0201d4c <get_pte>
ffffffffc0202578:	32050463          	beqz	a0,ffffffffc02028a0 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc020257c:	611c                	ld	a5,0(a0)
ffffffffc020257e:	078a                	slli	a5,a5,0x2
ffffffffc0202580:	0157f7b3          	and	a5,a5,s5
ffffffffc0202584:	2e879e63          	bne	a5,s0,ffffffffc0202880 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0202588:	6098                	ld	a4,0(s1)
ffffffffc020258a:	9452                	add	s0,s0,s4
ffffffffc020258c:	00c71793          	slli	a5,a4,0xc
ffffffffc0202590:	fcf468e3          	bltu	s0,a5,ffffffffc0202560 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0202594:	00093783          	ld	a5,0(s2)
ffffffffc0202598:	639c                	ld	a5,0(a5)
ffffffffc020259a:	42079363          	bnez	a5,ffffffffc02029c0 <pmm_init+0x866>
ffffffffc020259e:	100027f3          	csrr	a5,sstatus
ffffffffc02025a2:	8b89                	andi	a5,a5,2
ffffffffc02025a4:	24079963          	bnez	a5,ffffffffc02027f6 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02025a8:	000b3783          	ld	a5,0(s6)
ffffffffc02025ac:	4505                	li	a0,1
ffffffffc02025ae:	6f9c                	ld	a5,24(a5)
ffffffffc02025b0:	9782                	jalr	a5
ffffffffc02025b2:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc02025b4:	00093503          	ld	a0,0(s2)
ffffffffc02025b8:	4699                	li	a3,6
ffffffffc02025ba:	10000613          	li	a2,256
ffffffffc02025be:	85d2                	mv	a1,s4
ffffffffc02025c0:	aa5ff0ef          	jal	ra,ffffffffc0202064 <page_insert>
ffffffffc02025c4:	44051e63          	bnez	a0,ffffffffc0202a20 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc02025c8:	000a2703          	lw	a4,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc02025cc:	4785                	li	a5,1
ffffffffc02025ce:	42f71963          	bne	a4,a5,ffffffffc0202a00 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc02025d2:	00093503          	ld	a0,0(s2)
ffffffffc02025d6:	6405                	lui	s0,0x1
ffffffffc02025d8:	4699                	li	a3,6
ffffffffc02025da:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc02025de:	85d2                	mv	a1,s4
ffffffffc02025e0:	a85ff0ef          	jal	ra,ffffffffc0202064 <page_insert>
ffffffffc02025e4:	72051363          	bnez	a0,ffffffffc0202d0a <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc02025e8:	000a2703          	lw	a4,0(s4)
ffffffffc02025ec:	4789                	li	a5,2
ffffffffc02025ee:	6ef71e63          	bne	a4,a5,ffffffffc0202cea <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc02025f2:	00003597          	auipc	a1,0x3
ffffffffc02025f6:	d2e58593          	addi	a1,a1,-722 # ffffffffc0205320 <default_pmm_manager+0x660>
ffffffffc02025fa:	10000513          	li	a0,256
ffffffffc02025fe:	7d2010ef          	jal	ra,ffffffffc0203dd0 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202602:	10040593          	addi	a1,s0,256
ffffffffc0202606:	10000513          	li	a0,256
ffffffffc020260a:	7d8010ef          	jal	ra,ffffffffc0203de2 <strcmp>
ffffffffc020260e:	6a051e63          	bnez	a0,ffffffffc0202cca <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0202612:	000bb683          	ld	a3,0(s7)
ffffffffc0202616:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc020261a:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc020261c:	40da06b3          	sub	a3,s4,a3
ffffffffc0202620:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0202622:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0202624:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0202626:	8031                	srli	s0,s0,0xc
ffffffffc0202628:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc020262c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020262e:	30f77d63          	bgeu	a4,a5,ffffffffc0202948 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0202632:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202636:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc020263a:	96be                	add	a3,a3,a5
ffffffffc020263c:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202640:	75a010ef          	jal	ra,ffffffffc0203d9a <strlen>
ffffffffc0202644:	66051363          	bnez	a0,ffffffffc0202caa <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0202648:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc020264c:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc020264e:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fdf1b14>
ffffffffc0202652:	068a                	slli	a3,a3,0x2
ffffffffc0202654:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0202656:	26f6f563          	bgeu	a3,a5,ffffffffc02028c0 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc020265a:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc020265c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020265e:	2ef47563          	bgeu	s0,a5,ffffffffc0202948 <pmm_init+0x7ee>
ffffffffc0202662:	0009b403          	ld	s0,0(s3)
ffffffffc0202666:	9436                	add	s0,s0,a3
ffffffffc0202668:	100027f3          	csrr	a5,sstatus
ffffffffc020266c:	8b89                	andi	a5,a5,2
ffffffffc020266e:	1e079163          	bnez	a5,ffffffffc0202850 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0202672:	000b3783          	ld	a5,0(s6)
ffffffffc0202676:	4585                	li	a1,1
ffffffffc0202678:	8552                	mv	a0,s4
ffffffffc020267a:	739c                	ld	a5,32(a5)
ffffffffc020267c:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020267e:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0202680:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0202682:	078a                	slli	a5,a5,0x2
ffffffffc0202684:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202686:	22e7fd63          	bgeu	a5,a4,ffffffffc02028c0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020268a:	000bb503          	ld	a0,0(s7)
ffffffffc020268e:	fff80737          	lui	a4,0xfff80
ffffffffc0202692:	97ba                	add	a5,a5,a4
ffffffffc0202694:	079a                	slli	a5,a5,0x6
ffffffffc0202696:	953e                	add	a0,a0,a5
ffffffffc0202698:	100027f3          	csrr	a5,sstatus
ffffffffc020269c:	8b89                	andi	a5,a5,2
ffffffffc020269e:	18079d63          	bnez	a5,ffffffffc0202838 <pmm_init+0x6de>
ffffffffc02026a2:	000b3783          	ld	a5,0(s6)
ffffffffc02026a6:	4585                	li	a1,1
ffffffffc02026a8:	739c                	ld	a5,32(a5)
ffffffffc02026aa:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02026ac:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc02026b0:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02026b2:	078a                	slli	a5,a5,0x2
ffffffffc02026b4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02026b6:	20e7f563          	bgeu	a5,a4,ffffffffc02028c0 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02026ba:	000bb503          	ld	a0,0(s7)
ffffffffc02026be:	fff80737          	lui	a4,0xfff80
ffffffffc02026c2:	97ba                	add	a5,a5,a4
ffffffffc02026c4:	079a                	slli	a5,a5,0x6
ffffffffc02026c6:	953e                	add	a0,a0,a5
ffffffffc02026c8:	100027f3          	csrr	a5,sstatus
ffffffffc02026cc:	8b89                	andi	a5,a5,2
ffffffffc02026ce:	14079963          	bnez	a5,ffffffffc0202820 <pmm_init+0x6c6>
ffffffffc02026d2:	000b3783          	ld	a5,0(s6)
ffffffffc02026d6:	4585                	li	a1,1
ffffffffc02026d8:	739c                	ld	a5,32(a5)
ffffffffc02026da:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc02026dc:	00093783          	ld	a5,0(s2)
ffffffffc02026e0:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc02026e4:	12000073          	sfence.vma
ffffffffc02026e8:	100027f3          	csrr	a5,sstatus
ffffffffc02026ec:	8b89                	andi	a5,a5,2
ffffffffc02026ee:	10079f63          	bnez	a5,ffffffffc020280c <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc02026f2:	000b3783          	ld	a5,0(s6)
ffffffffc02026f6:	779c                	ld	a5,40(a5)
ffffffffc02026f8:	9782                	jalr	a5
ffffffffc02026fa:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02026fc:	4c8c1e63          	bne	s8,s0,ffffffffc0202bd8 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0202700:	00003517          	auipc	a0,0x3
ffffffffc0202704:	c9850513          	addi	a0,a0,-872 # ffffffffc0205398 <default_pmm_manager+0x6d8>
ffffffffc0202708:	a8dfd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc020270c:	7406                	ld	s0,96(sp)
ffffffffc020270e:	70a6                	ld	ra,104(sp)
ffffffffc0202710:	64e6                	ld	s1,88(sp)
ffffffffc0202712:	6946                	ld	s2,80(sp)
ffffffffc0202714:	69a6                	ld	s3,72(sp)
ffffffffc0202716:	6a06                	ld	s4,64(sp)
ffffffffc0202718:	7ae2                	ld	s5,56(sp)
ffffffffc020271a:	7b42                	ld	s6,48(sp)
ffffffffc020271c:	7ba2                	ld	s7,40(sp)
ffffffffc020271e:	7c02                	ld	s8,32(sp)
ffffffffc0202720:	6ce2                	ld	s9,24(sp)
ffffffffc0202722:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0202724:	b72ff06f          	j	ffffffffc0201a96 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0202728:	c80007b7          	lui	a5,0xc8000
ffffffffc020272c:	bc7d                	j	ffffffffc02021ea <pmm_init+0x90>
        intr_disable();
ffffffffc020272e:	a02fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202732:	000b3783          	ld	a5,0(s6)
ffffffffc0202736:	4505                	li	a0,1
ffffffffc0202738:	6f9c                	ld	a5,24(a5)
ffffffffc020273a:	9782                	jalr	a5
ffffffffc020273c:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020273e:	9ecfe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202742:	b9a9                	j	ffffffffc020239c <pmm_init+0x242>
        intr_disable();
ffffffffc0202744:	9ecfe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202748:	000b3783          	ld	a5,0(s6)
ffffffffc020274c:	4505                	li	a0,1
ffffffffc020274e:	6f9c                	ld	a5,24(a5)
ffffffffc0202750:	9782                	jalr	a5
ffffffffc0202752:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202754:	9d6fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202758:	b645                	j	ffffffffc02022f8 <pmm_init+0x19e>
        intr_disable();
ffffffffc020275a:	9d6fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020275e:	000b3783          	ld	a5,0(s6)
ffffffffc0202762:	779c                	ld	a5,40(a5)
ffffffffc0202764:	9782                	jalr	a5
ffffffffc0202766:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0202768:	9c2fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020276c:	b6b9                	j	ffffffffc02022ba <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc020276e:	6705                	lui	a4,0x1
ffffffffc0202770:	177d                	addi	a4,a4,-1
ffffffffc0202772:	96ba                	add	a3,a3,a4
ffffffffc0202774:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0202776:	00c7d713          	srli	a4,a5,0xc
ffffffffc020277a:	14a77363          	bgeu	a4,a0,ffffffffc02028c0 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc020277e:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0202782:	fff80537          	lui	a0,0xfff80
ffffffffc0202786:	972a                	add	a4,a4,a0
ffffffffc0202788:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020278a:	8c1d                	sub	s0,s0,a5
ffffffffc020278c:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0202790:	00c45593          	srli	a1,s0,0xc
ffffffffc0202794:	9532                	add	a0,a0,a2
ffffffffc0202796:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0202798:	0009b583          	ld	a1,0(s3)
}
ffffffffc020279c:	b4c1                	j	ffffffffc020225c <pmm_init+0x102>
        intr_disable();
ffffffffc020279e:	992fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02027a2:	000b3783          	ld	a5,0(s6)
ffffffffc02027a6:	779c                	ld	a5,40(a5)
ffffffffc02027a8:	9782                	jalr	a5
ffffffffc02027aa:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02027ac:	97efe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027b0:	bb79                	j	ffffffffc020254e <pmm_init+0x3f4>
        intr_disable();
ffffffffc02027b2:	97efe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027b6:	000b3783          	ld	a5,0(s6)
ffffffffc02027ba:	779c                	ld	a5,40(a5)
ffffffffc02027bc:	9782                	jalr	a5
ffffffffc02027be:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02027c0:	96afe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027c4:	b39d                	j	ffffffffc020252a <pmm_init+0x3d0>
ffffffffc02027c6:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02027c8:	968fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02027cc:	000b3783          	ld	a5,0(s6)
ffffffffc02027d0:	6522                	ld	a0,8(sp)
ffffffffc02027d2:	4585                	li	a1,1
ffffffffc02027d4:	739c                	ld	a5,32(a5)
ffffffffc02027d6:	9782                	jalr	a5
        intr_enable();
ffffffffc02027d8:	952fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027dc:	b33d                	j	ffffffffc020250a <pmm_init+0x3b0>
ffffffffc02027de:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02027e0:	950fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc02027e4:	000b3783          	ld	a5,0(s6)
ffffffffc02027e8:	6522                	ld	a0,8(sp)
ffffffffc02027ea:	4585                	li	a1,1
ffffffffc02027ec:	739c                	ld	a5,32(a5)
ffffffffc02027ee:	9782                	jalr	a5
        intr_enable();
ffffffffc02027f0:	93afe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc02027f4:	b1dd                	j	ffffffffc02024da <pmm_init+0x380>
        intr_disable();
ffffffffc02027f6:	93afe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02027fa:	000b3783          	ld	a5,0(s6)
ffffffffc02027fe:	4505                	li	a0,1
ffffffffc0202800:	6f9c                	ld	a5,24(a5)
ffffffffc0202802:	9782                	jalr	a5
ffffffffc0202804:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0202806:	924fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020280a:	b36d                	j	ffffffffc02025b4 <pmm_init+0x45a>
        intr_disable();
ffffffffc020280c:	924fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0202810:	000b3783          	ld	a5,0(s6)
ffffffffc0202814:	779c                	ld	a5,40(a5)
ffffffffc0202816:	9782                	jalr	a5
ffffffffc0202818:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020281a:	910fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020281e:	bdf9                	j	ffffffffc02026fc <pmm_init+0x5a2>
ffffffffc0202820:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0202822:	90efe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0202826:	000b3783          	ld	a5,0(s6)
ffffffffc020282a:	6522                	ld	a0,8(sp)
ffffffffc020282c:	4585                	li	a1,1
ffffffffc020282e:	739c                	ld	a5,32(a5)
ffffffffc0202830:	9782                	jalr	a5
        intr_enable();
ffffffffc0202832:	8f8fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202836:	b55d                	j	ffffffffc02026dc <pmm_init+0x582>
ffffffffc0202838:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc020283a:	8f6fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc020283e:	000b3783          	ld	a5,0(s6)
ffffffffc0202842:	6522                	ld	a0,8(sp)
ffffffffc0202844:	4585                	li	a1,1
ffffffffc0202846:	739c                	ld	a5,32(a5)
ffffffffc0202848:	9782                	jalr	a5
        intr_enable();
ffffffffc020284a:	8e0fe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc020284e:	bdb9                	j	ffffffffc02026ac <pmm_init+0x552>
        intr_disable();
ffffffffc0202850:	8e0fe0ef          	jal	ra,ffffffffc0200930 <intr_disable>
ffffffffc0202854:	000b3783          	ld	a5,0(s6)
ffffffffc0202858:	4585                	li	a1,1
ffffffffc020285a:	8552                	mv	a0,s4
ffffffffc020285c:	739c                	ld	a5,32(a5)
ffffffffc020285e:	9782                	jalr	a5
        intr_enable();
ffffffffc0202860:	8cafe0ef          	jal	ra,ffffffffc020092a <intr_enable>
ffffffffc0202864:	bd29                	j	ffffffffc020267e <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0202866:	86a2                	mv	a3,s0
ffffffffc0202868:	00002617          	auipc	a2,0x2
ffffffffc020286c:	49060613          	addi	a2,a2,1168 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0202870:	1a400593          	li	a1,420
ffffffffc0202874:	00002517          	auipc	a0,0x2
ffffffffc0202878:	59c50513          	addi	a0,a0,1436 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc020287c:	bdffd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0202880:	00003697          	auipc	a3,0x3
ffffffffc0202884:	9b868693          	addi	a3,a3,-1608 # ffffffffc0205238 <default_pmm_manager+0x578>
ffffffffc0202888:	00002617          	auipc	a2,0x2
ffffffffc020288c:	08860613          	addi	a2,a2,136 # ffffffffc0204910 <commands+0x818>
ffffffffc0202890:	1a500593          	li	a1,421
ffffffffc0202894:	00002517          	auipc	a0,0x2
ffffffffc0202898:	57c50513          	addi	a0,a0,1404 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc020289c:	bbffd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02028a0:	00003697          	auipc	a3,0x3
ffffffffc02028a4:	95868693          	addi	a3,a3,-1704 # ffffffffc02051f8 <default_pmm_manager+0x538>
ffffffffc02028a8:	00002617          	auipc	a2,0x2
ffffffffc02028ac:	06860613          	addi	a2,a2,104 # ffffffffc0204910 <commands+0x818>
ffffffffc02028b0:	1a400593          	li	a1,420
ffffffffc02028b4:	00002517          	auipc	a0,0x2
ffffffffc02028b8:	55c50513          	addi	a0,a0,1372 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc02028bc:	b9ffd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc02028c0:	b9cff0ef          	jal	ra,ffffffffc0201c5c <pa2page.part.0>
ffffffffc02028c4:	bb4ff0ef          	jal	ra,ffffffffc0201c78 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02028c8:	00002697          	auipc	a3,0x2
ffffffffc02028cc:	72868693          	addi	a3,a3,1832 # ffffffffc0204ff0 <default_pmm_manager+0x330>
ffffffffc02028d0:	00002617          	auipc	a2,0x2
ffffffffc02028d4:	04060613          	addi	a2,a2,64 # ffffffffc0204910 <commands+0x818>
ffffffffc02028d8:	17400593          	li	a1,372
ffffffffc02028dc:	00002517          	auipc	a0,0x2
ffffffffc02028e0:	53450513          	addi	a0,a0,1332 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc02028e4:	b77fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc02028e8:	00002697          	auipc	a3,0x2
ffffffffc02028ec:	64868693          	addi	a3,a3,1608 # ffffffffc0204f30 <default_pmm_manager+0x270>
ffffffffc02028f0:	00002617          	auipc	a2,0x2
ffffffffc02028f4:	02060613          	addi	a2,a2,32 # ffffffffc0204910 <commands+0x818>
ffffffffc02028f8:	16700593          	li	a1,359
ffffffffc02028fc:	00002517          	auipc	a0,0x2
ffffffffc0202900:	51450513          	addi	a0,a0,1300 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202904:	b57fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0202908:	00002697          	auipc	a3,0x2
ffffffffc020290c:	5e868693          	addi	a3,a3,1512 # ffffffffc0204ef0 <default_pmm_manager+0x230>
ffffffffc0202910:	00002617          	auipc	a2,0x2
ffffffffc0202914:	00060613          	mv	a2,a2
ffffffffc0202918:	16600593          	li	a1,358
ffffffffc020291c:	00002517          	auipc	a0,0x2
ffffffffc0202920:	4f450513          	addi	a0,a0,1268 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202924:	b37fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0202928:	00002697          	auipc	a3,0x2
ffffffffc020292c:	5a868693          	addi	a3,a3,1448 # ffffffffc0204ed0 <default_pmm_manager+0x210>
ffffffffc0202930:	00002617          	auipc	a2,0x2
ffffffffc0202934:	fe060613          	addi	a2,a2,-32 # ffffffffc0204910 <commands+0x818>
ffffffffc0202938:	16500593          	li	a1,357
ffffffffc020293c:	00002517          	auipc	a0,0x2
ffffffffc0202940:	4d450513          	addi	a0,a0,1236 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202944:	b17fd0ef          	jal	ra,ffffffffc020045a <__panic>
    return KADDR(page2pa(page));
ffffffffc0202948:	00002617          	auipc	a2,0x2
ffffffffc020294c:	3b060613          	addi	a2,a2,944 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0202950:	07100593          	li	a1,113
ffffffffc0202954:	00002517          	auipc	a0,0x2
ffffffffc0202958:	3cc50513          	addi	a0,a0,972 # ffffffffc0204d20 <default_pmm_manager+0x60>
ffffffffc020295c:	afffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202960:	00003697          	auipc	a3,0x3
ffffffffc0202964:	82068693          	addi	a3,a3,-2016 # ffffffffc0205180 <default_pmm_manager+0x4c0>
ffffffffc0202968:	00002617          	auipc	a2,0x2
ffffffffc020296c:	fa860613          	addi	a2,a2,-88 # ffffffffc0204910 <commands+0x818>
ffffffffc0202970:	18d00593          	li	a1,397
ffffffffc0202974:	00002517          	auipc	a0,0x2
ffffffffc0202978:	49c50513          	addi	a0,a0,1180 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc020297c:	adffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202980:	00002697          	auipc	a3,0x2
ffffffffc0202984:	7b868693          	addi	a3,a3,1976 # ffffffffc0205138 <default_pmm_manager+0x478>
ffffffffc0202988:	00002617          	auipc	a2,0x2
ffffffffc020298c:	f8860613          	addi	a2,a2,-120 # ffffffffc0204910 <commands+0x818>
ffffffffc0202990:	18b00593          	li	a1,395
ffffffffc0202994:	00002517          	auipc	a0,0x2
ffffffffc0202998:	47c50513          	addi	a0,a0,1148 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc020299c:	abffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02029a0:	00002697          	auipc	a3,0x2
ffffffffc02029a4:	7c868693          	addi	a3,a3,1992 # ffffffffc0205168 <default_pmm_manager+0x4a8>
ffffffffc02029a8:	00002617          	auipc	a2,0x2
ffffffffc02029ac:	f6860613          	addi	a2,a2,-152 # ffffffffc0204910 <commands+0x818>
ffffffffc02029b0:	18a00593          	li	a1,394
ffffffffc02029b4:	00002517          	auipc	a0,0x2
ffffffffc02029b8:	45c50513          	addi	a0,a0,1116 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc02029bc:	a9ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02029c0:	00003697          	auipc	a3,0x3
ffffffffc02029c4:	89068693          	addi	a3,a3,-1904 # ffffffffc0205250 <default_pmm_manager+0x590>
ffffffffc02029c8:	00002617          	auipc	a2,0x2
ffffffffc02029cc:	f4860613          	addi	a2,a2,-184 # ffffffffc0204910 <commands+0x818>
ffffffffc02029d0:	1a800593          	li	a1,424
ffffffffc02029d4:	00002517          	auipc	a0,0x2
ffffffffc02029d8:	43c50513          	addi	a0,a0,1084 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc02029dc:	a7ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc02029e0:	00002697          	auipc	a3,0x2
ffffffffc02029e4:	7d068693          	addi	a3,a3,2000 # ffffffffc02051b0 <default_pmm_manager+0x4f0>
ffffffffc02029e8:	00002617          	auipc	a2,0x2
ffffffffc02029ec:	f2860613          	addi	a2,a2,-216 # ffffffffc0204910 <commands+0x818>
ffffffffc02029f0:	19500593          	li	a1,405
ffffffffc02029f4:	00002517          	auipc	a0,0x2
ffffffffc02029f8:	41c50513          	addi	a0,a0,1052 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc02029fc:	a5ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202a00:	00003697          	auipc	a3,0x3
ffffffffc0202a04:	8a868693          	addi	a3,a3,-1880 # ffffffffc02052a8 <default_pmm_manager+0x5e8>
ffffffffc0202a08:	00002617          	auipc	a2,0x2
ffffffffc0202a0c:	f0860613          	addi	a2,a2,-248 # ffffffffc0204910 <commands+0x818>
ffffffffc0202a10:	1ad00593          	li	a1,429
ffffffffc0202a14:	00002517          	auipc	a0,0x2
ffffffffc0202a18:	3fc50513          	addi	a0,a0,1020 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202a1c:	a3ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202a20:	00003697          	auipc	a3,0x3
ffffffffc0202a24:	84868693          	addi	a3,a3,-1976 # ffffffffc0205268 <default_pmm_manager+0x5a8>
ffffffffc0202a28:	00002617          	auipc	a2,0x2
ffffffffc0202a2c:	ee860613          	addi	a2,a2,-280 # ffffffffc0204910 <commands+0x818>
ffffffffc0202a30:	1ac00593          	li	a1,428
ffffffffc0202a34:	00002517          	auipc	a0,0x2
ffffffffc0202a38:	3dc50513          	addi	a0,a0,988 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202a3c:	a1ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202a40:	00002697          	auipc	a3,0x2
ffffffffc0202a44:	6f868693          	addi	a3,a3,1784 # ffffffffc0205138 <default_pmm_manager+0x478>
ffffffffc0202a48:	00002617          	auipc	a2,0x2
ffffffffc0202a4c:	ec860613          	addi	a2,a2,-312 # ffffffffc0204910 <commands+0x818>
ffffffffc0202a50:	18700593          	li	a1,391
ffffffffc0202a54:	00002517          	auipc	a0,0x2
ffffffffc0202a58:	3bc50513          	addi	a0,a0,956 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202a5c:	9fffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202a60:	00002697          	auipc	a3,0x2
ffffffffc0202a64:	57868693          	addi	a3,a3,1400 # ffffffffc0204fd8 <default_pmm_manager+0x318>
ffffffffc0202a68:	00002617          	auipc	a2,0x2
ffffffffc0202a6c:	ea860613          	addi	a2,a2,-344 # ffffffffc0204910 <commands+0x818>
ffffffffc0202a70:	18600593          	li	a1,390
ffffffffc0202a74:	00002517          	auipc	a0,0x2
ffffffffc0202a78:	39c50513          	addi	a0,a0,924 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202a7c:	9dffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0202a80:	00002697          	auipc	a3,0x2
ffffffffc0202a84:	6d068693          	addi	a3,a3,1744 # ffffffffc0205150 <default_pmm_manager+0x490>
ffffffffc0202a88:	00002617          	auipc	a2,0x2
ffffffffc0202a8c:	e8860613          	addi	a2,a2,-376 # ffffffffc0204910 <commands+0x818>
ffffffffc0202a90:	18300593          	li	a1,387
ffffffffc0202a94:	00002517          	auipc	a0,0x2
ffffffffc0202a98:	37c50513          	addi	a0,a0,892 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202a9c:	9bffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202aa0:	00002697          	auipc	a3,0x2
ffffffffc0202aa4:	52068693          	addi	a3,a3,1312 # ffffffffc0204fc0 <default_pmm_manager+0x300>
ffffffffc0202aa8:	00002617          	auipc	a2,0x2
ffffffffc0202aac:	e6860613          	addi	a2,a2,-408 # ffffffffc0204910 <commands+0x818>
ffffffffc0202ab0:	18200593          	li	a1,386
ffffffffc0202ab4:	00002517          	auipc	a0,0x2
ffffffffc0202ab8:	35c50513          	addi	a0,a0,860 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202abc:	99ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202ac0:	00002697          	auipc	a3,0x2
ffffffffc0202ac4:	5a068693          	addi	a3,a3,1440 # ffffffffc0205060 <default_pmm_manager+0x3a0>
ffffffffc0202ac8:	00002617          	auipc	a2,0x2
ffffffffc0202acc:	e4860613          	addi	a2,a2,-440 # ffffffffc0204910 <commands+0x818>
ffffffffc0202ad0:	18100593          	li	a1,385
ffffffffc0202ad4:	00002517          	auipc	a0,0x2
ffffffffc0202ad8:	33c50513          	addi	a0,a0,828 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202adc:	97ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202ae0:	00002697          	auipc	a3,0x2
ffffffffc0202ae4:	65868693          	addi	a3,a3,1624 # ffffffffc0205138 <default_pmm_manager+0x478>
ffffffffc0202ae8:	00002617          	auipc	a2,0x2
ffffffffc0202aec:	e2860613          	addi	a2,a2,-472 # ffffffffc0204910 <commands+0x818>
ffffffffc0202af0:	18000593          	li	a1,384
ffffffffc0202af4:	00002517          	auipc	a0,0x2
ffffffffc0202af8:	31c50513          	addi	a0,a0,796 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202afc:	95ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202b00:	00002697          	auipc	a3,0x2
ffffffffc0202b04:	62068693          	addi	a3,a3,1568 # ffffffffc0205120 <default_pmm_manager+0x460>
ffffffffc0202b08:	00002617          	auipc	a2,0x2
ffffffffc0202b0c:	e0860613          	addi	a2,a2,-504 # ffffffffc0204910 <commands+0x818>
ffffffffc0202b10:	17f00593          	li	a1,383
ffffffffc0202b14:	00002517          	auipc	a0,0x2
ffffffffc0202b18:	2fc50513          	addi	a0,a0,764 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202b1c:	93ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202b20:	00002697          	auipc	a3,0x2
ffffffffc0202b24:	5d068693          	addi	a3,a3,1488 # ffffffffc02050f0 <default_pmm_manager+0x430>
ffffffffc0202b28:	00002617          	auipc	a2,0x2
ffffffffc0202b2c:	de860613          	addi	a2,a2,-536 # ffffffffc0204910 <commands+0x818>
ffffffffc0202b30:	17e00593          	li	a1,382
ffffffffc0202b34:	00002517          	auipc	a0,0x2
ffffffffc0202b38:	2dc50513          	addi	a0,a0,732 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202b3c:	91ffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202b40:	00002697          	auipc	a3,0x2
ffffffffc0202b44:	59868693          	addi	a3,a3,1432 # ffffffffc02050d8 <default_pmm_manager+0x418>
ffffffffc0202b48:	00002617          	auipc	a2,0x2
ffffffffc0202b4c:	dc860613          	addi	a2,a2,-568 # ffffffffc0204910 <commands+0x818>
ffffffffc0202b50:	17c00593          	li	a1,380
ffffffffc0202b54:	00002517          	auipc	a0,0x2
ffffffffc0202b58:	2bc50513          	addi	a0,a0,700 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202b5c:	8fffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202b60:	00002697          	auipc	a3,0x2
ffffffffc0202b64:	55868693          	addi	a3,a3,1368 # ffffffffc02050b8 <default_pmm_manager+0x3f8>
ffffffffc0202b68:	00002617          	auipc	a2,0x2
ffffffffc0202b6c:	da860613          	addi	a2,a2,-600 # ffffffffc0204910 <commands+0x818>
ffffffffc0202b70:	17b00593          	li	a1,379
ffffffffc0202b74:	00002517          	auipc	a0,0x2
ffffffffc0202b78:	29c50513          	addi	a0,a0,668 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202b7c:	8dffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(*ptep & PTE_W);
ffffffffc0202b80:	00002697          	auipc	a3,0x2
ffffffffc0202b84:	52868693          	addi	a3,a3,1320 # ffffffffc02050a8 <default_pmm_manager+0x3e8>
ffffffffc0202b88:	00002617          	auipc	a2,0x2
ffffffffc0202b8c:	d8860613          	addi	a2,a2,-632 # ffffffffc0204910 <commands+0x818>
ffffffffc0202b90:	17a00593          	li	a1,378
ffffffffc0202b94:	00002517          	auipc	a0,0x2
ffffffffc0202b98:	27c50513          	addi	a0,a0,636 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202b9c:	8bffd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(*ptep & PTE_U);
ffffffffc0202ba0:	00002697          	auipc	a3,0x2
ffffffffc0202ba4:	4f868693          	addi	a3,a3,1272 # ffffffffc0205098 <default_pmm_manager+0x3d8>
ffffffffc0202ba8:	00002617          	auipc	a2,0x2
ffffffffc0202bac:	d6860613          	addi	a2,a2,-664 # ffffffffc0204910 <commands+0x818>
ffffffffc0202bb0:	17900593          	li	a1,377
ffffffffc0202bb4:	00002517          	auipc	a0,0x2
ffffffffc0202bb8:	25c50513          	addi	a0,a0,604 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202bbc:	89ffd0ef          	jal	ra,ffffffffc020045a <__panic>
        panic("DTB memory info not available");
ffffffffc0202bc0:	00002617          	auipc	a2,0x2
ffffffffc0202bc4:	27860613          	addi	a2,a2,632 # ffffffffc0204e38 <default_pmm_manager+0x178>
ffffffffc0202bc8:	06400593          	li	a1,100
ffffffffc0202bcc:	00002517          	auipc	a0,0x2
ffffffffc0202bd0:	24450513          	addi	a0,a0,580 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202bd4:	887fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202bd8:	00002697          	auipc	a3,0x2
ffffffffc0202bdc:	5d868693          	addi	a3,a3,1496 # ffffffffc02051b0 <default_pmm_manager+0x4f0>
ffffffffc0202be0:	00002617          	auipc	a2,0x2
ffffffffc0202be4:	d3060613          	addi	a2,a2,-720 # ffffffffc0204910 <commands+0x818>
ffffffffc0202be8:	1bf00593          	li	a1,447
ffffffffc0202bec:	00002517          	auipc	a0,0x2
ffffffffc0202bf0:	22450513          	addi	a0,a0,548 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202bf4:	867fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0202bf8:	00002697          	auipc	a3,0x2
ffffffffc0202bfc:	46868693          	addi	a3,a3,1128 # ffffffffc0205060 <default_pmm_manager+0x3a0>
ffffffffc0202c00:	00002617          	auipc	a2,0x2
ffffffffc0202c04:	d1060613          	addi	a2,a2,-752 # ffffffffc0204910 <commands+0x818>
ffffffffc0202c08:	17800593          	li	a1,376
ffffffffc0202c0c:	00002517          	auipc	a0,0x2
ffffffffc0202c10:	20450513          	addi	a0,a0,516 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202c14:	847fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0202c18:	00002697          	auipc	a3,0x2
ffffffffc0202c1c:	40868693          	addi	a3,a3,1032 # ffffffffc0205020 <default_pmm_manager+0x360>
ffffffffc0202c20:	00002617          	auipc	a2,0x2
ffffffffc0202c24:	cf060613          	addi	a2,a2,-784 # ffffffffc0204910 <commands+0x818>
ffffffffc0202c28:	17700593          	li	a1,375
ffffffffc0202c2c:	00002517          	auipc	a0,0x2
ffffffffc0202c30:	1e450513          	addi	a0,a0,484 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202c34:	827fd0ef          	jal	ra,ffffffffc020045a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0202c38:	86d6                	mv	a3,s5
ffffffffc0202c3a:	00002617          	auipc	a2,0x2
ffffffffc0202c3e:	0be60613          	addi	a2,a2,190 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0202c42:	17300593          	li	a1,371
ffffffffc0202c46:	00002517          	auipc	a0,0x2
ffffffffc0202c4a:	1ca50513          	addi	a0,a0,458 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202c4e:	80dfd0ef          	jal	ra,ffffffffc020045a <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202c52:	00002617          	auipc	a2,0x2
ffffffffc0202c56:	0a660613          	addi	a2,a2,166 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0202c5a:	17200593          	li	a1,370
ffffffffc0202c5e:	00002517          	auipc	a0,0x2
ffffffffc0202c62:	1b250513          	addi	a0,a0,434 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202c66:	ff4fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202c6a:	00002697          	auipc	a3,0x2
ffffffffc0202c6e:	36e68693          	addi	a3,a3,878 # ffffffffc0204fd8 <default_pmm_manager+0x318>
ffffffffc0202c72:	00002617          	auipc	a2,0x2
ffffffffc0202c76:	c9e60613          	addi	a2,a2,-866 # ffffffffc0204910 <commands+0x818>
ffffffffc0202c7a:	17000593          	li	a1,368
ffffffffc0202c7e:	00002517          	auipc	a0,0x2
ffffffffc0202c82:	19250513          	addi	a0,a0,402 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202c86:	fd4fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0202c8a:	00002697          	auipc	a3,0x2
ffffffffc0202c8e:	33668693          	addi	a3,a3,822 # ffffffffc0204fc0 <default_pmm_manager+0x300>
ffffffffc0202c92:	00002617          	auipc	a2,0x2
ffffffffc0202c96:	c7e60613          	addi	a2,a2,-898 # ffffffffc0204910 <commands+0x818>
ffffffffc0202c9a:	16f00593          	li	a1,367
ffffffffc0202c9e:	00002517          	auipc	a0,0x2
ffffffffc0202ca2:	17250513          	addi	a0,a0,370 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202ca6:	fb4fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0202caa:	00002697          	auipc	a3,0x2
ffffffffc0202cae:	6c668693          	addi	a3,a3,1734 # ffffffffc0205370 <default_pmm_manager+0x6b0>
ffffffffc0202cb2:	00002617          	auipc	a2,0x2
ffffffffc0202cb6:	c5e60613          	addi	a2,a2,-930 # ffffffffc0204910 <commands+0x818>
ffffffffc0202cba:	1b600593          	li	a1,438
ffffffffc0202cbe:	00002517          	auipc	a0,0x2
ffffffffc0202cc2:	15250513          	addi	a0,a0,338 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202cc6:	f94fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202cca:	00002697          	auipc	a3,0x2
ffffffffc0202cce:	66e68693          	addi	a3,a3,1646 # ffffffffc0205338 <default_pmm_manager+0x678>
ffffffffc0202cd2:	00002617          	auipc	a2,0x2
ffffffffc0202cd6:	c3e60613          	addi	a2,a2,-962 # ffffffffc0204910 <commands+0x818>
ffffffffc0202cda:	1b300593          	li	a1,435
ffffffffc0202cde:	00002517          	auipc	a0,0x2
ffffffffc0202ce2:	13250513          	addi	a0,a0,306 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202ce6:	f74fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202cea:	00002697          	auipc	a3,0x2
ffffffffc0202cee:	61e68693          	addi	a3,a3,1566 # ffffffffc0205308 <default_pmm_manager+0x648>
ffffffffc0202cf2:	00002617          	auipc	a2,0x2
ffffffffc0202cf6:	c1e60613          	addi	a2,a2,-994 # ffffffffc0204910 <commands+0x818>
ffffffffc0202cfa:	1af00593          	li	a1,431
ffffffffc0202cfe:	00002517          	auipc	a0,0x2
ffffffffc0202d02:	11250513          	addi	a0,a0,274 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202d06:	f54fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202d0a:	00002697          	auipc	a3,0x2
ffffffffc0202d0e:	5b668693          	addi	a3,a3,1462 # ffffffffc02052c0 <default_pmm_manager+0x600>
ffffffffc0202d12:	00002617          	auipc	a2,0x2
ffffffffc0202d16:	bfe60613          	addi	a2,a2,-1026 # ffffffffc0204910 <commands+0x818>
ffffffffc0202d1a:	1ae00593          	li	a1,430
ffffffffc0202d1e:	00002517          	auipc	a0,0x2
ffffffffc0202d22:	0f250513          	addi	a0,a0,242 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202d26:	f34fd0ef          	jal	ra,ffffffffc020045a <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202d2a:	00002617          	auipc	a2,0x2
ffffffffc0202d2e:	07660613          	addi	a2,a2,118 # ffffffffc0204da0 <default_pmm_manager+0xe0>
ffffffffc0202d32:	0cb00593          	li	a1,203
ffffffffc0202d36:	00002517          	auipc	a0,0x2
ffffffffc0202d3a:	0da50513          	addi	a0,a0,218 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202d3e:	f1cfd0ef          	jal	ra,ffffffffc020045a <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202d42:	00002617          	auipc	a2,0x2
ffffffffc0202d46:	05e60613          	addi	a2,a2,94 # ffffffffc0204da0 <default_pmm_manager+0xe0>
ffffffffc0202d4a:	08000593          	li	a1,128
ffffffffc0202d4e:	00002517          	auipc	a0,0x2
ffffffffc0202d52:	0c250513          	addi	a0,a0,194 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202d56:	f04fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202d5a:	00002697          	auipc	a3,0x2
ffffffffc0202d5e:	23668693          	addi	a3,a3,566 # ffffffffc0204f90 <default_pmm_manager+0x2d0>
ffffffffc0202d62:	00002617          	auipc	a2,0x2
ffffffffc0202d66:	bae60613          	addi	a2,a2,-1106 # ffffffffc0204910 <commands+0x818>
ffffffffc0202d6a:	16e00593          	li	a1,366
ffffffffc0202d6e:	00002517          	auipc	a0,0x2
ffffffffc0202d72:	0a250513          	addi	a0,a0,162 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202d76:	ee4fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0202d7a:	00002697          	auipc	a3,0x2
ffffffffc0202d7e:	1e668693          	addi	a3,a3,486 # ffffffffc0204f60 <default_pmm_manager+0x2a0>
ffffffffc0202d82:	00002617          	auipc	a2,0x2
ffffffffc0202d86:	b8e60613          	addi	a2,a2,-1138 # ffffffffc0204910 <commands+0x818>
ffffffffc0202d8a:	16b00593          	li	a1,363
ffffffffc0202d8e:	00002517          	auipc	a0,0x2
ffffffffc0202d92:	08250513          	addi	a0,a0,130 # ffffffffc0204e10 <default_pmm_manager+0x150>
ffffffffc0202d96:	ec4fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202d9a <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202d9a:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0202d9c:	00002697          	auipc	a3,0x2
ffffffffc0202da0:	61c68693          	addi	a3,a3,1564 # ffffffffc02053b8 <default_pmm_manager+0x6f8>
ffffffffc0202da4:	00002617          	auipc	a2,0x2
ffffffffc0202da8:	b6c60613          	addi	a2,a2,-1172 # ffffffffc0204910 <commands+0x818>
ffffffffc0202dac:	08800593          	li	a1,136
ffffffffc0202db0:	00002517          	auipc	a0,0x2
ffffffffc0202db4:	62850513          	addi	a0,a0,1576 # ffffffffc02053d8 <default_pmm_manager+0x718>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202db8:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202dba:	ea0fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202dbe <find_vma>:
{
ffffffffc0202dbe:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0202dc0:	c505                	beqz	a0,ffffffffc0202de8 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0202dc2:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202dc4:	c501                	beqz	a0,ffffffffc0202dcc <find_vma+0xe>
ffffffffc0202dc6:	651c                	ld	a5,8(a0)
ffffffffc0202dc8:	02f5f263          	bgeu	a1,a5,ffffffffc0202dec <find_vma+0x2e>
    return listelm->next;
ffffffffc0202dcc:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0202dce:	00f68d63          	beq	a3,a5,ffffffffc0202de8 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0202dd2:	fe87b703          	ld	a4,-24(a5) # ffffffffc7ffffe8 <end+0x7df2afc>
ffffffffc0202dd6:	00e5e663          	bltu	a1,a4,ffffffffc0202de2 <find_vma+0x24>
ffffffffc0202dda:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202dde:	00e5ec63          	bltu	a1,a4,ffffffffc0202df6 <find_vma+0x38>
ffffffffc0202de2:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0202de4:	fef697e3          	bne	a3,a5,ffffffffc0202dd2 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0202de8:	4501                	li	a0,0
}
ffffffffc0202dea:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202dec:	691c                	ld	a5,16(a0)
ffffffffc0202dee:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202dcc <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0202df2:	ea88                	sd	a0,16(a3)
ffffffffc0202df4:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0202df6:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202dfa:	ea88                	sd	a0,16(a3)
ffffffffc0202dfc:	8082                	ret

ffffffffc0202dfe <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202dfe:	6590                	ld	a2,8(a1)
ffffffffc0202e00:	0105b803          	ld	a6,16(a1)
{
ffffffffc0202e04:	1141                	addi	sp,sp,-16
ffffffffc0202e06:	e406                	sd	ra,8(sp)
ffffffffc0202e08:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e0a:	01066763          	bltu	a2,a6,ffffffffc0202e18 <insert_vma_struct+0x1a>
ffffffffc0202e0e:	a085                	j	ffffffffc0202e6e <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202e10:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e14:	04e66863          	bltu	a2,a4,ffffffffc0202e64 <insert_vma_struct+0x66>
ffffffffc0202e18:	86be                	mv	a3,a5
ffffffffc0202e1a:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0202e1c:	fef51ae3          	bne	a0,a5,ffffffffc0202e10 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0202e20:	02a68463          	beq	a3,a0,ffffffffc0202e48 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0202e24:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202e28:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202e2c:	08e8f163          	bgeu	a7,a4,ffffffffc0202eae <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e30:	04e66f63          	bltu	a2,a4,ffffffffc0202e8e <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0202e34:	00f50a63          	beq	a0,a5,ffffffffc0202e48 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202e38:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e3c:	05076963          	bltu	a4,a6,ffffffffc0202e8e <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0202e40:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202e44:	02c77363          	bgeu	a4,a2,ffffffffc0202e6a <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0202e48:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0202e4a:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0202e4c:	02058613          	addi	a2,a1,32
    prev->next = next->prev = elm;
ffffffffc0202e50:	e390                	sd	a2,0(a5)
ffffffffc0202e52:	e690                	sd	a2,8(a3)
}
ffffffffc0202e54:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0202e56:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0202e58:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0202e5a:	0017079b          	addiw	a5,a4,1
ffffffffc0202e5e:	d11c                	sw	a5,32(a0)
}
ffffffffc0202e60:	0141                	addi	sp,sp,16
ffffffffc0202e62:	8082                	ret
    if (le_prev != list)
ffffffffc0202e64:	fca690e3          	bne	a3,a0,ffffffffc0202e24 <insert_vma_struct+0x26>
ffffffffc0202e68:	bfd1                	j	ffffffffc0202e3c <insert_vma_struct+0x3e>
ffffffffc0202e6a:	f31ff0ef          	jal	ra,ffffffffc0202d9a <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202e6e:	00002697          	auipc	a3,0x2
ffffffffc0202e72:	57a68693          	addi	a3,a3,1402 # ffffffffc02053e8 <default_pmm_manager+0x728>
ffffffffc0202e76:	00002617          	auipc	a2,0x2
ffffffffc0202e7a:	a9a60613          	addi	a2,a2,-1382 # ffffffffc0204910 <commands+0x818>
ffffffffc0202e7e:	08e00593          	li	a1,142
ffffffffc0202e82:	00002517          	auipc	a0,0x2
ffffffffc0202e86:	55650513          	addi	a0,a0,1366 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0202e8a:	dd0fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202e8e:	00002697          	auipc	a3,0x2
ffffffffc0202e92:	59a68693          	addi	a3,a3,1434 # ffffffffc0205428 <default_pmm_manager+0x768>
ffffffffc0202e96:	00002617          	auipc	a2,0x2
ffffffffc0202e9a:	a7a60613          	addi	a2,a2,-1414 # ffffffffc0204910 <commands+0x818>
ffffffffc0202e9e:	08700593          	li	a1,135
ffffffffc0202ea2:	00002517          	auipc	a0,0x2
ffffffffc0202ea6:	53650513          	addi	a0,a0,1334 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0202eaa:	db0fd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202eae:	00002697          	auipc	a3,0x2
ffffffffc0202eb2:	55a68693          	addi	a3,a3,1370 # ffffffffc0205408 <default_pmm_manager+0x748>
ffffffffc0202eb6:	00002617          	auipc	a2,0x2
ffffffffc0202eba:	a5a60613          	addi	a2,a2,-1446 # ffffffffc0204910 <commands+0x818>
ffffffffc0202ebe:	08600593          	li	a1,134
ffffffffc0202ec2:	00002517          	auipc	a0,0x2
ffffffffc0202ec6:	51650513          	addi	a0,a0,1302 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0202eca:	d90fd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0202ece <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0202ece:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202ed0:	03000513          	li	a0,48
{
ffffffffc0202ed4:	fc06                	sd	ra,56(sp)
ffffffffc0202ed6:	f822                	sd	s0,48(sp)
ffffffffc0202ed8:	f426                	sd	s1,40(sp)
ffffffffc0202eda:	f04a                	sd	s2,32(sp)
ffffffffc0202edc:	ec4e                	sd	s3,24(sp)
ffffffffc0202ede:	e852                	sd	s4,16(sp)
ffffffffc0202ee0:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202ee2:	bd5fe0ef          	jal	ra,ffffffffc0201ab6 <kmalloc>
    if (mm != NULL)
ffffffffc0202ee6:	2e050f63          	beqz	a0,ffffffffc02031e4 <vmm_init+0x316>
ffffffffc0202eea:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0202eec:	e508                	sd	a0,8(a0)
ffffffffc0202eee:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202ef0:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202ef4:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202ef8:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0202efc:	02053423          	sd	zero,40(a0)
ffffffffc0202f00:	03200413          	li	s0,50
ffffffffc0202f04:	a811                	j	ffffffffc0202f18 <vmm_init+0x4a>
        vma->vm_start = vm_start;
ffffffffc0202f06:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202f08:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202f0a:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0202f0e:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202f10:	8526                	mv	a0,s1
ffffffffc0202f12:	eedff0ef          	jal	ra,ffffffffc0202dfe <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0202f16:	c80d                	beqz	s0,ffffffffc0202f48 <vmm_init+0x7a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f18:	03000513          	li	a0,48
ffffffffc0202f1c:	b9bfe0ef          	jal	ra,ffffffffc0201ab6 <kmalloc>
ffffffffc0202f20:	85aa                	mv	a1,a0
ffffffffc0202f22:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0202f26:	f165                	bnez	a0,ffffffffc0202f06 <vmm_init+0x38>
        assert(vma != NULL);
ffffffffc0202f28:	00002697          	auipc	a3,0x2
ffffffffc0202f2c:	69868693          	addi	a3,a3,1688 # ffffffffc02055c0 <default_pmm_manager+0x900>
ffffffffc0202f30:	00002617          	auipc	a2,0x2
ffffffffc0202f34:	9e060613          	addi	a2,a2,-1568 # ffffffffc0204910 <commands+0x818>
ffffffffc0202f38:	0da00593          	li	a1,218
ffffffffc0202f3c:	00002517          	auipc	a0,0x2
ffffffffc0202f40:	49c50513          	addi	a0,a0,1180 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0202f44:	d16fd0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0202f48:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f4c:	1f900913          	li	s2,505
ffffffffc0202f50:	a819                	j	ffffffffc0202f66 <vmm_init+0x98>
        vma->vm_start = vm_start;
ffffffffc0202f52:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202f54:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202f56:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f5a:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202f5c:	8526                	mv	a0,s1
ffffffffc0202f5e:	ea1ff0ef          	jal	ra,ffffffffc0202dfe <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202f62:	03240a63          	beq	s0,s2,ffffffffc0202f96 <vmm_init+0xc8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202f66:	03000513          	li	a0,48
ffffffffc0202f6a:	b4dfe0ef          	jal	ra,ffffffffc0201ab6 <kmalloc>
ffffffffc0202f6e:	85aa                	mv	a1,a0
ffffffffc0202f70:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0202f74:	fd79                	bnez	a0,ffffffffc0202f52 <vmm_init+0x84>
        assert(vma != NULL);
ffffffffc0202f76:	00002697          	auipc	a3,0x2
ffffffffc0202f7a:	64a68693          	addi	a3,a3,1610 # ffffffffc02055c0 <default_pmm_manager+0x900>
ffffffffc0202f7e:	00002617          	auipc	a2,0x2
ffffffffc0202f82:	99260613          	addi	a2,a2,-1646 # ffffffffc0204910 <commands+0x818>
ffffffffc0202f86:	0e100593          	li	a1,225
ffffffffc0202f8a:	00002517          	auipc	a0,0x2
ffffffffc0202f8e:	44e50513          	addi	a0,a0,1102 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0202f92:	cc8fd0ef          	jal	ra,ffffffffc020045a <__panic>
    return listelm->next;
ffffffffc0202f96:	649c                	ld	a5,8(s1)
ffffffffc0202f98:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0202f9a:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0202f9e:	18f48363          	beq	s1,a5,ffffffffc0203124 <vmm_init+0x256>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202fa2:	fe87b603          	ld	a2,-24(a5)
ffffffffc0202fa6:	ffe70693          	addi	a3,a4,-2 # ffe <kern_entry-0xffffffffc01ff002>
ffffffffc0202faa:	10d61d63          	bne	a2,a3,ffffffffc02030c4 <vmm_init+0x1f6>
ffffffffc0202fae:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202fb2:	10e69963          	bne	a3,a4,ffffffffc02030c4 <vmm_init+0x1f6>
    for (i = 1; i <= step2; i++)
ffffffffc0202fb6:	0715                	addi	a4,a4,5
ffffffffc0202fb8:	679c                	ld	a5,8(a5)
ffffffffc0202fba:	feb712e3          	bne	a4,a1,ffffffffc0202f9e <vmm_init+0xd0>
ffffffffc0202fbe:	4a1d                	li	s4,7
ffffffffc0202fc0:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0202fc2:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0202fc6:	85a2                	mv	a1,s0
ffffffffc0202fc8:	8526                	mv	a0,s1
ffffffffc0202fca:	df5ff0ef          	jal	ra,ffffffffc0202dbe <find_vma>
ffffffffc0202fce:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0202fd0:	18050a63          	beqz	a0,ffffffffc0203164 <vmm_init+0x296>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0202fd4:	00140593          	addi	a1,s0,1
ffffffffc0202fd8:	8526                	mv	a0,s1
ffffffffc0202fda:	de5ff0ef          	jal	ra,ffffffffc0202dbe <find_vma>
ffffffffc0202fde:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202fe0:	16050263          	beqz	a0,ffffffffc0203144 <vmm_init+0x276>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0202fe4:	85d2                	mv	a1,s4
ffffffffc0202fe6:	8526                	mv	a0,s1
ffffffffc0202fe8:	dd7ff0ef          	jal	ra,ffffffffc0202dbe <find_vma>
        assert(vma3 == NULL);
ffffffffc0202fec:	18051c63          	bnez	a0,ffffffffc0203184 <vmm_init+0x2b6>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0202ff0:	00340593          	addi	a1,s0,3
ffffffffc0202ff4:	8526                	mv	a0,s1
ffffffffc0202ff6:	dc9ff0ef          	jal	ra,ffffffffc0202dbe <find_vma>
        assert(vma4 == NULL);
ffffffffc0202ffa:	1c051563          	bnez	a0,ffffffffc02031c4 <vmm_init+0x2f6>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0202ffe:	00440593          	addi	a1,s0,4
ffffffffc0203002:	8526                	mv	a0,s1
ffffffffc0203004:	dbbff0ef          	jal	ra,ffffffffc0202dbe <find_vma>
        assert(vma5 == NULL);
ffffffffc0203008:	18051e63          	bnez	a0,ffffffffc02031a4 <vmm_init+0x2d6>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc020300c:	00893783          	ld	a5,8(s2)
ffffffffc0203010:	0c879a63          	bne	a5,s0,ffffffffc02030e4 <vmm_init+0x216>
ffffffffc0203014:	01093783          	ld	a5,16(s2)
ffffffffc0203018:	0d479663          	bne	a5,s4,ffffffffc02030e4 <vmm_init+0x216>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc020301c:	0089b783          	ld	a5,8(s3)
ffffffffc0203020:	0e879263          	bne	a5,s0,ffffffffc0203104 <vmm_init+0x236>
ffffffffc0203024:	0109b783          	ld	a5,16(s3)
ffffffffc0203028:	0d479e63          	bne	a5,s4,ffffffffc0203104 <vmm_init+0x236>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc020302c:	0415                	addi	s0,s0,5
ffffffffc020302e:	0a15                	addi	s4,s4,5
ffffffffc0203030:	f9541be3          	bne	s0,s5,ffffffffc0202fc6 <vmm_init+0xf8>
ffffffffc0203034:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0203036:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0203038:	85a2                	mv	a1,s0
ffffffffc020303a:	8526                	mv	a0,s1
ffffffffc020303c:	d83ff0ef          	jal	ra,ffffffffc0202dbe <find_vma>
ffffffffc0203040:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0203044:	c90d                	beqz	a0,ffffffffc0203076 <vmm_init+0x1a8>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0203046:	6914                	ld	a3,16(a0)
ffffffffc0203048:	6510                	ld	a2,8(a0)
ffffffffc020304a:	00002517          	auipc	a0,0x2
ffffffffc020304e:	4fe50513          	addi	a0,a0,1278 # ffffffffc0205548 <default_pmm_manager+0x888>
ffffffffc0203052:	942fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0203056:	00002697          	auipc	a3,0x2
ffffffffc020305a:	51a68693          	addi	a3,a3,1306 # ffffffffc0205570 <default_pmm_manager+0x8b0>
ffffffffc020305e:	00002617          	auipc	a2,0x2
ffffffffc0203062:	8b260613          	addi	a2,a2,-1870 # ffffffffc0204910 <commands+0x818>
ffffffffc0203066:	10700593          	li	a1,263
ffffffffc020306a:	00002517          	auipc	a0,0x2
ffffffffc020306e:	36e50513          	addi	a0,a0,878 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0203072:	be8fd0ef          	jal	ra,ffffffffc020045a <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0203076:	147d                	addi	s0,s0,-1
ffffffffc0203078:	fd2410e3          	bne	s0,s2,ffffffffc0203038 <vmm_init+0x16a>
ffffffffc020307c:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc020307e:	00a48c63          	beq	s1,a0,ffffffffc0203096 <vmm_init+0x1c8>
    __list_del(listelm->prev, listelm->next);
ffffffffc0203082:	6118                	ld	a4,0(a0)
ffffffffc0203084:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0203086:	1501                	addi	a0,a0,-32
    prev->next = next;
ffffffffc0203088:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020308a:	e398                	sd	a4,0(a5)
ffffffffc020308c:	adbfe0ef          	jal	ra,ffffffffc0201b66 <kfree>
    return listelm->next;
ffffffffc0203090:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc0203092:	fea498e3          	bne	s1,a0,ffffffffc0203082 <vmm_init+0x1b4>
    kfree(mm); // kfree mm
ffffffffc0203096:	8526                	mv	a0,s1
ffffffffc0203098:	acffe0ef          	jal	ra,ffffffffc0201b66 <kfree>
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc020309c:	00002517          	auipc	a0,0x2
ffffffffc02030a0:	4ec50513          	addi	a0,a0,1260 # ffffffffc0205588 <default_pmm_manager+0x8c8>
ffffffffc02030a4:	8f0fd0ef          	jal	ra,ffffffffc0200194 <cprintf>
}
ffffffffc02030a8:	7442                	ld	s0,48(sp)
ffffffffc02030aa:	70e2                	ld	ra,56(sp)
ffffffffc02030ac:	74a2                	ld	s1,40(sp)
ffffffffc02030ae:	7902                	ld	s2,32(sp)
ffffffffc02030b0:	69e2                	ld	s3,24(sp)
ffffffffc02030b2:	6a42                	ld	s4,16(sp)
ffffffffc02030b4:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc02030b6:	00002517          	auipc	a0,0x2
ffffffffc02030ba:	4f250513          	addi	a0,a0,1266 # ffffffffc02055a8 <default_pmm_manager+0x8e8>
}
ffffffffc02030be:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc02030c0:	8d4fd06f          	j	ffffffffc0200194 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc02030c4:	00002697          	auipc	a3,0x2
ffffffffc02030c8:	39c68693          	addi	a3,a3,924 # ffffffffc0205460 <default_pmm_manager+0x7a0>
ffffffffc02030cc:	00002617          	auipc	a2,0x2
ffffffffc02030d0:	84460613          	addi	a2,a2,-1980 # ffffffffc0204910 <commands+0x818>
ffffffffc02030d4:	0eb00593          	li	a1,235
ffffffffc02030d8:	00002517          	auipc	a0,0x2
ffffffffc02030dc:	30050513          	addi	a0,a0,768 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc02030e0:	b7afd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc02030e4:	00002697          	auipc	a3,0x2
ffffffffc02030e8:	40468693          	addi	a3,a3,1028 # ffffffffc02054e8 <default_pmm_manager+0x828>
ffffffffc02030ec:	00002617          	auipc	a2,0x2
ffffffffc02030f0:	82460613          	addi	a2,a2,-2012 # ffffffffc0204910 <commands+0x818>
ffffffffc02030f4:	0fc00593          	li	a1,252
ffffffffc02030f8:	00002517          	auipc	a0,0x2
ffffffffc02030fc:	2e050513          	addi	a0,a0,736 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0203100:	b5afd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0203104:	00002697          	auipc	a3,0x2
ffffffffc0203108:	41468693          	addi	a3,a3,1044 # ffffffffc0205518 <default_pmm_manager+0x858>
ffffffffc020310c:	00002617          	auipc	a2,0x2
ffffffffc0203110:	80460613          	addi	a2,a2,-2044 # ffffffffc0204910 <commands+0x818>
ffffffffc0203114:	0fd00593          	li	a1,253
ffffffffc0203118:	00002517          	auipc	a0,0x2
ffffffffc020311c:	2c050513          	addi	a0,a0,704 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0203120:	b3afd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0203124:	00002697          	auipc	a3,0x2
ffffffffc0203128:	32468693          	addi	a3,a3,804 # ffffffffc0205448 <default_pmm_manager+0x788>
ffffffffc020312c:	00001617          	auipc	a2,0x1
ffffffffc0203130:	7e460613          	addi	a2,a2,2020 # ffffffffc0204910 <commands+0x818>
ffffffffc0203134:	0e900593          	li	a1,233
ffffffffc0203138:	00002517          	auipc	a0,0x2
ffffffffc020313c:	2a050513          	addi	a0,a0,672 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0203140:	b1afd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma2 != NULL);
ffffffffc0203144:	00002697          	auipc	a3,0x2
ffffffffc0203148:	36468693          	addi	a3,a3,868 # ffffffffc02054a8 <default_pmm_manager+0x7e8>
ffffffffc020314c:	00001617          	auipc	a2,0x1
ffffffffc0203150:	7c460613          	addi	a2,a2,1988 # ffffffffc0204910 <commands+0x818>
ffffffffc0203154:	0f400593          	li	a1,244
ffffffffc0203158:	00002517          	auipc	a0,0x2
ffffffffc020315c:	28050513          	addi	a0,a0,640 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0203160:	afafd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma1 != NULL);
ffffffffc0203164:	00002697          	auipc	a3,0x2
ffffffffc0203168:	33468693          	addi	a3,a3,820 # ffffffffc0205498 <default_pmm_manager+0x7d8>
ffffffffc020316c:	00001617          	auipc	a2,0x1
ffffffffc0203170:	7a460613          	addi	a2,a2,1956 # ffffffffc0204910 <commands+0x818>
ffffffffc0203174:	0f200593          	li	a1,242
ffffffffc0203178:	00002517          	auipc	a0,0x2
ffffffffc020317c:	26050513          	addi	a0,a0,608 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0203180:	adafd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma3 == NULL);
ffffffffc0203184:	00002697          	auipc	a3,0x2
ffffffffc0203188:	33468693          	addi	a3,a3,820 # ffffffffc02054b8 <default_pmm_manager+0x7f8>
ffffffffc020318c:	00001617          	auipc	a2,0x1
ffffffffc0203190:	78460613          	addi	a2,a2,1924 # ffffffffc0204910 <commands+0x818>
ffffffffc0203194:	0f600593          	li	a1,246
ffffffffc0203198:	00002517          	auipc	a0,0x2
ffffffffc020319c:	24050513          	addi	a0,a0,576 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc02031a0:	abafd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma5 == NULL);
ffffffffc02031a4:	00002697          	auipc	a3,0x2
ffffffffc02031a8:	33468693          	addi	a3,a3,820 # ffffffffc02054d8 <default_pmm_manager+0x818>
ffffffffc02031ac:	00001617          	auipc	a2,0x1
ffffffffc02031b0:	76460613          	addi	a2,a2,1892 # ffffffffc0204910 <commands+0x818>
ffffffffc02031b4:	0fa00593          	li	a1,250
ffffffffc02031b8:	00002517          	auipc	a0,0x2
ffffffffc02031bc:	22050513          	addi	a0,a0,544 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc02031c0:	a9afd0ef          	jal	ra,ffffffffc020045a <__panic>
        assert(vma4 == NULL);
ffffffffc02031c4:	00002697          	auipc	a3,0x2
ffffffffc02031c8:	30468693          	addi	a3,a3,772 # ffffffffc02054c8 <default_pmm_manager+0x808>
ffffffffc02031cc:	00001617          	auipc	a2,0x1
ffffffffc02031d0:	74460613          	addi	a2,a2,1860 # ffffffffc0204910 <commands+0x818>
ffffffffc02031d4:	0f800593          	li	a1,248
ffffffffc02031d8:	00002517          	auipc	a0,0x2
ffffffffc02031dc:	20050513          	addi	a0,a0,512 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc02031e0:	a7afd0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(mm != NULL);
ffffffffc02031e4:	00002697          	auipc	a3,0x2
ffffffffc02031e8:	3ec68693          	addi	a3,a3,1004 # ffffffffc02055d0 <default_pmm_manager+0x910>
ffffffffc02031ec:	00001617          	auipc	a2,0x1
ffffffffc02031f0:	72460613          	addi	a2,a2,1828 # ffffffffc0204910 <commands+0x818>
ffffffffc02031f4:	0d200593          	li	a1,210
ffffffffc02031f8:	00002517          	auipc	a0,0x2
ffffffffc02031fc:	1e050513          	addi	a0,a0,480 # ffffffffc02053d8 <default_pmm_manager+0x718>
ffffffffc0203200:	a5afd0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203204 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203204:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203206:	9402                	jalr	s0

	jal do_exit
ffffffffc0203208:	3d8000ef          	jal	ra,ffffffffc02035e0 <do_exit>

ffffffffc020320c <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc020320c:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020320e:	0e800513          	li	a0,232
{
ffffffffc0203212:	e022                	sd	s0,0(sp)
ffffffffc0203214:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203216:	8a1fe0ef          	jal	ra,ffffffffc0201ab6 <kmalloc>
ffffffffc020321a:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc020321c:	c521                	beqz	a0,ffffffffc0203264 <alloc_proc+0x58>
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
        
        proc->state = PROC_UNINIT;
ffffffffc020321e:	57fd                	li	a5,-1
ffffffffc0203220:	1782                	slli	a5,a5,0x20
ffffffffc0203222:	e11c                	sd	a5,0(a0)
        proc->runs = 0;
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203224:	07000613          	li	a2,112
ffffffffc0203228:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc020322a:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc020322e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203232:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203236:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc020323a:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc020323e:	03050513          	addi	a0,a0,48
ffffffffc0203242:	3fb000ef          	jal	ra,ffffffffc0203e3c <memset>
        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203246:	0000a797          	auipc	a5,0xa
ffffffffc020324a:	25a7b783          	ld	a5,602(a5) # ffffffffc020d4a0 <boot_pgdir_pa>
        proc->tf = NULL;
ffffffffc020324e:	0a043023          	sd	zero,160(s0)
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203252:	f45c                	sd	a5,168(s0)
        proc->flags = 0;
ffffffffc0203254:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, PROC_NAME_LEN + 1);
ffffffffc0203258:	4641                	li	a2,16
ffffffffc020325a:	4581                	li	a1,0
ffffffffc020325c:	0b440513          	addi	a0,s0,180
ffffffffc0203260:	3dd000ef          	jal	ra,ffffffffc0203e3c <memset>
    }
    return proc;
}
ffffffffc0203264:	60a2                	ld	ra,8(sp)
ffffffffc0203266:	8522                	mv	a0,s0
ffffffffc0203268:	6402                	ld	s0,0(sp)
ffffffffc020326a:	0141                	addi	sp,sp,16
ffffffffc020326c:	8082                	ret

ffffffffc020326e <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc020326e:	0000a797          	auipc	a5,0xa
ffffffffc0203272:	2627b783          	ld	a5,610(a5) # ffffffffc020d4d0 <current>
ffffffffc0203276:	73c8                	ld	a0,160(a5)
ffffffffc0203278:	b5dfd06f          	j	ffffffffc0200dd4 <forkrets>

ffffffffc020327c <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020327c:	7179                	addi	sp,sp,-48
ffffffffc020327e:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc0203280:	0000a497          	auipc	s1,0xa
ffffffffc0203284:	1c848493          	addi	s1,s1,456 # ffffffffc020d448 <name.2>
{
ffffffffc0203288:	f022                	sd	s0,32(sp)
ffffffffc020328a:	e84a                	sd	s2,16(sp)
ffffffffc020328c:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc020328e:	0000a917          	auipc	s2,0xa
ffffffffc0203292:	24293903          	ld	s2,578(s2) # ffffffffc020d4d0 <current>
    memset(name, 0, sizeof(name));
ffffffffc0203296:	4641                	li	a2,16
ffffffffc0203298:	4581                	li	a1,0
ffffffffc020329a:	8526                	mv	a0,s1
{
ffffffffc020329c:	f406                	sd	ra,40(sp)
ffffffffc020329e:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02032a0:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc02032a4:	399000ef          	jal	ra,ffffffffc0203e3c <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc02032a8:	0b490593          	addi	a1,s2,180
ffffffffc02032ac:	463d                	li	a2,15
ffffffffc02032ae:	8526                	mv	a0,s1
ffffffffc02032b0:	39f000ef          	jal	ra,ffffffffc0203e4e <memcpy>
ffffffffc02032b4:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc02032b6:	85ce                	mv	a1,s3
ffffffffc02032b8:	00002517          	auipc	a0,0x2
ffffffffc02032bc:	32850513          	addi	a0,a0,808 # ffffffffc02055e0 <default_pmm_manager+0x920>
ffffffffc02032c0:	ed5fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc02032c4:	85a2                	mv	a1,s0
ffffffffc02032c6:	00002517          	auipc	a0,0x2
ffffffffc02032ca:	34250513          	addi	a0,a0,834 # ffffffffc0205608 <default_pmm_manager+0x948>
ffffffffc02032ce:	ec7fc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc02032d2:	00002517          	auipc	a0,0x2
ffffffffc02032d6:	34650513          	addi	a0,a0,838 # ffffffffc0205618 <default_pmm_manager+0x958>
ffffffffc02032da:	ebbfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    return 0;
}
ffffffffc02032de:	70a2                	ld	ra,40(sp)
ffffffffc02032e0:	7402                	ld	s0,32(sp)
ffffffffc02032e2:	64e2                	ld	s1,24(sp)
ffffffffc02032e4:	6942                	ld	s2,16(sp)
ffffffffc02032e6:	69a2                	ld	s3,8(sp)
ffffffffc02032e8:	4501                	li	a0,0
ffffffffc02032ea:	6145                	addi	sp,sp,48
ffffffffc02032ec:	8082                	ret

ffffffffc02032ee <proc_run>:
{
ffffffffc02032ee:	7179                	addi	sp,sp,-48
ffffffffc02032f0:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc02032f2:	0000a917          	auipc	s2,0xa
ffffffffc02032f6:	1de90913          	addi	s2,s2,478 # ffffffffc020d4d0 <current>
{
ffffffffc02032fa:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc02032fc:	00093483          	ld	s1,0(s2)
{
ffffffffc0203300:	f406                	sd	ra,40(sp)
ffffffffc0203302:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203304:	02a48963          	beq	s1,a0,ffffffffc0203336 <proc_run+0x48>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203308:	100027f3          	csrr	a5,sstatus
ffffffffc020330c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020330e:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203310:	e3a1                	bnez	a5,ffffffffc0203350 <proc_run+0x62>
        lsatp(current->pgdir);
ffffffffc0203312:	755c                	ld	a5,168(a0)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned int pgdir)
{
  write_csr(satp, SATP32_MODE | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203314:	80000737          	lui	a4,0x80000
        current=proc;
ffffffffc0203318:	00a93023          	sd	a0,0(s2)
ffffffffc020331c:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc0203320:	8fd9                	or	a5,a5,a4
ffffffffc0203322:	18079073          	csrw	satp,a5
        switch_to(&(prev->context),&(current->context));
ffffffffc0203326:	03050593          	addi	a1,a0,48
ffffffffc020332a:	03048513          	addi	a0,s1,48
ffffffffc020332e:	538000ef          	jal	ra,ffffffffc0203866 <switch_to>
    if (flag) {
ffffffffc0203332:	00099863          	bnez	s3,ffffffffc0203342 <proc_run+0x54>
}
ffffffffc0203336:	70a2                	ld	ra,40(sp)
ffffffffc0203338:	7482                	ld	s1,32(sp)
ffffffffc020333a:	6962                	ld	s2,24(sp)
ffffffffc020333c:	69c2                	ld	s3,16(sp)
ffffffffc020333e:	6145                	addi	sp,sp,48
ffffffffc0203340:	8082                	ret
ffffffffc0203342:	70a2                	ld	ra,40(sp)
ffffffffc0203344:	7482                	ld	s1,32(sp)
ffffffffc0203346:	6962                	ld	s2,24(sp)
ffffffffc0203348:	69c2                	ld	s3,16(sp)
ffffffffc020334a:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc020334c:	ddefd06f          	j	ffffffffc020092a <intr_enable>
ffffffffc0203350:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0203352:	ddefd0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc0203356:	6522                	ld	a0,8(sp)
ffffffffc0203358:	4985                	li	s3,1
ffffffffc020335a:	bf65                	j	ffffffffc0203312 <proc_run+0x24>

ffffffffc020335c <do_fork>:
{
ffffffffc020335c:	7179                	addi	sp,sp,-48
ffffffffc020335e:	ec26                	sd	s1,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203360:	0000a497          	auipc	s1,0xa
ffffffffc0203364:	18848493          	addi	s1,s1,392 # ffffffffc020d4e8 <nr_process>
ffffffffc0203368:	4098                	lw	a4,0(s1)
{
ffffffffc020336a:	f406                	sd	ra,40(sp)
ffffffffc020336c:	f022                	sd	s0,32(sp)
ffffffffc020336e:	e84a                	sd	s2,16(sp)
ffffffffc0203370:	e44e                	sd	s3,8(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0203372:	6785                	lui	a5,0x1
ffffffffc0203374:	1cf75b63          	bge	a4,a5,ffffffffc020354a <do_fork+0x1ee>
ffffffffc0203378:	892e                	mv	s2,a1
ffffffffc020337a:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL)
ffffffffc020337c:	e91ff0ef          	jal	ra,ffffffffc020320c <alloc_proc>
ffffffffc0203380:	89aa                	mv	s3,a0
ffffffffc0203382:	1c050963          	beqz	a0,ffffffffc0203554 <do_fork+0x1f8>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203386:	4509                	li	a0,2
ffffffffc0203388:	90dfe0ef          	jal	ra,ffffffffc0201c94 <alloc_pages>
    if (page != NULL)
ffffffffc020338c:	1a050a63          	beqz	a0,ffffffffc0203540 <do_fork+0x1e4>
    return page - pages + nbase;
ffffffffc0203390:	0000a697          	auipc	a3,0xa
ffffffffc0203394:	1286b683          	ld	a3,296(a3) # ffffffffc020d4b8 <pages>
ffffffffc0203398:	40d506b3          	sub	a3,a0,a3
ffffffffc020339c:	8699                	srai	a3,a3,0x6
ffffffffc020339e:	00002517          	auipc	a0,0x2
ffffffffc02033a2:	63a53503          	ld	a0,1594(a0) # ffffffffc02059d8 <nbase>
ffffffffc02033a6:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc02033a8:	00c69793          	slli	a5,a3,0xc
ffffffffc02033ac:	83b1                	srli	a5,a5,0xc
ffffffffc02033ae:	0000a717          	auipc	a4,0xa
ffffffffc02033b2:	10273703          	ld	a4,258(a4) # ffffffffc020d4b0 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc02033b6:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02033b8:	1ce7f063          	bgeu	a5,a4,ffffffffc0203578 <do_fork+0x21c>
    assert(current->mm == NULL);
ffffffffc02033bc:	0000a797          	auipc	a5,0xa
ffffffffc02033c0:	1147b783          	ld	a5,276(a5) # ffffffffc020d4d0 <current>
ffffffffc02033c4:	779c                	ld	a5,40(a5)
ffffffffc02033c6:	0000a717          	auipc	a4,0xa
ffffffffc02033ca:	10273703          	ld	a4,258(a4) # ffffffffc020d4c8 <va_pa_offset>
ffffffffc02033ce:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02033d0:	00d9b823          	sd	a3,16(s3)
    assert(current->mm == NULL);
ffffffffc02033d4:	18079263          	bnez	a5,ffffffffc0203558 <do_fork+0x1fc>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02033d8:	6789                	lui	a5,0x2
ffffffffc02033da:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc02033de:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02033e0:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc02033e2:	0ad9b023          	sd	a3,160(s3)
    *(proc->tf) = *tf;
ffffffffc02033e6:	87b6                	mv	a5,a3
ffffffffc02033e8:	12040893          	addi	a7,s0,288
ffffffffc02033ec:	00063803          	ld	a6,0(a2)
ffffffffc02033f0:	6608                	ld	a0,8(a2)
ffffffffc02033f2:	6a0c                	ld	a1,16(a2)
ffffffffc02033f4:	6e18                	ld	a4,24(a2)
ffffffffc02033f6:	0107b023          	sd	a6,0(a5)
ffffffffc02033fa:	e788                	sd	a0,8(a5)
ffffffffc02033fc:	eb8c                	sd	a1,16(a5)
ffffffffc02033fe:	ef98                	sd	a4,24(a5)
ffffffffc0203400:	02060613          	addi	a2,a2,32
ffffffffc0203404:	02078793          	addi	a5,a5,32
ffffffffc0203408:	ff1612e3          	bne	a2,a7,ffffffffc02033ec <do_fork+0x90>
    proc->tf->gpr.a0 = 0;
ffffffffc020340c:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203410:	10090c63          	beqz	s2,ffffffffc0203528 <do_fork+0x1cc>
    if (++last_pid >= MAX_PID)
ffffffffc0203414:	00006817          	auipc	a6,0x6
ffffffffc0203418:	c1480813          	addi	a6,a6,-1004 # ffffffffc0209028 <last_pid.1>
ffffffffc020341c:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203420:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203424:	00000717          	auipc	a4,0x0
ffffffffc0203428:	e4a70713          	addi	a4,a4,-438 # ffffffffc020326e <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc020342c:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0203430:	02e9b823          	sd	a4,48(s3)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0203434:	02d9bc23          	sd	a3,56(s3)
    if (++last_pid >= MAX_PID)
ffffffffc0203438:	00a82023          	sw	a0,0(a6)
ffffffffc020343c:	6789                	lui	a5,0x2
ffffffffc020343e:	06f55e63          	bge	a0,a5,ffffffffc02034ba <do_fork+0x15e>
    if (last_pid >= next_safe)
ffffffffc0203442:	00006317          	auipc	t1,0x6
ffffffffc0203446:	bea30313          	addi	t1,t1,-1046 # ffffffffc020902c <next_safe.0>
ffffffffc020344a:	00032783          	lw	a5,0(t1)
ffffffffc020344e:	0000a417          	auipc	s0,0xa
ffffffffc0203452:	00a40413          	addi	s0,s0,10 # ffffffffc020d458 <proc_list>
ffffffffc0203456:	06f55a63          	bge	a0,a5,ffffffffc02034ca <do_fork+0x16e>
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020345a:	45a9                	li	a1,10
    proc->pid = get_pid();
ffffffffc020345c:	00a9a223          	sw	a0,4(s3)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0203460:	2501                	sext.w	a0,a0
ffffffffc0203462:	534000ef          	jal	ra,ffffffffc0203996 <hash32>
ffffffffc0203466:	02051793          	slli	a5,a0,0x20
ffffffffc020346a:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020346e:	00006797          	auipc	a5,0x6
ffffffffc0203472:	fda78793          	addi	a5,a5,-38 # ffffffffc0209448 <hash_list>
ffffffffc0203476:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0203478:	6518                	ld	a4,8(a0)
ffffffffc020347a:	0d898793          	addi	a5,s3,216
ffffffffc020347e:	6414                	ld	a3,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203480:	e31c                	sd	a5,0(a4)
ffffffffc0203482:	e51c                	sd	a5,8(a0)
    nr_process++;
ffffffffc0203484:	409c                	lw	a5,0(s1)
    elm->next = next;
ffffffffc0203486:	0ee9b023          	sd	a4,224(s3)
    elm->prev = prev;
ffffffffc020348a:	0ca9bc23          	sd	a0,216(s3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc020348e:	0c898713          	addi	a4,s3,200
    prev->next = next->prev = elm;
ffffffffc0203492:	e298                	sd	a4,0(a3)
    nr_process++;
ffffffffc0203494:	2785                	addiw	a5,a5,1
    wakeup_proc(proc);
ffffffffc0203496:	854e                	mv	a0,s3
    elm->next = next;
ffffffffc0203498:	0cd9b823          	sd	a3,208(s3)
    elm->prev = prev;
ffffffffc020349c:	0c89b423          	sd	s0,200(s3)
    prev->next = next->prev = elm;
ffffffffc02034a0:	e418                	sd	a4,8(s0)
    nr_process++;
ffffffffc02034a2:	c09c                	sw	a5,0(s1)
    wakeup_proc(proc);
ffffffffc02034a4:	42c000ef          	jal	ra,ffffffffc02038d0 <wakeup_proc>
    ret = proc->pid;
ffffffffc02034a8:	0049a503          	lw	a0,4(s3)
}
ffffffffc02034ac:	70a2                	ld	ra,40(sp)
ffffffffc02034ae:	7402                	ld	s0,32(sp)
ffffffffc02034b0:	64e2                	ld	s1,24(sp)
ffffffffc02034b2:	6942                	ld	s2,16(sp)
ffffffffc02034b4:	69a2                	ld	s3,8(sp)
ffffffffc02034b6:	6145                	addi	sp,sp,48
ffffffffc02034b8:	8082                	ret
        last_pid = 1;
ffffffffc02034ba:	4785                	li	a5,1
ffffffffc02034bc:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02034c0:	4505                	li	a0,1
ffffffffc02034c2:	00006317          	auipc	t1,0x6
ffffffffc02034c6:	b6a30313          	addi	t1,t1,-1174 # ffffffffc020902c <next_safe.0>
    return listelm->next;
ffffffffc02034ca:	0000a417          	auipc	s0,0xa
ffffffffc02034ce:	f8e40413          	addi	s0,s0,-114 # ffffffffc020d458 <proc_list>
ffffffffc02034d2:	00843e03          	ld	t3,8(s0)
        next_safe = MAX_PID;
ffffffffc02034d6:	6789                	lui	a5,0x2
ffffffffc02034d8:	00f32023          	sw	a5,0(t1)
ffffffffc02034dc:	86aa                	mv	a3,a0
ffffffffc02034de:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc02034e0:	6e89                	lui	t4,0x2
ffffffffc02034e2:	048e0a63          	beq	t3,s0,ffffffffc0203536 <do_fork+0x1da>
ffffffffc02034e6:	88ae                	mv	a7,a1
ffffffffc02034e8:	87f2                	mv	a5,t3
ffffffffc02034ea:	6609                	lui	a2,0x2
ffffffffc02034ec:	a811                	j	ffffffffc0203500 <do_fork+0x1a4>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc02034ee:	00e6d663          	bge	a3,a4,ffffffffc02034fa <do_fork+0x19e>
ffffffffc02034f2:	00c75463          	bge	a4,a2,ffffffffc02034fa <do_fork+0x19e>
ffffffffc02034f6:	863a                	mv	a2,a4
ffffffffc02034f8:	4885                	li	a7,1
ffffffffc02034fa:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02034fc:	00878d63          	beq	a5,s0,ffffffffc0203516 <do_fork+0x1ba>
            if (proc->pid == last_pid)
ffffffffc0203500:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc0203504:	fed715e3          	bne	a4,a3,ffffffffc02034ee <do_fork+0x192>
                if (++last_pid >= next_safe)
ffffffffc0203508:	2685                	addiw	a3,a3,1
ffffffffc020350a:	02c6d163          	bge	a3,a2,ffffffffc020352c <do_fork+0x1d0>
ffffffffc020350e:	679c                	ld	a5,8(a5)
ffffffffc0203510:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0203512:	fe8797e3          	bne	a5,s0,ffffffffc0203500 <do_fork+0x1a4>
ffffffffc0203516:	c581                	beqz	a1,ffffffffc020351e <do_fork+0x1c2>
ffffffffc0203518:	00d82023          	sw	a3,0(a6)
ffffffffc020351c:	8536                	mv	a0,a3
ffffffffc020351e:	f2088ee3          	beqz	a7,ffffffffc020345a <do_fork+0xfe>
ffffffffc0203522:	00c32023          	sw	a2,0(t1)
ffffffffc0203526:	bf15                	j	ffffffffc020345a <do_fork+0xfe>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0203528:	8936                	mv	s2,a3
ffffffffc020352a:	b5ed                	j	ffffffffc0203414 <do_fork+0xb8>
                    if (last_pid >= MAX_PID)
ffffffffc020352c:	01d6c363          	blt	a3,t4,ffffffffc0203532 <do_fork+0x1d6>
                        last_pid = 1;
ffffffffc0203530:	4685                	li	a3,1
                    goto repeat;
ffffffffc0203532:	4585                	li	a1,1
ffffffffc0203534:	b77d                	j	ffffffffc02034e2 <do_fork+0x186>
ffffffffc0203536:	cd81                	beqz	a1,ffffffffc020354e <do_fork+0x1f2>
ffffffffc0203538:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020353c:	8536                	mv	a0,a3
ffffffffc020353e:	bf31                	j	ffffffffc020345a <do_fork+0xfe>
    kfree(proc);
ffffffffc0203540:	854e                	mv	a0,s3
ffffffffc0203542:	e24fe0ef          	jal	ra,ffffffffc0201b66 <kfree>
    ret = -E_NO_MEM;
ffffffffc0203546:	5571                	li	a0,-4
    goto fork_out;
ffffffffc0203548:	b795                	j	ffffffffc02034ac <do_fork+0x150>
    int ret = -E_NO_FREE_PROC;
ffffffffc020354a:	556d                	li	a0,-5
ffffffffc020354c:	b785                	j	ffffffffc02034ac <do_fork+0x150>
    return last_pid;
ffffffffc020354e:	00082503          	lw	a0,0(a6)
ffffffffc0203552:	b721                	j	ffffffffc020345a <do_fork+0xfe>
    ret = -E_NO_MEM;
ffffffffc0203554:	5571                	li	a0,-4
    return ret;
ffffffffc0203556:	bf99                	j	ffffffffc02034ac <do_fork+0x150>
    assert(current->mm == NULL);
ffffffffc0203558:	00002697          	auipc	a3,0x2
ffffffffc020355c:	0e068693          	addi	a3,a3,224 # ffffffffc0205638 <default_pmm_manager+0x978>
ffffffffc0203560:	00001617          	auipc	a2,0x1
ffffffffc0203564:	3b060613          	addi	a2,a2,944 # ffffffffc0204910 <commands+0x818>
ffffffffc0203568:	11c00593          	li	a1,284
ffffffffc020356c:	00002517          	auipc	a0,0x2
ffffffffc0203570:	0e450513          	addi	a0,a0,228 # ffffffffc0205650 <default_pmm_manager+0x990>
ffffffffc0203574:	ee7fc0ef          	jal	ra,ffffffffc020045a <__panic>
ffffffffc0203578:	00001617          	auipc	a2,0x1
ffffffffc020357c:	78060613          	addi	a2,a2,1920 # ffffffffc0204cf8 <default_pmm_manager+0x38>
ffffffffc0203580:	07100593          	li	a1,113
ffffffffc0203584:	00001517          	auipc	a0,0x1
ffffffffc0203588:	79c50513          	addi	a0,a0,1948 # ffffffffc0204d20 <default_pmm_manager+0x60>
ffffffffc020358c:	ecffc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203590 <kernel_thread>:
{
ffffffffc0203590:	7129                	addi	sp,sp,-320
ffffffffc0203592:	fa22                	sd	s0,304(sp)
ffffffffc0203594:	f626                	sd	s1,296(sp)
ffffffffc0203596:	f24a                	sd	s2,288(sp)
ffffffffc0203598:	84ae                	mv	s1,a1
ffffffffc020359a:	892a                	mv	s2,a0
ffffffffc020359c:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020359e:	4581                	li	a1,0
ffffffffc02035a0:	12000613          	li	a2,288
ffffffffc02035a4:	850a                	mv	a0,sp
{
ffffffffc02035a6:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02035a8:	095000ef          	jal	ra,ffffffffc0203e3c <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02035ac:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02035ae:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02035b0:	100027f3          	csrr	a5,sstatus
ffffffffc02035b4:	edd7f793          	andi	a5,a5,-291
ffffffffc02035b8:	1207e793          	ori	a5,a5,288
ffffffffc02035bc:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02035be:	860a                	mv	a2,sp
ffffffffc02035c0:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02035c4:	00000797          	auipc	a5,0x0
ffffffffc02035c8:	c4078793          	addi	a5,a5,-960 # ffffffffc0203204 <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02035cc:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02035ce:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02035d0:	d8dff0ef          	jal	ra,ffffffffc020335c <do_fork>
}
ffffffffc02035d4:	70f2                	ld	ra,312(sp)
ffffffffc02035d6:	7452                	ld	s0,304(sp)
ffffffffc02035d8:	74b2                	ld	s1,296(sp)
ffffffffc02035da:	7912                	ld	s2,288(sp)
ffffffffc02035dc:	6131                	addi	sp,sp,320
ffffffffc02035de:	8082                	ret

ffffffffc02035e0 <do_exit>:
{
ffffffffc02035e0:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc02035e2:	00002617          	auipc	a2,0x2
ffffffffc02035e6:	08660613          	addi	a2,a2,134 # ffffffffc0205668 <default_pmm_manager+0x9a8>
ffffffffc02035ea:	17b00593          	li	a1,379
ffffffffc02035ee:	00002517          	auipc	a0,0x2
ffffffffc02035f2:	06250513          	addi	a0,a0,98 # ffffffffc0205650 <default_pmm_manager+0x990>
{
ffffffffc02035f6:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc02035f8:	e63fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc02035fc <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc02035fc:	7179                	addi	sp,sp,-48
ffffffffc02035fe:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc0203600:	0000a797          	auipc	a5,0xa
ffffffffc0203604:	e5878793          	addi	a5,a5,-424 # ffffffffc020d458 <proc_list>
ffffffffc0203608:	f406                	sd	ra,40(sp)
ffffffffc020360a:	f022                	sd	s0,32(sp)
ffffffffc020360c:	e84a                	sd	s2,16(sp)
ffffffffc020360e:	e44e                	sd	s3,8(sp)
ffffffffc0203610:	00006497          	auipc	s1,0x6
ffffffffc0203614:	e3848493          	addi	s1,s1,-456 # ffffffffc0209448 <hash_list>
ffffffffc0203618:	e79c                	sd	a5,8(a5)
ffffffffc020361a:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc020361c:	0000a717          	auipc	a4,0xa
ffffffffc0203620:	e2c70713          	addi	a4,a4,-468 # ffffffffc020d448 <name.2>
ffffffffc0203624:	87a6                	mv	a5,s1
ffffffffc0203626:	e79c                	sd	a5,8(a5)
ffffffffc0203628:	e39c                	sd	a5,0(a5)
ffffffffc020362a:	07c1                	addi	a5,a5,16
ffffffffc020362c:	fef71de3          	bne	a4,a5,ffffffffc0203626 <proc_init+0x2a>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0203630:	bddff0ef          	jal	ra,ffffffffc020320c <alloc_proc>
ffffffffc0203634:	0000a917          	auipc	s2,0xa
ffffffffc0203638:	ea490913          	addi	s2,s2,-348 # ffffffffc020d4d8 <idleproc>
ffffffffc020363c:	00a93023          	sd	a0,0(s2)
ffffffffc0203640:	18050d63          	beqz	a0,ffffffffc02037da <proc_init+0x1de>
    {
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc0203644:	07000513          	li	a0,112
ffffffffc0203648:	c6efe0ef          	jal	ra,ffffffffc0201ab6 <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc020364c:	07000613          	li	a2,112
ffffffffc0203650:	4581                	li	a1,0
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc0203652:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc0203654:	7e8000ef          	jal	ra,ffffffffc0203e3c <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc0203658:	00093503          	ld	a0,0(s2)
ffffffffc020365c:	85a2                	mv	a1,s0
ffffffffc020365e:	07000613          	li	a2,112
ffffffffc0203662:	03050513          	addi	a0,a0,48
ffffffffc0203666:	001000ef          	jal	ra,ffffffffc0203e66 <memcmp>
ffffffffc020366a:	89aa                	mv	s3,a0

    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc020366c:	453d                	li	a0,15
ffffffffc020366e:	c48fe0ef          	jal	ra,ffffffffc0201ab6 <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203672:	463d                	li	a2,15
ffffffffc0203674:	4581                	li	a1,0
    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc0203676:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc0203678:	7c4000ef          	jal	ra,ffffffffc0203e3c <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc020367c:	00093503          	ld	a0,0(s2)
ffffffffc0203680:	463d                	li	a2,15
ffffffffc0203682:	85a2                	mv	a1,s0
ffffffffc0203684:	0b450513          	addi	a0,a0,180
ffffffffc0203688:	7de000ef          	jal	ra,ffffffffc0203e66 <memcmp>

    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc020368c:	00093783          	ld	a5,0(s2)
ffffffffc0203690:	0000a717          	auipc	a4,0xa
ffffffffc0203694:	e1073703          	ld	a4,-496(a4) # ffffffffc020d4a0 <boot_pgdir_pa>
ffffffffc0203698:	77d4                	ld	a3,168(a5)
ffffffffc020369a:	0ee68463          	beq	a3,a4,ffffffffc0203782 <proc_init+0x186>
    {
        cprintf("alloc_proc() correct!\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020369e:	4709                	li	a4,2
ffffffffc02036a0:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02036a2:	00003717          	auipc	a4,0x3
ffffffffc02036a6:	95e70713          	addi	a4,a4,-1698 # ffffffffc0206000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02036aa:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc02036ae:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc02036b0:	4705                	li	a4,1
ffffffffc02036b2:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02036b4:	4641                	li	a2,16
ffffffffc02036b6:	4581                	li	a1,0
ffffffffc02036b8:	8522                	mv	a0,s0
ffffffffc02036ba:	782000ef          	jal	ra,ffffffffc0203e3c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02036be:	463d                	li	a2,15
ffffffffc02036c0:	00002597          	auipc	a1,0x2
ffffffffc02036c4:	ff058593          	addi	a1,a1,-16 # ffffffffc02056b0 <default_pmm_manager+0x9f0>
ffffffffc02036c8:	8522                	mv	a0,s0
ffffffffc02036ca:	784000ef          	jal	ra,ffffffffc0203e4e <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc02036ce:	0000a717          	auipc	a4,0xa
ffffffffc02036d2:	e1a70713          	addi	a4,a4,-486 # ffffffffc020d4e8 <nr_process>
ffffffffc02036d6:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc02036d8:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036dc:	4601                	li	a2,0
    nr_process++;
ffffffffc02036de:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036e0:	00002597          	auipc	a1,0x2
ffffffffc02036e4:	fd858593          	addi	a1,a1,-40 # ffffffffc02056b8 <default_pmm_manager+0x9f8>
ffffffffc02036e8:	00000517          	auipc	a0,0x0
ffffffffc02036ec:	b9450513          	addi	a0,a0,-1132 # ffffffffc020327c <init_main>
    nr_process++;
ffffffffc02036f0:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc02036f2:	0000a797          	auipc	a5,0xa
ffffffffc02036f6:	dcd7bf23          	sd	a3,-546(a5) # ffffffffc020d4d0 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc02036fa:	e97ff0ef          	jal	ra,ffffffffc0203590 <kernel_thread>
ffffffffc02036fe:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0203700:	0ea05963          	blez	a0,ffffffffc02037f2 <proc_init+0x1f6>
    if (0 < pid && pid < MAX_PID)
ffffffffc0203704:	6789                	lui	a5,0x2
ffffffffc0203706:	fff5071b          	addiw	a4,a0,-1
ffffffffc020370a:	17f9                	addi	a5,a5,-2
ffffffffc020370c:	2501                	sext.w	a0,a0
ffffffffc020370e:	02e7e363          	bltu	a5,a4,ffffffffc0203734 <proc_init+0x138>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203712:	45a9                	li	a1,10
ffffffffc0203714:	282000ef          	jal	ra,ffffffffc0203996 <hash32>
ffffffffc0203718:	02051793          	slli	a5,a0,0x20
ffffffffc020371c:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0203720:	96a6                	add	a3,a3,s1
ffffffffc0203722:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0203724:	a029                	j	ffffffffc020372e <proc_init+0x132>
            if (proc->pid == pid)
ffffffffc0203726:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc020372a:	0a870563          	beq	a4,s0,ffffffffc02037d4 <proc_init+0x1d8>
    return listelm->next;
ffffffffc020372e:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0203730:	fef69be3          	bne	a3,a5,ffffffffc0203726 <proc_init+0x12a>
    return NULL;
ffffffffc0203734:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203736:	0b478493          	addi	s1,a5,180
ffffffffc020373a:	4641                	li	a2,16
ffffffffc020373c:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc020373e:	0000a417          	auipc	s0,0xa
ffffffffc0203742:	da240413          	addi	s0,s0,-606 # ffffffffc020d4e0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203746:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0203748:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020374a:	6f2000ef          	jal	ra,ffffffffc0203e3c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020374e:	463d                	li	a2,15
ffffffffc0203750:	00002597          	auipc	a1,0x2
ffffffffc0203754:	f9858593          	addi	a1,a1,-104 # ffffffffc02056e8 <default_pmm_manager+0xa28>
ffffffffc0203758:	8526                	mv	a0,s1
ffffffffc020375a:	6f4000ef          	jal	ra,ffffffffc0203e4e <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020375e:	00093783          	ld	a5,0(s2)
ffffffffc0203762:	c7e1                	beqz	a5,ffffffffc020382a <proc_init+0x22e>
ffffffffc0203764:	43dc                	lw	a5,4(a5)
ffffffffc0203766:	e3f1                	bnez	a5,ffffffffc020382a <proc_init+0x22e>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0203768:	601c                	ld	a5,0(s0)
ffffffffc020376a:	c3c5                	beqz	a5,ffffffffc020380a <proc_init+0x20e>
ffffffffc020376c:	43d8                	lw	a4,4(a5)
ffffffffc020376e:	4785                	li	a5,1
ffffffffc0203770:	08f71d63          	bne	a4,a5,ffffffffc020380a <proc_init+0x20e>
}
ffffffffc0203774:	70a2                	ld	ra,40(sp)
ffffffffc0203776:	7402                	ld	s0,32(sp)
ffffffffc0203778:	64e2                	ld	s1,24(sp)
ffffffffc020377a:	6942                	ld	s2,16(sp)
ffffffffc020377c:	69a2                	ld	s3,8(sp)
ffffffffc020377e:	6145                	addi	sp,sp,48
ffffffffc0203780:	8082                	ret
    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc0203782:	73d8                	ld	a4,160(a5)
ffffffffc0203784:	ff09                	bnez	a4,ffffffffc020369e <proc_init+0xa2>
ffffffffc0203786:	f0099ce3          	bnez	s3,ffffffffc020369e <proc_init+0xa2>
ffffffffc020378a:	6394                	ld	a3,0(a5)
ffffffffc020378c:	577d                	li	a4,-1
ffffffffc020378e:	1702                	slli	a4,a4,0x20
ffffffffc0203790:	f0e697e3          	bne	a3,a4,ffffffffc020369e <proc_init+0xa2>
ffffffffc0203794:	4798                	lw	a4,8(a5)
ffffffffc0203796:	f00714e3          	bnez	a4,ffffffffc020369e <proc_init+0xa2>
ffffffffc020379a:	6b98                	ld	a4,16(a5)
ffffffffc020379c:	f00711e3          	bnez	a4,ffffffffc020369e <proc_init+0xa2>
ffffffffc02037a0:	4f98                	lw	a4,24(a5)
ffffffffc02037a2:	2701                	sext.w	a4,a4
ffffffffc02037a4:	ee071de3          	bnez	a4,ffffffffc020369e <proc_init+0xa2>
ffffffffc02037a8:	7398                	ld	a4,32(a5)
ffffffffc02037aa:	ee071ae3          	bnez	a4,ffffffffc020369e <proc_init+0xa2>
ffffffffc02037ae:	7798                	ld	a4,40(a5)
ffffffffc02037b0:	ee0717e3          	bnez	a4,ffffffffc020369e <proc_init+0xa2>
ffffffffc02037b4:	0b07a703          	lw	a4,176(a5)
ffffffffc02037b8:	8d59                	or	a0,a0,a4
ffffffffc02037ba:	0005071b          	sext.w	a4,a0
ffffffffc02037be:	ee0710e3          	bnez	a4,ffffffffc020369e <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc02037c2:	00002517          	auipc	a0,0x2
ffffffffc02037c6:	ed650513          	addi	a0,a0,-298 # ffffffffc0205698 <default_pmm_manager+0x9d8>
ffffffffc02037ca:	9cbfc0ef          	jal	ra,ffffffffc0200194 <cprintf>
    idleproc->pid = 0;
ffffffffc02037ce:	00093783          	ld	a5,0(s2)
ffffffffc02037d2:	b5f1                	j	ffffffffc020369e <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02037d4:	f2878793          	addi	a5,a5,-216
ffffffffc02037d8:	bfb9                	j	ffffffffc0203736 <proc_init+0x13a>
        panic("cannot alloc idleproc.\n");
ffffffffc02037da:	00002617          	auipc	a2,0x2
ffffffffc02037de:	ea660613          	addi	a2,a2,-346 # ffffffffc0205680 <default_pmm_manager+0x9c0>
ffffffffc02037e2:	19600593          	li	a1,406
ffffffffc02037e6:	00002517          	auipc	a0,0x2
ffffffffc02037ea:	e6a50513          	addi	a0,a0,-406 # ffffffffc0205650 <default_pmm_manager+0x990>
ffffffffc02037ee:	c6dfc0ef          	jal	ra,ffffffffc020045a <__panic>
        panic("create init_main failed.\n");
ffffffffc02037f2:	00002617          	auipc	a2,0x2
ffffffffc02037f6:	ed660613          	addi	a2,a2,-298 # ffffffffc02056c8 <default_pmm_manager+0xa08>
ffffffffc02037fa:	1b300593          	li	a1,435
ffffffffc02037fe:	00002517          	auipc	a0,0x2
ffffffffc0203802:	e5250513          	addi	a0,a0,-430 # ffffffffc0205650 <default_pmm_manager+0x990>
ffffffffc0203806:	c55fc0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020380a:	00002697          	auipc	a3,0x2
ffffffffc020380e:	f0e68693          	addi	a3,a3,-242 # ffffffffc0205718 <default_pmm_manager+0xa58>
ffffffffc0203812:	00001617          	auipc	a2,0x1
ffffffffc0203816:	0fe60613          	addi	a2,a2,254 # ffffffffc0204910 <commands+0x818>
ffffffffc020381a:	1ba00593          	li	a1,442
ffffffffc020381e:	00002517          	auipc	a0,0x2
ffffffffc0203822:	e3250513          	addi	a0,a0,-462 # ffffffffc0205650 <default_pmm_manager+0x990>
ffffffffc0203826:	c35fc0ef          	jal	ra,ffffffffc020045a <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc020382a:	00002697          	auipc	a3,0x2
ffffffffc020382e:	ec668693          	addi	a3,a3,-314 # ffffffffc02056f0 <default_pmm_manager+0xa30>
ffffffffc0203832:	00001617          	auipc	a2,0x1
ffffffffc0203836:	0de60613          	addi	a2,a2,222 # ffffffffc0204910 <commands+0x818>
ffffffffc020383a:	1b900593          	li	a1,441
ffffffffc020383e:	00002517          	auipc	a0,0x2
ffffffffc0203842:	e1250513          	addi	a0,a0,-494 # ffffffffc0205650 <default_pmm_manager+0x990>
ffffffffc0203846:	c15fc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc020384a <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc020384a:	1141                	addi	sp,sp,-16
ffffffffc020384c:	e022                	sd	s0,0(sp)
ffffffffc020384e:	e406                	sd	ra,8(sp)
ffffffffc0203850:	0000a417          	auipc	s0,0xa
ffffffffc0203854:	c8040413          	addi	s0,s0,-896 # ffffffffc020d4d0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0203858:	6018                	ld	a4,0(s0)
ffffffffc020385a:	4f1c                	lw	a5,24(a4)
ffffffffc020385c:	2781                	sext.w	a5,a5
ffffffffc020385e:	dff5                	beqz	a5,ffffffffc020385a <cpu_idle+0x10>
        {
            schedule();
ffffffffc0203860:	0a2000ef          	jal	ra,ffffffffc0203902 <schedule>
ffffffffc0203864:	bfd5                	j	ffffffffc0203858 <cpu_idle+0xe>

ffffffffc0203866 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203866:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc020386a:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc020386e:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0203870:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0203872:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203876:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc020387a:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc020387e:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0203882:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203886:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc020388a:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc020388e:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0203892:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203896:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc020389a:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020389e:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc02038a2:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc02038a4:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc02038a6:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc02038aa:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc02038ae:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc02038b2:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc02038b6:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc02038ba:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc02038be:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc02038c2:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc02038c6:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc02038ca:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc02038ce:	8082                	ret

ffffffffc02038d0 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038d0:	411c                	lw	a5,0(a0)
ffffffffc02038d2:	4705                	li	a4,1
ffffffffc02038d4:	37f9                	addiw	a5,a5,-2
ffffffffc02038d6:	00f77563          	bgeu	a4,a5,ffffffffc02038e0 <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc02038da:	4789                	li	a5,2
ffffffffc02038dc:	c11c                	sw	a5,0(a0)
ffffffffc02038de:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc02038e0:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038e2:	00002697          	auipc	a3,0x2
ffffffffc02038e6:	e5e68693          	addi	a3,a3,-418 # ffffffffc0205740 <default_pmm_manager+0xa80>
ffffffffc02038ea:	00001617          	auipc	a2,0x1
ffffffffc02038ee:	02660613          	addi	a2,a2,38 # ffffffffc0204910 <commands+0x818>
ffffffffc02038f2:	45a5                	li	a1,9
ffffffffc02038f4:	00002517          	auipc	a0,0x2
ffffffffc02038f8:	e8c50513          	addi	a0,a0,-372 # ffffffffc0205780 <default_pmm_manager+0xac0>
wakeup_proc(struct proc_struct *proc) {
ffffffffc02038fc:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038fe:	b5dfc0ef          	jal	ra,ffffffffc020045a <__panic>

ffffffffc0203902 <schedule>:
}

void
schedule(void) {
ffffffffc0203902:	1141                	addi	sp,sp,-16
ffffffffc0203904:	e406                	sd	ra,8(sp)
ffffffffc0203906:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203908:	100027f3          	csrr	a5,sstatus
ffffffffc020390c:	8b89                	andi	a5,a5,2
ffffffffc020390e:	4401                	li	s0,0
ffffffffc0203910:	efbd                	bnez	a5,ffffffffc020398e <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0203912:	0000a897          	auipc	a7,0xa
ffffffffc0203916:	bbe8b883          	ld	a7,-1090(a7) # ffffffffc020d4d0 <current>
ffffffffc020391a:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020391e:	0000a517          	auipc	a0,0xa
ffffffffc0203922:	bba53503          	ld	a0,-1094(a0) # ffffffffc020d4d8 <idleproc>
ffffffffc0203926:	04a88e63          	beq	a7,a0,ffffffffc0203982 <schedule+0x80>
ffffffffc020392a:	0c888693          	addi	a3,a7,200
ffffffffc020392e:	0000a617          	auipc	a2,0xa
ffffffffc0203932:	b2a60613          	addi	a2,a2,-1238 # ffffffffc020d458 <proc_list>
        le = last;
ffffffffc0203936:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0203938:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc020393a:	4809                	li	a6,2
ffffffffc020393c:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc020393e:	00c78863          	beq	a5,a2,ffffffffc020394e <schedule+0x4c>
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203942:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0203946:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc020394a:	03070163          	beq	a4,a6,ffffffffc020396c <schedule+0x6a>
                    break;
                }
            }
        } while (le != last);
ffffffffc020394e:	fef697e3          	bne	a3,a5,ffffffffc020393c <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203952:	ed89                	bnez	a1,ffffffffc020396c <schedule+0x6a>
            next = idleproc;
        }
        next->runs ++;
ffffffffc0203954:	451c                	lw	a5,8(a0)
ffffffffc0203956:	2785                	addiw	a5,a5,1
ffffffffc0203958:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc020395a:	00a88463          	beq	a7,a0,ffffffffc0203962 <schedule+0x60>
            proc_run(next);
ffffffffc020395e:	991ff0ef          	jal	ra,ffffffffc02032ee <proc_run>
    if (flag) {
ffffffffc0203962:	e819                	bnez	s0,ffffffffc0203978 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0203964:	60a2                	ld	ra,8(sp)
ffffffffc0203966:	6402                	ld	s0,0(sp)
ffffffffc0203968:	0141                	addi	sp,sp,16
ffffffffc020396a:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc020396c:	4198                	lw	a4,0(a1)
ffffffffc020396e:	4789                	li	a5,2
ffffffffc0203970:	fef712e3          	bne	a4,a5,ffffffffc0203954 <schedule+0x52>
ffffffffc0203974:	852e                	mv	a0,a1
ffffffffc0203976:	bff9                	j	ffffffffc0203954 <schedule+0x52>
}
ffffffffc0203978:	6402                	ld	s0,0(sp)
ffffffffc020397a:	60a2                	ld	ra,8(sp)
ffffffffc020397c:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020397e:	fadfc06f          	j	ffffffffc020092a <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203982:	0000a617          	auipc	a2,0xa
ffffffffc0203986:	ad660613          	addi	a2,a2,-1322 # ffffffffc020d458 <proc_list>
ffffffffc020398a:	86b2                	mv	a3,a2
ffffffffc020398c:	b76d                	j	ffffffffc0203936 <schedule+0x34>
        intr_disable();
ffffffffc020398e:	fa3fc0ef          	jal	ra,ffffffffc0200930 <intr_disable>
        return 1;
ffffffffc0203992:	4405                	li	s0,1
ffffffffc0203994:	bfbd                	j	ffffffffc0203912 <schedule+0x10>

ffffffffc0203996 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0203996:	9e3707b7          	lui	a5,0x9e370
ffffffffc020399a:	2785                	addiw	a5,a5,1
ffffffffc020399c:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc02039a0:	02000793          	li	a5,32
ffffffffc02039a4:	9f8d                	subw	a5,a5,a1
}
ffffffffc02039a6:	00f5553b          	srlw	a0,a0,a5
ffffffffc02039aa:	8082                	ret

ffffffffc02039ac <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc02039ac:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02039b0:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc02039b2:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02039b6:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc02039b8:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc02039bc:	f022                	sd	s0,32(sp)
ffffffffc02039be:	ec26                	sd	s1,24(sp)
ffffffffc02039c0:	e84a                	sd	s2,16(sp)
ffffffffc02039c2:	f406                	sd	ra,40(sp)
ffffffffc02039c4:	e44e                	sd	s3,8(sp)
ffffffffc02039c6:	84aa                	mv	s1,a0
ffffffffc02039c8:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02039ca:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02039ce:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02039d0:	03067e63          	bgeu	a2,a6,ffffffffc0203a0c <printnum+0x60>
ffffffffc02039d4:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02039d6:	00805763          	blez	s0,ffffffffc02039e4 <printnum+0x38>
ffffffffc02039da:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02039dc:	85ca                	mv	a1,s2
ffffffffc02039de:	854e                	mv	a0,s3
ffffffffc02039e0:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02039e2:	fc65                	bnez	s0,ffffffffc02039da <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02039e4:	1a02                	slli	s4,s4,0x20
ffffffffc02039e6:	00002797          	auipc	a5,0x2
ffffffffc02039ea:	db278793          	addi	a5,a5,-590 # ffffffffc0205798 <default_pmm_manager+0xad8>
ffffffffc02039ee:	020a5a13          	srli	s4,s4,0x20
ffffffffc02039f2:	9a3e                	add	s4,s4,a5
}
ffffffffc02039f4:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02039f6:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02039fa:	70a2                	ld	ra,40(sp)
ffffffffc02039fc:	69a2                	ld	s3,8(sp)
ffffffffc02039fe:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a00:	85ca                	mv	a1,s2
ffffffffc0203a02:	87a6                	mv	a5,s1
}
ffffffffc0203a04:	6942                	ld	s2,16(sp)
ffffffffc0203a06:	64e2                	ld	s1,24(sp)
ffffffffc0203a08:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203a0a:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203a0c:	03065633          	divu	a2,a2,a6
ffffffffc0203a10:	8722                	mv	a4,s0
ffffffffc0203a12:	f9bff0ef          	jal	ra,ffffffffc02039ac <printnum>
ffffffffc0203a16:	b7f9                	j	ffffffffc02039e4 <printnum+0x38>

ffffffffc0203a18 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203a18:	7119                	addi	sp,sp,-128
ffffffffc0203a1a:	f4a6                	sd	s1,104(sp)
ffffffffc0203a1c:	f0ca                	sd	s2,96(sp)
ffffffffc0203a1e:	ecce                	sd	s3,88(sp)
ffffffffc0203a20:	e8d2                	sd	s4,80(sp)
ffffffffc0203a22:	e4d6                	sd	s5,72(sp)
ffffffffc0203a24:	e0da                	sd	s6,64(sp)
ffffffffc0203a26:	fc5e                	sd	s7,56(sp)
ffffffffc0203a28:	f06a                	sd	s10,32(sp)
ffffffffc0203a2a:	fc86                	sd	ra,120(sp)
ffffffffc0203a2c:	f8a2                	sd	s0,112(sp)
ffffffffc0203a2e:	f862                	sd	s8,48(sp)
ffffffffc0203a30:	f466                	sd	s9,40(sp)
ffffffffc0203a32:	ec6e                	sd	s11,24(sp)
ffffffffc0203a34:	892a                	mv	s2,a0
ffffffffc0203a36:	84ae                	mv	s1,a1
ffffffffc0203a38:	8d32                	mv	s10,a2
ffffffffc0203a3a:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a3c:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0203a40:	5b7d                	li	s6,-1
ffffffffc0203a42:	00002a97          	auipc	s5,0x2
ffffffffc0203a46:	d82a8a93          	addi	s5,s5,-638 # ffffffffc02057c4 <default_pmm_manager+0xb04>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203a4a:	00002b97          	auipc	s7,0x2
ffffffffc0203a4e:	f56b8b93          	addi	s7,s7,-170 # ffffffffc02059a0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a52:	000d4503          	lbu	a0,0(s10)
ffffffffc0203a56:	001d0413          	addi	s0,s10,1
ffffffffc0203a5a:	01350a63          	beq	a0,s3,ffffffffc0203a6e <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0203a5e:	c121                	beqz	a0,ffffffffc0203a9e <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0203a60:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a62:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203a64:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203a66:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203a6a:	ff351ae3          	bne	a0,s3,ffffffffc0203a5e <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203a6e:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203a72:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203a76:	4c81                	li	s9,0
ffffffffc0203a78:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0203a7a:	5c7d                	li	s8,-1
ffffffffc0203a7c:	5dfd                	li	s11,-1
ffffffffc0203a7e:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0203a82:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203a84:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203a88:	0ff5f593          	zext.b	a1,a1
ffffffffc0203a8c:	00140d13          	addi	s10,s0,1
ffffffffc0203a90:	04b56263          	bltu	a0,a1,ffffffffc0203ad4 <vprintfmt+0xbc>
ffffffffc0203a94:	058a                	slli	a1,a1,0x2
ffffffffc0203a96:	95d6                	add	a1,a1,s5
ffffffffc0203a98:	4194                	lw	a3,0(a1)
ffffffffc0203a9a:	96d6                	add	a3,a3,s5
ffffffffc0203a9c:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203a9e:	70e6                	ld	ra,120(sp)
ffffffffc0203aa0:	7446                	ld	s0,112(sp)
ffffffffc0203aa2:	74a6                	ld	s1,104(sp)
ffffffffc0203aa4:	7906                	ld	s2,96(sp)
ffffffffc0203aa6:	69e6                	ld	s3,88(sp)
ffffffffc0203aa8:	6a46                	ld	s4,80(sp)
ffffffffc0203aaa:	6aa6                	ld	s5,72(sp)
ffffffffc0203aac:	6b06                	ld	s6,64(sp)
ffffffffc0203aae:	7be2                	ld	s7,56(sp)
ffffffffc0203ab0:	7c42                	ld	s8,48(sp)
ffffffffc0203ab2:	7ca2                	ld	s9,40(sp)
ffffffffc0203ab4:	7d02                	ld	s10,32(sp)
ffffffffc0203ab6:	6de2                	ld	s11,24(sp)
ffffffffc0203ab8:	6109                	addi	sp,sp,128
ffffffffc0203aba:	8082                	ret
            padc = '0';
ffffffffc0203abc:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0203abe:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ac2:	846a                	mv	s0,s10
ffffffffc0203ac4:	00140d13          	addi	s10,s0,1
ffffffffc0203ac8:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203acc:	0ff5f593          	zext.b	a1,a1
ffffffffc0203ad0:	fcb572e3          	bgeu	a0,a1,ffffffffc0203a94 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0203ad4:	85a6                	mv	a1,s1
ffffffffc0203ad6:	02500513          	li	a0,37
ffffffffc0203ada:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203adc:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203ae0:	8d22                	mv	s10,s0
ffffffffc0203ae2:	f73788e3          	beq	a5,s3,ffffffffc0203a52 <vprintfmt+0x3a>
ffffffffc0203ae6:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0203aea:	1d7d                	addi	s10,s10,-1
ffffffffc0203aec:	ff379de3          	bne	a5,s3,ffffffffc0203ae6 <vprintfmt+0xce>
ffffffffc0203af0:	b78d                	j	ffffffffc0203a52 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0203af2:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0203af6:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203afa:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0203afc:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0203b00:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203b04:	02d86463          	bltu	a6,a3,ffffffffc0203b2c <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0203b08:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203b0c:	002c169b          	slliw	a3,s8,0x2
ffffffffc0203b10:	0186873b          	addw	a4,a3,s8
ffffffffc0203b14:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203b18:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0203b1a:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203b1e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203b20:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0203b24:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203b28:	fed870e3          	bgeu	a6,a3,ffffffffc0203b08 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0203b2c:	f40ddce3          	bgez	s11,ffffffffc0203a84 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0203b30:	8de2                	mv	s11,s8
ffffffffc0203b32:	5c7d                	li	s8,-1
ffffffffc0203b34:	bf81                	j	ffffffffc0203a84 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0203b36:	fffdc693          	not	a3,s11
ffffffffc0203b3a:	96fd                	srai	a3,a3,0x3f
ffffffffc0203b3c:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b40:	00144603          	lbu	a2,1(s0)
ffffffffc0203b44:	2d81                	sext.w	s11,s11
ffffffffc0203b46:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203b48:	bf35                	j	ffffffffc0203a84 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0203b4a:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b4e:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0203b52:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b54:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0203b56:	bfd9                	j	ffffffffc0203b2c <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0203b58:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203b5a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203b5e:	01174463          	blt	a4,a7,ffffffffc0203b66 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0203b62:	1a088e63          	beqz	a7,ffffffffc0203d1e <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0203b66:	000a3603          	ld	a2,0(s4)
ffffffffc0203b6a:	46c1                	li	a3,16
ffffffffc0203b6c:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203b6e:	2781                	sext.w	a5,a5
ffffffffc0203b70:	876e                	mv	a4,s11
ffffffffc0203b72:	85a6                	mv	a1,s1
ffffffffc0203b74:	854a                	mv	a0,s2
ffffffffc0203b76:	e37ff0ef          	jal	ra,ffffffffc02039ac <printnum>
            break;
ffffffffc0203b7a:	bde1                	j	ffffffffc0203a52 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0203b7c:	000a2503          	lw	a0,0(s4)
ffffffffc0203b80:	85a6                	mv	a1,s1
ffffffffc0203b82:	0a21                	addi	s4,s4,8
ffffffffc0203b84:	9902                	jalr	s2
            break;
ffffffffc0203b86:	b5f1                	j	ffffffffc0203a52 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203b88:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203b8a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203b8e:	01174463          	blt	a4,a7,ffffffffc0203b96 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0203b92:	18088163          	beqz	a7,ffffffffc0203d14 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0203b96:	000a3603          	ld	a2,0(s4)
ffffffffc0203b9a:	46a9                	li	a3,10
ffffffffc0203b9c:	8a2e                	mv	s4,a1
ffffffffc0203b9e:	bfc1                	j	ffffffffc0203b6e <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ba0:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0203ba4:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ba6:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203ba8:	bdf1                	j	ffffffffc0203a84 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0203baa:	85a6                	mv	a1,s1
ffffffffc0203bac:	02500513          	li	a0,37
ffffffffc0203bb0:	9902                	jalr	s2
            break;
ffffffffc0203bb2:	b545                	j	ffffffffc0203a52 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bb4:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0203bb8:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bba:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203bbc:	b5e1                	j	ffffffffc0203a84 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0203bbe:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203bc0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203bc4:	01174463          	blt	a4,a7,ffffffffc0203bcc <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0203bc8:	14088163          	beqz	a7,ffffffffc0203d0a <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0203bcc:	000a3603          	ld	a2,0(s4)
ffffffffc0203bd0:	46a1                	li	a3,8
ffffffffc0203bd2:	8a2e                	mv	s4,a1
ffffffffc0203bd4:	bf69                	j	ffffffffc0203b6e <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0203bd6:	03000513          	li	a0,48
ffffffffc0203bda:	85a6                	mv	a1,s1
ffffffffc0203bdc:	e03e                	sd	a5,0(sp)
ffffffffc0203bde:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0203be0:	85a6                	mv	a1,s1
ffffffffc0203be2:	07800513          	li	a0,120
ffffffffc0203be6:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203be8:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203bea:	6782                	ld	a5,0(sp)
ffffffffc0203bec:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203bee:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0203bf2:	bfb5                	j	ffffffffc0203b6e <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203bf4:	000a3403          	ld	s0,0(s4)
ffffffffc0203bf8:	008a0713          	addi	a4,s4,8
ffffffffc0203bfc:	e03a                	sd	a4,0(sp)
ffffffffc0203bfe:	14040263          	beqz	s0,ffffffffc0203d42 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0203c02:	0fb05763          	blez	s11,ffffffffc0203cf0 <vprintfmt+0x2d8>
ffffffffc0203c06:	02d00693          	li	a3,45
ffffffffc0203c0a:	0cd79163          	bne	a5,a3,ffffffffc0203ccc <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c0e:	00044783          	lbu	a5,0(s0)
ffffffffc0203c12:	0007851b          	sext.w	a0,a5
ffffffffc0203c16:	cf85                	beqz	a5,ffffffffc0203c4e <vprintfmt+0x236>
ffffffffc0203c18:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203c1c:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c20:	000c4563          	bltz	s8,ffffffffc0203c2a <vprintfmt+0x212>
ffffffffc0203c24:	3c7d                	addiw	s8,s8,-1
ffffffffc0203c26:	036c0263          	beq	s8,s6,ffffffffc0203c4a <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0203c2a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203c2c:	0e0c8e63          	beqz	s9,ffffffffc0203d28 <vprintfmt+0x310>
ffffffffc0203c30:	3781                	addiw	a5,a5,-32
ffffffffc0203c32:	0ef47b63          	bgeu	s0,a5,ffffffffc0203d28 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0203c36:	03f00513          	li	a0,63
ffffffffc0203c3a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203c3c:	000a4783          	lbu	a5,0(s4)
ffffffffc0203c40:	3dfd                	addiw	s11,s11,-1
ffffffffc0203c42:	0a05                	addi	s4,s4,1
ffffffffc0203c44:	0007851b          	sext.w	a0,a5
ffffffffc0203c48:	ffe1                	bnez	a5,ffffffffc0203c20 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0203c4a:	01b05963          	blez	s11,ffffffffc0203c5c <vprintfmt+0x244>
ffffffffc0203c4e:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0203c50:	85a6                	mv	a1,s1
ffffffffc0203c52:	02000513          	li	a0,32
ffffffffc0203c56:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0203c58:	fe0d9be3          	bnez	s11,ffffffffc0203c4e <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203c5c:	6a02                	ld	s4,0(sp)
ffffffffc0203c5e:	bbd5                	j	ffffffffc0203a52 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203c60:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c62:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0203c66:	01174463          	blt	a4,a7,ffffffffc0203c6e <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0203c6a:	08088d63          	beqz	a7,ffffffffc0203d04 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0203c6e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203c72:	0a044d63          	bltz	s0,ffffffffc0203d2c <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0203c76:	8622                	mv	a2,s0
ffffffffc0203c78:	8a66                	mv	s4,s9
ffffffffc0203c7a:	46a9                	li	a3,10
ffffffffc0203c7c:	bdcd                	j	ffffffffc0203b6e <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0203c7e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203c82:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0203c84:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203c86:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203c8a:	8fb5                	xor	a5,a5,a3
ffffffffc0203c8c:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203c90:	02d74163          	blt	a4,a3,ffffffffc0203cb2 <vprintfmt+0x29a>
ffffffffc0203c94:	00369793          	slli	a5,a3,0x3
ffffffffc0203c98:	97de                	add	a5,a5,s7
ffffffffc0203c9a:	639c                	ld	a5,0(a5)
ffffffffc0203c9c:	cb99                	beqz	a5,ffffffffc0203cb2 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203c9e:	86be                	mv	a3,a5
ffffffffc0203ca0:	00000617          	auipc	a2,0x0
ffffffffc0203ca4:	21860613          	addi	a2,a2,536 # ffffffffc0203eb8 <etext+0x2e>
ffffffffc0203ca8:	85a6                	mv	a1,s1
ffffffffc0203caa:	854a                	mv	a0,s2
ffffffffc0203cac:	0ce000ef          	jal	ra,ffffffffc0203d7a <printfmt>
ffffffffc0203cb0:	b34d                	j	ffffffffc0203a52 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0203cb2:	00002617          	auipc	a2,0x2
ffffffffc0203cb6:	b0660613          	addi	a2,a2,-1274 # ffffffffc02057b8 <default_pmm_manager+0xaf8>
ffffffffc0203cba:	85a6                	mv	a1,s1
ffffffffc0203cbc:	854a                	mv	a0,s2
ffffffffc0203cbe:	0bc000ef          	jal	ra,ffffffffc0203d7a <printfmt>
ffffffffc0203cc2:	bb41                	j	ffffffffc0203a52 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0203cc4:	00002417          	auipc	s0,0x2
ffffffffc0203cc8:	aec40413          	addi	s0,s0,-1300 # ffffffffc02057b0 <default_pmm_manager+0xaf0>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203ccc:	85e2                	mv	a1,s8
ffffffffc0203cce:	8522                	mv	a0,s0
ffffffffc0203cd0:	e43e                	sd	a5,8(sp)
ffffffffc0203cd2:	0e2000ef          	jal	ra,ffffffffc0203db4 <strnlen>
ffffffffc0203cd6:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0203cda:	01b05b63          	blez	s11,ffffffffc0203cf0 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0203cde:	67a2                	ld	a5,8(sp)
ffffffffc0203ce0:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203ce4:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0203ce6:	85a6                	mv	a1,s1
ffffffffc0203ce8:	8552                	mv	a0,s4
ffffffffc0203cea:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203cec:	fe0d9ce3          	bnez	s11,ffffffffc0203ce4 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cf0:	00044783          	lbu	a5,0(s0)
ffffffffc0203cf4:	00140a13          	addi	s4,s0,1
ffffffffc0203cf8:	0007851b          	sext.w	a0,a5
ffffffffc0203cfc:	d3a5                	beqz	a5,ffffffffc0203c5c <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203cfe:	05e00413          	li	s0,94
ffffffffc0203d02:	bf39                	j	ffffffffc0203c20 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0203d04:	000a2403          	lw	s0,0(s4)
ffffffffc0203d08:	b7ad                	j	ffffffffc0203c72 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0203d0a:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d0e:	46a1                	li	a3,8
ffffffffc0203d10:	8a2e                	mv	s4,a1
ffffffffc0203d12:	bdb1                	j	ffffffffc0203b6e <vprintfmt+0x156>
ffffffffc0203d14:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d18:	46a9                	li	a3,10
ffffffffc0203d1a:	8a2e                	mv	s4,a1
ffffffffc0203d1c:	bd89                	j	ffffffffc0203b6e <vprintfmt+0x156>
ffffffffc0203d1e:	000a6603          	lwu	a2,0(s4)
ffffffffc0203d22:	46c1                	li	a3,16
ffffffffc0203d24:	8a2e                	mv	s4,a1
ffffffffc0203d26:	b5a1                	j	ffffffffc0203b6e <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0203d28:	9902                	jalr	s2
ffffffffc0203d2a:	bf09                	j	ffffffffc0203c3c <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0203d2c:	85a6                	mv	a1,s1
ffffffffc0203d2e:	02d00513          	li	a0,45
ffffffffc0203d32:	e03e                	sd	a5,0(sp)
ffffffffc0203d34:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0203d36:	6782                	ld	a5,0(sp)
ffffffffc0203d38:	8a66                	mv	s4,s9
ffffffffc0203d3a:	40800633          	neg	a2,s0
ffffffffc0203d3e:	46a9                	li	a3,10
ffffffffc0203d40:	b53d                	j	ffffffffc0203b6e <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0203d42:	03b05163          	blez	s11,ffffffffc0203d64 <vprintfmt+0x34c>
ffffffffc0203d46:	02d00693          	li	a3,45
ffffffffc0203d4a:	f6d79de3          	bne	a5,a3,ffffffffc0203cc4 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0203d4e:	00002417          	auipc	s0,0x2
ffffffffc0203d52:	a6240413          	addi	s0,s0,-1438 # ffffffffc02057b0 <default_pmm_manager+0xaf0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d56:	02800793          	li	a5,40
ffffffffc0203d5a:	02800513          	li	a0,40
ffffffffc0203d5e:	00140a13          	addi	s4,s0,1
ffffffffc0203d62:	bd6d                	j	ffffffffc0203c1c <vprintfmt+0x204>
ffffffffc0203d64:	00002a17          	auipc	s4,0x2
ffffffffc0203d68:	a4da0a13          	addi	s4,s4,-1459 # ffffffffc02057b1 <default_pmm_manager+0xaf1>
ffffffffc0203d6c:	02800513          	li	a0,40
ffffffffc0203d70:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d74:	05e00413          	li	s0,94
ffffffffc0203d78:	b565                	j	ffffffffc0203c20 <vprintfmt+0x208>

ffffffffc0203d7a <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d7a:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0203d7c:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d80:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203d82:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203d84:	ec06                	sd	ra,24(sp)
ffffffffc0203d86:	f83a                	sd	a4,48(sp)
ffffffffc0203d88:	fc3e                	sd	a5,56(sp)
ffffffffc0203d8a:	e0c2                	sd	a6,64(sp)
ffffffffc0203d8c:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0203d8e:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203d90:	c89ff0ef          	jal	ra,ffffffffc0203a18 <vprintfmt>
}
ffffffffc0203d94:	60e2                	ld	ra,24(sp)
ffffffffc0203d96:	6161                	addi	sp,sp,80
ffffffffc0203d98:	8082                	ret

ffffffffc0203d9a <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0203d9a:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0203d9e:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0203da0:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0203da2:	cb81                	beqz	a5,ffffffffc0203db2 <strlen+0x18>
        cnt ++;
ffffffffc0203da4:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0203da6:	00a707b3          	add	a5,a4,a0
ffffffffc0203daa:	0007c783          	lbu	a5,0(a5)
ffffffffc0203dae:	fbfd                	bnez	a5,ffffffffc0203da4 <strlen+0xa>
ffffffffc0203db0:	8082                	ret
    }
    return cnt;
}
ffffffffc0203db2:	8082                	ret

ffffffffc0203db4 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0203db4:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203db6:	e589                	bnez	a1,ffffffffc0203dc0 <strnlen+0xc>
ffffffffc0203db8:	a811                	j	ffffffffc0203dcc <strnlen+0x18>
        cnt ++;
ffffffffc0203dba:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0203dbc:	00f58863          	beq	a1,a5,ffffffffc0203dcc <strnlen+0x18>
ffffffffc0203dc0:	00f50733          	add	a4,a0,a5
ffffffffc0203dc4:	00074703          	lbu	a4,0(a4)
ffffffffc0203dc8:	fb6d                	bnez	a4,ffffffffc0203dba <strnlen+0x6>
ffffffffc0203dca:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0203dcc:	852e                	mv	a0,a1
ffffffffc0203dce:	8082                	ret

ffffffffc0203dd0 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc0203dd0:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc0203dd2:	0005c703          	lbu	a4,0(a1)
ffffffffc0203dd6:	0785                	addi	a5,a5,1
ffffffffc0203dd8:	0585                	addi	a1,a1,1
ffffffffc0203dda:	fee78fa3          	sb	a4,-1(a5)
ffffffffc0203dde:	fb75                	bnez	a4,ffffffffc0203dd2 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0203de0:	8082                	ret

ffffffffc0203de2 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203de2:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203de6:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203dea:	cb89                	beqz	a5,ffffffffc0203dfc <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0203dec:	0505                	addi	a0,a0,1
ffffffffc0203dee:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203df0:	fee789e3          	beq	a5,a4,ffffffffc0203de2 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203df4:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203df8:	9d19                	subw	a0,a0,a4
ffffffffc0203dfa:	8082                	ret
ffffffffc0203dfc:	4501                	li	a0,0
ffffffffc0203dfe:	bfed                	j	ffffffffc0203df8 <strcmp+0x16>

ffffffffc0203e00 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e00:	c20d                	beqz	a2,ffffffffc0203e22 <strncmp+0x22>
ffffffffc0203e02:	962e                	add	a2,a2,a1
ffffffffc0203e04:	a031                	j	ffffffffc0203e10 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0203e06:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e08:	00e79a63          	bne	a5,a4,ffffffffc0203e1c <strncmp+0x1c>
ffffffffc0203e0c:	00b60b63          	beq	a2,a1,ffffffffc0203e22 <strncmp+0x22>
ffffffffc0203e10:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0203e14:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203e16:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203e1a:	f7f5                	bnez	a5,ffffffffc0203e06 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e1c:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0203e20:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e22:	4501                	li	a0,0
ffffffffc0203e24:	8082                	ret

ffffffffc0203e26 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203e26:	00054783          	lbu	a5,0(a0)
ffffffffc0203e2a:	c799                	beqz	a5,ffffffffc0203e38 <strchr+0x12>
        if (*s == c) {
ffffffffc0203e2c:	00f58763          	beq	a1,a5,ffffffffc0203e3a <strchr+0x14>
    while (*s != '\0') {
ffffffffc0203e30:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0203e34:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203e36:	fbfd                	bnez	a5,ffffffffc0203e2c <strchr+0x6>
    }
    return NULL;
ffffffffc0203e38:	4501                	li	a0,0
}
ffffffffc0203e3a:	8082                	ret

ffffffffc0203e3c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203e3c:	ca01                	beqz	a2,ffffffffc0203e4c <memset+0x10>
ffffffffc0203e3e:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203e40:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203e42:	0785                	addi	a5,a5,1
ffffffffc0203e44:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203e48:	fec79de3          	bne	a5,a2,ffffffffc0203e42 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203e4c:	8082                	ret

ffffffffc0203e4e <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203e4e:	ca19                	beqz	a2,ffffffffc0203e64 <memcpy+0x16>
ffffffffc0203e50:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203e52:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203e54:	0005c703          	lbu	a4,0(a1)
ffffffffc0203e58:	0585                	addi	a1,a1,1
ffffffffc0203e5a:	0785                	addi	a5,a5,1
ffffffffc0203e5c:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203e60:	fec59ae3          	bne	a1,a2,ffffffffc0203e54 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203e64:	8082                	ret

ffffffffc0203e66 <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0203e66:	c205                	beqz	a2,ffffffffc0203e86 <memcmp+0x20>
ffffffffc0203e68:	962e                	add	a2,a2,a1
ffffffffc0203e6a:	a019                	j	ffffffffc0203e70 <memcmp+0xa>
ffffffffc0203e6c:	00c58d63          	beq	a1,a2,ffffffffc0203e86 <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0203e70:	00054783          	lbu	a5,0(a0)
ffffffffc0203e74:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0203e78:	0505                	addi	a0,a0,1
ffffffffc0203e7a:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0203e7c:	fee788e3          	beq	a5,a4,ffffffffc0203e6c <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203e80:	40e7853b          	subw	a0,a5,a4
ffffffffc0203e84:	8082                	ret
    }
    return 0;
ffffffffc0203e86:	4501                	li	a0,0
}
ffffffffc0203e88:	8082                	ret
