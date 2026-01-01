
obj/__user_matrix.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a2b5                	j	800190 <sys_open>

0000000000800026 <close>:
  800026:	aa95                	j	80019a <sys_close>

0000000000800028 <dup2>:
  800028:	aaad                	j	8001a2 <sys_dup>

000000000080002a <_start>:
  80002a:	1ea000ef          	jal	ra,800214 <umain>
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
  800040:	00001517          	auipc	a0,0x1
  800044:	8b050513          	addi	a0,a0,-1872 # 8008f0 <main+0xc6>
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
  800060:	00001517          	auipc	a0,0x1
  800064:	90850513          	addi	a0,a0,-1784 # 800968 <main+0x13e>
  800068:	08e000ef          	jal	ra,8000f6 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	13e000ef          	jal	ra,8001ac <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	832e                	mv	t1,a1
  800076:	e822                	sd	s0,16(sp)
  800078:	85aa                	mv	a1,a0
  80007a:	8432                	mv	s0,a2
  80007c:	fc3e                	sd	a5,56(sp)
  80007e:	861a                	mv	a2,t1
  800080:	103c                	addi	a5,sp,40
  800082:	00001517          	auipc	a0,0x1
  800086:	88e50513          	addi	a0,a0,-1906 # 800910 <main+0xe6>
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
  8000a2:	00001517          	auipc	a0,0x1
  8000a6:	8c650513          	addi	a0,a0,-1850 # 800968 <main+0x13e>
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
  8000be:	0cc000ef          	jal	ra,80018a <sys_putc>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <matc+0xffffffffff7f57b1>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	214000ef          	jal	ra,8002fe <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <matc+0xffffffffff7f57b1>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1d8000ef          	jal	ra,8002fe <vprintfmt>
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

0000000000800186 <sys_getpid>:
  800186:	4549                	li	a0,18
  800188:	b76d                	j	800132 <syscall>

000000000080018a <sys_putc>:
  80018a:	85aa                	mv	a1,a0
  80018c:	4579                	li	a0,30
  80018e:	b755                	j	800132 <syscall>

0000000000800190 <sys_open>:
  800190:	862e                	mv	a2,a1
  800192:	85aa                	mv	a1,a0
  800194:	06400513          	li	a0,100
  800198:	bf69                	j	800132 <syscall>

000000000080019a <sys_close>:
  80019a:	85aa                	mv	a1,a0
  80019c:	06500513          	li	a0,101
  8001a0:	bf49                	j	800132 <syscall>

00000000008001a2 <sys_dup>:
  8001a2:	862e                	mv	a2,a1
  8001a4:	85aa                	mv	a1,a0
  8001a6:	08200513          	li	a0,130
  8001aa:	b761                	j	800132 <syscall>

00000000008001ac <exit>:
  8001ac:	1141                	addi	sp,sp,-16
  8001ae:	e406                	sd	ra,8(sp)
  8001b0:	fbbff0ef          	jal	ra,80016a <sys_exit>
  8001b4:	00000517          	auipc	a0,0x0
  8001b8:	77c50513          	addi	a0,a0,1916 # 800930 <main+0x106>
  8001bc:	f3bff0ef          	jal	ra,8000f6 <cprintf>
  8001c0:	a001                	j	8001c0 <exit+0x14>

00000000008001c2 <fork>:
  8001c2:	b77d                	j	800170 <sys_fork>

00000000008001c4 <wait>:
  8001c4:	4581                	li	a1,0
  8001c6:	4501                	li	a0,0
  8001c8:	b775                	j	800174 <sys_wait>

00000000008001ca <yield>:
  8001ca:	bf4d                	j	80017c <sys_yield>

00000000008001cc <kill>:
  8001cc:	bf55                	j	800180 <sys_kill>

00000000008001ce <getpid>:
  8001ce:	bf65                	j	800186 <sys_getpid>

00000000008001d0 <initfd>:
  8001d0:	1101                	addi	sp,sp,-32
  8001d2:	87ae                	mv	a5,a1
  8001d4:	e426                	sd	s1,8(sp)
  8001d6:	85b2                	mv	a1,a2
  8001d8:	84aa                	mv	s1,a0
  8001da:	853e                	mv	a0,a5
  8001dc:	e822                	sd	s0,16(sp)
  8001de:	ec06                	sd	ra,24(sp)
  8001e0:	e41ff0ef          	jal	ra,800020 <open>
  8001e4:	842a                	mv	s0,a0
  8001e6:	00054463          	bltz	a0,8001ee <initfd+0x1e>
  8001ea:	00951863          	bne	a0,s1,8001fa <initfd+0x2a>
  8001ee:	60e2                	ld	ra,24(sp)
  8001f0:	8522                	mv	a0,s0
  8001f2:	6442                	ld	s0,16(sp)
  8001f4:	64a2                	ld	s1,8(sp)
  8001f6:	6105                	addi	sp,sp,32
  8001f8:	8082                	ret
  8001fa:	8526                	mv	a0,s1
  8001fc:	e2bff0ef          	jal	ra,800026 <close>
  800200:	85a6                	mv	a1,s1
  800202:	8522                	mv	a0,s0
  800204:	e25ff0ef          	jal	ra,800028 <dup2>
  800208:	84aa                	mv	s1,a0
  80020a:	8522                	mv	a0,s0
  80020c:	e1bff0ef          	jal	ra,800026 <close>
  800210:	8426                	mv	s0,s1
  800212:	bff1                	j	8001ee <initfd+0x1e>

