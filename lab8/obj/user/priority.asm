
obj/__user_priority.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa95                	j	800198 <sys_open>

0000000000800026 <close>:
  800026:	aab5                	j	8001a2 <sys_close>

0000000000800028 <dup2>:
  800028:	a249                	j	8001aa <sys_dup>

000000000080002a <_start>:
  80002a:	1f4000ef          	jal	ra,80021e <umain>
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
  800044:	85050513          	addi	a0,a0,-1968 # 800890 <main+0x1bc>
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
  800064:	8a850513          	addi	a0,a0,-1880 # 800908 <main+0x234>
  800068:	08e000ef          	jal	ra,8000f6 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	146000ef          	jal	ra,8001b4 <exit>

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
  800086:	82e50513          	addi	a0,a0,-2002 # 8008b0 <main+0x1dc>
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
  8000a6:	86650513          	addi	a0,a0,-1946 # 800908 <main+0x234>
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
  8000be:	0c8000ef          	jal	ra,800186 <sys_putc>
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
  8000e2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <status+0xffffffffff7f5aa9>
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	c602                	sw	zero,12(sp)
  8000ea:	21e000ef          	jal	ra,800308 <vprintfmt>
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
  800116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <status+0xffffffffff7f5aa9>
  80011a:	ec06                	sd	ra,24(sp)
  80011c:	e4be                	sd	a5,72(sp)
  80011e:	e8c2                	sd	a6,80(sp)
  800120:	ecc6                	sd	a7,88(sp)
  800122:	e41a                	sd	t1,8(sp)
  800124:	c202                	sw	zero,4(sp)
  800126:	1e2000ef          	jal	ra,800308 <vprintfmt>
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

000000000080017c <sys_kill>:
  80017c:	85aa                	mv	a1,a0
  80017e:	4531                	li	a0,12
  800180:	bf4d                	j	800132 <syscall>

0000000000800182 <sys_getpid>:
  800182:	4549                	li	a0,18
  800184:	b77d                	j	800132 <syscall>

0000000000800186 <sys_putc>:
  800186:	85aa                	mv	a1,a0
  800188:	4579                	li	a0,30
  80018a:	b765                	j	800132 <syscall>

000000000080018c <sys_lab6_set_priority>:
  80018c:	85aa                	mv	a1,a0
  80018e:	0ff00513          	li	a0,255
  800192:	b745                	j	800132 <syscall>

0000000000800194 <sys_gettime>:
  800194:	4545                	li	a0,17
  800196:	bf71                	j	800132 <syscall>

0000000000800198 <sys_open>:
  800198:	862e                	mv	a2,a1
  80019a:	85aa                	mv	a1,a0
  80019c:	06400513          	li	a0,100
  8001a0:	bf49                	j	800132 <syscall>

00000000008001a2 <sys_close>:
  8001a2:	85aa                	mv	a1,a0
  8001a4:	06500513          	li	a0,101
  8001a8:	b769                	j	800132 <syscall>

00000000008001aa <sys_dup>:
  8001aa:	862e                	mv	a2,a1
  8001ac:	85aa                	mv	a1,a0
  8001ae:	08200513          	li	a0,130
  8001b2:	b741                	j	800132 <syscall>

00000000008001b4 <exit>:
  8001b4:	1141                	addi	sp,sp,-16
  8001b6:	e406                	sd	ra,8(sp)
  8001b8:	fb3ff0ef          	jal	ra,80016a <sys_exit>
  8001bc:	00000517          	auipc	a0,0x0
  8001c0:	71450513          	addi	a0,a0,1812 # 8008d0 <main+0x1fc>
  8001c4:	f33ff0ef          	jal	ra,8000f6 <cprintf>
  8001c8:	a001                	j	8001c8 <exit+0x14>

00000000008001ca <fork>:
  8001ca:	b75d                	j	800170 <sys_fork>

00000000008001cc <waitpid>:
  8001cc:	b765                	j	800174 <sys_wait>

00000000008001ce <kill>:
  8001ce:	b77d                	j	80017c <sys_kill>

00000000008001d0 <getpid>:
  8001d0:	bf4d                	j	800182 <sys_getpid>

00000000008001d2 <gettime_msec>:
  8001d2:	b7c9                	j	800194 <sys_gettime>

00000000008001d4 <lab6_set_priority>:
  8001d4:	1502                	slli	a0,a0,0x20
  8001d6:	9101                	srli	a0,a0,0x20
  8001d8:	bf55                	j	80018c <sys_lab6_set_priority>

