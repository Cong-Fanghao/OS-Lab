
obj/__user_badarg.out:     file format elf64-littleriscv


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
  80002a:	1d8000ef          	jal	ra,800202 <umain>
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
  800044:	75850513          	addi	a0,a0,1880 # 800798 <main+0xf2>
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
  800064:	7b050513          	addi	a0,a0,1968 # 800810 <main+0x16a>
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
  800086:	73650513          	addi	a0,a0,1846 # 8007b8 <main+0x112>
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
  8000a6:	76e50513          	addi	a0,a0,1902 # 800810 <main+0x16a>
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
  8000be:	0c2000ef          	jal	ra,800180 <sys_putc>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f19>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	202000ef          	jal	ra,8002ec <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f19>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1c6000ef          	jal	ra,8002ec <vprintfmt>
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

0000000000800180 <sys_putc>:
  800180:	85aa                	mv	a1,a0
  800182:	4579                	li	a0,30
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
  8001ae:	62e50513          	addi	a0,a0,1582 # 8007d8 <main+0x132>
  8001b2:	f45ff0ef          	jal	ra,8000f6 <cprintf>
  8001b6:	a001                	j	8001b6 <exit+0x14>

00000000008001b8 <fork>:
  8001b8:	bf65                	j	800170 <sys_fork>

00000000008001ba <waitpid>:
  8001ba:	bf6d                	j	800174 <sys_wait>

00000000008001bc <yield>:
  8001bc:	b7c1                	j	80017c <sys_yield>

00000000008001be <initfd>:
  8001be:	1101                	addi	sp,sp,-32
  8001c0:	87ae                	mv	a5,a1
  8001c2:	e426                	sd	s1,8(sp)
  8001c4:	85b2                	mv	a1,a2
  8001c6:	84aa                	mv	s1,a0
  8001c8:	853e                	mv	a0,a5
  8001ca:	e822                	sd	s0,16(sp)
  8001cc:	ec06                	sd	ra,24(sp)
  8001ce:	e53ff0ef          	jal	ra,800020 <open>
  8001d2:	842a                	mv	s0,a0
  8001d4:	00054463          	bltz	a0,8001dc <initfd+0x1e>
  8001d8:	00951863          	bne	a0,s1,8001e8 <initfd+0x2a>
  8001dc:	60e2                	ld	ra,24(sp)
  8001de:	8522                	mv	a0,s0
  8001e0:	6442                	ld	s0,16(sp)
  8001e2:	64a2                	ld	s1,8(sp)
  8001e4:	6105                	addi	sp,sp,32
  8001e6:	8082                	ret
  8001e8:	8526                	mv	a0,s1
  8001ea:	e3dff0ef          	jal	ra,800026 <close>
  8001ee:	85a6                	mv	a1,s1
  8001f0:	8522                	mv	a0,s0
  8001f2:	e37ff0ef          	jal	ra,800028 <dup2>
  8001f6:	84aa                	mv	s1,a0
  8001f8:	8522                	mv	a0,s0
  8001fa:	e2dff0ef          	jal	ra,800026 <close>
  8001fe:	8426                	mv	s0,s1
  800200:	bff1                	j	8001dc <initfd+0x1e>

