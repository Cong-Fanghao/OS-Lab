
obj/__user_waitkill.out:     file format elf64-littleriscv


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
  80002a:	1e6000ef          	jal	ra,800210 <umain>
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
  800044:	7a850513          	addi	a0,a0,1960 # 8007e8 <main+0xac>
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
  800064:	c8050513          	addi	a0,a0,-896 # 800ce0 <error_string+0xd0>
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
  800082:	00000517          	auipc	a0,0x0
  800086:	78650513          	addi	a0,a0,1926 # 800808 <main+0xcc>
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
  8000a6:	c3e50513          	addi	a0,a0,-962 # 800ce0 <error_string+0xd0>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <pid2+0xffffffffff7f5ad1>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	210000ef          	jal	ra,8002fa <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <pid2+0xffffffffff7f5ad1>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1d4000ef          	jal	ra,8002fa <vprintfmt>
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
  8001b8:	67450513          	addi	a0,a0,1652 # 800828 <main+0xec>
  8001bc:	f3bff0ef          	jal	ra,8000f6 <cprintf>
  8001c0:	a001                	j	8001c0 <exit+0x14>

00000000008001c2 <fork>:
  8001c2:	b77d                	j	800170 <sys_fork>

00000000008001c4 <waitpid>:
  8001c4:	bf45                	j	800174 <sys_wait>

00000000008001c6 <yield>:
  8001c6:	bf5d                	j	80017c <sys_yield>

00000000008001c8 <kill>:
  8001c8:	bf65                	j	800180 <sys_kill>

00000000008001ca <getpid>:
  8001ca:	bf75                	j	800186 <sys_getpid>

00000000008001cc <initfd>:
  8001cc:	1101                	addi	sp,sp,-32
  8001ce:	87ae                	mv	a5,a1
  8001d0:	e426                	sd	s1,8(sp)
  8001d2:	85b2                	mv	a1,a2
  8001d4:	84aa                	mv	s1,a0
  8001d6:	853e                	mv	a0,a5
  8001d8:	e822                	sd	s0,16(sp)
  8001da:	ec06                	sd	ra,24(sp)
  8001dc:	e45ff0ef          	jal	ra,800020 <open>
  8001e0:	842a                	mv	s0,a0
  8001e2:	00054463          	bltz	a0,8001ea <initfd+0x1e>
  8001e6:	00951863          	bne	a0,s1,8001f6 <initfd+0x2a>
  8001ea:	60e2                	ld	ra,24(sp)
  8001ec:	8522                	mv	a0,s0
  8001ee:	6442                	ld	s0,16(sp)
  8001f0:	64a2                	ld	s1,8(sp)
  8001f2:	6105                	addi	sp,sp,32
  8001f4:	8082                	ret
  8001f6:	8526                	mv	a0,s1
  8001f8:	e2fff0ef          	jal	ra,800026 <close>
  8001fc:	85a6                	mv	a1,s1
  8001fe:	8522                	mv	a0,s0
  800200:	e29ff0ef          	jal	ra,800028 <dup2>
  800204:	84aa                	mv	s1,a0
  800206:	8522                	mv	a0,s0
  800208:	e1fff0ef          	jal	ra,800026 <close>
  80020c:	8426                	mv	s0,s1
  80020e:	bff1                	j	8001ea <initfd+0x1e>

