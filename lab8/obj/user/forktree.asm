
obj/__user_forktree.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa31                	j	800140 <sys_open>

0000000000800026 <close>:
  800026:	a215                	j	80014a <sys_close>

0000000000800028 <dup2>:
  800028:	a22d                	j	800152 <sys_dup>

000000000080002a <_start>:
  80002a:	192000ef          	jal	ra,8001bc <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__warn>:
  800030:	715d                	addi	sp,sp,-80
  800032:	832e                	mv	t1,a1
  800034:	e822                	sd	s0,16(sp)
  800036:	85aa                	mv	a1,a0
  800038:	8432                	mv	s0,a2
  80003a:	fc3e                	sd	a5,56(sp)
  80003c:	861a                	mv	a2,t1
  80003e:	103c                	addi	a5,sp,40
  800040:	00000517          	auipc	a0,0x0
  800044:	79050513          	addi	a0,a0,1936 # 8007d0 <main+0x3e>
  800048:	ec06                	sd	ra,24(sp)
  80004a:	f436                	sd	a3,40(sp)
  80004c:	f83a                	sd	a4,48(sp)
  80004e:	e0c2                	sd	a6,64(sp)
  800050:	e4c6                	sd	a7,72(sp)
  800052:	e43e                	sd	a5,8(sp)
  800054:	060000ef          	jal	ra,8000b4 <cprintf>
  800058:	65a2                	ld	a1,8(sp)
  80005a:	8522                	mv	a0,s0
  80005c:	032000ef          	jal	ra,80008e <vcprintf>
  800060:	00000517          	auipc	a0,0x0
  800064:	7c850513          	addi	a0,a0,1992 # 800828 <main+0x96>
  800068:	04c000ef          	jal	ra,8000b4 <cprintf>
  80006c:	60e2                	ld	ra,24(sp)
  80006e:	6442                	ld	s0,16(sp)
  800070:	6161                	addi	sp,sp,80
  800072:	8082                	ret

0000000000800074 <cputch>:
  800074:	1141                	addi	sp,sp,-16
  800076:	e022                	sd	s0,0(sp)
  800078:	e406                	sd	ra,8(sp)
  80007a:	842e                	mv	s0,a1
  80007c:	0be000ef          	jal	ra,80013a <sys_putc>
  800080:	401c                	lw	a5,0(s0)
  800082:	60a2                	ld	ra,8(sp)
  800084:	2785                	addiw	a5,a5,1
  800086:	c01c                	sw	a5,0(s0)
  800088:	6402                	ld	s0,0(sp)
  80008a:	0141                	addi	sp,sp,16
  80008c:	8082                	ret

000000000080008e <vcprintf>:
  80008e:	1101                	addi	sp,sp,-32
  800090:	872e                	mv	a4,a1
  800092:	75dd                	lui	a1,0xffff7
  800094:	86aa                	mv	a3,a0
  800096:	0070                	addi	a2,sp,12
  800098:	00000517          	auipc	a0,0x0
  80009c:	fdc50513          	addi	a0,a0,-36 # 800074 <cputch>
  8000a0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f01>
  8000a4:	ec06                	sd	ra,24(sp)
  8000a6:	c602                	sw	zero,12(sp)
  8000a8:	218000ef          	jal	ra,8002c0 <vprintfmt>
  8000ac:	60e2                	ld	ra,24(sp)
  8000ae:	4532                	lw	a0,12(sp)
  8000b0:	6105                	addi	sp,sp,32
  8000b2:	8082                	ret

00000000008000b4 <cprintf>:
  8000b4:	711d                	addi	sp,sp,-96
  8000b6:	02810313          	addi	t1,sp,40
  8000ba:	8e2a                	mv	t3,a0
  8000bc:	f42e                	sd	a1,40(sp)
  8000be:	75dd                	lui	a1,0xffff7
  8000c0:	f832                	sd	a2,48(sp)
  8000c2:	fc36                	sd	a3,56(sp)
  8000c4:	e0ba                	sd	a4,64(sp)
  8000c6:	00000517          	auipc	a0,0x0
  8000ca:	fae50513          	addi	a0,a0,-82 # 800074 <cputch>
  8000ce:	0050                	addi	a2,sp,4
  8000d0:	871a                	mv	a4,t1
  8000d2:	86f2                	mv	a3,t3
  8000d4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f01>
  8000d8:	ec06                	sd	ra,24(sp)
  8000da:	e4be                	sd	a5,72(sp)
  8000dc:	e8c2                	sd	a6,80(sp)
  8000de:	ecc6                	sd	a7,88(sp)
  8000e0:	e41a                	sd	t1,8(sp)
  8000e2:	c202                	sw	zero,4(sp)
  8000e4:	1dc000ef          	jal	ra,8002c0 <vprintfmt>
  8000e8:	60e2                	ld	ra,24(sp)
  8000ea:	4512                	lw	a0,4(sp)
  8000ec:	6125                	addi	sp,sp,96
  8000ee:	8082                	ret

