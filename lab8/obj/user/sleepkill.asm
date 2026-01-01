
obj/__user_sleepkill.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a28d                	j	800186 <sys_open>

0000000000800026 <close>:
  800026:	a2ad                	j	800190 <sys_close>

0000000000800028 <dup2>:
  800028:	aa85                	j	800198 <sys_dup>

000000000080002a <_start>:
  80002a:	1dc000ef          	jal	ra,800206 <umain>
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
  800044:	6f050513          	addi	a0,a0,1776 # 800730 <main+0x86>
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
  800064:	74850513          	addi	a0,a0,1864 # 8007a8 <main+0xfe>
  800068:	08e000ef          	jal	ra,8000f6 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	134000ef          	jal	ra,8001a2 <exit>

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
  800086:	6ce50513          	addi	a0,a0,1742 # 800750 <main+0xa6>
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
  8000a6:	70650513          	addi	a0,a0,1798 # 8007a8 <main+0xfe>
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
  8000be:	0bc000ef          	jal	ra,80017a <sys_putc>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f81>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	206000ef          	jal	ra,8002f0 <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f81>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1ca000ef          	jal	ra,8002f0 <vprintfmt>
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

0000000000800170 <sys_fork>:
  800170:	4509                	li	a0,2
  800172:	b7c1                	j	800132 <syscall>

0000000000800174 <sys_kill>:
  800174:	85aa                	mv	a1,a0
  800176:	4531                	li	a0,12
  800178:	bf6d                	j	800132 <syscall>

000000000080017a <sys_putc>:
  80017a:	85aa                	mv	a1,a0
  80017c:	4579                	li	a0,30
  80017e:	bf55                	j	800132 <syscall>

0000000000800180 <sys_sleep>:
  800180:	85aa                	mv	a1,a0
  800182:	452d                	li	a0,11
  800184:	b77d                	j	800132 <syscall>

0000000000800186 <sys_open>:
  800186:	862e                	mv	a2,a1
  800188:	85aa                	mv	a1,a0
  80018a:	06400513          	li	a0,100
  80018e:	b755                	j	800132 <syscall>

0000000000800190 <sys_close>:
  800190:	85aa                	mv	a1,a0
  800192:	06500513          	li	a0,101
  800196:	bf71                	j	800132 <syscall>

0000000000800198 <sys_dup>:
  800198:	862e                	mv	a2,a1
  80019a:	85aa                	mv	a1,a0
  80019c:	08200513          	li	a0,130
  8001a0:	bf49                	j	800132 <syscall>

00000000008001a2 <exit>:
  8001a2:	1141                	addi	sp,sp,-16
  8001a4:	e406                	sd	ra,8(sp)
  8001a6:	fc5ff0ef          	jal	ra,80016a <sys_exit>
  8001aa:	00000517          	auipc	a0,0x0
  8001ae:	5c650513          	addi	a0,a0,1478 # 800770 <main+0xc6>
  8001b2:	f45ff0ef          	jal	ra,8000f6 <cprintf>
  8001b6:	a001                	j	8001b6 <exit+0x14>

00000000008001b8 <fork>:
  8001b8:	bf65                	j	800170 <sys_fork>

00000000008001ba <kill>:
  8001ba:	bf6d                	j	800174 <sys_kill>

00000000008001bc <sleep>:
  8001bc:	1502                	slli	a0,a0,0x20
  8001be:	9101                	srli	a0,a0,0x20
  8001c0:	b7c1                	j	800180 <sys_sleep>

