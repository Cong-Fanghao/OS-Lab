
obj/__user_testbss.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa89                	j	800176 <sys_open>

0000000000800026 <close>:
  800026:	aaa9                	j	800180 <sys_close>

0000000000800028 <dup2>:
  800028:	a285                	j	800188 <sys_dup>

000000000080002a <_start>:
  80002a:	1c2000ef          	jal	ra,8001ec <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	8e2e                	mv	t3,a1
  800034:	e822                	sd	s0,16(sp)
  800036:	85aa                	mv	a1,a0
  800038:	8432                	mv	s0,a2
  80003a:	fc3e                	sd	a5,56(sp)
  80003c:	8672                	mv	a2,t3
  80003e:	103c                	addi	a5,sp,40
  800040:	00000517          	auipc	a0,0x0
  800044:	71050513          	addi	a0,a0,1808 # 800750 <main+0xc0>
  800048:	ec06                	sd	ra,24(sp)
  80004a:	f436                	sd	a3,40(sp)
  80004c:	f83a                	sd	a4,48(sp)
  80004e:	e0c2                	sd	a6,64(sp)
  800050:	e4c6                	sd	a7,72(sp)
  800052:	e43e                	sd	a5,8(sp)
  800054:	0a2000ef          	jal	ra,8000f6 <cprintf>
  800058:	65a2                	ld	a1,8(sp)
  80005a:	8522                	mv	a0,s0
  80005c:	074000ef          	jal	ra,8000d0 <vcprintf>
  800060:	00000517          	auipc	a0,0x0
  800064:	76850513          	addi	a0,a0,1896 # 8007c8 <main+0x138>
  800068:	08e000ef          	jal	ra,8000f6 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	124000ef          	jal	ra,800192 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	832e                	mv	t1,a1
  800076:	e822                	sd	s0,16(sp)
  800078:	85aa                	mv	a1,a0
  80007a:	8432                	mv	s0,a2
  80007c:	fc3e                	sd	a5,56(sp)
  80007e:	861a                	mv	a2,t1
  800080:	103c                	addi	a5,sp,40
  800082:	00000517          	auipc	a0,0x0
  800086:	6ee50513          	addi	a0,a0,1774 # 800770 <main+0xe0>
  80008a:	ec06                	sd	ra,24(sp)
  80008c:	f436                	sd	a3,40(sp)
  80008e:	f83a                	sd	a4,48(sp)
  800090:	e0c2                	sd	a6,64(sp)
  800092:	e4c6                	sd	a7,72(sp)
  800094:	e43e                	sd	a5,8(sp)
  800096:	060000ef          	jal	ra,8000f6 <cprintf>
  80009a:	65a2                	ld	a1,8(sp)
  80009c:	8522                	mv	a0,s0
  80009e:	032000ef          	jal	ra,8000d0 <vcprintf>
  8000a2:	00000517          	auipc	a0,0x0
  8000a6:	72650513          	addi	a0,a0,1830 # 8007c8 <main+0x138>
  8000aa:	04c000ef          	jal	ra,8000f6 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1141                	addi	sp,sp,-16
  8000b8:	e022                	sd	s0,0(sp)
  8000ba:	e406                	sd	ra,8(sp)
  8000bc:	842e                	mv	s0,a1
  8000be:	0b2000ef          	jal	ra,800170 <sys_putc>
  8000c2:	401c                	lw	a5,0(s0)
  8000c4:	60a2                	ld	ra,8(sp)
  8000c6:	2785                	addiw	a5,a5,1
  8000c8:	c01c                	sw	a5,0(s0)
  8000ca:	6402                	ld	s0,0(sp)
  8000cc:	0141                	addi	sp,sp,16
  8000ce:	8082                	ret

00000000008000d0 <vcprintf>:
  8000d0:	1101                	addi	sp,sp,-32
  8000d2:	872e                	mv	a4,a1
  8000d4:	75dd                	lui	a1,0xffff7
  8000d6:	86aa                	mv	a3,a0
  8000d8:	0070                	addi	a2,sp,12
  8000da:	00000517          	auipc	a0,0x0
  8000de:	fdc50513          	addi	a0,a0,-36 # 8000b6 <cputch>
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <bigarray+0xffffffffff7f5ad9>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	1ec000ef          	jal	ra,8002d6 <vprintfmt>
  8000ee:	60e2                	ld	ra,24(sp)
  8000f0:	4532                	lw	a0,12(sp)
  8000f2:	6105                	addi	sp,sp,32
  8000f4:	8082                	ret

