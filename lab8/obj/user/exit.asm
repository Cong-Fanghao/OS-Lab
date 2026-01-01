
obj/__user_exit.out:     file format elf64-littleriscv


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
  80002a:	1de000ef          	jal	ra,800208 <umain>
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
  800044:	78050513          	addi	a0,a0,1920 # 8007c0 <main+0x114>
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
  800064:	7d850513          	addi	a0,a0,2008 # 800838 <main+0x18c>
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
  800086:	75e50513          	addi	a0,a0,1886 # 8007e0 <main+0x134>
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
  8000a6:	79650513          	addi	a0,a0,1942 # 800838 <main+0x18c>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	208000ef          	jal	ra,8002f2 <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1cc000ef          	jal	ra,8002f2 <vprintfmt>
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
  8001ae:	65650513          	addi	a0,a0,1622 # 800800 <main+0x154>
  8001b2:	f45ff0ef          	jal	ra,8000f6 <cprintf>
  8001b6:	a001                	j	8001b6 <exit+0x14>

00000000008001b8 <fork>:
  8001b8:	bf65                	j	800170 <sys_fork>

00000000008001ba <wait>:
  8001ba:	4581                	li	a1,0
  8001bc:	4501                	li	a0,0
  8001be:	bf5d                	j	800174 <sys_wait>

00000000008001c0 <waitpid>:
  8001c0:	bf55                	j	800174 <sys_wait>

00000000008001c2 <yield>:
  8001c2:	bf6d                	j	80017c <sys_yield>

00000000008001c4 <initfd>:
  8001c4:	1101                	addi	sp,sp,-32
  8001c6:	87ae                	mv	a5,a1
  8001c8:	e426                	sd	s1,8(sp)
  8001ca:	85b2                	mv	a1,a2
  8001cc:	84aa                	mv	s1,a0
  8001ce:	853e                	mv	a0,a5
  8001d0:	e822                	sd	s0,16(sp)
  8001d2:	ec06                	sd	ra,24(sp)
  8001d4:	e4dff0ef          	jal	ra,800020 <open>
  8001d8:	842a                	mv	s0,a0
  8001da:	00054463          	bltz	a0,8001e2 <initfd+0x1e>
  8001de:	00951863          	bne	a0,s1,8001ee <initfd+0x2a>
  8001e2:	60e2                	ld	ra,24(sp)
  8001e4:	8522                	mv	a0,s0
  8001e6:	6442                	ld	s0,16(sp)
  8001e8:	64a2                	ld	s1,8(sp)
  8001ea:	6105                	addi	sp,sp,32
  8001ec:	8082                	ret
  8001ee:	8526                	mv	a0,s1
  8001f0:	e37ff0ef          	jal	ra,800026 <close>
  8001f4:	85a6                	mv	a1,s1
  8001f6:	8522                	mv	a0,s0
  8001f8:	e31ff0ef          	jal	ra,800028 <dup2>
  8001fc:	84aa                	mv	s1,a0
  8001fe:	8522                	mv	a0,s0
  800200:	e27ff0ef          	jal	ra,800026 <close>
  800204:	8426                	mv	s0,s1
  800206:	bff1                	j	8001e2 <initfd+0x1e>

