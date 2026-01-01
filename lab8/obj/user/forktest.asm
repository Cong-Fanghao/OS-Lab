
obj/__user_forktest.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aab9                	j	800182 <sys_open>

0000000000800026 <close>:
  800026:	a29d                	j	80018c <sys_close>

0000000000800028 <dup2>:
  800028:	a2b5                	j	800194 <sys_dup>

000000000080002a <_start>:
  80002a:	1d6000ef          	jal	ra,800200 <umain>
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
  800044:	71050513          	addi	a0,a0,1808 # 800750 <main+0xac>
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
  800064:	76850513          	addi	a0,a0,1896 # 8007c8 <main+0x124>
  800068:	08e000ef          	jal	ra,8000f6 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	130000ef          	jal	ra,80019e <exit>

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
  800086:	6ee50513          	addi	a0,a0,1774 # 800770 <main+0xcc>
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
  8000a6:	72650513          	addi	a0,a0,1830 # 8007c8 <main+0x124>
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
  8000be:	0be000ef          	jal	ra,80017c <sys_putc>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f61>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	200000ef          	jal	ra,8002ea <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f61>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1c4000ef          	jal	ra,8002ea <vprintfmt>
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

000000000080017c <sys_putc>:
  80017c:	85aa                	mv	a1,a0
  80017e:	4579                	li	a0,30
  800180:	bf4d                	j	800132 <syscall>

0000000000800182 <sys_open>:
  800182:	862e                	mv	a2,a1
  800184:	85aa                	mv	a1,a0
  800186:	06400513          	li	a0,100
  80018a:	b765                	j	800132 <syscall>

000000000080018c <sys_close>:
  80018c:	85aa                	mv	a1,a0
  80018e:	06500513          	li	a0,101
  800192:	b745                	j	800132 <syscall>

0000000000800194 <sys_dup>:
  800194:	862e                	mv	a2,a1
  800196:	85aa                	mv	a1,a0
  800198:	08200513          	li	a0,130
  80019c:	bf59                	j	800132 <syscall>

000000000080019e <exit>:
  80019e:	1141                	addi	sp,sp,-16
  8001a0:	e406                	sd	ra,8(sp)
  8001a2:	fc9ff0ef          	jal	ra,80016a <sys_exit>
  8001a6:	00000517          	auipc	a0,0x0
  8001aa:	5ea50513          	addi	a0,a0,1514 # 800790 <main+0xec>
  8001ae:	f49ff0ef          	jal	ra,8000f6 <cprintf>
  8001b2:	a001                	j	8001b2 <exit+0x14>

00000000008001b4 <fork>:
  8001b4:	bf75                	j	800170 <sys_fork>

00000000008001b6 <wait>:
  8001b6:	4581                	li	a1,0
  8001b8:	4501                	li	a0,0
  8001ba:	bf6d                	j	800174 <sys_wait>

00000000008001bc <initfd>:
  8001bc:	1101                	addi	sp,sp,-32
  8001be:	87ae                	mv	a5,a1
  8001c0:	e426                	sd	s1,8(sp)
  8001c2:	85b2                	mv	a1,a2
  8001c4:	84aa                	mv	s1,a0
  8001c6:	853e                	mv	a0,a5
  8001c8:	e822                	sd	s0,16(sp)
  8001ca:	ec06                	sd	ra,24(sp)
  8001cc:	e55ff0ef          	jal	ra,800020 <open>
  8001d0:	842a                	mv	s0,a0
  8001d2:	00054463          	bltz	a0,8001da <initfd+0x1e>
  8001d6:	00951863          	bne	a0,s1,8001e6 <initfd+0x2a>
  8001da:	60e2                	ld	ra,24(sp)
  8001dc:	8522                	mv	a0,s0
  8001de:	6442                	ld	s0,16(sp)
  8001e0:	64a2                	ld	s1,8(sp)
  8001e2:	6105                	addi	sp,sp,32
  8001e4:	8082                	ret
  8001e6:	8526                	mv	a0,s1
  8001e8:	e3fff0ef          	jal	ra,800026 <close>
  8001ec:	85a6                	mv	a1,s1
  8001ee:	8522                	mv	a0,s0
  8001f0:	e39ff0ef          	jal	ra,800028 <dup2>
  8001f4:	84aa                	mv	s1,a0
  8001f6:	8522                	mv	a0,s0
  8001f8:	e2fff0ef          	jal	ra,800026 <close>
  8001fc:	8426                	mv	s0,s1
  8001fe:	bff1                	j	8001da <initfd+0x1e>