00000000008000f6 <cprintf>:
  8000f6:	711d                	addi	sp,sp,-96
  8000f8:	02810313          	addi	t1,sp,40
  8000fc:	8e2a                	mv	t3,a0
  8000fe:	f42e                	sd	a1,40(sp)
  800100:	75dd                	lui	a1,0xffff7
  800102:	f832                	sd	a2,48(sp)
  800104:	fc36                	sd	a3,56(sp)
  800106:	e0ba                	sd	a4,64(sp)
  800108:	00000517          	auipc	a0,0x0
  80010c:	fae50513          	addi	a0,a0,-82 # 8000b6 <cputch>
  800110:	0050                	addi	a2,sp,4
  800112:	871a                	mv	a4,t1
  800114:	86f2                	mv	a3,t3
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <bigarray+0xffffffffff7f5ad9>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1b0000ef          	jal	ra,8002d6 <vprintfmt>
  80012a:	60e2                	ld	ra,24(sp)
  80012c:	4512                	lw	a0,4(sp)
  80012e:	6125                	addi	sp,sp,96
  800130:	8082                	ret

0000000000800132 <syscall>:
  800132:	7175                	addi	sp,sp,-144
  800134:	f8ba                	sd	a4,112(sp)
  800136:	e0ba                	sd	a4,64(sp)
  800138:	0118                	addi	a4,sp,128
  80013a:	e42a                	sd	a0,8(sp)
  80013c:	ecae                	sd	a1,88(sp)
  80013e:	f0b2                	sd	a2,96(sp)
  800140:	f4b6                	sd	a3,104(sp)
  800142:	fcbe                	sd	a5,120(sp)
  800144:	e142                	sd	a6,128(sp)
  800146:	e546                	sd	a7,136(sp)
  800148:	f42e                	sd	a1,40(sp)
  80014a:	f832                	sd	a2,48(sp)
  80014c:	fc36                	sd	a3,56(sp)
  80014e:	f03a                	sd	a4,32(sp)
  800150:	e4be                	sd	a5,72(sp)
  800152:	4522                	lw	a0,8(sp)
  800154:	55a2                	lw	a1,40(sp)
  800156:	5642                	lw	a2,48(sp)
  800158:	56e2                	lw	a3,56(sp)
  80015a:	4706                	lw	a4,64(sp)
  80015c:	47a6                	lw	a5,72(sp)
  80015e:	00000073          	ecall
  800162:	ce2a                	sw	a0,28(sp)
  800164:	4572                	lw	a0,28(sp)
  800166:	6149                	addi	sp,sp,144
  800168:	8082                	ret

000000000080016a <sys_exit>:
  80016a:	85aa                	mv	a1,a0
  80016c:	4505                	li	a0,1
  80016e:	b7d1                	j	800132 <syscall>

0000000000800170 <sys_putc>:
  800170:	85aa                	mv	a1,a0
  800172:	4579                	li	a0,30
  800174:	bf7d                	j	800132 <syscall>

0000000000800176 <sys_open>:
  800176:	862e                	mv	a2,a1
  800178:	85aa                	mv	a1,a0
  80017a:	06400513          	li	a0,100
  80017e:	bf55                	j	800132 <syscall>

0000000000800180 <sys_close>:
  800180:	85aa                	mv	a1,a0
  800182:	06500513          	li	a0,101
  800186:	b775                	j	800132 <syscall>

0000000000800188 <sys_dup>:
  800188:	862e                	mv	a2,a1
  80018a:	85aa                	mv	a1,a0
  80018c:	08200513          	li	a0,130
  800190:	b74d                	j	800132 <syscall>

0000000000800192 <exit>:
  800192:	1141                	addi	sp,sp,-16
  800194:	e406                	sd	ra,8(sp)
  800196:	fd5ff0ef          	jal	ra,80016a <sys_exit>
  80019a:	00000517          	auipc	a0,0x0
  80019e:	5f650513          	addi	a0,a0,1526 # 800790 <main+0x100>
  8001a2:	f55ff0ef          	jal	ra,8000f6 <cprintf>
  8001a6:	a001                	j	8001a6 <exit+0x14>

00000000008001a8 <initfd>:
  8001a8:	1101                	addi	sp,sp,-32
  8001aa:	87ae                	mv	a5,a1
  8001ac:	e426                	sd	s1,8(sp)
  8001ae:	85b2                	mv	a1,a2
  8001b0:	84aa                	mv	s1,a0
  8001b2:	853e                	mv	a0,a5
  8001b4:	e822                	sd	s0,16(sp)
  8001b6:	ec06                	sd	ra,24(sp)
  8001b8:	e69ff0ef          	jal	ra,800020 <open>
  8001bc:	842a                	mv	s0,a0
  8001be:	00054463          	bltz	a0,8001c6 <initfd+0x1e>
  8001c2:	00951863          	bne	a0,s1,8001d2 <initfd+0x2a>
  8001c6:	60e2                	ld	ra,24(sp)
  8001c8:	8522                	mv	a0,s0
  8001ca:	6442                	ld	s0,16(sp)
  8001cc:	64a2                	ld	s1,8(sp)
  8001ce:	6105                	addi	sp,sp,32
  8001d0:	8082                	ret
  8001d2:	8526                	mv	a0,s1
  8001d4:	e53ff0ef          	jal	ra,800026 <close>
  8001d8:	85a6                	mv	a1,s1
  8001da:	8522                	mv	a0,s0
  8001dc:	e4dff0ef          	jal	ra,800028 <dup2>
  8001e0:	84aa                	mv	s1,a0
  8001e2:	8522                	mv	a0,s0
  8001e4:	e43ff0ef          	jal	ra,800026 <close>
  8001e8:	8426                	mv	s0,s1
  8001ea:	bff1                	j	8001c6 <initfd+0x1e>

