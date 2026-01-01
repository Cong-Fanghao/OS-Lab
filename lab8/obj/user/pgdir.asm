
obj/__user_pgdir.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa21                	j	80013c <sys_open>

0000000000800026 <close>:
  800026:	a205                	j	800146 <sys_close>

0000000000800028 <dup2>:
  800028:	a21d                	j	80014e <sys_dup>

000000000080002a <_start>:
  80002a:	18c000ef          	jal	ra,8001b6 <umain>
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
  800044:	66850513          	addi	a0,a0,1640 # 8006a8 <main+0x4e>
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
  800064:	6a050513          	addi	a0,a0,1696 # 800700 <main+0xa6>
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
  8000a0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6029>
  8000a4:	ec06                	sd	ra,24(sp)
  8000a6:	c602                	sw	zero,12(sp)
  8000a8:	1f8000ef          	jal	ra,8002a0 <vprintfmt>
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
  8000d4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f6029>
  8000d8:	ec06                	sd	ra,24(sp)
  8000da:	e4be                	sd	a5,72(sp)
  8000dc:	e8c2                	sd	a6,80(sp)
  8000de:	ecc6                	sd	a7,88(sp)
  8000e0:	e41a                	sd	t1,8(sp)
  8000e2:	c202                	sw	zero,4(sp)
  8000e4:	1bc000ef          	jal	ra,8002a0 <vprintfmt>
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

0000000000800138 <sys_pgdir>:
  800138:	457d                	li	a0,31
  80013a:	bf5d                	j	8000f0 <syscall>

000000000080013c <sys_open>:
  80013c:	862e                	mv	a2,a1
  80013e:	85aa                	mv	a1,a0
  800140:	06400513          	li	a0,100
  800144:	b775                	j	8000f0 <syscall>

0000000000800146 <sys_close>:
  800146:	85aa                	mv	a1,a0
  800148:	06500513          	li	a0,101
  80014c:	b755                	j	8000f0 <syscall>

000000000080014e <sys_dup>:
  80014e:	862e                	mv	a2,a1
  800150:	85aa                	mv	a1,a0
  800152:	08200513          	li	a0,130
  800156:	bf69                	j	8000f0 <syscall>

0000000000800158 <exit>:
  800158:	1141                	addi	sp,sp,-16
  80015a:	e406                	sd	ra,8(sp)
  80015c:	fcdff0ef          	jal	ra,800128 <sys_exit>
  800160:	00000517          	auipc	a0,0x0
  800164:	56850513          	addi	a0,a0,1384 # 8006c8 <main+0x6e>
  800168:	f4dff0ef          	jal	ra,8000b4 <cprintf>
  80016c:	a001                	j	80016c <exit+0x14>

000000000080016e <getpid>:
  80016e:	b7c1                	j	80012e <sys_getpid>

0000000000800170 <print_pgdir>:
  800170:	b7e1                	j	800138 <sys_pgdir>

0000000000800172 <initfd>:
  800172:	1101                	addi	sp,sp,-32
  800174:	87ae                	mv	a5,a1
  800176:	e426                	sd	s1,8(sp)
  800178:	85b2                	mv	a1,a2
  80017a:	84aa                	mv	s1,a0
  80017c:	853e                	mv	a0,a5
  80017e:	e822                	sd	s0,16(sp)
  800180:	ec06                	sd	ra,24(sp)
  800182:	e9fff0ef          	jal	ra,800020 <open>
  800186:	842a                	mv	s0,a0
  800188:	00054463          	bltz	a0,800190 <initfd+0x1e>
  80018c:	00951863          	bne	a0,s1,80019c <initfd+0x2a>
  800190:	60e2                	ld	ra,24(sp)
  800192:	8522                	mv	a0,s0
  800194:	6442                	ld	s0,16(sp)
  800196:	64a2                	ld	s1,8(sp)
  800198:	6105                	addi	sp,sp,32
  80019a:	8082                	ret
  80019c:	8526                	mv	a0,s1
  80019e:	e89ff0ef          	jal	ra,800026 <close>
  8001a2:	85a6                	mv	a1,s1
  8001a4:	8522                	mv	a0,s0
  8001a6:	e83ff0ef          	jal	ra,800028 <dup2>
  8001aa:	84aa                	mv	s1,a0
  8001ac:	8522                	mv	a0,s0
  8001ae:	e79ff0ef          	jal	ra,800026 <close>
  8001b2:	8426                	mv	s0,s1
  8001b4:	bff1                	j	800190 <initfd+0x1e>

