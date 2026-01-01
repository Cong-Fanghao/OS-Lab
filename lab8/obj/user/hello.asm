
obj/__user_hello.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa11                	j	800138 <sys_open>

0000000000800026 <close>:
  800026:	aa31                	j	800142 <sys_close>

0000000000800028 <dup2>:
  800028:	a20d                	j	80014a <sys_dup>

000000000080002a <_start>:
  80002a:	186000ef          	jal	ra,8001b0 <umain>
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
  800044:	67050513          	addi	a0,a0,1648 # 8006b0 <main+0x5c>
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
  800060:	00001517          	auipc	a0,0x1
  800064:	b4050513          	addi	a0,a0,-1216 # 800ba0 <error_string+0xe8>
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
  80007c:	0b6000ef          	jal	ra,800132 <sys_putc>
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
  8000a0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6021>
  8000a4:	ec06                	sd	ra,24(sp)
  8000a6:	c602                	sw	zero,12(sp)
  8000a8:	1f2000ef          	jal	ra,80029a <vprintfmt>
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
  8000d4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6021>
  8000d8:	ec06                	sd	ra,24(sp)
  8000da:	e4be                	sd	a5,72(sp)
  8000dc:	e8c2                	sd	a6,80(sp)
  8000de:	ecc6                	sd	a7,88(sp)
  8000e0:	e41a                	sd	t1,8(sp)
  8000e2:	c202                	sw	zero,4(sp)
  8000e4:	1b6000ef          	jal	ra,80029a <vprintfmt>
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

000000000080012e <sys_getpid>:
  80012e:	4549                	li	a0,18
  800130:	b7c1                	j	8000f0 <syscall>

0000000000800132 <sys_putc>:
  800132:	85aa                	mv	a1,a0
  800134:	4579                	li	a0,30
  800136:	bf6d                	j	8000f0 <syscall>

0000000000800138 <sys_open>:
  800138:	862e                	mv	a2,a1
  80013a:	85aa                	mv	a1,a0
  80013c:	06400513          	li	a0,100
  800140:	bf45                	j	8000f0 <syscall>

0000000000800142 <sys_close>:
  800142:	85aa                	mv	a1,a0
  800144:	06500513          	li	a0,101
  800148:	b765                	j	8000f0 <syscall>

000000000080014a <sys_dup>:
  80014a:	862e                	mv	a2,a1
  80014c:	85aa                	mv	a1,a0
  80014e:	08200513          	li	a0,130
  800152:	bf79                	j	8000f0 <syscall>

0000000000800154 <exit>:
  800154:	1141                	addi	sp,sp,-16
  800156:	e406                	sd	ra,8(sp)
  800158:	fd1ff0ef          	jal	ra,800128 <sys_exit>
  80015c:	00000517          	auipc	a0,0x0
  800160:	57450513          	addi	a0,a0,1396 # 8006d0 <main+0x7c>
  800164:	f51ff0ef          	jal	ra,8000b4 <cprintf>
  800168:	a001                	j	800168 <exit+0x14>

000000000080016a <getpid>:
  80016a:	b7d1                	j	80012e <sys_getpid>

000000000080016c <initfd>:
  80016c:	1101                	addi	sp,sp,-32
  80016e:	87ae                	mv	a5,a1
  800170:	e426                	sd	s1,8(sp)
  800172:	85b2                	mv	a1,a2
  800174:	84aa                	mv	s1,a0
  800176:	853e                	mv	a0,a5
  800178:	e822                	sd	s0,16(sp)
  80017a:	ec06                	sd	ra,24(sp)
  80017c:	ea5ff0ef          	jal	ra,800020 <open>
  800180:	842a                	mv	s0,a0
  800182:	00054463          	bltz	a0,80018a <initfd+0x1e>
  800186:	00951863          	bne	a0,s1,800196 <initfd+0x2a>
  80018a:	60e2                	ld	ra,24(sp)
  80018c:	8522                	mv	a0,s0
  80018e:	6442                	ld	s0,16(sp)
  800190:	64a2                	ld	s1,8(sp)
  800192:	6105                	addi	sp,sp,32
  800194:	8082                	ret
  800196:	8526                	mv	a0,s1
  800198:	e8fff0ef          	jal	ra,800026 <close>
  80019c:	85a6                	mv	a1,s1
  80019e:	8522                	mv	a0,s0
  8001a0:	e89ff0ef          	jal	ra,800028 <dup2>
  8001a4:	84aa                	mv	s1,a0
  8001a6:	8522                	mv	a0,s0
  8001a8:	e7fff0ef          	jal	ra,800026 <close>
  8001ac:	8426                	mv	s0,s1
  8001ae:	bff1                	j	80018a <initfd+0x1e>