0000000000800200 <umain>:
  800200:	1101                	addi	sp,sp,-32
  800202:	e822                	sd	s0,16(sp)
  800204:	e426                	sd	s1,8(sp)
  800206:	842a                	mv	s0,a0
  800208:	84ae                	mv	s1,a1
  80020a:	4601                	li	a2,0
  80020c:	00000597          	auipc	a1,0x0
  800210:	59c58593          	addi	a1,a1,1436 # 8007a8 <main+0x104>
  800214:	4501                	li	a0,0
  800216:	ec06                	sd	ra,24(sp)
  800218:	fa5ff0ef          	jal	ra,8001bc <initfd>
  80021c:	02054263          	bltz	a0,800240 <umain+0x40>
  800220:	4605                	li	a2,1
  800222:	00000597          	auipc	a1,0x0
  800226:	5c658593          	addi	a1,a1,1478 # 8007e8 <main+0x144>
  80022a:	4505                	li	a0,1
  80022c:	f91ff0ef          	jal	ra,8001bc <initfd>
  800230:	02054563          	bltz	a0,80025a <umain+0x5a>
  800234:	85a6                	mv	a1,s1
  800236:	8522                	mv	a0,s0
  800238:	46c000ef          	jal	ra,8006a4 <main>
  80023c:	f63ff0ef          	jal	ra,80019e <exit>
  800240:	86aa                	mv	a3,a0
  800242:	00000617          	auipc	a2,0x0
  800246:	56e60613          	addi	a2,a2,1390 # 8007b0 <main+0x10c>
  80024a:	45e9                	li	a1,26
  80024c:	00000517          	auipc	a0,0x0
  800250:	58450513          	addi	a0,a0,1412 # 8007d0 <main+0x12c>
  800254:	e1fff0ef          	jal	ra,800072 <__warn>
  800258:	b7e1                	j	800220 <umain+0x20>
  80025a:	86aa                	mv	a3,a0
  80025c:	00000617          	auipc	a2,0x0
  800260:	59460613          	addi	a2,a2,1428 # 8007f0 <main+0x14c>
  800264:	45f5                	li	a1,29
  800266:	00000517          	auipc	a0,0x0
  80026a:	56a50513          	addi	a0,a0,1386 # 8007d0 <main+0x12c>
  80026e:	e05ff0ef          	jal	ra,800072 <__warn>
  800272:	b7c9                	j	800234 <umain+0x34>

0000000000800274 <printnum>:
  800274:	02071893          	slli	a7,a4,0x20
  800278:	7139                	addi	sp,sp,-64
  80027a:	0208d893          	srli	a7,a7,0x20
  80027e:	e456                	sd	s5,8(sp)
  800280:	0316fab3          	remu	s5,a3,a7
  800284:	f822                	sd	s0,48(sp)
  800286:	f426                	sd	s1,40(sp)
  800288:	f04a                	sd	s2,32(sp)
  80028a:	ec4e                	sd	s3,24(sp)
  80028c:	fc06                	sd	ra,56(sp)
  80028e:	e852                	sd	s4,16(sp)
  800290:	84aa                	mv	s1,a0
  800292:	89ae                	mv	s3,a1
  800294:	8932                	mv	s2,a2
  800296:	fff7841b          	addiw	s0,a5,-1
  80029a:	2a81                	sext.w	s5,s5
  80029c:	0516f163          	bgeu	a3,a7,8002de <printnum+0x6a>
  8002a0:	8a42                	mv	s4,a6
  8002a2:	00805863          	blez	s0,8002b2 <printnum+0x3e>
  8002a6:	347d                	addiw	s0,s0,-1
  8002a8:	864e                	mv	a2,s3
  8002aa:	85ca                	mv	a1,s2
  8002ac:	8552                	mv	a0,s4
  8002ae:	9482                	jalr	s1
  8002b0:	f87d                	bnez	s0,8002a6 <printnum+0x32>
  8002b2:	1a82                	slli	s5,s5,0x20
  8002b4:	00000797          	auipc	a5,0x0
  8002b8:	55c78793          	addi	a5,a5,1372 # 800810 <main+0x16c>
  8002bc:	020ada93          	srli	s5,s5,0x20
  8002c0:	9abe                	add	s5,s5,a5
  8002c2:	7442                	ld	s0,48(sp)
  8002c4:	000ac503          	lbu	a0,0(s5)
  8002c8:	70e2                	ld	ra,56(sp)
  8002ca:	6a42                	ld	s4,16(sp)
  8002cc:	6aa2                	ld	s5,8(sp)
  8002ce:	864e                	mv	a2,s3
  8002d0:	85ca                	mv	a1,s2
  8002d2:	69e2                	ld	s3,24(sp)
  8002d4:	7902                	ld	s2,32(sp)
  8002d6:	87a6                	mv	a5,s1
  8002d8:	74a2                	ld	s1,40(sp)
  8002da:	6121                	addi	sp,sp,64
  8002dc:	8782                	jr	a5
  8002de:	0316d6b3          	divu	a3,a3,a7
  8002e2:	87a2                	mv	a5,s0
  8002e4:	f91ff0ef          	jal	ra,800274 <printnum>
  8002e8:	b7e9                	j	8002b2 <printnum+0x3e>