00000000008001b6 <umain>:
  8001b6:	1101                	addi	sp,sp,-32
  8001b8:	e822                	sd	s0,16(sp)
  8001ba:	e426                	sd	s1,8(sp)
  8001bc:	842a                	mv	s0,a0
  8001be:	84ae                	mv	s1,a1
  8001c0:	4601                	li	a2,0
  8001c2:	00000597          	auipc	a1,0x0
  8001c6:	51e58593          	addi	a1,a1,1310 # 8006e0 <main+0x86>
  8001ca:	4501                	li	a0,0
  8001cc:	ec06                	sd	ra,24(sp)
  8001ce:	fa5ff0ef          	jal	ra,800172 <initfd>
  8001d2:	02054263          	bltz	a0,8001f6 <umain+0x40>
  8001d6:	4605                	li	a2,1
  8001d8:	00000597          	auipc	a1,0x0
  8001dc:	54858593          	addi	a1,a1,1352 # 800720 <main+0xc6>
  8001e0:	4505                	li	a0,1
  8001e2:	f91ff0ef          	jal	ra,800172 <initfd>
  8001e6:	02054563          	bltz	a0,800210 <umain+0x5a>
  8001ea:	85a6                	mv	a1,s1
  8001ec:	8522                	mv	a0,s0
  8001ee:	46c000ef          	jal	ra,80065a <main>
  8001f2:	f67ff0ef          	jal	ra,800158 <exit>
  8001f6:	86aa                	mv	a3,a0
  8001f8:	00000617          	auipc	a2,0x0
  8001fc:	4f060613          	addi	a2,a2,1264 # 8006e8 <main+0x8e>
  800200:	45e9                	li	a1,26
  800202:	00000517          	auipc	a0,0x0
  800206:	50650513          	addi	a0,a0,1286 # 800708 <main+0xae>
  80020a:	e27ff0ef          	jal	ra,800030 <__warn>
  80020e:	b7e1                	j	8001d6 <umain+0x20>
  800210:	86aa                	mv	a3,a0
  800212:	00000617          	auipc	a2,0x0
  800216:	51660613          	addi	a2,a2,1302 # 800728 <main+0xce>
  80021a:	45f5                	li	a1,29
  80021c:	00000517          	auipc	a0,0x0
  800220:	4ec50513          	addi	a0,a0,1260 # 800708 <main+0xae>
  800224:	e0dff0ef          	jal	ra,800030 <__warn>
  800228:	b7c9                	j	8001ea <umain+0x34>

