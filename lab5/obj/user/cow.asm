
obj/__user_cow.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
.text
.globl _start
_start:
    # call user-program function
    call umain
  800020:	0c2000ef          	jal	ra,8000e2 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1141                	addi	sp,sp,-16
  800028:	e022                	sd	s0,0(sp)
  80002a:	e406                	sd	ra,8(sp)
  80002c:	842e                	mv	s0,a1
    sys_putc(c);
  80002e:	094000ef          	jal	ra,8000c2 <sys_putc>
    (*cnt) ++;
  800032:	401c                	lw	a5,0(s0)
}
  800034:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
  800036:	2785                	addiw	a5,a5,1
  800038:	c01c                	sw	a5,0(s0)
}
  80003a:	6402                	ld	s0,0(sp)
  80003c:	0141                	addi	sp,sp,16
  80003e:	8082                	ret

0000000000800040 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  800040:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800042:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800046:	8e2a                	mv	t3,a0
  800048:	f42e                	sd	a1,40(sp)
  80004a:	f832                	sd	a2,48(sp)
  80004c:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	addi	a0,a0,-40 # 800026 <cputch>
  800056:	004c                	addi	a1,sp,4
  800058:	869a                	mv	a3,t1
  80005a:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
  80005c:	ec06                	sd	ra,24(sp)
  80005e:	e0ba                	sd	a4,64(sp)
  800060:	e4be                	sd	a5,72(sp)
  800062:	e8c2                	sd	a6,80(sp)
  800064:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
  800066:	e41a                	sd	t1,8(sp)
    int cnt = 0;
  800068:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80006a:	0f0000ef          	jal	ra,80015a <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006e:	60e2                	ld	ra,24(sp)
  800070:	4512                	lw	a0,4(sp)
  800072:	6125                	addi	sp,sp,96
  800074:	8082                	ret

0000000000800076 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800076:	7175                	addi	sp,sp,-144
  800078:	f8ba                	sd	a4,112(sp)
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  80007a:	e0ba                	sd	a4,64(sp)
  80007c:	0118                	addi	a4,sp,128
syscall(int64_t num, ...) {
  80007e:	e42a                	sd	a0,8(sp)
  800080:	ecae                	sd	a1,88(sp)
  800082:	f0b2                	sd	a2,96(sp)
  800084:	f4b6                	sd	a3,104(sp)
  800086:	fcbe                	sd	a5,120(sp)
  800088:	e142                	sd	a6,128(sp)
  80008a:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  80008c:	f42e                	sd	a1,40(sp)
  80008e:	f832                	sd	a2,48(sp)
  800090:	fc36                	sd	a3,56(sp)
  800092:	f03a                	sd	a4,32(sp)
  800094:	e4be                	sd	a5,72(sp)
    }
    va_end(ap);

    asm volatile (
  800096:	6522                	ld	a0,8(sp)
  800098:	75a2                	ld	a1,40(sp)
  80009a:	7642                	ld	a2,48(sp)
  80009c:	76e2                	ld	a3,56(sp)
  80009e:	6706                	ld	a4,64(sp)
  8000a0:	67a6                	ld	a5,72(sp)
  8000a2:	00000073          	ecall
  8000a6:	00a13e23          	sd	a0,28(sp)
        "sd a0, %0"
        : "=m" (ret)
        : "m"(num), "m"(a[0]), "m"(a[1]), "m"(a[2]), "m"(a[3]), "m"(a[4])
        :"memory");
    return ret;
}
  8000aa:	4572                	lw	a0,28(sp)
  8000ac:	6149                	addi	sp,sp,144
  8000ae:	8082                	ret

00000000008000b0 <sys_exit>:

int
sys_exit(int64_t error_code) {
  8000b0:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  8000b2:	4505                	li	a0,1
  8000b4:	b7c9                	j	800076 <syscall>

00000000008000b6 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000b6:	4509                	li	a0,2
  8000b8:	bf7d                	j	800076 <syscall>

00000000008000ba <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  8000ba:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  8000bc:	85aa                	mv	a1,a0
  8000be:	450d                	li	a0,3
  8000c0:	bf5d                	j	800076 <syscall>

00000000008000c2 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  8000c2:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000c4:	4579                	li	a0,30
  8000c6:	bf45                	j	800076 <syscall>

00000000008000c8 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000c8:	1141                	addi	sp,sp,-16
  8000ca:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000cc:	fe5ff0ef          	jal	ra,8000b0 <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000d0:	00000517          	auipc	a0,0x0
  8000d4:	4e850513          	addi	a0,a0,1256 # 8005b8 <main+0xc0>
  8000d8:	f69ff0ef          	jal	ra,800040 <cprintf>
    while (1);
  8000dc:	a001                	j	8000dc <exit+0x14>

00000000008000de <fork>:
}

int
fork(void) {
    return sys_fork();
  8000de:	bfe1                	j	8000b6 <sys_fork>

00000000008000e0 <waitpid>:
    return sys_wait(0, NULL);
}

int
waitpid(int pid, int *store) {
    return sys_wait(pid, store);
  8000e0:	bfe9                	j	8000ba <sys_wait>

00000000008000e2 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000e2:	1141                	addi	sp,sp,-16
  8000e4:	e406                	sd	ra,8(sp)
    int ret = main();
  8000e6:	412000ef          	jal	ra,8004f8 <main>
    exit(ret);
  8000ea:	fdfff0ef          	jal	ra,8000c8 <exit>

00000000008000ee <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000ee:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000f2:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
  8000f4:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000f8:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  8000fa:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
  8000fe:	f022                	sd	s0,32(sp)
  800100:	ec26                	sd	s1,24(sp)
  800102:	e84a                	sd	s2,16(sp)
  800104:	f406                	sd	ra,40(sp)
  800106:	e44e                	sd	s3,8(sp)
  800108:	84aa                	mv	s1,a0
  80010a:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80010c:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
  800110:	2a01                	sext.w	s4,s4
    if (num >= base) {
  800112:	03067e63          	bgeu	a2,a6,80014e <printnum+0x60>
  800116:	89be                	mv	s3,a5
        while (-- width > 0)
  800118:	00805763          	blez	s0,800126 <printnum+0x38>
  80011c:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  80011e:	85ca                	mv	a1,s2
  800120:	854e                	mv	a0,s3
  800122:	9482                	jalr	s1
        while (-- width > 0)
  800124:	fc65                	bnez	s0,80011c <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800126:	1a02                	slli	s4,s4,0x20
  800128:	00000797          	auipc	a5,0x0
  80012c:	4a878793          	addi	a5,a5,1192 # 8005d0 <main+0xd8>
  800130:	020a5a13          	srli	s4,s4,0x20
  800134:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800136:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  800138:	000a4503          	lbu	a0,0(s4)
}
  80013c:	70a2                	ld	ra,40(sp)
  80013e:	69a2                	ld	s3,8(sp)
  800140:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  800142:	85ca                	mv	a1,s2
  800144:	87a6                	mv	a5,s1
}
  800146:	6942                	ld	s2,16(sp)
  800148:	64e2                	ld	s1,24(sp)
  80014a:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  80014c:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  80014e:	03065633          	divu	a2,a2,a6
  800152:	8722                	mv	a4,s0
  800154:	f9bff0ef          	jal	ra,8000ee <printnum>
  800158:	b7f9                	j	800126 <printnum+0x38>