0000000000800210 <umain>:
  800210:	1101                	addi	sp,sp,-32
  800212:	e822                	sd	s0,16(sp)
  800214:	e426                	sd	s1,8(sp)
  800216:	842a                	mv	s0,a0
  800218:	84ae                	mv	s1,a1
  80021a:	4601                	li	a2,0
  80021c:	00000597          	auipc	a1,0x0
  800220:	62458593          	addi	a1,a1,1572 # 800840 <main+0x104>
  800224:	4501                	li	a0,0
  800226:	ec06                	sd	ra,24(sp)
  800228:	fa5ff0ef          	jal	ra,8001cc <initfd>
  80022c:	02054263          	bltz	a0,800250 <umain+0x40>
  800230:	4605                	li	a2,1
  800232:	00000597          	auipc	a1,0x0
  800236:	64e58593          	addi	a1,a1,1614 # 800880 <main+0x144>
  80023a:	4505                	li	a0,1
  80023c:	f91ff0ef          	jal	ra,8001cc <initfd>
  800240:	02054563          	bltz	a0,80026a <umain+0x5a>
  800244:	85a6                	mv	a1,s1
  800246:	8522                	mv	a0,s0
  800248:	4f4000ef          	jal	ra,80073c <main>
  80024c:	f61ff0ef          	jal	ra,8001ac <exit>
  800250:	86aa                	mv	a3,a0
  800252:	00000617          	auipc	a2,0x0
  800256:	5f660613          	addi	a2,a2,1526 # 800848 <main+0x10c>
  80025a:	45e9                	li	a1,26
  80025c:	00000517          	auipc	a0,0x0
  800260:	60c50513          	addi	a0,a0,1548 # 800868 <main+0x12c>
  800264:	e0fff0ef          	jal	ra,800072 <__warn>
  800268:	b7e1                	j	800230 <umain+0x20>
  80026a:	86aa                	mv	a3,a0
  80026c:	00000617          	auipc	a2,0x0
  800270:	61c60613          	addi	a2,a2,1564 # 800888 <main+0x14c>
  800274:	45f5                	li	a1,29
  800276:	00000517          	auipc	a0,0x0
  80027a:	5f250513          	addi	a0,a0,1522 # 800868 <main+0x12c>
  80027e:	df5ff0ef          	jal	ra,800072 <__warn>
  800282:	b7c9                	j	800244 <umain+0x34>

0000000000800284 <printnum>:
  800284:	02071893          	slli	a7,a4,0x20
  800288:	7139                	addi	sp,sp,-64
  80028a:	0208d893          	srli	a7,a7,0x20
  80028e:	e456                	sd	s5,8(sp)
  800290:	0316fab3          	remu	s5,a3,a7
  800294:	f822                	sd	s0,48(sp)
  800296:	f426                	sd	s1,40(sp)
  800298:	f04a                	sd	s2,32(sp)
  80029a:	ec4e                	sd	s3,24(sp)
  80029c:	fc06                	sd	ra,56(sp)
  80029e:	e852                	sd	s4,16(sp)
  8002a0:	84aa                	mv	s1,a0
  8002a2:	89ae                	mv	s3,a1
  8002a4:	8932                	mv	s2,a2
  8002a6:	fff7841b          	addiw	s0,a5,-1
  8002aa:	2a81                	sext.w	s5,s5
  8002ac:	0516f163          	bgeu	a3,a7,8002ee <printnum+0x6a>
  8002b0:	8a42                	mv	s4,a6
  8002b2:	00805863          	blez	s0,8002c2 <printnum+0x3e>
  8002b6:	347d                	addiw	s0,s0,-1
  8002b8:	864e                	mv	a2,s3
  8002ba:	85ca                	mv	a1,s2
  8002bc:	8552                	mv	a0,s4
  8002be:	9482                	jalr	s1
  8002c0:	f87d                	bnez	s0,8002b6 <printnum+0x32>
  8002c2:	1a82                	slli	s5,s5,0x20
  8002c4:	00000797          	auipc	a5,0x0
  8002c8:	5e478793          	addi	a5,a5,1508 # 8008a8 <main+0x16c>
  8002cc:	020ada93          	srli	s5,s5,0x20
  8002d0:	9abe                	add	s5,s5,a5
  8002d2:	7442                	ld	s0,48(sp)
  8002d4:	000ac503          	lbu	a0,0(s5)
  8002d8:	70e2                	ld	ra,56(sp)
  8002da:	6a42                	ld	s4,16(sp)
  8002dc:	6aa2                	ld	s5,8(sp)
  8002de:	864e                	mv	a2,s3
  8002e0:	85ca                	mv	a1,s2
  8002e2:	69e2                	ld	s3,24(sp)
  8002e4:	7902                	ld	s2,32(sp)
  8002e6:	87a6                	mv	a5,s1
  8002e8:	74a2                	ld	s1,40(sp)
  8002ea:	6121                	addi	sp,sp,64
  8002ec:	8782                	jr	a5
  8002ee:	0316d6b3          	divu	a3,a3,a7
  8002f2:	87a2                	mv	a5,s0
  8002f4:	f91ff0ef          	jal	ra,800284 <printnum>
  8002f8:	b7e9                	j	8002c2 <printnum+0x3e>

