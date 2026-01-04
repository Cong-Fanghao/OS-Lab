
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	5380b0ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0200066:	52c000ef          	jal	ra,ffffffffc0200592 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	59e58593          	addi	a1,a1,1438 # ffffffffc020b608 <etext+0x4>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	5b650513          	addi	a0,a0,1462 # ffffffffc020b628 <etext+0x24>
ffffffffc020007a:	12c000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ae000ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc0200082:	62a000ef          	jal	ra,ffffffffc02006ac <dtb_init>
ffffffffc0200086:	24b020ef          	jal	ra,ffffffffc0202ad0 <pmm_init>
ffffffffc020008a:	3ef000ef          	jal	ra,ffffffffc0200c78 <pic_init>
ffffffffc020008e:	515000ef          	jal	ra,ffffffffc0200da2 <idt_init>
ffffffffc0200092:	755030ef          	jal	ra,ffffffffc0203fe6 <vmm_init>
ffffffffc0200096:	282070ef          	jal	ra,ffffffffc0207318 <sched_init>
ffffffffc020009a:	689060ef          	jal	ra,ffffffffc0206f22 <proc_init>
ffffffffc020009e:	1bf000ef          	jal	ra,ffffffffc0200a5c <ide_init>
ffffffffc02000a2:	186050ef          	jal	ra,ffffffffc0205228 <fs_init>
ffffffffc02000a6:	4a4000ef          	jal	ra,ffffffffc020054a <clock_init>
ffffffffc02000aa:	3c3000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02000ae:	040070ef          	jal	ra,ffffffffc02070ee <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	715d                	addi	sp,sp,-80
ffffffffc02000b4:	e486                	sd	ra,72(sp)
ffffffffc02000b6:	e0a6                	sd	s1,64(sp)
ffffffffc02000b8:	fc4a                	sd	s2,56(sp)
ffffffffc02000ba:	f84e                	sd	s3,48(sp)
ffffffffc02000bc:	f452                	sd	s4,40(sp)
ffffffffc02000be:	f056                	sd	s5,32(sp)
ffffffffc02000c0:	ec5a                	sd	s6,24(sp)
ffffffffc02000c2:	e85e                	sd	s7,16(sp)
ffffffffc02000c4:	c901                	beqz	a0,ffffffffc02000d4 <readline+0x22>
ffffffffc02000c6:	85aa                	mv	a1,a0
ffffffffc02000c8:	0000b517          	auipc	a0,0xb
ffffffffc02000cc:	56850513          	addi	a0,a0,1384 # ffffffffc020b630 <etext+0x2c>
ffffffffc02000d0:	0d6000ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02000d4:	4481                	li	s1,0
ffffffffc02000d6:	497d                	li	s2,31
ffffffffc02000d8:	49a1                	li	s3,8
ffffffffc02000da:	4aa9                	li	s5,10
ffffffffc02000dc:	4b35                	li	s6,13
ffffffffc02000de:	00091b97          	auipc	s7,0x91
ffffffffc02000e2:	f82b8b93          	addi	s7,s7,-126 # ffffffffc0291060 <buf>
ffffffffc02000e6:	3fe00a13          	li	s4,1022
ffffffffc02000ea:	0fa000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000ee:	00054a63          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc02000f2:	00a95a63          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc02000f6:	029a5263          	bge	s4,s1,ffffffffc020011a <readline+0x68>
ffffffffc02000fa:	0ea000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc02000fe:	fe055ae3          	bgez	a0,ffffffffc02000f2 <readline+0x40>
ffffffffc0200102:	4501                	li	a0,0
ffffffffc0200104:	a091                	j	ffffffffc0200148 <readline+0x96>
ffffffffc0200106:	03351463          	bne	a0,s3,ffffffffc020012e <readline+0x7c>
ffffffffc020010a:	e8a9                	bnez	s1,ffffffffc020015c <readline+0xaa>
ffffffffc020010c:	0d8000ef          	jal	ra,ffffffffc02001e4 <getchar>
ffffffffc0200110:	fe0549e3          	bltz	a0,ffffffffc0200102 <readline+0x50>
ffffffffc0200114:	fea959e3          	bge	s2,a0,ffffffffc0200106 <readline+0x54>
ffffffffc0200118:	4481                	li	s1,0
ffffffffc020011a:	e42a                	sd	a0,8(sp)
ffffffffc020011c:	0c6000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200120:	6522                	ld	a0,8(sp)
ffffffffc0200122:	009b87b3          	add	a5,s7,s1
ffffffffc0200126:	2485                	addiw	s1,s1,1
ffffffffc0200128:	00a78023          	sb	a0,0(a5)
ffffffffc020012c:	bf7d                	j	ffffffffc02000ea <readline+0x38>
ffffffffc020012e:	01550463          	beq	a0,s5,ffffffffc0200136 <readline+0x84>
ffffffffc0200132:	fb651ce3          	bne	a0,s6,ffffffffc02000ea <readline+0x38>
ffffffffc0200136:	0ac000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc020013a:	00091517          	auipc	a0,0x91
ffffffffc020013e:	f2650513          	addi	a0,a0,-218 # ffffffffc0291060 <buf>
ffffffffc0200142:	94aa                	add	s1,s1,a0
ffffffffc0200144:	00048023          	sb	zero,0(s1)
ffffffffc0200148:	60a6                	ld	ra,72(sp)
ffffffffc020014a:	6486                	ld	s1,64(sp)
ffffffffc020014c:	7962                	ld	s2,56(sp)
ffffffffc020014e:	79c2                	ld	s3,48(sp)
ffffffffc0200150:	7a22                	ld	s4,40(sp)
ffffffffc0200152:	7a82                	ld	s5,32(sp)
ffffffffc0200154:	6b62                	ld	s6,24(sp)
ffffffffc0200156:	6bc2                	ld	s7,16(sp)
ffffffffc0200158:	6161                	addi	sp,sp,80
ffffffffc020015a:	8082                	ret
ffffffffc020015c:	4521                	li	a0,8
ffffffffc020015e:	084000ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0200162:	34fd                	addiw	s1,s1,-1
ffffffffc0200164:	b759                	j	ffffffffc02000ea <readline+0x38>

ffffffffc0200166 <cputch>:
ffffffffc0200166:	1141                	addi	sp,sp,-16
ffffffffc0200168:	e022                	sd	s0,0(sp)
ffffffffc020016a:	e406                	sd	ra,8(sp)
ffffffffc020016c:	842e                	mv	s0,a1
ffffffffc020016e:	432000ef          	jal	ra,ffffffffc02005a0 <cons_putc>
ffffffffc0200172:	401c                	lw	a5,0(s0)
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	2785                	addiw	a5,a5,1
ffffffffc0200178:	c01c                	sw	a5,0(s0)
ffffffffc020017a:	6402                	ld	s0,0(sp)
ffffffffc020017c:	0141                	addi	sp,sp,16
ffffffffc020017e:	8082                	ret

ffffffffc0200180 <vcprintf>:
ffffffffc0200180:	1101                	addi	sp,sp,-32
ffffffffc0200182:	872e                	mv	a4,a1
ffffffffc0200184:	75dd                	lui	a1,0xffff7
ffffffffc0200186:	86aa                	mv	a3,a0
ffffffffc0200188:	0070                	addi	a2,sp,12
ffffffffc020018a:	00000517          	auipc	a0,0x0
ffffffffc020018e:	fdc50513          	addi	a0,a0,-36 # ffffffffc0200166 <cputch>
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	7730a0ef          	jal	ra,ffffffffc020b10c <vprintfmt>
ffffffffc020019e:	60e2                	ld	ra,24(sp)
ffffffffc02001a0:	4532                	lw	a0,12(sp)
ffffffffc02001a2:	6105                	addi	sp,sp,32
ffffffffc02001a4:	8082                	ret

ffffffffc02001a6 <cprintf>:
ffffffffc02001a6:	711d                	addi	sp,sp,-96
ffffffffc02001a8:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc02001ac:	8e2a                	mv	t3,a0
ffffffffc02001ae:	f42e                	sd	a1,40(sp)
ffffffffc02001b0:	75dd                	lui	a1,0xffff7
ffffffffc02001b2:	f832                	sd	a2,48(sp)
ffffffffc02001b4:	fc36                	sd	a3,56(sp)
ffffffffc02001b6:	e0ba                	sd	a4,64(sp)
ffffffffc02001b8:	00000517          	auipc	a0,0x0
ffffffffc02001bc:	fae50513          	addi	a0,a0,-82 # ffffffffc0200166 <cputch>
ffffffffc02001c0:	0050                	addi	a2,sp,4
ffffffffc02001c2:	871a                	mv	a4,t1
ffffffffc02001c4:	86f2                	mv	a3,t3
ffffffffc02001c6:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc02001ca:	ec06                	sd	ra,24(sp)
ffffffffc02001cc:	e4be                	sd	a5,72(sp)
ffffffffc02001ce:	e8c2                	sd	a6,80(sp)
ffffffffc02001d0:	ecc6                	sd	a7,88(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	c202                	sw	zero,4(sp)
ffffffffc02001d6:	7370a0ef          	jal	ra,ffffffffc020b10c <vprintfmt>
ffffffffc02001da:	60e2                	ld	ra,24(sp)
ffffffffc02001dc:	4512                	lw	a0,4(sp)
ffffffffc02001de:	6125                	addi	sp,sp,96
ffffffffc02001e0:	8082                	ret

ffffffffc02001e2 <cputchar>:
ffffffffc02001e2:	ae7d                	j	ffffffffc02005a0 <cons_putc>

ffffffffc02001e4 <getchar>:
ffffffffc02001e4:	1141                	addi	sp,sp,-16
ffffffffc02001e6:	e406                	sd	ra,8(sp)
ffffffffc02001e8:	40c000ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc02001ec:	dd75                	beqz	a0,ffffffffc02001e8 <getchar+0x4>
ffffffffc02001ee:	60a2                	ld	ra,8(sp)
ffffffffc02001f0:	0141                	addi	sp,sp,16
ffffffffc02001f2:	8082                	ret

ffffffffc02001f4 <strdup>:
ffffffffc02001f4:	1101                	addi	sp,sp,-32
ffffffffc02001f6:	ec06                	sd	ra,24(sp)
ffffffffc02001f8:	e822                	sd	s0,16(sp)
ffffffffc02001fa:	e426                	sd	s1,8(sp)
ffffffffc02001fc:	e04a                	sd	s2,0(sp)
ffffffffc02001fe:	892a                	mv	s2,a0
ffffffffc0200200:	2f80b0ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc0200204:	842a                	mv	s0,a0
ffffffffc0200206:	0505                	addi	a0,a0,1
ffffffffc0200208:	587010ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020020c:	84aa                	mv	s1,a0
ffffffffc020020e:	c901                	beqz	a0,ffffffffc020021e <strdup+0x2a>
ffffffffc0200210:	8622                	mv	a2,s0
ffffffffc0200212:	85ca                	mv	a1,s2
ffffffffc0200214:	9426                	add	s0,s0,s1
ffffffffc0200216:	3d60b0ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020021a:	00040023          	sb	zero,0(s0)
ffffffffc020021e:	60e2                	ld	ra,24(sp)
ffffffffc0200220:	6442                	ld	s0,16(sp)
ffffffffc0200222:	6902                	ld	s2,0(sp)
ffffffffc0200224:	8526                	mv	a0,s1
ffffffffc0200226:	64a2                	ld	s1,8(sp)
ffffffffc0200228:	6105                	addi	sp,sp,32
ffffffffc020022a:	8082                	ret

ffffffffc020022c <print_kerninfo>:
ffffffffc020022c:	1141                	addi	sp,sp,-16
ffffffffc020022e:	0000b517          	auipc	a0,0xb
ffffffffc0200232:	40a50513          	addi	a0,a0,1034 # ffffffffc020b638 <etext+0x34>
ffffffffc0200236:	e406                	sd	ra,8(sp)
ffffffffc0200238:	f6fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020023c:	00000597          	auipc	a1,0x0
ffffffffc0200240:	e0e58593          	addi	a1,a1,-498 # ffffffffc020004a <kern_init>
ffffffffc0200244:	0000b517          	auipc	a0,0xb
ffffffffc0200248:	41450513          	addi	a0,a0,1044 # ffffffffc020b658 <etext+0x54>
ffffffffc020024c:	f5bff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200250:	0000b597          	auipc	a1,0xb
ffffffffc0200254:	3b458593          	addi	a1,a1,948 # ffffffffc020b604 <etext>
ffffffffc0200258:	0000b517          	auipc	a0,0xb
ffffffffc020025c:	42050513          	addi	a0,a0,1056 # ffffffffc020b678 <etext+0x74>
ffffffffc0200260:	f47ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200264:	00091597          	auipc	a1,0x91
ffffffffc0200268:	dfc58593          	addi	a1,a1,-516 # ffffffffc0291060 <buf>
ffffffffc020026c:	0000b517          	auipc	a0,0xb
ffffffffc0200270:	42c50513          	addi	a0,a0,1068 # ffffffffc020b698 <etext+0x94>
ffffffffc0200274:	f33ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200278:	00096597          	auipc	a1,0x96
ffffffffc020027c:	69858593          	addi	a1,a1,1688 # ffffffffc0296910 <end>
ffffffffc0200280:	0000b517          	auipc	a0,0xb
ffffffffc0200284:	43850513          	addi	a0,a0,1080 # ffffffffc020b6b8 <etext+0xb4>
ffffffffc0200288:	f1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020028c:	00097597          	auipc	a1,0x97
ffffffffc0200290:	a8358593          	addi	a1,a1,-1405 # ffffffffc0296d0f <end+0x3ff>
ffffffffc0200294:	00000797          	auipc	a5,0x0
ffffffffc0200298:	db678793          	addi	a5,a5,-586 # ffffffffc020004a <kern_init>
ffffffffc020029c:	40f587b3          	sub	a5,a1,a5
ffffffffc02002a0:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a4:	60a2                	ld	ra,8(sp)
ffffffffc02002a6:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002aa:	95be                	add	a1,a1,a5
ffffffffc02002ac:	85a9                	srai	a1,a1,0xa
ffffffffc02002ae:	0000b517          	auipc	a0,0xb
ffffffffc02002b2:	42a50513          	addi	a0,a0,1066 # ffffffffc020b6d8 <etext+0xd4>
ffffffffc02002b6:	0141                	addi	sp,sp,16
ffffffffc02002b8:	b5fd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002ba <print_stackframe>:
ffffffffc02002ba:	1141                	addi	sp,sp,-16
ffffffffc02002bc:	0000b617          	auipc	a2,0xb
ffffffffc02002c0:	44c60613          	addi	a2,a2,1100 # ffffffffc020b708 <etext+0x104>
ffffffffc02002c4:	04e00593          	li	a1,78
ffffffffc02002c8:	0000b517          	auipc	a0,0xb
ffffffffc02002cc:	45850513          	addi	a0,a0,1112 # ffffffffc020b720 <etext+0x11c>
ffffffffc02002d0:	e406                	sd	ra,8(sp)
ffffffffc02002d2:	1cc000ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02002d6 <mon_help>:
ffffffffc02002d6:	1141                	addi	sp,sp,-16
ffffffffc02002d8:	0000b617          	auipc	a2,0xb
ffffffffc02002dc:	46060613          	addi	a2,a2,1120 # ffffffffc020b738 <etext+0x134>
ffffffffc02002e0:	0000b597          	auipc	a1,0xb
ffffffffc02002e4:	47858593          	addi	a1,a1,1144 # ffffffffc020b758 <etext+0x154>
ffffffffc02002e8:	0000b517          	auipc	a0,0xb
ffffffffc02002ec:	47850513          	addi	a0,a0,1144 # ffffffffc020b760 <etext+0x15c>
ffffffffc02002f0:	e406                	sd	ra,8(sp)
ffffffffc02002f2:	eb5ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02002f6:	0000b617          	auipc	a2,0xb
ffffffffc02002fa:	47a60613          	addi	a2,a2,1146 # ffffffffc020b770 <etext+0x16c>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	49a58593          	addi	a1,a1,1178 # ffffffffc020b798 <etext+0x194>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	45a50513          	addi	a0,a0,1114 # ffffffffc020b760 <etext+0x15c>
ffffffffc020030e:	e99ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200312:	0000b617          	auipc	a2,0xb
ffffffffc0200316:	49660613          	addi	a2,a2,1174 # ffffffffc020b7a8 <etext+0x1a4>
ffffffffc020031a:	0000b597          	auipc	a1,0xb
ffffffffc020031e:	4ae58593          	addi	a1,a1,1198 # ffffffffc020b7c8 <etext+0x1c4>
ffffffffc0200322:	0000b517          	auipc	a0,0xb
ffffffffc0200326:	43e50513          	addi	a0,a0,1086 # ffffffffc020b760 <etext+0x15c>
ffffffffc020032a:	e7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020032e:	60a2                	ld	ra,8(sp)
ffffffffc0200330:	4501                	li	a0,0
ffffffffc0200332:	0141                	addi	sp,sp,16
ffffffffc0200334:	8082                	ret

ffffffffc0200336 <mon_kerninfo>:
ffffffffc0200336:	1141                	addi	sp,sp,-16
ffffffffc0200338:	e406                	sd	ra,8(sp)
ffffffffc020033a:	ef3ff0ef          	jal	ra,ffffffffc020022c <print_kerninfo>
ffffffffc020033e:	60a2                	ld	ra,8(sp)
ffffffffc0200340:	4501                	li	a0,0
ffffffffc0200342:	0141                	addi	sp,sp,16
ffffffffc0200344:	8082                	ret

ffffffffc0200346 <mon_backtrace>:
ffffffffc0200346:	1141                	addi	sp,sp,-16
ffffffffc0200348:	e406                	sd	ra,8(sp)
ffffffffc020034a:	f71ff0ef          	jal	ra,ffffffffc02002ba <print_stackframe>
ffffffffc020034e:	60a2                	ld	ra,8(sp)
ffffffffc0200350:	4501                	li	a0,0
ffffffffc0200352:	0141                	addi	sp,sp,16
ffffffffc0200354:	8082                	ret

ffffffffc0200356 <kmonitor>:
ffffffffc0200356:	7115                	addi	sp,sp,-224
ffffffffc0200358:	ed5e                	sd	s7,152(sp)
ffffffffc020035a:	8baa                	mv	s7,a0
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	47c50513          	addi	a0,a0,1148 # ffffffffc020b7d8 <etext+0x1d4>
ffffffffc0200364:	ed86                	sd	ra,216(sp)
ffffffffc0200366:	e9a2                	sd	s0,208(sp)
ffffffffc0200368:	e5a6                	sd	s1,200(sp)
ffffffffc020036a:	e1ca                	sd	s2,192(sp)
ffffffffc020036c:	fd4e                	sd	s3,184(sp)
ffffffffc020036e:	f952                	sd	s4,176(sp)
ffffffffc0200370:	f556                	sd	s5,168(sp)
ffffffffc0200372:	f15a                	sd	s6,160(sp)
ffffffffc0200374:	e962                	sd	s8,144(sp)
ffffffffc0200376:	e566                	sd	s9,136(sp)
ffffffffc0200378:	e16a                	sd	s10,128(sp)
ffffffffc020037a:	e2dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020037e:	0000b517          	auipc	a0,0xb
ffffffffc0200382:	48250513          	addi	a0,a0,1154 # ffffffffc020b800 <etext+0x1fc>
ffffffffc0200386:	e21ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020038a:	000b8563          	beqz	s7,ffffffffc0200394 <kmonitor+0x3e>
ffffffffc020038e:	855e                	mv	a0,s7
ffffffffc0200390:	3fb000ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc0200394:	0000bc17          	auipc	s8,0xb
ffffffffc0200398:	4dcc0c13          	addi	s8,s8,1244 # ffffffffc020b870 <commands>
ffffffffc020039c:	0000b917          	auipc	s2,0xb
ffffffffc02003a0:	48c90913          	addi	s2,s2,1164 # ffffffffc020b828 <etext+0x224>
ffffffffc02003a4:	0000b497          	auipc	s1,0xb
ffffffffc02003a8:	48c48493          	addi	s1,s1,1164 # ffffffffc020b830 <etext+0x22c>
ffffffffc02003ac:	49bd                	li	s3,15
ffffffffc02003ae:	0000bb17          	auipc	s6,0xb
ffffffffc02003b2:	48ab0b13          	addi	s6,s6,1162 # ffffffffc020b838 <etext+0x234>
ffffffffc02003b6:	0000ba17          	auipc	s4,0xb
ffffffffc02003ba:	3a2a0a13          	addi	s4,s4,930 # ffffffffc020b758 <etext+0x154>
ffffffffc02003be:	4a8d                	li	s5,3
ffffffffc02003c0:	854a                	mv	a0,s2
ffffffffc02003c2:	cf1ff0ef          	jal	ra,ffffffffc02000b2 <readline>
ffffffffc02003c6:	842a                	mv	s0,a0
ffffffffc02003c8:	dd65                	beqz	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003ca:	00054583          	lbu	a1,0(a0)
ffffffffc02003ce:	4c81                	li	s9,0
ffffffffc02003d0:	e1bd                	bnez	a1,ffffffffc0200436 <kmonitor+0xe0>
ffffffffc02003d2:	fe0c87e3          	beqz	s9,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc02003d6:	6582                	ld	a1,0(sp)
ffffffffc02003d8:	0000bd17          	auipc	s10,0xb
ffffffffc02003dc:	498d0d13          	addi	s10,s10,1176 # ffffffffc020b870 <commands>
ffffffffc02003e0:	8552                	mv	a0,s4
ffffffffc02003e2:	4401                	li	s0,0
ffffffffc02003e4:	0d61                	addi	s10,s10,24
ffffffffc02003e6:	15a0b0ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc02003ea:	c919                	beqz	a0,ffffffffc0200400 <kmonitor+0xaa>
ffffffffc02003ec:	2405                	addiw	s0,s0,1
ffffffffc02003ee:	0b540063          	beq	s0,s5,ffffffffc020048e <kmonitor+0x138>
ffffffffc02003f2:	000d3503          	ld	a0,0(s10)
ffffffffc02003f6:	6582                	ld	a1,0(sp)
ffffffffc02003f8:	0d61                	addi	s10,s10,24
ffffffffc02003fa:	1460b0ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc02003fe:	f57d                	bnez	a0,ffffffffc02003ec <kmonitor+0x96>
ffffffffc0200400:	00141793          	slli	a5,s0,0x1
ffffffffc0200404:	97a2                	add	a5,a5,s0
ffffffffc0200406:	078e                	slli	a5,a5,0x3
ffffffffc0200408:	97e2                	add	a5,a5,s8
ffffffffc020040a:	6b9c                	ld	a5,16(a5)
ffffffffc020040c:	865e                	mv	a2,s7
ffffffffc020040e:	002c                	addi	a1,sp,8
ffffffffc0200410:	fffc851b          	addiw	a0,s9,-1
ffffffffc0200414:	9782                	jalr	a5
ffffffffc0200416:	fa0555e3          	bgez	a0,ffffffffc02003c0 <kmonitor+0x6a>
ffffffffc020041a:	60ee                	ld	ra,216(sp)
ffffffffc020041c:	644e                	ld	s0,208(sp)
ffffffffc020041e:	64ae                	ld	s1,200(sp)
ffffffffc0200420:	690e                	ld	s2,192(sp)
ffffffffc0200422:	79ea                	ld	s3,184(sp)
ffffffffc0200424:	7a4a                	ld	s4,176(sp)
ffffffffc0200426:	7aaa                	ld	s5,168(sp)
ffffffffc0200428:	7b0a                	ld	s6,160(sp)
ffffffffc020042a:	6bea                	ld	s7,152(sp)
ffffffffc020042c:	6c4a                	ld	s8,144(sp)
ffffffffc020042e:	6caa                	ld	s9,136(sp)
ffffffffc0200430:	6d0a                	ld	s10,128(sp)
ffffffffc0200432:	612d                	addi	sp,sp,224
ffffffffc0200434:	8082                	ret
ffffffffc0200436:	8526                	mv	a0,s1
ffffffffc0200438:	14c0b0ef          	jal	ra,ffffffffc020b584 <strchr>
ffffffffc020043c:	c901                	beqz	a0,ffffffffc020044c <kmonitor+0xf6>
ffffffffc020043e:	00144583          	lbu	a1,1(s0)
ffffffffc0200442:	00040023          	sb	zero,0(s0)
ffffffffc0200446:	0405                	addi	s0,s0,1
ffffffffc0200448:	d5c9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc020044a:	b7f5                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc020044c:	00044783          	lbu	a5,0(s0)
ffffffffc0200450:	d3c9                	beqz	a5,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200452:	033c8963          	beq	s9,s3,ffffffffc0200484 <kmonitor+0x12e>
ffffffffc0200456:	003c9793          	slli	a5,s9,0x3
ffffffffc020045a:	0118                	addi	a4,sp,128
ffffffffc020045c:	97ba                	add	a5,a5,a4
ffffffffc020045e:	f887b023          	sd	s0,-128(a5)
ffffffffc0200462:	00044583          	lbu	a1,0(s0)
ffffffffc0200466:	2c85                	addiw	s9,s9,1
ffffffffc0200468:	e591                	bnez	a1,ffffffffc0200474 <kmonitor+0x11e>
ffffffffc020046a:	b7b5                	j	ffffffffc02003d6 <kmonitor+0x80>
ffffffffc020046c:	00144583          	lbu	a1,1(s0)
ffffffffc0200470:	0405                	addi	s0,s0,1
ffffffffc0200472:	d1a5                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200474:	8526                	mv	a0,s1
ffffffffc0200476:	10e0b0ef          	jal	ra,ffffffffc020b584 <strchr>
ffffffffc020047a:	d96d                	beqz	a0,ffffffffc020046c <kmonitor+0x116>
ffffffffc020047c:	00044583          	lbu	a1,0(s0)
ffffffffc0200480:	d9a9                	beqz	a1,ffffffffc02003d2 <kmonitor+0x7c>
ffffffffc0200482:	bf55                	j	ffffffffc0200436 <kmonitor+0xe0>
ffffffffc0200484:	45c1                	li	a1,16
ffffffffc0200486:	855a                	mv	a0,s6
ffffffffc0200488:	d1fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020048c:	b7e9                	j	ffffffffc0200456 <kmonitor+0x100>
ffffffffc020048e:	6582                	ld	a1,0(sp)
ffffffffc0200490:	0000b517          	auipc	a0,0xb
ffffffffc0200494:	3c850513          	addi	a0,a0,968 # ffffffffc020b858 <etext+0x254>
ffffffffc0200498:	d0fff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020049c:	b715                	j	ffffffffc02003c0 <kmonitor+0x6a>

ffffffffc020049e <__panic>:
ffffffffc020049e:	00096317          	auipc	t1,0x96
ffffffffc02004a2:	3ca30313          	addi	t1,t1,970 # ffffffffc0296868 <is_panic>
ffffffffc02004a6:	00033e03          	ld	t3,0(t1)
ffffffffc02004aa:	715d                	addi	sp,sp,-80
ffffffffc02004ac:	ec06                	sd	ra,24(sp)
ffffffffc02004ae:	e822                	sd	s0,16(sp)
ffffffffc02004b0:	f436                	sd	a3,40(sp)
ffffffffc02004b2:	f83a                	sd	a4,48(sp)
ffffffffc02004b4:	fc3e                	sd	a5,56(sp)
ffffffffc02004b6:	e0c2                	sd	a6,64(sp)
ffffffffc02004b8:	e4c6                	sd	a7,72(sp)
ffffffffc02004ba:	020e1a63          	bnez	t3,ffffffffc02004ee <__panic+0x50>
ffffffffc02004be:	4785                	li	a5,1
ffffffffc02004c0:	00f33023          	sd	a5,0(t1)
ffffffffc02004c4:	8432                	mv	s0,a2
ffffffffc02004c6:	103c                	addi	a5,sp,40
ffffffffc02004c8:	862e                	mv	a2,a1
ffffffffc02004ca:	85aa                	mv	a1,a0
ffffffffc02004cc:	0000b517          	auipc	a0,0xb
ffffffffc02004d0:	3ec50513          	addi	a0,a0,1004 # ffffffffc020b8b8 <commands+0x48>
ffffffffc02004d4:	e43e                	sd	a5,8(sp)
ffffffffc02004d6:	cd1ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004da:	65a2                	ld	a1,8(sp)
ffffffffc02004dc:	8522                	mv	a0,s0
ffffffffc02004de:	ca3ff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc02004e2:	0000c517          	auipc	a0,0xc
ffffffffc02004e6:	69650513          	addi	a0,a0,1686 # ffffffffc020cb78 <default_pmm_manager+0x610>
ffffffffc02004ea:	cbdff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02004ee:	4501                	li	a0,0
ffffffffc02004f0:	4581                	li	a1,0
ffffffffc02004f2:	4601                	li	a2,0
ffffffffc02004f4:	48a1                	li	a7,8
ffffffffc02004f6:	00000073          	ecall
ffffffffc02004fa:	778000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02004fe:	4501                	li	a0,0
ffffffffc0200500:	e57ff0ef          	jal	ra,ffffffffc0200356 <kmonitor>
ffffffffc0200504:	bfed                	j	ffffffffc02004fe <__panic+0x60>

ffffffffc0200506 <__warn>:
ffffffffc0200506:	715d                	addi	sp,sp,-80
ffffffffc0200508:	832e                	mv	t1,a1
ffffffffc020050a:	e822                	sd	s0,16(sp)
ffffffffc020050c:	85aa                	mv	a1,a0
ffffffffc020050e:	8432                	mv	s0,a2
ffffffffc0200510:	fc3e                	sd	a5,56(sp)
ffffffffc0200512:	861a                	mv	a2,t1
ffffffffc0200514:	103c                	addi	a5,sp,40
ffffffffc0200516:	0000b517          	auipc	a0,0xb
ffffffffc020051a:	3c250513          	addi	a0,a0,962 # ffffffffc020b8d8 <commands+0x68>
ffffffffc020051e:	ec06                	sd	ra,24(sp)
ffffffffc0200520:	f436                	sd	a3,40(sp)
ffffffffc0200522:	f83a                	sd	a4,48(sp)
ffffffffc0200524:	e0c2                	sd	a6,64(sp)
ffffffffc0200526:	e4c6                	sd	a7,72(sp)
ffffffffc0200528:	e43e                	sd	a5,8(sp)
ffffffffc020052a:	c7dff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020052e:	65a2                	ld	a1,8(sp)
ffffffffc0200530:	8522                	mv	a0,s0
ffffffffc0200532:	c4fff0ef          	jal	ra,ffffffffc0200180 <vcprintf>
ffffffffc0200536:	0000c517          	auipc	a0,0xc
ffffffffc020053a:	64250513          	addi	a0,a0,1602 # ffffffffc020cb78 <default_pmm_manager+0x610>
ffffffffc020053e:	c69ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200542:	60e2                	ld	ra,24(sp)
ffffffffc0200544:	6442                	ld	s0,16(sp)
ffffffffc0200546:	6161                	addi	sp,sp,80
ffffffffc0200548:	8082                	ret

ffffffffc020054a <clock_init>:
ffffffffc020054a:	02000793          	li	a5,32
ffffffffc020054e:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc0200552:	c0102573          	rdtime	a0
ffffffffc0200556:	67e1                	lui	a5,0x18
ffffffffc0200558:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc020055c:	953e                	add	a0,a0,a5
ffffffffc020055e:	4581                	li	a1,0
ffffffffc0200560:	4601                	li	a2,0
ffffffffc0200562:	4881                	li	a7,0
ffffffffc0200564:	00000073          	ecall
ffffffffc0200568:	0000b517          	auipc	a0,0xb
ffffffffc020056c:	39050513          	addi	a0,a0,912 # ffffffffc020b8f8 <commands+0x88>
ffffffffc0200570:	00096797          	auipc	a5,0x96
ffffffffc0200574:	3007b023          	sd	zero,768(a5) # ffffffffc0296870 <ticks>
ffffffffc0200578:	b13d                	j	ffffffffc02001a6 <cprintf>

ffffffffc020057a <clock_set_next_event>:
ffffffffc020057a:	c0102573          	rdtime	a0
ffffffffc020057e:	67e1                	lui	a5,0x18
ffffffffc0200580:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200584:	953e                	add	a0,a0,a5
ffffffffc0200586:	4581                	li	a1,0
ffffffffc0200588:	4601                	li	a2,0
ffffffffc020058a:	4881                	li	a7,0
ffffffffc020058c:	00000073          	ecall
ffffffffc0200590:	8082                	ret

ffffffffc0200592 <cons_init>:
ffffffffc0200592:	4501                	li	a0,0
ffffffffc0200594:	4581                	li	a1,0
ffffffffc0200596:	4601                	li	a2,0
ffffffffc0200598:	4889                	li	a7,2
ffffffffc020059a:	00000073          	ecall
ffffffffc020059e:	8082                	ret

ffffffffc02005a0 <cons_putc>:
ffffffffc02005a0:	1101                	addi	sp,sp,-32
ffffffffc02005a2:	ec06                	sd	ra,24(sp)
ffffffffc02005a4:	100027f3          	csrr	a5,sstatus
ffffffffc02005a8:	8b89                	andi	a5,a5,2
ffffffffc02005aa:	4701                	li	a4,0
ffffffffc02005ac:	ef95                	bnez	a5,ffffffffc02005e8 <cons_putc+0x48>
ffffffffc02005ae:	47a1                	li	a5,8
ffffffffc02005b0:	00f50b63          	beq	a0,a5,ffffffffc02005c6 <cons_putc+0x26>
ffffffffc02005b4:	4581                	li	a1,0
ffffffffc02005b6:	4601                	li	a2,0
ffffffffc02005b8:	4885                	li	a7,1
ffffffffc02005ba:	00000073          	ecall
ffffffffc02005be:	e315                	bnez	a4,ffffffffc02005e2 <cons_putc+0x42>
ffffffffc02005c0:	60e2                	ld	ra,24(sp)
ffffffffc02005c2:	6105                	addi	sp,sp,32
ffffffffc02005c4:	8082                	ret
ffffffffc02005c6:	4521                	li	a0,8
ffffffffc02005c8:	4581                	li	a1,0
ffffffffc02005ca:	4601                	li	a2,0
ffffffffc02005cc:	4885                	li	a7,1
ffffffffc02005ce:	00000073          	ecall
ffffffffc02005d2:	02000513          	li	a0,32
ffffffffc02005d6:	00000073          	ecall
ffffffffc02005da:	4521                	li	a0,8
ffffffffc02005dc:	00000073          	ecall
ffffffffc02005e0:	d365                	beqz	a4,ffffffffc02005c0 <cons_putc+0x20>
ffffffffc02005e2:	60e2                	ld	ra,24(sp)
ffffffffc02005e4:	6105                	addi	sp,sp,32
ffffffffc02005e6:	a559                	j	ffffffffc0200c6c <intr_enable>
ffffffffc02005e8:	e42a                	sd	a0,8(sp)
ffffffffc02005ea:	688000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02005ee:	6522                	ld	a0,8(sp)
ffffffffc02005f0:	4705                	li	a4,1
ffffffffc02005f2:	bf75                	j	ffffffffc02005ae <cons_putc+0xe>

ffffffffc02005f4 <cons_getc>:
ffffffffc02005f4:	1101                	addi	sp,sp,-32
ffffffffc02005f6:	ec06                	sd	ra,24(sp)
ffffffffc02005f8:	100027f3          	csrr	a5,sstatus
ffffffffc02005fc:	8b89                	andi	a5,a5,2
ffffffffc02005fe:	4801                	li	a6,0
ffffffffc0200600:	e3d5                	bnez	a5,ffffffffc02006a4 <cons_getc+0xb0>
ffffffffc0200602:	00091697          	auipc	a3,0x91
ffffffffc0200606:	e5e68693          	addi	a3,a3,-418 # ffffffffc0291460 <cons>
ffffffffc020060a:	07f00713          	li	a4,127
ffffffffc020060e:	20000313          	li	t1,512
ffffffffc0200612:	a021                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200614:	0ff57513          	zext.b	a0,a0
ffffffffc0200618:	ef91                	bnez	a5,ffffffffc0200634 <cons_getc+0x40>
ffffffffc020061a:	4501                	li	a0,0
ffffffffc020061c:	4581                	li	a1,0
ffffffffc020061e:	4601                	li	a2,0
ffffffffc0200620:	4889                	li	a7,2
ffffffffc0200622:	00000073          	ecall
ffffffffc0200626:	0005079b          	sext.w	a5,a0
ffffffffc020062a:	0207c763          	bltz	a5,ffffffffc0200658 <cons_getc+0x64>
ffffffffc020062e:	fee793e3          	bne	a5,a4,ffffffffc0200614 <cons_getc+0x20>
ffffffffc0200632:	4521                	li	a0,8
ffffffffc0200634:	2046a783          	lw	a5,516(a3)
ffffffffc0200638:	02079613          	slli	a2,a5,0x20
ffffffffc020063c:	9201                	srli	a2,a2,0x20
ffffffffc020063e:	2785                	addiw	a5,a5,1
ffffffffc0200640:	9636                	add	a2,a2,a3
ffffffffc0200642:	20f6a223          	sw	a5,516(a3)
ffffffffc0200646:	00a60023          	sb	a0,0(a2)
ffffffffc020064a:	fc6798e3          	bne	a5,t1,ffffffffc020061a <cons_getc+0x26>
ffffffffc020064e:	00091797          	auipc	a5,0x91
ffffffffc0200652:	0007ab23          	sw	zero,22(a5) # ffffffffc0291664 <cons+0x204>
ffffffffc0200656:	b7d1                	j	ffffffffc020061a <cons_getc+0x26>
ffffffffc0200658:	2006a783          	lw	a5,512(a3)
ffffffffc020065c:	2046a703          	lw	a4,516(a3)
ffffffffc0200660:	4501                	li	a0,0
ffffffffc0200662:	00f70f63          	beq	a4,a5,ffffffffc0200680 <cons_getc+0x8c>
ffffffffc0200666:	0017861b          	addiw	a2,a5,1
ffffffffc020066a:	1782                	slli	a5,a5,0x20
ffffffffc020066c:	9381                	srli	a5,a5,0x20
ffffffffc020066e:	97b6                	add	a5,a5,a3
ffffffffc0200670:	20c6a023          	sw	a2,512(a3)
ffffffffc0200674:	20000713          	li	a4,512
ffffffffc0200678:	0007c503          	lbu	a0,0(a5)
ffffffffc020067c:	00e60763          	beq	a2,a4,ffffffffc020068a <cons_getc+0x96>
ffffffffc0200680:	00081b63          	bnez	a6,ffffffffc0200696 <cons_getc+0xa2>
ffffffffc0200684:	60e2                	ld	ra,24(sp)
ffffffffc0200686:	6105                	addi	sp,sp,32
ffffffffc0200688:	8082                	ret
ffffffffc020068a:	00091797          	auipc	a5,0x91
ffffffffc020068e:	fc07ab23          	sw	zero,-42(a5) # ffffffffc0291660 <cons+0x200>
ffffffffc0200692:	fe0809e3          	beqz	a6,ffffffffc0200684 <cons_getc+0x90>
ffffffffc0200696:	e42a                	sd	a0,8(sp)
ffffffffc0200698:	5d4000ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020069c:	60e2                	ld	ra,24(sp)
ffffffffc020069e:	6522                	ld	a0,8(sp)
ffffffffc02006a0:	6105                	addi	sp,sp,32
ffffffffc02006a2:	8082                	ret
ffffffffc02006a4:	5ce000ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02006a8:	4805                	li	a6,1
ffffffffc02006aa:	bfa1                	j	ffffffffc0200602 <cons_getc+0xe>

ffffffffc02006ac <dtb_init>:
ffffffffc02006ac:	7119                	addi	sp,sp,-128
ffffffffc02006ae:	0000b517          	auipc	a0,0xb
ffffffffc02006b2:	26a50513          	addi	a0,a0,618 # ffffffffc020b918 <commands+0xa8>
ffffffffc02006b6:	fc86                	sd	ra,120(sp)
ffffffffc02006b8:	f8a2                	sd	s0,112(sp)
ffffffffc02006ba:	e8d2                	sd	s4,80(sp)
ffffffffc02006bc:	f4a6                	sd	s1,104(sp)
ffffffffc02006be:	f0ca                	sd	s2,96(sp)
ffffffffc02006c0:	ecce                	sd	s3,88(sp)
ffffffffc02006c2:	e4d6                	sd	s5,72(sp)
ffffffffc02006c4:	e0da                	sd	s6,64(sp)
ffffffffc02006c6:	fc5e                	sd	s7,56(sp)
ffffffffc02006c8:	f862                	sd	s8,48(sp)
ffffffffc02006ca:	f466                	sd	s9,40(sp)
ffffffffc02006cc:	f06a                	sd	s10,32(sp)
ffffffffc02006ce:	ec6e                	sd	s11,24(sp)
ffffffffc02006d0:	ad7ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006d4:	00014597          	auipc	a1,0x14
ffffffffc02006d8:	92c5b583          	ld	a1,-1748(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc02006dc:	0000b517          	auipc	a0,0xb
ffffffffc02006e0:	24c50513          	addi	a0,a0,588 # ffffffffc020b928 <commands+0xb8>
ffffffffc02006e4:	ac3ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006e8:	00014417          	auipc	s0,0x14
ffffffffc02006ec:	92040413          	addi	s0,s0,-1760 # ffffffffc0214008 <boot_dtb>
ffffffffc02006f0:	600c                	ld	a1,0(s0)
ffffffffc02006f2:	0000b517          	auipc	a0,0xb
ffffffffc02006f6:	24650513          	addi	a0,a0,582 # ffffffffc020b938 <commands+0xc8>
ffffffffc02006fa:	aadff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02006fe:	00043a03          	ld	s4,0(s0)
ffffffffc0200702:	0000b517          	auipc	a0,0xb
ffffffffc0200706:	24e50513          	addi	a0,a0,590 # ffffffffc020b950 <commands+0xe0>
ffffffffc020070a:	120a0463          	beqz	s4,ffffffffc0200832 <dtb_init+0x186>
ffffffffc020070e:	57f5                	li	a5,-3
ffffffffc0200710:	07fa                	slli	a5,a5,0x1e
ffffffffc0200712:	00fa0733          	add	a4,s4,a5
ffffffffc0200716:	431c                	lw	a5,0(a4)
ffffffffc0200718:	00ff0637          	lui	a2,0xff0
ffffffffc020071c:	6b41                	lui	s6,0x10
ffffffffc020071e:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200722:	0187969b          	slliw	a3,a5,0x18
ffffffffc0200726:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020072a:	0105959b          	slliw	a1,a1,0x10
ffffffffc020072e:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200732:	8df1                	and	a1,a1,a2
ffffffffc0200734:	8ec9                	or	a3,a3,a0
ffffffffc0200736:	0087979b          	slliw	a5,a5,0x8
ffffffffc020073a:	1b7d                	addi	s6,s6,-1
ffffffffc020073c:	0167f7b3          	and	a5,a5,s6
ffffffffc0200740:	8dd5                	or	a1,a1,a3
ffffffffc0200742:	8ddd                	or	a1,a1,a5
ffffffffc0200744:	d00e07b7          	lui	a5,0xd00e0
ffffffffc0200748:	2581                	sext.w	a1,a1
ffffffffc020074a:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc020074e:	10f59163          	bne	a1,a5,ffffffffc0200850 <dtb_init+0x1a4>
ffffffffc0200752:	471c                	lw	a5,8(a4)
ffffffffc0200754:	4754                	lw	a3,12(a4)
ffffffffc0200756:	4c81                	li	s9,0
ffffffffc0200758:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020075c:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200760:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200764:	0186d89b          	srliw	a7,a3,0x18
ffffffffc0200768:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020076c:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200770:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200774:	0106d69b          	srliw	a3,a3,0x10
ffffffffc0200778:	0105959b          	slliw	a1,a1,0x10
ffffffffc020077c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200780:	8d71                	and	a0,a0,a2
ffffffffc0200782:	01146433          	or	s0,s0,a7
ffffffffc0200786:	0086969b          	slliw	a3,a3,0x8
ffffffffc020078a:	010a6a33          	or	s4,s4,a6
ffffffffc020078e:	8e6d                	and	a2,a2,a1
ffffffffc0200790:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200794:	8c49                	or	s0,s0,a0
ffffffffc0200796:	0166f6b3          	and	a3,a3,s6
ffffffffc020079a:	00ca6a33          	or	s4,s4,a2
ffffffffc020079e:	0167f7b3          	and	a5,a5,s6
ffffffffc02007a2:	8c55                	or	s0,s0,a3
ffffffffc02007a4:	00fa6a33          	or	s4,s4,a5
ffffffffc02007a8:	1402                	slli	s0,s0,0x20
ffffffffc02007aa:	1a02                	slli	s4,s4,0x20
ffffffffc02007ac:	9001                	srli	s0,s0,0x20
ffffffffc02007ae:	020a5a13          	srli	s4,s4,0x20
ffffffffc02007b2:	943a                	add	s0,s0,a4
ffffffffc02007b4:	9a3a                	add	s4,s4,a4
ffffffffc02007b6:	00ff0c37          	lui	s8,0xff0
ffffffffc02007ba:	4b8d                	li	s7,3
ffffffffc02007bc:	0000b917          	auipc	s2,0xb
ffffffffc02007c0:	1e490913          	addi	s2,s2,484 # ffffffffc020b9a0 <commands+0x130>
ffffffffc02007c4:	49bd                	li	s3,15
ffffffffc02007c6:	4d91                	li	s11,4
ffffffffc02007c8:	4d05                	li	s10,1
ffffffffc02007ca:	0000b497          	auipc	s1,0xb
ffffffffc02007ce:	1ce48493          	addi	s1,s1,462 # ffffffffc020b998 <commands+0x128>
ffffffffc02007d2:	000a2703          	lw	a4,0(s4)
ffffffffc02007d6:	004a0a93          	addi	s5,s4,4
ffffffffc02007da:	0087569b          	srliw	a3,a4,0x8
ffffffffc02007de:	0187179b          	slliw	a5,a4,0x18
ffffffffc02007e2:	0187561b          	srliw	a2,a4,0x18
ffffffffc02007e6:	0106969b          	slliw	a3,a3,0x10
ffffffffc02007ea:	0107571b          	srliw	a4,a4,0x10
ffffffffc02007ee:	8fd1                	or	a5,a5,a2
ffffffffc02007f0:	0186f6b3          	and	a3,a3,s8
ffffffffc02007f4:	0087171b          	slliw	a4,a4,0x8
ffffffffc02007f8:	8fd5                	or	a5,a5,a3
ffffffffc02007fa:	00eb7733          	and	a4,s6,a4
ffffffffc02007fe:	8fd9                	or	a5,a5,a4
ffffffffc0200800:	2781                	sext.w	a5,a5
ffffffffc0200802:	09778c63          	beq	a5,s7,ffffffffc020089a <dtb_init+0x1ee>
ffffffffc0200806:	00fbea63          	bltu	s7,a5,ffffffffc020081a <dtb_init+0x16e>
ffffffffc020080a:	07a78663          	beq	a5,s10,ffffffffc0200876 <dtb_init+0x1ca>
ffffffffc020080e:	4709                	li	a4,2
ffffffffc0200810:	00e79763          	bne	a5,a4,ffffffffc020081e <dtb_init+0x172>
ffffffffc0200814:	4c81                	li	s9,0
ffffffffc0200816:	8a56                	mv	s4,s5
ffffffffc0200818:	bf6d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020081a:	ffb78ee3          	beq	a5,s11,ffffffffc0200816 <dtb_init+0x16a>
ffffffffc020081e:	0000b517          	auipc	a0,0xb
ffffffffc0200822:	1fa50513          	addi	a0,a0,506 # ffffffffc020ba18 <commands+0x1a8>
ffffffffc0200826:	981ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020082a:	0000b517          	auipc	a0,0xb
ffffffffc020082e:	22650513          	addi	a0,a0,550 # ffffffffc020ba50 <commands+0x1e0>
ffffffffc0200832:	7446                	ld	s0,112(sp)
ffffffffc0200834:	70e6                	ld	ra,120(sp)
ffffffffc0200836:	74a6                	ld	s1,104(sp)
ffffffffc0200838:	7906                	ld	s2,96(sp)
ffffffffc020083a:	69e6                	ld	s3,88(sp)
ffffffffc020083c:	6a46                	ld	s4,80(sp)
ffffffffc020083e:	6aa6                	ld	s5,72(sp)
ffffffffc0200840:	6b06                	ld	s6,64(sp)
ffffffffc0200842:	7be2                	ld	s7,56(sp)
ffffffffc0200844:	7c42                	ld	s8,48(sp)
ffffffffc0200846:	7ca2                	ld	s9,40(sp)
ffffffffc0200848:	7d02                	ld	s10,32(sp)
ffffffffc020084a:	6de2                	ld	s11,24(sp)
ffffffffc020084c:	6109                	addi	sp,sp,128
ffffffffc020084e:	baa1                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200850:	7446                	ld	s0,112(sp)
ffffffffc0200852:	70e6                	ld	ra,120(sp)
ffffffffc0200854:	74a6                	ld	s1,104(sp)
ffffffffc0200856:	7906                	ld	s2,96(sp)
ffffffffc0200858:	69e6                	ld	s3,88(sp)
ffffffffc020085a:	6a46                	ld	s4,80(sp)
ffffffffc020085c:	6aa6                	ld	s5,72(sp)
ffffffffc020085e:	6b06                	ld	s6,64(sp)
ffffffffc0200860:	7be2                	ld	s7,56(sp)
ffffffffc0200862:	7c42                	ld	s8,48(sp)
ffffffffc0200864:	7ca2                	ld	s9,40(sp)
ffffffffc0200866:	7d02                	ld	s10,32(sp)
ffffffffc0200868:	6de2                	ld	s11,24(sp)
ffffffffc020086a:	0000b517          	auipc	a0,0xb
ffffffffc020086e:	10650513          	addi	a0,a0,262 # ffffffffc020b970 <commands+0x100>
ffffffffc0200872:	6109                	addi	sp,sp,128
ffffffffc0200874:	ba0d                	j	ffffffffc02001a6 <cprintf>
ffffffffc0200876:	8556                	mv	a0,s5
ffffffffc0200878:	4810a0ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc020087c:	8a2a                	mv	s4,a0
ffffffffc020087e:	4619                	li	a2,6
ffffffffc0200880:	85a6                	mv	a1,s1
ffffffffc0200882:	8556                	mv	a0,s5
ffffffffc0200884:	2a01                	sext.w	s4,s4
ffffffffc0200886:	4d90a0ef          	jal	ra,ffffffffc020b55e <strncmp>
ffffffffc020088a:	e111                	bnez	a0,ffffffffc020088e <dtb_init+0x1e2>
ffffffffc020088c:	4c85                	li	s9,1
ffffffffc020088e:	0a91                	addi	s5,s5,4
ffffffffc0200890:	9ad2                	add	s5,s5,s4
ffffffffc0200892:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200896:	8a56                	mv	s4,s5
ffffffffc0200898:	bf2d                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc020089a:	004a2783          	lw	a5,4(s4)
ffffffffc020089e:	00ca0693          	addi	a3,s4,12
ffffffffc02008a2:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02008a6:	01879a9b          	slliw	s5,a5,0x18
ffffffffc02008aa:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008ae:	0107171b          	slliw	a4,a4,0x10
ffffffffc02008b2:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02008b6:	00caeab3          	or	s5,s5,a2
ffffffffc02008ba:	01877733          	and	a4,a4,s8
ffffffffc02008be:	0087979b          	slliw	a5,a5,0x8
ffffffffc02008c2:	00eaeab3          	or	s5,s5,a4
ffffffffc02008c6:	00fb77b3          	and	a5,s6,a5
ffffffffc02008ca:	00faeab3          	or	s5,s5,a5
ffffffffc02008ce:	2a81                	sext.w	s5,s5
ffffffffc02008d0:	000c9c63          	bnez	s9,ffffffffc02008e8 <dtb_init+0x23c>
ffffffffc02008d4:	1a82                	slli	s5,s5,0x20
ffffffffc02008d6:	00368793          	addi	a5,a3,3
ffffffffc02008da:	020ada93          	srli	s5,s5,0x20
ffffffffc02008de:	9abe                	add	s5,s5,a5
ffffffffc02008e0:	ffcafa93          	andi	s5,s5,-4
ffffffffc02008e4:	8a56                	mv	s4,s5
ffffffffc02008e6:	b5f5                	j	ffffffffc02007d2 <dtb_init+0x126>
ffffffffc02008e8:	008a2783          	lw	a5,8(s4)
ffffffffc02008ec:	85ca                	mv	a1,s2
ffffffffc02008ee:	e436                	sd	a3,8(sp)
ffffffffc02008f0:	0087d51b          	srliw	a0,a5,0x8
ffffffffc02008f4:	0187d61b          	srliw	a2,a5,0x18
ffffffffc02008f8:	0187971b          	slliw	a4,a5,0x18
ffffffffc02008fc:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200900:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200904:	8f51                	or	a4,a4,a2
ffffffffc0200906:	01857533          	and	a0,a0,s8
ffffffffc020090a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020090e:	8d59                	or	a0,a0,a4
ffffffffc0200910:	00fb77b3          	and	a5,s6,a5
ffffffffc0200914:	8d5d                	or	a0,a0,a5
ffffffffc0200916:	1502                	slli	a0,a0,0x20
ffffffffc0200918:	9101                	srli	a0,a0,0x20
ffffffffc020091a:	9522                	add	a0,a0,s0
ffffffffc020091c:	4250a0ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc0200920:	66a2                	ld	a3,8(sp)
ffffffffc0200922:	f94d                	bnez	a0,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200924:	fb59f8e3          	bgeu	s3,s5,ffffffffc02008d4 <dtb_init+0x228>
ffffffffc0200928:	00ca3783          	ld	a5,12(s4)
ffffffffc020092c:	014a3703          	ld	a4,20(s4)
ffffffffc0200930:	0000b517          	auipc	a0,0xb
ffffffffc0200934:	07850513          	addi	a0,a0,120 # ffffffffc020b9a8 <commands+0x138>
ffffffffc0200938:	4207d613          	srai	a2,a5,0x20
ffffffffc020093c:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200940:	42075593          	srai	a1,a4,0x20
ffffffffc0200944:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200948:	0186581b          	srliw	a6,a2,0x18
ffffffffc020094c:	0187941b          	slliw	s0,a5,0x18
ffffffffc0200950:	0107d89b          	srliw	a7,a5,0x10
ffffffffc0200954:	0187d693          	srli	a3,a5,0x18
ffffffffc0200958:	01861f1b          	slliw	t5,a2,0x18
ffffffffc020095c:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200960:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200964:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200968:	010f6f33          	or	t5,t5,a6
ffffffffc020096c:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200970:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200974:	01837333          	and	t1,t1,s8
ffffffffc0200978:	01c46433          	or	s0,s0,t3
ffffffffc020097c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200980:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200984:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200988:	0107581b          	srliw	a6,a4,0x10
ffffffffc020098c:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200990:	8361                	srli	a4,a4,0x18
ffffffffc0200992:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200996:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020099a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020099e:	00cb7633          	and	a2,s6,a2
ffffffffc02009a2:	0088181b          	slliw	a6,a6,0x8
ffffffffc02009a6:	0085959b          	slliw	a1,a1,0x8
ffffffffc02009aa:	00646433          	or	s0,s0,t1
ffffffffc02009ae:	0187f7b3          	and	a5,a5,s8
ffffffffc02009b2:	01fe6333          	or	t1,t3,t6
ffffffffc02009b6:	01877c33          	and	s8,a4,s8
ffffffffc02009ba:	0088989b          	slliw	a7,a7,0x8
ffffffffc02009be:	011b78b3          	and	a7,s6,a7
ffffffffc02009c2:	005eeeb3          	or	t4,t4,t0
ffffffffc02009c6:	00c6e733          	or	a4,a3,a2
ffffffffc02009ca:	006c6c33          	or	s8,s8,t1
ffffffffc02009ce:	010b76b3          	and	a3,s6,a6
ffffffffc02009d2:	00bb7b33          	and	s6,s6,a1
ffffffffc02009d6:	01d7e7b3          	or	a5,a5,t4
ffffffffc02009da:	016c6b33          	or	s6,s8,s6
ffffffffc02009de:	01146433          	or	s0,s0,a7
ffffffffc02009e2:	8fd5                	or	a5,a5,a3
ffffffffc02009e4:	1702                	slli	a4,a4,0x20
ffffffffc02009e6:	1b02                	slli	s6,s6,0x20
ffffffffc02009e8:	1782                	slli	a5,a5,0x20
ffffffffc02009ea:	9301                	srli	a4,a4,0x20
ffffffffc02009ec:	1402                	slli	s0,s0,0x20
ffffffffc02009ee:	020b5b13          	srli	s6,s6,0x20
ffffffffc02009f2:	0167eb33          	or	s6,a5,s6
ffffffffc02009f6:	8c59                	or	s0,s0,a4
ffffffffc02009f8:	faeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02009fc:	85a2                	mv	a1,s0
ffffffffc02009fe:	0000b517          	auipc	a0,0xb
ffffffffc0200a02:	fca50513          	addi	a0,a0,-54 # ffffffffc020b9c8 <commands+0x158>
ffffffffc0200a06:	fa0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a0a:	014b5613          	srli	a2,s6,0x14
ffffffffc0200a0e:	85da                	mv	a1,s6
ffffffffc0200a10:	0000b517          	auipc	a0,0xb
ffffffffc0200a14:	fd050513          	addi	a0,a0,-48 # ffffffffc020b9e0 <commands+0x170>
ffffffffc0200a18:	f8eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a1c:	008b05b3          	add	a1,s6,s0
ffffffffc0200a20:	15fd                	addi	a1,a1,-1
ffffffffc0200a22:	0000b517          	auipc	a0,0xb
ffffffffc0200a26:	fde50513          	addi	a0,a0,-34 # ffffffffc020ba00 <commands+0x190>
ffffffffc0200a2a:	f7cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200a2e:	0000b517          	auipc	a0,0xb
ffffffffc0200a32:	02250513          	addi	a0,a0,34 # ffffffffc020ba50 <commands+0x1e0>
ffffffffc0200a36:	00096797          	auipc	a5,0x96
ffffffffc0200a3a:	e487b123          	sd	s0,-446(a5) # ffffffffc0296878 <memory_base>
ffffffffc0200a3e:	00096797          	auipc	a5,0x96
ffffffffc0200a42:	e567b123          	sd	s6,-446(a5) # ffffffffc0296880 <memory_size>
ffffffffc0200a46:	b3f5                	j	ffffffffc0200832 <dtb_init+0x186>

ffffffffc0200a48 <get_memory_base>:
ffffffffc0200a48:	00096517          	auipc	a0,0x96
ffffffffc0200a4c:	e3053503          	ld	a0,-464(a0) # ffffffffc0296878 <memory_base>
ffffffffc0200a50:	8082                	ret

ffffffffc0200a52 <get_memory_size>:
ffffffffc0200a52:	00096517          	auipc	a0,0x96
ffffffffc0200a56:	e2e53503          	ld	a0,-466(a0) # ffffffffc0296880 <memory_size>
ffffffffc0200a5a:	8082                	ret

ffffffffc0200a5c <ide_init>:
ffffffffc0200a5c:	1141                	addi	sp,sp,-16
ffffffffc0200a5e:	00091597          	auipc	a1,0x91
ffffffffc0200a62:	c5a58593          	addi	a1,a1,-934 # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a66:	4505                	li	a0,1
ffffffffc0200a68:	e022                	sd	s0,0(sp)
ffffffffc0200a6a:	00091797          	auipc	a5,0x91
ffffffffc0200a6e:	be07af23          	sw	zero,-1026(a5) # ffffffffc0291668 <ide_devices>
ffffffffc0200a72:	00091797          	auipc	a5,0x91
ffffffffc0200a76:	c407a323          	sw	zero,-954(a5) # ffffffffc02916b8 <ide_devices+0x50>
ffffffffc0200a7a:	00091797          	auipc	a5,0x91
ffffffffc0200a7e:	c807a723          	sw	zero,-882(a5) # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200a82:	00091797          	auipc	a5,0x91
ffffffffc0200a86:	cc07ab23          	sw	zero,-810(a5) # ffffffffc0291758 <ide_devices+0xf0>
ffffffffc0200a8a:	e406                	sd	ra,8(sp)
ffffffffc0200a8c:	00091417          	auipc	s0,0x91
ffffffffc0200a90:	bdc40413          	addi	s0,s0,-1060 # ffffffffc0291668 <ide_devices>
ffffffffc0200a94:	23a000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200a98:	483c                	lw	a5,80(s0)
ffffffffc0200a9a:	cf99                	beqz	a5,ffffffffc0200ab8 <ide_init+0x5c>
ffffffffc0200a9c:	00091597          	auipc	a1,0x91
ffffffffc0200aa0:	c6c58593          	addi	a1,a1,-916 # ffffffffc0291708 <ide_devices+0xa0>
ffffffffc0200aa4:	4509                	li	a0,2
ffffffffc0200aa6:	228000ef          	jal	ra,ffffffffc0200cce <ramdisk_init>
ffffffffc0200aaa:	0a042783          	lw	a5,160(s0)
ffffffffc0200aae:	c785                	beqz	a5,ffffffffc0200ad6 <ide_init+0x7a>
ffffffffc0200ab0:	60a2                	ld	ra,8(sp)
ffffffffc0200ab2:	6402                	ld	s0,0(sp)
ffffffffc0200ab4:	0141                	addi	sp,sp,16
ffffffffc0200ab6:	8082                	ret
ffffffffc0200ab8:	0000b697          	auipc	a3,0xb
ffffffffc0200abc:	fb068693          	addi	a3,a3,-80 # ffffffffc020ba68 <commands+0x1f8>
ffffffffc0200ac0:	0000b617          	auipc	a2,0xb
ffffffffc0200ac4:	fc060613          	addi	a2,a2,-64 # ffffffffc020ba80 <commands+0x210>
ffffffffc0200ac8:	45c5                	li	a1,17
ffffffffc0200aca:	0000b517          	auipc	a0,0xb
ffffffffc0200ace:	fce50513          	addi	a0,a0,-50 # ffffffffc020ba98 <commands+0x228>
ffffffffc0200ad2:	9cdff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200ad6:	0000b697          	auipc	a3,0xb
ffffffffc0200ada:	fda68693          	addi	a3,a3,-38 # ffffffffc020bab0 <commands+0x240>
ffffffffc0200ade:	0000b617          	auipc	a2,0xb
ffffffffc0200ae2:	fa260613          	addi	a2,a2,-94 # ffffffffc020ba80 <commands+0x210>
ffffffffc0200ae6:	45d1                	li	a1,20
ffffffffc0200ae8:	0000b517          	auipc	a0,0xb
ffffffffc0200aec:	fb050513          	addi	a0,a0,-80 # ffffffffc020ba98 <commands+0x228>
ffffffffc0200af0:	9afff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200af4 <ide_device_valid>:
ffffffffc0200af4:	478d                	li	a5,3
ffffffffc0200af6:	00a7ef63          	bltu	a5,a0,ffffffffc0200b14 <ide_device_valid+0x20>
ffffffffc0200afa:	00251793          	slli	a5,a0,0x2
ffffffffc0200afe:	953e                	add	a0,a0,a5
ffffffffc0200b00:	0512                	slli	a0,a0,0x4
ffffffffc0200b02:	00091797          	auipc	a5,0x91
ffffffffc0200b06:	b6678793          	addi	a5,a5,-1178 # ffffffffc0291668 <ide_devices>
ffffffffc0200b0a:	953e                	add	a0,a0,a5
ffffffffc0200b0c:	4108                	lw	a0,0(a0)
ffffffffc0200b0e:	00a03533          	snez	a0,a0
ffffffffc0200b12:	8082                	ret
ffffffffc0200b14:	4501                	li	a0,0
ffffffffc0200b16:	8082                	ret

ffffffffc0200b18 <ide_device_size>:
ffffffffc0200b18:	478d                	li	a5,3
ffffffffc0200b1a:	02a7e163          	bltu	a5,a0,ffffffffc0200b3c <ide_device_size+0x24>
ffffffffc0200b1e:	00251793          	slli	a5,a0,0x2
ffffffffc0200b22:	953e                	add	a0,a0,a5
ffffffffc0200b24:	0512                	slli	a0,a0,0x4
ffffffffc0200b26:	00091797          	auipc	a5,0x91
ffffffffc0200b2a:	b4278793          	addi	a5,a5,-1214 # ffffffffc0291668 <ide_devices>
ffffffffc0200b2e:	97aa                	add	a5,a5,a0
ffffffffc0200b30:	4398                	lw	a4,0(a5)
ffffffffc0200b32:	4501                	li	a0,0
ffffffffc0200b34:	c709                	beqz	a4,ffffffffc0200b3e <ide_device_size+0x26>
ffffffffc0200b36:	0087e503          	lwu	a0,8(a5)
ffffffffc0200b3a:	8082                	ret
ffffffffc0200b3c:	4501                	li	a0,0
ffffffffc0200b3e:	8082                	ret

ffffffffc0200b40 <ide_read_secs>:
ffffffffc0200b40:	1141                	addi	sp,sp,-16
ffffffffc0200b42:	e406                	sd	ra,8(sp)
ffffffffc0200b44:	08000793          	li	a5,128
ffffffffc0200b48:	04d7e763          	bltu	a5,a3,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b4c:	478d                	li	a5,3
ffffffffc0200b4e:	0005081b          	sext.w	a6,a0
ffffffffc0200b52:	04a7e263          	bltu	a5,a0,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b56:	00281793          	slli	a5,a6,0x2
ffffffffc0200b5a:	97c2                	add	a5,a5,a6
ffffffffc0200b5c:	0792                	slli	a5,a5,0x4
ffffffffc0200b5e:	00091817          	auipc	a6,0x91
ffffffffc0200b62:	b0a80813          	addi	a6,a6,-1270 # ffffffffc0291668 <ide_devices>
ffffffffc0200b66:	97c2                	add	a5,a5,a6
ffffffffc0200b68:	0007a883          	lw	a7,0(a5)
ffffffffc0200b6c:	02088563          	beqz	a7,ffffffffc0200b96 <ide_read_secs+0x56>
ffffffffc0200b70:	100008b7          	lui	a7,0x10000
ffffffffc0200b74:	0515f163          	bgeu	a1,a7,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b78:	1582                	slli	a1,a1,0x20
ffffffffc0200b7a:	9181                	srli	a1,a1,0x20
ffffffffc0200b7c:	00d58733          	add	a4,a1,a3
ffffffffc0200b80:	02e8eb63          	bltu	a7,a4,ffffffffc0200bb6 <ide_read_secs+0x76>
ffffffffc0200b84:	00251713          	slli	a4,a0,0x2
ffffffffc0200b88:	60a2                	ld	ra,8(sp)
ffffffffc0200b8a:	63bc                	ld	a5,64(a5)
ffffffffc0200b8c:	953a                	add	a0,a0,a4
ffffffffc0200b8e:	0512                	slli	a0,a0,0x4
ffffffffc0200b90:	9542                	add	a0,a0,a6
ffffffffc0200b92:	0141                	addi	sp,sp,16
ffffffffc0200b94:	8782                	jr	a5
ffffffffc0200b96:	0000b697          	auipc	a3,0xb
ffffffffc0200b9a:	f3268693          	addi	a3,a3,-206 # ffffffffc020bac8 <commands+0x258>
ffffffffc0200b9e:	0000b617          	auipc	a2,0xb
ffffffffc0200ba2:	ee260613          	addi	a2,a2,-286 # ffffffffc020ba80 <commands+0x210>
ffffffffc0200ba6:	02200593          	li	a1,34
ffffffffc0200baa:	0000b517          	auipc	a0,0xb
ffffffffc0200bae:	eee50513          	addi	a0,a0,-274 # ffffffffc020ba98 <commands+0x228>
ffffffffc0200bb2:	8edff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200bb6:	0000b697          	auipc	a3,0xb
ffffffffc0200bba:	f3a68693          	addi	a3,a3,-198 # ffffffffc020baf0 <commands+0x280>
ffffffffc0200bbe:	0000b617          	auipc	a2,0xb
ffffffffc0200bc2:	ec260613          	addi	a2,a2,-318 # ffffffffc020ba80 <commands+0x210>
ffffffffc0200bc6:	02300593          	li	a1,35
ffffffffc0200bca:	0000b517          	auipc	a0,0xb
ffffffffc0200bce:	ece50513          	addi	a0,a0,-306 # ffffffffc020ba98 <commands+0x228>
ffffffffc0200bd2:	8cdff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200bd6 <ide_write_secs>:
ffffffffc0200bd6:	1141                	addi	sp,sp,-16
ffffffffc0200bd8:	e406                	sd	ra,8(sp)
ffffffffc0200bda:	08000793          	li	a5,128
ffffffffc0200bde:	04d7e763          	bltu	a5,a3,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200be2:	478d                	li	a5,3
ffffffffc0200be4:	0005081b          	sext.w	a6,a0
ffffffffc0200be8:	04a7e263          	bltu	a5,a0,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200bec:	00281793          	slli	a5,a6,0x2
ffffffffc0200bf0:	97c2                	add	a5,a5,a6
ffffffffc0200bf2:	0792                	slli	a5,a5,0x4
ffffffffc0200bf4:	00091817          	auipc	a6,0x91
ffffffffc0200bf8:	a7480813          	addi	a6,a6,-1420 # ffffffffc0291668 <ide_devices>
ffffffffc0200bfc:	97c2                	add	a5,a5,a6
ffffffffc0200bfe:	0007a883          	lw	a7,0(a5)
ffffffffc0200c02:	02088563          	beqz	a7,ffffffffc0200c2c <ide_write_secs+0x56>
ffffffffc0200c06:	100008b7          	lui	a7,0x10000
ffffffffc0200c0a:	0515f163          	bgeu	a1,a7,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c0e:	1582                	slli	a1,a1,0x20
ffffffffc0200c10:	9181                	srli	a1,a1,0x20
ffffffffc0200c12:	00d58733          	add	a4,a1,a3
ffffffffc0200c16:	02e8eb63          	bltu	a7,a4,ffffffffc0200c4c <ide_write_secs+0x76>
ffffffffc0200c1a:	00251713          	slli	a4,a0,0x2
ffffffffc0200c1e:	60a2                	ld	ra,8(sp)
ffffffffc0200c20:	67bc                	ld	a5,72(a5)
ffffffffc0200c22:	953a                	add	a0,a0,a4
ffffffffc0200c24:	0512                	slli	a0,a0,0x4
ffffffffc0200c26:	9542                	add	a0,a0,a6
ffffffffc0200c28:	0141                	addi	sp,sp,16
ffffffffc0200c2a:	8782                	jr	a5
ffffffffc0200c2c:	0000b697          	auipc	a3,0xb
ffffffffc0200c30:	e9c68693          	addi	a3,a3,-356 # ffffffffc020bac8 <commands+0x258>
ffffffffc0200c34:	0000b617          	auipc	a2,0xb
ffffffffc0200c38:	e4c60613          	addi	a2,a2,-436 # ffffffffc020ba80 <commands+0x210>
ffffffffc0200c3c:	02900593          	li	a1,41
ffffffffc0200c40:	0000b517          	auipc	a0,0xb
ffffffffc0200c44:	e5850513          	addi	a0,a0,-424 # ffffffffc020ba98 <commands+0x228>
ffffffffc0200c48:	857ff0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0200c4c:	0000b697          	auipc	a3,0xb
ffffffffc0200c50:	ea468693          	addi	a3,a3,-348 # ffffffffc020baf0 <commands+0x280>
ffffffffc0200c54:	0000b617          	auipc	a2,0xb
ffffffffc0200c58:	e2c60613          	addi	a2,a2,-468 # ffffffffc020ba80 <commands+0x210>
ffffffffc0200c5c:	02a00593          	li	a1,42
ffffffffc0200c60:	0000b517          	auipc	a0,0xb
ffffffffc0200c64:	e3850513          	addi	a0,a0,-456 # ffffffffc020ba98 <commands+0x228>
ffffffffc0200c68:	837ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200c6c <intr_enable>:
ffffffffc0200c6c:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200c70:	8082                	ret

ffffffffc0200c72 <intr_disable>:
ffffffffc0200c72:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200c76:	8082                	ret

ffffffffc0200c78 <pic_init>:
ffffffffc0200c78:	8082                	ret

ffffffffc0200c7a <ramdisk_write>:
ffffffffc0200c7a:	00856703          	lwu	a4,8(a0)
ffffffffc0200c7e:	1141                	addi	sp,sp,-16
ffffffffc0200c80:	e406                	sd	ra,8(sp)
ffffffffc0200c82:	8f0d                	sub	a4,a4,a1
ffffffffc0200c84:	87ae                	mv	a5,a1
ffffffffc0200c86:	85b2                	mv	a1,a2
ffffffffc0200c88:	00e6f363          	bgeu	a3,a4,ffffffffc0200c8e <ramdisk_write+0x14>
ffffffffc0200c8c:	8736                	mv	a4,a3
ffffffffc0200c8e:	6908                	ld	a0,16(a0)
ffffffffc0200c90:	07a6                	slli	a5,a5,0x9
ffffffffc0200c92:	00971613          	slli	a2,a4,0x9
ffffffffc0200c96:	953e                	add	a0,a0,a5
ffffffffc0200c98:	1550a0ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc0200c9c:	60a2                	ld	ra,8(sp)
ffffffffc0200c9e:	4501                	li	a0,0
ffffffffc0200ca0:	0141                	addi	sp,sp,16
ffffffffc0200ca2:	8082                	ret

ffffffffc0200ca4 <ramdisk_read>:
ffffffffc0200ca4:	00856783          	lwu	a5,8(a0)
ffffffffc0200ca8:	1141                	addi	sp,sp,-16
ffffffffc0200caa:	e406                	sd	ra,8(sp)
ffffffffc0200cac:	8f8d                	sub	a5,a5,a1
ffffffffc0200cae:	872a                	mv	a4,a0
ffffffffc0200cb0:	8532                	mv	a0,a2
ffffffffc0200cb2:	00f6f363          	bgeu	a3,a5,ffffffffc0200cb8 <ramdisk_read+0x14>
ffffffffc0200cb6:	87b6                	mv	a5,a3
ffffffffc0200cb8:	6b18                	ld	a4,16(a4)
ffffffffc0200cba:	05a6                	slli	a1,a1,0x9
ffffffffc0200cbc:	00979613          	slli	a2,a5,0x9
ffffffffc0200cc0:	95ba                	add	a1,a1,a4
ffffffffc0200cc2:	12b0a0ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc0200cc6:	60a2                	ld	ra,8(sp)
ffffffffc0200cc8:	4501                	li	a0,0
ffffffffc0200cca:	0141                	addi	sp,sp,16
ffffffffc0200ccc:	8082                	ret

ffffffffc0200cce <ramdisk_init>:
ffffffffc0200cce:	1101                	addi	sp,sp,-32
ffffffffc0200cd0:	e822                	sd	s0,16(sp)
ffffffffc0200cd2:	842e                	mv	s0,a1
ffffffffc0200cd4:	e426                	sd	s1,8(sp)
ffffffffc0200cd6:	05000613          	li	a2,80
ffffffffc0200cda:	84aa                	mv	s1,a0
ffffffffc0200cdc:	4581                	li	a1,0
ffffffffc0200cde:	8522                	mv	a0,s0
ffffffffc0200ce0:	ec06                	sd	ra,24(sp)
ffffffffc0200ce2:	e04a                	sd	s2,0(sp)
ffffffffc0200ce4:	0b70a0ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0200ce8:	4785                	li	a5,1
ffffffffc0200cea:	06f48b63          	beq	s1,a5,ffffffffc0200d60 <ramdisk_init+0x92>
ffffffffc0200cee:	4789                	li	a5,2
ffffffffc0200cf0:	00090617          	auipc	a2,0x90
ffffffffc0200cf4:	32060613          	addi	a2,a2,800 # ffffffffc0291010 <arena>
ffffffffc0200cf8:	0001b917          	auipc	s2,0x1b
ffffffffc0200cfc:	01890913          	addi	s2,s2,24 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d00:	08f49563          	bne	s1,a5,ffffffffc0200d8a <ramdisk_init+0xbc>
ffffffffc0200d04:	06c90863          	beq	s2,a2,ffffffffc0200d74 <ramdisk_init+0xa6>
ffffffffc0200d08:	412604b3          	sub	s1,a2,s2
ffffffffc0200d0c:	86a6                	mv	a3,s1
ffffffffc0200d0e:	85ca                	mv	a1,s2
ffffffffc0200d10:	167d                	addi	a2,a2,-1
ffffffffc0200d12:	0000b517          	auipc	a0,0xb
ffffffffc0200d16:	e3650513          	addi	a0,a0,-458 # ffffffffc020bb48 <commands+0x2d8>
ffffffffc0200d1a:	c8cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200d1e:	57fd                	li	a5,-1
ffffffffc0200d20:	1782                	slli	a5,a5,0x20
ffffffffc0200d22:	0785                	addi	a5,a5,1
ffffffffc0200d24:	0094d49b          	srliw	s1,s1,0x9
ffffffffc0200d28:	e01c                	sd	a5,0(s0)
ffffffffc0200d2a:	c404                	sw	s1,8(s0)
ffffffffc0200d2c:	01243823          	sd	s2,16(s0)
ffffffffc0200d30:	02040513          	addi	a0,s0,32
ffffffffc0200d34:	0000b597          	auipc	a1,0xb
ffffffffc0200d38:	e6c58593          	addi	a1,a1,-404 # ffffffffc020bba0 <commands+0x330>
ffffffffc0200d3c:	7f20a0ef          	jal	ra,ffffffffc020b52e <strcpy>
ffffffffc0200d40:	00000797          	auipc	a5,0x0
ffffffffc0200d44:	f6478793          	addi	a5,a5,-156 # ffffffffc0200ca4 <ramdisk_read>
ffffffffc0200d48:	e03c                	sd	a5,64(s0)
ffffffffc0200d4a:	00000797          	auipc	a5,0x0
ffffffffc0200d4e:	f3078793          	addi	a5,a5,-208 # ffffffffc0200c7a <ramdisk_write>
ffffffffc0200d52:	60e2                	ld	ra,24(sp)
ffffffffc0200d54:	e43c                	sd	a5,72(s0)
ffffffffc0200d56:	6442                	ld	s0,16(sp)
ffffffffc0200d58:	64a2                	ld	s1,8(sp)
ffffffffc0200d5a:	6902                	ld	s2,0(sp)
ffffffffc0200d5c:	6105                	addi	sp,sp,32
ffffffffc0200d5e:	8082                	ret
ffffffffc0200d60:	0001b617          	auipc	a2,0x1b
ffffffffc0200d64:	fb060613          	addi	a2,a2,-80 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc0200d68:	00013917          	auipc	s2,0x13
ffffffffc0200d6c:	2a890913          	addi	s2,s2,680 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200d70:	f8c91ce3          	bne	s2,a2,ffffffffc0200d08 <ramdisk_init+0x3a>
ffffffffc0200d74:	6442                	ld	s0,16(sp)
ffffffffc0200d76:	60e2                	ld	ra,24(sp)
ffffffffc0200d78:	64a2                	ld	s1,8(sp)
ffffffffc0200d7a:	6902                	ld	s2,0(sp)
ffffffffc0200d7c:	0000b517          	auipc	a0,0xb
ffffffffc0200d80:	db450513          	addi	a0,a0,-588 # ffffffffc020bb30 <commands+0x2c0>
ffffffffc0200d84:	6105                	addi	sp,sp,32
ffffffffc0200d86:	c20ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d8a:	0000b617          	auipc	a2,0xb
ffffffffc0200d8e:	de660613          	addi	a2,a2,-538 # ffffffffc020bb70 <commands+0x300>
ffffffffc0200d92:	03200593          	li	a1,50
ffffffffc0200d96:	0000b517          	auipc	a0,0xb
ffffffffc0200d9a:	df250513          	addi	a0,a0,-526 # ffffffffc020bb88 <commands+0x318>
ffffffffc0200d9e:	f00ff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0200da2 <idt_init>:
ffffffffc0200da2:	14005073          	csrwi	sscratch,0
ffffffffc0200da6:	00000797          	auipc	a5,0x0
ffffffffc0200daa:	43a78793          	addi	a5,a5,1082 # ffffffffc02011e0 <__alltraps>
ffffffffc0200dae:	10579073          	csrw	stvec,a5
ffffffffc0200db2:	000407b7          	lui	a5,0x40
ffffffffc0200db6:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dba:	8082                	ret

ffffffffc0200dbc <print_regs>:
ffffffffc0200dbc:	610c                	ld	a1,0(a0)
ffffffffc0200dbe:	1141                	addi	sp,sp,-16
ffffffffc0200dc0:	e022                	sd	s0,0(sp)
ffffffffc0200dc2:	842a                	mv	s0,a0
ffffffffc0200dc4:	0000b517          	auipc	a0,0xb
ffffffffc0200dc8:	dec50513          	addi	a0,a0,-532 # ffffffffc020bbb0 <commands+0x340>
ffffffffc0200dcc:	e406                	sd	ra,8(sp)
ffffffffc0200dce:	bd8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dd2:	640c                	ld	a1,8(s0)
ffffffffc0200dd4:	0000b517          	auipc	a0,0xb
ffffffffc0200dd8:	df450513          	addi	a0,a0,-524 # ffffffffc020bbc8 <commands+0x358>
ffffffffc0200ddc:	bcaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200de0:	680c                	ld	a1,16(s0)
ffffffffc0200de2:	0000b517          	auipc	a0,0xb
ffffffffc0200de6:	dfe50513          	addi	a0,a0,-514 # ffffffffc020bbe0 <commands+0x370>
ffffffffc0200dea:	bbcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dee:	6c0c                	ld	a1,24(s0)
ffffffffc0200df0:	0000b517          	auipc	a0,0xb
ffffffffc0200df4:	e0850513          	addi	a0,a0,-504 # ffffffffc020bbf8 <commands+0x388>
ffffffffc0200df8:	baeff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200dfc:	700c                	ld	a1,32(s0)
ffffffffc0200dfe:	0000b517          	auipc	a0,0xb
ffffffffc0200e02:	e1250513          	addi	a0,a0,-494 # ffffffffc020bc10 <commands+0x3a0>
ffffffffc0200e06:	ba0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e0a:	740c                	ld	a1,40(s0)
ffffffffc0200e0c:	0000b517          	auipc	a0,0xb
ffffffffc0200e10:	e1c50513          	addi	a0,a0,-484 # ffffffffc020bc28 <commands+0x3b8>
ffffffffc0200e14:	b92ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e18:	780c                	ld	a1,48(s0)
ffffffffc0200e1a:	0000b517          	auipc	a0,0xb
ffffffffc0200e1e:	e2650513          	addi	a0,a0,-474 # ffffffffc020bc40 <commands+0x3d0>
ffffffffc0200e22:	b84ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e26:	7c0c                	ld	a1,56(s0)
ffffffffc0200e28:	0000b517          	auipc	a0,0xb
ffffffffc0200e2c:	e3050513          	addi	a0,a0,-464 # ffffffffc020bc58 <commands+0x3e8>
ffffffffc0200e30:	b76ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e34:	602c                	ld	a1,64(s0)
ffffffffc0200e36:	0000b517          	auipc	a0,0xb
ffffffffc0200e3a:	e3a50513          	addi	a0,a0,-454 # ffffffffc020bc70 <commands+0x400>
ffffffffc0200e3e:	b68ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e42:	642c                	ld	a1,72(s0)
ffffffffc0200e44:	0000b517          	auipc	a0,0xb
ffffffffc0200e48:	e4450513          	addi	a0,a0,-444 # ffffffffc020bc88 <commands+0x418>
ffffffffc0200e4c:	b5aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e50:	682c                	ld	a1,80(s0)
ffffffffc0200e52:	0000b517          	auipc	a0,0xb
ffffffffc0200e56:	e4e50513          	addi	a0,a0,-434 # ffffffffc020bca0 <commands+0x430>
ffffffffc0200e5a:	b4cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e5e:	6c2c                	ld	a1,88(s0)
ffffffffc0200e60:	0000b517          	auipc	a0,0xb
ffffffffc0200e64:	e5850513          	addi	a0,a0,-424 # ffffffffc020bcb8 <commands+0x448>
ffffffffc0200e68:	b3eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e6c:	702c                	ld	a1,96(s0)
ffffffffc0200e6e:	0000b517          	auipc	a0,0xb
ffffffffc0200e72:	e6250513          	addi	a0,a0,-414 # ffffffffc020bcd0 <commands+0x460>
ffffffffc0200e76:	b30ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e7a:	742c                	ld	a1,104(s0)
ffffffffc0200e7c:	0000b517          	auipc	a0,0xb
ffffffffc0200e80:	e6c50513          	addi	a0,a0,-404 # ffffffffc020bce8 <commands+0x478>
ffffffffc0200e84:	b22ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e88:	782c                	ld	a1,112(s0)
ffffffffc0200e8a:	0000b517          	auipc	a0,0xb
ffffffffc0200e8e:	e7650513          	addi	a0,a0,-394 # ffffffffc020bd00 <commands+0x490>
ffffffffc0200e92:	b14ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200e96:	7c2c                	ld	a1,120(s0)
ffffffffc0200e98:	0000b517          	auipc	a0,0xb
ffffffffc0200e9c:	e8050513          	addi	a0,a0,-384 # ffffffffc020bd18 <commands+0x4a8>
ffffffffc0200ea0:	b06ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ea4:	604c                	ld	a1,128(s0)
ffffffffc0200ea6:	0000b517          	auipc	a0,0xb
ffffffffc0200eaa:	e8a50513          	addi	a0,a0,-374 # ffffffffc020bd30 <commands+0x4c0>
ffffffffc0200eae:	af8ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eb2:	644c                	ld	a1,136(s0)
ffffffffc0200eb4:	0000b517          	auipc	a0,0xb
ffffffffc0200eb8:	e9450513          	addi	a0,a0,-364 # ffffffffc020bd48 <commands+0x4d8>
ffffffffc0200ebc:	aeaff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ec0:	684c                	ld	a1,144(s0)
ffffffffc0200ec2:	0000b517          	auipc	a0,0xb
ffffffffc0200ec6:	e9e50513          	addi	a0,a0,-354 # ffffffffc020bd60 <commands+0x4f0>
ffffffffc0200eca:	adcff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ece:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed0:	0000b517          	auipc	a0,0xb
ffffffffc0200ed4:	ea850513          	addi	a0,a0,-344 # ffffffffc020bd78 <commands+0x508>
ffffffffc0200ed8:	aceff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200edc:	704c                	ld	a1,160(s0)
ffffffffc0200ede:	0000b517          	auipc	a0,0xb
ffffffffc0200ee2:	eb250513          	addi	a0,a0,-334 # ffffffffc020bd90 <commands+0x520>
ffffffffc0200ee6:	ac0ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200eea:	744c                	ld	a1,168(s0)
ffffffffc0200eec:	0000b517          	auipc	a0,0xb
ffffffffc0200ef0:	ebc50513          	addi	a0,a0,-324 # ffffffffc020bda8 <commands+0x538>
ffffffffc0200ef4:	ab2ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200ef8:	784c                	ld	a1,176(s0)
ffffffffc0200efa:	0000b517          	auipc	a0,0xb
ffffffffc0200efe:	ec650513          	addi	a0,a0,-314 # ffffffffc020bdc0 <commands+0x550>
ffffffffc0200f02:	aa4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f06:	7c4c                	ld	a1,184(s0)
ffffffffc0200f08:	0000b517          	auipc	a0,0xb
ffffffffc0200f0c:	ed050513          	addi	a0,a0,-304 # ffffffffc020bdd8 <commands+0x568>
ffffffffc0200f10:	a96ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f14:	606c                	ld	a1,192(s0)
ffffffffc0200f16:	0000b517          	auipc	a0,0xb
ffffffffc0200f1a:	eda50513          	addi	a0,a0,-294 # ffffffffc020bdf0 <commands+0x580>
ffffffffc0200f1e:	a88ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f22:	646c                	ld	a1,200(s0)
ffffffffc0200f24:	0000b517          	auipc	a0,0xb
ffffffffc0200f28:	ee450513          	addi	a0,a0,-284 # ffffffffc020be08 <commands+0x598>
ffffffffc0200f2c:	a7aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f30:	686c                	ld	a1,208(s0)
ffffffffc0200f32:	0000b517          	auipc	a0,0xb
ffffffffc0200f36:	eee50513          	addi	a0,a0,-274 # ffffffffc020be20 <commands+0x5b0>
ffffffffc0200f3a:	a6cff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f3e:	6c6c                	ld	a1,216(s0)
ffffffffc0200f40:	0000b517          	auipc	a0,0xb
ffffffffc0200f44:	ef850513          	addi	a0,a0,-264 # ffffffffc020be38 <commands+0x5c8>
ffffffffc0200f48:	a5eff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f4c:	706c                	ld	a1,224(s0)
ffffffffc0200f4e:	0000b517          	auipc	a0,0xb
ffffffffc0200f52:	f0250513          	addi	a0,a0,-254 # ffffffffc020be50 <commands+0x5e0>
ffffffffc0200f56:	a50ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f5a:	746c                	ld	a1,232(s0)
ffffffffc0200f5c:	0000b517          	auipc	a0,0xb
ffffffffc0200f60:	f0c50513          	addi	a0,a0,-244 # ffffffffc020be68 <commands+0x5f8>
ffffffffc0200f64:	a42ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f68:	786c                	ld	a1,240(s0)
ffffffffc0200f6a:	0000b517          	auipc	a0,0xb
ffffffffc0200f6e:	f1650513          	addi	a0,a0,-234 # ffffffffc020be80 <commands+0x610>
ffffffffc0200f72:	a34ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200f76:	7c6c                	ld	a1,248(s0)
ffffffffc0200f78:	6402                	ld	s0,0(sp)
ffffffffc0200f7a:	60a2                	ld	ra,8(sp)
ffffffffc0200f7c:	0000b517          	auipc	a0,0xb
ffffffffc0200f80:	f1c50513          	addi	a0,a0,-228 # ffffffffc020be98 <commands+0x628>
ffffffffc0200f84:	0141                	addi	sp,sp,16
ffffffffc0200f86:	a20ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f8a <print_trapframe>:
ffffffffc0200f8a:	1141                	addi	sp,sp,-16
ffffffffc0200f8c:	e022                	sd	s0,0(sp)
ffffffffc0200f8e:	85aa                	mv	a1,a0
ffffffffc0200f90:	842a                	mv	s0,a0
ffffffffc0200f92:	0000b517          	auipc	a0,0xb
ffffffffc0200f96:	f1e50513          	addi	a0,a0,-226 # ffffffffc020beb0 <commands+0x640>
ffffffffc0200f9a:	e406                	sd	ra,8(sp)
ffffffffc0200f9c:	a0aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fa0:	8522                	mv	a0,s0
ffffffffc0200fa2:	e1bff0ef          	jal	ra,ffffffffc0200dbc <print_regs>
ffffffffc0200fa6:	10043583          	ld	a1,256(s0)
ffffffffc0200faa:	0000b517          	auipc	a0,0xb
ffffffffc0200fae:	f1e50513          	addi	a0,a0,-226 # ffffffffc020bec8 <commands+0x658>
ffffffffc0200fb2:	9f4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fb6:	10843583          	ld	a1,264(s0)
ffffffffc0200fba:	0000b517          	auipc	a0,0xb
ffffffffc0200fbe:	f2650513          	addi	a0,a0,-218 # ffffffffc020bee0 <commands+0x670>
ffffffffc0200fc2:	9e4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fc6:	11043583          	ld	a1,272(s0)
ffffffffc0200fca:	0000b517          	auipc	a0,0xb
ffffffffc0200fce:	f2e50513          	addi	a0,a0,-210 # ffffffffc020bef8 <commands+0x688>
ffffffffc0200fd2:	9d4ff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0200fd6:	11843583          	ld	a1,280(s0)
ffffffffc0200fda:	6402                	ld	s0,0(sp)
ffffffffc0200fdc:	60a2                	ld	ra,8(sp)
ffffffffc0200fde:	0000b517          	auipc	a0,0xb
ffffffffc0200fe2:	f2a50513          	addi	a0,a0,-214 # ffffffffc020bf08 <commands+0x698>
ffffffffc0200fe6:	0141                	addi	sp,sp,16
ffffffffc0200fe8:	9beff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200fec <interrupt_handler>:
ffffffffc0200fec:	11853783          	ld	a5,280(a0)
ffffffffc0200ff0:	472d                	li	a4,11
ffffffffc0200ff2:	0786                	slli	a5,a5,0x1
ffffffffc0200ff4:	8385                	srli	a5,a5,0x1
ffffffffc0200ff6:	06f76c63          	bltu	a4,a5,ffffffffc020106e <interrupt_handler+0x82>
ffffffffc0200ffa:	0000b717          	auipc	a4,0xb
ffffffffc0200ffe:	fc670713          	addi	a4,a4,-58 # ffffffffc020bfc0 <commands+0x750>
ffffffffc0201002:	078a                	slli	a5,a5,0x2
ffffffffc0201004:	97ba                	add	a5,a5,a4
ffffffffc0201006:	439c                	lw	a5,0(a5)
ffffffffc0201008:	97ba                	add	a5,a5,a4
ffffffffc020100a:	8782                	jr	a5
ffffffffc020100c:	0000b517          	auipc	a0,0xb
ffffffffc0201010:	f7450513          	addi	a0,a0,-140 # ffffffffc020bf80 <commands+0x710>
ffffffffc0201014:	992ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201018:	0000b517          	auipc	a0,0xb
ffffffffc020101c:	f4850513          	addi	a0,a0,-184 # ffffffffc020bf60 <commands+0x6f0>
ffffffffc0201020:	986ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201024:	0000b517          	auipc	a0,0xb
ffffffffc0201028:	efc50513          	addi	a0,a0,-260 # ffffffffc020bf20 <commands+0x6b0>
ffffffffc020102c:	97aff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201030:	0000b517          	auipc	a0,0xb
ffffffffc0201034:	f1050513          	addi	a0,a0,-240 # ffffffffc020bf40 <commands+0x6d0>
ffffffffc0201038:	96eff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020103c:	1141                	addi	sp,sp,-16
ffffffffc020103e:	e406                	sd	ra,8(sp)
ffffffffc0201040:	d3aff0ef          	jal	ra,ffffffffc020057a <clock_set_next_event>
ffffffffc0201044:	00096717          	auipc	a4,0x96
ffffffffc0201048:	82c70713          	addi	a4,a4,-2004 # ffffffffc0296870 <ticks>
ffffffffc020104c:	631c                	ld	a5,0(a4)
ffffffffc020104e:	0785                	addi	a5,a5,1
ffffffffc0201050:	e31c                	sd	a5,0(a4)
ffffffffc0201052:	5d6060ef          	jal	ra,ffffffffc0207628 <run_timer_list>
ffffffffc0201056:	d9eff0ef          	jal	ra,ffffffffc02005f4 <cons_getc>
ffffffffc020105a:	60a2                	ld	ra,8(sp)
ffffffffc020105c:	0141                	addi	sp,sp,16
ffffffffc020105e:	49b0706f          	j	ffffffffc0208cf8 <dev_stdin_write>
ffffffffc0201062:	0000b517          	auipc	a0,0xb
ffffffffc0201066:	f3e50513          	addi	a0,a0,-194 # ffffffffc020bfa0 <commands+0x730>
ffffffffc020106a:	93cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020106e:	bf31                	j	ffffffffc0200f8a <print_trapframe>

ffffffffc0201070 <exception_handler>:
ffffffffc0201070:	11853783          	ld	a5,280(a0)
ffffffffc0201074:	1141                	addi	sp,sp,-16
ffffffffc0201076:	e022                	sd	s0,0(sp)
ffffffffc0201078:	e406                	sd	ra,8(sp)
ffffffffc020107a:	473d                	li	a4,15
ffffffffc020107c:	842a                	mv	s0,a0
ffffffffc020107e:	0af76b63          	bltu	a4,a5,ffffffffc0201134 <exception_handler+0xc4>
ffffffffc0201082:	0000b717          	auipc	a4,0xb
ffffffffc0201086:	0fe70713          	addi	a4,a4,254 # ffffffffc020c180 <commands+0x910>
ffffffffc020108a:	078a                	slli	a5,a5,0x2
ffffffffc020108c:	97ba                	add	a5,a5,a4
ffffffffc020108e:	439c                	lw	a5,0(a5)
ffffffffc0201090:	97ba                	add	a5,a5,a4
ffffffffc0201092:	8782                	jr	a5
ffffffffc0201094:	0000b517          	auipc	a0,0xb
ffffffffc0201098:	04450513          	addi	a0,a0,68 # ffffffffc020c0d8 <commands+0x868>
ffffffffc020109c:	90aff0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02010a0:	10843783          	ld	a5,264(s0)
ffffffffc02010a4:	60a2                	ld	ra,8(sp)
ffffffffc02010a6:	0791                	addi	a5,a5,4
ffffffffc02010a8:	10f43423          	sd	a5,264(s0)
ffffffffc02010ac:	6402                	ld	s0,0(sp)
ffffffffc02010ae:	0141                	addi	sp,sp,16
ffffffffc02010b0:	78e0606f          	j	ffffffffc020783e <syscall>
ffffffffc02010b4:	0000b517          	auipc	a0,0xb
ffffffffc02010b8:	04450513          	addi	a0,a0,68 # ffffffffc020c0f8 <commands+0x888>
ffffffffc02010bc:	6402                	ld	s0,0(sp)
ffffffffc02010be:	60a2                	ld	ra,8(sp)
ffffffffc02010c0:	0141                	addi	sp,sp,16
ffffffffc02010c2:	8e4ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02010c6:	0000b517          	auipc	a0,0xb
ffffffffc02010ca:	05250513          	addi	a0,a0,82 # ffffffffc020c118 <commands+0x8a8>
ffffffffc02010ce:	b7fd                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010d0:	0000b517          	auipc	a0,0xb
ffffffffc02010d4:	06850513          	addi	a0,a0,104 # ffffffffc020c138 <commands+0x8c8>
ffffffffc02010d8:	b7d5                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010da:	0000b517          	auipc	a0,0xb
ffffffffc02010de:	07650513          	addi	a0,a0,118 # ffffffffc020c150 <commands+0x8e0>
ffffffffc02010e2:	bfe9                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010e4:	0000b517          	auipc	a0,0xb
ffffffffc02010e8:	08450513          	addi	a0,a0,132 # ffffffffc020c168 <commands+0x8f8>
ffffffffc02010ec:	bfc1                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010ee:	0000b517          	auipc	a0,0xb
ffffffffc02010f2:	f0250513          	addi	a0,a0,-254 # ffffffffc020bff0 <commands+0x780>
ffffffffc02010f6:	b7d9                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc02010f8:	0000b517          	auipc	a0,0xb
ffffffffc02010fc:	f1850513          	addi	a0,a0,-232 # ffffffffc020c010 <commands+0x7a0>
ffffffffc0201100:	bf75                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201102:	0000b517          	auipc	a0,0xb
ffffffffc0201106:	f2e50513          	addi	a0,a0,-210 # ffffffffc020c030 <commands+0x7c0>
ffffffffc020110a:	bf4d                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc020110c:	0000b517          	auipc	a0,0xb
ffffffffc0201110:	f3c50513          	addi	a0,a0,-196 # ffffffffc020c048 <commands+0x7d8>
ffffffffc0201114:	b765                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201116:	0000b517          	auipc	a0,0xb
ffffffffc020111a:	f4250513          	addi	a0,a0,-190 # ffffffffc020c058 <commands+0x7e8>
ffffffffc020111e:	bf79                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201120:	0000b517          	auipc	a0,0xb
ffffffffc0201124:	f5850513          	addi	a0,a0,-168 # ffffffffc020c078 <commands+0x808>
ffffffffc0201128:	bf51                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc020112a:	0000b517          	auipc	a0,0xb
ffffffffc020112e:	f9650513          	addi	a0,a0,-106 # ffffffffc020c0c0 <commands+0x850>
ffffffffc0201132:	b769                	j	ffffffffc02010bc <exception_handler+0x4c>
ffffffffc0201134:	8522                	mv	a0,s0
ffffffffc0201136:	6402                	ld	s0,0(sp)
ffffffffc0201138:	60a2                	ld	ra,8(sp)
ffffffffc020113a:	0141                	addi	sp,sp,16
ffffffffc020113c:	b5b9                	j	ffffffffc0200f8a <print_trapframe>
ffffffffc020113e:	0000b617          	auipc	a2,0xb
ffffffffc0201142:	f5260613          	addi	a2,a2,-174 # ffffffffc020c090 <commands+0x820>
ffffffffc0201146:	0b200593          	li	a1,178
ffffffffc020114a:	0000b517          	auipc	a0,0xb
ffffffffc020114e:	f5e50513          	addi	a0,a0,-162 # ffffffffc020c0a8 <commands+0x838>
ffffffffc0201152:	b4cff0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201156 <trap>:
ffffffffc0201156:	1101                	addi	sp,sp,-32
ffffffffc0201158:	e822                	sd	s0,16(sp)
ffffffffc020115a:	00095417          	auipc	s0,0x95
ffffffffc020115e:	76640413          	addi	s0,s0,1894 # ffffffffc02968c0 <current>
ffffffffc0201162:	6018                	ld	a4,0(s0)
ffffffffc0201164:	ec06                	sd	ra,24(sp)
ffffffffc0201166:	e426                	sd	s1,8(sp)
ffffffffc0201168:	e04a                	sd	s2,0(sp)
ffffffffc020116a:	11853683          	ld	a3,280(a0)
ffffffffc020116e:	cf1d                	beqz	a4,ffffffffc02011ac <trap+0x56>
ffffffffc0201170:	10053483          	ld	s1,256(a0)
ffffffffc0201174:	0a073903          	ld	s2,160(a4)
ffffffffc0201178:	f348                	sd	a0,160(a4)
ffffffffc020117a:	1004f493          	andi	s1,s1,256
ffffffffc020117e:	0206c463          	bltz	a3,ffffffffc02011a6 <trap+0x50>
ffffffffc0201182:	eefff0ef          	jal	ra,ffffffffc0201070 <exception_handler>
ffffffffc0201186:	601c                	ld	a5,0(s0)
ffffffffc0201188:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_bin_swap_img_size+0x383a0>
ffffffffc020118c:	e499                	bnez	s1,ffffffffc020119a <trap+0x44>
ffffffffc020118e:	0b07a703          	lw	a4,176(a5)
ffffffffc0201192:	8b05                	andi	a4,a4,1
ffffffffc0201194:	e329                	bnez	a4,ffffffffc02011d6 <trap+0x80>
ffffffffc0201196:	6f9c                	ld	a5,24(a5)
ffffffffc0201198:	eb85                	bnez	a5,ffffffffc02011c8 <trap+0x72>
ffffffffc020119a:	60e2                	ld	ra,24(sp)
ffffffffc020119c:	6442                	ld	s0,16(sp)
ffffffffc020119e:	64a2                	ld	s1,8(sp)
ffffffffc02011a0:	6902                	ld	s2,0(sp)
ffffffffc02011a2:	6105                	addi	sp,sp,32
ffffffffc02011a4:	8082                	ret
ffffffffc02011a6:	e47ff0ef          	jal	ra,ffffffffc0200fec <interrupt_handler>
ffffffffc02011aa:	bff1                	j	ffffffffc0201186 <trap+0x30>
ffffffffc02011ac:	0006c863          	bltz	a3,ffffffffc02011bc <trap+0x66>
ffffffffc02011b0:	6442                	ld	s0,16(sp)
ffffffffc02011b2:	60e2                	ld	ra,24(sp)
ffffffffc02011b4:	64a2                	ld	s1,8(sp)
ffffffffc02011b6:	6902                	ld	s2,0(sp)
ffffffffc02011b8:	6105                	addi	sp,sp,32
ffffffffc02011ba:	bd5d                	j	ffffffffc0201070 <exception_handler>
ffffffffc02011bc:	6442                	ld	s0,16(sp)
ffffffffc02011be:	60e2                	ld	ra,24(sp)
ffffffffc02011c0:	64a2                	ld	s1,8(sp)
ffffffffc02011c2:	6902                	ld	s2,0(sp)
ffffffffc02011c4:	6105                	addi	sp,sp,32
ffffffffc02011c6:	b51d                	j	ffffffffc0200fec <interrupt_handler>
ffffffffc02011c8:	6442                	ld	s0,16(sp)
ffffffffc02011ca:	60e2                	ld	ra,24(sp)
ffffffffc02011cc:	64a2                	ld	s1,8(sp)
ffffffffc02011ce:	6902                	ld	s2,0(sp)
ffffffffc02011d0:	6105                	addi	sp,sp,32
ffffffffc02011d2:	24a0606f          	j	ffffffffc020741c <schedule>
ffffffffc02011d6:	555d                	li	a0,-9
ffffffffc02011d8:	687040ef          	jal	ra,ffffffffc020605e <do_exit>
ffffffffc02011dc:	601c                	ld	a5,0(s0)
ffffffffc02011de:	bf65                	j	ffffffffc0201196 <trap+0x40>

ffffffffc02011e0 <__alltraps>:
ffffffffc02011e0:	14011173          	csrrw	sp,sscratch,sp
ffffffffc02011e4:	00011463          	bnez	sp,ffffffffc02011ec <__alltraps+0xc>
ffffffffc02011e8:	14002173          	csrr	sp,sscratch
ffffffffc02011ec:	712d                	addi	sp,sp,-288
ffffffffc02011ee:	e002                	sd	zero,0(sp)
ffffffffc02011f0:	e406                	sd	ra,8(sp)
ffffffffc02011f2:	ec0e                	sd	gp,24(sp)
ffffffffc02011f4:	f012                	sd	tp,32(sp)
ffffffffc02011f6:	f416                	sd	t0,40(sp)
ffffffffc02011f8:	f81a                	sd	t1,48(sp)
ffffffffc02011fa:	fc1e                	sd	t2,56(sp)
ffffffffc02011fc:	e0a2                	sd	s0,64(sp)
ffffffffc02011fe:	e4a6                	sd	s1,72(sp)
ffffffffc0201200:	e8aa                	sd	a0,80(sp)
ffffffffc0201202:	ecae                	sd	a1,88(sp)
ffffffffc0201204:	f0b2                	sd	a2,96(sp)
ffffffffc0201206:	f4b6                	sd	a3,104(sp)
ffffffffc0201208:	f8ba                	sd	a4,112(sp)
ffffffffc020120a:	fcbe                	sd	a5,120(sp)
ffffffffc020120c:	e142                	sd	a6,128(sp)
ffffffffc020120e:	e546                	sd	a7,136(sp)
ffffffffc0201210:	e94a                	sd	s2,144(sp)
ffffffffc0201212:	ed4e                	sd	s3,152(sp)
ffffffffc0201214:	f152                	sd	s4,160(sp)
ffffffffc0201216:	f556                	sd	s5,168(sp)
ffffffffc0201218:	f95a                	sd	s6,176(sp)
ffffffffc020121a:	fd5e                	sd	s7,184(sp)
ffffffffc020121c:	e1e2                	sd	s8,192(sp)
ffffffffc020121e:	e5e6                	sd	s9,200(sp)
ffffffffc0201220:	e9ea                	sd	s10,208(sp)
ffffffffc0201222:	edee                	sd	s11,216(sp)
ffffffffc0201224:	f1f2                	sd	t3,224(sp)
ffffffffc0201226:	f5f6                	sd	t4,232(sp)
ffffffffc0201228:	f9fa                	sd	t5,240(sp)
ffffffffc020122a:	fdfe                	sd	t6,248(sp)
ffffffffc020122c:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201230:	100024f3          	csrr	s1,sstatus
ffffffffc0201234:	14102973          	csrr	s2,sepc
ffffffffc0201238:	143029f3          	csrr	s3,stval
ffffffffc020123c:	14202a73          	csrr	s4,scause
ffffffffc0201240:	e822                	sd	s0,16(sp)
ffffffffc0201242:	e226                	sd	s1,256(sp)
ffffffffc0201244:	e64a                	sd	s2,264(sp)
ffffffffc0201246:	ea4e                	sd	s3,272(sp)
ffffffffc0201248:	ee52                	sd	s4,280(sp)
ffffffffc020124a:	850a                	mv	a0,sp
ffffffffc020124c:	f0bff0ef          	jal	ra,ffffffffc0201156 <trap>

ffffffffc0201250 <__trapret>:
ffffffffc0201250:	6492                	ld	s1,256(sp)
ffffffffc0201252:	6932                	ld	s2,264(sp)
ffffffffc0201254:	1004f413          	andi	s0,s1,256
ffffffffc0201258:	e401                	bnez	s0,ffffffffc0201260 <__trapret+0x10>
ffffffffc020125a:	1200                	addi	s0,sp,288
ffffffffc020125c:	14041073          	csrw	sscratch,s0
ffffffffc0201260:	10049073          	csrw	sstatus,s1
ffffffffc0201264:	14191073          	csrw	sepc,s2
ffffffffc0201268:	60a2                	ld	ra,8(sp)
ffffffffc020126a:	61e2                	ld	gp,24(sp)
ffffffffc020126c:	7202                	ld	tp,32(sp)
ffffffffc020126e:	72a2                	ld	t0,40(sp)
ffffffffc0201270:	7342                	ld	t1,48(sp)
ffffffffc0201272:	73e2                	ld	t2,56(sp)
ffffffffc0201274:	6406                	ld	s0,64(sp)
ffffffffc0201276:	64a6                	ld	s1,72(sp)
ffffffffc0201278:	6546                	ld	a0,80(sp)
ffffffffc020127a:	65e6                	ld	a1,88(sp)
ffffffffc020127c:	7606                	ld	a2,96(sp)
ffffffffc020127e:	76a6                	ld	a3,104(sp)
ffffffffc0201280:	7746                	ld	a4,112(sp)
ffffffffc0201282:	77e6                	ld	a5,120(sp)
ffffffffc0201284:	680a                	ld	a6,128(sp)
ffffffffc0201286:	68aa                	ld	a7,136(sp)
ffffffffc0201288:	694a                	ld	s2,144(sp)
ffffffffc020128a:	69ea                	ld	s3,152(sp)
ffffffffc020128c:	7a0a                	ld	s4,160(sp)
ffffffffc020128e:	7aaa                	ld	s5,168(sp)
ffffffffc0201290:	7b4a                	ld	s6,176(sp)
ffffffffc0201292:	7bea                	ld	s7,184(sp)
ffffffffc0201294:	6c0e                	ld	s8,192(sp)
ffffffffc0201296:	6cae                	ld	s9,200(sp)
ffffffffc0201298:	6d4e                	ld	s10,208(sp)
ffffffffc020129a:	6dee                	ld	s11,216(sp)
ffffffffc020129c:	7e0e                	ld	t3,224(sp)
ffffffffc020129e:	7eae                	ld	t4,232(sp)
ffffffffc02012a0:	7f4e                	ld	t5,240(sp)
ffffffffc02012a2:	7fee                	ld	t6,248(sp)
ffffffffc02012a4:	6142                	ld	sp,16(sp)
ffffffffc02012a6:	10200073          	sret

ffffffffc02012aa <forkrets>:
ffffffffc02012aa:	812a                	mv	sp,a0
ffffffffc02012ac:	b755                	j	ffffffffc0201250 <__trapret>

ffffffffc02012ae <default_init>:
ffffffffc02012ae:	00090797          	auipc	a5,0x90
ffffffffc02012b2:	4fa78793          	addi	a5,a5,1274 # ffffffffc02917a8 <free_area>
ffffffffc02012b6:	e79c                	sd	a5,8(a5)
ffffffffc02012b8:	e39c                	sd	a5,0(a5)
ffffffffc02012ba:	0007a823          	sw	zero,16(a5)
ffffffffc02012be:	8082                	ret

ffffffffc02012c0 <default_nr_free_pages>:
ffffffffc02012c0:	00090517          	auipc	a0,0x90
ffffffffc02012c4:	4f856503          	lwu	a0,1272(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02012c8:	8082                	ret

ffffffffc02012ca <default_check>:
ffffffffc02012ca:	715d                	addi	sp,sp,-80
ffffffffc02012cc:	e0a2                	sd	s0,64(sp)
ffffffffc02012ce:	00090417          	auipc	s0,0x90
ffffffffc02012d2:	4da40413          	addi	s0,s0,1242 # ffffffffc02917a8 <free_area>
ffffffffc02012d6:	641c                	ld	a5,8(s0)
ffffffffc02012d8:	e486                	sd	ra,72(sp)
ffffffffc02012da:	fc26                	sd	s1,56(sp)
ffffffffc02012dc:	f84a                	sd	s2,48(sp)
ffffffffc02012de:	f44e                	sd	s3,40(sp)
ffffffffc02012e0:	f052                	sd	s4,32(sp)
ffffffffc02012e2:	ec56                	sd	s5,24(sp)
ffffffffc02012e4:	e85a                	sd	s6,16(sp)
ffffffffc02012e6:	e45e                	sd	s7,8(sp)
ffffffffc02012e8:	e062                	sd	s8,0(sp)
ffffffffc02012ea:	2a878d63          	beq	a5,s0,ffffffffc02015a4 <default_check+0x2da>
ffffffffc02012ee:	4481                	li	s1,0
ffffffffc02012f0:	4901                	li	s2,0
ffffffffc02012f2:	ff07b703          	ld	a4,-16(a5)
ffffffffc02012f6:	8b09                	andi	a4,a4,2
ffffffffc02012f8:	2a070a63          	beqz	a4,ffffffffc02015ac <default_check+0x2e2>
ffffffffc02012fc:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201300:	679c                	ld	a5,8(a5)
ffffffffc0201302:	2905                	addiw	s2,s2,1
ffffffffc0201304:	9cb9                	addw	s1,s1,a4
ffffffffc0201306:	fe8796e3          	bne	a5,s0,ffffffffc02012f2 <default_check+0x28>
ffffffffc020130a:	89a6                	mv	s3,s1
ffffffffc020130c:	6df000ef          	jal	ra,ffffffffc02021ea <nr_free_pages>
ffffffffc0201310:	6f351e63          	bne	a0,s3,ffffffffc0201a0c <default_check+0x742>
ffffffffc0201314:	4505                	li	a0,1
ffffffffc0201316:	657000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020131a:	8aaa                	mv	s5,a0
ffffffffc020131c:	42050863          	beqz	a0,ffffffffc020174c <default_check+0x482>
ffffffffc0201320:	4505                	li	a0,1
ffffffffc0201322:	64b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201326:	89aa                	mv	s3,a0
ffffffffc0201328:	70050263          	beqz	a0,ffffffffc0201a2c <default_check+0x762>
ffffffffc020132c:	4505                	li	a0,1
ffffffffc020132e:	63f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201332:	8a2a                	mv	s4,a0
ffffffffc0201334:	48050c63          	beqz	a0,ffffffffc02017cc <default_check+0x502>
ffffffffc0201338:	293a8a63          	beq	s5,s3,ffffffffc02015cc <default_check+0x302>
ffffffffc020133c:	28aa8863          	beq	s5,a0,ffffffffc02015cc <default_check+0x302>
ffffffffc0201340:	28a98663          	beq	s3,a0,ffffffffc02015cc <default_check+0x302>
ffffffffc0201344:	000aa783          	lw	a5,0(s5)
ffffffffc0201348:	2a079263          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc020134c:	0009a783          	lw	a5,0(s3)
ffffffffc0201350:	28079e63          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc0201354:	411c                	lw	a5,0(a0)
ffffffffc0201356:	28079b63          	bnez	a5,ffffffffc02015ec <default_check+0x322>
ffffffffc020135a:	00095797          	auipc	a5,0x95
ffffffffc020135e:	54e7b783          	ld	a5,1358(a5) # ffffffffc02968a8 <pages>
ffffffffc0201362:	40fa8733          	sub	a4,s5,a5
ffffffffc0201366:	0000e617          	auipc	a2,0xe
ffffffffc020136a:	56a63603          	ld	a2,1386(a2) # ffffffffc020f8d0 <nbase>
ffffffffc020136e:	8719                	srai	a4,a4,0x6
ffffffffc0201370:	9732                	add	a4,a4,a2
ffffffffc0201372:	00095697          	auipc	a3,0x95
ffffffffc0201376:	52e6b683          	ld	a3,1326(a3) # ffffffffc02968a0 <npage>
ffffffffc020137a:	06b2                	slli	a3,a3,0xc
ffffffffc020137c:	0732                	slli	a4,a4,0xc
ffffffffc020137e:	28d77763          	bgeu	a4,a3,ffffffffc020160c <default_check+0x342>
ffffffffc0201382:	40f98733          	sub	a4,s3,a5
ffffffffc0201386:	8719                	srai	a4,a4,0x6
ffffffffc0201388:	9732                	add	a4,a4,a2
ffffffffc020138a:	0732                	slli	a4,a4,0xc
ffffffffc020138c:	4cd77063          	bgeu	a4,a3,ffffffffc020184c <default_check+0x582>
ffffffffc0201390:	40f507b3          	sub	a5,a0,a5
ffffffffc0201394:	8799                	srai	a5,a5,0x6
ffffffffc0201396:	97b2                	add	a5,a5,a2
ffffffffc0201398:	07b2                	slli	a5,a5,0xc
ffffffffc020139a:	30d7f963          	bgeu	a5,a3,ffffffffc02016ac <default_check+0x3e2>
ffffffffc020139e:	4505                	li	a0,1
ffffffffc02013a0:	00043c03          	ld	s8,0(s0)
ffffffffc02013a4:	00843b83          	ld	s7,8(s0)
ffffffffc02013a8:	01042b03          	lw	s6,16(s0)
ffffffffc02013ac:	e400                	sd	s0,8(s0)
ffffffffc02013ae:	e000                	sd	s0,0(s0)
ffffffffc02013b0:	00090797          	auipc	a5,0x90
ffffffffc02013b4:	4007a423          	sw	zero,1032(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc02013b8:	5b5000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013bc:	2c051863          	bnez	a0,ffffffffc020168c <default_check+0x3c2>
ffffffffc02013c0:	4585                	li	a1,1
ffffffffc02013c2:	8556                	mv	a0,s5
ffffffffc02013c4:	5e7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013c8:	4585                	li	a1,1
ffffffffc02013ca:	854e                	mv	a0,s3
ffffffffc02013cc:	5df000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013d0:	4585                	li	a1,1
ffffffffc02013d2:	8552                	mv	a0,s4
ffffffffc02013d4:	5d7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02013d8:	4818                	lw	a4,16(s0)
ffffffffc02013da:	478d                	li	a5,3
ffffffffc02013dc:	28f71863          	bne	a4,a5,ffffffffc020166c <default_check+0x3a2>
ffffffffc02013e0:	4505                	li	a0,1
ffffffffc02013e2:	58b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013e6:	89aa                	mv	s3,a0
ffffffffc02013e8:	26050263          	beqz	a0,ffffffffc020164c <default_check+0x382>
ffffffffc02013ec:	4505                	li	a0,1
ffffffffc02013ee:	57f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013f2:	8aaa                	mv	s5,a0
ffffffffc02013f4:	3a050c63          	beqz	a0,ffffffffc02017ac <default_check+0x4e2>
ffffffffc02013f8:	4505                	li	a0,1
ffffffffc02013fa:	573000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02013fe:	8a2a                	mv	s4,a0
ffffffffc0201400:	38050663          	beqz	a0,ffffffffc020178c <default_check+0x4c2>
ffffffffc0201404:	4505                	li	a0,1
ffffffffc0201406:	567000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020140a:	36051163          	bnez	a0,ffffffffc020176c <default_check+0x4a2>
ffffffffc020140e:	4585                	li	a1,1
ffffffffc0201410:	854e                	mv	a0,s3
ffffffffc0201412:	599000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201416:	641c                	ld	a5,8(s0)
ffffffffc0201418:	20878a63          	beq	a5,s0,ffffffffc020162c <default_check+0x362>
ffffffffc020141c:	4505                	li	a0,1
ffffffffc020141e:	54f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201422:	30a99563          	bne	s3,a0,ffffffffc020172c <default_check+0x462>
ffffffffc0201426:	4505                	li	a0,1
ffffffffc0201428:	545000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020142c:	2e051063          	bnez	a0,ffffffffc020170c <default_check+0x442>
ffffffffc0201430:	481c                	lw	a5,16(s0)
ffffffffc0201432:	2a079d63          	bnez	a5,ffffffffc02016ec <default_check+0x422>
ffffffffc0201436:	854e                	mv	a0,s3
ffffffffc0201438:	4585                	li	a1,1
ffffffffc020143a:	01843023          	sd	s8,0(s0)
ffffffffc020143e:	01743423          	sd	s7,8(s0)
ffffffffc0201442:	01642823          	sw	s6,16(s0)
ffffffffc0201446:	565000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020144a:	4585                	li	a1,1
ffffffffc020144c:	8556                	mv	a0,s5
ffffffffc020144e:	55d000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201452:	4585                	li	a1,1
ffffffffc0201454:	8552                	mv	a0,s4
ffffffffc0201456:	555000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020145a:	4515                	li	a0,5
ffffffffc020145c:	511000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201460:	89aa                	mv	s3,a0
ffffffffc0201462:	26050563          	beqz	a0,ffffffffc02016cc <default_check+0x402>
ffffffffc0201466:	651c                	ld	a5,8(a0)
ffffffffc0201468:	8385                	srli	a5,a5,0x1
ffffffffc020146a:	8b85                	andi	a5,a5,1
ffffffffc020146c:	54079063          	bnez	a5,ffffffffc02019ac <default_check+0x6e2>
ffffffffc0201470:	4505                	li	a0,1
ffffffffc0201472:	00043b03          	ld	s6,0(s0)
ffffffffc0201476:	00843a83          	ld	s5,8(s0)
ffffffffc020147a:	e000                	sd	s0,0(s0)
ffffffffc020147c:	e400                	sd	s0,8(s0)
ffffffffc020147e:	4ef000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201482:	50051563          	bnez	a0,ffffffffc020198c <default_check+0x6c2>
ffffffffc0201486:	08098a13          	addi	s4,s3,128
ffffffffc020148a:	8552                	mv	a0,s4
ffffffffc020148c:	458d                	li	a1,3
ffffffffc020148e:	01042b83          	lw	s7,16(s0)
ffffffffc0201492:	00090797          	auipc	a5,0x90
ffffffffc0201496:	3207a323          	sw	zero,806(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020149a:	511000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc020149e:	4511                	li	a0,4
ffffffffc02014a0:	4cd000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014a4:	4c051463          	bnez	a0,ffffffffc020196c <default_check+0x6a2>
ffffffffc02014a8:	0889b783          	ld	a5,136(s3)
ffffffffc02014ac:	8385                	srli	a5,a5,0x1
ffffffffc02014ae:	8b85                	andi	a5,a5,1
ffffffffc02014b0:	48078e63          	beqz	a5,ffffffffc020194c <default_check+0x682>
ffffffffc02014b4:	0909a703          	lw	a4,144(s3)
ffffffffc02014b8:	478d                	li	a5,3
ffffffffc02014ba:	48f71963          	bne	a4,a5,ffffffffc020194c <default_check+0x682>
ffffffffc02014be:	450d                	li	a0,3
ffffffffc02014c0:	4ad000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014c4:	8c2a                	mv	s8,a0
ffffffffc02014c6:	46050363          	beqz	a0,ffffffffc020192c <default_check+0x662>
ffffffffc02014ca:	4505                	li	a0,1
ffffffffc02014cc:	4a1000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc02014d0:	42051e63          	bnez	a0,ffffffffc020190c <default_check+0x642>
ffffffffc02014d4:	418a1c63          	bne	s4,s8,ffffffffc02018ec <default_check+0x622>
ffffffffc02014d8:	4585                	li	a1,1
ffffffffc02014da:	854e                	mv	a0,s3
ffffffffc02014dc:	4cf000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02014e0:	458d                	li	a1,3
ffffffffc02014e2:	8552                	mv	a0,s4
ffffffffc02014e4:	4c7000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02014e8:	0089b783          	ld	a5,8(s3)
ffffffffc02014ec:	04098c13          	addi	s8,s3,64
ffffffffc02014f0:	8385                	srli	a5,a5,0x1
ffffffffc02014f2:	8b85                	andi	a5,a5,1
ffffffffc02014f4:	3c078c63          	beqz	a5,ffffffffc02018cc <default_check+0x602>
ffffffffc02014f8:	0109a703          	lw	a4,16(s3)
ffffffffc02014fc:	4785                	li	a5,1
ffffffffc02014fe:	3cf71763          	bne	a4,a5,ffffffffc02018cc <default_check+0x602>
ffffffffc0201502:	008a3783          	ld	a5,8(s4)
ffffffffc0201506:	8385                	srli	a5,a5,0x1
ffffffffc0201508:	8b85                	andi	a5,a5,1
ffffffffc020150a:	3a078163          	beqz	a5,ffffffffc02018ac <default_check+0x5e2>
ffffffffc020150e:	010a2703          	lw	a4,16(s4)
ffffffffc0201512:	478d                	li	a5,3
ffffffffc0201514:	38f71c63          	bne	a4,a5,ffffffffc02018ac <default_check+0x5e2>
ffffffffc0201518:	4505                	li	a0,1
ffffffffc020151a:	453000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020151e:	36a99763          	bne	s3,a0,ffffffffc020188c <default_check+0x5c2>
ffffffffc0201522:	4585                	li	a1,1
ffffffffc0201524:	487000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201528:	4509                	li	a0,2
ffffffffc020152a:	443000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc020152e:	32aa1f63          	bne	s4,a0,ffffffffc020186c <default_check+0x5a2>
ffffffffc0201532:	4589                	li	a1,2
ffffffffc0201534:	477000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201538:	4585                	li	a1,1
ffffffffc020153a:	8562                	mv	a0,s8
ffffffffc020153c:	46f000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201540:	4515                	li	a0,5
ffffffffc0201542:	42b000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201546:	89aa                	mv	s3,a0
ffffffffc0201548:	48050263          	beqz	a0,ffffffffc02019cc <default_check+0x702>
ffffffffc020154c:	4505                	li	a0,1
ffffffffc020154e:	41f000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201552:	2c051d63          	bnez	a0,ffffffffc020182c <default_check+0x562>
ffffffffc0201556:	481c                	lw	a5,16(s0)
ffffffffc0201558:	2a079a63          	bnez	a5,ffffffffc020180c <default_check+0x542>
ffffffffc020155c:	4595                	li	a1,5
ffffffffc020155e:	854e                	mv	a0,s3
ffffffffc0201560:	01742823          	sw	s7,16(s0)
ffffffffc0201564:	01643023          	sd	s6,0(s0)
ffffffffc0201568:	01543423          	sd	s5,8(s0)
ffffffffc020156c:	43f000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0201570:	641c                	ld	a5,8(s0)
ffffffffc0201572:	00878963          	beq	a5,s0,ffffffffc0201584 <default_check+0x2ba>
ffffffffc0201576:	ff87a703          	lw	a4,-8(a5)
ffffffffc020157a:	679c                	ld	a5,8(a5)
ffffffffc020157c:	397d                	addiw	s2,s2,-1
ffffffffc020157e:	9c99                	subw	s1,s1,a4
ffffffffc0201580:	fe879be3          	bne	a5,s0,ffffffffc0201576 <default_check+0x2ac>
ffffffffc0201584:	26091463          	bnez	s2,ffffffffc02017ec <default_check+0x522>
ffffffffc0201588:	46049263          	bnez	s1,ffffffffc02019ec <default_check+0x722>
ffffffffc020158c:	60a6                	ld	ra,72(sp)
ffffffffc020158e:	6406                	ld	s0,64(sp)
ffffffffc0201590:	74e2                	ld	s1,56(sp)
ffffffffc0201592:	7942                	ld	s2,48(sp)
ffffffffc0201594:	79a2                	ld	s3,40(sp)
ffffffffc0201596:	7a02                	ld	s4,32(sp)
ffffffffc0201598:	6ae2                	ld	s5,24(sp)
ffffffffc020159a:	6b42                	ld	s6,16(sp)
ffffffffc020159c:	6ba2                	ld	s7,8(sp)
ffffffffc020159e:	6c02                	ld	s8,0(sp)
ffffffffc02015a0:	6161                	addi	sp,sp,80
ffffffffc02015a2:	8082                	ret
ffffffffc02015a4:	4981                	li	s3,0
ffffffffc02015a6:	4481                	li	s1,0
ffffffffc02015a8:	4901                	li	s2,0
ffffffffc02015aa:	b38d                	j	ffffffffc020130c <default_check+0x42>
ffffffffc02015ac:	0000b697          	auipc	a3,0xb
ffffffffc02015b0:	c1468693          	addi	a3,a3,-1004 # ffffffffc020c1c0 <commands+0x950>
ffffffffc02015b4:	0000a617          	auipc	a2,0xa
ffffffffc02015b8:	4cc60613          	addi	a2,a2,1228 # ffffffffc020ba80 <commands+0x210>
ffffffffc02015bc:	0ef00593          	li	a1,239
ffffffffc02015c0:	0000b517          	auipc	a0,0xb
ffffffffc02015c4:	c1050513          	addi	a0,a0,-1008 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02015c8:	ed7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02015cc:	0000b697          	auipc	a3,0xb
ffffffffc02015d0:	c9c68693          	addi	a3,a3,-868 # ffffffffc020c268 <commands+0x9f8>
ffffffffc02015d4:	0000a617          	auipc	a2,0xa
ffffffffc02015d8:	4ac60613          	addi	a2,a2,1196 # ffffffffc020ba80 <commands+0x210>
ffffffffc02015dc:	0bc00593          	li	a1,188
ffffffffc02015e0:	0000b517          	auipc	a0,0xb
ffffffffc02015e4:	bf050513          	addi	a0,a0,-1040 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02015e8:	eb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02015ec:	0000b697          	auipc	a3,0xb
ffffffffc02015f0:	ca468693          	addi	a3,a3,-860 # ffffffffc020c290 <commands+0xa20>
ffffffffc02015f4:	0000a617          	auipc	a2,0xa
ffffffffc02015f8:	48c60613          	addi	a2,a2,1164 # ffffffffc020ba80 <commands+0x210>
ffffffffc02015fc:	0bd00593          	li	a1,189
ffffffffc0201600:	0000b517          	auipc	a0,0xb
ffffffffc0201604:	bd050513          	addi	a0,a0,-1072 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201608:	e97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020160c:	0000b697          	auipc	a3,0xb
ffffffffc0201610:	cc468693          	addi	a3,a3,-828 # ffffffffc020c2d0 <commands+0xa60>
ffffffffc0201614:	0000a617          	auipc	a2,0xa
ffffffffc0201618:	46c60613          	addi	a2,a2,1132 # ffffffffc020ba80 <commands+0x210>
ffffffffc020161c:	0bf00593          	li	a1,191
ffffffffc0201620:	0000b517          	auipc	a0,0xb
ffffffffc0201624:	bb050513          	addi	a0,a0,-1104 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201628:	e77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020162c:	0000b697          	auipc	a3,0xb
ffffffffc0201630:	d2c68693          	addi	a3,a3,-724 # ffffffffc020c358 <commands+0xae8>
ffffffffc0201634:	0000a617          	auipc	a2,0xa
ffffffffc0201638:	44c60613          	addi	a2,a2,1100 # ffffffffc020ba80 <commands+0x210>
ffffffffc020163c:	0d800593          	li	a1,216
ffffffffc0201640:	0000b517          	auipc	a0,0xb
ffffffffc0201644:	b9050513          	addi	a0,a0,-1136 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201648:	e57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020164c:	0000b697          	auipc	a3,0xb
ffffffffc0201650:	bbc68693          	addi	a3,a3,-1092 # ffffffffc020c208 <commands+0x998>
ffffffffc0201654:	0000a617          	auipc	a2,0xa
ffffffffc0201658:	42c60613          	addi	a2,a2,1068 # ffffffffc020ba80 <commands+0x210>
ffffffffc020165c:	0d100593          	li	a1,209
ffffffffc0201660:	0000b517          	auipc	a0,0xb
ffffffffc0201664:	b7050513          	addi	a0,a0,-1168 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201668:	e37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020166c:	0000b697          	auipc	a3,0xb
ffffffffc0201670:	cdc68693          	addi	a3,a3,-804 # ffffffffc020c348 <commands+0xad8>
ffffffffc0201674:	0000a617          	auipc	a2,0xa
ffffffffc0201678:	40c60613          	addi	a2,a2,1036 # ffffffffc020ba80 <commands+0x210>
ffffffffc020167c:	0cf00593          	li	a1,207
ffffffffc0201680:	0000b517          	auipc	a0,0xb
ffffffffc0201684:	b5050513          	addi	a0,a0,-1200 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201688:	e17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020168c:	0000b697          	auipc	a3,0xb
ffffffffc0201690:	ca468693          	addi	a3,a3,-860 # ffffffffc020c330 <commands+0xac0>
ffffffffc0201694:	0000a617          	auipc	a2,0xa
ffffffffc0201698:	3ec60613          	addi	a2,a2,1004 # ffffffffc020ba80 <commands+0x210>
ffffffffc020169c:	0ca00593          	li	a1,202
ffffffffc02016a0:	0000b517          	auipc	a0,0xb
ffffffffc02016a4:	b3050513          	addi	a0,a0,-1232 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02016a8:	df7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016ac:	0000b697          	auipc	a3,0xb
ffffffffc02016b0:	c6468693          	addi	a3,a3,-924 # ffffffffc020c310 <commands+0xaa0>
ffffffffc02016b4:	0000a617          	auipc	a2,0xa
ffffffffc02016b8:	3cc60613          	addi	a2,a2,972 # ffffffffc020ba80 <commands+0x210>
ffffffffc02016bc:	0c100593          	li	a1,193
ffffffffc02016c0:	0000b517          	auipc	a0,0xb
ffffffffc02016c4:	b1050513          	addi	a0,a0,-1264 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02016c8:	dd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016cc:	0000b697          	auipc	a3,0xb
ffffffffc02016d0:	cd468693          	addi	a3,a3,-812 # ffffffffc020c3a0 <commands+0xb30>
ffffffffc02016d4:	0000a617          	auipc	a2,0xa
ffffffffc02016d8:	3ac60613          	addi	a2,a2,940 # ffffffffc020ba80 <commands+0x210>
ffffffffc02016dc:	0f700593          	li	a1,247
ffffffffc02016e0:	0000b517          	auipc	a0,0xb
ffffffffc02016e4:	af050513          	addi	a0,a0,-1296 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02016e8:	db7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02016ec:	0000b697          	auipc	a3,0xb
ffffffffc02016f0:	ca468693          	addi	a3,a3,-860 # ffffffffc020c390 <commands+0xb20>
ffffffffc02016f4:	0000a617          	auipc	a2,0xa
ffffffffc02016f8:	38c60613          	addi	a2,a2,908 # ffffffffc020ba80 <commands+0x210>
ffffffffc02016fc:	0de00593          	li	a1,222
ffffffffc0201700:	0000b517          	auipc	a0,0xb
ffffffffc0201704:	ad050513          	addi	a0,a0,-1328 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201708:	d97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020170c:	0000b697          	auipc	a3,0xb
ffffffffc0201710:	c2468693          	addi	a3,a3,-988 # ffffffffc020c330 <commands+0xac0>
ffffffffc0201714:	0000a617          	auipc	a2,0xa
ffffffffc0201718:	36c60613          	addi	a2,a2,876 # ffffffffc020ba80 <commands+0x210>
ffffffffc020171c:	0dc00593          	li	a1,220
ffffffffc0201720:	0000b517          	auipc	a0,0xb
ffffffffc0201724:	ab050513          	addi	a0,a0,-1360 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201728:	d77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020172c:	0000b697          	auipc	a3,0xb
ffffffffc0201730:	c4468693          	addi	a3,a3,-956 # ffffffffc020c370 <commands+0xb00>
ffffffffc0201734:	0000a617          	auipc	a2,0xa
ffffffffc0201738:	34c60613          	addi	a2,a2,844 # ffffffffc020ba80 <commands+0x210>
ffffffffc020173c:	0db00593          	li	a1,219
ffffffffc0201740:	0000b517          	auipc	a0,0xb
ffffffffc0201744:	a9050513          	addi	a0,a0,-1392 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201748:	d57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020174c:	0000b697          	auipc	a3,0xb
ffffffffc0201750:	abc68693          	addi	a3,a3,-1348 # ffffffffc020c208 <commands+0x998>
ffffffffc0201754:	0000a617          	auipc	a2,0xa
ffffffffc0201758:	32c60613          	addi	a2,a2,812 # ffffffffc020ba80 <commands+0x210>
ffffffffc020175c:	0b800593          	li	a1,184
ffffffffc0201760:	0000b517          	auipc	a0,0xb
ffffffffc0201764:	a7050513          	addi	a0,a0,-1424 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201768:	d37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020176c:	0000b697          	auipc	a3,0xb
ffffffffc0201770:	bc468693          	addi	a3,a3,-1084 # ffffffffc020c330 <commands+0xac0>
ffffffffc0201774:	0000a617          	auipc	a2,0xa
ffffffffc0201778:	30c60613          	addi	a2,a2,780 # ffffffffc020ba80 <commands+0x210>
ffffffffc020177c:	0d500593          	li	a1,213
ffffffffc0201780:	0000b517          	auipc	a0,0xb
ffffffffc0201784:	a5050513          	addi	a0,a0,-1456 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201788:	d17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020178c:	0000b697          	auipc	a3,0xb
ffffffffc0201790:	abc68693          	addi	a3,a3,-1348 # ffffffffc020c248 <commands+0x9d8>
ffffffffc0201794:	0000a617          	auipc	a2,0xa
ffffffffc0201798:	2ec60613          	addi	a2,a2,748 # ffffffffc020ba80 <commands+0x210>
ffffffffc020179c:	0d300593          	li	a1,211
ffffffffc02017a0:	0000b517          	auipc	a0,0xb
ffffffffc02017a4:	a3050513          	addi	a0,a0,-1488 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02017a8:	cf7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017ac:	0000b697          	auipc	a3,0xb
ffffffffc02017b0:	a7c68693          	addi	a3,a3,-1412 # ffffffffc020c228 <commands+0x9b8>
ffffffffc02017b4:	0000a617          	auipc	a2,0xa
ffffffffc02017b8:	2cc60613          	addi	a2,a2,716 # ffffffffc020ba80 <commands+0x210>
ffffffffc02017bc:	0d200593          	li	a1,210
ffffffffc02017c0:	0000b517          	auipc	a0,0xb
ffffffffc02017c4:	a1050513          	addi	a0,a0,-1520 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02017c8:	cd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017cc:	0000b697          	auipc	a3,0xb
ffffffffc02017d0:	a7c68693          	addi	a3,a3,-1412 # ffffffffc020c248 <commands+0x9d8>
ffffffffc02017d4:	0000a617          	auipc	a2,0xa
ffffffffc02017d8:	2ac60613          	addi	a2,a2,684 # ffffffffc020ba80 <commands+0x210>
ffffffffc02017dc:	0ba00593          	li	a1,186
ffffffffc02017e0:	0000b517          	auipc	a0,0xb
ffffffffc02017e4:	9f050513          	addi	a0,a0,-1552 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02017e8:	cb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02017ec:	0000b697          	auipc	a3,0xb
ffffffffc02017f0:	d0468693          	addi	a3,a3,-764 # ffffffffc020c4f0 <commands+0xc80>
ffffffffc02017f4:	0000a617          	auipc	a2,0xa
ffffffffc02017f8:	28c60613          	addi	a2,a2,652 # ffffffffc020ba80 <commands+0x210>
ffffffffc02017fc:	12400593          	li	a1,292
ffffffffc0201800:	0000b517          	auipc	a0,0xb
ffffffffc0201804:	9d050513          	addi	a0,a0,-1584 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201808:	c97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020180c:	0000b697          	auipc	a3,0xb
ffffffffc0201810:	b8468693          	addi	a3,a3,-1148 # ffffffffc020c390 <commands+0xb20>
ffffffffc0201814:	0000a617          	auipc	a2,0xa
ffffffffc0201818:	26c60613          	addi	a2,a2,620 # ffffffffc020ba80 <commands+0x210>
ffffffffc020181c:	11900593          	li	a1,281
ffffffffc0201820:	0000b517          	auipc	a0,0xb
ffffffffc0201824:	9b050513          	addi	a0,a0,-1616 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201828:	c77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020182c:	0000b697          	auipc	a3,0xb
ffffffffc0201830:	b0468693          	addi	a3,a3,-1276 # ffffffffc020c330 <commands+0xac0>
ffffffffc0201834:	0000a617          	auipc	a2,0xa
ffffffffc0201838:	24c60613          	addi	a2,a2,588 # ffffffffc020ba80 <commands+0x210>
ffffffffc020183c:	11700593          	li	a1,279
ffffffffc0201840:	0000b517          	auipc	a0,0xb
ffffffffc0201844:	99050513          	addi	a0,a0,-1648 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201848:	c57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020184c:	0000b697          	auipc	a3,0xb
ffffffffc0201850:	aa468693          	addi	a3,a3,-1372 # ffffffffc020c2f0 <commands+0xa80>
ffffffffc0201854:	0000a617          	auipc	a2,0xa
ffffffffc0201858:	22c60613          	addi	a2,a2,556 # ffffffffc020ba80 <commands+0x210>
ffffffffc020185c:	0c000593          	li	a1,192
ffffffffc0201860:	0000b517          	auipc	a0,0xb
ffffffffc0201864:	97050513          	addi	a0,a0,-1680 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201868:	c37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020186c:	0000b697          	auipc	a3,0xb
ffffffffc0201870:	c4468693          	addi	a3,a3,-956 # ffffffffc020c4b0 <commands+0xc40>
ffffffffc0201874:	0000a617          	auipc	a2,0xa
ffffffffc0201878:	20c60613          	addi	a2,a2,524 # ffffffffc020ba80 <commands+0x210>
ffffffffc020187c:	11100593          	li	a1,273
ffffffffc0201880:	0000b517          	auipc	a0,0xb
ffffffffc0201884:	95050513          	addi	a0,a0,-1712 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201888:	c17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020188c:	0000b697          	auipc	a3,0xb
ffffffffc0201890:	c0468693          	addi	a3,a3,-1020 # ffffffffc020c490 <commands+0xc20>
ffffffffc0201894:	0000a617          	auipc	a2,0xa
ffffffffc0201898:	1ec60613          	addi	a2,a2,492 # ffffffffc020ba80 <commands+0x210>
ffffffffc020189c:	10f00593          	li	a1,271
ffffffffc02018a0:	0000b517          	auipc	a0,0xb
ffffffffc02018a4:	93050513          	addi	a0,a0,-1744 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02018a8:	bf7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018ac:	0000b697          	auipc	a3,0xb
ffffffffc02018b0:	bbc68693          	addi	a3,a3,-1092 # ffffffffc020c468 <commands+0xbf8>
ffffffffc02018b4:	0000a617          	auipc	a2,0xa
ffffffffc02018b8:	1cc60613          	addi	a2,a2,460 # ffffffffc020ba80 <commands+0x210>
ffffffffc02018bc:	10d00593          	li	a1,269
ffffffffc02018c0:	0000b517          	auipc	a0,0xb
ffffffffc02018c4:	91050513          	addi	a0,a0,-1776 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02018c8:	bd7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018cc:	0000b697          	auipc	a3,0xb
ffffffffc02018d0:	b7468693          	addi	a3,a3,-1164 # ffffffffc020c440 <commands+0xbd0>
ffffffffc02018d4:	0000a617          	auipc	a2,0xa
ffffffffc02018d8:	1ac60613          	addi	a2,a2,428 # ffffffffc020ba80 <commands+0x210>
ffffffffc02018dc:	10c00593          	li	a1,268
ffffffffc02018e0:	0000b517          	auipc	a0,0xb
ffffffffc02018e4:	8f050513          	addi	a0,a0,-1808 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02018e8:	bb7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02018ec:	0000b697          	auipc	a3,0xb
ffffffffc02018f0:	b4468693          	addi	a3,a3,-1212 # ffffffffc020c430 <commands+0xbc0>
ffffffffc02018f4:	0000a617          	auipc	a2,0xa
ffffffffc02018f8:	18c60613          	addi	a2,a2,396 # ffffffffc020ba80 <commands+0x210>
ffffffffc02018fc:	10700593          	li	a1,263
ffffffffc0201900:	0000b517          	auipc	a0,0xb
ffffffffc0201904:	8d050513          	addi	a0,a0,-1840 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201908:	b97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020190c:	0000b697          	auipc	a3,0xb
ffffffffc0201910:	a2468693          	addi	a3,a3,-1500 # ffffffffc020c330 <commands+0xac0>
ffffffffc0201914:	0000a617          	auipc	a2,0xa
ffffffffc0201918:	16c60613          	addi	a2,a2,364 # ffffffffc020ba80 <commands+0x210>
ffffffffc020191c:	10600593          	li	a1,262
ffffffffc0201920:	0000b517          	auipc	a0,0xb
ffffffffc0201924:	8b050513          	addi	a0,a0,-1872 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201928:	b77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020192c:	0000b697          	auipc	a3,0xb
ffffffffc0201930:	ae468693          	addi	a3,a3,-1308 # ffffffffc020c410 <commands+0xba0>
ffffffffc0201934:	0000a617          	auipc	a2,0xa
ffffffffc0201938:	14c60613          	addi	a2,a2,332 # ffffffffc020ba80 <commands+0x210>
ffffffffc020193c:	10500593          	li	a1,261
ffffffffc0201940:	0000b517          	auipc	a0,0xb
ffffffffc0201944:	89050513          	addi	a0,a0,-1904 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201948:	b57fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020194c:	0000b697          	auipc	a3,0xb
ffffffffc0201950:	a9468693          	addi	a3,a3,-1388 # ffffffffc020c3e0 <commands+0xb70>
ffffffffc0201954:	0000a617          	auipc	a2,0xa
ffffffffc0201958:	12c60613          	addi	a2,a2,300 # ffffffffc020ba80 <commands+0x210>
ffffffffc020195c:	10400593          	li	a1,260
ffffffffc0201960:	0000b517          	auipc	a0,0xb
ffffffffc0201964:	87050513          	addi	a0,a0,-1936 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201968:	b37fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020196c:	0000b697          	auipc	a3,0xb
ffffffffc0201970:	a5c68693          	addi	a3,a3,-1444 # ffffffffc020c3c8 <commands+0xb58>
ffffffffc0201974:	0000a617          	auipc	a2,0xa
ffffffffc0201978:	10c60613          	addi	a2,a2,268 # ffffffffc020ba80 <commands+0x210>
ffffffffc020197c:	10300593          	li	a1,259
ffffffffc0201980:	0000b517          	auipc	a0,0xb
ffffffffc0201984:	85050513          	addi	a0,a0,-1968 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201988:	b17fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020198c:	0000b697          	auipc	a3,0xb
ffffffffc0201990:	9a468693          	addi	a3,a3,-1628 # ffffffffc020c330 <commands+0xac0>
ffffffffc0201994:	0000a617          	auipc	a2,0xa
ffffffffc0201998:	0ec60613          	addi	a2,a2,236 # ffffffffc020ba80 <commands+0x210>
ffffffffc020199c:	0fd00593          	li	a1,253
ffffffffc02019a0:	0000b517          	auipc	a0,0xb
ffffffffc02019a4:	83050513          	addi	a0,a0,-2000 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02019a8:	af7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019ac:	0000b697          	auipc	a3,0xb
ffffffffc02019b0:	a0468693          	addi	a3,a3,-1532 # ffffffffc020c3b0 <commands+0xb40>
ffffffffc02019b4:	0000a617          	auipc	a2,0xa
ffffffffc02019b8:	0cc60613          	addi	a2,a2,204 # ffffffffc020ba80 <commands+0x210>
ffffffffc02019bc:	0f800593          	li	a1,248
ffffffffc02019c0:	0000b517          	auipc	a0,0xb
ffffffffc02019c4:	81050513          	addi	a0,a0,-2032 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02019c8:	ad7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019cc:	0000b697          	auipc	a3,0xb
ffffffffc02019d0:	b0468693          	addi	a3,a3,-1276 # ffffffffc020c4d0 <commands+0xc60>
ffffffffc02019d4:	0000a617          	auipc	a2,0xa
ffffffffc02019d8:	0ac60613          	addi	a2,a2,172 # ffffffffc020ba80 <commands+0x210>
ffffffffc02019dc:	11600593          	li	a1,278
ffffffffc02019e0:	0000a517          	auipc	a0,0xa
ffffffffc02019e4:	7f050513          	addi	a0,a0,2032 # ffffffffc020c1d0 <commands+0x960>
ffffffffc02019e8:	ab7fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02019ec:	0000b697          	auipc	a3,0xb
ffffffffc02019f0:	b1468693          	addi	a3,a3,-1260 # ffffffffc020c500 <commands+0xc90>
ffffffffc02019f4:	0000a617          	auipc	a2,0xa
ffffffffc02019f8:	08c60613          	addi	a2,a2,140 # ffffffffc020ba80 <commands+0x210>
ffffffffc02019fc:	12500593          	li	a1,293
ffffffffc0201a00:	0000a517          	auipc	a0,0xa
ffffffffc0201a04:	7d050513          	addi	a0,a0,2000 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201a08:	a97fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a0c:	0000a697          	auipc	a3,0xa
ffffffffc0201a10:	7dc68693          	addi	a3,a3,2012 # ffffffffc020c1e8 <commands+0x978>
ffffffffc0201a14:	0000a617          	auipc	a2,0xa
ffffffffc0201a18:	06c60613          	addi	a2,a2,108 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201a1c:	0f200593          	li	a1,242
ffffffffc0201a20:	0000a517          	auipc	a0,0xa
ffffffffc0201a24:	7b050513          	addi	a0,a0,1968 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201a28:	a77fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201a2c:	0000a697          	auipc	a3,0xa
ffffffffc0201a30:	7fc68693          	addi	a3,a3,2044 # ffffffffc020c228 <commands+0x9b8>
ffffffffc0201a34:	0000a617          	auipc	a2,0xa
ffffffffc0201a38:	04c60613          	addi	a2,a2,76 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201a3c:	0b900593          	li	a1,185
ffffffffc0201a40:	0000a517          	auipc	a0,0xa
ffffffffc0201a44:	79050513          	addi	a0,a0,1936 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201a48:	a57fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201a4c <default_free_pages>:
ffffffffc0201a4c:	1141                	addi	sp,sp,-16
ffffffffc0201a4e:	e406                	sd	ra,8(sp)
ffffffffc0201a50:	14058463          	beqz	a1,ffffffffc0201b98 <default_free_pages+0x14c>
ffffffffc0201a54:	00659693          	slli	a3,a1,0x6
ffffffffc0201a58:	96aa                	add	a3,a3,a0
ffffffffc0201a5a:	87aa                	mv	a5,a0
ffffffffc0201a5c:	02d50263          	beq	a0,a3,ffffffffc0201a80 <default_free_pages+0x34>
ffffffffc0201a60:	6798                	ld	a4,8(a5)
ffffffffc0201a62:	8b05                	andi	a4,a4,1
ffffffffc0201a64:	10071a63          	bnez	a4,ffffffffc0201b78 <default_free_pages+0x12c>
ffffffffc0201a68:	6798                	ld	a4,8(a5)
ffffffffc0201a6a:	8b09                	andi	a4,a4,2
ffffffffc0201a6c:	10071663          	bnez	a4,ffffffffc0201b78 <default_free_pages+0x12c>
ffffffffc0201a70:	0007b423          	sd	zero,8(a5)
ffffffffc0201a74:	0007a023          	sw	zero,0(a5)
ffffffffc0201a78:	04078793          	addi	a5,a5,64
ffffffffc0201a7c:	fed792e3          	bne	a5,a3,ffffffffc0201a60 <default_free_pages+0x14>
ffffffffc0201a80:	2581                	sext.w	a1,a1
ffffffffc0201a82:	c90c                	sw	a1,16(a0)
ffffffffc0201a84:	00850893          	addi	a7,a0,8
ffffffffc0201a88:	4789                	li	a5,2
ffffffffc0201a8a:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201a8e:	00090697          	auipc	a3,0x90
ffffffffc0201a92:	d1a68693          	addi	a3,a3,-742 # ffffffffc02917a8 <free_area>
ffffffffc0201a96:	4a98                	lw	a4,16(a3)
ffffffffc0201a98:	669c                	ld	a5,8(a3)
ffffffffc0201a9a:	01850613          	addi	a2,a0,24
ffffffffc0201a9e:	9db9                	addw	a1,a1,a4
ffffffffc0201aa0:	ca8c                	sw	a1,16(a3)
ffffffffc0201aa2:	0ad78463          	beq	a5,a3,ffffffffc0201b4a <default_free_pages+0xfe>
ffffffffc0201aa6:	fe878713          	addi	a4,a5,-24
ffffffffc0201aaa:	0006b803          	ld	a6,0(a3)
ffffffffc0201aae:	4581                	li	a1,0
ffffffffc0201ab0:	00e56a63          	bltu	a0,a4,ffffffffc0201ac4 <default_free_pages+0x78>
ffffffffc0201ab4:	6798                	ld	a4,8(a5)
ffffffffc0201ab6:	04d70c63          	beq	a4,a3,ffffffffc0201b0e <default_free_pages+0xc2>
ffffffffc0201aba:	87ba                	mv	a5,a4
ffffffffc0201abc:	fe878713          	addi	a4,a5,-24
ffffffffc0201ac0:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ab4 <default_free_pages+0x68>
ffffffffc0201ac4:	c199                	beqz	a1,ffffffffc0201aca <default_free_pages+0x7e>
ffffffffc0201ac6:	0106b023          	sd	a6,0(a3)
ffffffffc0201aca:	6398                	ld	a4,0(a5)
ffffffffc0201acc:	e390                	sd	a2,0(a5)
ffffffffc0201ace:	e710                	sd	a2,8(a4)
ffffffffc0201ad0:	f11c                	sd	a5,32(a0)
ffffffffc0201ad2:	ed18                	sd	a4,24(a0)
ffffffffc0201ad4:	00d70d63          	beq	a4,a3,ffffffffc0201aee <default_free_pages+0xa2>
ffffffffc0201ad8:	ff872583          	lw	a1,-8(a4)
ffffffffc0201adc:	fe870613          	addi	a2,a4,-24
ffffffffc0201ae0:	02059813          	slli	a6,a1,0x20
ffffffffc0201ae4:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201ae8:	97b2                	add	a5,a5,a2
ffffffffc0201aea:	02f50c63          	beq	a0,a5,ffffffffc0201b22 <default_free_pages+0xd6>
ffffffffc0201aee:	711c                	ld	a5,32(a0)
ffffffffc0201af0:	00d78c63          	beq	a5,a3,ffffffffc0201b08 <default_free_pages+0xbc>
ffffffffc0201af4:	4910                	lw	a2,16(a0)
ffffffffc0201af6:	fe878693          	addi	a3,a5,-24
ffffffffc0201afa:	02061593          	slli	a1,a2,0x20
ffffffffc0201afe:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201b02:	972a                	add	a4,a4,a0
ffffffffc0201b04:	04e68a63          	beq	a3,a4,ffffffffc0201b58 <default_free_pages+0x10c>
ffffffffc0201b08:	60a2                	ld	ra,8(sp)
ffffffffc0201b0a:	0141                	addi	sp,sp,16
ffffffffc0201b0c:	8082                	ret
ffffffffc0201b0e:	e790                	sd	a2,8(a5)
ffffffffc0201b10:	f114                	sd	a3,32(a0)
ffffffffc0201b12:	6798                	ld	a4,8(a5)
ffffffffc0201b14:	ed1c                	sd	a5,24(a0)
ffffffffc0201b16:	02d70763          	beq	a4,a3,ffffffffc0201b44 <default_free_pages+0xf8>
ffffffffc0201b1a:	8832                	mv	a6,a2
ffffffffc0201b1c:	4585                	li	a1,1
ffffffffc0201b1e:	87ba                	mv	a5,a4
ffffffffc0201b20:	bf71                	j	ffffffffc0201abc <default_free_pages+0x70>
ffffffffc0201b22:	491c                	lw	a5,16(a0)
ffffffffc0201b24:	9dbd                	addw	a1,a1,a5
ffffffffc0201b26:	feb72c23          	sw	a1,-8(a4)
ffffffffc0201b2a:	57f5                	li	a5,-3
ffffffffc0201b2c:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc0201b30:	01853803          	ld	a6,24(a0)
ffffffffc0201b34:	710c                	ld	a1,32(a0)
ffffffffc0201b36:	8532                	mv	a0,a2
ffffffffc0201b38:	00b83423          	sd	a1,8(a6)
ffffffffc0201b3c:	671c                	ld	a5,8(a4)
ffffffffc0201b3e:	0105b023          	sd	a6,0(a1)
ffffffffc0201b42:	b77d                	j	ffffffffc0201af0 <default_free_pages+0xa4>
ffffffffc0201b44:	e290                	sd	a2,0(a3)
ffffffffc0201b46:	873e                	mv	a4,a5
ffffffffc0201b48:	bf41                	j	ffffffffc0201ad8 <default_free_pages+0x8c>
ffffffffc0201b4a:	60a2                	ld	ra,8(sp)
ffffffffc0201b4c:	e390                	sd	a2,0(a5)
ffffffffc0201b4e:	e790                	sd	a2,8(a5)
ffffffffc0201b50:	f11c                	sd	a5,32(a0)
ffffffffc0201b52:	ed1c                	sd	a5,24(a0)
ffffffffc0201b54:	0141                	addi	sp,sp,16
ffffffffc0201b56:	8082                	ret
ffffffffc0201b58:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201b5c:	ff078693          	addi	a3,a5,-16
ffffffffc0201b60:	9e39                	addw	a2,a2,a4
ffffffffc0201b62:	c910                	sw	a2,16(a0)
ffffffffc0201b64:	5775                	li	a4,-3
ffffffffc0201b66:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc0201b6a:	6398                	ld	a4,0(a5)
ffffffffc0201b6c:	679c                	ld	a5,8(a5)
ffffffffc0201b6e:	60a2                	ld	ra,8(sp)
ffffffffc0201b70:	e71c                	sd	a5,8(a4)
ffffffffc0201b72:	e398                	sd	a4,0(a5)
ffffffffc0201b74:	0141                	addi	sp,sp,16
ffffffffc0201b76:	8082                	ret
ffffffffc0201b78:	0000b697          	auipc	a3,0xb
ffffffffc0201b7c:	9a068693          	addi	a3,a3,-1632 # ffffffffc020c518 <commands+0xca8>
ffffffffc0201b80:	0000a617          	auipc	a2,0xa
ffffffffc0201b84:	f0060613          	addi	a2,a2,-256 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201b88:	08200593          	li	a1,130
ffffffffc0201b8c:	0000a517          	auipc	a0,0xa
ffffffffc0201b90:	64450513          	addi	a0,a0,1604 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201b94:	90bfe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201b98:	0000b697          	auipc	a3,0xb
ffffffffc0201b9c:	97868693          	addi	a3,a3,-1672 # ffffffffc020c510 <commands+0xca0>
ffffffffc0201ba0:	0000a617          	auipc	a2,0xa
ffffffffc0201ba4:	ee060613          	addi	a2,a2,-288 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201ba8:	07f00593          	li	a1,127
ffffffffc0201bac:	0000a517          	auipc	a0,0xa
ffffffffc0201bb0:	62450513          	addi	a0,a0,1572 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201bb4:	8ebfe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201bb8 <default_alloc_pages>:
ffffffffc0201bb8:	c941                	beqz	a0,ffffffffc0201c48 <default_alloc_pages+0x90>
ffffffffc0201bba:	00090597          	auipc	a1,0x90
ffffffffc0201bbe:	bee58593          	addi	a1,a1,-1042 # ffffffffc02917a8 <free_area>
ffffffffc0201bc2:	0105a803          	lw	a6,16(a1)
ffffffffc0201bc6:	872a                	mv	a4,a0
ffffffffc0201bc8:	02081793          	slli	a5,a6,0x20
ffffffffc0201bcc:	9381                	srli	a5,a5,0x20
ffffffffc0201bce:	00a7ee63          	bltu	a5,a0,ffffffffc0201bea <default_alloc_pages+0x32>
ffffffffc0201bd2:	87ae                	mv	a5,a1
ffffffffc0201bd4:	a801                	j	ffffffffc0201be4 <default_alloc_pages+0x2c>
ffffffffc0201bd6:	ff87a683          	lw	a3,-8(a5)
ffffffffc0201bda:	02069613          	slli	a2,a3,0x20
ffffffffc0201bde:	9201                	srli	a2,a2,0x20
ffffffffc0201be0:	00e67763          	bgeu	a2,a4,ffffffffc0201bee <default_alloc_pages+0x36>
ffffffffc0201be4:	679c                	ld	a5,8(a5)
ffffffffc0201be6:	feb798e3          	bne	a5,a1,ffffffffc0201bd6 <default_alloc_pages+0x1e>
ffffffffc0201bea:	4501                	li	a0,0
ffffffffc0201bec:	8082                	ret
ffffffffc0201bee:	0007b883          	ld	a7,0(a5)
ffffffffc0201bf2:	0087b303          	ld	t1,8(a5)
ffffffffc0201bf6:	fe878513          	addi	a0,a5,-24
ffffffffc0201bfa:	00070e1b          	sext.w	t3,a4
ffffffffc0201bfe:	0068b423          	sd	t1,8(a7) # 10000008 <_binary_bin_sfs_img_size+0xff8ad08>
ffffffffc0201c02:	01133023          	sd	a7,0(t1)
ffffffffc0201c06:	02c77863          	bgeu	a4,a2,ffffffffc0201c36 <default_alloc_pages+0x7e>
ffffffffc0201c0a:	071a                	slli	a4,a4,0x6
ffffffffc0201c0c:	972a                	add	a4,a4,a0
ffffffffc0201c0e:	41c686bb          	subw	a3,a3,t3
ffffffffc0201c12:	cb14                	sw	a3,16(a4)
ffffffffc0201c14:	00870613          	addi	a2,a4,8
ffffffffc0201c18:	4689                	li	a3,2
ffffffffc0201c1a:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc0201c1e:	0088b683          	ld	a3,8(a7)
ffffffffc0201c22:	01870613          	addi	a2,a4,24
ffffffffc0201c26:	0105a803          	lw	a6,16(a1)
ffffffffc0201c2a:	e290                	sd	a2,0(a3)
ffffffffc0201c2c:	00c8b423          	sd	a2,8(a7)
ffffffffc0201c30:	f314                	sd	a3,32(a4)
ffffffffc0201c32:	01173c23          	sd	a7,24(a4)
ffffffffc0201c36:	41c8083b          	subw	a6,a6,t3
ffffffffc0201c3a:	0105a823          	sw	a6,16(a1)
ffffffffc0201c3e:	5775                	li	a4,-3
ffffffffc0201c40:	17c1                	addi	a5,a5,-16
ffffffffc0201c42:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201c46:	8082                	ret
ffffffffc0201c48:	1141                	addi	sp,sp,-16
ffffffffc0201c4a:	0000b697          	auipc	a3,0xb
ffffffffc0201c4e:	8c668693          	addi	a3,a3,-1850 # ffffffffc020c510 <commands+0xca0>
ffffffffc0201c52:	0000a617          	auipc	a2,0xa
ffffffffc0201c56:	e2e60613          	addi	a2,a2,-466 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201c5a:	06100593          	li	a1,97
ffffffffc0201c5e:	0000a517          	auipc	a0,0xa
ffffffffc0201c62:	57250513          	addi	a0,a0,1394 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201c66:	e406                	sd	ra,8(sp)
ffffffffc0201c68:	837fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201c6c <default_init_memmap>:
ffffffffc0201c6c:	1141                	addi	sp,sp,-16
ffffffffc0201c6e:	e406                	sd	ra,8(sp)
ffffffffc0201c70:	c5f1                	beqz	a1,ffffffffc0201d3c <default_init_memmap+0xd0>
ffffffffc0201c72:	00659693          	slli	a3,a1,0x6
ffffffffc0201c76:	96aa                	add	a3,a3,a0
ffffffffc0201c78:	87aa                	mv	a5,a0
ffffffffc0201c7a:	00d50f63          	beq	a0,a3,ffffffffc0201c98 <default_init_memmap+0x2c>
ffffffffc0201c7e:	6798                	ld	a4,8(a5)
ffffffffc0201c80:	8b05                	andi	a4,a4,1
ffffffffc0201c82:	cf49                	beqz	a4,ffffffffc0201d1c <default_init_memmap+0xb0>
ffffffffc0201c84:	0007a823          	sw	zero,16(a5)
ffffffffc0201c88:	0007b423          	sd	zero,8(a5)
ffffffffc0201c8c:	0007a023          	sw	zero,0(a5)
ffffffffc0201c90:	04078793          	addi	a5,a5,64
ffffffffc0201c94:	fed795e3          	bne	a5,a3,ffffffffc0201c7e <default_init_memmap+0x12>
ffffffffc0201c98:	2581                	sext.w	a1,a1
ffffffffc0201c9a:	c90c                	sw	a1,16(a0)
ffffffffc0201c9c:	4789                	li	a5,2
ffffffffc0201c9e:	00850713          	addi	a4,a0,8
ffffffffc0201ca2:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201ca6:	00090697          	auipc	a3,0x90
ffffffffc0201caa:	b0268693          	addi	a3,a3,-1278 # ffffffffc02917a8 <free_area>
ffffffffc0201cae:	4a98                	lw	a4,16(a3)
ffffffffc0201cb0:	669c                	ld	a5,8(a3)
ffffffffc0201cb2:	01850613          	addi	a2,a0,24
ffffffffc0201cb6:	9db9                	addw	a1,a1,a4
ffffffffc0201cb8:	ca8c                	sw	a1,16(a3)
ffffffffc0201cba:	04d78a63          	beq	a5,a3,ffffffffc0201d0e <default_init_memmap+0xa2>
ffffffffc0201cbe:	fe878713          	addi	a4,a5,-24
ffffffffc0201cc2:	0006b803          	ld	a6,0(a3)
ffffffffc0201cc6:	4581                	li	a1,0
ffffffffc0201cc8:	00e56a63          	bltu	a0,a4,ffffffffc0201cdc <default_init_memmap+0x70>
ffffffffc0201ccc:	6798                	ld	a4,8(a5)
ffffffffc0201cce:	02d70263          	beq	a4,a3,ffffffffc0201cf2 <default_init_memmap+0x86>
ffffffffc0201cd2:	87ba                	mv	a5,a4
ffffffffc0201cd4:	fe878713          	addi	a4,a5,-24
ffffffffc0201cd8:	fee57ae3          	bgeu	a0,a4,ffffffffc0201ccc <default_init_memmap+0x60>
ffffffffc0201cdc:	c199                	beqz	a1,ffffffffc0201ce2 <default_init_memmap+0x76>
ffffffffc0201cde:	0106b023          	sd	a6,0(a3)
ffffffffc0201ce2:	6398                	ld	a4,0(a5)
ffffffffc0201ce4:	60a2                	ld	ra,8(sp)
ffffffffc0201ce6:	e390                	sd	a2,0(a5)
ffffffffc0201ce8:	e710                	sd	a2,8(a4)
ffffffffc0201cea:	f11c                	sd	a5,32(a0)
ffffffffc0201cec:	ed18                	sd	a4,24(a0)
ffffffffc0201cee:	0141                	addi	sp,sp,16
ffffffffc0201cf0:	8082                	ret
ffffffffc0201cf2:	e790                	sd	a2,8(a5)
ffffffffc0201cf4:	f114                	sd	a3,32(a0)
ffffffffc0201cf6:	6798                	ld	a4,8(a5)
ffffffffc0201cf8:	ed1c                	sd	a5,24(a0)
ffffffffc0201cfa:	00d70663          	beq	a4,a3,ffffffffc0201d06 <default_init_memmap+0x9a>
ffffffffc0201cfe:	8832                	mv	a6,a2
ffffffffc0201d00:	4585                	li	a1,1
ffffffffc0201d02:	87ba                	mv	a5,a4
ffffffffc0201d04:	bfc1                	j	ffffffffc0201cd4 <default_init_memmap+0x68>
ffffffffc0201d06:	60a2                	ld	ra,8(sp)
ffffffffc0201d08:	e290                	sd	a2,0(a3)
ffffffffc0201d0a:	0141                	addi	sp,sp,16
ffffffffc0201d0c:	8082                	ret
ffffffffc0201d0e:	60a2                	ld	ra,8(sp)
ffffffffc0201d10:	e390                	sd	a2,0(a5)
ffffffffc0201d12:	e790                	sd	a2,8(a5)
ffffffffc0201d14:	f11c                	sd	a5,32(a0)
ffffffffc0201d16:	ed1c                	sd	a5,24(a0)
ffffffffc0201d18:	0141                	addi	sp,sp,16
ffffffffc0201d1a:	8082                	ret
ffffffffc0201d1c:	0000b697          	auipc	a3,0xb
ffffffffc0201d20:	82468693          	addi	a3,a3,-2012 # ffffffffc020c540 <commands+0xcd0>
ffffffffc0201d24:	0000a617          	auipc	a2,0xa
ffffffffc0201d28:	d5c60613          	addi	a2,a2,-676 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201d2c:	04800593          	li	a1,72
ffffffffc0201d30:	0000a517          	auipc	a0,0xa
ffffffffc0201d34:	4a050513          	addi	a0,a0,1184 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201d38:	f66fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0201d3c:	0000a697          	auipc	a3,0xa
ffffffffc0201d40:	7d468693          	addi	a3,a3,2004 # ffffffffc020c510 <commands+0xca0>
ffffffffc0201d44:	0000a617          	auipc	a2,0xa
ffffffffc0201d48:	d3c60613          	addi	a2,a2,-708 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201d4c:	04500593          	li	a1,69
ffffffffc0201d50:	0000a517          	auipc	a0,0xa
ffffffffc0201d54:	48050513          	addi	a0,a0,1152 # ffffffffc020c1d0 <commands+0x960>
ffffffffc0201d58:	f46fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201d5c <slob_free>:
ffffffffc0201d5c:	c94d                	beqz	a0,ffffffffc0201e0e <slob_free+0xb2>
ffffffffc0201d5e:	1141                	addi	sp,sp,-16
ffffffffc0201d60:	e022                	sd	s0,0(sp)
ffffffffc0201d62:	e406                	sd	ra,8(sp)
ffffffffc0201d64:	842a                	mv	s0,a0
ffffffffc0201d66:	e9c1                	bnez	a1,ffffffffc0201df6 <slob_free+0x9a>
ffffffffc0201d68:	100027f3          	csrr	a5,sstatus
ffffffffc0201d6c:	8b89                	andi	a5,a5,2
ffffffffc0201d6e:	4501                	li	a0,0
ffffffffc0201d70:	ebd9                	bnez	a5,ffffffffc0201e06 <slob_free+0xaa>
ffffffffc0201d72:	0008f617          	auipc	a2,0x8f
ffffffffc0201d76:	2de60613          	addi	a2,a2,734 # ffffffffc0291050 <slobfree>
ffffffffc0201d7a:	621c                	ld	a5,0(a2)
ffffffffc0201d7c:	873e                	mv	a4,a5
ffffffffc0201d7e:	679c                	ld	a5,8(a5)
ffffffffc0201d80:	02877a63          	bgeu	a4,s0,ffffffffc0201db4 <slob_free+0x58>
ffffffffc0201d84:	00f46463          	bltu	s0,a5,ffffffffc0201d8c <slob_free+0x30>
ffffffffc0201d88:	fef76ae3          	bltu	a4,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201d8c:	400c                	lw	a1,0(s0)
ffffffffc0201d8e:	00459693          	slli	a3,a1,0x4
ffffffffc0201d92:	96a2                	add	a3,a3,s0
ffffffffc0201d94:	02d78a63          	beq	a5,a3,ffffffffc0201dc8 <slob_free+0x6c>
ffffffffc0201d98:	4314                	lw	a3,0(a4)
ffffffffc0201d9a:	e41c                	sd	a5,8(s0)
ffffffffc0201d9c:	00469793          	slli	a5,a3,0x4
ffffffffc0201da0:	97ba                	add	a5,a5,a4
ffffffffc0201da2:	02f40e63          	beq	s0,a5,ffffffffc0201dde <slob_free+0x82>
ffffffffc0201da6:	e700                	sd	s0,8(a4)
ffffffffc0201da8:	e218                	sd	a4,0(a2)
ffffffffc0201daa:	e129                	bnez	a0,ffffffffc0201dec <slob_free+0x90>
ffffffffc0201dac:	60a2                	ld	ra,8(sp)
ffffffffc0201dae:	6402                	ld	s0,0(sp)
ffffffffc0201db0:	0141                	addi	sp,sp,16
ffffffffc0201db2:	8082                	ret
ffffffffc0201db4:	fcf764e3          	bltu	a4,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201db8:	fcf472e3          	bgeu	s0,a5,ffffffffc0201d7c <slob_free+0x20>
ffffffffc0201dbc:	400c                	lw	a1,0(s0)
ffffffffc0201dbe:	00459693          	slli	a3,a1,0x4
ffffffffc0201dc2:	96a2                	add	a3,a3,s0
ffffffffc0201dc4:	fcd79ae3          	bne	a5,a3,ffffffffc0201d98 <slob_free+0x3c>
ffffffffc0201dc8:	4394                	lw	a3,0(a5)
ffffffffc0201dca:	679c                	ld	a5,8(a5)
ffffffffc0201dcc:	9db5                	addw	a1,a1,a3
ffffffffc0201dce:	c00c                	sw	a1,0(s0)
ffffffffc0201dd0:	4314                	lw	a3,0(a4)
ffffffffc0201dd2:	e41c                	sd	a5,8(s0)
ffffffffc0201dd4:	00469793          	slli	a5,a3,0x4
ffffffffc0201dd8:	97ba                	add	a5,a5,a4
ffffffffc0201dda:	fcf416e3          	bne	s0,a5,ffffffffc0201da6 <slob_free+0x4a>
ffffffffc0201dde:	401c                	lw	a5,0(s0)
ffffffffc0201de0:	640c                	ld	a1,8(s0)
ffffffffc0201de2:	e218                	sd	a4,0(a2)
ffffffffc0201de4:	9ebd                	addw	a3,a3,a5
ffffffffc0201de6:	c314                	sw	a3,0(a4)
ffffffffc0201de8:	e70c                	sd	a1,8(a4)
ffffffffc0201dea:	d169                	beqz	a0,ffffffffc0201dac <slob_free+0x50>
ffffffffc0201dec:	6402                	ld	s0,0(sp)
ffffffffc0201dee:	60a2                	ld	ra,8(sp)
ffffffffc0201df0:	0141                	addi	sp,sp,16
ffffffffc0201df2:	e7bfe06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0201df6:	25bd                	addiw	a1,a1,15
ffffffffc0201df8:	8191                	srli	a1,a1,0x4
ffffffffc0201dfa:	c10c                	sw	a1,0(a0)
ffffffffc0201dfc:	100027f3          	csrr	a5,sstatus
ffffffffc0201e00:	8b89                	andi	a5,a5,2
ffffffffc0201e02:	4501                	li	a0,0
ffffffffc0201e04:	d7bd                	beqz	a5,ffffffffc0201d72 <slob_free+0x16>
ffffffffc0201e06:	e6dfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201e0a:	4505                	li	a0,1
ffffffffc0201e0c:	b79d                	j	ffffffffc0201d72 <slob_free+0x16>
ffffffffc0201e0e:	8082                	ret

ffffffffc0201e10 <__slob_get_free_pages.constprop.0>:
ffffffffc0201e10:	4785                	li	a5,1
ffffffffc0201e12:	1141                	addi	sp,sp,-16
ffffffffc0201e14:	00a7953b          	sllw	a0,a5,a0
ffffffffc0201e18:	e406                	sd	ra,8(sp)
ffffffffc0201e1a:	352000ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0201e1e:	c91d                	beqz	a0,ffffffffc0201e54 <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0201e20:	00095697          	auipc	a3,0x95
ffffffffc0201e24:	a886b683          	ld	a3,-1400(a3) # ffffffffc02968a8 <pages>
ffffffffc0201e28:	8d15                	sub	a0,a0,a3
ffffffffc0201e2a:	8519                	srai	a0,a0,0x6
ffffffffc0201e2c:	0000e697          	auipc	a3,0xe
ffffffffc0201e30:	aa46b683          	ld	a3,-1372(a3) # ffffffffc020f8d0 <nbase>
ffffffffc0201e34:	9536                	add	a0,a0,a3
ffffffffc0201e36:	00c51793          	slli	a5,a0,0xc
ffffffffc0201e3a:	83b1                	srli	a5,a5,0xc
ffffffffc0201e3c:	00095717          	auipc	a4,0x95
ffffffffc0201e40:	a6473703          	ld	a4,-1436(a4) # ffffffffc02968a0 <npage>
ffffffffc0201e44:	0532                	slli	a0,a0,0xc
ffffffffc0201e46:	00e7fa63          	bgeu	a5,a4,ffffffffc0201e5a <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0201e4a:	00095697          	auipc	a3,0x95
ffffffffc0201e4e:	a6e6b683          	ld	a3,-1426(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0201e52:	9536                	add	a0,a0,a3
ffffffffc0201e54:	60a2                	ld	ra,8(sp)
ffffffffc0201e56:	0141                	addi	sp,sp,16
ffffffffc0201e58:	8082                	ret
ffffffffc0201e5a:	86aa                	mv	a3,a0
ffffffffc0201e5c:	0000a617          	auipc	a2,0xa
ffffffffc0201e60:	74460613          	addi	a2,a2,1860 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0201e64:	07100593          	li	a1,113
ffffffffc0201e68:	0000a517          	auipc	a0,0xa
ffffffffc0201e6c:	76050513          	addi	a0,a0,1888 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0201e70:	e2efe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201e74 <slob_alloc.constprop.0>:
ffffffffc0201e74:	1101                	addi	sp,sp,-32
ffffffffc0201e76:	ec06                	sd	ra,24(sp)
ffffffffc0201e78:	e822                	sd	s0,16(sp)
ffffffffc0201e7a:	e426                	sd	s1,8(sp)
ffffffffc0201e7c:	e04a                	sd	s2,0(sp)
ffffffffc0201e7e:	01050713          	addi	a4,a0,16
ffffffffc0201e82:	6785                	lui	a5,0x1
ffffffffc0201e84:	0cf77363          	bgeu	a4,a5,ffffffffc0201f4a <slob_alloc.constprop.0+0xd6>
ffffffffc0201e88:	00f50493          	addi	s1,a0,15
ffffffffc0201e8c:	8091                	srli	s1,s1,0x4
ffffffffc0201e8e:	2481                	sext.w	s1,s1
ffffffffc0201e90:	10002673          	csrr	a2,sstatus
ffffffffc0201e94:	8a09                	andi	a2,a2,2
ffffffffc0201e96:	e25d                	bnez	a2,ffffffffc0201f3c <slob_alloc.constprop.0+0xc8>
ffffffffc0201e98:	0008f917          	auipc	s2,0x8f
ffffffffc0201e9c:	1b890913          	addi	s2,s2,440 # ffffffffc0291050 <slobfree>
ffffffffc0201ea0:	00093683          	ld	a3,0(s2)
ffffffffc0201ea4:	669c                	ld	a5,8(a3)
ffffffffc0201ea6:	4398                	lw	a4,0(a5)
ffffffffc0201ea8:	08975e63          	bge	a4,s1,ffffffffc0201f44 <slob_alloc.constprop.0+0xd0>
ffffffffc0201eac:	00f68b63          	beq	a3,a5,ffffffffc0201ec2 <slob_alloc.constprop.0+0x4e>
ffffffffc0201eb0:	6780                	ld	s0,8(a5)
ffffffffc0201eb2:	4018                	lw	a4,0(s0)
ffffffffc0201eb4:	02975a63          	bge	a4,s1,ffffffffc0201ee8 <slob_alloc.constprop.0+0x74>
ffffffffc0201eb8:	00093683          	ld	a3,0(s2)
ffffffffc0201ebc:	87a2                	mv	a5,s0
ffffffffc0201ebe:	fef699e3          	bne	a3,a5,ffffffffc0201eb0 <slob_alloc.constprop.0+0x3c>
ffffffffc0201ec2:	ee31                	bnez	a2,ffffffffc0201f1e <slob_alloc.constprop.0+0xaa>
ffffffffc0201ec4:	4501                	li	a0,0
ffffffffc0201ec6:	f4bff0ef          	jal	ra,ffffffffc0201e10 <__slob_get_free_pages.constprop.0>
ffffffffc0201eca:	842a                	mv	s0,a0
ffffffffc0201ecc:	cd05                	beqz	a0,ffffffffc0201f04 <slob_alloc.constprop.0+0x90>
ffffffffc0201ece:	6585                	lui	a1,0x1
ffffffffc0201ed0:	e8dff0ef          	jal	ra,ffffffffc0201d5c <slob_free>
ffffffffc0201ed4:	10002673          	csrr	a2,sstatus
ffffffffc0201ed8:	8a09                	andi	a2,a2,2
ffffffffc0201eda:	ee05                	bnez	a2,ffffffffc0201f12 <slob_alloc.constprop.0+0x9e>
ffffffffc0201edc:	00093783          	ld	a5,0(s2)
ffffffffc0201ee0:	6780                	ld	s0,8(a5)
ffffffffc0201ee2:	4018                	lw	a4,0(s0)
ffffffffc0201ee4:	fc974ae3          	blt	a4,s1,ffffffffc0201eb8 <slob_alloc.constprop.0+0x44>
ffffffffc0201ee8:	04e48763          	beq	s1,a4,ffffffffc0201f36 <slob_alloc.constprop.0+0xc2>
ffffffffc0201eec:	00449693          	slli	a3,s1,0x4
ffffffffc0201ef0:	96a2                	add	a3,a3,s0
ffffffffc0201ef2:	e794                	sd	a3,8(a5)
ffffffffc0201ef4:	640c                	ld	a1,8(s0)
ffffffffc0201ef6:	9f05                	subw	a4,a4,s1
ffffffffc0201ef8:	c298                	sw	a4,0(a3)
ffffffffc0201efa:	e68c                	sd	a1,8(a3)
ffffffffc0201efc:	c004                	sw	s1,0(s0)
ffffffffc0201efe:	00f93023          	sd	a5,0(s2)
ffffffffc0201f02:	e20d                	bnez	a2,ffffffffc0201f24 <slob_alloc.constprop.0+0xb0>
ffffffffc0201f04:	60e2                	ld	ra,24(sp)
ffffffffc0201f06:	8522                	mv	a0,s0
ffffffffc0201f08:	6442                	ld	s0,16(sp)
ffffffffc0201f0a:	64a2                	ld	s1,8(sp)
ffffffffc0201f0c:	6902                	ld	s2,0(sp)
ffffffffc0201f0e:	6105                	addi	sp,sp,32
ffffffffc0201f10:	8082                	ret
ffffffffc0201f12:	d61fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f16:	00093783          	ld	a5,0(s2)
ffffffffc0201f1a:	4605                	li	a2,1
ffffffffc0201f1c:	b7d1                	j	ffffffffc0201ee0 <slob_alloc.constprop.0+0x6c>
ffffffffc0201f1e:	d4ffe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201f22:	b74d                	j	ffffffffc0201ec4 <slob_alloc.constprop.0+0x50>
ffffffffc0201f24:	d49fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0201f28:	60e2                	ld	ra,24(sp)
ffffffffc0201f2a:	8522                	mv	a0,s0
ffffffffc0201f2c:	6442                	ld	s0,16(sp)
ffffffffc0201f2e:	64a2                	ld	s1,8(sp)
ffffffffc0201f30:	6902                	ld	s2,0(sp)
ffffffffc0201f32:	6105                	addi	sp,sp,32
ffffffffc0201f34:	8082                	ret
ffffffffc0201f36:	6418                	ld	a4,8(s0)
ffffffffc0201f38:	e798                	sd	a4,8(a5)
ffffffffc0201f3a:	b7d1                	j	ffffffffc0201efe <slob_alloc.constprop.0+0x8a>
ffffffffc0201f3c:	d37fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0201f40:	4605                	li	a2,1
ffffffffc0201f42:	bf99                	j	ffffffffc0201e98 <slob_alloc.constprop.0+0x24>
ffffffffc0201f44:	843e                	mv	s0,a5
ffffffffc0201f46:	87b6                	mv	a5,a3
ffffffffc0201f48:	b745                	j	ffffffffc0201ee8 <slob_alloc.constprop.0+0x74>
ffffffffc0201f4a:	0000a697          	auipc	a3,0xa
ffffffffc0201f4e:	68e68693          	addi	a3,a3,1678 # ffffffffc020c5d8 <default_pmm_manager+0x70>
ffffffffc0201f52:	0000a617          	auipc	a2,0xa
ffffffffc0201f56:	b2e60613          	addi	a2,a2,-1234 # ffffffffc020ba80 <commands+0x210>
ffffffffc0201f5a:	06300593          	li	a1,99
ffffffffc0201f5e:	0000a517          	auipc	a0,0xa
ffffffffc0201f62:	69a50513          	addi	a0,a0,1690 # ffffffffc020c5f8 <default_pmm_manager+0x90>
ffffffffc0201f66:	d38fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0201f6a <kmalloc_init>:
ffffffffc0201f6a:	1141                	addi	sp,sp,-16
ffffffffc0201f6c:	0000a517          	auipc	a0,0xa
ffffffffc0201f70:	6a450513          	addi	a0,a0,1700 # ffffffffc020c610 <default_pmm_manager+0xa8>
ffffffffc0201f74:	e406                	sd	ra,8(sp)
ffffffffc0201f76:	a30fe0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0201f7a:	60a2                	ld	ra,8(sp)
ffffffffc0201f7c:	0000a517          	auipc	a0,0xa
ffffffffc0201f80:	6ac50513          	addi	a0,a0,1708 # ffffffffc020c628 <default_pmm_manager+0xc0>
ffffffffc0201f84:	0141                	addi	sp,sp,16
ffffffffc0201f86:	a20fe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0201f8a <kallocated>:
ffffffffc0201f8a:	4501                	li	a0,0
ffffffffc0201f8c:	8082                	ret

ffffffffc0201f8e <kmalloc>:
ffffffffc0201f8e:	1101                	addi	sp,sp,-32
ffffffffc0201f90:	e04a                	sd	s2,0(sp)
ffffffffc0201f92:	6905                	lui	s2,0x1
ffffffffc0201f94:	e822                	sd	s0,16(sp)
ffffffffc0201f96:	ec06                	sd	ra,24(sp)
ffffffffc0201f98:	e426                	sd	s1,8(sp)
ffffffffc0201f9a:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0201f9e:	842a                	mv	s0,a0
ffffffffc0201fa0:	04a7f963          	bgeu	a5,a0,ffffffffc0201ff2 <kmalloc+0x64>
ffffffffc0201fa4:	4561                	li	a0,24
ffffffffc0201fa6:	ecfff0ef          	jal	ra,ffffffffc0201e74 <slob_alloc.constprop.0>
ffffffffc0201faa:	84aa                	mv	s1,a0
ffffffffc0201fac:	c929                	beqz	a0,ffffffffc0201ffe <kmalloc+0x70>
ffffffffc0201fae:	0004079b          	sext.w	a5,s0
ffffffffc0201fb2:	4501                	li	a0,0
ffffffffc0201fb4:	00f95763          	bge	s2,a5,ffffffffc0201fc2 <kmalloc+0x34>
ffffffffc0201fb8:	6705                	lui	a4,0x1
ffffffffc0201fba:	8785                	srai	a5,a5,0x1
ffffffffc0201fbc:	2505                	addiw	a0,a0,1
ffffffffc0201fbe:	fef74ee3          	blt	a4,a5,ffffffffc0201fba <kmalloc+0x2c>
ffffffffc0201fc2:	c088                	sw	a0,0(s1)
ffffffffc0201fc4:	e4dff0ef          	jal	ra,ffffffffc0201e10 <__slob_get_free_pages.constprop.0>
ffffffffc0201fc8:	e488                	sd	a0,8(s1)
ffffffffc0201fca:	842a                	mv	s0,a0
ffffffffc0201fcc:	c525                	beqz	a0,ffffffffc0202034 <kmalloc+0xa6>
ffffffffc0201fce:	100027f3          	csrr	a5,sstatus
ffffffffc0201fd2:	8b89                	andi	a5,a5,2
ffffffffc0201fd4:	ef8d                	bnez	a5,ffffffffc020200e <kmalloc+0x80>
ffffffffc0201fd6:	00095797          	auipc	a5,0x95
ffffffffc0201fda:	8b278793          	addi	a5,a5,-1870 # ffffffffc0296888 <bigblocks>
ffffffffc0201fde:	6398                	ld	a4,0(a5)
ffffffffc0201fe0:	e384                	sd	s1,0(a5)
ffffffffc0201fe2:	e898                	sd	a4,16(s1)
ffffffffc0201fe4:	60e2                	ld	ra,24(sp)
ffffffffc0201fe6:	8522                	mv	a0,s0
ffffffffc0201fe8:	6442                	ld	s0,16(sp)
ffffffffc0201fea:	64a2                	ld	s1,8(sp)
ffffffffc0201fec:	6902                	ld	s2,0(sp)
ffffffffc0201fee:	6105                	addi	sp,sp,32
ffffffffc0201ff0:	8082                	ret
ffffffffc0201ff2:	0541                	addi	a0,a0,16
ffffffffc0201ff4:	e81ff0ef          	jal	ra,ffffffffc0201e74 <slob_alloc.constprop.0>
ffffffffc0201ff8:	01050413          	addi	s0,a0,16
ffffffffc0201ffc:	f565                	bnez	a0,ffffffffc0201fe4 <kmalloc+0x56>
ffffffffc0201ffe:	4401                	li	s0,0
ffffffffc0202000:	60e2                	ld	ra,24(sp)
ffffffffc0202002:	8522                	mv	a0,s0
ffffffffc0202004:	6442                	ld	s0,16(sp)
ffffffffc0202006:	64a2                	ld	s1,8(sp)
ffffffffc0202008:	6902                	ld	s2,0(sp)
ffffffffc020200a:	6105                	addi	sp,sp,32
ffffffffc020200c:	8082                	ret
ffffffffc020200e:	c65fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202012:	00095797          	auipc	a5,0x95
ffffffffc0202016:	87678793          	addi	a5,a5,-1930 # ffffffffc0296888 <bigblocks>
ffffffffc020201a:	6398                	ld	a4,0(a5)
ffffffffc020201c:	e384                	sd	s1,0(a5)
ffffffffc020201e:	e898                	sd	a4,16(s1)
ffffffffc0202020:	c4dfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202024:	6480                	ld	s0,8(s1)
ffffffffc0202026:	60e2                	ld	ra,24(sp)
ffffffffc0202028:	64a2                	ld	s1,8(sp)
ffffffffc020202a:	8522                	mv	a0,s0
ffffffffc020202c:	6442                	ld	s0,16(sp)
ffffffffc020202e:	6902                	ld	s2,0(sp)
ffffffffc0202030:	6105                	addi	sp,sp,32
ffffffffc0202032:	8082                	ret
ffffffffc0202034:	45e1                	li	a1,24
ffffffffc0202036:	8526                	mv	a0,s1
ffffffffc0202038:	d25ff0ef          	jal	ra,ffffffffc0201d5c <slob_free>
ffffffffc020203c:	b765                	j	ffffffffc0201fe4 <kmalloc+0x56>

ffffffffc020203e <kfree>:
ffffffffc020203e:	c169                	beqz	a0,ffffffffc0202100 <kfree+0xc2>
ffffffffc0202040:	1101                	addi	sp,sp,-32
ffffffffc0202042:	e822                	sd	s0,16(sp)
ffffffffc0202044:	ec06                	sd	ra,24(sp)
ffffffffc0202046:	e426                	sd	s1,8(sp)
ffffffffc0202048:	03451793          	slli	a5,a0,0x34
ffffffffc020204c:	842a                	mv	s0,a0
ffffffffc020204e:	e3d9                	bnez	a5,ffffffffc02020d4 <kfree+0x96>
ffffffffc0202050:	100027f3          	csrr	a5,sstatus
ffffffffc0202054:	8b89                	andi	a5,a5,2
ffffffffc0202056:	e7d9                	bnez	a5,ffffffffc02020e4 <kfree+0xa6>
ffffffffc0202058:	00095797          	auipc	a5,0x95
ffffffffc020205c:	8307b783          	ld	a5,-2000(a5) # ffffffffc0296888 <bigblocks>
ffffffffc0202060:	4601                	li	a2,0
ffffffffc0202062:	cbad                	beqz	a5,ffffffffc02020d4 <kfree+0x96>
ffffffffc0202064:	00095697          	auipc	a3,0x95
ffffffffc0202068:	82468693          	addi	a3,a3,-2012 # ffffffffc0296888 <bigblocks>
ffffffffc020206c:	a021                	j	ffffffffc0202074 <kfree+0x36>
ffffffffc020206e:	01048693          	addi	a3,s1,16
ffffffffc0202072:	c3a5                	beqz	a5,ffffffffc02020d2 <kfree+0x94>
ffffffffc0202074:	6798                	ld	a4,8(a5)
ffffffffc0202076:	84be                	mv	s1,a5
ffffffffc0202078:	6b9c                	ld	a5,16(a5)
ffffffffc020207a:	fe871ae3          	bne	a4,s0,ffffffffc020206e <kfree+0x30>
ffffffffc020207e:	e29c                	sd	a5,0(a3)
ffffffffc0202080:	ee2d                	bnez	a2,ffffffffc02020fa <kfree+0xbc>
ffffffffc0202082:	c02007b7          	lui	a5,0xc0200
ffffffffc0202086:	4098                	lw	a4,0(s1)
ffffffffc0202088:	08f46963          	bltu	s0,a5,ffffffffc020211a <kfree+0xdc>
ffffffffc020208c:	00095697          	auipc	a3,0x95
ffffffffc0202090:	82c6b683          	ld	a3,-2004(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202094:	8c15                	sub	s0,s0,a3
ffffffffc0202096:	8031                	srli	s0,s0,0xc
ffffffffc0202098:	00095797          	auipc	a5,0x95
ffffffffc020209c:	8087b783          	ld	a5,-2040(a5) # ffffffffc02968a0 <npage>
ffffffffc02020a0:	06f47163          	bgeu	s0,a5,ffffffffc0202102 <kfree+0xc4>
ffffffffc02020a4:	0000e517          	auipc	a0,0xe
ffffffffc02020a8:	82c53503          	ld	a0,-2004(a0) # ffffffffc020f8d0 <nbase>
ffffffffc02020ac:	8c09                	sub	s0,s0,a0
ffffffffc02020ae:	041a                	slli	s0,s0,0x6
ffffffffc02020b0:	00094517          	auipc	a0,0x94
ffffffffc02020b4:	7f853503          	ld	a0,2040(a0) # ffffffffc02968a8 <pages>
ffffffffc02020b8:	4585                	li	a1,1
ffffffffc02020ba:	9522                	add	a0,a0,s0
ffffffffc02020bc:	00e595bb          	sllw	a1,a1,a4
ffffffffc02020c0:	0ea000ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc02020c4:	6442                	ld	s0,16(sp)
ffffffffc02020c6:	60e2                	ld	ra,24(sp)
ffffffffc02020c8:	8526                	mv	a0,s1
ffffffffc02020ca:	64a2                	ld	s1,8(sp)
ffffffffc02020cc:	45e1                	li	a1,24
ffffffffc02020ce:	6105                	addi	sp,sp,32
ffffffffc02020d0:	b171                	j	ffffffffc0201d5c <slob_free>
ffffffffc02020d2:	e20d                	bnez	a2,ffffffffc02020f4 <kfree+0xb6>
ffffffffc02020d4:	ff040513          	addi	a0,s0,-16
ffffffffc02020d8:	6442                	ld	s0,16(sp)
ffffffffc02020da:	60e2                	ld	ra,24(sp)
ffffffffc02020dc:	64a2                	ld	s1,8(sp)
ffffffffc02020de:	4581                	li	a1,0
ffffffffc02020e0:	6105                	addi	sp,sp,32
ffffffffc02020e2:	b9ad                	j	ffffffffc0201d5c <slob_free>
ffffffffc02020e4:	b8ffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02020e8:	00094797          	auipc	a5,0x94
ffffffffc02020ec:	7a07b783          	ld	a5,1952(a5) # ffffffffc0296888 <bigblocks>
ffffffffc02020f0:	4605                	li	a2,1
ffffffffc02020f2:	fbad                	bnez	a5,ffffffffc0202064 <kfree+0x26>
ffffffffc02020f4:	b79fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020f8:	bff1                	j	ffffffffc02020d4 <kfree+0x96>
ffffffffc02020fa:	b73fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02020fe:	b751                	j	ffffffffc0202082 <kfree+0x44>
ffffffffc0202100:	8082                	ret
ffffffffc0202102:	0000a617          	auipc	a2,0xa
ffffffffc0202106:	56e60613          	addi	a2,a2,1390 # ffffffffc020c670 <default_pmm_manager+0x108>
ffffffffc020210a:	06900593          	li	a1,105
ffffffffc020210e:	0000a517          	auipc	a0,0xa
ffffffffc0202112:	4ba50513          	addi	a0,a0,1210 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0202116:	b88fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020211a:	86a2                	mv	a3,s0
ffffffffc020211c:	0000a617          	auipc	a2,0xa
ffffffffc0202120:	52c60613          	addi	a2,a2,1324 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0202124:	07700593          	li	a1,119
ffffffffc0202128:	0000a517          	auipc	a0,0xa
ffffffffc020212c:	4a050513          	addi	a0,a0,1184 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0202130:	b6efe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202134 <pa2page.part.0>:
ffffffffc0202134:	1141                	addi	sp,sp,-16
ffffffffc0202136:	0000a617          	auipc	a2,0xa
ffffffffc020213a:	53a60613          	addi	a2,a2,1338 # ffffffffc020c670 <default_pmm_manager+0x108>
ffffffffc020213e:	06900593          	li	a1,105
ffffffffc0202142:	0000a517          	auipc	a0,0xa
ffffffffc0202146:	48650513          	addi	a0,a0,1158 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc020214a:	e406                	sd	ra,8(sp)
ffffffffc020214c:	b52fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202150 <pte2page.part.0>:
ffffffffc0202150:	1141                	addi	sp,sp,-16
ffffffffc0202152:	0000a617          	auipc	a2,0xa
ffffffffc0202156:	53e60613          	addi	a2,a2,1342 # ffffffffc020c690 <default_pmm_manager+0x128>
ffffffffc020215a:	07f00593          	li	a1,127
ffffffffc020215e:	0000a517          	auipc	a0,0xa
ffffffffc0202162:	46a50513          	addi	a0,a0,1130 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0202166:	e406                	sd	ra,8(sp)
ffffffffc0202168:	b36fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020216c <alloc_pages>:
ffffffffc020216c:	100027f3          	csrr	a5,sstatus
ffffffffc0202170:	8b89                	andi	a5,a5,2
ffffffffc0202172:	e799                	bnez	a5,ffffffffc0202180 <alloc_pages+0x14>
ffffffffc0202174:	00094797          	auipc	a5,0x94
ffffffffc0202178:	73c7b783          	ld	a5,1852(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020217c:	6f9c                	ld	a5,24(a5)
ffffffffc020217e:	8782                	jr	a5
ffffffffc0202180:	1141                	addi	sp,sp,-16
ffffffffc0202182:	e406                	sd	ra,8(sp)
ffffffffc0202184:	e022                	sd	s0,0(sp)
ffffffffc0202186:	842a                	mv	s0,a0
ffffffffc0202188:	aebfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020218c:	00094797          	auipc	a5,0x94
ffffffffc0202190:	7247b783          	ld	a5,1828(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202194:	6f9c                	ld	a5,24(a5)
ffffffffc0202196:	8522                	mv	a0,s0
ffffffffc0202198:	9782                	jalr	a5
ffffffffc020219a:	842a                	mv	s0,a0
ffffffffc020219c:	ad1fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02021a0:	60a2                	ld	ra,8(sp)
ffffffffc02021a2:	8522                	mv	a0,s0
ffffffffc02021a4:	6402                	ld	s0,0(sp)
ffffffffc02021a6:	0141                	addi	sp,sp,16
ffffffffc02021a8:	8082                	ret

ffffffffc02021aa <free_pages>:
ffffffffc02021aa:	100027f3          	csrr	a5,sstatus
ffffffffc02021ae:	8b89                	andi	a5,a5,2
ffffffffc02021b0:	e799                	bnez	a5,ffffffffc02021be <free_pages+0x14>
ffffffffc02021b2:	00094797          	auipc	a5,0x94
ffffffffc02021b6:	6fe7b783          	ld	a5,1790(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021ba:	739c                	ld	a5,32(a5)
ffffffffc02021bc:	8782                	jr	a5
ffffffffc02021be:	1101                	addi	sp,sp,-32
ffffffffc02021c0:	ec06                	sd	ra,24(sp)
ffffffffc02021c2:	e822                	sd	s0,16(sp)
ffffffffc02021c4:	e426                	sd	s1,8(sp)
ffffffffc02021c6:	842a                	mv	s0,a0
ffffffffc02021c8:	84ae                	mv	s1,a1
ffffffffc02021ca:	aa9fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02021ce:	00094797          	auipc	a5,0x94
ffffffffc02021d2:	6e27b783          	ld	a5,1762(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021d6:	739c                	ld	a5,32(a5)
ffffffffc02021d8:	85a6                	mv	a1,s1
ffffffffc02021da:	8522                	mv	a0,s0
ffffffffc02021dc:	9782                	jalr	a5
ffffffffc02021de:	6442                	ld	s0,16(sp)
ffffffffc02021e0:	60e2                	ld	ra,24(sp)
ffffffffc02021e2:	64a2                	ld	s1,8(sp)
ffffffffc02021e4:	6105                	addi	sp,sp,32
ffffffffc02021e6:	a87fe06f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc02021ea <nr_free_pages>:
ffffffffc02021ea:	100027f3          	csrr	a5,sstatus
ffffffffc02021ee:	8b89                	andi	a5,a5,2
ffffffffc02021f0:	e799                	bnez	a5,ffffffffc02021fe <nr_free_pages+0x14>
ffffffffc02021f2:	00094797          	auipc	a5,0x94
ffffffffc02021f6:	6be7b783          	ld	a5,1726(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02021fa:	779c                	ld	a5,40(a5)
ffffffffc02021fc:	8782                	jr	a5
ffffffffc02021fe:	1141                	addi	sp,sp,-16
ffffffffc0202200:	e406                	sd	ra,8(sp)
ffffffffc0202202:	e022                	sd	s0,0(sp)
ffffffffc0202204:	a6ffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202208:	00094797          	auipc	a5,0x94
ffffffffc020220c:	6a87b783          	ld	a5,1704(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202210:	779c                	ld	a5,40(a5)
ffffffffc0202212:	9782                	jalr	a5
ffffffffc0202214:	842a                	mv	s0,a0
ffffffffc0202216:	a57fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020221a:	60a2                	ld	ra,8(sp)
ffffffffc020221c:	8522                	mv	a0,s0
ffffffffc020221e:	6402                	ld	s0,0(sp)
ffffffffc0202220:	0141                	addi	sp,sp,16
ffffffffc0202222:	8082                	ret

ffffffffc0202224 <get_pte>:
ffffffffc0202224:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0202228:	1ff7f793          	andi	a5,a5,511
ffffffffc020222c:	7139                	addi	sp,sp,-64
ffffffffc020222e:	078e                	slli	a5,a5,0x3
ffffffffc0202230:	f426                	sd	s1,40(sp)
ffffffffc0202232:	00f504b3          	add	s1,a0,a5
ffffffffc0202236:	6094                	ld	a3,0(s1)
ffffffffc0202238:	f04a                	sd	s2,32(sp)
ffffffffc020223a:	ec4e                	sd	s3,24(sp)
ffffffffc020223c:	e852                	sd	s4,16(sp)
ffffffffc020223e:	fc06                	sd	ra,56(sp)
ffffffffc0202240:	f822                	sd	s0,48(sp)
ffffffffc0202242:	e456                	sd	s5,8(sp)
ffffffffc0202244:	e05a                	sd	s6,0(sp)
ffffffffc0202246:	0016f793          	andi	a5,a3,1
ffffffffc020224a:	892e                	mv	s2,a1
ffffffffc020224c:	8a32                	mv	s4,a2
ffffffffc020224e:	00094997          	auipc	s3,0x94
ffffffffc0202252:	65298993          	addi	s3,s3,1618 # ffffffffc02968a0 <npage>
ffffffffc0202256:	efbd                	bnez	a5,ffffffffc02022d4 <get_pte+0xb0>
ffffffffc0202258:	14060c63          	beqz	a2,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020225c:	100027f3          	csrr	a5,sstatus
ffffffffc0202260:	8b89                	andi	a5,a5,2
ffffffffc0202262:	14079963          	bnez	a5,ffffffffc02023b4 <get_pte+0x190>
ffffffffc0202266:	00094797          	auipc	a5,0x94
ffffffffc020226a:	64a7b783          	ld	a5,1610(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020226e:	6f9c                	ld	a5,24(a5)
ffffffffc0202270:	4505                	li	a0,1
ffffffffc0202272:	9782                	jalr	a5
ffffffffc0202274:	842a                	mv	s0,a0
ffffffffc0202276:	12040d63          	beqz	s0,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020227a:	00094b17          	auipc	s6,0x94
ffffffffc020227e:	62eb0b13          	addi	s6,s6,1582 # ffffffffc02968a8 <pages>
ffffffffc0202282:	000b3503          	ld	a0,0(s6)
ffffffffc0202286:	00080ab7          	lui	s5,0x80
ffffffffc020228a:	00094997          	auipc	s3,0x94
ffffffffc020228e:	61698993          	addi	s3,s3,1558 # ffffffffc02968a0 <npage>
ffffffffc0202292:	40a40533          	sub	a0,s0,a0
ffffffffc0202296:	8519                	srai	a0,a0,0x6
ffffffffc0202298:	9556                	add	a0,a0,s5
ffffffffc020229a:	0009b703          	ld	a4,0(s3)
ffffffffc020229e:	00c51793          	slli	a5,a0,0xc
ffffffffc02022a2:	4685                	li	a3,1
ffffffffc02022a4:	c014                	sw	a3,0(s0)
ffffffffc02022a6:	83b1                	srli	a5,a5,0xc
ffffffffc02022a8:	0532                	slli	a0,a0,0xc
ffffffffc02022aa:	16e7f763          	bgeu	a5,a4,ffffffffc0202418 <get_pte+0x1f4>
ffffffffc02022ae:	00094797          	auipc	a5,0x94
ffffffffc02022b2:	60a7b783          	ld	a5,1546(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc02022b6:	6605                	lui	a2,0x1
ffffffffc02022b8:	4581                	li	a1,0
ffffffffc02022ba:	953e                	add	a0,a0,a5
ffffffffc02022bc:	2de090ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc02022c0:	000b3683          	ld	a3,0(s6)
ffffffffc02022c4:	40d406b3          	sub	a3,s0,a3
ffffffffc02022c8:	8699                	srai	a3,a3,0x6
ffffffffc02022ca:	96d6                	add	a3,a3,s5
ffffffffc02022cc:	06aa                	slli	a3,a3,0xa
ffffffffc02022ce:	0116e693          	ori	a3,a3,17
ffffffffc02022d2:	e094                	sd	a3,0(s1)
ffffffffc02022d4:	77fd                	lui	a5,0xfffff
ffffffffc02022d6:	068a                	slli	a3,a3,0x2
ffffffffc02022d8:	0009b703          	ld	a4,0(s3)
ffffffffc02022dc:	8efd                	and	a3,a3,a5
ffffffffc02022de:	00c6d793          	srli	a5,a3,0xc
ffffffffc02022e2:	10e7ff63          	bgeu	a5,a4,ffffffffc0202400 <get_pte+0x1dc>
ffffffffc02022e6:	00094a97          	auipc	s5,0x94
ffffffffc02022ea:	5d2a8a93          	addi	s5,s5,1490 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02022ee:	000ab403          	ld	s0,0(s5)
ffffffffc02022f2:	01595793          	srli	a5,s2,0x15
ffffffffc02022f6:	1ff7f793          	andi	a5,a5,511
ffffffffc02022fa:	96a2                	add	a3,a3,s0
ffffffffc02022fc:	00379413          	slli	s0,a5,0x3
ffffffffc0202300:	9436                	add	s0,s0,a3
ffffffffc0202302:	6014                	ld	a3,0(s0)
ffffffffc0202304:	0016f793          	andi	a5,a3,1
ffffffffc0202308:	ebad                	bnez	a5,ffffffffc020237a <get_pte+0x156>
ffffffffc020230a:	0a0a0363          	beqz	s4,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc020230e:	100027f3          	csrr	a5,sstatus
ffffffffc0202312:	8b89                	andi	a5,a5,2
ffffffffc0202314:	efcd                	bnez	a5,ffffffffc02023ce <get_pte+0x1aa>
ffffffffc0202316:	00094797          	auipc	a5,0x94
ffffffffc020231a:	59a7b783          	ld	a5,1434(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc020231e:	6f9c                	ld	a5,24(a5)
ffffffffc0202320:	4505                	li	a0,1
ffffffffc0202322:	9782                	jalr	a5
ffffffffc0202324:	84aa                	mv	s1,a0
ffffffffc0202326:	c4c9                	beqz	s1,ffffffffc02023b0 <get_pte+0x18c>
ffffffffc0202328:	00094b17          	auipc	s6,0x94
ffffffffc020232c:	580b0b13          	addi	s6,s6,1408 # ffffffffc02968a8 <pages>
ffffffffc0202330:	000b3503          	ld	a0,0(s6)
ffffffffc0202334:	00080a37          	lui	s4,0x80
ffffffffc0202338:	0009b703          	ld	a4,0(s3)
ffffffffc020233c:	40a48533          	sub	a0,s1,a0
ffffffffc0202340:	8519                	srai	a0,a0,0x6
ffffffffc0202342:	9552                	add	a0,a0,s4
ffffffffc0202344:	00c51793          	slli	a5,a0,0xc
ffffffffc0202348:	4685                	li	a3,1
ffffffffc020234a:	c094                	sw	a3,0(s1)
ffffffffc020234c:	83b1                	srli	a5,a5,0xc
ffffffffc020234e:	0532                	slli	a0,a0,0xc
ffffffffc0202350:	0ee7f163          	bgeu	a5,a4,ffffffffc0202432 <get_pte+0x20e>
ffffffffc0202354:	000ab783          	ld	a5,0(s5)
ffffffffc0202358:	6605                	lui	a2,0x1
ffffffffc020235a:	4581                	li	a1,0
ffffffffc020235c:	953e                	add	a0,a0,a5
ffffffffc020235e:	23c090ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0202362:	000b3683          	ld	a3,0(s6)
ffffffffc0202366:	40d486b3          	sub	a3,s1,a3
ffffffffc020236a:	8699                	srai	a3,a3,0x6
ffffffffc020236c:	96d2                	add	a3,a3,s4
ffffffffc020236e:	06aa                	slli	a3,a3,0xa
ffffffffc0202370:	0116e693          	ori	a3,a3,17
ffffffffc0202374:	e014                	sd	a3,0(s0)
ffffffffc0202376:	0009b703          	ld	a4,0(s3)
ffffffffc020237a:	068a                	slli	a3,a3,0x2
ffffffffc020237c:	757d                	lui	a0,0xfffff
ffffffffc020237e:	8ee9                	and	a3,a3,a0
ffffffffc0202380:	00c6d793          	srli	a5,a3,0xc
ffffffffc0202384:	06e7f263          	bgeu	a5,a4,ffffffffc02023e8 <get_pte+0x1c4>
ffffffffc0202388:	000ab503          	ld	a0,0(s5)
ffffffffc020238c:	00c95913          	srli	s2,s2,0xc
ffffffffc0202390:	1ff97913          	andi	s2,s2,511
ffffffffc0202394:	96aa                	add	a3,a3,a0
ffffffffc0202396:	00391513          	slli	a0,s2,0x3
ffffffffc020239a:	9536                	add	a0,a0,a3
ffffffffc020239c:	70e2                	ld	ra,56(sp)
ffffffffc020239e:	7442                	ld	s0,48(sp)
ffffffffc02023a0:	74a2                	ld	s1,40(sp)
ffffffffc02023a2:	7902                	ld	s2,32(sp)
ffffffffc02023a4:	69e2                	ld	s3,24(sp)
ffffffffc02023a6:	6a42                	ld	s4,16(sp)
ffffffffc02023a8:	6aa2                	ld	s5,8(sp)
ffffffffc02023aa:	6b02                	ld	s6,0(sp)
ffffffffc02023ac:	6121                	addi	sp,sp,64
ffffffffc02023ae:	8082                	ret
ffffffffc02023b0:	4501                	li	a0,0
ffffffffc02023b2:	b7ed                	j	ffffffffc020239c <get_pte+0x178>
ffffffffc02023b4:	8bffe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02023b8:	00094797          	auipc	a5,0x94
ffffffffc02023bc:	4f87b783          	ld	a5,1272(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023c0:	6f9c                	ld	a5,24(a5)
ffffffffc02023c2:	4505                	li	a0,1
ffffffffc02023c4:	9782                	jalr	a5
ffffffffc02023c6:	842a                	mv	s0,a0
ffffffffc02023c8:	8a5fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02023cc:	b56d                	j	ffffffffc0202276 <get_pte+0x52>
ffffffffc02023ce:	8a5fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02023d2:	00094797          	auipc	a5,0x94
ffffffffc02023d6:	4de7b783          	ld	a5,1246(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02023da:	6f9c                	ld	a5,24(a5)
ffffffffc02023dc:	4505                	li	a0,1
ffffffffc02023de:	9782                	jalr	a5
ffffffffc02023e0:	84aa                	mv	s1,a0
ffffffffc02023e2:	88bfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02023e6:	b781                	j	ffffffffc0202326 <get_pte+0x102>
ffffffffc02023e8:	0000a617          	auipc	a2,0xa
ffffffffc02023ec:	1b860613          	addi	a2,a2,440 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc02023f0:	13200593          	li	a1,306
ffffffffc02023f4:	0000a517          	auipc	a0,0xa
ffffffffc02023f8:	2c450513          	addi	a0,a0,708 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02023fc:	8a2fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202400:	0000a617          	auipc	a2,0xa
ffffffffc0202404:	1a060613          	addi	a2,a2,416 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0202408:	12500593          	li	a1,293
ffffffffc020240c:	0000a517          	auipc	a0,0xa
ffffffffc0202410:	2ac50513          	addi	a0,a0,684 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0202414:	88afe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202418:	86aa                	mv	a3,a0
ffffffffc020241a:	0000a617          	auipc	a2,0xa
ffffffffc020241e:	18660613          	addi	a2,a2,390 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0202422:	12100593          	li	a1,289
ffffffffc0202426:	0000a517          	auipc	a0,0xa
ffffffffc020242a:	29250513          	addi	a0,a0,658 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020242e:	870fe0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202432:	86aa                	mv	a3,a0
ffffffffc0202434:	0000a617          	auipc	a2,0xa
ffffffffc0202438:	16c60613          	addi	a2,a2,364 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc020243c:	12f00593          	li	a1,303
ffffffffc0202440:	0000a517          	auipc	a0,0xa
ffffffffc0202444:	27850513          	addi	a0,a0,632 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0202448:	856fe0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020244c <boot_map_segment>:
ffffffffc020244c:	6785                	lui	a5,0x1
ffffffffc020244e:	7139                	addi	sp,sp,-64
ffffffffc0202450:	00d5c833          	xor	a6,a1,a3
ffffffffc0202454:	17fd                	addi	a5,a5,-1
ffffffffc0202456:	fc06                	sd	ra,56(sp)
ffffffffc0202458:	f822                	sd	s0,48(sp)
ffffffffc020245a:	f426                	sd	s1,40(sp)
ffffffffc020245c:	f04a                	sd	s2,32(sp)
ffffffffc020245e:	ec4e                	sd	s3,24(sp)
ffffffffc0202460:	e852                	sd	s4,16(sp)
ffffffffc0202462:	e456                	sd	s5,8(sp)
ffffffffc0202464:	00f87833          	and	a6,a6,a5
ffffffffc0202468:	08081563          	bnez	a6,ffffffffc02024f2 <boot_map_segment+0xa6>
ffffffffc020246c:	00f5f4b3          	and	s1,a1,a5
ffffffffc0202470:	963e                	add	a2,a2,a5
ffffffffc0202472:	94b2                	add	s1,s1,a2
ffffffffc0202474:	797d                	lui	s2,0xfffff
ffffffffc0202476:	80b1                	srli	s1,s1,0xc
ffffffffc0202478:	0125f5b3          	and	a1,a1,s2
ffffffffc020247c:	0126f6b3          	and	a3,a3,s2
ffffffffc0202480:	c0a1                	beqz	s1,ffffffffc02024c0 <boot_map_segment+0x74>
ffffffffc0202482:	00176713          	ori	a4,a4,1
ffffffffc0202486:	04b2                	slli	s1,s1,0xc
ffffffffc0202488:	02071993          	slli	s3,a4,0x20
ffffffffc020248c:	8a2a                	mv	s4,a0
ffffffffc020248e:	842e                	mv	s0,a1
ffffffffc0202490:	94ae                	add	s1,s1,a1
ffffffffc0202492:	40b68933          	sub	s2,a3,a1
ffffffffc0202496:	0209d993          	srli	s3,s3,0x20
ffffffffc020249a:	6a85                	lui	s5,0x1
ffffffffc020249c:	4605                	li	a2,1
ffffffffc020249e:	85a2                	mv	a1,s0
ffffffffc02024a0:	8552                	mv	a0,s4
ffffffffc02024a2:	d83ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02024a6:	008907b3          	add	a5,s2,s0
ffffffffc02024aa:	c505                	beqz	a0,ffffffffc02024d2 <boot_map_segment+0x86>
ffffffffc02024ac:	83b1                	srli	a5,a5,0xc
ffffffffc02024ae:	07aa                	slli	a5,a5,0xa
ffffffffc02024b0:	0137e7b3          	or	a5,a5,s3
ffffffffc02024b4:	0017e793          	ori	a5,a5,1
ffffffffc02024b8:	e11c                	sd	a5,0(a0)
ffffffffc02024ba:	9456                	add	s0,s0,s5
ffffffffc02024bc:	fe8490e3          	bne	s1,s0,ffffffffc020249c <boot_map_segment+0x50>
ffffffffc02024c0:	70e2                	ld	ra,56(sp)
ffffffffc02024c2:	7442                	ld	s0,48(sp)
ffffffffc02024c4:	74a2                	ld	s1,40(sp)
ffffffffc02024c6:	7902                	ld	s2,32(sp)
ffffffffc02024c8:	69e2                	ld	s3,24(sp)
ffffffffc02024ca:	6a42                	ld	s4,16(sp)
ffffffffc02024cc:	6aa2                	ld	s5,8(sp)
ffffffffc02024ce:	6121                	addi	sp,sp,64
ffffffffc02024d0:	8082                	ret
ffffffffc02024d2:	0000a697          	auipc	a3,0xa
ffffffffc02024d6:	20e68693          	addi	a3,a3,526 # ffffffffc020c6e0 <default_pmm_manager+0x178>
ffffffffc02024da:	00009617          	auipc	a2,0x9
ffffffffc02024de:	5a660613          	addi	a2,a2,1446 # ffffffffc020ba80 <commands+0x210>
ffffffffc02024e2:	09c00593          	li	a1,156
ffffffffc02024e6:	0000a517          	auipc	a0,0xa
ffffffffc02024ea:	1d250513          	addi	a0,a0,466 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02024ee:	fb1fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02024f2:	0000a697          	auipc	a3,0xa
ffffffffc02024f6:	1d668693          	addi	a3,a3,470 # ffffffffc020c6c8 <default_pmm_manager+0x160>
ffffffffc02024fa:	00009617          	auipc	a2,0x9
ffffffffc02024fe:	58660613          	addi	a2,a2,1414 # ffffffffc020ba80 <commands+0x210>
ffffffffc0202502:	09500593          	li	a1,149
ffffffffc0202506:	0000a517          	auipc	a0,0xa
ffffffffc020250a:	1b250513          	addi	a0,a0,434 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020250e:	f91fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0202512 <get_page>:
ffffffffc0202512:	1141                	addi	sp,sp,-16
ffffffffc0202514:	e022                	sd	s0,0(sp)
ffffffffc0202516:	8432                	mv	s0,a2
ffffffffc0202518:	4601                	li	a2,0
ffffffffc020251a:	e406                	sd	ra,8(sp)
ffffffffc020251c:	d09ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202520:	c011                	beqz	s0,ffffffffc0202524 <get_page+0x12>
ffffffffc0202522:	e008                	sd	a0,0(s0)
ffffffffc0202524:	c511                	beqz	a0,ffffffffc0202530 <get_page+0x1e>
ffffffffc0202526:	611c                	ld	a5,0(a0)
ffffffffc0202528:	4501                	li	a0,0
ffffffffc020252a:	0017f713          	andi	a4,a5,1
ffffffffc020252e:	e709                	bnez	a4,ffffffffc0202538 <get_page+0x26>
ffffffffc0202530:	60a2                	ld	ra,8(sp)
ffffffffc0202532:	6402                	ld	s0,0(sp)
ffffffffc0202534:	0141                	addi	sp,sp,16
ffffffffc0202536:	8082                	ret
ffffffffc0202538:	078a                	slli	a5,a5,0x2
ffffffffc020253a:	83b1                	srli	a5,a5,0xc
ffffffffc020253c:	00094717          	auipc	a4,0x94
ffffffffc0202540:	36473703          	ld	a4,868(a4) # ffffffffc02968a0 <npage>
ffffffffc0202544:	00e7ff63          	bgeu	a5,a4,ffffffffc0202562 <get_page+0x50>
ffffffffc0202548:	60a2                	ld	ra,8(sp)
ffffffffc020254a:	6402                	ld	s0,0(sp)
ffffffffc020254c:	fff80537          	lui	a0,0xfff80
ffffffffc0202550:	97aa                	add	a5,a5,a0
ffffffffc0202552:	079a                	slli	a5,a5,0x6
ffffffffc0202554:	00094517          	auipc	a0,0x94
ffffffffc0202558:	35453503          	ld	a0,852(a0) # ffffffffc02968a8 <pages>
ffffffffc020255c:	953e                	add	a0,a0,a5
ffffffffc020255e:	0141                	addi	sp,sp,16
ffffffffc0202560:	8082                	ret
ffffffffc0202562:	bd3ff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc0202566 <unmap_range>:
ffffffffc0202566:	7159                	addi	sp,sp,-112
ffffffffc0202568:	00c5e7b3          	or	a5,a1,a2
ffffffffc020256c:	f486                	sd	ra,104(sp)
ffffffffc020256e:	f0a2                	sd	s0,96(sp)
ffffffffc0202570:	eca6                	sd	s1,88(sp)
ffffffffc0202572:	e8ca                	sd	s2,80(sp)
ffffffffc0202574:	e4ce                	sd	s3,72(sp)
ffffffffc0202576:	e0d2                	sd	s4,64(sp)
ffffffffc0202578:	fc56                	sd	s5,56(sp)
ffffffffc020257a:	f85a                	sd	s6,48(sp)
ffffffffc020257c:	f45e                	sd	s7,40(sp)
ffffffffc020257e:	f062                	sd	s8,32(sp)
ffffffffc0202580:	ec66                	sd	s9,24(sp)
ffffffffc0202582:	e86a                	sd	s10,16(sp)
ffffffffc0202584:	17d2                	slli	a5,a5,0x34
ffffffffc0202586:	e3ed                	bnez	a5,ffffffffc0202668 <unmap_range+0x102>
ffffffffc0202588:	002007b7          	lui	a5,0x200
ffffffffc020258c:	842e                	mv	s0,a1
ffffffffc020258e:	0ef5ed63          	bltu	a1,a5,ffffffffc0202688 <unmap_range+0x122>
ffffffffc0202592:	8932                	mv	s2,a2
ffffffffc0202594:	0ec5fa63          	bgeu	a1,a2,ffffffffc0202688 <unmap_range+0x122>
ffffffffc0202598:	4785                	li	a5,1
ffffffffc020259a:	07fe                	slli	a5,a5,0x1f
ffffffffc020259c:	0ec7e663          	bltu	a5,a2,ffffffffc0202688 <unmap_range+0x122>
ffffffffc02025a0:	89aa                	mv	s3,a0
ffffffffc02025a2:	6a05                	lui	s4,0x1
ffffffffc02025a4:	00094c97          	auipc	s9,0x94
ffffffffc02025a8:	2fcc8c93          	addi	s9,s9,764 # ffffffffc02968a0 <npage>
ffffffffc02025ac:	00094c17          	auipc	s8,0x94
ffffffffc02025b0:	2fcc0c13          	addi	s8,s8,764 # ffffffffc02968a8 <pages>
ffffffffc02025b4:	fff80bb7          	lui	s7,0xfff80
ffffffffc02025b8:	00094d17          	auipc	s10,0x94
ffffffffc02025bc:	2f8d0d13          	addi	s10,s10,760 # ffffffffc02968b0 <pmm_manager>
ffffffffc02025c0:	00200b37          	lui	s6,0x200
ffffffffc02025c4:	ffe00ab7          	lui	s5,0xffe00
ffffffffc02025c8:	4601                	li	a2,0
ffffffffc02025ca:	85a2                	mv	a1,s0
ffffffffc02025cc:	854e                	mv	a0,s3
ffffffffc02025ce:	c57ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02025d2:	84aa                	mv	s1,a0
ffffffffc02025d4:	cd29                	beqz	a0,ffffffffc020262e <unmap_range+0xc8>
ffffffffc02025d6:	611c                	ld	a5,0(a0)
ffffffffc02025d8:	e395                	bnez	a5,ffffffffc02025fc <unmap_range+0x96>
ffffffffc02025da:	9452                	add	s0,s0,s4
ffffffffc02025dc:	ff2466e3          	bltu	s0,s2,ffffffffc02025c8 <unmap_range+0x62>
ffffffffc02025e0:	70a6                	ld	ra,104(sp)
ffffffffc02025e2:	7406                	ld	s0,96(sp)
ffffffffc02025e4:	64e6                	ld	s1,88(sp)
ffffffffc02025e6:	6946                	ld	s2,80(sp)
ffffffffc02025e8:	69a6                	ld	s3,72(sp)
ffffffffc02025ea:	6a06                	ld	s4,64(sp)
ffffffffc02025ec:	7ae2                	ld	s5,56(sp)
ffffffffc02025ee:	7b42                	ld	s6,48(sp)
ffffffffc02025f0:	7ba2                	ld	s7,40(sp)
ffffffffc02025f2:	7c02                	ld	s8,32(sp)
ffffffffc02025f4:	6ce2                	ld	s9,24(sp)
ffffffffc02025f6:	6d42                	ld	s10,16(sp)
ffffffffc02025f8:	6165                	addi	sp,sp,112
ffffffffc02025fa:	8082                	ret
ffffffffc02025fc:	0017f713          	andi	a4,a5,1
ffffffffc0202600:	df69                	beqz	a4,ffffffffc02025da <unmap_range+0x74>
ffffffffc0202602:	000cb703          	ld	a4,0(s9)
ffffffffc0202606:	078a                	slli	a5,a5,0x2
ffffffffc0202608:	83b1                	srli	a5,a5,0xc
ffffffffc020260a:	08e7ff63          	bgeu	a5,a4,ffffffffc02026a8 <unmap_range+0x142>
ffffffffc020260e:	000c3503          	ld	a0,0(s8)
ffffffffc0202612:	97de                	add	a5,a5,s7
ffffffffc0202614:	079a                	slli	a5,a5,0x6
ffffffffc0202616:	953e                	add	a0,a0,a5
ffffffffc0202618:	411c                	lw	a5,0(a0)
ffffffffc020261a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020261e:	c118                	sw	a4,0(a0)
ffffffffc0202620:	cf11                	beqz	a4,ffffffffc020263c <unmap_range+0xd6>
ffffffffc0202622:	0004b023          	sd	zero,0(s1)
ffffffffc0202626:	12040073          	sfence.vma	s0
ffffffffc020262a:	9452                	add	s0,s0,s4
ffffffffc020262c:	bf45                	j	ffffffffc02025dc <unmap_range+0x76>
ffffffffc020262e:	945a                	add	s0,s0,s6
ffffffffc0202630:	01547433          	and	s0,s0,s5
ffffffffc0202634:	d455                	beqz	s0,ffffffffc02025e0 <unmap_range+0x7a>
ffffffffc0202636:	f92469e3          	bltu	s0,s2,ffffffffc02025c8 <unmap_range+0x62>
ffffffffc020263a:	b75d                	j	ffffffffc02025e0 <unmap_range+0x7a>
ffffffffc020263c:	100027f3          	csrr	a5,sstatus
ffffffffc0202640:	8b89                	andi	a5,a5,2
ffffffffc0202642:	e799                	bnez	a5,ffffffffc0202650 <unmap_range+0xea>
ffffffffc0202644:	000d3783          	ld	a5,0(s10)
ffffffffc0202648:	4585                	li	a1,1
ffffffffc020264a:	739c                	ld	a5,32(a5)
ffffffffc020264c:	9782                	jalr	a5
ffffffffc020264e:	bfd1                	j	ffffffffc0202622 <unmap_range+0xbc>
ffffffffc0202650:	e42a                	sd	a0,8(sp)
ffffffffc0202652:	e20fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202656:	000d3783          	ld	a5,0(s10)
ffffffffc020265a:	6522                	ld	a0,8(sp)
ffffffffc020265c:	4585                	li	a1,1
ffffffffc020265e:	739c                	ld	a5,32(a5)
ffffffffc0202660:	9782                	jalr	a5
ffffffffc0202662:	e0afe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202666:	bf75                	j	ffffffffc0202622 <unmap_range+0xbc>
ffffffffc0202668:	0000a697          	auipc	a3,0xa
ffffffffc020266c:	08868693          	addi	a3,a3,136 # ffffffffc020c6f0 <default_pmm_manager+0x188>
ffffffffc0202670:	00009617          	auipc	a2,0x9
ffffffffc0202674:	41060613          	addi	a2,a2,1040 # ffffffffc020ba80 <commands+0x210>
ffffffffc0202678:	15a00593          	li	a1,346
ffffffffc020267c:	0000a517          	auipc	a0,0xa
ffffffffc0202680:	03c50513          	addi	a0,a0,60 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0202684:	e1bfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202688:	0000a697          	auipc	a3,0xa
ffffffffc020268c:	09868693          	addi	a3,a3,152 # ffffffffc020c720 <default_pmm_manager+0x1b8>
ffffffffc0202690:	00009617          	auipc	a2,0x9
ffffffffc0202694:	3f060613          	addi	a2,a2,1008 # ffffffffc020ba80 <commands+0x210>
ffffffffc0202698:	15b00593          	li	a1,347
ffffffffc020269c:	0000a517          	auipc	a0,0xa
ffffffffc02026a0:	01c50513          	addi	a0,a0,28 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02026a4:	dfbfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02026a8:	a8dff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc02026ac <exit_range>:
ffffffffc02026ac:	7119                	addi	sp,sp,-128
ffffffffc02026ae:	00c5e7b3          	or	a5,a1,a2
ffffffffc02026b2:	fc86                	sd	ra,120(sp)
ffffffffc02026b4:	f8a2                	sd	s0,112(sp)
ffffffffc02026b6:	f4a6                	sd	s1,104(sp)
ffffffffc02026b8:	f0ca                	sd	s2,96(sp)
ffffffffc02026ba:	ecce                	sd	s3,88(sp)
ffffffffc02026bc:	e8d2                	sd	s4,80(sp)
ffffffffc02026be:	e4d6                	sd	s5,72(sp)
ffffffffc02026c0:	e0da                	sd	s6,64(sp)
ffffffffc02026c2:	fc5e                	sd	s7,56(sp)
ffffffffc02026c4:	f862                	sd	s8,48(sp)
ffffffffc02026c6:	f466                	sd	s9,40(sp)
ffffffffc02026c8:	f06a                	sd	s10,32(sp)
ffffffffc02026ca:	ec6e                	sd	s11,24(sp)
ffffffffc02026cc:	17d2                	slli	a5,a5,0x34
ffffffffc02026ce:	20079a63          	bnez	a5,ffffffffc02028e2 <exit_range+0x236>
ffffffffc02026d2:	002007b7          	lui	a5,0x200
ffffffffc02026d6:	24f5e463          	bltu	a1,a5,ffffffffc020291e <exit_range+0x272>
ffffffffc02026da:	8ab2                	mv	s5,a2
ffffffffc02026dc:	24c5f163          	bgeu	a1,a2,ffffffffc020291e <exit_range+0x272>
ffffffffc02026e0:	4785                	li	a5,1
ffffffffc02026e2:	07fe                	slli	a5,a5,0x1f
ffffffffc02026e4:	22c7ed63          	bltu	a5,a2,ffffffffc020291e <exit_range+0x272>
ffffffffc02026e8:	c00009b7          	lui	s3,0xc0000
ffffffffc02026ec:	0135f9b3          	and	s3,a1,s3
ffffffffc02026f0:	ffe00937          	lui	s2,0xffe00
ffffffffc02026f4:	400007b7          	lui	a5,0x40000
ffffffffc02026f8:	5cfd                	li	s9,-1
ffffffffc02026fa:	8c2a                	mv	s8,a0
ffffffffc02026fc:	0125f933          	and	s2,a1,s2
ffffffffc0202700:	99be                	add	s3,s3,a5
ffffffffc0202702:	00094d17          	auipc	s10,0x94
ffffffffc0202706:	19ed0d13          	addi	s10,s10,414 # ffffffffc02968a0 <npage>
ffffffffc020270a:	00ccdc93          	srli	s9,s9,0xc
ffffffffc020270e:	00094717          	auipc	a4,0x94
ffffffffc0202712:	19a70713          	addi	a4,a4,410 # ffffffffc02968a8 <pages>
ffffffffc0202716:	00094d97          	auipc	s11,0x94
ffffffffc020271a:	19ad8d93          	addi	s11,s11,410 # ffffffffc02968b0 <pmm_manager>
ffffffffc020271e:	c0000437          	lui	s0,0xc0000
ffffffffc0202722:	944e                	add	s0,s0,s3
ffffffffc0202724:	8079                	srli	s0,s0,0x1e
ffffffffc0202726:	1ff47413          	andi	s0,s0,511
ffffffffc020272a:	040e                	slli	s0,s0,0x3
ffffffffc020272c:	9462                	add	s0,s0,s8
ffffffffc020272e:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0202732:	001a7793          	andi	a5,s4,1
ffffffffc0202736:	eb99                	bnez	a5,ffffffffc020274c <exit_range+0xa0>
ffffffffc0202738:	12098463          	beqz	s3,ffffffffc0202860 <exit_range+0x1b4>
ffffffffc020273c:	400007b7          	lui	a5,0x40000
ffffffffc0202740:	97ce                	add	a5,a5,s3
ffffffffc0202742:	894e                	mv	s2,s3
ffffffffc0202744:	1159fe63          	bgeu	s3,s5,ffffffffc0202860 <exit_range+0x1b4>
ffffffffc0202748:	89be                	mv	s3,a5
ffffffffc020274a:	bfd1                	j	ffffffffc020271e <exit_range+0x72>
ffffffffc020274c:	000d3783          	ld	a5,0(s10)
ffffffffc0202750:	0a0a                	slli	s4,s4,0x2
ffffffffc0202752:	00ca5a13          	srli	s4,s4,0xc
ffffffffc0202756:	1cfa7263          	bgeu	s4,a5,ffffffffc020291a <exit_range+0x26e>
ffffffffc020275a:	fff80637          	lui	a2,0xfff80
ffffffffc020275e:	9652                	add	a2,a2,s4
ffffffffc0202760:	000806b7          	lui	a3,0x80
ffffffffc0202764:	96b2                	add	a3,a3,a2
ffffffffc0202766:	0196f5b3          	and	a1,a3,s9
ffffffffc020276a:	061a                	slli	a2,a2,0x6
ffffffffc020276c:	06b2                	slli	a3,a3,0xc
ffffffffc020276e:	18f5fa63          	bgeu	a1,a5,ffffffffc0202902 <exit_range+0x256>
ffffffffc0202772:	00094817          	auipc	a6,0x94
ffffffffc0202776:	14680813          	addi	a6,a6,326 # ffffffffc02968b8 <va_pa_offset>
ffffffffc020277a:	00083b03          	ld	s6,0(a6)
ffffffffc020277e:	4b85                	li	s7,1
ffffffffc0202780:	fff80e37          	lui	t3,0xfff80
ffffffffc0202784:	9b36                	add	s6,s6,a3
ffffffffc0202786:	00080337          	lui	t1,0x80
ffffffffc020278a:	6885                	lui	a7,0x1
ffffffffc020278c:	a819                	j	ffffffffc02027a2 <exit_range+0xf6>
ffffffffc020278e:	4b81                	li	s7,0
ffffffffc0202790:	002007b7          	lui	a5,0x200
ffffffffc0202794:	993e                	add	s2,s2,a5
ffffffffc0202796:	08090c63          	beqz	s2,ffffffffc020282e <exit_range+0x182>
ffffffffc020279a:	09397a63          	bgeu	s2,s3,ffffffffc020282e <exit_range+0x182>
ffffffffc020279e:	0f597063          	bgeu	s2,s5,ffffffffc020287e <exit_range+0x1d2>
ffffffffc02027a2:	01595493          	srli	s1,s2,0x15
ffffffffc02027a6:	1ff4f493          	andi	s1,s1,511
ffffffffc02027aa:	048e                	slli	s1,s1,0x3
ffffffffc02027ac:	94da                	add	s1,s1,s6
ffffffffc02027ae:	609c                	ld	a5,0(s1)
ffffffffc02027b0:	0017f693          	andi	a3,a5,1
ffffffffc02027b4:	dee9                	beqz	a3,ffffffffc020278e <exit_range+0xe2>
ffffffffc02027b6:	000d3583          	ld	a1,0(s10)
ffffffffc02027ba:	078a                	slli	a5,a5,0x2
ffffffffc02027bc:	83b1                	srli	a5,a5,0xc
ffffffffc02027be:	14b7fe63          	bgeu	a5,a1,ffffffffc020291a <exit_range+0x26e>
ffffffffc02027c2:	97f2                	add	a5,a5,t3
ffffffffc02027c4:	006786b3          	add	a3,a5,t1
ffffffffc02027c8:	0196feb3          	and	t4,a3,s9
ffffffffc02027cc:	00679513          	slli	a0,a5,0x6
ffffffffc02027d0:	06b2                	slli	a3,a3,0xc
ffffffffc02027d2:	12bef863          	bgeu	t4,a1,ffffffffc0202902 <exit_range+0x256>
ffffffffc02027d6:	00083783          	ld	a5,0(a6)
ffffffffc02027da:	96be                	add	a3,a3,a5
ffffffffc02027dc:	011685b3          	add	a1,a3,a7
ffffffffc02027e0:	629c                	ld	a5,0(a3)
ffffffffc02027e2:	8b85                	andi	a5,a5,1
ffffffffc02027e4:	f7d5                	bnez	a5,ffffffffc0202790 <exit_range+0xe4>
ffffffffc02027e6:	06a1                	addi	a3,a3,8
ffffffffc02027e8:	fed59ce3          	bne	a1,a3,ffffffffc02027e0 <exit_range+0x134>
ffffffffc02027ec:	631c                	ld	a5,0(a4)
ffffffffc02027ee:	953e                	add	a0,a0,a5
ffffffffc02027f0:	100027f3          	csrr	a5,sstatus
ffffffffc02027f4:	8b89                	andi	a5,a5,2
ffffffffc02027f6:	e7d9                	bnez	a5,ffffffffc0202884 <exit_range+0x1d8>
ffffffffc02027f8:	000db783          	ld	a5,0(s11)
ffffffffc02027fc:	4585                	li	a1,1
ffffffffc02027fe:	e032                	sd	a2,0(sp)
ffffffffc0202800:	739c                	ld	a5,32(a5)
ffffffffc0202802:	9782                	jalr	a5
ffffffffc0202804:	6602                	ld	a2,0(sp)
ffffffffc0202806:	00094817          	auipc	a6,0x94
ffffffffc020280a:	0b280813          	addi	a6,a6,178 # ffffffffc02968b8 <va_pa_offset>
ffffffffc020280e:	fff80e37          	lui	t3,0xfff80
ffffffffc0202812:	00080337          	lui	t1,0x80
ffffffffc0202816:	6885                	lui	a7,0x1
ffffffffc0202818:	00094717          	auipc	a4,0x94
ffffffffc020281c:	09070713          	addi	a4,a4,144 # ffffffffc02968a8 <pages>
ffffffffc0202820:	0004b023          	sd	zero,0(s1)
ffffffffc0202824:	002007b7          	lui	a5,0x200
ffffffffc0202828:	993e                	add	s2,s2,a5
ffffffffc020282a:	f60918e3          	bnez	s2,ffffffffc020279a <exit_range+0xee>
ffffffffc020282e:	f00b85e3          	beqz	s7,ffffffffc0202738 <exit_range+0x8c>
ffffffffc0202832:	000d3783          	ld	a5,0(s10)
ffffffffc0202836:	0efa7263          	bgeu	s4,a5,ffffffffc020291a <exit_range+0x26e>
ffffffffc020283a:	6308                	ld	a0,0(a4)
ffffffffc020283c:	9532                	add	a0,a0,a2
ffffffffc020283e:	100027f3          	csrr	a5,sstatus
ffffffffc0202842:	8b89                	andi	a5,a5,2
ffffffffc0202844:	efad                	bnez	a5,ffffffffc02028be <exit_range+0x212>
ffffffffc0202846:	000db783          	ld	a5,0(s11)
ffffffffc020284a:	4585                	li	a1,1
ffffffffc020284c:	739c                	ld	a5,32(a5)
ffffffffc020284e:	9782                	jalr	a5
ffffffffc0202850:	00094717          	auipc	a4,0x94
ffffffffc0202854:	05870713          	addi	a4,a4,88 # ffffffffc02968a8 <pages>
ffffffffc0202858:	00043023          	sd	zero,0(s0)
ffffffffc020285c:	ee0990e3          	bnez	s3,ffffffffc020273c <exit_range+0x90>
ffffffffc0202860:	70e6                	ld	ra,120(sp)
ffffffffc0202862:	7446                	ld	s0,112(sp)
ffffffffc0202864:	74a6                	ld	s1,104(sp)
ffffffffc0202866:	7906                	ld	s2,96(sp)
ffffffffc0202868:	69e6                	ld	s3,88(sp)
ffffffffc020286a:	6a46                	ld	s4,80(sp)
ffffffffc020286c:	6aa6                	ld	s5,72(sp)
ffffffffc020286e:	6b06                	ld	s6,64(sp)
ffffffffc0202870:	7be2                	ld	s7,56(sp)
ffffffffc0202872:	7c42                	ld	s8,48(sp)
ffffffffc0202874:	7ca2                	ld	s9,40(sp)
ffffffffc0202876:	7d02                	ld	s10,32(sp)
ffffffffc0202878:	6de2                	ld	s11,24(sp)
ffffffffc020287a:	6109                	addi	sp,sp,128
ffffffffc020287c:	8082                	ret
ffffffffc020287e:	ea0b8fe3          	beqz	s7,ffffffffc020273c <exit_range+0x90>
ffffffffc0202882:	bf45                	j	ffffffffc0202832 <exit_range+0x186>
ffffffffc0202884:	e032                	sd	a2,0(sp)
ffffffffc0202886:	e42a                	sd	a0,8(sp)
ffffffffc0202888:	beafe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020288c:	000db783          	ld	a5,0(s11)
ffffffffc0202890:	6522                	ld	a0,8(sp)
ffffffffc0202892:	4585                	li	a1,1
ffffffffc0202894:	739c                	ld	a5,32(a5)
ffffffffc0202896:	9782                	jalr	a5
ffffffffc0202898:	bd4fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020289c:	6602                	ld	a2,0(sp)
ffffffffc020289e:	00094717          	auipc	a4,0x94
ffffffffc02028a2:	00a70713          	addi	a4,a4,10 # ffffffffc02968a8 <pages>
ffffffffc02028a6:	6885                	lui	a7,0x1
ffffffffc02028a8:	00080337          	lui	t1,0x80
ffffffffc02028ac:	fff80e37          	lui	t3,0xfff80
ffffffffc02028b0:	00094817          	auipc	a6,0x94
ffffffffc02028b4:	00880813          	addi	a6,a6,8 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02028b8:	0004b023          	sd	zero,0(s1)
ffffffffc02028bc:	b7a5                	j	ffffffffc0202824 <exit_range+0x178>
ffffffffc02028be:	e02a                	sd	a0,0(sp)
ffffffffc02028c0:	bb2fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02028c4:	000db783          	ld	a5,0(s11)
ffffffffc02028c8:	6502                	ld	a0,0(sp)
ffffffffc02028ca:	4585                	li	a1,1
ffffffffc02028cc:	739c                	ld	a5,32(a5)
ffffffffc02028ce:	9782                	jalr	a5
ffffffffc02028d0:	b9cfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02028d4:	00094717          	auipc	a4,0x94
ffffffffc02028d8:	fd470713          	addi	a4,a4,-44 # ffffffffc02968a8 <pages>
ffffffffc02028dc:	00043023          	sd	zero,0(s0)
ffffffffc02028e0:	bfb5                	j	ffffffffc020285c <exit_range+0x1b0>
ffffffffc02028e2:	0000a697          	auipc	a3,0xa
ffffffffc02028e6:	e0e68693          	addi	a3,a3,-498 # ffffffffc020c6f0 <default_pmm_manager+0x188>
ffffffffc02028ea:	00009617          	auipc	a2,0x9
ffffffffc02028ee:	19660613          	addi	a2,a2,406 # ffffffffc020ba80 <commands+0x210>
ffffffffc02028f2:	16f00593          	li	a1,367
ffffffffc02028f6:	0000a517          	auipc	a0,0xa
ffffffffc02028fa:	dc250513          	addi	a0,a0,-574 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02028fe:	ba1fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0202902:	0000a617          	auipc	a2,0xa
ffffffffc0202906:	c9e60613          	addi	a2,a2,-866 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc020290a:	07100593          	li	a1,113
ffffffffc020290e:	0000a517          	auipc	a0,0xa
ffffffffc0202912:	cba50513          	addi	a0,a0,-838 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0202916:	b89fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020291a:	81bff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>
ffffffffc020291e:	0000a697          	auipc	a3,0xa
ffffffffc0202922:	e0268693          	addi	a3,a3,-510 # ffffffffc020c720 <default_pmm_manager+0x1b8>
ffffffffc0202926:	00009617          	auipc	a2,0x9
ffffffffc020292a:	15a60613          	addi	a2,a2,346 # ffffffffc020ba80 <commands+0x210>
ffffffffc020292e:	17000593          	li	a1,368
ffffffffc0202932:	0000a517          	auipc	a0,0xa
ffffffffc0202936:	d8650513          	addi	a0,a0,-634 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020293a:	b65fd0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020293e <page_remove>:
ffffffffc020293e:	7179                	addi	sp,sp,-48
ffffffffc0202940:	4601                	li	a2,0
ffffffffc0202942:	ec26                	sd	s1,24(sp)
ffffffffc0202944:	f406                	sd	ra,40(sp)
ffffffffc0202946:	f022                	sd	s0,32(sp)
ffffffffc0202948:	84ae                	mv	s1,a1
ffffffffc020294a:	8dbff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020294e:	c511                	beqz	a0,ffffffffc020295a <page_remove+0x1c>
ffffffffc0202950:	611c                	ld	a5,0(a0)
ffffffffc0202952:	842a                	mv	s0,a0
ffffffffc0202954:	0017f713          	andi	a4,a5,1
ffffffffc0202958:	e711                	bnez	a4,ffffffffc0202964 <page_remove+0x26>
ffffffffc020295a:	70a2                	ld	ra,40(sp)
ffffffffc020295c:	7402                	ld	s0,32(sp)
ffffffffc020295e:	64e2                	ld	s1,24(sp)
ffffffffc0202960:	6145                	addi	sp,sp,48
ffffffffc0202962:	8082                	ret
ffffffffc0202964:	078a                	slli	a5,a5,0x2
ffffffffc0202966:	83b1                	srli	a5,a5,0xc
ffffffffc0202968:	00094717          	auipc	a4,0x94
ffffffffc020296c:	f3873703          	ld	a4,-200(a4) # ffffffffc02968a0 <npage>
ffffffffc0202970:	06e7f363          	bgeu	a5,a4,ffffffffc02029d6 <page_remove+0x98>
ffffffffc0202974:	fff80537          	lui	a0,0xfff80
ffffffffc0202978:	97aa                	add	a5,a5,a0
ffffffffc020297a:	079a                	slli	a5,a5,0x6
ffffffffc020297c:	00094517          	auipc	a0,0x94
ffffffffc0202980:	f2c53503          	ld	a0,-212(a0) # ffffffffc02968a8 <pages>
ffffffffc0202984:	953e                	add	a0,a0,a5
ffffffffc0202986:	411c                	lw	a5,0(a0)
ffffffffc0202988:	fff7871b          	addiw	a4,a5,-1
ffffffffc020298c:	c118                	sw	a4,0(a0)
ffffffffc020298e:	cb11                	beqz	a4,ffffffffc02029a2 <page_remove+0x64>
ffffffffc0202990:	00043023          	sd	zero,0(s0)
ffffffffc0202994:	12048073          	sfence.vma	s1
ffffffffc0202998:	70a2                	ld	ra,40(sp)
ffffffffc020299a:	7402                	ld	s0,32(sp)
ffffffffc020299c:	64e2                	ld	s1,24(sp)
ffffffffc020299e:	6145                	addi	sp,sp,48
ffffffffc02029a0:	8082                	ret
ffffffffc02029a2:	100027f3          	csrr	a5,sstatus
ffffffffc02029a6:	8b89                	andi	a5,a5,2
ffffffffc02029a8:	eb89                	bnez	a5,ffffffffc02029ba <page_remove+0x7c>
ffffffffc02029aa:	00094797          	auipc	a5,0x94
ffffffffc02029ae:	f067b783          	ld	a5,-250(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02029b2:	739c                	ld	a5,32(a5)
ffffffffc02029b4:	4585                	li	a1,1
ffffffffc02029b6:	9782                	jalr	a5
ffffffffc02029b8:	bfe1                	j	ffffffffc0202990 <page_remove+0x52>
ffffffffc02029ba:	e42a                	sd	a0,8(sp)
ffffffffc02029bc:	ab6fe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02029c0:	00094797          	auipc	a5,0x94
ffffffffc02029c4:	ef07b783          	ld	a5,-272(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc02029c8:	739c                	ld	a5,32(a5)
ffffffffc02029ca:	6522                	ld	a0,8(sp)
ffffffffc02029cc:	4585                	li	a1,1
ffffffffc02029ce:	9782                	jalr	a5
ffffffffc02029d0:	a9cfe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02029d4:	bf75                	j	ffffffffc0202990 <page_remove+0x52>
ffffffffc02029d6:	f5eff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc02029da <page_insert>:
ffffffffc02029da:	7139                	addi	sp,sp,-64
ffffffffc02029dc:	e852                	sd	s4,16(sp)
ffffffffc02029de:	8a32                	mv	s4,a2
ffffffffc02029e0:	f822                	sd	s0,48(sp)
ffffffffc02029e2:	4605                	li	a2,1
ffffffffc02029e4:	842e                	mv	s0,a1
ffffffffc02029e6:	85d2                	mv	a1,s4
ffffffffc02029e8:	f426                	sd	s1,40(sp)
ffffffffc02029ea:	fc06                	sd	ra,56(sp)
ffffffffc02029ec:	f04a                	sd	s2,32(sp)
ffffffffc02029ee:	ec4e                	sd	s3,24(sp)
ffffffffc02029f0:	e456                	sd	s5,8(sp)
ffffffffc02029f2:	84b6                	mv	s1,a3
ffffffffc02029f4:	831ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc02029f8:	c961                	beqz	a0,ffffffffc0202ac8 <page_insert+0xee>
ffffffffc02029fa:	4014                	lw	a3,0(s0)
ffffffffc02029fc:	611c                	ld	a5,0(a0)
ffffffffc02029fe:	89aa                	mv	s3,a0
ffffffffc0202a00:	0016871b          	addiw	a4,a3,1
ffffffffc0202a04:	c018                	sw	a4,0(s0)
ffffffffc0202a06:	0017f713          	andi	a4,a5,1
ffffffffc0202a0a:	ef05                	bnez	a4,ffffffffc0202a42 <page_insert+0x68>
ffffffffc0202a0c:	00094717          	auipc	a4,0x94
ffffffffc0202a10:	e9c73703          	ld	a4,-356(a4) # ffffffffc02968a8 <pages>
ffffffffc0202a14:	8c19                	sub	s0,s0,a4
ffffffffc0202a16:	000807b7          	lui	a5,0x80
ffffffffc0202a1a:	8419                	srai	s0,s0,0x6
ffffffffc0202a1c:	943e                	add	s0,s0,a5
ffffffffc0202a1e:	042a                	slli	s0,s0,0xa
ffffffffc0202a20:	8cc1                	or	s1,s1,s0
ffffffffc0202a22:	0014e493          	ori	s1,s1,1
ffffffffc0202a26:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0202a2a:	120a0073          	sfence.vma	s4
ffffffffc0202a2e:	4501                	li	a0,0
ffffffffc0202a30:	70e2                	ld	ra,56(sp)
ffffffffc0202a32:	7442                	ld	s0,48(sp)
ffffffffc0202a34:	74a2                	ld	s1,40(sp)
ffffffffc0202a36:	7902                	ld	s2,32(sp)
ffffffffc0202a38:	69e2                	ld	s3,24(sp)
ffffffffc0202a3a:	6a42                	ld	s4,16(sp)
ffffffffc0202a3c:	6aa2                	ld	s5,8(sp)
ffffffffc0202a3e:	6121                	addi	sp,sp,64
ffffffffc0202a40:	8082                	ret
ffffffffc0202a42:	078a                	slli	a5,a5,0x2
ffffffffc0202a44:	83b1                	srli	a5,a5,0xc
ffffffffc0202a46:	00094717          	auipc	a4,0x94
ffffffffc0202a4a:	e5a73703          	ld	a4,-422(a4) # ffffffffc02968a0 <npage>
ffffffffc0202a4e:	06e7ff63          	bgeu	a5,a4,ffffffffc0202acc <page_insert+0xf2>
ffffffffc0202a52:	00094a97          	auipc	s5,0x94
ffffffffc0202a56:	e56a8a93          	addi	s5,s5,-426 # ffffffffc02968a8 <pages>
ffffffffc0202a5a:	000ab703          	ld	a4,0(s5)
ffffffffc0202a5e:	fff80937          	lui	s2,0xfff80
ffffffffc0202a62:	993e                	add	s2,s2,a5
ffffffffc0202a64:	091a                	slli	s2,s2,0x6
ffffffffc0202a66:	993a                	add	s2,s2,a4
ffffffffc0202a68:	01240c63          	beq	s0,s2,ffffffffc0202a80 <page_insert+0xa6>
ffffffffc0202a6c:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202a70:	fff7869b          	addiw	a3,a5,-1
ffffffffc0202a74:	00d92023          	sw	a3,0(s2)
ffffffffc0202a78:	c691                	beqz	a3,ffffffffc0202a84 <page_insert+0xaa>
ffffffffc0202a7a:	120a0073          	sfence.vma	s4
ffffffffc0202a7e:	bf59                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202a80:	c014                	sw	a3,0(s0)
ffffffffc0202a82:	bf49                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202a84:	100027f3          	csrr	a5,sstatus
ffffffffc0202a88:	8b89                	andi	a5,a5,2
ffffffffc0202a8a:	ef91                	bnez	a5,ffffffffc0202aa6 <page_insert+0xcc>
ffffffffc0202a8c:	00094797          	auipc	a5,0x94
ffffffffc0202a90:	e247b783          	ld	a5,-476(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202a94:	739c                	ld	a5,32(a5)
ffffffffc0202a96:	4585                	li	a1,1
ffffffffc0202a98:	854a                	mv	a0,s2
ffffffffc0202a9a:	9782                	jalr	a5
ffffffffc0202a9c:	000ab703          	ld	a4,0(s5)
ffffffffc0202aa0:	120a0073          	sfence.vma	s4
ffffffffc0202aa4:	bf85                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202aa6:	9ccfe0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0202aaa:	00094797          	auipc	a5,0x94
ffffffffc0202aae:	e067b783          	ld	a5,-506(a5) # ffffffffc02968b0 <pmm_manager>
ffffffffc0202ab2:	739c                	ld	a5,32(a5)
ffffffffc0202ab4:	4585                	li	a1,1
ffffffffc0202ab6:	854a                	mv	a0,s2
ffffffffc0202ab8:	9782                	jalr	a5
ffffffffc0202aba:	9b2fe0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0202abe:	000ab703          	ld	a4,0(s5)
ffffffffc0202ac2:	120a0073          	sfence.vma	s4
ffffffffc0202ac6:	b7b9                	j	ffffffffc0202a14 <page_insert+0x3a>
ffffffffc0202ac8:	5571                	li	a0,-4
ffffffffc0202aca:	b79d                	j	ffffffffc0202a30 <page_insert+0x56>
ffffffffc0202acc:	e68ff0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>

ffffffffc0202ad0 <pmm_init>:
ffffffffc0202ad0:	0000a797          	auipc	a5,0xa
ffffffffc0202ad4:	a9878793          	addi	a5,a5,-1384 # ffffffffc020c568 <default_pmm_manager>
ffffffffc0202ad8:	638c                	ld	a1,0(a5)
ffffffffc0202ada:	7159                	addi	sp,sp,-112
ffffffffc0202adc:	f85a                	sd	s6,48(sp)
ffffffffc0202ade:	0000a517          	auipc	a0,0xa
ffffffffc0202ae2:	c5a50513          	addi	a0,a0,-934 # ffffffffc020c738 <default_pmm_manager+0x1d0>
ffffffffc0202ae6:	00094b17          	auipc	s6,0x94
ffffffffc0202aea:	dcab0b13          	addi	s6,s6,-566 # ffffffffc02968b0 <pmm_manager>
ffffffffc0202aee:	f486                	sd	ra,104(sp)
ffffffffc0202af0:	e8ca                	sd	s2,80(sp)
ffffffffc0202af2:	e4ce                	sd	s3,72(sp)
ffffffffc0202af4:	f0a2                	sd	s0,96(sp)
ffffffffc0202af6:	eca6                	sd	s1,88(sp)
ffffffffc0202af8:	e0d2                	sd	s4,64(sp)
ffffffffc0202afa:	fc56                	sd	s5,56(sp)
ffffffffc0202afc:	f45e                	sd	s7,40(sp)
ffffffffc0202afe:	f062                	sd	s8,32(sp)
ffffffffc0202b00:	ec66                	sd	s9,24(sp)
ffffffffc0202b02:	00fb3023          	sd	a5,0(s6)
ffffffffc0202b06:	ea0fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b0a:	000b3783          	ld	a5,0(s6)
ffffffffc0202b0e:	00094997          	auipc	s3,0x94
ffffffffc0202b12:	daa98993          	addi	s3,s3,-598 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0202b16:	679c                	ld	a5,8(a5)
ffffffffc0202b18:	9782                	jalr	a5
ffffffffc0202b1a:	57f5                	li	a5,-3
ffffffffc0202b1c:	07fa                	slli	a5,a5,0x1e
ffffffffc0202b1e:	00f9b023          	sd	a5,0(s3)
ffffffffc0202b22:	f27fd0ef          	jal	ra,ffffffffc0200a48 <get_memory_base>
ffffffffc0202b26:	892a                	mv	s2,a0
ffffffffc0202b28:	f2bfd0ef          	jal	ra,ffffffffc0200a52 <get_memory_size>
ffffffffc0202b2c:	280502e3          	beqz	a0,ffffffffc02035b0 <pmm_init+0xae0>
ffffffffc0202b30:	84aa                	mv	s1,a0
ffffffffc0202b32:	0000a517          	auipc	a0,0xa
ffffffffc0202b36:	c3e50513          	addi	a0,a0,-962 # ffffffffc020c770 <default_pmm_manager+0x208>
ffffffffc0202b3a:	e6cfd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b3e:	00990433          	add	s0,s2,s1
ffffffffc0202b42:	fff40693          	addi	a3,s0,-1
ffffffffc0202b46:	864a                	mv	a2,s2
ffffffffc0202b48:	85a6                	mv	a1,s1
ffffffffc0202b4a:	0000a517          	auipc	a0,0xa
ffffffffc0202b4e:	c3e50513          	addi	a0,a0,-962 # ffffffffc020c788 <default_pmm_manager+0x220>
ffffffffc0202b52:	e54fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202b56:	c8000737          	lui	a4,0xc8000
ffffffffc0202b5a:	87a2                	mv	a5,s0
ffffffffc0202b5c:	5e876e63          	bltu	a4,s0,ffffffffc0203158 <pmm_init+0x688>
ffffffffc0202b60:	757d                	lui	a0,0xfffff
ffffffffc0202b62:	00095617          	auipc	a2,0x95
ffffffffc0202b66:	dad60613          	addi	a2,a2,-595 # ffffffffc029790f <end+0xfff>
ffffffffc0202b6a:	8e69                	and	a2,a2,a0
ffffffffc0202b6c:	00094497          	auipc	s1,0x94
ffffffffc0202b70:	d3448493          	addi	s1,s1,-716 # ffffffffc02968a0 <npage>
ffffffffc0202b74:	00c7d513          	srli	a0,a5,0xc
ffffffffc0202b78:	00094b97          	auipc	s7,0x94
ffffffffc0202b7c:	d30b8b93          	addi	s7,s7,-720 # ffffffffc02968a8 <pages>
ffffffffc0202b80:	e088                	sd	a0,0(s1)
ffffffffc0202b82:	00cbb023          	sd	a2,0(s7)
ffffffffc0202b86:	000807b7          	lui	a5,0x80
ffffffffc0202b8a:	86b2                	mv	a3,a2
ffffffffc0202b8c:	02f50863          	beq	a0,a5,ffffffffc0202bbc <pmm_init+0xec>
ffffffffc0202b90:	4781                	li	a5,0
ffffffffc0202b92:	4585                	li	a1,1
ffffffffc0202b94:	fff806b7          	lui	a3,0xfff80
ffffffffc0202b98:	00679513          	slli	a0,a5,0x6
ffffffffc0202b9c:	9532                	add	a0,a0,a2
ffffffffc0202b9e:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0202ba2:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0202ba6:	6088                	ld	a0,0(s1)
ffffffffc0202ba8:	0785                	addi	a5,a5,1
ffffffffc0202baa:	000bb603          	ld	a2,0(s7)
ffffffffc0202bae:	00d50733          	add	a4,a0,a3
ffffffffc0202bb2:	fee7e3e3          	bltu	a5,a4,ffffffffc0202b98 <pmm_init+0xc8>
ffffffffc0202bb6:	071a                	slli	a4,a4,0x6
ffffffffc0202bb8:	00e606b3          	add	a3,a2,a4
ffffffffc0202bbc:	c02007b7          	lui	a5,0xc0200
ffffffffc0202bc0:	3af6eae3          	bltu	a3,a5,ffffffffc0203774 <pmm_init+0xca4>
ffffffffc0202bc4:	0009b583          	ld	a1,0(s3)
ffffffffc0202bc8:	77fd                	lui	a5,0xfffff
ffffffffc0202bca:	8c7d                	and	s0,s0,a5
ffffffffc0202bcc:	8e8d                	sub	a3,a3,a1
ffffffffc0202bce:	5e86e363          	bltu	a3,s0,ffffffffc02031b4 <pmm_init+0x6e4>
ffffffffc0202bd2:	0000a517          	auipc	a0,0xa
ffffffffc0202bd6:	bde50513          	addi	a0,a0,-1058 # ffffffffc020c7b0 <default_pmm_manager+0x248>
ffffffffc0202bda:	dccfd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bde:	000b3783          	ld	a5,0(s6)
ffffffffc0202be2:	7b9c                	ld	a5,48(a5)
ffffffffc0202be4:	9782                	jalr	a5
ffffffffc0202be6:	0000a517          	auipc	a0,0xa
ffffffffc0202bea:	be250513          	addi	a0,a0,-1054 # ffffffffc020c7c8 <default_pmm_manager+0x260>
ffffffffc0202bee:	db8fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202bf2:	100027f3          	csrr	a5,sstatus
ffffffffc0202bf6:	8b89                	andi	a5,a5,2
ffffffffc0202bf8:	5a079363          	bnez	a5,ffffffffc020319e <pmm_init+0x6ce>
ffffffffc0202bfc:	000b3783          	ld	a5,0(s6)
ffffffffc0202c00:	4505                	li	a0,1
ffffffffc0202c02:	6f9c                	ld	a5,24(a5)
ffffffffc0202c04:	9782                	jalr	a5
ffffffffc0202c06:	842a                	mv	s0,a0
ffffffffc0202c08:	180408e3          	beqz	s0,ffffffffc0203598 <pmm_init+0xac8>
ffffffffc0202c0c:	000bb683          	ld	a3,0(s7)
ffffffffc0202c10:	5a7d                	li	s4,-1
ffffffffc0202c12:	6098                	ld	a4,0(s1)
ffffffffc0202c14:	40d406b3          	sub	a3,s0,a3
ffffffffc0202c18:	8699                	srai	a3,a3,0x6
ffffffffc0202c1a:	00080437          	lui	s0,0x80
ffffffffc0202c1e:	96a2                	add	a3,a3,s0
ffffffffc0202c20:	00ca5793          	srli	a5,s4,0xc
ffffffffc0202c24:	8ff5                	and	a5,a5,a3
ffffffffc0202c26:	06b2                	slli	a3,a3,0xc
ffffffffc0202c28:	30e7fde3          	bgeu	a5,a4,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0202c2c:	0009b403          	ld	s0,0(s3)
ffffffffc0202c30:	6605                	lui	a2,0x1
ffffffffc0202c32:	4581                	li	a1,0
ffffffffc0202c34:	9436                	add	s0,s0,a3
ffffffffc0202c36:	8522                	mv	a0,s0
ffffffffc0202c38:	163080ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0202c3c:	0009b683          	ld	a3,0(s3)
ffffffffc0202c40:	77fd                	lui	a5,0xfffff
ffffffffc0202c42:	0000a917          	auipc	s2,0xa
ffffffffc0202c46:	9c190913          	addi	s2,s2,-1599 # ffffffffc020c603 <default_pmm_manager+0x9b>
ffffffffc0202c4a:	00f97933          	and	s2,s2,a5
ffffffffc0202c4e:	c0200ab7          	lui	s5,0xc0200
ffffffffc0202c52:	3fe00637          	lui	a2,0x3fe00
ffffffffc0202c56:	964a                	add	a2,a2,s2
ffffffffc0202c58:	4729                	li	a4,10
ffffffffc0202c5a:	40da86b3          	sub	a3,s5,a3
ffffffffc0202c5e:	c02005b7          	lui	a1,0xc0200
ffffffffc0202c62:	8522                	mv	a0,s0
ffffffffc0202c64:	fe8ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0202c68:	c8000637          	lui	a2,0xc8000
ffffffffc0202c6c:	41260633          	sub	a2,a2,s2
ffffffffc0202c70:	3f596ce3          	bltu	s2,s5,ffffffffc0203868 <pmm_init+0xd98>
ffffffffc0202c74:	0009b683          	ld	a3,0(s3)
ffffffffc0202c78:	85ca                	mv	a1,s2
ffffffffc0202c7a:	4719                	li	a4,6
ffffffffc0202c7c:	40d906b3          	sub	a3,s2,a3
ffffffffc0202c80:	8522                	mv	a0,s0
ffffffffc0202c82:	00094917          	auipc	s2,0x94
ffffffffc0202c86:	c1690913          	addi	s2,s2,-1002 # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0202c8a:	fc2ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0202c8e:	00893023          	sd	s0,0(s2)
ffffffffc0202c92:	2d5464e3          	bltu	s0,s5,ffffffffc020375a <pmm_init+0xc8a>
ffffffffc0202c96:	0009b783          	ld	a5,0(s3)
ffffffffc0202c9a:	1a7e                	slli	s4,s4,0x3f
ffffffffc0202c9c:	8c1d                	sub	s0,s0,a5
ffffffffc0202c9e:	00c45793          	srli	a5,s0,0xc
ffffffffc0202ca2:	00094717          	auipc	a4,0x94
ffffffffc0202ca6:	be873723          	sd	s0,-1042(a4) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0202caa:	0147ea33          	or	s4,a5,s4
ffffffffc0202cae:	180a1073          	csrw	satp,s4
ffffffffc0202cb2:	12000073          	sfence.vma
ffffffffc0202cb6:	0000a517          	auipc	a0,0xa
ffffffffc0202cba:	b5250513          	addi	a0,a0,-1198 # ffffffffc020c808 <default_pmm_manager+0x2a0>
ffffffffc0202cbe:	ce8fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202cc2:	0000e717          	auipc	a4,0xe
ffffffffc0202cc6:	33e70713          	addi	a4,a4,830 # ffffffffc0211000 <bootstack>
ffffffffc0202cca:	0000e797          	auipc	a5,0xe
ffffffffc0202cce:	33678793          	addi	a5,a5,822 # ffffffffc0211000 <bootstack>
ffffffffc0202cd2:	5cf70d63          	beq	a4,a5,ffffffffc02032ac <pmm_init+0x7dc>
ffffffffc0202cd6:	100027f3          	csrr	a5,sstatus
ffffffffc0202cda:	8b89                	andi	a5,a5,2
ffffffffc0202cdc:	4a079763          	bnez	a5,ffffffffc020318a <pmm_init+0x6ba>
ffffffffc0202ce0:	000b3783          	ld	a5,0(s6)
ffffffffc0202ce4:	779c                	ld	a5,40(a5)
ffffffffc0202ce6:	9782                	jalr	a5
ffffffffc0202ce8:	842a                	mv	s0,a0
ffffffffc0202cea:	6098                	ld	a4,0(s1)
ffffffffc0202cec:	c80007b7          	lui	a5,0xc8000
ffffffffc0202cf0:	83b1                	srli	a5,a5,0xc
ffffffffc0202cf2:	08e7e3e3          	bltu	a5,a4,ffffffffc0203578 <pmm_init+0xaa8>
ffffffffc0202cf6:	00093503          	ld	a0,0(s2)
ffffffffc0202cfa:	04050fe3          	beqz	a0,ffffffffc0203558 <pmm_init+0xa88>
ffffffffc0202cfe:	03451793          	slli	a5,a0,0x34
ffffffffc0202d02:	04079be3          	bnez	a5,ffffffffc0203558 <pmm_init+0xa88>
ffffffffc0202d06:	4601                	li	a2,0
ffffffffc0202d08:	4581                	li	a1,0
ffffffffc0202d0a:	809ff0ef          	jal	ra,ffffffffc0202512 <get_page>
ffffffffc0202d0e:	2e0511e3          	bnez	a0,ffffffffc02037f0 <pmm_init+0xd20>
ffffffffc0202d12:	100027f3          	csrr	a5,sstatus
ffffffffc0202d16:	8b89                	andi	a5,a5,2
ffffffffc0202d18:	44079e63          	bnez	a5,ffffffffc0203174 <pmm_init+0x6a4>
ffffffffc0202d1c:	000b3783          	ld	a5,0(s6)
ffffffffc0202d20:	4505                	li	a0,1
ffffffffc0202d22:	6f9c                	ld	a5,24(a5)
ffffffffc0202d24:	9782                	jalr	a5
ffffffffc0202d26:	8a2a                	mv	s4,a0
ffffffffc0202d28:	00093503          	ld	a0,0(s2)
ffffffffc0202d2c:	4681                	li	a3,0
ffffffffc0202d2e:	4601                	li	a2,0
ffffffffc0202d30:	85d2                	mv	a1,s4
ffffffffc0202d32:	ca9ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202d36:	26051be3          	bnez	a0,ffffffffc02037ac <pmm_init+0xcdc>
ffffffffc0202d3a:	00093503          	ld	a0,0(s2)
ffffffffc0202d3e:	4601                	li	a2,0
ffffffffc0202d40:	4581                	li	a1,0
ffffffffc0202d42:	ce2ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202d46:	280505e3          	beqz	a0,ffffffffc02037d0 <pmm_init+0xd00>
ffffffffc0202d4a:	611c                	ld	a5,0(a0)
ffffffffc0202d4c:	0017f713          	andi	a4,a5,1
ffffffffc0202d50:	26070ee3          	beqz	a4,ffffffffc02037cc <pmm_init+0xcfc>
ffffffffc0202d54:	6098                	ld	a4,0(s1)
ffffffffc0202d56:	078a                	slli	a5,a5,0x2
ffffffffc0202d58:	83b1                	srli	a5,a5,0xc
ffffffffc0202d5a:	62e7f363          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202d5e:	000bb683          	ld	a3,0(s7)
ffffffffc0202d62:	fff80637          	lui	a2,0xfff80
ffffffffc0202d66:	97b2                	add	a5,a5,a2
ffffffffc0202d68:	079a                	slli	a5,a5,0x6
ffffffffc0202d6a:	97b6                	add	a5,a5,a3
ffffffffc0202d6c:	2afa12e3          	bne	s4,a5,ffffffffc0203810 <pmm_init+0xd40>
ffffffffc0202d70:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202d74:	4785                	li	a5,1
ffffffffc0202d76:	2cf699e3          	bne	a3,a5,ffffffffc0203848 <pmm_init+0xd78>
ffffffffc0202d7a:	00093503          	ld	a0,0(s2)
ffffffffc0202d7e:	77fd                	lui	a5,0xfffff
ffffffffc0202d80:	6114                	ld	a3,0(a0)
ffffffffc0202d82:	068a                	slli	a3,a3,0x2
ffffffffc0202d84:	8efd                	and	a3,a3,a5
ffffffffc0202d86:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202d8a:	2ae673e3          	bgeu	a2,a4,ffffffffc0203830 <pmm_init+0xd60>
ffffffffc0202d8e:	0009bc03          	ld	s8,0(s3)
ffffffffc0202d92:	96e2                	add	a3,a3,s8
ffffffffc0202d94:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0202d98:	0a8a                	slli	s5,s5,0x2
ffffffffc0202d9a:	00fafab3          	and	s5,s5,a5
ffffffffc0202d9e:	00cad793          	srli	a5,s5,0xc
ffffffffc0202da2:	06e7f3e3          	bgeu	a5,a4,ffffffffc0203608 <pmm_init+0xb38>
ffffffffc0202da6:	4601                	li	a2,0
ffffffffc0202da8:	6585                	lui	a1,0x1
ffffffffc0202daa:	9ae2                	add	s5,s5,s8
ffffffffc0202dac:	c78ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202db0:	0aa1                	addi	s5,s5,8
ffffffffc0202db2:	03551be3          	bne	a0,s5,ffffffffc02035e8 <pmm_init+0xb18>
ffffffffc0202db6:	100027f3          	csrr	a5,sstatus
ffffffffc0202dba:	8b89                	andi	a5,a5,2
ffffffffc0202dbc:	3a079163          	bnez	a5,ffffffffc020315e <pmm_init+0x68e>
ffffffffc0202dc0:	000b3783          	ld	a5,0(s6)
ffffffffc0202dc4:	4505                	li	a0,1
ffffffffc0202dc6:	6f9c                	ld	a5,24(a5)
ffffffffc0202dc8:	9782                	jalr	a5
ffffffffc0202dca:	8c2a                	mv	s8,a0
ffffffffc0202dcc:	00093503          	ld	a0,0(s2)
ffffffffc0202dd0:	46d1                	li	a3,20
ffffffffc0202dd2:	6605                	lui	a2,0x1
ffffffffc0202dd4:	85e2                	mv	a1,s8
ffffffffc0202dd6:	c05ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202dda:	1a0519e3          	bnez	a0,ffffffffc020378c <pmm_init+0xcbc>
ffffffffc0202dde:	00093503          	ld	a0,0(s2)
ffffffffc0202de2:	4601                	li	a2,0
ffffffffc0202de4:	6585                	lui	a1,0x1
ffffffffc0202de6:	c3eff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202dea:	10050ce3          	beqz	a0,ffffffffc0203702 <pmm_init+0xc32>
ffffffffc0202dee:	611c                	ld	a5,0(a0)
ffffffffc0202df0:	0107f713          	andi	a4,a5,16
ffffffffc0202df4:	0e0707e3          	beqz	a4,ffffffffc02036e2 <pmm_init+0xc12>
ffffffffc0202df8:	8b91                	andi	a5,a5,4
ffffffffc0202dfa:	0c0784e3          	beqz	a5,ffffffffc02036c2 <pmm_init+0xbf2>
ffffffffc0202dfe:	00093503          	ld	a0,0(s2)
ffffffffc0202e02:	611c                	ld	a5,0(a0)
ffffffffc0202e04:	8bc1                	andi	a5,a5,16
ffffffffc0202e06:	08078ee3          	beqz	a5,ffffffffc02036a2 <pmm_init+0xbd2>
ffffffffc0202e0a:	000c2703          	lw	a4,0(s8)
ffffffffc0202e0e:	4785                	li	a5,1
ffffffffc0202e10:	06f719e3          	bne	a4,a5,ffffffffc0203682 <pmm_init+0xbb2>
ffffffffc0202e14:	4681                	li	a3,0
ffffffffc0202e16:	6605                	lui	a2,0x1
ffffffffc0202e18:	85d2                	mv	a1,s4
ffffffffc0202e1a:	bc1ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202e1e:	040512e3          	bnez	a0,ffffffffc0203662 <pmm_init+0xb92>
ffffffffc0202e22:	000a2703          	lw	a4,0(s4)
ffffffffc0202e26:	4789                	li	a5,2
ffffffffc0202e28:	00f71de3          	bne	a4,a5,ffffffffc0203642 <pmm_init+0xb72>
ffffffffc0202e2c:	000c2783          	lw	a5,0(s8)
ffffffffc0202e30:	7e079963          	bnez	a5,ffffffffc0203622 <pmm_init+0xb52>
ffffffffc0202e34:	00093503          	ld	a0,0(s2)
ffffffffc0202e38:	4601                	li	a2,0
ffffffffc0202e3a:	6585                	lui	a1,0x1
ffffffffc0202e3c:	be8ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202e40:	54050263          	beqz	a0,ffffffffc0203384 <pmm_init+0x8b4>
ffffffffc0202e44:	6118                	ld	a4,0(a0)
ffffffffc0202e46:	00177793          	andi	a5,a4,1
ffffffffc0202e4a:	180781e3          	beqz	a5,ffffffffc02037cc <pmm_init+0xcfc>
ffffffffc0202e4e:	6094                	ld	a3,0(s1)
ffffffffc0202e50:	00271793          	slli	a5,a4,0x2
ffffffffc0202e54:	83b1                	srli	a5,a5,0xc
ffffffffc0202e56:	52d7f563          	bgeu	a5,a3,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202e5a:	000bb683          	ld	a3,0(s7)
ffffffffc0202e5e:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202e62:	97d6                	add	a5,a5,s5
ffffffffc0202e64:	079a                	slli	a5,a5,0x6
ffffffffc0202e66:	97b6                	add	a5,a5,a3
ffffffffc0202e68:	58fa1e63          	bne	s4,a5,ffffffffc0203404 <pmm_init+0x934>
ffffffffc0202e6c:	8b41                	andi	a4,a4,16
ffffffffc0202e6e:	56071b63          	bnez	a4,ffffffffc02033e4 <pmm_init+0x914>
ffffffffc0202e72:	00093503          	ld	a0,0(s2)
ffffffffc0202e76:	4581                	li	a1,0
ffffffffc0202e78:	ac7ff0ef          	jal	ra,ffffffffc020293e <page_remove>
ffffffffc0202e7c:	000a2c83          	lw	s9,0(s4)
ffffffffc0202e80:	4785                	li	a5,1
ffffffffc0202e82:	5cfc9163          	bne	s9,a5,ffffffffc0203444 <pmm_init+0x974>
ffffffffc0202e86:	000c2783          	lw	a5,0(s8)
ffffffffc0202e8a:	58079d63          	bnez	a5,ffffffffc0203424 <pmm_init+0x954>
ffffffffc0202e8e:	00093503          	ld	a0,0(s2)
ffffffffc0202e92:	6585                	lui	a1,0x1
ffffffffc0202e94:	aabff0ef          	jal	ra,ffffffffc020293e <page_remove>
ffffffffc0202e98:	000a2783          	lw	a5,0(s4)
ffffffffc0202e9c:	200793e3          	bnez	a5,ffffffffc02038a2 <pmm_init+0xdd2>
ffffffffc0202ea0:	000c2783          	lw	a5,0(s8)
ffffffffc0202ea4:	1c079fe3          	bnez	a5,ffffffffc0203882 <pmm_init+0xdb2>
ffffffffc0202ea8:	00093a03          	ld	s4,0(s2)
ffffffffc0202eac:	608c                	ld	a1,0(s1)
ffffffffc0202eae:	000a3683          	ld	a3,0(s4)
ffffffffc0202eb2:	068a                	slli	a3,a3,0x2
ffffffffc0202eb4:	82b1                	srli	a3,a3,0xc
ffffffffc0202eb6:	4cb6f563          	bgeu	a3,a1,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202eba:	000bb503          	ld	a0,0(s7)
ffffffffc0202ebe:	96d6                	add	a3,a3,s5
ffffffffc0202ec0:	069a                	slli	a3,a3,0x6
ffffffffc0202ec2:	00d507b3          	add	a5,a0,a3
ffffffffc0202ec6:	439c                	lw	a5,0(a5)
ffffffffc0202ec8:	4f979e63          	bne	a5,s9,ffffffffc02033c4 <pmm_init+0x8f4>
ffffffffc0202ecc:	8699                	srai	a3,a3,0x6
ffffffffc0202ece:	00080637          	lui	a2,0x80
ffffffffc0202ed2:	96b2                	add	a3,a3,a2
ffffffffc0202ed4:	00c69713          	slli	a4,a3,0xc
ffffffffc0202ed8:	8331                	srli	a4,a4,0xc
ffffffffc0202eda:	06b2                	slli	a3,a3,0xc
ffffffffc0202edc:	06b773e3          	bgeu	a4,a1,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0202ee0:	0009b703          	ld	a4,0(s3)
ffffffffc0202ee4:	96ba                	add	a3,a3,a4
ffffffffc0202ee6:	629c                	ld	a5,0(a3)
ffffffffc0202ee8:	078a                	slli	a5,a5,0x2
ffffffffc0202eea:	83b1                	srli	a5,a5,0xc
ffffffffc0202eec:	48b7fa63          	bgeu	a5,a1,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202ef0:	8f91                	sub	a5,a5,a2
ffffffffc0202ef2:	079a                	slli	a5,a5,0x6
ffffffffc0202ef4:	953e                	add	a0,a0,a5
ffffffffc0202ef6:	100027f3          	csrr	a5,sstatus
ffffffffc0202efa:	8b89                	andi	a5,a5,2
ffffffffc0202efc:	32079463          	bnez	a5,ffffffffc0203224 <pmm_init+0x754>
ffffffffc0202f00:	000b3783          	ld	a5,0(s6)
ffffffffc0202f04:	4585                	li	a1,1
ffffffffc0202f06:	739c                	ld	a5,32(a5)
ffffffffc0202f08:	9782                	jalr	a5
ffffffffc0202f0a:	000a3783          	ld	a5,0(s4)
ffffffffc0202f0e:	6098                	ld	a4,0(s1)
ffffffffc0202f10:	078a                	slli	a5,a5,0x2
ffffffffc0202f12:	83b1                	srli	a5,a5,0xc
ffffffffc0202f14:	46e7f663          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc0202f18:	000bb503          	ld	a0,0(s7)
ffffffffc0202f1c:	fff80737          	lui	a4,0xfff80
ffffffffc0202f20:	97ba                	add	a5,a5,a4
ffffffffc0202f22:	079a                	slli	a5,a5,0x6
ffffffffc0202f24:	953e                	add	a0,a0,a5
ffffffffc0202f26:	100027f3          	csrr	a5,sstatus
ffffffffc0202f2a:	8b89                	andi	a5,a5,2
ffffffffc0202f2c:	2e079063          	bnez	a5,ffffffffc020320c <pmm_init+0x73c>
ffffffffc0202f30:	000b3783          	ld	a5,0(s6)
ffffffffc0202f34:	4585                	li	a1,1
ffffffffc0202f36:	739c                	ld	a5,32(a5)
ffffffffc0202f38:	9782                	jalr	a5
ffffffffc0202f3a:	00093783          	ld	a5,0(s2)
ffffffffc0202f3e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202f42:	12000073          	sfence.vma
ffffffffc0202f46:	100027f3          	csrr	a5,sstatus
ffffffffc0202f4a:	8b89                	andi	a5,a5,2
ffffffffc0202f4c:	2a079663          	bnez	a5,ffffffffc02031f8 <pmm_init+0x728>
ffffffffc0202f50:	000b3783          	ld	a5,0(s6)
ffffffffc0202f54:	779c                	ld	a5,40(a5)
ffffffffc0202f56:	9782                	jalr	a5
ffffffffc0202f58:	8a2a                	mv	s4,a0
ffffffffc0202f5a:	7d441463          	bne	s0,s4,ffffffffc0203722 <pmm_init+0xc52>
ffffffffc0202f5e:	0000a517          	auipc	a0,0xa
ffffffffc0202f62:	c0250513          	addi	a0,a0,-1022 # ffffffffc020cb60 <default_pmm_manager+0x5f8>
ffffffffc0202f66:	a40fd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0202f6a:	100027f3          	csrr	a5,sstatus
ffffffffc0202f6e:	8b89                	andi	a5,a5,2
ffffffffc0202f70:	26079a63          	bnez	a5,ffffffffc02031e4 <pmm_init+0x714>
ffffffffc0202f74:	000b3783          	ld	a5,0(s6)
ffffffffc0202f78:	779c                	ld	a5,40(a5)
ffffffffc0202f7a:	9782                	jalr	a5
ffffffffc0202f7c:	8c2a                	mv	s8,a0
ffffffffc0202f7e:	6098                	ld	a4,0(s1)
ffffffffc0202f80:	c0200437          	lui	s0,0xc0200
ffffffffc0202f84:	7afd                	lui	s5,0xfffff
ffffffffc0202f86:	00c71793          	slli	a5,a4,0xc
ffffffffc0202f8a:	6a05                	lui	s4,0x1
ffffffffc0202f8c:	02f47c63          	bgeu	s0,a5,ffffffffc0202fc4 <pmm_init+0x4f4>
ffffffffc0202f90:	00c45793          	srli	a5,s0,0xc
ffffffffc0202f94:	00093503          	ld	a0,0(s2)
ffffffffc0202f98:	3ae7f763          	bgeu	a5,a4,ffffffffc0203346 <pmm_init+0x876>
ffffffffc0202f9c:	0009b583          	ld	a1,0(s3)
ffffffffc0202fa0:	4601                	li	a2,0
ffffffffc0202fa2:	95a2                	add	a1,a1,s0
ffffffffc0202fa4:	a80ff0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0202fa8:	36050f63          	beqz	a0,ffffffffc0203326 <pmm_init+0x856>
ffffffffc0202fac:	611c                	ld	a5,0(a0)
ffffffffc0202fae:	078a                	slli	a5,a5,0x2
ffffffffc0202fb0:	0157f7b3          	and	a5,a5,s5
ffffffffc0202fb4:	3a879663          	bne	a5,s0,ffffffffc0203360 <pmm_init+0x890>
ffffffffc0202fb8:	6098                	ld	a4,0(s1)
ffffffffc0202fba:	9452                	add	s0,s0,s4
ffffffffc0202fbc:	00c71793          	slli	a5,a4,0xc
ffffffffc0202fc0:	fcf468e3          	bltu	s0,a5,ffffffffc0202f90 <pmm_init+0x4c0>
ffffffffc0202fc4:	00093783          	ld	a5,0(s2)
ffffffffc0202fc8:	639c                	ld	a5,0(a5)
ffffffffc0202fca:	48079d63          	bnez	a5,ffffffffc0203464 <pmm_init+0x994>
ffffffffc0202fce:	100027f3          	csrr	a5,sstatus
ffffffffc0202fd2:	8b89                	andi	a5,a5,2
ffffffffc0202fd4:	26079463          	bnez	a5,ffffffffc020323c <pmm_init+0x76c>
ffffffffc0202fd8:	000b3783          	ld	a5,0(s6)
ffffffffc0202fdc:	4505                	li	a0,1
ffffffffc0202fde:	6f9c                	ld	a5,24(a5)
ffffffffc0202fe0:	9782                	jalr	a5
ffffffffc0202fe2:	8a2a                	mv	s4,a0
ffffffffc0202fe4:	00093503          	ld	a0,0(s2)
ffffffffc0202fe8:	4699                	li	a3,6
ffffffffc0202fea:	10000613          	li	a2,256
ffffffffc0202fee:	85d2                	mv	a1,s4
ffffffffc0202ff0:	9ebff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0202ff4:	4a051863          	bnez	a0,ffffffffc02034a4 <pmm_init+0x9d4>
ffffffffc0202ff8:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202ffc:	4785                	li	a5,1
ffffffffc0202ffe:	48f71363          	bne	a4,a5,ffffffffc0203484 <pmm_init+0x9b4>
ffffffffc0203002:	00093503          	ld	a0,0(s2)
ffffffffc0203006:	6405                	lui	s0,0x1
ffffffffc0203008:	4699                	li	a3,6
ffffffffc020300a:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc020300e:	85d2                	mv	a1,s4
ffffffffc0203010:	9cbff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203014:	38051863          	bnez	a0,ffffffffc02033a4 <pmm_init+0x8d4>
ffffffffc0203018:	000a2703          	lw	a4,0(s4)
ffffffffc020301c:	4789                	li	a5,2
ffffffffc020301e:	4ef71363          	bne	a4,a5,ffffffffc0203504 <pmm_init+0xa34>
ffffffffc0203022:	0000a597          	auipc	a1,0xa
ffffffffc0203026:	c8658593          	addi	a1,a1,-890 # ffffffffc020cca8 <default_pmm_manager+0x740>
ffffffffc020302a:	10000513          	li	a0,256
ffffffffc020302e:	500080ef          	jal	ra,ffffffffc020b52e <strcpy>
ffffffffc0203032:	10040593          	addi	a1,s0,256
ffffffffc0203036:	10000513          	li	a0,256
ffffffffc020303a:	506080ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc020303e:	4a051363          	bnez	a0,ffffffffc02034e4 <pmm_init+0xa14>
ffffffffc0203042:	000bb683          	ld	a3,0(s7)
ffffffffc0203046:	00080737          	lui	a4,0x80
ffffffffc020304a:	547d                	li	s0,-1
ffffffffc020304c:	40da06b3          	sub	a3,s4,a3
ffffffffc0203050:	8699                	srai	a3,a3,0x6
ffffffffc0203052:	609c                	ld	a5,0(s1)
ffffffffc0203054:	96ba                	add	a3,a3,a4
ffffffffc0203056:	8031                	srli	s0,s0,0xc
ffffffffc0203058:	0086f733          	and	a4,a3,s0
ffffffffc020305c:	06b2                	slli	a3,a3,0xc
ffffffffc020305e:	6ef77263          	bgeu	a4,a5,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0203062:	0009b783          	ld	a5,0(s3)
ffffffffc0203066:	10000513          	li	a0,256
ffffffffc020306a:	96be                	add	a3,a3,a5
ffffffffc020306c:	10068023          	sb	zero,256(a3)
ffffffffc0203070:	488080ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc0203074:	44051863          	bnez	a0,ffffffffc02034c4 <pmm_init+0x9f4>
ffffffffc0203078:	00093a83          	ld	s5,0(s2)
ffffffffc020307c:	609c                	ld	a5,0(s1)
ffffffffc020307e:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0203082:	068a                	slli	a3,a3,0x2
ffffffffc0203084:	82b1                	srli	a3,a3,0xc
ffffffffc0203086:	2ef6fd63          	bgeu	a3,a5,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc020308a:	8c75                	and	s0,s0,a3
ffffffffc020308c:	06b2                	slli	a3,a3,0xc
ffffffffc020308e:	6af47a63          	bgeu	s0,a5,ffffffffc0203742 <pmm_init+0xc72>
ffffffffc0203092:	0009b403          	ld	s0,0(s3)
ffffffffc0203096:	9436                	add	s0,s0,a3
ffffffffc0203098:	100027f3          	csrr	a5,sstatus
ffffffffc020309c:	8b89                	andi	a5,a5,2
ffffffffc020309e:	1e079c63          	bnez	a5,ffffffffc0203296 <pmm_init+0x7c6>
ffffffffc02030a2:	000b3783          	ld	a5,0(s6)
ffffffffc02030a6:	4585                	li	a1,1
ffffffffc02030a8:	8552                	mv	a0,s4
ffffffffc02030aa:	739c                	ld	a5,32(a5)
ffffffffc02030ac:	9782                	jalr	a5
ffffffffc02030ae:	601c                	ld	a5,0(s0)
ffffffffc02030b0:	6098                	ld	a4,0(s1)
ffffffffc02030b2:	078a                	slli	a5,a5,0x2
ffffffffc02030b4:	83b1                	srli	a5,a5,0xc
ffffffffc02030b6:	2ce7f563          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02030ba:	000bb503          	ld	a0,0(s7)
ffffffffc02030be:	fff80737          	lui	a4,0xfff80
ffffffffc02030c2:	97ba                	add	a5,a5,a4
ffffffffc02030c4:	079a                	slli	a5,a5,0x6
ffffffffc02030c6:	953e                	add	a0,a0,a5
ffffffffc02030c8:	100027f3          	csrr	a5,sstatus
ffffffffc02030cc:	8b89                	andi	a5,a5,2
ffffffffc02030ce:	1a079863          	bnez	a5,ffffffffc020327e <pmm_init+0x7ae>
ffffffffc02030d2:	000b3783          	ld	a5,0(s6)
ffffffffc02030d6:	4585                	li	a1,1
ffffffffc02030d8:	739c                	ld	a5,32(a5)
ffffffffc02030da:	9782                	jalr	a5
ffffffffc02030dc:	000ab783          	ld	a5,0(s5)
ffffffffc02030e0:	6098                	ld	a4,0(s1)
ffffffffc02030e2:	078a                	slli	a5,a5,0x2
ffffffffc02030e4:	83b1                	srli	a5,a5,0xc
ffffffffc02030e6:	28e7fd63          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02030ea:	000bb503          	ld	a0,0(s7)
ffffffffc02030ee:	fff80737          	lui	a4,0xfff80
ffffffffc02030f2:	97ba                	add	a5,a5,a4
ffffffffc02030f4:	079a                	slli	a5,a5,0x6
ffffffffc02030f6:	953e                	add	a0,a0,a5
ffffffffc02030f8:	100027f3          	csrr	a5,sstatus
ffffffffc02030fc:	8b89                	andi	a5,a5,2
ffffffffc02030fe:	16079463          	bnez	a5,ffffffffc0203266 <pmm_init+0x796>
ffffffffc0203102:	000b3783          	ld	a5,0(s6)
ffffffffc0203106:	4585                	li	a1,1
ffffffffc0203108:	739c                	ld	a5,32(a5)
ffffffffc020310a:	9782                	jalr	a5
ffffffffc020310c:	00093783          	ld	a5,0(s2)
ffffffffc0203110:	0007b023          	sd	zero,0(a5)
ffffffffc0203114:	12000073          	sfence.vma
ffffffffc0203118:	100027f3          	csrr	a5,sstatus
ffffffffc020311c:	8b89                	andi	a5,a5,2
ffffffffc020311e:	12079a63          	bnez	a5,ffffffffc0203252 <pmm_init+0x782>
ffffffffc0203122:	000b3783          	ld	a5,0(s6)
ffffffffc0203126:	779c                	ld	a5,40(a5)
ffffffffc0203128:	9782                	jalr	a5
ffffffffc020312a:	842a                	mv	s0,a0
ffffffffc020312c:	488c1e63          	bne	s8,s0,ffffffffc02035c8 <pmm_init+0xaf8>
ffffffffc0203130:	0000a517          	auipc	a0,0xa
ffffffffc0203134:	bf050513          	addi	a0,a0,-1040 # ffffffffc020cd20 <default_pmm_manager+0x7b8>
ffffffffc0203138:	86efd0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020313c:	7406                	ld	s0,96(sp)
ffffffffc020313e:	70a6                	ld	ra,104(sp)
ffffffffc0203140:	64e6                	ld	s1,88(sp)
ffffffffc0203142:	6946                	ld	s2,80(sp)
ffffffffc0203144:	69a6                	ld	s3,72(sp)
ffffffffc0203146:	6a06                	ld	s4,64(sp)
ffffffffc0203148:	7ae2                	ld	s5,56(sp)
ffffffffc020314a:	7b42                	ld	s6,48(sp)
ffffffffc020314c:	7ba2                	ld	s7,40(sp)
ffffffffc020314e:	7c02                	ld	s8,32(sp)
ffffffffc0203150:	6ce2                	ld	s9,24(sp)
ffffffffc0203152:	6165                	addi	sp,sp,112
ffffffffc0203154:	e17fe06f          	j	ffffffffc0201f6a <kmalloc_init>
ffffffffc0203158:	c80007b7          	lui	a5,0xc8000
ffffffffc020315c:	b411                	j	ffffffffc0202b60 <pmm_init+0x90>
ffffffffc020315e:	b15fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203162:	000b3783          	ld	a5,0(s6)
ffffffffc0203166:	4505                	li	a0,1
ffffffffc0203168:	6f9c                	ld	a5,24(a5)
ffffffffc020316a:	9782                	jalr	a5
ffffffffc020316c:	8c2a                	mv	s8,a0
ffffffffc020316e:	afffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203172:	b9a9                	j	ffffffffc0202dcc <pmm_init+0x2fc>
ffffffffc0203174:	afffd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203178:	000b3783          	ld	a5,0(s6)
ffffffffc020317c:	4505                	li	a0,1
ffffffffc020317e:	6f9c                	ld	a5,24(a5)
ffffffffc0203180:	9782                	jalr	a5
ffffffffc0203182:	8a2a                	mv	s4,a0
ffffffffc0203184:	ae9fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203188:	b645                	j	ffffffffc0202d28 <pmm_init+0x258>
ffffffffc020318a:	ae9fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020318e:	000b3783          	ld	a5,0(s6)
ffffffffc0203192:	779c                	ld	a5,40(a5)
ffffffffc0203194:	9782                	jalr	a5
ffffffffc0203196:	842a                	mv	s0,a0
ffffffffc0203198:	ad5fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020319c:	b6b9                	j	ffffffffc0202cea <pmm_init+0x21a>
ffffffffc020319e:	ad5fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031a2:	000b3783          	ld	a5,0(s6)
ffffffffc02031a6:	4505                	li	a0,1
ffffffffc02031a8:	6f9c                	ld	a5,24(a5)
ffffffffc02031aa:	9782                	jalr	a5
ffffffffc02031ac:	842a                	mv	s0,a0
ffffffffc02031ae:	abffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02031b2:	bc99                	j	ffffffffc0202c08 <pmm_init+0x138>
ffffffffc02031b4:	6705                	lui	a4,0x1
ffffffffc02031b6:	177d                	addi	a4,a4,-1
ffffffffc02031b8:	96ba                	add	a3,a3,a4
ffffffffc02031ba:	8ff5                	and	a5,a5,a3
ffffffffc02031bc:	00c7d713          	srli	a4,a5,0xc
ffffffffc02031c0:	1ca77063          	bgeu	a4,a0,ffffffffc0203380 <pmm_init+0x8b0>
ffffffffc02031c4:	000b3683          	ld	a3,0(s6)
ffffffffc02031c8:	fff80537          	lui	a0,0xfff80
ffffffffc02031cc:	972a                	add	a4,a4,a0
ffffffffc02031ce:	6a94                	ld	a3,16(a3)
ffffffffc02031d0:	8c1d                	sub	s0,s0,a5
ffffffffc02031d2:	00671513          	slli	a0,a4,0x6
ffffffffc02031d6:	00c45593          	srli	a1,s0,0xc
ffffffffc02031da:	9532                	add	a0,a0,a2
ffffffffc02031dc:	9682                	jalr	a3
ffffffffc02031de:	0009b583          	ld	a1,0(s3)
ffffffffc02031e2:	bac5                	j	ffffffffc0202bd2 <pmm_init+0x102>
ffffffffc02031e4:	a8ffd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031e8:	000b3783          	ld	a5,0(s6)
ffffffffc02031ec:	779c                	ld	a5,40(a5)
ffffffffc02031ee:	9782                	jalr	a5
ffffffffc02031f0:	8c2a                	mv	s8,a0
ffffffffc02031f2:	a7bfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02031f6:	b361                	j	ffffffffc0202f7e <pmm_init+0x4ae>
ffffffffc02031f8:	a7bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02031fc:	000b3783          	ld	a5,0(s6)
ffffffffc0203200:	779c                	ld	a5,40(a5)
ffffffffc0203202:	9782                	jalr	a5
ffffffffc0203204:	8a2a                	mv	s4,a0
ffffffffc0203206:	a67fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020320a:	bb81                	j	ffffffffc0202f5a <pmm_init+0x48a>
ffffffffc020320c:	e42a                	sd	a0,8(sp)
ffffffffc020320e:	a65fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203212:	000b3783          	ld	a5,0(s6)
ffffffffc0203216:	6522                	ld	a0,8(sp)
ffffffffc0203218:	4585                	li	a1,1
ffffffffc020321a:	739c                	ld	a5,32(a5)
ffffffffc020321c:	9782                	jalr	a5
ffffffffc020321e:	a4ffd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203222:	bb21                	j	ffffffffc0202f3a <pmm_init+0x46a>
ffffffffc0203224:	e42a                	sd	a0,8(sp)
ffffffffc0203226:	a4dfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020322a:	000b3783          	ld	a5,0(s6)
ffffffffc020322e:	6522                	ld	a0,8(sp)
ffffffffc0203230:	4585                	li	a1,1
ffffffffc0203232:	739c                	ld	a5,32(a5)
ffffffffc0203234:	9782                	jalr	a5
ffffffffc0203236:	a37fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020323a:	b9c1                	j	ffffffffc0202f0a <pmm_init+0x43a>
ffffffffc020323c:	a37fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203240:	000b3783          	ld	a5,0(s6)
ffffffffc0203244:	4505                	li	a0,1
ffffffffc0203246:	6f9c                	ld	a5,24(a5)
ffffffffc0203248:	9782                	jalr	a5
ffffffffc020324a:	8a2a                	mv	s4,a0
ffffffffc020324c:	a21fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203250:	bb51                	j	ffffffffc0202fe4 <pmm_init+0x514>
ffffffffc0203252:	a21fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203256:	000b3783          	ld	a5,0(s6)
ffffffffc020325a:	779c                	ld	a5,40(a5)
ffffffffc020325c:	9782                	jalr	a5
ffffffffc020325e:	842a                	mv	s0,a0
ffffffffc0203260:	a0dfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203264:	b5e1                	j	ffffffffc020312c <pmm_init+0x65c>
ffffffffc0203266:	e42a                	sd	a0,8(sp)
ffffffffc0203268:	a0bfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020326c:	000b3783          	ld	a5,0(s6)
ffffffffc0203270:	6522                	ld	a0,8(sp)
ffffffffc0203272:	4585                	li	a1,1
ffffffffc0203274:	739c                	ld	a5,32(a5)
ffffffffc0203276:	9782                	jalr	a5
ffffffffc0203278:	9f5fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc020327c:	bd41                	j	ffffffffc020310c <pmm_init+0x63c>
ffffffffc020327e:	e42a                	sd	a0,8(sp)
ffffffffc0203280:	9f3fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203284:	000b3783          	ld	a5,0(s6)
ffffffffc0203288:	6522                	ld	a0,8(sp)
ffffffffc020328a:	4585                	li	a1,1
ffffffffc020328c:	739c                	ld	a5,32(a5)
ffffffffc020328e:	9782                	jalr	a5
ffffffffc0203290:	9ddfd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203294:	b5a1                	j	ffffffffc02030dc <pmm_init+0x60c>
ffffffffc0203296:	9ddfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc020329a:	000b3783          	ld	a5,0(s6)
ffffffffc020329e:	4585                	li	a1,1
ffffffffc02032a0:	8552                	mv	a0,s4
ffffffffc02032a2:	739c                	ld	a5,32(a5)
ffffffffc02032a4:	9782                	jalr	a5
ffffffffc02032a6:	9c7fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02032aa:	b511                	j	ffffffffc02030ae <pmm_init+0x5de>
ffffffffc02032ac:	00010417          	auipc	s0,0x10
ffffffffc02032b0:	d5440413          	addi	s0,s0,-684 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02032b4:	00010797          	auipc	a5,0x10
ffffffffc02032b8:	d4c78793          	addi	a5,a5,-692 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc02032bc:	a0f41de3          	bne	s0,a5,ffffffffc0202cd6 <pmm_init+0x206>
ffffffffc02032c0:	4581                	li	a1,0
ffffffffc02032c2:	6605                	lui	a2,0x1
ffffffffc02032c4:	8522                	mv	a0,s0
ffffffffc02032c6:	2d4080ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc02032ca:	0000d597          	auipc	a1,0xd
ffffffffc02032ce:	d3658593          	addi	a1,a1,-714 # ffffffffc0210000 <bootstackguard>
ffffffffc02032d2:	0000e797          	auipc	a5,0xe
ffffffffc02032d6:	d20786a3          	sb	zero,-723(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc02032da:	0000d797          	auipc	a5,0xd
ffffffffc02032de:	d2078323          	sb	zero,-730(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc02032e2:	00093503          	ld	a0,0(s2)
ffffffffc02032e6:	2555ec63          	bltu	a1,s5,ffffffffc020353e <pmm_init+0xa6e>
ffffffffc02032ea:	0009b683          	ld	a3,0(s3)
ffffffffc02032ee:	4701                	li	a4,0
ffffffffc02032f0:	6605                	lui	a2,0x1
ffffffffc02032f2:	40d586b3          	sub	a3,a1,a3
ffffffffc02032f6:	956ff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc02032fa:	00093503          	ld	a0,0(s2)
ffffffffc02032fe:	23546363          	bltu	s0,s5,ffffffffc0203524 <pmm_init+0xa54>
ffffffffc0203302:	0009b683          	ld	a3,0(s3)
ffffffffc0203306:	4701                	li	a4,0
ffffffffc0203308:	6605                	lui	a2,0x1
ffffffffc020330a:	40d406b3          	sub	a3,s0,a3
ffffffffc020330e:	85a2                	mv	a1,s0
ffffffffc0203310:	93cff0ef          	jal	ra,ffffffffc020244c <boot_map_segment>
ffffffffc0203314:	12000073          	sfence.vma
ffffffffc0203318:	00009517          	auipc	a0,0x9
ffffffffc020331c:	51850513          	addi	a0,a0,1304 # ffffffffc020c830 <default_pmm_manager+0x2c8>
ffffffffc0203320:	e87fc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0203324:	ba4d                	j	ffffffffc0202cd6 <pmm_init+0x206>
ffffffffc0203326:	0000a697          	auipc	a3,0xa
ffffffffc020332a:	85a68693          	addi	a3,a3,-1958 # ffffffffc020cb80 <default_pmm_manager+0x618>
ffffffffc020332e:	00008617          	auipc	a2,0x8
ffffffffc0203332:	75260613          	addi	a2,a2,1874 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203336:	28600593          	li	a1,646
ffffffffc020333a:	00009517          	auipc	a0,0x9
ffffffffc020333e:	37e50513          	addi	a0,a0,894 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203342:	95cfd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203346:	86a2                	mv	a3,s0
ffffffffc0203348:	00009617          	auipc	a2,0x9
ffffffffc020334c:	25860613          	addi	a2,a2,600 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0203350:	28600593          	li	a1,646
ffffffffc0203354:	00009517          	auipc	a0,0x9
ffffffffc0203358:	36450513          	addi	a0,a0,868 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020335c:	942fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203360:	0000a697          	auipc	a3,0xa
ffffffffc0203364:	86068693          	addi	a3,a3,-1952 # ffffffffc020cbc0 <default_pmm_manager+0x658>
ffffffffc0203368:	00008617          	auipc	a2,0x8
ffffffffc020336c:	71860613          	addi	a2,a2,1816 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203370:	28700593          	li	a1,647
ffffffffc0203374:	00009517          	auipc	a0,0x9
ffffffffc0203378:	34450513          	addi	a0,a0,836 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020337c:	922fd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203380:	db5fe0ef          	jal	ra,ffffffffc0202134 <pa2page.part.0>
ffffffffc0203384:	00009697          	auipc	a3,0x9
ffffffffc0203388:	66468693          	addi	a3,a3,1636 # ffffffffc020c9e8 <default_pmm_manager+0x480>
ffffffffc020338c:	00008617          	auipc	a2,0x8
ffffffffc0203390:	6f460613          	addi	a2,a2,1780 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203394:	26300593          	li	a1,611
ffffffffc0203398:	00009517          	auipc	a0,0x9
ffffffffc020339c:	32050513          	addi	a0,a0,800 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02033a0:	8fefd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033a4:	0000a697          	auipc	a3,0xa
ffffffffc02033a8:	8a468693          	addi	a3,a3,-1884 # ffffffffc020cc48 <default_pmm_manager+0x6e0>
ffffffffc02033ac:	00008617          	auipc	a2,0x8
ffffffffc02033b0:	6d460613          	addi	a2,a2,1748 # ffffffffc020ba80 <commands+0x210>
ffffffffc02033b4:	29000593          	li	a1,656
ffffffffc02033b8:	00009517          	auipc	a0,0x9
ffffffffc02033bc:	30050513          	addi	a0,a0,768 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02033c0:	8defd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033c4:	00009697          	auipc	a3,0x9
ffffffffc02033c8:	74468693          	addi	a3,a3,1860 # ffffffffc020cb08 <default_pmm_manager+0x5a0>
ffffffffc02033cc:	00008617          	auipc	a2,0x8
ffffffffc02033d0:	6b460613          	addi	a2,a2,1716 # ffffffffc020ba80 <commands+0x210>
ffffffffc02033d4:	26f00593          	li	a1,623
ffffffffc02033d8:	00009517          	auipc	a0,0x9
ffffffffc02033dc:	2e050513          	addi	a0,a0,736 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02033e0:	8befd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02033e4:	00009697          	auipc	a3,0x9
ffffffffc02033e8:	6f468693          	addi	a3,a3,1780 # ffffffffc020cad8 <default_pmm_manager+0x570>
ffffffffc02033ec:	00008617          	auipc	a2,0x8
ffffffffc02033f0:	69460613          	addi	a2,a2,1684 # ffffffffc020ba80 <commands+0x210>
ffffffffc02033f4:	26500593          	li	a1,613
ffffffffc02033f8:	00009517          	auipc	a0,0x9
ffffffffc02033fc:	2c050513          	addi	a0,a0,704 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203400:	89efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203404:	00009697          	auipc	a3,0x9
ffffffffc0203408:	54468693          	addi	a3,a3,1348 # ffffffffc020c948 <default_pmm_manager+0x3e0>
ffffffffc020340c:	00008617          	auipc	a2,0x8
ffffffffc0203410:	67460613          	addi	a2,a2,1652 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203414:	26400593          	li	a1,612
ffffffffc0203418:	00009517          	auipc	a0,0x9
ffffffffc020341c:	2a050513          	addi	a0,a0,672 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203420:	87efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203424:	00009697          	auipc	a3,0x9
ffffffffc0203428:	69c68693          	addi	a3,a3,1692 # ffffffffc020cac0 <default_pmm_manager+0x558>
ffffffffc020342c:	00008617          	auipc	a2,0x8
ffffffffc0203430:	65460613          	addi	a2,a2,1620 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203434:	26900593          	li	a1,617
ffffffffc0203438:	00009517          	auipc	a0,0x9
ffffffffc020343c:	28050513          	addi	a0,a0,640 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203440:	85efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203444:	00009697          	auipc	a3,0x9
ffffffffc0203448:	51c68693          	addi	a3,a3,1308 # ffffffffc020c960 <default_pmm_manager+0x3f8>
ffffffffc020344c:	00008617          	auipc	a2,0x8
ffffffffc0203450:	63460613          	addi	a2,a2,1588 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203454:	26800593          	li	a1,616
ffffffffc0203458:	00009517          	auipc	a0,0x9
ffffffffc020345c:	26050513          	addi	a0,a0,608 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203460:	83efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203464:	00009697          	auipc	a3,0x9
ffffffffc0203468:	77468693          	addi	a3,a3,1908 # ffffffffc020cbd8 <default_pmm_manager+0x670>
ffffffffc020346c:	00008617          	auipc	a2,0x8
ffffffffc0203470:	61460613          	addi	a2,a2,1556 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203474:	28a00593          	li	a1,650
ffffffffc0203478:	00009517          	auipc	a0,0x9
ffffffffc020347c:	24050513          	addi	a0,a0,576 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203480:	81efd0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203484:	00009697          	auipc	a3,0x9
ffffffffc0203488:	7ac68693          	addi	a3,a3,1964 # ffffffffc020cc30 <default_pmm_manager+0x6c8>
ffffffffc020348c:	00008617          	auipc	a2,0x8
ffffffffc0203490:	5f460613          	addi	a2,a2,1524 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203494:	28f00593          	li	a1,655
ffffffffc0203498:	00009517          	auipc	a0,0x9
ffffffffc020349c:	22050513          	addi	a0,a0,544 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02034a0:	ffffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034a4:	00009697          	auipc	a3,0x9
ffffffffc02034a8:	74c68693          	addi	a3,a3,1868 # ffffffffc020cbf0 <default_pmm_manager+0x688>
ffffffffc02034ac:	00008617          	auipc	a2,0x8
ffffffffc02034b0:	5d460613          	addi	a2,a2,1492 # ffffffffc020ba80 <commands+0x210>
ffffffffc02034b4:	28e00593          	li	a1,654
ffffffffc02034b8:	00009517          	auipc	a0,0x9
ffffffffc02034bc:	20050513          	addi	a0,a0,512 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02034c0:	fdffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034c4:	0000a697          	auipc	a3,0xa
ffffffffc02034c8:	83468693          	addi	a3,a3,-1996 # ffffffffc020ccf8 <default_pmm_manager+0x790>
ffffffffc02034cc:	00008617          	auipc	a2,0x8
ffffffffc02034d0:	5b460613          	addi	a2,a2,1460 # ffffffffc020ba80 <commands+0x210>
ffffffffc02034d4:	29800593          	li	a1,664
ffffffffc02034d8:	00009517          	auipc	a0,0x9
ffffffffc02034dc:	1e050513          	addi	a0,a0,480 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02034e0:	fbffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02034e4:	00009697          	auipc	a3,0x9
ffffffffc02034e8:	7dc68693          	addi	a3,a3,2012 # ffffffffc020ccc0 <default_pmm_manager+0x758>
ffffffffc02034ec:	00008617          	auipc	a2,0x8
ffffffffc02034f0:	59460613          	addi	a2,a2,1428 # ffffffffc020ba80 <commands+0x210>
ffffffffc02034f4:	29500593          	li	a1,661
ffffffffc02034f8:	00009517          	auipc	a0,0x9
ffffffffc02034fc:	1c050513          	addi	a0,a0,448 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203500:	f9ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203504:	00009697          	auipc	a3,0x9
ffffffffc0203508:	78c68693          	addi	a3,a3,1932 # ffffffffc020cc90 <default_pmm_manager+0x728>
ffffffffc020350c:	00008617          	auipc	a2,0x8
ffffffffc0203510:	57460613          	addi	a2,a2,1396 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203514:	29100593          	li	a1,657
ffffffffc0203518:	00009517          	auipc	a0,0x9
ffffffffc020351c:	1a050513          	addi	a0,a0,416 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203520:	f7ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203524:	86a2                	mv	a3,s0
ffffffffc0203526:	00009617          	auipc	a2,0x9
ffffffffc020352a:	12260613          	addi	a2,a2,290 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc020352e:	0dc00593          	li	a1,220
ffffffffc0203532:	00009517          	auipc	a0,0x9
ffffffffc0203536:	18650513          	addi	a0,a0,390 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020353a:	f65fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020353e:	86ae                	mv	a3,a1
ffffffffc0203540:	00009617          	auipc	a2,0x9
ffffffffc0203544:	10860613          	addi	a2,a2,264 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0203548:	0db00593          	li	a1,219
ffffffffc020354c:	00009517          	auipc	a0,0x9
ffffffffc0203550:	16c50513          	addi	a0,a0,364 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203554:	f4bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203558:	00009697          	auipc	a3,0x9
ffffffffc020355c:	32068693          	addi	a3,a3,800 # ffffffffc020c878 <default_pmm_manager+0x310>
ffffffffc0203560:	00008617          	auipc	a2,0x8
ffffffffc0203564:	52060613          	addi	a2,a2,1312 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203568:	24800593          	li	a1,584
ffffffffc020356c:	00009517          	auipc	a0,0x9
ffffffffc0203570:	14c50513          	addi	a0,a0,332 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203574:	f2bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203578:	00009697          	auipc	a3,0x9
ffffffffc020357c:	2e068693          	addi	a3,a3,736 # ffffffffc020c858 <default_pmm_manager+0x2f0>
ffffffffc0203580:	00008617          	auipc	a2,0x8
ffffffffc0203584:	50060613          	addi	a2,a2,1280 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203588:	24700593          	li	a1,583
ffffffffc020358c:	00009517          	auipc	a0,0x9
ffffffffc0203590:	12c50513          	addi	a0,a0,300 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203594:	f0bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203598:	00009617          	auipc	a2,0x9
ffffffffc020359c:	25060613          	addi	a2,a2,592 # ffffffffc020c7e8 <default_pmm_manager+0x280>
ffffffffc02035a0:	0aa00593          	li	a1,170
ffffffffc02035a4:	00009517          	auipc	a0,0x9
ffffffffc02035a8:	11450513          	addi	a0,a0,276 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02035ac:	ef3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035b0:	00009617          	auipc	a2,0x9
ffffffffc02035b4:	1a060613          	addi	a2,a2,416 # ffffffffc020c750 <default_pmm_manager+0x1e8>
ffffffffc02035b8:	06500593          	li	a1,101
ffffffffc02035bc:	00009517          	auipc	a0,0x9
ffffffffc02035c0:	0fc50513          	addi	a0,a0,252 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02035c4:	edbfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035c8:	00009697          	auipc	a3,0x9
ffffffffc02035cc:	57068693          	addi	a3,a3,1392 # ffffffffc020cb38 <default_pmm_manager+0x5d0>
ffffffffc02035d0:	00008617          	auipc	a2,0x8
ffffffffc02035d4:	4b060613          	addi	a2,a2,1200 # ffffffffc020ba80 <commands+0x210>
ffffffffc02035d8:	2a100593          	li	a1,673
ffffffffc02035dc:	00009517          	auipc	a0,0x9
ffffffffc02035e0:	0dc50513          	addi	a0,a0,220 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02035e4:	ebbfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02035e8:	00009697          	auipc	a3,0x9
ffffffffc02035ec:	39068693          	addi	a3,a3,912 # ffffffffc020c978 <default_pmm_manager+0x410>
ffffffffc02035f0:	00008617          	auipc	a2,0x8
ffffffffc02035f4:	49060613          	addi	a2,a2,1168 # ffffffffc020ba80 <commands+0x210>
ffffffffc02035f8:	25600593          	li	a1,598
ffffffffc02035fc:	00009517          	auipc	a0,0x9
ffffffffc0203600:	0bc50513          	addi	a0,a0,188 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203604:	e9bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203608:	86d6                	mv	a3,s5
ffffffffc020360a:	00009617          	auipc	a2,0x9
ffffffffc020360e:	f9660613          	addi	a2,a2,-106 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0203612:	25500593          	li	a1,597
ffffffffc0203616:	00009517          	auipc	a0,0x9
ffffffffc020361a:	0a250513          	addi	a0,a0,162 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020361e:	e81fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203622:	00009697          	auipc	a3,0x9
ffffffffc0203626:	49e68693          	addi	a3,a3,1182 # ffffffffc020cac0 <default_pmm_manager+0x558>
ffffffffc020362a:	00008617          	auipc	a2,0x8
ffffffffc020362e:	45660613          	addi	a2,a2,1110 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203632:	26200593          	li	a1,610
ffffffffc0203636:	00009517          	auipc	a0,0x9
ffffffffc020363a:	08250513          	addi	a0,a0,130 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020363e:	e61fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203642:	00009697          	auipc	a3,0x9
ffffffffc0203646:	46668693          	addi	a3,a3,1126 # ffffffffc020caa8 <default_pmm_manager+0x540>
ffffffffc020364a:	00008617          	auipc	a2,0x8
ffffffffc020364e:	43660613          	addi	a2,a2,1078 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203652:	26100593          	li	a1,609
ffffffffc0203656:	00009517          	auipc	a0,0x9
ffffffffc020365a:	06250513          	addi	a0,a0,98 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020365e:	e41fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203662:	00009697          	auipc	a3,0x9
ffffffffc0203666:	41668693          	addi	a3,a3,1046 # ffffffffc020ca78 <default_pmm_manager+0x510>
ffffffffc020366a:	00008617          	auipc	a2,0x8
ffffffffc020366e:	41660613          	addi	a2,a2,1046 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203672:	26000593          	li	a1,608
ffffffffc0203676:	00009517          	auipc	a0,0x9
ffffffffc020367a:	04250513          	addi	a0,a0,66 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020367e:	e21fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203682:	00009697          	auipc	a3,0x9
ffffffffc0203686:	3de68693          	addi	a3,a3,990 # ffffffffc020ca60 <default_pmm_manager+0x4f8>
ffffffffc020368a:	00008617          	auipc	a2,0x8
ffffffffc020368e:	3f660613          	addi	a2,a2,1014 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203692:	25e00593          	li	a1,606
ffffffffc0203696:	00009517          	auipc	a0,0x9
ffffffffc020369a:	02250513          	addi	a0,a0,34 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020369e:	e01fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036a2:	00009697          	auipc	a3,0x9
ffffffffc02036a6:	39e68693          	addi	a3,a3,926 # ffffffffc020ca40 <default_pmm_manager+0x4d8>
ffffffffc02036aa:	00008617          	auipc	a2,0x8
ffffffffc02036ae:	3d660613          	addi	a2,a2,982 # ffffffffc020ba80 <commands+0x210>
ffffffffc02036b2:	25d00593          	li	a1,605
ffffffffc02036b6:	00009517          	auipc	a0,0x9
ffffffffc02036ba:	00250513          	addi	a0,a0,2 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02036be:	de1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036c2:	00009697          	auipc	a3,0x9
ffffffffc02036c6:	36e68693          	addi	a3,a3,878 # ffffffffc020ca30 <default_pmm_manager+0x4c8>
ffffffffc02036ca:	00008617          	auipc	a2,0x8
ffffffffc02036ce:	3b660613          	addi	a2,a2,950 # ffffffffc020ba80 <commands+0x210>
ffffffffc02036d2:	25c00593          	li	a1,604
ffffffffc02036d6:	00009517          	auipc	a0,0x9
ffffffffc02036da:	fe250513          	addi	a0,a0,-30 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02036de:	dc1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02036e2:	00009697          	auipc	a3,0x9
ffffffffc02036e6:	33e68693          	addi	a3,a3,830 # ffffffffc020ca20 <default_pmm_manager+0x4b8>
ffffffffc02036ea:	00008617          	auipc	a2,0x8
ffffffffc02036ee:	39660613          	addi	a2,a2,918 # ffffffffc020ba80 <commands+0x210>
ffffffffc02036f2:	25b00593          	li	a1,603
ffffffffc02036f6:	00009517          	auipc	a0,0x9
ffffffffc02036fa:	fc250513          	addi	a0,a0,-62 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02036fe:	da1fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203702:	00009697          	auipc	a3,0x9
ffffffffc0203706:	2e668693          	addi	a3,a3,742 # ffffffffc020c9e8 <default_pmm_manager+0x480>
ffffffffc020370a:	00008617          	auipc	a2,0x8
ffffffffc020370e:	37660613          	addi	a2,a2,886 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203712:	25a00593          	li	a1,602
ffffffffc0203716:	00009517          	auipc	a0,0x9
ffffffffc020371a:	fa250513          	addi	a0,a0,-94 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020371e:	d81fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203722:	00009697          	auipc	a3,0x9
ffffffffc0203726:	41668693          	addi	a3,a3,1046 # ffffffffc020cb38 <default_pmm_manager+0x5d0>
ffffffffc020372a:	00008617          	auipc	a2,0x8
ffffffffc020372e:	35660613          	addi	a2,a2,854 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203732:	27700593          	li	a1,631
ffffffffc0203736:	00009517          	auipc	a0,0x9
ffffffffc020373a:	f8250513          	addi	a0,a0,-126 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020373e:	d61fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203742:	00009617          	auipc	a2,0x9
ffffffffc0203746:	e5e60613          	addi	a2,a2,-418 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc020374a:	07100593          	li	a1,113
ffffffffc020374e:	00009517          	auipc	a0,0x9
ffffffffc0203752:	e7a50513          	addi	a0,a0,-390 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0203756:	d49fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020375a:	86a2                	mv	a3,s0
ffffffffc020375c:	00009617          	auipc	a2,0x9
ffffffffc0203760:	eec60613          	addi	a2,a2,-276 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0203764:	0ca00593          	li	a1,202
ffffffffc0203768:	00009517          	auipc	a0,0x9
ffffffffc020376c:	f5050513          	addi	a0,a0,-176 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203770:	d2ffc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203774:	00009617          	auipc	a2,0x9
ffffffffc0203778:	ed460613          	addi	a2,a2,-300 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc020377c:	08100593          	li	a1,129
ffffffffc0203780:	00009517          	auipc	a0,0x9
ffffffffc0203784:	f3850513          	addi	a0,a0,-200 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203788:	d17fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020378c:	00009697          	auipc	a3,0x9
ffffffffc0203790:	21c68693          	addi	a3,a3,540 # ffffffffc020c9a8 <default_pmm_manager+0x440>
ffffffffc0203794:	00008617          	auipc	a2,0x8
ffffffffc0203798:	2ec60613          	addi	a2,a2,748 # ffffffffc020ba80 <commands+0x210>
ffffffffc020379c:	25900593          	li	a1,601
ffffffffc02037a0:	00009517          	auipc	a0,0x9
ffffffffc02037a4:	f1850513          	addi	a0,a0,-232 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02037a8:	cf7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037ac:	00009697          	auipc	a3,0x9
ffffffffc02037b0:	13c68693          	addi	a3,a3,316 # ffffffffc020c8e8 <default_pmm_manager+0x380>
ffffffffc02037b4:	00008617          	auipc	a2,0x8
ffffffffc02037b8:	2cc60613          	addi	a2,a2,716 # ffffffffc020ba80 <commands+0x210>
ffffffffc02037bc:	24d00593          	li	a1,589
ffffffffc02037c0:	00009517          	auipc	a0,0x9
ffffffffc02037c4:	ef850513          	addi	a0,a0,-264 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02037c8:	cd7fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037cc:	985fe0ef          	jal	ra,ffffffffc0202150 <pte2page.part.0>
ffffffffc02037d0:	00009697          	auipc	a3,0x9
ffffffffc02037d4:	14868693          	addi	a3,a3,328 # ffffffffc020c918 <default_pmm_manager+0x3b0>
ffffffffc02037d8:	00008617          	auipc	a2,0x8
ffffffffc02037dc:	2a860613          	addi	a2,a2,680 # ffffffffc020ba80 <commands+0x210>
ffffffffc02037e0:	25000593          	li	a1,592
ffffffffc02037e4:	00009517          	auipc	a0,0x9
ffffffffc02037e8:	ed450513          	addi	a0,a0,-300 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02037ec:	cb3fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02037f0:	00009697          	auipc	a3,0x9
ffffffffc02037f4:	0c868693          	addi	a3,a3,200 # ffffffffc020c8b8 <default_pmm_manager+0x350>
ffffffffc02037f8:	00008617          	auipc	a2,0x8
ffffffffc02037fc:	28860613          	addi	a2,a2,648 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203800:	24900593          	li	a1,585
ffffffffc0203804:	00009517          	auipc	a0,0x9
ffffffffc0203808:	eb450513          	addi	a0,a0,-332 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020380c:	c93fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203810:	00009697          	auipc	a3,0x9
ffffffffc0203814:	13868693          	addi	a3,a3,312 # ffffffffc020c948 <default_pmm_manager+0x3e0>
ffffffffc0203818:	00008617          	auipc	a2,0x8
ffffffffc020381c:	26860613          	addi	a2,a2,616 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203820:	25100593          	li	a1,593
ffffffffc0203824:	00009517          	auipc	a0,0x9
ffffffffc0203828:	e9450513          	addi	a0,a0,-364 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020382c:	c73fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203830:	00009617          	auipc	a2,0x9
ffffffffc0203834:	d7060613          	addi	a2,a2,-656 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0203838:	25400593          	li	a1,596
ffffffffc020383c:	00009517          	auipc	a0,0x9
ffffffffc0203840:	e7c50513          	addi	a0,a0,-388 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203844:	c5bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203848:	00009697          	auipc	a3,0x9
ffffffffc020384c:	11868693          	addi	a3,a3,280 # ffffffffc020c960 <default_pmm_manager+0x3f8>
ffffffffc0203850:	00008617          	auipc	a2,0x8
ffffffffc0203854:	23060613          	addi	a2,a2,560 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203858:	25200593          	li	a1,594
ffffffffc020385c:	00009517          	auipc	a0,0x9
ffffffffc0203860:	e5c50513          	addi	a0,a0,-420 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203864:	c3bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203868:	86ca                	mv	a3,s2
ffffffffc020386a:	00009617          	auipc	a2,0x9
ffffffffc020386e:	dde60613          	addi	a2,a2,-546 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0203872:	0c600593          	li	a1,198
ffffffffc0203876:	00009517          	auipc	a0,0x9
ffffffffc020387a:	e4250513          	addi	a0,a0,-446 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020387e:	c21fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203882:	00009697          	auipc	a3,0x9
ffffffffc0203886:	23e68693          	addi	a3,a3,574 # ffffffffc020cac0 <default_pmm_manager+0x558>
ffffffffc020388a:	00008617          	auipc	a2,0x8
ffffffffc020388e:	1f660613          	addi	a2,a2,502 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203892:	26d00593          	li	a1,621
ffffffffc0203896:	00009517          	auipc	a0,0x9
ffffffffc020389a:	e2250513          	addi	a0,a0,-478 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc020389e:	c01fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02038a2:	00009697          	auipc	a3,0x9
ffffffffc02038a6:	24e68693          	addi	a3,a3,590 # ffffffffc020caf0 <default_pmm_manager+0x588>
ffffffffc02038aa:	00008617          	auipc	a2,0x8
ffffffffc02038ae:	1d660613          	addi	a2,a2,470 # ffffffffc020ba80 <commands+0x210>
ffffffffc02038b2:	26c00593          	li	a1,620
ffffffffc02038b6:	00009517          	auipc	a0,0x9
ffffffffc02038ba:	e0250513          	addi	a0,a0,-510 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc02038be:	be1fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02038c2 <copy_range>:
ffffffffc02038c2:	7119                	addi	sp,sp,-128
ffffffffc02038c4:	f4a6                	sd	s1,104(sp)
ffffffffc02038c6:	84b6                	mv	s1,a3
ffffffffc02038c8:	8ed1                	or	a3,a3,a2
ffffffffc02038ca:	fc86                	sd	ra,120(sp)
ffffffffc02038cc:	f8a2                	sd	s0,112(sp)
ffffffffc02038ce:	f0ca                	sd	s2,96(sp)
ffffffffc02038d0:	ecce                	sd	s3,88(sp)
ffffffffc02038d2:	e8d2                	sd	s4,80(sp)
ffffffffc02038d4:	e4d6                	sd	s5,72(sp)
ffffffffc02038d6:	e0da                	sd	s6,64(sp)
ffffffffc02038d8:	fc5e                	sd	s7,56(sp)
ffffffffc02038da:	f862                	sd	s8,48(sp)
ffffffffc02038dc:	f466                	sd	s9,40(sp)
ffffffffc02038de:	f06a                	sd	s10,32(sp)
ffffffffc02038e0:	ec6e                	sd	s11,24(sp)
ffffffffc02038e2:	16d2                	slli	a3,a3,0x34
ffffffffc02038e4:	e43a                	sd	a4,8(sp)
ffffffffc02038e6:	28069d63          	bnez	a3,ffffffffc0203b80 <copy_range+0x2be>
ffffffffc02038ea:	00200737          	lui	a4,0x200
ffffffffc02038ee:	8db2                	mv	s11,a2
ffffffffc02038f0:	1ce66363          	bltu	a2,a4,ffffffffc0203ab6 <copy_range+0x1f4>
ffffffffc02038f4:	1c967163          	bgeu	a2,s1,ffffffffc0203ab6 <copy_range+0x1f4>
ffffffffc02038f8:	4705                	li	a4,1
ffffffffc02038fa:	077e                	slli	a4,a4,0x1f
ffffffffc02038fc:	1a976d63          	bltu	a4,s1,ffffffffc0203ab6 <copy_range+0x1f4>
ffffffffc0203900:	5c7d                	li	s8,-1
ffffffffc0203902:	8a2a                	mv	s4,a0
ffffffffc0203904:	842e                	mv	s0,a1
ffffffffc0203906:	6985                	lui	s3,0x1
ffffffffc0203908:	00093b97          	auipc	s7,0x93
ffffffffc020390c:	f98b8b93          	addi	s7,s7,-104 # ffffffffc02968a0 <npage>
ffffffffc0203910:	00093b17          	auipc	s6,0x93
ffffffffc0203914:	f98b0b13          	addi	s6,s6,-104 # ffffffffc02968a8 <pages>
ffffffffc0203918:	00cc5c13          	srli	s8,s8,0xc
ffffffffc020391c:	00093a97          	auipc	s5,0x93
ffffffffc0203920:	f94a8a93          	addi	s5,s5,-108 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203924:	4601                	li	a2,0
ffffffffc0203926:	85ee                	mv	a1,s11
ffffffffc0203928:	8522                	mv	a0,s0
ffffffffc020392a:	8fbfe0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc020392e:	892a                	mv	s2,a0
ffffffffc0203930:	c555                	beqz	a0,ffffffffc02039dc <copy_range+0x11a>
ffffffffc0203932:	6118                	ld	a4,0(a0)
ffffffffc0203934:	8b05                	andi	a4,a4,1
ffffffffc0203936:	e705                	bnez	a4,ffffffffc020395e <copy_range+0x9c>
ffffffffc0203938:	9dce                	add	s11,s11,s3
ffffffffc020393a:	fe9de5e3          	bltu	s11,s1,ffffffffc0203924 <copy_range+0x62>
ffffffffc020393e:	4501                	li	a0,0
ffffffffc0203940:	70e6                	ld	ra,120(sp)
ffffffffc0203942:	7446                	ld	s0,112(sp)
ffffffffc0203944:	74a6                	ld	s1,104(sp)
ffffffffc0203946:	7906                	ld	s2,96(sp)
ffffffffc0203948:	69e6                	ld	s3,88(sp)
ffffffffc020394a:	6a46                	ld	s4,80(sp)
ffffffffc020394c:	6aa6                	ld	s5,72(sp)
ffffffffc020394e:	6b06                	ld	s6,64(sp)
ffffffffc0203950:	7be2                	ld	s7,56(sp)
ffffffffc0203952:	7c42                	ld	s8,48(sp)
ffffffffc0203954:	7ca2                	ld	s9,40(sp)
ffffffffc0203956:	7d02                	ld	s10,32(sp)
ffffffffc0203958:	6de2                	ld	s11,24(sp)
ffffffffc020395a:	6109                	addi	sp,sp,128
ffffffffc020395c:	8082                	ret
ffffffffc020395e:	4605                	li	a2,1
ffffffffc0203960:	85ee                	mv	a1,s11
ffffffffc0203962:	8552                	mv	a0,s4
ffffffffc0203964:	8c1fe0ef          	jal	ra,ffffffffc0202224 <get_pte>
ffffffffc0203968:	14050563          	beqz	a0,ffffffffc0203ab2 <copy_range+0x1f0>
ffffffffc020396c:	00093703          	ld	a4,0(s2)
ffffffffc0203970:	00177693          	andi	a3,a4,1
ffffffffc0203974:	0007091b          	sext.w	s2,a4
ffffffffc0203978:	1e068863          	beqz	a3,ffffffffc0203b68 <copy_range+0x2a6>
ffffffffc020397c:	000bb683          	ld	a3,0(s7)
ffffffffc0203980:	070a                	slli	a4,a4,0x2
ffffffffc0203982:	8331                	srli	a4,a4,0xc
ffffffffc0203984:	1cd77663          	bgeu	a4,a3,ffffffffc0203b50 <copy_range+0x28e>
ffffffffc0203988:	000b3583          	ld	a1,0(s6)
ffffffffc020398c:	fff807b7          	lui	a5,0xfff80
ffffffffc0203990:	973e                	add	a4,a4,a5
ffffffffc0203992:	071a                	slli	a4,a4,0x6
ffffffffc0203994:	00e58d33          	add	s10,a1,a4
ffffffffc0203998:	10002773          	csrr	a4,sstatus
ffffffffc020399c:	8b09                	andi	a4,a4,2
ffffffffc020399e:	e765                	bnez	a4,ffffffffc0203a86 <copy_range+0x1c4>
ffffffffc02039a0:	000ab703          	ld	a4,0(s5)
ffffffffc02039a4:	4505                	li	a0,1
ffffffffc02039a6:	6f18                	ld	a4,24(a4)
ffffffffc02039a8:	9702                	jalr	a4
ffffffffc02039aa:	8caa                	mv	s9,a0
ffffffffc02039ac:	160d0563          	beqz	s10,ffffffffc0203b16 <copy_range+0x254>
ffffffffc02039b0:	140c8363          	beqz	s9,ffffffffc0203af6 <copy_range+0x234>
ffffffffc02039b4:	67a2                	ld	a5,8(sp)
ffffffffc02039b6:	c3a1                	beqz	a5,ffffffffc02039f6 <copy_range+0x134>
ffffffffc02039b8:	01b97913          	andi	s2,s2,27
ffffffffc02039bc:	86ca                	mv	a3,s2
ffffffffc02039be:	866e                	mv	a2,s11
ffffffffc02039c0:	85ea                	mv	a1,s10
ffffffffc02039c2:	8552                	mv	a0,s4
ffffffffc02039c4:	816ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc02039c8:	fd25                	bnez	a0,ffffffffc0203940 <copy_range+0x7e>
ffffffffc02039ca:	86ca                	mv	a3,s2
ffffffffc02039cc:	866e                	mv	a2,s11
ffffffffc02039ce:	85ea                	mv	a1,s10
ffffffffc02039d0:	8522                	mv	a0,s0
ffffffffc02039d2:	808ff0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc02039d6:	f52d                	bnez	a0,ffffffffc0203940 <copy_range+0x7e>
ffffffffc02039d8:	9dce                	add	s11,s11,s3
ffffffffc02039da:	b785                	j	ffffffffc020393a <copy_range+0x78>
ffffffffc02039dc:	00200637          	lui	a2,0x200
ffffffffc02039e0:	00cd87b3          	add	a5,s11,a2
ffffffffc02039e4:	ffe00637          	lui	a2,0xffe00
ffffffffc02039e8:	00c7fdb3          	and	s11,a5,a2
ffffffffc02039ec:	f40d89e3          	beqz	s11,ffffffffc020393e <copy_range+0x7c>
ffffffffc02039f0:	f29deae3          	bltu	s11,s1,ffffffffc0203924 <copy_range+0x62>
ffffffffc02039f4:	b7a9                	j	ffffffffc020393e <copy_range+0x7c>
ffffffffc02039f6:	10002773          	csrr	a4,sstatus
ffffffffc02039fa:	8b09                	andi	a4,a4,2
ffffffffc02039fc:	e345                	bnez	a4,ffffffffc0203a9c <copy_range+0x1da>
ffffffffc02039fe:	000ab703          	ld	a4,0(s5)
ffffffffc0203a02:	4505                	li	a0,1
ffffffffc0203a04:	6f18                	ld	a4,24(a4)
ffffffffc0203a06:	9702                	jalr	a4
ffffffffc0203a08:	8caa                	mv	s9,a0
ffffffffc0203a0a:	0c0c8663          	beqz	s9,ffffffffc0203ad6 <copy_range+0x214>
ffffffffc0203a0e:	000b3703          	ld	a4,0(s6)
ffffffffc0203a12:	000808b7          	lui	a7,0x80
ffffffffc0203a16:	000bb603          	ld	a2,0(s7)
ffffffffc0203a1a:	40ed06b3          	sub	a3,s10,a4
ffffffffc0203a1e:	8699                	srai	a3,a3,0x6
ffffffffc0203a20:	96c6                	add	a3,a3,a7
ffffffffc0203a22:	0186f5b3          	and	a1,a3,s8
ffffffffc0203a26:	06b2                	slli	a3,a3,0xc
ffffffffc0203a28:	10c5f863          	bgeu	a1,a2,ffffffffc0203b38 <copy_range+0x276>
ffffffffc0203a2c:	40ec8733          	sub	a4,s9,a4
ffffffffc0203a30:	00093797          	auipc	a5,0x93
ffffffffc0203a34:	e8878793          	addi	a5,a5,-376 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0203a38:	6388                	ld	a0,0(a5)
ffffffffc0203a3a:	8719                	srai	a4,a4,0x6
ffffffffc0203a3c:	9746                	add	a4,a4,a7
ffffffffc0203a3e:	018778b3          	and	a7,a4,s8
ffffffffc0203a42:	00a685b3          	add	a1,a3,a0
ffffffffc0203a46:	0732                	slli	a4,a4,0xc
ffffffffc0203a48:	0ec8f763          	bgeu	a7,a2,ffffffffc0203b36 <copy_range+0x274>
ffffffffc0203a4c:	6605                	lui	a2,0x1
ffffffffc0203a4e:	953a                	add	a0,a0,a4
ffffffffc0203a50:	39d070ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc0203a54:	01f97693          	andi	a3,s2,31
ffffffffc0203a58:	866e                	mv	a2,s11
ffffffffc0203a5a:	85e6                	mv	a1,s9
ffffffffc0203a5c:	8552                	mv	a0,s4
ffffffffc0203a5e:	f7dfe0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203a62:	ec050be3          	beqz	a0,ffffffffc0203938 <copy_range+0x76>
ffffffffc0203a66:	00009697          	auipc	a3,0x9
ffffffffc0203a6a:	2fa68693          	addi	a3,a3,762 # ffffffffc020cd60 <default_pmm_manager+0x7f8>
ffffffffc0203a6e:	00008617          	auipc	a2,0x8
ffffffffc0203a72:	01260613          	addi	a2,a2,18 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203a76:	1e400593          	li	a1,484
ffffffffc0203a7a:	00009517          	auipc	a0,0x9
ffffffffc0203a7e:	c3e50513          	addi	a0,a0,-962 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203a82:	a1dfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203a86:	9ecfd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203a8a:	000ab703          	ld	a4,0(s5)
ffffffffc0203a8e:	4505                	li	a0,1
ffffffffc0203a90:	6f18                	ld	a4,24(a4)
ffffffffc0203a92:	9702                	jalr	a4
ffffffffc0203a94:	8caa                	mv	s9,a0
ffffffffc0203a96:	9d6fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203a9a:	bf09                	j	ffffffffc02039ac <copy_range+0xea>
ffffffffc0203a9c:	9d6fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203aa0:	000ab703          	ld	a4,0(s5)
ffffffffc0203aa4:	4505                	li	a0,1
ffffffffc0203aa6:	6f18                	ld	a4,24(a4)
ffffffffc0203aa8:	9702                	jalr	a4
ffffffffc0203aaa:	8caa                	mv	s9,a0
ffffffffc0203aac:	9c0fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203ab0:	bfa9                	j	ffffffffc0203a0a <copy_range+0x148>
ffffffffc0203ab2:	5571                	li	a0,-4
ffffffffc0203ab4:	b571                	j	ffffffffc0203940 <copy_range+0x7e>
ffffffffc0203ab6:	00009697          	auipc	a3,0x9
ffffffffc0203aba:	c6a68693          	addi	a3,a3,-918 # ffffffffc020c720 <default_pmm_manager+0x1b8>
ffffffffc0203abe:	00008617          	auipc	a2,0x8
ffffffffc0203ac2:	fc260613          	addi	a2,a2,-62 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203ac6:	1b600593          	li	a1,438
ffffffffc0203aca:	00009517          	auipc	a0,0x9
ffffffffc0203ace:	bee50513          	addi	a0,a0,-1042 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203ad2:	9cdfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203ad6:	00009697          	auipc	a3,0x9
ffffffffc0203ada:	27a68693          	addi	a3,a3,634 # ffffffffc020cd50 <default_pmm_manager+0x7e8>
ffffffffc0203ade:	00008617          	auipc	a2,0x8
ffffffffc0203ae2:	fa260613          	addi	a2,a2,-94 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203ae6:	1df00593          	li	a1,479
ffffffffc0203aea:	00009517          	auipc	a0,0x9
ffffffffc0203aee:	bce50513          	addi	a0,a0,-1074 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203af2:	9adfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203af6:	00009697          	auipc	a3,0x9
ffffffffc0203afa:	25a68693          	addi	a3,a3,602 # ffffffffc020cd50 <default_pmm_manager+0x7e8>
ffffffffc0203afe:	00008617          	auipc	a2,0x8
ffffffffc0203b02:	f8260613          	addi	a2,a2,-126 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203b06:	1cf00593          	li	a1,463
ffffffffc0203b0a:	00009517          	auipc	a0,0x9
ffffffffc0203b0e:	bae50513          	addi	a0,a0,-1106 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203b12:	98dfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b16:	00009697          	auipc	a3,0x9
ffffffffc0203b1a:	22a68693          	addi	a3,a3,554 # ffffffffc020cd40 <default_pmm_manager+0x7d8>
ffffffffc0203b1e:	00008617          	auipc	a2,0x8
ffffffffc0203b22:	f6260613          	addi	a2,a2,-158 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203b26:	1ce00593          	li	a1,462
ffffffffc0203b2a:	00009517          	auipc	a0,0x9
ffffffffc0203b2e:	b8e50513          	addi	a0,a0,-1138 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203b32:	96dfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b36:	86ba                	mv	a3,a4
ffffffffc0203b38:	00009617          	auipc	a2,0x9
ffffffffc0203b3c:	a6860613          	addi	a2,a2,-1432 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0203b40:	07100593          	li	a1,113
ffffffffc0203b44:	00009517          	auipc	a0,0x9
ffffffffc0203b48:	a8450513          	addi	a0,a0,-1404 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0203b4c:	953fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b50:	00009617          	auipc	a2,0x9
ffffffffc0203b54:	b2060613          	addi	a2,a2,-1248 # ffffffffc020c670 <default_pmm_manager+0x108>
ffffffffc0203b58:	06900593          	li	a1,105
ffffffffc0203b5c:	00009517          	auipc	a0,0x9
ffffffffc0203b60:	a6c50513          	addi	a0,a0,-1428 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0203b64:	93bfc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b68:	00009617          	auipc	a2,0x9
ffffffffc0203b6c:	b2860613          	addi	a2,a2,-1240 # ffffffffc020c690 <default_pmm_manager+0x128>
ffffffffc0203b70:	07f00593          	li	a1,127
ffffffffc0203b74:	00009517          	auipc	a0,0x9
ffffffffc0203b78:	a5450513          	addi	a0,a0,-1452 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0203b7c:	923fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203b80:	00009697          	auipc	a3,0x9
ffffffffc0203b84:	b7068693          	addi	a3,a3,-1168 # ffffffffc020c6f0 <default_pmm_manager+0x188>
ffffffffc0203b88:	00008617          	auipc	a2,0x8
ffffffffc0203b8c:	ef860613          	addi	a2,a2,-264 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203b90:	1b500593          	li	a1,437
ffffffffc0203b94:	00009517          	auipc	a0,0x9
ffffffffc0203b98:	b2450513          	addi	a0,a0,-1244 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203b9c:	903fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203ba0 <pgdir_alloc_page>:
ffffffffc0203ba0:	7179                	addi	sp,sp,-48
ffffffffc0203ba2:	ec26                	sd	s1,24(sp)
ffffffffc0203ba4:	e84a                	sd	s2,16(sp)
ffffffffc0203ba6:	e052                	sd	s4,0(sp)
ffffffffc0203ba8:	f406                	sd	ra,40(sp)
ffffffffc0203baa:	f022                	sd	s0,32(sp)
ffffffffc0203bac:	e44e                	sd	s3,8(sp)
ffffffffc0203bae:	8a2a                	mv	s4,a0
ffffffffc0203bb0:	84ae                	mv	s1,a1
ffffffffc0203bb2:	8932                	mv	s2,a2
ffffffffc0203bb4:	100027f3          	csrr	a5,sstatus
ffffffffc0203bb8:	8b89                	andi	a5,a5,2
ffffffffc0203bba:	00093997          	auipc	s3,0x93
ffffffffc0203bbe:	cf698993          	addi	s3,s3,-778 # ffffffffc02968b0 <pmm_manager>
ffffffffc0203bc2:	ef8d                	bnez	a5,ffffffffc0203bfc <pgdir_alloc_page+0x5c>
ffffffffc0203bc4:	0009b783          	ld	a5,0(s3)
ffffffffc0203bc8:	4505                	li	a0,1
ffffffffc0203bca:	6f9c                	ld	a5,24(a5)
ffffffffc0203bcc:	9782                	jalr	a5
ffffffffc0203bce:	842a                	mv	s0,a0
ffffffffc0203bd0:	cc09                	beqz	s0,ffffffffc0203bea <pgdir_alloc_page+0x4a>
ffffffffc0203bd2:	86ca                	mv	a3,s2
ffffffffc0203bd4:	8626                	mv	a2,s1
ffffffffc0203bd6:	85a2                	mv	a1,s0
ffffffffc0203bd8:	8552                	mv	a0,s4
ffffffffc0203bda:	e01fe0ef          	jal	ra,ffffffffc02029da <page_insert>
ffffffffc0203bde:	e915                	bnez	a0,ffffffffc0203c12 <pgdir_alloc_page+0x72>
ffffffffc0203be0:	4018                	lw	a4,0(s0)
ffffffffc0203be2:	fc04                	sd	s1,56(s0)
ffffffffc0203be4:	4785                	li	a5,1
ffffffffc0203be6:	04f71e63          	bne	a4,a5,ffffffffc0203c42 <pgdir_alloc_page+0xa2>
ffffffffc0203bea:	70a2                	ld	ra,40(sp)
ffffffffc0203bec:	8522                	mv	a0,s0
ffffffffc0203bee:	7402                	ld	s0,32(sp)
ffffffffc0203bf0:	64e2                	ld	s1,24(sp)
ffffffffc0203bf2:	6942                	ld	s2,16(sp)
ffffffffc0203bf4:	69a2                	ld	s3,8(sp)
ffffffffc0203bf6:	6a02                	ld	s4,0(sp)
ffffffffc0203bf8:	6145                	addi	sp,sp,48
ffffffffc0203bfa:	8082                	ret
ffffffffc0203bfc:	876fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203c00:	0009b783          	ld	a5,0(s3)
ffffffffc0203c04:	4505                	li	a0,1
ffffffffc0203c06:	6f9c                	ld	a5,24(a5)
ffffffffc0203c08:	9782                	jalr	a5
ffffffffc0203c0a:	842a                	mv	s0,a0
ffffffffc0203c0c:	860fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203c10:	b7c1                	j	ffffffffc0203bd0 <pgdir_alloc_page+0x30>
ffffffffc0203c12:	100027f3          	csrr	a5,sstatus
ffffffffc0203c16:	8b89                	andi	a5,a5,2
ffffffffc0203c18:	eb89                	bnez	a5,ffffffffc0203c2a <pgdir_alloc_page+0x8a>
ffffffffc0203c1a:	0009b783          	ld	a5,0(s3)
ffffffffc0203c1e:	8522                	mv	a0,s0
ffffffffc0203c20:	4585                	li	a1,1
ffffffffc0203c22:	739c                	ld	a5,32(a5)
ffffffffc0203c24:	4401                	li	s0,0
ffffffffc0203c26:	9782                	jalr	a5
ffffffffc0203c28:	b7c9                	j	ffffffffc0203bea <pgdir_alloc_page+0x4a>
ffffffffc0203c2a:	848fd0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0203c2e:	0009b783          	ld	a5,0(s3)
ffffffffc0203c32:	8522                	mv	a0,s0
ffffffffc0203c34:	4585                	li	a1,1
ffffffffc0203c36:	739c                	ld	a5,32(a5)
ffffffffc0203c38:	4401                	li	s0,0
ffffffffc0203c3a:	9782                	jalr	a5
ffffffffc0203c3c:	830fd0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0203c40:	b76d                	j	ffffffffc0203bea <pgdir_alloc_page+0x4a>
ffffffffc0203c42:	00009697          	auipc	a3,0x9
ffffffffc0203c46:	12e68693          	addi	a3,a3,302 # ffffffffc020cd70 <default_pmm_manager+0x808>
ffffffffc0203c4a:	00008617          	auipc	a2,0x8
ffffffffc0203c4e:	e3660613          	addi	a2,a2,-458 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203c52:	22e00593          	li	a1,558
ffffffffc0203c56:	00009517          	auipc	a0,0x9
ffffffffc0203c5a:	a6250513          	addi	a0,a0,-1438 # ffffffffc020c6b8 <default_pmm_manager+0x150>
ffffffffc0203c5e:	841fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203c62 <check_vma_overlap.part.0>:
ffffffffc0203c62:	1141                	addi	sp,sp,-16
ffffffffc0203c64:	00009697          	auipc	a3,0x9
ffffffffc0203c68:	12468693          	addi	a3,a3,292 # ffffffffc020cd88 <default_pmm_manager+0x820>
ffffffffc0203c6c:	00008617          	auipc	a2,0x8
ffffffffc0203c70:	e1460613          	addi	a2,a2,-492 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203c74:	07400593          	li	a1,116
ffffffffc0203c78:	00009517          	auipc	a0,0x9
ffffffffc0203c7c:	13050513          	addi	a0,a0,304 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0203c80:	e406                	sd	ra,8(sp)
ffffffffc0203c82:	81dfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203c86 <mm_create>:
ffffffffc0203c86:	1141                	addi	sp,sp,-16
ffffffffc0203c88:	05800513          	li	a0,88
ffffffffc0203c8c:	e022                	sd	s0,0(sp)
ffffffffc0203c8e:	e406                	sd	ra,8(sp)
ffffffffc0203c90:	afefe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203c94:	842a                	mv	s0,a0
ffffffffc0203c96:	c115                	beqz	a0,ffffffffc0203cba <mm_create+0x34>
ffffffffc0203c98:	e408                	sd	a0,8(s0)
ffffffffc0203c9a:	e008                	sd	a0,0(s0)
ffffffffc0203c9c:	00053823          	sd	zero,16(a0)
ffffffffc0203ca0:	00053c23          	sd	zero,24(a0)
ffffffffc0203ca4:	02052023          	sw	zero,32(a0)
ffffffffc0203ca8:	02053423          	sd	zero,40(a0)
ffffffffc0203cac:	02052823          	sw	zero,48(a0)
ffffffffc0203cb0:	4585                	li	a1,1
ffffffffc0203cb2:	03850513          	addi	a0,a0,56
ffffffffc0203cb6:	123000ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc0203cba:	60a2                	ld	ra,8(sp)
ffffffffc0203cbc:	8522                	mv	a0,s0
ffffffffc0203cbe:	6402                	ld	s0,0(sp)
ffffffffc0203cc0:	0141                	addi	sp,sp,16
ffffffffc0203cc2:	8082                	ret

ffffffffc0203cc4 <find_vma>:
ffffffffc0203cc4:	86aa                	mv	a3,a0
ffffffffc0203cc6:	c505                	beqz	a0,ffffffffc0203cee <find_vma+0x2a>
ffffffffc0203cc8:	6908                	ld	a0,16(a0)
ffffffffc0203cca:	c501                	beqz	a0,ffffffffc0203cd2 <find_vma+0xe>
ffffffffc0203ccc:	651c                	ld	a5,8(a0)
ffffffffc0203cce:	02f5f263          	bgeu	a1,a5,ffffffffc0203cf2 <find_vma+0x2e>
ffffffffc0203cd2:	669c                	ld	a5,8(a3)
ffffffffc0203cd4:	00f68d63          	beq	a3,a5,ffffffffc0203cee <find_vma+0x2a>
ffffffffc0203cd8:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203cdc:	00e5e663          	bltu	a1,a4,ffffffffc0203ce8 <find_vma+0x24>
ffffffffc0203ce0:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203ce4:	00e5ec63          	bltu	a1,a4,ffffffffc0203cfc <find_vma+0x38>
ffffffffc0203ce8:	679c                	ld	a5,8(a5)
ffffffffc0203cea:	fef697e3          	bne	a3,a5,ffffffffc0203cd8 <find_vma+0x14>
ffffffffc0203cee:	4501                	li	a0,0
ffffffffc0203cf0:	8082                	ret
ffffffffc0203cf2:	691c                	ld	a5,16(a0)
ffffffffc0203cf4:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0203cd2 <find_vma+0xe>
ffffffffc0203cf8:	ea88                	sd	a0,16(a3)
ffffffffc0203cfa:	8082                	ret
ffffffffc0203cfc:	fe078513          	addi	a0,a5,-32
ffffffffc0203d00:	ea88                	sd	a0,16(a3)
ffffffffc0203d02:	8082                	ret

ffffffffc0203d04 <insert_vma_struct>:
ffffffffc0203d04:	6590                	ld	a2,8(a1)
ffffffffc0203d06:	0105b803          	ld	a6,16(a1)
ffffffffc0203d0a:	1141                	addi	sp,sp,-16
ffffffffc0203d0c:	e406                	sd	ra,8(sp)
ffffffffc0203d0e:	87aa                	mv	a5,a0
ffffffffc0203d10:	01066763          	bltu	a2,a6,ffffffffc0203d1e <insert_vma_struct+0x1a>
ffffffffc0203d14:	a085                	j	ffffffffc0203d74 <insert_vma_struct+0x70>
ffffffffc0203d16:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d1a:	04e66863          	bltu	a2,a4,ffffffffc0203d6a <insert_vma_struct+0x66>
ffffffffc0203d1e:	86be                	mv	a3,a5
ffffffffc0203d20:	679c                	ld	a5,8(a5)
ffffffffc0203d22:	fef51ae3          	bne	a0,a5,ffffffffc0203d16 <insert_vma_struct+0x12>
ffffffffc0203d26:	02a68463          	beq	a3,a0,ffffffffc0203d4e <insert_vma_struct+0x4a>
ffffffffc0203d2a:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203d2e:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203d32:	08e8f163          	bgeu	a7,a4,ffffffffc0203db4 <insert_vma_struct+0xb0>
ffffffffc0203d36:	04e66f63          	bltu	a2,a4,ffffffffc0203d94 <insert_vma_struct+0x90>
ffffffffc0203d3a:	00f50a63          	beq	a0,a5,ffffffffc0203d4e <insert_vma_struct+0x4a>
ffffffffc0203d3e:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203d42:	05076963          	bltu	a4,a6,ffffffffc0203d94 <insert_vma_struct+0x90>
ffffffffc0203d46:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203d4a:	02c77363          	bgeu	a4,a2,ffffffffc0203d70 <insert_vma_struct+0x6c>
ffffffffc0203d4e:	5118                	lw	a4,32(a0)
ffffffffc0203d50:	e188                	sd	a0,0(a1)
ffffffffc0203d52:	02058613          	addi	a2,a1,32
ffffffffc0203d56:	e390                	sd	a2,0(a5)
ffffffffc0203d58:	e690                	sd	a2,8(a3)
ffffffffc0203d5a:	60a2                	ld	ra,8(sp)
ffffffffc0203d5c:	f59c                	sd	a5,40(a1)
ffffffffc0203d5e:	f194                	sd	a3,32(a1)
ffffffffc0203d60:	0017079b          	addiw	a5,a4,1
ffffffffc0203d64:	d11c                	sw	a5,32(a0)
ffffffffc0203d66:	0141                	addi	sp,sp,16
ffffffffc0203d68:	8082                	ret
ffffffffc0203d6a:	fca690e3          	bne	a3,a0,ffffffffc0203d2a <insert_vma_struct+0x26>
ffffffffc0203d6e:	bfd1                	j	ffffffffc0203d42 <insert_vma_struct+0x3e>
ffffffffc0203d70:	ef3ff0ef          	jal	ra,ffffffffc0203c62 <check_vma_overlap.part.0>
ffffffffc0203d74:	00009697          	auipc	a3,0x9
ffffffffc0203d78:	04468693          	addi	a3,a3,68 # ffffffffc020cdb8 <default_pmm_manager+0x850>
ffffffffc0203d7c:	00008617          	auipc	a2,0x8
ffffffffc0203d80:	d0460613          	addi	a2,a2,-764 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203d84:	07a00593          	li	a1,122
ffffffffc0203d88:	00009517          	auipc	a0,0x9
ffffffffc0203d8c:	02050513          	addi	a0,a0,32 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0203d90:	f0efc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203d94:	00009697          	auipc	a3,0x9
ffffffffc0203d98:	06468693          	addi	a3,a3,100 # ffffffffc020cdf8 <default_pmm_manager+0x890>
ffffffffc0203d9c:	00008617          	auipc	a2,0x8
ffffffffc0203da0:	ce460613          	addi	a2,a2,-796 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203da4:	07300593          	li	a1,115
ffffffffc0203da8:	00009517          	auipc	a0,0x9
ffffffffc0203dac:	00050513          	mv	a0,a0
ffffffffc0203db0:	eeefc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0203db4:	00009697          	auipc	a3,0x9
ffffffffc0203db8:	02468693          	addi	a3,a3,36 # ffffffffc020cdd8 <default_pmm_manager+0x870>
ffffffffc0203dbc:	00008617          	auipc	a2,0x8
ffffffffc0203dc0:	cc460613          	addi	a2,a2,-828 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203dc4:	07200593          	li	a1,114
ffffffffc0203dc8:	00009517          	auipc	a0,0x9
ffffffffc0203dcc:	fe050513          	addi	a0,a0,-32 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0203dd0:	ecefc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203dd4 <mm_destroy>:
ffffffffc0203dd4:	591c                	lw	a5,48(a0)
ffffffffc0203dd6:	1141                	addi	sp,sp,-16
ffffffffc0203dd8:	e406                	sd	ra,8(sp)
ffffffffc0203dda:	e022                	sd	s0,0(sp)
ffffffffc0203ddc:	e78d                	bnez	a5,ffffffffc0203e06 <mm_destroy+0x32>
ffffffffc0203dde:	842a                	mv	s0,a0
ffffffffc0203de0:	6508                	ld	a0,8(a0)
ffffffffc0203de2:	00a40c63          	beq	s0,a0,ffffffffc0203dfa <mm_destroy+0x26>
ffffffffc0203de6:	6118                	ld	a4,0(a0)
ffffffffc0203de8:	651c                	ld	a5,8(a0)
ffffffffc0203dea:	1501                	addi	a0,a0,-32
ffffffffc0203dec:	e71c                	sd	a5,8(a4)
ffffffffc0203dee:	e398                	sd	a4,0(a5)
ffffffffc0203df0:	a4efe0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0203df4:	6408                	ld	a0,8(s0)
ffffffffc0203df6:	fea418e3          	bne	s0,a0,ffffffffc0203de6 <mm_destroy+0x12>
ffffffffc0203dfa:	8522                	mv	a0,s0
ffffffffc0203dfc:	6402                	ld	s0,0(sp)
ffffffffc0203dfe:	60a2                	ld	ra,8(sp)
ffffffffc0203e00:	0141                	addi	sp,sp,16
ffffffffc0203e02:	a3cfe06f          	j	ffffffffc020203e <kfree>
ffffffffc0203e06:	00009697          	auipc	a3,0x9
ffffffffc0203e0a:	01268693          	addi	a3,a3,18 # ffffffffc020ce18 <default_pmm_manager+0x8b0>
ffffffffc0203e0e:	00008617          	auipc	a2,0x8
ffffffffc0203e12:	c7260613          	addi	a2,a2,-910 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203e16:	09e00593          	li	a1,158
ffffffffc0203e1a:	00009517          	auipc	a0,0x9
ffffffffc0203e1e:	f8e50513          	addi	a0,a0,-114 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0203e22:	e7cfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203e26 <mm_map>:
ffffffffc0203e26:	7139                	addi	sp,sp,-64
ffffffffc0203e28:	f822                	sd	s0,48(sp)
ffffffffc0203e2a:	6405                	lui	s0,0x1
ffffffffc0203e2c:	147d                	addi	s0,s0,-1
ffffffffc0203e2e:	77fd                	lui	a5,0xfffff
ffffffffc0203e30:	9622                	add	a2,a2,s0
ffffffffc0203e32:	962e                	add	a2,a2,a1
ffffffffc0203e34:	f426                	sd	s1,40(sp)
ffffffffc0203e36:	fc06                	sd	ra,56(sp)
ffffffffc0203e38:	00f5f4b3          	and	s1,a1,a5
ffffffffc0203e3c:	f04a                	sd	s2,32(sp)
ffffffffc0203e3e:	ec4e                	sd	s3,24(sp)
ffffffffc0203e40:	e852                	sd	s4,16(sp)
ffffffffc0203e42:	e456                	sd	s5,8(sp)
ffffffffc0203e44:	002005b7          	lui	a1,0x200
ffffffffc0203e48:	00f67433          	and	s0,a2,a5
ffffffffc0203e4c:	06b4e363          	bltu	s1,a1,ffffffffc0203eb2 <mm_map+0x8c>
ffffffffc0203e50:	0684f163          	bgeu	s1,s0,ffffffffc0203eb2 <mm_map+0x8c>
ffffffffc0203e54:	4785                	li	a5,1
ffffffffc0203e56:	07fe                	slli	a5,a5,0x1f
ffffffffc0203e58:	0487ed63          	bltu	a5,s0,ffffffffc0203eb2 <mm_map+0x8c>
ffffffffc0203e5c:	89aa                	mv	s3,a0
ffffffffc0203e5e:	cd21                	beqz	a0,ffffffffc0203eb6 <mm_map+0x90>
ffffffffc0203e60:	85a6                	mv	a1,s1
ffffffffc0203e62:	8ab6                	mv	s5,a3
ffffffffc0203e64:	8a3a                	mv	s4,a4
ffffffffc0203e66:	e5fff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc0203e6a:	c501                	beqz	a0,ffffffffc0203e72 <mm_map+0x4c>
ffffffffc0203e6c:	651c                	ld	a5,8(a0)
ffffffffc0203e6e:	0487e263          	bltu	a5,s0,ffffffffc0203eb2 <mm_map+0x8c>
ffffffffc0203e72:	03000513          	li	a0,48
ffffffffc0203e76:	918fe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203e7a:	892a                	mv	s2,a0
ffffffffc0203e7c:	5571                	li	a0,-4
ffffffffc0203e7e:	02090163          	beqz	s2,ffffffffc0203ea0 <mm_map+0x7a>
ffffffffc0203e82:	854e                	mv	a0,s3
ffffffffc0203e84:	00993423          	sd	s1,8(s2)
ffffffffc0203e88:	00893823          	sd	s0,16(s2)
ffffffffc0203e8c:	01592c23          	sw	s5,24(s2)
ffffffffc0203e90:	85ca                	mv	a1,s2
ffffffffc0203e92:	e73ff0ef          	jal	ra,ffffffffc0203d04 <insert_vma_struct>
ffffffffc0203e96:	4501                	li	a0,0
ffffffffc0203e98:	000a0463          	beqz	s4,ffffffffc0203ea0 <mm_map+0x7a>
ffffffffc0203e9c:	012a3023          	sd	s2,0(s4)
ffffffffc0203ea0:	70e2                	ld	ra,56(sp)
ffffffffc0203ea2:	7442                	ld	s0,48(sp)
ffffffffc0203ea4:	74a2                	ld	s1,40(sp)
ffffffffc0203ea6:	7902                	ld	s2,32(sp)
ffffffffc0203ea8:	69e2                	ld	s3,24(sp)
ffffffffc0203eaa:	6a42                	ld	s4,16(sp)
ffffffffc0203eac:	6aa2                	ld	s5,8(sp)
ffffffffc0203eae:	6121                	addi	sp,sp,64
ffffffffc0203eb0:	8082                	ret
ffffffffc0203eb2:	5575                	li	a0,-3
ffffffffc0203eb4:	b7f5                	j	ffffffffc0203ea0 <mm_map+0x7a>
ffffffffc0203eb6:	00009697          	auipc	a3,0x9
ffffffffc0203eba:	f7a68693          	addi	a3,a3,-134 # ffffffffc020ce30 <default_pmm_manager+0x8c8>
ffffffffc0203ebe:	00008617          	auipc	a2,0x8
ffffffffc0203ec2:	bc260613          	addi	a2,a2,-1086 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203ec6:	0b300593          	li	a1,179
ffffffffc0203eca:	00009517          	auipc	a0,0x9
ffffffffc0203ece:	ede50513          	addi	a0,a0,-290 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0203ed2:	dccfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203ed6 <dup_mmap>:
ffffffffc0203ed6:	7139                	addi	sp,sp,-64
ffffffffc0203ed8:	fc06                	sd	ra,56(sp)
ffffffffc0203eda:	f822                	sd	s0,48(sp)
ffffffffc0203edc:	f426                	sd	s1,40(sp)
ffffffffc0203ede:	f04a                	sd	s2,32(sp)
ffffffffc0203ee0:	ec4e                	sd	s3,24(sp)
ffffffffc0203ee2:	e852                	sd	s4,16(sp)
ffffffffc0203ee4:	e456                	sd	s5,8(sp)
ffffffffc0203ee6:	c52d                	beqz	a0,ffffffffc0203f50 <dup_mmap+0x7a>
ffffffffc0203ee8:	892a                	mv	s2,a0
ffffffffc0203eea:	84ae                	mv	s1,a1
ffffffffc0203eec:	842e                	mv	s0,a1
ffffffffc0203eee:	e595                	bnez	a1,ffffffffc0203f1a <dup_mmap+0x44>
ffffffffc0203ef0:	a085                	j	ffffffffc0203f50 <dup_mmap+0x7a>
ffffffffc0203ef2:	854a                	mv	a0,s2
ffffffffc0203ef4:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc0203ef8:	0145b823          	sd	s4,16(a1)
ffffffffc0203efc:	0135ac23          	sw	s3,24(a1)
ffffffffc0203f00:	e05ff0ef          	jal	ra,ffffffffc0203d04 <insert_vma_struct>
ffffffffc0203f04:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc0203f08:	fe843603          	ld	a2,-24(s0)
ffffffffc0203f0c:	6c8c                	ld	a1,24(s1)
ffffffffc0203f0e:	01893503          	ld	a0,24(s2)
ffffffffc0203f12:	4701                	li	a4,0
ffffffffc0203f14:	9afff0ef          	jal	ra,ffffffffc02038c2 <copy_range>
ffffffffc0203f18:	e105                	bnez	a0,ffffffffc0203f38 <dup_mmap+0x62>
ffffffffc0203f1a:	6000                	ld	s0,0(s0)
ffffffffc0203f1c:	02848863          	beq	s1,s0,ffffffffc0203f4c <dup_mmap+0x76>
ffffffffc0203f20:	03000513          	li	a0,48
ffffffffc0203f24:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203f28:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203f2c:	ff842983          	lw	s3,-8(s0)
ffffffffc0203f30:	85efe0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203f34:	85aa                	mv	a1,a0
ffffffffc0203f36:	fd55                	bnez	a0,ffffffffc0203ef2 <dup_mmap+0x1c>
ffffffffc0203f38:	5571                	li	a0,-4
ffffffffc0203f3a:	70e2                	ld	ra,56(sp)
ffffffffc0203f3c:	7442                	ld	s0,48(sp)
ffffffffc0203f3e:	74a2                	ld	s1,40(sp)
ffffffffc0203f40:	7902                	ld	s2,32(sp)
ffffffffc0203f42:	69e2                	ld	s3,24(sp)
ffffffffc0203f44:	6a42                	ld	s4,16(sp)
ffffffffc0203f46:	6aa2                	ld	s5,8(sp)
ffffffffc0203f48:	6121                	addi	sp,sp,64
ffffffffc0203f4a:	8082                	ret
ffffffffc0203f4c:	4501                	li	a0,0
ffffffffc0203f4e:	b7f5                	j	ffffffffc0203f3a <dup_mmap+0x64>
ffffffffc0203f50:	00009697          	auipc	a3,0x9
ffffffffc0203f54:	ef068693          	addi	a3,a3,-272 # ffffffffc020ce40 <default_pmm_manager+0x8d8>
ffffffffc0203f58:	00008617          	auipc	a2,0x8
ffffffffc0203f5c:	b2860613          	addi	a2,a2,-1240 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203f60:	0cf00593          	li	a1,207
ffffffffc0203f64:	00009517          	auipc	a0,0x9
ffffffffc0203f68:	e4450513          	addi	a0,a0,-444 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0203f6c:	d32fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203f70 <exit_mmap>:
ffffffffc0203f70:	1101                	addi	sp,sp,-32
ffffffffc0203f72:	ec06                	sd	ra,24(sp)
ffffffffc0203f74:	e822                	sd	s0,16(sp)
ffffffffc0203f76:	e426                	sd	s1,8(sp)
ffffffffc0203f78:	e04a                	sd	s2,0(sp)
ffffffffc0203f7a:	c531                	beqz	a0,ffffffffc0203fc6 <exit_mmap+0x56>
ffffffffc0203f7c:	591c                	lw	a5,48(a0)
ffffffffc0203f7e:	84aa                	mv	s1,a0
ffffffffc0203f80:	e3b9                	bnez	a5,ffffffffc0203fc6 <exit_mmap+0x56>
ffffffffc0203f82:	6500                	ld	s0,8(a0)
ffffffffc0203f84:	01853903          	ld	s2,24(a0)
ffffffffc0203f88:	02850663          	beq	a0,s0,ffffffffc0203fb4 <exit_mmap+0x44>
ffffffffc0203f8c:	ff043603          	ld	a2,-16(s0)
ffffffffc0203f90:	fe843583          	ld	a1,-24(s0)
ffffffffc0203f94:	854a                	mv	a0,s2
ffffffffc0203f96:	dd0fe0ef          	jal	ra,ffffffffc0202566 <unmap_range>
ffffffffc0203f9a:	6400                	ld	s0,8(s0)
ffffffffc0203f9c:	fe8498e3          	bne	s1,s0,ffffffffc0203f8c <exit_mmap+0x1c>
ffffffffc0203fa0:	6400                	ld	s0,8(s0)
ffffffffc0203fa2:	00848c63          	beq	s1,s0,ffffffffc0203fba <exit_mmap+0x4a>
ffffffffc0203fa6:	ff043603          	ld	a2,-16(s0)
ffffffffc0203faa:	fe843583          	ld	a1,-24(s0)
ffffffffc0203fae:	854a                	mv	a0,s2
ffffffffc0203fb0:	efcfe0ef          	jal	ra,ffffffffc02026ac <exit_range>
ffffffffc0203fb4:	6400                	ld	s0,8(s0)
ffffffffc0203fb6:	fe8498e3          	bne	s1,s0,ffffffffc0203fa6 <exit_mmap+0x36>
ffffffffc0203fba:	60e2                	ld	ra,24(sp)
ffffffffc0203fbc:	6442                	ld	s0,16(sp)
ffffffffc0203fbe:	64a2                	ld	s1,8(sp)
ffffffffc0203fc0:	6902                	ld	s2,0(sp)
ffffffffc0203fc2:	6105                	addi	sp,sp,32
ffffffffc0203fc4:	8082                	ret
ffffffffc0203fc6:	00009697          	auipc	a3,0x9
ffffffffc0203fca:	e9a68693          	addi	a3,a3,-358 # ffffffffc020ce60 <default_pmm_manager+0x8f8>
ffffffffc0203fce:	00008617          	auipc	a2,0x8
ffffffffc0203fd2:	ab260613          	addi	a2,a2,-1358 # ffffffffc020ba80 <commands+0x210>
ffffffffc0203fd6:	0e800593          	li	a1,232
ffffffffc0203fda:	00009517          	auipc	a0,0x9
ffffffffc0203fde:	dce50513          	addi	a0,a0,-562 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0203fe2:	cbcfc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0203fe6 <vmm_init>:
ffffffffc0203fe6:	7139                	addi	sp,sp,-64
ffffffffc0203fe8:	05800513          	li	a0,88
ffffffffc0203fec:	fc06                	sd	ra,56(sp)
ffffffffc0203fee:	f822                	sd	s0,48(sp)
ffffffffc0203ff0:	f426                	sd	s1,40(sp)
ffffffffc0203ff2:	f04a                	sd	s2,32(sp)
ffffffffc0203ff4:	ec4e                	sd	s3,24(sp)
ffffffffc0203ff6:	e852                	sd	s4,16(sp)
ffffffffc0203ff8:	e456                	sd	s5,8(sp)
ffffffffc0203ffa:	f95fd0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0203ffe:	2e050963          	beqz	a0,ffffffffc02042f0 <vmm_init+0x30a>
ffffffffc0204002:	e508                	sd	a0,8(a0)
ffffffffc0204004:	e108                	sd	a0,0(a0)
ffffffffc0204006:	00053823          	sd	zero,16(a0)
ffffffffc020400a:	00053c23          	sd	zero,24(a0)
ffffffffc020400e:	02052023          	sw	zero,32(a0)
ffffffffc0204012:	02053423          	sd	zero,40(a0)
ffffffffc0204016:	02052823          	sw	zero,48(a0)
ffffffffc020401a:	84aa                	mv	s1,a0
ffffffffc020401c:	4585                	li	a1,1
ffffffffc020401e:	03850513          	addi	a0,a0,56
ffffffffc0204022:	5b6000ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc0204026:	03200413          	li	s0,50
ffffffffc020402a:	a811                	j	ffffffffc020403e <vmm_init+0x58>
ffffffffc020402c:	e500                	sd	s0,8(a0)
ffffffffc020402e:	e91c                	sd	a5,16(a0)
ffffffffc0204030:	00052c23          	sw	zero,24(a0)
ffffffffc0204034:	146d                	addi	s0,s0,-5
ffffffffc0204036:	8526                	mv	a0,s1
ffffffffc0204038:	ccdff0ef          	jal	ra,ffffffffc0203d04 <insert_vma_struct>
ffffffffc020403c:	c80d                	beqz	s0,ffffffffc020406e <vmm_init+0x88>
ffffffffc020403e:	03000513          	li	a0,48
ffffffffc0204042:	f4dfd0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0204046:	85aa                	mv	a1,a0
ffffffffc0204048:	00240793          	addi	a5,s0,2
ffffffffc020404c:	f165                	bnez	a0,ffffffffc020402c <vmm_init+0x46>
ffffffffc020404e:	00009697          	auipc	a3,0x9
ffffffffc0204052:	faa68693          	addi	a3,a3,-86 # ffffffffc020cff8 <default_pmm_manager+0xa90>
ffffffffc0204056:	00008617          	auipc	a2,0x8
ffffffffc020405a:	a2a60613          	addi	a2,a2,-1494 # ffffffffc020ba80 <commands+0x210>
ffffffffc020405e:	12c00593          	li	a1,300
ffffffffc0204062:	00009517          	auipc	a0,0x9
ffffffffc0204066:	d4650513          	addi	a0,a0,-698 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc020406a:	c34fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020406e:	03700413          	li	s0,55
ffffffffc0204072:	1f900913          	li	s2,505
ffffffffc0204076:	a819                	j	ffffffffc020408c <vmm_init+0xa6>
ffffffffc0204078:	e500                	sd	s0,8(a0)
ffffffffc020407a:	e91c                	sd	a5,16(a0)
ffffffffc020407c:	00052c23          	sw	zero,24(a0)
ffffffffc0204080:	0415                	addi	s0,s0,5
ffffffffc0204082:	8526                	mv	a0,s1
ffffffffc0204084:	c81ff0ef          	jal	ra,ffffffffc0203d04 <insert_vma_struct>
ffffffffc0204088:	03240a63          	beq	s0,s2,ffffffffc02040bc <vmm_init+0xd6>
ffffffffc020408c:	03000513          	li	a0,48
ffffffffc0204090:	efffd0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0204094:	85aa                	mv	a1,a0
ffffffffc0204096:	00240793          	addi	a5,s0,2
ffffffffc020409a:	fd79                	bnez	a0,ffffffffc0204078 <vmm_init+0x92>
ffffffffc020409c:	00009697          	auipc	a3,0x9
ffffffffc02040a0:	f5c68693          	addi	a3,a3,-164 # ffffffffc020cff8 <default_pmm_manager+0xa90>
ffffffffc02040a4:	00008617          	auipc	a2,0x8
ffffffffc02040a8:	9dc60613          	addi	a2,a2,-1572 # ffffffffc020ba80 <commands+0x210>
ffffffffc02040ac:	13300593          	li	a1,307
ffffffffc02040b0:	00009517          	auipc	a0,0x9
ffffffffc02040b4:	cf850513          	addi	a0,a0,-776 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc02040b8:	be6fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02040bc:	649c                	ld	a5,8(s1)
ffffffffc02040be:	471d                	li	a4,7
ffffffffc02040c0:	1fb00593          	li	a1,507
ffffffffc02040c4:	16f48663          	beq	s1,a5,ffffffffc0204230 <vmm_init+0x24a>
ffffffffc02040c8:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686d8>
ffffffffc02040cc:	ffe70693          	addi	a3,a4,-2 # 1ffffe <_binary_bin_sfs_img_size+0x18acfe>
ffffffffc02040d0:	10d61063          	bne	a2,a3,ffffffffc02041d0 <vmm_init+0x1ea>
ffffffffc02040d4:	ff07b683          	ld	a3,-16(a5)
ffffffffc02040d8:	0ed71c63          	bne	a4,a3,ffffffffc02041d0 <vmm_init+0x1ea>
ffffffffc02040dc:	0715                	addi	a4,a4,5
ffffffffc02040de:	679c                	ld	a5,8(a5)
ffffffffc02040e0:	feb712e3          	bne	a4,a1,ffffffffc02040c4 <vmm_init+0xde>
ffffffffc02040e4:	4a1d                	li	s4,7
ffffffffc02040e6:	4415                	li	s0,5
ffffffffc02040e8:	1f900a93          	li	s5,505
ffffffffc02040ec:	85a2                	mv	a1,s0
ffffffffc02040ee:	8526                	mv	a0,s1
ffffffffc02040f0:	bd5ff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc02040f4:	892a                	mv	s2,a0
ffffffffc02040f6:	16050d63          	beqz	a0,ffffffffc0204270 <vmm_init+0x28a>
ffffffffc02040fa:	00140593          	addi	a1,s0,1
ffffffffc02040fe:	8526                	mv	a0,s1
ffffffffc0204100:	bc5ff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc0204104:	89aa                	mv	s3,a0
ffffffffc0204106:	14050563          	beqz	a0,ffffffffc0204250 <vmm_init+0x26a>
ffffffffc020410a:	85d2                	mv	a1,s4
ffffffffc020410c:	8526                	mv	a0,s1
ffffffffc020410e:	bb7ff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc0204112:	16051f63          	bnez	a0,ffffffffc0204290 <vmm_init+0x2aa>
ffffffffc0204116:	00340593          	addi	a1,s0,3
ffffffffc020411a:	8526                	mv	a0,s1
ffffffffc020411c:	ba9ff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc0204120:	1a051863          	bnez	a0,ffffffffc02042d0 <vmm_init+0x2ea>
ffffffffc0204124:	00440593          	addi	a1,s0,4
ffffffffc0204128:	8526                	mv	a0,s1
ffffffffc020412a:	b9bff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc020412e:	18051163          	bnez	a0,ffffffffc02042b0 <vmm_init+0x2ca>
ffffffffc0204132:	00893783          	ld	a5,8(s2)
ffffffffc0204136:	0a879d63          	bne	a5,s0,ffffffffc02041f0 <vmm_init+0x20a>
ffffffffc020413a:	01093783          	ld	a5,16(s2)
ffffffffc020413e:	0b479963          	bne	a5,s4,ffffffffc02041f0 <vmm_init+0x20a>
ffffffffc0204142:	0089b783          	ld	a5,8(s3)
ffffffffc0204146:	0c879563          	bne	a5,s0,ffffffffc0204210 <vmm_init+0x22a>
ffffffffc020414a:	0109b783          	ld	a5,16(s3)
ffffffffc020414e:	0d479163          	bne	a5,s4,ffffffffc0204210 <vmm_init+0x22a>
ffffffffc0204152:	0415                	addi	s0,s0,5
ffffffffc0204154:	0a15                	addi	s4,s4,5
ffffffffc0204156:	f9541be3          	bne	s0,s5,ffffffffc02040ec <vmm_init+0x106>
ffffffffc020415a:	4411                	li	s0,4
ffffffffc020415c:	597d                	li	s2,-1
ffffffffc020415e:	85a2                	mv	a1,s0
ffffffffc0204160:	8526                	mv	a0,s1
ffffffffc0204162:	b63ff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc0204166:	0004059b          	sext.w	a1,s0
ffffffffc020416a:	c90d                	beqz	a0,ffffffffc020419c <vmm_init+0x1b6>
ffffffffc020416c:	6914                	ld	a3,16(a0)
ffffffffc020416e:	6510                	ld	a2,8(a0)
ffffffffc0204170:	00009517          	auipc	a0,0x9
ffffffffc0204174:	e1050513          	addi	a0,a0,-496 # ffffffffc020cf80 <default_pmm_manager+0xa18>
ffffffffc0204178:	82efc0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020417c:	00009697          	auipc	a3,0x9
ffffffffc0204180:	e2c68693          	addi	a3,a3,-468 # ffffffffc020cfa8 <default_pmm_manager+0xa40>
ffffffffc0204184:	00008617          	auipc	a2,0x8
ffffffffc0204188:	8fc60613          	addi	a2,a2,-1796 # ffffffffc020ba80 <commands+0x210>
ffffffffc020418c:	15900593          	li	a1,345
ffffffffc0204190:	00009517          	auipc	a0,0x9
ffffffffc0204194:	c1850513          	addi	a0,a0,-1000 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc0204198:	b06fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020419c:	147d                	addi	s0,s0,-1
ffffffffc020419e:	fd2410e3          	bne	s0,s2,ffffffffc020415e <vmm_init+0x178>
ffffffffc02041a2:	8526                	mv	a0,s1
ffffffffc02041a4:	c31ff0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc02041a8:	00009517          	auipc	a0,0x9
ffffffffc02041ac:	e1850513          	addi	a0,a0,-488 # ffffffffc020cfc0 <default_pmm_manager+0xa58>
ffffffffc02041b0:	ff7fb0ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02041b4:	7442                	ld	s0,48(sp)
ffffffffc02041b6:	70e2                	ld	ra,56(sp)
ffffffffc02041b8:	74a2                	ld	s1,40(sp)
ffffffffc02041ba:	7902                	ld	s2,32(sp)
ffffffffc02041bc:	69e2                	ld	s3,24(sp)
ffffffffc02041be:	6a42                	ld	s4,16(sp)
ffffffffc02041c0:	6aa2                	ld	s5,8(sp)
ffffffffc02041c2:	00009517          	auipc	a0,0x9
ffffffffc02041c6:	e1e50513          	addi	a0,a0,-482 # ffffffffc020cfe0 <default_pmm_manager+0xa78>
ffffffffc02041ca:	6121                	addi	sp,sp,64
ffffffffc02041cc:	fdbfb06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc02041d0:	00009697          	auipc	a3,0x9
ffffffffc02041d4:	cc868693          	addi	a3,a3,-824 # ffffffffc020ce98 <default_pmm_manager+0x930>
ffffffffc02041d8:	00008617          	auipc	a2,0x8
ffffffffc02041dc:	8a860613          	addi	a2,a2,-1880 # ffffffffc020ba80 <commands+0x210>
ffffffffc02041e0:	13d00593          	li	a1,317
ffffffffc02041e4:	00009517          	auipc	a0,0x9
ffffffffc02041e8:	bc450513          	addi	a0,a0,-1084 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc02041ec:	ab2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02041f0:	00009697          	auipc	a3,0x9
ffffffffc02041f4:	d3068693          	addi	a3,a3,-720 # ffffffffc020cf20 <default_pmm_manager+0x9b8>
ffffffffc02041f8:	00008617          	auipc	a2,0x8
ffffffffc02041fc:	88860613          	addi	a2,a2,-1912 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204200:	14e00593          	li	a1,334
ffffffffc0204204:	00009517          	auipc	a0,0x9
ffffffffc0204208:	ba450513          	addi	a0,a0,-1116 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc020420c:	a92fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204210:	00009697          	auipc	a3,0x9
ffffffffc0204214:	d4068693          	addi	a3,a3,-704 # ffffffffc020cf50 <default_pmm_manager+0x9e8>
ffffffffc0204218:	00008617          	auipc	a2,0x8
ffffffffc020421c:	86860613          	addi	a2,a2,-1944 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204220:	14f00593          	li	a1,335
ffffffffc0204224:	00009517          	auipc	a0,0x9
ffffffffc0204228:	b8450513          	addi	a0,a0,-1148 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc020422c:	a72fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204230:	00009697          	auipc	a3,0x9
ffffffffc0204234:	c5068693          	addi	a3,a3,-944 # ffffffffc020ce80 <default_pmm_manager+0x918>
ffffffffc0204238:	00008617          	auipc	a2,0x8
ffffffffc020423c:	84860613          	addi	a2,a2,-1976 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204240:	13b00593          	li	a1,315
ffffffffc0204244:	00009517          	auipc	a0,0x9
ffffffffc0204248:	b6450513          	addi	a0,a0,-1180 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc020424c:	a52fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204250:	00009697          	auipc	a3,0x9
ffffffffc0204254:	c9068693          	addi	a3,a3,-880 # ffffffffc020cee0 <default_pmm_manager+0x978>
ffffffffc0204258:	00008617          	auipc	a2,0x8
ffffffffc020425c:	82860613          	addi	a2,a2,-2008 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204260:	14600593          	li	a1,326
ffffffffc0204264:	00009517          	auipc	a0,0x9
ffffffffc0204268:	b4450513          	addi	a0,a0,-1212 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc020426c:	a32fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204270:	00009697          	auipc	a3,0x9
ffffffffc0204274:	c6068693          	addi	a3,a3,-928 # ffffffffc020ced0 <default_pmm_manager+0x968>
ffffffffc0204278:	00008617          	auipc	a2,0x8
ffffffffc020427c:	80860613          	addi	a2,a2,-2040 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204280:	14400593          	li	a1,324
ffffffffc0204284:	00009517          	auipc	a0,0x9
ffffffffc0204288:	b2450513          	addi	a0,a0,-1244 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc020428c:	a12fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204290:	00009697          	auipc	a3,0x9
ffffffffc0204294:	c6068693          	addi	a3,a3,-928 # ffffffffc020cef0 <default_pmm_manager+0x988>
ffffffffc0204298:	00007617          	auipc	a2,0x7
ffffffffc020429c:	7e860613          	addi	a2,a2,2024 # ffffffffc020ba80 <commands+0x210>
ffffffffc02042a0:	14800593          	li	a1,328
ffffffffc02042a4:	00009517          	auipc	a0,0x9
ffffffffc02042a8:	b0450513          	addi	a0,a0,-1276 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc02042ac:	9f2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02042b0:	00009697          	auipc	a3,0x9
ffffffffc02042b4:	c6068693          	addi	a3,a3,-928 # ffffffffc020cf10 <default_pmm_manager+0x9a8>
ffffffffc02042b8:	00007617          	auipc	a2,0x7
ffffffffc02042bc:	7c860613          	addi	a2,a2,1992 # ffffffffc020ba80 <commands+0x210>
ffffffffc02042c0:	14c00593          	li	a1,332
ffffffffc02042c4:	00009517          	auipc	a0,0x9
ffffffffc02042c8:	ae450513          	addi	a0,a0,-1308 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc02042cc:	9d2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02042d0:	00009697          	auipc	a3,0x9
ffffffffc02042d4:	c3068693          	addi	a3,a3,-976 # ffffffffc020cf00 <default_pmm_manager+0x998>
ffffffffc02042d8:	00007617          	auipc	a2,0x7
ffffffffc02042dc:	7a860613          	addi	a2,a2,1960 # ffffffffc020ba80 <commands+0x210>
ffffffffc02042e0:	14a00593          	li	a1,330
ffffffffc02042e4:	00009517          	auipc	a0,0x9
ffffffffc02042e8:	ac450513          	addi	a0,a0,-1340 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc02042ec:	9b2fc0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02042f0:	00009697          	auipc	a3,0x9
ffffffffc02042f4:	b4068693          	addi	a3,a3,-1216 # ffffffffc020ce30 <default_pmm_manager+0x8c8>
ffffffffc02042f8:	00007617          	auipc	a2,0x7
ffffffffc02042fc:	78860613          	addi	a2,a2,1928 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204300:	12400593          	li	a1,292
ffffffffc0204304:	00009517          	auipc	a0,0x9
ffffffffc0204308:	aa450513          	addi	a0,a0,-1372 # ffffffffc020cda8 <default_pmm_manager+0x840>
ffffffffc020430c:	992fc0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204310 <user_mem_check>:
ffffffffc0204310:	7179                	addi	sp,sp,-48
ffffffffc0204312:	f022                	sd	s0,32(sp)
ffffffffc0204314:	f406                	sd	ra,40(sp)
ffffffffc0204316:	ec26                	sd	s1,24(sp)
ffffffffc0204318:	e84a                	sd	s2,16(sp)
ffffffffc020431a:	e44e                	sd	s3,8(sp)
ffffffffc020431c:	e052                	sd	s4,0(sp)
ffffffffc020431e:	842e                	mv	s0,a1
ffffffffc0204320:	c135                	beqz	a0,ffffffffc0204384 <user_mem_check+0x74>
ffffffffc0204322:	002007b7          	lui	a5,0x200
ffffffffc0204326:	04f5e663          	bltu	a1,a5,ffffffffc0204372 <user_mem_check+0x62>
ffffffffc020432a:	00c584b3          	add	s1,a1,a2
ffffffffc020432e:	0495f263          	bgeu	a1,s1,ffffffffc0204372 <user_mem_check+0x62>
ffffffffc0204332:	4785                	li	a5,1
ffffffffc0204334:	07fe                	slli	a5,a5,0x1f
ffffffffc0204336:	0297ee63          	bltu	a5,s1,ffffffffc0204372 <user_mem_check+0x62>
ffffffffc020433a:	892a                	mv	s2,a0
ffffffffc020433c:	89b6                	mv	s3,a3
ffffffffc020433e:	6a05                	lui	s4,0x1
ffffffffc0204340:	a821                	j	ffffffffc0204358 <user_mem_check+0x48>
ffffffffc0204342:	0027f693          	andi	a3,a5,2
ffffffffc0204346:	9752                	add	a4,a4,s4
ffffffffc0204348:	8ba1                	andi	a5,a5,8
ffffffffc020434a:	c685                	beqz	a3,ffffffffc0204372 <user_mem_check+0x62>
ffffffffc020434c:	c399                	beqz	a5,ffffffffc0204352 <user_mem_check+0x42>
ffffffffc020434e:	02e46263          	bltu	s0,a4,ffffffffc0204372 <user_mem_check+0x62>
ffffffffc0204352:	6900                	ld	s0,16(a0)
ffffffffc0204354:	04947663          	bgeu	s0,s1,ffffffffc02043a0 <user_mem_check+0x90>
ffffffffc0204358:	85a2                	mv	a1,s0
ffffffffc020435a:	854a                	mv	a0,s2
ffffffffc020435c:	969ff0ef          	jal	ra,ffffffffc0203cc4 <find_vma>
ffffffffc0204360:	c909                	beqz	a0,ffffffffc0204372 <user_mem_check+0x62>
ffffffffc0204362:	6518                	ld	a4,8(a0)
ffffffffc0204364:	00e46763          	bltu	s0,a4,ffffffffc0204372 <user_mem_check+0x62>
ffffffffc0204368:	4d1c                	lw	a5,24(a0)
ffffffffc020436a:	fc099ce3          	bnez	s3,ffffffffc0204342 <user_mem_check+0x32>
ffffffffc020436e:	8b85                	andi	a5,a5,1
ffffffffc0204370:	f3ed                	bnez	a5,ffffffffc0204352 <user_mem_check+0x42>
ffffffffc0204372:	4501                	li	a0,0
ffffffffc0204374:	70a2                	ld	ra,40(sp)
ffffffffc0204376:	7402                	ld	s0,32(sp)
ffffffffc0204378:	64e2                	ld	s1,24(sp)
ffffffffc020437a:	6942                	ld	s2,16(sp)
ffffffffc020437c:	69a2                	ld	s3,8(sp)
ffffffffc020437e:	6a02                	ld	s4,0(sp)
ffffffffc0204380:	6145                	addi	sp,sp,48
ffffffffc0204382:	8082                	ret
ffffffffc0204384:	c02007b7          	lui	a5,0xc0200
ffffffffc0204388:	4501                	li	a0,0
ffffffffc020438a:	fef5e5e3          	bltu	a1,a5,ffffffffc0204374 <user_mem_check+0x64>
ffffffffc020438e:	962e                	add	a2,a2,a1
ffffffffc0204390:	fec5f2e3          	bgeu	a1,a2,ffffffffc0204374 <user_mem_check+0x64>
ffffffffc0204394:	c8000537          	lui	a0,0xc8000
ffffffffc0204398:	0505                	addi	a0,a0,1
ffffffffc020439a:	00a63533          	sltu	a0,a2,a0
ffffffffc020439e:	bfd9                	j	ffffffffc0204374 <user_mem_check+0x64>
ffffffffc02043a0:	4505                	li	a0,1
ffffffffc02043a2:	bfc9                	j	ffffffffc0204374 <user_mem_check+0x64>

ffffffffc02043a4 <copy_from_user>:
ffffffffc02043a4:	1101                	addi	sp,sp,-32
ffffffffc02043a6:	e822                	sd	s0,16(sp)
ffffffffc02043a8:	e426                	sd	s1,8(sp)
ffffffffc02043aa:	8432                	mv	s0,a2
ffffffffc02043ac:	84b6                	mv	s1,a3
ffffffffc02043ae:	e04a                	sd	s2,0(sp)
ffffffffc02043b0:	86ba                	mv	a3,a4
ffffffffc02043b2:	892e                	mv	s2,a1
ffffffffc02043b4:	8626                	mv	a2,s1
ffffffffc02043b6:	85a2                	mv	a1,s0
ffffffffc02043b8:	ec06                	sd	ra,24(sp)
ffffffffc02043ba:	f57ff0ef          	jal	ra,ffffffffc0204310 <user_mem_check>
ffffffffc02043be:	c519                	beqz	a0,ffffffffc02043cc <copy_from_user+0x28>
ffffffffc02043c0:	8626                	mv	a2,s1
ffffffffc02043c2:	85a2                	mv	a1,s0
ffffffffc02043c4:	854a                	mv	a0,s2
ffffffffc02043c6:	226070ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc02043ca:	4505                	li	a0,1
ffffffffc02043cc:	60e2                	ld	ra,24(sp)
ffffffffc02043ce:	6442                	ld	s0,16(sp)
ffffffffc02043d0:	64a2                	ld	s1,8(sp)
ffffffffc02043d2:	6902                	ld	s2,0(sp)
ffffffffc02043d4:	6105                	addi	sp,sp,32
ffffffffc02043d6:	8082                	ret

ffffffffc02043d8 <copy_to_user>:
ffffffffc02043d8:	1101                	addi	sp,sp,-32
ffffffffc02043da:	e822                	sd	s0,16(sp)
ffffffffc02043dc:	8436                	mv	s0,a3
ffffffffc02043de:	e04a                	sd	s2,0(sp)
ffffffffc02043e0:	4685                	li	a3,1
ffffffffc02043e2:	8932                	mv	s2,a2
ffffffffc02043e4:	8622                	mv	a2,s0
ffffffffc02043e6:	e426                	sd	s1,8(sp)
ffffffffc02043e8:	ec06                	sd	ra,24(sp)
ffffffffc02043ea:	84ae                	mv	s1,a1
ffffffffc02043ec:	f25ff0ef          	jal	ra,ffffffffc0204310 <user_mem_check>
ffffffffc02043f0:	c519                	beqz	a0,ffffffffc02043fe <copy_to_user+0x26>
ffffffffc02043f2:	8622                	mv	a2,s0
ffffffffc02043f4:	85ca                	mv	a1,s2
ffffffffc02043f6:	8526                	mv	a0,s1
ffffffffc02043f8:	1f4070ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc02043fc:	4505                	li	a0,1
ffffffffc02043fe:	60e2                	ld	ra,24(sp)
ffffffffc0204400:	6442                	ld	s0,16(sp)
ffffffffc0204402:	64a2                	ld	s1,8(sp)
ffffffffc0204404:	6902                	ld	s2,0(sp)
ffffffffc0204406:	6105                	addi	sp,sp,32
ffffffffc0204408:	8082                	ret

ffffffffc020440a <copy_string>:
ffffffffc020440a:	7139                	addi	sp,sp,-64
ffffffffc020440c:	ec4e                	sd	s3,24(sp)
ffffffffc020440e:	6985                	lui	s3,0x1
ffffffffc0204410:	99b2                	add	s3,s3,a2
ffffffffc0204412:	77fd                	lui	a5,0xfffff
ffffffffc0204414:	00f9f9b3          	and	s3,s3,a5
ffffffffc0204418:	f426                	sd	s1,40(sp)
ffffffffc020441a:	f04a                	sd	s2,32(sp)
ffffffffc020441c:	e852                	sd	s4,16(sp)
ffffffffc020441e:	e456                	sd	s5,8(sp)
ffffffffc0204420:	fc06                	sd	ra,56(sp)
ffffffffc0204422:	f822                	sd	s0,48(sp)
ffffffffc0204424:	84b2                	mv	s1,a2
ffffffffc0204426:	8aaa                	mv	s5,a0
ffffffffc0204428:	8a2e                	mv	s4,a1
ffffffffc020442a:	8936                	mv	s2,a3
ffffffffc020442c:	40c989b3          	sub	s3,s3,a2
ffffffffc0204430:	a015                	j	ffffffffc0204454 <copy_string+0x4a>
ffffffffc0204432:	0e0070ef          	jal	ra,ffffffffc020b512 <strnlen>
ffffffffc0204436:	87aa                	mv	a5,a0
ffffffffc0204438:	85a6                	mv	a1,s1
ffffffffc020443a:	8552                	mv	a0,s4
ffffffffc020443c:	8622                	mv	a2,s0
ffffffffc020443e:	0487e363          	bltu	a5,s0,ffffffffc0204484 <copy_string+0x7a>
ffffffffc0204442:	0329f763          	bgeu	s3,s2,ffffffffc0204470 <copy_string+0x66>
ffffffffc0204446:	1a6070ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020444a:	9a22                	add	s4,s4,s0
ffffffffc020444c:	94a2                	add	s1,s1,s0
ffffffffc020444e:	40890933          	sub	s2,s2,s0
ffffffffc0204452:	6985                	lui	s3,0x1
ffffffffc0204454:	4681                	li	a3,0
ffffffffc0204456:	85a6                	mv	a1,s1
ffffffffc0204458:	8556                	mv	a0,s5
ffffffffc020445a:	844a                	mv	s0,s2
ffffffffc020445c:	0129f363          	bgeu	s3,s2,ffffffffc0204462 <copy_string+0x58>
ffffffffc0204460:	844e                	mv	s0,s3
ffffffffc0204462:	8622                	mv	a2,s0
ffffffffc0204464:	eadff0ef          	jal	ra,ffffffffc0204310 <user_mem_check>
ffffffffc0204468:	87aa                	mv	a5,a0
ffffffffc020446a:	85a2                	mv	a1,s0
ffffffffc020446c:	8526                	mv	a0,s1
ffffffffc020446e:	f3f1                	bnez	a5,ffffffffc0204432 <copy_string+0x28>
ffffffffc0204470:	4501                	li	a0,0
ffffffffc0204472:	70e2                	ld	ra,56(sp)
ffffffffc0204474:	7442                	ld	s0,48(sp)
ffffffffc0204476:	74a2                	ld	s1,40(sp)
ffffffffc0204478:	7902                	ld	s2,32(sp)
ffffffffc020447a:	69e2                	ld	s3,24(sp)
ffffffffc020447c:	6a42                	ld	s4,16(sp)
ffffffffc020447e:	6aa2                	ld	s5,8(sp)
ffffffffc0204480:	6121                	addi	sp,sp,64
ffffffffc0204482:	8082                	ret
ffffffffc0204484:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc0204488:	164070ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020448c:	4505                	li	a0,1
ffffffffc020448e:	b7d5                	j	ffffffffc0204472 <copy_string+0x68>

ffffffffc0204490 <__down.constprop.0>:
ffffffffc0204490:	715d                	addi	sp,sp,-80
ffffffffc0204492:	e0a2                	sd	s0,64(sp)
ffffffffc0204494:	e486                	sd	ra,72(sp)
ffffffffc0204496:	fc26                	sd	s1,56(sp)
ffffffffc0204498:	842a                	mv	s0,a0
ffffffffc020449a:	100027f3          	csrr	a5,sstatus
ffffffffc020449e:	8b89                	andi	a5,a5,2
ffffffffc02044a0:	ebb1                	bnez	a5,ffffffffc02044f4 <__down.constprop.0+0x64>
ffffffffc02044a2:	411c                	lw	a5,0(a0)
ffffffffc02044a4:	00f05a63          	blez	a5,ffffffffc02044b8 <__down.constprop.0+0x28>
ffffffffc02044a8:	37fd                	addiw	a5,a5,-1
ffffffffc02044aa:	c11c                	sw	a5,0(a0)
ffffffffc02044ac:	4501                	li	a0,0
ffffffffc02044ae:	60a6                	ld	ra,72(sp)
ffffffffc02044b0:	6406                	ld	s0,64(sp)
ffffffffc02044b2:	74e2                	ld	s1,56(sp)
ffffffffc02044b4:	6161                	addi	sp,sp,80
ffffffffc02044b6:	8082                	ret
ffffffffc02044b8:	00850413          	addi	s0,a0,8 # ffffffffc8000008 <end+0x7d696f8>
ffffffffc02044bc:	0024                	addi	s1,sp,8
ffffffffc02044be:	10000613          	li	a2,256
ffffffffc02044c2:	85a6                	mv	a1,s1
ffffffffc02044c4:	8522                	mv	a0,s0
ffffffffc02044c6:	2d8000ef          	jal	ra,ffffffffc020479e <wait_current_set>
ffffffffc02044ca:	753020ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc02044ce:	100027f3          	csrr	a5,sstatus
ffffffffc02044d2:	8b89                	andi	a5,a5,2
ffffffffc02044d4:	efb9                	bnez	a5,ffffffffc0204532 <__down.constprop.0+0xa2>
ffffffffc02044d6:	8526                	mv	a0,s1
ffffffffc02044d8:	19c000ef          	jal	ra,ffffffffc0204674 <wait_in_queue>
ffffffffc02044dc:	e531                	bnez	a0,ffffffffc0204528 <__down.constprop.0+0x98>
ffffffffc02044de:	4542                	lw	a0,16(sp)
ffffffffc02044e0:	10000793          	li	a5,256
ffffffffc02044e4:	fcf515e3          	bne	a0,a5,ffffffffc02044ae <__down.constprop.0+0x1e>
ffffffffc02044e8:	60a6                	ld	ra,72(sp)
ffffffffc02044ea:	6406                	ld	s0,64(sp)
ffffffffc02044ec:	74e2                	ld	s1,56(sp)
ffffffffc02044ee:	4501                	li	a0,0
ffffffffc02044f0:	6161                	addi	sp,sp,80
ffffffffc02044f2:	8082                	ret
ffffffffc02044f4:	f7efc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02044f8:	401c                	lw	a5,0(s0)
ffffffffc02044fa:	00f05c63          	blez	a5,ffffffffc0204512 <__down.constprop.0+0x82>
ffffffffc02044fe:	37fd                	addiw	a5,a5,-1
ffffffffc0204500:	c01c                	sw	a5,0(s0)
ffffffffc0204502:	f6afc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0204506:	60a6                	ld	ra,72(sp)
ffffffffc0204508:	6406                	ld	s0,64(sp)
ffffffffc020450a:	74e2                	ld	s1,56(sp)
ffffffffc020450c:	4501                	li	a0,0
ffffffffc020450e:	6161                	addi	sp,sp,80
ffffffffc0204510:	8082                	ret
ffffffffc0204512:	0421                	addi	s0,s0,8
ffffffffc0204514:	0024                	addi	s1,sp,8
ffffffffc0204516:	10000613          	li	a2,256
ffffffffc020451a:	85a6                	mv	a1,s1
ffffffffc020451c:	8522                	mv	a0,s0
ffffffffc020451e:	280000ef          	jal	ra,ffffffffc020479e <wait_current_set>
ffffffffc0204522:	f4afc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0204526:	b755                	j	ffffffffc02044ca <__down.constprop.0+0x3a>
ffffffffc0204528:	85a6                	mv	a1,s1
ffffffffc020452a:	8522                	mv	a0,s0
ffffffffc020452c:	0ee000ef          	jal	ra,ffffffffc020461a <wait_queue_del>
ffffffffc0204530:	b77d                	j	ffffffffc02044de <__down.constprop.0+0x4e>
ffffffffc0204532:	f40fc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0204536:	8526                	mv	a0,s1
ffffffffc0204538:	13c000ef          	jal	ra,ffffffffc0204674 <wait_in_queue>
ffffffffc020453c:	e501                	bnez	a0,ffffffffc0204544 <__down.constprop.0+0xb4>
ffffffffc020453e:	f2efc0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0204542:	bf71                	j	ffffffffc02044de <__down.constprop.0+0x4e>
ffffffffc0204544:	85a6                	mv	a1,s1
ffffffffc0204546:	8522                	mv	a0,s0
ffffffffc0204548:	0d2000ef          	jal	ra,ffffffffc020461a <wait_queue_del>
ffffffffc020454c:	bfcd                	j	ffffffffc020453e <__down.constprop.0+0xae>

ffffffffc020454e <__up.constprop.0>:
ffffffffc020454e:	1101                	addi	sp,sp,-32
ffffffffc0204550:	e822                	sd	s0,16(sp)
ffffffffc0204552:	ec06                	sd	ra,24(sp)
ffffffffc0204554:	e426                	sd	s1,8(sp)
ffffffffc0204556:	e04a                	sd	s2,0(sp)
ffffffffc0204558:	842a                	mv	s0,a0
ffffffffc020455a:	100027f3          	csrr	a5,sstatus
ffffffffc020455e:	8b89                	andi	a5,a5,2
ffffffffc0204560:	4901                	li	s2,0
ffffffffc0204562:	eba1                	bnez	a5,ffffffffc02045b2 <__up.constprop.0+0x64>
ffffffffc0204564:	00840493          	addi	s1,s0,8
ffffffffc0204568:	8526                	mv	a0,s1
ffffffffc020456a:	0ee000ef          	jal	ra,ffffffffc0204658 <wait_queue_first>
ffffffffc020456e:	85aa                	mv	a1,a0
ffffffffc0204570:	cd0d                	beqz	a0,ffffffffc02045aa <__up.constprop.0+0x5c>
ffffffffc0204572:	6118                	ld	a4,0(a0)
ffffffffc0204574:	10000793          	li	a5,256
ffffffffc0204578:	0ec72703          	lw	a4,236(a4)
ffffffffc020457c:	02f71f63          	bne	a4,a5,ffffffffc02045ba <__up.constprop.0+0x6c>
ffffffffc0204580:	4685                	li	a3,1
ffffffffc0204582:	10000613          	li	a2,256
ffffffffc0204586:	8526                	mv	a0,s1
ffffffffc0204588:	0fa000ef          	jal	ra,ffffffffc0204682 <wakeup_wait>
ffffffffc020458c:	00091863          	bnez	s2,ffffffffc020459c <__up.constprop.0+0x4e>
ffffffffc0204590:	60e2                	ld	ra,24(sp)
ffffffffc0204592:	6442                	ld	s0,16(sp)
ffffffffc0204594:	64a2                	ld	s1,8(sp)
ffffffffc0204596:	6902                	ld	s2,0(sp)
ffffffffc0204598:	6105                	addi	sp,sp,32
ffffffffc020459a:	8082                	ret
ffffffffc020459c:	6442                	ld	s0,16(sp)
ffffffffc020459e:	60e2                	ld	ra,24(sp)
ffffffffc02045a0:	64a2                	ld	s1,8(sp)
ffffffffc02045a2:	6902                	ld	s2,0(sp)
ffffffffc02045a4:	6105                	addi	sp,sp,32
ffffffffc02045a6:	ec6fc06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02045aa:	401c                	lw	a5,0(s0)
ffffffffc02045ac:	2785                	addiw	a5,a5,1
ffffffffc02045ae:	c01c                	sw	a5,0(s0)
ffffffffc02045b0:	bff1                	j	ffffffffc020458c <__up.constprop.0+0x3e>
ffffffffc02045b2:	ec0fc0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02045b6:	4905                	li	s2,1
ffffffffc02045b8:	b775                	j	ffffffffc0204564 <__up.constprop.0+0x16>
ffffffffc02045ba:	00009697          	auipc	a3,0x9
ffffffffc02045be:	a4e68693          	addi	a3,a3,-1458 # ffffffffc020d008 <default_pmm_manager+0xaa0>
ffffffffc02045c2:	00007617          	auipc	a2,0x7
ffffffffc02045c6:	4be60613          	addi	a2,a2,1214 # ffffffffc020ba80 <commands+0x210>
ffffffffc02045ca:	45e5                	li	a1,25
ffffffffc02045cc:	00009517          	auipc	a0,0x9
ffffffffc02045d0:	a6450513          	addi	a0,a0,-1436 # ffffffffc020d030 <default_pmm_manager+0xac8>
ffffffffc02045d4:	ecbfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02045d8 <sem_init>:
ffffffffc02045d8:	c10c                	sw	a1,0(a0)
ffffffffc02045da:	0521                	addi	a0,a0,8
ffffffffc02045dc:	a825                	j	ffffffffc0204614 <wait_queue_init>

ffffffffc02045de <up>:
ffffffffc02045de:	f71ff06f          	j	ffffffffc020454e <__up.constprop.0>

ffffffffc02045e2 <down>:
ffffffffc02045e2:	1141                	addi	sp,sp,-16
ffffffffc02045e4:	e406                	sd	ra,8(sp)
ffffffffc02045e6:	eabff0ef          	jal	ra,ffffffffc0204490 <__down.constprop.0>
ffffffffc02045ea:	2501                	sext.w	a0,a0
ffffffffc02045ec:	e501                	bnez	a0,ffffffffc02045f4 <down+0x12>
ffffffffc02045ee:	60a2                	ld	ra,8(sp)
ffffffffc02045f0:	0141                	addi	sp,sp,16
ffffffffc02045f2:	8082                	ret
ffffffffc02045f4:	00009697          	auipc	a3,0x9
ffffffffc02045f8:	a4c68693          	addi	a3,a3,-1460 # ffffffffc020d040 <default_pmm_manager+0xad8>
ffffffffc02045fc:	00007617          	auipc	a2,0x7
ffffffffc0204600:	48460613          	addi	a2,a2,1156 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204604:	04000593          	li	a1,64
ffffffffc0204608:	00009517          	auipc	a0,0x9
ffffffffc020460c:	a2850513          	addi	a0,a0,-1496 # ffffffffc020d030 <default_pmm_manager+0xac8>
ffffffffc0204610:	e8ffb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204614 <wait_queue_init>:
ffffffffc0204614:	e508                	sd	a0,8(a0)
ffffffffc0204616:	e108                	sd	a0,0(a0)
ffffffffc0204618:	8082                	ret

ffffffffc020461a <wait_queue_del>:
ffffffffc020461a:	7198                	ld	a4,32(a1)
ffffffffc020461c:	01858793          	addi	a5,a1,24
ffffffffc0204620:	00e78b63          	beq	a5,a4,ffffffffc0204636 <wait_queue_del+0x1c>
ffffffffc0204624:	6994                	ld	a3,16(a1)
ffffffffc0204626:	00a69863          	bne	a3,a0,ffffffffc0204636 <wait_queue_del+0x1c>
ffffffffc020462a:	6d94                	ld	a3,24(a1)
ffffffffc020462c:	e698                	sd	a4,8(a3)
ffffffffc020462e:	e314                	sd	a3,0(a4)
ffffffffc0204630:	f19c                	sd	a5,32(a1)
ffffffffc0204632:	ed9c                	sd	a5,24(a1)
ffffffffc0204634:	8082                	ret
ffffffffc0204636:	1141                	addi	sp,sp,-16
ffffffffc0204638:	00009697          	auipc	a3,0x9
ffffffffc020463c:	a6868693          	addi	a3,a3,-1432 # ffffffffc020d0a0 <default_pmm_manager+0xb38>
ffffffffc0204640:	00007617          	auipc	a2,0x7
ffffffffc0204644:	44060613          	addi	a2,a2,1088 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204648:	45f1                	li	a1,28
ffffffffc020464a:	00009517          	auipc	a0,0x9
ffffffffc020464e:	a3e50513          	addi	a0,a0,-1474 # ffffffffc020d088 <default_pmm_manager+0xb20>
ffffffffc0204652:	e406                	sd	ra,8(sp)
ffffffffc0204654:	e4bfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204658 <wait_queue_first>:
ffffffffc0204658:	651c                	ld	a5,8(a0)
ffffffffc020465a:	00f50563          	beq	a0,a5,ffffffffc0204664 <wait_queue_first+0xc>
ffffffffc020465e:	fe878513          	addi	a0,a5,-24
ffffffffc0204662:	8082                	ret
ffffffffc0204664:	4501                	li	a0,0
ffffffffc0204666:	8082                	ret

ffffffffc0204668 <wait_queue_empty>:
ffffffffc0204668:	651c                	ld	a5,8(a0)
ffffffffc020466a:	40a78533          	sub	a0,a5,a0
ffffffffc020466e:	00153513          	seqz	a0,a0
ffffffffc0204672:	8082                	ret

ffffffffc0204674 <wait_in_queue>:
ffffffffc0204674:	711c                	ld	a5,32(a0)
ffffffffc0204676:	0561                	addi	a0,a0,24
ffffffffc0204678:	40a78533          	sub	a0,a5,a0
ffffffffc020467c:	00a03533          	snez	a0,a0
ffffffffc0204680:	8082                	ret

ffffffffc0204682 <wakeup_wait>:
ffffffffc0204682:	e689                	bnez	a3,ffffffffc020468c <wakeup_wait+0xa>
ffffffffc0204684:	6188                	ld	a0,0(a1)
ffffffffc0204686:	c590                	sw	a2,8(a1)
ffffffffc0204688:	4e30206f          	j	ffffffffc020736a <wakeup_proc>
ffffffffc020468c:	7198                	ld	a4,32(a1)
ffffffffc020468e:	01858793          	addi	a5,a1,24
ffffffffc0204692:	00e78e63          	beq	a5,a4,ffffffffc02046ae <wakeup_wait+0x2c>
ffffffffc0204696:	6994                	ld	a3,16(a1)
ffffffffc0204698:	00d51b63          	bne	a0,a3,ffffffffc02046ae <wakeup_wait+0x2c>
ffffffffc020469c:	6d94                	ld	a3,24(a1)
ffffffffc020469e:	6188                	ld	a0,0(a1)
ffffffffc02046a0:	e698                	sd	a4,8(a3)
ffffffffc02046a2:	e314                	sd	a3,0(a4)
ffffffffc02046a4:	f19c                	sd	a5,32(a1)
ffffffffc02046a6:	ed9c                	sd	a5,24(a1)
ffffffffc02046a8:	c590                	sw	a2,8(a1)
ffffffffc02046aa:	4c10206f          	j	ffffffffc020736a <wakeup_proc>
ffffffffc02046ae:	1141                	addi	sp,sp,-16
ffffffffc02046b0:	00009697          	auipc	a3,0x9
ffffffffc02046b4:	9f068693          	addi	a3,a3,-1552 # ffffffffc020d0a0 <default_pmm_manager+0xb38>
ffffffffc02046b8:	00007617          	auipc	a2,0x7
ffffffffc02046bc:	3c860613          	addi	a2,a2,968 # ffffffffc020ba80 <commands+0x210>
ffffffffc02046c0:	45f1                	li	a1,28
ffffffffc02046c2:	00009517          	auipc	a0,0x9
ffffffffc02046c6:	9c650513          	addi	a0,a0,-1594 # ffffffffc020d088 <default_pmm_manager+0xb20>
ffffffffc02046ca:	e406                	sd	ra,8(sp)
ffffffffc02046cc:	dd3fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02046d0 <wakeup_queue>:
ffffffffc02046d0:	651c                	ld	a5,8(a0)
ffffffffc02046d2:	0ca78563          	beq	a5,a0,ffffffffc020479c <wakeup_queue+0xcc>
ffffffffc02046d6:	1101                	addi	sp,sp,-32
ffffffffc02046d8:	e822                	sd	s0,16(sp)
ffffffffc02046da:	e426                	sd	s1,8(sp)
ffffffffc02046dc:	e04a                	sd	s2,0(sp)
ffffffffc02046de:	ec06                	sd	ra,24(sp)
ffffffffc02046e0:	84aa                	mv	s1,a0
ffffffffc02046e2:	892e                	mv	s2,a1
ffffffffc02046e4:	fe878413          	addi	s0,a5,-24
ffffffffc02046e8:	e23d                	bnez	a2,ffffffffc020474e <wakeup_queue+0x7e>
ffffffffc02046ea:	6008                	ld	a0,0(s0)
ffffffffc02046ec:	01242423          	sw	s2,8(s0)
ffffffffc02046f0:	47b020ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc02046f4:	701c                	ld	a5,32(s0)
ffffffffc02046f6:	01840713          	addi	a4,s0,24
ffffffffc02046fa:	02e78463          	beq	a5,a4,ffffffffc0204722 <wakeup_queue+0x52>
ffffffffc02046fe:	6818                	ld	a4,16(s0)
ffffffffc0204700:	02e49163          	bne	s1,a4,ffffffffc0204722 <wakeup_queue+0x52>
ffffffffc0204704:	02f48f63          	beq	s1,a5,ffffffffc0204742 <wakeup_queue+0x72>
ffffffffc0204708:	fe87b503          	ld	a0,-24(a5)
ffffffffc020470c:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204710:	fe878413          	addi	s0,a5,-24
ffffffffc0204714:	457020ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc0204718:	701c                	ld	a5,32(s0)
ffffffffc020471a:	01840713          	addi	a4,s0,24
ffffffffc020471e:	fee790e3          	bne	a5,a4,ffffffffc02046fe <wakeup_queue+0x2e>
ffffffffc0204722:	00009697          	auipc	a3,0x9
ffffffffc0204726:	97e68693          	addi	a3,a3,-1666 # ffffffffc020d0a0 <default_pmm_manager+0xb38>
ffffffffc020472a:	00007617          	auipc	a2,0x7
ffffffffc020472e:	35660613          	addi	a2,a2,854 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204732:	02200593          	li	a1,34
ffffffffc0204736:	00009517          	auipc	a0,0x9
ffffffffc020473a:	95250513          	addi	a0,a0,-1710 # ffffffffc020d088 <default_pmm_manager+0xb20>
ffffffffc020473e:	d61fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204742:	60e2                	ld	ra,24(sp)
ffffffffc0204744:	6442                	ld	s0,16(sp)
ffffffffc0204746:	64a2                	ld	s1,8(sp)
ffffffffc0204748:	6902                	ld	s2,0(sp)
ffffffffc020474a:	6105                	addi	sp,sp,32
ffffffffc020474c:	8082                	ret
ffffffffc020474e:	6798                	ld	a4,8(a5)
ffffffffc0204750:	02f70763          	beq	a4,a5,ffffffffc020477e <wakeup_queue+0xae>
ffffffffc0204754:	6814                	ld	a3,16(s0)
ffffffffc0204756:	02d49463          	bne	s1,a3,ffffffffc020477e <wakeup_queue+0xae>
ffffffffc020475a:	6c14                	ld	a3,24(s0)
ffffffffc020475c:	6008                	ld	a0,0(s0)
ffffffffc020475e:	e698                	sd	a4,8(a3)
ffffffffc0204760:	e314                	sd	a3,0(a4)
ffffffffc0204762:	f01c                	sd	a5,32(s0)
ffffffffc0204764:	ec1c                	sd	a5,24(s0)
ffffffffc0204766:	01242423          	sw	s2,8(s0)
ffffffffc020476a:	401020ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc020476e:	6480                	ld	s0,8(s1)
ffffffffc0204770:	fc8489e3          	beq	s1,s0,ffffffffc0204742 <wakeup_queue+0x72>
ffffffffc0204774:	6418                	ld	a4,8(s0)
ffffffffc0204776:	87a2                	mv	a5,s0
ffffffffc0204778:	1421                	addi	s0,s0,-24
ffffffffc020477a:	fce79de3          	bne	a5,a4,ffffffffc0204754 <wakeup_queue+0x84>
ffffffffc020477e:	00009697          	auipc	a3,0x9
ffffffffc0204782:	92268693          	addi	a3,a3,-1758 # ffffffffc020d0a0 <default_pmm_manager+0xb38>
ffffffffc0204786:	00007617          	auipc	a2,0x7
ffffffffc020478a:	2fa60613          	addi	a2,a2,762 # ffffffffc020ba80 <commands+0x210>
ffffffffc020478e:	45f1                	li	a1,28
ffffffffc0204790:	00009517          	auipc	a0,0x9
ffffffffc0204794:	8f850513          	addi	a0,a0,-1800 # ffffffffc020d088 <default_pmm_manager+0xb20>
ffffffffc0204798:	d07fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020479c:	8082                	ret

ffffffffc020479e <wait_current_set>:
ffffffffc020479e:	00092797          	auipc	a5,0x92
ffffffffc02047a2:	1227b783          	ld	a5,290(a5) # ffffffffc02968c0 <current>
ffffffffc02047a6:	c39d                	beqz	a5,ffffffffc02047cc <wait_current_set+0x2e>
ffffffffc02047a8:	01858713          	addi	a4,a1,24
ffffffffc02047ac:	800006b7          	lui	a3,0x80000
ffffffffc02047b0:	ed98                	sd	a4,24(a1)
ffffffffc02047b2:	e19c                	sd	a5,0(a1)
ffffffffc02047b4:	c594                	sw	a3,8(a1)
ffffffffc02047b6:	4685                	li	a3,1
ffffffffc02047b8:	c394                	sw	a3,0(a5)
ffffffffc02047ba:	0ec7a623          	sw	a2,236(a5)
ffffffffc02047be:	611c                	ld	a5,0(a0)
ffffffffc02047c0:	e988                	sd	a0,16(a1)
ffffffffc02047c2:	e118                	sd	a4,0(a0)
ffffffffc02047c4:	e798                	sd	a4,8(a5)
ffffffffc02047c6:	f188                	sd	a0,32(a1)
ffffffffc02047c8:	ed9c                	sd	a5,24(a1)
ffffffffc02047ca:	8082                	ret
ffffffffc02047cc:	1141                	addi	sp,sp,-16
ffffffffc02047ce:	00009697          	auipc	a3,0x9
ffffffffc02047d2:	91268693          	addi	a3,a3,-1774 # ffffffffc020d0e0 <default_pmm_manager+0xb78>
ffffffffc02047d6:	00007617          	auipc	a2,0x7
ffffffffc02047da:	2aa60613          	addi	a2,a2,682 # ffffffffc020ba80 <commands+0x210>
ffffffffc02047de:	07400593          	li	a1,116
ffffffffc02047e2:	00009517          	auipc	a0,0x9
ffffffffc02047e6:	8a650513          	addi	a0,a0,-1882 # ffffffffc020d088 <default_pmm_manager+0xb20>
ffffffffc02047ea:	e406                	sd	ra,8(sp)
ffffffffc02047ec:	cb3fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02047f0 <get_fd_array.part.0>:
ffffffffc02047f0:	1141                	addi	sp,sp,-16
ffffffffc02047f2:	00009697          	auipc	a3,0x9
ffffffffc02047f6:	8fe68693          	addi	a3,a3,-1794 # ffffffffc020d0f0 <default_pmm_manager+0xb88>
ffffffffc02047fa:	00007617          	auipc	a2,0x7
ffffffffc02047fe:	28660613          	addi	a2,a2,646 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204802:	45d1                	li	a1,20
ffffffffc0204804:	00009517          	auipc	a0,0x9
ffffffffc0204808:	91c50513          	addi	a0,a0,-1764 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc020480c:	e406                	sd	ra,8(sp)
ffffffffc020480e:	c91fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204812 <fd_array_alloc>:
ffffffffc0204812:	00092797          	auipc	a5,0x92
ffffffffc0204816:	0ae7b783          	ld	a5,174(a5) # ffffffffc02968c0 <current>
ffffffffc020481a:	1487b783          	ld	a5,328(a5)
ffffffffc020481e:	1141                	addi	sp,sp,-16
ffffffffc0204820:	e406                	sd	ra,8(sp)
ffffffffc0204822:	c3a5                	beqz	a5,ffffffffc0204882 <fd_array_alloc+0x70>
ffffffffc0204824:	4b98                	lw	a4,16(a5)
ffffffffc0204826:	04e05e63          	blez	a4,ffffffffc0204882 <fd_array_alloc+0x70>
ffffffffc020482a:	775d                	lui	a4,0xffff7
ffffffffc020482c:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204830:	679c                	ld	a5,8(a5)
ffffffffc0204832:	02e50863          	beq	a0,a4,ffffffffc0204862 <fd_array_alloc+0x50>
ffffffffc0204836:	04700713          	li	a4,71
ffffffffc020483a:	04a76263          	bltu	a4,a0,ffffffffc020487e <fd_array_alloc+0x6c>
ffffffffc020483e:	00351713          	slli	a4,a0,0x3
ffffffffc0204842:	40a70533          	sub	a0,a4,a0
ffffffffc0204846:	050e                	slli	a0,a0,0x3
ffffffffc0204848:	97aa                	add	a5,a5,a0
ffffffffc020484a:	4398                	lw	a4,0(a5)
ffffffffc020484c:	e71d                	bnez	a4,ffffffffc020487a <fd_array_alloc+0x68>
ffffffffc020484e:	5b88                	lw	a0,48(a5)
ffffffffc0204850:	e91d                	bnez	a0,ffffffffc0204886 <fd_array_alloc+0x74>
ffffffffc0204852:	4705                	li	a4,1
ffffffffc0204854:	c398                	sw	a4,0(a5)
ffffffffc0204856:	0207b423          	sd	zero,40(a5)
ffffffffc020485a:	e19c                	sd	a5,0(a1)
ffffffffc020485c:	60a2                	ld	ra,8(sp)
ffffffffc020485e:	0141                	addi	sp,sp,16
ffffffffc0204860:	8082                	ret
ffffffffc0204862:	6685                	lui	a3,0x1
ffffffffc0204864:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0204868:	96be                	add	a3,a3,a5
ffffffffc020486a:	4398                	lw	a4,0(a5)
ffffffffc020486c:	d36d                	beqz	a4,ffffffffc020484e <fd_array_alloc+0x3c>
ffffffffc020486e:	03878793          	addi	a5,a5,56
ffffffffc0204872:	fef69ce3          	bne	a3,a5,ffffffffc020486a <fd_array_alloc+0x58>
ffffffffc0204876:	5529                	li	a0,-22
ffffffffc0204878:	b7d5                	j	ffffffffc020485c <fd_array_alloc+0x4a>
ffffffffc020487a:	5545                	li	a0,-15
ffffffffc020487c:	b7c5                	j	ffffffffc020485c <fd_array_alloc+0x4a>
ffffffffc020487e:	5575                	li	a0,-3
ffffffffc0204880:	bff1                	j	ffffffffc020485c <fd_array_alloc+0x4a>
ffffffffc0204882:	f6fff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>
ffffffffc0204886:	00009697          	auipc	a3,0x9
ffffffffc020488a:	8aa68693          	addi	a3,a3,-1878 # ffffffffc020d130 <default_pmm_manager+0xbc8>
ffffffffc020488e:	00007617          	auipc	a2,0x7
ffffffffc0204892:	1f260613          	addi	a2,a2,498 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204896:	03b00593          	li	a1,59
ffffffffc020489a:	00009517          	auipc	a0,0x9
ffffffffc020489e:	88650513          	addi	a0,a0,-1914 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc02048a2:	bfdfb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02048a6 <fd_array_free>:
ffffffffc02048a6:	411c                	lw	a5,0(a0)
ffffffffc02048a8:	1141                	addi	sp,sp,-16
ffffffffc02048aa:	e022                	sd	s0,0(sp)
ffffffffc02048ac:	e406                	sd	ra,8(sp)
ffffffffc02048ae:	4705                	li	a4,1
ffffffffc02048b0:	842a                	mv	s0,a0
ffffffffc02048b2:	04e78063          	beq	a5,a4,ffffffffc02048f2 <fd_array_free+0x4c>
ffffffffc02048b6:	470d                	li	a4,3
ffffffffc02048b8:	04e79563          	bne	a5,a4,ffffffffc0204902 <fd_array_free+0x5c>
ffffffffc02048bc:	591c                	lw	a5,48(a0)
ffffffffc02048be:	c38d                	beqz	a5,ffffffffc02048e0 <fd_array_free+0x3a>
ffffffffc02048c0:	00009697          	auipc	a3,0x9
ffffffffc02048c4:	87068693          	addi	a3,a3,-1936 # ffffffffc020d130 <default_pmm_manager+0xbc8>
ffffffffc02048c8:	00007617          	auipc	a2,0x7
ffffffffc02048cc:	1b860613          	addi	a2,a2,440 # ffffffffc020ba80 <commands+0x210>
ffffffffc02048d0:	04500593          	li	a1,69
ffffffffc02048d4:	00009517          	auipc	a0,0x9
ffffffffc02048d8:	84c50513          	addi	a0,a0,-1972 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc02048dc:	bc3fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02048e0:	7408                	ld	a0,40(s0)
ffffffffc02048e2:	0ff030ef          	jal	ra,ffffffffc02081e0 <vfs_close>
ffffffffc02048e6:	60a2                	ld	ra,8(sp)
ffffffffc02048e8:	00042023          	sw	zero,0(s0)
ffffffffc02048ec:	6402                	ld	s0,0(sp)
ffffffffc02048ee:	0141                	addi	sp,sp,16
ffffffffc02048f0:	8082                	ret
ffffffffc02048f2:	591c                	lw	a5,48(a0)
ffffffffc02048f4:	f7f1                	bnez	a5,ffffffffc02048c0 <fd_array_free+0x1a>
ffffffffc02048f6:	60a2                	ld	ra,8(sp)
ffffffffc02048f8:	00042023          	sw	zero,0(s0)
ffffffffc02048fc:	6402                	ld	s0,0(sp)
ffffffffc02048fe:	0141                	addi	sp,sp,16
ffffffffc0204900:	8082                	ret
ffffffffc0204902:	00009697          	auipc	a3,0x9
ffffffffc0204906:	86668693          	addi	a3,a3,-1946 # ffffffffc020d168 <default_pmm_manager+0xc00>
ffffffffc020490a:	00007617          	auipc	a2,0x7
ffffffffc020490e:	17660613          	addi	a2,a2,374 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204912:	04400593          	li	a1,68
ffffffffc0204916:	00009517          	auipc	a0,0x9
ffffffffc020491a:	80a50513          	addi	a0,a0,-2038 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc020491e:	b81fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204922 <fd_array_release>:
ffffffffc0204922:	4118                	lw	a4,0(a0)
ffffffffc0204924:	1141                	addi	sp,sp,-16
ffffffffc0204926:	e406                	sd	ra,8(sp)
ffffffffc0204928:	4685                	li	a3,1
ffffffffc020492a:	3779                	addiw	a4,a4,-2
ffffffffc020492c:	04e6e063          	bltu	a3,a4,ffffffffc020496c <fd_array_release+0x4a>
ffffffffc0204930:	5918                	lw	a4,48(a0)
ffffffffc0204932:	00e05d63          	blez	a4,ffffffffc020494c <fd_array_release+0x2a>
ffffffffc0204936:	fff7069b          	addiw	a3,a4,-1
ffffffffc020493a:	d914                	sw	a3,48(a0)
ffffffffc020493c:	c681                	beqz	a3,ffffffffc0204944 <fd_array_release+0x22>
ffffffffc020493e:	60a2                	ld	ra,8(sp)
ffffffffc0204940:	0141                	addi	sp,sp,16
ffffffffc0204942:	8082                	ret
ffffffffc0204944:	60a2                	ld	ra,8(sp)
ffffffffc0204946:	0141                	addi	sp,sp,16
ffffffffc0204948:	f5fff06f          	j	ffffffffc02048a6 <fd_array_free>
ffffffffc020494c:	00009697          	auipc	a3,0x9
ffffffffc0204950:	88c68693          	addi	a3,a3,-1908 # ffffffffc020d1d8 <default_pmm_manager+0xc70>
ffffffffc0204954:	00007617          	auipc	a2,0x7
ffffffffc0204958:	12c60613          	addi	a2,a2,300 # ffffffffc020ba80 <commands+0x210>
ffffffffc020495c:	05600593          	li	a1,86
ffffffffc0204960:	00008517          	auipc	a0,0x8
ffffffffc0204964:	7c050513          	addi	a0,a0,1984 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204968:	b37fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020496c:	00009697          	auipc	a3,0x9
ffffffffc0204970:	83468693          	addi	a3,a3,-1996 # ffffffffc020d1a0 <default_pmm_manager+0xc38>
ffffffffc0204974:	00007617          	auipc	a2,0x7
ffffffffc0204978:	10c60613          	addi	a2,a2,268 # ffffffffc020ba80 <commands+0x210>
ffffffffc020497c:	05500593          	li	a1,85
ffffffffc0204980:	00008517          	auipc	a0,0x8
ffffffffc0204984:	7a050513          	addi	a0,a0,1952 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204988:	b17fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020498c <fd_array_open.part.0>:
ffffffffc020498c:	1141                	addi	sp,sp,-16
ffffffffc020498e:	00009697          	auipc	a3,0x9
ffffffffc0204992:	86268693          	addi	a3,a3,-1950 # ffffffffc020d1f0 <default_pmm_manager+0xc88>
ffffffffc0204996:	00007617          	auipc	a2,0x7
ffffffffc020499a:	0ea60613          	addi	a2,a2,234 # ffffffffc020ba80 <commands+0x210>
ffffffffc020499e:	05f00593          	li	a1,95
ffffffffc02049a2:	00008517          	auipc	a0,0x8
ffffffffc02049a6:	77e50513          	addi	a0,a0,1918 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc02049aa:	e406                	sd	ra,8(sp)
ffffffffc02049ac:	af3fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02049b0 <fd_array_init>:
ffffffffc02049b0:	4781                	li	a5,0
ffffffffc02049b2:	04800713          	li	a4,72
ffffffffc02049b6:	cd1c                	sw	a5,24(a0)
ffffffffc02049b8:	02052823          	sw	zero,48(a0)
ffffffffc02049bc:	00052023          	sw	zero,0(a0)
ffffffffc02049c0:	2785                	addiw	a5,a5,1
ffffffffc02049c2:	03850513          	addi	a0,a0,56
ffffffffc02049c6:	fee798e3          	bne	a5,a4,ffffffffc02049b6 <fd_array_init+0x6>
ffffffffc02049ca:	8082                	ret

ffffffffc02049cc <fd_array_close>:
ffffffffc02049cc:	4118                	lw	a4,0(a0)
ffffffffc02049ce:	1141                	addi	sp,sp,-16
ffffffffc02049d0:	e406                	sd	ra,8(sp)
ffffffffc02049d2:	e022                	sd	s0,0(sp)
ffffffffc02049d4:	4789                	li	a5,2
ffffffffc02049d6:	04f71a63          	bne	a4,a5,ffffffffc0204a2a <fd_array_close+0x5e>
ffffffffc02049da:	591c                	lw	a5,48(a0)
ffffffffc02049dc:	842a                	mv	s0,a0
ffffffffc02049de:	02f05663          	blez	a5,ffffffffc0204a0a <fd_array_close+0x3e>
ffffffffc02049e2:	37fd                	addiw	a5,a5,-1
ffffffffc02049e4:	470d                	li	a4,3
ffffffffc02049e6:	c118                	sw	a4,0(a0)
ffffffffc02049e8:	d91c                	sw	a5,48(a0)
ffffffffc02049ea:	0007871b          	sext.w	a4,a5
ffffffffc02049ee:	c709                	beqz	a4,ffffffffc02049f8 <fd_array_close+0x2c>
ffffffffc02049f0:	60a2                	ld	ra,8(sp)
ffffffffc02049f2:	6402                	ld	s0,0(sp)
ffffffffc02049f4:	0141                	addi	sp,sp,16
ffffffffc02049f6:	8082                	ret
ffffffffc02049f8:	7508                	ld	a0,40(a0)
ffffffffc02049fa:	7e6030ef          	jal	ra,ffffffffc02081e0 <vfs_close>
ffffffffc02049fe:	60a2                	ld	ra,8(sp)
ffffffffc0204a00:	00042023          	sw	zero,0(s0)
ffffffffc0204a04:	6402                	ld	s0,0(sp)
ffffffffc0204a06:	0141                	addi	sp,sp,16
ffffffffc0204a08:	8082                	ret
ffffffffc0204a0a:	00008697          	auipc	a3,0x8
ffffffffc0204a0e:	7ce68693          	addi	a3,a3,1998 # ffffffffc020d1d8 <default_pmm_manager+0xc70>
ffffffffc0204a12:	00007617          	auipc	a2,0x7
ffffffffc0204a16:	06e60613          	addi	a2,a2,110 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204a1a:	06800593          	li	a1,104
ffffffffc0204a1e:	00008517          	auipc	a0,0x8
ffffffffc0204a22:	70250513          	addi	a0,a0,1794 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204a26:	a79fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204a2a:	00008697          	auipc	a3,0x8
ffffffffc0204a2e:	71e68693          	addi	a3,a3,1822 # ffffffffc020d148 <default_pmm_manager+0xbe0>
ffffffffc0204a32:	00007617          	auipc	a2,0x7
ffffffffc0204a36:	04e60613          	addi	a2,a2,78 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204a3a:	06700593          	li	a1,103
ffffffffc0204a3e:	00008517          	auipc	a0,0x8
ffffffffc0204a42:	6e250513          	addi	a0,a0,1762 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204a46:	a59fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204a4a <fd_array_dup>:
ffffffffc0204a4a:	7179                	addi	sp,sp,-48
ffffffffc0204a4c:	e84a                	sd	s2,16(sp)
ffffffffc0204a4e:	00052903          	lw	s2,0(a0)
ffffffffc0204a52:	f406                	sd	ra,40(sp)
ffffffffc0204a54:	f022                	sd	s0,32(sp)
ffffffffc0204a56:	ec26                	sd	s1,24(sp)
ffffffffc0204a58:	e44e                	sd	s3,8(sp)
ffffffffc0204a5a:	4785                	li	a5,1
ffffffffc0204a5c:	04f91663          	bne	s2,a5,ffffffffc0204aa8 <fd_array_dup+0x5e>
ffffffffc0204a60:	0005a983          	lw	s3,0(a1)
ffffffffc0204a64:	4789                	li	a5,2
ffffffffc0204a66:	04f99163          	bne	s3,a5,ffffffffc0204aa8 <fd_array_dup+0x5e>
ffffffffc0204a6a:	7584                	ld	s1,40(a1)
ffffffffc0204a6c:	699c                	ld	a5,16(a1)
ffffffffc0204a6e:	7194                	ld	a3,32(a1)
ffffffffc0204a70:	6598                	ld	a4,8(a1)
ffffffffc0204a72:	842a                	mv	s0,a0
ffffffffc0204a74:	e91c                	sd	a5,16(a0)
ffffffffc0204a76:	f114                	sd	a3,32(a0)
ffffffffc0204a78:	e518                	sd	a4,8(a0)
ffffffffc0204a7a:	8526                	mv	a0,s1
ffffffffc0204a7c:	6c3020ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc0204a80:	8526                	mv	a0,s1
ffffffffc0204a82:	6c9020ef          	jal	ra,ffffffffc020794a <inode_open_inc>
ffffffffc0204a86:	401c                	lw	a5,0(s0)
ffffffffc0204a88:	f404                	sd	s1,40(s0)
ffffffffc0204a8a:	03279f63          	bne	a5,s2,ffffffffc0204ac8 <fd_array_dup+0x7e>
ffffffffc0204a8e:	cc8d                	beqz	s1,ffffffffc0204ac8 <fd_array_dup+0x7e>
ffffffffc0204a90:	581c                	lw	a5,48(s0)
ffffffffc0204a92:	01342023          	sw	s3,0(s0)
ffffffffc0204a96:	70a2                	ld	ra,40(sp)
ffffffffc0204a98:	2785                	addiw	a5,a5,1
ffffffffc0204a9a:	d81c                	sw	a5,48(s0)
ffffffffc0204a9c:	7402                	ld	s0,32(sp)
ffffffffc0204a9e:	64e2                	ld	s1,24(sp)
ffffffffc0204aa0:	6942                	ld	s2,16(sp)
ffffffffc0204aa2:	69a2                	ld	s3,8(sp)
ffffffffc0204aa4:	6145                	addi	sp,sp,48
ffffffffc0204aa6:	8082                	ret
ffffffffc0204aa8:	00008697          	auipc	a3,0x8
ffffffffc0204aac:	77868693          	addi	a3,a3,1912 # ffffffffc020d220 <default_pmm_manager+0xcb8>
ffffffffc0204ab0:	00007617          	auipc	a2,0x7
ffffffffc0204ab4:	fd060613          	addi	a2,a2,-48 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204ab8:	07300593          	li	a1,115
ffffffffc0204abc:	00008517          	auipc	a0,0x8
ffffffffc0204ac0:	66450513          	addi	a0,a0,1636 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204ac4:	9dbfb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204ac8:	ec5ff0ef          	jal	ra,ffffffffc020498c <fd_array_open.part.0>

ffffffffc0204acc <file_testfd>:
ffffffffc0204acc:	04700793          	li	a5,71
ffffffffc0204ad0:	04a7e263          	bltu	a5,a0,ffffffffc0204b14 <file_testfd+0x48>
ffffffffc0204ad4:	00092797          	auipc	a5,0x92
ffffffffc0204ad8:	dec7b783          	ld	a5,-532(a5) # ffffffffc02968c0 <current>
ffffffffc0204adc:	1487b783          	ld	a5,328(a5)
ffffffffc0204ae0:	cf85                	beqz	a5,ffffffffc0204b18 <file_testfd+0x4c>
ffffffffc0204ae2:	4b98                	lw	a4,16(a5)
ffffffffc0204ae4:	02e05a63          	blez	a4,ffffffffc0204b18 <file_testfd+0x4c>
ffffffffc0204ae8:	6798                	ld	a4,8(a5)
ffffffffc0204aea:	00351793          	slli	a5,a0,0x3
ffffffffc0204aee:	8f89                	sub	a5,a5,a0
ffffffffc0204af0:	078e                	slli	a5,a5,0x3
ffffffffc0204af2:	97ba                	add	a5,a5,a4
ffffffffc0204af4:	4394                	lw	a3,0(a5)
ffffffffc0204af6:	4709                	li	a4,2
ffffffffc0204af8:	00e69e63          	bne	a3,a4,ffffffffc0204b14 <file_testfd+0x48>
ffffffffc0204afc:	4f98                	lw	a4,24(a5)
ffffffffc0204afe:	00a71b63          	bne	a4,a0,ffffffffc0204b14 <file_testfd+0x48>
ffffffffc0204b02:	c199                	beqz	a1,ffffffffc0204b08 <file_testfd+0x3c>
ffffffffc0204b04:	6788                	ld	a0,8(a5)
ffffffffc0204b06:	c901                	beqz	a0,ffffffffc0204b16 <file_testfd+0x4a>
ffffffffc0204b08:	4505                	li	a0,1
ffffffffc0204b0a:	c611                	beqz	a2,ffffffffc0204b16 <file_testfd+0x4a>
ffffffffc0204b0c:	6b88                	ld	a0,16(a5)
ffffffffc0204b0e:	00a03533          	snez	a0,a0
ffffffffc0204b12:	8082                	ret
ffffffffc0204b14:	4501                	li	a0,0
ffffffffc0204b16:	8082                	ret
ffffffffc0204b18:	1141                	addi	sp,sp,-16
ffffffffc0204b1a:	e406                	sd	ra,8(sp)
ffffffffc0204b1c:	cd5ff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>

ffffffffc0204b20 <file_open>:
ffffffffc0204b20:	711d                	addi	sp,sp,-96
ffffffffc0204b22:	ec86                	sd	ra,88(sp)
ffffffffc0204b24:	e8a2                	sd	s0,80(sp)
ffffffffc0204b26:	e4a6                	sd	s1,72(sp)
ffffffffc0204b28:	e0ca                	sd	s2,64(sp)
ffffffffc0204b2a:	fc4e                	sd	s3,56(sp)
ffffffffc0204b2c:	f852                	sd	s4,48(sp)
ffffffffc0204b2e:	0035f793          	andi	a5,a1,3
ffffffffc0204b32:	470d                	li	a4,3
ffffffffc0204b34:	0ce78163          	beq	a5,a4,ffffffffc0204bf6 <file_open+0xd6>
ffffffffc0204b38:	078e                	slli	a5,a5,0x3
ffffffffc0204b3a:	00009717          	auipc	a4,0x9
ffffffffc0204b3e:	95670713          	addi	a4,a4,-1706 # ffffffffc020d490 <CSWTCH.79>
ffffffffc0204b42:	892a                	mv	s2,a0
ffffffffc0204b44:	00009697          	auipc	a3,0x9
ffffffffc0204b48:	93468693          	addi	a3,a3,-1740 # ffffffffc020d478 <CSWTCH.78>
ffffffffc0204b4c:	755d                	lui	a0,0xffff7
ffffffffc0204b4e:	96be                	add	a3,a3,a5
ffffffffc0204b50:	84ae                	mv	s1,a1
ffffffffc0204b52:	97ba                	add	a5,a5,a4
ffffffffc0204b54:	858a                	mv	a1,sp
ffffffffc0204b56:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204b5a:	0006ba03          	ld	s4,0(a3)
ffffffffc0204b5e:	0007b983          	ld	s3,0(a5)
ffffffffc0204b62:	cb1ff0ef          	jal	ra,ffffffffc0204812 <fd_array_alloc>
ffffffffc0204b66:	842a                	mv	s0,a0
ffffffffc0204b68:	c911                	beqz	a0,ffffffffc0204b7c <file_open+0x5c>
ffffffffc0204b6a:	60e6                	ld	ra,88(sp)
ffffffffc0204b6c:	8522                	mv	a0,s0
ffffffffc0204b6e:	6446                	ld	s0,80(sp)
ffffffffc0204b70:	64a6                	ld	s1,72(sp)
ffffffffc0204b72:	6906                	ld	s2,64(sp)
ffffffffc0204b74:	79e2                	ld	s3,56(sp)
ffffffffc0204b76:	7a42                	ld	s4,48(sp)
ffffffffc0204b78:	6125                	addi	sp,sp,96
ffffffffc0204b7a:	8082                	ret
ffffffffc0204b7c:	0030                	addi	a2,sp,8
ffffffffc0204b7e:	85a6                	mv	a1,s1
ffffffffc0204b80:	854a                	mv	a0,s2
ffffffffc0204b82:	4b8030ef          	jal	ra,ffffffffc020803a <vfs_open>
ffffffffc0204b86:	842a                	mv	s0,a0
ffffffffc0204b88:	e13d                	bnez	a0,ffffffffc0204bee <file_open+0xce>
ffffffffc0204b8a:	6782                	ld	a5,0(sp)
ffffffffc0204b8c:	0204f493          	andi	s1,s1,32
ffffffffc0204b90:	6422                	ld	s0,8(sp)
ffffffffc0204b92:	0207b023          	sd	zero,32(a5)
ffffffffc0204b96:	c885                	beqz	s1,ffffffffc0204bc6 <file_open+0xa6>
ffffffffc0204b98:	c03d                	beqz	s0,ffffffffc0204bfe <file_open+0xde>
ffffffffc0204b9a:	783c                	ld	a5,112(s0)
ffffffffc0204b9c:	c3ad                	beqz	a5,ffffffffc0204bfe <file_open+0xde>
ffffffffc0204b9e:	779c                	ld	a5,40(a5)
ffffffffc0204ba0:	cfb9                	beqz	a5,ffffffffc0204bfe <file_open+0xde>
ffffffffc0204ba2:	8522                	mv	a0,s0
ffffffffc0204ba4:	00008597          	auipc	a1,0x8
ffffffffc0204ba8:	70458593          	addi	a1,a1,1796 # ffffffffc020d2a8 <default_pmm_manager+0xd40>
ffffffffc0204bac:	5ab020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0204bb0:	783c                	ld	a5,112(s0)
ffffffffc0204bb2:	6522                	ld	a0,8(sp)
ffffffffc0204bb4:	080c                	addi	a1,sp,16
ffffffffc0204bb6:	779c                	ld	a5,40(a5)
ffffffffc0204bb8:	9782                	jalr	a5
ffffffffc0204bba:	842a                	mv	s0,a0
ffffffffc0204bbc:	e515                	bnez	a0,ffffffffc0204be8 <file_open+0xc8>
ffffffffc0204bbe:	6782                	ld	a5,0(sp)
ffffffffc0204bc0:	7722                	ld	a4,40(sp)
ffffffffc0204bc2:	6422                	ld	s0,8(sp)
ffffffffc0204bc4:	f398                	sd	a4,32(a5)
ffffffffc0204bc6:	4394                	lw	a3,0(a5)
ffffffffc0204bc8:	f780                	sd	s0,40(a5)
ffffffffc0204bca:	0147b423          	sd	s4,8(a5)
ffffffffc0204bce:	0137b823          	sd	s3,16(a5)
ffffffffc0204bd2:	4705                	li	a4,1
ffffffffc0204bd4:	02e69363          	bne	a3,a4,ffffffffc0204bfa <file_open+0xda>
ffffffffc0204bd8:	c00d                	beqz	s0,ffffffffc0204bfa <file_open+0xda>
ffffffffc0204bda:	5b98                	lw	a4,48(a5)
ffffffffc0204bdc:	4689                	li	a3,2
ffffffffc0204bde:	4f80                	lw	s0,24(a5)
ffffffffc0204be0:	2705                	addiw	a4,a4,1
ffffffffc0204be2:	c394                	sw	a3,0(a5)
ffffffffc0204be4:	db98                	sw	a4,48(a5)
ffffffffc0204be6:	b751                	j	ffffffffc0204b6a <file_open+0x4a>
ffffffffc0204be8:	6522                	ld	a0,8(sp)
ffffffffc0204bea:	5f6030ef          	jal	ra,ffffffffc02081e0 <vfs_close>
ffffffffc0204bee:	6502                	ld	a0,0(sp)
ffffffffc0204bf0:	cb7ff0ef          	jal	ra,ffffffffc02048a6 <fd_array_free>
ffffffffc0204bf4:	bf9d                	j	ffffffffc0204b6a <file_open+0x4a>
ffffffffc0204bf6:	5475                	li	s0,-3
ffffffffc0204bf8:	bf8d                	j	ffffffffc0204b6a <file_open+0x4a>
ffffffffc0204bfa:	d93ff0ef          	jal	ra,ffffffffc020498c <fd_array_open.part.0>
ffffffffc0204bfe:	00008697          	auipc	a3,0x8
ffffffffc0204c02:	65a68693          	addi	a3,a3,1626 # ffffffffc020d258 <default_pmm_manager+0xcf0>
ffffffffc0204c06:	00007617          	auipc	a2,0x7
ffffffffc0204c0a:	e7a60613          	addi	a2,a2,-390 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204c0e:	0b500593          	li	a1,181
ffffffffc0204c12:	00008517          	auipc	a0,0x8
ffffffffc0204c16:	50e50513          	addi	a0,a0,1294 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204c1a:	885fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204c1e <file_close>:
ffffffffc0204c1e:	04700713          	li	a4,71
ffffffffc0204c22:	04a76563          	bltu	a4,a0,ffffffffc0204c6c <file_close+0x4e>
ffffffffc0204c26:	00092717          	auipc	a4,0x92
ffffffffc0204c2a:	c9a73703          	ld	a4,-870(a4) # ffffffffc02968c0 <current>
ffffffffc0204c2e:	14873703          	ld	a4,328(a4)
ffffffffc0204c32:	1141                	addi	sp,sp,-16
ffffffffc0204c34:	e406                	sd	ra,8(sp)
ffffffffc0204c36:	cf0d                	beqz	a4,ffffffffc0204c70 <file_close+0x52>
ffffffffc0204c38:	4b14                	lw	a3,16(a4)
ffffffffc0204c3a:	02d05b63          	blez	a3,ffffffffc0204c70 <file_close+0x52>
ffffffffc0204c3e:	6718                	ld	a4,8(a4)
ffffffffc0204c40:	87aa                	mv	a5,a0
ffffffffc0204c42:	050e                	slli	a0,a0,0x3
ffffffffc0204c44:	8d1d                	sub	a0,a0,a5
ffffffffc0204c46:	050e                	slli	a0,a0,0x3
ffffffffc0204c48:	953a                	add	a0,a0,a4
ffffffffc0204c4a:	4114                	lw	a3,0(a0)
ffffffffc0204c4c:	4709                	li	a4,2
ffffffffc0204c4e:	00e69b63          	bne	a3,a4,ffffffffc0204c64 <file_close+0x46>
ffffffffc0204c52:	4d18                	lw	a4,24(a0)
ffffffffc0204c54:	00f71863          	bne	a4,a5,ffffffffc0204c64 <file_close+0x46>
ffffffffc0204c58:	d75ff0ef          	jal	ra,ffffffffc02049cc <fd_array_close>
ffffffffc0204c5c:	60a2                	ld	ra,8(sp)
ffffffffc0204c5e:	4501                	li	a0,0
ffffffffc0204c60:	0141                	addi	sp,sp,16
ffffffffc0204c62:	8082                	ret
ffffffffc0204c64:	60a2                	ld	ra,8(sp)
ffffffffc0204c66:	5575                	li	a0,-3
ffffffffc0204c68:	0141                	addi	sp,sp,16
ffffffffc0204c6a:	8082                	ret
ffffffffc0204c6c:	5575                	li	a0,-3
ffffffffc0204c6e:	8082                	ret
ffffffffc0204c70:	b81ff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>

ffffffffc0204c74 <file_read>:
ffffffffc0204c74:	715d                	addi	sp,sp,-80
ffffffffc0204c76:	e486                	sd	ra,72(sp)
ffffffffc0204c78:	e0a2                	sd	s0,64(sp)
ffffffffc0204c7a:	fc26                	sd	s1,56(sp)
ffffffffc0204c7c:	f84a                	sd	s2,48(sp)
ffffffffc0204c7e:	f44e                	sd	s3,40(sp)
ffffffffc0204c80:	f052                	sd	s4,32(sp)
ffffffffc0204c82:	0006b023          	sd	zero,0(a3)
ffffffffc0204c86:	04700793          	li	a5,71
ffffffffc0204c8a:	0aa7e463          	bltu	a5,a0,ffffffffc0204d32 <file_read+0xbe>
ffffffffc0204c8e:	00092797          	auipc	a5,0x92
ffffffffc0204c92:	c327b783          	ld	a5,-974(a5) # ffffffffc02968c0 <current>
ffffffffc0204c96:	1487b783          	ld	a5,328(a5)
ffffffffc0204c9a:	cfd1                	beqz	a5,ffffffffc0204d36 <file_read+0xc2>
ffffffffc0204c9c:	4b98                	lw	a4,16(a5)
ffffffffc0204c9e:	08e05c63          	blez	a4,ffffffffc0204d36 <file_read+0xc2>
ffffffffc0204ca2:	6780                	ld	s0,8(a5)
ffffffffc0204ca4:	00351793          	slli	a5,a0,0x3
ffffffffc0204ca8:	8f89                	sub	a5,a5,a0
ffffffffc0204caa:	078e                	slli	a5,a5,0x3
ffffffffc0204cac:	943e                	add	s0,s0,a5
ffffffffc0204cae:	00042983          	lw	s3,0(s0)
ffffffffc0204cb2:	4789                	li	a5,2
ffffffffc0204cb4:	06f99f63          	bne	s3,a5,ffffffffc0204d32 <file_read+0xbe>
ffffffffc0204cb8:	4c1c                	lw	a5,24(s0)
ffffffffc0204cba:	06a79c63          	bne	a5,a0,ffffffffc0204d32 <file_read+0xbe>
ffffffffc0204cbe:	641c                	ld	a5,8(s0)
ffffffffc0204cc0:	cbad                	beqz	a5,ffffffffc0204d32 <file_read+0xbe>
ffffffffc0204cc2:	581c                	lw	a5,48(s0)
ffffffffc0204cc4:	8a36                	mv	s4,a3
ffffffffc0204cc6:	7014                	ld	a3,32(s0)
ffffffffc0204cc8:	2785                	addiw	a5,a5,1
ffffffffc0204cca:	850a                	mv	a0,sp
ffffffffc0204ccc:	d81c                	sw	a5,48(s0)
ffffffffc0204cce:	792000ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc0204cd2:	02843903          	ld	s2,40(s0)
ffffffffc0204cd6:	84aa                	mv	s1,a0
ffffffffc0204cd8:	06090163          	beqz	s2,ffffffffc0204d3a <file_read+0xc6>
ffffffffc0204cdc:	07093783          	ld	a5,112(s2)
ffffffffc0204ce0:	cfa9                	beqz	a5,ffffffffc0204d3a <file_read+0xc6>
ffffffffc0204ce2:	6f9c                	ld	a5,24(a5)
ffffffffc0204ce4:	cbb9                	beqz	a5,ffffffffc0204d3a <file_read+0xc6>
ffffffffc0204ce6:	00008597          	auipc	a1,0x8
ffffffffc0204cea:	61a58593          	addi	a1,a1,1562 # ffffffffc020d300 <default_pmm_manager+0xd98>
ffffffffc0204cee:	854a                	mv	a0,s2
ffffffffc0204cf0:	467020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0204cf4:	07093783          	ld	a5,112(s2)
ffffffffc0204cf8:	7408                	ld	a0,40(s0)
ffffffffc0204cfa:	85a6                	mv	a1,s1
ffffffffc0204cfc:	6f9c                	ld	a5,24(a5)
ffffffffc0204cfe:	9782                	jalr	a5
ffffffffc0204d00:	689c                	ld	a5,16(s1)
ffffffffc0204d02:	6c94                	ld	a3,24(s1)
ffffffffc0204d04:	4018                	lw	a4,0(s0)
ffffffffc0204d06:	84aa                	mv	s1,a0
ffffffffc0204d08:	8f95                	sub	a5,a5,a3
ffffffffc0204d0a:	03370063          	beq	a4,s3,ffffffffc0204d2a <file_read+0xb6>
ffffffffc0204d0e:	00fa3023          	sd	a5,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204d12:	8522                	mv	a0,s0
ffffffffc0204d14:	c0fff0ef          	jal	ra,ffffffffc0204922 <fd_array_release>
ffffffffc0204d18:	60a6                	ld	ra,72(sp)
ffffffffc0204d1a:	6406                	ld	s0,64(sp)
ffffffffc0204d1c:	7942                	ld	s2,48(sp)
ffffffffc0204d1e:	79a2                	ld	s3,40(sp)
ffffffffc0204d20:	7a02                	ld	s4,32(sp)
ffffffffc0204d22:	8526                	mv	a0,s1
ffffffffc0204d24:	74e2                	ld	s1,56(sp)
ffffffffc0204d26:	6161                	addi	sp,sp,80
ffffffffc0204d28:	8082                	ret
ffffffffc0204d2a:	7018                	ld	a4,32(s0)
ffffffffc0204d2c:	973e                	add	a4,a4,a5
ffffffffc0204d2e:	f018                	sd	a4,32(s0)
ffffffffc0204d30:	bff9                	j	ffffffffc0204d0e <file_read+0x9a>
ffffffffc0204d32:	54f5                	li	s1,-3
ffffffffc0204d34:	b7d5                	j	ffffffffc0204d18 <file_read+0xa4>
ffffffffc0204d36:	abbff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>
ffffffffc0204d3a:	00008697          	auipc	a3,0x8
ffffffffc0204d3e:	57668693          	addi	a3,a3,1398 # ffffffffc020d2b0 <default_pmm_manager+0xd48>
ffffffffc0204d42:	00007617          	auipc	a2,0x7
ffffffffc0204d46:	d3e60613          	addi	a2,a2,-706 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204d4a:	0de00593          	li	a1,222
ffffffffc0204d4e:	00008517          	auipc	a0,0x8
ffffffffc0204d52:	3d250513          	addi	a0,a0,978 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204d56:	f48fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204d5a <file_write>:
ffffffffc0204d5a:	715d                	addi	sp,sp,-80
ffffffffc0204d5c:	e486                	sd	ra,72(sp)
ffffffffc0204d5e:	e0a2                	sd	s0,64(sp)
ffffffffc0204d60:	fc26                	sd	s1,56(sp)
ffffffffc0204d62:	f84a                	sd	s2,48(sp)
ffffffffc0204d64:	f44e                	sd	s3,40(sp)
ffffffffc0204d66:	f052                	sd	s4,32(sp)
ffffffffc0204d68:	0006b023          	sd	zero,0(a3)
ffffffffc0204d6c:	04700793          	li	a5,71
ffffffffc0204d70:	0aa7e463          	bltu	a5,a0,ffffffffc0204e18 <file_write+0xbe>
ffffffffc0204d74:	00092797          	auipc	a5,0x92
ffffffffc0204d78:	b4c7b783          	ld	a5,-1204(a5) # ffffffffc02968c0 <current>
ffffffffc0204d7c:	1487b783          	ld	a5,328(a5)
ffffffffc0204d80:	cfd1                	beqz	a5,ffffffffc0204e1c <file_write+0xc2>
ffffffffc0204d82:	4b98                	lw	a4,16(a5)
ffffffffc0204d84:	08e05c63          	blez	a4,ffffffffc0204e1c <file_write+0xc2>
ffffffffc0204d88:	6780                	ld	s0,8(a5)
ffffffffc0204d8a:	00351793          	slli	a5,a0,0x3
ffffffffc0204d8e:	8f89                	sub	a5,a5,a0
ffffffffc0204d90:	078e                	slli	a5,a5,0x3
ffffffffc0204d92:	943e                	add	s0,s0,a5
ffffffffc0204d94:	00042983          	lw	s3,0(s0)
ffffffffc0204d98:	4789                	li	a5,2
ffffffffc0204d9a:	06f99f63          	bne	s3,a5,ffffffffc0204e18 <file_write+0xbe>
ffffffffc0204d9e:	4c1c                	lw	a5,24(s0)
ffffffffc0204da0:	06a79c63          	bne	a5,a0,ffffffffc0204e18 <file_write+0xbe>
ffffffffc0204da4:	681c                	ld	a5,16(s0)
ffffffffc0204da6:	cbad                	beqz	a5,ffffffffc0204e18 <file_write+0xbe>
ffffffffc0204da8:	581c                	lw	a5,48(s0)
ffffffffc0204daa:	8a36                	mv	s4,a3
ffffffffc0204dac:	7014                	ld	a3,32(s0)
ffffffffc0204dae:	2785                	addiw	a5,a5,1
ffffffffc0204db0:	850a                	mv	a0,sp
ffffffffc0204db2:	d81c                	sw	a5,48(s0)
ffffffffc0204db4:	6ac000ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc0204db8:	02843903          	ld	s2,40(s0)
ffffffffc0204dbc:	84aa                	mv	s1,a0
ffffffffc0204dbe:	06090163          	beqz	s2,ffffffffc0204e20 <file_write+0xc6>
ffffffffc0204dc2:	07093783          	ld	a5,112(s2)
ffffffffc0204dc6:	cfa9                	beqz	a5,ffffffffc0204e20 <file_write+0xc6>
ffffffffc0204dc8:	739c                	ld	a5,32(a5)
ffffffffc0204dca:	cbb9                	beqz	a5,ffffffffc0204e20 <file_write+0xc6>
ffffffffc0204dcc:	00008597          	auipc	a1,0x8
ffffffffc0204dd0:	58c58593          	addi	a1,a1,1420 # ffffffffc020d358 <default_pmm_manager+0xdf0>
ffffffffc0204dd4:	854a                	mv	a0,s2
ffffffffc0204dd6:	381020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0204dda:	07093783          	ld	a5,112(s2)
ffffffffc0204dde:	7408                	ld	a0,40(s0)
ffffffffc0204de0:	85a6                	mv	a1,s1
ffffffffc0204de2:	739c                	ld	a5,32(a5)
ffffffffc0204de4:	9782                	jalr	a5
ffffffffc0204de6:	689c                	ld	a5,16(s1)
ffffffffc0204de8:	6c94                	ld	a3,24(s1)
ffffffffc0204dea:	4018                	lw	a4,0(s0)
ffffffffc0204dec:	84aa                	mv	s1,a0
ffffffffc0204dee:	8f95                	sub	a5,a5,a3
ffffffffc0204df0:	03370063          	beq	a4,s3,ffffffffc0204e10 <file_write+0xb6>
ffffffffc0204df4:	00fa3023          	sd	a5,0(s4)
ffffffffc0204df8:	8522                	mv	a0,s0
ffffffffc0204dfa:	b29ff0ef          	jal	ra,ffffffffc0204922 <fd_array_release>
ffffffffc0204dfe:	60a6                	ld	ra,72(sp)
ffffffffc0204e00:	6406                	ld	s0,64(sp)
ffffffffc0204e02:	7942                	ld	s2,48(sp)
ffffffffc0204e04:	79a2                	ld	s3,40(sp)
ffffffffc0204e06:	7a02                	ld	s4,32(sp)
ffffffffc0204e08:	8526                	mv	a0,s1
ffffffffc0204e0a:	74e2                	ld	s1,56(sp)
ffffffffc0204e0c:	6161                	addi	sp,sp,80
ffffffffc0204e0e:	8082                	ret
ffffffffc0204e10:	7018                	ld	a4,32(s0)
ffffffffc0204e12:	973e                	add	a4,a4,a5
ffffffffc0204e14:	f018                	sd	a4,32(s0)
ffffffffc0204e16:	bff9                	j	ffffffffc0204df4 <file_write+0x9a>
ffffffffc0204e18:	54f5                	li	s1,-3
ffffffffc0204e1a:	b7d5                	j	ffffffffc0204dfe <file_write+0xa4>
ffffffffc0204e1c:	9d5ff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>
ffffffffc0204e20:	00008697          	auipc	a3,0x8
ffffffffc0204e24:	4e868693          	addi	a3,a3,1256 # ffffffffc020d308 <default_pmm_manager+0xda0>
ffffffffc0204e28:	00007617          	auipc	a2,0x7
ffffffffc0204e2c:	c5860613          	addi	a2,a2,-936 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204e30:	0f800593          	li	a1,248
ffffffffc0204e34:	00008517          	auipc	a0,0x8
ffffffffc0204e38:	2ec50513          	addi	a0,a0,748 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204e3c:	e62fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204e40 <file_seek>:
ffffffffc0204e40:	7139                	addi	sp,sp,-64
ffffffffc0204e42:	fc06                	sd	ra,56(sp)
ffffffffc0204e44:	f822                	sd	s0,48(sp)
ffffffffc0204e46:	f426                	sd	s1,40(sp)
ffffffffc0204e48:	f04a                	sd	s2,32(sp)
ffffffffc0204e4a:	04700793          	li	a5,71
ffffffffc0204e4e:	08a7e863          	bltu	a5,a0,ffffffffc0204ede <file_seek+0x9e>
ffffffffc0204e52:	00092797          	auipc	a5,0x92
ffffffffc0204e56:	a6e7b783          	ld	a5,-1426(a5) # ffffffffc02968c0 <current>
ffffffffc0204e5a:	1487b783          	ld	a5,328(a5)
ffffffffc0204e5e:	cfdd                	beqz	a5,ffffffffc0204f1c <file_seek+0xdc>
ffffffffc0204e60:	4b98                	lw	a4,16(a5)
ffffffffc0204e62:	0ae05d63          	blez	a4,ffffffffc0204f1c <file_seek+0xdc>
ffffffffc0204e66:	6780                	ld	s0,8(a5)
ffffffffc0204e68:	00351793          	slli	a5,a0,0x3
ffffffffc0204e6c:	8f89                	sub	a5,a5,a0
ffffffffc0204e6e:	078e                	slli	a5,a5,0x3
ffffffffc0204e70:	943e                	add	s0,s0,a5
ffffffffc0204e72:	4018                	lw	a4,0(s0)
ffffffffc0204e74:	4789                	li	a5,2
ffffffffc0204e76:	06f71463          	bne	a4,a5,ffffffffc0204ede <file_seek+0x9e>
ffffffffc0204e7a:	4c1c                	lw	a5,24(s0)
ffffffffc0204e7c:	06a79163          	bne	a5,a0,ffffffffc0204ede <file_seek+0x9e>
ffffffffc0204e80:	581c                	lw	a5,48(s0)
ffffffffc0204e82:	4685                	li	a3,1
ffffffffc0204e84:	892e                	mv	s2,a1
ffffffffc0204e86:	2785                	addiw	a5,a5,1
ffffffffc0204e88:	d81c                	sw	a5,48(s0)
ffffffffc0204e8a:	02d60063          	beq	a2,a3,ffffffffc0204eaa <file_seek+0x6a>
ffffffffc0204e8e:	06e60063          	beq	a2,a4,ffffffffc0204eee <file_seek+0xae>
ffffffffc0204e92:	54f5                	li	s1,-3
ffffffffc0204e94:	ce11                	beqz	a2,ffffffffc0204eb0 <file_seek+0x70>
ffffffffc0204e96:	8522                	mv	a0,s0
ffffffffc0204e98:	a8bff0ef          	jal	ra,ffffffffc0204922 <fd_array_release>
ffffffffc0204e9c:	70e2                	ld	ra,56(sp)
ffffffffc0204e9e:	7442                	ld	s0,48(sp)
ffffffffc0204ea0:	7902                	ld	s2,32(sp)
ffffffffc0204ea2:	8526                	mv	a0,s1
ffffffffc0204ea4:	74a2                	ld	s1,40(sp)
ffffffffc0204ea6:	6121                	addi	sp,sp,64
ffffffffc0204ea8:	8082                	ret
ffffffffc0204eaa:	701c                	ld	a5,32(s0)
ffffffffc0204eac:	00f58933          	add	s2,a1,a5
ffffffffc0204eb0:	7404                	ld	s1,40(s0)
ffffffffc0204eb2:	c4bd                	beqz	s1,ffffffffc0204f20 <file_seek+0xe0>
ffffffffc0204eb4:	78bc                	ld	a5,112(s1)
ffffffffc0204eb6:	c7ad                	beqz	a5,ffffffffc0204f20 <file_seek+0xe0>
ffffffffc0204eb8:	6fbc                	ld	a5,88(a5)
ffffffffc0204eba:	c3bd                	beqz	a5,ffffffffc0204f20 <file_seek+0xe0>
ffffffffc0204ebc:	8526                	mv	a0,s1
ffffffffc0204ebe:	00008597          	auipc	a1,0x8
ffffffffc0204ec2:	4f258593          	addi	a1,a1,1266 # ffffffffc020d3b0 <default_pmm_manager+0xe48>
ffffffffc0204ec6:	291020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0204eca:	78bc                	ld	a5,112(s1)
ffffffffc0204ecc:	7408                	ld	a0,40(s0)
ffffffffc0204ece:	85ca                	mv	a1,s2
ffffffffc0204ed0:	6fbc                	ld	a5,88(a5)
ffffffffc0204ed2:	9782                	jalr	a5
ffffffffc0204ed4:	84aa                	mv	s1,a0
ffffffffc0204ed6:	f161                	bnez	a0,ffffffffc0204e96 <file_seek+0x56>
ffffffffc0204ed8:	03243023          	sd	s2,32(s0)
ffffffffc0204edc:	bf6d                	j	ffffffffc0204e96 <file_seek+0x56>
ffffffffc0204ede:	70e2                	ld	ra,56(sp)
ffffffffc0204ee0:	7442                	ld	s0,48(sp)
ffffffffc0204ee2:	54f5                	li	s1,-3
ffffffffc0204ee4:	7902                	ld	s2,32(sp)
ffffffffc0204ee6:	8526                	mv	a0,s1
ffffffffc0204ee8:	74a2                	ld	s1,40(sp)
ffffffffc0204eea:	6121                	addi	sp,sp,64
ffffffffc0204eec:	8082                	ret
ffffffffc0204eee:	7404                	ld	s1,40(s0)
ffffffffc0204ef0:	c8a1                	beqz	s1,ffffffffc0204f40 <file_seek+0x100>
ffffffffc0204ef2:	78bc                	ld	a5,112(s1)
ffffffffc0204ef4:	c7b1                	beqz	a5,ffffffffc0204f40 <file_seek+0x100>
ffffffffc0204ef6:	779c                	ld	a5,40(a5)
ffffffffc0204ef8:	c7a1                	beqz	a5,ffffffffc0204f40 <file_seek+0x100>
ffffffffc0204efa:	8526                	mv	a0,s1
ffffffffc0204efc:	00008597          	auipc	a1,0x8
ffffffffc0204f00:	3ac58593          	addi	a1,a1,940 # ffffffffc020d2a8 <default_pmm_manager+0xd40>
ffffffffc0204f04:	253020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0204f08:	78bc                	ld	a5,112(s1)
ffffffffc0204f0a:	7408                	ld	a0,40(s0)
ffffffffc0204f0c:	858a                	mv	a1,sp
ffffffffc0204f0e:	779c                	ld	a5,40(a5)
ffffffffc0204f10:	9782                	jalr	a5
ffffffffc0204f12:	84aa                	mv	s1,a0
ffffffffc0204f14:	f149                	bnez	a0,ffffffffc0204e96 <file_seek+0x56>
ffffffffc0204f16:	67e2                	ld	a5,24(sp)
ffffffffc0204f18:	993e                	add	s2,s2,a5
ffffffffc0204f1a:	bf59                	j	ffffffffc0204eb0 <file_seek+0x70>
ffffffffc0204f1c:	8d5ff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>
ffffffffc0204f20:	00008697          	auipc	a3,0x8
ffffffffc0204f24:	44068693          	addi	a3,a3,1088 # ffffffffc020d360 <default_pmm_manager+0xdf8>
ffffffffc0204f28:	00007617          	auipc	a2,0x7
ffffffffc0204f2c:	b5860613          	addi	a2,a2,-1192 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204f30:	11a00593          	li	a1,282
ffffffffc0204f34:	00008517          	auipc	a0,0x8
ffffffffc0204f38:	1ec50513          	addi	a0,a0,492 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204f3c:	d62fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0204f40:	00008697          	auipc	a3,0x8
ffffffffc0204f44:	31868693          	addi	a3,a3,792 # ffffffffc020d258 <default_pmm_manager+0xcf0>
ffffffffc0204f48:	00007617          	auipc	a2,0x7
ffffffffc0204f4c:	b3860613          	addi	a2,a2,-1224 # ffffffffc020ba80 <commands+0x210>
ffffffffc0204f50:	11200593          	li	a1,274
ffffffffc0204f54:	00008517          	auipc	a0,0x8
ffffffffc0204f58:	1cc50513          	addi	a0,a0,460 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0204f5c:	d42fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0204f60 <file_fstat>:
ffffffffc0204f60:	1101                	addi	sp,sp,-32
ffffffffc0204f62:	ec06                	sd	ra,24(sp)
ffffffffc0204f64:	e822                	sd	s0,16(sp)
ffffffffc0204f66:	e426                	sd	s1,8(sp)
ffffffffc0204f68:	e04a                	sd	s2,0(sp)
ffffffffc0204f6a:	04700793          	li	a5,71
ffffffffc0204f6e:	06a7ef63          	bltu	a5,a0,ffffffffc0204fec <file_fstat+0x8c>
ffffffffc0204f72:	00092797          	auipc	a5,0x92
ffffffffc0204f76:	94e7b783          	ld	a5,-1714(a5) # ffffffffc02968c0 <current>
ffffffffc0204f7a:	1487b783          	ld	a5,328(a5)
ffffffffc0204f7e:	cfd9                	beqz	a5,ffffffffc020501c <file_fstat+0xbc>
ffffffffc0204f80:	4b98                	lw	a4,16(a5)
ffffffffc0204f82:	08e05d63          	blez	a4,ffffffffc020501c <file_fstat+0xbc>
ffffffffc0204f86:	6780                	ld	s0,8(a5)
ffffffffc0204f88:	00351793          	slli	a5,a0,0x3
ffffffffc0204f8c:	8f89                	sub	a5,a5,a0
ffffffffc0204f8e:	078e                	slli	a5,a5,0x3
ffffffffc0204f90:	943e                	add	s0,s0,a5
ffffffffc0204f92:	4018                	lw	a4,0(s0)
ffffffffc0204f94:	4789                	li	a5,2
ffffffffc0204f96:	04f71b63          	bne	a4,a5,ffffffffc0204fec <file_fstat+0x8c>
ffffffffc0204f9a:	4c1c                	lw	a5,24(s0)
ffffffffc0204f9c:	04a79863          	bne	a5,a0,ffffffffc0204fec <file_fstat+0x8c>
ffffffffc0204fa0:	581c                	lw	a5,48(s0)
ffffffffc0204fa2:	02843903          	ld	s2,40(s0)
ffffffffc0204fa6:	2785                	addiw	a5,a5,1
ffffffffc0204fa8:	d81c                	sw	a5,48(s0)
ffffffffc0204faa:	04090963          	beqz	s2,ffffffffc0204ffc <file_fstat+0x9c>
ffffffffc0204fae:	07093783          	ld	a5,112(s2)
ffffffffc0204fb2:	c7a9                	beqz	a5,ffffffffc0204ffc <file_fstat+0x9c>
ffffffffc0204fb4:	779c                	ld	a5,40(a5)
ffffffffc0204fb6:	c3b9                	beqz	a5,ffffffffc0204ffc <file_fstat+0x9c>
ffffffffc0204fb8:	84ae                	mv	s1,a1
ffffffffc0204fba:	854a                	mv	a0,s2
ffffffffc0204fbc:	00008597          	auipc	a1,0x8
ffffffffc0204fc0:	2ec58593          	addi	a1,a1,748 # ffffffffc020d2a8 <default_pmm_manager+0xd40>
ffffffffc0204fc4:	193020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0204fc8:	07093783          	ld	a5,112(s2)
ffffffffc0204fcc:	7408                	ld	a0,40(s0)
ffffffffc0204fce:	85a6                	mv	a1,s1
ffffffffc0204fd0:	779c                	ld	a5,40(a5)
ffffffffc0204fd2:	9782                	jalr	a5
ffffffffc0204fd4:	87aa                	mv	a5,a0
ffffffffc0204fd6:	8522                	mv	a0,s0
ffffffffc0204fd8:	843e                	mv	s0,a5
ffffffffc0204fda:	949ff0ef          	jal	ra,ffffffffc0204922 <fd_array_release>
ffffffffc0204fde:	60e2                	ld	ra,24(sp)
ffffffffc0204fe0:	8522                	mv	a0,s0
ffffffffc0204fe2:	6442                	ld	s0,16(sp)
ffffffffc0204fe4:	64a2                	ld	s1,8(sp)
ffffffffc0204fe6:	6902                	ld	s2,0(sp)
ffffffffc0204fe8:	6105                	addi	sp,sp,32
ffffffffc0204fea:	8082                	ret
ffffffffc0204fec:	5475                	li	s0,-3
ffffffffc0204fee:	60e2                	ld	ra,24(sp)
ffffffffc0204ff0:	8522                	mv	a0,s0
ffffffffc0204ff2:	6442                	ld	s0,16(sp)
ffffffffc0204ff4:	64a2                	ld	s1,8(sp)
ffffffffc0204ff6:	6902                	ld	s2,0(sp)
ffffffffc0204ff8:	6105                	addi	sp,sp,32
ffffffffc0204ffa:	8082                	ret
ffffffffc0204ffc:	00008697          	auipc	a3,0x8
ffffffffc0205000:	25c68693          	addi	a3,a3,604 # ffffffffc020d258 <default_pmm_manager+0xcf0>
ffffffffc0205004:	00007617          	auipc	a2,0x7
ffffffffc0205008:	a7c60613          	addi	a2,a2,-1412 # ffffffffc020ba80 <commands+0x210>
ffffffffc020500c:	12c00593          	li	a1,300
ffffffffc0205010:	00008517          	auipc	a0,0x8
ffffffffc0205014:	11050513          	addi	a0,a0,272 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc0205018:	c86fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020501c:	fd4ff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>

ffffffffc0205020 <file_fsync>:
ffffffffc0205020:	1101                	addi	sp,sp,-32
ffffffffc0205022:	ec06                	sd	ra,24(sp)
ffffffffc0205024:	e822                	sd	s0,16(sp)
ffffffffc0205026:	e426                	sd	s1,8(sp)
ffffffffc0205028:	04700793          	li	a5,71
ffffffffc020502c:	06a7e863          	bltu	a5,a0,ffffffffc020509c <file_fsync+0x7c>
ffffffffc0205030:	00092797          	auipc	a5,0x92
ffffffffc0205034:	8907b783          	ld	a5,-1904(a5) # ffffffffc02968c0 <current>
ffffffffc0205038:	1487b783          	ld	a5,328(a5)
ffffffffc020503c:	c7d9                	beqz	a5,ffffffffc02050ca <file_fsync+0xaa>
ffffffffc020503e:	4b98                	lw	a4,16(a5)
ffffffffc0205040:	08e05563          	blez	a4,ffffffffc02050ca <file_fsync+0xaa>
ffffffffc0205044:	6780                	ld	s0,8(a5)
ffffffffc0205046:	00351793          	slli	a5,a0,0x3
ffffffffc020504a:	8f89                	sub	a5,a5,a0
ffffffffc020504c:	078e                	slli	a5,a5,0x3
ffffffffc020504e:	943e                	add	s0,s0,a5
ffffffffc0205050:	4018                	lw	a4,0(s0)
ffffffffc0205052:	4789                	li	a5,2
ffffffffc0205054:	04f71463          	bne	a4,a5,ffffffffc020509c <file_fsync+0x7c>
ffffffffc0205058:	4c1c                	lw	a5,24(s0)
ffffffffc020505a:	04a79163          	bne	a5,a0,ffffffffc020509c <file_fsync+0x7c>
ffffffffc020505e:	581c                	lw	a5,48(s0)
ffffffffc0205060:	7404                	ld	s1,40(s0)
ffffffffc0205062:	2785                	addiw	a5,a5,1
ffffffffc0205064:	d81c                	sw	a5,48(s0)
ffffffffc0205066:	c0b1                	beqz	s1,ffffffffc02050aa <file_fsync+0x8a>
ffffffffc0205068:	78bc                	ld	a5,112(s1)
ffffffffc020506a:	c3a1                	beqz	a5,ffffffffc02050aa <file_fsync+0x8a>
ffffffffc020506c:	7b9c                	ld	a5,48(a5)
ffffffffc020506e:	cf95                	beqz	a5,ffffffffc02050aa <file_fsync+0x8a>
ffffffffc0205070:	00008597          	auipc	a1,0x8
ffffffffc0205074:	39858593          	addi	a1,a1,920 # ffffffffc020d408 <default_pmm_manager+0xea0>
ffffffffc0205078:	8526                	mv	a0,s1
ffffffffc020507a:	0dd020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc020507e:	78bc                	ld	a5,112(s1)
ffffffffc0205080:	7408                	ld	a0,40(s0)
ffffffffc0205082:	7b9c                	ld	a5,48(a5)
ffffffffc0205084:	9782                	jalr	a5
ffffffffc0205086:	87aa                	mv	a5,a0
ffffffffc0205088:	8522                	mv	a0,s0
ffffffffc020508a:	843e                	mv	s0,a5
ffffffffc020508c:	897ff0ef          	jal	ra,ffffffffc0204922 <fd_array_release>
ffffffffc0205090:	60e2                	ld	ra,24(sp)
ffffffffc0205092:	8522                	mv	a0,s0
ffffffffc0205094:	6442                	ld	s0,16(sp)
ffffffffc0205096:	64a2                	ld	s1,8(sp)
ffffffffc0205098:	6105                	addi	sp,sp,32
ffffffffc020509a:	8082                	ret
ffffffffc020509c:	5475                	li	s0,-3
ffffffffc020509e:	60e2                	ld	ra,24(sp)
ffffffffc02050a0:	8522                	mv	a0,s0
ffffffffc02050a2:	6442                	ld	s0,16(sp)
ffffffffc02050a4:	64a2                	ld	s1,8(sp)
ffffffffc02050a6:	6105                	addi	sp,sp,32
ffffffffc02050a8:	8082                	ret
ffffffffc02050aa:	00008697          	auipc	a3,0x8
ffffffffc02050ae:	30e68693          	addi	a3,a3,782 # ffffffffc020d3b8 <default_pmm_manager+0xe50>
ffffffffc02050b2:	00007617          	auipc	a2,0x7
ffffffffc02050b6:	9ce60613          	addi	a2,a2,-1586 # ffffffffc020ba80 <commands+0x210>
ffffffffc02050ba:	13a00593          	li	a1,314
ffffffffc02050be:	00008517          	auipc	a0,0x8
ffffffffc02050c2:	06250513          	addi	a0,a0,98 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc02050c6:	bd8fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02050ca:	f26ff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>

ffffffffc02050ce <file_getdirentry>:
ffffffffc02050ce:	715d                	addi	sp,sp,-80
ffffffffc02050d0:	e486                	sd	ra,72(sp)
ffffffffc02050d2:	e0a2                	sd	s0,64(sp)
ffffffffc02050d4:	fc26                	sd	s1,56(sp)
ffffffffc02050d6:	f84a                	sd	s2,48(sp)
ffffffffc02050d8:	f44e                	sd	s3,40(sp)
ffffffffc02050da:	04700793          	li	a5,71
ffffffffc02050de:	0aa7e063          	bltu	a5,a0,ffffffffc020517e <file_getdirentry+0xb0>
ffffffffc02050e2:	00091797          	auipc	a5,0x91
ffffffffc02050e6:	7de7b783          	ld	a5,2014(a5) # ffffffffc02968c0 <current>
ffffffffc02050ea:	1487b783          	ld	a5,328(a5)
ffffffffc02050ee:	c3e9                	beqz	a5,ffffffffc02051b0 <file_getdirentry+0xe2>
ffffffffc02050f0:	4b98                	lw	a4,16(a5)
ffffffffc02050f2:	0ae05f63          	blez	a4,ffffffffc02051b0 <file_getdirentry+0xe2>
ffffffffc02050f6:	6780                	ld	s0,8(a5)
ffffffffc02050f8:	00351793          	slli	a5,a0,0x3
ffffffffc02050fc:	8f89                	sub	a5,a5,a0
ffffffffc02050fe:	078e                	slli	a5,a5,0x3
ffffffffc0205100:	943e                	add	s0,s0,a5
ffffffffc0205102:	4018                	lw	a4,0(s0)
ffffffffc0205104:	4789                	li	a5,2
ffffffffc0205106:	06f71c63          	bne	a4,a5,ffffffffc020517e <file_getdirentry+0xb0>
ffffffffc020510a:	4c1c                	lw	a5,24(s0)
ffffffffc020510c:	06a79963          	bne	a5,a0,ffffffffc020517e <file_getdirentry+0xb0>
ffffffffc0205110:	581c                	lw	a5,48(s0)
ffffffffc0205112:	6194                	ld	a3,0(a1)
ffffffffc0205114:	84ae                	mv	s1,a1
ffffffffc0205116:	2785                	addiw	a5,a5,1
ffffffffc0205118:	10000613          	li	a2,256
ffffffffc020511c:	d81c                	sw	a5,48(s0)
ffffffffc020511e:	05a1                	addi	a1,a1,8
ffffffffc0205120:	850a                	mv	a0,sp
ffffffffc0205122:	33e000ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc0205126:	02843983          	ld	s3,40(s0)
ffffffffc020512a:	892a                	mv	s2,a0
ffffffffc020512c:	06098263          	beqz	s3,ffffffffc0205190 <file_getdirentry+0xc2>
ffffffffc0205130:	0709b783          	ld	a5,112(s3) # 1070 <_binary_bin_swap_img_size-0x6c90>
ffffffffc0205134:	cfb1                	beqz	a5,ffffffffc0205190 <file_getdirentry+0xc2>
ffffffffc0205136:	63bc                	ld	a5,64(a5)
ffffffffc0205138:	cfa1                	beqz	a5,ffffffffc0205190 <file_getdirentry+0xc2>
ffffffffc020513a:	854e                	mv	a0,s3
ffffffffc020513c:	00008597          	auipc	a1,0x8
ffffffffc0205140:	32c58593          	addi	a1,a1,812 # ffffffffc020d468 <default_pmm_manager+0xf00>
ffffffffc0205144:	013020ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0205148:	0709b783          	ld	a5,112(s3)
ffffffffc020514c:	7408                	ld	a0,40(s0)
ffffffffc020514e:	85ca                	mv	a1,s2
ffffffffc0205150:	63bc                	ld	a5,64(a5)
ffffffffc0205152:	9782                	jalr	a5
ffffffffc0205154:	89aa                	mv	s3,a0
ffffffffc0205156:	e909                	bnez	a0,ffffffffc0205168 <file_getdirentry+0x9a>
ffffffffc0205158:	609c                	ld	a5,0(s1)
ffffffffc020515a:	01093683          	ld	a3,16(s2)
ffffffffc020515e:	01893703          	ld	a4,24(s2)
ffffffffc0205162:	97b6                	add	a5,a5,a3
ffffffffc0205164:	8f99                	sub	a5,a5,a4
ffffffffc0205166:	e09c                	sd	a5,0(s1)
ffffffffc0205168:	8522                	mv	a0,s0
ffffffffc020516a:	fb8ff0ef          	jal	ra,ffffffffc0204922 <fd_array_release>
ffffffffc020516e:	60a6                	ld	ra,72(sp)
ffffffffc0205170:	6406                	ld	s0,64(sp)
ffffffffc0205172:	74e2                	ld	s1,56(sp)
ffffffffc0205174:	7942                	ld	s2,48(sp)
ffffffffc0205176:	854e                	mv	a0,s3
ffffffffc0205178:	79a2                	ld	s3,40(sp)
ffffffffc020517a:	6161                	addi	sp,sp,80
ffffffffc020517c:	8082                	ret
ffffffffc020517e:	60a6                	ld	ra,72(sp)
ffffffffc0205180:	6406                	ld	s0,64(sp)
ffffffffc0205182:	59f5                	li	s3,-3
ffffffffc0205184:	74e2                	ld	s1,56(sp)
ffffffffc0205186:	7942                	ld	s2,48(sp)
ffffffffc0205188:	854e                	mv	a0,s3
ffffffffc020518a:	79a2                	ld	s3,40(sp)
ffffffffc020518c:	6161                	addi	sp,sp,80
ffffffffc020518e:	8082                	ret
ffffffffc0205190:	00008697          	auipc	a3,0x8
ffffffffc0205194:	28068693          	addi	a3,a3,640 # ffffffffc020d410 <default_pmm_manager+0xea8>
ffffffffc0205198:	00007617          	auipc	a2,0x7
ffffffffc020519c:	8e860613          	addi	a2,a2,-1816 # ffffffffc020ba80 <commands+0x210>
ffffffffc02051a0:	14a00593          	li	a1,330
ffffffffc02051a4:	00008517          	auipc	a0,0x8
ffffffffc02051a8:	f7c50513          	addi	a0,a0,-132 # ffffffffc020d120 <default_pmm_manager+0xbb8>
ffffffffc02051ac:	af2fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02051b0:	e40ff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>

ffffffffc02051b4 <file_dup>:
ffffffffc02051b4:	04700713          	li	a4,71
ffffffffc02051b8:	06a76463          	bltu	a4,a0,ffffffffc0205220 <file_dup+0x6c>
ffffffffc02051bc:	00091717          	auipc	a4,0x91
ffffffffc02051c0:	70473703          	ld	a4,1796(a4) # ffffffffc02968c0 <current>
ffffffffc02051c4:	14873703          	ld	a4,328(a4)
ffffffffc02051c8:	1101                	addi	sp,sp,-32
ffffffffc02051ca:	ec06                	sd	ra,24(sp)
ffffffffc02051cc:	e822                	sd	s0,16(sp)
ffffffffc02051ce:	cb39                	beqz	a4,ffffffffc0205224 <file_dup+0x70>
ffffffffc02051d0:	4b14                	lw	a3,16(a4)
ffffffffc02051d2:	04d05963          	blez	a3,ffffffffc0205224 <file_dup+0x70>
ffffffffc02051d6:	6700                	ld	s0,8(a4)
ffffffffc02051d8:	00351713          	slli	a4,a0,0x3
ffffffffc02051dc:	8f09                	sub	a4,a4,a0
ffffffffc02051de:	070e                	slli	a4,a4,0x3
ffffffffc02051e0:	943a                	add	s0,s0,a4
ffffffffc02051e2:	4014                	lw	a3,0(s0)
ffffffffc02051e4:	4709                	li	a4,2
ffffffffc02051e6:	02e69863          	bne	a3,a4,ffffffffc0205216 <file_dup+0x62>
ffffffffc02051ea:	4c18                	lw	a4,24(s0)
ffffffffc02051ec:	02a71563          	bne	a4,a0,ffffffffc0205216 <file_dup+0x62>
ffffffffc02051f0:	852e                	mv	a0,a1
ffffffffc02051f2:	002c                	addi	a1,sp,8
ffffffffc02051f4:	e1eff0ef          	jal	ra,ffffffffc0204812 <fd_array_alloc>
ffffffffc02051f8:	c509                	beqz	a0,ffffffffc0205202 <file_dup+0x4e>
ffffffffc02051fa:	60e2                	ld	ra,24(sp)
ffffffffc02051fc:	6442                	ld	s0,16(sp)
ffffffffc02051fe:	6105                	addi	sp,sp,32
ffffffffc0205200:	8082                	ret
ffffffffc0205202:	6522                	ld	a0,8(sp)
ffffffffc0205204:	85a2                	mv	a1,s0
ffffffffc0205206:	845ff0ef          	jal	ra,ffffffffc0204a4a <fd_array_dup>
ffffffffc020520a:	67a2                	ld	a5,8(sp)
ffffffffc020520c:	60e2                	ld	ra,24(sp)
ffffffffc020520e:	6442                	ld	s0,16(sp)
ffffffffc0205210:	4f88                	lw	a0,24(a5)
ffffffffc0205212:	6105                	addi	sp,sp,32
ffffffffc0205214:	8082                	ret
ffffffffc0205216:	60e2                	ld	ra,24(sp)
ffffffffc0205218:	6442                	ld	s0,16(sp)
ffffffffc020521a:	5575                	li	a0,-3
ffffffffc020521c:	6105                	addi	sp,sp,32
ffffffffc020521e:	8082                	ret
ffffffffc0205220:	5575                	li	a0,-3
ffffffffc0205222:	8082                	ret
ffffffffc0205224:	dccff0ef          	jal	ra,ffffffffc02047f0 <get_fd_array.part.0>

ffffffffc0205228 <fs_init>:
ffffffffc0205228:	1141                	addi	sp,sp,-16
ffffffffc020522a:	e406                	sd	ra,8(sp)
ffffffffc020522c:	149020ef          	jal	ra,ffffffffc0207b74 <vfs_init>
ffffffffc0205230:	620030ef          	jal	ra,ffffffffc0208850 <dev_init>
ffffffffc0205234:	60a2                	ld	ra,8(sp)
ffffffffc0205236:	0141                	addi	sp,sp,16
ffffffffc0205238:	7710306f          	j	ffffffffc02091a8 <sfs_init>

ffffffffc020523c <fs_cleanup>:
ffffffffc020523c:	38b0206f          	j	ffffffffc0207dc6 <vfs_cleanup>

ffffffffc0205240 <lock_files>:
ffffffffc0205240:	0561                	addi	a0,a0,24
ffffffffc0205242:	ba0ff06f          	j	ffffffffc02045e2 <down>

ffffffffc0205246 <unlock_files>:
ffffffffc0205246:	0561                	addi	a0,a0,24
ffffffffc0205248:	b96ff06f          	j	ffffffffc02045de <up>

ffffffffc020524c <files_create>:
ffffffffc020524c:	1141                	addi	sp,sp,-16
ffffffffc020524e:	6505                	lui	a0,0x1
ffffffffc0205250:	e022                	sd	s0,0(sp)
ffffffffc0205252:	e406                	sd	ra,8(sp)
ffffffffc0205254:	d3bfc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0205258:	842a                	mv	s0,a0
ffffffffc020525a:	cd19                	beqz	a0,ffffffffc0205278 <files_create+0x2c>
ffffffffc020525c:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc0205260:	00043023          	sd	zero,0(s0)
ffffffffc0205264:	0561                	addi	a0,a0,24
ffffffffc0205266:	e41c                	sd	a5,8(s0)
ffffffffc0205268:	00042823          	sw	zero,16(s0)
ffffffffc020526c:	4585                	li	a1,1
ffffffffc020526e:	b6aff0ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc0205272:	6408                	ld	a0,8(s0)
ffffffffc0205274:	f3cff0ef          	jal	ra,ffffffffc02049b0 <fd_array_init>
ffffffffc0205278:	60a2                	ld	ra,8(sp)
ffffffffc020527a:	8522                	mv	a0,s0
ffffffffc020527c:	6402                	ld	s0,0(sp)
ffffffffc020527e:	0141                	addi	sp,sp,16
ffffffffc0205280:	8082                	ret

ffffffffc0205282 <files_destroy>:
ffffffffc0205282:	7179                	addi	sp,sp,-48
ffffffffc0205284:	f406                	sd	ra,40(sp)
ffffffffc0205286:	f022                	sd	s0,32(sp)
ffffffffc0205288:	ec26                	sd	s1,24(sp)
ffffffffc020528a:	e84a                	sd	s2,16(sp)
ffffffffc020528c:	e44e                	sd	s3,8(sp)
ffffffffc020528e:	c52d                	beqz	a0,ffffffffc02052f8 <files_destroy+0x76>
ffffffffc0205290:	491c                	lw	a5,16(a0)
ffffffffc0205292:	89aa                	mv	s3,a0
ffffffffc0205294:	e3b5                	bnez	a5,ffffffffc02052f8 <files_destroy+0x76>
ffffffffc0205296:	6108                	ld	a0,0(a0)
ffffffffc0205298:	c119                	beqz	a0,ffffffffc020529e <files_destroy+0x1c>
ffffffffc020529a:	772020ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020529e:	0089b403          	ld	s0,8(s3)
ffffffffc02052a2:	6485                	lui	s1,0x1
ffffffffc02052a4:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02052a8:	94a2                	add	s1,s1,s0
ffffffffc02052aa:	4909                	li	s2,2
ffffffffc02052ac:	401c                	lw	a5,0(s0)
ffffffffc02052ae:	03278063          	beq	a5,s2,ffffffffc02052ce <files_destroy+0x4c>
ffffffffc02052b2:	e39d                	bnez	a5,ffffffffc02052d8 <files_destroy+0x56>
ffffffffc02052b4:	03840413          	addi	s0,s0,56
ffffffffc02052b8:	fe849ae3          	bne	s1,s0,ffffffffc02052ac <files_destroy+0x2a>
ffffffffc02052bc:	7402                	ld	s0,32(sp)
ffffffffc02052be:	70a2                	ld	ra,40(sp)
ffffffffc02052c0:	64e2                	ld	s1,24(sp)
ffffffffc02052c2:	6942                	ld	s2,16(sp)
ffffffffc02052c4:	854e                	mv	a0,s3
ffffffffc02052c6:	69a2                	ld	s3,8(sp)
ffffffffc02052c8:	6145                	addi	sp,sp,48
ffffffffc02052ca:	d75fc06f          	j	ffffffffc020203e <kfree>
ffffffffc02052ce:	8522                	mv	a0,s0
ffffffffc02052d0:	efcff0ef          	jal	ra,ffffffffc02049cc <fd_array_close>
ffffffffc02052d4:	401c                	lw	a5,0(s0)
ffffffffc02052d6:	bff1                	j	ffffffffc02052b2 <files_destroy+0x30>
ffffffffc02052d8:	00008697          	auipc	a3,0x8
ffffffffc02052dc:	21068693          	addi	a3,a3,528 # ffffffffc020d4e8 <CSWTCH.79+0x58>
ffffffffc02052e0:	00006617          	auipc	a2,0x6
ffffffffc02052e4:	7a060613          	addi	a2,a2,1952 # ffffffffc020ba80 <commands+0x210>
ffffffffc02052e8:	03d00593          	li	a1,61
ffffffffc02052ec:	00008517          	auipc	a0,0x8
ffffffffc02052f0:	1ec50513          	addi	a0,a0,492 # ffffffffc020d4d8 <CSWTCH.79+0x48>
ffffffffc02052f4:	9aafb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02052f8:	00008697          	auipc	a3,0x8
ffffffffc02052fc:	1b068693          	addi	a3,a3,432 # ffffffffc020d4a8 <CSWTCH.79+0x18>
ffffffffc0205300:	00006617          	auipc	a2,0x6
ffffffffc0205304:	78060613          	addi	a2,a2,1920 # ffffffffc020ba80 <commands+0x210>
ffffffffc0205308:	03300593          	li	a1,51
ffffffffc020530c:	00008517          	auipc	a0,0x8
ffffffffc0205310:	1cc50513          	addi	a0,a0,460 # ffffffffc020d4d8 <CSWTCH.79+0x48>
ffffffffc0205314:	98afb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205318 <files_closeall>:
ffffffffc0205318:	1101                	addi	sp,sp,-32
ffffffffc020531a:	ec06                	sd	ra,24(sp)
ffffffffc020531c:	e822                	sd	s0,16(sp)
ffffffffc020531e:	e426                	sd	s1,8(sp)
ffffffffc0205320:	e04a                	sd	s2,0(sp)
ffffffffc0205322:	c129                	beqz	a0,ffffffffc0205364 <files_closeall+0x4c>
ffffffffc0205324:	491c                	lw	a5,16(a0)
ffffffffc0205326:	02f05f63          	blez	a5,ffffffffc0205364 <files_closeall+0x4c>
ffffffffc020532a:	6504                	ld	s1,8(a0)
ffffffffc020532c:	6785                	lui	a5,0x1
ffffffffc020532e:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205332:	07048413          	addi	s0,s1,112
ffffffffc0205336:	4909                	li	s2,2
ffffffffc0205338:	94be                	add	s1,s1,a5
ffffffffc020533a:	a029                	j	ffffffffc0205344 <files_closeall+0x2c>
ffffffffc020533c:	03840413          	addi	s0,s0,56
ffffffffc0205340:	00848c63          	beq	s1,s0,ffffffffc0205358 <files_closeall+0x40>
ffffffffc0205344:	401c                	lw	a5,0(s0)
ffffffffc0205346:	ff279be3          	bne	a5,s2,ffffffffc020533c <files_closeall+0x24>
ffffffffc020534a:	8522                	mv	a0,s0
ffffffffc020534c:	03840413          	addi	s0,s0,56
ffffffffc0205350:	e7cff0ef          	jal	ra,ffffffffc02049cc <fd_array_close>
ffffffffc0205354:	fe8498e3          	bne	s1,s0,ffffffffc0205344 <files_closeall+0x2c>
ffffffffc0205358:	60e2                	ld	ra,24(sp)
ffffffffc020535a:	6442                	ld	s0,16(sp)
ffffffffc020535c:	64a2                	ld	s1,8(sp)
ffffffffc020535e:	6902                	ld	s2,0(sp)
ffffffffc0205360:	6105                	addi	sp,sp,32
ffffffffc0205362:	8082                	ret
ffffffffc0205364:	00008697          	auipc	a3,0x8
ffffffffc0205368:	d8c68693          	addi	a3,a3,-628 # ffffffffc020d0f0 <default_pmm_manager+0xb88>
ffffffffc020536c:	00006617          	auipc	a2,0x6
ffffffffc0205370:	71460613          	addi	a2,a2,1812 # ffffffffc020ba80 <commands+0x210>
ffffffffc0205374:	04500593          	li	a1,69
ffffffffc0205378:	00008517          	auipc	a0,0x8
ffffffffc020537c:	16050513          	addi	a0,a0,352 # ffffffffc020d4d8 <CSWTCH.79+0x48>
ffffffffc0205380:	91efb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205384 <dup_files>:
ffffffffc0205384:	7179                	addi	sp,sp,-48
ffffffffc0205386:	f406                	sd	ra,40(sp)
ffffffffc0205388:	f022                	sd	s0,32(sp)
ffffffffc020538a:	ec26                	sd	s1,24(sp)
ffffffffc020538c:	e84a                	sd	s2,16(sp)
ffffffffc020538e:	e44e                	sd	s3,8(sp)
ffffffffc0205390:	e052                	sd	s4,0(sp)
ffffffffc0205392:	c52d                	beqz	a0,ffffffffc02053fc <dup_files+0x78>
ffffffffc0205394:	842e                	mv	s0,a1
ffffffffc0205396:	c1bd                	beqz	a1,ffffffffc02053fc <dup_files+0x78>
ffffffffc0205398:	491c                	lw	a5,16(a0)
ffffffffc020539a:	84aa                	mv	s1,a0
ffffffffc020539c:	e3c1                	bnez	a5,ffffffffc020541c <dup_files+0x98>
ffffffffc020539e:	499c                	lw	a5,16(a1)
ffffffffc02053a0:	06f05e63          	blez	a5,ffffffffc020541c <dup_files+0x98>
ffffffffc02053a4:	6188                	ld	a0,0(a1)
ffffffffc02053a6:	e088                	sd	a0,0(s1)
ffffffffc02053a8:	c119                	beqz	a0,ffffffffc02053ae <dup_files+0x2a>
ffffffffc02053aa:	594020ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc02053ae:	6400                	ld	s0,8(s0)
ffffffffc02053b0:	6905                	lui	s2,0x1
ffffffffc02053b2:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02053b6:	6484                	ld	s1,8(s1)
ffffffffc02053b8:	9922                	add	s2,s2,s0
ffffffffc02053ba:	4989                	li	s3,2
ffffffffc02053bc:	4a05                	li	s4,1
ffffffffc02053be:	a039                	j	ffffffffc02053cc <dup_files+0x48>
ffffffffc02053c0:	03840413          	addi	s0,s0,56
ffffffffc02053c4:	03848493          	addi	s1,s1,56
ffffffffc02053c8:	02890163          	beq	s2,s0,ffffffffc02053ea <dup_files+0x66>
ffffffffc02053cc:	401c                	lw	a5,0(s0)
ffffffffc02053ce:	ff3799e3          	bne	a5,s3,ffffffffc02053c0 <dup_files+0x3c>
ffffffffc02053d2:	0144a023          	sw	s4,0(s1)
ffffffffc02053d6:	85a2                	mv	a1,s0
ffffffffc02053d8:	8526                	mv	a0,s1
ffffffffc02053da:	03840413          	addi	s0,s0,56
ffffffffc02053de:	e6cff0ef          	jal	ra,ffffffffc0204a4a <fd_array_dup>
ffffffffc02053e2:	03848493          	addi	s1,s1,56
ffffffffc02053e6:	fe8913e3          	bne	s2,s0,ffffffffc02053cc <dup_files+0x48>
ffffffffc02053ea:	70a2                	ld	ra,40(sp)
ffffffffc02053ec:	7402                	ld	s0,32(sp)
ffffffffc02053ee:	64e2                	ld	s1,24(sp)
ffffffffc02053f0:	6942                	ld	s2,16(sp)
ffffffffc02053f2:	69a2                	ld	s3,8(sp)
ffffffffc02053f4:	6a02                	ld	s4,0(sp)
ffffffffc02053f6:	4501                	li	a0,0
ffffffffc02053f8:	6145                	addi	sp,sp,48
ffffffffc02053fa:	8082                	ret
ffffffffc02053fc:	00008697          	auipc	a3,0x8
ffffffffc0205400:	a4468693          	addi	a3,a3,-1468 # ffffffffc020ce40 <default_pmm_manager+0x8d8>
ffffffffc0205404:	00006617          	auipc	a2,0x6
ffffffffc0205408:	67c60613          	addi	a2,a2,1660 # ffffffffc020ba80 <commands+0x210>
ffffffffc020540c:	05300593          	li	a1,83
ffffffffc0205410:	00008517          	auipc	a0,0x8
ffffffffc0205414:	0c850513          	addi	a0,a0,200 # ffffffffc020d4d8 <CSWTCH.79+0x48>
ffffffffc0205418:	886fb0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020541c:	00008697          	auipc	a3,0x8
ffffffffc0205420:	0e468693          	addi	a3,a3,228 # ffffffffc020d500 <CSWTCH.79+0x70>
ffffffffc0205424:	00006617          	auipc	a2,0x6
ffffffffc0205428:	65c60613          	addi	a2,a2,1628 # ffffffffc020ba80 <commands+0x210>
ffffffffc020542c:	05400593          	li	a1,84
ffffffffc0205430:	00008517          	auipc	a0,0x8
ffffffffc0205434:	0a850513          	addi	a0,a0,168 # ffffffffc020d4d8 <CSWTCH.79+0x48>
ffffffffc0205438:	866fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020543c <iobuf_skip.part.0>:
ffffffffc020543c:	1141                	addi	sp,sp,-16
ffffffffc020543e:	00008697          	auipc	a3,0x8
ffffffffc0205442:	0f268693          	addi	a3,a3,242 # ffffffffc020d530 <CSWTCH.79+0xa0>
ffffffffc0205446:	00006617          	auipc	a2,0x6
ffffffffc020544a:	63a60613          	addi	a2,a2,1594 # ffffffffc020ba80 <commands+0x210>
ffffffffc020544e:	04a00593          	li	a1,74
ffffffffc0205452:	00008517          	auipc	a0,0x8
ffffffffc0205456:	0f650513          	addi	a0,a0,246 # ffffffffc020d548 <CSWTCH.79+0xb8>
ffffffffc020545a:	e406                	sd	ra,8(sp)
ffffffffc020545c:	842fb0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205460 <iobuf_init>:
ffffffffc0205460:	e10c                	sd	a1,0(a0)
ffffffffc0205462:	e514                	sd	a3,8(a0)
ffffffffc0205464:	ed10                	sd	a2,24(a0)
ffffffffc0205466:	e910                	sd	a2,16(a0)
ffffffffc0205468:	8082                	ret

ffffffffc020546a <iobuf_move>:
ffffffffc020546a:	7179                	addi	sp,sp,-48
ffffffffc020546c:	ec26                	sd	s1,24(sp)
ffffffffc020546e:	6d04                	ld	s1,24(a0)
ffffffffc0205470:	f022                	sd	s0,32(sp)
ffffffffc0205472:	e84a                	sd	s2,16(sp)
ffffffffc0205474:	e44e                	sd	s3,8(sp)
ffffffffc0205476:	f406                	sd	ra,40(sp)
ffffffffc0205478:	842a                	mv	s0,a0
ffffffffc020547a:	8932                	mv	s2,a2
ffffffffc020547c:	852e                	mv	a0,a1
ffffffffc020547e:	89ba                	mv	s3,a4
ffffffffc0205480:	00967363          	bgeu	a2,s1,ffffffffc0205486 <iobuf_move+0x1c>
ffffffffc0205484:	84b2                	mv	s1,a2
ffffffffc0205486:	c495                	beqz	s1,ffffffffc02054b2 <iobuf_move+0x48>
ffffffffc0205488:	600c                	ld	a1,0(s0)
ffffffffc020548a:	c681                	beqz	a3,ffffffffc0205492 <iobuf_move+0x28>
ffffffffc020548c:	87ae                	mv	a5,a1
ffffffffc020548e:	85aa                	mv	a1,a0
ffffffffc0205490:	853e                	mv	a0,a5
ffffffffc0205492:	8626                	mv	a2,s1
ffffffffc0205494:	118060ef          	jal	ra,ffffffffc020b5ac <memmove>
ffffffffc0205498:	6c1c                	ld	a5,24(s0)
ffffffffc020549a:	0297ea63          	bltu	a5,s1,ffffffffc02054ce <iobuf_move+0x64>
ffffffffc020549e:	6014                	ld	a3,0(s0)
ffffffffc02054a0:	6418                	ld	a4,8(s0)
ffffffffc02054a2:	8f85                	sub	a5,a5,s1
ffffffffc02054a4:	96a6                	add	a3,a3,s1
ffffffffc02054a6:	9726                	add	a4,a4,s1
ffffffffc02054a8:	e014                	sd	a3,0(s0)
ffffffffc02054aa:	e418                	sd	a4,8(s0)
ffffffffc02054ac:	ec1c                	sd	a5,24(s0)
ffffffffc02054ae:	40990933          	sub	s2,s2,s1
ffffffffc02054b2:	00098463          	beqz	s3,ffffffffc02054ba <iobuf_move+0x50>
ffffffffc02054b6:	0099b023          	sd	s1,0(s3)
ffffffffc02054ba:	4501                	li	a0,0
ffffffffc02054bc:	00091b63          	bnez	s2,ffffffffc02054d2 <iobuf_move+0x68>
ffffffffc02054c0:	70a2                	ld	ra,40(sp)
ffffffffc02054c2:	7402                	ld	s0,32(sp)
ffffffffc02054c4:	64e2                	ld	s1,24(sp)
ffffffffc02054c6:	6942                	ld	s2,16(sp)
ffffffffc02054c8:	69a2                	ld	s3,8(sp)
ffffffffc02054ca:	6145                	addi	sp,sp,48
ffffffffc02054cc:	8082                	ret
ffffffffc02054ce:	f6fff0ef          	jal	ra,ffffffffc020543c <iobuf_skip.part.0>
ffffffffc02054d2:	5571                	li	a0,-4
ffffffffc02054d4:	b7f5                	j	ffffffffc02054c0 <iobuf_move+0x56>

ffffffffc02054d6 <iobuf_skip>:
ffffffffc02054d6:	6d1c                	ld	a5,24(a0)
ffffffffc02054d8:	00b7eb63          	bltu	a5,a1,ffffffffc02054ee <iobuf_skip+0x18>
ffffffffc02054dc:	6114                	ld	a3,0(a0)
ffffffffc02054de:	6518                	ld	a4,8(a0)
ffffffffc02054e0:	8f8d                	sub	a5,a5,a1
ffffffffc02054e2:	96ae                	add	a3,a3,a1
ffffffffc02054e4:	95ba                	add	a1,a1,a4
ffffffffc02054e6:	e114                	sd	a3,0(a0)
ffffffffc02054e8:	e50c                	sd	a1,8(a0)
ffffffffc02054ea:	ed1c                	sd	a5,24(a0)
ffffffffc02054ec:	8082                	ret
ffffffffc02054ee:	1141                	addi	sp,sp,-16
ffffffffc02054f0:	e406                	sd	ra,8(sp)
ffffffffc02054f2:	f4bff0ef          	jal	ra,ffffffffc020543c <iobuf_skip.part.0>

ffffffffc02054f6 <copy_path>:
ffffffffc02054f6:	7139                	addi	sp,sp,-64
ffffffffc02054f8:	f04a                	sd	s2,32(sp)
ffffffffc02054fa:	00091917          	auipc	s2,0x91
ffffffffc02054fe:	3c690913          	addi	s2,s2,966 # ffffffffc02968c0 <current>
ffffffffc0205502:	00093703          	ld	a4,0(s2)
ffffffffc0205506:	ec4e                	sd	s3,24(sp)
ffffffffc0205508:	89aa                	mv	s3,a0
ffffffffc020550a:	6505                	lui	a0,0x1
ffffffffc020550c:	f426                	sd	s1,40(sp)
ffffffffc020550e:	e852                	sd	s4,16(sp)
ffffffffc0205510:	fc06                	sd	ra,56(sp)
ffffffffc0205512:	f822                	sd	s0,48(sp)
ffffffffc0205514:	e456                	sd	s5,8(sp)
ffffffffc0205516:	02873a03          	ld	s4,40(a4)
ffffffffc020551a:	84ae                	mv	s1,a1
ffffffffc020551c:	a73fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0205520:	c141                	beqz	a0,ffffffffc02055a0 <copy_path+0xaa>
ffffffffc0205522:	842a                	mv	s0,a0
ffffffffc0205524:	040a0563          	beqz	s4,ffffffffc020556e <copy_path+0x78>
ffffffffc0205528:	038a0a93          	addi	s5,s4,56
ffffffffc020552c:	8556                	mv	a0,s5
ffffffffc020552e:	8b4ff0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0205532:	00093783          	ld	a5,0(s2)
ffffffffc0205536:	cba1                	beqz	a5,ffffffffc0205586 <copy_path+0x90>
ffffffffc0205538:	43dc                	lw	a5,4(a5)
ffffffffc020553a:	6685                	lui	a3,0x1
ffffffffc020553c:	8626                	mv	a2,s1
ffffffffc020553e:	04fa2823          	sw	a5,80(s4)
ffffffffc0205542:	85a2                	mv	a1,s0
ffffffffc0205544:	8552                	mv	a0,s4
ffffffffc0205546:	ec5fe0ef          	jal	ra,ffffffffc020440a <copy_string>
ffffffffc020554a:	c529                	beqz	a0,ffffffffc0205594 <copy_path+0x9e>
ffffffffc020554c:	8556                	mv	a0,s5
ffffffffc020554e:	890ff0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0205552:	040a2823          	sw	zero,80(s4)
ffffffffc0205556:	0089b023          	sd	s0,0(s3)
ffffffffc020555a:	4501                	li	a0,0
ffffffffc020555c:	70e2                	ld	ra,56(sp)
ffffffffc020555e:	7442                	ld	s0,48(sp)
ffffffffc0205560:	74a2                	ld	s1,40(sp)
ffffffffc0205562:	7902                	ld	s2,32(sp)
ffffffffc0205564:	69e2                	ld	s3,24(sp)
ffffffffc0205566:	6a42                	ld	s4,16(sp)
ffffffffc0205568:	6aa2                	ld	s5,8(sp)
ffffffffc020556a:	6121                	addi	sp,sp,64
ffffffffc020556c:	8082                	ret
ffffffffc020556e:	85aa                	mv	a1,a0
ffffffffc0205570:	6685                	lui	a3,0x1
ffffffffc0205572:	8626                	mv	a2,s1
ffffffffc0205574:	4501                	li	a0,0
ffffffffc0205576:	e95fe0ef          	jal	ra,ffffffffc020440a <copy_string>
ffffffffc020557a:	fd71                	bnez	a0,ffffffffc0205556 <copy_path+0x60>
ffffffffc020557c:	8522                	mv	a0,s0
ffffffffc020557e:	ac1fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205582:	5575                	li	a0,-3
ffffffffc0205584:	bfe1                	j	ffffffffc020555c <copy_path+0x66>
ffffffffc0205586:	6685                	lui	a3,0x1
ffffffffc0205588:	8626                	mv	a2,s1
ffffffffc020558a:	85a2                	mv	a1,s0
ffffffffc020558c:	8552                	mv	a0,s4
ffffffffc020558e:	e7dfe0ef          	jal	ra,ffffffffc020440a <copy_string>
ffffffffc0205592:	fd4d                	bnez	a0,ffffffffc020554c <copy_path+0x56>
ffffffffc0205594:	8556                	mv	a0,s5
ffffffffc0205596:	848ff0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020559a:	040a2823          	sw	zero,80(s4)
ffffffffc020559e:	bff9                	j	ffffffffc020557c <copy_path+0x86>
ffffffffc02055a0:	5571                	li	a0,-4
ffffffffc02055a2:	bf6d                	j	ffffffffc020555c <copy_path+0x66>

ffffffffc02055a4 <sysfile_open>:
ffffffffc02055a4:	7179                	addi	sp,sp,-48
ffffffffc02055a6:	872a                	mv	a4,a0
ffffffffc02055a8:	ec26                	sd	s1,24(sp)
ffffffffc02055aa:	0028                	addi	a0,sp,8
ffffffffc02055ac:	84ae                	mv	s1,a1
ffffffffc02055ae:	85ba                	mv	a1,a4
ffffffffc02055b0:	f022                	sd	s0,32(sp)
ffffffffc02055b2:	f406                	sd	ra,40(sp)
ffffffffc02055b4:	f43ff0ef          	jal	ra,ffffffffc02054f6 <copy_path>
ffffffffc02055b8:	842a                	mv	s0,a0
ffffffffc02055ba:	e909                	bnez	a0,ffffffffc02055cc <sysfile_open+0x28>
ffffffffc02055bc:	6522                	ld	a0,8(sp)
ffffffffc02055be:	85a6                	mv	a1,s1
ffffffffc02055c0:	d60ff0ef          	jal	ra,ffffffffc0204b20 <file_open>
ffffffffc02055c4:	842a                	mv	s0,a0
ffffffffc02055c6:	6522                	ld	a0,8(sp)
ffffffffc02055c8:	a77fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02055cc:	70a2                	ld	ra,40(sp)
ffffffffc02055ce:	8522                	mv	a0,s0
ffffffffc02055d0:	7402                	ld	s0,32(sp)
ffffffffc02055d2:	64e2                	ld	s1,24(sp)
ffffffffc02055d4:	6145                	addi	sp,sp,48
ffffffffc02055d6:	8082                	ret

ffffffffc02055d8 <sysfile_close>:
ffffffffc02055d8:	e46ff06f          	j	ffffffffc0204c1e <file_close>

ffffffffc02055dc <sysfile_read>:
ffffffffc02055dc:	7159                	addi	sp,sp,-112
ffffffffc02055de:	f0a2                	sd	s0,96(sp)
ffffffffc02055e0:	f486                	sd	ra,104(sp)
ffffffffc02055e2:	eca6                	sd	s1,88(sp)
ffffffffc02055e4:	e8ca                	sd	s2,80(sp)
ffffffffc02055e6:	e4ce                	sd	s3,72(sp)
ffffffffc02055e8:	e0d2                	sd	s4,64(sp)
ffffffffc02055ea:	fc56                	sd	s5,56(sp)
ffffffffc02055ec:	f85a                	sd	s6,48(sp)
ffffffffc02055ee:	f45e                	sd	s7,40(sp)
ffffffffc02055f0:	f062                	sd	s8,32(sp)
ffffffffc02055f2:	ec66                	sd	s9,24(sp)
ffffffffc02055f4:	4401                	li	s0,0
ffffffffc02055f6:	ee19                	bnez	a2,ffffffffc0205614 <sysfile_read+0x38>
ffffffffc02055f8:	70a6                	ld	ra,104(sp)
ffffffffc02055fa:	8522                	mv	a0,s0
ffffffffc02055fc:	7406                	ld	s0,96(sp)
ffffffffc02055fe:	64e6                	ld	s1,88(sp)
ffffffffc0205600:	6946                	ld	s2,80(sp)
ffffffffc0205602:	69a6                	ld	s3,72(sp)
ffffffffc0205604:	6a06                	ld	s4,64(sp)
ffffffffc0205606:	7ae2                	ld	s5,56(sp)
ffffffffc0205608:	7b42                	ld	s6,48(sp)
ffffffffc020560a:	7ba2                	ld	s7,40(sp)
ffffffffc020560c:	7c02                	ld	s8,32(sp)
ffffffffc020560e:	6ce2                	ld	s9,24(sp)
ffffffffc0205610:	6165                	addi	sp,sp,112
ffffffffc0205612:	8082                	ret
ffffffffc0205614:	00091c97          	auipc	s9,0x91
ffffffffc0205618:	2acc8c93          	addi	s9,s9,684 # ffffffffc02968c0 <current>
ffffffffc020561c:	000cb783          	ld	a5,0(s9)
ffffffffc0205620:	84b2                	mv	s1,a2
ffffffffc0205622:	8b2e                	mv	s6,a1
ffffffffc0205624:	4601                	li	a2,0
ffffffffc0205626:	4585                	li	a1,1
ffffffffc0205628:	0287b903          	ld	s2,40(a5)
ffffffffc020562c:	8aaa                	mv	s5,a0
ffffffffc020562e:	c9eff0ef          	jal	ra,ffffffffc0204acc <file_testfd>
ffffffffc0205632:	c959                	beqz	a0,ffffffffc02056c8 <sysfile_read+0xec>
ffffffffc0205634:	6505                	lui	a0,0x1
ffffffffc0205636:	959fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020563a:	89aa                	mv	s3,a0
ffffffffc020563c:	c941                	beqz	a0,ffffffffc02056cc <sysfile_read+0xf0>
ffffffffc020563e:	4b81                	li	s7,0
ffffffffc0205640:	6a05                	lui	s4,0x1
ffffffffc0205642:	03890c13          	addi	s8,s2,56
ffffffffc0205646:	0744ec63          	bltu	s1,s4,ffffffffc02056be <sysfile_read+0xe2>
ffffffffc020564a:	e452                	sd	s4,8(sp)
ffffffffc020564c:	6605                	lui	a2,0x1
ffffffffc020564e:	0034                	addi	a3,sp,8
ffffffffc0205650:	85ce                	mv	a1,s3
ffffffffc0205652:	8556                	mv	a0,s5
ffffffffc0205654:	e20ff0ef          	jal	ra,ffffffffc0204c74 <file_read>
ffffffffc0205658:	66a2                	ld	a3,8(sp)
ffffffffc020565a:	842a                	mv	s0,a0
ffffffffc020565c:	ca9d                	beqz	a3,ffffffffc0205692 <sysfile_read+0xb6>
ffffffffc020565e:	00090c63          	beqz	s2,ffffffffc0205676 <sysfile_read+0x9a>
ffffffffc0205662:	8562                	mv	a0,s8
ffffffffc0205664:	f7ffe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0205668:	000cb783          	ld	a5,0(s9)
ffffffffc020566c:	cfa1                	beqz	a5,ffffffffc02056c4 <sysfile_read+0xe8>
ffffffffc020566e:	43dc                	lw	a5,4(a5)
ffffffffc0205670:	66a2                	ld	a3,8(sp)
ffffffffc0205672:	04f92823          	sw	a5,80(s2)
ffffffffc0205676:	864e                	mv	a2,s3
ffffffffc0205678:	85da                	mv	a1,s6
ffffffffc020567a:	854a                	mv	a0,s2
ffffffffc020567c:	d5dfe0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc0205680:	c50d                	beqz	a0,ffffffffc02056aa <sysfile_read+0xce>
ffffffffc0205682:	67a2                	ld	a5,8(sp)
ffffffffc0205684:	04f4e663          	bltu	s1,a5,ffffffffc02056d0 <sysfile_read+0xf4>
ffffffffc0205688:	9b3e                	add	s6,s6,a5
ffffffffc020568a:	8c9d                	sub	s1,s1,a5
ffffffffc020568c:	9bbe                	add	s7,s7,a5
ffffffffc020568e:	02091263          	bnez	s2,ffffffffc02056b2 <sysfile_read+0xd6>
ffffffffc0205692:	e401                	bnez	s0,ffffffffc020569a <sysfile_read+0xbe>
ffffffffc0205694:	67a2                	ld	a5,8(sp)
ffffffffc0205696:	c391                	beqz	a5,ffffffffc020569a <sysfile_read+0xbe>
ffffffffc0205698:	f4dd                	bnez	s1,ffffffffc0205646 <sysfile_read+0x6a>
ffffffffc020569a:	854e                	mv	a0,s3
ffffffffc020569c:	9a3fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02056a0:	f40b8ce3          	beqz	s7,ffffffffc02055f8 <sysfile_read+0x1c>
ffffffffc02056a4:	000b841b          	sext.w	s0,s7
ffffffffc02056a8:	bf81                	j	ffffffffc02055f8 <sysfile_read+0x1c>
ffffffffc02056aa:	e011                	bnez	s0,ffffffffc02056ae <sysfile_read+0xd2>
ffffffffc02056ac:	5475                	li	s0,-3
ffffffffc02056ae:	fe0906e3          	beqz	s2,ffffffffc020569a <sysfile_read+0xbe>
ffffffffc02056b2:	8562                	mv	a0,s8
ffffffffc02056b4:	f2bfe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02056b8:	04092823          	sw	zero,80(s2)
ffffffffc02056bc:	bfd9                	j	ffffffffc0205692 <sysfile_read+0xb6>
ffffffffc02056be:	e426                	sd	s1,8(sp)
ffffffffc02056c0:	8626                	mv	a2,s1
ffffffffc02056c2:	b771                	j	ffffffffc020564e <sysfile_read+0x72>
ffffffffc02056c4:	66a2                	ld	a3,8(sp)
ffffffffc02056c6:	bf45                	j	ffffffffc0205676 <sysfile_read+0x9a>
ffffffffc02056c8:	5475                	li	s0,-3
ffffffffc02056ca:	b73d                	j	ffffffffc02055f8 <sysfile_read+0x1c>
ffffffffc02056cc:	5471                	li	s0,-4
ffffffffc02056ce:	b72d                	j	ffffffffc02055f8 <sysfile_read+0x1c>
ffffffffc02056d0:	00008697          	auipc	a3,0x8
ffffffffc02056d4:	e8868693          	addi	a3,a3,-376 # ffffffffc020d558 <CSWTCH.79+0xc8>
ffffffffc02056d8:	00006617          	auipc	a2,0x6
ffffffffc02056dc:	3a860613          	addi	a2,a2,936 # ffffffffc020ba80 <commands+0x210>
ffffffffc02056e0:	05500593          	li	a1,85
ffffffffc02056e4:	00008517          	auipc	a0,0x8
ffffffffc02056e8:	e8450513          	addi	a0,a0,-380 # ffffffffc020d568 <CSWTCH.79+0xd8>
ffffffffc02056ec:	db3fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02056f0 <sysfile_write>:
ffffffffc02056f0:	7159                	addi	sp,sp,-112
ffffffffc02056f2:	e8ca                	sd	s2,80(sp)
ffffffffc02056f4:	f486                	sd	ra,104(sp)
ffffffffc02056f6:	f0a2                	sd	s0,96(sp)
ffffffffc02056f8:	eca6                	sd	s1,88(sp)
ffffffffc02056fa:	e4ce                	sd	s3,72(sp)
ffffffffc02056fc:	e0d2                	sd	s4,64(sp)
ffffffffc02056fe:	fc56                	sd	s5,56(sp)
ffffffffc0205700:	f85a                	sd	s6,48(sp)
ffffffffc0205702:	f45e                	sd	s7,40(sp)
ffffffffc0205704:	f062                	sd	s8,32(sp)
ffffffffc0205706:	ec66                	sd	s9,24(sp)
ffffffffc0205708:	4901                	li	s2,0
ffffffffc020570a:	ee19                	bnez	a2,ffffffffc0205728 <sysfile_write+0x38>
ffffffffc020570c:	70a6                	ld	ra,104(sp)
ffffffffc020570e:	7406                	ld	s0,96(sp)
ffffffffc0205710:	64e6                	ld	s1,88(sp)
ffffffffc0205712:	69a6                	ld	s3,72(sp)
ffffffffc0205714:	6a06                	ld	s4,64(sp)
ffffffffc0205716:	7ae2                	ld	s5,56(sp)
ffffffffc0205718:	7b42                	ld	s6,48(sp)
ffffffffc020571a:	7ba2                	ld	s7,40(sp)
ffffffffc020571c:	7c02                	ld	s8,32(sp)
ffffffffc020571e:	6ce2                	ld	s9,24(sp)
ffffffffc0205720:	854a                	mv	a0,s2
ffffffffc0205722:	6946                	ld	s2,80(sp)
ffffffffc0205724:	6165                	addi	sp,sp,112
ffffffffc0205726:	8082                	ret
ffffffffc0205728:	00091c17          	auipc	s8,0x91
ffffffffc020572c:	198c0c13          	addi	s8,s8,408 # ffffffffc02968c0 <current>
ffffffffc0205730:	000c3783          	ld	a5,0(s8)
ffffffffc0205734:	8432                	mv	s0,a2
ffffffffc0205736:	89ae                	mv	s3,a1
ffffffffc0205738:	4605                	li	a2,1
ffffffffc020573a:	4581                	li	a1,0
ffffffffc020573c:	7784                	ld	s1,40(a5)
ffffffffc020573e:	8baa                	mv	s7,a0
ffffffffc0205740:	b8cff0ef          	jal	ra,ffffffffc0204acc <file_testfd>
ffffffffc0205744:	cd59                	beqz	a0,ffffffffc02057e2 <sysfile_write+0xf2>
ffffffffc0205746:	6505                	lui	a0,0x1
ffffffffc0205748:	847fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020574c:	8a2a                	mv	s4,a0
ffffffffc020574e:	cd41                	beqz	a0,ffffffffc02057e6 <sysfile_write+0xf6>
ffffffffc0205750:	4c81                	li	s9,0
ffffffffc0205752:	6a85                	lui	s5,0x1
ffffffffc0205754:	03848b13          	addi	s6,s1,56
ffffffffc0205758:	05546a63          	bltu	s0,s5,ffffffffc02057ac <sysfile_write+0xbc>
ffffffffc020575c:	e456                	sd	s5,8(sp)
ffffffffc020575e:	c8a9                	beqz	s1,ffffffffc02057b0 <sysfile_write+0xc0>
ffffffffc0205760:	855a                	mv	a0,s6
ffffffffc0205762:	e81fe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0205766:	000c3783          	ld	a5,0(s8)
ffffffffc020576a:	c399                	beqz	a5,ffffffffc0205770 <sysfile_write+0x80>
ffffffffc020576c:	43dc                	lw	a5,4(a5)
ffffffffc020576e:	c8bc                	sw	a5,80(s1)
ffffffffc0205770:	66a2                	ld	a3,8(sp)
ffffffffc0205772:	4701                	li	a4,0
ffffffffc0205774:	864e                	mv	a2,s3
ffffffffc0205776:	85d2                	mv	a1,s4
ffffffffc0205778:	8526                	mv	a0,s1
ffffffffc020577a:	c2bfe0ef          	jal	ra,ffffffffc02043a4 <copy_from_user>
ffffffffc020577e:	c139                	beqz	a0,ffffffffc02057c4 <sysfile_write+0xd4>
ffffffffc0205780:	855a                	mv	a0,s6
ffffffffc0205782:	e5dfe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0205786:	0404a823          	sw	zero,80(s1)
ffffffffc020578a:	6622                	ld	a2,8(sp)
ffffffffc020578c:	0034                	addi	a3,sp,8
ffffffffc020578e:	85d2                	mv	a1,s4
ffffffffc0205790:	855e                	mv	a0,s7
ffffffffc0205792:	dc8ff0ef          	jal	ra,ffffffffc0204d5a <file_write>
ffffffffc0205796:	67a2                	ld	a5,8(sp)
ffffffffc0205798:	892a                	mv	s2,a0
ffffffffc020579a:	ef85                	bnez	a5,ffffffffc02057d2 <sysfile_write+0xe2>
ffffffffc020579c:	8552                	mv	a0,s4
ffffffffc020579e:	8a1fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02057a2:	f60c85e3          	beqz	s9,ffffffffc020570c <sysfile_write+0x1c>
ffffffffc02057a6:	000c891b          	sext.w	s2,s9
ffffffffc02057aa:	b78d                	j	ffffffffc020570c <sysfile_write+0x1c>
ffffffffc02057ac:	e422                	sd	s0,8(sp)
ffffffffc02057ae:	f8cd                	bnez	s1,ffffffffc0205760 <sysfile_write+0x70>
ffffffffc02057b0:	66a2                	ld	a3,8(sp)
ffffffffc02057b2:	4701                	li	a4,0
ffffffffc02057b4:	864e                	mv	a2,s3
ffffffffc02057b6:	85d2                	mv	a1,s4
ffffffffc02057b8:	4501                	li	a0,0
ffffffffc02057ba:	bebfe0ef          	jal	ra,ffffffffc02043a4 <copy_from_user>
ffffffffc02057be:	f571                	bnez	a0,ffffffffc020578a <sysfile_write+0x9a>
ffffffffc02057c0:	5975                	li	s2,-3
ffffffffc02057c2:	bfe9                	j	ffffffffc020579c <sysfile_write+0xac>
ffffffffc02057c4:	855a                	mv	a0,s6
ffffffffc02057c6:	e19fe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02057ca:	5975                	li	s2,-3
ffffffffc02057cc:	0404a823          	sw	zero,80(s1)
ffffffffc02057d0:	b7f1                	j	ffffffffc020579c <sysfile_write+0xac>
ffffffffc02057d2:	00f46c63          	bltu	s0,a5,ffffffffc02057ea <sysfile_write+0xfa>
ffffffffc02057d6:	99be                	add	s3,s3,a5
ffffffffc02057d8:	8c1d                	sub	s0,s0,a5
ffffffffc02057da:	9cbe                	add	s9,s9,a5
ffffffffc02057dc:	f161                	bnez	a0,ffffffffc020579c <sysfile_write+0xac>
ffffffffc02057de:	fc2d                	bnez	s0,ffffffffc0205758 <sysfile_write+0x68>
ffffffffc02057e0:	bf75                	j	ffffffffc020579c <sysfile_write+0xac>
ffffffffc02057e2:	5975                	li	s2,-3
ffffffffc02057e4:	b725                	j	ffffffffc020570c <sysfile_write+0x1c>
ffffffffc02057e6:	5971                	li	s2,-4
ffffffffc02057e8:	b715                	j	ffffffffc020570c <sysfile_write+0x1c>
ffffffffc02057ea:	00008697          	auipc	a3,0x8
ffffffffc02057ee:	d6e68693          	addi	a3,a3,-658 # ffffffffc020d558 <CSWTCH.79+0xc8>
ffffffffc02057f2:	00006617          	auipc	a2,0x6
ffffffffc02057f6:	28e60613          	addi	a2,a2,654 # ffffffffc020ba80 <commands+0x210>
ffffffffc02057fa:	08a00593          	li	a1,138
ffffffffc02057fe:	00008517          	auipc	a0,0x8
ffffffffc0205802:	d6a50513          	addi	a0,a0,-662 # ffffffffc020d568 <CSWTCH.79+0xd8>
ffffffffc0205806:	c99fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020580a <sysfile_seek>:
ffffffffc020580a:	e36ff06f          	j	ffffffffc0204e40 <file_seek>

ffffffffc020580e <sysfile_fstat>:
ffffffffc020580e:	715d                	addi	sp,sp,-80
ffffffffc0205810:	f44e                	sd	s3,40(sp)
ffffffffc0205812:	00091997          	auipc	s3,0x91
ffffffffc0205816:	0ae98993          	addi	s3,s3,174 # ffffffffc02968c0 <current>
ffffffffc020581a:	0009b703          	ld	a4,0(s3)
ffffffffc020581e:	fc26                	sd	s1,56(sp)
ffffffffc0205820:	84ae                	mv	s1,a1
ffffffffc0205822:	858a                	mv	a1,sp
ffffffffc0205824:	e0a2                	sd	s0,64(sp)
ffffffffc0205826:	f84a                	sd	s2,48(sp)
ffffffffc0205828:	e486                	sd	ra,72(sp)
ffffffffc020582a:	02873903          	ld	s2,40(a4)
ffffffffc020582e:	f052                	sd	s4,32(sp)
ffffffffc0205830:	f30ff0ef          	jal	ra,ffffffffc0204f60 <file_fstat>
ffffffffc0205834:	842a                	mv	s0,a0
ffffffffc0205836:	e91d                	bnez	a0,ffffffffc020586c <sysfile_fstat+0x5e>
ffffffffc0205838:	04090363          	beqz	s2,ffffffffc020587e <sysfile_fstat+0x70>
ffffffffc020583c:	03890a13          	addi	s4,s2,56
ffffffffc0205840:	8552                	mv	a0,s4
ffffffffc0205842:	da1fe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0205846:	0009b783          	ld	a5,0(s3)
ffffffffc020584a:	c3b9                	beqz	a5,ffffffffc0205890 <sysfile_fstat+0x82>
ffffffffc020584c:	43dc                	lw	a5,4(a5)
ffffffffc020584e:	02000693          	li	a3,32
ffffffffc0205852:	860a                	mv	a2,sp
ffffffffc0205854:	04f92823          	sw	a5,80(s2)
ffffffffc0205858:	85a6                	mv	a1,s1
ffffffffc020585a:	854a                	mv	a0,s2
ffffffffc020585c:	b7dfe0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc0205860:	c121                	beqz	a0,ffffffffc02058a0 <sysfile_fstat+0x92>
ffffffffc0205862:	8552                	mv	a0,s4
ffffffffc0205864:	d7bfe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0205868:	04092823          	sw	zero,80(s2)
ffffffffc020586c:	60a6                	ld	ra,72(sp)
ffffffffc020586e:	8522                	mv	a0,s0
ffffffffc0205870:	6406                	ld	s0,64(sp)
ffffffffc0205872:	74e2                	ld	s1,56(sp)
ffffffffc0205874:	7942                	ld	s2,48(sp)
ffffffffc0205876:	79a2                	ld	s3,40(sp)
ffffffffc0205878:	7a02                	ld	s4,32(sp)
ffffffffc020587a:	6161                	addi	sp,sp,80
ffffffffc020587c:	8082                	ret
ffffffffc020587e:	02000693          	li	a3,32
ffffffffc0205882:	860a                	mv	a2,sp
ffffffffc0205884:	85a6                	mv	a1,s1
ffffffffc0205886:	b53fe0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc020588a:	f16d                	bnez	a0,ffffffffc020586c <sysfile_fstat+0x5e>
ffffffffc020588c:	5475                	li	s0,-3
ffffffffc020588e:	bff9                	j	ffffffffc020586c <sysfile_fstat+0x5e>
ffffffffc0205890:	02000693          	li	a3,32
ffffffffc0205894:	860a                	mv	a2,sp
ffffffffc0205896:	85a6                	mv	a1,s1
ffffffffc0205898:	854a                	mv	a0,s2
ffffffffc020589a:	b3ffe0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc020589e:	f171                	bnez	a0,ffffffffc0205862 <sysfile_fstat+0x54>
ffffffffc02058a0:	8552                	mv	a0,s4
ffffffffc02058a2:	d3dfe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02058a6:	5475                	li	s0,-3
ffffffffc02058a8:	04092823          	sw	zero,80(s2)
ffffffffc02058ac:	b7c1                	j	ffffffffc020586c <sysfile_fstat+0x5e>

ffffffffc02058ae <sysfile_fsync>:
ffffffffc02058ae:	f72ff06f          	j	ffffffffc0205020 <file_fsync>

ffffffffc02058b2 <sysfile_getcwd>:
ffffffffc02058b2:	715d                	addi	sp,sp,-80
ffffffffc02058b4:	f44e                	sd	s3,40(sp)
ffffffffc02058b6:	00091997          	auipc	s3,0x91
ffffffffc02058ba:	00a98993          	addi	s3,s3,10 # ffffffffc02968c0 <current>
ffffffffc02058be:	0009b783          	ld	a5,0(s3)
ffffffffc02058c2:	f84a                	sd	s2,48(sp)
ffffffffc02058c4:	e486                	sd	ra,72(sp)
ffffffffc02058c6:	e0a2                	sd	s0,64(sp)
ffffffffc02058c8:	fc26                	sd	s1,56(sp)
ffffffffc02058ca:	f052                	sd	s4,32(sp)
ffffffffc02058cc:	0287b903          	ld	s2,40(a5)
ffffffffc02058d0:	cda9                	beqz	a1,ffffffffc020592a <sysfile_getcwd+0x78>
ffffffffc02058d2:	842e                	mv	s0,a1
ffffffffc02058d4:	84aa                	mv	s1,a0
ffffffffc02058d6:	04090363          	beqz	s2,ffffffffc020591c <sysfile_getcwd+0x6a>
ffffffffc02058da:	03890a13          	addi	s4,s2,56
ffffffffc02058de:	8552                	mv	a0,s4
ffffffffc02058e0:	d03fe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc02058e4:	0009b783          	ld	a5,0(s3)
ffffffffc02058e8:	c781                	beqz	a5,ffffffffc02058f0 <sysfile_getcwd+0x3e>
ffffffffc02058ea:	43dc                	lw	a5,4(a5)
ffffffffc02058ec:	04f92823          	sw	a5,80(s2)
ffffffffc02058f0:	4685                	li	a3,1
ffffffffc02058f2:	8622                	mv	a2,s0
ffffffffc02058f4:	85a6                	mv	a1,s1
ffffffffc02058f6:	854a                	mv	a0,s2
ffffffffc02058f8:	a19fe0ef          	jal	ra,ffffffffc0204310 <user_mem_check>
ffffffffc02058fc:	e90d                	bnez	a0,ffffffffc020592e <sysfile_getcwd+0x7c>
ffffffffc02058fe:	5475                	li	s0,-3
ffffffffc0205900:	8552                	mv	a0,s4
ffffffffc0205902:	cddfe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0205906:	04092823          	sw	zero,80(s2)
ffffffffc020590a:	60a6                	ld	ra,72(sp)
ffffffffc020590c:	8522                	mv	a0,s0
ffffffffc020590e:	6406                	ld	s0,64(sp)
ffffffffc0205910:	74e2                	ld	s1,56(sp)
ffffffffc0205912:	7942                	ld	s2,48(sp)
ffffffffc0205914:	79a2                	ld	s3,40(sp)
ffffffffc0205916:	7a02                	ld	s4,32(sp)
ffffffffc0205918:	6161                	addi	sp,sp,80
ffffffffc020591a:	8082                	ret
ffffffffc020591c:	862e                	mv	a2,a1
ffffffffc020591e:	4685                	li	a3,1
ffffffffc0205920:	85aa                	mv	a1,a0
ffffffffc0205922:	4501                	li	a0,0
ffffffffc0205924:	9edfe0ef          	jal	ra,ffffffffc0204310 <user_mem_check>
ffffffffc0205928:	ed09                	bnez	a0,ffffffffc0205942 <sysfile_getcwd+0x90>
ffffffffc020592a:	5475                	li	s0,-3
ffffffffc020592c:	bff9                	j	ffffffffc020590a <sysfile_getcwd+0x58>
ffffffffc020592e:	8622                	mv	a2,s0
ffffffffc0205930:	4681                	li	a3,0
ffffffffc0205932:	85a6                	mv	a1,s1
ffffffffc0205934:	850a                	mv	a0,sp
ffffffffc0205936:	b2bff0ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc020593a:	3c3020ef          	jal	ra,ffffffffc02084fc <vfs_getcwd>
ffffffffc020593e:	842a                	mv	s0,a0
ffffffffc0205940:	b7c1                	j	ffffffffc0205900 <sysfile_getcwd+0x4e>
ffffffffc0205942:	8622                	mv	a2,s0
ffffffffc0205944:	4681                	li	a3,0
ffffffffc0205946:	85a6                	mv	a1,s1
ffffffffc0205948:	850a                	mv	a0,sp
ffffffffc020594a:	b17ff0ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc020594e:	3af020ef          	jal	ra,ffffffffc02084fc <vfs_getcwd>
ffffffffc0205952:	842a                	mv	s0,a0
ffffffffc0205954:	bf5d                	j	ffffffffc020590a <sysfile_getcwd+0x58>

ffffffffc0205956 <sysfile_getdirentry>:
ffffffffc0205956:	7139                	addi	sp,sp,-64
ffffffffc0205958:	e852                	sd	s4,16(sp)
ffffffffc020595a:	00091a17          	auipc	s4,0x91
ffffffffc020595e:	f66a0a13          	addi	s4,s4,-154 # ffffffffc02968c0 <current>
ffffffffc0205962:	000a3703          	ld	a4,0(s4)
ffffffffc0205966:	ec4e                	sd	s3,24(sp)
ffffffffc0205968:	89aa                	mv	s3,a0
ffffffffc020596a:	10800513          	li	a0,264
ffffffffc020596e:	f426                	sd	s1,40(sp)
ffffffffc0205970:	f04a                	sd	s2,32(sp)
ffffffffc0205972:	fc06                	sd	ra,56(sp)
ffffffffc0205974:	f822                	sd	s0,48(sp)
ffffffffc0205976:	e456                	sd	s5,8(sp)
ffffffffc0205978:	7704                	ld	s1,40(a4)
ffffffffc020597a:	892e                	mv	s2,a1
ffffffffc020597c:	e12fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0205980:	c169                	beqz	a0,ffffffffc0205a42 <sysfile_getdirentry+0xec>
ffffffffc0205982:	842a                	mv	s0,a0
ffffffffc0205984:	c8c1                	beqz	s1,ffffffffc0205a14 <sysfile_getdirentry+0xbe>
ffffffffc0205986:	03848a93          	addi	s5,s1,56
ffffffffc020598a:	8556                	mv	a0,s5
ffffffffc020598c:	c57fe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0205990:	000a3783          	ld	a5,0(s4)
ffffffffc0205994:	c399                	beqz	a5,ffffffffc020599a <sysfile_getdirentry+0x44>
ffffffffc0205996:	43dc                	lw	a5,4(a5)
ffffffffc0205998:	c8bc                	sw	a5,80(s1)
ffffffffc020599a:	4705                	li	a4,1
ffffffffc020599c:	46a1                	li	a3,8
ffffffffc020599e:	864a                	mv	a2,s2
ffffffffc02059a0:	85a2                	mv	a1,s0
ffffffffc02059a2:	8526                	mv	a0,s1
ffffffffc02059a4:	a01fe0ef          	jal	ra,ffffffffc02043a4 <copy_from_user>
ffffffffc02059a8:	e505                	bnez	a0,ffffffffc02059d0 <sysfile_getdirentry+0x7a>
ffffffffc02059aa:	8556                	mv	a0,s5
ffffffffc02059ac:	c33fe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02059b0:	59f5                	li	s3,-3
ffffffffc02059b2:	0404a823          	sw	zero,80(s1)
ffffffffc02059b6:	8522                	mv	a0,s0
ffffffffc02059b8:	e86fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02059bc:	70e2                	ld	ra,56(sp)
ffffffffc02059be:	7442                	ld	s0,48(sp)
ffffffffc02059c0:	74a2                	ld	s1,40(sp)
ffffffffc02059c2:	7902                	ld	s2,32(sp)
ffffffffc02059c4:	6a42                	ld	s4,16(sp)
ffffffffc02059c6:	6aa2                	ld	s5,8(sp)
ffffffffc02059c8:	854e                	mv	a0,s3
ffffffffc02059ca:	69e2                	ld	s3,24(sp)
ffffffffc02059cc:	6121                	addi	sp,sp,64
ffffffffc02059ce:	8082                	ret
ffffffffc02059d0:	8556                	mv	a0,s5
ffffffffc02059d2:	c0dfe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02059d6:	854e                	mv	a0,s3
ffffffffc02059d8:	85a2                	mv	a1,s0
ffffffffc02059da:	0404a823          	sw	zero,80(s1)
ffffffffc02059de:	ef0ff0ef          	jal	ra,ffffffffc02050ce <file_getdirentry>
ffffffffc02059e2:	89aa                	mv	s3,a0
ffffffffc02059e4:	f969                	bnez	a0,ffffffffc02059b6 <sysfile_getdirentry+0x60>
ffffffffc02059e6:	8556                	mv	a0,s5
ffffffffc02059e8:	bfbfe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc02059ec:	000a3783          	ld	a5,0(s4)
ffffffffc02059f0:	c399                	beqz	a5,ffffffffc02059f6 <sysfile_getdirentry+0xa0>
ffffffffc02059f2:	43dc                	lw	a5,4(a5)
ffffffffc02059f4:	c8bc                	sw	a5,80(s1)
ffffffffc02059f6:	10800693          	li	a3,264
ffffffffc02059fa:	8622                	mv	a2,s0
ffffffffc02059fc:	85ca                	mv	a1,s2
ffffffffc02059fe:	8526                	mv	a0,s1
ffffffffc0205a00:	9d9fe0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc0205a04:	e111                	bnez	a0,ffffffffc0205a08 <sysfile_getdirentry+0xb2>
ffffffffc0205a06:	59f5                	li	s3,-3
ffffffffc0205a08:	8556                	mv	a0,s5
ffffffffc0205a0a:	bd5fe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0205a0e:	0404a823          	sw	zero,80(s1)
ffffffffc0205a12:	b755                	j	ffffffffc02059b6 <sysfile_getdirentry+0x60>
ffffffffc0205a14:	85aa                	mv	a1,a0
ffffffffc0205a16:	4705                	li	a4,1
ffffffffc0205a18:	46a1                	li	a3,8
ffffffffc0205a1a:	864a                	mv	a2,s2
ffffffffc0205a1c:	4501                	li	a0,0
ffffffffc0205a1e:	987fe0ef          	jal	ra,ffffffffc02043a4 <copy_from_user>
ffffffffc0205a22:	cd11                	beqz	a0,ffffffffc0205a3e <sysfile_getdirentry+0xe8>
ffffffffc0205a24:	854e                	mv	a0,s3
ffffffffc0205a26:	85a2                	mv	a1,s0
ffffffffc0205a28:	ea6ff0ef          	jal	ra,ffffffffc02050ce <file_getdirentry>
ffffffffc0205a2c:	89aa                	mv	s3,a0
ffffffffc0205a2e:	f541                	bnez	a0,ffffffffc02059b6 <sysfile_getdirentry+0x60>
ffffffffc0205a30:	10800693          	li	a3,264
ffffffffc0205a34:	8622                	mv	a2,s0
ffffffffc0205a36:	85ca                	mv	a1,s2
ffffffffc0205a38:	9a1fe0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc0205a3c:	fd2d                	bnez	a0,ffffffffc02059b6 <sysfile_getdirentry+0x60>
ffffffffc0205a3e:	59f5                	li	s3,-3
ffffffffc0205a40:	bf9d                	j	ffffffffc02059b6 <sysfile_getdirentry+0x60>
ffffffffc0205a42:	59f1                	li	s3,-4
ffffffffc0205a44:	bfa5                	j	ffffffffc02059bc <sysfile_getdirentry+0x66>

ffffffffc0205a46 <sysfile_dup>:
ffffffffc0205a46:	f6eff06f          	j	ffffffffc02051b4 <file_dup>

ffffffffc0205a4a <kernel_thread_entry>:
ffffffffc0205a4a:	8526                	mv	a0,s1
ffffffffc0205a4c:	9402                	jalr	s0
ffffffffc0205a4e:	610000ef          	jal	ra,ffffffffc020605e <do_exit>

ffffffffc0205a52 <alloc_proc>:
ffffffffc0205a52:	1141                	addi	sp,sp,-16
ffffffffc0205a54:	15000513          	li	a0,336
ffffffffc0205a58:	e022                	sd	s0,0(sp)
ffffffffc0205a5a:	e406                	sd	ra,8(sp)
ffffffffc0205a5c:	d32fc0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0205a60:	842a                	mv	s0,a0
ffffffffc0205a62:	c951                	beqz	a0,ffffffffc0205af6 <alloc_proc+0xa4>
ffffffffc0205a64:	57fd                	li	a5,-1
ffffffffc0205a66:	1782                	slli	a5,a5,0x20
ffffffffc0205a68:	e11c                	sd	a5,0(a0)
ffffffffc0205a6a:	00091797          	auipc	a5,0x91
ffffffffc0205a6e:	e267b783          	ld	a5,-474(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc0205a72:	f55c                	sd	a5,168(a0)
ffffffffc0205a74:	4641                	li	a2,16
ffffffffc0205a76:	4581                	li	a1,0
ffffffffc0205a78:	00052423          	sw	zero,8(a0)
ffffffffc0205a7c:	00053c23          	sd	zero,24(a0)
ffffffffc0205a80:	00053823          	sd	zero,16(a0)
ffffffffc0205a84:	02053423          	sd	zero,40(a0)
ffffffffc0205a88:	02053023          	sd	zero,32(a0)
ffffffffc0205a8c:	0a052823          	sw	zero,176(a0)
ffffffffc0205a90:	0e053423          	sd	zero,232(a0)
ffffffffc0205a94:	0e053823          	sd	zero,240(a0)
ffffffffc0205a98:	0e053c23          	sd	zero,248(a0)
ffffffffc0205a9c:	10053023          	sd	zero,256(a0)
ffffffffc0205aa0:	0b450513          	addi	a0,a0,180
ffffffffc0205aa4:	2f7050ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0205aa8:	07000613          	li	a2,112
ffffffffc0205aac:	4581                	li	a1,0
ffffffffc0205aae:	03040513          	addi	a0,s0,48
ffffffffc0205ab2:	2e9050ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0205ab6:	11040793          	addi	a5,s0,272
ffffffffc0205aba:	10f43c23          	sd	a5,280(s0)
ffffffffc0205abe:	10f43823          	sd	a5,272(s0)
ffffffffc0205ac2:	4785                	li	a5,1
ffffffffc0205ac4:	0c840693          	addi	a3,s0,200
ffffffffc0205ac8:	0d840713          	addi	a4,s0,216
ffffffffc0205acc:	1782                	slli	a5,a5,0x20
ffffffffc0205ace:	0a043023          	sd	zero,160(s0)
ffffffffc0205ad2:	e874                	sd	a3,208(s0)
ffffffffc0205ad4:	e474                	sd	a3,200(s0)
ffffffffc0205ad6:	f078                	sd	a4,224(s0)
ffffffffc0205ad8:	ec78                	sd	a4,216(s0)
ffffffffc0205ada:	10043423          	sd	zero,264(s0)
ffffffffc0205ade:	12042023          	sw	zero,288(s0)
ffffffffc0205ae2:	12043423          	sd	zero,296(s0)
ffffffffc0205ae6:	12043823          	sd	zero,304(s0)
ffffffffc0205aea:	12043c23          	sd	zero,312(s0)
ffffffffc0205aee:	14f43023          	sd	a5,320(s0)
ffffffffc0205af2:	14043423          	sd	zero,328(s0)
ffffffffc0205af6:	60a2                	ld	ra,8(sp)
ffffffffc0205af8:	8522                	mv	a0,s0
ffffffffc0205afa:	6402                	ld	s0,0(sp)
ffffffffc0205afc:	0141                	addi	sp,sp,16
ffffffffc0205afe:	8082                	ret

ffffffffc0205b00 <forkret>:
ffffffffc0205b00:	00091797          	auipc	a5,0x91
ffffffffc0205b04:	dc07b783          	ld	a5,-576(a5) # ffffffffc02968c0 <current>
ffffffffc0205b08:	73c8                	ld	a0,160(a5)
ffffffffc0205b0a:	fa0fb06f          	j	ffffffffc02012aa <forkrets>

ffffffffc0205b0e <put_pgdir.isra.0>:
ffffffffc0205b0e:	1141                	addi	sp,sp,-16
ffffffffc0205b10:	e406                	sd	ra,8(sp)
ffffffffc0205b12:	c02007b7          	lui	a5,0xc0200
ffffffffc0205b16:	02f56e63          	bltu	a0,a5,ffffffffc0205b52 <put_pgdir.isra.0+0x44>
ffffffffc0205b1a:	00091697          	auipc	a3,0x91
ffffffffc0205b1e:	d9e6b683          	ld	a3,-610(a3) # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205b22:	8d15                	sub	a0,a0,a3
ffffffffc0205b24:	8131                	srli	a0,a0,0xc
ffffffffc0205b26:	00091797          	auipc	a5,0x91
ffffffffc0205b2a:	d7a7b783          	ld	a5,-646(a5) # ffffffffc02968a0 <npage>
ffffffffc0205b2e:	02f57f63          	bgeu	a0,a5,ffffffffc0205b6c <put_pgdir.isra.0+0x5e>
ffffffffc0205b32:	0000a697          	auipc	a3,0xa
ffffffffc0205b36:	d9e6b683          	ld	a3,-610(a3) # ffffffffc020f8d0 <nbase>
ffffffffc0205b3a:	60a2                	ld	ra,8(sp)
ffffffffc0205b3c:	8d15                	sub	a0,a0,a3
ffffffffc0205b3e:	00091797          	auipc	a5,0x91
ffffffffc0205b42:	d6a7b783          	ld	a5,-662(a5) # ffffffffc02968a8 <pages>
ffffffffc0205b46:	051a                	slli	a0,a0,0x6
ffffffffc0205b48:	4585                	li	a1,1
ffffffffc0205b4a:	953e                	add	a0,a0,a5
ffffffffc0205b4c:	0141                	addi	sp,sp,16
ffffffffc0205b4e:	e5cfc06f          	j	ffffffffc02021aa <free_pages>
ffffffffc0205b52:	86aa                	mv	a3,a0
ffffffffc0205b54:	00007617          	auipc	a2,0x7
ffffffffc0205b58:	af460613          	addi	a2,a2,-1292 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0205b5c:	07700593          	li	a1,119
ffffffffc0205b60:	00007517          	auipc	a0,0x7
ffffffffc0205b64:	a6850513          	addi	a0,a0,-1432 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0205b68:	937fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205b6c:	00007617          	auipc	a2,0x7
ffffffffc0205b70:	b0460613          	addi	a2,a2,-1276 # ffffffffc020c670 <default_pmm_manager+0x108>
ffffffffc0205b74:	06900593          	li	a1,105
ffffffffc0205b78:	00007517          	auipc	a0,0x7
ffffffffc0205b7c:	a5050513          	addi	a0,a0,-1456 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0205b80:	91ffa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0205b84 <proc_run>:
ffffffffc0205b84:	7179                	addi	sp,sp,-48
ffffffffc0205b86:	f026                	sd	s1,32(sp)
ffffffffc0205b88:	00091497          	auipc	s1,0x91
ffffffffc0205b8c:	d3848493          	addi	s1,s1,-712 # ffffffffc02968c0 <current>
ffffffffc0205b90:	ec4a                	sd	s2,24(sp)
ffffffffc0205b92:	0004b903          	ld	s2,0(s1)
ffffffffc0205b96:	f406                	sd	ra,40(sp)
ffffffffc0205b98:	e84e                	sd	s3,16(sp)
ffffffffc0205b9a:	02a90a63          	beq	s2,a0,ffffffffc0205bce <proc_run+0x4a>
ffffffffc0205b9e:	100027f3          	csrr	a5,sstatus
ffffffffc0205ba2:	8b89                	andi	a5,a5,2
ffffffffc0205ba4:	4981                	li	s3,0
ffffffffc0205ba6:	e3a9                	bnez	a5,ffffffffc0205be8 <proc_run+0x64>
ffffffffc0205ba8:	755c                	ld	a5,168(a0)
ffffffffc0205baa:	577d                	li	a4,-1
ffffffffc0205bac:	177e                	slli	a4,a4,0x3f
ffffffffc0205bae:	83b1                	srli	a5,a5,0xc
ffffffffc0205bb0:	e088                	sd	a0,0(s1)
ffffffffc0205bb2:	8fd9                	or	a5,a5,a4
ffffffffc0205bb4:	18079073          	csrw	satp,a5
ffffffffc0205bb8:	12000073          	sfence.vma
ffffffffc0205bbc:	608c                	ld	a1,0(s1)
ffffffffc0205bbe:	03090513          	addi	a0,s2,48
ffffffffc0205bc2:	03058593          	addi	a1,a1,48
ffffffffc0205bc6:	600010ef          	jal	ra,ffffffffc02071c6 <switch_to>
ffffffffc0205bca:	00099863          	bnez	s3,ffffffffc0205bda <proc_run+0x56>
ffffffffc0205bce:	70a2                	ld	ra,40(sp)
ffffffffc0205bd0:	7482                	ld	s1,32(sp)
ffffffffc0205bd2:	6962                	ld	s2,24(sp)
ffffffffc0205bd4:	69c2                	ld	s3,16(sp)
ffffffffc0205bd6:	6145                	addi	sp,sp,48
ffffffffc0205bd8:	8082                	ret
ffffffffc0205bda:	70a2                	ld	ra,40(sp)
ffffffffc0205bdc:	7482                	ld	s1,32(sp)
ffffffffc0205bde:	6962                	ld	s2,24(sp)
ffffffffc0205be0:	69c2                	ld	s3,16(sp)
ffffffffc0205be2:	6145                	addi	sp,sp,48
ffffffffc0205be4:	888fb06f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0205be8:	e42a                	sd	a0,8(sp)
ffffffffc0205bea:	888fb0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205bee:	6522                	ld	a0,8(sp)
ffffffffc0205bf0:	4985                	li	s3,1
ffffffffc0205bf2:	bf5d                	j	ffffffffc0205ba8 <proc_run+0x24>

ffffffffc0205bf4 <do_fork>:
ffffffffc0205bf4:	7119                	addi	sp,sp,-128
ffffffffc0205bf6:	e8d2                	sd	s4,80(sp)
ffffffffc0205bf8:	00091a17          	auipc	s4,0x91
ffffffffc0205bfc:	ce0a0a13          	addi	s4,s4,-800 # ffffffffc02968d8 <nr_process>
ffffffffc0205c00:	000a2703          	lw	a4,0(s4)
ffffffffc0205c04:	fc86                	sd	ra,120(sp)
ffffffffc0205c06:	f8a2                	sd	s0,112(sp)
ffffffffc0205c08:	f4a6                	sd	s1,104(sp)
ffffffffc0205c0a:	f0ca                	sd	s2,96(sp)
ffffffffc0205c0c:	ecce                	sd	s3,88(sp)
ffffffffc0205c0e:	e4d6                	sd	s5,72(sp)
ffffffffc0205c10:	e0da                	sd	s6,64(sp)
ffffffffc0205c12:	fc5e                	sd	s7,56(sp)
ffffffffc0205c14:	f862                	sd	s8,48(sp)
ffffffffc0205c16:	f466                	sd	s9,40(sp)
ffffffffc0205c18:	f06a                	sd	s10,32(sp)
ffffffffc0205c1a:	ec6e                	sd	s11,24(sp)
ffffffffc0205c1c:	6785                	lui	a5,0x1
ffffffffc0205c1e:	e032                	sd	a2,0(sp)
ffffffffc0205c20:	36f75263          	bge	a4,a5,ffffffffc0205f84 <do_fork+0x390>
ffffffffc0205c24:	892a                	mv	s2,a0
ffffffffc0205c26:	89ae                	mv	s3,a1
ffffffffc0205c28:	e2bff0ef          	jal	ra,ffffffffc0205a52 <alloc_proc>
ffffffffc0205c2c:	842a                	mv	s0,a0
ffffffffc0205c2e:	34050063          	beqz	a0,ffffffffc0205f6e <do_fork+0x37a>
ffffffffc0205c32:	4509                	li	a0,2
ffffffffc0205c34:	d38fc0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0205c38:	32050863          	beqz	a0,ffffffffc0205f68 <do_fork+0x374>
ffffffffc0205c3c:	00091b17          	auipc	s6,0x91
ffffffffc0205c40:	c6cb0b13          	addi	s6,s6,-916 # ffffffffc02968a8 <pages>
ffffffffc0205c44:	000b3683          	ld	a3,0(s6)
ffffffffc0205c48:	00091b97          	auipc	s7,0x91
ffffffffc0205c4c:	c58b8b93          	addi	s7,s7,-936 # ffffffffc02968a0 <npage>
ffffffffc0205c50:	0000aa97          	auipc	s5,0xa
ffffffffc0205c54:	c80aba83          	ld	s5,-896(s5) # ffffffffc020f8d0 <nbase>
ffffffffc0205c58:	40d506b3          	sub	a3,a0,a3
ffffffffc0205c5c:	8699                	srai	a3,a3,0x6
ffffffffc0205c5e:	5c7d                	li	s8,-1
ffffffffc0205c60:	000bb783          	ld	a5,0(s7)
ffffffffc0205c64:	96d6                	add	a3,a3,s5
ffffffffc0205c66:	00cc5c13          	srli	s8,s8,0xc
ffffffffc0205c6a:	0186f733          	and	a4,a3,s8
ffffffffc0205c6e:	06b2                	slli	a3,a3,0xc
ffffffffc0205c70:	36f77363          	bgeu	a4,a5,ffffffffc0205fd6 <do_fork+0x3e2>
ffffffffc0205c74:	00091c97          	auipc	s9,0x91
ffffffffc0205c78:	c4cc8c93          	addi	s9,s9,-948 # ffffffffc02968c0 <current>
ffffffffc0205c7c:	000cb603          	ld	a2,0(s9)
ffffffffc0205c80:	00091d17          	auipc	s10,0x91
ffffffffc0205c84:	c38d0d13          	addi	s10,s10,-968 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0205c88:	000d3703          	ld	a4,0(s10)
ffffffffc0205c8c:	7604                	ld	s1,40(a2)
ffffffffc0205c8e:	96ba                	add	a3,a3,a4
ffffffffc0205c90:	e814                	sd	a3,16(s0)
ffffffffc0205c92:	c485                	beqz	s1,ffffffffc0205cba <do_fork+0xc6>
ffffffffc0205c94:	10097713          	andi	a4,s2,256
ffffffffc0205c98:	20070163          	beqz	a4,ffffffffc0205e9a <do_fork+0x2a6>
ffffffffc0205c9c:	5898                	lw	a4,48(s1)
ffffffffc0205c9e:	6c94                	ld	a3,24(s1)
ffffffffc0205ca0:	c0200637          	lui	a2,0xc0200
ffffffffc0205ca4:	2705                	addiw	a4,a4,1
ffffffffc0205ca6:	d898                	sw	a4,48(s1)
ffffffffc0205ca8:	f404                	sd	s1,40(s0)
ffffffffc0205caa:	2ec6e263          	bltu	a3,a2,ffffffffc0205f8e <do_fork+0x39a>
ffffffffc0205cae:	000d3783          	ld	a5,0(s10)
ffffffffc0205cb2:	000cb603          	ld	a2,0(s9)
ffffffffc0205cb6:	8e9d                	sub	a3,a3,a5
ffffffffc0205cb8:	f454                	sd	a3,168(s0)
ffffffffc0205cba:	14863c03          	ld	s8,328(a2) # ffffffffc0200148 <readline+0x96>
ffffffffc0205cbe:	320c0863          	beqz	s8,ffffffffc0205fee <do_fork+0x3fa>
ffffffffc0205cc2:	00b95913          	srli	s2,s2,0xb
ffffffffc0205cc6:	00197913          	andi	s2,s2,1
ffffffffc0205cca:	1a090063          	beqz	s2,ffffffffc0205e6a <do_fork+0x276>
ffffffffc0205cce:	010c2783          	lw	a5,16(s8)
ffffffffc0205cd2:	2785                	addiw	a5,a5,1
ffffffffc0205cd4:	00fc2823          	sw	a5,16(s8)
ffffffffc0205cd8:	15843423          	sd	s8,328(s0)
ffffffffc0205cdc:	100027f3          	csrr	a5,sstatus
ffffffffc0205ce0:	8b89                	andi	a5,a5,2
ffffffffc0205ce2:	28079863          	bnez	a5,ffffffffc0205f72 <do_fork+0x37e>
ffffffffc0205ce6:	4a81                	li	s5,0
ffffffffc0205ce8:	0008b817          	auipc	a6,0x8b
ffffffffc0205cec:	37080813          	addi	a6,a6,880 # ffffffffc0291058 <last_pid.1>
ffffffffc0205cf0:	000cb703          	ld	a4,0(s9)
ffffffffc0205cf4:	00082783          	lw	a5,0(a6)
ffffffffc0205cf8:	6689                	lui	a3,0x2
ffffffffc0205cfa:	f018                	sd	a4,32(s0)
ffffffffc0205cfc:	0017851b          	addiw	a0,a5,1
ffffffffc0205d00:	0e072623          	sw	zero,236(a4)
ffffffffc0205d04:	00a82023          	sw	a0,0(a6)
ffffffffc0205d08:	0ed55863          	bge	a0,a3,ffffffffc0205df8 <do_fork+0x204>
ffffffffc0205d0c:	0008b317          	auipc	t1,0x8b
ffffffffc0205d10:	35030313          	addi	t1,t1,848 # ffffffffc029105c <next_safe.0>
ffffffffc0205d14:	00032783          	lw	a5,0(t1)
ffffffffc0205d18:	00090917          	auipc	s2,0x90
ffffffffc0205d1c:	aa890913          	addi	s2,s2,-1368 # ffffffffc02957c0 <proc_list>
ffffffffc0205d20:	0ef55463          	bge	a0,a5,ffffffffc0205e08 <do_fork+0x214>
ffffffffc0205d24:	6818                	ld	a4,16(s0)
ffffffffc0205d26:	6602                	ld	a2,0(sp)
ffffffffc0205d28:	6789                	lui	a5,0x2
ffffffffc0205d2a:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205d2e:	973e                	add	a4,a4,a5
ffffffffc0205d30:	c048                	sw	a0,4(s0)
ffffffffc0205d32:	f058                	sd	a4,160(s0)
ffffffffc0205d34:	87ba                	mv	a5,a4
ffffffffc0205d36:	12060313          	addi	t1,a2,288
ffffffffc0205d3a:	00063883          	ld	a7,0(a2)
ffffffffc0205d3e:	00863803          	ld	a6,8(a2)
ffffffffc0205d42:	6a0c                	ld	a1,16(a2)
ffffffffc0205d44:	6e14                	ld	a3,24(a2)
ffffffffc0205d46:	0117b023          	sd	a7,0(a5)
ffffffffc0205d4a:	0107b423          	sd	a6,8(a5)
ffffffffc0205d4e:	eb8c                	sd	a1,16(a5)
ffffffffc0205d50:	ef94                	sd	a3,24(a5)
ffffffffc0205d52:	02060613          	addi	a2,a2,32
ffffffffc0205d56:	02078793          	addi	a5,a5,32
ffffffffc0205d5a:	fe6610e3          	bne	a2,t1,ffffffffc0205d3a <do_fork+0x146>
ffffffffc0205d5e:	04073823          	sd	zero,80(a4)
ffffffffc0205d62:	10098263          	beqz	s3,ffffffffc0205e66 <do_fork+0x272>
ffffffffc0205d66:	01373823          	sd	s3,16(a4)
ffffffffc0205d6a:	00000797          	auipc	a5,0x0
ffffffffc0205d6e:	d9678793          	addi	a5,a5,-618 # ffffffffc0205b00 <forkret>
ffffffffc0205d72:	f81c                	sd	a5,48(s0)
ffffffffc0205d74:	fc18                	sd	a4,56(s0)
ffffffffc0205d76:	45a9                	li	a1,10
ffffffffc0205d78:	2501                	sext.w	a0,a0
ffffffffc0205d7a:	2ec050ef          	jal	ra,ffffffffc020b066 <hash32>
ffffffffc0205d7e:	02051793          	slli	a5,a0,0x20
ffffffffc0205d82:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205d86:	0008c797          	auipc	a5,0x8c
ffffffffc0205d8a:	a3a78793          	addi	a5,a5,-1478 # ffffffffc02917c0 <hash_list>
ffffffffc0205d8e:	953e                	add	a0,a0,a5
ffffffffc0205d90:	650c                	ld	a1,8(a0)
ffffffffc0205d92:	7014                	ld	a3,32(s0)
ffffffffc0205d94:	0d840793          	addi	a5,s0,216
ffffffffc0205d98:	e19c                	sd	a5,0(a1)
ffffffffc0205d9a:	00893603          	ld	a2,8(s2)
ffffffffc0205d9e:	e51c                	sd	a5,8(a0)
ffffffffc0205da0:	7af8                	ld	a4,240(a3)
ffffffffc0205da2:	0c840793          	addi	a5,s0,200
ffffffffc0205da6:	f06c                	sd	a1,224(s0)
ffffffffc0205da8:	ec68                	sd	a0,216(s0)
ffffffffc0205daa:	e21c                	sd	a5,0(a2)
ffffffffc0205dac:	00f93423          	sd	a5,8(s2)
ffffffffc0205db0:	e870                	sd	a2,208(s0)
ffffffffc0205db2:	0d243423          	sd	s2,200(s0)
ffffffffc0205db6:	0e043c23          	sd	zero,248(s0)
ffffffffc0205dba:	10e43023          	sd	a4,256(s0)
ffffffffc0205dbe:	c311                	beqz	a4,ffffffffc0205dc2 <do_fork+0x1ce>
ffffffffc0205dc0:	ff60                	sd	s0,248(a4)
ffffffffc0205dc2:	000a2783          	lw	a5,0(s4)
ffffffffc0205dc6:	fae0                	sd	s0,240(a3)
ffffffffc0205dc8:	8522                	mv	a0,s0
ffffffffc0205dca:	2785                	addiw	a5,a5,1
ffffffffc0205dcc:	00fa2023          	sw	a5,0(s4)
ffffffffc0205dd0:	59a010ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc0205dd4:	140a9163          	bnez	s5,ffffffffc0205f16 <do_fork+0x322>
ffffffffc0205dd8:	4048                	lw	a0,4(s0)
ffffffffc0205dda:	70e6                	ld	ra,120(sp)
ffffffffc0205ddc:	7446                	ld	s0,112(sp)
ffffffffc0205dde:	74a6                	ld	s1,104(sp)
ffffffffc0205de0:	7906                	ld	s2,96(sp)
ffffffffc0205de2:	69e6                	ld	s3,88(sp)
ffffffffc0205de4:	6a46                	ld	s4,80(sp)
ffffffffc0205de6:	6aa6                	ld	s5,72(sp)
ffffffffc0205de8:	6b06                	ld	s6,64(sp)
ffffffffc0205dea:	7be2                	ld	s7,56(sp)
ffffffffc0205dec:	7c42                	ld	s8,48(sp)
ffffffffc0205dee:	7ca2                	ld	s9,40(sp)
ffffffffc0205df0:	7d02                	ld	s10,32(sp)
ffffffffc0205df2:	6de2                	ld	s11,24(sp)
ffffffffc0205df4:	6109                	addi	sp,sp,128
ffffffffc0205df6:	8082                	ret
ffffffffc0205df8:	4785                	li	a5,1
ffffffffc0205dfa:	00f82023          	sw	a5,0(a6)
ffffffffc0205dfe:	4505                	li	a0,1
ffffffffc0205e00:	0008b317          	auipc	t1,0x8b
ffffffffc0205e04:	25c30313          	addi	t1,t1,604 # ffffffffc029105c <next_safe.0>
ffffffffc0205e08:	00090917          	auipc	s2,0x90
ffffffffc0205e0c:	9b890913          	addi	s2,s2,-1608 # ffffffffc02957c0 <proc_list>
ffffffffc0205e10:	00893e03          	ld	t3,8(s2)
ffffffffc0205e14:	6789                	lui	a5,0x2
ffffffffc0205e16:	00f32023          	sw	a5,0(t1)
ffffffffc0205e1a:	86aa                	mv	a3,a0
ffffffffc0205e1c:	4581                	li	a1,0
ffffffffc0205e1e:	6e89                	lui	t4,0x2
ffffffffc0205e20:	152e0d63          	beq	t3,s2,ffffffffc0205f7a <do_fork+0x386>
ffffffffc0205e24:	88ae                	mv	a7,a1
ffffffffc0205e26:	87f2                	mv	a5,t3
ffffffffc0205e28:	6609                	lui	a2,0x2
ffffffffc0205e2a:	a811                	j	ffffffffc0205e3e <do_fork+0x24a>
ffffffffc0205e2c:	00e6d663          	bge	a3,a4,ffffffffc0205e38 <do_fork+0x244>
ffffffffc0205e30:	00c75463          	bge	a4,a2,ffffffffc0205e38 <do_fork+0x244>
ffffffffc0205e34:	863a                	mv	a2,a4
ffffffffc0205e36:	4885                	li	a7,1
ffffffffc0205e38:	679c                	ld	a5,8(a5)
ffffffffc0205e3a:	01278d63          	beq	a5,s2,ffffffffc0205e54 <do_fork+0x260>
ffffffffc0205e3e:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205e42:	fed715e3          	bne	a4,a3,ffffffffc0205e2c <do_fork+0x238>
ffffffffc0205e46:	2685                	addiw	a3,a3,1
ffffffffc0205e48:	0cc6da63          	bge	a3,a2,ffffffffc0205f1c <do_fork+0x328>
ffffffffc0205e4c:	679c                	ld	a5,8(a5)
ffffffffc0205e4e:	4585                	li	a1,1
ffffffffc0205e50:	ff2797e3          	bne	a5,s2,ffffffffc0205e3e <do_fork+0x24a>
ffffffffc0205e54:	c581                	beqz	a1,ffffffffc0205e5c <do_fork+0x268>
ffffffffc0205e56:	00d82023          	sw	a3,0(a6)
ffffffffc0205e5a:	8536                	mv	a0,a3
ffffffffc0205e5c:	ec0884e3          	beqz	a7,ffffffffc0205d24 <do_fork+0x130>
ffffffffc0205e60:	00c32023          	sw	a2,0(t1)
ffffffffc0205e64:	b5c1                	j	ffffffffc0205d24 <do_fork+0x130>
ffffffffc0205e66:	89ba                	mv	s3,a4
ffffffffc0205e68:	bdfd                	j	ffffffffc0205d66 <do_fork+0x172>
ffffffffc0205e6a:	be2ff0ef          	jal	ra,ffffffffc020524c <files_create>
ffffffffc0205e6e:	892a                	mv	s2,a0
ffffffffc0205e70:	c911                	beqz	a0,ffffffffc0205e84 <do_fork+0x290>
ffffffffc0205e72:	85e2                	mv	a1,s8
ffffffffc0205e74:	d10ff0ef          	jal	ra,ffffffffc0205384 <dup_files>
ffffffffc0205e78:	8c4a                	mv	s8,s2
ffffffffc0205e7a:	e4050ae3          	beqz	a0,ffffffffc0205cce <do_fork+0xda>
ffffffffc0205e7e:	854a                	mv	a0,s2
ffffffffc0205e80:	c02ff0ef          	jal	ra,ffffffffc0205282 <files_destroy>
ffffffffc0205e84:	14843503          	ld	a0,328(s0)
ffffffffc0205e88:	c94d                	beqz	a0,ffffffffc0205f3a <do_fork+0x346>
ffffffffc0205e8a:	491c                	lw	a5,16(a0)
ffffffffc0205e8c:	fff7871b          	addiw	a4,a5,-1
ffffffffc0205e90:	c918                	sw	a4,16(a0)
ffffffffc0205e92:	e745                	bnez	a4,ffffffffc0205f3a <do_fork+0x346>
ffffffffc0205e94:	beeff0ef          	jal	ra,ffffffffc0205282 <files_destroy>
ffffffffc0205e98:	a04d                	j	ffffffffc0205f3a <do_fork+0x346>
ffffffffc0205e9a:	dedfd0ef          	jal	ra,ffffffffc0203c86 <mm_create>
ffffffffc0205e9e:	8daa                	mv	s11,a0
ffffffffc0205ea0:	cd49                	beqz	a0,ffffffffc0205f3a <do_fork+0x346>
ffffffffc0205ea2:	4505                	li	a0,1
ffffffffc0205ea4:	ac8fc0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0205ea8:	c551                	beqz	a0,ffffffffc0205f34 <do_fork+0x340>
ffffffffc0205eaa:	000b3683          	ld	a3,0(s6)
ffffffffc0205eae:	000bb703          	ld	a4,0(s7)
ffffffffc0205eb2:	40d506b3          	sub	a3,a0,a3
ffffffffc0205eb6:	8699                	srai	a3,a3,0x6
ffffffffc0205eb8:	96d6                	add	a3,a3,s5
ffffffffc0205eba:	0186fc33          	and	s8,a3,s8
ffffffffc0205ebe:	06b2                	slli	a3,a3,0xc
ffffffffc0205ec0:	10ec7b63          	bgeu	s8,a4,ffffffffc0205fd6 <do_fork+0x3e2>
ffffffffc0205ec4:	000d3c03          	ld	s8,0(s10)
ffffffffc0205ec8:	6605                	lui	a2,0x1
ffffffffc0205eca:	00091597          	auipc	a1,0x91
ffffffffc0205ece:	9ce5b583          	ld	a1,-1586(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0205ed2:	9c36                	add	s8,s8,a3
ffffffffc0205ed4:	8562                	mv	a0,s8
ffffffffc0205ed6:	716050ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc0205eda:	03848713          	addi	a4,s1,56
ffffffffc0205ede:	853a                	mv	a0,a4
ffffffffc0205ee0:	018dbc23          	sd	s8,24(s11)
ffffffffc0205ee4:	e43a                	sd	a4,8(sp)
ffffffffc0205ee6:	efcfe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0205eea:	000cb683          	ld	a3,0(s9)
ffffffffc0205eee:	6722                	ld	a4,8(sp)
ffffffffc0205ef0:	c299                	beqz	a3,ffffffffc0205ef6 <do_fork+0x302>
ffffffffc0205ef2:	42d4                	lw	a3,4(a3)
ffffffffc0205ef4:	c8b4                	sw	a3,80(s1)
ffffffffc0205ef6:	85a6                	mv	a1,s1
ffffffffc0205ef8:	856e                	mv	a0,s11
ffffffffc0205efa:	e43a                	sd	a4,8(sp)
ffffffffc0205efc:	fdbfd0ef          	jal	ra,ffffffffc0203ed6 <dup_mmap>
ffffffffc0205f00:	6722                	ld	a4,8(sp)
ffffffffc0205f02:	8c2a                	mv	s8,a0
ffffffffc0205f04:	853a                	mv	a0,a4
ffffffffc0205f06:	ed8fe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0205f0a:	0404a823          	sw	zero,80(s1)
ffffffffc0205f0e:	000c1c63          	bnez	s8,ffffffffc0205f26 <do_fork+0x332>
ffffffffc0205f12:	84ee                	mv	s1,s11
ffffffffc0205f14:	b361                	j	ffffffffc0205c9c <do_fork+0xa8>
ffffffffc0205f16:	d57fa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0205f1a:	bd7d                	j	ffffffffc0205dd8 <do_fork+0x1e4>
ffffffffc0205f1c:	01d6c363          	blt	a3,t4,ffffffffc0205f22 <do_fork+0x32e>
ffffffffc0205f20:	4685                	li	a3,1
ffffffffc0205f22:	4585                	li	a1,1
ffffffffc0205f24:	bdf5                	j	ffffffffc0205e20 <do_fork+0x22c>
ffffffffc0205f26:	856e                	mv	a0,s11
ffffffffc0205f28:	848fe0ef          	jal	ra,ffffffffc0203f70 <exit_mmap>
ffffffffc0205f2c:	018db503          	ld	a0,24(s11)
ffffffffc0205f30:	bdfff0ef          	jal	ra,ffffffffc0205b0e <put_pgdir.isra.0>
ffffffffc0205f34:	856e                	mv	a0,s11
ffffffffc0205f36:	e9ffd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc0205f3a:	6814                	ld	a3,16(s0)
ffffffffc0205f3c:	c02007b7          	lui	a5,0xc0200
ffffffffc0205f40:	06f6ef63          	bltu	a3,a5,ffffffffc0205fbe <do_fork+0x3ca>
ffffffffc0205f44:	000d3783          	ld	a5,0(s10)
ffffffffc0205f48:	000bb703          	ld	a4,0(s7)
ffffffffc0205f4c:	40f687b3          	sub	a5,a3,a5
ffffffffc0205f50:	83b1                	srli	a5,a5,0xc
ffffffffc0205f52:	04e7fa63          	bgeu	a5,a4,ffffffffc0205fa6 <do_fork+0x3b2>
ffffffffc0205f56:	000b3503          	ld	a0,0(s6)
ffffffffc0205f5a:	415787b3          	sub	a5,a5,s5
ffffffffc0205f5e:	079a                	slli	a5,a5,0x6
ffffffffc0205f60:	4589                	li	a1,2
ffffffffc0205f62:	953e                	add	a0,a0,a5
ffffffffc0205f64:	a46fc0ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0205f68:	8522                	mv	a0,s0
ffffffffc0205f6a:	8d4fc0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0205f6e:	5571                	li	a0,-4
ffffffffc0205f70:	b5ad                	j	ffffffffc0205dda <do_fork+0x1e6>
ffffffffc0205f72:	d01fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0205f76:	4a85                	li	s5,1
ffffffffc0205f78:	bb85                	j	ffffffffc0205ce8 <do_fork+0xf4>
ffffffffc0205f7a:	c599                	beqz	a1,ffffffffc0205f88 <do_fork+0x394>
ffffffffc0205f7c:	00d82023          	sw	a3,0(a6)
ffffffffc0205f80:	8536                	mv	a0,a3
ffffffffc0205f82:	b34d                	j	ffffffffc0205d24 <do_fork+0x130>
ffffffffc0205f84:	556d                	li	a0,-5
ffffffffc0205f86:	bd91                	j	ffffffffc0205dda <do_fork+0x1e6>
ffffffffc0205f88:	00082503          	lw	a0,0(a6)
ffffffffc0205f8c:	bb61                	j	ffffffffc0205d24 <do_fork+0x130>
ffffffffc0205f8e:	00006617          	auipc	a2,0x6
ffffffffc0205f92:	6ba60613          	addi	a2,a2,1722 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0205f96:	1b400593          	li	a1,436
ffffffffc0205f9a:	00007517          	auipc	a0,0x7
ffffffffc0205f9e:	5e650513          	addi	a0,a0,1510 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0205fa2:	cfcfa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205fa6:	00006617          	auipc	a2,0x6
ffffffffc0205faa:	6ca60613          	addi	a2,a2,1738 # ffffffffc020c670 <default_pmm_manager+0x108>
ffffffffc0205fae:	06900593          	li	a1,105
ffffffffc0205fb2:	00006517          	auipc	a0,0x6
ffffffffc0205fb6:	61650513          	addi	a0,a0,1558 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0205fba:	ce4fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205fbe:	00006617          	auipc	a2,0x6
ffffffffc0205fc2:	68a60613          	addi	a2,a2,1674 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0205fc6:	07700593          	li	a1,119
ffffffffc0205fca:	00006517          	auipc	a0,0x6
ffffffffc0205fce:	5fe50513          	addi	a0,a0,1534 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0205fd2:	cccfa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205fd6:	00006617          	auipc	a2,0x6
ffffffffc0205fda:	5ca60613          	addi	a2,a2,1482 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0205fde:	07100593          	li	a1,113
ffffffffc0205fe2:	00006517          	auipc	a0,0x6
ffffffffc0205fe6:	5e650513          	addi	a0,a0,1510 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0205fea:	cb4fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0205fee:	00007697          	auipc	a3,0x7
ffffffffc0205ff2:	5aa68693          	addi	a3,a3,1450 # ffffffffc020d598 <CSWTCH.79+0x108>
ffffffffc0205ff6:	00006617          	auipc	a2,0x6
ffffffffc0205ffa:	a8a60613          	addi	a2,a2,-1398 # ffffffffc020ba80 <commands+0x210>
ffffffffc0205ffe:	1d400593          	li	a1,468
ffffffffc0206002:	00007517          	auipc	a0,0x7
ffffffffc0206006:	57e50513          	addi	a0,a0,1406 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc020600a:	c94fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020600e <kernel_thread>:
ffffffffc020600e:	7129                	addi	sp,sp,-320
ffffffffc0206010:	fa22                	sd	s0,304(sp)
ffffffffc0206012:	f626                	sd	s1,296(sp)
ffffffffc0206014:	f24a                	sd	s2,288(sp)
ffffffffc0206016:	84ae                	mv	s1,a1
ffffffffc0206018:	892a                	mv	s2,a0
ffffffffc020601a:	8432                	mv	s0,a2
ffffffffc020601c:	4581                	li	a1,0
ffffffffc020601e:	12000613          	li	a2,288
ffffffffc0206022:	850a                	mv	a0,sp
ffffffffc0206024:	fe06                	sd	ra,312(sp)
ffffffffc0206026:	574050ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc020602a:	e0ca                	sd	s2,64(sp)
ffffffffc020602c:	e4a6                	sd	s1,72(sp)
ffffffffc020602e:	100027f3          	csrr	a5,sstatus
ffffffffc0206032:	edd7f793          	andi	a5,a5,-291
ffffffffc0206036:	1207e793          	ori	a5,a5,288
ffffffffc020603a:	e23e                	sd	a5,256(sp)
ffffffffc020603c:	860a                	mv	a2,sp
ffffffffc020603e:	10046513          	ori	a0,s0,256
ffffffffc0206042:	00000797          	auipc	a5,0x0
ffffffffc0206046:	a0878793          	addi	a5,a5,-1528 # ffffffffc0205a4a <kernel_thread_entry>
ffffffffc020604a:	4581                	li	a1,0
ffffffffc020604c:	e63e                	sd	a5,264(sp)
ffffffffc020604e:	ba7ff0ef          	jal	ra,ffffffffc0205bf4 <do_fork>
ffffffffc0206052:	70f2                	ld	ra,312(sp)
ffffffffc0206054:	7452                	ld	s0,304(sp)
ffffffffc0206056:	74b2                	ld	s1,296(sp)
ffffffffc0206058:	7912                	ld	s2,288(sp)
ffffffffc020605a:	6131                	addi	sp,sp,320
ffffffffc020605c:	8082                	ret

ffffffffc020605e <do_exit>:
ffffffffc020605e:	7179                	addi	sp,sp,-48
ffffffffc0206060:	f022                	sd	s0,32(sp)
ffffffffc0206062:	00091417          	auipc	s0,0x91
ffffffffc0206066:	85e40413          	addi	s0,s0,-1954 # ffffffffc02968c0 <current>
ffffffffc020606a:	601c                	ld	a5,0(s0)
ffffffffc020606c:	f406                	sd	ra,40(sp)
ffffffffc020606e:	ec26                	sd	s1,24(sp)
ffffffffc0206070:	e84a                	sd	s2,16(sp)
ffffffffc0206072:	e44e                	sd	s3,8(sp)
ffffffffc0206074:	e052                	sd	s4,0(sp)
ffffffffc0206076:	00091717          	auipc	a4,0x91
ffffffffc020607a:	85273703          	ld	a4,-1966(a4) # ffffffffc02968c8 <idleproc>
ffffffffc020607e:	0ee78763          	beq	a5,a4,ffffffffc020616c <do_exit+0x10e>
ffffffffc0206082:	00091497          	auipc	s1,0x91
ffffffffc0206086:	84e48493          	addi	s1,s1,-1970 # ffffffffc02968d0 <initproc>
ffffffffc020608a:	6098                	ld	a4,0(s1)
ffffffffc020608c:	10e78763          	beq	a5,a4,ffffffffc020619a <do_exit+0x13c>
ffffffffc0206090:	0287b983          	ld	s3,40(a5)
ffffffffc0206094:	892a                	mv	s2,a0
ffffffffc0206096:	02098e63          	beqz	s3,ffffffffc02060d2 <do_exit+0x74>
ffffffffc020609a:	00090797          	auipc	a5,0x90
ffffffffc020609e:	7f67b783          	ld	a5,2038(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc02060a2:	577d                	li	a4,-1
ffffffffc02060a4:	177e                	slli	a4,a4,0x3f
ffffffffc02060a6:	83b1                	srli	a5,a5,0xc
ffffffffc02060a8:	8fd9                	or	a5,a5,a4
ffffffffc02060aa:	18079073          	csrw	satp,a5
ffffffffc02060ae:	0309a783          	lw	a5,48(s3)
ffffffffc02060b2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02060b6:	02e9a823          	sw	a4,48(s3)
ffffffffc02060ba:	c769                	beqz	a4,ffffffffc0206184 <do_exit+0x126>
ffffffffc02060bc:	601c                	ld	a5,0(s0)
ffffffffc02060be:	1487b503          	ld	a0,328(a5)
ffffffffc02060c2:	0207b423          	sd	zero,40(a5)
ffffffffc02060c6:	c511                	beqz	a0,ffffffffc02060d2 <do_exit+0x74>
ffffffffc02060c8:	491c                	lw	a5,16(a0)
ffffffffc02060ca:	fff7871b          	addiw	a4,a5,-1
ffffffffc02060ce:	c918                	sw	a4,16(a0)
ffffffffc02060d0:	cb59                	beqz	a4,ffffffffc0206166 <do_exit+0x108>
ffffffffc02060d2:	601c                	ld	a5,0(s0)
ffffffffc02060d4:	470d                	li	a4,3
ffffffffc02060d6:	c398                	sw	a4,0(a5)
ffffffffc02060d8:	0f27a423          	sw	s2,232(a5)
ffffffffc02060dc:	100027f3          	csrr	a5,sstatus
ffffffffc02060e0:	8b89                	andi	a5,a5,2
ffffffffc02060e2:	4a01                	li	s4,0
ffffffffc02060e4:	e7f9                	bnez	a5,ffffffffc02061b2 <do_exit+0x154>
ffffffffc02060e6:	6018                	ld	a4,0(s0)
ffffffffc02060e8:	800007b7          	lui	a5,0x80000
ffffffffc02060ec:	0785                	addi	a5,a5,1
ffffffffc02060ee:	7308                	ld	a0,32(a4)
ffffffffc02060f0:	0ec52703          	lw	a4,236(a0)
ffffffffc02060f4:	0cf70363          	beq	a4,a5,ffffffffc02061ba <do_exit+0x15c>
ffffffffc02060f8:	6018                	ld	a4,0(s0)
ffffffffc02060fa:	7b7c                	ld	a5,240(a4)
ffffffffc02060fc:	c3a1                	beqz	a5,ffffffffc020613c <do_exit+0xde>
ffffffffc02060fe:	800009b7          	lui	s3,0x80000
ffffffffc0206102:	490d                	li	s2,3
ffffffffc0206104:	0985                	addi	s3,s3,1
ffffffffc0206106:	a021                	j	ffffffffc020610e <do_exit+0xb0>
ffffffffc0206108:	6018                	ld	a4,0(s0)
ffffffffc020610a:	7b7c                	ld	a5,240(a4)
ffffffffc020610c:	cb85                	beqz	a5,ffffffffc020613c <do_exit+0xde>
ffffffffc020610e:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc0206112:	6088                	ld	a0,0(s1)
ffffffffc0206114:	fb74                	sd	a3,240(a4)
ffffffffc0206116:	7978                	ld	a4,240(a0)
ffffffffc0206118:	0e07bc23          	sd	zero,248(a5)
ffffffffc020611c:	10e7b023          	sd	a4,256(a5)
ffffffffc0206120:	c311                	beqz	a4,ffffffffc0206124 <do_exit+0xc6>
ffffffffc0206122:	ff7c                	sd	a5,248(a4)
ffffffffc0206124:	4398                	lw	a4,0(a5)
ffffffffc0206126:	f388                	sd	a0,32(a5)
ffffffffc0206128:	f97c                	sd	a5,240(a0)
ffffffffc020612a:	fd271fe3          	bne	a4,s2,ffffffffc0206108 <do_exit+0xaa>
ffffffffc020612e:	0ec52783          	lw	a5,236(a0)
ffffffffc0206132:	fd379be3          	bne	a5,s3,ffffffffc0206108 <do_exit+0xaa>
ffffffffc0206136:	234010ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc020613a:	b7f9                	j	ffffffffc0206108 <do_exit+0xaa>
ffffffffc020613c:	020a1263          	bnez	s4,ffffffffc0206160 <do_exit+0x102>
ffffffffc0206140:	2dc010ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc0206144:	601c                	ld	a5,0(s0)
ffffffffc0206146:	00007617          	auipc	a2,0x7
ffffffffc020614a:	48a60613          	addi	a2,a2,1162 # ffffffffc020d5d0 <CSWTCH.79+0x140>
ffffffffc020614e:	29c00593          	li	a1,668
ffffffffc0206152:	43d4                	lw	a3,4(a5)
ffffffffc0206154:	00007517          	auipc	a0,0x7
ffffffffc0206158:	42c50513          	addi	a0,a0,1068 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc020615c:	b42fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206160:	b0dfa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0206164:	bff1                	j	ffffffffc0206140 <do_exit+0xe2>
ffffffffc0206166:	91cff0ef          	jal	ra,ffffffffc0205282 <files_destroy>
ffffffffc020616a:	b7a5                	j	ffffffffc02060d2 <do_exit+0x74>
ffffffffc020616c:	00007617          	auipc	a2,0x7
ffffffffc0206170:	44460613          	addi	a2,a2,1092 # ffffffffc020d5b0 <CSWTCH.79+0x120>
ffffffffc0206174:	26700593          	li	a1,615
ffffffffc0206178:	00007517          	auipc	a0,0x7
ffffffffc020617c:	40850513          	addi	a0,a0,1032 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206180:	b1efa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206184:	854e                	mv	a0,s3
ffffffffc0206186:	debfd0ef          	jal	ra,ffffffffc0203f70 <exit_mmap>
ffffffffc020618a:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc020618e:	981ff0ef          	jal	ra,ffffffffc0205b0e <put_pgdir.isra.0>
ffffffffc0206192:	854e                	mv	a0,s3
ffffffffc0206194:	c41fd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc0206198:	b715                	j	ffffffffc02060bc <do_exit+0x5e>
ffffffffc020619a:	00007617          	auipc	a2,0x7
ffffffffc020619e:	42660613          	addi	a2,a2,1062 # ffffffffc020d5c0 <CSWTCH.79+0x130>
ffffffffc02061a2:	26b00593          	li	a1,619
ffffffffc02061a6:	00007517          	auipc	a0,0x7
ffffffffc02061aa:	3da50513          	addi	a0,a0,986 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc02061ae:	af0fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02061b2:	ac1fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02061b6:	4a05                	li	s4,1
ffffffffc02061b8:	b73d                	j	ffffffffc02060e6 <do_exit+0x88>
ffffffffc02061ba:	1b0010ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc02061be:	bf2d                	j	ffffffffc02060f8 <do_exit+0x9a>

ffffffffc02061c0 <do_wait.part.0>:
ffffffffc02061c0:	715d                	addi	sp,sp,-80
ffffffffc02061c2:	f84a                	sd	s2,48(sp)
ffffffffc02061c4:	f44e                	sd	s3,40(sp)
ffffffffc02061c6:	80000937          	lui	s2,0x80000
ffffffffc02061ca:	6989                	lui	s3,0x2
ffffffffc02061cc:	fc26                	sd	s1,56(sp)
ffffffffc02061ce:	f052                	sd	s4,32(sp)
ffffffffc02061d0:	ec56                	sd	s5,24(sp)
ffffffffc02061d2:	e85a                	sd	s6,16(sp)
ffffffffc02061d4:	e45e                	sd	s7,8(sp)
ffffffffc02061d6:	e486                	sd	ra,72(sp)
ffffffffc02061d8:	e0a2                	sd	s0,64(sp)
ffffffffc02061da:	84aa                	mv	s1,a0
ffffffffc02061dc:	8a2e                	mv	s4,a1
ffffffffc02061de:	00090b97          	auipc	s7,0x90
ffffffffc02061e2:	6e2b8b93          	addi	s7,s7,1762 # ffffffffc02968c0 <current>
ffffffffc02061e6:	00050b1b          	sext.w	s6,a0
ffffffffc02061ea:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02061ee:	19f9                	addi	s3,s3,-2
ffffffffc02061f0:	0905                	addi	s2,s2,1
ffffffffc02061f2:	ccbd                	beqz	s1,ffffffffc0206270 <do_wait.part.0+0xb0>
ffffffffc02061f4:	0359e863          	bltu	s3,s5,ffffffffc0206224 <do_wait.part.0+0x64>
ffffffffc02061f8:	45a9                	li	a1,10
ffffffffc02061fa:	855a                	mv	a0,s6
ffffffffc02061fc:	66b040ef          	jal	ra,ffffffffc020b066 <hash32>
ffffffffc0206200:	02051793          	slli	a5,a0,0x20
ffffffffc0206204:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206208:	0008b797          	auipc	a5,0x8b
ffffffffc020620c:	5b878793          	addi	a5,a5,1464 # ffffffffc02917c0 <hash_list>
ffffffffc0206210:	953e                	add	a0,a0,a5
ffffffffc0206212:	842a                	mv	s0,a0
ffffffffc0206214:	a029                	j	ffffffffc020621e <do_wait.part.0+0x5e>
ffffffffc0206216:	f2c42783          	lw	a5,-212(s0)
ffffffffc020621a:	02978163          	beq	a5,s1,ffffffffc020623c <do_wait.part.0+0x7c>
ffffffffc020621e:	6400                	ld	s0,8(s0)
ffffffffc0206220:	fe851be3          	bne	a0,s0,ffffffffc0206216 <do_wait.part.0+0x56>
ffffffffc0206224:	5579                	li	a0,-2
ffffffffc0206226:	60a6                	ld	ra,72(sp)
ffffffffc0206228:	6406                	ld	s0,64(sp)
ffffffffc020622a:	74e2                	ld	s1,56(sp)
ffffffffc020622c:	7942                	ld	s2,48(sp)
ffffffffc020622e:	79a2                	ld	s3,40(sp)
ffffffffc0206230:	7a02                	ld	s4,32(sp)
ffffffffc0206232:	6ae2                	ld	s5,24(sp)
ffffffffc0206234:	6b42                	ld	s6,16(sp)
ffffffffc0206236:	6ba2                	ld	s7,8(sp)
ffffffffc0206238:	6161                	addi	sp,sp,80
ffffffffc020623a:	8082                	ret
ffffffffc020623c:	000bb683          	ld	a3,0(s7)
ffffffffc0206240:	f4843783          	ld	a5,-184(s0)
ffffffffc0206244:	fed790e3          	bne	a5,a3,ffffffffc0206224 <do_wait.part.0+0x64>
ffffffffc0206248:	f2842703          	lw	a4,-216(s0)
ffffffffc020624c:	478d                	li	a5,3
ffffffffc020624e:	0ef70b63          	beq	a4,a5,ffffffffc0206344 <do_wait.part.0+0x184>
ffffffffc0206252:	4785                	li	a5,1
ffffffffc0206254:	c29c                	sw	a5,0(a3)
ffffffffc0206256:	0f26a623          	sw	s2,236(a3)
ffffffffc020625a:	1c2010ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc020625e:	000bb783          	ld	a5,0(s7)
ffffffffc0206262:	0b07a783          	lw	a5,176(a5)
ffffffffc0206266:	8b85                	andi	a5,a5,1
ffffffffc0206268:	d7c9                	beqz	a5,ffffffffc02061f2 <do_wait.part.0+0x32>
ffffffffc020626a:	555d                	li	a0,-9
ffffffffc020626c:	df3ff0ef          	jal	ra,ffffffffc020605e <do_exit>
ffffffffc0206270:	000bb683          	ld	a3,0(s7)
ffffffffc0206274:	7ae0                	ld	s0,240(a3)
ffffffffc0206276:	d45d                	beqz	s0,ffffffffc0206224 <do_wait.part.0+0x64>
ffffffffc0206278:	470d                	li	a4,3
ffffffffc020627a:	a021                	j	ffffffffc0206282 <do_wait.part.0+0xc2>
ffffffffc020627c:	10043403          	ld	s0,256(s0)
ffffffffc0206280:	d869                	beqz	s0,ffffffffc0206252 <do_wait.part.0+0x92>
ffffffffc0206282:	401c                	lw	a5,0(s0)
ffffffffc0206284:	fee79ce3          	bne	a5,a4,ffffffffc020627c <do_wait.part.0+0xbc>
ffffffffc0206288:	00090797          	auipc	a5,0x90
ffffffffc020628c:	6407b783          	ld	a5,1600(a5) # ffffffffc02968c8 <idleproc>
ffffffffc0206290:	0c878963          	beq	a5,s0,ffffffffc0206362 <do_wait.part.0+0x1a2>
ffffffffc0206294:	00090797          	auipc	a5,0x90
ffffffffc0206298:	63c7b783          	ld	a5,1596(a5) # ffffffffc02968d0 <initproc>
ffffffffc020629c:	0cf40363          	beq	s0,a5,ffffffffc0206362 <do_wait.part.0+0x1a2>
ffffffffc02062a0:	000a0663          	beqz	s4,ffffffffc02062ac <do_wait.part.0+0xec>
ffffffffc02062a4:	0e842783          	lw	a5,232(s0)
ffffffffc02062a8:	00fa2023          	sw	a5,0(s4)
ffffffffc02062ac:	100027f3          	csrr	a5,sstatus
ffffffffc02062b0:	8b89                	andi	a5,a5,2
ffffffffc02062b2:	4581                	li	a1,0
ffffffffc02062b4:	e7c1                	bnez	a5,ffffffffc020633c <do_wait.part.0+0x17c>
ffffffffc02062b6:	6c70                	ld	a2,216(s0)
ffffffffc02062b8:	7074                	ld	a3,224(s0)
ffffffffc02062ba:	10043703          	ld	a4,256(s0)
ffffffffc02062be:	7c7c                	ld	a5,248(s0)
ffffffffc02062c0:	e614                	sd	a3,8(a2)
ffffffffc02062c2:	e290                	sd	a2,0(a3)
ffffffffc02062c4:	6470                	ld	a2,200(s0)
ffffffffc02062c6:	6874                	ld	a3,208(s0)
ffffffffc02062c8:	e614                	sd	a3,8(a2)
ffffffffc02062ca:	e290                	sd	a2,0(a3)
ffffffffc02062cc:	c319                	beqz	a4,ffffffffc02062d2 <do_wait.part.0+0x112>
ffffffffc02062ce:	ff7c                	sd	a5,248(a4)
ffffffffc02062d0:	7c7c                	ld	a5,248(s0)
ffffffffc02062d2:	c3b5                	beqz	a5,ffffffffc0206336 <do_wait.part.0+0x176>
ffffffffc02062d4:	10e7b023          	sd	a4,256(a5)
ffffffffc02062d8:	00090717          	auipc	a4,0x90
ffffffffc02062dc:	60070713          	addi	a4,a4,1536 # ffffffffc02968d8 <nr_process>
ffffffffc02062e0:	431c                	lw	a5,0(a4)
ffffffffc02062e2:	37fd                	addiw	a5,a5,-1
ffffffffc02062e4:	c31c                	sw	a5,0(a4)
ffffffffc02062e6:	e5a9                	bnez	a1,ffffffffc0206330 <do_wait.part.0+0x170>
ffffffffc02062e8:	6814                	ld	a3,16(s0)
ffffffffc02062ea:	c02007b7          	lui	a5,0xc0200
ffffffffc02062ee:	04f6ee63          	bltu	a3,a5,ffffffffc020634a <do_wait.part.0+0x18a>
ffffffffc02062f2:	00090797          	auipc	a5,0x90
ffffffffc02062f6:	5c67b783          	ld	a5,1478(a5) # ffffffffc02968b8 <va_pa_offset>
ffffffffc02062fa:	8e9d                	sub	a3,a3,a5
ffffffffc02062fc:	82b1                	srli	a3,a3,0xc
ffffffffc02062fe:	00090797          	auipc	a5,0x90
ffffffffc0206302:	5a27b783          	ld	a5,1442(a5) # ffffffffc02968a0 <npage>
ffffffffc0206306:	06f6fa63          	bgeu	a3,a5,ffffffffc020637a <do_wait.part.0+0x1ba>
ffffffffc020630a:	00009517          	auipc	a0,0x9
ffffffffc020630e:	5c653503          	ld	a0,1478(a0) # ffffffffc020f8d0 <nbase>
ffffffffc0206312:	8e89                	sub	a3,a3,a0
ffffffffc0206314:	069a                	slli	a3,a3,0x6
ffffffffc0206316:	00090517          	auipc	a0,0x90
ffffffffc020631a:	59253503          	ld	a0,1426(a0) # ffffffffc02968a8 <pages>
ffffffffc020631e:	9536                	add	a0,a0,a3
ffffffffc0206320:	4589                	li	a1,2
ffffffffc0206322:	e89fb0ef          	jal	ra,ffffffffc02021aa <free_pages>
ffffffffc0206326:	8522                	mv	a0,s0
ffffffffc0206328:	d17fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020632c:	4501                	li	a0,0
ffffffffc020632e:	bde5                	j	ffffffffc0206226 <do_wait.part.0+0x66>
ffffffffc0206330:	93dfa0ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0206334:	bf55                	j	ffffffffc02062e8 <do_wait.part.0+0x128>
ffffffffc0206336:	701c                	ld	a5,32(s0)
ffffffffc0206338:	fbf8                	sd	a4,240(a5)
ffffffffc020633a:	bf79                	j	ffffffffc02062d8 <do_wait.part.0+0x118>
ffffffffc020633c:	937fa0ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0206340:	4585                	li	a1,1
ffffffffc0206342:	bf95                	j	ffffffffc02062b6 <do_wait.part.0+0xf6>
ffffffffc0206344:	f2840413          	addi	s0,s0,-216
ffffffffc0206348:	b781                	j	ffffffffc0206288 <do_wait.part.0+0xc8>
ffffffffc020634a:	00006617          	auipc	a2,0x6
ffffffffc020634e:	2fe60613          	addi	a2,a2,766 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0206352:	07700593          	li	a1,119
ffffffffc0206356:	00006517          	auipc	a0,0x6
ffffffffc020635a:	27250513          	addi	a0,a0,626 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc020635e:	940fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206362:	00007617          	auipc	a2,0x7
ffffffffc0206366:	28e60613          	addi	a2,a2,654 # ffffffffc020d5f0 <CSWTCH.79+0x160>
ffffffffc020636a:	44c00593          	li	a1,1100
ffffffffc020636e:	00007517          	auipc	a0,0x7
ffffffffc0206372:	21250513          	addi	a0,a0,530 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206376:	928fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020637a:	00006617          	auipc	a2,0x6
ffffffffc020637e:	2f660613          	addi	a2,a2,758 # ffffffffc020c670 <default_pmm_manager+0x108>
ffffffffc0206382:	06900593          	li	a1,105
ffffffffc0206386:	00006517          	auipc	a0,0x6
ffffffffc020638a:	24250513          	addi	a0,a0,578 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc020638e:	910fa0ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206392 <init_main>:
ffffffffc0206392:	1141                	addi	sp,sp,-16
ffffffffc0206394:	00007517          	auipc	a0,0x7
ffffffffc0206398:	27c50513          	addi	a0,a0,636 # ffffffffc020d610 <CSWTCH.79+0x180>
ffffffffc020639c:	e406                	sd	ra,8(sp)
ffffffffc020639e:	7ee010ef          	jal	ra,ffffffffc0207b8c <vfs_set_bootfs>
ffffffffc02063a2:	e179                	bnez	a0,ffffffffc0206468 <init_main+0xd6>
ffffffffc02063a4:	e47fb0ef          	jal	ra,ffffffffc02021ea <nr_free_pages>
ffffffffc02063a8:	be3fb0ef          	jal	ra,ffffffffc0201f8a <kallocated>
ffffffffc02063ac:	4601                	li	a2,0
ffffffffc02063ae:	4581                	li	a1,0
ffffffffc02063b0:	00001517          	auipc	a0,0x1
ffffffffc02063b4:	a1450513          	addi	a0,a0,-1516 # ffffffffc0206dc4 <user_main>
ffffffffc02063b8:	c57ff0ef          	jal	ra,ffffffffc020600e <kernel_thread>
ffffffffc02063bc:	00a04563          	bgtz	a0,ffffffffc02063c6 <init_main+0x34>
ffffffffc02063c0:	a841                	j	ffffffffc0206450 <init_main+0xbe>
ffffffffc02063c2:	05a010ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc02063c6:	4581                	li	a1,0
ffffffffc02063c8:	4501                	li	a0,0
ffffffffc02063ca:	df7ff0ef          	jal	ra,ffffffffc02061c0 <do_wait.part.0>
ffffffffc02063ce:	d975                	beqz	a0,ffffffffc02063c2 <init_main+0x30>
ffffffffc02063d0:	e6dfe0ef          	jal	ra,ffffffffc020523c <fs_cleanup>
ffffffffc02063d4:	00007517          	auipc	a0,0x7
ffffffffc02063d8:	28450513          	addi	a0,a0,644 # ffffffffc020d658 <CSWTCH.79+0x1c8>
ffffffffc02063dc:	dcbf90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02063e0:	00090797          	auipc	a5,0x90
ffffffffc02063e4:	4f07b783          	ld	a5,1264(a5) # ffffffffc02968d0 <initproc>
ffffffffc02063e8:	7bf8                	ld	a4,240(a5)
ffffffffc02063ea:	e339                	bnez	a4,ffffffffc0206430 <init_main+0x9e>
ffffffffc02063ec:	7ff8                	ld	a4,248(a5)
ffffffffc02063ee:	e329                	bnez	a4,ffffffffc0206430 <init_main+0x9e>
ffffffffc02063f0:	1007b703          	ld	a4,256(a5)
ffffffffc02063f4:	ef15                	bnez	a4,ffffffffc0206430 <init_main+0x9e>
ffffffffc02063f6:	00090697          	auipc	a3,0x90
ffffffffc02063fa:	4e26a683          	lw	a3,1250(a3) # ffffffffc02968d8 <nr_process>
ffffffffc02063fe:	4709                	li	a4,2
ffffffffc0206400:	0ce69163          	bne	a3,a4,ffffffffc02064c2 <init_main+0x130>
ffffffffc0206404:	0008f717          	auipc	a4,0x8f
ffffffffc0206408:	3bc70713          	addi	a4,a4,956 # ffffffffc02957c0 <proc_list>
ffffffffc020640c:	6714                	ld	a3,8(a4)
ffffffffc020640e:	0c878793          	addi	a5,a5,200
ffffffffc0206412:	08d79863          	bne	a5,a3,ffffffffc02064a2 <init_main+0x110>
ffffffffc0206416:	6318                	ld	a4,0(a4)
ffffffffc0206418:	06e79563          	bne	a5,a4,ffffffffc0206482 <init_main+0xf0>
ffffffffc020641c:	00007517          	auipc	a0,0x7
ffffffffc0206420:	32450513          	addi	a0,a0,804 # ffffffffc020d740 <CSWTCH.79+0x2b0>
ffffffffc0206424:	d83f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206428:	60a2                	ld	ra,8(sp)
ffffffffc020642a:	4501                	li	a0,0
ffffffffc020642c:	0141                	addi	sp,sp,16
ffffffffc020642e:	8082                	ret
ffffffffc0206430:	00007697          	auipc	a3,0x7
ffffffffc0206434:	25068693          	addi	a3,a3,592 # ffffffffc020d680 <CSWTCH.79+0x1f0>
ffffffffc0206438:	00005617          	auipc	a2,0x5
ffffffffc020643c:	64860613          	addi	a2,a2,1608 # ffffffffc020ba80 <commands+0x210>
ffffffffc0206440:	4c200593          	li	a1,1218
ffffffffc0206444:	00007517          	auipc	a0,0x7
ffffffffc0206448:	13c50513          	addi	a0,a0,316 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc020644c:	852fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206450:	00007617          	auipc	a2,0x7
ffffffffc0206454:	1e860613          	addi	a2,a2,488 # ffffffffc020d638 <CSWTCH.79+0x1a8>
ffffffffc0206458:	4b500593          	li	a1,1205
ffffffffc020645c:	00007517          	auipc	a0,0x7
ffffffffc0206460:	12450513          	addi	a0,a0,292 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206464:	83afa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206468:	86aa                	mv	a3,a0
ffffffffc020646a:	00007617          	auipc	a2,0x7
ffffffffc020646e:	1ae60613          	addi	a2,a2,430 # ffffffffc020d618 <CSWTCH.79+0x188>
ffffffffc0206472:	4ad00593          	li	a1,1197
ffffffffc0206476:	00007517          	auipc	a0,0x7
ffffffffc020647a:	10a50513          	addi	a0,a0,266 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc020647e:	820fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206482:	00007697          	auipc	a3,0x7
ffffffffc0206486:	28e68693          	addi	a3,a3,654 # ffffffffc020d710 <CSWTCH.79+0x280>
ffffffffc020648a:	00005617          	auipc	a2,0x5
ffffffffc020648e:	5f660613          	addi	a2,a2,1526 # ffffffffc020ba80 <commands+0x210>
ffffffffc0206492:	4c500593          	li	a1,1221
ffffffffc0206496:	00007517          	auipc	a0,0x7
ffffffffc020649a:	0ea50513          	addi	a0,a0,234 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc020649e:	800fa0ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02064a2:	00007697          	auipc	a3,0x7
ffffffffc02064a6:	23e68693          	addi	a3,a3,574 # ffffffffc020d6e0 <CSWTCH.79+0x250>
ffffffffc02064aa:	00005617          	auipc	a2,0x5
ffffffffc02064ae:	5d660613          	addi	a2,a2,1494 # ffffffffc020ba80 <commands+0x210>
ffffffffc02064b2:	4c400593          	li	a1,1220
ffffffffc02064b6:	00007517          	auipc	a0,0x7
ffffffffc02064ba:	0ca50513          	addi	a0,a0,202 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc02064be:	fe1f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02064c2:	00007697          	auipc	a3,0x7
ffffffffc02064c6:	20e68693          	addi	a3,a3,526 # ffffffffc020d6d0 <CSWTCH.79+0x240>
ffffffffc02064ca:	00005617          	auipc	a2,0x5
ffffffffc02064ce:	5b660613          	addi	a2,a2,1462 # ffffffffc020ba80 <commands+0x210>
ffffffffc02064d2:	4c300593          	li	a1,1219
ffffffffc02064d6:	00007517          	auipc	a0,0x7
ffffffffc02064da:	0aa50513          	addi	a0,a0,170 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc02064de:	fc1f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02064e2 <do_execve>:
ffffffffc02064e2:	c9010113          	addi	sp,sp,-880
ffffffffc02064e6:	33513c23          	sd	s5,824(sp)
ffffffffc02064ea:	00090a97          	auipc	s5,0x90
ffffffffc02064ee:	3d6a8a93          	addi	s5,s5,982 # ffffffffc02968c0 <current>
ffffffffc02064f2:	000ab683          	ld	a3,0(s5)
ffffffffc02064f6:	31913c23          	sd	s9,792(sp)
ffffffffc02064fa:	fff58c9b          	addiw	s9,a1,-1
ffffffffc02064fe:	33613823          	sd	s6,816(sp)
ffffffffc0206502:	36113423          	sd	ra,872(sp)
ffffffffc0206506:	36813023          	sd	s0,864(sp)
ffffffffc020650a:	34913c23          	sd	s1,856(sp)
ffffffffc020650e:	35213823          	sd	s2,848(sp)
ffffffffc0206512:	35313423          	sd	s3,840(sp)
ffffffffc0206516:	35413023          	sd	s4,832(sp)
ffffffffc020651a:	33713423          	sd	s7,808(sp)
ffffffffc020651e:	33813023          	sd	s8,800(sp)
ffffffffc0206522:	31a13823          	sd	s10,784(sp)
ffffffffc0206526:	31b13423          	sd	s11,776(sp)
ffffffffc020652a:	000c871b          	sext.w	a4,s9
ffffffffc020652e:	47fd                	li	a5,31
ffffffffc0206530:	0286bb03          	ld	s6,40(a3)
ffffffffc0206534:	76e7ee63          	bltu	a5,a4,ffffffffc0206cb0 <do_execve+0x7ce>
ffffffffc0206538:	842e                	mv	s0,a1
ffffffffc020653a:	84aa                	mv	s1,a0
ffffffffc020653c:	8bb2                	mv	s7,a2
ffffffffc020653e:	4581                	li	a1,0
ffffffffc0206540:	4641                	li	a2,16
ffffffffc0206542:	1888                	addi	a0,sp,112
ffffffffc0206544:	056050ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0206548:	000b0c63          	beqz	s6,ffffffffc0206560 <do_execve+0x7e>
ffffffffc020654c:	038b0513          	addi	a0,s6,56
ffffffffc0206550:	892fe0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0206554:	000ab783          	ld	a5,0(s5)
ffffffffc0206558:	c781                	beqz	a5,ffffffffc0206560 <do_execve+0x7e>
ffffffffc020655a:	43dc                	lw	a5,4(a5)
ffffffffc020655c:	04fb2823          	sw	a5,80(s6)
ffffffffc0206560:	24048563          	beqz	s1,ffffffffc02067aa <do_execve+0x2c8>
ffffffffc0206564:	46c1                	li	a3,16
ffffffffc0206566:	8626                	mv	a2,s1
ffffffffc0206568:	188c                	addi	a1,sp,112
ffffffffc020656a:	855a                	mv	a0,s6
ffffffffc020656c:	e9ffd0ef          	jal	ra,ffffffffc020440a <copy_string>
ffffffffc0206570:	76050363          	beqz	a0,ffffffffc0206cd6 <do_execve+0x7f4>
ffffffffc0206574:	00341793          	slli	a5,s0,0x3
ffffffffc0206578:	4681                	li	a3,0
ffffffffc020657a:	863e                	mv	a2,a5
ffffffffc020657c:	85de                	mv	a1,s7
ffffffffc020657e:	855a                	mv	a0,s6
ffffffffc0206580:	f43e                	sd	a5,40(sp)
ffffffffc0206582:	d8ffd0ef          	jal	ra,ffffffffc0204310 <user_mem_check>
ffffffffc0206586:	89de                	mv	s3,s7
ffffffffc0206588:	72050863          	beqz	a0,ffffffffc0206cb8 <do_execve+0x7d6>
ffffffffc020658c:	0f810a13          	addi	s4,sp,248
ffffffffc0206590:	4481                	li	s1,0
ffffffffc0206592:	6505                	lui	a0,0x1
ffffffffc0206594:	9fbfb0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0206598:	892a                	mv	s2,a0
ffffffffc020659a:	18050563          	beqz	a0,ffffffffc0206724 <do_execve+0x242>
ffffffffc020659e:	0009b603          	ld	a2,0(s3) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc02065a2:	85aa                	mv	a1,a0
ffffffffc02065a4:	6685                	lui	a3,0x1
ffffffffc02065a6:	855a                	mv	a0,s6
ffffffffc02065a8:	e63fd0ef          	jal	ra,ffffffffc020440a <copy_string>
ffffffffc02065ac:	1e050a63          	beqz	a0,ffffffffc02067a0 <do_execve+0x2be>
ffffffffc02065b0:	012a3023          	sd	s2,0(s4)
ffffffffc02065b4:	2485                	addiw	s1,s1,1
ffffffffc02065b6:	0a21                	addi	s4,s4,8
ffffffffc02065b8:	09a1                	addi	s3,s3,8
ffffffffc02065ba:	fc941ce3          	bne	s0,s1,ffffffffc0206592 <do_execve+0xb0>
ffffffffc02065be:	000bb903          	ld	s2,0(s7)
ffffffffc02065c2:	0e0b0763          	beqz	s6,ffffffffc02066b0 <do_execve+0x1ce>
ffffffffc02065c6:	038b0513          	addi	a0,s6,56
ffffffffc02065ca:	814fe0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02065ce:	000ab783          	ld	a5,0(s5)
ffffffffc02065d2:	040b2823          	sw	zero,80(s6)
ffffffffc02065d6:	1487b503          	ld	a0,328(a5)
ffffffffc02065da:	d3ffe0ef          	jal	ra,ffffffffc0205318 <files_closeall>
ffffffffc02065de:	854a                	mv	a0,s2
ffffffffc02065e0:	4581                	li	a1,0
ffffffffc02065e2:	fc3fe0ef          	jal	ra,ffffffffc02055a4 <sysfile_open>
ffffffffc02065e6:	892a                	mv	s2,a0
ffffffffc02065e8:	1c054e63          	bltz	a0,ffffffffc02067c4 <do_execve+0x2e2>
ffffffffc02065ec:	00090797          	auipc	a5,0x90
ffffffffc02065f0:	2a47b783          	ld	a5,676(a5) # ffffffffc0296890 <boot_pgdir_pa>
ffffffffc02065f4:	577d                	li	a4,-1
ffffffffc02065f6:	177e                	slli	a4,a4,0x3f
ffffffffc02065f8:	83b1                	srli	a5,a5,0xc
ffffffffc02065fa:	8fd9                	or	a5,a5,a4
ffffffffc02065fc:	18079073          	csrw	satp,a5
ffffffffc0206600:	030b2783          	lw	a5,48(s6)
ffffffffc0206604:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206608:	02eb2823          	sw	a4,48(s6)
ffffffffc020660c:	52070263          	beqz	a4,ffffffffc0206b30 <do_execve+0x64e>
ffffffffc0206610:	000ab783          	ld	a5,0(s5)
ffffffffc0206614:	0207b423          	sd	zero,40(a5)
ffffffffc0206618:	e6efd0ef          	jal	ra,ffffffffc0203c86 <mm_create>
ffffffffc020661c:	89aa                	mv	s3,a0
ffffffffc020661e:	c969                	beqz	a0,ffffffffc02066f0 <do_execve+0x20e>
ffffffffc0206620:	4505                	li	a0,1
ffffffffc0206622:	b4bfb0ef          	jal	ra,ffffffffc020216c <alloc_pages>
ffffffffc0206626:	c171                	beqz	a0,ffffffffc02066ea <do_execve+0x208>
ffffffffc0206628:	00090b97          	auipc	s7,0x90
ffffffffc020662c:	280b8b93          	addi	s7,s7,640 # ffffffffc02968a8 <pages>
ffffffffc0206630:	000bb683          	ld	a3,0(s7)
ffffffffc0206634:	00009717          	auipc	a4,0x9
ffffffffc0206638:	29c73703          	ld	a4,668(a4) # ffffffffc020f8d0 <nbase>
ffffffffc020663c:	00090c17          	auipc	s8,0x90
ffffffffc0206640:	264c0c13          	addi	s8,s8,612 # ffffffffc02968a0 <npage>
ffffffffc0206644:	40d506b3          	sub	a3,a0,a3
ffffffffc0206648:	8699                	srai	a3,a3,0x6
ffffffffc020664a:	96ba                	add	a3,a3,a4
ffffffffc020664c:	e83a                	sd	a4,16(sp)
ffffffffc020664e:	000c3783          	ld	a5,0(s8)
ffffffffc0206652:	577d                	li	a4,-1
ffffffffc0206654:	8331                	srli	a4,a4,0xc
ffffffffc0206656:	e43a                	sd	a4,8(sp)
ffffffffc0206658:	8f75                	and	a4,a4,a3
ffffffffc020665a:	06b2                	slli	a3,a3,0xc
ffffffffc020665c:	6af77c63          	bgeu	a4,a5,ffffffffc0206d14 <do_execve+0x832>
ffffffffc0206660:	00090797          	auipc	a5,0x90
ffffffffc0206664:	25878793          	addi	a5,a5,600 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206668:	0007ba03          	ld	s4,0(a5)
ffffffffc020666c:	6605                	lui	a2,0x1
ffffffffc020666e:	00090597          	auipc	a1,0x90
ffffffffc0206672:	22a5b583          	ld	a1,554(a1) # ffffffffc0296898 <boot_pgdir_va>
ffffffffc0206676:	9a36                	add	s4,s4,a3
ffffffffc0206678:	8552                	mv	a0,s4
ffffffffc020667a:	773040ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020667e:	4601                	li	a2,0
ffffffffc0206680:	0149bc23          	sd	s4,24(s3)
ffffffffc0206684:	4581                	li	a1,0
ffffffffc0206686:	854a                	mv	a0,s2
ffffffffc0206688:	fb8fe0ef          	jal	ra,ffffffffc0204e40 <file_seek>
ffffffffc020668c:	8a2a                	mv	s4,a0
ffffffffc020668e:	14050263          	beqz	a0,ffffffffc02067d2 <do_execve+0x2f0>
ffffffffc0206692:	0189b503          	ld	a0,24(s3)
ffffffffc0206696:	020c9b93          	slli	s7,s9,0x20
ffffffffc020669a:	8952                	mv	s2,s4
ffffffffc020669c:	c72ff0ef          	jal	ra,ffffffffc0205b0e <put_pgdir.isra.0>
ffffffffc02066a0:	854e                	mv	a0,s3
ffffffffc02066a2:	0e810b13          	addi	s6,sp,232
ffffffffc02066a6:	f2efd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc02066aa:	020bdb93          	srli	s7,s7,0x20
ffffffffc02066ae:	a881                	j	ffffffffc02066fe <do_execve+0x21c>
ffffffffc02066b0:	000ab783          	ld	a5,0(s5)
ffffffffc02066b4:	1487b503          	ld	a0,328(a5)
ffffffffc02066b8:	c61fe0ef          	jal	ra,ffffffffc0205318 <files_closeall>
ffffffffc02066bc:	854a                	mv	a0,s2
ffffffffc02066be:	4581                	li	a1,0
ffffffffc02066c0:	ee5fe0ef          	jal	ra,ffffffffc02055a4 <sysfile_open>
ffffffffc02066c4:	892a                	mv	s2,a0
ffffffffc02066c6:	0e054f63          	bltz	a0,ffffffffc02067c4 <do_execve+0x2e2>
ffffffffc02066ca:	000ab783          	ld	a5,0(s5)
ffffffffc02066ce:	779c                	ld	a5,40(a5)
ffffffffc02066d0:	d7a1                	beqz	a5,ffffffffc0206618 <do_execve+0x136>
ffffffffc02066d2:	00007617          	auipc	a2,0x7
ffffffffc02066d6:	09e60613          	addi	a2,a2,158 # ffffffffc020d770 <CSWTCH.79+0x2e0>
ffffffffc02066da:	2d300593          	li	a1,723
ffffffffc02066de:	00007517          	auipc	a0,0x7
ffffffffc02066e2:	ea250513          	addi	a0,a0,-350 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc02066e6:	db9f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02066ea:	854e                	mv	a0,s3
ffffffffc02066ec:	ee8fd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc02066f0:	020c9b93          	slli	s7,s9,0x20
ffffffffc02066f4:	5971                	li	s2,-4
ffffffffc02066f6:	0e810b13          	addi	s6,sp,232
ffffffffc02066fa:	020bdb93          	srli	s7,s7,0x20
ffffffffc02066fe:	77a2                	ld	a5,40(sp)
ffffffffc0206700:	147d                	addi	s0,s0,-1
ffffffffc0206702:	040e                	slli	s0,s0,0x3
ffffffffc0206704:	00fb04b3          	add	s1,s6,a5
ffffffffc0206708:	0b8e                	slli	s7,s7,0x3
ffffffffc020670a:	19bc                	addi	a5,sp,248
ffffffffc020670c:	943e                	add	s0,s0,a5
ffffffffc020670e:	417484b3          	sub	s1,s1,s7
ffffffffc0206712:	6008                	ld	a0,0(s0)
ffffffffc0206714:	1461                	addi	s0,s0,-8
ffffffffc0206716:	929fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020671a:	fe849ce3          	bne	s1,s0,ffffffffc0206712 <do_execve+0x230>
ffffffffc020671e:	854a                	mv	a0,s2
ffffffffc0206720:	93fff0ef          	jal	ra,ffffffffc020605e <do_exit>
ffffffffc0206724:	5a71                	li	s4,-4
ffffffffc0206726:	c49d                	beqz	s1,ffffffffc0206754 <do_execve+0x272>
ffffffffc0206728:	00349713          	slli	a4,s1,0x3
ffffffffc020672c:	fff48413          	addi	s0,s1,-1
ffffffffc0206730:	11bc                	addi	a5,sp,232
ffffffffc0206732:	34fd                	addiw	s1,s1,-1
ffffffffc0206734:	97ba                	add	a5,a5,a4
ffffffffc0206736:	02049713          	slli	a4,s1,0x20
ffffffffc020673a:	01d75493          	srli	s1,a4,0x1d
ffffffffc020673e:	040e                	slli	s0,s0,0x3
ffffffffc0206740:	19b8                	addi	a4,sp,248
ffffffffc0206742:	943a                	add	s0,s0,a4
ffffffffc0206744:	409784b3          	sub	s1,a5,s1
ffffffffc0206748:	6008                	ld	a0,0(s0)
ffffffffc020674a:	1461                	addi	s0,s0,-8
ffffffffc020674c:	8f3fb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0206750:	fe849ce3          	bne	s1,s0,ffffffffc0206748 <do_execve+0x266>
ffffffffc0206754:	000b0863          	beqz	s6,ffffffffc0206764 <do_execve+0x282>
ffffffffc0206758:	038b0513          	addi	a0,s6,56
ffffffffc020675c:	e83fd0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0206760:	040b2823          	sw	zero,80(s6)
ffffffffc0206764:	36813083          	ld	ra,872(sp)
ffffffffc0206768:	36013403          	ld	s0,864(sp)
ffffffffc020676c:	35813483          	ld	s1,856(sp)
ffffffffc0206770:	35013903          	ld	s2,848(sp)
ffffffffc0206774:	34813983          	ld	s3,840(sp)
ffffffffc0206778:	33813a83          	ld	s5,824(sp)
ffffffffc020677c:	33013b03          	ld	s6,816(sp)
ffffffffc0206780:	32813b83          	ld	s7,808(sp)
ffffffffc0206784:	32013c03          	ld	s8,800(sp)
ffffffffc0206788:	31813c83          	ld	s9,792(sp)
ffffffffc020678c:	31013d03          	ld	s10,784(sp)
ffffffffc0206790:	30813d83          	ld	s11,776(sp)
ffffffffc0206794:	8552                	mv	a0,s4
ffffffffc0206796:	34013a03          	ld	s4,832(sp)
ffffffffc020679a:	37010113          	addi	sp,sp,880
ffffffffc020679e:	8082                	ret
ffffffffc02067a0:	854a                	mv	a0,s2
ffffffffc02067a2:	89dfb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02067a6:	5a75                	li	s4,-3
ffffffffc02067a8:	bfbd                	j	ffffffffc0206726 <do_execve+0x244>
ffffffffc02067aa:	000ab783          	ld	a5,0(s5)
ffffffffc02067ae:	00007617          	auipc	a2,0x7
ffffffffc02067b2:	fb260613          	addi	a2,a2,-78 # ffffffffc020d760 <CSWTCH.79+0x2d0>
ffffffffc02067b6:	45c1                	li	a1,16
ffffffffc02067b8:	43d4                	lw	a3,4(a5)
ffffffffc02067ba:	1888                	addi	a0,sp,112
ffffffffc02067bc:	4ef040ef          	jal	ra,ffffffffc020b4aa <snprintf>
ffffffffc02067c0:	bb55                	j	ffffffffc0206574 <do_execve+0x92>
ffffffffc02067c2:	896e                	mv	s2,s11
ffffffffc02067c4:	020c9b93          	slli	s7,s9,0x20
ffffffffc02067c8:	0e810b13          	addi	s6,sp,232
ffffffffc02067cc:	020bdb93          	srli	s7,s7,0x20
ffffffffc02067d0:	b73d                	j	ffffffffc02066fe <do_execve+0x21c>
ffffffffc02067d2:	1bb4                	addi	a3,sp,504
ffffffffc02067d4:	04000613          	li	a2,64
ffffffffc02067d8:	192c                	addi	a1,sp,184
ffffffffc02067da:	854a                	mv	a0,s2
ffffffffc02067dc:	ff82                	sd	zero,504(sp)
ffffffffc02067de:	c96fe0ef          	jal	ra,ffffffffc0204c74 <file_read>
ffffffffc02067e2:	8a2a                	mv	s4,a0
ffffffffc02067e4:	ea0517e3          	bnez	a0,ffffffffc0206692 <do_execve+0x1b0>
ffffffffc02067e8:	777e                	ld	a4,504(sp)
ffffffffc02067ea:	04000793          	li	a5,64
ffffffffc02067ee:	52f71063          	bne	a4,a5,ffffffffc0206d0e <do_execve+0x82c>
ffffffffc02067f2:	576a                	lw	a4,184(sp)
ffffffffc02067f4:	464c47b7          	lui	a5,0x464c4
ffffffffc02067f8:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc02067fc:	36f71163          	bne	a4,a5,ffffffffc0206b5e <do_execve+0x67c>
ffffffffc0206800:	0f015783          	lhu	a5,240(sp)
ffffffffc0206804:	c7bd                	beqz	a5,ffffffffc0206872 <do_execve+0x390>
ffffffffc0206806:	e882                	sd	zero,80(sp)
ffffffffc0206808:	f802                	sd	zero,48(sp)
ffffffffc020680a:	ec02                	sd	zero,24(sp)
ffffffffc020680c:	f4a6                	sd	s1,104(sp)
ffffffffc020680e:	e04e                	sd	s3,0(sp)
ffffffffc0206810:	f0aa                	sd	a0,96(sp)
ffffffffc0206812:	fc22                	sd	s0,56(sp)
ffffffffc0206814:	c2e6                	sw	s9,68(sp)
ffffffffc0206816:	65ee                	ld	a1,216(sp)
ffffffffc0206818:	77c2                	ld	a5,48(sp)
ffffffffc020681a:	4601                	li	a2,0
ffffffffc020681c:	854a                	mv	a0,s2
ffffffffc020681e:	95be                	add	a1,a1,a5
ffffffffc0206820:	e20fe0ef          	jal	ra,ffffffffc0204e40 <file_seek>
ffffffffc0206824:	8caa                	mv	s9,a0
ffffffffc0206826:	2c051c63          	bnez	a0,ffffffffc0206afe <do_execve+0x61c>
ffffffffc020682a:	1bb4                	addi	a3,sp,504
ffffffffc020682c:	03800613          	li	a2,56
ffffffffc0206830:	010c                	addi	a1,sp,128
ffffffffc0206832:	854a                	mv	a0,s2
ffffffffc0206834:	ff82                	sd	zero,504(sp)
ffffffffc0206836:	c3efe0ef          	jal	ra,ffffffffc0204c74 <file_read>
ffffffffc020683a:	8caa                	mv	s9,a0
ffffffffc020683c:	2c051163          	bnez	a0,ffffffffc0206afe <do_execve+0x61c>
ffffffffc0206840:	777e                	ld	a4,504(sp)
ffffffffc0206842:	03800793          	li	a5,56
ffffffffc0206846:	46f71d63          	bne	a4,a5,ffffffffc0206cc0 <do_execve+0x7de>
ffffffffc020684a:	478a                	lw	a5,128(sp)
ffffffffc020684c:	4705                	li	a4,1
ffffffffc020684e:	1ae78d63          	beq	a5,a4,ffffffffc0206a08 <do_execve+0x526>
ffffffffc0206852:	6746                	ld	a4,80(sp)
ffffffffc0206854:	76c2                	ld	a3,48(sp)
ffffffffc0206856:	0f015783          	lhu	a5,240(sp)
ffffffffc020685a:	2705                	addiw	a4,a4,1
ffffffffc020685c:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc0206860:	e8ba                	sd	a4,80(sp)
ffffffffc0206862:	f836                	sd	a3,48(sp)
ffffffffc0206864:	faf749e3          	blt	a4,a5,ffffffffc0206816 <do_execve+0x334>
ffffffffc0206868:	74a6                	ld	s1,104(sp)
ffffffffc020686a:	6982                	ld	s3,0(sp)
ffffffffc020686c:	7a06                	ld	s4,96(sp)
ffffffffc020686e:	7462                	ld	s0,56(sp)
ffffffffc0206870:	4c96                	lw	s9,68(sp)
ffffffffc0206872:	4701                	li	a4,0
ffffffffc0206874:	46ad                	li	a3,11
ffffffffc0206876:	00100637          	lui	a2,0x100
ffffffffc020687a:	7ff005b7          	lui	a1,0x7ff00
ffffffffc020687e:	854e                	mv	a0,s3
ffffffffc0206880:	da6fd0ef          	jal	ra,ffffffffc0203e26 <mm_map>
ffffffffc0206884:	8daa                	mv	s11,a0
ffffffffc0206886:	46051663          	bnez	a0,ffffffffc0206cf2 <do_execve+0x810>
ffffffffc020688a:	0189b503          	ld	a0,24(s3)
ffffffffc020688e:	467d                	li	a2,31
ffffffffc0206890:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206894:	b0cfd0ef          	jal	ra,ffffffffc0203ba0 <pgdir_alloc_page>
ffffffffc0206898:	48050a63          	beqz	a0,ffffffffc0206d2c <do_execve+0x84a>
ffffffffc020689c:	0189b503          	ld	a0,24(s3)
ffffffffc02068a0:	467d                	li	a2,31
ffffffffc02068a2:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02068a6:	afafd0ef          	jal	ra,ffffffffc0203ba0 <pgdir_alloc_page>
ffffffffc02068aa:	4e050d63          	beqz	a0,ffffffffc0206da4 <do_execve+0x8c2>
ffffffffc02068ae:	0189b503          	ld	a0,24(s3)
ffffffffc02068b2:	467d                	li	a2,31
ffffffffc02068b4:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02068b8:	ae8fd0ef          	jal	ra,ffffffffc0203ba0 <pgdir_alloc_page>
ffffffffc02068bc:	4c050463          	beqz	a0,ffffffffc0206d84 <do_execve+0x8a2>
ffffffffc02068c0:	0189b503          	ld	a0,24(s3)
ffffffffc02068c4:	467d                	li	a2,31
ffffffffc02068c6:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02068ca:	ad6fd0ef          	jal	ra,ffffffffc0203ba0 <pgdir_alloc_page>
ffffffffc02068ce:	48050b63          	beqz	a0,ffffffffc0206d64 <do_execve+0x882>
ffffffffc02068d2:	0309a783          	lw	a5,48(s3)
ffffffffc02068d6:	000ab703          	ld	a4,0(s5)
ffffffffc02068da:	0189b683          	ld	a3,24(s3)
ffffffffc02068de:	2785                	addiw	a5,a5,1
ffffffffc02068e0:	02f9a823          	sw	a5,48(s3)
ffffffffc02068e4:	03373423          	sd	s3,40(a4)
ffffffffc02068e8:	c02007b7          	lui	a5,0xc0200
ffffffffc02068ec:	46f6e063          	bltu	a3,a5,ffffffffc0206d4c <do_execve+0x86a>
ffffffffc02068f0:	00090797          	auipc	a5,0x90
ffffffffc02068f4:	fc878793          	addi	a5,a5,-56 # ffffffffc02968b8 <va_pa_offset>
ffffffffc02068f8:	639c                	ld	a5,0(a5)
ffffffffc02068fa:	8e9d                	sub	a3,a3,a5
ffffffffc02068fc:	f754                	sd	a3,168(a4)
ffffffffc02068fe:	577d                	li	a4,-1
ffffffffc0206900:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206904:	177e                	slli	a4,a4,0x3f
ffffffffc0206906:	8fd9                	or	a5,a5,a4
ffffffffc0206908:	18079073          	csrw	satp,a5
ffffffffc020690c:	77a2                	ld	a5,40(sp)
ffffffffc020690e:	020c9b93          	slli	s7,s9,0x20
ffffffffc0206912:	19b4                	addi	a3,sp,248
ffffffffc0206914:	ff878713          	addi	a4,a5,-8
ffffffffc0206918:	00e68db3          	add	s11,a3,a4
ffffffffc020691c:	0e810b13          	addi	s6,sp,232
ffffffffc0206920:	020bdb93          	srli	s7,s7,0x20
ffffffffc0206924:	1bb4                	addi	a3,sp,504
ffffffffc0206926:	00fb0cb3          	add	s9,s6,a5
ffffffffc020692a:	9736                	add	a4,a4,a3
ffffffffc020692c:	003b9793          	slli	a5,s7,0x3
ffffffffc0206930:	4c05                	li	s8,1
ffffffffc0206932:	40fc8cb3          	sub	s9,s9,a5
ffffffffc0206936:	0c7e                	slli	s8,s8,0x1f
ffffffffc0206938:	8d3a                	mv	s10,a4
ffffffffc020693a:	e022                	sd	s0,0(sp)
ffffffffc020693c:	000db403          	ld	s0,0(s11)
ffffffffc0206940:	8522                	mv	a0,s0
ffffffffc0206942:	3b7040ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc0206946:	00150693          	addi	a3,a0,1
ffffffffc020694a:	40dc0c33          	sub	s8,s8,a3
ffffffffc020694e:	ff8c7c13          	andi	s8,s8,-8
ffffffffc0206952:	8622                	mv	a2,s0
ffffffffc0206954:	85e2                	mv	a1,s8
ffffffffc0206956:	854e                	mv	a0,s3
ffffffffc0206958:	a81fd0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc020695c:	3a050663          	beqz	a0,ffffffffc0206d08 <do_execve+0x826>
ffffffffc0206960:	018d3023          	sd	s8,0(s10)
ffffffffc0206964:	1de1                	addi	s11,s11,-8
ffffffffc0206966:	1d61                	addi	s10,s10,-8
ffffffffc0206968:	fd9d9ae3          	bne	s11,s9,ffffffffc020693c <do_execve+0x45a>
ffffffffc020696c:	77a2                	ld	a5,40(sp)
ffffffffc020696e:	0618                	addi	a4,sp,768
ffffffffc0206970:	1bb0                	addi	a2,sp,504
ffffffffc0206972:	00878693          	addi	a3,a5,8
ffffffffc0206976:	00349793          	slli	a5,s1,0x3
ffffffffc020697a:	40dc0c33          	sub	s8,s8,a3
ffffffffc020697e:	97ba                	add	a5,a5,a4
ffffffffc0206980:	85e2                	mv	a1,s8
ffffffffc0206982:	854e                	mv	a0,s3
ffffffffc0206984:	ee07bc23          	sd	zero,-264(a5)
ffffffffc0206988:	6402                	ld	s0,0(sp)
ffffffffc020698a:	a4ffd0ef          	jal	ra,ffffffffc02043d8 <copy_to_user>
ffffffffc020698e:	36050e63          	beqz	a0,ffffffffc0206d0a <do_execve+0x828>
ffffffffc0206992:	000ab783          	ld	a5,0(s5)
ffffffffc0206996:	12000613          	li	a2,288
ffffffffc020699a:	4581                	li	a1,0
ffffffffc020699c:	73c4                	ld	s1,160(a5)
ffffffffc020699e:	1004b983          	ld	s3,256(s1)
ffffffffc02069a2:	8526                	mv	a0,s1
ffffffffc02069a4:	3f7040ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc02069a8:	674e                	ld	a4,208(sp)
ffffffffc02069aa:	edf9f793          	andi	a5,s3,-289
ffffffffc02069ae:	0207e793          	ori	a5,a5,32
ffffffffc02069b2:	0184b823          	sd	s8,16(s1)
ffffffffc02069b6:	e8a0                	sd	s0,80(s1)
ffffffffc02069b8:	0584bc23          	sd	s8,88(s1)
ffffffffc02069bc:	10e4b423          	sd	a4,264(s1)
ffffffffc02069c0:	10f4b023          	sd	a5,256(s1)
ffffffffc02069c4:	854a                	mv	a0,s2
ffffffffc02069c6:	c13fe0ef          	jal	ra,ffffffffc02055d8 <sysfile_close>
ffffffffc02069ca:	77a2                	ld	a5,40(sp)
ffffffffc02069cc:	147d                	addi	s0,s0,-1
ffffffffc02069ce:	040e                	slli	s0,s0,0x3
ffffffffc02069d0:	9b3e                	add	s6,s6,a5
ffffffffc02069d2:	003b9493          	slli	s1,s7,0x3
ffffffffc02069d6:	19bc                	addi	a5,sp,248
ffffffffc02069d8:	943e                	add	s0,s0,a5
ffffffffc02069da:	409b04b3          	sub	s1,s6,s1
ffffffffc02069de:	6008                	ld	a0,0(s0)
ffffffffc02069e0:	1461                	addi	s0,s0,-8
ffffffffc02069e2:	e5cfb0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02069e6:	fe941ce3          	bne	s0,s1,ffffffffc02069de <do_execve+0x4fc>
ffffffffc02069ea:	000ab403          	ld	s0,0(s5)
ffffffffc02069ee:	4641                	li	a2,16
ffffffffc02069f0:	4581                	li	a1,0
ffffffffc02069f2:	0b440413          	addi	s0,s0,180
ffffffffc02069f6:	8522                	mv	a0,s0
ffffffffc02069f8:	3a3040ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc02069fc:	463d                	li	a2,15
ffffffffc02069fe:	188c                	addi	a1,sp,112
ffffffffc0206a00:	8522                	mv	a0,s0
ffffffffc0206a02:	3eb040ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc0206a06:	bbb9                	j	ffffffffc0206764 <do_execve+0x282>
ffffffffc0206a08:	762a                	ld	a2,168(sp)
ffffffffc0206a0a:	778a                	ld	a5,160(sp)
ffffffffc0206a0c:	2cf66f63          	bltu	a2,a5,ffffffffc0206cea <do_execve+0x808>
ffffffffc0206a10:	479a                	lw	a5,132(sp)
ffffffffc0206a12:	0017f693          	andi	a3,a5,1
ffffffffc0206a16:	c291                	beqz	a3,ffffffffc0206a1a <do_execve+0x538>
ffffffffc0206a18:	4691                	li	a3,4
ffffffffc0206a1a:	0027f713          	andi	a4,a5,2
ffffffffc0206a1e:	8b91                	andi	a5,a5,4
ffffffffc0206a20:	12070363          	beqz	a4,ffffffffc0206b46 <do_execve+0x664>
ffffffffc0206a24:	0026e693          	ori	a3,a3,2
ffffffffc0206a28:	12079263          	bnez	a5,ffffffffc0206b4c <do_execve+0x66a>
ffffffffc0206a2c:	47dd                	li	a5,23
ffffffffc0206a2e:	ecbe                	sd	a5,88(sp)
ffffffffc0206a30:	0046f793          	andi	a5,a3,4
ffffffffc0206a34:	c789                	beqz	a5,ffffffffc0206a3e <do_execve+0x55c>
ffffffffc0206a36:	67e6                	ld	a5,88(sp)
ffffffffc0206a38:	0087e793          	ori	a5,a5,8
ffffffffc0206a3c:	ecbe                	sd	a5,88(sp)
ffffffffc0206a3e:	65ca                	ld	a1,144(sp)
ffffffffc0206a40:	6502                	ld	a0,0(sp)
ffffffffc0206a42:	4701                	li	a4,0
ffffffffc0206a44:	be2fd0ef          	jal	ra,ffffffffc0203e26 <mm_map>
ffffffffc0206a48:	8caa                	mv	s9,a0
ffffffffc0206a4a:	e955                	bnez	a0,ffffffffc0206afe <do_execve+0x61c>
ffffffffc0206a4c:	6a4a                	ld	s4,144(sp)
ffffffffc0206a4e:	67aa                	ld	a5,136(sp)
ffffffffc0206a50:	7d0a                	ld	s10,160(sp)
ffffffffc0206a52:	e4be                	sd	a5,72(sp)
ffffffffc0206a54:	9d52                	add	s10,s10,s4
ffffffffc0206a56:	77fd                	lui	a5,0xfffff
ffffffffc0206a58:	00fa7db3          	and	s11,s4,a5
ffffffffc0206a5c:	2baa7263          	bgeu	s4,s10,ffffffffc0206d00 <do_execve+0x81e>
ffffffffc0206a60:	64e6                	ld	s1,88(sp)
ffffffffc0206a62:	5cf1                	li	s9,-4
ffffffffc0206a64:	89ee                	mv	s3,s11
ffffffffc0206a66:	8b52                	mv	s6,s4
ffffffffc0206a68:	a03d                	j	ffffffffc0206a96 <do_execve+0x5b4>
ffffffffc0206a6a:	67e2                	ld	a5,24(sp)
ffffffffc0206a6c:	7702                	ld	a4,32(sp)
ffffffffc0206a6e:	413b09b3          	sub	s3,s6,s3
ffffffffc0206a72:	1bb4                	addi	a3,sp,504
ffffffffc0206a74:	00e785b3          	add	a1,a5,a4
ffffffffc0206a78:	866e                	mv	a2,s11
ffffffffc0206a7a:	95ce                	add	a1,a1,s3
ffffffffc0206a7c:	854a                	mv	a0,s2
ffffffffc0206a7e:	ff82                	sd	zero,504(sp)
ffffffffc0206a80:	9f4fe0ef          	jal	ra,ffffffffc0204c74 <file_read>
ffffffffc0206a84:	8caa                	mv	s9,a0
ffffffffc0206a86:	ed25                	bnez	a0,ffffffffc0206afe <do_execve+0x61c>
ffffffffc0206a88:	76fe                	ld	a3,504(sp)
ffffffffc0206a8a:	22dd9b63          	bne	s11,a3,ffffffffc0206cc0 <do_execve+0x7de>
ffffffffc0206a8e:	9b6e                	add	s6,s6,s11
ffffffffc0206a90:	13ab7163          	bgeu	s6,s10,ffffffffc0206bb2 <do_execve+0x6d0>
ffffffffc0206a94:	89a2                	mv	s3,s0
ffffffffc0206a96:	6782                	ld	a5,0(sp)
ffffffffc0206a98:	8626                	mv	a2,s1
ffffffffc0206a9a:	85ce                	mv	a1,s3
ffffffffc0206a9c:	6f88                	ld	a0,24(a5)
ffffffffc0206a9e:	902fd0ef          	jal	ra,ffffffffc0203ba0 <pgdir_alloc_page>
ffffffffc0206aa2:	8a2a                	mv	s4,a0
ffffffffc0206aa4:	0c050c63          	beqz	a0,ffffffffc0206b7c <do_execve+0x69a>
ffffffffc0206aa8:	6785                	lui	a5,0x1
ffffffffc0206aaa:	00f98433          	add	s0,s3,a5
ffffffffc0206aae:	41640db3          	sub	s11,s0,s6
ffffffffc0206ab2:	008d7463          	bgeu	s10,s0,ffffffffc0206aba <do_execve+0x5d8>
ffffffffc0206ab6:	416d0db3          	sub	s11,s10,s6
ffffffffc0206aba:	000bb583          	ld	a1,0(s7)
ffffffffc0206abe:	67c2                	ld	a5,16(sp)
ffffffffc0206ac0:	000c3603          	ld	a2,0(s8)
ffffffffc0206ac4:	40ba05b3          	sub	a1,s4,a1
ffffffffc0206ac8:	8599                	srai	a1,a1,0x6
ffffffffc0206aca:	95be                	add	a1,a1,a5
ffffffffc0206acc:	67a2                	ld	a5,8(sp)
ffffffffc0206ace:	00f5f533          	and	a0,a1,a5
ffffffffc0206ad2:	00c59793          	slli	a5,a1,0xc
ffffffffc0206ad6:	ec3e                	sd	a5,24(sp)
ffffffffc0206ad8:	22c57d63          	bgeu	a0,a2,ffffffffc0206d12 <do_execve+0x830>
ffffffffc0206adc:	67a6                	ld	a5,72(sp)
ffffffffc0206ade:	65ca                	ld	a1,144(sp)
ffffffffc0206ae0:	4601                	li	a2,0
ffffffffc0206ae2:	854a                	mv	a0,s2
ffffffffc0206ae4:	40b785b3          	sub	a1,a5,a1
ffffffffc0206ae8:	00090797          	auipc	a5,0x90
ffffffffc0206aec:	dd078793          	addi	a5,a5,-560 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206af0:	639c                	ld	a5,0(a5)
ffffffffc0206af2:	95da                	add	a1,a1,s6
ffffffffc0206af4:	f03e                	sd	a5,32(sp)
ffffffffc0206af6:	b4afe0ef          	jal	ra,ffffffffc0204e40 <file_seek>
ffffffffc0206afa:	8caa                	mv	s9,a0
ffffffffc0206afc:	d53d                	beqz	a0,ffffffffc0206a6a <do_execve+0x588>
ffffffffc0206afe:	8de6                	mv	s11,s9
ffffffffc0206b00:	4c96                	lw	s9,68(sp)
ffffffffc0206b02:	6982                	ld	s3,0(sp)
ffffffffc0206b04:	7462                	ld	s0,56(sp)
ffffffffc0206b06:	020c9b93          	slli	s7,s9,0x20
ffffffffc0206b0a:	0e810b13          	addi	s6,sp,232
ffffffffc0206b0e:	020bdb93          	srli	s7,s7,0x20
ffffffffc0206b12:	854a                	mv	a0,s2
ffffffffc0206b14:	ac5fe0ef          	jal	ra,ffffffffc02055d8 <sysfile_close>
ffffffffc0206b18:	854e                	mv	a0,s3
ffffffffc0206b1a:	c56fd0ef          	jal	ra,ffffffffc0203f70 <exit_mmap>
ffffffffc0206b1e:	0189b503          	ld	a0,24(s3)
ffffffffc0206b22:	896e                	mv	s2,s11
ffffffffc0206b24:	febfe0ef          	jal	ra,ffffffffc0205b0e <put_pgdir.isra.0>
ffffffffc0206b28:	854e                	mv	a0,s3
ffffffffc0206b2a:	aaafd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc0206b2e:	bec1                	j	ffffffffc02066fe <do_execve+0x21c>
ffffffffc0206b30:	855a                	mv	a0,s6
ffffffffc0206b32:	c3efd0ef          	jal	ra,ffffffffc0203f70 <exit_mmap>
ffffffffc0206b36:	018b3503          	ld	a0,24(s6)
ffffffffc0206b3a:	fd5fe0ef          	jal	ra,ffffffffc0205b0e <put_pgdir.isra.0>
ffffffffc0206b3e:	855a                	mv	a0,s6
ffffffffc0206b40:	a94fd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc0206b44:	b4f1                	j	ffffffffc0206610 <do_execve+0x12e>
ffffffffc0206b46:	4745                	li	a4,17
ffffffffc0206b48:	ecba                	sd	a4,88(sp)
ffffffffc0206b4a:	c789                	beqz	a5,ffffffffc0206b54 <do_execve+0x672>
ffffffffc0206b4c:	47cd                	li	a5,19
ffffffffc0206b4e:	0016e693          	ori	a3,a3,1
ffffffffc0206b52:	ecbe                	sd	a5,88(sp)
ffffffffc0206b54:	0026f793          	andi	a5,a3,2
ffffffffc0206b58:	ec078ce3          	beqz	a5,ffffffffc0206a30 <do_execve+0x54e>
ffffffffc0206b5c:	bdc1                	j	ffffffffc0206a2c <do_execve+0x54a>
ffffffffc0206b5e:	0189b503          	ld	a0,24(s3)
ffffffffc0206b62:	020c9b93          	slli	s7,s9,0x20
ffffffffc0206b66:	5961                	li	s2,-8
ffffffffc0206b68:	fa7fe0ef          	jal	ra,ffffffffc0205b0e <put_pgdir.isra.0>
ffffffffc0206b6c:	854e                	mv	a0,s3
ffffffffc0206b6e:	0e810b13          	addi	s6,sp,232
ffffffffc0206b72:	a62fd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc0206b76:	020bdb93          	srli	s7,s7,0x20
ffffffffc0206b7a:	b651                	j	ffffffffc02066fe <do_execve+0x21c>
ffffffffc0206b7c:	8de6                	mv	s11,s9
ffffffffc0206b7e:	6982                	ld	s3,0(sp)
ffffffffc0206b80:	7a06                	ld	s4,96(sp)
ffffffffc0206b82:	7462                	ld	s0,56(sp)
ffffffffc0206b84:	4c96                	lw	s9,68(sp)
ffffffffc0206b86:	854a                	mv	a0,s2
ffffffffc0206b88:	a51fe0ef          	jal	ra,ffffffffc02055d8 <sysfile_close>
ffffffffc0206b8c:	854e                	mv	a0,s3
ffffffffc0206b8e:	be2fd0ef          	jal	ra,ffffffffc0203f70 <exit_mmap>
ffffffffc0206b92:	0189b503          	ld	a0,24(s3)
ffffffffc0206b96:	f79fe0ef          	jal	ra,ffffffffc0205b0e <put_pgdir.isra.0>
ffffffffc0206b9a:	854e                	mv	a0,s3
ffffffffc0206b9c:	a38fd0ef          	jal	ra,ffffffffc0203dd4 <mm_destroy>
ffffffffc0206ba0:	c20d91e3          	bnez	s11,ffffffffc02067c2 <do_execve+0x2e0>
ffffffffc0206ba4:	020c9b93          	slli	s7,s9,0x20
ffffffffc0206ba8:	0e810b13          	addi	s6,sp,232
ffffffffc0206bac:	020bdb93          	srli	s7,s7,0x20
ffffffffc0206bb0:	bd29                	j	ffffffffc02069ca <do_execve+0x4e8>
ffffffffc0206bb2:	64ca                	ld	s1,144(sp)
ffffffffc0206bb4:	ec52                	sd	s4,24(sp)
ffffffffc0206bb6:	8a5a                	mv	s4,s6
ffffffffc0206bb8:	76aa                	ld	a3,168(sp)
ffffffffc0206bba:	94b6                	add	s1,s1,a3
ffffffffc0206bbc:	088a7363          	bgeu	s4,s0,ffffffffc0206c42 <do_execve+0x760>
ffffffffc0206bc0:	c94489e3          	beq	s1,s4,ffffffffc0206852 <do_execve+0x370>
ffffffffc0206bc4:	6785                	lui	a5,0x1
ffffffffc0206bc6:	00fa0533          	add	a0,s4,a5
ffffffffc0206bca:	8d01                	sub	a0,a0,s0
ffffffffc0206bcc:	414489b3          	sub	s3,s1,s4
ffffffffc0206bd0:	0084e463          	bltu	s1,s0,ffffffffc0206bd8 <do_execve+0x6f6>
ffffffffc0206bd4:	414409b3          	sub	s3,s0,s4
ffffffffc0206bd8:	67e2                	ld	a5,24(sp)
ffffffffc0206bda:	000bb683          	ld	a3,0(s7)
ffffffffc0206bde:	000c3603          	ld	a2,0(s8)
ffffffffc0206be2:	40d786b3          	sub	a3,a5,a3
ffffffffc0206be6:	67c2                	ld	a5,16(sp)
ffffffffc0206be8:	8699                	srai	a3,a3,0x6
ffffffffc0206bea:	96be                	add	a3,a3,a5
ffffffffc0206bec:	67a2                	ld	a5,8(sp)
ffffffffc0206bee:	00f6f5b3          	and	a1,a3,a5
ffffffffc0206bf2:	06b2                	slli	a3,a3,0xc
ffffffffc0206bf4:	12c5f063          	bgeu	a1,a2,ffffffffc0206d14 <do_execve+0x832>
ffffffffc0206bf8:	00090797          	auipc	a5,0x90
ffffffffc0206bfc:	cc078793          	addi	a5,a5,-832 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206c00:	0007b883          	ld	a7,0(a5)
ffffffffc0206c04:	864e                	mv	a2,s3
ffffffffc0206c06:	4581                	li	a1,0
ffffffffc0206c08:	96c6                	add	a3,a3,a7
ffffffffc0206c0a:	9536                	add	a0,a0,a3
ffffffffc0206c0c:	18f040ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0206c10:	01498733          	add	a4,s3,s4
ffffffffc0206c14:	0284f463          	bgeu	s1,s0,ffffffffc0206c3c <do_execve+0x75a>
ffffffffc0206c18:	c2e48de3          	beq	s1,a4,ffffffffc0206852 <do_execve+0x370>
ffffffffc0206c1c:	00007697          	auipc	a3,0x7
ffffffffc0206c20:	b7c68693          	addi	a3,a3,-1156 # ffffffffc020d798 <CSWTCH.79+0x308>
ffffffffc0206c24:	00005617          	auipc	a2,0x5
ffffffffc0206c28:	e5c60613          	addi	a2,a2,-420 # ffffffffc020ba80 <commands+0x210>
ffffffffc0206c2c:	34200593          	li	a1,834
ffffffffc0206c30:	00007517          	auipc	a0,0x7
ffffffffc0206c34:	95050513          	addi	a0,a0,-1712 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206c38:	867f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206c3c:	fe8710e3          	bne	a4,s0,ffffffffc0206c1c <do_execve+0x73a>
ffffffffc0206c40:	8a22                	mv	s4,s0
ffffffffc0206c42:	c09a78e3          	bgeu	s4,s1,ffffffffc0206852 <do_execve+0x370>
ffffffffc0206c46:	6982                	ld	s3,0(sp)
ffffffffc0206c48:	6d66                	ld	s10,88(sp)
ffffffffc0206c4a:	6dc2                	ld	s11,16(sp)
ffffffffc0206c4c:	a0a9                	j	ffffffffc0206c96 <do_execve+0x7b4>
ffffffffc0206c4e:	6785                	lui	a5,0x1
ffffffffc0206c50:	408a0533          	sub	a0,s4,s0
ffffffffc0206c54:	943e                	add	s0,s0,a5
ffffffffc0206c56:	41440633          	sub	a2,s0,s4
ffffffffc0206c5a:	0084f463          	bgeu	s1,s0,ffffffffc0206c62 <do_execve+0x780>
ffffffffc0206c5e:	41448633          	sub	a2,s1,s4
ffffffffc0206c62:	000bb783          	ld	a5,0(s7)
ffffffffc0206c66:	66a2                	ld	a3,8(sp)
ffffffffc0206c68:	000c3703          	ld	a4,0(s8)
ffffffffc0206c6c:	40fb07b3          	sub	a5,s6,a5
ffffffffc0206c70:	8799                	srai	a5,a5,0x6
ffffffffc0206c72:	97ee                	add	a5,a5,s11
ffffffffc0206c74:	8efd                	and	a3,a3,a5
ffffffffc0206c76:	07b2                	slli	a5,a5,0xc
ffffffffc0206c78:	08e6fd63          	bgeu	a3,a4,ffffffffc0206d12 <do_execve+0x830>
ffffffffc0206c7c:	00090717          	auipc	a4,0x90
ffffffffc0206c80:	c3c70713          	addi	a4,a4,-964 # ffffffffc02968b8 <va_pa_offset>
ffffffffc0206c84:	6318                	ld	a4,0(a4)
ffffffffc0206c86:	9a32                	add	s4,s4,a2
ffffffffc0206c88:	4581                	li	a1,0
ffffffffc0206c8a:	97ba                	add	a5,a5,a4
ffffffffc0206c8c:	953e                	add	a0,a0,a5
ffffffffc0206c8e:	10d040ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0206c92:	029a7163          	bgeu	s4,s1,ffffffffc0206cb4 <do_execve+0x7d2>
ffffffffc0206c96:	0189b503          	ld	a0,24(s3)
ffffffffc0206c9a:	866a                	mv	a2,s10
ffffffffc0206c9c:	85a2                	mv	a1,s0
ffffffffc0206c9e:	f03fc0ef          	jal	ra,ffffffffc0203ba0 <pgdir_alloc_page>
ffffffffc0206ca2:	8b2a                	mv	s6,a0
ffffffffc0206ca4:	f54d                	bnez	a0,ffffffffc0206c4e <do_execve+0x76c>
ffffffffc0206ca6:	8de6                	mv	s11,s9
ffffffffc0206ca8:	7a06                	ld	s4,96(sp)
ffffffffc0206caa:	7462                	ld	s0,56(sp)
ffffffffc0206cac:	4c96                	lw	s9,68(sp)
ffffffffc0206cae:	bde1                	j	ffffffffc0206b86 <do_execve+0x6a4>
ffffffffc0206cb0:	5a75                	li	s4,-3
ffffffffc0206cb2:	bc4d                	j	ffffffffc0206764 <do_execve+0x282>
ffffffffc0206cb4:	ec5a                	sd	s6,24(sp)
ffffffffc0206cb6:	be71                	j	ffffffffc0206852 <do_execve+0x370>
ffffffffc0206cb8:	5a75                	li	s4,-3
ffffffffc0206cba:	a80b1fe3          	bnez	s6,ffffffffc0206758 <do_execve+0x276>
ffffffffc0206cbe:	b45d                	j	ffffffffc0206764 <do_execve+0x282>
ffffffffc0206cc0:	4c96                	lw	s9,68(sp)
ffffffffc0206cc2:	6982                	ld	s3,0(sp)
ffffffffc0206cc4:	7462                	ld	s0,56(sp)
ffffffffc0206cc6:	020c9b93          	slli	s7,s9,0x20
ffffffffc0206cca:	5df5                	li	s11,-3
ffffffffc0206ccc:	0e810b13          	addi	s6,sp,232
ffffffffc0206cd0:	020bdb93          	srli	s7,s7,0x20
ffffffffc0206cd4:	bd3d                	j	ffffffffc0206b12 <do_execve+0x630>
ffffffffc0206cd6:	fc0b0de3          	beqz	s6,ffffffffc0206cb0 <do_execve+0x7ce>
ffffffffc0206cda:	038b0513          	addi	a0,s6,56
ffffffffc0206cde:	901fd0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0206ce2:	5a75                	li	s4,-3
ffffffffc0206ce4:	040b2823          	sw	zero,80(s6)
ffffffffc0206ce8:	bcb5                	j	ffffffffc0206764 <do_execve+0x282>
ffffffffc0206cea:	6982                	ld	s3,0(sp)
ffffffffc0206cec:	7462                	ld	s0,56(sp)
ffffffffc0206cee:	4c96                	lw	s9,68(sp)
ffffffffc0206cf0:	5de1                	li	s11,-8
ffffffffc0206cf2:	020c9b93          	slli	s7,s9,0x20
ffffffffc0206cf6:	0e810b13          	addi	s6,sp,232
ffffffffc0206cfa:	020bdb93          	srli	s7,s7,0x20
ffffffffc0206cfe:	bd11                	j	ffffffffc0206b12 <do_execve+0x630>
ffffffffc0206d00:	84d2                	mv	s1,s4
ffffffffc0206d02:	846e                	mv	s0,s11
ffffffffc0206d04:	5cf1                	li	s9,-4
ffffffffc0206d06:	bd4d                	j	ffffffffc0206bb8 <do_execve+0x6d6>
ffffffffc0206d08:	6402                	ld	s0,0(sp)
ffffffffc0206d0a:	5df5                	li	s11,-3
ffffffffc0206d0c:	b519                	j	ffffffffc0206b12 <do_execve+0x630>
ffffffffc0206d0e:	5a75                	li	s4,-3
ffffffffc0206d10:	b249                	j	ffffffffc0206692 <do_execve+0x1b0>
ffffffffc0206d12:	86be                	mv	a3,a5
ffffffffc0206d14:	00006617          	auipc	a2,0x6
ffffffffc0206d18:	88c60613          	addi	a2,a2,-1908 # ffffffffc020c5a0 <default_pmm_manager+0x38>
ffffffffc0206d1c:	07100593          	li	a1,113
ffffffffc0206d20:	00006517          	auipc	a0,0x6
ffffffffc0206d24:	8a850513          	addi	a0,a0,-1880 # ffffffffc020c5c8 <default_pmm_manager+0x60>
ffffffffc0206d28:	f76f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206d2c:	00007697          	auipc	a3,0x7
ffffffffc0206d30:	aac68693          	addi	a3,a3,-1364 # ffffffffc020d7d8 <CSWTCH.79+0x348>
ffffffffc0206d34:	00005617          	auipc	a2,0x5
ffffffffc0206d38:	d4c60613          	addi	a2,a2,-692 # ffffffffc020ba80 <commands+0x210>
ffffffffc0206d3c:	35a00593          	li	a1,858
ffffffffc0206d40:	00007517          	auipc	a0,0x7
ffffffffc0206d44:	84050513          	addi	a0,a0,-1984 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206d48:	f56f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206d4c:	00006617          	auipc	a2,0x6
ffffffffc0206d50:	8fc60613          	addi	a2,a2,-1796 # ffffffffc020c648 <default_pmm_manager+0xe0>
ffffffffc0206d54:	36200593          	li	a1,866
ffffffffc0206d58:	00007517          	auipc	a0,0x7
ffffffffc0206d5c:	82850513          	addi	a0,a0,-2008 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206d60:	f3ef90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206d64:	00007697          	auipc	a3,0x7
ffffffffc0206d68:	b4c68693          	addi	a3,a3,-1204 # ffffffffc020d8b0 <CSWTCH.79+0x420>
ffffffffc0206d6c:	00005617          	auipc	a2,0x5
ffffffffc0206d70:	d1460613          	addi	a2,a2,-748 # ffffffffc020ba80 <commands+0x210>
ffffffffc0206d74:	35d00593          	li	a1,861
ffffffffc0206d78:	00007517          	auipc	a0,0x7
ffffffffc0206d7c:	80850513          	addi	a0,a0,-2040 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206d80:	f1ef90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206d84:	00007697          	auipc	a3,0x7
ffffffffc0206d88:	ae468693          	addi	a3,a3,-1308 # ffffffffc020d868 <CSWTCH.79+0x3d8>
ffffffffc0206d8c:	00005617          	auipc	a2,0x5
ffffffffc0206d90:	cf460613          	addi	a2,a2,-780 # ffffffffc020ba80 <commands+0x210>
ffffffffc0206d94:	35c00593          	li	a1,860
ffffffffc0206d98:	00006517          	auipc	a0,0x6
ffffffffc0206d9c:	7e850513          	addi	a0,a0,2024 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206da0:	efef90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206da4:	00007697          	auipc	a3,0x7
ffffffffc0206da8:	a7c68693          	addi	a3,a3,-1412 # ffffffffc020d820 <CSWTCH.79+0x390>
ffffffffc0206dac:	00005617          	auipc	a2,0x5
ffffffffc0206db0:	cd460613          	addi	a2,a2,-812 # ffffffffc020ba80 <commands+0x210>
ffffffffc0206db4:	35b00593          	li	a1,859
ffffffffc0206db8:	00006517          	auipc	a0,0x6
ffffffffc0206dbc:	7c850513          	addi	a0,a0,1992 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206dc0:	edef90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0206dc4 <user_main>:
ffffffffc0206dc4:	7179                	addi	sp,sp,-48
ffffffffc0206dc6:	e84a                	sd	s2,16(sp)
ffffffffc0206dc8:	00090917          	auipc	s2,0x90
ffffffffc0206dcc:	af890913          	addi	s2,s2,-1288 # ffffffffc02968c0 <current>
ffffffffc0206dd0:	00093783          	ld	a5,0(s2)
ffffffffc0206dd4:	00007617          	auipc	a2,0x7
ffffffffc0206dd8:	b2460613          	addi	a2,a2,-1244 # ffffffffc020d8f8 <CSWTCH.79+0x468>
ffffffffc0206ddc:	00007517          	auipc	a0,0x7
ffffffffc0206de0:	b2450513          	addi	a0,a0,-1244 # ffffffffc020d900 <CSWTCH.79+0x470>
ffffffffc0206de4:	43cc                	lw	a1,4(a5)
ffffffffc0206de6:	f406                	sd	ra,40(sp)
ffffffffc0206de8:	f022                	sd	s0,32(sp)
ffffffffc0206dea:	ec26                	sd	s1,24(sp)
ffffffffc0206dec:	e032                	sd	a2,0(sp)
ffffffffc0206dee:	e402                	sd	zero,8(sp)
ffffffffc0206df0:	bb6f90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0206df4:	6782                	ld	a5,0(sp)
ffffffffc0206df6:	cfb9                	beqz	a5,ffffffffc0206e54 <user_main+0x90>
ffffffffc0206df8:	003c                	addi	a5,sp,8
ffffffffc0206dfa:	4401                	li	s0,0
ffffffffc0206dfc:	6398                	ld	a4,0(a5)
ffffffffc0206dfe:	0405                	addi	s0,s0,1
ffffffffc0206e00:	07a1                	addi	a5,a5,8
ffffffffc0206e02:	ff6d                	bnez	a4,ffffffffc0206dfc <user_main+0x38>
ffffffffc0206e04:	00093783          	ld	a5,0(s2)
ffffffffc0206e08:	12000613          	li	a2,288
ffffffffc0206e0c:	6b84                	ld	s1,16(a5)
ffffffffc0206e0e:	73cc                	ld	a1,160(a5)
ffffffffc0206e10:	6789                	lui	a5,0x2
ffffffffc0206e12:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206e16:	94be                	add	s1,s1,a5
ffffffffc0206e18:	8526                	mv	a0,s1
ffffffffc0206e1a:	7d2040ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc0206e1e:	00093783          	ld	a5,0(s2)
ffffffffc0206e22:	860a                	mv	a2,sp
ffffffffc0206e24:	0004059b          	sext.w	a1,s0
ffffffffc0206e28:	f3c4                	sd	s1,160(a5)
ffffffffc0206e2a:	00007517          	auipc	a0,0x7
ffffffffc0206e2e:	ace50513          	addi	a0,a0,-1330 # ffffffffc020d8f8 <CSWTCH.79+0x468>
ffffffffc0206e32:	eb0ff0ef          	jal	ra,ffffffffc02064e2 <do_execve>
ffffffffc0206e36:	8126                	mv	sp,s1
ffffffffc0206e38:	c18fa06f          	j	ffffffffc0201250 <__trapret>
ffffffffc0206e3c:	00007617          	auipc	a2,0x7
ffffffffc0206e40:	aec60613          	addi	a2,a2,-1300 # ffffffffc020d928 <CSWTCH.79+0x498>
ffffffffc0206e44:	4a300593          	li	a1,1187
ffffffffc0206e48:	00006517          	auipc	a0,0x6
ffffffffc0206e4c:	73850513          	addi	a0,a0,1848 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0206e50:	e4ef90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0206e54:	4401                	li	s0,0
ffffffffc0206e56:	b77d                	j	ffffffffc0206e04 <user_main+0x40>

ffffffffc0206e58 <do_yield>:
ffffffffc0206e58:	00090797          	auipc	a5,0x90
ffffffffc0206e5c:	a687b783          	ld	a5,-1432(a5) # ffffffffc02968c0 <current>
ffffffffc0206e60:	4705                	li	a4,1
ffffffffc0206e62:	ef98                	sd	a4,24(a5)
ffffffffc0206e64:	4501                	li	a0,0
ffffffffc0206e66:	8082                	ret

ffffffffc0206e68 <do_wait>:
ffffffffc0206e68:	1101                	addi	sp,sp,-32
ffffffffc0206e6a:	e822                	sd	s0,16(sp)
ffffffffc0206e6c:	e426                	sd	s1,8(sp)
ffffffffc0206e6e:	ec06                	sd	ra,24(sp)
ffffffffc0206e70:	842e                	mv	s0,a1
ffffffffc0206e72:	84aa                	mv	s1,a0
ffffffffc0206e74:	c999                	beqz	a1,ffffffffc0206e8a <do_wait+0x22>
ffffffffc0206e76:	00090797          	auipc	a5,0x90
ffffffffc0206e7a:	a4a7b783          	ld	a5,-1462(a5) # ffffffffc02968c0 <current>
ffffffffc0206e7e:	7788                	ld	a0,40(a5)
ffffffffc0206e80:	4685                	li	a3,1
ffffffffc0206e82:	4611                	li	a2,4
ffffffffc0206e84:	c8cfd0ef          	jal	ra,ffffffffc0204310 <user_mem_check>
ffffffffc0206e88:	c909                	beqz	a0,ffffffffc0206e9a <do_wait+0x32>
ffffffffc0206e8a:	85a2                	mv	a1,s0
ffffffffc0206e8c:	6442                	ld	s0,16(sp)
ffffffffc0206e8e:	60e2                	ld	ra,24(sp)
ffffffffc0206e90:	8526                	mv	a0,s1
ffffffffc0206e92:	64a2                	ld	s1,8(sp)
ffffffffc0206e94:	6105                	addi	sp,sp,32
ffffffffc0206e96:	b2aff06f          	j	ffffffffc02061c0 <do_wait.part.0>
ffffffffc0206e9a:	60e2                	ld	ra,24(sp)
ffffffffc0206e9c:	6442                	ld	s0,16(sp)
ffffffffc0206e9e:	64a2                	ld	s1,8(sp)
ffffffffc0206ea0:	5575                	li	a0,-3
ffffffffc0206ea2:	6105                	addi	sp,sp,32
ffffffffc0206ea4:	8082                	ret

ffffffffc0206ea6 <do_kill>:
ffffffffc0206ea6:	1141                	addi	sp,sp,-16
ffffffffc0206ea8:	6789                	lui	a5,0x2
ffffffffc0206eaa:	e406                	sd	ra,8(sp)
ffffffffc0206eac:	e022                	sd	s0,0(sp)
ffffffffc0206eae:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206eb2:	17f9                	addi	a5,a5,-2
ffffffffc0206eb4:	02e7e963          	bltu	a5,a4,ffffffffc0206ee6 <do_kill+0x40>
ffffffffc0206eb8:	842a                	mv	s0,a0
ffffffffc0206eba:	45a9                	li	a1,10
ffffffffc0206ebc:	2501                	sext.w	a0,a0
ffffffffc0206ebe:	1a8040ef          	jal	ra,ffffffffc020b066 <hash32>
ffffffffc0206ec2:	02051793          	slli	a5,a0,0x20
ffffffffc0206ec6:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206eca:	0008b797          	auipc	a5,0x8b
ffffffffc0206ece:	8f678793          	addi	a5,a5,-1802 # ffffffffc02917c0 <hash_list>
ffffffffc0206ed2:	953e                	add	a0,a0,a5
ffffffffc0206ed4:	87aa                	mv	a5,a0
ffffffffc0206ed6:	a029                	j	ffffffffc0206ee0 <do_kill+0x3a>
ffffffffc0206ed8:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206edc:	00870b63          	beq	a4,s0,ffffffffc0206ef2 <do_kill+0x4c>
ffffffffc0206ee0:	679c                	ld	a5,8(a5)
ffffffffc0206ee2:	fef51be3          	bne	a0,a5,ffffffffc0206ed8 <do_kill+0x32>
ffffffffc0206ee6:	5475                	li	s0,-3
ffffffffc0206ee8:	60a2                	ld	ra,8(sp)
ffffffffc0206eea:	8522                	mv	a0,s0
ffffffffc0206eec:	6402                	ld	s0,0(sp)
ffffffffc0206eee:	0141                	addi	sp,sp,16
ffffffffc0206ef0:	8082                	ret
ffffffffc0206ef2:	fd87a703          	lw	a4,-40(a5)
ffffffffc0206ef6:	00177693          	andi	a3,a4,1
ffffffffc0206efa:	e295                	bnez	a3,ffffffffc0206f1e <do_kill+0x78>
ffffffffc0206efc:	4bd4                	lw	a3,20(a5)
ffffffffc0206efe:	00176713          	ori	a4,a4,1
ffffffffc0206f02:	fce7ac23          	sw	a4,-40(a5)
ffffffffc0206f06:	4401                	li	s0,0
ffffffffc0206f08:	fe06d0e3          	bgez	a3,ffffffffc0206ee8 <do_kill+0x42>
ffffffffc0206f0c:	f2878513          	addi	a0,a5,-216
ffffffffc0206f10:	45a000ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc0206f14:	60a2                	ld	ra,8(sp)
ffffffffc0206f16:	8522                	mv	a0,s0
ffffffffc0206f18:	6402                	ld	s0,0(sp)
ffffffffc0206f1a:	0141                	addi	sp,sp,16
ffffffffc0206f1c:	8082                	ret
ffffffffc0206f1e:	545d                	li	s0,-9
ffffffffc0206f20:	b7e1                	j	ffffffffc0206ee8 <do_kill+0x42>

ffffffffc0206f22 <proc_init>:
ffffffffc0206f22:	1101                	addi	sp,sp,-32
ffffffffc0206f24:	e426                	sd	s1,8(sp)
ffffffffc0206f26:	0008f797          	auipc	a5,0x8f
ffffffffc0206f2a:	89a78793          	addi	a5,a5,-1894 # ffffffffc02957c0 <proc_list>
ffffffffc0206f2e:	ec06                	sd	ra,24(sp)
ffffffffc0206f30:	e822                	sd	s0,16(sp)
ffffffffc0206f32:	e04a                	sd	s2,0(sp)
ffffffffc0206f34:	0008b497          	auipc	s1,0x8b
ffffffffc0206f38:	88c48493          	addi	s1,s1,-1908 # ffffffffc02917c0 <hash_list>
ffffffffc0206f3c:	e79c                	sd	a5,8(a5)
ffffffffc0206f3e:	e39c                	sd	a5,0(a5)
ffffffffc0206f40:	0008f717          	auipc	a4,0x8f
ffffffffc0206f44:	88070713          	addi	a4,a4,-1920 # ffffffffc02957c0 <proc_list>
ffffffffc0206f48:	87a6                	mv	a5,s1
ffffffffc0206f4a:	e79c                	sd	a5,8(a5)
ffffffffc0206f4c:	e39c                	sd	a5,0(a5)
ffffffffc0206f4e:	07c1                	addi	a5,a5,16
ffffffffc0206f50:	fef71de3          	bne	a4,a5,ffffffffc0206f4a <proc_init+0x28>
ffffffffc0206f54:	afffe0ef          	jal	ra,ffffffffc0205a52 <alloc_proc>
ffffffffc0206f58:	00090917          	auipc	s2,0x90
ffffffffc0206f5c:	97090913          	addi	s2,s2,-1680 # ffffffffc02968c8 <idleproc>
ffffffffc0206f60:	00a93023          	sd	a0,0(s2)
ffffffffc0206f64:	842a                	mv	s0,a0
ffffffffc0206f66:	12050863          	beqz	a0,ffffffffc0207096 <proc_init+0x174>
ffffffffc0206f6a:	4789                	li	a5,2
ffffffffc0206f6c:	e11c                	sd	a5,0(a0)
ffffffffc0206f6e:	0000a797          	auipc	a5,0xa
ffffffffc0206f72:	09278793          	addi	a5,a5,146 # ffffffffc0211000 <bootstack>
ffffffffc0206f76:	e91c                	sd	a5,16(a0)
ffffffffc0206f78:	4785                	li	a5,1
ffffffffc0206f7a:	ed1c                	sd	a5,24(a0)
ffffffffc0206f7c:	ad0fe0ef          	jal	ra,ffffffffc020524c <files_create>
ffffffffc0206f80:	14a43423          	sd	a0,328(s0)
ffffffffc0206f84:	0e050d63          	beqz	a0,ffffffffc020707e <proc_init+0x15c>
ffffffffc0206f88:	00093403          	ld	s0,0(s2)
ffffffffc0206f8c:	4641                	li	a2,16
ffffffffc0206f8e:	4581                	li	a1,0
ffffffffc0206f90:	14843703          	ld	a4,328(s0)
ffffffffc0206f94:	0b440413          	addi	s0,s0,180
ffffffffc0206f98:	8522                	mv	a0,s0
ffffffffc0206f9a:	4b1c                	lw	a5,16(a4)
ffffffffc0206f9c:	2785                	addiw	a5,a5,1
ffffffffc0206f9e:	cb1c                	sw	a5,16(a4)
ffffffffc0206fa0:	5fa040ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0206fa4:	463d                	li	a2,15
ffffffffc0206fa6:	00007597          	auipc	a1,0x7
ffffffffc0206faa:	9e258593          	addi	a1,a1,-1566 # ffffffffc020d988 <CSWTCH.79+0x4f8>
ffffffffc0206fae:	8522                	mv	a0,s0
ffffffffc0206fb0:	63c040ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc0206fb4:	00090717          	auipc	a4,0x90
ffffffffc0206fb8:	92470713          	addi	a4,a4,-1756 # ffffffffc02968d8 <nr_process>
ffffffffc0206fbc:	431c                	lw	a5,0(a4)
ffffffffc0206fbe:	00093683          	ld	a3,0(s2)
ffffffffc0206fc2:	4601                	li	a2,0
ffffffffc0206fc4:	2785                	addiw	a5,a5,1
ffffffffc0206fc6:	4581                	li	a1,0
ffffffffc0206fc8:	fffff517          	auipc	a0,0xfffff
ffffffffc0206fcc:	3ca50513          	addi	a0,a0,970 # ffffffffc0206392 <init_main>
ffffffffc0206fd0:	c31c                	sw	a5,0(a4)
ffffffffc0206fd2:	00090797          	auipc	a5,0x90
ffffffffc0206fd6:	8ed7b723          	sd	a3,-1810(a5) # ffffffffc02968c0 <current>
ffffffffc0206fda:	834ff0ef          	jal	ra,ffffffffc020600e <kernel_thread>
ffffffffc0206fde:	842a                	mv	s0,a0
ffffffffc0206fe0:	08a05363          	blez	a0,ffffffffc0207066 <proc_init+0x144>
ffffffffc0206fe4:	6789                	lui	a5,0x2
ffffffffc0206fe6:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206fea:	17f9                	addi	a5,a5,-2
ffffffffc0206fec:	2501                	sext.w	a0,a0
ffffffffc0206fee:	02e7e363          	bltu	a5,a4,ffffffffc0207014 <proc_init+0xf2>
ffffffffc0206ff2:	45a9                	li	a1,10
ffffffffc0206ff4:	072040ef          	jal	ra,ffffffffc020b066 <hash32>
ffffffffc0206ff8:	02051793          	slli	a5,a0,0x20
ffffffffc0206ffc:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0207000:	96a6                	add	a3,a3,s1
ffffffffc0207002:	87b6                	mv	a5,a3
ffffffffc0207004:	a029                	j	ffffffffc020700e <proc_init+0xec>
ffffffffc0207006:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc020700a:	04870b63          	beq	a4,s0,ffffffffc0207060 <proc_init+0x13e>
ffffffffc020700e:	679c                	ld	a5,8(a5)
ffffffffc0207010:	fef69be3          	bne	a3,a5,ffffffffc0207006 <proc_init+0xe4>
ffffffffc0207014:	4781                	li	a5,0
ffffffffc0207016:	0b478493          	addi	s1,a5,180
ffffffffc020701a:	4641                	li	a2,16
ffffffffc020701c:	4581                	li	a1,0
ffffffffc020701e:	00090417          	auipc	s0,0x90
ffffffffc0207022:	8b240413          	addi	s0,s0,-1870 # ffffffffc02968d0 <initproc>
ffffffffc0207026:	8526                	mv	a0,s1
ffffffffc0207028:	e01c                	sd	a5,0(s0)
ffffffffc020702a:	570040ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc020702e:	463d                	li	a2,15
ffffffffc0207030:	00007597          	auipc	a1,0x7
ffffffffc0207034:	98058593          	addi	a1,a1,-1664 # ffffffffc020d9b0 <CSWTCH.79+0x520>
ffffffffc0207038:	8526                	mv	a0,s1
ffffffffc020703a:	5b2040ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020703e:	00093783          	ld	a5,0(s2)
ffffffffc0207042:	c7d1                	beqz	a5,ffffffffc02070ce <proc_init+0x1ac>
ffffffffc0207044:	43dc                	lw	a5,4(a5)
ffffffffc0207046:	e7c1                	bnez	a5,ffffffffc02070ce <proc_init+0x1ac>
ffffffffc0207048:	601c                	ld	a5,0(s0)
ffffffffc020704a:	c3b5                	beqz	a5,ffffffffc02070ae <proc_init+0x18c>
ffffffffc020704c:	43d8                	lw	a4,4(a5)
ffffffffc020704e:	4785                	li	a5,1
ffffffffc0207050:	04f71f63          	bne	a4,a5,ffffffffc02070ae <proc_init+0x18c>
ffffffffc0207054:	60e2                	ld	ra,24(sp)
ffffffffc0207056:	6442                	ld	s0,16(sp)
ffffffffc0207058:	64a2                	ld	s1,8(sp)
ffffffffc020705a:	6902                	ld	s2,0(sp)
ffffffffc020705c:	6105                	addi	sp,sp,32
ffffffffc020705e:	8082                	ret
ffffffffc0207060:	f2878793          	addi	a5,a5,-216
ffffffffc0207064:	bf4d                	j	ffffffffc0207016 <proc_init+0xf4>
ffffffffc0207066:	00007617          	auipc	a2,0x7
ffffffffc020706a:	92a60613          	addi	a2,a2,-1750 # ffffffffc020d990 <CSWTCH.79+0x500>
ffffffffc020706e:	4ef00593          	li	a1,1263
ffffffffc0207072:	00006517          	auipc	a0,0x6
ffffffffc0207076:	50e50513          	addi	a0,a0,1294 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc020707a:	c24f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020707e:	00007617          	auipc	a2,0x7
ffffffffc0207082:	8e260613          	addi	a2,a2,-1822 # ffffffffc020d960 <CSWTCH.79+0x4d0>
ffffffffc0207086:	4e300593          	li	a1,1251
ffffffffc020708a:	00006517          	auipc	a0,0x6
ffffffffc020708e:	4f650513          	addi	a0,a0,1270 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc0207092:	c0cf90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207096:	00007617          	auipc	a2,0x7
ffffffffc020709a:	8b260613          	addi	a2,a2,-1870 # ffffffffc020d948 <CSWTCH.79+0x4b8>
ffffffffc020709e:	4d900593          	li	a1,1241
ffffffffc02070a2:	00006517          	auipc	a0,0x6
ffffffffc02070a6:	4de50513          	addi	a0,a0,1246 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc02070aa:	bf4f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02070ae:	00007697          	auipc	a3,0x7
ffffffffc02070b2:	93268693          	addi	a3,a3,-1742 # ffffffffc020d9e0 <CSWTCH.79+0x550>
ffffffffc02070b6:	00005617          	auipc	a2,0x5
ffffffffc02070ba:	9ca60613          	addi	a2,a2,-1590 # ffffffffc020ba80 <commands+0x210>
ffffffffc02070be:	4f600593          	li	a1,1270
ffffffffc02070c2:	00006517          	auipc	a0,0x6
ffffffffc02070c6:	4be50513          	addi	a0,a0,1214 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc02070ca:	bd4f90ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02070ce:	00007697          	auipc	a3,0x7
ffffffffc02070d2:	8ea68693          	addi	a3,a3,-1814 # ffffffffc020d9b8 <CSWTCH.79+0x528>
ffffffffc02070d6:	00005617          	auipc	a2,0x5
ffffffffc02070da:	9aa60613          	addi	a2,a2,-1622 # ffffffffc020ba80 <commands+0x210>
ffffffffc02070de:	4f500593          	li	a1,1269
ffffffffc02070e2:	00006517          	auipc	a0,0x6
ffffffffc02070e6:	49e50513          	addi	a0,a0,1182 # ffffffffc020d580 <CSWTCH.79+0xf0>
ffffffffc02070ea:	bb4f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02070ee <cpu_idle>:
ffffffffc02070ee:	1141                	addi	sp,sp,-16
ffffffffc02070f0:	e022                	sd	s0,0(sp)
ffffffffc02070f2:	e406                	sd	ra,8(sp)
ffffffffc02070f4:	0008f417          	auipc	s0,0x8f
ffffffffc02070f8:	7cc40413          	addi	s0,s0,1996 # ffffffffc02968c0 <current>
ffffffffc02070fc:	6018                	ld	a4,0(s0)
ffffffffc02070fe:	6f1c                	ld	a5,24(a4)
ffffffffc0207100:	dffd                	beqz	a5,ffffffffc02070fe <cpu_idle+0x10>
ffffffffc0207102:	31a000ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc0207106:	bfdd                	j	ffffffffc02070fc <cpu_idle+0xe>

ffffffffc0207108 <lab6_set_priority>:
ffffffffc0207108:	1141                	addi	sp,sp,-16
ffffffffc020710a:	e022                	sd	s0,0(sp)
ffffffffc020710c:	85aa                	mv	a1,a0
ffffffffc020710e:	842a                	mv	s0,a0
ffffffffc0207110:	00007517          	auipc	a0,0x7
ffffffffc0207114:	8f850513          	addi	a0,a0,-1800 # ffffffffc020da08 <CSWTCH.79+0x578>
ffffffffc0207118:	e406                	sd	ra,8(sp)
ffffffffc020711a:	88cf90ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020711e:	0008f797          	auipc	a5,0x8f
ffffffffc0207122:	7a27b783          	ld	a5,1954(a5) # ffffffffc02968c0 <current>
ffffffffc0207126:	e801                	bnez	s0,ffffffffc0207136 <lab6_set_priority+0x2e>
ffffffffc0207128:	60a2                	ld	ra,8(sp)
ffffffffc020712a:	6402                	ld	s0,0(sp)
ffffffffc020712c:	4705                	li	a4,1
ffffffffc020712e:	14e7a223          	sw	a4,324(a5)
ffffffffc0207132:	0141                	addi	sp,sp,16
ffffffffc0207134:	8082                	ret
ffffffffc0207136:	60a2                	ld	ra,8(sp)
ffffffffc0207138:	1487a223          	sw	s0,324(a5)
ffffffffc020713c:	6402                	ld	s0,0(sp)
ffffffffc020713e:	0141                	addi	sp,sp,16
ffffffffc0207140:	8082                	ret

ffffffffc0207142 <do_sleep>:
ffffffffc0207142:	c539                	beqz	a0,ffffffffc0207190 <do_sleep+0x4e>
ffffffffc0207144:	7179                	addi	sp,sp,-48
ffffffffc0207146:	f022                	sd	s0,32(sp)
ffffffffc0207148:	f406                	sd	ra,40(sp)
ffffffffc020714a:	842a                	mv	s0,a0
ffffffffc020714c:	100027f3          	csrr	a5,sstatus
ffffffffc0207150:	8b89                	andi	a5,a5,2
ffffffffc0207152:	e3a9                	bnez	a5,ffffffffc0207194 <do_sleep+0x52>
ffffffffc0207154:	0008f797          	auipc	a5,0x8f
ffffffffc0207158:	76c7b783          	ld	a5,1900(a5) # ffffffffc02968c0 <current>
ffffffffc020715c:	0818                	addi	a4,sp,16
ffffffffc020715e:	c02a                	sw	a0,0(sp)
ffffffffc0207160:	ec3a                	sd	a4,24(sp)
ffffffffc0207162:	e83a                	sd	a4,16(sp)
ffffffffc0207164:	e43e                	sd	a5,8(sp)
ffffffffc0207166:	4705                	li	a4,1
ffffffffc0207168:	c398                	sw	a4,0(a5)
ffffffffc020716a:	80000737          	lui	a4,0x80000
ffffffffc020716e:	840a                	mv	s0,sp
ffffffffc0207170:	0709                	addi	a4,a4,2
ffffffffc0207172:	0ee7a623          	sw	a4,236(a5)
ffffffffc0207176:	8522                	mv	a0,s0
ffffffffc0207178:	364000ef          	jal	ra,ffffffffc02074dc <add_timer>
ffffffffc020717c:	2a0000ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc0207180:	8522                	mv	a0,s0
ffffffffc0207182:	422000ef          	jal	ra,ffffffffc02075a4 <del_timer>
ffffffffc0207186:	70a2                	ld	ra,40(sp)
ffffffffc0207188:	7402                	ld	s0,32(sp)
ffffffffc020718a:	4501                	li	a0,0
ffffffffc020718c:	6145                	addi	sp,sp,48
ffffffffc020718e:	8082                	ret
ffffffffc0207190:	4501                	li	a0,0
ffffffffc0207192:	8082                	ret
ffffffffc0207194:	adff90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207198:	0008f797          	auipc	a5,0x8f
ffffffffc020719c:	7287b783          	ld	a5,1832(a5) # ffffffffc02968c0 <current>
ffffffffc02071a0:	0818                	addi	a4,sp,16
ffffffffc02071a2:	c022                	sw	s0,0(sp)
ffffffffc02071a4:	e43e                	sd	a5,8(sp)
ffffffffc02071a6:	ec3a                	sd	a4,24(sp)
ffffffffc02071a8:	e83a                	sd	a4,16(sp)
ffffffffc02071aa:	4705                	li	a4,1
ffffffffc02071ac:	c398                	sw	a4,0(a5)
ffffffffc02071ae:	80000737          	lui	a4,0x80000
ffffffffc02071b2:	0709                	addi	a4,a4,2
ffffffffc02071b4:	840a                	mv	s0,sp
ffffffffc02071b6:	8522                	mv	a0,s0
ffffffffc02071b8:	0ee7a623          	sw	a4,236(a5)
ffffffffc02071bc:	320000ef          	jal	ra,ffffffffc02074dc <add_timer>
ffffffffc02071c0:	aadf90ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc02071c4:	bf65                	j	ffffffffc020717c <do_sleep+0x3a>

ffffffffc02071c6 <switch_to>:
ffffffffc02071c6:	00153023          	sd	ra,0(a0)
ffffffffc02071ca:	00253423          	sd	sp,8(a0)
ffffffffc02071ce:	e900                	sd	s0,16(a0)
ffffffffc02071d0:	ed04                	sd	s1,24(a0)
ffffffffc02071d2:	03253023          	sd	s2,32(a0)
ffffffffc02071d6:	03353423          	sd	s3,40(a0)
ffffffffc02071da:	03453823          	sd	s4,48(a0)
ffffffffc02071de:	03553c23          	sd	s5,56(a0)
ffffffffc02071e2:	05653023          	sd	s6,64(a0)
ffffffffc02071e6:	05753423          	sd	s7,72(a0)
ffffffffc02071ea:	05853823          	sd	s8,80(a0)
ffffffffc02071ee:	05953c23          	sd	s9,88(a0)
ffffffffc02071f2:	07a53023          	sd	s10,96(a0)
ffffffffc02071f6:	07b53423          	sd	s11,104(a0)
ffffffffc02071fa:	0005b083          	ld	ra,0(a1)
ffffffffc02071fe:	0085b103          	ld	sp,8(a1)
ffffffffc0207202:	6980                	ld	s0,16(a1)
ffffffffc0207204:	6d84                	ld	s1,24(a1)
ffffffffc0207206:	0205b903          	ld	s2,32(a1)
ffffffffc020720a:	0285b983          	ld	s3,40(a1)
ffffffffc020720e:	0305ba03          	ld	s4,48(a1)
ffffffffc0207212:	0385ba83          	ld	s5,56(a1)
ffffffffc0207216:	0405bb03          	ld	s6,64(a1)
ffffffffc020721a:	0485bb83          	ld	s7,72(a1)
ffffffffc020721e:	0505bc03          	ld	s8,80(a1)
ffffffffc0207222:	0585bc83          	ld	s9,88(a1)
ffffffffc0207226:	0605bd03          	ld	s10,96(a1)
ffffffffc020722a:	0685bd83          	ld	s11,104(a1)
ffffffffc020722e:	8082                	ret

ffffffffc0207230 <RR_init>:
ffffffffc0207230:	e508                	sd	a0,8(a0)
ffffffffc0207232:	e108                	sd	a0,0(a0)
ffffffffc0207234:	00052823          	sw	zero,16(a0)
ffffffffc0207238:	8082                	ret

ffffffffc020723a <RR_pick_next>:
ffffffffc020723a:	651c                	ld	a5,8(a0)
ffffffffc020723c:	00f50563          	beq	a0,a5,ffffffffc0207246 <RR_pick_next+0xc>
ffffffffc0207240:	ef078513          	addi	a0,a5,-272
ffffffffc0207244:	8082                	ret
ffffffffc0207246:	4501                	li	a0,0
ffffffffc0207248:	8082                	ret

ffffffffc020724a <RR_proc_tick>:
ffffffffc020724a:	1205a783          	lw	a5,288(a1)
ffffffffc020724e:	00f05563          	blez	a5,ffffffffc0207258 <RR_proc_tick+0xe>
ffffffffc0207252:	37fd                	addiw	a5,a5,-1
ffffffffc0207254:	12f5a023          	sw	a5,288(a1)
ffffffffc0207258:	e399                	bnez	a5,ffffffffc020725e <RR_proc_tick+0x14>
ffffffffc020725a:	4785                	li	a5,1
ffffffffc020725c:	ed9c                	sd	a5,24(a1)
ffffffffc020725e:	8082                	ret

ffffffffc0207260 <RR_dequeue>:
ffffffffc0207260:	1185b703          	ld	a4,280(a1)
ffffffffc0207264:	11058793          	addi	a5,a1,272
ffffffffc0207268:	02e78363          	beq	a5,a4,ffffffffc020728e <RR_dequeue+0x2e>
ffffffffc020726c:	1085b683          	ld	a3,264(a1)
ffffffffc0207270:	00a69f63          	bne	a3,a0,ffffffffc020728e <RR_dequeue+0x2e>
ffffffffc0207274:	1105b503          	ld	a0,272(a1)
ffffffffc0207278:	4a90                	lw	a2,16(a3)
ffffffffc020727a:	e518                	sd	a4,8(a0)
ffffffffc020727c:	e308                	sd	a0,0(a4)
ffffffffc020727e:	10f5bc23          	sd	a5,280(a1)
ffffffffc0207282:	10f5b823          	sd	a5,272(a1)
ffffffffc0207286:	fff6079b          	addiw	a5,a2,-1
ffffffffc020728a:	ca9c                	sw	a5,16(a3)
ffffffffc020728c:	8082                	ret
ffffffffc020728e:	1141                	addi	sp,sp,-16
ffffffffc0207290:	00006697          	auipc	a3,0x6
ffffffffc0207294:	79068693          	addi	a3,a3,1936 # ffffffffc020da20 <CSWTCH.79+0x590>
ffffffffc0207298:	00004617          	auipc	a2,0x4
ffffffffc020729c:	7e860613          	addi	a2,a2,2024 # ffffffffc020ba80 <commands+0x210>
ffffffffc02072a0:	03c00593          	li	a1,60
ffffffffc02072a4:	00006517          	auipc	a0,0x6
ffffffffc02072a8:	7b450513          	addi	a0,a0,1972 # ffffffffc020da58 <CSWTCH.79+0x5c8>
ffffffffc02072ac:	e406                	sd	ra,8(sp)
ffffffffc02072ae:	9f0f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02072b2 <RR_enqueue>:
ffffffffc02072b2:	1185b703          	ld	a4,280(a1)
ffffffffc02072b6:	11058793          	addi	a5,a1,272
ffffffffc02072ba:	02e79d63          	bne	a5,a4,ffffffffc02072f4 <RR_enqueue+0x42>
ffffffffc02072be:	6118                	ld	a4,0(a0)
ffffffffc02072c0:	1205a683          	lw	a3,288(a1)
ffffffffc02072c4:	e11c                	sd	a5,0(a0)
ffffffffc02072c6:	e71c                	sd	a5,8(a4)
ffffffffc02072c8:	10a5bc23          	sd	a0,280(a1)
ffffffffc02072cc:	10e5b823          	sd	a4,272(a1)
ffffffffc02072d0:	495c                	lw	a5,20(a0)
ffffffffc02072d2:	ea89                	bnez	a3,ffffffffc02072e4 <RR_enqueue+0x32>
ffffffffc02072d4:	12f5a023          	sw	a5,288(a1)
ffffffffc02072d8:	491c                	lw	a5,16(a0)
ffffffffc02072da:	10a5b423          	sd	a0,264(a1)
ffffffffc02072de:	2785                	addiw	a5,a5,1
ffffffffc02072e0:	c91c                	sw	a5,16(a0)
ffffffffc02072e2:	8082                	ret
ffffffffc02072e4:	fed7c8e3          	blt	a5,a3,ffffffffc02072d4 <RR_enqueue+0x22>
ffffffffc02072e8:	491c                	lw	a5,16(a0)
ffffffffc02072ea:	10a5b423          	sd	a0,264(a1)
ffffffffc02072ee:	2785                	addiw	a5,a5,1
ffffffffc02072f0:	c91c                	sw	a5,16(a0)
ffffffffc02072f2:	8082                	ret
ffffffffc02072f4:	1141                	addi	sp,sp,-16
ffffffffc02072f6:	00006697          	auipc	a3,0x6
ffffffffc02072fa:	78268693          	addi	a3,a3,1922 # ffffffffc020da78 <CSWTCH.79+0x5e8>
ffffffffc02072fe:	00004617          	auipc	a2,0x4
ffffffffc0207302:	78260613          	addi	a2,a2,1922 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207306:	02800593          	li	a1,40
ffffffffc020730a:	00006517          	auipc	a0,0x6
ffffffffc020730e:	74e50513          	addi	a0,a0,1870 # ffffffffc020da58 <CSWTCH.79+0x5c8>
ffffffffc0207312:	e406                	sd	ra,8(sp)
ffffffffc0207314:	98af90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207318 <sched_init>:
ffffffffc0207318:	1141                	addi	sp,sp,-16
ffffffffc020731a:	0008a717          	auipc	a4,0x8a
ffffffffc020731e:	d0670713          	addi	a4,a4,-762 # ffffffffc0291020 <default_sched_class>
ffffffffc0207322:	e022                	sd	s0,0(sp)
ffffffffc0207324:	e406                	sd	ra,8(sp)
ffffffffc0207326:	0008e797          	auipc	a5,0x8e
ffffffffc020732a:	4ca78793          	addi	a5,a5,1226 # ffffffffc02957f0 <timer_list>
ffffffffc020732e:	6714                	ld	a3,8(a4)
ffffffffc0207330:	0008e517          	auipc	a0,0x8e
ffffffffc0207334:	4a050513          	addi	a0,a0,1184 # ffffffffc02957d0 <__rq>
ffffffffc0207338:	e79c                	sd	a5,8(a5)
ffffffffc020733a:	e39c                	sd	a5,0(a5)
ffffffffc020733c:	4795                	li	a5,5
ffffffffc020733e:	c95c                	sw	a5,20(a0)
ffffffffc0207340:	0008f417          	auipc	s0,0x8f
ffffffffc0207344:	5a840413          	addi	s0,s0,1448 # ffffffffc02968e8 <sched_class>
ffffffffc0207348:	0008f797          	auipc	a5,0x8f
ffffffffc020734c:	58a7bc23          	sd	a0,1432(a5) # ffffffffc02968e0 <rq>
ffffffffc0207350:	e018                	sd	a4,0(s0)
ffffffffc0207352:	9682                	jalr	a3
ffffffffc0207354:	601c                	ld	a5,0(s0)
ffffffffc0207356:	6402                	ld	s0,0(sp)
ffffffffc0207358:	60a2                	ld	ra,8(sp)
ffffffffc020735a:	638c                	ld	a1,0(a5)
ffffffffc020735c:	00006517          	auipc	a0,0x6
ffffffffc0207360:	74c50513          	addi	a0,a0,1868 # ffffffffc020daa8 <CSWTCH.79+0x618>
ffffffffc0207364:	0141                	addi	sp,sp,16
ffffffffc0207366:	e41f806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc020736a <wakeup_proc>:
ffffffffc020736a:	4118                	lw	a4,0(a0)
ffffffffc020736c:	1101                	addi	sp,sp,-32
ffffffffc020736e:	ec06                	sd	ra,24(sp)
ffffffffc0207370:	e822                	sd	s0,16(sp)
ffffffffc0207372:	e426                	sd	s1,8(sp)
ffffffffc0207374:	478d                	li	a5,3
ffffffffc0207376:	08f70363          	beq	a4,a5,ffffffffc02073fc <wakeup_proc+0x92>
ffffffffc020737a:	842a                	mv	s0,a0
ffffffffc020737c:	100027f3          	csrr	a5,sstatus
ffffffffc0207380:	8b89                	andi	a5,a5,2
ffffffffc0207382:	4481                	li	s1,0
ffffffffc0207384:	e7bd                	bnez	a5,ffffffffc02073f2 <wakeup_proc+0x88>
ffffffffc0207386:	4789                	li	a5,2
ffffffffc0207388:	04f70863          	beq	a4,a5,ffffffffc02073d8 <wakeup_proc+0x6e>
ffffffffc020738c:	c01c                	sw	a5,0(s0)
ffffffffc020738e:	0e042623          	sw	zero,236(s0)
ffffffffc0207392:	0008f797          	auipc	a5,0x8f
ffffffffc0207396:	52e7b783          	ld	a5,1326(a5) # ffffffffc02968c0 <current>
ffffffffc020739a:	02878363          	beq	a5,s0,ffffffffc02073c0 <wakeup_proc+0x56>
ffffffffc020739e:	0008f797          	auipc	a5,0x8f
ffffffffc02073a2:	52a7b783          	ld	a5,1322(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02073a6:	00f40d63          	beq	s0,a5,ffffffffc02073c0 <wakeup_proc+0x56>
ffffffffc02073aa:	0008f797          	auipc	a5,0x8f
ffffffffc02073ae:	53e7b783          	ld	a5,1342(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02073b2:	6b9c                	ld	a5,16(a5)
ffffffffc02073b4:	85a2                	mv	a1,s0
ffffffffc02073b6:	0008f517          	auipc	a0,0x8f
ffffffffc02073ba:	52a53503          	ld	a0,1322(a0) # ffffffffc02968e0 <rq>
ffffffffc02073be:	9782                	jalr	a5
ffffffffc02073c0:	e491                	bnez	s1,ffffffffc02073cc <wakeup_proc+0x62>
ffffffffc02073c2:	60e2                	ld	ra,24(sp)
ffffffffc02073c4:	6442                	ld	s0,16(sp)
ffffffffc02073c6:	64a2                	ld	s1,8(sp)
ffffffffc02073c8:	6105                	addi	sp,sp,32
ffffffffc02073ca:	8082                	ret
ffffffffc02073cc:	6442                	ld	s0,16(sp)
ffffffffc02073ce:	60e2                	ld	ra,24(sp)
ffffffffc02073d0:	64a2                	ld	s1,8(sp)
ffffffffc02073d2:	6105                	addi	sp,sp,32
ffffffffc02073d4:	899f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02073d8:	00006617          	auipc	a2,0x6
ffffffffc02073dc:	72060613          	addi	a2,a2,1824 # ffffffffc020daf8 <CSWTCH.79+0x668>
ffffffffc02073e0:	05200593          	li	a1,82
ffffffffc02073e4:	00006517          	auipc	a0,0x6
ffffffffc02073e8:	6fc50513          	addi	a0,a0,1788 # ffffffffc020dae0 <CSWTCH.79+0x650>
ffffffffc02073ec:	91af90ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc02073f0:	bfc1                	j	ffffffffc02073c0 <wakeup_proc+0x56>
ffffffffc02073f2:	881f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02073f6:	4018                	lw	a4,0(s0)
ffffffffc02073f8:	4485                	li	s1,1
ffffffffc02073fa:	b771                	j	ffffffffc0207386 <wakeup_proc+0x1c>
ffffffffc02073fc:	00006697          	auipc	a3,0x6
ffffffffc0207400:	6c468693          	addi	a3,a3,1732 # ffffffffc020dac0 <CSWTCH.79+0x630>
ffffffffc0207404:	00004617          	auipc	a2,0x4
ffffffffc0207408:	67c60613          	addi	a2,a2,1660 # ffffffffc020ba80 <commands+0x210>
ffffffffc020740c:	04300593          	li	a1,67
ffffffffc0207410:	00006517          	auipc	a0,0x6
ffffffffc0207414:	6d050513          	addi	a0,a0,1744 # ffffffffc020dae0 <CSWTCH.79+0x650>
ffffffffc0207418:	886f90ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020741c <schedule>:
ffffffffc020741c:	7179                	addi	sp,sp,-48
ffffffffc020741e:	f406                	sd	ra,40(sp)
ffffffffc0207420:	f022                	sd	s0,32(sp)
ffffffffc0207422:	ec26                	sd	s1,24(sp)
ffffffffc0207424:	e84a                	sd	s2,16(sp)
ffffffffc0207426:	e44e                	sd	s3,8(sp)
ffffffffc0207428:	e052                	sd	s4,0(sp)
ffffffffc020742a:	100027f3          	csrr	a5,sstatus
ffffffffc020742e:	8b89                	andi	a5,a5,2
ffffffffc0207430:	4a01                	li	s4,0
ffffffffc0207432:	e3cd                	bnez	a5,ffffffffc02074d4 <schedule+0xb8>
ffffffffc0207434:	0008f497          	auipc	s1,0x8f
ffffffffc0207438:	48c48493          	addi	s1,s1,1164 # ffffffffc02968c0 <current>
ffffffffc020743c:	608c                	ld	a1,0(s1)
ffffffffc020743e:	0008f997          	auipc	s3,0x8f
ffffffffc0207442:	4aa98993          	addi	s3,s3,1194 # ffffffffc02968e8 <sched_class>
ffffffffc0207446:	0008f917          	auipc	s2,0x8f
ffffffffc020744a:	49a90913          	addi	s2,s2,1178 # ffffffffc02968e0 <rq>
ffffffffc020744e:	4194                	lw	a3,0(a1)
ffffffffc0207450:	0005bc23          	sd	zero,24(a1)
ffffffffc0207454:	4709                	li	a4,2
ffffffffc0207456:	0009b783          	ld	a5,0(s3)
ffffffffc020745a:	00093503          	ld	a0,0(s2)
ffffffffc020745e:	04e68e63          	beq	a3,a4,ffffffffc02074ba <schedule+0x9e>
ffffffffc0207462:	739c                	ld	a5,32(a5)
ffffffffc0207464:	9782                	jalr	a5
ffffffffc0207466:	842a                	mv	s0,a0
ffffffffc0207468:	c521                	beqz	a0,ffffffffc02074b0 <schedule+0x94>
ffffffffc020746a:	0009b783          	ld	a5,0(s3)
ffffffffc020746e:	00093503          	ld	a0,0(s2)
ffffffffc0207472:	85a2                	mv	a1,s0
ffffffffc0207474:	6f9c                	ld	a5,24(a5)
ffffffffc0207476:	9782                	jalr	a5
ffffffffc0207478:	441c                	lw	a5,8(s0)
ffffffffc020747a:	6098                	ld	a4,0(s1)
ffffffffc020747c:	2785                	addiw	a5,a5,1
ffffffffc020747e:	c41c                	sw	a5,8(s0)
ffffffffc0207480:	00870563          	beq	a4,s0,ffffffffc020748a <schedule+0x6e>
ffffffffc0207484:	8522                	mv	a0,s0
ffffffffc0207486:	efefe0ef          	jal	ra,ffffffffc0205b84 <proc_run>
ffffffffc020748a:	000a1a63          	bnez	s4,ffffffffc020749e <schedule+0x82>
ffffffffc020748e:	70a2                	ld	ra,40(sp)
ffffffffc0207490:	7402                	ld	s0,32(sp)
ffffffffc0207492:	64e2                	ld	s1,24(sp)
ffffffffc0207494:	6942                	ld	s2,16(sp)
ffffffffc0207496:	69a2                	ld	s3,8(sp)
ffffffffc0207498:	6a02                	ld	s4,0(sp)
ffffffffc020749a:	6145                	addi	sp,sp,48
ffffffffc020749c:	8082                	ret
ffffffffc020749e:	7402                	ld	s0,32(sp)
ffffffffc02074a0:	70a2                	ld	ra,40(sp)
ffffffffc02074a2:	64e2                	ld	s1,24(sp)
ffffffffc02074a4:	6942                	ld	s2,16(sp)
ffffffffc02074a6:	69a2                	ld	s3,8(sp)
ffffffffc02074a8:	6a02                	ld	s4,0(sp)
ffffffffc02074aa:	6145                	addi	sp,sp,48
ffffffffc02074ac:	fc0f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc02074b0:	0008f417          	auipc	s0,0x8f
ffffffffc02074b4:	41843403          	ld	s0,1048(s0) # ffffffffc02968c8 <idleproc>
ffffffffc02074b8:	b7c1                	j	ffffffffc0207478 <schedule+0x5c>
ffffffffc02074ba:	0008f717          	auipc	a4,0x8f
ffffffffc02074be:	40e73703          	ld	a4,1038(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02074c2:	fae580e3          	beq	a1,a4,ffffffffc0207462 <schedule+0x46>
ffffffffc02074c6:	6b9c                	ld	a5,16(a5)
ffffffffc02074c8:	9782                	jalr	a5
ffffffffc02074ca:	0009b783          	ld	a5,0(s3)
ffffffffc02074ce:	00093503          	ld	a0,0(s2)
ffffffffc02074d2:	bf41                	j	ffffffffc0207462 <schedule+0x46>
ffffffffc02074d4:	f9ef90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02074d8:	4a05                	li	s4,1
ffffffffc02074da:	bfa9                	j	ffffffffc0207434 <schedule+0x18>

ffffffffc02074dc <add_timer>:
ffffffffc02074dc:	1141                	addi	sp,sp,-16
ffffffffc02074de:	e022                	sd	s0,0(sp)
ffffffffc02074e0:	e406                	sd	ra,8(sp)
ffffffffc02074e2:	842a                	mv	s0,a0
ffffffffc02074e4:	100027f3          	csrr	a5,sstatus
ffffffffc02074e8:	8b89                	andi	a5,a5,2
ffffffffc02074ea:	4501                	li	a0,0
ffffffffc02074ec:	eba5                	bnez	a5,ffffffffc020755c <add_timer+0x80>
ffffffffc02074ee:	401c                	lw	a5,0(s0)
ffffffffc02074f0:	cbb5                	beqz	a5,ffffffffc0207564 <add_timer+0x88>
ffffffffc02074f2:	6418                	ld	a4,8(s0)
ffffffffc02074f4:	cb25                	beqz	a4,ffffffffc0207564 <add_timer+0x88>
ffffffffc02074f6:	6c18                	ld	a4,24(s0)
ffffffffc02074f8:	01040593          	addi	a1,s0,16
ffffffffc02074fc:	08e59463          	bne	a1,a4,ffffffffc0207584 <add_timer+0xa8>
ffffffffc0207500:	0008e617          	auipc	a2,0x8e
ffffffffc0207504:	2f060613          	addi	a2,a2,752 # ffffffffc02957f0 <timer_list>
ffffffffc0207508:	6618                	ld	a4,8(a2)
ffffffffc020750a:	00c71863          	bne	a4,a2,ffffffffc020751a <add_timer+0x3e>
ffffffffc020750e:	a80d                	j	ffffffffc0207540 <add_timer+0x64>
ffffffffc0207510:	6718                	ld	a4,8(a4)
ffffffffc0207512:	9f95                	subw	a5,a5,a3
ffffffffc0207514:	c01c                	sw	a5,0(s0)
ffffffffc0207516:	02c70563          	beq	a4,a2,ffffffffc0207540 <add_timer+0x64>
ffffffffc020751a:	ff072683          	lw	a3,-16(a4)
ffffffffc020751e:	fed7f9e3          	bgeu	a5,a3,ffffffffc0207510 <add_timer+0x34>
ffffffffc0207522:	40f687bb          	subw	a5,a3,a5
ffffffffc0207526:	fef72823          	sw	a5,-16(a4)
ffffffffc020752a:	631c                	ld	a5,0(a4)
ffffffffc020752c:	e30c                	sd	a1,0(a4)
ffffffffc020752e:	e78c                	sd	a1,8(a5)
ffffffffc0207530:	ec18                	sd	a4,24(s0)
ffffffffc0207532:	e81c                	sd	a5,16(s0)
ffffffffc0207534:	c105                	beqz	a0,ffffffffc0207554 <add_timer+0x78>
ffffffffc0207536:	6402                	ld	s0,0(sp)
ffffffffc0207538:	60a2                	ld	ra,8(sp)
ffffffffc020753a:	0141                	addi	sp,sp,16
ffffffffc020753c:	f30f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0207540:	0008e717          	auipc	a4,0x8e
ffffffffc0207544:	2b070713          	addi	a4,a4,688 # ffffffffc02957f0 <timer_list>
ffffffffc0207548:	631c                	ld	a5,0(a4)
ffffffffc020754a:	e30c                	sd	a1,0(a4)
ffffffffc020754c:	e78c                	sd	a1,8(a5)
ffffffffc020754e:	ec18                	sd	a4,24(s0)
ffffffffc0207550:	e81c                	sd	a5,16(s0)
ffffffffc0207552:	f175                	bnez	a0,ffffffffc0207536 <add_timer+0x5a>
ffffffffc0207554:	60a2                	ld	ra,8(sp)
ffffffffc0207556:	6402                	ld	s0,0(sp)
ffffffffc0207558:	0141                	addi	sp,sp,16
ffffffffc020755a:	8082                	ret
ffffffffc020755c:	f16f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207560:	4505                	li	a0,1
ffffffffc0207562:	b771                	j	ffffffffc02074ee <add_timer+0x12>
ffffffffc0207564:	00006697          	auipc	a3,0x6
ffffffffc0207568:	5b468693          	addi	a3,a3,1460 # ffffffffc020db18 <CSWTCH.79+0x688>
ffffffffc020756c:	00004617          	auipc	a2,0x4
ffffffffc0207570:	51460613          	addi	a2,a2,1300 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207574:	07a00593          	li	a1,122
ffffffffc0207578:	00006517          	auipc	a0,0x6
ffffffffc020757c:	56850513          	addi	a0,a0,1384 # ffffffffc020dae0 <CSWTCH.79+0x650>
ffffffffc0207580:	f1ff80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207584:	00006697          	auipc	a3,0x6
ffffffffc0207588:	5c468693          	addi	a3,a3,1476 # ffffffffc020db48 <CSWTCH.79+0x6b8>
ffffffffc020758c:	00004617          	auipc	a2,0x4
ffffffffc0207590:	4f460613          	addi	a2,a2,1268 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207594:	07b00593          	li	a1,123
ffffffffc0207598:	00006517          	auipc	a0,0x6
ffffffffc020759c:	54850513          	addi	a0,a0,1352 # ffffffffc020dae0 <CSWTCH.79+0x650>
ffffffffc02075a0:	efff80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02075a4 <del_timer>:
ffffffffc02075a4:	1101                	addi	sp,sp,-32
ffffffffc02075a6:	e822                	sd	s0,16(sp)
ffffffffc02075a8:	ec06                	sd	ra,24(sp)
ffffffffc02075aa:	e426                	sd	s1,8(sp)
ffffffffc02075ac:	842a                	mv	s0,a0
ffffffffc02075ae:	100027f3          	csrr	a5,sstatus
ffffffffc02075b2:	8b89                	andi	a5,a5,2
ffffffffc02075b4:	01050493          	addi	s1,a0,16
ffffffffc02075b8:	eb9d                	bnez	a5,ffffffffc02075ee <del_timer+0x4a>
ffffffffc02075ba:	6d1c                	ld	a5,24(a0)
ffffffffc02075bc:	02978463          	beq	a5,s1,ffffffffc02075e4 <del_timer+0x40>
ffffffffc02075c0:	4114                	lw	a3,0(a0)
ffffffffc02075c2:	6918                	ld	a4,16(a0)
ffffffffc02075c4:	ce81                	beqz	a3,ffffffffc02075dc <del_timer+0x38>
ffffffffc02075c6:	0008e617          	auipc	a2,0x8e
ffffffffc02075ca:	22a60613          	addi	a2,a2,554 # ffffffffc02957f0 <timer_list>
ffffffffc02075ce:	00c78763          	beq	a5,a2,ffffffffc02075dc <del_timer+0x38>
ffffffffc02075d2:	ff07a603          	lw	a2,-16(a5)
ffffffffc02075d6:	9eb1                	addw	a3,a3,a2
ffffffffc02075d8:	fed7a823          	sw	a3,-16(a5)
ffffffffc02075dc:	e71c                	sd	a5,8(a4)
ffffffffc02075de:	e398                	sd	a4,0(a5)
ffffffffc02075e0:	ec04                	sd	s1,24(s0)
ffffffffc02075e2:	e804                	sd	s1,16(s0)
ffffffffc02075e4:	60e2                	ld	ra,24(sp)
ffffffffc02075e6:	6442                	ld	s0,16(sp)
ffffffffc02075e8:	64a2                	ld	s1,8(sp)
ffffffffc02075ea:	6105                	addi	sp,sp,32
ffffffffc02075ec:	8082                	ret
ffffffffc02075ee:	e84f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc02075f2:	6c1c                	ld	a5,24(s0)
ffffffffc02075f4:	02978463          	beq	a5,s1,ffffffffc020761c <del_timer+0x78>
ffffffffc02075f8:	4014                	lw	a3,0(s0)
ffffffffc02075fa:	6818                	ld	a4,16(s0)
ffffffffc02075fc:	ce81                	beqz	a3,ffffffffc0207614 <del_timer+0x70>
ffffffffc02075fe:	0008e617          	auipc	a2,0x8e
ffffffffc0207602:	1f260613          	addi	a2,a2,498 # ffffffffc02957f0 <timer_list>
ffffffffc0207606:	00c78763          	beq	a5,a2,ffffffffc0207614 <del_timer+0x70>
ffffffffc020760a:	ff07a603          	lw	a2,-16(a5)
ffffffffc020760e:	9eb1                	addw	a3,a3,a2
ffffffffc0207610:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207614:	e71c                	sd	a5,8(a4)
ffffffffc0207616:	e398                	sd	a4,0(a5)
ffffffffc0207618:	ec04                	sd	s1,24(s0)
ffffffffc020761a:	e804                	sd	s1,16(s0)
ffffffffc020761c:	6442                	ld	s0,16(sp)
ffffffffc020761e:	60e2                	ld	ra,24(sp)
ffffffffc0207620:	64a2                	ld	s1,8(sp)
ffffffffc0207622:	6105                	addi	sp,sp,32
ffffffffc0207624:	e48f906f          	j	ffffffffc0200c6c <intr_enable>

ffffffffc0207628 <run_timer_list>:
ffffffffc0207628:	7139                	addi	sp,sp,-64
ffffffffc020762a:	fc06                	sd	ra,56(sp)
ffffffffc020762c:	f822                	sd	s0,48(sp)
ffffffffc020762e:	f426                	sd	s1,40(sp)
ffffffffc0207630:	f04a                	sd	s2,32(sp)
ffffffffc0207632:	ec4e                	sd	s3,24(sp)
ffffffffc0207634:	e852                	sd	s4,16(sp)
ffffffffc0207636:	e456                	sd	s5,8(sp)
ffffffffc0207638:	e05a                	sd	s6,0(sp)
ffffffffc020763a:	100027f3          	csrr	a5,sstatus
ffffffffc020763e:	8b89                	andi	a5,a5,2
ffffffffc0207640:	4b01                	li	s6,0
ffffffffc0207642:	efe9                	bnez	a5,ffffffffc020771c <run_timer_list+0xf4>
ffffffffc0207644:	0008e997          	auipc	s3,0x8e
ffffffffc0207648:	1ac98993          	addi	s3,s3,428 # ffffffffc02957f0 <timer_list>
ffffffffc020764c:	0089b403          	ld	s0,8(s3)
ffffffffc0207650:	07340a63          	beq	s0,s3,ffffffffc02076c4 <run_timer_list+0x9c>
ffffffffc0207654:	ff042783          	lw	a5,-16(s0)
ffffffffc0207658:	ff040913          	addi	s2,s0,-16
ffffffffc020765c:	0e078763          	beqz	a5,ffffffffc020774a <run_timer_list+0x122>
ffffffffc0207660:	fff7871b          	addiw	a4,a5,-1
ffffffffc0207664:	fee42823          	sw	a4,-16(s0)
ffffffffc0207668:	ef31                	bnez	a4,ffffffffc02076c4 <run_timer_list+0x9c>
ffffffffc020766a:	00006a97          	auipc	s5,0x6
ffffffffc020766e:	546a8a93          	addi	s5,s5,1350 # ffffffffc020dbb0 <CSWTCH.79+0x720>
ffffffffc0207672:	00006a17          	auipc	s4,0x6
ffffffffc0207676:	46ea0a13          	addi	s4,s4,1134 # ffffffffc020dae0 <CSWTCH.79+0x650>
ffffffffc020767a:	a005                	j	ffffffffc020769a <run_timer_list+0x72>
ffffffffc020767c:	0a07d763          	bgez	a5,ffffffffc020772a <run_timer_list+0x102>
ffffffffc0207680:	8526                	mv	a0,s1
ffffffffc0207682:	ce9ff0ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc0207686:	854a                	mv	a0,s2
ffffffffc0207688:	f1dff0ef          	jal	ra,ffffffffc02075a4 <del_timer>
ffffffffc020768c:	03340c63          	beq	s0,s3,ffffffffc02076c4 <run_timer_list+0x9c>
ffffffffc0207690:	ff042783          	lw	a5,-16(s0)
ffffffffc0207694:	ff040913          	addi	s2,s0,-16
ffffffffc0207698:	e795                	bnez	a5,ffffffffc02076c4 <run_timer_list+0x9c>
ffffffffc020769a:	00893483          	ld	s1,8(s2)
ffffffffc020769e:	6400                	ld	s0,8(s0)
ffffffffc02076a0:	0ec4a783          	lw	a5,236(s1)
ffffffffc02076a4:	ffe1                	bnez	a5,ffffffffc020767c <run_timer_list+0x54>
ffffffffc02076a6:	40d4                	lw	a3,4(s1)
ffffffffc02076a8:	8656                	mv	a2,s5
ffffffffc02076aa:	0ba00593          	li	a1,186
ffffffffc02076ae:	8552                	mv	a0,s4
ffffffffc02076b0:	e57f80ef          	jal	ra,ffffffffc0200506 <__warn>
ffffffffc02076b4:	8526                	mv	a0,s1
ffffffffc02076b6:	cb5ff0ef          	jal	ra,ffffffffc020736a <wakeup_proc>
ffffffffc02076ba:	854a                	mv	a0,s2
ffffffffc02076bc:	ee9ff0ef          	jal	ra,ffffffffc02075a4 <del_timer>
ffffffffc02076c0:	fd3418e3          	bne	s0,s3,ffffffffc0207690 <run_timer_list+0x68>
ffffffffc02076c4:	0008f597          	auipc	a1,0x8f
ffffffffc02076c8:	1fc5b583          	ld	a1,508(a1) # ffffffffc02968c0 <current>
ffffffffc02076cc:	c18d                	beqz	a1,ffffffffc02076ee <run_timer_list+0xc6>
ffffffffc02076ce:	0008f797          	auipc	a5,0x8f
ffffffffc02076d2:	1fa7b783          	ld	a5,506(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02076d6:	04f58763          	beq	a1,a5,ffffffffc0207724 <run_timer_list+0xfc>
ffffffffc02076da:	0008f797          	auipc	a5,0x8f
ffffffffc02076de:	20e7b783          	ld	a5,526(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02076e2:	779c                	ld	a5,40(a5)
ffffffffc02076e4:	0008f517          	auipc	a0,0x8f
ffffffffc02076e8:	1fc53503          	ld	a0,508(a0) # ffffffffc02968e0 <rq>
ffffffffc02076ec:	9782                	jalr	a5
ffffffffc02076ee:	000b1c63          	bnez	s6,ffffffffc0207706 <run_timer_list+0xde>
ffffffffc02076f2:	70e2                	ld	ra,56(sp)
ffffffffc02076f4:	7442                	ld	s0,48(sp)
ffffffffc02076f6:	74a2                	ld	s1,40(sp)
ffffffffc02076f8:	7902                	ld	s2,32(sp)
ffffffffc02076fa:	69e2                	ld	s3,24(sp)
ffffffffc02076fc:	6a42                	ld	s4,16(sp)
ffffffffc02076fe:	6aa2                	ld	s5,8(sp)
ffffffffc0207700:	6b02                	ld	s6,0(sp)
ffffffffc0207702:	6121                	addi	sp,sp,64
ffffffffc0207704:	8082                	ret
ffffffffc0207706:	7442                	ld	s0,48(sp)
ffffffffc0207708:	70e2                	ld	ra,56(sp)
ffffffffc020770a:	74a2                	ld	s1,40(sp)
ffffffffc020770c:	7902                	ld	s2,32(sp)
ffffffffc020770e:	69e2                	ld	s3,24(sp)
ffffffffc0207710:	6a42                	ld	s4,16(sp)
ffffffffc0207712:	6aa2                	ld	s5,8(sp)
ffffffffc0207714:	6b02                	ld	s6,0(sp)
ffffffffc0207716:	6121                	addi	sp,sp,64
ffffffffc0207718:	d54f906f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc020771c:	d56f90ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0207720:	4b05                	li	s6,1
ffffffffc0207722:	b70d                	j	ffffffffc0207644 <run_timer_list+0x1c>
ffffffffc0207724:	4785                	li	a5,1
ffffffffc0207726:	ed9c                	sd	a5,24(a1)
ffffffffc0207728:	b7d9                	j	ffffffffc02076ee <run_timer_list+0xc6>
ffffffffc020772a:	00006697          	auipc	a3,0x6
ffffffffc020772e:	45e68693          	addi	a3,a3,1118 # ffffffffc020db88 <CSWTCH.79+0x6f8>
ffffffffc0207732:	00004617          	auipc	a2,0x4
ffffffffc0207736:	34e60613          	addi	a2,a2,846 # ffffffffc020ba80 <commands+0x210>
ffffffffc020773a:	0b600593          	li	a1,182
ffffffffc020773e:	00006517          	auipc	a0,0x6
ffffffffc0207742:	3a250513          	addi	a0,a0,930 # ffffffffc020dae0 <CSWTCH.79+0x650>
ffffffffc0207746:	d59f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020774a:	00006697          	auipc	a3,0x6
ffffffffc020774e:	42668693          	addi	a3,a3,1062 # ffffffffc020db70 <CSWTCH.79+0x6e0>
ffffffffc0207752:	00004617          	auipc	a2,0x4
ffffffffc0207756:	32e60613          	addi	a2,a2,814 # ffffffffc020ba80 <commands+0x210>
ffffffffc020775a:	0ae00593          	li	a1,174
ffffffffc020775e:	00006517          	auipc	a0,0x6
ffffffffc0207762:	38250513          	addi	a0,a0,898 # ffffffffc020dae0 <CSWTCH.79+0x650>
ffffffffc0207766:	d39f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020776a <sys_getpid>:
ffffffffc020776a:	0008f797          	auipc	a5,0x8f
ffffffffc020776e:	1567b783          	ld	a5,342(a5) # ffffffffc02968c0 <current>
ffffffffc0207772:	43c8                	lw	a0,4(a5)
ffffffffc0207774:	8082                	ret

ffffffffc0207776 <sys_pgdir>:
ffffffffc0207776:	4501                	li	a0,0
ffffffffc0207778:	8082                	ret

ffffffffc020777a <sys_gettime>:
ffffffffc020777a:	0008f797          	auipc	a5,0x8f
ffffffffc020777e:	0f67b783          	ld	a5,246(a5) # ffffffffc0296870 <ticks>
ffffffffc0207782:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207786:	9d3d                	addw	a0,a0,a5
ffffffffc0207788:	0015151b          	slliw	a0,a0,0x1
ffffffffc020778c:	8082                	ret

ffffffffc020778e <sys_lab6_set_priority>:
ffffffffc020778e:	4108                	lw	a0,0(a0)
ffffffffc0207790:	1141                	addi	sp,sp,-16
ffffffffc0207792:	e406                	sd	ra,8(sp)
ffffffffc0207794:	975ff0ef          	jal	ra,ffffffffc0207108 <lab6_set_priority>
ffffffffc0207798:	60a2                	ld	ra,8(sp)
ffffffffc020779a:	4501                	li	a0,0
ffffffffc020779c:	0141                	addi	sp,sp,16
ffffffffc020779e:	8082                	ret

ffffffffc02077a0 <sys_dup>:
ffffffffc02077a0:	450c                	lw	a1,8(a0)
ffffffffc02077a2:	4108                	lw	a0,0(a0)
ffffffffc02077a4:	aa2fe06f          	j	ffffffffc0205a46 <sysfile_dup>

ffffffffc02077a8 <sys_getdirentry>:
ffffffffc02077a8:	650c                	ld	a1,8(a0)
ffffffffc02077aa:	4108                	lw	a0,0(a0)
ffffffffc02077ac:	9aafe06f          	j	ffffffffc0205956 <sysfile_getdirentry>

ffffffffc02077b0 <sys_getcwd>:
ffffffffc02077b0:	650c                	ld	a1,8(a0)
ffffffffc02077b2:	6108                	ld	a0,0(a0)
ffffffffc02077b4:	8fefe06f          	j	ffffffffc02058b2 <sysfile_getcwd>

ffffffffc02077b8 <sys_fsync>:
ffffffffc02077b8:	4108                	lw	a0,0(a0)
ffffffffc02077ba:	8f4fe06f          	j	ffffffffc02058ae <sysfile_fsync>

ffffffffc02077be <sys_fstat>:
ffffffffc02077be:	650c                	ld	a1,8(a0)
ffffffffc02077c0:	4108                	lw	a0,0(a0)
ffffffffc02077c2:	84cfe06f          	j	ffffffffc020580e <sysfile_fstat>

ffffffffc02077c6 <sys_seek>:
ffffffffc02077c6:	4910                	lw	a2,16(a0)
ffffffffc02077c8:	650c                	ld	a1,8(a0)
ffffffffc02077ca:	4108                	lw	a0,0(a0)
ffffffffc02077cc:	83efe06f          	j	ffffffffc020580a <sysfile_seek>

ffffffffc02077d0 <sys_write>:
ffffffffc02077d0:	6910                	ld	a2,16(a0)
ffffffffc02077d2:	650c                	ld	a1,8(a0)
ffffffffc02077d4:	4108                	lw	a0,0(a0)
ffffffffc02077d6:	f1bfd06f          	j	ffffffffc02056f0 <sysfile_write>

ffffffffc02077da <sys_read>:
ffffffffc02077da:	6910                	ld	a2,16(a0)
ffffffffc02077dc:	650c                	ld	a1,8(a0)
ffffffffc02077de:	4108                	lw	a0,0(a0)
ffffffffc02077e0:	dfdfd06f          	j	ffffffffc02055dc <sysfile_read>

ffffffffc02077e4 <sys_close>:
ffffffffc02077e4:	4108                	lw	a0,0(a0)
ffffffffc02077e6:	df3fd06f          	j	ffffffffc02055d8 <sysfile_close>

ffffffffc02077ea <sys_open>:
ffffffffc02077ea:	450c                	lw	a1,8(a0)
ffffffffc02077ec:	6108                	ld	a0,0(a0)
ffffffffc02077ee:	db7fd06f          	j	ffffffffc02055a4 <sysfile_open>

ffffffffc02077f2 <sys_putc>:
ffffffffc02077f2:	4108                	lw	a0,0(a0)
ffffffffc02077f4:	1141                	addi	sp,sp,-16
ffffffffc02077f6:	e406                	sd	ra,8(sp)
ffffffffc02077f8:	9ebf80ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc02077fc:	60a2                	ld	ra,8(sp)
ffffffffc02077fe:	4501                	li	a0,0
ffffffffc0207800:	0141                	addi	sp,sp,16
ffffffffc0207802:	8082                	ret

ffffffffc0207804 <sys_kill>:
ffffffffc0207804:	4108                	lw	a0,0(a0)
ffffffffc0207806:	ea0ff06f          	j	ffffffffc0206ea6 <do_kill>

ffffffffc020780a <sys_sleep>:
ffffffffc020780a:	4108                	lw	a0,0(a0)
ffffffffc020780c:	937ff06f          	j	ffffffffc0207142 <do_sleep>

ffffffffc0207810 <sys_yield>:
ffffffffc0207810:	e48ff06f          	j	ffffffffc0206e58 <do_yield>

ffffffffc0207814 <sys_exec>:
ffffffffc0207814:	6910                	ld	a2,16(a0)
ffffffffc0207816:	450c                	lw	a1,8(a0)
ffffffffc0207818:	6108                	ld	a0,0(a0)
ffffffffc020781a:	cc9fe06f          	j	ffffffffc02064e2 <do_execve>

ffffffffc020781e <sys_wait>:
ffffffffc020781e:	650c                	ld	a1,8(a0)
ffffffffc0207820:	4108                	lw	a0,0(a0)
ffffffffc0207822:	e46ff06f          	j	ffffffffc0206e68 <do_wait>

ffffffffc0207826 <sys_fork>:
ffffffffc0207826:	0008f797          	auipc	a5,0x8f
ffffffffc020782a:	09a7b783          	ld	a5,154(a5) # ffffffffc02968c0 <current>
ffffffffc020782e:	73d0                	ld	a2,160(a5)
ffffffffc0207830:	4501                	li	a0,0
ffffffffc0207832:	6a0c                	ld	a1,16(a2)
ffffffffc0207834:	bc0fe06f          	j	ffffffffc0205bf4 <do_fork>

ffffffffc0207838 <sys_exit>:
ffffffffc0207838:	4108                	lw	a0,0(a0)
ffffffffc020783a:	825fe06f          	j	ffffffffc020605e <do_exit>

ffffffffc020783e <syscall>:
ffffffffc020783e:	715d                	addi	sp,sp,-80
ffffffffc0207840:	fc26                	sd	s1,56(sp)
ffffffffc0207842:	0008f497          	auipc	s1,0x8f
ffffffffc0207846:	07e48493          	addi	s1,s1,126 # ffffffffc02968c0 <current>
ffffffffc020784a:	6098                	ld	a4,0(s1)
ffffffffc020784c:	e0a2                	sd	s0,64(sp)
ffffffffc020784e:	f84a                	sd	s2,48(sp)
ffffffffc0207850:	7340                	ld	s0,160(a4)
ffffffffc0207852:	e486                	sd	ra,72(sp)
ffffffffc0207854:	0ff00793          	li	a5,255
ffffffffc0207858:	05042903          	lw	s2,80(s0)
ffffffffc020785c:	0327ee63          	bltu	a5,s2,ffffffffc0207898 <syscall+0x5a>
ffffffffc0207860:	00391713          	slli	a4,s2,0x3
ffffffffc0207864:	00006797          	auipc	a5,0x6
ffffffffc0207868:	3b478793          	addi	a5,a5,948 # ffffffffc020dc18 <syscalls>
ffffffffc020786c:	97ba                	add	a5,a5,a4
ffffffffc020786e:	639c                	ld	a5,0(a5)
ffffffffc0207870:	c785                	beqz	a5,ffffffffc0207898 <syscall+0x5a>
ffffffffc0207872:	6c28                	ld	a0,88(s0)
ffffffffc0207874:	702c                	ld	a1,96(s0)
ffffffffc0207876:	7430                	ld	a2,104(s0)
ffffffffc0207878:	7834                	ld	a3,112(s0)
ffffffffc020787a:	7c38                	ld	a4,120(s0)
ffffffffc020787c:	e42a                	sd	a0,8(sp)
ffffffffc020787e:	e82e                	sd	a1,16(sp)
ffffffffc0207880:	ec32                	sd	a2,24(sp)
ffffffffc0207882:	f036                	sd	a3,32(sp)
ffffffffc0207884:	f43a                	sd	a4,40(sp)
ffffffffc0207886:	0028                	addi	a0,sp,8
ffffffffc0207888:	9782                	jalr	a5
ffffffffc020788a:	60a6                	ld	ra,72(sp)
ffffffffc020788c:	e828                	sd	a0,80(s0)
ffffffffc020788e:	6406                	ld	s0,64(sp)
ffffffffc0207890:	74e2                	ld	s1,56(sp)
ffffffffc0207892:	7942                	ld	s2,48(sp)
ffffffffc0207894:	6161                	addi	sp,sp,80
ffffffffc0207896:	8082                	ret
ffffffffc0207898:	8522                	mv	a0,s0
ffffffffc020789a:	ef0f90ef          	jal	ra,ffffffffc0200f8a <print_trapframe>
ffffffffc020789e:	609c                	ld	a5,0(s1)
ffffffffc02078a0:	86ca                	mv	a3,s2
ffffffffc02078a2:	00006617          	auipc	a2,0x6
ffffffffc02078a6:	32e60613          	addi	a2,a2,814 # ffffffffc020dbd0 <CSWTCH.79+0x740>
ffffffffc02078aa:	43d8                	lw	a4,4(a5)
ffffffffc02078ac:	0d800593          	li	a1,216
ffffffffc02078b0:	0b478793          	addi	a5,a5,180
ffffffffc02078b4:	00006517          	auipc	a0,0x6
ffffffffc02078b8:	34c50513          	addi	a0,a0,844 # ffffffffc020dc00 <CSWTCH.79+0x770>
ffffffffc02078bc:	be3f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02078c0 <__alloc_inode>:
ffffffffc02078c0:	1141                	addi	sp,sp,-16
ffffffffc02078c2:	e022                	sd	s0,0(sp)
ffffffffc02078c4:	842a                	mv	s0,a0
ffffffffc02078c6:	07800513          	li	a0,120
ffffffffc02078ca:	e406                	sd	ra,8(sp)
ffffffffc02078cc:	ec2fa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc02078d0:	c111                	beqz	a0,ffffffffc02078d4 <__alloc_inode+0x14>
ffffffffc02078d2:	cd20                	sw	s0,88(a0)
ffffffffc02078d4:	60a2                	ld	ra,8(sp)
ffffffffc02078d6:	6402                	ld	s0,0(sp)
ffffffffc02078d8:	0141                	addi	sp,sp,16
ffffffffc02078da:	8082                	ret

ffffffffc02078dc <inode_init>:
ffffffffc02078dc:	4785                	li	a5,1
ffffffffc02078de:	06052023          	sw	zero,96(a0)
ffffffffc02078e2:	f92c                	sd	a1,112(a0)
ffffffffc02078e4:	f530                	sd	a2,104(a0)
ffffffffc02078e6:	cd7c                	sw	a5,92(a0)
ffffffffc02078e8:	8082                	ret

ffffffffc02078ea <inode_kill>:
ffffffffc02078ea:	4d78                	lw	a4,92(a0)
ffffffffc02078ec:	1141                	addi	sp,sp,-16
ffffffffc02078ee:	e406                	sd	ra,8(sp)
ffffffffc02078f0:	e719                	bnez	a4,ffffffffc02078fe <inode_kill+0x14>
ffffffffc02078f2:	513c                	lw	a5,96(a0)
ffffffffc02078f4:	e78d                	bnez	a5,ffffffffc020791e <inode_kill+0x34>
ffffffffc02078f6:	60a2                	ld	ra,8(sp)
ffffffffc02078f8:	0141                	addi	sp,sp,16
ffffffffc02078fa:	f44fa06f          	j	ffffffffc020203e <kfree>
ffffffffc02078fe:	00007697          	auipc	a3,0x7
ffffffffc0207902:	b1a68693          	addi	a3,a3,-1254 # ffffffffc020e418 <syscalls+0x800>
ffffffffc0207906:	00004617          	auipc	a2,0x4
ffffffffc020790a:	17a60613          	addi	a2,a2,378 # ffffffffc020ba80 <commands+0x210>
ffffffffc020790e:	02900593          	li	a1,41
ffffffffc0207912:	00007517          	auipc	a0,0x7
ffffffffc0207916:	b2650513          	addi	a0,a0,-1242 # ffffffffc020e438 <syscalls+0x820>
ffffffffc020791a:	b85f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020791e:	00007697          	auipc	a3,0x7
ffffffffc0207922:	b3268693          	addi	a3,a3,-1230 # ffffffffc020e450 <syscalls+0x838>
ffffffffc0207926:	00004617          	auipc	a2,0x4
ffffffffc020792a:	15a60613          	addi	a2,a2,346 # ffffffffc020ba80 <commands+0x210>
ffffffffc020792e:	02a00593          	li	a1,42
ffffffffc0207932:	00007517          	auipc	a0,0x7
ffffffffc0207936:	b0650513          	addi	a0,a0,-1274 # ffffffffc020e438 <syscalls+0x820>
ffffffffc020793a:	b65f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020793e <inode_ref_inc>:
ffffffffc020793e:	4d7c                	lw	a5,92(a0)
ffffffffc0207940:	2785                	addiw	a5,a5,1
ffffffffc0207942:	cd7c                	sw	a5,92(a0)
ffffffffc0207944:	0007851b          	sext.w	a0,a5
ffffffffc0207948:	8082                	ret

ffffffffc020794a <inode_open_inc>:
ffffffffc020794a:	513c                	lw	a5,96(a0)
ffffffffc020794c:	2785                	addiw	a5,a5,1
ffffffffc020794e:	d13c                	sw	a5,96(a0)
ffffffffc0207950:	0007851b          	sext.w	a0,a5
ffffffffc0207954:	8082                	ret

ffffffffc0207956 <inode_check>:
ffffffffc0207956:	1141                	addi	sp,sp,-16
ffffffffc0207958:	e406                	sd	ra,8(sp)
ffffffffc020795a:	c90d                	beqz	a0,ffffffffc020798c <inode_check+0x36>
ffffffffc020795c:	793c                	ld	a5,112(a0)
ffffffffc020795e:	c79d                	beqz	a5,ffffffffc020798c <inode_check+0x36>
ffffffffc0207960:	6398                	ld	a4,0(a5)
ffffffffc0207962:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207966:	0786                	slli	a5,a5,0x1
ffffffffc0207968:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc020796c:	08f71063          	bne	a4,a5,ffffffffc02079ec <inode_check+0x96>
ffffffffc0207970:	4d78                	lw	a4,92(a0)
ffffffffc0207972:	513c                	lw	a5,96(a0)
ffffffffc0207974:	04f74c63          	blt	a4,a5,ffffffffc02079cc <inode_check+0x76>
ffffffffc0207978:	0407ca63          	bltz	a5,ffffffffc02079cc <inode_check+0x76>
ffffffffc020797c:	66c1                	lui	a3,0x10
ffffffffc020797e:	02d75763          	bge	a4,a3,ffffffffc02079ac <inode_check+0x56>
ffffffffc0207982:	02d7d563          	bge	a5,a3,ffffffffc02079ac <inode_check+0x56>
ffffffffc0207986:	60a2                	ld	ra,8(sp)
ffffffffc0207988:	0141                	addi	sp,sp,16
ffffffffc020798a:	8082                	ret
ffffffffc020798c:	00007697          	auipc	a3,0x7
ffffffffc0207990:	ae468693          	addi	a3,a3,-1308 # ffffffffc020e470 <syscalls+0x858>
ffffffffc0207994:	00004617          	auipc	a2,0x4
ffffffffc0207998:	0ec60613          	addi	a2,a2,236 # ffffffffc020ba80 <commands+0x210>
ffffffffc020799c:	06e00593          	li	a1,110
ffffffffc02079a0:	00007517          	auipc	a0,0x7
ffffffffc02079a4:	a9850513          	addi	a0,a0,-1384 # ffffffffc020e438 <syscalls+0x820>
ffffffffc02079a8:	af7f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02079ac:	00007697          	auipc	a3,0x7
ffffffffc02079b0:	b4468693          	addi	a3,a3,-1212 # ffffffffc020e4f0 <syscalls+0x8d8>
ffffffffc02079b4:	00004617          	auipc	a2,0x4
ffffffffc02079b8:	0cc60613          	addi	a2,a2,204 # ffffffffc020ba80 <commands+0x210>
ffffffffc02079bc:	07200593          	li	a1,114
ffffffffc02079c0:	00007517          	auipc	a0,0x7
ffffffffc02079c4:	a7850513          	addi	a0,a0,-1416 # ffffffffc020e438 <syscalls+0x820>
ffffffffc02079c8:	ad7f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02079cc:	00007697          	auipc	a3,0x7
ffffffffc02079d0:	af468693          	addi	a3,a3,-1292 # ffffffffc020e4c0 <syscalls+0x8a8>
ffffffffc02079d4:	00004617          	auipc	a2,0x4
ffffffffc02079d8:	0ac60613          	addi	a2,a2,172 # ffffffffc020ba80 <commands+0x210>
ffffffffc02079dc:	07100593          	li	a1,113
ffffffffc02079e0:	00007517          	auipc	a0,0x7
ffffffffc02079e4:	a5850513          	addi	a0,a0,-1448 # ffffffffc020e438 <syscalls+0x820>
ffffffffc02079e8:	ab7f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02079ec:	00007697          	auipc	a3,0x7
ffffffffc02079f0:	aac68693          	addi	a3,a3,-1364 # ffffffffc020e498 <syscalls+0x880>
ffffffffc02079f4:	00004617          	auipc	a2,0x4
ffffffffc02079f8:	08c60613          	addi	a2,a2,140 # ffffffffc020ba80 <commands+0x210>
ffffffffc02079fc:	06f00593          	li	a1,111
ffffffffc0207a00:	00007517          	auipc	a0,0x7
ffffffffc0207a04:	a3850513          	addi	a0,a0,-1480 # ffffffffc020e438 <syscalls+0x820>
ffffffffc0207a08:	a97f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207a0c <inode_ref_dec>:
ffffffffc0207a0c:	4d7c                	lw	a5,92(a0)
ffffffffc0207a0e:	1101                	addi	sp,sp,-32
ffffffffc0207a10:	ec06                	sd	ra,24(sp)
ffffffffc0207a12:	e822                	sd	s0,16(sp)
ffffffffc0207a14:	e426                	sd	s1,8(sp)
ffffffffc0207a16:	e04a                	sd	s2,0(sp)
ffffffffc0207a18:	06f05e63          	blez	a5,ffffffffc0207a94 <inode_ref_dec+0x88>
ffffffffc0207a1c:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207a20:	cd64                	sw	s1,92(a0)
ffffffffc0207a22:	842a                	mv	s0,a0
ffffffffc0207a24:	e09d                	bnez	s1,ffffffffc0207a4a <inode_ref_dec+0x3e>
ffffffffc0207a26:	793c                	ld	a5,112(a0)
ffffffffc0207a28:	c7b1                	beqz	a5,ffffffffc0207a74 <inode_ref_dec+0x68>
ffffffffc0207a2a:	0487b903          	ld	s2,72(a5)
ffffffffc0207a2e:	04090363          	beqz	s2,ffffffffc0207a74 <inode_ref_dec+0x68>
ffffffffc0207a32:	00007597          	auipc	a1,0x7
ffffffffc0207a36:	b6e58593          	addi	a1,a1,-1170 # ffffffffc020e5a0 <syscalls+0x988>
ffffffffc0207a3a:	f1dff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0207a3e:	8522                	mv	a0,s0
ffffffffc0207a40:	9902                	jalr	s2
ffffffffc0207a42:	c501                	beqz	a0,ffffffffc0207a4a <inode_ref_dec+0x3e>
ffffffffc0207a44:	57c5                	li	a5,-15
ffffffffc0207a46:	00f51963          	bne	a0,a5,ffffffffc0207a58 <inode_ref_dec+0x4c>
ffffffffc0207a4a:	60e2                	ld	ra,24(sp)
ffffffffc0207a4c:	6442                	ld	s0,16(sp)
ffffffffc0207a4e:	6902                	ld	s2,0(sp)
ffffffffc0207a50:	8526                	mv	a0,s1
ffffffffc0207a52:	64a2                	ld	s1,8(sp)
ffffffffc0207a54:	6105                	addi	sp,sp,32
ffffffffc0207a56:	8082                	ret
ffffffffc0207a58:	85aa                	mv	a1,a0
ffffffffc0207a5a:	00007517          	auipc	a0,0x7
ffffffffc0207a5e:	b4e50513          	addi	a0,a0,-1202 # ffffffffc020e5a8 <syscalls+0x990>
ffffffffc0207a62:	f44f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207a66:	60e2                	ld	ra,24(sp)
ffffffffc0207a68:	6442                	ld	s0,16(sp)
ffffffffc0207a6a:	6902                	ld	s2,0(sp)
ffffffffc0207a6c:	8526                	mv	a0,s1
ffffffffc0207a6e:	64a2                	ld	s1,8(sp)
ffffffffc0207a70:	6105                	addi	sp,sp,32
ffffffffc0207a72:	8082                	ret
ffffffffc0207a74:	00007697          	auipc	a3,0x7
ffffffffc0207a78:	adc68693          	addi	a3,a3,-1316 # ffffffffc020e550 <syscalls+0x938>
ffffffffc0207a7c:	00004617          	auipc	a2,0x4
ffffffffc0207a80:	00460613          	addi	a2,a2,4 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207a84:	04400593          	li	a1,68
ffffffffc0207a88:	00007517          	auipc	a0,0x7
ffffffffc0207a8c:	9b050513          	addi	a0,a0,-1616 # ffffffffc020e438 <syscalls+0x820>
ffffffffc0207a90:	a0ff80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207a94:	00007697          	auipc	a3,0x7
ffffffffc0207a98:	a9c68693          	addi	a3,a3,-1380 # ffffffffc020e530 <syscalls+0x918>
ffffffffc0207a9c:	00004617          	auipc	a2,0x4
ffffffffc0207aa0:	fe460613          	addi	a2,a2,-28 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207aa4:	03f00593          	li	a1,63
ffffffffc0207aa8:	00007517          	auipc	a0,0x7
ffffffffc0207aac:	99050513          	addi	a0,a0,-1648 # ffffffffc020e438 <syscalls+0x820>
ffffffffc0207ab0:	9eff80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207ab4 <inode_open_dec>:
ffffffffc0207ab4:	513c                	lw	a5,96(a0)
ffffffffc0207ab6:	1101                	addi	sp,sp,-32
ffffffffc0207ab8:	ec06                	sd	ra,24(sp)
ffffffffc0207aba:	e822                	sd	s0,16(sp)
ffffffffc0207abc:	e426                	sd	s1,8(sp)
ffffffffc0207abe:	e04a                	sd	s2,0(sp)
ffffffffc0207ac0:	06f05b63          	blez	a5,ffffffffc0207b36 <inode_open_dec+0x82>
ffffffffc0207ac4:	fff7849b          	addiw	s1,a5,-1
ffffffffc0207ac8:	d124                	sw	s1,96(a0)
ffffffffc0207aca:	842a                	mv	s0,a0
ffffffffc0207acc:	e085                	bnez	s1,ffffffffc0207aec <inode_open_dec+0x38>
ffffffffc0207ace:	793c                	ld	a5,112(a0)
ffffffffc0207ad0:	c3b9                	beqz	a5,ffffffffc0207b16 <inode_open_dec+0x62>
ffffffffc0207ad2:	0107b903          	ld	s2,16(a5)
ffffffffc0207ad6:	04090063          	beqz	s2,ffffffffc0207b16 <inode_open_dec+0x62>
ffffffffc0207ada:	00007597          	auipc	a1,0x7
ffffffffc0207ade:	b5e58593          	addi	a1,a1,-1186 # ffffffffc020e638 <syscalls+0xa20>
ffffffffc0207ae2:	e75ff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0207ae6:	8522                	mv	a0,s0
ffffffffc0207ae8:	9902                	jalr	s2
ffffffffc0207aea:	e901                	bnez	a0,ffffffffc0207afa <inode_open_dec+0x46>
ffffffffc0207aec:	60e2                	ld	ra,24(sp)
ffffffffc0207aee:	6442                	ld	s0,16(sp)
ffffffffc0207af0:	6902                	ld	s2,0(sp)
ffffffffc0207af2:	8526                	mv	a0,s1
ffffffffc0207af4:	64a2                	ld	s1,8(sp)
ffffffffc0207af6:	6105                	addi	sp,sp,32
ffffffffc0207af8:	8082                	ret
ffffffffc0207afa:	85aa                	mv	a1,a0
ffffffffc0207afc:	00007517          	auipc	a0,0x7
ffffffffc0207b00:	b4450513          	addi	a0,a0,-1212 # ffffffffc020e640 <syscalls+0xa28>
ffffffffc0207b04:	ea2f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207b08:	60e2                	ld	ra,24(sp)
ffffffffc0207b0a:	6442                	ld	s0,16(sp)
ffffffffc0207b0c:	6902                	ld	s2,0(sp)
ffffffffc0207b0e:	8526                	mv	a0,s1
ffffffffc0207b10:	64a2                	ld	s1,8(sp)
ffffffffc0207b12:	6105                	addi	sp,sp,32
ffffffffc0207b14:	8082                	ret
ffffffffc0207b16:	00007697          	auipc	a3,0x7
ffffffffc0207b1a:	ad268693          	addi	a3,a3,-1326 # ffffffffc020e5e8 <syscalls+0x9d0>
ffffffffc0207b1e:	00004617          	auipc	a2,0x4
ffffffffc0207b22:	f6260613          	addi	a2,a2,-158 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207b26:	06100593          	li	a1,97
ffffffffc0207b2a:	00007517          	auipc	a0,0x7
ffffffffc0207b2e:	90e50513          	addi	a0,a0,-1778 # ffffffffc020e438 <syscalls+0x820>
ffffffffc0207b32:	96df80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207b36:	00007697          	auipc	a3,0x7
ffffffffc0207b3a:	a9268693          	addi	a3,a3,-1390 # ffffffffc020e5c8 <syscalls+0x9b0>
ffffffffc0207b3e:	00004617          	auipc	a2,0x4
ffffffffc0207b42:	f4260613          	addi	a2,a2,-190 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207b46:	05c00593          	li	a1,92
ffffffffc0207b4a:	00007517          	auipc	a0,0x7
ffffffffc0207b4e:	8ee50513          	addi	a0,a0,-1810 # ffffffffc020e438 <syscalls+0x820>
ffffffffc0207b52:	94df80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207b56 <__alloc_fs>:
ffffffffc0207b56:	1141                	addi	sp,sp,-16
ffffffffc0207b58:	e022                	sd	s0,0(sp)
ffffffffc0207b5a:	842a                	mv	s0,a0
ffffffffc0207b5c:	0d800513          	li	a0,216
ffffffffc0207b60:	e406                	sd	ra,8(sp)
ffffffffc0207b62:	c2cfa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0207b66:	c119                	beqz	a0,ffffffffc0207b6c <__alloc_fs+0x16>
ffffffffc0207b68:	0a852823          	sw	s0,176(a0)
ffffffffc0207b6c:	60a2                	ld	ra,8(sp)
ffffffffc0207b6e:	6402                	ld	s0,0(sp)
ffffffffc0207b70:	0141                	addi	sp,sp,16
ffffffffc0207b72:	8082                	ret

ffffffffc0207b74 <vfs_init>:
ffffffffc0207b74:	1141                	addi	sp,sp,-16
ffffffffc0207b76:	4585                	li	a1,1
ffffffffc0207b78:	0008e517          	auipc	a0,0x8e
ffffffffc0207b7c:	c8850513          	addi	a0,a0,-888 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207b80:	e406                	sd	ra,8(sp)
ffffffffc0207b82:	a57fc0ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc0207b86:	60a2                	ld	ra,8(sp)
ffffffffc0207b88:	0141                	addi	sp,sp,16
ffffffffc0207b8a:	a40d                	j	ffffffffc0207dac <vfs_devlist_init>

ffffffffc0207b8c <vfs_set_bootfs>:
ffffffffc0207b8c:	7179                	addi	sp,sp,-48
ffffffffc0207b8e:	f022                	sd	s0,32(sp)
ffffffffc0207b90:	f406                	sd	ra,40(sp)
ffffffffc0207b92:	ec26                	sd	s1,24(sp)
ffffffffc0207b94:	e402                	sd	zero,8(sp)
ffffffffc0207b96:	842a                	mv	s0,a0
ffffffffc0207b98:	c915                	beqz	a0,ffffffffc0207bcc <vfs_set_bootfs+0x40>
ffffffffc0207b9a:	03a00593          	li	a1,58
ffffffffc0207b9e:	1e7030ef          	jal	ra,ffffffffc020b584 <strchr>
ffffffffc0207ba2:	c135                	beqz	a0,ffffffffc0207c06 <vfs_set_bootfs+0x7a>
ffffffffc0207ba4:	00154783          	lbu	a5,1(a0)
ffffffffc0207ba8:	efb9                	bnez	a5,ffffffffc0207c06 <vfs_set_bootfs+0x7a>
ffffffffc0207baa:	8522                	mv	a0,s0
ffffffffc0207bac:	11f000ef          	jal	ra,ffffffffc02084ca <vfs_chdir>
ffffffffc0207bb0:	842a                	mv	s0,a0
ffffffffc0207bb2:	c519                	beqz	a0,ffffffffc0207bc0 <vfs_set_bootfs+0x34>
ffffffffc0207bb4:	70a2                	ld	ra,40(sp)
ffffffffc0207bb6:	8522                	mv	a0,s0
ffffffffc0207bb8:	7402                	ld	s0,32(sp)
ffffffffc0207bba:	64e2                	ld	s1,24(sp)
ffffffffc0207bbc:	6145                	addi	sp,sp,48
ffffffffc0207bbe:	8082                	ret
ffffffffc0207bc0:	0028                	addi	a0,sp,8
ffffffffc0207bc2:	013000ef          	jal	ra,ffffffffc02083d4 <vfs_get_curdir>
ffffffffc0207bc6:	842a                	mv	s0,a0
ffffffffc0207bc8:	f575                	bnez	a0,ffffffffc0207bb4 <vfs_set_bootfs+0x28>
ffffffffc0207bca:	6422                	ld	s0,8(sp)
ffffffffc0207bcc:	0008e517          	auipc	a0,0x8e
ffffffffc0207bd0:	c3450513          	addi	a0,a0,-972 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207bd4:	a0ffc0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0207bd8:	0008f797          	auipc	a5,0x8f
ffffffffc0207bdc:	d1878793          	addi	a5,a5,-744 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207be0:	6384                	ld	s1,0(a5)
ffffffffc0207be2:	0008e517          	auipc	a0,0x8e
ffffffffc0207be6:	c1e50513          	addi	a0,a0,-994 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207bea:	e380                	sd	s0,0(a5)
ffffffffc0207bec:	4401                	li	s0,0
ffffffffc0207bee:	9f1fc0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0207bf2:	d0e9                	beqz	s1,ffffffffc0207bb4 <vfs_set_bootfs+0x28>
ffffffffc0207bf4:	8526                	mv	a0,s1
ffffffffc0207bf6:	e17ff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc0207bfa:	70a2                	ld	ra,40(sp)
ffffffffc0207bfc:	8522                	mv	a0,s0
ffffffffc0207bfe:	7402                	ld	s0,32(sp)
ffffffffc0207c00:	64e2                	ld	s1,24(sp)
ffffffffc0207c02:	6145                	addi	sp,sp,48
ffffffffc0207c04:	8082                	ret
ffffffffc0207c06:	5475                	li	s0,-3
ffffffffc0207c08:	b775                	j	ffffffffc0207bb4 <vfs_set_bootfs+0x28>

ffffffffc0207c0a <vfs_get_bootfs>:
ffffffffc0207c0a:	1101                	addi	sp,sp,-32
ffffffffc0207c0c:	e426                	sd	s1,8(sp)
ffffffffc0207c0e:	0008f497          	auipc	s1,0x8f
ffffffffc0207c12:	ce248493          	addi	s1,s1,-798 # ffffffffc02968f0 <bootfs_node>
ffffffffc0207c16:	609c                	ld	a5,0(s1)
ffffffffc0207c18:	ec06                	sd	ra,24(sp)
ffffffffc0207c1a:	e822                	sd	s0,16(sp)
ffffffffc0207c1c:	c3a1                	beqz	a5,ffffffffc0207c5c <vfs_get_bootfs+0x52>
ffffffffc0207c1e:	842a                	mv	s0,a0
ffffffffc0207c20:	0008e517          	auipc	a0,0x8e
ffffffffc0207c24:	be050513          	addi	a0,a0,-1056 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207c28:	9bbfc0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0207c2c:	6084                	ld	s1,0(s1)
ffffffffc0207c2e:	c08d                	beqz	s1,ffffffffc0207c50 <vfs_get_bootfs+0x46>
ffffffffc0207c30:	8526                	mv	a0,s1
ffffffffc0207c32:	d0dff0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc0207c36:	0008e517          	auipc	a0,0x8e
ffffffffc0207c3a:	bca50513          	addi	a0,a0,-1078 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207c3e:	9a1fc0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0207c42:	4501                	li	a0,0
ffffffffc0207c44:	e004                	sd	s1,0(s0)
ffffffffc0207c46:	60e2                	ld	ra,24(sp)
ffffffffc0207c48:	6442                	ld	s0,16(sp)
ffffffffc0207c4a:	64a2                	ld	s1,8(sp)
ffffffffc0207c4c:	6105                	addi	sp,sp,32
ffffffffc0207c4e:	8082                	ret
ffffffffc0207c50:	0008e517          	auipc	a0,0x8e
ffffffffc0207c54:	bb050513          	addi	a0,a0,-1104 # ffffffffc0295800 <bootfs_sem>
ffffffffc0207c58:	987fc0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0207c5c:	5541                	li	a0,-16
ffffffffc0207c5e:	b7e5                	j	ffffffffc0207c46 <vfs_get_bootfs+0x3c>

ffffffffc0207c60 <vfs_do_add>:
ffffffffc0207c60:	7139                	addi	sp,sp,-64
ffffffffc0207c62:	fc06                	sd	ra,56(sp)
ffffffffc0207c64:	f822                	sd	s0,48(sp)
ffffffffc0207c66:	f426                	sd	s1,40(sp)
ffffffffc0207c68:	f04a                	sd	s2,32(sp)
ffffffffc0207c6a:	ec4e                	sd	s3,24(sp)
ffffffffc0207c6c:	e852                	sd	s4,16(sp)
ffffffffc0207c6e:	e456                	sd	s5,8(sp)
ffffffffc0207c70:	e05a                	sd	s6,0(sp)
ffffffffc0207c72:	0e050b63          	beqz	a0,ffffffffc0207d68 <vfs_do_add+0x108>
ffffffffc0207c76:	842a                	mv	s0,a0
ffffffffc0207c78:	8a2e                	mv	s4,a1
ffffffffc0207c7a:	8b32                	mv	s6,a2
ffffffffc0207c7c:	8ab6                	mv	s5,a3
ffffffffc0207c7e:	c5cd                	beqz	a1,ffffffffc0207d28 <vfs_do_add+0xc8>
ffffffffc0207c80:	4db8                	lw	a4,88(a1)
ffffffffc0207c82:	6785                	lui	a5,0x1
ffffffffc0207c84:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207c88:	0af71163          	bne	a4,a5,ffffffffc0207d2a <vfs_do_add+0xca>
ffffffffc0207c8c:	8522                	mv	a0,s0
ffffffffc0207c8e:	06b030ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc0207c92:	47fd                	li	a5,31
ffffffffc0207c94:	0ca7e663          	bltu	a5,a0,ffffffffc0207d60 <vfs_do_add+0x100>
ffffffffc0207c98:	8522                	mv	a0,s0
ffffffffc0207c9a:	d5af80ef          	jal	ra,ffffffffc02001f4 <strdup>
ffffffffc0207c9e:	84aa                	mv	s1,a0
ffffffffc0207ca0:	c171                	beqz	a0,ffffffffc0207d64 <vfs_do_add+0x104>
ffffffffc0207ca2:	03000513          	li	a0,48
ffffffffc0207ca6:	ae8fa0ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0207caa:	89aa                	mv	s3,a0
ffffffffc0207cac:	c92d                	beqz	a0,ffffffffc0207d1e <vfs_do_add+0xbe>
ffffffffc0207cae:	0008e517          	auipc	a0,0x8e
ffffffffc0207cb2:	b7a50513          	addi	a0,a0,-1158 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207cb6:	0008e917          	auipc	s2,0x8e
ffffffffc0207cba:	b6290913          	addi	s2,s2,-1182 # ffffffffc0295818 <vdev_list>
ffffffffc0207cbe:	925fc0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0207cc2:	844a                	mv	s0,s2
ffffffffc0207cc4:	a039                	j	ffffffffc0207cd2 <vfs_do_add+0x72>
ffffffffc0207cc6:	fe043503          	ld	a0,-32(s0)
ffffffffc0207cca:	85a6                	mv	a1,s1
ffffffffc0207ccc:	075030ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc0207cd0:	cd2d                	beqz	a0,ffffffffc0207d4a <vfs_do_add+0xea>
ffffffffc0207cd2:	6400                	ld	s0,8(s0)
ffffffffc0207cd4:	ff2419e3          	bne	s0,s2,ffffffffc0207cc6 <vfs_do_add+0x66>
ffffffffc0207cd8:	6418                	ld	a4,8(s0)
ffffffffc0207cda:	02098793          	addi	a5,s3,32
ffffffffc0207cde:	0099b023          	sd	s1,0(s3)
ffffffffc0207ce2:	0149b423          	sd	s4,8(s3)
ffffffffc0207ce6:	0159bc23          	sd	s5,24(s3)
ffffffffc0207cea:	0169b823          	sd	s6,16(s3)
ffffffffc0207cee:	e31c                	sd	a5,0(a4)
ffffffffc0207cf0:	0289b023          	sd	s0,32(s3)
ffffffffc0207cf4:	02e9b423          	sd	a4,40(s3)
ffffffffc0207cf8:	0008e517          	auipc	a0,0x8e
ffffffffc0207cfc:	b3050513          	addi	a0,a0,-1232 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207d00:	e41c                	sd	a5,8(s0)
ffffffffc0207d02:	4401                	li	s0,0
ffffffffc0207d04:	8dbfc0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0207d08:	70e2                	ld	ra,56(sp)
ffffffffc0207d0a:	8522                	mv	a0,s0
ffffffffc0207d0c:	7442                	ld	s0,48(sp)
ffffffffc0207d0e:	74a2                	ld	s1,40(sp)
ffffffffc0207d10:	7902                	ld	s2,32(sp)
ffffffffc0207d12:	69e2                	ld	s3,24(sp)
ffffffffc0207d14:	6a42                	ld	s4,16(sp)
ffffffffc0207d16:	6aa2                	ld	s5,8(sp)
ffffffffc0207d18:	6b02                	ld	s6,0(sp)
ffffffffc0207d1a:	6121                	addi	sp,sp,64
ffffffffc0207d1c:	8082                	ret
ffffffffc0207d1e:	5471                	li	s0,-4
ffffffffc0207d20:	8526                	mv	a0,s1
ffffffffc0207d22:	b1cfa0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0207d26:	b7cd                	j	ffffffffc0207d08 <vfs_do_add+0xa8>
ffffffffc0207d28:	d2b5                	beqz	a3,ffffffffc0207c8c <vfs_do_add+0x2c>
ffffffffc0207d2a:	00007697          	auipc	a3,0x7
ffffffffc0207d2e:	95e68693          	addi	a3,a3,-1698 # ffffffffc020e688 <syscalls+0xa70>
ffffffffc0207d32:	00004617          	auipc	a2,0x4
ffffffffc0207d36:	d4e60613          	addi	a2,a2,-690 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207d3a:	08f00593          	li	a1,143
ffffffffc0207d3e:	00007517          	auipc	a0,0x7
ffffffffc0207d42:	93250513          	addi	a0,a0,-1742 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0207d46:	f58f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207d4a:	0008e517          	auipc	a0,0x8e
ffffffffc0207d4e:	ade50513          	addi	a0,a0,-1314 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207d52:	88dfc0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0207d56:	854e                	mv	a0,s3
ffffffffc0207d58:	ae6fa0ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0207d5c:	5425                	li	s0,-23
ffffffffc0207d5e:	b7c9                	j	ffffffffc0207d20 <vfs_do_add+0xc0>
ffffffffc0207d60:	5451                	li	s0,-12
ffffffffc0207d62:	b75d                	j	ffffffffc0207d08 <vfs_do_add+0xa8>
ffffffffc0207d64:	5471                	li	s0,-4
ffffffffc0207d66:	b74d                	j	ffffffffc0207d08 <vfs_do_add+0xa8>
ffffffffc0207d68:	00007697          	auipc	a3,0x7
ffffffffc0207d6c:	8f868693          	addi	a3,a3,-1800 # ffffffffc020e660 <syscalls+0xa48>
ffffffffc0207d70:	00004617          	auipc	a2,0x4
ffffffffc0207d74:	d1060613          	addi	a2,a2,-752 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207d78:	08e00593          	li	a1,142
ffffffffc0207d7c:	00007517          	auipc	a0,0x7
ffffffffc0207d80:	8f450513          	addi	a0,a0,-1804 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0207d84:	f1af80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207d88 <find_mount.part.0>:
ffffffffc0207d88:	1141                	addi	sp,sp,-16
ffffffffc0207d8a:	00007697          	auipc	a3,0x7
ffffffffc0207d8e:	8d668693          	addi	a3,a3,-1834 # ffffffffc020e660 <syscalls+0xa48>
ffffffffc0207d92:	00004617          	auipc	a2,0x4
ffffffffc0207d96:	cee60613          	addi	a2,a2,-786 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207d9a:	0cd00593          	li	a1,205
ffffffffc0207d9e:	00007517          	auipc	a0,0x7
ffffffffc0207da2:	8d250513          	addi	a0,a0,-1838 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0207da6:	e406                	sd	ra,8(sp)
ffffffffc0207da8:	ef6f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207dac <vfs_devlist_init>:
ffffffffc0207dac:	0008e797          	auipc	a5,0x8e
ffffffffc0207db0:	a6c78793          	addi	a5,a5,-1428 # ffffffffc0295818 <vdev_list>
ffffffffc0207db4:	4585                	li	a1,1
ffffffffc0207db6:	0008e517          	auipc	a0,0x8e
ffffffffc0207dba:	a7250513          	addi	a0,a0,-1422 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207dbe:	e79c                	sd	a5,8(a5)
ffffffffc0207dc0:	e39c                	sd	a5,0(a5)
ffffffffc0207dc2:	817fc06f          	j	ffffffffc02045d8 <sem_init>

ffffffffc0207dc6 <vfs_cleanup>:
ffffffffc0207dc6:	1101                	addi	sp,sp,-32
ffffffffc0207dc8:	e426                	sd	s1,8(sp)
ffffffffc0207dca:	0008e497          	auipc	s1,0x8e
ffffffffc0207dce:	a4e48493          	addi	s1,s1,-1458 # ffffffffc0295818 <vdev_list>
ffffffffc0207dd2:	649c                	ld	a5,8(s1)
ffffffffc0207dd4:	ec06                	sd	ra,24(sp)
ffffffffc0207dd6:	e822                	sd	s0,16(sp)
ffffffffc0207dd8:	02978e63          	beq	a5,s1,ffffffffc0207e14 <vfs_cleanup+0x4e>
ffffffffc0207ddc:	0008e517          	auipc	a0,0x8e
ffffffffc0207de0:	a4c50513          	addi	a0,a0,-1460 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207de4:	ffefc0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0207de8:	6480                	ld	s0,8(s1)
ffffffffc0207dea:	00940b63          	beq	s0,s1,ffffffffc0207e00 <vfs_cleanup+0x3a>
ffffffffc0207dee:	ff043783          	ld	a5,-16(s0)
ffffffffc0207df2:	853e                	mv	a0,a5
ffffffffc0207df4:	c399                	beqz	a5,ffffffffc0207dfa <vfs_cleanup+0x34>
ffffffffc0207df6:	6bfc                	ld	a5,208(a5)
ffffffffc0207df8:	9782                	jalr	a5
ffffffffc0207dfa:	6400                	ld	s0,8(s0)
ffffffffc0207dfc:	fe9419e3          	bne	s0,s1,ffffffffc0207dee <vfs_cleanup+0x28>
ffffffffc0207e00:	6442                	ld	s0,16(sp)
ffffffffc0207e02:	60e2                	ld	ra,24(sp)
ffffffffc0207e04:	64a2                	ld	s1,8(sp)
ffffffffc0207e06:	0008e517          	auipc	a0,0x8e
ffffffffc0207e0a:	a2250513          	addi	a0,a0,-1502 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207e0e:	6105                	addi	sp,sp,32
ffffffffc0207e10:	fcefc06f          	j	ffffffffc02045de <up>
ffffffffc0207e14:	60e2                	ld	ra,24(sp)
ffffffffc0207e16:	6442                	ld	s0,16(sp)
ffffffffc0207e18:	64a2                	ld	s1,8(sp)
ffffffffc0207e1a:	6105                	addi	sp,sp,32
ffffffffc0207e1c:	8082                	ret

ffffffffc0207e1e <vfs_get_root>:
ffffffffc0207e1e:	7179                	addi	sp,sp,-48
ffffffffc0207e20:	f406                	sd	ra,40(sp)
ffffffffc0207e22:	f022                	sd	s0,32(sp)
ffffffffc0207e24:	ec26                	sd	s1,24(sp)
ffffffffc0207e26:	e84a                	sd	s2,16(sp)
ffffffffc0207e28:	e44e                	sd	s3,8(sp)
ffffffffc0207e2a:	e052                	sd	s4,0(sp)
ffffffffc0207e2c:	c541                	beqz	a0,ffffffffc0207eb4 <vfs_get_root+0x96>
ffffffffc0207e2e:	0008e917          	auipc	s2,0x8e
ffffffffc0207e32:	9ea90913          	addi	s2,s2,-1558 # ffffffffc0295818 <vdev_list>
ffffffffc0207e36:	00893783          	ld	a5,8(s2)
ffffffffc0207e3a:	07278b63          	beq	a5,s2,ffffffffc0207eb0 <vfs_get_root+0x92>
ffffffffc0207e3e:	89aa                	mv	s3,a0
ffffffffc0207e40:	0008e517          	auipc	a0,0x8e
ffffffffc0207e44:	9e850513          	addi	a0,a0,-1560 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207e48:	8a2e                	mv	s4,a1
ffffffffc0207e4a:	844a                	mv	s0,s2
ffffffffc0207e4c:	f96fc0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0207e50:	a801                	j	ffffffffc0207e60 <vfs_get_root+0x42>
ffffffffc0207e52:	fe043583          	ld	a1,-32(s0)
ffffffffc0207e56:	854e                	mv	a0,s3
ffffffffc0207e58:	6e8030ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc0207e5c:	84aa                	mv	s1,a0
ffffffffc0207e5e:	c505                	beqz	a0,ffffffffc0207e86 <vfs_get_root+0x68>
ffffffffc0207e60:	6400                	ld	s0,8(s0)
ffffffffc0207e62:	ff2418e3          	bne	s0,s2,ffffffffc0207e52 <vfs_get_root+0x34>
ffffffffc0207e66:	54cd                	li	s1,-13
ffffffffc0207e68:	0008e517          	auipc	a0,0x8e
ffffffffc0207e6c:	9c050513          	addi	a0,a0,-1600 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207e70:	f6efc0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0207e74:	70a2                	ld	ra,40(sp)
ffffffffc0207e76:	7402                	ld	s0,32(sp)
ffffffffc0207e78:	6942                	ld	s2,16(sp)
ffffffffc0207e7a:	69a2                	ld	s3,8(sp)
ffffffffc0207e7c:	6a02                	ld	s4,0(sp)
ffffffffc0207e7e:	8526                	mv	a0,s1
ffffffffc0207e80:	64e2                	ld	s1,24(sp)
ffffffffc0207e82:	6145                	addi	sp,sp,48
ffffffffc0207e84:	8082                	ret
ffffffffc0207e86:	ff043503          	ld	a0,-16(s0)
ffffffffc0207e8a:	c519                	beqz	a0,ffffffffc0207e98 <vfs_get_root+0x7a>
ffffffffc0207e8c:	617c                	ld	a5,192(a0)
ffffffffc0207e8e:	9782                	jalr	a5
ffffffffc0207e90:	c519                	beqz	a0,ffffffffc0207e9e <vfs_get_root+0x80>
ffffffffc0207e92:	00aa3023          	sd	a0,0(s4)
ffffffffc0207e96:	bfc9                	j	ffffffffc0207e68 <vfs_get_root+0x4a>
ffffffffc0207e98:	ff843783          	ld	a5,-8(s0)
ffffffffc0207e9c:	c399                	beqz	a5,ffffffffc0207ea2 <vfs_get_root+0x84>
ffffffffc0207e9e:	54c9                	li	s1,-14
ffffffffc0207ea0:	b7e1                	j	ffffffffc0207e68 <vfs_get_root+0x4a>
ffffffffc0207ea2:	fe843503          	ld	a0,-24(s0)
ffffffffc0207ea6:	a99ff0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc0207eaa:	fe843503          	ld	a0,-24(s0)
ffffffffc0207eae:	b7cd                	j	ffffffffc0207e90 <vfs_get_root+0x72>
ffffffffc0207eb0:	54cd                	li	s1,-13
ffffffffc0207eb2:	b7c9                	j	ffffffffc0207e74 <vfs_get_root+0x56>
ffffffffc0207eb4:	00006697          	auipc	a3,0x6
ffffffffc0207eb8:	7ac68693          	addi	a3,a3,1964 # ffffffffc020e660 <syscalls+0xa48>
ffffffffc0207ebc:	00004617          	auipc	a2,0x4
ffffffffc0207ec0:	bc460613          	addi	a2,a2,-1084 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207ec4:	04500593          	li	a1,69
ffffffffc0207ec8:	00006517          	auipc	a0,0x6
ffffffffc0207ecc:	7a850513          	addi	a0,a0,1960 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0207ed0:	dcef80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207ed4 <vfs_get_devname>:
ffffffffc0207ed4:	0008e697          	auipc	a3,0x8e
ffffffffc0207ed8:	94468693          	addi	a3,a3,-1724 # ffffffffc0295818 <vdev_list>
ffffffffc0207edc:	87b6                	mv	a5,a3
ffffffffc0207ede:	e511                	bnez	a0,ffffffffc0207eea <vfs_get_devname+0x16>
ffffffffc0207ee0:	a829                	j	ffffffffc0207efa <vfs_get_devname+0x26>
ffffffffc0207ee2:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207ee6:	00a70763          	beq	a4,a0,ffffffffc0207ef4 <vfs_get_devname+0x20>
ffffffffc0207eea:	679c                	ld	a5,8(a5)
ffffffffc0207eec:	fed79be3          	bne	a5,a3,ffffffffc0207ee2 <vfs_get_devname+0xe>
ffffffffc0207ef0:	4501                	li	a0,0
ffffffffc0207ef2:	8082                	ret
ffffffffc0207ef4:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207ef8:	8082                	ret
ffffffffc0207efa:	1141                	addi	sp,sp,-16
ffffffffc0207efc:	00006697          	auipc	a3,0x6
ffffffffc0207f00:	7ec68693          	addi	a3,a3,2028 # ffffffffc020e6e8 <syscalls+0xad0>
ffffffffc0207f04:	00004617          	auipc	a2,0x4
ffffffffc0207f08:	b7c60613          	addi	a2,a2,-1156 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207f0c:	06a00593          	li	a1,106
ffffffffc0207f10:	00006517          	auipc	a0,0x6
ffffffffc0207f14:	76050513          	addi	a0,a0,1888 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0207f18:	e406                	sd	ra,8(sp)
ffffffffc0207f1a:	d84f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0207f1e <vfs_add_dev>:
ffffffffc0207f1e:	86b2                	mv	a3,a2
ffffffffc0207f20:	4601                	li	a2,0
ffffffffc0207f22:	d3fff06f          	j	ffffffffc0207c60 <vfs_do_add>

ffffffffc0207f26 <vfs_mount>:
ffffffffc0207f26:	7179                	addi	sp,sp,-48
ffffffffc0207f28:	e84a                	sd	s2,16(sp)
ffffffffc0207f2a:	892a                	mv	s2,a0
ffffffffc0207f2c:	0008e517          	auipc	a0,0x8e
ffffffffc0207f30:	8fc50513          	addi	a0,a0,-1796 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207f34:	e44e                	sd	s3,8(sp)
ffffffffc0207f36:	f406                	sd	ra,40(sp)
ffffffffc0207f38:	f022                	sd	s0,32(sp)
ffffffffc0207f3a:	ec26                	sd	s1,24(sp)
ffffffffc0207f3c:	89ae                	mv	s3,a1
ffffffffc0207f3e:	ea4fc0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0207f42:	08090a63          	beqz	s2,ffffffffc0207fd6 <vfs_mount+0xb0>
ffffffffc0207f46:	0008e497          	auipc	s1,0x8e
ffffffffc0207f4a:	8d248493          	addi	s1,s1,-1838 # ffffffffc0295818 <vdev_list>
ffffffffc0207f4e:	6480                	ld	s0,8(s1)
ffffffffc0207f50:	00941663          	bne	s0,s1,ffffffffc0207f5c <vfs_mount+0x36>
ffffffffc0207f54:	a8ad                	j	ffffffffc0207fce <vfs_mount+0xa8>
ffffffffc0207f56:	6400                	ld	s0,8(s0)
ffffffffc0207f58:	06940b63          	beq	s0,s1,ffffffffc0207fce <vfs_mount+0xa8>
ffffffffc0207f5c:	ff843783          	ld	a5,-8(s0)
ffffffffc0207f60:	dbfd                	beqz	a5,ffffffffc0207f56 <vfs_mount+0x30>
ffffffffc0207f62:	fe043503          	ld	a0,-32(s0)
ffffffffc0207f66:	85ca                	mv	a1,s2
ffffffffc0207f68:	5d8030ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc0207f6c:	f56d                	bnez	a0,ffffffffc0207f56 <vfs_mount+0x30>
ffffffffc0207f6e:	ff043783          	ld	a5,-16(s0)
ffffffffc0207f72:	e3a5                	bnez	a5,ffffffffc0207fd2 <vfs_mount+0xac>
ffffffffc0207f74:	fe043783          	ld	a5,-32(s0)
ffffffffc0207f78:	c3c9                	beqz	a5,ffffffffc0207ffa <vfs_mount+0xd4>
ffffffffc0207f7a:	ff843783          	ld	a5,-8(s0)
ffffffffc0207f7e:	cfb5                	beqz	a5,ffffffffc0207ffa <vfs_mount+0xd4>
ffffffffc0207f80:	fe843503          	ld	a0,-24(s0)
ffffffffc0207f84:	c939                	beqz	a0,ffffffffc0207fda <vfs_mount+0xb4>
ffffffffc0207f86:	4d38                	lw	a4,88(a0)
ffffffffc0207f88:	6785                	lui	a5,0x1
ffffffffc0207f8a:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207f8e:	04f71663          	bne	a4,a5,ffffffffc0207fda <vfs_mount+0xb4>
ffffffffc0207f92:	ff040593          	addi	a1,s0,-16
ffffffffc0207f96:	9982                	jalr	s3
ffffffffc0207f98:	84aa                	mv	s1,a0
ffffffffc0207f9a:	ed01                	bnez	a0,ffffffffc0207fb2 <vfs_mount+0x8c>
ffffffffc0207f9c:	ff043783          	ld	a5,-16(s0)
ffffffffc0207fa0:	cfad                	beqz	a5,ffffffffc020801a <vfs_mount+0xf4>
ffffffffc0207fa2:	fe043583          	ld	a1,-32(s0)
ffffffffc0207fa6:	00006517          	auipc	a0,0x6
ffffffffc0207faa:	7d250513          	addi	a0,a0,2002 # ffffffffc020e778 <syscalls+0xb60>
ffffffffc0207fae:	9f8f80ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0207fb2:	0008e517          	auipc	a0,0x8e
ffffffffc0207fb6:	87650513          	addi	a0,a0,-1930 # ffffffffc0295828 <vdev_list_sem>
ffffffffc0207fba:	e24fc0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc0207fbe:	70a2                	ld	ra,40(sp)
ffffffffc0207fc0:	7402                	ld	s0,32(sp)
ffffffffc0207fc2:	6942                	ld	s2,16(sp)
ffffffffc0207fc4:	69a2                	ld	s3,8(sp)
ffffffffc0207fc6:	8526                	mv	a0,s1
ffffffffc0207fc8:	64e2                	ld	s1,24(sp)
ffffffffc0207fca:	6145                	addi	sp,sp,48
ffffffffc0207fcc:	8082                	ret
ffffffffc0207fce:	54cd                	li	s1,-13
ffffffffc0207fd0:	b7cd                	j	ffffffffc0207fb2 <vfs_mount+0x8c>
ffffffffc0207fd2:	54c5                	li	s1,-15
ffffffffc0207fd4:	bff9                	j	ffffffffc0207fb2 <vfs_mount+0x8c>
ffffffffc0207fd6:	db3ff0ef          	jal	ra,ffffffffc0207d88 <find_mount.part.0>
ffffffffc0207fda:	00006697          	auipc	a3,0x6
ffffffffc0207fde:	74e68693          	addi	a3,a3,1870 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc0207fe2:	00004617          	auipc	a2,0x4
ffffffffc0207fe6:	a9e60613          	addi	a2,a2,-1378 # ffffffffc020ba80 <commands+0x210>
ffffffffc0207fea:	0ed00593          	li	a1,237
ffffffffc0207fee:	00006517          	auipc	a0,0x6
ffffffffc0207ff2:	68250513          	addi	a0,a0,1666 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0207ff6:	ca8f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0207ffa:	00006697          	auipc	a3,0x6
ffffffffc0207ffe:	6fe68693          	addi	a3,a3,1790 # ffffffffc020e6f8 <syscalls+0xae0>
ffffffffc0208002:	00004617          	auipc	a2,0x4
ffffffffc0208006:	a7e60613          	addi	a2,a2,-1410 # ffffffffc020ba80 <commands+0x210>
ffffffffc020800a:	0eb00593          	li	a1,235
ffffffffc020800e:	00006517          	auipc	a0,0x6
ffffffffc0208012:	66250513          	addi	a0,a0,1634 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0208016:	c88f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020801a:	00006697          	auipc	a3,0x6
ffffffffc020801e:	74668693          	addi	a3,a3,1862 # ffffffffc020e760 <syscalls+0xb48>
ffffffffc0208022:	00004617          	auipc	a2,0x4
ffffffffc0208026:	a5e60613          	addi	a2,a2,-1442 # ffffffffc020ba80 <commands+0x210>
ffffffffc020802a:	0ef00593          	li	a1,239
ffffffffc020802e:	00006517          	auipc	a0,0x6
ffffffffc0208032:	64250513          	addi	a0,a0,1602 # ffffffffc020e670 <syscalls+0xa58>
ffffffffc0208036:	c68f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020803a <vfs_open>:
ffffffffc020803a:	711d                	addi	sp,sp,-96
ffffffffc020803c:	e4a6                	sd	s1,72(sp)
ffffffffc020803e:	e0ca                	sd	s2,64(sp)
ffffffffc0208040:	fc4e                	sd	s3,56(sp)
ffffffffc0208042:	ec86                	sd	ra,88(sp)
ffffffffc0208044:	e8a2                	sd	s0,80(sp)
ffffffffc0208046:	f852                	sd	s4,48(sp)
ffffffffc0208048:	f456                	sd	s5,40(sp)
ffffffffc020804a:	0035f793          	andi	a5,a1,3
ffffffffc020804e:	84ae                	mv	s1,a1
ffffffffc0208050:	892a                	mv	s2,a0
ffffffffc0208052:	89b2                	mv	s3,a2
ffffffffc0208054:	0e078663          	beqz	a5,ffffffffc0208140 <vfs_open+0x106>
ffffffffc0208058:	470d                	li	a4,3
ffffffffc020805a:	0105fa93          	andi	s5,a1,16
ffffffffc020805e:	0ce78f63          	beq	a5,a4,ffffffffc020813c <vfs_open+0x102>
ffffffffc0208062:	002c                	addi	a1,sp,8
ffffffffc0208064:	854a                	mv	a0,s2
ffffffffc0208066:	2ae000ef          	jal	ra,ffffffffc0208314 <vfs_lookup>
ffffffffc020806a:	842a                	mv	s0,a0
ffffffffc020806c:	0044fa13          	andi	s4,s1,4
ffffffffc0208070:	e159                	bnez	a0,ffffffffc02080f6 <vfs_open+0xbc>
ffffffffc0208072:	00c4f793          	andi	a5,s1,12
ffffffffc0208076:	4731                	li	a4,12
ffffffffc0208078:	0ee78263          	beq	a5,a4,ffffffffc020815c <vfs_open+0x122>
ffffffffc020807c:	6422                	ld	s0,8(sp)
ffffffffc020807e:	12040163          	beqz	s0,ffffffffc02081a0 <vfs_open+0x166>
ffffffffc0208082:	783c                	ld	a5,112(s0)
ffffffffc0208084:	cff1                	beqz	a5,ffffffffc0208160 <vfs_open+0x126>
ffffffffc0208086:	679c                	ld	a5,8(a5)
ffffffffc0208088:	cfe1                	beqz	a5,ffffffffc0208160 <vfs_open+0x126>
ffffffffc020808a:	8522                	mv	a0,s0
ffffffffc020808c:	00006597          	auipc	a1,0x6
ffffffffc0208090:	7cc58593          	addi	a1,a1,1996 # ffffffffc020e858 <syscalls+0xc40>
ffffffffc0208094:	8c3ff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0208098:	783c                	ld	a5,112(s0)
ffffffffc020809a:	6522                	ld	a0,8(sp)
ffffffffc020809c:	85a6                	mv	a1,s1
ffffffffc020809e:	679c                	ld	a5,8(a5)
ffffffffc02080a0:	9782                	jalr	a5
ffffffffc02080a2:	842a                	mv	s0,a0
ffffffffc02080a4:	6522                	ld	a0,8(sp)
ffffffffc02080a6:	e845                	bnez	s0,ffffffffc0208156 <vfs_open+0x11c>
ffffffffc02080a8:	015a6a33          	or	s4,s4,s5
ffffffffc02080ac:	89fff0ef          	jal	ra,ffffffffc020794a <inode_open_inc>
ffffffffc02080b0:	020a0663          	beqz	s4,ffffffffc02080dc <vfs_open+0xa2>
ffffffffc02080b4:	64a2                	ld	s1,8(sp)
ffffffffc02080b6:	c4e9                	beqz	s1,ffffffffc0208180 <vfs_open+0x146>
ffffffffc02080b8:	78bc                	ld	a5,112(s1)
ffffffffc02080ba:	c3f9                	beqz	a5,ffffffffc0208180 <vfs_open+0x146>
ffffffffc02080bc:	73bc                	ld	a5,96(a5)
ffffffffc02080be:	c3e9                	beqz	a5,ffffffffc0208180 <vfs_open+0x146>
ffffffffc02080c0:	00006597          	auipc	a1,0x6
ffffffffc02080c4:	7f858593          	addi	a1,a1,2040 # ffffffffc020e8b8 <syscalls+0xca0>
ffffffffc02080c8:	8526                	mv	a0,s1
ffffffffc02080ca:	88dff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc02080ce:	78bc                	ld	a5,112(s1)
ffffffffc02080d0:	6522                	ld	a0,8(sp)
ffffffffc02080d2:	4581                	li	a1,0
ffffffffc02080d4:	73bc                	ld	a5,96(a5)
ffffffffc02080d6:	9782                	jalr	a5
ffffffffc02080d8:	87aa                	mv	a5,a0
ffffffffc02080da:	e92d                	bnez	a0,ffffffffc020814c <vfs_open+0x112>
ffffffffc02080dc:	67a2                	ld	a5,8(sp)
ffffffffc02080de:	00f9b023          	sd	a5,0(s3)
ffffffffc02080e2:	60e6                	ld	ra,88(sp)
ffffffffc02080e4:	8522                	mv	a0,s0
ffffffffc02080e6:	6446                	ld	s0,80(sp)
ffffffffc02080e8:	64a6                	ld	s1,72(sp)
ffffffffc02080ea:	6906                	ld	s2,64(sp)
ffffffffc02080ec:	79e2                	ld	s3,56(sp)
ffffffffc02080ee:	7a42                	ld	s4,48(sp)
ffffffffc02080f0:	7aa2                	ld	s5,40(sp)
ffffffffc02080f2:	6125                	addi	sp,sp,96
ffffffffc02080f4:	8082                	ret
ffffffffc02080f6:	57c1                	li	a5,-16
ffffffffc02080f8:	fef515e3          	bne	a0,a5,ffffffffc02080e2 <vfs_open+0xa8>
ffffffffc02080fc:	fe0a03e3          	beqz	s4,ffffffffc02080e2 <vfs_open+0xa8>
ffffffffc0208100:	0810                	addi	a2,sp,16
ffffffffc0208102:	082c                	addi	a1,sp,24
ffffffffc0208104:	854a                	mv	a0,s2
ffffffffc0208106:	2a4000ef          	jal	ra,ffffffffc02083aa <vfs_lookup_parent>
ffffffffc020810a:	842a                	mv	s0,a0
ffffffffc020810c:	f979                	bnez	a0,ffffffffc02080e2 <vfs_open+0xa8>
ffffffffc020810e:	6462                	ld	s0,24(sp)
ffffffffc0208110:	c845                	beqz	s0,ffffffffc02081c0 <vfs_open+0x186>
ffffffffc0208112:	783c                	ld	a5,112(s0)
ffffffffc0208114:	c7d5                	beqz	a5,ffffffffc02081c0 <vfs_open+0x186>
ffffffffc0208116:	77bc                	ld	a5,104(a5)
ffffffffc0208118:	c7c5                	beqz	a5,ffffffffc02081c0 <vfs_open+0x186>
ffffffffc020811a:	8522                	mv	a0,s0
ffffffffc020811c:	00006597          	auipc	a1,0x6
ffffffffc0208120:	6d458593          	addi	a1,a1,1748 # ffffffffc020e7f0 <syscalls+0xbd8>
ffffffffc0208124:	833ff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0208128:	783c                	ld	a5,112(s0)
ffffffffc020812a:	65c2                	ld	a1,16(sp)
ffffffffc020812c:	6562                	ld	a0,24(sp)
ffffffffc020812e:	77bc                	ld	a5,104(a5)
ffffffffc0208130:	4034d613          	srai	a2,s1,0x3
ffffffffc0208134:	0034                	addi	a3,sp,8
ffffffffc0208136:	8a05                	andi	a2,a2,1
ffffffffc0208138:	9782                	jalr	a5
ffffffffc020813a:	b789                	j	ffffffffc020807c <vfs_open+0x42>
ffffffffc020813c:	5475                	li	s0,-3
ffffffffc020813e:	b755                	j	ffffffffc02080e2 <vfs_open+0xa8>
ffffffffc0208140:	0105fa93          	andi	s5,a1,16
ffffffffc0208144:	5475                	li	s0,-3
ffffffffc0208146:	f80a9ee3          	bnez	s5,ffffffffc02080e2 <vfs_open+0xa8>
ffffffffc020814a:	bf21                	j	ffffffffc0208062 <vfs_open+0x28>
ffffffffc020814c:	6522                	ld	a0,8(sp)
ffffffffc020814e:	843e                	mv	s0,a5
ffffffffc0208150:	965ff0ef          	jal	ra,ffffffffc0207ab4 <inode_open_dec>
ffffffffc0208154:	6522                	ld	a0,8(sp)
ffffffffc0208156:	8b7ff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020815a:	b761                	j	ffffffffc02080e2 <vfs_open+0xa8>
ffffffffc020815c:	5425                	li	s0,-23
ffffffffc020815e:	b751                	j	ffffffffc02080e2 <vfs_open+0xa8>
ffffffffc0208160:	00006697          	auipc	a3,0x6
ffffffffc0208164:	6a868693          	addi	a3,a3,1704 # ffffffffc020e808 <syscalls+0xbf0>
ffffffffc0208168:	00004617          	auipc	a2,0x4
ffffffffc020816c:	91860613          	addi	a2,a2,-1768 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208170:	03300593          	li	a1,51
ffffffffc0208174:	00006517          	auipc	a0,0x6
ffffffffc0208178:	66450513          	addi	a0,a0,1636 # ffffffffc020e7d8 <syscalls+0xbc0>
ffffffffc020817c:	b22f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208180:	00006697          	auipc	a3,0x6
ffffffffc0208184:	6e068693          	addi	a3,a3,1760 # ffffffffc020e860 <syscalls+0xc48>
ffffffffc0208188:	00004617          	auipc	a2,0x4
ffffffffc020818c:	8f860613          	addi	a2,a2,-1800 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208190:	03a00593          	li	a1,58
ffffffffc0208194:	00006517          	auipc	a0,0x6
ffffffffc0208198:	64450513          	addi	a0,a0,1604 # ffffffffc020e7d8 <syscalls+0xbc0>
ffffffffc020819c:	b02f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02081a0:	00006697          	auipc	a3,0x6
ffffffffc02081a4:	65868693          	addi	a3,a3,1624 # ffffffffc020e7f8 <syscalls+0xbe0>
ffffffffc02081a8:	00004617          	auipc	a2,0x4
ffffffffc02081ac:	8d860613          	addi	a2,a2,-1832 # ffffffffc020ba80 <commands+0x210>
ffffffffc02081b0:	03100593          	li	a1,49
ffffffffc02081b4:	00006517          	auipc	a0,0x6
ffffffffc02081b8:	62450513          	addi	a0,a0,1572 # ffffffffc020e7d8 <syscalls+0xbc0>
ffffffffc02081bc:	ae2f80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02081c0:	00006697          	auipc	a3,0x6
ffffffffc02081c4:	5c868693          	addi	a3,a3,1480 # ffffffffc020e788 <syscalls+0xb70>
ffffffffc02081c8:	00004617          	auipc	a2,0x4
ffffffffc02081cc:	8b860613          	addi	a2,a2,-1864 # ffffffffc020ba80 <commands+0x210>
ffffffffc02081d0:	02c00593          	li	a1,44
ffffffffc02081d4:	00006517          	auipc	a0,0x6
ffffffffc02081d8:	60450513          	addi	a0,a0,1540 # ffffffffc020e7d8 <syscalls+0xbc0>
ffffffffc02081dc:	ac2f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02081e0 <vfs_close>:
ffffffffc02081e0:	1141                	addi	sp,sp,-16
ffffffffc02081e2:	e406                	sd	ra,8(sp)
ffffffffc02081e4:	e022                	sd	s0,0(sp)
ffffffffc02081e6:	842a                	mv	s0,a0
ffffffffc02081e8:	8cdff0ef          	jal	ra,ffffffffc0207ab4 <inode_open_dec>
ffffffffc02081ec:	8522                	mv	a0,s0
ffffffffc02081ee:	81fff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc02081f2:	60a2                	ld	ra,8(sp)
ffffffffc02081f4:	6402                	ld	s0,0(sp)
ffffffffc02081f6:	4501                	li	a0,0
ffffffffc02081f8:	0141                	addi	sp,sp,16
ffffffffc02081fa:	8082                	ret

ffffffffc02081fc <get_device>:
ffffffffc02081fc:	7179                	addi	sp,sp,-48
ffffffffc02081fe:	ec26                	sd	s1,24(sp)
ffffffffc0208200:	e84a                	sd	s2,16(sp)
ffffffffc0208202:	f406                	sd	ra,40(sp)
ffffffffc0208204:	f022                	sd	s0,32(sp)
ffffffffc0208206:	00054303          	lbu	t1,0(a0)
ffffffffc020820a:	892e                	mv	s2,a1
ffffffffc020820c:	84b2                	mv	s1,a2
ffffffffc020820e:	02030463          	beqz	t1,ffffffffc0208236 <get_device+0x3a>
ffffffffc0208212:	00150413          	addi	s0,a0,1
ffffffffc0208216:	86a2                	mv	a3,s0
ffffffffc0208218:	879a                	mv	a5,t1
ffffffffc020821a:	4701                	li	a4,0
ffffffffc020821c:	03a00813          	li	a6,58
ffffffffc0208220:	02f00893          	li	a7,47
ffffffffc0208224:	03078263          	beq	a5,a6,ffffffffc0208248 <get_device+0x4c>
ffffffffc0208228:	05178963          	beq	a5,a7,ffffffffc020827a <get_device+0x7e>
ffffffffc020822c:	0006c783          	lbu	a5,0(a3)
ffffffffc0208230:	2705                	addiw	a4,a4,1
ffffffffc0208232:	0685                	addi	a3,a3,1
ffffffffc0208234:	fbe5                	bnez	a5,ffffffffc0208224 <get_device+0x28>
ffffffffc0208236:	7402                	ld	s0,32(sp)
ffffffffc0208238:	00a93023          	sd	a0,0(s2)
ffffffffc020823c:	70a2                	ld	ra,40(sp)
ffffffffc020823e:	6942                	ld	s2,16(sp)
ffffffffc0208240:	8526                	mv	a0,s1
ffffffffc0208242:	64e2                	ld	s1,24(sp)
ffffffffc0208244:	6145                	addi	sp,sp,48
ffffffffc0208246:	a279                	j	ffffffffc02083d4 <vfs_get_curdir>
ffffffffc0208248:	cb15                	beqz	a4,ffffffffc020827c <get_device+0x80>
ffffffffc020824a:	00e507b3          	add	a5,a0,a4
ffffffffc020824e:	0705                	addi	a4,a4,1
ffffffffc0208250:	00078023          	sb	zero,0(a5)
ffffffffc0208254:	972a                	add	a4,a4,a0
ffffffffc0208256:	02f00613          	li	a2,47
ffffffffc020825a:	00074783          	lbu	a5,0(a4)
ffffffffc020825e:	86ba                	mv	a3,a4
ffffffffc0208260:	0705                	addi	a4,a4,1
ffffffffc0208262:	fec78ce3          	beq	a5,a2,ffffffffc020825a <get_device+0x5e>
ffffffffc0208266:	7402                	ld	s0,32(sp)
ffffffffc0208268:	70a2                	ld	ra,40(sp)
ffffffffc020826a:	00d93023          	sd	a3,0(s2)
ffffffffc020826e:	85a6                	mv	a1,s1
ffffffffc0208270:	6942                	ld	s2,16(sp)
ffffffffc0208272:	64e2                	ld	s1,24(sp)
ffffffffc0208274:	6145                	addi	sp,sp,48
ffffffffc0208276:	ba9ff06f          	j	ffffffffc0207e1e <vfs_get_root>
ffffffffc020827a:	ff55                	bnez	a4,ffffffffc0208236 <get_device+0x3a>
ffffffffc020827c:	02f00793          	li	a5,47
ffffffffc0208280:	04f30563          	beq	t1,a5,ffffffffc02082ca <get_device+0xce>
ffffffffc0208284:	03a00793          	li	a5,58
ffffffffc0208288:	06f31663          	bne	t1,a5,ffffffffc02082f4 <get_device+0xf8>
ffffffffc020828c:	0028                	addi	a0,sp,8
ffffffffc020828e:	146000ef          	jal	ra,ffffffffc02083d4 <vfs_get_curdir>
ffffffffc0208292:	e515                	bnez	a0,ffffffffc02082be <get_device+0xc2>
ffffffffc0208294:	67a2                	ld	a5,8(sp)
ffffffffc0208296:	77a8                	ld	a0,104(a5)
ffffffffc0208298:	cd15                	beqz	a0,ffffffffc02082d4 <get_device+0xd8>
ffffffffc020829a:	617c                	ld	a5,192(a0)
ffffffffc020829c:	9782                	jalr	a5
ffffffffc020829e:	87aa                	mv	a5,a0
ffffffffc02082a0:	6522                	ld	a0,8(sp)
ffffffffc02082a2:	e09c                	sd	a5,0(s1)
ffffffffc02082a4:	f68ff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc02082a8:	02f00713          	li	a4,47
ffffffffc02082ac:	a011                	j	ffffffffc02082b0 <get_device+0xb4>
ffffffffc02082ae:	0405                	addi	s0,s0,1
ffffffffc02082b0:	00044783          	lbu	a5,0(s0)
ffffffffc02082b4:	fee78de3          	beq	a5,a4,ffffffffc02082ae <get_device+0xb2>
ffffffffc02082b8:	00893023          	sd	s0,0(s2)
ffffffffc02082bc:	4501                	li	a0,0
ffffffffc02082be:	70a2                	ld	ra,40(sp)
ffffffffc02082c0:	7402                	ld	s0,32(sp)
ffffffffc02082c2:	64e2                	ld	s1,24(sp)
ffffffffc02082c4:	6942                	ld	s2,16(sp)
ffffffffc02082c6:	6145                	addi	sp,sp,48
ffffffffc02082c8:	8082                	ret
ffffffffc02082ca:	8526                	mv	a0,s1
ffffffffc02082cc:	93fff0ef          	jal	ra,ffffffffc0207c0a <vfs_get_bootfs>
ffffffffc02082d0:	dd61                	beqz	a0,ffffffffc02082a8 <get_device+0xac>
ffffffffc02082d2:	b7f5                	j	ffffffffc02082be <get_device+0xc2>
ffffffffc02082d4:	00006697          	auipc	a3,0x6
ffffffffc02082d8:	61c68693          	addi	a3,a3,1564 # ffffffffc020e8f0 <syscalls+0xcd8>
ffffffffc02082dc:	00003617          	auipc	a2,0x3
ffffffffc02082e0:	7a460613          	addi	a2,a2,1956 # ffffffffc020ba80 <commands+0x210>
ffffffffc02082e4:	03900593          	li	a1,57
ffffffffc02082e8:	00006517          	auipc	a0,0x6
ffffffffc02082ec:	5f050513          	addi	a0,a0,1520 # ffffffffc020e8d8 <syscalls+0xcc0>
ffffffffc02082f0:	9aef80ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02082f4:	00006697          	auipc	a3,0x6
ffffffffc02082f8:	5d468693          	addi	a3,a3,1492 # ffffffffc020e8c8 <syscalls+0xcb0>
ffffffffc02082fc:	00003617          	auipc	a2,0x3
ffffffffc0208300:	78460613          	addi	a2,a2,1924 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208304:	03300593          	li	a1,51
ffffffffc0208308:	00006517          	auipc	a0,0x6
ffffffffc020830c:	5d050513          	addi	a0,a0,1488 # ffffffffc020e8d8 <syscalls+0xcc0>
ffffffffc0208310:	98ef80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208314 <vfs_lookup>:
ffffffffc0208314:	7139                	addi	sp,sp,-64
ffffffffc0208316:	f426                	sd	s1,40(sp)
ffffffffc0208318:	0830                	addi	a2,sp,24
ffffffffc020831a:	84ae                	mv	s1,a1
ffffffffc020831c:	002c                	addi	a1,sp,8
ffffffffc020831e:	f822                	sd	s0,48(sp)
ffffffffc0208320:	fc06                	sd	ra,56(sp)
ffffffffc0208322:	f04a                	sd	s2,32(sp)
ffffffffc0208324:	e42a                	sd	a0,8(sp)
ffffffffc0208326:	ed7ff0ef          	jal	ra,ffffffffc02081fc <get_device>
ffffffffc020832a:	842a                	mv	s0,a0
ffffffffc020832c:	ed1d                	bnez	a0,ffffffffc020836a <vfs_lookup+0x56>
ffffffffc020832e:	67a2                	ld	a5,8(sp)
ffffffffc0208330:	6962                	ld	s2,24(sp)
ffffffffc0208332:	0007c783          	lbu	a5,0(a5)
ffffffffc0208336:	c3a9                	beqz	a5,ffffffffc0208378 <vfs_lookup+0x64>
ffffffffc0208338:	04090963          	beqz	s2,ffffffffc020838a <vfs_lookup+0x76>
ffffffffc020833c:	07093783          	ld	a5,112(s2)
ffffffffc0208340:	c7a9                	beqz	a5,ffffffffc020838a <vfs_lookup+0x76>
ffffffffc0208342:	7bbc                	ld	a5,112(a5)
ffffffffc0208344:	c3b9                	beqz	a5,ffffffffc020838a <vfs_lookup+0x76>
ffffffffc0208346:	854a                	mv	a0,s2
ffffffffc0208348:	00006597          	auipc	a1,0x6
ffffffffc020834c:	61058593          	addi	a1,a1,1552 # ffffffffc020e958 <syscalls+0xd40>
ffffffffc0208350:	e06ff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0208354:	07093783          	ld	a5,112(s2)
ffffffffc0208358:	65a2                	ld	a1,8(sp)
ffffffffc020835a:	6562                	ld	a0,24(sp)
ffffffffc020835c:	7bbc                	ld	a5,112(a5)
ffffffffc020835e:	8626                	mv	a2,s1
ffffffffc0208360:	9782                	jalr	a5
ffffffffc0208362:	842a                	mv	s0,a0
ffffffffc0208364:	6562                	ld	a0,24(sp)
ffffffffc0208366:	ea6ff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020836a:	70e2                	ld	ra,56(sp)
ffffffffc020836c:	8522                	mv	a0,s0
ffffffffc020836e:	7442                	ld	s0,48(sp)
ffffffffc0208370:	74a2                	ld	s1,40(sp)
ffffffffc0208372:	7902                	ld	s2,32(sp)
ffffffffc0208374:	6121                	addi	sp,sp,64
ffffffffc0208376:	8082                	ret
ffffffffc0208378:	70e2                	ld	ra,56(sp)
ffffffffc020837a:	8522                	mv	a0,s0
ffffffffc020837c:	7442                	ld	s0,48(sp)
ffffffffc020837e:	0124b023          	sd	s2,0(s1)
ffffffffc0208382:	74a2                	ld	s1,40(sp)
ffffffffc0208384:	7902                	ld	s2,32(sp)
ffffffffc0208386:	6121                	addi	sp,sp,64
ffffffffc0208388:	8082                	ret
ffffffffc020838a:	00006697          	auipc	a3,0x6
ffffffffc020838e:	57e68693          	addi	a3,a3,1406 # ffffffffc020e908 <syscalls+0xcf0>
ffffffffc0208392:	00003617          	auipc	a2,0x3
ffffffffc0208396:	6ee60613          	addi	a2,a2,1774 # ffffffffc020ba80 <commands+0x210>
ffffffffc020839a:	04f00593          	li	a1,79
ffffffffc020839e:	00006517          	auipc	a0,0x6
ffffffffc02083a2:	53a50513          	addi	a0,a0,1338 # ffffffffc020e8d8 <syscalls+0xcc0>
ffffffffc02083a6:	8f8f80ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02083aa <vfs_lookup_parent>:
ffffffffc02083aa:	7139                	addi	sp,sp,-64
ffffffffc02083ac:	f822                	sd	s0,48(sp)
ffffffffc02083ae:	f426                	sd	s1,40(sp)
ffffffffc02083b0:	842e                	mv	s0,a1
ffffffffc02083b2:	84b2                	mv	s1,a2
ffffffffc02083b4:	002c                	addi	a1,sp,8
ffffffffc02083b6:	0830                	addi	a2,sp,24
ffffffffc02083b8:	fc06                	sd	ra,56(sp)
ffffffffc02083ba:	e42a                	sd	a0,8(sp)
ffffffffc02083bc:	e41ff0ef          	jal	ra,ffffffffc02081fc <get_device>
ffffffffc02083c0:	e509                	bnez	a0,ffffffffc02083ca <vfs_lookup_parent+0x20>
ffffffffc02083c2:	67a2                	ld	a5,8(sp)
ffffffffc02083c4:	e09c                	sd	a5,0(s1)
ffffffffc02083c6:	67e2                	ld	a5,24(sp)
ffffffffc02083c8:	e01c                	sd	a5,0(s0)
ffffffffc02083ca:	70e2                	ld	ra,56(sp)
ffffffffc02083cc:	7442                	ld	s0,48(sp)
ffffffffc02083ce:	74a2                	ld	s1,40(sp)
ffffffffc02083d0:	6121                	addi	sp,sp,64
ffffffffc02083d2:	8082                	ret

ffffffffc02083d4 <vfs_get_curdir>:
ffffffffc02083d4:	0008e797          	auipc	a5,0x8e
ffffffffc02083d8:	4ec7b783          	ld	a5,1260(a5) # ffffffffc02968c0 <current>
ffffffffc02083dc:	1487b783          	ld	a5,328(a5)
ffffffffc02083e0:	1101                	addi	sp,sp,-32
ffffffffc02083e2:	e426                	sd	s1,8(sp)
ffffffffc02083e4:	6384                	ld	s1,0(a5)
ffffffffc02083e6:	ec06                	sd	ra,24(sp)
ffffffffc02083e8:	e822                	sd	s0,16(sp)
ffffffffc02083ea:	cc81                	beqz	s1,ffffffffc0208402 <vfs_get_curdir+0x2e>
ffffffffc02083ec:	842a                	mv	s0,a0
ffffffffc02083ee:	8526                	mv	a0,s1
ffffffffc02083f0:	d4eff0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc02083f4:	4501                	li	a0,0
ffffffffc02083f6:	e004                	sd	s1,0(s0)
ffffffffc02083f8:	60e2                	ld	ra,24(sp)
ffffffffc02083fa:	6442                	ld	s0,16(sp)
ffffffffc02083fc:	64a2                	ld	s1,8(sp)
ffffffffc02083fe:	6105                	addi	sp,sp,32
ffffffffc0208400:	8082                	ret
ffffffffc0208402:	5541                	li	a0,-16
ffffffffc0208404:	bfd5                	j	ffffffffc02083f8 <vfs_get_curdir+0x24>

ffffffffc0208406 <vfs_set_curdir>:
ffffffffc0208406:	7139                	addi	sp,sp,-64
ffffffffc0208408:	f04a                	sd	s2,32(sp)
ffffffffc020840a:	0008e917          	auipc	s2,0x8e
ffffffffc020840e:	4b690913          	addi	s2,s2,1206 # ffffffffc02968c0 <current>
ffffffffc0208412:	00093783          	ld	a5,0(s2)
ffffffffc0208416:	f822                	sd	s0,48(sp)
ffffffffc0208418:	842a                	mv	s0,a0
ffffffffc020841a:	1487b503          	ld	a0,328(a5)
ffffffffc020841e:	ec4e                	sd	s3,24(sp)
ffffffffc0208420:	fc06                	sd	ra,56(sp)
ffffffffc0208422:	f426                	sd	s1,40(sp)
ffffffffc0208424:	e1dfc0ef          	jal	ra,ffffffffc0205240 <lock_files>
ffffffffc0208428:	00093783          	ld	a5,0(s2)
ffffffffc020842c:	1487b503          	ld	a0,328(a5)
ffffffffc0208430:	00053983          	ld	s3,0(a0)
ffffffffc0208434:	07340963          	beq	s0,s3,ffffffffc02084a6 <vfs_set_curdir+0xa0>
ffffffffc0208438:	cc39                	beqz	s0,ffffffffc0208496 <vfs_set_curdir+0x90>
ffffffffc020843a:	783c                	ld	a5,112(s0)
ffffffffc020843c:	c7bd                	beqz	a5,ffffffffc02084aa <vfs_set_curdir+0xa4>
ffffffffc020843e:	6bbc                	ld	a5,80(a5)
ffffffffc0208440:	c7ad                	beqz	a5,ffffffffc02084aa <vfs_set_curdir+0xa4>
ffffffffc0208442:	00006597          	auipc	a1,0x6
ffffffffc0208446:	58658593          	addi	a1,a1,1414 # ffffffffc020e9c8 <syscalls+0xdb0>
ffffffffc020844a:	8522                	mv	a0,s0
ffffffffc020844c:	d0aff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0208450:	783c                	ld	a5,112(s0)
ffffffffc0208452:	006c                	addi	a1,sp,12
ffffffffc0208454:	8522                	mv	a0,s0
ffffffffc0208456:	6bbc                	ld	a5,80(a5)
ffffffffc0208458:	9782                	jalr	a5
ffffffffc020845a:	84aa                	mv	s1,a0
ffffffffc020845c:	e901                	bnez	a0,ffffffffc020846c <vfs_set_curdir+0x66>
ffffffffc020845e:	47b2                	lw	a5,12(sp)
ffffffffc0208460:	669d                	lui	a3,0x7
ffffffffc0208462:	6709                	lui	a4,0x2
ffffffffc0208464:	8ff5                	and	a5,a5,a3
ffffffffc0208466:	54b9                	li	s1,-18
ffffffffc0208468:	02e78063          	beq	a5,a4,ffffffffc0208488 <vfs_set_curdir+0x82>
ffffffffc020846c:	00093783          	ld	a5,0(s2)
ffffffffc0208470:	1487b503          	ld	a0,328(a5)
ffffffffc0208474:	dd3fc0ef          	jal	ra,ffffffffc0205246 <unlock_files>
ffffffffc0208478:	70e2                	ld	ra,56(sp)
ffffffffc020847a:	7442                	ld	s0,48(sp)
ffffffffc020847c:	7902                	ld	s2,32(sp)
ffffffffc020847e:	69e2                	ld	s3,24(sp)
ffffffffc0208480:	8526                	mv	a0,s1
ffffffffc0208482:	74a2                	ld	s1,40(sp)
ffffffffc0208484:	6121                	addi	sp,sp,64
ffffffffc0208486:	8082                	ret
ffffffffc0208488:	8522                	mv	a0,s0
ffffffffc020848a:	cb4ff0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc020848e:	00093783          	ld	a5,0(s2)
ffffffffc0208492:	1487b503          	ld	a0,328(a5)
ffffffffc0208496:	e100                	sd	s0,0(a0)
ffffffffc0208498:	4481                	li	s1,0
ffffffffc020849a:	fc098de3          	beqz	s3,ffffffffc0208474 <vfs_set_curdir+0x6e>
ffffffffc020849e:	854e                	mv	a0,s3
ffffffffc02084a0:	d6cff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc02084a4:	b7e1                	j	ffffffffc020846c <vfs_set_curdir+0x66>
ffffffffc02084a6:	4481                	li	s1,0
ffffffffc02084a8:	b7f1                	j	ffffffffc0208474 <vfs_set_curdir+0x6e>
ffffffffc02084aa:	00006697          	auipc	a3,0x6
ffffffffc02084ae:	4b668693          	addi	a3,a3,1206 # ffffffffc020e960 <syscalls+0xd48>
ffffffffc02084b2:	00003617          	auipc	a2,0x3
ffffffffc02084b6:	5ce60613          	addi	a2,a2,1486 # ffffffffc020ba80 <commands+0x210>
ffffffffc02084ba:	04300593          	li	a1,67
ffffffffc02084be:	00006517          	auipc	a0,0x6
ffffffffc02084c2:	4f250513          	addi	a0,a0,1266 # ffffffffc020e9b0 <syscalls+0xd98>
ffffffffc02084c6:	fd9f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02084ca <vfs_chdir>:
ffffffffc02084ca:	1101                	addi	sp,sp,-32
ffffffffc02084cc:	002c                	addi	a1,sp,8
ffffffffc02084ce:	e822                	sd	s0,16(sp)
ffffffffc02084d0:	ec06                	sd	ra,24(sp)
ffffffffc02084d2:	e43ff0ef          	jal	ra,ffffffffc0208314 <vfs_lookup>
ffffffffc02084d6:	842a                	mv	s0,a0
ffffffffc02084d8:	c511                	beqz	a0,ffffffffc02084e4 <vfs_chdir+0x1a>
ffffffffc02084da:	60e2                	ld	ra,24(sp)
ffffffffc02084dc:	8522                	mv	a0,s0
ffffffffc02084de:	6442                	ld	s0,16(sp)
ffffffffc02084e0:	6105                	addi	sp,sp,32
ffffffffc02084e2:	8082                	ret
ffffffffc02084e4:	6522                	ld	a0,8(sp)
ffffffffc02084e6:	f21ff0ef          	jal	ra,ffffffffc0208406 <vfs_set_curdir>
ffffffffc02084ea:	842a                	mv	s0,a0
ffffffffc02084ec:	6522                	ld	a0,8(sp)
ffffffffc02084ee:	d1eff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc02084f2:	60e2                	ld	ra,24(sp)
ffffffffc02084f4:	8522                	mv	a0,s0
ffffffffc02084f6:	6442                	ld	s0,16(sp)
ffffffffc02084f8:	6105                	addi	sp,sp,32
ffffffffc02084fa:	8082                	ret

ffffffffc02084fc <vfs_getcwd>:
ffffffffc02084fc:	0008e797          	auipc	a5,0x8e
ffffffffc0208500:	3c47b783          	ld	a5,964(a5) # ffffffffc02968c0 <current>
ffffffffc0208504:	1487b783          	ld	a5,328(a5)
ffffffffc0208508:	7179                	addi	sp,sp,-48
ffffffffc020850a:	ec26                	sd	s1,24(sp)
ffffffffc020850c:	6384                	ld	s1,0(a5)
ffffffffc020850e:	f406                	sd	ra,40(sp)
ffffffffc0208510:	f022                	sd	s0,32(sp)
ffffffffc0208512:	e84a                	sd	s2,16(sp)
ffffffffc0208514:	ccbd                	beqz	s1,ffffffffc0208592 <vfs_getcwd+0x96>
ffffffffc0208516:	892a                	mv	s2,a0
ffffffffc0208518:	8526                	mv	a0,s1
ffffffffc020851a:	c24ff0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc020851e:	74a8                	ld	a0,104(s1)
ffffffffc0208520:	c93d                	beqz	a0,ffffffffc0208596 <vfs_getcwd+0x9a>
ffffffffc0208522:	9b3ff0ef          	jal	ra,ffffffffc0207ed4 <vfs_get_devname>
ffffffffc0208526:	842a                	mv	s0,a0
ffffffffc0208528:	7d1020ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc020852c:	862a                	mv	a2,a0
ffffffffc020852e:	85a2                	mv	a1,s0
ffffffffc0208530:	4701                	li	a4,0
ffffffffc0208532:	4685                	li	a3,1
ffffffffc0208534:	854a                	mv	a0,s2
ffffffffc0208536:	f35fc0ef          	jal	ra,ffffffffc020546a <iobuf_move>
ffffffffc020853a:	842a                	mv	s0,a0
ffffffffc020853c:	c919                	beqz	a0,ffffffffc0208552 <vfs_getcwd+0x56>
ffffffffc020853e:	8526                	mv	a0,s1
ffffffffc0208540:	cccff0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc0208544:	70a2                	ld	ra,40(sp)
ffffffffc0208546:	8522                	mv	a0,s0
ffffffffc0208548:	7402                	ld	s0,32(sp)
ffffffffc020854a:	64e2                	ld	s1,24(sp)
ffffffffc020854c:	6942                	ld	s2,16(sp)
ffffffffc020854e:	6145                	addi	sp,sp,48
ffffffffc0208550:	8082                	ret
ffffffffc0208552:	03a00793          	li	a5,58
ffffffffc0208556:	4701                	li	a4,0
ffffffffc0208558:	4685                	li	a3,1
ffffffffc020855a:	4605                	li	a2,1
ffffffffc020855c:	00f10593          	addi	a1,sp,15
ffffffffc0208560:	854a                	mv	a0,s2
ffffffffc0208562:	00f107a3          	sb	a5,15(sp)
ffffffffc0208566:	f05fc0ef          	jal	ra,ffffffffc020546a <iobuf_move>
ffffffffc020856a:	842a                	mv	s0,a0
ffffffffc020856c:	f969                	bnez	a0,ffffffffc020853e <vfs_getcwd+0x42>
ffffffffc020856e:	78bc                	ld	a5,112(s1)
ffffffffc0208570:	c3b9                	beqz	a5,ffffffffc02085b6 <vfs_getcwd+0xba>
ffffffffc0208572:	7f9c                	ld	a5,56(a5)
ffffffffc0208574:	c3a9                	beqz	a5,ffffffffc02085b6 <vfs_getcwd+0xba>
ffffffffc0208576:	00006597          	auipc	a1,0x6
ffffffffc020857a:	4b258593          	addi	a1,a1,1202 # ffffffffc020ea28 <syscalls+0xe10>
ffffffffc020857e:	8526                	mv	a0,s1
ffffffffc0208580:	bd6ff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0208584:	78bc                	ld	a5,112(s1)
ffffffffc0208586:	85ca                	mv	a1,s2
ffffffffc0208588:	8526                	mv	a0,s1
ffffffffc020858a:	7f9c                	ld	a5,56(a5)
ffffffffc020858c:	9782                	jalr	a5
ffffffffc020858e:	842a                	mv	s0,a0
ffffffffc0208590:	b77d                	j	ffffffffc020853e <vfs_getcwd+0x42>
ffffffffc0208592:	5441                	li	s0,-16
ffffffffc0208594:	bf45                	j	ffffffffc0208544 <vfs_getcwd+0x48>
ffffffffc0208596:	00006697          	auipc	a3,0x6
ffffffffc020859a:	35a68693          	addi	a3,a3,858 # ffffffffc020e8f0 <syscalls+0xcd8>
ffffffffc020859e:	00003617          	auipc	a2,0x3
ffffffffc02085a2:	4e260613          	addi	a2,a2,1250 # ffffffffc020ba80 <commands+0x210>
ffffffffc02085a6:	06e00593          	li	a1,110
ffffffffc02085aa:	00006517          	auipc	a0,0x6
ffffffffc02085ae:	40650513          	addi	a0,a0,1030 # ffffffffc020e9b0 <syscalls+0xd98>
ffffffffc02085b2:	eedf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02085b6:	00006697          	auipc	a3,0x6
ffffffffc02085ba:	41a68693          	addi	a3,a3,1050 # ffffffffc020e9d0 <syscalls+0xdb8>
ffffffffc02085be:	00003617          	auipc	a2,0x3
ffffffffc02085c2:	4c260613          	addi	a2,a2,1218 # ffffffffc020ba80 <commands+0x210>
ffffffffc02085c6:	07800593          	li	a1,120
ffffffffc02085ca:	00006517          	auipc	a0,0x6
ffffffffc02085ce:	3e650513          	addi	a0,a0,998 # ffffffffc020e9b0 <syscalls+0xd98>
ffffffffc02085d2:	ecdf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02085d6 <dev_lookup>:
ffffffffc02085d6:	0005c783          	lbu	a5,0(a1)
ffffffffc02085da:	e385                	bnez	a5,ffffffffc02085fa <dev_lookup+0x24>
ffffffffc02085dc:	1101                	addi	sp,sp,-32
ffffffffc02085de:	e822                	sd	s0,16(sp)
ffffffffc02085e0:	e426                	sd	s1,8(sp)
ffffffffc02085e2:	ec06                	sd	ra,24(sp)
ffffffffc02085e4:	84aa                	mv	s1,a0
ffffffffc02085e6:	8432                	mv	s0,a2
ffffffffc02085e8:	b56ff0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc02085ec:	60e2                	ld	ra,24(sp)
ffffffffc02085ee:	e004                	sd	s1,0(s0)
ffffffffc02085f0:	6442                	ld	s0,16(sp)
ffffffffc02085f2:	64a2                	ld	s1,8(sp)
ffffffffc02085f4:	4501                	li	a0,0
ffffffffc02085f6:	6105                	addi	sp,sp,32
ffffffffc02085f8:	8082                	ret
ffffffffc02085fa:	5541                	li	a0,-16
ffffffffc02085fc:	8082                	ret

ffffffffc02085fe <dev_fstat>:
ffffffffc02085fe:	1101                	addi	sp,sp,-32
ffffffffc0208600:	e426                	sd	s1,8(sp)
ffffffffc0208602:	84ae                	mv	s1,a1
ffffffffc0208604:	e822                	sd	s0,16(sp)
ffffffffc0208606:	02000613          	li	a2,32
ffffffffc020860a:	842a                	mv	s0,a0
ffffffffc020860c:	4581                	li	a1,0
ffffffffc020860e:	8526                	mv	a0,s1
ffffffffc0208610:	ec06                	sd	ra,24(sp)
ffffffffc0208612:	789020ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0208616:	c429                	beqz	s0,ffffffffc0208660 <dev_fstat+0x62>
ffffffffc0208618:	783c                	ld	a5,112(s0)
ffffffffc020861a:	c3b9                	beqz	a5,ffffffffc0208660 <dev_fstat+0x62>
ffffffffc020861c:	6bbc                	ld	a5,80(a5)
ffffffffc020861e:	c3a9                	beqz	a5,ffffffffc0208660 <dev_fstat+0x62>
ffffffffc0208620:	00006597          	auipc	a1,0x6
ffffffffc0208624:	3a858593          	addi	a1,a1,936 # ffffffffc020e9c8 <syscalls+0xdb0>
ffffffffc0208628:	8522                	mv	a0,s0
ffffffffc020862a:	b2cff0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc020862e:	783c                	ld	a5,112(s0)
ffffffffc0208630:	85a6                	mv	a1,s1
ffffffffc0208632:	8522                	mv	a0,s0
ffffffffc0208634:	6bbc                	ld	a5,80(a5)
ffffffffc0208636:	9782                	jalr	a5
ffffffffc0208638:	ed19                	bnez	a0,ffffffffc0208656 <dev_fstat+0x58>
ffffffffc020863a:	4c38                	lw	a4,88(s0)
ffffffffc020863c:	6785                	lui	a5,0x1
ffffffffc020863e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208642:	02f71f63          	bne	a4,a5,ffffffffc0208680 <dev_fstat+0x82>
ffffffffc0208646:	6018                	ld	a4,0(s0)
ffffffffc0208648:	641c                	ld	a5,8(s0)
ffffffffc020864a:	4685                	li	a3,1
ffffffffc020864c:	e494                	sd	a3,8(s1)
ffffffffc020864e:	02e787b3          	mul	a5,a5,a4
ffffffffc0208652:	e898                	sd	a4,16(s1)
ffffffffc0208654:	ec9c                	sd	a5,24(s1)
ffffffffc0208656:	60e2                	ld	ra,24(sp)
ffffffffc0208658:	6442                	ld	s0,16(sp)
ffffffffc020865a:	64a2                	ld	s1,8(sp)
ffffffffc020865c:	6105                	addi	sp,sp,32
ffffffffc020865e:	8082                	ret
ffffffffc0208660:	00006697          	auipc	a3,0x6
ffffffffc0208664:	30068693          	addi	a3,a3,768 # ffffffffc020e960 <syscalls+0xd48>
ffffffffc0208668:	00003617          	auipc	a2,0x3
ffffffffc020866c:	41860613          	addi	a2,a2,1048 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208670:	04200593          	li	a1,66
ffffffffc0208674:	00006517          	auipc	a0,0x6
ffffffffc0208678:	3c450513          	addi	a0,a0,964 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc020867c:	e23f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208680:	00006697          	auipc	a3,0x6
ffffffffc0208684:	0a868693          	addi	a3,a3,168 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc0208688:	00003617          	auipc	a2,0x3
ffffffffc020868c:	3f860613          	addi	a2,a2,1016 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208690:	04500593          	li	a1,69
ffffffffc0208694:	00006517          	auipc	a0,0x6
ffffffffc0208698:	3a450513          	addi	a0,a0,932 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc020869c:	e03f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02086a0 <dev_ioctl>:
ffffffffc02086a0:	c909                	beqz	a0,ffffffffc02086b2 <dev_ioctl+0x12>
ffffffffc02086a2:	4d34                	lw	a3,88(a0)
ffffffffc02086a4:	6705                	lui	a4,0x1
ffffffffc02086a6:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086aa:	00e69463          	bne	a3,a4,ffffffffc02086b2 <dev_ioctl+0x12>
ffffffffc02086ae:	751c                	ld	a5,40(a0)
ffffffffc02086b0:	8782                	jr	a5
ffffffffc02086b2:	1141                	addi	sp,sp,-16
ffffffffc02086b4:	00006697          	auipc	a3,0x6
ffffffffc02086b8:	07468693          	addi	a3,a3,116 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc02086bc:	00003617          	auipc	a2,0x3
ffffffffc02086c0:	3c460613          	addi	a2,a2,964 # ffffffffc020ba80 <commands+0x210>
ffffffffc02086c4:	03500593          	li	a1,53
ffffffffc02086c8:	00006517          	auipc	a0,0x6
ffffffffc02086cc:	37050513          	addi	a0,a0,880 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc02086d0:	e406                	sd	ra,8(sp)
ffffffffc02086d2:	dcdf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02086d6 <dev_tryseek>:
ffffffffc02086d6:	c51d                	beqz	a0,ffffffffc0208704 <dev_tryseek+0x2e>
ffffffffc02086d8:	4d38                	lw	a4,88(a0)
ffffffffc02086da:	6785                	lui	a5,0x1
ffffffffc02086dc:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086e0:	02f71263          	bne	a4,a5,ffffffffc0208704 <dev_tryseek+0x2e>
ffffffffc02086e4:	611c                	ld	a5,0(a0)
ffffffffc02086e6:	cf89                	beqz	a5,ffffffffc0208700 <dev_tryseek+0x2a>
ffffffffc02086e8:	6518                	ld	a4,8(a0)
ffffffffc02086ea:	02e5f6b3          	remu	a3,a1,a4
ffffffffc02086ee:	ea89                	bnez	a3,ffffffffc0208700 <dev_tryseek+0x2a>
ffffffffc02086f0:	0005c863          	bltz	a1,ffffffffc0208700 <dev_tryseek+0x2a>
ffffffffc02086f4:	02e787b3          	mul	a5,a5,a4
ffffffffc02086f8:	00f5f463          	bgeu	a1,a5,ffffffffc0208700 <dev_tryseek+0x2a>
ffffffffc02086fc:	4501                	li	a0,0
ffffffffc02086fe:	8082                	ret
ffffffffc0208700:	5575                	li	a0,-3
ffffffffc0208702:	8082                	ret
ffffffffc0208704:	1141                	addi	sp,sp,-16
ffffffffc0208706:	00006697          	auipc	a3,0x6
ffffffffc020870a:	02268693          	addi	a3,a3,34 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc020870e:	00003617          	auipc	a2,0x3
ffffffffc0208712:	37260613          	addi	a2,a2,882 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208716:	05f00593          	li	a1,95
ffffffffc020871a:	00006517          	auipc	a0,0x6
ffffffffc020871e:	31e50513          	addi	a0,a0,798 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc0208722:	e406                	sd	ra,8(sp)
ffffffffc0208724:	d7bf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208728 <dev_gettype>:
ffffffffc0208728:	c10d                	beqz	a0,ffffffffc020874a <dev_gettype+0x22>
ffffffffc020872a:	4d38                	lw	a4,88(a0)
ffffffffc020872c:	6785                	lui	a5,0x1
ffffffffc020872e:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208732:	00f71c63          	bne	a4,a5,ffffffffc020874a <dev_gettype+0x22>
ffffffffc0208736:	6118                	ld	a4,0(a0)
ffffffffc0208738:	6795                	lui	a5,0x5
ffffffffc020873a:	c701                	beqz	a4,ffffffffc0208742 <dev_gettype+0x1a>
ffffffffc020873c:	c19c                	sw	a5,0(a1)
ffffffffc020873e:	4501                	li	a0,0
ffffffffc0208740:	8082                	ret
ffffffffc0208742:	6791                	lui	a5,0x4
ffffffffc0208744:	c19c                	sw	a5,0(a1)
ffffffffc0208746:	4501                	li	a0,0
ffffffffc0208748:	8082                	ret
ffffffffc020874a:	1141                	addi	sp,sp,-16
ffffffffc020874c:	00006697          	auipc	a3,0x6
ffffffffc0208750:	fdc68693          	addi	a3,a3,-36 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc0208754:	00003617          	auipc	a2,0x3
ffffffffc0208758:	32c60613          	addi	a2,a2,812 # ffffffffc020ba80 <commands+0x210>
ffffffffc020875c:	05300593          	li	a1,83
ffffffffc0208760:	00006517          	auipc	a0,0x6
ffffffffc0208764:	2d850513          	addi	a0,a0,728 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc0208768:	e406                	sd	ra,8(sp)
ffffffffc020876a:	d35f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020876e <dev_write>:
ffffffffc020876e:	c911                	beqz	a0,ffffffffc0208782 <dev_write+0x14>
ffffffffc0208770:	4d34                	lw	a3,88(a0)
ffffffffc0208772:	6705                	lui	a4,0x1
ffffffffc0208774:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208778:	00e69563          	bne	a3,a4,ffffffffc0208782 <dev_write+0x14>
ffffffffc020877c:	711c                	ld	a5,32(a0)
ffffffffc020877e:	4605                	li	a2,1
ffffffffc0208780:	8782                	jr	a5
ffffffffc0208782:	1141                	addi	sp,sp,-16
ffffffffc0208784:	00006697          	auipc	a3,0x6
ffffffffc0208788:	fa468693          	addi	a3,a3,-92 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc020878c:	00003617          	auipc	a2,0x3
ffffffffc0208790:	2f460613          	addi	a2,a2,756 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208794:	02c00593          	li	a1,44
ffffffffc0208798:	00006517          	auipc	a0,0x6
ffffffffc020879c:	2a050513          	addi	a0,a0,672 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc02087a0:	e406                	sd	ra,8(sp)
ffffffffc02087a2:	cfdf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02087a6 <dev_read>:
ffffffffc02087a6:	c911                	beqz	a0,ffffffffc02087ba <dev_read+0x14>
ffffffffc02087a8:	4d34                	lw	a3,88(a0)
ffffffffc02087aa:	6705                	lui	a4,0x1
ffffffffc02087ac:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02087b0:	00e69563          	bne	a3,a4,ffffffffc02087ba <dev_read+0x14>
ffffffffc02087b4:	711c                	ld	a5,32(a0)
ffffffffc02087b6:	4601                	li	a2,0
ffffffffc02087b8:	8782                	jr	a5
ffffffffc02087ba:	1141                	addi	sp,sp,-16
ffffffffc02087bc:	00006697          	auipc	a3,0x6
ffffffffc02087c0:	f6c68693          	addi	a3,a3,-148 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc02087c4:	00003617          	auipc	a2,0x3
ffffffffc02087c8:	2bc60613          	addi	a2,a2,700 # ffffffffc020ba80 <commands+0x210>
ffffffffc02087cc:	02300593          	li	a1,35
ffffffffc02087d0:	00006517          	auipc	a0,0x6
ffffffffc02087d4:	26850513          	addi	a0,a0,616 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc02087d8:	e406                	sd	ra,8(sp)
ffffffffc02087da:	cc5f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02087de <dev_close>:
ffffffffc02087de:	c909                	beqz	a0,ffffffffc02087f0 <dev_close+0x12>
ffffffffc02087e0:	4d34                	lw	a3,88(a0)
ffffffffc02087e2:	6705                	lui	a4,0x1
ffffffffc02087e4:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02087e8:	00e69463          	bne	a3,a4,ffffffffc02087f0 <dev_close+0x12>
ffffffffc02087ec:	6d1c                	ld	a5,24(a0)
ffffffffc02087ee:	8782                	jr	a5
ffffffffc02087f0:	1141                	addi	sp,sp,-16
ffffffffc02087f2:	00006697          	auipc	a3,0x6
ffffffffc02087f6:	f3668693          	addi	a3,a3,-202 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc02087fa:	00003617          	auipc	a2,0x3
ffffffffc02087fe:	28660613          	addi	a2,a2,646 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208802:	45e9                	li	a1,26
ffffffffc0208804:	00006517          	auipc	a0,0x6
ffffffffc0208808:	23450513          	addi	a0,a0,564 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc020880c:	e406                	sd	ra,8(sp)
ffffffffc020880e:	c91f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208812 <dev_open>:
ffffffffc0208812:	03c5f713          	andi	a4,a1,60
ffffffffc0208816:	eb11                	bnez	a4,ffffffffc020882a <dev_open+0x18>
ffffffffc0208818:	c919                	beqz	a0,ffffffffc020882e <dev_open+0x1c>
ffffffffc020881a:	4d34                	lw	a3,88(a0)
ffffffffc020881c:	6705                	lui	a4,0x1
ffffffffc020881e:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208822:	00e69663          	bne	a3,a4,ffffffffc020882e <dev_open+0x1c>
ffffffffc0208826:	691c                	ld	a5,16(a0)
ffffffffc0208828:	8782                	jr	a5
ffffffffc020882a:	5575                	li	a0,-3
ffffffffc020882c:	8082                	ret
ffffffffc020882e:	1141                	addi	sp,sp,-16
ffffffffc0208830:	00006697          	auipc	a3,0x6
ffffffffc0208834:	ef868693          	addi	a3,a3,-264 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc0208838:	00003617          	auipc	a2,0x3
ffffffffc020883c:	24860613          	addi	a2,a2,584 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208840:	45c5                	li	a1,17
ffffffffc0208842:	00006517          	auipc	a0,0x6
ffffffffc0208846:	1f650513          	addi	a0,a0,502 # ffffffffc020ea38 <syscalls+0xe20>
ffffffffc020884a:	e406                	sd	ra,8(sp)
ffffffffc020884c:	c53f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208850 <dev_init>:
ffffffffc0208850:	1141                	addi	sp,sp,-16
ffffffffc0208852:	e406                	sd	ra,8(sp)
ffffffffc0208854:	542000ef          	jal	ra,ffffffffc0208d96 <dev_init_stdin>
ffffffffc0208858:	65a000ef          	jal	ra,ffffffffc0208eb2 <dev_init_stdout>
ffffffffc020885c:	60a2                	ld	ra,8(sp)
ffffffffc020885e:	0141                	addi	sp,sp,16
ffffffffc0208860:	a439                	j	ffffffffc0208a6e <dev_init_disk0>

ffffffffc0208862 <dev_create_inode>:
ffffffffc0208862:	6505                	lui	a0,0x1
ffffffffc0208864:	1141                	addi	sp,sp,-16
ffffffffc0208866:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc020886a:	e022                	sd	s0,0(sp)
ffffffffc020886c:	e406                	sd	ra,8(sp)
ffffffffc020886e:	852ff0ef          	jal	ra,ffffffffc02078c0 <__alloc_inode>
ffffffffc0208872:	842a                	mv	s0,a0
ffffffffc0208874:	c901                	beqz	a0,ffffffffc0208884 <dev_create_inode+0x22>
ffffffffc0208876:	4601                	li	a2,0
ffffffffc0208878:	00006597          	auipc	a1,0x6
ffffffffc020887c:	1d858593          	addi	a1,a1,472 # ffffffffc020ea50 <dev_node_ops>
ffffffffc0208880:	85cff0ef          	jal	ra,ffffffffc02078dc <inode_init>
ffffffffc0208884:	60a2                	ld	ra,8(sp)
ffffffffc0208886:	8522                	mv	a0,s0
ffffffffc0208888:	6402                	ld	s0,0(sp)
ffffffffc020888a:	0141                	addi	sp,sp,16
ffffffffc020888c:	8082                	ret

ffffffffc020888e <disk0_open>:
ffffffffc020888e:	4501                	li	a0,0
ffffffffc0208890:	8082                	ret

ffffffffc0208892 <disk0_close>:
ffffffffc0208892:	4501                	li	a0,0
ffffffffc0208894:	8082                	ret

ffffffffc0208896 <disk0_ioctl>:
ffffffffc0208896:	5531                	li	a0,-20
ffffffffc0208898:	8082                	ret

ffffffffc020889a <disk0_io>:
ffffffffc020889a:	659c                	ld	a5,8(a1)
ffffffffc020889c:	7159                	addi	sp,sp,-112
ffffffffc020889e:	eca6                	sd	s1,88(sp)
ffffffffc02088a0:	f45e                	sd	s7,40(sp)
ffffffffc02088a2:	6d84                	ld	s1,24(a1)
ffffffffc02088a4:	6b85                	lui	s7,0x1
ffffffffc02088a6:	1bfd                	addi	s7,s7,-1
ffffffffc02088a8:	e4ce                	sd	s3,72(sp)
ffffffffc02088aa:	43f7d993          	srai	s3,a5,0x3f
ffffffffc02088ae:	0179f9b3          	and	s3,s3,s7
ffffffffc02088b2:	99be                	add	s3,s3,a5
ffffffffc02088b4:	8fc5                	or	a5,a5,s1
ffffffffc02088b6:	f486                	sd	ra,104(sp)
ffffffffc02088b8:	f0a2                	sd	s0,96(sp)
ffffffffc02088ba:	e8ca                	sd	s2,80(sp)
ffffffffc02088bc:	e0d2                	sd	s4,64(sp)
ffffffffc02088be:	fc56                	sd	s5,56(sp)
ffffffffc02088c0:	f85a                	sd	s6,48(sp)
ffffffffc02088c2:	f062                	sd	s8,32(sp)
ffffffffc02088c4:	ec66                	sd	s9,24(sp)
ffffffffc02088c6:	e86a                	sd	s10,16(sp)
ffffffffc02088c8:	0177f7b3          	and	a5,a5,s7
ffffffffc02088cc:	10079d63          	bnez	a5,ffffffffc02089e6 <disk0_io+0x14c>
ffffffffc02088d0:	40c9d993          	srai	s3,s3,0xc
ffffffffc02088d4:	00c4d713          	srli	a4,s1,0xc
ffffffffc02088d8:	2981                	sext.w	s3,s3
ffffffffc02088da:	2701                	sext.w	a4,a4
ffffffffc02088dc:	00e987bb          	addw	a5,s3,a4
ffffffffc02088e0:	6114                	ld	a3,0(a0)
ffffffffc02088e2:	1782                	slli	a5,a5,0x20
ffffffffc02088e4:	9381                	srli	a5,a5,0x20
ffffffffc02088e6:	10f6e063          	bltu	a3,a5,ffffffffc02089e6 <disk0_io+0x14c>
ffffffffc02088ea:	4501                	li	a0,0
ffffffffc02088ec:	ef19                	bnez	a4,ffffffffc020890a <disk0_io+0x70>
ffffffffc02088ee:	70a6                	ld	ra,104(sp)
ffffffffc02088f0:	7406                	ld	s0,96(sp)
ffffffffc02088f2:	64e6                	ld	s1,88(sp)
ffffffffc02088f4:	6946                	ld	s2,80(sp)
ffffffffc02088f6:	69a6                	ld	s3,72(sp)
ffffffffc02088f8:	6a06                	ld	s4,64(sp)
ffffffffc02088fa:	7ae2                	ld	s5,56(sp)
ffffffffc02088fc:	7b42                	ld	s6,48(sp)
ffffffffc02088fe:	7ba2                	ld	s7,40(sp)
ffffffffc0208900:	7c02                	ld	s8,32(sp)
ffffffffc0208902:	6ce2                	ld	s9,24(sp)
ffffffffc0208904:	6d42                	ld	s10,16(sp)
ffffffffc0208906:	6165                	addi	sp,sp,112
ffffffffc0208908:	8082                	ret
ffffffffc020890a:	0008d517          	auipc	a0,0x8d
ffffffffc020890e:	f3650513          	addi	a0,a0,-202 # ffffffffc0295840 <disk0_sem>
ffffffffc0208912:	8b2e                	mv	s6,a1
ffffffffc0208914:	8c32                	mv	s8,a2
ffffffffc0208916:	0008ea97          	auipc	s5,0x8e
ffffffffc020891a:	fe2a8a93          	addi	s5,s5,-30 # ffffffffc02968f8 <disk0_buffer>
ffffffffc020891e:	cc5fb0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc0208922:	6c91                	lui	s9,0x4
ffffffffc0208924:	e4b9                	bnez	s1,ffffffffc0208972 <disk0_io+0xd8>
ffffffffc0208926:	a845                	j	ffffffffc02089d6 <disk0_io+0x13c>
ffffffffc0208928:	00c4d413          	srli	s0,s1,0xc
ffffffffc020892c:	0034169b          	slliw	a3,s0,0x3
ffffffffc0208930:	00068d1b          	sext.w	s10,a3
ffffffffc0208934:	1682                	slli	a3,a3,0x20
ffffffffc0208936:	2401                	sext.w	s0,s0
ffffffffc0208938:	9281                	srli	a3,a3,0x20
ffffffffc020893a:	8926                	mv	s2,s1
ffffffffc020893c:	00399a1b          	slliw	s4,s3,0x3
ffffffffc0208940:	862e                	mv	a2,a1
ffffffffc0208942:	4509                	li	a0,2
ffffffffc0208944:	85d2                	mv	a1,s4
ffffffffc0208946:	9faf80ef          	jal	ra,ffffffffc0200b40 <ide_read_secs>
ffffffffc020894a:	e165                	bnez	a0,ffffffffc0208a2a <disk0_io+0x190>
ffffffffc020894c:	000ab583          	ld	a1,0(s5)
ffffffffc0208950:	0038                	addi	a4,sp,8
ffffffffc0208952:	4685                	li	a3,1
ffffffffc0208954:	864a                	mv	a2,s2
ffffffffc0208956:	855a                	mv	a0,s6
ffffffffc0208958:	b13fc0ef          	jal	ra,ffffffffc020546a <iobuf_move>
ffffffffc020895c:	67a2                	ld	a5,8(sp)
ffffffffc020895e:	09279663          	bne	a5,s2,ffffffffc02089ea <disk0_io+0x150>
ffffffffc0208962:	017977b3          	and	a5,s2,s7
ffffffffc0208966:	e3d1                	bnez	a5,ffffffffc02089ea <disk0_io+0x150>
ffffffffc0208968:	412484b3          	sub	s1,s1,s2
ffffffffc020896c:	013409bb          	addw	s3,s0,s3
ffffffffc0208970:	c0bd                	beqz	s1,ffffffffc02089d6 <disk0_io+0x13c>
ffffffffc0208972:	000ab583          	ld	a1,0(s5)
ffffffffc0208976:	000c1b63          	bnez	s8,ffffffffc020898c <disk0_io+0xf2>
ffffffffc020897a:	fb94e7e3          	bltu	s1,s9,ffffffffc0208928 <disk0_io+0x8e>
ffffffffc020897e:	02000693          	li	a3,32
ffffffffc0208982:	02000d13          	li	s10,32
ffffffffc0208986:	4411                	li	s0,4
ffffffffc0208988:	6911                	lui	s2,0x4
ffffffffc020898a:	bf4d                	j	ffffffffc020893c <disk0_io+0xa2>
ffffffffc020898c:	0038                	addi	a4,sp,8
ffffffffc020898e:	4681                	li	a3,0
ffffffffc0208990:	6611                	lui	a2,0x4
ffffffffc0208992:	855a                	mv	a0,s6
ffffffffc0208994:	ad7fc0ef          	jal	ra,ffffffffc020546a <iobuf_move>
ffffffffc0208998:	6422                	ld	s0,8(sp)
ffffffffc020899a:	c825                	beqz	s0,ffffffffc0208a0a <disk0_io+0x170>
ffffffffc020899c:	0684e763          	bltu	s1,s0,ffffffffc0208a0a <disk0_io+0x170>
ffffffffc02089a0:	017477b3          	and	a5,s0,s7
ffffffffc02089a4:	e3bd                	bnez	a5,ffffffffc0208a0a <disk0_io+0x170>
ffffffffc02089a6:	8031                	srli	s0,s0,0xc
ffffffffc02089a8:	0034179b          	slliw	a5,s0,0x3
ffffffffc02089ac:	000ab603          	ld	a2,0(s5)
ffffffffc02089b0:	0039991b          	slliw	s2,s3,0x3
ffffffffc02089b4:	02079693          	slli	a3,a5,0x20
ffffffffc02089b8:	9281                	srli	a3,a3,0x20
ffffffffc02089ba:	85ca                	mv	a1,s2
ffffffffc02089bc:	4509                	li	a0,2
ffffffffc02089be:	2401                	sext.w	s0,s0
ffffffffc02089c0:	00078a1b          	sext.w	s4,a5
ffffffffc02089c4:	a12f80ef          	jal	ra,ffffffffc0200bd6 <ide_write_secs>
ffffffffc02089c8:	e151                	bnez	a0,ffffffffc0208a4c <disk0_io+0x1b2>
ffffffffc02089ca:	6922                	ld	s2,8(sp)
ffffffffc02089cc:	013409bb          	addw	s3,s0,s3
ffffffffc02089d0:	412484b3          	sub	s1,s1,s2
ffffffffc02089d4:	fcd9                	bnez	s1,ffffffffc0208972 <disk0_io+0xd8>
ffffffffc02089d6:	0008d517          	auipc	a0,0x8d
ffffffffc02089da:	e6a50513          	addi	a0,a0,-406 # ffffffffc0295840 <disk0_sem>
ffffffffc02089de:	c01fb0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02089e2:	4501                	li	a0,0
ffffffffc02089e4:	b729                	j	ffffffffc02088ee <disk0_io+0x54>
ffffffffc02089e6:	5575                	li	a0,-3
ffffffffc02089e8:	b719                	j	ffffffffc02088ee <disk0_io+0x54>
ffffffffc02089ea:	00006697          	auipc	a3,0x6
ffffffffc02089ee:	1de68693          	addi	a3,a3,478 # ffffffffc020ebc8 <dev_node_ops+0x178>
ffffffffc02089f2:	00003617          	auipc	a2,0x3
ffffffffc02089f6:	08e60613          	addi	a2,a2,142 # ffffffffc020ba80 <commands+0x210>
ffffffffc02089fa:	06200593          	li	a1,98
ffffffffc02089fe:	00006517          	auipc	a0,0x6
ffffffffc0208a02:	11250513          	addi	a0,a0,274 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208a06:	a99f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a0a:	00006697          	auipc	a3,0x6
ffffffffc0208a0e:	0c668693          	addi	a3,a3,198 # ffffffffc020ead0 <dev_node_ops+0x80>
ffffffffc0208a12:	00003617          	auipc	a2,0x3
ffffffffc0208a16:	06e60613          	addi	a2,a2,110 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208a1a:	05700593          	li	a1,87
ffffffffc0208a1e:	00006517          	auipc	a0,0x6
ffffffffc0208a22:	0f250513          	addi	a0,a0,242 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208a26:	a79f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a2a:	88aa                	mv	a7,a0
ffffffffc0208a2c:	886a                	mv	a6,s10
ffffffffc0208a2e:	87a2                	mv	a5,s0
ffffffffc0208a30:	8752                	mv	a4,s4
ffffffffc0208a32:	86ce                	mv	a3,s3
ffffffffc0208a34:	00006617          	auipc	a2,0x6
ffffffffc0208a38:	14c60613          	addi	a2,a2,332 # ffffffffc020eb80 <dev_node_ops+0x130>
ffffffffc0208a3c:	02d00593          	li	a1,45
ffffffffc0208a40:	00006517          	auipc	a0,0x6
ffffffffc0208a44:	0d050513          	addi	a0,a0,208 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208a48:	a57f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208a4c:	88aa                	mv	a7,a0
ffffffffc0208a4e:	8852                	mv	a6,s4
ffffffffc0208a50:	87a2                	mv	a5,s0
ffffffffc0208a52:	874a                	mv	a4,s2
ffffffffc0208a54:	86ce                	mv	a3,s3
ffffffffc0208a56:	00006617          	auipc	a2,0x6
ffffffffc0208a5a:	0da60613          	addi	a2,a2,218 # ffffffffc020eb30 <dev_node_ops+0xe0>
ffffffffc0208a5e:	03700593          	li	a1,55
ffffffffc0208a62:	00006517          	auipc	a0,0x6
ffffffffc0208a66:	0ae50513          	addi	a0,a0,174 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208a6a:	a35f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208a6e <dev_init_disk0>:
ffffffffc0208a6e:	1101                	addi	sp,sp,-32
ffffffffc0208a70:	ec06                	sd	ra,24(sp)
ffffffffc0208a72:	e822                	sd	s0,16(sp)
ffffffffc0208a74:	e426                	sd	s1,8(sp)
ffffffffc0208a76:	dedff0ef          	jal	ra,ffffffffc0208862 <dev_create_inode>
ffffffffc0208a7a:	c541                	beqz	a0,ffffffffc0208b02 <dev_init_disk0+0x94>
ffffffffc0208a7c:	4d38                	lw	a4,88(a0)
ffffffffc0208a7e:	6485                	lui	s1,0x1
ffffffffc0208a80:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208a84:	842a                	mv	s0,a0
ffffffffc0208a86:	0cf71f63          	bne	a4,a5,ffffffffc0208b64 <dev_init_disk0+0xf6>
ffffffffc0208a8a:	4509                	li	a0,2
ffffffffc0208a8c:	868f80ef          	jal	ra,ffffffffc0200af4 <ide_device_valid>
ffffffffc0208a90:	cd55                	beqz	a0,ffffffffc0208b4c <dev_init_disk0+0xde>
ffffffffc0208a92:	4509                	li	a0,2
ffffffffc0208a94:	884f80ef          	jal	ra,ffffffffc0200b18 <ide_device_size>
ffffffffc0208a98:	00355793          	srli	a5,a0,0x3
ffffffffc0208a9c:	e01c                	sd	a5,0(s0)
ffffffffc0208a9e:	00000797          	auipc	a5,0x0
ffffffffc0208aa2:	df078793          	addi	a5,a5,-528 # ffffffffc020888e <disk0_open>
ffffffffc0208aa6:	e81c                	sd	a5,16(s0)
ffffffffc0208aa8:	00000797          	auipc	a5,0x0
ffffffffc0208aac:	dea78793          	addi	a5,a5,-534 # ffffffffc0208892 <disk0_close>
ffffffffc0208ab0:	ec1c                	sd	a5,24(s0)
ffffffffc0208ab2:	00000797          	auipc	a5,0x0
ffffffffc0208ab6:	de878793          	addi	a5,a5,-536 # ffffffffc020889a <disk0_io>
ffffffffc0208aba:	f01c                	sd	a5,32(s0)
ffffffffc0208abc:	00000797          	auipc	a5,0x0
ffffffffc0208ac0:	dda78793          	addi	a5,a5,-550 # ffffffffc0208896 <disk0_ioctl>
ffffffffc0208ac4:	f41c                	sd	a5,40(s0)
ffffffffc0208ac6:	4585                	li	a1,1
ffffffffc0208ac8:	0008d517          	auipc	a0,0x8d
ffffffffc0208acc:	d7850513          	addi	a0,a0,-648 # ffffffffc0295840 <disk0_sem>
ffffffffc0208ad0:	e404                	sd	s1,8(s0)
ffffffffc0208ad2:	b07fb0ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc0208ad6:	6511                	lui	a0,0x4
ffffffffc0208ad8:	cb6f90ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208adc:	0008e797          	auipc	a5,0x8e
ffffffffc0208ae0:	e0a7be23          	sd	a0,-484(a5) # ffffffffc02968f8 <disk0_buffer>
ffffffffc0208ae4:	c921                	beqz	a0,ffffffffc0208b34 <dev_init_disk0+0xc6>
ffffffffc0208ae6:	4605                	li	a2,1
ffffffffc0208ae8:	85a2                	mv	a1,s0
ffffffffc0208aea:	00006517          	auipc	a0,0x6
ffffffffc0208aee:	16e50513          	addi	a0,a0,366 # ffffffffc020ec58 <dev_node_ops+0x208>
ffffffffc0208af2:	c2cff0ef          	jal	ra,ffffffffc0207f1e <vfs_add_dev>
ffffffffc0208af6:	e115                	bnez	a0,ffffffffc0208b1a <dev_init_disk0+0xac>
ffffffffc0208af8:	60e2                	ld	ra,24(sp)
ffffffffc0208afa:	6442                	ld	s0,16(sp)
ffffffffc0208afc:	64a2                	ld	s1,8(sp)
ffffffffc0208afe:	6105                	addi	sp,sp,32
ffffffffc0208b00:	8082                	ret
ffffffffc0208b02:	00006617          	auipc	a2,0x6
ffffffffc0208b06:	0f660613          	addi	a2,a2,246 # ffffffffc020ebf8 <dev_node_ops+0x1a8>
ffffffffc0208b0a:	08700593          	li	a1,135
ffffffffc0208b0e:	00006517          	auipc	a0,0x6
ffffffffc0208b12:	00250513          	addi	a0,a0,2 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208b16:	989f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208b1a:	86aa                	mv	a3,a0
ffffffffc0208b1c:	00006617          	auipc	a2,0x6
ffffffffc0208b20:	14460613          	addi	a2,a2,324 # ffffffffc020ec60 <dev_node_ops+0x210>
ffffffffc0208b24:	08d00593          	li	a1,141
ffffffffc0208b28:	00006517          	auipc	a0,0x6
ffffffffc0208b2c:	fe850513          	addi	a0,a0,-24 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208b30:	96ff70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208b34:	00006617          	auipc	a2,0x6
ffffffffc0208b38:	10460613          	addi	a2,a2,260 # ffffffffc020ec38 <dev_node_ops+0x1e8>
ffffffffc0208b3c:	07f00593          	li	a1,127
ffffffffc0208b40:	00006517          	auipc	a0,0x6
ffffffffc0208b44:	fd050513          	addi	a0,a0,-48 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208b48:	957f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208b4c:	00006617          	auipc	a2,0x6
ffffffffc0208b50:	0cc60613          	addi	a2,a2,204 # ffffffffc020ec18 <dev_node_ops+0x1c8>
ffffffffc0208b54:	07300593          	li	a1,115
ffffffffc0208b58:	00006517          	auipc	a0,0x6
ffffffffc0208b5c:	fb850513          	addi	a0,a0,-72 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208b60:	93ff70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208b64:	00006697          	auipc	a3,0x6
ffffffffc0208b68:	bc468693          	addi	a3,a3,-1084 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc0208b6c:	00003617          	auipc	a2,0x3
ffffffffc0208b70:	f1460613          	addi	a2,a2,-236 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208b74:	08900593          	li	a1,137
ffffffffc0208b78:	00006517          	auipc	a0,0x6
ffffffffc0208b7c:	f9850513          	addi	a0,a0,-104 # ffffffffc020eb10 <dev_node_ops+0xc0>
ffffffffc0208b80:	91ff70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208b84 <stdin_open>:
ffffffffc0208b84:	4501                	li	a0,0
ffffffffc0208b86:	e191                	bnez	a1,ffffffffc0208b8a <stdin_open+0x6>
ffffffffc0208b88:	8082                	ret
ffffffffc0208b8a:	5575                	li	a0,-3
ffffffffc0208b8c:	8082                	ret

ffffffffc0208b8e <stdin_close>:
ffffffffc0208b8e:	4501                	li	a0,0
ffffffffc0208b90:	8082                	ret

ffffffffc0208b92 <stdin_ioctl>:
ffffffffc0208b92:	5575                	li	a0,-3
ffffffffc0208b94:	8082                	ret

ffffffffc0208b96 <stdin_io>:
ffffffffc0208b96:	7135                	addi	sp,sp,-160
ffffffffc0208b98:	ed06                	sd	ra,152(sp)
ffffffffc0208b9a:	e922                	sd	s0,144(sp)
ffffffffc0208b9c:	e526                	sd	s1,136(sp)
ffffffffc0208b9e:	e14a                	sd	s2,128(sp)
ffffffffc0208ba0:	fcce                	sd	s3,120(sp)
ffffffffc0208ba2:	f8d2                	sd	s4,112(sp)
ffffffffc0208ba4:	f4d6                	sd	s5,104(sp)
ffffffffc0208ba6:	f0da                	sd	s6,96(sp)
ffffffffc0208ba8:	ecde                	sd	s7,88(sp)
ffffffffc0208baa:	e8e2                	sd	s8,80(sp)
ffffffffc0208bac:	e4e6                	sd	s9,72(sp)
ffffffffc0208bae:	e0ea                	sd	s10,64(sp)
ffffffffc0208bb0:	fc6e                	sd	s11,56(sp)
ffffffffc0208bb2:	14061163          	bnez	a2,ffffffffc0208cf4 <stdin_io+0x15e>
ffffffffc0208bb6:	0005bd83          	ld	s11,0(a1)
ffffffffc0208bba:	0185bd03          	ld	s10,24(a1)
ffffffffc0208bbe:	8b2e                	mv	s6,a1
ffffffffc0208bc0:	100027f3          	csrr	a5,sstatus
ffffffffc0208bc4:	8b89                	andi	a5,a5,2
ffffffffc0208bc6:	10079e63          	bnez	a5,ffffffffc0208ce2 <stdin_io+0x14c>
ffffffffc0208bca:	4401                	li	s0,0
ffffffffc0208bcc:	100d0963          	beqz	s10,ffffffffc0208cde <stdin_io+0x148>
ffffffffc0208bd0:	0008e997          	auipc	s3,0x8e
ffffffffc0208bd4:	d3098993          	addi	s3,s3,-720 # ffffffffc0296900 <p_rpos>
ffffffffc0208bd8:	0009b783          	ld	a5,0(s3)
ffffffffc0208bdc:	800004b7          	lui	s1,0x80000
ffffffffc0208be0:	6c85                	lui	s9,0x1
ffffffffc0208be2:	4a81                	li	s5,0
ffffffffc0208be4:	0008ea17          	auipc	s4,0x8e
ffffffffc0208be8:	d24a0a13          	addi	s4,s4,-732 # ffffffffc0296908 <p_wpos>
ffffffffc0208bec:	0491                	addi	s1,s1,4
ffffffffc0208bee:	0008d917          	auipc	s2,0x8d
ffffffffc0208bf2:	c6a90913          	addi	s2,s2,-918 # ffffffffc0295858 <__wait_queue>
ffffffffc0208bf6:	1cfd                	addi	s9,s9,-1
ffffffffc0208bf8:	000a3703          	ld	a4,0(s4)
ffffffffc0208bfc:	000a8c1b          	sext.w	s8,s5
ffffffffc0208c00:	8be2                	mv	s7,s8
ffffffffc0208c02:	02e7d763          	bge	a5,a4,ffffffffc0208c30 <stdin_io+0x9a>
ffffffffc0208c06:	a859                	j	ffffffffc0208c9c <stdin_io+0x106>
ffffffffc0208c08:	815fe0ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc0208c0c:	100027f3          	csrr	a5,sstatus
ffffffffc0208c10:	8b89                	andi	a5,a5,2
ffffffffc0208c12:	4401                	li	s0,0
ffffffffc0208c14:	ef8d                	bnez	a5,ffffffffc0208c4e <stdin_io+0xb8>
ffffffffc0208c16:	0028                	addi	a0,sp,8
ffffffffc0208c18:	a5dfb0ef          	jal	ra,ffffffffc0204674 <wait_in_queue>
ffffffffc0208c1c:	e121                	bnez	a0,ffffffffc0208c5c <stdin_io+0xc6>
ffffffffc0208c1e:	47c2                	lw	a5,16(sp)
ffffffffc0208c20:	04979563          	bne	a5,s1,ffffffffc0208c6a <stdin_io+0xd4>
ffffffffc0208c24:	0009b783          	ld	a5,0(s3)
ffffffffc0208c28:	000a3703          	ld	a4,0(s4)
ffffffffc0208c2c:	06e7c863          	blt	a5,a4,ffffffffc0208c9c <stdin_io+0x106>
ffffffffc0208c30:	8626                	mv	a2,s1
ffffffffc0208c32:	002c                	addi	a1,sp,8
ffffffffc0208c34:	854a                	mv	a0,s2
ffffffffc0208c36:	b69fb0ef          	jal	ra,ffffffffc020479e <wait_current_set>
ffffffffc0208c3a:	d479                	beqz	s0,ffffffffc0208c08 <stdin_io+0x72>
ffffffffc0208c3c:	830f80ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208c40:	fdcfe0ef          	jal	ra,ffffffffc020741c <schedule>
ffffffffc0208c44:	100027f3          	csrr	a5,sstatus
ffffffffc0208c48:	8b89                	andi	a5,a5,2
ffffffffc0208c4a:	4401                	li	s0,0
ffffffffc0208c4c:	d7e9                	beqz	a5,ffffffffc0208c16 <stdin_io+0x80>
ffffffffc0208c4e:	824f80ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208c52:	0028                	addi	a0,sp,8
ffffffffc0208c54:	4405                	li	s0,1
ffffffffc0208c56:	a1ffb0ef          	jal	ra,ffffffffc0204674 <wait_in_queue>
ffffffffc0208c5a:	d171                	beqz	a0,ffffffffc0208c1e <stdin_io+0x88>
ffffffffc0208c5c:	002c                	addi	a1,sp,8
ffffffffc0208c5e:	854a                	mv	a0,s2
ffffffffc0208c60:	9bbfb0ef          	jal	ra,ffffffffc020461a <wait_queue_del>
ffffffffc0208c64:	47c2                	lw	a5,16(sp)
ffffffffc0208c66:	fa978fe3          	beq	a5,s1,ffffffffc0208c24 <stdin_io+0x8e>
ffffffffc0208c6a:	e435                	bnez	s0,ffffffffc0208cd6 <stdin_io+0x140>
ffffffffc0208c6c:	060b8963          	beqz	s7,ffffffffc0208cde <stdin_io+0x148>
ffffffffc0208c70:	018b3783          	ld	a5,24(s6)
ffffffffc0208c74:	41578ab3          	sub	s5,a5,s5
ffffffffc0208c78:	015b3c23          	sd	s5,24(s6)
ffffffffc0208c7c:	60ea                	ld	ra,152(sp)
ffffffffc0208c7e:	644a                	ld	s0,144(sp)
ffffffffc0208c80:	64aa                	ld	s1,136(sp)
ffffffffc0208c82:	690a                	ld	s2,128(sp)
ffffffffc0208c84:	79e6                	ld	s3,120(sp)
ffffffffc0208c86:	7a46                	ld	s4,112(sp)
ffffffffc0208c88:	7aa6                	ld	s5,104(sp)
ffffffffc0208c8a:	7b06                	ld	s6,96(sp)
ffffffffc0208c8c:	6c46                	ld	s8,80(sp)
ffffffffc0208c8e:	6ca6                	ld	s9,72(sp)
ffffffffc0208c90:	6d06                	ld	s10,64(sp)
ffffffffc0208c92:	7de2                	ld	s11,56(sp)
ffffffffc0208c94:	855e                	mv	a0,s7
ffffffffc0208c96:	6be6                	ld	s7,88(sp)
ffffffffc0208c98:	610d                	addi	sp,sp,160
ffffffffc0208c9a:	8082                	ret
ffffffffc0208c9c:	43f7d713          	srai	a4,a5,0x3f
ffffffffc0208ca0:	03475693          	srli	a3,a4,0x34
ffffffffc0208ca4:	00d78733          	add	a4,a5,a3
ffffffffc0208ca8:	01977733          	and	a4,a4,s9
ffffffffc0208cac:	8f15                	sub	a4,a4,a3
ffffffffc0208cae:	0008d697          	auipc	a3,0x8d
ffffffffc0208cb2:	bba68693          	addi	a3,a3,-1094 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208cb6:	9736                	add	a4,a4,a3
ffffffffc0208cb8:	00074683          	lbu	a3,0(a4)
ffffffffc0208cbc:	0785                	addi	a5,a5,1
ffffffffc0208cbe:	015d8733          	add	a4,s11,s5
ffffffffc0208cc2:	00d70023          	sb	a3,0(a4)
ffffffffc0208cc6:	00f9b023          	sd	a5,0(s3)
ffffffffc0208cca:	0a85                	addi	s5,s5,1
ffffffffc0208ccc:	001c0b9b          	addiw	s7,s8,1
ffffffffc0208cd0:	f3aae4e3          	bltu	s5,s10,ffffffffc0208bf8 <stdin_io+0x62>
ffffffffc0208cd4:	dc51                	beqz	s0,ffffffffc0208c70 <stdin_io+0xda>
ffffffffc0208cd6:	f97f70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208cda:	f80b9be3          	bnez	s7,ffffffffc0208c70 <stdin_io+0xda>
ffffffffc0208cde:	4b81                	li	s7,0
ffffffffc0208ce0:	bf71                	j	ffffffffc0208c7c <stdin_io+0xe6>
ffffffffc0208ce2:	f91f70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208ce6:	4405                	li	s0,1
ffffffffc0208ce8:	ee0d14e3          	bnez	s10,ffffffffc0208bd0 <stdin_io+0x3a>
ffffffffc0208cec:	f81f70ef          	jal	ra,ffffffffc0200c6c <intr_enable>
ffffffffc0208cf0:	4b81                	li	s7,0
ffffffffc0208cf2:	b769                	j	ffffffffc0208c7c <stdin_io+0xe6>
ffffffffc0208cf4:	5bf5                	li	s7,-3
ffffffffc0208cf6:	b759                	j	ffffffffc0208c7c <stdin_io+0xe6>

ffffffffc0208cf8 <dev_stdin_write>:
ffffffffc0208cf8:	e111                	bnez	a0,ffffffffc0208cfc <dev_stdin_write+0x4>
ffffffffc0208cfa:	8082                	ret
ffffffffc0208cfc:	1101                	addi	sp,sp,-32
ffffffffc0208cfe:	e822                	sd	s0,16(sp)
ffffffffc0208d00:	ec06                	sd	ra,24(sp)
ffffffffc0208d02:	e426                	sd	s1,8(sp)
ffffffffc0208d04:	842a                	mv	s0,a0
ffffffffc0208d06:	100027f3          	csrr	a5,sstatus
ffffffffc0208d0a:	8b89                	andi	a5,a5,2
ffffffffc0208d0c:	4481                	li	s1,0
ffffffffc0208d0e:	e3c1                	bnez	a5,ffffffffc0208d8e <dev_stdin_write+0x96>
ffffffffc0208d10:	0008e597          	auipc	a1,0x8e
ffffffffc0208d14:	bf858593          	addi	a1,a1,-1032 # ffffffffc0296908 <p_wpos>
ffffffffc0208d18:	6198                	ld	a4,0(a1)
ffffffffc0208d1a:	6605                	lui	a2,0x1
ffffffffc0208d1c:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208d20:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208d24:	92d1                	srli	a3,a3,0x34
ffffffffc0208d26:	00d707b3          	add	a5,a4,a3
ffffffffc0208d2a:	8fe9                	and	a5,a5,a0
ffffffffc0208d2c:	8f95                	sub	a5,a5,a3
ffffffffc0208d2e:	0008d697          	auipc	a3,0x8d
ffffffffc0208d32:	b3a68693          	addi	a3,a3,-1222 # ffffffffc0295868 <stdin_buffer>
ffffffffc0208d36:	97b6                	add	a5,a5,a3
ffffffffc0208d38:	00878023          	sb	s0,0(a5)
ffffffffc0208d3c:	0008e797          	auipc	a5,0x8e
ffffffffc0208d40:	bc47b783          	ld	a5,-1084(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208d44:	40f707b3          	sub	a5,a4,a5
ffffffffc0208d48:	00c7d463          	bge	a5,a2,ffffffffc0208d50 <dev_stdin_write+0x58>
ffffffffc0208d4c:	0705                	addi	a4,a4,1
ffffffffc0208d4e:	e198                	sd	a4,0(a1)
ffffffffc0208d50:	0008d517          	auipc	a0,0x8d
ffffffffc0208d54:	b0850513          	addi	a0,a0,-1272 # ffffffffc0295858 <__wait_queue>
ffffffffc0208d58:	911fb0ef          	jal	ra,ffffffffc0204668 <wait_queue_empty>
ffffffffc0208d5c:	cd09                	beqz	a0,ffffffffc0208d76 <dev_stdin_write+0x7e>
ffffffffc0208d5e:	e491                	bnez	s1,ffffffffc0208d6a <dev_stdin_write+0x72>
ffffffffc0208d60:	60e2                	ld	ra,24(sp)
ffffffffc0208d62:	6442                	ld	s0,16(sp)
ffffffffc0208d64:	64a2                	ld	s1,8(sp)
ffffffffc0208d66:	6105                	addi	sp,sp,32
ffffffffc0208d68:	8082                	ret
ffffffffc0208d6a:	6442                	ld	s0,16(sp)
ffffffffc0208d6c:	60e2                	ld	ra,24(sp)
ffffffffc0208d6e:	64a2                	ld	s1,8(sp)
ffffffffc0208d70:	6105                	addi	sp,sp,32
ffffffffc0208d72:	efbf706f          	j	ffffffffc0200c6c <intr_enable>
ffffffffc0208d76:	800005b7          	lui	a1,0x80000
ffffffffc0208d7a:	4605                	li	a2,1
ffffffffc0208d7c:	0591                	addi	a1,a1,4
ffffffffc0208d7e:	0008d517          	auipc	a0,0x8d
ffffffffc0208d82:	ada50513          	addi	a0,a0,-1318 # ffffffffc0295858 <__wait_queue>
ffffffffc0208d86:	94bfb0ef          	jal	ra,ffffffffc02046d0 <wakeup_queue>
ffffffffc0208d8a:	d8f9                	beqz	s1,ffffffffc0208d60 <dev_stdin_write+0x68>
ffffffffc0208d8c:	bff9                	j	ffffffffc0208d6a <dev_stdin_write+0x72>
ffffffffc0208d8e:	ee5f70ef          	jal	ra,ffffffffc0200c72 <intr_disable>
ffffffffc0208d92:	4485                	li	s1,1
ffffffffc0208d94:	bfb5                	j	ffffffffc0208d10 <dev_stdin_write+0x18>

ffffffffc0208d96 <dev_init_stdin>:
ffffffffc0208d96:	1141                	addi	sp,sp,-16
ffffffffc0208d98:	e406                	sd	ra,8(sp)
ffffffffc0208d9a:	e022                	sd	s0,0(sp)
ffffffffc0208d9c:	ac7ff0ef          	jal	ra,ffffffffc0208862 <dev_create_inode>
ffffffffc0208da0:	c93d                	beqz	a0,ffffffffc0208e16 <dev_init_stdin+0x80>
ffffffffc0208da2:	4d38                	lw	a4,88(a0)
ffffffffc0208da4:	6785                	lui	a5,0x1
ffffffffc0208da6:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208daa:	842a                	mv	s0,a0
ffffffffc0208dac:	08f71e63          	bne	a4,a5,ffffffffc0208e48 <dev_init_stdin+0xb2>
ffffffffc0208db0:	4785                	li	a5,1
ffffffffc0208db2:	e41c                	sd	a5,8(s0)
ffffffffc0208db4:	00000797          	auipc	a5,0x0
ffffffffc0208db8:	dd078793          	addi	a5,a5,-560 # ffffffffc0208b84 <stdin_open>
ffffffffc0208dbc:	e81c                	sd	a5,16(s0)
ffffffffc0208dbe:	00000797          	auipc	a5,0x0
ffffffffc0208dc2:	dd078793          	addi	a5,a5,-560 # ffffffffc0208b8e <stdin_close>
ffffffffc0208dc6:	ec1c                	sd	a5,24(s0)
ffffffffc0208dc8:	00000797          	auipc	a5,0x0
ffffffffc0208dcc:	dce78793          	addi	a5,a5,-562 # ffffffffc0208b96 <stdin_io>
ffffffffc0208dd0:	f01c                	sd	a5,32(s0)
ffffffffc0208dd2:	00000797          	auipc	a5,0x0
ffffffffc0208dd6:	dc078793          	addi	a5,a5,-576 # ffffffffc0208b92 <stdin_ioctl>
ffffffffc0208dda:	f41c                	sd	a5,40(s0)
ffffffffc0208ddc:	0008d517          	auipc	a0,0x8d
ffffffffc0208de0:	a7c50513          	addi	a0,a0,-1412 # ffffffffc0295858 <__wait_queue>
ffffffffc0208de4:	00043023          	sd	zero,0(s0)
ffffffffc0208de8:	0008e797          	auipc	a5,0x8e
ffffffffc0208dec:	b207b023          	sd	zero,-1248(a5) # ffffffffc0296908 <p_wpos>
ffffffffc0208df0:	0008e797          	auipc	a5,0x8e
ffffffffc0208df4:	b007b823          	sd	zero,-1264(a5) # ffffffffc0296900 <p_rpos>
ffffffffc0208df8:	81dfb0ef          	jal	ra,ffffffffc0204614 <wait_queue_init>
ffffffffc0208dfc:	4601                	li	a2,0
ffffffffc0208dfe:	85a2                	mv	a1,s0
ffffffffc0208e00:	00006517          	auipc	a0,0x6
ffffffffc0208e04:	ec050513          	addi	a0,a0,-320 # ffffffffc020ecc0 <dev_node_ops+0x270>
ffffffffc0208e08:	916ff0ef          	jal	ra,ffffffffc0207f1e <vfs_add_dev>
ffffffffc0208e0c:	e10d                	bnez	a0,ffffffffc0208e2e <dev_init_stdin+0x98>
ffffffffc0208e0e:	60a2                	ld	ra,8(sp)
ffffffffc0208e10:	6402                	ld	s0,0(sp)
ffffffffc0208e12:	0141                	addi	sp,sp,16
ffffffffc0208e14:	8082                	ret
ffffffffc0208e16:	00006617          	auipc	a2,0x6
ffffffffc0208e1a:	e6a60613          	addi	a2,a2,-406 # ffffffffc020ec80 <dev_node_ops+0x230>
ffffffffc0208e1e:	07500593          	li	a1,117
ffffffffc0208e22:	00006517          	auipc	a0,0x6
ffffffffc0208e26:	e7e50513          	addi	a0,a0,-386 # ffffffffc020eca0 <dev_node_ops+0x250>
ffffffffc0208e2a:	e74f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208e2e:	86aa                	mv	a3,a0
ffffffffc0208e30:	00006617          	auipc	a2,0x6
ffffffffc0208e34:	e9860613          	addi	a2,a2,-360 # ffffffffc020ecc8 <dev_node_ops+0x278>
ffffffffc0208e38:	07b00593          	li	a1,123
ffffffffc0208e3c:	00006517          	auipc	a0,0x6
ffffffffc0208e40:	e6450513          	addi	a0,a0,-412 # ffffffffc020eca0 <dev_node_ops+0x250>
ffffffffc0208e44:	e5af70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208e48:	00006697          	auipc	a3,0x6
ffffffffc0208e4c:	8e068693          	addi	a3,a3,-1824 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc0208e50:	00003617          	auipc	a2,0x3
ffffffffc0208e54:	c3060613          	addi	a2,a2,-976 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208e58:	07700593          	li	a1,119
ffffffffc0208e5c:	00006517          	auipc	a0,0x6
ffffffffc0208e60:	e4450513          	addi	a0,a0,-444 # ffffffffc020eca0 <dev_node_ops+0x250>
ffffffffc0208e64:	e3af70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208e68 <stdout_open>:
ffffffffc0208e68:	4785                	li	a5,1
ffffffffc0208e6a:	4501                	li	a0,0
ffffffffc0208e6c:	00f59363          	bne	a1,a5,ffffffffc0208e72 <stdout_open+0xa>
ffffffffc0208e70:	8082                	ret
ffffffffc0208e72:	5575                	li	a0,-3
ffffffffc0208e74:	8082                	ret

ffffffffc0208e76 <stdout_close>:
ffffffffc0208e76:	4501                	li	a0,0
ffffffffc0208e78:	8082                	ret

ffffffffc0208e7a <stdout_ioctl>:
ffffffffc0208e7a:	5575                	li	a0,-3
ffffffffc0208e7c:	8082                	ret

ffffffffc0208e7e <stdout_io>:
ffffffffc0208e7e:	ca05                	beqz	a2,ffffffffc0208eae <stdout_io+0x30>
ffffffffc0208e80:	6d9c                	ld	a5,24(a1)
ffffffffc0208e82:	1101                	addi	sp,sp,-32
ffffffffc0208e84:	e822                	sd	s0,16(sp)
ffffffffc0208e86:	e426                	sd	s1,8(sp)
ffffffffc0208e88:	ec06                	sd	ra,24(sp)
ffffffffc0208e8a:	6180                	ld	s0,0(a1)
ffffffffc0208e8c:	84ae                	mv	s1,a1
ffffffffc0208e8e:	cb91                	beqz	a5,ffffffffc0208ea2 <stdout_io+0x24>
ffffffffc0208e90:	00044503          	lbu	a0,0(s0)
ffffffffc0208e94:	0405                	addi	s0,s0,1
ffffffffc0208e96:	b4cf70ef          	jal	ra,ffffffffc02001e2 <cputchar>
ffffffffc0208e9a:	6c9c                	ld	a5,24(s1)
ffffffffc0208e9c:	17fd                	addi	a5,a5,-1
ffffffffc0208e9e:	ec9c                	sd	a5,24(s1)
ffffffffc0208ea0:	fbe5                	bnez	a5,ffffffffc0208e90 <stdout_io+0x12>
ffffffffc0208ea2:	60e2                	ld	ra,24(sp)
ffffffffc0208ea4:	6442                	ld	s0,16(sp)
ffffffffc0208ea6:	64a2                	ld	s1,8(sp)
ffffffffc0208ea8:	4501                	li	a0,0
ffffffffc0208eaa:	6105                	addi	sp,sp,32
ffffffffc0208eac:	8082                	ret
ffffffffc0208eae:	5575                	li	a0,-3
ffffffffc0208eb0:	8082                	ret

ffffffffc0208eb2 <dev_init_stdout>:
ffffffffc0208eb2:	1141                	addi	sp,sp,-16
ffffffffc0208eb4:	e406                	sd	ra,8(sp)
ffffffffc0208eb6:	9adff0ef          	jal	ra,ffffffffc0208862 <dev_create_inode>
ffffffffc0208eba:	c939                	beqz	a0,ffffffffc0208f10 <dev_init_stdout+0x5e>
ffffffffc0208ebc:	4d38                	lw	a4,88(a0)
ffffffffc0208ebe:	6785                	lui	a5,0x1
ffffffffc0208ec0:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208ec4:	85aa                	mv	a1,a0
ffffffffc0208ec6:	06f71e63          	bne	a4,a5,ffffffffc0208f42 <dev_init_stdout+0x90>
ffffffffc0208eca:	4785                	li	a5,1
ffffffffc0208ecc:	e51c                	sd	a5,8(a0)
ffffffffc0208ece:	00000797          	auipc	a5,0x0
ffffffffc0208ed2:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208e68 <stdout_open>
ffffffffc0208ed6:	e91c                	sd	a5,16(a0)
ffffffffc0208ed8:	00000797          	auipc	a5,0x0
ffffffffc0208edc:	f9e78793          	addi	a5,a5,-98 # ffffffffc0208e76 <stdout_close>
ffffffffc0208ee0:	ed1c                	sd	a5,24(a0)
ffffffffc0208ee2:	00000797          	auipc	a5,0x0
ffffffffc0208ee6:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208e7e <stdout_io>
ffffffffc0208eea:	f11c                	sd	a5,32(a0)
ffffffffc0208eec:	00000797          	auipc	a5,0x0
ffffffffc0208ef0:	f8e78793          	addi	a5,a5,-114 # ffffffffc0208e7a <stdout_ioctl>
ffffffffc0208ef4:	00053023          	sd	zero,0(a0)
ffffffffc0208ef8:	f51c                	sd	a5,40(a0)
ffffffffc0208efa:	4601                	li	a2,0
ffffffffc0208efc:	00006517          	auipc	a0,0x6
ffffffffc0208f00:	e2c50513          	addi	a0,a0,-468 # ffffffffc020ed28 <dev_node_ops+0x2d8>
ffffffffc0208f04:	81aff0ef          	jal	ra,ffffffffc0207f1e <vfs_add_dev>
ffffffffc0208f08:	e105                	bnez	a0,ffffffffc0208f28 <dev_init_stdout+0x76>
ffffffffc0208f0a:	60a2                	ld	ra,8(sp)
ffffffffc0208f0c:	0141                	addi	sp,sp,16
ffffffffc0208f0e:	8082                	ret
ffffffffc0208f10:	00006617          	auipc	a2,0x6
ffffffffc0208f14:	dd860613          	addi	a2,a2,-552 # ffffffffc020ece8 <dev_node_ops+0x298>
ffffffffc0208f18:	03700593          	li	a1,55
ffffffffc0208f1c:	00006517          	auipc	a0,0x6
ffffffffc0208f20:	dec50513          	addi	a0,a0,-532 # ffffffffc020ed08 <dev_node_ops+0x2b8>
ffffffffc0208f24:	d7af70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208f28:	86aa                	mv	a3,a0
ffffffffc0208f2a:	00006617          	auipc	a2,0x6
ffffffffc0208f2e:	e0660613          	addi	a2,a2,-506 # ffffffffc020ed30 <dev_node_ops+0x2e0>
ffffffffc0208f32:	03d00593          	li	a1,61
ffffffffc0208f36:	00006517          	auipc	a0,0x6
ffffffffc0208f3a:	dd250513          	addi	a0,a0,-558 # ffffffffc020ed08 <dev_node_ops+0x2b8>
ffffffffc0208f3e:	d60f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0208f42:	00005697          	auipc	a3,0x5
ffffffffc0208f46:	7e668693          	addi	a3,a3,2022 # ffffffffc020e728 <syscalls+0xb10>
ffffffffc0208f4a:	00003617          	auipc	a2,0x3
ffffffffc0208f4e:	b3660613          	addi	a2,a2,-1226 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208f52:	03900593          	li	a1,57
ffffffffc0208f56:	00006517          	auipc	a0,0x6
ffffffffc0208f5a:	db250513          	addi	a0,a0,-590 # ffffffffc020ed08 <dev_node_ops+0x2b8>
ffffffffc0208f5e:	d40f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208f62 <bitmap_translate.part.0>:
ffffffffc0208f62:	1141                	addi	sp,sp,-16
ffffffffc0208f64:	00006697          	auipc	a3,0x6
ffffffffc0208f68:	dec68693          	addi	a3,a3,-532 # ffffffffc020ed50 <dev_node_ops+0x300>
ffffffffc0208f6c:	00003617          	auipc	a2,0x3
ffffffffc0208f70:	b1460613          	addi	a2,a2,-1260 # ffffffffc020ba80 <commands+0x210>
ffffffffc0208f74:	04c00593          	li	a1,76
ffffffffc0208f78:	00006517          	auipc	a0,0x6
ffffffffc0208f7c:	df050513          	addi	a0,a0,-528 # ffffffffc020ed68 <dev_node_ops+0x318>
ffffffffc0208f80:	e406                	sd	ra,8(sp)
ffffffffc0208f82:	d1cf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0208f86 <bitmap_create>:
ffffffffc0208f86:	7139                	addi	sp,sp,-64
ffffffffc0208f88:	fc06                	sd	ra,56(sp)
ffffffffc0208f8a:	f822                	sd	s0,48(sp)
ffffffffc0208f8c:	f426                	sd	s1,40(sp)
ffffffffc0208f8e:	f04a                	sd	s2,32(sp)
ffffffffc0208f90:	ec4e                	sd	s3,24(sp)
ffffffffc0208f92:	e852                	sd	s4,16(sp)
ffffffffc0208f94:	e456                	sd	s5,8(sp)
ffffffffc0208f96:	c14d                	beqz	a0,ffffffffc0209038 <bitmap_create+0xb2>
ffffffffc0208f98:	842a                	mv	s0,a0
ffffffffc0208f9a:	4541                	li	a0,16
ffffffffc0208f9c:	ff3f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208fa0:	84aa                	mv	s1,a0
ffffffffc0208fa2:	cd25                	beqz	a0,ffffffffc020901a <bitmap_create+0x94>
ffffffffc0208fa4:	02041a13          	slli	s4,s0,0x20
ffffffffc0208fa8:	020a5a13          	srli	s4,s4,0x20
ffffffffc0208fac:	01fa0793          	addi	a5,s4,31
ffffffffc0208fb0:	0057d993          	srli	s3,a5,0x5
ffffffffc0208fb4:	00299a93          	slli	s5,s3,0x2
ffffffffc0208fb8:	8556                	mv	a0,s5
ffffffffc0208fba:	894e                	mv	s2,s3
ffffffffc0208fbc:	fd3f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0208fc0:	c53d                	beqz	a0,ffffffffc020902e <bitmap_create+0xa8>
ffffffffc0208fc2:	0134a223          	sw	s3,4(s1) # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0208fc6:	c080                	sw	s0,0(s1)
ffffffffc0208fc8:	8656                	mv	a2,s5
ffffffffc0208fca:	0ff00593          	li	a1,255
ffffffffc0208fce:	5cc020ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0208fd2:	e488                	sd	a0,8(s1)
ffffffffc0208fd4:	0996                	slli	s3,s3,0x5
ffffffffc0208fd6:	053a0263          	beq	s4,s3,ffffffffc020901a <bitmap_create+0x94>
ffffffffc0208fda:	fff9079b          	addiw	a5,s2,-1
ffffffffc0208fde:	0057969b          	slliw	a3,a5,0x5
ffffffffc0208fe2:	0054561b          	srliw	a2,s0,0x5
ffffffffc0208fe6:	40d4073b          	subw	a4,s0,a3
ffffffffc0208fea:	0054541b          	srliw	s0,s0,0x5
ffffffffc0208fee:	08f61463          	bne	a2,a5,ffffffffc0209076 <bitmap_create+0xf0>
ffffffffc0208ff2:	fff7069b          	addiw	a3,a4,-1
ffffffffc0208ff6:	47f9                	li	a5,30
ffffffffc0208ff8:	04d7ef63          	bltu	a5,a3,ffffffffc0209056 <bitmap_create+0xd0>
ffffffffc0208ffc:	1402                	slli	s0,s0,0x20
ffffffffc0208ffe:	8079                	srli	s0,s0,0x1e
ffffffffc0209000:	9522                	add	a0,a0,s0
ffffffffc0209002:	411c                	lw	a5,0(a0)
ffffffffc0209004:	4585                	li	a1,1
ffffffffc0209006:	02000613          	li	a2,32
ffffffffc020900a:	00e596bb          	sllw	a3,a1,a4
ffffffffc020900e:	8fb5                	xor	a5,a5,a3
ffffffffc0209010:	2705                	addiw	a4,a4,1
ffffffffc0209012:	2781                	sext.w	a5,a5
ffffffffc0209014:	fec71be3          	bne	a4,a2,ffffffffc020900a <bitmap_create+0x84>
ffffffffc0209018:	c11c                	sw	a5,0(a0)
ffffffffc020901a:	70e2                	ld	ra,56(sp)
ffffffffc020901c:	7442                	ld	s0,48(sp)
ffffffffc020901e:	7902                	ld	s2,32(sp)
ffffffffc0209020:	69e2                	ld	s3,24(sp)
ffffffffc0209022:	6a42                	ld	s4,16(sp)
ffffffffc0209024:	6aa2                	ld	s5,8(sp)
ffffffffc0209026:	8526                	mv	a0,s1
ffffffffc0209028:	74a2                	ld	s1,40(sp)
ffffffffc020902a:	6121                	addi	sp,sp,64
ffffffffc020902c:	8082                	ret
ffffffffc020902e:	8526                	mv	a0,s1
ffffffffc0209030:	80ef90ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209034:	4481                	li	s1,0
ffffffffc0209036:	b7d5                	j	ffffffffc020901a <bitmap_create+0x94>
ffffffffc0209038:	00006697          	auipc	a3,0x6
ffffffffc020903c:	d4868693          	addi	a3,a3,-696 # ffffffffc020ed80 <dev_node_ops+0x330>
ffffffffc0209040:	00003617          	auipc	a2,0x3
ffffffffc0209044:	a4060613          	addi	a2,a2,-1472 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209048:	45d5                	li	a1,21
ffffffffc020904a:	00006517          	auipc	a0,0x6
ffffffffc020904e:	d1e50513          	addi	a0,a0,-738 # ffffffffc020ed68 <dev_node_ops+0x318>
ffffffffc0209052:	c4cf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209056:	00006697          	auipc	a3,0x6
ffffffffc020905a:	d6a68693          	addi	a3,a3,-662 # ffffffffc020edc0 <dev_node_ops+0x370>
ffffffffc020905e:	00003617          	auipc	a2,0x3
ffffffffc0209062:	a2260613          	addi	a2,a2,-1502 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209066:	02b00593          	li	a1,43
ffffffffc020906a:	00006517          	auipc	a0,0x6
ffffffffc020906e:	cfe50513          	addi	a0,a0,-770 # ffffffffc020ed68 <dev_node_ops+0x318>
ffffffffc0209072:	c2cf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209076:	00006697          	auipc	a3,0x6
ffffffffc020907a:	d3268693          	addi	a3,a3,-718 # ffffffffc020eda8 <dev_node_ops+0x358>
ffffffffc020907e:	00003617          	auipc	a2,0x3
ffffffffc0209082:	a0260613          	addi	a2,a2,-1534 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209086:	02a00593          	li	a1,42
ffffffffc020908a:	00006517          	auipc	a0,0x6
ffffffffc020908e:	cde50513          	addi	a0,a0,-802 # ffffffffc020ed68 <dev_node_ops+0x318>
ffffffffc0209092:	c0cf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209096 <bitmap_alloc>:
ffffffffc0209096:	4150                	lw	a2,4(a0)
ffffffffc0209098:	651c                	ld	a5,8(a0)
ffffffffc020909a:	c231                	beqz	a2,ffffffffc02090de <bitmap_alloc+0x48>
ffffffffc020909c:	4701                	li	a4,0
ffffffffc020909e:	a029                	j	ffffffffc02090a8 <bitmap_alloc+0x12>
ffffffffc02090a0:	2705                	addiw	a4,a4,1
ffffffffc02090a2:	0791                	addi	a5,a5,4
ffffffffc02090a4:	02e60d63          	beq	a2,a4,ffffffffc02090de <bitmap_alloc+0x48>
ffffffffc02090a8:	4394                	lw	a3,0(a5)
ffffffffc02090aa:	dafd                	beqz	a3,ffffffffc02090a0 <bitmap_alloc+0xa>
ffffffffc02090ac:	4501                	li	a0,0
ffffffffc02090ae:	4885                	li	a7,1
ffffffffc02090b0:	8e36                	mv	t3,a3
ffffffffc02090b2:	02000313          	li	t1,32
ffffffffc02090b6:	a021                	j	ffffffffc02090be <bitmap_alloc+0x28>
ffffffffc02090b8:	2505                	addiw	a0,a0,1
ffffffffc02090ba:	02650463          	beq	a0,t1,ffffffffc02090e2 <bitmap_alloc+0x4c>
ffffffffc02090be:	00a8983b          	sllw	a6,a7,a0
ffffffffc02090c2:	0106f633          	and	a2,a3,a6
ffffffffc02090c6:	2601                	sext.w	a2,a2
ffffffffc02090c8:	da65                	beqz	a2,ffffffffc02090b8 <bitmap_alloc+0x22>
ffffffffc02090ca:	010e4833          	xor	a6,t3,a6
ffffffffc02090ce:	0057171b          	slliw	a4,a4,0x5
ffffffffc02090d2:	9f29                	addw	a4,a4,a0
ffffffffc02090d4:	0107a023          	sw	a6,0(a5)
ffffffffc02090d8:	c198                	sw	a4,0(a1)
ffffffffc02090da:	4501                	li	a0,0
ffffffffc02090dc:	8082                	ret
ffffffffc02090de:	5571                	li	a0,-4
ffffffffc02090e0:	8082                	ret
ffffffffc02090e2:	1141                	addi	sp,sp,-16
ffffffffc02090e4:	00004697          	auipc	a3,0x4
ffffffffc02090e8:	a1c68693          	addi	a3,a3,-1508 # ffffffffc020cb00 <default_pmm_manager+0x598>
ffffffffc02090ec:	00003617          	auipc	a2,0x3
ffffffffc02090f0:	99460613          	addi	a2,a2,-1644 # ffffffffc020ba80 <commands+0x210>
ffffffffc02090f4:	04300593          	li	a1,67
ffffffffc02090f8:	00006517          	auipc	a0,0x6
ffffffffc02090fc:	c7050513          	addi	a0,a0,-912 # ffffffffc020ed68 <dev_node_ops+0x318>
ffffffffc0209100:	e406                	sd	ra,8(sp)
ffffffffc0209102:	b9cf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209106 <bitmap_test>:
ffffffffc0209106:	411c                	lw	a5,0(a0)
ffffffffc0209108:	00f5ff63          	bgeu	a1,a5,ffffffffc0209126 <bitmap_test+0x20>
ffffffffc020910c:	651c                	ld	a5,8(a0)
ffffffffc020910e:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209112:	070a                	slli	a4,a4,0x2
ffffffffc0209114:	97ba                	add	a5,a5,a4
ffffffffc0209116:	4388                	lw	a0,0(a5)
ffffffffc0209118:	4785                	li	a5,1
ffffffffc020911a:	00b795bb          	sllw	a1,a5,a1
ffffffffc020911e:	8d6d                	and	a0,a0,a1
ffffffffc0209120:	1502                	slli	a0,a0,0x20
ffffffffc0209122:	9101                	srli	a0,a0,0x20
ffffffffc0209124:	8082                	ret
ffffffffc0209126:	1141                	addi	sp,sp,-16
ffffffffc0209128:	e406                	sd	ra,8(sp)
ffffffffc020912a:	e39ff0ef          	jal	ra,ffffffffc0208f62 <bitmap_translate.part.0>

ffffffffc020912e <bitmap_free>:
ffffffffc020912e:	411c                	lw	a5,0(a0)
ffffffffc0209130:	1141                	addi	sp,sp,-16
ffffffffc0209132:	e406                	sd	ra,8(sp)
ffffffffc0209134:	02f5f463          	bgeu	a1,a5,ffffffffc020915c <bitmap_free+0x2e>
ffffffffc0209138:	651c                	ld	a5,8(a0)
ffffffffc020913a:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020913e:	070a                	slli	a4,a4,0x2
ffffffffc0209140:	97ba                	add	a5,a5,a4
ffffffffc0209142:	4398                	lw	a4,0(a5)
ffffffffc0209144:	4685                	li	a3,1
ffffffffc0209146:	00b695bb          	sllw	a1,a3,a1
ffffffffc020914a:	00b776b3          	and	a3,a4,a1
ffffffffc020914e:	2681                	sext.w	a3,a3
ffffffffc0209150:	ea81                	bnez	a3,ffffffffc0209160 <bitmap_free+0x32>
ffffffffc0209152:	60a2                	ld	ra,8(sp)
ffffffffc0209154:	8f4d                	or	a4,a4,a1
ffffffffc0209156:	c398                	sw	a4,0(a5)
ffffffffc0209158:	0141                	addi	sp,sp,16
ffffffffc020915a:	8082                	ret
ffffffffc020915c:	e07ff0ef          	jal	ra,ffffffffc0208f62 <bitmap_translate.part.0>
ffffffffc0209160:	00006697          	auipc	a3,0x6
ffffffffc0209164:	c8868693          	addi	a3,a3,-888 # ffffffffc020ede8 <dev_node_ops+0x398>
ffffffffc0209168:	00003617          	auipc	a2,0x3
ffffffffc020916c:	91860613          	addi	a2,a2,-1768 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209170:	05f00593          	li	a1,95
ffffffffc0209174:	00006517          	auipc	a0,0x6
ffffffffc0209178:	bf450513          	addi	a0,a0,-1036 # ffffffffc020ed68 <dev_node_ops+0x318>
ffffffffc020917c:	b22f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209180 <bitmap_destroy>:
ffffffffc0209180:	1141                	addi	sp,sp,-16
ffffffffc0209182:	e022                	sd	s0,0(sp)
ffffffffc0209184:	842a                	mv	s0,a0
ffffffffc0209186:	6508                	ld	a0,8(a0)
ffffffffc0209188:	e406                	sd	ra,8(sp)
ffffffffc020918a:	eb5f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020918e:	8522                	mv	a0,s0
ffffffffc0209190:	6402                	ld	s0,0(sp)
ffffffffc0209192:	60a2                	ld	ra,8(sp)
ffffffffc0209194:	0141                	addi	sp,sp,16
ffffffffc0209196:	ea9f806f          	j	ffffffffc020203e <kfree>

ffffffffc020919a <bitmap_getdata>:
ffffffffc020919a:	c589                	beqz	a1,ffffffffc02091a4 <bitmap_getdata+0xa>
ffffffffc020919c:	00456783          	lwu	a5,4(a0)
ffffffffc02091a0:	078a                	slli	a5,a5,0x2
ffffffffc02091a2:	e19c                	sd	a5,0(a1)
ffffffffc02091a4:	6508                	ld	a0,8(a0)
ffffffffc02091a6:	8082                	ret

ffffffffc02091a8 <sfs_init>:
ffffffffc02091a8:	1141                	addi	sp,sp,-16
ffffffffc02091aa:	00006517          	auipc	a0,0x6
ffffffffc02091ae:	aae50513          	addi	a0,a0,-1362 # ffffffffc020ec58 <dev_node_ops+0x208>
ffffffffc02091b2:	e406                	sd	ra,8(sp)
ffffffffc02091b4:	554000ef          	jal	ra,ffffffffc0209708 <sfs_mount>
ffffffffc02091b8:	e501                	bnez	a0,ffffffffc02091c0 <sfs_init+0x18>
ffffffffc02091ba:	60a2                	ld	ra,8(sp)
ffffffffc02091bc:	0141                	addi	sp,sp,16
ffffffffc02091be:	8082                	ret
ffffffffc02091c0:	86aa                	mv	a3,a0
ffffffffc02091c2:	00006617          	auipc	a2,0x6
ffffffffc02091c6:	c3660613          	addi	a2,a2,-970 # ffffffffc020edf8 <dev_node_ops+0x3a8>
ffffffffc02091ca:	45c1                	li	a1,16
ffffffffc02091cc:	00006517          	auipc	a0,0x6
ffffffffc02091d0:	c4c50513          	addi	a0,a0,-948 # ffffffffc020ee18 <dev_node_ops+0x3c8>
ffffffffc02091d4:	acaf70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02091d8 <sfs_unmount>:
ffffffffc02091d8:	1141                	addi	sp,sp,-16
ffffffffc02091da:	e406                	sd	ra,8(sp)
ffffffffc02091dc:	e022                	sd	s0,0(sp)
ffffffffc02091de:	cd1d                	beqz	a0,ffffffffc020921c <sfs_unmount+0x44>
ffffffffc02091e0:	0b052783          	lw	a5,176(a0)
ffffffffc02091e4:	842a                	mv	s0,a0
ffffffffc02091e6:	eb9d                	bnez	a5,ffffffffc020921c <sfs_unmount+0x44>
ffffffffc02091e8:	7158                	ld	a4,160(a0)
ffffffffc02091ea:	09850793          	addi	a5,a0,152
ffffffffc02091ee:	02f71563          	bne	a4,a5,ffffffffc0209218 <sfs_unmount+0x40>
ffffffffc02091f2:	613c                	ld	a5,64(a0)
ffffffffc02091f4:	e7a1                	bnez	a5,ffffffffc020923c <sfs_unmount+0x64>
ffffffffc02091f6:	7d08                	ld	a0,56(a0)
ffffffffc02091f8:	f89ff0ef          	jal	ra,ffffffffc0209180 <bitmap_destroy>
ffffffffc02091fc:	6428                	ld	a0,72(s0)
ffffffffc02091fe:	e41f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209202:	7448                	ld	a0,168(s0)
ffffffffc0209204:	e3bf80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209208:	8522                	mv	a0,s0
ffffffffc020920a:	e35f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020920e:	4501                	li	a0,0
ffffffffc0209210:	60a2                	ld	ra,8(sp)
ffffffffc0209212:	6402                	ld	s0,0(sp)
ffffffffc0209214:	0141                	addi	sp,sp,16
ffffffffc0209216:	8082                	ret
ffffffffc0209218:	5545                	li	a0,-15
ffffffffc020921a:	bfdd                	j	ffffffffc0209210 <sfs_unmount+0x38>
ffffffffc020921c:	00006697          	auipc	a3,0x6
ffffffffc0209220:	c1468693          	addi	a3,a3,-1004 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc0209224:	00003617          	auipc	a2,0x3
ffffffffc0209228:	85c60613          	addi	a2,a2,-1956 # ffffffffc020ba80 <commands+0x210>
ffffffffc020922c:	04100593          	li	a1,65
ffffffffc0209230:	00006517          	auipc	a0,0x6
ffffffffc0209234:	c3050513          	addi	a0,a0,-976 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc0209238:	a66f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020923c:	00006697          	auipc	a3,0x6
ffffffffc0209240:	c3c68693          	addi	a3,a3,-964 # ffffffffc020ee78 <dev_node_ops+0x428>
ffffffffc0209244:	00003617          	auipc	a2,0x3
ffffffffc0209248:	83c60613          	addi	a2,a2,-1988 # ffffffffc020ba80 <commands+0x210>
ffffffffc020924c:	04500593          	li	a1,69
ffffffffc0209250:	00006517          	auipc	a0,0x6
ffffffffc0209254:	c1050513          	addi	a0,a0,-1008 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc0209258:	a46f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020925c <sfs_cleanup>:
ffffffffc020925c:	1101                	addi	sp,sp,-32
ffffffffc020925e:	ec06                	sd	ra,24(sp)
ffffffffc0209260:	e822                	sd	s0,16(sp)
ffffffffc0209262:	e426                	sd	s1,8(sp)
ffffffffc0209264:	e04a                	sd	s2,0(sp)
ffffffffc0209266:	c525                	beqz	a0,ffffffffc02092ce <sfs_cleanup+0x72>
ffffffffc0209268:	0b052783          	lw	a5,176(a0)
ffffffffc020926c:	84aa                	mv	s1,a0
ffffffffc020926e:	e3a5                	bnez	a5,ffffffffc02092ce <sfs_cleanup+0x72>
ffffffffc0209270:	4158                	lw	a4,4(a0)
ffffffffc0209272:	4514                	lw	a3,8(a0)
ffffffffc0209274:	00c50913          	addi	s2,a0,12
ffffffffc0209278:	85ca                	mv	a1,s2
ffffffffc020927a:	40d7063b          	subw	a2,a4,a3
ffffffffc020927e:	00006517          	auipc	a0,0x6
ffffffffc0209282:	c1250513          	addi	a0,a0,-1006 # ffffffffc020ee90 <dev_node_ops+0x440>
ffffffffc0209286:	f21f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc020928a:	02000413          	li	s0,32
ffffffffc020928e:	a019                	j	ffffffffc0209294 <sfs_cleanup+0x38>
ffffffffc0209290:	347d                	addiw	s0,s0,-1
ffffffffc0209292:	c819                	beqz	s0,ffffffffc02092a8 <sfs_cleanup+0x4c>
ffffffffc0209294:	7cdc                	ld	a5,184(s1)
ffffffffc0209296:	8526                	mv	a0,s1
ffffffffc0209298:	9782                	jalr	a5
ffffffffc020929a:	f97d                	bnez	a0,ffffffffc0209290 <sfs_cleanup+0x34>
ffffffffc020929c:	60e2                	ld	ra,24(sp)
ffffffffc020929e:	6442                	ld	s0,16(sp)
ffffffffc02092a0:	64a2                	ld	s1,8(sp)
ffffffffc02092a2:	6902                	ld	s2,0(sp)
ffffffffc02092a4:	6105                	addi	sp,sp,32
ffffffffc02092a6:	8082                	ret
ffffffffc02092a8:	6442                	ld	s0,16(sp)
ffffffffc02092aa:	60e2                	ld	ra,24(sp)
ffffffffc02092ac:	64a2                	ld	s1,8(sp)
ffffffffc02092ae:	86ca                	mv	a3,s2
ffffffffc02092b0:	6902                	ld	s2,0(sp)
ffffffffc02092b2:	872a                	mv	a4,a0
ffffffffc02092b4:	00006617          	auipc	a2,0x6
ffffffffc02092b8:	bfc60613          	addi	a2,a2,-1028 # ffffffffc020eeb0 <dev_node_ops+0x460>
ffffffffc02092bc:	05f00593          	li	a1,95
ffffffffc02092c0:	00006517          	auipc	a0,0x6
ffffffffc02092c4:	ba050513          	addi	a0,a0,-1120 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc02092c8:	6105                	addi	sp,sp,32
ffffffffc02092ca:	a3cf706f          	j	ffffffffc0200506 <__warn>
ffffffffc02092ce:	00006697          	auipc	a3,0x6
ffffffffc02092d2:	b6268693          	addi	a3,a3,-1182 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc02092d6:	00002617          	auipc	a2,0x2
ffffffffc02092da:	7aa60613          	addi	a2,a2,1962 # ffffffffc020ba80 <commands+0x210>
ffffffffc02092de:	05400593          	li	a1,84
ffffffffc02092e2:	00006517          	auipc	a0,0x6
ffffffffc02092e6:	b7e50513          	addi	a0,a0,-1154 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc02092ea:	9b4f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02092ee <sfs_sync>:
ffffffffc02092ee:	7179                	addi	sp,sp,-48
ffffffffc02092f0:	f406                	sd	ra,40(sp)
ffffffffc02092f2:	f022                	sd	s0,32(sp)
ffffffffc02092f4:	ec26                	sd	s1,24(sp)
ffffffffc02092f6:	e84a                	sd	s2,16(sp)
ffffffffc02092f8:	e44e                	sd	s3,8(sp)
ffffffffc02092fa:	e052                	sd	s4,0(sp)
ffffffffc02092fc:	cd4d                	beqz	a0,ffffffffc02093b6 <sfs_sync+0xc8>
ffffffffc02092fe:	0b052783          	lw	a5,176(a0)
ffffffffc0209302:	8a2a                	mv	s4,a0
ffffffffc0209304:	ebcd                	bnez	a5,ffffffffc02093b6 <sfs_sync+0xc8>
ffffffffc0209306:	541010ef          	jal	ra,ffffffffc020b046 <lock_sfs_fs>
ffffffffc020930a:	0a0a3403          	ld	s0,160(s4)
ffffffffc020930e:	098a0913          	addi	s2,s4,152
ffffffffc0209312:	02890763          	beq	s2,s0,ffffffffc0209340 <sfs_sync+0x52>
ffffffffc0209316:	00004997          	auipc	s3,0x4
ffffffffc020931a:	0f298993          	addi	s3,s3,242 # ffffffffc020d408 <default_pmm_manager+0xea0>
ffffffffc020931e:	7c1c                	ld	a5,56(s0)
ffffffffc0209320:	fc840493          	addi	s1,s0,-56
ffffffffc0209324:	cbb5                	beqz	a5,ffffffffc0209398 <sfs_sync+0xaa>
ffffffffc0209326:	7b9c                	ld	a5,48(a5)
ffffffffc0209328:	cba5                	beqz	a5,ffffffffc0209398 <sfs_sync+0xaa>
ffffffffc020932a:	85ce                	mv	a1,s3
ffffffffc020932c:	8526                	mv	a0,s1
ffffffffc020932e:	e28fe0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0209332:	7c1c                	ld	a5,56(s0)
ffffffffc0209334:	8526                	mv	a0,s1
ffffffffc0209336:	7b9c                	ld	a5,48(a5)
ffffffffc0209338:	9782                	jalr	a5
ffffffffc020933a:	6400                	ld	s0,8(s0)
ffffffffc020933c:	fe8911e3          	bne	s2,s0,ffffffffc020931e <sfs_sync+0x30>
ffffffffc0209340:	8552                	mv	a0,s4
ffffffffc0209342:	515010ef          	jal	ra,ffffffffc020b056 <unlock_sfs_fs>
ffffffffc0209346:	040a3783          	ld	a5,64(s4)
ffffffffc020934a:	4501                	li	a0,0
ffffffffc020934c:	eb89                	bnez	a5,ffffffffc020935e <sfs_sync+0x70>
ffffffffc020934e:	70a2                	ld	ra,40(sp)
ffffffffc0209350:	7402                	ld	s0,32(sp)
ffffffffc0209352:	64e2                	ld	s1,24(sp)
ffffffffc0209354:	6942                	ld	s2,16(sp)
ffffffffc0209356:	69a2                	ld	s3,8(sp)
ffffffffc0209358:	6a02                	ld	s4,0(sp)
ffffffffc020935a:	6145                	addi	sp,sp,48
ffffffffc020935c:	8082                	ret
ffffffffc020935e:	040a3023          	sd	zero,64(s4)
ffffffffc0209362:	8552                	mv	a0,s4
ffffffffc0209364:	3c7010ef          	jal	ra,ffffffffc020af2a <sfs_sync_super>
ffffffffc0209368:	cd01                	beqz	a0,ffffffffc0209380 <sfs_sync+0x92>
ffffffffc020936a:	70a2                	ld	ra,40(sp)
ffffffffc020936c:	7402                	ld	s0,32(sp)
ffffffffc020936e:	4785                	li	a5,1
ffffffffc0209370:	04fa3023          	sd	a5,64(s4)
ffffffffc0209374:	64e2                	ld	s1,24(sp)
ffffffffc0209376:	6942                	ld	s2,16(sp)
ffffffffc0209378:	69a2                	ld	s3,8(sp)
ffffffffc020937a:	6a02                	ld	s4,0(sp)
ffffffffc020937c:	6145                	addi	sp,sp,48
ffffffffc020937e:	8082                	ret
ffffffffc0209380:	8552                	mv	a0,s4
ffffffffc0209382:	3ef010ef          	jal	ra,ffffffffc020af70 <sfs_sync_freemap>
ffffffffc0209386:	f175                	bnez	a0,ffffffffc020936a <sfs_sync+0x7c>
ffffffffc0209388:	70a2                	ld	ra,40(sp)
ffffffffc020938a:	7402                	ld	s0,32(sp)
ffffffffc020938c:	64e2                	ld	s1,24(sp)
ffffffffc020938e:	6942                	ld	s2,16(sp)
ffffffffc0209390:	69a2                	ld	s3,8(sp)
ffffffffc0209392:	6a02                	ld	s4,0(sp)
ffffffffc0209394:	6145                	addi	sp,sp,48
ffffffffc0209396:	8082                	ret
ffffffffc0209398:	00004697          	auipc	a3,0x4
ffffffffc020939c:	02068693          	addi	a3,a3,32 # ffffffffc020d3b8 <default_pmm_manager+0xe50>
ffffffffc02093a0:	00002617          	auipc	a2,0x2
ffffffffc02093a4:	6e060613          	addi	a2,a2,1760 # ffffffffc020ba80 <commands+0x210>
ffffffffc02093a8:	45ed                	li	a1,27
ffffffffc02093aa:	00006517          	auipc	a0,0x6
ffffffffc02093ae:	ab650513          	addi	a0,a0,-1354 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc02093b2:	8ecf70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02093b6:	00006697          	auipc	a3,0x6
ffffffffc02093ba:	a7a68693          	addi	a3,a3,-1414 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc02093be:	00002617          	auipc	a2,0x2
ffffffffc02093c2:	6c260613          	addi	a2,a2,1730 # ffffffffc020ba80 <commands+0x210>
ffffffffc02093c6:	45d5                	li	a1,21
ffffffffc02093c8:	00006517          	auipc	a0,0x6
ffffffffc02093cc:	a9850513          	addi	a0,a0,-1384 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc02093d0:	8cef70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02093d4 <sfs_get_root>:
ffffffffc02093d4:	1101                	addi	sp,sp,-32
ffffffffc02093d6:	ec06                	sd	ra,24(sp)
ffffffffc02093d8:	cd09                	beqz	a0,ffffffffc02093f2 <sfs_get_root+0x1e>
ffffffffc02093da:	0b052783          	lw	a5,176(a0)
ffffffffc02093de:	eb91                	bnez	a5,ffffffffc02093f2 <sfs_get_root+0x1e>
ffffffffc02093e0:	4605                	li	a2,1
ffffffffc02093e2:	002c                	addi	a1,sp,8
ffffffffc02093e4:	378010ef          	jal	ra,ffffffffc020a75c <sfs_load_inode>
ffffffffc02093e8:	e50d                	bnez	a0,ffffffffc0209412 <sfs_get_root+0x3e>
ffffffffc02093ea:	60e2                	ld	ra,24(sp)
ffffffffc02093ec:	6522                	ld	a0,8(sp)
ffffffffc02093ee:	6105                	addi	sp,sp,32
ffffffffc02093f0:	8082                	ret
ffffffffc02093f2:	00006697          	auipc	a3,0x6
ffffffffc02093f6:	a3e68693          	addi	a3,a3,-1474 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc02093fa:	00002617          	auipc	a2,0x2
ffffffffc02093fe:	68660613          	addi	a2,a2,1670 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209402:	03600593          	li	a1,54
ffffffffc0209406:	00006517          	auipc	a0,0x6
ffffffffc020940a:	a5a50513          	addi	a0,a0,-1446 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc020940e:	890f70ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209412:	86aa                	mv	a3,a0
ffffffffc0209414:	00006617          	auipc	a2,0x6
ffffffffc0209418:	abc60613          	addi	a2,a2,-1348 # ffffffffc020eed0 <dev_node_ops+0x480>
ffffffffc020941c:	03700593          	li	a1,55
ffffffffc0209420:	00006517          	auipc	a0,0x6
ffffffffc0209424:	a4050513          	addi	a0,a0,-1472 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc0209428:	876f70ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020942c <sfs_do_mount>:
ffffffffc020942c:	6518                	ld	a4,8(a0)
ffffffffc020942e:	7171                	addi	sp,sp,-176
ffffffffc0209430:	f506                	sd	ra,168(sp)
ffffffffc0209432:	f122                	sd	s0,160(sp)
ffffffffc0209434:	ed26                	sd	s1,152(sp)
ffffffffc0209436:	e94a                	sd	s2,144(sp)
ffffffffc0209438:	e54e                	sd	s3,136(sp)
ffffffffc020943a:	e152                	sd	s4,128(sp)
ffffffffc020943c:	fcd6                	sd	s5,120(sp)
ffffffffc020943e:	f8da                	sd	s6,112(sp)
ffffffffc0209440:	f4de                	sd	s7,104(sp)
ffffffffc0209442:	f0e2                	sd	s8,96(sp)
ffffffffc0209444:	ece6                	sd	s9,88(sp)
ffffffffc0209446:	e8ea                	sd	s10,80(sp)
ffffffffc0209448:	e4ee                	sd	s11,72(sp)
ffffffffc020944a:	6785                	lui	a5,0x1
ffffffffc020944c:	24f71663          	bne	a4,a5,ffffffffc0209698 <sfs_do_mount+0x26c>
ffffffffc0209450:	892a                	mv	s2,a0
ffffffffc0209452:	4501                	li	a0,0
ffffffffc0209454:	8aae                	mv	s5,a1
ffffffffc0209456:	f00fe0ef          	jal	ra,ffffffffc0207b56 <__alloc_fs>
ffffffffc020945a:	842a                	mv	s0,a0
ffffffffc020945c:	24050463          	beqz	a0,ffffffffc02096a4 <sfs_do_mount+0x278>
ffffffffc0209460:	0b052b03          	lw	s6,176(a0)
ffffffffc0209464:	260b1263          	bnez	s6,ffffffffc02096c8 <sfs_do_mount+0x29c>
ffffffffc0209468:	03253823          	sd	s2,48(a0)
ffffffffc020946c:	6505                	lui	a0,0x1
ffffffffc020946e:	b21f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0209472:	e428                	sd	a0,72(s0)
ffffffffc0209474:	84aa                	mv	s1,a0
ffffffffc0209476:	16050363          	beqz	a0,ffffffffc02095dc <sfs_do_mount+0x1b0>
ffffffffc020947a:	85aa                	mv	a1,a0
ffffffffc020947c:	4681                	li	a3,0
ffffffffc020947e:	6605                	lui	a2,0x1
ffffffffc0209480:	1008                	addi	a0,sp,32
ffffffffc0209482:	fdffb0ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc0209486:	02093783          	ld	a5,32(s2)
ffffffffc020948a:	85aa                	mv	a1,a0
ffffffffc020948c:	4601                	li	a2,0
ffffffffc020948e:	854a                	mv	a0,s2
ffffffffc0209490:	9782                	jalr	a5
ffffffffc0209492:	8a2a                	mv	s4,a0
ffffffffc0209494:	10051e63          	bnez	a0,ffffffffc02095b0 <sfs_do_mount+0x184>
ffffffffc0209498:	408c                	lw	a1,0(s1)
ffffffffc020949a:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc020949e:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc02094a2:	14c59863          	bne	a1,a2,ffffffffc02095f2 <sfs_do_mount+0x1c6>
ffffffffc02094a6:	40dc                	lw	a5,4(s1)
ffffffffc02094a8:	00093603          	ld	a2,0(s2)
ffffffffc02094ac:	02079713          	slli	a4,a5,0x20
ffffffffc02094b0:	9301                	srli	a4,a4,0x20
ffffffffc02094b2:	12e66763          	bltu	a2,a4,ffffffffc02095e0 <sfs_do_mount+0x1b4>
ffffffffc02094b6:	020485a3          	sb	zero,43(s1)
ffffffffc02094ba:	0084af03          	lw	t5,8(s1)
ffffffffc02094be:	00c4ae83          	lw	t4,12(s1)
ffffffffc02094c2:	0104ae03          	lw	t3,16(s1)
ffffffffc02094c6:	0144a303          	lw	t1,20(s1)
ffffffffc02094ca:	0184a883          	lw	a7,24(s1)
ffffffffc02094ce:	01c4a803          	lw	a6,28(s1)
ffffffffc02094d2:	5090                	lw	a2,32(s1)
ffffffffc02094d4:	50d4                	lw	a3,36(s1)
ffffffffc02094d6:	5498                	lw	a4,40(s1)
ffffffffc02094d8:	6511                	lui	a0,0x4
ffffffffc02094da:	c00c                	sw	a1,0(s0)
ffffffffc02094dc:	c05c                	sw	a5,4(s0)
ffffffffc02094de:	01e42423          	sw	t5,8(s0)
ffffffffc02094e2:	01d42623          	sw	t4,12(s0)
ffffffffc02094e6:	01c42823          	sw	t3,16(s0)
ffffffffc02094ea:	00642a23          	sw	t1,20(s0)
ffffffffc02094ee:	01142c23          	sw	a7,24(s0)
ffffffffc02094f2:	01042e23          	sw	a6,28(s0)
ffffffffc02094f6:	d010                	sw	a2,32(s0)
ffffffffc02094f8:	d054                	sw	a3,36(s0)
ffffffffc02094fa:	d418                	sw	a4,40(s0)
ffffffffc02094fc:	a93f80ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc0209500:	f448                	sd	a0,168(s0)
ffffffffc0209502:	8c2a                	mv	s8,a0
ffffffffc0209504:	18050c63          	beqz	a0,ffffffffc020969c <sfs_do_mount+0x270>
ffffffffc0209508:	6711                	lui	a4,0x4
ffffffffc020950a:	87aa                	mv	a5,a0
ffffffffc020950c:	972a                	add	a4,a4,a0
ffffffffc020950e:	e79c                	sd	a5,8(a5)
ffffffffc0209510:	e39c                	sd	a5,0(a5)
ffffffffc0209512:	07c1                	addi	a5,a5,16
ffffffffc0209514:	fee79de3          	bne	a5,a4,ffffffffc020950e <sfs_do_mount+0xe2>
ffffffffc0209518:	0044eb83          	lwu	s7,4(s1)
ffffffffc020951c:	67a1                	lui	a5,0x8
ffffffffc020951e:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209522:	9bce                	add	s7,s7,s3
ffffffffc0209524:	77e1                	lui	a5,0xffff8
ffffffffc0209526:	00fbfbb3          	and	s7,s7,a5
ffffffffc020952a:	2b81                	sext.w	s7,s7
ffffffffc020952c:	855e                	mv	a0,s7
ffffffffc020952e:	a59ff0ef          	jal	ra,ffffffffc0208f86 <bitmap_create>
ffffffffc0209532:	fc08                	sd	a0,56(s0)
ffffffffc0209534:	8d2a                	mv	s10,a0
ffffffffc0209536:	14050f63          	beqz	a0,ffffffffc0209694 <sfs_do_mount+0x268>
ffffffffc020953a:	0044e783          	lwu	a5,4(s1)
ffffffffc020953e:	082c                	addi	a1,sp,24
ffffffffc0209540:	97ce                	add	a5,a5,s3
ffffffffc0209542:	00f7d713          	srli	a4,a5,0xf
ffffffffc0209546:	e43a                	sd	a4,8(sp)
ffffffffc0209548:	40f7d993          	srai	s3,a5,0xf
ffffffffc020954c:	c4fff0ef          	jal	ra,ffffffffc020919a <bitmap_getdata>
ffffffffc0209550:	14050c63          	beqz	a0,ffffffffc02096a8 <sfs_do_mount+0x27c>
ffffffffc0209554:	00c9979b          	slliw	a5,s3,0xc
ffffffffc0209558:	66e2                	ld	a3,24(sp)
ffffffffc020955a:	1782                	slli	a5,a5,0x20
ffffffffc020955c:	9381                	srli	a5,a5,0x20
ffffffffc020955e:	14d79563          	bne	a5,a3,ffffffffc02096a8 <sfs_do_mount+0x27c>
ffffffffc0209562:	6722                	ld	a4,8(sp)
ffffffffc0209564:	6d89                	lui	s11,0x2
ffffffffc0209566:	89aa                	mv	s3,a0
ffffffffc0209568:	00c71c93          	slli	s9,a4,0xc
ffffffffc020956c:	9caa                	add	s9,s9,a0
ffffffffc020956e:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0209572:	e711                	bnez	a4,ffffffffc020957e <sfs_do_mount+0x152>
ffffffffc0209574:	a079                	j	ffffffffc0209602 <sfs_do_mount+0x1d6>
ffffffffc0209576:	6785                	lui	a5,0x1
ffffffffc0209578:	99be                	add	s3,s3,a5
ffffffffc020957a:	093c8463          	beq	s9,s3,ffffffffc0209602 <sfs_do_mount+0x1d6>
ffffffffc020957e:	013d86bb          	addw	a3,s11,s3
ffffffffc0209582:	1682                	slli	a3,a3,0x20
ffffffffc0209584:	6605                	lui	a2,0x1
ffffffffc0209586:	85ce                	mv	a1,s3
ffffffffc0209588:	9281                	srli	a3,a3,0x20
ffffffffc020958a:	1008                	addi	a0,sp,32
ffffffffc020958c:	ed5fb0ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc0209590:	02093783          	ld	a5,32(s2)
ffffffffc0209594:	85aa                	mv	a1,a0
ffffffffc0209596:	4601                	li	a2,0
ffffffffc0209598:	854a                	mv	a0,s2
ffffffffc020959a:	9782                	jalr	a5
ffffffffc020959c:	dd69                	beqz	a0,ffffffffc0209576 <sfs_do_mount+0x14a>
ffffffffc020959e:	e42a                	sd	a0,8(sp)
ffffffffc02095a0:	856a                	mv	a0,s10
ffffffffc02095a2:	bdfff0ef          	jal	ra,ffffffffc0209180 <bitmap_destroy>
ffffffffc02095a6:	67a2                	ld	a5,8(sp)
ffffffffc02095a8:	8a3e                	mv	s4,a5
ffffffffc02095aa:	8562                	mv	a0,s8
ffffffffc02095ac:	a93f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02095b0:	8526                	mv	a0,s1
ffffffffc02095b2:	a8df80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02095b6:	8522                	mv	a0,s0
ffffffffc02095b8:	a87f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc02095bc:	70aa                	ld	ra,168(sp)
ffffffffc02095be:	740a                	ld	s0,160(sp)
ffffffffc02095c0:	64ea                	ld	s1,152(sp)
ffffffffc02095c2:	694a                	ld	s2,144(sp)
ffffffffc02095c4:	69aa                	ld	s3,136(sp)
ffffffffc02095c6:	7ae6                	ld	s5,120(sp)
ffffffffc02095c8:	7b46                	ld	s6,112(sp)
ffffffffc02095ca:	7ba6                	ld	s7,104(sp)
ffffffffc02095cc:	7c06                	ld	s8,96(sp)
ffffffffc02095ce:	6ce6                	ld	s9,88(sp)
ffffffffc02095d0:	6d46                	ld	s10,80(sp)
ffffffffc02095d2:	6da6                	ld	s11,72(sp)
ffffffffc02095d4:	8552                	mv	a0,s4
ffffffffc02095d6:	6a0a                	ld	s4,128(sp)
ffffffffc02095d8:	614d                	addi	sp,sp,176
ffffffffc02095da:	8082                	ret
ffffffffc02095dc:	5a71                	li	s4,-4
ffffffffc02095de:	bfe1                	j	ffffffffc02095b6 <sfs_do_mount+0x18a>
ffffffffc02095e0:	85be                	mv	a1,a5
ffffffffc02095e2:	00006517          	auipc	a0,0x6
ffffffffc02095e6:	94650513          	addi	a0,a0,-1722 # ffffffffc020ef28 <dev_node_ops+0x4d8>
ffffffffc02095ea:	bbdf60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02095ee:	5a75                	li	s4,-3
ffffffffc02095f0:	b7c1                	j	ffffffffc02095b0 <sfs_do_mount+0x184>
ffffffffc02095f2:	00006517          	auipc	a0,0x6
ffffffffc02095f6:	8fe50513          	addi	a0,a0,-1794 # ffffffffc020eef0 <dev_node_ops+0x4a0>
ffffffffc02095fa:	badf60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc02095fe:	5a75                	li	s4,-3
ffffffffc0209600:	bf45                	j	ffffffffc02095b0 <sfs_do_mount+0x184>
ffffffffc0209602:	00442903          	lw	s2,4(s0)
ffffffffc0209606:	4481                	li	s1,0
ffffffffc0209608:	080b8c63          	beqz	s7,ffffffffc02096a0 <sfs_do_mount+0x274>
ffffffffc020960c:	85a6                	mv	a1,s1
ffffffffc020960e:	856a                	mv	a0,s10
ffffffffc0209610:	af7ff0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc0209614:	c111                	beqz	a0,ffffffffc0209618 <sfs_do_mount+0x1ec>
ffffffffc0209616:	2b05                	addiw	s6,s6,1
ffffffffc0209618:	2485                	addiw	s1,s1,1
ffffffffc020961a:	fe9b99e3          	bne	s7,s1,ffffffffc020960c <sfs_do_mount+0x1e0>
ffffffffc020961e:	441c                	lw	a5,8(s0)
ffffffffc0209620:	0d679463          	bne	a5,s6,ffffffffc02096e8 <sfs_do_mount+0x2bc>
ffffffffc0209624:	4585                	li	a1,1
ffffffffc0209626:	05040513          	addi	a0,s0,80
ffffffffc020962a:	04043023          	sd	zero,64(s0)
ffffffffc020962e:	fabfa0ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc0209632:	4585                	li	a1,1
ffffffffc0209634:	06840513          	addi	a0,s0,104
ffffffffc0209638:	fa1fa0ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc020963c:	4585                	li	a1,1
ffffffffc020963e:	08040513          	addi	a0,s0,128
ffffffffc0209642:	f97fa0ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc0209646:	09840793          	addi	a5,s0,152
ffffffffc020964a:	f05c                	sd	a5,160(s0)
ffffffffc020964c:	ec5c                	sd	a5,152(s0)
ffffffffc020964e:	874a                	mv	a4,s2
ffffffffc0209650:	86da                	mv	a3,s6
ffffffffc0209652:	4169063b          	subw	a2,s2,s6
ffffffffc0209656:	00c40593          	addi	a1,s0,12
ffffffffc020965a:	00006517          	auipc	a0,0x6
ffffffffc020965e:	95e50513          	addi	a0,a0,-1698 # ffffffffc020efb8 <dev_node_ops+0x568>
ffffffffc0209662:	b45f60ef          	jal	ra,ffffffffc02001a6 <cprintf>
ffffffffc0209666:	00000797          	auipc	a5,0x0
ffffffffc020966a:	c8878793          	addi	a5,a5,-888 # ffffffffc02092ee <sfs_sync>
ffffffffc020966e:	fc5c                	sd	a5,184(s0)
ffffffffc0209670:	00000797          	auipc	a5,0x0
ffffffffc0209674:	d6478793          	addi	a5,a5,-668 # ffffffffc02093d4 <sfs_get_root>
ffffffffc0209678:	e07c                	sd	a5,192(s0)
ffffffffc020967a:	00000797          	auipc	a5,0x0
ffffffffc020967e:	b5e78793          	addi	a5,a5,-1186 # ffffffffc02091d8 <sfs_unmount>
ffffffffc0209682:	e47c                	sd	a5,200(s0)
ffffffffc0209684:	00000797          	auipc	a5,0x0
ffffffffc0209688:	bd878793          	addi	a5,a5,-1064 # ffffffffc020925c <sfs_cleanup>
ffffffffc020968c:	e87c                	sd	a5,208(s0)
ffffffffc020968e:	008ab023          	sd	s0,0(s5)
ffffffffc0209692:	b72d                	j	ffffffffc02095bc <sfs_do_mount+0x190>
ffffffffc0209694:	5a71                	li	s4,-4
ffffffffc0209696:	bf11                	j	ffffffffc02095aa <sfs_do_mount+0x17e>
ffffffffc0209698:	5a49                	li	s4,-14
ffffffffc020969a:	b70d                	j	ffffffffc02095bc <sfs_do_mount+0x190>
ffffffffc020969c:	5a71                	li	s4,-4
ffffffffc020969e:	bf09                	j	ffffffffc02095b0 <sfs_do_mount+0x184>
ffffffffc02096a0:	4b01                	li	s6,0
ffffffffc02096a2:	bfb5                	j	ffffffffc020961e <sfs_do_mount+0x1f2>
ffffffffc02096a4:	5a71                	li	s4,-4
ffffffffc02096a6:	bf19                	j	ffffffffc02095bc <sfs_do_mount+0x190>
ffffffffc02096a8:	00006697          	auipc	a3,0x6
ffffffffc02096ac:	8b068693          	addi	a3,a3,-1872 # ffffffffc020ef58 <dev_node_ops+0x508>
ffffffffc02096b0:	00002617          	auipc	a2,0x2
ffffffffc02096b4:	3d060613          	addi	a2,a2,976 # ffffffffc020ba80 <commands+0x210>
ffffffffc02096b8:	08300593          	li	a1,131
ffffffffc02096bc:	00005517          	auipc	a0,0x5
ffffffffc02096c0:	7a450513          	addi	a0,a0,1956 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc02096c4:	ddbf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02096c8:	00005697          	auipc	a3,0x5
ffffffffc02096cc:	76868693          	addi	a3,a3,1896 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc02096d0:	00002617          	auipc	a2,0x2
ffffffffc02096d4:	3b060613          	addi	a2,a2,944 # ffffffffc020ba80 <commands+0x210>
ffffffffc02096d8:	0a300593          	li	a1,163
ffffffffc02096dc:	00005517          	auipc	a0,0x5
ffffffffc02096e0:	78450513          	addi	a0,a0,1924 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc02096e4:	dbbf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02096e8:	00006697          	auipc	a3,0x6
ffffffffc02096ec:	8a068693          	addi	a3,a3,-1888 # ffffffffc020ef88 <dev_node_ops+0x538>
ffffffffc02096f0:	00002617          	auipc	a2,0x2
ffffffffc02096f4:	39060613          	addi	a2,a2,912 # ffffffffc020ba80 <commands+0x210>
ffffffffc02096f8:	0e000593          	li	a1,224
ffffffffc02096fc:	00005517          	auipc	a0,0x5
ffffffffc0209700:	76450513          	addi	a0,a0,1892 # ffffffffc020ee60 <dev_node_ops+0x410>
ffffffffc0209704:	d9bf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209708 <sfs_mount>:
ffffffffc0209708:	00000597          	auipc	a1,0x0
ffffffffc020970c:	d2458593          	addi	a1,a1,-732 # ffffffffc020942c <sfs_do_mount>
ffffffffc0209710:	817fe06f          	j	ffffffffc0207f26 <vfs_mount>

ffffffffc0209714 <sfs_opendir>:
ffffffffc0209714:	0235f593          	andi	a1,a1,35
ffffffffc0209718:	4501                	li	a0,0
ffffffffc020971a:	e191                	bnez	a1,ffffffffc020971e <sfs_opendir+0xa>
ffffffffc020971c:	8082                	ret
ffffffffc020971e:	553d                	li	a0,-17
ffffffffc0209720:	8082                	ret

ffffffffc0209722 <sfs_openfile>:
ffffffffc0209722:	4501                	li	a0,0
ffffffffc0209724:	8082                	ret

ffffffffc0209726 <sfs_gettype>:
ffffffffc0209726:	1141                	addi	sp,sp,-16
ffffffffc0209728:	e406                	sd	ra,8(sp)
ffffffffc020972a:	c939                	beqz	a0,ffffffffc0209780 <sfs_gettype+0x5a>
ffffffffc020972c:	4d34                	lw	a3,88(a0)
ffffffffc020972e:	6785                	lui	a5,0x1
ffffffffc0209730:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209734:	04e69663          	bne	a3,a4,ffffffffc0209780 <sfs_gettype+0x5a>
ffffffffc0209738:	6114                	ld	a3,0(a0)
ffffffffc020973a:	4709                	li	a4,2
ffffffffc020973c:	0046d683          	lhu	a3,4(a3)
ffffffffc0209740:	02e68a63          	beq	a3,a4,ffffffffc0209774 <sfs_gettype+0x4e>
ffffffffc0209744:	470d                	li	a4,3
ffffffffc0209746:	02e68163          	beq	a3,a4,ffffffffc0209768 <sfs_gettype+0x42>
ffffffffc020974a:	4705                	li	a4,1
ffffffffc020974c:	00e68f63          	beq	a3,a4,ffffffffc020976a <sfs_gettype+0x44>
ffffffffc0209750:	00006617          	auipc	a2,0x6
ffffffffc0209754:	8d860613          	addi	a2,a2,-1832 # ffffffffc020f028 <dev_node_ops+0x5d8>
ffffffffc0209758:	39500593          	li	a1,917
ffffffffc020975c:	00006517          	auipc	a0,0x6
ffffffffc0209760:	8b450513          	addi	a0,a0,-1868 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209764:	d3bf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209768:	678d                	lui	a5,0x3
ffffffffc020976a:	60a2                	ld	ra,8(sp)
ffffffffc020976c:	c19c                	sw	a5,0(a1)
ffffffffc020976e:	4501                	li	a0,0
ffffffffc0209770:	0141                	addi	sp,sp,16
ffffffffc0209772:	8082                	ret
ffffffffc0209774:	60a2                	ld	ra,8(sp)
ffffffffc0209776:	6789                	lui	a5,0x2
ffffffffc0209778:	c19c                	sw	a5,0(a1)
ffffffffc020977a:	4501                	li	a0,0
ffffffffc020977c:	0141                	addi	sp,sp,16
ffffffffc020977e:	8082                	ret
ffffffffc0209780:	00006697          	auipc	a3,0x6
ffffffffc0209784:	85868693          	addi	a3,a3,-1960 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc0209788:	00002617          	auipc	a2,0x2
ffffffffc020978c:	2f860613          	addi	a2,a2,760 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209790:	38900593          	li	a1,905
ffffffffc0209794:	00006517          	auipc	a0,0x6
ffffffffc0209798:	87c50513          	addi	a0,a0,-1924 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020979c:	d03f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02097a0 <sfs_fsync>:
ffffffffc02097a0:	7179                	addi	sp,sp,-48
ffffffffc02097a2:	ec26                	sd	s1,24(sp)
ffffffffc02097a4:	7524                	ld	s1,104(a0)
ffffffffc02097a6:	f406                	sd	ra,40(sp)
ffffffffc02097a8:	f022                	sd	s0,32(sp)
ffffffffc02097aa:	e84a                	sd	s2,16(sp)
ffffffffc02097ac:	e44e                	sd	s3,8(sp)
ffffffffc02097ae:	c4bd                	beqz	s1,ffffffffc020981c <sfs_fsync+0x7c>
ffffffffc02097b0:	0b04a783          	lw	a5,176(s1)
ffffffffc02097b4:	e7a5                	bnez	a5,ffffffffc020981c <sfs_fsync+0x7c>
ffffffffc02097b6:	4d38                	lw	a4,88(a0)
ffffffffc02097b8:	6785                	lui	a5,0x1
ffffffffc02097ba:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02097be:	842a                	mv	s0,a0
ffffffffc02097c0:	06f71e63          	bne	a4,a5,ffffffffc020983c <sfs_fsync+0x9c>
ffffffffc02097c4:	691c                	ld	a5,16(a0)
ffffffffc02097c6:	4901                	li	s2,0
ffffffffc02097c8:	eb89                	bnez	a5,ffffffffc02097da <sfs_fsync+0x3a>
ffffffffc02097ca:	70a2                	ld	ra,40(sp)
ffffffffc02097cc:	7402                	ld	s0,32(sp)
ffffffffc02097ce:	64e2                	ld	s1,24(sp)
ffffffffc02097d0:	69a2                	ld	s3,8(sp)
ffffffffc02097d2:	854a                	mv	a0,s2
ffffffffc02097d4:	6942                	ld	s2,16(sp)
ffffffffc02097d6:	6145                	addi	sp,sp,48
ffffffffc02097d8:	8082                	ret
ffffffffc02097da:	02050993          	addi	s3,a0,32
ffffffffc02097de:	854e                	mv	a0,s3
ffffffffc02097e0:	e03fa0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc02097e4:	681c                	ld	a5,16(s0)
ffffffffc02097e6:	ef81                	bnez	a5,ffffffffc02097fe <sfs_fsync+0x5e>
ffffffffc02097e8:	854e                	mv	a0,s3
ffffffffc02097ea:	df5fa0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc02097ee:	70a2                	ld	ra,40(sp)
ffffffffc02097f0:	7402                	ld	s0,32(sp)
ffffffffc02097f2:	64e2                	ld	s1,24(sp)
ffffffffc02097f4:	69a2                	ld	s3,8(sp)
ffffffffc02097f6:	854a                	mv	a0,s2
ffffffffc02097f8:	6942                	ld	s2,16(sp)
ffffffffc02097fa:	6145                	addi	sp,sp,48
ffffffffc02097fc:	8082                	ret
ffffffffc02097fe:	4414                	lw	a3,8(s0)
ffffffffc0209800:	600c                	ld	a1,0(s0)
ffffffffc0209802:	00043823          	sd	zero,16(s0)
ffffffffc0209806:	4701                	li	a4,0
ffffffffc0209808:	04000613          	li	a2,64
ffffffffc020980c:	8526                	mv	a0,s1
ffffffffc020980e:	688010ef          	jal	ra,ffffffffc020ae96 <sfs_wbuf>
ffffffffc0209812:	892a                	mv	s2,a0
ffffffffc0209814:	d971                	beqz	a0,ffffffffc02097e8 <sfs_fsync+0x48>
ffffffffc0209816:	4785                	li	a5,1
ffffffffc0209818:	e81c                	sd	a5,16(s0)
ffffffffc020981a:	b7f9                	j	ffffffffc02097e8 <sfs_fsync+0x48>
ffffffffc020981c:	00005697          	auipc	a3,0x5
ffffffffc0209820:	61468693          	addi	a3,a3,1556 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc0209824:	00002617          	auipc	a2,0x2
ffffffffc0209828:	25c60613          	addi	a2,a2,604 # ffffffffc020ba80 <commands+0x210>
ffffffffc020982c:	2ce00593          	li	a1,718
ffffffffc0209830:	00005517          	auipc	a0,0x5
ffffffffc0209834:	7e050513          	addi	a0,a0,2016 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209838:	c67f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020983c:	00005697          	auipc	a3,0x5
ffffffffc0209840:	79c68693          	addi	a3,a3,1948 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc0209844:	00002617          	auipc	a2,0x2
ffffffffc0209848:	23c60613          	addi	a2,a2,572 # ffffffffc020ba80 <commands+0x210>
ffffffffc020984c:	2cf00593          	li	a1,719
ffffffffc0209850:	00005517          	auipc	a0,0x5
ffffffffc0209854:	7c050513          	addi	a0,a0,1984 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209858:	c47f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020985c <sfs_fstat>:
ffffffffc020985c:	1101                	addi	sp,sp,-32
ffffffffc020985e:	e426                	sd	s1,8(sp)
ffffffffc0209860:	84ae                	mv	s1,a1
ffffffffc0209862:	e822                	sd	s0,16(sp)
ffffffffc0209864:	02000613          	li	a2,32
ffffffffc0209868:	842a                	mv	s0,a0
ffffffffc020986a:	4581                	li	a1,0
ffffffffc020986c:	8526                	mv	a0,s1
ffffffffc020986e:	ec06                	sd	ra,24(sp)
ffffffffc0209870:	52b010ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc0209874:	c439                	beqz	s0,ffffffffc02098c2 <sfs_fstat+0x66>
ffffffffc0209876:	783c                	ld	a5,112(s0)
ffffffffc0209878:	c7a9                	beqz	a5,ffffffffc02098c2 <sfs_fstat+0x66>
ffffffffc020987a:	6bbc                	ld	a5,80(a5)
ffffffffc020987c:	c3b9                	beqz	a5,ffffffffc02098c2 <sfs_fstat+0x66>
ffffffffc020987e:	00005597          	auipc	a1,0x5
ffffffffc0209882:	14a58593          	addi	a1,a1,330 # ffffffffc020e9c8 <syscalls+0xdb0>
ffffffffc0209886:	8522                	mv	a0,s0
ffffffffc0209888:	8cefe0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc020988c:	783c                	ld	a5,112(s0)
ffffffffc020988e:	85a6                	mv	a1,s1
ffffffffc0209890:	8522                	mv	a0,s0
ffffffffc0209892:	6bbc                	ld	a5,80(a5)
ffffffffc0209894:	9782                	jalr	a5
ffffffffc0209896:	e10d                	bnez	a0,ffffffffc02098b8 <sfs_fstat+0x5c>
ffffffffc0209898:	4c38                	lw	a4,88(s0)
ffffffffc020989a:	6785                	lui	a5,0x1
ffffffffc020989c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02098a0:	04f71163          	bne	a4,a5,ffffffffc02098e2 <sfs_fstat+0x86>
ffffffffc02098a4:	601c                	ld	a5,0(s0)
ffffffffc02098a6:	0067d683          	lhu	a3,6(a5)
ffffffffc02098aa:	0087e703          	lwu	a4,8(a5)
ffffffffc02098ae:	0007e783          	lwu	a5,0(a5)
ffffffffc02098b2:	e494                	sd	a3,8(s1)
ffffffffc02098b4:	e898                	sd	a4,16(s1)
ffffffffc02098b6:	ec9c                	sd	a5,24(s1)
ffffffffc02098b8:	60e2                	ld	ra,24(sp)
ffffffffc02098ba:	6442                	ld	s0,16(sp)
ffffffffc02098bc:	64a2                	ld	s1,8(sp)
ffffffffc02098be:	6105                	addi	sp,sp,32
ffffffffc02098c0:	8082                	ret
ffffffffc02098c2:	00005697          	auipc	a3,0x5
ffffffffc02098c6:	09e68693          	addi	a3,a3,158 # ffffffffc020e960 <syscalls+0xd48>
ffffffffc02098ca:	00002617          	auipc	a2,0x2
ffffffffc02098ce:	1b660613          	addi	a2,a2,438 # ffffffffc020ba80 <commands+0x210>
ffffffffc02098d2:	2bf00593          	li	a1,703
ffffffffc02098d6:	00005517          	auipc	a0,0x5
ffffffffc02098da:	73a50513          	addi	a0,a0,1850 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc02098de:	bc1f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc02098e2:	00005697          	auipc	a3,0x5
ffffffffc02098e6:	6f668693          	addi	a3,a3,1782 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc02098ea:	00002617          	auipc	a2,0x2
ffffffffc02098ee:	19660613          	addi	a2,a2,406 # ffffffffc020ba80 <commands+0x210>
ffffffffc02098f2:	2c200593          	li	a1,706
ffffffffc02098f6:	00005517          	auipc	a0,0x5
ffffffffc02098fa:	71a50513          	addi	a0,a0,1818 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc02098fe:	ba1f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209902 <sfs_tryseek>:
ffffffffc0209902:	080007b7          	lui	a5,0x8000
ffffffffc0209906:	04f5fd63          	bgeu	a1,a5,ffffffffc0209960 <sfs_tryseek+0x5e>
ffffffffc020990a:	1101                	addi	sp,sp,-32
ffffffffc020990c:	e822                	sd	s0,16(sp)
ffffffffc020990e:	ec06                	sd	ra,24(sp)
ffffffffc0209910:	e426                	sd	s1,8(sp)
ffffffffc0209912:	842a                	mv	s0,a0
ffffffffc0209914:	c921                	beqz	a0,ffffffffc0209964 <sfs_tryseek+0x62>
ffffffffc0209916:	4d38                	lw	a4,88(a0)
ffffffffc0209918:	6785                	lui	a5,0x1
ffffffffc020991a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020991e:	04f71363          	bne	a4,a5,ffffffffc0209964 <sfs_tryseek+0x62>
ffffffffc0209922:	611c                	ld	a5,0(a0)
ffffffffc0209924:	84ae                	mv	s1,a1
ffffffffc0209926:	0007e783          	lwu	a5,0(a5)
ffffffffc020992a:	02b7d563          	bge	a5,a1,ffffffffc0209954 <sfs_tryseek+0x52>
ffffffffc020992e:	793c                	ld	a5,112(a0)
ffffffffc0209930:	cbb1                	beqz	a5,ffffffffc0209984 <sfs_tryseek+0x82>
ffffffffc0209932:	73bc                	ld	a5,96(a5)
ffffffffc0209934:	cba1                	beqz	a5,ffffffffc0209984 <sfs_tryseek+0x82>
ffffffffc0209936:	00005597          	auipc	a1,0x5
ffffffffc020993a:	f8258593          	addi	a1,a1,-126 # ffffffffc020e8b8 <syscalls+0xca0>
ffffffffc020993e:	818fe0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0209942:	783c                	ld	a5,112(s0)
ffffffffc0209944:	8522                	mv	a0,s0
ffffffffc0209946:	6442                	ld	s0,16(sp)
ffffffffc0209948:	60e2                	ld	ra,24(sp)
ffffffffc020994a:	73bc                	ld	a5,96(a5)
ffffffffc020994c:	85a6                	mv	a1,s1
ffffffffc020994e:	64a2                	ld	s1,8(sp)
ffffffffc0209950:	6105                	addi	sp,sp,32
ffffffffc0209952:	8782                	jr	a5
ffffffffc0209954:	60e2                	ld	ra,24(sp)
ffffffffc0209956:	6442                	ld	s0,16(sp)
ffffffffc0209958:	64a2                	ld	s1,8(sp)
ffffffffc020995a:	4501                	li	a0,0
ffffffffc020995c:	6105                	addi	sp,sp,32
ffffffffc020995e:	8082                	ret
ffffffffc0209960:	5575                	li	a0,-3
ffffffffc0209962:	8082                	ret
ffffffffc0209964:	00005697          	auipc	a3,0x5
ffffffffc0209968:	67468693          	addi	a3,a3,1652 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020996c:	00002617          	auipc	a2,0x2
ffffffffc0209970:	11460613          	addi	a2,a2,276 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209974:	3a000593          	li	a1,928
ffffffffc0209978:	00005517          	auipc	a0,0x5
ffffffffc020997c:	69850513          	addi	a0,a0,1688 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209980:	b1ff60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209984:	00005697          	auipc	a3,0x5
ffffffffc0209988:	edc68693          	addi	a3,a3,-292 # ffffffffc020e860 <syscalls+0xc48>
ffffffffc020998c:	00002617          	auipc	a2,0x2
ffffffffc0209990:	0f460613          	addi	a2,a2,244 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209994:	3a200593          	li	a1,930
ffffffffc0209998:	00005517          	auipc	a0,0x5
ffffffffc020999c:	67850513          	addi	a0,a0,1656 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc02099a0:	afff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02099a4 <sfs_close>:
ffffffffc02099a4:	1141                	addi	sp,sp,-16
ffffffffc02099a6:	e406                	sd	ra,8(sp)
ffffffffc02099a8:	e022                	sd	s0,0(sp)
ffffffffc02099aa:	c11d                	beqz	a0,ffffffffc02099d0 <sfs_close+0x2c>
ffffffffc02099ac:	793c                	ld	a5,112(a0)
ffffffffc02099ae:	842a                	mv	s0,a0
ffffffffc02099b0:	c385                	beqz	a5,ffffffffc02099d0 <sfs_close+0x2c>
ffffffffc02099b2:	7b9c                	ld	a5,48(a5)
ffffffffc02099b4:	cf91                	beqz	a5,ffffffffc02099d0 <sfs_close+0x2c>
ffffffffc02099b6:	00004597          	auipc	a1,0x4
ffffffffc02099ba:	a5258593          	addi	a1,a1,-1454 # ffffffffc020d408 <default_pmm_manager+0xea0>
ffffffffc02099be:	f99fd0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc02099c2:	783c                	ld	a5,112(s0)
ffffffffc02099c4:	8522                	mv	a0,s0
ffffffffc02099c6:	6402                	ld	s0,0(sp)
ffffffffc02099c8:	60a2                	ld	ra,8(sp)
ffffffffc02099ca:	7b9c                	ld	a5,48(a5)
ffffffffc02099cc:	0141                	addi	sp,sp,16
ffffffffc02099ce:	8782                	jr	a5
ffffffffc02099d0:	00004697          	auipc	a3,0x4
ffffffffc02099d4:	9e868693          	addi	a3,a3,-1560 # ffffffffc020d3b8 <default_pmm_manager+0xe50>
ffffffffc02099d8:	00002617          	auipc	a2,0x2
ffffffffc02099dc:	0a860613          	addi	a2,a2,168 # ffffffffc020ba80 <commands+0x210>
ffffffffc02099e0:	21c00593          	li	a1,540
ffffffffc02099e4:	00005517          	auipc	a0,0x5
ffffffffc02099e8:	62c50513          	addi	a0,a0,1580 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc02099ec:	ab3f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc02099f0 <sfs_io.part.0>:
ffffffffc02099f0:	1141                	addi	sp,sp,-16
ffffffffc02099f2:	00005697          	auipc	a3,0x5
ffffffffc02099f6:	5e668693          	addi	a3,a3,1510 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc02099fa:	00002617          	auipc	a2,0x2
ffffffffc02099fe:	08660613          	addi	a2,a2,134 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209a02:	29e00593          	li	a1,670
ffffffffc0209a06:	00005517          	auipc	a0,0x5
ffffffffc0209a0a:	60a50513          	addi	a0,a0,1546 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209a0e:	e406                	sd	ra,8(sp)
ffffffffc0209a10:	a8ff60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209a14 <sfs_block_free>:
ffffffffc0209a14:	1101                	addi	sp,sp,-32
ffffffffc0209a16:	e426                	sd	s1,8(sp)
ffffffffc0209a18:	ec06                	sd	ra,24(sp)
ffffffffc0209a1a:	e822                	sd	s0,16(sp)
ffffffffc0209a1c:	4154                	lw	a3,4(a0)
ffffffffc0209a1e:	84ae                	mv	s1,a1
ffffffffc0209a20:	c595                	beqz	a1,ffffffffc0209a4c <sfs_block_free+0x38>
ffffffffc0209a22:	02d5f563          	bgeu	a1,a3,ffffffffc0209a4c <sfs_block_free+0x38>
ffffffffc0209a26:	842a                	mv	s0,a0
ffffffffc0209a28:	7d08                	ld	a0,56(a0)
ffffffffc0209a2a:	edcff0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc0209a2e:	ed05                	bnez	a0,ffffffffc0209a66 <sfs_block_free+0x52>
ffffffffc0209a30:	7c08                	ld	a0,56(s0)
ffffffffc0209a32:	85a6                	mv	a1,s1
ffffffffc0209a34:	efaff0ef          	jal	ra,ffffffffc020912e <bitmap_free>
ffffffffc0209a38:	441c                	lw	a5,8(s0)
ffffffffc0209a3a:	4705                	li	a4,1
ffffffffc0209a3c:	60e2                	ld	ra,24(sp)
ffffffffc0209a3e:	2785                	addiw	a5,a5,1
ffffffffc0209a40:	e038                	sd	a4,64(s0)
ffffffffc0209a42:	c41c                	sw	a5,8(s0)
ffffffffc0209a44:	6442                	ld	s0,16(sp)
ffffffffc0209a46:	64a2                	ld	s1,8(sp)
ffffffffc0209a48:	6105                	addi	sp,sp,32
ffffffffc0209a4a:	8082                	ret
ffffffffc0209a4c:	8726                	mv	a4,s1
ffffffffc0209a4e:	00005617          	auipc	a2,0x5
ffffffffc0209a52:	5f260613          	addi	a2,a2,1522 # ffffffffc020f040 <dev_node_ops+0x5f0>
ffffffffc0209a56:	05300593          	li	a1,83
ffffffffc0209a5a:	00005517          	auipc	a0,0x5
ffffffffc0209a5e:	5b650513          	addi	a0,a0,1462 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209a62:	a3df60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209a66:	00005697          	auipc	a3,0x5
ffffffffc0209a6a:	61268693          	addi	a3,a3,1554 # ffffffffc020f078 <dev_node_ops+0x628>
ffffffffc0209a6e:	00002617          	auipc	a2,0x2
ffffffffc0209a72:	01260613          	addi	a2,a2,18 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209a76:	06a00593          	li	a1,106
ffffffffc0209a7a:	00005517          	auipc	a0,0x5
ffffffffc0209a7e:	59650513          	addi	a0,a0,1430 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209a82:	a1df60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209a86 <sfs_reclaim>:
ffffffffc0209a86:	1101                	addi	sp,sp,-32
ffffffffc0209a88:	e426                	sd	s1,8(sp)
ffffffffc0209a8a:	7524                	ld	s1,104(a0)
ffffffffc0209a8c:	ec06                	sd	ra,24(sp)
ffffffffc0209a8e:	e822                	sd	s0,16(sp)
ffffffffc0209a90:	e04a                	sd	s2,0(sp)
ffffffffc0209a92:	0e048a63          	beqz	s1,ffffffffc0209b86 <sfs_reclaim+0x100>
ffffffffc0209a96:	0b04a783          	lw	a5,176(s1)
ffffffffc0209a9a:	0e079663          	bnez	a5,ffffffffc0209b86 <sfs_reclaim+0x100>
ffffffffc0209a9e:	4d38                	lw	a4,88(a0)
ffffffffc0209aa0:	6785                	lui	a5,0x1
ffffffffc0209aa2:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209aa6:	842a                	mv	s0,a0
ffffffffc0209aa8:	10f71f63          	bne	a4,a5,ffffffffc0209bc6 <sfs_reclaim+0x140>
ffffffffc0209aac:	8526                	mv	a0,s1
ffffffffc0209aae:	598010ef          	jal	ra,ffffffffc020b046 <lock_sfs_fs>
ffffffffc0209ab2:	4c1c                	lw	a5,24(s0)
ffffffffc0209ab4:	0ef05963          	blez	a5,ffffffffc0209ba6 <sfs_reclaim+0x120>
ffffffffc0209ab8:	fff7871b          	addiw	a4,a5,-1
ffffffffc0209abc:	cc18                	sw	a4,24(s0)
ffffffffc0209abe:	eb59                	bnez	a4,ffffffffc0209b54 <sfs_reclaim+0xce>
ffffffffc0209ac0:	05c42903          	lw	s2,92(s0)
ffffffffc0209ac4:	08091863          	bnez	s2,ffffffffc0209b54 <sfs_reclaim+0xce>
ffffffffc0209ac8:	601c                	ld	a5,0(s0)
ffffffffc0209aca:	0067d783          	lhu	a5,6(a5)
ffffffffc0209ace:	e785                	bnez	a5,ffffffffc0209af6 <sfs_reclaim+0x70>
ffffffffc0209ad0:	783c                	ld	a5,112(s0)
ffffffffc0209ad2:	10078a63          	beqz	a5,ffffffffc0209be6 <sfs_reclaim+0x160>
ffffffffc0209ad6:	73bc                	ld	a5,96(a5)
ffffffffc0209ad8:	10078763          	beqz	a5,ffffffffc0209be6 <sfs_reclaim+0x160>
ffffffffc0209adc:	00005597          	auipc	a1,0x5
ffffffffc0209ae0:	ddc58593          	addi	a1,a1,-548 # ffffffffc020e8b8 <syscalls+0xca0>
ffffffffc0209ae4:	8522                	mv	a0,s0
ffffffffc0209ae6:	e71fd0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0209aea:	783c                	ld	a5,112(s0)
ffffffffc0209aec:	4581                	li	a1,0
ffffffffc0209aee:	8522                	mv	a0,s0
ffffffffc0209af0:	73bc                	ld	a5,96(a5)
ffffffffc0209af2:	9782                	jalr	a5
ffffffffc0209af4:	e559                	bnez	a0,ffffffffc0209b82 <sfs_reclaim+0xfc>
ffffffffc0209af6:	681c                	ld	a5,16(s0)
ffffffffc0209af8:	c39d                	beqz	a5,ffffffffc0209b1e <sfs_reclaim+0x98>
ffffffffc0209afa:	783c                	ld	a5,112(s0)
ffffffffc0209afc:	10078563          	beqz	a5,ffffffffc0209c06 <sfs_reclaim+0x180>
ffffffffc0209b00:	7b9c                	ld	a5,48(a5)
ffffffffc0209b02:	10078263          	beqz	a5,ffffffffc0209c06 <sfs_reclaim+0x180>
ffffffffc0209b06:	8522                	mv	a0,s0
ffffffffc0209b08:	00004597          	auipc	a1,0x4
ffffffffc0209b0c:	90058593          	addi	a1,a1,-1792 # ffffffffc020d408 <default_pmm_manager+0xea0>
ffffffffc0209b10:	e47fd0ef          	jal	ra,ffffffffc0207956 <inode_check>
ffffffffc0209b14:	783c                	ld	a5,112(s0)
ffffffffc0209b16:	8522                	mv	a0,s0
ffffffffc0209b18:	7b9c                	ld	a5,48(a5)
ffffffffc0209b1a:	9782                	jalr	a5
ffffffffc0209b1c:	e13d                	bnez	a0,ffffffffc0209b82 <sfs_reclaim+0xfc>
ffffffffc0209b1e:	7c18                	ld	a4,56(s0)
ffffffffc0209b20:	603c                	ld	a5,64(s0)
ffffffffc0209b22:	8526                	mv	a0,s1
ffffffffc0209b24:	e71c                	sd	a5,8(a4)
ffffffffc0209b26:	e398                	sd	a4,0(a5)
ffffffffc0209b28:	6438                	ld	a4,72(s0)
ffffffffc0209b2a:	683c                	ld	a5,80(s0)
ffffffffc0209b2c:	e71c                	sd	a5,8(a4)
ffffffffc0209b2e:	e398                	sd	a4,0(a5)
ffffffffc0209b30:	526010ef          	jal	ra,ffffffffc020b056 <unlock_sfs_fs>
ffffffffc0209b34:	6008                	ld	a0,0(s0)
ffffffffc0209b36:	00655783          	lhu	a5,6(a0)
ffffffffc0209b3a:	cb85                	beqz	a5,ffffffffc0209b6a <sfs_reclaim+0xe4>
ffffffffc0209b3c:	d02f80ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc0209b40:	8522                	mv	a0,s0
ffffffffc0209b42:	da9fd0ef          	jal	ra,ffffffffc02078ea <inode_kill>
ffffffffc0209b46:	60e2                	ld	ra,24(sp)
ffffffffc0209b48:	6442                	ld	s0,16(sp)
ffffffffc0209b4a:	64a2                	ld	s1,8(sp)
ffffffffc0209b4c:	854a                	mv	a0,s2
ffffffffc0209b4e:	6902                	ld	s2,0(sp)
ffffffffc0209b50:	6105                	addi	sp,sp,32
ffffffffc0209b52:	8082                	ret
ffffffffc0209b54:	5945                	li	s2,-15
ffffffffc0209b56:	8526                	mv	a0,s1
ffffffffc0209b58:	4fe010ef          	jal	ra,ffffffffc020b056 <unlock_sfs_fs>
ffffffffc0209b5c:	60e2                	ld	ra,24(sp)
ffffffffc0209b5e:	6442                	ld	s0,16(sp)
ffffffffc0209b60:	64a2                	ld	s1,8(sp)
ffffffffc0209b62:	854a                	mv	a0,s2
ffffffffc0209b64:	6902                	ld	s2,0(sp)
ffffffffc0209b66:	6105                	addi	sp,sp,32
ffffffffc0209b68:	8082                	ret
ffffffffc0209b6a:	440c                	lw	a1,8(s0)
ffffffffc0209b6c:	8526                	mv	a0,s1
ffffffffc0209b6e:	ea7ff0ef          	jal	ra,ffffffffc0209a14 <sfs_block_free>
ffffffffc0209b72:	6008                	ld	a0,0(s0)
ffffffffc0209b74:	5d4c                	lw	a1,60(a0)
ffffffffc0209b76:	d1f9                	beqz	a1,ffffffffc0209b3c <sfs_reclaim+0xb6>
ffffffffc0209b78:	8526                	mv	a0,s1
ffffffffc0209b7a:	e9bff0ef          	jal	ra,ffffffffc0209a14 <sfs_block_free>
ffffffffc0209b7e:	6008                	ld	a0,0(s0)
ffffffffc0209b80:	bf75                	j	ffffffffc0209b3c <sfs_reclaim+0xb6>
ffffffffc0209b82:	892a                	mv	s2,a0
ffffffffc0209b84:	bfc9                	j	ffffffffc0209b56 <sfs_reclaim+0xd0>
ffffffffc0209b86:	00005697          	auipc	a3,0x5
ffffffffc0209b8a:	2aa68693          	addi	a3,a3,682 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc0209b8e:	00002617          	auipc	a2,0x2
ffffffffc0209b92:	ef260613          	addi	a2,a2,-270 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209b96:	35e00593          	li	a1,862
ffffffffc0209b9a:	00005517          	auipc	a0,0x5
ffffffffc0209b9e:	47650513          	addi	a0,a0,1142 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209ba2:	8fdf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209ba6:	00005697          	auipc	a3,0x5
ffffffffc0209baa:	4f268693          	addi	a3,a3,1266 # ffffffffc020f098 <dev_node_ops+0x648>
ffffffffc0209bae:	00002617          	auipc	a2,0x2
ffffffffc0209bb2:	ed260613          	addi	a2,a2,-302 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209bb6:	36400593          	li	a1,868
ffffffffc0209bba:	00005517          	auipc	a0,0x5
ffffffffc0209bbe:	45650513          	addi	a0,a0,1110 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209bc2:	8ddf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209bc6:	00005697          	auipc	a3,0x5
ffffffffc0209bca:	41268693          	addi	a3,a3,1042 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc0209bce:	00002617          	auipc	a2,0x2
ffffffffc0209bd2:	eb260613          	addi	a2,a2,-334 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209bd6:	35f00593          	li	a1,863
ffffffffc0209bda:	00005517          	auipc	a0,0x5
ffffffffc0209bde:	43650513          	addi	a0,a0,1078 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209be2:	8bdf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209be6:	00005697          	auipc	a3,0x5
ffffffffc0209bea:	c7a68693          	addi	a3,a3,-902 # ffffffffc020e860 <syscalls+0xc48>
ffffffffc0209bee:	00002617          	auipc	a2,0x2
ffffffffc0209bf2:	e9260613          	addi	a2,a2,-366 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209bf6:	36900593          	li	a1,873
ffffffffc0209bfa:	00005517          	auipc	a0,0x5
ffffffffc0209bfe:	41650513          	addi	a0,a0,1046 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209c02:	89df60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209c06:	00003697          	auipc	a3,0x3
ffffffffc0209c0a:	7b268693          	addi	a3,a3,1970 # ffffffffc020d3b8 <default_pmm_manager+0xe50>
ffffffffc0209c0e:	00002617          	auipc	a2,0x2
ffffffffc0209c12:	e7260613          	addi	a2,a2,-398 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209c16:	36e00593          	li	a1,878
ffffffffc0209c1a:	00005517          	auipc	a0,0x5
ffffffffc0209c1e:	3f650513          	addi	a0,a0,1014 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209c22:	87df60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209c26 <sfs_block_alloc>:
ffffffffc0209c26:	1101                	addi	sp,sp,-32
ffffffffc0209c28:	e822                	sd	s0,16(sp)
ffffffffc0209c2a:	842a                	mv	s0,a0
ffffffffc0209c2c:	7d08                	ld	a0,56(a0)
ffffffffc0209c2e:	e426                	sd	s1,8(sp)
ffffffffc0209c30:	ec06                	sd	ra,24(sp)
ffffffffc0209c32:	84ae                	mv	s1,a1
ffffffffc0209c34:	c62ff0ef          	jal	ra,ffffffffc0209096 <bitmap_alloc>
ffffffffc0209c38:	e90d                	bnez	a0,ffffffffc0209c6a <sfs_block_alloc+0x44>
ffffffffc0209c3a:	441c                	lw	a5,8(s0)
ffffffffc0209c3c:	cbad                	beqz	a5,ffffffffc0209cae <sfs_block_alloc+0x88>
ffffffffc0209c3e:	37fd                	addiw	a5,a5,-1
ffffffffc0209c40:	c41c                	sw	a5,8(s0)
ffffffffc0209c42:	408c                	lw	a1,0(s1)
ffffffffc0209c44:	4785                	li	a5,1
ffffffffc0209c46:	e03c                	sd	a5,64(s0)
ffffffffc0209c48:	4054                	lw	a3,4(s0)
ffffffffc0209c4a:	c58d                	beqz	a1,ffffffffc0209c74 <sfs_block_alloc+0x4e>
ffffffffc0209c4c:	02d5f463          	bgeu	a1,a3,ffffffffc0209c74 <sfs_block_alloc+0x4e>
ffffffffc0209c50:	7c08                	ld	a0,56(s0)
ffffffffc0209c52:	cb4ff0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc0209c56:	ed05                	bnez	a0,ffffffffc0209c8e <sfs_block_alloc+0x68>
ffffffffc0209c58:	8522                	mv	a0,s0
ffffffffc0209c5a:	6442                	ld	s0,16(sp)
ffffffffc0209c5c:	408c                	lw	a1,0(s1)
ffffffffc0209c5e:	60e2                	ld	ra,24(sp)
ffffffffc0209c60:	64a2                	ld	s1,8(sp)
ffffffffc0209c62:	4605                	li	a2,1
ffffffffc0209c64:	6105                	addi	sp,sp,32
ffffffffc0209c66:	3800106f          	j	ffffffffc020afe6 <sfs_clear_block>
ffffffffc0209c6a:	60e2                	ld	ra,24(sp)
ffffffffc0209c6c:	6442                	ld	s0,16(sp)
ffffffffc0209c6e:	64a2                	ld	s1,8(sp)
ffffffffc0209c70:	6105                	addi	sp,sp,32
ffffffffc0209c72:	8082                	ret
ffffffffc0209c74:	872e                	mv	a4,a1
ffffffffc0209c76:	00005617          	auipc	a2,0x5
ffffffffc0209c7a:	3ca60613          	addi	a2,a2,970 # ffffffffc020f040 <dev_node_ops+0x5f0>
ffffffffc0209c7e:	05300593          	li	a1,83
ffffffffc0209c82:	00005517          	auipc	a0,0x5
ffffffffc0209c86:	38e50513          	addi	a0,a0,910 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209c8a:	815f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209c8e:	00005697          	auipc	a3,0x5
ffffffffc0209c92:	44268693          	addi	a3,a3,1090 # ffffffffc020f0d0 <dev_node_ops+0x680>
ffffffffc0209c96:	00002617          	auipc	a2,0x2
ffffffffc0209c9a:	dea60613          	addi	a2,a2,-534 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209c9e:	06100593          	li	a1,97
ffffffffc0209ca2:	00005517          	auipc	a0,0x5
ffffffffc0209ca6:	36e50513          	addi	a0,a0,878 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209caa:	ff4f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209cae:	00005697          	auipc	a3,0x5
ffffffffc0209cb2:	40268693          	addi	a3,a3,1026 # ffffffffc020f0b0 <dev_node_ops+0x660>
ffffffffc0209cb6:	00002617          	auipc	a2,0x2
ffffffffc0209cba:	dca60613          	addi	a2,a2,-566 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209cbe:	05f00593          	li	a1,95
ffffffffc0209cc2:	00005517          	auipc	a0,0x5
ffffffffc0209cc6:	34e50513          	addi	a0,a0,846 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209cca:	fd4f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209cce <sfs_bmap_load_nolock>:
ffffffffc0209cce:	7159                	addi	sp,sp,-112
ffffffffc0209cd0:	f85a                	sd	s6,48(sp)
ffffffffc0209cd2:	0005bb03          	ld	s6,0(a1)
ffffffffc0209cd6:	f45e                	sd	s7,40(sp)
ffffffffc0209cd8:	f486                	sd	ra,104(sp)
ffffffffc0209cda:	008b2b83          	lw	s7,8(s6)
ffffffffc0209cde:	f0a2                	sd	s0,96(sp)
ffffffffc0209ce0:	eca6                	sd	s1,88(sp)
ffffffffc0209ce2:	e8ca                	sd	s2,80(sp)
ffffffffc0209ce4:	e4ce                	sd	s3,72(sp)
ffffffffc0209ce6:	e0d2                	sd	s4,64(sp)
ffffffffc0209ce8:	fc56                	sd	s5,56(sp)
ffffffffc0209cea:	f062                	sd	s8,32(sp)
ffffffffc0209cec:	ec66                	sd	s9,24(sp)
ffffffffc0209cee:	18cbe363          	bltu	s7,a2,ffffffffc0209e74 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209cf2:	47ad                	li	a5,11
ffffffffc0209cf4:	8aae                	mv	s5,a1
ffffffffc0209cf6:	8432                	mv	s0,a2
ffffffffc0209cf8:	84aa                	mv	s1,a0
ffffffffc0209cfa:	89b6                	mv	s3,a3
ffffffffc0209cfc:	04c7f563          	bgeu	a5,a2,ffffffffc0209d46 <sfs_bmap_load_nolock+0x78>
ffffffffc0209d00:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209d04:	0007069b          	sext.w	a3,a4
ffffffffc0209d08:	3ff00793          	li	a5,1023
ffffffffc0209d0c:	1ad7e163          	bltu	a5,a3,ffffffffc0209eae <sfs_bmap_load_nolock+0x1e0>
ffffffffc0209d10:	03cb2a03          	lw	s4,60(s6)
ffffffffc0209d14:	02071793          	slli	a5,a4,0x20
ffffffffc0209d18:	c602                	sw	zero,12(sp)
ffffffffc0209d1a:	c452                	sw	s4,8(sp)
ffffffffc0209d1c:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc0209d20:	0e0a1e63          	bnez	s4,ffffffffc0209e1c <sfs_bmap_load_nolock+0x14e>
ffffffffc0209d24:	0acb8663          	beq	s7,a2,ffffffffc0209dd0 <sfs_bmap_load_nolock+0x102>
ffffffffc0209d28:	4a01                	li	s4,0
ffffffffc0209d2a:	40d4                	lw	a3,4(s1)
ffffffffc0209d2c:	8752                	mv	a4,s4
ffffffffc0209d2e:	00005617          	auipc	a2,0x5
ffffffffc0209d32:	31260613          	addi	a2,a2,786 # ffffffffc020f040 <dev_node_ops+0x5f0>
ffffffffc0209d36:	05300593          	li	a1,83
ffffffffc0209d3a:	00005517          	auipc	a0,0x5
ffffffffc0209d3e:	2d650513          	addi	a0,a0,726 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209d42:	f5cf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209d46:	02061793          	slli	a5,a2,0x20
ffffffffc0209d4a:	01e7da13          	srli	s4,a5,0x1e
ffffffffc0209d4e:	9a5a                	add	s4,s4,s6
ffffffffc0209d50:	00ca2583          	lw	a1,12(s4)
ffffffffc0209d54:	c22e                	sw	a1,4(sp)
ffffffffc0209d56:	ed99                	bnez	a1,ffffffffc0209d74 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209d58:	fccb98e3          	bne	s7,a2,ffffffffc0209d28 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d5c:	004c                	addi	a1,sp,4
ffffffffc0209d5e:	ec9ff0ef          	jal	ra,ffffffffc0209c26 <sfs_block_alloc>
ffffffffc0209d62:	892a                	mv	s2,a0
ffffffffc0209d64:	e921                	bnez	a0,ffffffffc0209db4 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209d66:	4592                	lw	a1,4(sp)
ffffffffc0209d68:	4705                	li	a4,1
ffffffffc0209d6a:	00ba2623          	sw	a1,12(s4)
ffffffffc0209d6e:	00eab823          	sd	a4,16(s5)
ffffffffc0209d72:	d9dd                	beqz	a1,ffffffffc0209d28 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209d74:	40d4                	lw	a3,4(s1)
ffffffffc0209d76:	10d5ff63          	bgeu	a1,a3,ffffffffc0209e94 <sfs_bmap_load_nolock+0x1c6>
ffffffffc0209d7a:	7c88                	ld	a0,56(s1)
ffffffffc0209d7c:	b8aff0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc0209d80:	18051363          	bnez	a0,ffffffffc0209f06 <sfs_bmap_load_nolock+0x238>
ffffffffc0209d84:	4a12                	lw	s4,4(sp)
ffffffffc0209d86:	fa0a02e3          	beqz	s4,ffffffffc0209d2a <sfs_bmap_load_nolock+0x5c>
ffffffffc0209d8a:	40dc                	lw	a5,4(s1)
ffffffffc0209d8c:	f8fa7fe3          	bgeu	s4,a5,ffffffffc0209d2a <sfs_bmap_load_nolock+0x5c>
ffffffffc0209d90:	7c88                	ld	a0,56(s1)
ffffffffc0209d92:	85d2                	mv	a1,s4
ffffffffc0209d94:	b72ff0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc0209d98:	12051763          	bnez	a0,ffffffffc0209ec6 <sfs_bmap_load_nolock+0x1f8>
ffffffffc0209d9c:	008b9763          	bne	s7,s0,ffffffffc0209daa <sfs_bmap_load_nolock+0xdc>
ffffffffc0209da0:	008b2783          	lw	a5,8(s6)
ffffffffc0209da4:	2785                	addiw	a5,a5,1
ffffffffc0209da6:	00fb2423          	sw	a5,8(s6)
ffffffffc0209daa:	4901                	li	s2,0
ffffffffc0209dac:	00098463          	beqz	s3,ffffffffc0209db4 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209db0:	0149a023          	sw	s4,0(s3)
ffffffffc0209db4:	70a6                	ld	ra,104(sp)
ffffffffc0209db6:	7406                	ld	s0,96(sp)
ffffffffc0209db8:	64e6                	ld	s1,88(sp)
ffffffffc0209dba:	69a6                	ld	s3,72(sp)
ffffffffc0209dbc:	6a06                	ld	s4,64(sp)
ffffffffc0209dbe:	7ae2                	ld	s5,56(sp)
ffffffffc0209dc0:	7b42                	ld	s6,48(sp)
ffffffffc0209dc2:	7ba2                	ld	s7,40(sp)
ffffffffc0209dc4:	7c02                	ld	s8,32(sp)
ffffffffc0209dc6:	6ce2                	ld	s9,24(sp)
ffffffffc0209dc8:	854a                	mv	a0,s2
ffffffffc0209dca:	6946                	ld	s2,80(sp)
ffffffffc0209dcc:	6165                	addi	sp,sp,112
ffffffffc0209dce:	8082                	ret
ffffffffc0209dd0:	002c                	addi	a1,sp,8
ffffffffc0209dd2:	e55ff0ef          	jal	ra,ffffffffc0209c26 <sfs_block_alloc>
ffffffffc0209dd6:	892a                	mv	s2,a0
ffffffffc0209dd8:	00c10c93          	addi	s9,sp,12
ffffffffc0209ddc:	fd61                	bnez	a0,ffffffffc0209db4 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209dde:	85e6                	mv	a1,s9
ffffffffc0209de0:	8526                	mv	a0,s1
ffffffffc0209de2:	e45ff0ef          	jal	ra,ffffffffc0209c26 <sfs_block_alloc>
ffffffffc0209de6:	892a                	mv	s2,a0
ffffffffc0209de8:	e925                	bnez	a0,ffffffffc0209e58 <sfs_bmap_load_nolock+0x18a>
ffffffffc0209dea:	46a2                	lw	a3,8(sp)
ffffffffc0209dec:	85e6                	mv	a1,s9
ffffffffc0209dee:	8762                	mv	a4,s8
ffffffffc0209df0:	4611                	li	a2,4
ffffffffc0209df2:	8526                	mv	a0,s1
ffffffffc0209df4:	0a2010ef          	jal	ra,ffffffffc020ae96 <sfs_wbuf>
ffffffffc0209df8:	45b2                	lw	a1,12(sp)
ffffffffc0209dfa:	892a                	mv	s2,a0
ffffffffc0209dfc:	e939                	bnez	a0,ffffffffc0209e52 <sfs_bmap_load_nolock+0x184>
ffffffffc0209dfe:	03cb2683          	lw	a3,60(s6)
ffffffffc0209e02:	4722                	lw	a4,8(sp)
ffffffffc0209e04:	c22e                	sw	a1,4(sp)
ffffffffc0209e06:	f6d706e3          	beq	a4,a3,ffffffffc0209d72 <sfs_bmap_load_nolock+0xa4>
ffffffffc0209e0a:	eef1                	bnez	a3,ffffffffc0209ee6 <sfs_bmap_load_nolock+0x218>
ffffffffc0209e0c:	02eb2e23          	sw	a4,60(s6)
ffffffffc0209e10:	4705                	li	a4,1
ffffffffc0209e12:	00eab823          	sd	a4,16(s5)
ffffffffc0209e16:	f00589e3          	beqz	a1,ffffffffc0209d28 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209e1a:	bfa9                	j	ffffffffc0209d74 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209e1c:	00c10c93          	addi	s9,sp,12
ffffffffc0209e20:	8762                	mv	a4,s8
ffffffffc0209e22:	86d2                	mv	a3,s4
ffffffffc0209e24:	4611                	li	a2,4
ffffffffc0209e26:	85e6                	mv	a1,s9
ffffffffc0209e28:	7ef000ef          	jal	ra,ffffffffc020ae16 <sfs_rbuf>
ffffffffc0209e2c:	892a                	mv	s2,a0
ffffffffc0209e2e:	f159                	bnez	a0,ffffffffc0209db4 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209e30:	45b2                	lw	a1,12(sp)
ffffffffc0209e32:	e995                	bnez	a1,ffffffffc0209e66 <sfs_bmap_load_nolock+0x198>
ffffffffc0209e34:	fa8b85e3          	beq	s7,s0,ffffffffc0209dde <sfs_bmap_load_nolock+0x110>
ffffffffc0209e38:	03cb2703          	lw	a4,60(s6)
ffffffffc0209e3c:	47a2                	lw	a5,8(sp)
ffffffffc0209e3e:	c202                	sw	zero,4(sp)
ffffffffc0209e40:	eee784e3          	beq	a5,a4,ffffffffc0209d28 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209e44:	e34d                	bnez	a4,ffffffffc0209ee6 <sfs_bmap_load_nolock+0x218>
ffffffffc0209e46:	02fb2e23          	sw	a5,60(s6)
ffffffffc0209e4a:	4785                	li	a5,1
ffffffffc0209e4c:	00fab823          	sd	a5,16(s5)
ffffffffc0209e50:	bde1                	j	ffffffffc0209d28 <sfs_bmap_load_nolock+0x5a>
ffffffffc0209e52:	8526                	mv	a0,s1
ffffffffc0209e54:	bc1ff0ef          	jal	ra,ffffffffc0209a14 <sfs_block_free>
ffffffffc0209e58:	45a2                	lw	a1,8(sp)
ffffffffc0209e5a:	f4ba0de3          	beq	s4,a1,ffffffffc0209db4 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209e5e:	8526                	mv	a0,s1
ffffffffc0209e60:	bb5ff0ef          	jal	ra,ffffffffc0209a14 <sfs_block_free>
ffffffffc0209e64:	bf81                	j	ffffffffc0209db4 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209e66:	03cb2683          	lw	a3,60(s6)
ffffffffc0209e6a:	4722                	lw	a4,8(sp)
ffffffffc0209e6c:	c22e                	sw	a1,4(sp)
ffffffffc0209e6e:	f8e69ee3          	bne	a3,a4,ffffffffc0209e0a <sfs_bmap_load_nolock+0x13c>
ffffffffc0209e72:	b709                	j	ffffffffc0209d74 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209e74:	00005697          	auipc	a3,0x5
ffffffffc0209e78:	28468693          	addi	a3,a3,644 # ffffffffc020f0f8 <dev_node_ops+0x6a8>
ffffffffc0209e7c:	00002617          	auipc	a2,0x2
ffffffffc0209e80:	c0460613          	addi	a2,a2,-1020 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209e84:	16400593          	li	a1,356
ffffffffc0209e88:	00005517          	auipc	a0,0x5
ffffffffc0209e8c:	18850513          	addi	a0,a0,392 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209e90:	e0ef60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209e94:	872e                	mv	a4,a1
ffffffffc0209e96:	00005617          	auipc	a2,0x5
ffffffffc0209e9a:	1aa60613          	addi	a2,a2,426 # ffffffffc020f040 <dev_node_ops+0x5f0>
ffffffffc0209e9e:	05300593          	li	a1,83
ffffffffc0209ea2:	00005517          	auipc	a0,0x5
ffffffffc0209ea6:	16e50513          	addi	a0,a0,366 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209eaa:	df4f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209eae:	00005617          	auipc	a2,0x5
ffffffffc0209eb2:	27a60613          	addi	a2,a2,634 # ffffffffc020f128 <dev_node_ops+0x6d8>
ffffffffc0209eb6:	11e00593          	li	a1,286
ffffffffc0209eba:	00005517          	auipc	a0,0x5
ffffffffc0209ebe:	15650513          	addi	a0,a0,342 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209ec2:	ddcf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209ec6:	00005697          	auipc	a3,0x5
ffffffffc0209eca:	1b268693          	addi	a3,a3,434 # ffffffffc020f078 <dev_node_ops+0x628>
ffffffffc0209ece:	00002617          	auipc	a2,0x2
ffffffffc0209ed2:	bb260613          	addi	a2,a2,-1102 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209ed6:	16b00593          	li	a1,363
ffffffffc0209eda:	00005517          	auipc	a0,0x5
ffffffffc0209ede:	13650513          	addi	a0,a0,310 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209ee2:	dbcf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209ee6:	00005697          	auipc	a3,0x5
ffffffffc0209eea:	22a68693          	addi	a3,a3,554 # ffffffffc020f110 <dev_node_ops+0x6c0>
ffffffffc0209eee:	00002617          	auipc	a2,0x2
ffffffffc0209ef2:	b9260613          	addi	a2,a2,-1134 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209ef6:	11800593          	li	a1,280
ffffffffc0209efa:	00005517          	auipc	a0,0x5
ffffffffc0209efe:	11650513          	addi	a0,a0,278 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209f02:	d9cf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc0209f06:	00005697          	auipc	a3,0x5
ffffffffc0209f0a:	25268693          	addi	a3,a3,594 # ffffffffc020f158 <dev_node_ops+0x708>
ffffffffc0209f0e:	00002617          	auipc	a2,0x2
ffffffffc0209f12:	b7260613          	addi	a2,a2,-1166 # ffffffffc020ba80 <commands+0x210>
ffffffffc0209f16:	12100593          	li	a1,289
ffffffffc0209f1a:	00005517          	auipc	a0,0x5
ffffffffc0209f1e:	0f650513          	addi	a0,a0,246 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc0209f22:	d7cf60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc0209f26 <sfs_io_nolock>:
ffffffffc0209f26:	7135                	addi	sp,sp,-160
ffffffffc0209f28:	f0da                	sd	s6,96(sp)
ffffffffc0209f2a:	8b2e                	mv	s6,a1
ffffffffc0209f2c:	618c                	ld	a1,0(a1)
ffffffffc0209f2e:	ed06                	sd	ra,152(sp)
ffffffffc0209f30:	e922                	sd	s0,144(sp)
ffffffffc0209f32:	0045d883          	lhu	a7,4(a1)
ffffffffc0209f36:	e526                	sd	s1,136(sp)
ffffffffc0209f38:	e14a                	sd	s2,128(sp)
ffffffffc0209f3a:	fcce                	sd	s3,120(sp)
ffffffffc0209f3c:	f8d2                	sd	s4,112(sp)
ffffffffc0209f3e:	f4d6                	sd	s5,104(sp)
ffffffffc0209f40:	ecde                	sd	s7,88(sp)
ffffffffc0209f42:	e8e2                	sd	s8,80(sp)
ffffffffc0209f44:	e4e6                	sd	s9,72(sp)
ffffffffc0209f46:	e0ea                	sd	s10,64(sp)
ffffffffc0209f48:	fc6e                	sd	s11,56(sp)
ffffffffc0209f4a:	4809                	li	a6,2
ffffffffc0209f4c:	e43e                	sd	a5,8(sp)
ffffffffc0209f4e:	19088f63          	beq	a7,a6,ffffffffc020a0ec <sfs_io_nolock+0x1c6>
ffffffffc0209f52:	00073903          	ld	s2,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc0209f56:	080007b7          	lui	a5,0x8000
ffffffffc0209f5a:	00073023          	sd	zero,0(a4)
ffffffffc0209f5e:	8a36                	mv	s4,a3
ffffffffc0209f60:	8c3a                	mv	s8,a4
ffffffffc0209f62:	9936                	add	s2,s2,a3
ffffffffc0209f64:	18f6f263          	bgeu	a3,a5,ffffffffc020a0e8 <sfs_io_nolock+0x1c2>
ffffffffc0209f68:	18d94063          	blt	s2,a3,ffffffffc020a0e8 <sfs_io_nolock+0x1c2>
ffffffffc0209f6c:	89aa                	mv	s3,a0
ffffffffc0209f6e:	4501                	li	a0,0
ffffffffc0209f70:	0f268363          	beq	a3,s2,ffffffffc020a056 <sfs_io_nolock+0x130>
ffffffffc0209f74:	8432                	mv	s0,a2
ffffffffc0209f76:	0127f463          	bgeu	a5,s2,ffffffffc0209f7e <sfs_io_nolock+0x58>
ffffffffc0209f7a:	08000937          	lui	s2,0x8000
ffffffffc0209f7e:	67a2                	ld	a5,8(sp)
ffffffffc0209f80:	cbf5                	beqz	a5,ffffffffc020a074 <sfs_io_nolock+0x14e>
ffffffffc0209f82:	00001797          	auipc	a5,0x1
ffffffffc0209f86:	f1478793          	addi	a5,a5,-236 # ffffffffc020ae96 <sfs_wbuf>
ffffffffc0209f8a:	00001d17          	auipc	s10,0x1
ffffffffc0209f8e:	e2cd0d13          	addi	s10,s10,-468 # ffffffffc020adb6 <sfs_wblock>
ffffffffc0209f92:	e83e                	sd	a5,16(sp)
ffffffffc0209f94:	6685                	lui	a3,0x1
ffffffffc0209f96:	fff68c93          	addi	s9,a3,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209f9a:	40ca5713          	srai	a4,s4,0xc
ffffffffc0209f9e:	40c95a93          	srai	s5,s2,0xc
ffffffffc0209fa2:	019a7cb3          	and	s9,s4,s9
ffffffffc0209fa6:	00070d9b          	sext.w	s11,a4
ffffffffc0209faa:	000a8b9b          	sext.w	s7,s5
ffffffffc0209fae:	40ea8abb          	subw	s5,s5,a4
ffffffffc0209fb2:	8766                	mv	a4,s9
ffffffffc0209fb4:	0e0c8163          	beqz	s9,ffffffffc020a096 <sfs_io_nolock+0x170>
ffffffffc0209fb8:	41490cb3          	sub	s9,s2,s4
ffffffffc0209fbc:	0c0a9f63          	bnez	s5,ffffffffc020a09a <sfs_io_nolock+0x174>
ffffffffc0209fc0:	1074                	addi	a3,sp,44
ffffffffc0209fc2:	866e                	mv	a2,s11
ffffffffc0209fc4:	85da                	mv	a1,s6
ffffffffc0209fc6:	854e                	mv	a0,s3
ffffffffc0209fc8:	ec3a                	sd	a4,24(sp)
ffffffffc0209fca:	d05ff0ef          	jal	ra,ffffffffc0209cce <sfs_bmap_load_nolock>
ffffffffc0209fce:	4481                	li	s1,0
ffffffffc0209fd0:	e12d                	bnez	a0,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc0209fd2:	56b2                	lw	a3,44(sp)
ffffffffc0209fd4:	6762                	ld	a4,24(sp)
ffffffffc0209fd6:	67c2                	ld	a5,16(sp)
ffffffffc0209fd8:	8666                	mv	a2,s9
ffffffffc0209fda:	85a2                	mv	a1,s0
ffffffffc0209fdc:	854e                	mv	a0,s3
ffffffffc0209fde:	9782                	jalr	a5
ffffffffc0209fe0:	e929                	bnez	a0,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc0209fe2:	019a0733          	add	a4,s4,s9
ffffffffc0209fe6:	84e6                	mv	s1,s9
ffffffffc0209fe8:	05270563          	beq	a4,s2,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc0209fec:	2d85                	addiw	s11,s11,1
ffffffffc0209fee:	9466                	add	s0,s0,s9
ffffffffc0209ff0:	41bb8abb          	subw	s5,s7,s11
ffffffffc0209ff4:	0c0a8163          	beqz	s5,ffffffffc020a0b6 <sfs_io_nolock+0x190>
ffffffffc0209ff8:	84e6                	mv	s1,s9
ffffffffc0209ffa:	01ba8abb          	addw	s5,s5,s11
ffffffffc0209ffe:	6b85                	lui	s7,0x1
ffffffffc020a000:	41970cb3          	sub	s9,a4,s9
ffffffffc020a004:	a005                	j	ffffffffc020a024 <sfs_io_nolock+0xfe>
ffffffffc020a006:	5632                	lw	a2,44(sp)
ffffffffc020a008:	4685                	li	a3,1
ffffffffc020a00a:	85a2                	mv	a1,s0
ffffffffc020a00c:	854e                	mv	a0,s3
ffffffffc020a00e:	9d02                	jalr	s10
ffffffffc020a010:	e10d                	bnez	a0,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc020a012:	94de                	add	s1,s1,s7
ffffffffc020a014:	009c8733          	add	a4,s9,s1
ffffffffc020a018:	01270d63          	beq	a4,s2,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc020a01c:	2d85                	addiw	s11,s11,1
ffffffffc020a01e:	945e                	add	s0,s0,s7
ffffffffc020a020:	09ba8d63          	beq	s5,s11,ffffffffc020a0ba <sfs_io_nolock+0x194>
ffffffffc020a024:	1074                	addi	a3,sp,44
ffffffffc020a026:	866e                	mv	a2,s11
ffffffffc020a028:	85da                	mv	a1,s6
ffffffffc020a02a:	854e                	mv	a0,s3
ffffffffc020a02c:	ca3ff0ef          	jal	ra,ffffffffc0209cce <sfs_bmap_load_nolock>
ffffffffc020a030:	d979                	beqz	a0,ffffffffc020a006 <sfs_io_nolock+0xe0>
ffffffffc020a032:	67a2                	ld	a5,8(sp)
ffffffffc020a034:	009c3023          	sd	s1,0(s8)
ffffffffc020a038:	cf99                	beqz	a5,ffffffffc020a056 <sfs_io_nolock+0x130>
ffffffffc020a03a:	000b3703          	ld	a4,0(s6)
ffffffffc020a03e:	009a07b3          	add	a5,s4,s1
ffffffffc020a042:	00076683          	lwu	a3,0(a4)
ffffffffc020a046:	00f6f863          	bgeu	a3,a5,ffffffffc020a056 <sfs_io_nolock+0x130>
ffffffffc020a04a:	009a04bb          	addw	s1,s4,s1
ffffffffc020a04e:	c304                	sw	s1,0(a4)
ffffffffc020a050:	4785                	li	a5,1
ffffffffc020a052:	00fb3823          	sd	a5,16(s6)
ffffffffc020a056:	60ea                	ld	ra,152(sp)
ffffffffc020a058:	644a                	ld	s0,144(sp)
ffffffffc020a05a:	64aa                	ld	s1,136(sp)
ffffffffc020a05c:	690a                	ld	s2,128(sp)
ffffffffc020a05e:	79e6                	ld	s3,120(sp)
ffffffffc020a060:	7a46                	ld	s4,112(sp)
ffffffffc020a062:	7aa6                	ld	s5,104(sp)
ffffffffc020a064:	7b06                	ld	s6,96(sp)
ffffffffc020a066:	6be6                	ld	s7,88(sp)
ffffffffc020a068:	6c46                	ld	s8,80(sp)
ffffffffc020a06a:	6ca6                	ld	s9,72(sp)
ffffffffc020a06c:	6d06                	ld	s10,64(sp)
ffffffffc020a06e:	7de2                	ld	s11,56(sp)
ffffffffc020a070:	610d                	addi	sp,sp,160
ffffffffc020a072:	8082                	ret
ffffffffc020a074:	0005e783          	lwu	a5,0(a1)
ffffffffc020a078:	4501                	li	a0,0
ffffffffc020a07a:	fcfa5ee3          	bge	s4,a5,ffffffffc020a056 <sfs_io_nolock+0x130>
ffffffffc020a07e:	0327c163          	blt	a5,s2,ffffffffc020a0a0 <sfs_io_nolock+0x17a>
ffffffffc020a082:	00001797          	auipc	a5,0x1
ffffffffc020a086:	d9478793          	addi	a5,a5,-620 # ffffffffc020ae16 <sfs_rbuf>
ffffffffc020a08a:	00001d17          	auipc	s10,0x1
ffffffffc020a08e:	cccd0d13          	addi	s10,s10,-820 # ffffffffc020ad56 <sfs_rblock>
ffffffffc020a092:	e83e                	sd	a5,16(sp)
ffffffffc020a094:	b701                	j	ffffffffc0209f94 <sfs_io_nolock+0x6e>
ffffffffc020a096:	8752                	mv	a4,s4
ffffffffc020a098:	bfb1                	j	ffffffffc0209ff4 <sfs_io_nolock+0xce>
ffffffffc020a09a:	40e68cb3          	sub	s9,a3,a4
ffffffffc020a09e:	b70d                	j	ffffffffc0209fc0 <sfs_io_nolock+0x9a>
ffffffffc020a0a0:	893e                	mv	s2,a5
ffffffffc020a0a2:	00001797          	auipc	a5,0x1
ffffffffc020a0a6:	d7478793          	addi	a5,a5,-652 # ffffffffc020ae16 <sfs_rbuf>
ffffffffc020a0aa:	00001d17          	auipc	s10,0x1
ffffffffc020a0ae:	cacd0d13          	addi	s10,s10,-852 # ffffffffc020ad56 <sfs_rblock>
ffffffffc020a0b2:	e83e                	sd	a5,16(sp)
ffffffffc020a0b4:	b5c5                	j	ffffffffc0209f94 <sfs_io_nolock+0x6e>
ffffffffc020a0b6:	8aee                	mv	s5,s11
ffffffffc020a0b8:	84e6                	mv	s1,s9
ffffffffc020a0ba:	1952                	slli	s2,s2,0x34
ffffffffc020a0bc:	03495b93          	srli	s7,s2,0x34
ffffffffc020a0c0:	4501                	li	a0,0
ffffffffc020a0c2:	f60908e3          	beqz	s2,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc020a0c6:	1074                	addi	a3,sp,44
ffffffffc020a0c8:	8656                	mv	a2,s5
ffffffffc020a0ca:	85da                	mv	a1,s6
ffffffffc020a0cc:	854e                	mv	a0,s3
ffffffffc020a0ce:	c01ff0ef          	jal	ra,ffffffffc0209cce <sfs_bmap_load_nolock>
ffffffffc020a0d2:	f125                	bnez	a0,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc020a0d4:	56b2                	lw	a3,44(sp)
ffffffffc020a0d6:	67c2                	ld	a5,16(sp)
ffffffffc020a0d8:	4701                	li	a4,0
ffffffffc020a0da:	865e                	mv	a2,s7
ffffffffc020a0dc:	85a2                	mv	a1,s0
ffffffffc020a0de:	854e                	mv	a0,s3
ffffffffc020a0e0:	9782                	jalr	a5
ffffffffc020a0e2:	f921                	bnez	a0,ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc020a0e4:	94de                	add	s1,s1,s7
ffffffffc020a0e6:	b7b1                	j	ffffffffc020a032 <sfs_io_nolock+0x10c>
ffffffffc020a0e8:	5575                	li	a0,-3
ffffffffc020a0ea:	b7b5                	j	ffffffffc020a056 <sfs_io_nolock+0x130>
ffffffffc020a0ec:	00005697          	auipc	a3,0x5
ffffffffc020a0f0:	09468693          	addi	a3,a3,148 # ffffffffc020f180 <dev_node_ops+0x730>
ffffffffc020a0f4:	00002617          	auipc	a2,0x2
ffffffffc020a0f8:	98c60613          	addi	a2,a2,-1652 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a0fc:	22b00593          	li	a1,555
ffffffffc020a100:	00005517          	auipc	a0,0x5
ffffffffc020a104:	f1050513          	addi	a0,a0,-240 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a108:	b96f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a10c <sfs_read>:
ffffffffc020a10c:	7139                	addi	sp,sp,-64
ffffffffc020a10e:	f04a                	sd	s2,32(sp)
ffffffffc020a110:	06853903          	ld	s2,104(a0)
ffffffffc020a114:	fc06                	sd	ra,56(sp)
ffffffffc020a116:	f822                	sd	s0,48(sp)
ffffffffc020a118:	f426                	sd	s1,40(sp)
ffffffffc020a11a:	ec4e                	sd	s3,24(sp)
ffffffffc020a11c:	04090f63          	beqz	s2,ffffffffc020a17a <sfs_read+0x6e>
ffffffffc020a120:	0b092783          	lw	a5,176(s2) # 80000b0 <_binary_bin_sfs_img_size+0x7f8adb0>
ffffffffc020a124:	ebb9                	bnez	a5,ffffffffc020a17a <sfs_read+0x6e>
ffffffffc020a126:	4d38                	lw	a4,88(a0)
ffffffffc020a128:	6785                	lui	a5,0x1
ffffffffc020a12a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a12e:	842a                	mv	s0,a0
ffffffffc020a130:	06f71563          	bne	a4,a5,ffffffffc020a19a <sfs_read+0x8e>
ffffffffc020a134:	02050993          	addi	s3,a0,32
ffffffffc020a138:	854e                	mv	a0,s3
ffffffffc020a13a:	84ae                	mv	s1,a1
ffffffffc020a13c:	ca6fa0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc020a140:	0184b803          	ld	a6,24(s1)
ffffffffc020a144:	6494                	ld	a3,8(s1)
ffffffffc020a146:	6090                	ld	a2,0(s1)
ffffffffc020a148:	85a2                	mv	a1,s0
ffffffffc020a14a:	4781                	li	a5,0
ffffffffc020a14c:	0038                	addi	a4,sp,8
ffffffffc020a14e:	854a                	mv	a0,s2
ffffffffc020a150:	e442                	sd	a6,8(sp)
ffffffffc020a152:	dd5ff0ef          	jal	ra,ffffffffc0209f26 <sfs_io_nolock>
ffffffffc020a156:	65a2                	ld	a1,8(sp)
ffffffffc020a158:	842a                	mv	s0,a0
ffffffffc020a15a:	ed81                	bnez	a1,ffffffffc020a172 <sfs_read+0x66>
ffffffffc020a15c:	854e                	mv	a0,s3
ffffffffc020a15e:	c80fa0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020a162:	70e2                	ld	ra,56(sp)
ffffffffc020a164:	8522                	mv	a0,s0
ffffffffc020a166:	7442                	ld	s0,48(sp)
ffffffffc020a168:	74a2                	ld	s1,40(sp)
ffffffffc020a16a:	7902                	ld	s2,32(sp)
ffffffffc020a16c:	69e2                	ld	s3,24(sp)
ffffffffc020a16e:	6121                	addi	sp,sp,64
ffffffffc020a170:	8082                	ret
ffffffffc020a172:	8526                	mv	a0,s1
ffffffffc020a174:	b62fb0ef          	jal	ra,ffffffffc02054d6 <iobuf_skip>
ffffffffc020a178:	b7d5                	j	ffffffffc020a15c <sfs_read+0x50>
ffffffffc020a17a:	00005697          	auipc	a3,0x5
ffffffffc020a17e:	cb668693          	addi	a3,a3,-842 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc020a182:	00002617          	auipc	a2,0x2
ffffffffc020a186:	8fe60613          	addi	a2,a2,-1794 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a18a:	29d00593          	li	a1,669
ffffffffc020a18e:	00005517          	auipc	a0,0x5
ffffffffc020a192:	e8250513          	addi	a0,a0,-382 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a196:	b08f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a19a:	857ff0ef          	jal	ra,ffffffffc02099f0 <sfs_io.part.0>

ffffffffc020a19e <sfs_write>:
ffffffffc020a19e:	7139                	addi	sp,sp,-64
ffffffffc020a1a0:	f04a                	sd	s2,32(sp)
ffffffffc020a1a2:	06853903          	ld	s2,104(a0)
ffffffffc020a1a6:	fc06                	sd	ra,56(sp)
ffffffffc020a1a8:	f822                	sd	s0,48(sp)
ffffffffc020a1aa:	f426                	sd	s1,40(sp)
ffffffffc020a1ac:	ec4e                	sd	s3,24(sp)
ffffffffc020a1ae:	04090f63          	beqz	s2,ffffffffc020a20c <sfs_write+0x6e>
ffffffffc020a1b2:	0b092783          	lw	a5,176(s2)
ffffffffc020a1b6:	ebb9                	bnez	a5,ffffffffc020a20c <sfs_write+0x6e>
ffffffffc020a1b8:	4d38                	lw	a4,88(a0)
ffffffffc020a1ba:	6785                	lui	a5,0x1
ffffffffc020a1bc:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a1c0:	842a                	mv	s0,a0
ffffffffc020a1c2:	06f71563          	bne	a4,a5,ffffffffc020a22c <sfs_write+0x8e>
ffffffffc020a1c6:	02050993          	addi	s3,a0,32
ffffffffc020a1ca:	854e                	mv	a0,s3
ffffffffc020a1cc:	84ae                	mv	s1,a1
ffffffffc020a1ce:	c14fa0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc020a1d2:	0184b803          	ld	a6,24(s1)
ffffffffc020a1d6:	6494                	ld	a3,8(s1)
ffffffffc020a1d8:	6090                	ld	a2,0(s1)
ffffffffc020a1da:	85a2                	mv	a1,s0
ffffffffc020a1dc:	4785                	li	a5,1
ffffffffc020a1de:	0038                	addi	a4,sp,8
ffffffffc020a1e0:	854a                	mv	a0,s2
ffffffffc020a1e2:	e442                	sd	a6,8(sp)
ffffffffc020a1e4:	d43ff0ef          	jal	ra,ffffffffc0209f26 <sfs_io_nolock>
ffffffffc020a1e8:	65a2                	ld	a1,8(sp)
ffffffffc020a1ea:	842a                	mv	s0,a0
ffffffffc020a1ec:	ed81                	bnez	a1,ffffffffc020a204 <sfs_write+0x66>
ffffffffc020a1ee:	854e                	mv	a0,s3
ffffffffc020a1f0:	beefa0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020a1f4:	70e2                	ld	ra,56(sp)
ffffffffc020a1f6:	8522                	mv	a0,s0
ffffffffc020a1f8:	7442                	ld	s0,48(sp)
ffffffffc020a1fa:	74a2                	ld	s1,40(sp)
ffffffffc020a1fc:	7902                	ld	s2,32(sp)
ffffffffc020a1fe:	69e2                	ld	s3,24(sp)
ffffffffc020a200:	6121                	addi	sp,sp,64
ffffffffc020a202:	8082                	ret
ffffffffc020a204:	8526                	mv	a0,s1
ffffffffc020a206:	ad0fb0ef          	jal	ra,ffffffffc02054d6 <iobuf_skip>
ffffffffc020a20a:	b7d5                	j	ffffffffc020a1ee <sfs_write+0x50>
ffffffffc020a20c:	00005697          	auipc	a3,0x5
ffffffffc020a210:	c2468693          	addi	a3,a3,-988 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc020a214:	00002617          	auipc	a2,0x2
ffffffffc020a218:	86c60613          	addi	a2,a2,-1940 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a21c:	29d00593          	li	a1,669
ffffffffc020a220:	00005517          	auipc	a0,0x5
ffffffffc020a224:	df050513          	addi	a0,a0,-528 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a228:	a76f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a22c:	fc4ff0ef          	jal	ra,ffffffffc02099f0 <sfs_io.part.0>

ffffffffc020a230 <sfs_dirent_read_nolock>:
ffffffffc020a230:	6198                	ld	a4,0(a1)
ffffffffc020a232:	7179                	addi	sp,sp,-48
ffffffffc020a234:	f406                	sd	ra,40(sp)
ffffffffc020a236:	00475883          	lhu	a7,4(a4)
ffffffffc020a23a:	f022                	sd	s0,32(sp)
ffffffffc020a23c:	ec26                	sd	s1,24(sp)
ffffffffc020a23e:	4809                	li	a6,2
ffffffffc020a240:	05089b63          	bne	a7,a6,ffffffffc020a296 <sfs_dirent_read_nolock+0x66>
ffffffffc020a244:	4718                	lw	a4,8(a4)
ffffffffc020a246:	87b2                	mv	a5,a2
ffffffffc020a248:	2601                	sext.w	a2,a2
ffffffffc020a24a:	04e7f663          	bgeu	a5,a4,ffffffffc020a296 <sfs_dirent_read_nolock+0x66>
ffffffffc020a24e:	84b6                	mv	s1,a3
ffffffffc020a250:	0074                	addi	a3,sp,12
ffffffffc020a252:	842a                	mv	s0,a0
ffffffffc020a254:	a7bff0ef          	jal	ra,ffffffffc0209cce <sfs_bmap_load_nolock>
ffffffffc020a258:	c511                	beqz	a0,ffffffffc020a264 <sfs_dirent_read_nolock+0x34>
ffffffffc020a25a:	70a2                	ld	ra,40(sp)
ffffffffc020a25c:	7402                	ld	s0,32(sp)
ffffffffc020a25e:	64e2                	ld	s1,24(sp)
ffffffffc020a260:	6145                	addi	sp,sp,48
ffffffffc020a262:	8082                	ret
ffffffffc020a264:	45b2                	lw	a1,12(sp)
ffffffffc020a266:	4054                	lw	a3,4(s0)
ffffffffc020a268:	c5b9                	beqz	a1,ffffffffc020a2b6 <sfs_dirent_read_nolock+0x86>
ffffffffc020a26a:	04d5f663          	bgeu	a1,a3,ffffffffc020a2b6 <sfs_dirent_read_nolock+0x86>
ffffffffc020a26e:	7c08                	ld	a0,56(s0)
ffffffffc020a270:	e97fe0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc020a274:	ed31                	bnez	a0,ffffffffc020a2d0 <sfs_dirent_read_nolock+0xa0>
ffffffffc020a276:	46b2                	lw	a3,12(sp)
ffffffffc020a278:	4701                	li	a4,0
ffffffffc020a27a:	10400613          	li	a2,260
ffffffffc020a27e:	85a6                	mv	a1,s1
ffffffffc020a280:	8522                	mv	a0,s0
ffffffffc020a282:	395000ef          	jal	ra,ffffffffc020ae16 <sfs_rbuf>
ffffffffc020a286:	f971                	bnez	a0,ffffffffc020a25a <sfs_dirent_read_nolock+0x2a>
ffffffffc020a288:	100481a3          	sb	zero,259(s1)
ffffffffc020a28c:	70a2                	ld	ra,40(sp)
ffffffffc020a28e:	7402                	ld	s0,32(sp)
ffffffffc020a290:	64e2                	ld	s1,24(sp)
ffffffffc020a292:	6145                	addi	sp,sp,48
ffffffffc020a294:	8082                	ret
ffffffffc020a296:	00005697          	auipc	a3,0x5
ffffffffc020a29a:	f0a68693          	addi	a3,a3,-246 # ffffffffc020f1a0 <dev_node_ops+0x750>
ffffffffc020a29e:	00001617          	auipc	a2,0x1
ffffffffc020a2a2:	7e260613          	addi	a2,a2,2018 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a2a6:	18e00593          	li	a1,398
ffffffffc020a2aa:	00005517          	auipc	a0,0x5
ffffffffc020a2ae:	d6650513          	addi	a0,a0,-666 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a2b2:	9ecf60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a2b6:	872e                	mv	a4,a1
ffffffffc020a2b8:	00005617          	auipc	a2,0x5
ffffffffc020a2bc:	d8860613          	addi	a2,a2,-632 # ffffffffc020f040 <dev_node_ops+0x5f0>
ffffffffc020a2c0:	05300593          	li	a1,83
ffffffffc020a2c4:	00005517          	auipc	a0,0x5
ffffffffc020a2c8:	d4c50513          	addi	a0,a0,-692 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a2cc:	9d2f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a2d0:	00005697          	auipc	a3,0x5
ffffffffc020a2d4:	da868693          	addi	a3,a3,-600 # ffffffffc020f078 <dev_node_ops+0x628>
ffffffffc020a2d8:	00001617          	auipc	a2,0x1
ffffffffc020a2dc:	7a860613          	addi	a2,a2,1960 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a2e0:	19500593          	li	a1,405
ffffffffc020a2e4:	00005517          	auipc	a0,0x5
ffffffffc020a2e8:	d2c50513          	addi	a0,a0,-724 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a2ec:	9b2f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a2f0 <sfs_getdirentry>:
ffffffffc020a2f0:	715d                	addi	sp,sp,-80
ffffffffc020a2f2:	ec56                	sd	s5,24(sp)
ffffffffc020a2f4:	8aaa                	mv	s5,a0
ffffffffc020a2f6:	10400513          	li	a0,260
ffffffffc020a2fa:	e85a                	sd	s6,16(sp)
ffffffffc020a2fc:	e486                	sd	ra,72(sp)
ffffffffc020a2fe:	e0a2                	sd	s0,64(sp)
ffffffffc020a300:	fc26                	sd	s1,56(sp)
ffffffffc020a302:	f84a                	sd	s2,48(sp)
ffffffffc020a304:	f44e                	sd	s3,40(sp)
ffffffffc020a306:	f052                	sd	s4,32(sp)
ffffffffc020a308:	e45e                	sd	s7,8(sp)
ffffffffc020a30a:	e062                	sd	s8,0(sp)
ffffffffc020a30c:	8b2e                	mv	s6,a1
ffffffffc020a30e:	c81f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a312:	cd61                	beqz	a0,ffffffffc020a3ea <sfs_getdirentry+0xfa>
ffffffffc020a314:	068abb83          	ld	s7,104(s5)
ffffffffc020a318:	0c0b8b63          	beqz	s7,ffffffffc020a3ee <sfs_getdirentry+0xfe>
ffffffffc020a31c:	0b0ba783          	lw	a5,176(s7) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a320:	e7f9                	bnez	a5,ffffffffc020a3ee <sfs_getdirentry+0xfe>
ffffffffc020a322:	058aa703          	lw	a4,88(s5)
ffffffffc020a326:	6785                	lui	a5,0x1
ffffffffc020a328:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a32c:	0ef71163          	bne	a4,a5,ffffffffc020a40e <sfs_getdirentry+0x11e>
ffffffffc020a330:	008b3983          	ld	s3,8(s6)
ffffffffc020a334:	892a                	mv	s2,a0
ffffffffc020a336:	0a09c163          	bltz	s3,ffffffffc020a3d8 <sfs_getdirentry+0xe8>
ffffffffc020a33a:	0ff9f793          	zext.b	a5,s3
ffffffffc020a33e:	efc9                	bnez	a5,ffffffffc020a3d8 <sfs_getdirentry+0xe8>
ffffffffc020a340:	000ab783          	ld	a5,0(s5)
ffffffffc020a344:	0089d993          	srli	s3,s3,0x8
ffffffffc020a348:	2981                	sext.w	s3,s3
ffffffffc020a34a:	479c                	lw	a5,8(a5)
ffffffffc020a34c:	0937eb63          	bltu	a5,s3,ffffffffc020a3e2 <sfs_getdirentry+0xf2>
ffffffffc020a350:	020a8c13          	addi	s8,s5,32
ffffffffc020a354:	8562                	mv	a0,s8
ffffffffc020a356:	a8cfa0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc020a35a:	000ab783          	ld	a5,0(s5)
ffffffffc020a35e:	0087aa03          	lw	s4,8(a5)
ffffffffc020a362:	07405663          	blez	s4,ffffffffc020a3ce <sfs_getdirentry+0xde>
ffffffffc020a366:	4481                	li	s1,0
ffffffffc020a368:	a811                	j	ffffffffc020a37c <sfs_getdirentry+0x8c>
ffffffffc020a36a:	00092783          	lw	a5,0(s2)
ffffffffc020a36e:	c781                	beqz	a5,ffffffffc020a376 <sfs_getdirentry+0x86>
ffffffffc020a370:	02098263          	beqz	s3,ffffffffc020a394 <sfs_getdirentry+0xa4>
ffffffffc020a374:	39fd                	addiw	s3,s3,-1
ffffffffc020a376:	2485                	addiw	s1,s1,1
ffffffffc020a378:	049a0b63          	beq	s4,s1,ffffffffc020a3ce <sfs_getdirentry+0xde>
ffffffffc020a37c:	86ca                	mv	a3,s2
ffffffffc020a37e:	8626                	mv	a2,s1
ffffffffc020a380:	85d6                	mv	a1,s5
ffffffffc020a382:	855e                	mv	a0,s7
ffffffffc020a384:	eadff0ef          	jal	ra,ffffffffc020a230 <sfs_dirent_read_nolock>
ffffffffc020a388:	842a                	mv	s0,a0
ffffffffc020a38a:	d165                	beqz	a0,ffffffffc020a36a <sfs_getdirentry+0x7a>
ffffffffc020a38c:	8562                	mv	a0,s8
ffffffffc020a38e:	a50fa0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020a392:	a831                	j	ffffffffc020a3ae <sfs_getdirentry+0xbe>
ffffffffc020a394:	8562                	mv	a0,s8
ffffffffc020a396:	a48fa0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020a39a:	4701                	li	a4,0
ffffffffc020a39c:	4685                	li	a3,1
ffffffffc020a39e:	10000613          	li	a2,256
ffffffffc020a3a2:	00490593          	addi	a1,s2,4
ffffffffc020a3a6:	855a                	mv	a0,s6
ffffffffc020a3a8:	8c2fb0ef          	jal	ra,ffffffffc020546a <iobuf_move>
ffffffffc020a3ac:	842a                	mv	s0,a0
ffffffffc020a3ae:	854a                	mv	a0,s2
ffffffffc020a3b0:	c8ff70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a3b4:	60a6                	ld	ra,72(sp)
ffffffffc020a3b6:	8522                	mv	a0,s0
ffffffffc020a3b8:	6406                	ld	s0,64(sp)
ffffffffc020a3ba:	74e2                	ld	s1,56(sp)
ffffffffc020a3bc:	7942                	ld	s2,48(sp)
ffffffffc020a3be:	79a2                	ld	s3,40(sp)
ffffffffc020a3c0:	7a02                	ld	s4,32(sp)
ffffffffc020a3c2:	6ae2                	ld	s5,24(sp)
ffffffffc020a3c4:	6b42                	ld	s6,16(sp)
ffffffffc020a3c6:	6ba2                	ld	s7,8(sp)
ffffffffc020a3c8:	6c02                	ld	s8,0(sp)
ffffffffc020a3ca:	6161                	addi	sp,sp,80
ffffffffc020a3cc:	8082                	ret
ffffffffc020a3ce:	8562                	mv	a0,s8
ffffffffc020a3d0:	5441                	li	s0,-16
ffffffffc020a3d2:	a0cfa0ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020a3d6:	bfe1                	j	ffffffffc020a3ae <sfs_getdirentry+0xbe>
ffffffffc020a3d8:	854a                	mv	a0,s2
ffffffffc020a3da:	c65f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a3de:	5475                	li	s0,-3
ffffffffc020a3e0:	bfd1                	j	ffffffffc020a3b4 <sfs_getdirentry+0xc4>
ffffffffc020a3e2:	c5df70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a3e6:	5441                	li	s0,-16
ffffffffc020a3e8:	b7f1                	j	ffffffffc020a3b4 <sfs_getdirentry+0xc4>
ffffffffc020a3ea:	5471                	li	s0,-4
ffffffffc020a3ec:	b7e1                	j	ffffffffc020a3b4 <sfs_getdirentry+0xc4>
ffffffffc020a3ee:	00005697          	auipc	a3,0x5
ffffffffc020a3f2:	a4268693          	addi	a3,a3,-1470 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc020a3f6:	00001617          	auipc	a2,0x1
ffffffffc020a3fa:	68a60613          	addi	a2,a2,1674 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a3fe:	34000593          	li	a1,832
ffffffffc020a402:	00005517          	auipc	a0,0x5
ffffffffc020a406:	c0e50513          	addi	a0,a0,-1010 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a40a:	894f60ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a40e:	00005697          	auipc	a3,0x5
ffffffffc020a412:	bca68693          	addi	a3,a3,-1078 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020a416:	00001617          	auipc	a2,0x1
ffffffffc020a41a:	66a60613          	addi	a2,a2,1642 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a41e:	34100593          	li	a1,833
ffffffffc020a422:	00005517          	auipc	a0,0x5
ffffffffc020a426:	bee50513          	addi	a0,a0,-1042 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a42a:	874f60ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a42e <sfs_dirent_search_nolock.constprop.0>:
ffffffffc020a42e:	715d                	addi	sp,sp,-80
ffffffffc020a430:	f052                	sd	s4,32(sp)
ffffffffc020a432:	8a2a                	mv	s4,a0
ffffffffc020a434:	8532                	mv	a0,a2
ffffffffc020a436:	f44e                	sd	s3,40(sp)
ffffffffc020a438:	e85a                	sd	s6,16(sp)
ffffffffc020a43a:	e45e                	sd	s7,8(sp)
ffffffffc020a43c:	e486                	sd	ra,72(sp)
ffffffffc020a43e:	e0a2                	sd	s0,64(sp)
ffffffffc020a440:	fc26                	sd	s1,56(sp)
ffffffffc020a442:	f84a                	sd	s2,48(sp)
ffffffffc020a444:	ec56                	sd	s5,24(sp)
ffffffffc020a446:	e062                	sd	s8,0(sp)
ffffffffc020a448:	8b32                	mv	s6,a2
ffffffffc020a44a:	89ae                	mv	s3,a1
ffffffffc020a44c:	8bb6                	mv	s7,a3
ffffffffc020a44e:	0aa010ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc020a452:	0ff00793          	li	a5,255
ffffffffc020a456:	06a7ef63          	bltu	a5,a0,ffffffffc020a4d4 <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc020a45a:	10400513          	li	a0,260
ffffffffc020a45e:	b31f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a462:	892a                	mv	s2,a0
ffffffffc020a464:	c535                	beqz	a0,ffffffffc020a4d0 <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc020a466:	0009b783          	ld	a5,0(s3)
ffffffffc020a46a:	0087aa83          	lw	s5,8(a5)
ffffffffc020a46e:	05505a63          	blez	s5,ffffffffc020a4c2 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a472:	4481                	li	s1,0
ffffffffc020a474:	00450c13          	addi	s8,a0,4
ffffffffc020a478:	a829                	j	ffffffffc020a492 <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc020a47a:	00092783          	lw	a5,0(s2)
ffffffffc020a47e:	c799                	beqz	a5,ffffffffc020a48c <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc020a480:	85e2                	mv	a1,s8
ffffffffc020a482:	855a                	mv	a0,s6
ffffffffc020a484:	0bc010ef          	jal	ra,ffffffffc020b540 <strcmp>
ffffffffc020a488:	842a                	mv	s0,a0
ffffffffc020a48a:	cd15                	beqz	a0,ffffffffc020a4c6 <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc020a48c:	2485                	addiw	s1,s1,1
ffffffffc020a48e:	029a8a63          	beq	s5,s1,ffffffffc020a4c2 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc020a492:	86ca                	mv	a3,s2
ffffffffc020a494:	8626                	mv	a2,s1
ffffffffc020a496:	85ce                	mv	a1,s3
ffffffffc020a498:	8552                	mv	a0,s4
ffffffffc020a49a:	d97ff0ef          	jal	ra,ffffffffc020a230 <sfs_dirent_read_nolock>
ffffffffc020a49e:	842a                	mv	s0,a0
ffffffffc020a4a0:	dd69                	beqz	a0,ffffffffc020a47a <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc020a4a2:	854a                	mv	a0,s2
ffffffffc020a4a4:	b9bf70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a4a8:	60a6                	ld	ra,72(sp)
ffffffffc020a4aa:	8522                	mv	a0,s0
ffffffffc020a4ac:	6406                	ld	s0,64(sp)
ffffffffc020a4ae:	74e2                	ld	s1,56(sp)
ffffffffc020a4b0:	7942                	ld	s2,48(sp)
ffffffffc020a4b2:	79a2                	ld	s3,40(sp)
ffffffffc020a4b4:	7a02                	ld	s4,32(sp)
ffffffffc020a4b6:	6ae2                	ld	s5,24(sp)
ffffffffc020a4b8:	6b42                	ld	s6,16(sp)
ffffffffc020a4ba:	6ba2                	ld	s7,8(sp)
ffffffffc020a4bc:	6c02                	ld	s8,0(sp)
ffffffffc020a4be:	6161                	addi	sp,sp,80
ffffffffc020a4c0:	8082                	ret
ffffffffc020a4c2:	5441                	li	s0,-16
ffffffffc020a4c4:	bff9                	j	ffffffffc020a4a2 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a4c6:	00092783          	lw	a5,0(s2)
ffffffffc020a4ca:	00fba023          	sw	a5,0(s7)
ffffffffc020a4ce:	bfd1                	j	ffffffffc020a4a2 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc020a4d0:	5471                	li	s0,-4
ffffffffc020a4d2:	bfd9                	j	ffffffffc020a4a8 <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc020a4d4:	00005697          	auipc	a3,0x5
ffffffffc020a4d8:	d1c68693          	addi	a3,a3,-740 # ffffffffc020f1f0 <dev_node_ops+0x7a0>
ffffffffc020a4dc:	00001617          	auipc	a2,0x1
ffffffffc020a4e0:	5a460613          	addi	a2,a2,1444 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a4e4:	1ba00593          	li	a1,442
ffffffffc020a4e8:	00005517          	auipc	a0,0x5
ffffffffc020a4ec:	b2850513          	addi	a0,a0,-1240 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a4f0:	faff50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a4f4 <sfs_truncfile>:
ffffffffc020a4f4:	7175                	addi	sp,sp,-144
ffffffffc020a4f6:	e506                	sd	ra,136(sp)
ffffffffc020a4f8:	e122                	sd	s0,128(sp)
ffffffffc020a4fa:	fca6                	sd	s1,120(sp)
ffffffffc020a4fc:	f8ca                	sd	s2,112(sp)
ffffffffc020a4fe:	f4ce                	sd	s3,104(sp)
ffffffffc020a500:	f0d2                	sd	s4,96(sp)
ffffffffc020a502:	ecd6                	sd	s5,88(sp)
ffffffffc020a504:	e8da                	sd	s6,80(sp)
ffffffffc020a506:	e4de                	sd	s7,72(sp)
ffffffffc020a508:	e0e2                	sd	s8,64(sp)
ffffffffc020a50a:	fc66                	sd	s9,56(sp)
ffffffffc020a50c:	f86a                	sd	s10,48(sp)
ffffffffc020a50e:	f46e                	sd	s11,40(sp)
ffffffffc020a510:	080007b7          	lui	a5,0x8000
ffffffffc020a514:	16b7e463          	bltu	a5,a1,ffffffffc020a67c <sfs_truncfile+0x188>
ffffffffc020a518:	06853c83          	ld	s9,104(a0)
ffffffffc020a51c:	89aa                	mv	s3,a0
ffffffffc020a51e:	160c8163          	beqz	s9,ffffffffc020a680 <sfs_truncfile+0x18c>
ffffffffc020a522:	0b0ca783          	lw	a5,176(s9) # 10b0 <_binary_bin_swap_img_size-0x6c50>
ffffffffc020a526:	14079d63          	bnez	a5,ffffffffc020a680 <sfs_truncfile+0x18c>
ffffffffc020a52a:	4d38                	lw	a4,88(a0)
ffffffffc020a52c:	6405                	lui	s0,0x1
ffffffffc020a52e:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a532:	16f71763          	bne	a4,a5,ffffffffc020a6a0 <sfs_truncfile+0x1ac>
ffffffffc020a536:	00053a83          	ld	s5,0(a0)
ffffffffc020a53a:	147d                	addi	s0,s0,-1
ffffffffc020a53c:	942e                	add	s0,s0,a1
ffffffffc020a53e:	000ae783          	lwu	a5,0(s5)
ffffffffc020a542:	8031                	srli	s0,s0,0xc
ffffffffc020a544:	8a2e                	mv	s4,a1
ffffffffc020a546:	2401                	sext.w	s0,s0
ffffffffc020a548:	02b79763          	bne	a5,a1,ffffffffc020a576 <sfs_truncfile+0x82>
ffffffffc020a54c:	008aa783          	lw	a5,8(s5)
ffffffffc020a550:	4901                	li	s2,0
ffffffffc020a552:	18879763          	bne	a5,s0,ffffffffc020a6e0 <sfs_truncfile+0x1ec>
ffffffffc020a556:	60aa                	ld	ra,136(sp)
ffffffffc020a558:	640a                	ld	s0,128(sp)
ffffffffc020a55a:	74e6                	ld	s1,120(sp)
ffffffffc020a55c:	79a6                	ld	s3,104(sp)
ffffffffc020a55e:	7a06                	ld	s4,96(sp)
ffffffffc020a560:	6ae6                	ld	s5,88(sp)
ffffffffc020a562:	6b46                	ld	s6,80(sp)
ffffffffc020a564:	6ba6                	ld	s7,72(sp)
ffffffffc020a566:	6c06                	ld	s8,64(sp)
ffffffffc020a568:	7ce2                	ld	s9,56(sp)
ffffffffc020a56a:	7d42                	ld	s10,48(sp)
ffffffffc020a56c:	7da2                	ld	s11,40(sp)
ffffffffc020a56e:	854a                	mv	a0,s2
ffffffffc020a570:	7946                	ld	s2,112(sp)
ffffffffc020a572:	6149                	addi	sp,sp,144
ffffffffc020a574:	8082                	ret
ffffffffc020a576:	02050b13          	addi	s6,a0,32
ffffffffc020a57a:	855a                	mv	a0,s6
ffffffffc020a57c:	866fa0ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc020a580:	008aa483          	lw	s1,8(s5)
ffffffffc020a584:	0a84e663          	bltu	s1,s0,ffffffffc020a630 <sfs_truncfile+0x13c>
ffffffffc020a588:	0c947163          	bgeu	s0,s1,ffffffffc020a64a <sfs_truncfile+0x156>
ffffffffc020a58c:	4dad                	li	s11,11
ffffffffc020a58e:	4b85                	li	s7,1
ffffffffc020a590:	a09d                	j	ffffffffc020a5f6 <sfs_truncfile+0x102>
ffffffffc020a592:	ff37091b          	addiw	s2,a4,-13
ffffffffc020a596:	0009079b          	sext.w	a5,s2
ffffffffc020a59a:	3ff00713          	li	a4,1023
ffffffffc020a59e:	04f76563          	bltu	a4,a5,ffffffffc020a5e8 <sfs_truncfile+0xf4>
ffffffffc020a5a2:	03cd2c03          	lw	s8,60(s10)
ffffffffc020a5a6:	040c0163          	beqz	s8,ffffffffc020a5e8 <sfs_truncfile+0xf4>
ffffffffc020a5aa:	004ca783          	lw	a5,4(s9)
ffffffffc020a5ae:	18fc7963          	bgeu	s8,a5,ffffffffc020a740 <sfs_truncfile+0x24c>
ffffffffc020a5b2:	038cb503          	ld	a0,56(s9)
ffffffffc020a5b6:	85e2                	mv	a1,s8
ffffffffc020a5b8:	b4ffe0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc020a5bc:	16051263          	bnez	a0,ffffffffc020a720 <sfs_truncfile+0x22c>
ffffffffc020a5c0:	02091793          	slli	a5,s2,0x20
ffffffffc020a5c4:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a5c8:	86e2                	mv	a3,s8
ffffffffc020a5ca:	4611                	li	a2,4
ffffffffc020a5cc:	082c                	addi	a1,sp,24
ffffffffc020a5ce:	8566                	mv	a0,s9
ffffffffc020a5d0:	e43a                	sd	a4,8(sp)
ffffffffc020a5d2:	ce02                	sw	zero,28(sp)
ffffffffc020a5d4:	043000ef          	jal	ra,ffffffffc020ae16 <sfs_rbuf>
ffffffffc020a5d8:	892a                	mv	s2,a0
ffffffffc020a5da:	e141                	bnez	a0,ffffffffc020a65a <sfs_truncfile+0x166>
ffffffffc020a5dc:	47e2                	lw	a5,24(sp)
ffffffffc020a5de:	6722                	ld	a4,8(sp)
ffffffffc020a5e0:	e3c9                	bnez	a5,ffffffffc020a662 <sfs_truncfile+0x16e>
ffffffffc020a5e2:	008d2603          	lw	a2,8(s10)
ffffffffc020a5e6:	367d                	addiw	a2,a2,-1
ffffffffc020a5e8:	00cd2423          	sw	a2,8(s10)
ffffffffc020a5ec:	0179b823          	sd	s7,16(s3)
ffffffffc020a5f0:	34fd                	addiw	s1,s1,-1
ffffffffc020a5f2:	04940a63          	beq	s0,s1,ffffffffc020a646 <sfs_truncfile+0x152>
ffffffffc020a5f6:	0009bd03          	ld	s10,0(s3)
ffffffffc020a5fa:	008d2703          	lw	a4,8(s10)
ffffffffc020a5fe:	c369                	beqz	a4,ffffffffc020a6c0 <sfs_truncfile+0x1cc>
ffffffffc020a600:	fff7079b          	addiw	a5,a4,-1
ffffffffc020a604:	0007861b          	sext.w	a2,a5
ffffffffc020a608:	f8cde5e3          	bltu	s11,a2,ffffffffc020a592 <sfs_truncfile+0x9e>
ffffffffc020a60c:	02079713          	slli	a4,a5,0x20
ffffffffc020a610:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a614:	00fd0933          	add	s2,s10,a5
ffffffffc020a618:	00c92583          	lw	a1,12(s2)
ffffffffc020a61c:	d5f1                	beqz	a1,ffffffffc020a5e8 <sfs_truncfile+0xf4>
ffffffffc020a61e:	8566                	mv	a0,s9
ffffffffc020a620:	bf4ff0ef          	jal	ra,ffffffffc0209a14 <sfs_block_free>
ffffffffc020a624:	00092623          	sw	zero,12(s2)
ffffffffc020a628:	008d2603          	lw	a2,8(s10)
ffffffffc020a62c:	367d                	addiw	a2,a2,-1
ffffffffc020a62e:	bf6d                	j	ffffffffc020a5e8 <sfs_truncfile+0xf4>
ffffffffc020a630:	4681                	li	a3,0
ffffffffc020a632:	8626                	mv	a2,s1
ffffffffc020a634:	85ce                	mv	a1,s3
ffffffffc020a636:	8566                	mv	a0,s9
ffffffffc020a638:	e96ff0ef          	jal	ra,ffffffffc0209cce <sfs_bmap_load_nolock>
ffffffffc020a63c:	892a                	mv	s2,a0
ffffffffc020a63e:	ed11                	bnez	a0,ffffffffc020a65a <sfs_truncfile+0x166>
ffffffffc020a640:	2485                	addiw	s1,s1,1
ffffffffc020a642:	fe9417e3          	bne	s0,s1,ffffffffc020a630 <sfs_truncfile+0x13c>
ffffffffc020a646:	008aa483          	lw	s1,8(s5)
ffffffffc020a64a:	0a941b63          	bne	s0,s1,ffffffffc020a700 <sfs_truncfile+0x20c>
ffffffffc020a64e:	014aa023          	sw	s4,0(s5)
ffffffffc020a652:	4785                	li	a5,1
ffffffffc020a654:	00f9b823          	sd	a5,16(s3)
ffffffffc020a658:	4901                	li	s2,0
ffffffffc020a65a:	855a                	mv	a0,s6
ffffffffc020a65c:	f83f90ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020a660:	bddd                	j	ffffffffc020a556 <sfs_truncfile+0x62>
ffffffffc020a662:	86e2                	mv	a3,s8
ffffffffc020a664:	4611                	li	a2,4
ffffffffc020a666:	086c                	addi	a1,sp,28
ffffffffc020a668:	8566                	mv	a0,s9
ffffffffc020a66a:	02d000ef          	jal	ra,ffffffffc020ae96 <sfs_wbuf>
ffffffffc020a66e:	892a                	mv	s2,a0
ffffffffc020a670:	f56d                	bnez	a0,ffffffffc020a65a <sfs_truncfile+0x166>
ffffffffc020a672:	45e2                	lw	a1,24(sp)
ffffffffc020a674:	8566                	mv	a0,s9
ffffffffc020a676:	b9eff0ef          	jal	ra,ffffffffc0209a14 <sfs_block_free>
ffffffffc020a67a:	b7a5                	j	ffffffffc020a5e2 <sfs_truncfile+0xee>
ffffffffc020a67c:	5975                	li	s2,-3
ffffffffc020a67e:	bde1                	j	ffffffffc020a556 <sfs_truncfile+0x62>
ffffffffc020a680:	00004697          	auipc	a3,0x4
ffffffffc020a684:	7b068693          	addi	a3,a3,1968 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc020a688:	00001617          	auipc	a2,0x1
ffffffffc020a68c:	3f860613          	addi	a2,a2,1016 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a690:	3af00593          	li	a1,943
ffffffffc020a694:	00005517          	auipc	a0,0x5
ffffffffc020a698:	97c50513          	addi	a0,a0,-1668 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a69c:	e03f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a6a0:	00005697          	auipc	a3,0x5
ffffffffc020a6a4:	93868693          	addi	a3,a3,-1736 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020a6a8:	00001617          	auipc	a2,0x1
ffffffffc020a6ac:	3d860613          	addi	a2,a2,984 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a6b0:	3b000593          	li	a1,944
ffffffffc020a6b4:	00005517          	auipc	a0,0x5
ffffffffc020a6b8:	95c50513          	addi	a0,a0,-1700 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a6bc:	de3f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a6c0:	00005697          	auipc	a3,0x5
ffffffffc020a6c4:	b7068693          	addi	a3,a3,-1168 # ffffffffc020f230 <dev_node_ops+0x7e0>
ffffffffc020a6c8:	00001617          	auipc	a2,0x1
ffffffffc020a6cc:	3b860613          	addi	a2,a2,952 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a6d0:	17b00593          	li	a1,379
ffffffffc020a6d4:	00005517          	auipc	a0,0x5
ffffffffc020a6d8:	93c50513          	addi	a0,a0,-1732 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a6dc:	dc3f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a6e0:	00005697          	auipc	a3,0x5
ffffffffc020a6e4:	b3868693          	addi	a3,a3,-1224 # ffffffffc020f218 <dev_node_ops+0x7c8>
ffffffffc020a6e8:	00001617          	auipc	a2,0x1
ffffffffc020a6ec:	39860613          	addi	a2,a2,920 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a6f0:	3b700593          	li	a1,951
ffffffffc020a6f4:	00005517          	auipc	a0,0x5
ffffffffc020a6f8:	91c50513          	addi	a0,a0,-1764 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a6fc:	da3f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a700:	00005697          	auipc	a3,0x5
ffffffffc020a704:	b8068693          	addi	a3,a3,-1152 # ffffffffc020f280 <dev_node_ops+0x830>
ffffffffc020a708:	00001617          	auipc	a2,0x1
ffffffffc020a70c:	37860613          	addi	a2,a2,888 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a710:	3d000593          	li	a1,976
ffffffffc020a714:	00005517          	auipc	a0,0x5
ffffffffc020a718:	8fc50513          	addi	a0,a0,-1796 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a71c:	d83f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a720:	00005697          	auipc	a3,0x5
ffffffffc020a724:	b2868693          	addi	a3,a3,-1240 # ffffffffc020f248 <dev_node_ops+0x7f8>
ffffffffc020a728:	00001617          	auipc	a2,0x1
ffffffffc020a72c:	35860613          	addi	a2,a2,856 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a730:	12b00593          	li	a1,299
ffffffffc020a734:	00005517          	auipc	a0,0x5
ffffffffc020a738:	8dc50513          	addi	a0,a0,-1828 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a73c:	d63f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a740:	8762                	mv	a4,s8
ffffffffc020a742:	86be                	mv	a3,a5
ffffffffc020a744:	00005617          	auipc	a2,0x5
ffffffffc020a748:	8fc60613          	addi	a2,a2,-1796 # ffffffffc020f040 <dev_node_ops+0x5f0>
ffffffffc020a74c:	05300593          	li	a1,83
ffffffffc020a750:	00005517          	auipc	a0,0x5
ffffffffc020a754:	8c050513          	addi	a0,a0,-1856 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a758:	d47f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a75c <sfs_load_inode>:
ffffffffc020a75c:	7139                	addi	sp,sp,-64
ffffffffc020a75e:	fc06                	sd	ra,56(sp)
ffffffffc020a760:	f822                	sd	s0,48(sp)
ffffffffc020a762:	f426                	sd	s1,40(sp)
ffffffffc020a764:	f04a                	sd	s2,32(sp)
ffffffffc020a766:	84b2                	mv	s1,a2
ffffffffc020a768:	892a                	mv	s2,a0
ffffffffc020a76a:	ec4e                	sd	s3,24(sp)
ffffffffc020a76c:	e852                	sd	s4,16(sp)
ffffffffc020a76e:	89ae                	mv	s3,a1
ffffffffc020a770:	e456                	sd	s5,8(sp)
ffffffffc020a772:	0d5000ef          	jal	ra,ffffffffc020b046 <lock_sfs_fs>
ffffffffc020a776:	45a9                	li	a1,10
ffffffffc020a778:	8526                	mv	a0,s1
ffffffffc020a77a:	0a893403          	ld	s0,168(s2)
ffffffffc020a77e:	0e9000ef          	jal	ra,ffffffffc020b066 <hash32>
ffffffffc020a782:	02051793          	slli	a5,a0,0x20
ffffffffc020a786:	01c7d713          	srli	a4,a5,0x1c
ffffffffc020a78a:	9722                	add	a4,a4,s0
ffffffffc020a78c:	843a                	mv	s0,a4
ffffffffc020a78e:	a029                	j	ffffffffc020a798 <sfs_load_inode+0x3c>
ffffffffc020a790:	fc042783          	lw	a5,-64(s0)
ffffffffc020a794:	10978863          	beq	a5,s1,ffffffffc020a8a4 <sfs_load_inode+0x148>
ffffffffc020a798:	6400                	ld	s0,8(s0)
ffffffffc020a79a:	fe871be3          	bne	a4,s0,ffffffffc020a790 <sfs_load_inode+0x34>
ffffffffc020a79e:	04000513          	li	a0,64
ffffffffc020a7a2:	fecf70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020a7a6:	8aaa                	mv	s5,a0
ffffffffc020a7a8:	16050563          	beqz	a0,ffffffffc020a912 <sfs_load_inode+0x1b6>
ffffffffc020a7ac:	00492683          	lw	a3,4(s2)
ffffffffc020a7b0:	18048363          	beqz	s1,ffffffffc020a936 <sfs_load_inode+0x1da>
ffffffffc020a7b4:	18d4f163          	bgeu	s1,a3,ffffffffc020a936 <sfs_load_inode+0x1da>
ffffffffc020a7b8:	03893503          	ld	a0,56(s2)
ffffffffc020a7bc:	85a6                	mv	a1,s1
ffffffffc020a7be:	949fe0ef          	jal	ra,ffffffffc0209106 <bitmap_test>
ffffffffc020a7c2:	18051763          	bnez	a0,ffffffffc020a950 <sfs_load_inode+0x1f4>
ffffffffc020a7c6:	4701                	li	a4,0
ffffffffc020a7c8:	86a6                	mv	a3,s1
ffffffffc020a7ca:	04000613          	li	a2,64
ffffffffc020a7ce:	85d6                	mv	a1,s5
ffffffffc020a7d0:	854a                	mv	a0,s2
ffffffffc020a7d2:	644000ef          	jal	ra,ffffffffc020ae16 <sfs_rbuf>
ffffffffc020a7d6:	842a                	mv	s0,a0
ffffffffc020a7d8:	0e051563          	bnez	a0,ffffffffc020a8c2 <sfs_load_inode+0x166>
ffffffffc020a7dc:	006ad783          	lhu	a5,6(s5)
ffffffffc020a7e0:	12078b63          	beqz	a5,ffffffffc020a916 <sfs_load_inode+0x1ba>
ffffffffc020a7e4:	6405                	lui	s0,0x1
ffffffffc020a7e6:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a7ea:	8d6fd0ef          	jal	ra,ffffffffc02078c0 <__alloc_inode>
ffffffffc020a7ee:	8a2a                	mv	s4,a0
ffffffffc020a7f0:	c961                	beqz	a0,ffffffffc020a8c0 <sfs_load_inode+0x164>
ffffffffc020a7f2:	004ad683          	lhu	a3,4(s5)
ffffffffc020a7f6:	4785                	li	a5,1
ffffffffc020a7f8:	0cf69c63          	bne	a3,a5,ffffffffc020a8d0 <sfs_load_inode+0x174>
ffffffffc020a7fc:	864a                	mv	a2,s2
ffffffffc020a7fe:	00005597          	auipc	a1,0x5
ffffffffc020a802:	b9258593          	addi	a1,a1,-1134 # ffffffffc020f390 <sfs_node_fileops>
ffffffffc020a806:	8d6fd0ef          	jal	ra,ffffffffc02078dc <inode_init>
ffffffffc020a80a:	058a2783          	lw	a5,88(s4)
ffffffffc020a80e:	23540413          	addi	s0,s0,565
ffffffffc020a812:	0e879063          	bne	a5,s0,ffffffffc020a8f2 <sfs_load_inode+0x196>
ffffffffc020a816:	4785                	li	a5,1
ffffffffc020a818:	00fa2c23          	sw	a5,24(s4)
ffffffffc020a81c:	015a3023          	sd	s5,0(s4)
ffffffffc020a820:	009a2423          	sw	s1,8(s4)
ffffffffc020a824:	000a3823          	sd	zero,16(s4)
ffffffffc020a828:	4585                	li	a1,1
ffffffffc020a82a:	020a0513          	addi	a0,s4,32
ffffffffc020a82e:	dabf90ef          	jal	ra,ffffffffc02045d8 <sem_init>
ffffffffc020a832:	058a2703          	lw	a4,88(s4)
ffffffffc020a836:	6785                	lui	a5,0x1
ffffffffc020a838:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a83c:	14f71663          	bne	a4,a5,ffffffffc020a988 <sfs_load_inode+0x22c>
ffffffffc020a840:	0a093703          	ld	a4,160(s2)
ffffffffc020a844:	038a0793          	addi	a5,s4,56
ffffffffc020a848:	008a2503          	lw	a0,8(s4)
ffffffffc020a84c:	e31c                	sd	a5,0(a4)
ffffffffc020a84e:	0af93023          	sd	a5,160(s2)
ffffffffc020a852:	09890793          	addi	a5,s2,152
ffffffffc020a856:	0a893403          	ld	s0,168(s2)
ffffffffc020a85a:	45a9                	li	a1,10
ffffffffc020a85c:	04ea3023          	sd	a4,64(s4)
ffffffffc020a860:	02fa3c23          	sd	a5,56(s4)
ffffffffc020a864:	003000ef          	jal	ra,ffffffffc020b066 <hash32>
ffffffffc020a868:	02051713          	slli	a4,a0,0x20
ffffffffc020a86c:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a870:	97a2                	add	a5,a5,s0
ffffffffc020a872:	6798                	ld	a4,8(a5)
ffffffffc020a874:	048a0693          	addi	a3,s4,72
ffffffffc020a878:	e314                	sd	a3,0(a4)
ffffffffc020a87a:	e794                	sd	a3,8(a5)
ffffffffc020a87c:	04ea3823          	sd	a4,80(s4)
ffffffffc020a880:	04fa3423          	sd	a5,72(s4)
ffffffffc020a884:	854a                	mv	a0,s2
ffffffffc020a886:	7d0000ef          	jal	ra,ffffffffc020b056 <unlock_sfs_fs>
ffffffffc020a88a:	4401                	li	s0,0
ffffffffc020a88c:	0149b023          	sd	s4,0(s3)
ffffffffc020a890:	70e2                	ld	ra,56(sp)
ffffffffc020a892:	8522                	mv	a0,s0
ffffffffc020a894:	7442                	ld	s0,48(sp)
ffffffffc020a896:	74a2                	ld	s1,40(sp)
ffffffffc020a898:	7902                	ld	s2,32(sp)
ffffffffc020a89a:	69e2                	ld	s3,24(sp)
ffffffffc020a89c:	6a42                	ld	s4,16(sp)
ffffffffc020a89e:	6aa2                	ld	s5,8(sp)
ffffffffc020a8a0:	6121                	addi	sp,sp,64
ffffffffc020a8a2:	8082                	ret
ffffffffc020a8a4:	fb840a13          	addi	s4,s0,-72
ffffffffc020a8a8:	8552                	mv	a0,s4
ffffffffc020a8aa:	894fd0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc020a8ae:	4785                	li	a5,1
ffffffffc020a8b0:	fcf51ae3          	bne	a0,a5,ffffffffc020a884 <sfs_load_inode+0x128>
ffffffffc020a8b4:	fd042783          	lw	a5,-48(s0)
ffffffffc020a8b8:	2785                	addiw	a5,a5,1
ffffffffc020a8ba:	fcf42823          	sw	a5,-48(s0)
ffffffffc020a8be:	b7d9                	j	ffffffffc020a884 <sfs_load_inode+0x128>
ffffffffc020a8c0:	5471                	li	s0,-4
ffffffffc020a8c2:	8556                	mv	a0,s5
ffffffffc020a8c4:	f7af70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020a8c8:	854a                	mv	a0,s2
ffffffffc020a8ca:	78c000ef          	jal	ra,ffffffffc020b056 <unlock_sfs_fs>
ffffffffc020a8ce:	b7c9                	j	ffffffffc020a890 <sfs_load_inode+0x134>
ffffffffc020a8d0:	4789                	li	a5,2
ffffffffc020a8d2:	08f69f63          	bne	a3,a5,ffffffffc020a970 <sfs_load_inode+0x214>
ffffffffc020a8d6:	864a                	mv	a2,s2
ffffffffc020a8d8:	00005597          	auipc	a1,0x5
ffffffffc020a8dc:	a3858593          	addi	a1,a1,-1480 # ffffffffc020f310 <sfs_node_dirops>
ffffffffc020a8e0:	ffdfc0ef          	jal	ra,ffffffffc02078dc <inode_init>
ffffffffc020a8e4:	058a2703          	lw	a4,88(s4)
ffffffffc020a8e8:	6785                	lui	a5,0x1
ffffffffc020a8ea:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a8ee:	f2f704e3          	beq	a4,a5,ffffffffc020a816 <sfs_load_inode+0xba>
ffffffffc020a8f2:	00004697          	auipc	a3,0x4
ffffffffc020a8f6:	6e668693          	addi	a3,a3,1766 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020a8fa:	00001617          	auipc	a2,0x1
ffffffffc020a8fe:	18660613          	addi	a2,a2,390 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a902:	07700593          	li	a1,119
ffffffffc020a906:	00004517          	auipc	a0,0x4
ffffffffc020a90a:	70a50513          	addi	a0,a0,1802 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a90e:	b91f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a912:	5471                	li	s0,-4
ffffffffc020a914:	bf55                	j	ffffffffc020a8c8 <sfs_load_inode+0x16c>
ffffffffc020a916:	00005697          	auipc	a3,0x5
ffffffffc020a91a:	98268693          	addi	a3,a3,-1662 # ffffffffc020f298 <dev_node_ops+0x848>
ffffffffc020a91e:	00001617          	auipc	a2,0x1
ffffffffc020a922:	16260613          	addi	a2,a2,354 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a926:	0ad00593          	li	a1,173
ffffffffc020a92a:	00004517          	auipc	a0,0x4
ffffffffc020a92e:	6e650513          	addi	a0,a0,1766 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a932:	b6df50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a936:	8726                	mv	a4,s1
ffffffffc020a938:	00004617          	auipc	a2,0x4
ffffffffc020a93c:	70860613          	addi	a2,a2,1800 # ffffffffc020f040 <dev_node_ops+0x5f0>
ffffffffc020a940:	05300593          	li	a1,83
ffffffffc020a944:	00004517          	auipc	a0,0x4
ffffffffc020a948:	6cc50513          	addi	a0,a0,1740 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a94c:	b53f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a950:	00004697          	auipc	a3,0x4
ffffffffc020a954:	72868693          	addi	a3,a3,1832 # ffffffffc020f078 <dev_node_ops+0x628>
ffffffffc020a958:	00001617          	auipc	a2,0x1
ffffffffc020a95c:	12860613          	addi	a2,a2,296 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a960:	0a800593          	li	a1,168
ffffffffc020a964:	00004517          	auipc	a0,0x4
ffffffffc020a968:	6ac50513          	addi	a0,a0,1708 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a96c:	b33f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a970:	00004617          	auipc	a2,0x4
ffffffffc020a974:	6b860613          	addi	a2,a2,1720 # ffffffffc020f028 <dev_node_ops+0x5d8>
ffffffffc020a978:	02e00593          	li	a1,46
ffffffffc020a97c:	00004517          	auipc	a0,0x4
ffffffffc020a980:	69450513          	addi	a0,a0,1684 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a984:	b1bf50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020a988:	00004697          	auipc	a3,0x4
ffffffffc020a98c:	65068693          	addi	a3,a3,1616 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020a990:	00001617          	auipc	a2,0x1
ffffffffc020a994:	0f060613          	addi	a2,a2,240 # ffffffffc020ba80 <commands+0x210>
ffffffffc020a998:	0b100593          	li	a1,177
ffffffffc020a99c:	00004517          	auipc	a0,0x4
ffffffffc020a9a0:	67450513          	addi	a0,a0,1652 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020a9a4:	afbf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020a9a8 <sfs_lookup>:
ffffffffc020a9a8:	7139                	addi	sp,sp,-64
ffffffffc020a9aa:	ec4e                	sd	s3,24(sp)
ffffffffc020a9ac:	06853983          	ld	s3,104(a0)
ffffffffc020a9b0:	fc06                	sd	ra,56(sp)
ffffffffc020a9b2:	f822                	sd	s0,48(sp)
ffffffffc020a9b4:	f426                	sd	s1,40(sp)
ffffffffc020a9b6:	f04a                	sd	s2,32(sp)
ffffffffc020a9b8:	e852                	sd	s4,16(sp)
ffffffffc020a9ba:	0a098c63          	beqz	s3,ffffffffc020aa72 <sfs_lookup+0xca>
ffffffffc020a9be:	0b09a783          	lw	a5,176(s3)
ffffffffc020a9c2:	ebc5                	bnez	a5,ffffffffc020aa72 <sfs_lookup+0xca>
ffffffffc020a9c4:	0005c783          	lbu	a5,0(a1)
ffffffffc020a9c8:	84ae                	mv	s1,a1
ffffffffc020a9ca:	c7c1                	beqz	a5,ffffffffc020aa52 <sfs_lookup+0xaa>
ffffffffc020a9cc:	02f00713          	li	a4,47
ffffffffc020a9d0:	08e78163          	beq	a5,a4,ffffffffc020aa52 <sfs_lookup+0xaa>
ffffffffc020a9d4:	842a                	mv	s0,a0
ffffffffc020a9d6:	8a32                	mv	s4,a2
ffffffffc020a9d8:	f67fc0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc020a9dc:	4c38                	lw	a4,88(s0)
ffffffffc020a9de:	6785                	lui	a5,0x1
ffffffffc020a9e0:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a9e4:	0af71763          	bne	a4,a5,ffffffffc020aa92 <sfs_lookup+0xea>
ffffffffc020a9e8:	6018                	ld	a4,0(s0)
ffffffffc020a9ea:	4789                	li	a5,2
ffffffffc020a9ec:	00475703          	lhu	a4,4(a4)
ffffffffc020a9f0:	04f71c63          	bne	a4,a5,ffffffffc020aa48 <sfs_lookup+0xa0>
ffffffffc020a9f4:	02040913          	addi	s2,s0,32
ffffffffc020a9f8:	854a                	mv	a0,s2
ffffffffc020a9fa:	be9f90ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc020a9fe:	8626                	mv	a2,s1
ffffffffc020aa00:	0054                	addi	a3,sp,4
ffffffffc020aa02:	85a2                	mv	a1,s0
ffffffffc020aa04:	854e                	mv	a0,s3
ffffffffc020aa06:	a29ff0ef          	jal	ra,ffffffffc020a42e <sfs_dirent_search_nolock.constprop.0>
ffffffffc020aa0a:	84aa                	mv	s1,a0
ffffffffc020aa0c:	854a                	mv	a0,s2
ffffffffc020aa0e:	bd1f90ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020aa12:	cc89                	beqz	s1,ffffffffc020aa2c <sfs_lookup+0x84>
ffffffffc020aa14:	8522                	mv	a0,s0
ffffffffc020aa16:	ff7fc0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020aa1a:	70e2                	ld	ra,56(sp)
ffffffffc020aa1c:	7442                	ld	s0,48(sp)
ffffffffc020aa1e:	7902                	ld	s2,32(sp)
ffffffffc020aa20:	69e2                	ld	s3,24(sp)
ffffffffc020aa22:	6a42                	ld	s4,16(sp)
ffffffffc020aa24:	8526                	mv	a0,s1
ffffffffc020aa26:	74a2                	ld	s1,40(sp)
ffffffffc020aa28:	6121                	addi	sp,sp,64
ffffffffc020aa2a:	8082                	ret
ffffffffc020aa2c:	4612                	lw	a2,4(sp)
ffffffffc020aa2e:	002c                	addi	a1,sp,8
ffffffffc020aa30:	854e                	mv	a0,s3
ffffffffc020aa32:	d2bff0ef          	jal	ra,ffffffffc020a75c <sfs_load_inode>
ffffffffc020aa36:	84aa                	mv	s1,a0
ffffffffc020aa38:	8522                	mv	a0,s0
ffffffffc020aa3a:	fd3fc0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020aa3e:	fcf1                	bnez	s1,ffffffffc020aa1a <sfs_lookup+0x72>
ffffffffc020aa40:	67a2                	ld	a5,8(sp)
ffffffffc020aa42:	00fa3023          	sd	a5,0(s4)
ffffffffc020aa46:	bfd1                	j	ffffffffc020aa1a <sfs_lookup+0x72>
ffffffffc020aa48:	8522                	mv	a0,s0
ffffffffc020aa4a:	fc3fc0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020aa4e:	54b9                	li	s1,-18
ffffffffc020aa50:	b7e9                	j	ffffffffc020aa1a <sfs_lookup+0x72>
ffffffffc020aa52:	00005697          	auipc	a3,0x5
ffffffffc020aa56:	85e68693          	addi	a3,a3,-1954 # ffffffffc020f2b0 <dev_node_ops+0x860>
ffffffffc020aa5a:	00001617          	auipc	a2,0x1
ffffffffc020aa5e:	02660613          	addi	a2,a2,38 # ffffffffc020ba80 <commands+0x210>
ffffffffc020aa62:	3e100593          	li	a1,993
ffffffffc020aa66:	00004517          	auipc	a0,0x4
ffffffffc020aa6a:	5aa50513          	addi	a0,a0,1450 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020aa6e:	a31f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aa72:	00004697          	auipc	a3,0x4
ffffffffc020aa76:	3be68693          	addi	a3,a3,958 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc020aa7a:	00001617          	auipc	a2,0x1
ffffffffc020aa7e:	00660613          	addi	a2,a2,6 # ffffffffc020ba80 <commands+0x210>
ffffffffc020aa82:	3e000593          	li	a1,992
ffffffffc020aa86:	00004517          	auipc	a0,0x4
ffffffffc020aa8a:	58a50513          	addi	a0,a0,1418 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020aa8e:	a11f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020aa92:	00004697          	auipc	a3,0x4
ffffffffc020aa96:	54668693          	addi	a3,a3,1350 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020aa9a:	00001617          	auipc	a2,0x1
ffffffffc020aa9e:	fe660613          	addi	a2,a2,-26 # ffffffffc020ba80 <commands+0x210>
ffffffffc020aaa2:	3e300593          	li	a1,995
ffffffffc020aaa6:	00004517          	auipc	a0,0x4
ffffffffc020aaaa:	56a50513          	addi	a0,a0,1386 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020aaae:	9f1f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020aab2 <sfs_namefile>:
ffffffffc020aab2:	6d98                	ld	a4,24(a1)
ffffffffc020aab4:	7175                	addi	sp,sp,-144
ffffffffc020aab6:	e506                	sd	ra,136(sp)
ffffffffc020aab8:	e122                	sd	s0,128(sp)
ffffffffc020aaba:	fca6                	sd	s1,120(sp)
ffffffffc020aabc:	f8ca                	sd	s2,112(sp)
ffffffffc020aabe:	f4ce                	sd	s3,104(sp)
ffffffffc020aac0:	f0d2                	sd	s4,96(sp)
ffffffffc020aac2:	ecd6                	sd	s5,88(sp)
ffffffffc020aac4:	e8da                	sd	s6,80(sp)
ffffffffc020aac6:	e4de                	sd	s7,72(sp)
ffffffffc020aac8:	e0e2                	sd	s8,64(sp)
ffffffffc020aaca:	fc66                	sd	s9,56(sp)
ffffffffc020aacc:	f86a                	sd	s10,48(sp)
ffffffffc020aace:	f46e                	sd	s11,40(sp)
ffffffffc020aad0:	e42e                	sd	a1,8(sp)
ffffffffc020aad2:	4789                	li	a5,2
ffffffffc020aad4:	1ae7f363          	bgeu	a5,a4,ffffffffc020ac7a <sfs_namefile+0x1c8>
ffffffffc020aad8:	89aa                	mv	s3,a0
ffffffffc020aada:	10400513          	li	a0,260
ffffffffc020aade:	cb0f70ef          	jal	ra,ffffffffc0201f8e <kmalloc>
ffffffffc020aae2:	842a                	mv	s0,a0
ffffffffc020aae4:	18050b63          	beqz	a0,ffffffffc020ac7a <sfs_namefile+0x1c8>
ffffffffc020aae8:	0689b483          	ld	s1,104(s3)
ffffffffc020aaec:	1e048963          	beqz	s1,ffffffffc020acde <sfs_namefile+0x22c>
ffffffffc020aaf0:	0b04a783          	lw	a5,176(s1)
ffffffffc020aaf4:	1e079563          	bnez	a5,ffffffffc020acde <sfs_namefile+0x22c>
ffffffffc020aaf8:	0589ac83          	lw	s9,88(s3)
ffffffffc020aafc:	6785                	lui	a5,0x1
ffffffffc020aafe:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ab02:	1afc9e63          	bne	s9,a5,ffffffffc020acbe <sfs_namefile+0x20c>
ffffffffc020ab06:	6722                	ld	a4,8(sp)
ffffffffc020ab08:	854e                	mv	a0,s3
ffffffffc020ab0a:	8ace                	mv	s5,s3
ffffffffc020ab0c:	6f1c                	ld	a5,24(a4)
ffffffffc020ab0e:	00073b03          	ld	s6,0(a4)
ffffffffc020ab12:	02098a13          	addi	s4,s3,32
ffffffffc020ab16:	ffe78b93          	addi	s7,a5,-2
ffffffffc020ab1a:	9b3e                	add	s6,s6,a5
ffffffffc020ab1c:	00004d17          	auipc	s10,0x4
ffffffffc020ab20:	7b4d0d13          	addi	s10,s10,1972 # ffffffffc020f2d0 <dev_node_ops+0x880>
ffffffffc020ab24:	e1bfc0ef          	jal	ra,ffffffffc020793e <inode_ref_inc>
ffffffffc020ab28:	00440c13          	addi	s8,s0,4
ffffffffc020ab2c:	e066                	sd	s9,0(sp)
ffffffffc020ab2e:	8552                	mv	a0,s4
ffffffffc020ab30:	ab3f90ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc020ab34:	0854                	addi	a3,sp,20
ffffffffc020ab36:	866a                	mv	a2,s10
ffffffffc020ab38:	85d6                	mv	a1,s5
ffffffffc020ab3a:	8526                	mv	a0,s1
ffffffffc020ab3c:	8f3ff0ef          	jal	ra,ffffffffc020a42e <sfs_dirent_search_nolock.constprop.0>
ffffffffc020ab40:	8daa                	mv	s11,a0
ffffffffc020ab42:	8552                	mv	a0,s4
ffffffffc020ab44:	a9bf90ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020ab48:	020d8863          	beqz	s11,ffffffffc020ab78 <sfs_namefile+0xc6>
ffffffffc020ab4c:	854e                	mv	a0,s3
ffffffffc020ab4e:	ebffc0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020ab52:	8522                	mv	a0,s0
ffffffffc020ab54:	ceaf70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020ab58:	60aa                	ld	ra,136(sp)
ffffffffc020ab5a:	640a                	ld	s0,128(sp)
ffffffffc020ab5c:	74e6                	ld	s1,120(sp)
ffffffffc020ab5e:	7946                	ld	s2,112(sp)
ffffffffc020ab60:	79a6                	ld	s3,104(sp)
ffffffffc020ab62:	7a06                	ld	s4,96(sp)
ffffffffc020ab64:	6ae6                	ld	s5,88(sp)
ffffffffc020ab66:	6b46                	ld	s6,80(sp)
ffffffffc020ab68:	6ba6                	ld	s7,72(sp)
ffffffffc020ab6a:	6c06                	ld	s8,64(sp)
ffffffffc020ab6c:	7ce2                	ld	s9,56(sp)
ffffffffc020ab6e:	7d42                	ld	s10,48(sp)
ffffffffc020ab70:	856e                	mv	a0,s11
ffffffffc020ab72:	7da2                	ld	s11,40(sp)
ffffffffc020ab74:	6149                	addi	sp,sp,144
ffffffffc020ab76:	8082                	ret
ffffffffc020ab78:	4652                	lw	a2,20(sp)
ffffffffc020ab7a:	082c                	addi	a1,sp,24
ffffffffc020ab7c:	8526                	mv	a0,s1
ffffffffc020ab7e:	bdfff0ef          	jal	ra,ffffffffc020a75c <sfs_load_inode>
ffffffffc020ab82:	8daa                	mv	s11,a0
ffffffffc020ab84:	f561                	bnez	a0,ffffffffc020ab4c <sfs_namefile+0x9a>
ffffffffc020ab86:	854e                	mv	a0,s3
ffffffffc020ab88:	008aa903          	lw	s2,8(s5)
ffffffffc020ab8c:	e81fc0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020ab90:	6ce2                	ld	s9,24(sp)
ffffffffc020ab92:	0b3c8463          	beq	s9,s3,ffffffffc020ac3a <sfs_namefile+0x188>
ffffffffc020ab96:	100c8463          	beqz	s9,ffffffffc020ac9e <sfs_namefile+0x1ec>
ffffffffc020ab9a:	058ca703          	lw	a4,88(s9)
ffffffffc020ab9e:	6782                	ld	a5,0(sp)
ffffffffc020aba0:	0ef71f63          	bne	a4,a5,ffffffffc020ac9e <sfs_namefile+0x1ec>
ffffffffc020aba4:	008ca703          	lw	a4,8(s9)
ffffffffc020aba8:	8ae6                	mv	s5,s9
ffffffffc020abaa:	0d270a63          	beq	a4,s2,ffffffffc020ac7e <sfs_namefile+0x1cc>
ffffffffc020abae:	000cb703          	ld	a4,0(s9)
ffffffffc020abb2:	4789                	li	a5,2
ffffffffc020abb4:	00475703          	lhu	a4,4(a4)
ffffffffc020abb8:	0cf71363          	bne	a4,a5,ffffffffc020ac7e <sfs_namefile+0x1cc>
ffffffffc020abbc:	020c8a13          	addi	s4,s9,32
ffffffffc020abc0:	8552                	mv	a0,s4
ffffffffc020abc2:	a21f90ef          	jal	ra,ffffffffc02045e2 <down>
ffffffffc020abc6:	000cb703          	ld	a4,0(s9)
ffffffffc020abca:	00872983          	lw	s3,8(a4)
ffffffffc020abce:	01304963          	bgtz	s3,ffffffffc020abe0 <sfs_namefile+0x12e>
ffffffffc020abd2:	a899                	j	ffffffffc020ac28 <sfs_namefile+0x176>
ffffffffc020abd4:	4018                	lw	a4,0(s0)
ffffffffc020abd6:	01270e63          	beq	a4,s2,ffffffffc020abf2 <sfs_namefile+0x140>
ffffffffc020abda:	2d85                	addiw	s11,s11,1
ffffffffc020abdc:	05b98663          	beq	s3,s11,ffffffffc020ac28 <sfs_namefile+0x176>
ffffffffc020abe0:	86a2                	mv	a3,s0
ffffffffc020abe2:	866e                	mv	a2,s11
ffffffffc020abe4:	85e6                	mv	a1,s9
ffffffffc020abe6:	8526                	mv	a0,s1
ffffffffc020abe8:	e48ff0ef          	jal	ra,ffffffffc020a230 <sfs_dirent_read_nolock>
ffffffffc020abec:	872a                	mv	a4,a0
ffffffffc020abee:	d17d                	beqz	a0,ffffffffc020abd4 <sfs_namefile+0x122>
ffffffffc020abf0:	a82d                	j	ffffffffc020ac2a <sfs_namefile+0x178>
ffffffffc020abf2:	8552                	mv	a0,s4
ffffffffc020abf4:	9ebf90ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020abf8:	8562                	mv	a0,s8
ffffffffc020abfa:	0ff000ef          	jal	ra,ffffffffc020b4f8 <strlen>
ffffffffc020abfe:	00150793          	addi	a5,a0,1
ffffffffc020ac02:	862a                	mv	a2,a0
ffffffffc020ac04:	06fbe863          	bltu	s7,a5,ffffffffc020ac74 <sfs_namefile+0x1c2>
ffffffffc020ac08:	fff64913          	not	s2,a2
ffffffffc020ac0c:	995a                	add	s2,s2,s6
ffffffffc020ac0e:	85e2                	mv	a1,s8
ffffffffc020ac10:	854a                	mv	a0,s2
ffffffffc020ac12:	40fb8bb3          	sub	s7,s7,a5
ffffffffc020ac16:	1d7000ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020ac1a:	02f00793          	li	a5,47
ffffffffc020ac1e:	fefb0fa3          	sb	a5,-1(s6)
ffffffffc020ac22:	89e6                	mv	s3,s9
ffffffffc020ac24:	8b4a                	mv	s6,s2
ffffffffc020ac26:	b721                	j	ffffffffc020ab2e <sfs_namefile+0x7c>
ffffffffc020ac28:	5741                	li	a4,-16
ffffffffc020ac2a:	8552                	mv	a0,s4
ffffffffc020ac2c:	e03a                	sd	a4,0(sp)
ffffffffc020ac2e:	9b1f90ef          	jal	ra,ffffffffc02045de <up>
ffffffffc020ac32:	6702                	ld	a4,0(sp)
ffffffffc020ac34:	89e6                	mv	s3,s9
ffffffffc020ac36:	8dba                	mv	s11,a4
ffffffffc020ac38:	bf11                	j	ffffffffc020ab4c <sfs_namefile+0x9a>
ffffffffc020ac3a:	854e                	mv	a0,s3
ffffffffc020ac3c:	dd1fc0ef          	jal	ra,ffffffffc0207a0c <inode_ref_dec>
ffffffffc020ac40:	64a2                	ld	s1,8(sp)
ffffffffc020ac42:	85da                	mv	a1,s6
ffffffffc020ac44:	6c98                	ld	a4,24(s1)
ffffffffc020ac46:	6088                	ld	a0,0(s1)
ffffffffc020ac48:	1779                	addi	a4,a4,-2
ffffffffc020ac4a:	41770bb3          	sub	s7,a4,s7
ffffffffc020ac4e:	865e                	mv	a2,s7
ffffffffc020ac50:	0505                	addi	a0,a0,1
ffffffffc020ac52:	15b000ef          	jal	ra,ffffffffc020b5ac <memmove>
ffffffffc020ac56:	02f00713          	li	a4,47
ffffffffc020ac5a:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020ac5e:	955e                	add	a0,a0,s7
ffffffffc020ac60:	00050023          	sb	zero,0(a0)
ffffffffc020ac64:	85de                	mv	a1,s7
ffffffffc020ac66:	8526                	mv	a0,s1
ffffffffc020ac68:	86ffa0ef          	jal	ra,ffffffffc02054d6 <iobuf_skip>
ffffffffc020ac6c:	8522                	mv	a0,s0
ffffffffc020ac6e:	bd0f70ef          	jal	ra,ffffffffc020203e <kfree>
ffffffffc020ac72:	b5dd                	j	ffffffffc020ab58 <sfs_namefile+0xa6>
ffffffffc020ac74:	89e6                	mv	s3,s9
ffffffffc020ac76:	5df1                	li	s11,-4
ffffffffc020ac78:	bdd1                	j	ffffffffc020ab4c <sfs_namefile+0x9a>
ffffffffc020ac7a:	5df1                	li	s11,-4
ffffffffc020ac7c:	bdf1                	j	ffffffffc020ab58 <sfs_namefile+0xa6>
ffffffffc020ac7e:	00004697          	auipc	a3,0x4
ffffffffc020ac82:	65a68693          	addi	a3,a3,1626 # ffffffffc020f2d8 <dev_node_ops+0x888>
ffffffffc020ac86:	00001617          	auipc	a2,0x1
ffffffffc020ac8a:	dfa60613          	addi	a2,a2,-518 # ffffffffc020ba80 <commands+0x210>
ffffffffc020ac8e:	2ff00593          	li	a1,767
ffffffffc020ac92:	00004517          	auipc	a0,0x4
ffffffffc020ac96:	37e50513          	addi	a0,a0,894 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020ac9a:	805f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020ac9e:	00004697          	auipc	a3,0x4
ffffffffc020aca2:	33a68693          	addi	a3,a3,826 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020aca6:	00001617          	auipc	a2,0x1
ffffffffc020acaa:	dda60613          	addi	a2,a2,-550 # ffffffffc020ba80 <commands+0x210>
ffffffffc020acae:	2fe00593          	li	a1,766
ffffffffc020acb2:	00004517          	auipc	a0,0x4
ffffffffc020acb6:	35e50513          	addi	a0,a0,862 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020acba:	fe4f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020acbe:	00004697          	auipc	a3,0x4
ffffffffc020acc2:	31a68693          	addi	a3,a3,794 # ffffffffc020efd8 <dev_node_ops+0x588>
ffffffffc020acc6:	00001617          	auipc	a2,0x1
ffffffffc020acca:	dba60613          	addi	a2,a2,-582 # ffffffffc020ba80 <commands+0x210>
ffffffffc020acce:	2eb00593          	li	a1,747
ffffffffc020acd2:	00004517          	auipc	a0,0x4
ffffffffc020acd6:	33e50513          	addi	a0,a0,830 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020acda:	fc4f50ef          	jal	ra,ffffffffc020049e <__panic>
ffffffffc020acde:	00004697          	auipc	a3,0x4
ffffffffc020ace2:	15268693          	addi	a3,a3,338 # ffffffffc020ee30 <dev_node_ops+0x3e0>
ffffffffc020ace6:	00001617          	auipc	a2,0x1
ffffffffc020acea:	d9a60613          	addi	a2,a2,-614 # ffffffffc020ba80 <commands+0x210>
ffffffffc020acee:	2ea00593          	li	a1,746
ffffffffc020acf2:	00004517          	auipc	a0,0x4
ffffffffc020acf6:	31e50513          	addi	a0,a0,798 # ffffffffc020f010 <dev_node_ops+0x5c0>
ffffffffc020acfa:	fa4f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020acfe <sfs_rwblock_nolock>:
ffffffffc020acfe:	7139                	addi	sp,sp,-64
ffffffffc020ad00:	f822                	sd	s0,48(sp)
ffffffffc020ad02:	f426                	sd	s1,40(sp)
ffffffffc020ad04:	fc06                	sd	ra,56(sp)
ffffffffc020ad06:	842a                	mv	s0,a0
ffffffffc020ad08:	84b6                	mv	s1,a3
ffffffffc020ad0a:	e211                	bnez	a2,ffffffffc020ad0e <sfs_rwblock_nolock+0x10>
ffffffffc020ad0c:	e715                	bnez	a4,ffffffffc020ad38 <sfs_rwblock_nolock+0x3a>
ffffffffc020ad0e:	405c                	lw	a5,4(s0)
ffffffffc020ad10:	02f67463          	bgeu	a2,a5,ffffffffc020ad38 <sfs_rwblock_nolock+0x3a>
ffffffffc020ad14:	00c6169b          	slliw	a3,a2,0xc
ffffffffc020ad18:	1682                	slli	a3,a3,0x20
ffffffffc020ad1a:	6605                	lui	a2,0x1
ffffffffc020ad1c:	9281                	srli	a3,a3,0x20
ffffffffc020ad1e:	850a                	mv	a0,sp
ffffffffc020ad20:	f40fa0ef          	jal	ra,ffffffffc0205460 <iobuf_init>
ffffffffc020ad24:	85aa                	mv	a1,a0
ffffffffc020ad26:	7808                	ld	a0,48(s0)
ffffffffc020ad28:	8626                	mv	a2,s1
ffffffffc020ad2a:	7118                	ld	a4,32(a0)
ffffffffc020ad2c:	9702                	jalr	a4
ffffffffc020ad2e:	70e2                	ld	ra,56(sp)
ffffffffc020ad30:	7442                	ld	s0,48(sp)
ffffffffc020ad32:	74a2                	ld	s1,40(sp)
ffffffffc020ad34:	6121                	addi	sp,sp,64
ffffffffc020ad36:	8082                	ret
ffffffffc020ad38:	00004697          	auipc	a3,0x4
ffffffffc020ad3c:	6d868693          	addi	a3,a3,1752 # ffffffffc020f410 <sfs_node_fileops+0x80>
ffffffffc020ad40:	00001617          	auipc	a2,0x1
ffffffffc020ad44:	d4060613          	addi	a2,a2,-704 # ffffffffc020ba80 <commands+0x210>
ffffffffc020ad48:	45d5                	li	a1,21
ffffffffc020ad4a:	00004517          	auipc	a0,0x4
ffffffffc020ad4e:	6fe50513          	addi	a0,a0,1790 # ffffffffc020f448 <sfs_node_fileops+0xb8>
ffffffffc020ad52:	f4cf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ad56 <sfs_rblock>:
ffffffffc020ad56:	7139                	addi	sp,sp,-64
ffffffffc020ad58:	ec4e                	sd	s3,24(sp)
ffffffffc020ad5a:	89b6                	mv	s3,a3
ffffffffc020ad5c:	f822                	sd	s0,48(sp)
ffffffffc020ad5e:	f04a                	sd	s2,32(sp)
ffffffffc020ad60:	e852                	sd	s4,16(sp)
ffffffffc020ad62:	fc06                	sd	ra,56(sp)
ffffffffc020ad64:	f426                	sd	s1,40(sp)
ffffffffc020ad66:	e456                	sd	s5,8(sp)
ffffffffc020ad68:	8a2a                	mv	s4,a0
ffffffffc020ad6a:	892e                	mv	s2,a1
ffffffffc020ad6c:	8432                	mv	s0,a2
ffffffffc020ad6e:	2e0000ef          	jal	ra,ffffffffc020b04e <lock_sfs_io>
ffffffffc020ad72:	04098063          	beqz	s3,ffffffffc020adb2 <sfs_rblock+0x5c>
ffffffffc020ad76:	013409bb          	addw	s3,s0,s3
ffffffffc020ad7a:	6a85                	lui	s5,0x1
ffffffffc020ad7c:	a021                	j	ffffffffc020ad84 <sfs_rblock+0x2e>
ffffffffc020ad7e:	9956                	add	s2,s2,s5
ffffffffc020ad80:	02898963          	beq	s3,s0,ffffffffc020adb2 <sfs_rblock+0x5c>
ffffffffc020ad84:	8622                	mv	a2,s0
ffffffffc020ad86:	85ca                	mv	a1,s2
ffffffffc020ad88:	4705                	li	a4,1
ffffffffc020ad8a:	4681                	li	a3,0
ffffffffc020ad8c:	8552                	mv	a0,s4
ffffffffc020ad8e:	f71ff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020ad92:	84aa                	mv	s1,a0
ffffffffc020ad94:	2405                	addiw	s0,s0,1
ffffffffc020ad96:	d565                	beqz	a0,ffffffffc020ad7e <sfs_rblock+0x28>
ffffffffc020ad98:	8552                	mv	a0,s4
ffffffffc020ad9a:	2c4000ef          	jal	ra,ffffffffc020b05e <unlock_sfs_io>
ffffffffc020ad9e:	70e2                	ld	ra,56(sp)
ffffffffc020ada0:	7442                	ld	s0,48(sp)
ffffffffc020ada2:	7902                	ld	s2,32(sp)
ffffffffc020ada4:	69e2                	ld	s3,24(sp)
ffffffffc020ada6:	6a42                	ld	s4,16(sp)
ffffffffc020ada8:	6aa2                	ld	s5,8(sp)
ffffffffc020adaa:	8526                	mv	a0,s1
ffffffffc020adac:	74a2                	ld	s1,40(sp)
ffffffffc020adae:	6121                	addi	sp,sp,64
ffffffffc020adb0:	8082                	ret
ffffffffc020adb2:	4481                	li	s1,0
ffffffffc020adb4:	b7d5                	j	ffffffffc020ad98 <sfs_rblock+0x42>

ffffffffc020adb6 <sfs_wblock>:
ffffffffc020adb6:	7139                	addi	sp,sp,-64
ffffffffc020adb8:	ec4e                	sd	s3,24(sp)
ffffffffc020adba:	89b6                	mv	s3,a3
ffffffffc020adbc:	f822                	sd	s0,48(sp)
ffffffffc020adbe:	f04a                	sd	s2,32(sp)
ffffffffc020adc0:	e852                	sd	s4,16(sp)
ffffffffc020adc2:	fc06                	sd	ra,56(sp)
ffffffffc020adc4:	f426                	sd	s1,40(sp)
ffffffffc020adc6:	e456                	sd	s5,8(sp)
ffffffffc020adc8:	8a2a                	mv	s4,a0
ffffffffc020adca:	892e                	mv	s2,a1
ffffffffc020adcc:	8432                	mv	s0,a2
ffffffffc020adce:	280000ef          	jal	ra,ffffffffc020b04e <lock_sfs_io>
ffffffffc020add2:	04098063          	beqz	s3,ffffffffc020ae12 <sfs_wblock+0x5c>
ffffffffc020add6:	013409bb          	addw	s3,s0,s3
ffffffffc020adda:	6a85                	lui	s5,0x1
ffffffffc020addc:	a021                	j	ffffffffc020ade4 <sfs_wblock+0x2e>
ffffffffc020adde:	9956                	add	s2,s2,s5
ffffffffc020ade0:	02898963          	beq	s3,s0,ffffffffc020ae12 <sfs_wblock+0x5c>
ffffffffc020ade4:	8622                	mv	a2,s0
ffffffffc020ade6:	85ca                	mv	a1,s2
ffffffffc020ade8:	4705                	li	a4,1
ffffffffc020adea:	4685                	li	a3,1
ffffffffc020adec:	8552                	mv	a0,s4
ffffffffc020adee:	f11ff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020adf2:	84aa                	mv	s1,a0
ffffffffc020adf4:	2405                	addiw	s0,s0,1
ffffffffc020adf6:	d565                	beqz	a0,ffffffffc020adde <sfs_wblock+0x28>
ffffffffc020adf8:	8552                	mv	a0,s4
ffffffffc020adfa:	264000ef          	jal	ra,ffffffffc020b05e <unlock_sfs_io>
ffffffffc020adfe:	70e2                	ld	ra,56(sp)
ffffffffc020ae00:	7442                	ld	s0,48(sp)
ffffffffc020ae02:	7902                	ld	s2,32(sp)
ffffffffc020ae04:	69e2                	ld	s3,24(sp)
ffffffffc020ae06:	6a42                	ld	s4,16(sp)
ffffffffc020ae08:	6aa2                	ld	s5,8(sp)
ffffffffc020ae0a:	8526                	mv	a0,s1
ffffffffc020ae0c:	74a2                	ld	s1,40(sp)
ffffffffc020ae0e:	6121                	addi	sp,sp,64
ffffffffc020ae10:	8082                	ret
ffffffffc020ae12:	4481                	li	s1,0
ffffffffc020ae14:	b7d5                	j	ffffffffc020adf8 <sfs_wblock+0x42>

ffffffffc020ae16 <sfs_rbuf>:
ffffffffc020ae16:	7179                	addi	sp,sp,-48
ffffffffc020ae18:	f406                	sd	ra,40(sp)
ffffffffc020ae1a:	f022                	sd	s0,32(sp)
ffffffffc020ae1c:	ec26                	sd	s1,24(sp)
ffffffffc020ae1e:	e84a                	sd	s2,16(sp)
ffffffffc020ae20:	e44e                	sd	s3,8(sp)
ffffffffc020ae22:	e052                	sd	s4,0(sp)
ffffffffc020ae24:	6785                	lui	a5,0x1
ffffffffc020ae26:	04f77863          	bgeu	a4,a5,ffffffffc020ae76 <sfs_rbuf+0x60>
ffffffffc020ae2a:	84ba                	mv	s1,a4
ffffffffc020ae2c:	9732                	add	a4,a4,a2
ffffffffc020ae2e:	89b2                	mv	s3,a2
ffffffffc020ae30:	04e7e363          	bltu	a5,a4,ffffffffc020ae76 <sfs_rbuf+0x60>
ffffffffc020ae34:	8936                	mv	s2,a3
ffffffffc020ae36:	842a                	mv	s0,a0
ffffffffc020ae38:	8a2e                	mv	s4,a1
ffffffffc020ae3a:	214000ef          	jal	ra,ffffffffc020b04e <lock_sfs_io>
ffffffffc020ae3e:	642c                	ld	a1,72(s0)
ffffffffc020ae40:	864a                	mv	a2,s2
ffffffffc020ae42:	4705                	li	a4,1
ffffffffc020ae44:	4681                	li	a3,0
ffffffffc020ae46:	8522                	mv	a0,s0
ffffffffc020ae48:	eb7ff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020ae4c:	892a                	mv	s2,a0
ffffffffc020ae4e:	cd09                	beqz	a0,ffffffffc020ae68 <sfs_rbuf+0x52>
ffffffffc020ae50:	8522                	mv	a0,s0
ffffffffc020ae52:	20c000ef          	jal	ra,ffffffffc020b05e <unlock_sfs_io>
ffffffffc020ae56:	70a2                	ld	ra,40(sp)
ffffffffc020ae58:	7402                	ld	s0,32(sp)
ffffffffc020ae5a:	64e2                	ld	s1,24(sp)
ffffffffc020ae5c:	69a2                	ld	s3,8(sp)
ffffffffc020ae5e:	6a02                	ld	s4,0(sp)
ffffffffc020ae60:	854a                	mv	a0,s2
ffffffffc020ae62:	6942                	ld	s2,16(sp)
ffffffffc020ae64:	6145                	addi	sp,sp,48
ffffffffc020ae66:	8082                	ret
ffffffffc020ae68:	642c                	ld	a1,72(s0)
ffffffffc020ae6a:	864e                	mv	a2,s3
ffffffffc020ae6c:	8552                	mv	a0,s4
ffffffffc020ae6e:	95a6                	add	a1,a1,s1
ffffffffc020ae70:	77c000ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020ae74:	bff1                	j	ffffffffc020ae50 <sfs_rbuf+0x3a>
ffffffffc020ae76:	00004697          	auipc	a3,0x4
ffffffffc020ae7a:	5ea68693          	addi	a3,a3,1514 # ffffffffc020f460 <sfs_node_fileops+0xd0>
ffffffffc020ae7e:	00001617          	auipc	a2,0x1
ffffffffc020ae82:	c0260613          	addi	a2,a2,-1022 # ffffffffc020ba80 <commands+0x210>
ffffffffc020ae86:	05500593          	li	a1,85
ffffffffc020ae8a:	00004517          	auipc	a0,0x4
ffffffffc020ae8e:	5be50513          	addi	a0,a0,1470 # ffffffffc020f448 <sfs_node_fileops+0xb8>
ffffffffc020ae92:	e0cf50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020ae96 <sfs_wbuf>:
ffffffffc020ae96:	7139                	addi	sp,sp,-64
ffffffffc020ae98:	fc06                	sd	ra,56(sp)
ffffffffc020ae9a:	f822                	sd	s0,48(sp)
ffffffffc020ae9c:	f426                	sd	s1,40(sp)
ffffffffc020ae9e:	f04a                	sd	s2,32(sp)
ffffffffc020aea0:	ec4e                	sd	s3,24(sp)
ffffffffc020aea2:	e852                	sd	s4,16(sp)
ffffffffc020aea4:	e456                	sd	s5,8(sp)
ffffffffc020aea6:	6785                	lui	a5,0x1
ffffffffc020aea8:	06f77163          	bgeu	a4,a5,ffffffffc020af0a <sfs_wbuf+0x74>
ffffffffc020aeac:	893a                	mv	s2,a4
ffffffffc020aeae:	9732                	add	a4,a4,a2
ffffffffc020aeb0:	8a32                	mv	s4,a2
ffffffffc020aeb2:	04e7ec63          	bltu	a5,a4,ffffffffc020af0a <sfs_wbuf+0x74>
ffffffffc020aeb6:	842a                	mv	s0,a0
ffffffffc020aeb8:	89b6                	mv	s3,a3
ffffffffc020aeba:	8aae                	mv	s5,a1
ffffffffc020aebc:	192000ef          	jal	ra,ffffffffc020b04e <lock_sfs_io>
ffffffffc020aec0:	642c                	ld	a1,72(s0)
ffffffffc020aec2:	4705                	li	a4,1
ffffffffc020aec4:	4681                	li	a3,0
ffffffffc020aec6:	864e                	mv	a2,s3
ffffffffc020aec8:	8522                	mv	a0,s0
ffffffffc020aeca:	e35ff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020aece:	84aa                	mv	s1,a0
ffffffffc020aed0:	cd11                	beqz	a0,ffffffffc020aeec <sfs_wbuf+0x56>
ffffffffc020aed2:	8522                	mv	a0,s0
ffffffffc020aed4:	18a000ef          	jal	ra,ffffffffc020b05e <unlock_sfs_io>
ffffffffc020aed8:	70e2                	ld	ra,56(sp)
ffffffffc020aeda:	7442                	ld	s0,48(sp)
ffffffffc020aedc:	7902                	ld	s2,32(sp)
ffffffffc020aede:	69e2                	ld	s3,24(sp)
ffffffffc020aee0:	6a42                	ld	s4,16(sp)
ffffffffc020aee2:	6aa2                	ld	s5,8(sp)
ffffffffc020aee4:	8526                	mv	a0,s1
ffffffffc020aee6:	74a2                	ld	s1,40(sp)
ffffffffc020aee8:	6121                	addi	sp,sp,64
ffffffffc020aeea:	8082                	ret
ffffffffc020aeec:	6428                	ld	a0,72(s0)
ffffffffc020aeee:	8652                	mv	a2,s4
ffffffffc020aef0:	85d6                	mv	a1,s5
ffffffffc020aef2:	954a                	add	a0,a0,s2
ffffffffc020aef4:	6f8000ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020aef8:	642c                	ld	a1,72(s0)
ffffffffc020aefa:	4705                	li	a4,1
ffffffffc020aefc:	4685                	li	a3,1
ffffffffc020aefe:	864e                	mv	a2,s3
ffffffffc020af00:	8522                	mv	a0,s0
ffffffffc020af02:	dfdff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020af06:	84aa                	mv	s1,a0
ffffffffc020af08:	b7e9                	j	ffffffffc020aed2 <sfs_wbuf+0x3c>
ffffffffc020af0a:	00004697          	auipc	a3,0x4
ffffffffc020af0e:	55668693          	addi	a3,a3,1366 # ffffffffc020f460 <sfs_node_fileops+0xd0>
ffffffffc020af12:	00001617          	auipc	a2,0x1
ffffffffc020af16:	b6e60613          	addi	a2,a2,-1170 # ffffffffc020ba80 <commands+0x210>
ffffffffc020af1a:	06b00593          	li	a1,107
ffffffffc020af1e:	00004517          	auipc	a0,0x4
ffffffffc020af22:	52a50513          	addi	a0,a0,1322 # ffffffffc020f448 <sfs_node_fileops+0xb8>
ffffffffc020af26:	d78f50ef          	jal	ra,ffffffffc020049e <__panic>

ffffffffc020af2a <sfs_sync_super>:
ffffffffc020af2a:	1101                	addi	sp,sp,-32
ffffffffc020af2c:	ec06                	sd	ra,24(sp)
ffffffffc020af2e:	e822                	sd	s0,16(sp)
ffffffffc020af30:	e426                	sd	s1,8(sp)
ffffffffc020af32:	842a                	mv	s0,a0
ffffffffc020af34:	11a000ef          	jal	ra,ffffffffc020b04e <lock_sfs_io>
ffffffffc020af38:	6428                	ld	a0,72(s0)
ffffffffc020af3a:	6605                	lui	a2,0x1
ffffffffc020af3c:	4581                	li	a1,0
ffffffffc020af3e:	65c000ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc020af42:	6428                	ld	a0,72(s0)
ffffffffc020af44:	85a2                	mv	a1,s0
ffffffffc020af46:	02c00613          	li	a2,44
ffffffffc020af4a:	6a2000ef          	jal	ra,ffffffffc020b5ec <memcpy>
ffffffffc020af4e:	642c                	ld	a1,72(s0)
ffffffffc020af50:	4701                	li	a4,0
ffffffffc020af52:	4685                	li	a3,1
ffffffffc020af54:	4601                	li	a2,0
ffffffffc020af56:	8522                	mv	a0,s0
ffffffffc020af58:	da7ff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020af5c:	84aa                	mv	s1,a0
ffffffffc020af5e:	8522                	mv	a0,s0
ffffffffc020af60:	0fe000ef          	jal	ra,ffffffffc020b05e <unlock_sfs_io>
ffffffffc020af64:	60e2                	ld	ra,24(sp)
ffffffffc020af66:	6442                	ld	s0,16(sp)
ffffffffc020af68:	8526                	mv	a0,s1
ffffffffc020af6a:	64a2                	ld	s1,8(sp)
ffffffffc020af6c:	6105                	addi	sp,sp,32
ffffffffc020af6e:	8082                	ret

ffffffffc020af70 <sfs_sync_freemap>:
ffffffffc020af70:	7139                	addi	sp,sp,-64
ffffffffc020af72:	ec4e                	sd	s3,24(sp)
ffffffffc020af74:	e852                	sd	s4,16(sp)
ffffffffc020af76:	00456983          	lwu	s3,4(a0)
ffffffffc020af7a:	8a2a                	mv	s4,a0
ffffffffc020af7c:	7d08                	ld	a0,56(a0)
ffffffffc020af7e:	67a1                	lui	a5,0x8
ffffffffc020af80:	17fd                	addi	a5,a5,-1
ffffffffc020af82:	4581                	li	a1,0
ffffffffc020af84:	f822                	sd	s0,48(sp)
ffffffffc020af86:	fc06                	sd	ra,56(sp)
ffffffffc020af88:	f426                	sd	s1,40(sp)
ffffffffc020af8a:	f04a                	sd	s2,32(sp)
ffffffffc020af8c:	e456                	sd	s5,8(sp)
ffffffffc020af8e:	99be                	add	s3,s3,a5
ffffffffc020af90:	a0afe0ef          	jal	ra,ffffffffc020919a <bitmap_getdata>
ffffffffc020af94:	00f9d993          	srli	s3,s3,0xf
ffffffffc020af98:	842a                	mv	s0,a0
ffffffffc020af9a:	8552                	mv	a0,s4
ffffffffc020af9c:	0b2000ef          	jal	ra,ffffffffc020b04e <lock_sfs_io>
ffffffffc020afa0:	04098163          	beqz	s3,ffffffffc020afe2 <sfs_sync_freemap+0x72>
ffffffffc020afa4:	09b2                	slli	s3,s3,0xc
ffffffffc020afa6:	99a2                	add	s3,s3,s0
ffffffffc020afa8:	4909                	li	s2,2
ffffffffc020afaa:	6a85                	lui	s5,0x1
ffffffffc020afac:	a021                	j	ffffffffc020afb4 <sfs_sync_freemap+0x44>
ffffffffc020afae:	2905                	addiw	s2,s2,1
ffffffffc020afb0:	02898963          	beq	s3,s0,ffffffffc020afe2 <sfs_sync_freemap+0x72>
ffffffffc020afb4:	85a2                	mv	a1,s0
ffffffffc020afb6:	864a                	mv	a2,s2
ffffffffc020afb8:	4705                	li	a4,1
ffffffffc020afba:	4685                	li	a3,1
ffffffffc020afbc:	8552                	mv	a0,s4
ffffffffc020afbe:	d41ff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020afc2:	84aa                	mv	s1,a0
ffffffffc020afc4:	9456                	add	s0,s0,s5
ffffffffc020afc6:	d565                	beqz	a0,ffffffffc020afae <sfs_sync_freemap+0x3e>
ffffffffc020afc8:	8552                	mv	a0,s4
ffffffffc020afca:	094000ef          	jal	ra,ffffffffc020b05e <unlock_sfs_io>
ffffffffc020afce:	70e2                	ld	ra,56(sp)
ffffffffc020afd0:	7442                	ld	s0,48(sp)
ffffffffc020afd2:	7902                	ld	s2,32(sp)
ffffffffc020afd4:	69e2                	ld	s3,24(sp)
ffffffffc020afd6:	6a42                	ld	s4,16(sp)
ffffffffc020afd8:	6aa2                	ld	s5,8(sp)
ffffffffc020afda:	8526                	mv	a0,s1
ffffffffc020afdc:	74a2                	ld	s1,40(sp)
ffffffffc020afde:	6121                	addi	sp,sp,64
ffffffffc020afe0:	8082                	ret
ffffffffc020afe2:	4481                	li	s1,0
ffffffffc020afe4:	b7d5                	j	ffffffffc020afc8 <sfs_sync_freemap+0x58>

ffffffffc020afe6 <sfs_clear_block>:
ffffffffc020afe6:	7179                	addi	sp,sp,-48
ffffffffc020afe8:	f022                	sd	s0,32(sp)
ffffffffc020afea:	e84a                	sd	s2,16(sp)
ffffffffc020afec:	e44e                	sd	s3,8(sp)
ffffffffc020afee:	f406                	sd	ra,40(sp)
ffffffffc020aff0:	89b2                	mv	s3,a2
ffffffffc020aff2:	ec26                	sd	s1,24(sp)
ffffffffc020aff4:	892a                	mv	s2,a0
ffffffffc020aff6:	842e                	mv	s0,a1
ffffffffc020aff8:	056000ef          	jal	ra,ffffffffc020b04e <lock_sfs_io>
ffffffffc020affc:	04893503          	ld	a0,72(s2)
ffffffffc020b000:	6605                	lui	a2,0x1
ffffffffc020b002:	4581                	li	a1,0
ffffffffc020b004:	596000ef          	jal	ra,ffffffffc020b59a <memset>
ffffffffc020b008:	02098d63          	beqz	s3,ffffffffc020b042 <sfs_clear_block+0x5c>
ffffffffc020b00c:	013409bb          	addw	s3,s0,s3
ffffffffc020b010:	a019                	j	ffffffffc020b016 <sfs_clear_block+0x30>
ffffffffc020b012:	02898863          	beq	s3,s0,ffffffffc020b042 <sfs_clear_block+0x5c>
ffffffffc020b016:	04893583          	ld	a1,72(s2)
ffffffffc020b01a:	8622                	mv	a2,s0
ffffffffc020b01c:	4705                	li	a4,1
ffffffffc020b01e:	4685                	li	a3,1
ffffffffc020b020:	854a                	mv	a0,s2
ffffffffc020b022:	cddff0ef          	jal	ra,ffffffffc020acfe <sfs_rwblock_nolock>
ffffffffc020b026:	84aa                	mv	s1,a0
ffffffffc020b028:	2405                	addiw	s0,s0,1
ffffffffc020b02a:	d565                	beqz	a0,ffffffffc020b012 <sfs_clear_block+0x2c>
ffffffffc020b02c:	854a                	mv	a0,s2
ffffffffc020b02e:	030000ef          	jal	ra,ffffffffc020b05e <unlock_sfs_io>
ffffffffc020b032:	70a2                	ld	ra,40(sp)
ffffffffc020b034:	7402                	ld	s0,32(sp)
ffffffffc020b036:	6942                	ld	s2,16(sp)
ffffffffc020b038:	69a2                	ld	s3,8(sp)
ffffffffc020b03a:	8526                	mv	a0,s1
ffffffffc020b03c:	64e2                	ld	s1,24(sp)
ffffffffc020b03e:	6145                	addi	sp,sp,48
ffffffffc020b040:	8082                	ret
ffffffffc020b042:	4481                	li	s1,0
ffffffffc020b044:	b7e5                	j	ffffffffc020b02c <sfs_clear_block+0x46>

ffffffffc020b046 <lock_sfs_fs>:
ffffffffc020b046:	05050513          	addi	a0,a0,80
ffffffffc020b04a:	d98f906f          	j	ffffffffc02045e2 <down>

ffffffffc020b04e <lock_sfs_io>:
ffffffffc020b04e:	06850513          	addi	a0,a0,104
ffffffffc020b052:	d90f906f          	j	ffffffffc02045e2 <down>

ffffffffc020b056 <unlock_sfs_fs>:
ffffffffc020b056:	05050513          	addi	a0,a0,80
ffffffffc020b05a:	d84f906f          	j	ffffffffc02045de <up>

ffffffffc020b05e <unlock_sfs_io>:
ffffffffc020b05e:	06850513          	addi	a0,a0,104
ffffffffc020b062:	d7cf906f          	j	ffffffffc02045de <up>

ffffffffc020b066 <hash32>:
ffffffffc020b066:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b06a:	2785                	addiw	a5,a5,1
ffffffffc020b06c:	02a7853b          	mulw	a0,a5,a0
ffffffffc020b070:	02000793          	li	a5,32
ffffffffc020b074:	9f8d                	subw	a5,a5,a1
ffffffffc020b076:	00f5553b          	srlw	a0,a0,a5
ffffffffc020b07a:	8082                	ret

ffffffffc020b07c <printnum>:
ffffffffc020b07c:	02071893          	slli	a7,a4,0x20
ffffffffc020b080:	7139                	addi	sp,sp,-64
ffffffffc020b082:	0208d893          	srli	a7,a7,0x20
ffffffffc020b086:	e456                	sd	s5,8(sp)
ffffffffc020b088:	0316fab3          	remu	s5,a3,a7
ffffffffc020b08c:	f822                	sd	s0,48(sp)
ffffffffc020b08e:	f426                	sd	s1,40(sp)
ffffffffc020b090:	f04a                	sd	s2,32(sp)
ffffffffc020b092:	ec4e                	sd	s3,24(sp)
ffffffffc020b094:	fc06                	sd	ra,56(sp)
ffffffffc020b096:	e852                	sd	s4,16(sp)
ffffffffc020b098:	84aa                	mv	s1,a0
ffffffffc020b09a:	89ae                	mv	s3,a1
ffffffffc020b09c:	8932                	mv	s2,a2
ffffffffc020b09e:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b0a2:	2a81                	sext.w	s5,s5
ffffffffc020b0a4:	0516f163          	bgeu	a3,a7,ffffffffc020b0e6 <printnum+0x6a>
ffffffffc020b0a8:	8a42                	mv	s4,a6
ffffffffc020b0aa:	00805863          	blez	s0,ffffffffc020b0ba <printnum+0x3e>
ffffffffc020b0ae:	347d                	addiw	s0,s0,-1
ffffffffc020b0b0:	864e                	mv	a2,s3
ffffffffc020b0b2:	85ca                	mv	a1,s2
ffffffffc020b0b4:	8552                	mv	a0,s4
ffffffffc020b0b6:	9482                	jalr	s1
ffffffffc020b0b8:	f87d                	bnez	s0,ffffffffc020b0ae <printnum+0x32>
ffffffffc020b0ba:	1a82                	slli	s5,s5,0x20
ffffffffc020b0bc:	00004797          	auipc	a5,0x4
ffffffffc020b0c0:	3ec78793          	addi	a5,a5,1004 # ffffffffc020f4a8 <sfs_node_fileops+0x118>
ffffffffc020b0c4:	020ada93          	srli	s5,s5,0x20
ffffffffc020b0c8:	9abe                	add	s5,s5,a5
ffffffffc020b0ca:	7442                	ld	s0,48(sp)
ffffffffc020b0cc:	000ac503          	lbu	a0,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020b0d0:	70e2                	ld	ra,56(sp)
ffffffffc020b0d2:	6a42                	ld	s4,16(sp)
ffffffffc020b0d4:	6aa2                	ld	s5,8(sp)
ffffffffc020b0d6:	864e                	mv	a2,s3
ffffffffc020b0d8:	85ca                	mv	a1,s2
ffffffffc020b0da:	69e2                	ld	s3,24(sp)
ffffffffc020b0dc:	7902                	ld	s2,32(sp)
ffffffffc020b0de:	87a6                	mv	a5,s1
ffffffffc020b0e0:	74a2                	ld	s1,40(sp)
ffffffffc020b0e2:	6121                	addi	sp,sp,64
ffffffffc020b0e4:	8782                	jr	a5
ffffffffc020b0e6:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b0ea:	87a2                	mv	a5,s0
ffffffffc020b0ec:	f91ff0ef          	jal	ra,ffffffffc020b07c <printnum>
ffffffffc020b0f0:	b7e9                	j	ffffffffc020b0ba <printnum+0x3e>

ffffffffc020b0f2 <sprintputch>:
ffffffffc020b0f2:	499c                	lw	a5,16(a1)
ffffffffc020b0f4:	6198                	ld	a4,0(a1)
ffffffffc020b0f6:	6594                	ld	a3,8(a1)
ffffffffc020b0f8:	2785                	addiw	a5,a5,1
ffffffffc020b0fa:	c99c                	sw	a5,16(a1)
ffffffffc020b0fc:	00d77763          	bgeu	a4,a3,ffffffffc020b10a <sprintputch+0x18>
ffffffffc020b100:	00170793          	addi	a5,a4,1
ffffffffc020b104:	e19c                	sd	a5,0(a1)
ffffffffc020b106:	00a70023          	sb	a0,0(a4)
ffffffffc020b10a:	8082                	ret

ffffffffc020b10c <vprintfmt>:
ffffffffc020b10c:	7119                	addi	sp,sp,-128
ffffffffc020b10e:	f4a6                	sd	s1,104(sp)
ffffffffc020b110:	f0ca                	sd	s2,96(sp)
ffffffffc020b112:	ecce                	sd	s3,88(sp)
ffffffffc020b114:	e8d2                	sd	s4,80(sp)
ffffffffc020b116:	e4d6                	sd	s5,72(sp)
ffffffffc020b118:	e0da                	sd	s6,64(sp)
ffffffffc020b11a:	fc5e                	sd	s7,56(sp)
ffffffffc020b11c:	ec6e                	sd	s11,24(sp)
ffffffffc020b11e:	fc86                	sd	ra,120(sp)
ffffffffc020b120:	f8a2                	sd	s0,112(sp)
ffffffffc020b122:	f862                	sd	s8,48(sp)
ffffffffc020b124:	f466                	sd	s9,40(sp)
ffffffffc020b126:	f06a                	sd	s10,32(sp)
ffffffffc020b128:	89aa                	mv	s3,a0
ffffffffc020b12a:	892e                	mv	s2,a1
ffffffffc020b12c:	84b2                	mv	s1,a2
ffffffffc020b12e:	8db6                	mv	s11,a3
ffffffffc020b130:	8aba                	mv	s5,a4
ffffffffc020b132:	02500a13          	li	s4,37
ffffffffc020b136:	5bfd                	li	s7,-1
ffffffffc020b138:	00004b17          	auipc	s6,0x4
ffffffffc020b13c:	39cb0b13          	addi	s6,s6,924 # ffffffffc020f4d4 <sfs_node_fileops+0x144>
ffffffffc020b140:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020b144:	001d8413          	addi	s0,s11,1
ffffffffc020b148:	01450b63          	beq	a0,s4,ffffffffc020b15e <vprintfmt+0x52>
ffffffffc020b14c:	c129                	beqz	a0,ffffffffc020b18e <vprintfmt+0x82>
ffffffffc020b14e:	864a                	mv	a2,s2
ffffffffc020b150:	85a6                	mv	a1,s1
ffffffffc020b152:	0405                	addi	s0,s0,1
ffffffffc020b154:	9982                	jalr	s3
ffffffffc020b156:	fff44503          	lbu	a0,-1(s0)
ffffffffc020b15a:	ff4519e3          	bne	a0,s4,ffffffffc020b14c <vprintfmt+0x40>
ffffffffc020b15e:	00044583          	lbu	a1,0(s0)
ffffffffc020b162:	02000813          	li	a6,32
ffffffffc020b166:	4d01                	li	s10,0
ffffffffc020b168:	4301                	li	t1,0
ffffffffc020b16a:	5cfd                	li	s9,-1
ffffffffc020b16c:	5c7d                	li	s8,-1
ffffffffc020b16e:	05500513          	li	a0,85
ffffffffc020b172:	48a5                	li	a7,9
ffffffffc020b174:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b178:	0ff67613          	zext.b	a2,a2
ffffffffc020b17c:	00140d93          	addi	s11,s0,1
ffffffffc020b180:	04c56263          	bltu	a0,a2,ffffffffc020b1c4 <vprintfmt+0xb8>
ffffffffc020b184:	060a                	slli	a2,a2,0x2
ffffffffc020b186:	965a                	add	a2,a2,s6
ffffffffc020b188:	4214                	lw	a3,0(a2)
ffffffffc020b18a:	96da                	add	a3,a3,s6
ffffffffc020b18c:	8682                	jr	a3
ffffffffc020b18e:	70e6                	ld	ra,120(sp)
ffffffffc020b190:	7446                	ld	s0,112(sp)
ffffffffc020b192:	74a6                	ld	s1,104(sp)
ffffffffc020b194:	7906                	ld	s2,96(sp)
ffffffffc020b196:	69e6                	ld	s3,88(sp)
ffffffffc020b198:	6a46                	ld	s4,80(sp)
ffffffffc020b19a:	6aa6                	ld	s5,72(sp)
ffffffffc020b19c:	6b06                	ld	s6,64(sp)
ffffffffc020b19e:	7be2                	ld	s7,56(sp)
ffffffffc020b1a0:	7c42                	ld	s8,48(sp)
ffffffffc020b1a2:	7ca2                	ld	s9,40(sp)
ffffffffc020b1a4:	7d02                	ld	s10,32(sp)
ffffffffc020b1a6:	6de2                	ld	s11,24(sp)
ffffffffc020b1a8:	6109                	addi	sp,sp,128
ffffffffc020b1aa:	8082                	ret
ffffffffc020b1ac:	882e                	mv	a6,a1
ffffffffc020b1ae:	00144583          	lbu	a1,1(s0)
ffffffffc020b1b2:	846e                	mv	s0,s11
ffffffffc020b1b4:	00140d93          	addi	s11,s0,1
ffffffffc020b1b8:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b1bc:	0ff67613          	zext.b	a2,a2
ffffffffc020b1c0:	fcc572e3          	bgeu	a0,a2,ffffffffc020b184 <vprintfmt+0x78>
ffffffffc020b1c4:	864a                	mv	a2,s2
ffffffffc020b1c6:	85a6                	mv	a1,s1
ffffffffc020b1c8:	02500513          	li	a0,37
ffffffffc020b1cc:	9982                	jalr	s3
ffffffffc020b1ce:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b1d2:	8da2                	mv	s11,s0
ffffffffc020b1d4:	f74786e3          	beq	a5,s4,ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b1d8:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b1dc:	1dfd                	addi	s11,s11,-1
ffffffffc020b1de:	ff479de3          	bne	a5,s4,ffffffffc020b1d8 <vprintfmt+0xcc>
ffffffffc020b1e2:	bfb9                	j	ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b1e4:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b1e8:	00144583          	lbu	a1,1(s0)
ffffffffc020b1ec:	846e                	mv	s0,s11
ffffffffc020b1ee:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b1f2:	0005861b          	sext.w	a2,a1
ffffffffc020b1f6:	02d8e463          	bltu	a7,a3,ffffffffc020b21e <vprintfmt+0x112>
ffffffffc020b1fa:	00144583          	lbu	a1,1(s0)
ffffffffc020b1fe:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b202:	0196873b          	addw	a4,a3,s9
ffffffffc020b206:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b20a:	9f31                	addw	a4,a4,a2
ffffffffc020b20c:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b210:	0405                	addi	s0,s0,1
ffffffffc020b212:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b216:	0005861b          	sext.w	a2,a1
ffffffffc020b21a:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b1fa <vprintfmt+0xee>
ffffffffc020b21e:	f40c5be3          	bgez	s8,ffffffffc020b174 <vprintfmt+0x68>
ffffffffc020b222:	8c66                	mv	s8,s9
ffffffffc020b224:	5cfd                	li	s9,-1
ffffffffc020b226:	b7b9                	j	ffffffffc020b174 <vprintfmt+0x68>
ffffffffc020b228:	fffc4693          	not	a3,s8
ffffffffc020b22c:	96fd                	srai	a3,a3,0x3f
ffffffffc020b22e:	00dc77b3          	and	a5,s8,a3
ffffffffc020b232:	00144583          	lbu	a1,1(s0)
ffffffffc020b236:	00078c1b          	sext.w	s8,a5
ffffffffc020b23a:	846e                	mv	s0,s11
ffffffffc020b23c:	bf25                	j	ffffffffc020b174 <vprintfmt+0x68>
ffffffffc020b23e:	000aac83          	lw	s9,0(s5)
ffffffffc020b242:	00144583          	lbu	a1,1(s0)
ffffffffc020b246:	0aa1                	addi	s5,s5,8
ffffffffc020b248:	846e                	mv	s0,s11
ffffffffc020b24a:	bfd1                	j	ffffffffc020b21e <vprintfmt+0x112>
ffffffffc020b24c:	4705                	li	a4,1
ffffffffc020b24e:	008a8613          	addi	a2,s5,8
ffffffffc020b252:	00674463          	blt	a4,t1,ffffffffc020b25a <vprintfmt+0x14e>
ffffffffc020b256:	1c030c63          	beqz	t1,ffffffffc020b42e <vprintfmt+0x322>
ffffffffc020b25a:	000ab683          	ld	a3,0(s5)
ffffffffc020b25e:	4741                	li	a4,16
ffffffffc020b260:	8ab2                	mv	s5,a2
ffffffffc020b262:	2801                	sext.w	a6,a6
ffffffffc020b264:	87e2                	mv	a5,s8
ffffffffc020b266:	8626                	mv	a2,s1
ffffffffc020b268:	85ca                	mv	a1,s2
ffffffffc020b26a:	854e                	mv	a0,s3
ffffffffc020b26c:	e11ff0ef          	jal	ra,ffffffffc020b07c <printnum>
ffffffffc020b270:	bdc1                	j	ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b272:	000aa503          	lw	a0,0(s5)
ffffffffc020b276:	864a                	mv	a2,s2
ffffffffc020b278:	85a6                	mv	a1,s1
ffffffffc020b27a:	0aa1                	addi	s5,s5,8
ffffffffc020b27c:	9982                	jalr	s3
ffffffffc020b27e:	b5c9                	j	ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b280:	4705                	li	a4,1
ffffffffc020b282:	008a8613          	addi	a2,s5,8
ffffffffc020b286:	00674463          	blt	a4,t1,ffffffffc020b28e <vprintfmt+0x182>
ffffffffc020b28a:	18030d63          	beqz	t1,ffffffffc020b424 <vprintfmt+0x318>
ffffffffc020b28e:	000ab683          	ld	a3,0(s5)
ffffffffc020b292:	4729                	li	a4,10
ffffffffc020b294:	8ab2                	mv	s5,a2
ffffffffc020b296:	b7f1                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b298:	00144583          	lbu	a1,1(s0)
ffffffffc020b29c:	4d05                	li	s10,1
ffffffffc020b29e:	846e                	mv	s0,s11
ffffffffc020b2a0:	bdd1                	j	ffffffffc020b174 <vprintfmt+0x68>
ffffffffc020b2a2:	864a                	mv	a2,s2
ffffffffc020b2a4:	85a6                	mv	a1,s1
ffffffffc020b2a6:	02500513          	li	a0,37
ffffffffc020b2aa:	9982                	jalr	s3
ffffffffc020b2ac:	bd51                	j	ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b2ae:	00144583          	lbu	a1,1(s0)
ffffffffc020b2b2:	2305                	addiw	t1,t1,1
ffffffffc020b2b4:	846e                	mv	s0,s11
ffffffffc020b2b6:	bd7d                	j	ffffffffc020b174 <vprintfmt+0x68>
ffffffffc020b2b8:	4705                	li	a4,1
ffffffffc020b2ba:	008a8613          	addi	a2,s5,8
ffffffffc020b2be:	00674463          	blt	a4,t1,ffffffffc020b2c6 <vprintfmt+0x1ba>
ffffffffc020b2c2:	14030c63          	beqz	t1,ffffffffc020b41a <vprintfmt+0x30e>
ffffffffc020b2c6:	000ab683          	ld	a3,0(s5)
ffffffffc020b2ca:	4721                	li	a4,8
ffffffffc020b2cc:	8ab2                	mv	s5,a2
ffffffffc020b2ce:	bf51                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b2d0:	03000513          	li	a0,48
ffffffffc020b2d4:	864a                	mv	a2,s2
ffffffffc020b2d6:	85a6                	mv	a1,s1
ffffffffc020b2d8:	e042                	sd	a6,0(sp)
ffffffffc020b2da:	9982                	jalr	s3
ffffffffc020b2dc:	864a                	mv	a2,s2
ffffffffc020b2de:	85a6                	mv	a1,s1
ffffffffc020b2e0:	07800513          	li	a0,120
ffffffffc020b2e4:	9982                	jalr	s3
ffffffffc020b2e6:	0aa1                	addi	s5,s5,8
ffffffffc020b2e8:	6802                	ld	a6,0(sp)
ffffffffc020b2ea:	4741                	li	a4,16
ffffffffc020b2ec:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b2f0:	bf8d                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b2f2:	000ab403          	ld	s0,0(s5)
ffffffffc020b2f6:	008a8793          	addi	a5,s5,8
ffffffffc020b2fa:	e03e                	sd	a5,0(sp)
ffffffffc020b2fc:	14040c63          	beqz	s0,ffffffffc020b454 <vprintfmt+0x348>
ffffffffc020b300:	11805063          	blez	s8,ffffffffc020b400 <vprintfmt+0x2f4>
ffffffffc020b304:	02d00693          	li	a3,45
ffffffffc020b308:	0cd81963          	bne	a6,a3,ffffffffc020b3da <vprintfmt+0x2ce>
ffffffffc020b30c:	00044683          	lbu	a3,0(s0)
ffffffffc020b310:	0006851b          	sext.w	a0,a3
ffffffffc020b314:	ce8d                	beqz	a3,ffffffffc020b34e <vprintfmt+0x242>
ffffffffc020b316:	00140a93          	addi	s5,s0,1
ffffffffc020b31a:	05e00413          	li	s0,94
ffffffffc020b31e:	000cc563          	bltz	s9,ffffffffc020b328 <vprintfmt+0x21c>
ffffffffc020b322:	3cfd                	addiw	s9,s9,-1
ffffffffc020b324:	037c8363          	beq	s9,s7,ffffffffc020b34a <vprintfmt+0x23e>
ffffffffc020b328:	864a                	mv	a2,s2
ffffffffc020b32a:	85a6                	mv	a1,s1
ffffffffc020b32c:	100d0663          	beqz	s10,ffffffffc020b438 <vprintfmt+0x32c>
ffffffffc020b330:	3681                	addiw	a3,a3,-32
ffffffffc020b332:	10d47363          	bgeu	s0,a3,ffffffffc020b438 <vprintfmt+0x32c>
ffffffffc020b336:	03f00513          	li	a0,63
ffffffffc020b33a:	9982                	jalr	s3
ffffffffc020b33c:	000ac683          	lbu	a3,0(s5)
ffffffffc020b340:	3c7d                	addiw	s8,s8,-1
ffffffffc020b342:	0a85                	addi	s5,s5,1
ffffffffc020b344:	0006851b          	sext.w	a0,a3
ffffffffc020b348:	faf9                	bnez	a3,ffffffffc020b31e <vprintfmt+0x212>
ffffffffc020b34a:	01805a63          	blez	s8,ffffffffc020b35e <vprintfmt+0x252>
ffffffffc020b34e:	3c7d                	addiw	s8,s8,-1
ffffffffc020b350:	864a                	mv	a2,s2
ffffffffc020b352:	85a6                	mv	a1,s1
ffffffffc020b354:	02000513          	li	a0,32
ffffffffc020b358:	9982                	jalr	s3
ffffffffc020b35a:	fe0c1ae3          	bnez	s8,ffffffffc020b34e <vprintfmt+0x242>
ffffffffc020b35e:	6a82                	ld	s5,0(sp)
ffffffffc020b360:	b3c5                	j	ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b362:	4705                	li	a4,1
ffffffffc020b364:	008a8d13          	addi	s10,s5,8
ffffffffc020b368:	00674463          	blt	a4,t1,ffffffffc020b370 <vprintfmt+0x264>
ffffffffc020b36c:	0a030463          	beqz	t1,ffffffffc020b414 <vprintfmt+0x308>
ffffffffc020b370:	000ab403          	ld	s0,0(s5)
ffffffffc020b374:	0c044463          	bltz	s0,ffffffffc020b43c <vprintfmt+0x330>
ffffffffc020b378:	86a2                	mv	a3,s0
ffffffffc020b37a:	8aea                	mv	s5,s10
ffffffffc020b37c:	4729                	li	a4,10
ffffffffc020b37e:	b5d5                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b380:	000aa783          	lw	a5,0(s5)
ffffffffc020b384:	46e1                	li	a3,24
ffffffffc020b386:	0aa1                	addi	s5,s5,8
ffffffffc020b388:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b38c:	8fb9                	xor	a5,a5,a4
ffffffffc020b38e:	40e7873b          	subw	a4,a5,a4
ffffffffc020b392:	02e6c663          	blt	a3,a4,ffffffffc020b3be <vprintfmt+0x2b2>
ffffffffc020b396:	00371793          	slli	a5,a4,0x3
ffffffffc020b39a:	00004697          	auipc	a3,0x4
ffffffffc020b39e:	46e68693          	addi	a3,a3,1134 # ffffffffc020f808 <error_string>
ffffffffc020b3a2:	97b6                	add	a5,a5,a3
ffffffffc020b3a4:	639c                	ld	a5,0(a5)
ffffffffc020b3a6:	cf81                	beqz	a5,ffffffffc020b3be <vprintfmt+0x2b2>
ffffffffc020b3a8:	873e                	mv	a4,a5
ffffffffc020b3aa:	00000697          	auipc	a3,0x0
ffffffffc020b3ae:	28668693          	addi	a3,a3,646 # ffffffffc020b630 <etext+0x2c>
ffffffffc020b3b2:	8626                	mv	a2,s1
ffffffffc020b3b4:	85ca                	mv	a1,s2
ffffffffc020b3b6:	854e                	mv	a0,s3
ffffffffc020b3b8:	0d4000ef          	jal	ra,ffffffffc020b48c <printfmt>
ffffffffc020b3bc:	b351                	j	ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b3be:	00004697          	auipc	a3,0x4
ffffffffc020b3c2:	10a68693          	addi	a3,a3,266 # ffffffffc020f4c8 <sfs_node_fileops+0x138>
ffffffffc020b3c6:	8626                	mv	a2,s1
ffffffffc020b3c8:	85ca                	mv	a1,s2
ffffffffc020b3ca:	854e                	mv	a0,s3
ffffffffc020b3cc:	0c0000ef          	jal	ra,ffffffffc020b48c <printfmt>
ffffffffc020b3d0:	bb85                	j	ffffffffc020b140 <vprintfmt+0x34>
ffffffffc020b3d2:	00004417          	auipc	s0,0x4
ffffffffc020b3d6:	0ee40413          	addi	s0,s0,238 # ffffffffc020f4c0 <sfs_node_fileops+0x130>
ffffffffc020b3da:	85e6                	mv	a1,s9
ffffffffc020b3dc:	8522                	mv	a0,s0
ffffffffc020b3de:	e442                	sd	a6,8(sp)
ffffffffc020b3e0:	132000ef          	jal	ra,ffffffffc020b512 <strnlen>
ffffffffc020b3e4:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b3e8:	01805c63          	blez	s8,ffffffffc020b400 <vprintfmt+0x2f4>
ffffffffc020b3ec:	6822                	ld	a6,8(sp)
ffffffffc020b3ee:	00080a9b          	sext.w	s5,a6
ffffffffc020b3f2:	3c7d                	addiw	s8,s8,-1
ffffffffc020b3f4:	864a                	mv	a2,s2
ffffffffc020b3f6:	85a6                	mv	a1,s1
ffffffffc020b3f8:	8556                	mv	a0,s5
ffffffffc020b3fa:	9982                	jalr	s3
ffffffffc020b3fc:	fe0c1be3          	bnez	s8,ffffffffc020b3f2 <vprintfmt+0x2e6>
ffffffffc020b400:	00044683          	lbu	a3,0(s0)
ffffffffc020b404:	00140a93          	addi	s5,s0,1
ffffffffc020b408:	0006851b          	sext.w	a0,a3
ffffffffc020b40c:	daa9                	beqz	a3,ffffffffc020b35e <vprintfmt+0x252>
ffffffffc020b40e:	05e00413          	li	s0,94
ffffffffc020b412:	b731                	j	ffffffffc020b31e <vprintfmt+0x212>
ffffffffc020b414:	000aa403          	lw	s0,0(s5)
ffffffffc020b418:	bfb1                	j	ffffffffc020b374 <vprintfmt+0x268>
ffffffffc020b41a:	000ae683          	lwu	a3,0(s5)
ffffffffc020b41e:	4721                	li	a4,8
ffffffffc020b420:	8ab2                	mv	s5,a2
ffffffffc020b422:	b581                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b424:	000ae683          	lwu	a3,0(s5)
ffffffffc020b428:	4729                	li	a4,10
ffffffffc020b42a:	8ab2                	mv	s5,a2
ffffffffc020b42c:	bd1d                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b42e:	000ae683          	lwu	a3,0(s5)
ffffffffc020b432:	4741                	li	a4,16
ffffffffc020b434:	8ab2                	mv	s5,a2
ffffffffc020b436:	b535                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b438:	9982                	jalr	s3
ffffffffc020b43a:	b709                	j	ffffffffc020b33c <vprintfmt+0x230>
ffffffffc020b43c:	864a                	mv	a2,s2
ffffffffc020b43e:	85a6                	mv	a1,s1
ffffffffc020b440:	02d00513          	li	a0,45
ffffffffc020b444:	e042                	sd	a6,0(sp)
ffffffffc020b446:	9982                	jalr	s3
ffffffffc020b448:	6802                	ld	a6,0(sp)
ffffffffc020b44a:	8aea                	mv	s5,s10
ffffffffc020b44c:	408006b3          	neg	a3,s0
ffffffffc020b450:	4729                	li	a4,10
ffffffffc020b452:	bd01                	j	ffffffffc020b262 <vprintfmt+0x156>
ffffffffc020b454:	03805163          	blez	s8,ffffffffc020b476 <vprintfmt+0x36a>
ffffffffc020b458:	02d00693          	li	a3,45
ffffffffc020b45c:	f6d81be3          	bne	a6,a3,ffffffffc020b3d2 <vprintfmt+0x2c6>
ffffffffc020b460:	00004417          	auipc	s0,0x4
ffffffffc020b464:	06040413          	addi	s0,s0,96 # ffffffffc020f4c0 <sfs_node_fileops+0x130>
ffffffffc020b468:	02800693          	li	a3,40
ffffffffc020b46c:	02800513          	li	a0,40
ffffffffc020b470:	00140a93          	addi	s5,s0,1
ffffffffc020b474:	b55d                	j	ffffffffc020b31a <vprintfmt+0x20e>
ffffffffc020b476:	00004a97          	auipc	s5,0x4
ffffffffc020b47a:	04ba8a93          	addi	s5,s5,75 # ffffffffc020f4c1 <sfs_node_fileops+0x131>
ffffffffc020b47e:	02800513          	li	a0,40
ffffffffc020b482:	02800693          	li	a3,40
ffffffffc020b486:	05e00413          	li	s0,94
ffffffffc020b48a:	bd51                	j	ffffffffc020b31e <vprintfmt+0x212>

ffffffffc020b48c <printfmt>:
ffffffffc020b48c:	7139                	addi	sp,sp,-64
ffffffffc020b48e:	02010313          	addi	t1,sp,32
ffffffffc020b492:	f03a                	sd	a4,32(sp)
ffffffffc020b494:	871a                	mv	a4,t1
ffffffffc020b496:	ec06                	sd	ra,24(sp)
ffffffffc020b498:	f43e                	sd	a5,40(sp)
ffffffffc020b49a:	f842                	sd	a6,48(sp)
ffffffffc020b49c:	fc46                	sd	a7,56(sp)
ffffffffc020b49e:	e41a                	sd	t1,8(sp)
ffffffffc020b4a0:	c6dff0ef          	jal	ra,ffffffffc020b10c <vprintfmt>
ffffffffc020b4a4:	60e2                	ld	ra,24(sp)
ffffffffc020b4a6:	6121                	addi	sp,sp,64
ffffffffc020b4a8:	8082                	ret

ffffffffc020b4aa <snprintf>:
ffffffffc020b4aa:	711d                	addi	sp,sp,-96
ffffffffc020b4ac:	15fd                	addi	a1,a1,-1
ffffffffc020b4ae:	03810313          	addi	t1,sp,56
ffffffffc020b4b2:	95aa                	add	a1,a1,a0
ffffffffc020b4b4:	f406                	sd	ra,40(sp)
ffffffffc020b4b6:	fc36                	sd	a3,56(sp)
ffffffffc020b4b8:	e0ba                	sd	a4,64(sp)
ffffffffc020b4ba:	e4be                	sd	a5,72(sp)
ffffffffc020b4bc:	e8c2                	sd	a6,80(sp)
ffffffffc020b4be:	ecc6                	sd	a7,88(sp)
ffffffffc020b4c0:	e01a                	sd	t1,0(sp)
ffffffffc020b4c2:	e42a                	sd	a0,8(sp)
ffffffffc020b4c4:	e82e                	sd	a1,16(sp)
ffffffffc020b4c6:	cc02                	sw	zero,24(sp)
ffffffffc020b4c8:	c515                	beqz	a0,ffffffffc020b4f4 <snprintf+0x4a>
ffffffffc020b4ca:	02a5e563          	bltu	a1,a0,ffffffffc020b4f4 <snprintf+0x4a>
ffffffffc020b4ce:	75dd                	lui	a1,0xffff7
ffffffffc020b4d0:	86b2                	mv	a3,a2
ffffffffc020b4d2:	00000517          	auipc	a0,0x0
ffffffffc020b4d6:	c2050513          	addi	a0,a0,-992 # ffffffffc020b0f2 <sprintputch>
ffffffffc020b4da:	871a                	mv	a4,t1
ffffffffc020b4dc:	0030                	addi	a2,sp,8
ffffffffc020b4de:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b4e2:	c2bff0ef          	jal	ra,ffffffffc020b10c <vprintfmt>
ffffffffc020b4e6:	67a2                	ld	a5,8(sp)
ffffffffc020b4e8:	00078023          	sb	zero,0(a5)
ffffffffc020b4ec:	4562                	lw	a0,24(sp)
ffffffffc020b4ee:	70a2                	ld	ra,40(sp)
ffffffffc020b4f0:	6125                	addi	sp,sp,96
ffffffffc020b4f2:	8082                	ret
ffffffffc020b4f4:	5575                	li	a0,-3
ffffffffc020b4f6:	bfe5                	j	ffffffffc020b4ee <snprintf+0x44>

ffffffffc020b4f8 <strlen>:
ffffffffc020b4f8:	00054783          	lbu	a5,0(a0)
ffffffffc020b4fc:	872a                	mv	a4,a0
ffffffffc020b4fe:	4501                	li	a0,0
ffffffffc020b500:	cb81                	beqz	a5,ffffffffc020b510 <strlen+0x18>
ffffffffc020b502:	0505                	addi	a0,a0,1
ffffffffc020b504:	00a707b3          	add	a5,a4,a0
ffffffffc020b508:	0007c783          	lbu	a5,0(a5)
ffffffffc020b50c:	fbfd                	bnez	a5,ffffffffc020b502 <strlen+0xa>
ffffffffc020b50e:	8082                	ret
ffffffffc020b510:	8082                	ret

ffffffffc020b512 <strnlen>:
ffffffffc020b512:	4781                	li	a5,0
ffffffffc020b514:	e589                	bnez	a1,ffffffffc020b51e <strnlen+0xc>
ffffffffc020b516:	a811                	j	ffffffffc020b52a <strnlen+0x18>
ffffffffc020b518:	0785                	addi	a5,a5,1
ffffffffc020b51a:	00f58863          	beq	a1,a5,ffffffffc020b52a <strnlen+0x18>
ffffffffc020b51e:	00f50733          	add	a4,a0,a5
ffffffffc020b522:	00074703          	lbu	a4,0(a4)
ffffffffc020b526:	fb6d                	bnez	a4,ffffffffc020b518 <strnlen+0x6>
ffffffffc020b528:	85be                	mv	a1,a5
ffffffffc020b52a:	852e                	mv	a0,a1
ffffffffc020b52c:	8082                	ret

ffffffffc020b52e <strcpy>:
ffffffffc020b52e:	87aa                	mv	a5,a0
ffffffffc020b530:	0005c703          	lbu	a4,0(a1)
ffffffffc020b534:	0785                	addi	a5,a5,1
ffffffffc020b536:	0585                	addi	a1,a1,1
ffffffffc020b538:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b53c:	fb75                	bnez	a4,ffffffffc020b530 <strcpy+0x2>
ffffffffc020b53e:	8082                	ret

ffffffffc020b540 <strcmp>:
ffffffffc020b540:	00054783          	lbu	a5,0(a0)
ffffffffc020b544:	0005c703          	lbu	a4,0(a1)
ffffffffc020b548:	cb89                	beqz	a5,ffffffffc020b55a <strcmp+0x1a>
ffffffffc020b54a:	0505                	addi	a0,a0,1
ffffffffc020b54c:	0585                	addi	a1,a1,1
ffffffffc020b54e:	fee789e3          	beq	a5,a4,ffffffffc020b540 <strcmp>
ffffffffc020b552:	0007851b          	sext.w	a0,a5
ffffffffc020b556:	9d19                	subw	a0,a0,a4
ffffffffc020b558:	8082                	ret
ffffffffc020b55a:	4501                	li	a0,0
ffffffffc020b55c:	bfed                	j	ffffffffc020b556 <strcmp+0x16>

ffffffffc020b55e <strncmp>:
ffffffffc020b55e:	c20d                	beqz	a2,ffffffffc020b580 <strncmp+0x22>
ffffffffc020b560:	962e                	add	a2,a2,a1
ffffffffc020b562:	a031                	j	ffffffffc020b56e <strncmp+0x10>
ffffffffc020b564:	0505                	addi	a0,a0,1
ffffffffc020b566:	00e79a63          	bne	a5,a4,ffffffffc020b57a <strncmp+0x1c>
ffffffffc020b56a:	00b60b63          	beq	a2,a1,ffffffffc020b580 <strncmp+0x22>
ffffffffc020b56e:	00054783          	lbu	a5,0(a0)
ffffffffc020b572:	0585                	addi	a1,a1,1
ffffffffc020b574:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020b578:	f7f5                	bnez	a5,ffffffffc020b564 <strncmp+0x6>
ffffffffc020b57a:	40e7853b          	subw	a0,a5,a4
ffffffffc020b57e:	8082                	ret
ffffffffc020b580:	4501                	li	a0,0
ffffffffc020b582:	8082                	ret

ffffffffc020b584 <strchr>:
ffffffffc020b584:	00054783          	lbu	a5,0(a0)
ffffffffc020b588:	c799                	beqz	a5,ffffffffc020b596 <strchr+0x12>
ffffffffc020b58a:	00f58763          	beq	a1,a5,ffffffffc020b598 <strchr+0x14>
ffffffffc020b58e:	00154783          	lbu	a5,1(a0)
ffffffffc020b592:	0505                	addi	a0,a0,1
ffffffffc020b594:	fbfd                	bnez	a5,ffffffffc020b58a <strchr+0x6>
ffffffffc020b596:	4501                	li	a0,0
ffffffffc020b598:	8082                	ret

ffffffffc020b59a <memset>:
ffffffffc020b59a:	ca01                	beqz	a2,ffffffffc020b5aa <memset+0x10>
ffffffffc020b59c:	962a                	add	a2,a2,a0
ffffffffc020b59e:	87aa                	mv	a5,a0
ffffffffc020b5a0:	0785                	addi	a5,a5,1
ffffffffc020b5a2:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b5a6:	fec79de3          	bne	a5,a2,ffffffffc020b5a0 <memset+0x6>
ffffffffc020b5aa:	8082                	ret

ffffffffc020b5ac <memmove>:
ffffffffc020b5ac:	02a5f263          	bgeu	a1,a0,ffffffffc020b5d0 <memmove+0x24>
ffffffffc020b5b0:	00c587b3          	add	a5,a1,a2
ffffffffc020b5b4:	00f57e63          	bgeu	a0,a5,ffffffffc020b5d0 <memmove+0x24>
ffffffffc020b5b8:	00c50733          	add	a4,a0,a2
ffffffffc020b5bc:	c615                	beqz	a2,ffffffffc020b5e8 <memmove+0x3c>
ffffffffc020b5be:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020b5c2:	17fd                	addi	a5,a5,-1
ffffffffc020b5c4:	177d                	addi	a4,a4,-1
ffffffffc020b5c6:	00d70023          	sb	a3,0(a4)
ffffffffc020b5ca:	fef59ae3          	bne	a1,a5,ffffffffc020b5be <memmove+0x12>
ffffffffc020b5ce:	8082                	ret
ffffffffc020b5d0:	00c586b3          	add	a3,a1,a2
ffffffffc020b5d4:	87aa                	mv	a5,a0
ffffffffc020b5d6:	ca11                	beqz	a2,ffffffffc020b5ea <memmove+0x3e>
ffffffffc020b5d8:	0005c703          	lbu	a4,0(a1)
ffffffffc020b5dc:	0585                	addi	a1,a1,1
ffffffffc020b5de:	0785                	addi	a5,a5,1
ffffffffc020b5e0:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b5e4:	fed59ae3          	bne	a1,a3,ffffffffc020b5d8 <memmove+0x2c>
ffffffffc020b5e8:	8082                	ret
ffffffffc020b5ea:	8082                	ret

ffffffffc020b5ec <memcpy>:
ffffffffc020b5ec:	ca19                	beqz	a2,ffffffffc020b602 <memcpy+0x16>
ffffffffc020b5ee:	962e                	add	a2,a2,a1
ffffffffc020b5f0:	87aa                	mv	a5,a0
ffffffffc020b5f2:	0005c703          	lbu	a4,0(a1)
ffffffffc020b5f6:	0585                	addi	a1,a1,1
ffffffffc020b5f8:	0785                	addi	a5,a5,1
ffffffffc020b5fa:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b5fe:	fec59ae3          	bne	a1,a2,ffffffffc020b5f2 <memcpy+0x6>
ffffffffc020b602:	8082                	ret