0000000000800208 <umain>:
  800208:	1101                	addi	sp,sp,-32
  80020a:	e822                	sd	s0,16(sp)
  80020c:	e426                	sd	s1,8(sp)
  80020e:	842a                	mv	s0,a0
  800210:	84ae                	mv	s1,a1
  800212:	4601                	li	a2,0
  800214:	00000597          	auipc	a1,0x0
  800218:	60458593          	addi	a1,a1,1540 # 800818 <main+0x16c>
  80021c:	4501                	li	a0,0
  80021e:	ec06                	sd	ra,24(sp)
  800220:	fa5ff0ef          	jal	ra,8001c4 <initfd>
  800224:	02054263          	bltz	a0,800248 <umain+0x40>
  800228:	4605                	li	a2,1
  80022a:	00000597          	auipc	a1,0x0
  80022e:	62e58593          	addi	a1,a1,1582 # 800858 <main+0x1ac>
  800232:	4505                	li	a0,1
  800234:	f91ff0ef          	jal	ra,8001c4 <initfd>
  800238:	02054563          	bltz	a0,800262 <umain+0x5a>
  80023c:	85a6                	mv	a1,s1
  80023e:	8522                	mv	a0,s0
  800240:	46c000ef          	jal	ra,8006ac <main>
  800244:	f5fff0ef          	jal	ra,8001a2 <exit>
  800248:	86aa                	mv	a3,a0
  80024a:	00000617          	auipc	a2,0x0
  80024e:	5d660613          	addi	a2,a2,1494 # 800820 <main+0x174>
  800252:	45e9                	li	a1,26
  800254:	00000517          	auipc	a0,0x0
  800258:	5ec50513          	addi	a0,a0,1516 # 800840 <main+0x194>
  80025c:	e17ff0ef          	jal	ra,800072 <__warn>
  800260:	b7e1                	j	800228 <umain+0x20>
  800262:	86aa                	mv	a3,a0
  800264:	00000617          	auipc	a2,0x0
  800268:	5fc60613          	addi	a2,a2,1532 # 800860 <main+0x1b4>
  80026c:	45f5                	li	a1,29
  80026e:	00000517          	auipc	a0,0x0
  800272:	5d250513          	addi	a0,a0,1490 # 800840 <main+0x194>
  800276:	dfdff0ef          	jal	ra,800072 <__warn>
  80027a:	b7c9                	j	80023c <umain+0x34>

000000000080027c <printnum>:
  80027c:	02071893          	slli	a7,a4,0x20
  800280:	7139                	addi	sp,sp,-64
  800282:	0208d893          	srli	a7,a7,0x20
  800286:	e456                	sd	s5,8(sp)
  800288:	0316fab3          	remu	s5,a3,a7
  80028c:	f822                	sd	s0,48(sp)
  80028e:	f426                	sd	s1,40(sp)
  800290:	f04a                	sd	s2,32(sp)
  800292:	ec4e                	sd	s3,24(sp)
  800294:	fc06                	sd	ra,56(sp)
  800296:	e852                	sd	s4,16(sp)
  800298:	84aa                	mv	s1,a0
  80029a:	89ae                	mv	s3,a1
  80029c:	8932                	mv	s2,a2
  80029e:	fff7841b          	addiw	s0,a5,-1
  8002a2:	2a81                	sext.w	s5,s5
  8002a4:	0516f163          	bgeu	a3,a7,8002e6 <printnum+0x6a>
  8002a8:	8a42                	mv	s4,a6
  8002aa:	00805863          	blez	s0,8002ba <printnum+0x3e>
  8002ae:	347d                	addiw	s0,s0,-1
  8002b0:	864e                	mv	a2,s3
  8002b2:	85ca                	mv	a1,s2
  8002b4:	8552                	mv	a0,s4
  8002b6:	9482                	jalr	s1
  8002b8:	f87d                	bnez	s0,8002ae <printnum+0x32>
  8002ba:	1a82                	slli	s5,s5,0x20
  8002bc:	00000797          	auipc	a5,0x0
  8002c0:	5c478793          	addi	a5,a5,1476 # 800880 <main+0x1d4>
  8002c4:	020ada93          	srli	s5,s5,0x20
  8002c8:	9abe                	add	s5,s5,a5
  8002ca:	7442                	ld	s0,48(sp)
  8002cc:	000ac503          	lbu	a0,0(s5)
  8002d0:	70e2                	ld	ra,56(sp)
  8002d2:	6a42                	ld	s4,16(sp)
  8002d4:	6aa2                	ld	s5,8(sp)
  8002d6:	864e                	mv	a2,s3
  8002d8:	85ca                	mv	a1,s2
  8002da:	69e2                	ld	s3,24(sp)
  8002dc:	7902                	ld	s2,32(sp)
  8002de:	87a6                	mv	a5,s1
  8002e0:	74a2                	ld	s1,40(sp)
  8002e2:	6121                	addi	sp,sp,64
  8002e4:	8782                	jr	a5
  8002e6:	0316d6b3          	divu	a3,a3,a7
  8002ea:	87a2                	mv	a5,s0
  8002ec:	f91ff0ef          	jal	ra,80027c <printnum>
  8002f0:	b7e9                	j	8002ba <printnum+0x3e>