00000000008002fa <vprintfmt>:
  8002fa:	7119                	addi	sp,sp,-128
  8002fc:	f4a6                	sd	s1,104(sp)
  8002fe:	f0ca                	sd	s2,96(sp)
  800300:	ecce                	sd	s3,88(sp)
  800302:	e8d2                	sd	s4,80(sp)
  800304:	e4d6                	sd	s5,72(sp)
  800306:	e0da                	sd	s6,64(sp)
  800308:	fc5e                	sd	s7,56(sp)
  80030a:	ec6e                	sd	s11,24(sp)
  80030c:	fc86                	sd	ra,120(sp)
  80030e:	f8a2                	sd	s0,112(sp)
  800310:	f862                	sd	s8,48(sp)
  800312:	f466                	sd	s9,40(sp)
  800314:	f06a                	sd	s10,32(sp)
  800316:	89aa                	mv	s3,a0
  800318:	892e                	mv	s2,a1
  80031a:	84b2                	mv	s1,a2
  80031c:	8db6                	mv	s11,a3
  80031e:	8aba                	mv	s5,a4
  800320:	02500a13          	li	s4,37
  800324:	5bfd                	li	s7,-1
  800326:	00000b17          	auipc	s6,0x0
  80032a:	5b6b0b13          	addi	s6,s6,1462 # 8008dc <main+0x1a0>
  80032e:	000dc503          	lbu	a0,0(s11)
  800332:	001d8413          	addi	s0,s11,1
  800336:	01450b63          	beq	a0,s4,80034c <vprintfmt+0x52>
  80033a:	c129                	beqz	a0,80037c <vprintfmt+0x82>
  80033c:	864a                	mv	a2,s2
  80033e:	85a6                	mv	a1,s1
  800340:	0405                	addi	s0,s0,1
  800342:	9982                	jalr	s3
  800344:	fff44503          	lbu	a0,-1(s0)
  800348:	ff4519e3          	bne	a0,s4,80033a <vprintfmt+0x40>
  80034c:	00044583          	lbu	a1,0(s0)
  800350:	02000813          	li	a6,32
  800354:	4d01                	li	s10,0
  800356:	4301                	li	t1,0
  800358:	5cfd                	li	s9,-1
  80035a:	5c7d                	li	s8,-1
  80035c:	05500513          	li	a0,85
  800360:	48a5                	li	a7,9
  800362:	fdd5861b          	addiw	a2,a1,-35
  800366:	0ff67613          	zext.b	a2,a2
  80036a:	00140d93          	addi	s11,s0,1
  80036e:	04c56263          	bltu	a0,a2,8003b2 <vprintfmt+0xb8>
  800372:	060a                	slli	a2,a2,0x2
  800374:	965a                	add	a2,a2,s6
  800376:	4214                	lw	a3,0(a2)
  800378:	96da                	add	a3,a3,s6
  80037a:	8682                	jr	a3
  80037c:	70e6                	ld	ra,120(sp)
  80037e:	7446                	ld	s0,112(sp)
  800380:	74a6                	ld	s1,104(sp)
  800382:	7906                	ld	s2,96(sp)
  800384:	69e6                	ld	s3,88(sp)
  800386:	6a46                	ld	s4,80(sp)
  800388:	6aa6                	ld	s5,72(sp)
  80038a:	6b06                	ld	s6,64(sp)
  80038c:	7be2                	ld	s7,56(sp)
  80038e:	7c42                	ld	s8,48(sp)
  800390:	7ca2                	ld	s9,40(sp)
  800392:	7d02                	ld	s10,32(sp)
  800394:	6de2                	ld	s11,24(sp)
  800396:	6109                	addi	sp,sp,128
  800398:	8082                	ret
  80039a:	882e                	mv	a6,a1
  80039c:	00144583          	lbu	a1,1(s0)
  8003a0:	846e                	mv	s0,s11
  8003a2:	00140d93          	addi	s11,s0,1
  8003a6:	fdd5861b          	addiw	a2,a1,-35
  8003aa:	0ff67613          	zext.b	a2,a2
  8003ae:	fcc572e3          	bgeu	a0,a2,800372 <vprintfmt+0x78>
  8003b2:	864a                	mv	a2,s2
  8003b4:	85a6                	mv	a1,s1
  8003b6:	02500513          	li	a0,37
  8003ba:	9982                	jalr	s3
  8003bc:	fff44783          	lbu	a5,-1(s0)
  8003c0:	8da2                	mv	s11,s0
  8003c2:	f74786e3          	beq	a5,s4,80032e <vprintfmt+0x34>
  8003c6:	ffedc783          	lbu	a5,-2(s11)
  8003ca:	1dfd                	addi	s11,s11,-1
  8003cc:	ff479de3          	bne	a5,s4,8003c6 <vprintfmt+0xcc>
  8003d0:	bfb9                	j	80032e <vprintfmt+0x34>
  8003d2:	fd058c9b          	addiw	s9,a1,-48
  8003d6:	00144583          	lbu	a1,1(s0)
  8003da:	846e                	mv	s0,s11
  8003dc:	fd05869b          	addiw	a3,a1,-48
  8003e0:	0005861b          	sext.w	a2,a1
  8003e4:	02d8e463          	bltu	a7,a3,80040c <vprintfmt+0x112>
  8003e8:	00144583          	lbu	a1,1(s0)
  8003ec:	002c969b          	slliw	a3,s9,0x2
  8003f0:	0196873b          	addw	a4,a3,s9
  8003f4:	0017171b          	slliw	a4,a4,0x1
  8003f8:	9f31                	addw	a4,a4,a2
  8003fa:	fd05869b          	addiw	a3,a1,-48
  8003fe:	0405                	addi	s0,s0,1
  800400:	fd070c9b          	addiw	s9,a4,-48
  800404:	0005861b          	sext.w	a2,a1
  800408:	fed8f0e3          	bgeu	a7,a3,8003e8 <vprintfmt+0xee>
  80040c:	f40c5be3          	bgez	s8,800362 <vprintfmt+0x68>
  800410:	8c66                	mv	s8,s9
  800412:	5cfd                	li	s9,-1
  800414:	b7b9                	j	800362 <vprintfmt+0x68>
  800416:	fffc4693          	not	a3,s8
  80041a:	96fd                	srai	a3,a3,0x3f
  80041c:	00dc77b3          	and	a5,s8,a3
  800420:	00144583          	lbu	a1,1(s0)
  800424:	00078c1b          	sext.w	s8,a5
  800428:	846e                	mv	s0,s11
  80042a:	bf25                	j	800362 <vprintfmt+0x68>
  80042c:	000aac83          	lw	s9,0(s5)
  800430:	00144583          	lbu	a1,1(s0)
  800434:	0aa1                	addi	s5,s5,8
  800436:	846e                	mv	s0,s11
  800438:	bfd1                	j	80040c <vprintfmt+0x112>
  80043a:	4705                	li	a4,1
  80043c:	008a8613          	addi	a2,s5,8
  800440:	00674463          	blt	a4,t1,800448 <vprintfmt+0x14e>
  800444:	1c030c63          	beqz	t1,80061c <vprintfmt+0x322>
  800448:	000ab683          	ld	a3,0(s5)
  80044c:	4741                	li	a4,16
  80044e:	8ab2                	mv	s5,a2
  800450:	2801                	sext.w	a6,a6
  800452:	87e2                	mv	a5,s8
  800454:	8626                	mv	a2,s1
  800456:	85ca                	mv	a1,s2
  800458:	854e                	mv	a0,s3
  80045a:	e2bff0ef          	jal	ra,800284 <printnum>
  80045e:	bdc1                	j	80032e <vprintfmt+0x34>
  800460:	000aa503          	lw	a0,0(s5)
  800464:	864a                	mv	a2,s2
  800466:	85a6                	mv	a1,s1
  800468:	0aa1                	addi	s5,s5,8
  80046a:	9982                	jalr	s3
  80046c:	b5c9                	j	80032e <vprintfmt+0x34>
  80046e:	4705                	li	a4,1
  800470:	008a8613          	addi	a2,s5,8
  800474:	00674463          	blt	a4,t1,80047c <vprintfmt+0x182>
  800478:	18030d63          	beqz	t1,800612 <vprintfmt+0x318>
  80047c:	000ab683          	ld	a3,0(s5)
  800480:	4729                	li	a4,10
  800482:	8ab2                	mv	s5,a2
  800484:	b7f1                	j	800450 <vprintfmt+0x156>
  800486:	00144583          	lbu	a1,1(s0)
  80048a:	4d05                	li	s10,1
  80048c:	846e                	mv	s0,s11
  80048e:	bdd1                	j	800362 <vprintfmt+0x68>
  800490:	864a                	mv	a2,s2
  800492:	85a6                	mv	a1,s1
  800494:	02500513          	li	a0,37
  800498:	9982                	jalr	s3
  80049a:	bd51                	j	80032e <vprintfmt+0x34>
  80049c:	00144583          	lbu	a1,1(s0)
  8004a0:	2305                	addiw	t1,t1,1
  8004a2:	846e                	mv	s0,s11
  8004a4:	bd7d                	j	800362 <vprintfmt+0x68>
  8004a6:	4705                	li	a4,1
  8004a8:	008a8613          	addi	a2,s5,8
  8004ac:	00674463          	blt	a4,t1,8004b4 <vprintfmt+0x1ba>
  8004b0:	14030c63          	beqz	t1,800608 <vprintfmt+0x30e>
  8004b4:	000ab683          	ld	a3,0(s5)
  8004b8:	4721                	li	a4,8
  8004ba:	8ab2                	mv	s5,a2
  8004bc:	bf51                	j	800450 <vprintfmt+0x156>
  8004be:	03000513          	li	a0,48
  8004c2:	864a                	mv	a2,s2
  8004c4:	85a6                	mv	a1,s1
  8004c6:	e042                	sd	a6,0(sp)
  8004c8:	9982                	jalr	s3
  8004ca:	864a                	mv	a2,s2
  8004cc:	85a6                	mv	a1,s1
  8004ce:	07800513          	li	a0,120
  8004d2:	9982                	jalr	s3
  8004d4:	0aa1                	addi	s5,s5,8
  8004d6:	6802                	ld	a6,0(sp)
  8004d8:	4741                	li	a4,16
  8004da:	ff8ab683          	ld	a3,-8(s5)
  8004de:	bf8d                	j	800450 <vprintfmt+0x156>
  8004e0:	000ab403          	ld	s0,0(s5)
  8004e4:	008a8793          	addi	a5,s5,8
  8004e8:	e03e                	sd	a5,0(sp)
  8004ea:	14040c63          	beqz	s0,800642 <vprintfmt+0x348>
  8004ee:	11805063          	blez	s8,8005ee <vprintfmt+0x2f4>
  8004f2:	02d00693          	li	a3,45
  8004f6:	0cd81963          	bne	a6,a3,8005c8 <vprintfmt+0x2ce>
  8004fa:	00044683          	lbu	a3,0(s0)
  8004fe:	0006851b          	sext.w	a0,a3
  800502:	ce8d                	beqz	a3,80053c <vprintfmt+0x242>
  800504:	00140a93          	addi	s5,s0,1
  800508:	05e00413          	li	s0,94
  80050c:	000cc563          	bltz	s9,800516 <vprintfmt+0x21c>
  800510:	3cfd                	addiw	s9,s9,-1
  800512:	037c8363          	beq	s9,s7,800538 <vprintfmt+0x23e>
  800516:	864a                	mv	a2,s2
  800518:	85a6                	mv	a1,s1
  80051a:	100d0663          	beqz	s10,800626 <vprintfmt+0x32c>
  80051e:	3681                	addiw	a3,a3,-32
  800520:	10d47363          	bgeu	s0,a3,800626 <vprintfmt+0x32c>
  800524:	03f00513          	li	a0,63
  800528:	9982                	jalr	s3
  80052a:	000ac683          	lbu	a3,0(s5)
  80052e:	3c7d                	addiw	s8,s8,-1
  800530:	0a85                	addi	s5,s5,1
  800532:	0006851b          	sext.w	a0,a3
  800536:	faf9                	bnez	a3,80050c <vprintfmt+0x212>
  800538:	01805a63          	blez	s8,80054c <vprintfmt+0x252>
  80053c:	3c7d                	addiw	s8,s8,-1
  80053e:	864a                	mv	a2,s2
  800540:	85a6                	mv	a1,s1
  800542:	02000513          	li	a0,32
  800546:	9982                	jalr	s3
  800548:	fe0c1ae3          	bnez	s8,80053c <vprintfmt+0x242>
  80054c:	6a82                	ld	s5,0(sp)
  80054e:	b3c5                	j	80032e <vprintfmt+0x34>
  800550:	4705                	li	a4,1
  800552:	008a8d13          	addi	s10,s5,8
  800556:	00674463          	blt	a4,t1,80055e <vprintfmt+0x264>
  80055a:	0a030463          	beqz	t1,800602 <vprintfmt+0x308>
  80055e:	000ab403          	ld	s0,0(s5)
  800562:	0c044463          	bltz	s0,80062a <vprintfmt+0x330>
  800566:	86a2                	mv	a3,s0
  800568:	8aea                	mv	s5,s10
  80056a:	4729                	li	a4,10
  80056c:	b5d5                	j	800450 <vprintfmt+0x156>
  80056e:	000aa783          	lw	a5,0(s5)
  800572:	46e1                	li	a3,24
  800574:	0aa1                	addi	s5,s5,8
  800576:	41f7d71b          	sraiw	a4,a5,0x1f
  80057a:	8fb9                	xor	a5,a5,a4
  80057c:	40e7873b          	subw	a4,a5,a4
  800580:	02e6c663          	blt	a3,a4,8005ac <vprintfmt+0x2b2>
  800584:	00371793          	slli	a5,a4,0x3
  800588:	00000697          	auipc	a3,0x0
  80058c:	68868693          	addi	a3,a3,1672 # 800c10 <error_string>
  800590:	97b6                	add	a5,a5,a3
  800592:	639c                	ld	a5,0(a5)
  800594:	cf81                	beqz	a5,8005ac <vprintfmt+0x2b2>
  800596:	873e                	mv	a4,a5
  800598:	00000697          	auipc	a3,0x0
  80059c:	34068693          	addi	a3,a3,832 # 8008d8 <main+0x19c>
  8005a0:	8626                	mv	a2,s1
  8005a2:	85ca                	mv	a1,s2
  8005a4:	854e                	mv	a0,s3
  8005a6:	0d4000ef          	jal	ra,80067a <printfmt>
  8005aa:	b351                	j	80032e <vprintfmt+0x34>
  8005ac:	00000697          	auipc	a3,0x0
  8005b0:	31c68693          	addi	a3,a3,796 # 8008c8 <main+0x18c>
  8005b4:	8626                	mv	a2,s1
  8005b6:	85ca                	mv	a1,s2
  8005b8:	854e                	mv	a0,s3
  8005ba:	0c0000ef          	jal	ra,80067a <printfmt>
  8005be:	bb85                	j	80032e <vprintfmt+0x34>
  8005c0:	00000417          	auipc	s0,0x0
  8005c4:	30040413          	addi	s0,s0,768 # 8008c0 <main+0x184>
  8005c8:	85e6                	mv	a1,s9
  8005ca:	8522                	mv	a0,s0
  8005cc:	e442                	sd	a6,8(sp)
  8005ce:	0ca000ef          	jal	ra,800698 <strnlen>
  8005d2:	40ac0c3b          	subw	s8,s8,a0
  8005d6:	01805c63          	blez	s8,8005ee <vprintfmt+0x2f4>
  8005da:	6822                	ld	a6,8(sp)
  8005dc:	00080a9b          	sext.w	s5,a6
  8005e0:	3c7d                	addiw	s8,s8,-1
  8005e2:	864a                	mv	a2,s2
  8005e4:	85a6                	mv	a1,s1
  8005e6:	8556                	mv	a0,s5
  8005e8:	9982                	jalr	s3
  8005ea:	fe0c1be3          	bnez	s8,8005e0 <vprintfmt+0x2e6>
  8005ee:	00044683          	lbu	a3,0(s0)
  8005f2:	00140a93          	addi	s5,s0,1
  8005f6:	0006851b          	sext.w	a0,a3
  8005fa:	daa9                	beqz	a3,80054c <vprintfmt+0x252>
  8005fc:	05e00413          	li	s0,94
  800600:	b731                	j	80050c <vprintfmt+0x212>
  800602:	000aa403          	lw	s0,0(s5)
  800606:	bfb1                	j	800562 <vprintfmt+0x268>
  800608:	000ae683          	lwu	a3,0(s5)
  80060c:	4721                	li	a4,8
  80060e:	8ab2                	mv	s5,a2
  800610:	b581                	j	800450 <vprintfmt+0x156>
  800612:	000ae683          	lwu	a3,0(s5)
  800616:	4729                	li	a4,10
  800618:	8ab2                	mv	s5,a2
  80061a:	bd1d                	j	800450 <vprintfmt+0x156>
  80061c:	000ae683          	lwu	a3,0(s5)
  800620:	4741                	li	a4,16
  800622:	8ab2                	mv	s5,a2
  800624:	b535                	j	800450 <vprintfmt+0x156>
  800626:	9982                	jalr	s3
  800628:	b709                	j	80052a <vprintfmt+0x230>
  80062a:	864a                	mv	a2,s2
  80062c:	85a6                	mv	a1,s1
  80062e:	02d00513          	li	a0,45
  800632:	e042                	sd	a6,0(sp)
  800634:	9982                	jalr	s3
  800636:	6802                	ld	a6,0(sp)
  800638:	8aea                	mv	s5,s10
  80063a:	408006b3          	neg	a3,s0
  80063e:	4729                	li	a4,10
  800640:	bd01                	j	800450 <vprintfmt+0x156>
  800642:	03805163          	blez	s8,800664 <vprintfmt+0x36a>
  800646:	02d00693          	li	a3,45
  80064a:	f6d81be3          	bne	a6,a3,8005c0 <vprintfmt+0x2c6>
  80064e:	00000417          	auipc	s0,0x0
  800652:	27240413          	addi	s0,s0,626 # 8008c0 <main+0x184>
  800656:	02800693          	li	a3,40
  80065a:	02800513          	li	a0,40
  80065e:	00140a93          	addi	s5,s0,1
  800662:	b55d                	j	800508 <vprintfmt+0x20e>
  800664:	00000a97          	auipc	s5,0x0
  800668:	25da8a93          	addi	s5,s5,605 # 8008c1 <main+0x185>
  80066c:	02800513          	li	a0,40
  800670:	02800693          	li	a3,40
  800674:	05e00413          	li	s0,94
  800678:	bd51                	j	80050c <vprintfmt+0x212>

