
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a4010113          	addi	sp,sp,-1472 # 80008a40 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
    80000022:	f14027f3          	csrr	a5,mhartid
    80000026:	0007869b          	sext.w	a3,a5
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	8ae70713          	addi	a4,a4,-1874 # 80008900 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
    8000005c:	ef1c                	sd	a5,24(a4)
    8000005e:	f310                	sd	a2,32(a4)
    80000060:	34071073          	csrw	mscratch,a4
    80000064:	00006797          	auipc	a5,0x6
    80000068:	53c78793          	addi	a5,a5,1340 # 800065a0 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
    80000070:	300027f3          	csrr	a5,mstatus
    80000074:	0087e793          	ori	a5,a5,8
    80000078:	30079073          	csrw	mstatus,a5
    8000007c:	304027f3          	csrr	a5,mie
    80000080:	0807e793          	ori	a5,a5,128
    80000084:	30479073          	csrw	mie,a5
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
    80000096:	300027f3          	csrr	a5,mstatus
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb68f>
    800000a0:	8ff9                	and	a5,a5,a4
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
    800000aa:	30079073          	csrw	mstatus,a5
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dca78793          	addi	a5,a5,-566 # 80000e78 <main>
    800000b6:	34179073          	csrw	mepc,a5
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
    800000c8:	30379073          	csrw	mideleg,a5
    800000cc:	104027f3          	csrr	a5,sie
    800000d0:	2227e793          	ori	a5,a5,546
    800000d4:	10479073          	csrw	sie,a5
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
    800000ee:	f14027f3          	csrr	a5,mhartid
    800000f2:	2781                	sext.w	a5,a5
    800000f4:	823e                	mv	tp,a5
    800000f6:	30200073          	mret
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00002097          	auipc	ra,0x2
    80000130:	45c080e7          	jalr	1116(ra) # 80002588 <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
    8000014c:	854a                	mv	a0,s2
    8000014e:	60a6                	ld	ra,72(sp)
    80000150:	6406                	ld	s0,64(sp)
    80000152:	74e2                	ld	s1,56(sp)
    80000154:	7942                	ld	s2,48(sp)
    80000156:	79a2                	ld	s3,40(sp)
    80000158:	7a02                	ld	s4,32(sp)
    8000015a:	6ae2                	ld	s5,24(sp)
    8000015c:	6161                	addi	sp,sp,80
    8000015e:	8082                	ret
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
    80000164:	7159                	addi	sp,sp,-112
    80000166:	f486                	sd	ra,104(sp)
    80000168:	f0a2                	sd	s0,96(sp)
    8000016a:	eca6                	sd	s1,88(sp)
    8000016c:	e8ca                	sd	s2,80(sp)
    8000016e:	e4ce                	sd	s3,72(sp)
    80000170:	e0d2                	sd	s4,64(sp)
    80000172:	fc56                	sd	s5,56(sp)
    80000174:	f85a                	sd	s6,48(sp)
    80000176:	f45e                	sd	s7,40(sp)
    80000178:	f062                	sd	s8,32(sp)
    8000017a:	ec66                	sd	s9,24(sp)
    8000017c:	e86a                	sd	s10,16(sp)
    8000017e:	1880                	addi	s0,sp,112
    80000180:	8aaa                	mv	s5,a0
    80000182:	8a2e                	mv	s4,a1
    80000184:	89b2                	mv	s3,a2
    80000186:	00060b1b          	sext.w	s6,a2
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	8b650513          	addi	a0,a0,-1866 # 80010a40 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	a44080e7          	jalr	-1468(ra) # 80000bd6 <acquire>
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	8a648493          	addi	s1,s1,-1882 # 80010a40 <cons>
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	93690913          	addi	s2,s2,-1738 # 80010ad8 <cons+0x98>
    800001aa:	4b91                	li	s7,4
    800001ac:	5c7d                	li	s8,-1
    800001ae:	4ca9                	li	s9,10
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
    800001c0:	00001097          	auipc	ra,0x1
    800001c4:	7ec080e7          	jalr	2028(ra) # 800019ac <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	20a080e7          	jalr	522(ra) # 800023d2 <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	f48080e7          	jalr	-184(ra) # 8000211e <sleep>
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	320080e7          	jalr	800(ra) # 80002532 <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    8000021e:	0a05                	addi	s4,s4,1
    80000220:	39fd                	addiw	s3,s3,-1
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	81a50513          	addi	a0,a0,-2022 # 80010a40 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	a5c080e7          	jalr	-1444(ra) # 80000c8a <release>
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	80450513          	addi	a0,a0,-2044 # 80010a40 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	a46080e7          	jalr	-1466(ra) # 80000c8a <release>
    8000024c:	557d                	li	a0,-1
    8000024e:	70a6                	ld	ra,104(sp)
    80000250:	7406                	ld	s0,96(sp)
    80000252:	64e6                	ld	s1,88(sp)
    80000254:	6946                	ld	s2,80(sp)
    80000256:	69a6                	ld	s3,72(sp)
    80000258:	6a06                	ld	s4,64(sp)
    8000025a:	7ae2                	ld	s5,56(sp)
    8000025c:	7b42                	ld	s6,48(sp)
    8000025e:	7ba2                	ld	s7,40(sp)
    80000260:	7c02                	ld	s8,32(sp)
    80000262:	6ce2                	ld	s9,24(sp)
    80000264:	6d42                	ld	s10,16(sp)
    80000266:	6165                	addi	sp,sp,112
    80000268:	8082                	ret
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
    80000272:	00011717          	auipc	a4,0x11
    80000276:	86f72323          	sw	a5,-1946(a4) # 80010ad8 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    8000029c:	4521                	li	a0,8
    8000029e:	00000097          	auipc	ra,0x0
    800002a2:	54c080e7          	jalr	1356(ra) # 800007ea <uartputc_sync>
    800002a6:	02000513          	li	a0,32
    800002aa:	00000097          	auipc	ra,0x0
    800002ae:	540080e7          	jalr	1344(ra) # 800007ea <uartputc_sync>
    800002b2:	4521                	li	a0,8
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	536080e7          	jalr	1334(ra) # 800007ea <uartputc_sync>
    800002bc:	bfe1                	j	80000294 <consputc+0x18>

00000000800002be <consoleintr>:
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
    800002cc:	00010517          	auipc	a0,0x10
    800002d0:	77450513          	addi	a0,a0,1908 # 80010a40 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	902080e7          	jalr	-1790(ra) # 80000bd6 <acquire>
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	2ec080e7          	jalr	748(ra) # 800025de <procdump>
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	74650513          	addi	a0,a0,1862 # 80010a40 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	988080e7          	jalr	-1656(ra) # 80000c8a <release>
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	72270713          	addi	a4,a4,1826 # 80010a40 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	6f878793          	addi	a5,a5,1784 # 80010a40 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7627a783          	lw	a5,1890(a5) # 80010ad8 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	6b670713          	addi	a4,a4,1718 # 80010a40 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	6a648493          	addi	s1,s1,1702 # 80010a40 <cons>
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
    800003b8:	0af4a023          	sw	a5,160(s1)
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	66a70713          	addi	a4,a4,1642 # 80010a40 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	6ef72a23          	sw	a5,1780(a4) # 80010ae0 <cons+0xa0>
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
    80000412:	00010797          	auipc	a5,0x10
    80000416:	62e78793          	addi	a5,a5,1582 # 80010a40 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	6ac7a323          	sw	a2,1702(a5) # 80010adc <cons+0x9c>
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	69a50513          	addi	a0,a0,1690 # 80010ad8 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	d3c080e7          	jalr	-708(ra) # 80002182 <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	5e050513          	addi	a0,a0,1504 # 80010a40 <cons>
    80000468:	00000097          	auipc	ra,0x0
    8000046c:	6de080e7          	jalr	1758(ra) # 80000b46 <initlock>
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>
    80000478:	00022797          	auipc	a5,0x22
    8000047c:	b6078793          	addi	a5,a5,-1184 # 80021fd8 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48
    800004b6:	4701                	li	a4,0
    800004b8:	2581                	sext.w	a1,a1
    800004ba:	00008617          	auipc	a2,0x8
    800004be:	b8660613          	addi	a2,a2,-1146 # 80008040 <digits>
    800004c2:	883a                	mv	a6,a4
    800004c4:	2705                	addiw	a4,a4,1
    800004c6:	02b577bb          	remuw	a5,a0,a1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	97b2                	add	a5,a5,a2
    800004d0:	0007c783          	lbu	a5,0(a5)
    800004d4:	00f68023          	sb	a5,0(a3)
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    80000536:	40a0053b          	negw	a0,a0
    8000053a:	4885                	li	a7,1
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
    8000054a:	00010797          	auipc	a5,0x10
    8000054e:	5a07ab23          	sw	zero,1462(a5) # 80010b00 <pr+0x18>
    80000552:	00008517          	auipc	a0,0x8
    80000556:	ac650513          	addi	a0,a0,-1338 # 80008018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	e2c50513          	addi	a0,a0,-468 # 80008398 <states.0+0xd0>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
    8000057c:	4785                	li	a5,1
    8000057e:	00008717          	auipc	a4,0x8
    80000582:	34f72123          	sw	a5,834(a4) # 800088c0 <panicked>
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
    80000588:	7131                	addi	sp,sp,-192
    8000058a:	fc86                	sd	ra,120(sp)
    8000058c:	f8a2                	sd	s0,112(sp)
    8000058e:	f4a6                	sd	s1,104(sp)
    80000590:	f0ca                	sd	s2,96(sp)
    80000592:	ecce                	sd	s3,88(sp)
    80000594:	e8d2                	sd	s4,80(sp)
    80000596:	e4d6                	sd	s5,72(sp)
    80000598:	e0da                	sd	s6,64(sp)
    8000059a:	fc5e                	sd	s7,56(sp)
    8000059c:	f862                	sd	s8,48(sp)
    8000059e:	f466                	sd	s9,40(sp)
    800005a0:	f06a                	sd	s10,32(sp)
    800005a2:	ec6e                	sd	s11,24(sp)
    800005a4:	0100                	addi	s0,sp,128
    800005a6:	8a2a                	mv	s4,a0
    800005a8:	e40c                	sd	a1,8(s0)
    800005aa:	e810                	sd	a2,16(s0)
    800005ac:	ec14                	sd	a3,24(s0)
    800005ae:	f018                	sd	a4,32(s0)
    800005b0:	f41c                	sd	a5,40(s0)
    800005b2:	03043823          	sd	a6,48(s0)
    800005b6:	03143c23          	sd	a7,56(s0)
    800005ba:	00010d97          	auipc	s11,0x10
    800005be:	546dad83          	lw	s11,1350(s11) # 80010b00 <pr+0x18>
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    800005dc:	02500a93          	li	s5,37
    800005e0:	07000b93          	li	s7,112
    800005e4:	4d41                	li	s10,16
    800005e6:	00008b17          	auipc	s6,0x8
    800005ea:	a5ab0b13          	addi	s6,s6,-1446 # 80008040 <digits>
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    800005f8:	00010517          	auipc	a0,0x10
    800005fc:	4f050513          	addi	a0,a0,1264 # 80010ae8 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	5d6080e7          	jalr	1494(ra) # 80000bd6 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    8000060a:	00008517          	auipc	a0,0x8
    8000060e:	a1e50513          	addi	a0,a0,-1506 # 80008028 <etext+0x28>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
    80000672:	bf45                	j	80000622 <printf+0x9a>
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
    80000696:	b771                	j	80000622 <printf+0x9a>
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
    80000704:	00008497          	auipc	s1,0x8
    80000708:	91c48493          	addi	s1,s1,-1764 # 80008020 <etext+0x20>
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
    8000071c:	b719                	j	80000622 <printf+0x9a>
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
    80000732:	bdc5                	j	80000622 <printf+0x9a>
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
    80000738:	70e6                	ld	ra,120(sp)
    8000073a:	7446                	ld	s0,112(sp)
    8000073c:	74a6                	ld	s1,104(sp)
    8000073e:	7906                	ld	s2,96(sp)
    80000740:	69e6                	ld	s3,88(sp)
    80000742:	6a46                	ld	s4,80(sp)
    80000744:	6aa6                	ld	s5,72(sp)
    80000746:	6b06                	ld	s6,64(sp)
    80000748:	7be2                	ld	s7,56(sp)
    8000074a:	7c42                	ld	s8,48(sp)
    8000074c:	7ca2                	ld	s9,40(sp)
    8000074e:	7d02                	ld	s10,32(sp)
    80000750:	6de2                	ld	s11,24(sp)
    80000752:	6129                	addi	sp,sp,192
    80000754:	8082                	ret
    80000756:	00010517          	auipc	a0,0x10
    8000075a:	39250513          	addi	a0,a0,914 # 80010ae8 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	52c080e7          	jalr	1324(ra) # 80000c8a <release>
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
    80000772:	00010497          	auipc	s1,0x10
    80000776:	37648493          	addi	s1,s1,886 # 80010ae8 <pr>
    8000077a:	00008597          	auipc	a1,0x8
    8000077e:	8be58593          	addi	a1,a1,-1858 # 80008038 <etext+0x38>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	3c2080e7          	jalr	962(ra) # 80000b46 <initlock>
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)
    800007b8:	000780a3          	sb	zero,1(a5)
    800007bc:	00e781a3          	sb	a4,3(a5)
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)
    800007c6:	00e780a3          	sb	a4,1(a5)
    800007ca:	00008597          	auipc	a1,0x8
    800007ce:	88e58593          	addi	a1,a1,-1906 # 80008058 <digits+0x18>
    800007d2:	00010517          	auipc	a0,0x10
    800007d6:	33650513          	addi	a0,a0,822 # 80010b08 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	36c080e7          	jalr	876(ra) # 80000b46 <initlock>
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	394080e7          	jalr	916(ra) # 80000b8a <push_off>
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	0c27a783          	lw	a5,194(a5) # 800088c0 <panicked>
    80000806:	10000737          	lui	a4,0x10000
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    80000818:	0ff4f513          	andi	a0,s1,255
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000824:	00000097          	auipc	ra,0x0
    80000828:	406080e7          	jalr	1030(ra) # 80000c2a <pop_off>
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
    80000836:	00008797          	auipc	a5,0x8
    8000083a:	0927b783          	ld	a5,146(a5) # 800088c8 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	09273703          	ld	a4,146(a4) # 800088d0 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
    8000085c:	10000937          	lui	s2,0x10000
    80000860:	00010a17          	auipc	s4,0x10
    80000864:	2a8a0a13          	addi	s4,s4,680 # 80010b08 <uart_tx_lock>
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	06048493          	addi	s1,s1,96 # 800088c8 <uart_tx_r>
    80000870:	00008997          	auipc	s3,0x8
    80000874:	06098993          	addi	s3,s3,96 # 800088d0 <uart_tx_w>
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	8f0080e7          	jalr	-1808(ra) # 80002182 <wakeup>
    8000089a:	01590023          	sb	s5,0(s2)
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
    800008a8:	70e2                	ld	ra,56(sp)
    800008aa:	7442                	ld	s0,48(sp)
    800008ac:	74a2                	ld	s1,40(sp)
    800008ae:	7902                	ld	s2,32(sp)
    800008b0:	69e2                	ld	s3,24(sp)
    800008b2:	6a42                	ld	s4,16(sp)
    800008b4:	6aa2                	ld	s5,8(sp)
    800008b6:	6121                	addi	sp,sp,64
    800008b8:	8082                	ret
    800008ba:	8082                	ret

00000000800008bc <uartputc>:
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
    800008ce:	00010517          	auipc	a0,0x10
    800008d2:	23a50513          	addi	a0,a0,570 # 80010b08 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	300080e7          	jalr	768(ra) # 80000bd6 <acquire>
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	fe27a783          	lw	a5,-30(a5) # 800088c0 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	fe873703          	ld	a4,-24(a4) # 800088d0 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	fd87b783          	ld	a5,-40(a5) # 800088c8 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	20c98993          	addi	s3,s3,524 # 80010b08 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	fc448493          	addi	s1,s1,-60 # 800088c8 <uart_tx_r>
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	fc490913          	addi	s2,s2,-60 # 800088d0 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	802080e7          	jalr	-2046(ra) # 8000211e <sleep>
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
    80000932:	00010497          	auipc	s1,0x10
    80000936:	1d648493          	addi	s1,s1,470 # 80010b08 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	f8e7b523          	sd	a4,-118(a5) # 800088d0 <uart_tx_w>
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	332080e7          	jalr	818(ra) # 80000c8a <release>
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	andi	a0,a0,255
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
    800009bc:	00010497          	auipc	s1,0x10
    800009c0:	14c48493          	addi	s1,s1,332 # 80010b08 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	210080e7          	jalr	528(ra) # 80000bd6 <acquire>
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	2b2080e7          	jalr	690(ra) # 80000c8a <release>
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <kfree>:
    800009ea:	1101                	addi	sp,sp,-32
    800009ec:	ec06                	sd	ra,24(sp)
    800009ee:	e822                	sd	s0,16(sp)
    800009f0:	e426                	sd	s1,8(sp)
    800009f2:	e04a                	sd	s2,0(sp)
    800009f4:	1000                	addi	s0,sp,32
    800009f6:	03451793          	slli	a5,a0,0x34
    800009fa:	ebb9                	bnez	a5,80000a50 <kfree+0x66>
    800009fc:	84aa                	mv	s1,a0
    800009fe:	00022797          	auipc	a5,0x22
    80000a02:	77278793          	addi	a5,a5,1906 # 80023170 <end>
    80000a06:	04f56563          	bltu	a0,a5,80000a50 <kfree+0x66>
    80000a0a:	47c5                	li	a5,17
    80000a0c:	07ee                	slli	a5,a5,0x1b
    80000a0e:	04f57163          	bgeu	a0,a5,80000a50 <kfree+0x66>
    80000a12:	6605                	lui	a2,0x1
    80000a14:	4585                	li	a1,1
    80000a16:	00000097          	auipc	ra,0x0
    80000a1a:	2bc080e7          	jalr	700(ra) # 80000cd2 <memset>
    80000a1e:	00010917          	auipc	s2,0x10
    80000a22:	12290913          	addi	s2,s2,290 # 80010b40 <kmem>
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	1ae080e7          	jalr	430(ra) # 80000bd6 <acquire>
    80000a30:	01893783          	ld	a5,24(s2)
    80000a34:	e09c                	sd	a5,0(s1)
    80000a36:	00993c23          	sd	s1,24(s2)
    80000a3a:	854a                	mv	a0,s2
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	24e080e7          	jalr	590(ra) # 80000c8a <release>
    80000a44:	60e2                	ld	ra,24(sp)
    80000a46:	6442                	ld	s0,16(sp)
    80000a48:	64a2                	ld	s1,8(sp)
    80000a4a:	6902                	ld	s2,0(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret
    80000a50:	00007517          	auipc	a0,0x7
    80000a54:	61050513          	addi	a0,a0,1552 # 80008060 <digits+0x20>
    80000a58:	00000097          	auipc	ra,0x0
    80000a5c:	ae6080e7          	jalr	-1306(ra) # 8000053e <panic>

0000000080000a60 <freerange>:
    80000a60:	7179                	addi	sp,sp,-48
    80000a62:	f406                	sd	ra,40(sp)
    80000a64:	f022                	sd	s0,32(sp)
    80000a66:	ec26                	sd	s1,24(sp)
    80000a68:	e84a                	sd	s2,16(sp)
    80000a6a:	e44e                	sd	s3,8(sp)
    80000a6c:	e052                	sd	s4,0(sp)
    80000a6e:	1800                	addi	s0,sp,48
    80000a70:	6785                	lui	a5,0x1
    80000a72:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a76:	94aa                	add	s1,s1,a0
    80000a78:	757d                	lui	a0,0xfffff
    80000a7a:	8ce9                	and	s1,s1,a0
    80000a7c:	94be                	add	s1,s1,a5
    80000a7e:	0095ee63          	bltu	a1,s1,80000a9a <freerange+0x3a>
    80000a82:	892e                	mv	s2,a1
    80000a84:	7a7d                	lui	s4,0xfffff
    80000a86:	6985                	lui	s3,0x1
    80000a88:	01448533          	add	a0,s1,s4
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	f5e080e7          	jalr	-162(ra) # 800009ea <kfree>
    80000a94:	94ce                	add	s1,s1,s3
    80000a96:	fe9979e3          	bgeu	s2,s1,80000a88 <freerange+0x28>
    80000a9a:	70a2                	ld	ra,40(sp)
    80000a9c:	7402                	ld	s0,32(sp)
    80000a9e:	64e2                	ld	s1,24(sp)
    80000aa0:	6942                	ld	s2,16(sp)
    80000aa2:	69a2                	ld	s3,8(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	6145                	addi	sp,sp,48
    80000aa8:	8082                	ret

0000000080000aaa <kinit>:
    80000aaa:	1141                	addi	sp,sp,-16
    80000aac:	e406                	sd	ra,8(sp)
    80000aae:	e022                	sd	s0,0(sp)
    80000ab0:	0800                	addi	s0,sp,16
    80000ab2:	00007597          	auipc	a1,0x7
    80000ab6:	5b658593          	addi	a1,a1,1462 # 80008068 <digits+0x28>
    80000aba:	00010517          	auipc	a0,0x10
    80000abe:	08650513          	addi	a0,a0,134 # 80010b40 <kmem>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	084080e7          	jalr	132(ra) # 80000b46 <initlock>
    80000aca:	45c5                	li	a1,17
    80000acc:	05ee                	slli	a1,a1,0x1b
    80000ace:	00022517          	auipc	a0,0x22
    80000ad2:	6a250513          	addi	a0,a0,1698 # 80023170 <end>
    80000ad6:	00000097          	auipc	ra,0x0
    80000ada:	f8a080e7          	jalr	-118(ra) # 80000a60 <freerange>
    80000ade:	60a2                	ld	ra,8(sp)
    80000ae0:	6402                	ld	s0,0(sp)
    80000ae2:	0141                	addi	sp,sp,16
    80000ae4:	8082                	ret

0000000080000ae6 <kalloc>:
    80000ae6:	1101                	addi	sp,sp,-32
    80000ae8:	ec06                	sd	ra,24(sp)
    80000aea:	e822                	sd	s0,16(sp)
    80000aec:	e426                	sd	s1,8(sp)
    80000aee:	1000                	addi	s0,sp,32
    80000af0:	00010497          	auipc	s1,0x10
    80000af4:	05048493          	addi	s1,s1,80 # 80010b40 <kmem>
    80000af8:	8526                	mv	a0,s1
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	0dc080e7          	jalr	220(ra) # 80000bd6 <acquire>
    80000b02:	6c84                	ld	s1,24(s1)
    80000b04:	c885                	beqz	s1,80000b34 <kalloc+0x4e>
    80000b06:	609c                	ld	a5,0(s1)
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	03850513          	addi	a0,a0,56 # 80010b40 <kmem>
    80000b10:	ed1c                	sd	a5,24(a0)
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	178080e7          	jalr	376(ra) # 80000c8a <release>
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	4595                	li	a1,5
    80000b1e:	8526                	mv	a0,s1
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	1b2080e7          	jalr	434(ra) # 80000cd2 <memset>
    80000b28:	8526                	mv	a0,s1
    80000b2a:	60e2                	ld	ra,24(sp)
    80000b2c:	6442                	ld	s0,16(sp)
    80000b2e:	64a2                	ld	s1,8(sp)
    80000b30:	6105                	addi	sp,sp,32
    80000b32:	8082                	ret
    80000b34:	00010517          	auipc	a0,0x10
    80000b38:	00c50513          	addi	a0,a0,12 # 80010b40 <kmem>
    80000b3c:	00000097          	auipc	ra,0x0
    80000b40:	14e080e7          	jalr	334(ra) # 80000c8a <release>
    80000b44:	b7d5                	j	80000b28 <kalloc+0x42>

0000000080000b46 <initlock>:
    80000b46:	1141                	addi	sp,sp,-16
    80000b48:	e422                	sd	s0,8(sp)
    80000b4a:	0800                	addi	s0,sp,16
    80000b4c:	e50c                	sd	a1,8(a0)
    80000b4e:	00052023          	sw	zero,0(a0)
    80000b52:	00053823          	sd	zero,16(a0)
    80000b56:	6422                	ld	s0,8(sp)
    80000b58:	0141                	addi	sp,sp,16
    80000b5a:	8082                	ret

0000000080000b5c <holding>:
    80000b5c:	411c                	lw	a5,0(a0)
    80000b5e:	e399                	bnez	a5,80000b64 <holding+0x8>
    80000b60:	4501                	li	a0,0
    80000b62:	8082                	ret
    80000b64:	1101                	addi	sp,sp,-32
    80000b66:	ec06                	sd	ra,24(sp)
    80000b68:	e822                	sd	s0,16(sp)
    80000b6a:	e426                	sd	s1,8(sp)
    80000b6c:	1000                	addi	s0,sp,32
    80000b6e:	6904                	ld	s1,16(a0)
    80000b70:	00001097          	auipc	ra,0x1
    80000b74:	e20080e7          	jalr	-480(ra) # 80001990 <mycpu>
    80000b78:	40a48533          	sub	a0,s1,a0
    80000b7c:	00153513          	seqz	a0,a0
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret

0000000080000b8a <push_off>:
    80000b8a:	1101                	addi	sp,sp,-32
    80000b8c:	ec06                	sd	ra,24(sp)
    80000b8e:	e822                	sd	s0,16(sp)
    80000b90:	e426                	sd	s1,8(sp)
    80000b92:	1000                	addi	s0,sp,32
    80000b94:	100024f3          	csrr	s1,sstatus
    80000b98:	100027f3          	csrr	a5,sstatus
    80000b9c:	9bf5                	andi	a5,a5,-3
    80000b9e:	10079073          	csrw	sstatus,a5
    80000ba2:	00001097          	auipc	ra,0x1
    80000ba6:	dee080e7          	jalr	-530(ra) # 80001990 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cf89                	beqz	a5,80000bc6 <push_off+0x3c>
    80000bae:	00001097          	auipc	ra,0x1
    80000bb2:	de2080e7          	jalr	-542(ra) # 80001990 <mycpu>
    80000bb6:	5d3c                	lw	a5,120(a0)
    80000bb8:	2785                	addiw	a5,a5,1
    80000bba:	dd3c                	sw	a5,120(a0)
    80000bbc:	60e2                	ld	ra,24(sp)
    80000bbe:	6442                	ld	s0,16(sp)
    80000bc0:	64a2                	ld	s1,8(sp)
    80000bc2:	6105                	addi	sp,sp,32
    80000bc4:	8082                	ret
    80000bc6:	00001097          	auipc	ra,0x1
    80000bca:	dca080e7          	jalr	-566(ra) # 80001990 <mycpu>
    80000bce:	8085                	srli	s1,s1,0x1
    80000bd0:	8885                	andi	s1,s1,1
    80000bd2:	dd64                	sw	s1,124(a0)
    80000bd4:	bfe9                	j	80000bae <push_off+0x24>

0000000080000bd6 <acquire>:
    80000bd6:	1101                	addi	sp,sp,-32
    80000bd8:	ec06                	sd	ra,24(sp)
    80000bda:	e822                	sd	s0,16(sp)
    80000bdc:	e426                	sd	s1,8(sp)
    80000bde:	1000                	addi	s0,sp,32
    80000be0:	84aa                	mv	s1,a0
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	fa8080e7          	jalr	-88(ra) # 80000b8a <push_off>
    80000bea:	8526                	mv	a0,s1
    80000bec:	00000097          	auipc	ra,0x0
    80000bf0:	f70080e7          	jalr	-144(ra) # 80000b5c <holding>
    80000bf4:	4705                	li	a4,1
    80000bf6:	e115                	bnez	a0,80000c1a <acquire+0x44>
    80000bf8:	87ba                	mv	a5,a4
    80000bfa:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bfe:	2781                	sext.w	a5,a5
    80000c00:	ffe5                	bnez	a5,80000bf8 <acquire+0x22>
    80000c02:	0ff0000f          	fence
    80000c06:	00001097          	auipc	ra,0x1
    80000c0a:	d8a080e7          	jalr	-630(ra) # 80001990 <mycpu>
    80000c0e:	e888                	sd	a0,16(s1)
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    80000c1a:	00007517          	auipc	a0,0x7
    80000c1e:	45650513          	addi	a0,a0,1110 # 80008070 <digits+0x30>
    80000c22:	00000097          	auipc	ra,0x0
    80000c26:	91c080e7          	jalr	-1764(ra) # 8000053e <panic>

0000000080000c2a <pop_off>:
    80000c2a:	1141                	addi	sp,sp,-16
    80000c2c:	e406                	sd	ra,8(sp)
    80000c2e:	e022                	sd	s0,0(sp)
    80000c30:	0800                	addi	s0,sp,16
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	d5e080e7          	jalr	-674(ra) # 80001990 <mycpu>
    80000c3a:	100027f3          	csrr	a5,sstatus
    80000c3e:	8b89                	andi	a5,a5,2
    80000c40:	e78d                	bnez	a5,80000c6a <pop_off+0x40>
    80000c42:	5d3c                	lw	a5,120(a0)
    80000c44:	02f05b63          	blez	a5,80000c7a <pop_off+0x50>
    80000c48:	37fd                	addiw	a5,a5,-1
    80000c4a:	0007871b          	sext.w	a4,a5
    80000c4e:	dd3c                	sw	a5,120(a0)
    80000c50:	eb09                	bnez	a4,80000c62 <pop_off+0x38>
    80000c52:	5d7c                	lw	a5,124(a0)
    80000c54:	c799                	beqz	a5,80000c62 <pop_off+0x38>
    80000c56:	100027f3          	csrr	a5,sstatus
    80000c5a:	0027e793          	ori	a5,a5,2
    80000c5e:	10079073          	csrw	sstatus,a5
    80000c62:	60a2                	ld	ra,8(sp)
    80000c64:	6402                	ld	s0,0(sp)
    80000c66:	0141                	addi	sp,sp,16
    80000c68:	8082                	ret
    80000c6a:	00007517          	auipc	a0,0x7
    80000c6e:	40e50513          	addi	a0,a0,1038 # 80008078 <digits+0x38>
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	8cc080e7          	jalr	-1844(ra) # 8000053e <panic>
    80000c7a:	00007517          	auipc	a0,0x7
    80000c7e:	41650513          	addi	a0,a0,1046 # 80008090 <digits+0x50>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	8bc080e7          	jalr	-1860(ra) # 8000053e <panic>

0000000080000c8a <release>:
    80000c8a:	1101                	addi	sp,sp,-32
    80000c8c:	ec06                	sd	ra,24(sp)
    80000c8e:	e822                	sd	s0,16(sp)
    80000c90:	e426                	sd	s1,8(sp)
    80000c92:	1000                	addi	s0,sp,32
    80000c94:	84aa                	mv	s1,a0
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	ec6080e7          	jalr	-314(ra) # 80000b5c <holding>
    80000c9e:	c115                	beqz	a0,80000cc2 <release+0x38>
    80000ca0:	0004b823          	sd	zero,16(s1)
    80000ca4:	0ff0000f          	fence
    80000ca8:	0f50000f          	fence	iorw,ow
    80000cac:	0804a02f          	amoswap.w	zero,zero,(s1)
    80000cb0:	00000097          	auipc	ra,0x0
    80000cb4:	f7a080e7          	jalr	-134(ra) # 80000c2a <pop_off>
    80000cb8:	60e2                	ld	ra,24(sp)
    80000cba:	6442                	ld	s0,16(sp)
    80000cbc:	64a2                	ld	s1,8(sp)
    80000cbe:	6105                	addi	sp,sp,32
    80000cc0:	8082                	ret
    80000cc2:	00007517          	auipc	a0,0x7
    80000cc6:	3d650513          	addi	a0,a0,982 # 80008098 <digits+0x58>
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	874080e7          	jalr	-1932(ra) # 8000053e <panic>

0000000080000cd2 <memset>:
    80000cd2:	1141                	addi	sp,sp,-16
    80000cd4:	e422                	sd	s0,8(sp)
    80000cd6:	0800                	addi	s0,sp,16
    80000cd8:	ca19                	beqz	a2,80000cee <memset+0x1c>
    80000cda:	87aa                	mv	a5,a0
    80000cdc:	1602                	slli	a2,a2,0x20
    80000cde:	9201                	srli	a2,a2,0x20
    80000ce0:	00a60733          	add	a4,a2,a0
    80000ce4:	00b78023          	sb	a1,0(a5)
    80000ce8:	0785                	addi	a5,a5,1
    80000cea:	fee79de3          	bne	a5,a4,80000ce4 <memset+0x12>
    80000cee:	6422                	ld	s0,8(sp)
    80000cf0:	0141                	addi	sp,sp,16
    80000cf2:	8082                	ret

0000000080000cf4 <memcmp>:
    80000cf4:	1141                	addi	sp,sp,-16
    80000cf6:	e422                	sd	s0,8(sp)
    80000cf8:	0800                	addi	s0,sp,16
    80000cfa:	ca05                	beqz	a2,80000d2a <memcmp+0x36>
    80000cfc:	fff6069b          	addiw	a3,a2,-1
    80000d00:	1682                	slli	a3,a3,0x20
    80000d02:	9281                	srli	a3,a3,0x20
    80000d04:	0685                	addi	a3,a3,1
    80000d06:	96aa                	add	a3,a3,a0
    80000d08:	00054783          	lbu	a5,0(a0)
    80000d0c:	0005c703          	lbu	a4,0(a1)
    80000d10:	00e79863          	bne	a5,a4,80000d20 <memcmp+0x2c>
    80000d14:	0505                	addi	a0,a0,1
    80000d16:	0585                	addi	a1,a1,1
    80000d18:	fed518e3          	bne	a0,a3,80000d08 <memcmp+0x14>
    80000d1c:	4501                	li	a0,0
    80000d1e:	a019                	j	80000d24 <memcmp+0x30>
    80000d20:	40e7853b          	subw	a0,a5,a4
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
    80000d2a:	4501                	li	a0,0
    80000d2c:	bfe5                	j	80000d24 <memcmp+0x30>

0000000080000d2e <memmove>:
    80000d2e:	1141                	addi	sp,sp,-16
    80000d30:	e422                	sd	s0,8(sp)
    80000d32:	0800                	addi	s0,sp,16
    80000d34:	c205                	beqz	a2,80000d54 <memmove+0x26>
    80000d36:	02a5e263          	bltu	a1,a0,80000d5a <memmove+0x2c>
    80000d3a:	1602                	slli	a2,a2,0x20
    80000d3c:	9201                	srli	a2,a2,0x20
    80000d3e:	00c587b3          	add	a5,a1,a2
    80000d42:	872a                	mv	a4,a0
    80000d44:	0585                	addi	a1,a1,1
    80000d46:	0705                	addi	a4,a4,1
    80000d48:	fff5c683          	lbu	a3,-1(a1)
    80000d4c:	fed70fa3          	sb	a3,-1(a4)
    80000d50:	fef59ae3          	bne	a1,a5,80000d44 <memmove+0x16>
    80000d54:	6422                	ld	s0,8(sp)
    80000d56:	0141                	addi	sp,sp,16
    80000d58:	8082                	ret
    80000d5a:	02061693          	slli	a3,a2,0x20
    80000d5e:	9281                	srli	a3,a3,0x20
    80000d60:	00d58733          	add	a4,a1,a3
    80000d64:	fce57be3          	bgeu	a0,a4,80000d3a <memmove+0xc>
    80000d68:	96aa                	add	a3,a3,a0
    80000d6a:	fff6079b          	addiw	a5,a2,-1
    80000d6e:	1782                	slli	a5,a5,0x20
    80000d70:	9381                	srli	a5,a5,0x20
    80000d72:	fff7c793          	not	a5,a5
    80000d76:	97ba                	add	a5,a5,a4
    80000d78:	177d                	addi	a4,a4,-1
    80000d7a:	16fd                	addi	a3,a3,-1
    80000d7c:	00074603          	lbu	a2,0(a4)
    80000d80:	00c68023          	sb	a2,0(a3)
    80000d84:	fee79ae3          	bne	a5,a4,80000d78 <memmove+0x4a>
    80000d88:	b7f1                	j	80000d54 <memmove+0x26>

0000000080000d8a <memcpy>:
    80000d8a:	1141                	addi	sp,sp,-16
    80000d8c:	e406                	sd	ra,8(sp)
    80000d8e:	e022                	sd	s0,0(sp)
    80000d90:	0800                	addi	s0,sp,16
    80000d92:	00000097          	auipc	ra,0x0
    80000d96:	f9c080e7          	jalr	-100(ra) # 80000d2e <memmove>
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
    80000dc0:	4501                	li	a0,0
    80000dc2:	a809                	j	80000dd4 <strncmp+0x32>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a039                	j	80000dd4 <strncmp+0x32>
    80000dc8:	ca09                	beqz	a2,80000dda <strncmp+0x38>
    80000dca:	00054503          	lbu	a0,0(a0)
    80000dce:	0005c783          	lbu	a5,0(a1)
    80000dd2:	9d1d                	subw	a0,a0,a5
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <strncmp+0x32>

0000000080000dde <strncpy>:
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
    80000de4:	872a                	mv	a4,a0
    80000de6:	8832                	mv	a6,a2
    80000de8:	367d                	addiw	a2,a2,-1
    80000dea:	01005963          	blez	a6,80000dfc <strncpy+0x1e>
    80000dee:	0705                	addi	a4,a4,1
    80000df0:	0005c783          	lbu	a5,0(a1)
    80000df4:	fef70fa3          	sb	a5,-1(a4)
    80000df8:	0585                	addi	a1,a1,1
    80000dfa:	f7f5                	bnez	a5,80000de6 <strncpy+0x8>
    80000dfc:	86ba                	mv	a3,a4
    80000dfe:	00c05c63          	blez	a2,80000e16 <strncpy+0x38>
    80000e02:	0685                	addi	a3,a3,1
    80000e04:	fe068fa3          	sb	zero,-1(a3)
    80000e08:	fff6c793          	not	a5,a3
    80000e0c:	9fb9                	addw	a5,a5,a4
    80000e0e:	010787bb          	addw	a5,a5,a6
    80000e12:	fef048e3          	bgtz	a5,80000e02 <strncpy+0x24>
    80000e16:	6422                	ld	s0,8(sp)
    80000e18:	0141                	addi	sp,sp,16
    80000e1a:	8082                	ret

0000000080000e1c <safestrcpy>:
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e422                	sd	s0,8(sp)
    80000e20:	0800                	addi	s0,sp,16
    80000e22:	02c05363          	blez	a2,80000e48 <safestrcpy+0x2c>
    80000e26:	fff6069b          	addiw	a3,a2,-1
    80000e2a:	1682                	slli	a3,a3,0x20
    80000e2c:	9281                	srli	a3,a3,0x20
    80000e2e:	96ae                	add	a3,a3,a1
    80000e30:	87aa                	mv	a5,a0
    80000e32:	00d58963          	beq	a1,a3,80000e44 <safestrcpy+0x28>
    80000e36:	0585                	addi	a1,a1,1
    80000e38:	0785                	addi	a5,a5,1
    80000e3a:	fff5c703          	lbu	a4,-1(a1)
    80000e3e:	fee78fa3          	sb	a4,-1(a5)
    80000e42:	fb65                	bnez	a4,80000e32 <safestrcpy+0x16>
    80000e44:	00078023          	sb	zero,0(a5)
    80000e48:	6422                	ld	s0,8(sp)
    80000e4a:	0141                	addi	sp,sp,16
    80000e4c:	8082                	ret

0000000080000e4e <strlen>:
    80000e4e:	1141                	addi	sp,sp,-16
    80000e50:	e422                	sd	s0,8(sp)
    80000e52:	0800                	addi	s0,sp,16
    80000e54:	00054783          	lbu	a5,0(a0)
    80000e58:	cf91                	beqz	a5,80000e74 <strlen+0x26>
    80000e5a:	0505                	addi	a0,a0,1
    80000e5c:	87aa                	mv	a5,a0
    80000e5e:	4685                	li	a3,1
    80000e60:	9e89                	subw	a3,a3,a0
    80000e62:	00f6853b          	addw	a0,a3,a5
    80000e66:	0785                	addi	a5,a5,1
    80000e68:	fff7c703          	lbu	a4,-1(a5)
    80000e6c:	fb7d                	bnez	a4,80000e62 <strlen+0x14>
    80000e6e:	6422                	ld	s0,8(sp)
    80000e70:	0141                	addi	sp,sp,16
    80000e72:	8082                	ret
    80000e74:	4501                	li	a0,0
    80000e76:	bfe5                	j	80000e6e <strlen+0x20>

0000000080000e78 <main>:
    80000e78:	1141                	addi	sp,sp,-16
    80000e7a:	e406                	sd	ra,8(sp)
    80000e7c:	e022                	sd	s0,0(sp)
    80000e7e:	0800                	addi	s0,sp,16
    80000e80:	00001097          	auipc	ra,0x1
    80000e84:	b00080e7          	jalr	-1280(ra) # 80001980 <cpuid>
    80000e88:	00008717          	auipc	a4,0x8
    80000e8c:	a5070713          	addi	a4,a4,-1456 # 800088d8 <started>
    80000e90:	c139                	beqz	a0,80000ed6 <main+0x5e>
    80000e92:	431c                	lw	a5,0(a4)
    80000e94:	2781                	sext.w	a5,a5
    80000e96:	dff5                	beqz	a5,80000e92 <main+0x1a>
    80000e98:	0ff0000f          	fence
    80000e9c:	00001097          	auipc	ra,0x1
    80000ea0:	ae4080e7          	jalr	-1308(ra) # 80001980 <cpuid>
    80000ea4:	85aa                	mv	a1,a0
    80000ea6:	00007517          	auipc	a0,0x7
    80000eaa:	21250513          	addi	a0,a0,530 # 800080b8 <digits+0x78>
    80000eae:	fffff097          	auipc	ra,0xfffff
    80000eb2:	6da080e7          	jalr	1754(ra) # 80000588 <printf>
    80000eb6:	00000097          	auipc	ra,0x0
    80000eba:	0d8080e7          	jalr	216(ra) # 80000f8e <kvminithart>
    80000ebe:	00002097          	auipc	ra,0x2
    80000ec2:	a2c080e7          	jalr	-1492(ra) # 800028ea <trapinithart>
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	71a080e7          	jalr	1818(ra) # 800065e0 <plicinithart>
    80000ece:	00001097          	auipc	ra,0x1
    80000ed2:	00c080e7          	jalr	12(ra) # 80001eda <scheduler>
    80000ed6:	fffff097          	auipc	ra,0xfffff
    80000eda:	57a080e7          	jalr	1402(ra) # 80000450 <consoleinit>
    80000ede:	00000097          	auipc	ra,0x0
    80000ee2:	88a080e7          	jalr	-1910(ra) # 80000768 <printfinit>
    80000ee6:	00007517          	auipc	a0,0x7
    80000eea:	4b250513          	addi	a0,a0,1202 # 80008398 <states.0+0xd0>
    80000eee:	fffff097          	auipc	ra,0xfffff
    80000ef2:	69a080e7          	jalr	1690(ra) # 80000588 <printf>
    80000ef6:	00007517          	auipc	a0,0x7
    80000efa:	1aa50513          	addi	a0,a0,426 # 800080a0 <digits+0x60>
    80000efe:	fffff097          	auipc	ra,0xfffff
    80000f02:	68a080e7          	jalr	1674(ra) # 80000588 <printf>
    80000f06:	00007517          	auipc	a0,0x7
    80000f0a:	49250513          	addi	a0,a0,1170 # 80008398 <states.0+0xd0>
    80000f0e:	fffff097          	auipc	ra,0xfffff
    80000f12:	67a080e7          	jalr	1658(ra) # 80000588 <printf>
    80000f16:	00000097          	auipc	ra,0x0
    80000f1a:	b94080e7          	jalr	-1132(ra) # 80000aaa <kinit>
    80000f1e:	00000097          	auipc	ra,0x0
    80000f22:	326080e7          	jalr	806(ra) # 80001244 <kvminit>
    80000f26:	00000097          	auipc	ra,0x0
    80000f2a:	068080e7          	jalr	104(ra) # 80000f8e <kvminithart>
    80000f2e:	00001097          	auipc	ra,0x1
    80000f32:	99e080e7          	jalr	-1634(ra) # 800018cc <procinit>
    80000f36:	00002097          	auipc	ra,0x2
    80000f3a:	98c080e7          	jalr	-1652(ra) # 800028c2 <trapinit>
    80000f3e:	00002097          	auipc	ra,0x2
    80000f42:	9ac080e7          	jalr	-1620(ra) # 800028ea <trapinithart>
    80000f46:	00005097          	auipc	ra,0x5
    80000f4a:	684080e7          	jalr	1668(ra) # 800065ca <plicinit>
    80000f4e:	00005097          	auipc	ra,0x5
    80000f52:	692080e7          	jalr	1682(ra) # 800065e0 <plicinithart>
    80000f56:	00002097          	auipc	ra,0x2
    80000f5a:	78c080e7          	jalr	1932(ra) # 800036e2 <binit>
    80000f5e:	00003097          	auipc	ra,0x3
    80000f62:	e30080e7          	jalr	-464(ra) # 80003d8e <iinit>
    80000f66:	00004097          	auipc	ra,0x4
    80000f6a:	dce080e7          	jalr	-562(ra) # 80004d34 <fileinit>
    80000f6e:	00005097          	auipc	ra,0x5
    80000f72:	77a080e7          	jalr	1914(ra) # 800066e8 <virtio_disk_init>
    80000f76:	00001097          	auipc	ra,0x1
    80000f7a:	d46080e7          	jalr	-698(ra) # 80001cbc <userinit>
    80000f7e:	0ff0000f          	fence
    80000f82:	4785                	li	a5,1
    80000f84:	00008717          	auipc	a4,0x8
    80000f88:	94f72a23          	sw	a5,-1708(a4) # 800088d8 <started>
    80000f8c:	b789                	j	80000ece <main+0x56>

0000000080000f8e <kvminithart>:
    80000f8e:	1141                	addi	sp,sp,-16
    80000f90:	e422                	sd	s0,8(sp)
    80000f92:	0800                	addi	s0,sp,16
    80000f94:	12000073          	sfence.vma
    80000f98:	00008797          	auipc	a5,0x8
    80000f9c:	9487b783          	ld	a5,-1720(a5) # 800088e0 <kernel_pagetable>
    80000fa0:	83b1                	srli	a5,a5,0xc
    80000fa2:	577d                	li	a4,-1
    80000fa4:	177e                	slli	a4,a4,0x3f
    80000fa6:	8fd9                	or	a5,a5,a4
    80000fa8:	18079073          	csrw	satp,a5
    80000fac:	12000073          	sfence.vma
    80000fb0:	6422                	ld	s0,8(sp)
    80000fb2:	0141                	addi	sp,sp,16
    80000fb4:	8082                	ret

0000000080000fb6 <walk>:
    80000fb6:	7139                	addi	sp,sp,-64
    80000fb8:	fc06                	sd	ra,56(sp)
    80000fba:	f822                	sd	s0,48(sp)
    80000fbc:	f426                	sd	s1,40(sp)
    80000fbe:	f04a                	sd	s2,32(sp)
    80000fc0:	ec4e                	sd	s3,24(sp)
    80000fc2:	e852                	sd	s4,16(sp)
    80000fc4:	e456                	sd	s5,8(sp)
    80000fc6:	e05a                	sd	s6,0(sp)
    80000fc8:	0080                	addi	s0,sp,64
    80000fca:	84aa                	mv	s1,a0
    80000fcc:	89ae                	mv	s3,a1
    80000fce:	8ab2                	mv	s5,a2
    80000fd0:	57fd                	li	a5,-1
    80000fd2:	83e9                	srli	a5,a5,0x1a
    80000fd4:	4a79                	li	s4,30
    80000fd6:	4b31                	li	s6,12
    80000fd8:	04b7f263          	bgeu	a5,a1,8000101c <walk+0x66>
    80000fdc:	00007517          	auipc	a0,0x7
    80000fe0:	0f450513          	addi	a0,a0,244 # 800080d0 <digits+0x90>
    80000fe4:	fffff097          	auipc	ra,0xfffff
    80000fe8:	55a080e7          	jalr	1370(ra) # 8000053e <panic>
    80000fec:	060a8663          	beqz	s5,80001058 <walk+0xa2>
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	af6080e7          	jalr	-1290(ra) # 80000ae6 <kalloc>
    80000ff8:	84aa                	mv	s1,a0
    80000ffa:	c529                	beqz	a0,80001044 <walk+0x8e>
    80000ffc:	6605                	lui	a2,0x1
    80000ffe:	4581                	li	a1,0
    80001000:	00000097          	auipc	ra,0x0
    80001004:	cd2080e7          	jalr	-814(ra) # 80000cd2 <memset>
    80001008:	00c4d793          	srli	a5,s1,0xc
    8000100c:	07aa                	slli	a5,a5,0xa
    8000100e:	0017e793          	ori	a5,a5,1
    80001012:	00f93023          	sd	a5,0(s2)
    80001016:	3a5d                	addiw	s4,s4,-9
    80001018:	036a0063          	beq	s4,s6,80001038 <walk+0x82>
    8000101c:	0149d933          	srl	s2,s3,s4
    80001020:	1ff97913          	andi	s2,s2,511
    80001024:	090e                	slli	s2,s2,0x3
    80001026:	9926                	add	s2,s2,s1
    80001028:	00093483          	ld	s1,0(s2)
    8000102c:	0014f793          	andi	a5,s1,1
    80001030:	dfd5                	beqz	a5,80000fec <walk+0x36>
    80001032:	80a9                	srli	s1,s1,0xa
    80001034:	04b2                	slli	s1,s1,0xc
    80001036:	b7c5                	j	80001016 <walk+0x60>
    80001038:	00c9d513          	srli	a0,s3,0xc
    8000103c:	1ff57513          	andi	a0,a0,511
    80001040:	050e                	slli	a0,a0,0x3
    80001042:	9526                	add	a0,a0,s1
    80001044:	70e2                	ld	ra,56(sp)
    80001046:	7442                	ld	s0,48(sp)
    80001048:	74a2                	ld	s1,40(sp)
    8000104a:	7902                	ld	s2,32(sp)
    8000104c:	69e2                	ld	s3,24(sp)
    8000104e:	6a42                	ld	s4,16(sp)
    80001050:	6aa2                	ld	s5,8(sp)
    80001052:	6b02                	ld	s6,0(sp)
    80001054:	6121                	addi	sp,sp,64
    80001056:	8082                	ret
    80001058:	4501                	li	a0,0
    8000105a:	b7ed                	j	80001044 <walk+0x8e>

000000008000105c <walkaddr>:
    8000105c:	57fd                	li	a5,-1
    8000105e:	83e9                	srli	a5,a5,0x1a
    80001060:	00b7f463          	bgeu	a5,a1,80001068 <walkaddr+0xc>
    80001064:	4501                	li	a0,0
    80001066:	8082                	ret
    80001068:	1141                	addi	sp,sp,-16
    8000106a:	e406                	sd	ra,8(sp)
    8000106c:	e022                	sd	s0,0(sp)
    8000106e:	0800                	addi	s0,sp,16
    80001070:	4601                	li	a2,0
    80001072:	00000097          	auipc	ra,0x0
    80001076:	f44080e7          	jalr	-188(ra) # 80000fb6 <walk>
    8000107a:	c105                	beqz	a0,8000109a <walkaddr+0x3e>
    8000107c:	611c                	ld	a5,0(a0)
    8000107e:	0117f693          	andi	a3,a5,17
    80001082:	4745                	li	a4,17
    80001084:	4501                	li	a0,0
    80001086:	00e68663          	beq	a3,a4,80001092 <walkaddr+0x36>
    8000108a:	60a2                	ld	ra,8(sp)
    8000108c:	6402                	ld	s0,0(sp)
    8000108e:	0141                	addi	sp,sp,16
    80001090:	8082                	ret
    80001092:	00a7d513          	srli	a0,a5,0xa
    80001096:	0532                	slli	a0,a0,0xc
    80001098:	bfcd                	j	8000108a <walkaddr+0x2e>
    8000109a:	4501                	li	a0,0
    8000109c:	b7fd                	j	8000108a <walkaddr+0x2e>

000000008000109e <mappages>:
    8000109e:	715d                	addi	sp,sp,-80
    800010a0:	e486                	sd	ra,72(sp)
    800010a2:	e0a2                	sd	s0,64(sp)
    800010a4:	fc26                	sd	s1,56(sp)
    800010a6:	f84a                	sd	s2,48(sp)
    800010a8:	f44e                	sd	s3,40(sp)
    800010aa:	f052                	sd	s4,32(sp)
    800010ac:	ec56                	sd	s5,24(sp)
    800010ae:	e85a                	sd	s6,16(sp)
    800010b0:	e45e                	sd	s7,8(sp)
    800010b2:	0880                	addi	s0,sp,80
    800010b4:	c639                	beqz	a2,80001102 <mappages+0x64>
    800010b6:	8aaa                	mv	s5,a0
    800010b8:	8b3a                	mv	s6,a4
    800010ba:	77fd                	lui	a5,0xfffff
    800010bc:	00f5fa33          	and	s4,a1,a5
    800010c0:	15fd                	addi	a1,a1,-1
    800010c2:	00c589b3          	add	s3,a1,a2
    800010c6:	00f9f9b3          	and	s3,s3,a5
    800010ca:	8952                	mv	s2,s4
    800010cc:	41468a33          	sub	s4,a3,s4
    800010d0:	6b85                	lui	s7,0x1
    800010d2:	012a04b3          	add	s1,s4,s2
    800010d6:	4605                	li	a2,1
    800010d8:	85ca                	mv	a1,s2
    800010da:	8556                	mv	a0,s5
    800010dc:	00000097          	auipc	ra,0x0
    800010e0:	eda080e7          	jalr	-294(ra) # 80000fb6 <walk>
    800010e4:	cd1d                	beqz	a0,80001122 <mappages+0x84>
    800010e6:	611c                	ld	a5,0(a0)
    800010e8:	8b85                	andi	a5,a5,1
    800010ea:	e785                	bnez	a5,80001112 <mappages+0x74>
    800010ec:	80b1                	srli	s1,s1,0xc
    800010ee:	04aa                	slli	s1,s1,0xa
    800010f0:	0164e4b3          	or	s1,s1,s6
    800010f4:	0014e493          	ori	s1,s1,1
    800010f8:	e104                	sd	s1,0(a0)
    800010fa:	05390063          	beq	s2,s3,8000113a <mappages+0x9c>
    800010fe:	995e                	add	s2,s2,s7
    80001100:	bfc9                	j	800010d2 <mappages+0x34>
    80001102:	00007517          	auipc	a0,0x7
    80001106:	fd650513          	addi	a0,a0,-42 # 800080d8 <digits+0x98>
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	434080e7          	jalr	1076(ra) # 8000053e <panic>
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fd650513          	addi	a0,a0,-42 # 800080e8 <digits+0xa8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	424080e7          	jalr	1060(ra) # 8000053e <panic>
    80001122:	557d                	li	a0,-1
    80001124:	60a6                	ld	ra,72(sp)
    80001126:	6406                	ld	s0,64(sp)
    80001128:	74e2                	ld	s1,56(sp)
    8000112a:	7942                	ld	s2,48(sp)
    8000112c:	79a2                	ld	s3,40(sp)
    8000112e:	7a02                	ld	s4,32(sp)
    80001130:	6ae2                	ld	s5,24(sp)
    80001132:	6b42                	ld	s6,16(sp)
    80001134:	6ba2                	ld	s7,8(sp)
    80001136:	6161                	addi	sp,sp,80
    80001138:	8082                	ret
    8000113a:	4501                	li	a0,0
    8000113c:	b7e5                	j	80001124 <mappages+0x86>

000000008000113e <kvmmap>:
    8000113e:	1141                	addi	sp,sp,-16
    80001140:	e406                	sd	ra,8(sp)
    80001142:	e022                	sd	s0,0(sp)
    80001144:	0800                	addi	s0,sp,16
    80001146:	87b6                	mv	a5,a3
    80001148:	86b2                	mv	a3,a2
    8000114a:	863e                	mv	a2,a5
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	f52080e7          	jalr	-174(ra) # 8000109e <mappages>
    80001154:	e509                	bnez	a0,8000115e <kvmmap+0x20>
    80001156:	60a2                	ld	ra,8(sp)
    80001158:	6402                	ld	s0,0(sp)
    8000115a:	0141                	addi	sp,sp,16
    8000115c:	8082                	ret
    8000115e:	00007517          	auipc	a0,0x7
    80001162:	f9a50513          	addi	a0,a0,-102 # 800080f8 <digits+0xb8>
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3d8080e7          	jalr	984(ra) # 8000053e <panic>

000000008000116e <kvmmake>:
    8000116e:	1101                	addi	sp,sp,-32
    80001170:	ec06                	sd	ra,24(sp)
    80001172:	e822                	sd	s0,16(sp)
    80001174:	e426                	sd	s1,8(sp)
    80001176:	e04a                	sd	s2,0(sp)
    80001178:	1000                	addi	s0,sp,32
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	96c080e7          	jalr	-1684(ra) # 80000ae6 <kalloc>
    80001182:	84aa                	mv	s1,a0
    80001184:	6605                	lui	a2,0x1
    80001186:	4581                	li	a1,0
    80001188:	00000097          	auipc	ra,0x0
    8000118c:	b4a080e7          	jalr	-1206(ra) # 80000cd2 <memset>
    80001190:	4719                	li	a4,6
    80001192:	6685                	lui	a3,0x1
    80001194:	10000637          	lui	a2,0x10000
    80001198:	100005b7          	lui	a1,0x10000
    8000119c:	8526                	mv	a0,s1
    8000119e:	00000097          	auipc	ra,0x0
    800011a2:	fa0080e7          	jalr	-96(ra) # 8000113e <kvmmap>
    800011a6:	4719                	li	a4,6
    800011a8:	6685                	lui	a3,0x1
    800011aa:	10001637          	lui	a2,0x10001
    800011ae:	100015b7          	lui	a1,0x10001
    800011b2:	8526                	mv	a0,s1
    800011b4:	00000097          	auipc	ra,0x0
    800011b8:	f8a080e7          	jalr	-118(ra) # 8000113e <kvmmap>
    800011bc:	4719                	li	a4,6
    800011be:	004006b7          	lui	a3,0x400
    800011c2:	0c000637          	lui	a2,0xc000
    800011c6:	0c0005b7          	lui	a1,0xc000
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f72080e7          	jalr	-142(ra) # 8000113e <kvmmap>
    800011d4:	00007917          	auipc	s2,0x7
    800011d8:	e2c90913          	addi	s2,s2,-468 # 80008000 <etext>
    800011dc:	4729                	li	a4,10
    800011de:	80007697          	auipc	a3,0x80007
    800011e2:	e2268693          	addi	a3,a3,-478 # 8000 <_entry-0x7fff8000>
    800011e6:	4605                	li	a2,1
    800011e8:	067e                	slli	a2,a2,0x1f
    800011ea:	85b2                	mv	a1,a2
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	f50080e7          	jalr	-176(ra) # 8000113e <kvmmap>
    800011f6:	4719                	li	a4,6
    800011f8:	46c5                	li	a3,17
    800011fa:	06ee                	slli	a3,a3,0x1b
    800011fc:	412686b3          	sub	a3,a3,s2
    80001200:	864a                	mv	a2,s2
    80001202:	85ca                	mv	a1,s2
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	f38080e7          	jalr	-200(ra) # 8000113e <kvmmap>
    8000120e:	4729                	li	a4,10
    80001210:	6685                	lui	a3,0x1
    80001212:	00006617          	auipc	a2,0x6
    80001216:	dee60613          	addi	a2,a2,-530 # 80007000 <_trampoline>
    8000121a:	040005b7          	lui	a1,0x4000
    8000121e:	15fd                	addi	a1,a1,-1
    80001220:	05b2                	slli	a1,a1,0xc
    80001222:	8526                	mv	a0,s1
    80001224:	00000097          	auipc	ra,0x0
    80001228:	f1a080e7          	jalr	-230(ra) # 8000113e <kvmmap>
    8000122c:	8526                	mv	a0,s1
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	608080e7          	jalr	1544(ra) # 80001836 <proc_mapstacks>
    80001236:	8526                	mv	a0,s1
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6902                	ld	s2,0(sp)
    80001240:	6105                	addi	sp,sp,32
    80001242:	8082                	ret

0000000080001244 <kvminit>:
    80001244:	1141                	addi	sp,sp,-16
    80001246:	e406                	sd	ra,8(sp)
    80001248:	e022                	sd	s0,0(sp)
    8000124a:	0800                	addi	s0,sp,16
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	f22080e7          	jalr	-222(ra) # 8000116e <kvmmake>
    80001254:	00007797          	auipc	a5,0x7
    80001258:	68a7b623          	sd	a0,1676(a5) # 800088e0 <kernel_pagetable>
    8000125c:	60a2                	ld	ra,8(sp)
    8000125e:	6402                	ld	s0,0(sp)
    80001260:	0141                	addi	sp,sp,16
    80001262:	8082                	ret

0000000080001264 <uvmunmap>:
    80001264:	715d                	addi	sp,sp,-80
    80001266:	e486                	sd	ra,72(sp)
    80001268:	e0a2                	sd	s0,64(sp)
    8000126a:	fc26                	sd	s1,56(sp)
    8000126c:	f84a                	sd	s2,48(sp)
    8000126e:	f44e                	sd	s3,40(sp)
    80001270:	f052                	sd	s4,32(sp)
    80001272:	ec56                	sd	s5,24(sp)
    80001274:	e85a                	sd	s6,16(sp)
    80001276:	e45e                	sd	s7,8(sp)
    80001278:	0880                	addi	s0,sp,80
    8000127a:	03459793          	slli	a5,a1,0x34
    8000127e:	e795                	bnez	a5,800012aa <uvmunmap+0x46>
    80001280:	8a2a                	mv	s4,a0
    80001282:	892e                	mv	s2,a1
    80001284:	8ab6                	mv	s5,a3
    80001286:	0632                	slli	a2,a2,0xc
    80001288:	00b609b3          	add	s3,a2,a1
    8000128c:	4b85                	li	s7,1
    8000128e:	6b05                	lui	s6,0x1
    80001290:	0735e263          	bltu	a1,s3,800012f4 <uvmunmap+0x90>
    80001294:	60a6                	ld	ra,72(sp)
    80001296:	6406                	ld	s0,64(sp)
    80001298:	74e2                	ld	s1,56(sp)
    8000129a:	7942                	ld	s2,48(sp)
    8000129c:	79a2                	ld	s3,40(sp)
    8000129e:	7a02                	ld	s4,32(sp)
    800012a0:	6ae2                	ld	s5,24(sp)
    800012a2:	6b42                	ld	s6,16(sp)
    800012a4:	6ba2                	ld	s7,8(sp)
    800012a6:	6161                	addi	sp,sp,80
    800012a8:	8082                	ret
    800012aa:	00007517          	auipc	a0,0x7
    800012ae:	e5650513          	addi	a0,a0,-426 # 80008100 <digits+0xc0>
    800012b2:	fffff097          	auipc	ra,0xfffff
    800012b6:	28c080e7          	jalr	652(ra) # 8000053e <panic>
    800012ba:	00007517          	auipc	a0,0x7
    800012be:	e5e50513          	addi	a0,a0,-418 # 80008118 <digits+0xd8>
    800012c2:	fffff097          	auipc	ra,0xfffff
    800012c6:	27c080e7          	jalr	636(ra) # 8000053e <panic>
    800012ca:	00007517          	auipc	a0,0x7
    800012ce:	e5e50513          	addi	a0,a0,-418 # 80008128 <digits+0xe8>
    800012d2:	fffff097          	auipc	ra,0xfffff
    800012d6:	26c080e7          	jalr	620(ra) # 8000053e <panic>
    800012da:	00007517          	auipc	a0,0x7
    800012de:	e6650513          	addi	a0,a0,-410 # 80008140 <digits+0x100>
    800012e2:	fffff097          	auipc	ra,0xfffff
    800012e6:	25c080e7          	jalr	604(ra) # 8000053e <panic>
    800012ea:	0004b023          	sd	zero,0(s1)
    800012ee:	995a                	add	s2,s2,s6
    800012f0:	fb3972e3          	bgeu	s2,s3,80001294 <uvmunmap+0x30>
    800012f4:	4601                	li	a2,0
    800012f6:	85ca                	mv	a1,s2
    800012f8:	8552                	mv	a0,s4
    800012fa:	00000097          	auipc	ra,0x0
    800012fe:	cbc080e7          	jalr	-836(ra) # 80000fb6 <walk>
    80001302:	84aa                	mv	s1,a0
    80001304:	d95d                	beqz	a0,800012ba <uvmunmap+0x56>
    80001306:	6108                	ld	a0,0(a0)
    80001308:	00157793          	andi	a5,a0,1
    8000130c:	dfdd                	beqz	a5,800012ca <uvmunmap+0x66>
    8000130e:	3ff57793          	andi	a5,a0,1023
    80001312:	fd7784e3          	beq	a5,s7,800012da <uvmunmap+0x76>
    80001316:	fc0a8ae3          	beqz	s5,800012ea <uvmunmap+0x86>
    8000131a:	8129                	srli	a0,a0,0xa
    8000131c:	0532                	slli	a0,a0,0xc
    8000131e:	fffff097          	auipc	ra,0xfffff
    80001322:	6cc080e7          	jalr	1740(ra) # 800009ea <kfree>
    80001326:	b7d1                	j	800012ea <uvmunmap+0x86>

0000000080001328 <uvmcreate>:
    80001328:	1101                	addi	sp,sp,-32
    8000132a:	ec06                	sd	ra,24(sp)
    8000132c:	e822                	sd	s0,16(sp)
    8000132e:	e426                	sd	s1,8(sp)
    80001330:	1000                	addi	s0,sp,32
    80001332:	fffff097          	auipc	ra,0xfffff
    80001336:	7b4080e7          	jalr	1972(ra) # 80000ae6 <kalloc>
    8000133a:	84aa                	mv	s1,a0
    8000133c:	c519                	beqz	a0,8000134a <uvmcreate+0x22>
    8000133e:	6605                	lui	a2,0x1
    80001340:	4581                	li	a1,0
    80001342:	00000097          	auipc	ra,0x0
    80001346:	990080e7          	jalr	-1648(ra) # 80000cd2 <memset>
    8000134a:	8526                	mv	a0,s1
    8000134c:	60e2                	ld	ra,24(sp)
    8000134e:	6442                	ld	s0,16(sp)
    80001350:	64a2                	ld	s1,8(sp)
    80001352:	6105                	addi	sp,sp,32
    80001354:	8082                	ret

0000000080001356 <uvmfirst>:
    80001356:	7179                	addi	sp,sp,-48
    80001358:	f406                	sd	ra,40(sp)
    8000135a:	f022                	sd	s0,32(sp)
    8000135c:	ec26                	sd	s1,24(sp)
    8000135e:	e84a                	sd	s2,16(sp)
    80001360:	e44e                	sd	s3,8(sp)
    80001362:	e052                	sd	s4,0(sp)
    80001364:	1800                	addi	s0,sp,48
    80001366:	6785                	lui	a5,0x1
    80001368:	04f67863          	bgeu	a2,a5,800013b8 <uvmfirst+0x62>
    8000136c:	8a2a                	mv	s4,a0
    8000136e:	89ae                	mv	s3,a1
    80001370:	84b2                	mv	s1,a2
    80001372:	fffff097          	auipc	ra,0xfffff
    80001376:	774080e7          	jalr	1908(ra) # 80000ae6 <kalloc>
    8000137a:	892a                	mv	s2,a0
    8000137c:	6605                	lui	a2,0x1
    8000137e:	4581                	li	a1,0
    80001380:	00000097          	auipc	ra,0x0
    80001384:	952080e7          	jalr	-1710(ra) # 80000cd2 <memset>
    80001388:	4779                	li	a4,30
    8000138a:	86ca                	mv	a3,s2
    8000138c:	6605                	lui	a2,0x1
    8000138e:	4581                	li	a1,0
    80001390:	8552                	mv	a0,s4
    80001392:	00000097          	auipc	ra,0x0
    80001396:	d0c080e7          	jalr	-756(ra) # 8000109e <mappages>
    8000139a:	8626                	mv	a2,s1
    8000139c:	85ce                	mv	a1,s3
    8000139e:	854a                	mv	a0,s2
    800013a0:	00000097          	auipc	ra,0x0
    800013a4:	98e080e7          	jalr	-1650(ra) # 80000d2e <memmove>
    800013a8:	70a2                	ld	ra,40(sp)
    800013aa:	7402                	ld	s0,32(sp)
    800013ac:	64e2                	ld	s1,24(sp)
    800013ae:	6942                	ld	s2,16(sp)
    800013b0:	69a2                	ld	s3,8(sp)
    800013b2:	6a02                	ld	s4,0(sp)
    800013b4:	6145                	addi	sp,sp,48
    800013b6:	8082                	ret
    800013b8:	00007517          	auipc	a0,0x7
    800013bc:	da050513          	addi	a0,a0,-608 # 80008158 <digits+0x118>
    800013c0:	fffff097          	auipc	ra,0xfffff
    800013c4:	17e080e7          	jalr	382(ra) # 8000053e <panic>

00000000800013c8 <uvmdealloc>:
    800013c8:	1101                	addi	sp,sp,-32
    800013ca:	ec06                	sd	ra,24(sp)
    800013cc:	e822                	sd	s0,16(sp)
    800013ce:	e426                	sd	s1,8(sp)
    800013d0:	1000                	addi	s0,sp,32
    800013d2:	84ae                	mv	s1,a1
    800013d4:	00b67d63          	bgeu	a2,a1,800013ee <uvmdealloc+0x26>
    800013d8:	84b2                	mv	s1,a2
    800013da:	6785                	lui	a5,0x1
    800013dc:	17fd                	addi	a5,a5,-1
    800013de:	00f60733          	add	a4,a2,a5
    800013e2:	767d                	lui	a2,0xfffff
    800013e4:	8f71                	and	a4,a4,a2
    800013e6:	97ae                	add	a5,a5,a1
    800013e8:	8ff1                	and	a5,a5,a2
    800013ea:	00f76863          	bltu	a4,a5,800013fa <uvmdealloc+0x32>
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret
    800013fa:	8f99                	sub	a5,a5,a4
    800013fc:	83b1                	srli	a5,a5,0xc
    800013fe:	4685                	li	a3,1
    80001400:	0007861b          	sext.w	a2,a5
    80001404:	85ba                	mv	a1,a4
    80001406:	00000097          	auipc	ra,0x0
    8000140a:	e5e080e7          	jalr	-418(ra) # 80001264 <uvmunmap>
    8000140e:	b7c5                	j	800013ee <uvmdealloc+0x26>

0000000080001410 <uvmalloc>:
    80001410:	0ab66563          	bltu	a2,a1,800014ba <uvmalloc+0xaa>
    80001414:	7139                	addi	sp,sp,-64
    80001416:	fc06                	sd	ra,56(sp)
    80001418:	f822                	sd	s0,48(sp)
    8000141a:	f426                	sd	s1,40(sp)
    8000141c:	f04a                	sd	s2,32(sp)
    8000141e:	ec4e                	sd	s3,24(sp)
    80001420:	e852                	sd	s4,16(sp)
    80001422:	e456                	sd	s5,8(sp)
    80001424:	e05a                	sd	s6,0(sp)
    80001426:	0080                	addi	s0,sp,64
    80001428:	8aaa                	mv	s5,a0
    8000142a:	8a32                	mv	s4,a2
    8000142c:	6985                	lui	s3,0x1
    8000142e:	19fd                	addi	s3,s3,-1
    80001430:	95ce                	add	a1,a1,s3
    80001432:	79fd                	lui	s3,0xfffff
    80001434:	0135f9b3          	and	s3,a1,s3
    80001438:	08c9f363          	bgeu	s3,a2,800014be <uvmalloc+0xae>
    8000143c:	894e                	mv	s2,s3
    8000143e:	0126eb13          	ori	s6,a3,18
    80001442:	fffff097          	auipc	ra,0xfffff
    80001446:	6a4080e7          	jalr	1700(ra) # 80000ae6 <kalloc>
    8000144a:	84aa                	mv	s1,a0
    8000144c:	c51d                	beqz	a0,8000147a <uvmalloc+0x6a>
    8000144e:	6605                	lui	a2,0x1
    80001450:	4581                	li	a1,0
    80001452:	00000097          	auipc	ra,0x0
    80001456:	880080e7          	jalr	-1920(ra) # 80000cd2 <memset>
    8000145a:	875a                	mv	a4,s6
    8000145c:	86a6                	mv	a3,s1
    8000145e:	6605                	lui	a2,0x1
    80001460:	85ca                	mv	a1,s2
    80001462:	8556                	mv	a0,s5
    80001464:	00000097          	auipc	ra,0x0
    80001468:	c3a080e7          	jalr	-966(ra) # 8000109e <mappages>
    8000146c:	e90d                	bnez	a0,8000149e <uvmalloc+0x8e>
    8000146e:	6785                	lui	a5,0x1
    80001470:	993e                	add	s2,s2,a5
    80001472:	fd4968e3          	bltu	s2,s4,80001442 <uvmalloc+0x32>
    80001476:	8552                	mv	a0,s4
    80001478:	a809                	j	8000148a <uvmalloc+0x7a>
    8000147a:	864e                	mv	a2,s3
    8000147c:	85ca                	mv	a1,s2
    8000147e:	8556                	mv	a0,s5
    80001480:	00000097          	auipc	ra,0x0
    80001484:	f48080e7          	jalr	-184(ra) # 800013c8 <uvmdealloc>
    80001488:	4501                	li	a0,0
    8000148a:	70e2                	ld	ra,56(sp)
    8000148c:	7442                	ld	s0,48(sp)
    8000148e:	74a2                	ld	s1,40(sp)
    80001490:	7902                	ld	s2,32(sp)
    80001492:	69e2                	ld	s3,24(sp)
    80001494:	6a42                	ld	s4,16(sp)
    80001496:	6aa2                	ld	s5,8(sp)
    80001498:	6b02                	ld	s6,0(sp)
    8000149a:	6121                	addi	sp,sp,64
    8000149c:	8082                	ret
    8000149e:	8526                	mv	a0,s1
    800014a0:	fffff097          	auipc	ra,0xfffff
    800014a4:	54a080e7          	jalr	1354(ra) # 800009ea <kfree>
    800014a8:	864e                	mv	a2,s3
    800014aa:	85ca                	mv	a1,s2
    800014ac:	8556                	mv	a0,s5
    800014ae:	00000097          	auipc	ra,0x0
    800014b2:	f1a080e7          	jalr	-230(ra) # 800013c8 <uvmdealloc>
    800014b6:	4501                	li	a0,0
    800014b8:	bfc9                	j	8000148a <uvmalloc+0x7a>
    800014ba:	852e                	mv	a0,a1
    800014bc:	8082                	ret
    800014be:	8532                	mv	a0,a2
    800014c0:	b7e9                	j	8000148a <uvmalloc+0x7a>

00000000800014c2 <freewalk>:
    800014c2:	7179                	addi	sp,sp,-48
    800014c4:	f406                	sd	ra,40(sp)
    800014c6:	f022                	sd	s0,32(sp)
    800014c8:	ec26                	sd	s1,24(sp)
    800014ca:	e84a                	sd	s2,16(sp)
    800014cc:	e44e                	sd	s3,8(sp)
    800014ce:	e052                	sd	s4,0(sp)
    800014d0:	1800                	addi	s0,sp,48
    800014d2:	8a2a                	mv	s4,a0
    800014d4:	84aa                	mv	s1,a0
    800014d6:	6905                	lui	s2,0x1
    800014d8:	992a                	add	s2,s2,a0
    800014da:	4985                	li	s3,1
    800014dc:	a821                	j	800014f4 <freewalk+0x32>
    800014de:	8129                	srli	a0,a0,0xa
    800014e0:	0532                	slli	a0,a0,0xc
    800014e2:	00000097          	auipc	ra,0x0
    800014e6:	fe0080e7          	jalr	-32(ra) # 800014c2 <freewalk>
    800014ea:	0004b023          	sd	zero,0(s1)
    800014ee:	04a1                	addi	s1,s1,8
    800014f0:	03248163          	beq	s1,s2,80001512 <freewalk+0x50>
    800014f4:	6088                	ld	a0,0(s1)
    800014f6:	00f57793          	andi	a5,a0,15
    800014fa:	ff3782e3          	beq	a5,s3,800014de <freewalk+0x1c>
    800014fe:	8905                	andi	a0,a0,1
    80001500:	d57d                	beqz	a0,800014ee <freewalk+0x2c>
    80001502:	00007517          	auipc	a0,0x7
    80001506:	c7650513          	addi	a0,a0,-906 # 80008178 <digits+0x138>
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	034080e7          	jalr	52(ra) # 8000053e <panic>
    80001512:	8552                	mv	a0,s4
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	4d6080e7          	jalr	1238(ra) # 800009ea <kfree>
    8000151c:	70a2                	ld	ra,40(sp)
    8000151e:	7402                	ld	s0,32(sp)
    80001520:	64e2                	ld	s1,24(sp)
    80001522:	6942                	ld	s2,16(sp)
    80001524:	69a2                	ld	s3,8(sp)
    80001526:	6a02                	ld	s4,0(sp)
    80001528:	6145                	addi	sp,sp,48
    8000152a:	8082                	ret

000000008000152c <uvmfree>:
    8000152c:	1101                	addi	sp,sp,-32
    8000152e:	ec06                	sd	ra,24(sp)
    80001530:	e822                	sd	s0,16(sp)
    80001532:	e426                	sd	s1,8(sp)
    80001534:	1000                	addi	s0,sp,32
    80001536:	84aa                	mv	s1,a0
    80001538:	e999                	bnez	a1,8000154e <uvmfree+0x22>
    8000153a:	8526                	mv	a0,s1
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	f86080e7          	jalr	-122(ra) # 800014c2 <freewalk>
    80001544:	60e2                	ld	ra,24(sp)
    80001546:	6442                	ld	s0,16(sp)
    80001548:	64a2                	ld	s1,8(sp)
    8000154a:	6105                	addi	sp,sp,32
    8000154c:	8082                	ret
    8000154e:	6605                	lui	a2,0x1
    80001550:	167d                	addi	a2,a2,-1
    80001552:	962e                	add	a2,a2,a1
    80001554:	4685                	li	a3,1
    80001556:	8231                	srli	a2,a2,0xc
    80001558:	4581                	li	a1,0
    8000155a:	00000097          	auipc	ra,0x0
    8000155e:	d0a080e7          	jalr	-758(ra) # 80001264 <uvmunmap>
    80001562:	bfe1                	j	8000153a <uvmfree+0xe>

0000000080001564 <uvmcopy>:
    80001564:	c679                	beqz	a2,80001632 <uvmcopy+0xce>
    80001566:	715d                	addi	sp,sp,-80
    80001568:	e486                	sd	ra,72(sp)
    8000156a:	e0a2                	sd	s0,64(sp)
    8000156c:	fc26                	sd	s1,56(sp)
    8000156e:	f84a                	sd	s2,48(sp)
    80001570:	f44e                	sd	s3,40(sp)
    80001572:	f052                	sd	s4,32(sp)
    80001574:	ec56                	sd	s5,24(sp)
    80001576:	e85a                	sd	s6,16(sp)
    80001578:	e45e                	sd	s7,8(sp)
    8000157a:	0880                	addi	s0,sp,80
    8000157c:	8b2a                	mv	s6,a0
    8000157e:	8aae                	mv	s5,a1
    80001580:	8a32                	mv	s4,a2
    80001582:	4981                	li	s3,0
    80001584:	4601                	li	a2,0
    80001586:	85ce                	mv	a1,s3
    80001588:	855a                	mv	a0,s6
    8000158a:	00000097          	auipc	ra,0x0
    8000158e:	a2c080e7          	jalr	-1492(ra) # 80000fb6 <walk>
    80001592:	c531                	beqz	a0,800015de <uvmcopy+0x7a>
    80001594:	6118                	ld	a4,0(a0)
    80001596:	00177793          	andi	a5,a4,1
    8000159a:	cbb1                	beqz	a5,800015ee <uvmcopy+0x8a>
    8000159c:	00a75593          	srli	a1,a4,0xa
    800015a0:	00c59b93          	slli	s7,a1,0xc
    800015a4:	3ff77493          	andi	s1,a4,1023
    800015a8:	fffff097          	auipc	ra,0xfffff
    800015ac:	53e080e7          	jalr	1342(ra) # 80000ae6 <kalloc>
    800015b0:	892a                	mv	s2,a0
    800015b2:	c939                	beqz	a0,80001608 <uvmcopy+0xa4>
    800015b4:	6605                	lui	a2,0x1
    800015b6:	85de                	mv	a1,s7
    800015b8:	fffff097          	auipc	ra,0xfffff
    800015bc:	776080e7          	jalr	1910(ra) # 80000d2e <memmove>
    800015c0:	8726                	mv	a4,s1
    800015c2:	86ca                	mv	a3,s2
    800015c4:	6605                	lui	a2,0x1
    800015c6:	85ce                	mv	a1,s3
    800015c8:	8556                	mv	a0,s5
    800015ca:	00000097          	auipc	ra,0x0
    800015ce:	ad4080e7          	jalr	-1324(ra) # 8000109e <mappages>
    800015d2:	e515                	bnez	a0,800015fe <uvmcopy+0x9a>
    800015d4:	6785                	lui	a5,0x1
    800015d6:	99be                	add	s3,s3,a5
    800015d8:	fb49e6e3          	bltu	s3,s4,80001584 <uvmcopy+0x20>
    800015dc:	a081                	j	8000161c <uvmcopy+0xb8>
    800015de:	00007517          	auipc	a0,0x7
    800015e2:	baa50513          	addi	a0,a0,-1110 # 80008188 <digits+0x148>
    800015e6:	fffff097          	auipc	ra,0xfffff
    800015ea:	f58080e7          	jalr	-168(ra) # 8000053e <panic>
    800015ee:	00007517          	auipc	a0,0x7
    800015f2:	bba50513          	addi	a0,a0,-1094 # 800081a8 <digits+0x168>
    800015f6:	fffff097          	auipc	ra,0xfffff
    800015fa:	f48080e7          	jalr	-184(ra) # 8000053e <panic>
    800015fe:	854a                	mv	a0,s2
    80001600:	fffff097          	auipc	ra,0xfffff
    80001604:	3ea080e7          	jalr	1002(ra) # 800009ea <kfree>
    80001608:	4685                	li	a3,1
    8000160a:	00c9d613          	srli	a2,s3,0xc
    8000160e:	4581                	li	a1,0
    80001610:	8556                	mv	a0,s5
    80001612:	00000097          	auipc	ra,0x0
    80001616:	c52080e7          	jalr	-942(ra) # 80001264 <uvmunmap>
    8000161a:	557d                	li	a0,-1
    8000161c:	60a6                	ld	ra,72(sp)
    8000161e:	6406                	ld	s0,64(sp)
    80001620:	74e2                	ld	s1,56(sp)
    80001622:	7942                	ld	s2,48(sp)
    80001624:	79a2                	ld	s3,40(sp)
    80001626:	7a02                	ld	s4,32(sp)
    80001628:	6ae2                	ld	s5,24(sp)
    8000162a:	6b42                	ld	s6,16(sp)
    8000162c:	6ba2                	ld	s7,8(sp)
    8000162e:	6161                	addi	sp,sp,80
    80001630:	8082                	ret
    80001632:	4501                	li	a0,0
    80001634:	8082                	ret

0000000080001636 <uvmclear>:
    80001636:	1141                	addi	sp,sp,-16
    80001638:	e406                	sd	ra,8(sp)
    8000163a:	e022                	sd	s0,0(sp)
    8000163c:	0800                	addi	s0,sp,16
    8000163e:	4601                	li	a2,0
    80001640:	00000097          	auipc	ra,0x0
    80001644:	976080e7          	jalr	-1674(ra) # 80000fb6 <walk>
    80001648:	c901                	beqz	a0,80001658 <uvmclear+0x22>
    8000164a:	611c                	ld	a5,0(a0)
    8000164c:	9bbd                	andi	a5,a5,-17
    8000164e:	e11c                	sd	a5,0(a0)
    80001650:	60a2                	ld	ra,8(sp)
    80001652:	6402                	ld	s0,0(sp)
    80001654:	0141                	addi	sp,sp,16
    80001656:	8082                	ret
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b7050513          	addi	a0,a0,-1168 # 800081c8 <digits+0x188>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	ede080e7          	jalr	-290(ra) # 8000053e <panic>

0000000080001668 <copyout>:
    80001668:	c6bd                	beqz	a3,800016d6 <copyout+0x6e>
    8000166a:	715d                	addi	sp,sp,-80
    8000166c:	e486                	sd	ra,72(sp)
    8000166e:	e0a2                	sd	s0,64(sp)
    80001670:	fc26                	sd	s1,56(sp)
    80001672:	f84a                	sd	s2,48(sp)
    80001674:	f44e                	sd	s3,40(sp)
    80001676:	f052                	sd	s4,32(sp)
    80001678:	ec56                	sd	s5,24(sp)
    8000167a:	e85a                	sd	s6,16(sp)
    8000167c:	e45e                	sd	s7,8(sp)
    8000167e:	e062                	sd	s8,0(sp)
    80001680:	0880                	addi	s0,sp,80
    80001682:	8b2a                	mv	s6,a0
    80001684:	8c2e                	mv	s8,a1
    80001686:	8a32                	mv	s4,a2
    80001688:	89b6                	mv	s3,a3
    8000168a:	7bfd                	lui	s7,0xfffff
    8000168c:	6a85                	lui	s5,0x1
    8000168e:	a015                	j	800016b2 <copyout+0x4a>
    80001690:	9562                	add	a0,a0,s8
    80001692:	0004861b          	sext.w	a2,s1
    80001696:	85d2                	mv	a1,s4
    80001698:	41250533          	sub	a0,a0,s2
    8000169c:	fffff097          	auipc	ra,0xfffff
    800016a0:	692080e7          	jalr	1682(ra) # 80000d2e <memmove>
    800016a4:	409989b3          	sub	s3,s3,s1
    800016a8:	9a26                	add	s4,s4,s1
    800016aa:	01590c33          	add	s8,s2,s5
    800016ae:	02098263          	beqz	s3,800016d2 <copyout+0x6a>
    800016b2:	017c7933          	and	s2,s8,s7
    800016b6:	85ca                	mv	a1,s2
    800016b8:	855a                	mv	a0,s6
    800016ba:	00000097          	auipc	ra,0x0
    800016be:	9a2080e7          	jalr	-1630(ra) # 8000105c <walkaddr>
    800016c2:	cd01                	beqz	a0,800016da <copyout+0x72>
    800016c4:	418904b3          	sub	s1,s2,s8
    800016c8:	94d6                	add	s1,s1,s5
    800016ca:	fc99f3e3          	bgeu	s3,s1,80001690 <copyout+0x28>
    800016ce:	84ce                	mv	s1,s3
    800016d0:	b7c1                	j	80001690 <copyout+0x28>
    800016d2:	4501                	li	a0,0
    800016d4:	a021                	j	800016dc <copyout+0x74>
    800016d6:	4501                	li	a0,0
    800016d8:	8082                	ret
    800016da:	557d                	li	a0,-1
    800016dc:	60a6                	ld	ra,72(sp)
    800016de:	6406                	ld	s0,64(sp)
    800016e0:	74e2                	ld	s1,56(sp)
    800016e2:	7942                	ld	s2,48(sp)
    800016e4:	79a2                	ld	s3,40(sp)
    800016e6:	7a02                	ld	s4,32(sp)
    800016e8:	6ae2                	ld	s5,24(sp)
    800016ea:	6b42                	ld	s6,16(sp)
    800016ec:	6ba2                	ld	s7,8(sp)
    800016ee:	6c02                	ld	s8,0(sp)
    800016f0:	6161                	addi	sp,sp,80
    800016f2:	8082                	ret

00000000800016f4 <copyin>:
    800016f4:	caa5                	beqz	a3,80001764 <copyin+0x70>
    800016f6:	715d                	addi	sp,sp,-80
    800016f8:	e486                	sd	ra,72(sp)
    800016fa:	e0a2                	sd	s0,64(sp)
    800016fc:	fc26                	sd	s1,56(sp)
    800016fe:	f84a                	sd	s2,48(sp)
    80001700:	f44e                	sd	s3,40(sp)
    80001702:	f052                	sd	s4,32(sp)
    80001704:	ec56                	sd	s5,24(sp)
    80001706:	e85a                	sd	s6,16(sp)
    80001708:	e45e                	sd	s7,8(sp)
    8000170a:	e062                	sd	s8,0(sp)
    8000170c:	0880                	addi	s0,sp,80
    8000170e:	8b2a                	mv	s6,a0
    80001710:	8a2e                	mv	s4,a1
    80001712:	8c32                	mv	s8,a2
    80001714:	89b6                	mv	s3,a3
    80001716:	7bfd                	lui	s7,0xfffff
    80001718:	6a85                	lui	s5,0x1
    8000171a:	a01d                	j	80001740 <copyin+0x4c>
    8000171c:	018505b3          	add	a1,a0,s8
    80001720:	0004861b          	sext.w	a2,s1
    80001724:	412585b3          	sub	a1,a1,s2
    80001728:	8552                	mv	a0,s4
    8000172a:	fffff097          	auipc	ra,0xfffff
    8000172e:	604080e7          	jalr	1540(ra) # 80000d2e <memmove>
    80001732:	409989b3          	sub	s3,s3,s1
    80001736:	9a26                	add	s4,s4,s1
    80001738:	01590c33          	add	s8,s2,s5
    8000173c:	02098263          	beqz	s3,80001760 <copyin+0x6c>
    80001740:	017c7933          	and	s2,s8,s7
    80001744:	85ca                	mv	a1,s2
    80001746:	855a                	mv	a0,s6
    80001748:	00000097          	auipc	ra,0x0
    8000174c:	914080e7          	jalr	-1772(ra) # 8000105c <walkaddr>
    80001750:	cd01                	beqz	a0,80001768 <copyin+0x74>
    80001752:	418904b3          	sub	s1,s2,s8
    80001756:	94d6                	add	s1,s1,s5
    80001758:	fc99f2e3          	bgeu	s3,s1,8000171c <copyin+0x28>
    8000175c:	84ce                	mv	s1,s3
    8000175e:	bf7d                	j	8000171c <copyin+0x28>
    80001760:	4501                	li	a0,0
    80001762:	a021                	j	8000176a <copyin+0x76>
    80001764:	4501                	li	a0,0
    80001766:	8082                	ret
    80001768:	557d                	li	a0,-1
    8000176a:	60a6                	ld	ra,72(sp)
    8000176c:	6406                	ld	s0,64(sp)
    8000176e:	74e2                	ld	s1,56(sp)
    80001770:	7942                	ld	s2,48(sp)
    80001772:	79a2                	ld	s3,40(sp)
    80001774:	7a02                	ld	s4,32(sp)
    80001776:	6ae2                	ld	s5,24(sp)
    80001778:	6b42                	ld	s6,16(sp)
    8000177a:	6ba2                	ld	s7,8(sp)
    8000177c:	6c02                	ld	s8,0(sp)
    8000177e:	6161                	addi	sp,sp,80
    80001780:	8082                	ret

0000000080001782 <copyinstr>:
    80001782:	c6c5                	beqz	a3,8000182a <copyinstr+0xa8>
    80001784:	715d                	addi	sp,sp,-80
    80001786:	e486                	sd	ra,72(sp)
    80001788:	e0a2                	sd	s0,64(sp)
    8000178a:	fc26                	sd	s1,56(sp)
    8000178c:	f84a                	sd	s2,48(sp)
    8000178e:	f44e                	sd	s3,40(sp)
    80001790:	f052                	sd	s4,32(sp)
    80001792:	ec56                	sd	s5,24(sp)
    80001794:	e85a                	sd	s6,16(sp)
    80001796:	e45e                	sd	s7,8(sp)
    80001798:	0880                	addi	s0,sp,80
    8000179a:	8a2a                	mv	s4,a0
    8000179c:	8b2e                	mv	s6,a1
    8000179e:	8bb2                	mv	s7,a2
    800017a0:	84b6                	mv	s1,a3
    800017a2:	7afd                	lui	s5,0xfffff
    800017a4:	6985                	lui	s3,0x1
    800017a6:	a035                	j	800017d2 <copyinstr+0x50>
    800017a8:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800017ac:	4785                	li	a5,1
    800017ae:	0017b793          	seqz	a5,a5
    800017b2:	40f00533          	neg	a0,a5
    800017b6:	60a6                	ld	ra,72(sp)
    800017b8:	6406                	ld	s0,64(sp)
    800017ba:	74e2                	ld	s1,56(sp)
    800017bc:	7942                	ld	s2,48(sp)
    800017be:	79a2                	ld	s3,40(sp)
    800017c0:	7a02                	ld	s4,32(sp)
    800017c2:	6ae2                	ld	s5,24(sp)
    800017c4:	6b42                	ld	s6,16(sp)
    800017c6:	6ba2                	ld	s7,8(sp)
    800017c8:	6161                	addi	sp,sp,80
    800017ca:	8082                	ret
    800017cc:	01390bb3          	add	s7,s2,s3
    800017d0:	c8a9                	beqz	s1,80001822 <copyinstr+0xa0>
    800017d2:	015bf933          	and	s2,s7,s5
    800017d6:	85ca                	mv	a1,s2
    800017d8:	8552                	mv	a0,s4
    800017da:	00000097          	auipc	ra,0x0
    800017de:	882080e7          	jalr	-1918(ra) # 8000105c <walkaddr>
    800017e2:	c131                	beqz	a0,80001826 <copyinstr+0xa4>
    800017e4:	41790833          	sub	a6,s2,s7
    800017e8:	984e                	add	a6,a6,s3
    800017ea:	0104f363          	bgeu	s1,a6,800017f0 <copyinstr+0x6e>
    800017ee:	8826                	mv	a6,s1
    800017f0:	955e                	add	a0,a0,s7
    800017f2:	41250533          	sub	a0,a0,s2
    800017f6:	fc080be3          	beqz	a6,800017cc <copyinstr+0x4a>
    800017fa:	985a                	add	a6,a6,s6
    800017fc:	87da                	mv	a5,s6
    800017fe:	41650633          	sub	a2,a0,s6
    80001802:	14fd                	addi	s1,s1,-1
    80001804:	9b26                	add	s6,s6,s1
    80001806:	00f60733          	add	a4,a2,a5
    8000180a:	00074703          	lbu	a4,0(a4)
    8000180e:	df49                	beqz	a4,800017a8 <copyinstr+0x26>
    80001810:	00e78023          	sb	a4,0(a5)
    80001814:	40fb04b3          	sub	s1,s6,a5
    80001818:	0785                	addi	a5,a5,1
    8000181a:	ff0796e3          	bne	a5,a6,80001806 <copyinstr+0x84>
    8000181e:	8b42                	mv	s6,a6
    80001820:	b775                	j	800017cc <copyinstr+0x4a>
    80001822:	4781                	li	a5,0
    80001824:	b769                	j	800017ae <copyinstr+0x2c>
    80001826:	557d                	li	a0,-1
    80001828:	b779                	j	800017b6 <copyinstr+0x34>
    8000182a:	4781                	li	a5,0
    8000182c:	0017b793          	seqz	a5,a5
    80001830:	40f00533          	neg	a0,a5
    80001834:	8082                	ret

0000000080001836 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001836:	7139                	addi	sp,sp,-64
    80001838:	fc06                	sd	ra,56(sp)
    8000183a:	f822                	sd	s0,48(sp)
    8000183c:	f426                	sd	s1,40(sp)
    8000183e:	f04a                	sd	s2,32(sp)
    80001840:	ec4e                	sd	s3,24(sp)
    80001842:	e852                	sd	s4,16(sp)
    80001844:	e456                	sd	s5,8(sp)
    80001846:	e05a                	sd	s6,0(sp)
    80001848:	0080                	addi	s0,sp,64
    8000184a:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    8000184c:	0000f497          	auipc	s1,0xf
    80001850:	74448493          	addi	s1,s1,1860 # 80010f90 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001854:	8b26                	mv	s6,s1
    80001856:	00006a97          	auipc	s5,0x6
    8000185a:	7aaa8a93          	addi	s5,s5,1962 # 80008000 <etext>
    8000185e:	04000937          	lui	s2,0x4000
    80001862:	197d                	addi	s2,s2,-1
    80001864:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001866:	00016a17          	auipc	s4,0x16
    8000186a:	52aa0a13          	addi	s4,s4,1322 # 80017d90 <tickslock>
    char *pa = kalloc();
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	278080e7          	jalr	632(ra) # 80000ae6 <kalloc>
    80001876:	862a                	mv	a2,a0
    if (pa == 0)
    80001878:	c131                	beqz	a0,800018bc <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    8000187a:	416485b3          	sub	a1,s1,s6
    8000187e:	858d                	srai	a1,a1,0x3
    80001880:	000ab783          	ld	a5,0(s5)
    80001884:	02f585b3          	mul	a1,a1,a5
    80001888:	2585                	addiw	a1,a1,1
    8000188a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000188e:	4719                	li	a4,6
    80001890:	6685                	lui	a3,0x1
    80001892:	40b905b3          	sub	a1,s2,a1
    80001896:	854e                	mv	a0,s3
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	8a6080e7          	jalr	-1882(ra) # 8000113e <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    800018a0:	1b848493          	addi	s1,s1,440
    800018a4:	fd4495e3          	bne	s1,s4,8000186e <proc_mapstacks+0x38>
  }
}
    800018a8:	70e2                	ld	ra,56(sp)
    800018aa:	7442                	ld	s0,48(sp)
    800018ac:	74a2                	ld	s1,40(sp)
    800018ae:	7902                	ld	s2,32(sp)
    800018b0:	69e2                	ld	s3,24(sp)
    800018b2:	6a42                	ld	s4,16(sp)
    800018b4:	6aa2                	ld	s5,8(sp)
    800018b6:	6b02                	ld	s6,0(sp)
    800018b8:	6121                	addi	sp,sp,64
    800018ba:	8082                	ret
      panic("kalloc");
    800018bc:	00007517          	auipc	a0,0x7
    800018c0:	91c50513          	addi	a0,a0,-1764 # 800081d8 <digits+0x198>
    800018c4:	fffff097          	auipc	ra,0xfffff
    800018c8:	c7a080e7          	jalr	-902(ra) # 8000053e <panic>

00000000800018cc <procinit>:

// initialize the proc table.
void procinit(void)
{
    800018cc:	7139                	addi	sp,sp,-64
    800018ce:	fc06                	sd	ra,56(sp)
    800018d0:	f822                	sd	s0,48(sp)
    800018d2:	f426                	sd	s1,40(sp)
    800018d4:	f04a                	sd	s2,32(sp)
    800018d6:	ec4e                	sd	s3,24(sp)
    800018d8:	e852                	sd	s4,16(sp)
    800018da:	e456                	sd	s5,8(sp)
    800018dc:	e05a                	sd	s6,0(sp)
    800018de:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    800018e0:	00007597          	auipc	a1,0x7
    800018e4:	90058593          	addi	a1,a1,-1792 # 800081e0 <digits+0x1a0>
    800018e8:	0000f517          	auipc	a0,0xf
    800018ec:	27850513          	addi	a0,a0,632 # 80010b60 <pid_lock>
    800018f0:	fffff097          	auipc	ra,0xfffff
    800018f4:	256080e7          	jalr	598(ra) # 80000b46 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8f058593          	addi	a1,a1,-1808 # 800081e8 <digits+0x1a8>
    80001900:	0000f517          	auipc	a0,0xf
    80001904:	27850513          	addi	a0,a0,632 # 80010b78 <wait_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	23e080e7          	jalr	574(ra) # 80000b46 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001910:	0000f497          	auipc	s1,0xf
    80001914:	68048493          	addi	s1,s1,1664 # 80010f90 <proc>
  {
    initlock(&p->lock, "proc");
    80001918:	00007b17          	auipc	s6,0x7
    8000191c:	8e0b0b13          	addi	s6,s6,-1824 # 800081f8 <digits+0x1b8>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001920:	8aa6                	mv	s5,s1
    80001922:	00006a17          	auipc	s4,0x6
    80001926:	6dea0a13          	addi	s4,s4,1758 # 80008000 <etext>
    8000192a:	04000937          	lui	s2,0x4000
    8000192e:	197d                	addi	s2,s2,-1
    80001930:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001932:	00016997          	auipc	s3,0x16
    80001936:	45e98993          	addi	s3,s3,1118 # 80017d90 <tickslock>
    initlock(&p->lock, "proc");
    8000193a:	85da                	mv	a1,s6
    8000193c:	8526                	mv	a0,s1
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	208080e7          	jalr	520(ra) # 80000b46 <initlock>
    p->state = UNUSED;
    80001946:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000194a:	415487b3          	sub	a5,s1,s5
    8000194e:	878d                	srai	a5,a5,0x3
    80001950:	000a3703          	ld	a4,0(s4)
    80001954:	02e787b3          	mul	a5,a5,a4
    80001958:	2785                	addiw	a5,a5,1
    8000195a:	00d7979b          	slliw	a5,a5,0xd
    8000195e:	40f907b3          	sub	a5,s2,a5
    80001962:	e0dc                	sd	a5,128(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001964:	1b848493          	addi	s1,s1,440
    80001968:	fd3499e3          	bne	s1,s3,8000193a <procinit+0x6e>
  }
}
    8000196c:	70e2                	ld	ra,56(sp)
    8000196e:	7442                	ld	s0,48(sp)
    80001970:	74a2                	ld	s1,40(sp)
    80001972:	7902                	ld	s2,32(sp)
    80001974:	69e2                	ld	s3,24(sp)
    80001976:	6a42                	ld	s4,16(sp)
    80001978:	6aa2                	ld	s5,8(sp)
    8000197a:	6b02                	ld	s6,0(sp)
    8000197c:	6121                	addi	sp,sp,64
    8000197e:	8082                	ret

0000000080001980 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001980:	1141                	addi	sp,sp,-16
    80001982:	e422                	sd	s0,8(sp)
    80001984:	0800                	addi	s0,sp,16
// this core's hartid (core number), the index into cpus[].
static inline uint64
r_tp()
{
  uint64 x;
  asm volatile("mv %0, tp" : "=r" (x) );
    80001986:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001988:	2501                	sext.w	a0,a0
    8000198a:	6422                	ld	s0,8(sp)
    8000198c:	0141                	addi	sp,sp,16
    8000198e:	8082                	ret

0000000080001990 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001990:	1141                	addi	sp,sp,-16
    80001992:	e422                	sd	s0,8(sp)
    80001994:	0800                	addi	s0,sp,16
    80001996:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001998:	2781                	sext.w	a5,a5
    8000199a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000199c:	0000f517          	auipc	a0,0xf
    800019a0:	1f450513          	addi	a0,a0,500 # 80010b90 <cpus>
    800019a4:	953e                	add	a0,a0,a5
    800019a6:	6422                	ld	s0,8(sp)
    800019a8:	0141                	addi	sp,sp,16
    800019aa:	8082                	ret

00000000800019ac <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800019ac:	1101                	addi	sp,sp,-32
    800019ae:	ec06                	sd	ra,24(sp)
    800019b0:	e822                	sd	s0,16(sp)
    800019b2:	e426                	sd	s1,8(sp)
    800019b4:	1000                	addi	s0,sp,32
  push_off();
    800019b6:	fffff097          	auipc	ra,0xfffff
    800019ba:	1d4080e7          	jalr	468(ra) # 80000b8a <push_off>
    800019be:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800019c0:	2781                	sext.w	a5,a5
    800019c2:	079e                	slli	a5,a5,0x7
    800019c4:	0000f717          	auipc	a4,0xf
    800019c8:	19c70713          	addi	a4,a4,412 # 80010b60 <pid_lock>
    800019cc:	97ba                	add	a5,a5,a4
    800019ce:	7b84                	ld	s1,48(a5)
  pop_off();
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	25a080e7          	jalr	602(ra) # 80000c2a <pop_off>
  return p;
}
    800019d8:	8526                	mv	a0,s1
    800019da:	60e2                	ld	ra,24(sp)
    800019dc:	6442                	ld	s0,16(sp)
    800019de:	64a2                	ld	s1,8(sp)
    800019e0:	6105                	addi	sp,sp,32
    800019e2:	8082                	ret

00000000800019e4 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    800019e4:	1141                	addi	sp,sp,-16
    800019e6:	e406                	sd	ra,8(sp)
    800019e8:	e022                	sd	s0,0(sp)
    800019ea:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019ec:	00000097          	auipc	ra,0x0
    800019f0:	fc0080e7          	jalr	-64(ra) # 800019ac <myproc>
    800019f4:	fffff097          	auipc	ra,0xfffff
    800019f8:	296080e7          	jalr	662(ra) # 80000c8a <release>

  if (first)
    800019fc:	00007797          	auipc	a5,0x7
    80001a00:	e747a783          	lw	a5,-396(a5) # 80008870 <first.1>
    80001a04:	eb89                	bnez	a5,80001a16 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001a06:	00001097          	auipc	ra,0x1
    80001a0a:	efc080e7          	jalr	-260(ra) # 80002902 <usertrapret>
}
    80001a0e:	60a2                	ld	ra,8(sp)
    80001a10:	6402                	ld	s0,0(sp)
    80001a12:	0141                	addi	sp,sp,16
    80001a14:	8082                	ret
    first = 0;
    80001a16:	00007797          	auipc	a5,0x7
    80001a1a:	e407ad23          	sw	zero,-422(a5) # 80008870 <first.1>
    fsinit(ROOTDEV);
    80001a1e:	4505                	li	a0,1
    80001a20:	00002097          	auipc	ra,0x2
    80001a24:	2ee080e7          	jalr	750(ra) # 80003d0e <fsinit>
    80001a28:	bff9                	j	80001a06 <forkret+0x22>

0000000080001a2a <allocpid>:
{
    80001a2a:	1101                	addi	sp,sp,-32
    80001a2c:	ec06                	sd	ra,24(sp)
    80001a2e:	e822                	sd	s0,16(sp)
    80001a30:	e426                	sd	s1,8(sp)
    80001a32:	e04a                	sd	s2,0(sp)
    80001a34:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a36:	0000f917          	auipc	s2,0xf
    80001a3a:	12a90913          	addi	s2,s2,298 # 80010b60 <pid_lock>
    80001a3e:	854a                	mv	a0,s2
    80001a40:	fffff097          	auipc	ra,0xfffff
    80001a44:	196080e7          	jalr	406(ra) # 80000bd6 <acquire>
  pid = nextpid;
    80001a48:	00007797          	auipc	a5,0x7
    80001a4c:	e2c78793          	addi	a5,a5,-468 # 80008874 <nextpid>
    80001a50:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a52:	0014871b          	addiw	a4,s1,1
    80001a56:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a58:	854a                	mv	a0,s2
    80001a5a:	fffff097          	auipc	ra,0xfffff
    80001a5e:	230080e7          	jalr	560(ra) # 80000c8a <release>
}
    80001a62:	8526                	mv	a0,s1
    80001a64:	60e2                	ld	ra,24(sp)
    80001a66:	6442                	ld	s0,16(sp)
    80001a68:	64a2                	ld	s1,8(sp)
    80001a6a:	6902                	ld	s2,0(sp)
    80001a6c:	6105                	addi	sp,sp,32
    80001a6e:	8082                	ret

0000000080001a70 <proc_pagetable>:
{
    80001a70:	1101                	addi	sp,sp,-32
    80001a72:	ec06                	sd	ra,24(sp)
    80001a74:	e822                	sd	s0,16(sp)
    80001a76:	e426                	sd	s1,8(sp)
    80001a78:	e04a                	sd	s2,0(sp)
    80001a7a:	1000                	addi	s0,sp,32
    80001a7c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a7e:	00000097          	auipc	ra,0x0
    80001a82:	8aa080e7          	jalr	-1878(ra) # 80001328 <uvmcreate>
    80001a86:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001a88:	c121                	beqz	a0,80001ac8 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a8a:	4729                	li	a4,10
    80001a8c:	00005697          	auipc	a3,0x5
    80001a90:	57468693          	addi	a3,a3,1396 # 80007000 <_trampoline>
    80001a94:	6605                	lui	a2,0x1
    80001a96:	040005b7          	lui	a1,0x4000
    80001a9a:	15fd                	addi	a1,a1,-1
    80001a9c:	05b2                	slli	a1,a1,0xc
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	600080e7          	jalr	1536(ra) # 8000109e <mappages>
    80001aa6:	02054863          	bltz	a0,80001ad6 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001aaa:	4719                	li	a4,6
    80001aac:	09893683          	ld	a3,152(s2)
    80001ab0:	6605                	lui	a2,0x1
    80001ab2:	020005b7          	lui	a1,0x2000
    80001ab6:	15fd                	addi	a1,a1,-1
    80001ab8:	05b6                	slli	a1,a1,0xd
    80001aba:	8526                	mv	a0,s1
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	5e2080e7          	jalr	1506(ra) # 8000109e <mappages>
    80001ac4:	02054163          	bltz	a0,80001ae6 <proc_pagetable+0x76>
}
    80001ac8:	8526                	mv	a0,s1
    80001aca:	60e2                	ld	ra,24(sp)
    80001acc:	6442                	ld	s0,16(sp)
    80001ace:	64a2                	ld	s1,8(sp)
    80001ad0:	6902                	ld	s2,0(sp)
    80001ad2:	6105                	addi	sp,sp,32
    80001ad4:	8082                	ret
    uvmfree(pagetable, 0);
    80001ad6:	4581                	li	a1,0
    80001ad8:	8526                	mv	a0,s1
    80001ada:	00000097          	auipc	ra,0x0
    80001ade:	a52080e7          	jalr	-1454(ra) # 8000152c <uvmfree>
    return 0;
    80001ae2:	4481                	li	s1,0
    80001ae4:	b7d5                	j	80001ac8 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ae6:	4681                	li	a3,0
    80001ae8:	4605                	li	a2,1
    80001aea:	040005b7          	lui	a1,0x4000
    80001aee:	15fd                	addi	a1,a1,-1
    80001af0:	05b2                	slli	a1,a1,0xc
    80001af2:	8526                	mv	a0,s1
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	770080e7          	jalr	1904(ra) # 80001264 <uvmunmap>
    uvmfree(pagetable, 0);
    80001afc:	4581                	li	a1,0
    80001afe:	8526                	mv	a0,s1
    80001b00:	00000097          	auipc	ra,0x0
    80001b04:	a2c080e7          	jalr	-1492(ra) # 8000152c <uvmfree>
    return 0;
    80001b08:	4481                	li	s1,0
    80001b0a:	bf7d                	j	80001ac8 <proc_pagetable+0x58>

0000000080001b0c <proc_freepagetable>:
{
    80001b0c:	1101                	addi	sp,sp,-32
    80001b0e:	ec06                	sd	ra,24(sp)
    80001b10:	e822                	sd	s0,16(sp)
    80001b12:	e426                	sd	s1,8(sp)
    80001b14:	e04a                	sd	s2,0(sp)
    80001b16:	1000                	addi	s0,sp,32
    80001b18:	84aa                	mv	s1,a0
    80001b1a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1c:	4681                	li	a3,0
    80001b1e:	4605                	li	a2,1
    80001b20:	040005b7          	lui	a1,0x4000
    80001b24:	15fd                	addi	a1,a1,-1
    80001b26:	05b2                	slli	a1,a1,0xc
    80001b28:	fffff097          	auipc	ra,0xfffff
    80001b2c:	73c080e7          	jalr	1852(ra) # 80001264 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b30:	4681                	li	a3,0
    80001b32:	4605                	li	a2,1
    80001b34:	020005b7          	lui	a1,0x2000
    80001b38:	15fd                	addi	a1,a1,-1
    80001b3a:	05b6                	slli	a1,a1,0xd
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	726080e7          	jalr	1830(ra) # 80001264 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b46:	85ca                	mv	a1,s2
    80001b48:	8526                	mv	a0,s1
    80001b4a:	00000097          	auipc	ra,0x0
    80001b4e:	9e2080e7          	jalr	-1566(ra) # 8000152c <uvmfree>
}
    80001b52:	60e2                	ld	ra,24(sp)
    80001b54:	6442                	ld	s0,16(sp)
    80001b56:	64a2                	ld	s1,8(sp)
    80001b58:	6902                	ld	s2,0(sp)
    80001b5a:	6105                	addi	sp,sp,32
    80001b5c:	8082                	ret

0000000080001b5e <freeproc>:
{
    80001b5e:	1101                	addi	sp,sp,-32
    80001b60:	ec06                	sd	ra,24(sp)
    80001b62:	e822                	sd	s0,16(sp)
    80001b64:	e426                	sd	s1,8(sp)
    80001b66:	1000                	addi	s0,sp,32
    80001b68:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001b6a:	6d48                	ld	a0,152(a0)
    80001b6c:	c509                	beqz	a0,80001b76 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001b6e:	fffff097          	auipc	ra,0xfffff
    80001b72:	e7c080e7          	jalr	-388(ra) # 800009ea <kfree>
  p->trapframe = 0;
    80001b76:	0804bc23          	sd	zero,152(s1)
  if (p->pagetable)
    80001b7a:	68c8                	ld	a0,144(s1)
    80001b7c:	c511                	beqz	a0,80001b88 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b7e:	64cc                	ld	a1,136(s1)
    80001b80:	00000097          	auipc	ra,0x0
    80001b84:	f8c080e7          	jalr	-116(ra) # 80001b0c <proc_freepagetable>
  p->pagetable = 0;
    80001b88:	0804b823          	sd	zero,144(s1)
  p->sz = 0;
    80001b8c:	0804b423          	sd	zero,136(s1)
  p->pid = 0;
    80001b90:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b94:	0604bc23          	sd	zero,120(s1)
  p->name[0] = 0;
    80001b98:	18048c23          	sb	zero,408(s1)
  p->chan = 0;
    80001b9c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ba0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ba4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ba8:	0004ac23          	sw	zero,24(s1)
}
    80001bac:	60e2                	ld	ra,24(sp)
    80001bae:	6442                	ld	s0,16(sp)
    80001bb0:	64a2                	ld	s1,8(sp)
    80001bb2:	6105                	addi	sp,sp,32
    80001bb4:	8082                	ret

0000000080001bb6 <allocproc>:
{
    80001bb6:	1101                	addi	sp,sp,-32
    80001bb8:	ec06                	sd	ra,24(sp)
    80001bba:	e822                	sd	s0,16(sp)
    80001bbc:	e426                	sd	s1,8(sp)
    80001bbe:	e04a                	sd	s2,0(sp)
    80001bc0:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001bc2:	0000f497          	auipc	s1,0xf
    80001bc6:	3ce48493          	addi	s1,s1,974 # 80010f90 <proc>
    80001bca:	00016917          	auipc	s2,0x16
    80001bce:	1c690913          	addi	s2,s2,454 # 80017d90 <tickslock>
    acquire(&p->lock);
    80001bd2:	8526                	mv	a0,s1
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	002080e7          	jalr	2(ra) # 80000bd6 <acquire>
    if (p->state == UNUSED)
    80001bdc:	4c9c                	lw	a5,24(s1)
    80001bde:	cf81                	beqz	a5,80001bf6 <allocproc+0x40>
      release(&p->lock);
    80001be0:	8526                	mv	a0,s1
    80001be2:	fffff097          	auipc	ra,0xfffff
    80001be6:	0a8080e7          	jalr	168(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001bea:	1b848493          	addi	s1,s1,440
    80001bee:	ff2492e3          	bne	s1,s2,80001bd2 <allocproc+0x1c>
  return 0;
    80001bf2:	4481                	li	s1,0
    80001bf4:	a069                	j	80001c7e <allocproc+0xc8>
  p->pid = allocpid();
    80001bf6:	00000097          	auipc	ra,0x0
    80001bfa:	e34080e7          	jalr	-460(ra) # 80001a2a <allocpid>
    80001bfe:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001c00:	4785                	li	a5,1
    80001c02:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001c04:	fffff097          	auipc	ra,0xfffff
    80001c08:	ee2080e7          	jalr	-286(ra) # 80000ae6 <kalloc>
    80001c0c:	892a                	mv	s2,a0
    80001c0e:	ecc8                	sd	a0,152(s1)
    80001c10:	cd35                	beqz	a0,80001c8c <allocproc+0xd6>
  p->pagetable = proc_pagetable(p);
    80001c12:	8526                	mv	a0,s1
    80001c14:	00000097          	auipc	ra,0x0
    80001c18:	e5c080e7          	jalr	-420(ra) # 80001a70 <proc_pagetable>
    80001c1c:	892a                	mv	s2,a0
    80001c1e:	e8c8                	sd	a0,144(s1)
  if (p->pagetable == 0)
    80001c20:	c151                	beqz	a0,80001ca4 <allocproc+0xee>
  memset(&p->context, 0, sizeof(p->context));
    80001c22:	07000613          	li	a2,112
    80001c26:	4581                	li	a1,0
    80001c28:	0a048513          	addi	a0,s1,160
    80001c2c:	fffff097          	auipc	ra,0xfffff
    80001c30:	0a6080e7          	jalr	166(ra) # 80000cd2 <memset>
  p->context.ra = (uint64)forkret;
    80001c34:	00000797          	auipc	a5,0x0
    80001c38:	db078793          	addi	a5,a5,-592 # 800019e4 <forkret>
    80001c3c:	f0dc                	sd	a5,160(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c3e:	60dc                	ld	a5,128(s1)
    80001c40:	6705                	lui	a4,0x1
    80001c42:	97ba                	add	a5,a5,a4
    80001c44:	f4dc                	sd	a5,168(s1)
  p->rtime = 0;
    80001c46:	1a04a423          	sw	zero,424(s1)
  p->etime = 0;
    80001c4a:	1a04a823          	sw	zero,432(s1)
  p->ctime = ticks;
    80001c4e:	00007797          	auipc	a5,0x7
    80001c52:	ca27a783          	lw	a5,-862(a5) # 800088f0 <ticks>
    80001c56:	1af4a623          	sw	a5,428(s1)
  p->ticks = 0;
    80001c5a:	0204bc23          	sd	zero,56(s1)
  p->ishandler = 0;
    80001c5e:	0404b823          	sd	zero,80(s1)
  p->currentticks = 0;
    80001c62:	0404b023          	sd	zero,64(s1)
  p->funcadr = 0;
    80001c66:	0404b423          	sd	zero,72(s1)
  p->sliceticks = 0;
    80001c6a:	0604a223          	sw	zero,100(s1)
  p->queue = 0;
    80001c6e:	0604a023          	sw	zero,96(s1)
  p->flagforio = 0; // 0 for not waiting for io, 1 for waiting for io
    80001c72:	0604a623          	sw	zero,108(s1)
  p->slicetime = 1;
    80001c76:	4785                	li	a5,1
    80001c78:	d4bc                	sw	a5,104(s1)
  p->timeofwait = 0;
    80001c7a:	0604a823          	sw	zero,112(s1)
}
    80001c7e:	8526                	mv	a0,s1
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	64a2                	ld	s1,8(sp)
    80001c86:	6902                	ld	s2,0(sp)
    80001c88:	6105                	addi	sp,sp,32
    80001c8a:	8082                	ret
    freeproc(p);
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00000097          	auipc	ra,0x0
    80001c92:	ed0080e7          	jalr	-304(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001c96:	8526                	mv	a0,s1
    80001c98:	fffff097          	auipc	ra,0xfffff
    80001c9c:	ff2080e7          	jalr	-14(ra) # 80000c8a <release>
    return 0;
    80001ca0:	84ca                	mv	s1,s2
    80001ca2:	bff1                	j	80001c7e <allocproc+0xc8>
    freeproc(p);
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	00000097          	auipc	ra,0x0
    80001caa:	eb8080e7          	jalr	-328(ra) # 80001b5e <freeproc>
    release(&p->lock);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	fda080e7          	jalr	-38(ra) # 80000c8a <release>
    return 0;
    80001cb8:	84ca                	mv	s1,s2
    80001cba:	b7d1                	j	80001c7e <allocproc+0xc8>

0000000080001cbc <userinit>:
{
    80001cbc:	1101                	addi	sp,sp,-32
    80001cbe:	ec06                	sd	ra,24(sp)
    80001cc0:	e822                	sd	s0,16(sp)
    80001cc2:	e426                	sd	s1,8(sp)
    80001cc4:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	ef0080e7          	jalr	-272(ra) # 80001bb6 <allocproc>
    80001cce:	84aa                	mv	s1,a0
  initproc = p;
    80001cd0:	00007797          	auipc	a5,0x7
    80001cd4:	c0a7bc23          	sd	a0,-1000(a5) # 800088e8 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001cd8:	03400613          	li	a2,52
    80001cdc:	00007597          	auipc	a1,0x7
    80001ce0:	ba458593          	addi	a1,a1,-1116 # 80008880 <initcode>
    80001ce4:	6948                	ld	a0,144(a0)
    80001ce6:	fffff097          	auipc	ra,0xfffff
    80001cea:	670080e7          	jalr	1648(ra) # 80001356 <uvmfirst>
  p->sz = PGSIZE;
    80001cee:	6785                	lui	a5,0x1
    80001cf0:	e4dc                	sd	a5,136(s1)
  p->trapframe->epc = 0;     // user program counter
    80001cf2:	6cd8                	ld	a4,152(s1)
    80001cf4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001cf8:	6cd8                	ld	a4,152(s1)
    80001cfa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001cfc:	4641                	li	a2,16
    80001cfe:	00006597          	auipc	a1,0x6
    80001d02:	50258593          	addi	a1,a1,1282 # 80008200 <digits+0x1c0>
    80001d06:	19848513          	addi	a0,s1,408
    80001d0a:	fffff097          	auipc	ra,0xfffff
    80001d0e:	112080e7          	jalr	274(ra) # 80000e1c <safestrcpy>
  p->cwd = namei("/");
    80001d12:	00006517          	auipc	a0,0x6
    80001d16:	4fe50513          	addi	a0,a0,1278 # 80008210 <digits+0x1d0>
    80001d1a:	00003097          	auipc	ra,0x3
    80001d1e:	a16080e7          	jalr	-1514(ra) # 80004730 <namei>
    80001d22:	18a4b823          	sd	a0,400(s1)
  p->state = RUNNABLE;
    80001d26:	478d                	li	a5,3
    80001d28:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	fffff097          	auipc	ra,0xfffff
    80001d30:	f5e080e7          	jalr	-162(ra) # 80000c8a <release>
}
    80001d34:	60e2                	ld	ra,24(sp)
    80001d36:	6442                	ld	s0,16(sp)
    80001d38:	64a2                	ld	s1,8(sp)
    80001d3a:	6105                	addi	sp,sp,32
    80001d3c:	8082                	ret

0000000080001d3e <growproc>:
{
    80001d3e:	1101                	addi	sp,sp,-32
    80001d40:	ec06                	sd	ra,24(sp)
    80001d42:	e822                	sd	s0,16(sp)
    80001d44:	e426                	sd	s1,8(sp)
    80001d46:	e04a                	sd	s2,0(sp)
    80001d48:	1000                	addi	s0,sp,32
    80001d4a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001d4c:	00000097          	auipc	ra,0x0
    80001d50:	c60080e7          	jalr	-928(ra) # 800019ac <myproc>
    80001d54:	84aa                	mv	s1,a0
  sz = p->sz;
    80001d56:	654c                	ld	a1,136(a0)
  if (n > 0)
    80001d58:	01204c63          	bgtz	s2,80001d70 <growproc+0x32>
  else if (n < 0)
    80001d5c:	02094663          	bltz	s2,80001d88 <growproc+0x4a>
  p->sz = sz;
    80001d60:	e4cc                	sd	a1,136(s1)
  return 0;
    80001d62:	4501                	li	a0,0
}
    80001d64:	60e2                	ld	ra,24(sp)
    80001d66:	6442                	ld	s0,16(sp)
    80001d68:	64a2                	ld	s1,8(sp)
    80001d6a:	6902                	ld	s2,0(sp)
    80001d6c:	6105                	addi	sp,sp,32
    80001d6e:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80001d70:	4691                	li	a3,4
    80001d72:	00b90633          	add	a2,s2,a1
    80001d76:	6948                	ld	a0,144(a0)
    80001d78:	fffff097          	auipc	ra,0xfffff
    80001d7c:	698080e7          	jalr	1688(ra) # 80001410 <uvmalloc>
    80001d80:	85aa                	mv	a1,a0
    80001d82:	fd79                	bnez	a0,80001d60 <growproc+0x22>
      return -1;
    80001d84:	557d                	li	a0,-1
    80001d86:	bff9                	j	80001d64 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d88:	00b90633          	add	a2,s2,a1
    80001d8c:	6948                	ld	a0,144(a0)
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	63a080e7          	jalr	1594(ra) # 800013c8 <uvmdealloc>
    80001d96:	85aa                	mv	a1,a0
    80001d98:	b7e1                	j	80001d60 <growproc+0x22>

0000000080001d9a <fork>:
{
    80001d9a:	7139                	addi	sp,sp,-64
    80001d9c:	fc06                	sd	ra,56(sp)
    80001d9e:	f822                	sd	s0,48(sp)
    80001da0:	f426                	sd	s1,40(sp)
    80001da2:	f04a                	sd	s2,32(sp)
    80001da4:	ec4e                	sd	s3,24(sp)
    80001da6:	e852                	sd	s4,16(sp)
    80001da8:	e456                	sd	s5,8(sp)
    80001daa:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001dac:	00000097          	auipc	ra,0x0
    80001db0:	c00080e7          	jalr	-1024(ra) # 800019ac <myproc>
    80001db4:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001db6:	00000097          	auipc	ra,0x0
    80001dba:	e00080e7          	jalr	-512(ra) # 80001bb6 <allocproc>
    80001dbe:	10050c63          	beqz	a0,80001ed6 <fork+0x13c>
    80001dc2:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001dc4:	088ab603          	ld	a2,136(s5)
    80001dc8:	694c                	ld	a1,144(a0)
    80001dca:	090ab503          	ld	a0,144(s5)
    80001dce:	fffff097          	auipc	ra,0xfffff
    80001dd2:	796080e7          	jalr	1942(ra) # 80001564 <uvmcopy>
    80001dd6:	04054863          	bltz	a0,80001e26 <fork+0x8c>
  np->sz = p->sz;
    80001dda:	088ab783          	ld	a5,136(s5)
    80001dde:	08fa3423          	sd	a5,136(s4)
  *(np->trapframe) = *(p->trapframe);
    80001de2:	098ab683          	ld	a3,152(s5)
    80001de6:	87b6                	mv	a5,a3
    80001de8:	098a3703          	ld	a4,152(s4)
    80001dec:	12068693          	addi	a3,a3,288
    80001df0:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001df4:	6788                	ld	a0,8(a5)
    80001df6:	6b8c                	ld	a1,16(a5)
    80001df8:	6f90                	ld	a2,24(a5)
    80001dfa:	01073023          	sd	a6,0(a4)
    80001dfe:	e708                	sd	a0,8(a4)
    80001e00:	eb0c                	sd	a1,16(a4)
    80001e02:	ef10                	sd	a2,24(a4)
    80001e04:	02078793          	addi	a5,a5,32
    80001e08:	02070713          	addi	a4,a4,32
    80001e0c:	fed792e3          	bne	a5,a3,80001df0 <fork+0x56>
  np->trapframe->a0 = 0;
    80001e10:	098a3783          	ld	a5,152(s4)
    80001e14:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001e18:	110a8493          	addi	s1,s5,272
    80001e1c:	110a0913          	addi	s2,s4,272
    80001e20:	190a8993          	addi	s3,s5,400
    80001e24:	a00d                	j	80001e46 <fork+0xac>
    freeproc(np);
    80001e26:	8552                	mv	a0,s4
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	d36080e7          	jalr	-714(ra) # 80001b5e <freeproc>
    release(&np->lock);
    80001e30:	8552                	mv	a0,s4
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	e58080e7          	jalr	-424(ra) # 80000c8a <release>
    return -1;
    80001e3a:	597d                	li	s2,-1
    80001e3c:	a059                	j	80001ec2 <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    80001e3e:	04a1                	addi	s1,s1,8
    80001e40:	0921                	addi	s2,s2,8
    80001e42:	01348b63          	beq	s1,s3,80001e58 <fork+0xbe>
    if (p->ofile[i])
    80001e46:	6088                	ld	a0,0(s1)
    80001e48:	d97d                	beqz	a0,80001e3e <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e4a:	00003097          	auipc	ra,0x3
    80001e4e:	f7c080e7          	jalr	-132(ra) # 80004dc6 <filedup>
    80001e52:	00a93023          	sd	a0,0(s2)
    80001e56:	b7e5                	j	80001e3e <fork+0xa4>
  np->cwd = idup(p->cwd);
    80001e58:	190ab503          	ld	a0,400(s5)
    80001e5c:	00002097          	auipc	ra,0x2
    80001e60:	0f0080e7          	jalr	240(ra) # 80003f4c <idup>
    80001e64:	18aa3823          	sd	a0,400(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e68:	4641                	li	a2,16
    80001e6a:	198a8593          	addi	a1,s5,408
    80001e6e:	198a0513          	addi	a0,s4,408
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	faa080e7          	jalr	-86(ra) # 80000e1c <safestrcpy>
  pid = np->pid;
    80001e7a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001e7e:	8552                	mv	a0,s4
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	e0a080e7          	jalr	-502(ra) # 80000c8a <release>
  acquire(&wait_lock);
    80001e88:	0000f497          	auipc	s1,0xf
    80001e8c:	cf048493          	addi	s1,s1,-784 # 80010b78 <wait_lock>
    80001e90:	8526                	mv	a0,s1
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	d44080e7          	jalr	-700(ra) # 80000bd6 <acquire>
  np->parent = p;
    80001e9a:	075a3c23          	sd	s5,120(s4)
  release(&wait_lock);
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	dea080e7          	jalr	-534(ra) # 80000c8a <release>
  acquire(&np->lock);
    80001ea8:	8552                	mv	a0,s4
    80001eaa:	fffff097          	auipc	ra,0xfffff
    80001eae:	d2c080e7          	jalr	-724(ra) # 80000bd6 <acquire>
  np->state = RUNNABLE;
    80001eb2:	478d                	li	a5,3
    80001eb4:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001eb8:	8552                	mv	a0,s4
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	dd0080e7          	jalr	-560(ra) # 80000c8a <release>
}
    80001ec2:	854a                	mv	a0,s2
    80001ec4:	70e2                	ld	ra,56(sp)
    80001ec6:	7442                	ld	s0,48(sp)
    80001ec8:	74a2                	ld	s1,40(sp)
    80001eca:	7902                	ld	s2,32(sp)
    80001ecc:	69e2                	ld	s3,24(sp)
    80001ece:	6a42                	ld	s4,16(sp)
    80001ed0:	6aa2                	ld	s5,8(sp)
    80001ed2:	6121                	addi	sp,sp,64
    80001ed4:	8082                	ret
    return -1;
    80001ed6:	597d                	li	s2,-1
    80001ed8:	b7ed                	j	80001ec2 <fork+0x128>

0000000080001eda <scheduler>:
{
    80001eda:	7139                	addi	sp,sp,-64
    80001edc:	fc06                	sd	ra,56(sp)
    80001ede:	f822                	sd	s0,48(sp)
    80001ee0:	f426                	sd	s1,40(sp)
    80001ee2:	f04a                	sd	s2,32(sp)
    80001ee4:	ec4e                	sd	s3,24(sp)
    80001ee6:	e852                	sd	s4,16(sp)
    80001ee8:	e456                	sd	s5,8(sp)
    80001eea:	e05a                	sd	s6,0(sp)
    80001eec:	0080                	addi	s0,sp,64
    80001eee:	8792                	mv	a5,tp
  int id = r_tp();
    80001ef0:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001ef2:	00779693          	slli	a3,a5,0x7
    80001ef6:	0000f717          	auipc	a4,0xf
    80001efa:	c6a70713          	addi	a4,a4,-918 # 80010b60 <pid_lock>
    80001efe:	9736                	add	a4,a4,a3
    80001f00:	02073823          	sd	zero,48(a4)
      swtch(&c->context, &temp->context);
    80001f04:	0000f717          	auipc	a4,0xf
    80001f08:	c9470713          	addi	a4,a4,-876 # 80010b98 <cpus+0x8>
    80001f0c:	00e68b33          	add	s6,a3,a4
    int minqueue = 100;
    80001f10:	06400993          	li	s3,100
      if (p->state == RUNNABLE)
    80001f14:	448d                	li	s1,3
    for (p = proc; p < &proc[NPROC]; p++)
    80001f16:	00016917          	auipc	s2,0x16
    80001f1a:	e7a90913          	addi	s2,s2,-390 # 80017d90 <tickslock>
      c->proc = temp;
    80001f1e:	0000fa17          	auipc	s4,0xf
    80001f22:	c42a0a13          	addi	s4,s4,-958 # 80010b60 <pid_lock>
    80001f26:	9a36                	add	s4,s4,a3
    80001f28:	a045                	j	80001fc8 <scheduler+0xee>
    80001f2a:	0007069b          	sext.w	a3,a4
    for (p = proc; p < &proc[NPROC]; p++)
    80001f2e:	1b878793          	addi	a5,a5,440
    80001f32:	01278c63          	beq	a5,s2,80001f4a <scheduler+0x70>
      if (p->state == RUNNABLE)
    80001f36:	4f98                	lw	a4,24(a5)
    80001f38:	fe971be3          	bne	a4,s1,80001f2e <scheduler+0x54>
        if (p->queue < minqueue)
    80001f3c:	53b8                	lw	a4,96(a5)
    80001f3e:	0007061b          	sext.w	a2,a4
    80001f42:	fec6d4e3          	bge	a3,a2,80001f2a <scheduler+0x50>
    80001f46:	8736                	mv	a4,a3
    80001f48:	b7cd                	j	80001f2a <scheduler+0x50>
    for (p = proc; p < &proc[NPROC]; p++)
    80001f4a:	0000f797          	auipc	a5,0xf
    80001f4e:	04678793          	addi	a5,a5,70 # 80010f90 <proc>
    80001f52:	a029                	j	80001f5c <scheduler+0x82>
    80001f54:	1b878793          	addi	a5,a5,440
    80001f58:	07278863          	beq	a5,s2,80001fc8 <scheduler+0xee>
      if (p->state == RUNNABLE)
    80001f5c:	4f98                	lw	a4,24(a5)
    80001f5e:	fe971be3          	bne	a4,s1,80001f54 <scheduler+0x7a>
        if (p->queue == minqueue)
    80001f62:	53b8                	lw	a4,96(a5)
    80001f64:	fed718e3          	bne	a4,a3,80001f54 <scheduler+0x7a>
      for (p = proc; p < &proc[NPROC]; p++)
    80001f68:	0000fa97          	auipc	s5,0xf
    80001f6c:	028a8a93          	addi	s5,s5,40 # 80010f90 <proc>
        if (p->state == RUNNABLE && p->flagforio == 1 && p->queue == minqueue)
    80001f70:	4705                	li	a4,1
    80001f72:	a029                	j	80001f7c <scheduler+0xa2>
      for (p = proc; p < &proc[NPROC]; p++)
    80001f74:	1b8a8a93          	addi	s5,s5,440
    80001f78:	072a8463          	beq	s5,s2,80001fe0 <scheduler+0x106>
        if (p->state == RUNNABLE && p->flagforio == 1 && p->queue == minqueue)
    80001f7c:	018aa783          	lw	a5,24(s5)
    80001f80:	fe979ae3          	bne	a5,s1,80001f74 <scheduler+0x9a>
    80001f84:	06caa783          	lw	a5,108(s5)
    80001f88:	fee796e3          	bne	a5,a4,80001f74 <scheduler+0x9a>
    80001f8c:	060aa783          	lw	a5,96(s5)
    80001f90:	fed792e3          	bne	a5,a3,80001f74 <scheduler+0x9a>
      acquire(&temp->lock);
    80001f94:	8556                	mv	a0,s5
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	c40080e7          	jalr	-960(ra) # 80000bd6 <acquire>
      temp->state = RUNNING;
    80001f9e:	4791                	li	a5,4
    80001fa0:	00faac23          	sw	a5,24(s5)
      temp->timeofwait = 0;
    80001fa4:	060aa823          	sw	zero,112(s5)
      c->proc = temp;
    80001fa8:	035a3823          	sd	s5,48(s4)
      swtch(&c->context, &temp->context);
    80001fac:	0a0a8593          	addi	a1,s5,160
    80001fb0:	855a                	mv	a0,s6
    80001fb2:	00001097          	auipc	ra,0x1
    80001fb6:	8a6080e7          	jalr	-1882(ra) # 80002858 <swtch>
      c->proc = 0;
    80001fba:	020a3823          	sd	zero,48(s4)
      release(&temp->lock);
    80001fbe:	8556                	mv	a0,s5
    80001fc0:	fffff097          	auipc	ra,0xfffff
    80001fc4:	cca080e7          	jalr	-822(ra) # 80000c8a <release>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fc8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fcc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fd0:	10079073          	csrw	sstatus,a5
    int minqueue = 100;
    80001fd4:	86ce                	mv	a3,s3
    for (p = proc; p < &proc[NPROC]; p++)
    80001fd6:	0000f797          	auipc	a5,0xf
    80001fda:	fba78793          	addi	a5,a5,-70 # 80010f90 <proc>
    80001fde:	bfa1                	j	80001f36 <scheduler+0x5c>
        int maxwtime = -1;
    80001fe0:	567d                	li	a2,-1
        for (p = proc; p < &proc[NPROC]; p++)
    80001fe2:	0000f797          	auipc	a5,0xf
    80001fe6:	fae78793          	addi	a5,a5,-82 # 80010f90 <proc>
    80001fea:	a029                	j	80001ff4 <scheduler+0x11a>
    80001fec:	1b878793          	addi	a5,a5,440
    80001ff0:	fb2782e3          	beq	a5,s2,80001f94 <scheduler+0xba>
          if (p->state == RUNNABLE && p->queue == minqueue)
    80001ff4:	4f98                	lw	a4,24(a5)
    80001ff6:	fe971be3          	bne	a4,s1,80001fec <scheduler+0x112>
    80001ffa:	53b8                	lw	a4,96(a5)
    80001ffc:	fed718e3          	bne	a4,a3,80001fec <scheduler+0x112>
            if (p->timeofwait > maxwtime)
    80002000:	5bb8                	lw	a4,112(a5)
    80002002:	fee655e3          	bge	a2,a4,80001fec <scheduler+0x112>
    80002006:	8abe                	mv	s5,a5
              maxwtime = p->timeofwait;
    80002008:	863a                	mv	a2,a4
    8000200a:	b7cd                	j	80001fec <scheduler+0x112>

000000008000200c <sched>:
{
    8000200c:	7179                	addi	sp,sp,-48
    8000200e:	f406                	sd	ra,40(sp)
    80002010:	f022                	sd	s0,32(sp)
    80002012:	ec26                	sd	s1,24(sp)
    80002014:	e84a                	sd	s2,16(sp)
    80002016:	e44e                	sd	s3,8(sp)
    80002018:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000201a:	00000097          	auipc	ra,0x0
    8000201e:	992080e7          	jalr	-1646(ra) # 800019ac <myproc>
    80002022:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	b38080e7          	jalr	-1224(ra) # 80000b5c <holding>
    8000202c:	c93d                	beqz	a0,800020a2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000202e:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80002030:	2781                	sext.w	a5,a5
    80002032:	079e                	slli	a5,a5,0x7
    80002034:	0000f717          	auipc	a4,0xf
    80002038:	b2c70713          	addi	a4,a4,-1236 # 80010b60 <pid_lock>
    8000203c:	97ba                	add	a5,a5,a4
    8000203e:	0a87a703          	lw	a4,168(a5)
    80002042:	4785                	li	a5,1
    80002044:	06f71763          	bne	a4,a5,800020b2 <sched+0xa6>
  if (p->state == RUNNING)
    80002048:	4c98                	lw	a4,24(s1)
    8000204a:	4791                	li	a5,4
    8000204c:	06f70b63          	beq	a4,a5,800020c2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002050:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002054:	8b89                	andi	a5,a5,2
  if (intr_get())
    80002056:	efb5                	bnez	a5,800020d2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002058:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000205a:	0000f917          	auipc	s2,0xf
    8000205e:	b0690913          	addi	s2,s2,-1274 # 80010b60 <pid_lock>
    80002062:	2781                	sext.w	a5,a5
    80002064:	079e                	slli	a5,a5,0x7
    80002066:	97ca                	add	a5,a5,s2
    80002068:	0ac7a983          	lw	s3,172(a5)
    8000206c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000206e:	2781                	sext.w	a5,a5
    80002070:	079e                	slli	a5,a5,0x7
    80002072:	0000f597          	auipc	a1,0xf
    80002076:	b2658593          	addi	a1,a1,-1242 # 80010b98 <cpus+0x8>
    8000207a:	95be                	add	a1,a1,a5
    8000207c:	0a048513          	addi	a0,s1,160
    80002080:	00000097          	auipc	ra,0x0
    80002084:	7d8080e7          	jalr	2008(ra) # 80002858 <swtch>
    80002088:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000208a:	2781                	sext.w	a5,a5
    8000208c:	079e                	slli	a5,a5,0x7
    8000208e:	97ca                	add	a5,a5,s2
    80002090:	0b37a623          	sw	s3,172(a5)
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret
    panic("sched p->lock");
    800020a2:	00006517          	auipc	a0,0x6
    800020a6:	17650513          	addi	a0,a0,374 # 80008218 <digits+0x1d8>
    800020aa:	ffffe097          	auipc	ra,0xffffe
    800020ae:	494080e7          	jalr	1172(ra) # 8000053e <panic>
    panic("sched locks");
    800020b2:	00006517          	auipc	a0,0x6
    800020b6:	17650513          	addi	a0,a0,374 # 80008228 <digits+0x1e8>
    800020ba:	ffffe097          	auipc	ra,0xffffe
    800020be:	484080e7          	jalr	1156(ra) # 8000053e <panic>
    panic("sched running");
    800020c2:	00006517          	auipc	a0,0x6
    800020c6:	17650513          	addi	a0,a0,374 # 80008238 <digits+0x1f8>
    800020ca:	ffffe097          	auipc	ra,0xffffe
    800020ce:	474080e7          	jalr	1140(ra) # 8000053e <panic>
    panic("sched interruptible");
    800020d2:	00006517          	auipc	a0,0x6
    800020d6:	17650513          	addi	a0,a0,374 # 80008248 <digits+0x208>
    800020da:	ffffe097          	auipc	ra,0xffffe
    800020de:	464080e7          	jalr	1124(ra) # 8000053e <panic>

00000000800020e2 <yield>:
{
    800020e2:	1101                	addi	sp,sp,-32
    800020e4:	ec06                	sd	ra,24(sp)
    800020e6:	e822                	sd	s0,16(sp)
    800020e8:	e426                	sd	s1,8(sp)
    800020ea:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020ec:	00000097          	auipc	ra,0x0
    800020f0:	8c0080e7          	jalr	-1856(ra) # 800019ac <myproc>
    800020f4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	ae0080e7          	jalr	-1312(ra) # 80000bd6 <acquire>
  p->state = RUNNABLE;
    800020fe:	478d                	li	a5,3
    80002100:	cc9c                	sw	a5,24(s1)
  sched();
    80002102:	00000097          	auipc	ra,0x0
    80002106:	f0a080e7          	jalr	-246(ra) # 8000200c <sched>
  release(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	fffff097          	auipc	ra,0xfffff
    80002110:	b7e080e7          	jalr	-1154(ra) # 80000c8a <release>
}
    80002114:	60e2                	ld	ra,24(sp)
    80002116:	6442                	ld	s0,16(sp)
    80002118:	64a2                	ld	s1,8(sp)
    8000211a:	6105                	addi	sp,sp,32
    8000211c:	8082                	ret

000000008000211e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000211e:	7179                	addi	sp,sp,-48
    80002120:	f406                	sd	ra,40(sp)
    80002122:	f022                	sd	s0,32(sp)
    80002124:	ec26                	sd	s1,24(sp)
    80002126:	e84a                	sd	s2,16(sp)
    80002128:	e44e                	sd	s3,8(sp)
    8000212a:	1800                	addi	s0,sp,48
    8000212c:	89aa                	mv	s3,a0
    8000212e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002130:	00000097          	auipc	ra,0x0
    80002134:	87c080e7          	jalr	-1924(ra) # 800019ac <myproc>
    80002138:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	a9c080e7          	jalr	-1380(ra) # 80000bd6 <acquire>
  release(lk);
    80002142:	854a                	mv	a0,s2
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	b46080e7          	jalr	-1210(ra) # 80000c8a <release>

  // Go to sleep.
  p->chan = chan;
    8000214c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002150:	4789                	li	a5,2
    80002152:	cc9c                	sw	a5,24(s1)

  sched();
    80002154:	00000097          	auipc	ra,0x0
    80002158:	eb8080e7          	jalr	-328(ra) # 8000200c <sched>

  // Tidy up.
  p->chan = 0;
    8000215c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002160:	8526                	mv	a0,s1
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	b28080e7          	jalr	-1240(ra) # 80000c8a <release>
  acquire(lk);
    8000216a:	854a                	mv	a0,s2
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	a6a080e7          	jalr	-1430(ra) # 80000bd6 <acquire>
}
    80002174:	70a2                	ld	ra,40(sp)
    80002176:	7402                	ld	s0,32(sp)
    80002178:	64e2                	ld	s1,24(sp)
    8000217a:	6942                	ld	s2,16(sp)
    8000217c:	69a2                	ld	s3,8(sp)
    8000217e:	6145                	addi	sp,sp,48
    80002180:	8082                	ret

0000000080002182 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002182:	7139                	addi	sp,sp,-64
    80002184:	fc06                	sd	ra,56(sp)
    80002186:	f822                	sd	s0,48(sp)
    80002188:	f426                	sd	s1,40(sp)
    8000218a:	f04a                	sd	s2,32(sp)
    8000218c:	ec4e                	sd	s3,24(sp)
    8000218e:	e852                	sd	s4,16(sp)
    80002190:	e456                	sd	s5,8(sp)
    80002192:	0080                	addi	s0,sp,64
    80002194:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002196:	0000f497          	auipc	s1,0xf
    8000219a:	dfa48493          	addi	s1,s1,-518 # 80010f90 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    8000219e:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800021a0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800021a2:	00016917          	auipc	s2,0x16
    800021a6:	bee90913          	addi	s2,s2,-1042 # 80017d90 <tickslock>
    800021aa:	a811                	j	800021be <wakeup+0x3c>
      }
      release(&p->lock);
    800021ac:	8526                	mv	a0,s1
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	adc080e7          	jalr	-1316(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800021b6:	1b848493          	addi	s1,s1,440
    800021ba:	03248663          	beq	s1,s2,800021e6 <wakeup+0x64>
    if (p != myproc())
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	7ee080e7          	jalr	2030(ra) # 800019ac <myproc>
    800021c6:	fea488e3          	beq	s1,a0,800021b6 <wakeup+0x34>
      acquire(&p->lock);
    800021ca:	8526                	mv	a0,s1
    800021cc:	fffff097          	auipc	ra,0xfffff
    800021d0:	a0a080e7          	jalr	-1526(ra) # 80000bd6 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    800021d4:	4c9c                	lw	a5,24(s1)
    800021d6:	fd379be3          	bne	a5,s3,800021ac <wakeup+0x2a>
    800021da:	709c                	ld	a5,32(s1)
    800021dc:	fd4798e3          	bne	a5,s4,800021ac <wakeup+0x2a>
        p->state = RUNNABLE;
    800021e0:	0154ac23          	sw	s5,24(s1)
    800021e4:	b7e1                	j	800021ac <wakeup+0x2a>
    }
  }
}
    800021e6:	70e2                	ld	ra,56(sp)
    800021e8:	7442                	ld	s0,48(sp)
    800021ea:	74a2                	ld	s1,40(sp)
    800021ec:	7902                	ld	s2,32(sp)
    800021ee:	69e2                	ld	s3,24(sp)
    800021f0:	6a42                	ld	s4,16(sp)
    800021f2:	6aa2                	ld	s5,8(sp)
    800021f4:	6121                	addi	sp,sp,64
    800021f6:	8082                	ret

00000000800021f8 <reparent>:
{
    800021f8:	7179                	addi	sp,sp,-48
    800021fa:	f406                	sd	ra,40(sp)
    800021fc:	f022                	sd	s0,32(sp)
    800021fe:	ec26                	sd	s1,24(sp)
    80002200:	e84a                	sd	s2,16(sp)
    80002202:	e44e                	sd	s3,8(sp)
    80002204:	e052                	sd	s4,0(sp)
    80002206:	1800                	addi	s0,sp,48
    80002208:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000220a:	0000f497          	auipc	s1,0xf
    8000220e:	d8648493          	addi	s1,s1,-634 # 80010f90 <proc>
      pp->parent = initproc;
    80002212:	00006a17          	auipc	s4,0x6
    80002216:	6d6a0a13          	addi	s4,s4,1750 # 800088e8 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000221a:	00016997          	auipc	s3,0x16
    8000221e:	b7698993          	addi	s3,s3,-1162 # 80017d90 <tickslock>
    80002222:	a029                	j	8000222c <reparent+0x34>
    80002224:	1b848493          	addi	s1,s1,440
    80002228:	01348d63          	beq	s1,s3,80002242 <reparent+0x4a>
    if (pp->parent == p)
    8000222c:	7cbc                	ld	a5,120(s1)
    8000222e:	ff279be3          	bne	a5,s2,80002224 <reparent+0x2c>
      pp->parent = initproc;
    80002232:	000a3503          	ld	a0,0(s4)
    80002236:	fca8                	sd	a0,120(s1)
      wakeup(initproc);
    80002238:	00000097          	auipc	ra,0x0
    8000223c:	f4a080e7          	jalr	-182(ra) # 80002182 <wakeup>
    80002240:	b7d5                	j	80002224 <reparent+0x2c>
}
    80002242:	70a2                	ld	ra,40(sp)
    80002244:	7402                	ld	s0,32(sp)
    80002246:	64e2                	ld	s1,24(sp)
    80002248:	6942                	ld	s2,16(sp)
    8000224a:	69a2                	ld	s3,8(sp)
    8000224c:	6a02                	ld	s4,0(sp)
    8000224e:	6145                	addi	sp,sp,48
    80002250:	8082                	ret

0000000080002252 <exit>:
{
    80002252:	7179                	addi	sp,sp,-48
    80002254:	f406                	sd	ra,40(sp)
    80002256:	f022                	sd	s0,32(sp)
    80002258:	ec26                	sd	s1,24(sp)
    8000225a:	e84a                	sd	s2,16(sp)
    8000225c:	e44e                	sd	s3,8(sp)
    8000225e:	e052                	sd	s4,0(sp)
    80002260:	1800                	addi	s0,sp,48
    80002262:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	748080e7          	jalr	1864(ra) # 800019ac <myproc>
    8000226c:	89aa                	mv	s3,a0
  if (p == initproc)
    8000226e:	00006797          	auipc	a5,0x6
    80002272:	67a7b783          	ld	a5,1658(a5) # 800088e8 <initproc>
    80002276:	11050493          	addi	s1,a0,272
    8000227a:	19050913          	addi	s2,a0,400
    8000227e:	02a79363          	bne	a5,a0,800022a4 <exit+0x52>
    panic("init exiting");
    80002282:	00006517          	auipc	a0,0x6
    80002286:	fde50513          	addi	a0,a0,-34 # 80008260 <digits+0x220>
    8000228a:	ffffe097          	auipc	ra,0xffffe
    8000228e:	2b4080e7          	jalr	692(ra) # 8000053e <panic>
      fileclose(f);
    80002292:	00003097          	auipc	ra,0x3
    80002296:	b86080e7          	jalr	-1146(ra) # 80004e18 <fileclose>
      p->ofile[fd] = 0;
    8000229a:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    8000229e:	04a1                	addi	s1,s1,8
    800022a0:	01248563          	beq	s1,s2,800022aa <exit+0x58>
    if (p->ofile[fd])
    800022a4:	6088                	ld	a0,0(s1)
    800022a6:	f575                	bnez	a0,80002292 <exit+0x40>
    800022a8:	bfdd                	j	8000229e <exit+0x4c>
  begin_op();
    800022aa:	00002097          	auipc	ra,0x2
    800022ae:	6a2080e7          	jalr	1698(ra) # 8000494c <begin_op>
  iput(p->cwd);
    800022b2:	1909b503          	ld	a0,400(s3)
    800022b6:	00002097          	auipc	ra,0x2
    800022ba:	e8e080e7          	jalr	-370(ra) # 80004144 <iput>
  end_op();
    800022be:	00002097          	auipc	ra,0x2
    800022c2:	70e080e7          	jalr	1806(ra) # 800049cc <end_op>
  p->cwd = 0;
    800022c6:	1809b823          	sd	zero,400(s3)
  acquire(&wait_lock);
    800022ca:	0000f497          	auipc	s1,0xf
    800022ce:	8ae48493          	addi	s1,s1,-1874 # 80010b78 <wait_lock>
    800022d2:	8526                	mv	a0,s1
    800022d4:	fffff097          	auipc	ra,0xfffff
    800022d8:	902080e7          	jalr	-1790(ra) # 80000bd6 <acquire>
  reparent(p);
    800022dc:	854e                	mv	a0,s3
    800022de:	00000097          	auipc	ra,0x0
    800022e2:	f1a080e7          	jalr	-230(ra) # 800021f8 <reparent>
  wakeup(p->parent);
    800022e6:	0789b503          	ld	a0,120(s3)
    800022ea:	00000097          	auipc	ra,0x0
    800022ee:	e98080e7          	jalr	-360(ra) # 80002182 <wakeup>
  acquire(&p->lock);
    800022f2:	854e                	mv	a0,s3
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	8e2080e7          	jalr	-1822(ra) # 80000bd6 <acquire>
  p->xstate = status;
    800022fc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002300:	4795                	li	a5,5
    80002302:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    80002306:	00006797          	auipc	a5,0x6
    8000230a:	5ea7a783          	lw	a5,1514(a5) # 800088f0 <ticks>
    8000230e:	1af9a823          	sw	a5,432(s3)
  release(&wait_lock);
    80002312:	8526                	mv	a0,s1
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	976080e7          	jalr	-1674(ra) # 80000c8a <release>
  sched();
    8000231c:	00000097          	auipc	ra,0x0
    80002320:	cf0080e7          	jalr	-784(ra) # 8000200c <sched>
  panic("zombie exit");
    80002324:	00006517          	auipc	a0,0x6
    80002328:	f4c50513          	addi	a0,a0,-180 # 80008270 <digits+0x230>
    8000232c:	ffffe097          	auipc	ra,0xffffe
    80002330:	212080e7          	jalr	530(ra) # 8000053e <panic>

0000000080002334 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002334:	7179                	addi	sp,sp,-48
    80002336:	f406                	sd	ra,40(sp)
    80002338:	f022                	sd	s0,32(sp)
    8000233a:	ec26                	sd	s1,24(sp)
    8000233c:	e84a                	sd	s2,16(sp)
    8000233e:	e44e                	sd	s3,8(sp)
    80002340:	1800                	addi	s0,sp,48
    80002342:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002344:	0000f497          	auipc	s1,0xf
    80002348:	c4c48493          	addi	s1,s1,-948 # 80010f90 <proc>
    8000234c:	00016997          	auipc	s3,0x16
    80002350:	a4498993          	addi	s3,s3,-1468 # 80017d90 <tickslock>
  {
    acquire(&p->lock);
    80002354:	8526                	mv	a0,s1
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	880080e7          	jalr	-1920(ra) # 80000bd6 <acquire>
    if (p->pid == pid)
    8000235e:	589c                	lw	a5,48(s1)
    80002360:	01278d63          	beq	a5,s2,8000237a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002364:	8526                	mv	a0,s1
    80002366:	fffff097          	auipc	ra,0xfffff
    8000236a:	924080e7          	jalr	-1756(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000236e:	1b848493          	addi	s1,s1,440
    80002372:	ff3491e3          	bne	s1,s3,80002354 <kill+0x20>
  }
  return -1;
    80002376:	557d                	li	a0,-1
    80002378:	a829                	j	80002392 <kill+0x5e>
      p->killed = 1;
    8000237a:	4785                	li	a5,1
    8000237c:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    8000237e:	4c98                	lw	a4,24(s1)
    80002380:	4789                	li	a5,2
    80002382:	00f70f63          	beq	a4,a5,800023a0 <kill+0x6c>
      release(&p->lock);
    80002386:	8526                	mv	a0,s1
    80002388:	fffff097          	auipc	ra,0xfffff
    8000238c:	902080e7          	jalr	-1790(ra) # 80000c8a <release>
      return 0;
    80002390:	4501                	li	a0,0
}
    80002392:	70a2                	ld	ra,40(sp)
    80002394:	7402                	ld	s0,32(sp)
    80002396:	64e2                	ld	s1,24(sp)
    80002398:	6942                	ld	s2,16(sp)
    8000239a:	69a2                	ld	s3,8(sp)
    8000239c:	6145                	addi	sp,sp,48
    8000239e:	8082                	ret
        p->state = RUNNABLE;
    800023a0:	478d                	li	a5,3
    800023a2:	cc9c                	sw	a5,24(s1)
    800023a4:	b7cd                	j	80002386 <kill+0x52>

00000000800023a6 <setkilled>:

void setkilled(struct proc *p)
{
    800023a6:	1101                	addi	sp,sp,-32
    800023a8:	ec06                	sd	ra,24(sp)
    800023aa:	e822                	sd	s0,16(sp)
    800023ac:	e426                	sd	s1,8(sp)
    800023ae:	1000                	addi	s0,sp,32
    800023b0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800023b2:	fffff097          	auipc	ra,0xfffff
    800023b6:	824080e7          	jalr	-2012(ra) # 80000bd6 <acquire>
  p->killed = 1;
    800023ba:	4785                	li	a5,1
    800023bc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800023be:	8526                	mv	a0,s1
    800023c0:	fffff097          	auipc	ra,0xfffff
    800023c4:	8ca080e7          	jalr	-1846(ra) # 80000c8a <release>
}
    800023c8:	60e2                	ld	ra,24(sp)
    800023ca:	6442                	ld	s0,16(sp)
    800023cc:	64a2                	ld	s1,8(sp)
    800023ce:	6105                	addi	sp,sp,32
    800023d0:	8082                	ret

00000000800023d2 <killed>:

int killed(struct proc *p)
{
    800023d2:	1101                	addi	sp,sp,-32
    800023d4:	ec06                	sd	ra,24(sp)
    800023d6:	e822                	sd	s0,16(sp)
    800023d8:	e426                	sd	s1,8(sp)
    800023da:	e04a                	sd	s2,0(sp)
    800023dc:	1000                	addi	s0,sp,32
    800023de:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800023e0:	ffffe097          	auipc	ra,0xffffe
    800023e4:	7f6080e7          	jalr	2038(ra) # 80000bd6 <acquire>
  k = p->killed;
    800023e8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800023ec:	8526                	mv	a0,s1
    800023ee:	fffff097          	auipc	ra,0xfffff
    800023f2:	89c080e7          	jalr	-1892(ra) # 80000c8a <release>
  return k;
}
    800023f6:	854a                	mv	a0,s2
    800023f8:	60e2                	ld	ra,24(sp)
    800023fa:	6442                	ld	s0,16(sp)
    800023fc:	64a2                	ld	s1,8(sp)
    800023fe:	6902                	ld	s2,0(sp)
    80002400:	6105                	addi	sp,sp,32
    80002402:	8082                	ret

0000000080002404 <wait>:
{
    80002404:	715d                	addi	sp,sp,-80
    80002406:	e486                	sd	ra,72(sp)
    80002408:	e0a2                	sd	s0,64(sp)
    8000240a:	fc26                	sd	s1,56(sp)
    8000240c:	f84a                	sd	s2,48(sp)
    8000240e:	f44e                	sd	s3,40(sp)
    80002410:	f052                	sd	s4,32(sp)
    80002412:	ec56                	sd	s5,24(sp)
    80002414:	e85a                	sd	s6,16(sp)
    80002416:	e45e                	sd	s7,8(sp)
    80002418:	e062                	sd	s8,0(sp)
    8000241a:	0880                	addi	s0,sp,80
    8000241c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000241e:	fffff097          	auipc	ra,0xfffff
    80002422:	58e080e7          	jalr	1422(ra) # 800019ac <myproc>
    80002426:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002428:	0000e517          	auipc	a0,0xe
    8000242c:	75050513          	addi	a0,a0,1872 # 80010b78 <wait_lock>
    80002430:	ffffe097          	auipc	ra,0xffffe
    80002434:	7a6080e7          	jalr	1958(ra) # 80000bd6 <acquire>
    havekids = 0;
    80002438:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    8000243a:	4a15                	li	s4,5
        havekids = 1;
    8000243c:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000243e:	00016997          	auipc	s3,0x16
    80002442:	95298993          	addi	s3,s3,-1710 # 80017d90 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002446:	0000ec17          	auipc	s8,0xe
    8000244a:	732c0c13          	addi	s8,s8,1842 # 80010b78 <wait_lock>
    havekids = 0;
    8000244e:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002450:	0000f497          	auipc	s1,0xf
    80002454:	b4048493          	addi	s1,s1,-1216 # 80010f90 <proc>
    80002458:	a0bd                	j	800024c6 <wait+0xc2>
          pid = pp->pid;
    8000245a:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000245e:	000b0e63          	beqz	s6,8000247a <wait+0x76>
    80002462:	4691                	li	a3,4
    80002464:	02c48613          	addi	a2,s1,44
    80002468:	85da                	mv	a1,s6
    8000246a:	09093503          	ld	a0,144(s2)
    8000246e:	fffff097          	auipc	ra,0xfffff
    80002472:	1fa080e7          	jalr	506(ra) # 80001668 <copyout>
    80002476:	02054563          	bltz	a0,800024a0 <wait+0x9c>
          freeproc(pp);
    8000247a:	8526                	mv	a0,s1
    8000247c:	fffff097          	auipc	ra,0xfffff
    80002480:	6e2080e7          	jalr	1762(ra) # 80001b5e <freeproc>
          release(&pp->lock);
    80002484:	8526                	mv	a0,s1
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	804080e7          	jalr	-2044(ra) # 80000c8a <release>
          release(&wait_lock);
    8000248e:	0000e517          	auipc	a0,0xe
    80002492:	6ea50513          	addi	a0,a0,1770 # 80010b78 <wait_lock>
    80002496:	ffffe097          	auipc	ra,0xffffe
    8000249a:	7f4080e7          	jalr	2036(ra) # 80000c8a <release>
          return pid;
    8000249e:	a0b5                	j	8000250a <wait+0x106>
            release(&pp->lock);
    800024a0:	8526                	mv	a0,s1
    800024a2:	ffffe097          	auipc	ra,0xffffe
    800024a6:	7e8080e7          	jalr	2024(ra) # 80000c8a <release>
            release(&wait_lock);
    800024aa:	0000e517          	auipc	a0,0xe
    800024ae:	6ce50513          	addi	a0,a0,1742 # 80010b78 <wait_lock>
    800024b2:	ffffe097          	auipc	ra,0xffffe
    800024b6:	7d8080e7          	jalr	2008(ra) # 80000c8a <release>
            return -1;
    800024ba:	59fd                	li	s3,-1
    800024bc:	a0b9                	j	8000250a <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800024be:	1b848493          	addi	s1,s1,440
    800024c2:	03348463          	beq	s1,s3,800024ea <wait+0xe6>
      if (pp->parent == p)
    800024c6:	7cbc                	ld	a5,120(s1)
    800024c8:	ff279be3          	bne	a5,s2,800024be <wait+0xba>
        acquire(&pp->lock);
    800024cc:	8526                	mv	a0,s1
    800024ce:	ffffe097          	auipc	ra,0xffffe
    800024d2:	708080e7          	jalr	1800(ra) # 80000bd6 <acquire>
        if (pp->state == ZOMBIE)
    800024d6:	4c9c                	lw	a5,24(s1)
    800024d8:	f94781e3          	beq	a5,s4,8000245a <wait+0x56>
        release(&pp->lock);
    800024dc:	8526                	mv	a0,s1
    800024de:	ffffe097          	auipc	ra,0xffffe
    800024e2:	7ac080e7          	jalr	1964(ra) # 80000c8a <release>
        havekids = 1;
    800024e6:	8756                	mv	a4,s5
    800024e8:	bfd9                	j	800024be <wait+0xba>
    if (!havekids || killed(p))
    800024ea:	c719                	beqz	a4,800024f8 <wait+0xf4>
    800024ec:	854a                	mv	a0,s2
    800024ee:	00000097          	auipc	ra,0x0
    800024f2:	ee4080e7          	jalr	-284(ra) # 800023d2 <killed>
    800024f6:	c51d                	beqz	a0,80002524 <wait+0x120>
      release(&wait_lock);
    800024f8:	0000e517          	auipc	a0,0xe
    800024fc:	68050513          	addi	a0,a0,1664 # 80010b78 <wait_lock>
    80002500:	ffffe097          	auipc	ra,0xffffe
    80002504:	78a080e7          	jalr	1930(ra) # 80000c8a <release>
      return -1;
    80002508:	59fd                	li	s3,-1
}
    8000250a:	854e                	mv	a0,s3
    8000250c:	60a6                	ld	ra,72(sp)
    8000250e:	6406                	ld	s0,64(sp)
    80002510:	74e2                	ld	s1,56(sp)
    80002512:	7942                	ld	s2,48(sp)
    80002514:	79a2                	ld	s3,40(sp)
    80002516:	7a02                	ld	s4,32(sp)
    80002518:	6ae2                	ld	s5,24(sp)
    8000251a:	6b42                	ld	s6,16(sp)
    8000251c:	6ba2                	ld	s7,8(sp)
    8000251e:	6c02                	ld	s8,0(sp)
    80002520:	6161                	addi	sp,sp,80
    80002522:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002524:	85e2                	mv	a1,s8
    80002526:	854a                	mv	a0,s2
    80002528:	00000097          	auipc	ra,0x0
    8000252c:	bf6080e7          	jalr	-1034(ra) # 8000211e <sleep>
    havekids = 0;
    80002530:	bf39                	j	8000244e <wait+0x4a>

0000000080002532 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002532:	7179                	addi	sp,sp,-48
    80002534:	f406                	sd	ra,40(sp)
    80002536:	f022                	sd	s0,32(sp)
    80002538:	ec26                	sd	s1,24(sp)
    8000253a:	e84a                	sd	s2,16(sp)
    8000253c:	e44e                	sd	s3,8(sp)
    8000253e:	e052                	sd	s4,0(sp)
    80002540:	1800                	addi	s0,sp,48
    80002542:	84aa                	mv	s1,a0
    80002544:	892e                	mv	s2,a1
    80002546:	89b2                	mv	s3,a2
    80002548:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000254a:	fffff097          	auipc	ra,0xfffff
    8000254e:	462080e7          	jalr	1122(ra) # 800019ac <myproc>
  if (user_dst)
    80002552:	c08d                	beqz	s1,80002574 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80002554:	86d2                	mv	a3,s4
    80002556:	864e                	mv	a2,s3
    80002558:	85ca                	mv	a1,s2
    8000255a:	6948                	ld	a0,144(a0)
    8000255c:	fffff097          	auipc	ra,0xfffff
    80002560:	10c080e7          	jalr	268(ra) # 80001668 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002564:	70a2                	ld	ra,40(sp)
    80002566:	7402                	ld	s0,32(sp)
    80002568:	64e2                	ld	s1,24(sp)
    8000256a:	6942                	ld	s2,16(sp)
    8000256c:	69a2                	ld	s3,8(sp)
    8000256e:	6a02                	ld	s4,0(sp)
    80002570:	6145                	addi	sp,sp,48
    80002572:	8082                	ret
    memmove((char *)dst, src, len);
    80002574:	000a061b          	sext.w	a2,s4
    80002578:	85ce                	mv	a1,s3
    8000257a:	854a                	mv	a0,s2
    8000257c:	ffffe097          	auipc	ra,0xffffe
    80002580:	7b2080e7          	jalr	1970(ra) # 80000d2e <memmove>
    return 0;
    80002584:	8526                	mv	a0,s1
    80002586:	bff9                	j	80002564 <either_copyout+0x32>

0000000080002588 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002588:	7179                	addi	sp,sp,-48
    8000258a:	f406                	sd	ra,40(sp)
    8000258c:	f022                	sd	s0,32(sp)
    8000258e:	ec26                	sd	s1,24(sp)
    80002590:	e84a                	sd	s2,16(sp)
    80002592:	e44e                	sd	s3,8(sp)
    80002594:	e052                	sd	s4,0(sp)
    80002596:	1800                	addi	s0,sp,48
    80002598:	892a                	mv	s2,a0
    8000259a:	84ae                	mv	s1,a1
    8000259c:	89b2                	mv	s3,a2
    8000259e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025a0:	fffff097          	auipc	ra,0xfffff
    800025a4:	40c080e7          	jalr	1036(ra) # 800019ac <myproc>
  if (user_src)
    800025a8:	c08d                	beqz	s1,800025ca <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    800025aa:	86d2                	mv	a3,s4
    800025ac:	864e                	mv	a2,s3
    800025ae:	85ca                	mv	a1,s2
    800025b0:	6948                	ld	a0,144(a0)
    800025b2:	fffff097          	auipc	ra,0xfffff
    800025b6:	142080e7          	jalr	322(ra) # 800016f4 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800025ba:	70a2                	ld	ra,40(sp)
    800025bc:	7402                	ld	s0,32(sp)
    800025be:	64e2                	ld	s1,24(sp)
    800025c0:	6942                	ld	s2,16(sp)
    800025c2:	69a2                	ld	s3,8(sp)
    800025c4:	6a02                	ld	s4,0(sp)
    800025c6:	6145                	addi	sp,sp,48
    800025c8:	8082                	ret
    memmove(dst, (char *)src, len);
    800025ca:	000a061b          	sext.w	a2,s4
    800025ce:	85ce                	mv	a1,s3
    800025d0:	854a                	mv	a0,s2
    800025d2:	ffffe097          	auipc	ra,0xffffe
    800025d6:	75c080e7          	jalr	1884(ra) # 80000d2e <memmove>
    return 0;
    800025da:	8526                	mv	a0,s1
    800025dc:	bff9                	j	800025ba <either_copyin+0x32>

00000000800025de <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800025de:	711d                	addi	sp,sp,-96
    800025e0:	ec86                	sd	ra,88(sp)
    800025e2:	e8a2                	sd	s0,80(sp)
    800025e4:	e4a6                	sd	s1,72(sp)
    800025e6:	e0ca                	sd	s2,64(sp)
    800025e8:	fc4e                	sd	s3,56(sp)
    800025ea:	f852                	sd	s4,48(sp)
    800025ec:	f456                	sd	s5,40(sp)
    800025ee:	f05a                	sd	s6,32(sp)
    800025f0:	ec5e                	sd	s7,24(sp)
    800025f2:	e862                	sd	s8,16(sp)
    800025f4:	e466                	sd	s9,8(sp)
    800025f6:	1080                	addi	s0,sp,96
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800025f8:	00006517          	auipc	a0,0x6
    800025fc:	da050513          	addi	a0,a0,-608 # 80008398 <states.0+0xd0>
    80002600:	ffffe097          	auipc	ra,0xffffe
    80002604:	f88080e7          	jalr	-120(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002608:	0000f497          	auipc	s1,0xf
    8000260c:	b2048493          	addi	s1,s1,-1248 # 80011128 <proc+0x198>
    80002610:	00016917          	auipc	s2,0x16
    80002614:	91890913          	addi	s2,s2,-1768 # 80017f28 <bcache+0x180>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002618:	4a95                	li	s5,5
      state = states[p->state];
    else
      state = "???";
    8000261a:	00006997          	auipc	s3,0x6
    8000261e:	c6698993          	addi	s3,s3,-922 # 80008280 <digits+0x240>
    if (p->state == RUNNING)
    80002622:	4a11                	li	s4,4
    {
      printf("%d %s %s %d %d", p->pid, state, p->name, p->queue, ticks);
    80002624:	00006c97          	auipc	s9,0x6
    80002628:	2ccc8c93          	addi	s9,s9,716 # 800088f0 <ticks>
    8000262c:	00006c17          	auipc	s8,0x6
    80002630:	c5cc0c13          	addi	s8,s8,-932 # 80008288 <digits+0x248>
      printf("\n");
    80002634:	00006b97          	auipc	s7,0x6
    80002638:	d64b8b93          	addi	s7,s7,-668 # 80008398 <states.0+0xd0>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000263c:	00006b17          	auipc	s6,0x6
    80002640:	c8cb0b13          	addi	s6,s6,-884 # 800082c8 <states.0>
    80002644:	a039                	j	80002652 <procdump+0x74>
    if (p->state == RUNNING)
    80002646:	03478663          	beq	a5,s4,80002672 <procdump+0x94>
  for (p = proc; p < &proc[NPROC]; p++)
    8000264a:	1b848493          	addi	s1,s1,440
    8000264e:	05248363          	beq	s1,s2,80002694 <procdump+0xb6>
    if (p->state == UNUSED)
    80002652:	86a6                	mv	a3,s1
    80002654:	e804a783          	lw	a5,-384(s1)
    80002658:	dbed                	beqz	a5,8000264a <procdump+0x6c>
      state = "???";
    8000265a:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000265c:	fefae5e3          	bltu	s5,a5,80002646 <procdump+0x68>
    80002660:	02079713          	slli	a4,a5,0x20
    80002664:	9301                	srli	a4,a4,0x20
    80002666:	070e                	slli	a4,a4,0x3
    80002668:	975a                	add	a4,a4,s6
    8000266a:	6310                	ld	a2,0(a4)
    8000266c:	fe69                	bnez	a2,80002646 <procdump+0x68>
      state = "???";
    8000266e:	864e                	mv	a2,s3
    80002670:	bfd9                	j	80002646 <procdump+0x68>
      printf("%d %s %s %d %d", p->pid, state, p->name, p->queue, ticks);
    80002672:	000ca783          	lw	a5,0(s9)
    80002676:	ec86a703          	lw	a4,-312(a3)
    8000267a:	e986a583          	lw	a1,-360(a3)
    8000267e:	8562                	mv	a0,s8
    80002680:	ffffe097          	auipc	ra,0xffffe
    80002684:	f08080e7          	jalr	-248(ra) # 80000588 <printf>
      printf("\n");
    80002688:	855e                	mv	a0,s7
    8000268a:	ffffe097          	auipc	ra,0xffffe
    8000268e:	efe080e7          	jalr	-258(ra) # 80000588 <printf>
    80002692:	bf65                	j	8000264a <procdump+0x6c>
    }
  }
}
    80002694:	60e6                	ld	ra,88(sp)
    80002696:	6446                	ld	s0,80(sp)
    80002698:	64a6                	ld	s1,72(sp)
    8000269a:	6906                	ld	s2,64(sp)
    8000269c:	79e2                	ld	s3,56(sp)
    8000269e:	7a42                	ld	s4,48(sp)
    800026a0:	7aa2                	ld	s5,40(sp)
    800026a2:	7b02                	ld	s6,32(sp)
    800026a4:	6be2                	ld	s7,24(sp)
    800026a6:	6c42                	ld	s8,16(sp)
    800026a8:	6ca2                	ld	s9,8(sp)
    800026aa:	6125                	addi	sp,sp,96
    800026ac:	8082                	ret

00000000800026ae <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    800026ae:	711d                	addi	sp,sp,-96
    800026b0:	ec86                	sd	ra,88(sp)
    800026b2:	e8a2                	sd	s0,80(sp)
    800026b4:	e4a6                	sd	s1,72(sp)
    800026b6:	e0ca                	sd	s2,64(sp)
    800026b8:	fc4e                	sd	s3,56(sp)
    800026ba:	f852                	sd	s4,48(sp)
    800026bc:	f456                	sd	s5,40(sp)
    800026be:	f05a                	sd	s6,32(sp)
    800026c0:	ec5e                	sd	s7,24(sp)
    800026c2:	e862                	sd	s8,16(sp)
    800026c4:	e466                	sd	s9,8(sp)
    800026c6:	e06a                	sd	s10,0(sp)
    800026c8:	1080                	addi	s0,sp,96
    800026ca:	8b2a                	mv	s6,a0
    800026cc:	8bae                	mv	s7,a1
    800026ce:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    800026d0:	fffff097          	auipc	ra,0xfffff
    800026d4:	2dc080e7          	jalr	732(ra) # 800019ac <myproc>
    800026d8:	892a                	mv	s2,a0

  acquire(&wait_lock);
    800026da:	0000e517          	auipc	a0,0xe
    800026de:	49e50513          	addi	a0,a0,1182 # 80010b78 <wait_lock>
    800026e2:	ffffe097          	auipc	ra,0xffffe
    800026e6:	4f4080e7          	jalr	1268(ra) # 80000bd6 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    800026ea:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    800026ec:	4a15                	li	s4,5
        havekids = 1;
    800026ee:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    800026f0:	00015997          	auipc	s3,0x15
    800026f4:	6a098993          	addi	s3,s3,1696 # 80017d90 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    800026f8:	0000ed17          	auipc	s10,0xe
    800026fc:	480d0d13          	addi	s10,s10,1152 # 80010b78 <wait_lock>
    havekids = 0;
    80002700:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002702:	0000f497          	auipc	s1,0xf
    80002706:	88e48493          	addi	s1,s1,-1906 # 80010f90 <proc>
    8000270a:	a059                	j	80002790 <waitx+0xe2>
          pid = np->pid;
    8000270c:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002710:	1a84a703          	lw	a4,424(s1)
    80002714:	00ec2023          	sw	a4,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002718:	1ac4a783          	lw	a5,428(s1)
    8000271c:	9f3d                	addw	a4,a4,a5
    8000271e:	1b04a783          	lw	a5,432(s1)
    80002722:	9f99                	subw	a5,a5,a4
    80002724:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002728:	000b0e63          	beqz	s6,80002744 <waitx+0x96>
    8000272c:	4691                	li	a3,4
    8000272e:	02c48613          	addi	a2,s1,44
    80002732:	85da                	mv	a1,s6
    80002734:	09093503          	ld	a0,144(s2)
    80002738:	fffff097          	auipc	ra,0xfffff
    8000273c:	f30080e7          	jalr	-208(ra) # 80001668 <copyout>
    80002740:	02054563          	bltz	a0,8000276a <waitx+0xbc>
          freeproc(np);
    80002744:	8526                	mv	a0,s1
    80002746:	fffff097          	auipc	ra,0xfffff
    8000274a:	418080e7          	jalr	1048(ra) # 80001b5e <freeproc>
          release(&np->lock);
    8000274e:	8526                	mv	a0,s1
    80002750:	ffffe097          	auipc	ra,0xffffe
    80002754:	53a080e7          	jalr	1338(ra) # 80000c8a <release>
          release(&wait_lock);
    80002758:	0000e517          	auipc	a0,0xe
    8000275c:	42050513          	addi	a0,a0,1056 # 80010b78 <wait_lock>
    80002760:	ffffe097          	auipc	ra,0xffffe
    80002764:	52a080e7          	jalr	1322(ra) # 80000c8a <release>
          return pid;
    80002768:	a09d                	j	800027ce <waitx+0x120>
            release(&np->lock);
    8000276a:	8526                	mv	a0,s1
    8000276c:	ffffe097          	auipc	ra,0xffffe
    80002770:	51e080e7          	jalr	1310(ra) # 80000c8a <release>
            release(&wait_lock);
    80002774:	0000e517          	auipc	a0,0xe
    80002778:	40450513          	addi	a0,a0,1028 # 80010b78 <wait_lock>
    8000277c:	ffffe097          	auipc	ra,0xffffe
    80002780:	50e080e7          	jalr	1294(ra) # 80000c8a <release>
            return -1;
    80002784:	59fd                	li	s3,-1
    80002786:	a0a1                	j	800027ce <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    80002788:	1b848493          	addi	s1,s1,440
    8000278c:	03348463          	beq	s1,s3,800027b4 <waitx+0x106>
      if (np->parent == p)
    80002790:	7cbc                	ld	a5,120(s1)
    80002792:	ff279be3          	bne	a5,s2,80002788 <waitx+0xda>
        acquire(&np->lock);
    80002796:	8526                	mv	a0,s1
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	43e080e7          	jalr	1086(ra) # 80000bd6 <acquire>
        if (np->state == ZOMBIE)
    800027a0:	4c9c                	lw	a5,24(s1)
    800027a2:	f74785e3          	beq	a5,s4,8000270c <waitx+0x5e>
        release(&np->lock);
    800027a6:	8526                	mv	a0,s1
    800027a8:	ffffe097          	auipc	ra,0xffffe
    800027ac:	4e2080e7          	jalr	1250(ra) # 80000c8a <release>
        havekids = 1;
    800027b0:	8756                	mv	a4,s5
    800027b2:	bfd9                	j	80002788 <waitx+0xda>
    if (!havekids || p->killed)
    800027b4:	c701                	beqz	a4,800027bc <waitx+0x10e>
    800027b6:	02892783          	lw	a5,40(s2)
    800027ba:	cb8d                	beqz	a5,800027ec <waitx+0x13e>
      release(&wait_lock);
    800027bc:	0000e517          	auipc	a0,0xe
    800027c0:	3bc50513          	addi	a0,a0,956 # 80010b78 <wait_lock>
    800027c4:	ffffe097          	auipc	ra,0xffffe
    800027c8:	4c6080e7          	jalr	1222(ra) # 80000c8a <release>
      return -1;
    800027cc:	59fd                	li	s3,-1
  }
}
    800027ce:	854e                	mv	a0,s3
    800027d0:	60e6                	ld	ra,88(sp)
    800027d2:	6446                	ld	s0,80(sp)
    800027d4:	64a6                	ld	s1,72(sp)
    800027d6:	6906                	ld	s2,64(sp)
    800027d8:	79e2                	ld	s3,56(sp)
    800027da:	7a42                	ld	s4,48(sp)
    800027dc:	7aa2                	ld	s5,40(sp)
    800027de:	7b02                	ld	s6,32(sp)
    800027e0:	6be2                	ld	s7,24(sp)
    800027e2:	6c42                	ld	s8,16(sp)
    800027e4:	6ca2                	ld	s9,8(sp)
    800027e6:	6d02                	ld	s10,0(sp)
    800027e8:	6125                	addi	sp,sp,96
    800027ea:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800027ec:	85ea                	mv	a1,s10
    800027ee:	854a                	mv	a0,s2
    800027f0:	00000097          	auipc	ra,0x0
    800027f4:	92e080e7          	jalr	-1746(ra) # 8000211e <sleep>
    havekids = 0;
    800027f8:	b721                	j	80002700 <waitx+0x52>

00000000800027fa <update_time>:

void update_time()
{
    800027fa:	7179                	addi	sp,sp,-48
    800027fc:	f406                	sd	ra,40(sp)
    800027fe:	f022                	sd	s0,32(sp)
    80002800:	ec26                	sd	s1,24(sp)
    80002802:	e84a                	sd	s2,16(sp)
    80002804:	e44e                	sd	s3,8(sp)
    80002806:	1800                	addi	s0,sp,48
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002808:	0000e497          	auipc	s1,0xe
    8000280c:	78848493          	addi	s1,s1,1928 # 80010f90 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002810:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++)
    80002812:	00015917          	auipc	s2,0x15
    80002816:	57e90913          	addi	s2,s2,1406 # 80017d90 <tickslock>
    8000281a:	a811                	j	8000282e <update_time+0x34>
    {
      p->rtime++;
    }
    release(&p->lock);
    8000281c:	8526                	mv	a0,s1
    8000281e:	ffffe097          	auipc	ra,0xffffe
    80002822:	46c080e7          	jalr	1132(ra) # 80000c8a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002826:	1b848493          	addi	s1,s1,440
    8000282a:	03248063          	beq	s1,s2,8000284a <update_time+0x50>
    acquire(&p->lock);
    8000282e:	8526                	mv	a0,s1
    80002830:	ffffe097          	auipc	ra,0xffffe
    80002834:	3a6080e7          	jalr	934(ra) # 80000bd6 <acquire>
    if (p->state == RUNNING)
    80002838:	4c9c                	lw	a5,24(s1)
    8000283a:	ff3791e3          	bne	a5,s3,8000281c <update_time+0x22>
      p->rtime++;
    8000283e:	1a84a783          	lw	a5,424(s1)
    80002842:	2785                	addiw	a5,a5,1
    80002844:	1af4a423          	sw	a5,424(s1)
    80002848:	bfd1                	j	8000281c <update_time+0x22>
  }
}
    8000284a:	70a2                	ld	ra,40(sp)
    8000284c:	7402                	ld	s0,32(sp)
    8000284e:	64e2                	ld	s1,24(sp)
    80002850:	6942                	ld	s2,16(sp)
    80002852:	69a2                	ld	s3,8(sp)
    80002854:	6145                	addi	sp,sp,48
    80002856:	8082                	ret

0000000080002858 <swtch>:
    80002858:	00153023          	sd	ra,0(a0)
    8000285c:	00253423          	sd	sp,8(a0)
    80002860:	e900                	sd	s0,16(a0)
    80002862:	ed04                	sd	s1,24(a0)
    80002864:	03253023          	sd	s2,32(a0)
    80002868:	03353423          	sd	s3,40(a0)
    8000286c:	03453823          	sd	s4,48(a0)
    80002870:	03553c23          	sd	s5,56(a0)
    80002874:	05653023          	sd	s6,64(a0)
    80002878:	05753423          	sd	s7,72(a0)
    8000287c:	05853823          	sd	s8,80(a0)
    80002880:	05953c23          	sd	s9,88(a0)
    80002884:	07a53023          	sd	s10,96(a0)
    80002888:	07b53423          	sd	s11,104(a0)
    8000288c:	0005b083          	ld	ra,0(a1)
    80002890:	0085b103          	ld	sp,8(a1)
    80002894:	6980                	ld	s0,16(a1)
    80002896:	6d84                	ld	s1,24(a1)
    80002898:	0205b903          	ld	s2,32(a1)
    8000289c:	0285b983          	ld	s3,40(a1)
    800028a0:	0305ba03          	ld	s4,48(a1)
    800028a4:	0385ba83          	ld	s5,56(a1)
    800028a8:	0405bb03          	ld	s6,64(a1)
    800028ac:	0485bb83          	ld	s7,72(a1)
    800028b0:	0505bc03          	ld	s8,80(a1)
    800028b4:	0585bc83          	ld	s9,88(a1)
    800028b8:	0605bd03          	ld	s10,96(a1)
    800028bc:	0685bd83          	ld	s11,104(a1)
    800028c0:	8082                	ret

00000000800028c2 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    800028c2:	1141                	addi	sp,sp,-16
    800028c4:	e406                	sd	ra,8(sp)
    800028c6:	e022                	sd	s0,0(sp)
    800028c8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800028ca:	00006597          	auipc	a1,0x6
    800028ce:	a2e58593          	addi	a1,a1,-1490 # 800082f8 <states.0+0x30>
    800028d2:	00015517          	auipc	a0,0x15
    800028d6:	4be50513          	addi	a0,a0,1214 # 80017d90 <tickslock>
    800028da:	ffffe097          	auipc	ra,0xffffe
    800028de:	26c080e7          	jalr	620(ra) # 80000b46 <initlock>
}
    800028e2:	60a2                	ld	ra,8(sp)
    800028e4:	6402                	ld	s0,0(sp)
    800028e6:	0141                	addi	sp,sp,16
    800028e8:	8082                	ret

00000000800028ea <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    800028ea:	1141                	addi	sp,sp,-16
    800028ec:	e422                	sd	s0,8(sp)
    800028ee:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800028f0:	00004797          	auipc	a5,0x4
    800028f4:	c2078793          	addi	a5,a5,-992 # 80006510 <kernelvec>
    800028f8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800028fc:	6422                	ld	s0,8(sp)
    800028fe:	0141                	addi	sp,sp,16
    80002900:	8082                	ret

0000000080002902 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002902:	1141                	addi	sp,sp,-16
    80002904:	e406                	sd	ra,8(sp)
    80002906:	e022                	sd	s0,0(sp)
    80002908:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000290a:	fffff097          	auipc	ra,0xfffff
    8000290e:	0a2080e7          	jalr	162(ra) # 800019ac <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002912:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002916:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002918:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000291c:	00004617          	auipc	a2,0x4
    80002920:	6e460613          	addi	a2,a2,1764 # 80007000 <_trampoline>
    80002924:	00004697          	auipc	a3,0x4
    80002928:	6dc68693          	addi	a3,a3,1756 # 80007000 <_trampoline>
    8000292c:	8e91                	sub	a3,a3,a2
    8000292e:	040007b7          	lui	a5,0x4000
    80002932:	17fd                	addi	a5,a5,-1
    80002934:	07b2                	slli	a5,a5,0xc
    80002936:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002938:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000293c:	6d58                	ld	a4,152(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000293e:	180026f3          	csrr	a3,satp
    80002942:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002944:	6d58                	ld	a4,152(a0)
    80002946:	6154                	ld	a3,128(a0)
    80002948:	6585                	lui	a1,0x1
    8000294a:	96ae                	add	a3,a3,a1
    8000294c:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000294e:	6d58                	ld	a4,152(a0)
    80002950:	00000697          	auipc	a3,0x0
    80002954:	13e68693          	addi	a3,a3,318 # 80002a8e <usertrap>
    80002958:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    8000295a:	6d58                	ld	a4,152(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000295c:	8692                	mv	a3,tp
    8000295e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002960:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002964:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002968:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000296c:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002970:	6d58                	ld	a4,152(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002972:	6f18                	ld	a4,24(a4)
    80002974:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002978:	6948                	ld	a0,144(a0)
    8000297a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000297c:	00004717          	auipc	a4,0x4
    80002980:	72070713          	addi	a4,a4,1824 # 8000709c <userret>
    80002984:	8f11                	sub	a4,a4,a2
    80002986:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002988:	577d                	li	a4,-1
    8000298a:	177e                	slli	a4,a4,0x3f
    8000298c:	8d59                	or	a0,a0,a4
    8000298e:	9782                	jalr	a5
}
    80002990:	60a2                	ld	ra,8(sp)
    80002992:	6402                	ld	s0,0(sp)
    80002994:	0141                	addi	sp,sp,16
    80002996:	8082                	ret

0000000080002998 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002998:	1101                	addi	sp,sp,-32
    8000299a:	ec06                	sd	ra,24(sp)
    8000299c:	e822                	sd	s0,16(sp)
    8000299e:	e426                	sd	s1,8(sp)
    800029a0:	e04a                	sd	s2,0(sp)
    800029a2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800029a4:	00015917          	auipc	s2,0x15
    800029a8:	3ec90913          	addi	s2,s2,1004 # 80017d90 <tickslock>
    800029ac:	854a                	mv	a0,s2
    800029ae:	ffffe097          	auipc	ra,0xffffe
    800029b2:	228080e7          	jalr	552(ra) # 80000bd6 <acquire>
  ticks++;
    800029b6:	00006497          	auipc	s1,0x6
    800029ba:	f3a48493          	addi	s1,s1,-198 # 800088f0 <ticks>
    800029be:	409c                	lw	a5,0(s1)
    800029c0:	2785                	addiw	a5,a5,1
    800029c2:	c09c                	sw	a5,0(s1)
  update_time();
    800029c4:	00000097          	auipc	ra,0x0
    800029c8:	e36080e7          	jalr	-458(ra) # 800027fa <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    800029cc:	8526                	mv	a0,s1
    800029ce:	fffff097          	auipc	ra,0xfffff
    800029d2:	7b4080e7          	jalr	1972(ra) # 80002182 <wakeup>
  release(&tickslock);
    800029d6:	854a                	mv	a0,s2
    800029d8:	ffffe097          	auipc	ra,0xffffe
    800029dc:	2b2080e7          	jalr	690(ra) # 80000c8a <release>
}
    800029e0:	60e2                	ld	ra,24(sp)
    800029e2:	6442                	ld	s0,16(sp)
    800029e4:	64a2                	ld	s1,8(sp)
    800029e6:	6902                	ld	s2,0(sp)
    800029e8:	6105                	addi	sp,sp,32
    800029ea:	8082                	ret

00000000800029ec <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    800029ec:	1101                	addi	sp,sp,-32
    800029ee:	ec06                	sd	ra,24(sp)
    800029f0:	e822                	sd	s0,16(sp)
    800029f2:	e426                	sd	s1,8(sp)
    800029f4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029f6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    800029fa:	00074d63          	bltz	a4,80002a14 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    800029fe:	57fd                	li	a5,-1
    80002a00:	17fe                	slli	a5,a5,0x3f
    80002a02:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002a04:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002a06:	06f70363          	beq	a4,a5,80002a6c <devintr+0x80>
  }
}
    80002a0a:	60e2                	ld	ra,24(sp)
    80002a0c:	6442                	ld	s0,16(sp)
    80002a0e:	64a2                	ld	s1,8(sp)
    80002a10:	6105                	addi	sp,sp,32
    80002a12:	8082                	ret
      (scause & 0xff) == 9)
    80002a14:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80002a18:	46a5                	li	a3,9
    80002a1a:	fed792e3          	bne	a5,a3,800029fe <devintr+0x12>
    int irq = plic_claim();
    80002a1e:	00004097          	auipc	ra,0x4
    80002a22:	bfa080e7          	jalr	-1030(ra) # 80006618 <plic_claim>
    80002a26:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002a28:	47a9                	li	a5,10
    80002a2a:	02f50763          	beq	a0,a5,80002a58 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002a2e:	4785                	li	a5,1
    80002a30:	02f50963          	beq	a0,a5,80002a62 <devintr+0x76>
    return 1;
    80002a34:	4505                	li	a0,1
    else if (irq)
    80002a36:	d8f1                	beqz	s1,80002a0a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002a38:	85a6                	mv	a1,s1
    80002a3a:	00006517          	auipc	a0,0x6
    80002a3e:	8c650513          	addi	a0,a0,-1850 # 80008300 <states.0+0x38>
    80002a42:	ffffe097          	auipc	ra,0xffffe
    80002a46:	b46080e7          	jalr	-1210(ra) # 80000588 <printf>
      plic_complete(irq);
    80002a4a:	8526                	mv	a0,s1
    80002a4c:	00004097          	auipc	ra,0x4
    80002a50:	bf0080e7          	jalr	-1040(ra) # 8000663c <plic_complete>
    return 1;
    80002a54:	4505                	li	a0,1
    80002a56:	bf55                	j	80002a0a <devintr+0x1e>
      uartintr();
    80002a58:	ffffe097          	auipc	ra,0xffffe
    80002a5c:	f42080e7          	jalr	-190(ra) # 8000099a <uartintr>
    80002a60:	b7ed                	j	80002a4a <devintr+0x5e>
      virtio_disk_intr();
    80002a62:	00004097          	auipc	ra,0x4
    80002a66:	0a6080e7          	jalr	166(ra) # 80006b08 <virtio_disk_intr>
    80002a6a:	b7c5                	j	80002a4a <devintr+0x5e>
    if (cpuid() == 0)
    80002a6c:	fffff097          	auipc	ra,0xfffff
    80002a70:	f14080e7          	jalr	-236(ra) # 80001980 <cpuid>
    80002a74:	c901                	beqz	a0,80002a84 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002a76:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002a7a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002a7c:	14479073          	csrw	sip,a5
    return 2;
    80002a80:	4509                	li	a0,2
    80002a82:	b761                	j	80002a0a <devintr+0x1e>
      clockintr();
    80002a84:	00000097          	auipc	ra,0x0
    80002a88:	f14080e7          	jalr	-236(ra) # 80002998 <clockintr>
    80002a8c:	b7ed                	j	80002a76 <devintr+0x8a>

0000000080002a8e <usertrap>:
{
    80002a8e:	711d                	addi	sp,sp,-96
    80002a90:	ec86                	sd	ra,88(sp)
    80002a92:	e8a2                	sd	s0,80(sp)
    80002a94:	e4a6                	sd	s1,72(sp)
    80002a96:	e0ca                	sd	s2,64(sp)
    80002a98:	fc4e                	sd	s3,56(sp)
    80002a9a:	f852                	sd	s4,48(sp)
    80002a9c:	f456                	sd	s5,40(sp)
    80002a9e:	f05a                	sd	s6,32(sp)
    80002aa0:	ec5e                	sd	s7,24(sp)
    80002aa2:	e862                	sd	s8,16(sp)
    80002aa4:	e466                	sd	s9,8(sp)
    80002aa6:	1080                	addi	s0,sp,96
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002aa8:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002aac:	1007f793          	andi	a5,a5,256
    80002ab0:	e3b1                	bnez	a5,80002af4 <usertrap+0x66>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ab2:	00004797          	auipc	a5,0x4
    80002ab6:	a5e78793          	addi	a5,a5,-1442 # 80006510 <kernelvec>
    80002aba:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002abe:	fffff097          	auipc	ra,0xfffff
    80002ac2:	eee080e7          	jalr	-274(ra) # 800019ac <myproc>
    80002ac6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002ac8:	6d5c                	ld	a5,152(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002aca:	14102773          	csrr	a4,sepc
    80002ace:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ad0:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002ad4:	47a1                	li	a5,8
    80002ad6:	02f70763          	beq	a4,a5,80002b04 <usertrap+0x76>
  else if ((which_dev = devintr()) != 0)
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	f12080e7          	jalr	-238(ra) # 800029ec <devintr>
    80002ae2:	892a                	mv	s2,a0
    80002ae4:	c949                	beqz	a0,80002b76 <usertrap+0xe8>
  if (killed(p))
    80002ae6:	8526                	mv	a0,s1
    80002ae8:	00000097          	auipc	ra,0x0
    80002aec:	8ea080e7          	jalr	-1814(ra) # 800023d2 <killed>
    80002af0:	c929                	beqz	a0,80002b42 <usertrap+0xb4>
    80002af2:	a099                	j	80002b38 <usertrap+0xaa>
    panic("usertrap: not from user mode");
    80002af4:	00006517          	auipc	a0,0x6
    80002af8:	82c50513          	addi	a0,a0,-2004 # 80008320 <states.0+0x58>
    80002afc:	ffffe097          	auipc	ra,0xffffe
    80002b00:	a42080e7          	jalr	-1470(ra) # 8000053e <panic>
    if (killed(p))
    80002b04:	00000097          	auipc	ra,0x0
    80002b08:	8ce080e7          	jalr	-1842(ra) # 800023d2 <killed>
    80002b0c:	ed39                	bnez	a0,80002b6a <usertrap+0xdc>
    p->trapframe->epc += 4;
    80002b0e:	6cd8                	ld	a4,152(s1)
    80002b10:	6f1c                	ld	a5,24(a4)
    80002b12:	0791                	addi	a5,a5,4
    80002b14:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b16:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002b1a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b1e:	10079073          	csrw	sstatus,a5
    syscall();
    80002b22:	00001097          	auipc	ra,0x1
    80002b26:	8d8080e7          	jalr	-1832(ra) # 800033fa <syscall>
  if (killed(p))
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	8a6080e7          	jalr	-1882(ra) # 800023d2 <killed>
    80002b34:	c911                	beqz	a0,80002b48 <usertrap+0xba>
    80002b36:	4901                	li	s2,0
    exit(-1);
    80002b38:	557d                	li	a0,-1
    80002b3a:	fffff097          	auipc	ra,0xfffff
    80002b3e:	718080e7          	jalr	1816(ra) # 80002252 <exit>
  if (which_dev == 2)
    80002b42:	4789                	li	a5,2
    80002b44:	06f90663          	beq	s2,a5,80002bb0 <usertrap+0x122>
  usertrapret();
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	dba080e7          	jalr	-582(ra) # 80002902 <usertrapret>
}
    80002b50:	60e6                	ld	ra,88(sp)
    80002b52:	6446                	ld	s0,80(sp)
    80002b54:	64a6                	ld	s1,72(sp)
    80002b56:	6906                	ld	s2,64(sp)
    80002b58:	79e2                	ld	s3,56(sp)
    80002b5a:	7a42                	ld	s4,48(sp)
    80002b5c:	7aa2                	ld	s5,40(sp)
    80002b5e:	7b02                	ld	s6,32(sp)
    80002b60:	6be2                	ld	s7,24(sp)
    80002b62:	6c42                	ld	s8,16(sp)
    80002b64:	6ca2                	ld	s9,8(sp)
    80002b66:	6125                	addi	sp,sp,96
    80002b68:	8082                	ret
      exit(-1);
    80002b6a:	557d                	li	a0,-1
    80002b6c:	fffff097          	auipc	ra,0xfffff
    80002b70:	6e6080e7          	jalr	1766(ra) # 80002252 <exit>
    80002b74:	bf69                	j	80002b0e <usertrap+0x80>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b76:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002b7a:	5890                	lw	a2,48(s1)
    80002b7c:	00005517          	auipc	a0,0x5
    80002b80:	7c450513          	addi	a0,a0,1988 # 80008340 <states.0+0x78>
    80002b84:	ffffe097          	auipc	ra,0xffffe
    80002b88:	a04080e7          	jalr	-1532(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b8c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002b90:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002b94:	00005517          	auipc	a0,0x5
    80002b98:	7dc50513          	addi	a0,a0,2012 # 80008370 <states.0+0xa8>
    80002b9c:	ffffe097          	auipc	ra,0xffffe
    80002ba0:	9ec080e7          	jalr	-1556(ra) # 80000588 <printf>
    setkilled(p);
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	00000097          	auipc	ra,0x0
    80002baa:	800080e7          	jalr	-2048(ra) # 800023a6 <setkilled>
    80002bae:	bfb5                	j	80002b2a <usertrap+0x9c>
    printf("%d %d %d\n", ticks, p->pid, p->queue);
    80002bb0:	50b4                	lw	a3,96(s1)
    80002bb2:	5890                	lw	a2,48(s1)
    80002bb4:	00006597          	auipc	a1,0x6
    80002bb8:	d3c5a583          	lw	a1,-708(a1) # 800088f0 <ticks>
    80002bbc:	00005517          	auipc	a0,0x5
    80002bc0:	7d450513          	addi	a0,a0,2004 # 80008390 <states.0+0xc8>
    80002bc4:	ffffe097          	auipc	ra,0xffffe
    80002bc8:	9c4080e7          	jalr	-1596(ra) # 80000588 <printf>
    p->currentticks++;
    80002bcc:	60bc                	ld	a5,64(s1)
    80002bce:	0785                	addi	a5,a5,1
    80002bd0:	e0bc                	sd	a5,64(s1)
    if (p->currentticks % p->ticks == 0 && p->ishandler == 0)
    80002bd2:	7c98                	ld	a4,56(s1)
    80002bd4:	02e7f7b3          	remu	a5,a5,a4
    80002bd8:	e399                	bnez	a5,80002bde <usertrap+0x150>
    80002bda:	68bc                	ld	a5,80(s1)
    80002bdc:	cb99                	beqz	a5,80002bf2 <usertrap+0x164>
  if (killed(p))
    80002bde:	0000e497          	auipc	s1,0xe
    80002be2:	3b248493          	addi	s1,s1,946 # 80010f90 <proc>
      if (p->state == RUNNABLE)
    80002be6:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002be8:	00015917          	auipc	s2,0x15
    80002bec:	1a890913          	addi	s2,s2,424 # 80017d90 <tickslock>
    80002bf0:	a81d                	j	80002c26 <usertrap+0x198>
      p->pasttrapframe = kalloc();
    80002bf2:	ffffe097          	auipc	ra,0xffffe
    80002bf6:	ef4080e7          	jalr	-268(ra) # 80000ae6 <kalloc>
    80002bfa:	eca8                	sd	a0,88(s1)
      p->ishandler = 1;
    80002bfc:	4785                	li	a5,1
    80002bfe:	e8bc                	sd	a5,80(s1)
      memmove(p->pasttrapframe, p->trapframe, PGSIZE);
    80002c00:	6605                	lui	a2,0x1
    80002c02:	6ccc                	ld	a1,152(s1)
    80002c04:	ffffe097          	auipc	ra,0xffffe
    80002c08:	12a080e7          	jalr	298(ra) # 80000d2e <memmove>
      p->trapframe->epc = p->funcadr;
    80002c0c:	6cdc                	ld	a5,152(s1)
    80002c0e:	64b8                	ld	a4,72(s1)
    80002c10:	ef98                	sd	a4,24(a5)
    80002c12:	b7f1                	j	80002bde <usertrap+0x150>
      release(&p->lock);
    80002c14:	8526                	mv	a0,s1
    80002c16:	ffffe097          	auipc	ra,0xffffe
    80002c1a:	074080e7          	jalr	116(ra) # 80000c8a <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c1e:	1b848493          	addi	s1,s1,440
    80002c22:	01248e63          	beq	s1,s2,80002c3e <usertrap+0x1b0>
      acquire(&p->lock);
    80002c26:	8526                	mv	a0,s1
    80002c28:	ffffe097          	auipc	ra,0xffffe
    80002c2c:	fae080e7          	jalr	-82(ra) # 80000bd6 <acquire>
      if (p->state == RUNNABLE)
    80002c30:	4c9c                	lw	a5,24(s1)
    80002c32:	ff3791e3          	bne	a5,s3,80002c14 <usertrap+0x186>
        p->timeofwait++;
    80002c36:	58bc                	lw	a5,112(s1)
    80002c38:	2785                	addiw	a5,a5,1
    80002c3a:	d8bc                	sw	a5,112(s1)
    80002c3c:	bfe1                	j	80002c14 <usertrap+0x186>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c3e:	0000e497          	auipc	s1,0xe
    80002c42:	35248493          	addi	s1,s1,850 # 80010f90 <proc>
      if (p->state == RUNNING)
    80002c46:	4991                	li	s3,4
    for (p = proc; p < &proc[NPROC]; p++)
    80002c48:	00015917          	auipc	s2,0x15
    80002c4c:	14890913          	addi	s2,s2,328 # 80017d90 <tickslock>
    80002c50:	a811                	j	80002c64 <usertrap+0x1d6>
      release(&p->lock);
    80002c52:	8526                	mv	a0,s1
    80002c54:	ffffe097          	auipc	ra,0xffffe
    80002c58:	036080e7          	jalr	54(ra) # 80000c8a <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c5c:	1b848493          	addi	s1,s1,440
    80002c60:	01248e63          	beq	s1,s2,80002c7c <usertrap+0x1ee>
      acquire(&p->lock);
    80002c64:	8526                	mv	a0,s1
    80002c66:	ffffe097          	auipc	ra,0xffffe
    80002c6a:	f70080e7          	jalr	-144(ra) # 80000bd6 <acquire>
      if (p->state == RUNNING)
    80002c6e:	4c9c                	lw	a5,24(s1)
    80002c70:	ff3791e3          	bne	a5,s3,80002c52 <usertrap+0x1c4>
        p->sliceticks++;
    80002c74:	50fc                	lw	a5,100(s1)
    80002c76:	2785                	addiw	a5,a5,1
    80002c78:	d0fc                	sw	a5,100(s1)
    80002c7a:	bfe1                	j	80002c52 <usertrap+0x1c4>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c7c:	0000e497          	auipc	s1,0xe
    80002c80:	31448493          	addi	s1,s1,788 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->timeofwait >= 30 && p->queue > 0)
    80002c84:	490d                	li	s2,3
    80002c86:	4a75                	li	s4,29
        if (p->pid >= 9)
    80002c88:	4aa1                	li	s5,8
        else if (p->queue == 1)
    80002c8a:	4b05                	li	s6,1
        else if (p->queue == 2)
    80002c8c:	4c09                	li	s8,2
          p->slicetime = 15;
    80002c8e:	4cbd                	li	s9,15
          printf("%d %d %d\n", ticks, p->pid, p->queue);
    80002c90:	00006b97          	auipc	s7,0x6
    80002c94:	c60b8b93          	addi	s7,s7,-928 # 800088f0 <ticks>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c98:	00015997          	auipc	s3,0x15
    80002c9c:	0f898993          	addi	s3,s3,248 # 80017d90 <tickslock>
    80002ca0:	a8a9                	j	80002cfa <usertrap+0x26c>
          printf("%d %d %d\n", ticks - 1, p->pid, p->queue);
    80002ca2:	000ba583          	lw	a1,0(s7)
    80002ca6:	35fd                	addiw	a1,a1,-1
    80002ca8:	00005517          	auipc	a0,0x5
    80002cac:	6e850513          	addi	a0,a0,1768 # 80008390 <states.0+0xc8>
    80002cb0:	ffffe097          	auipc	ra,0xffffe
    80002cb4:	8d8080e7          	jalr	-1832(ra) # 80000588 <printf>
    80002cb8:	a8a9                	j	80002d12 <usertrap+0x284>
          printf("%d %d %d\n", ticks, p->pid, p->queue);
    80002cba:	000ba583          	lw	a1,0(s7)
    80002cbe:	00005517          	auipc	a0,0x5
    80002cc2:	6d250513          	addi	a0,a0,1746 # 80008390 <states.0+0xc8>
    80002cc6:	ffffe097          	auipc	ra,0xffffe
    80002cca:	8c2080e7          	jalr	-1854(ra) # 80000588 <printf>
    80002cce:	a891                	j	80002d22 <usertrap+0x294>
        else if (p->queue == 1)
    80002cd0:	01678963          	beq	a5,s6,80002ce2 <usertrap+0x254>
        else if (p->queue == 2)
    80002cd4:	05878c63          	beq	a5,s8,80002d2c <usertrap+0x29e>
        else if (p->queue == 3)
    80002cd8:	01279763          	bne	a5,s2,80002ce6 <usertrap+0x258>
          p->slicetime = 15;
    80002cdc:	0794a423          	sw	s9,104(s1)
    80002ce0:	a019                	j	80002ce6 <usertrap+0x258>
          p->slicetime = 3;
    80002ce2:	0724a423          	sw	s2,104(s1)
        p->sliceticks = 0;
    80002ce6:	0604a223          	sw	zero,100(s1)
        p->timeofwait = 0;
    80002cea:	0604a823          	sw	zero,112(s1)
        p->flagforio = 0;
    80002cee:	0604a623          	sw	zero,108(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80002cf2:	1b848493          	addi	s1,s1,440
    80002cf6:	03348e63          	beq	s1,s3,80002d32 <usertrap+0x2a4>
      if (p->state == RUNNABLE && p->timeofwait >= 30 && p->queue > 0)
    80002cfa:	4c9c                	lw	a5,24(s1)
    80002cfc:	ff279be3          	bne	a5,s2,80002cf2 <usertrap+0x264>
    80002d00:	58bc                	lw	a5,112(s1)
    80002d02:	fefa58e3          	bge	s4,a5,80002cf2 <usertrap+0x264>
    80002d06:	50b4                	lw	a3,96(s1)
    80002d08:	fed055e3          	blez	a3,80002cf2 <usertrap+0x264>
        if (p->pid >= 9)
    80002d0c:	5890                	lw	a2,48(s1)
    80002d0e:	f8cacae3          	blt	s5,a2,80002ca2 <usertrap+0x214>
        p->queue--;
    80002d12:	50bc                	lw	a5,96(s1)
    80002d14:	37fd                	addiw	a5,a5,-1
    80002d16:	0007869b          	sext.w	a3,a5
    80002d1a:	d0bc                	sw	a5,96(s1)
        if (p->pid >= 9)
    80002d1c:	5890                	lw	a2,48(s1)
    80002d1e:	f8cacee3          	blt	s5,a2,80002cba <usertrap+0x22c>
        if (p->queue == 0)
    80002d22:	50bc                	lw	a5,96(s1)
    80002d24:	f7d5                	bnez	a5,80002cd0 <usertrap+0x242>
          p->slicetime = 1;
    80002d26:	0764a423          	sw	s6,104(s1)
    80002d2a:	bf75                	j	80002ce6 <usertrap+0x258>
          p->slicetime = 9;
    80002d2c:	47a5                	li	a5,9
    80002d2e:	d4bc                	sw	a5,104(s1)
    80002d30:	bf5d                	j	80002ce6 <usertrap+0x258>
    for (p = proc; p < &proc[NPROC]; p++)
    80002d32:	0000e497          	auipc	s1,0xe
    80002d36:	25e48493          	addi	s1,s1,606 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 0 && p->queue < myproc()->queue)
    80002d3a:	498d                	li	s3,3
        myproc()->flagforio = 1;
    80002d3c:	4a05                	li	s4,1
    for (p = proc; p < &proc[NPROC]; p++)
    80002d3e:	00015917          	auipc	s2,0x15
    80002d42:	05290913          	addi	s2,s2,82 # 80017d90 <tickslock>
    80002d46:	a839                	j	80002d64 <usertrap+0x2d6>
        myproc()->flagforio = 1;
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	c64080e7          	jalr	-924(ra) # 800019ac <myproc>
    80002d50:	07452623          	sw	s4,108(a0)
        yield();
    80002d54:	fffff097          	auipc	ra,0xfffff
    80002d58:	38e080e7          	jalr	910(ra) # 800020e2 <yield>
    for (p = proc; p < &proc[NPROC]; p++)
    80002d5c:	1b848493          	addi	s1,s1,440
    80002d60:	01248f63          	beq	s1,s2,80002d7e <usertrap+0x2f0>
      if (p->state == RUNNABLE && p->queue == 0 && p->queue < myproc()->queue)
    80002d64:	4c9c                	lw	a5,24(s1)
    80002d66:	ff379be3          	bne	a5,s3,80002d5c <usertrap+0x2ce>
    80002d6a:	50bc                	lw	a5,96(s1)
    80002d6c:	fbe5                	bnez	a5,80002d5c <usertrap+0x2ce>
    80002d6e:	fffff097          	auipc	ra,0xfffff
    80002d72:	c3e080e7          	jalr	-962(ra) # 800019ac <myproc>
    80002d76:	513c                	lw	a5,96(a0)
    80002d78:	fef052e3          	blez	a5,80002d5c <usertrap+0x2ce>
    80002d7c:	b7f1                	j	80002d48 <usertrap+0x2ba>
    for (p = proc; p < &proc[NPROC]; p++)
    80002d7e:	0000e497          	auipc	s1,0xe
    80002d82:	21248493          	addi	s1,s1,530 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 1 && p->queue < myproc()->queue)
    80002d86:	498d                	li	s3,3
    80002d88:	4a05                	li	s4,1
    for (p = proc; p < &proc[NPROC]; p++)
    80002d8a:	00015917          	auipc	s2,0x15
    80002d8e:	00690913          	addi	s2,s2,6 # 80017d90 <tickslock>
    80002d92:	a029                	j	80002d9c <usertrap+0x30e>
    80002d94:	1b848493          	addi	s1,s1,440
    80002d98:	03248a63          	beq	s1,s2,80002dcc <usertrap+0x33e>
      if (p->state == RUNNABLE && p->queue == 1 && p->queue < myproc()->queue)
    80002d9c:	4c9c                	lw	a5,24(s1)
    80002d9e:	ff379be3          	bne	a5,s3,80002d94 <usertrap+0x306>
    80002da2:	50bc                	lw	a5,96(s1)
    80002da4:	ff4798e3          	bne	a5,s4,80002d94 <usertrap+0x306>
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	c04080e7          	jalr	-1020(ra) # 800019ac <myproc>
    80002db0:	513c                	lw	a5,96(a0)
    80002db2:	fefa51e3          	bge	s4,a5,80002d94 <usertrap+0x306>
        myproc()->flagforio = 1;
    80002db6:	fffff097          	auipc	ra,0xfffff
    80002dba:	bf6080e7          	jalr	-1034(ra) # 800019ac <myproc>
    80002dbe:	07452623          	sw	s4,108(a0)
        yield();
    80002dc2:	fffff097          	auipc	ra,0xfffff
    80002dc6:	320080e7          	jalr	800(ra) # 800020e2 <yield>
    80002dca:	b7e9                	j	80002d94 <usertrap+0x306>
    for (p = proc; p < &proc[NPROC]; p++)
    80002dcc:	0000e497          	auipc	s1,0xe
    80002dd0:	1c448493          	addi	s1,s1,452 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 2 && p->queue < myproc()->queue)
    80002dd4:	498d                	li	s3,3
    80002dd6:	4a09                	li	s4,2
        myproc()->flagforio = 1;
    80002dd8:	4a85                	li	s5,1
    for (p = proc; p < &proc[NPROC]; p++)
    80002dda:	00015917          	auipc	s2,0x15
    80002dde:	fb690913          	addi	s2,s2,-74 # 80017d90 <tickslock>
    80002de2:	a029                	j	80002dec <usertrap+0x35e>
    80002de4:	1b848493          	addi	s1,s1,440
    80002de8:	03248a63          	beq	s1,s2,80002e1c <usertrap+0x38e>
      if (p->state == RUNNABLE && p->queue == 2 && p->queue < myproc()->queue)
    80002dec:	4c9c                	lw	a5,24(s1)
    80002dee:	ff379be3          	bne	a5,s3,80002de4 <usertrap+0x356>
    80002df2:	50bc                	lw	a5,96(s1)
    80002df4:	ff4798e3          	bne	a5,s4,80002de4 <usertrap+0x356>
    80002df8:	fffff097          	auipc	ra,0xfffff
    80002dfc:	bb4080e7          	jalr	-1100(ra) # 800019ac <myproc>
    80002e00:	513c                	lw	a5,96(a0)
    80002e02:	fefa51e3          	bge	s4,a5,80002de4 <usertrap+0x356>
        myproc()->flagforio = 1;
    80002e06:	fffff097          	auipc	ra,0xfffff
    80002e0a:	ba6080e7          	jalr	-1114(ra) # 800019ac <myproc>
    80002e0e:	07552623          	sw	s5,108(a0)
        yield();
    80002e12:	fffff097          	auipc	ra,0xfffff
    80002e16:	2d0080e7          	jalr	720(ra) # 800020e2 <yield>
    80002e1a:	b7e9                	j	80002de4 <usertrap+0x356>
    for (p = proc; p < &proc[NPROC]; p++)
    80002e1c:	0000e497          	auipc	s1,0xe
    80002e20:	17448493          	addi	s1,s1,372 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 3 && p->queue < myproc()->queue)
    80002e24:	490d                	li	s2,3
        myproc()->flagforio = 1;
    80002e26:	4a05                	li	s4,1
    for (p = proc; p < &proc[NPROC]; p++)
    80002e28:	00015997          	auipc	s3,0x15
    80002e2c:	f6898993          	addi	s3,s3,-152 # 80017d90 <tickslock>
    80002e30:	a029                	j	80002e3a <usertrap+0x3ac>
    80002e32:	1b848493          	addi	s1,s1,440
    80002e36:	03348a63          	beq	s1,s3,80002e6a <usertrap+0x3dc>
      if (p->state == RUNNABLE && p->queue == 3 && p->queue < myproc()->queue)
    80002e3a:	4c9c                	lw	a5,24(s1)
    80002e3c:	ff279be3          	bne	a5,s2,80002e32 <usertrap+0x3a4>
    80002e40:	50bc                	lw	a5,96(s1)
    80002e42:	ff2798e3          	bne	a5,s2,80002e32 <usertrap+0x3a4>
    80002e46:	fffff097          	auipc	ra,0xfffff
    80002e4a:	b66080e7          	jalr	-1178(ra) # 800019ac <myproc>
    80002e4e:	513c                	lw	a5,96(a0)
    80002e50:	fef951e3          	bge	s2,a5,80002e32 <usertrap+0x3a4>
        myproc()->flagforio = 1;
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	b58080e7          	jalr	-1192(ra) # 800019ac <myproc>
    80002e5c:	07452623          	sw	s4,108(a0)
        yield();
    80002e60:	fffff097          	auipc	ra,0xfffff
    80002e64:	282080e7          	jalr	642(ra) # 800020e2 <yield>
    80002e68:	b7e9                	j	80002e32 <usertrap+0x3a4>
    p = myproc();
    80002e6a:	fffff097          	auipc	ra,0xfffff
    80002e6e:	b42080e7          	jalr	-1214(ra) # 800019ac <myproc>
    80002e72:	84aa                	mv	s1,a0
    if (p->sliceticks == p->slicetime)
    80002e74:	5178                	lw	a4,100(a0)
    80002e76:	553c                	lw	a5,104(a0)
    80002e78:	ccf718e3          	bne	a4,a5,80002b48 <usertrap+0xba>
      p->flagforio = 0;
    80002e7c:	06052623          	sw	zero,108(a0)
      if (p->queue < 3)
    80002e80:	513c                	lw	a5,96(a0)
    80002e82:	4709                	li	a4,2
    80002e84:	00f74463          	blt	a4,a5,80002e8c <usertrap+0x3fe>
        p->queue++;
    80002e88:	2785                	addiw	a5,a5,1
    80002e8a:	d13c                	sw	a5,96(a0)
      if (p->pid >= 9)
    80002e8c:	5890                	lw	a2,48(s1)
    80002e8e:	47a1                	li	a5,8
    80002e90:	00c7cf63          	blt	a5,a2,80002eae <usertrap+0x420>
      if (p->queue == 1)
    80002e94:	50bc                	lw	a5,96(s1)
    80002e96:	4705                	li	a4,1
    80002e98:	02e78963          	beq	a5,a4,80002eca <usertrap+0x43c>
      else if (p->queue == 2)
    80002e9c:	4709                	li	a4,2
    80002e9e:	04e78163          	beq	a5,a4,80002ee0 <usertrap+0x452>
      else if (p->queue == 3)
    80002ea2:	470d                	li	a4,3
    80002ea4:	02e79563          	bne	a5,a4,80002ece <usertrap+0x440>
        p->slicetime = 15;
    80002ea8:	47bd                	li	a5,15
    80002eaa:	d4bc                	sw	a5,104(s1)
    80002eac:	a00d                	j	80002ece <usertrap+0x440>
        printf("%d %d %d\n", ticks, p->pid, p->queue);
    80002eae:	50b4                	lw	a3,96(s1)
    80002eb0:	00006597          	auipc	a1,0x6
    80002eb4:	a405a583          	lw	a1,-1472(a1) # 800088f0 <ticks>
    80002eb8:	00005517          	auipc	a0,0x5
    80002ebc:	4d850513          	addi	a0,a0,1240 # 80008390 <states.0+0xc8>
    80002ec0:	ffffd097          	auipc	ra,0xffffd
    80002ec4:	6c8080e7          	jalr	1736(ra) # 80000588 <printf>
    80002ec8:	b7f1                	j	80002e94 <usertrap+0x406>
        p->slicetime = 3;
    80002eca:	478d                	li	a5,3
    80002ecc:	d4bc                	sw	a5,104(s1)
      p->sliceticks = 0;
    80002ece:	0604a223          	sw	zero,100(s1)
      p->timeofwait = 0;
    80002ed2:	0604a823          	sw	zero,112(s1)
      yield();
    80002ed6:	fffff097          	auipc	ra,0xfffff
    80002eda:	20c080e7          	jalr	524(ra) # 800020e2 <yield>
    80002ede:	b1ad                	j	80002b48 <usertrap+0xba>
        p->slicetime = 9;
    80002ee0:	47a5                	li	a5,9
    80002ee2:	d4bc                	sw	a5,104(s1)
    80002ee4:	b7ed                	j	80002ece <usertrap+0x440>

0000000080002ee6 <kerneltrap>:
{
    80002ee6:	7159                	addi	sp,sp,-112
    80002ee8:	f486                	sd	ra,104(sp)
    80002eea:	f0a2                	sd	s0,96(sp)
    80002eec:	eca6                	sd	s1,88(sp)
    80002eee:	e8ca                	sd	s2,80(sp)
    80002ef0:	e4ce                	sd	s3,72(sp)
    80002ef2:	e0d2                	sd	s4,64(sp)
    80002ef4:	fc56                	sd	s5,56(sp)
    80002ef6:	f85a                	sd	s6,48(sp)
    80002ef8:	f45e                	sd	s7,40(sp)
    80002efa:	f062                	sd	s8,32(sp)
    80002efc:	ec66                	sd	s9,24(sp)
    80002efe:	e86a                	sd	s10,16(sp)
    80002f00:	e46e                	sd	s11,8(sp)
    80002f02:	1880                	addi	s0,sp,112
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f04:	141029f3          	csrr	s3,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f08:	10002973          	csrr	s2,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f0c:	142024f3          	csrr	s1,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002f10:	10097793          	andi	a5,s2,256
    80002f14:	c3a1                	beqz	a5,80002f54 <kerneltrap+0x6e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f16:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f1a:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002f1c:	e7a1                	bnez	a5,80002f64 <kerneltrap+0x7e>
  if ((which_dev = devintr()) == 0)
    80002f1e:	00000097          	auipc	ra,0x0
    80002f22:	ace080e7          	jalr	-1330(ra) # 800029ec <devintr>
    80002f26:	c539                	beqz	a0,80002f74 <kerneltrap+0x8e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f28:	4789                	li	a5,2
    80002f2a:	08f50263          	beq	a0,a5,80002fae <kerneltrap+0xc8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f2e:	14199073          	csrw	sepc,s3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f32:	10091073          	csrw	sstatus,s2
}
    80002f36:	70a6                	ld	ra,104(sp)
    80002f38:	7406                	ld	s0,96(sp)
    80002f3a:	64e6                	ld	s1,88(sp)
    80002f3c:	6946                	ld	s2,80(sp)
    80002f3e:	69a6                	ld	s3,72(sp)
    80002f40:	6a06                	ld	s4,64(sp)
    80002f42:	7ae2                	ld	s5,56(sp)
    80002f44:	7b42                	ld	s6,48(sp)
    80002f46:	7ba2                	ld	s7,40(sp)
    80002f48:	7c02                	ld	s8,32(sp)
    80002f4a:	6ce2                	ld	s9,24(sp)
    80002f4c:	6d42                	ld	s10,16(sp)
    80002f4e:	6da2                	ld	s11,8(sp)
    80002f50:	6165                	addi	sp,sp,112
    80002f52:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002f54:	00005517          	auipc	a0,0x5
    80002f58:	44c50513          	addi	a0,a0,1100 # 800083a0 <states.0+0xd8>
    80002f5c:	ffffd097          	auipc	ra,0xffffd
    80002f60:	5e2080e7          	jalr	1506(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    80002f64:	00005517          	auipc	a0,0x5
    80002f68:	46450513          	addi	a0,a0,1124 # 800083c8 <states.0+0x100>
    80002f6c:	ffffd097          	auipc	ra,0xffffd
    80002f70:	5d2080e7          	jalr	1490(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80002f74:	85a6                	mv	a1,s1
    80002f76:	00005517          	auipc	a0,0x5
    80002f7a:	47250513          	addi	a0,a0,1138 # 800083e8 <states.0+0x120>
    80002f7e:	ffffd097          	auipc	ra,0xffffd
    80002f82:	60a080e7          	jalr	1546(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f86:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f8a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f8e:	00005517          	auipc	a0,0x5
    80002f92:	46a50513          	addi	a0,a0,1130 # 800083f8 <states.0+0x130>
    80002f96:	ffffd097          	auipc	ra,0xffffd
    80002f9a:	5f2080e7          	jalr	1522(ra) # 80000588 <printf>
    panic("kerneltrap");
    80002f9e:	00005517          	auipc	a0,0x5
    80002fa2:	47250513          	addi	a0,a0,1138 # 80008410 <states.0+0x148>
    80002fa6:	ffffd097          	auipc	ra,0xffffd
    80002faa:	598080e7          	jalr	1432(ra) # 8000053e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002fae:	fffff097          	auipc	ra,0xfffff
    80002fb2:	9fe080e7          	jalr	-1538(ra) # 800019ac <myproc>
    80002fb6:	dd25                	beqz	a0,80002f2e <kerneltrap+0x48>
    80002fb8:	fffff097          	auipc	ra,0xfffff
    80002fbc:	9f4080e7          	jalr	-1548(ra) # 800019ac <myproc>
    80002fc0:	4d18                	lw	a4,24(a0)
    80002fc2:	4791                	li	a5,4
    80002fc4:	f6f715e3          	bne	a4,a5,80002f2e <kerneltrap+0x48>
    for (p = proc; p < &proc[NPROC]; p++)
    80002fc8:	0000e497          	auipc	s1,0xe
    80002fcc:	fc848493          	addi	s1,s1,-56 # 80010f90 <proc>
      if (p->state == RUNNABLE)
    80002fd0:	4a8d                	li	s5,3
      if (p->state == RUNNING)
    80002fd2:	4b11                	li	s6,4
    for (p = proc; p < &proc[NPROC]; p++)
    80002fd4:	00015a17          	auipc	s4,0x15
    80002fd8:	dbca0a13          	addi	s4,s4,-580 # 80017d90 <tickslock>
    80002fdc:	a829                	j	80002ff6 <kerneltrap+0x110>
        p->timeofwait++;
    80002fde:	58bc                	lw	a5,112(s1)
    80002fe0:	2785                	addiw	a5,a5,1
    80002fe2:	d8bc                	sw	a5,112(s1)
      release(&p->lock);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	ffffe097          	auipc	ra,0xffffe
    80002fea:	ca4080e7          	jalr	-860(ra) # 80000c8a <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002fee:	1b848493          	addi	s1,s1,440
    80002ff2:	03448063          	beq	s1,s4,80003012 <kerneltrap+0x12c>
      acquire(&p->lock);
    80002ff6:	8526                	mv	a0,s1
    80002ff8:	ffffe097          	auipc	ra,0xffffe
    80002ffc:	bde080e7          	jalr	-1058(ra) # 80000bd6 <acquire>
      if (p->state == RUNNABLE)
    80003000:	4c9c                	lw	a5,24(s1)
    80003002:	fd578ee3          	beq	a5,s5,80002fde <kerneltrap+0xf8>
      if (p->state == RUNNING)
    80003006:	fd679fe3          	bne	a5,s6,80002fe4 <kerneltrap+0xfe>
        p->sliceticks++;
    8000300a:	50fc                	lw	a5,100(s1)
    8000300c:	2785                	addiw	a5,a5,1
    8000300e:	d0fc                	sw	a5,100(s1)
    80003010:	bfd1                	j	80002fe4 <kerneltrap+0xfe>
    for (p = proc; p < &proc[NPROC]; p++)
    80003012:	0000e497          	auipc	s1,0xe
    80003016:	f7e48493          	addi	s1,s1,-130 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->timeofwait >= 30 && p->queue > 0)
    8000301a:	4a0d                	li	s4,3
    8000301c:	4b75                	li	s6,29
        if (p->pid >= 9)
    8000301e:	4ba1                	li	s7,8
        else if (p->queue == 1)
    80003020:	4c05                	li	s8,1
        else if (p->queue == 2)
    80003022:	4d09                	li	s10,2
          p->slicetime = 15;
    80003024:	4dbd                	li	s11,15
          printf("%d %d %d\n", ticks, p->pid, p->queue);
    80003026:	00006c97          	auipc	s9,0x6
    8000302a:	8cac8c93          	addi	s9,s9,-1846 # 800088f0 <ticks>
    for (p = proc; p < &proc[NPROC]; p++)
    8000302e:	00015a97          	auipc	s5,0x15
    80003032:	d62a8a93          	addi	s5,s5,-670 # 80017d90 <tickslock>
    80003036:	a8a9                	j	80003090 <kerneltrap+0x1aa>
          printf("%d %d %d\n", ticks - 1, p->pid, p->queue);
    80003038:	000ca583          	lw	a1,0(s9)
    8000303c:	35fd                	addiw	a1,a1,-1
    8000303e:	00005517          	auipc	a0,0x5
    80003042:	35250513          	addi	a0,a0,850 # 80008390 <states.0+0xc8>
    80003046:	ffffd097          	auipc	ra,0xffffd
    8000304a:	542080e7          	jalr	1346(ra) # 80000588 <printf>
    8000304e:	a8a9                	j	800030a8 <kerneltrap+0x1c2>
          printf("%d %d %d\n", ticks, p->pid, p->queue);
    80003050:	000ca583          	lw	a1,0(s9)
    80003054:	00005517          	auipc	a0,0x5
    80003058:	33c50513          	addi	a0,a0,828 # 80008390 <states.0+0xc8>
    8000305c:	ffffd097          	auipc	ra,0xffffd
    80003060:	52c080e7          	jalr	1324(ra) # 80000588 <printf>
    80003064:	a891                	j	800030b8 <kerneltrap+0x1d2>
        else if (p->queue == 1)
    80003066:	01878963          	beq	a5,s8,80003078 <kerneltrap+0x192>
        else if (p->queue == 2)
    8000306a:	05a78c63          	beq	a5,s10,800030c2 <kerneltrap+0x1dc>
        else if (p->queue == 3)
    8000306e:	01479763          	bne	a5,s4,8000307c <kerneltrap+0x196>
          p->slicetime = 15;
    80003072:	07b4a423          	sw	s11,104(s1)
    80003076:	a019                	j	8000307c <kerneltrap+0x196>
          p->slicetime = 3;
    80003078:	0744a423          	sw	s4,104(s1)
        p->sliceticks = 0;
    8000307c:	0604a223          	sw	zero,100(s1)
        p->timeofwait = 0;
    80003080:	0604a823          	sw	zero,112(s1)
        p->flagforio = 0;
    80003084:	0604a623          	sw	zero,108(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80003088:	1b848493          	addi	s1,s1,440
    8000308c:	03548e63          	beq	s1,s5,800030c8 <kerneltrap+0x1e2>
      if (p->state == RUNNABLE && p->timeofwait >= 30 && p->queue > 0)
    80003090:	4c9c                	lw	a5,24(s1)
    80003092:	ff479be3          	bne	a5,s4,80003088 <kerneltrap+0x1a2>
    80003096:	58bc                	lw	a5,112(s1)
    80003098:	fefb58e3          	bge	s6,a5,80003088 <kerneltrap+0x1a2>
    8000309c:	50b4                	lw	a3,96(s1)
    8000309e:	fed055e3          	blez	a3,80003088 <kerneltrap+0x1a2>
        if (p->pid >= 9)
    800030a2:	5890                	lw	a2,48(s1)
    800030a4:	f8cbcae3          	blt	s7,a2,80003038 <kerneltrap+0x152>
        p->queue--;
    800030a8:	50bc                	lw	a5,96(s1)
    800030aa:	37fd                	addiw	a5,a5,-1
    800030ac:	0007869b          	sext.w	a3,a5
    800030b0:	d0bc                	sw	a5,96(s1)
        if (p->pid >= 9)
    800030b2:	5890                	lw	a2,48(s1)
    800030b4:	f8cbcee3          	blt	s7,a2,80003050 <kerneltrap+0x16a>
        if (p->queue == 0)
    800030b8:	50bc                	lw	a5,96(s1)
    800030ba:	f7d5                	bnez	a5,80003066 <kerneltrap+0x180>
          p->slicetime = 1;
    800030bc:	0784a423          	sw	s8,104(s1)
    800030c0:	bf75                	j	8000307c <kerneltrap+0x196>
          p->slicetime = 9;
    800030c2:	47a5                	li	a5,9
    800030c4:	d4bc                	sw	a5,104(s1)
    800030c6:	bf5d                	j	8000307c <kerneltrap+0x196>
    for (p = proc; p < &proc[NPROC]; p++)
    800030c8:	0000e497          	auipc	s1,0xe
    800030cc:	ec848493          	addi	s1,s1,-312 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 0 && p->queue < myproc()->queue)
    800030d0:	4a8d                	li	s5,3
        myproc()->flagforio = 1;
    800030d2:	4b05                	li	s6,1
    for (p = proc; p < &proc[NPROC]; p++)
    800030d4:	00015a17          	auipc	s4,0x15
    800030d8:	cbca0a13          	addi	s4,s4,-836 # 80017d90 <tickslock>
    800030dc:	a839                	j	800030fa <kerneltrap+0x214>
        myproc()->flagforio = 1;
    800030de:	fffff097          	auipc	ra,0xfffff
    800030e2:	8ce080e7          	jalr	-1842(ra) # 800019ac <myproc>
    800030e6:	07652623          	sw	s6,108(a0)
        yield();
    800030ea:	fffff097          	auipc	ra,0xfffff
    800030ee:	ff8080e7          	jalr	-8(ra) # 800020e2 <yield>
    for (p = proc; p < &proc[NPROC]; p++)
    800030f2:	1b848493          	addi	s1,s1,440
    800030f6:	01448f63          	beq	s1,s4,80003114 <kerneltrap+0x22e>
      if (p->state == RUNNABLE && p->queue == 0 && p->queue < myproc()->queue)
    800030fa:	4c9c                	lw	a5,24(s1)
    800030fc:	ff579be3          	bne	a5,s5,800030f2 <kerneltrap+0x20c>
    80003100:	50bc                	lw	a5,96(s1)
    80003102:	fbe5                	bnez	a5,800030f2 <kerneltrap+0x20c>
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	8a8080e7          	jalr	-1880(ra) # 800019ac <myproc>
    8000310c:	513c                	lw	a5,96(a0)
    8000310e:	fef052e3          	blez	a5,800030f2 <kerneltrap+0x20c>
    80003112:	b7f1                	j	800030de <kerneltrap+0x1f8>
    for (p = proc; p < &proc[NPROC]; p++)
    80003114:	0000e497          	auipc	s1,0xe
    80003118:	e7c48493          	addi	s1,s1,-388 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 1 && p->queue < myproc()->queue)
    8000311c:	4a8d                	li	s5,3
    8000311e:	4b05                	li	s6,1
    for (p = proc; p < &proc[NPROC]; p++)
    80003120:	00015a17          	auipc	s4,0x15
    80003124:	c70a0a13          	addi	s4,s4,-912 # 80017d90 <tickslock>
    80003128:	a029                	j	80003132 <kerneltrap+0x24c>
    8000312a:	1b848493          	addi	s1,s1,440
    8000312e:	03448a63          	beq	s1,s4,80003162 <kerneltrap+0x27c>
      if (p->state == RUNNABLE && p->queue == 1 && p->queue < myproc()->queue)
    80003132:	4c9c                	lw	a5,24(s1)
    80003134:	ff579be3          	bne	a5,s5,8000312a <kerneltrap+0x244>
    80003138:	50bc                	lw	a5,96(s1)
    8000313a:	ff6798e3          	bne	a5,s6,8000312a <kerneltrap+0x244>
    8000313e:	fffff097          	auipc	ra,0xfffff
    80003142:	86e080e7          	jalr	-1938(ra) # 800019ac <myproc>
    80003146:	513c                	lw	a5,96(a0)
    80003148:	fefb51e3          	bge	s6,a5,8000312a <kerneltrap+0x244>
        myproc()->flagforio = 1;
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	860080e7          	jalr	-1952(ra) # 800019ac <myproc>
    80003154:	07652623          	sw	s6,108(a0)
        yield();
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	f8a080e7          	jalr	-118(ra) # 800020e2 <yield>
    80003160:	b7e9                	j	8000312a <kerneltrap+0x244>
    for (p = proc; p < &proc[NPROC]; p++)
    80003162:	0000e497          	auipc	s1,0xe
    80003166:	e2e48493          	addi	s1,s1,-466 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 2 && p->queue < myproc()->queue)
    8000316a:	4a8d                	li	s5,3
    8000316c:	4b09                	li	s6,2
        myproc()->flagforio = 1;
    8000316e:	4b85                	li	s7,1
    for (p = proc; p < &proc[NPROC]; p++)
    80003170:	00015a17          	auipc	s4,0x15
    80003174:	c20a0a13          	addi	s4,s4,-992 # 80017d90 <tickslock>
    80003178:	a029                	j	80003182 <kerneltrap+0x29c>
    8000317a:	1b848493          	addi	s1,s1,440
    8000317e:	03448a63          	beq	s1,s4,800031b2 <kerneltrap+0x2cc>
      if (p->state == RUNNABLE && p->queue == 2 && p->queue < myproc()->queue)
    80003182:	4c9c                	lw	a5,24(s1)
    80003184:	ff579be3          	bne	a5,s5,8000317a <kerneltrap+0x294>
    80003188:	50bc                	lw	a5,96(s1)
    8000318a:	ff6798e3          	bne	a5,s6,8000317a <kerneltrap+0x294>
    8000318e:	fffff097          	auipc	ra,0xfffff
    80003192:	81e080e7          	jalr	-2018(ra) # 800019ac <myproc>
    80003196:	513c                	lw	a5,96(a0)
    80003198:	fefb51e3          	bge	s6,a5,8000317a <kerneltrap+0x294>
        myproc()->flagforio = 1;
    8000319c:	fffff097          	auipc	ra,0xfffff
    800031a0:	810080e7          	jalr	-2032(ra) # 800019ac <myproc>
    800031a4:	07752623          	sw	s7,108(a0)
        yield();
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	f3a080e7          	jalr	-198(ra) # 800020e2 <yield>
    800031b0:	b7e9                	j	8000317a <kerneltrap+0x294>
    for (p = proc; p < &proc[NPROC]; p++)
    800031b2:	0000e497          	auipc	s1,0xe
    800031b6:	dde48493          	addi	s1,s1,-546 # 80010f90 <proc>
      if (p->state == RUNNABLE && p->queue == 3 && p->queue < myproc()->queue)
    800031ba:	4a0d                	li	s4,3
        myproc()->flagforio = 1;
    800031bc:	4b05                	li	s6,1
    for (p = proc; p < &proc[NPROC]; p++)
    800031be:	00015a97          	auipc	s5,0x15
    800031c2:	bd2a8a93          	addi	s5,s5,-1070 # 80017d90 <tickslock>
    800031c6:	a029                	j	800031d0 <kerneltrap+0x2ea>
    800031c8:	1b848493          	addi	s1,s1,440
    800031cc:	03548a63          	beq	s1,s5,80003200 <kerneltrap+0x31a>
      if (p->state == RUNNABLE && p->queue == 3 && p->queue < myproc()->queue)
    800031d0:	4c9c                	lw	a5,24(s1)
    800031d2:	ff479be3          	bne	a5,s4,800031c8 <kerneltrap+0x2e2>
    800031d6:	50bc                	lw	a5,96(s1)
    800031d8:	ff4798e3          	bne	a5,s4,800031c8 <kerneltrap+0x2e2>
    800031dc:	ffffe097          	auipc	ra,0xffffe
    800031e0:	7d0080e7          	jalr	2000(ra) # 800019ac <myproc>
    800031e4:	513c                	lw	a5,96(a0)
    800031e6:	fefa51e3          	bge	s4,a5,800031c8 <kerneltrap+0x2e2>
        myproc()->flagforio = 1;
    800031ea:	ffffe097          	auipc	ra,0xffffe
    800031ee:	7c2080e7          	jalr	1986(ra) # 800019ac <myproc>
    800031f2:	07652623          	sw	s6,108(a0)
        yield();
    800031f6:	fffff097          	auipc	ra,0xfffff
    800031fa:	eec080e7          	jalr	-276(ra) # 800020e2 <yield>
    800031fe:	b7e9                	j	800031c8 <kerneltrap+0x2e2>
    p = myproc();
    80003200:	ffffe097          	auipc	ra,0xffffe
    80003204:	7ac080e7          	jalr	1964(ra) # 800019ac <myproc>
    80003208:	84aa                	mv	s1,a0
    if (p->sliceticks == p->slicetime)
    8000320a:	5178                	lw	a4,100(a0)
    8000320c:	553c                	lw	a5,104(a0)
    8000320e:	d2f710e3          	bne	a4,a5,80002f2e <kerneltrap+0x48>
      p->flagforio = 0;
    80003212:	06052623          	sw	zero,108(a0)
      if (p->queue < 3)
    80003216:	513c                	lw	a5,96(a0)
    80003218:	4709                	li	a4,2
    8000321a:	00f74463          	blt	a4,a5,80003222 <kerneltrap+0x33c>
        p->queue++;
    8000321e:	2785                	addiw	a5,a5,1
    80003220:	d13c                	sw	a5,96(a0)
      if (p->pid >= 9)
    80003222:	5890                	lw	a2,48(s1)
    80003224:	47a1                	li	a5,8
    80003226:	00c7cf63          	blt	a5,a2,80003244 <kerneltrap+0x35e>
      if (p->queue == 1)
    8000322a:	50bc                	lw	a5,96(s1)
    8000322c:	4705                	li	a4,1
    8000322e:	02e78963          	beq	a5,a4,80003260 <kerneltrap+0x37a>
      else if (p->queue == 2)
    80003232:	4709                	li	a4,2
    80003234:	04e78163          	beq	a5,a4,80003276 <kerneltrap+0x390>
      else if (p->queue == 3)
    80003238:	470d                	li	a4,3
    8000323a:	02e79563          	bne	a5,a4,80003264 <kerneltrap+0x37e>
        p->slicetime = 15;
    8000323e:	47bd                	li	a5,15
    80003240:	d4bc                	sw	a5,104(s1)
    80003242:	a00d                	j	80003264 <kerneltrap+0x37e>
        printf("%d %d %d\n", ticks, p->pid, p->queue);
    80003244:	50b4                	lw	a3,96(s1)
    80003246:	00005597          	auipc	a1,0x5
    8000324a:	6aa5a583          	lw	a1,1706(a1) # 800088f0 <ticks>
    8000324e:	00005517          	auipc	a0,0x5
    80003252:	14250513          	addi	a0,a0,322 # 80008390 <states.0+0xc8>
    80003256:	ffffd097          	auipc	ra,0xffffd
    8000325a:	332080e7          	jalr	818(ra) # 80000588 <printf>
    8000325e:	b7f1                	j	8000322a <kerneltrap+0x344>
        p->slicetime = 3;
    80003260:	478d                	li	a5,3
    80003262:	d4bc                	sw	a5,104(s1)
      p->sliceticks = 0;
    80003264:	0604a223          	sw	zero,100(s1)
      p->timeofwait = 0;
    80003268:	0604a823          	sw	zero,112(s1)
      yield();
    8000326c:	fffff097          	auipc	ra,0xfffff
    80003270:	e76080e7          	jalr	-394(ra) # 800020e2 <yield>
    80003274:	b96d                	j	80002f2e <kerneltrap+0x48>
        p->slicetime = 9;
    80003276:	47a5                	li	a5,9
    80003278:	d4bc                	sw	a5,104(s1)
    8000327a:	b7ed                	j	80003264 <kerneltrap+0x37e>

000000008000327c <argraw>:
    8000327c:	1101                	addi	sp,sp,-32
    8000327e:	ec06                	sd	ra,24(sp)
    80003280:	e822                	sd	s0,16(sp)
    80003282:	e426                	sd	s1,8(sp)
    80003284:	1000                	addi	s0,sp,32
    80003286:	84aa                	mv	s1,a0
    80003288:	ffffe097          	auipc	ra,0xffffe
    8000328c:	724080e7          	jalr	1828(ra) # 800019ac <myproc>
    80003290:	4795                	li	a5,5
    80003292:	0497e163          	bltu	a5,s1,800032d4 <argraw+0x58>
    80003296:	048a                	slli	s1,s1,0x2
    80003298:	00005717          	auipc	a4,0x5
    8000329c:	1b070713          	addi	a4,a4,432 # 80008448 <states.0+0x180>
    800032a0:	94ba                	add	s1,s1,a4
    800032a2:	409c                	lw	a5,0(s1)
    800032a4:	97ba                	add	a5,a5,a4
    800032a6:	8782                	jr	a5
    800032a8:	6d5c                	ld	a5,152(a0)
    800032aa:	7ba8                	ld	a0,112(a5)
    800032ac:	60e2                	ld	ra,24(sp)
    800032ae:	6442                	ld	s0,16(sp)
    800032b0:	64a2                	ld	s1,8(sp)
    800032b2:	6105                	addi	sp,sp,32
    800032b4:	8082                	ret
    800032b6:	6d5c                	ld	a5,152(a0)
    800032b8:	7fa8                	ld	a0,120(a5)
    800032ba:	bfcd                	j	800032ac <argraw+0x30>
    800032bc:	6d5c                	ld	a5,152(a0)
    800032be:	63c8                	ld	a0,128(a5)
    800032c0:	b7f5                	j	800032ac <argraw+0x30>
    800032c2:	6d5c                	ld	a5,152(a0)
    800032c4:	67c8                	ld	a0,136(a5)
    800032c6:	b7dd                	j	800032ac <argraw+0x30>
    800032c8:	6d5c                	ld	a5,152(a0)
    800032ca:	6bc8                	ld	a0,144(a5)
    800032cc:	b7c5                	j	800032ac <argraw+0x30>
    800032ce:	6d5c                	ld	a5,152(a0)
    800032d0:	6fc8                	ld	a0,152(a5)
    800032d2:	bfe9                	j	800032ac <argraw+0x30>
    800032d4:	00005517          	auipc	a0,0x5
    800032d8:	14c50513          	addi	a0,a0,332 # 80008420 <states.0+0x158>
    800032dc:	ffffd097          	auipc	ra,0xffffd
    800032e0:	262080e7          	jalr	610(ra) # 8000053e <panic>

00000000800032e4 <fetchaddr>:
    800032e4:	1101                	addi	sp,sp,-32
    800032e6:	ec06                	sd	ra,24(sp)
    800032e8:	e822                	sd	s0,16(sp)
    800032ea:	e426                	sd	s1,8(sp)
    800032ec:	e04a                	sd	s2,0(sp)
    800032ee:	1000                	addi	s0,sp,32
    800032f0:	84aa                	mv	s1,a0
    800032f2:	892e                	mv	s2,a1
    800032f4:	ffffe097          	auipc	ra,0xffffe
    800032f8:	6b8080e7          	jalr	1720(ra) # 800019ac <myproc>
    800032fc:	655c                	ld	a5,136(a0)
    800032fe:	02f4f863          	bgeu	s1,a5,8000332e <fetchaddr+0x4a>
    80003302:	00848713          	addi	a4,s1,8
    80003306:	02e7e663          	bltu	a5,a4,80003332 <fetchaddr+0x4e>
    8000330a:	46a1                	li	a3,8
    8000330c:	8626                	mv	a2,s1
    8000330e:	85ca                	mv	a1,s2
    80003310:	6948                	ld	a0,144(a0)
    80003312:	ffffe097          	auipc	ra,0xffffe
    80003316:	3e2080e7          	jalr	994(ra) # 800016f4 <copyin>
    8000331a:	00a03533          	snez	a0,a0
    8000331e:	40a00533          	neg	a0,a0
    80003322:	60e2                	ld	ra,24(sp)
    80003324:	6442                	ld	s0,16(sp)
    80003326:	64a2                	ld	s1,8(sp)
    80003328:	6902                	ld	s2,0(sp)
    8000332a:	6105                	addi	sp,sp,32
    8000332c:	8082                	ret
    8000332e:	557d                	li	a0,-1
    80003330:	bfcd                	j	80003322 <fetchaddr+0x3e>
    80003332:	557d                	li	a0,-1
    80003334:	b7fd                	j	80003322 <fetchaddr+0x3e>

0000000080003336 <fetchstr>:
    80003336:	7179                	addi	sp,sp,-48
    80003338:	f406                	sd	ra,40(sp)
    8000333a:	f022                	sd	s0,32(sp)
    8000333c:	ec26                	sd	s1,24(sp)
    8000333e:	e84a                	sd	s2,16(sp)
    80003340:	e44e                	sd	s3,8(sp)
    80003342:	1800                	addi	s0,sp,48
    80003344:	892a                	mv	s2,a0
    80003346:	84ae                	mv	s1,a1
    80003348:	89b2                	mv	s3,a2
    8000334a:	ffffe097          	auipc	ra,0xffffe
    8000334e:	662080e7          	jalr	1634(ra) # 800019ac <myproc>
    80003352:	86ce                	mv	a3,s3
    80003354:	864a                	mv	a2,s2
    80003356:	85a6                	mv	a1,s1
    80003358:	6948                	ld	a0,144(a0)
    8000335a:	ffffe097          	auipc	ra,0xffffe
    8000335e:	428080e7          	jalr	1064(ra) # 80001782 <copyinstr>
    80003362:	00054e63          	bltz	a0,8000337e <fetchstr+0x48>
    80003366:	8526                	mv	a0,s1
    80003368:	ffffe097          	auipc	ra,0xffffe
    8000336c:	ae6080e7          	jalr	-1306(ra) # 80000e4e <strlen>
    80003370:	70a2                	ld	ra,40(sp)
    80003372:	7402                	ld	s0,32(sp)
    80003374:	64e2                	ld	s1,24(sp)
    80003376:	6942                	ld	s2,16(sp)
    80003378:	69a2                	ld	s3,8(sp)
    8000337a:	6145                	addi	sp,sp,48
    8000337c:	8082                	ret
    8000337e:	557d                	li	a0,-1
    80003380:	bfc5                	j	80003370 <fetchstr+0x3a>

0000000080003382 <argint>:
    80003382:	1101                	addi	sp,sp,-32
    80003384:	ec06                	sd	ra,24(sp)
    80003386:	e822                	sd	s0,16(sp)
    80003388:	e426                	sd	s1,8(sp)
    8000338a:	1000                	addi	s0,sp,32
    8000338c:	84ae                	mv	s1,a1
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	eee080e7          	jalr	-274(ra) # 8000327c <argraw>
    80003396:	c088                	sw	a0,0(s1)
    80003398:	60e2                	ld	ra,24(sp)
    8000339a:	6442                	ld	s0,16(sp)
    8000339c:	64a2                	ld	s1,8(sp)
    8000339e:	6105                	addi	sp,sp,32
    800033a0:	8082                	ret

00000000800033a2 <argaddr>:
    800033a2:	1101                	addi	sp,sp,-32
    800033a4:	ec06                	sd	ra,24(sp)
    800033a6:	e822                	sd	s0,16(sp)
    800033a8:	e426                	sd	s1,8(sp)
    800033aa:	1000                	addi	s0,sp,32
    800033ac:	84ae                	mv	s1,a1
    800033ae:	00000097          	auipc	ra,0x0
    800033b2:	ece080e7          	jalr	-306(ra) # 8000327c <argraw>
    800033b6:	e088                	sd	a0,0(s1)
    800033b8:	60e2                	ld	ra,24(sp)
    800033ba:	6442                	ld	s0,16(sp)
    800033bc:	64a2                	ld	s1,8(sp)
    800033be:	6105                	addi	sp,sp,32
    800033c0:	8082                	ret

00000000800033c2 <argstr>:
    800033c2:	7179                	addi	sp,sp,-48
    800033c4:	f406                	sd	ra,40(sp)
    800033c6:	f022                	sd	s0,32(sp)
    800033c8:	ec26                	sd	s1,24(sp)
    800033ca:	e84a                	sd	s2,16(sp)
    800033cc:	1800                	addi	s0,sp,48
    800033ce:	84ae                	mv	s1,a1
    800033d0:	8932                	mv	s2,a2
    800033d2:	fd840593          	addi	a1,s0,-40
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	fcc080e7          	jalr	-52(ra) # 800033a2 <argaddr>
    800033de:	864a                	mv	a2,s2
    800033e0:	85a6                	mv	a1,s1
    800033e2:	fd843503          	ld	a0,-40(s0)
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	f50080e7          	jalr	-176(ra) # 80003336 <fetchstr>
    800033ee:	70a2                	ld	ra,40(sp)
    800033f0:	7402                	ld	s0,32(sp)
    800033f2:	64e2                	ld	s1,24(sp)
    800033f4:	6942                	ld	s2,16(sp)
    800033f6:	6145                	addi	sp,sp,48
    800033f8:	8082                	ret

00000000800033fa <syscall>:
    800033fa:	1101                	addi	sp,sp,-32
    800033fc:	ec06                	sd	ra,24(sp)
    800033fe:	e822                	sd	s0,16(sp)
    80003400:	e426                	sd	s1,8(sp)
    80003402:	e04a                	sd	s2,0(sp)
    80003404:	1000                	addi	s0,sp,32
    80003406:	ffffe097          	auipc	ra,0xffffe
    8000340a:	5a6080e7          	jalr	1446(ra) # 800019ac <myproc>
    8000340e:	84aa                	mv	s1,a0
    80003410:	09853903          	ld	s2,152(a0)
    80003414:	0a893783          	ld	a5,168(s2)
    80003418:	0007869b          	sext.w	a3,a5
    8000341c:	37fd                	addiw	a5,a5,-1
    8000341e:	4761                	li	a4,24
    80003420:	00f76f63          	bltu	a4,a5,8000343e <syscall+0x44>
    80003424:	00369713          	slli	a4,a3,0x3
    80003428:	00005797          	auipc	a5,0x5
    8000342c:	03878793          	addi	a5,a5,56 # 80008460 <syscalls>
    80003430:	97ba                	add	a5,a5,a4
    80003432:	639c                	ld	a5,0(a5)
    80003434:	c789                	beqz	a5,8000343e <syscall+0x44>
    80003436:	9782                	jalr	a5
    80003438:	06a93823          	sd	a0,112(s2)
    8000343c:	a839                	j	8000345a <syscall+0x60>
    8000343e:	19848613          	addi	a2,s1,408
    80003442:	588c                	lw	a1,48(s1)
    80003444:	00005517          	auipc	a0,0x5
    80003448:	fe450513          	addi	a0,a0,-28 # 80008428 <states.0+0x160>
    8000344c:	ffffd097          	auipc	ra,0xffffd
    80003450:	13c080e7          	jalr	316(ra) # 80000588 <printf>
    80003454:	6cdc                	ld	a5,152(s1)
    80003456:	577d                	li	a4,-1
    80003458:	fbb8                	sd	a4,112(a5)
    8000345a:	60e2                	ld	ra,24(sp)
    8000345c:	6442                	ld	s0,16(sp)
    8000345e:	64a2                	ld	s1,8(sp)
    80003460:	6902                	ld	s2,0(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <sys_exit>:
    80003466:	1101                	addi	sp,sp,-32
    80003468:	ec06                	sd	ra,24(sp)
    8000346a:	e822                	sd	s0,16(sp)
    8000346c:	1000                	addi	s0,sp,32
    8000346e:	fec40593          	addi	a1,s0,-20
    80003472:	4501                	li	a0,0
    80003474:	00000097          	auipc	ra,0x0
    80003478:	f0e080e7          	jalr	-242(ra) # 80003382 <argint>
    8000347c:	fec42503          	lw	a0,-20(s0)
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	dd2080e7          	jalr	-558(ra) # 80002252 <exit>
    80003488:	4501                	li	a0,0
    8000348a:	60e2                	ld	ra,24(sp)
    8000348c:	6442                	ld	s0,16(sp)
    8000348e:	6105                	addi	sp,sp,32
    80003490:	8082                	ret

0000000080003492 <sys_getpid>:
    80003492:	1141                	addi	sp,sp,-16
    80003494:	e406                	sd	ra,8(sp)
    80003496:	e022                	sd	s0,0(sp)
    80003498:	0800                	addi	s0,sp,16
    8000349a:	ffffe097          	auipc	ra,0xffffe
    8000349e:	512080e7          	jalr	1298(ra) # 800019ac <myproc>
    800034a2:	5908                	lw	a0,48(a0)
    800034a4:	60a2                	ld	ra,8(sp)
    800034a6:	6402                	ld	s0,0(sp)
    800034a8:	0141                	addi	sp,sp,16
    800034aa:	8082                	ret

00000000800034ac <sys_fork>:
    800034ac:	1141                	addi	sp,sp,-16
    800034ae:	e406                	sd	ra,8(sp)
    800034b0:	e022                	sd	s0,0(sp)
    800034b2:	0800                	addi	s0,sp,16
    800034b4:	fffff097          	auipc	ra,0xfffff
    800034b8:	8e6080e7          	jalr	-1818(ra) # 80001d9a <fork>
    800034bc:	60a2                	ld	ra,8(sp)
    800034be:	6402                	ld	s0,0(sp)
    800034c0:	0141                	addi	sp,sp,16
    800034c2:	8082                	ret

00000000800034c4 <sys_wait>:
    800034c4:	1101                	addi	sp,sp,-32
    800034c6:	ec06                	sd	ra,24(sp)
    800034c8:	e822                	sd	s0,16(sp)
    800034ca:	1000                	addi	s0,sp,32
    800034cc:	fe840593          	addi	a1,s0,-24
    800034d0:	4501                	li	a0,0
    800034d2:	00000097          	auipc	ra,0x0
    800034d6:	ed0080e7          	jalr	-304(ra) # 800033a2 <argaddr>
    800034da:	fe843503          	ld	a0,-24(s0)
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	f26080e7          	jalr	-218(ra) # 80002404 <wait>
    800034e6:	60e2                	ld	ra,24(sp)
    800034e8:	6442                	ld	s0,16(sp)
    800034ea:	6105                	addi	sp,sp,32
    800034ec:	8082                	ret

00000000800034ee <sys_sbrk>:
    800034ee:	7179                	addi	sp,sp,-48
    800034f0:	f406                	sd	ra,40(sp)
    800034f2:	f022                	sd	s0,32(sp)
    800034f4:	ec26                	sd	s1,24(sp)
    800034f6:	1800                	addi	s0,sp,48
    800034f8:	fdc40593          	addi	a1,s0,-36
    800034fc:	4501                	li	a0,0
    800034fe:	00000097          	auipc	ra,0x0
    80003502:	e84080e7          	jalr	-380(ra) # 80003382 <argint>
    80003506:	ffffe097          	auipc	ra,0xffffe
    8000350a:	4a6080e7          	jalr	1190(ra) # 800019ac <myproc>
    8000350e:	6544                	ld	s1,136(a0)
    80003510:	fdc42503          	lw	a0,-36(s0)
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	82a080e7          	jalr	-2006(ra) # 80001d3e <growproc>
    8000351c:	00054863          	bltz	a0,8000352c <sys_sbrk+0x3e>
    80003520:	8526                	mv	a0,s1
    80003522:	70a2                	ld	ra,40(sp)
    80003524:	7402                	ld	s0,32(sp)
    80003526:	64e2                	ld	s1,24(sp)
    80003528:	6145                	addi	sp,sp,48
    8000352a:	8082                	ret
    8000352c:	54fd                	li	s1,-1
    8000352e:	bfcd                	j	80003520 <sys_sbrk+0x32>

0000000080003530 <sys_sleep>:
    80003530:	7139                	addi	sp,sp,-64
    80003532:	fc06                	sd	ra,56(sp)
    80003534:	f822                	sd	s0,48(sp)
    80003536:	f426                	sd	s1,40(sp)
    80003538:	f04a                	sd	s2,32(sp)
    8000353a:	ec4e                	sd	s3,24(sp)
    8000353c:	0080                	addi	s0,sp,64
    8000353e:	fcc40593          	addi	a1,s0,-52
    80003542:	4501                	li	a0,0
    80003544:	00000097          	auipc	ra,0x0
    80003548:	e3e080e7          	jalr	-450(ra) # 80003382 <argint>
    8000354c:	00015517          	auipc	a0,0x15
    80003550:	84450513          	addi	a0,a0,-1980 # 80017d90 <tickslock>
    80003554:	ffffd097          	auipc	ra,0xffffd
    80003558:	682080e7          	jalr	1666(ra) # 80000bd6 <acquire>
    8000355c:	00005917          	auipc	s2,0x5
    80003560:	39492903          	lw	s2,916(s2) # 800088f0 <ticks>
    80003564:	fcc42783          	lw	a5,-52(s0)
    80003568:	cf9d                	beqz	a5,800035a6 <sys_sleep+0x76>
    8000356a:	00015997          	auipc	s3,0x15
    8000356e:	82698993          	addi	s3,s3,-2010 # 80017d90 <tickslock>
    80003572:	00005497          	auipc	s1,0x5
    80003576:	37e48493          	addi	s1,s1,894 # 800088f0 <ticks>
    8000357a:	ffffe097          	auipc	ra,0xffffe
    8000357e:	432080e7          	jalr	1074(ra) # 800019ac <myproc>
    80003582:	fffff097          	auipc	ra,0xfffff
    80003586:	e50080e7          	jalr	-432(ra) # 800023d2 <killed>
    8000358a:	ed15                	bnez	a0,800035c6 <sys_sleep+0x96>
    8000358c:	85ce                	mv	a1,s3
    8000358e:	8526                	mv	a0,s1
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	b8e080e7          	jalr	-1138(ra) # 8000211e <sleep>
    80003598:	409c                	lw	a5,0(s1)
    8000359a:	412787bb          	subw	a5,a5,s2
    8000359e:	fcc42703          	lw	a4,-52(s0)
    800035a2:	fce7ece3          	bltu	a5,a4,8000357a <sys_sleep+0x4a>
    800035a6:	00014517          	auipc	a0,0x14
    800035aa:	7ea50513          	addi	a0,a0,2026 # 80017d90 <tickslock>
    800035ae:	ffffd097          	auipc	ra,0xffffd
    800035b2:	6dc080e7          	jalr	1756(ra) # 80000c8a <release>
    800035b6:	4501                	li	a0,0
    800035b8:	70e2                	ld	ra,56(sp)
    800035ba:	7442                	ld	s0,48(sp)
    800035bc:	74a2                	ld	s1,40(sp)
    800035be:	7902                	ld	s2,32(sp)
    800035c0:	69e2                	ld	s3,24(sp)
    800035c2:	6121                	addi	sp,sp,64
    800035c4:	8082                	ret
    800035c6:	00014517          	auipc	a0,0x14
    800035ca:	7ca50513          	addi	a0,a0,1994 # 80017d90 <tickslock>
    800035ce:	ffffd097          	auipc	ra,0xffffd
    800035d2:	6bc080e7          	jalr	1724(ra) # 80000c8a <release>
    800035d6:	557d                	li	a0,-1
    800035d8:	b7c5                	j	800035b8 <sys_sleep+0x88>

00000000800035da <sys_kill>:
    800035da:	1101                	addi	sp,sp,-32
    800035dc:	ec06                	sd	ra,24(sp)
    800035de:	e822                	sd	s0,16(sp)
    800035e0:	1000                	addi	s0,sp,32
    800035e2:	fec40593          	addi	a1,s0,-20
    800035e6:	4501                	li	a0,0
    800035e8:	00000097          	auipc	ra,0x0
    800035ec:	d9a080e7          	jalr	-614(ra) # 80003382 <argint>
    800035f0:	fec42503          	lw	a0,-20(s0)
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	d40080e7          	jalr	-704(ra) # 80002334 <kill>
    800035fc:	60e2                	ld	ra,24(sp)
    800035fe:	6442                	ld	s0,16(sp)
    80003600:	6105                	addi	sp,sp,32
    80003602:	8082                	ret

0000000080003604 <sys_uptime>:
    80003604:	1101                	addi	sp,sp,-32
    80003606:	ec06                	sd	ra,24(sp)
    80003608:	e822                	sd	s0,16(sp)
    8000360a:	e426                	sd	s1,8(sp)
    8000360c:	1000                	addi	s0,sp,32
    8000360e:	00014517          	auipc	a0,0x14
    80003612:	78250513          	addi	a0,a0,1922 # 80017d90 <tickslock>
    80003616:	ffffd097          	auipc	ra,0xffffd
    8000361a:	5c0080e7          	jalr	1472(ra) # 80000bd6 <acquire>
    8000361e:	00005497          	auipc	s1,0x5
    80003622:	2d24a483          	lw	s1,722(s1) # 800088f0 <ticks>
    80003626:	00014517          	auipc	a0,0x14
    8000362a:	76a50513          	addi	a0,a0,1898 # 80017d90 <tickslock>
    8000362e:	ffffd097          	auipc	ra,0xffffd
    80003632:	65c080e7          	jalr	1628(ra) # 80000c8a <release>
    80003636:	02049513          	slli	a0,s1,0x20
    8000363a:	9101                	srli	a0,a0,0x20
    8000363c:	60e2                	ld	ra,24(sp)
    8000363e:	6442                	ld	s0,16(sp)
    80003640:	64a2                	ld	s1,8(sp)
    80003642:	6105                	addi	sp,sp,32
    80003644:	8082                	ret

0000000080003646 <sys_waitx>:
    80003646:	7139                	addi	sp,sp,-64
    80003648:	fc06                	sd	ra,56(sp)
    8000364a:	f822                	sd	s0,48(sp)
    8000364c:	f426                	sd	s1,40(sp)
    8000364e:	f04a                	sd	s2,32(sp)
    80003650:	0080                	addi	s0,sp,64
    80003652:	fd840593          	addi	a1,s0,-40
    80003656:	4501                	li	a0,0
    80003658:	00000097          	auipc	ra,0x0
    8000365c:	d4a080e7          	jalr	-694(ra) # 800033a2 <argaddr>
    80003660:	fd040593          	addi	a1,s0,-48
    80003664:	4505                	li	a0,1
    80003666:	00000097          	auipc	ra,0x0
    8000366a:	d3c080e7          	jalr	-708(ra) # 800033a2 <argaddr>
    8000366e:	fc840593          	addi	a1,s0,-56
    80003672:	4509                	li	a0,2
    80003674:	00000097          	auipc	ra,0x0
    80003678:	d2e080e7          	jalr	-722(ra) # 800033a2 <argaddr>
    8000367c:	fc040613          	addi	a2,s0,-64
    80003680:	fc440593          	addi	a1,s0,-60
    80003684:	fd843503          	ld	a0,-40(s0)
    80003688:	fffff097          	auipc	ra,0xfffff
    8000368c:	026080e7          	jalr	38(ra) # 800026ae <waitx>
    80003690:	892a                	mv	s2,a0
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	31a080e7          	jalr	794(ra) # 800019ac <myproc>
    8000369a:	84aa                	mv	s1,a0
    8000369c:	4691                	li	a3,4
    8000369e:	fc440613          	addi	a2,s0,-60
    800036a2:	fd043583          	ld	a1,-48(s0)
    800036a6:	6948                	ld	a0,144(a0)
    800036a8:	ffffe097          	auipc	ra,0xffffe
    800036ac:	fc0080e7          	jalr	-64(ra) # 80001668 <copyout>
    800036b0:	57fd                	li	a5,-1
    800036b2:	00054f63          	bltz	a0,800036d0 <sys_waitx+0x8a>
    800036b6:	4691                	li	a3,4
    800036b8:	fc040613          	addi	a2,s0,-64
    800036bc:	fc843583          	ld	a1,-56(s0)
    800036c0:	68c8                	ld	a0,144(s1)
    800036c2:	ffffe097          	auipc	ra,0xffffe
    800036c6:	fa6080e7          	jalr	-90(ra) # 80001668 <copyout>
    800036ca:	00054a63          	bltz	a0,800036de <sys_waitx+0x98>
    800036ce:	87ca                	mv	a5,s2
    800036d0:	853e                	mv	a0,a5
    800036d2:	70e2                	ld	ra,56(sp)
    800036d4:	7442                	ld	s0,48(sp)
    800036d6:	74a2                	ld	s1,40(sp)
    800036d8:	7902                	ld	s2,32(sp)
    800036da:	6121                	addi	sp,sp,64
    800036dc:	8082                	ret
    800036de:	57fd                	li	a5,-1
    800036e0:	bfc5                	j	800036d0 <sys_waitx+0x8a>

00000000800036e2 <binit>:
    800036e2:	7179                	addi	sp,sp,-48
    800036e4:	f406                	sd	ra,40(sp)
    800036e6:	f022                	sd	s0,32(sp)
    800036e8:	ec26                	sd	s1,24(sp)
    800036ea:	e84a                	sd	s2,16(sp)
    800036ec:	e44e                	sd	s3,8(sp)
    800036ee:	e052                	sd	s4,0(sp)
    800036f0:	1800                	addi	s0,sp,48
    800036f2:	00005597          	auipc	a1,0x5
    800036f6:	e3e58593          	addi	a1,a1,-450 # 80008530 <syscalls+0xd0>
    800036fa:	00014517          	auipc	a0,0x14
    800036fe:	6ae50513          	addi	a0,a0,1710 # 80017da8 <bcache>
    80003702:	ffffd097          	auipc	ra,0xffffd
    80003706:	444080e7          	jalr	1092(ra) # 80000b46 <initlock>
    8000370a:	0001c797          	auipc	a5,0x1c
    8000370e:	69e78793          	addi	a5,a5,1694 # 8001fda8 <bcache+0x8000>
    80003712:	0001d717          	auipc	a4,0x1d
    80003716:	8fe70713          	addi	a4,a4,-1794 # 80020010 <bcache+0x8268>
    8000371a:	2ae7b823          	sd	a4,688(a5)
    8000371e:	2ae7bc23          	sd	a4,696(a5)
    80003722:	00014497          	auipc	s1,0x14
    80003726:	69e48493          	addi	s1,s1,1694 # 80017dc0 <bcache+0x18>
    8000372a:	893e                	mv	s2,a5
    8000372c:	89ba                	mv	s3,a4
    8000372e:	00005a17          	auipc	s4,0x5
    80003732:	e0aa0a13          	addi	s4,s4,-502 # 80008538 <syscalls+0xd8>
    80003736:	2b893783          	ld	a5,696(s2)
    8000373a:	e8bc                	sd	a5,80(s1)
    8000373c:	0534b423          	sd	s3,72(s1)
    80003740:	85d2                	mv	a1,s4
    80003742:	01048513          	addi	a0,s1,16
    80003746:	00001097          	auipc	ra,0x1
    8000374a:	4c4080e7          	jalr	1220(ra) # 80004c0a <initsleeplock>
    8000374e:	2b893783          	ld	a5,696(s2)
    80003752:	e7a4                	sd	s1,72(a5)
    80003754:	2a993c23          	sd	s1,696(s2)
    80003758:	45848493          	addi	s1,s1,1112
    8000375c:	fd349de3          	bne	s1,s3,80003736 <binit+0x54>
    80003760:	70a2                	ld	ra,40(sp)
    80003762:	7402                	ld	s0,32(sp)
    80003764:	64e2                	ld	s1,24(sp)
    80003766:	6942                	ld	s2,16(sp)
    80003768:	69a2                	ld	s3,8(sp)
    8000376a:	6a02                	ld	s4,0(sp)
    8000376c:	6145                	addi	sp,sp,48
    8000376e:	8082                	ret

0000000080003770 <bread>:
    80003770:	7179                	addi	sp,sp,-48
    80003772:	f406                	sd	ra,40(sp)
    80003774:	f022                	sd	s0,32(sp)
    80003776:	ec26                	sd	s1,24(sp)
    80003778:	e84a                	sd	s2,16(sp)
    8000377a:	e44e                	sd	s3,8(sp)
    8000377c:	1800                	addi	s0,sp,48
    8000377e:	892a                	mv	s2,a0
    80003780:	89ae                	mv	s3,a1
    80003782:	00014517          	auipc	a0,0x14
    80003786:	62650513          	addi	a0,a0,1574 # 80017da8 <bcache>
    8000378a:	ffffd097          	auipc	ra,0xffffd
    8000378e:	44c080e7          	jalr	1100(ra) # 80000bd6 <acquire>
    80003792:	0001d497          	auipc	s1,0x1d
    80003796:	8ce4b483          	ld	s1,-1842(s1) # 80020060 <bcache+0x82b8>
    8000379a:	0001d797          	auipc	a5,0x1d
    8000379e:	87678793          	addi	a5,a5,-1930 # 80020010 <bcache+0x8268>
    800037a2:	02f48f63          	beq	s1,a5,800037e0 <bread+0x70>
    800037a6:	873e                	mv	a4,a5
    800037a8:	a021                	j	800037b0 <bread+0x40>
    800037aa:	68a4                	ld	s1,80(s1)
    800037ac:	02e48a63          	beq	s1,a4,800037e0 <bread+0x70>
    800037b0:	449c                	lw	a5,8(s1)
    800037b2:	ff279ce3          	bne	a5,s2,800037aa <bread+0x3a>
    800037b6:	44dc                	lw	a5,12(s1)
    800037b8:	ff3799e3          	bne	a5,s3,800037aa <bread+0x3a>
    800037bc:	40bc                	lw	a5,64(s1)
    800037be:	2785                	addiw	a5,a5,1
    800037c0:	c0bc                	sw	a5,64(s1)
    800037c2:	00014517          	auipc	a0,0x14
    800037c6:	5e650513          	addi	a0,a0,1510 # 80017da8 <bcache>
    800037ca:	ffffd097          	auipc	ra,0xffffd
    800037ce:	4c0080e7          	jalr	1216(ra) # 80000c8a <release>
    800037d2:	01048513          	addi	a0,s1,16
    800037d6:	00001097          	auipc	ra,0x1
    800037da:	46e080e7          	jalr	1134(ra) # 80004c44 <acquiresleep>
    800037de:	a8b9                	j	8000383c <bread+0xcc>
    800037e0:	0001d497          	auipc	s1,0x1d
    800037e4:	8784b483          	ld	s1,-1928(s1) # 80020058 <bcache+0x82b0>
    800037e8:	0001d797          	auipc	a5,0x1d
    800037ec:	82878793          	addi	a5,a5,-2008 # 80020010 <bcache+0x8268>
    800037f0:	00f48863          	beq	s1,a5,80003800 <bread+0x90>
    800037f4:	873e                	mv	a4,a5
    800037f6:	40bc                	lw	a5,64(s1)
    800037f8:	cf81                	beqz	a5,80003810 <bread+0xa0>
    800037fa:	64a4                	ld	s1,72(s1)
    800037fc:	fee49de3          	bne	s1,a4,800037f6 <bread+0x86>
    80003800:	00005517          	auipc	a0,0x5
    80003804:	d4050513          	addi	a0,a0,-704 # 80008540 <syscalls+0xe0>
    80003808:	ffffd097          	auipc	ra,0xffffd
    8000380c:	d36080e7          	jalr	-714(ra) # 8000053e <panic>
    80003810:	0124a423          	sw	s2,8(s1)
    80003814:	0134a623          	sw	s3,12(s1)
    80003818:	0004a023          	sw	zero,0(s1)
    8000381c:	4785                	li	a5,1
    8000381e:	c0bc                	sw	a5,64(s1)
    80003820:	00014517          	auipc	a0,0x14
    80003824:	58850513          	addi	a0,a0,1416 # 80017da8 <bcache>
    80003828:	ffffd097          	auipc	ra,0xffffd
    8000382c:	462080e7          	jalr	1122(ra) # 80000c8a <release>
    80003830:	01048513          	addi	a0,s1,16
    80003834:	00001097          	auipc	ra,0x1
    80003838:	410080e7          	jalr	1040(ra) # 80004c44 <acquiresleep>
    8000383c:	409c                	lw	a5,0(s1)
    8000383e:	cb89                	beqz	a5,80003850 <bread+0xe0>
    80003840:	8526                	mv	a0,s1
    80003842:	70a2                	ld	ra,40(sp)
    80003844:	7402                	ld	s0,32(sp)
    80003846:	64e2                	ld	s1,24(sp)
    80003848:	6942                	ld	s2,16(sp)
    8000384a:	69a2                	ld	s3,8(sp)
    8000384c:	6145                	addi	sp,sp,48
    8000384e:	8082                	ret
    80003850:	4581                	li	a1,0
    80003852:	8526                	mv	a0,s1
    80003854:	00003097          	auipc	ra,0x3
    80003858:	080080e7          	jalr	128(ra) # 800068d4 <virtio_disk_rw>
    8000385c:	4785                	li	a5,1
    8000385e:	c09c                	sw	a5,0(s1)
    80003860:	b7c5                	j	80003840 <bread+0xd0>

0000000080003862 <bwrite>:
    80003862:	1101                	addi	sp,sp,-32
    80003864:	ec06                	sd	ra,24(sp)
    80003866:	e822                	sd	s0,16(sp)
    80003868:	e426                	sd	s1,8(sp)
    8000386a:	1000                	addi	s0,sp,32
    8000386c:	84aa                	mv	s1,a0
    8000386e:	0541                	addi	a0,a0,16
    80003870:	00001097          	auipc	ra,0x1
    80003874:	46e080e7          	jalr	1134(ra) # 80004cde <holdingsleep>
    80003878:	cd01                	beqz	a0,80003890 <bwrite+0x2e>
    8000387a:	4585                	li	a1,1
    8000387c:	8526                	mv	a0,s1
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	056080e7          	jalr	86(ra) # 800068d4 <virtio_disk_rw>
    80003886:	60e2                	ld	ra,24(sp)
    80003888:	6442                	ld	s0,16(sp)
    8000388a:	64a2                	ld	s1,8(sp)
    8000388c:	6105                	addi	sp,sp,32
    8000388e:	8082                	ret
    80003890:	00005517          	auipc	a0,0x5
    80003894:	cc850513          	addi	a0,a0,-824 # 80008558 <syscalls+0xf8>
    80003898:	ffffd097          	auipc	ra,0xffffd
    8000389c:	ca6080e7          	jalr	-858(ra) # 8000053e <panic>

00000000800038a0 <brelse>:
    800038a0:	1101                	addi	sp,sp,-32
    800038a2:	ec06                	sd	ra,24(sp)
    800038a4:	e822                	sd	s0,16(sp)
    800038a6:	e426                	sd	s1,8(sp)
    800038a8:	e04a                	sd	s2,0(sp)
    800038aa:	1000                	addi	s0,sp,32
    800038ac:	84aa                	mv	s1,a0
    800038ae:	01050913          	addi	s2,a0,16
    800038b2:	854a                	mv	a0,s2
    800038b4:	00001097          	auipc	ra,0x1
    800038b8:	42a080e7          	jalr	1066(ra) # 80004cde <holdingsleep>
    800038bc:	c92d                	beqz	a0,8000392e <brelse+0x8e>
    800038be:	854a                	mv	a0,s2
    800038c0:	00001097          	auipc	ra,0x1
    800038c4:	3da080e7          	jalr	986(ra) # 80004c9a <releasesleep>
    800038c8:	00014517          	auipc	a0,0x14
    800038cc:	4e050513          	addi	a0,a0,1248 # 80017da8 <bcache>
    800038d0:	ffffd097          	auipc	ra,0xffffd
    800038d4:	306080e7          	jalr	774(ra) # 80000bd6 <acquire>
    800038d8:	40bc                	lw	a5,64(s1)
    800038da:	37fd                	addiw	a5,a5,-1
    800038dc:	0007871b          	sext.w	a4,a5
    800038e0:	c0bc                	sw	a5,64(s1)
    800038e2:	eb05                	bnez	a4,80003912 <brelse+0x72>
    800038e4:	68bc                	ld	a5,80(s1)
    800038e6:	64b8                	ld	a4,72(s1)
    800038e8:	e7b8                	sd	a4,72(a5)
    800038ea:	64bc                	ld	a5,72(s1)
    800038ec:	68b8                	ld	a4,80(s1)
    800038ee:	ebb8                	sd	a4,80(a5)
    800038f0:	0001c797          	auipc	a5,0x1c
    800038f4:	4b878793          	addi	a5,a5,1208 # 8001fda8 <bcache+0x8000>
    800038f8:	2b87b703          	ld	a4,696(a5)
    800038fc:	e8b8                	sd	a4,80(s1)
    800038fe:	0001c717          	auipc	a4,0x1c
    80003902:	71270713          	addi	a4,a4,1810 # 80020010 <bcache+0x8268>
    80003906:	e4b8                	sd	a4,72(s1)
    80003908:	2b87b703          	ld	a4,696(a5)
    8000390c:	e724                	sd	s1,72(a4)
    8000390e:	2a97bc23          	sd	s1,696(a5)
    80003912:	00014517          	auipc	a0,0x14
    80003916:	49650513          	addi	a0,a0,1174 # 80017da8 <bcache>
    8000391a:	ffffd097          	auipc	ra,0xffffd
    8000391e:	370080e7          	jalr	880(ra) # 80000c8a <release>
    80003922:	60e2                	ld	ra,24(sp)
    80003924:	6442                	ld	s0,16(sp)
    80003926:	64a2                	ld	s1,8(sp)
    80003928:	6902                	ld	s2,0(sp)
    8000392a:	6105                	addi	sp,sp,32
    8000392c:	8082                	ret
    8000392e:	00005517          	auipc	a0,0x5
    80003932:	c3250513          	addi	a0,a0,-974 # 80008560 <syscalls+0x100>
    80003936:	ffffd097          	auipc	ra,0xffffd
    8000393a:	c08080e7          	jalr	-1016(ra) # 8000053e <panic>

000000008000393e <bpin>:
    8000393e:	1101                	addi	sp,sp,-32
    80003940:	ec06                	sd	ra,24(sp)
    80003942:	e822                	sd	s0,16(sp)
    80003944:	e426                	sd	s1,8(sp)
    80003946:	1000                	addi	s0,sp,32
    80003948:	84aa                	mv	s1,a0
    8000394a:	00014517          	auipc	a0,0x14
    8000394e:	45e50513          	addi	a0,a0,1118 # 80017da8 <bcache>
    80003952:	ffffd097          	auipc	ra,0xffffd
    80003956:	284080e7          	jalr	644(ra) # 80000bd6 <acquire>
    8000395a:	40bc                	lw	a5,64(s1)
    8000395c:	2785                	addiw	a5,a5,1
    8000395e:	c0bc                	sw	a5,64(s1)
    80003960:	00014517          	auipc	a0,0x14
    80003964:	44850513          	addi	a0,a0,1096 # 80017da8 <bcache>
    80003968:	ffffd097          	auipc	ra,0xffffd
    8000396c:	322080e7          	jalr	802(ra) # 80000c8a <release>
    80003970:	60e2                	ld	ra,24(sp)
    80003972:	6442                	ld	s0,16(sp)
    80003974:	64a2                	ld	s1,8(sp)
    80003976:	6105                	addi	sp,sp,32
    80003978:	8082                	ret

000000008000397a <bunpin>:
    8000397a:	1101                	addi	sp,sp,-32
    8000397c:	ec06                	sd	ra,24(sp)
    8000397e:	e822                	sd	s0,16(sp)
    80003980:	e426                	sd	s1,8(sp)
    80003982:	1000                	addi	s0,sp,32
    80003984:	84aa                	mv	s1,a0
    80003986:	00014517          	auipc	a0,0x14
    8000398a:	42250513          	addi	a0,a0,1058 # 80017da8 <bcache>
    8000398e:	ffffd097          	auipc	ra,0xffffd
    80003992:	248080e7          	jalr	584(ra) # 80000bd6 <acquire>
    80003996:	40bc                	lw	a5,64(s1)
    80003998:	37fd                	addiw	a5,a5,-1
    8000399a:	c0bc                	sw	a5,64(s1)
    8000399c:	00014517          	auipc	a0,0x14
    800039a0:	40c50513          	addi	a0,a0,1036 # 80017da8 <bcache>
    800039a4:	ffffd097          	auipc	ra,0xffffd
    800039a8:	2e6080e7          	jalr	742(ra) # 80000c8a <release>
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	64a2                	ld	s1,8(sp)
    800039b2:	6105                	addi	sp,sp,32
    800039b4:	8082                	ret

00000000800039b6 <bfree>:
    800039b6:	1101                	addi	sp,sp,-32
    800039b8:	ec06                	sd	ra,24(sp)
    800039ba:	e822                	sd	s0,16(sp)
    800039bc:	e426                	sd	s1,8(sp)
    800039be:	e04a                	sd	s2,0(sp)
    800039c0:	1000                	addi	s0,sp,32
    800039c2:	84ae                	mv	s1,a1
    800039c4:	00d5d59b          	srliw	a1,a1,0xd
    800039c8:	0001d797          	auipc	a5,0x1d
    800039cc:	abc7a783          	lw	a5,-1348(a5) # 80020484 <sb+0x1c>
    800039d0:	9dbd                	addw	a1,a1,a5
    800039d2:	00000097          	auipc	ra,0x0
    800039d6:	d9e080e7          	jalr	-610(ra) # 80003770 <bread>
    800039da:	0074f713          	andi	a4,s1,7
    800039de:	4785                	li	a5,1
    800039e0:	00e797bb          	sllw	a5,a5,a4
    800039e4:	14ce                	slli	s1,s1,0x33
    800039e6:	90d9                	srli	s1,s1,0x36
    800039e8:	00950733          	add	a4,a0,s1
    800039ec:	05874703          	lbu	a4,88(a4)
    800039f0:	00e7f6b3          	and	a3,a5,a4
    800039f4:	c69d                	beqz	a3,80003a22 <bfree+0x6c>
    800039f6:	892a                	mv	s2,a0
    800039f8:	94aa                	add	s1,s1,a0
    800039fa:	fff7c793          	not	a5,a5
    800039fe:	8ff9                	and	a5,a5,a4
    80003a00:	04f48c23          	sb	a5,88(s1)
    80003a04:	00001097          	auipc	ra,0x1
    80003a08:	120080e7          	jalr	288(ra) # 80004b24 <log_write>
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	00000097          	auipc	ra,0x0
    80003a12:	e92080e7          	jalr	-366(ra) # 800038a0 <brelse>
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6902                	ld	s2,0(sp)
    80003a1e:	6105                	addi	sp,sp,32
    80003a20:	8082                	ret
    80003a22:	00005517          	auipc	a0,0x5
    80003a26:	b4650513          	addi	a0,a0,-1210 # 80008568 <syscalls+0x108>
    80003a2a:	ffffd097          	auipc	ra,0xffffd
    80003a2e:	b14080e7          	jalr	-1260(ra) # 8000053e <panic>

0000000080003a32 <balloc>:
    80003a32:	711d                	addi	sp,sp,-96
    80003a34:	ec86                	sd	ra,88(sp)
    80003a36:	e8a2                	sd	s0,80(sp)
    80003a38:	e4a6                	sd	s1,72(sp)
    80003a3a:	e0ca                	sd	s2,64(sp)
    80003a3c:	fc4e                	sd	s3,56(sp)
    80003a3e:	f852                	sd	s4,48(sp)
    80003a40:	f456                	sd	s5,40(sp)
    80003a42:	f05a                	sd	s6,32(sp)
    80003a44:	ec5e                	sd	s7,24(sp)
    80003a46:	e862                	sd	s8,16(sp)
    80003a48:	e466                	sd	s9,8(sp)
    80003a4a:	1080                	addi	s0,sp,96
    80003a4c:	0001d797          	auipc	a5,0x1d
    80003a50:	a207a783          	lw	a5,-1504(a5) # 8002046c <sb+0x4>
    80003a54:	10078163          	beqz	a5,80003b56 <balloc+0x124>
    80003a58:	8baa                	mv	s7,a0
    80003a5a:	4a81                	li	s5,0
    80003a5c:	0001db17          	auipc	s6,0x1d
    80003a60:	a0cb0b13          	addi	s6,s6,-1524 # 80020468 <sb>
    80003a64:	4c01                	li	s8,0
    80003a66:	4985                	li	s3,1
    80003a68:	6a09                	lui	s4,0x2
    80003a6a:	6c89                	lui	s9,0x2
    80003a6c:	a061                	j	80003af4 <balloc+0xc2>
    80003a6e:	974a                	add	a4,a4,s2
    80003a70:	8fd5                	or	a5,a5,a3
    80003a72:	04f70c23          	sb	a5,88(a4)
    80003a76:	854a                	mv	a0,s2
    80003a78:	00001097          	auipc	ra,0x1
    80003a7c:	0ac080e7          	jalr	172(ra) # 80004b24 <log_write>
    80003a80:	854a                	mv	a0,s2
    80003a82:	00000097          	auipc	ra,0x0
    80003a86:	e1e080e7          	jalr	-482(ra) # 800038a0 <brelse>
    80003a8a:	85a6                	mv	a1,s1
    80003a8c:	855e                	mv	a0,s7
    80003a8e:	00000097          	auipc	ra,0x0
    80003a92:	ce2080e7          	jalr	-798(ra) # 80003770 <bread>
    80003a96:	892a                	mv	s2,a0
    80003a98:	40000613          	li	a2,1024
    80003a9c:	4581                	li	a1,0
    80003a9e:	05850513          	addi	a0,a0,88
    80003aa2:	ffffd097          	auipc	ra,0xffffd
    80003aa6:	230080e7          	jalr	560(ra) # 80000cd2 <memset>
    80003aaa:	854a                	mv	a0,s2
    80003aac:	00001097          	auipc	ra,0x1
    80003ab0:	078080e7          	jalr	120(ra) # 80004b24 <log_write>
    80003ab4:	854a                	mv	a0,s2
    80003ab6:	00000097          	auipc	ra,0x0
    80003aba:	dea080e7          	jalr	-534(ra) # 800038a0 <brelse>
    80003abe:	8526                	mv	a0,s1
    80003ac0:	60e6                	ld	ra,88(sp)
    80003ac2:	6446                	ld	s0,80(sp)
    80003ac4:	64a6                	ld	s1,72(sp)
    80003ac6:	6906                	ld	s2,64(sp)
    80003ac8:	79e2                	ld	s3,56(sp)
    80003aca:	7a42                	ld	s4,48(sp)
    80003acc:	7aa2                	ld	s5,40(sp)
    80003ace:	7b02                	ld	s6,32(sp)
    80003ad0:	6be2                	ld	s7,24(sp)
    80003ad2:	6c42                	ld	s8,16(sp)
    80003ad4:	6ca2                	ld	s9,8(sp)
    80003ad6:	6125                	addi	sp,sp,96
    80003ad8:	8082                	ret
    80003ada:	854a                	mv	a0,s2
    80003adc:	00000097          	auipc	ra,0x0
    80003ae0:	dc4080e7          	jalr	-572(ra) # 800038a0 <brelse>
    80003ae4:	015c87bb          	addw	a5,s9,s5
    80003ae8:	00078a9b          	sext.w	s5,a5
    80003aec:	004b2703          	lw	a4,4(s6)
    80003af0:	06eaf363          	bgeu	s5,a4,80003b56 <balloc+0x124>
    80003af4:	41fad79b          	sraiw	a5,s5,0x1f
    80003af8:	0137d79b          	srliw	a5,a5,0x13
    80003afc:	015787bb          	addw	a5,a5,s5
    80003b00:	40d7d79b          	sraiw	a5,a5,0xd
    80003b04:	01cb2583          	lw	a1,28(s6)
    80003b08:	9dbd                	addw	a1,a1,a5
    80003b0a:	855e                	mv	a0,s7
    80003b0c:	00000097          	auipc	ra,0x0
    80003b10:	c64080e7          	jalr	-924(ra) # 80003770 <bread>
    80003b14:	892a                	mv	s2,a0
    80003b16:	004b2503          	lw	a0,4(s6)
    80003b1a:	000a849b          	sext.w	s1,s5
    80003b1e:	8662                	mv	a2,s8
    80003b20:	faa4fde3          	bgeu	s1,a0,80003ada <balloc+0xa8>
    80003b24:	41f6579b          	sraiw	a5,a2,0x1f
    80003b28:	01d7d69b          	srliw	a3,a5,0x1d
    80003b2c:	00c6873b          	addw	a4,a3,a2
    80003b30:	00777793          	andi	a5,a4,7
    80003b34:	9f95                	subw	a5,a5,a3
    80003b36:	00f997bb          	sllw	a5,s3,a5
    80003b3a:	4037571b          	sraiw	a4,a4,0x3
    80003b3e:	00e906b3          	add	a3,s2,a4
    80003b42:	0586c683          	lbu	a3,88(a3)
    80003b46:	00d7f5b3          	and	a1,a5,a3
    80003b4a:	d195                	beqz	a1,80003a6e <balloc+0x3c>
    80003b4c:	2605                	addiw	a2,a2,1
    80003b4e:	2485                	addiw	s1,s1,1
    80003b50:	fd4618e3          	bne	a2,s4,80003b20 <balloc+0xee>
    80003b54:	b759                	j	80003ada <balloc+0xa8>
    80003b56:	00005517          	auipc	a0,0x5
    80003b5a:	a2a50513          	addi	a0,a0,-1494 # 80008580 <syscalls+0x120>
    80003b5e:	ffffd097          	auipc	ra,0xffffd
    80003b62:	a2a080e7          	jalr	-1494(ra) # 80000588 <printf>
    80003b66:	4481                	li	s1,0
    80003b68:	bf99                	j	80003abe <balloc+0x8c>

0000000080003b6a <bmap>:
    80003b6a:	7179                	addi	sp,sp,-48
    80003b6c:	f406                	sd	ra,40(sp)
    80003b6e:	f022                	sd	s0,32(sp)
    80003b70:	ec26                	sd	s1,24(sp)
    80003b72:	e84a                	sd	s2,16(sp)
    80003b74:	e44e                	sd	s3,8(sp)
    80003b76:	e052                	sd	s4,0(sp)
    80003b78:	1800                	addi	s0,sp,48
    80003b7a:	89aa                	mv	s3,a0
    80003b7c:	47ad                	li	a5,11
    80003b7e:	02b7e763          	bltu	a5,a1,80003bac <bmap+0x42>
    80003b82:	02059493          	slli	s1,a1,0x20
    80003b86:	9081                	srli	s1,s1,0x20
    80003b88:	048a                	slli	s1,s1,0x2
    80003b8a:	94aa                	add	s1,s1,a0
    80003b8c:	0504a903          	lw	s2,80(s1)
    80003b90:	06091e63          	bnez	s2,80003c0c <bmap+0xa2>
    80003b94:	4108                	lw	a0,0(a0)
    80003b96:	00000097          	auipc	ra,0x0
    80003b9a:	e9c080e7          	jalr	-356(ra) # 80003a32 <balloc>
    80003b9e:	0005091b          	sext.w	s2,a0
    80003ba2:	06090563          	beqz	s2,80003c0c <bmap+0xa2>
    80003ba6:	0524a823          	sw	s2,80(s1)
    80003baa:	a08d                	j	80003c0c <bmap+0xa2>
    80003bac:	ff45849b          	addiw	s1,a1,-12
    80003bb0:	0004871b          	sext.w	a4,s1
    80003bb4:	0ff00793          	li	a5,255
    80003bb8:	08e7e563          	bltu	a5,a4,80003c42 <bmap+0xd8>
    80003bbc:	08052903          	lw	s2,128(a0)
    80003bc0:	00091d63          	bnez	s2,80003bda <bmap+0x70>
    80003bc4:	4108                	lw	a0,0(a0)
    80003bc6:	00000097          	auipc	ra,0x0
    80003bca:	e6c080e7          	jalr	-404(ra) # 80003a32 <balloc>
    80003bce:	0005091b          	sext.w	s2,a0
    80003bd2:	02090d63          	beqz	s2,80003c0c <bmap+0xa2>
    80003bd6:	0929a023          	sw	s2,128(s3)
    80003bda:	85ca                	mv	a1,s2
    80003bdc:	0009a503          	lw	a0,0(s3)
    80003be0:	00000097          	auipc	ra,0x0
    80003be4:	b90080e7          	jalr	-1136(ra) # 80003770 <bread>
    80003be8:	8a2a                	mv	s4,a0
    80003bea:	05850793          	addi	a5,a0,88
    80003bee:	02049593          	slli	a1,s1,0x20
    80003bf2:	9181                	srli	a1,a1,0x20
    80003bf4:	058a                	slli	a1,a1,0x2
    80003bf6:	00b784b3          	add	s1,a5,a1
    80003bfa:	0004a903          	lw	s2,0(s1)
    80003bfe:	02090063          	beqz	s2,80003c1e <bmap+0xb4>
    80003c02:	8552                	mv	a0,s4
    80003c04:	00000097          	auipc	ra,0x0
    80003c08:	c9c080e7          	jalr	-868(ra) # 800038a0 <brelse>
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	70a2                	ld	ra,40(sp)
    80003c10:	7402                	ld	s0,32(sp)
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	6942                	ld	s2,16(sp)
    80003c16:	69a2                	ld	s3,8(sp)
    80003c18:	6a02                	ld	s4,0(sp)
    80003c1a:	6145                	addi	sp,sp,48
    80003c1c:	8082                	ret
    80003c1e:	0009a503          	lw	a0,0(s3)
    80003c22:	00000097          	auipc	ra,0x0
    80003c26:	e10080e7          	jalr	-496(ra) # 80003a32 <balloc>
    80003c2a:	0005091b          	sext.w	s2,a0
    80003c2e:	fc090ae3          	beqz	s2,80003c02 <bmap+0x98>
    80003c32:	0124a023          	sw	s2,0(s1)
    80003c36:	8552                	mv	a0,s4
    80003c38:	00001097          	auipc	ra,0x1
    80003c3c:	eec080e7          	jalr	-276(ra) # 80004b24 <log_write>
    80003c40:	b7c9                	j	80003c02 <bmap+0x98>
    80003c42:	00005517          	auipc	a0,0x5
    80003c46:	95650513          	addi	a0,a0,-1706 # 80008598 <syscalls+0x138>
    80003c4a:	ffffd097          	auipc	ra,0xffffd
    80003c4e:	8f4080e7          	jalr	-1804(ra) # 8000053e <panic>

0000000080003c52 <iget>:
    80003c52:	7179                	addi	sp,sp,-48
    80003c54:	f406                	sd	ra,40(sp)
    80003c56:	f022                	sd	s0,32(sp)
    80003c58:	ec26                	sd	s1,24(sp)
    80003c5a:	e84a                	sd	s2,16(sp)
    80003c5c:	e44e                	sd	s3,8(sp)
    80003c5e:	e052                	sd	s4,0(sp)
    80003c60:	1800                	addi	s0,sp,48
    80003c62:	89aa                	mv	s3,a0
    80003c64:	8a2e                	mv	s4,a1
    80003c66:	0001d517          	auipc	a0,0x1d
    80003c6a:	82250513          	addi	a0,a0,-2014 # 80020488 <itable>
    80003c6e:	ffffd097          	auipc	ra,0xffffd
    80003c72:	f68080e7          	jalr	-152(ra) # 80000bd6 <acquire>
    80003c76:	4901                	li	s2,0
    80003c78:	0001d497          	auipc	s1,0x1d
    80003c7c:	82848493          	addi	s1,s1,-2008 # 800204a0 <itable+0x18>
    80003c80:	0001e697          	auipc	a3,0x1e
    80003c84:	2b068693          	addi	a3,a3,688 # 80021f30 <log>
    80003c88:	a039                	j	80003c96 <iget+0x44>
    80003c8a:	02090b63          	beqz	s2,80003cc0 <iget+0x6e>
    80003c8e:	08848493          	addi	s1,s1,136
    80003c92:	02d48a63          	beq	s1,a3,80003cc6 <iget+0x74>
    80003c96:	449c                	lw	a5,8(s1)
    80003c98:	fef059e3          	blez	a5,80003c8a <iget+0x38>
    80003c9c:	4098                	lw	a4,0(s1)
    80003c9e:	ff3716e3          	bne	a4,s3,80003c8a <iget+0x38>
    80003ca2:	40d8                	lw	a4,4(s1)
    80003ca4:	ff4713e3          	bne	a4,s4,80003c8a <iget+0x38>
    80003ca8:	2785                	addiw	a5,a5,1
    80003caa:	c49c                	sw	a5,8(s1)
    80003cac:	0001c517          	auipc	a0,0x1c
    80003cb0:	7dc50513          	addi	a0,a0,2012 # 80020488 <itable>
    80003cb4:	ffffd097          	auipc	ra,0xffffd
    80003cb8:	fd6080e7          	jalr	-42(ra) # 80000c8a <release>
    80003cbc:	8926                	mv	s2,s1
    80003cbe:	a03d                	j	80003cec <iget+0x9a>
    80003cc0:	f7f9                	bnez	a5,80003c8e <iget+0x3c>
    80003cc2:	8926                	mv	s2,s1
    80003cc4:	b7e9                	j	80003c8e <iget+0x3c>
    80003cc6:	02090c63          	beqz	s2,80003cfe <iget+0xac>
    80003cca:	01392023          	sw	s3,0(s2)
    80003cce:	01492223          	sw	s4,4(s2)
    80003cd2:	4785                	li	a5,1
    80003cd4:	00f92423          	sw	a5,8(s2)
    80003cd8:	04092023          	sw	zero,64(s2)
    80003cdc:	0001c517          	auipc	a0,0x1c
    80003ce0:	7ac50513          	addi	a0,a0,1964 # 80020488 <itable>
    80003ce4:	ffffd097          	auipc	ra,0xffffd
    80003ce8:	fa6080e7          	jalr	-90(ra) # 80000c8a <release>
    80003cec:	854a                	mv	a0,s2
    80003cee:	70a2                	ld	ra,40(sp)
    80003cf0:	7402                	ld	s0,32(sp)
    80003cf2:	64e2                	ld	s1,24(sp)
    80003cf4:	6942                	ld	s2,16(sp)
    80003cf6:	69a2                	ld	s3,8(sp)
    80003cf8:	6a02                	ld	s4,0(sp)
    80003cfa:	6145                	addi	sp,sp,48
    80003cfc:	8082                	ret
    80003cfe:	00005517          	auipc	a0,0x5
    80003d02:	8b250513          	addi	a0,a0,-1870 # 800085b0 <syscalls+0x150>
    80003d06:	ffffd097          	auipc	ra,0xffffd
    80003d0a:	838080e7          	jalr	-1992(ra) # 8000053e <panic>

0000000080003d0e <fsinit>:
    80003d0e:	7179                	addi	sp,sp,-48
    80003d10:	f406                	sd	ra,40(sp)
    80003d12:	f022                	sd	s0,32(sp)
    80003d14:	ec26                	sd	s1,24(sp)
    80003d16:	e84a                	sd	s2,16(sp)
    80003d18:	e44e                	sd	s3,8(sp)
    80003d1a:	1800                	addi	s0,sp,48
    80003d1c:	892a                	mv	s2,a0
    80003d1e:	4585                	li	a1,1
    80003d20:	00000097          	auipc	ra,0x0
    80003d24:	a50080e7          	jalr	-1456(ra) # 80003770 <bread>
    80003d28:	84aa                	mv	s1,a0
    80003d2a:	0001c997          	auipc	s3,0x1c
    80003d2e:	73e98993          	addi	s3,s3,1854 # 80020468 <sb>
    80003d32:	02000613          	li	a2,32
    80003d36:	05850593          	addi	a1,a0,88
    80003d3a:	854e                	mv	a0,s3
    80003d3c:	ffffd097          	auipc	ra,0xffffd
    80003d40:	ff2080e7          	jalr	-14(ra) # 80000d2e <memmove>
    80003d44:	8526                	mv	a0,s1
    80003d46:	00000097          	auipc	ra,0x0
    80003d4a:	b5a080e7          	jalr	-1190(ra) # 800038a0 <brelse>
    80003d4e:	0009a703          	lw	a4,0(s3)
    80003d52:	102037b7          	lui	a5,0x10203
    80003d56:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003d5a:	02f71263          	bne	a4,a5,80003d7e <fsinit+0x70>
    80003d5e:	0001c597          	auipc	a1,0x1c
    80003d62:	70a58593          	addi	a1,a1,1802 # 80020468 <sb>
    80003d66:	854a                	mv	a0,s2
    80003d68:	00001097          	auipc	ra,0x1
    80003d6c:	b40080e7          	jalr	-1216(ra) # 800048a8 <initlog>
    80003d70:	70a2                	ld	ra,40(sp)
    80003d72:	7402                	ld	s0,32(sp)
    80003d74:	64e2                	ld	s1,24(sp)
    80003d76:	6942                	ld	s2,16(sp)
    80003d78:	69a2                	ld	s3,8(sp)
    80003d7a:	6145                	addi	sp,sp,48
    80003d7c:	8082                	ret
    80003d7e:	00005517          	auipc	a0,0x5
    80003d82:	84250513          	addi	a0,a0,-1982 # 800085c0 <syscalls+0x160>
    80003d86:	ffffc097          	auipc	ra,0xffffc
    80003d8a:	7b8080e7          	jalr	1976(ra) # 8000053e <panic>

0000000080003d8e <iinit>:
    80003d8e:	7179                	addi	sp,sp,-48
    80003d90:	f406                	sd	ra,40(sp)
    80003d92:	f022                	sd	s0,32(sp)
    80003d94:	ec26                	sd	s1,24(sp)
    80003d96:	e84a                	sd	s2,16(sp)
    80003d98:	e44e                	sd	s3,8(sp)
    80003d9a:	1800                	addi	s0,sp,48
    80003d9c:	00005597          	auipc	a1,0x5
    80003da0:	83c58593          	addi	a1,a1,-1988 # 800085d8 <syscalls+0x178>
    80003da4:	0001c517          	auipc	a0,0x1c
    80003da8:	6e450513          	addi	a0,a0,1764 # 80020488 <itable>
    80003dac:	ffffd097          	auipc	ra,0xffffd
    80003db0:	d9a080e7          	jalr	-614(ra) # 80000b46 <initlock>
    80003db4:	0001c497          	auipc	s1,0x1c
    80003db8:	6fc48493          	addi	s1,s1,1788 # 800204b0 <itable+0x28>
    80003dbc:	0001e997          	auipc	s3,0x1e
    80003dc0:	18498993          	addi	s3,s3,388 # 80021f40 <log+0x10>
    80003dc4:	00005917          	auipc	s2,0x5
    80003dc8:	81c90913          	addi	s2,s2,-2020 # 800085e0 <syscalls+0x180>
    80003dcc:	85ca                	mv	a1,s2
    80003dce:	8526                	mv	a0,s1
    80003dd0:	00001097          	auipc	ra,0x1
    80003dd4:	e3a080e7          	jalr	-454(ra) # 80004c0a <initsleeplock>
    80003dd8:	08848493          	addi	s1,s1,136
    80003ddc:	ff3498e3          	bne	s1,s3,80003dcc <iinit+0x3e>
    80003de0:	70a2                	ld	ra,40(sp)
    80003de2:	7402                	ld	s0,32(sp)
    80003de4:	64e2                	ld	s1,24(sp)
    80003de6:	6942                	ld	s2,16(sp)
    80003de8:	69a2                	ld	s3,8(sp)
    80003dea:	6145                	addi	sp,sp,48
    80003dec:	8082                	ret

0000000080003dee <ialloc>:
    80003dee:	715d                	addi	sp,sp,-80
    80003df0:	e486                	sd	ra,72(sp)
    80003df2:	e0a2                	sd	s0,64(sp)
    80003df4:	fc26                	sd	s1,56(sp)
    80003df6:	f84a                	sd	s2,48(sp)
    80003df8:	f44e                	sd	s3,40(sp)
    80003dfa:	f052                	sd	s4,32(sp)
    80003dfc:	ec56                	sd	s5,24(sp)
    80003dfe:	e85a                	sd	s6,16(sp)
    80003e00:	e45e                	sd	s7,8(sp)
    80003e02:	0880                	addi	s0,sp,80
    80003e04:	0001c717          	auipc	a4,0x1c
    80003e08:	67072703          	lw	a4,1648(a4) # 80020474 <sb+0xc>
    80003e0c:	4785                	li	a5,1
    80003e0e:	04e7fa63          	bgeu	a5,a4,80003e62 <ialloc+0x74>
    80003e12:	8aaa                	mv	s5,a0
    80003e14:	8bae                	mv	s7,a1
    80003e16:	4485                	li	s1,1
    80003e18:	0001ca17          	auipc	s4,0x1c
    80003e1c:	650a0a13          	addi	s4,s4,1616 # 80020468 <sb>
    80003e20:	00048b1b          	sext.w	s6,s1
    80003e24:	0044d793          	srli	a5,s1,0x4
    80003e28:	018a2583          	lw	a1,24(s4)
    80003e2c:	9dbd                	addw	a1,a1,a5
    80003e2e:	8556                	mv	a0,s5
    80003e30:	00000097          	auipc	ra,0x0
    80003e34:	940080e7          	jalr	-1728(ra) # 80003770 <bread>
    80003e38:	892a                	mv	s2,a0
    80003e3a:	05850993          	addi	s3,a0,88
    80003e3e:	00f4f793          	andi	a5,s1,15
    80003e42:	079a                	slli	a5,a5,0x6
    80003e44:	99be                	add	s3,s3,a5
    80003e46:	00099783          	lh	a5,0(s3)
    80003e4a:	c3a1                	beqz	a5,80003e8a <ialloc+0x9c>
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	a54080e7          	jalr	-1452(ra) # 800038a0 <brelse>
    80003e54:	0485                	addi	s1,s1,1
    80003e56:	00ca2703          	lw	a4,12(s4)
    80003e5a:	0004879b          	sext.w	a5,s1
    80003e5e:	fce7e1e3          	bltu	a5,a4,80003e20 <ialloc+0x32>
    80003e62:	00004517          	auipc	a0,0x4
    80003e66:	78650513          	addi	a0,a0,1926 # 800085e8 <syscalls+0x188>
    80003e6a:	ffffc097          	auipc	ra,0xffffc
    80003e6e:	71e080e7          	jalr	1822(ra) # 80000588 <printf>
    80003e72:	4501                	li	a0,0
    80003e74:	60a6                	ld	ra,72(sp)
    80003e76:	6406                	ld	s0,64(sp)
    80003e78:	74e2                	ld	s1,56(sp)
    80003e7a:	7942                	ld	s2,48(sp)
    80003e7c:	79a2                	ld	s3,40(sp)
    80003e7e:	7a02                	ld	s4,32(sp)
    80003e80:	6ae2                	ld	s5,24(sp)
    80003e82:	6b42                	ld	s6,16(sp)
    80003e84:	6ba2                	ld	s7,8(sp)
    80003e86:	6161                	addi	sp,sp,80
    80003e88:	8082                	ret
    80003e8a:	04000613          	li	a2,64
    80003e8e:	4581                	li	a1,0
    80003e90:	854e                	mv	a0,s3
    80003e92:	ffffd097          	auipc	ra,0xffffd
    80003e96:	e40080e7          	jalr	-448(ra) # 80000cd2 <memset>
    80003e9a:	01799023          	sh	s7,0(s3)
    80003e9e:	854a                	mv	a0,s2
    80003ea0:	00001097          	auipc	ra,0x1
    80003ea4:	c84080e7          	jalr	-892(ra) # 80004b24 <log_write>
    80003ea8:	854a                	mv	a0,s2
    80003eaa:	00000097          	auipc	ra,0x0
    80003eae:	9f6080e7          	jalr	-1546(ra) # 800038a0 <brelse>
    80003eb2:	85da                	mv	a1,s6
    80003eb4:	8556                	mv	a0,s5
    80003eb6:	00000097          	auipc	ra,0x0
    80003eba:	d9c080e7          	jalr	-612(ra) # 80003c52 <iget>
    80003ebe:	bf5d                	j	80003e74 <ialloc+0x86>

0000000080003ec0 <iupdate>:
    80003ec0:	1101                	addi	sp,sp,-32
    80003ec2:	ec06                	sd	ra,24(sp)
    80003ec4:	e822                	sd	s0,16(sp)
    80003ec6:	e426                	sd	s1,8(sp)
    80003ec8:	e04a                	sd	s2,0(sp)
    80003eca:	1000                	addi	s0,sp,32
    80003ecc:	84aa                	mv	s1,a0
    80003ece:	415c                	lw	a5,4(a0)
    80003ed0:	0047d79b          	srliw	a5,a5,0x4
    80003ed4:	0001c597          	auipc	a1,0x1c
    80003ed8:	5ac5a583          	lw	a1,1452(a1) # 80020480 <sb+0x18>
    80003edc:	9dbd                	addw	a1,a1,a5
    80003ede:	4108                	lw	a0,0(a0)
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	890080e7          	jalr	-1904(ra) # 80003770 <bread>
    80003ee8:	892a                	mv	s2,a0
    80003eea:	05850793          	addi	a5,a0,88
    80003eee:	40c8                	lw	a0,4(s1)
    80003ef0:	893d                	andi	a0,a0,15
    80003ef2:	051a                	slli	a0,a0,0x6
    80003ef4:	953e                	add	a0,a0,a5
    80003ef6:	04449703          	lh	a4,68(s1)
    80003efa:	00e51023          	sh	a4,0(a0)
    80003efe:	04649703          	lh	a4,70(s1)
    80003f02:	00e51123          	sh	a4,2(a0)
    80003f06:	04849703          	lh	a4,72(s1)
    80003f0a:	00e51223          	sh	a4,4(a0)
    80003f0e:	04a49703          	lh	a4,74(s1)
    80003f12:	00e51323          	sh	a4,6(a0)
    80003f16:	44f8                	lw	a4,76(s1)
    80003f18:	c518                	sw	a4,8(a0)
    80003f1a:	03400613          	li	a2,52
    80003f1e:	05048593          	addi	a1,s1,80
    80003f22:	0531                	addi	a0,a0,12
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	e0a080e7          	jalr	-502(ra) # 80000d2e <memmove>
    80003f2c:	854a                	mv	a0,s2
    80003f2e:	00001097          	auipc	ra,0x1
    80003f32:	bf6080e7          	jalr	-1034(ra) # 80004b24 <log_write>
    80003f36:	854a                	mv	a0,s2
    80003f38:	00000097          	auipc	ra,0x0
    80003f3c:	968080e7          	jalr	-1688(ra) # 800038a0 <brelse>
    80003f40:	60e2                	ld	ra,24(sp)
    80003f42:	6442                	ld	s0,16(sp)
    80003f44:	64a2                	ld	s1,8(sp)
    80003f46:	6902                	ld	s2,0(sp)
    80003f48:	6105                	addi	sp,sp,32
    80003f4a:	8082                	ret

0000000080003f4c <idup>:
    80003f4c:	1101                	addi	sp,sp,-32
    80003f4e:	ec06                	sd	ra,24(sp)
    80003f50:	e822                	sd	s0,16(sp)
    80003f52:	e426                	sd	s1,8(sp)
    80003f54:	1000                	addi	s0,sp,32
    80003f56:	84aa                	mv	s1,a0
    80003f58:	0001c517          	auipc	a0,0x1c
    80003f5c:	53050513          	addi	a0,a0,1328 # 80020488 <itable>
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	c76080e7          	jalr	-906(ra) # 80000bd6 <acquire>
    80003f68:	449c                	lw	a5,8(s1)
    80003f6a:	2785                	addiw	a5,a5,1
    80003f6c:	c49c                	sw	a5,8(s1)
    80003f6e:	0001c517          	auipc	a0,0x1c
    80003f72:	51a50513          	addi	a0,a0,1306 # 80020488 <itable>
    80003f76:	ffffd097          	auipc	ra,0xffffd
    80003f7a:	d14080e7          	jalr	-748(ra) # 80000c8a <release>
    80003f7e:	8526                	mv	a0,s1
    80003f80:	60e2                	ld	ra,24(sp)
    80003f82:	6442                	ld	s0,16(sp)
    80003f84:	64a2                	ld	s1,8(sp)
    80003f86:	6105                	addi	sp,sp,32
    80003f88:	8082                	ret

0000000080003f8a <ilock>:
    80003f8a:	1101                	addi	sp,sp,-32
    80003f8c:	ec06                	sd	ra,24(sp)
    80003f8e:	e822                	sd	s0,16(sp)
    80003f90:	e426                	sd	s1,8(sp)
    80003f92:	e04a                	sd	s2,0(sp)
    80003f94:	1000                	addi	s0,sp,32
    80003f96:	c115                	beqz	a0,80003fba <ilock+0x30>
    80003f98:	84aa                	mv	s1,a0
    80003f9a:	451c                	lw	a5,8(a0)
    80003f9c:	00f05f63          	blez	a5,80003fba <ilock+0x30>
    80003fa0:	0541                	addi	a0,a0,16
    80003fa2:	00001097          	auipc	ra,0x1
    80003fa6:	ca2080e7          	jalr	-862(ra) # 80004c44 <acquiresleep>
    80003faa:	40bc                	lw	a5,64(s1)
    80003fac:	cf99                	beqz	a5,80003fca <ilock+0x40>
    80003fae:	60e2                	ld	ra,24(sp)
    80003fb0:	6442                	ld	s0,16(sp)
    80003fb2:	64a2                	ld	s1,8(sp)
    80003fb4:	6902                	ld	s2,0(sp)
    80003fb6:	6105                	addi	sp,sp,32
    80003fb8:	8082                	ret
    80003fba:	00004517          	auipc	a0,0x4
    80003fbe:	64650513          	addi	a0,a0,1606 # 80008600 <syscalls+0x1a0>
    80003fc2:	ffffc097          	auipc	ra,0xffffc
    80003fc6:	57c080e7          	jalr	1404(ra) # 8000053e <panic>
    80003fca:	40dc                	lw	a5,4(s1)
    80003fcc:	0047d79b          	srliw	a5,a5,0x4
    80003fd0:	0001c597          	auipc	a1,0x1c
    80003fd4:	4b05a583          	lw	a1,1200(a1) # 80020480 <sb+0x18>
    80003fd8:	9dbd                	addw	a1,a1,a5
    80003fda:	4088                	lw	a0,0(s1)
    80003fdc:	fffff097          	auipc	ra,0xfffff
    80003fe0:	794080e7          	jalr	1940(ra) # 80003770 <bread>
    80003fe4:	892a                	mv	s2,a0
    80003fe6:	05850593          	addi	a1,a0,88
    80003fea:	40dc                	lw	a5,4(s1)
    80003fec:	8bbd                	andi	a5,a5,15
    80003fee:	079a                	slli	a5,a5,0x6
    80003ff0:	95be                	add	a1,a1,a5
    80003ff2:	00059783          	lh	a5,0(a1)
    80003ff6:	04f49223          	sh	a5,68(s1)
    80003ffa:	00259783          	lh	a5,2(a1)
    80003ffe:	04f49323          	sh	a5,70(s1)
    80004002:	00459783          	lh	a5,4(a1)
    80004006:	04f49423          	sh	a5,72(s1)
    8000400a:	00659783          	lh	a5,6(a1)
    8000400e:	04f49523          	sh	a5,74(s1)
    80004012:	459c                	lw	a5,8(a1)
    80004014:	c4fc                	sw	a5,76(s1)
    80004016:	03400613          	li	a2,52
    8000401a:	05b1                	addi	a1,a1,12
    8000401c:	05048513          	addi	a0,s1,80
    80004020:	ffffd097          	auipc	ra,0xffffd
    80004024:	d0e080e7          	jalr	-754(ra) # 80000d2e <memmove>
    80004028:	854a                	mv	a0,s2
    8000402a:	00000097          	auipc	ra,0x0
    8000402e:	876080e7          	jalr	-1930(ra) # 800038a0 <brelse>
    80004032:	4785                	li	a5,1
    80004034:	c0bc                	sw	a5,64(s1)
    80004036:	04449783          	lh	a5,68(s1)
    8000403a:	fbb5                	bnez	a5,80003fae <ilock+0x24>
    8000403c:	00004517          	auipc	a0,0x4
    80004040:	5cc50513          	addi	a0,a0,1484 # 80008608 <syscalls+0x1a8>
    80004044:	ffffc097          	auipc	ra,0xffffc
    80004048:	4fa080e7          	jalr	1274(ra) # 8000053e <panic>

000000008000404c <iunlock>:
    8000404c:	1101                	addi	sp,sp,-32
    8000404e:	ec06                	sd	ra,24(sp)
    80004050:	e822                	sd	s0,16(sp)
    80004052:	e426                	sd	s1,8(sp)
    80004054:	e04a                	sd	s2,0(sp)
    80004056:	1000                	addi	s0,sp,32
    80004058:	c905                	beqz	a0,80004088 <iunlock+0x3c>
    8000405a:	84aa                	mv	s1,a0
    8000405c:	01050913          	addi	s2,a0,16
    80004060:	854a                	mv	a0,s2
    80004062:	00001097          	auipc	ra,0x1
    80004066:	c7c080e7          	jalr	-900(ra) # 80004cde <holdingsleep>
    8000406a:	cd19                	beqz	a0,80004088 <iunlock+0x3c>
    8000406c:	449c                	lw	a5,8(s1)
    8000406e:	00f05d63          	blez	a5,80004088 <iunlock+0x3c>
    80004072:	854a                	mv	a0,s2
    80004074:	00001097          	auipc	ra,0x1
    80004078:	c26080e7          	jalr	-986(ra) # 80004c9a <releasesleep>
    8000407c:	60e2                	ld	ra,24(sp)
    8000407e:	6442                	ld	s0,16(sp)
    80004080:	64a2                	ld	s1,8(sp)
    80004082:	6902                	ld	s2,0(sp)
    80004084:	6105                	addi	sp,sp,32
    80004086:	8082                	ret
    80004088:	00004517          	auipc	a0,0x4
    8000408c:	59050513          	addi	a0,a0,1424 # 80008618 <syscalls+0x1b8>
    80004090:	ffffc097          	auipc	ra,0xffffc
    80004094:	4ae080e7          	jalr	1198(ra) # 8000053e <panic>

0000000080004098 <itrunc>:
    80004098:	7179                	addi	sp,sp,-48
    8000409a:	f406                	sd	ra,40(sp)
    8000409c:	f022                	sd	s0,32(sp)
    8000409e:	ec26                	sd	s1,24(sp)
    800040a0:	e84a                	sd	s2,16(sp)
    800040a2:	e44e                	sd	s3,8(sp)
    800040a4:	e052                	sd	s4,0(sp)
    800040a6:	1800                	addi	s0,sp,48
    800040a8:	89aa                	mv	s3,a0
    800040aa:	05050493          	addi	s1,a0,80
    800040ae:	08050913          	addi	s2,a0,128
    800040b2:	a021                	j	800040ba <itrunc+0x22>
    800040b4:	0491                	addi	s1,s1,4
    800040b6:	01248d63          	beq	s1,s2,800040d0 <itrunc+0x38>
    800040ba:	408c                	lw	a1,0(s1)
    800040bc:	dde5                	beqz	a1,800040b4 <itrunc+0x1c>
    800040be:	0009a503          	lw	a0,0(s3)
    800040c2:	00000097          	auipc	ra,0x0
    800040c6:	8f4080e7          	jalr	-1804(ra) # 800039b6 <bfree>
    800040ca:	0004a023          	sw	zero,0(s1)
    800040ce:	b7dd                	j	800040b4 <itrunc+0x1c>
    800040d0:	0809a583          	lw	a1,128(s3)
    800040d4:	e185                	bnez	a1,800040f4 <itrunc+0x5c>
    800040d6:	0409a623          	sw	zero,76(s3)
    800040da:	854e                	mv	a0,s3
    800040dc:	00000097          	auipc	ra,0x0
    800040e0:	de4080e7          	jalr	-540(ra) # 80003ec0 <iupdate>
    800040e4:	70a2                	ld	ra,40(sp)
    800040e6:	7402                	ld	s0,32(sp)
    800040e8:	64e2                	ld	s1,24(sp)
    800040ea:	6942                	ld	s2,16(sp)
    800040ec:	69a2                	ld	s3,8(sp)
    800040ee:	6a02                	ld	s4,0(sp)
    800040f0:	6145                	addi	sp,sp,48
    800040f2:	8082                	ret
    800040f4:	0009a503          	lw	a0,0(s3)
    800040f8:	fffff097          	auipc	ra,0xfffff
    800040fc:	678080e7          	jalr	1656(ra) # 80003770 <bread>
    80004100:	8a2a                	mv	s4,a0
    80004102:	05850493          	addi	s1,a0,88
    80004106:	45850913          	addi	s2,a0,1112
    8000410a:	a021                	j	80004112 <itrunc+0x7a>
    8000410c:	0491                	addi	s1,s1,4
    8000410e:	01248b63          	beq	s1,s2,80004124 <itrunc+0x8c>
    80004112:	408c                	lw	a1,0(s1)
    80004114:	dde5                	beqz	a1,8000410c <itrunc+0x74>
    80004116:	0009a503          	lw	a0,0(s3)
    8000411a:	00000097          	auipc	ra,0x0
    8000411e:	89c080e7          	jalr	-1892(ra) # 800039b6 <bfree>
    80004122:	b7ed                	j	8000410c <itrunc+0x74>
    80004124:	8552                	mv	a0,s4
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	77a080e7          	jalr	1914(ra) # 800038a0 <brelse>
    8000412e:	0809a583          	lw	a1,128(s3)
    80004132:	0009a503          	lw	a0,0(s3)
    80004136:	00000097          	auipc	ra,0x0
    8000413a:	880080e7          	jalr	-1920(ra) # 800039b6 <bfree>
    8000413e:	0809a023          	sw	zero,128(s3)
    80004142:	bf51                	j	800040d6 <itrunc+0x3e>

0000000080004144 <iput>:
    80004144:	1101                	addi	sp,sp,-32
    80004146:	ec06                	sd	ra,24(sp)
    80004148:	e822                	sd	s0,16(sp)
    8000414a:	e426                	sd	s1,8(sp)
    8000414c:	e04a                	sd	s2,0(sp)
    8000414e:	1000                	addi	s0,sp,32
    80004150:	84aa                	mv	s1,a0
    80004152:	0001c517          	auipc	a0,0x1c
    80004156:	33650513          	addi	a0,a0,822 # 80020488 <itable>
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	a7c080e7          	jalr	-1412(ra) # 80000bd6 <acquire>
    80004162:	4498                	lw	a4,8(s1)
    80004164:	4785                	li	a5,1
    80004166:	02f70363          	beq	a4,a5,8000418c <iput+0x48>
    8000416a:	449c                	lw	a5,8(s1)
    8000416c:	37fd                	addiw	a5,a5,-1
    8000416e:	c49c                	sw	a5,8(s1)
    80004170:	0001c517          	auipc	a0,0x1c
    80004174:	31850513          	addi	a0,a0,792 # 80020488 <itable>
    80004178:	ffffd097          	auipc	ra,0xffffd
    8000417c:	b12080e7          	jalr	-1262(ra) # 80000c8a <release>
    80004180:	60e2                	ld	ra,24(sp)
    80004182:	6442                	ld	s0,16(sp)
    80004184:	64a2                	ld	s1,8(sp)
    80004186:	6902                	ld	s2,0(sp)
    80004188:	6105                	addi	sp,sp,32
    8000418a:	8082                	ret
    8000418c:	40bc                	lw	a5,64(s1)
    8000418e:	dff1                	beqz	a5,8000416a <iput+0x26>
    80004190:	04a49783          	lh	a5,74(s1)
    80004194:	fbf9                	bnez	a5,8000416a <iput+0x26>
    80004196:	01048913          	addi	s2,s1,16
    8000419a:	854a                	mv	a0,s2
    8000419c:	00001097          	auipc	ra,0x1
    800041a0:	aa8080e7          	jalr	-1368(ra) # 80004c44 <acquiresleep>
    800041a4:	0001c517          	auipc	a0,0x1c
    800041a8:	2e450513          	addi	a0,a0,740 # 80020488 <itable>
    800041ac:	ffffd097          	auipc	ra,0xffffd
    800041b0:	ade080e7          	jalr	-1314(ra) # 80000c8a <release>
    800041b4:	8526                	mv	a0,s1
    800041b6:	00000097          	auipc	ra,0x0
    800041ba:	ee2080e7          	jalr	-286(ra) # 80004098 <itrunc>
    800041be:	04049223          	sh	zero,68(s1)
    800041c2:	8526                	mv	a0,s1
    800041c4:	00000097          	auipc	ra,0x0
    800041c8:	cfc080e7          	jalr	-772(ra) # 80003ec0 <iupdate>
    800041cc:	0404a023          	sw	zero,64(s1)
    800041d0:	854a                	mv	a0,s2
    800041d2:	00001097          	auipc	ra,0x1
    800041d6:	ac8080e7          	jalr	-1336(ra) # 80004c9a <releasesleep>
    800041da:	0001c517          	auipc	a0,0x1c
    800041de:	2ae50513          	addi	a0,a0,686 # 80020488 <itable>
    800041e2:	ffffd097          	auipc	ra,0xffffd
    800041e6:	9f4080e7          	jalr	-1548(ra) # 80000bd6 <acquire>
    800041ea:	b741                	j	8000416a <iput+0x26>

00000000800041ec <iunlockput>:
    800041ec:	1101                	addi	sp,sp,-32
    800041ee:	ec06                	sd	ra,24(sp)
    800041f0:	e822                	sd	s0,16(sp)
    800041f2:	e426                	sd	s1,8(sp)
    800041f4:	1000                	addi	s0,sp,32
    800041f6:	84aa                	mv	s1,a0
    800041f8:	00000097          	auipc	ra,0x0
    800041fc:	e54080e7          	jalr	-428(ra) # 8000404c <iunlock>
    80004200:	8526                	mv	a0,s1
    80004202:	00000097          	auipc	ra,0x0
    80004206:	f42080e7          	jalr	-190(ra) # 80004144 <iput>
    8000420a:	60e2                	ld	ra,24(sp)
    8000420c:	6442                	ld	s0,16(sp)
    8000420e:	64a2                	ld	s1,8(sp)
    80004210:	6105                	addi	sp,sp,32
    80004212:	8082                	ret

0000000080004214 <stati>:
    80004214:	1141                	addi	sp,sp,-16
    80004216:	e422                	sd	s0,8(sp)
    80004218:	0800                	addi	s0,sp,16
    8000421a:	411c                	lw	a5,0(a0)
    8000421c:	c19c                	sw	a5,0(a1)
    8000421e:	415c                	lw	a5,4(a0)
    80004220:	c1dc                	sw	a5,4(a1)
    80004222:	04451783          	lh	a5,68(a0)
    80004226:	00f59423          	sh	a5,8(a1)
    8000422a:	04a51783          	lh	a5,74(a0)
    8000422e:	00f59523          	sh	a5,10(a1)
    80004232:	04c56783          	lwu	a5,76(a0)
    80004236:	e99c                	sd	a5,16(a1)
    80004238:	6422                	ld	s0,8(sp)
    8000423a:	0141                	addi	sp,sp,16
    8000423c:	8082                	ret

000000008000423e <readi>:
    8000423e:	457c                	lw	a5,76(a0)
    80004240:	0ed7e963          	bltu	a5,a3,80004332 <readi+0xf4>
    80004244:	7159                	addi	sp,sp,-112
    80004246:	f486                	sd	ra,104(sp)
    80004248:	f0a2                	sd	s0,96(sp)
    8000424a:	eca6                	sd	s1,88(sp)
    8000424c:	e8ca                	sd	s2,80(sp)
    8000424e:	e4ce                	sd	s3,72(sp)
    80004250:	e0d2                	sd	s4,64(sp)
    80004252:	fc56                	sd	s5,56(sp)
    80004254:	f85a                	sd	s6,48(sp)
    80004256:	f45e                	sd	s7,40(sp)
    80004258:	f062                	sd	s8,32(sp)
    8000425a:	ec66                	sd	s9,24(sp)
    8000425c:	e86a                	sd	s10,16(sp)
    8000425e:	e46e                	sd	s11,8(sp)
    80004260:	1880                	addi	s0,sp,112
    80004262:	8b2a                	mv	s6,a0
    80004264:	8bae                	mv	s7,a1
    80004266:	8a32                	mv	s4,a2
    80004268:	84b6                	mv	s1,a3
    8000426a:	8aba                	mv	s5,a4
    8000426c:	9f35                	addw	a4,a4,a3
    8000426e:	4501                	li	a0,0
    80004270:	0ad76063          	bltu	a4,a3,80004310 <readi+0xd2>
    80004274:	00e7f463          	bgeu	a5,a4,8000427c <readi+0x3e>
    80004278:	40d78abb          	subw	s5,a5,a3
    8000427c:	0a0a8963          	beqz	s5,8000432e <readi+0xf0>
    80004280:	4981                	li	s3,0
    80004282:	40000c93          	li	s9,1024
    80004286:	5c7d                	li	s8,-1
    80004288:	a82d                	j	800042c2 <readi+0x84>
    8000428a:	020d1d93          	slli	s11,s10,0x20
    8000428e:	020ddd93          	srli	s11,s11,0x20
    80004292:	05890793          	addi	a5,s2,88
    80004296:	86ee                	mv	a3,s11
    80004298:	963e                	add	a2,a2,a5
    8000429a:	85d2                	mv	a1,s4
    8000429c:	855e                	mv	a0,s7
    8000429e:	ffffe097          	auipc	ra,0xffffe
    800042a2:	294080e7          	jalr	660(ra) # 80002532 <either_copyout>
    800042a6:	05850d63          	beq	a0,s8,80004300 <readi+0xc2>
    800042aa:	854a                	mv	a0,s2
    800042ac:	fffff097          	auipc	ra,0xfffff
    800042b0:	5f4080e7          	jalr	1524(ra) # 800038a0 <brelse>
    800042b4:	013d09bb          	addw	s3,s10,s3
    800042b8:	009d04bb          	addw	s1,s10,s1
    800042bc:	9a6e                	add	s4,s4,s11
    800042be:	0559f763          	bgeu	s3,s5,8000430c <readi+0xce>
    800042c2:	00a4d59b          	srliw	a1,s1,0xa
    800042c6:	855a                	mv	a0,s6
    800042c8:	00000097          	auipc	ra,0x0
    800042cc:	8a2080e7          	jalr	-1886(ra) # 80003b6a <bmap>
    800042d0:	0005059b          	sext.w	a1,a0
    800042d4:	cd85                	beqz	a1,8000430c <readi+0xce>
    800042d6:	000b2503          	lw	a0,0(s6)
    800042da:	fffff097          	auipc	ra,0xfffff
    800042de:	496080e7          	jalr	1174(ra) # 80003770 <bread>
    800042e2:	892a                	mv	s2,a0
    800042e4:	3ff4f613          	andi	a2,s1,1023
    800042e8:	40cc87bb          	subw	a5,s9,a2
    800042ec:	413a873b          	subw	a4,s5,s3
    800042f0:	8d3e                	mv	s10,a5
    800042f2:	2781                	sext.w	a5,a5
    800042f4:	0007069b          	sext.w	a3,a4
    800042f8:	f8f6f9e3          	bgeu	a3,a5,8000428a <readi+0x4c>
    800042fc:	8d3a                	mv	s10,a4
    800042fe:	b771                	j	8000428a <readi+0x4c>
    80004300:	854a                	mv	a0,s2
    80004302:	fffff097          	auipc	ra,0xfffff
    80004306:	59e080e7          	jalr	1438(ra) # 800038a0 <brelse>
    8000430a:	59fd                	li	s3,-1
    8000430c:	0009851b          	sext.w	a0,s3
    80004310:	70a6                	ld	ra,104(sp)
    80004312:	7406                	ld	s0,96(sp)
    80004314:	64e6                	ld	s1,88(sp)
    80004316:	6946                	ld	s2,80(sp)
    80004318:	69a6                	ld	s3,72(sp)
    8000431a:	6a06                	ld	s4,64(sp)
    8000431c:	7ae2                	ld	s5,56(sp)
    8000431e:	7b42                	ld	s6,48(sp)
    80004320:	7ba2                	ld	s7,40(sp)
    80004322:	7c02                	ld	s8,32(sp)
    80004324:	6ce2                	ld	s9,24(sp)
    80004326:	6d42                	ld	s10,16(sp)
    80004328:	6da2                	ld	s11,8(sp)
    8000432a:	6165                	addi	sp,sp,112
    8000432c:	8082                	ret
    8000432e:	89d6                	mv	s3,s5
    80004330:	bff1                	j	8000430c <readi+0xce>
    80004332:	4501                	li	a0,0
    80004334:	8082                	ret

0000000080004336 <writei>:
    80004336:	457c                	lw	a5,76(a0)
    80004338:	10d7e863          	bltu	a5,a3,80004448 <writei+0x112>
    8000433c:	7159                	addi	sp,sp,-112
    8000433e:	f486                	sd	ra,104(sp)
    80004340:	f0a2                	sd	s0,96(sp)
    80004342:	eca6                	sd	s1,88(sp)
    80004344:	e8ca                	sd	s2,80(sp)
    80004346:	e4ce                	sd	s3,72(sp)
    80004348:	e0d2                	sd	s4,64(sp)
    8000434a:	fc56                	sd	s5,56(sp)
    8000434c:	f85a                	sd	s6,48(sp)
    8000434e:	f45e                	sd	s7,40(sp)
    80004350:	f062                	sd	s8,32(sp)
    80004352:	ec66                	sd	s9,24(sp)
    80004354:	e86a                	sd	s10,16(sp)
    80004356:	e46e                	sd	s11,8(sp)
    80004358:	1880                	addi	s0,sp,112
    8000435a:	8aaa                	mv	s5,a0
    8000435c:	8bae                	mv	s7,a1
    8000435e:	8a32                	mv	s4,a2
    80004360:	8936                	mv	s2,a3
    80004362:	8b3a                	mv	s6,a4
    80004364:	00e687bb          	addw	a5,a3,a4
    80004368:	0ed7e263          	bltu	a5,a3,8000444c <writei+0x116>
    8000436c:	00043737          	lui	a4,0x43
    80004370:	0ef76063          	bltu	a4,a5,80004450 <writei+0x11a>
    80004374:	0c0b0863          	beqz	s6,80004444 <writei+0x10e>
    80004378:	4981                	li	s3,0
    8000437a:	40000c93          	li	s9,1024
    8000437e:	5c7d                	li	s8,-1
    80004380:	a091                	j	800043c4 <writei+0x8e>
    80004382:	020d1d93          	slli	s11,s10,0x20
    80004386:	020ddd93          	srli	s11,s11,0x20
    8000438a:	05848793          	addi	a5,s1,88
    8000438e:	86ee                	mv	a3,s11
    80004390:	8652                	mv	a2,s4
    80004392:	85de                	mv	a1,s7
    80004394:	953e                	add	a0,a0,a5
    80004396:	ffffe097          	auipc	ra,0xffffe
    8000439a:	1f2080e7          	jalr	498(ra) # 80002588 <either_copyin>
    8000439e:	07850263          	beq	a0,s8,80004402 <writei+0xcc>
    800043a2:	8526                	mv	a0,s1
    800043a4:	00000097          	auipc	ra,0x0
    800043a8:	780080e7          	jalr	1920(ra) # 80004b24 <log_write>
    800043ac:	8526                	mv	a0,s1
    800043ae:	fffff097          	auipc	ra,0xfffff
    800043b2:	4f2080e7          	jalr	1266(ra) # 800038a0 <brelse>
    800043b6:	013d09bb          	addw	s3,s10,s3
    800043ba:	012d093b          	addw	s2,s10,s2
    800043be:	9a6e                	add	s4,s4,s11
    800043c0:	0569f663          	bgeu	s3,s6,8000440c <writei+0xd6>
    800043c4:	00a9559b          	srliw	a1,s2,0xa
    800043c8:	8556                	mv	a0,s5
    800043ca:	fffff097          	auipc	ra,0xfffff
    800043ce:	7a0080e7          	jalr	1952(ra) # 80003b6a <bmap>
    800043d2:	0005059b          	sext.w	a1,a0
    800043d6:	c99d                	beqz	a1,8000440c <writei+0xd6>
    800043d8:	000aa503          	lw	a0,0(s5)
    800043dc:	fffff097          	auipc	ra,0xfffff
    800043e0:	394080e7          	jalr	916(ra) # 80003770 <bread>
    800043e4:	84aa                	mv	s1,a0
    800043e6:	3ff97513          	andi	a0,s2,1023
    800043ea:	40ac87bb          	subw	a5,s9,a0
    800043ee:	413b073b          	subw	a4,s6,s3
    800043f2:	8d3e                	mv	s10,a5
    800043f4:	2781                	sext.w	a5,a5
    800043f6:	0007069b          	sext.w	a3,a4
    800043fa:	f8f6f4e3          	bgeu	a3,a5,80004382 <writei+0x4c>
    800043fe:	8d3a                	mv	s10,a4
    80004400:	b749                	j	80004382 <writei+0x4c>
    80004402:	8526                	mv	a0,s1
    80004404:	fffff097          	auipc	ra,0xfffff
    80004408:	49c080e7          	jalr	1180(ra) # 800038a0 <brelse>
    8000440c:	04caa783          	lw	a5,76(s5)
    80004410:	0127f463          	bgeu	a5,s2,80004418 <writei+0xe2>
    80004414:	052aa623          	sw	s2,76(s5)
    80004418:	8556                	mv	a0,s5
    8000441a:	00000097          	auipc	ra,0x0
    8000441e:	aa6080e7          	jalr	-1370(ra) # 80003ec0 <iupdate>
    80004422:	0009851b          	sext.w	a0,s3
    80004426:	70a6                	ld	ra,104(sp)
    80004428:	7406                	ld	s0,96(sp)
    8000442a:	64e6                	ld	s1,88(sp)
    8000442c:	6946                	ld	s2,80(sp)
    8000442e:	69a6                	ld	s3,72(sp)
    80004430:	6a06                	ld	s4,64(sp)
    80004432:	7ae2                	ld	s5,56(sp)
    80004434:	7b42                	ld	s6,48(sp)
    80004436:	7ba2                	ld	s7,40(sp)
    80004438:	7c02                	ld	s8,32(sp)
    8000443a:	6ce2                	ld	s9,24(sp)
    8000443c:	6d42                	ld	s10,16(sp)
    8000443e:	6da2                	ld	s11,8(sp)
    80004440:	6165                	addi	sp,sp,112
    80004442:	8082                	ret
    80004444:	89da                	mv	s3,s6
    80004446:	bfc9                	j	80004418 <writei+0xe2>
    80004448:	557d                	li	a0,-1
    8000444a:	8082                	ret
    8000444c:	557d                	li	a0,-1
    8000444e:	bfe1                	j	80004426 <writei+0xf0>
    80004450:	557d                	li	a0,-1
    80004452:	bfd1                	j	80004426 <writei+0xf0>

0000000080004454 <namecmp>:
    80004454:	1141                	addi	sp,sp,-16
    80004456:	e406                	sd	ra,8(sp)
    80004458:	e022                	sd	s0,0(sp)
    8000445a:	0800                	addi	s0,sp,16
    8000445c:	4639                	li	a2,14
    8000445e:	ffffd097          	auipc	ra,0xffffd
    80004462:	944080e7          	jalr	-1724(ra) # 80000da2 <strncmp>
    80004466:	60a2                	ld	ra,8(sp)
    80004468:	6402                	ld	s0,0(sp)
    8000446a:	0141                	addi	sp,sp,16
    8000446c:	8082                	ret

000000008000446e <dirlookup>:
    8000446e:	7139                	addi	sp,sp,-64
    80004470:	fc06                	sd	ra,56(sp)
    80004472:	f822                	sd	s0,48(sp)
    80004474:	f426                	sd	s1,40(sp)
    80004476:	f04a                	sd	s2,32(sp)
    80004478:	ec4e                	sd	s3,24(sp)
    8000447a:	e852                	sd	s4,16(sp)
    8000447c:	0080                	addi	s0,sp,64
    8000447e:	04451703          	lh	a4,68(a0)
    80004482:	4785                	li	a5,1
    80004484:	00f71a63          	bne	a4,a5,80004498 <dirlookup+0x2a>
    80004488:	892a                	mv	s2,a0
    8000448a:	89ae                	mv	s3,a1
    8000448c:	8a32                	mv	s4,a2
    8000448e:	457c                	lw	a5,76(a0)
    80004490:	4481                	li	s1,0
    80004492:	4501                	li	a0,0
    80004494:	e79d                	bnez	a5,800044c2 <dirlookup+0x54>
    80004496:	a8a5                	j	8000450e <dirlookup+0xa0>
    80004498:	00004517          	auipc	a0,0x4
    8000449c:	18850513          	addi	a0,a0,392 # 80008620 <syscalls+0x1c0>
    800044a0:	ffffc097          	auipc	ra,0xffffc
    800044a4:	09e080e7          	jalr	158(ra) # 8000053e <panic>
    800044a8:	00004517          	auipc	a0,0x4
    800044ac:	19050513          	addi	a0,a0,400 # 80008638 <syscalls+0x1d8>
    800044b0:	ffffc097          	auipc	ra,0xffffc
    800044b4:	08e080e7          	jalr	142(ra) # 8000053e <panic>
    800044b8:	24c1                	addiw	s1,s1,16
    800044ba:	04c92783          	lw	a5,76(s2)
    800044be:	04f4f763          	bgeu	s1,a5,8000450c <dirlookup+0x9e>
    800044c2:	4741                	li	a4,16
    800044c4:	86a6                	mv	a3,s1
    800044c6:	fc040613          	addi	a2,s0,-64
    800044ca:	4581                	li	a1,0
    800044cc:	854a                	mv	a0,s2
    800044ce:	00000097          	auipc	ra,0x0
    800044d2:	d70080e7          	jalr	-656(ra) # 8000423e <readi>
    800044d6:	47c1                	li	a5,16
    800044d8:	fcf518e3          	bne	a0,a5,800044a8 <dirlookup+0x3a>
    800044dc:	fc045783          	lhu	a5,-64(s0)
    800044e0:	dfe1                	beqz	a5,800044b8 <dirlookup+0x4a>
    800044e2:	fc240593          	addi	a1,s0,-62
    800044e6:	854e                	mv	a0,s3
    800044e8:	00000097          	auipc	ra,0x0
    800044ec:	f6c080e7          	jalr	-148(ra) # 80004454 <namecmp>
    800044f0:	f561                	bnez	a0,800044b8 <dirlookup+0x4a>
    800044f2:	000a0463          	beqz	s4,800044fa <dirlookup+0x8c>
    800044f6:	009a2023          	sw	s1,0(s4)
    800044fa:	fc045583          	lhu	a1,-64(s0)
    800044fe:	00092503          	lw	a0,0(s2)
    80004502:	fffff097          	auipc	ra,0xfffff
    80004506:	750080e7          	jalr	1872(ra) # 80003c52 <iget>
    8000450a:	a011                	j	8000450e <dirlookup+0xa0>
    8000450c:	4501                	li	a0,0
    8000450e:	70e2                	ld	ra,56(sp)
    80004510:	7442                	ld	s0,48(sp)
    80004512:	74a2                	ld	s1,40(sp)
    80004514:	7902                	ld	s2,32(sp)
    80004516:	69e2                	ld	s3,24(sp)
    80004518:	6a42                	ld	s4,16(sp)
    8000451a:	6121                	addi	sp,sp,64
    8000451c:	8082                	ret

000000008000451e <namex>:
    8000451e:	711d                	addi	sp,sp,-96
    80004520:	ec86                	sd	ra,88(sp)
    80004522:	e8a2                	sd	s0,80(sp)
    80004524:	e4a6                	sd	s1,72(sp)
    80004526:	e0ca                	sd	s2,64(sp)
    80004528:	fc4e                	sd	s3,56(sp)
    8000452a:	f852                	sd	s4,48(sp)
    8000452c:	f456                	sd	s5,40(sp)
    8000452e:	f05a                	sd	s6,32(sp)
    80004530:	ec5e                	sd	s7,24(sp)
    80004532:	e862                	sd	s8,16(sp)
    80004534:	e466                	sd	s9,8(sp)
    80004536:	1080                	addi	s0,sp,96
    80004538:	84aa                	mv	s1,a0
    8000453a:	8aae                	mv	s5,a1
    8000453c:	8a32                	mv	s4,a2
    8000453e:	00054703          	lbu	a4,0(a0)
    80004542:	02f00793          	li	a5,47
    80004546:	02f70363          	beq	a4,a5,8000456c <namex+0x4e>
    8000454a:	ffffd097          	auipc	ra,0xffffd
    8000454e:	462080e7          	jalr	1122(ra) # 800019ac <myproc>
    80004552:	19053503          	ld	a0,400(a0)
    80004556:	00000097          	auipc	ra,0x0
    8000455a:	9f6080e7          	jalr	-1546(ra) # 80003f4c <idup>
    8000455e:	89aa                	mv	s3,a0
    80004560:	02f00913          	li	s2,47
    80004564:	4b01                	li	s6,0
    80004566:	4c35                	li	s8,13
    80004568:	4b85                	li	s7,1
    8000456a:	a865                	j	80004622 <namex+0x104>
    8000456c:	4585                	li	a1,1
    8000456e:	4505                	li	a0,1
    80004570:	fffff097          	auipc	ra,0xfffff
    80004574:	6e2080e7          	jalr	1762(ra) # 80003c52 <iget>
    80004578:	89aa                	mv	s3,a0
    8000457a:	b7dd                	j	80004560 <namex+0x42>
    8000457c:	854e                	mv	a0,s3
    8000457e:	00000097          	auipc	ra,0x0
    80004582:	c6e080e7          	jalr	-914(ra) # 800041ec <iunlockput>
    80004586:	4981                	li	s3,0
    80004588:	854e                	mv	a0,s3
    8000458a:	60e6                	ld	ra,88(sp)
    8000458c:	6446                	ld	s0,80(sp)
    8000458e:	64a6                	ld	s1,72(sp)
    80004590:	6906                	ld	s2,64(sp)
    80004592:	79e2                	ld	s3,56(sp)
    80004594:	7a42                	ld	s4,48(sp)
    80004596:	7aa2                	ld	s5,40(sp)
    80004598:	7b02                	ld	s6,32(sp)
    8000459a:	6be2                	ld	s7,24(sp)
    8000459c:	6c42                	ld	s8,16(sp)
    8000459e:	6ca2                	ld	s9,8(sp)
    800045a0:	6125                	addi	sp,sp,96
    800045a2:	8082                	ret
    800045a4:	854e                	mv	a0,s3
    800045a6:	00000097          	auipc	ra,0x0
    800045aa:	aa6080e7          	jalr	-1370(ra) # 8000404c <iunlock>
    800045ae:	bfe9                	j	80004588 <namex+0x6a>
    800045b0:	854e                	mv	a0,s3
    800045b2:	00000097          	auipc	ra,0x0
    800045b6:	c3a080e7          	jalr	-966(ra) # 800041ec <iunlockput>
    800045ba:	89e6                	mv	s3,s9
    800045bc:	b7f1                	j	80004588 <namex+0x6a>
    800045be:	40b48633          	sub	a2,s1,a1
    800045c2:	00060c9b          	sext.w	s9,a2
    800045c6:	099c5463          	bge	s8,s9,8000464e <namex+0x130>
    800045ca:	4639                	li	a2,14
    800045cc:	8552                	mv	a0,s4
    800045ce:	ffffc097          	auipc	ra,0xffffc
    800045d2:	760080e7          	jalr	1888(ra) # 80000d2e <memmove>
    800045d6:	0004c783          	lbu	a5,0(s1)
    800045da:	01279763          	bne	a5,s2,800045e8 <namex+0xca>
    800045de:	0485                	addi	s1,s1,1
    800045e0:	0004c783          	lbu	a5,0(s1)
    800045e4:	ff278de3          	beq	a5,s2,800045de <namex+0xc0>
    800045e8:	854e                	mv	a0,s3
    800045ea:	00000097          	auipc	ra,0x0
    800045ee:	9a0080e7          	jalr	-1632(ra) # 80003f8a <ilock>
    800045f2:	04499783          	lh	a5,68(s3)
    800045f6:	f97793e3          	bne	a5,s7,8000457c <namex+0x5e>
    800045fa:	000a8563          	beqz	s5,80004604 <namex+0xe6>
    800045fe:	0004c783          	lbu	a5,0(s1)
    80004602:	d3cd                	beqz	a5,800045a4 <namex+0x86>
    80004604:	865a                	mv	a2,s6
    80004606:	85d2                	mv	a1,s4
    80004608:	854e                	mv	a0,s3
    8000460a:	00000097          	auipc	ra,0x0
    8000460e:	e64080e7          	jalr	-412(ra) # 8000446e <dirlookup>
    80004612:	8caa                	mv	s9,a0
    80004614:	dd51                	beqz	a0,800045b0 <namex+0x92>
    80004616:	854e                	mv	a0,s3
    80004618:	00000097          	auipc	ra,0x0
    8000461c:	bd4080e7          	jalr	-1068(ra) # 800041ec <iunlockput>
    80004620:	89e6                	mv	s3,s9
    80004622:	0004c783          	lbu	a5,0(s1)
    80004626:	05279763          	bne	a5,s2,80004674 <namex+0x156>
    8000462a:	0485                	addi	s1,s1,1
    8000462c:	0004c783          	lbu	a5,0(s1)
    80004630:	ff278de3          	beq	a5,s2,8000462a <namex+0x10c>
    80004634:	c79d                	beqz	a5,80004662 <namex+0x144>
    80004636:	85a6                	mv	a1,s1
    80004638:	8cda                	mv	s9,s6
    8000463a:	865a                	mv	a2,s6
    8000463c:	01278963          	beq	a5,s2,8000464e <namex+0x130>
    80004640:	dfbd                	beqz	a5,800045be <namex+0xa0>
    80004642:	0485                	addi	s1,s1,1
    80004644:	0004c783          	lbu	a5,0(s1)
    80004648:	ff279ce3          	bne	a5,s2,80004640 <namex+0x122>
    8000464c:	bf8d                	j	800045be <namex+0xa0>
    8000464e:	2601                	sext.w	a2,a2
    80004650:	8552                	mv	a0,s4
    80004652:	ffffc097          	auipc	ra,0xffffc
    80004656:	6dc080e7          	jalr	1756(ra) # 80000d2e <memmove>
    8000465a:	9cd2                	add	s9,s9,s4
    8000465c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80004660:	bf9d                	j	800045d6 <namex+0xb8>
    80004662:	f20a83e3          	beqz	s5,80004588 <namex+0x6a>
    80004666:	854e                	mv	a0,s3
    80004668:	00000097          	auipc	ra,0x0
    8000466c:	adc080e7          	jalr	-1316(ra) # 80004144 <iput>
    80004670:	4981                	li	s3,0
    80004672:	bf19                	j	80004588 <namex+0x6a>
    80004674:	d7fd                	beqz	a5,80004662 <namex+0x144>
    80004676:	0004c783          	lbu	a5,0(s1)
    8000467a:	85a6                	mv	a1,s1
    8000467c:	b7d1                	j	80004640 <namex+0x122>

000000008000467e <dirlink>:
    8000467e:	7139                	addi	sp,sp,-64
    80004680:	fc06                	sd	ra,56(sp)
    80004682:	f822                	sd	s0,48(sp)
    80004684:	f426                	sd	s1,40(sp)
    80004686:	f04a                	sd	s2,32(sp)
    80004688:	ec4e                	sd	s3,24(sp)
    8000468a:	e852                	sd	s4,16(sp)
    8000468c:	0080                	addi	s0,sp,64
    8000468e:	892a                	mv	s2,a0
    80004690:	8a2e                	mv	s4,a1
    80004692:	89b2                	mv	s3,a2
    80004694:	4601                	li	a2,0
    80004696:	00000097          	auipc	ra,0x0
    8000469a:	dd8080e7          	jalr	-552(ra) # 8000446e <dirlookup>
    8000469e:	e93d                	bnez	a0,80004714 <dirlink+0x96>
    800046a0:	04c92483          	lw	s1,76(s2)
    800046a4:	c49d                	beqz	s1,800046d2 <dirlink+0x54>
    800046a6:	4481                	li	s1,0
    800046a8:	4741                	li	a4,16
    800046aa:	86a6                	mv	a3,s1
    800046ac:	fc040613          	addi	a2,s0,-64
    800046b0:	4581                	li	a1,0
    800046b2:	854a                	mv	a0,s2
    800046b4:	00000097          	auipc	ra,0x0
    800046b8:	b8a080e7          	jalr	-1142(ra) # 8000423e <readi>
    800046bc:	47c1                	li	a5,16
    800046be:	06f51163          	bne	a0,a5,80004720 <dirlink+0xa2>
    800046c2:	fc045783          	lhu	a5,-64(s0)
    800046c6:	c791                	beqz	a5,800046d2 <dirlink+0x54>
    800046c8:	24c1                	addiw	s1,s1,16
    800046ca:	04c92783          	lw	a5,76(s2)
    800046ce:	fcf4ede3          	bltu	s1,a5,800046a8 <dirlink+0x2a>
    800046d2:	4639                	li	a2,14
    800046d4:	85d2                	mv	a1,s4
    800046d6:	fc240513          	addi	a0,s0,-62
    800046da:	ffffc097          	auipc	ra,0xffffc
    800046de:	704080e7          	jalr	1796(ra) # 80000dde <strncpy>
    800046e2:	fd341023          	sh	s3,-64(s0)
    800046e6:	4741                	li	a4,16
    800046e8:	86a6                	mv	a3,s1
    800046ea:	fc040613          	addi	a2,s0,-64
    800046ee:	4581                	li	a1,0
    800046f0:	854a                	mv	a0,s2
    800046f2:	00000097          	auipc	ra,0x0
    800046f6:	c44080e7          	jalr	-956(ra) # 80004336 <writei>
    800046fa:	1541                	addi	a0,a0,-16
    800046fc:	00a03533          	snez	a0,a0
    80004700:	40a00533          	neg	a0,a0
    80004704:	70e2                	ld	ra,56(sp)
    80004706:	7442                	ld	s0,48(sp)
    80004708:	74a2                	ld	s1,40(sp)
    8000470a:	7902                	ld	s2,32(sp)
    8000470c:	69e2                	ld	s3,24(sp)
    8000470e:	6a42                	ld	s4,16(sp)
    80004710:	6121                	addi	sp,sp,64
    80004712:	8082                	ret
    80004714:	00000097          	auipc	ra,0x0
    80004718:	a30080e7          	jalr	-1488(ra) # 80004144 <iput>
    8000471c:	557d                	li	a0,-1
    8000471e:	b7dd                	j	80004704 <dirlink+0x86>
    80004720:	00004517          	auipc	a0,0x4
    80004724:	f2850513          	addi	a0,a0,-216 # 80008648 <syscalls+0x1e8>
    80004728:	ffffc097          	auipc	ra,0xffffc
    8000472c:	e16080e7          	jalr	-490(ra) # 8000053e <panic>

0000000080004730 <namei>:
    80004730:	1101                	addi	sp,sp,-32
    80004732:	ec06                	sd	ra,24(sp)
    80004734:	e822                	sd	s0,16(sp)
    80004736:	1000                	addi	s0,sp,32
    80004738:	fe040613          	addi	a2,s0,-32
    8000473c:	4581                	li	a1,0
    8000473e:	00000097          	auipc	ra,0x0
    80004742:	de0080e7          	jalr	-544(ra) # 8000451e <namex>
    80004746:	60e2                	ld	ra,24(sp)
    80004748:	6442                	ld	s0,16(sp)
    8000474a:	6105                	addi	sp,sp,32
    8000474c:	8082                	ret

000000008000474e <nameiparent>:
    8000474e:	1141                	addi	sp,sp,-16
    80004750:	e406                	sd	ra,8(sp)
    80004752:	e022                	sd	s0,0(sp)
    80004754:	0800                	addi	s0,sp,16
    80004756:	862e                	mv	a2,a1
    80004758:	4585                	li	a1,1
    8000475a:	00000097          	auipc	ra,0x0
    8000475e:	dc4080e7          	jalr	-572(ra) # 8000451e <namex>
    80004762:	60a2                	ld	ra,8(sp)
    80004764:	6402                	ld	s0,0(sp)
    80004766:	0141                	addi	sp,sp,16
    80004768:	8082                	ret

000000008000476a <write_head>:
    8000476a:	1101                	addi	sp,sp,-32
    8000476c:	ec06                	sd	ra,24(sp)
    8000476e:	e822                	sd	s0,16(sp)
    80004770:	e426                	sd	s1,8(sp)
    80004772:	e04a                	sd	s2,0(sp)
    80004774:	1000                	addi	s0,sp,32
    80004776:	0001d917          	auipc	s2,0x1d
    8000477a:	7ba90913          	addi	s2,s2,1978 # 80021f30 <log>
    8000477e:	01892583          	lw	a1,24(s2)
    80004782:	02892503          	lw	a0,40(s2)
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	fea080e7          	jalr	-22(ra) # 80003770 <bread>
    8000478e:	84aa                	mv	s1,a0
    80004790:	02c92683          	lw	a3,44(s2)
    80004794:	cd34                	sw	a3,88(a0)
    80004796:	02d05763          	blez	a3,800047c4 <write_head+0x5a>
    8000479a:	0001d797          	auipc	a5,0x1d
    8000479e:	7c678793          	addi	a5,a5,1990 # 80021f60 <log+0x30>
    800047a2:	05c50713          	addi	a4,a0,92
    800047a6:	36fd                	addiw	a3,a3,-1
    800047a8:	1682                	slli	a3,a3,0x20
    800047aa:	9281                	srli	a3,a3,0x20
    800047ac:	068a                	slli	a3,a3,0x2
    800047ae:	0001d617          	auipc	a2,0x1d
    800047b2:	7b660613          	addi	a2,a2,1974 # 80021f64 <log+0x34>
    800047b6:	96b2                	add	a3,a3,a2
    800047b8:	4390                	lw	a2,0(a5)
    800047ba:	c310                	sw	a2,0(a4)
    800047bc:	0791                	addi	a5,a5,4
    800047be:	0711                	addi	a4,a4,4
    800047c0:	fed79ce3          	bne	a5,a3,800047b8 <write_head+0x4e>
    800047c4:	8526                	mv	a0,s1
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	09c080e7          	jalr	156(ra) # 80003862 <bwrite>
    800047ce:	8526                	mv	a0,s1
    800047d0:	fffff097          	auipc	ra,0xfffff
    800047d4:	0d0080e7          	jalr	208(ra) # 800038a0 <brelse>
    800047d8:	60e2                	ld	ra,24(sp)
    800047da:	6442                	ld	s0,16(sp)
    800047dc:	64a2                	ld	s1,8(sp)
    800047de:	6902                	ld	s2,0(sp)
    800047e0:	6105                	addi	sp,sp,32
    800047e2:	8082                	ret

00000000800047e4 <install_trans>:
    800047e4:	0001d797          	auipc	a5,0x1d
    800047e8:	7787a783          	lw	a5,1912(a5) # 80021f5c <log+0x2c>
    800047ec:	0af05d63          	blez	a5,800048a6 <install_trans+0xc2>
    800047f0:	7139                	addi	sp,sp,-64
    800047f2:	fc06                	sd	ra,56(sp)
    800047f4:	f822                	sd	s0,48(sp)
    800047f6:	f426                	sd	s1,40(sp)
    800047f8:	f04a                	sd	s2,32(sp)
    800047fa:	ec4e                	sd	s3,24(sp)
    800047fc:	e852                	sd	s4,16(sp)
    800047fe:	e456                	sd	s5,8(sp)
    80004800:	e05a                	sd	s6,0(sp)
    80004802:	0080                	addi	s0,sp,64
    80004804:	8b2a                	mv	s6,a0
    80004806:	0001da97          	auipc	s5,0x1d
    8000480a:	75aa8a93          	addi	s5,s5,1882 # 80021f60 <log+0x30>
    8000480e:	4a01                	li	s4,0
    80004810:	0001d997          	auipc	s3,0x1d
    80004814:	72098993          	addi	s3,s3,1824 # 80021f30 <log>
    80004818:	a00d                	j	8000483a <install_trans+0x56>
    8000481a:	854a                	mv	a0,s2
    8000481c:	fffff097          	auipc	ra,0xfffff
    80004820:	084080e7          	jalr	132(ra) # 800038a0 <brelse>
    80004824:	8526                	mv	a0,s1
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	07a080e7          	jalr	122(ra) # 800038a0 <brelse>
    8000482e:	2a05                	addiw	s4,s4,1
    80004830:	0a91                	addi	s5,s5,4
    80004832:	02c9a783          	lw	a5,44(s3)
    80004836:	04fa5e63          	bge	s4,a5,80004892 <install_trans+0xae>
    8000483a:	0189a583          	lw	a1,24(s3)
    8000483e:	014585bb          	addw	a1,a1,s4
    80004842:	2585                	addiw	a1,a1,1
    80004844:	0289a503          	lw	a0,40(s3)
    80004848:	fffff097          	auipc	ra,0xfffff
    8000484c:	f28080e7          	jalr	-216(ra) # 80003770 <bread>
    80004850:	892a                	mv	s2,a0
    80004852:	000aa583          	lw	a1,0(s5)
    80004856:	0289a503          	lw	a0,40(s3)
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	f16080e7          	jalr	-234(ra) # 80003770 <bread>
    80004862:	84aa                	mv	s1,a0
    80004864:	40000613          	li	a2,1024
    80004868:	05890593          	addi	a1,s2,88
    8000486c:	05850513          	addi	a0,a0,88
    80004870:	ffffc097          	auipc	ra,0xffffc
    80004874:	4be080e7          	jalr	1214(ra) # 80000d2e <memmove>
    80004878:	8526                	mv	a0,s1
    8000487a:	fffff097          	auipc	ra,0xfffff
    8000487e:	fe8080e7          	jalr	-24(ra) # 80003862 <bwrite>
    80004882:	f80b1ce3          	bnez	s6,8000481a <install_trans+0x36>
    80004886:	8526                	mv	a0,s1
    80004888:	fffff097          	auipc	ra,0xfffff
    8000488c:	0f2080e7          	jalr	242(ra) # 8000397a <bunpin>
    80004890:	b769                	j	8000481a <install_trans+0x36>
    80004892:	70e2                	ld	ra,56(sp)
    80004894:	7442                	ld	s0,48(sp)
    80004896:	74a2                	ld	s1,40(sp)
    80004898:	7902                	ld	s2,32(sp)
    8000489a:	69e2                	ld	s3,24(sp)
    8000489c:	6a42                	ld	s4,16(sp)
    8000489e:	6aa2                	ld	s5,8(sp)
    800048a0:	6b02                	ld	s6,0(sp)
    800048a2:	6121                	addi	sp,sp,64
    800048a4:	8082                	ret
    800048a6:	8082                	ret

00000000800048a8 <initlog>:
    800048a8:	7179                	addi	sp,sp,-48
    800048aa:	f406                	sd	ra,40(sp)
    800048ac:	f022                	sd	s0,32(sp)
    800048ae:	ec26                	sd	s1,24(sp)
    800048b0:	e84a                	sd	s2,16(sp)
    800048b2:	e44e                	sd	s3,8(sp)
    800048b4:	1800                	addi	s0,sp,48
    800048b6:	892a                	mv	s2,a0
    800048b8:	89ae                	mv	s3,a1
    800048ba:	0001d497          	auipc	s1,0x1d
    800048be:	67648493          	addi	s1,s1,1654 # 80021f30 <log>
    800048c2:	00004597          	auipc	a1,0x4
    800048c6:	d9658593          	addi	a1,a1,-618 # 80008658 <syscalls+0x1f8>
    800048ca:	8526                	mv	a0,s1
    800048cc:	ffffc097          	auipc	ra,0xffffc
    800048d0:	27a080e7          	jalr	634(ra) # 80000b46 <initlock>
    800048d4:	0149a583          	lw	a1,20(s3)
    800048d8:	cc8c                	sw	a1,24(s1)
    800048da:	0109a783          	lw	a5,16(s3)
    800048de:	ccdc                	sw	a5,28(s1)
    800048e0:	0324a423          	sw	s2,40(s1)
    800048e4:	854a                	mv	a0,s2
    800048e6:	fffff097          	auipc	ra,0xfffff
    800048ea:	e8a080e7          	jalr	-374(ra) # 80003770 <bread>
    800048ee:	4d34                	lw	a3,88(a0)
    800048f0:	d4d4                	sw	a3,44(s1)
    800048f2:	02d05563          	blez	a3,8000491c <initlog+0x74>
    800048f6:	05c50793          	addi	a5,a0,92
    800048fa:	0001d717          	auipc	a4,0x1d
    800048fe:	66670713          	addi	a4,a4,1638 # 80021f60 <log+0x30>
    80004902:	36fd                	addiw	a3,a3,-1
    80004904:	1682                	slli	a3,a3,0x20
    80004906:	9281                	srli	a3,a3,0x20
    80004908:	068a                	slli	a3,a3,0x2
    8000490a:	06050613          	addi	a2,a0,96
    8000490e:	96b2                	add	a3,a3,a2
    80004910:	4390                	lw	a2,0(a5)
    80004912:	c310                	sw	a2,0(a4)
    80004914:	0791                	addi	a5,a5,4
    80004916:	0711                	addi	a4,a4,4
    80004918:	fed79ce3          	bne	a5,a3,80004910 <initlog+0x68>
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	f84080e7          	jalr	-124(ra) # 800038a0 <brelse>
    80004924:	4505                	li	a0,1
    80004926:	00000097          	auipc	ra,0x0
    8000492a:	ebe080e7          	jalr	-322(ra) # 800047e4 <install_trans>
    8000492e:	0001d797          	auipc	a5,0x1d
    80004932:	6207a723          	sw	zero,1582(a5) # 80021f5c <log+0x2c>
    80004936:	00000097          	auipc	ra,0x0
    8000493a:	e34080e7          	jalr	-460(ra) # 8000476a <write_head>
    8000493e:	70a2                	ld	ra,40(sp)
    80004940:	7402                	ld	s0,32(sp)
    80004942:	64e2                	ld	s1,24(sp)
    80004944:	6942                	ld	s2,16(sp)
    80004946:	69a2                	ld	s3,8(sp)
    80004948:	6145                	addi	sp,sp,48
    8000494a:	8082                	ret

000000008000494c <begin_op>:
    8000494c:	1101                	addi	sp,sp,-32
    8000494e:	ec06                	sd	ra,24(sp)
    80004950:	e822                	sd	s0,16(sp)
    80004952:	e426                	sd	s1,8(sp)
    80004954:	e04a                	sd	s2,0(sp)
    80004956:	1000                	addi	s0,sp,32
    80004958:	0001d517          	auipc	a0,0x1d
    8000495c:	5d850513          	addi	a0,a0,1496 # 80021f30 <log>
    80004960:	ffffc097          	auipc	ra,0xffffc
    80004964:	276080e7          	jalr	630(ra) # 80000bd6 <acquire>
    80004968:	0001d497          	auipc	s1,0x1d
    8000496c:	5c848493          	addi	s1,s1,1480 # 80021f30 <log>
    80004970:	4979                	li	s2,30
    80004972:	a039                	j	80004980 <begin_op+0x34>
    80004974:	85a6                	mv	a1,s1
    80004976:	8526                	mv	a0,s1
    80004978:	ffffd097          	auipc	ra,0xffffd
    8000497c:	7a6080e7          	jalr	1958(ra) # 8000211e <sleep>
    80004980:	50dc                	lw	a5,36(s1)
    80004982:	fbed                	bnez	a5,80004974 <begin_op+0x28>
    80004984:	509c                	lw	a5,32(s1)
    80004986:	0017871b          	addiw	a4,a5,1
    8000498a:	0007069b          	sext.w	a3,a4
    8000498e:	0027179b          	slliw	a5,a4,0x2
    80004992:	9fb9                	addw	a5,a5,a4
    80004994:	0017979b          	slliw	a5,a5,0x1
    80004998:	54d8                	lw	a4,44(s1)
    8000499a:	9fb9                	addw	a5,a5,a4
    8000499c:	00f95963          	bge	s2,a5,800049ae <begin_op+0x62>
    800049a0:	85a6                	mv	a1,s1
    800049a2:	8526                	mv	a0,s1
    800049a4:	ffffd097          	auipc	ra,0xffffd
    800049a8:	77a080e7          	jalr	1914(ra) # 8000211e <sleep>
    800049ac:	bfd1                	j	80004980 <begin_op+0x34>
    800049ae:	0001d517          	auipc	a0,0x1d
    800049b2:	58250513          	addi	a0,a0,1410 # 80021f30 <log>
    800049b6:	d114                	sw	a3,32(a0)
    800049b8:	ffffc097          	auipc	ra,0xffffc
    800049bc:	2d2080e7          	jalr	722(ra) # 80000c8a <release>
    800049c0:	60e2                	ld	ra,24(sp)
    800049c2:	6442                	ld	s0,16(sp)
    800049c4:	64a2                	ld	s1,8(sp)
    800049c6:	6902                	ld	s2,0(sp)
    800049c8:	6105                	addi	sp,sp,32
    800049ca:	8082                	ret

00000000800049cc <end_op>:
    800049cc:	7139                	addi	sp,sp,-64
    800049ce:	fc06                	sd	ra,56(sp)
    800049d0:	f822                	sd	s0,48(sp)
    800049d2:	f426                	sd	s1,40(sp)
    800049d4:	f04a                	sd	s2,32(sp)
    800049d6:	ec4e                	sd	s3,24(sp)
    800049d8:	e852                	sd	s4,16(sp)
    800049da:	e456                	sd	s5,8(sp)
    800049dc:	0080                	addi	s0,sp,64
    800049de:	0001d497          	auipc	s1,0x1d
    800049e2:	55248493          	addi	s1,s1,1362 # 80021f30 <log>
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffc097          	auipc	ra,0xffffc
    800049ec:	1ee080e7          	jalr	494(ra) # 80000bd6 <acquire>
    800049f0:	509c                	lw	a5,32(s1)
    800049f2:	37fd                	addiw	a5,a5,-1
    800049f4:	0007891b          	sext.w	s2,a5
    800049f8:	d09c                	sw	a5,32(s1)
    800049fa:	50dc                	lw	a5,36(s1)
    800049fc:	e7b9                	bnez	a5,80004a4a <end_op+0x7e>
    800049fe:	04091e63          	bnez	s2,80004a5a <end_op+0x8e>
    80004a02:	0001d497          	auipc	s1,0x1d
    80004a06:	52e48493          	addi	s1,s1,1326 # 80021f30 <log>
    80004a0a:	4785                	li	a5,1
    80004a0c:	d0dc                	sw	a5,36(s1)
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffc097          	auipc	ra,0xffffc
    80004a14:	27a080e7          	jalr	634(ra) # 80000c8a <release>
    80004a18:	54dc                	lw	a5,44(s1)
    80004a1a:	06f04763          	bgtz	a5,80004a88 <end_op+0xbc>
    80004a1e:	0001d497          	auipc	s1,0x1d
    80004a22:	51248493          	addi	s1,s1,1298 # 80021f30 <log>
    80004a26:	8526                	mv	a0,s1
    80004a28:	ffffc097          	auipc	ra,0xffffc
    80004a2c:	1ae080e7          	jalr	430(ra) # 80000bd6 <acquire>
    80004a30:	0204a223          	sw	zero,36(s1)
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffd097          	auipc	ra,0xffffd
    80004a3a:	74c080e7          	jalr	1868(ra) # 80002182 <wakeup>
    80004a3e:	8526                	mv	a0,s1
    80004a40:	ffffc097          	auipc	ra,0xffffc
    80004a44:	24a080e7          	jalr	586(ra) # 80000c8a <release>
    80004a48:	a03d                	j	80004a76 <end_op+0xaa>
    80004a4a:	00004517          	auipc	a0,0x4
    80004a4e:	c1650513          	addi	a0,a0,-1002 # 80008660 <syscalls+0x200>
    80004a52:	ffffc097          	auipc	ra,0xffffc
    80004a56:	aec080e7          	jalr	-1300(ra) # 8000053e <panic>
    80004a5a:	0001d497          	auipc	s1,0x1d
    80004a5e:	4d648493          	addi	s1,s1,1238 # 80021f30 <log>
    80004a62:	8526                	mv	a0,s1
    80004a64:	ffffd097          	auipc	ra,0xffffd
    80004a68:	71e080e7          	jalr	1822(ra) # 80002182 <wakeup>
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffc097          	auipc	ra,0xffffc
    80004a72:	21c080e7          	jalr	540(ra) # 80000c8a <release>
    80004a76:	70e2                	ld	ra,56(sp)
    80004a78:	7442                	ld	s0,48(sp)
    80004a7a:	74a2                	ld	s1,40(sp)
    80004a7c:	7902                	ld	s2,32(sp)
    80004a7e:	69e2                	ld	s3,24(sp)
    80004a80:	6a42                	ld	s4,16(sp)
    80004a82:	6aa2                	ld	s5,8(sp)
    80004a84:	6121                	addi	sp,sp,64
    80004a86:	8082                	ret
    80004a88:	0001da97          	auipc	s5,0x1d
    80004a8c:	4d8a8a93          	addi	s5,s5,1240 # 80021f60 <log+0x30>
    80004a90:	0001da17          	auipc	s4,0x1d
    80004a94:	4a0a0a13          	addi	s4,s4,1184 # 80021f30 <log>
    80004a98:	018a2583          	lw	a1,24(s4)
    80004a9c:	012585bb          	addw	a1,a1,s2
    80004aa0:	2585                	addiw	a1,a1,1
    80004aa2:	028a2503          	lw	a0,40(s4)
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	cca080e7          	jalr	-822(ra) # 80003770 <bread>
    80004aae:	84aa                	mv	s1,a0
    80004ab0:	000aa583          	lw	a1,0(s5)
    80004ab4:	028a2503          	lw	a0,40(s4)
    80004ab8:	fffff097          	auipc	ra,0xfffff
    80004abc:	cb8080e7          	jalr	-840(ra) # 80003770 <bread>
    80004ac0:	89aa                	mv	s3,a0
    80004ac2:	40000613          	li	a2,1024
    80004ac6:	05850593          	addi	a1,a0,88
    80004aca:	05848513          	addi	a0,s1,88
    80004ace:	ffffc097          	auipc	ra,0xffffc
    80004ad2:	260080e7          	jalr	608(ra) # 80000d2e <memmove>
    80004ad6:	8526                	mv	a0,s1
    80004ad8:	fffff097          	auipc	ra,0xfffff
    80004adc:	d8a080e7          	jalr	-630(ra) # 80003862 <bwrite>
    80004ae0:	854e                	mv	a0,s3
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	dbe080e7          	jalr	-578(ra) # 800038a0 <brelse>
    80004aea:	8526                	mv	a0,s1
    80004aec:	fffff097          	auipc	ra,0xfffff
    80004af0:	db4080e7          	jalr	-588(ra) # 800038a0 <brelse>
    80004af4:	2905                	addiw	s2,s2,1
    80004af6:	0a91                	addi	s5,s5,4
    80004af8:	02ca2783          	lw	a5,44(s4)
    80004afc:	f8f94ee3          	blt	s2,a5,80004a98 <end_op+0xcc>
    80004b00:	00000097          	auipc	ra,0x0
    80004b04:	c6a080e7          	jalr	-918(ra) # 8000476a <write_head>
    80004b08:	4501                	li	a0,0
    80004b0a:	00000097          	auipc	ra,0x0
    80004b0e:	cda080e7          	jalr	-806(ra) # 800047e4 <install_trans>
    80004b12:	0001d797          	auipc	a5,0x1d
    80004b16:	4407a523          	sw	zero,1098(a5) # 80021f5c <log+0x2c>
    80004b1a:	00000097          	auipc	ra,0x0
    80004b1e:	c50080e7          	jalr	-944(ra) # 8000476a <write_head>
    80004b22:	bdf5                	j	80004a1e <end_op+0x52>

0000000080004b24 <log_write>:
    80004b24:	1101                	addi	sp,sp,-32
    80004b26:	ec06                	sd	ra,24(sp)
    80004b28:	e822                	sd	s0,16(sp)
    80004b2a:	e426                	sd	s1,8(sp)
    80004b2c:	e04a                	sd	s2,0(sp)
    80004b2e:	1000                	addi	s0,sp,32
    80004b30:	84aa                	mv	s1,a0
    80004b32:	0001d917          	auipc	s2,0x1d
    80004b36:	3fe90913          	addi	s2,s2,1022 # 80021f30 <log>
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	ffffc097          	auipc	ra,0xffffc
    80004b40:	09a080e7          	jalr	154(ra) # 80000bd6 <acquire>
    80004b44:	02c92603          	lw	a2,44(s2)
    80004b48:	47f5                	li	a5,29
    80004b4a:	06c7c563          	blt	a5,a2,80004bb4 <log_write+0x90>
    80004b4e:	0001d797          	auipc	a5,0x1d
    80004b52:	3fe7a783          	lw	a5,1022(a5) # 80021f4c <log+0x1c>
    80004b56:	37fd                	addiw	a5,a5,-1
    80004b58:	04f65e63          	bge	a2,a5,80004bb4 <log_write+0x90>
    80004b5c:	0001d797          	auipc	a5,0x1d
    80004b60:	3f47a783          	lw	a5,1012(a5) # 80021f50 <log+0x20>
    80004b64:	06f05063          	blez	a5,80004bc4 <log_write+0xa0>
    80004b68:	4781                	li	a5,0
    80004b6a:	06c05563          	blez	a2,80004bd4 <log_write+0xb0>
    80004b6e:	44cc                	lw	a1,12(s1)
    80004b70:	0001d717          	auipc	a4,0x1d
    80004b74:	3f070713          	addi	a4,a4,1008 # 80021f60 <log+0x30>
    80004b78:	4781                	li	a5,0
    80004b7a:	4314                	lw	a3,0(a4)
    80004b7c:	04b68c63          	beq	a3,a1,80004bd4 <log_write+0xb0>
    80004b80:	2785                	addiw	a5,a5,1
    80004b82:	0711                	addi	a4,a4,4
    80004b84:	fef61be3          	bne	a2,a5,80004b7a <log_write+0x56>
    80004b88:	0621                	addi	a2,a2,8
    80004b8a:	060a                	slli	a2,a2,0x2
    80004b8c:	0001d797          	auipc	a5,0x1d
    80004b90:	3a478793          	addi	a5,a5,932 # 80021f30 <log>
    80004b94:	963e                	add	a2,a2,a5
    80004b96:	44dc                	lw	a5,12(s1)
    80004b98:	ca1c                	sw	a5,16(a2)
    80004b9a:	8526                	mv	a0,s1
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	da2080e7          	jalr	-606(ra) # 8000393e <bpin>
    80004ba4:	0001d717          	auipc	a4,0x1d
    80004ba8:	38c70713          	addi	a4,a4,908 # 80021f30 <log>
    80004bac:	575c                	lw	a5,44(a4)
    80004bae:	2785                	addiw	a5,a5,1
    80004bb0:	d75c                	sw	a5,44(a4)
    80004bb2:	a835                	j	80004bee <log_write+0xca>
    80004bb4:	00004517          	auipc	a0,0x4
    80004bb8:	abc50513          	addi	a0,a0,-1348 # 80008670 <syscalls+0x210>
    80004bbc:	ffffc097          	auipc	ra,0xffffc
    80004bc0:	982080e7          	jalr	-1662(ra) # 8000053e <panic>
    80004bc4:	00004517          	auipc	a0,0x4
    80004bc8:	ac450513          	addi	a0,a0,-1340 # 80008688 <syscalls+0x228>
    80004bcc:	ffffc097          	auipc	ra,0xffffc
    80004bd0:	972080e7          	jalr	-1678(ra) # 8000053e <panic>
    80004bd4:	00878713          	addi	a4,a5,8
    80004bd8:	00271693          	slli	a3,a4,0x2
    80004bdc:	0001d717          	auipc	a4,0x1d
    80004be0:	35470713          	addi	a4,a4,852 # 80021f30 <log>
    80004be4:	9736                	add	a4,a4,a3
    80004be6:	44d4                	lw	a3,12(s1)
    80004be8:	cb14                	sw	a3,16(a4)
    80004bea:	faf608e3          	beq	a2,a5,80004b9a <log_write+0x76>
    80004bee:	0001d517          	auipc	a0,0x1d
    80004bf2:	34250513          	addi	a0,a0,834 # 80021f30 <log>
    80004bf6:	ffffc097          	auipc	ra,0xffffc
    80004bfa:	094080e7          	jalr	148(ra) # 80000c8a <release>
    80004bfe:	60e2                	ld	ra,24(sp)
    80004c00:	6442                	ld	s0,16(sp)
    80004c02:	64a2                	ld	s1,8(sp)
    80004c04:	6902                	ld	s2,0(sp)
    80004c06:	6105                	addi	sp,sp,32
    80004c08:	8082                	ret

0000000080004c0a <initsleeplock>:
    80004c0a:	1101                	addi	sp,sp,-32
    80004c0c:	ec06                	sd	ra,24(sp)
    80004c0e:	e822                	sd	s0,16(sp)
    80004c10:	e426                	sd	s1,8(sp)
    80004c12:	e04a                	sd	s2,0(sp)
    80004c14:	1000                	addi	s0,sp,32
    80004c16:	84aa                	mv	s1,a0
    80004c18:	892e                	mv	s2,a1
    80004c1a:	00004597          	auipc	a1,0x4
    80004c1e:	a8e58593          	addi	a1,a1,-1394 # 800086a8 <syscalls+0x248>
    80004c22:	0521                	addi	a0,a0,8
    80004c24:	ffffc097          	auipc	ra,0xffffc
    80004c28:	f22080e7          	jalr	-222(ra) # 80000b46 <initlock>
    80004c2c:	0324b023          	sd	s2,32(s1)
    80004c30:	0004a023          	sw	zero,0(s1)
    80004c34:	0204a423          	sw	zero,40(s1)
    80004c38:	60e2                	ld	ra,24(sp)
    80004c3a:	6442                	ld	s0,16(sp)
    80004c3c:	64a2                	ld	s1,8(sp)
    80004c3e:	6902                	ld	s2,0(sp)
    80004c40:	6105                	addi	sp,sp,32
    80004c42:	8082                	ret

0000000080004c44 <acquiresleep>:
    80004c44:	1101                	addi	sp,sp,-32
    80004c46:	ec06                	sd	ra,24(sp)
    80004c48:	e822                	sd	s0,16(sp)
    80004c4a:	e426                	sd	s1,8(sp)
    80004c4c:	e04a                	sd	s2,0(sp)
    80004c4e:	1000                	addi	s0,sp,32
    80004c50:	84aa                	mv	s1,a0
    80004c52:	00850913          	addi	s2,a0,8
    80004c56:	854a                	mv	a0,s2
    80004c58:	ffffc097          	auipc	ra,0xffffc
    80004c5c:	f7e080e7          	jalr	-130(ra) # 80000bd6 <acquire>
    80004c60:	409c                	lw	a5,0(s1)
    80004c62:	cb89                	beqz	a5,80004c74 <acquiresleep+0x30>
    80004c64:	85ca                	mv	a1,s2
    80004c66:	8526                	mv	a0,s1
    80004c68:	ffffd097          	auipc	ra,0xffffd
    80004c6c:	4b6080e7          	jalr	1206(ra) # 8000211e <sleep>
    80004c70:	409c                	lw	a5,0(s1)
    80004c72:	fbed                	bnez	a5,80004c64 <acquiresleep+0x20>
    80004c74:	4785                	li	a5,1
    80004c76:	c09c                	sw	a5,0(s1)
    80004c78:	ffffd097          	auipc	ra,0xffffd
    80004c7c:	d34080e7          	jalr	-716(ra) # 800019ac <myproc>
    80004c80:	591c                	lw	a5,48(a0)
    80004c82:	d49c                	sw	a5,40(s1)
    80004c84:	854a                	mv	a0,s2
    80004c86:	ffffc097          	auipc	ra,0xffffc
    80004c8a:	004080e7          	jalr	4(ra) # 80000c8a <release>
    80004c8e:	60e2                	ld	ra,24(sp)
    80004c90:	6442                	ld	s0,16(sp)
    80004c92:	64a2                	ld	s1,8(sp)
    80004c94:	6902                	ld	s2,0(sp)
    80004c96:	6105                	addi	sp,sp,32
    80004c98:	8082                	ret

0000000080004c9a <releasesleep>:
    80004c9a:	1101                	addi	sp,sp,-32
    80004c9c:	ec06                	sd	ra,24(sp)
    80004c9e:	e822                	sd	s0,16(sp)
    80004ca0:	e426                	sd	s1,8(sp)
    80004ca2:	e04a                	sd	s2,0(sp)
    80004ca4:	1000                	addi	s0,sp,32
    80004ca6:	84aa                	mv	s1,a0
    80004ca8:	00850913          	addi	s2,a0,8
    80004cac:	854a                	mv	a0,s2
    80004cae:	ffffc097          	auipc	ra,0xffffc
    80004cb2:	f28080e7          	jalr	-216(ra) # 80000bd6 <acquire>
    80004cb6:	0004a023          	sw	zero,0(s1)
    80004cba:	0204a423          	sw	zero,40(s1)
    80004cbe:	8526                	mv	a0,s1
    80004cc0:	ffffd097          	auipc	ra,0xffffd
    80004cc4:	4c2080e7          	jalr	1218(ra) # 80002182 <wakeup>
    80004cc8:	854a                	mv	a0,s2
    80004cca:	ffffc097          	auipc	ra,0xffffc
    80004cce:	fc0080e7          	jalr	-64(ra) # 80000c8a <release>
    80004cd2:	60e2                	ld	ra,24(sp)
    80004cd4:	6442                	ld	s0,16(sp)
    80004cd6:	64a2                	ld	s1,8(sp)
    80004cd8:	6902                	ld	s2,0(sp)
    80004cda:	6105                	addi	sp,sp,32
    80004cdc:	8082                	ret

0000000080004cde <holdingsleep>:
    80004cde:	7179                	addi	sp,sp,-48
    80004ce0:	f406                	sd	ra,40(sp)
    80004ce2:	f022                	sd	s0,32(sp)
    80004ce4:	ec26                	sd	s1,24(sp)
    80004ce6:	e84a                	sd	s2,16(sp)
    80004ce8:	e44e                	sd	s3,8(sp)
    80004cea:	1800                	addi	s0,sp,48
    80004cec:	84aa                	mv	s1,a0
    80004cee:	00850913          	addi	s2,a0,8
    80004cf2:	854a                	mv	a0,s2
    80004cf4:	ffffc097          	auipc	ra,0xffffc
    80004cf8:	ee2080e7          	jalr	-286(ra) # 80000bd6 <acquire>
    80004cfc:	409c                	lw	a5,0(s1)
    80004cfe:	ef99                	bnez	a5,80004d1c <holdingsleep+0x3e>
    80004d00:	4481                	li	s1,0
    80004d02:	854a                	mv	a0,s2
    80004d04:	ffffc097          	auipc	ra,0xffffc
    80004d08:	f86080e7          	jalr	-122(ra) # 80000c8a <release>
    80004d0c:	8526                	mv	a0,s1
    80004d0e:	70a2                	ld	ra,40(sp)
    80004d10:	7402                	ld	s0,32(sp)
    80004d12:	64e2                	ld	s1,24(sp)
    80004d14:	6942                	ld	s2,16(sp)
    80004d16:	69a2                	ld	s3,8(sp)
    80004d18:	6145                	addi	sp,sp,48
    80004d1a:	8082                	ret
    80004d1c:	0284a983          	lw	s3,40(s1)
    80004d20:	ffffd097          	auipc	ra,0xffffd
    80004d24:	c8c080e7          	jalr	-884(ra) # 800019ac <myproc>
    80004d28:	5904                	lw	s1,48(a0)
    80004d2a:	413484b3          	sub	s1,s1,s3
    80004d2e:	0014b493          	seqz	s1,s1
    80004d32:	bfc1                	j	80004d02 <holdingsleep+0x24>

0000000080004d34 <fileinit>:
    80004d34:	1141                	addi	sp,sp,-16
    80004d36:	e406                	sd	ra,8(sp)
    80004d38:	e022                	sd	s0,0(sp)
    80004d3a:	0800                	addi	s0,sp,16
    80004d3c:	00004597          	auipc	a1,0x4
    80004d40:	97c58593          	addi	a1,a1,-1668 # 800086b8 <syscalls+0x258>
    80004d44:	0001d517          	auipc	a0,0x1d
    80004d48:	33450513          	addi	a0,a0,820 # 80022078 <ftable>
    80004d4c:	ffffc097          	auipc	ra,0xffffc
    80004d50:	dfa080e7          	jalr	-518(ra) # 80000b46 <initlock>
    80004d54:	60a2                	ld	ra,8(sp)
    80004d56:	6402                	ld	s0,0(sp)
    80004d58:	0141                	addi	sp,sp,16
    80004d5a:	8082                	ret

0000000080004d5c <filealloc>:
    80004d5c:	1101                	addi	sp,sp,-32
    80004d5e:	ec06                	sd	ra,24(sp)
    80004d60:	e822                	sd	s0,16(sp)
    80004d62:	e426                	sd	s1,8(sp)
    80004d64:	1000                	addi	s0,sp,32
    80004d66:	0001d517          	auipc	a0,0x1d
    80004d6a:	31250513          	addi	a0,a0,786 # 80022078 <ftable>
    80004d6e:	ffffc097          	auipc	ra,0xffffc
    80004d72:	e68080e7          	jalr	-408(ra) # 80000bd6 <acquire>
    80004d76:	0001d497          	auipc	s1,0x1d
    80004d7a:	31a48493          	addi	s1,s1,794 # 80022090 <ftable+0x18>
    80004d7e:	0001e717          	auipc	a4,0x1e
    80004d82:	2b270713          	addi	a4,a4,690 # 80023030 <disk>
    80004d86:	40dc                	lw	a5,4(s1)
    80004d88:	cf99                	beqz	a5,80004da6 <filealloc+0x4a>
    80004d8a:	02848493          	addi	s1,s1,40
    80004d8e:	fee49ce3          	bne	s1,a4,80004d86 <filealloc+0x2a>
    80004d92:	0001d517          	auipc	a0,0x1d
    80004d96:	2e650513          	addi	a0,a0,742 # 80022078 <ftable>
    80004d9a:	ffffc097          	auipc	ra,0xffffc
    80004d9e:	ef0080e7          	jalr	-272(ra) # 80000c8a <release>
    80004da2:	4481                	li	s1,0
    80004da4:	a819                	j	80004dba <filealloc+0x5e>
    80004da6:	4785                	li	a5,1
    80004da8:	c0dc                	sw	a5,4(s1)
    80004daa:	0001d517          	auipc	a0,0x1d
    80004dae:	2ce50513          	addi	a0,a0,718 # 80022078 <ftable>
    80004db2:	ffffc097          	auipc	ra,0xffffc
    80004db6:	ed8080e7          	jalr	-296(ra) # 80000c8a <release>
    80004dba:	8526                	mv	a0,s1
    80004dbc:	60e2                	ld	ra,24(sp)
    80004dbe:	6442                	ld	s0,16(sp)
    80004dc0:	64a2                	ld	s1,8(sp)
    80004dc2:	6105                	addi	sp,sp,32
    80004dc4:	8082                	ret

0000000080004dc6 <filedup>:
    80004dc6:	1101                	addi	sp,sp,-32
    80004dc8:	ec06                	sd	ra,24(sp)
    80004dca:	e822                	sd	s0,16(sp)
    80004dcc:	e426                	sd	s1,8(sp)
    80004dce:	1000                	addi	s0,sp,32
    80004dd0:	84aa                	mv	s1,a0
    80004dd2:	0001d517          	auipc	a0,0x1d
    80004dd6:	2a650513          	addi	a0,a0,678 # 80022078 <ftable>
    80004dda:	ffffc097          	auipc	ra,0xffffc
    80004dde:	dfc080e7          	jalr	-516(ra) # 80000bd6 <acquire>
    80004de2:	40dc                	lw	a5,4(s1)
    80004de4:	02f05263          	blez	a5,80004e08 <filedup+0x42>
    80004de8:	2785                	addiw	a5,a5,1
    80004dea:	c0dc                	sw	a5,4(s1)
    80004dec:	0001d517          	auipc	a0,0x1d
    80004df0:	28c50513          	addi	a0,a0,652 # 80022078 <ftable>
    80004df4:	ffffc097          	auipc	ra,0xffffc
    80004df8:	e96080e7          	jalr	-362(ra) # 80000c8a <release>
    80004dfc:	8526                	mv	a0,s1
    80004dfe:	60e2                	ld	ra,24(sp)
    80004e00:	6442                	ld	s0,16(sp)
    80004e02:	64a2                	ld	s1,8(sp)
    80004e04:	6105                	addi	sp,sp,32
    80004e06:	8082                	ret
    80004e08:	00004517          	auipc	a0,0x4
    80004e0c:	8b850513          	addi	a0,a0,-1864 # 800086c0 <syscalls+0x260>
    80004e10:	ffffb097          	auipc	ra,0xffffb
    80004e14:	72e080e7          	jalr	1838(ra) # 8000053e <panic>

0000000080004e18 <fileclose>:
    80004e18:	7139                	addi	sp,sp,-64
    80004e1a:	fc06                	sd	ra,56(sp)
    80004e1c:	f822                	sd	s0,48(sp)
    80004e1e:	f426                	sd	s1,40(sp)
    80004e20:	f04a                	sd	s2,32(sp)
    80004e22:	ec4e                	sd	s3,24(sp)
    80004e24:	e852                	sd	s4,16(sp)
    80004e26:	e456                	sd	s5,8(sp)
    80004e28:	0080                	addi	s0,sp,64
    80004e2a:	84aa                	mv	s1,a0
    80004e2c:	0001d517          	auipc	a0,0x1d
    80004e30:	24c50513          	addi	a0,a0,588 # 80022078 <ftable>
    80004e34:	ffffc097          	auipc	ra,0xffffc
    80004e38:	da2080e7          	jalr	-606(ra) # 80000bd6 <acquire>
    80004e3c:	40dc                	lw	a5,4(s1)
    80004e3e:	06f05163          	blez	a5,80004ea0 <fileclose+0x88>
    80004e42:	37fd                	addiw	a5,a5,-1
    80004e44:	0007871b          	sext.w	a4,a5
    80004e48:	c0dc                	sw	a5,4(s1)
    80004e4a:	06e04363          	bgtz	a4,80004eb0 <fileclose+0x98>
    80004e4e:	0004a903          	lw	s2,0(s1)
    80004e52:	0094ca83          	lbu	s5,9(s1)
    80004e56:	0104ba03          	ld	s4,16(s1)
    80004e5a:	0184b983          	ld	s3,24(s1)
    80004e5e:	0004a223          	sw	zero,4(s1)
    80004e62:	0004a023          	sw	zero,0(s1)
    80004e66:	0001d517          	auipc	a0,0x1d
    80004e6a:	21250513          	addi	a0,a0,530 # 80022078 <ftable>
    80004e6e:	ffffc097          	auipc	ra,0xffffc
    80004e72:	e1c080e7          	jalr	-484(ra) # 80000c8a <release>
    80004e76:	4785                	li	a5,1
    80004e78:	04f90d63          	beq	s2,a5,80004ed2 <fileclose+0xba>
    80004e7c:	3979                	addiw	s2,s2,-2
    80004e7e:	4785                	li	a5,1
    80004e80:	0527e063          	bltu	a5,s2,80004ec0 <fileclose+0xa8>
    80004e84:	00000097          	auipc	ra,0x0
    80004e88:	ac8080e7          	jalr	-1336(ra) # 8000494c <begin_op>
    80004e8c:	854e                	mv	a0,s3
    80004e8e:	fffff097          	auipc	ra,0xfffff
    80004e92:	2b6080e7          	jalr	694(ra) # 80004144 <iput>
    80004e96:	00000097          	auipc	ra,0x0
    80004e9a:	b36080e7          	jalr	-1226(ra) # 800049cc <end_op>
    80004e9e:	a00d                	j	80004ec0 <fileclose+0xa8>
    80004ea0:	00004517          	auipc	a0,0x4
    80004ea4:	82850513          	addi	a0,a0,-2008 # 800086c8 <syscalls+0x268>
    80004ea8:	ffffb097          	auipc	ra,0xffffb
    80004eac:	696080e7          	jalr	1686(ra) # 8000053e <panic>
    80004eb0:	0001d517          	auipc	a0,0x1d
    80004eb4:	1c850513          	addi	a0,a0,456 # 80022078 <ftable>
    80004eb8:	ffffc097          	auipc	ra,0xffffc
    80004ebc:	dd2080e7          	jalr	-558(ra) # 80000c8a <release>
    80004ec0:	70e2                	ld	ra,56(sp)
    80004ec2:	7442                	ld	s0,48(sp)
    80004ec4:	74a2                	ld	s1,40(sp)
    80004ec6:	7902                	ld	s2,32(sp)
    80004ec8:	69e2                	ld	s3,24(sp)
    80004eca:	6a42                	ld	s4,16(sp)
    80004ecc:	6aa2                	ld	s5,8(sp)
    80004ece:	6121                	addi	sp,sp,64
    80004ed0:	8082                	ret
    80004ed2:	85d6                	mv	a1,s5
    80004ed4:	8552                	mv	a0,s4
    80004ed6:	00000097          	auipc	ra,0x0
    80004eda:	34c080e7          	jalr	844(ra) # 80005222 <pipeclose>
    80004ede:	b7cd                	j	80004ec0 <fileclose+0xa8>

0000000080004ee0 <filestat>:
    80004ee0:	715d                	addi	sp,sp,-80
    80004ee2:	e486                	sd	ra,72(sp)
    80004ee4:	e0a2                	sd	s0,64(sp)
    80004ee6:	fc26                	sd	s1,56(sp)
    80004ee8:	f84a                	sd	s2,48(sp)
    80004eea:	f44e                	sd	s3,40(sp)
    80004eec:	0880                	addi	s0,sp,80
    80004eee:	84aa                	mv	s1,a0
    80004ef0:	89ae                	mv	s3,a1
    80004ef2:	ffffd097          	auipc	ra,0xffffd
    80004ef6:	aba080e7          	jalr	-1350(ra) # 800019ac <myproc>
    80004efa:	409c                	lw	a5,0(s1)
    80004efc:	37f9                	addiw	a5,a5,-2
    80004efe:	4705                	li	a4,1
    80004f00:	04f76763          	bltu	a4,a5,80004f4e <filestat+0x6e>
    80004f04:	892a                	mv	s2,a0
    80004f06:	6c88                	ld	a0,24(s1)
    80004f08:	fffff097          	auipc	ra,0xfffff
    80004f0c:	082080e7          	jalr	130(ra) # 80003f8a <ilock>
    80004f10:	fb840593          	addi	a1,s0,-72
    80004f14:	6c88                	ld	a0,24(s1)
    80004f16:	fffff097          	auipc	ra,0xfffff
    80004f1a:	2fe080e7          	jalr	766(ra) # 80004214 <stati>
    80004f1e:	6c88                	ld	a0,24(s1)
    80004f20:	fffff097          	auipc	ra,0xfffff
    80004f24:	12c080e7          	jalr	300(ra) # 8000404c <iunlock>
    80004f28:	46e1                	li	a3,24
    80004f2a:	fb840613          	addi	a2,s0,-72
    80004f2e:	85ce                	mv	a1,s3
    80004f30:	09093503          	ld	a0,144(s2)
    80004f34:	ffffc097          	auipc	ra,0xffffc
    80004f38:	734080e7          	jalr	1844(ra) # 80001668 <copyout>
    80004f3c:	41f5551b          	sraiw	a0,a0,0x1f
    80004f40:	60a6                	ld	ra,72(sp)
    80004f42:	6406                	ld	s0,64(sp)
    80004f44:	74e2                	ld	s1,56(sp)
    80004f46:	7942                	ld	s2,48(sp)
    80004f48:	79a2                	ld	s3,40(sp)
    80004f4a:	6161                	addi	sp,sp,80
    80004f4c:	8082                	ret
    80004f4e:	557d                	li	a0,-1
    80004f50:	bfc5                	j	80004f40 <filestat+0x60>

0000000080004f52 <fileread>:
    80004f52:	7179                	addi	sp,sp,-48
    80004f54:	f406                	sd	ra,40(sp)
    80004f56:	f022                	sd	s0,32(sp)
    80004f58:	ec26                	sd	s1,24(sp)
    80004f5a:	e84a                	sd	s2,16(sp)
    80004f5c:	e44e                	sd	s3,8(sp)
    80004f5e:	1800                	addi	s0,sp,48
    80004f60:	00854783          	lbu	a5,8(a0)
    80004f64:	c3d5                	beqz	a5,80005008 <fileread+0xb6>
    80004f66:	84aa                	mv	s1,a0
    80004f68:	89ae                	mv	s3,a1
    80004f6a:	8932                	mv	s2,a2
    80004f6c:	411c                	lw	a5,0(a0)
    80004f6e:	4705                	li	a4,1
    80004f70:	04e78963          	beq	a5,a4,80004fc2 <fileread+0x70>
    80004f74:	470d                	li	a4,3
    80004f76:	04e78d63          	beq	a5,a4,80004fd0 <fileread+0x7e>
    80004f7a:	4709                	li	a4,2
    80004f7c:	06e79e63          	bne	a5,a4,80004ff8 <fileread+0xa6>
    80004f80:	6d08                	ld	a0,24(a0)
    80004f82:	fffff097          	auipc	ra,0xfffff
    80004f86:	008080e7          	jalr	8(ra) # 80003f8a <ilock>
    80004f8a:	874a                	mv	a4,s2
    80004f8c:	5094                	lw	a3,32(s1)
    80004f8e:	864e                	mv	a2,s3
    80004f90:	4585                	li	a1,1
    80004f92:	6c88                	ld	a0,24(s1)
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	2aa080e7          	jalr	682(ra) # 8000423e <readi>
    80004f9c:	892a                	mv	s2,a0
    80004f9e:	00a05563          	blez	a0,80004fa8 <fileread+0x56>
    80004fa2:	509c                	lw	a5,32(s1)
    80004fa4:	9fa9                	addw	a5,a5,a0
    80004fa6:	d09c                	sw	a5,32(s1)
    80004fa8:	6c88                	ld	a0,24(s1)
    80004faa:	fffff097          	auipc	ra,0xfffff
    80004fae:	0a2080e7          	jalr	162(ra) # 8000404c <iunlock>
    80004fb2:	854a                	mv	a0,s2
    80004fb4:	70a2                	ld	ra,40(sp)
    80004fb6:	7402                	ld	s0,32(sp)
    80004fb8:	64e2                	ld	s1,24(sp)
    80004fba:	6942                	ld	s2,16(sp)
    80004fbc:	69a2                	ld	s3,8(sp)
    80004fbe:	6145                	addi	sp,sp,48
    80004fc0:	8082                	ret
    80004fc2:	6908                	ld	a0,16(a0)
    80004fc4:	00000097          	auipc	ra,0x0
    80004fc8:	3c6080e7          	jalr	966(ra) # 8000538a <piperead>
    80004fcc:	892a                	mv	s2,a0
    80004fce:	b7d5                	j	80004fb2 <fileread+0x60>
    80004fd0:	02451783          	lh	a5,36(a0)
    80004fd4:	03079693          	slli	a3,a5,0x30
    80004fd8:	92c1                	srli	a3,a3,0x30
    80004fda:	4725                	li	a4,9
    80004fdc:	02d76863          	bltu	a4,a3,8000500c <fileread+0xba>
    80004fe0:	0792                	slli	a5,a5,0x4
    80004fe2:	0001d717          	auipc	a4,0x1d
    80004fe6:	ff670713          	addi	a4,a4,-10 # 80021fd8 <devsw>
    80004fea:	97ba                	add	a5,a5,a4
    80004fec:	639c                	ld	a5,0(a5)
    80004fee:	c38d                	beqz	a5,80005010 <fileread+0xbe>
    80004ff0:	4505                	li	a0,1
    80004ff2:	9782                	jalr	a5
    80004ff4:	892a                	mv	s2,a0
    80004ff6:	bf75                	j	80004fb2 <fileread+0x60>
    80004ff8:	00003517          	auipc	a0,0x3
    80004ffc:	6e050513          	addi	a0,a0,1760 # 800086d8 <syscalls+0x278>
    80005000:	ffffb097          	auipc	ra,0xffffb
    80005004:	53e080e7          	jalr	1342(ra) # 8000053e <panic>
    80005008:	597d                	li	s2,-1
    8000500a:	b765                	j	80004fb2 <fileread+0x60>
    8000500c:	597d                	li	s2,-1
    8000500e:	b755                	j	80004fb2 <fileread+0x60>
    80005010:	597d                	li	s2,-1
    80005012:	b745                	j	80004fb2 <fileread+0x60>

0000000080005014 <filewrite>:
    80005014:	715d                	addi	sp,sp,-80
    80005016:	e486                	sd	ra,72(sp)
    80005018:	e0a2                	sd	s0,64(sp)
    8000501a:	fc26                	sd	s1,56(sp)
    8000501c:	f84a                	sd	s2,48(sp)
    8000501e:	f44e                	sd	s3,40(sp)
    80005020:	f052                	sd	s4,32(sp)
    80005022:	ec56                	sd	s5,24(sp)
    80005024:	e85a                	sd	s6,16(sp)
    80005026:	e45e                	sd	s7,8(sp)
    80005028:	e062                	sd	s8,0(sp)
    8000502a:	0880                	addi	s0,sp,80
    8000502c:	00954783          	lbu	a5,9(a0)
    80005030:	10078663          	beqz	a5,8000513c <filewrite+0x128>
    80005034:	892a                	mv	s2,a0
    80005036:	8aae                	mv	s5,a1
    80005038:	8a32                	mv	s4,a2
    8000503a:	411c                	lw	a5,0(a0)
    8000503c:	4705                	li	a4,1
    8000503e:	02e78263          	beq	a5,a4,80005062 <filewrite+0x4e>
    80005042:	470d                	li	a4,3
    80005044:	02e78663          	beq	a5,a4,80005070 <filewrite+0x5c>
    80005048:	4709                	li	a4,2
    8000504a:	0ee79163          	bne	a5,a4,8000512c <filewrite+0x118>
    8000504e:	0ac05d63          	blez	a2,80005108 <filewrite+0xf4>
    80005052:	4981                	li	s3,0
    80005054:	6b05                	lui	s6,0x1
    80005056:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    8000505a:	6b85                	lui	s7,0x1
    8000505c:	c00b8b9b          	addiw	s7,s7,-1024
    80005060:	a861                	j	800050f8 <filewrite+0xe4>
    80005062:	6908                	ld	a0,16(a0)
    80005064:	00000097          	auipc	ra,0x0
    80005068:	22e080e7          	jalr	558(ra) # 80005292 <pipewrite>
    8000506c:	8a2a                	mv	s4,a0
    8000506e:	a045                	j	8000510e <filewrite+0xfa>
    80005070:	02451783          	lh	a5,36(a0)
    80005074:	03079693          	slli	a3,a5,0x30
    80005078:	92c1                	srli	a3,a3,0x30
    8000507a:	4725                	li	a4,9
    8000507c:	0cd76263          	bltu	a4,a3,80005140 <filewrite+0x12c>
    80005080:	0792                	slli	a5,a5,0x4
    80005082:	0001d717          	auipc	a4,0x1d
    80005086:	f5670713          	addi	a4,a4,-170 # 80021fd8 <devsw>
    8000508a:	97ba                	add	a5,a5,a4
    8000508c:	679c                	ld	a5,8(a5)
    8000508e:	cbdd                	beqz	a5,80005144 <filewrite+0x130>
    80005090:	4505                	li	a0,1
    80005092:	9782                	jalr	a5
    80005094:	8a2a                	mv	s4,a0
    80005096:	a8a5                	j	8000510e <filewrite+0xfa>
    80005098:	00048c1b          	sext.w	s8,s1
    8000509c:	00000097          	auipc	ra,0x0
    800050a0:	8b0080e7          	jalr	-1872(ra) # 8000494c <begin_op>
    800050a4:	01893503          	ld	a0,24(s2)
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	ee2080e7          	jalr	-286(ra) # 80003f8a <ilock>
    800050b0:	8762                	mv	a4,s8
    800050b2:	02092683          	lw	a3,32(s2)
    800050b6:	01598633          	add	a2,s3,s5
    800050ba:	4585                	li	a1,1
    800050bc:	01893503          	ld	a0,24(s2)
    800050c0:	fffff097          	auipc	ra,0xfffff
    800050c4:	276080e7          	jalr	630(ra) # 80004336 <writei>
    800050c8:	84aa                	mv	s1,a0
    800050ca:	00a05763          	blez	a0,800050d8 <filewrite+0xc4>
    800050ce:	02092783          	lw	a5,32(s2)
    800050d2:	9fa9                	addw	a5,a5,a0
    800050d4:	02f92023          	sw	a5,32(s2)
    800050d8:	01893503          	ld	a0,24(s2)
    800050dc:	fffff097          	auipc	ra,0xfffff
    800050e0:	f70080e7          	jalr	-144(ra) # 8000404c <iunlock>
    800050e4:	00000097          	auipc	ra,0x0
    800050e8:	8e8080e7          	jalr	-1816(ra) # 800049cc <end_op>
    800050ec:	009c1f63          	bne	s8,s1,8000510a <filewrite+0xf6>
    800050f0:	013489bb          	addw	s3,s1,s3
    800050f4:	0149db63          	bge	s3,s4,8000510a <filewrite+0xf6>
    800050f8:	413a07bb          	subw	a5,s4,s3
    800050fc:	84be                	mv	s1,a5
    800050fe:	2781                	sext.w	a5,a5
    80005100:	f8fb5ce3          	bge	s6,a5,80005098 <filewrite+0x84>
    80005104:	84de                	mv	s1,s7
    80005106:	bf49                	j	80005098 <filewrite+0x84>
    80005108:	4981                	li	s3,0
    8000510a:	013a1f63          	bne	s4,s3,80005128 <filewrite+0x114>
    8000510e:	8552                	mv	a0,s4
    80005110:	60a6                	ld	ra,72(sp)
    80005112:	6406                	ld	s0,64(sp)
    80005114:	74e2                	ld	s1,56(sp)
    80005116:	7942                	ld	s2,48(sp)
    80005118:	79a2                	ld	s3,40(sp)
    8000511a:	7a02                	ld	s4,32(sp)
    8000511c:	6ae2                	ld	s5,24(sp)
    8000511e:	6b42                	ld	s6,16(sp)
    80005120:	6ba2                	ld	s7,8(sp)
    80005122:	6c02                	ld	s8,0(sp)
    80005124:	6161                	addi	sp,sp,80
    80005126:	8082                	ret
    80005128:	5a7d                	li	s4,-1
    8000512a:	b7d5                	j	8000510e <filewrite+0xfa>
    8000512c:	00003517          	auipc	a0,0x3
    80005130:	5bc50513          	addi	a0,a0,1468 # 800086e8 <syscalls+0x288>
    80005134:	ffffb097          	auipc	ra,0xffffb
    80005138:	40a080e7          	jalr	1034(ra) # 8000053e <panic>
    8000513c:	5a7d                	li	s4,-1
    8000513e:	bfc1                	j	8000510e <filewrite+0xfa>
    80005140:	5a7d                	li	s4,-1
    80005142:	b7f1                	j	8000510e <filewrite+0xfa>
    80005144:	5a7d                	li	s4,-1
    80005146:	b7e1                	j	8000510e <filewrite+0xfa>

0000000080005148 <pipealloc>:
    80005148:	7179                	addi	sp,sp,-48
    8000514a:	f406                	sd	ra,40(sp)
    8000514c:	f022                	sd	s0,32(sp)
    8000514e:	ec26                	sd	s1,24(sp)
    80005150:	e84a                	sd	s2,16(sp)
    80005152:	e44e                	sd	s3,8(sp)
    80005154:	e052                	sd	s4,0(sp)
    80005156:	1800                	addi	s0,sp,48
    80005158:	84aa                	mv	s1,a0
    8000515a:	8a2e                	mv	s4,a1
    8000515c:	0005b023          	sd	zero,0(a1)
    80005160:	00053023          	sd	zero,0(a0)
    80005164:	00000097          	auipc	ra,0x0
    80005168:	bf8080e7          	jalr	-1032(ra) # 80004d5c <filealloc>
    8000516c:	e088                	sd	a0,0(s1)
    8000516e:	c551                	beqz	a0,800051fa <pipealloc+0xb2>
    80005170:	00000097          	auipc	ra,0x0
    80005174:	bec080e7          	jalr	-1044(ra) # 80004d5c <filealloc>
    80005178:	00aa3023          	sd	a0,0(s4)
    8000517c:	c92d                	beqz	a0,800051ee <pipealloc+0xa6>
    8000517e:	ffffc097          	auipc	ra,0xffffc
    80005182:	968080e7          	jalr	-1688(ra) # 80000ae6 <kalloc>
    80005186:	892a                	mv	s2,a0
    80005188:	c125                	beqz	a0,800051e8 <pipealloc+0xa0>
    8000518a:	4985                	li	s3,1
    8000518c:	23352023          	sw	s3,544(a0)
    80005190:	23352223          	sw	s3,548(a0)
    80005194:	20052e23          	sw	zero,540(a0)
    80005198:	20052c23          	sw	zero,536(a0)
    8000519c:	00003597          	auipc	a1,0x3
    800051a0:	55c58593          	addi	a1,a1,1372 # 800086f8 <syscalls+0x298>
    800051a4:	ffffc097          	auipc	ra,0xffffc
    800051a8:	9a2080e7          	jalr	-1630(ra) # 80000b46 <initlock>
    800051ac:	609c                	ld	a5,0(s1)
    800051ae:	0137a023          	sw	s3,0(a5)
    800051b2:	609c                	ld	a5,0(s1)
    800051b4:	01378423          	sb	s3,8(a5)
    800051b8:	609c                	ld	a5,0(s1)
    800051ba:	000784a3          	sb	zero,9(a5)
    800051be:	609c                	ld	a5,0(s1)
    800051c0:	0127b823          	sd	s2,16(a5)
    800051c4:	000a3783          	ld	a5,0(s4)
    800051c8:	0137a023          	sw	s3,0(a5)
    800051cc:	000a3783          	ld	a5,0(s4)
    800051d0:	00078423          	sb	zero,8(a5)
    800051d4:	000a3783          	ld	a5,0(s4)
    800051d8:	013784a3          	sb	s3,9(a5)
    800051dc:	000a3783          	ld	a5,0(s4)
    800051e0:	0127b823          	sd	s2,16(a5)
    800051e4:	4501                	li	a0,0
    800051e6:	a025                	j	8000520e <pipealloc+0xc6>
    800051e8:	6088                	ld	a0,0(s1)
    800051ea:	e501                	bnez	a0,800051f2 <pipealloc+0xaa>
    800051ec:	a039                	j	800051fa <pipealloc+0xb2>
    800051ee:	6088                	ld	a0,0(s1)
    800051f0:	c51d                	beqz	a0,8000521e <pipealloc+0xd6>
    800051f2:	00000097          	auipc	ra,0x0
    800051f6:	c26080e7          	jalr	-986(ra) # 80004e18 <fileclose>
    800051fa:	000a3783          	ld	a5,0(s4)
    800051fe:	557d                	li	a0,-1
    80005200:	c799                	beqz	a5,8000520e <pipealloc+0xc6>
    80005202:	853e                	mv	a0,a5
    80005204:	00000097          	auipc	ra,0x0
    80005208:	c14080e7          	jalr	-1004(ra) # 80004e18 <fileclose>
    8000520c:	557d                	li	a0,-1
    8000520e:	70a2                	ld	ra,40(sp)
    80005210:	7402                	ld	s0,32(sp)
    80005212:	64e2                	ld	s1,24(sp)
    80005214:	6942                	ld	s2,16(sp)
    80005216:	69a2                	ld	s3,8(sp)
    80005218:	6a02                	ld	s4,0(sp)
    8000521a:	6145                	addi	sp,sp,48
    8000521c:	8082                	ret
    8000521e:	557d                	li	a0,-1
    80005220:	b7fd                	j	8000520e <pipealloc+0xc6>

0000000080005222 <pipeclose>:
    80005222:	1101                	addi	sp,sp,-32
    80005224:	ec06                	sd	ra,24(sp)
    80005226:	e822                	sd	s0,16(sp)
    80005228:	e426                	sd	s1,8(sp)
    8000522a:	e04a                	sd	s2,0(sp)
    8000522c:	1000                	addi	s0,sp,32
    8000522e:	84aa                	mv	s1,a0
    80005230:	892e                	mv	s2,a1
    80005232:	ffffc097          	auipc	ra,0xffffc
    80005236:	9a4080e7          	jalr	-1628(ra) # 80000bd6 <acquire>
    8000523a:	02090d63          	beqz	s2,80005274 <pipeclose+0x52>
    8000523e:	2204a223          	sw	zero,548(s1)
    80005242:	21848513          	addi	a0,s1,536
    80005246:	ffffd097          	auipc	ra,0xffffd
    8000524a:	f3c080e7          	jalr	-196(ra) # 80002182 <wakeup>
    8000524e:	2204b783          	ld	a5,544(s1)
    80005252:	eb95                	bnez	a5,80005286 <pipeclose+0x64>
    80005254:	8526                	mv	a0,s1
    80005256:	ffffc097          	auipc	ra,0xffffc
    8000525a:	a34080e7          	jalr	-1484(ra) # 80000c8a <release>
    8000525e:	8526                	mv	a0,s1
    80005260:	ffffb097          	auipc	ra,0xffffb
    80005264:	78a080e7          	jalr	1930(ra) # 800009ea <kfree>
    80005268:	60e2                	ld	ra,24(sp)
    8000526a:	6442                	ld	s0,16(sp)
    8000526c:	64a2                	ld	s1,8(sp)
    8000526e:	6902                	ld	s2,0(sp)
    80005270:	6105                	addi	sp,sp,32
    80005272:	8082                	ret
    80005274:	2204a023          	sw	zero,544(s1)
    80005278:	21c48513          	addi	a0,s1,540
    8000527c:	ffffd097          	auipc	ra,0xffffd
    80005280:	f06080e7          	jalr	-250(ra) # 80002182 <wakeup>
    80005284:	b7e9                	j	8000524e <pipeclose+0x2c>
    80005286:	8526                	mv	a0,s1
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	a02080e7          	jalr	-1534(ra) # 80000c8a <release>
    80005290:	bfe1                	j	80005268 <pipeclose+0x46>

0000000080005292 <pipewrite>:
    80005292:	711d                	addi	sp,sp,-96
    80005294:	ec86                	sd	ra,88(sp)
    80005296:	e8a2                	sd	s0,80(sp)
    80005298:	e4a6                	sd	s1,72(sp)
    8000529a:	e0ca                	sd	s2,64(sp)
    8000529c:	fc4e                	sd	s3,56(sp)
    8000529e:	f852                	sd	s4,48(sp)
    800052a0:	f456                	sd	s5,40(sp)
    800052a2:	f05a                	sd	s6,32(sp)
    800052a4:	ec5e                	sd	s7,24(sp)
    800052a6:	e862                	sd	s8,16(sp)
    800052a8:	1080                	addi	s0,sp,96
    800052aa:	84aa                	mv	s1,a0
    800052ac:	8aae                	mv	s5,a1
    800052ae:	8a32                	mv	s4,a2
    800052b0:	ffffc097          	auipc	ra,0xffffc
    800052b4:	6fc080e7          	jalr	1788(ra) # 800019ac <myproc>
    800052b8:	89aa                	mv	s3,a0
    800052ba:	8526                	mv	a0,s1
    800052bc:	ffffc097          	auipc	ra,0xffffc
    800052c0:	91a080e7          	jalr	-1766(ra) # 80000bd6 <acquire>
    800052c4:	0b405663          	blez	s4,80005370 <pipewrite+0xde>
    800052c8:	4901                	li	s2,0
    800052ca:	5b7d                	li	s6,-1
    800052cc:	21848c13          	addi	s8,s1,536
    800052d0:	21c48b93          	addi	s7,s1,540
    800052d4:	a089                	j	80005316 <pipewrite+0x84>
    800052d6:	8526                	mv	a0,s1
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	9b2080e7          	jalr	-1614(ra) # 80000c8a <release>
    800052e0:	597d                	li	s2,-1
    800052e2:	854a                	mv	a0,s2
    800052e4:	60e6                	ld	ra,88(sp)
    800052e6:	6446                	ld	s0,80(sp)
    800052e8:	64a6                	ld	s1,72(sp)
    800052ea:	6906                	ld	s2,64(sp)
    800052ec:	79e2                	ld	s3,56(sp)
    800052ee:	7a42                	ld	s4,48(sp)
    800052f0:	7aa2                	ld	s5,40(sp)
    800052f2:	7b02                	ld	s6,32(sp)
    800052f4:	6be2                	ld	s7,24(sp)
    800052f6:	6c42                	ld	s8,16(sp)
    800052f8:	6125                	addi	sp,sp,96
    800052fa:	8082                	ret
    800052fc:	8562                	mv	a0,s8
    800052fe:	ffffd097          	auipc	ra,0xffffd
    80005302:	e84080e7          	jalr	-380(ra) # 80002182 <wakeup>
    80005306:	85a6                	mv	a1,s1
    80005308:	855e                	mv	a0,s7
    8000530a:	ffffd097          	auipc	ra,0xffffd
    8000530e:	e14080e7          	jalr	-492(ra) # 8000211e <sleep>
    80005312:	07495063          	bge	s2,s4,80005372 <pipewrite+0xe0>
    80005316:	2204a783          	lw	a5,544(s1)
    8000531a:	dfd5                	beqz	a5,800052d6 <pipewrite+0x44>
    8000531c:	854e                	mv	a0,s3
    8000531e:	ffffd097          	auipc	ra,0xffffd
    80005322:	0b4080e7          	jalr	180(ra) # 800023d2 <killed>
    80005326:	f945                	bnez	a0,800052d6 <pipewrite+0x44>
    80005328:	2184a783          	lw	a5,536(s1)
    8000532c:	21c4a703          	lw	a4,540(s1)
    80005330:	2007879b          	addiw	a5,a5,512
    80005334:	fcf704e3          	beq	a4,a5,800052fc <pipewrite+0x6a>
    80005338:	4685                	li	a3,1
    8000533a:	01590633          	add	a2,s2,s5
    8000533e:	faf40593          	addi	a1,s0,-81
    80005342:	0909b503          	ld	a0,144(s3)
    80005346:	ffffc097          	auipc	ra,0xffffc
    8000534a:	3ae080e7          	jalr	942(ra) # 800016f4 <copyin>
    8000534e:	03650263          	beq	a0,s6,80005372 <pipewrite+0xe0>
    80005352:	21c4a783          	lw	a5,540(s1)
    80005356:	0017871b          	addiw	a4,a5,1
    8000535a:	20e4ae23          	sw	a4,540(s1)
    8000535e:	1ff7f793          	andi	a5,a5,511
    80005362:	97a6                	add	a5,a5,s1
    80005364:	faf44703          	lbu	a4,-81(s0)
    80005368:	00e78c23          	sb	a4,24(a5)
    8000536c:	2905                	addiw	s2,s2,1
    8000536e:	b755                	j	80005312 <pipewrite+0x80>
    80005370:	4901                	li	s2,0
    80005372:	21848513          	addi	a0,s1,536
    80005376:	ffffd097          	auipc	ra,0xffffd
    8000537a:	e0c080e7          	jalr	-500(ra) # 80002182 <wakeup>
    8000537e:	8526                	mv	a0,s1
    80005380:	ffffc097          	auipc	ra,0xffffc
    80005384:	90a080e7          	jalr	-1782(ra) # 80000c8a <release>
    80005388:	bfa9                	j	800052e2 <pipewrite+0x50>

000000008000538a <piperead>:
    8000538a:	715d                	addi	sp,sp,-80
    8000538c:	e486                	sd	ra,72(sp)
    8000538e:	e0a2                	sd	s0,64(sp)
    80005390:	fc26                	sd	s1,56(sp)
    80005392:	f84a                	sd	s2,48(sp)
    80005394:	f44e                	sd	s3,40(sp)
    80005396:	f052                	sd	s4,32(sp)
    80005398:	ec56                	sd	s5,24(sp)
    8000539a:	e85a                	sd	s6,16(sp)
    8000539c:	0880                	addi	s0,sp,80
    8000539e:	84aa                	mv	s1,a0
    800053a0:	892e                	mv	s2,a1
    800053a2:	8ab2                	mv	s5,a2
    800053a4:	ffffc097          	auipc	ra,0xffffc
    800053a8:	608080e7          	jalr	1544(ra) # 800019ac <myproc>
    800053ac:	8a2a                	mv	s4,a0
    800053ae:	8526                	mv	a0,s1
    800053b0:	ffffc097          	auipc	ra,0xffffc
    800053b4:	826080e7          	jalr	-2010(ra) # 80000bd6 <acquire>
    800053b8:	2184a703          	lw	a4,536(s1)
    800053bc:	21c4a783          	lw	a5,540(s1)
    800053c0:	21848993          	addi	s3,s1,536
    800053c4:	02f71763          	bne	a4,a5,800053f2 <piperead+0x68>
    800053c8:	2244a783          	lw	a5,548(s1)
    800053cc:	c39d                	beqz	a5,800053f2 <piperead+0x68>
    800053ce:	8552                	mv	a0,s4
    800053d0:	ffffd097          	auipc	ra,0xffffd
    800053d4:	002080e7          	jalr	2(ra) # 800023d2 <killed>
    800053d8:	e941                	bnez	a0,80005468 <piperead+0xde>
    800053da:	85a6                	mv	a1,s1
    800053dc:	854e                	mv	a0,s3
    800053de:	ffffd097          	auipc	ra,0xffffd
    800053e2:	d40080e7          	jalr	-704(ra) # 8000211e <sleep>
    800053e6:	2184a703          	lw	a4,536(s1)
    800053ea:	21c4a783          	lw	a5,540(s1)
    800053ee:	fcf70de3          	beq	a4,a5,800053c8 <piperead+0x3e>
    800053f2:	4981                	li	s3,0
    800053f4:	5b7d                	li	s6,-1
    800053f6:	05505363          	blez	s5,8000543c <piperead+0xb2>
    800053fa:	2184a783          	lw	a5,536(s1)
    800053fe:	21c4a703          	lw	a4,540(s1)
    80005402:	02f70d63          	beq	a4,a5,8000543c <piperead+0xb2>
    80005406:	0017871b          	addiw	a4,a5,1
    8000540a:	20e4ac23          	sw	a4,536(s1)
    8000540e:	1ff7f793          	andi	a5,a5,511
    80005412:	97a6                	add	a5,a5,s1
    80005414:	0187c783          	lbu	a5,24(a5)
    80005418:	faf40fa3          	sb	a5,-65(s0)
    8000541c:	4685                	li	a3,1
    8000541e:	fbf40613          	addi	a2,s0,-65
    80005422:	85ca                	mv	a1,s2
    80005424:	090a3503          	ld	a0,144(s4)
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	240080e7          	jalr	576(ra) # 80001668 <copyout>
    80005430:	01650663          	beq	a0,s6,8000543c <piperead+0xb2>
    80005434:	2985                	addiw	s3,s3,1
    80005436:	0905                	addi	s2,s2,1
    80005438:	fd3a91e3          	bne	s5,s3,800053fa <piperead+0x70>
    8000543c:	21c48513          	addi	a0,s1,540
    80005440:	ffffd097          	auipc	ra,0xffffd
    80005444:	d42080e7          	jalr	-702(ra) # 80002182 <wakeup>
    80005448:	8526                	mv	a0,s1
    8000544a:	ffffc097          	auipc	ra,0xffffc
    8000544e:	840080e7          	jalr	-1984(ra) # 80000c8a <release>
    80005452:	854e                	mv	a0,s3
    80005454:	60a6                	ld	ra,72(sp)
    80005456:	6406                	ld	s0,64(sp)
    80005458:	74e2                	ld	s1,56(sp)
    8000545a:	7942                	ld	s2,48(sp)
    8000545c:	79a2                	ld	s3,40(sp)
    8000545e:	7a02                	ld	s4,32(sp)
    80005460:	6ae2                	ld	s5,24(sp)
    80005462:	6b42                	ld	s6,16(sp)
    80005464:	6161                	addi	sp,sp,80
    80005466:	8082                	ret
    80005468:	8526                	mv	a0,s1
    8000546a:	ffffc097          	auipc	ra,0xffffc
    8000546e:	820080e7          	jalr	-2016(ra) # 80000c8a <release>
    80005472:	59fd                	li	s3,-1
    80005474:	bff9                	j	80005452 <piperead+0xc8>

0000000080005476 <flags2perm>:
    80005476:	1141                	addi	sp,sp,-16
    80005478:	e422                	sd	s0,8(sp)
    8000547a:	0800                	addi	s0,sp,16
    8000547c:	87aa                	mv	a5,a0
    8000547e:	8905                	andi	a0,a0,1
    80005480:	c111                	beqz	a0,80005484 <flags2perm+0xe>
    80005482:	4521                	li	a0,8
    80005484:	8b89                	andi	a5,a5,2
    80005486:	c399                	beqz	a5,8000548c <flags2perm+0x16>
    80005488:	00456513          	ori	a0,a0,4
    8000548c:	6422                	ld	s0,8(sp)
    8000548e:	0141                	addi	sp,sp,16
    80005490:	8082                	ret

0000000080005492 <exec>:
    80005492:	de010113          	addi	sp,sp,-544
    80005496:	20113c23          	sd	ra,536(sp)
    8000549a:	20813823          	sd	s0,528(sp)
    8000549e:	20913423          	sd	s1,520(sp)
    800054a2:	21213023          	sd	s2,512(sp)
    800054a6:	ffce                	sd	s3,504(sp)
    800054a8:	fbd2                	sd	s4,496(sp)
    800054aa:	f7d6                	sd	s5,488(sp)
    800054ac:	f3da                	sd	s6,480(sp)
    800054ae:	efde                	sd	s7,472(sp)
    800054b0:	ebe2                	sd	s8,464(sp)
    800054b2:	e7e6                	sd	s9,456(sp)
    800054b4:	e3ea                	sd	s10,448(sp)
    800054b6:	ff6e                	sd	s11,440(sp)
    800054b8:	1400                	addi	s0,sp,544
    800054ba:	892a                	mv	s2,a0
    800054bc:	dea43423          	sd	a0,-536(s0)
    800054c0:	deb43823          	sd	a1,-528(s0)
    800054c4:	ffffc097          	auipc	ra,0xffffc
    800054c8:	4e8080e7          	jalr	1256(ra) # 800019ac <myproc>
    800054cc:	84aa                	mv	s1,a0
    800054ce:	fffff097          	auipc	ra,0xfffff
    800054d2:	47e080e7          	jalr	1150(ra) # 8000494c <begin_op>
    800054d6:	854a                	mv	a0,s2
    800054d8:	fffff097          	auipc	ra,0xfffff
    800054dc:	258080e7          	jalr	600(ra) # 80004730 <namei>
    800054e0:	c93d                	beqz	a0,80005556 <exec+0xc4>
    800054e2:	8aaa                	mv	s5,a0
    800054e4:	fffff097          	auipc	ra,0xfffff
    800054e8:	aa6080e7          	jalr	-1370(ra) # 80003f8a <ilock>
    800054ec:	04000713          	li	a4,64
    800054f0:	4681                	li	a3,0
    800054f2:	e5040613          	addi	a2,s0,-432
    800054f6:	4581                	li	a1,0
    800054f8:	8556                	mv	a0,s5
    800054fa:	fffff097          	auipc	ra,0xfffff
    800054fe:	d44080e7          	jalr	-700(ra) # 8000423e <readi>
    80005502:	04000793          	li	a5,64
    80005506:	00f51a63          	bne	a0,a5,8000551a <exec+0x88>
    8000550a:	e5042703          	lw	a4,-432(s0)
    8000550e:	464c47b7          	lui	a5,0x464c4
    80005512:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005516:	04f70663          	beq	a4,a5,80005562 <exec+0xd0>
    8000551a:	8556                	mv	a0,s5
    8000551c:	fffff097          	auipc	ra,0xfffff
    80005520:	cd0080e7          	jalr	-816(ra) # 800041ec <iunlockput>
    80005524:	fffff097          	auipc	ra,0xfffff
    80005528:	4a8080e7          	jalr	1192(ra) # 800049cc <end_op>
    8000552c:	557d                	li	a0,-1
    8000552e:	21813083          	ld	ra,536(sp)
    80005532:	21013403          	ld	s0,528(sp)
    80005536:	20813483          	ld	s1,520(sp)
    8000553a:	20013903          	ld	s2,512(sp)
    8000553e:	79fe                	ld	s3,504(sp)
    80005540:	7a5e                	ld	s4,496(sp)
    80005542:	7abe                	ld	s5,488(sp)
    80005544:	7b1e                	ld	s6,480(sp)
    80005546:	6bfe                	ld	s7,472(sp)
    80005548:	6c5e                	ld	s8,464(sp)
    8000554a:	6cbe                	ld	s9,456(sp)
    8000554c:	6d1e                	ld	s10,448(sp)
    8000554e:	7dfa                	ld	s11,440(sp)
    80005550:	22010113          	addi	sp,sp,544
    80005554:	8082                	ret
    80005556:	fffff097          	auipc	ra,0xfffff
    8000555a:	476080e7          	jalr	1142(ra) # 800049cc <end_op>
    8000555e:	557d                	li	a0,-1
    80005560:	b7f9                	j	8000552e <exec+0x9c>
    80005562:	8526                	mv	a0,s1
    80005564:	ffffc097          	auipc	ra,0xffffc
    80005568:	50c080e7          	jalr	1292(ra) # 80001a70 <proc_pagetable>
    8000556c:	8b2a                	mv	s6,a0
    8000556e:	d555                	beqz	a0,8000551a <exec+0x88>
    80005570:	e7042783          	lw	a5,-400(s0)
    80005574:	e8845703          	lhu	a4,-376(s0)
    80005578:	c735                	beqz	a4,800055e4 <exec+0x152>
    8000557a:	4901                	li	s2,0
    8000557c:	e0043423          	sd	zero,-504(s0)
    80005580:	6a05                	lui	s4,0x1
    80005582:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005586:	dee43023          	sd	a4,-544(s0)
    8000558a:	6d85                	lui	s11,0x1
    8000558c:	7d7d                	lui	s10,0xfffff
    8000558e:	a481                	j	800057ce <exec+0x33c>
    80005590:	00003517          	auipc	a0,0x3
    80005594:	17050513          	addi	a0,a0,368 # 80008700 <syscalls+0x2a0>
    80005598:	ffffb097          	auipc	ra,0xffffb
    8000559c:	fa6080e7          	jalr	-90(ra) # 8000053e <panic>
    800055a0:	874a                	mv	a4,s2
    800055a2:	009c86bb          	addw	a3,s9,s1
    800055a6:	4581                	li	a1,0
    800055a8:	8556                	mv	a0,s5
    800055aa:	fffff097          	auipc	ra,0xfffff
    800055ae:	c94080e7          	jalr	-876(ra) # 8000423e <readi>
    800055b2:	2501                	sext.w	a0,a0
    800055b4:	1aa91a63          	bne	s2,a0,80005768 <exec+0x2d6>
    800055b8:	009d84bb          	addw	s1,s11,s1
    800055bc:	013d09bb          	addw	s3,s10,s3
    800055c0:	1f74f763          	bgeu	s1,s7,800057ae <exec+0x31c>
    800055c4:	02049593          	slli	a1,s1,0x20
    800055c8:	9181                	srli	a1,a1,0x20
    800055ca:	95e2                	add	a1,a1,s8
    800055cc:	855a                	mv	a0,s6
    800055ce:	ffffc097          	auipc	ra,0xffffc
    800055d2:	a8e080e7          	jalr	-1394(ra) # 8000105c <walkaddr>
    800055d6:	862a                	mv	a2,a0
    800055d8:	dd45                	beqz	a0,80005590 <exec+0xfe>
    800055da:	8952                	mv	s2,s4
    800055dc:	fd49f2e3          	bgeu	s3,s4,800055a0 <exec+0x10e>
    800055e0:	894e                	mv	s2,s3
    800055e2:	bf7d                	j	800055a0 <exec+0x10e>
    800055e4:	4901                	li	s2,0
    800055e6:	8556                	mv	a0,s5
    800055e8:	fffff097          	auipc	ra,0xfffff
    800055ec:	c04080e7          	jalr	-1020(ra) # 800041ec <iunlockput>
    800055f0:	fffff097          	auipc	ra,0xfffff
    800055f4:	3dc080e7          	jalr	988(ra) # 800049cc <end_op>
    800055f8:	ffffc097          	auipc	ra,0xffffc
    800055fc:	3b4080e7          	jalr	948(ra) # 800019ac <myproc>
    80005600:	8baa                	mv	s7,a0
    80005602:	08853d03          	ld	s10,136(a0)
    80005606:	6785                	lui	a5,0x1
    80005608:	17fd                	addi	a5,a5,-1
    8000560a:	993e                	add	s2,s2,a5
    8000560c:	77fd                	lui	a5,0xfffff
    8000560e:	00f977b3          	and	a5,s2,a5
    80005612:	def43c23          	sd	a5,-520(s0)
    80005616:	4691                	li	a3,4
    80005618:	6609                	lui	a2,0x2
    8000561a:	963e                	add	a2,a2,a5
    8000561c:	85be                	mv	a1,a5
    8000561e:	855a                	mv	a0,s6
    80005620:	ffffc097          	auipc	ra,0xffffc
    80005624:	df0080e7          	jalr	-528(ra) # 80001410 <uvmalloc>
    80005628:	8c2a                	mv	s8,a0
    8000562a:	4a81                	li	s5,0
    8000562c:	12050e63          	beqz	a0,80005768 <exec+0x2d6>
    80005630:	75f9                	lui	a1,0xffffe
    80005632:	95aa                	add	a1,a1,a0
    80005634:	855a                	mv	a0,s6
    80005636:	ffffc097          	auipc	ra,0xffffc
    8000563a:	000080e7          	jalr	ra # 80001636 <uvmclear>
    8000563e:	7afd                	lui	s5,0xfffff
    80005640:	9ae2                	add	s5,s5,s8
    80005642:	df043783          	ld	a5,-528(s0)
    80005646:	6388                	ld	a0,0(a5)
    80005648:	c925                	beqz	a0,800056b8 <exec+0x226>
    8000564a:	e9040993          	addi	s3,s0,-368
    8000564e:	f9040c93          	addi	s9,s0,-112
    80005652:	8962                	mv	s2,s8
    80005654:	4481                	li	s1,0
    80005656:	ffffb097          	auipc	ra,0xffffb
    8000565a:	7f8080e7          	jalr	2040(ra) # 80000e4e <strlen>
    8000565e:	0015079b          	addiw	a5,a0,1
    80005662:	40f90933          	sub	s2,s2,a5
    80005666:	ff097913          	andi	s2,s2,-16
    8000566a:	13596663          	bltu	s2,s5,80005796 <exec+0x304>
    8000566e:	df043d83          	ld	s11,-528(s0)
    80005672:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005676:	8552                	mv	a0,s4
    80005678:	ffffb097          	auipc	ra,0xffffb
    8000567c:	7d6080e7          	jalr	2006(ra) # 80000e4e <strlen>
    80005680:	0015069b          	addiw	a3,a0,1
    80005684:	8652                	mv	a2,s4
    80005686:	85ca                	mv	a1,s2
    80005688:	855a                	mv	a0,s6
    8000568a:	ffffc097          	auipc	ra,0xffffc
    8000568e:	fde080e7          	jalr	-34(ra) # 80001668 <copyout>
    80005692:	10054663          	bltz	a0,8000579e <exec+0x30c>
    80005696:	0129b023          	sd	s2,0(s3)
    8000569a:	0485                	addi	s1,s1,1
    8000569c:	008d8793          	addi	a5,s11,8
    800056a0:	def43823          	sd	a5,-528(s0)
    800056a4:	008db503          	ld	a0,8(s11)
    800056a8:	c911                	beqz	a0,800056bc <exec+0x22a>
    800056aa:	09a1                	addi	s3,s3,8
    800056ac:	fb3c95e3          	bne	s9,s3,80005656 <exec+0x1c4>
    800056b0:	df843c23          	sd	s8,-520(s0)
    800056b4:	4a81                	li	s5,0
    800056b6:	a84d                	j	80005768 <exec+0x2d6>
    800056b8:	8962                	mv	s2,s8
    800056ba:	4481                	li	s1,0
    800056bc:	00349793          	slli	a5,s1,0x3
    800056c0:	f9040713          	addi	a4,s0,-112
    800056c4:	97ba                	add	a5,a5,a4
    800056c6:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7ffdbd90>
    800056ca:	00148693          	addi	a3,s1,1
    800056ce:	068e                	slli	a3,a3,0x3
    800056d0:	40d90933          	sub	s2,s2,a3
    800056d4:	ff097913          	andi	s2,s2,-16
    800056d8:	01597663          	bgeu	s2,s5,800056e4 <exec+0x252>
    800056dc:	df843c23          	sd	s8,-520(s0)
    800056e0:	4a81                	li	s5,0
    800056e2:	a059                	j	80005768 <exec+0x2d6>
    800056e4:	e9040613          	addi	a2,s0,-368
    800056e8:	85ca                	mv	a1,s2
    800056ea:	855a                	mv	a0,s6
    800056ec:	ffffc097          	auipc	ra,0xffffc
    800056f0:	f7c080e7          	jalr	-132(ra) # 80001668 <copyout>
    800056f4:	0a054963          	bltz	a0,800057a6 <exec+0x314>
    800056f8:	098bb783          	ld	a5,152(s7) # 1098 <_entry-0x7fffef68>
    800056fc:	0727bc23          	sd	s2,120(a5)
    80005700:	de843783          	ld	a5,-536(s0)
    80005704:	0007c703          	lbu	a4,0(a5)
    80005708:	cf11                	beqz	a4,80005724 <exec+0x292>
    8000570a:	0785                	addi	a5,a5,1
    8000570c:	02f00693          	li	a3,47
    80005710:	a039                	j	8000571e <exec+0x28c>
    80005712:	def43423          	sd	a5,-536(s0)
    80005716:	0785                	addi	a5,a5,1
    80005718:	fff7c703          	lbu	a4,-1(a5)
    8000571c:	c701                	beqz	a4,80005724 <exec+0x292>
    8000571e:	fed71ce3          	bne	a4,a3,80005716 <exec+0x284>
    80005722:	bfc5                	j	80005712 <exec+0x280>
    80005724:	4641                	li	a2,16
    80005726:	de843583          	ld	a1,-536(s0)
    8000572a:	198b8513          	addi	a0,s7,408
    8000572e:	ffffb097          	auipc	ra,0xffffb
    80005732:	6ee080e7          	jalr	1774(ra) # 80000e1c <safestrcpy>
    80005736:	090bb503          	ld	a0,144(s7)
    8000573a:	096bb823          	sd	s6,144(s7)
    8000573e:	098bb423          	sd	s8,136(s7)
    80005742:	098bb783          	ld	a5,152(s7)
    80005746:	e6843703          	ld	a4,-408(s0)
    8000574a:	ef98                	sd	a4,24(a5)
    8000574c:	098bb783          	ld	a5,152(s7)
    80005750:	0327b823          	sd	s2,48(a5)
    80005754:	85ea                	mv	a1,s10
    80005756:	ffffc097          	auipc	ra,0xffffc
    8000575a:	3b6080e7          	jalr	950(ra) # 80001b0c <proc_freepagetable>
    8000575e:	0004851b          	sext.w	a0,s1
    80005762:	b3f1                	j	8000552e <exec+0x9c>
    80005764:	df243c23          	sd	s2,-520(s0)
    80005768:	df843583          	ld	a1,-520(s0)
    8000576c:	855a                	mv	a0,s6
    8000576e:	ffffc097          	auipc	ra,0xffffc
    80005772:	39e080e7          	jalr	926(ra) # 80001b0c <proc_freepagetable>
    80005776:	da0a92e3          	bnez	s5,8000551a <exec+0x88>
    8000577a:	557d                	li	a0,-1
    8000577c:	bb4d                	j	8000552e <exec+0x9c>
    8000577e:	df243c23          	sd	s2,-520(s0)
    80005782:	b7dd                	j	80005768 <exec+0x2d6>
    80005784:	df243c23          	sd	s2,-520(s0)
    80005788:	b7c5                	j	80005768 <exec+0x2d6>
    8000578a:	df243c23          	sd	s2,-520(s0)
    8000578e:	bfe9                	j	80005768 <exec+0x2d6>
    80005790:	df243c23          	sd	s2,-520(s0)
    80005794:	bfd1                	j	80005768 <exec+0x2d6>
    80005796:	df843c23          	sd	s8,-520(s0)
    8000579a:	4a81                	li	s5,0
    8000579c:	b7f1                	j	80005768 <exec+0x2d6>
    8000579e:	df843c23          	sd	s8,-520(s0)
    800057a2:	4a81                	li	s5,0
    800057a4:	b7d1                	j	80005768 <exec+0x2d6>
    800057a6:	df843c23          	sd	s8,-520(s0)
    800057aa:	4a81                	li	s5,0
    800057ac:	bf75                	j	80005768 <exec+0x2d6>
    800057ae:	df843903          	ld	s2,-520(s0)
    800057b2:	e0843783          	ld	a5,-504(s0)
    800057b6:	0017869b          	addiw	a3,a5,1
    800057ba:	e0d43423          	sd	a3,-504(s0)
    800057be:	e0043783          	ld	a5,-512(s0)
    800057c2:	0387879b          	addiw	a5,a5,56
    800057c6:	e8845703          	lhu	a4,-376(s0)
    800057ca:	e0e6dee3          	bge	a3,a4,800055e6 <exec+0x154>
    800057ce:	2781                	sext.w	a5,a5
    800057d0:	e0f43023          	sd	a5,-512(s0)
    800057d4:	03800713          	li	a4,56
    800057d8:	86be                	mv	a3,a5
    800057da:	e1840613          	addi	a2,s0,-488
    800057de:	4581                	li	a1,0
    800057e0:	8556                	mv	a0,s5
    800057e2:	fffff097          	auipc	ra,0xfffff
    800057e6:	a5c080e7          	jalr	-1444(ra) # 8000423e <readi>
    800057ea:	03800793          	li	a5,56
    800057ee:	f6f51be3          	bne	a0,a5,80005764 <exec+0x2d2>
    800057f2:	e1842783          	lw	a5,-488(s0)
    800057f6:	4705                	li	a4,1
    800057f8:	fae79de3          	bne	a5,a4,800057b2 <exec+0x320>
    800057fc:	e4043483          	ld	s1,-448(s0)
    80005800:	e3843783          	ld	a5,-456(s0)
    80005804:	f6f4ede3          	bltu	s1,a5,8000577e <exec+0x2ec>
    80005808:	e2843783          	ld	a5,-472(s0)
    8000580c:	94be                	add	s1,s1,a5
    8000580e:	f6f4ebe3          	bltu	s1,a5,80005784 <exec+0x2f2>
    80005812:	de043703          	ld	a4,-544(s0)
    80005816:	8ff9                	and	a5,a5,a4
    80005818:	fbad                	bnez	a5,8000578a <exec+0x2f8>
    8000581a:	e1c42503          	lw	a0,-484(s0)
    8000581e:	00000097          	auipc	ra,0x0
    80005822:	c58080e7          	jalr	-936(ra) # 80005476 <flags2perm>
    80005826:	86aa                	mv	a3,a0
    80005828:	8626                	mv	a2,s1
    8000582a:	85ca                	mv	a1,s2
    8000582c:	855a                	mv	a0,s6
    8000582e:	ffffc097          	auipc	ra,0xffffc
    80005832:	be2080e7          	jalr	-1054(ra) # 80001410 <uvmalloc>
    80005836:	dea43c23          	sd	a0,-520(s0)
    8000583a:	d939                	beqz	a0,80005790 <exec+0x2fe>
    8000583c:	e2843c03          	ld	s8,-472(s0)
    80005840:	e2042c83          	lw	s9,-480(s0)
    80005844:	e3842b83          	lw	s7,-456(s0)
    80005848:	f60b83e3          	beqz	s7,800057ae <exec+0x31c>
    8000584c:	89de                	mv	s3,s7
    8000584e:	4481                	li	s1,0
    80005850:	bb95                	j	800055c4 <exec+0x132>

0000000080005852 <argfd>:
    80005852:	7179                	addi	sp,sp,-48
    80005854:	f406                	sd	ra,40(sp)
    80005856:	f022                	sd	s0,32(sp)
    80005858:	ec26                	sd	s1,24(sp)
    8000585a:	e84a                	sd	s2,16(sp)
    8000585c:	1800                	addi	s0,sp,48
    8000585e:	892e                	mv	s2,a1
    80005860:	84b2                	mv	s1,a2
    80005862:	fdc40593          	addi	a1,s0,-36
    80005866:	ffffe097          	auipc	ra,0xffffe
    8000586a:	b1c080e7          	jalr	-1252(ra) # 80003382 <argint>
    8000586e:	fdc42703          	lw	a4,-36(s0)
    80005872:	47bd                	li	a5,15
    80005874:	02e7eb63          	bltu	a5,a4,800058aa <argfd+0x58>
    80005878:	ffffc097          	auipc	ra,0xffffc
    8000587c:	134080e7          	jalr	308(ra) # 800019ac <myproc>
    80005880:	fdc42703          	lw	a4,-36(s0)
    80005884:	02270793          	addi	a5,a4,34
    80005888:	078e                	slli	a5,a5,0x3
    8000588a:	953e                	add	a0,a0,a5
    8000588c:	611c                	ld	a5,0(a0)
    8000588e:	c385                	beqz	a5,800058ae <argfd+0x5c>
    80005890:	00090463          	beqz	s2,80005898 <argfd+0x46>
    80005894:	00e92023          	sw	a4,0(s2)
    80005898:	4501                	li	a0,0
    8000589a:	c091                	beqz	s1,8000589e <argfd+0x4c>
    8000589c:	e09c                	sd	a5,0(s1)
    8000589e:	70a2                	ld	ra,40(sp)
    800058a0:	7402                	ld	s0,32(sp)
    800058a2:	64e2                	ld	s1,24(sp)
    800058a4:	6942                	ld	s2,16(sp)
    800058a6:	6145                	addi	sp,sp,48
    800058a8:	8082                	ret
    800058aa:	557d                	li	a0,-1
    800058ac:	bfcd                	j	8000589e <argfd+0x4c>
    800058ae:	557d                	li	a0,-1
    800058b0:	b7fd                	j	8000589e <argfd+0x4c>

00000000800058b2 <fdalloc>:
    800058b2:	1101                	addi	sp,sp,-32
    800058b4:	ec06                	sd	ra,24(sp)
    800058b6:	e822                	sd	s0,16(sp)
    800058b8:	e426                	sd	s1,8(sp)
    800058ba:	1000                	addi	s0,sp,32
    800058bc:	84aa                	mv	s1,a0
    800058be:	ffffc097          	auipc	ra,0xffffc
    800058c2:	0ee080e7          	jalr	238(ra) # 800019ac <myproc>
    800058c6:	862a                	mv	a2,a0
    800058c8:	11050793          	addi	a5,a0,272
    800058cc:	4501                	li	a0,0
    800058ce:	46c1                	li	a3,16
    800058d0:	6398                	ld	a4,0(a5)
    800058d2:	cb19                	beqz	a4,800058e8 <fdalloc+0x36>
    800058d4:	2505                	addiw	a0,a0,1
    800058d6:	07a1                	addi	a5,a5,8
    800058d8:	fed51ce3          	bne	a0,a3,800058d0 <fdalloc+0x1e>
    800058dc:	557d                	li	a0,-1
    800058de:	60e2                	ld	ra,24(sp)
    800058e0:	6442                	ld	s0,16(sp)
    800058e2:	64a2                	ld	s1,8(sp)
    800058e4:	6105                	addi	sp,sp,32
    800058e6:	8082                	ret
    800058e8:	02250793          	addi	a5,a0,34
    800058ec:	078e                	slli	a5,a5,0x3
    800058ee:	963e                	add	a2,a2,a5
    800058f0:	e204                	sd	s1,0(a2)
    800058f2:	b7f5                	j	800058de <fdalloc+0x2c>

00000000800058f4 <create>:
    800058f4:	715d                	addi	sp,sp,-80
    800058f6:	e486                	sd	ra,72(sp)
    800058f8:	e0a2                	sd	s0,64(sp)
    800058fa:	fc26                	sd	s1,56(sp)
    800058fc:	f84a                	sd	s2,48(sp)
    800058fe:	f44e                	sd	s3,40(sp)
    80005900:	f052                	sd	s4,32(sp)
    80005902:	ec56                	sd	s5,24(sp)
    80005904:	e85a                	sd	s6,16(sp)
    80005906:	0880                	addi	s0,sp,80
    80005908:	8b2e                	mv	s6,a1
    8000590a:	89b2                	mv	s3,a2
    8000590c:	8936                	mv	s2,a3
    8000590e:	fb040593          	addi	a1,s0,-80
    80005912:	fffff097          	auipc	ra,0xfffff
    80005916:	e3c080e7          	jalr	-452(ra) # 8000474e <nameiparent>
    8000591a:	84aa                	mv	s1,a0
    8000591c:	14050f63          	beqz	a0,80005a7a <create+0x186>
    80005920:	ffffe097          	auipc	ra,0xffffe
    80005924:	66a080e7          	jalr	1642(ra) # 80003f8a <ilock>
    80005928:	4601                	li	a2,0
    8000592a:	fb040593          	addi	a1,s0,-80
    8000592e:	8526                	mv	a0,s1
    80005930:	fffff097          	auipc	ra,0xfffff
    80005934:	b3e080e7          	jalr	-1218(ra) # 8000446e <dirlookup>
    80005938:	8aaa                	mv	s5,a0
    8000593a:	c931                	beqz	a0,8000598e <create+0x9a>
    8000593c:	8526                	mv	a0,s1
    8000593e:	fffff097          	auipc	ra,0xfffff
    80005942:	8ae080e7          	jalr	-1874(ra) # 800041ec <iunlockput>
    80005946:	8556                	mv	a0,s5
    80005948:	ffffe097          	auipc	ra,0xffffe
    8000594c:	642080e7          	jalr	1602(ra) # 80003f8a <ilock>
    80005950:	000b059b          	sext.w	a1,s6
    80005954:	4789                	li	a5,2
    80005956:	02f59563          	bne	a1,a5,80005980 <create+0x8c>
    8000595a:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffdbed4>
    8000595e:	37f9                	addiw	a5,a5,-2
    80005960:	17c2                	slli	a5,a5,0x30
    80005962:	93c1                	srli	a5,a5,0x30
    80005964:	4705                	li	a4,1
    80005966:	00f76d63          	bltu	a4,a5,80005980 <create+0x8c>
    8000596a:	8556                	mv	a0,s5
    8000596c:	60a6                	ld	ra,72(sp)
    8000596e:	6406                	ld	s0,64(sp)
    80005970:	74e2                	ld	s1,56(sp)
    80005972:	7942                	ld	s2,48(sp)
    80005974:	79a2                	ld	s3,40(sp)
    80005976:	7a02                	ld	s4,32(sp)
    80005978:	6ae2                	ld	s5,24(sp)
    8000597a:	6b42                	ld	s6,16(sp)
    8000597c:	6161                	addi	sp,sp,80
    8000597e:	8082                	ret
    80005980:	8556                	mv	a0,s5
    80005982:	fffff097          	auipc	ra,0xfffff
    80005986:	86a080e7          	jalr	-1942(ra) # 800041ec <iunlockput>
    8000598a:	4a81                	li	s5,0
    8000598c:	bff9                	j	8000596a <create+0x76>
    8000598e:	85da                	mv	a1,s6
    80005990:	4088                	lw	a0,0(s1)
    80005992:	ffffe097          	auipc	ra,0xffffe
    80005996:	45c080e7          	jalr	1116(ra) # 80003dee <ialloc>
    8000599a:	8a2a                	mv	s4,a0
    8000599c:	c539                	beqz	a0,800059ea <create+0xf6>
    8000599e:	ffffe097          	auipc	ra,0xffffe
    800059a2:	5ec080e7          	jalr	1516(ra) # 80003f8a <ilock>
    800059a6:	053a1323          	sh	s3,70(s4)
    800059aa:	052a1423          	sh	s2,72(s4)
    800059ae:	4905                	li	s2,1
    800059b0:	052a1523          	sh	s2,74(s4)
    800059b4:	8552                	mv	a0,s4
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	50a080e7          	jalr	1290(ra) # 80003ec0 <iupdate>
    800059be:	000b059b          	sext.w	a1,s6
    800059c2:	03258b63          	beq	a1,s2,800059f8 <create+0x104>
    800059c6:	004a2603          	lw	a2,4(s4)
    800059ca:	fb040593          	addi	a1,s0,-80
    800059ce:	8526                	mv	a0,s1
    800059d0:	fffff097          	auipc	ra,0xfffff
    800059d4:	cae080e7          	jalr	-850(ra) # 8000467e <dirlink>
    800059d8:	06054f63          	bltz	a0,80005a56 <create+0x162>
    800059dc:	8526                	mv	a0,s1
    800059de:	fffff097          	auipc	ra,0xfffff
    800059e2:	80e080e7          	jalr	-2034(ra) # 800041ec <iunlockput>
    800059e6:	8ad2                	mv	s5,s4
    800059e8:	b749                	j	8000596a <create+0x76>
    800059ea:	8526                	mv	a0,s1
    800059ec:	fffff097          	auipc	ra,0xfffff
    800059f0:	800080e7          	jalr	-2048(ra) # 800041ec <iunlockput>
    800059f4:	8ad2                	mv	s5,s4
    800059f6:	bf95                	j	8000596a <create+0x76>
    800059f8:	004a2603          	lw	a2,4(s4)
    800059fc:	00003597          	auipc	a1,0x3
    80005a00:	d2458593          	addi	a1,a1,-732 # 80008720 <syscalls+0x2c0>
    80005a04:	8552                	mv	a0,s4
    80005a06:	fffff097          	auipc	ra,0xfffff
    80005a0a:	c78080e7          	jalr	-904(ra) # 8000467e <dirlink>
    80005a0e:	04054463          	bltz	a0,80005a56 <create+0x162>
    80005a12:	40d0                	lw	a2,4(s1)
    80005a14:	00003597          	auipc	a1,0x3
    80005a18:	d1458593          	addi	a1,a1,-748 # 80008728 <syscalls+0x2c8>
    80005a1c:	8552                	mv	a0,s4
    80005a1e:	fffff097          	auipc	ra,0xfffff
    80005a22:	c60080e7          	jalr	-928(ra) # 8000467e <dirlink>
    80005a26:	02054863          	bltz	a0,80005a56 <create+0x162>
    80005a2a:	004a2603          	lw	a2,4(s4)
    80005a2e:	fb040593          	addi	a1,s0,-80
    80005a32:	8526                	mv	a0,s1
    80005a34:	fffff097          	auipc	ra,0xfffff
    80005a38:	c4a080e7          	jalr	-950(ra) # 8000467e <dirlink>
    80005a3c:	00054d63          	bltz	a0,80005a56 <create+0x162>
    80005a40:	04a4d783          	lhu	a5,74(s1)
    80005a44:	2785                	addiw	a5,a5,1
    80005a46:	04f49523          	sh	a5,74(s1)
    80005a4a:	8526                	mv	a0,s1
    80005a4c:	ffffe097          	auipc	ra,0xffffe
    80005a50:	474080e7          	jalr	1140(ra) # 80003ec0 <iupdate>
    80005a54:	b761                	j	800059dc <create+0xe8>
    80005a56:	040a1523          	sh	zero,74(s4)
    80005a5a:	8552                	mv	a0,s4
    80005a5c:	ffffe097          	auipc	ra,0xffffe
    80005a60:	464080e7          	jalr	1124(ra) # 80003ec0 <iupdate>
    80005a64:	8552                	mv	a0,s4
    80005a66:	ffffe097          	auipc	ra,0xffffe
    80005a6a:	786080e7          	jalr	1926(ra) # 800041ec <iunlockput>
    80005a6e:	8526                	mv	a0,s1
    80005a70:	ffffe097          	auipc	ra,0xffffe
    80005a74:	77c080e7          	jalr	1916(ra) # 800041ec <iunlockput>
    80005a78:	bdcd                	j	8000596a <create+0x76>
    80005a7a:	8aaa                	mv	s5,a0
    80005a7c:	b5fd                	j	8000596a <create+0x76>

0000000080005a7e <sys_dup>:
    80005a7e:	7179                	addi	sp,sp,-48
    80005a80:	f406                	sd	ra,40(sp)
    80005a82:	f022                	sd	s0,32(sp)
    80005a84:	ec26                	sd	s1,24(sp)
    80005a86:	1800                	addi	s0,sp,48
    80005a88:	fd840613          	addi	a2,s0,-40
    80005a8c:	4581                	li	a1,0
    80005a8e:	4501                	li	a0,0
    80005a90:	00000097          	auipc	ra,0x0
    80005a94:	dc2080e7          	jalr	-574(ra) # 80005852 <argfd>
    80005a98:	57fd                	li	a5,-1
    80005a9a:	02054363          	bltz	a0,80005ac0 <sys_dup+0x42>
    80005a9e:	fd843503          	ld	a0,-40(s0)
    80005aa2:	00000097          	auipc	ra,0x0
    80005aa6:	e10080e7          	jalr	-496(ra) # 800058b2 <fdalloc>
    80005aaa:	84aa                	mv	s1,a0
    80005aac:	57fd                	li	a5,-1
    80005aae:	00054963          	bltz	a0,80005ac0 <sys_dup+0x42>
    80005ab2:	fd843503          	ld	a0,-40(s0)
    80005ab6:	fffff097          	auipc	ra,0xfffff
    80005aba:	310080e7          	jalr	784(ra) # 80004dc6 <filedup>
    80005abe:	87a6                	mv	a5,s1
    80005ac0:	853e                	mv	a0,a5
    80005ac2:	70a2                	ld	ra,40(sp)
    80005ac4:	7402                	ld	s0,32(sp)
    80005ac6:	64e2                	ld	s1,24(sp)
    80005ac8:	6145                	addi	sp,sp,48
    80005aca:	8082                	ret

0000000080005acc <sys_read>:
    80005acc:	7179                	addi	sp,sp,-48
    80005ace:	f406                	sd	ra,40(sp)
    80005ad0:	f022                	sd	s0,32(sp)
    80005ad2:	1800                	addi	s0,sp,48
    80005ad4:	00003717          	auipc	a4,0x3
    80005ad8:	e2070713          	addi	a4,a4,-480 # 800088f4 <someyuckcounts>
    80005adc:	431c                	lw	a5,0(a4)
    80005ade:	2785                	addiw	a5,a5,1
    80005ae0:	c31c                	sw	a5,0(a4)
    80005ae2:	fd840593          	addi	a1,s0,-40
    80005ae6:	4505                	li	a0,1
    80005ae8:	ffffe097          	auipc	ra,0xffffe
    80005aec:	8ba080e7          	jalr	-1862(ra) # 800033a2 <argaddr>
    80005af0:	fe440593          	addi	a1,s0,-28
    80005af4:	4509                	li	a0,2
    80005af6:	ffffe097          	auipc	ra,0xffffe
    80005afa:	88c080e7          	jalr	-1908(ra) # 80003382 <argint>
    80005afe:	fe840613          	addi	a2,s0,-24
    80005b02:	4581                	li	a1,0
    80005b04:	4501                	li	a0,0
    80005b06:	00000097          	auipc	ra,0x0
    80005b0a:	d4c080e7          	jalr	-692(ra) # 80005852 <argfd>
    80005b0e:	87aa                	mv	a5,a0
    80005b10:	557d                	li	a0,-1
    80005b12:	0007cc63          	bltz	a5,80005b2a <sys_read+0x5e>
    80005b16:	fe442603          	lw	a2,-28(s0)
    80005b1a:	fd843583          	ld	a1,-40(s0)
    80005b1e:	fe843503          	ld	a0,-24(s0)
    80005b22:	fffff097          	auipc	ra,0xfffff
    80005b26:	430080e7          	jalr	1072(ra) # 80004f52 <fileread>
    80005b2a:	70a2                	ld	ra,40(sp)
    80005b2c:	7402                	ld	s0,32(sp)
    80005b2e:	6145                	addi	sp,sp,48
    80005b30:	8082                	ret

0000000080005b32 <sys_write>:
    80005b32:	7179                	addi	sp,sp,-48
    80005b34:	f406                	sd	ra,40(sp)
    80005b36:	f022                	sd	s0,32(sp)
    80005b38:	1800                	addi	s0,sp,48
    80005b3a:	fd840593          	addi	a1,s0,-40
    80005b3e:	4505                	li	a0,1
    80005b40:	ffffe097          	auipc	ra,0xffffe
    80005b44:	862080e7          	jalr	-1950(ra) # 800033a2 <argaddr>
    80005b48:	fe440593          	addi	a1,s0,-28
    80005b4c:	4509                	li	a0,2
    80005b4e:	ffffe097          	auipc	ra,0xffffe
    80005b52:	834080e7          	jalr	-1996(ra) # 80003382 <argint>
    80005b56:	fe840613          	addi	a2,s0,-24
    80005b5a:	4581                	li	a1,0
    80005b5c:	4501                	li	a0,0
    80005b5e:	00000097          	auipc	ra,0x0
    80005b62:	cf4080e7          	jalr	-780(ra) # 80005852 <argfd>
    80005b66:	87aa                	mv	a5,a0
    80005b68:	557d                	li	a0,-1
    80005b6a:	0007cc63          	bltz	a5,80005b82 <sys_write+0x50>
    80005b6e:	fe442603          	lw	a2,-28(s0)
    80005b72:	fd843583          	ld	a1,-40(s0)
    80005b76:	fe843503          	ld	a0,-24(s0)
    80005b7a:	fffff097          	auipc	ra,0xfffff
    80005b7e:	49a080e7          	jalr	1178(ra) # 80005014 <filewrite>
    80005b82:	70a2                	ld	ra,40(sp)
    80005b84:	7402                	ld	s0,32(sp)
    80005b86:	6145                	addi	sp,sp,48
    80005b88:	8082                	ret

0000000080005b8a <sys_close>:
    80005b8a:	1101                	addi	sp,sp,-32
    80005b8c:	ec06                	sd	ra,24(sp)
    80005b8e:	e822                	sd	s0,16(sp)
    80005b90:	1000                	addi	s0,sp,32
    80005b92:	fe040613          	addi	a2,s0,-32
    80005b96:	fec40593          	addi	a1,s0,-20
    80005b9a:	4501                	li	a0,0
    80005b9c:	00000097          	auipc	ra,0x0
    80005ba0:	cb6080e7          	jalr	-842(ra) # 80005852 <argfd>
    80005ba4:	57fd                	li	a5,-1
    80005ba6:	02054563          	bltz	a0,80005bd0 <sys_close+0x46>
    80005baa:	ffffc097          	auipc	ra,0xffffc
    80005bae:	e02080e7          	jalr	-510(ra) # 800019ac <myproc>
    80005bb2:	fec42783          	lw	a5,-20(s0)
    80005bb6:	02278793          	addi	a5,a5,34
    80005bba:	078e                	slli	a5,a5,0x3
    80005bbc:	97aa                	add	a5,a5,a0
    80005bbe:	0007b023          	sd	zero,0(a5)
    80005bc2:	fe043503          	ld	a0,-32(s0)
    80005bc6:	fffff097          	auipc	ra,0xfffff
    80005bca:	252080e7          	jalr	594(ra) # 80004e18 <fileclose>
    80005bce:	4781                	li	a5,0
    80005bd0:	853e                	mv	a0,a5
    80005bd2:	60e2                	ld	ra,24(sp)
    80005bd4:	6442                	ld	s0,16(sp)
    80005bd6:	6105                	addi	sp,sp,32
    80005bd8:	8082                	ret

0000000080005bda <sys_fstat>:
    80005bda:	1101                	addi	sp,sp,-32
    80005bdc:	ec06                	sd	ra,24(sp)
    80005bde:	e822                	sd	s0,16(sp)
    80005be0:	1000                	addi	s0,sp,32
    80005be2:	fe040593          	addi	a1,s0,-32
    80005be6:	4505                	li	a0,1
    80005be8:	ffffd097          	auipc	ra,0xffffd
    80005bec:	7ba080e7          	jalr	1978(ra) # 800033a2 <argaddr>
    80005bf0:	fe840613          	addi	a2,s0,-24
    80005bf4:	4581                	li	a1,0
    80005bf6:	4501                	li	a0,0
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	c5a080e7          	jalr	-934(ra) # 80005852 <argfd>
    80005c00:	87aa                	mv	a5,a0
    80005c02:	557d                	li	a0,-1
    80005c04:	0007ca63          	bltz	a5,80005c18 <sys_fstat+0x3e>
    80005c08:	fe043583          	ld	a1,-32(s0)
    80005c0c:	fe843503          	ld	a0,-24(s0)
    80005c10:	fffff097          	auipc	ra,0xfffff
    80005c14:	2d0080e7          	jalr	720(ra) # 80004ee0 <filestat>
    80005c18:	60e2                	ld	ra,24(sp)
    80005c1a:	6442                	ld	s0,16(sp)
    80005c1c:	6105                	addi	sp,sp,32
    80005c1e:	8082                	ret

0000000080005c20 <sys_link>:
    80005c20:	7169                	addi	sp,sp,-304
    80005c22:	f606                	sd	ra,296(sp)
    80005c24:	f222                	sd	s0,288(sp)
    80005c26:	ee26                	sd	s1,280(sp)
    80005c28:	ea4a                	sd	s2,272(sp)
    80005c2a:	1a00                	addi	s0,sp,304
    80005c2c:	08000613          	li	a2,128
    80005c30:	ed040593          	addi	a1,s0,-304
    80005c34:	4501                	li	a0,0
    80005c36:	ffffd097          	auipc	ra,0xffffd
    80005c3a:	78c080e7          	jalr	1932(ra) # 800033c2 <argstr>
    80005c3e:	57fd                	li	a5,-1
    80005c40:	10054e63          	bltz	a0,80005d5c <sys_link+0x13c>
    80005c44:	08000613          	li	a2,128
    80005c48:	f5040593          	addi	a1,s0,-176
    80005c4c:	4505                	li	a0,1
    80005c4e:	ffffd097          	auipc	ra,0xffffd
    80005c52:	774080e7          	jalr	1908(ra) # 800033c2 <argstr>
    80005c56:	57fd                	li	a5,-1
    80005c58:	10054263          	bltz	a0,80005d5c <sys_link+0x13c>
    80005c5c:	fffff097          	auipc	ra,0xfffff
    80005c60:	cf0080e7          	jalr	-784(ra) # 8000494c <begin_op>
    80005c64:	ed040513          	addi	a0,s0,-304
    80005c68:	fffff097          	auipc	ra,0xfffff
    80005c6c:	ac8080e7          	jalr	-1336(ra) # 80004730 <namei>
    80005c70:	84aa                	mv	s1,a0
    80005c72:	c551                	beqz	a0,80005cfe <sys_link+0xde>
    80005c74:	ffffe097          	auipc	ra,0xffffe
    80005c78:	316080e7          	jalr	790(ra) # 80003f8a <ilock>
    80005c7c:	04449703          	lh	a4,68(s1)
    80005c80:	4785                	li	a5,1
    80005c82:	08f70463          	beq	a4,a5,80005d0a <sys_link+0xea>
    80005c86:	04a4d783          	lhu	a5,74(s1)
    80005c8a:	2785                	addiw	a5,a5,1
    80005c8c:	04f49523          	sh	a5,74(s1)
    80005c90:	8526                	mv	a0,s1
    80005c92:	ffffe097          	auipc	ra,0xffffe
    80005c96:	22e080e7          	jalr	558(ra) # 80003ec0 <iupdate>
    80005c9a:	8526                	mv	a0,s1
    80005c9c:	ffffe097          	auipc	ra,0xffffe
    80005ca0:	3b0080e7          	jalr	944(ra) # 8000404c <iunlock>
    80005ca4:	fd040593          	addi	a1,s0,-48
    80005ca8:	f5040513          	addi	a0,s0,-176
    80005cac:	fffff097          	auipc	ra,0xfffff
    80005cb0:	aa2080e7          	jalr	-1374(ra) # 8000474e <nameiparent>
    80005cb4:	892a                	mv	s2,a0
    80005cb6:	c935                	beqz	a0,80005d2a <sys_link+0x10a>
    80005cb8:	ffffe097          	auipc	ra,0xffffe
    80005cbc:	2d2080e7          	jalr	722(ra) # 80003f8a <ilock>
    80005cc0:	00092703          	lw	a4,0(s2)
    80005cc4:	409c                	lw	a5,0(s1)
    80005cc6:	04f71d63          	bne	a4,a5,80005d20 <sys_link+0x100>
    80005cca:	40d0                	lw	a2,4(s1)
    80005ccc:	fd040593          	addi	a1,s0,-48
    80005cd0:	854a                	mv	a0,s2
    80005cd2:	fffff097          	auipc	ra,0xfffff
    80005cd6:	9ac080e7          	jalr	-1620(ra) # 8000467e <dirlink>
    80005cda:	04054363          	bltz	a0,80005d20 <sys_link+0x100>
    80005cde:	854a                	mv	a0,s2
    80005ce0:	ffffe097          	auipc	ra,0xffffe
    80005ce4:	50c080e7          	jalr	1292(ra) # 800041ec <iunlockput>
    80005ce8:	8526                	mv	a0,s1
    80005cea:	ffffe097          	auipc	ra,0xffffe
    80005cee:	45a080e7          	jalr	1114(ra) # 80004144 <iput>
    80005cf2:	fffff097          	auipc	ra,0xfffff
    80005cf6:	cda080e7          	jalr	-806(ra) # 800049cc <end_op>
    80005cfa:	4781                	li	a5,0
    80005cfc:	a085                	j	80005d5c <sys_link+0x13c>
    80005cfe:	fffff097          	auipc	ra,0xfffff
    80005d02:	cce080e7          	jalr	-818(ra) # 800049cc <end_op>
    80005d06:	57fd                	li	a5,-1
    80005d08:	a891                	j	80005d5c <sys_link+0x13c>
    80005d0a:	8526                	mv	a0,s1
    80005d0c:	ffffe097          	auipc	ra,0xffffe
    80005d10:	4e0080e7          	jalr	1248(ra) # 800041ec <iunlockput>
    80005d14:	fffff097          	auipc	ra,0xfffff
    80005d18:	cb8080e7          	jalr	-840(ra) # 800049cc <end_op>
    80005d1c:	57fd                	li	a5,-1
    80005d1e:	a83d                	j	80005d5c <sys_link+0x13c>
    80005d20:	854a                	mv	a0,s2
    80005d22:	ffffe097          	auipc	ra,0xffffe
    80005d26:	4ca080e7          	jalr	1226(ra) # 800041ec <iunlockput>
    80005d2a:	8526                	mv	a0,s1
    80005d2c:	ffffe097          	auipc	ra,0xffffe
    80005d30:	25e080e7          	jalr	606(ra) # 80003f8a <ilock>
    80005d34:	04a4d783          	lhu	a5,74(s1)
    80005d38:	37fd                	addiw	a5,a5,-1
    80005d3a:	04f49523          	sh	a5,74(s1)
    80005d3e:	8526                	mv	a0,s1
    80005d40:	ffffe097          	auipc	ra,0xffffe
    80005d44:	180080e7          	jalr	384(ra) # 80003ec0 <iupdate>
    80005d48:	8526                	mv	a0,s1
    80005d4a:	ffffe097          	auipc	ra,0xffffe
    80005d4e:	4a2080e7          	jalr	1186(ra) # 800041ec <iunlockput>
    80005d52:	fffff097          	auipc	ra,0xfffff
    80005d56:	c7a080e7          	jalr	-902(ra) # 800049cc <end_op>
    80005d5a:	57fd                	li	a5,-1
    80005d5c:	853e                	mv	a0,a5
    80005d5e:	70b2                	ld	ra,296(sp)
    80005d60:	7412                	ld	s0,288(sp)
    80005d62:	64f2                	ld	s1,280(sp)
    80005d64:	6952                	ld	s2,272(sp)
    80005d66:	6155                	addi	sp,sp,304
    80005d68:	8082                	ret

0000000080005d6a <sys_unlink>:
    80005d6a:	7151                	addi	sp,sp,-240
    80005d6c:	f586                	sd	ra,232(sp)
    80005d6e:	f1a2                	sd	s0,224(sp)
    80005d70:	eda6                	sd	s1,216(sp)
    80005d72:	e9ca                	sd	s2,208(sp)
    80005d74:	e5ce                	sd	s3,200(sp)
    80005d76:	1980                	addi	s0,sp,240
    80005d78:	08000613          	li	a2,128
    80005d7c:	f3040593          	addi	a1,s0,-208
    80005d80:	4501                	li	a0,0
    80005d82:	ffffd097          	auipc	ra,0xffffd
    80005d86:	640080e7          	jalr	1600(ra) # 800033c2 <argstr>
    80005d8a:	18054163          	bltz	a0,80005f0c <sys_unlink+0x1a2>
    80005d8e:	fffff097          	auipc	ra,0xfffff
    80005d92:	bbe080e7          	jalr	-1090(ra) # 8000494c <begin_op>
    80005d96:	fb040593          	addi	a1,s0,-80
    80005d9a:	f3040513          	addi	a0,s0,-208
    80005d9e:	fffff097          	auipc	ra,0xfffff
    80005da2:	9b0080e7          	jalr	-1616(ra) # 8000474e <nameiparent>
    80005da6:	84aa                	mv	s1,a0
    80005da8:	c979                	beqz	a0,80005e7e <sys_unlink+0x114>
    80005daa:	ffffe097          	auipc	ra,0xffffe
    80005dae:	1e0080e7          	jalr	480(ra) # 80003f8a <ilock>
    80005db2:	00003597          	auipc	a1,0x3
    80005db6:	96e58593          	addi	a1,a1,-1682 # 80008720 <syscalls+0x2c0>
    80005dba:	fb040513          	addi	a0,s0,-80
    80005dbe:	ffffe097          	auipc	ra,0xffffe
    80005dc2:	696080e7          	jalr	1686(ra) # 80004454 <namecmp>
    80005dc6:	14050a63          	beqz	a0,80005f1a <sys_unlink+0x1b0>
    80005dca:	00003597          	auipc	a1,0x3
    80005dce:	95e58593          	addi	a1,a1,-1698 # 80008728 <syscalls+0x2c8>
    80005dd2:	fb040513          	addi	a0,s0,-80
    80005dd6:	ffffe097          	auipc	ra,0xffffe
    80005dda:	67e080e7          	jalr	1662(ra) # 80004454 <namecmp>
    80005dde:	12050e63          	beqz	a0,80005f1a <sys_unlink+0x1b0>
    80005de2:	f2c40613          	addi	a2,s0,-212
    80005de6:	fb040593          	addi	a1,s0,-80
    80005dea:	8526                	mv	a0,s1
    80005dec:	ffffe097          	auipc	ra,0xffffe
    80005df0:	682080e7          	jalr	1666(ra) # 8000446e <dirlookup>
    80005df4:	892a                	mv	s2,a0
    80005df6:	12050263          	beqz	a0,80005f1a <sys_unlink+0x1b0>
    80005dfa:	ffffe097          	auipc	ra,0xffffe
    80005dfe:	190080e7          	jalr	400(ra) # 80003f8a <ilock>
    80005e02:	04a91783          	lh	a5,74(s2)
    80005e06:	08f05263          	blez	a5,80005e8a <sys_unlink+0x120>
    80005e0a:	04491703          	lh	a4,68(s2)
    80005e0e:	4785                	li	a5,1
    80005e10:	08f70563          	beq	a4,a5,80005e9a <sys_unlink+0x130>
    80005e14:	4641                	li	a2,16
    80005e16:	4581                	li	a1,0
    80005e18:	fc040513          	addi	a0,s0,-64
    80005e1c:	ffffb097          	auipc	ra,0xffffb
    80005e20:	eb6080e7          	jalr	-330(ra) # 80000cd2 <memset>
    80005e24:	4741                	li	a4,16
    80005e26:	f2c42683          	lw	a3,-212(s0)
    80005e2a:	fc040613          	addi	a2,s0,-64
    80005e2e:	4581                	li	a1,0
    80005e30:	8526                	mv	a0,s1
    80005e32:	ffffe097          	auipc	ra,0xffffe
    80005e36:	504080e7          	jalr	1284(ra) # 80004336 <writei>
    80005e3a:	47c1                	li	a5,16
    80005e3c:	0af51563          	bne	a0,a5,80005ee6 <sys_unlink+0x17c>
    80005e40:	04491703          	lh	a4,68(s2)
    80005e44:	4785                	li	a5,1
    80005e46:	0af70863          	beq	a4,a5,80005ef6 <sys_unlink+0x18c>
    80005e4a:	8526                	mv	a0,s1
    80005e4c:	ffffe097          	auipc	ra,0xffffe
    80005e50:	3a0080e7          	jalr	928(ra) # 800041ec <iunlockput>
    80005e54:	04a95783          	lhu	a5,74(s2)
    80005e58:	37fd                	addiw	a5,a5,-1
    80005e5a:	04f91523          	sh	a5,74(s2)
    80005e5e:	854a                	mv	a0,s2
    80005e60:	ffffe097          	auipc	ra,0xffffe
    80005e64:	060080e7          	jalr	96(ra) # 80003ec0 <iupdate>
    80005e68:	854a                	mv	a0,s2
    80005e6a:	ffffe097          	auipc	ra,0xffffe
    80005e6e:	382080e7          	jalr	898(ra) # 800041ec <iunlockput>
    80005e72:	fffff097          	auipc	ra,0xfffff
    80005e76:	b5a080e7          	jalr	-1190(ra) # 800049cc <end_op>
    80005e7a:	4501                	li	a0,0
    80005e7c:	a84d                	j	80005f2e <sys_unlink+0x1c4>
    80005e7e:	fffff097          	auipc	ra,0xfffff
    80005e82:	b4e080e7          	jalr	-1202(ra) # 800049cc <end_op>
    80005e86:	557d                	li	a0,-1
    80005e88:	a05d                	j	80005f2e <sys_unlink+0x1c4>
    80005e8a:	00003517          	auipc	a0,0x3
    80005e8e:	8a650513          	addi	a0,a0,-1882 # 80008730 <syscalls+0x2d0>
    80005e92:	ffffa097          	auipc	ra,0xffffa
    80005e96:	6ac080e7          	jalr	1708(ra) # 8000053e <panic>
    80005e9a:	04c92703          	lw	a4,76(s2)
    80005e9e:	02000793          	li	a5,32
    80005ea2:	f6e7f9e3          	bgeu	a5,a4,80005e14 <sys_unlink+0xaa>
    80005ea6:	02000993          	li	s3,32
    80005eaa:	4741                	li	a4,16
    80005eac:	86ce                	mv	a3,s3
    80005eae:	f1840613          	addi	a2,s0,-232
    80005eb2:	4581                	li	a1,0
    80005eb4:	854a                	mv	a0,s2
    80005eb6:	ffffe097          	auipc	ra,0xffffe
    80005eba:	388080e7          	jalr	904(ra) # 8000423e <readi>
    80005ebe:	47c1                	li	a5,16
    80005ec0:	00f51b63          	bne	a0,a5,80005ed6 <sys_unlink+0x16c>
    80005ec4:	f1845783          	lhu	a5,-232(s0)
    80005ec8:	e7a1                	bnez	a5,80005f10 <sys_unlink+0x1a6>
    80005eca:	29c1                	addiw	s3,s3,16
    80005ecc:	04c92783          	lw	a5,76(s2)
    80005ed0:	fcf9ede3          	bltu	s3,a5,80005eaa <sys_unlink+0x140>
    80005ed4:	b781                	j	80005e14 <sys_unlink+0xaa>
    80005ed6:	00003517          	auipc	a0,0x3
    80005eda:	87250513          	addi	a0,a0,-1934 # 80008748 <syscalls+0x2e8>
    80005ede:	ffffa097          	auipc	ra,0xffffa
    80005ee2:	660080e7          	jalr	1632(ra) # 8000053e <panic>
    80005ee6:	00003517          	auipc	a0,0x3
    80005eea:	87a50513          	addi	a0,a0,-1926 # 80008760 <syscalls+0x300>
    80005eee:	ffffa097          	auipc	ra,0xffffa
    80005ef2:	650080e7          	jalr	1616(ra) # 8000053e <panic>
    80005ef6:	04a4d783          	lhu	a5,74(s1)
    80005efa:	37fd                	addiw	a5,a5,-1
    80005efc:	04f49523          	sh	a5,74(s1)
    80005f00:	8526                	mv	a0,s1
    80005f02:	ffffe097          	auipc	ra,0xffffe
    80005f06:	fbe080e7          	jalr	-66(ra) # 80003ec0 <iupdate>
    80005f0a:	b781                	j	80005e4a <sys_unlink+0xe0>
    80005f0c:	557d                	li	a0,-1
    80005f0e:	a005                	j	80005f2e <sys_unlink+0x1c4>
    80005f10:	854a                	mv	a0,s2
    80005f12:	ffffe097          	auipc	ra,0xffffe
    80005f16:	2da080e7          	jalr	730(ra) # 800041ec <iunlockput>
    80005f1a:	8526                	mv	a0,s1
    80005f1c:	ffffe097          	auipc	ra,0xffffe
    80005f20:	2d0080e7          	jalr	720(ra) # 800041ec <iunlockput>
    80005f24:	fffff097          	auipc	ra,0xfffff
    80005f28:	aa8080e7          	jalr	-1368(ra) # 800049cc <end_op>
    80005f2c:	557d                	li	a0,-1
    80005f2e:	70ae                	ld	ra,232(sp)
    80005f30:	740e                	ld	s0,224(sp)
    80005f32:	64ee                	ld	s1,216(sp)
    80005f34:	694e                	ld	s2,208(sp)
    80005f36:	69ae                	ld	s3,200(sp)
    80005f38:	616d                	addi	sp,sp,240
    80005f3a:	8082                	ret

0000000080005f3c <sys_open>:
    80005f3c:	7131                	addi	sp,sp,-192
    80005f3e:	fd06                	sd	ra,184(sp)
    80005f40:	f922                	sd	s0,176(sp)
    80005f42:	f526                	sd	s1,168(sp)
    80005f44:	f14a                	sd	s2,160(sp)
    80005f46:	ed4e                	sd	s3,152(sp)
    80005f48:	0180                	addi	s0,sp,192
    80005f4a:	f4c40593          	addi	a1,s0,-180
    80005f4e:	4505                	li	a0,1
    80005f50:	ffffd097          	auipc	ra,0xffffd
    80005f54:	432080e7          	jalr	1074(ra) # 80003382 <argint>
    80005f58:	08000613          	li	a2,128
    80005f5c:	f5040593          	addi	a1,s0,-176
    80005f60:	4501                	li	a0,0
    80005f62:	ffffd097          	auipc	ra,0xffffd
    80005f66:	460080e7          	jalr	1120(ra) # 800033c2 <argstr>
    80005f6a:	87aa                	mv	a5,a0
    80005f6c:	557d                	li	a0,-1
    80005f6e:	0a07c963          	bltz	a5,80006020 <sys_open+0xe4>
    80005f72:	fffff097          	auipc	ra,0xfffff
    80005f76:	9da080e7          	jalr	-1574(ra) # 8000494c <begin_op>
    80005f7a:	f4c42783          	lw	a5,-180(s0)
    80005f7e:	2007f793          	andi	a5,a5,512
    80005f82:	cfc5                	beqz	a5,8000603a <sys_open+0xfe>
    80005f84:	4681                	li	a3,0
    80005f86:	4601                	li	a2,0
    80005f88:	4589                	li	a1,2
    80005f8a:	f5040513          	addi	a0,s0,-176
    80005f8e:	00000097          	auipc	ra,0x0
    80005f92:	966080e7          	jalr	-1690(ra) # 800058f4 <create>
    80005f96:	84aa                	mv	s1,a0
    80005f98:	c959                	beqz	a0,8000602e <sys_open+0xf2>
    80005f9a:	04449703          	lh	a4,68(s1)
    80005f9e:	478d                	li	a5,3
    80005fa0:	00f71763          	bne	a4,a5,80005fae <sys_open+0x72>
    80005fa4:	0464d703          	lhu	a4,70(s1)
    80005fa8:	47a5                	li	a5,9
    80005faa:	0ce7ed63          	bltu	a5,a4,80006084 <sys_open+0x148>
    80005fae:	fffff097          	auipc	ra,0xfffff
    80005fb2:	dae080e7          	jalr	-594(ra) # 80004d5c <filealloc>
    80005fb6:	89aa                	mv	s3,a0
    80005fb8:	10050363          	beqz	a0,800060be <sys_open+0x182>
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	8f6080e7          	jalr	-1802(ra) # 800058b2 <fdalloc>
    80005fc4:	892a                	mv	s2,a0
    80005fc6:	0e054763          	bltz	a0,800060b4 <sys_open+0x178>
    80005fca:	04449703          	lh	a4,68(s1)
    80005fce:	478d                	li	a5,3
    80005fd0:	0cf70563          	beq	a4,a5,8000609a <sys_open+0x15e>
    80005fd4:	4789                	li	a5,2
    80005fd6:	00f9a023          	sw	a5,0(s3)
    80005fda:	0209a023          	sw	zero,32(s3)
    80005fde:	0099bc23          	sd	s1,24(s3)
    80005fe2:	f4c42783          	lw	a5,-180(s0)
    80005fe6:	0017c713          	xori	a4,a5,1
    80005fea:	8b05                	andi	a4,a4,1
    80005fec:	00e98423          	sb	a4,8(s3)
    80005ff0:	0037f713          	andi	a4,a5,3
    80005ff4:	00e03733          	snez	a4,a4
    80005ff8:	00e984a3          	sb	a4,9(s3)
    80005ffc:	4007f793          	andi	a5,a5,1024
    80006000:	c791                	beqz	a5,8000600c <sys_open+0xd0>
    80006002:	04449703          	lh	a4,68(s1)
    80006006:	4789                	li	a5,2
    80006008:	0af70063          	beq	a4,a5,800060a8 <sys_open+0x16c>
    8000600c:	8526                	mv	a0,s1
    8000600e:	ffffe097          	auipc	ra,0xffffe
    80006012:	03e080e7          	jalr	62(ra) # 8000404c <iunlock>
    80006016:	fffff097          	auipc	ra,0xfffff
    8000601a:	9b6080e7          	jalr	-1610(ra) # 800049cc <end_op>
    8000601e:	854a                	mv	a0,s2
    80006020:	70ea                	ld	ra,184(sp)
    80006022:	744a                	ld	s0,176(sp)
    80006024:	74aa                	ld	s1,168(sp)
    80006026:	790a                	ld	s2,160(sp)
    80006028:	69ea                	ld	s3,152(sp)
    8000602a:	6129                	addi	sp,sp,192
    8000602c:	8082                	ret
    8000602e:	fffff097          	auipc	ra,0xfffff
    80006032:	99e080e7          	jalr	-1634(ra) # 800049cc <end_op>
    80006036:	557d                	li	a0,-1
    80006038:	b7e5                	j	80006020 <sys_open+0xe4>
    8000603a:	f5040513          	addi	a0,s0,-176
    8000603e:	ffffe097          	auipc	ra,0xffffe
    80006042:	6f2080e7          	jalr	1778(ra) # 80004730 <namei>
    80006046:	84aa                	mv	s1,a0
    80006048:	c905                	beqz	a0,80006078 <sys_open+0x13c>
    8000604a:	ffffe097          	auipc	ra,0xffffe
    8000604e:	f40080e7          	jalr	-192(ra) # 80003f8a <ilock>
    80006052:	04449703          	lh	a4,68(s1)
    80006056:	4785                	li	a5,1
    80006058:	f4f711e3          	bne	a4,a5,80005f9a <sys_open+0x5e>
    8000605c:	f4c42783          	lw	a5,-180(s0)
    80006060:	d7b9                	beqz	a5,80005fae <sys_open+0x72>
    80006062:	8526                	mv	a0,s1
    80006064:	ffffe097          	auipc	ra,0xffffe
    80006068:	188080e7          	jalr	392(ra) # 800041ec <iunlockput>
    8000606c:	fffff097          	auipc	ra,0xfffff
    80006070:	960080e7          	jalr	-1696(ra) # 800049cc <end_op>
    80006074:	557d                	li	a0,-1
    80006076:	b76d                	j	80006020 <sys_open+0xe4>
    80006078:	fffff097          	auipc	ra,0xfffff
    8000607c:	954080e7          	jalr	-1708(ra) # 800049cc <end_op>
    80006080:	557d                	li	a0,-1
    80006082:	bf79                	j	80006020 <sys_open+0xe4>
    80006084:	8526                	mv	a0,s1
    80006086:	ffffe097          	auipc	ra,0xffffe
    8000608a:	166080e7          	jalr	358(ra) # 800041ec <iunlockput>
    8000608e:	fffff097          	auipc	ra,0xfffff
    80006092:	93e080e7          	jalr	-1730(ra) # 800049cc <end_op>
    80006096:	557d                	li	a0,-1
    80006098:	b761                	j	80006020 <sys_open+0xe4>
    8000609a:	00f9a023          	sw	a5,0(s3)
    8000609e:	04649783          	lh	a5,70(s1)
    800060a2:	02f99223          	sh	a5,36(s3)
    800060a6:	bf25                	j	80005fde <sys_open+0xa2>
    800060a8:	8526                	mv	a0,s1
    800060aa:	ffffe097          	auipc	ra,0xffffe
    800060ae:	fee080e7          	jalr	-18(ra) # 80004098 <itrunc>
    800060b2:	bfa9                	j	8000600c <sys_open+0xd0>
    800060b4:	854e                	mv	a0,s3
    800060b6:	fffff097          	auipc	ra,0xfffff
    800060ba:	d62080e7          	jalr	-670(ra) # 80004e18 <fileclose>
    800060be:	8526                	mv	a0,s1
    800060c0:	ffffe097          	auipc	ra,0xffffe
    800060c4:	12c080e7          	jalr	300(ra) # 800041ec <iunlockput>
    800060c8:	fffff097          	auipc	ra,0xfffff
    800060cc:	904080e7          	jalr	-1788(ra) # 800049cc <end_op>
    800060d0:	557d                	li	a0,-1
    800060d2:	b7b9                	j	80006020 <sys_open+0xe4>

00000000800060d4 <sys_mkdir>:
    800060d4:	7175                	addi	sp,sp,-144
    800060d6:	e506                	sd	ra,136(sp)
    800060d8:	e122                	sd	s0,128(sp)
    800060da:	0900                	addi	s0,sp,144
    800060dc:	fffff097          	auipc	ra,0xfffff
    800060e0:	870080e7          	jalr	-1936(ra) # 8000494c <begin_op>
    800060e4:	08000613          	li	a2,128
    800060e8:	f7040593          	addi	a1,s0,-144
    800060ec:	4501                	li	a0,0
    800060ee:	ffffd097          	auipc	ra,0xffffd
    800060f2:	2d4080e7          	jalr	724(ra) # 800033c2 <argstr>
    800060f6:	02054963          	bltz	a0,80006128 <sys_mkdir+0x54>
    800060fa:	4681                	li	a3,0
    800060fc:	4601                	li	a2,0
    800060fe:	4585                	li	a1,1
    80006100:	f7040513          	addi	a0,s0,-144
    80006104:	fffff097          	auipc	ra,0xfffff
    80006108:	7f0080e7          	jalr	2032(ra) # 800058f4 <create>
    8000610c:	cd11                	beqz	a0,80006128 <sys_mkdir+0x54>
    8000610e:	ffffe097          	auipc	ra,0xffffe
    80006112:	0de080e7          	jalr	222(ra) # 800041ec <iunlockput>
    80006116:	fffff097          	auipc	ra,0xfffff
    8000611a:	8b6080e7          	jalr	-1866(ra) # 800049cc <end_op>
    8000611e:	4501                	li	a0,0
    80006120:	60aa                	ld	ra,136(sp)
    80006122:	640a                	ld	s0,128(sp)
    80006124:	6149                	addi	sp,sp,144
    80006126:	8082                	ret
    80006128:	fffff097          	auipc	ra,0xfffff
    8000612c:	8a4080e7          	jalr	-1884(ra) # 800049cc <end_op>
    80006130:	557d                	li	a0,-1
    80006132:	b7fd                	j	80006120 <sys_mkdir+0x4c>

0000000080006134 <sys_mknod>:
    80006134:	7135                	addi	sp,sp,-160
    80006136:	ed06                	sd	ra,152(sp)
    80006138:	e922                	sd	s0,144(sp)
    8000613a:	1100                	addi	s0,sp,160
    8000613c:	fffff097          	auipc	ra,0xfffff
    80006140:	810080e7          	jalr	-2032(ra) # 8000494c <begin_op>
    80006144:	f6c40593          	addi	a1,s0,-148
    80006148:	4505                	li	a0,1
    8000614a:	ffffd097          	auipc	ra,0xffffd
    8000614e:	238080e7          	jalr	568(ra) # 80003382 <argint>
    80006152:	f6840593          	addi	a1,s0,-152
    80006156:	4509                	li	a0,2
    80006158:	ffffd097          	auipc	ra,0xffffd
    8000615c:	22a080e7          	jalr	554(ra) # 80003382 <argint>
    80006160:	08000613          	li	a2,128
    80006164:	f7040593          	addi	a1,s0,-144
    80006168:	4501                	li	a0,0
    8000616a:	ffffd097          	auipc	ra,0xffffd
    8000616e:	258080e7          	jalr	600(ra) # 800033c2 <argstr>
    80006172:	02054b63          	bltz	a0,800061a8 <sys_mknod+0x74>
    80006176:	f6841683          	lh	a3,-152(s0)
    8000617a:	f6c41603          	lh	a2,-148(s0)
    8000617e:	458d                	li	a1,3
    80006180:	f7040513          	addi	a0,s0,-144
    80006184:	fffff097          	auipc	ra,0xfffff
    80006188:	770080e7          	jalr	1904(ra) # 800058f4 <create>
    8000618c:	cd11                	beqz	a0,800061a8 <sys_mknod+0x74>
    8000618e:	ffffe097          	auipc	ra,0xffffe
    80006192:	05e080e7          	jalr	94(ra) # 800041ec <iunlockput>
    80006196:	fffff097          	auipc	ra,0xfffff
    8000619a:	836080e7          	jalr	-1994(ra) # 800049cc <end_op>
    8000619e:	4501                	li	a0,0
    800061a0:	60ea                	ld	ra,152(sp)
    800061a2:	644a                	ld	s0,144(sp)
    800061a4:	610d                	addi	sp,sp,160
    800061a6:	8082                	ret
    800061a8:	fffff097          	auipc	ra,0xfffff
    800061ac:	824080e7          	jalr	-2012(ra) # 800049cc <end_op>
    800061b0:	557d                	li	a0,-1
    800061b2:	b7fd                	j	800061a0 <sys_mknod+0x6c>

00000000800061b4 <sys_chdir>:
    800061b4:	7135                	addi	sp,sp,-160
    800061b6:	ed06                	sd	ra,152(sp)
    800061b8:	e922                	sd	s0,144(sp)
    800061ba:	e526                	sd	s1,136(sp)
    800061bc:	e14a                	sd	s2,128(sp)
    800061be:	1100                	addi	s0,sp,160
    800061c0:	ffffb097          	auipc	ra,0xffffb
    800061c4:	7ec080e7          	jalr	2028(ra) # 800019ac <myproc>
    800061c8:	892a                	mv	s2,a0
    800061ca:	ffffe097          	auipc	ra,0xffffe
    800061ce:	782080e7          	jalr	1922(ra) # 8000494c <begin_op>
    800061d2:	08000613          	li	a2,128
    800061d6:	f6040593          	addi	a1,s0,-160
    800061da:	4501                	li	a0,0
    800061dc:	ffffd097          	auipc	ra,0xffffd
    800061e0:	1e6080e7          	jalr	486(ra) # 800033c2 <argstr>
    800061e4:	04054b63          	bltz	a0,8000623a <sys_chdir+0x86>
    800061e8:	f6040513          	addi	a0,s0,-160
    800061ec:	ffffe097          	auipc	ra,0xffffe
    800061f0:	544080e7          	jalr	1348(ra) # 80004730 <namei>
    800061f4:	84aa                	mv	s1,a0
    800061f6:	c131                	beqz	a0,8000623a <sys_chdir+0x86>
    800061f8:	ffffe097          	auipc	ra,0xffffe
    800061fc:	d92080e7          	jalr	-622(ra) # 80003f8a <ilock>
    80006200:	04449703          	lh	a4,68(s1)
    80006204:	4785                	li	a5,1
    80006206:	04f71063          	bne	a4,a5,80006246 <sys_chdir+0x92>
    8000620a:	8526                	mv	a0,s1
    8000620c:	ffffe097          	auipc	ra,0xffffe
    80006210:	e40080e7          	jalr	-448(ra) # 8000404c <iunlock>
    80006214:	19093503          	ld	a0,400(s2)
    80006218:	ffffe097          	auipc	ra,0xffffe
    8000621c:	f2c080e7          	jalr	-212(ra) # 80004144 <iput>
    80006220:	ffffe097          	auipc	ra,0xffffe
    80006224:	7ac080e7          	jalr	1964(ra) # 800049cc <end_op>
    80006228:	18993823          	sd	s1,400(s2)
    8000622c:	4501                	li	a0,0
    8000622e:	60ea                	ld	ra,152(sp)
    80006230:	644a                	ld	s0,144(sp)
    80006232:	64aa                	ld	s1,136(sp)
    80006234:	690a                	ld	s2,128(sp)
    80006236:	610d                	addi	sp,sp,160
    80006238:	8082                	ret
    8000623a:	ffffe097          	auipc	ra,0xffffe
    8000623e:	792080e7          	jalr	1938(ra) # 800049cc <end_op>
    80006242:	557d                	li	a0,-1
    80006244:	b7ed                	j	8000622e <sys_chdir+0x7a>
    80006246:	8526                	mv	a0,s1
    80006248:	ffffe097          	auipc	ra,0xffffe
    8000624c:	fa4080e7          	jalr	-92(ra) # 800041ec <iunlockput>
    80006250:	ffffe097          	auipc	ra,0xffffe
    80006254:	77c080e7          	jalr	1916(ra) # 800049cc <end_op>
    80006258:	557d                	li	a0,-1
    8000625a:	bfd1                	j	8000622e <sys_chdir+0x7a>

000000008000625c <sys_exec>:
    8000625c:	7145                	addi	sp,sp,-464
    8000625e:	e786                	sd	ra,456(sp)
    80006260:	e3a2                	sd	s0,448(sp)
    80006262:	ff26                	sd	s1,440(sp)
    80006264:	fb4a                	sd	s2,432(sp)
    80006266:	f74e                	sd	s3,424(sp)
    80006268:	f352                	sd	s4,416(sp)
    8000626a:	ef56                	sd	s5,408(sp)
    8000626c:	0b80                	addi	s0,sp,464
    8000626e:	e3840593          	addi	a1,s0,-456
    80006272:	4505                	li	a0,1
    80006274:	ffffd097          	auipc	ra,0xffffd
    80006278:	12e080e7          	jalr	302(ra) # 800033a2 <argaddr>
    8000627c:	08000613          	li	a2,128
    80006280:	f4040593          	addi	a1,s0,-192
    80006284:	4501                	li	a0,0
    80006286:	ffffd097          	auipc	ra,0xffffd
    8000628a:	13c080e7          	jalr	316(ra) # 800033c2 <argstr>
    8000628e:	87aa                	mv	a5,a0
    80006290:	557d                	li	a0,-1
    80006292:	0c07c263          	bltz	a5,80006356 <sys_exec+0xfa>
    80006296:	10000613          	li	a2,256
    8000629a:	4581                	li	a1,0
    8000629c:	e4040513          	addi	a0,s0,-448
    800062a0:	ffffb097          	auipc	ra,0xffffb
    800062a4:	a32080e7          	jalr	-1486(ra) # 80000cd2 <memset>
    800062a8:	e4040493          	addi	s1,s0,-448
    800062ac:	89a6                	mv	s3,s1
    800062ae:	4901                	li	s2,0
    800062b0:	02000a13          	li	s4,32
    800062b4:	00090a9b          	sext.w	s5,s2
    800062b8:	00391793          	slli	a5,s2,0x3
    800062bc:	e3040593          	addi	a1,s0,-464
    800062c0:	e3843503          	ld	a0,-456(s0)
    800062c4:	953e                	add	a0,a0,a5
    800062c6:	ffffd097          	auipc	ra,0xffffd
    800062ca:	01e080e7          	jalr	30(ra) # 800032e4 <fetchaddr>
    800062ce:	02054a63          	bltz	a0,80006302 <sys_exec+0xa6>
    800062d2:	e3043783          	ld	a5,-464(s0)
    800062d6:	c3b9                	beqz	a5,8000631c <sys_exec+0xc0>
    800062d8:	ffffb097          	auipc	ra,0xffffb
    800062dc:	80e080e7          	jalr	-2034(ra) # 80000ae6 <kalloc>
    800062e0:	85aa                	mv	a1,a0
    800062e2:	00a9b023          	sd	a0,0(s3)
    800062e6:	cd11                	beqz	a0,80006302 <sys_exec+0xa6>
    800062e8:	6605                	lui	a2,0x1
    800062ea:	e3043503          	ld	a0,-464(s0)
    800062ee:	ffffd097          	auipc	ra,0xffffd
    800062f2:	048080e7          	jalr	72(ra) # 80003336 <fetchstr>
    800062f6:	00054663          	bltz	a0,80006302 <sys_exec+0xa6>
    800062fa:	0905                	addi	s2,s2,1
    800062fc:	09a1                	addi	s3,s3,8
    800062fe:	fb491be3          	bne	s2,s4,800062b4 <sys_exec+0x58>
    80006302:	10048913          	addi	s2,s1,256
    80006306:	6088                	ld	a0,0(s1)
    80006308:	c531                	beqz	a0,80006354 <sys_exec+0xf8>
    8000630a:	ffffa097          	auipc	ra,0xffffa
    8000630e:	6e0080e7          	jalr	1760(ra) # 800009ea <kfree>
    80006312:	04a1                	addi	s1,s1,8
    80006314:	ff2499e3          	bne	s1,s2,80006306 <sys_exec+0xaa>
    80006318:	557d                	li	a0,-1
    8000631a:	a835                	j	80006356 <sys_exec+0xfa>
    8000631c:	0a8e                	slli	s5,s5,0x3
    8000631e:	fc040793          	addi	a5,s0,-64
    80006322:	9abe                	add	s5,s5,a5
    80006324:	e80ab023          	sd	zero,-384(s5)
    80006328:	e4040593          	addi	a1,s0,-448
    8000632c:	f4040513          	addi	a0,s0,-192
    80006330:	fffff097          	auipc	ra,0xfffff
    80006334:	162080e7          	jalr	354(ra) # 80005492 <exec>
    80006338:	892a                	mv	s2,a0
    8000633a:	10048993          	addi	s3,s1,256
    8000633e:	6088                	ld	a0,0(s1)
    80006340:	c901                	beqz	a0,80006350 <sys_exec+0xf4>
    80006342:	ffffa097          	auipc	ra,0xffffa
    80006346:	6a8080e7          	jalr	1704(ra) # 800009ea <kfree>
    8000634a:	04a1                	addi	s1,s1,8
    8000634c:	ff3499e3          	bne	s1,s3,8000633e <sys_exec+0xe2>
    80006350:	854a                	mv	a0,s2
    80006352:	a011                	j	80006356 <sys_exec+0xfa>
    80006354:	557d                	li	a0,-1
    80006356:	60be                	ld	ra,456(sp)
    80006358:	641e                	ld	s0,448(sp)
    8000635a:	74fa                	ld	s1,440(sp)
    8000635c:	795a                	ld	s2,432(sp)
    8000635e:	79ba                	ld	s3,424(sp)
    80006360:	7a1a                	ld	s4,416(sp)
    80006362:	6afa                	ld	s5,408(sp)
    80006364:	6179                	addi	sp,sp,464
    80006366:	8082                	ret

0000000080006368 <sys_pipe>:
    80006368:	7139                	addi	sp,sp,-64
    8000636a:	fc06                	sd	ra,56(sp)
    8000636c:	f822                	sd	s0,48(sp)
    8000636e:	f426                	sd	s1,40(sp)
    80006370:	0080                	addi	s0,sp,64
    80006372:	ffffb097          	auipc	ra,0xffffb
    80006376:	63a080e7          	jalr	1594(ra) # 800019ac <myproc>
    8000637a:	84aa                	mv	s1,a0
    8000637c:	fd840593          	addi	a1,s0,-40
    80006380:	4501                	li	a0,0
    80006382:	ffffd097          	auipc	ra,0xffffd
    80006386:	020080e7          	jalr	32(ra) # 800033a2 <argaddr>
    8000638a:	fc840593          	addi	a1,s0,-56
    8000638e:	fd040513          	addi	a0,s0,-48
    80006392:	fffff097          	auipc	ra,0xfffff
    80006396:	db6080e7          	jalr	-586(ra) # 80005148 <pipealloc>
    8000639a:	57fd                	li	a5,-1
    8000639c:	0c054763          	bltz	a0,8000646a <sys_pipe+0x102>
    800063a0:	fcf42223          	sw	a5,-60(s0)
    800063a4:	fd043503          	ld	a0,-48(s0)
    800063a8:	fffff097          	auipc	ra,0xfffff
    800063ac:	50a080e7          	jalr	1290(ra) # 800058b2 <fdalloc>
    800063b0:	fca42223          	sw	a0,-60(s0)
    800063b4:	08054e63          	bltz	a0,80006450 <sys_pipe+0xe8>
    800063b8:	fc843503          	ld	a0,-56(s0)
    800063bc:	fffff097          	auipc	ra,0xfffff
    800063c0:	4f6080e7          	jalr	1270(ra) # 800058b2 <fdalloc>
    800063c4:	fca42023          	sw	a0,-64(s0)
    800063c8:	06054a63          	bltz	a0,8000643c <sys_pipe+0xd4>
    800063cc:	4691                	li	a3,4
    800063ce:	fc440613          	addi	a2,s0,-60
    800063d2:	fd843583          	ld	a1,-40(s0)
    800063d6:	68c8                	ld	a0,144(s1)
    800063d8:	ffffb097          	auipc	ra,0xffffb
    800063dc:	290080e7          	jalr	656(ra) # 80001668 <copyout>
    800063e0:	02054063          	bltz	a0,80006400 <sys_pipe+0x98>
    800063e4:	4691                	li	a3,4
    800063e6:	fc040613          	addi	a2,s0,-64
    800063ea:	fd843583          	ld	a1,-40(s0)
    800063ee:	0591                	addi	a1,a1,4
    800063f0:	68c8                	ld	a0,144(s1)
    800063f2:	ffffb097          	auipc	ra,0xffffb
    800063f6:	276080e7          	jalr	630(ra) # 80001668 <copyout>
    800063fa:	4781                	li	a5,0
    800063fc:	06055763          	bgez	a0,8000646a <sys_pipe+0x102>
    80006400:	fc442783          	lw	a5,-60(s0)
    80006404:	02278793          	addi	a5,a5,34
    80006408:	078e                	slli	a5,a5,0x3
    8000640a:	97a6                	add	a5,a5,s1
    8000640c:	0007b023          	sd	zero,0(a5)
    80006410:	fc042503          	lw	a0,-64(s0)
    80006414:	02250513          	addi	a0,a0,34
    80006418:	050e                	slli	a0,a0,0x3
    8000641a:	94aa                	add	s1,s1,a0
    8000641c:	0004b023          	sd	zero,0(s1)
    80006420:	fd043503          	ld	a0,-48(s0)
    80006424:	fffff097          	auipc	ra,0xfffff
    80006428:	9f4080e7          	jalr	-1548(ra) # 80004e18 <fileclose>
    8000642c:	fc843503          	ld	a0,-56(s0)
    80006430:	fffff097          	auipc	ra,0xfffff
    80006434:	9e8080e7          	jalr	-1560(ra) # 80004e18 <fileclose>
    80006438:	57fd                	li	a5,-1
    8000643a:	a805                	j	8000646a <sys_pipe+0x102>
    8000643c:	fc442783          	lw	a5,-60(s0)
    80006440:	0007c863          	bltz	a5,80006450 <sys_pipe+0xe8>
    80006444:	02278793          	addi	a5,a5,34
    80006448:	078e                	slli	a5,a5,0x3
    8000644a:	94be                	add	s1,s1,a5
    8000644c:	0004b023          	sd	zero,0(s1)
    80006450:	fd043503          	ld	a0,-48(s0)
    80006454:	fffff097          	auipc	ra,0xfffff
    80006458:	9c4080e7          	jalr	-1596(ra) # 80004e18 <fileclose>
    8000645c:	fc843503          	ld	a0,-56(s0)
    80006460:	fffff097          	auipc	ra,0xfffff
    80006464:	9b8080e7          	jalr	-1608(ra) # 80004e18 <fileclose>
    80006468:	57fd                	li	a5,-1
    8000646a:	853e                	mv	a0,a5
    8000646c:	70e2                	ld	ra,56(sp)
    8000646e:	7442                	ld	s0,48(sp)
    80006470:	74a2                	ld	s1,40(sp)
    80006472:	6121                	addi	sp,sp,64
    80006474:	8082                	ret

0000000080006476 <sys_getreadcount>:
    80006476:	1141                	addi	sp,sp,-16
    80006478:	e422                	sd	s0,8(sp)
    8000647a:	0800                	addi	s0,sp,16
    8000647c:	00002517          	auipc	a0,0x2
    80006480:	47852503          	lw	a0,1144(a0) # 800088f4 <someyuckcounts>
    80006484:	6422                	ld	s0,8(sp)
    80006486:	0141                	addi	sp,sp,16
    80006488:	8082                	ret

000000008000648a <sys_sigalarm>:
    8000648a:	1101                	addi	sp,sp,-32
    8000648c:	ec06                	sd	ra,24(sp)
    8000648e:	e822                	sd	s0,16(sp)
    80006490:	e426                	sd	s1,8(sp)
    80006492:	1000                	addi	s0,sp,32
    80006494:	ffffb097          	auipc	ra,0xffffb
    80006498:	518080e7          	jalr	1304(ra) # 800019ac <myproc>
    8000649c:	84aa                	mv	s1,a0
    8000649e:	03850593          	addi	a1,a0,56
    800064a2:	4501                	li	a0,0
    800064a4:	ffffd097          	auipc	ra,0xffffd
    800064a8:	efe080e7          	jalr	-258(ra) # 800033a2 <argaddr>
    800064ac:	04848593          	addi	a1,s1,72
    800064b0:	4505                	li	a0,1
    800064b2:	ffffd097          	auipc	ra,0xffffd
    800064b6:	ef0080e7          	jalr	-272(ra) # 800033a2 <argaddr>
    800064ba:	4501                	li	a0,0
    800064bc:	60e2                	ld	ra,24(sp)
    800064be:	6442                	ld	s0,16(sp)
    800064c0:	64a2                	ld	s1,8(sp)
    800064c2:	6105                	addi	sp,sp,32
    800064c4:	8082                	ret

00000000800064c6 <sys_sigreturn>:
    800064c6:	1101                	addi	sp,sp,-32
    800064c8:	ec06                	sd	ra,24(sp)
    800064ca:	e822                	sd	s0,16(sp)
    800064cc:	e426                	sd	s1,8(sp)
    800064ce:	1000                	addi	s0,sp,32
    800064d0:	ffffb097          	auipc	ra,0xffffb
    800064d4:	4dc080e7          	jalr	1244(ra) # 800019ac <myproc>
    800064d8:	84aa                	mv	s1,a0
    800064da:	6605                	lui	a2,0x1
    800064dc:	6d2c                	ld	a1,88(a0)
    800064de:	6d48                	ld	a0,152(a0)
    800064e0:	ffffb097          	auipc	ra,0xffffb
    800064e4:	84e080e7          	jalr	-1970(ra) # 80000d2e <memmove>
    800064e8:	0404b023          	sd	zero,64(s1)
    800064ec:	0404b823          	sd	zero,80(s1)
    800064f0:	6ca8                	ld	a0,88(s1)
    800064f2:	ffffa097          	auipc	ra,0xffffa
    800064f6:	4f8080e7          	jalr	1272(ra) # 800009ea <kfree>
    800064fa:	0404bc23          	sd	zero,88(s1)
    800064fe:	6cdc                	ld	a5,152(s1)
    80006500:	7ba8                	ld	a0,112(a5)
    80006502:	60e2                	ld	ra,24(sp)
    80006504:	6442                	ld	s0,16(sp)
    80006506:	64a2                	ld	s1,8(sp)
    80006508:	6105                	addi	sp,sp,32
    8000650a:	8082                	ret
    8000650c:	0000                	unimp
	...

0000000080006510 <kernelvec>:
    80006510:	7111                	addi	sp,sp,-256
    80006512:	e006                	sd	ra,0(sp)
    80006514:	e40a                	sd	sp,8(sp)
    80006516:	e80e                	sd	gp,16(sp)
    80006518:	ec12                	sd	tp,24(sp)
    8000651a:	f016                	sd	t0,32(sp)
    8000651c:	f41a                	sd	t1,40(sp)
    8000651e:	f81e                	sd	t2,48(sp)
    80006520:	fc22                	sd	s0,56(sp)
    80006522:	e0a6                	sd	s1,64(sp)
    80006524:	e4aa                	sd	a0,72(sp)
    80006526:	e8ae                	sd	a1,80(sp)
    80006528:	ecb2                	sd	a2,88(sp)
    8000652a:	f0b6                	sd	a3,96(sp)
    8000652c:	f4ba                	sd	a4,104(sp)
    8000652e:	f8be                	sd	a5,112(sp)
    80006530:	fcc2                	sd	a6,120(sp)
    80006532:	e146                	sd	a7,128(sp)
    80006534:	e54a                	sd	s2,136(sp)
    80006536:	e94e                	sd	s3,144(sp)
    80006538:	ed52                	sd	s4,152(sp)
    8000653a:	f156                	sd	s5,160(sp)
    8000653c:	f55a                	sd	s6,168(sp)
    8000653e:	f95e                	sd	s7,176(sp)
    80006540:	fd62                	sd	s8,184(sp)
    80006542:	e1e6                	sd	s9,192(sp)
    80006544:	e5ea                	sd	s10,200(sp)
    80006546:	e9ee                	sd	s11,208(sp)
    80006548:	edf2                	sd	t3,216(sp)
    8000654a:	f1f6                	sd	t4,224(sp)
    8000654c:	f5fa                	sd	t5,232(sp)
    8000654e:	f9fe                	sd	t6,240(sp)
    80006550:	997fc0ef          	jal	ra,80002ee6 <kerneltrap>
    80006554:	6082                	ld	ra,0(sp)
    80006556:	6122                	ld	sp,8(sp)
    80006558:	61c2                	ld	gp,16(sp)
    8000655a:	7282                	ld	t0,32(sp)
    8000655c:	7322                	ld	t1,40(sp)
    8000655e:	73c2                	ld	t2,48(sp)
    80006560:	7462                	ld	s0,56(sp)
    80006562:	6486                	ld	s1,64(sp)
    80006564:	6526                	ld	a0,72(sp)
    80006566:	65c6                	ld	a1,80(sp)
    80006568:	6666                	ld	a2,88(sp)
    8000656a:	7686                	ld	a3,96(sp)
    8000656c:	7726                	ld	a4,104(sp)
    8000656e:	77c6                	ld	a5,112(sp)
    80006570:	7866                	ld	a6,120(sp)
    80006572:	688a                	ld	a7,128(sp)
    80006574:	692a                	ld	s2,136(sp)
    80006576:	69ca                	ld	s3,144(sp)
    80006578:	6a6a                	ld	s4,152(sp)
    8000657a:	7a8a                	ld	s5,160(sp)
    8000657c:	7b2a                	ld	s6,168(sp)
    8000657e:	7bca                	ld	s7,176(sp)
    80006580:	7c6a                	ld	s8,184(sp)
    80006582:	6c8e                	ld	s9,192(sp)
    80006584:	6d2e                	ld	s10,200(sp)
    80006586:	6dce                	ld	s11,208(sp)
    80006588:	6e6e                	ld	t3,216(sp)
    8000658a:	7e8e                	ld	t4,224(sp)
    8000658c:	7f2e                	ld	t5,232(sp)
    8000658e:	7fce                	ld	t6,240(sp)
    80006590:	6111                	addi	sp,sp,256
    80006592:	10200073          	sret
    80006596:	00000013          	nop
    8000659a:	00000013          	nop
    8000659e:	0001                	nop

00000000800065a0 <timervec>:
    800065a0:	34051573          	csrrw	a0,mscratch,a0
    800065a4:	e10c                	sd	a1,0(a0)
    800065a6:	e510                	sd	a2,8(a0)
    800065a8:	e914                	sd	a3,16(a0)
    800065aa:	6d0c                	ld	a1,24(a0)
    800065ac:	7110                	ld	a2,32(a0)
    800065ae:	6194                	ld	a3,0(a1)
    800065b0:	96b2                	add	a3,a3,a2
    800065b2:	e194                	sd	a3,0(a1)
    800065b4:	4589                	li	a1,2
    800065b6:	14459073          	csrw	sip,a1
    800065ba:	6914                	ld	a3,16(a0)
    800065bc:	6510                	ld	a2,8(a0)
    800065be:	610c                	ld	a1,0(a0)
    800065c0:	34051573          	csrrw	a0,mscratch,a0
    800065c4:	30200073          	mret
	...

00000000800065ca <plicinit>:
    800065ca:	1141                	addi	sp,sp,-16
    800065cc:	e422                	sd	s0,8(sp)
    800065ce:	0800                	addi	s0,sp,16
    800065d0:	0c0007b7          	lui	a5,0xc000
    800065d4:	4705                	li	a4,1
    800065d6:	d798                	sw	a4,40(a5)
    800065d8:	c3d8                	sw	a4,4(a5)
    800065da:	6422                	ld	s0,8(sp)
    800065dc:	0141                	addi	sp,sp,16
    800065de:	8082                	ret

00000000800065e0 <plicinithart>:
    800065e0:	1141                	addi	sp,sp,-16
    800065e2:	e406                	sd	ra,8(sp)
    800065e4:	e022                	sd	s0,0(sp)
    800065e6:	0800                	addi	s0,sp,16
    800065e8:	ffffb097          	auipc	ra,0xffffb
    800065ec:	398080e7          	jalr	920(ra) # 80001980 <cpuid>
    800065f0:	0085171b          	slliw	a4,a0,0x8
    800065f4:	0c0027b7          	lui	a5,0xc002
    800065f8:	97ba                	add	a5,a5,a4
    800065fa:	40200713          	li	a4,1026
    800065fe:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>
    80006602:	00d5151b          	slliw	a0,a0,0xd
    80006606:	0c2017b7          	lui	a5,0xc201
    8000660a:	953e                	add	a0,a0,a5
    8000660c:	00052023          	sw	zero,0(a0)
    80006610:	60a2                	ld	ra,8(sp)
    80006612:	6402                	ld	s0,0(sp)
    80006614:	0141                	addi	sp,sp,16
    80006616:	8082                	ret

0000000080006618 <plic_claim>:
    80006618:	1141                	addi	sp,sp,-16
    8000661a:	e406                	sd	ra,8(sp)
    8000661c:	e022                	sd	s0,0(sp)
    8000661e:	0800                	addi	s0,sp,16
    80006620:	ffffb097          	auipc	ra,0xffffb
    80006624:	360080e7          	jalr	864(ra) # 80001980 <cpuid>
    80006628:	00d5179b          	slliw	a5,a0,0xd
    8000662c:	0c201537          	lui	a0,0xc201
    80006630:	953e                	add	a0,a0,a5
    80006632:	4148                	lw	a0,4(a0)
    80006634:	60a2                	ld	ra,8(sp)
    80006636:	6402                	ld	s0,0(sp)
    80006638:	0141                	addi	sp,sp,16
    8000663a:	8082                	ret

000000008000663c <plic_complete>:
    8000663c:	1101                	addi	sp,sp,-32
    8000663e:	ec06                	sd	ra,24(sp)
    80006640:	e822                	sd	s0,16(sp)
    80006642:	e426                	sd	s1,8(sp)
    80006644:	1000                	addi	s0,sp,32
    80006646:	84aa                	mv	s1,a0
    80006648:	ffffb097          	auipc	ra,0xffffb
    8000664c:	338080e7          	jalr	824(ra) # 80001980 <cpuid>
    80006650:	00d5151b          	slliw	a0,a0,0xd
    80006654:	0c2017b7          	lui	a5,0xc201
    80006658:	97aa                	add	a5,a5,a0
    8000665a:	c3c4                	sw	s1,4(a5)
    8000665c:	60e2                	ld	ra,24(sp)
    8000665e:	6442                	ld	s0,16(sp)
    80006660:	64a2                	ld	s1,8(sp)
    80006662:	6105                	addi	sp,sp,32
    80006664:	8082                	ret

0000000080006666 <free_desc>:
    80006666:	1141                	addi	sp,sp,-16
    80006668:	e406                	sd	ra,8(sp)
    8000666a:	e022                	sd	s0,0(sp)
    8000666c:	0800                	addi	s0,sp,16
    8000666e:	479d                	li	a5,7
    80006670:	04a7cc63          	blt	a5,a0,800066c8 <free_desc+0x62>
    80006674:	0001d797          	auipc	a5,0x1d
    80006678:	9bc78793          	addi	a5,a5,-1604 # 80023030 <disk>
    8000667c:	97aa                	add	a5,a5,a0
    8000667e:	0187c783          	lbu	a5,24(a5)
    80006682:	ebb9                	bnez	a5,800066d8 <free_desc+0x72>
    80006684:	00451613          	slli	a2,a0,0x4
    80006688:	0001d797          	auipc	a5,0x1d
    8000668c:	9a878793          	addi	a5,a5,-1624 # 80023030 <disk>
    80006690:	6394                	ld	a3,0(a5)
    80006692:	96b2                	add	a3,a3,a2
    80006694:	0006b023          	sd	zero,0(a3)
    80006698:	6398                	ld	a4,0(a5)
    8000669a:	9732                	add	a4,a4,a2
    8000669c:	00072423          	sw	zero,8(a4)
    800066a0:	00071623          	sh	zero,12(a4)
    800066a4:	00071723          	sh	zero,14(a4)
    800066a8:	953e                	add	a0,a0,a5
    800066aa:	4785                	li	a5,1
    800066ac:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
    800066b0:	0001d517          	auipc	a0,0x1d
    800066b4:	99850513          	addi	a0,a0,-1640 # 80023048 <disk+0x18>
    800066b8:	ffffc097          	auipc	ra,0xffffc
    800066bc:	aca080e7          	jalr	-1334(ra) # 80002182 <wakeup>
    800066c0:	60a2                	ld	ra,8(sp)
    800066c2:	6402                	ld	s0,0(sp)
    800066c4:	0141                	addi	sp,sp,16
    800066c6:	8082                	ret
    800066c8:	00002517          	auipc	a0,0x2
    800066cc:	0a850513          	addi	a0,a0,168 # 80008770 <syscalls+0x310>
    800066d0:	ffffa097          	auipc	ra,0xffffa
    800066d4:	e6e080e7          	jalr	-402(ra) # 8000053e <panic>
    800066d8:	00002517          	auipc	a0,0x2
    800066dc:	0a850513          	addi	a0,a0,168 # 80008780 <syscalls+0x320>
    800066e0:	ffffa097          	auipc	ra,0xffffa
    800066e4:	e5e080e7          	jalr	-418(ra) # 8000053e <panic>

00000000800066e8 <virtio_disk_init>:
    800066e8:	1101                	addi	sp,sp,-32
    800066ea:	ec06                	sd	ra,24(sp)
    800066ec:	e822                	sd	s0,16(sp)
    800066ee:	e426                	sd	s1,8(sp)
    800066f0:	e04a                	sd	s2,0(sp)
    800066f2:	1000                	addi	s0,sp,32
    800066f4:	00002597          	auipc	a1,0x2
    800066f8:	09c58593          	addi	a1,a1,156 # 80008790 <syscalls+0x330>
    800066fc:	0001d517          	auipc	a0,0x1d
    80006700:	a5c50513          	addi	a0,a0,-1444 # 80023158 <disk+0x128>
    80006704:	ffffa097          	auipc	ra,0xffffa
    80006708:	442080e7          	jalr	1090(ra) # 80000b46 <initlock>
    8000670c:	100017b7          	lui	a5,0x10001
    80006710:	4398                	lw	a4,0(a5)
    80006712:	2701                	sext.w	a4,a4
    80006714:	747277b7          	lui	a5,0x74727
    80006718:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000671c:	14f71c63          	bne	a4,a5,80006874 <virtio_disk_init+0x18c>
    80006720:	100017b7          	lui	a5,0x10001
    80006724:	43dc                	lw	a5,4(a5)
    80006726:	2781                	sext.w	a5,a5
    80006728:	4709                	li	a4,2
    8000672a:	14e79563          	bne	a5,a4,80006874 <virtio_disk_init+0x18c>
    8000672e:	100017b7          	lui	a5,0x10001
    80006732:	479c                	lw	a5,8(a5)
    80006734:	2781                	sext.w	a5,a5
    80006736:	12e79f63          	bne	a5,a4,80006874 <virtio_disk_init+0x18c>
    8000673a:	100017b7          	lui	a5,0x10001
    8000673e:	47d8                	lw	a4,12(a5)
    80006740:	2701                	sext.w	a4,a4
    80006742:	554d47b7          	lui	a5,0x554d4
    80006746:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000674a:	12f71563          	bne	a4,a5,80006874 <virtio_disk_init+0x18c>
    8000674e:	100017b7          	lui	a5,0x10001
    80006752:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
    80006756:	4705                	li	a4,1
    80006758:	dbb8                	sw	a4,112(a5)
    8000675a:	470d                	li	a4,3
    8000675c:	dbb8                	sw	a4,112(a5)
    8000675e:	4b94                	lw	a3,16(a5)
    80006760:	c7ffe737          	lui	a4,0xc7ffe
    80006764:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb5ef>
    80006768:	8f75                	and	a4,a4,a3
    8000676a:	2701                	sext.w	a4,a4
    8000676c:	d398                	sw	a4,32(a5)
    8000676e:	472d                	li	a4,11
    80006770:	dbb8                	sw	a4,112(a5)
    80006772:	5bbc                	lw	a5,112(a5)
    80006774:	0007891b          	sext.w	s2,a5
    80006778:	8ba1                	andi	a5,a5,8
    8000677a:	10078563          	beqz	a5,80006884 <virtio_disk_init+0x19c>
    8000677e:	100017b7          	lui	a5,0x10001
    80006782:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
    80006786:	43fc                	lw	a5,68(a5)
    80006788:	2781                	sext.w	a5,a5
    8000678a:	10079563          	bnez	a5,80006894 <virtio_disk_init+0x1ac>
    8000678e:	100017b7          	lui	a5,0x10001
    80006792:	5bdc                	lw	a5,52(a5)
    80006794:	2781                	sext.w	a5,a5
    80006796:	10078763          	beqz	a5,800068a4 <virtio_disk_init+0x1bc>
    8000679a:	471d                	li	a4,7
    8000679c:	10f77c63          	bgeu	a4,a5,800068b4 <virtio_disk_init+0x1cc>
    800067a0:	ffffa097          	auipc	ra,0xffffa
    800067a4:	346080e7          	jalr	838(ra) # 80000ae6 <kalloc>
    800067a8:	0001d497          	auipc	s1,0x1d
    800067ac:	88848493          	addi	s1,s1,-1912 # 80023030 <disk>
    800067b0:	e088                	sd	a0,0(s1)
    800067b2:	ffffa097          	auipc	ra,0xffffa
    800067b6:	334080e7          	jalr	820(ra) # 80000ae6 <kalloc>
    800067ba:	e488                	sd	a0,8(s1)
    800067bc:	ffffa097          	auipc	ra,0xffffa
    800067c0:	32a080e7          	jalr	810(ra) # 80000ae6 <kalloc>
    800067c4:	87aa                	mv	a5,a0
    800067c6:	e888                	sd	a0,16(s1)
    800067c8:	6088                	ld	a0,0(s1)
    800067ca:	cd6d                	beqz	a0,800068c4 <virtio_disk_init+0x1dc>
    800067cc:	0001d717          	auipc	a4,0x1d
    800067d0:	86c73703          	ld	a4,-1940(a4) # 80023038 <disk+0x8>
    800067d4:	cb65                	beqz	a4,800068c4 <virtio_disk_init+0x1dc>
    800067d6:	c7fd                	beqz	a5,800068c4 <virtio_disk_init+0x1dc>
    800067d8:	6605                	lui	a2,0x1
    800067da:	4581                	li	a1,0
    800067dc:	ffffa097          	auipc	ra,0xffffa
    800067e0:	4f6080e7          	jalr	1270(ra) # 80000cd2 <memset>
    800067e4:	0001d497          	auipc	s1,0x1d
    800067e8:	84c48493          	addi	s1,s1,-1972 # 80023030 <disk>
    800067ec:	6605                	lui	a2,0x1
    800067ee:	4581                	li	a1,0
    800067f0:	6488                	ld	a0,8(s1)
    800067f2:	ffffa097          	auipc	ra,0xffffa
    800067f6:	4e0080e7          	jalr	1248(ra) # 80000cd2 <memset>
    800067fa:	6605                	lui	a2,0x1
    800067fc:	4581                	li	a1,0
    800067fe:	6888                	ld	a0,16(s1)
    80006800:	ffffa097          	auipc	ra,0xffffa
    80006804:	4d2080e7          	jalr	1234(ra) # 80000cd2 <memset>
    80006808:	100017b7          	lui	a5,0x10001
    8000680c:	4721                	li	a4,8
    8000680e:	df98                	sw	a4,56(a5)
    80006810:	4098                	lw	a4,0(s1)
    80006812:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
    80006816:	40d8                	lw	a4,4(s1)
    80006818:	08e7a223          	sw	a4,132(a5)
    8000681c:	6498                	ld	a4,8(s1)
    8000681e:	0007069b          	sext.w	a3,a4
    80006822:	08d7a823          	sw	a3,144(a5)
    80006826:	9701                	srai	a4,a4,0x20
    80006828:	08e7aa23          	sw	a4,148(a5)
    8000682c:	6898                	ld	a4,16(s1)
    8000682e:	0007069b          	sext.w	a3,a4
    80006832:	0ad7a023          	sw	a3,160(a5)
    80006836:	9701                	srai	a4,a4,0x20
    80006838:	0ae7a223          	sw	a4,164(a5)
    8000683c:	4705                	li	a4,1
    8000683e:	c3f8                	sw	a4,68(a5)
    80006840:	00e48c23          	sb	a4,24(s1)
    80006844:	00e48ca3          	sb	a4,25(s1)
    80006848:	00e48d23          	sb	a4,26(s1)
    8000684c:	00e48da3          	sb	a4,27(s1)
    80006850:	00e48e23          	sb	a4,28(s1)
    80006854:	00e48ea3          	sb	a4,29(s1)
    80006858:	00e48f23          	sb	a4,30(s1)
    8000685c:	00e48fa3          	sb	a4,31(s1)
    80006860:	00496913          	ori	s2,s2,4
    80006864:	0727a823          	sw	s2,112(a5)
    80006868:	60e2                	ld	ra,24(sp)
    8000686a:	6442                	ld	s0,16(sp)
    8000686c:	64a2                	ld	s1,8(sp)
    8000686e:	6902                	ld	s2,0(sp)
    80006870:	6105                	addi	sp,sp,32
    80006872:	8082                	ret
    80006874:	00002517          	auipc	a0,0x2
    80006878:	f2c50513          	addi	a0,a0,-212 # 800087a0 <syscalls+0x340>
    8000687c:	ffffa097          	auipc	ra,0xffffa
    80006880:	cc2080e7          	jalr	-830(ra) # 8000053e <panic>
    80006884:	00002517          	auipc	a0,0x2
    80006888:	f3c50513          	addi	a0,a0,-196 # 800087c0 <syscalls+0x360>
    8000688c:	ffffa097          	auipc	ra,0xffffa
    80006890:	cb2080e7          	jalr	-846(ra) # 8000053e <panic>
    80006894:	00002517          	auipc	a0,0x2
    80006898:	f4c50513          	addi	a0,a0,-180 # 800087e0 <syscalls+0x380>
    8000689c:	ffffa097          	auipc	ra,0xffffa
    800068a0:	ca2080e7          	jalr	-862(ra) # 8000053e <panic>
    800068a4:	00002517          	auipc	a0,0x2
    800068a8:	f5c50513          	addi	a0,a0,-164 # 80008800 <syscalls+0x3a0>
    800068ac:	ffffa097          	auipc	ra,0xffffa
    800068b0:	c92080e7          	jalr	-878(ra) # 8000053e <panic>
    800068b4:	00002517          	auipc	a0,0x2
    800068b8:	f6c50513          	addi	a0,a0,-148 # 80008820 <syscalls+0x3c0>
    800068bc:	ffffa097          	auipc	ra,0xffffa
    800068c0:	c82080e7          	jalr	-894(ra) # 8000053e <panic>
    800068c4:	00002517          	auipc	a0,0x2
    800068c8:	f7c50513          	addi	a0,a0,-132 # 80008840 <syscalls+0x3e0>
    800068cc:	ffffa097          	auipc	ra,0xffffa
    800068d0:	c72080e7          	jalr	-910(ra) # 8000053e <panic>

00000000800068d4 <virtio_disk_rw>:
    800068d4:	7119                	addi	sp,sp,-128
    800068d6:	fc86                	sd	ra,120(sp)
    800068d8:	f8a2                	sd	s0,112(sp)
    800068da:	f4a6                	sd	s1,104(sp)
    800068dc:	f0ca                	sd	s2,96(sp)
    800068de:	ecce                	sd	s3,88(sp)
    800068e0:	e8d2                	sd	s4,80(sp)
    800068e2:	e4d6                	sd	s5,72(sp)
    800068e4:	e0da                	sd	s6,64(sp)
    800068e6:	fc5e                	sd	s7,56(sp)
    800068e8:	f862                	sd	s8,48(sp)
    800068ea:	f466                	sd	s9,40(sp)
    800068ec:	f06a                	sd	s10,32(sp)
    800068ee:	ec6e                	sd	s11,24(sp)
    800068f0:	0100                	addi	s0,sp,128
    800068f2:	8aaa                	mv	s5,a0
    800068f4:	8c2e                	mv	s8,a1
    800068f6:	00c52d03          	lw	s10,12(a0)
    800068fa:	001d1d1b          	slliw	s10,s10,0x1
    800068fe:	1d02                	slli	s10,s10,0x20
    80006900:	020d5d13          	srli	s10,s10,0x20
    80006904:	0001d517          	auipc	a0,0x1d
    80006908:	85450513          	addi	a0,a0,-1964 # 80023158 <disk+0x128>
    8000690c:	ffffa097          	auipc	ra,0xffffa
    80006910:	2ca080e7          	jalr	714(ra) # 80000bd6 <acquire>
    80006914:	4981                	li	s3,0
    80006916:	44a1                	li	s1,8
    80006918:	0001cb97          	auipc	s7,0x1c
    8000691c:	718b8b93          	addi	s7,s7,1816 # 80023030 <disk>
    80006920:	4b0d                	li	s6,3
    80006922:	0001dc97          	auipc	s9,0x1d
    80006926:	836c8c93          	addi	s9,s9,-1994 # 80023158 <disk+0x128>
    8000692a:	a08d                	j	8000698c <virtio_disk_rw+0xb8>
    8000692c:	00fb8733          	add	a4,s7,a5
    80006930:	00070c23          	sb	zero,24(a4)
    80006934:	c19c                	sw	a5,0(a1)
    80006936:	0207c563          	bltz	a5,80006960 <virtio_disk_rw+0x8c>
    8000693a:	2905                	addiw	s2,s2,1
    8000693c:	0611                	addi	a2,a2,4
    8000693e:	05690c63          	beq	s2,s6,80006996 <virtio_disk_rw+0xc2>
    80006942:	85b2                	mv	a1,a2
    80006944:	0001c717          	auipc	a4,0x1c
    80006948:	6ec70713          	addi	a4,a4,1772 # 80023030 <disk>
    8000694c:	87ce                	mv	a5,s3
    8000694e:	01874683          	lbu	a3,24(a4)
    80006952:	fee9                	bnez	a3,8000692c <virtio_disk_rw+0x58>
    80006954:	2785                	addiw	a5,a5,1
    80006956:	0705                	addi	a4,a4,1
    80006958:	fe979be3          	bne	a5,s1,8000694e <virtio_disk_rw+0x7a>
    8000695c:	57fd                	li	a5,-1
    8000695e:	c19c                	sw	a5,0(a1)
    80006960:	01205d63          	blez	s2,8000697a <virtio_disk_rw+0xa6>
    80006964:	8dce                	mv	s11,s3
    80006966:	000a2503          	lw	a0,0(s4)
    8000696a:	00000097          	auipc	ra,0x0
    8000696e:	cfc080e7          	jalr	-772(ra) # 80006666 <free_desc>
    80006972:	2d85                	addiw	s11,s11,1
    80006974:	0a11                	addi	s4,s4,4
    80006976:	ffb918e3          	bne	s2,s11,80006966 <virtio_disk_rw+0x92>
    8000697a:	85e6                	mv	a1,s9
    8000697c:	0001c517          	auipc	a0,0x1c
    80006980:	6cc50513          	addi	a0,a0,1740 # 80023048 <disk+0x18>
    80006984:	ffffb097          	auipc	ra,0xffffb
    80006988:	79a080e7          	jalr	1946(ra) # 8000211e <sleep>
    8000698c:	f8040a13          	addi	s4,s0,-128
    80006990:	8652                	mv	a2,s4
    80006992:	894e                	mv	s2,s3
    80006994:	b77d                	j	80006942 <virtio_disk_rw+0x6e>
    80006996:	f8042583          	lw	a1,-128(s0)
    8000699a:	00a58793          	addi	a5,a1,10
    8000699e:	0792                	slli	a5,a5,0x4
    800069a0:	0001c617          	auipc	a2,0x1c
    800069a4:	69060613          	addi	a2,a2,1680 # 80023030 <disk>
    800069a8:	00f60733          	add	a4,a2,a5
    800069ac:	018036b3          	snez	a3,s8
    800069b0:	c714                	sw	a3,8(a4)
    800069b2:	00072623          	sw	zero,12(a4)
    800069b6:	01a73823          	sd	s10,16(a4)
    800069ba:	f6078693          	addi	a3,a5,-160
    800069be:	6218                	ld	a4,0(a2)
    800069c0:	9736                	add	a4,a4,a3
    800069c2:	00878513          	addi	a0,a5,8
    800069c6:	9532                	add	a0,a0,a2
    800069c8:	e308                	sd	a0,0(a4)
    800069ca:	6208                	ld	a0,0(a2)
    800069cc:	96aa                	add	a3,a3,a0
    800069ce:	4741                	li	a4,16
    800069d0:	c698                	sw	a4,8(a3)
    800069d2:	4705                	li	a4,1
    800069d4:	00e69623          	sh	a4,12(a3)
    800069d8:	f8442703          	lw	a4,-124(s0)
    800069dc:	00e69723          	sh	a4,14(a3)
    800069e0:	0712                	slli	a4,a4,0x4
    800069e2:	953a                	add	a0,a0,a4
    800069e4:	058a8693          	addi	a3,s5,88
    800069e8:	e114                	sd	a3,0(a0)
    800069ea:	6208                	ld	a0,0(a2)
    800069ec:	972a                	add	a4,a4,a0
    800069ee:	40000693          	li	a3,1024
    800069f2:	c714                	sw	a3,8(a4)
    800069f4:	001c3c13          	seqz	s8,s8
    800069f8:	0c06                	slli	s8,s8,0x1
    800069fa:	001c6c13          	ori	s8,s8,1
    800069fe:	01871623          	sh	s8,12(a4)
    80006a02:	f8842603          	lw	a2,-120(s0)
    80006a06:	00c71723          	sh	a2,14(a4)
    80006a0a:	0001c697          	auipc	a3,0x1c
    80006a0e:	62668693          	addi	a3,a3,1574 # 80023030 <disk>
    80006a12:	00258713          	addi	a4,a1,2
    80006a16:	0712                	slli	a4,a4,0x4
    80006a18:	9736                	add	a4,a4,a3
    80006a1a:	587d                	li	a6,-1
    80006a1c:	01070823          	sb	a6,16(a4)
    80006a20:	0612                	slli	a2,a2,0x4
    80006a22:	9532                	add	a0,a0,a2
    80006a24:	f9078793          	addi	a5,a5,-112
    80006a28:	97b6                	add	a5,a5,a3
    80006a2a:	e11c                	sd	a5,0(a0)
    80006a2c:	629c                	ld	a5,0(a3)
    80006a2e:	97b2                	add	a5,a5,a2
    80006a30:	4605                	li	a2,1
    80006a32:	c790                	sw	a2,8(a5)
    80006a34:	4509                	li	a0,2
    80006a36:	00a79623          	sh	a0,12(a5)
    80006a3a:	00079723          	sh	zero,14(a5)
    80006a3e:	00caa223          	sw	a2,4(s5)
    80006a42:	01573423          	sd	s5,8(a4)
    80006a46:	6698                	ld	a4,8(a3)
    80006a48:	00275783          	lhu	a5,2(a4)
    80006a4c:	8b9d                	andi	a5,a5,7
    80006a4e:	0786                	slli	a5,a5,0x1
    80006a50:	97ba                	add	a5,a5,a4
    80006a52:	00b79223          	sh	a1,4(a5)
    80006a56:	0ff0000f          	fence
    80006a5a:	6698                	ld	a4,8(a3)
    80006a5c:	00275783          	lhu	a5,2(a4)
    80006a60:	2785                	addiw	a5,a5,1
    80006a62:	00f71123          	sh	a5,2(a4)
    80006a66:	0ff0000f          	fence
    80006a6a:	100017b7          	lui	a5,0x10001
    80006a6e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>
    80006a72:	004aa783          	lw	a5,4(s5)
    80006a76:	02c79163          	bne	a5,a2,80006a98 <virtio_disk_rw+0x1c4>
    80006a7a:	0001c917          	auipc	s2,0x1c
    80006a7e:	6de90913          	addi	s2,s2,1758 # 80023158 <disk+0x128>
    80006a82:	4485                	li	s1,1
    80006a84:	85ca                	mv	a1,s2
    80006a86:	8556                	mv	a0,s5
    80006a88:	ffffb097          	auipc	ra,0xffffb
    80006a8c:	696080e7          	jalr	1686(ra) # 8000211e <sleep>
    80006a90:	004aa783          	lw	a5,4(s5)
    80006a94:	fe9788e3          	beq	a5,s1,80006a84 <virtio_disk_rw+0x1b0>
    80006a98:	f8042903          	lw	s2,-128(s0)
    80006a9c:	00290793          	addi	a5,s2,2
    80006aa0:	00479713          	slli	a4,a5,0x4
    80006aa4:	0001c797          	auipc	a5,0x1c
    80006aa8:	58c78793          	addi	a5,a5,1420 # 80023030 <disk>
    80006aac:	97ba                	add	a5,a5,a4
    80006aae:	0007b423          	sd	zero,8(a5)
    80006ab2:	0001c997          	auipc	s3,0x1c
    80006ab6:	57e98993          	addi	s3,s3,1406 # 80023030 <disk>
    80006aba:	00491713          	slli	a4,s2,0x4
    80006abe:	0009b783          	ld	a5,0(s3)
    80006ac2:	97ba                	add	a5,a5,a4
    80006ac4:	00c7d483          	lhu	s1,12(a5)
    80006ac8:	854a                	mv	a0,s2
    80006aca:	00e7d903          	lhu	s2,14(a5)
    80006ace:	00000097          	auipc	ra,0x0
    80006ad2:	b98080e7          	jalr	-1128(ra) # 80006666 <free_desc>
    80006ad6:	8885                	andi	s1,s1,1
    80006ad8:	f0ed                	bnez	s1,80006aba <virtio_disk_rw+0x1e6>
    80006ada:	0001c517          	auipc	a0,0x1c
    80006ade:	67e50513          	addi	a0,a0,1662 # 80023158 <disk+0x128>
    80006ae2:	ffffa097          	auipc	ra,0xffffa
    80006ae6:	1a8080e7          	jalr	424(ra) # 80000c8a <release>
    80006aea:	70e6                	ld	ra,120(sp)
    80006aec:	7446                	ld	s0,112(sp)
    80006aee:	74a6                	ld	s1,104(sp)
    80006af0:	7906                	ld	s2,96(sp)
    80006af2:	69e6                	ld	s3,88(sp)
    80006af4:	6a46                	ld	s4,80(sp)
    80006af6:	6aa6                	ld	s5,72(sp)
    80006af8:	6b06                	ld	s6,64(sp)
    80006afa:	7be2                	ld	s7,56(sp)
    80006afc:	7c42                	ld	s8,48(sp)
    80006afe:	7ca2                	ld	s9,40(sp)
    80006b00:	7d02                	ld	s10,32(sp)
    80006b02:	6de2                	ld	s11,24(sp)
    80006b04:	6109                	addi	sp,sp,128
    80006b06:	8082                	ret

0000000080006b08 <virtio_disk_intr>:
    80006b08:	1101                	addi	sp,sp,-32
    80006b0a:	ec06                	sd	ra,24(sp)
    80006b0c:	e822                	sd	s0,16(sp)
    80006b0e:	e426                	sd	s1,8(sp)
    80006b10:	1000                	addi	s0,sp,32
    80006b12:	0001c497          	auipc	s1,0x1c
    80006b16:	51e48493          	addi	s1,s1,1310 # 80023030 <disk>
    80006b1a:	0001c517          	auipc	a0,0x1c
    80006b1e:	63e50513          	addi	a0,a0,1598 # 80023158 <disk+0x128>
    80006b22:	ffffa097          	auipc	ra,0xffffa
    80006b26:	0b4080e7          	jalr	180(ra) # 80000bd6 <acquire>
    80006b2a:	10001737          	lui	a4,0x10001
    80006b2e:	533c                	lw	a5,96(a4)
    80006b30:	8b8d                	andi	a5,a5,3
    80006b32:	d37c                	sw	a5,100(a4)
    80006b34:	0ff0000f          	fence
    80006b38:	689c                	ld	a5,16(s1)
    80006b3a:	0204d703          	lhu	a4,32(s1)
    80006b3e:	0027d783          	lhu	a5,2(a5)
    80006b42:	04f70863          	beq	a4,a5,80006b92 <virtio_disk_intr+0x8a>
    80006b46:	0ff0000f          	fence
    80006b4a:	6898                	ld	a4,16(s1)
    80006b4c:	0204d783          	lhu	a5,32(s1)
    80006b50:	8b9d                	andi	a5,a5,7
    80006b52:	078e                	slli	a5,a5,0x3
    80006b54:	97ba                	add	a5,a5,a4
    80006b56:	43dc                	lw	a5,4(a5)
    80006b58:	00278713          	addi	a4,a5,2
    80006b5c:	0712                	slli	a4,a4,0x4
    80006b5e:	9726                	add	a4,a4,s1
    80006b60:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006b64:	e721                	bnez	a4,80006bac <virtio_disk_intr+0xa4>
    80006b66:	0789                	addi	a5,a5,2
    80006b68:	0792                	slli	a5,a5,0x4
    80006b6a:	97a6                	add	a5,a5,s1
    80006b6c:	6788                	ld	a0,8(a5)
    80006b6e:	00052223          	sw	zero,4(a0)
    80006b72:	ffffb097          	auipc	ra,0xffffb
    80006b76:	610080e7          	jalr	1552(ra) # 80002182 <wakeup>
    80006b7a:	0204d783          	lhu	a5,32(s1)
    80006b7e:	2785                	addiw	a5,a5,1
    80006b80:	17c2                	slli	a5,a5,0x30
    80006b82:	93c1                	srli	a5,a5,0x30
    80006b84:	02f49023          	sh	a5,32(s1)
    80006b88:	6898                	ld	a4,16(s1)
    80006b8a:	00275703          	lhu	a4,2(a4)
    80006b8e:	faf71ce3          	bne	a4,a5,80006b46 <virtio_disk_intr+0x3e>
    80006b92:	0001c517          	auipc	a0,0x1c
    80006b96:	5c650513          	addi	a0,a0,1478 # 80023158 <disk+0x128>
    80006b9a:	ffffa097          	auipc	ra,0xffffa
    80006b9e:	0f0080e7          	jalr	240(ra) # 80000c8a <release>
    80006ba2:	60e2                	ld	ra,24(sp)
    80006ba4:	6442                	ld	s0,16(sp)
    80006ba6:	64a2                	ld	s1,8(sp)
    80006ba8:	6105                	addi	sp,sp,32
    80006baa:	8082                	ret
    80006bac:	00002517          	auipc	a0,0x2
    80006bb0:	cac50513          	addi	a0,a0,-852 # 80008858 <syscalls+0x3f8>
    80006bb4:	ffffa097          	auipc	ra,0xffffa
    80006bb8:	98a080e7          	jalr	-1654(ra) # 8000053e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
