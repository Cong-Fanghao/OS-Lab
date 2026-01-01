
obj/__user_sh.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a431                	j	800230 <sys_open>

0000000000800026 <close>:
  800026:	ac11                	j	80023a <sys_close>

0000000000800028 <read>:
  800028:	ac29                	j	800242 <sys_read>

000000000080002a <write>:
  80002a:	a415                	j	80024e <sys_write>

000000000080002c <dup2>:
  80002c:	a43d                	j	80025a <sys_dup>

000000000080002e <_start>:
  80002e:	2ae000ef          	jal	ra,8002dc <umain>
  800032:	a001                	j	800032 <_start+0x4>

0000000000800034 <__panic>:
  800034:	715d                	addi	sp,sp,-80
  800036:	8e2e                	mv	t3,a1
  800038:	e822                	sd	s0,16(sp)
  80003a:	85aa                	mv	a1,a0
  80003c:	8432                	mv	s0,a2
  80003e:	fc3e                	sd	a5,56(sp)
  800040:	8672                	mv	a2,t3
  800042:	103c                	addi	a5,sp,40
  800044:	00001517          	auipc	a0,0x1
  800048:	d1c50513          	addi	a0,a0,-740 # 800d60 <main+0xce>
  80004c:	ec06                	sd	ra,24(sp)
  80004e:	f436                	sd	a3,40(sp)
  800050:	f83a                	sd	a4,48(sp)
  800052:	e0c2                	sd	a6,64(sp)
  800054:	e4c6                	sd	a7,72(sp)
  800056:	e43e                	sd	a5,8(sp)
  800058:	0cc000ef          	jal	ra,800124 <cprintf>
  80005c:	65a2                	ld	a1,8(sp)
  80005e:	8522                	mv	a0,s0
  800060:	09e000ef          	jal	ra,8000fe <vcprintf>
  800064:	00001517          	auipc	a0,0x1
  800068:	d7450513          	addi	a0,a0,-652 # 800dd8 <main+0x146>
  80006c:	0b8000ef          	jal	ra,800124 <cprintf>
  800070:	5559                	li	a0,-10
  800072:	1f2000ef          	jal	ra,800264 <exit>

0000000000800076 <__warn>:
  800076:	715d                	addi	sp,sp,-80
  800078:	832e                	mv	t1,a1
  80007a:	e822                	sd	s0,16(sp)
  80007c:	85aa                	mv	a1,a0
  80007e:	8432                	mv	s0,a2
  800080:	fc3e                	sd	a5,56(sp)
  800082:	861a                	mv	a2,t1
  800084:	103c                	addi	a5,sp,40
  800086:	00001517          	auipc	a0,0x1
  80008a:	cfa50513          	addi	a0,a0,-774 # 800d80 <main+0xee>
  80008e:	ec06                	sd	ra,24(sp)
  800090:	f436                	sd	a3,40(sp)
  800092:	f83a                	sd	a4,48(sp)
  800094:	e0c2                	sd	a6,64(sp)
  800096:	e4c6                	sd	a7,72(sp)
  800098:	e43e                	sd	a5,8(sp)
  80009a:	08a000ef          	jal	ra,800124 <cprintf>
  80009e:	65a2                	ld	a1,8(sp)
  8000a0:	8522                	mv	a0,s0
  8000a2:	05c000ef          	jal	ra,8000fe <vcprintf>
  8000a6:	00001517          	auipc	a0,0x1
  8000aa:	d3250513          	addi	a0,a0,-718 # 800dd8 <main+0x146>
  8000ae:	076000ef          	jal	ra,800124 <cprintf>
  8000b2:	60e2                	ld	ra,24(sp)
  8000b4:	6442                	ld	s0,16(sp)
  8000b6:	6161                	addi	sp,sp,80
  8000b8:	8082                	ret

00000000008000ba <cputch>:
  8000ba:	1141                	addi	sp,sp,-16
  8000bc:	e022                	sd	s0,0(sp)
  8000be:	e406                	sd	ra,8(sp)
  8000c0:	842e                	mv	s0,a1
  8000c2:	15e000ef          	jal	ra,800220 <sys_putc>
  8000c6:	401c                	lw	a5,0(s0)
  8000c8:	60a2                	ld	ra,8(sp)
  8000ca:	2785                	addiw	a5,a5,1
  8000cc:	c01c                	sw	a5,0(s0)
  8000ce:	6402                	ld	s0,0(sp)
  8000d0:	0141                	addi	sp,sp,16
  8000d2:	8082                	ret

00000000008000d4 <fputch>:
  8000d4:	1101                	addi	sp,sp,-32
  8000d6:	8732                	mv	a4,a2
  8000d8:	e822                	sd	s0,16(sp)
  8000da:	87aa                	mv	a5,a0
  8000dc:	842e                	mv	s0,a1
  8000de:	4605                	li	a2,1
  8000e0:	00f10593          	addi	a1,sp,15
  8000e4:	853a                	mv	a0,a4
  8000e6:	ec06                	sd	ra,24(sp)
  8000e8:	00f107a3          	sb	a5,15(sp)
  8000ec:	f3fff0ef          	jal	ra,80002a <write>
  8000f0:	401c                	lw	a5,0(s0)
  8000f2:	60e2                	ld	ra,24(sp)
  8000f4:	2785                	addiw	a5,a5,1
  8000f6:	c01c                	sw	a5,0(s0)
  8000f8:	6442                	ld	s0,16(sp)
  8000fa:	6105                	addi	sp,sp,32
  8000fc:	8082                	ret

00000000008000fe <vcprintf>:
  8000fe:	1101                	addi	sp,sp,-32
  800100:	872e                	mv	a4,a1
  800102:	75dd                	lui	a1,0xffff7
  800104:	86aa                	mv	a3,a0
  800106:	0070                	addi	a2,sp,12
  800108:	00000517          	auipc	a0,0x0
  80010c:	fb250513          	addi	a0,a0,-78 # 8000ba <cputch>
  800110:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  800114:	ec06                	sd	ra,24(sp)
  800116:	c602                	sw	zero,12(sp)
  800118:	2c8000ef          	jal	ra,8003e0 <vprintfmt>
  80011c:	60e2                	ld	ra,24(sp)
  80011e:	4532                	lw	a0,12(sp)
  800120:	6105                	addi	sp,sp,32
  800122:	8082                	ret

0000000000800124 <cprintf>:
  800124:	711d                	addi	sp,sp,-96
  800126:	02810313          	addi	t1,sp,40
  80012a:	8e2a                	mv	t3,a0
  80012c:	f42e                	sd	a1,40(sp)
  80012e:	75dd                	lui	a1,0xffff7
  800130:	f832                	sd	a2,48(sp)
  800132:	fc36                	sd	a3,56(sp)
  800134:	e0ba                	sd	a4,64(sp)
  800136:	00000517          	auipc	a0,0x0
  80013a:	f8450513          	addi	a0,a0,-124 # 8000ba <cputch>
  80013e:	0050                	addi	a2,sp,4
  800140:	871a                	mv	a4,t1
  800142:	86f2                	mv	a3,t3
  800144:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  800148:	ec06                	sd	ra,24(sp)
  80014a:	e4be                	sd	a5,72(sp)
  80014c:	e8c2                	sd	a6,80(sp)
  80014e:	ecc6                	sd	a7,88(sp)
  800150:	e41a                	sd	t1,8(sp)
  800152:	c202                	sw	zero,4(sp)
  800154:	28c000ef          	jal	ra,8003e0 <vprintfmt>
  800158:	60e2                	ld	ra,24(sp)
  80015a:	4512                	lw	a0,4(sp)
  80015c:	6125                	addi	sp,sp,96
  80015e:	8082                	ret

0000000000800160 <cputs>:
  800160:	1101                	addi	sp,sp,-32
  800162:	e822                	sd	s0,16(sp)
  800164:	ec06                	sd	ra,24(sp)
  800166:	e426                	sd	s1,8(sp)
  800168:	842a                	mv	s0,a0
  80016a:	00054503          	lbu	a0,0(a0)
  80016e:	c51d                	beqz	a0,80019c <cputs+0x3c>
  800170:	0405                	addi	s0,s0,1
  800172:	4485                	li	s1,1
  800174:	9c81                	subw	s1,s1,s0
  800176:	0aa000ef          	jal	ra,800220 <sys_putc>
  80017a:	00044503          	lbu	a0,0(s0)
  80017e:	008487bb          	addw	a5,s1,s0
  800182:	0405                	addi	s0,s0,1
  800184:	f96d                	bnez	a0,800176 <cputs+0x16>
  800186:	0017841b          	addiw	s0,a5,1
  80018a:	4529                	li	a0,10
  80018c:	094000ef          	jal	ra,800220 <sys_putc>
  800190:	60e2                	ld	ra,24(sp)
  800192:	8522                	mv	a0,s0
  800194:	6442                	ld	s0,16(sp)
  800196:	64a2                	ld	s1,8(sp)
  800198:	6105                	addi	sp,sp,32
  80019a:	8082                	ret
  80019c:	4405                	li	s0,1
  80019e:	b7f5                	j	80018a <cputs+0x2a>

