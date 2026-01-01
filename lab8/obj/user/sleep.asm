
obj/__user_sleep.out:     file format elf64-littleriscv


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
  80002a:	1e4000ef          	jal	ra,80020e <umain>
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
  800044:	71850513          	addi	a0,a0,1816 # 800758 <main+0x70>
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
  800064:	77050513          	addi	a0,a0,1904 # 8007d0 <main+0xe8>
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
  800086:	6f650513          	addi	a0,a0,1782 # 800778 <main+0x90>
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
  8000a6:	72e50513          	addi	a0,a0,1838 # 8007d0 <main+0xe8>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f59>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	20e000ef          	jal	ra,8002f8 <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5f59>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1d2000ef          	jal	ra,8002f8 <vprintfmt>
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

0000000000800182 <sys_sleep>:
  800182:	85aa                	mv	a1,a0
  800184:	452d                	li	a0,11
  800186:	b775                	j	800132 <syscall>

0000000000800188 <sys_gettime>:
  800188:	4545                	li	a0,17
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
  8001b4:	5e850513          	addi	a0,a0,1512 # 800798 <main+0xb0>
  8001b8:	f3fff0ef          	jal	ra,8000f6 <cprintf>
  8001bc:	a001                	j	8001bc <exit+0x14>

00000000008001be <fork>:
  8001be:	bf4d                	j	800170 <sys_fork>

00000000008001c0 <waitpid>:
  8001c0:	bf55                	j	800174 <sys_wait>

00000000008001c2 <gettime_msec>:
  8001c2:	b7d9                	j	800188 <sys_gettime>

00000000008001c4 <sleep>:
  8001c4:	1502                	slli	a0,a0,0x20
  8001c6:	9101                	srli	a0,a0,0x20
  8001c8:	bf6d                	j	800182 <sys_sleep>

00000000008001ca <initfd>:
  8001ca:	1101                	addi	sp,sp,-32
  8001cc:	87ae                	mv	a5,a1
  8001ce:	e426                	sd	s1,8(sp)
  8001d0:	85b2                	mv	a1,a2
  8001d2:	84aa                	mv	s1,a0
  8001d4:	853e                	mv	a0,a5
  8001d6:	e822                	sd	s0,16(sp)
  8001d8:	ec06                	sd	ra,24(sp)
  8001da:	e47ff0ef          	jal	ra,800020 <open>
  8001de:	842a                	mv	s0,a0
  8001e0:	00054463          	bltz	a0,8001e8 <initfd+0x1e>
  8001e4:	00951863          	bne	a0,s1,8001f4 <initfd+0x2a>
  8001e8:	60e2                	ld	ra,24(sp)
  8001ea:	8522                	mv	a0,s0
  8001ec:	6442                	ld	s0,16(sp)
  8001ee:	64a2                	ld	s1,8(sp)
  8001f0:	6105                	addi	sp,sp,32
  8001f2:	8082                	ret
  8001f4:	8526                	mv	a0,s1
  8001f6:	e31ff0ef          	jal	ra,800026 <close>
  8001fa:	85a6                	mv	a1,s1
  8001fc:	8522                	mv	a0,s0
  8001fe:	e2bff0ef          	jal	ra,800028 <dup2>
  800202:	84aa                	mv	s1,a0
  800204:	8522                	mv	a0,s0
  800206:	e21ff0ef          	jal	ra,800026 <close>
  80020a:	8426                	mv	s0,s1
  80020c:	bff1                	j	8001e8 <initfd+0x1e>