0000000000800214 <umain>:
  800214:	1101                	addi	sp,sp,-32
  800216:	e822                	sd	s0,16(sp)
  800218:	e426                	sd	s1,8(sp)
  80021a:	842a                	mv	s0,a0
  80021c:	84ae                	mv	s1,a1
  80021e:	4601                	li	a2,0
  800220:	00000597          	auipc	a1,0x0
  800224:	72858593          	addi	a1,a1,1832 # 800948 <main+0x11e>
  800228:	4501                	li	a0,0
  80022a:	ec06                	sd	ra,24(sp)
  80022c:	fa5ff0ef          	jal	ra,8001d0 <initfd>
  800230:	02054263          	bltz	a0,800254 <umain+0x40>
  800234:	4605                	li	a2,1
  800236:	00000597          	auipc	a1,0x0
  80023a:	75258593          	addi	a1,a1,1874 # 800988 <main+0x15e>
  80023e:	4505                	li	a0,1
  800240:	f91ff0ef          	jal	ra,8001d0 <initfd>
  800244:	02054563          	bltz	a0,80026e <umain+0x5a>
  800248:	85a6                	mv	a1,s1
  80024a:	8522                	mv	a0,s0
  80024c:	5de000ef          	jal	ra,80082a <main>
  800250:	f5dff0ef          	jal	ra,8001ac <exit>
  800254:	86aa                	mv	a3,a0
  800256:	00000617          	auipc	a2,0x0
  80025a:	6fa60613          	addi	a2,a2,1786 # 800950 <main+0x126>
  80025e:	45e9                	li	a1,26
  800260:	00000517          	auipc	a0,0x0
  800264:	71050513          	addi	a0,a0,1808 # 800970 <main+0x146>
  800268:	e0bff0ef          	jal	ra,800072 <__warn>
  80026c:	b7e1                	j	800234 <umain+0x20>
  80026e:	86aa                	mv	a3,a0
  800270:	00000617          	auipc	a2,0x0
  800274:	72060613          	addi	a2,a2,1824 # 800990 <main+0x166>
  800278:	45f5                	li	a1,29
  80027a:	00000517          	auipc	a0,0x0
  80027e:	6f650513          	addi	a0,a0,1782 # 800970 <main+0x146>
  800282:	df1ff0ef          	jal	ra,800072 <__warn>
  800286:	b7c9                	j	800248 <umain+0x34>

0000000000800288 <printnum>:
  800288:	02071893          	slli	a7,a4,0x20
  80028c:	7139                	addi	sp,sp,-64
  80028e:	0208d893          	srli	a7,a7,0x20
  800292:	e456                	sd	s5,8(sp)
  800294:	0316fab3          	remu	s5,a3,a7
  800298:	f822                	sd	s0,48(sp)
  80029a:	f426                	sd	s1,40(sp)
  80029c:	f04a                	sd	s2,32(sp)
  80029e:	ec4e                	sd	s3,24(sp)
  8002a0:	fc06                	sd	ra,56(sp)
  8002a2:	e852                	sd	s4,16(sp)
  8002a4:	84aa                	mv	s1,a0
  8002a6:	89ae                	mv	s3,a1
  8002a8:	8932                	mv	s2,a2
  8002aa:	fff7841b          	addiw	s0,a5,-1
  8002ae:	2a81                	sext.w	s5,s5
  8002b0:	0516f163          	bgeu	a3,a7,8002f2 <printnum+0x6a>
  8002b4:	8a42                	mv	s4,a6
  8002b6:	00805863          	blez	s0,8002c6 <printnum+0x3e>
  8002ba:	347d                	addiw	s0,s0,-1
  8002bc:	864e                	mv	a2,s3
  8002be:	85ca                	mv	a1,s2
  8002c0:	8552                	mv	a0,s4
  8002c2:	9482                	jalr	s1
  8002c4:	f87d                	bnez	s0,8002ba <printnum+0x32>
  8002c6:	1a82                	slli	s5,s5,0x20
  8002c8:	00000797          	auipc	a5,0x0
  8002cc:	6e878793          	addi	a5,a5,1768 # 8009b0 <main+0x186>
  8002d0:	020ada93          	srli	s5,s5,0x20
  8002d4:	9abe                	add	s5,s5,a5
  8002d6:	7442                	ld	s0,48(sp)
  8002d8:	000ac503          	lbu	a0,0(s5)
  8002dc:	70e2                	ld	ra,56(sp)
  8002de:	6a42                	ld	s4,16(sp)
  8002e0:	6aa2                	ld	s5,8(sp)
  8002e2:	864e                	mv	a2,s3
  8002e4:	85ca                	mv	a1,s2
  8002e6:	69e2                	ld	s3,24(sp)
  8002e8:	7902                	ld	s2,32(sp)
  8002ea:	87a6                	mv	a5,s1
  8002ec:	74a2                	ld	s1,40(sp)
  8002ee:	6121                	addi	sp,sp,64
  8002f0:	8782                	jr	a5
  8002f2:	0316d6b3          	divu	a3,a3,a7
  8002f6:	87a2                	mv	a5,s0
  8002f8:	f91ff0ef          	jal	ra,800288 <printnum>
  8002fc:	b7e9                	j	8002c6 <printnum+0x3e>

