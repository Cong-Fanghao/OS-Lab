
obj/__user_softint.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa01                	j	800134 <sys_open>

0000000000800026 <close>:
  800026:	aa21                	j	80013e <sys_close>

0000000000800028 <dup2>:
  800028:	aa39                	j	800146 <sys_dup>

000000000080002a <_start>:
  80002a:	180000ef          	jal	ra,8001aa <umain>
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
  800044:	63850513          	addi	a0,a0,1592 # 800678 <main+0x2a>
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
  800064:	67050513          	addi	a0,a0,1648 # 8006d0 <main+0x82>
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
  80007c:	0b2000ef          	jal	ra,80012e <sys_putc>
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
  8000a0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6059>
  8000a4:	ec06                	sd	ra,24(sp)
  8000a6:	c602                	sw	zero,12(sp)
  8000a8:	1ec000ef          	jal	ra,800294 <vprintfmt>
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
  8000d4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6059>
  8000d8:	ec06                	sd	ra,24(sp)
  8000da:	e4be                	sd	a5,72(sp)
  8000dc:	e8c2                	sd	a6,80(sp)
  8000de:	ecc6                	sd	a7,88(sp)
  8000e0:	e41a                	sd	t1,8(sp)
  8000e2:	c202                	sw	zero,4(sp)
  8000e4:	1b0000ef          	jal	ra,800294 <vprintfmt>
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

000000000080012e <sys_putc>:
  80012e:	85aa                	mv	a1,a0
  800130:	4579                	li	a0,30
  800132:	bf7d                	j	8000f0 <syscall>

0000000000800134 <sys_open>:
  800134:	862e                	mv	a2,a1
  800136:	85aa                	mv	a1,a0
  800138:	06400513          	li	a0,100
  80013c:	bf55                	j	8000f0 <syscall>

000000000080013e <sys_close>:
  80013e:	85aa                	mv	a1,a0
  800140:	06500513          	li	a0,101
  800144:	b775                	j	8000f0 <syscall>

0000000000800146 <sys_dup>:
  800146:	862e                	mv	a2,a1
  800148:	85aa                	mv	a1,a0
  80014a:	08200513          	li	a0,130
  80014e:	b74d                	j	8000f0 <syscall>

0000000000800150 <exit>:
  800150:	1141                	addi	sp,sp,-16
  800152:	e406                	sd	ra,8(sp)
  800154:	fd5ff0ef          	jal	ra,800128 <sys_exit>
  800158:	00000517          	auipc	a0,0x0
  80015c:	54050513          	addi	a0,a0,1344 # 800698 <main+0x4a>
  800160:	f55ff0ef          	jal	ra,8000b4 <cprintf>
  800164:	a001                	j	800164 <exit+0x14>

0000000000800166 <initfd>:
  800166:	1101                	addi	sp,sp,-32
  800168:	87ae                	mv	a5,a1
  80016a:	e426                	sd	s1,8(sp)
  80016c:	85b2                	mv	a1,a2
  80016e:	84aa                	mv	s1,a0
  800170:	853e                	mv	a0,a5
  800172:	e822                	sd	s0,16(sp)
  800174:	ec06                	sd	ra,24(sp)
  800176:	eabff0ef          	jal	ra,800020 <open>
  80017a:	842a                	mv	s0,a0
  80017c:	00054463          	bltz	a0,800184 <initfd+0x1e>
  800180:	00951863          	bne	a0,s1,800190 <initfd+0x2a>
  800184:	60e2                	ld	ra,24(sp)
  800186:	8522                	mv	a0,s0
  800188:	6442                	ld	s0,16(sp)
  80018a:	64a2                	ld	s1,8(sp)
  80018c:	6105                	addi	sp,sp,32
  80018e:	8082                	ret
  800190:	8526                	mv	a0,s1
  800192:	e95ff0ef          	jal	ra,800026 <close>
  800196:	85a6                	mv	a1,s1
  800198:	8522                	mv	a0,s0
  80019a:	e8fff0ef          	jal	ra,800028 <dup2>
  80019e:	84aa                	mv	s1,a0
  8001a0:	8522                	mv	a0,s0
  8001a2:	e85ff0ef          	jal	ra,800026 <close>
  8001a6:	8426                	mv	s0,s1
  8001a8:	bff1                	j	800184 <initfd+0x1e>