00000000008001da <initfd>:
  8001da:	1101                	addi	sp,sp,-32
  8001dc:	87ae                	mv	a5,a1
  8001de:	e426                	sd	s1,8(sp)
  8001e0:	85b2                	mv	a1,a2
  8001e2:	84aa                	mv	s1,a0
  8001e4:	853e                	mv	a0,a5
  8001e6:	e822                	sd	s0,16(sp)
  8001e8:	ec06                	sd	ra,24(sp)
  8001ea:	e37ff0ef          	jal	ra,800020 <open>
  8001ee:	842a                	mv	s0,a0
  8001f0:	00054463          	bltz	a0,8001f8 <initfd+0x1e>
  8001f4:	00951863          	bne	a0,s1,800204 <initfd+0x2a>
  8001f8:	60e2                	ld	ra,24(sp)
  8001fa:	8522                	mv	a0,s0
  8001fc:	6442                	ld	s0,16(sp)
  8001fe:	64a2                	ld	s1,8(sp)
  800200:	6105                	addi	sp,sp,32
  800202:	8082                	ret
  800204:	8526                	mv	a0,s1
  800206:	e21ff0ef          	jal	ra,800026 <close>
  80020a:	85a6                	mv	a1,s1
  80020c:	8522                	mv	a0,s0
  80020e:	e1bff0ef          	jal	ra,800028 <dup2>
  800212:	84aa                	mv	s1,a0
  800214:	8522                	mv	a0,s0
  800216:	e11ff0ef          	jal	ra,800026 <close>
  80021a:	8426                	mv	s0,s1
  80021c:	bff1                	j	8001f8 <initfd+0x1e>

000000000080021e <umain>:
  80021e:	1101                	addi	sp,sp,-32
  800220:	e822                	sd	s0,16(sp)
  800222:	e426                	sd	s1,8(sp)
  800224:	842a                	mv	s0,a0
  800226:	84ae                	mv	s1,a1
  800228:	4601                	li	a2,0
  80022a:	00000597          	auipc	a1,0x0
  80022e:	6be58593          	addi	a1,a1,1726 # 8008e8 <main+0x214>
  800232:	4501                	li	a0,0
  800234:	ec06                	sd	ra,24(sp)
  800236:	fa5ff0ef          	jal	ra,8001da <initfd>
  80023a:	02054263          	bltz	a0,80025e <umain+0x40>
  80023e:	4605                	li	a2,1
  800240:	00000597          	auipc	a1,0x0
  800244:	6e858593          	addi	a1,a1,1768 # 800928 <main+0x254>
  800248:	4505                	li	a0,1
  80024a:	f91ff0ef          	jal	ra,8001da <initfd>
  80024e:	02054563          	bltz	a0,800278 <umain+0x5a>
  800252:	85a6                	mv	a1,s1
  800254:	8522                	mv	a0,s0
  800256:	47e000ef          	jal	ra,8006d4 <main>
  80025a:	f5bff0ef          	jal	ra,8001b4 <exit>
  80025e:	86aa                	mv	a3,a0
  800260:	00000617          	auipc	a2,0x0
  800264:	69060613          	addi	a2,a2,1680 # 8008f0 <main+0x21c>
  800268:	45e9                	li	a1,26
  80026a:	00000517          	auipc	a0,0x0
  80026e:	6a650513          	addi	a0,a0,1702 # 800910 <main+0x23c>
  800272:	e01ff0ef          	jal	ra,800072 <__warn>
  800276:	b7e1                	j	80023e <umain+0x20>
  800278:	86aa                	mv	a3,a0
  80027a:	00000617          	auipc	a2,0x0
  80027e:	6b660613          	addi	a2,a2,1718 # 800930 <main+0x25c>
  800282:	45f5                	li	a1,29
  800284:	00000517          	auipc	a0,0x0
  800288:	68c50513          	addi	a0,a0,1676 # 800910 <main+0x23c>
  80028c:	de7ff0ef          	jal	ra,800072 <__warn>
  800290:	b7c9                	j	800252 <umain+0x34>

0000000000800292 <printnum>:
  800292:	02071893          	slli	a7,a4,0x20
  800296:	7139                	addi	sp,sp,-64
  800298:	0208d893          	srli	a7,a7,0x20
  80029c:	e456                	sd	s5,8(sp)
  80029e:	0316fab3          	remu	s5,a3,a7
  8002a2:	f822                	sd	s0,48(sp)
  8002a4:	f426                	sd	s1,40(sp)
  8002a6:	f04a                	sd	s2,32(sp)
  8002a8:	ec4e                	sd	s3,24(sp)
  8002aa:	fc06                	sd	ra,56(sp)
  8002ac:	e852                	sd	s4,16(sp)
  8002ae:	84aa                	mv	s1,a0
  8002b0:	89ae                	mv	s3,a1
  8002b2:	8932                	mv	s2,a2
  8002b4:	fff7841b          	addiw	s0,a5,-1
  8002b8:	2a81                	sext.w	s5,s5
  8002ba:	0516f163          	bgeu	a3,a7,8002fc <printnum+0x6a>
  8002be:	8a42                	mv	s4,a6
  8002c0:	00805863          	blez	s0,8002d0 <printnum+0x3e>
  8002c4:	347d                	addiw	s0,s0,-1
  8002c6:	864e                	mv	a2,s3
  8002c8:	85ca                	mv	a1,s2
  8002ca:	8552                	mv	a0,s4
  8002cc:	9482                	jalr	s1
  8002ce:	f87d                	bnez	s0,8002c4 <printnum+0x32>
  8002d0:	1a82                	slli	s5,s5,0x20
  8002d2:	00000797          	auipc	a5,0x0
  8002d6:	67e78793          	addi	a5,a5,1662 # 800950 <main+0x27c>
  8002da:	020ada93          	srli	s5,s5,0x20
  8002de:	9abe                	add	s5,s5,a5
  8002e0:	7442                	ld	s0,48(sp)
  8002e2:	000ac503          	lbu	a0,0(s5)
  8002e6:	70e2                	ld	ra,56(sp)
  8002e8:	6a42                	ld	s4,16(sp)
  8002ea:	6aa2                	ld	s5,8(sp)
  8002ec:	864e                	mv	a2,s3
  8002ee:	85ca                	mv	a1,s2
  8002f0:	69e2                	ld	s3,24(sp)
  8002f2:	7902                	ld	s2,32(sp)
  8002f4:	87a6                	mv	a5,s1
  8002f6:	74a2                	ld	s1,40(sp)
  8002f8:	6121                	addi	sp,sp,64
  8002fa:	8782                	jr	a5
  8002fc:	0316d6b3          	divu	a3,a3,a7
  800300:	87a2                	mv	a5,s0
  800302:	f91ff0ef          	jal	ra,800292 <printnum>
  800306:	b7e9                	j	8002d0 <printnum+0x3e>