0000000000800202 <umain>:
  800202:	1101                	addi	sp,sp,-32
  800204:	e822                	sd	s0,16(sp)
  800206:	e426                	sd	s1,8(sp)
  800208:	842a                	mv	s0,a0
  80020a:	84ae                	mv	s1,a1
  80020c:	4601                	li	a2,0
  80020e:	00000597          	auipc	a1,0x0
  800212:	5e258593          	addi	a1,a1,1506 # 8007f0 <main+0x14a>
  800216:	4501                	li	a0,0
  800218:	ec06                	sd	ra,24(sp)
  80021a:	fa5ff0ef          	jal	ra,8001be <initfd>
  80021e:	02054263          	bltz	a0,800242 <umain+0x40>
  800222:	4605                	li	a2,1
  800224:	00000597          	auipc	a1,0x0
  800228:	60c58593          	addi	a1,a1,1548 # 800830 <main+0x18a>
  80022c:	4505                	li	a0,1
  80022e:	f91ff0ef          	jal	ra,8001be <initfd>
  800232:	02054563          	bltz	a0,80025c <umain+0x5a>
  800236:	85a6                	mv	a1,s1
  800238:	8522                	mv	a0,s0
  80023a:	46c000ef          	jal	ra,8006a6 <main>
  80023e:	f65ff0ef          	jal	ra,8001a2 <exit>
  800242:	86aa                	mv	a3,a0
  800244:	00000617          	auipc	a2,0x0
  800248:	5b460613          	addi	a2,a2,1460 # 8007f8 <main+0x152>
  80024c:	45e9                	li	a1,26
  80024e:	00000517          	auipc	a0,0x0
  800252:	5ca50513          	addi	a0,a0,1482 # 800818 <main+0x172>
  800256:	e1dff0ef          	jal	ra,800072 <__warn>
  80025a:	b7e1                	j	800222 <umain+0x20>
  80025c:	86aa                	mv	a3,a0
  80025e:	00000617          	auipc	a2,0x0
  800262:	5da60613          	addi	a2,a2,1498 # 800838 <main+0x192>
  800266:	45f5                	li	a1,29
  800268:	00000517          	auipc	a0,0x0
  80026c:	5b050513          	addi	a0,a0,1456 # 800818 <main+0x172>
  800270:	e03ff0ef          	jal	ra,800072 <__warn>
  800274:	b7c9                	j	800236 <umain+0x34>

0000000000800276 <printnum>:
  800276:	02071893          	slli	a7,a4,0x20
  80027a:	7139                	addi	sp,sp,-64
  80027c:	0208d893          	srli	a7,a7,0x20
  800280:	e456                	sd	s5,8(sp)
  800282:	0316fab3          	remu	s5,a3,a7
  800286:	f822                	sd	s0,48(sp)
  800288:	f426                	sd	s1,40(sp)
  80028a:	f04a                	sd	s2,32(sp)
  80028c:	ec4e                	sd	s3,24(sp)
  80028e:	fc06                	sd	ra,56(sp)
  800290:	e852                	sd	s4,16(sp)
  800292:	84aa                	mv	s1,a0
  800294:	89ae                	mv	s3,a1
  800296:	8932                	mv	s2,a2
  800298:	fff7841b          	addiw	s0,a5,-1
  80029c:	2a81                	sext.w	s5,s5
  80029e:	0516f163          	bgeu	a3,a7,8002e0 <printnum+0x6a>
  8002a2:	8a42                	mv	s4,a6
  8002a4:	00805863          	blez	s0,8002b4 <printnum+0x3e>
  8002a8:	347d                	addiw	s0,s0,-1
  8002aa:	864e                	mv	a2,s3
  8002ac:	85ca                	mv	a1,s2
  8002ae:	8552                	mv	a0,s4
  8002b0:	9482                	jalr	s1
  8002b2:	f87d                	bnez	s0,8002a8 <printnum+0x32>
  8002b4:	1a82                	slli	s5,s5,0x20
  8002b6:	00000797          	auipc	a5,0x0
  8002ba:	5a278793          	addi	a5,a5,1442 # 800858 <main+0x1b2>
  8002be:	020ada93          	srli	s5,s5,0x20
  8002c2:	9abe                	add	s5,s5,a5
  8002c4:	7442                	ld	s0,48(sp)
  8002c6:	000ac503          	lbu	a0,0(s5)
  8002ca:	70e2                	ld	ra,56(sp)
  8002cc:	6a42                	ld	s4,16(sp)
  8002ce:	6aa2                	ld	s5,8(sp)
  8002d0:	864e                	mv	a2,s3
  8002d2:	85ca                	mv	a1,s2
  8002d4:	69e2                	ld	s3,24(sp)
  8002d6:	7902                	ld	s2,32(sp)
  8002d8:	87a6                	mv	a5,s1
  8002da:	74a2                	ld	s1,40(sp)
  8002dc:	6121                	addi	sp,sp,64
  8002de:	8782                	jr	a5
  8002e0:	0316d6b3          	divu	a3,a3,a7
  8002e4:	87a2                	mv	a5,s0
  8002e6:	f91ff0ef          	jal	ra,800276 <printnum>
  8002ea:	b7e9                	j	8002b4 <printnum+0x3e>