00000000008001ec <umain>:
  8001ec:	1101                	addi	sp,sp,-32
  8001ee:	e822                	sd	s0,16(sp)
  8001f0:	e426                	sd	s1,8(sp)
  8001f2:	842a                	mv	s0,a0
  8001f4:	84ae                	mv	s1,a1
  8001f6:	4601                	li	a2,0
  8001f8:	00000597          	auipc	a1,0x0
  8001fc:	5b058593          	addi	a1,a1,1456 # 8007a8 <main+0x118>
  800200:	4501                	li	a0,0
  800202:	ec06                	sd	ra,24(sp)
  800204:	fa5ff0ef          	jal	ra,8001a8 <initfd>
  800208:	02054263          	bltz	a0,80022c <umain+0x40>
  80020c:	4605                	li	a2,1
  80020e:	00000597          	auipc	a1,0x0
  800212:	5da58593          	addi	a1,a1,1498 # 8007e8 <main+0x158>
  800216:	4505                	li	a0,1
  800218:	f91ff0ef          	jal	ra,8001a8 <initfd>
  80021c:	02054563          	bltz	a0,800246 <umain+0x5a>
  800220:	85a6                	mv	a1,s1
  800222:	8522                	mv	a0,s0
  800224:	46c000ef          	jal	ra,800690 <main>
  800228:	f6bff0ef          	jal	ra,800192 <exit>
  80022c:	86aa                	mv	a3,a0
  80022e:	00000617          	auipc	a2,0x0
  800232:	58260613          	addi	a2,a2,1410 # 8007b0 <main+0x120>
  800236:	45e9                	li	a1,26
  800238:	00000517          	auipc	a0,0x0
  80023c:	59850513          	addi	a0,a0,1432 # 8007d0 <main+0x140>
  800240:	e33ff0ef          	jal	ra,800072 <__warn>
  800244:	b7e1                	j	80020c <umain+0x20>
  800246:	86aa                	mv	a3,a0
  800248:	00000617          	auipc	a2,0x0
  80024c:	5a860613          	addi	a2,a2,1448 # 8007f0 <main+0x160>
  800250:	45f5                	li	a1,29
  800252:	00000517          	auipc	a0,0x0
  800256:	57e50513          	addi	a0,a0,1406 # 8007d0 <main+0x140>
  80025a:	e19ff0ef          	jal	ra,800072 <__warn>
  80025e:	b7c9                	j	800220 <umain+0x34>

0000000000800260 <printnum>:
  800260:	02071893          	slli	a7,a4,0x20
  800264:	7139                	addi	sp,sp,-64
  800266:	0208d893          	srli	a7,a7,0x20
  80026a:	e456                	sd	s5,8(sp)
  80026c:	0316fab3          	remu	s5,a3,a7
  800270:	f822                	sd	s0,48(sp)
  800272:	f426                	sd	s1,40(sp)
  800274:	f04a                	sd	s2,32(sp)
  800276:	ec4e                	sd	s3,24(sp)
  800278:	fc06                	sd	ra,56(sp)
  80027a:	e852                	sd	s4,16(sp)
  80027c:	84aa                	mv	s1,a0
  80027e:	89ae                	mv	s3,a1
  800280:	8932                	mv	s2,a2
  800282:	fff7841b          	addiw	s0,a5,-1
  800286:	2a81                	sext.w	s5,s5
  800288:	0516f163          	bgeu	a3,a7,8002ca <printnum+0x6a>
  80028c:	8a42                	mv	s4,a6
  80028e:	00805863          	blez	s0,80029e <printnum+0x3e>
  800292:	347d                	addiw	s0,s0,-1
  800294:	864e                	mv	a2,s3
  800296:	85ca                	mv	a1,s2
  800298:	8552                	mv	a0,s4
  80029a:	9482                	jalr	s1
  80029c:	f87d                	bnez	s0,800292 <printnum+0x32>
  80029e:	1a82                	slli	s5,s5,0x20
  8002a0:	00000797          	auipc	a5,0x0
  8002a4:	57078793          	addi	a5,a5,1392 # 800810 <main+0x180>
  8002a8:	020ada93          	srli	s5,s5,0x20
  8002ac:	9abe                	add	s5,s5,a5
  8002ae:	7442                	ld	s0,48(sp)
  8002b0:	000ac503          	lbu	a0,0(s5)
  8002b4:	70e2                	ld	ra,56(sp)
  8002b6:	6a42                	ld	s4,16(sp)
  8002b8:	6aa2                	ld	s5,8(sp)
  8002ba:	864e                	mv	a2,s3
  8002bc:	85ca                	mv	a1,s2
  8002be:	69e2                	ld	s3,24(sp)
  8002c0:	7902                	ld	s2,32(sp)
  8002c2:	87a6                	mv	a5,s1
  8002c4:	74a2                	ld	s1,40(sp)
  8002c6:	6121                	addi	sp,sp,64
  8002c8:	8782                	jr	a5
  8002ca:	0316d6b3          	divu	a3,a3,a7
  8002ce:	87a2                	mv	a5,s0
  8002d0:	f91ff0ef          	jal	ra,800260 <printnum>
  8002d4:	b7e9                	j	80029e <printnum+0x3e>