00000000008001b0 <umain>:
  8001b0:	1101                	addi	sp,sp,-32
  8001b2:	e822                	sd	s0,16(sp)
  8001b4:	e426                	sd	s1,8(sp)
  8001b6:	842a                	mv	s0,a0
  8001b8:	84ae                	mv	s1,a1
  8001ba:	4601                	li	a2,0
  8001bc:	00000597          	auipc	a1,0x0
  8001c0:	52c58593          	addi	a1,a1,1324 # 8006e8 <main+0x94>
  8001c4:	4501                	li	a0,0
  8001c6:	ec06                	sd	ra,24(sp)
  8001c8:	fa5ff0ef          	jal	ra,80016c <initfd>
  8001cc:	02054263          	bltz	a0,8001f0 <umain+0x40>
  8001d0:	4605                	li	a2,1
  8001d2:	00000597          	auipc	a1,0x0
  8001d6:	55658593          	addi	a1,a1,1366 # 800728 <main+0xd4>
  8001da:	4505                	li	a0,1
  8001dc:	f91ff0ef          	jal	ra,80016c <initfd>
  8001e0:	02054563          	bltz	a0,80020a <umain+0x5a>
  8001e4:	85a6                	mv	a1,s1
  8001e6:	8522                	mv	a0,s0
  8001e8:	46c000ef          	jal	ra,800654 <main>
  8001ec:	f69ff0ef          	jal	ra,800154 <exit>
  8001f0:	86aa                	mv	a3,a0
  8001f2:	00000617          	auipc	a2,0x0
  8001f6:	4fe60613          	addi	a2,a2,1278 # 8006f0 <main+0x9c>
  8001fa:	45e9                	li	a1,26
  8001fc:	00000517          	auipc	a0,0x0
  800200:	51450513          	addi	a0,a0,1300 # 800710 <main+0xbc>
  800204:	e2dff0ef          	jal	ra,800030 <__warn>
  800208:	b7e1                	j	8001d0 <umain+0x20>
  80020a:	86aa                	mv	a3,a0
  80020c:	00000617          	auipc	a2,0x0
  800210:	52460613          	addi	a2,a2,1316 # 800730 <main+0xdc>
  800214:	45f5                	li	a1,29
  800216:	00000517          	auipc	a0,0x0
  80021a:	4fa50513          	addi	a0,a0,1274 # 800710 <main+0xbc>
  80021e:	e13ff0ef          	jal	ra,800030 <__warn>
  800222:	b7c9                	j	8001e4 <umain+0x34>