000000000080020e <umain>:
  80020e:	1101                	addi	sp,sp,-32
  800210:	e822                	sd	s0,16(sp)
  800212:	e426                	sd	s1,8(sp)
  800214:	842a                	mv	s0,a0
  800216:	84ae                	mv	s1,a1
  800218:	4601                	li	a2,0
  80021a:	00000597          	auipc	a1,0x0
  80021e:	59658593          	addi	a1,a1,1430 # 8007b0 <main+0xc8>
  800222:	4501                	li	a0,0
  800224:	ec06                	sd	ra,24(sp)
  800226:	fa5ff0ef          	jal	ra,8001ca <initfd>
  80022a:	02054263          	bltz	a0,80024e <umain+0x40>
  80022e:	4605                	li	a2,1
  800230:	00000597          	auipc	a1,0x0
  800234:	5c058593          	addi	a1,a1,1472 # 8007f0 <main+0x108>
  800238:	4505                	li	a0,1
  80023a:	f91ff0ef          	jal	ra,8001ca <initfd>
  80023e:	02054563          	bltz	a0,800268 <umain+0x5a>
  800242:	85a6                	mv	a1,s1
  800244:	8522                	mv	a0,s0
  800246:	4a2000ef          	jal	ra,8006e8 <main>
  80024a:	f5fff0ef          	jal	ra,8001a8 <exit>
  80024e:	86aa                	mv	a3,a0
  800250:	00000617          	auipc	a2,0x0
  800254:	56860613          	addi	a2,a2,1384 # 8007b8 <main+0xd0>
  800258:	45e9                	li	a1,26
  80025a:	00000517          	auipc	a0,0x0
  80025e:	57e50513          	addi	a0,a0,1406 # 8007d8 <main+0xf0>
  800262:	e11ff0ef          	jal	ra,800072 <__warn>
  800266:	b7e1                	j	80022e <umain+0x20>
  800268:	86aa                	mv	a3,a0
  80026a:	00000617          	auipc	a2,0x0
  80026e:	58e60613          	addi	a2,a2,1422 # 8007f8 <main+0x110>
  800272:	45f5                	li	a1,29
  800274:	00000517          	auipc	a0,0x0
  800278:	56450513          	addi	a0,a0,1380 # 8007d8 <main+0xf0>
  80027c:	df7ff0ef          	jal	ra,800072 <__warn>
  800280:	b7c9                	j	800242 <umain+0x34>

0000000000800282 <printnum>:
  800282:	02071893          	slli	a7,a4,0x20
  800286:	7139                	addi	sp,sp,-64
  800288:	0208d893          	srli	a7,a7,0x20
  80028c:	e456                	sd	s5,8(sp)
  80028e:	0316fab3          	remu	s5,a3,a7
  800292:	f822                	sd	s0,48(sp)
  800294:	f426                	sd	s1,40(sp)
  800296:	f04a                	sd	s2,32(sp)
  800298:	ec4e                	sd	s3,24(sp)
  80029a:	fc06                	sd	ra,56(sp)
  80029c:	e852                	sd	s4,16(sp)
  80029e:	84aa                	mv	s1,a0
  8002a0:	89ae                	mv	s3,a1
  8002a2:	8932                	mv	s2,a2
  8002a4:	fff7841b          	addiw	s0,a5,-1
  8002a8:	2a81                	sext.w	s5,s5
  8002aa:	0516f163          	bgeu	a3,a7,8002ec <printnum+0x6a>
  8002ae:	8a42                	mv	s4,a6
  8002b0:	00805863          	blez	s0,8002c0 <printnum+0x3e>
  8002b4:	347d                	addiw	s0,s0,-1
  8002b6:	864e                	mv	a2,s3
  8002b8:	85ca                	mv	a1,s2
  8002ba:	8552                	mv	a0,s4
  8002bc:	9482                	jalr	s1
  8002be:	f87d                	bnez	s0,8002b4 <printnum+0x32>
  8002c0:	1a82                	slli	s5,s5,0x20
  8002c2:	00000797          	auipc	a5,0x0
  8002c6:	55678793          	addi	a5,a5,1366 # 800818 <main+0x130>
  8002ca:	020ada93          	srli	s5,s5,0x20
  8002ce:	9abe                	add	s5,s5,a5
  8002d0:	7442                	ld	s0,48(sp)
  8002d2:	000ac503          	lbu	a0,0(s5)
  8002d6:	70e2                	ld	ra,56(sp)
  8002d8:	6a42                	ld	s4,16(sp)
  8002da:	6aa2                	ld	s5,8(sp)
  8002dc:	864e                	mv	a2,s3
  8002de:	85ca                	mv	a1,s2
  8002e0:	69e2                	ld	s3,24(sp)
  8002e2:	7902                	ld	s2,32(sp)
  8002e4:	87a6                	mv	a5,s1
  8002e6:	74a2                	ld	s1,40(sp)
  8002e8:	6121                	addi	sp,sp,64
  8002ea:	8782                	jr	a5
  8002ec:	0316d6b3          	divu	a3,a3,a7
  8002f0:	87a2                	mv	a5,s0
  8002f2:	f91ff0ef          	jal	ra,800282 <printnum>
  8002f6:	b7e9                	j	8002c0 <printnum+0x3e>

