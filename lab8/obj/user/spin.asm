
obj/__user_spin.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a2a5                	j	80018c <sys_open>

0000000000800026 <close>:
  800026:	aa85                	j	800196 <sys_close>

0000000000800028 <dup2>:
  800028:	aa9d                	j	80019e <sys_dup>

000000000080002a <_start>:
  80002a:	1e0000ef          	jal	ra,80020a <umain>
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
  800044:	74050513          	addi	a0,a0,1856 # 800780 <main+0xd2>
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
  800064:	79850513          	addi	a0,a0,1944 # 8007f8 <main+0x14a>
  800068:	08e000ef          	jal	ra,8000f6 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	13a000ef          	jal	ra,8001a8 <exit>

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
  800086:	71e50513          	addi	a0,a0,1822 # 8007a0 <main+0xf2>
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
  8000a6:	75650513          	addi	a0,a0,1878 # 8007f8 <main+0x14a>
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
  8000be:	0c8000ef          	jal	ra,800186 <sys_putc>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f31>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	20a000ef          	jal	ra,8002f4 <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f31>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1ce000ef          	jal	ra,8002f4 <vprintfmt>
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

0000000000800174 <sys_wait>:
  800174:	862e                	mv	a2,a1
  800176:	85aa                	mv	a1,a0
  800178:	450d                	li	a0,3
  80017a:	bf65                	j	800132 <syscall>

000000000080017c <sys_yield>:
  80017c:	4529                	li	a0,10
  80017e:	bf55                	j	800132 <syscall>

0000000000800180 <sys_kill>:
  800180:	85aa                	mv	a1,a0
  800182:	4531                	li	a0,12
  800184:	b77d                	j	800132 <syscall>

0000000000800186 <sys_putc>:
  800186:	85aa                	mv	a1,a0
  800188:	4579                	li	a0,30
  80018a:	b765                	j	800132 <syscall>

000000000080018c <sys_open>:
  80018c:	862e                	mv	a2,a1
  80018e:	85aa                	mv	a1,a0
  800190:	06400513          	li	a0,100
  800194:	bf79                	j	800132 <syscall>

0000000000800196 <sys_close>:
  800196:	85aa                	mv	a1,a0
  800198:	06500513          	li	a0,101
  80019c:	bf59                	j	800132 <syscall>

000000000080019e <sys_dup>:
  80019e:	862e                	mv	a2,a1
  8001a0:	85aa                	mv	a1,a0
  8001a2:	08200513          	li	a0,130
  8001a6:	b771                	j	800132 <syscall>

00000000008001a8 <exit>:
  8001a8:	1141                	addi	sp,sp,-16
  8001aa:	e406                	sd	ra,8(sp)
  8001ac:	fbfff0ef          	jal	ra,80016a <sys_exit>
  8001b0:	00000517          	auipc	a0,0x0
  8001b4:	61050513          	addi	a0,a0,1552 # 8007c0 <main+0x112>
  8001b8:	f3fff0ef          	jal	ra,8000f6 <cprintf>
  8001bc:	a001                	j	8001bc <exit+0x14>

00000000008001be <fork>:
  8001be:	bf4d                	j	800170 <sys_fork>

00000000008001c0 <waitpid>:
  8001c0:	bf55                	j	800174 <sys_wait>

00000000008001c2 <yield>:
  8001c2:	bf6d                	j	80017c <sys_yield>

00000000008001c4 <kill>:
  8001c4:	bf75                	j	800180 <sys_kill>

00000000008001c6 <initfd>:
  8001c6:	1101                	addi	sp,sp,-32
  8001c8:	87ae                	mv	a5,a1
  8001ca:	e426                	sd	s1,8(sp)
  8001cc:	85b2                	mv	a1,a2
  8001ce:	84aa                	mv	s1,a0
  8001d0:	853e                	mv	a0,a5
  8001d2:	e822                	sd	s0,16(sp)
  8001d4:	ec06                	sd	ra,24(sp)
  8001d6:	e4bff0ef          	jal	ra,800020 <open>
  8001da:	842a                	mv	s0,a0
  8001dc:	00054463          	bltz	a0,8001e4 <initfd+0x1e>
  8001e0:	00951863          	bne	a0,s1,8001f0 <initfd+0x2a>
  8001e4:	60e2                	ld	ra,24(sp)
  8001e6:	8522                	mv	a0,s0
  8001e8:	6442                	ld	s0,16(sp)
  8001ea:	64a2                	ld	s1,8(sp)
  8001ec:	6105                	addi	sp,sp,32
  8001ee:	8082                	ret
  8001f0:	8526                	mv	a0,s1
  8001f2:	e35ff0ef          	jal	ra,800026 <close>
  8001f6:	85a6                	mv	a1,s1
  8001f8:	8522                	mv	a0,s0
  8001fa:	e2fff0ef          	jal	ra,800028 <dup2>
  8001fe:	84aa                	mv	s1,a0
  800200:	8522                	mv	a0,s0
  800202:	e25ff0ef          	jal	ra,800026 <close>
  800206:	8426                	mv	s0,s1
  800208:	bff1                	j	8001e4 <initfd+0x1e>