00000000008002fe <vprintfmt>:
  8002fe:	7119                	addi	sp,sp,-128
  800300:	f4a6                	sd	s1,104(sp)
  800302:	f0ca                	sd	s2,96(sp)
  800304:	ecce                	sd	s3,88(sp)
  800306:	e8d2                	sd	s4,80(sp)
  800308:	e4d6                	sd	s5,72(sp)
  80030a:	e0da                	sd	s6,64(sp)
  80030c:	fc5e                	sd	s7,56(sp)
  80030e:	ec6e                	sd	s11,24(sp)
  800310:	fc86                	sd	ra,120(sp)
  800312:	f8a2                	sd	s0,112(sp)
  800314:	f862                	sd	s8,48(sp)
  800316:	f466                	sd	s9,40(sp)
  800318:	f06a                	sd	s10,32(sp)
  80031a:	89aa                	mv	s3,a0
  80031c:	892e                	mv	s2,a1
  80031e:	84b2                	mv	s1,a2
  800320:	8db6                	mv	s11,a3
  800322:	8aba                	mv	s5,a4
  800324:	02500a13          	li	s4,37
  800328:	5bfd                	li	s7,-1
  80032a:	00000b17          	auipc	s6,0x0
  80032e:	6bab0b13          	addi	s6,s6,1722 # 8009e4 <main+0x1ba>
  800332:	000dc503          	lbu	a0,0(s11)
  800336:	001d8413          	addi	s0,s11,1
  80033a:	01450b63          	beq	a0,s4,800350 <vprintfmt+0x52>
  80033e:	c129                	beqz	a0,800380 <vprintfmt+0x82>
  800340:	864a                	mv	a2,s2
  800342:	85a6                	mv	a1,s1
  800344:	0405                	addi	s0,s0,1
  800346:	9982                	jalr	s3
  800348:	fff44503          	lbu	a0,-1(s0)
  80034c:	ff4519e3          	bne	a0,s4,80033e <vprintfmt+0x40>
  800350:	00044583          	lbu	a1,0(s0)
  800354:	02000813          	li	a6,32
  800358:	4d01                	li	s10,0
  80035a:	4301                	li	t1,0
  80035c:	5cfd                	li	s9,-1
  80035e:	5c7d                	li	s8,-1
  800360:	05500513          	li	a0,85
  800364:	48a5                	li	a7,9
  800366:	fdd5861b          	addiw	a2,a1,-35
  80036a:	0ff67613          	zext.b	a2,a2
  80036e:	00140d93          	addi	s11,s0,1
  800372:	04c56263          	bltu	a0,a2,8003b6 <vprintfmt+0xb8>
  800376:	060a                	slli	a2,a2,0x2
  800378:	965a                	add	a2,a2,s6
  80037a:	4214                	lw	a3,0(a2)
  80037c:	96da                	add	a3,a3,s6
  80037e:	8682                	jr	a3
  800380:	70e6                	ld	ra,120(sp)
  800382:	7446                	ld	s0,112(sp)
  800384:	74a6                	ld	s1,104(sp)
  800386:	7906                	ld	s2,96(sp)
  800388:	69e6                	ld	s3,88(sp)
  80038a:	6a46                	ld	s4,80(sp)
  80038c:	6aa6                	ld	s5,72(sp)
  80038e:	6b06                	ld	s6,64(sp)
  800390:	7be2                	ld	s7,56(sp)
  800392:	7c42                	ld	s8,48(sp)
  800394:	7ca2                	ld	s9,40(sp)
  800396:	7d02                	ld	s10,32(sp)
  800398:	6de2                	ld	s11,24(sp)
  80039a:	6109                	addi	sp,sp,128
  80039c:	8082                	ret
  80039e:	882e                	mv	a6,a1
  8003a0:	00144583          	lbu	a1,1(s0)
  8003a4:	846e                	mv	s0,s11
  8003a6:	00140d93          	addi	s11,s0,1
  8003aa:	fdd5861b          	addiw	a2,a1,-35
  8003ae:	0ff67613          	zext.b	a2,a2
  8003b2:	fcc572e3          	bgeu	a0,a2,800376 <vprintfmt+0x78>
  8003b6:	864a                	mv	a2,s2
  8003b8:	85a6                	mv	a1,s1
  8003ba:	02500513          	li	a0,37
  8003be:	9982                	jalr	s3
  8003c0:	fff44783          	lbu	a5,-1(s0)
  8003c4:	8da2                	mv	s11,s0
  8003c6:	f74786e3          	beq	a5,s4,800332 <vprintfmt+0x34>
  8003ca:	ffedc783          	lbu	a5,-2(s11)
  8003ce:	1dfd                	addi	s11,s11,-1
  8003d0:	ff479de3          	bne	a5,s4,8003ca <vprintfmt+0xcc>
  8003d4:	bfb9                	j	800332 <vprintfmt+0x34>
  8003d6:	fd058c9b          	addiw	s9,a1,-48
  8003da:	00144583          	lbu	a1,1(s0)
  8003de:	846e                	mv	s0,s11
  8003e0:	fd05869b          	addiw	a3,a1,-48
  8003e4:	0005861b          	sext.w	a2,a1
  8003e8:	02d8e463          	bltu	a7,a3,800410 <vprintfmt+0x112>
  8003ec:	00144583          	lbu	a1,1(s0)
  8003f0:	002c969b          	slliw	a3,s9,0x2
  8003f4:	0196873b          	addw	a4,a3,s9
  8003f8:	0017171b          	slliw	a4,a4,0x1
  8003fc:	9f31                	addw	a4,a4,a2
  8003fe:	fd05869b          	addiw	a3,a1,-48
  800402:	0405                	addi	s0,s0,1
  800404:	fd070c9b          	addiw	s9,a4,-48
  800408:	0005861b          	sext.w	a2,a1
  80040c:	fed8f0e3          	bgeu	a7,a3,8003ec <vprintfmt+0xee>
  800410:	f40c5be3          	bgez	s8,800366 <vprintfmt+0x68>
  800414:	8c66                	mv	s8,s9
  800416:	5cfd                	li	s9,-1
  800418:	b7b9                	j	800366 <vprintfmt+0x68>
  80041a:	fffc4693          	not	a3,s8
  80041e:	96fd                	srai	a3,a3,0x3f
  800420:	00dc77b3          	and	a5,s8,a3
  800424:	00144583          	lbu	a1,1(s0)
  800428:	00078c1b          	sext.w	s8,a5
  80042c:	846e                	mv	s0,s11
  80042e:	bf25                	j	800366 <vprintfmt+0x68>
  800430:	000aac83          	lw	s9,0(s5)
  800434:	00144583          	lbu	a1,1(s0)
  800438:	0aa1                	addi	s5,s5,8
  80043a:	846e                	mv	s0,s11
  80043c:	bfd1                	j	800410 <vprintfmt+0x112>
  80043e:	4705                	li	a4,1
  800440:	008a8613          	addi	a2,s5,8
  800444:	00674463          	blt	a4,t1,80044c <vprintfmt+0x14e>
  800448:	1c030c63          	beqz	t1,800620 <vprintfmt+0x322>
  80044c:	000ab683          	ld	a3,0(s5)
  800450:	4741                	li	a4,16
  800452:	8ab2                	mv	s5,a2
  800454:	2801                	sext.w	a6,a6
  800456:	87e2                	mv	a5,s8
  800458:	8626                	mv	a2,s1
  80045a:	85ca                	mv	a1,s2
  80045c:	854e                	mv	a0,s3
  80045e:	e2bff0ef          	jal	ra,800288 <printnum>
  800462:	bdc1                	j	800332 <vprintfmt+0x34>
  800464:	000aa503          	lw	a0,0(s5)
  800468:	864a                	mv	a2,s2
  80046a:	85a6                	mv	a1,s1
  80046c:	0aa1                	addi	s5,s5,8
  80046e:	9982                	jalr	s3
  800470:	b5c9                	j	800332 <vprintfmt+0x34>
  800472:	4705                	li	a4,1
  800474:	008a8613          	addi	a2,s5,8
  800478:	00674463          	blt	a4,t1,800480 <vprintfmt+0x182>
  80047c:	18030d63          	beqz	t1,800616 <vprintfmt+0x318>
  800480:	000ab683          	ld	a3,0(s5)
  800484:	4729                	li	a4,10
  800486:	8ab2                	mv	s5,a2
  800488:	b7f1                	j	800454 <vprintfmt+0x156>
  80048a:	00144583          	lbu	a1,1(s0)
  80048e:	4d05                	li	s10,1
  800490:	846e                	mv	s0,s11
  800492:	bdd1                	j	800366 <vprintfmt+0x68>
  800494:	864a                	mv	a2,s2
  800496:	85a6                	mv	a1,s1
  800498:	02500513          	li	a0,37
  80049c:	9982                	jalr	s3
  80049e:	bd51                	j	800332 <vprintfmt+0x34>
  8004a0:	00144583          	lbu	a1,1(s0)
  8004a4:	2305                	addiw	t1,t1,1
  8004a6:	846e                	mv	s0,s11
  8004a8:	bd7d                	j	800366 <vprintfmt+0x68>
  8004aa:	4705                	li	a4,1
  8004ac:	008a8613          	addi	a2,s5,8
  8004b0:	00674463          	blt	a4,t1,8004b8 <vprintfmt+0x1ba>
  8004b4:	14030c63          	beqz	t1,80060c <vprintfmt+0x30e>
  8004b8:	000ab683          	ld	a3,0(s5)
  8004bc:	4721                	li	a4,8
  8004be:	8ab2                	mv	s5,a2
  8004c0:	bf51                	j	800454 <vprintfmt+0x156>
  8004c2:	03000513          	li	a0,48
  8004c6:	864a                	mv	a2,s2
  8004c8:	85a6                	mv	a1,s1
  8004ca:	e042                	sd	a6,0(sp)
  8004cc:	9982                	jalr	s3
  8004ce:	864a                	mv	a2,s2
  8004d0:	85a6                	mv	a1,s1
  8004d2:	07800513          	li	a0,120
  8004d6:	9982                	jalr	s3
  8004d8:	0aa1                	addi	s5,s5,8
  8004da:	6802                	ld	a6,0(sp)
  8004dc:	4741                	li	a4,16
  8004de:	ff8ab683          	ld	a3,-8(s5)
  8004e2:	bf8d                	j	800454 <vprintfmt+0x156>
  8004e4:	000ab403          	ld	s0,0(s5)
  8004e8:	008a8793          	addi	a5,s5,8
  8004ec:	e03e                	sd	a5,0(sp)
  8004ee:	14040c63          	beqz	s0,800646 <vprintfmt+0x348>
  8004f2:	11805063          	blez	s8,8005f2 <vprintfmt+0x2f4>
  8004f6:	02d00693          	li	a3,45
  8004fa:	0cd81963          	bne	a6,a3,8005cc <vprintfmt+0x2ce>
  8004fe:	00044683          	lbu	a3,0(s0)
  800502:	0006851b          	sext.w	a0,a3
  800506:	ce8d                	beqz	a3,800540 <vprintfmt+0x242>
  800508:	00140a93          	addi	s5,s0,1
  80050c:	05e00413          	li	s0,94
  800510:	000cc563          	bltz	s9,80051a <vprintfmt+0x21c>
  800514:	3cfd                	addiw	s9,s9,-1
  800516:	037c8363          	beq	s9,s7,80053c <vprintfmt+0x23e>
  80051a:	864a                	mv	a2,s2
  80051c:	85a6                	mv	a1,s1
  80051e:	100d0663          	beqz	s10,80062a <vprintfmt+0x32c>
  800522:	3681                	addiw	a3,a3,-32
  800524:	10d47363          	bgeu	s0,a3,80062a <vprintfmt+0x32c>
  800528:	03f00513          	li	a0,63
  80052c:	9982                	jalr	s3
  80052e:	000ac683          	lbu	a3,0(s5)
  800532:	3c7d                	addiw	s8,s8,-1
  800534:	0a85                	addi	s5,s5,1
  800536:	0006851b          	sext.w	a0,a3
  80053a:	faf9                	bnez	a3,800510 <vprintfmt+0x212>
  80053c:	01805a63          	blez	s8,800550 <vprintfmt+0x252>
  800540:	3c7d                	addiw	s8,s8,-1
  800542:	864a                	mv	a2,s2
  800544:	85a6                	mv	a1,s1
  800546:	02000513          	li	a0,32
  80054a:	9982                	jalr	s3
  80054c:	fe0c1ae3          	bnez	s8,800540 <vprintfmt+0x242>
  800550:	6a82                	ld	s5,0(sp)
  800552:	b3c5                	j	800332 <vprintfmt+0x34>
  800554:	4705                	li	a4,1
  800556:	008a8d13          	addi	s10,s5,8
  80055a:	00674463          	blt	a4,t1,800562 <vprintfmt+0x264>
  80055e:	0a030463          	beqz	t1,800606 <vprintfmt+0x308>
  800562:	000ab403          	ld	s0,0(s5)
  800566:	0c044463          	bltz	s0,80062e <vprintfmt+0x330>
  80056a:	86a2                	mv	a3,s0
  80056c:	8aea                	mv	s5,s10
  80056e:	4729                	li	a4,10
  800570:	b5d5                	j	800454 <vprintfmt+0x156>
  800572:	000aa783          	lw	a5,0(s5)
  800576:	46e1                	li	a3,24
  800578:	0aa1                	addi	s5,s5,8
  80057a:	41f7d71b          	sraiw	a4,a5,0x1f
  80057e:	8fb9                	xor	a5,a5,a4
  800580:	40e7873b          	subw	a4,a5,a4
  800584:	02e6c663          	blt	a3,a4,8005b0 <vprintfmt+0x2b2>
  800588:	00371793          	slli	a5,a4,0x3
  80058c:	00000697          	auipc	a3,0x0
  800590:	78c68693          	addi	a3,a3,1932 # 800d18 <error_string>
  800594:	97b6                	add	a5,a5,a3
  800596:	639c                	ld	a5,0(a5)
  800598:	cf81                	beqz	a5,8005b0 <vprintfmt+0x2b2>
  80059a:	873e                	mv	a4,a5
  80059c:	00000697          	auipc	a3,0x0
  8005a0:	44468693          	addi	a3,a3,1092 # 8009e0 <main+0x1b6>
  8005a4:	8626                	mv	a2,s1
  8005a6:	85ca                	mv	a1,s2
  8005a8:	854e                	mv	a0,s3
  8005aa:	0d4000ef          	jal	ra,80067e <printfmt>
  8005ae:	b351                	j	800332 <vprintfmt+0x34>
  8005b0:	00000697          	auipc	a3,0x0
  8005b4:	42068693          	addi	a3,a3,1056 # 8009d0 <main+0x1a6>
  8005b8:	8626                	mv	a2,s1
  8005ba:	85ca                	mv	a1,s2
  8005bc:	854e                	mv	a0,s3
  8005be:	0c0000ef          	jal	ra,80067e <printfmt>
  8005c2:	bb85                	j	800332 <vprintfmt+0x34>
  8005c4:	00000417          	auipc	s0,0x0
  8005c8:	40440413          	addi	s0,s0,1028 # 8009c8 <main+0x19e>
  8005cc:	85e6                	mv	a1,s9
  8005ce:	8522                	mv	a0,s0
  8005d0:	e442                	sd	a6,8(sp)
  8005d2:	10a000ef          	jal	ra,8006dc <strnlen>
  8005d6:	40ac0c3b          	subw	s8,s8,a0
  8005da:	01805c63          	blez	s8,8005f2 <vprintfmt+0x2f4>
  8005de:	6822                	ld	a6,8(sp)
  8005e0:	00080a9b          	sext.w	s5,a6
  8005e4:	3c7d                	addiw	s8,s8,-1
  8005e6:	864a                	mv	a2,s2
  8005e8:	85a6                	mv	a1,s1
  8005ea:	8556                	mv	a0,s5
  8005ec:	9982                	jalr	s3
  8005ee:	fe0c1be3          	bnez	s8,8005e4 <vprintfmt+0x2e6>
  8005f2:	00044683          	lbu	a3,0(s0)
  8005f6:	00140a93          	addi	s5,s0,1
  8005fa:	0006851b          	sext.w	a0,a3
  8005fe:	daa9                	beqz	a3,800550 <vprintfmt+0x252>
  800600:	05e00413          	li	s0,94
  800604:	b731                	j	800510 <vprintfmt+0x212>
  800606:	000aa403          	lw	s0,0(s5)
  80060a:	bfb1                	j	800566 <vprintfmt+0x268>
  80060c:	000ae683          	lwu	a3,0(s5)
  800610:	4721                	li	a4,8
  800612:	8ab2                	mv	s5,a2
  800614:	b581                	j	800454 <vprintfmt+0x156>
  800616:	000ae683          	lwu	a3,0(s5)
  80061a:	4729                	li	a4,10
  80061c:	8ab2                	mv	s5,a2
  80061e:	bd1d                	j	800454 <vprintfmt+0x156>
  800620:	000ae683          	lwu	a3,0(s5)
  800624:	4741                	li	a4,16
  800626:	8ab2                	mv	s5,a2
  800628:	b535                	j	800454 <vprintfmt+0x156>
  80062a:	9982                	jalr	s3
  80062c:	b709                	j	80052e <vprintfmt+0x230>
  80062e:	864a                	mv	a2,s2
  800630:	85a6                	mv	a1,s1
  800632:	02d00513          	li	a0,45
  800636:	e042                	sd	a6,0(sp)
  800638:	9982                	jalr	s3
  80063a:	6802                	ld	a6,0(sp)
  80063c:	8aea                	mv	s5,s10
  80063e:	408006b3          	neg	a3,s0
  800642:	4729                	li	a4,10
  800644:	bd01                	j	800454 <vprintfmt+0x156>
  800646:	03805163          	blez	s8,800668 <vprintfmt+0x36a>
  80064a:	02d00693          	li	a3,45
  80064e:	f6d81be3          	bne	a6,a3,8005c4 <vprintfmt+0x2c6>
  800652:	00000417          	auipc	s0,0x0
  800656:	37640413          	addi	s0,s0,886 # 8009c8 <main+0x19e>
  80065a:	02800693          	li	a3,40
  80065e:	02800513          	li	a0,40
  800662:	00140a93          	addi	s5,s0,1
  800666:	b55d                	j	80050c <vprintfmt+0x20e>
  800668:	00000a97          	auipc	s5,0x0
  80066c:	361a8a93          	addi	s5,s5,865 # 8009c9 <main+0x19f>
  800670:	02800513          	li	a0,40
  800674:	02800693          	li	a3,40
  800678:	05e00413          	li	s0,94
  80067c:	bd51                	j	800510 <vprintfmt+0x212>