00000000008002f8 <vprintfmt>:
  8002f8:	7119                	addi	sp,sp,-128
  8002fa:	f4a6                	sd	s1,104(sp)
  8002fc:	f0ca                	sd	s2,96(sp)
  8002fe:	ecce                	sd	s3,88(sp)
  800300:	e8d2                	sd	s4,80(sp)
  800302:	e4d6                	sd	s5,72(sp)
  800304:	e0da                	sd	s6,64(sp)
  800306:	fc5e                	sd	s7,56(sp)
  800308:	ec6e                	sd	s11,24(sp)
  80030a:	fc86                	sd	ra,120(sp)
  80030c:	f8a2                	sd	s0,112(sp)
  80030e:	f862                	sd	s8,48(sp)
  800310:	f466                	sd	s9,40(sp)
  800312:	f06a                	sd	s10,32(sp)
  800314:	89aa                	mv	s3,a0
  800316:	892e                	mv	s2,a1
  800318:	84b2                	mv	s1,a2
  80031a:	8db6                	mv	s11,a3
  80031c:	8aba                	mv	s5,a4
  80031e:	02500a13          	li	s4,37
  800322:	5bfd                	li	s7,-1
  800324:	00000b17          	auipc	s6,0x0
  800328:	528b0b13          	addi	s6,s6,1320 # 80084c <main+0x164>
  80032c:	000dc503          	lbu	a0,0(s11)
  800330:	001d8413          	addi	s0,s11,1
  800334:	01450b63          	beq	a0,s4,80034a <vprintfmt+0x52>
  800338:	c129                	beqz	a0,80037a <vprintfmt+0x82>
  80033a:	864a                	mv	a2,s2
  80033c:	85a6                	mv	a1,s1
  80033e:	0405                	addi	s0,s0,1
  800340:	9982                	jalr	s3
  800342:	fff44503          	lbu	a0,-1(s0)
  800346:	ff4519e3          	bne	a0,s4,800338 <vprintfmt+0x40>
  80034a:	00044583          	lbu	a1,0(s0)
  80034e:	02000813          	li	a6,32
  800352:	4d01                	li	s10,0
  800354:	4301                	li	t1,0
  800356:	5cfd                	li	s9,-1
  800358:	5c7d                	li	s8,-1
  80035a:	05500513          	li	a0,85
  80035e:	48a5                	li	a7,9
  800360:	fdd5861b          	addiw	a2,a1,-35
  800364:	0ff67613          	zext.b	a2,a2
  800368:	00140d93          	addi	s11,s0,1
  80036c:	04c56263          	bltu	a0,a2,8003b0 <vprintfmt+0xb8>
  800370:	060a                	slli	a2,a2,0x2
  800372:	965a                	add	a2,a2,s6
  800374:	4214                	lw	a3,0(a2)
  800376:	96da                	add	a3,a3,s6
  800378:	8682                	jr	a3
  80037a:	70e6                	ld	ra,120(sp)
  80037c:	7446                	ld	s0,112(sp)
  80037e:	74a6                	ld	s1,104(sp)
  800380:	7906                	ld	s2,96(sp)
  800382:	69e6                	ld	s3,88(sp)
  800384:	6a46                	ld	s4,80(sp)
  800386:	6aa6                	ld	s5,72(sp)
  800388:	6b06                	ld	s6,64(sp)
  80038a:	7be2                	ld	s7,56(sp)
  80038c:	7c42                	ld	s8,48(sp)
  80038e:	7ca2                	ld	s9,40(sp)
  800390:	7d02                	ld	s10,32(sp)
  800392:	6de2                	ld	s11,24(sp)
  800394:	6109                	addi	sp,sp,128
  800396:	8082                	ret
  800398:	882e                	mv	a6,a1
  80039a:	00144583          	lbu	a1,1(s0)
  80039e:	846e                	mv	s0,s11
  8003a0:	00140d93          	addi	s11,s0,1
  8003a4:	fdd5861b          	addiw	a2,a1,-35
  8003a8:	0ff67613          	zext.b	a2,a2
  8003ac:	fcc572e3          	bgeu	a0,a2,800370 <vprintfmt+0x78>
  8003b0:	864a                	mv	a2,s2
  8003b2:	85a6                	mv	a1,s1
  8003b4:	02500513          	li	a0,37
  8003b8:	9982                	jalr	s3
  8003ba:	fff44783          	lbu	a5,-1(s0)
  8003be:	8da2                	mv	s11,s0
  8003c0:	f74786e3          	beq	a5,s4,80032c <vprintfmt+0x34>
  8003c4:	ffedc783          	lbu	a5,-2(s11)
  8003c8:	1dfd                	addi	s11,s11,-1
  8003ca:	ff479de3          	bne	a5,s4,8003c4 <vprintfmt+0xcc>
  8003ce:	bfb9                	j	80032c <vprintfmt+0x34>
  8003d0:	fd058c9b          	addiw	s9,a1,-48
  8003d4:	00144583          	lbu	a1,1(s0)
  8003d8:	846e                	mv	s0,s11
  8003da:	fd05869b          	addiw	a3,a1,-48
  8003de:	0005861b          	sext.w	a2,a1
  8003e2:	02d8e463          	bltu	a7,a3,80040a <vprintfmt+0x112>
  8003e6:	00144583          	lbu	a1,1(s0)
  8003ea:	002c969b          	slliw	a3,s9,0x2
  8003ee:	0196873b          	addw	a4,a3,s9
  8003f2:	0017171b          	slliw	a4,a4,0x1
  8003f6:	9f31                	addw	a4,a4,a2
  8003f8:	fd05869b          	addiw	a3,a1,-48
  8003fc:	0405                	addi	s0,s0,1
  8003fe:	fd070c9b          	addiw	s9,a4,-48
  800402:	0005861b          	sext.w	a2,a1
  800406:	fed8f0e3          	bgeu	a7,a3,8003e6 <vprintfmt+0xee>
  80040a:	f40c5be3          	bgez	s8,800360 <vprintfmt+0x68>
  80040e:	8c66                	mv	s8,s9
  800410:	5cfd                	li	s9,-1
  800412:	b7b9                	j	800360 <vprintfmt+0x68>
  800414:	fffc4693          	not	a3,s8
  800418:	96fd                	srai	a3,a3,0x3f
  80041a:	00dc77b3          	and	a5,s8,a3
  80041e:	00144583          	lbu	a1,1(s0)
  800422:	00078c1b          	sext.w	s8,a5
  800426:	846e                	mv	s0,s11
  800428:	bf25                	j	800360 <vprintfmt+0x68>
  80042a:	000aac83          	lw	s9,0(s5)
  80042e:	00144583          	lbu	a1,1(s0)
  800432:	0aa1                	addi	s5,s5,8
  800434:	846e                	mv	s0,s11
  800436:	bfd1                	j	80040a <vprintfmt+0x112>
  800438:	4705                	li	a4,1
  80043a:	008a8613          	addi	a2,s5,8
  80043e:	00674463          	blt	a4,t1,800446 <vprintfmt+0x14e>
  800442:	1c030c63          	beqz	t1,80061a <vprintfmt+0x322>
  800446:	000ab683          	ld	a3,0(s5)
  80044a:	4741                	li	a4,16
  80044c:	8ab2                	mv	s5,a2
  80044e:	2801                	sext.w	a6,a6
  800450:	87e2                	mv	a5,s8
  800452:	8626                	mv	a2,s1
  800454:	85ca                	mv	a1,s2
  800456:	854e                	mv	a0,s3
  800458:	e2bff0ef          	jal	ra,800282 <printnum>
  80045c:	bdc1                	j	80032c <vprintfmt+0x34>
  80045e:	000aa503          	lw	a0,0(s5)
  800462:	864a                	mv	a2,s2
  800464:	85a6                	mv	a1,s1
  800466:	0aa1                	addi	s5,s5,8
  800468:	9982                	jalr	s3
  80046a:	b5c9                	j	80032c <vprintfmt+0x34>
  80046c:	4705                	li	a4,1
  80046e:	008a8613          	addi	a2,s5,8
  800472:	00674463          	blt	a4,t1,80047a <vprintfmt+0x182>
  800476:	18030d63          	beqz	t1,800610 <vprintfmt+0x318>
  80047a:	000ab683          	ld	a3,0(s5)
  80047e:	4729                	li	a4,10
  800480:	8ab2                	mv	s5,a2
  800482:	b7f1                	j	80044e <vprintfmt+0x156>
  800484:	00144583          	lbu	a1,1(s0)
  800488:	4d05                	li	s10,1
  80048a:	846e                	mv	s0,s11
  80048c:	bdd1                	j	800360 <vprintfmt+0x68>
  80048e:	864a                	mv	a2,s2
  800490:	85a6                	mv	a1,s1
  800492:	02500513          	li	a0,37
  800496:	9982                	jalr	s3
  800498:	bd51                	j	80032c <vprintfmt+0x34>
  80049a:	00144583          	lbu	a1,1(s0)
  80049e:	2305                	addiw	t1,t1,1
  8004a0:	846e                	mv	s0,s11
  8004a2:	bd7d                	j	800360 <vprintfmt+0x68>
  8004a4:	4705                	li	a4,1
  8004a6:	008a8613          	addi	a2,s5,8
  8004aa:	00674463          	blt	a4,t1,8004b2 <vprintfmt+0x1ba>
  8004ae:	14030c63          	beqz	t1,800606 <vprintfmt+0x30e>
  8004b2:	000ab683          	ld	a3,0(s5)
  8004b6:	4721                	li	a4,8
  8004b8:	8ab2                	mv	s5,a2
  8004ba:	bf51                	j	80044e <vprintfmt+0x156>
  8004bc:	03000513          	li	a0,48
  8004c0:	864a                	mv	a2,s2
  8004c2:	85a6                	mv	a1,s1
  8004c4:	e042                	sd	a6,0(sp)
  8004c6:	9982                	jalr	s3
  8004c8:	864a                	mv	a2,s2
  8004ca:	85a6                	mv	a1,s1
  8004cc:	07800513          	li	a0,120
  8004d0:	9982                	jalr	s3
  8004d2:	0aa1                	addi	s5,s5,8
  8004d4:	6802                	ld	a6,0(sp)
  8004d6:	4741                	li	a4,16
  8004d8:	ff8ab683          	ld	a3,-8(s5)
  8004dc:	bf8d                	j	80044e <vprintfmt+0x156>
  8004de:	000ab403          	ld	s0,0(s5)
  8004e2:	008a8793          	addi	a5,s5,8
  8004e6:	e03e                	sd	a5,0(sp)
  8004e8:	14040c63          	beqz	s0,800640 <vprintfmt+0x348>
  8004ec:	11805063          	blez	s8,8005ec <vprintfmt+0x2f4>
  8004f0:	02d00693          	li	a3,45
  8004f4:	0cd81963          	bne	a6,a3,8005c6 <vprintfmt+0x2ce>
  8004f8:	00044683          	lbu	a3,0(s0)
  8004fc:	0006851b          	sext.w	a0,a3
  800500:	ce8d                	beqz	a3,80053a <vprintfmt+0x242>
  800502:	00140a93          	addi	s5,s0,1
  800506:	05e00413          	li	s0,94
  80050a:	000cc563          	bltz	s9,800514 <vprintfmt+0x21c>
  80050e:	3cfd                	addiw	s9,s9,-1
  800510:	037c8363          	beq	s9,s7,800536 <vprintfmt+0x23e>
  800514:	864a                	mv	a2,s2
  800516:	85a6                	mv	a1,s1
  800518:	100d0663          	beqz	s10,800624 <vprintfmt+0x32c>
  80051c:	3681                	addiw	a3,a3,-32
  80051e:	10d47363          	bgeu	s0,a3,800624 <vprintfmt+0x32c>
  800522:	03f00513          	li	a0,63
  800526:	9982                	jalr	s3
  800528:	000ac683          	lbu	a3,0(s5)
  80052c:	3c7d                	addiw	s8,s8,-1
  80052e:	0a85                	addi	s5,s5,1
  800530:	0006851b          	sext.w	a0,a3
  800534:	faf9                	bnez	a3,80050a <vprintfmt+0x212>
  800536:	01805a63          	blez	s8,80054a <vprintfmt+0x252>
  80053a:	3c7d                	addiw	s8,s8,-1
  80053c:	864a                	mv	a2,s2
  80053e:	85a6                	mv	a1,s1
  800540:	02000513          	li	a0,32
  800544:	9982                	jalr	s3
  800546:	fe0c1ae3          	bnez	s8,80053a <vprintfmt+0x242>
  80054a:	6a82                	ld	s5,0(sp)
  80054c:	b3c5                	j	80032c <vprintfmt+0x34>
  80054e:	4705                	li	a4,1
  800550:	008a8d13          	addi	s10,s5,8
  800554:	00674463          	blt	a4,t1,80055c <vprintfmt+0x264>
  800558:	0a030463          	beqz	t1,800600 <vprintfmt+0x308>
  80055c:	000ab403          	ld	s0,0(s5)
  800560:	0c044463          	bltz	s0,800628 <vprintfmt+0x330>
  800564:	86a2                	mv	a3,s0
  800566:	8aea                	mv	s5,s10
  800568:	4729                	li	a4,10
  80056a:	b5d5                	j	80044e <vprintfmt+0x156>
  80056c:	000aa783          	lw	a5,0(s5)
  800570:	46e1                	li	a3,24
  800572:	0aa1                	addi	s5,s5,8
  800574:	41f7d71b          	sraiw	a4,a5,0x1f
  800578:	8fb9                	xor	a5,a5,a4
  80057a:	40e7873b          	subw	a4,a5,a4
  80057e:	02e6c663          	blt	a3,a4,8005aa <vprintfmt+0x2b2>
  800582:	00371793          	slli	a5,a4,0x3
  800586:	00000697          	auipc	a3,0x0
  80058a:	5fa68693          	addi	a3,a3,1530 # 800b80 <error_string>
  80058e:	97b6                	add	a5,a5,a3
  800590:	639c                	ld	a5,0(a5)
  800592:	cf81                	beqz	a5,8005aa <vprintfmt+0x2b2>
  800594:	873e                	mv	a4,a5
  800596:	00000697          	auipc	a3,0x0
  80059a:	2b268693          	addi	a3,a3,690 # 800848 <main+0x160>
  80059e:	8626                	mv	a2,s1
  8005a0:	85ca                	mv	a1,s2
  8005a2:	854e                	mv	a0,s3
  8005a4:	0d4000ef          	jal	ra,800678 <printfmt>
  8005a8:	b351                	j	80032c <vprintfmt+0x34>
  8005aa:	00000697          	auipc	a3,0x0
  8005ae:	28e68693          	addi	a3,a3,654 # 800838 <main+0x150>
  8005b2:	8626                	mv	a2,s1
  8005b4:	85ca                	mv	a1,s2
  8005b6:	854e                	mv	a0,s3
  8005b8:	0c0000ef          	jal	ra,800678 <printfmt>
  8005bc:	bb85                	j	80032c <vprintfmt+0x34>
  8005be:	00000417          	auipc	s0,0x0
  8005c2:	27240413          	addi	s0,s0,626 # 800830 <main+0x148>
  8005c6:	85e6                	mv	a1,s9
  8005c8:	8522                	mv	a0,s0
  8005ca:	e442                	sd	a6,8(sp)
  8005cc:	0ca000ef          	jal	ra,800696 <strnlen>
  8005d0:	40ac0c3b          	subw	s8,s8,a0
  8005d4:	01805c63          	blez	s8,8005ec <vprintfmt+0x2f4>
  8005d8:	6822                	ld	a6,8(sp)
  8005da:	00080a9b          	sext.w	s5,a6
  8005de:	3c7d                	addiw	s8,s8,-1
  8005e0:	864a                	mv	a2,s2
  8005e2:	85a6                	mv	a1,s1
  8005e4:	8556                	mv	a0,s5
  8005e6:	9982                	jalr	s3
  8005e8:	fe0c1be3          	bnez	s8,8005de <vprintfmt+0x2e6>
  8005ec:	00044683          	lbu	a3,0(s0)
  8005f0:	00140a93          	addi	s5,s0,1
  8005f4:	0006851b          	sext.w	a0,a3
  8005f8:	daa9                	beqz	a3,80054a <vprintfmt+0x252>
  8005fa:	05e00413          	li	s0,94
  8005fe:	b731                	j	80050a <vprintfmt+0x212>
  800600:	000aa403          	lw	s0,0(s5)
  800604:	bfb1                	j	800560 <vprintfmt+0x268>
  800606:	000ae683          	lwu	a3,0(s5)
  80060a:	4721                	li	a4,8
  80060c:	8ab2                	mv	s5,a2
  80060e:	b581                	j	80044e <vprintfmt+0x156>
  800610:	000ae683          	lwu	a3,0(s5)
  800614:	4729                	li	a4,10
  800616:	8ab2                	mv	s5,a2
  800618:	bd1d                	j	80044e <vprintfmt+0x156>
  80061a:	000ae683          	lwu	a3,0(s5)
  80061e:	4741                	li	a4,16
  800620:	8ab2                	mv	s5,a2
  800622:	b535                	j	80044e <vprintfmt+0x156>
  800624:	9982                	jalr	s3
  800626:	b709                	j	800528 <vprintfmt+0x230>
  800628:	864a                	mv	a2,s2
  80062a:	85a6                	mv	a1,s1
  80062c:	02d00513          	li	a0,45
  800630:	e042                	sd	a6,0(sp)
  800632:	9982                	jalr	s3
  800634:	6802                	ld	a6,0(sp)
  800636:	8aea                	mv	s5,s10
  800638:	408006b3          	neg	a3,s0
  80063c:	4729                	li	a4,10
  80063e:	bd01                	j	80044e <vprintfmt+0x156>
  800640:	03805163          	blez	s8,800662 <vprintfmt+0x36a>
  800644:	02d00693          	li	a3,45
  800648:	f6d81be3          	bne	a6,a3,8005be <vprintfmt+0x2c6>
  80064c:	00000417          	auipc	s0,0x0
  800650:	1e440413          	addi	s0,s0,484 # 800830 <main+0x148>
  800654:	02800693          	li	a3,40
  800658:	02800513          	li	a0,40
  80065c:	00140a93          	addi	s5,s0,1
  800660:	b55d                	j	800506 <vprintfmt+0x20e>
  800662:	00000a97          	auipc	s5,0x0
  800666:	1cfa8a93          	addi	s5,s5,463 # 800831 <main+0x149>
  80066a:	02800513          	li	a0,40
  80066e:	02800693          	li	a3,40
  800672:	05e00413          	li	s0,94
  800676:	bd51                	j	80050a <vprintfmt+0x212>