00000000008001c2 <initfd>:
  8001c2:	1101                	addi	sp,sp,-32
  8001c4:	87ae                	mv	a5,a1
  8001c6:	e426                	sd	s1,8(sp)
  8001c8:	85b2                	mv	a1,a2
  8001ca:	84aa                	mv	s1,a0
  8001cc:	853e                	mv	a0,a5
  8001ce:	e822                	sd	s0,16(sp)
  8001d0:	ec06                	sd	ra,24(sp)
  8001d2:	e4fff0ef          	jal	ra,800020 <open>
  8001d6:	842a                	mv	s0,a0
  8001d8:	00054463          	bltz	a0,8001e0 <initfd+0x1e>
  8001dc:	00951863          	bne	a0,s1,8001ec <initfd+0x2a>
  8001e0:	60e2                	ld	ra,24(sp)
  8001e2:	8522                	mv	a0,s0
  8001e4:	6442                	ld	s0,16(sp)
  8001e6:	64a2                	ld	s1,8(sp)
  8001e8:	6105                	addi	sp,sp,32
  8001ea:	8082                	ret
  8001ec:	8526                	mv	a0,s1
  8001ee:	e39ff0ef          	jal	ra,800026 <close>
  8001f2:	85a6                	mv	a1,s1
  8001f4:	8522                	mv	a0,s0
  8001f6:	e33ff0ef          	jal	ra,800028 <dup2>
  8001fa:	84aa                	mv	s1,a0
  8001fc:	8522                	mv	a0,s0
  8001fe:	e29ff0ef          	jal	ra,800026 <close>
  800202:	8426                	mv	s0,s1
  800204:	bff1                	j	8001e0 <initfd+0x1e>

0000000000800206 <umain>:
  800206:	1101                	addi	sp,sp,-32
  800208:	e822                	sd	s0,16(sp)
  80020a:	e426                	sd	s1,8(sp)
  80020c:	842a                	mv	s0,a0
  80020e:	84ae                	mv	s1,a1
  800210:	4601                	li	a2,0
  800212:	00000597          	auipc	a1,0x0
  800216:	57658593          	addi	a1,a1,1398 # 800788 <main+0xde>
  80021a:	4501                	li	a0,0
  80021c:	ec06                	sd	ra,24(sp)
  80021e:	fa5ff0ef          	jal	ra,8001c2 <initfd>
  800222:	02054263          	bltz	a0,800246 <umain+0x40>
  800226:	4605                	li	a2,1
  800228:	00000597          	auipc	a1,0x0
  80022c:	5a058593          	addi	a1,a1,1440 # 8007c8 <main+0x11e>
  800230:	4505                	li	a0,1
  800232:	f91ff0ef          	jal	ra,8001c2 <initfd>
  800236:	02054563          	bltz	a0,800260 <umain+0x5a>
  80023a:	85a6                	mv	a1,s1
  80023c:	8522                	mv	a0,s0
  80023e:	46c000ef          	jal	ra,8006aa <main>
  800242:	f61ff0ef          	jal	ra,8001a2 <exit>
  800246:	86aa                	mv	a3,a0
  800248:	00000617          	auipc	a2,0x0
  80024c:	54860613          	addi	a2,a2,1352 # 800790 <main+0xe6>
  800250:	45e9                	li	a1,26
  800252:	00000517          	auipc	a0,0x0
  800256:	55e50513          	addi	a0,a0,1374 # 8007b0 <main+0x106>
  80025a:	e19ff0ef          	jal	ra,800072 <__warn>
  80025e:	b7e1                	j	800226 <umain+0x20>
  800260:	86aa                	mv	a3,a0
  800262:	00000617          	auipc	a2,0x0
  800266:	56e60613          	addi	a2,a2,1390 # 8007d0 <main+0x126>
  80026a:	45f5                	li	a1,29
  80026c:	00000517          	auipc	a0,0x0
  800270:	54450513          	addi	a0,a0,1348 # 8007b0 <main+0x106>
  800274:	dffff0ef          	jal	ra,800072 <__warn>
  800278:	b7c9                	j	80023a <umain+0x34>