000000000080067e <printfmt>:
  80067e:	7139                	addi	sp,sp,-64
  800680:	02010313          	addi	t1,sp,32
  800684:	f03a                	sd	a4,32(sp)
  800686:	871a                	mv	a4,t1
  800688:	ec06                	sd	ra,24(sp)
  80068a:	f43e                	sd	a5,40(sp)
  80068c:	f842                	sd	a6,48(sp)
  80068e:	fc46                	sd	a7,56(sp)
  800690:	e41a                	sd	t1,8(sp)
  800692:	c6dff0ef          	jal	ra,8002fe <vprintfmt>
  800696:	60e2                	ld	ra,24(sp)
  800698:	6121                	addi	sp,sp,64
  80069a:	8082                	ret

000000000080069c <rand>:
  80069c:	00001697          	auipc	a3,0x1
  8006a0:	96468693          	addi	a3,a3,-1692 # 801000 <next>
  8006a4:	629c                	ld	a5,0(a3)
  8006a6:	00000717          	auipc	a4,0x0
  8006aa:	7ba73703          	ld	a4,1978(a4) # 800e60 <error_string+0x148>
  8006ae:	02e787b3          	mul	a5,a5,a4
  8006b2:	80000737          	lui	a4,0x80000
  8006b6:	fff74713          	not	a4,a4
  8006ba:	07ad                	addi	a5,a5,11
  8006bc:	07c2                	slli	a5,a5,0x10
  8006be:	83c1                	srli	a5,a5,0x10
  8006c0:	00c7d513          	srli	a0,a5,0xc
  8006c4:	02e57533          	remu	a0,a0,a4
  8006c8:	e29c                	sd	a5,0(a3)
  8006ca:	2505                	addiw	a0,a0,1
  8006cc:	8082                	ret