0000000000800678 <printfmt>:
  800678:	7139                	addi	sp,sp,-64
  80067a:	02010313          	addi	t1,sp,32
  80067e:	f03a                	sd	a4,32(sp)
  800680:	871a                	mv	a4,t1
  800682:	ec06                	sd	ra,24(sp)
  800684:	f43e                	sd	a5,40(sp)
  800686:	f842                	sd	a6,48(sp)
  800688:	fc46                	sd	a7,56(sp)
  80068a:	e41a                	sd	t1,8(sp)
  80068c:	c6dff0ef          	jal	ra,8002f8 <vprintfmt>
  800690:	60e2                	ld	ra,24(sp)
  800692:	6121                	addi	sp,sp,64
  800694:	8082                	ret

0000000000800696 <strnlen>:
  800696:	4781                	li	a5,0
  800698:	e589                	bnez	a1,8006a2 <strnlen+0xc>
  80069a:	a811                	j	8006ae <strnlen+0x18>
  80069c:	0785                	addi	a5,a5,1
  80069e:	00f58863          	beq	a1,a5,8006ae <strnlen+0x18>
  8006a2:	00f50733          	add	a4,a0,a5
  8006a6:	00074703          	lbu	a4,0(a4)
  8006aa:	fb6d                	bnez	a4,80069c <strnlen+0x6>
  8006ac:	85be                	mv	a1,a5
  8006ae:	852e                	mv	a0,a1
  8006b0:	8082                	ret