000000000080020a <umain>:
  80020a:	1101                	addi	sp,sp,-32
  80020c:	e822                	sd	s0,16(sp)
  80020e:	e426                	sd	s1,8(sp)
  800210:	842a                	mv	s0,a0
  800212:	84ae                	mv	s1,a1
  800214:	4601                	li	a2,0
  800216:	00000597          	auipc	a1,0x0
  80021a:	5c258593          	addi	a1,a1,1474 # 8007d8 <main+0x12a>
  80021e:	4501                	li	a0,0
  800220:	ec06                	sd	ra,24(sp)
  800222:	fa5ff0ef          	jal	ra,8001c6 <initfd>
  800226:	02054263          	bltz	a0,80024a <umain+0x40>
  80022a:	4605                	li	a2,1
  80022c:	00000597          	auipc	a1,0x0
  800230:	5ec58593          	addi	a1,a1,1516 # 800818 <main+0x16a>
  800234:	4505                	li	a0,1
  800236:	f91ff0ef          	jal	ra,8001c6 <initfd>
  80023a:	02054563          	bltz	a0,800264 <umain+0x5a>
  80023e:	85a6                	mv	a1,s1
  800240:	8522                	mv	a0,s0
  800242:	46c000ef          	jal	ra,8006ae <main>
  800246:	f63ff0ef          	jal	ra,8001a8 <exit>
  80024a:	86aa                	mv	a3,a0
  80024c:	00000617          	auipc	a2,0x0
  800250:	59460613          	addi	a2,a2,1428 # 8007e0 <main+0x132>
  800254:	45e9                	li	a1,26
  800256:	00000517          	auipc	a0,0x0
  80025a:	5aa50513          	addi	a0,a0,1450 # 800800 <main+0x152>
  80025e:	e15ff0ef          	jal	ra,800072 <__warn>
  800262:	b7e1                	j	80022a <umain+0x20>
  800264:	86aa                	mv	a3,a0
  800266:	00000617          	auipc	a2,0x0
  80026a:	5ba60613          	addi	a2,a2,1466 # 800820 <main+0x172>
  80026e:	45f5                	li	a1,29
  800270:	00000517          	auipc	a0,0x0
  800274:	59050513          	addi	a0,a0,1424 # 800800 <main+0x152>
  800278:	dfbff0ef          	jal	ra,800072 <__warn>
  80027c:	b7c9                	j	80023e <umain+0x34>