0000000000800308 <vprintfmt>:
  800308:	7119                	addi	sp,sp,-128
  80030a:	f4a6                	sd	s1,104(sp)
  80030c:	f0ca                	sd	s2,96(sp)
  80030e:	ecce                	sd	s3,88(sp)
  800310:	e8d2                	sd	s4,80(sp)
  800312:	e4d6                	sd	s5,72(sp)
  800314:	e0da                	sd	s6,64(sp)
  800316:	fc5e                	sd	s7,56(sp)
  800318:	ec6e                	sd	s11,24(sp)
  80031a:	fc86                	sd	ra,120(sp)
  80031c:	f8a2                	sd	s0,112(sp)
  80031e:	f862                	sd	s8,48(sp)
  800320:	f466                	sd	s9,40(sp)
  800322:	f06a                	sd	s10,32(sp)
  800324:	89aa                	mv	s3,a0
  800326:	892e                	mv	s2,a1
  800328:	84b2                	mv	s1,a2
  80032a:	8db6                	mv	s11,a3
  80032c:	8aba                	mv	s5,a4
  80032e:	02500a13          	li	s4,37
  800332:	5bfd                	li	s7,-1
  800334:	00000b17          	auipc	s6,0x0
  800338:	650b0b13          	addi	s6,s6,1616 # 800984 <main+0x2b0>
  80033c:	000dc503          	lbu	a0,0(s11)
  800340:	001d8413          	addi	s0,s11,1
  800344:	01450b63          	beq	a0,s4,80035a <vprintfmt+0x52>
  800348:	c129                	beqz	a0,80038a <vprintfmt+0x82>
  80034a:	864a                	mv	a2,s2
  80034c:	85a6                	mv	a1,s1
  80034e:	0405                	addi	s0,s0,1
  800350:	9982                	jalr	s3
  800352:	fff44503          	lbu	a0,-1(s0)
  800356:	ff4519e3          	bne	a0,s4,800348 <vprintfmt+0x40>
  80035a:	00044583          	lbu	a1,0(s0)
  80035e:	02000813          	li	a6,32
  800362:	4d01                	li	s10,0
  800364:	4301                	li	t1,0
  800366:	5cfd                	li	s9,-1
  800368:	5c7d                	li	s8,-1
  80036a:	05500513          	li	a0,85
  80036e:	48a5                	li	a7,9
  800370:	fdd5861b          	addiw	a2,a1,-35
  800374:	0ff67613          	zext.b	a2,a2
  800378:	00140d93          	addi	s11,s0,1
  80037c:	04c56263          	bltu	a0,a2,8003c0 <vprintfmt+0xb8>
  800380:	060a                	slli	a2,a2,0x2
  800382:	965a                	add	a2,a2,s6
  800384:	4214                	lw	a3,0(a2)
  800386:	96da                	add	a3,a3,s6
  800388:	8682                	jr	a3
  80038a:	70e6                	ld	ra,120(sp)
  80038c:	7446                	ld	s0,112(sp)
  80038e:	74a6                	ld	s1,104(sp)
  800390:	7906                	ld	s2,96(sp)
  800392:	69e6                	ld	s3,88(sp)
  800394:	6a46                	ld	s4,80(sp)
  800396:	6aa6                	ld	s5,72(sp)
  800398:	6b06                	ld	s6,64(sp)
  80039a:	7be2                	ld	s7,56(sp)
  80039c:	7c42                	ld	s8,48(sp)
  80039e:	7ca2                	ld	s9,40(sp)
  8003a0:	7d02                	ld	s10,32(sp)
  8003a2:	6de2                	ld	s11,24(sp)
  8003a4:	6109                	addi	sp,sp,128
  8003a6:	8082                	ret
  8003a8:	882e                	mv	a6,a1
  8003aa:	00144583          	lbu	a1,1(s0)
  8003ae:	846e                	mv	s0,s11
  8003b0:	00140d93          	addi	s11,s0,1
  8003b4:	fdd5861b          	addiw	a2,a1,-35
  8003b8:	0ff67613          	zext.b	a2,a2
  8003bc:	fcc572e3          	bgeu	a0,a2,800380 <vprintfmt+0x78>
  8003c0:	864a                	mv	a2,s2
  8003c2:	85a6                	mv	a1,s1
  8003c4:	02500513          	li	a0,37
  8003c8:	9982                	jalr	s3
  8003ca:	fff44783          	lbu	a5,-1(s0)
  8003ce:	8da2                	mv	s11,s0
  8003d0:	f74786e3          	beq	a5,s4,80033c <vprintfmt+0x34>
  8003d4:	ffedc783          	lbu	a5,-2(s11)
  8003d8:	1dfd                	addi	s11,s11,-1
  8003da:	ff479de3          	bne	a5,s4,8003d4 <vprintfmt+0xcc>
  8003de:	bfb9                	j	80033c <vprintfmt+0x34>
  8003e0:	fd058c9b          	addiw	s9,a1,-48
  8003e4:	00144583          	lbu	a1,1(s0)
  8003e8:	846e                	mv	s0,s11
  8003ea:	fd05869b          	addiw	a3,a1,-48
  8003ee:	0005861b          	sext.w	a2,a1
  8003f2:	02d8e463          	bltu	a7,a3,80041a <vprintfmt+0x112>
  8003f6:	00144583          	lbu	a1,1(s0)
  8003fa:	002c969b          	slliw	a3,s9,0x2
  8003fe:	0196873b          	addw	a4,a3,s9
  800402:	0017171b          	slliw	a4,a4,0x1
  800406:	9f31                	addw	a4,a4,a2
  800408:	fd05869b          	addiw	a3,a1,-48
  80040c:	0405                	addi	s0,s0,1
  80040e:	fd070c9b          	addiw	s9,a4,-48
  800412:	0005861b          	sext.w	a2,a1
  800416:	fed8f0e3          	bgeu	a7,a3,8003f6 <vprintfmt+0xee>
  80041a:	f40c5be3          	bgez	s8,800370 <vprintfmt+0x68>
  80041e:	8c66                	mv	s8,s9
  800420:	5cfd                	li	s9,-1
  800422:	b7b9                	j	800370 <vprintfmt+0x68>
  800424:	fffc4693          	not	a3,s8
  800428:	96fd                	srai	a3,a3,0x3f
  80042a:	00dc77b3          	and	a5,s8,a3
  80042e:	00144583          	lbu	a1,1(s0)
  800432:	00078c1b          	sext.w	s8,a5
  800436:	846e                	mv	s0,s11
  800438:	bf25                	j	800370 <vprintfmt+0x68>
  80043a:	000aac83          	lw	s9,0(s5)
  80043e:	00144583          	lbu	a1,1(s0)
  800442:	0aa1                	addi	s5,s5,8
  800444:	846e                	mv	s0,s11
  800446:	bfd1                	j	80041a <vprintfmt+0x112>
  800448:	4705                	li	a4,1
  80044a:	008a8613          	addi	a2,s5,8
  80044e:	00674463          	blt	a4,t1,800456 <vprintfmt+0x14e>
  800452:	1c030c63          	beqz	t1,80062a <vprintfmt+0x322>
  800456:	000ab683          	ld	a3,0(s5)
  80045a:	4741                	li	a4,16
  80045c:	8ab2                	mv	s5,a2
  80045e:	2801                	sext.w	a6,a6
  800460:	87e2                	mv	a5,s8
  800462:	8626                	mv	a2,s1
  800464:	85ca                	mv	a1,s2
  800466:	854e                	mv	a0,s3
  800468:	e2bff0ef          	jal	ra,800292 <printnum>
  80046c:	bdc1                	j	80033c <vprintfmt+0x34>
  80046e:	000aa503          	lw	a0,0(s5)
  800472:	864a                	mv	a2,s2
  800474:	85a6                	mv	a1,s1
  800476:	0aa1                	addi	s5,s5,8
  800478:	9982                	jalr	s3
  80047a:	b5c9                	j	80033c <vprintfmt+0x34>
  80047c:	4705                	li	a4,1
  80047e:	008a8613          	addi	a2,s5,8
  800482:	00674463          	blt	a4,t1,80048a <vprintfmt+0x182>
  800486:	18030d63          	beqz	t1,800620 <vprintfmt+0x318>
  80048a:	000ab683          	ld	a3,0(s5)
  80048e:	4729                	li	a4,10
  800490:	8ab2                	mv	s5,a2
  800492:	b7f1                	j	80045e <vprintfmt+0x156>
  800494:	00144583          	lbu	a1,1(s0)
  800498:	4d05                	li	s10,1
  80049a:	846e                	mv	s0,s11
  80049c:	bdd1                	j	800370 <vprintfmt+0x68>
  80049e:	864a                	mv	a2,s2
  8004a0:	85a6                	mv	a1,s1
  8004a2:	02500513          	li	a0,37
  8004a6:	9982                	jalr	s3
  8004a8:	bd51                	j	80033c <vprintfmt+0x34>
  8004aa:	00144583          	lbu	a1,1(s0)
  8004ae:	2305                	addiw	t1,t1,1
  8004b0:	846e                	mv	s0,s11
  8004b2:	bd7d                	j	800370 <vprintfmt+0x68>
  8004b4:	4705                	li	a4,1
  8004b6:	008a8613          	addi	a2,s5,8
  8004ba:	00674463          	blt	a4,t1,8004c2 <vprintfmt+0x1ba>
  8004be:	14030c63          	beqz	t1,800616 <vprintfmt+0x30e>
  8004c2:	000ab683          	ld	a3,0(s5)
  8004c6:	4721                	li	a4,8
  8004c8:	8ab2                	mv	s5,a2
  8004ca:	bf51                	j	80045e <vprintfmt+0x156>
  8004cc:	03000513          	li	a0,48
  8004d0:	864a                	mv	a2,s2
  8004d2:	85a6                	mv	a1,s1
  8004d4:	e042                	sd	a6,0(sp)
  8004d6:	9982                	jalr	s3
  8004d8:	864a                	mv	a2,s2
  8004da:	85a6                	mv	a1,s1
  8004dc:	07800513          	li	a0,120
  8004e0:	9982                	jalr	s3
  8004e2:	0aa1                	addi	s5,s5,8
  8004e4:	6802                	ld	a6,0(sp)
  8004e6:	4741                	li	a4,16
  8004e8:	ff8ab683          	ld	a3,-8(s5)
  8004ec:	bf8d                	j	80045e <vprintfmt+0x156>
  8004ee:	000ab403          	ld	s0,0(s5)
  8004f2:	008a8793          	addi	a5,s5,8
  8004f6:	e03e                	sd	a5,0(sp)
  8004f8:	14040c63          	beqz	s0,800650 <vprintfmt+0x348>
  8004fc:	11805063          	blez	s8,8005fc <vprintfmt+0x2f4>
  800500:	02d00693          	li	a3,45
  800504:	0cd81963          	bne	a6,a3,8005d6 <vprintfmt+0x2ce>
  800508:	00044683          	lbu	a3,0(s0)
  80050c:	0006851b          	sext.w	a0,a3
  800510:	ce8d                	beqz	a3,80054a <vprintfmt+0x242>
  800512:	00140a93          	addi	s5,s0,1
  800516:	05e00413          	li	s0,94
  80051a:	000cc563          	bltz	s9,800524 <vprintfmt+0x21c>
  80051e:	3cfd                	addiw	s9,s9,-1
  800520:	037c8363          	beq	s9,s7,800546 <vprintfmt+0x23e>
  800524:	864a                	mv	a2,s2
  800526:	85a6                	mv	a1,s1
  800528:	100d0663          	beqz	s10,800634 <vprintfmt+0x32c>
  80052c:	3681                	addiw	a3,a3,-32
  80052e:	10d47363          	bgeu	s0,a3,800634 <vprintfmt+0x32c>
  800532:	03f00513          	li	a0,63
  800536:	9982                	jalr	s3
  800538:	000ac683          	lbu	a3,0(s5)
  80053c:	3c7d                	addiw	s8,s8,-1
  80053e:	0a85                	addi	s5,s5,1
  800540:	0006851b          	sext.w	a0,a3
  800544:	faf9                	bnez	a3,80051a <vprintfmt+0x212>
  800546:	01805a63          	blez	s8,80055a <vprintfmt+0x252>
  80054a:	3c7d                	addiw	s8,s8,-1
  80054c:	864a                	mv	a2,s2
  80054e:	85a6                	mv	a1,s1
  800550:	02000513          	li	a0,32
  800554:	9982                	jalr	s3
  800556:	fe0c1ae3          	bnez	s8,80054a <vprintfmt+0x242>
  80055a:	6a82                	ld	s5,0(sp)
  80055c:	b3c5                	j	80033c <vprintfmt+0x34>
  80055e:	4705                	li	a4,1
  800560:	008a8d13          	addi	s10,s5,8
  800564:	00674463          	blt	a4,t1,80056c <vprintfmt+0x264>
  800568:	0a030463          	beqz	t1,800610 <vprintfmt+0x308>
  80056c:	000ab403          	ld	s0,0(s5)
  800570:	0c044463          	bltz	s0,800638 <vprintfmt+0x330>
  800574:	86a2                	mv	a3,s0
  800576:	8aea                	mv	s5,s10
  800578:	4729                	li	a4,10
  80057a:	b5d5                	j	80045e <vprintfmt+0x156>
  80057c:	000aa783          	lw	a5,0(s5)
  800580:	46e1                	li	a3,24
  800582:	0aa1                	addi	s5,s5,8
  800584:	41f7d71b          	sraiw	a4,a5,0x1f
  800588:	8fb9                	xor	a5,a5,a4
  80058a:	40e7873b          	subw	a4,a5,a4
  80058e:	02e6c663          	blt	a3,a4,8005ba <vprintfmt+0x2b2>
  800592:	00371793          	slli	a5,a4,0x3
  800596:	00000697          	auipc	a3,0x0
  80059a:	72268693          	addi	a3,a3,1826 # 800cb8 <error_string>
  80059e:	97b6                	add	a5,a5,a3
  8005a0:	639c                	ld	a5,0(a5)
  8005a2:	cf81                	beqz	a5,8005ba <vprintfmt+0x2b2>
  8005a4:	873e                	mv	a4,a5
  8005a6:	00000697          	auipc	a3,0x0
  8005aa:	3da68693          	addi	a3,a3,986 # 800980 <main+0x2ac>
  8005ae:	8626                	mv	a2,s1
  8005b0:	85ca                	mv	a1,s2
  8005b2:	854e                	mv	a0,s3
  8005b4:	0d4000ef          	jal	ra,800688 <printfmt>
  8005b8:	b351                	j	80033c <vprintfmt+0x34>
  8005ba:	00000697          	auipc	a3,0x0
  8005be:	3b668693          	addi	a3,a3,950 # 800970 <main+0x29c>
  8005c2:	8626                	mv	a2,s1
  8005c4:	85ca                	mv	a1,s2
  8005c6:	854e                	mv	a0,s3
  8005c8:	0c0000ef          	jal	ra,800688 <printfmt>
  8005cc:	bb85                	j	80033c <vprintfmt+0x34>
  8005ce:	00000417          	auipc	s0,0x0
  8005d2:	39a40413          	addi	s0,s0,922 # 800968 <main+0x294>
  8005d6:	85e6                	mv	a1,s9
  8005d8:	8522                	mv	a0,s0
  8005da:	e442                	sd	a6,8(sp)
  8005dc:	0ca000ef          	jal	ra,8006a6 <strnlen>
  8005e0:	40ac0c3b          	subw	s8,s8,a0
  8005e4:	01805c63          	blez	s8,8005fc <vprintfmt+0x2f4>
  8005e8:	6822                	ld	a6,8(sp)
  8005ea:	00080a9b          	sext.w	s5,a6
  8005ee:	3c7d                	addiw	s8,s8,-1
  8005f0:	864a                	mv	a2,s2
  8005f2:	85a6                	mv	a1,s1
  8005f4:	8556                	mv	a0,s5
  8005f6:	9982                	jalr	s3
  8005f8:	fe0c1be3          	bnez	s8,8005ee <vprintfmt+0x2e6>
  8005fc:	00044683          	lbu	a3,0(s0)
  800600:	00140a93          	addi	s5,s0,1
  800604:	0006851b          	sext.w	a0,a3
  800608:	daa9                	beqz	a3,80055a <vprintfmt+0x252>
  80060a:	05e00413          	li	s0,94
  80060e:	b731                	j	80051a <vprintfmt+0x212>
  800610:	000aa403          	lw	s0,0(s5)
  800614:	bfb1                	j	800570 <vprintfmt+0x268>
  800616:	000ae683          	lwu	a3,0(s5)
  80061a:	4721                	li	a4,8
  80061c:	8ab2                	mv	s5,a2
  80061e:	b581                	j	80045e <vprintfmt+0x156>
  800620:	000ae683          	lwu	a3,0(s5)
  800624:	4729                	li	a4,10
  800626:	8ab2                	mv	s5,a2
  800628:	bd1d                	j	80045e <vprintfmt+0x156>
  80062a:	000ae683          	lwu	a3,0(s5)
  80062e:	4741                	li	a4,16
  800630:	8ab2                	mv	s5,a2
  800632:	b535                	j	80045e <vprintfmt+0x156>
  800634:	9982                	jalr	s3
  800636:	b709                	j	800538 <vprintfmt+0x230>
  800638:	864a                	mv	a2,s2
  80063a:	85a6                	mv	a1,s1
  80063c:	02d00513          	li	a0,45
  800640:	e042                	sd	a6,0(sp)
  800642:	9982                	jalr	s3
  800644:	6802                	ld	a6,0(sp)
  800646:	8aea                	mv	s5,s10
  800648:	408006b3          	neg	a3,s0
  80064c:	4729                	li	a4,10
  80064e:	bd01                	j	80045e <vprintfmt+0x156>
  800650:	03805163          	blez	s8,800672 <vprintfmt+0x36a>
  800654:	02d00693          	li	a3,45
  800658:	f6d81be3          	bne	a6,a3,8005ce <vprintfmt+0x2c6>
  80065c:	00000417          	auipc	s0,0x0
  800660:	30c40413          	addi	s0,s0,780 # 800968 <main+0x294>
  800664:	02800693          	li	a3,40
  800668:	02800513          	li	a0,40
  80066c:	00140a93          	addi	s5,s0,1
  800670:	b55d                	j	800516 <vprintfmt+0x20e>
  800672:	00000a97          	auipc	s5,0x0
  800676:	2f7a8a93          	addi	s5,s5,759 # 800969 <main+0x295>
  80067a:	02800513          	li	a0,40
  80067e:	02800693          	li	a3,40
  800682:	05e00413          	li	s0,94
  800686:	bd51                	j	80051a <vprintfmt+0x212>