00000000008002f2 <vprintfmt>:
  8002f2:	7119                	addi	sp,sp,-128
  8002f4:	f4a6                	sd	s1,104(sp)
  8002f6:	f0ca                	sd	s2,96(sp)
  8002f8:	ecce                	sd	s3,88(sp)
  8002fa:	e8d2                	sd	s4,80(sp)
  8002fc:	e4d6                	sd	s5,72(sp)
  8002fe:	e0da                	sd	s6,64(sp)
  800300:	fc5e                	sd	s7,56(sp)
  800302:	ec6e                	sd	s11,24(sp)
  800304:	fc86                	sd	ra,120(sp)
  800306:	f8a2                	sd	s0,112(sp)
  800308:	f862                	sd	s8,48(sp)
  80030a:	f466                	sd	s9,40(sp)
  80030c:	f06a                	sd	s10,32(sp)
  80030e:	89aa                	mv	s3,a0
  800310:	892e                	mv	s2,a1
  800312:	84b2                	mv	s1,a2
  800314:	8db6                	mv	s11,a3
  800316:	8aba                	mv	s5,a4
  800318:	02500a13          	li	s4,37
  80031c:	5bfd                	li	s7,-1
  80031e:	00000b17          	auipc	s6,0x0
  800322:	596b0b13          	addi	s6,s6,1430 # 8008b4 <main+0x208>
  800326:	000dc503          	lbu	a0,0(s11)
  80032a:	001d8413          	addi	s0,s11,1
  80032e:	01450b63          	beq	a0,s4,800344 <vprintfmt+0x52>
  800332:	c129                	beqz	a0,800374 <vprintfmt+0x82>
  800334:	864a                	mv	a2,s2
  800336:	85a6                	mv	a1,s1
  800338:	0405                	addi	s0,s0,1
  80033a:	9982                	jalr	s3
  80033c:	fff44503          	lbu	a0,-1(s0)
  800340:	ff4519e3          	bne	a0,s4,800332 <vprintfmt+0x40>
  800344:	00044583          	lbu	a1,0(s0)
  800348:	02000813          	li	a6,32
  80034c:	4d01                	li	s10,0
  80034e:	4301                	li	t1,0
  800350:	5cfd                	li	s9,-1
  800352:	5c7d                	li	s8,-1
  800354:	05500513          	li	a0,85
  800358:	48a5                	li	a7,9
  80035a:	fdd5861b          	addiw	a2,a1,-35
  80035e:	0ff67613          	zext.b	a2,a2
  800362:	00140d93          	addi	s11,s0,1
  800366:	04c56263          	bltu	a0,a2,8003aa <vprintfmt+0xb8>
  80036a:	060a                	slli	a2,a2,0x2
  80036c:	965a                	add	a2,a2,s6
  80036e:	4214                	lw	a3,0(a2)
  800370:	96da                	add	a3,a3,s6
  800372:	8682                	jr	a3
  800374:	70e6                	ld	ra,120(sp)
  800376:	7446                	ld	s0,112(sp)
  800378:	74a6                	ld	s1,104(sp)
  80037a:	7906                	ld	s2,96(sp)
  80037c:	69e6                	ld	s3,88(sp)
  80037e:	6a46                	ld	s4,80(sp)
  800380:	6aa6                	ld	s5,72(sp)
  800382:	6b06                	ld	s6,64(sp)
  800384:	7be2                	ld	s7,56(sp)
  800386:	7c42                	ld	s8,48(sp)
  800388:	7ca2                	ld	s9,40(sp)
  80038a:	7d02                	ld	s10,32(sp)
  80038c:	6de2                	ld	s11,24(sp)
  80038e:	6109                	addi	sp,sp,128
  800390:	8082                	ret
  800392:	882e                	mv	a6,a1
  800394:	00144583          	lbu	a1,1(s0)
  800398:	846e                	mv	s0,s11
  80039a:	00140d93          	addi	s11,s0,1
  80039e:	fdd5861b          	addiw	a2,a1,-35
  8003a2:	0ff67613          	zext.b	a2,a2
  8003a6:	fcc572e3          	bgeu	a0,a2,80036a <vprintfmt+0x78>
  8003aa:	864a                	mv	a2,s2
  8003ac:	85a6                	mv	a1,s1
  8003ae:	02500513          	li	a0,37
  8003b2:	9982                	jalr	s3
  8003b4:	fff44783          	lbu	a5,-1(s0)
  8003b8:	8da2                	mv	s11,s0
  8003ba:	f74786e3          	beq	a5,s4,800326 <vprintfmt+0x34>
  8003be:	ffedc783          	lbu	a5,-2(s11)
  8003c2:	1dfd                	addi	s11,s11,-1
  8003c4:	ff479de3          	bne	a5,s4,8003be <vprintfmt+0xcc>
  8003c8:	bfb9                	j	800326 <vprintfmt+0x34>
  8003ca:	fd058c9b          	addiw	s9,a1,-48
  8003ce:	00144583          	lbu	a1,1(s0)
  8003d2:	846e                	mv	s0,s11
  8003d4:	fd05869b          	addiw	a3,a1,-48
  8003d8:	0005861b          	sext.w	a2,a1
  8003dc:	02d8e463          	bltu	a7,a3,800404 <vprintfmt+0x112>
  8003e0:	00144583          	lbu	a1,1(s0)
  8003e4:	002c969b          	slliw	a3,s9,0x2
  8003e8:	0196873b          	addw	a4,a3,s9
  8003ec:	0017171b          	slliw	a4,a4,0x1
  8003f0:	9f31                	addw	a4,a4,a2
  8003f2:	fd05869b          	addiw	a3,a1,-48
  8003f6:	0405                	addi	s0,s0,1
  8003f8:	fd070c9b          	addiw	s9,a4,-48
  8003fc:	0005861b          	sext.w	a2,a1
  800400:	fed8f0e3          	bgeu	a7,a3,8003e0 <vprintfmt+0xee>
  800404:	f40c5be3          	bgez	s8,80035a <vprintfmt+0x68>
  800408:	8c66                	mv	s8,s9
  80040a:	5cfd                	li	s9,-1
  80040c:	b7b9                	j	80035a <vprintfmt+0x68>
  80040e:	fffc4693          	not	a3,s8
  800412:	96fd                	srai	a3,a3,0x3f
  800414:	00dc77b3          	and	a5,s8,a3
  800418:	00144583          	lbu	a1,1(s0)
  80041c:	00078c1b          	sext.w	s8,a5
  800420:	846e                	mv	s0,s11
  800422:	bf25                	j	80035a <vprintfmt+0x68>
  800424:	000aac83          	lw	s9,0(s5)
  800428:	00144583          	lbu	a1,1(s0)
  80042c:	0aa1                	addi	s5,s5,8
  80042e:	846e                	mv	s0,s11
  800430:	bfd1                	j	800404 <vprintfmt+0x112>
  800432:	4705                	li	a4,1
  800434:	008a8613          	addi	a2,s5,8
  800438:	00674463          	blt	a4,t1,800440 <vprintfmt+0x14e>
  80043c:	1c030c63          	beqz	t1,800614 <vprintfmt+0x322>
  800440:	000ab683          	ld	a3,0(s5)
  800444:	4741                	li	a4,16
  800446:	8ab2                	mv	s5,a2
  800448:	2801                	sext.w	a6,a6
  80044a:	87e2                	mv	a5,s8
  80044c:	8626                	mv	a2,s1
  80044e:	85ca                	mv	a1,s2
  800450:	854e                	mv	a0,s3
  800452:	e2bff0ef          	jal	ra,80027c <printnum>
  800456:	bdc1                	j	800326 <vprintfmt+0x34>
  800458:	000aa503          	lw	a0,0(s5)
  80045c:	864a                	mv	a2,s2
  80045e:	85a6                	mv	a1,s1
  800460:	0aa1                	addi	s5,s5,8
  800462:	9982                	jalr	s3
  800464:	b5c9                	j	800326 <vprintfmt+0x34>
  800466:	4705                	li	a4,1
  800468:	008a8613          	addi	a2,s5,8
  80046c:	00674463          	blt	a4,t1,800474 <vprintfmt+0x182>
  800470:	18030d63          	beqz	t1,80060a <vprintfmt+0x318>
  800474:	000ab683          	ld	a3,0(s5)
  800478:	4729                	li	a4,10
  80047a:	8ab2                	mv	s5,a2
  80047c:	b7f1                	j	800448 <vprintfmt+0x156>
  80047e:	00144583          	lbu	a1,1(s0)
  800482:	4d05                	li	s10,1
  800484:	846e                	mv	s0,s11
  800486:	bdd1                	j	80035a <vprintfmt+0x68>
  800488:	864a                	mv	a2,s2
  80048a:	85a6                	mv	a1,s1
  80048c:	02500513          	li	a0,37
  800490:	9982                	jalr	s3
  800492:	bd51                	j	800326 <vprintfmt+0x34>
  800494:	00144583          	lbu	a1,1(s0)
  800498:	2305                	addiw	t1,t1,1
  80049a:	846e                	mv	s0,s11
  80049c:	bd7d                	j	80035a <vprintfmt+0x68>
  80049e:	4705                	li	a4,1
  8004a0:	008a8613          	addi	a2,s5,8
  8004a4:	00674463          	blt	a4,t1,8004ac <vprintfmt+0x1ba>
  8004a8:	14030c63          	beqz	t1,800600 <vprintfmt+0x30e>
  8004ac:	000ab683          	ld	a3,0(s5)
  8004b0:	4721                	li	a4,8
  8004b2:	8ab2                	mv	s5,a2
  8004b4:	bf51                	j	800448 <vprintfmt+0x156>
  8004b6:	03000513          	li	a0,48
  8004ba:	864a                	mv	a2,s2
  8004bc:	85a6                	mv	a1,s1
  8004be:	e042                	sd	a6,0(sp)
  8004c0:	9982                	jalr	s3
  8004c2:	864a                	mv	a2,s2
  8004c4:	85a6                	mv	a1,s1
  8004c6:	07800513          	li	a0,120
  8004ca:	9982                	jalr	s3
  8004cc:	0aa1                	addi	s5,s5,8
  8004ce:	6802                	ld	a6,0(sp)
  8004d0:	4741                	li	a4,16
  8004d2:	ff8ab683          	ld	a3,-8(s5)
  8004d6:	bf8d                	j	800448 <vprintfmt+0x156>
  8004d8:	000ab403          	ld	s0,0(s5)
  8004dc:	008a8793          	addi	a5,s5,8
  8004e0:	e03e                	sd	a5,0(sp)
  8004e2:	14040c63          	beqz	s0,80063a <vprintfmt+0x348>
  8004e6:	11805063          	blez	s8,8005e6 <vprintfmt+0x2f4>
  8004ea:	02d00693          	li	a3,45
  8004ee:	0cd81963          	bne	a6,a3,8005c0 <vprintfmt+0x2ce>
  8004f2:	00044683          	lbu	a3,0(s0)
  8004f6:	0006851b          	sext.w	a0,a3
  8004fa:	ce8d                	beqz	a3,800534 <vprintfmt+0x242>
  8004fc:	00140a93          	addi	s5,s0,1
  800500:	05e00413          	li	s0,94
  800504:	000cc563          	bltz	s9,80050e <vprintfmt+0x21c>
  800508:	3cfd                	addiw	s9,s9,-1
  80050a:	037c8363          	beq	s9,s7,800530 <vprintfmt+0x23e>
  80050e:	864a                	mv	a2,s2
  800510:	85a6                	mv	a1,s1
  800512:	100d0663          	beqz	s10,80061e <vprintfmt+0x32c>
  800516:	3681                	addiw	a3,a3,-32
  800518:	10d47363          	bgeu	s0,a3,80061e <vprintfmt+0x32c>
  80051c:	03f00513          	li	a0,63
  800520:	9982                	jalr	s3
  800522:	000ac683          	lbu	a3,0(s5)
  800526:	3c7d                	addiw	s8,s8,-1
  800528:	0a85                	addi	s5,s5,1
  80052a:	0006851b          	sext.w	a0,a3
  80052e:	faf9                	bnez	a3,800504 <vprintfmt+0x212>
  800530:	01805a63          	blez	s8,800544 <vprintfmt+0x252>
  800534:	3c7d                	addiw	s8,s8,-1
  800536:	864a                	mv	a2,s2
  800538:	85a6                	mv	a1,s1
  80053a:	02000513          	li	a0,32
  80053e:	9982                	jalr	s3
  800540:	fe0c1ae3          	bnez	s8,800534 <vprintfmt+0x242>
  800544:	6a82                	ld	s5,0(sp)
  800546:	b3c5                	j	800326 <vprintfmt+0x34>
  800548:	4705                	li	a4,1
  80054a:	008a8d13          	addi	s10,s5,8
  80054e:	00674463          	blt	a4,t1,800556 <vprintfmt+0x264>
  800552:	0a030463          	beqz	t1,8005fa <vprintfmt+0x308>
  800556:	000ab403          	ld	s0,0(s5)
  80055a:	0c044463          	bltz	s0,800622 <vprintfmt+0x330>
  80055e:	86a2                	mv	a3,s0
  800560:	8aea                	mv	s5,s10
  800562:	4729                	li	a4,10
  800564:	b5d5                	j	800448 <vprintfmt+0x156>
  800566:	000aa783          	lw	a5,0(s5)
  80056a:	46e1                	li	a3,24
  80056c:	0aa1                	addi	s5,s5,8
  80056e:	41f7d71b          	sraiw	a4,a5,0x1f
  800572:	8fb9                	xor	a5,a5,a4
  800574:	40e7873b          	subw	a4,a5,a4
  800578:	02e6c663          	blt	a3,a4,8005a4 <vprintfmt+0x2b2>
  80057c:	00371793          	slli	a5,a4,0x3
  800580:	00000697          	auipc	a3,0x0
  800584:	66868693          	addi	a3,a3,1640 # 800be8 <error_string>
  800588:	97b6                	add	a5,a5,a3
  80058a:	639c                	ld	a5,0(a5)
  80058c:	cf81                	beqz	a5,8005a4 <vprintfmt+0x2b2>
  80058e:	873e                	mv	a4,a5
  800590:	00000697          	auipc	a3,0x0
  800594:	32068693          	addi	a3,a3,800 # 8008b0 <main+0x204>
  800598:	8626                	mv	a2,s1
  80059a:	85ca                	mv	a1,s2
  80059c:	854e                	mv	a0,s3
  80059e:	0d4000ef          	jal	ra,800672 <printfmt>
  8005a2:	b351                	j	800326 <vprintfmt+0x34>
  8005a4:	00000697          	auipc	a3,0x0
  8005a8:	2fc68693          	addi	a3,a3,764 # 8008a0 <main+0x1f4>
  8005ac:	8626                	mv	a2,s1
  8005ae:	85ca                	mv	a1,s2
  8005b0:	854e                	mv	a0,s3
  8005b2:	0c0000ef          	jal	ra,800672 <printfmt>
  8005b6:	bb85                	j	800326 <vprintfmt+0x34>
  8005b8:	00000417          	auipc	s0,0x0
  8005bc:	2e040413          	addi	s0,s0,736 # 800898 <main+0x1ec>
  8005c0:	85e6                	mv	a1,s9
  8005c2:	8522                	mv	a0,s0
  8005c4:	e442                	sd	a6,8(sp)
  8005c6:	0ca000ef          	jal	ra,800690 <strnlen>
  8005ca:	40ac0c3b          	subw	s8,s8,a0
  8005ce:	01805c63          	blez	s8,8005e6 <vprintfmt+0x2f4>
  8005d2:	6822                	ld	a6,8(sp)
  8005d4:	00080a9b          	sext.w	s5,a6
  8005d8:	3c7d                	addiw	s8,s8,-1
  8005da:	864a                	mv	a2,s2
  8005dc:	85a6                	mv	a1,s1
  8005de:	8556                	mv	a0,s5
  8005e0:	9982                	jalr	s3
  8005e2:	fe0c1be3          	bnez	s8,8005d8 <vprintfmt+0x2e6>
  8005e6:	00044683          	lbu	a3,0(s0)
  8005ea:	00140a93          	addi	s5,s0,1
  8005ee:	0006851b          	sext.w	a0,a3
  8005f2:	daa9                	beqz	a3,800544 <vprintfmt+0x252>
  8005f4:	05e00413          	li	s0,94
  8005f8:	b731                	j	800504 <vprintfmt+0x212>
  8005fa:	000aa403          	lw	s0,0(s5)
  8005fe:	bfb1                	j	80055a <vprintfmt+0x268>
  800600:	000ae683          	lwu	a3,0(s5)
  800604:	4721                	li	a4,8
  800606:	8ab2                	mv	s5,a2
  800608:	b581                	j	800448 <vprintfmt+0x156>
  80060a:	000ae683          	lwu	a3,0(s5)
  80060e:	4729                	li	a4,10
  800610:	8ab2                	mv	s5,a2
  800612:	bd1d                	j	800448 <vprintfmt+0x156>
  800614:	000ae683          	lwu	a3,0(s5)
  800618:	4741                	li	a4,16
  80061a:	8ab2                	mv	s5,a2
  80061c:	b535                	j	800448 <vprintfmt+0x156>
  80061e:	9982                	jalr	s3
  800620:	b709                	j	800522 <vprintfmt+0x230>
  800622:	864a                	mv	a2,s2
  800624:	85a6                	mv	a1,s1
  800626:	02d00513          	li	a0,45
  80062a:	e042                	sd	a6,0(sp)
  80062c:	9982                	jalr	s3
  80062e:	6802                	ld	a6,0(sp)
  800630:	8aea                	mv	s5,s10
  800632:	408006b3          	neg	a3,s0
  800636:	4729                	li	a4,10
  800638:	bd01                	j	800448 <vprintfmt+0x156>
  80063a:	03805163          	blez	s8,80065c <vprintfmt+0x36a>
  80063e:	02d00693          	li	a3,45
  800642:	f6d81be3          	bne	a6,a3,8005b8 <vprintfmt+0x2c6>
  800646:	00000417          	auipc	s0,0x0
  80064a:	25240413          	addi	s0,s0,594 # 800898 <main+0x1ec>
  80064e:	02800693          	li	a3,40
  800652:	02800513          	li	a0,40
  800656:	00140a93          	addi	s5,s0,1
  80065a:	b55d                	j	800500 <vprintfmt+0x20e>
  80065c:	00000a97          	auipc	s5,0x0
  800660:	23da8a93          	addi	s5,s5,573 # 800899 <main+0x1ed>
  800664:	02800513          	li	a0,40
  800668:	02800693          	li	a3,40
  80066c:	05e00413          	li	s0,94
  800670:	bd51                	j	800504 <vprintfmt+0x212>