00000000008001a0 <fprintf>:
  8001a0:	715d                	addi	sp,sp,-80
  8001a2:	02010313          	addi	t1,sp,32
  8001a6:	8e2a                	mv	t3,a0
  8001a8:	f032                	sd	a2,32(sp)
  8001aa:	f436                	sd	a3,40(sp)
  8001ac:	f83a                	sd	a4,48(sp)
  8001ae:	00000517          	auipc	a0,0x0
  8001b2:	f2650513          	addi	a0,a0,-218 # 8000d4 <fputch>
  8001b6:	86ae                	mv	a3,a1
  8001b8:	0050                	addi	a2,sp,4
  8001ba:	871a                	mv	a4,t1
  8001bc:	85f2                	mv	a1,t3
  8001be:	ec06                	sd	ra,24(sp)
  8001c0:	fc3e                	sd	a5,56(sp)
  8001c2:	e0c2                	sd	a6,64(sp)
  8001c4:	e4c6                	sd	a7,72(sp)
  8001c6:	e41a                	sd	t1,8(sp)
  8001c8:	c202                	sw	zero,4(sp)
  8001ca:	216000ef          	jal	ra,8003e0 <vprintfmt>
  8001ce:	60e2                	ld	ra,24(sp)
  8001d0:	4512                	lw	a0,4(sp)
  8001d2:	6161                	addi	sp,sp,80
  8001d4:	8082                	ret

00000000008001d6 <syscall>:
  8001d6:	7175                	addi	sp,sp,-144
  8001d8:	f8ba                	sd	a4,112(sp)
  8001da:	e0ba                	sd	a4,64(sp)
  8001dc:	0118                	addi	a4,sp,128
  8001de:	e42a                	sd	a0,8(sp)
  8001e0:	ecae                	sd	a1,88(sp)
  8001e2:	f0b2                	sd	a2,96(sp)
  8001e4:	f4b6                	sd	a3,104(sp)
  8001e6:	fcbe                	sd	a5,120(sp)
  8001e8:	e142                	sd	a6,128(sp)
  8001ea:	e546                	sd	a7,136(sp)
  8001ec:	f42e                	sd	a1,40(sp)
  8001ee:	f832                	sd	a2,48(sp)
  8001f0:	fc36                	sd	a3,56(sp)
  8001f2:	f03a                	sd	a4,32(sp)
  8001f4:	e4be                	sd	a5,72(sp)
  8001f6:	4522                	lw	a0,8(sp)
  8001f8:	55a2                	lw	a1,40(sp)
  8001fa:	5642                	lw	a2,48(sp)
  8001fc:	56e2                	lw	a3,56(sp)
  8001fe:	4706                	lw	a4,64(sp)
  800200:	47a6                	lw	a5,72(sp)
  800202:	00000073          	ecall
  800206:	ce2a                	sw	a0,28(sp)
  800208:	4572                	lw	a0,28(sp)
  80020a:	6149                	addi	sp,sp,144
  80020c:	8082                	ret

000000000080020e <sys_exit>:
  80020e:	85aa                	mv	a1,a0
  800210:	4505                	li	a0,1
  800212:	b7d1                	j	8001d6 <syscall>

0000000000800214 <sys_fork>:
  800214:	4509                	li	a0,2
  800216:	b7c1                	j	8001d6 <syscall>

0000000000800218 <sys_wait>:
  800218:	862e                	mv	a2,a1
  80021a:	85aa                	mv	a1,a0
  80021c:	450d                	li	a0,3
  80021e:	bf65                	j	8001d6 <syscall>

0000000000800220 <sys_putc>:
  800220:	85aa                	mv	a1,a0
  800222:	4579                	li	a0,30
  800224:	bf4d                	j	8001d6 <syscall>

0000000000800226 <sys_exec>:
  800226:	86b2                	mv	a3,a2
  800228:	862e                	mv	a2,a1
  80022a:	85aa                	mv	a1,a0
  80022c:	4511                	li	a0,4
  80022e:	b765                	j	8001d6 <syscall>

0000000000800230 <sys_open>:
  800230:	862e                	mv	a2,a1
  800232:	85aa                	mv	a1,a0
  800234:	06400513          	li	a0,100
  800238:	bf79                	j	8001d6 <syscall>

000000000080023a <sys_close>:
  80023a:	85aa                	mv	a1,a0
  80023c:	06500513          	li	a0,101
  800240:	bf59                	j	8001d6 <syscall>

0000000000800242 <sys_read>:
  800242:	86b2                	mv	a3,a2
  800244:	862e                	mv	a2,a1
  800246:	85aa                	mv	a1,a0
  800248:	06600513          	li	a0,102
  80024c:	b769                	j	8001d6 <syscall>

000000000080024e <sys_write>:
  80024e:	86b2                	mv	a3,a2
  800250:	862e                	mv	a2,a1
  800252:	85aa                	mv	a1,a0
  800254:	06700513          	li	a0,103
  800258:	bfbd                	j	8001d6 <syscall>

000000000080025a <sys_dup>:
  80025a:	862e                	mv	a2,a1
  80025c:	85aa                	mv	a1,a0
  80025e:	08200513          	li	a0,130
  800262:	bf95                	j	8001d6 <syscall>

0000000000800264 <exit>:
  800264:	1141                	addi	sp,sp,-16
  800266:	e406                	sd	ra,8(sp)
  800268:	fa7ff0ef          	jal	ra,80020e <sys_exit>
  80026c:	00001517          	auipc	a0,0x1
  800270:	b3450513          	addi	a0,a0,-1228 # 800da0 <main+0x10e>
  800274:	eb1ff0ef          	jal	ra,800124 <cprintf>
  800278:	a001                	j	800278 <exit+0x14>

000000000080027a <fork>:
  80027a:	bf69                	j	800214 <sys_fork>

000000000080027c <waitpid>:
  80027c:	bf71                	j	800218 <sys_wait>

000000000080027e <__exec>:
  80027e:	619c                	ld	a5,0(a1)
  800280:	862e                	mv	a2,a1
  800282:	cb89                	beqz	a5,800294 <__exec+0x16>
  800284:	00858793          	addi	a5,a1,8
  800288:	4581                	li	a1,0
  80028a:	6398                	ld	a4,0(a5)
  80028c:	2585                	addiw	a1,a1,1
  80028e:	07a1                	addi	a5,a5,8
  800290:	ff6d                	bnez	a4,80028a <__exec+0xc>
  800292:	bf51                	j	800226 <sys_exec>
  800294:	4581                	li	a1,0
  800296:	bf41                	j	800226 <sys_exec>

0000000000800298 <initfd>:
  800298:	1101                	addi	sp,sp,-32
  80029a:	87ae                	mv	a5,a1
  80029c:	e426                	sd	s1,8(sp)
  80029e:	85b2                	mv	a1,a2
  8002a0:	84aa                	mv	s1,a0
  8002a2:	853e                	mv	a0,a5
  8002a4:	e822                	sd	s0,16(sp)
  8002a6:	ec06                	sd	ra,24(sp)
  8002a8:	d79ff0ef          	jal	ra,800020 <open>
  8002ac:	842a                	mv	s0,a0
  8002ae:	00054463          	bltz	a0,8002b6 <initfd+0x1e>
  8002b2:	00951863          	bne	a0,s1,8002c2 <initfd+0x2a>
  8002b6:	60e2                	ld	ra,24(sp)
  8002b8:	8522                	mv	a0,s0
  8002ba:	6442                	ld	s0,16(sp)
  8002bc:	64a2                	ld	s1,8(sp)
  8002be:	6105                	addi	sp,sp,32
  8002c0:	8082                	ret
  8002c2:	8526                	mv	a0,s1
  8002c4:	d63ff0ef          	jal	ra,800026 <close>
  8002c8:	85a6                	mv	a1,s1
  8002ca:	8522                	mv	a0,s0
  8002cc:	d61ff0ef          	jal	ra,80002c <dup2>
  8002d0:	84aa                	mv	s1,a0
  8002d2:	8522                	mv	a0,s0
  8002d4:	d53ff0ef          	jal	ra,800026 <close>
  8002d8:	8426                	mv	s0,s1
  8002da:	bff1                	j	8002b6 <initfd+0x1e>

00000000008002dc <umain>:
  8002dc:	1101                	addi	sp,sp,-32
  8002de:	e822                	sd	s0,16(sp)
  8002e0:	e426                	sd	s1,8(sp)
  8002e2:	842a                	mv	s0,a0
  8002e4:	84ae                	mv	s1,a1
  8002e6:	4601                	li	a2,0
  8002e8:	00001597          	auipc	a1,0x1
  8002ec:	ad058593          	addi	a1,a1,-1328 # 800db8 <main+0x126>
  8002f0:	4501                	li	a0,0
  8002f2:	ec06                	sd	ra,24(sp)
  8002f4:	fa5ff0ef          	jal	ra,800298 <initfd>
  8002f8:	02054263          	bltz	a0,80031c <umain+0x40>
  8002fc:	4605                	li	a2,1
  8002fe:	00001597          	auipc	a1,0x1
  800302:	afa58593          	addi	a1,a1,-1286 # 800df8 <main+0x166>
  800306:	4505                	li	a0,1
  800308:	f91ff0ef          	jal	ra,800298 <initfd>
  80030c:	02054563          	bltz	a0,800336 <umain+0x5a>
  800310:	85a6                	mv	a1,s1
  800312:	8522                	mv	a0,s0
  800314:	17f000ef          	jal	ra,800c92 <main>
  800318:	f4dff0ef          	jal	ra,800264 <exit>
  80031c:	86aa                	mv	a3,a0
  80031e:	00001617          	auipc	a2,0x1
  800322:	aa260613          	addi	a2,a2,-1374 # 800dc0 <main+0x12e>
  800326:	45e9                	li	a1,26
  800328:	00001517          	auipc	a0,0x1
  80032c:	ab850513          	addi	a0,a0,-1352 # 800de0 <main+0x14e>
  800330:	d47ff0ef          	jal	ra,800076 <__warn>
  800334:	b7e1                	j	8002fc <umain+0x20>
  800336:	86aa                	mv	a3,a0
  800338:	00001617          	auipc	a2,0x1
  80033c:	ac860613          	addi	a2,a2,-1336 # 800e00 <main+0x16e>
  800340:	45f5                	li	a1,29
  800342:	00001517          	auipc	a0,0x1
  800346:	a9e50513          	addi	a0,a0,-1378 # 800de0 <main+0x14e>
  80034a:	d2dff0ef          	jal	ra,800076 <__warn>
  80034e:	b7c9                	j	800310 <umain+0x34>