0000000000800224 <printnum>:
  800224:	02071893          	slli	a7,a4,0x20
  800228:	7139                	addi	sp,sp,-64
  80022a:	0208d893          	srli	a7,a7,0x20
  80022e:	e456                	sd	s5,8(sp)
  800230:	0316fab3          	remu	s5,a3,a7
  800234:	f822                	sd	s0,48(sp)
  800236:	f426                	sd	s1,40(sp)
  800238:	f04a                	sd	s2,32(sp)
  80023a:	ec4e                	sd	s3,24(sp)
  80023c:	fc06                	sd	ra,56(sp)
  80023e:	e852                	sd	s4,16(sp)
  800240:	84aa                	mv	s1,a0
  800242:	89ae                	mv	s3,a1
  800244:	8932                	mv	s2,a2
  800246:	fff7841b          	addiw	s0,a5,-1
  80024a:	2a81                	sext.w	s5,s5
  80024c:	0516f163          	bgeu	a3,a7,80028e <printnum+0x6a>
  800250:	8a42                	mv	s4,a6
  800252:	00805863          	blez	s0,800262 <printnum+0x3e>
  800256:	347d                	addiw	s0,s0,-1
  800258:	864e                	mv	a2,s3
  80025a:	85ca                	mv	a1,s2
  80025c:	8552                	mv	a0,s4
  80025e:	9482                	jalr	s1
  800260:	f87d                	bnez	s0,800256 <printnum+0x32>
  800262:	1a82                	slli	s5,s5,0x20
  800264:	00000797          	auipc	a5,0x0
  800268:	4ec78793          	addi	a5,a5,1260 # 800750 <main+0xfc>
  80026c:	020ada93          	srli	s5,s5,0x20
  800270:	9abe                	add	s5,s5,a5
  800272:	7442                	ld	s0,48(sp)
  800274:	000ac503          	lbu	a0,0(s5)
  800278:	70e2                	ld	ra,56(sp)
  80027a:	6a42                	ld	s4,16(sp)
  80027c:	6aa2                	ld	s5,8(sp)
  80027e:	864e                	mv	a2,s3
  800280:	85ca                	mv	a1,s2
  800282:	69e2                	ld	s3,24(sp)
  800284:	7902                	ld	s2,32(sp)
  800286:	87a6                	mv	a5,s1
  800288:	74a2                	ld	s1,40(sp)
  80028a:	6121                	addi	sp,sp,64
  80028c:	8782                	jr	a5
  80028e:	0316d6b3          	divu	a3,a3,a7
  800292:	87a2                	mv	a5,s0
  800294:	f91ff0ef          	jal	ra,800224 <printnum>
  800298:	b7e9                	j	800262 <printnum+0x3e>