00000000008006ce <srand>:
  8006ce:	1502                	slli	a0,a0,0x20
  8006d0:	9101                	srli	a0,a0,0x20
  8006d2:	00001797          	auipc	a5,0x1
  8006d6:	92a7b723          	sd	a0,-1746(a5) # 801000 <next>
  8006da:	8082                	ret

00000000008006dc <strnlen>:
  8006dc:	4781                	li	a5,0
  8006de:	e589                	bnez	a1,8006e8 <strnlen+0xc>
  8006e0:	a811                	j	8006f4 <strnlen+0x18>
  8006e2:	0785                	addi	a5,a5,1
  8006e4:	00f58863          	beq	a1,a5,8006f4 <strnlen+0x18>
  8006e8:	00f50733          	add	a4,a0,a5
  8006ec:	00074703          	lbu	a4,0(a4) # ffffffff80000000 <matc+0xffffffff7f7fecd8>
  8006f0:	fb6d                	bnez	a4,8006e2 <strnlen+0x6>
  8006f2:	85be                	mv	a1,a5
  8006f4:	852e                	mv	a0,a1
  8006f6:	8082                	ret

00000000008006f8 <memset>:
  8006f8:	ca01                	beqz	a2,800708 <memset+0x10>
  8006fa:	962a                	add	a2,a2,a0
  8006fc:	87aa                	mv	a5,a0
  8006fe:	0785                	addi	a5,a5,1
  800700:	feb78fa3          	sb	a1,-1(a5)
  800704:	fec79de3          	bne	a5,a2,8006fe <memset+0x6>
  800708:	8082                	ret