0000000000800350 <printnum>:
  800350:	02071893          	slli	a7,a4,0x20
  800354:	7139                	addi	sp,sp,-64
  800356:	0208d893          	srli	a7,a7,0x20
  80035a:	e456                	sd	s5,8(sp)
  80035c:	0316fab3          	remu	s5,a3,a7
  800360:	f822                	sd	s0,48(sp)
  800362:	f426                	sd	s1,40(sp)
  800364:	f04a                	sd	s2,32(sp)
  800366:	ec4e                	sd	s3,24(sp)
  800368:	fc06                	sd	ra,56(sp)
  80036a:	e852                	sd	s4,16(sp)
  80036c:	84aa                	mv	s1,a0
  80036e:	89ae                	mv	s3,a1
  800370:	8932                	mv	s2,a2
  800372:	fff7841b          	addiw	s0,a5,-1
  800376:	2a81                	sext.w	s5,s5
  800378:	0516f163          	bgeu	a3,a7,8003ba <printnum+0x6a>
  80037c:	8a42                	mv	s4,a6
  80037e:	00805863          	blez	s0,80038e <printnum+0x3e>
  800382:	347d                	addiw	s0,s0,-1
  800384:	864e                	mv	a2,s3
  800386:	85ca                	mv	a1,s2
  800388:	8552                	mv	a0,s4
  80038a:	9482                	jalr	s1
  80038c:	f87d                	bnez	s0,800382 <printnum+0x32>
  80038e:	1a82                	slli	s5,s5,0x20
  800390:	00001797          	auipc	a5,0x1
  800394:	a9078793          	addi	a5,a5,-1392 # 800e20 <main+0x18e>
  800398:	020ada93          	srli	s5,s5,0x20
  80039c:	9abe                	add	s5,s5,a5
  80039e:	7442                	ld	s0,48(sp)
  8003a0:	000ac503          	lbu	a0,0(s5)
  8003a4:	70e2                	ld	ra,56(sp)
  8003a6:	6a42                	ld	s4,16(sp)
  8003a8:	6aa2                	ld	s5,8(sp)
  8003aa:	864e                	mv	a2,s3
  8003ac:	85ca                	mv	a1,s2
  8003ae:	69e2                	ld	s3,24(sp)
  8003b0:	7902                	ld	s2,32(sp)
  8003b2:	87a6                	mv	a5,s1
  8003b4:	74a2                	ld	s1,40(sp)
  8003b6:	6121                	addi	sp,sp,64
  8003b8:	8782                	jr	a5
  8003ba:	0316d6b3          	divu	a3,a3,a7
  8003be:	87a2                	mv	a5,s0
  8003c0:	f91ff0ef          	jal	ra,800350 <printnum>
  8003c4:	b7e9                	j	80038e <printnum+0x3e>

00000000008003c6 <sprintputch>:
  8003c6:	499c                	lw	a5,16(a1)
  8003c8:	6198                	ld	a4,0(a1)
  8003ca:	6594                	ld	a3,8(a1)
  8003cc:	2785                	addiw	a5,a5,1
  8003ce:	c99c                	sw	a5,16(a1)
  8003d0:	00d77763          	bgeu	a4,a3,8003de <sprintputch+0x18>
  8003d4:	00170793          	addi	a5,a4,1
  8003d8:	e19c                	sd	a5,0(a1)
  8003da:	00a70023          	sb	a0,0(a4)
  8003de:	8082                	ret