000000000080029a <vprintfmt>:
  80029a:	7119                	addi	sp,sp,-128
  80029c:	f4a6                	sd	s1,104(sp)
  80029e:	f0ca                	sd	s2,96(sp)
  8002a0:	ecce                	sd	s3,88(sp)
  8002a2:	e8d2                	sd	s4,80(sp)
  8002a4:	e4d6                	sd	s5,72(sp)
  8002a6:	e0da                	sd	s6,64(sp)
  8002a8:	fc5e                	sd	s7,56(sp)
  8002aa:	ec6e                	sd	s11,24(sp)
  8002ac:	fc86                	sd	ra,120(sp)
  8002ae:	f8a2                	sd	s0,112(sp)
  8002b0:	f862                	sd	s8,48(sp)
  8002b2:	f466                	sd	s9,40(sp)
  8002b4:	f06a                	sd	s10,32(sp)
  8002b6:	89aa                	mv	s3,a0
  8002b8:	892e                	mv	s2,a1
  8002ba:	84b2                	mv	s1,a2
  8002bc:	8db6                	mv	s11,a3
  8002be:	8aba                	mv	s5,a4
  8002c0:	02500a13          	li	s4,37
  8002c4:	5bfd                	li	s7,-1
  8002c6:	00000b17          	auipc	s6,0x0
  8002ca:	4beb0b13          	addi	s6,s6,1214 # 800784 <main+0x130>
  8002ce:	000dc503          	lbu	a0,0(s11)
  8002d2:	001d8413          	addi	s0,s11,1
  8002d6:	01450b63          	beq	a0,s4,8002ec <vprintfmt+0x52>
  8002da:	c129                	beqz	a0,80031c <vprintfmt+0x82>
  8002dc:	864a                	mv	a2,s2
  8002de:	85a6                	mv	a1,s1
  8002e0:	0405                	addi	s0,s0,1
  8002e2:	9982                	jalr	s3
  8002e4:	fff44503          	lbu	a0,-1(s0)
  8002e8:	ff4519e3          	bne	a0,s4,8002da <vprintfmt+0x40>
  8002ec:	00044583          	lbu	a1,0(s0)
  8002f0:	02000813          	li	a6,32
  8002f4:	4d01                	li	s10,0
  8002f6:	4301                	li	t1,0
  8002f8:	5cfd                	li	s9,-1
  8002fa:	5c7d                	li	s8,-1
  8002fc:	05500513          	li	a0,85
  800300:	48a5                	li	a7,9
  800302:	fdd5861b          	addiw	a2,a1,-35
  800306:	0ff67613          	zext.b	a2,a2
  80030a:	00140d93          	addi	s11,s0,1
  80030e:	04c56263          	bltu	a0,a2,800352 <vprintfmt+0xb8>
  800312:	060a                	slli	a2,a2,0x2
  800314:	965a                	add	a2,a2,s6
  800316:	4214                	lw	a3,0(a2)
  800318:	96da                	add	a3,a3,s6
  80031a:	8682                	jr	a3
  80031c:	70e6                	ld	ra,120(sp)
  80031e:	7446                	ld	s0,112(sp)
  800320:	74a6                	ld	s1,104(sp)
  800322:	7906                	ld	s2,96(sp)
  800324:	69e6                	ld	s3,88(sp)
  800326:	6a46                	ld	s4,80(sp)
  800328:	6aa6                	ld	s5,72(sp)
  80032a:	6b06                	ld	s6,64(sp)
  80032c:	7be2                	ld	s7,56(sp)
  80032e:	7c42                	ld	s8,48(sp)
  800330:	7ca2                	ld	s9,40(sp)
  800332:	7d02                	ld	s10,32(sp)
  800334:	6de2                	ld	s11,24(sp)
  800336:	6109                	addi	sp,sp,128
  800338:	8082                	ret
  80033a:	882e                	mv	a6,a1
  80033c:	00144583          	lbu	a1,1(s0)
  800340:	846e                	mv	s0,s11
  800342:	00140d93          	addi	s11,s0,1
  800346:	fdd5861b          	addiw	a2,a1,-35
  80034a:	0ff67613          	zext.b	a2,a2
  80034e:	fcc572e3          	bgeu	a0,a2,800312 <vprintfmt+0x78>
  800352:	864a                	mv	a2,s2
  800354:	85a6                	mv	a1,s1
  800356:	02500513          	li	a0,37
  80035a:	9982                	jalr	s3
  80035c:	fff44783          	lbu	a5,-1(s0)
  800360:	8da2                	mv	s11,s0
  800362:	f74786e3          	beq	a5,s4,8002ce <vprintfmt+0x34>
  800366:	ffedc783          	lbu	a5,-2(s11)
  80036a:	1dfd                	addi	s11,s11,-1
  80036c:	ff479de3          	bne	a5,s4,800366 <vprintfmt+0xcc>
  800370:	bfb9                	j	8002ce <vprintfmt+0x34>
  800372:	fd058c9b          	addiw	s9,a1,-48
  800376:	00144583          	lbu	a1,1(s0)
  80037a:	846e                	mv	s0,s11
  80037c:	fd05869b          	addiw	a3,a1,-48
  800380:	0005861b          	sext.w	a2,a1
  800384:	02d8e463          	bltu	a7,a3,8003ac <vprintfmt+0x112>
  800388:	00144583          	lbu	a1,1(s0)
  80038c:	002c969b          	slliw	a3,s9,0x2
  800390:	0196873b          	addw	a4,a3,s9
  800394:	0017171b          	slliw	a4,a4,0x1
  800398:	9f31                	addw	a4,a4,a2
  80039a:	fd05869b          	addiw	a3,a1,-48
  80039e:	0405                	addi	s0,s0,1
  8003a0:	fd070c9b          	addiw	s9,a4,-48
  8003a4:	0005861b          	sext.w	a2,a1
  8003a8:	fed8f0e3          	bgeu	a7,a3,800388 <vprintfmt+0xee>
  8003ac:	f40c5be3          	bgez	s8,800302 <vprintfmt+0x68>
  8003b0:	8c66                	mv	s8,s9
  8003b2:	5cfd                	li	s9,-1
  8003b4:	b7b9                	j	800302 <vprintfmt+0x68>
  8003b6:	fffc4693          	not	a3,s8
  8003ba:	96fd                	srai	a3,a3,0x3f
  8003bc:	00dc77b3          	and	a5,s8,a3
  8003c0:	00144583          	lbu	a1,1(s0)
  8003c4:	00078c1b          	sext.w	s8,a5
  8003c8:	846e                	mv	s0,s11
  8003ca:	bf25                	j	800302 <vprintfmt+0x68>
  8003cc:	000aac83          	lw	s9,0(s5)
  8003d0:	00144583          	lbu	a1,1(s0)
  8003d4:	0aa1                	addi	s5,s5,8
  8003d6:	846e                	mv	s0,s11
  8003d8:	bfd1                	j	8003ac <vprintfmt+0x112>
  8003da:	4705                	li	a4,1
  8003dc:	008a8613          	addi	a2,s5,8
  8003e0:	00674463          	blt	a4,t1,8003e8 <vprintfmt+0x14e>
  8003e4:	1c030c63          	beqz	t1,8005bc <vprintfmt+0x322>
  8003e8:	000ab683          	ld	a3,0(s5)
  8003ec:	4741                	li	a4,16
  8003ee:	8ab2                	mv	s5,a2
  8003f0:	2801                	sext.w	a6,a6
  8003f2:	87e2                	mv	a5,s8
  8003f4:	8626                	mv	a2,s1
  8003f6:	85ca                	mv	a1,s2
  8003f8:	854e                	mv	a0,s3
  8003fa:	e2bff0ef          	jal	ra,800224 <printnum>
  8003fe:	bdc1                	j	8002ce <vprintfmt+0x34>
  800400:	000aa503          	lw	a0,0(s5)
  800404:	864a                	mv	a2,s2
  800406:	85a6                	mv	a1,s1
  800408:	0aa1                	addi	s5,s5,8
  80040a:	9982                	jalr	s3
  80040c:	b5c9                	j	8002ce <vprintfmt+0x34>
  80040e:	4705                	li	a4,1
  800410:	008a8613          	addi	a2,s5,8
  800414:	00674463          	blt	a4,t1,80041c <vprintfmt+0x182>
  800418:	18030d63          	beqz	t1,8005b2 <vprintfmt+0x318>
  80041c:	000ab683          	ld	a3,0(s5)
  800420:	4729                	li	a4,10
  800422:	8ab2                	mv	s5,a2
  800424:	b7f1                	j	8003f0 <vprintfmt+0x156>
  800426:	00144583          	lbu	a1,1(s0)
  80042a:	4d05                	li	s10,1
  80042c:	846e                	mv	s0,s11
  80042e:	bdd1                	j	800302 <vprintfmt+0x68>
  800430:	864a                	mv	a2,s2
  800432:	85a6                	mv	a1,s1
  800434:	02500513          	li	a0,37
  800438:	9982                	jalr	s3
  80043a:	bd51                	j	8002ce <vprintfmt+0x34>
  80043c:	00144583          	lbu	a1,1(s0)
  800440:	2305                	addiw	t1,t1,1
  800442:	846e                	mv	s0,s11
  800444:	bd7d                	j	800302 <vprintfmt+0x68>
  800446:	4705                	li	a4,1
  800448:	008a8613          	addi	a2,s5,8
  80044c:	00674463          	blt	a4,t1,800454 <vprintfmt+0x1ba>
  800450:	14030c63          	beqz	t1,8005a8 <vprintfmt+0x30e>
  800454:	000ab683          	ld	a3,0(s5)
  800458:	4721                	li	a4,8
  80045a:	8ab2                	mv	s5,a2
  80045c:	bf51                	j	8003f0 <vprintfmt+0x156>
  80045e:	03000513          	li	a0,48
  800462:	864a                	mv	a2,s2
  800464:	85a6                	mv	a1,s1
  800466:	e042                	sd	a6,0(sp)
  800468:	9982                	jalr	s3
  80046a:	864a                	mv	a2,s2
  80046c:	85a6                	mv	a1,s1
  80046e:	07800513          	li	a0,120
  800472:	9982                	jalr	s3
  800474:	0aa1                	addi	s5,s5,8
  800476:	6802                	ld	a6,0(sp)
  800478:	4741                	li	a4,16
  80047a:	ff8ab683          	ld	a3,-8(s5)
  80047e:	bf8d                	j	8003f0 <vprintfmt+0x156>
  800480:	000ab403          	ld	s0,0(s5)
  800484:	008a8793          	addi	a5,s5,8
  800488:	e03e                	sd	a5,0(sp)
  80048a:	14040c63          	beqz	s0,8005e2 <vprintfmt+0x348>
  80048e:	11805063          	blez	s8,80058e <vprintfmt+0x2f4>
  800492:	02d00693          	li	a3,45
  800496:	0cd81963          	bne	a6,a3,800568 <vprintfmt+0x2ce>
  80049a:	00044683          	lbu	a3,0(s0)
  80049e:	0006851b          	sext.w	a0,a3
  8004a2:	ce8d                	beqz	a3,8004dc <vprintfmt+0x242>
  8004a4:	00140a93          	addi	s5,s0,1
  8004a8:	05e00413          	li	s0,94
  8004ac:	000cc563          	bltz	s9,8004b6 <vprintfmt+0x21c>
  8004b0:	3cfd                	addiw	s9,s9,-1
  8004b2:	037c8363          	beq	s9,s7,8004d8 <vprintfmt+0x23e>
  8004b6:	864a                	mv	a2,s2
  8004b8:	85a6                	mv	a1,s1
  8004ba:	100d0663          	beqz	s10,8005c6 <vprintfmt+0x32c>
  8004be:	3681                	addiw	a3,a3,-32
  8004c0:	10d47363          	bgeu	s0,a3,8005c6 <vprintfmt+0x32c>
  8004c4:	03f00513          	li	a0,63
  8004c8:	9982                	jalr	s3
  8004ca:	000ac683          	lbu	a3,0(s5)
  8004ce:	3c7d                	addiw	s8,s8,-1
  8004d0:	0a85                	addi	s5,s5,1
  8004d2:	0006851b          	sext.w	a0,a3
  8004d6:	faf9                	bnez	a3,8004ac <vprintfmt+0x212>
  8004d8:	01805a63          	blez	s8,8004ec <vprintfmt+0x252>
  8004dc:	3c7d                	addiw	s8,s8,-1
  8004de:	864a                	mv	a2,s2
  8004e0:	85a6                	mv	a1,s1
  8004e2:	02000513          	li	a0,32
  8004e6:	9982                	jalr	s3
  8004e8:	fe0c1ae3          	bnez	s8,8004dc <vprintfmt+0x242>
  8004ec:	6a82                	ld	s5,0(sp)
  8004ee:	b3c5                	j	8002ce <vprintfmt+0x34>
  8004f0:	4705                	li	a4,1
  8004f2:	008a8d13          	addi	s10,s5,8
  8004f6:	00674463          	blt	a4,t1,8004fe <vprintfmt+0x264>
  8004fa:	0a030463          	beqz	t1,8005a2 <vprintfmt+0x308>
  8004fe:	000ab403          	ld	s0,0(s5)
  800502:	0c044463          	bltz	s0,8005ca <vprintfmt+0x330>
  800506:	86a2                	mv	a3,s0
  800508:	8aea                	mv	s5,s10
  80050a:	4729                	li	a4,10
  80050c:	b5d5                	j	8003f0 <vprintfmt+0x156>
  80050e:	000aa783          	lw	a5,0(s5)
  800512:	46e1                	li	a3,24
  800514:	0aa1                	addi	s5,s5,8
  800516:	41f7d71b          	sraiw	a4,a5,0x1f
  80051a:	8fb9                	xor	a5,a5,a4
  80051c:	40e7873b          	subw	a4,a5,a4
  800520:	02e6c663          	blt	a3,a4,80054c <vprintfmt+0x2b2>
  800524:	00371793          	slli	a5,a4,0x3
  800528:	00000697          	auipc	a3,0x0
  80052c:	59068693          	addi	a3,a3,1424 # 800ab8 <error_string>
  800530:	97b6                	add	a5,a5,a3
  800532:	639c                	ld	a5,0(a5)
  800534:	cf81                	beqz	a5,80054c <vprintfmt+0x2b2>
  800536:	873e                	mv	a4,a5
  800538:	00000697          	auipc	a3,0x0
  80053c:	24868693          	addi	a3,a3,584 # 800780 <main+0x12c>
  800540:	8626                	mv	a2,s1
  800542:	85ca                	mv	a1,s2
  800544:	854e                	mv	a0,s3
  800546:	0d4000ef          	jal	ra,80061a <printfmt>
  80054a:	b351                	j	8002ce <vprintfmt+0x34>
  80054c:	00000697          	auipc	a3,0x0
  800550:	22468693          	addi	a3,a3,548 # 800770 <main+0x11c>
  800554:	8626                	mv	a2,s1
  800556:	85ca                	mv	a1,s2
  800558:	854e                	mv	a0,s3
  80055a:	0c0000ef          	jal	ra,80061a <printfmt>
  80055e:	bb85                	j	8002ce <vprintfmt+0x34>
  800560:	00000417          	auipc	s0,0x0
  800564:	20840413          	addi	s0,s0,520 # 800768 <main+0x114>
  800568:	85e6                	mv	a1,s9
  80056a:	8522                	mv	a0,s0
  80056c:	e442                	sd	a6,8(sp)
  80056e:	0ca000ef          	jal	ra,800638 <strnlen>
  800572:	40ac0c3b          	subw	s8,s8,a0
  800576:	01805c63          	blez	s8,80058e <vprintfmt+0x2f4>
  80057a:	6822                	ld	a6,8(sp)
  80057c:	00080a9b          	sext.w	s5,a6
  800580:	3c7d                	addiw	s8,s8,-1
  800582:	864a                	mv	a2,s2
  800584:	85a6                	mv	a1,s1
  800586:	8556                	mv	a0,s5
  800588:	9982                	jalr	s3
  80058a:	fe0c1be3          	bnez	s8,800580 <vprintfmt+0x2e6>
  80058e:	00044683          	lbu	a3,0(s0)
  800592:	00140a93          	addi	s5,s0,1
  800596:	0006851b          	sext.w	a0,a3
  80059a:	daa9                	beqz	a3,8004ec <vprintfmt+0x252>
  80059c:	05e00413          	li	s0,94
  8005a0:	b731                	j	8004ac <vprintfmt+0x212>
  8005a2:	000aa403          	lw	s0,0(s5)
  8005a6:	bfb1                	j	800502 <vprintfmt+0x268>
  8005a8:	000ae683          	lwu	a3,0(s5)
  8005ac:	4721                	li	a4,8
  8005ae:	8ab2                	mv	s5,a2
  8005b0:	b581                	j	8003f0 <vprintfmt+0x156>
  8005b2:	000ae683          	lwu	a3,0(s5)
  8005b6:	4729                	li	a4,10
  8005b8:	8ab2                	mv	s5,a2
  8005ba:	bd1d                	j	8003f0 <vprintfmt+0x156>
  8005bc:	000ae683          	lwu	a3,0(s5)
  8005c0:	4741                	li	a4,16
  8005c2:	8ab2                	mv	s5,a2
  8005c4:	b535                	j	8003f0 <vprintfmt+0x156>
  8005c6:	9982                	jalr	s3
  8005c8:	b709                	j	8004ca <vprintfmt+0x230>
  8005ca:	864a                	mv	a2,s2
  8005cc:	85a6                	mv	a1,s1
  8005ce:	02d00513          	li	a0,45
  8005d2:	e042                	sd	a6,0(sp)
  8005d4:	9982                	jalr	s3
  8005d6:	6802                	ld	a6,0(sp)
  8005d8:	8aea                	mv	s5,s10
  8005da:	408006b3          	neg	a3,s0
  8005de:	4729                	li	a4,10
  8005e0:	bd01                	j	8003f0 <vprintfmt+0x156>
  8005e2:	03805163          	blez	s8,800604 <vprintfmt+0x36a>
  8005e6:	02d00693          	li	a3,45
  8005ea:	f6d81be3          	bne	a6,a3,800560 <vprintfmt+0x2c6>
  8005ee:	00000417          	auipc	s0,0x0
  8005f2:	17a40413          	addi	s0,s0,378 # 800768 <main+0x114>
  8005f6:	02800693          	li	a3,40
  8005fa:	02800513          	li	a0,40
  8005fe:	00140a93          	addi	s5,s0,1
  800602:	b55d                	j	8004a8 <vprintfmt+0x20e>
  800604:	00000a97          	auipc	s5,0x0
  800608:	165a8a93          	addi	s5,s5,357 # 800769 <main+0x115>
  80060c:	02800513          	li	a0,40
  800610:	02800693          	li	a3,40
  800614:	05e00413          	li	s0,94
  800618:	bd51                	j	8004ac <vprintfmt+0x212>