00000000008002ea <vprintfmt>:
  8002ea:	7119                	addi	sp,sp,-128
  8002ec:	f4a6                	sd	s1,104(sp)
  8002ee:	f0ca                	sd	s2,96(sp)
  8002f0:	ecce                	sd	s3,88(sp)
  8002f2:	e8d2                	sd	s4,80(sp)
  8002f4:	e4d6                	sd	s5,72(sp)
  8002f6:	e0da                	sd	s6,64(sp)
  8002f8:	fc5e                	sd	s7,56(sp)
  8002fa:	ec6e                	sd	s11,24(sp)
  8002fc:	fc86                	sd	ra,120(sp)
  8002fe:	f8a2                	sd	s0,112(sp)
  800300:	f862                	sd	s8,48(sp)
  800302:	f466                	sd	s9,40(sp)
  800304:	f06a                	sd	s10,32(sp)
  800306:	89aa                	mv	s3,a0
  800308:	892e                	mv	s2,a1
  80030a:	84b2                	mv	s1,a2
  80030c:	8db6                	mv	s11,a3
  80030e:	8aba                	mv	s5,a4
  800310:	02500a13          	li	s4,37
  800314:	5bfd                	li	s7,-1
  800316:	00000b17          	auipc	s6,0x0
  80031a:	52eb0b13          	addi	s6,s6,1326 # 800844 <main+0x1a0>
  80031e:	000dc503          	lbu	a0,0(s11)
  800322:	001d8413          	addi	s0,s11,1
  800326:	01450b63          	beq	a0,s4,80033c <vprintfmt+0x52>
  80032a:	c129                	beqz	a0,80036c <vprintfmt+0x82>
  80032c:	864a                	mv	a2,s2
  80032e:	85a6                	mv	a1,s1
  800330:	0405                	addi	s0,s0,1
  800332:	9982                	jalr	s3
  800334:	fff44503          	lbu	a0,-1(s0)
  800338:	ff4519e3          	bne	a0,s4,80032a <vprintfmt+0x40>
  80033c:	00044583          	lbu	a1,0(s0)
  800340:	02000813          	li	a6,32
  800344:	4d01                	li	s10,0
  800346:	4301                	li	t1,0
  800348:	5cfd                	li	s9,-1
  80034a:	5c7d                	li	s8,-1
  80034c:	05500513          	li	a0,85
  800350:	48a5                	li	a7,9
  800352:	fdd5861b          	addiw	a2,a1,-35
  800356:	0ff67613          	zext.b	a2,a2
  80035a:	00140d93          	addi	s11,s0,1
  80035e:	04c56263          	bltu	a0,a2,8003a2 <vprintfmt+0xb8>
  800362:	060a                	slli	a2,a2,0x2
  800364:	965a                	add	a2,a2,s6
  800366:	4214                	lw	a3,0(a2)
  800368:	96da                	add	a3,a3,s6
  80036a:	8682                	jr	a3
  80036c:	70e6                	ld	ra,120(sp)
  80036e:	7446                	ld	s0,112(sp)
  800370:	74a6                	ld	s1,104(sp)
  800372:	7906                	ld	s2,96(sp)
  800374:	69e6                	ld	s3,88(sp)
  800376:	6a46                	ld	s4,80(sp)
  800378:	6aa6                	ld	s5,72(sp)
  80037a:	6b06                	ld	s6,64(sp)
  80037c:	7be2                	ld	s7,56(sp)
  80037e:	7c42                	ld	s8,48(sp)
  800380:	7ca2                	ld	s9,40(sp)
  800382:	7d02                	ld	s10,32(sp)
  800384:	6de2                	ld	s11,24(sp)
  800386:	6109                	addi	sp,sp,128
  800388:	8082                	ret
  80038a:	882e                	mv	a6,a1
  80038c:	00144583          	lbu	a1,1(s0)
  800390:	846e                	mv	s0,s11
  800392:	00140d93          	addi	s11,s0,1
  800396:	fdd5861b          	addiw	a2,a1,-35
  80039a:	0ff67613          	zext.b	a2,a2
  80039e:	fcc572e3          	bgeu	a0,a2,800362 <vprintfmt+0x78>
  8003a2:	864a                	mv	a2,s2
  8003a4:	85a6                	mv	a1,s1
  8003a6:	02500513          	li	a0,37
  8003aa:	9982                	jalr	s3
  8003ac:	fff44783          	lbu	a5,-1(s0)
  8003b0:	8da2                	mv	s11,s0
  8003b2:	f74786e3          	beq	a5,s4,80031e <vprintfmt+0x34>
  8003b6:	ffedc783          	lbu	a5,-2(s11)
  8003ba:	1dfd                	addi	s11,s11,-1
  8003bc:	ff479de3          	bne	a5,s4,8003b6 <vprintfmt+0xcc>
  8003c0:	bfb9                	j	80031e <vprintfmt+0x34>
  8003c2:	fd058c9b          	addiw	s9,a1,-48
  8003c6:	00144583          	lbu	a1,1(s0)
  8003ca:	846e                	mv	s0,s11
  8003cc:	fd05869b          	addiw	a3,a1,-48
  8003d0:	0005861b          	sext.w	a2,a1
  8003d4:	02d8e463          	bltu	a7,a3,8003fc <vprintfmt+0x112>
  8003d8:	00144583          	lbu	a1,1(s0)
  8003dc:	002c969b          	slliw	a3,s9,0x2
  8003e0:	0196873b          	addw	a4,a3,s9
  8003e4:	0017171b          	slliw	a4,a4,0x1
  8003e8:	9f31                	addw	a4,a4,a2
  8003ea:	fd05869b          	addiw	a3,a1,-48
  8003ee:	0405                	addi	s0,s0,1
  8003f0:	fd070c9b          	addiw	s9,a4,-48
  8003f4:	0005861b          	sext.w	a2,a1
  8003f8:	fed8f0e3          	bgeu	a7,a3,8003d8 <vprintfmt+0xee>
  8003fc:	f40c5be3          	bgez	s8,800352 <vprintfmt+0x68>
  800400:	8c66                	mv	s8,s9
  800402:	5cfd                	li	s9,-1
  800404:	b7b9                	j	800352 <vprintfmt+0x68>
  800406:	fffc4693          	not	a3,s8
  80040a:	96fd                	srai	a3,a3,0x3f
  80040c:	00dc77b3          	and	a5,s8,a3
  800410:	00144583          	lbu	a1,1(s0)
  800414:	00078c1b          	sext.w	s8,a5
  800418:	846e                	mv	s0,s11
  80041a:	bf25                	j	800352 <vprintfmt+0x68>
  80041c:	000aac83          	lw	s9,0(s5)
  800420:	00144583          	lbu	a1,1(s0)
  800424:	0aa1                	addi	s5,s5,8
  800426:	846e                	mv	s0,s11
  800428:	bfd1                	j	8003fc <vprintfmt+0x112>
  80042a:	4705                	li	a4,1
  80042c:	008a8613          	addi	a2,s5,8
  800430:	00674463          	blt	a4,t1,800438 <vprintfmt+0x14e>
  800434:	1c030c63          	beqz	t1,80060c <vprintfmt+0x322>
  800438:	000ab683          	ld	a3,0(s5)
  80043c:	4741                	li	a4,16
  80043e:	8ab2                	mv	s5,a2
  800440:	2801                	sext.w	a6,a6
  800442:	87e2                	mv	a5,s8
  800444:	8626                	mv	a2,s1
  800446:	85ca                	mv	a1,s2
  800448:	854e                	mv	a0,s3
  80044a:	e2bff0ef          	jal	ra,800274 <printnum>
  80044e:	bdc1                	j	80031e <vprintfmt+0x34>
  800450:	000aa503          	lw	a0,0(s5)
  800454:	864a                	mv	a2,s2
  800456:	85a6                	mv	a1,s1
  800458:	0aa1                	addi	s5,s5,8
  80045a:	9982                	jalr	s3
  80045c:	b5c9                	j	80031e <vprintfmt+0x34>
  80045e:	4705                	li	a4,1
  800460:	008a8613          	addi	a2,s5,8
  800464:	00674463          	blt	a4,t1,80046c <vprintfmt+0x182>
  800468:	18030d63          	beqz	t1,800602 <vprintfmt+0x318>
  80046c:	000ab683          	ld	a3,0(s5)
  800470:	4729                	li	a4,10
  800472:	8ab2                	mv	s5,a2
  800474:	b7f1                	j	800440 <vprintfmt+0x156>
  800476:	00144583          	lbu	a1,1(s0)
  80047a:	4d05                	li	s10,1
  80047c:	846e                	mv	s0,s11
  80047e:	bdd1                	j	800352 <vprintfmt+0x68>
  800480:	864a                	mv	a2,s2
  800482:	85a6                	mv	a1,s1
  800484:	02500513          	li	a0,37
  800488:	9982                	jalr	s3
  80048a:	bd51                	j	80031e <vprintfmt+0x34>
  80048c:	00144583          	lbu	a1,1(s0)
  800490:	2305                	addiw	t1,t1,1
  800492:	846e                	mv	s0,s11
  800494:	bd7d                	j	800352 <vprintfmt+0x68>
  800496:	4705                	li	a4,1
  800498:	008a8613          	addi	a2,s5,8
  80049c:	00674463          	blt	a4,t1,8004a4 <vprintfmt+0x1ba>
  8004a0:	14030c63          	beqz	t1,8005f8 <vprintfmt+0x30e>
  8004a4:	000ab683          	ld	a3,0(s5)
  8004a8:	4721                	li	a4,8
  8004aa:	8ab2                	mv	s5,a2
  8004ac:	bf51                	j	800440 <vprintfmt+0x156>
  8004ae:	03000513          	li	a0,48
  8004b2:	864a                	mv	a2,s2
  8004b4:	85a6                	mv	a1,s1
  8004b6:	e042                	sd	a6,0(sp)
  8004b8:	9982                	jalr	s3
  8004ba:	864a                	mv	a2,s2
  8004bc:	85a6                	mv	a1,s1
  8004be:	07800513          	li	a0,120
  8004c2:	9982                	jalr	s3
  8004c4:	0aa1                	addi	s5,s5,8
  8004c6:	6802                	ld	a6,0(sp)
  8004c8:	4741                	li	a4,16
  8004ca:	ff8ab683          	ld	a3,-8(s5)
  8004ce:	bf8d                	j	800440 <vprintfmt+0x156>
  8004d0:	000ab403          	ld	s0,0(s5)
  8004d4:	008a8793          	addi	a5,s5,8
  8004d8:	e03e                	sd	a5,0(sp)
  8004da:	14040c63          	beqz	s0,800632 <vprintfmt+0x348>
  8004de:	11805063          	blez	s8,8005de <vprintfmt+0x2f4>
  8004e2:	02d00693          	li	a3,45
  8004e6:	0cd81963          	bne	a6,a3,8005b8 <vprintfmt+0x2ce>
  8004ea:	00044683          	lbu	a3,0(s0)
  8004ee:	0006851b          	sext.w	a0,a3
  8004f2:	ce8d                	beqz	a3,80052c <vprintfmt+0x242>
  8004f4:	00140a93          	addi	s5,s0,1
  8004f8:	05e00413          	li	s0,94
  8004fc:	000cc563          	bltz	s9,800506 <vprintfmt+0x21c>
  800500:	3cfd                	addiw	s9,s9,-1
  800502:	037c8363          	beq	s9,s7,800528 <vprintfmt+0x23e>
  800506:	864a                	mv	a2,s2
  800508:	85a6                	mv	a1,s1
  80050a:	100d0663          	beqz	s10,800616 <vprintfmt+0x32c>
  80050e:	3681                	addiw	a3,a3,-32
  800510:	10d47363          	bgeu	s0,a3,800616 <vprintfmt+0x32c>
  800514:	03f00513          	li	a0,63
  800518:	9982                	jalr	s3
  80051a:	000ac683          	lbu	a3,0(s5)
  80051e:	3c7d                	addiw	s8,s8,-1
  800520:	0a85                	addi	s5,s5,1
  800522:	0006851b          	sext.w	a0,a3
  800526:	faf9                	bnez	a3,8004fc <vprintfmt+0x212>
  800528:	01805a63          	blez	s8,80053c <vprintfmt+0x252>
  80052c:	3c7d                	addiw	s8,s8,-1
  80052e:	864a                	mv	a2,s2
  800530:	85a6                	mv	a1,s1
  800532:	02000513          	li	a0,32
  800536:	9982                	jalr	s3
  800538:	fe0c1ae3          	bnez	s8,80052c <vprintfmt+0x242>
  80053c:	6a82                	ld	s5,0(sp)
  80053e:	b3c5                	j	80031e <vprintfmt+0x34>
  800540:	4705                	li	a4,1
  800542:	008a8d13          	addi	s10,s5,8
  800546:	00674463          	blt	a4,t1,80054e <vprintfmt+0x264>
  80054a:	0a030463          	beqz	t1,8005f2 <vprintfmt+0x308>
  80054e:	000ab403          	ld	s0,0(s5)
  800552:	0c044463          	bltz	s0,80061a <vprintfmt+0x330>
  800556:	86a2                	mv	a3,s0
  800558:	8aea                	mv	s5,s10
  80055a:	4729                	li	a4,10
  80055c:	b5d5                	j	800440 <vprintfmt+0x156>
  80055e:	000aa783          	lw	a5,0(s5)
  800562:	46e1                	li	a3,24
  800564:	0aa1                	addi	s5,s5,8
  800566:	41f7d71b          	sraiw	a4,a5,0x1f
  80056a:	8fb9                	xor	a5,a5,a4
  80056c:	40e7873b          	subw	a4,a5,a4
  800570:	02e6c663          	blt	a3,a4,80059c <vprintfmt+0x2b2>
  800574:	00371793          	slli	a5,a4,0x3
  800578:	00000697          	auipc	a3,0x0
  80057c:	60068693          	addi	a3,a3,1536 # 800b78 <error_string>
  800580:	97b6                	add	a5,a5,a3
  800582:	639c                	ld	a5,0(a5)
  800584:	cf81                	beqz	a5,80059c <vprintfmt+0x2b2>
  800586:	873e                	mv	a4,a5
  800588:	00000697          	auipc	a3,0x0
  80058c:	2b868693          	addi	a3,a3,696 # 800840 <main+0x19c>
  800590:	8626                	mv	a2,s1
  800592:	85ca                	mv	a1,s2
  800594:	854e                	mv	a0,s3
  800596:	0d4000ef          	jal	ra,80066a <printfmt>
  80059a:	b351                	j	80031e <vprintfmt+0x34>
  80059c:	00000697          	auipc	a3,0x0
  8005a0:	29468693          	addi	a3,a3,660 # 800830 <main+0x18c>
  8005a4:	8626                	mv	a2,s1
  8005a6:	85ca                	mv	a1,s2
  8005a8:	854e                	mv	a0,s3
  8005aa:	0c0000ef          	jal	ra,80066a <printfmt>
  8005ae:	bb85                	j	80031e <vprintfmt+0x34>
  8005b0:	00000417          	auipc	s0,0x0
  8005b4:	27840413          	addi	s0,s0,632 # 800828 <main+0x184>
  8005b8:	85e6                	mv	a1,s9
  8005ba:	8522                	mv	a0,s0
  8005bc:	e442                	sd	a6,8(sp)
  8005be:	0ca000ef          	jal	ra,800688 <strnlen>
  8005c2:	40ac0c3b          	subw	s8,s8,a0
  8005c6:	01805c63          	blez	s8,8005de <vprintfmt+0x2f4>
  8005ca:	6822                	ld	a6,8(sp)
  8005cc:	00080a9b          	sext.w	s5,a6
  8005d0:	3c7d                	addiw	s8,s8,-1
  8005d2:	864a                	mv	a2,s2
  8005d4:	85a6                	mv	a1,s1
  8005d6:	8556                	mv	a0,s5
  8005d8:	9982                	jalr	s3
  8005da:	fe0c1be3          	bnez	s8,8005d0 <vprintfmt+0x2e6>
  8005de:	00044683          	lbu	a3,0(s0)
  8005e2:	00140a93          	addi	s5,s0,1
  8005e6:	0006851b          	sext.w	a0,a3
  8005ea:	daa9                	beqz	a3,80053c <vprintfmt+0x252>
  8005ec:	05e00413          	li	s0,94
  8005f0:	b731                	j	8004fc <vprintfmt+0x212>
  8005f2:	000aa403          	lw	s0,0(s5)
  8005f6:	bfb1                	j	800552 <vprintfmt+0x268>
  8005f8:	000ae683          	lwu	a3,0(s5)
  8005fc:	4721                	li	a4,8
  8005fe:	8ab2                	mv	s5,a2
  800600:	b581                	j	800440 <vprintfmt+0x156>
  800602:	000ae683          	lwu	a3,0(s5)
  800606:	4729                	li	a4,10
  800608:	8ab2                	mv	s5,a2
  80060a:	bd1d                	j	800440 <vprintfmt+0x156>
  80060c:	000ae683          	lwu	a3,0(s5)
  800610:	4741                	li	a4,16
  800612:	8ab2                	mv	s5,a2
  800614:	b535                	j	800440 <vprintfmt+0x156>
  800616:	9982                	jalr	s3
  800618:	b709                	j	80051a <vprintfmt+0x230>
  80061a:	864a                	mv	a2,s2
  80061c:	85a6                	mv	a1,s1
  80061e:	02d00513          	li	a0,45
  800622:	e042                	sd	a6,0(sp)
  800624:	9982                	jalr	s3
  800626:	6802                	ld	a6,0(sp)
  800628:	8aea                	mv	s5,s10
  80062a:	408006b3          	neg	a3,s0
  80062e:	4729                	li	a4,10
  800630:	bd01                	j	800440 <vprintfmt+0x156>
  800632:	03805163          	blez	s8,800654 <vprintfmt+0x36a>
  800636:	02d00693          	li	a3,45
  80063a:	f6d81be3          	bne	a6,a3,8005b0 <vprintfmt+0x2c6>
  80063e:	00000417          	auipc	s0,0x0
  800642:	1ea40413          	addi	s0,s0,490 # 800828 <main+0x184>
  800646:	02800693          	li	a3,40
  80064a:	02800513          	li	a0,40
  80064e:	00140a93          	addi	s5,s0,1
  800652:	b55d                	j	8004f8 <vprintfmt+0x20e>
  800654:	00000a97          	auipc	s5,0x0
  800658:	1d5a8a93          	addi	s5,s5,469 # 800829 <main+0x185>
  80065c:	02800513          	li	a0,40
  800660:	02800693          	li	a3,40
  800664:	05e00413          	li	s0,94
  800668:	bd51                	j	8004fc <vprintfmt+0x212>