0000000000800688 <printfmt>:
  800688:	7139                	addi	sp,sp,-64
  80068a:	02010313          	addi	t1,sp,32
  80068e:	f03a                	sd	a4,32(sp)
  800690:	871a                	mv	a4,t1
  800692:	ec06                	sd	ra,24(sp)
  800694:	f43e                	sd	a5,40(sp)
  800696:	f842                	sd	a6,48(sp)
  800698:	fc46                	sd	a7,56(sp)
  80069a:	e41a                	sd	t1,8(sp)
  80069c:	c6dff0ef          	jal	ra,800308 <vprintfmt>
  8006a0:	60e2                	ld	ra,24(sp)
  8006a2:	6121                	addi	sp,sp,64
  8006a4:	8082                	ret

00000000008006a6 <strnlen>:
  8006a6:	4781                	li	a5,0
  8006a8:	e589                	bnez	a1,8006b2 <strnlen+0xc>
  8006aa:	a811                	j	8006be <strnlen+0x18>
  8006ac:	0785                	addi	a5,a5,1
  8006ae:	00f58863          	beq	a1,a5,8006be <strnlen+0x18>
  8006b2:	00f50733          	add	a4,a0,a5
  8006b6:	00074703          	lbu	a4,0(a4)
  8006ba:	fb6d                	bnez	a4,8006ac <strnlen+0x6>
  8006bc:	85be                	mv	a1,a5
  8006be:	852e                	mv	a0,a1
  8006c0:	8082                	ret