000000000080022a <printnum>:
  80022a:	02071893          	slli	a7,a4,0x20
  80022e:	7139                	addi	sp,sp,-64
  800230:	0208d893          	srli	a7,a7,0x20
  800234:	e456                	sd	s5,8(sp)
  800236:	0316fab3          	remu	s5,a3,a7
  80023a:	f822                	sd	s0,48(sp)
  80023c:	f426                	sd	s1,40(sp)
  80023e:	f04a                	sd	s2,32(sp)
  800240:	ec4e                	sd	s3,24(sp)
  800242:	fc06                	sd	ra,56(sp)
  800244:	e852                	sd	s4,16(sp)
  800246:	84aa                	mv	s1,a0
  800248:	89ae                	mv	s3,a1
  80024a:	8932                	mv	s2,a2
  80024c:	fff7841b          	addiw	s0,a5,-1
  800250:	2a81                	sext.w	s5,s5
  800252:	0516f163          	bgeu	a3,a7,800294 <printnum+0x6a>
  800256:	8a42                	mv	s4,a6
  800258:	00805863          	blez	s0,800268 <printnum+0x3e>
  80025c:	347d                	addiw	s0,s0,-1
  80025e:	864e                	mv	a2,s3
  800260:	85ca                	mv	a1,s2
  800262:	8552                	mv	a0,s4
  800264:	9482                	jalr	s1
  800266:	f87d                	bnez	s0,80025c <printnum+0x32>
  800268:	1a82                	slli	s5,s5,0x20
  80026a:	00000797          	auipc	a5,0x0
  80026e:	4de78793          	addi	a5,a5,1246 # 800748 <main+0xee>
  800272:	020ada93          	srli	s5,s5,0x20
  800276:	9abe                	add	s5,s5,a5
  800278:	7442                	ld	s0,48(sp)
  80027a:	000ac503          	lbu	a0,0(s5)
  80027e:	70e2                	ld	ra,56(sp)
  800280:	6a42                	ld	s4,16(sp)
  800282:	6aa2                	ld	s5,8(sp)
  800284:	864e                	mv	a2,s3
  800286:	85ca                	mv	a1,s2
  800288:	69e2                	ld	s3,24(sp)
  80028a:	7902                	ld	s2,32(sp)
  80028c:	87a6                	mv	a5,s1
  80028e:	74a2                	ld	s1,40(sp)
  800290:	6121                	addi	sp,sp,64
  800292:	8782                	jr	a5
  800294:	0316d6b3          	divu	a3,a3,a7
  800298:	87a2                	mv	a5,s0
  80029a:	f91ff0ef          	jal	ra,80022a <printnum>
  80029e:	b7e9                	j	800268 <printnum+0x3e>