000000000080066a <printfmt>:
  80066a:	7139                	addi	sp,sp,-64
  80066c:	02010313          	addi	t1,sp,32
  800670:	f03a                	sd	a4,32(sp)
  800672:	871a                	mv	a4,t1
  800674:	ec06                	sd	ra,24(sp)
  800676:	f43e                	sd	a5,40(sp)
  800678:	f842                	sd	a6,48(sp)
  80067a:	fc46                	sd	a7,56(sp)
  80067c:	e41a                	sd	t1,8(sp)
  80067e:	c6dff0ef          	jal	ra,8002ea <vprintfmt>
  800682:	60e2                	ld	ra,24(sp)
  800684:	6121                	addi	sp,sp,64
  800686:	8082                	ret

0000000000800688 <strnlen>:
  800688:	4781                	li	a5,0
  80068a:	e589                	bnez	a1,800694 <strnlen+0xc>
  80068c:	a811                	j	8006a0 <strnlen+0x18>
  80068e:	0785                	addi	a5,a5,1
  800690:	00f58863          	beq	a1,a5,8006a0 <strnlen+0x18>
  800694:	00f50733          	add	a4,a0,a5
  800698:	00074703          	lbu	a4,0(a4)
  80069c:	fb6d                	bnez	a4,80068e <strnlen+0x6>
  80069e:	85be                	mv	a1,a5
  8006a0:	852e                	mv	a0,a1
  8006a2:	8082                	ret