000000000080027e <printnum>:
  80027e:	02071893          	slli	a7,a4,0x20
  800282:	7139                	addi	sp,sp,-64
  800284:	0208d893          	srli	a7,a7,0x20
  800288:	e456                	sd	s5,8(sp)
  80028a:	0316fab3          	remu	s5,a3,a7
  80028e:	f822                	sd	s0,48(sp)
  800290:	f426                	sd	s1,40(sp)
  800292:	f04a                	sd	s2,32(sp)
  800294:	ec4e                	sd	s3,24(sp)
  800296:	fc06                	sd	ra,56(sp)
  800298:	e852                	sd	s4,16(sp)
  80029a:	84aa                	mv	s1,a0
  80029c:	89ae                	mv	s3,a1
  80029e:	8932                	mv	s2,a2
  8002a0:	fff7841b          	addiw	s0,a5,-1
  8002a4:	2a81                	sext.w	s5,s5
  8002a6:	0516f163          	bgeu	a3,a7,8002e8 <printnum+0x6a>
  8002aa:	8a42                	mv	s4,a6
  8002ac:	00805863          	blez	s0,8002bc <printnum+0x3e>
  8002b0:	347d                	addiw	s0,s0,-1
  8002b2:	864e                	mv	a2,s3
  8002b4:	85ca                	mv	a1,s2
  8002b6:	8552                	mv	a0,s4
  8002b8:	9482                	jalr	s1
  8002ba:	f87d                	bnez	s0,8002b0 <printnum+0x32>
  8002bc:	1a82                	slli	s5,s5,0x20
  8002be:	00000797          	auipc	a5,0x0
  8002c2:	58278793          	addi	a5,a5,1410 # 800840 <main+0x192>
  8002c6:	020ada93          	srli	s5,s5,0x20
  8002ca:	9abe                	add	s5,s5,a5
  8002cc:	7442                	ld	s0,48(sp)
  8002ce:	000ac503          	lbu	a0,0(s5)
  8002d2:	70e2                	ld	ra,56(sp)
  8002d4:	6a42                	ld	s4,16(sp)
  8002d6:	6aa2                	ld	s5,8(sp)
  8002d8:	864e                	mv	a2,s3
  8002da:	85ca                	mv	a1,s2
  8002dc:	69e2                	ld	s3,24(sp)
  8002de:	7902                	ld	s2,32(sp)
  8002e0:	87a6                	mv	a5,s1
  8002e2:	74a2                	ld	s1,40(sp)
  8002e4:	6121                	addi	sp,sp,64
  8002e6:	8782                	jr	a5
  8002e8:	0316d6b3          	divu	a3,a3,a7
  8002ec:	87a2                	mv	a5,s0
  8002ee:	f91ff0ef          	jal	ra,80027e <printnum>
  8002f2:	b7e9                	j	8002bc <printnum+0x3e>