000000000080027a <printnum>:
  80027a:	02071893          	slli	a7,a4,0x20
  80027e:	7139                	addi	sp,sp,-64
  800280:	0208d893          	srli	a7,a7,0x20
  800284:	e456                	sd	s5,8(sp)
  800286:	0316fab3          	remu	s5,a3,a7
  80028a:	f822                	sd	s0,48(sp)
  80028c:	f426                	sd	s1,40(sp)
  80028e:	f04a                	sd	s2,32(sp)
  800290:	ec4e                	sd	s3,24(sp)
  800292:	fc06                	sd	ra,56(sp)
  800294:	e852                	sd	s4,16(sp)
  800296:	84aa                	mv	s1,a0
  800298:	89ae                	mv	s3,a1
  80029a:	8932                	mv	s2,a2
  80029c:	fff7841b          	addiw	s0,a5,-1
  8002a0:	2a81                	sext.w	s5,s5
  8002a2:	0516f163          	bgeu	a3,a7,8002e4 <printnum+0x6a>
  8002a6:	8a42                	mv	s4,a6
  8002a8:	00805863          	blez	s0,8002b8 <printnum+0x3e>
  8002ac:	347d                	addiw	s0,s0,-1
  8002ae:	864e                	mv	a2,s3
  8002b0:	85ca                	mv	a1,s2
  8002b2:	8552                	mv	a0,s4
  8002b4:	9482                	jalr	s1
  8002b6:	f87d                	bnez	s0,8002ac <printnum+0x32>
  8002b8:	1a82                	slli	s5,s5,0x20
  8002ba:	00000797          	auipc	a5,0x0
  8002be:	53678793          	addi	a5,a5,1334 # 8007f0 <main+0x146>
  8002c2:	020ada93          	srli	s5,s5,0x20
  8002c6:	9abe                	add	s5,s5,a5
  8002c8:	7442                	ld	s0,48(sp)
  8002ca:	000ac503          	lbu	a0,0(s5)
  8002ce:	70e2                	ld	ra,56(sp)
  8002d0:	6a42                	ld	s4,16(sp)
  8002d2:	6aa2                	ld	s5,8(sp)
  8002d4:	864e                	mv	a2,s3
  8002d6:	85ca                	mv	a1,s2
  8002d8:	69e2                	ld	s3,24(sp)
  8002da:	7902                	ld	s2,32(sp)
  8002dc:	87a6                	mv	a5,s1
  8002de:	74a2                	ld	s1,40(sp)
  8002e0:	6121                	addi	sp,sp,64
  8002e2:	8782                	jr	a5
  8002e4:	0316d6b3          	divu	a3,a3,a7
  8002e8:	87a2                	mv	a5,s0
  8002ea:	f91ff0ef          	jal	ra,80027a <printnum>
  8002ee:	b7e9                	j	8002b8 <printnum+0x3e>