00000000008003e0 <vprintfmt>:
  8003e0:	7119                	addi	sp,sp,-128
  8003e2:	f4a6                	sd	s1,104(sp)
  8003e4:	f0ca                	sd	s2,96(sp)
  8003e6:	ecce                	sd	s3,88(sp)
  8003e8:	e8d2                	sd	s4,80(sp)
  8003ea:	e4d6                	sd	s5,72(sp)
  8003ec:	e0da                	sd	s6,64(sp)
  8003ee:	fc5e                	sd	s7,56(sp)
  8003f0:	ec6e                	sd	s11,24(sp)
  8003f2:	fc86                	sd	ra,120(sp)
  8003f4:	f8a2                	sd	s0,112(sp)
  8003f6:	f862                	sd	s8,48(sp)
  8003f8:	f466                	sd	s9,40(sp)
  8003fa:	f06a                	sd	s10,32(sp)
  8003fc:	89aa                	mv	s3,a0
  8003fe:	892e                	mv	s2,a1
  800400:	84b2                	mv	s1,a2
  800402:	8db6                	mv	s11,a3
  800404:	8aba                	mv	s5,a4
  800406:	02500a13          	li	s4,37
  80040a:	5bfd                	li	s7,-1
  80040c:	00001b17          	auipc	s6,0x1
  800410:	a48b0b13          	addi	s6,s6,-1464 # 800e54 <main+0x1c2>
  800414:	000dc503          	lbu	a0,0(s11)
  800418:	001d8413          	addi	s0,s11,1
  80041c:	01450b63          	beq	a0,s4,800432 <vprintfmt+0x52>
  800420:	c129                	beqz	a0,800462 <vprintfmt+0x82>
  800422:	864a                	mv	a2,s2
  800424:	85a6                	mv	a1,s1
  800426:	0405                	addi	s0,s0,1
  800428:	9982                	jalr	s3
  80042a:	fff44503          	lbu	a0,-1(s0)
  80042e:	ff4519e3          	bne	a0,s4,800420 <vprintfmt+0x40>
  800432:	00044583          	lbu	a1,0(s0)
  800436:	02000813          	li	a6,32
  80043a:	4d01                	li	s10,0
  80043c:	4301                	li	t1,0
  80043e:	5cfd                	li	s9,-1
  800440:	5c7d                	li	s8,-1
  800442:	05500513          	li	a0,85
  800446:	48a5                	li	a7,9
  800448:	fdd5861b          	addiw	a2,a1,-35
  80044c:	0ff67613          	zext.b	a2,a2
  800450:	00140d93          	addi	s11,s0,1
  800454:	04c56263          	bltu	a0,a2,800498 <vprintfmt+0xb8>
  800458:	060a                	slli	a2,a2,0x2
  80045a:	965a                	add	a2,a2,s6
  80045c:	4214                	lw	a3,0(a2)
  80045e:	96da                	add	a3,a3,s6
  800460:	8682                	jr	a3
  800462:	70e6                	ld	ra,120(sp)
  800464:	7446                	ld	s0,112(sp)
  800466:	74a6                	ld	s1,104(sp)
  800468:	7906                	ld	s2,96(sp)
  80046a:	69e6                	ld	s3,88(sp)
  80046c:	6a46                	ld	s4,80(sp)
  80046e:	6aa6                	ld	s5,72(sp)
  800470:	6b06                	ld	s6,64(sp)
  800472:	7be2                	ld	s7,56(sp)
  800474:	7c42                	ld	s8,48(sp)
  800476:	7ca2                	ld	s9,40(sp)
  800478:	7d02                	ld	s10,32(sp)
  80047a:	6de2                	ld	s11,24(sp)
  80047c:	6109                	addi	sp,sp,128
  80047e:	8082                	ret
  800480:	882e                	mv	a6,a1
  800482:	00144583          	lbu	a1,1(s0)
  800486:	846e                	mv	s0,s11
  800488:	00140d93          	addi	s11,s0,1
  80048c:	fdd5861b          	addiw	a2,a1,-35
  800490:	0ff67613          	zext.b	a2,a2
  800494:	fcc572e3          	bgeu	a0,a2,800458 <vprintfmt+0x78>
  800498:	864a                	mv	a2,s2
  80049a:	85a6                	mv	a1,s1
  80049c:	02500513          	li	a0,37
  8004a0:	9982                	jalr	s3
  8004a2:	fff44783          	lbu	a5,-1(s0)
  8004a6:	8da2                	mv	s11,s0
  8004a8:	f74786e3          	beq	a5,s4,800414 <vprintfmt+0x34>
  8004ac:	ffedc783          	lbu	a5,-2(s11)
  8004b0:	1dfd                	addi	s11,s11,-1
  8004b2:	ff479de3          	bne	a5,s4,8004ac <vprintfmt+0xcc>
  8004b6:	bfb9                	j	800414 <vprintfmt+0x34>
  8004b8:	fd058c9b          	addiw	s9,a1,-48
  8004bc:	00144583          	lbu	a1,1(s0)
  8004c0:	846e                	mv	s0,s11
  8004c2:	fd05869b          	addiw	a3,a1,-48
  8004c6:	0005861b          	sext.w	a2,a1
  8004ca:	02d8e463          	bltu	a7,a3,8004f2 <vprintfmt+0x112>
  8004ce:	00144583          	lbu	a1,1(s0)
  8004d2:	002c969b          	slliw	a3,s9,0x2
  8004d6:	0196873b          	addw	a4,a3,s9
  8004da:	0017171b          	slliw	a4,a4,0x1
  8004de:	9f31                	addw	a4,a4,a2
  8004e0:	fd05869b          	addiw	a3,a1,-48
  8004e4:	0405                	addi	s0,s0,1
  8004e6:	fd070c9b          	addiw	s9,a4,-48
  8004ea:	0005861b          	sext.w	a2,a1
  8004ee:	fed8f0e3          	bgeu	a7,a3,8004ce <vprintfmt+0xee>
  8004f2:	f40c5be3          	bgez	s8,800448 <vprintfmt+0x68>
  8004f6:	8c66                	mv	s8,s9
  8004f8:	5cfd                	li	s9,-1
  8004fa:	b7b9                	j	800448 <vprintfmt+0x68>
  8004fc:	fffc4693          	not	a3,s8
  800500:	96fd                	srai	a3,a3,0x3f
  800502:	00dc77b3          	and	a5,s8,a3
  800506:	00144583          	lbu	a1,1(s0)
  80050a:	00078c1b          	sext.w	s8,a5
  80050e:	846e                	mv	s0,s11
  800510:	bf25                	j	800448 <vprintfmt+0x68>
  800512:	000aac83          	lw	s9,0(s5)
  800516:	00144583          	lbu	a1,1(s0)
  80051a:	0aa1                	addi	s5,s5,8
  80051c:	846e                	mv	s0,s11
  80051e:	bfd1                	j	8004f2 <vprintfmt+0x112>
  800520:	4705                	li	a4,1
  800522:	008a8613          	addi	a2,s5,8
  800526:	00674463          	blt	a4,t1,80052e <vprintfmt+0x14e>
  80052a:	1c030c63          	beqz	t1,800702 <vprintfmt+0x322>
  80052e:	000ab683          	ld	a3,0(s5)
  800532:	4741                	li	a4,16
  800534:	8ab2                	mv	s5,a2
  800536:	2801                	sext.w	a6,a6
  800538:	87e2                	mv	a5,s8
  80053a:	8626                	mv	a2,s1
  80053c:	85ca                	mv	a1,s2
  80053e:	854e                	mv	a0,s3
  800540:	e11ff0ef          	jal	ra,800350 <printnum>
  800544:	bdc1                	j	800414 <vprintfmt+0x34>
  800546:	000aa503          	lw	a0,0(s5)
  80054a:	864a                	mv	a2,s2
  80054c:	85a6                	mv	a1,s1
  80054e:	0aa1                	addi	s5,s5,8
  800550:	9982                	jalr	s3
  800552:	b5c9                	j	800414 <vprintfmt+0x34>
  800554:	4705                	li	a4,1
  800556:	008a8613          	addi	a2,s5,8
  80055a:	00674463          	blt	a4,t1,800562 <vprintfmt+0x182>
  80055e:	18030d63          	beqz	t1,8006f8 <vprintfmt+0x318>
  800562:	000ab683          	ld	a3,0(s5)
  800566:	4729                	li	a4,10
  800568:	8ab2                	mv	s5,a2
  80056a:	b7f1                	j	800536 <vprintfmt+0x156>
  80056c:	00144583          	lbu	a1,1(s0)
  800570:	4d05                	li	s10,1
  800572:	846e                	mv	s0,s11
  800574:	bdd1                	j	800448 <vprintfmt+0x68>
  800576:	864a                	mv	a2,s2
  800578:	85a6                	mv	a1,s1
  80057a:	02500513          	li	a0,37
  80057e:	9982                	jalr	s3
  800580:	bd51                	j	800414 <vprintfmt+0x34>
  800582:	00144583          	lbu	a1,1(s0)
  800586:	2305                	addiw	t1,t1,1
  800588:	846e                	mv	s0,s11
  80058a:	bd7d                	j	800448 <vprintfmt+0x68>
  80058c:	4705                	li	a4,1
  80058e:	008a8613          	addi	a2,s5,8
  800592:	00674463          	blt	a4,t1,80059a <vprintfmt+0x1ba>
  800596:	14030c63          	beqz	t1,8006ee <vprintfmt+0x30e>
  80059a:	000ab683          	ld	a3,0(s5)
  80059e:	4721                	li	a4,8
  8005a0:	8ab2                	mv	s5,a2
  8005a2:	bf51                	j	800536 <vprintfmt+0x156>
  8005a4:	03000513          	li	a0,48
  8005a8:	864a                	mv	a2,s2
  8005aa:	85a6                	mv	a1,s1
  8005ac:	e042                	sd	a6,0(sp)
  8005ae:	9982                	jalr	s3
  8005b0:	864a                	mv	a2,s2
  8005b2:	85a6                	mv	a1,s1
  8005b4:	07800513          	li	a0,120
  8005b8:	9982                	jalr	s3
  8005ba:	0aa1                	addi	s5,s5,8
  8005bc:	6802                	ld	a6,0(sp)
  8005be:	4741                	li	a4,16
  8005c0:	ff8ab683          	ld	a3,-8(s5)
  8005c4:	bf8d                	j	800536 <vprintfmt+0x156>
  8005c6:	000ab403          	ld	s0,0(s5)
  8005ca:	008a8793          	addi	a5,s5,8
  8005ce:	e03e                	sd	a5,0(sp)
  8005d0:	14040c63          	beqz	s0,800728 <vprintfmt+0x348>
  8005d4:	11805063          	blez	s8,8006d4 <vprintfmt+0x2f4>
  8005d8:	02d00693          	li	a3,45
  8005dc:	0cd81963          	bne	a6,a3,8006ae <vprintfmt+0x2ce>
  8005e0:	00044683          	lbu	a3,0(s0)
  8005e4:	0006851b          	sext.w	a0,a3
  8005e8:	ce8d                	beqz	a3,800622 <vprintfmt+0x242>
  8005ea:	00140a93          	addi	s5,s0,1
  8005ee:	05e00413          	li	s0,94
  8005f2:	000cc563          	bltz	s9,8005fc <vprintfmt+0x21c>
  8005f6:	3cfd                	addiw	s9,s9,-1
  8005f8:	037c8363          	beq	s9,s7,80061e <vprintfmt+0x23e>
  8005fc:	864a                	mv	a2,s2
  8005fe:	85a6                	mv	a1,s1
  800600:	100d0663          	beqz	s10,80070c <vprintfmt+0x32c>
  800604:	3681                	addiw	a3,a3,-32
  800606:	10d47363          	bgeu	s0,a3,80070c <vprintfmt+0x32c>
  80060a:	03f00513          	li	a0,63
  80060e:	9982                	jalr	s3
  800610:	000ac683          	lbu	a3,0(s5)
  800614:	3c7d                	addiw	s8,s8,-1
  800616:	0a85                	addi	s5,s5,1
  800618:	0006851b          	sext.w	a0,a3
  80061c:	faf9                	bnez	a3,8005f2 <vprintfmt+0x212>
  80061e:	01805a63          	blez	s8,800632 <vprintfmt+0x252>
  800622:	3c7d                	addiw	s8,s8,-1
  800624:	864a                	mv	a2,s2
  800626:	85a6                	mv	a1,s1
  800628:	02000513          	li	a0,32
  80062c:	9982                	jalr	s3
  80062e:	fe0c1ae3          	bnez	s8,800622 <vprintfmt+0x242>
  800632:	6a82                	ld	s5,0(sp)
  800634:	b3c5                	j	800414 <vprintfmt+0x34>
  800636:	4705                	li	a4,1
  800638:	008a8d13          	addi	s10,s5,8
  80063c:	00674463          	blt	a4,t1,800644 <vprintfmt+0x264>
  800640:	0a030463          	beqz	t1,8006e8 <vprintfmt+0x308>
  800644:	000ab403          	ld	s0,0(s5)
  800648:	0c044463          	bltz	s0,800710 <vprintfmt+0x330>
  80064c:	86a2                	mv	a3,s0
  80064e:	8aea                	mv	s5,s10
  800650:	4729                	li	a4,10
  800652:	b5d5                	j	800536 <vprintfmt+0x156>
  800654:	000aa783          	lw	a5,0(s5)
  800658:	46e1                	li	a3,24
  80065a:	0aa1                	addi	s5,s5,8
  80065c:	41f7d71b          	sraiw	a4,a5,0x1f
  800660:	8fb9                	xor	a5,a5,a4
  800662:	40e7873b          	subw	a4,a5,a4
  800666:	02e6c663          	blt	a3,a4,800692 <vprintfmt+0x2b2>
  80066a:	00371793          	slli	a5,a4,0x3
  80066e:	00001697          	auipc	a3,0x1
  800672:	b1a68693          	addi	a3,a3,-1254 # 801188 <error_string>
  800676:	97b6                	add	a5,a5,a3
  800678:	639c                	ld	a5,0(a5)
  80067a:	cf81                	beqz	a5,800692 <vprintfmt+0x2b2>
  80067c:	873e                	mv	a4,a5
  80067e:	00000697          	auipc	a3,0x0
  800682:	7d268693          	addi	a3,a3,2002 # 800e50 <main+0x1be>
  800686:	8626                	mv	a2,s1
  800688:	85ca                	mv	a1,s2
  80068a:	854e                	mv	a0,s3
  80068c:	0d4000ef          	jal	ra,800760 <printfmt>
  800690:	b351                	j	800414 <vprintfmt+0x34>
  800692:	00000697          	auipc	a3,0x0
  800696:	7ae68693          	addi	a3,a3,1966 # 800e40 <main+0x1ae>
  80069a:	8626                	mv	a2,s1
  80069c:	85ca                	mv	a1,s2
  80069e:	854e                	mv	a0,s3
  8006a0:	0c0000ef          	jal	ra,800760 <printfmt>
  8006a4:	bb85                	j	800414 <vprintfmt+0x34>
  8006a6:	00000417          	auipc	s0,0x0
  8006aa:	79240413          	addi	s0,s0,1938 # 800e38 <main+0x1a6>
  8006ae:	85e6                	mv	a1,s9
  8006b0:	8522                	mv	a0,s0
  8006b2:	e442                	sd	a6,8(sp)
  8006b4:	118000ef          	jal	ra,8007cc <strnlen>
  8006b8:	40ac0c3b          	subw	s8,s8,a0
  8006bc:	01805c63          	blez	s8,8006d4 <vprintfmt+0x2f4>
  8006c0:	6822                	ld	a6,8(sp)
  8006c2:	00080a9b          	sext.w	s5,a6
  8006c6:	3c7d                	addiw	s8,s8,-1
  8006c8:	864a                	mv	a2,s2
  8006ca:	85a6                	mv	a1,s1
  8006cc:	8556                	mv	a0,s5
  8006ce:	9982                	jalr	s3
  8006d0:	fe0c1be3          	bnez	s8,8006c6 <vprintfmt+0x2e6>
  8006d4:	00044683          	lbu	a3,0(s0)
  8006d8:	00140a93          	addi	s5,s0,1
  8006dc:	0006851b          	sext.w	a0,a3
  8006e0:	daa9                	beqz	a3,800632 <vprintfmt+0x252>
  8006e2:	05e00413          	li	s0,94
  8006e6:	b731                	j	8005f2 <vprintfmt+0x212>
  8006e8:	000aa403          	lw	s0,0(s5)
  8006ec:	bfb1                	j	800648 <vprintfmt+0x268>
  8006ee:	000ae683          	lwu	a3,0(s5)
  8006f2:	4721                	li	a4,8
  8006f4:	8ab2                	mv	s5,a2
  8006f6:	b581                	j	800536 <vprintfmt+0x156>
  8006f8:	000ae683          	lwu	a3,0(s5)
  8006fc:	4729                	li	a4,10
  8006fe:	8ab2                	mv	s5,a2
  800700:	bd1d                	j	800536 <vprintfmt+0x156>
  800702:	000ae683          	lwu	a3,0(s5)
  800706:	4741                	li	a4,16
  800708:	8ab2                	mv	s5,a2
  80070a:	b535                	j	800536 <vprintfmt+0x156>
  80070c:	9982                	jalr	s3
  80070e:	b709                	j	800610 <vprintfmt+0x230>
  800710:	864a                	mv	a2,s2
  800712:	85a6                	mv	a1,s1
  800714:	02d00513          	li	a0,45
  800718:	e042                	sd	a6,0(sp)
  80071a:	9982                	jalr	s3
  80071c:	6802                	ld	a6,0(sp)
  80071e:	8aea                	mv	s5,s10
  800720:	408006b3          	neg	a3,s0
  800724:	4729                	li	a4,10
  800726:	bd01                	j	800536 <vprintfmt+0x156>
  800728:	03805163          	blez	s8,80074a <vprintfmt+0x36a>
  80072c:	02d00693          	li	a3,45
  800730:	f6d81be3          	bne	a6,a3,8006a6 <vprintfmt+0x2c6>
  800734:	00000417          	auipc	s0,0x0
  800738:	70440413          	addi	s0,s0,1796 # 800e38 <main+0x1a6>
  80073c:	02800693          	li	a3,40
  800740:	02800513          	li	a0,40
  800744:	00140a93          	addi	s5,s0,1
  800748:	b55d                	j	8005ee <vprintfmt+0x20e>
  80074a:	00000a97          	auipc	s5,0x0
  80074e:	6efa8a93          	addi	s5,s5,1775 # 800e39 <main+0x1a7>
  800752:	02800513          	li	a0,40
  800756:	02800693          	li	a3,40
  80075a:	05e00413          	li	s0,94
  80075e:	bd51                	j	8005f2 <vprintfmt+0x212>