0000000000800672 <printfmt>:
  800672:	7139                	addi	sp,sp,-64
  800674:	02010313          	addi	t1,sp,32
  800678:	f03a                	sd	a4,32(sp)
  80067a:	871a                	mv	a4,t1
  80067c:	ec06                	sd	ra,24(sp)
  80067e:	f43e                	sd	a5,40(sp)
  800680:	f842                	sd	a6,48(sp)
  800682:	fc46                	sd	a7,56(sp)
  800684:	e41a                	sd	t1,8(sp)
  800686:	c6dff0ef          	jal	ra,8002f2 <vprintfmt>
  80068a:	60e2                	ld	ra,24(sp)
  80068c:	6121                	addi	sp,sp,64
  80068e:	8082                	ret

0000000000800690 <strnlen>:
  800690:	4781                	li	a5,0
  800692:	e589                	bnez	a1,80069c <strnlen+0xc>
  800694:	a811                	j	8006a8 <strnlen+0x18>
  800696:	0785                	addi	a5,a5,1
  800698:	00f58863          	beq	a1,a5,8006a8 <strnlen+0x18>
  80069c:	00f50733          	add	a4,a0,a5
  8006a0:	00074703          	lbu	a4,0(a4)
  8006a4:	fb6d                	bnez	a4,800696 <strnlen+0x6>
  8006a6:	85be                	mv	a1,a5
  8006a8:	852e                	mv	a0,a1
  8006aa:	8082                	ret