00000000008002f4 <vprintfmt>:
  8002f4:	7119                	addi	sp,sp,-128
  8002f6:	f4a6                	sd	s1,104(sp)
  8002f8:	f0ca                	sd	s2,96(sp)
  8002fa:	ecce                	sd	s3,88(sp)
  8002fc:	e8d2                	sd	s4,80(sp)
  8002fe:	e4d6                	sd	s5,72(sp)
  800300:	e0da                	sd	s6,64(sp)
  800302:	fc5e                	sd	s7,56(sp)
  800304:	ec6e                	sd	s11,24(sp)
  800306:	fc86                	sd	ra,120(sp)
  800308:	f8a2                	sd	s0,112(sp)
  80030a:	f862                	sd	s8,48(sp)
  80030c:	f466                	sd	s9,40(sp)
  80030e:	f06a                	sd	s10,32(sp)
  800310:	89aa                	mv	s3,a0
  800312:	892e                	mv	s2,a1
  800314:	84b2                	mv	s1,a2
  800316:	8db6                	mv	s11,a3
  800318:	8aba                	mv	s5,a4
  80031a:	02500a13          	li	s4,37
  80031e:	5bfd                	li	s7,-1
  800320:	00000b17          	auipc	s6,0x0
  800324:	554b0b13          	addi	s6,s6,1364 # 800874 <main+0x1c6>
  800328:	000dc503          	lbu	a0,0(s11)
  80032c:	001d8413          	addi	s0,s11,1
  800330:	01450b63          	beq	a0,s4,800346 <vprintfmt+0x52>
  800334:	c129                	beqz	a0,800376 <vprintfmt+0x82>
  800336:	864a                	mv	a2,s2
  800338:	85a6                	mv	a1,s1
  80033a:	0405                	addi	s0,s0,1
  80033c:	9982                	jalr	s3
  80033e:	fff44503          	lbu	a0,-1(s0)
  800342:	ff4519e3          	bne	a0,s4,800334 <vprintfmt+0x40>
  800346:	00044583          	lbu	a1,0(s0)
  80034a:	02000813          	li	a6,32
  80034e:	4d01                	li	s10,0
  800350:	4301                	li	t1,0
  800352:	5cfd                	li	s9,-1
  800354:	5c7d                	li	s8,-1
  800356:	05500513          	li	a0,85
  80035a:	48a5                	li	a7,9
  80035c:	fdd5861b          	addiw	a2,a1,-35
  800360:	0ff67613          	zext.b	a2,a2
  800364:	00140d93          	addi	s11,s0,1
  800368:	04c56263          	bltu	a0,a2,8003ac <vprintfmt+0xb8>
  80036c:	060a                	slli	a2,a2,0x2
  80036e:	965a                	add	a2,a2,s6
  800370:	4214                	lw	a3,0(a2)
  800372:	96da                	add	a3,a3,s6
  800374:	8682                	jr	a3
  800376:	70e6                	ld	ra,120(sp)
  800378:	7446                	ld	s0,112(sp)
  80037a:	74a6                	ld	s1,104(sp)
  80037c:	7906                	ld	s2,96(sp)
  80037e:	69e6                	ld	s3,88(sp)
  800380:	6a46                	ld	s4,80(sp)
  800382:	6aa6                	ld	s5,72(sp)
  800384:	6b06                	ld	s6,64(sp)
  800386:	7be2                	ld	s7,56(sp)
  800388:	7c42                	ld	s8,48(sp)
  80038a:	7ca2                	ld	s9,40(sp)
  80038c:	7d02                	ld	s10,32(sp)
  80038e:	6de2                	ld	s11,24(sp)
  800390:	6109                	addi	sp,sp,128
  800392:	8082                	ret
  800394:	882e                	mv	a6,a1
  800396:	00144583          	lbu	a1,1(s0)
  80039a:	846e                	mv	s0,s11
  80039c:	00140d93          	addi	s11,s0,1
  8003a0:	fdd5861b          	addiw	a2,a1,-35
  8003a4:	0ff67613          	zext.b	a2,a2
  8003a8:	fcc572e3          	bgeu	a0,a2,80036c <vprintfmt+0x78>
  8003ac:	864a                	mv	a2,s2
  8003ae:	85a6                	mv	a1,s1
  8003b0:	02500513          	li	a0,37
  8003b4:	9982                	jalr	s3
  8003b6:	fff44783          	lbu	a5,-1(s0)
  8003ba:	8da2                	mv	s11,s0
  8003bc:	f74786e3          	beq	a5,s4,800328 <vprintfmt+0x34>
  8003c0:	ffedc783          	lbu	a5,-2(s11)
  8003c4:	1dfd                	addi	s11,s11,-1
  8003c6:	ff479de3          	bne	a5,s4,8003c0 <vprintfmt+0xcc>
  8003ca:	bfb9                	j	800328 <vprintfmt+0x34>
  8003cc:	fd058c9b          	addiw	s9,a1,-48
  8003d0:	00144583          	lbu	a1,1(s0)
  8003d4:	846e                	mv	s0,s11
  8003d6:	fd05869b          	addiw	a3,a1,-48
  8003da:	0005861b          	sext.w	a2,a1
  8003de:	02d8e463          	bltu	a7,a3,800406 <vprintfmt+0x112>
  8003e2:	00144583          	lbu	a1,1(s0)
  8003e6:	002c969b          	slliw	a3,s9,0x2
  8003ea:	0196873b          	addw	a4,a3,s9
  8003ee:	0017171b          	slliw	a4,a4,0x1
  8003f2:	9f31                	addw	a4,a4,a2
  8003f4:	fd05869b          	addiw	a3,a1,-48
  8003f8:	0405                	addi	s0,s0,1
  8003fa:	fd070c9b          	addiw	s9,a4,-48
  8003fe:	0005861b          	sext.w	a2,a1
  800402:	fed8f0e3          	bgeu	a7,a3,8003e2 <vprintfmt+0xee>
  800406:	f40c5be3          	bgez	s8,80035c <vprintfmt+0x68>
  80040a:	8c66                	mv	s8,s9
  80040c:	5cfd                	li	s9,-1
  80040e:	b7b9                	j	80035c <vprintfmt+0x68>
  800410:	fffc4693          	not	a3,s8
  800414:	96fd                	srai	a3,a3,0x3f
  800416:	00dc77b3          	and	a5,s8,a3
  80041a:	00144583          	lbu	a1,1(s0)
  80041e:	00078c1b          	sext.w	s8,a5
  800422:	846e                	mv	s0,s11
  800424:	bf25                	j	80035c <vprintfmt+0x68>
  800426:	000aac83          	lw	s9,0(s5)
  80042a:	00144583          	lbu	a1,1(s0)
  80042e:	0aa1                	addi	s5,s5,8
  800430:	846e                	mv	s0,s11
  800432:	bfd1                	j	800406 <vprintfmt+0x112>
  800434:	4705                	li	a4,1
  800436:	008a8613          	addi	a2,s5,8
  80043a:	00674463          	blt	a4,t1,800442 <vprintfmt+0x14e>
  80043e:	1c030c63          	beqz	t1,800616 <vprintfmt+0x322>
  800442:	000ab683          	ld	a3,0(s5)
  800446:	4741                	li	a4,16
  800448:	8ab2                	mv	s5,a2
  80044a:	2801                	sext.w	a6,a6
  80044c:	87e2                	mv	a5,s8
  80044e:	8626                	mv	a2,s1
  800450:	85ca                	mv	a1,s2
  800452:	854e                	mv	a0,s3
  800454:	e2bff0ef          	jal	ra,80027e <printnum>
  800458:	bdc1                	j	800328 <vprintfmt+0x34>
  80045a:	000aa503          	lw	a0,0(s5)
  80045e:	864a                	mv	a2,s2
  800460:	85a6                	mv	a1,s1
  800462:	0aa1                	addi	s5,s5,8
  800464:	9982                	jalr	s3
  800466:	b5c9                	j	800328 <vprintfmt+0x34>
  800468:	4705                	li	a4,1
  80046a:	008a8613          	addi	a2,s5,8
  80046e:	00674463          	blt	a4,t1,800476 <vprintfmt+0x182>
  800472:	18030d63          	beqz	t1,80060c <vprintfmt+0x318>
  800476:	000ab683          	ld	a3,0(s5)
  80047a:	4729                	li	a4,10
  80047c:	8ab2                	mv	s5,a2
  80047e:	b7f1                	j	80044a <vprintfmt+0x156>
  800480:	00144583          	lbu	a1,1(s0)
  800484:	4d05                	li	s10,1
  800486:	846e                	mv	s0,s11
  800488:	bdd1                	j	80035c <vprintfmt+0x68>
  80048a:	864a                	mv	a2,s2
  80048c:	85a6                	mv	a1,s1
  80048e:	02500513          	li	a0,37
  800492:	9982                	jalr	s3
  800494:	bd51                	j	800328 <vprintfmt+0x34>
  800496:	00144583          	lbu	a1,1(s0)
  80049a:	2305                	addiw	t1,t1,1
  80049c:	846e                	mv	s0,s11
  80049e:	bd7d                	j	80035c <vprintfmt+0x68>
  8004a0:	4705                	li	a4,1
  8004a2:	008a8613          	addi	a2,s5,8
  8004a6:	00674463          	blt	a4,t1,8004ae <vprintfmt+0x1ba>
  8004aa:	14030c63          	beqz	t1,800602 <vprintfmt+0x30e>
  8004ae:	000ab683          	ld	a3,0(s5)
  8004b2:	4721                	li	a4,8
  8004b4:	8ab2                	mv	s5,a2
  8004b6:	bf51                	j	80044a <vprintfmt+0x156>
  8004b8:	03000513          	li	a0,48
  8004bc:	864a                	mv	a2,s2
  8004be:	85a6                	mv	a1,s1
  8004c0:	e042                	sd	a6,0(sp)
  8004c2:	9982                	jalr	s3
  8004c4:	864a                	mv	a2,s2
  8004c6:	85a6                	mv	a1,s1
  8004c8:	07800513          	li	a0,120
  8004cc:	9982                	jalr	s3
  8004ce:	0aa1                	addi	s5,s5,8
  8004d0:	6802                	ld	a6,0(sp)
  8004d2:	4741                	li	a4,16
  8004d4:	ff8ab683          	ld	a3,-8(s5)
  8004d8:	bf8d                	j	80044a <vprintfmt+0x156>
  8004da:	000ab403          	ld	s0,0(s5)
  8004de:	008a8793          	addi	a5,s5,8
  8004e2:	e03e                	sd	a5,0(sp)
  8004e4:	14040c63          	beqz	s0,80063c <vprintfmt+0x348>
  8004e8:	11805063          	blez	s8,8005e8 <vprintfmt+0x2f4>
  8004ec:	02d00693          	li	a3,45
  8004f0:	0cd81963          	bne	a6,a3,8005c2 <vprintfmt+0x2ce>
  8004f4:	00044683          	lbu	a3,0(s0)
  8004f8:	0006851b          	sext.w	a0,a3
  8004fc:	ce8d                	beqz	a3,800536 <vprintfmt+0x242>
  8004fe:	00140a93          	addi	s5,s0,1
  800502:	05e00413          	li	s0,94
  800506:	000cc563          	bltz	s9,800510 <vprintfmt+0x21c>
  80050a:	3cfd                	addiw	s9,s9,-1
  80050c:	037c8363          	beq	s9,s7,800532 <vprintfmt+0x23e>
  800510:	864a                	mv	a2,s2
  800512:	85a6                	mv	a1,s1
  800514:	100d0663          	beqz	s10,800620 <vprintfmt+0x32c>
  800518:	3681                	addiw	a3,a3,-32
  80051a:	10d47363          	bgeu	s0,a3,800620 <vprintfmt+0x32c>
  80051e:	03f00513          	li	a0,63
  800522:	9982                	jalr	s3
  800524:	000ac683          	lbu	a3,0(s5)
  800528:	3c7d                	addiw	s8,s8,-1
  80052a:	0a85                	addi	s5,s5,1
  80052c:	0006851b          	sext.w	a0,a3
  800530:	faf9                	bnez	a3,800506 <vprintfmt+0x212>
  800532:	01805a63          	blez	s8,800546 <vprintfmt+0x252>
  800536:	3c7d                	addiw	s8,s8,-1
  800538:	864a                	mv	a2,s2
  80053a:	85a6                	mv	a1,s1
  80053c:	02000513          	li	a0,32
  800540:	9982                	jalr	s3
  800542:	fe0c1ae3          	bnez	s8,800536 <vprintfmt+0x242>
  800546:	6a82                	ld	s5,0(sp)
  800548:	b3c5                	j	800328 <vprintfmt+0x34>
  80054a:	4705                	li	a4,1
  80054c:	008a8d13          	addi	s10,s5,8
  800550:	00674463          	blt	a4,t1,800558 <vprintfmt+0x264>
  800554:	0a030463          	beqz	t1,8005fc <vprintfmt+0x308>
  800558:	000ab403          	ld	s0,0(s5)
  80055c:	0c044463          	bltz	s0,800624 <vprintfmt+0x330>
  800560:	86a2                	mv	a3,s0
  800562:	8aea                	mv	s5,s10
  800564:	4729                	li	a4,10
  800566:	b5d5                	j	80044a <vprintfmt+0x156>
  800568:	000aa783          	lw	a5,0(s5)
  80056c:	46e1                	li	a3,24
  80056e:	0aa1                	addi	s5,s5,8
  800570:	41f7d71b          	sraiw	a4,a5,0x1f
  800574:	8fb9                	xor	a5,a5,a4
  800576:	40e7873b          	subw	a4,a5,a4
  80057a:	02e6c663          	blt	a3,a4,8005a6 <vprintfmt+0x2b2>
  80057e:	00371793          	slli	a5,a4,0x3
  800582:	00000697          	auipc	a3,0x0
  800586:	62668693          	addi	a3,a3,1574 # 800ba8 <error_string>
  80058a:	97b6                	add	a5,a5,a3
  80058c:	639c                	ld	a5,0(a5)
  80058e:	cf81                	beqz	a5,8005a6 <vprintfmt+0x2b2>
  800590:	873e                	mv	a4,a5
  800592:	00000697          	auipc	a3,0x0
  800596:	2de68693          	addi	a3,a3,734 # 800870 <main+0x1c2>
  80059a:	8626                	mv	a2,s1
  80059c:	85ca                	mv	a1,s2
  80059e:	854e                	mv	a0,s3
  8005a0:	0d4000ef          	jal	ra,800674 <printfmt>
  8005a4:	b351                	j	800328 <vprintfmt+0x34>
  8005a6:	00000697          	auipc	a3,0x0
  8005aa:	2ba68693          	addi	a3,a3,698 # 800860 <main+0x1b2>
  8005ae:	8626                	mv	a2,s1
  8005b0:	85ca                	mv	a1,s2
  8005b2:	854e                	mv	a0,s3
  8005b4:	0c0000ef          	jal	ra,800674 <printfmt>
  8005b8:	bb85                	j	800328 <vprintfmt+0x34>
  8005ba:	00000417          	auipc	s0,0x0
  8005be:	29e40413          	addi	s0,s0,670 # 800858 <main+0x1aa>
  8005c2:	85e6                	mv	a1,s9
  8005c4:	8522                	mv	a0,s0
  8005c6:	e442                	sd	a6,8(sp)
  8005c8:	0ca000ef          	jal	ra,800692 <strnlen>
  8005cc:	40ac0c3b          	subw	s8,s8,a0
  8005d0:	01805c63          	blez	s8,8005e8 <vprintfmt+0x2f4>
  8005d4:	6822                	ld	a6,8(sp)
  8005d6:	00080a9b          	sext.w	s5,a6
  8005da:	3c7d                	addiw	s8,s8,-1
  8005dc:	864a                	mv	a2,s2
  8005de:	85a6                	mv	a1,s1
  8005e0:	8556                	mv	a0,s5
  8005e2:	9982                	jalr	s3
  8005e4:	fe0c1be3          	bnez	s8,8005da <vprintfmt+0x2e6>
  8005e8:	00044683          	lbu	a3,0(s0)
  8005ec:	00140a93          	addi	s5,s0,1
  8005f0:	0006851b          	sext.w	a0,a3
  8005f4:	daa9                	beqz	a3,800546 <vprintfmt+0x252>
  8005f6:	05e00413          	li	s0,94
  8005fa:	b731                	j	800506 <vprintfmt+0x212>
  8005fc:	000aa403          	lw	s0,0(s5)
  800600:	bfb1                	j	80055c <vprintfmt+0x268>
  800602:	000ae683          	lwu	a3,0(s5)
  800606:	4721                	li	a4,8
  800608:	8ab2                	mv	s5,a2
  80060a:	b581                	j	80044a <vprintfmt+0x156>
  80060c:	000ae683          	lwu	a3,0(s5)
  800610:	4729                	li	a4,10
  800612:	8ab2                	mv	s5,a2
  800614:	bd1d                	j	80044a <vprintfmt+0x156>
  800616:	000ae683          	lwu	a3,0(s5)
  80061a:	4741                	li	a4,16
  80061c:	8ab2                	mv	s5,a2
  80061e:	b535                	j	80044a <vprintfmt+0x156>
  800620:	9982                	jalr	s3
  800622:	b709                	j	800524 <vprintfmt+0x230>
  800624:	864a                	mv	a2,s2
  800626:	85a6                	mv	a1,s1
  800628:	02d00513          	li	a0,45
  80062c:	e042                	sd	a6,0(sp)
  80062e:	9982                	jalr	s3
  800630:	6802                	ld	a6,0(sp)
  800632:	8aea                	mv	s5,s10
  800634:	408006b3          	neg	a3,s0
  800638:	4729                	li	a4,10
  80063a:	bd01                	j	80044a <vprintfmt+0x156>
  80063c:	03805163          	blez	s8,80065e <vprintfmt+0x36a>
  800640:	02d00693          	li	a3,45
  800644:	f6d81be3          	bne	a6,a3,8005ba <vprintfmt+0x2c6>
  800648:	00000417          	auipc	s0,0x0
  80064c:	21040413          	addi	s0,s0,528 # 800858 <main+0x1aa>
  800650:	02800693          	li	a3,40
  800654:	02800513          	li	a0,40
  800658:	00140a93          	addi	s5,s0,1
  80065c:	b55d                	j	800502 <vprintfmt+0x20e>
  80065e:	00000a97          	auipc	s5,0x0
  800662:	1fba8a93          	addi	s5,s5,507 # 800859 <main+0x1ab>
  800666:	02800513          	li	a0,40
  80066a:	02800693          	li	a3,40
  80066e:	05e00413          	li	s0,94
  800672:	bd51                	j	800506 <vprintfmt+0x212>