00000000008001aa <umain>:
  8001aa:	1101                	addi	sp,sp,-32
  8001ac:	e822                	sd	s0,16(sp)
  8001ae:	e426                	sd	s1,8(sp)
  8001b0:	842a                	mv	s0,a0
  8001b2:	84ae                	mv	s1,a1
  8001b4:	4601                	li	a2,0
  8001b6:	00000597          	auipc	a1,0x0
  8001ba:	4fa58593          	addi	a1,a1,1274 # 8006b0 <main+0x62>
  8001be:	4501                	li	a0,0
  8001c0:	ec06                	sd	ra,24(sp)
  8001c2:	fa5ff0ef          	jal	ra,800166 <initfd>
  8001c6:	02054263          	bltz	a0,8001ea <umain+0x40>
  8001ca:	4605                	li	a2,1
  8001cc:	00000597          	auipc	a1,0x0
  8001d0:	52458593          	addi	a1,a1,1316 # 8006f0 <main+0xa2>
  8001d4:	4505                	li	a0,1
  8001d6:	f91ff0ef          	jal	ra,800166 <initfd>
  8001da:	02054563          	bltz	a0,800204 <umain+0x5a>
  8001de:	85a6                	mv	a1,s1
  8001e0:	8522                	mv	a0,s0
  8001e2:	46c000ef          	jal	ra,80064e <main>
  8001e6:	f6bff0ef          	jal	ra,800150 <exit>
  8001ea:	86aa                	mv	a3,a0
  8001ec:	00000617          	auipc	a2,0x0
  8001f0:	4cc60613          	addi	a2,a2,1228 # 8006b8 <main+0x6a>
  8001f4:	45e9                	li	a1,26
  8001f6:	00000517          	auipc	a0,0x0
  8001fa:	4e250513          	addi	a0,a0,1250 # 8006d8 <main+0x8a>
  8001fe:	e33ff0ef          	jal	ra,800030 <__warn>
  800202:	b7e1                	j	8001ca <umain+0x20>
  800204:	86aa                	mv	a3,a0
  800206:	00000617          	auipc	a2,0x0
  80020a:	4f260613          	addi	a2,a2,1266 # 8006f8 <main+0xaa>
  80020e:	45f5                	li	a1,29
  800210:	00000517          	auipc	a0,0x0
  800214:	4c850513          	addi	a0,a0,1224 # 8006d8 <main+0x8a>
  800218:	e19ff0ef          	jal	ra,800030 <__warn>
  80021c:	b7c9                	j	8001de <umain+0x34>

000000000080021e <printnum>:
  80021e:	02071893          	slli	a7,a4,0x20
  800222:	7139                	addi	sp,sp,-64
  800224:	0208d893          	srli	a7,a7,0x20
  800228:	e456                	sd	s5,8(sp)
  80022a:	0316fab3          	remu	s5,a3,a7
  80022e:	f822                	sd	s0,48(sp)
  800230:	f426                	sd	s1,40(sp)
  800232:	f04a                	sd	s2,32(sp)
  800234:	ec4e                	sd	s3,24(sp)
  800236:	fc06                	sd	ra,56(sp)
  800238:	e852                	sd	s4,16(sp)
  80023a:	84aa                	mv	s1,a0
  80023c:	89ae                	mv	s3,a1
  80023e:	8932                	mv	s2,a2
  800240:	fff7841b          	addiw	s0,a5,-1
  800244:	2a81                	sext.w	s5,s5
  800246:	0516f163          	bgeu	a3,a7,800288 <printnum+0x6a>
  80024a:	8a42                	mv	s4,a6
  80024c:	00805863          	blez	s0,80025c <printnum+0x3e>
  800250:	347d                	addiw	s0,s0,-1
  800252:	864e                	mv	a2,s3
  800254:	85ca                	mv	a1,s2
  800256:	8552                	mv	a0,s4
  800258:	9482                	jalr	s1
  80025a:	f87d                	bnez	s0,800250 <printnum+0x32>
  80025c:	1a82                	slli	s5,s5,0x20
  80025e:	00000797          	auipc	a5,0x0
  800262:	4ba78793          	addi	a5,a5,1210 # 800718 <main+0xca>
  800266:	020ada93          	srli	s5,s5,0x20
  80026a:	9abe                	add	s5,s5,a5
  80026c:	7442                	ld	s0,48(sp)
  80026e:	000ac503          	lbu	a0,0(s5)
  800272:	70e2                	ld	ra,56(sp)
  800274:	6a42                	ld	s4,16(sp)
  800276:	6aa2                	ld	s5,8(sp)
  800278:	864e                	mv	a2,s3
  80027a:	85ca                	mv	a1,s2
  80027c:	69e2                	ld	s3,24(sp)
  80027e:	7902                	ld	s2,32(sp)
  800280:	87a6                	mv	a5,s1
  800282:	74a2                	ld	s1,40(sp)
  800284:	6121                	addi	sp,sp,64
  800286:	8782                	jr	a5
  800288:	0316d6b3          	divu	a3,a3,a7
  80028c:	87a2                	mv	a5,s0
  80028e:	f91ff0ef          	jal	ra,80021e <printnum>
  800292:	b7e9                	j	80025c <printnum+0x3e>