000000000080061a <printfmt>:
  80061a:	7139                	addi	sp,sp,-64
  80061c:	02010313          	addi	t1,sp,32
  800620:	f03a                	sd	a4,32(sp)
  800622:	871a                	mv	a4,t1
  800624:	ec06                	sd	ra,24(sp)
  800626:	f43e                	sd	a5,40(sp)
  800628:	f842                	sd	a6,48(sp)
  80062a:	fc46                	sd	a7,56(sp)
  80062c:	e41a                	sd	t1,8(sp)
  80062e:	c6dff0ef          	jal	ra,80029a <vprintfmt>
  800632:	60e2                	ld	ra,24(sp)
  800634:	6121                	addi	sp,sp,64
  800636:	8082                	ret

0000000000800638 <strnlen>:
  800638:	4781                	li	a5,0
  80063a:	e589                	bnez	a1,800644 <strnlen+0xc>
  80063c:	a811                	j	800650 <strnlen+0x18>
  80063e:	0785                	addi	a5,a5,1
  800640:	00f58863          	beq	a1,a5,800650 <strnlen+0x18>
  800644:	00f50733          	add	a4,a0,a5
  800648:	00074703          	lbu	a4,0(a4)
  80064c:	fb6d                	bnez	a4,80063e <strnlen+0x6>
  80064e:	85be                	mv	a1,a5
  800650:	852e                	mv	a0,a1
  800652:	8082                	ret

0000000000800654 <main>:
  800654:	1141                	addi	sp,sp,-16
  800656:	00000517          	auipc	a0,0x0
  80065a:	52a50513          	addi	a0,a0,1322 # 800b80 <error_string+0xc8>
  80065e:	e406                	sd	ra,8(sp)
  800660:	a55ff0ef          	jal	ra,8000b4 <cprintf>
  800664:	b07ff0ef          	jal	ra,80016a <getpid>
  800668:	85aa                	mv	a1,a0
  80066a:	00000517          	auipc	a0,0x0
  80066e:	52650513          	addi	a0,a0,1318 # 800b90 <error_string+0xd8>
  800672:	a43ff0ef          	jal	ra,8000b4 <cprintf>
  800676:	00000517          	auipc	a0,0x0
  80067a:	53250513          	addi	a0,a0,1330 # 800ba8 <error_string+0xf0>
  80067e:	a37ff0ef          	jal	ra,8000b4 <cprintf>
  800682:	60a2                	ld	ra,8(sp)
  800684:	4501                	li	a0,0
  800686:	0141                	addi	sp,sp,16
  800688:	8082                	ret