0000000000800674 <printfmt>:
  800674:	7139                	addi	sp,sp,-64
  800676:	02010313          	addi	t1,sp,32
  80067a:	f03a                	sd	a4,32(sp)
  80067c:	871a                	mv	a4,t1
  80067e:	ec06                	sd	ra,24(sp)
  800680:	f43e                	sd	a5,40(sp)
  800682:	f842                	sd	a6,48(sp)
  800684:	fc46                	sd	a7,56(sp)
  800686:	e41a                	sd	t1,8(sp)
  800688:	c6dff0ef          	jal	ra,8002f4 <vprintfmt>
  80068c:	60e2                	ld	ra,24(sp)
  80068e:	6121                	addi	sp,sp,64
  800690:	8082                	ret

0000000000800692 <strnlen>:
  800692:	4781                	li	a5,0
  800694:	e589                	bnez	a1,80069e <strnlen+0xc>
  800696:	a811                	j	8006aa <strnlen+0x18>
  800698:	0785                	addi	a5,a5,1
  80069a:	00f58863          	beq	a1,a5,8006aa <strnlen+0x18>
  80069e:	00f50733          	add	a4,a0,a5
  8006a2:	00074703          	lbu	a4,0(a4)
  8006a6:	fb6d                	bnez	a4,800698 <strnlen+0x6>
  8006a8:	85be                	mv	a1,a5
  8006aa:	852e                	mv	a0,a1
  8006ac:	8082                	ret