00000000008002f0 <vprintfmt>:
  8002f0:	7119                	addi	sp,sp,-128
  8002f2:	f4a6                	sd	s1,104(sp)
  8002f4:	f0ca                	sd	s2,96(sp)
  8002f6:	ecce                	sd	s3,88(sp)
  8002f8:	e8d2                	sd	s4,80(sp)
  8002fa:	e4d6                	sd	s5,72(sp)
  8002fc:	e0da                	sd	s6,64(sp)
  8002fe:	fc5e                	sd	s7,56(sp)
  800300:	ec6e                	sd	s11,24(sp)
  800302:	fc86                	sd	ra,120(sp)
  800304:	f8a2                	sd	s0,112(sp)
  800306:	f862                	sd	s8,48(sp)
  800308:	f466                	sd	s9,40(sp)
  80030a:	f06a                	sd	s10,32(sp)
  80030c:	89aa                	mv	s3,a0
  80030e:	892e                	mv	s2,a1
  800310:	84b2                	mv	s1,a2
  800312:	8db6                	mv	s11,a3
  800314:	8aba                	mv	s5,a4
  800316:	02500a13          	li	s4,37
  80031a:	5bfd                	li	s7,-1
  80031c:	00000b17          	auipc	s6,0x0
  800320:	508b0b13          	addi	s6,s6,1288 # 800824 <main+0x17a>
  800324:	000dc503          	lbu	a0,0(s11)
  800328:	001d8413          	addi	s0,s11,1
  80032c:	01450b63          	beq	a0,s4,800342 <vprintfmt+0x52>
  800330:	c129                	beqz	a0,800372 <vprintfmt+0x82>
  800332:	864a                	mv	a2,s2
  800334:	85a6                	mv	a1,s1
  800336:	0405                	addi	s0,s0,1
  800338:	9982                	jalr	s3
  80033a:	fff44503          	lbu	a0,-1(s0)
  80033e:	ff4519e3          	bne	a0,s4,800330 <vprintfmt+0x40>
  800342:	00044583          	lbu	a1,0(s0)
  800346:	02000813          	li	a6,32
  80034a:	4d01                	li	s10,0
  80034c:	4301                	li	t1,0
  80034e:	5cfd                	li	s9,-1
  800350:	5c7d                	li	s8,-1
  800352:	05500513          	li	a0,85
  800356:	48a5                	li	a7,9
  800358:	fdd5861b          	addiw	a2,a1,-35
  80035c:	0ff67613          	zext.b	a2,a2
  800360:	00140d93          	addi	s11,s0,1
  800364:	04c56263          	bltu	a0,a2,8003a8 <vprintfmt+0xb8>
  800368:	060a                	slli	a2,a2,0x2
  80036a:	965a                	add	a2,a2,s6
  80036c:	4214                	lw	a3,0(a2)
  80036e:	96da                	add	a3,a3,s6
  800370:	8682                	jr	a3
  800372:	70e6                	ld	ra,120(sp)
  800374:	7446                	ld	s0,112(sp)
  800376:	74a6                	ld	s1,104(sp)
  800378:	7906                	ld	s2,96(sp)
  80037a:	69e6                	ld	s3,88(sp)
  80037c:	6a46                	ld	s4,80(sp)
  80037e:	6aa6                	ld	s5,72(sp)
  800380:	6b06                	ld	s6,64(sp)
  800382:	7be2                	ld	s7,56(sp)
  800384:	7c42                	ld	s8,48(sp)
  800386:	7ca2                	ld	s9,40(sp)
  800388:	7d02                	ld	s10,32(sp)
  80038a:	6de2                	ld	s11,24(sp)
  80038c:	6109                	addi	sp,sp,128
  80038e:	8082                	ret
  800390:	882e                	mv	a6,a1
  800392:	00144583          	lbu	a1,1(s0)
  800396:	846e                	mv	s0,s11
  800398:	00140d93          	addi	s11,s0,1
  80039c:	fdd5861b          	addiw	a2,a1,-35
  8003a0:	0ff67613          	zext.b	a2,a2
  8003a4:	fcc572e3          	bgeu	a0,a2,800368 <vprintfmt+0x78>
  8003a8:	864a                	mv	a2,s2
  8003aa:	85a6                	mv	a1,s1
  8003ac:	02500513          	li	a0,37
  8003b0:	9982                	jalr	s3
  8003b2:	fff44783          	lbu	a5,-1(s0)
  8003b6:	8da2                	mv	s11,s0
  8003b8:	f74786e3          	beq	a5,s4,800324 <vprintfmt+0x34>
  8003bc:	ffedc783          	lbu	a5,-2(s11)
  8003c0:	1dfd                	addi	s11,s11,-1
  8003c2:	ff479de3          	bne	a5,s4,8003bc <vprintfmt+0xcc>
  8003c6:	bfb9                	j	800324 <vprintfmt+0x34>
  8003c8:	fd058c9b          	addiw	s9,a1,-48
  8003cc:	00144583          	lbu	a1,1(s0)
  8003d0:	846e                	mv	s0,s11
  8003d2:	fd05869b          	addiw	a3,a1,-48
  8003d6:	0005861b          	sext.w	a2,a1
  8003da:	02d8e463          	bltu	a7,a3,800402 <vprintfmt+0x112>
  8003de:	00144583          	lbu	a1,1(s0)
  8003e2:	002c969b          	slliw	a3,s9,0x2
  8003e6:	0196873b          	addw	a4,a3,s9
  8003ea:	0017171b          	slliw	a4,a4,0x1
  8003ee:	9f31                	addw	a4,a4,a2
  8003f0:	fd05869b          	addiw	a3,a1,-48
  8003f4:	0405                	addi	s0,s0,1
  8003f6:	fd070c9b          	addiw	s9,a4,-48
  8003fa:	0005861b          	sext.w	a2,a1
  8003fe:	fed8f0e3          	bgeu	a7,a3,8003de <vprintfmt+0xee>
  800402:	f40c5be3          	bgez	s8,800358 <vprintfmt+0x68>
  800406:	8c66                	mv	s8,s9
  800408:	5cfd                	li	s9,-1
  80040a:	b7b9                	j	800358 <vprintfmt+0x68>
  80040c:	fffc4693          	not	a3,s8
  800410:	96fd                	srai	a3,a3,0x3f
  800412:	00dc77b3          	and	a5,s8,a3
  800416:	00144583          	lbu	a1,1(s0)
  80041a:	00078c1b          	sext.w	s8,a5
  80041e:	846e                	mv	s0,s11
  800420:	bf25                	j	800358 <vprintfmt+0x68>
  800422:	000aac83          	lw	s9,0(s5)
  800426:	00144583          	lbu	a1,1(s0)
  80042a:	0aa1                	addi	s5,s5,8
  80042c:	846e                	mv	s0,s11
  80042e:	bfd1                	j	800402 <vprintfmt+0x112>
  800430:	4705                	li	a4,1
  800432:	008a8613          	addi	a2,s5,8
  800436:	00674463          	blt	a4,t1,80043e <vprintfmt+0x14e>
  80043a:	1c030c63          	beqz	t1,800612 <vprintfmt+0x322>
  80043e:	000ab683          	ld	a3,0(s5)
  800442:	4741                	li	a4,16
  800444:	8ab2                	mv	s5,a2
  800446:	2801                	sext.w	a6,a6
  800448:	87e2                	mv	a5,s8
  80044a:	8626                	mv	a2,s1
  80044c:	85ca                	mv	a1,s2
  80044e:	854e                	mv	a0,s3
  800450:	e2bff0ef          	jal	ra,80027a <printnum>
  800454:	bdc1                	j	800324 <vprintfmt+0x34>
  800456:	000aa503          	lw	a0,0(s5)
  80045a:	864a                	mv	a2,s2
  80045c:	85a6                	mv	a1,s1
  80045e:	0aa1                	addi	s5,s5,8
  800460:	9982                	jalr	s3
  800462:	b5c9                	j	800324 <vprintfmt+0x34>
  800464:	4705                	li	a4,1
  800466:	008a8613          	addi	a2,s5,8
  80046a:	00674463          	blt	a4,t1,800472 <vprintfmt+0x182>
  80046e:	18030d63          	beqz	t1,800608 <vprintfmt+0x318>
  800472:	000ab683          	ld	a3,0(s5)
  800476:	4729                	li	a4,10
  800478:	8ab2                	mv	s5,a2
  80047a:	b7f1                	j	800446 <vprintfmt+0x156>
  80047c:	00144583          	lbu	a1,1(s0)
  800480:	4d05                	li	s10,1
  800482:	846e                	mv	s0,s11
  800484:	bdd1                	j	800358 <vprintfmt+0x68>
  800486:	864a                	mv	a2,s2
  800488:	85a6                	mv	a1,s1
  80048a:	02500513          	li	a0,37
  80048e:	9982                	jalr	s3
  800490:	bd51                	j	800324 <vprintfmt+0x34>
  800492:	00144583          	lbu	a1,1(s0)
  800496:	2305                	addiw	t1,t1,1
  800498:	846e                	mv	s0,s11
  80049a:	bd7d                	j	800358 <vprintfmt+0x68>
  80049c:	4705                	li	a4,1
  80049e:	008a8613          	addi	a2,s5,8
  8004a2:	00674463          	blt	a4,t1,8004aa <vprintfmt+0x1ba>
  8004a6:	14030c63          	beqz	t1,8005fe <vprintfmt+0x30e>
  8004aa:	000ab683          	ld	a3,0(s5)
  8004ae:	4721                	li	a4,8
  8004b0:	8ab2                	mv	s5,a2
  8004b2:	bf51                	j	800446 <vprintfmt+0x156>
  8004b4:	03000513          	li	a0,48
  8004b8:	864a                	mv	a2,s2
  8004ba:	85a6                	mv	a1,s1
  8004bc:	e042                	sd	a6,0(sp)
  8004be:	9982                	jalr	s3
  8004c0:	864a                	mv	a2,s2
  8004c2:	85a6                	mv	a1,s1
  8004c4:	07800513          	li	a0,120
  8004c8:	9982                	jalr	s3
  8004ca:	0aa1                	addi	s5,s5,8
  8004cc:	6802                	ld	a6,0(sp)
  8004ce:	4741                	li	a4,16
  8004d0:	ff8ab683          	ld	a3,-8(s5)
  8004d4:	bf8d                	j	800446 <vprintfmt+0x156>
  8004d6:	000ab403          	ld	s0,0(s5)
  8004da:	008a8793          	addi	a5,s5,8
  8004de:	e03e                	sd	a5,0(sp)
  8004e0:	14040c63          	beqz	s0,800638 <vprintfmt+0x348>
  8004e4:	11805063          	blez	s8,8005e4 <vprintfmt+0x2f4>
  8004e8:	02d00693          	li	a3,45
  8004ec:	0cd81963          	bne	a6,a3,8005be <vprintfmt+0x2ce>
  8004f0:	00044683          	lbu	a3,0(s0)
  8004f4:	0006851b          	sext.w	a0,a3
  8004f8:	ce8d                	beqz	a3,800532 <vprintfmt+0x242>
  8004fa:	00140a93          	addi	s5,s0,1
  8004fe:	05e00413          	li	s0,94
  800502:	000cc563          	bltz	s9,80050c <vprintfmt+0x21c>
  800506:	3cfd                	addiw	s9,s9,-1
  800508:	037c8363          	beq	s9,s7,80052e <vprintfmt+0x23e>
  80050c:	864a                	mv	a2,s2
  80050e:	85a6                	mv	a1,s1
  800510:	100d0663          	beqz	s10,80061c <vprintfmt+0x32c>
  800514:	3681                	addiw	a3,a3,-32
  800516:	10d47363          	bgeu	s0,a3,80061c <vprintfmt+0x32c>
  80051a:	03f00513          	li	a0,63
  80051e:	9982                	jalr	s3
  800520:	000ac683          	lbu	a3,0(s5)
  800524:	3c7d                	addiw	s8,s8,-1
  800526:	0a85                	addi	s5,s5,1
  800528:	0006851b          	sext.w	a0,a3
  80052c:	faf9                	bnez	a3,800502 <vprintfmt+0x212>
  80052e:	01805a63          	blez	s8,800542 <vprintfmt+0x252>
  800532:	3c7d                	addiw	s8,s8,-1
  800534:	864a                	mv	a2,s2
  800536:	85a6                	mv	a1,s1
  800538:	02000513          	li	a0,32
  80053c:	9982                	jalr	s3
  80053e:	fe0c1ae3          	bnez	s8,800532 <vprintfmt+0x242>
  800542:	6a82                	ld	s5,0(sp)
  800544:	b3c5                	j	800324 <vprintfmt+0x34>
  800546:	4705                	li	a4,1
  800548:	008a8d13          	addi	s10,s5,8
  80054c:	00674463          	blt	a4,t1,800554 <vprintfmt+0x264>
  800550:	0a030463          	beqz	t1,8005f8 <vprintfmt+0x308>
  800554:	000ab403          	ld	s0,0(s5)
  800558:	0c044463          	bltz	s0,800620 <vprintfmt+0x330>
  80055c:	86a2                	mv	a3,s0
  80055e:	8aea                	mv	s5,s10
  800560:	4729                	li	a4,10
  800562:	b5d5                	j	800446 <vprintfmt+0x156>
  800564:	000aa783          	lw	a5,0(s5)
  800568:	46e1                	li	a3,24
  80056a:	0aa1                	addi	s5,s5,8
  80056c:	41f7d71b          	sraiw	a4,a5,0x1f
  800570:	8fb9                	xor	a5,a5,a4
  800572:	40e7873b          	subw	a4,a5,a4
  800576:	02e6c663          	blt	a3,a4,8005a2 <vprintfmt+0x2b2>
  80057a:	00371793          	slli	a5,a4,0x3
  80057e:	00000697          	auipc	a3,0x0
  800582:	5da68693          	addi	a3,a3,1498 # 800b58 <error_string>
  800586:	97b6                	add	a5,a5,a3
  800588:	639c                	ld	a5,0(a5)
  80058a:	cf81                	beqz	a5,8005a2 <vprintfmt+0x2b2>
  80058c:	873e                	mv	a4,a5
  80058e:	00000697          	auipc	a3,0x0
  800592:	29268693          	addi	a3,a3,658 # 800820 <main+0x176>
  800596:	8626                	mv	a2,s1
  800598:	85ca                	mv	a1,s2
  80059a:	854e                	mv	a0,s3
  80059c:	0d4000ef          	jal	ra,800670 <printfmt>
  8005a0:	b351                	j	800324 <vprintfmt+0x34>
  8005a2:	00000697          	auipc	a3,0x0
  8005a6:	26e68693          	addi	a3,a3,622 # 800810 <main+0x166>
  8005aa:	8626                	mv	a2,s1
  8005ac:	85ca                	mv	a1,s2
  8005ae:	854e                	mv	a0,s3
  8005b0:	0c0000ef          	jal	ra,800670 <printfmt>
  8005b4:	bb85                	j	800324 <vprintfmt+0x34>
  8005b6:	00000417          	auipc	s0,0x0
  8005ba:	25240413          	addi	s0,s0,594 # 800808 <main+0x15e>
  8005be:	85e6                	mv	a1,s9
  8005c0:	8522                	mv	a0,s0
  8005c2:	e442                	sd	a6,8(sp)
  8005c4:	0ca000ef          	jal	ra,80068e <strnlen>
  8005c8:	40ac0c3b          	subw	s8,s8,a0
  8005cc:	01805c63          	blez	s8,8005e4 <vprintfmt+0x2f4>
  8005d0:	6822                	ld	a6,8(sp)
  8005d2:	00080a9b          	sext.w	s5,a6
  8005d6:	3c7d                	addiw	s8,s8,-1
  8005d8:	864a                	mv	a2,s2
  8005da:	85a6                	mv	a1,s1
  8005dc:	8556                	mv	a0,s5
  8005de:	9982                	jalr	s3
  8005e0:	fe0c1be3          	bnez	s8,8005d6 <vprintfmt+0x2e6>
  8005e4:	00044683          	lbu	a3,0(s0)
  8005e8:	00140a93          	addi	s5,s0,1
  8005ec:	0006851b          	sext.w	a0,a3
  8005f0:	daa9                	beqz	a3,800542 <vprintfmt+0x252>
  8005f2:	05e00413          	li	s0,94
  8005f6:	b731                	j	800502 <vprintfmt+0x212>
  8005f8:	000aa403          	lw	s0,0(s5)
  8005fc:	bfb1                	j	800558 <vprintfmt+0x268>
  8005fe:	000ae683          	lwu	a3,0(s5)
  800602:	4721                	li	a4,8
  800604:	8ab2                	mv	s5,a2
  800606:	b581                	j	800446 <vprintfmt+0x156>
  800608:	000ae683          	lwu	a3,0(s5)
  80060c:	4729                	li	a4,10
  80060e:	8ab2                	mv	s5,a2
  800610:	bd1d                	j	800446 <vprintfmt+0x156>
  800612:	000ae683          	lwu	a3,0(s5)
  800616:	4741                	li	a4,16
  800618:	8ab2                	mv	s5,a2
  80061a:	b535                	j	800446 <vprintfmt+0x156>
  80061c:	9982                	jalr	s3
  80061e:	b709                	j	800520 <vprintfmt+0x230>
  800620:	864a                	mv	a2,s2
  800622:	85a6                	mv	a1,s1
  800624:	02d00513          	li	a0,45
  800628:	e042                	sd	a6,0(sp)
  80062a:	9982                	jalr	s3
  80062c:	6802                	ld	a6,0(sp)
  80062e:	8aea                	mv	s5,s10
  800630:	408006b3          	neg	a3,s0
  800634:	4729                	li	a4,10
  800636:	bd01                	j	800446 <vprintfmt+0x156>
  800638:	03805163          	blez	s8,80065a <vprintfmt+0x36a>
  80063c:	02d00693          	li	a3,45
  800640:	f6d81be3          	bne	a6,a3,8005b6 <vprintfmt+0x2c6>
  800644:	00000417          	auipc	s0,0x0
  800648:	1c440413          	addi	s0,s0,452 # 800808 <main+0x15e>
  80064c:	02800693          	li	a3,40
  800650:	02800513          	li	a0,40
  800654:	00140a93          	addi	s5,s0,1
  800658:	b55d                	j	8004fe <vprintfmt+0x20e>
  80065a:	00000a97          	auipc	s5,0x0
  80065e:	1afa8a93          	addi	s5,s5,431 # 800809 <main+0x15f>
  800662:	02800513          	li	a0,40
  800666:	02800693          	li	a3,40
  80066a:	05e00413          	li	s0,94
  80066e:	bd51                	j	800502 <vprintfmt+0x212>