00000000008000f0 <syscall>:
  8000f0:	7175                	addi	sp,sp,-144
  8000f2:	f8ba                	sd	a4,112(sp)
  8000f4:	e0ba                	sd	a4,64(sp)
  8000f6:	0118                	addi	a4,sp,128
  8000f8:	e42a                	sd	a0,8(sp)
  8000fa:	ecae                	sd	a1,88(sp)
  8000fc:	f0b2                	sd	a2,96(sp)
  8000fe:	f4b6                	sd	a3,104(sp)
  800100:	fcbe                	sd	a5,120(sp)
  800102:	e142                	sd	a6,128(sp)
  800104:	e546                	sd	a7,136(sp)
  800106:	f42e                	sd	a1,40(sp)
  800108:	f832                	sd	a2,48(sp)
  80010a:	fc36                	sd	a3,56(sp)
  80010c:	f03a                	sd	a4,32(sp)
  80010e:	e4be                	sd	a5,72(sp)
  800110:	4522                	lw	a0,8(sp)
  800112:	55a2                	lw	a1,40(sp)
  800114:	5642                	lw	a2,48(sp)
  800116:	56e2                	lw	a3,56(sp)
  800118:	4706                	lw	a4,64(sp)
  80011a:	47a6                	lw	a5,72(sp)
  80011c:	00000073          	ecall
  800120:	ce2a                	sw	a0,28(sp)
  800122:	4572                	lw	a0,28(sp)
  800124:	6149                	addi	sp,sp,144
  800126:	8082                	ret

0000000000800128 <sys_exit>:
  800128:	85aa                	mv	a1,a0
  80012a:	4505                	li	a0,1
  80012c:	b7d1                	j	8000f0 <syscall>

000000000080012e <sys_fork>:
  80012e:	4509                	li	a0,2
  800130:	b7c1                	j	8000f0 <syscall>

0000000000800132 <sys_yield>:
  800132:	4529                	li	a0,10
  800134:	bf75                	j	8000f0 <syscall>

0000000000800136 <sys_getpid>:
  800136:	4549                	li	a0,18
  800138:	bf65                	j	8000f0 <syscall>

000000000080013a <sys_putc>:
  80013a:	85aa                	mv	a1,a0
  80013c:	4579                	li	a0,30
  80013e:	bf4d                	j	8000f0 <syscall>

0000000000800140 <sys_open>:
  800140:	862e                	mv	a2,a1
  800142:	85aa                	mv	a1,a0
  800144:	06400513          	li	a0,100
  800148:	b765                	j	8000f0 <syscall>

000000000080014a <sys_close>:
  80014a:	85aa                	mv	a1,a0
  80014c:	06500513          	li	a0,101
  800150:	b745                	j	8000f0 <syscall>

0000000000800152 <sys_dup>:
  800152:	862e                	mv	a2,a1
  800154:	85aa                	mv	a1,a0
  800156:	08200513          	li	a0,130
  80015a:	bf59                	j	8000f0 <syscall>

000000000080015c <exit>:
  80015c:	1141                	addi	sp,sp,-16
  80015e:	e406                	sd	ra,8(sp)
  800160:	fc9ff0ef          	jal	ra,800128 <sys_exit>
  800164:	00000517          	auipc	a0,0x0
  800168:	68c50513          	addi	a0,a0,1676 # 8007f0 <main+0x5e>
  80016c:	f49ff0ef          	jal	ra,8000b4 <cprintf>
  800170:	a001                	j	800170 <exit+0x14>

0000000000800172 <fork>:
  800172:	bf75                	j	80012e <sys_fork>

0000000000800174 <yield>:
  800174:	bf7d                	j	800132 <sys_yield>

0000000000800176 <getpid>:
  800176:	b7c1                	j	800136 <sys_getpid>

0000000000800178 <initfd>:
  800178:	1101                	addi	sp,sp,-32
  80017a:	87ae                	mv	a5,a1
  80017c:	e426                	sd	s1,8(sp)
  80017e:	85b2                	mv	a1,a2
  800180:	84aa                	mv	s1,a0
  800182:	853e                	mv	a0,a5
  800184:	e822                	sd	s0,16(sp)
  800186:	ec06                	sd	ra,24(sp)
  800188:	e99ff0ef          	jal	ra,800020 <open>
  80018c:	842a                	mv	s0,a0
  80018e:	00054463          	bltz	a0,800196 <initfd+0x1e>
  800192:	00951863          	bne	a0,s1,8001a2 <initfd+0x2a>
  800196:	60e2                	ld	ra,24(sp)
  800198:	8522                	mv	a0,s0
  80019a:	6442                	ld	s0,16(sp)
  80019c:	64a2                	ld	s1,8(sp)
  80019e:	6105                	addi	sp,sp,32
  8001a0:	8082                	ret
  8001a2:	8526                	mv	a0,s1
  8001a4:	e83ff0ef          	jal	ra,800026 <close>
  8001a8:	85a6                	mv	a1,s1
  8001aa:	8522                	mv	a0,s0
  8001ac:	e7dff0ef          	jal	ra,800028 <dup2>
  8001b0:	84aa                	mv	s1,a0
  8001b2:	8522                	mv	a0,s0
  8001b4:	e73ff0ef          	jal	ra,800026 <close>
  8001b8:	8426                	mv	s0,s1
  8001ba:	bff1                	j	800196 <initfd+0x1e>