000000000080015a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80015a:	7119                	addi	sp,sp,-128
  80015c:	f4a6                	sd	s1,104(sp)
  80015e:	f0ca                	sd	s2,96(sp)
  800160:	ecce                	sd	s3,88(sp)
  800162:	e8d2                	sd	s4,80(sp)
  800164:	e4d6                	sd	s5,72(sp)
  800166:	e0da                	sd	s6,64(sp)
  800168:	fc5e                	sd	s7,56(sp)
  80016a:	f06a                	sd	s10,32(sp)
  80016c:	fc86                	sd	ra,120(sp)
  80016e:	f8a2                	sd	s0,112(sp)
  800170:	f862                	sd	s8,48(sp)
  800172:	f466                	sd	s9,40(sp)
  800174:	ec6e                	sd	s11,24(sp)
  800176:	892a                	mv	s2,a0
  800178:	84ae                	mv	s1,a1
  80017a:	8d32                	mv	s10,a2
  80017c:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80017e:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
  800182:	5b7d                	li	s6,-1
  800184:	00000a97          	auipc	s5,0x0
  800188:	480a8a93          	addi	s5,s5,1152 # 800604 <main+0x10c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80018c:	00000b97          	auipc	s7,0x0
  800190:	694b8b93          	addi	s7,s7,1684 # 800820 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800194:	000d4503          	lbu	a0,0(s10)
  800198:	001d0413          	addi	s0,s10,1
  80019c:	01350a63          	beq	a0,s3,8001b0 <vprintfmt+0x56>
            if (ch == '\0') {
  8001a0:	c121                	beqz	a0,8001e0 <vprintfmt+0x86>
            putch(ch, putdat);
  8001a2:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001a4:	0405                	addi	s0,s0,1
            putch(ch, putdat);
  8001a6:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8001a8:	fff44503          	lbu	a0,-1(s0)
  8001ac:	ff351ae3          	bne	a0,s3,8001a0 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
  8001b0:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
  8001b4:	02000793          	li	a5,32
        lflag = altflag = 0;
  8001b8:	4c81                	li	s9,0
  8001ba:	4881                	li	a7,0
        width = precision = -1;
  8001bc:	5c7d                	li	s8,-1
  8001be:	5dfd                	li	s11,-1
  8001c0:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
  8001c4:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
  8001c6:	fdd6059b          	addiw	a1,a2,-35
  8001ca:	0ff5f593          	zext.b	a1,a1
  8001ce:	00140d13          	addi	s10,s0,1
  8001d2:	04b56263          	bltu	a0,a1,800216 <vprintfmt+0xbc>
  8001d6:	058a                	slli	a1,a1,0x2
  8001d8:	95d6                	add	a1,a1,s5
  8001da:	4194                	lw	a3,0(a1)
  8001dc:	96d6                	add	a3,a3,s5
  8001de:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001e0:	70e6                	ld	ra,120(sp)
  8001e2:	7446                	ld	s0,112(sp)
  8001e4:	74a6                	ld	s1,104(sp)
  8001e6:	7906                	ld	s2,96(sp)
  8001e8:	69e6                	ld	s3,88(sp)
  8001ea:	6a46                	ld	s4,80(sp)
  8001ec:	6aa6                	ld	s5,72(sp)
  8001ee:	6b06                	ld	s6,64(sp)
  8001f0:	7be2                	ld	s7,56(sp)
  8001f2:	7c42                	ld	s8,48(sp)
  8001f4:	7ca2                	ld	s9,40(sp)
  8001f6:	7d02                	ld	s10,32(sp)
  8001f8:	6de2                	ld	s11,24(sp)
  8001fa:	6109                	addi	sp,sp,128
  8001fc:	8082                	ret
            padc = '0';
  8001fe:	87b2                	mv	a5,a2
            goto reswitch;
  800200:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  800204:	846a                	mv	s0,s10
  800206:	00140d13          	addi	s10,s0,1
  80020a:	fdd6059b          	addiw	a1,a2,-35
  80020e:	0ff5f593          	zext.b	a1,a1
  800212:	fcb572e3          	bgeu	a0,a1,8001d6 <vprintfmt+0x7c>
            putch('%', putdat);
  800216:	85a6                	mv	a1,s1
  800218:	02500513          	li	a0,37
  80021c:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
  80021e:	fff44783          	lbu	a5,-1(s0)
  800222:	8d22                	mv	s10,s0
  800224:	f73788e3          	beq	a5,s3,800194 <vprintfmt+0x3a>
  800228:	ffed4783          	lbu	a5,-2(s10)
  80022c:	1d7d                	addi	s10,s10,-1
  80022e:	ff379de3          	bne	a5,s3,800228 <vprintfmt+0xce>
  800232:	b78d                	j	800194 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
  800234:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
  800238:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
  80023c:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
  80023e:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
  800242:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  800246:	02d86463          	bltu	a6,a3,80026e <vprintfmt+0x114>
                ch = *fmt;
  80024a:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
  80024e:	002c169b          	slliw	a3,s8,0x2
  800252:	0186873b          	addw	a4,a3,s8
  800256:	0017171b          	slliw	a4,a4,0x1
  80025a:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
  80025c:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
  800260:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  800262:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
  800266:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
  80026a:	fed870e3          	bgeu	a6,a3,80024a <vprintfmt+0xf0>
            if (width < 0)
  80026e:	f40ddce3          	bgez	s11,8001c6 <vprintfmt+0x6c>
                width = precision, precision = -1;
  800272:	8de2                	mv	s11,s8
  800274:	5c7d                	li	s8,-1
  800276:	bf81                	j	8001c6 <vprintfmt+0x6c>
            if (width < 0)
  800278:	fffdc693          	not	a3,s11
  80027c:	96fd                	srai	a3,a3,0x3f
  80027e:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
  800282:	00144603          	lbu	a2,1(s0)
  800286:	2d81                	sext.w	s11,s11
  800288:	846a                	mv	s0,s10
            goto reswitch;
  80028a:	bf35                	j	8001c6 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
  80028c:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  800290:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
  800294:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
  800296:	846a                	mv	s0,s10
            goto process_precision;
  800298:	bfd9                	j	80026e <vprintfmt+0x114>
    if (lflag >= 2) {
  80029a:	4705                	li	a4,1
            precision = va_arg(ap, int);
  80029c:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002a0:	01174463          	blt	a4,a7,8002a8 <vprintfmt+0x14e>
    else if (lflag) {
  8002a4:	1a088e63          	beqz	a7,800460 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
  8002a8:	000a3603          	ld	a2,0(s4)
  8002ac:	46c1                	li	a3,16
  8002ae:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  8002b0:	2781                	sext.w	a5,a5
  8002b2:	876e                	mv	a4,s11
  8002b4:	85a6                	mv	a1,s1
  8002b6:	854a                	mv	a0,s2
  8002b8:	e37ff0ef          	jal	ra,8000ee <printnum>
            break;
  8002bc:	bde1                	j	800194 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
  8002be:	000a2503          	lw	a0,0(s4)
  8002c2:	85a6                	mv	a1,s1
  8002c4:	0a21                	addi	s4,s4,8
  8002c6:	9902                	jalr	s2
            break;
  8002c8:	b5f1                	j	800194 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8002ca:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002cc:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002d0:	01174463          	blt	a4,a7,8002d8 <vprintfmt+0x17e>
    else if (lflag) {
  8002d4:	18088163          	beqz	a7,800456 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
  8002d8:	000a3603          	ld	a2,0(s4)
  8002dc:	46a9                	li	a3,10
  8002de:	8a2e                	mv	s4,a1
  8002e0:	bfc1                	j	8002b0 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
  8002e2:	00144603          	lbu	a2,1(s0)
            altflag = 1;
  8002e6:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
  8002e8:	846a                	mv	s0,s10
            goto reswitch;
  8002ea:	bdf1                	j	8001c6 <vprintfmt+0x6c>
            putch(ch, putdat);
  8002ec:	85a6                	mv	a1,s1
  8002ee:	02500513          	li	a0,37
  8002f2:	9902                	jalr	s2
            break;
  8002f4:	b545                	j	800194 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
  8002f6:	00144603          	lbu	a2,1(s0)
            lflag ++;
  8002fa:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
  8002fc:	846a                	mv	s0,s10
            goto reswitch;
  8002fe:	b5e1                	j	8001c6 <vprintfmt+0x6c>
    if (lflag >= 2) {
  800300:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800302:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800306:	01174463          	blt	a4,a7,80030e <vprintfmt+0x1b4>
    else if (lflag) {
  80030a:	14088163          	beqz	a7,80044c <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
  80030e:	000a3603          	ld	a2,0(s4)
  800312:	46a1                	li	a3,8
  800314:	8a2e                	mv	s4,a1
  800316:	bf69                	j	8002b0 <vprintfmt+0x156>
            putch('0', putdat);
  800318:	03000513          	li	a0,48
  80031c:	85a6                	mv	a1,s1
  80031e:	e03e                	sd	a5,0(sp)
  800320:	9902                	jalr	s2
            putch('x', putdat);
  800322:	85a6                	mv	a1,s1
  800324:	07800513          	li	a0,120
  800328:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  80032a:	0a21                	addi	s4,s4,8
            goto number;
  80032c:	6782                	ld	a5,0(sp)
  80032e:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800330:	ff8a3603          	ld	a2,-8(s4)
            goto number;
  800334:	bfb5                	j	8002b0 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
  800336:	000a3403          	ld	s0,0(s4)
  80033a:	008a0713          	addi	a4,s4,8
  80033e:	e03a                	sd	a4,0(sp)
  800340:	14040263          	beqz	s0,800484 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
  800344:	0fb05763          	blez	s11,800432 <vprintfmt+0x2d8>
  800348:	02d00693          	li	a3,45
  80034c:	0cd79163          	bne	a5,a3,80040e <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800350:	00044783          	lbu	a5,0(s0)
  800354:	0007851b          	sext.w	a0,a5
  800358:	cf85                	beqz	a5,800390 <vprintfmt+0x236>
  80035a:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
  80035e:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800362:	000c4563          	bltz	s8,80036c <vprintfmt+0x212>
  800366:	3c7d                	addiw	s8,s8,-1
  800368:	036c0263          	beq	s8,s6,80038c <vprintfmt+0x232>
                    putch('?', putdat);
  80036c:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
  80036e:	0e0c8e63          	beqz	s9,80046a <vprintfmt+0x310>
  800372:	3781                	addiw	a5,a5,-32
  800374:	0ef47b63          	bgeu	s0,a5,80046a <vprintfmt+0x310>
                    putch('?', putdat);
  800378:	03f00513          	li	a0,63
  80037c:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80037e:	000a4783          	lbu	a5,0(s4)
  800382:	3dfd                	addiw	s11,s11,-1
  800384:	0a05                	addi	s4,s4,1
  800386:	0007851b          	sext.w	a0,a5
  80038a:	ffe1                	bnez	a5,800362 <vprintfmt+0x208>
            for (; width > 0; width --) {
  80038c:	01b05963          	blez	s11,80039e <vprintfmt+0x244>
  800390:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
  800392:	85a6                	mv	a1,s1
  800394:	02000513          	li	a0,32
  800398:	9902                	jalr	s2
            for (; width > 0; width --) {
  80039a:	fe0d9be3          	bnez	s11,800390 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
  80039e:	6a02                	ld	s4,0(sp)
  8003a0:	bbd5                	j	800194 <vprintfmt+0x3a>
    if (lflag >= 2) {
  8003a2:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8003a4:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
  8003a8:	01174463          	blt	a4,a7,8003b0 <vprintfmt+0x256>
    else if (lflag) {
  8003ac:	08088d63          	beqz	a7,800446 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
  8003b0:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003b4:	0a044d63          	bltz	s0,80046e <vprintfmt+0x314>
            num = getint(&ap, lflag);
  8003b8:	8622                	mv	a2,s0
  8003ba:	8a66                	mv	s4,s9
  8003bc:	46a9                	li	a3,10
  8003be:	bdcd                	j	8002b0 <vprintfmt+0x156>
            err = va_arg(ap, int);
  8003c0:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003c4:	4761                	li	a4,24
            err = va_arg(ap, int);
  8003c6:	0a21                	addi	s4,s4,8
            if (err < 0) {
  8003c8:	41f7d69b          	sraiw	a3,a5,0x1f
  8003cc:	8fb5                	xor	a5,a5,a3
  8003ce:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003d2:	02d74163          	blt	a4,a3,8003f4 <vprintfmt+0x29a>
  8003d6:	00369793          	slli	a5,a3,0x3
  8003da:	97de                	add	a5,a5,s7
  8003dc:	639c                	ld	a5,0(a5)
  8003de:	cb99                	beqz	a5,8003f4 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
  8003e0:	86be                	mv	a3,a5
  8003e2:	00000617          	auipc	a2,0x0
  8003e6:	21e60613          	addi	a2,a2,542 # 800600 <main+0x108>
  8003ea:	85a6                	mv	a1,s1
  8003ec:	854a                	mv	a0,s2
  8003ee:	0ce000ef          	jal	ra,8004bc <printfmt>
  8003f2:	b34d                	j	800194 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
  8003f4:	00000617          	auipc	a2,0x0
  8003f8:	1fc60613          	addi	a2,a2,508 # 8005f0 <main+0xf8>
  8003fc:	85a6                	mv	a1,s1
  8003fe:	854a                	mv	a0,s2
  800400:	0bc000ef          	jal	ra,8004bc <printfmt>
  800404:	bb41                	j	800194 <vprintfmt+0x3a>
                p = "(null)";
  800406:	00000417          	auipc	s0,0x0
  80040a:	1e240413          	addi	s0,s0,482 # 8005e8 <main+0xf0>
                for (width -= strnlen(p, precision); width > 0; width --) {
  80040e:	85e2                	mv	a1,s8
  800410:	8522                	mv	a0,s0
  800412:	e43e                	sd	a5,8(sp)
  800414:	0c8000ef          	jal	ra,8004dc <strnlen>
  800418:	40ad8dbb          	subw	s11,s11,a0
  80041c:	01b05b63          	blez	s11,800432 <vprintfmt+0x2d8>
                    putch(padc, putdat);
  800420:	67a2                	ld	a5,8(sp)
  800422:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  800426:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
  800428:	85a6                	mv	a1,s1
  80042a:	8552                	mv	a0,s4
  80042c:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
  80042e:	fe0d9ce3          	bnez	s11,800426 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800432:	00044783          	lbu	a5,0(s0)
  800436:	00140a13          	addi	s4,s0,1
  80043a:	0007851b          	sext.w	a0,a5
  80043e:	d3a5                	beqz	a5,80039e <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
  800440:	05e00413          	li	s0,94
  800444:	bf39                	j	800362 <vprintfmt+0x208>
        return va_arg(*ap, int);
  800446:	000a2403          	lw	s0,0(s4)
  80044a:	b7ad                	j	8003b4 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
  80044c:	000a6603          	lwu	a2,0(s4)
  800450:	46a1                	li	a3,8
  800452:	8a2e                	mv	s4,a1
  800454:	bdb1                	j	8002b0 <vprintfmt+0x156>
  800456:	000a6603          	lwu	a2,0(s4)
  80045a:	46a9                	li	a3,10
  80045c:	8a2e                	mv	s4,a1
  80045e:	bd89                	j	8002b0 <vprintfmt+0x156>
  800460:	000a6603          	lwu	a2,0(s4)
  800464:	46c1                	li	a3,16
  800466:	8a2e                	mv	s4,a1
  800468:	b5a1                	j	8002b0 <vprintfmt+0x156>
                    putch(ch, putdat);
  80046a:	9902                	jalr	s2
  80046c:	bf09                	j	80037e <vprintfmt+0x224>
                putch('-', putdat);
  80046e:	85a6                	mv	a1,s1
  800470:	02d00513          	li	a0,45
  800474:	e03e                	sd	a5,0(sp)
  800476:	9902                	jalr	s2
                num = -(long long)num;
  800478:	6782                	ld	a5,0(sp)
  80047a:	8a66                	mv	s4,s9
  80047c:	40800633          	neg	a2,s0
  800480:	46a9                	li	a3,10
  800482:	b53d                	j	8002b0 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
  800484:	03b05163          	blez	s11,8004a6 <vprintfmt+0x34c>
  800488:	02d00693          	li	a3,45
  80048c:	f6d79de3          	bne	a5,a3,800406 <vprintfmt+0x2ac>
                p = "(null)";
  800490:	00000417          	auipc	s0,0x0
  800494:	15840413          	addi	s0,s0,344 # 8005e8 <main+0xf0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800498:	02800793          	li	a5,40
  80049c:	02800513          	li	a0,40
  8004a0:	00140a13          	addi	s4,s0,1
  8004a4:	bd6d                	j	80035e <vprintfmt+0x204>
  8004a6:	00000a17          	auipc	s4,0x0
  8004aa:	143a0a13          	addi	s4,s4,323 # 8005e9 <main+0xf1>
  8004ae:	02800513          	li	a0,40
  8004b2:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
  8004b6:	05e00413          	li	s0,94
  8004ba:	b565                	j	800362 <vprintfmt+0x208>

00000000008004bc <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004bc:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  8004be:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004c2:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004c4:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004c6:	ec06                	sd	ra,24(sp)
  8004c8:	f83a                	sd	a4,48(sp)
  8004ca:	fc3e                	sd	a5,56(sp)
  8004cc:	e0c2                	sd	a6,64(sp)
  8004ce:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004d0:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004d2:	c89ff0ef          	jal	ra,80015a <vprintfmt>
}
  8004d6:	60e2                	ld	ra,24(sp)
  8004d8:	6161                	addi	sp,sp,80
  8004da:	8082                	ret

00000000008004dc <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8004dc:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8004de:	e589                	bnez	a1,8004e8 <strnlen+0xc>
  8004e0:	a811                	j	8004f4 <strnlen+0x18>
        cnt ++;
  8004e2:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8004e4:	00f58863          	beq	a1,a5,8004f4 <strnlen+0x18>
  8004e8:	00f50733          	add	a4,a0,a5
  8004ec:	00074703          	lbu	a4,0(a4)
  8004f0:	fb6d                	bnez	a4,8004e2 <strnlen+0x6>
  8004f2:	85be                	mv	a1,a5
    }
    return cnt;
}
  8004f4:	852e                	mv	a0,a1
  8004f6:	8082                	ret

00000000008004f8 <main>:
#include <stdio.h>
#include <ulib.h>

int global_var = 100;

int main(void) {
  8004f8:	1101                	addi	sp,sp,-32
    int pid;
    int local_var = 200;

    cprintf("COW Test: Parent process starting...\n");
  8004fa:	00000517          	auipc	a0,0x0
  8004fe:	3ee50513          	addi	a0,a0,1006 # 8008e8 <error_string+0xc8>
int main(void) {
  800502:	ec06                	sd	ra,24(sp)
  800504:	e822                	sd	s0,16(sp)
    cprintf("COW Test: Parent process starting...\n");
  800506:	b3bff0ef          	jal	ra,800040 <cprintf>
    cprintf("Before fork: global_var = %d, local_var = %d\n", global_var, local_var);
  80050a:	00001417          	auipc	s0,0x1
  80050e:	af640413          	addi	s0,s0,-1290 # 801000 <global_var>
  800512:	400c                	lw	a1,0(s0)
  800514:	0c800613          	li	a2,200
  800518:	00000517          	auipc	a0,0x0
  80051c:	3f850513          	addi	a0,a0,1016 # 800910 <error_string+0xf0>
  800520:	b21ff0ef          	jal	ra,800040 <cprintf>

    pid = fork();
  800524:	bbbff0ef          	jal	ra,8000de <fork>

    if (pid == 0) {
  800528:	c129                	beqz	a0,80056a <main+0x72>
        cprintf("CHILD: After modification: global_var = %d, local_var = %d\n", global_var, local_var);
        exit(0);
    } else {
        // === 父进程 ===
        int exit_code;
        waitpid(pid, &exit_code); // 等待子进程结束
  80052a:	006c                	addi	a1,sp,12
  80052c:	bb5ff0ef          	jal	ra,8000e0 <waitpid>
        
        cprintf("I am PARENT. Child finished.\n");
  800530:	00000517          	auipc	a0,0x0
  800534:	4d850513          	addi	a0,a0,1240 # 800a08 <error_string+0x1e8>
  800538:	b09ff0ef          	jal	ra,800040 <cprintf>
        
        //检查父进程的值是否被修改
        // 如果 COW 正常，父进程的值应该保持不变（因为子进程改的是副本）
        if (global_var == 100 && local_var == 200) {
  80053c:	4018                	lw	a4,0(s0)
  80053e:	06400793          	li	a5,100
  800542:	00f70d63          	beq	a4,a5,80055c <main+0x64>
            cprintf("cow success!\n");
        } else {
            cprintf("FAILURE: Parent's variables were modified! COW failed.\n");
  800546:	00000517          	auipc	a0,0x0
  80054a:	4f250513          	addi	a0,a0,1266 # 800a38 <error_string+0x218>
  80054e:	af3ff0ef          	jal	ra,800040 <cprintf>
        }
    }
    return 0;
  800552:	60e2                	ld	ra,24(sp)
  800554:	6442                	ld	s0,16(sp)
  800556:	4501                	li	a0,0
  800558:	6105                	addi	sp,sp,32
  80055a:	8082                	ret
            cprintf("cow success!\n");
  80055c:	00000517          	auipc	a0,0x0
  800560:	4cc50513          	addi	a0,a0,1228 # 800a28 <error_string+0x208>
  800564:	addff0ef          	jal	ra,800040 <cprintf>
  800568:	b7ed                	j	800552 <main+0x5a>
        cprintf("I am CHILD. Reading values (should be same)...\n");
  80056a:	00000517          	auipc	a0,0x0
  80056e:	3d650513          	addi	a0,a0,982 # 800940 <error_string+0x120>
  800572:	acfff0ef          	jal	ra,800040 <cprintf>
        cprintf("CHILD: global_var = %d, local_var = %d\n", global_var, local_var);
  800576:	400c                	lw	a1,0(s0)
  800578:	0c800613          	li	a2,200
  80057c:	00000517          	auipc	a0,0x0
  800580:	3f450513          	addi	a0,a0,1012 # 800970 <error_string+0x150>
  800584:	abdff0ef          	jal	ra,800040 <cprintf>
        cprintf("CHILD: Modifying variables (Triggering COW)...\n");
  800588:	00000517          	auipc	a0,0x0
  80058c:	41050513          	addi	a0,a0,1040 # 800998 <error_string+0x178>
  800590:	ab1ff0ef          	jal	ra,800040 <cprintf>
        global_var = 300;
  800594:	12c00793          	li	a5,300
        cprintf("CHILD: After modification: global_var = %d, local_var = %d\n", global_var, local_var);
  800598:	19000613          	li	a2,400
  80059c:	12c00593          	li	a1,300
  8005a0:	00000517          	auipc	a0,0x0
  8005a4:	42850513          	addi	a0,a0,1064 # 8009c8 <error_string+0x1a8>
        global_var = 300;
  8005a8:	c01c                	sw	a5,0(s0)
        cprintf("CHILD: After modification: global_var = %d, local_var = %d\n", global_var, local_var);
  8005aa:	a97ff0ef          	jal	ra,800040 <cprintf>
        exit(0);
  8005ae:	4501                	li	a0,0
  8005b0:	b19ff0ef          	jal	ra,8000c8 <exit>