000000000080067a <printfmt>:
  80067a:	7139                	addi	sp,sp,-64
  80067c:	02010313          	addi	t1,sp,32
  800680:	f03a                	sd	a4,32(sp)
  800682:	871a                	mv	a4,t1
  800684:	ec06                	sd	ra,24(sp)
  800686:	f43e                	sd	a5,40(sp)
  800688:	f842                	sd	a6,48(sp)
  80068a:	fc46                	sd	a7,56(sp)
  80068c:	e41a                	sd	t1,8(sp)
  80068e:	c6dff0ef          	jal	ra,8002fa <vprintfmt>
  800692:	60e2                	ld	ra,24(sp)
  800694:	6121                	addi	sp,sp,64
  800696:	8082                	ret

0000000000800698 <strnlen>:
  800698:	4781                	li	a5,0
  80069a:	e589                	bnez	a1,8006a4 <strnlen+0xc>
  80069c:	a811                	j	8006b0 <strnlen+0x18>
  80069e:	0785                	addi	a5,a5,1
  8006a0:	00f58863          	beq	a1,a5,8006b0 <strnlen+0x18>
  8006a4:	00f50733          	add	a4,a0,a5
  8006a8:	00074703          	lbu	a4,0(a4)
  8006ac:	fb6d                	bnez	a4,80069e <strnlen+0x6>
  8006ae:	85be                	mv	a1,a5
  8006b0:	852e                	mv	a0,a1
  8006b2:	8082                	ret