00000000008001bc <umain>:
  8001bc:	1101                	addi	sp,sp,-32
  8001be:	e822                	sd	s0,16(sp)
  8001c0:	e426                	sd	s1,8(sp)
  8001c2:	842a                	mv	s0,a0
  8001c4:	84ae                	mv	s1,a1
  8001c6:	4601                	li	a2,0
  8001c8:	00000597          	auipc	a1,0x0
  8001cc:	64058593          	addi	a1,a1,1600 # 800808 <main+0x76>
  8001d0:	4501                	li	a0,0
  8001d2:	ec06                	sd	ra,24(sp)
  8001d4:	fa5ff0ef          	jal	ra,800178 <initfd>
  8001d8:	02054263          	bltz	a0,8001fc <umain+0x40>
  8001dc:	4605                	li	a2,1
  8001de:	00000597          	auipc	a1,0x0
  8001e2:	66a58593          	addi	a1,a1,1642 # 800848 <main+0xb6>
  8001e6:	4505                	li	a0,1
  8001e8:	f91ff0ef          	jal	ra,800178 <initfd>
  8001ec:	02054563          	bltz	a0,800216 <umain+0x5a>
  8001f0:	85a6                	mv	a1,s1
  8001f2:	8522                	mv	a0,s0
  8001f4:	59e000ef          	jal	ra,800792 <main>
  8001f8:	f65ff0ef          	jal	ra,80015c <exit>
  8001fc:	86aa                	mv	a3,a0
  8001fe:	00000617          	auipc	a2,0x0
  800202:	61260613          	addi	a2,a2,1554 # 800810 <main+0x7e>
  800206:	45e9                	li	a1,26
  800208:	00000517          	auipc	a0,0x0
  80020c:	62850513          	addi	a0,a0,1576 # 800830 <main+0x9e>
  800210:	e21ff0ef          	jal	ra,800030 <__warn>
  800214:	b7e1                	j	8001dc <umain+0x20>
  800216:	86aa                	mv	a3,a0
  800218:	00000617          	auipc	a2,0x0
  80021c:	63860613          	addi	a2,a2,1592 # 800850 <main+0xbe>
  800220:	45f5                	li	a1,29
  800222:	00000517          	auipc	a0,0x0
  800226:	60e50513          	addi	a0,a0,1550 # 800830 <main+0x9e>
  80022a:	e07ff0ef          	jal	ra,800030 <__warn>
  80022e:	b7c9                	j	8001f0 <umain+0x34>

0000000000800230 <printnum>:
  800230:	02071893          	slli	a7,a4,0x20
  800234:	7139                	addi	sp,sp,-64
  800236:	0208d893          	srli	a7,a7,0x20
  80023a:	e456                	sd	s5,8(sp)
  80023c:	0316fab3          	remu	s5,a3,a7
  800240:	f822                	sd	s0,48(sp)
  800242:	f426                	sd	s1,40(sp)
  800244:	f04a                	sd	s2,32(sp)
  800246:	ec4e                	sd	s3,24(sp)
  800248:	fc06                	sd	ra,56(sp)
  80024a:	e852                	sd	s4,16(sp)
  80024c:	84aa                	mv	s1,a0
  80024e:	89ae                	mv	s3,a1
  800250:	8932                	mv	s2,a2
  800252:	fff7841b          	addiw	s0,a5,-1
  800256:	2a81                	sext.w	s5,s5
  800258:	0516f163          	bgeu	a3,a7,80029a <printnum+0x6a>
  80025c:	8a42                	mv	s4,a6
  80025e:	00805863          	blez	s0,80026e <printnum+0x3e>
  800262:	347d                	addiw	s0,s0,-1
  800264:	864e                	mv	a2,s3
  800266:	85ca                	mv	a1,s2
  800268:	8552                	mv	a0,s4
  80026a:	9482                	jalr	s1
  80026c:	f87d                	bnez	s0,800262 <printnum+0x32>
  80026e:	1a82                	slli	s5,s5,0x20
  800270:	00000797          	auipc	a5,0x0
  800274:	60078793          	addi	a5,a5,1536 # 800870 <main+0xde>
  800278:	020ada93          	srli	s5,s5,0x20
  80027c:	9abe                	add	s5,s5,a5
  80027e:	7442                	ld	s0,48(sp)
  800280:	000ac503          	lbu	a0,0(s5)
  800284:	70e2                	ld	ra,56(sp)
  800286:	6a42                	ld	s4,16(sp)
  800288:	6aa2                	ld	s5,8(sp)
  80028a:	864e                	mv	a2,s3
  80028c:	85ca                	mv	a1,s2
  80028e:	69e2                	ld	s3,24(sp)
  800290:	7902                	ld	s2,32(sp)
  800292:	87a6                	mv	a5,s1
  800294:	74a2                	ld	s1,40(sp)
  800296:	6121                	addi	sp,sp,64
  800298:	8782                	jr	a5
  80029a:	0316d6b3          	divu	a3,a3,a7
  80029e:	87a2                	mv	a5,s0
  8002a0:	f91ff0ef          	jal	ra,800230 <printnum>
  8002a4:	b7e9                	j	80026e <printnum+0x3e>

00000000008002a6 <sprintputch>:
  8002a6:	499c                	lw	a5,16(a1)
  8002a8:	6198                	ld	a4,0(a1)
  8002aa:	6594                	ld	a3,8(a1)
  8002ac:	2785                	addiw	a5,a5,1
  8002ae:	c99c                	sw	a5,16(a1)
  8002b0:	00d77763          	bgeu	a4,a3,8002be <sprintputch+0x18>
  8002b4:	00170793          	addi	a5,a4,1
  8002b8:	e19c                	sd	a5,0(a1)
  8002ba:	00a70023          	sb	a0,0(a4)
  8002be:	8082                	ret