00000000008006c2 <memset>:
  8006c2:	ca01                	beqz	a2,8006d2 <memset+0x10>
  8006c4:	962a                	add	a2,a2,a0
  8006c6:	87aa                	mv	a5,a0
  8006c8:	0785                	addi	a5,a5,1
  8006ca:	feb78fa3          	sb	a1,-1(a5)
  8006ce:	fec79de3          	bne	a5,a2,8006c8 <memset+0x6>
  8006d2:	8082                	ret

00000000008006d4 <main>:
  8006d4:	711d                	addi	sp,sp,-96
  8006d6:	4651                	li	a2,20
  8006d8:	4581                	li	a1,0
  8006da:	00001517          	auipc	a0,0x1
  8006de:	93e50513          	addi	a0,a0,-1730 # 801018 <pids>
  8006e2:	ec86                	sd	ra,88(sp)
  8006e4:	e8a2                	sd	s0,80(sp)
  8006e6:	e4a6                	sd	s1,72(sp)
  8006e8:	e0ca                	sd	s2,64(sp)
  8006ea:	fc4e                	sd	s3,56(sp)
  8006ec:	f852                	sd	s4,48(sp)
  8006ee:	f456                	sd	s5,40(sp)
  8006f0:	f05a                	sd	s6,32(sp)
  8006f2:	ec5e                	sd	s7,24(sp)
  8006f4:	fcfff0ef          	jal	ra,8006c2 <memset>
  8006f8:	4519                	li	a0,6
  8006fa:	00001a97          	auipc	s5,0x1
  8006fe:	906a8a93          	addi	s5,s5,-1786 # 801000 <acc>
  800702:	00001917          	auipc	s2,0x1
  800706:	91690913          	addi	s2,s2,-1770 # 801018 <pids>
  80070a:	acbff0ef          	jal	ra,8001d4 <lab6_set_priority>
  80070e:	89d6                	mv	s3,s5
  800710:	84ca                	mv	s1,s2
  800712:	4401                	li	s0,0
  800714:	4a15                	li	s4,5
  800716:	0009a023          	sw	zero,0(s3)
  80071a:	ab1ff0ef          	jal	ra,8001ca <fork>
  80071e:	c088                	sw	a0,0(s1)
  800720:	c969                	beqz	a0,8007f2 <main+0x11e>
  800722:	12054d63          	bltz	a0,80085c <main+0x188>
  800726:	2405                	addiw	s0,s0,1
  800728:	0991                	addi	s3,s3,4
  80072a:	0491                	addi	s1,s1,4
  80072c:	ff4415e3          	bne	s0,s4,800716 <main+0x42>
  800730:	00001497          	auipc	s1,0x1
  800734:	90048493          	addi	s1,s1,-1792 # 801030 <status>
  800738:	00000517          	auipc	a0,0x0
  80073c:	66850513          	addi	a0,a0,1640 # 800da0 <error_string+0xe8>
  800740:	9b7ff0ef          	jal	ra,8000f6 <cprintf>
  800744:	00001997          	auipc	s3,0x1
  800748:	90098993          	addi	s3,s3,-1792 # 801044 <status+0x14>
  80074c:	8a26                	mv	s4,s1
  80074e:	8426                	mv	s0,s1
  800750:	00000b97          	auipc	s7,0x0
  800754:	678b8b93          	addi	s7,s7,1656 # 800dc8 <error_string+0x110>
  800758:	00092503          	lw	a0,0(s2)
  80075c:	85a2                	mv	a1,s0
  80075e:	00042023          	sw	zero,0(s0)
  800762:	a6bff0ef          	jal	ra,8001cc <waitpid>
  800766:	00092a83          	lw	s5,0(s2)
  80076a:	00042b03          	lw	s6,0(s0)
  80076e:	a65ff0ef          	jal	ra,8001d2 <gettime_msec>
  800772:	0005069b          	sext.w	a3,a0
  800776:	865a                	mv	a2,s6
  800778:	85d6                	mv	a1,s5
  80077a:	855e                	mv	a0,s7
  80077c:	0411                	addi	s0,s0,4
  80077e:	979ff0ef          	jal	ra,8000f6 <cprintf>
  800782:	0911                	addi	s2,s2,4
  800784:	fd341ae3          	bne	s0,s3,800758 <main+0x84>
  800788:	00000517          	auipc	a0,0x0
  80078c:	66050513          	addi	a0,a0,1632 # 800de8 <error_string+0x130>
  800790:	967ff0ef          	jal	ra,8000f6 <cprintf>
  800794:	00000517          	auipc	a0,0x0
  800798:	66c50513          	addi	a0,a0,1644 # 800e00 <error_string+0x148>
  80079c:	95bff0ef          	jal	ra,8000f6 <cprintf>
  8007a0:	00000417          	auipc	s0,0x0
  8007a4:	68040413          	addi	s0,s0,1664 # 800e20 <error_string+0x168>
  8007a8:	408c                	lw	a1,0(s1)
  8007aa:	000a2783          	lw	a5,0(s4)
  8007ae:	0491                	addi	s1,s1,4
  8007b0:	0015959b          	slliw	a1,a1,0x1
  8007b4:	02f5c5bb          	divw	a1,a1,a5
  8007b8:	8522                	mv	a0,s0
  8007ba:	2585                	addiw	a1,a1,1
  8007bc:	01f5d79b          	srliw	a5,a1,0x1f
  8007c0:	9dbd                	addw	a1,a1,a5
  8007c2:	4015d59b          	sraiw	a1,a1,0x1
  8007c6:	931ff0ef          	jal	ra,8000f6 <cprintf>
  8007ca:	fd349fe3          	bne	s1,s3,8007a8 <main+0xd4>
  8007ce:	00000517          	auipc	a0,0x0
  8007d2:	13a50513          	addi	a0,a0,314 # 800908 <main+0x234>
  8007d6:	921ff0ef          	jal	ra,8000f6 <cprintf>
  8007da:	60e6                	ld	ra,88(sp)
  8007dc:	6446                	ld	s0,80(sp)
  8007de:	64a6                	ld	s1,72(sp)
  8007e0:	6906                	ld	s2,64(sp)
  8007e2:	79e2                	ld	s3,56(sp)
  8007e4:	7a42                	ld	s4,48(sp)
  8007e6:	7aa2                	ld	s5,40(sp)
  8007e8:	7b02                	ld	s6,32(sp)
  8007ea:	6be2                	ld	s7,24(sp)
  8007ec:	4501                	li	a0,0
  8007ee:	6125                	addi	sp,sp,96
  8007f0:	8082                	ret
  8007f2:	0014051b          	addiw	a0,s0,1
  8007f6:	040a                	slli	s0,s0,0x2
  8007f8:	9456                	add	s0,s0,s5
  8007fa:	6485                	lui	s1,0x1
  8007fc:	6989                	lui	s3,0x2
  8007fe:	9d7ff0ef          	jal	ra,8001d4 <lab6_set_priority>
  800802:	fa04849b          	addiw	s1,s1,-96
  800806:	00042023          	sw	zero,0(s0)
  80080a:	71098993          	addi	s3,s3,1808 # 2710 <open-0x7fd910>
  80080e:	4014                	lw	a3,0(s0)
  800810:	2685                	addiw	a3,a3,1
  800812:	0c800713          	li	a4,200
  800816:	47b2                	lw	a5,12(sp)
  800818:	377d                	addiw	a4,a4,-1
  80081a:	2781                	sext.w	a5,a5
  80081c:	0017b793          	seqz	a5,a5
  800820:	c63e                	sw	a5,12(sp)
  800822:	fb75                	bnez	a4,800816 <main+0x142>
  800824:	0296f7bb          	remuw	a5,a3,s1
  800828:	0016871b          	addiw	a4,a3,1
  80082c:	c399                	beqz	a5,800832 <main+0x15e>
  80082e:	86ba                	mv	a3,a4
  800830:	b7cd                	j	800812 <main+0x13e>
  800832:	c014                	sw	a3,0(s0)
  800834:	99fff0ef          	jal	ra,8001d2 <gettime_msec>
  800838:	0005091b          	sext.w	s2,a0
  80083c:	fd29d9e3          	bge	s3,s2,80080e <main+0x13a>
  800840:	991ff0ef          	jal	ra,8001d0 <getpid>
  800844:	4010                	lw	a2,0(s0)
  800846:	85aa                	mv	a1,a0
  800848:	86ca                	mv	a3,s2
  80084a:	00000517          	auipc	a0,0x0
  80084e:	53650513          	addi	a0,a0,1334 # 800d80 <error_string+0xc8>
  800852:	8a5ff0ef          	jal	ra,8000f6 <cprintf>
  800856:	4008                	lw	a0,0(s0)
  800858:	95dff0ef          	jal	ra,8001b4 <exit>
  80085c:	00000417          	auipc	s0,0x0
  800860:	7d040413          	addi	s0,s0,2000 # 80102c <pids+0x14>
  800864:	00092503          	lw	a0,0(s2)
  800868:	00a05463          	blez	a0,800870 <main+0x19c>
  80086c:	963ff0ef          	jal	ra,8001ce <kill>
  800870:	0911                	addi	s2,s2,4
  800872:	ff2419e3          	bne	s0,s2,800864 <main+0x190>
  800876:	00000617          	auipc	a2,0x0
  80087a:	5b260613          	addi	a2,a2,1458 # 800e28 <error_string+0x170>
  80087e:	04b00593          	li	a1,75
  800882:	00000517          	auipc	a0,0x0
  800886:	5b650513          	addi	a0,a0,1462 # 800e38 <error_string+0x180>
  80088a:	fa6ff0ef          	jal	ra,800030 <__panic>