0000000000800760 <printfmt>:
  800760:	7139                	addi	sp,sp,-64
  800762:	02010313          	addi	t1,sp,32
  800766:	f03a                	sd	a4,32(sp)
  800768:	871a                	mv	a4,t1
  80076a:	ec06                	sd	ra,24(sp)
  80076c:	f43e                	sd	a5,40(sp)
  80076e:	f842                	sd	a6,48(sp)
  800770:	fc46                	sd	a7,56(sp)
  800772:	e41a                	sd	t1,8(sp)
  800774:	c6dff0ef          	jal	ra,8003e0 <vprintfmt>
  800778:	60e2                	ld	ra,24(sp)
  80077a:	6121                	addi	sp,sp,64
  80077c:	8082                	ret

000000000080077e <snprintf>:
  80077e:	711d                	addi	sp,sp,-96
  800780:	15fd                	addi	a1,a1,-1
  800782:	03810313          	addi	t1,sp,56
  800786:	95aa                	add	a1,a1,a0
  800788:	f406                	sd	ra,40(sp)
  80078a:	fc36                	sd	a3,56(sp)
  80078c:	e0ba                	sd	a4,64(sp)
  80078e:	e4be                	sd	a5,72(sp)
  800790:	e8c2                	sd	a6,80(sp)
  800792:	ecc6                	sd	a7,88(sp)
  800794:	e01a                	sd	t1,0(sp)
  800796:	e42a                	sd	a0,8(sp)
  800798:	e82e                	sd	a1,16(sp)
  80079a:	cc02                	sw	zero,24(sp)
  80079c:	c515                	beqz	a0,8007c8 <snprintf+0x4a>
  80079e:	02a5e563          	bltu	a1,a0,8007c8 <snprintf+0x4a>
  8007a2:	75dd                	lui	a1,0xffff7
  8007a4:	86b2                	mv	a3,a2
  8007a6:	00000517          	auipc	a0,0x0
  8007aa:	c2050513          	addi	a0,a0,-992 # 8003c6 <sprintputch>
  8007ae:	871a                	mv	a4,t1
  8007b0:	0030                	addi	a2,sp,8
  8007b2:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  8007b6:	c2bff0ef          	jal	ra,8003e0 <vprintfmt>
  8007ba:	67a2                	ld	a5,8(sp)
  8007bc:	00078023          	sb	zero,0(a5)
  8007c0:	4562                	lw	a0,24(sp)
  8007c2:	70a2                	ld	ra,40(sp)
  8007c4:	6125                	addi	sp,sp,96
  8007c6:	8082                	ret
  8007c8:	5575                	li	a0,-3
  8007ca:	bfe5                	j	8007c2 <snprintf+0x44>

00000000008007cc <strnlen>:
  8007cc:	4781                	li	a5,0
  8007ce:	e589                	bnez	a1,8007d8 <strnlen+0xc>
  8007d0:	a811                	j	8007e4 <strnlen+0x18>
  8007d2:	0785                	addi	a5,a5,1
  8007d4:	00f58863          	beq	a1,a5,8007e4 <strnlen+0x18>
  8007d8:	00f50733          	add	a4,a0,a5
  8007dc:	00074703          	lbu	a4,0(a4)
  8007e0:	fb6d                	bnez	a4,8007d2 <strnlen+0x6>
  8007e2:	85be                	mv	a1,a5
  8007e4:	852e                	mv	a0,a1
  8007e6:	8082                	ret

00000000008007e8 <strcpy>:
  8007e8:	87aa                	mv	a5,a0
  8007ea:	0005c703          	lbu	a4,0(a1)
  8007ee:	0785                	addi	a5,a5,1
  8007f0:	0585                	addi	a1,a1,1
  8007f2:	fee78fa3          	sb	a4,-1(a5)
  8007f6:	fb75                	bnez	a4,8007ea <strcpy+0x2>
  8007f8:	8082                	ret

00000000008007fa <strcmp>:
  8007fa:	00054783          	lbu	a5,0(a0)
  8007fe:	0005c703          	lbu	a4,0(a1)
  800802:	cb89                	beqz	a5,800814 <strcmp+0x1a>
  800804:	0505                	addi	a0,a0,1
  800806:	0585                	addi	a1,a1,1
  800808:	fee789e3          	beq	a5,a4,8007fa <strcmp>
  80080c:	0007851b          	sext.w	a0,a5
  800810:	9d19                	subw	a0,a0,a4
  800812:	8082                	ret
  800814:	4501                	li	a0,0
  800816:	bfed                	j	800810 <strcmp+0x16>

0000000000800818 <strchr>:
  800818:	00054783          	lbu	a5,0(a0)
  80081c:	c799                	beqz	a5,80082a <strchr+0x12>
  80081e:	00f58763          	beq	a1,a5,80082c <strchr+0x14>
  800822:	00154783          	lbu	a5,1(a0)
  800826:	0505                	addi	a0,a0,1
  800828:	fbfd                	bnez	a5,80081e <strchr+0x6>
  80082a:	4501                	li	a0,0
  80082c:	8082                	ret