00000000008002c0 <vprintfmt>:
  8002c0:	7119                	addi	sp,sp,-128
  8002c2:	f4a6                	sd	s1,104(sp)
  8002c4:	f0ca                	sd	s2,96(sp)
  8002c6:	ecce                	sd	s3,88(sp)
  8002c8:	e8d2                	sd	s4,80(sp)
  8002ca:	e4d6                	sd	s5,72(sp)
  8002cc:	e0da                	sd	s6,64(sp)
  8002ce:	fc5e                	sd	s7,56(sp)
  8002d0:	ec6e                	sd	s11,24(sp)
  8002d2:	fc86                	sd	ra,120(sp)
  8002d4:	f8a2                	sd	s0,112(sp)
  8002d6:	f862                	sd	s8,48(sp)
  8002d8:	f466                	sd	s9,40(sp)
  8002da:	f06a                	sd	s10,32(sp)
  8002dc:	89aa                	mv	s3,a0
  8002de:	892e                	mv	s2,a1
  8002e0:	84b2                	mv	s1,a2
  8002e2:	8db6                	mv	s11,a3
  8002e4:	8aba                	mv	s5,a4
  8002e6:	02500a13          	li	s4,37
  8002ea:	5bfd                	li	s7,-1
  8002ec:	00000b17          	auipc	s6,0x0
  8002f0:	5b8b0b13          	addi	s6,s6,1464 # 8008a4 <main+0x112>
  8002f4:	000dc503          	lbu	a0,0(s11)
  8002f8:	001d8413          	addi	s0,s11,1
  8002fc:	01450b63          	beq	a0,s4,800312 <vprintfmt+0x52>
  800300:	c129                	beqz	a0,800342 <vprintfmt+0x82>
  800302:	864a                	mv	a2,s2
  800304:	85a6                	mv	a1,s1
  800306:	0405                	addi	s0,s0,1
  800308:	9982                	jalr	s3
  80030a:	fff44503          	lbu	a0,-1(s0)
  80030e:	ff4519e3          	bne	a0,s4,800300 <vprintfmt+0x40>
  800312:	00044583          	lbu	a1,0(s0)
  800316:	02000813          	li	a6,32
  80031a:	4d01                	li	s10,0
  80031c:	4301                	li	t1,0
  80031e:	5cfd                	li	s9,-1
  800320:	5c7d                	li	s8,-1
  800322:	05500513          	li	a0,85
  800326:	48a5                	li	a7,9
  800328:	fdd5861b          	addiw	a2,a1,-35
  80032c:	0ff67613          	zext.b	a2,a2
  800330:	00140d93          	addi	s11,s0,1
  800334:	04c56263          	bltu	a0,a2,800378 <vprintfmt+0xb8>
  800338:	060a                	slli	a2,a2,0x2
  80033a:	965a                	add	a2,a2,s6
  80033c:	4214                	lw	a3,0(a2)
  80033e:	96da                	add	a3,a3,s6
  800340:	8682                	jr	a3
  800342:	70e6                	ld	ra,120(sp)
  800344:	7446                	ld	s0,112(sp)
  800346:	74a6                	ld	s1,104(sp)
  800348:	7906                	ld	s2,96(sp)
  80034a:	69e6                	ld	s3,88(sp)
  80034c:	6a46                	ld	s4,80(sp)
  80034e:	6aa6                	ld	s5,72(sp)
  800350:	6b06                	ld	s6,64(sp)
  800352:	7be2                	ld	s7,56(sp)
  800354:	7c42                	ld	s8,48(sp)
  800356:	7ca2                	ld	s9,40(sp)
  800358:	7d02                	ld	s10,32(sp)
  80035a:	6de2                	ld	s11,24(sp)
  80035c:	6109                	addi	sp,sp,128
  80035e:	8082                	ret
  800360:	882e                	mv	a6,a1
  800362:	00144583          	lbu	a1,1(s0)
  800366:	846e                	mv	s0,s11
  800368:	00140d93          	addi	s11,s0,1
  80036c:	fdd5861b          	addiw	a2,a1,-35
  800370:	0ff67613          	zext.b	a2,a2
  800374:	fcc572e3          	bgeu	a0,a2,800338 <vprintfmt+0x78>
  800378:	864a                	mv	a2,s2
  80037a:	85a6                	mv	a1,s1
  80037c:	02500513          	li	a0,37
  800380:	9982                	jalr	s3
  800382:	fff44783          	lbu	a5,-1(s0)
  800386:	8da2                	mv	s11,s0
  800388:	f74786e3          	beq	a5,s4,8002f4 <vprintfmt+0x34>
  80038c:	ffedc783          	lbu	a5,-2(s11)
  800390:	1dfd                	addi	s11,s11,-1
  800392:	ff479de3          	bne	a5,s4,80038c <vprintfmt+0xcc>
  800396:	bfb9                	j	8002f4 <vprintfmt+0x34>
  800398:	fd058c9b          	addiw	s9,a1,-48
  80039c:	00144583          	lbu	a1,1(s0)
  8003a0:	846e                	mv	s0,s11
  8003a2:	fd05869b          	addiw	a3,a1,-48
  8003a6:	0005861b          	sext.w	a2,a1
  8003aa:	02d8e463          	bltu	a7,a3,8003d2 <vprintfmt+0x112>
  8003ae:	00144583          	lbu	a1,1(s0)
  8003b2:	002c969b          	slliw	a3,s9,0x2
  8003b6:	0196873b          	addw	a4,a3,s9
  8003ba:	0017171b          	slliw	a4,a4,0x1
  8003be:	9f31                	addw	a4,a4,a2
  8003c0:	fd05869b          	addiw	a3,a1,-48
  8003c4:	0405                	addi	s0,s0,1
  8003c6:	fd070c9b          	addiw	s9,a4,-48
  8003ca:	0005861b          	sext.w	a2,a1
  8003ce:	fed8f0e3          	bgeu	a7,a3,8003ae <vprintfmt+0xee>
  8003d2:	f40c5be3          	bgez	s8,800328 <vprintfmt+0x68>
  8003d6:	8c66                	mv	s8,s9
  8003d8:	5cfd                	li	s9,-1
  8003da:	b7b9                	j	800328 <vprintfmt+0x68>
  8003dc:	fffc4693          	not	a3,s8
  8003e0:	96fd                	srai	a3,a3,0x3f
  8003e2:	00dc77b3          	and	a5,s8,a3
  8003e6:	00144583          	lbu	a1,1(s0)
  8003ea:	00078c1b          	sext.w	s8,a5
  8003ee:	846e                	mv	s0,s11
  8003f0:	bf25                	j	800328 <vprintfmt+0x68>
  8003f2:	000aac83          	lw	s9,0(s5)
  8003f6:	00144583          	lbu	a1,1(s0)
  8003fa:	0aa1                	addi	s5,s5,8
  8003fc:	846e                	mv	s0,s11
  8003fe:	bfd1                	j	8003d2 <vprintfmt+0x112>
  800400:	4705                	li	a4,1
  800402:	008a8613          	addi	a2,s5,8
  800406:	00674463          	blt	a4,t1,80040e <vprintfmt+0x14e>
  80040a:	1c030c63          	beqz	t1,8005e2 <vprintfmt+0x322>
  80040e:	000ab683          	ld	a3,0(s5)
  800412:	4741                	li	a4,16
  800414:	8ab2                	mv	s5,a2
  800416:	2801                	sext.w	a6,a6
  800418:	87e2                	mv	a5,s8
  80041a:	8626                	mv	a2,s1
  80041c:	85ca                	mv	a1,s2
  80041e:	854e                	mv	a0,s3
  800420:	e11ff0ef          	jal	ra,800230 <printnum>
  800424:	bdc1                	j	8002f4 <vprintfmt+0x34>
  800426:	000aa503          	lw	a0,0(s5)
  80042a:	864a                	mv	a2,s2
  80042c:	85a6                	mv	a1,s1
  80042e:	0aa1                	addi	s5,s5,8
  800430:	9982                	jalr	s3
  800432:	b5c9                	j	8002f4 <vprintfmt+0x34>
  800434:	4705                	li	a4,1
  800436:	008a8613          	addi	a2,s5,8
  80043a:	00674463          	blt	a4,t1,800442 <vprintfmt+0x182>
  80043e:	18030d63          	beqz	t1,8005d8 <vprintfmt+0x318>
  800442:	000ab683          	ld	a3,0(s5)
  800446:	4729                	li	a4,10
  800448:	8ab2                	mv	s5,a2
  80044a:	b7f1                	j	800416 <vprintfmt+0x156>
  80044c:	00144583          	lbu	a1,1(s0)
  800450:	4d05                	li	s10,1
  800452:	846e                	mv	s0,s11
  800454:	bdd1                	j	800328 <vprintfmt+0x68>
  800456:	864a                	mv	a2,s2
  800458:	85a6                	mv	a1,s1
  80045a:	02500513          	li	a0,37
  80045e:	9982                	jalr	s3
  800460:	bd51                	j	8002f4 <vprintfmt+0x34>
  800462:	00144583          	lbu	a1,1(s0)
  800466:	2305                	addiw	t1,t1,1
  800468:	846e                	mv	s0,s11
  80046a:	bd7d                	j	800328 <vprintfmt+0x68>
  80046c:	4705                	li	a4,1
  80046e:	008a8613          	addi	a2,s5,8
  800472:	00674463          	blt	a4,t1,80047a <vprintfmt+0x1ba>
  800476:	14030c63          	beqz	t1,8005ce <vprintfmt+0x30e>
  80047a:	000ab683          	ld	a3,0(s5)
  80047e:	4721                	li	a4,8
  800480:	8ab2                	mv	s5,a2
  800482:	bf51                	j	800416 <vprintfmt+0x156>
  800484:	03000513          	li	a0,48
  800488:	864a                	mv	a2,s2
  80048a:	85a6                	mv	a1,s1
  80048c:	e042                	sd	a6,0(sp)
  80048e:	9982                	jalr	s3
  800490:	864a                	mv	a2,s2
  800492:	85a6                	mv	a1,s1
  800494:	07800513          	li	a0,120
  800498:	9982                	jalr	s3
  80049a:	0aa1                	addi	s5,s5,8
  80049c:	6802                	ld	a6,0(sp)
  80049e:	4741                	li	a4,16
  8004a0:	ff8ab683          	ld	a3,-8(s5)
  8004a4:	bf8d                	j	800416 <vprintfmt+0x156>
  8004a6:	000ab403          	ld	s0,0(s5)
  8004aa:	008a8793          	addi	a5,s5,8
  8004ae:	e03e                	sd	a5,0(sp)
  8004b0:	14040c63          	beqz	s0,800608 <vprintfmt+0x348>
  8004b4:	11805063          	blez	s8,8005b4 <vprintfmt+0x2f4>
  8004b8:	02d00693          	li	a3,45
  8004bc:	0cd81963          	bne	a6,a3,80058e <vprintfmt+0x2ce>
  8004c0:	00044683          	lbu	a3,0(s0)
  8004c4:	0006851b          	sext.w	a0,a3
  8004c8:	ce8d                	beqz	a3,800502 <vprintfmt+0x242>
  8004ca:	00140a93          	addi	s5,s0,1
  8004ce:	05e00413          	li	s0,94
  8004d2:	000cc563          	bltz	s9,8004dc <vprintfmt+0x21c>
  8004d6:	3cfd                	addiw	s9,s9,-1
  8004d8:	037c8363          	beq	s9,s7,8004fe <vprintfmt+0x23e>
  8004dc:	864a                	mv	a2,s2
  8004de:	85a6                	mv	a1,s1
  8004e0:	100d0663          	beqz	s10,8005ec <vprintfmt+0x32c>
  8004e4:	3681                	addiw	a3,a3,-32
  8004e6:	10d47363          	bgeu	s0,a3,8005ec <vprintfmt+0x32c>
  8004ea:	03f00513          	li	a0,63
  8004ee:	9982                	jalr	s3
  8004f0:	000ac683          	lbu	a3,0(s5)
  8004f4:	3c7d                	addiw	s8,s8,-1
  8004f6:	0a85                	addi	s5,s5,1
  8004f8:	0006851b          	sext.w	a0,a3
  8004fc:	faf9                	bnez	a3,8004d2 <vprintfmt+0x212>
  8004fe:	01805a63          	blez	s8,800512 <vprintfmt+0x252>
  800502:	3c7d                	addiw	s8,s8,-1
  800504:	864a                	mv	a2,s2
  800506:	85a6                	mv	a1,s1
  800508:	02000513          	li	a0,32
  80050c:	9982                	jalr	s3
  80050e:	fe0c1ae3          	bnez	s8,800502 <vprintfmt+0x242>
  800512:	6a82                	ld	s5,0(sp)
  800514:	b3c5                	j	8002f4 <vprintfmt+0x34>
  800516:	4705                	li	a4,1
  800518:	008a8d13          	addi	s10,s5,8
  80051c:	00674463          	blt	a4,t1,800524 <vprintfmt+0x264>
  800520:	0a030463          	beqz	t1,8005c8 <vprintfmt+0x308>
  800524:	000ab403          	ld	s0,0(s5)
  800528:	0c044463          	bltz	s0,8005f0 <vprintfmt+0x330>
  80052c:	86a2                	mv	a3,s0
  80052e:	8aea                	mv	s5,s10
  800530:	4729                	li	a4,10
  800532:	b5d5                	j	800416 <vprintfmt+0x156>
  800534:	000aa783          	lw	a5,0(s5)
  800538:	46e1                	li	a3,24
  80053a:	0aa1                	addi	s5,s5,8
  80053c:	41f7d71b          	sraiw	a4,a5,0x1f
  800540:	8fb9                	xor	a5,a5,a4
  800542:	40e7873b          	subw	a4,a5,a4
  800546:	02e6c663          	blt	a3,a4,800572 <vprintfmt+0x2b2>
  80054a:	00371793          	slli	a5,a4,0x3
  80054e:	00000697          	auipc	a3,0x0
  800552:	68a68693          	addi	a3,a3,1674 # 800bd8 <error_string>
  800556:	97b6                	add	a5,a5,a3
  800558:	639c                	ld	a5,0(a5)
  80055a:	cf81                	beqz	a5,800572 <vprintfmt+0x2b2>
  80055c:	873e                	mv	a4,a5
  80055e:	00000697          	auipc	a3,0x0
  800562:	34268693          	addi	a3,a3,834 # 8008a0 <main+0x10e>
  800566:	8626                	mv	a2,s1
  800568:	85ca                	mv	a1,s2
  80056a:	854e                	mv	a0,s3
  80056c:	0d4000ef          	jal	ra,800640 <printfmt>
  800570:	b351                	j	8002f4 <vprintfmt+0x34>
  800572:	00000697          	auipc	a3,0x0
  800576:	31e68693          	addi	a3,a3,798 # 800890 <main+0xfe>
  80057a:	8626                	mv	a2,s1
  80057c:	85ca                	mv	a1,s2
  80057e:	854e                	mv	a0,s3
  800580:	0c0000ef          	jal	ra,800640 <printfmt>
  800584:	bb85                	j	8002f4 <vprintfmt+0x34>
  800586:	00000417          	auipc	s0,0x0
  80058a:	30240413          	addi	s0,s0,770 # 800888 <main+0xf6>
  80058e:	85e6                	mv	a1,s9
  800590:	8522                	mv	a0,s0
  800592:	e442                	sd	a6,8(sp)
  800594:	132000ef          	jal	ra,8006c6 <strnlen>
  800598:	40ac0c3b          	subw	s8,s8,a0
  80059c:	01805c63          	blez	s8,8005b4 <vprintfmt+0x2f4>
  8005a0:	6822                	ld	a6,8(sp)
  8005a2:	00080a9b          	sext.w	s5,a6
  8005a6:	3c7d                	addiw	s8,s8,-1
  8005a8:	864a                	mv	a2,s2
  8005aa:	85a6                	mv	a1,s1
  8005ac:	8556                	mv	a0,s5
  8005ae:	9982                	jalr	s3
  8005b0:	fe0c1be3          	bnez	s8,8005a6 <vprintfmt+0x2e6>
  8005b4:	00044683          	lbu	a3,0(s0)
  8005b8:	00140a93          	addi	s5,s0,1
  8005bc:	0006851b          	sext.w	a0,a3
  8005c0:	daa9                	beqz	a3,800512 <vprintfmt+0x252>
  8005c2:	05e00413          	li	s0,94
  8005c6:	b731                	j	8004d2 <vprintfmt+0x212>
  8005c8:	000aa403          	lw	s0,0(s5)
  8005cc:	bfb1                	j	800528 <vprintfmt+0x268>
  8005ce:	000ae683          	lwu	a3,0(s5)
  8005d2:	4721                	li	a4,8
  8005d4:	8ab2                	mv	s5,a2
  8005d6:	b581                	j	800416 <vprintfmt+0x156>
  8005d8:	000ae683          	lwu	a3,0(s5)
  8005dc:	4729                	li	a4,10
  8005de:	8ab2                	mv	s5,a2
  8005e0:	bd1d                	j	800416 <vprintfmt+0x156>
  8005e2:	000ae683          	lwu	a3,0(s5)
  8005e6:	4741                	li	a4,16
  8005e8:	8ab2                	mv	s5,a2
  8005ea:	b535                	j	800416 <vprintfmt+0x156>
  8005ec:	9982                	jalr	s3
  8005ee:	b709                	j	8004f0 <vprintfmt+0x230>
  8005f0:	864a                	mv	a2,s2
  8005f2:	85a6                	mv	a1,s1
  8005f4:	02d00513          	li	a0,45
  8005f8:	e042                	sd	a6,0(sp)
  8005fa:	9982                	jalr	s3
  8005fc:	6802                	ld	a6,0(sp)
  8005fe:	8aea                	mv	s5,s10
  800600:	408006b3          	neg	a3,s0
  800604:	4729                	li	a4,10
  800606:	bd01                	j	800416 <vprintfmt+0x156>
  800608:	03805163          	blez	s8,80062a <vprintfmt+0x36a>
  80060c:	02d00693          	li	a3,45
  800610:	f6d81be3          	bne	a6,a3,800586 <vprintfmt+0x2c6>
  800614:	00000417          	auipc	s0,0x0
  800618:	27440413          	addi	s0,s0,628 # 800888 <main+0xf6>
  80061c:	02800693          	li	a3,40
  800620:	02800513          	li	a0,40
  800624:	00140a93          	addi	s5,s0,1
  800628:	b55d                	j	8004ce <vprintfmt+0x20e>
  80062a:	00000a97          	auipc	s5,0x0
  80062e:	25fa8a93          	addi	s5,s5,607 # 800889 <main+0xf7>
  800632:	02800513          	li	a0,40
  800636:	02800693          	li	a3,40
  80063a:	05e00413          	li	s0,94
  80063e:	bd51                	j	8004d2 <vprintfmt+0x212>