0000000000800294 <vprintfmt>:
  800294:	7119                	addi	sp,sp,-128
  800296:	f4a6                	sd	s1,104(sp)
  800298:	f0ca                	sd	s2,96(sp)
  80029a:	ecce                	sd	s3,88(sp)
  80029c:	e8d2                	sd	s4,80(sp)
  80029e:	e4d6                	sd	s5,72(sp)
  8002a0:	e0da                	sd	s6,64(sp)
  8002a2:	fc5e                	sd	s7,56(sp)
  8002a4:	ec6e                	sd	s11,24(sp)
  8002a6:	fc86                	sd	ra,120(sp)
  8002a8:	f8a2                	sd	s0,112(sp)
  8002aa:	f862                	sd	s8,48(sp)
  8002ac:	f466                	sd	s9,40(sp)
  8002ae:	f06a                	sd	s10,32(sp)
  8002b0:	89aa                	mv	s3,a0
  8002b2:	892e                	mv	s2,a1
  8002b4:	84b2                	mv	s1,a2
  8002b6:	8db6                	mv	s11,a3
  8002b8:	8aba                	mv	s5,a4
  8002ba:	02500a13          	li	s4,37
  8002be:	5bfd                	li	s7,-1
  8002c0:	00000b17          	auipc	s6,0x0
  8002c4:	48cb0b13          	addi	s6,s6,1164 # 80074c <main+0xfe>
  8002c8:	000dc503          	lbu	a0,0(s11)
  8002cc:	001d8413          	addi	s0,s11,1
  8002d0:	01450b63          	beq	a0,s4,8002e6 <vprintfmt+0x52>
  8002d4:	c129                	beqz	a0,800316 <vprintfmt+0x82>
  8002d6:	864a                	mv	a2,s2
  8002d8:	85a6                	mv	a1,s1
  8002da:	0405                	addi	s0,s0,1
  8002dc:	9982                	jalr	s3
  8002de:	fff44503          	lbu	a0,-1(s0)
  8002e2:	ff4519e3          	bne	a0,s4,8002d4 <vprintfmt+0x40>
  8002e6:	00044583          	lbu	a1,0(s0)
  8002ea:	02000813          	li	a6,32
  8002ee:	4d01                	li	s10,0
  8002f0:	4301                	li	t1,0
  8002f2:	5cfd                	li	s9,-1
  8002f4:	5c7d                	li	s8,-1
  8002f6:	05500513          	li	a0,85
  8002fa:	48a5                	li	a7,9
  8002fc:	fdd5861b          	addiw	a2,a1,-35
  800300:	0ff67613          	zext.b	a2,a2
  800304:	00140d93          	addi	s11,s0,1
  800308:	04c56263          	bltu	a0,a2,80034c <vprintfmt+0xb8>
  80030c:	060a                	slli	a2,a2,0x2
  80030e:	965a                	add	a2,a2,s6
  800310:	4214                	lw	a3,0(a2)
  800312:	96da                	add	a3,a3,s6
  800314:	8682                	jr	a3
  800316:	70e6                	ld	ra,120(sp)
  800318:	7446                	ld	s0,112(sp)
  80031a:	74a6                	ld	s1,104(sp)
  80031c:	7906                	ld	s2,96(sp)
  80031e:	69e6                	ld	s3,88(sp)
  800320:	6a46                	ld	s4,80(sp)
  800322:	6aa6                	ld	s5,72(sp)
  800324:	6b06                	ld	s6,64(sp)
  800326:	7be2                	ld	s7,56(sp)
  800328:	7c42                	ld	s8,48(sp)
  80032a:	7ca2                	ld	s9,40(sp)
  80032c:	7d02                	ld	s10,32(sp)
  80032e:	6de2                	ld	s11,24(sp)
  800330:	6109                	addi	sp,sp,128
  800332:	8082                	ret
  800334:	882e                	mv	a6,a1
  800336:	00144583          	lbu	a1,1(s0)
  80033a:	846e                	mv	s0,s11
  80033c:	00140d93          	addi	s11,s0,1
  800340:	fdd5861b          	addiw	a2,a1,-35
  800344:	0ff67613          	zext.b	a2,a2
  800348:	fcc572e3          	bgeu	a0,a2,80030c <vprintfmt+0x78>
  80034c:	864a                	mv	a2,s2
  80034e:	85a6                	mv	a1,s1
  800350:	02500513          	li	a0,37
  800354:	9982                	jalr	s3
  800356:	fff44783          	lbu	a5,-1(s0)
  80035a:	8da2                	mv	s11,s0
  80035c:	f74786e3          	beq	a5,s4,8002c8 <vprintfmt+0x34>
  800360:	ffedc783          	lbu	a5,-2(s11)
  800364:	1dfd                	addi	s11,s11,-1
  800366:	ff479de3          	bne	a5,s4,800360 <vprintfmt+0xcc>
  80036a:	bfb9                	j	8002c8 <vprintfmt+0x34>
  80036c:	fd058c9b          	addiw	s9,a1,-48
  800370:	00144583          	lbu	a1,1(s0)
  800374:	846e                	mv	s0,s11
  800376:	fd05869b          	addiw	a3,a1,-48
  80037a:	0005861b          	sext.w	a2,a1
  80037e:	02d8e463          	bltu	a7,a3,8003a6 <vprintfmt+0x112>
  800382:	00144583          	lbu	a1,1(s0)
  800386:	002c969b          	slliw	a3,s9,0x2
  80038a:	0196873b          	addw	a4,a3,s9
  80038e:	0017171b          	slliw	a4,a4,0x1
  800392:	9f31                	addw	a4,a4,a2
  800394:	fd05869b          	addiw	a3,a1,-48
  800398:	0405                	addi	s0,s0,1
  80039a:	fd070c9b          	addiw	s9,a4,-48
  80039e:	0005861b          	sext.w	a2,a1
  8003a2:	fed8f0e3          	bgeu	a7,a3,800382 <vprintfmt+0xee>
  8003a6:	f40c5be3          	bgez	s8,8002fc <vprintfmt+0x68>
  8003aa:	8c66                	mv	s8,s9
  8003ac:	5cfd                	li	s9,-1
  8003ae:	b7b9                	j	8002fc <vprintfmt+0x68>
  8003b0:	fffc4693          	not	a3,s8
  8003b4:	96fd                	srai	a3,a3,0x3f
  8003b6:	00dc77b3          	and	a5,s8,a3
  8003ba:	00144583          	lbu	a1,1(s0)
  8003be:	00078c1b          	sext.w	s8,a5
  8003c2:	846e                	mv	s0,s11
  8003c4:	bf25                	j	8002fc <vprintfmt+0x68>
  8003c6:	000aac83          	lw	s9,0(s5)
  8003ca:	00144583          	lbu	a1,1(s0)
  8003ce:	0aa1                	addi	s5,s5,8
  8003d0:	846e                	mv	s0,s11
  8003d2:	bfd1                	j	8003a6 <vprintfmt+0x112>
  8003d4:	4705                	li	a4,1
  8003d6:	008a8613          	addi	a2,s5,8
  8003da:	00674463          	blt	a4,t1,8003e2 <vprintfmt+0x14e>
  8003de:	1c030c63          	beqz	t1,8005b6 <vprintfmt+0x322>
  8003e2:	000ab683          	ld	a3,0(s5)
  8003e6:	4741                	li	a4,16
  8003e8:	8ab2                	mv	s5,a2
  8003ea:	2801                	sext.w	a6,a6
  8003ec:	87e2                	mv	a5,s8
  8003ee:	8626                	mv	a2,s1
  8003f0:	85ca                	mv	a1,s2
  8003f2:	854e                	mv	a0,s3
  8003f4:	e2bff0ef          	jal	ra,80021e <printnum>
  8003f8:	bdc1                	j	8002c8 <vprintfmt+0x34>
  8003fa:	000aa503          	lw	a0,0(s5)
  8003fe:	864a                	mv	a2,s2
  800400:	85a6                	mv	a1,s1
  800402:	0aa1                	addi	s5,s5,8
  800404:	9982                	jalr	s3
  800406:	b5c9                	j	8002c8 <vprintfmt+0x34>
  800408:	4705                	li	a4,1
  80040a:	008a8613          	addi	a2,s5,8
  80040e:	00674463          	blt	a4,t1,800416 <vprintfmt+0x182>
  800412:	18030d63          	beqz	t1,8005ac <vprintfmt+0x318>
  800416:	000ab683          	ld	a3,0(s5)
  80041a:	4729                	li	a4,10
  80041c:	8ab2                	mv	s5,a2
  80041e:	b7f1                	j	8003ea <vprintfmt+0x156>
  800420:	00144583          	lbu	a1,1(s0)
  800424:	4d05                	li	s10,1
  800426:	846e                	mv	s0,s11
  800428:	bdd1                	j	8002fc <vprintfmt+0x68>
  80042a:	864a                	mv	a2,s2
  80042c:	85a6                	mv	a1,s1
  80042e:	02500513          	li	a0,37
  800432:	9982                	jalr	s3
  800434:	bd51                	j	8002c8 <vprintfmt+0x34>
  800436:	00144583          	lbu	a1,1(s0)
  80043a:	2305                	addiw	t1,t1,1
  80043c:	846e                	mv	s0,s11
  80043e:	bd7d                	j	8002fc <vprintfmt+0x68>
  800440:	4705                	li	a4,1
  800442:	008a8613          	addi	a2,s5,8
  800446:	00674463          	blt	a4,t1,80044e <vprintfmt+0x1ba>
  80044a:	14030c63          	beqz	t1,8005a2 <vprintfmt+0x30e>
  80044e:	000ab683          	ld	a3,0(s5)
  800452:	4721                	li	a4,8
  800454:	8ab2                	mv	s5,a2
  800456:	bf51                	j	8003ea <vprintfmt+0x156>
  800458:	03000513          	li	a0,48
  80045c:	864a                	mv	a2,s2
  80045e:	85a6                	mv	a1,s1
  800460:	e042                	sd	a6,0(sp)
  800462:	9982                	jalr	s3
  800464:	864a                	mv	a2,s2
  800466:	85a6                	mv	a1,s1
  800468:	07800513          	li	a0,120
  80046c:	9982                	jalr	s3
  80046e:	0aa1                	addi	s5,s5,8
  800470:	6802                	ld	a6,0(sp)
  800472:	4741                	li	a4,16
  800474:	ff8ab683          	ld	a3,-8(s5)
  800478:	bf8d                	j	8003ea <vprintfmt+0x156>
  80047a:	000ab403          	ld	s0,0(s5)
  80047e:	008a8793          	addi	a5,s5,8
  800482:	e03e                	sd	a5,0(sp)
  800484:	14040c63          	beqz	s0,8005dc <vprintfmt+0x348>
  800488:	11805063          	blez	s8,800588 <vprintfmt+0x2f4>
  80048c:	02d00693          	li	a3,45
  800490:	0cd81963          	bne	a6,a3,800562 <vprintfmt+0x2ce>
  800494:	00044683          	lbu	a3,0(s0)
  800498:	0006851b          	sext.w	a0,a3
  80049c:	ce8d                	beqz	a3,8004d6 <vprintfmt+0x242>
  80049e:	00140a93          	addi	s5,s0,1
  8004a2:	05e00413          	li	s0,94
  8004a6:	000cc563          	bltz	s9,8004b0 <vprintfmt+0x21c>
  8004aa:	3cfd                	addiw	s9,s9,-1
  8004ac:	037c8363          	beq	s9,s7,8004d2 <vprintfmt+0x23e>
  8004b0:	864a                	mv	a2,s2
  8004b2:	85a6                	mv	a1,s1
  8004b4:	100d0663          	beqz	s10,8005c0 <vprintfmt+0x32c>
  8004b8:	3681                	addiw	a3,a3,-32
  8004ba:	10d47363          	bgeu	s0,a3,8005c0 <vprintfmt+0x32c>
  8004be:	03f00513          	li	a0,63
  8004c2:	9982                	jalr	s3
  8004c4:	000ac683          	lbu	a3,0(s5)
  8004c8:	3c7d                	addiw	s8,s8,-1
  8004ca:	0a85                	addi	s5,s5,1
  8004cc:	0006851b          	sext.w	a0,a3
  8004d0:	faf9                	bnez	a3,8004a6 <vprintfmt+0x212>
  8004d2:	01805a63          	blez	s8,8004e6 <vprintfmt+0x252>
  8004d6:	3c7d                	addiw	s8,s8,-1
  8004d8:	864a                	mv	a2,s2
  8004da:	85a6                	mv	a1,s1
  8004dc:	02000513          	li	a0,32
  8004e0:	9982                	jalr	s3
  8004e2:	fe0c1ae3          	bnez	s8,8004d6 <vprintfmt+0x242>
  8004e6:	6a82                	ld	s5,0(sp)
  8004e8:	b3c5                	j	8002c8 <vprintfmt+0x34>
  8004ea:	4705                	li	a4,1
  8004ec:	008a8d13          	addi	s10,s5,8
  8004f0:	00674463          	blt	a4,t1,8004f8 <vprintfmt+0x264>
  8004f4:	0a030463          	beqz	t1,80059c <vprintfmt+0x308>
  8004f8:	000ab403          	ld	s0,0(s5)
  8004fc:	0c044463          	bltz	s0,8005c4 <vprintfmt+0x330>
  800500:	86a2                	mv	a3,s0
  800502:	8aea                	mv	s5,s10
  800504:	4729                	li	a4,10
  800506:	b5d5                	j	8003ea <vprintfmt+0x156>
  800508:	000aa783          	lw	a5,0(s5)
  80050c:	46e1                	li	a3,24
  80050e:	0aa1                	addi	s5,s5,8
  800510:	41f7d71b          	sraiw	a4,a5,0x1f
  800514:	8fb9                	xor	a5,a5,a4
  800516:	40e7873b          	subw	a4,a5,a4
  80051a:	02e6c663          	blt	a3,a4,800546 <vprintfmt+0x2b2>
  80051e:	00371793          	slli	a5,a4,0x3
  800522:	00000697          	auipc	a3,0x0
  800526:	55e68693          	addi	a3,a3,1374 # 800a80 <error_string>
  80052a:	97b6                	add	a5,a5,a3
  80052c:	639c                	ld	a5,0(a5)
  80052e:	cf81                	beqz	a5,800546 <vprintfmt+0x2b2>
  800530:	873e                	mv	a4,a5
  800532:	00000697          	auipc	a3,0x0
  800536:	21668693          	addi	a3,a3,534 # 800748 <main+0xfa>
  80053a:	8626                	mv	a2,s1
  80053c:	85ca                	mv	a1,s2
  80053e:	854e                	mv	a0,s3
  800540:	0d4000ef          	jal	ra,800614 <printfmt>
  800544:	b351                	j	8002c8 <vprintfmt+0x34>
  800546:	00000697          	auipc	a3,0x0
  80054a:	1f268693          	addi	a3,a3,498 # 800738 <main+0xea>
  80054e:	8626                	mv	a2,s1
  800550:	85ca                	mv	a1,s2
  800552:	854e                	mv	a0,s3
  800554:	0c0000ef          	jal	ra,800614 <printfmt>
  800558:	bb85                	j	8002c8 <vprintfmt+0x34>
  80055a:	00000417          	auipc	s0,0x0
  80055e:	1d640413          	addi	s0,s0,470 # 800730 <main+0xe2>
  800562:	85e6                	mv	a1,s9
  800564:	8522                	mv	a0,s0
  800566:	e442                	sd	a6,8(sp)
  800568:	0ca000ef          	jal	ra,800632 <strnlen>
  80056c:	40ac0c3b          	subw	s8,s8,a0
  800570:	01805c63          	blez	s8,800588 <vprintfmt+0x2f4>
  800574:	6822                	ld	a6,8(sp)
  800576:	00080a9b          	sext.w	s5,a6
  80057a:	3c7d                	addiw	s8,s8,-1
  80057c:	864a                	mv	a2,s2
  80057e:	85a6                	mv	a1,s1
  800580:	8556                	mv	a0,s5
  800582:	9982                	jalr	s3
  800584:	fe0c1be3          	bnez	s8,80057a <vprintfmt+0x2e6>
  800588:	00044683          	lbu	a3,0(s0)
  80058c:	00140a93          	addi	s5,s0,1
  800590:	0006851b          	sext.w	a0,a3
  800594:	daa9                	beqz	a3,8004e6 <vprintfmt+0x252>
  800596:	05e00413          	li	s0,94
  80059a:	b731                	j	8004a6 <vprintfmt+0x212>
  80059c:	000aa403          	lw	s0,0(s5)
  8005a0:	bfb1                	j	8004fc <vprintfmt+0x268>
  8005a2:	000ae683          	lwu	a3,0(s5)
  8005a6:	4721                	li	a4,8
  8005a8:	8ab2                	mv	s5,a2
  8005aa:	b581                	j	8003ea <vprintfmt+0x156>
  8005ac:	000ae683          	lwu	a3,0(s5)
  8005b0:	4729                	li	a4,10
  8005b2:	8ab2                	mv	s5,a2
  8005b4:	bd1d                	j	8003ea <vprintfmt+0x156>
  8005b6:	000ae683          	lwu	a3,0(s5)
  8005ba:	4741                	li	a4,16
  8005bc:	8ab2                	mv	s5,a2
  8005be:	b535                	j	8003ea <vprintfmt+0x156>
  8005c0:	9982                	jalr	s3
  8005c2:	b709                	j	8004c4 <vprintfmt+0x230>
  8005c4:	864a                	mv	a2,s2
  8005c6:	85a6                	mv	a1,s1
  8005c8:	02d00513          	li	a0,45
  8005cc:	e042                	sd	a6,0(sp)
  8005ce:	9982                	jalr	s3
  8005d0:	6802                	ld	a6,0(sp)
  8005d2:	8aea                	mv	s5,s10
  8005d4:	408006b3          	neg	a3,s0
  8005d8:	4729                	li	a4,10
  8005da:	bd01                	j	8003ea <vprintfmt+0x156>
  8005dc:	03805163          	blez	s8,8005fe <vprintfmt+0x36a>
  8005e0:	02d00693          	li	a3,45
  8005e4:	f6d81be3          	bne	a6,a3,80055a <vprintfmt+0x2c6>
  8005e8:	00000417          	auipc	s0,0x0
  8005ec:	14840413          	addi	s0,s0,328 # 800730 <main+0xe2>
  8005f0:	02800693          	li	a3,40
  8005f4:	02800513          	li	a0,40
  8005f8:	00140a93          	addi	s5,s0,1
  8005fc:	b55d                	j	8004a2 <vprintfmt+0x20e>
  8005fe:	00000a97          	auipc	s5,0x0
  800602:	133a8a93          	addi	s5,s5,307 # 800731 <main+0xe3>
  800606:	02800513          	li	a0,40
  80060a:	02800693          	li	a3,40
  80060e:	05e00413          	li	s0,94
  800612:	bd51                	j	8004a6 <vprintfmt+0x212>