000000000080082e <gettoken>:
  80082e:	7139                	addi	sp,sp,-64
  800830:	f822                	sd	s0,48(sp)
  800832:	6100                	ld	s0,0(a0)
  800834:	fc06                	sd	ra,56(sp)
  800836:	f426                	sd	s1,40(sp)
  800838:	f04a                	sd	s2,32(sp)
  80083a:	ec4e                	sd	s3,24(sp)
  80083c:	e852                	sd	s4,16(sp)
  80083e:	e456                	sd	s5,8(sp)
  800840:	e05a                	sd	s6,0(sp)
  800842:	c405                	beqz	s0,80086a <gettoken+0x3c>
  800844:	892a                	mv	s2,a0
  800846:	89ae                	mv	s3,a1
  800848:	00001497          	auipc	s1,0x1
  80084c:	a0848493          	addi	s1,s1,-1528 # 801250 <error_string+0xc8>
  800850:	a021                	j	800858 <gettoken+0x2a>
  800852:	0405                	addi	s0,s0,1
  800854:	fe040fa3          	sb	zero,-1(s0)
  800858:	00044583          	lbu	a1,0(s0)
  80085c:	8526                	mv	a0,s1
  80085e:	fbbff0ef          	jal	ra,800818 <strchr>
  800862:	f965                	bnez	a0,800852 <gettoken+0x24>
  800864:	00044783          	lbu	a5,0(s0)
  800868:	ef81                	bnez	a5,800880 <gettoken+0x52>
  80086a:	4501                	li	a0,0
  80086c:	70e2                	ld	ra,56(sp)
  80086e:	7442                	ld	s0,48(sp)
  800870:	74a2                	ld	s1,40(sp)
  800872:	7902                	ld	s2,32(sp)
  800874:	69e2                	ld	s3,24(sp)
  800876:	6a42                	ld	s4,16(sp)
  800878:	6aa2                	ld	s5,8(sp)
  80087a:	6b02                	ld	s6,0(sp)
  80087c:	6121                	addi	sp,sp,64
  80087e:	8082                	ret
  800880:	0089b023          	sd	s0,0(s3)
  800884:	00044583          	lbu	a1,0(s0)
  800888:	00001517          	auipc	a0,0x1
  80088c:	9d050513          	addi	a0,a0,-1584 # 801258 <error_string+0xd0>
  800890:	f89ff0ef          	jal	ra,800818 <strchr>
  800894:	84aa                	mv	s1,a0
  800896:	c10d                	beqz	a0,8008b8 <gettoken+0x8a>
  800898:	00044503          	lbu	a0,0(s0)
  80089c:	00140493          	addi	s1,s0,1
  8008a0:	00040023          	sb	zero,0(s0)
  8008a4:	0004c783          	lbu	a5,0(s1)
  8008a8:	00f037b3          	snez	a5,a5
  8008ac:	40f007b3          	neg	a5,a5
  8008b0:	8cfd                	and	s1,s1,a5
  8008b2:	00993023          	sd	s1,0(s2)
  8008b6:	bf5d                	j	80086c <gettoken+0x3e>
  8008b8:	00044583          	lbu	a1,0(s0)
  8008bc:	4981                	li	s3,0
  8008be:	00001b17          	auipc	s6,0x1
  8008c2:	9a2b0b13          	addi	s6,s6,-1630 # 801260 <error_string+0xd8>
  8008c6:	02200a13          	li	s4,34
  8008ca:	02000a93          	li	s5,32
  8008ce:	cd99                	beqz	a1,8008ec <gettoken+0xbe>
  8008d0:	02098363          	beqz	s3,8008f6 <gettoken+0xc8>
  8008d4:	00044783          	lbu	a5,0(s0)
  8008d8:	01479663          	bne	a5,s4,8008e4 <gettoken+0xb6>
  8008dc:	01540023          	sb	s5,0(s0)
  8008e0:	0019c993          	xori	s3,s3,1
  8008e4:	00144583          	lbu	a1,1(s0)
  8008e8:	0405                	addi	s0,s0,1
  8008ea:	f1fd                	bnez	a1,8008d0 <gettoken+0xa2>
  8008ec:	07700513          	li	a0,119
  8008f0:	00993023          	sd	s1,0(s2)
  8008f4:	bfa5                	j	80086c <gettoken+0x3e>
  8008f6:	855a                	mv	a0,s6
  8008f8:	f21ff0ef          	jal	ra,800818 <strchr>
  8008fc:	dd61                	beqz	a0,8008d4 <gettoken+0xa6>
  8008fe:	84a2                	mv	s1,s0
  800900:	07700513          	li	a0,119
  800904:	b745                	j	8008a4 <gettoken+0x76>

0000000000800906 <readline>:
  800906:	711d                	addi	sp,sp,-96
  800908:	ec86                	sd	ra,88(sp)
  80090a:	e8a2                	sd	s0,80(sp)
  80090c:	e4a6                	sd	s1,72(sp)
  80090e:	e0ca                	sd	s2,64(sp)
  800910:	fc4e                	sd	s3,56(sp)
  800912:	f852                	sd	s4,48(sp)
  800914:	f456                	sd	s5,40(sp)
  800916:	f05a                	sd	s6,32(sp)
  800918:	ec5e                	sd	s7,24(sp)
  80091a:	c909                	beqz	a0,80092c <readline+0x26>
  80091c:	862a                	mv	a2,a0
  80091e:	00000597          	auipc	a1,0x0
  800922:	53258593          	addi	a1,a1,1330 # 800e50 <main+0x1be>
  800926:	4505                	li	a0,1
  800928:	879ff0ef          	jal	ra,8001a0 <fprintf>
  80092c:	6985                	lui	s3,0x1
  80092e:	4401                	li	s0,0
  800930:	448d                	li	s1,3
  800932:	497d                	li	s2,31
  800934:	4a21                	li	s4,8
  800936:	4aa9                	li	s5,10
  800938:	4b35                	li	s6,13
  80093a:	19f9                	addi	s3,s3,-2
  80093c:	00002b97          	auipc	s7,0x2
  800940:	7ccb8b93          	addi	s7,s7,1996 # 803108 <buffer.2>
  800944:	4605                	li	a2,1
  800946:	00f10593          	addi	a1,sp,15
  80094a:	4501                	li	a0,0
  80094c:	edcff0ef          	jal	ra,800028 <read>
  800950:	04054163          	bltz	a0,800992 <readline+0x8c>
  800954:	c549                	beqz	a0,8009de <readline+0xd8>
  800956:	00f14603          	lbu	a2,15(sp)
  80095a:	02960c63          	beq	a2,s1,800992 <readline+0x8c>
  80095e:	04c97663          	bgeu	s2,a2,8009aa <readline+0xa4>
  800962:	fe89c1e3          	blt	s3,s0,800944 <readline+0x3e>
  800966:	00001597          	auipc	a1,0x1
  80096a:	90a58593          	addi	a1,a1,-1782 # 801270 <error_string+0xe8>
  80096e:	4505                	li	a0,1
  800970:	831ff0ef          	jal	ra,8001a0 <fprintf>
  800974:	00f14703          	lbu	a4,15(sp)
  800978:	008b87b3          	add	a5,s7,s0
  80097c:	4605                	li	a2,1
  80097e:	00e78023          	sb	a4,0(a5)
  800982:	00f10593          	addi	a1,sp,15
  800986:	4501                	li	a0,0
  800988:	2405                	addiw	s0,s0,1
  80098a:	e9eff0ef          	jal	ra,800028 <read>
  80098e:	fc0553e3          	bgez	a0,800954 <readline+0x4e>
  800992:	4501                	li	a0,0
  800994:	60e6                	ld	ra,88(sp)
  800996:	6446                	ld	s0,80(sp)
  800998:	64a6                	ld	s1,72(sp)
  80099a:	6906                	ld	s2,64(sp)
  80099c:	79e2                	ld	s3,56(sp)
  80099e:	7a42                	ld	s4,48(sp)
  8009a0:	7aa2                	ld	s5,40(sp)
  8009a2:	7b02                	ld	s6,32(sp)
  8009a4:	6be2                	ld	s7,24(sp)
  8009a6:	6125                	addi	sp,sp,96
  8009a8:	8082                	ret
  8009aa:	01461d63          	bne	a2,s4,8009c4 <readline+0xbe>
  8009ae:	d859                	beqz	s0,800944 <readline+0x3e>
  8009b0:	4621                	li	a2,8
  8009b2:	00001597          	auipc	a1,0x1
  8009b6:	8be58593          	addi	a1,a1,-1858 # 801270 <error_string+0xe8>
  8009ba:	4505                	li	a0,1
  8009bc:	fe4ff0ef          	jal	ra,8001a0 <fprintf>
  8009c0:	347d                	addiw	s0,s0,-1
  8009c2:	b749                	j	800944 <readline+0x3e>
  8009c4:	03560a63          	beq	a2,s5,8009f8 <readline+0xf2>
  8009c8:	f7661ee3          	bne	a2,s6,800944 <readline+0x3e>
  8009cc:	4635                	li	a2,13
  8009ce:	00001597          	auipc	a1,0x1
  8009d2:	8a258593          	addi	a1,a1,-1886 # 801270 <error_string+0xe8>
  8009d6:	4505                	li	a0,1
  8009d8:	fc8ff0ef          	jal	ra,8001a0 <fprintf>
  8009dc:	a011                	j	8009e0 <readline+0xda>
  8009de:	d855                	beqz	s0,800992 <readline+0x8c>
  8009e0:	00002797          	auipc	a5,0x2
  8009e4:	72878793          	addi	a5,a5,1832 # 803108 <buffer.2>
  8009e8:	97a2                	add	a5,a5,s0
  8009ea:	00078023          	sb	zero,0(a5)
  8009ee:	00002517          	auipc	a0,0x2
  8009f2:	71a50513          	addi	a0,a0,1818 # 803108 <buffer.2>
  8009f6:	bf79                	j	800994 <readline+0x8e>
  8009f8:	4629                	li	a2,10
  8009fa:	bfd1                	j	8009ce <readline+0xc8>