00000000008002d6 <vprintfmt>:
  8002d6:	7119                	addi	sp,sp,-128
  8002d8:	f4a6                	sd	s1,104(sp)
  8002da:	f0ca                	sd	s2,96(sp)
  8002dc:	ecce                	sd	s3,88(sp)
  8002de:	e8d2                	sd	s4,80(sp)
  8002e0:	e4d6                	sd	s5,72(sp)
  8002e2:	e0da                	sd	s6,64(sp)
  8002e4:	fc5e                	sd	s7,56(sp)
  8002e6:	ec6e                	sd	s11,24(sp)
  8002e8:	fc86                	sd	ra,120(sp)
  8002ea:	f8a2                	sd	s0,112(sp)
  8002ec:	f862                	sd	s8,48(sp)
  8002ee:	f466                	sd	s9,40(sp)
  8002f0:	f06a                	sd	s10,32(sp)
  8002f2:	89aa                	mv	s3,a0
  8002f4:	892e                	mv	s2,a1
  8002f6:	84b2                	mv	s1,a2
  8002f8:	8db6                	mv	s11,a3
  8002fa:	8aba                	mv	s5,a4
  8002fc:	02500a13          	li	s4,37
  800300:	5bfd                	li	s7,-1
  800302:	00000b17          	auipc	s6,0x0
  800306:	542b0b13          	addi	s6,s6,1346 # 800844 <main+0x1b4>
  80030a:	000dc503          	lbu	a0,0(s11)
  80030e:	001d8413          	addi	s0,s11,1
  800312:	01450b63          	beq	a0,s4,800328 <vprintfmt+0x52>
  800316:	c129                	beqz	a0,800358 <vprintfmt+0x82>
  800318:	864a                	mv	a2,s2
  80031a:	85a6                	mv	a1,s1
  80031c:	0405                	addi	s0,s0,1
  80031e:	9982                	jalr	s3
  800320:	fff44503          	lbu	a0,-1(s0)
  800324:	ff4519e3          	bne	a0,s4,800316 <vprintfmt+0x40>
  800328:	00044583          	lbu	a1,0(s0)
  80032c:	02000813          	li	a6,32
  800330:	4d01                	li	s10,0
  800332:	4301                	li	t1,0
  800334:	5cfd                	li	s9,-1
  800336:	5c7d                	li	s8,-1
  800338:	05500513          	li	a0,85
  80033c:	48a5                	li	a7,9
  80033e:	fdd5861b          	addiw	a2,a1,-35
  800342:	0ff67613          	zext.b	a2,a2
  800346:	00140d93          	addi	s11,s0,1
  80034a:	04c56263          	bltu	a0,a2,80038e <vprintfmt+0xb8>
  80034e:	060a                	slli	a2,a2,0x2
  800350:	965a                	add	a2,a2,s6
  800352:	4214                	lw	a3,0(a2)
  800354:	96da                	add	a3,a3,s6
  800356:	8682                	jr	a3
  800358:	70e6                	ld	ra,120(sp)
  80035a:	7446                	ld	s0,112(sp)
  80035c:	74a6                	ld	s1,104(sp)
  80035e:	7906                	ld	s2,96(sp)
  800360:	69e6                	ld	s3,88(sp)
  800362:	6a46                	ld	s4,80(sp)
  800364:	6aa6                	ld	s5,72(sp)
  800366:	6b06                	ld	s6,64(sp)
  800368:	7be2                	ld	s7,56(sp)
  80036a:	7c42                	ld	s8,48(sp)
  80036c:	7ca2                	ld	s9,40(sp)
  80036e:	7d02                	ld	s10,32(sp)
  800370:	6de2                	ld	s11,24(sp)
  800372:	6109                	addi	sp,sp,128
  800374:	8082                	ret
  800376:	882e                	mv	a6,a1
  800378:	00144583          	lbu	a1,1(s0)
  80037c:	846e                	mv	s0,s11
  80037e:	00140d93          	addi	s11,s0,1
  800382:	fdd5861b          	addiw	a2,a1,-35
  800386:	0ff67613          	zext.b	a2,a2
  80038a:	fcc572e3          	bgeu	a0,a2,80034e <vprintfmt+0x78>
  80038e:	864a                	mv	a2,s2
  800390:	85a6                	mv	a1,s1
  800392:	02500513          	li	a0,37
  800396:	9982                	jalr	s3
  800398:	fff44783          	lbu	a5,-1(s0)
  80039c:	8da2                	mv	s11,s0
  80039e:	f74786e3          	beq	a5,s4,80030a <vprintfmt+0x34>
  8003a2:	ffedc783          	lbu	a5,-2(s11)
  8003a6:	1dfd                	addi	s11,s11,-1
  8003a8:	ff479de3          	bne	a5,s4,8003a2 <vprintfmt+0xcc>
  8003ac:	bfb9                	j	80030a <vprintfmt+0x34>
  8003ae:	fd058c9b          	addiw	s9,a1,-48
  8003b2:	00144583          	lbu	a1,1(s0)
  8003b6:	846e                	mv	s0,s11
  8003b8:	fd05869b          	addiw	a3,a1,-48
  8003bc:	0005861b          	sext.w	a2,a1
  8003c0:	02d8e463          	bltu	a7,a3,8003e8 <vprintfmt+0x112>
  8003c4:	00144583          	lbu	a1,1(s0)
  8003c8:	002c969b          	slliw	a3,s9,0x2
  8003cc:	0196873b          	addw	a4,a3,s9
  8003d0:	0017171b          	slliw	a4,a4,0x1
  8003d4:	9f31                	addw	a4,a4,a2
  8003d6:	fd05869b          	addiw	a3,a1,-48
  8003da:	0405                	addi	s0,s0,1
  8003dc:	fd070c9b          	addiw	s9,a4,-48
  8003e0:	0005861b          	sext.w	a2,a1
  8003e4:	fed8f0e3          	bgeu	a7,a3,8003c4 <vprintfmt+0xee>
  8003e8:	f40c5be3          	bgez	s8,80033e <vprintfmt+0x68>
  8003ec:	8c66                	mv	s8,s9
  8003ee:	5cfd                	li	s9,-1
  8003f0:	b7b9                	j	80033e <vprintfmt+0x68>
  8003f2:	fffc4693          	not	a3,s8
  8003f6:	96fd                	srai	a3,a3,0x3f
  8003f8:	00dc77b3          	and	a5,s8,a3
  8003fc:	00144583          	lbu	a1,1(s0)
  800400:	00078c1b          	sext.w	s8,a5
  800404:	846e                	mv	s0,s11
  800406:	bf25                	j	80033e <vprintfmt+0x68>
  800408:	000aac83          	lw	s9,0(s5)
  80040c:	00144583          	lbu	a1,1(s0)
  800410:	0aa1                	addi	s5,s5,8
  800412:	846e                	mv	s0,s11
  800414:	bfd1                	j	8003e8 <vprintfmt+0x112>
  800416:	4705                	li	a4,1
  800418:	008a8613          	addi	a2,s5,8
  80041c:	00674463          	blt	a4,t1,800424 <vprintfmt+0x14e>
  800420:	1c030c63          	beqz	t1,8005f8 <vprintfmt+0x322>
  800424:	000ab683          	ld	a3,0(s5)
  800428:	4741                	li	a4,16
  80042a:	8ab2                	mv	s5,a2
  80042c:	2801                	sext.w	a6,a6
  80042e:	87e2                	mv	a5,s8
  800430:	8626                	mv	a2,s1
  800432:	85ca                	mv	a1,s2
  800434:	854e                	mv	a0,s3
  800436:	e2bff0ef          	jal	ra,800260 <printnum>
  80043a:	bdc1                	j	80030a <vprintfmt+0x34>
  80043c:	000aa503          	lw	a0,0(s5)
  800440:	864a                	mv	a2,s2
  800442:	85a6                	mv	a1,s1
  800444:	0aa1                	addi	s5,s5,8
  800446:	9982                	jalr	s3
  800448:	b5c9                	j	80030a <vprintfmt+0x34>
  80044a:	4705                	li	a4,1
  80044c:	008a8613          	addi	a2,s5,8
  800450:	00674463          	blt	a4,t1,800458 <vprintfmt+0x182>
  800454:	18030d63          	beqz	t1,8005ee <vprintfmt+0x318>
  800458:	000ab683          	ld	a3,0(s5)
  80045c:	4729                	li	a4,10
  80045e:	8ab2                	mv	s5,a2
  800460:	b7f1                	j	80042c <vprintfmt+0x156>
  800462:	00144583          	lbu	a1,1(s0)
  800466:	4d05                	li	s10,1
  800468:	846e                	mv	s0,s11
  80046a:	bdd1                	j	80033e <vprintfmt+0x68>
  80046c:	864a                	mv	a2,s2
  80046e:	85a6                	mv	a1,s1
  800470:	02500513          	li	a0,37
  800474:	9982                	jalr	s3
  800476:	bd51                	j	80030a <vprintfmt+0x34>
  800478:	00144583          	lbu	a1,1(s0)
  80047c:	2305                	addiw	t1,t1,1
  80047e:	846e                	mv	s0,s11
  800480:	bd7d                	j	80033e <vprintfmt+0x68>
  800482:	4705                	li	a4,1
  800484:	008a8613          	addi	a2,s5,8
  800488:	00674463          	blt	a4,t1,800490 <vprintfmt+0x1ba>
  80048c:	14030c63          	beqz	t1,8005e4 <vprintfmt+0x30e>
  800490:	000ab683          	ld	a3,0(s5)
  800494:	4721                	li	a4,8
  800496:	8ab2                	mv	s5,a2
  800498:	bf51                	j	80042c <vprintfmt+0x156>
  80049a:	03000513          	li	a0,48
  80049e:	864a                	mv	a2,s2
  8004a0:	85a6                	mv	a1,s1
  8004a2:	e042                	sd	a6,0(sp)
  8004a4:	9982                	jalr	s3
  8004a6:	864a                	mv	a2,s2
  8004a8:	85a6                	mv	a1,s1
  8004aa:	07800513          	li	a0,120
  8004ae:	9982                	jalr	s3
  8004b0:	0aa1                	addi	s5,s5,8
  8004b2:	6802                	ld	a6,0(sp)
  8004b4:	4741                	li	a4,16
  8004b6:	ff8ab683          	ld	a3,-8(s5)
  8004ba:	bf8d                	j	80042c <vprintfmt+0x156>
  8004bc:	000ab403          	ld	s0,0(s5)
  8004c0:	008a8793          	addi	a5,s5,8
  8004c4:	e03e                	sd	a5,0(sp)
  8004c6:	14040c63          	beqz	s0,80061e <vprintfmt+0x348>
  8004ca:	11805063          	blez	s8,8005ca <vprintfmt+0x2f4>
  8004ce:	02d00693          	li	a3,45
  8004d2:	0cd81963          	bne	a6,a3,8005a4 <vprintfmt+0x2ce>
  8004d6:	00044683          	lbu	a3,0(s0)
  8004da:	0006851b          	sext.w	a0,a3
  8004de:	ce8d                	beqz	a3,800518 <vprintfmt+0x242>
  8004e0:	00140a93          	addi	s5,s0,1
  8004e4:	05e00413          	li	s0,94
  8004e8:	000cc563          	bltz	s9,8004f2 <vprintfmt+0x21c>
  8004ec:	3cfd                	addiw	s9,s9,-1
  8004ee:	037c8363          	beq	s9,s7,800514 <vprintfmt+0x23e>
  8004f2:	864a                	mv	a2,s2
  8004f4:	85a6                	mv	a1,s1
  8004f6:	100d0663          	beqz	s10,800602 <vprintfmt+0x32c>
  8004fa:	3681                	addiw	a3,a3,-32
  8004fc:	10d47363          	bgeu	s0,a3,800602 <vprintfmt+0x32c>
  800500:	03f00513          	li	a0,63
  800504:	9982                	jalr	s3
  800506:	000ac683          	lbu	a3,0(s5)
  80050a:	3c7d                	addiw	s8,s8,-1
  80050c:	0a85                	addi	s5,s5,1
  80050e:	0006851b          	sext.w	a0,a3
  800512:	faf9                	bnez	a3,8004e8 <vprintfmt+0x212>
  800514:	01805a63          	blez	s8,800528 <vprintfmt+0x252>
  800518:	3c7d                	addiw	s8,s8,-1
  80051a:	864a                	mv	a2,s2
  80051c:	85a6                	mv	a1,s1
  80051e:	02000513          	li	a0,32
  800522:	9982                	jalr	s3
  800524:	fe0c1ae3          	bnez	s8,800518 <vprintfmt+0x242>
  800528:	6a82                	ld	s5,0(sp)
  80052a:	b3c5                	j	80030a <vprintfmt+0x34>
  80052c:	4705                	li	a4,1
  80052e:	008a8d13          	addi	s10,s5,8
  800532:	00674463          	blt	a4,t1,80053a <vprintfmt+0x264>
  800536:	0a030463          	beqz	t1,8005de <vprintfmt+0x308>
  80053a:	000ab403          	ld	s0,0(s5)
  80053e:	0c044463          	bltz	s0,800606 <vprintfmt+0x330>
  800542:	86a2                	mv	a3,s0
  800544:	8aea                	mv	s5,s10
  800546:	4729                	li	a4,10
  800548:	b5d5                	j	80042c <vprintfmt+0x156>
  80054a:	000aa783          	lw	a5,0(s5)
  80054e:	46e1                	li	a3,24
  800550:	0aa1                	addi	s5,s5,8
  800552:	41f7d71b          	sraiw	a4,a5,0x1f
  800556:	8fb9                	xor	a5,a5,a4
  800558:	40e7873b          	subw	a4,a5,a4
  80055c:	02e6c663          	blt	a3,a4,800588 <vprintfmt+0x2b2>
  800560:	00371793          	slli	a5,a4,0x3
  800564:	00000697          	auipc	a3,0x0
  800568:	61468693          	addi	a3,a3,1556 # 800b78 <error_string>
  80056c:	97b6                	add	a5,a5,a3
  80056e:	639c                	ld	a5,0(a5)
  800570:	cf81                	beqz	a5,800588 <vprintfmt+0x2b2>
  800572:	873e                	mv	a4,a5
  800574:	00000697          	auipc	a3,0x0
  800578:	2cc68693          	addi	a3,a3,716 # 800840 <main+0x1b0>
  80057c:	8626                	mv	a2,s1
  80057e:	85ca                	mv	a1,s2
  800580:	854e                	mv	a0,s3
  800582:	0d4000ef          	jal	ra,800656 <printfmt>
  800586:	b351                	j	80030a <vprintfmt+0x34>
  800588:	00000697          	auipc	a3,0x0
  80058c:	2a868693          	addi	a3,a3,680 # 800830 <main+0x1a0>
  800590:	8626                	mv	a2,s1
  800592:	85ca                	mv	a1,s2
  800594:	854e                	mv	a0,s3
  800596:	0c0000ef          	jal	ra,800656 <printfmt>
  80059a:	bb85                	j	80030a <vprintfmt+0x34>
  80059c:	00000417          	auipc	s0,0x0
  8005a0:	28c40413          	addi	s0,s0,652 # 800828 <main+0x198>
  8005a4:	85e6                	mv	a1,s9
  8005a6:	8522                	mv	a0,s0
  8005a8:	e442                	sd	a6,8(sp)
  8005aa:	0ca000ef          	jal	ra,800674 <strnlen>
  8005ae:	40ac0c3b          	subw	s8,s8,a0
  8005b2:	01805c63          	blez	s8,8005ca <vprintfmt+0x2f4>
  8005b6:	6822                	ld	a6,8(sp)
  8005b8:	00080a9b          	sext.w	s5,a6
  8005bc:	3c7d                	addiw	s8,s8,-1
  8005be:	864a                	mv	a2,s2
  8005c0:	85a6                	mv	a1,s1
  8005c2:	8556                	mv	a0,s5
  8005c4:	9982                	jalr	s3
  8005c6:	fe0c1be3          	bnez	s8,8005bc <vprintfmt+0x2e6>
  8005ca:	00044683          	lbu	a3,0(s0)
  8005ce:	00140a93          	addi	s5,s0,1
  8005d2:	0006851b          	sext.w	a0,a3
  8005d6:	daa9                	beqz	a3,800528 <vprintfmt+0x252>
  8005d8:	05e00413          	li	s0,94
  8005dc:	b731                	j	8004e8 <vprintfmt+0x212>
  8005de:	000aa403          	lw	s0,0(s5)
  8005e2:	bfb1                	j	80053e <vprintfmt+0x268>
  8005e4:	000ae683          	lwu	a3,0(s5)
  8005e8:	4721                	li	a4,8
  8005ea:	8ab2                	mv	s5,a2
  8005ec:	b581                	j	80042c <vprintfmt+0x156>
  8005ee:	000ae683          	lwu	a3,0(s5)
  8005f2:	4729                	li	a4,10
  8005f4:	8ab2                	mv	s5,a2
  8005f6:	bd1d                	j	80042c <vprintfmt+0x156>
  8005f8:	000ae683          	lwu	a3,0(s5)
  8005fc:	4741                	li	a4,16
  8005fe:	8ab2                	mv	s5,a2
  800600:	b535                	j	80042c <vprintfmt+0x156>
  800602:	9982                	jalr	s3
  800604:	b709                	j	800506 <vprintfmt+0x230>
  800606:	864a                	mv	a2,s2
  800608:	85a6                	mv	a1,s1
  80060a:	02d00513          	li	a0,45
  80060e:	e042                	sd	a6,0(sp)
  800610:	9982                	jalr	s3
  800612:	6802                	ld	a6,0(sp)
  800614:	8aea                	mv	s5,s10
  800616:	408006b3          	neg	a3,s0
  80061a:	4729                	li	a4,10
  80061c:	bd01                	j	80042c <vprintfmt+0x156>
  80061e:	03805163          	blez	s8,800640 <vprintfmt+0x36a>
  800622:	02d00693          	li	a3,45
  800626:	f6d81be3          	bne	a6,a3,80059c <vprintfmt+0x2c6>
  80062a:	00000417          	auipc	s0,0x0
  80062e:	1fe40413          	addi	s0,s0,510 # 800828 <main+0x198>
  800632:	02800693          	li	a3,40
  800636:	02800513          	li	a0,40
  80063a:	00140a93          	addi	s5,s0,1
  80063e:	b55d                	j	8004e4 <vprintfmt+0x20e>
  800640:	00000a97          	auipc	s5,0x0
  800644:	1e9a8a93          	addi	s5,s5,489 # 800829 <main+0x199>
  800648:	02800513          	li	a0,40
  80064c:	02800693          	li	a3,40
  800650:	05e00413          	li	s0,94
  800654:	bd51                	j	8004e8 <vprintfmt+0x212>