00000000008006a4 <main>:
  8006a4:	1101                	addi	sp,sp,-32
  8006a6:	e822                	sd	s0,16(sp)
  8006a8:	e426                	sd	s1,8(sp)
  8006aa:	ec06                	sd	ra,24(sp)
  8006ac:	4401                	li	s0,0
  8006ae:	02000493          	li	s1,32
  8006b2:	b03ff0ef          	jal	ra,8001b4 <fork>
  8006b6:	cd05                	beqz	a0,8006ee <main+0x4a>
  8006b8:	06a05063          	blez	a0,800718 <main+0x74>
  8006bc:	2405                	addiw	s0,s0,1
  8006be:	fe941ae3          	bne	s0,s1,8006b2 <main+0xe>
  8006c2:	02000413          	li	s0,32
  8006c6:	af1ff0ef          	jal	ra,8001b6 <wait>
  8006ca:	ed05                	bnez	a0,800702 <main+0x5e>
  8006cc:	347d                	addiw	s0,s0,-1
  8006ce:	fc65                	bnez	s0,8006c6 <main+0x22>
  8006d0:	ae7ff0ef          	jal	ra,8001b6 <wait>
  8006d4:	c12d                	beqz	a0,800736 <main+0x92>
  8006d6:	00000517          	auipc	a0,0x0
  8006da:	5da50513          	addi	a0,a0,1498 # 800cb0 <error_string+0x138>
  8006de:	a19ff0ef          	jal	ra,8000f6 <cprintf>
  8006e2:	60e2                	ld	ra,24(sp)
  8006e4:	6442                	ld	s0,16(sp)
  8006e6:	64a2                	ld	s1,8(sp)
  8006e8:	4501                	li	a0,0
  8006ea:	6105                	addi	sp,sp,32
  8006ec:	8082                	ret
  8006ee:	85a2                	mv	a1,s0
  8006f0:	00000517          	auipc	a0,0x0
  8006f4:	55050513          	addi	a0,a0,1360 # 800c40 <error_string+0xc8>
  8006f8:	9ffff0ef          	jal	ra,8000f6 <cprintf>
  8006fc:	4501                	li	a0,0
  8006fe:	aa1ff0ef          	jal	ra,80019e <exit>
  800702:	00000617          	auipc	a2,0x0
  800706:	57e60613          	addi	a2,a2,1406 # 800c80 <error_string+0x108>
  80070a:	45dd                	li	a1,23
  80070c:	00000517          	auipc	a0,0x0
  800710:	56450513          	addi	a0,a0,1380 # 800c70 <error_string+0xf8>
  800714:	91dff0ef          	jal	ra,800030 <__panic>
  800718:	00000697          	auipc	a3,0x0
  80071c:	53868693          	addi	a3,a3,1336 # 800c50 <error_string+0xd8>
  800720:	00000617          	auipc	a2,0x0
  800724:	53860613          	addi	a2,a2,1336 # 800c58 <error_string+0xe0>
  800728:	45b9                	li	a1,14
  80072a:	00000517          	auipc	a0,0x0
  80072e:	54650513          	addi	a0,a0,1350 # 800c70 <error_string+0xf8>
  800732:	8ffff0ef          	jal	ra,800030 <__panic>
  800736:	00000617          	auipc	a2,0x0
  80073a:	56260613          	addi	a2,a2,1378 # 800c98 <error_string+0x120>
  80073e:	45f1                	li	a1,28
  800740:	00000517          	auipc	a0,0x0
  800744:	53050513          	addi	a0,a0,1328 # 800c70 <error_string+0xf8>
  800748:	8e9ff0ef          	jal	ra,800030 <__panic>