00000000008009fc <reopen>:
  8009fc:	1101                	addi	sp,sp,-32
  8009fe:	ec06                	sd	ra,24(sp)
  800a00:	e822                	sd	s0,16(sp)
  800a02:	e426                	sd	s1,8(sp)
  800a04:	842e                	mv	s0,a1
  800a06:	e04a                	sd	s2,0(sp)
  800a08:	84aa                	mv	s1,a0
  800a0a:	8932                	mv	s2,a2
  800a0c:	e1aff0ef          	jal	ra,800026 <close>
  800a10:	8522                	mv	a0,s0
  800a12:	85ca                	mv	a1,s2
  800a14:	e0cff0ef          	jal	ra,800020 <open>
  800a18:	842a                	mv	s0,a0
  800a1a:	00054463          	bltz	a0,800a22 <reopen+0x26>
  800a1e:	00a49e63          	bne	s1,a0,800a3a <reopen+0x3e>
  800a22:	00142513          	slti	a0,s0,1
  800a26:	40a0053b          	negw	a0,a0
  800a2a:	60e2                	ld	ra,24(sp)
  800a2c:	8d61                	and	a0,a0,s0
  800a2e:	6442                	ld	s0,16(sp)
  800a30:	64a2                	ld	s1,8(sp)
  800a32:	6902                	ld	s2,0(sp)
  800a34:	2501                	sext.w	a0,a0
  800a36:	6105                	addi	sp,sp,32
  800a38:	8082                	ret
  800a3a:	8526                	mv	a0,s1
  800a3c:	deaff0ef          	jal	ra,800026 <close>
  800a40:	85a6                	mv	a1,s1
  800a42:	8522                	mv	a0,s0
  800a44:	de8ff0ef          	jal	ra,80002c <dup2>
  800a48:	84aa                	mv	s1,a0
  800a4a:	8522                	mv	a0,s0
  800a4c:	ddaff0ef          	jal	ra,800026 <close>
  800a50:	8426                	mv	s0,s1
  800a52:	bfc1                	j	800a22 <reopen+0x26>

0000000000800a54 <runcmd>:
  800a54:	7159                	addi	sp,sp,-112
  800a56:	e8ca                	sd	s2,80(sp)
  800a58:	e0d2                	sd	s4,64(sp)
  800a5a:	f85a                	sd	s6,48(sp)
  800a5c:	f45e                	sd	s7,40(sp)
  800a5e:	f486                	sd	ra,104(sp)
  800a60:	f0a2                	sd	s0,96(sp)
  800a62:	eca6                	sd	s1,88(sp)
  800a64:	e4ce                	sd	s3,72(sp)
  800a66:	fc56                	sd	s5,56(sp)
  800a68:	f062                	sd	s8,32(sp)
  800a6a:	e42a                	sd	a0,8(sp)
  800a6c:	07700913          	li	s2,119
  800a70:	02000b13          	li	s6,32
  800a74:	00001b97          	auipc	s7,0x1
  800a78:	58cb8b93          	addi	s7,s7,1420 # 802000 <argv.1>
  800a7c:	03b00a13          	li	s4,59
  800a80:	4401                	li	s0,0
  800a82:	03e00493          	li	s1,62
  800a86:	03c00993          	li	s3,60
  800a8a:	082c                	addi	a1,sp,24
  800a8c:	0028                	addi	a0,sp,8
  800a8e:	da1ff0ef          	jal	ra,80082e <gettoken>
  800a92:	0e950e63          	beq	a0,s1,800b8e <runcmd+0x13a>
  800a96:	04a4c763          	blt	s1,a0,800ae4 <runcmd+0x90>
  800a9a:	0f450063          	beq	a0,s4,800b7a <runcmd+0x126>
  800a9e:	07351e63          	bne	a0,s3,800b1a <runcmd+0xc6>
  800aa2:	082c                	addi	a1,sp,24
  800aa4:	0028                	addi	a0,sp,8
  800aa6:	d89ff0ef          	jal	ra,80082e <gettoken>
  800aaa:	19251463          	bne	a0,s2,800c32 <runcmd+0x1de>
  800aae:	6ae2                	ld	s5,24(sp)
  800ab0:	4501                	li	a0,0
  800ab2:	d74ff0ef          	jal	ra,800026 <close>
  800ab6:	8556                	mv	a0,s5
  800ab8:	4581                	li	a1,0
  800aba:	d66ff0ef          	jal	ra,800020 <open>
  800abe:	8aaa                	mv	s5,a0
  800ac0:	10054963          	bltz	a0,800bd2 <runcmd+0x17e>
  800ac4:	d179                	beqz	a0,800a8a <runcmd+0x36>
  800ac6:	4501                	li	a0,0
  800ac8:	d5eff0ef          	jal	ra,800026 <close>
  800acc:	4581                	li	a1,0
  800ace:	8556                	mv	a0,s5
  800ad0:	d5cff0ef          	jal	ra,80002c <dup2>
  800ad4:	8c2a                	mv	s8,a0
  800ad6:	8556                	mv	a0,s5
  800ad8:	d4eff0ef          	jal	ra,800026 <close>
  800adc:	fa0c57e3          	bgez	s8,800a8a <runcmd+0x36>
  800ae0:	8462                	mv	s0,s8
  800ae2:	a8bd                	j	800b60 <runcmd+0x10c>
  800ae4:	0d250e63          	beq	a0,s2,800bc0 <runcmd+0x16c>
  800ae8:	07c00793          	li	a5,124
  800aec:	06f51163          	bne	a0,a5,800b4e <runcmd+0xfa>
  800af0:	f8aff0ef          	jal	ra,80027a <fork>
  800af4:	87aa                	mv	a5,a0
  800af6:	14051763          	bnez	a0,800c44 <runcmd+0x1f0>
  800afa:	d2cff0ef          	jal	ra,800026 <close>
  800afe:	4581                	li	a1,0
  800b00:	4501                	li	a0,0
  800b02:	d2aff0ef          	jal	ra,80002c <dup2>
  800b06:	842a                	mv	s0,a0
  800b08:	04054c63          	bltz	a0,800b60 <runcmd+0x10c>
  800b0c:	4501                	li	a0,0
  800b0e:	d18ff0ef          	jal	ra,800026 <close>
  800b12:	4501                	li	a0,0
  800b14:	d12ff0ef          	jal	ra,800026 <close>
  800b18:	b7a5                	j	800a80 <runcmd+0x2c>
  800b1a:	e915                	bnez	a0,800b4e <runcmd+0xfa>
  800b1c:	c031                	beqz	s0,800b60 <runcmd+0x10c>
  800b1e:	00001497          	auipc	s1,0x1
  800b22:	4e248493          	addi	s1,s1,1250 # 802000 <argv.1>
  800b26:	6088                	ld	a0,0(s1)
  800b28:	00001597          	auipc	a1,0x1
  800b2c:	81858593          	addi	a1,a1,-2024 # 801340 <error_string+0x1b8>
  800b30:	ccbff0ef          	jal	ra,8007fa <strcmp>
  800b34:	e14d                	bnez	a0,800bd6 <runcmd+0x182>
  800b36:	4789                	li	a5,2
  800b38:	12f41963          	bne	s0,a5,800c6a <runcmd+0x216>
  800b3c:	648c                	ld	a1,8(s1)
  800b3e:	00003517          	auipc	a0,0x3
  800b42:	5ca50513          	addi	a0,a0,1482 # 804108 <shcwd>
  800b46:	4401                	li	s0,0
  800b48:	ca1ff0ef          	jal	ra,8007e8 <strcpy>
  800b4c:	a811                	j	800b60 <runcmd+0x10c>
  800b4e:	862a                	mv	a2,a0
  800b50:	00000597          	auipc	a1,0x0
  800b54:	7c858593          	addi	a1,a1,1992 # 801318 <error_string+0x190>
  800b58:	4505                	li	a0,1
  800b5a:	e46ff0ef          	jal	ra,8001a0 <fprintf>
  800b5e:	547d                	li	s0,-1
  800b60:	70a6                	ld	ra,104(sp)
  800b62:	8522                	mv	a0,s0
  800b64:	7406                	ld	s0,96(sp)
  800b66:	64e6                	ld	s1,88(sp)
  800b68:	6946                	ld	s2,80(sp)
  800b6a:	69a6                	ld	s3,72(sp)
  800b6c:	6a06                	ld	s4,64(sp)
  800b6e:	7ae2                	ld	s5,56(sp)
  800b70:	7b42                	ld	s6,48(sp)
  800b72:	7ba2                	ld	s7,40(sp)
  800b74:	7c02                	ld	s8,32(sp)
  800b76:	6165                	addi	sp,sp,112
  800b78:	8082                	ret
  800b7a:	f00ff0ef          	jal	ra,80027a <fork>
  800b7e:	87aa                	mv	a5,a0
  800b80:	dd51                	beqz	a0,800b1c <runcmd+0xc8>
  800b82:	08054463          	bltz	a0,800c0a <runcmd+0x1b6>
  800b86:	4581                	li	a1,0
  800b88:	ef4ff0ef          	jal	ra,80027c <waitpid>
  800b8c:	bdd5                	j	800a80 <runcmd+0x2c>
  800b8e:	082c                	addi	a1,sp,24
  800b90:	0028                	addi	a0,sp,8
  800b92:	c9dff0ef          	jal	ra,80082e <gettoken>
  800b96:	0d251c63          	bne	a0,s2,800c6e <runcmd+0x21a>
  800b9a:	6ae2                	ld	s5,24(sp)
  800b9c:	4505                	li	a0,1
  800b9e:	c88ff0ef          	jal	ra,800026 <close>
  800ba2:	8556                	mv	a0,s5
  800ba4:	45d9                	li	a1,22
  800ba6:	c7aff0ef          	jal	ra,800020 <open>
  800baa:	8aaa                	mv	s5,a0
  800bac:	02054363          	bltz	a0,800bd2 <runcmd+0x17e>
  800bb0:	4785                	li	a5,1
  800bb2:	ecf50ce3          	beq	a0,a5,800a8a <runcmd+0x36>
  800bb6:	4505                	li	a0,1
  800bb8:	c6eff0ef          	jal	ra,800026 <close>
  800bbc:	4585                	li	a1,1
  800bbe:	bf01                	j	800ace <runcmd+0x7a>
  800bc0:	0d640063          	beq	s0,s6,800c80 <runcmd+0x22c>
  800bc4:	6762                	ld	a4,24(sp)
  800bc6:	00341793          	slli	a5,s0,0x3
  800bca:	97de                	add	a5,a5,s7
  800bcc:	e398                	sd	a4,0(a5)
  800bce:	2405                	addiw	s0,s0,1
  800bd0:	bd6d                	j	800a8a <runcmd+0x36>
  800bd2:	8456                	mv	s0,s5
  800bd4:	b771                	j	800b60 <runcmd+0x10c>
  800bd6:	6088                	ld	a0,0(s1)
  800bd8:	4581                	li	a1,0
  800bda:	c46ff0ef          	jal	ra,800020 <open>
  800bde:	87aa                	mv	a5,a0
  800be0:	02054263          	bltz	a0,800c04 <runcmd+0x1b0>
  800be4:	c42ff0ef          	jal	ra,800026 <close>
  800be8:	00341793          	slli	a5,s0,0x3
  800bec:	97a6                	add	a5,a5,s1
  800bee:	0007b023          	sd	zero,0(a5)
  800bf2:	6088                	ld	a0,0(s1)
  800bf4:	00001597          	auipc	a1,0x1
  800bf8:	40c58593          	addi	a1,a1,1036 # 802000 <argv.1>
  800bfc:	e82ff0ef          	jal	ra,80027e <__exec>
  800c00:	842a                	mv	s0,a0
  800c02:	bfb9                	j	800b60 <runcmd+0x10c>
  800c04:	5741                	li	a4,-16
  800c06:	00e50463          	beq	a0,a4,800c0e <runcmd+0x1ba>
  800c0a:	843e                	mv	s0,a5
  800c0c:	bf91                	j	800b60 <runcmd+0x10c>
  800c0e:	6094                	ld	a3,0(s1)
  800c10:	00000617          	auipc	a2,0x0
  800c14:	73860613          	addi	a2,a2,1848 # 801348 <error_string+0x1c0>
  800c18:	6585                	lui	a1,0x1
  800c1a:	00001517          	auipc	a0,0x1
  800c1e:	4ee50513          	addi	a0,a0,1262 # 802108 <argv0.0>
  800c22:	b5dff0ef          	jal	ra,80077e <snprintf>
  800c26:	00001797          	auipc	a5,0x1
  800c2a:	4e278793          	addi	a5,a5,1250 # 802108 <argv0.0>
  800c2e:	e09c                	sd	a5,0(s1)
  800c30:	bf65                	j	800be8 <runcmd+0x194>
  800c32:	00000597          	auipc	a1,0x0
  800c36:	68658593          	addi	a1,a1,1670 # 8012b8 <error_string+0x130>
  800c3a:	4505                	li	a0,1
  800c3c:	d64ff0ef          	jal	ra,8001a0 <fprintf>
  800c40:	547d                	li	s0,-1
  800c42:	bf39                	j	800b60 <runcmd+0x10c>
  800c44:	fc0543e3          	bltz	a0,800c0a <runcmd+0x1b6>
  800c48:	4505                	li	a0,1
  800c4a:	bdcff0ef          	jal	ra,800026 <close>
  800c4e:	4585                	li	a1,1
  800c50:	4501                	li	a0,0
  800c52:	bdaff0ef          	jal	ra,80002c <dup2>
  800c56:	87aa                	mv	a5,a0
  800c58:	fa0549e3          	bltz	a0,800c0a <runcmd+0x1b6>
  800c5c:	4501                	li	a0,0
  800c5e:	bc8ff0ef          	jal	ra,800026 <close>
  800c62:	4501                	li	a0,0
  800c64:	bc2ff0ef          	jal	ra,800026 <close>
  800c68:	bd55                	j	800b1c <runcmd+0xc8>
  800c6a:	547d                	li	s0,-1
  800c6c:	bdd5                	j	800b60 <runcmd+0x10c>
  800c6e:	00000597          	auipc	a1,0x0
  800c72:	67a58593          	addi	a1,a1,1658 # 8012e8 <error_string+0x160>
  800c76:	4505                	li	a0,1
  800c78:	d28ff0ef          	jal	ra,8001a0 <fprintf>
  800c7c:	547d                	li	s0,-1
  800c7e:	b5cd                	j	800b60 <runcmd+0x10c>
  800c80:	00000597          	auipc	a1,0x0
  800c84:	61858593          	addi	a1,a1,1560 # 801298 <error_string+0x110>
  800c88:	4505                	li	a0,1
  800c8a:	d16ff0ef          	jal	ra,8001a0 <fprintf>
  800c8e:	547d                	li	s0,-1
  800c90:	bdc1                	j	800b60 <runcmd+0x10c>