0000000000800670 <printfmt>:
  800670:	7139                	addi	sp,sp,-64
  800672:	02010313          	addi	t1,sp,32
  800676:	f03a                	sd	a4,32(sp)
  800678:	871a                	mv	a4,t1
  80067a:	ec06                	sd	ra,24(sp)
  80067c:	f43e                	sd	a5,40(sp)
  80067e:	f842                	sd	a6,48(sp)
  800680:	fc46                	sd	a7,56(sp)
  800682:	e41a                	sd	t1,8(sp)
  800684:	c6dff0ef          	jal	ra,8002f0 <vprintfmt>
  800688:	60e2                	ld	ra,24(sp)
  80068a:	6121                	addi	sp,sp,64
  80068c:	8082                	ret

000000000080068e <strnlen>:
  80068e:	4781                	li	a5,0
  800690:	e589                	bnez	a1,80069a <strnlen+0xc>
  800692:	a811                	j	8006a6 <strnlen+0x18>
  800694:	0785                	addi	a5,a5,1
  800696:	00f58863          	beq	a1,a5,8006a6 <strnlen+0x18>
  80069a:	00f50733          	add	a4,a0,a5
  80069e:	00074703          	lbu	a4,0(a4)
  8006a2:	fb6d                	bnez	a4,800694 <strnlen+0x6>
  8006a4:	85be                	mv	a1,a5
  8006a6:	852e                	mv	a0,a1
  8006a8:	8082                	ret