0000000000800656 <printfmt>:
  800656:	7139                	addi	sp,sp,-64
  800658:	02010313          	addi	t1,sp,32
  80065c:	f03a                	sd	a4,32(sp)
  80065e:	871a                	mv	a4,t1
  800660:	ec06                	sd	ra,24(sp)
  800662:	f43e                	sd	a5,40(sp)
  800664:	f842                	sd	a6,48(sp)
  800666:	fc46                	sd	a7,56(sp)
  800668:	e41a                	sd	t1,8(sp)
  80066a:	c6dff0ef          	jal	ra,8002d6 <vprintfmt>
  80066e:	60e2                	ld	ra,24(sp)
  800670:	6121                	addi	sp,sp,64
  800672:	8082                	ret

0000000000800674 <strnlen>:
  800674:	4781                	li	a5,0
  800676:	e589                	bnez	a1,800680 <strnlen+0xc>
  800678:	a811                	j	80068c <strnlen+0x18>
  80067a:	0785                	addi	a5,a5,1
  80067c:	00f58863          	beq	a1,a5,80068c <strnlen+0x18>
  800680:	00f50733          	add	a4,a0,a5
  800684:	00074703          	lbu	a4,0(a4)
  800688:	fb6d                	bnez	a4,80067a <strnlen+0x6>
  80068a:	85be                	mv	a1,a5
  80068c:	852e                	mv	a0,a1
  80068e:	8082                	ret