0000000000800c92 <main>:
  800c92:	7179                	addi	sp,sp,-48
  800c94:	f022                	sd	s0,32(sp)
  800c96:	842a                	mv	s0,a0
  800c98:	00000517          	auipc	a0,0x0
  800c9c:	6b850513          	addi	a0,a0,1720 # 801350 <error_string+0x1c8>
  800ca0:	ec26                	sd	s1,24(sp)
  800ca2:	f406                	sd	ra,40(sp)
  800ca4:	e84a                	sd	s2,16(sp)
  800ca6:	84ae                	mv	s1,a1
  800ca8:	cb8ff0ef          	jal	ra,800160 <cputs>
  800cac:	4789                	li	a5,2
  800cae:	04f40e63          	beq	s0,a5,800d0a <main+0x78>
  800cb2:	00000497          	auipc	s1,0x0
  800cb6:	6ee48493          	addi	s1,s1,1774 # 8013a0 <error_string+0x218>
  800cba:	0687c163          	blt	a5,s0,800d1c <main+0x8a>
  800cbe:	00000917          	auipc	s2,0x0
  800cc2:	6ea90913          	addi	s2,s2,1770 # 8013a8 <error_string+0x220>
  800cc6:	a831                	j	800ce2 <main+0x50>
  800cc8:	00003797          	auipc	a5,0x3
  800ccc:	44078023          	sb	zero,1088(a5) # 804108 <shcwd>
  800cd0:	daaff0ef          	jal	ra,80027a <fork>
  800cd4:	cd2d                	beqz	a0,800d4e <main+0xbc>
  800cd6:	04054c63          	bltz	a0,800d2e <main+0x9c>
  800cda:	006c                	addi	a1,sp,12
  800cdc:	da0ff0ef          	jal	ra,80027c <waitpid>
  800ce0:	cd09                	beqz	a0,800cfa <main+0x68>
  800ce2:	8526                	mv	a0,s1
  800ce4:	c23ff0ef          	jal	ra,800906 <readline>
  800ce8:	842a                	mv	s0,a0
  800cea:	fd79                	bnez	a0,800cc8 <main+0x36>
  800cec:	4501                	li	a0,0
  800cee:	70a2                	ld	ra,40(sp)
  800cf0:	7402                	ld	s0,32(sp)
  800cf2:	64e2                	ld	s1,24(sp)
  800cf4:	6942                	ld	s2,16(sp)
  800cf6:	6145                	addi	sp,sp,48
  800cf8:	8082                	ret
  800cfa:	46b2                	lw	a3,12(sp)
  800cfc:	d2fd                	beqz	a3,800ce2 <main+0x50>
  800cfe:	8636                	mv	a2,a3
  800d00:	85ca                	mv	a1,s2
  800d02:	4505                	li	a0,1
  800d04:	c9cff0ef          	jal	ra,8001a0 <fprintf>
  800d08:	bfe9                	j	800ce2 <main+0x50>
  800d0a:	648c                	ld	a1,8(s1)
  800d0c:	4601                	li	a2,0
  800d0e:	4501                	li	a0,0
  800d10:	cedff0ef          	jal	ra,8009fc <reopen>
  800d14:	c62a                	sw	a0,12(sp)
  800d16:	4481                	li	s1,0
  800d18:	d15d                	beqz	a0,800cbe <main+0x2c>
  800d1a:	bfd1                	j	800cee <main+0x5c>
  800d1c:	00000597          	auipc	a1,0x0
  800d20:	55c58593          	addi	a1,a1,1372 # 801278 <error_string+0xf0>
  800d24:	4505                	li	a0,1
  800d26:	c7aff0ef          	jal	ra,8001a0 <fprintf>
  800d2a:	557d                	li	a0,-1
  800d2c:	b7c9                	j	800cee <main+0x5c>
  800d2e:	00000697          	auipc	a3,0x0
  800d32:	63a68693          	addi	a3,a3,1594 # 801368 <error_string+0x1e0>
  800d36:	00000617          	auipc	a2,0x0
  800d3a:	64260613          	addi	a2,a2,1602 # 801378 <error_string+0x1f0>
  800d3e:	0f200593          	li	a1,242
  800d42:	00000517          	auipc	a0,0x0
  800d46:	64e50513          	addi	a0,a0,1614 # 801390 <error_string+0x208>
  800d4a:	aeaff0ef          	jal	ra,800034 <__panic>
  800d4e:	8522                	mv	a0,s0
  800d50:	d05ff0ef          	jal	ra,800a54 <runcmd>
  800d54:	c62a                	sw	a0,12(sp)
  800d56:	d0eff0ef          	jal	ra,800264 <exit>