0000000000800640 <printfmt>:
  800640:	7139                	addi	sp,sp,-64
  800642:	02010313          	addi	t1,sp,32
  800646:	f03a                	sd	a4,32(sp)
  800648:	871a                	mv	a4,t1
  80064a:	ec06                	sd	ra,24(sp)
  80064c:	f43e                	sd	a5,40(sp)
  80064e:	f842                	sd	a6,48(sp)
  800650:	fc46                	sd	a7,56(sp)
  800652:	e41a                	sd	t1,8(sp)
  800654:	c6dff0ef          	jal	ra,8002c0 <vprintfmt>
  800658:	60e2                	ld	ra,24(sp)
  80065a:	6121                	addi	sp,sp,64
  80065c:	8082                	ret

000000000080065e <snprintf>:
  80065e:	711d                	addi	sp,sp,-96
  800660:	15fd                	addi	a1,a1,-1
  800662:	03810313          	addi	t1,sp,56
  800666:	95aa                	add	a1,a1,a0
  800668:	f406                	sd	ra,40(sp)
  80066a:	fc36                	sd	a3,56(sp)
  80066c:	e0ba                	sd	a4,64(sp)
  80066e:	e4be                	sd	a5,72(sp)
  800670:	e8c2                	sd	a6,80(sp)
  800672:	ecc6                	sd	a7,88(sp)
  800674:	e01a                	sd	t1,0(sp)
  800676:	e42a                	sd	a0,8(sp)
  800678:	e82e                	sd	a1,16(sp)
  80067a:	cc02                	sw	zero,24(sp)
  80067c:	c515                	beqz	a0,8006a8 <snprintf+0x4a>
  80067e:	02a5e563          	bltu	a1,a0,8006a8 <snprintf+0x4a>
  800682:	75dd                	lui	a1,0xffff7
  800684:	86b2                	mv	a3,a2
  800686:	00000517          	auipc	a0,0x0
  80068a:	c2050513          	addi	a0,a0,-992 # 8002a6 <sprintputch>
  80068e:	871a                	mv	a4,t1
  800690:	0030                	addi	a2,sp,8
  800692:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f01>
  800696:	c2bff0ef          	jal	ra,8002c0 <vprintfmt>
  80069a:	67a2                	ld	a5,8(sp)
  80069c:	00078023          	sb	zero,0(a5)
  8006a0:	4562                	lw	a0,24(sp)
  8006a2:	70a2                	ld	ra,40(sp)
  8006a4:	6125                	addi	sp,sp,96
  8006a6:	8082                	ret
  8006a8:	5575                	li	a0,-3
  8006aa:	bfe5                	j	8006a2 <snprintf+0x44>