00000000008002a0 <vprintfmt>:
  8002a0:	7119                	addi	sp,sp,-128
  8002a2:	f4a6                	sd	s1,104(sp)
  8002a4:	f0ca                	sd	s2,96(sp)
  8002a6:	ecce                	sd	s3,88(sp)
  8002a8:	e8d2                	sd	s4,80(sp)
  8002aa:	e4d6                	sd	s5,72(sp)
  8002ac:	e0da                	sd	s6,64(sp)
  8002ae:	fc5e                	sd	s7,56(sp)
  8002b0:	ec6e                	sd	s11,24(sp)
  8002b2:	fc86                	sd	ra,120(sp)
  8002b4:	f8a2                	sd	s0,112(sp)
  8002b6:	f862                	sd	s8,48(sp)
  8002b8:	f466                	sd	s9,40(sp)
  8002ba:	f06a                	sd	s10,32(sp)
  8002bc:	89aa                	mv	s3,a0
  8002be:	892e                	mv	s2,a1
  8002c0:	84b2                	mv	s1,a2
  8002c2:	8db6                	mv	s11,a3
  8002c4:	8aba                	mv	s5,a4
  8002c6:	02500a13          	li	s4,37
  8002ca:	5bfd                	li	s7,-1
  8002cc:	00000b17          	auipc	s6,0x0
  8002d0:	4b0b0b13          	addi	s6,s6,1200 # 80077c <main+0x122>
  8002d4:	000dc503          	lbu	a0,0(s11)
  8002d8:	001d8413          	addi	s0,s11,1
  8002dc:	01450b63          	beq	a0,s4,8002f2 <vprintfmt+0x52>
  8002e0:	c129                	beqz	a0,800322 <vprintfmt+0x82>
  8002e2:	864a                	mv	a2,s2
  8002e4:	85a6                	mv	a1,s1
  8002e6:	0405                	addi	s0,s0,1
  8002e8:	9982                	jalr	s3
  8002ea:	fff44503          	lbu	a0,-1(s0)
  8002ee:	ff4519e3          	bne	a0,s4,8002e0 <vprintfmt+0x40>
  8002f2:	00044583          	lbu	a1,0(s0)
  8002f6:	02000813          	li	a6,32
  8002fa:	4d01                	li	s10,0
  8002fc:	4301                	li	t1,0
  8002fe:	5cfd                	li	s9,-1
  800300:	5c7d                	li	s8,-1
  800302:	05500513          	li	a0,85
  800306:	48a5                	li	a7,9
  800308:	fdd5861b          	addiw	a2,a1,-35
  80030c:	0ff67613          	zext.b	a2,a2
  800310:	00140d93          	addi	s11,s0,1
  800314:	04c56263          	bltu	a0,a2,800358 <vprintfmt+0xb8>
  800318:	060a                	slli	a2,a2,0x2
  80031a:	965a                	add	a2,a2,s6
  80031c:	4214                	lw	a3,0(a2)
  80031e:	96da                	add	a3,a3,s6
  800320:	8682                	jr	a3
  800322:	70e6                	ld	ra,120(sp)
  800324:	7446                	ld	s0,112(sp)
  800326:	74a6                	ld	s1,104(sp)
  800328:	7906                	ld	s2,96(sp)
  80032a:	69e6                	ld	s3,88(sp)
  80032c:	6a46                	ld	s4,80(sp)
  80032e:	6aa6                	ld	s5,72(sp)
  800330:	6b06                	ld	s6,64(sp)
  800332:	7be2                	ld	s7,56(sp)
  800334:	7c42                	ld	s8,48(sp)
  800336:	7ca2                	ld	s9,40(sp)
  800338:	7d02                	ld	s10,32(sp)
  80033a:	6de2                	ld	s11,24(sp)
  80033c:	6109                	addi	sp,sp,128
  80033e:	8082                	ret
  800340:	882e                	mv	a6,a1
  800342:	00144583          	lbu	a1,1(s0)
  800346:	846e                	mv	s0,s11
  800348:	00140d93          	addi	s11,s0,1
  80034c:	fdd5861b          	addiw	a2,a1,-35
  800350:	0ff67613          	zext.b	a2,a2
  800354:	fcc572e3          	bgeu	a0,a2,800318 <vprintfmt+0x78>
  800358:	864a                	mv	a2,s2
  80035a:	85a6                	mv	a1,s1
  80035c:	02500513          	li	a0,37
  800360:	9982                	jalr	s3
  800362:	fff44783          	lbu	a5,-1(s0)
  800366:	8da2                	mv	s11,s0
  800368:	f74786e3          	beq	a5,s4,8002d4 <vprintfmt+0x34>
  80036c:	ffedc783          	lbu	a5,-2(s11)
  800370:	1dfd                	addi	s11,s11,-1
  800372:	ff479de3          	bne	a5,s4,80036c <vprintfmt+0xcc>
  800376:	bfb9                	j	8002d4 <vprintfmt+0x34>
  800378:	fd058c9b          	addiw	s9,a1,-48
  80037c:	00144583          	lbu	a1,1(s0)
  800380:	846e                	mv	s0,s11
  800382:	fd05869b          	addiw	a3,a1,-48
  800386:	0005861b          	sext.w	a2,a1
  80038a:	02d8e463          	bltu	a7,a3,8003b2 <vprintfmt+0x112>
  80038e:	00144583          	lbu	a1,1(s0)
  800392:	002c969b          	slliw	a3,s9,0x2
  800396:	0196873b          	addw	a4,a3,s9
  80039a:	0017171b          	slliw	a4,a4,0x1
  80039e:	9f31                	addw	a4,a4,a2
  8003a0:	fd05869b          	addiw	a3,a1,-48
  8003a4:	0405                	addi	s0,s0,1
  8003a6:	fd070c9b          	addiw	s9,a4,-48
  8003aa:	0005861b          	sext.w	a2,a1
  8003ae:	fed8f0e3          	bgeu	a7,a3,80038e <vprintfmt+0xee>
  8003b2:	f40c5be3          	bgez	s8,800308 <vprintfmt+0x68>
  8003b6:	8c66                	mv	s8,s9
  8003b8:	5cfd                	li	s9,-1
  8003ba:	b7b9                	j	800308 <vprintfmt+0x68>
  8003bc:	fffc4693          	not	a3,s8
  8003c0:	96fd                	srai	a3,a3,0x3f
  8003c2:	00dc77b3          	and	a5,s8,a3
  8003c6:	00144583          	lbu	a1,1(s0)
  8003ca:	00078c1b          	sext.w	s8,a5
  8003ce:	846e                	mv	s0,s11
  8003d0:	bf25                	j	800308 <vprintfmt+0x68>
  8003d2:	000aac83          	lw	s9,0(s5)
  8003d6:	00144583          	lbu	a1,1(s0)
  8003da:	0aa1                	addi	s5,s5,8
  8003dc:	846e                	mv	s0,s11
  8003de:	bfd1                	j	8003b2 <vprintfmt+0x112>
  8003e0:	4705                	li	a4,1
  8003e2:	008a8613          	addi	a2,s5,8
  8003e6:	00674463          	blt	a4,t1,8003ee <vprintfmt+0x14e>
  8003ea:	1c030c63          	beqz	t1,8005c2 <vprintfmt+0x322>
  8003ee:	000ab683          	ld	a3,0(s5)
  8003f2:	4741                	li	a4,16
  8003f4:	8ab2                	mv	s5,a2
  8003f6:	2801                	sext.w	a6,a6
  8003f8:	87e2                	mv	a5,s8
  8003fa:	8626                	mv	a2,s1
  8003fc:	85ca                	mv	a1,s2
  8003fe:	854e                	mv	a0,s3
  800400:	e2bff0ef          	jal	ra,80022a <printnum>
  800404:	bdc1                	j	8002d4 <vprintfmt+0x34>
  800406:	000aa503          	lw	a0,0(s5)
  80040a:	864a                	mv	a2,s2
  80040c:	85a6                	mv	a1,s1
  80040e:	0aa1                	addi	s5,s5,8
  800410:	9982                	jalr	s3
  800412:	b5c9                	j	8002d4 <vprintfmt+0x34>
  800414:	4705                	li	a4,1
  800416:	008a8613          	addi	a2,s5,8
  80041a:	00674463          	blt	a4,t1,800422 <vprintfmt+0x182>
  80041e:	18030d63          	beqz	t1,8005b8 <vprintfmt+0x318>
  800422:	000ab683          	ld	a3,0(s5)
  800426:	4729                	li	a4,10
  800428:	8ab2                	mv	s5,a2
  80042a:	b7f1                	j	8003f6 <vprintfmt+0x156>
  80042c:	00144583          	lbu	a1,1(s0)
  800430:	4d05                	li	s10,1
  800432:	846e                	mv	s0,s11
  800434:	bdd1                	j	800308 <vprintfmt+0x68>
  800436:	864a                	mv	a2,s2
  800438:	85a6                	mv	a1,s1
  80043a:	02500513          	li	a0,37
  80043e:	9982                	jalr	s3
  800440:	bd51                	j	8002d4 <vprintfmt+0x34>
  800442:	00144583          	lbu	a1,1(s0)
  800446:	2305                	addiw	t1,t1,1
  800448:	846e                	mv	s0,s11
  80044a:	bd7d                	j	800308 <vprintfmt+0x68>
  80044c:	4705                	li	a4,1
  80044e:	008a8613          	addi	a2,s5,8
  800452:	00674463          	blt	a4,t1,80045a <vprintfmt+0x1ba>
  800456:	14030c63          	beqz	t1,8005ae <vprintfmt+0x30e>
  80045a:	000ab683          	ld	a3,0(s5)
  80045e:	4721                	li	a4,8
  800460:	8ab2                	mv	s5,a2
  800462:	bf51                	j	8003f6 <vprintfmt+0x156>
  800464:	03000513          	li	a0,48
  800468:	864a                	mv	a2,s2
  80046a:	85a6                	mv	a1,s1
  80046c:	e042                	sd	a6,0(sp)
  80046e:	9982                	jalr	s3
  800470:	864a                	mv	a2,s2
  800472:	85a6                	mv	a1,s1
  800474:	07800513          	li	a0,120
  800478:	9982                	jalr	s3
  80047a:	0aa1                	addi	s5,s5,8
  80047c:	6802                	ld	a6,0(sp)
  80047e:	4741                	li	a4,16
  800480:	ff8ab683          	ld	a3,-8(s5)
  800484:	bf8d                	j	8003f6 <vprintfmt+0x156>
  800486:	000ab403          	ld	s0,0(s5)
  80048a:	008a8793          	addi	a5,s5,8
  80048e:	e03e                	sd	a5,0(sp)
  800490:	14040c63          	beqz	s0,8005e8 <vprintfmt+0x348>
  800494:	11805063          	blez	s8,800594 <vprintfmt+0x2f4>
  800498:	02d00693          	li	a3,45
  80049c:	0cd81963          	bne	a6,a3,80056e <vprintfmt+0x2ce>
  8004a0:	00044683          	lbu	a3,0(s0)
  8004a4:	0006851b          	sext.w	a0,a3
  8004a8:	ce8d                	beqz	a3,8004e2 <vprintfmt+0x242>
  8004aa:	00140a93          	addi	s5,s0,1
  8004ae:	05e00413          	li	s0,94
  8004b2:	000cc563          	bltz	s9,8004bc <vprintfmt+0x21c>
  8004b6:	3cfd                	addiw	s9,s9,-1
  8004b8:	037c8363          	beq	s9,s7,8004de <vprintfmt+0x23e>
  8004bc:	864a                	mv	a2,s2
  8004be:	85a6                	mv	a1,s1
  8004c0:	100d0663          	beqz	s10,8005cc <vprintfmt+0x32c>
  8004c4:	3681                	addiw	a3,a3,-32
  8004c6:	10d47363          	bgeu	s0,a3,8005cc <vprintfmt+0x32c>
  8004ca:	03f00513          	li	a0,63
  8004ce:	9982                	jalr	s3
  8004d0:	000ac683          	lbu	a3,0(s5)
  8004d4:	3c7d                	addiw	s8,s8,-1
  8004d6:	0a85                	addi	s5,s5,1
  8004d8:	0006851b          	sext.w	a0,a3
  8004dc:	faf9                	bnez	a3,8004b2 <vprintfmt+0x212>
  8004de:	01805a63          	blez	s8,8004f2 <vprintfmt+0x252>
  8004e2:	3c7d                	addiw	s8,s8,-1
  8004e4:	864a                	mv	a2,s2
  8004e6:	85a6                	mv	a1,s1
  8004e8:	02000513          	li	a0,32
  8004ec:	9982                	jalr	s3
  8004ee:	fe0c1ae3          	bnez	s8,8004e2 <vprintfmt+0x242>
  8004f2:	6a82                	ld	s5,0(sp)
  8004f4:	b3c5                	j	8002d4 <vprintfmt+0x34>
  8004f6:	4705                	li	a4,1
  8004f8:	008a8d13          	addi	s10,s5,8
  8004fc:	00674463          	blt	a4,t1,800504 <vprintfmt+0x264>
  800500:	0a030463          	beqz	t1,8005a8 <vprintfmt+0x308>
  800504:	000ab403          	ld	s0,0(s5)
  800508:	0c044463          	bltz	s0,8005d0 <vprintfmt+0x330>
  80050c:	86a2                	mv	a3,s0
  80050e:	8aea                	mv	s5,s10
  800510:	4729                	li	a4,10
  800512:	b5d5                	j	8003f6 <vprintfmt+0x156>
  800514:	000aa783          	lw	a5,0(s5)
  800518:	46e1                	li	a3,24
  80051a:	0aa1                	addi	s5,s5,8
  80051c:	41f7d71b          	sraiw	a4,a5,0x1f
  800520:	8fb9                	xor	a5,a5,a4
  800522:	40e7873b          	subw	a4,a5,a4
  800526:	02e6c663          	blt	a3,a4,800552 <vprintfmt+0x2b2>
  80052a:	00371793          	slli	a5,a4,0x3
  80052e:	00000697          	auipc	a3,0x0
  800532:	58268693          	addi	a3,a3,1410 # 800ab0 <error_string>
  800536:	97b6                	add	a5,a5,a3
  800538:	639c                	ld	a5,0(a5)
  80053a:	cf81                	beqz	a5,800552 <vprintfmt+0x2b2>
  80053c:	873e                	mv	a4,a5
  80053e:	00000697          	auipc	a3,0x0
  800542:	23a68693          	addi	a3,a3,570 # 800778 <main+0x11e>
  800546:	8626                	mv	a2,s1
  800548:	85ca                	mv	a1,s2
  80054a:	854e                	mv	a0,s3
  80054c:	0d4000ef          	jal	ra,800620 <printfmt>
  800550:	b351                	j	8002d4 <vprintfmt+0x34>
  800552:	00000697          	auipc	a3,0x0
  800556:	21668693          	addi	a3,a3,534 # 800768 <main+0x10e>
  80055a:	8626                	mv	a2,s1
  80055c:	85ca                	mv	a1,s2
  80055e:	854e                	mv	a0,s3
  800560:	0c0000ef          	jal	ra,800620 <printfmt>
  800564:	bb85                	j	8002d4 <vprintfmt+0x34>
  800566:	00000417          	auipc	s0,0x0
  80056a:	1fa40413          	addi	s0,s0,506 # 800760 <main+0x106>
  80056e:	85e6                	mv	a1,s9
  800570:	8522                	mv	a0,s0
  800572:	e442                	sd	a6,8(sp)
  800574:	0ca000ef          	jal	ra,80063e <strnlen>
  800578:	40ac0c3b          	subw	s8,s8,a0
  80057c:	01805c63          	blez	s8,800594 <vprintfmt+0x2f4>
  800580:	6822                	ld	a6,8(sp)
  800582:	00080a9b          	sext.w	s5,a6
  800586:	3c7d                	addiw	s8,s8,-1
  800588:	864a                	mv	a2,s2
  80058a:	85a6                	mv	a1,s1
  80058c:	8556                	mv	a0,s5
  80058e:	9982                	jalr	s3
  800590:	fe0c1be3          	bnez	s8,800586 <vprintfmt+0x2e6>
  800594:	00044683          	lbu	a3,0(s0)
  800598:	00140a93          	addi	s5,s0,1
  80059c:	0006851b          	sext.w	a0,a3
  8005a0:	daa9                	beqz	a3,8004f2 <vprintfmt+0x252>
  8005a2:	05e00413          	li	s0,94
  8005a6:	b731                	j	8004b2 <vprintfmt+0x212>
  8005a8:	000aa403          	lw	s0,0(s5)
  8005ac:	bfb1                	j	800508 <vprintfmt+0x268>
  8005ae:	000ae683          	lwu	a3,0(s5)
  8005b2:	4721                	li	a4,8
  8005b4:	8ab2                	mv	s5,a2
  8005b6:	b581                	j	8003f6 <vprintfmt+0x156>
  8005b8:	000ae683          	lwu	a3,0(s5)
  8005bc:	4729                	li	a4,10
  8005be:	8ab2                	mv	s5,a2
  8005c0:	bd1d                	j	8003f6 <vprintfmt+0x156>
  8005c2:	000ae683          	lwu	a3,0(s5)
  8005c6:	4741                	li	a4,16
  8005c8:	8ab2                	mv	s5,a2
  8005ca:	b535                	j	8003f6 <vprintfmt+0x156>
  8005cc:	9982                	jalr	s3
  8005ce:	b709                	j	8004d0 <vprintfmt+0x230>
  8005d0:	864a                	mv	a2,s2
  8005d2:	85a6                	mv	a1,s1
  8005d4:	02d00513          	li	a0,45
  8005d8:	e042                	sd	a6,0(sp)
  8005da:	9982                	jalr	s3
  8005dc:	6802                	ld	a6,0(sp)
  8005de:	8aea                	mv	s5,s10
  8005e0:	408006b3          	neg	a3,s0
  8005e4:	4729                	li	a4,10
  8005e6:	bd01                	j	8003f6 <vprintfmt+0x156>
  8005e8:	03805163          	blez	s8,80060a <vprintfmt+0x36a>
  8005ec:	02d00693          	li	a3,45
  8005f0:	f6d81be3          	bne	a6,a3,800566 <vprintfmt+0x2c6>
  8005f4:	00000417          	auipc	s0,0x0
  8005f8:	16c40413          	addi	s0,s0,364 # 800760 <main+0x106>
  8005fc:	02800693          	li	a3,40
  800600:	02800513          	li	a0,40
  800604:	00140a93          	addi	s5,s0,1
  800608:	b55d                	j	8004ae <vprintfmt+0x20e>
  80060a:	00000a97          	auipc	s5,0x0
  80060e:	157a8a93          	addi	s5,s5,343 # 800761 <main+0x107>
  800612:	02800513          	li	a0,40
  800616:	02800693          	li	a3,40
  80061a:	05e00413          	li	s0,94
  80061e:	bd51                	j	8004b2 <vprintfmt+0x212>