000000000080070a <work>:
  80070a:	7179                	addi	sp,sp,-48
  80070c:	ec26                	sd	s1,24(sp)
  80070e:	00001497          	auipc	s1,0x1
  800712:	8fa48493          	addi	s1,s1,-1798 # 801008 <mata>
  800716:	f022                	sd	s0,32(sp)
  800718:	e84a                	sd	s2,16(sp)
  80071a:	e44e                	sd	s3,8(sp)
  80071c:	f406                	sd	ra,40(sp)
  80071e:	89aa                	mv	s3,a0
  800720:	00001917          	auipc	s2,0x1
  800724:	a7890913          	addi	s2,s2,-1416 # 801198 <matb>
  800728:	00001597          	auipc	a1,0x1
  80072c:	a9858593          	addi	a1,a1,-1384 # 8011c0 <matb+0x28>
  800730:	00001417          	auipc	s0,0x1
  800734:	c2040413          	addi	s0,s0,-992 # 801350 <matc+0x28>
  800738:	8626                	mv	a2,s1
  80073a:	4685                	li	a3,1
  80073c:	fd858793          	addi	a5,a1,-40
  800740:	8732                	mv	a4,a2
  800742:	c394                	sw	a3,0(a5)
  800744:	c314                	sw	a3,0(a4)
  800746:	0791                	addi	a5,a5,4
  800748:	0711                	addi	a4,a4,4
  80074a:	feb79ce3          	bne	a5,a1,800742 <work+0x38>
  80074e:	02878593          	addi	a1,a5,40
  800752:	02860613          	addi	a2,a2,40
  800756:	fe8593e3          	bne	a1,s0,80073c <work+0x32>
  80075a:	a71ff0ef          	jal	ra,8001ca <yield>
  80075e:	a71ff0ef          	jal	ra,8001ce <getpid>
  800762:	85aa                	mv	a1,a0
  800764:	864e                	mv	a2,s3
  800766:	00000517          	auipc	a0,0x0
  80076a:	67a50513          	addi	a0,a0,1658 # 800de0 <error_string+0xc8>
  80076e:	989ff0ef          	jal	ra,8000f6 <cprintf>
  800772:	fff9839b          	addiw	t2,s3,-1
  800776:	00001297          	auipc	t0,0x1
  80077a:	d4228293          	addi	t0,t0,-702 # 8014b8 <matc+0x190>
  80077e:	00001f97          	auipc	t6,0x1
  800782:	a1af8f93          	addi	t6,t6,-1510 # 801198 <matb>
  800786:	00001f17          	auipc	t5,0x1
  80078a:	ba2f0f13          	addi	t5,t5,-1118 # 801328 <matc>
  80078e:	02800e13          	li	t3,40
  800792:	50fd                	li	ra,-1
  800794:	06098f63          	beqz	s3,800812 <work+0x108>
  800798:	00001897          	auipc	a7,0x1
  80079c:	b9088893          	addi	a7,a7,-1136 # 801328 <matc>
  8007a0:	8ec6                	mv	t4,a7
  8007a2:	8326                	mv	t1,s1
  8007a4:	857a                	mv	a0,t5
  8007a6:	8876                	mv	a6,t4
  8007a8:	e7050793          	addi	a5,a0,-400
  8007ac:	869a                	mv	a3,t1
  8007ae:	4601                	li	a2,0
  8007b0:	4298                	lw	a4,0(a3)
  8007b2:	438c                	lw	a1,0(a5)
  8007b4:	02878793          	addi	a5,a5,40
  8007b8:	0691                	addi	a3,a3,4
  8007ba:	02b7073b          	mulw	a4,a4,a1
  8007be:	9e39                	addw	a2,a2,a4
  8007c0:	fea798e3          	bne	a5,a0,8007b0 <work+0xa6>
  8007c4:	00c82023          	sw	a2,0(a6)
  8007c8:	00478513          	addi	a0,a5,4
  8007cc:	0811                	addi	a6,a6,4
  8007ce:	fc851de3          	bne	a0,s0,8007a8 <work+0x9e>
  8007d2:	02830313          	addi	t1,t1,40
  8007d6:	028e8e93          	addi	t4,t4,40
  8007da:	fc6f95e3          	bne	t6,t1,8007a4 <work+0x9a>
  8007de:	8526                	mv	a0,s1
  8007e0:	85ca                	mv	a1,s2
  8007e2:	4781                	li	a5,0
  8007e4:	00f88733          	add	a4,a7,a5
  8007e8:	4318                	lw	a4,0(a4)
  8007ea:	00f58633          	add	a2,a1,a5
  8007ee:	00f506b3          	add	a3,a0,a5
  8007f2:	c218                	sw	a4,0(a2)
  8007f4:	c298                	sw	a4,0(a3)
  8007f6:	0791                	addi	a5,a5,4
  8007f8:	ffc796e3          	bne	a5,t3,8007e4 <work+0xda>
  8007fc:	02888893          	addi	a7,a7,40
  800800:	02858593          	addi	a1,a1,40
  800804:	02850513          	addi	a0,a0,40
  800808:	fc589de3          	bne	a7,t0,8007e2 <work+0xd8>
  80080c:	33fd                	addiw	t2,t2,-1
  80080e:	f81395e3          	bne	t2,ra,800798 <work+0x8e>
  800812:	9bdff0ef          	jal	ra,8001ce <getpid>
  800816:	85aa                	mv	a1,a0
  800818:	00000517          	auipc	a0,0x0
  80081c:	5e850513          	addi	a0,a0,1512 # 800e00 <error_string+0xe8>
  800820:	8d7ff0ef          	jal	ra,8000f6 <cprintf>
  800824:	4501                	li	a0,0
  800826:	987ff0ef          	jal	ra,8001ac <exit>