00000000008006aa <main>:
  8006aa:	1141                	addi	sp,sp,-16
  8006ac:	e406                	sd	ra,8(sp)
  8006ae:	e022                	sd	s0,0(sp)
  8006b0:	b09ff0ef          	jal	ra,8001b8 <fork>
  8006b4:	c51d                	beqz	a0,8006e2 <main+0x38>
  8006b6:	842a                	mv	s0,a0
  8006b8:	04a05c63          	blez	a0,800710 <main+0x66>
  8006bc:	06400513          	li	a0,100
  8006c0:	afdff0ef          	jal	ra,8001bc <sleep>
  8006c4:	8522                	mv	a0,s0
  8006c6:	af5ff0ef          	jal	ra,8001ba <kill>
  8006ca:	e505                	bnez	a0,8006f2 <main+0x48>
  8006cc:	00000517          	auipc	a0,0x0
  8006d0:	59c50513          	addi	a0,a0,1436 # 800c68 <error_string+0x110>
  8006d4:	a23ff0ef          	jal	ra,8000f6 <cprintf>
  8006d8:	60a2                	ld	ra,8(sp)
  8006da:	6402                	ld	s0,0(sp)
  8006dc:	4501                	li	a0,0
  8006de:	0141                	addi	sp,sp,16
  8006e0:	8082                	ret
  8006e2:	557d                	li	a0,-1
  8006e4:	ad9ff0ef          	jal	ra,8001bc <sleep>
  8006e8:	6539                	lui	a0,0xe
  8006ea:	ead50513          	addi	a0,a0,-339 # dead <open-0x7f2173>
  8006ee:	ab5ff0ef          	jal	ra,8001a2 <exit>
  8006f2:	00000697          	auipc	a3,0x0
  8006f6:	56668693          	addi	a3,a3,1382 # 800c58 <error_string+0x100>
  8006fa:	00000617          	auipc	a2,0x0
  8006fe:	52e60613          	addi	a2,a2,1326 # 800c28 <error_string+0xd0>
  800702:	45b9                	li	a1,14
  800704:	00000517          	auipc	a0,0x0
  800708:	53c50513          	addi	a0,a0,1340 # 800c40 <error_string+0xe8>
  80070c:	925ff0ef          	jal	ra,800030 <__panic>
  800710:	00000697          	auipc	a3,0x0
  800714:	51068693          	addi	a3,a3,1296 # 800c20 <error_string+0xc8>
  800718:	00000617          	auipc	a2,0x0
  80071c:	51060613          	addi	a2,a2,1296 # 800c28 <error_string+0xd0>
  800720:	45ad                	li	a1,11
  800722:	00000517          	auipc	a0,0x0
  800726:	51e50513          	addi	a0,a0,1310 # 800c40 <error_string+0xe8>
  80072a:	907ff0ef          	jal	ra,800030 <__panic>