00000000008006b4 <do_yield>:
  8006b4:	1141                	addi	sp,sp,-16
  8006b6:	e406                	sd	ra,8(sp)
  8006b8:	b0fff0ef          	jal	ra,8001c6 <yield>
  8006bc:	b0bff0ef          	jal	ra,8001c6 <yield>
  8006c0:	b07ff0ef          	jal	ra,8001c6 <yield>
  8006c4:	b03ff0ef          	jal	ra,8001c6 <yield>
  8006c8:	affff0ef          	jal	ra,8001c6 <yield>
  8006cc:	60a2                	ld	ra,8(sp)
  8006ce:	0141                	addi	sp,sp,16
  8006d0:	bcdd                	j	8001c6 <yield>

00000000008006d2 <loop>:
  8006d2:	1141                	addi	sp,sp,-16
  8006d4:	00000517          	auipc	a0,0x0
  8006d8:	60450513          	addi	a0,a0,1540 # 800cd8 <error_string+0xc8>
  8006dc:	e406                	sd	ra,8(sp)
  8006de:	a19ff0ef          	jal	ra,8000f6 <cprintf>
  8006e2:	a001                	j	8006e2 <loop+0x10>

00000000008006e4 <work>:
  8006e4:	1141                	addi	sp,sp,-16
  8006e6:	00000517          	auipc	a0,0x0
  8006ea:	60250513          	addi	a0,a0,1538 # 800ce8 <error_string+0xd8>
  8006ee:	e406                	sd	ra,8(sp)
  8006f0:	a07ff0ef          	jal	ra,8000f6 <cprintf>
  8006f4:	fc1ff0ef          	jal	ra,8006b4 <do_yield>
  8006f8:	00001517          	auipc	a0,0x1
  8006fc:	90852503          	lw	a0,-1784(a0) # 801000 <parent>
  800700:	ac9ff0ef          	jal	ra,8001c8 <kill>
  800704:	e105                	bnez	a0,800724 <work+0x40>
  800706:	00000517          	auipc	a0,0x0
  80070a:	5f250513          	addi	a0,a0,1522 # 800cf8 <error_string+0xe8>
  80070e:	9e9ff0ef          	jal	ra,8000f6 <cprintf>
  800712:	fa3ff0ef          	jal	ra,8006b4 <do_yield>
  800716:	00001517          	auipc	a0,0x1
  80071a:	8ee52503          	lw	a0,-1810(a0) # 801004 <pid1>
  80071e:	aabff0ef          	jal	ra,8001c8 <kill>
  800722:	c501                	beqz	a0,80072a <work+0x46>
  800724:	557d                	li	a0,-1
  800726:	a87ff0ef          	jal	ra,8001ac <exit>
  80072a:	00000517          	auipc	a0,0x0
  80072e:	5e650513          	addi	a0,a0,1510 # 800d10 <error_string+0x100>
  800732:	9c5ff0ef          	jal	ra,8000f6 <cprintf>
  800736:	4501                	li	a0,0
  800738:	a75ff0ef          	jal	ra,8001ac <exit>