00000000008006ac <strlen>:
  8006ac:	00054783          	lbu	a5,0(a0)
  8006b0:	872a                	mv	a4,a0
  8006b2:	4501                	li	a0,0
  8006b4:	cb81                	beqz	a5,8006c4 <strlen+0x18>
  8006b6:	0505                	addi	a0,a0,1
  8006b8:	00a707b3          	add	a5,a4,a0
  8006bc:	0007c783          	lbu	a5,0(a5)
  8006c0:	fbfd                	bnez	a5,8006b6 <strlen+0xa>
  8006c2:	8082                	ret
  8006c4:	8082                	ret

00000000008006c6 <strnlen>:
  8006c6:	4781                	li	a5,0
  8006c8:	e589                	bnez	a1,8006d2 <strnlen+0xc>
  8006ca:	a811                	j	8006de <strnlen+0x18>
  8006cc:	0785                	addi	a5,a5,1
  8006ce:	00f58863          	beq	a1,a5,8006de <strnlen+0x18>
  8006d2:	00f50733          	add	a4,a0,a5
  8006d6:	00074703          	lbu	a4,0(a4)
  8006da:	fb6d                	bnez	a4,8006cc <strnlen+0x6>
  8006dc:	85be                	mv	a1,a5
  8006de:	852e                	mv	a0,a1
  8006e0:	8082                	ret