0000000000800690 <main>:
  800690:	1141                	addi	sp,sp,-16
  800692:	00000517          	auipc	a0,0x0
  800696:	5ae50513          	addi	a0,a0,1454 # 800c40 <error_string+0xc8>
  80069a:	e406                	sd	ra,8(sp)
  80069c:	a5bff0ef          	jal	ra,8000f6 <cprintf>
  8006a0:	00001597          	auipc	a1,0x1
  8006a4:	96058593          	addi	a1,a1,-1696 # 801000 <bigarray>
  8006a8:	87ae                	mv	a5,a1
  8006aa:	4681                	li	a3,0
  8006ac:	00100637          	lui	a2,0x100
  8006b0:	a029                	j	8006ba <main+0x2a>
  8006b2:	2685                	addiw	a3,a3,1
  8006b4:	0791                	addi	a5,a5,4
  8006b6:	00c68f63          	beq	a3,a2,8006d4 <main+0x44>
  8006ba:	4398                	lw	a4,0(a5)
  8006bc:	db7d                	beqz	a4,8006b2 <main+0x22>
  8006be:	00000617          	auipc	a2,0x0
  8006c2:	5a260613          	addi	a2,a2,1442 # 800c60 <error_string+0xe8>
  8006c6:	45b9                	li	a1,14
  8006c8:	00000517          	auipc	a0,0x0
  8006cc:	5b850513          	addi	a0,a0,1464 # 800c80 <error_string+0x108>
  8006d0:	961ff0ef          	jal	ra,800030 <__panic>
  8006d4:	00001717          	auipc	a4,0x1
  8006d8:	92c70713          	addi	a4,a4,-1748 # 801000 <bigarray>
  8006dc:	4781                	li	a5,0
  8006de:	001006b7          	lui	a3,0x100
  8006e2:	c31c                	sw	a5,0(a4)
  8006e4:	2785                	addiw	a5,a5,1
  8006e6:	0711                	addi	a4,a4,4
  8006e8:	fed79de3          	bne	a5,a3,8006e2 <main+0x52>
  8006ec:	4681                	li	a3,0
  8006ee:	00100737          	lui	a4,0x100
  8006f2:	a029                	j	8006fc <main+0x6c>
  8006f4:	2685                	addiw	a3,a3,1
  8006f6:	0591                	addi	a1,a1,4
  8006f8:	02e68063          	beq	a3,a4,800718 <main+0x88>
  8006fc:	419c                	lw	a5,0(a1)
  8006fe:	fed78be3          	beq	a5,a3,8006f4 <main+0x64>
  800702:	00000617          	auipc	a2,0x0
  800706:	58e60613          	addi	a2,a2,1422 # 800c90 <error_string+0x118>
  80070a:	45d9                	li	a1,22
  80070c:	00000517          	auipc	a0,0x0
  800710:	57450513          	addi	a0,a0,1396 # 800c80 <error_string+0x108>
  800714:	91dff0ef          	jal	ra,800030 <__panic>
  800718:	00000517          	auipc	a0,0x0
  80071c:	5a050513          	addi	a0,a0,1440 # 800cb8 <error_string+0x140>
  800720:	9d7ff0ef          	jal	ra,8000f6 <cprintf>
  800724:	00000517          	auipc	a0,0x0
  800728:	5cc50513          	addi	a0,a0,1484 # 800cf0 <error_string+0x178>
  80072c:	9cbff0ef          	jal	ra,8000f6 <cprintf>
  800730:	00000617          	auipc	a2,0x0
  800734:	5d860613          	addi	a2,a2,1496 # 800d08 <error_string+0x190>
  800738:	45fd                	li	a1,31
  80073a:	00000517          	auipc	a0,0x0
  80073e:	54650513          	addi	a0,a0,1350 # 800c80 <error_string+0x108>
  800742:	00402797          	auipc	a5,0x402
  800746:	8a07af23          	sw	zero,-1858(a5) # c02000 <bigarray+0x401000>
  80074a:	8e7ff0ef          	jal	ra,800030 <__panic>