00000000008006b2 <sleepy>:
  8006b2:	1101                	addi	sp,sp,-32
  8006b4:	e822                	sd	s0,16(sp)
  8006b6:	e426                	sd	s1,8(sp)
  8006b8:	e04a                	sd	s2,0(sp)
  8006ba:	ec06                	sd	ra,24(sp)
  8006bc:	4401                	li	s0,0
  8006be:	00000917          	auipc	s2,0x0
  8006c2:	58a90913          	addi	s2,s2,1418 # 800c48 <error_string+0xc8>
  8006c6:	44a9                	li	s1,10
  8006c8:	06400513          	li	a0,100
  8006cc:	af9ff0ef          	jal	ra,8001c4 <sleep>
  8006d0:	2405                	addiw	s0,s0,1
  8006d2:	06400613          	li	a2,100
  8006d6:	85a2                	mv	a1,s0
  8006d8:	854a                	mv	a0,s2
  8006da:	a1dff0ef          	jal	ra,8000f6 <cprintf>
  8006de:	fe9415e3          	bne	s0,s1,8006c8 <sleepy+0x16>
  8006e2:	4501                	li	a0,0
  8006e4:	ac5ff0ef          	jal	ra,8001a8 <exit>

00000000008006e8 <main>:
  8006e8:	1101                	addi	sp,sp,-32
  8006ea:	e822                	sd	s0,16(sp)
  8006ec:	ec06                	sd	ra,24(sp)
  8006ee:	ad5ff0ef          	jal	ra,8001c2 <gettime_msec>
  8006f2:	0005041b          	sext.w	s0,a0
  8006f6:	ac9ff0ef          	jal	ra,8001be <fork>
  8006fa:	cd21                	beqz	a0,800752 <main+0x6a>
  8006fc:	006c                	addi	a1,sp,12
  8006fe:	ac3ff0ef          	jal	ra,8001c0 <waitpid>
  800702:	47b2                	lw	a5,12(sp)
  800704:	8fc9                	or	a5,a5,a0
  800706:	2781                	sext.w	a5,a5
  800708:	e795                	bnez	a5,800734 <main+0x4c>
  80070a:	ab9ff0ef          	jal	ra,8001c2 <gettime_msec>
  80070e:	408505bb          	subw	a1,a0,s0
  800712:	00000517          	auipc	a0,0x0
  800716:	5ae50513          	addi	a0,a0,1454 # 800cc0 <error_string+0x140>
  80071a:	9ddff0ef          	jal	ra,8000f6 <cprintf>
  80071e:	00000517          	auipc	a0,0x0
  800722:	5ba50513          	addi	a0,a0,1466 # 800cd8 <error_string+0x158>
  800726:	9d1ff0ef          	jal	ra,8000f6 <cprintf>
  80072a:	60e2                	ld	ra,24(sp)
  80072c:	6442                	ld	s0,16(sp)
  80072e:	4501                	li	a0,0
  800730:	6105                	addi	sp,sp,32
  800732:	8082                	ret
  800734:	00000697          	auipc	a3,0x0
  800738:	52c68693          	addi	a3,a3,1324 # 800c60 <error_string+0xe0>
  80073c:	00000617          	auipc	a2,0x0
  800740:	55c60613          	addi	a2,a2,1372 # 800c98 <error_string+0x118>
  800744:	45dd                	li	a1,23
  800746:	00000517          	auipc	a0,0x0
  80074a:	56a50513          	addi	a0,a0,1386 # 800cb0 <error_string+0x130>
  80074e:	8e3ff0ef          	jal	ra,800030 <__panic>
  800752:	f61ff0ef          	jal	ra,8006b2 <sleepy>