000000000080082a <main>:
  80082a:	7175                	addi	sp,sp,-144
  80082c:	f4ce                	sd	s3,104(sp)
  80082e:	05400613          	li	a2,84
  800832:	4581                	li	a1,0
  800834:	0028                	addi	a0,sp,8
  800836:	00810993          	addi	s3,sp,8
  80083a:	e122                	sd	s0,128(sp)
  80083c:	fca6                	sd	s1,120(sp)
  80083e:	f8ca                	sd	s2,112(sp)
  800840:	e506                	sd	ra,136(sp)
  800842:	84ce                	mv	s1,s3
  800844:	eb5ff0ef          	jal	ra,8006f8 <memset>
  800848:	4401                	li	s0,0
  80084a:	4955                	li	s2,21
  80084c:	977ff0ef          	jal	ra,8001c2 <fork>
  800850:	c088                	sw	a0,0(s1)
  800852:	cd2d                	beqz	a0,8008cc <main+0xa2>
  800854:	04054663          	bltz	a0,8008a0 <main+0x76>
  800858:	2405                	addiw	s0,s0,1
  80085a:	0491                	addi	s1,s1,4
  80085c:	ff2418e3          	bne	s0,s2,80084c <main+0x22>
  800860:	00000517          	auipc	a0,0x0
  800864:	5b050513          	addi	a0,a0,1456 # 800e10 <error_string+0xf8>
  800868:	88fff0ef          	jal	ra,8000f6 <cprintf>
  80086c:	4455                	li	s0,21
  80086e:	957ff0ef          	jal	ra,8001c4 <wait>
  800872:	e10d                	bnez	a0,800894 <main+0x6a>
  800874:	347d                	addiw	s0,s0,-1
  800876:	fc65                	bnez	s0,80086e <main+0x44>
  800878:	00000517          	auipc	a0,0x0
  80087c:	5b850513          	addi	a0,a0,1464 # 800e30 <error_string+0x118>
  800880:	877ff0ef          	jal	ra,8000f6 <cprintf>
  800884:	60aa                	ld	ra,136(sp)
  800886:	640a                	ld	s0,128(sp)
  800888:	74e6                	ld	s1,120(sp)
  80088a:	7946                	ld	s2,112(sp)
  80088c:	79a6                	ld	s3,104(sp)
  80088e:	4501                	li	a0,0
  800890:	6149                	addi	sp,sp,144
  800892:	8082                	ret
  800894:	00000517          	auipc	a0,0x0
  800898:	58c50513          	addi	a0,a0,1420 # 800e20 <error_string+0x108>
  80089c:	85bff0ef          	jal	ra,8000f6 <cprintf>
  8008a0:	08e0                	addi	s0,sp,92
  8008a2:	0009a503          	lw	a0,0(s3)
  8008a6:	00a05463          	blez	a0,8008ae <main+0x84>
  8008aa:	923ff0ef          	jal	ra,8001cc <kill>
  8008ae:	0991                	addi	s3,s3,4
  8008b0:	fe8999e3          	bne	s3,s0,8008a2 <main+0x78>
  8008b4:	00000617          	auipc	a2,0x0
  8008b8:	58c60613          	addi	a2,a2,1420 # 800e40 <error_string+0x128>
  8008bc:	05200593          	li	a1,82
  8008c0:	00000517          	auipc	a0,0x0
  8008c4:	59050513          	addi	a0,a0,1424 # 800e50 <error_string+0x138>
  8008c8:	f68ff0ef          	jal	ra,800030 <__panic>
  8008cc:	0284053b          	mulw	a0,s0,s0
  8008d0:	dffff0ef          	jal	ra,8006ce <srand>
  8008d4:	dc9ff0ef          	jal	ra,80069c <rand>
  8008d8:	47d5                	li	a5,21
  8008da:	02f577bb          	remuw	a5,a0,a5
  8008de:	06400513          	li	a0,100
  8008e2:	02f787bb          	mulw	a5,a5,a5
  8008e6:	27a9                	addiw	a5,a5,10
  8008e8:	02f5053b          	mulw	a0,a0,a5
  8008ec:	e1fff0ef          	jal	ra,80070a <work>