000000000080073c <main>:
  80073c:	1141                	addi	sp,sp,-16
  80073e:	e406                	sd	ra,8(sp)
  800740:	e022                	sd	s0,0(sp)
  800742:	a89ff0ef          	jal	ra,8001ca <getpid>
  800746:	00001797          	auipc	a5,0x1
  80074a:	8aa7ad23          	sw	a0,-1862(a5) # 801000 <parent>
  80074e:	00001417          	auipc	s0,0x1
  800752:	8b640413          	addi	s0,s0,-1866 # 801004 <pid1>
  800756:	a6dff0ef          	jal	ra,8001c2 <fork>
  80075a:	c008                	sw	a0,0(s0)
  80075c:	c13d                	beqz	a0,8007c2 <main+0x86>
  80075e:	04a05263          	blez	a0,8007a2 <main+0x66>
  800762:	a61ff0ef          	jal	ra,8001c2 <fork>
  800766:	00001797          	auipc	a5,0x1
  80076a:	8aa7a123          	sw	a0,-1886(a5) # 801008 <pid2>
  80076e:	c93d                	beqz	a0,8007e4 <main+0xa8>
  800770:	04a05b63          	blez	a0,8007c6 <main+0x8a>
  800774:	00000517          	auipc	a0,0x0
  800778:	5ec50513          	addi	a0,a0,1516 # 800d60 <error_string+0x150>
  80077c:	97bff0ef          	jal	ra,8000f6 <cprintf>
  800780:	4008                	lw	a0,0(s0)
  800782:	4581                	li	a1,0
  800784:	a41ff0ef          	jal	ra,8001c4 <waitpid>
  800788:	4014                	lw	a3,0(s0)
  80078a:	00000617          	auipc	a2,0x0
  80078e:	5e660613          	addi	a2,a2,1510 # 800d70 <error_string+0x160>
  800792:	03400593          	li	a1,52
  800796:	00000517          	auipc	a0,0x0
  80079a:	5ba50513          	addi	a0,a0,1466 # 800d50 <error_string+0x140>
  80079e:	893ff0ef          	jal	ra,800030 <__panic>
  8007a2:	00000697          	auipc	a3,0x0
  8007a6:	58668693          	addi	a3,a3,1414 # 800d28 <error_string+0x118>
  8007aa:	00000617          	auipc	a2,0x0
  8007ae:	58e60613          	addi	a2,a2,1422 # 800d38 <error_string+0x128>
  8007b2:	02c00593          	li	a1,44
  8007b6:	00000517          	auipc	a0,0x0
  8007ba:	59a50513          	addi	a0,a0,1434 # 800d50 <error_string+0x140>
  8007be:	873ff0ef          	jal	ra,800030 <__panic>
  8007c2:	f11ff0ef          	jal	ra,8006d2 <loop>
  8007c6:	4008                	lw	a0,0(s0)
  8007c8:	a01ff0ef          	jal	ra,8001c8 <kill>
  8007cc:	00000617          	auipc	a2,0x0
  8007d0:	5bc60613          	addi	a2,a2,1468 # 800d88 <error_string+0x178>
  8007d4:	03900593          	li	a1,57
  8007d8:	00000517          	auipc	a0,0x0
  8007dc:	57850513          	addi	a0,a0,1400 # 800d50 <error_string+0x140>
  8007e0:	851ff0ef          	jal	ra,800030 <__panic>
  8007e4:	f01ff0ef          	jal	ra,8006e4 <work>