00000000008002ec <vprintfmt>:
  8002ec:	7119                	addi	sp,sp,-128
  8002ee:	f4a6                	sd	s1,104(sp)
  8002f0:	f0ca                	sd	s2,96(sp)
  8002f2:	ecce                	sd	s3,88(sp)
  8002f4:	e8d2                	sd	s4,80(sp)
  8002f6:	e4d6                	sd	s5,72(sp)
  8002f8:	e0da                	sd	s6,64(sp)
  8002fa:	fc5e                	sd	s7,56(sp)
  8002fc:	ec6e                	sd	s11,24(sp)
  8002fe:	fc86                	sd	ra,120(sp)
  800300:	f8a2                	sd	s0,112(sp)
  800302:	f862                	sd	s8,48(sp)
  800304:	f466                	sd	s9,40(sp)
  800306:	f06a                	sd	s10,32(sp)
  800308:	89aa                	mv	s3,a0
  80030a:	892e                	mv	s2,a1
  80030c:	84b2                	mv	s1,a2
  80030e:	8db6                	mv	s11,a3
  800310:	8aba                	mv	s5,a4
  800312:	02500a13          	li	s4,37
  800316:	5bfd                	li	s7,-1
  800318:	00000b17          	auipc	s6,0x0
  80031c:	574b0b13          	addi	s6,s6,1396 # 80088c <main+0x1e6>
  800320:	000dc503          	lbu	a0,0(s11)
  800324:	001d8413          	addi	s0,s11,1
  800328:	01450b63          	beq	a0,s4,80033e <vprintfmt+0x52>
  80032c:	c129                	beqz	a0,80036e <vprintfmt+0x82>
  80032e:	864a                	mv	a2,s2
  800330:	85a6                	mv	a1,s1
  800332:	0405                	addi	s0,s0,1
  800334:	9982                	jalr	s3
  800336:	fff44503          	lbu	a0,-1(s0)
  80033a:	ff4519e3          	bne	a0,s4,80032c <vprintfmt+0x40>
  80033e:	00044583          	lbu	a1,0(s0)
  800342:	02000813          	li	a6,32
  800346:	4d01                	li	s10,0
  800348:	4301                	li	t1,0
  80034a:	5cfd                	li	s9,-1
  80034c:	5c7d                	li	s8,-1
  80034e:	05500513          	li	a0,85
  800352:	48a5                	li	a7,9
  800354:	fdd5861b          	addiw	a2,a1,-35
  800358:	0ff67613          	zext.b	a2,a2
  80035c:	00140d93          	addi	s11,s0,1
  800360:	04c56263          	bltu	a0,a2,8003a4 <vprintfmt+0xb8>
  800364:	060a                	slli	a2,a2,0x2
  800366:	965a                	add	a2,a2,s6
  800368:	4214                	lw	a3,0(a2)
  80036a:	96da                	add	a3,a3,s6
  80036c:	8682                	jr	a3
  80036e:	70e6                	ld	ra,120(sp)
  800370:	7446                	ld	s0,112(sp)
  800372:	74a6                	ld	s1,104(sp)
  800374:	7906                	ld	s2,96(sp)
  800376:	69e6                	ld	s3,88(sp)
  800378:	6a46                	ld	s4,80(sp)
  80037a:	6aa6                	ld	s5,72(sp)
  80037c:	6b06                	ld	s6,64(sp)
  80037e:	7be2                	ld	s7,56(sp)
  800380:	7c42                	ld	s8,48(sp)
  800382:	7ca2                	ld	s9,40(sp)
  800384:	7d02                	ld	s10,32(sp)
  800386:	6de2                	ld	s11,24(sp)
  800388:	6109                	addi	sp,sp,128
  80038a:	8082                	ret
  80038c:	882e                	mv	a6,a1
  80038e:	00144583          	lbu	a1,1(s0)
  800392:	846e                	mv	s0,s11
  800394:	00140d93          	addi	s11,s0,1
  800398:	fdd5861b          	addiw	a2,a1,-35
  80039c:	0ff67613          	zext.b	a2,a2
  8003a0:	fcc572e3          	bgeu	a0,a2,800364 <vprintfmt+0x78>
  8003a4:	864a                	mv	a2,s2
  8003a6:	85a6                	mv	a1,s1
  8003a8:	02500513          	li	a0,37
  8003ac:	9982                	jalr	s3
  8003ae:	fff44783          	lbu	a5,-1(s0)
  8003b2:	8da2                	mv	s11,s0
  8003b4:	f74786e3          	beq	a5,s4,800320 <vprintfmt+0x34>
  8003b8:	ffedc783          	lbu	a5,-2(s11)
  8003bc:	1dfd                	addi	s11,s11,-1
  8003be:	ff479de3          	bne	a5,s4,8003b8 <vprintfmt+0xcc>
  8003c2:	bfb9                	j	800320 <vprintfmt+0x34>
  8003c4:	fd058c9b          	addiw	s9,a1,-48
  8003c8:	00144583          	lbu	a1,1(s0)
  8003cc:	846e                	mv	s0,s11
  8003ce:	fd05869b          	addiw	a3,a1,-48
  8003d2:	0005861b          	sext.w	a2,a1
  8003d6:	02d8e463          	bltu	a7,a3,8003fe <vprintfmt+0x112>
  8003da:	00144583          	lbu	a1,1(s0)
  8003de:	002c969b          	slliw	a3,s9,0x2
  8003e2:	0196873b          	addw	a4,a3,s9
  8003e6:	0017171b          	slliw	a4,a4,0x1
  8003ea:	9f31                	addw	a4,a4,a2
  8003ec:	fd05869b          	addiw	a3,a1,-48
  8003f0:	0405                	addi	s0,s0,1
  8003f2:	fd070c9b          	addiw	s9,a4,-48
  8003f6:	0005861b          	sext.w	a2,a1
  8003fa:	fed8f0e3          	bgeu	a7,a3,8003da <vprintfmt+0xee>
  8003fe:	f40c5be3          	bgez	s8,800354 <vprintfmt+0x68>
  800402:	8c66                	mv	s8,s9
  800404:	5cfd                	li	s9,-1
  800406:	b7b9                	j	800354 <vprintfmt+0x68>
  800408:	fffc4693          	not	a3,s8
  80040c:	96fd                	srai	a3,a3,0x3f
  80040e:	00dc77b3          	and	a5,s8,a3
  800412:	00144583          	lbu	a1,1(s0)
  800416:	00078c1b          	sext.w	s8,a5
  80041a:	846e                	mv	s0,s11
  80041c:	bf25                	j	800354 <vprintfmt+0x68>
  80041e:	000aac83          	lw	s9,0(s5)
  800422:	00144583          	lbu	a1,1(s0)
  800426:	0aa1                	addi	s5,s5,8
  800428:	846e                	mv	s0,s11
  80042a:	bfd1                	j	8003fe <vprintfmt+0x112>
  80042c:	4705                	li	a4,1
  80042e:	008a8613          	addi	a2,s5,8
  800432:	00674463          	blt	a4,t1,80043a <vprintfmt+0x14e>
  800436:	1c030c63          	beqz	t1,80060e <vprintfmt+0x322>
  80043a:	000ab683          	ld	a3,0(s5)
  80043e:	4741                	li	a4,16
  800440:	8ab2                	mv	s5,a2
  800442:	2801                	sext.w	a6,a6
  800444:	87e2                	mv	a5,s8
  800446:	8626                	mv	a2,s1
  800448:	85ca                	mv	a1,s2
  80044a:	854e                	mv	a0,s3
  80044c:	e2bff0ef          	jal	ra,800276 <printnum>
  800450:	bdc1                	j	800320 <vprintfmt+0x34>
  800452:	000aa503          	lw	a0,0(s5)
  800456:	864a                	mv	a2,s2
  800458:	85a6                	mv	a1,s1
  80045a:	0aa1                	addi	s5,s5,8
  80045c:	9982                	jalr	s3
  80045e:	b5c9                	j	800320 <vprintfmt+0x34>
  800460:	4705                	li	a4,1
  800462:	008a8613          	addi	a2,s5,8
  800466:	00674463          	blt	a4,t1,80046e <vprintfmt+0x182>
  80046a:	18030d63          	beqz	t1,800604 <vprintfmt+0x318>
  80046e:	000ab683          	ld	a3,0(s5)
  800472:	4729                	li	a4,10
  800474:	8ab2                	mv	s5,a2
  800476:	b7f1                	j	800442 <vprintfmt+0x156>
  800478:	00144583          	lbu	a1,1(s0)
  80047c:	4d05                	li	s10,1
  80047e:	846e                	mv	s0,s11
  800480:	bdd1                	j	800354 <vprintfmt+0x68>
  800482:	864a                	mv	a2,s2
  800484:	85a6                	mv	a1,s1
  800486:	02500513          	li	a0,37
  80048a:	9982                	jalr	s3
  80048c:	bd51                	j	800320 <vprintfmt+0x34>
  80048e:	00144583          	lbu	a1,1(s0)
  800492:	2305                	addiw	t1,t1,1
  800494:	846e                	mv	s0,s11
  800496:	bd7d                	j	800354 <vprintfmt+0x68>
  800498:	4705                	li	a4,1
  80049a:	008a8613          	addi	a2,s5,8
  80049e:	00674463          	blt	a4,t1,8004a6 <vprintfmt+0x1ba>
  8004a2:	14030c63          	beqz	t1,8005fa <vprintfmt+0x30e>
  8004a6:	000ab683          	ld	a3,0(s5)
  8004aa:	4721                	li	a4,8
  8004ac:	8ab2                	mv	s5,a2
  8004ae:	bf51                	j	800442 <vprintfmt+0x156>
  8004b0:	03000513          	li	a0,48
  8004b4:	864a                	mv	a2,s2
  8004b6:	85a6                	mv	a1,s1
  8004b8:	e042                	sd	a6,0(sp)
  8004ba:	9982                	jalr	s3
  8004bc:	864a                	mv	a2,s2
  8004be:	85a6                	mv	a1,s1
  8004c0:	07800513          	li	a0,120
  8004c4:	9982                	jalr	s3
  8004c6:	0aa1                	addi	s5,s5,8
  8004c8:	6802                	ld	a6,0(sp)
  8004ca:	4741                	li	a4,16
  8004cc:	ff8ab683          	ld	a3,-8(s5)
  8004d0:	bf8d                	j	800442 <vprintfmt+0x156>
  8004d2:	000ab403          	ld	s0,0(s5)
  8004d6:	008a8793          	addi	a5,s5,8
  8004da:	e03e                	sd	a5,0(sp)
  8004dc:	14040c63          	beqz	s0,800634 <vprintfmt+0x348>
  8004e0:	11805063          	blez	s8,8005e0 <vprintfmt+0x2f4>
  8004e4:	02d00693          	li	a3,45
  8004e8:	0cd81963          	bne	a6,a3,8005ba <vprintfmt+0x2ce>
  8004ec:	00044683          	lbu	a3,0(s0)
  8004f0:	0006851b          	sext.w	a0,a3
  8004f4:	ce8d                	beqz	a3,80052e <vprintfmt+0x242>
  8004f6:	00140a93          	addi	s5,s0,1
  8004fa:	05e00413          	li	s0,94
  8004fe:	000cc563          	bltz	s9,800508 <vprintfmt+0x21c>
  800502:	3cfd                	addiw	s9,s9,-1
  800504:	037c8363          	beq	s9,s7,80052a <vprintfmt+0x23e>
  800508:	864a                	mv	a2,s2
  80050a:	85a6                	mv	a1,s1
  80050c:	100d0663          	beqz	s10,800618 <vprintfmt+0x32c>
  800510:	3681                	addiw	a3,a3,-32
  800512:	10d47363          	bgeu	s0,a3,800618 <vprintfmt+0x32c>
  800516:	03f00513          	li	a0,63
  80051a:	9982                	jalr	s3
  80051c:	000ac683          	lbu	a3,0(s5)
  800520:	3c7d                	addiw	s8,s8,-1
  800522:	0a85                	addi	s5,s5,1
  800524:	0006851b          	sext.w	a0,a3
  800528:	faf9                	bnez	a3,8004fe <vprintfmt+0x212>
  80052a:	01805a63          	blez	s8,80053e <vprintfmt+0x252>
  80052e:	3c7d                	addiw	s8,s8,-1
  800530:	864a                	mv	a2,s2
  800532:	85a6                	mv	a1,s1
  800534:	02000513          	li	a0,32
  800538:	9982                	jalr	s3
  80053a:	fe0c1ae3          	bnez	s8,80052e <vprintfmt+0x242>
  80053e:	6a82                	ld	s5,0(sp)
  800540:	b3c5                	j	800320 <vprintfmt+0x34>
  800542:	4705                	li	a4,1
  800544:	008a8d13          	addi	s10,s5,8
  800548:	00674463          	blt	a4,t1,800550 <vprintfmt+0x264>
  80054c:	0a030463          	beqz	t1,8005f4 <vprintfmt+0x308>
  800550:	000ab403          	ld	s0,0(s5)
  800554:	0c044463          	bltz	s0,80061c <vprintfmt+0x330>
  800558:	86a2                	mv	a3,s0
  80055a:	8aea                	mv	s5,s10
  80055c:	4729                	li	a4,10
  80055e:	b5d5                	j	800442 <vprintfmt+0x156>
  800560:	000aa783          	lw	a5,0(s5)
  800564:	46e1                	li	a3,24
  800566:	0aa1                	addi	s5,s5,8
  800568:	41f7d71b          	sraiw	a4,a5,0x1f
  80056c:	8fb9                	xor	a5,a5,a4
  80056e:	40e7873b          	subw	a4,a5,a4
  800572:	02e6c663          	blt	a3,a4,80059e <vprintfmt+0x2b2>
  800576:	00371793          	slli	a5,a4,0x3
  80057a:	00000697          	auipc	a3,0x0
  80057e:	64668693          	addi	a3,a3,1606 # 800bc0 <error_string>
  800582:	97b6                	add	a5,a5,a3
  800584:	639c                	ld	a5,0(a5)
  800586:	cf81                	beqz	a5,80059e <vprintfmt+0x2b2>
  800588:	873e                	mv	a4,a5
  80058a:	00000697          	auipc	a3,0x0
  80058e:	2fe68693          	addi	a3,a3,766 # 800888 <main+0x1e2>
  800592:	8626                	mv	a2,s1
  800594:	85ca                	mv	a1,s2
  800596:	854e                	mv	a0,s3
  800598:	0d4000ef          	jal	ra,80066c <printfmt>
  80059c:	b351                	j	800320 <vprintfmt+0x34>
  80059e:	00000697          	auipc	a3,0x0
  8005a2:	2da68693          	addi	a3,a3,730 # 800878 <main+0x1d2>
  8005a6:	8626                	mv	a2,s1
  8005a8:	85ca                	mv	a1,s2
  8005aa:	854e                	mv	a0,s3
  8005ac:	0c0000ef          	jal	ra,80066c <printfmt>
  8005b0:	bb85                	j	800320 <vprintfmt+0x34>
  8005b2:	00000417          	auipc	s0,0x0
  8005b6:	2be40413          	addi	s0,s0,702 # 800870 <main+0x1ca>
  8005ba:	85e6                	mv	a1,s9
  8005bc:	8522                	mv	a0,s0
  8005be:	e442                	sd	a6,8(sp)
  8005c0:	0ca000ef          	jal	ra,80068a <strnlen>
  8005c4:	40ac0c3b          	subw	s8,s8,a0
  8005c8:	01805c63          	blez	s8,8005e0 <vprintfmt+0x2f4>
  8005cc:	6822                	ld	a6,8(sp)
  8005ce:	00080a9b          	sext.w	s5,a6
  8005d2:	3c7d                	addiw	s8,s8,-1
  8005d4:	864a                	mv	a2,s2
  8005d6:	85a6                	mv	a1,s1
  8005d8:	8556                	mv	a0,s5
  8005da:	9982                	jalr	s3
  8005dc:	fe0c1be3          	bnez	s8,8005d2 <vprintfmt+0x2e6>
  8005e0:	00044683          	lbu	a3,0(s0)
  8005e4:	00140a93          	addi	s5,s0,1
  8005e8:	0006851b          	sext.w	a0,a3
  8005ec:	daa9                	beqz	a3,80053e <vprintfmt+0x252>
  8005ee:	05e00413          	li	s0,94
  8005f2:	b731                	j	8004fe <vprintfmt+0x212>
  8005f4:	000aa403          	lw	s0,0(s5)
  8005f8:	bfb1                	j	800554 <vprintfmt+0x268>
  8005fa:	000ae683          	lwu	a3,0(s5)
  8005fe:	4721                	li	a4,8
  800600:	8ab2                	mv	s5,a2
  800602:	b581                	j	800442 <vprintfmt+0x156>
  800604:	000ae683          	lwu	a3,0(s5)
  800608:	4729                	li	a4,10
  80060a:	8ab2                	mv	s5,a2
  80060c:	bd1d                	j	800442 <vprintfmt+0x156>
  80060e:	000ae683          	lwu	a3,0(s5)
  800612:	4741                	li	a4,16
  800614:	8ab2                	mv	s5,a2
  800616:	b535                	j	800442 <vprintfmt+0x156>
  800618:	9982                	jalr	s3
  80061a:	b709                	j	80051c <vprintfmt+0x230>
  80061c:	864a                	mv	a2,s2
  80061e:	85a6                	mv	a1,s1
  800620:	02d00513          	li	a0,45
  800624:	e042                	sd	a6,0(sp)
  800626:	9982                	jalr	s3
  800628:	6802                	ld	a6,0(sp)
  80062a:	8aea                	mv	s5,s10
  80062c:	408006b3          	neg	a3,s0
  800630:	4729                	li	a4,10
  800632:	bd01                	j	800442 <vprintfmt+0x156>
  800634:	03805163          	blez	s8,800656 <vprintfmt+0x36a>
  800638:	02d00693          	li	a3,45
  80063c:	f6d81be3          	bne	a6,a3,8005b2 <vprintfmt+0x2c6>
  800640:	00000417          	auipc	s0,0x0
  800644:	23040413          	addi	s0,s0,560 # 800870 <main+0x1ca>
  800648:	02800693          	li	a3,40
  80064c:	02800513          	li	a0,40
  800650:	00140a93          	addi	s5,s0,1
  800654:	b55d                	j	8004fa <vprintfmt+0x20e>
  800656:	00000a97          	auipc	s5,0x0
  80065a:	21ba8a93          	addi	s5,s5,539 # 800871 <main+0x1cb>
  80065e:	02800513          	li	a0,40
  800662:	02800693          	li	a3,40
  800666:	05e00413          	li	s0,94
  80066a:	bd51                	j	8004fe <vprintfmt+0x212>