00000000008006ae <main>:
  8006ae:	1141                	addi	sp,sp,-16
  8006b0:	00000517          	auipc	a0,0x0
  8006b4:	5c050513          	addi	a0,a0,1472 # 800c70 <error_string+0xc8>
  8006b8:	e406                	sd	ra,8(sp)
  8006ba:	e022                	sd	s0,0(sp)
  8006bc:	a3bff0ef          	jal	ra,8000f6 <cprintf>
  8006c0:	affff0ef          	jal	ra,8001be <fork>
  8006c4:	e901                	bnez	a0,8006d4 <main+0x26>
  8006c6:	00000517          	auipc	a0,0x0
  8006ca:	5d250513          	addi	a0,a0,1490 # 800c98 <error_string+0xf0>
  8006ce:	a29ff0ef          	jal	ra,8000f6 <cprintf>
  8006d2:	a001                	j	8006d2 <main+0x24>
  8006d4:	842a                	mv	s0,a0
  8006d6:	00000517          	auipc	a0,0x0
  8006da:	5e250513          	addi	a0,a0,1506 # 800cb8 <error_string+0x110>
  8006de:	a19ff0ef          	jal	ra,8000f6 <cprintf>
  8006e2:	ae1ff0ef          	jal	ra,8001c2 <yield>
  8006e6:	addff0ef          	jal	ra,8001c2 <yield>
  8006ea:	ad9ff0ef          	jal	ra,8001c2 <yield>
  8006ee:	00000517          	auipc	a0,0x0
  8006f2:	5f250513          	addi	a0,a0,1522 # 800ce0 <error_string+0x138>
  8006f6:	a01ff0ef          	jal	ra,8000f6 <cprintf>
  8006fa:	8522                	mv	a0,s0
  8006fc:	ac9ff0ef          	jal	ra,8001c4 <kill>
  800700:	ed31                	bnez	a0,80075c <main+0xae>
  800702:	4581                	li	a1,0
  800704:	00000517          	auipc	a0,0x0
  800708:	64450513          	addi	a0,a0,1604 # 800d48 <error_string+0x1a0>
  80070c:	9ebff0ef          	jal	ra,8000f6 <cprintf>
  800710:	4581                	li	a1,0
  800712:	8522                	mv	a0,s0
  800714:	aadff0ef          	jal	ra,8001c0 <waitpid>
  800718:	e11d                	bnez	a0,80073e <main+0x90>
  80071a:	4581                	li	a1,0
  80071c:	00000517          	auipc	a0,0x0
  800720:	66450513          	addi	a0,a0,1636 # 800d80 <error_string+0x1d8>
  800724:	9d3ff0ef          	jal	ra,8000f6 <cprintf>
  800728:	00000517          	auipc	a0,0x0
  80072c:	67050513          	addi	a0,a0,1648 # 800d98 <error_string+0x1f0>
  800730:	9c7ff0ef          	jal	ra,8000f6 <cprintf>
  800734:	60a2                	ld	ra,8(sp)
  800736:	6402                	ld	s0,0(sp)
  800738:	4501                	li	a0,0
  80073a:	0141                	addi	sp,sp,16
  80073c:	8082                	ret
  80073e:	00000697          	auipc	a3,0x0
  800742:	62268693          	addi	a3,a3,1570 # 800d60 <error_string+0x1b8>
  800746:	00000617          	auipc	a2,0x0
  80074a:	5da60613          	addi	a2,a2,1498 # 800d20 <error_string+0x178>
  80074e:	45dd                	li	a1,23
  800750:	00000517          	auipc	a0,0x0
  800754:	5e850513          	addi	a0,a0,1512 # 800d38 <error_string+0x190>
  800758:	8d9ff0ef          	jal	ra,800030 <__panic>
  80075c:	00000697          	auipc	a3,0x0
  800760:	5ac68693          	addi	a3,a3,1452 # 800d08 <error_string+0x160>
  800764:	00000617          	auipc	a2,0x0
  800768:	5bc60613          	addi	a2,a2,1468 # 800d20 <error_string+0x178>
  80076c:	45d1                	li	a1,20
  80076e:	00000517          	auipc	a0,0x0
  800772:	5ca50513          	addi	a0,a0,1482 # 800d38 <error_string+0x190>
  800776:	8bbff0ef          	jal	ra,800030 <__panic>