00000000008006e2 <forktree>:
  8006e2:	1101                	addi	sp,sp,-32
  8006e4:	ec06                	sd	ra,24(sp)
  8006e6:	e822                	sd	s0,16(sp)
  8006e8:	842a                	mv	s0,a0
  8006ea:	a8dff0ef          	jal	ra,800176 <getpid>
  8006ee:	85aa                	mv	a1,a0
  8006f0:	8622                	mv	a2,s0
  8006f2:	00000517          	auipc	a0,0x0
  8006f6:	5ae50513          	addi	a0,a0,1454 # 800ca0 <error_string+0xc8>
  8006fa:	9bbff0ef          	jal	ra,8000b4 <cprintf>
  8006fe:	03000593          	li	a1,48
  800702:	8522                	mv	a0,s0
  800704:	044000ef          	jal	ra,800748 <forkchild>
  800708:	8522                	mv	a0,s0
  80070a:	fa3ff0ef          	jal	ra,8006ac <strlen>
  80070e:	4789                	li	a5,2
  800710:	00a7f663          	bgeu	a5,a0,80071c <forktree+0x3a>
  800714:	60e2                	ld	ra,24(sp)
  800716:	6442                	ld	s0,16(sp)
  800718:	6105                	addi	sp,sp,32
  80071a:	8082                	ret
  80071c:	03100713          	li	a4,49
  800720:	86a2                	mv	a3,s0
  800722:	00000617          	auipc	a2,0x0
  800726:	59660613          	addi	a2,a2,1430 # 800cb8 <error_string+0xe0>
  80072a:	4591                	li	a1,4
  80072c:	0028                	addi	a0,sp,8
  80072e:	f31ff0ef          	jal	ra,80065e <snprintf>
  800732:	a41ff0ef          	jal	ra,800172 <fork>
  800736:	fd79                	bnez	a0,800714 <forktree+0x32>
  800738:	0028                	addi	a0,sp,8
  80073a:	fa9ff0ef          	jal	ra,8006e2 <forktree>
  80073e:	a37ff0ef          	jal	ra,800174 <yield>
  800742:	4501                	li	a0,0
  800744:	a19ff0ef          	jal	ra,80015c <exit>