000000000080066c <printfmt>:
  80066c:	7139                	addi	sp,sp,-64
  80066e:	02010313          	addi	t1,sp,32
  800672:	f03a                	sd	a4,32(sp)
  800674:	871a                	mv	a4,t1
  800676:	ec06                	sd	ra,24(sp)
  800678:	f43e                	sd	a5,40(sp)
  80067a:	f842                	sd	a6,48(sp)
  80067c:	fc46                	sd	a7,56(sp)
  80067e:	e41a                	sd	t1,8(sp)
  800680:	c6dff0ef          	jal	ra,8002ec <vprintfmt>
  800684:	60e2                	ld	ra,24(sp)
  800686:	6121                	addi	sp,sp,64
  800688:	8082                	ret

000000000080068a <strnlen>:
  80068a:	4781                	li	a5,0
  80068c:	e589                	bnez	a1,800696 <strnlen+0xc>
  80068e:	a811                	j	8006a2 <strnlen+0x18>
  800690:	0785                	addi	a5,a5,1
  800692:	00f58863          	beq	a1,a5,8006a2 <strnlen+0x18>
  800696:	00f50733          	add	a4,a0,a5
  80069a:	00074703          	lbu	a4,0(a4)
  80069e:	fb6d                	bnez	a4,800690 <strnlen+0x6>
  8006a0:	85be                	mv	a1,a5
  8006a2:	852e                	mv	a0,a1
  8006a4:	8082                	ret