0000000000800614 <printfmt>:
  800614:	7139                	addi	sp,sp,-64
  800616:	02010313          	addi	t1,sp,32
  80061a:	f03a                	sd	a4,32(sp)
  80061c:	871a                	mv	a4,t1
  80061e:	ec06                	sd	ra,24(sp)
  800620:	f43e                	sd	a5,40(sp)
  800622:	f842                	sd	a6,48(sp)
  800624:	fc46                	sd	a7,56(sp)
  800626:	e41a                	sd	t1,8(sp)
  800628:	c6dff0ef          	jal	ra,800294 <vprintfmt>
  80062c:	60e2                	ld	ra,24(sp)
  80062e:	6121                	addi	sp,sp,64
  800630:	8082                	ret

0000000000800632 <strnlen>:
  800632:	4781                	li	a5,0
  800634:	e589                	bnez	a1,80063e <strnlen+0xc>
  800636:	a811                	j	80064a <strnlen+0x18>
  800638:	0785                	addi	a5,a5,1
  80063a:	00f58863          	beq	a1,a5,80064a <strnlen+0x18>
  80063e:	00f50733          	add	a4,a0,a5
  800642:	00074703          	lbu	a4,0(a4)
  800646:	fb6d                	bnez	a4,800638 <strnlen+0x6>
  800648:	85be                	mv	a1,a5
  80064a:	852e                	mv	a0,a1
  80064c:	8082                	ret

000000000080064e <main>:
  80064e:	1141                	addi	sp,sp,-16
  800650:	4501                	li	a0,0
  800652:	e406                	sd	ra,8(sp)
  800654:	afdff0ef          	jal	ra,800150 <exit>