0000000000800748 <forkchild>:
  800748:	7179                	addi	sp,sp,-48
  80074a:	f022                	sd	s0,32(sp)
  80074c:	ec26                	sd	s1,24(sp)
  80074e:	f406                	sd	ra,40(sp)
  800750:	842a                	mv	s0,a0
  800752:	84ae                	mv	s1,a1
  800754:	f59ff0ef          	jal	ra,8006ac <strlen>
  800758:	4789                	li	a5,2
  80075a:	00a7f763          	bgeu	a5,a0,800768 <forkchild+0x20>
  80075e:	70a2                	ld	ra,40(sp)
  800760:	7402                	ld	s0,32(sp)
  800762:	64e2                	ld	s1,24(sp)
  800764:	6145                	addi	sp,sp,48
  800766:	8082                	ret
  800768:	8726                	mv	a4,s1
  80076a:	86a2                	mv	a3,s0
  80076c:	00000617          	auipc	a2,0x0
  800770:	54c60613          	addi	a2,a2,1356 # 800cb8 <error_string+0xe0>
  800774:	4591                	li	a1,4
  800776:	0028                	addi	a0,sp,8
  800778:	ee7ff0ef          	jal	ra,80065e <snprintf>
  80077c:	9f7ff0ef          	jal	ra,800172 <fork>
  800780:	fd79                	bnez	a0,80075e <forkchild+0x16>
  800782:	0028                	addi	a0,sp,8
  800784:	f5fff0ef          	jal	ra,8006e2 <forktree>
  800788:	9edff0ef          	jal	ra,800174 <yield>
  80078c:	4501                	li	a0,0
  80078e:	9cfff0ef          	jal	ra,80015c <exit>

0000000000800792 <main>:
  800792:	1141                	addi	sp,sp,-16
  800794:	00000517          	auipc	a0,0x0
  800798:	51c50513          	addi	a0,a0,1308 # 800cb0 <error_string+0xd8>
  80079c:	e406                	sd	ra,8(sp)
  80079e:	f45ff0ef          	jal	ra,8006e2 <forktree>
  8007a2:	60a2                	ld	ra,8(sp)
  8007a4:	4501                	li	a0,0
  8007a6:	0141                	addi	sp,sp,16
  8007a8:	8082                	ret