0000000000800620 <printfmt>:
  800620:	7139                	addi	sp,sp,-64
  800622:	02010313          	addi	t1,sp,32
  800626:	f03a                	sd	a4,32(sp)
  800628:	871a                	mv	a4,t1
  80062a:	ec06                	sd	ra,24(sp)
  80062c:	f43e                	sd	a5,40(sp)
  80062e:	f842                	sd	a6,48(sp)
  800630:	fc46                	sd	a7,56(sp)
  800632:	e41a                	sd	t1,8(sp)
  800634:	c6dff0ef          	jal	ra,8002a0 <vprintfmt>
  800638:	60e2                	ld	ra,24(sp)
  80063a:	6121                	addi	sp,sp,64
  80063c:	8082                	ret

000000000080063e <strnlen>:
  80063e:	4781                	li	a5,0
  800640:	e589                	bnez	a1,80064a <strnlen+0xc>
  800642:	a811                	j	800656 <strnlen+0x18>
  800644:	0785                	addi	a5,a5,1
  800646:	00f58863          	beq	a1,a5,800656 <strnlen+0x18>
  80064a:	00f50733          	add	a4,a0,a5
  80064e:	00074703          	lbu	a4,0(a4)
  800652:	fb6d                	bnez	a4,800644 <strnlen+0x6>
  800654:	85be                	mv	a1,a5
  800656:	852e                	mv	a0,a1
  800658:	8082                	ret

000000000080065a <main>:
  80065a:	1141                	addi	sp,sp,-16
  80065c:	e406                	sd	ra,8(sp)
  80065e:	b11ff0ef          	jal	ra,80016e <getpid>
  800662:	85aa                	mv	a1,a0
  800664:	00000517          	auipc	a0,0x0
  800668:	51450513          	addi	a0,a0,1300 # 800b78 <error_string+0xc8>
  80066c:	a49ff0ef          	jal	ra,8000b4 <cprintf>
  800670:	b01ff0ef          	jal	ra,800170 <print_pgdir>
  800674:	00000517          	auipc	a0,0x0
  800678:	51c50513          	addi	a0,a0,1308 # 800b90 <error_string+0xe0>
  80067c:	a39ff0ef          	jal	ra,8000b4 <cprintf>
  800680:	60a2                	ld	ra,8(sp)
  800682:	4501                	li	a0,0
  800684:	0141                	addi	sp,sp,16
  800686:	8082                	ret