00000000008006a6 <main>:
  8006a6:	1101                	addi	sp,sp,-32
  8006a8:	ec06                	sd	ra,24(sp)
  8006aa:	e822                	sd	s0,16(sp)
  8006ac:	b0dff0ef          	jal	ra,8001b8 <fork>
  8006b0:	c169                	beqz	a0,800772 <main+0xcc>
  8006b2:	842a                	mv	s0,a0
  8006b4:	0aa05063          	blez	a0,800754 <main+0xae>
  8006b8:	4581                	li	a1,0
  8006ba:	557d                	li	a0,-1
  8006bc:	affff0ef          	jal	ra,8001ba <waitpid>
  8006c0:	c93d                	beqz	a0,800736 <main+0x90>
  8006c2:	458d                	li	a1,3
  8006c4:	05fa                	slli	a1,a1,0x1e
  8006c6:	8522                	mv	a0,s0
  8006c8:	af3ff0ef          	jal	ra,8001ba <waitpid>
  8006cc:	c531                	beqz	a0,800718 <main+0x72>
  8006ce:	006c                	addi	a1,sp,12
  8006d0:	8522                	mv	a0,s0
  8006d2:	ae9ff0ef          	jal	ra,8001ba <waitpid>
  8006d6:	e115                	bnez	a0,8006fa <main+0x54>
  8006d8:	4732                	lw	a4,12(sp)
  8006da:	67b1                	lui	a5,0xc
  8006dc:	eaf78793          	addi	a5,a5,-337 # beaf <open-0x7f4171>
  8006e0:	00f71d63          	bne	a4,a5,8006fa <main+0x54>
  8006e4:	00000517          	auipc	a0,0x0
  8006e8:	65c50513          	addi	a0,a0,1628 # 800d40 <error_string+0x180>
  8006ec:	a0bff0ef          	jal	ra,8000f6 <cprintf>
  8006f0:	60e2                	ld	ra,24(sp)
  8006f2:	6442                	ld	s0,16(sp)
  8006f4:	4501                	li	a0,0
  8006f6:	6105                	addi	sp,sp,32
  8006f8:	8082                	ret
  8006fa:	00000697          	auipc	a3,0x0
  8006fe:	60e68693          	addi	a3,a3,1550 # 800d08 <error_string+0x148>
  800702:	00000617          	auipc	a2,0x0
  800706:	59e60613          	addi	a2,a2,1438 # 800ca0 <error_string+0xe0>
  80070a:	45c9                	li	a1,18
  80070c:	00000517          	auipc	a0,0x0
  800710:	5ac50513          	addi	a0,a0,1452 # 800cb8 <error_string+0xf8>
  800714:	91dff0ef          	jal	ra,800030 <__panic>
  800718:	00000697          	auipc	a3,0x0
  80071c:	5c868693          	addi	a3,a3,1480 # 800ce0 <error_string+0x120>
  800720:	00000617          	auipc	a2,0x0
  800724:	58060613          	addi	a2,a2,1408 # 800ca0 <error_string+0xe0>
  800728:	45c5                	li	a1,17
  80072a:	00000517          	auipc	a0,0x0
  80072e:	58e50513          	addi	a0,a0,1422 # 800cb8 <error_string+0xf8>
  800732:	8ffff0ef          	jal	ra,800030 <__panic>
  800736:	00000697          	auipc	a3,0x0
  80073a:	59268693          	addi	a3,a3,1426 # 800cc8 <error_string+0x108>
  80073e:	00000617          	auipc	a2,0x0
  800742:	56260613          	addi	a2,a2,1378 # 800ca0 <error_string+0xe0>
  800746:	45c1                	li	a1,16
  800748:	00000517          	auipc	a0,0x0
  80074c:	57050513          	addi	a0,a0,1392 # 800cb8 <error_string+0xf8>
  800750:	8e1ff0ef          	jal	ra,800030 <__panic>
  800754:	00000697          	auipc	a3,0x0
  800758:	54468693          	addi	a3,a3,1348 # 800c98 <error_string+0xd8>
  80075c:	00000617          	auipc	a2,0x0
  800760:	54460613          	addi	a2,a2,1348 # 800ca0 <error_string+0xe0>
  800764:	45bd                	li	a1,15
  800766:	00000517          	auipc	a0,0x0
  80076a:	55250513          	addi	a0,a0,1362 # 800cb8 <error_string+0xf8>
  80076e:	8c3ff0ef          	jal	ra,800030 <__panic>
  800772:	00000517          	auipc	a0,0x0
  800776:	51650513          	addi	a0,a0,1302 # 800c88 <error_string+0xc8>
  80077a:	97dff0ef          	jal	ra,8000f6 <cprintf>
  80077e:	4429                	li	s0,10
  800780:	347d                	addiw	s0,s0,-1
  800782:	a3bff0ef          	jal	ra,8001bc <yield>
  800786:	fc6d                	bnez	s0,800780 <main+0xda>
  800788:	6531                	lui	a0,0xc
  80078a:	eaf50513          	addi	a0,a0,-337 # beaf <open-0x7f4171>
  80078e:	a15ff0ef          	jal	ra,8001a2 <exit>