00000000008006ac <main>:
  8006ac:	1101                	addi	sp,sp,-32
  8006ae:	00000517          	auipc	a0,0x0
  8006b2:	60250513          	addi	a0,a0,1538 # 800cb0 <error_string+0xc8>
  8006b6:	ec06                	sd	ra,24(sp)
  8006b8:	e822                	sd	s0,16(sp)
  8006ba:	a3dff0ef          	jal	ra,8000f6 <cprintf>
  8006be:	afbff0ef          	jal	ra,8001b8 <fork>
  8006c2:	c561                	beqz	a0,80078a <main+0xde>
  8006c4:	842a                	mv	s0,a0
  8006c6:	85aa                	mv	a1,a0
  8006c8:	00000517          	auipc	a0,0x0
  8006cc:	62850513          	addi	a0,a0,1576 # 800cf0 <error_string+0x108>
  8006d0:	a27ff0ef          	jal	ra,8000f6 <cprintf>
  8006d4:	08805c63          	blez	s0,80076c <main+0xc0>
  8006d8:	00000517          	auipc	a0,0x0
  8006dc:	67050513          	addi	a0,a0,1648 # 800d48 <error_string+0x160>
  8006e0:	a17ff0ef          	jal	ra,8000f6 <cprintf>
  8006e4:	006c                	addi	a1,sp,12
  8006e6:	8522                	mv	a0,s0
  8006e8:	ad9ff0ef          	jal	ra,8001c0 <waitpid>
  8006ec:	e131                	bnez	a0,800730 <main+0x84>
  8006ee:	4732                	lw	a4,12(sp)
  8006f0:	00001797          	auipc	a5,0x1
  8006f4:	9107a783          	lw	a5,-1776(a5) # 801000 <magic>
  8006f8:	02f71c63          	bne	a4,a5,800730 <main+0x84>
  8006fc:	006c                	addi	a1,sp,12
  8006fe:	8522                	mv	a0,s0
  800700:	ac1ff0ef          	jal	ra,8001c0 <waitpid>
  800704:	c529                	beqz	a0,80074e <main+0xa2>
  800706:	ab5ff0ef          	jal	ra,8001ba <wait>
  80070a:	c131                	beqz	a0,80074e <main+0xa2>
  80070c:	85a2                	mv	a1,s0
  80070e:	00000517          	auipc	a0,0x0
  800712:	6b250513          	addi	a0,a0,1714 # 800dc0 <error_string+0x1d8>
  800716:	9e1ff0ef          	jal	ra,8000f6 <cprintf>
  80071a:	00000517          	auipc	a0,0x0
  80071e:	6b650513          	addi	a0,a0,1718 # 800dd0 <error_string+0x1e8>
  800722:	9d5ff0ef          	jal	ra,8000f6 <cprintf>
  800726:	60e2                	ld	ra,24(sp)
  800728:	6442                	ld	s0,16(sp)
  80072a:	4501                	li	a0,0
  80072c:	6105                	addi	sp,sp,32
  80072e:	8082                	ret
  800730:	00000697          	auipc	a3,0x0
  800734:	63868693          	addi	a3,a3,1592 # 800d68 <error_string+0x180>
  800738:	00000617          	auipc	a2,0x0
  80073c:	5e860613          	addi	a2,a2,1512 # 800d20 <error_string+0x138>
  800740:	45ed                	li	a1,27
  800742:	00000517          	auipc	a0,0x0
  800746:	5f650513          	addi	a0,a0,1526 # 800d38 <error_string+0x150>
  80074a:	8e7ff0ef          	jal	ra,800030 <__panic>
  80074e:	00000697          	auipc	a3,0x0
  800752:	64a68693          	addi	a3,a3,1610 # 800d98 <error_string+0x1b0>
  800756:	00000617          	auipc	a2,0x0
  80075a:	5ca60613          	addi	a2,a2,1482 # 800d20 <error_string+0x138>
  80075e:	45f1                	li	a1,28
  800760:	00000517          	auipc	a0,0x0
  800764:	5d850513          	addi	a0,a0,1496 # 800d38 <error_string+0x150>
  800768:	8c9ff0ef          	jal	ra,800030 <__panic>
  80076c:	00000697          	auipc	a3,0x0
  800770:	5ac68693          	addi	a3,a3,1452 # 800d18 <error_string+0x130>
  800774:	00000617          	auipc	a2,0x0
  800778:	5ac60613          	addi	a2,a2,1452 # 800d20 <error_string+0x138>
  80077c:	45e1                	li	a1,24
  80077e:	00000517          	auipc	a0,0x0
  800782:	5ba50513          	addi	a0,a0,1466 # 800d38 <error_string+0x150>
  800786:	8abff0ef          	jal	ra,800030 <__panic>
  80078a:	00000517          	auipc	a0,0x0
  80078e:	54e50513          	addi	a0,a0,1358 # 800cd8 <error_string+0xf0>
  800792:	965ff0ef          	jal	ra,8000f6 <cprintf>
  800796:	a2dff0ef          	jal	ra,8001c2 <yield>
  80079a:	a29ff0ef          	jal	ra,8001c2 <yield>
  80079e:	a25ff0ef          	jal	ra,8001c2 <yield>
  8007a2:	a21ff0ef          	jal	ra,8001c2 <yield>
  8007a6:	a1dff0ef          	jal	ra,8001c2 <yield>
  8007aa:	a19ff0ef          	jal	ra,8001c2 <yield>
  8007ae:	a15ff0ef          	jal	ra,8001c2 <yield>
  8007b2:	00001517          	auipc	a0,0x1
  8007b6:	84e52503          	lw	a0,-1970(a0) # 801000 <magic>
  8007ba:	9e9ff0ef          	jal	ra,8001a2 <exit>
