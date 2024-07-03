
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	ad010113          	addi	sp,sp,-1328 # 80008ad0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	93e70713          	addi	a4,a4,-1730 # 80008990 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	5ac78793          	addi	a5,a5,1452 # 80006610 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbbfe7>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	faa78793          	addi	a5,a5,-86 # 80001058 <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000102:	715d                	addi	sp,sp,-80
    80000104:	e486                	sd	ra,72(sp)
    80000106:	e0a2                	sd	s0,64(sp)
    80000108:	fc26                	sd	s1,56(sp)
    8000010a:	f84a                	sd	s2,48(sp)
    8000010c:	f44e                	sd	s3,40(sp)
    8000010e:	f052                	sd	s4,32(sp)
    80000110:	ec56                	sd	s5,24(sp)
    80000112:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000114:	04c05663          	blez	a2,80000160 <consolewrite+0x5e>
    80000118:	8a2a                	mv	s4,a0
    8000011a:	84ae                	mv	s1,a1
    8000011c:	89b2                	mv	s3,a2
    8000011e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000120:	5afd                	li	s5,-1
    80000122:	4685                	li	a3,1
    80000124:	8626                	mv	a2,s1
    80000126:	85d2                	mv	a1,s4
    80000128:	fbf40513          	addi	a0,s0,-65
    8000012c:	00003097          	auipc	ra,0x3
    80000130:	8e6080e7          	jalr	-1818(ra) # 80002a12 <either_copyin>
    80000134:	01550c63          	beq	a0,s5,8000014c <consolewrite+0x4a>
      break;
    uartputc(c);
    80000138:	fbf44503          	lbu	a0,-65(s0)
    8000013c:	00000097          	auipc	ra,0x0
    80000140:	780080e7          	jalr	1920(ra) # 800008bc <uartputc>
  for(i = 0; i < n; i++){
    80000144:	2905                	addiw	s2,s2,1
    80000146:	0485                	addi	s1,s1,1
    80000148:	fd299de3          	bne	s3,s2,80000122 <consolewrite+0x20>
  }

  return i;
}
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
  for(i = 0; i < n; i++){
    80000160:	4901                	li	s2,0
    80000162:	b7ed                	j	8000014c <consolewrite+0x4a>

0000000080000164 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
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
  uint target;
  int c;
  char cbuf;

  target = n;
    80000186:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018a:	00011517          	auipc	a0,0x11
    8000018e:	94650513          	addi	a0,a0,-1722 # 80010ad0 <cons>
    80000192:	00001097          	auipc	ra,0x1
    80000196:	c24080e7          	jalr	-988(ra) # 80000db6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019a:	00011497          	auipc	s1,0x11
    8000019e:	93648493          	addi	s1,s1,-1738 # 80010ad0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a2:	00011917          	auipc	s2,0x11
    800001a6:	9c690913          	addi	s2,s2,-1594 # 80010b68 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800001aa:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ac:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001ae:	4ca9                	li	s9,10
  while(n > 0){
    800001b0:	07305b63          	blez	s3,80000226 <consoleread+0xc2>
    while(cons.r == cons.w){
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	02f71763          	bne	a4,a5,800001ea <consoleread+0x86>
      if(killed(myproc())){
    800001c0:	00002097          	auipc	ra,0x2
    800001c4:	ab8080e7          	jalr	-1352(ra) # 80001c78 <myproc>
    800001c8:	00002097          	auipc	ra,0x2
    800001cc:	694080e7          	jalr	1684(ra) # 8000285c <killed>
    800001d0:	e535                	bnez	a0,8000023c <consoleread+0xd8>
      sleep(&cons.r, &cons.lock);
    800001d2:	85a6                	mv	a1,s1
    800001d4:	854a                	mv	a0,s2
    800001d6:	00002097          	auipc	ra,0x2
    800001da:	3d2080e7          	jalr	978(ra) # 800025a8 <sleep>
    while(cons.r == cons.w){
    800001de:	0984a783          	lw	a5,152(s1)
    800001e2:	09c4a703          	lw	a4,156(s1)
    800001e6:	fcf70de3          	beq	a4,a5,800001c0 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ea:	0017871b          	addiw	a4,a5,1
    800001ee:	08e4ac23          	sw	a4,152(s1)
    800001f2:	07f7f713          	andi	a4,a5,127
    800001f6:	9726                	add	a4,a4,s1
    800001f8:	01874703          	lbu	a4,24(a4)
    800001fc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80000200:	077d0563          	beq	s10,s7,8000026a <consoleread+0x106>
    cbuf = c;
    80000204:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	f9f40613          	addi	a2,s0,-97
    8000020e:	85d2                	mv	a1,s4
    80000210:	8556                	mv	a0,s5
    80000212:	00002097          	auipc	ra,0x2
    80000216:	7aa080e7          	jalr	1962(ra) # 800029bc <either_copyout>
    8000021a:	01850663          	beq	a0,s8,80000226 <consoleread+0xc2>
    dst++;
    8000021e:	0a05                	addi	s4,s4,1
    --n;
    80000220:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80000222:	f99d17e3          	bne	s10,s9,800001b0 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000226:	00011517          	auipc	a0,0x11
    8000022a:	8aa50513          	addi	a0,a0,-1878 # 80010ad0 <cons>
    8000022e:	00001097          	auipc	ra,0x1
    80000232:	c3c080e7          	jalr	-964(ra) # 80000e6a <release>

  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	a811                	j	8000024e <consoleread+0xea>
        release(&cons.lock);
    8000023c:	00011517          	auipc	a0,0x11
    80000240:	89450513          	addi	a0,a0,-1900 # 80010ad0 <cons>
    80000244:	00001097          	auipc	ra,0x1
    80000248:	c26080e7          	jalr	-986(ra) # 80000e6a <release>
        return -1;
    8000024c:	557d                	li	a0,-1
}
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
      if(n < target){
    8000026a:	0009871b          	sext.w	a4,s3
    8000026e:	fb677ce3          	bgeu	a4,s6,80000226 <consoleread+0xc2>
        cons.r--;
    80000272:	00011717          	auipc	a4,0x11
    80000276:	8ef72b23          	sw	a5,-1802(a4) # 80010b68 <cons+0x98>
    8000027a:	b775                	j	80000226 <consoleread+0xc2>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000284:	10000793          	li	a5,256
    80000288:	00f50a63          	beq	a0,a5,8000029c <consputc+0x20>
    uartputc_sync(c);
    8000028c:	00000097          	auipc	ra,0x0
    80000290:	55e080e7          	jalr	1374(ra) # 800007ea <uartputc_sync>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
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
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002be:	1101                	addi	sp,sp,-32
    800002c0:	ec06                	sd	ra,24(sp)
    800002c2:	e822                	sd	s0,16(sp)
    800002c4:	e426                	sd	s1,8(sp)
    800002c6:	e04a                	sd	s2,0(sp)
    800002c8:	1000                	addi	s0,sp,32
    800002ca:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002cc:	00011517          	auipc	a0,0x11
    800002d0:	80450513          	addi	a0,a0,-2044 # 80010ad0 <cons>
    800002d4:	00001097          	auipc	ra,0x1
    800002d8:	ae2080e7          	jalr	-1310(ra) # 80000db6 <acquire>

  switch(c){
    800002dc:	47d5                	li	a5,21
    800002de:	0af48663          	beq	s1,a5,8000038a <consoleintr+0xcc>
    800002e2:	0297ca63          	blt	a5,s1,80000316 <consoleintr+0x58>
    800002e6:	47a1                	li	a5,8
    800002e8:	0ef48763          	beq	s1,a5,800003d6 <consoleintr+0x118>
    800002ec:	47c1                	li	a5,16
    800002ee:	10f49a63          	bne	s1,a5,80000402 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002f2:	00002097          	auipc	ra,0x2
    800002f6:	776080e7          	jalr	1910(ra) # 80002a68 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002fa:	00010517          	auipc	a0,0x10
    800002fe:	7d650513          	addi	a0,a0,2006 # 80010ad0 <cons>
    80000302:	00001097          	auipc	ra,0x1
    80000306:	b68080e7          	jalr	-1176(ra) # 80000e6a <release>
}
    8000030a:	60e2                	ld	ra,24(sp)
    8000030c:	6442                	ld	s0,16(sp)
    8000030e:	64a2                	ld	s1,8(sp)
    80000310:	6902                	ld	s2,0(sp)
    80000312:	6105                	addi	sp,sp,32
    80000314:	8082                	ret
  switch(c){
    80000316:	07f00793          	li	a5,127
    8000031a:	0af48e63          	beq	s1,a5,800003d6 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031e:	00010717          	auipc	a4,0x10
    80000322:	7b270713          	addi	a4,a4,1970 # 80010ad0 <cons>
    80000326:	0a072783          	lw	a5,160(a4)
    8000032a:	09872703          	lw	a4,152(a4)
    8000032e:	9f99                	subw	a5,a5,a4
    80000330:	07f00713          	li	a4,127
    80000334:	fcf763e3          	bltu	a4,a5,800002fa <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000338:	47b5                	li	a5,13
    8000033a:	0cf48763          	beq	s1,a5,80000408 <consoleintr+0x14a>
      consputc(c);
    8000033e:	8526                	mv	a0,s1
    80000340:	00000097          	auipc	ra,0x0
    80000344:	f3c080e7          	jalr	-196(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000348:	00010797          	auipc	a5,0x10
    8000034c:	78878793          	addi	a5,a5,1928 # 80010ad0 <cons>
    80000350:	0a07a683          	lw	a3,160(a5)
    80000354:	0016871b          	addiw	a4,a3,1
    80000358:	0007061b          	sext.w	a2,a4
    8000035c:	0ae7a023          	sw	a4,160(a5)
    80000360:	07f6f693          	andi	a3,a3,127
    80000364:	97b6                	add	a5,a5,a3
    80000366:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000036a:	47a9                	li	a5,10
    8000036c:	0cf48563          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000370:	4791                	li	a5,4
    80000372:	0cf48263          	beq	s1,a5,80000436 <consoleintr+0x178>
    80000376:	00010797          	auipc	a5,0x10
    8000037a:	7f27a783          	lw	a5,2034(a5) # 80010b68 <cons+0x98>
    8000037e:	9f1d                	subw	a4,a4,a5
    80000380:	08000793          	li	a5,128
    80000384:	f6f71be3          	bne	a4,a5,800002fa <consoleintr+0x3c>
    80000388:	a07d                	j	80000436 <consoleintr+0x178>
    while(cons.e != cons.w &&
    8000038a:	00010717          	auipc	a4,0x10
    8000038e:	74670713          	addi	a4,a4,1862 # 80010ad0 <cons>
    80000392:	0a072783          	lw	a5,160(a4)
    80000396:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000039a:	00010497          	auipc	s1,0x10
    8000039e:	73648493          	addi	s1,s1,1846 # 80010ad0 <cons>
    while(cons.e != cons.w &&
    800003a2:	4929                	li	s2,10
    800003a4:	f4f70be3          	beq	a4,a5,800002fa <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a8:	37fd                	addiw	a5,a5,-1
    800003aa:	07f7f713          	andi	a4,a5,127
    800003ae:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003b0:	01874703          	lbu	a4,24(a4)
    800003b4:	f52703e3          	beq	a4,s2,800002fa <consoleintr+0x3c>
      cons.e--;
    800003b8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003bc:	10000513          	li	a0,256
    800003c0:	00000097          	auipc	ra,0x0
    800003c4:	ebc080e7          	jalr	-324(ra) # 8000027c <consputc>
    while(cons.e != cons.w &&
    800003c8:	0a04a783          	lw	a5,160(s1)
    800003cc:	09c4a703          	lw	a4,156(s1)
    800003d0:	fcf71ce3          	bne	a4,a5,800003a8 <consoleintr+0xea>
    800003d4:	b71d                	j	800002fa <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003d6:	00010717          	auipc	a4,0x10
    800003da:	6fa70713          	addi	a4,a4,1786 # 80010ad0 <cons>
    800003de:	0a072783          	lw	a5,160(a4)
    800003e2:	09c72703          	lw	a4,156(a4)
    800003e6:	f0f70ae3          	beq	a4,a5,800002fa <consoleintr+0x3c>
      cons.e--;
    800003ea:	37fd                	addiw	a5,a5,-1
    800003ec:	00010717          	auipc	a4,0x10
    800003f0:	78f72223          	sw	a5,1924(a4) # 80010b70 <cons+0xa0>
      consputc(BACKSPACE);
    800003f4:	10000513          	li	a0,256
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	e84080e7          	jalr	-380(ra) # 8000027c <consputc>
    80000400:	bded                	j	800002fa <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000402:	ee048ce3          	beqz	s1,800002fa <consoleintr+0x3c>
    80000406:	bf21                	j	8000031e <consoleintr+0x60>
      consputc(c);
    80000408:	4529                	li	a0,10
    8000040a:	00000097          	auipc	ra,0x0
    8000040e:	e72080e7          	jalr	-398(ra) # 8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000412:	00010797          	auipc	a5,0x10
    80000416:	6be78793          	addi	a5,a5,1726 # 80010ad0 <cons>
    8000041a:	0a07a703          	lw	a4,160(a5)
    8000041e:	0017069b          	addiw	a3,a4,1
    80000422:	0006861b          	sext.w	a2,a3
    80000426:	0ad7a023          	sw	a3,160(a5)
    8000042a:	07f77713          	andi	a4,a4,127
    8000042e:	97ba                	add	a5,a5,a4
    80000430:	4729                	li	a4,10
    80000432:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000436:	00010797          	auipc	a5,0x10
    8000043a:	72c7ab23          	sw	a2,1846(a5) # 80010b6c <cons+0x9c>
        wakeup(&cons.r);
    8000043e:	00010517          	auipc	a0,0x10
    80000442:	72a50513          	addi	a0,a0,1834 # 80010b68 <cons+0x98>
    80000446:	00002097          	auipc	ra,0x2
    8000044a:	1c6080e7          	jalr	454(ra) # 8000260c <wakeup>
    8000044e:	b575                	j	800002fa <consoleintr+0x3c>

0000000080000450 <consoleinit>:

void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	bb858593          	addi	a1,a1,-1096 # 80008010 <etext+0x10>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	67050513          	addi	a0,a0,1648 # 80010ad0 <cons>
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	8be080e7          	jalr	-1858(ra) # 80000d26 <initlock>

  uartinit();
    80000470:	00000097          	auipc	ra,0x0
    80000474:	32a080e7          	jalr	810(ra) # 8000079a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000478:	00241797          	auipc	a5,0x241
    8000047c:	20878793          	addi	a5,a5,520 # 80241680 <devsw>
    80000480:	00000717          	auipc	a4,0x0
    80000484:	ce470713          	addi	a4,a4,-796 # 80000164 <consoleread>
    80000488:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	c7870713          	addi	a4,a4,-904 # 80000102 <consolewrite>
    80000492:	ef98                	sd	a4,24(a5)
}
    80000494:	60a2                	ld	ra,8(sp)
    80000496:	6402                	ld	s0,0(sp)
    80000498:	0141                	addi	sp,sp,16
    8000049a:	8082                	ret

000000008000049c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000049c:	7179                	addi	sp,sp,-48
    8000049e:	f406                	sd	ra,40(sp)
    800004a0:	f022                	sd	s0,32(sp)
    800004a2:	ec26                	sd	s1,24(sp)
    800004a4:	e84a                	sd	s2,16(sp)
    800004a6:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004a8:	c219                	beqz	a2,800004ae <printint+0x12>
    800004aa:	08054663          	bltz	a0,80000536 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ae:	2501                	sext.w	a0,a0
    800004b0:	4881                	li	a7,0
    800004b2:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004b6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
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
  } while((x /= base) != 0);
    800004d8:	0005079b          	sext.w	a5,a0
    800004dc:	02b5553b          	divuw	a0,a0,a1
    800004e0:	0685                	addi	a3,a3,1
    800004e2:	feb7f0e3          	bgeu	a5,a1,800004c2 <printint+0x26>

  if(sign)
    800004e6:	00088b63          	beqz	a7,800004fc <printint+0x60>
    buf[i++] = '-';
    800004ea:	fe040793          	addi	a5,s0,-32
    800004ee:	973e                	add	a4,a4,a5
    800004f0:	02d00793          	li	a5,45
    800004f4:	fef70823          	sb	a5,-16(a4)
    800004f8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004fc:	02e05763          	blez	a4,8000052a <printint+0x8e>
    80000500:	fd040793          	addi	a5,s0,-48
    80000504:	00e784b3          	add	s1,a5,a4
    80000508:	fff78913          	addi	s2,a5,-1
    8000050c:	993a                	add	s2,s2,a4
    8000050e:	377d                	addiw	a4,a4,-1
    80000510:	1702                	slli	a4,a4,0x20
    80000512:	9301                	srli	a4,a4,0x20
    80000514:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000518:	fff4c503          	lbu	a0,-1(s1)
    8000051c:	00000097          	auipc	ra,0x0
    80000520:	d60080e7          	jalr	-672(ra) # 8000027c <consputc>
  while(--i >= 0)
    80000524:	14fd                	addi	s1,s1,-1
    80000526:	ff2499e3          	bne	s1,s2,80000518 <printint+0x7c>
}
    8000052a:	70a2                	ld	ra,40(sp)
    8000052c:	7402                	ld	s0,32(sp)
    8000052e:	64e2                	ld	s1,24(sp)
    80000530:	6942                	ld	s2,16(sp)
    80000532:	6145                	addi	sp,sp,48
    80000534:	8082                	ret
    x = -xx;
    80000536:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000053a:	4885                	li	a7,1
    x = -xx;
    8000053c:	bf9d                	j	800004b2 <printint+0x16>

000000008000053e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000053e:	1101                	addi	sp,sp,-32
    80000540:	ec06                	sd	ra,24(sp)
    80000542:	e822                	sd	s0,16(sp)
    80000544:	e426                	sd	s1,8(sp)
    80000546:	1000                	addi	s0,sp,32
    80000548:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000054a:	00010797          	auipc	a5,0x10
    8000054e:	6407a323          	sw	zero,1606(a5) # 80010b90 <pr+0x18>
  printf("panic: ");
    80000552:	00008517          	auipc	a0,0x8
    80000556:	ac650513          	addi	a0,a0,-1338 # 80008018 <etext+0x18>
    8000055a:	00000097          	auipc	ra,0x0
    8000055e:	02e080e7          	jalr	46(ra) # 80000588 <printf>
  printf(s);
    80000562:	8526                	mv	a0,s1
    80000564:	00000097          	auipc	ra,0x0
    80000568:	024080e7          	jalr	36(ra) # 80000588 <printf>
  printf("\n");
    8000056c:	00008517          	auipc	a0,0x8
    80000570:	cbc50513          	addi	a0,a0,-836 # 80008228 <digits+0x1e8>
    80000574:	00000097          	auipc	ra,0x0
    80000578:	014080e7          	jalr	20(ra) # 80000588 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000057c:	4785                	li	a5,1
    8000057e:	00008717          	auipc	a4,0x8
    80000582:	3cf72923          	sw	a5,978(a4) # 80008950 <panicked>
  for(;;)
    80000586:	a001                	j	80000586 <panic+0x48>

0000000080000588 <printf>:
{
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
  locking = pr.locking;
    800005ba:	00010d97          	auipc	s11,0x10
    800005be:	5d6dad83          	lw	s11,1494(s11) # 80010b90 <pr+0x18>
  if(locking)
    800005c2:	020d9b63          	bnez	s11,800005f8 <printf+0x70>
  if (fmt == 0)
    800005c6:	040a0263          	beqz	s4,8000060a <printf+0x82>
  va_start(ap, fmt);
    800005ca:	00840793          	addi	a5,s0,8
    800005ce:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005d2:	000a4503          	lbu	a0,0(s4)
    800005d6:	14050f63          	beqz	a0,80000734 <printf+0x1ac>
    800005da:	4981                	li	s3,0
    if(c != '%'){
    800005dc:	02500a93          	li	s5,37
    switch(c){
    800005e0:	07000b93          	li	s7,112
  consputc('x');
    800005e4:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005e6:	00008b17          	auipc	s6,0x8
    800005ea:	a5ab0b13          	addi	s6,s6,-1446 # 80008040 <digits>
    switch(c){
    800005ee:	07300c93          	li	s9,115
    800005f2:	06400c13          	li	s8,100
    800005f6:	a82d                	j	80000630 <printf+0xa8>
    acquire(&pr.lock);
    800005f8:	00010517          	auipc	a0,0x10
    800005fc:	58050513          	addi	a0,a0,1408 # 80010b78 <pr>
    80000600:	00000097          	auipc	ra,0x0
    80000604:	7b6080e7          	jalr	1974(ra) # 80000db6 <acquire>
    80000608:	bf7d                	j	800005c6 <printf+0x3e>
    panic("null fmt");
    8000060a:	00008517          	auipc	a0,0x8
    8000060e:	a1e50513          	addi	a0,a0,-1506 # 80008028 <etext+0x28>
    80000612:	00000097          	auipc	ra,0x0
    80000616:	f2c080e7          	jalr	-212(ra) # 8000053e <panic>
      consputc(c);
    8000061a:	00000097          	auipc	ra,0x0
    8000061e:	c62080e7          	jalr	-926(ra) # 8000027c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000622:	2985                	addiw	s3,s3,1
    80000624:	013a07b3          	add	a5,s4,s3
    80000628:	0007c503          	lbu	a0,0(a5)
    8000062c:	10050463          	beqz	a0,80000734 <printf+0x1ac>
    if(c != '%'){
    80000630:	ff5515e3          	bne	a0,s5,8000061a <printf+0x92>
    c = fmt[++i] & 0xff;
    80000634:	2985                	addiw	s3,s3,1
    80000636:	013a07b3          	add	a5,s4,s3
    8000063a:	0007c783          	lbu	a5,0(a5)
    8000063e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000642:	cbed                	beqz	a5,80000734 <printf+0x1ac>
    switch(c){
    80000644:	05778a63          	beq	a5,s7,80000698 <printf+0x110>
    80000648:	02fbf663          	bgeu	s7,a5,80000674 <printf+0xec>
    8000064c:	09978863          	beq	a5,s9,800006dc <printf+0x154>
    80000650:	07800713          	li	a4,120
    80000654:	0ce79563          	bne	a5,a4,8000071e <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	85ea                	mv	a1,s10
    80000668:	4388                	lw	a0,0(a5)
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	e32080e7          	jalr	-462(ra) # 8000049c <printint>
      break;
    80000672:	bf45                	j	80000622 <printf+0x9a>
    switch(c){
    80000674:	09578f63          	beq	a5,s5,80000712 <printf+0x18a>
    80000678:	0b879363          	bne	a5,s8,8000071e <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4605                	li	a2,1
    8000068a:	45a9                	li	a1,10
    8000068c:	4388                	lw	a0,0(a5)
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	e0e080e7          	jalr	-498(ra) # 8000049c <printint>
      break;
    80000696:	b771                	j	80000622 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006a8:	03000513          	li	a0,48
    800006ac:	00000097          	auipc	ra,0x0
    800006b0:	bd0080e7          	jalr	-1072(ra) # 8000027c <consputc>
  consputc('x');
    800006b4:	07800513          	li	a0,120
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bc4080e7          	jalr	-1084(ra) # 8000027c <consputc>
    800006c0:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006c2:	03c95793          	srli	a5,s2,0x3c
    800006c6:	97da                	add	a5,a5,s6
    800006c8:	0007c503          	lbu	a0,0(a5)
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	bb0080e7          	jalr	-1104(ra) # 8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006d4:	0912                	slli	s2,s2,0x4
    800006d6:	34fd                	addiw	s1,s1,-1
    800006d8:	f4ed                	bnez	s1,800006c2 <printf+0x13a>
    800006da:	b7a1                	j	80000622 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	6384                	ld	s1,0(a5)
    800006ea:	cc89                	beqz	s1,80000704 <printf+0x17c>
      for(; *s; s++)
    800006ec:	0004c503          	lbu	a0,0(s1)
    800006f0:	d90d                	beqz	a0,80000622 <printf+0x9a>
        consputc(*s);
    800006f2:	00000097          	auipc	ra,0x0
    800006f6:	b8a080e7          	jalr	-1142(ra) # 8000027c <consputc>
      for(; *s; s++)
    800006fa:	0485                	addi	s1,s1,1
    800006fc:	0004c503          	lbu	a0,0(s1)
    80000700:	f96d                	bnez	a0,800006f2 <printf+0x16a>
    80000702:	b705                	j	80000622 <printf+0x9a>
        s = "(null)";
    80000704:	00008497          	auipc	s1,0x8
    80000708:	91c48493          	addi	s1,s1,-1764 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000070c:	02800513          	li	a0,40
    80000710:	b7cd                	j	800006f2 <printf+0x16a>
      consputc('%');
    80000712:	8556                	mv	a0,s5
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b68080e7          	jalr	-1176(ra) # 8000027c <consputc>
      break;
    8000071c:	b719                	j	80000622 <printf+0x9a>
      consputc('%');
    8000071e:	8556                	mv	a0,s5
    80000720:	00000097          	auipc	ra,0x0
    80000724:	b5c080e7          	jalr	-1188(ra) # 8000027c <consputc>
      consputc(c);
    80000728:	8526                	mv	a0,s1
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	b52080e7          	jalr	-1198(ra) # 8000027c <consputc>
      break;
    80000732:	bdc5                	j	80000622 <printf+0x9a>
  if(locking)
    80000734:	020d9163          	bnez	s11,80000756 <printf+0x1ce>
}
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
    release(&pr.lock);
    80000756:	00010517          	auipc	a0,0x10
    8000075a:	42250513          	addi	a0,a0,1058 # 80010b78 <pr>
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	70c080e7          	jalr	1804(ra) # 80000e6a <release>
}
    80000766:	bfc9                	j	80000738 <printf+0x1b0>

0000000080000768 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000768:	1101                	addi	sp,sp,-32
    8000076a:	ec06                	sd	ra,24(sp)
    8000076c:	e822                	sd	s0,16(sp)
    8000076e:	e426                	sd	s1,8(sp)
    80000770:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000772:	00010497          	auipc	s1,0x10
    80000776:	40648493          	addi	s1,s1,1030 # 80010b78 <pr>
    8000077a:	00008597          	auipc	a1,0x8
    8000077e:	8be58593          	addi	a1,a1,-1858 # 80008038 <etext+0x38>
    80000782:	8526                	mv	a0,s1
    80000784:	00000097          	auipc	ra,0x0
    80000788:	5a2080e7          	jalr	1442(ra) # 80000d26 <initlock>
  pr.locking = 1;
    8000078c:	4785                	li	a5,1
    8000078e:	cc9c                	sw	a5,24(s1)
}
    80000790:	60e2                	ld	ra,24(sp)
    80000792:	6442                	ld	s0,16(sp)
    80000794:	64a2                	ld	s1,8(sp)
    80000796:	6105                	addi	sp,sp,32
    80000798:	8082                	ret

000000008000079a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000079a:	1141                	addi	sp,sp,-16
    8000079c:	e406                	sd	ra,8(sp)
    8000079e:	e022                	sd	s0,0(sp)
    800007a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007a2:	100007b7          	lui	a5,0x10000
    800007a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007aa:	f8000713          	li	a4,-128
    800007ae:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007b2:	470d                	li	a4,3
    800007b4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007b8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007bc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007c0:	469d                	li	a3,7
    800007c2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007c6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007ca:	00008597          	auipc	a1,0x8
    800007ce:	88e58593          	addi	a1,a1,-1906 # 80008058 <digits+0x18>
    800007d2:	00010517          	auipc	a0,0x10
    800007d6:	3c650513          	addi	a0,a0,966 # 80010b98 <uart_tx_lock>
    800007da:	00000097          	auipc	ra,0x0
    800007de:	54c080e7          	jalr	1356(ra) # 80000d26 <initlock>
}
    800007e2:	60a2                	ld	ra,8(sp)
    800007e4:	6402                	ld	s0,0(sp)
    800007e6:	0141                	addi	sp,sp,16
    800007e8:	8082                	ret

00000000800007ea <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007ea:	1101                	addi	sp,sp,-32
    800007ec:	ec06                	sd	ra,24(sp)
    800007ee:	e822                	sd	s0,16(sp)
    800007f0:	e426                	sd	s1,8(sp)
    800007f2:	1000                	addi	s0,sp,32
    800007f4:	84aa                	mv	s1,a0
  push_off();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	574080e7          	jalr	1396(ra) # 80000d6a <push_off>

  if(panicked){
    800007fe:	00008797          	auipc	a5,0x8
    80000802:	1527a783          	lw	a5,338(a5) # 80008950 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000806:	10000737          	lui	a4,0x10000
  if(panicked){
    8000080a:	c391                	beqz	a5,8000080e <uartputc_sync+0x24>
    for(;;)
    8000080c:	a001                	j	8000080c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000080e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000812:	0207f793          	andi	a5,a5,32
    80000816:	dfe5                	beqz	a5,8000080e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000818:	0ff4f513          	andi	a0,s1,255
    8000081c:	100007b7          	lui	a5,0x10000
    80000820:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000824:	00000097          	auipc	ra,0x0
    80000828:	5e6080e7          	jalr	1510(ra) # 80000e0a <pop_off>
}
    8000082c:	60e2                	ld	ra,24(sp)
    8000082e:	6442                	ld	s0,16(sp)
    80000830:	64a2                	ld	s1,8(sp)
    80000832:	6105                	addi	sp,sp,32
    80000834:	8082                	ret

0000000080000836 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000836:	00008797          	auipc	a5,0x8
    8000083a:	1227b783          	ld	a5,290(a5) # 80008958 <uart_tx_r>
    8000083e:	00008717          	auipc	a4,0x8
    80000842:	12273703          	ld	a4,290(a4) # 80008960 <uart_tx_w>
    80000846:	06f70a63          	beq	a4,a5,800008ba <uartstart+0x84>
{
    8000084a:	7139                	addi	sp,sp,-64
    8000084c:	fc06                	sd	ra,56(sp)
    8000084e:	f822                	sd	s0,48(sp)
    80000850:	f426                	sd	s1,40(sp)
    80000852:	f04a                	sd	s2,32(sp)
    80000854:	ec4e                	sd	s3,24(sp)
    80000856:	e852                	sd	s4,16(sp)
    80000858:	e456                	sd	s5,8(sp)
    8000085a:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000085c:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000860:	00010a17          	auipc	s4,0x10
    80000864:	338a0a13          	addi	s4,s4,824 # 80010b98 <uart_tx_lock>
    uart_tx_r += 1;
    80000868:	00008497          	auipc	s1,0x8
    8000086c:	0f048493          	addi	s1,s1,240 # 80008958 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000870:	00008997          	auipc	s3,0x8
    80000874:	0f098993          	addi	s3,s3,240 # 80008960 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000878:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000087c:	02077713          	andi	a4,a4,32
    80000880:	c705                	beqz	a4,800008a8 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000882:	01f7f713          	andi	a4,a5,31
    80000886:	9752                	add	a4,a4,s4
    80000888:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000088c:	0785                	addi	a5,a5,1
    8000088e:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80000890:	8526                	mv	a0,s1
    80000892:	00002097          	auipc	ra,0x2
    80000896:	d7a080e7          	jalr	-646(ra) # 8000260c <wakeup>
    
    WriteReg(THR, c);
    8000089a:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000089e:	609c                	ld	a5,0(s1)
    800008a0:	0009b703          	ld	a4,0(s3)
    800008a4:	fcf71ae3          	bne	a4,a5,80000878 <uartstart+0x42>
  }
}
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
{
    800008bc:	7179                	addi	sp,sp,-48
    800008be:	f406                	sd	ra,40(sp)
    800008c0:	f022                	sd	s0,32(sp)
    800008c2:	ec26                	sd	s1,24(sp)
    800008c4:	e84a                	sd	s2,16(sp)
    800008c6:	e44e                	sd	s3,8(sp)
    800008c8:	e052                	sd	s4,0(sp)
    800008ca:	1800                	addi	s0,sp,48
    800008cc:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ce:	00010517          	auipc	a0,0x10
    800008d2:	2ca50513          	addi	a0,a0,714 # 80010b98 <uart_tx_lock>
    800008d6:	00000097          	auipc	ra,0x0
    800008da:	4e0080e7          	jalr	1248(ra) # 80000db6 <acquire>
  if(panicked){
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	0727a783          	lw	a5,114(a5) # 80008950 <panicked>
    800008e6:	e7c9                	bnez	a5,80000970 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008e8:	00008717          	auipc	a4,0x8
    800008ec:	07873703          	ld	a4,120(a4) # 80008960 <uart_tx_w>
    800008f0:	00008797          	auipc	a5,0x8
    800008f4:	0687b783          	ld	a5,104(a5) # 80008958 <uart_tx_r>
    800008f8:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800008fc:	00010997          	auipc	s3,0x10
    80000900:	29c98993          	addi	s3,s3,668 # 80010b98 <uart_tx_lock>
    80000904:	00008497          	auipc	s1,0x8
    80000908:	05448493          	addi	s1,s1,84 # 80008958 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000090c:	00008917          	auipc	s2,0x8
    80000910:	05490913          	addi	s2,s2,84 # 80008960 <uart_tx_w>
    80000914:	00e79f63          	bne	a5,a4,80000932 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000918:	85ce                	mv	a1,s3
    8000091a:	8526                	mv	a0,s1
    8000091c:	00002097          	auipc	ra,0x2
    80000920:	c8c080e7          	jalr	-884(ra) # 800025a8 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000924:	00093703          	ld	a4,0(s2)
    80000928:	609c                	ld	a5,0(s1)
    8000092a:	02078793          	addi	a5,a5,32
    8000092e:	fee785e3          	beq	a5,a4,80000918 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000932:	00010497          	auipc	s1,0x10
    80000936:	26648493          	addi	s1,s1,614 # 80010b98 <uart_tx_lock>
    8000093a:	01f77793          	andi	a5,a4,31
    8000093e:	97a6                	add	a5,a5,s1
    80000940:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000944:	0705                	addi	a4,a4,1
    80000946:	00008797          	auipc	a5,0x8
    8000094a:	00e7bd23          	sd	a4,26(a5) # 80008960 <uart_tx_w>
  uartstart();
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	ee8080e7          	jalr	-280(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    80000956:	8526                	mv	a0,s1
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	512080e7          	jalr	1298(ra) # 80000e6a <release>
}
    80000960:	70a2                	ld	ra,40(sp)
    80000962:	7402                	ld	s0,32(sp)
    80000964:	64e2                	ld	s1,24(sp)
    80000966:	6942                	ld	s2,16(sp)
    80000968:	69a2                	ld	s3,8(sp)
    8000096a:	6a02                	ld	s4,0(sp)
    8000096c:	6145                	addi	sp,sp,48
    8000096e:	8082                	ret
    for(;;)
    80000970:	a001                	j	80000970 <uartputc+0xb4>

0000000080000972 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000972:	1141                	addi	sp,sp,-16
    80000974:	e422                	sd	s0,8(sp)
    80000976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000978:	100007b7          	lui	a5,0x10000
    8000097c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000980:	8b85                	andi	a5,a5,1
    80000982:	cb91                	beqz	a5,80000996 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000984:	100007b7          	lui	a5,0x10000
    80000988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000098c:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80000990:	6422                	ld	s0,8(sp)
    80000992:	0141                	addi	sp,sp,16
    80000994:	8082                	ret
    return -1;
    80000996:	557d                	li	a0,-1
    80000998:	bfe5                	j	80000990 <uartgetc+0x1e>

000000008000099a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000099a:	1101                	addi	sp,sp,-32
    8000099c:	ec06                	sd	ra,24(sp)
    8000099e:	e822                	sd	s0,16(sp)
    800009a0:	e426                	sd	s1,8(sp)
    800009a2:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009a4:	54fd                	li	s1,-1
    800009a6:	a029                	j	800009b0 <uartintr+0x16>
      break;
    consoleintr(c);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	916080e7          	jalr	-1770(ra) # 800002be <consoleintr>
    int c = uartgetc();
    800009b0:	00000097          	auipc	ra,0x0
    800009b4:	fc2080e7          	jalr	-62(ra) # 80000972 <uartgetc>
    if(c == -1)
    800009b8:	fe9518e3          	bne	a0,s1,800009a8 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009bc:	00010497          	auipc	s1,0x10
    800009c0:	1dc48493          	addi	s1,s1,476 # 80010b98 <uart_tx_lock>
    800009c4:	8526                	mv	a0,s1
    800009c6:	00000097          	auipc	ra,0x0
    800009ca:	3f0080e7          	jalr	1008(ra) # 80000db6 <acquire>
  uartstart();
    800009ce:	00000097          	auipc	ra,0x0
    800009d2:	e68080e7          	jalr	-408(ra) # 80000836 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	00000097          	auipc	ra,0x0
    800009dc:	492080e7          	jalr	1170(ra) # 80000e6a <release>
}
    800009e0:	60e2                	ld	ra,24(sp)
    800009e2:	6442                	ld	s0,16(sp)
    800009e4:	64a2                	ld	s1,8(sp)
    800009e6:	6105                	addi	sp,sp,32
    800009e8:	8082                	ret

00000000800009ea <get_ref_index>:
    add_ref(p);
    kfree(p);
  }
}
int get_ref_index(void *pa)
{
    800009ea:	1141                	addi	sp,sp,-16
    800009ec:	e422                	sd	s0,8(sp)
    800009ee:	0800                	addi	s0,sp,16
  return ((uint64)pa >> PGSHIFT);
    800009f0:	8131                	srli	a0,a0,0xc
}
    800009f2:	2501                	sext.w	a0,a0
    800009f4:	6422                	ld	s0,8(sp)
    800009f6:	0141                	addi	sp,sp,16
    800009f8:	8082                	ret

00000000800009fa <add_ref>:
void add_ref(void *pa)
{
    800009fa:	1101                	addi	sp,sp,-32
    800009fc:	ec06                	sd	ra,24(sp)
    800009fe:	e822                	sd	s0,16(sp)
    80000a00:	e426                	sd	s1,8(sp)
    80000a02:	1000                	addi	s0,sp,32
    80000a04:	84aa                	mv	s1,a0
  acquire(&lock_for_ref);
    80000a06:	00010517          	auipc	a0,0x10
    80000a0a:	1ca50513          	addi	a0,a0,458 # 80010bd0 <lock_for_ref>
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	3a8080e7          	jalr	936(ra) # 80000db6 <acquire>
  return ((uint64)pa >> PGSHIFT);
    80000a16:	00c4d513          	srli	a0,s1,0xc
    80000a1a:	2501                	sext.w	a0,a0
  int index = get_ref_index(pa);
  if (index == -1)
    80000a1c:	57fd                	li	a5,-1
    80000a1e:	02f50863          	beq	a0,a5,80000a4e <add_ref+0x54>
  {
    release(&lock_for_ref);
    return;
  }
  refc[index] = refc[index] + 1;
    80000a22:	050a                	slli	a0,a0,0x2
    80000a24:	00010797          	auipc	a5,0x10
    80000a28:	1e478793          	addi	a5,a5,484 # 80010c08 <refc>
    80000a2c:	953e                	add	a0,a0,a5
    80000a2e:	411c                	lw	a5,0(a0)
    80000a30:	2785                	addiw	a5,a5,1
    80000a32:	c11c                	sw	a5,0(a0)
  release(&lock_for_ref);
    80000a34:	00010517          	auipc	a0,0x10
    80000a38:	19c50513          	addi	a0,a0,412 # 80010bd0 <lock_for_ref>
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	42e080e7          	jalr	1070(ra) # 80000e6a <release>
}
    80000a44:	60e2                	ld	ra,24(sp)
    80000a46:	6442                	ld	s0,16(sp)
    80000a48:	64a2                	ld	s1,8(sp)
    80000a4a:	6105                	addi	sp,sp,32
    80000a4c:	8082                	ret
    release(&lock_for_ref);
    80000a4e:	00010517          	auipc	a0,0x10
    80000a52:	18250513          	addi	a0,a0,386 # 80010bd0 <lock_for_ref>
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	414080e7          	jalr	1044(ra) # 80000e6a <release>
    return;
    80000a5e:	b7dd                	j	80000a44 <add_ref+0x4a>

0000000080000a60 <dec_ref>:

void dec_ref(void *pa)
{
    80000a60:	1101                	addi	sp,sp,-32
    80000a62:	ec06                	sd	ra,24(sp)
    80000a64:	e822                	sd	s0,16(sp)
    80000a66:	e426                	sd	s1,8(sp)
    80000a68:	1000                	addi	s0,sp,32
    80000a6a:	84aa                	mv	s1,a0

  acquire(&lock_for_ref);
    80000a6c:	00010517          	auipc	a0,0x10
    80000a70:	16450513          	addi	a0,a0,356 # 80010bd0 <lock_for_ref>
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	342080e7          	jalr	834(ra) # 80000db6 <acquire>
  return ((uint64)pa >> PGSHIFT);
    80000a7c:	00c4d513          	srli	a0,s1,0xc
    80000a80:	2501                	sext.w	a0,a0
  int index = get_ref_index(pa);
  if (index == -1)
    80000a82:	57fd                	li	a5,-1
    80000a84:	04f50163          	beq	a0,a5,80000ac6 <dec_ref+0x66>
  {
    release(&lock_for_ref);
    return;
  }
  int cur_count = refc[index];
    80000a88:	00251713          	slli	a4,a0,0x2
    80000a8c:	00010797          	auipc	a5,0x10
    80000a90:	17c78793          	addi	a5,a5,380 # 80010c08 <refc>
    80000a94:	97ba                	add	a5,a5,a4
    80000a96:	439c                	lw	a5,0(a5)
  if (cur_count <= 0)
    80000a98:	04f05063          	blez	a5,80000ad8 <dec_ref+0x78>
  {
    release(&lock_for_ref);
    panic("def a freed page!");
  }
  refc[index] = refc[index] - 1;
    80000a9c:	050a                	slli	a0,a0,0x2
    80000a9e:	00010717          	auipc	a4,0x10
    80000aa2:	16a70713          	addi	a4,a4,362 # 80010c08 <refc>
    80000aa6:	953a                	add	a0,a0,a4
    80000aa8:	37fd                	addiw	a5,a5,-1
    80000aaa:	c11c                	sw	a5,0(a0)
  release(&lock_for_ref);
    80000aac:	00010517          	auipc	a0,0x10
    80000ab0:	12450513          	addi	a0,a0,292 # 80010bd0 <lock_for_ref>
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	3b6080e7          	jalr	950(ra) # 80000e6a <release>
}
    80000abc:	60e2                	ld	ra,24(sp)
    80000abe:	6442                	ld	s0,16(sp)
    80000ac0:	64a2                	ld	s1,8(sp)
    80000ac2:	6105                	addi	sp,sp,32
    80000ac4:	8082                	ret
    release(&lock_for_ref);
    80000ac6:	00010517          	auipc	a0,0x10
    80000aca:	10a50513          	addi	a0,a0,266 # 80010bd0 <lock_for_ref>
    80000ace:	00000097          	auipc	ra,0x0
    80000ad2:	39c080e7          	jalr	924(ra) # 80000e6a <release>
    return;
    80000ad6:	b7dd                	j	80000abc <dec_ref+0x5c>
    release(&lock_for_ref);
    80000ad8:	00010517          	auipc	a0,0x10
    80000adc:	0f850513          	addi	a0,a0,248 # 80010bd0 <lock_for_ref>
    80000ae0:	00000097          	auipc	ra,0x0
    80000ae4:	38a080e7          	jalr	906(ra) # 80000e6a <release>
    panic("def a freed page!");
    80000ae8:	00007517          	auipc	a0,0x7
    80000aec:	57850513          	addi	a0,a0,1400 # 80008060 <digits+0x20>
    80000af0:	00000097          	auipc	ra,0x0
    80000af4:	a4e080e7          	jalr	-1458(ra) # 8000053e <panic>

0000000080000af8 <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000af8:	7179                	addi	sp,sp,-48
    80000afa:	f406                	sd	ra,40(sp)
    80000afc:	f022                	sd	s0,32(sp)
    80000afe:	ec26                	sd	s1,24(sp)
    80000b00:	e84a                	sd	s2,16(sp)
    80000b02:	e44e                	sd	s3,8(sp)
    80000b04:	1800                	addi	s0,sp,48
    80000b06:	84aa                	mv	s1,a0

  // int res=dec_ref(pa);
  acquire(&lock_for_ref);
    80000b08:	00010517          	auipc	a0,0x10
    80000b0c:	0c850513          	addi	a0,a0,200 # 80010bd0 <lock_for_ref>
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	2a6080e7          	jalr	678(ra) # 80000db6 <acquire>
  return ((uint64)pa >> PGSHIFT);
    80000b18:	00c4d793          	srli	a5,s1,0xc
    80000b1c:	2781                	sext.w	a5,a5
  int index = get_ref_index(pa);
  if (index == -1)
    80000b1e:	577d                	li	a4,-1
    80000b20:	08e78963          	beq	a5,a4,80000bb2 <kfree+0xba>
  {
    release(&lock_for_ref);
    return;
  }
  refc[index] = refc[index] - 1;
    80000b24:	078a                	slli	a5,a5,0x2
    80000b26:	00010717          	auipc	a4,0x10
    80000b2a:	0e270713          	addi	a4,a4,226 # 80010c08 <refc>
    80000b2e:	97ba                	add	a5,a5,a4
    80000b30:	4398                	lw	a4,0(a5)
    80000b32:	377d                	addiw	a4,a4,-1
    80000b34:	0007099b          	sext.w	s3,a4
    80000b38:	c398                	sw	a4,0(a5)
  {
    /* code */
    flag = 0;
  }

  release(&lock_for_ref);
    80000b3a:	00010517          	auipc	a0,0x10
    80000b3e:	09650513          	addi	a0,a0,150 # 80010bd0 <lock_for_ref>
    80000b42:	00000097          	auipc	ra,0x0
    80000b46:	328080e7          	jalr	808(ra) # 80000e6a <release>
  if (flag == 1)
    80000b4a:	04099d63          	bnez	s3,80000ba4 <kfree+0xac>
    return;
  }

  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000b4e:	03449793          	slli	a5,s1,0x34
    80000b52:	ebad                	bnez	a5,80000bc4 <kfree+0xcc>
    80000b54:	00242797          	auipc	a5,0x242
    80000b58:	cc478793          	addi	a5,a5,-828 # 80242818 <end>
    80000b5c:	06f4e463          	bltu	s1,a5,80000bc4 <kfree+0xcc>
    80000b60:	47c5                	li	a5,17
    80000b62:	07ee                	slli	a5,a5,0x1b
    80000b64:	06f4f063          	bgeu	s1,a5,80000bc4 <kfree+0xcc>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000b68:	6605                	lui	a2,0x1
    80000b6a:	4585                	li	a1,1
    80000b6c:	8526                	mv	a0,s1
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	344080e7          	jalr	836(ra) # 80000eb2 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000b76:	00010997          	auipc	s3,0x10
    80000b7a:	05a98993          	addi	s3,s3,90 # 80010bd0 <lock_for_ref>
    80000b7e:	00010917          	auipc	s2,0x10
    80000b82:	06a90913          	addi	s2,s2,106 # 80010be8 <kmem>
    80000b86:	854a                	mv	a0,s2
    80000b88:	00000097          	auipc	ra,0x0
    80000b8c:	22e080e7          	jalr	558(ra) # 80000db6 <acquire>
  r->next = kmem.freelist;
    80000b90:	0309b783          	ld	a5,48(s3)
    80000b94:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000b96:	0299b823          	sd	s1,48(s3)
  release(&kmem.lock);
    80000b9a:	854a                	mv	a0,s2
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	2ce080e7          	jalr	718(ra) # 80000e6a <release>
}
    80000ba4:	70a2                	ld	ra,40(sp)
    80000ba6:	7402                	ld	s0,32(sp)
    80000ba8:	64e2                	ld	s1,24(sp)
    80000baa:	6942                	ld	s2,16(sp)
    80000bac:	69a2                	ld	s3,8(sp)
    80000bae:	6145                	addi	sp,sp,48
    80000bb0:	8082                	ret
    release(&lock_for_ref);
    80000bb2:	00010517          	auipc	a0,0x10
    80000bb6:	01e50513          	addi	a0,a0,30 # 80010bd0 <lock_for_ref>
    80000bba:	00000097          	auipc	ra,0x0
    80000bbe:	2b0080e7          	jalr	688(ra) # 80000e6a <release>
    return;
    80000bc2:	b7cd                	j	80000ba4 <kfree+0xac>
    panic("kfree");
    80000bc4:	00007517          	auipc	a0,0x7
    80000bc8:	4b450513          	addi	a0,a0,1204 # 80008078 <digits+0x38>
    80000bcc:	00000097          	auipc	ra,0x0
    80000bd0:	972080e7          	jalr	-1678(ra) # 8000053e <panic>

0000000080000bd4 <freerange>:
{
    80000bd4:	7139                	addi	sp,sp,-64
    80000bd6:	fc06                	sd	ra,56(sp)
    80000bd8:	f822                	sd	s0,48(sp)
    80000bda:	f426                	sd	s1,40(sp)
    80000bdc:	f04a                	sd	s2,32(sp)
    80000bde:	ec4e                	sd	s3,24(sp)
    80000be0:	e852                	sd	s4,16(sp)
    80000be2:	e456                	sd	s5,8(sp)
    80000be4:	0080                	addi	s0,sp,64
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000be6:	6785                	lui	a5,0x1
    80000be8:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000bec:	94aa                	add	s1,s1,a0
    80000bee:	757d                	lui	a0,0xfffff
    80000bf0:	8ce9                	and	s1,s1,a0
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000bf2:	94be                	add	s1,s1,a5
    80000bf4:	0295e463          	bltu	a1,s1,80000c1c <freerange+0x48>
    80000bf8:	89ae                	mv	s3,a1
    80000bfa:	7afd                	lui	s5,0xfffff
    80000bfc:	6a05                	lui	s4,0x1
    80000bfe:	01548933          	add	s2,s1,s5
    add_ref(p);
    80000c02:	854a                	mv	a0,s2
    80000c04:	00000097          	auipc	ra,0x0
    80000c08:	df6080e7          	jalr	-522(ra) # 800009fa <add_ref>
    kfree(p);
    80000c0c:	854a                	mv	a0,s2
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	eea080e7          	jalr	-278(ra) # 80000af8 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000c16:	94d2                	add	s1,s1,s4
    80000c18:	fe99f3e3          	bgeu	s3,s1,80000bfe <freerange+0x2a>
}
    80000c1c:	70e2                	ld	ra,56(sp)
    80000c1e:	7442                	ld	s0,48(sp)
    80000c20:	74a2                	ld	s1,40(sp)
    80000c22:	7902                	ld	s2,32(sp)
    80000c24:	69e2                	ld	s3,24(sp)
    80000c26:	6a42                	ld	s4,16(sp)
    80000c28:	6aa2                	ld	s5,8(sp)
    80000c2a:	6121                	addi	sp,sp,64
    80000c2c:	8082                	ret

0000000080000c2e <kinit>:
{
    80000c2e:	1101                	addi	sp,sp,-32
    80000c30:	ec06                	sd	ra,24(sp)
    80000c32:	e822                	sd	s0,16(sp)
    80000c34:	e426                	sd	s1,8(sp)
    80000c36:	1000                	addi	s0,sp,32
  initlock(&kmem.lock, "kmem");
    80000c38:	00010497          	auipc	s1,0x10
    80000c3c:	f9848493          	addi	s1,s1,-104 # 80010bd0 <lock_for_ref>
    80000c40:	00007597          	auipc	a1,0x7
    80000c44:	44058593          	addi	a1,a1,1088 # 80008080 <digits+0x40>
    80000c48:	00010517          	auipc	a0,0x10
    80000c4c:	fa050513          	addi	a0,a0,-96 # 80010be8 <kmem>
    80000c50:	00000097          	auipc	ra,0x0
    80000c54:	0d6080e7          	jalr	214(ra) # 80000d26 <initlock>
  initlock(&lock_for_ref, "lock_for_ref");
    80000c58:	00007597          	auipc	a1,0x7
    80000c5c:	43058593          	addi	a1,a1,1072 # 80008088 <digits+0x48>
    80000c60:	8526                	mv	a0,s1
    80000c62:	00000097          	auipc	ra,0x0
    80000c66:	0c4080e7          	jalr	196(ra) # 80000d26 <initlock>
  acquire(&lock_for_ref);
    80000c6a:	8526                	mv	a0,s1
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	14a080e7          	jalr	330(ra) # 80000db6 <acquire>
  memset(&refc, sizeof(refc), 0);
    80000c74:	4601                	li	a2,0
    80000c76:	002205b7          	lui	a1,0x220
    80000c7a:	00010517          	auipc	a0,0x10
    80000c7e:	f8e50513          	addi	a0,a0,-114 # 80010c08 <refc>
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	230080e7          	jalr	560(ra) # 80000eb2 <memset>
  release(&lock_for_ref);
    80000c8a:	8526                	mv	a0,s1
    80000c8c:	00000097          	auipc	ra,0x0
    80000c90:	1de080e7          	jalr	478(ra) # 80000e6a <release>
  freerange(end, (void *)PHYSTOP);
    80000c94:	45c5                	li	a1,17
    80000c96:	05ee                	slli	a1,a1,0x1b
    80000c98:	00242517          	auipc	a0,0x242
    80000c9c:	b8050513          	addi	a0,a0,-1152 # 80242818 <end>
    80000ca0:	00000097          	auipc	ra,0x0
    80000ca4:	f34080e7          	jalr	-204(ra) # 80000bd4 <freerange>
}
    80000ca8:	60e2                	ld	ra,24(sp)
    80000caa:	6442                	ld	s0,16(sp)
    80000cac:	64a2                	ld	s1,8(sp)
    80000cae:	6105                	addi	sp,sp,32
    80000cb0:	8082                	ret

0000000080000cb2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000cb2:	1101                	addi	sp,sp,-32
    80000cb4:	ec06                	sd	ra,24(sp)
    80000cb6:	e822                	sd	s0,16(sp)
    80000cb8:	e426                	sd	s1,8(sp)
    80000cba:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000cbc:	00010517          	auipc	a0,0x10
    80000cc0:	f2c50513          	addi	a0,a0,-212 # 80010be8 <kmem>
    80000cc4:	00000097          	auipc	ra,0x0
    80000cc8:	0f2080e7          	jalr	242(ra) # 80000db6 <acquire>
  r = kmem.freelist;
    80000ccc:	00010497          	auipc	s1,0x10
    80000cd0:	f344b483          	ld	s1,-204(s1) # 80010c00 <kmem+0x18>
  if (r)
    80000cd4:	c0a1                	beqz	s1,80000d14 <kalloc+0x62>
    kmem.freelist = r->next;
    80000cd6:	609c                	ld	a5,0(s1)
    80000cd8:	00010717          	auipc	a4,0x10
    80000cdc:	f2f73423          	sd	a5,-216(a4) # 80010c00 <kmem+0x18>
  release(&kmem.lock);
    80000ce0:	00010517          	auipc	a0,0x10
    80000ce4:	f0850513          	addi	a0,a0,-248 # 80010be8 <kmem>
    80000ce8:	00000097          	auipc	ra,0x0
    80000cec:	182080e7          	jalr	386(ra) # 80000e6a <release>

  if (r)
  {
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000cf0:	6605                	lui	a2,0x1
    80000cf2:	4595                	li	a1,5
    80000cf4:	8526                	mv	a0,s1
    80000cf6:	00000097          	auipc	ra,0x0
    80000cfa:	1bc080e7          	jalr	444(ra) # 80000eb2 <memset>
    add_ref((void *)r);
    80000cfe:	8526                	mv	a0,s1
    80000d00:	00000097          	auipc	ra,0x0
    80000d04:	cfa080e7          	jalr	-774(ra) # 800009fa <add_ref>
  }
  return (void *)r;
}
    80000d08:	8526                	mv	a0,s1
    80000d0a:	60e2                	ld	ra,24(sp)
    80000d0c:	6442                	ld	s0,16(sp)
    80000d0e:	64a2                	ld	s1,8(sp)
    80000d10:	6105                	addi	sp,sp,32
    80000d12:	8082                	ret
  release(&kmem.lock);
    80000d14:	00010517          	auipc	a0,0x10
    80000d18:	ed450513          	addi	a0,a0,-300 # 80010be8 <kmem>
    80000d1c:	00000097          	auipc	ra,0x0
    80000d20:	14e080e7          	jalr	334(ra) # 80000e6a <release>
  if (r)
    80000d24:	b7d5                	j	80000d08 <kalloc+0x56>

0000000080000d26 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000d26:	1141                	addi	sp,sp,-16
    80000d28:	e422                	sd	s0,8(sp)
    80000d2a:	0800                	addi	s0,sp,16
  lk->name = name;
    80000d2c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000d2e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000d32:	00053823          	sd	zero,16(a0)
}
    80000d36:	6422                	ld	s0,8(sp)
    80000d38:	0141                	addi	sp,sp,16
    80000d3a:	8082                	ret

0000000080000d3c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000d3c:	411c                	lw	a5,0(a0)
    80000d3e:	e399                	bnez	a5,80000d44 <holding+0x8>
    80000d40:	4501                	li	a0,0
  return r;
}
    80000d42:	8082                	ret
{
    80000d44:	1101                	addi	sp,sp,-32
    80000d46:	ec06                	sd	ra,24(sp)
    80000d48:	e822                	sd	s0,16(sp)
    80000d4a:	e426                	sd	s1,8(sp)
    80000d4c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000d4e:	6904                	ld	s1,16(a0)
    80000d50:	00001097          	auipc	ra,0x1
    80000d54:	f0c080e7          	jalr	-244(ra) # 80001c5c <mycpu>
    80000d58:	40a48533          	sub	a0,s1,a0
    80000d5c:	00153513          	seqz	a0,a0
}
    80000d60:	60e2                	ld	ra,24(sp)
    80000d62:	6442                	ld	s0,16(sp)
    80000d64:	64a2                	ld	s1,8(sp)
    80000d66:	6105                	addi	sp,sp,32
    80000d68:	8082                	ret

0000000080000d6a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000d6a:	1101                	addi	sp,sp,-32
    80000d6c:	ec06                	sd	ra,24(sp)
    80000d6e:	e822                	sd	s0,16(sp)
    80000d70:	e426                	sd	s1,8(sp)
    80000d72:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d74:	100024f3          	csrr	s1,sstatus
    80000d78:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d7e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d82:	00001097          	auipc	ra,0x1
    80000d86:	eda080e7          	jalr	-294(ra) # 80001c5c <mycpu>
    80000d8a:	5d3c                	lw	a5,120(a0)
    80000d8c:	cf89                	beqz	a5,80000da6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d8e:	00001097          	auipc	ra,0x1
    80000d92:	ece080e7          	jalr	-306(ra) # 80001c5c <mycpu>
    80000d96:	5d3c                	lw	a5,120(a0)
    80000d98:	2785                	addiw	a5,a5,1
    80000d9a:	dd3c                	sw	a5,120(a0)
}
    80000d9c:	60e2                	ld	ra,24(sp)
    80000d9e:	6442                	ld	s0,16(sp)
    80000da0:	64a2                	ld	s1,8(sp)
    80000da2:	6105                	addi	sp,sp,32
    80000da4:	8082                	ret
    mycpu()->intena = old;
    80000da6:	00001097          	auipc	ra,0x1
    80000daa:	eb6080e7          	jalr	-330(ra) # 80001c5c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000dae:	8085                	srli	s1,s1,0x1
    80000db0:	8885                	andi	s1,s1,1
    80000db2:	dd64                	sw	s1,124(a0)
    80000db4:	bfe9                	j	80000d8e <push_off+0x24>

0000000080000db6 <acquire>:
{
    80000db6:	1101                	addi	sp,sp,-32
    80000db8:	ec06                	sd	ra,24(sp)
    80000dba:	e822                	sd	s0,16(sp)
    80000dbc:	e426                	sd	s1,8(sp)
    80000dbe:	1000                	addi	s0,sp,32
    80000dc0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	fa8080e7          	jalr	-88(ra) # 80000d6a <push_off>
  if(holding(lk))
    80000dca:	8526                	mv	a0,s1
    80000dcc:	00000097          	auipc	ra,0x0
    80000dd0:	f70080e7          	jalr	-144(ra) # 80000d3c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000dd4:	4705                	li	a4,1
  if(holding(lk))
    80000dd6:	e115                	bnez	a0,80000dfa <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000dd8:	87ba                	mv	a5,a4
    80000dda:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000dde:	2781                	sext.w	a5,a5
    80000de0:	ffe5                	bnez	a5,80000dd8 <acquire+0x22>
  __sync_synchronize();
    80000de2:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000de6:	00001097          	auipc	ra,0x1
    80000dea:	e76080e7          	jalr	-394(ra) # 80001c5c <mycpu>
    80000dee:	e888                	sd	a0,16(s1)
}
    80000df0:	60e2                	ld	ra,24(sp)
    80000df2:	6442                	ld	s0,16(sp)
    80000df4:	64a2                	ld	s1,8(sp)
    80000df6:	6105                	addi	sp,sp,32
    80000df8:	8082                	ret
    panic("acquire");
    80000dfa:	00007517          	auipc	a0,0x7
    80000dfe:	29e50513          	addi	a0,a0,670 # 80008098 <digits+0x58>
    80000e02:	fffff097          	auipc	ra,0xfffff
    80000e06:	73c080e7          	jalr	1852(ra) # 8000053e <panic>

0000000080000e0a <pop_off>:

void
pop_off(void)
{
    80000e0a:	1141                	addi	sp,sp,-16
    80000e0c:	e406                	sd	ra,8(sp)
    80000e0e:	e022                	sd	s0,0(sp)
    80000e10:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000e12:	00001097          	auipc	ra,0x1
    80000e16:	e4a080e7          	jalr	-438(ra) # 80001c5c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e1a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000e1e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000e20:	e78d                	bnez	a5,80000e4a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000e22:	5d3c                	lw	a5,120(a0)
    80000e24:	02f05b63          	blez	a5,80000e5a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000e28:	37fd                	addiw	a5,a5,-1
    80000e2a:	0007871b          	sext.w	a4,a5
    80000e2e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000e30:	eb09                	bnez	a4,80000e42 <pop_off+0x38>
    80000e32:	5d7c                	lw	a5,124(a0)
    80000e34:	c799                	beqz	a5,80000e42 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000e36:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000e3a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000e3e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000e42:	60a2                	ld	ra,8(sp)
    80000e44:	6402                	ld	s0,0(sp)
    80000e46:	0141                	addi	sp,sp,16
    80000e48:	8082                	ret
    panic("pop_off - interruptible");
    80000e4a:	00007517          	auipc	a0,0x7
    80000e4e:	25650513          	addi	a0,a0,598 # 800080a0 <digits+0x60>
    80000e52:	fffff097          	auipc	ra,0xfffff
    80000e56:	6ec080e7          	jalr	1772(ra) # 8000053e <panic>
    panic("pop_off");
    80000e5a:	00007517          	auipc	a0,0x7
    80000e5e:	25e50513          	addi	a0,a0,606 # 800080b8 <digits+0x78>
    80000e62:	fffff097          	auipc	ra,0xfffff
    80000e66:	6dc080e7          	jalr	1756(ra) # 8000053e <panic>

0000000080000e6a <release>:
{
    80000e6a:	1101                	addi	sp,sp,-32
    80000e6c:	ec06                	sd	ra,24(sp)
    80000e6e:	e822                	sd	s0,16(sp)
    80000e70:	e426                	sd	s1,8(sp)
    80000e72:	1000                	addi	s0,sp,32
    80000e74:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000e76:	00000097          	auipc	ra,0x0
    80000e7a:	ec6080e7          	jalr	-314(ra) # 80000d3c <holding>
    80000e7e:	c115                	beqz	a0,80000ea2 <release+0x38>
  lk->cpu = 0;
    80000e80:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000e84:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000e88:	0f50000f          	fence	iorw,ow
    80000e8c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000e90:	00000097          	auipc	ra,0x0
    80000e94:	f7a080e7          	jalr	-134(ra) # 80000e0a <pop_off>
}
    80000e98:	60e2                	ld	ra,24(sp)
    80000e9a:	6442                	ld	s0,16(sp)
    80000e9c:	64a2                	ld	s1,8(sp)
    80000e9e:	6105                	addi	sp,sp,32
    80000ea0:	8082                	ret
    panic("release");
    80000ea2:	00007517          	auipc	a0,0x7
    80000ea6:	21e50513          	addi	a0,a0,542 # 800080c0 <digits+0x80>
    80000eaa:	fffff097          	auipc	ra,0xfffff
    80000eae:	694080e7          	jalr	1684(ra) # 8000053e <panic>

0000000080000eb2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000eb2:	1141                	addi	sp,sp,-16
    80000eb4:	e422                	sd	s0,8(sp)
    80000eb6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000eb8:	ca19                	beqz	a2,80000ece <memset+0x1c>
    80000eba:	87aa                	mv	a5,a0
    80000ebc:	1602                	slli	a2,a2,0x20
    80000ebe:	9201                	srli	a2,a2,0x20
    80000ec0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ec4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000ec8:	0785                	addi	a5,a5,1
    80000eca:	fee79de3          	bne	a5,a4,80000ec4 <memset+0x12>
  }
  return dst;
}
    80000ece:	6422                	ld	s0,8(sp)
    80000ed0:	0141                	addi	sp,sp,16
    80000ed2:	8082                	ret

0000000080000ed4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ed4:	1141                	addi	sp,sp,-16
    80000ed6:	e422                	sd	s0,8(sp)
    80000ed8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000eda:	ca05                	beqz	a2,80000f0a <memcmp+0x36>
    80000edc:	fff6069b          	addiw	a3,a2,-1
    80000ee0:	1682                	slli	a3,a3,0x20
    80000ee2:	9281                	srli	a3,a3,0x20
    80000ee4:	0685                	addi	a3,a3,1
    80000ee6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000ee8:	00054783          	lbu	a5,0(a0)
    80000eec:	0005c703          	lbu	a4,0(a1) # 220000 <_entry-0x7fde0000>
    80000ef0:	00e79863          	bne	a5,a4,80000f00 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000ef4:	0505                	addi	a0,a0,1
    80000ef6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000ef8:	fed518e3          	bne	a0,a3,80000ee8 <memcmp+0x14>
  }

  return 0;
    80000efc:	4501                	li	a0,0
    80000efe:	a019                	j	80000f04 <memcmp+0x30>
      return *s1 - *s2;
    80000f00:	40e7853b          	subw	a0,a5,a4
}
    80000f04:	6422                	ld	s0,8(sp)
    80000f06:	0141                	addi	sp,sp,16
    80000f08:	8082                	ret
  return 0;
    80000f0a:	4501                	li	a0,0
    80000f0c:	bfe5                	j	80000f04 <memcmp+0x30>

0000000080000f0e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000f0e:	1141                	addi	sp,sp,-16
    80000f10:	e422                	sd	s0,8(sp)
    80000f12:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000f14:	c205                	beqz	a2,80000f34 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000f16:	02a5e263          	bltu	a1,a0,80000f3a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000f1a:	1602                	slli	a2,a2,0x20
    80000f1c:	9201                	srli	a2,a2,0x20
    80000f1e:	00c587b3          	add	a5,a1,a2
{
    80000f22:	872a                	mv	a4,a0
      *d++ = *s++;
    80000f24:	0585                	addi	a1,a1,1
    80000f26:	0705                	addi	a4,a4,1
    80000f28:	fff5c683          	lbu	a3,-1(a1)
    80000f2c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000f30:	fef59ae3          	bne	a1,a5,80000f24 <memmove+0x16>

  return dst;
}
    80000f34:	6422                	ld	s0,8(sp)
    80000f36:	0141                	addi	sp,sp,16
    80000f38:	8082                	ret
  if(s < d && s + n > d){
    80000f3a:	02061693          	slli	a3,a2,0x20
    80000f3e:	9281                	srli	a3,a3,0x20
    80000f40:	00d58733          	add	a4,a1,a3
    80000f44:	fce57be3          	bgeu	a0,a4,80000f1a <memmove+0xc>
    d += n;
    80000f48:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000f4a:	fff6079b          	addiw	a5,a2,-1
    80000f4e:	1782                	slli	a5,a5,0x20
    80000f50:	9381                	srli	a5,a5,0x20
    80000f52:	fff7c793          	not	a5,a5
    80000f56:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000f58:	177d                	addi	a4,a4,-1
    80000f5a:	16fd                	addi	a3,a3,-1
    80000f5c:	00074603          	lbu	a2,0(a4)
    80000f60:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000f64:	fee79ae3          	bne	a5,a4,80000f58 <memmove+0x4a>
    80000f68:	b7f1                	j	80000f34 <memmove+0x26>

0000000080000f6a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000f6a:	1141                	addi	sp,sp,-16
    80000f6c:	e406                	sd	ra,8(sp)
    80000f6e:	e022                	sd	s0,0(sp)
    80000f70:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000f72:	00000097          	auipc	ra,0x0
    80000f76:	f9c080e7          	jalr	-100(ra) # 80000f0e <memmove>
}
    80000f7a:	60a2                	ld	ra,8(sp)
    80000f7c:	6402                	ld	s0,0(sp)
    80000f7e:	0141                	addi	sp,sp,16
    80000f80:	8082                	ret

0000000080000f82 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e422                	sd	s0,8(sp)
    80000f86:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000f88:	ce11                	beqz	a2,80000fa4 <strncmp+0x22>
    80000f8a:	00054783          	lbu	a5,0(a0)
    80000f8e:	cf89                	beqz	a5,80000fa8 <strncmp+0x26>
    80000f90:	0005c703          	lbu	a4,0(a1)
    80000f94:	00f71a63          	bne	a4,a5,80000fa8 <strncmp+0x26>
    n--, p++, q++;
    80000f98:	367d                	addiw	a2,a2,-1
    80000f9a:	0505                	addi	a0,a0,1
    80000f9c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000f9e:	f675                	bnez	a2,80000f8a <strncmp+0x8>
  if(n == 0)
    return 0;
    80000fa0:	4501                	li	a0,0
    80000fa2:	a809                	j	80000fb4 <strncmp+0x32>
    80000fa4:	4501                	li	a0,0
    80000fa6:	a039                	j	80000fb4 <strncmp+0x32>
  if(n == 0)
    80000fa8:	ca09                	beqz	a2,80000fba <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000faa:	00054503          	lbu	a0,0(a0)
    80000fae:	0005c783          	lbu	a5,0(a1)
    80000fb2:	9d1d                	subw	a0,a0,a5
}
    80000fb4:	6422                	ld	s0,8(sp)
    80000fb6:	0141                	addi	sp,sp,16
    80000fb8:	8082                	ret
    return 0;
    80000fba:	4501                	li	a0,0
    80000fbc:	bfe5                	j	80000fb4 <strncmp+0x32>

0000000080000fbe <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000fbe:	1141                	addi	sp,sp,-16
    80000fc0:	e422                	sd	s0,8(sp)
    80000fc2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000fc4:	872a                	mv	a4,a0
    80000fc6:	8832                	mv	a6,a2
    80000fc8:	367d                	addiw	a2,a2,-1
    80000fca:	01005963          	blez	a6,80000fdc <strncpy+0x1e>
    80000fce:	0705                	addi	a4,a4,1
    80000fd0:	0005c783          	lbu	a5,0(a1)
    80000fd4:	fef70fa3          	sb	a5,-1(a4)
    80000fd8:	0585                	addi	a1,a1,1
    80000fda:	f7f5                	bnez	a5,80000fc6 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000fdc:	86ba                	mv	a3,a4
    80000fde:	00c05c63          	blez	a2,80000ff6 <strncpy+0x38>
    *s++ = 0;
    80000fe2:	0685                	addi	a3,a3,1
    80000fe4:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000fe8:	fff6c793          	not	a5,a3
    80000fec:	9fb9                	addw	a5,a5,a4
    80000fee:	010787bb          	addw	a5,a5,a6
    80000ff2:	fef048e3          	bgtz	a5,80000fe2 <strncpy+0x24>
  return os;
}
    80000ff6:	6422                	ld	s0,8(sp)
    80000ff8:	0141                	addi	sp,sp,16
    80000ffa:	8082                	ret

0000000080000ffc <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ffc:	1141                	addi	sp,sp,-16
    80000ffe:	e422                	sd	s0,8(sp)
    80001000:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80001002:	02c05363          	blez	a2,80001028 <safestrcpy+0x2c>
    80001006:	fff6069b          	addiw	a3,a2,-1
    8000100a:	1682                	slli	a3,a3,0x20
    8000100c:	9281                	srli	a3,a3,0x20
    8000100e:	96ae                	add	a3,a3,a1
    80001010:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80001012:	00d58963          	beq	a1,a3,80001024 <safestrcpy+0x28>
    80001016:	0585                	addi	a1,a1,1
    80001018:	0785                	addi	a5,a5,1
    8000101a:	fff5c703          	lbu	a4,-1(a1)
    8000101e:	fee78fa3          	sb	a4,-1(a5)
    80001022:	fb65                	bnez	a4,80001012 <safestrcpy+0x16>
    ;
  *s = 0;
    80001024:	00078023          	sb	zero,0(a5)
  return os;
}
    80001028:	6422                	ld	s0,8(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret

000000008000102e <strlen>:

int
strlen(const char *s)
{
    8000102e:	1141                	addi	sp,sp,-16
    80001030:	e422                	sd	s0,8(sp)
    80001032:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80001034:	00054783          	lbu	a5,0(a0)
    80001038:	cf91                	beqz	a5,80001054 <strlen+0x26>
    8000103a:	0505                	addi	a0,a0,1
    8000103c:	87aa                	mv	a5,a0
    8000103e:	4685                	li	a3,1
    80001040:	9e89                	subw	a3,a3,a0
    80001042:	00f6853b          	addw	a0,a3,a5
    80001046:	0785                	addi	a5,a5,1
    80001048:	fff7c703          	lbu	a4,-1(a5)
    8000104c:	fb7d                	bnez	a4,80001042 <strlen+0x14>
    ;
  return n;
}
    8000104e:	6422                	ld	s0,8(sp)
    80001050:	0141                	addi	sp,sp,16
    80001052:	8082                	ret
  for(n = 0; s[n]; n++)
    80001054:	4501                	li	a0,0
    80001056:	bfe5                	j	8000104e <strlen+0x20>

0000000080001058 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80001058:	1141                	addi	sp,sp,-16
    8000105a:	e406                	sd	ra,8(sp)
    8000105c:	e022                	sd	s0,0(sp)
    8000105e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001060:	00001097          	auipc	ra,0x1
    80001064:	bec080e7          	jalr	-1044(ra) # 80001c4c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80001068:	00008717          	auipc	a4,0x8
    8000106c:	90070713          	addi	a4,a4,-1792 # 80008968 <started>
  if(cpuid() == 0){
    80001070:	c139                	beqz	a0,800010b6 <main+0x5e>
    while(started == 0)
    80001072:	431c                	lw	a5,0(a4)
    80001074:	2781                	sext.w	a5,a5
    80001076:	dff5                	beqz	a5,80001072 <main+0x1a>
      ;
    __sync_synchronize();
    80001078:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000107c:	00001097          	auipc	ra,0x1
    80001080:	bd0080e7          	jalr	-1072(ra) # 80001c4c <cpuid>
    80001084:	85aa                	mv	a1,a0
    80001086:	00007517          	auipc	a0,0x7
    8000108a:	05a50513          	addi	a0,a0,90 # 800080e0 <digits+0xa0>
    8000108e:	fffff097          	auipc	ra,0xfffff
    80001092:	4fa080e7          	jalr	1274(ra) # 80000588 <printf>
    kvminithart();    // turn on paging
    80001096:	00000097          	auipc	ra,0x0
    8000109a:	0d8080e7          	jalr	216(ra) # 8000116e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000109e:	00002097          	auipc	ra,0x2
    800010a2:	d68080e7          	jalr	-664(ra) # 80002e06 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800010a6:	00005097          	auipc	ra,0x5
    800010aa:	5aa080e7          	jalr	1450(ra) # 80006650 <plicinithart>
  }

  scheduler();        
    800010ae:	00001097          	auipc	ra,0x1
    800010b2:	0f4080e7          	jalr	244(ra) # 800021a2 <scheduler>
    consoleinit();
    800010b6:	fffff097          	auipc	ra,0xfffff
    800010ba:	39a080e7          	jalr	922(ra) # 80000450 <consoleinit>
    printfinit();
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	6aa080e7          	jalr	1706(ra) # 80000768 <printfinit>
    printf("\n");
    800010c6:	00007517          	auipc	a0,0x7
    800010ca:	16250513          	addi	a0,a0,354 # 80008228 <digits+0x1e8>
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	4ba080e7          	jalr	1210(ra) # 80000588 <printf>
    printf("xv6 kernel is booting\n");
    800010d6:	00007517          	auipc	a0,0x7
    800010da:	ff250513          	addi	a0,a0,-14 # 800080c8 <digits+0x88>
    800010de:	fffff097          	auipc	ra,0xfffff
    800010e2:	4aa080e7          	jalr	1194(ra) # 80000588 <printf>
    printf("\n");
    800010e6:	00007517          	auipc	a0,0x7
    800010ea:	14250513          	addi	a0,a0,322 # 80008228 <digits+0x1e8>
    800010ee:	fffff097          	auipc	ra,0xfffff
    800010f2:	49a080e7          	jalr	1178(ra) # 80000588 <printf>
    kinit();         // physical page allocator
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	b38080e7          	jalr	-1224(ra) # 80000c2e <kinit>
    kvminit();       // create kernel page table
    800010fe:	00000097          	auipc	ra,0x0
    80001102:	326080e7          	jalr	806(ra) # 80001424 <kvminit>
    kvminithart();   // turn on paging
    80001106:	00000097          	auipc	ra,0x0
    8000110a:	068080e7          	jalr	104(ra) # 8000116e <kvminithart>
    procinit();      // process table
    8000110e:	00001097          	auipc	ra,0x1
    80001112:	a8a080e7          	jalr	-1398(ra) # 80001b98 <procinit>
    trapinit();      // trap vectors
    80001116:	00002097          	auipc	ra,0x2
    8000111a:	cc8080e7          	jalr	-824(ra) # 80002dde <trapinit>
    trapinithart();  // install kernel trap vector
    8000111e:	00002097          	auipc	ra,0x2
    80001122:	ce8080e7          	jalr	-792(ra) # 80002e06 <trapinithart>
    plicinit();      // set up interrupt controller
    80001126:	00005097          	auipc	ra,0x5
    8000112a:	514080e7          	jalr	1300(ra) # 8000663a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000112e:	00005097          	auipc	ra,0x5
    80001132:	522080e7          	jalr	1314(ra) # 80006650 <plicinithart>
    binit();         // buffer cache
    80001136:	00002097          	auipc	ra,0x2
    8000113a:	596080e7          	jalr	1430(ra) # 800036cc <binit>
    iinit();         // inode table
    8000113e:	00003097          	auipc	ra,0x3
    80001142:	c3a080e7          	jalr	-966(ra) # 80003d78 <iinit>
    fileinit();      // file table
    80001146:	00004097          	auipc	ra,0x4
    8000114a:	bd8080e7          	jalr	-1064(ra) # 80004d1e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000114e:	00005097          	auipc	ra,0x5
    80001152:	60a080e7          	jalr	1546(ra) # 80006758 <virtio_disk_init>
    userinit();      // first user process
    80001156:	00001097          	auipc	ra,0x1
    8000115a:	e2e080e7          	jalr	-466(ra) # 80001f84 <userinit>
    __sync_synchronize();
    8000115e:	0ff0000f          	fence
    started = 1;
    80001162:	4785                	li	a5,1
    80001164:	00008717          	auipc	a4,0x8
    80001168:	80f72223          	sw	a5,-2044(a4) # 80008968 <started>
    8000116c:	b789                	j	800010ae <main+0x56>

000000008000116e <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    8000116e:	1141                	addi	sp,sp,-16
    80001170:	e422                	sd	s0,8(sp)
    80001172:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001174:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001178:	00007797          	auipc	a5,0x7
    8000117c:	7f87b783          	ld	a5,2040(a5) # 80008970 <kernel_pagetable>
    80001180:	83b1                	srli	a5,a5,0xc
    80001182:	577d                	li	a4,-1
    80001184:	177e                	slli	a4,a4,0x3f
    80001186:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001188:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000118c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001190:	6422                	ld	s0,8(sp)
    80001192:	0141                	addi	sp,sp,16
    80001194:	8082                	ret

0000000080001196 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001196:	7139                	addi	sp,sp,-64
    80001198:	fc06                	sd	ra,56(sp)
    8000119a:	f822                	sd	s0,48(sp)
    8000119c:	f426                	sd	s1,40(sp)
    8000119e:	f04a                	sd	s2,32(sp)
    800011a0:	ec4e                	sd	s3,24(sp)
    800011a2:	e852                	sd	s4,16(sp)
    800011a4:	e456                	sd	s5,8(sp)
    800011a6:	e05a                	sd	s6,0(sp)
    800011a8:	0080                	addi	s0,sp,64
    800011aa:	84aa                	mv	s1,a0
    800011ac:	89ae                	mv	s3,a1
    800011ae:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    800011b0:	57fd                	li	a5,-1
    800011b2:	83e9                	srli	a5,a5,0x1a
    800011b4:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    800011b6:	4b31                	li	s6,12
  if (va >= MAXVA)
    800011b8:	04b7f263          	bgeu	a5,a1,800011fc <walk+0x66>
    panic("walk");
    800011bc:	00007517          	auipc	a0,0x7
    800011c0:	f3c50513          	addi	a0,a0,-196 # 800080f8 <digits+0xb8>
    800011c4:	fffff097          	auipc	ra,0xfffff
    800011c8:	37a080e7          	jalr	890(ra) # 8000053e <panic>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    }
    else
    {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    800011cc:	060a8663          	beqz	s5,80001238 <walk+0xa2>
    800011d0:	00000097          	auipc	ra,0x0
    800011d4:	ae2080e7          	jalr	-1310(ra) # 80000cb2 <kalloc>
    800011d8:	84aa                	mv	s1,a0
    800011da:	c529                	beqz	a0,80001224 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800011dc:	6605                	lui	a2,0x1
    800011de:	4581                	li	a1,0
    800011e0:	00000097          	auipc	ra,0x0
    800011e4:	cd2080e7          	jalr	-814(ra) # 80000eb2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800011e8:	00c4d793          	srli	a5,s1,0xc
    800011ec:	07aa                	slli	a5,a5,0xa
    800011ee:	0017e793          	ori	a5,a5,1
    800011f2:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--)
    800011f6:	3a5d                	addiw	s4,s4,-9
    800011f8:	036a0063          	beq	s4,s6,80001218 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800011fc:	0149d933          	srl	s2,s3,s4
    80001200:	1ff97913          	andi	s2,s2,511
    80001204:	090e                	slli	s2,s2,0x3
    80001206:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    80001208:	00093483          	ld	s1,0(s2)
    8000120c:	0014f793          	andi	a5,s1,1
    80001210:	dfd5                	beqz	a5,800011cc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001212:	80a9                	srli	s1,s1,0xa
    80001214:	04b2                	slli	s1,s1,0xc
    80001216:	b7c5                	j	800011f6 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001218:	00c9d513          	srli	a0,s3,0xc
    8000121c:	1ff57513          	andi	a0,a0,511
    80001220:	050e                	slli	a0,a0,0x3
    80001222:	9526                	add	a0,a0,s1
}
    80001224:	70e2                	ld	ra,56(sp)
    80001226:	7442                	ld	s0,48(sp)
    80001228:	74a2                	ld	s1,40(sp)
    8000122a:	7902                	ld	s2,32(sp)
    8000122c:	69e2                	ld	s3,24(sp)
    8000122e:	6a42                	ld	s4,16(sp)
    80001230:	6aa2                	ld	s5,8(sp)
    80001232:	6b02                	ld	s6,0(sp)
    80001234:	6121                	addi	sp,sp,64
    80001236:	8082                	ret
        return 0;
    80001238:	4501                	li	a0,0
    8000123a:	b7ed                	j	80001224 <walk+0x8e>

000000008000123c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    8000123c:	57fd                	li	a5,-1
    8000123e:	83e9                	srli	a5,a5,0x1a
    80001240:	00b7f463          	bgeu	a5,a1,80001248 <walkaddr+0xc>
    return 0;
    80001244:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001246:	8082                	ret
{
    80001248:	1141                	addi	sp,sp,-16
    8000124a:	e406                	sd	ra,8(sp)
    8000124c:	e022                	sd	s0,0(sp)
    8000124e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001250:	4601                	li	a2,0
    80001252:	00000097          	auipc	ra,0x0
    80001256:	f44080e7          	jalr	-188(ra) # 80001196 <walk>
  if (pte == 0)
    8000125a:	c105                	beqz	a0,8000127a <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    8000125c:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    8000125e:	0117f693          	andi	a3,a5,17
    80001262:	4745                	li	a4,17
    return 0;
    80001264:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80001266:	00e68663          	beq	a3,a4,80001272 <walkaddr+0x36>
}
    8000126a:	60a2                	ld	ra,8(sp)
    8000126c:	6402                	ld	s0,0(sp)
    8000126e:	0141                	addi	sp,sp,16
    80001270:	8082                	ret
  pa = PTE2PA(*pte);
    80001272:	00a7d513          	srli	a0,a5,0xa
    80001276:	0532                	slli	a0,a0,0xc
  return pa;
    80001278:	bfcd                	j	8000126a <walkaddr+0x2e>
    return 0;
    8000127a:	4501                	li	a0,0
    8000127c:	b7fd                	j	8000126a <walkaddr+0x2e>

000000008000127e <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000127e:	715d                	addi	sp,sp,-80
    80001280:	e486                	sd	ra,72(sp)
    80001282:	e0a2                	sd	s0,64(sp)
    80001284:	fc26                	sd	s1,56(sp)
    80001286:	f84a                	sd	s2,48(sp)
    80001288:	f44e                	sd	s3,40(sp)
    8000128a:	f052                	sd	s4,32(sp)
    8000128c:	ec56                	sd	s5,24(sp)
    8000128e:	e85a                	sd	s6,16(sp)
    80001290:	e45e                	sd	s7,8(sp)
    80001292:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    80001294:	c639                	beqz	a2,800012e2 <mappages+0x64>
    80001296:	8aaa                	mv	s5,a0
    80001298:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    8000129a:	77fd                	lui	a5,0xfffff
    8000129c:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800012a0:	15fd                	addi	a1,a1,-1
    800012a2:	00c589b3          	add	s3,a1,a2
    800012a6:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    800012aa:	8952                	mv	s2,s4
    800012ac:	41468a33          	sub	s4,a3,s4
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800012b0:	6b85                	lui	s7,0x1
    800012b2:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    800012b6:	4605                	li	a2,1
    800012b8:	85ca                	mv	a1,s2
    800012ba:	8556                	mv	a0,s5
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	eda080e7          	jalr	-294(ra) # 80001196 <walk>
    800012c4:	cd1d                	beqz	a0,80001302 <mappages+0x84>
    if (*pte & PTE_V)
    800012c6:	611c                	ld	a5,0(a0)
    800012c8:	8b85                	andi	a5,a5,1
    800012ca:	e785                	bnez	a5,800012f2 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800012cc:	80b1                	srli	s1,s1,0xc
    800012ce:	04aa                	slli	s1,s1,0xa
    800012d0:	0164e4b3          	or	s1,s1,s6
    800012d4:	0014e493          	ori	s1,s1,1
    800012d8:	e104                	sd	s1,0(a0)
    if (a == last)
    800012da:	05390063          	beq	s2,s3,8000131a <mappages+0x9c>
    a += PGSIZE;
    800012de:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    800012e0:	bfc9                	j	800012b2 <mappages+0x34>
    panic("mappages: size");
    800012e2:	00007517          	auipc	a0,0x7
    800012e6:	e1e50513          	addi	a0,a0,-482 # 80008100 <digits+0xc0>
    800012ea:	fffff097          	auipc	ra,0xfffff
    800012ee:	254080e7          	jalr	596(ra) # 8000053e <panic>
      panic("mappages: remap");
    800012f2:	00007517          	auipc	a0,0x7
    800012f6:	e1e50513          	addi	a0,a0,-482 # 80008110 <digits+0xd0>
    800012fa:	fffff097          	auipc	ra,0xfffff
    800012fe:	244080e7          	jalr	580(ra) # 8000053e <panic>
      return -1;
    80001302:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001304:	60a6                	ld	ra,72(sp)
    80001306:	6406                	ld	s0,64(sp)
    80001308:	74e2                	ld	s1,56(sp)
    8000130a:	7942                	ld	s2,48(sp)
    8000130c:	79a2                	ld	s3,40(sp)
    8000130e:	7a02                	ld	s4,32(sp)
    80001310:	6ae2                	ld	s5,24(sp)
    80001312:	6b42                	ld	s6,16(sp)
    80001314:	6ba2                	ld	s7,8(sp)
    80001316:	6161                	addi	sp,sp,80
    80001318:	8082                	ret
  return 0;
    8000131a:	4501                	li	a0,0
    8000131c:	b7e5                	j	80001304 <mappages+0x86>

000000008000131e <kvmmap>:
{
    8000131e:	1141                	addi	sp,sp,-16
    80001320:	e406                	sd	ra,8(sp)
    80001322:	e022                	sd	s0,0(sp)
    80001324:	0800                	addi	s0,sp,16
    80001326:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001328:	86b2                	mv	a3,a2
    8000132a:	863e                	mv	a2,a5
    8000132c:	00000097          	auipc	ra,0x0
    80001330:	f52080e7          	jalr	-174(ra) # 8000127e <mappages>
    80001334:	e509                	bnez	a0,8000133e <kvmmap+0x20>
}
    80001336:	60a2                	ld	ra,8(sp)
    80001338:	6402                	ld	s0,0(sp)
    8000133a:	0141                	addi	sp,sp,16
    8000133c:	8082                	ret
    panic("kvmmap");
    8000133e:	00007517          	auipc	a0,0x7
    80001342:	de250513          	addi	a0,a0,-542 # 80008120 <digits+0xe0>
    80001346:	fffff097          	auipc	ra,0xfffff
    8000134a:	1f8080e7          	jalr	504(ra) # 8000053e <panic>

000000008000134e <kvmmake>:
{
    8000134e:	1101                	addi	sp,sp,-32
    80001350:	ec06                	sd	ra,24(sp)
    80001352:	e822                	sd	s0,16(sp)
    80001354:	e426                	sd	s1,8(sp)
    80001356:	e04a                	sd	s2,0(sp)
    80001358:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000135a:	00000097          	auipc	ra,0x0
    8000135e:	958080e7          	jalr	-1704(ra) # 80000cb2 <kalloc>
    80001362:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001364:	6605                	lui	a2,0x1
    80001366:	4581                	li	a1,0
    80001368:	00000097          	auipc	ra,0x0
    8000136c:	b4a080e7          	jalr	-1206(ra) # 80000eb2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001370:	4719                	li	a4,6
    80001372:	6685                	lui	a3,0x1
    80001374:	10000637          	lui	a2,0x10000
    80001378:	100005b7          	lui	a1,0x10000
    8000137c:	8526                	mv	a0,s1
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	fa0080e7          	jalr	-96(ra) # 8000131e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001386:	4719                	li	a4,6
    80001388:	6685                	lui	a3,0x1
    8000138a:	10001637          	lui	a2,0x10001
    8000138e:	100015b7          	lui	a1,0x10001
    80001392:	8526                	mv	a0,s1
    80001394:	00000097          	auipc	ra,0x0
    80001398:	f8a080e7          	jalr	-118(ra) # 8000131e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000139c:	4719                	li	a4,6
    8000139e:	004006b7          	lui	a3,0x400
    800013a2:	0c000637          	lui	a2,0xc000
    800013a6:	0c0005b7          	lui	a1,0xc000
    800013aa:	8526                	mv	a0,s1
    800013ac:	00000097          	auipc	ra,0x0
    800013b0:	f72080e7          	jalr	-142(ra) # 8000131e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800013b4:	00007917          	auipc	s2,0x7
    800013b8:	c4c90913          	addi	s2,s2,-948 # 80008000 <etext>
    800013bc:	4729                	li	a4,10
    800013be:	80007697          	auipc	a3,0x80007
    800013c2:	c4268693          	addi	a3,a3,-958 # 8000 <_entry-0x7fff8000>
    800013c6:	4605                	li	a2,1
    800013c8:	067e                	slli	a2,a2,0x1f
    800013ca:	85b2                	mv	a1,a2
    800013cc:	8526                	mv	a0,s1
    800013ce:	00000097          	auipc	ra,0x0
    800013d2:	f50080e7          	jalr	-176(ra) # 8000131e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800013d6:	4719                	li	a4,6
    800013d8:	46c5                	li	a3,17
    800013da:	06ee                	slli	a3,a3,0x1b
    800013dc:	412686b3          	sub	a3,a3,s2
    800013e0:	864a                	mv	a2,s2
    800013e2:	85ca                	mv	a1,s2
    800013e4:	8526                	mv	a0,s1
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	f38080e7          	jalr	-200(ra) # 8000131e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013ee:	4729                	li	a4,10
    800013f0:	6685                	lui	a3,0x1
    800013f2:	00006617          	auipc	a2,0x6
    800013f6:	c0e60613          	addi	a2,a2,-1010 # 80007000 <_trampoline>
    800013fa:	040005b7          	lui	a1,0x4000
    800013fe:	15fd                	addi	a1,a1,-1
    80001400:	05b2                	slli	a1,a1,0xc
    80001402:	8526                	mv	a0,s1
    80001404:	00000097          	auipc	ra,0x0
    80001408:	f1a080e7          	jalr	-230(ra) # 8000131e <kvmmap>
  proc_mapstacks(kpgtbl);
    8000140c:	8526                	mv	a0,s1
    8000140e:	00000097          	auipc	ra,0x0
    80001412:	6f4080e7          	jalr	1780(ra) # 80001b02 <proc_mapstacks>
}
    80001416:	8526                	mv	a0,s1
    80001418:	60e2                	ld	ra,24(sp)
    8000141a:	6442                	ld	s0,16(sp)
    8000141c:	64a2                	ld	s1,8(sp)
    8000141e:	6902                	ld	s2,0(sp)
    80001420:	6105                	addi	sp,sp,32
    80001422:	8082                	ret

0000000080001424 <kvminit>:
{
    80001424:	1141                	addi	sp,sp,-16
    80001426:	e406                	sd	ra,8(sp)
    80001428:	e022                	sd	s0,0(sp)
    8000142a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000142c:	00000097          	auipc	ra,0x0
    80001430:	f22080e7          	jalr	-222(ra) # 8000134e <kvmmake>
    80001434:	00007797          	auipc	a5,0x7
    80001438:	52a7be23          	sd	a0,1340(a5) # 80008970 <kernel_pagetable>
}
    8000143c:	60a2                	ld	ra,8(sp)
    8000143e:	6402                	ld	s0,0(sp)
    80001440:	0141                	addi	sp,sp,16
    80001442:	8082                	ret

0000000080001444 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001444:	715d                	addi	sp,sp,-80
    80001446:	e486                	sd	ra,72(sp)
    80001448:	e0a2                	sd	s0,64(sp)
    8000144a:	fc26                	sd	s1,56(sp)
    8000144c:	f84a                	sd	s2,48(sp)
    8000144e:	f44e                	sd	s3,40(sp)
    80001450:	f052                	sd	s4,32(sp)
    80001452:	ec56                	sd	s5,24(sp)
    80001454:	e85a                	sd	s6,16(sp)
    80001456:	e45e                	sd	s7,8(sp)
    80001458:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    8000145a:	03459793          	slli	a5,a1,0x34
    8000145e:	e795                	bnez	a5,8000148a <uvmunmap+0x46>
    80001460:	8a2a                	mv	s4,a0
    80001462:	892e                	mv	s2,a1
    80001464:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80001466:	0632                	slli	a2,a2,0xc
    80001468:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    8000146c:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000146e:	6b05                	lui	s6,0x1
    80001470:	0735e263          	bltu	a1,s3,800014d4 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
  }
}
    80001474:	60a6                	ld	ra,72(sp)
    80001476:	6406                	ld	s0,64(sp)
    80001478:	74e2                	ld	s1,56(sp)
    8000147a:	7942                	ld	s2,48(sp)
    8000147c:	79a2                	ld	s3,40(sp)
    8000147e:	7a02                	ld	s4,32(sp)
    80001480:	6ae2                	ld	s5,24(sp)
    80001482:	6b42                	ld	s6,16(sp)
    80001484:	6ba2                	ld	s7,8(sp)
    80001486:	6161                	addi	sp,sp,80
    80001488:	8082                	ret
    panic("uvmunmap: not aligned");
    8000148a:	00007517          	auipc	a0,0x7
    8000148e:	c9e50513          	addi	a0,a0,-866 # 80008128 <digits+0xe8>
    80001492:	fffff097          	auipc	ra,0xfffff
    80001496:	0ac080e7          	jalr	172(ra) # 8000053e <panic>
      panic("uvmunmap: walk");
    8000149a:	00007517          	auipc	a0,0x7
    8000149e:	ca650513          	addi	a0,a0,-858 # 80008140 <digits+0x100>
    800014a2:	fffff097          	auipc	ra,0xfffff
    800014a6:	09c080e7          	jalr	156(ra) # 8000053e <panic>
      panic("uvmunmap: not mapped");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	ca650513          	addi	a0,a0,-858 # 80008150 <digits+0x110>
    800014b2:	fffff097          	auipc	ra,0xfffff
    800014b6:	08c080e7          	jalr	140(ra) # 8000053e <panic>
      panic("uvmunmap: not a leaf");
    800014ba:	00007517          	auipc	a0,0x7
    800014be:	cae50513          	addi	a0,a0,-850 # 80008168 <digits+0x128>
    800014c2:	fffff097          	auipc	ra,0xfffff
    800014c6:	07c080e7          	jalr	124(ra) # 8000053e <panic>
    *pte = 0;
    800014ca:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800014ce:	995a                	add	s2,s2,s6
    800014d0:	fb3972e3          	bgeu	s2,s3,80001474 <uvmunmap+0x30>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800014d4:	4601                	li	a2,0
    800014d6:	85ca                	mv	a1,s2
    800014d8:	8552                	mv	a0,s4
    800014da:	00000097          	auipc	ra,0x0
    800014de:	cbc080e7          	jalr	-836(ra) # 80001196 <walk>
    800014e2:	84aa                	mv	s1,a0
    800014e4:	d95d                	beqz	a0,8000149a <uvmunmap+0x56>
    if ((*pte & PTE_V) == 0)
    800014e6:	6108                	ld	a0,0(a0)
    800014e8:	00157793          	andi	a5,a0,1
    800014ec:	dfdd                	beqz	a5,800014aa <uvmunmap+0x66>
    if (PTE_FLAGS(*pte) == PTE_V)
    800014ee:	3ff57793          	andi	a5,a0,1023
    800014f2:	fd7784e3          	beq	a5,s7,800014ba <uvmunmap+0x76>
    if (do_free)
    800014f6:	fc0a8ae3          	beqz	s5,800014ca <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800014fa:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    800014fc:	0532                	slli	a0,a0,0xc
    800014fe:	fffff097          	auipc	ra,0xfffff
    80001502:	5fa080e7          	jalr	1530(ra) # 80000af8 <kfree>
    80001506:	b7d1                	j	800014ca <uvmunmap+0x86>

0000000080001508 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001508:	1101                	addi	sp,sp,-32
    8000150a:	ec06                	sd	ra,24(sp)
    8000150c:	e822                	sd	s0,16(sp)
    8000150e:	e426                	sd	s1,8(sp)
    80001510:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    80001512:	fffff097          	auipc	ra,0xfffff
    80001516:	7a0080e7          	jalr	1952(ra) # 80000cb2 <kalloc>
    8000151a:	84aa                	mv	s1,a0
  if (pagetable == 0)
    8000151c:	c519                	beqz	a0,8000152a <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000151e:	6605                	lui	a2,0x1
    80001520:	4581                	li	a1,0
    80001522:	00000097          	auipc	ra,0x0
    80001526:	990080e7          	jalr	-1648(ra) # 80000eb2 <memset>
  return pagetable;
}
    8000152a:	8526                	mv	a0,s1
    8000152c:	60e2                	ld	ra,24(sp)
    8000152e:	6442                	ld	s0,16(sp)
    80001530:	64a2                	ld	s1,8(sp)
    80001532:	6105                	addi	sp,sp,32
    80001534:	8082                	ret

0000000080001536 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001536:	7179                	addi	sp,sp,-48
    80001538:	f406                	sd	ra,40(sp)
    8000153a:	f022                	sd	s0,32(sp)
    8000153c:	ec26                	sd	s1,24(sp)
    8000153e:	e84a                	sd	s2,16(sp)
    80001540:	e44e                	sd	s3,8(sp)
    80001542:	e052                	sd	s4,0(sp)
    80001544:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    80001546:	6785                	lui	a5,0x1
    80001548:	04f67863          	bgeu	a2,a5,80001598 <uvmfirst+0x62>
    8000154c:	8a2a                	mv	s4,a0
    8000154e:	89ae                	mv	s3,a1
    80001550:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001552:	fffff097          	auipc	ra,0xfffff
    80001556:	760080e7          	jalr	1888(ra) # 80000cb2 <kalloc>
    8000155a:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000155c:	6605                	lui	a2,0x1
    8000155e:	4581                	li	a1,0
    80001560:	00000097          	auipc	ra,0x0
    80001564:	952080e7          	jalr	-1710(ra) # 80000eb2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80001568:	4779                	li	a4,30
    8000156a:	86ca                	mv	a3,s2
    8000156c:	6605                	lui	a2,0x1
    8000156e:	4581                	li	a1,0
    80001570:	8552                	mv	a0,s4
    80001572:	00000097          	auipc	ra,0x0
    80001576:	d0c080e7          	jalr	-756(ra) # 8000127e <mappages>
  memmove(mem, src, sz);
    8000157a:	8626                	mv	a2,s1
    8000157c:	85ce                	mv	a1,s3
    8000157e:	854a                	mv	a0,s2
    80001580:	00000097          	auipc	ra,0x0
    80001584:	98e080e7          	jalr	-1650(ra) # 80000f0e <memmove>
}
    80001588:	70a2                	ld	ra,40(sp)
    8000158a:	7402                	ld	s0,32(sp)
    8000158c:	64e2                	ld	s1,24(sp)
    8000158e:	6942                	ld	s2,16(sp)
    80001590:	69a2                	ld	s3,8(sp)
    80001592:	6a02                	ld	s4,0(sp)
    80001594:	6145                	addi	sp,sp,48
    80001596:	8082                	ret
    panic("uvmfirst: more than a page");
    80001598:	00007517          	auipc	a0,0x7
    8000159c:	be850513          	addi	a0,a0,-1048 # 80008180 <digits+0x140>
    800015a0:	fffff097          	auipc	ra,0xfffff
    800015a4:	f9e080e7          	jalr	-98(ra) # 8000053e <panic>

00000000800015a8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800015a8:	1101                	addi	sp,sp,-32
    800015aa:	ec06                	sd	ra,24(sp)
    800015ac:	e822                	sd	s0,16(sp)
    800015ae:	e426                	sd	s1,8(sp)
    800015b0:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800015b2:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800015b4:	00b67d63          	bgeu	a2,a1,800015ce <uvmdealloc+0x26>
    800015b8:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800015ba:	6785                	lui	a5,0x1
    800015bc:	17fd                	addi	a5,a5,-1
    800015be:	00f60733          	add	a4,a2,a5
    800015c2:	767d                	lui	a2,0xfffff
    800015c4:	8f71                	and	a4,a4,a2
    800015c6:	97ae                	add	a5,a5,a1
    800015c8:	8ff1                	and	a5,a5,a2
    800015ca:	00f76863          	bltu	a4,a5,800015da <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800015ce:	8526                	mv	a0,s1
    800015d0:	60e2                	ld	ra,24(sp)
    800015d2:	6442                	ld	s0,16(sp)
    800015d4:	64a2                	ld	s1,8(sp)
    800015d6:	6105                	addi	sp,sp,32
    800015d8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800015da:	8f99                	sub	a5,a5,a4
    800015dc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800015de:	4685                	li	a3,1
    800015e0:	0007861b          	sext.w	a2,a5
    800015e4:	85ba                	mv	a1,a4
    800015e6:	00000097          	auipc	ra,0x0
    800015ea:	e5e080e7          	jalr	-418(ra) # 80001444 <uvmunmap>
    800015ee:	b7c5                	j	800015ce <uvmdealloc+0x26>

00000000800015f0 <uvmalloc>:
  if (newsz < oldsz)
    800015f0:	0ab66563          	bltu	a2,a1,8000169a <uvmalloc+0xaa>
{
    800015f4:	7139                	addi	sp,sp,-64
    800015f6:	fc06                	sd	ra,56(sp)
    800015f8:	f822                	sd	s0,48(sp)
    800015fa:	f426                	sd	s1,40(sp)
    800015fc:	f04a                	sd	s2,32(sp)
    800015fe:	ec4e                	sd	s3,24(sp)
    80001600:	e852                	sd	s4,16(sp)
    80001602:	e456                	sd	s5,8(sp)
    80001604:	e05a                	sd	s6,0(sp)
    80001606:	0080                	addi	s0,sp,64
    80001608:	8aaa                	mv	s5,a0
    8000160a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000160c:	6985                	lui	s3,0x1
    8000160e:	19fd                	addi	s3,s3,-1
    80001610:	95ce                	add	a1,a1,s3
    80001612:	79fd                	lui	s3,0xfffff
    80001614:	0135f9b3          	and	s3,a1,s3
  for (a = oldsz; a < newsz; a += PGSIZE)
    80001618:	08c9f363          	bgeu	s3,a2,8000169e <uvmalloc+0xae>
    8000161c:	894e                	mv	s2,s3
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    8000161e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	690080e7          	jalr	1680(ra) # 80000cb2 <kalloc>
    8000162a:	84aa                	mv	s1,a0
    if (mem == 0)
    8000162c:	c51d                	beqz	a0,8000165a <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000162e:	6605                	lui	a2,0x1
    80001630:	4581                	li	a1,0
    80001632:	00000097          	auipc	ra,0x0
    80001636:	880080e7          	jalr	-1920(ra) # 80000eb2 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    8000163a:	875a                	mv	a4,s6
    8000163c:	86a6                	mv	a3,s1
    8000163e:	6605                	lui	a2,0x1
    80001640:	85ca                	mv	a1,s2
    80001642:	8556                	mv	a0,s5
    80001644:	00000097          	auipc	ra,0x0
    80001648:	c3a080e7          	jalr	-966(ra) # 8000127e <mappages>
    8000164c:	e90d                	bnez	a0,8000167e <uvmalloc+0x8e>
  for (a = oldsz; a < newsz; a += PGSIZE)
    8000164e:	6785                	lui	a5,0x1
    80001650:	993e                	add	s2,s2,a5
    80001652:	fd4968e3          	bltu	s2,s4,80001622 <uvmalloc+0x32>
  return newsz;
    80001656:	8552                	mv	a0,s4
    80001658:	a809                	j	8000166a <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000165a:	864e                	mv	a2,s3
    8000165c:	85ca                	mv	a1,s2
    8000165e:	8556                	mv	a0,s5
    80001660:	00000097          	auipc	ra,0x0
    80001664:	f48080e7          	jalr	-184(ra) # 800015a8 <uvmdealloc>
      return 0;
    80001668:	4501                	li	a0,0
}
    8000166a:	70e2                	ld	ra,56(sp)
    8000166c:	7442                	ld	s0,48(sp)
    8000166e:	74a2                	ld	s1,40(sp)
    80001670:	7902                	ld	s2,32(sp)
    80001672:	69e2                	ld	s3,24(sp)
    80001674:	6a42                	ld	s4,16(sp)
    80001676:	6aa2                	ld	s5,8(sp)
    80001678:	6b02                	ld	s6,0(sp)
    8000167a:	6121                	addi	sp,sp,64
    8000167c:	8082                	ret
      kfree(mem);
    8000167e:	8526                	mv	a0,s1
    80001680:	fffff097          	auipc	ra,0xfffff
    80001684:	478080e7          	jalr	1144(ra) # 80000af8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001688:	864e                	mv	a2,s3
    8000168a:	85ca                	mv	a1,s2
    8000168c:	8556                	mv	a0,s5
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	f1a080e7          	jalr	-230(ra) # 800015a8 <uvmdealloc>
      return 0;
    80001696:	4501                	li	a0,0
    80001698:	bfc9                	j	8000166a <uvmalloc+0x7a>
    return oldsz;
    8000169a:	852e                	mv	a0,a1
}
    8000169c:	8082                	ret
  return newsz;
    8000169e:	8532                	mv	a0,a2
    800016a0:	b7e9                	j	8000166a <uvmalloc+0x7a>

00000000800016a2 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    800016a2:	7179                	addi	sp,sp,-48
    800016a4:	f406                	sd	ra,40(sp)
    800016a6:	f022                	sd	s0,32(sp)
    800016a8:	ec26                	sd	s1,24(sp)
    800016aa:	e84a                	sd	s2,16(sp)
    800016ac:	e44e                	sd	s3,8(sp)
    800016ae:	e052                	sd	s4,0(sp)
    800016b0:	1800                	addi	s0,sp,48
    800016b2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    800016b4:	84aa                	mv	s1,a0
    800016b6:	6905                	lui	s2,0x1
    800016b8:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800016ba:	4985                	li	s3,1
    800016bc:	a821                	j	800016d4 <freewalk+0x32>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800016be:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800016c0:	0532                	slli	a0,a0,0xc
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	fe0080e7          	jalr	-32(ra) # 800016a2 <freewalk>
      pagetable[i] = 0;
    800016ca:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    800016ce:	04a1                	addi	s1,s1,8
    800016d0:	03248163          	beq	s1,s2,800016f2 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800016d4:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800016d6:	00f57793          	andi	a5,a0,15
    800016da:	ff3782e3          	beq	a5,s3,800016be <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    800016de:	8905                	andi	a0,a0,1
    800016e0:	d57d                	beqz	a0,800016ce <freewalk+0x2c>
    {
      panic("freewalk: leaf");
    800016e2:	00007517          	auipc	a0,0x7
    800016e6:	abe50513          	addi	a0,a0,-1346 # 800081a0 <digits+0x160>
    800016ea:	fffff097          	auipc	ra,0xfffff
    800016ee:	e54080e7          	jalr	-428(ra) # 8000053e <panic>
    }
  }
  kfree((void *)pagetable);
    800016f2:	8552                	mv	a0,s4
    800016f4:	fffff097          	auipc	ra,0xfffff
    800016f8:	404080e7          	jalr	1028(ra) # 80000af8 <kfree>
}
    800016fc:	70a2                	ld	ra,40(sp)
    800016fe:	7402                	ld	s0,32(sp)
    80001700:	64e2                	ld	s1,24(sp)
    80001702:	6942                	ld	s2,16(sp)
    80001704:	69a2                	ld	s3,8(sp)
    80001706:	6a02                	ld	s4,0(sp)
    80001708:	6145                	addi	sp,sp,48
    8000170a:	8082                	ret

000000008000170c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000170c:	1101                	addi	sp,sp,-32
    8000170e:	ec06                	sd	ra,24(sp)
    80001710:	e822                	sd	s0,16(sp)
    80001712:	e426                	sd	s1,8(sp)
    80001714:	1000                	addi	s0,sp,32
    80001716:	84aa                	mv	s1,a0
  if (sz > 0)
    80001718:	e999                	bnez	a1,8000172e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    8000171a:	8526                	mv	a0,s1
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	f86080e7          	jalr	-122(ra) # 800016a2 <freewalk>
}
    80001724:	60e2                	ld	ra,24(sp)
    80001726:	6442                	ld	s0,16(sp)
    80001728:	64a2                	ld	s1,8(sp)
    8000172a:	6105                	addi	sp,sp,32
    8000172c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    8000172e:	6605                	lui	a2,0x1
    80001730:	167d                	addi	a2,a2,-1
    80001732:	962e                	add	a2,a2,a1
    80001734:	4685                	li	a3,1
    80001736:	8231                	srli	a2,a2,0xc
    80001738:	4581                	li	a1,0
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	d0a080e7          	jalr	-758(ra) # 80001444 <uvmunmap>
    80001742:	bfe1                	j	8000171a <uvmfree+0xe>

0000000080001744 <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80001744:	711d                	addi	sp,sp,-96
    80001746:	ec86                	sd	ra,88(sp)
    80001748:	e8a2                	sd	s0,80(sp)
    8000174a:	e4a6                	sd	s1,72(sp)
    8000174c:	e0ca                	sd	s2,64(sp)
    8000174e:	fc4e                	sd	s3,56(sp)
    80001750:	f852                	sd	s4,48(sp)
    80001752:	f456                	sd	s5,40(sp)
    80001754:	f05a                	sd	s6,32(sp)
    80001756:	ec5e                	sd	s7,24(sp)
    80001758:	e862                	sd	s8,16(sp)
    8000175a:	e466                	sd	s9,8(sp)
    8000175c:	1080                	addi	s0,sp,96
    8000175e:	8b2a                	mv	s6,a0
    80001760:	8aae                	mv	s5,a1
    80001762:	8a32                	mv	s4,a2
  //   }
  // }
  pte_t *pte;
  uint64 pa, I;
  uint flags;
  printf("");
    80001764:	00007517          	auipc	a0,0x7
    80001768:	c6c50513          	addi	a0,a0,-916 # 800083d0 <states.0+0xb0>
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	e1c080e7          	jalr	-484(ra) # 80000588 <printf>
  for (I = 0; I < sz; I += PGSIZE)
    80001774:	0c0a0e63          	beqz	s4,80001850 <uvmcopy+0x10c>
    80001778:	4981                	li	s3,0
      if (mappages(new, I, PGSIZE, (uint64)pa, flags) != 0)
      {
        // kfree(mem);
        goto err;
      }
      *pte = PA2PTE(pa) | flags;
    8000177a:	7bfd                	lui	s7,0xfffff
    8000177c:	002bdb93          	srli	s7,s7,0x2
    80001780:	a0a9                	j	800017ca <uvmcopy+0x86>
      panic("uvmcopy : pte should exist");
    80001782:	00007517          	auipc	a0,0x7
    80001786:	a2e50513          	addi	a0,a0,-1490 # 800081b0 <digits+0x170>
    8000178a:	fffff097          	auipc	ra,0xfffff
    8000178e:	db4080e7          	jalr	-588(ra) # 8000053e <panic>
      panic("uvmcopy : page not present");
    80001792:	00007517          	auipc	a0,0x7
    80001796:	a3e50513          	addi	a0,a0,-1474 # 800081d0 <digits+0x190>
    8000179a:	fffff097          	auipc	ra,0xfffff
    8000179e:	da4080e7          	jalr	-604(ra) # 8000053e <panic>
    }
    else
    {
      if (mappages(new, I, PGSIZE, (uint64)pa, flags) != 0)
    800017a2:	3ff77713          	andi	a4,a4,1023
    800017a6:	86e2                	mv	a3,s8
    800017a8:	6605                	lui	a2,0x1
    800017aa:	85ce                	mv	a1,s3
    800017ac:	8556                	mv	a0,s5
    800017ae:	00000097          	auipc	ra,0x0
    800017b2:	ad0080e7          	jalr	-1328(ra) # 8000127e <mappages>
    800017b6:	e535                	bnez	a0,80001822 <uvmcopy+0xde>
      }
    }

    // map the parent’s physical pages into the child
    // Bump the reference count*
    add_ref((void *)pa);
    800017b8:	8562                	mv	a0,s8
    800017ba:	fffff097          	auipc	ra,0xfffff
    800017be:	240080e7          	jalr	576(ra) # 800009fa <add_ref>
  for (I = 0; I < sz; I += PGSIZE)
    800017c2:	6785                	lui	a5,0x1
    800017c4:	99be                	add	s3,s3,a5
    800017c6:	0549fc63          	bgeu	s3,s4,8000181e <uvmcopy+0xda>
    if ((pte = walk(old, I, 0)) == 0)
    800017ca:	4601                	li	a2,0
    800017cc:	85ce                	mv	a1,s3
    800017ce:	855a                	mv	a0,s6
    800017d0:	00000097          	auipc	ra,0x0
    800017d4:	9c6080e7          	jalr	-1594(ra) # 80001196 <walk>
    800017d8:	892a                	mv	s2,a0
    800017da:	d545                	beqz	a0,80001782 <uvmcopy+0x3e>
    if ((*pte & PTE_V) == 0)
    800017dc:	6104                	ld	s1,0(a0)
    800017de:	0014f793          	andi	a5,s1,1
    800017e2:	dbc5                	beqz	a5,80001792 <uvmcopy+0x4e>
    pa = PTE2PA(*pte);
    800017e4:	00a4dc13          	srli	s8,s1,0xa
    800017e8:	0c32                	slli	s8,s8,0xc
    flags = PTE_FLAGS(*pte);
    800017ea:	0004871b          	sext.w	a4,s1
    if (*pte & PTE_W)
    800017ee:	0044f793          	andi	a5,s1,4
    800017f2:	dbc5                	beqz	a5,800017a2 <uvmcopy+0x5e>
      flags &= (~PTE_W);
    800017f4:	3fb77713          	andi	a4,a4,1019
    800017f8:	10076c93          	ori	s9,a4,256
      if (mappages(new, I, PGSIZE, (uint64)pa, flags) != 0)
    800017fc:	8766                	mv	a4,s9
    800017fe:	86e2                	mv	a3,s8
    80001800:	6605                	lui	a2,0x1
    80001802:	85ce                	mv	a1,s3
    80001804:	8556                	mv	a0,s5
    80001806:	00000097          	auipc	ra,0x0
    8000180a:	a78080e7          	jalr	-1416(ra) # 8000127e <mappages>
    8000180e:	e911                	bnez	a0,80001822 <uvmcopy+0xde>
      *pte = PA2PTE(pa) | flags;
    80001810:	0174f4b3          	and	s1,s1,s7
    80001814:	009ce4b3          	or	s1,s9,s1
    80001818:	00993023          	sd	s1,0(s2) # 1000 <_entry-0x7ffff000>
    8000181c:	bf71                	j	800017b8 <uvmcopy+0x74>
    // {
    //   goto err;
    // }

  }
  return 0;
    8000181e:	4501                	li	a0,0
    80001820:	a819                	j	80001836 <uvmcopy+0xf2>
err:
  uvmunmap(new, 0, I / PGSIZE, 1);
    80001822:	4685                	li	a3,1
    80001824:	00c9d613          	srli	a2,s3,0xc
    80001828:	4581                	li	a1,0
    8000182a:	8556                	mv	a0,s5
    8000182c:	00000097          	auipc	ra,0x0
    80001830:	c18080e7          	jalr	-1000(ra) # 80001444 <uvmunmap>
  return -1;
    80001834:	557d                	li	a0,-1
}
    80001836:	60e6                	ld	ra,88(sp)
    80001838:	6446                	ld	s0,80(sp)
    8000183a:	64a6                	ld	s1,72(sp)
    8000183c:	6906                	ld	s2,64(sp)
    8000183e:	79e2                	ld	s3,56(sp)
    80001840:	7a42                	ld	s4,48(sp)
    80001842:	7aa2                	ld	s5,40(sp)
    80001844:	7b02                	ld	s6,32(sp)
    80001846:	6be2                	ld	s7,24(sp)
    80001848:	6c42                	ld	s8,16(sp)
    8000184a:	6ca2                	ld	s9,8(sp)
    8000184c:	6125                	addi	sp,sp,96
    8000184e:	8082                	ret
  return 0;
    80001850:	4501                	li	a0,0
    80001852:	b7d5                	j	80001836 <uvmcopy+0xf2>

0000000080001854 <uvmclear>:
// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80001854:	1141                	addi	sp,sp,-16
    80001856:	e406                	sd	ra,8(sp)
    80001858:	e022                	sd	s0,0(sp)
    8000185a:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    8000185c:	4601                	li	a2,0
    8000185e:	00000097          	auipc	ra,0x0
    80001862:	938080e7          	jalr	-1736(ra) # 80001196 <walk>
  if (pte == 0)
    80001866:	c901                	beqz	a0,80001876 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001868:	611c                	ld	a5,0(a0)
    8000186a:	9bbd                	andi	a5,a5,-17
    8000186c:	e11c                	sd	a5,0(a0)
}
    8000186e:	60a2                	ld	ra,8(sp)
    80001870:	6402                	ld	s0,0(sp)
    80001872:	0141                	addi	sp,sp,16
    80001874:	8082                	ret
    panic("uvmclear");
    80001876:	00007517          	auipc	a0,0x7
    8000187a:	97a50513          	addi	a0,a0,-1670 # 800081f0 <digits+0x1b0>
    8000187e:	fffff097          	auipc	ra,0xfffff
    80001882:	cc0080e7          	jalr	-832(ra) # 8000053e <panic>

0000000080001886 <copyout>:
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  if(dstva >= MAXVA)
    80001886:	57fd                	li	a5,-1
    80001888:	83e9                	srli	a5,a5,0x1a
    8000188a:	10b7e263          	bltu	a5,a1,8000198e <copyout+0x108>
{
    8000188e:	711d                	addi	sp,sp,-96
    80001890:	ec86                	sd	ra,88(sp)
    80001892:	e8a2                	sd	s0,80(sp)
    80001894:	e4a6                	sd	s1,72(sp)
    80001896:	e0ca                	sd	s2,64(sp)
    80001898:	fc4e                	sd	s3,56(sp)
    8000189a:	f852                	sd	s4,48(sp)
    8000189c:	f456                	sd	s5,40(sp)
    8000189e:	f05a                	sd	s6,32(sp)
    800018a0:	ec5e                	sd	s7,24(sp)
    800018a2:	e862                	sd	s8,16(sp)
    800018a4:	e466                	sd	s9,8(sp)
    800018a6:	e06a                	sd	s10,0(sp)
    800018a8:	1080                	addi	s0,sp,96
    800018aa:	8baa                	mv	s7,a0
    800018ac:	84ae                	mv	s1,a1
    800018ae:	8b32                	mv	s6,a2
    800018b0:	8ab6                	mv	s5,a3
  {
    return -1;
  }
  while (len > 0)
    800018b2:	c2e5                	beqz	a3,80001992 <copyout+0x10c>
  {
    va0 = PGROUNDDOWN(dstva);
    800018b4:	7c7d                	lui	s8,0xfffff
    800018b6:	a841                	j	80001946 <copyout+0xc0>
      return -1;
    }

    if (*pte & PTE_RSW)
    {
      pa0 = PTE2PA(*pte);
    800018b8:	00a75c93          	srli	s9,a4,0xa
    800018bc:	0cb2                	slli	s9,s9,0xc
      uint flags = PTE_FLAGS(*pte);
      // +Write, -COW
      flags |= PTE_W;
      flags &= (~PTE_RSW);
    800018be:	2ff77713          	andi	a4,a4,767
    800018c2:	00476a13          	ori	s4,a4,4

      char *mem = kalloc();
    800018c6:	fffff097          	auipc	ra,0xfffff
    800018ca:	3ec080e7          	jalr	1004(ra) # 80000cb2 <kalloc>
    800018ce:	8d2a                	mv	s10,a0
      if(mem==0)
    800018d0:	c575                	beqz	a0,800019bc <copyout+0x136>
      {
        return -1;
      }

      memmove(mem, (void *)pa0, PGSIZE);
    800018d2:	6605                	lui	a2,0x1
    800018d4:	85e6                	mv	a1,s9
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	638080e7          	jalr	1592(ra) # 80000f0e <memmove>
      // uvmunmap(pagetable, va0, PGSIZE, 0);
      kfree((void *)pa0);
    800018de:	8566                	mv	a0,s9
    800018e0:	fffff097          	auipc	ra,0xfffff
    800018e4:	218080e7          	jalr	536(ra) # 80000af8 <kfree>
      *pte = 0;
    800018e8:	00093023          	sd	zero,0(s2)
      if (mappages(pagetable, va0, PGSIZE, (uint64)mem, flags) != 0)
    800018ec:	8752                	mv	a4,s4
    800018ee:	86ea                	mv	a3,s10
    800018f0:	6605                	lui	a2,0x1
    800018f2:	85ce                	mv	a1,s3
    800018f4:	855e                	mv	a0,s7
    800018f6:	00000097          	auipc	ra,0x0
    800018fa:	988080e7          	jalr	-1656(ra) # 8000127e <mappages>
    800018fe:	e919                	bnez	a0,80001914 <copyout+0x8e>
      {
        panic("sometthing is wrong in mappages in trap.\n");
      }
      pa0 = walkaddr(pagetable, va0);
    80001900:	85ce                	mv	a1,s3
    80001902:	855e                	mv	a0,s7
    80001904:	00000097          	auipc	ra,0x0
    80001908:	938080e7          	jalr	-1736(ra) # 8000123c <walkaddr>
    8000190c:	8a2a                	mv	s4,a0
    }
    if (pa0 == 0)
    8000190e:	e535                	bnez	a0,8000197a <copyout+0xf4>
    {
      return -1;
    80001910:	557d                	li	a0,-1
    80001912:	a059                	j	80001998 <copyout+0x112>
        panic("sometthing is wrong in mappages in trap.\n");
    80001914:	00007517          	auipc	a0,0x7
    80001918:	8ec50513          	addi	a0,a0,-1812 # 80008200 <digits+0x1c0>
    8000191c:	fffff097          	auipc	ra,0xfffff
    80001920:	c22080e7          	jalr	-990(ra) # 8000053e <panic>
    }
    n = PGSIZE - (dstva - va0);
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001924:	41348533          	sub	a0,s1,s3
    80001928:	0009061b          	sext.w	a2,s2
    8000192c:	85da                	mv	a1,s6
    8000192e:	9552                	add	a0,a0,s4
    80001930:	fffff097          	auipc	ra,0xfffff
    80001934:	5de080e7          	jalr	1502(ra) # 80000f0e <memmove>

    len -= n;
    80001938:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000193c:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000193e:	6485                	lui	s1,0x1
    80001940:	94ce                	add	s1,s1,s3
  while (len > 0)
    80001942:	040a8463          	beqz	s5,8000198a <copyout+0x104>
    va0 = PGROUNDDOWN(dstva);
    80001946:	0184f9b3          	and	s3,s1,s8
    pa0 = walkaddr(pagetable, va0);
    8000194a:	85ce                	mv	a1,s3
    8000194c:	855e                	mv	a0,s7
    8000194e:	00000097          	auipc	ra,0x0
    80001952:	8ee080e7          	jalr	-1810(ra) # 8000123c <walkaddr>
    80001956:	8a2a                	mv	s4,a0
    if (pa0 == 0)
    80001958:	cd1d                	beqz	a0,80001996 <copyout+0x110>
    pte = walk(pagetable, va0, 0);
    8000195a:	4601                	li	a2,0
    8000195c:	85ce                	mv	a1,s3
    8000195e:	855e                	mv	a0,s7
    80001960:	00000097          	auipc	ra,0x0
    80001964:	836080e7          	jalr	-1994(ra) # 80001196 <walk>
    80001968:	892a                	mv	s2,a0
    if (pte == 0)
    8000196a:	c529                	beqz	a0,800019b4 <copyout+0x12e>
    if ((*pte & PTE_V) == 0)
    8000196c:	6118                	ld	a4,0(a0)
    8000196e:	00177793          	andi	a5,a4,1
    80001972:	c3b9                	beqz	a5,800019b8 <copyout+0x132>
    if (*pte & PTE_RSW)
    80001974:	10077793          	andi	a5,a4,256
    80001978:	f3a1                	bnez	a5,800018b8 <copyout+0x32>
    n = PGSIZE - (dstva - va0);
    8000197a:	40998933          	sub	s2,s3,s1
    8000197e:	6785                	lui	a5,0x1
    80001980:	993e                	add	s2,s2,a5
    if (n > len)
    80001982:	fb2af1e3          	bgeu	s5,s2,80001924 <copyout+0x9e>
    80001986:	8956                	mv	s2,s5
    80001988:	bf71                	j	80001924 <copyout+0x9e>
  }
  return 0;
    8000198a:	4501                	li	a0,0
    8000198c:	a031                	j	80001998 <copyout+0x112>
    return -1;
    8000198e:	557d                	li	a0,-1
}
    80001990:	8082                	ret
  return 0;
    80001992:	4501                	li	a0,0
    80001994:	a011                	j	80001998 <copyout+0x112>
      return -1;
    80001996:	557d                	li	a0,-1
}
    80001998:	60e6                	ld	ra,88(sp)
    8000199a:	6446                	ld	s0,80(sp)
    8000199c:	64a6                	ld	s1,72(sp)
    8000199e:	6906                	ld	s2,64(sp)
    800019a0:	79e2                	ld	s3,56(sp)
    800019a2:	7a42                	ld	s4,48(sp)
    800019a4:	7aa2                	ld	s5,40(sp)
    800019a6:	7b02                	ld	s6,32(sp)
    800019a8:	6be2                	ld	s7,24(sp)
    800019aa:	6c42                	ld	s8,16(sp)
    800019ac:	6ca2                	ld	s9,8(sp)
    800019ae:	6d02                	ld	s10,0(sp)
    800019b0:	6125                	addi	sp,sp,96
    800019b2:	8082                	ret
      return -1;
    800019b4:	557d                	li	a0,-1
    800019b6:	b7cd                	j	80001998 <copyout+0x112>
      return -1;
    800019b8:	557d                	li	a0,-1
    800019ba:	bff9                	j	80001998 <copyout+0x112>
        return -1;
    800019bc:	557d                	li	a0,-1
    800019be:	bfe9                	j	80001998 <copyout+0x112>

00000000800019c0 <copyin>:
// // Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    800019c0:	caa5                	beqz	a3,80001a30 <copyin+0x70>
{
    800019c2:	715d                	addi	sp,sp,-80
    800019c4:	e486                	sd	ra,72(sp)
    800019c6:	e0a2                	sd	s0,64(sp)
    800019c8:	fc26                	sd	s1,56(sp)
    800019ca:	f84a                	sd	s2,48(sp)
    800019cc:	f44e                	sd	s3,40(sp)
    800019ce:	f052                	sd	s4,32(sp)
    800019d0:	ec56                	sd	s5,24(sp)
    800019d2:	e85a                	sd	s6,16(sp)
    800019d4:	e45e                	sd	s7,8(sp)
    800019d6:	e062                	sd	s8,0(sp)
    800019d8:	0880                	addi	s0,sp,80
    800019da:	8b2a                	mv	s6,a0
    800019dc:	8a2e                	mv	s4,a1
    800019de:	8c32                	mv	s8,a2
    800019e0:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    800019e2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800019e4:	6a85                	lui	s5,0x1
    800019e6:	a01d                	j	80001a0c <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800019e8:	018505b3          	add	a1,a0,s8
    800019ec:	0004861b          	sext.w	a2,s1
    800019f0:	412585b3          	sub	a1,a1,s2
    800019f4:	8552                	mv	a0,s4
    800019f6:	fffff097          	auipc	ra,0xfffff
    800019fa:	518080e7          	jalr	1304(ra) # 80000f0e <memmove>

    len -= n;
    800019fe:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001a02:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001a04:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80001a08:	02098263          	beqz	s3,80001a2c <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001a0c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001a10:	85ca                	mv	a1,s2
    80001a12:	855a                	mv	a0,s6
    80001a14:	00000097          	auipc	ra,0x0
    80001a18:	828080e7          	jalr	-2008(ra) # 8000123c <walkaddr>
    if (pa0 == 0)
    80001a1c:	cd01                	beqz	a0,80001a34 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001a1e:	418904b3          	sub	s1,s2,s8
    80001a22:	94d6                	add	s1,s1,s5
    if (n > len)
    80001a24:	fc99f2e3          	bgeu	s3,s1,800019e8 <copyin+0x28>
    80001a28:	84ce                	mv	s1,s3
    80001a2a:	bf7d                	j	800019e8 <copyin+0x28>
  }
  return 0;
    80001a2c:	4501                	li	a0,0
    80001a2e:	a021                	j	80001a36 <copyin+0x76>
    80001a30:	4501                	li	a0,0
}
    80001a32:	8082                	ret
      return -1;
    80001a34:	557d                	li	a0,-1
}
    80001a36:	60a6                	ld	ra,72(sp)
    80001a38:	6406                	ld	s0,64(sp)
    80001a3a:	74e2                	ld	s1,56(sp)
    80001a3c:	7942                	ld	s2,48(sp)
    80001a3e:	79a2                	ld	s3,40(sp)
    80001a40:	7a02                	ld	s4,32(sp)
    80001a42:	6ae2                	ld	s5,24(sp)
    80001a44:	6b42                	ld	s6,16(sp)
    80001a46:	6ba2                	ld	s7,8(sp)
    80001a48:	6c02                	ld	s8,0(sp)
    80001a4a:	6161                	addi	sp,sp,80
    80001a4c:	8082                	ret

0000000080001a4e <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
    80001a4e:	c6c5                	beqz	a3,80001af6 <copyinstr+0xa8>
{
    80001a50:	715d                	addi	sp,sp,-80
    80001a52:	e486                	sd	ra,72(sp)
    80001a54:	e0a2                	sd	s0,64(sp)
    80001a56:	fc26                	sd	s1,56(sp)
    80001a58:	f84a                	sd	s2,48(sp)
    80001a5a:	f44e                	sd	s3,40(sp)
    80001a5c:	f052                	sd	s4,32(sp)
    80001a5e:	ec56                	sd	s5,24(sp)
    80001a60:	e85a                	sd	s6,16(sp)
    80001a62:	e45e                	sd	s7,8(sp)
    80001a64:	0880                	addi	s0,sp,80
    80001a66:	8a2a                	mv	s4,a0
    80001a68:	8b2e                	mv	s6,a1
    80001a6a:	8bb2                	mv	s7,a2
    80001a6c:	84b6                	mv	s1,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80001a6e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001a70:	6985                	lui	s3,0x1
    80001a72:	a035                	j	80001a9e <copyinstr+0x50>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80001a74:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001a78:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80001a7a:	0017b793          	seqz	a5,a5
    80001a7e:	40f00533          	neg	a0,a5
  }
  else
  {
    return -1;
  }
}
    80001a82:	60a6                	ld	ra,72(sp)
    80001a84:	6406                	ld	s0,64(sp)
    80001a86:	74e2                	ld	s1,56(sp)
    80001a88:	7942                	ld	s2,48(sp)
    80001a8a:	79a2                	ld	s3,40(sp)
    80001a8c:	7a02                	ld	s4,32(sp)
    80001a8e:	6ae2                	ld	s5,24(sp)
    80001a90:	6b42                	ld	s6,16(sp)
    80001a92:	6ba2                	ld	s7,8(sp)
    80001a94:	6161                	addi	sp,sp,80
    80001a96:	8082                	ret
    srcva = va0 + PGSIZE;
    80001a98:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0)
    80001a9c:	c8a9                	beqz	s1,80001aee <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001a9e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001aa2:	85ca                	mv	a1,s2
    80001aa4:	8552                	mv	a0,s4
    80001aa6:	fffff097          	auipc	ra,0xfffff
    80001aaa:	796080e7          	jalr	1942(ra) # 8000123c <walkaddr>
    if (pa0 == 0)
    80001aae:	c131                	beqz	a0,80001af2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001ab0:	41790833          	sub	a6,s2,s7
    80001ab4:	984e                	add	a6,a6,s3
    if (n > max)
    80001ab6:	0104f363          	bgeu	s1,a6,80001abc <copyinstr+0x6e>
    80001aba:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80001abc:	955e                	add	a0,a0,s7
    80001abe:	41250533          	sub	a0,a0,s2
    while (n > 0)
    80001ac2:	fc080be3          	beqz	a6,80001a98 <copyinstr+0x4a>
    80001ac6:	985a                	add	a6,a6,s6
    80001ac8:	87da                	mv	a5,s6
      if (*p == '\0')
    80001aca:	41650633          	sub	a2,a0,s6
    80001ace:	14fd                	addi	s1,s1,-1
    80001ad0:	9b26                	add	s6,s6,s1
    80001ad2:	00f60733          	add	a4,a2,a5
    80001ad6:	00074703          	lbu	a4,0(a4)
    80001ada:	df49                	beqz	a4,80001a74 <copyinstr+0x26>
        *dst = *p;
    80001adc:	00e78023          	sb	a4,0(a5)
      --max;
    80001ae0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001ae4:	0785                	addi	a5,a5,1
    while (n > 0)
    80001ae6:	ff0796e3          	bne	a5,a6,80001ad2 <copyinstr+0x84>
      dst++;
    80001aea:	8b42                	mv	s6,a6
    80001aec:	b775                	j	80001a98 <copyinstr+0x4a>
    80001aee:	4781                	li	a5,0
    80001af0:	b769                	j	80001a7a <copyinstr+0x2c>
      return -1;
    80001af2:	557d                	li	a0,-1
    80001af4:	b779                	j	80001a82 <copyinstr+0x34>
  int got_null = 0;
    80001af6:	4781                	li	a5,0
  if (got_null)
    80001af8:	0017b793          	seqz	a5,a5
    80001afc:	40f00533          	neg	a0,a5
}
    80001b00:	8082                	ret

0000000080001b02 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80001b02:	7139                	addi	sp,sp,-64
    80001b04:	fc06                	sd	ra,56(sp)
    80001b06:	f822                	sd	s0,48(sp)
    80001b08:	f426                	sd	s1,40(sp)
    80001b0a:	f04a                	sd	s2,32(sp)
    80001b0c:	ec4e                	sd	s3,24(sp)
    80001b0e:	e852                	sd	s4,16(sp)
    80001b10:	e456                	sd	s5,8(sp)
    80001b12:	e05a                	sd	s6,0(sp)
    80001b14:	0080                	addi	s0,sp,64
    80001b16:	89aa                	mv	s3,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001b18:	0022f497          	auipc	s1,0x22f
    80001b1c:	52048493          	addi	s1,s1,1312 # 80231038 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001b20:	8b26                	mv	s6,s1
    80001b22:	00006a97          	auipc	s5,0x6
    80001b26:	4dea8a93          	addi	s5,s5,1246 # 80008000 <etext>
    80001b2a:	04000937          	lui	s2,0x4000
    80001b2e:	197d                	addi	s2,s2,-1
    80001b30:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001b32:	00236a17          	auipc	s4,0x236
    80001b36:	906a0a13          	addi	s4,s4,-1786 # 80237438 <tickslock>
    char *pa = kalloc();
    80001b3a:	fffff097          	auipc	ra,0xfffff
    80001b3e:	178080e7          	jalr	376(ra) # 80000cb2 <kalloc>
    80001b42:	862a                	mv	a2,a0
    if (pa == 0)
    80001b44:	c131                	beqz	a0,80001b88 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int)(p - proc));
    80001b46:	416485b3          	sub	a1,s1,s6
    80001b4a:	8591                	srai	a1,a1,0x4
    80001b4c:	000ab783          	ld	a5,0(s5)
    80001b50:	02f585b3          	mul	a1,a1,a5
    80001b54:	2585                	addiw	a1,a1,1
    80001b56:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001b5a:	4719                	li	a4,6
    80001b5c:	6685                	lui	a3,0x1
    80001b5e:	40b905b3          	sub	a1,s2,a1
    80001b62:	854e                	mv	a0,s3
    80001b64:	fffff097          	auipc	ra,0xfffff
    80001b68:	7ba080e7          	jalr	1978(ra) # 8000131e <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b6c:	19048493          	addi	s1,s1,400
    80001b70:	fd4495e3          	bne	s1,s4,80001b3a <proc_mapstacks+0x38>
  }
}
    80001b74:	70e2                	ld	ra,56(sp)
    80001b76:	7442                	ld	s0,48(sp)
    80001b78:	74a2                	ld	s1,40(sp)
    80001b7a:	7902                	ld	s2,32(sp)
    80001b7c:	69e2                	ld	s3,24(sp)
    80001b7e:	6a42                	ld	s4,16(sp)
    80001b80:	6aa2                	ld	s5,8(sp)
    80001b82:	6b02                	ld	s6,0(sp)
    80001b84:	6121                	addi	sp,sp,64
    80001b86:	8082                	ret
      panic("kalloc");
    80001b88:	00006517          	auipc	a0,0x6
    80001b8c:	6a850513          	addi	a0,a0,1704 # 80008230 <digits+0x1f0>
    80001b90:	fffff097          	auipc	ra,0xfffff
    80001b94:	9ae080e7          	jalr	-1618(ra) # 8000053e <panic>

0000000080001b98 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80001b98:	7139                	addi	sp,sp,-64
    80001b9a:	fc06                	sd	ra,56(sp)
    80001b9c:	f822                	sd	s0,48(sp)
    80001b9e:	f426                	sd	s1,40(sp)
    80001ba0:	f04a                	sd	s2,32(sp)
    80001ba2:	ec4e                	sd	s3,24(sp)
    80001ba4:	e852                	sd	s4,16(sp)
    80001ba6:	e456                	sd	s5,8(sp)
    80001ba8:	e05a                	sd	s6,0(sp)
    80001baa:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001bac:	00006597          	auipc	a1,0x6
    80001bb0:	68c58593          	addi	a1,a1,1676 # 80008238 <digits+0x1f8>
    80001bb4:	0022f517          	auipc	a0,0x22f
    80001bb8:	05450513          	addi	a0,a0,84 # 80230c08 <pid_lock>
    80001bbc:	fffff097          	auipc	ra,0xfffff
    80001bc0:	16a080e7          	jalr	362(ra) # 80000d26 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001bc4:	00006597          	auipc	a1,0x6
    80001bc8:	67c58593          	addi	a1,a1,1660 # 80008240 <digits+0x200>
    80001bcc:	0022f517          	auipc	a0,0x22f
    80001bd0:	05450513          	addi	a0,a0,84 # 80230c20 <wait_lock>
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	152080e7          	jalr	338(ra) # 80000d26 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80001bdc:	0022f497          	auipc	s1,0x22f
    80001be0:	45c48493          	addi	s1,s1,1116 # 80231038 <proc>
  {
    initlock(&p->lock, "proc");
    80001be4:	00006b17          	auipc	s6,0x6
    80001be8:	66cb0b13          	addi	s6,s6,1644 # 80008250 <digits+0x210>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001bec:	8aa6                	mv	s5,s1
    80001bee:	00006a17          	auipc	s4,0x6
    80001bf2:	412a0a13          	addi	s4,s4,1042 # 80008000 <etext>
    80001bf6:	04000937          	lui	s2,0x4000
    80001bfa:	197d                	addi	s2,s2,-1
    80001bfc:	0932                	slli	s2,s2,0xc
  for (p = proc; p < &proc[NPROC]; p++)
    80001bfe:	00236997          	auipc	s3,0x236
    80001c02:	83a98993          	addi	s3,s3,-1990 # 80237438 <tickslock>
    initlock(&p->lock, "proc");
    80001c06:	85da                	mv	a1,s6
    80001c08:	8526                	mv	a0,s1
    80001c0a:	fffff097          	auipc	ra,0xfffff
    80001c0e:	11c080e7          	jalr	284(ra) # 80000d26 <initlock>
    p->state = UNUSED;
    80001c12:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001c16:	415487b3          	sub	a5,s1,s5
    80001c1a:	8791                	srai	a5,a5,0x4
    80001c1c:	000a3703          	ld	a4,0(s4)
    80001c20:	02e787b3          	mul	a5,a5,a4
    80001c24:	2785                	addiw	a5,a5,1
    80001c26:	00d7979b          	slliw	a5,a5,0xd
    80001c2a:	40f907b3          	sub	a5,s2,a5
    80001c2e:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80001c30:	19048493          	addi	s1,s1,400
    80001c34:	fd3499e3          	bne	s1,s3,80001c06 <procinit+0x6e>
  }
}
    80001c38:	70e2                	ld	ra,56(sp)
    80001c3a:	7442                	ld	s0,48(sp)
    80001c3c:	74a2                	ld	s1,40(sp)
    80001c3e:	7902                	ld	s2,32(sp)
    80001c40:	69e2                	ld	s3,24(sp)
    80001c42:	6a42                	ld	s4,16(sp)
    80001c44:	6aa2                	ld	s5,8(sp)
    80001c46:	6b02                	ld	s6,0(sp)
    80001c48:	6121                	addi	sp,sp,64
    80001c4a:	8082                	ret

0000000080001c4c <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80001c4c:	1141                	addi	sp,sp,-16
    80001c4e:	e422                	sd	s0,8(sp)
    80001c50:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c52:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001c54:	2501                	sext.w	a0,a0
    80001c56:	6422                	ld	s0,8(sp)
    80001c58:	0141                	addi	sp,sp,16
    80001c5a:	8082                	ret

0000000080001c5c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80001c5c:	1141                	addi	sp,sp,-16
    80001c5e:	e422                	sd	s0,8(sp)
    80001c60:	0800                	addi	s0,sp,16
    80001c62:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001c64:	2781                	sext.w	a5,a5
    80001c66:	079e                	slli	a5,a5,0x7
  return c;
}
    80001c68:	0022f517          	auipc	a0,0x22f
    80001c6c:	fd050513          	addi	a0,a0,-48 # 80230c38 <cpus>
    80001c70:	953e                	add	a0,a0,a5
    80001c72:	6422                	ld	s0,8(sp)
    80001c74:	0141                	addi	sp,sp,16
    80001c76:	8082                	ret

0000000080001c78 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80001c78:	1101                	addi	sp,sp,-32
    80001c7a:	ec06                	sd	ra,24(sp)
    80001c7c:	e822                	sd	s0,16(sp)
    80001c7e:	e426                	sd	s1,8(sp)
    80001c80:	1000                	addi	s0,sp,32
  push_off();
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	0e8080e7          	jalr	232(ra) # 80000d6a <push_off>
    80001c8a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c8c:	2781                	sext.w	a5,a5
    80001c8e:	079e                	slli	a5,a5,0x7
    80001c90:	0022f717          	auipc	a4,0x22f
    80001c94:	f7870713          	addi	a4,a4,-136 # 80230c08 <pid_lock>
    80001c98:	97ba                	add	a5,a5,a4
    80001c9a:	7b84                	ld	s1,48(a5)
  pop_off();
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	16e080e7          	jalr	366(ra) # 80000e0a <pop_off>
  return p;
}
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	60e2                	ld	ra,24(sp)
    80001ca8:	6442                	ld	s0,16(sp)
    80001caa:	64a2                	ld	s1,8(sp)
    80001cac:	6105                	addi	sp,sp,32
    80001cae:	8082                	ret

0000000080001cb0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001cb0:	1141                	addi	sp,sp,-16
    80001cb2:	e406                	sd	ra,8(sp)
    80001cb4:	e022                	sd	s0,0(sp)
    80001cb6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001cb8:	00000097          	auipc	ra,0x0
    80001cbc:	fc0080e7          	jalr	-64(ra) # 80001c78 <myproc>
    80001cc0:	fffff097          	auipc	ra,0xfffff
    80001cc4:	1aa080e7          	jalr	426(ra) # 80000e6a <release>

  if (first)
    80001cc8:	00007797          	auipc	a5,0x7
    80001ccc:	c387a783          	lw	a5,-968(a5) # 80008900 <first.1>
    80001cd0:	eb89                	bnez	a5,80001ce2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001cd2:	00001097          	auipc	ra,0x1
    80001cd6:	14c080e7          	jalr	332(ra) # 80002e1e <usertrapret>
}
    80001cda:	60a2                	ld	ra,8(sp)
    80001cdc:	6402                	ld	s0,0(sp)
    80001cde:	0141                	addi	sp,sp,16
    80001ce0:	8082                	ret
    first = 0;
    80001ce2:	00007797          	auipc	a5,0x7
    80001ce6:	c007af23          	sw	zero,-994(a5) # 80008900 <first.1>
    fsinit(ROOTDEV);
    80001cea:	4505                	li	a0,1
    80001cec:	00002097          	auipc	ra,0x2
    80001cf0:	00c080e7          	jalr	12(ra) # 80003cf8 <fsinit>
    80001cf4:	bff9                	j	80001cd2 <forkret+0x22>

0000000080001cf6 <allocpid>:
{
    80001cf6:	1101                	addi	sp,sp,-32
    80001cf8:	ec06                	sd	ra,24(sp)
    80001cfa:	e822                	sd	s0,16(sp)
    80001cfc:	e426                	sd	s1,8(sp)
    80001cfe:	e04a                	sd	s2,0(sp)
    80001d00:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001d02:	0022f917          	auipc	s2,0x22f
    80001d06:	f0690913          	addi	s2,s2,-250 # 80230c08 <pid_lock>
    80001d0a:	854a                	mv	a0,s2
    80001d0c:	fffff097          	auipc	ra,0xfffff
    80001d10:	0aa080e7          	jalr	170(ra) # 80000db6 <acquire>
  pid = nextpid;
    80001d14:	00007797          	auipc	a5,0x7
    80001d18:	bf078793          	addi	a5,a5,-1040 # 80008904 <nextpid>
    80001d1c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001d1e:	0014871b          	addiw	a4,s1,1
    80001d22:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001d24:	854a                	mv	a0,s2
    80001d26:	fffff097          	auipc	ra,0xfffff
    80001d2a:	144080e7          	jalr	324(ra) # 80000e6a <release>
}
    80001d2e:	8526                	mv	a0,s1
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	64a2                	ld	s1,8(sp)
    80001d36:	6902                	ld	s2,0(sp)
    80001d38:	6105                	addi	sp,sp,32
    80001d3a:	8082                	ret

0000000080001d3c <proc_pagetable>:
{
    80001d3c:	1101                	addi	sp,sp,-32
    80001d3e:	ec06                	sd	ra,24(sp)
    80001d40:	e822                	sd	s0,16(sp)
    80001d42:	e426                	sd	s1,8(sp)
    80001d44:	e04a                	sd	s2,0(sp)
    80001d46:	1000                	addi	s0,sp,32
    80001d48:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001d4a:	fffff097          	auipc	ra,0xfffff
    80001d4e:	7be080e7          	jalr	1982(ra) # 80001508 <uvmcreate>
    80001d52:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80001d54:	c121                	beqz	a0,80001d94 <proc_pagetable+0x58>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001d56:	4729                	li	a4,10
    80001d58:	00005697          	auipc	a3,0x5
    80001d5c:	2a868693          	addi	a3,a3,680 # 80007000 <_trampoline>
    80001d60:	6605                	lui	a2,0x1
    80001d62:	040005b7          	lui	a1,0x4000
    80001d66:	15fd                	addi	a1,a1,-1
    80001d68:	05b2                	slli	a1,a1,0xc
    80001d6a:	fffff097          	auipc	ra,0xfffff
    80001d6e:	514080e7          	jalr	1300(ra) # 8000127e <mappages>
    80001d72:	02054863          	bltz	a0,80001da2 <proc_pagetable+0x66>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d76:	4719                	li	a4,6
    80001d78:	05893683          	ld	a3,88(s2)
    80001d7c:	6605                	lui	a2,0x1
    80001d7e:	020005b7          	lui	a1,0x2000
    80001d82:	15fd                	addi	a1,a1,-1
    80001d84:	05b6                	slli	a1,a1,0xd
    80001d86:	8526                	mv	a0,s1
    80001d88:	fffff097          	auipc	ra,0xfffff
    80001d8c:	4f6080e7          	jalr	1270(ra) # 8000127e <mappages>
    80001d90:	02054163          	bltz	a0,80001db2 <proc_pagetable+0x76>
}
    80001d94:	8526                	mv	a0,s1
    80001d96:	60e2                	ld	ra,24(sp)
    80001d98:	6442                	ld	s0,16(sp)
    80001d9a:	64a2                	ld	s1,8(sp)
    80001d9c:	6902                	ld	s2,0(sp)
    80001d9e:	6105                	addi	sp,sp,32
    80001da0:	8082                	ret
    uvmfree(pagetable, 0);
    80001da2:	4581                	li	a1,0
    80001da4:	8526                	mv	a0,s1
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	966080e7          	jalr	-1690(ra) # 8000170c <uvmfree>
    return 0;
    80001dae:	4481                	li	s1,0
    80001db0:	b7d5                	j	80001d94 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001db2:	4681                	li	a3,0
    80001db4:	4605                	li	a2,1
    80001db6:	040005b7          	lui	a1,0x4000
    80001dba:	15fd                	addi	a1,a1,-1
    80001dbc:	05b2                	slli	a1,a1,0xc
    80001dbe:	8526                	mv	a0,s1
    80001dc0:	fffff097          	auipc	ra,0xfffff
    80001dc4:	684080e7          	jalr	1668(ra) # 80001444 <uvmunmap>
    uvmfree(pagetable, 0);
    80001dc8:	4581                	li	a1,0
    80001dca:	8526                	mv	a0,s1
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	940080e7          	jalr	-1728(ra) # 8000170c <uvmfree>
    return 0;
    80001dd4:	4481                	li	s1,0
    80001dd6:	bf7d                	j	80001d94 <proc_pagetable+0x58>

0000000080001dd8 <proc_freepagetable>:
{
    80001dd8:	1101                	addi	sp,sp,-32
    80001dda:	ec06                	sd	ra,24(sp)
    80001ddc:	e822                	sd	s0,16(sp)
    80001dde:	e426                	sd	s1,8(sp)
    80001de0:	e04a                	sd	s2,0(sp)
    80001de2:	1000                	addi	s0,sp,32
    80001de4:	84aa                	mv	s1,a0
    80001de6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001de8:	4681                	li	a3,0
    80001dea:	4605                	li	a2,1
    80001dec:	040005b7          	lui	a1,0x4000
    80001df0:	15fd                	addi	a1,a1,-1
    80001df2:	05b2                	slli	a1,a1,0xc
    80001df4:	fffff097          	auipc	ra,0xfffff
    80001df8:	650080e7          	jalr	1616(ra) # 80001444 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001dfc:	4681                	li	a3,0
    80001dfe:	4605                	li	a2,1
    80001e00:	020005b7          	lui	a1,0x2000
    80001e04:	15fd                	addi	a1,a1,-1
    80001e06:	05b6                	slli	a1,a1,0xd
    80001e08:	8526                	mv	a0,s1
    80001e0a:	fffff097          	auipc	ra,0xfffff
    80001e0e:	63a080e7          	jalr	1594(ra) # 80001444 <uvmunmap>
  uvmfree(pagetable, sz);
    80001e12:	85ca                	mv	a1,s2
    80001e14:	8526                	mv	a0,s1
    80001e16:	00000097          	auipc	ra,0x0
    80001e1a:	8f6080e7          	jalr	-1802(ra) # 8000170c <uvmfree>
}
    80001e1e:	60e2                	ld	ra,24(sp)
    80001e20:	6442                	ld	s0,16(sp)
    80001e22:	64a2                	ld	s1,8(sp)
    80001e24:	6902                	ld	s2,0(sp)
    80001e26:	6105                	addi	sp,sp,32
    80001e28:	8082                	ret

0000000080001e2a <freeproc>:
{
    80001e2a:	1101                	addi	sp,sp,-32
    80001e2c:	ec06                	sd	ra,24(sp)
    80001e2e:	e822                	sd	s0,16(sp)
    80001e30:	e426                	sd	s1,8(sp)
    80001e32:	1000                	addi	s0,sp,32
    80001e34:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001e36:	6d28                	ld	a0,88(a0)
    80001e38:	c509                	beqz	a0,80001e42 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	cbe080e7          	jalr	-834(ra) # 80000af8 <kfree>
  p->trapframe = 0;
    80001e42:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001e46:	68a8                	ld	a0,80(s1)
    80001e48:	c511                	beqz	a0,80001e54 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001e4a:	64ac                	ld	a1,72(s1)
    80001e4c:	00000097          	auipc	ra,0x0
    80001e50:	f8c080e7          	jalr	-116(ra) # 80001dd8 <proc_freepagetable>
  p->pagetable = 0;
    80001e54:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001e58:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001e5c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001e60:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001e64:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001e68:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001e6c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001e70:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001e74:	0004ac23          	sw	zero,24(s1)
}
    80001e78:	60e2                	ld	ra,24(sp)
    80001e7a:	6442                	ld	s0,16(sp)
    80001e7c:	64a2                	ld	s1,8(sp)
    80001e7e:	6105                	addi	sp,sp,32
    80001e80:	8082                	ret

0000000080001e82 <allocproc>:
{
    80001e82:	1101                	addi	sp,sp,-32
    80001e84:	ec06                	sd	ra,24(sp)
    80001e86:	e822                	sd	s0,16(sp)
    80001e88:	e426                	sd	s1,8(sp)
    80001e8a:	e04a                	sd	s2,0(sp)
    80001e8c:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    80001e8e:	0022f497          	auipc	s1,0x22f
    80001e92:	1aa48493          	addi	s1,s1,426 # 80231038 <proc>
    80001e96:	00235917          	auipc	s2,0x235
    80001e9a:	5a290913          	addi	s2,s2,1442 # 80237438 <tickslock>
    acquire(&p->lock);
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	f16080e7          	jalr	-234(ra) # 80000db6 <acquire>
    if (p->state == UNUSED)
    80001ea8:	4c9c                	lw	a5,24(s1)
    80001eaa:	cf81                	beqz	a5,80001ec2 <allocproc+0x40>
      release(&p->lock);
    80001eac:	8526                	mv	a0,s1
    80001eae:	fffff097          	auipc	ra,0xfffff
    80001eb2:	fbc080e7          	jalr	-68(ra) # 80000e6a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001eb6:	19048493          	addi	s1,s1,400
    80001eba:	ff2492e3          	bne	s1,s2,80001e9e <allocproc+0x1c>
  return 0;
    80001ebe:	4481                	li	s1,0
    80001ec0:	a059                	j	80001f46 <allocproc+0xc4>
  p->pid = allocpid();
    80001ec2:	00000097          	auipc	ra,0x0
    80001ec6:	e34080e7          	jalr	-460(ra) # 80001cf6 <allocpid>
    80001eca:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001ecc:	4785                	li	a5,1
    80001ece:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001ed0:	fffff097          	auipc	ra,0xfffff
    80001ed4:	de2080e7          	jalr	-542(ra) # 80000cb2 <kalloc>
    80001ed8:	892a                	mv	s2,a0
    80001eda:	eca8                	sd	a0,88(s1)
    80001edc:	cd25                	beqz	a0,80001f54 <allocproc+0xd2>
  p->pagetable = proc_pagetable(p);
    80001ede:	8526                	mv	a0,s1
    80001ee0:	00000097          	auipc	ra,0x0
    80001ee4:	e5c080e7          	jalr	-420(ra) # 80001d3c <proc_pagetable>
    80001ee8:	892a                	mv	s2,a0
    80001eea:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001eec:	c141                	beqz	a0,80001f6c <allocproc+0xea>
  memset(&p->context, 0, sizeof(p->context));
    80001eee:	07000613          	li	a2,112
    80001ef2:	4581                	li	a1,0
    80001ef4:	06048513          	addi	a0,s1,96
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	fba080e7          	jalr	-70(ra) # 80000eb2 <memset>
  p->context.ra = (uint64)forkret;
    80001f00:	00000797          	auipc	a5,0x0
    80001f04:	db078793          	addi	a5,a5,-592 # 80001cb0 <forkret>
    80001f08:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001f0a:	60bc                	ld	a5,64(s1)
    80001f0c:	6705                	lui	a4,0x1
    80001f0e:	97ba                	add	a5,a5,a4
    80001f10:	f4bc                	sd	a5,104(s1)
  p->rtime = 0;
    80001f12:	1604a423          	sw	zero,360(s1)
  p->etime = 0;
    80001f16:	1604a823          	sw	zero,368(s1)
  p->dynamicrtime = 0;
    80001f1a:	1604aa23          	sw	zero,372(s1)
  p->wtime = 0;
    80001f1e:	1604ac23          	sw	zero,376(s1)
  p->dynamicstime = 0;
    80001f22:	1604ae23          	sw	zero,380(s1)
  p->ctime = ticks;
    80001f26:	00007797          	auipc	a5,0x7
    80001f2a:	a5a7a783          	lw	a5,-1446(a5) # 80008980 <ticks>
    80001f2e:	16f4a623          	sw	a5,364(s1)
  p->staticpriority = 50;
    80001f32:	03200793          	li	a5,50
    80001f36:	18f4a023          	sw	a5,384(s1)
  p->defaultflag = 0;
    80001f3a:	1804a423          	sw	zero,392(s1)
  p->defaultflag2 = 0;
    80001f3e:	1804a623          	sw	zero,396(s1)
  p->numberoftimescheduled = 0;
    80001f42:	1804a223          	sw	zero,388(s1)
}
    80001f46:	8526                	mv	a0,s1
    80001f48:	60e2                	ld	ra,24(sp)
    80001f4a:	6442                	ld	s0,16(sp)
    80001f4c:	64a2                	ld	s1,8(sp)
    80001f4e:	6902                	ld	s2,0(sp)
    80001f50:	6105                	addi	sp,sp,32
    80001f52:	8082                	ret
    freeproc(p);
    80001f54:	8526                	mv	a0,s1
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	ed4080e7          	jalr	-300(ra) # 80001e2a <freeproc>
    release(&p->lock);
    80001f5e:	8526                	mv	a0,s1
    80001f60:	fffff097          	auipc	ra,0xfffff
    80001f64:	f0a080e7          	jalr	-246(ra) # 80000e6a <release>
    return 0;
    80001f68:	84ca                	mv	s1,s2
    80001f6a:	bff1                	j	80001f46 <allocproc+0xc4>
    freeproc(p);
    80001f6c:	8526                	mv	a0,s1
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	ebc080e7          	jalr	-324(ra) # 80001e2a <freeproc>
    release(&p->lock);
    80001f76:	8526                	mv	a0,s1
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	ef2080e7          	jalr	-270(ra) # 80000e6a <release>
    return 0;
    80001f80:	84ca                	mv	s1,s2
    80001f82:	b7d1                	j	80001f46 <allocproc+0xc4>

0000000080001f84 <userinit>:
{
    80001f84:	1101                	addi	sp,sp,-32
    80001f86:	ec06                	sd	ra,24(sp)
    80001f88:	e822                	sd	s0,16(sp)
    80001f8a:	e426                	sd	s1,8(sp)
    80001f8c:	1000                	addi	s0,sp,32
  p = allocproc();
    80001f8e:	00000097          	auipc	ra,0x0
    80001f92:	ef4080e7          	jalr	-268(ra) # 80001e82 <allocproc>
    80001f96:	84aa                	mv	s1,a0
  initproc = p;
    80001f98:	00007797          	auipc	a5,0x7
    80001f9c:	9ea7b023          	sd	a0,-1568(a5) # 80008978 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001fa0:	03400613          	li	a2,52
    80001fa4:	00007597          	auipc	a1,0x7
    80001fa8:	96c58593          	addi	a1,a1,-1684 # 80008910 <initcode>
    80001fac:	6928                	ld	a0,80(a0)
    80001fae:	fffff097          	auipc	ra,0xfffff
    80001fb2:	588080e7          	jalr	1416(ra) # 80001536 <uvmfirst>
  p->sz = PGSIZE;
    80001fb6:	6785                	lui	a5,0x1
    80001fb8:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    80001fba:	6cb8                	ld	a4,88(s1)
    80001fbc:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001fc0:	6cb8                	ld	a4,88(s1)
    80001fc2:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001fc4:	4641                	li	a2,16
    80001fc6:	00006597          	auipc	a1,0x6
    80001fca:	29258593          	addi	a1,a1,658 # 80008258 <digits+0x218>
    80001fce:	15848513          	addi	a0,s1,344
    80001fd2:	fffff097          	auipc	ra,0xfffff
    80001fd6:	02a080e7          	jalr	42(ra) # 80000ffc <safestrcpy>
  p->cwd = namei("/");
    80001fda:	00006517          	auipc	a0,0x6
    80001fde:	28e50513          	addi	a0,a0,654 # 80008268 <digits+0x228>
    80001fe2:	00002097          	auipc	ra,0x2
    80001fe6:	738080e7          	jalr	1848(ra) # 8000471a <namei>
    80001fea:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001fee:	478d                	li	a5,3
    80001ff0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001ff2:	8526                	mv	a0,s1
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	e76080e7          	jalr	-394(ra) # 80000e6a <release>
}
    80001ffc:	60e2                	ld	ra,24(sp)
    80001ffe:	6442                	ld	s0,16(sp)
    80002000:	64a2                	ld	s1,8(sp)
    80002002:	6105                	addi	sp,sp,32
    80002004:	8082                	ret

0000000080002006 <growproc>:
{
    80002006:	1101                	addi	sp,sp,-32
    80002008:	ec06                	sd	ra,24(sp)
    8000200a:	e822                	sd	s0,16(sp)
    8000200c:	e426                	sd	s1,8(sp)
    8000200e:	e04a                	sd	s2,0(sp)
    80002010:	1000                	addi	s0,sp,32
    80002012:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80002014:	00000097          	auipc	ra,0x0
    80002018:	c64080e7          	jalr	-924(ra) # 80001c78 <myproc>
    8000201c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000201e:	652c                	ld	a1,72(a0)
  if (n > 0)
    80002020:	01204c63          	bgtz	s2,80002038 <growproc+0x32>
  else if (n < 0)
    80002024:	02094663          	bltz	s2,80002050 <growproc+0x4a>
  p->sz = sz;
    80002028:	e4ac                	sd	a1,72(s1)
  return 0;
    8000202a:	4501                	li	a0,0
}
    8000202c:	60e2                	ld	ra,24(sp)
    8000202e:	6442                	ld	s0,16(sp)
    80002030:	64a2                	ld	s1,8(sp)
    80002032:	6902                	ld	s2,0(sp)
    80002034:	6105                	addi	sp,sp,32
    80002036:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002038:	4691                	li	a3,4
    8000203a:	00b90633          	add	a2,s2,a1
    8000203e:	6928                	ld	a0,80(a0)
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	5b0080e7          	jalr	1456(ra) # 800015f0 <uvmalloc>
    80002048:	85aa                	mv	a1,a0
    8000204a:	fd79                	bnez	a0,80002028 <growproc+0x22>
      return -1;
    8000204c:	557d                	li	a0,-1
    8000204e:	bff9                	j	8000202c <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002050:	00b90633          	add	a2,s2,a1
    80002054:	6928                	ld	a0,80(a0)
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	552080e7          	jalr	1362(ra) # 800015a8 <uvmdealloc>
    8000205e:	85aa                	mv	a1,a0
    80002060:	b7e1                	j	80002028 <growproc+0x22>

0000000080002062 <fork>:
{
    80002062:	7139                	addi	sp,sp,-64
    80002064:	fc06                	sd	ra,56(sp)
    80002066:	f822                	sd	s0,48(sp)
    80002068:	f426                	sd	s1,40(sp)
    8000206a:	f04a                	sd	s2,32(sp)
    8000206c:	ec4e                	sd	s3,24(sp)
    8000206e:	e852                	sd	s4,16(sp)
    80002070:	e456                	sd	s5,8(sp)
    80002072:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002074:	00000097          	auipc	ra,0x0
    80002078:	c04080e7          	jalr	-1020(ra) # 80001c78 <myproc>
    8000207c:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    8000207e:	00000097          	auipc	ra,0x0
    80002082:	e04080e7          	jalr	-508(ra) # 80001e82 <allocproc>
    80002086:	10050c63          	beqz	a0,8000219e <fork+0x13c>
    8000208a:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000208c:	048ab603          	ld	a2,72(s5)
    80002090:	692c                	ld	a1,80(a0)
    80002092:	050ab503          	ld	a0,80(s5)
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	6ae080e7          	jalr	1710(ra) # 80001744 <uvmcopy>
    8000209e:	04054863          	bltz	a0,800020ee <fork+0x8c>
  np->sz = p->sz;
    800020a2:	048ab783          	ld	a5,72(s5)
    800020a6:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800020aa:	058ab683          	ld	a3,88(s5)
    800020ae:	87b6                	mv	a5,a3
    800020b0:	058a3703          	ld	a4,88(s4)
    800020b4:	12068693          	addi	a3,a3,288
    800020b8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800020bc:	6788                	ld	a0,8(a5)
    800020be:	6b8c                	ld	a1,16(a5)
    800020c0:	6f90                	ld	a2,24(a5)
    800020c2:	01073023          	sd	a6,0(a4)
    800020c6:	e708                	sd	a0,8(a4)
    800020c8:	eb0c                	sd	a1,16(a4)
    800020ca:	ef10                	sd	a2,24(a4)
    800020cc:	02078793          	addi	a5,a5,32
    800020d0:	02070713          	addi	a4,a4,32
    800020d4:	fed792e3          	bne	a5,a3,800020b8 <fork+0x56>
  np->trapframe->a0 = 0;
    800020d8:	058a3783          	ld	a5,88(s4)
    800020dc:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800020e0:	0d0a8493          	addi	s1,s5,208
    800020e4:	0d0a0913          	addi	s2,s4,208
    800020e8:	150a8993          	addi	s3,s5,336
    800020ec:	a00d                	j	8000210e <fork+0xac>
    freeproc(np);
    800020ee:	8552                	mv	a0,s4
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	d3a080e7          	jalr	-710(ra) # 80001e2a <freeproc>
    release(&np->lock);
    800020f8:	8552                	mv	a0,s4
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	d70080e7          	jalr	-656(ra) # 80000e6a <release>
    return -1;
    80002102:	597d                	li	s2,-1
    80002104:	a059                	j	8000218a <fork+0x128>
  for (i = 0; i < NOFILE; i++)
    80002106:	04a1                	addi	s1,s1,8
    80002108:	0921                	addi	s2,s2,8
    8000210a:	01348b63          	beq	s1,s3,80002120 <fork+0xbe>
    if (p->ofile[i])
    8000210e:	6088                	ld	a0,0(s1)
    80002110:	d97d                	beqz	a0,80002106 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    80002112:	00003097          	auipc	ra,0x3
    80002116:	c9e080e7          	jalr	-866(ra) # 80004db0 <filedup>
    8000211a:	00a93023          	sd	a0,0(s2)
    8000211e:	b7e5                	j	80002106 <fork+0xa4>
  np->cwd = idup(p->cwd);
    80002120:	150ab503          	ld	a0,336(s5)
    80002124:	00002097          	auipc	ra,0x2
    80002128:	e12080e7          	jalr	-494(ra) # 80003f36 <idup>
    8000212c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002130:	4641                	li	a2,16
    80002132:	158a8593          	addi	a1,s5,344
    80002136:	158a0513          	addi	a0,s4,344
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	ec2080e7          	jalr	-318(ra) # 80000ffc <safestrcpy>
  pid = np->pid;
    80002142:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002146:	8552                	mv	a0,s4
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	d22080e7          	jalr	-734(ra) # 80000e6a <release>
  acquire(&wait_lock);
    80002150:	0022f497          	auipc	s1,0x22f
    80002154:	ad048493          	addi	s1,s1,-1328 # 80230c20 <wait_lock>
    80002158:	8526                	mv	a0,s1
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	c5c080e7          	jalr	-932(ra) # 80000db6 <acquire>
  np->parent = p;
    80002162:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80002166:	8526                	mv	a0,s1
    80002168:	fffff097          	auipc	ra,0xfffff
    8000216c:	d02080e7          	jalr	-766(ra) # 80000e6a <release>
  acquire(&np->lock);
    80002170:	8552                	mv	a0,s4
    80002172:	fffff097          	auipc	ra,0xfffff
    80002176:	c44080e7          	jalr	-956(ra) # 80000db6 <acquire>
  np->state = RUNNABLE;
    8000217a:	478d                	li	a5,3
    8000217c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002180:	8552                	mv	a0,s4
    80002182:	fffff097          	auipc	ra,0xfffff
    80002186:	ce8080e7          	jalr	-792(ra) # 80000e6a <release>
}
    8000218a:	854a                	mv	a0,s2
    8000218c:	70e2                	ld	ra,56(sp)
    8000218e:	7442                	ld	s0,48(sp)
    80002190:	74a2                	ld	s1,40(sp)
    80002192:	7902                	ld	s2,32(sp)
    80002194:	69e2                	ld	s3,24(sp)
    80002196:	6a42                	ld	s4,16(sp)
    80002198:	6aa2                	ld	s5,8(sp)
    8000219a:	6121                	addi	sp,sp,64
    8000219c:	8082                	ret
    return -1;
    8000219e:	597d                	li	s2,-1
    800021a0:	b7ed                	j	8000218a <fork+0x128>

00000000800021a2 <scheduler>:
{
    800021a2:	7175                	addi	sp,sp,-144
    800021a4:	e506                	sd	ra,136(sp)
    800021a6:	e122                	sd	s0,128(sp)
    800021a8:	fca6                	sd	s1,120(sp)
    800021aa:	f8ca                	sd	s2,112(sp)
    800021ac:	f4ce                	sd	s3,104(sp)
    800021ae:	f0d2                	sd	s4,96(sp)
    800021b0:	ecd6                	sd	s5,88(sp)
    800021b2:	e8da                	sd	s6,80(sp)
    800021b4:	e4de                	sd	s7,72(sp)
    800021b6:	e0e2                	sd	s8,64(sp)
    800021b8:	fc66                	sd	s9,56(sp)
    800021ba:	f86a                	sd	s10,48(sp)
    800021bc:	f46e                	sd	s11,40(sp)
    800021be:	0900                	addi	s0,sp,144
    800021c0:	8792                	mv	a5,tp
  int id = r_tp();
    800021c2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800021c4:	00779693          	slli	a3,a5,0x7
    800021c8:	0022f717          	auipc	a4,0x22f
    800021cc:	a4070713          	addi	a4,a4,-1472 # 80230c08 <pid_lock>
    800021d0:	9736                	add	a4,a4,a3
    800021d2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800021d6:	0022f717          	auipc	a4,0x22f
    800021da:	a6a70713          	addi	a4,a4,-1430 # 80230c40 <cpus+0x8>
    800021de:	9736                	add	a4,a4,a3
    800021e0:	f6e43c23          	sd	a4,-136(s0)
    int mn = 1e8;
    800021e4:	05f5e737          	lui	a4,0x5f5e
    800021e8:	10070713          	addi	a4,a4,256 # 5f5e100 <_entry-0x7a0a1f00>
    800021ec:	f8e43423          	sd	a4,-120(s0)
        c->proc = p;
    800021f0:	0022f717          	auipc	a4,0x22f
    800021f4:	a1870713          	addi	a4,a4,-1512 # 80230c08 <pid_lock>
    800021f8:	00d707b3          	add	a5,a4,a3
    800021fc:	f6f43823          	sd	a5,-144(s0)
    80002200:	a451                	j	80002484 <scheduler+0x2e2>
      if (DP == mn)
    80002202:	01279563          	bne	a5,s2,8000220c <scheduler+0x6a>
    80002206:	87ca                	mv	a5,s2
        counter++;
    80002208:	2b85                	addiw	s7,s7,1
    8000220a:	893e                	mv	s2,a5
      release(&p->lock);
    8000220c:	8526                	mv	a0,s1
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	c5c080e7          	jalr	-932(ra) # 80000e6a <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002216:	19048493          	addi	s1,s1,400
    8000221a:	07348763          	beq	s1,s3,80002288 <scheduler+0xe6>
      acquire(&p->lock);
    8000221e:	8526                	mv	a0,s1
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	b96080e7          	jalr	-1130(ra) # 80000db6 <acquire>
      int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    80002228:	1744a703          	lw	a4,372(s1)
    8000222c:	17c4a603          	lw	a2,380(s1)
    80002230:	1784a683          	lw	a3,376(s1)
      if (p->defaultflag == 1)
    80002234:	1884a583          	lw	a1,392(s1)
        RBI = 25;
    80002238:	87d6                	mv	a5,s5
      if (p->defaultflag == 1)
    8000223a:	03458563          	beq	a1,s4,80002264 <scheduler+0xc2>
      int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    8000223e:	0017179b          	slliw	a5,a4,0x1
    80002242:	9fb9                	addw	a5,a5,a4
    80002244:	9f91                	subw	a5,a5,a2
    80002246:	9f95                	subw	a5,a5,a3
    80002248:	038787bb          	mulw	a5,a5,s8
      RBI /= (p->dynamicrtime + p->dynamicstime + p->wtime + 1);
    8000224c:	9f31                	addw	a4,a4,a2
    8000224e:	9f35                	addw	a4,a4,a3
    80002250:	2705                	addiw	a4,a4,1
    80002252:	02e7c7bb          	divw	a5,a5,a4
    80002256:	0007871b          	sext.w	a4,a5
    8000225a:	fff74713          	not	a4,a4
    8000225e:	977d                	srai	a4,a4,0x3f
    80002260:	8ff9                	and	a5,a5,a4
    80002262:	2781                	sext.w	a5,a5
      int DP = p->staticpriority + RBI;
    80002264:	1804a703          	lw	a4,384(s1)
    80002268:	9fb9                	addw	a5,a5,a4
      if (DP > 100)
    8000226a:	873e                	mv	a4,a5
    8000226c:	2781                	sext.w	a5,a5
    8000226e:	00fb5363          	bge	s6,a5,80002274 <scheduler+0xd2>
    80002272:	876e                	mv	a4,s11
    80002274:	0007079b          	sext.w	a5,a4
      if (DP < mn && p->state == RUNNABLE)
    80002278:	f927d5e3          	bge	a5,s2,80002202 <scheduler+0x60>
    8000227c:	4c98                	lw	a4,24(s1)
    8000227e:	f99717e3          	bne	a4,s9,8000220c <scheduler+0x6a>
    80002282:	8d26                	mv	s10,s1
        counter = 0;
    80002284:	4b81                	li	s7,0
    80002286:	b749                	j	80002208 <scheduler+0x66>
    if (counter > 1)
    80002288:	037a4863          	blt	s4,s7,800022b8 <scheduler+0x116>
    if (p != 0)
    8000228c:	1a0d1063          	bnez	s10,8000242c <scheduler+0x28a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002290:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002294:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002298:	10079073          	csrw	sstatus,a5
    int counter = 0;
    8000229c:	4b81                	li	s7,0
    int mn = 1e8;
    8000229e:	f8843903          	ld	s2,-120(s0)
    struct proc *temp = 0;
    800022a2:	4d01                	li	s10,0
    for (p = proc; p < &proc[NPROC]; p++)
    800022a4:	0022f497          	auipc	s1,0x22f
    800022a8:	d9448493          	addi	s1,s1,-620 # 80231038 <proc>
    800022ac:	06400b13          	li	s6,100
    800022b0:	06400d93          	li	s11,100
      if (DP < mn && p->state == RUNNABLE)
    800022b4:	4c8d                	li	s9,3
    800022b6:	b7a5                	j	8000221e <scheduler+0x7c>
      int mn2 = 1e8;
    800022b8:	f8843c83          	ld	s9,-120(s0)
      int counter2 = 0;
    800022bc:	4d81                	li	s11,0
      for (p = proc; p < &proc[NPROC]; p++)
    800022be:	0022f497          	auipc	s1,0x22f
    800022c2:	d7a48493          	addi	s1,s1,-646 # 80231038 <proc>
        if (p->state != RUNNABLE)
    800022c6:	4b0d                	li	s6,3
        if (DP == mn)
    800022c8:	06400b93          	li	s7,100
    800022cc:	a01d                	j	800022f2 <scheduler+0x150>
          release(&p->lock);
    800022ce:	8526                	mv	a0,s1
    800022d0:	fffff097          	auipc	ra,0xfffff
    800022d4:	b9a080e7          	jalr	-1126(ra) # 80000e6a <release>
          continue;
    800022d8:	a809                	j	800022ea <scheduler+0x148>
        if (DP == mn)
    800022da:	2701                	sext.w	a4,a4
    800022dc:	07270b63          	beq	a4,s2,80002352 <scheduler+0x1b0>
        release(&p->lock);
    800022e0:	8526                	mv	a0,s1
    800022e2:	fffff097          	auipc	ra,0xfffff
    800022e6:	b88080e7          	jalr	-1144(ra) # 80000e6a <release>
      for (p = proc; p < &proc[NPROC]; p++)
    800022ea:	19048493          	addi	s1,s1,400
    800022ee:	07348f63          	beq	s1,s3,8000236c <scheduler+0x1ca>
        acquire(&p->lock);
    800022f2:	8526                	mv	a0,s1
    800022f4:	fffff097          	auipc	ra,0xfffff
    800022f8:	ac2080e7          	jalr	-1342(ra) # 80000db6 <acquire>
        if (p->state != RUNNABLE)
    800022fc:	4c9c                	lw	a5,24(s1)
    800022fe:	fd6798e3          	bne	a5,s6,800022ce <scheduler+0x12c>
        int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    80002302:	1744a703          	lw	a4,372(s1)
    80002306:	17c4a603          	lw	a2,380(s1)
    8000230a:	1784a683          	lw	a3,376(s1)
        if (p->defaultflag == 1)
    8000230e:	1884a583          	lw	a1,392(s1)
          RBI = 25;
    80002312:	87d6                	mv	a5,s5
        if (p->defaultflag == 1)
    80002314:	03458563          	beq	a1,s4,8000233e <scheduler+0x19c>
        int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    80002318:	0017179b          	slliw	a5,a4,0x1
    8000231c:	9fb9                	addw	a5,a5,a4
    8000231e:	9f91                	subw	a5,a5,a2
    80002320:	9f95                	subw	a5,a5,a3
    80002322:	038787bb          	mulw	a5,a5,s8
        RBI /= (p->dynamicrtime + p->dynamicstime + p->wtime + 1);
    80002326:	9f31                	addw	a4,a4,a2
    80002328:	9f35                	addw	a4,a4,a3
    8000232a:	2705                	addiw	a4,a4,1
    8000232c:	02e7c7bb          	divw	a5,a5,a4
    80002330:	0007871b          	sext.w	a4,a5
    80002334:	fff74713          	not	a4,a4
    80002338:	977d                	srai	a4,a4,0x3f
    8000233a:	8ff9                	and	a5,a5,a4
    8000233c:	2781                	sext.w	a5,a5
        int DP = p->staticpriority + RBI;
    8000233e:	1804a703          	lw	a4,384(s1)
    80002342:	9fb9                	addw	a5,a5,a4
        if (DP == mn)
    80002344:	873e                	mv	a4,a5
    80002346:	2781                	sext.w	a5,a5
    80002348:	f8fbd9e3          	bge	s7,a5,800022da <scheduler+0x138>
    8000234c:	06400713          	li	a4,100
    80002350:	b769                	j	800022da <scheduler+0x138>
          if (p->numberoftimescheduled < mn2)
    80002352:	1844a783          	lw	a5,388(s1)
    80002356:	0197c663          	blt	a5,s9,80002362 <scheduler+0x1c0>
          if (p->numberoftimescheduled == mn2)
    8000235a:	f99793e3          	bne	a5,s9,800022e0 <scheduler+0x13e>
    8000235e:	87e6                	mv	a5,s9
    80002360:	a019                	j	80002366 <scheduler+0x1c4>
    80002362:	8d26                	mv	s10,s1
            counter2 = 0;
    80002364:	4d81                	li	s11,0
            counter2++;
    80002366:	2d85                	addiw	s11,s11,1
    80002368:	8cbe                	mv	s9,a5
    8000236a:	bf9d                	j	800022e0 <scheduler+0x13e>
      if (counter2 > 1)
    8000236c:	f3ba50e3          	bge	s4,s11,8000228c <scheduler+0xea>
        int mn3 = 1e8;
    80002370:	f8843783          	ld	a5,-120(s0)
    80002374:	f8f43023          	sd	a5,-128(s0)
        for (p = proc; p < &proc[NPROC]; p++)
    80002378:	0022f497          	auipc	s1,0x22f
    8000237c:	cc048493          	addi	s1,s1,-832 # 80231038 <proc>
          if (p->state != RUNNABLE)
    80002380:	4b0d                	li	s6,3
          if (DP == mn && p->numberoftimescheduled == mn2)
    80002382:	06400b93          	li	s7,100
    80002386:	06400d93          	li	s11,100
    8000238a:	a01d                	j	800023b0 <scheduler+0x20e>
            release(&p->lock);
    8000238c:	8526                	mv	a0,s1
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	adc080e7          	jalr	-1316(ra) # 80000e6a <release>
            continue;
    80002396:	a809                	j	800023a8 <scheduler+0x206>
          if (DP == mn && p->numberoftimescheduled == mn2)
    80002398:	2701                	sext.w	a4,a4
    8000239a:	07270a63          	beq	a4,s2,8000240e <scheduler+0x26c>
          release(&p->lock);
    8000239e:	8526                	mv	a0,s1
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	aca080e7          	jalr	-1334(ra) # 80000e6a <release>
        for (p = proc; p < &proc[NPROC]; p++)
    800023a8:	19048493          	addi	s1,s1,400
    800023ac:	ef3480e3          	beq	s1,s3,8000228c <scheduler+0xea>
          acquire(&p->lock);
    800023b0:	8526                	mv	a0,s1
    800023b2:	fffff097          	auipc	ra,0xfffff
    800023b6:	a04080e7          	jalr	-1532(ra) # 80000db6 <acquire>
          if (p->state != RUNNABLE)
    800023ba:	4c9c                	lw	a5,24(s1)
    800023bc:	fd6798e3          	bne	a5,s6,8000238c <scheduler+0x1ea>
          int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    800023c0:	1744a703          	lw	a4,372(s1)
    800023c4:	17c4a603          	lw	a2,380(s1)
    800023c8:	1784a683          	lw	a3,376(s1)
          if (p->defaultflag == 1)
    800023cc:	1884a583          	lw	a1,392(s1)
            RBI = 25;
    800023d0:	87d6                	mv	a5,s5
          if (p->defaultflag == 1)
    800023d2:	03458563          	beq	a1,s4,800023fc <scheduler+0x25a>
          int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    800023d6:	0017179b          	slliw	a5,a4,0x1
    800023da:	9fb9                	addw	a5,a5,a4
    800023dc:	9f91                	subw	a5,a5,a2
    800023de:	9f95                	subw	a5,a5,a3
    800023e0:	038787bb          	mulw	a5,a5,s8
          RBI /= (p->dynamicrtime + p->dynamicstime + p->wtime + 1);
    800023e4:	9f31                	addw	a4,a4,a2
    800023e6:	9f35                	addw	a4,a4,a3
    800023e8:	2705                	addiw	a4,a4,1
    800023ea:	02e7c7bb          	divw	a5,a5,a4
    800023ee:	0007871b          	sext.w	a4,a5
    800023f2:	fff74713          	not	a4,a4
    800023f6:	977d                	srai	a4,a4,0x3f
    800023f8:	8ff9                	and	a5,a5,a4
    800023fa:	2781                	sext.w	a5,a5
          int DP = p->staticpriority + RBI;
    800023fc:	1804a703          	lw	a4,384(s1)
    80002400:	9fb9                	addw	a5,a5,a4
          if (DP == mn && p->numberoftimescheduled == mn2)
    80002402:	873e                	mv	a4,a5
    80002404:	2781                	sext.w	a5,a5
    80002406:	f8fbd9e3          	bge	s7,a5,80002398 <scheduler+0x1f6>
    8000240a:	876e                	mv	a4,s11
    8000240c:	b771                	j	80002398 <scheduler+0x1f6>
    8000240e:	1844a783          	lw	a5,388(s1)
    80002412:	f99796e3          	bne	a5,s9,8000239e <scheduler+0x1fc>
            if (mn3 > p->ctime)
    80002416:	16c4a783          	lw	a5,364(s1)
    8000241a:	f8042703          	lw	a4,-128(s0)
    8000241e:	f8e7f0e3          	bgeu	a5,a4,8000239e <scheduler+0x1fc>
              mn3 = p->ctime;
    80002422:	2781                	sext.w	a5,a5
    80002424:	f8f43023          	sd	a5,-128(s0)
    80002428:	8d26                	mv	s10,s1
    8000242a:	bf95                	j	8000239e <scheduler+0x1fc>
      acquire(&p->lock);
    8000242c:	84ea                	mv	s1,s10
    8000242e:	856a                	mv	a0,s10
    80002430:	fffff097          	auipc	ra,0xfffff
    80002434:	986080e7          	jalr	-1658(ra) # 80000db6 <acquire>
      if (p->state == RUNNABLE)
    80002438:	018d2703          	lw	a4,24(s10)
    8000243c:	478d                	li	a5,3
    8000243e:	02f71e63          	bne	a4,a5,8000247a <scheduler+0x2d8>
        p->state = RUNNING;
    80002442:	4791                	li	a5,4
    80002444:	00fd2c23          	sw	a5,24(s10)
        p->defaultflag = 0;
    80002448:	180d2423          	sw	zero,392(s10)
        c->proc = p;
    8000244c:	f7043903          	ld	s2,-144(s0)
    80002450:	03a93823          	sd	s10,48(s2)
        p->dynamicstime = 0;
    80002454:	160d2e23          	sw	zero,380(s10)
        p->dynamicrtime = 0;
    80002458:	160d2a23          	sw	zero,372(s10)
        p->numberoftimescheduled++;
    8000245c:	184d2783          	lw	a5,388(s10)
    80002460:	2785                	addiw	a5,a5,1
    80002462:	18fd2223          	sw	a5,388(s10)
        swtch(&c->context, &p->context);
    80002466:	060d0593          	addi	a1,s10,96
    8000246a:	f7843503          	ld	a0,-136(s0)
    8000246e:	00001097          	auipc	ra,0x1
    80002472:	906080e7          	jalr	-1786(ra) # 80002d74 <swtch>
        c->proc = 0;
    80002476:	02093823          	sd	zero,48(s2)
      release(&p->lock);
    8000247a:	8526                	mv	a0,s1
    8000247c:	fffff097          	auipc	ra,0xfffff
    80002480:	9ee080e7          	jalr	-1554(ra) # 80000e6a <release>
      if (p->defaultflag == 1)
    80002484:	4a05                	li	s4,1
        RBI = 25;
    80002486:	4ae5                	li	s5,25
      int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    80002488:	03200c13          	li	s8,50
    for (p = proc; p < &proc[NPROC]; p++)
    8000248c:	00235997          	auipc	s3,0x235
    80002490:	fac98993          	addi	s3,s3,-84 # 80237438 <tickslock>
    80002494:	bbf5                	j	80002290 <scheduler+0xee>

0000000080002496 <sched>:
{
    80002496:	7179                	addi	sp,sp,-48
    80002498:	f406                	sd	ra,40(sp)
    8000249a:	f022                	sd	s0,32(sp)
    8000249c:	ec26                	sd	s1,24(sp)
    8000249e:	e84a                	sd	s2,16(sp)
    800024a0:	e44e                	sd	s3,8(sp)
    800024a2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800024a4:	fffff097          	auipc	ra,0xfffff
    800024a8:	7d4080e7          	jalr	2004(ra) # 80001c78 <myproc>
    800024ac:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800024ae:	fffff097          	auipc	ra,0xfffff
    800024b2:	88e080e7          	jalr	-1906(ra) # 80000d3c <holding>
    800024b6:	c93d                	beqz	a0,8000252c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800024b8:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800024ba:	2781                	sext.w	a5,a5
    800024bc:	079e                	slli	a5,a5,0x7
    800024be:	0022e717          	auipc	a4,0x22e
    800024c2:	74a70713          	addi	a4,a4,1866 # 80230c08 <pid_lock>
    800024c6:	97ba                	add	a5,a5,a4
    800024c8:	0a87a703          	lw	a4,168(a5)
    800024cc:	4785                	li	a5,1
    800024ce:	06f71763          	bne	a4,a5,8000253c <sched+0xa6>
  if (p->state == RUNNING)
    800024d2:	4c98                	lw	a4,24(s1)
    800024d4:	4791                	li	a5,4
    800024d6:	06f70b63          	beq	a4,a5,8000254c <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024da:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800024de:	8b89                	andi	a5,a5,2
  if (intr_get())
    800024e0:	efb5                	bnez	a5,8000255c <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800024e2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800024e4:	0022e917          	auipc	s2,0x22e
    800024e8:	72490913          	addi	s2,s2,1828 # 80230c08 <pid_lock>
    800024ec:	2781                	sext.w	a5,a5
    800024ee:	079e                	slli	a5,a5,0x7
    800024f0:	97ca                	add	a5,a5,s2
    800024f2:	0ac7a983          	lw	s3,172(a5)
    800024f6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800024f8:	2781                	sext.w	a5,a5
    800024fa:	079e                	slli	a5,a5,0x7
    800024fc:	0022e597          	auipc	a1,0x22e
    80002500:	74458593          	addi	a1,a1,1860 # 80230c40 <cpus+0x8>
    80002504:	95be                	add	a1,a1,a5
    80002506:	06048513          	addi	a0,s1,96
    8000250a:	00001097          	auipc	ra,0x1
    8000250e:	86a080e7          	jalr	-1942(ra) # 80002d74 <swtch>
    80002512:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002514:	2781                	sext.w	a5,a5
    80002516:	079e                	slli	a5,a5,0x7
    80002518:	97ca                	add	a5,a5,s2
    8000251a:	0b37a623          	sw	s3,172(a5)
}
    8000251e:	70a2                	ld	ra,40(sp)
    80002520:	7402                	ld	s0,32(sp)
    80002522:	64e2                	ld	s1,24(sp)
    80002524:	6942                	ld	s2,16(sp)
    80002526:	69a2                	ld	s3,8(sp)
    80002528:	6145                	addi	sp,sp,48
    8000252a:	8082                	ret
    panic("sched p->lock");
    8000252c:	00006517          	auipc	a0,0x6
    80002530:	d4450513          	addi	a0,a0,-700 # 80008270 <digits+0x230>
    80002534:	ffffe097          	auipc	ra,0xffffe
    80002538:	00a080e7          	jalr	10(ra) # 8000053e <panic>
    panic("sched locks");
    8000253c:	00006517          	auipc	a0,0x6
    80002540:	d4450513          	addi	a0,a0,-700 # 80008280 <digits+0x240>
    80002544:	ffffe097          	auipc	ra,0xffffe
    80002548:	ffa080e7          	jalr	-6(ra) # 8000053e <panic>
    panic("sched running");
    8000254c:	00006517          	auipc	a0,0x6
    80002550:	d4450513          	addi	a0,a0,-700 # 80008290 <digits+0x250>
    80002554:	ffffe097          	auipc	ra,0xffffe
    80002558:	fea080e7          	jalr	-22(ra) # 8000053e <panic>
    panic("sched interruptible");
    8000255c:	00006517          	auipc	a0,0x6
    80002560:	d4450513          	addi	a0,a0,-700 # 800082a0 <digits+0x260>
    80002564:	ffffe097          	auipc	ra,0xffffe
    80002568:	fda080e7          	jalr	-38(ra) # 8000053e <panic>

000000008000256c <yield>:
{
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	e426                	sd	s1,8(sp)
    80002574:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002576:	fffff097          	auipc	ra,0xfffff
    8000257a:	702080e7          	jalr	1794(ra) # 80001c78 <myproc>
    8000257e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002580:	fffff097          	auipc	ra,0xfffff
    80002584:	836080e7          	jalr	-1994(ra) # 80000db6 <acquire>
  p->state = RUNNABLE;
    80002588:	478d                	li	a5,3
    8000258a:	cc9c                	sw	a5,24(s1)
  sched();
    8000258c:	00000097          	auipc	ra,0x0
    80002590:	f0a080e7          	jalr	-246(ra) # 80002496 <sched>
  release(&p->lock);
    80002594:	8526                	mv	a0,s1
    80002596:	fffff097          	auipc	ra,0xfffff
    8000259a:	8d4080e7          	jalr	-1836(ra) # 80000e6a <release>
}
    8000259e:	60e2                	ld	ra,24(sp)
    800025a0:	6442                	ld	s0,16(sp)
    800025a2:	64a2                	ld	s1,8(sp)
    800025a4:	6105                	addi	sp,sp,32
    800025a6:	8082                	ret

00000000800025a8 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800025a8:	7179                	addi	sp,sp,-48
    800025aa:	f406                	sd	ra,40(sp)
    800025ac:	f022                	sd	s0,32(sp)
    800025ae:	ec26                	sd	s1,24(sp)
    800025b0:	e84a                	sd	s2,16(sp)
    800025b2:	e44e                	sd	s3,8(sp)
    800025b4:	1800                	addi	s0,sp,48
    800025b6:	89aa                	mv	s3,a0
    800025b8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800025ba:	fffff097          	auipc	ra,0xfffff
    800025be:	6be080e7          	jalr	1726(ra) # 80001c78 <myproc>
    800025c2:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800025c4:	ffffe097          	auipc	ra,0xffffe
    800025c8:	7f2080e7          	jalr	2034(ra) # 80000db6 <acquire>
  release(lk);
    800025cc:	854a                	mv	a0,s2
    800025ce:	fffff097          	auipc	ra,0xfffff
    800025d2:	89c080e7          	jalr	-1892(ra) # 80000e6a <release>

  // Go to sleep.
  p->chan = chan;
    800025d6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800025da:	4789                	li	a5,2
    800025dc:	cc9c                	sw	a5,24(s1)

  sched();
    800025de:	00000097          	auipc	ra,0x0
    800025e2:	eb8080e7          	jalr	-328(ra) # 80002496 <sched>

  // Tidy up.
  p->chan = 0;
    800025e6:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800025ea:	8526                	mv	a0,s1
    800025ec:	fffff097          	auipc	ra,0xfffff
    800025f0:	87e080e7          	jalr	-1922(ra) # 80000e6a <release>
  acquire(lk);
    800025f4:	854a                	mv	a0,s2
    800025f6:	ffffe097          	auipc	ra,0xffffe
    800025fa:	7c0080e7          	jalr	1984(ra) # 80000db6 <acquire>
}
    800025fe:	70a2                	ld	ra,40(sp)
    80002600:	7402                	ld	s0,32(sp)
    80002602:	64e2                	ld	s1,24(sp)
    80002604:	6942                	ld	s2,16(sp)
    80002606:	69a2                	ld	s3,8(sp)
    80002608:	6145                	addi	sp,sp,48
    8000260a:	8082                	ret

000000008000260c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000260c:	7139                	addi	sp,sp,-64
    8000260e:	fc06                	sd	ra,56(sp)
    80002610:	f822                	sd	s0,48(sp)
    80002612:	f426                	sd	s1,40(sp)
    80002614:	f04a                	sd	s2,32(sp)
    80002616:	ec4e                	sd	s3,24(sp)
    80002618:	e852                	sd	s4,16(sp)
    8000261a:	e456                	sd	s5,8(sp)
    8000261c:	0080                	addi	s0,sp,64
    8000261e:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80002620:	0022f497          	auipc	s1,0x22f
    80002624:	a1848493          	addi	s1,s1,-1512 # 80231038 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    80002628:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    8000262a:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    8000262c:	00235917          	auipc	s2,0x235
    80002630:	e0c90913          	addi	s2,s2,-500 # 80237438 <tickslock>
    80002634:	a811                	j	80002648 <wakeup+0x3c>
      }
      release(&p->lock);
    80002636:	8526                	mv	a0,s1
    80002638:	fffff097          	auipc	ra,0xfffff
    8000263c:	832080e7          	jalr	-1998(ra) # 80000e6a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002640:	19048493          	addi	s1,s1,400
    80002644:	03248663          	beq	s1,s2,80002670 <wakeup+0x64>
    if (p != myproc())
    80002648:	fffff097          	auipc	ra,0xfffff
    8000264c:	630080e7          	jalr	1584(ra) # 80001c78 <myproc>
    80002650:	fea488e3          	beq	s1,a0,80002640 <wakeup+0x34>
      acquire(&p->lock);
    80002654:	8526                	mv	a0,s1
    80002656:	ffffe097          	auipc	ra,0xffffe
    8000265a:	760080e7          	jalr	1888(ra) # 80000db6 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    8000265e:	4c9c                	lw	a5,24(s1)
    80002660:	fd379be3          	bne	a5,s3,80002636 <wakeup+0x2a>
    80002664:	709c                	ld	a5,32(s1)
    80002666:	fd4798e3          	bne	a5,s4,80002636 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000266a:	0154ac23          	sw	s5,24(s1)
    8000266e:	b7e1                	j	80002636 <wakeup+0x2a>
    }
  }
}
    80002670:	70e2                	ld	ra,56(sp)
    80002672:	7442                	ld	s0,48(sp)
    80002674:	74a2                	ld	s1,40(sp)
    80002676:	7902                	ld	s2,32(sp)
    80002678:	69e2                	ld	s3,24(sp)
    8000267a:	6a42                	ld	s4,16(sp)
    8000267c:	6aa2                	ld	s5,8(sp)
    8000267e:	6121                	addi	sp,sp,64
    80002680:	8082                	ret

0000000080002682 <reparent>:
{
    80002682:	7179                	addi	sp,sp,-48
    80002684:	f406                	sd	ra,40(sp)
    80002686:	f022                	sd	s0,32(sp)
    80002688:	ec26                	sd	s1,24(sp)
    8000268a:	e84a                	sd	s2,16(sp)
    8000268c:	e44e                	sd	s3,8(sp)
    8000268e:	e052                	sd	s4,0(sp)
    80002690:	1800                	addi	s0,sp,48
    80002692:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    80002694:	0022f497          	auipc	s1,0x22f
    80002698:	9a448493          	addi	s1,s1,-1628 # 80231038 <proc>
      pp->parent = initproc;
    8000269c:	00006a17          	auipc	s4,0x6
    800026a0:	2dca0a13          	addi	s4,s4,732 # 80008978 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800026a4:	00235997          	auipc	s3,0x235
    800026a8:	d9498993          	addi	s3,s3,-620 # 80237438 <tickslock>
    800026ac:	a029                	j	800026b6 <reparent+0x34>
    800026ae:	19048493          	addi	s1,s1,400
    800026b2:	01348d63          	beq	s1,s3,800026cc <reparent+0x4a>
    if (pp->parent == p)
    800026b6:	7c9c                	ld	a5,56(s1)
    800026b8:	ff279be3          	bne	a5,s2,800026ae <reparent+0x2c>
      pp->parent = initproc;
    800026bc:	000a3503          	ld	a0,0(s4)
    800026c0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800026c2:	00000097          	auipc	ra,0x0
    800026c6:	f4a080e7          	jalr	-182(ra) # 8000260c <wakeup>
    800026ca:	b7d5                	j	800026ae <reparent+0x2c>
}
    800026cc:	70a2                	ld	ra,40(sp)
    800026ce:	7402                	ld	s0,32(sp)
    800026d0:	64e2                	ld	s1,24(sp)
    800026d2:	6942                	ld	s2,16(sp)
    800026d4:	69a2                	ld	s3,8(sp)
    800026d6:	6a02                	ld	s4,0(sp)
    800026d8:	6145                	addi	sp,sp,48
    800026da:	8082                	ret

00000000800026dc <exit>:
{
    800026dc:	7179                	addi	sp,sp,-48
    800026de:	f406                	sd	ra,40(sp)
    800026e0:	f022                	sd	s0,32(sp)
    800026e2:	ec26                	sd	s1,24(sp)
    800026e4:	e84a                	sd	s2,16(sp)
    800026e6:	e44e                	sd	s3,8(sp)
    800026e8:	e052                	sd	s4,0(sp)
    800026ea:	1800                	addi	s0,sp,48
    800026ec:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800026ee:	fffff097          	auipc	ra,0xfffff
    800026f2:	58a080e7          	jalr	1418(ra) # 80001c78 <myproc>
    800026f6:	89aa                	mv	s3,a0
  if (p == initproc)
    800026f8:	00006797          	auipc	a5,0x6
    800026fc:	2807b783          	ld	a5,640(a5) # 80008978 <initproc>
    80002700:	0d050493          	addi	s1,a0,208
    80002704:	15050913          	addi	s2,a0,336
    80002708:	02a79363          	bne	a5,a0,8000272e <exit+0x52>
    panic("init exiting");
    8000270c:	00006517          	auipc	a0,0x6
    80002710:	bac50513          	addi	a0,a0,-1108 # 800082b8 <digits+0x278>
    80002714:	ffffe097          	auipc	ra,0xffffe
    80002718:	e2a080e7          	jalr	-470(ra) # 8000053e <panic>
      fileclose(f);
    8000271c:	00002097          	auipc	ra,0x2
    80002720:	6e6080e7          	jalr	1766(ra) # 80004e02 <fileclose>
      p->ofile[fd] = 0;
    80002724:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    80002728:	04a1                	addi	s1,s1,8
    8000272a:	01248563          	beq	s1,s2,80002734 <exit+0x58>
    if (p->ofile[fd])
    8000272e:	6088                	ld	a0,0(s1)
    80002730:	f575                	bnez	a0,8000271c <exit+0x40>
    80002732:	bfdd                	j	80002728 <exit+0x4c>
  begin_op();
    80002734:	00002097          	auipc	ra,0x2
    80002738:	202080e7          	jalr	514(ra) # 80004936 <begin_op>
  iput(p->cwd);
    8000273c:	1509b503          	ld	a0,336(s3)
    80002740:	00002097          	auipc	ra,0x2
    80002744:	9ee080e7          	jalr	-1554(ra) # 8000412e <iput>
  end_op();
    80002748:	00002097          	auipc	ra,0x2
    8000274c:	26e080e7          	jalr	622(ra) # 800049b6 <end_op>
  p->cwd = 0;
    80002750:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002754:	0022e497          	auipc	s1,0x22e
    80002758:	4cc48493          	addi	s1,s1,1228 # 80230c20 <wait_lock>
    8000275c:	8526                	mv	a0,s1
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	658080e7          	jalr	1624(ra) # 80000db6 <acquire>
  reparent(p);
    80002766:	854e                	mv	a0,s3
    80002768:	00000097          	auipc	ra,0x0
    8000276c:	f1a080e7          	jalr	-230(ra) # 80002682 <reparent>
  wakeup(p->parent);
    80002770:	0389b503          	ld	a0,56(s3)
    80002774:	00000097          	auipc	ra,0x0
    80002778:	e98080e7          	jalr	-360(ra) # 8000260c <wakeup>
  acquire(&p->lock);
    8000277c:	854e                	mv	a0,s3
    8000277e:	ffffe097          	auipc	ra,0xffffe
    80002782:	638080e7          	jalr	1592(ra) # 80000db6 <acquire>
  p->xstate = status;
    80002786:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000278a:	4795                	li	a5,5
    8000278c:	00f9ac23          	sw	a5,24(s3)
  p->etime = ticks;
    80002790:	00006797          	auipc	a5,0x6
    80002794:	1f07a783          	lw	a5,496(a5) # 80008980 <ticks>
    80002798:	16f9a823          	sw	a5,368(s3)
  release(&wait_lock);
    8000279c:	8526                	mv	a0,s1
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	6cc080e7          	jalr	1740(ra) # 80000e6a <release>
  sched();
    800027a6:	00000097          	auipc	ra,0x0
    800027aa:	cf0080e7          	jalr	-784(ra) # 80002496 <sched>
  panic("zombie exit");
    800027ae:	00006517          	auipc	a0,0x6
    800027b2:	b1a50513          	addi	a0,a0,-1254 # 800082c8 <digits+0x288>
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	d88080e7          	jalr	-632(ra) # 8000053e <panic>

00000000800027be <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800027be:	7179                	addi	sp,sp,-48
    800027c0:	f406                	sd	ra,40(sp)
    800027c2:	f022                	sd	s0,32(sp)
    800027c4:	ec26                	sd	s1,24(sp)
    800027c6:	e84a                	sd	s2,16(sp)
    800027c8:	e44e                	sd	s3,8(sp)
    800027ca:	1800                	addi	s0,sp,48
    800027cc:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800027ce:	0022f497          	auipc	s1,0x22f
    800027d2:	86a48493          	addi	s1,s1,-1942 # 80231038 <proc>
    800027d6:	00235997          	auipc	s3,0x235
    800027da:	c6298993          	addi	s3,s3,-926 # 80237438 <tickslock>
  {
    acquire(&p->lock);
    800027de:	8526                	mv	a0,s1
    800027e0:	ffffe097          	auipc	ra,0xffffe
    800027e4:	5d6080e7          	jalr	1494(ra) # 80000db6 <acquire>
    if (p->pid == pid)
    800027e8:	589c                	lw	a5,48(s1)
    800027ea:	01278d63          	beq	a5,s2,80002804 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800027ee:	8526                	mv	a0,s1
    800027f0:	ffffe097          	auipc	ra,0xffffe
    800027f4:	67a080e7          	jalr	1658(ra) # 80000e6a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800027f8:	19048493          	addi	s1,s1,400
    800027fc:	ff3491e3          	bne	s1,s3,800027de <kill+0x20>
  }
  return -1;
    80002800:	557d                	li	a0,-1
    80002802:	a829                	j	8000281c <kill+0x5e>
      p->killed = 1;
    80002804:	4785                	li	a5,1
    80002806:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80002808:	4c98                	lw	a4,24(s1)
    8000280a:	4789                	li	a5,2
    8000280c:	00f70f63          	beq	a4,a5,8000282a <kill+0x6c>
      release(&p->lock);
    80002810:	8526                	mv	a0,s1
    80002812:	ffffe097          	auipc	ra,0xffffe
    80002816:	658080e7          	jalr	1624(ra) # 80000e6a <release>
      return 0;
    8000281a:	4501                	li	a0,0
}
    8000281c:	70a2                	ld	ra,40(sp)
    8000281e:	7402                	ld	s0,32(sp)
    80002820:	64e2                	ld	s1,24(sp)
    80002822:	6942                	ld	s2,16(sp)
    80002824:	69a2                	ld	s3,8(sp)
    80002826:	6145                	addi	sp,sp,48
    80002828:	8082                	ret
        p->state = RUNNABLE;
    8000282a:	478d                	li	a5,3
    8000282c:	cc9c                	sw	a5,24(s1)
    8000282e:	b7cd                	j	80002810 <kill+0x52>

0000000080002830 <setkilled>:

void setkilled(struct proc *p)
{
    80002830:	1101                	addi	sp,sp,-32
    80002832:	ec06                	sd	ra,24(sp)
    80002834:	e822                	sd	s0,16(sp)
    80002836:	e426                	sd	s1,8(sp)
    80002838:	1000                	addi	s0,sp,32
    8000283a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000283c:	ffffe097          	auipc	ra,0xffffe
    80002840:	57a080e7          	jalr	1402(ra) # 80000db6 <acquire>
  p->killed = 1;
    80002844:	4785                	li	a5,1
    80002846:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002848:	8526                	mv	a0,s1
    8000284a:	ffffe097          	auipc	ra,0xffffe
    8000284e:	620080e7          	jalr	1568(ra) # 80000e6a <release>
}
    80002852:	60e2                	ld	ra,24(sp)
    80002854:	6442                	ld	s0,16(sp)
    80002856:	64a2                	ld	s1,8(sp)
    80002858:	6105                	addi	sp,sp,32
    8000285a:	8082                	ret

000000008000285c <killed>:

int killed(struct proc *p)
{
    8000285c:	1101                	addi	sp,sp,-32
    8000285e:	ec06                	sd	ra,24(sp)
    80002860:	e822                	sd	s0,16(sp)
    80002862:	e426                	sd	s1,8(sp)
    80002864:	e04a                	sd	s2,0(sp)
    80002866:	1000                	addi	s0,sp,32
    80002868:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000286a:	ffffe097          	auipc	ra,0xffffe
    8000286e:	54c080e7          	jalr	1356(ra) # 80000db6 <acquire>
  k = p->killed;
    80002872:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002876:	8526                	mv	a0,s1
    80002878:	ffffe097          	auipc	ra,0xffffe
    8000287c:	5f2080e7          	jalr	1522(ra) # 80000e6a <release>
  return k;
}
    80002880:	854a                	mv	a0,s2
    80002882:	60e2                	ld	ra,24(sp)
    80002884:	6442                	ld	s0,16(sp)
    80002886:	64a2                	ld	s1,8(sp)
    80002888:	6902                	ld	s2,0(sp)
    8000288a:	6105                	addi	sp,sp,32
    8000288c:	8082                	ret

000000008000288e <wait>:
{
    8000288e:	715d                	addi	sp,sp,-80
    80002890:	e486                	sd	ra,72(sp)
    80002892:	e0a2                	sd	s0,64(sp)
    80002894:	fc26                	sd	s1,56(sp)
    80002896:	f84a                	sd	s2,48(sp)
    80002898:	f44e                	sd	s3,40(sp)
    8000289a:	f052                	sd	s4,32(sp)
    8000289c:	ec56                	sd	s5,24(sp)
    8000289e:	e85a                	sd	s6,16(sp)
    800028a0:	e45e                	sd	s7,8(sp)
    800028a2:	e062                	sd	s8,0(sp)
    800028a4:	0880                	addi	s0,sp,80
    800028a6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800028a8:	fffff097          	auipc	ra,0xfffff
    800028ac:	3d0080e7          	jalr	976(ra) # 80001c78 <myproc>
    800028b0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800028b2:	0022e517          	auipc	a0,0x22e
    800028b6:	36e50513          	addi	a0,a0,878 # 80230c20 <wait_lock>
    800028ba:	ffffe097          	auipc	ra,0xffffe
    800028be:	4fc080e7          	jalr	1276(ra) # 80000db6 <acquire>
    havekids = 0;
    800028c2:	4b81                	li	s7,0
        if (pp->state == ZOMBIE)
    800028c4:	4a15                	li	s4,5
        havekids = 1;
    800028c6:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800028c8:	00235997          	auipc	s3,0x235
    800028cc:	b7098993          	addi	s3,s3,-1168 # 80237438 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800028d0:	0022ec17          	auipc	s8,0x22e
    800028d4:	350c0c13          	addi	s8,s8,848 # 80230c20 <wait_lock>
    havekids = 0;
    800028d8:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800028da:	0022e497          	auipc	s1,0x22e
    800028de:	75e48493          	addi	s1,s1,1886 # 80231038 <proc>
    800028e2:	a0bd                	j	80002950 <wait+0xc2>
          pid = pp->pid;
    800028e4:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800028e8:	000b0e63          	beqz	s6,80002904 <wait+0x76>
    800028ec:	4691                	li	a3,4
    800028ee:	02c48613          	addi	a2,s1,44
    800028f2:	85da                	mv	a1,s6
    800028f4:	05093503          	ld	a0,80(s2)
    800028f8:	fffff097          	auipc	ra,0xfffff
    800028fc:	f8e080e7          	jalr	-114(ra) # 80001886 <copyout>
    80002900:	02054563          	bltz	a0,8000292a <wait+0x9c>
          freeproc(pp);
    80002904:	8526                	mv	a0,s1
    80002906:	fffff097          	auipc	ra,0xfffff
    8000290a:	524080e7          	jalr	1316(ra) # 80001e2a <freeproc>
          release(&pp->lock);
    8000290e:	8526                	mv	a0,s1
    80002910:	ffffe097          	auipc	ra,0xffffe
    80002914:	55a080e7          	jalr	1370(ra) # 80000e6a <release>
          release(&wait_lock);
    80002918:	0022e517          	auipc	a0,0x22e
    8000291c:	30850513          	addi	a0,a0,776 # 80230c20 <wait_lock>
    80002920:	ffffe097          	auipc	ra,0xffffe
    80002924:	54a080e7          	jalr	1354(ra) # 80000e6a <release>
          return pid;
    80002928:	a0b5                	j	80002994 <wait+0x106>
            release(&pp->lock);
    8000292a:	8526                	mv	a0,s1
    8000292c:	ffffe097          	auipc	ra,0xffffe
    80002930:	53e080e7          	jalr	1342(ra) # 80000e6a <release>
            release(&wait_lock);
    80002934:	0022e517          	auipc	a0,0x22e
    80002938:	2ec50513          	addi	a0,a0,748 # 80230c20 <wait_lock>
    8000293c:	ffffe097          	auipc	ra,0xffffe
    80002940:	52e080e7          	jalr	1326(ra) # 80000e6a <release>
            return -1;
    80002944:	59fd                	li	s3,-1
    80002946:	a0b9                	j	80002994 <wait+0x106>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002948:	19048493          	addi	s1,s1,400
    8000294c:	03348463          	beq	s1,s3,80002974 <wait+0xe6>
      if (pp->parent == p)
    80002950:	7c9c                	ld	a5,56(s1)
    80002952:	ff279be3          	bne	a5,s2,80002948 <wait+0xba>
        acquire(&pp->lock);
    80002956:	8526                	mv	a0,s1
    80002958:	ffffe097          	auipc	ra,0xffffe
    8000295c:	45e080e7          	jalr	1118(ra) # 80000db6 <acquire>
        if (pp->state == ZOMBIE)
    80002960:	4c9c                	lw	a5,24(s1)
    80002962:	f94781e3          	beq	a5,s4,800028e4 <wait+0x56>
        release(&pp->lock);
    80002966:	8526                	mv	a0,s1
    80002968:	ffffe097          	auipc	ra,0xffffe
    8000296c:	502080e7          	jalr	1282(ra) # 80000e6a <release>
        havekids = 1;
    80002970:	8756                	mv	a4,s5
    80002972:	bfd9                	j	80002948 <wait+0xba>
    if (!havekids || killed(p))
    80002974:	c719                	beqz	a4,80002982 <wait+0xf4>
    80002976:	854a                	mv	a0,s2
    80002978:	00000097          	auipc	ra,0x0
    8000297c:	ee4080e7          	jalr	-284(ra) # 8000285c <killed>
    80002980:	c51d                	beqz	a0,800029ae <wait+0x120>
      release(&wait_lock);
    80002982:	0022e517          	auipc	a0,0x22e
    80002986:	29e50513          	addi	a0,a0,670 # 80230c20 <wait_lock>
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	4e0080e7          	jalr	1248(ra) # 80000e6a <release>
      return -1;
    80002992:	59fd                	li	s3,-1
}
    80002994:	854e                	mv	a0,s3
    80002996:	60a6                	ld	ra,72(sp)
    80002998:	6406                	ld	s0,64(sp)
    8000299a:	74e2                	ld	s1,56(sp)
    8000299c:	7942                	ld	s2,48(sp)
    8000299e:	79a2                	ld	s3,40(sp)
    800029a0:	7a02                	ld	s4,32(sp)
    800029a2:	6ae2                	ld	s5,24(sp)
    800029a4:	6b42                	ld	s6,16(sp)
    800029a6:	6ba2                	ld	s7,8(sp)
    800029a8:	6c02                	ld	s8,0(sp)
    800029aa:	6161                	addi	sp,sp,80
    800029ac:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    800029ae:	85e2                	mv	a1,s8
    800029b0:	854a                	mv	a0,s2
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	bf6080e7          	jalr	-1034(ra) # 800025a8 <sleep>
    havekids = 0;
    800029ba:	bf39                	j	800028d8 <wait+0x4a>

00000000800029bc <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800029bc:	7179                	addi	sp,sp,-48
    800029be:	f406                	sd	ra,40(sp)
    800029c0:	f022                	sd	s0,32(sp)
    800029c2:	ec26                	sd	s1,24(sp)
    800029c4:	e84a                	sd	s2,16(sp)
    800029c6:	e44e                	sd	s3,8(sp)
    800029c8:	e052                	sd	s4,0(sp)
    800029ca:	1800                	addi	s0,sp,48
    800029cc:	84aa                	mv	s1,a0
    800029ce:	892e                	mv	s2,a1
    800029d0:	89b2                	mv	s3,a2
    800029d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800029d4:	fffff097          	auipc	ra,0xfffff
    800029d8:	2a4080e7          	jalr	676(ra) # 80001c78 <myproc>
  if (user_dst)
    800029dc:	c08d                	beqz	s1,800029fe <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    800029de:	86d2                	mv	a3,s4
    800029e0:	864e                	mv	a2,s3
    800029e2:	85ca                	mv	a1,s2
    800029e4:	6928                	ld	a0,80(a0)
    800029e6:	fffff097          	auipc	ra,0xfffff
    800029ea:	ea0080e7          	jalr	-352(ra) # 80001886 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800029ee:	70a2                	ld	ra,40(sp)
    800029f0:	7402                	ld	s0,32(sp)
    800029f2:	64e2                	ld	s1,24(sp)
    800029f4:	6942                	ld	s2,16(sp)
    800029f6:	69a2                	ld	s3,8(sp)
    800029f8:	6a02                	ld	s4,0(sp)
    800029fa:	6145                	addi	sp,sp,48
    800029fc:	8082                	ret
    memmove((char *)dst, src, len);
    800029fe:	000a061b          	sext.w	a2,s4
    80002a02:	85ce                	mv	a1,s3
    80002a04:	854a                	mv	a0,s2
    80002a06:	ffffe097          	auipc	ra,0xffffe
    80002a0a:	508080e7          	jalr	1288(ra) # 80000f0e <memmove>
    return 0;
    80002a0e:	8526                	mv	a0,s1
    80002a10:	bff9                	j	800029ee <either_copyout+0x32>

0000000080002a12 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002a12:	7179                	addi	sp,sp,-48
    80002a14:	f406                	sd	ra,40(sp)
    80002a16:	f022                	sd	s0,32(sp)
    80002a18:	ec26                	sd	s1,24(sp)
    80002a1a:	e84a                	sd	s2,16(sp)
    80002a1c:	e44e                	sd	s3,8(sp)
    80002a1e:	e052                	sd	s4,0(sp)
    80002a20:	1800                	addi	s0,sp,48
    80002a22:	892a                	mv	s2,a0
    80002a24:	84ae                	mv	s1,a1
    80002a26:	89b2                	mv	s3,a2
    80002a28:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002a2a:	fffff097          	auipc	ra,0xfffff
    80002a2e:	24e080e7          	jalr	590(ra) # 80001c78 <myproc>
  if (user_src)
    80002a32:	c08d                	beqz	s1,80002a54 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80002a34:	86d2                	mv	a3,s4
    80002a36:	864e                	mv	a2,s3
    80002a38:	85ca                	mv	a1,s2
    80002a3a:	6928                	ld	a0,80(a0)
    80002a3c:	fffff097          	auipc	ra,0xfffff
    80002a40:	f84080e7          	jalr	-124(ra) # 800019c0 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002a44:	70a2                	ld	ra,40(sp)
    80002a46:	7402                	ld	s0,32(sp)
    80002a48:	64e2                	ld	s1,24(sp)
    80002a4a:	6942                	ld	s2,16(sp)
    80002a4c:	69a2                	ld	s3,8(sp)
    80002a4e:	6a02                	ld	s4,0(sp)
    80002a50:	6145                	addi	sp,sp,48
    80002a52:	8082                	ret
    memmove(dst, (char *)src, len);
    80002a54:	000a061b          	sext.w	a2,s4
    80002a58:	85ce                	mv	a1,s3
    80002a5a:	854a                	mv	a0,s2
    80002a5c:	ffffe097          	auipc	ra,0xffffe
    80002a60:	4b2080e7          	jalr	1202(ra) # 80000f0e <memmove>
    return 0;
    80002a64:	8526                	mv	a0,s1
    80002a66:	bff9                	j	80002a44 <either_copyin+0x32>

0000000080002a68 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002a68:	715d                	addi	sp,sp,-80
    80002a6a:	e486                	sd	ra,72(sp)
    80002a6c:	e0a2                	sd	s0,64(sp)
    80002a6e:	fc26                	sd	s1,56(sp)
    80002a70:	f84a                	sd	s2,48(sp)
    80002a72:	f44e                	sd	s3,40(sp)
    80002a74:	f052                	sd	s4,32(sp)
    80002a76:	ec56                	sd	s5,24(sp)
    80002a78:	e85a                	sd	s6,16(sp)
    80002a7a:	e45e                	sd	s7,8(sp)
    80002a7c:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80002a7e:	00005517          	auipc	a0,0x5
    80002a82:	7aa50513          	addi	a0,a0,1962 # 80008228 <digits+0x1e8>
    80002a86:	ffffe097          	auipc	ra,0xffffe
    80002a8a:	b02080e7          	jalr	-1278(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002a8e:	0022e497          	auipc	s1,0x22e
    80002a92:	70248493          	addi	s1,s1,1794 # 80231190 <proc+0x158>
    80002a96:	00235917          	auipc	s2,0x235
    80002a9a:	afa90913          	addi	s2,s2,-1286 # 80237590 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a9e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002aa0:	00006997          	auipc	s3,0x6
    80002aa4:	83898993          	addi	s3,s3,-1992 # 800082d8 <digits+0x298>
    printf("%d %s %s", p->pid, state, p->name);
    80002aa8:	00006a97          	auipc	s5,0x6
    80002aac:	838a8a93          	addi	s5,s5,-1992 # 800082e0 <digits+0x2a0>
    printf("\n");
    80002ab0:	00005a17          	auipc	s4,0x5
    80002ab4:	778a0a13          	addi	s4,s4,1912 # 80008228 <digits+0x1e8>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ab8:	00006b97          	auipc	s7,0x6
    80002abc:	868b8b93          	addi	s7,s7,-1944 # 80008320 <states.0>
    80002ac0:	a00d                	j	80002ae2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002ac2:	ed86a583          	lw	a1,-296(a3)
    80002ac6:	8556                	mv	a0,s5
    80002ac8:	ffffe097          	auipc	ra,0xffffe
    80002acc:	ac0080e7          	jalr	-1344(ra) # 80000588 <printf>
    printf("\n");
    80002ad0:	8552                	mv	a0,s4
    80002ad2:	ffffe097          	auipc	ra,0xffffe
    80002ad6:	ab6080e7          	jalr	-1354(ra) # 80000588 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80002ada:	19048493          	addi	s1,s1,400
    80002ade:	03248163          	beq	s1,s2,80002b00 <procdump+0x98>
    if (p->state == UNUSED)
    80002ae2:	86a6                	mv	a3,s1
    80002ae4:	ec04a783          	lw	a5,-320(s1)
    80002ae8:	dbed                	beqz	a5,80002ada <procdump+0x72>
      state = "???";
    80002aea:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002aec:	fcfb6be3          	bltu	s6,a5,80002ac2 <procdump+0x5a>
    80002af0:	1782                	slli	a5,a5,0x20
    80002af2:	9381                	srli	a5,a5,0x20
    80002af4:	078e                	slli	a5,a5,0x3
    80002af6:	97de                	add	a5,a5,s7
    80002af8:	6390                	ld	a2,0(a5)
    80002afa:	f661                	bnez	a2,80002ac2 <procdump+0x5a>
      state = "???";
    80002afc:	864e                	mv	a2,s3
    80002afe:	b7d1                	j	80002ac2 <procdump+0x5a>
  }
}
    80002b00:	60a6                	ld	ra,72(sp)
    80002b02:	6406                	ld	s0,64(sp)
    80002b04:	74e2                	ld	s1,56(sp)
    80002b06:	7942                	ld	s2,48(sp)
    80002b08:	79a2                	ld	s3,40(sp)
    80002b0a:	7a02                	ld	s4,32(sp)
    80002b0c:	6ae2                	ld	s5,24(sp)
    80002b0e:	6b42                	ld	s6,16(sp)
    80002b10:	6ba2                	ld	s7,8(sp)
    80002b12:	6161                	addi	sp,sp,80
    80002b14:	8082                	ret

0000000080002b16 <waitx>:

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
    80002b16:	711d                	addi	sp,sp,-96
    80002b18:	ec86                	sd	ra,88(sp)
    80002b1a:	e8a2                	sd	s0,80(sp)
    80002b1c:	e4a6                	sd	s1,72(sp)
    80002b1e:	e0ca                	sd	s2,64(sp)
    80002b20:	fc4e                	sd	s3,56(sp)
    80002b22:	f852                	sd	s4,48(sp)
    80002b24:	f456                	sd	s5,40(sp)
    80002b26:	f05a                	sd	s6,32(sp)
    80002b28:	ec5e                	sd	s7,24(sp)
    80002b2a:	e862                	sd	s8,16(sp)
    80002b2c:	e466                	sd	s9,8(sp)
    80002b2e:	e06a                	sd	s10,0(sp)
    80002b30:	1080                	addi	s0,sp,96
    80002b32:	8b2a                	mv	s6,a0
    80002b34:	8bae                	mv	s7,a1
    80002b36:	8c32                	mv	s8,a2
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();
    80002b38:	fffff097          	auipc	ra,0xfffff
    80002b3c:	140080e7          	jalr	320(ra) # 80001c78 <myproc>
    80002b40:	892a                	mv	s2,a0

  acquire(&wait_lock);
    80002b42:	0022e517          	auipc	a0,0x22e
    80002b46:	0de50513          	addi	a0,a0,222 # 80230c20 <wait_lock>
    80002b4a:	ffffe097          	auipc	ra,0xffffe
    80002b4e:	26c080e7          	jalr	620(ra) # 80000db6 <acquire>

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    80002b52:	4c81                	li	s9,0
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
    80002b54:	4a15                	li	s4,5
        havekids = 1;
    80002b56:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80002b58:	00235997          	auipc	s3,0x235
    80002b5c:	8e098993          	addi	s3,s3,-1824 # 80237438 <tickslock>
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002b60:	0022ed17          	auipc	s10,0x22e
    80002b64:	0c0d0d13          	addi	s10,s10,192 # 80230c20 <wait_lock>
    havekids = 0;
    80002b68:	8766                	mv	a4,s9
    for (np = proc; np < &proc[NPROC]; np++)
    80002b6a:	0022e497          	auipc	s1,0x22e
    80002b6e:	4ce48493          	addi	s1,s1,1230 # 80231038 <proc>
    80002b72:	a059                	j	80002bf8 <waitx+0xe2>
          pid = np->pid;
    80002b74:	0304a983          	lw	s3,48(s1)
          *rtime = np->rtime;
    80002b78:	1684a703          	lw	a4,360(s1)
    80002b7c:	00ec2023          	sw	a4,0(s8)
          *wtime = np->etime - np->ctime - np->rtime;
    80002b80:	16c4a783          	lw	a5,364(s1)
    80002b84:	9f3d                	addw	a4,a4,a5
    80002b86:	1704a783          	lw	a5,368(s1)
    80002b8a:	9f99                	subw	a5,a5,a4
    80002b8c:	00fba023          	sw	a5,0(s7)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002b90:	000b0e63          	beqz	s6,80002bac <waitx+0x96>
    80002b94:	4691                	li	a3,4
    80002b96:	02c48613          	addi	a2,s1,44
    80002b9a:	85da                	mv	a1,s6
    80002b9c:	05093503          	ld	a0,80(s2)
    80002ba0:	fffff097          	auipc	ra,0xfffff
    80002ba4:	ce6080e7          	jalr	-794(ra) # 80001886 <copyout>
    80002ba8:	02054563          	bltz	a0,80002bd2 <waitx+0xbc>
          freeproc(np);
    80002bac:	8526                	mv	a0,s1
    80002bae:	fffff097          	auipc	ra,0xfffff
    80002bb2:	27c080e7          	jalr	636(ra) # 80001e2a <freeproc>
          release(&np->lock);
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	ffffe097          	auipc	ra,0xffffe
    80002bbc:	2b2080e7          	jalr	690(ra) # 80000e6a <release>
          release(&wait_lock);
    80002bc0:	0022e517          	auipc	a0,0x22e
    80002bc4:	06050513          	addi	a0,a0,96 # 80230c20 <wait_lock>
    80002bc8:	ffffe097          	auipc	ra,0xffffe
    80002bcc:	2a2080e7          	jalr	674(ra) # 80000e6a <release>
          return pid;
    80002bd0:	a09d                	j	80002c36 <waitx+0x120>
            release(&np->lock);
    80002bd2:	8526                	mv	a0,s1
    80002bd4:	ffffe097          	auipc	ra,0xffffe
    80002bd8:	296080e7          	jalr	662(ra) # 80000e6a <release>
            release(&wait_lock);
    80002bdc:	0022e517          	auipc	a0,0x22e
    80002be0:	04450513          	addi	a0,a0,68 # 80230c20 <wait_lock>
    80002be4:	ffffe097          	auipc	ra,0xffffe
    80002be8:	286080e7          	jalr	646(ra) # 80000e6a <release>
            return -1;
    80002bec:	59fd                	li	s3,-1
    80002bee:	a0a1                	j	80002c36 <waitx+0x120>
    for (np = proc; np < &proc[NPROC]; np++)
    80002bf0:	19048493          	addi	s1,s1,400
    80002bf4:	03348463          	beq	s1,s3,80002c1c <waitx+0x106>
      if (np->parent == p)
    80002bf8:	7c9c                	ld	a5,56(s1)
    80002bfa:	ff279be3          	bne	a5,s2,80002bf0 <waitx+0xda>
        acquire(&np->lock);
    80002bfe:	8526                	mv	a0,s1
    80002c00:	ffffe097          	auipc	ra,0xffffe
    80002c04:	1b6080e7          	jalr	438(ra) # 80000db6 <acquire>
        if (np->state == ZOMBIE)
    80002c08:	4c9c                	lw	a5,24(s1)
    80002c0a:	f74785e3          	beq	a5,s4,80002b74 <waitx+0x5e>
        release(&np->lock);
    80002c0e:	8526                	mv	a0,s1
    80002c10:	ffffe097          	auipc	ra,0xffffe
    80002c14:	25a080e7          	jalr	602(ra) # 80000e6a <release>
        havekids = 1;
    80002c18:	8756                	mv	a4,s5
    80002c1a:	bfd9                	j	80002bf0 <waitx+0xda>
    if (!havekids || p->killed)
    80002c1c:	c701                	beqz	a4,80002c24 <waitx+0x10e>
    80002c1e:	02892783          	lw	a5,40(s2)
    80002c22:	cb8d                	beqz	a5,80002c54 <waitx+0x13e>
      release(&wait_lock);
    80002c24:	0022e517          	auipc	a0,0x22e
    80002c28:	ffc50513          	addi	a0,a0,-4 # 80230c20 <wait_lock>
    80002c2c:	ffffe097          	auipc	ra,0xffffe
    80002c30:	23e080e7          	jalr	574(ra) # 80000e6a <release>
      return -1;
    80002c34:	59fd                	li	s3,-1
  }
}
    80002c36:	854e                	mv	a0,s3
    80002c38:	60e6                	ld	ra,88(sp)
    80002c3a:	6446                	ld	s0,80(sp)
    80002c3c:	64a6                	ld	s1,72(sp)
    80002c3e:	6906                	ld	s2,64(sp)
    80002c40:	79e2                	ld	s3,56(sp)
    80002c42:	7a42                	ld	s4,48(sp)
    80002c44:	7aa2                	ld	s5,40(sp)
    80002c46:	7b02                	ld	s6,32(sp)
    80002c48:	6be2                	ld	s7,24(sp)
    80002c4a:	6c42                	ld	s8,16(sp)
    80002c4c:	6ca2                	ld	s9,8(sp)
    80002c4e:	6d02                	ld	s10,0(sp)
    80002c50:	6125                	addi	sp,sp,96
    80002c52:	8082                	ret
    sleep(p, &wait_lock); // DOC: wait-sleep
    80002c54:	85ea                	mv	a1,s10
    80002c56:	854a                	mv	a0,s2
    80002c58:	00000097          	auipc	ra,0x0
    80002c5c:	950080e7          	jalr	-1712(ra) # 800025a8 <sleep>
    havekids = 0;
    80002c60:	b721                	j	80002b68 <waitx+0x52>

0000000080002c62 <update_time>:

void update_time()
{
    80002c62:	7139                	addi	sp,sp,-64
    80002c64:	fc06                	sd	ra,56(sp)
    80002c66:	f822                	sd	s0,48(sp)
    80002c68:	f426                	sd	s1,40(sp)
    80002c6a:	f04a                	sd	s2,32(sp)
    80002c6c:	ec4e                	sd	s3,24(sp)
    80002c6e:	e852                	sd	s4,16(sp)
    80002c70:	e456                	sd	s5,8(sp)
    80002c72:	0080                	addi	s0,sp,64
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
    80002c74:	0022e497          	auipc	s1,0x22e
    80002c78:	3c448493          	addi	s1,s1,964 # 80231038 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING || p->state == SLEEPING || p->state == RUNNABLE)
    80002c7c:	4989                	li	s3,2
    {
      if (p->pid >= 4 && p->pid <= 13)
    80002c7e:	4a25                	li	s4,9
  for (p = proc; p < &proc[NPROC]; p++)
    80002c80:	00234917          	auipc	s2,0x234
    80002c84:	7b890913          	addi	s2,s2,1976 # 80237438 <tickslock>
    80002c88:	a005                	j	80002ca8 <update_time+0x46>
      if (p->pid >= 4 && p->pid <= 13)
    80002c8a:	589c                	lw	a5,48(s1)
    80002c8c:	37f1                	addiw	a5,a5,-4
    80002c8e:	00fa6463          	bltu	s4,a5,80002c96 <update_time+0x34>
        
        int RBI = (3.0 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
        RBI /= (p->dynamicrtime + p->dynamicstime + p->wtime + 1);
        if (RBI < 0)
          RBI = 0;
        p->defaultflag = 0;
    80002c92:	1804a423          	sw	zero,392(s1)
          DP = 100;

        // printf("%d %d %d\n", p->pid, ticks-1, DP);
      }
    }
    release(&p->lock);
    80002c96:	8526                	mv	a0,s1
    80002c98:	ffffe097          	auipc	ra,0xffffe
    80002c9c:	1d2080e7          	jalr	466(ra) # 80000e6a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002ca0:	19048493          	addi	s1,s1,400
    80002ca4:	01248c63          	beq	s1,s2,80002cbc <update_time+0x5a>
    acquire(&p->lock);
    80002ca8:	8526                	mv	a0,s1
    80002caa:	ffffe097          	auipc	ra,0xffffe
    80002cae:	10c080e7          	jalr	268(ra) # 80000db6 <acquire>
    if (p->state == RUNNING || p->state == SLEEPING || p->state == RUNNABLE)
    80002cb2:	4c9c                	lw	a5,24(s1)
    80002cb4:	37f9                	addiw	a5,a5,-2
    80002cb6:	fef9e0e3          	bltu	s3,a5,80002c96 <update_time+0x34>
    80002cba:	bfc1                	j	80002c8a <update_time+0x28>
  }
  for (p = proc; p < &proc[NPROC]; p++)
    80002cbc:	0022e497          	auipc	s1,0x22e
    80002cc0:	37c48493          	addi	s1,s1,892 # 80231038 <proc>
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    80002cc4:	4991                	li	s3,4
    {
      p->dynamicstime = 0;
      p->rtime++;
      p->dynamicrtime++;
    }
    if (p->state == SLEEPING)
    80002cc6:	4a09                	li	s4,2
    {
      p->dynamicrtime = 0;
      p->dynamicstime++;
    }
    if (p->state == RUNNABLE)
    80002cc8:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    80002cca:	00234917          	auipc	s2,0x234
    80002cce:	76e90913          	addi	s2,s2,1902 # 80237438 <tickslock>
    80002cd2:	a035                	j	80002cfe <update_time+0x9c>
      p->dynamicstime = 0;
    80002cd4:	1604ae23          	sw	zero,380(s1)
      p->rtime++;
    80002cd8:	1684a783          	lw	a5,360(s1)
    80002cdc:	2785                	addiw	a5,a5,1
    80002cde:	16f4a423          	sw	a5,360(s1)
      p->dynamicrtime++;
    80002ce2:	1744a783          	lw	a5,372(s1)
    80002ce6:	2785                	addiw	a5,a5,1
    80002ce8:	16f4aa23          	sw	a5,372(s1)
    {
      p->dynamicrtime = 0;
      p->wtime++;
    }
    release(&p->lock);
    80002cec:	8526                	mv	a0,s1
    80002cee:	ffffe097          	auipc	ra,0xffffe
    80002cf2:	17c080e7          	jalr	380(ra) # 80000e6a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002cf6:	19048493          	addi	s1,s1,400
    80002cfa:	03248e63          	beq	s1,s2,80002d36 <update_time+0xd4>
    acquire(&p->lock);
    80002cfe:	8526                	mv	a0,s1
    80002d00:	ffffe097          	auipc	ra,0xffffe
    80002d04:	0b6080e7          	jalr	182(ra) # 80000db6 <acquire>
    if (p->state == RUNNING)
    80002d08:	4c9c                	lw	a5,24(s1)
    80002d0a:	fd3785e3          	beq	a5,s3,80002cd4 <update_time+0x72>
    if (p->state == SLEEPING)
    80002d0e:	01479a63          	bne	a5,s4,80002d22 <update_time+0xc0>
      p->dynamicrtime = 0;
    80002d12:	1604aa23          	sw	zero,372(s1)
      p->dynamicstime++;
    80002d16:	17c4a783          	lw	a5,380(s1)
    80002d1a:	2785                	addiw	a5,a5,1
    80002d1c:	16f4ae23          	sw	a5,380(s1)
    if (p->state == RUNNABLE)
    80002d20:	b7f1                	j	80002cec <update_time+0x8a>
    80002d22:	fd5795e3          	bne	a5,s5,80002cec <update_time+0x8a>
      p->dynamicrtime = 0;
    80002d26:	1604aa23          	sw	zero,372(s1)
      p->wtime++;
    80002d2a:	1784a783          	lw	a5,376(s1)
    80002d2e:	2785                	addiw	a5,a5,1
    80002d30:	16f4ac23          	sw	a5,376(s1)
    80002d34:	bf65                	j	80002cec <update_time+0x8a>
  }
  for (p = proc; p < &proc[NPROC]; p++)
    80002d36:	0022e497          	auipc	s1,0x22e
    80002d3a:	30248493          	addi	s1,s1,770 # 80231038 <proc>
    80002d3e:	00234917          	auipc	s2,0x234
    80002d42:	6fa90913          	addi	s2,s2,1786 # 80237438 <tickslock>
  {
    acquire(&p->lock);
    80002d46:	8526                	mv	a0,s1
    80002d48:	ffffe097          	auipc	ra,0xffffe
    80002d4c:	06e080e7          	jalr	110(ra) # 80000db6 <acquire>
          DP = 100;

        // printf("%d %d %d\n", p->pid, ticks, DP);
      }
    }
    release(&p->lock);
    80002d50:	8526                	mv	a0,s1
    80002d52:	ffffe097          	auipc	ra,0xffffe
    80002d56:	118080e7          	jalr	280(ra) # 80000e6a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80002d5a:	19048493          	addi	s1,s1,400
    80002d5e:	ff2494e3          	bne	s1,s2,80002d46 <update_time+0xe4>
  }
    80002d62:	70e2                	ld	ra,56(sp)
    80002d64:	7442                	ld	s0,48(sp)
    80002d66:	74a2                	ld	s1,40(sp)
    80002d68:	7902                	ld	s2,32(sp)
    80002d6a:	69e2                	ld	s3,24(sp)
    80002d6c:	6a42                	ld	s4,16(sp)
    80002d6e:	6aa2                	ld	s5,8(sp)
    80002d70:	6121                	addi	sp,sp,64
    80002d72:	8082                	ret

0000000080002d74 <swtch>:
    80002d74:	00153023          	sd	ra,0(a0)
    80002d78:	00253423          	sd	sp,8(a0)
    80002d7c:	e900                	sd	s0,16(a0)
    80002d7e:	ed04                	sd	s1,24(a0)
    80002d80:	03253023          	sd	s2,32(a0)
    80002d84:	03353423          	sd	s3,40(a0)
    80002d88:	03453823          	sd	s4,48(a0)
    80002d8c:	03553c23          	sd	s5,56(a0)
    80002d90:	05653023          	sd	s6,64(a0)
    80002d94:	05753423          	sd	s7,72(a0)
    80002d98:	05853823          	sd	s8,80(a0)
    80002d9c:	05953c23          	sd	s9,88(a0)
    80002da0:	07a53023          	sd	s10,96(a0)
    80002da4:	07b53423          	sd	s11,104(a0)
    80002da8:	0005b083          	ld	ra,0(a1)
    80002dac:	0085b103          	ld	sp,8(a1)
    80002db0:	6980                	ld	s0,16(a1)
    80002db2:	6d84                	ld	s1,24(a1)
    80002db4:	0205b903          	ld	s2,32(a1)
    80002db8:	0285b983          	ld	s3,40(a1)
    80002dbc:	0305ba03          	ld	s4,48(a1)
    80002dc0:	0385ba83          	ld	s5,56(a1)
    80002dc4:	0405bb03          	ld	s6,64(a1)
    80002dc8:	0485bb83          	ld	s7,72(a1)
    80002dcc:	0505bc03          	ld	s8,80(a1)
    80002dd0:	0585bc83          	ld	s9,88(a1)
    80002dd4:	0605bd03          	ld	s10,96(a1)
    80002dd8:	0685bd83          	ld	s11,104(a1)
    80002ddc:	8082                	ret

0000000080002dde <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002dde:	1141                	addi	sp,sp,-16
    80002de0:	e406                	sd	ra,8(sp)
    80002de2:	e022                	sd	s0,0(sp)
    80002de4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002de6:	00005597          	auipc	a1,0x5
    80002dea:	56a58593          	addi	a1,a1,1386 # 80008350 <states.0+0x30>
    80002dee:	00234517          	auipc	a0,0x234
    80002df2:	64a50513          	addi	a0,a0,1610 # 80237438 <tickslock>
    80002df6:	ffffe097          	auipc	ra,0xffffe
    80002dfa:	f30080e7          	jalr	-208(ra) # 80000d26 <initlock>
}
    80002dfe:	60a2                	ld	ra,8(sp)
    80002e00:	6402                	ld	s0,0(sp)
    80002e02:	0141                	addi	sp,sp,16
    80002e04:	8082                	ret

0000000080002e06 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002e06:	1141                	addi	sp,sp,-16
    80002e08:	e422                	sd	s0,8(sp)
    80002e0a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e0c:	00003797          	auipc	a5,0x3
    80002e10:	77478793          	addi	a5,a5,1908 # 80006580 <kernelvec>
    80002e14:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002e18:	6422                	ld	s0,8(sp)
    80002e1a:	0141                	addi	sp,sp,16
    80002e1c:	8082                	ret

0000000080002e1e <usertrapret>:
}
//
// return to user space
//
void usertrapret(void)
{
    80002e1e:	1141                	addi	sp,sp,-16
    80002e20:	e406                	sd	ra,8(sp)
    80002e22:	e022                	sd	s0,0(sp)
    80002e24:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002e26:	fffff097          	auipc	ra,0xfffff
    80002e2a:	e52080e7          	jalr	-430(ra) # 80001c78 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e2e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002e32:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e34:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002e38:	00004617          	auipc	a2,0x4
    80002e3c:	1c860613          	addi	a2,a2,456 # 80007000 <_trampoline>
    80002e40:	00004697          	auipc	a3,0x4
    80002e44:	1c068693          	addi	a3,a3,448 # 80007000 <_trampoline>
    80002e48:	8e91                	sub	a3,a3,a2
    80002e4a:	040007b7          	lui	a5,0x4000
    80002e4e:	17fd                	addi	a5,a5,-1
    80002e50:	07b2                	slli	a5,a5,0xc
    80002e52:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e54:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002e58:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002e5a:	180026f3          	csrr	a3,satp
    80002e5e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002e60:	6d38                	ld	a4,88(a0)
    80002e62:	6134                	ld	a3,64(a0)
    80002e64:	6585                	lui	a1,0x1
    80002e66:	96ae                	add	a3,a3,a1
    80002e68:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002e6a:	6d38                	ld	a4,88(a0)
    80002e6c:	00000697          	auipc	a3,0x0
    80002e70:	13e68693          	addi	a3,a3,318 # 80002faa <usertrap>
    80002e74:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002e76:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002e78:	8692                	mv	a3,tp
    80002e7a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e7c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002e80:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002e84:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e88:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002e8c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e8e:	6f18                	ld	a4,24(a4)
    80002e90:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002e94:	6928                	ld	a0,80(a0)
    80002e96:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002e98:	00004717          	auipc	a4,0x4
    80002e9c:	20470713          	addi	a4,a4,516 # 8000709c <userret>
    80002ea0:	8f11                	sub	a4,a4,a2
    80002ea2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002ea4:	577d                	li	a4,-1
    80002ea6:	177e                	slli	a4,a4,0x3f
    80002ea8:	8d59                	or	a0,a0,a4
    80002eaa:	9782                	jalr	a5
}
    80002eac:	60a2                	ld	ra,8(sp)
    80002eae:	6402                	ld	s0,0(sp)
    80002eb0:	0141                	addi	sp,sp,16
    80002eb2:	8082                	ret

0000000080002eb4 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80002eb4:	1101                	addi	sp,sp,-32
    80002eb6:	ec06                	sd	ra,24(sp)
    80002eb8:	e822                	sd	s0,16(sp)
    80002eba:	e426                	sd	s1,8(sp)
    80002ebc:	e04a                	sd	s2,0(sp)
    80002ebe:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002ec0:	00234917          	auipc	s2,0x234
    80002ec4:	57890913          	addi	s2,s2,1400 # 80237438 <tickslock>
    80002ec8:	854a                	mv	a0,s2
    80002eca:	ffffe097          	auipc	ra,0xffffe
    80002ece:	eec080e7          	jalr	-276(ra) # 80000db6 <acquire>
  ticks++;
    80002ed2:	00006497          	auipc	s1,0x6
    80002ed6:	aae48493          	addi	s1,s1,-1362 # 80008980 <ticks>
    80002eda:	409c                	lw	a5,0(s1)
    80002edc:	2785                	addiw	a5,a5,1
    80002ede:	c09c                	sw	a5,0(s1)
  update_time();
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	d82080e7          	jalr	-638(ra) # 80002c62 <update_time>
  //   // {
  //   //   p->wtime++;
  //   // }
  //   release(&p->lock);
  // }
  wakeup(&ticks);
    80002ee8:	8526                	mv	a0,s1
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	722080e7          	jalr	1826(ra) # 8000260c <wakeup>
  release(&tickslock);
    80002ef2:	854a                	mv	a0,s2
    80002ef4:	ffffe097          	auipc	ra,0xffffe
    80002ef8:	f76080e7          	jalr	-138(ra) # 80000e6a <release>
}
    80002efc:	60e2                	ld	ra,24(sp)
    80002efe:	6442                	ld	s0,16(sp)
    80002f00:	64a2                	ld	s1,8(sp)
    80002f02:	6902                	ld	s2,0(sp)
    80002f04:	6105                	addi	sp,sp,32
    80002f06:	8082                	ret

0000000080002f08 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80002f08:	1101                	addi	sp,sp,-32
    80002f0a:	ec06                	sd	ra,24(sp)
    80002f0c:	e822                	sd	s0,16(sp)
    80002f0e:	e426                	sd	s1,8(sp)
    80002f10:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f12:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if ((scause & 0x8000000000000000L) &&
    80002f16:	00074d63          	bltz	a4,80002f30 <devintr+0x28>
    if (irq)
      plic_complete(irq);

    return 1;
  }
  else if (scause == 0x8000000000000001L)
    80002f1a:	57fd                	li	a5,-1
    80002f1c:	17fe                	slli	a5,a5,0x3f
    80002f1e:	0785                	addi	a5,a5,1

    return 2;
  }
  else
  {
    return 0;
    80002f20:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80002f22:	06f70363          	beq	a4,a5,80002f88 <devintr+0x80>
  }
}
    80002f26:	60e2                	ld	ra,24(sp)
    80002f28:	6442                	ld	s0,16(sp)
    80002f2a:	64a2                	ld	s1,8(sp)
    80002f2c:	6105                	addi	sp,sp,32
    80002f2e:	8082                	ret
      (scause & 0xff) == 9)
    80002f30:	0ff77793          	andi	a5,a4,255
  if ((scause & 0x8000000000000000L) &&
    80002f34:	46a5                	li	a3,9
    80002f36:	fed792e3          	bne	a5,a3,80002f1a <devintr+0x12>
    int irq = plic_claim();
    80002f3a:	00003097          	auipc	ra,0x3
    80002f3e:	74e080e7          	jalr	1870(ra) # 80006688 <plic_claim>
    80002f42:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80002f44:	47a9                	li	a5,10
    80002f46:	02f50763          	beq	a0,a5,80002f74 <devintr+0x6c>
    else if (irq == VIRTIO0_IRQ)
    80002f4a:	4785                	li	a5,1
    80002f4c:	02f50963          	beq	a0,a5,80002f7e <devintr+0x76>
    return 1;
    80002f50:	4505                	li	a0,1
    else if (irq)
    80002f52:	d8f1                	beqz	s1,80002f26 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80002f54:	85a6                	mv	a1,s1
    80002f56:	00005517          	auipc	a0,0x5
    80002f5a:	40250513          	addi	a0,a0,1026 # 80008358 <states.0+0x38>
    80002f5e:	ffffd097          	auipc	ra,0xffffd
    80002f62:	62a080e7          	jalr	1578(ra) # 80000588 <printf>
      plic_complete(irq);
    80002f66:	8526                	mv	a0,s1
    80002f68:	00003097          	auipc	ra,0x3
    80002f6c:	744080e7          	jalr	1860(ra) # 800066ac <plic_complete>
    return 1;
    80002f70:	4505                	li	a0,1
    80002f72:	bf55                	j	80002f26 <devintr+0x1e>
      uartintr();
    80002f74:	ffffe097          	auipc	ra,0xffffe
    80002f78:	a26080e7          	jalr	-1498(ra) # 8000099a <uartintr>
    80002f7c:	b7ed                	j	80002f66 <devintr+0x5e>
      virtio_disk_intr();
    80002f7e:	00004097          	auipc	ra,0x4
    80002f82:	bfa080e7          	jalr	-1030(ra) # 80006b78 <virtio_disk_intr>
    80002f86:	b7c5                	j	80002f66 <devintr+0x5e>
    if (cpuid() == 0)
    80002f88:	fffff097          	auipc	ra,0xfffff
    80002f8c:	cc4080e7          	jalr	-828(ra) # 80001c4c <cpuid>
    80002f90:	c901                	beqz	a0,80002fa0 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002f92:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002f96:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002f98:	14479073          	csrw	sip,a5
    return 2;
    80002f9c:	4509                	li	a0,2
    80002f9e:	b761                	j	80002f26 <devintr+0x1e>
      clockintr();
    80002fa0:	00000097          	auipc	ra,0x0
    80002fa4:	f14080e7          	jalr	-236(ra) # 80002eb4 <clockintr>
    80002fa8:	b7ed                	j	80002f92 <devintr+0x8a>

0000000080002faa <usertrap>:
{
    80002faa:	7139                	addi	sp,sp,-64
    80002fac:	fc06                	sd	ra,56(sp)
    80002fae:	f822                	sd	s0,48(sp)
    80002fb0:	f426                	sd	s1,40(sp)
    80002fb2:	f04a                	sd	s2,32(sp)
    80002fb4:	ec4e                	sd	s3,24(sp)
    80002fb6:	e852                	sd	s4,16(sp)
    80002fb8:	e456                	sd	s5,8(sp)
    80002fba:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002fbc:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002fc0:	1007f793          	andi	a5,a5,256
    80002fc4:	efa5                	bnez	a5,8000303c <usertrap+0x92>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002fc6:	00003797          	auipc	a5,0x3
    80002fca:	5ba78793          	addi	a5,a5,1466 # 80006580 <kernelvec>
    80002fce:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002fd2:	fffff097          	auipc	ra,0xfffff
    80002fd6:	ca6080e7          	jalr	-858(ra) # 80001c78 <myproc>
    80002fda:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002fdc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002fde:	14102773          	csrr	a4,sepc
    80002fe2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fe4:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80002fe8:	47a1                	li	a5,8
    80002fea:	06f70163          	beq	a4,a5,8000304c <usertrap+0xa2>
    80002fee:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80002ff2:	47bd                	li	a5,15
    80002ff4:	12f71b63          	bne	a4,a5,8000312a <usertrap+0x180>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ff8:	14302773          	csrr	a4,stval
    if (r_stval() >= MAXVA || r_stval() <= 0)
    80002ffc:	57fd                	li	a5,-1
    80002ffe:	83e9                	srli	a5,a5,0x1a
    80003000:	00e7e563          	bltu	a5,a4,8000300a <usertrap+0x60>
    80003004:	143027f3          	csrr	a5,stval
    80003008:	efa5                	bnez	a5,80003080 <usertrap+0xd6>
      setkilled(p);
    8000300a:	8526                	mv	a0,s1
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	824080e7          	jalr	-2012(ra) # 80002830 <setkilled>
  if (killed(p))
    80003014:	8526                	mv	a0,s1
    80003016:	00000097          	auipc	ra,0x0
    8000301a:	846080e7          	jalr	-1978(ra) # 8000285c <killed>
    8000301e:	16051063          	bnez	a0,8000317e <usertrap+0x1d4>
  usertrapret();
    80003022:	00000097          	auipc	ra,0x0
    80003026:	dfc080e7          	jalr	-516(ra) # 80002e1e <usertrapret>
}
    8000302a:	70e2                	ld	ra,56(sp)
    8000302c:	7442                	ld	s0,48(sp)
    8000302e:	74a2                	ld	s1,40(sp)
    80003030:	7902                	ld	s2,32(sp)
    80003032:	69e2                	ld	s3,24(sp)
    80003034:	6a42                	ld	s4,16(sp)
    80003036:	6aa2                	ld	s5,8(sp)
    80003038:	6121                	addi	sp,sp,64
    8000303a:	8082                	ret
    panic("usertrap: not from user mode");
    8000303c:	00005517          	auipc	a0,0x5
    80003040:	33c50513          	addi	a0,a0,828 # 80008378 <states.0+0x58>
    80003044:	ffffd097          	auipc	ra,0xffffd
    80003048:	4fa080e7          	jalr	1274(ra) # 8000053e <panic>
    if (killed(p))
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	810080e7          	jalr	-2032(ra) # 8000285c <killed>
    80003054:	e105                	bnez	a0,80003074 <usertrap+0xca>
    p->trapframe->epc += 4;
    80003056:	6cb8                	ld	a4,88(s1)
    80003058:	6f1c                	ld	a5,24(a4)
    8000305a:	0791                	addi	a5,a5,4
    8000305c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000305e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003062:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003066:	10079073          	csrw	sstatus,a5
    syscall();
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	37a080e7          	jalr	890(ra) # 800033e4 <syscall>
    80003072:	b74d                	j	80003014 <usertrap+0x6a>
      exit(-1);
    80003074:	557d                	li	a0,-1
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	666080e7          	jalr	1638(ra) # 800026dc <exit>
    8000307e:	bfe1                	j	80003056 <usertrap+0xac>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003080:	143025f3          	csrr	a1,stval
      pte = walk(p->pagetable, start_va, 0);
    80003084:	4601                	li	a2,0
    80003086:	77fd                	lui	a5,0xfffff
    80003088:	8dfd                	and	a1,a1,a5
    8000308a:	6928                	ld	a0,80(a0)
    8000308c:	ffffe097          	auipc	ra,0xffffe
    80003090:	10a080e7          	jalr	266(ra) # 80001196 <walk>
    80003094:	892a                	mv	s2,a0
      if (pte == 0)
    80003096:	c921                	beqz	a0,800030e6 <usertrap+0x13c>
        if (*pte & PTE_RSW)
    80003098:	00053a03          	ld	s4,0(a0)
    8000309c:	100a7793          	andi	a5,s4,256
    800030a0:	c7bd                	beqz	a5,8000310e <usertrap+0x164>
          char *mem = kalloc();
    800030a2:	ffffe097          	auipc	ra,0xffffe
    800030a6:	c10080e7          	jalr	-1008(ra) # 80000cb2 <kalloc>
    800030aa:	89aa                	mv	s3,a0
          if (mem == 0)
    800030ac:	c939                	beqz	a0,80003102 <usertrap+0x158>
            char *pa = (char *)PTE2PA(*pte);
    800030ae:	00093a83          	ld	s5,0(s2)
    800030b2:	00aada93          	srli	s5,s5,0xa
    800030b6:	0ab2                	slli	s5,s5,0xc
            memmove(mem, pa, PGSIZE);
    800030b8:	6605                	lui	a2,0x1
    800030ba:	85d6                	mv	a1,s5
    800030bc:	ffffe097          	auipc	ra,0xffffe
    800030c0:	e52080e7          	jalr	-430(ra) # 80000f0e <memmove>
            kfree((void *)pa);
    800030c4:	8556                	mv	a0,s5
    800030c6:	ffffe097          	auipc	ra,0xffffe
    800030ca:	a32080e7          	jalr	-1486(ra) # 80000af8 <kfree>
            *pte = PA2PTE(mem) | flags;
    800030ce:	00c9d793          	srli	a5,s3,0xc
    800030d2:	07aa                	slli	a5,a5,0xa
          flags &= (~PTE_RSW);
    800030d4:	2ffa7a13          	andi	s4,s4,767
            *pte = PA2PTE(mem) | flags;
    800030d8:	004a6a13          	ori	s4,s4,4
    800030dc:	0147e7b3          	or	a5,a5,s4
    800030e0:	00f93023          	sd	a5,0(s2)
    800030e4:	bf05                	j	80003014 <usertrap+0x6a>
        printf("page not found\n");
    800030e6:	00005517          	auipc	a0,0x5
    800030ea:	2b250513          	addi	a0,a0,690 # 80008398 <states.0+0x78>
    800030ee:	ffffd097          	auipc	ra,0xffffd
    800030f2:	49a080e7          	jalr	1178(ra) # 80000588 <printf>
        setkilled(p);
    800030f6:	8526                	mv	a0,s1
    800030f8:	fffff097          	auipc	ra,0xfffff
    800030fc:	738080e7          	jalr	1848(ra) # 80002830 <setkilled>
    80003100:	bf11                	j	80003014 <usertrap+0x6a>
            setkilled(p);
    80003102:	8526                	mv	a0,s1
    80003104:	fffff097          	auipc	ra,0xfffff
    80003108:	72c080e7          	jalr	1836(ra) # 80002830 <setkilled>
    8000310c:	b721                	j	80003014 <usertrap+0x6a>
          printf("page not found\n");
    8000310e:	00005517          	auipc	a0,0x5
    80003112:	28a50513          	addi	a0,a0,650 # 80008398 <states.0+0x78>
    80003116:	ffffd097          	auipc	ra,0xffffd
    8000311a:	472080e7          	jalr	1138(ra) # 80000588 <printf>
          setkilled(p);
    8000311e:	8526                	mv	a0,s1
    80003120:	fffff097          	auipc	ra,0xfffff
    80003124:	710080e7          	jalr	1808(ra) # 80002830 <setkilled>
    80003128:	b5f5                	j	80003014 <usertrap+0x6a>
  else if ((which_dev = devintr()) != 0)
    8000312a:	00000097          	auipc	ra,0x0
    8000312e:	dde080e7          	jalr	-546(ra) # 80002f08 <devintr>
    80003132:	892a                	mv	s2,a0
    80003134:	c901                	beqz	a0,80003144 <usertrap+0x19a>
  if (killed(p))
    80003136:	8526                	mv	a0,s1
    80003138:	fffff097          	auipc	ra,0xfffff
    8000313c:	724080e7          	jalr	1828(ra) # 8000285c <killed>
    80003140:	c529                	beqz	a0,8000318a <usertrap+0x1e0>
    80003142:	a83d                	j	80003180 <usertrap+0x1d6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003144:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003148:	5890                	lw	a2,48(s1)
    8000314a:	00005517          	auipc	a0,0x5
    8000314e:	25e50513          	addi	a0,a0,606 # 800083a8 <states.0+0x88>
    80003152:	ffffd097          	auipc	ra,0xffffd
    80003156:	436080e7          	jalr	1078(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000315a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000315e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003162:	00005517          	auipc	a0,0x5
    80003166:	27650513          	addi	a0,a0,630 # 800083d8 <states.0+0xb8>
    8000316a:	ffffd097          	auipc	ra,0xffffd
    8000316e:	41e080e7          	jalr	1054(ra) # 80000588 <printf>
    setkilled(p);
    80003172:	8526                	mv	a0,s1
    80003174:	fffff097          	auipc	ra,0xfffff
    80003178:	6bc080e7          	jalr	1724(ra) # 80002830 <setkilled>
    8000317c:	bd61                	j	80003014 <usertrap+0x6a>
  if (killed(p))
    8000317e:	4901                	li	s2,0
    exit(-1);
    80003180:	557d                	li	a0,-1
    80003182:	fffff097          	auipc	ra,0xfffff
    80003186:	55a080e7          	jalr	1370(ra) # 800026dc <exit>
  if (which_dev == 2)
    8000318a:	4789                	li	a5,2
    8000318c:	e8f91be3          	bne	s2,a5,80003022 <usertrap+0x78>
    yield();
    80003190:	fffff097          	auipc	ra,0xfffff
    80003194:	3dc080e7          	jalr	988(ra) # 8000256c <yield>
    80003198:	b569                	j	80003022 <usertrap+0x78>

000000008000319a <kerneltrap>:
{
    8000319a:	7179                	addi	sp,sp,-48
    8000319c:	f406                	sd	ra,40(sp)
    8000319e:	f022                	sd	s0,32(sp)
    800031a0:	ec26                	sd	s1,24(sp)
    800031a2:	e84a                	sd	s2,16(sp)
    800031a4:	e44e                	sd	s3,8(sp)
    800031a6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031a8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800031ac:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031b0:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    800031b4:	1004f793          	andi	a5,s1,256
    800031b8:	cb85                	beqz	a5,800031e8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800031ba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800031be:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800031c0:	ef85                	bnez	a5,800031f8 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    800031c2:	00000097          	auipc	ra,0x0
    800031c6:	d46080e7          	jalr	-698(ra) # 80002f08 <devintr>
    800031ca:	cd1d                	beqz	a0,80003208 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800031cc:	4789                	li	a5,2
    800031ce:	06f50a63          	beq	a0,a5,80003242 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800031d2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800031d6:	10049073          	csrw	sstatus,s1
}
    800031da:	70a2                	ld	ra,40(sp)
    800031dc:	7402                	ld	s0,32(sp)
    800031de:	64e2                	ld	s1,24(sp)
    800031e0:	6942                	ld	s2,16(sp)
    800031e2:	69a2                	ld	s3,8(sp)
    800031e4:	6145                	addi	sp,sp,48
    800031e6:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800031e8:	00005517          	auipc	a0,0x5
    800031ec:	21050513          	addi	a0,a0,528 # 800083f8 <states.0+0xd8>
    800031f0:	ffffd097          	auipc	ra,0xffffd
    800031f4:	34e080e7          	jalr	846(ra) # 8000053e <panic>
    panic("kerneltrap: interrupts enabled");
    800031f8:	00005517          	auipc	a0,0x5
    800031fc:	22850513          	addi	a0,a0,552 # 80008420 <states.0+0x100>
    80003200:	ffffd097          	auipc	ra,0xffffd
    80003204:	33e080e7          	jalr	830(ra) # 8000053e <panic>
    printf("scause %p\n", scause);
    80003208:	85ce                	mv	a1,s3
    8000320a:	00005517          	auipc	a0,0x5
    8000320e:	23650513          	addi	a0,a0,566 # 80008440 <states.0+0x120>
    80003212:	ffffd097          	auipc	ra,0xffffd
    80003216:	376080e7          	jalr	886(ra) # 80000588 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000321a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000321e:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003222:	00005517          	auipc	a0,0x5
    80003226:	22e50513          	addi	a0,a0,558 # 80008450 <states.0+0x130>
    8000322a:	ffffd097          	auipc	ra,0xffffd
    8000322e:	35e080e7          	jalr	862(ra) # 80000588 <printf>
    panic("kerneltrap");
    80003232:	00005517          	auipc	a0,0x5
    80003236:	23650513          	addi	a0,a0,566 # 80008468 <states.0+0x148>
    8000323a:	ffffd097          	auipc	ra,0xffffd
    8000323e:	304080e7          	jalr	772(ra) # 8000053e <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003242:	fffff097          	auipc	ra,0xfffff
    80003246:	a36080e7          	jalr	-1482(ra) # 80001c78 <myproc>
    8000324a:	d541                	beqz	a0,800031d2 <kerneltrap+0x38>
    8000324c:	fffff097          	auipc	ra,0xfffff
    80003250:	a2c080e7          	jalr	-1492(ra) # 80001c78 <myproc>
    80003254:	4d18                	lw	a4,24(a0)
    80003256:	4791                	li	a5,4
    80003258:	f6f71de3          	bne	a4,a5,800031d2 <kerneltrap+0x38>
    yield();
    8000325c:	fffff097          	auipc	ra,0xfffff
    80003260:	310080e7          	jalr	784(ra) # 8000256c <yield>
    80003264:	b7bd                	j	800031d2 <kerneltrap+0x38>

0000000080003266 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003266:	1101                	addi	sp,sp,-32
    80003268:	ec06                	sd	ra,24(sp)
    8000326a:	e822                	sd	s0,16(sp)
    8000326c:	e426                	sd	s1,8(sp)
    8000326e:	1000                	addi	s0,sp,32
    80003270:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003272:	fffff097          	auipc	ra,0xfffff
    80003276:	a06080e7          	jalr	-1530(ra) # 80001c78 <myproc>
  switch (n) {
    8000327a:	4795                	li	a5,5
    8000327c:	0497e163          	bltu	a5,s1,800032be <argraw+0x58>
    80003280:	048a                	slli	s1,s1,0x2
    80003282:	00005717          	auipc	a4,0x5
    80003286:	21e70713          	addi	a4,a4,542 # 800084a0 <states.0+0x180>
    8000328a:	94ba                	add	s1,s1,a4
    8000328c:	409c                	lw	a5,0(s1)
    8000328e:	97ba                	add	a5,a5,a4
    80003290:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003292:	6d3c                	ld	a5,88(a0)
    80003294:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003296:	60e2                	ld	ra,24(sp)
    80003298:	6442                	ld	s0,16(sp)
    8000329a:	64a2                	ld	s1,8(sp)
    8000329c:	6105                	addi	sp,sp,32
    8000329e:	8082                	ret
    return p->trapframe->a1;
    800032a0:	6d3c                	ld	a5,88(a0)
    800032a2:	7fa8                	ld	a0,120(a5)
    800032a4:	bfcd                	j	80003296 <argraw+0x30>
    return p->trapframe->a2;
    800032a6:	6d3c                	ld	a5,88(a0)
    800032a8:	63c8                	ld	a0,128(a5)
    800032aa:	b7f5                	j	80003296 <argraw+0x30>
    return p->trapframe->a3;
    800032ac:	6d3c                	ld	a5,88(a0)
    800032ae:	67c8                	ld	a0,136(a5)
    800032b0:	b7dd                	j	80003296 <argraw+0x30>
    return p->trapframe->a4;
    800032b2:	6d3c                	ld	a5,88(a0)
    800032b4:	6bc8                	ld	a0,144(a5)
    800032b6:	b7c5                	j	80003296 <argraw+0x30>
    return p->trapframe->a5;
    800032b8:	6d3c                	ld	a5,88(a0)
    800032ba:	6fc8                	ld	a0,152(a5)
    800032bc:	bfe9                	j	80003296 <argraw+0x30>
  panic("argraw");
    800032be:	00005517          	auipc	a0,0x5
    800032c2:	1ba50513          	addi	a0,a0,442 # 80008478 <states.0+0x158>
    800032c6:	ffffd097          	auipc	ra,0xffffd
    800032ca:	278080e7          	jalr	632(ra) # 8000053e <panic>

00000000800032ce <fetchaddr>:
{
    800032ce:	1101                	addi	sp,sp,-32
    800032d0:	ec06                	sd	ra,24(sp)
    800032d2:	e822                	sd	s0,16(sp)
    800032d4:	e426                	sd	s1,8(sp)
    800032d6:	e04a                	sd	s2,0(sp)
    800032d8:	1000                	addi	s0,sp,32
    800032da:	84aa                	mv	s1,a0
    800032dc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800032de:	fffff097          	auipc	ra,0xfffff
    800032e2:	99a080e7          	jalr	-1638(ra) # 80001c78 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800032e6:	653c                	ld	a5,72(a0)
    800032e8:	02f4f863          	bgeu	s1,a5,80003318 <fetchaddr+0x4a>
    800032ec:	00848713          	addi	a4,s1,8
    800032f0:	02e7e663          	bltu	a5,a4,8000331c <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800032f4:	46a1                	li	a3,8
    800032f6:	8626                	mv	a2,s1
    800032f8:	85ca                	mv	a1,s2
    800032fa:	6928                	ld	a0,80(a0)
    800032fc:	ffffe097          	auipc	ra,0xffffe
    80003300:	6c4080e7          	jalr	1732(ra) # 800019c0 <copyin>
    80003304:	00a03533          	snez	a0,a0
    80003308:	40a00533          	neg	a0,a0
}
    8000330c:	60e2                	ld	ra,24(sp)
    8000330e:	6442                	ld	s0,16(sp)
    80003310:	64a2                	ld	s1,8(sp)
    80003312:	6902                	ld	s2,0(sp)
    80003314:	6105                	addi	sp,sp,32
    80003316:	8082                	ret
    return -1;
    80003318:	557d                	li	a0,-1
    8000331a:	bfcd                	j	8000330c <fetchaddr+0x3e>
    8000331c:	557d                	li	a0,-1
    8000331e:	b7fd                	j	8000330c <fetchaddr+0x3e>

0000000080003320 <fetchstr>:
{
    80003320:	7179                	addi	sp,sp,-48
    80003322:	f406                	sd	ra,40(sp)
    80003324:	f022                	sd	s0,32(sp)
    80003326:	ec26                	sd	s1,24(sp)
    80003328:	e84a                	sd	s2,16(sp)
    8000332a:	e44e                	sd	s3,8(sp)
    8000332c:	1800                	addi	s0,sp,48
    8000332e:	892a                	mv	s2,a0
    80003330:	84ae                	mv	s1,a1
    80003332:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003334:	fffff097          	auipc	ra,0xfffff
    80003338:	944080e7          	jalr	-1724(ra) # 80001c78 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000333c:	86ce                	mv	a3,s3
    8000333e:	864a                	mv	a2,s2
    80003340:	85a6                	mv	a1,s1
    80003342:	6928                	ld	a0,80(a0)
    80003344:	ffffe097          	auipc	ra,0xffffe
    80003348:	70a080e7          	jalr	1802(ra) # 80001a4e <copyinstr>
    8000334c:	00054e63          	bltz	a0,80003368 <fetchstr+0x48>
  return strlen(buf);
    80003350:	8526                	mv	a0,s1
    80003352:	ffffe097          	auipc	ra,0xffffe
    80003356:	cdc080e7          	jalr	-804(ra) # 8000102e <strlen>
}
    8000335a:	70a2                	ld	ra,40(sp)
    8000335c:	7402                	ld	s0,32(sp)
    8000335e:	64e2                	ld	s1,24(sp)
    80003360:	6942                	ld	s2,16(sp)
    80003362:	69a2                	ld	s3,8(sp)
    80003364:	6145                	addi	sp,sp,48
    80003366:	8082                	ret
    return -1;
    80003368:	557d                	li	a0,-1
    8000336a:	bfc5                	j	8000335a <fetchstr+0x3a>

000000008000336c <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000336c:	1101                	addi	sp,sp,-32
    8000336e:	ec06                	sd	ra,24(sp)
    80003370:	e822                	sd	s0,16(sp)
    80003372:	e426                	sd	s1,8(sp)
    80003374:	1000                	addi	s0,sp,32
    80003376:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	eee080e7          	jalr	-274(ra) # 80003266 <argraw>
    80003380:	c088                	sw	a0,0(s1)
}
    80003382:	60e2                	ld	ra,24(sp)
    80003384:	6442                	ld	s0,16(sp)
    80003386:	64a2                	ld	s1,8(sp)
    80003388:	6105                	addi	sp,sp,32
    8000338a:	8082                	ret

000000008000338c <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000338c:	1101                	addi	sp,sp,-32
    8000338e:	ec06                	sd	ra,24(sp)
    80003390:	e822                	sd	s0,16(sp)
    80003392:	e426                	sd	s1,8(sp)
    80003394:	1000                	addi	s0,sp,32
    80003396:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003398:	00000097          	auipc	ra,0x0
    8000339c:	ece080e7          	jalr	-306(ra) # 80003266 <argraw>
    800033a0:	e088                	sd	a0,0(s1)
}
    800033a2:	60e2                	ld	ra,24(sp)
    800033a4:	6442                	ld	s0,16(sp)
    800033a6:	64a2                	ld	s1,8(sp)
    800033a8:	6105                	addi	sp,sp,32
    800033aa:	8082                	ret

00000000800033ac <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800033ac:	7179                	addi	sp,sp,-48
    800033ae:	f406                	sd	ra,40(sp)
    800033b0:	f022                	sd	s0,32(sp)
    800033b2:	ec26                	sd	s1,24(sp)
    800033b4:	e84a                	sd	s2,16(sp)
    800033b6:	1800                	addi	s0,sp,48
    800033b8:	84ae                	mv	s1,a1
    800033ba:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800033bc:	fd840593          	addi	a1,s0,-40
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	fcc080e7          	jalr	-52(ra) # 8000338c <argaddr>
  return fetchstr(addr, buf, max);
    800033c8:	864a                	mv	a2,s2
    800033ca:	85a6                	mv	a1,s1
    800033cc:	fd843503          	ld	a0,-40(s0)
    800033d0:	00000097          	auipc	ra,0x0
    800033d4:	f50080e7          	jalr	-176(ra) # 80003320 <fetchstr>
}
    800033d8:	70a2                	ld	ra,40(sp)
    800033da:	7402                	ld	s0,32(sp)
    800033dc:	64e2                	ld	s1,24(sp)
    800033de:	6942                	ld	s2,16(sp)
    800033e0:	6145                	addi	sp,sp,48
    800033e2:	8082                	ret

00000000800033e4 <syscall>:
[SYS_set_priority] sys_set_priority,
};

void
syscall(void)
{
    800033e4:	1101                	addi	sp,sp,-32
    800033e6:	ec06                	sd	ra,24(sp)
    800033e8:	e822                	sd	s0,16(sp)
    800033ea:	e426                	sd	s1,8(sp)
    800033ec:	e04a                	sd	s2,0(sp)
    800033ee:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	888080e7          	jalr	-1912(ra) # 80001c78 <myproc>
    800033f8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800033fa:	05853903          	ld	s2,88(a0)
    800033fe:	0a893783          	ld	a5,168(s2)
    80003402:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003406:	37fd                	addiw	a5,a5,-1
    80003408:	475d                	li	a4,23
    8000340a:	00f76f63          	bltu	a4,a5,80003428 <syscall+0x44>
    8000340e:	00369713          	slli	a4,a3,0x3
    80003412:	00005797          	auipc	a5,0x5
    80003416:	0a678793          	addi	a5,a5,166 # 800084b8 <syscalls>
    8000341a:	97ba                	add	a5,a5,a4
    8000341c:	639c                	ld	a5,0(a5)
    8000341e:	c789                	beqz	a5,80003428 <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003420:	9782                	jalr	a5
    80003422:	06a93823          	sd	a0,112(s2)
    80003426:	a839                	j	80003444 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003428:	15848613          	addi	a2,s1,344
    8000342c:	588c                	lw	a1,48(s1)
    8000342e:	00005517          	auipc	a0,0x5
    80003432:	05250513          	addi	a0,a0,82 # 80008480 <states.0+0x160>
    80003436:	ffffd097          	auipc	ra,0xffffd
    8000343a:	152080e7          	jalr	338(ra) # 80000588 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000343e:	6cbc                	ld	a5,88(s1)
    80003440:	577d                	li	a4,-1
    80003442:	fbb8                	sd	a4,112(a5)
  }
}
    80003444:	60e2                	ld	ra,24(sp)
    80003446:	6442                	ld	s0,16(sp)
    80003448:	64a2                	ld	s1,8(sp)
    8000344a:	6902                	ld	s2,0(sp)
    8000344c:	6105                	addi	sp,sp,32
    8000344e:	8082                	ret

0000000080003450 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80003450:	1101                	addi	sp,sp,-32
    80003452:	ec06                	sd	ra,24(sp)
    80003454:	e822                	sd	s0,16(sp)
    80003456:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003458:	fec40593          	addi	a1,s0,-20
    8000345c:	4501                	li	a0,0
    8000345e:	00000097          	auipc	ra,0x0
    80003462:	f0e080e7          	jalr	-242(ra) # 8000336c <argint>
  exit(n);
    80003466:	fec42503          	lw	a0,-20(s0)
    8000346a:	fffff097          	auipc	ra,0xfffff
    8000346e:	272080e7          	jalr	626(ra) # 800026dc <exit>
  return 0; // not reached
}
    80003472:	4501                	li	a0,0
    80003474:	60e2                	ld	ra,24(sp)
    80003476:	6442                	ld	s0,16(sp)
    80003478:	6105                	addi	sp,sp,32
    8000347a:	8082                	ret

000000008000347c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000347c:	1141                	addi	sp,sp,-16
    8000347e:	e406                	sd	ra,8(sp)
    80003480:	e022                	sd	s0,0(sp)
    80003482:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003484:	ffffe097          	auipc	ra,0xffffe
    80003488:	7f4080e7          	jalr	2036(ra) # 80001c78 <myproc>
}
    8000348c:	5908                	lw	a0,48(a0)
    8000348e:	60a2                	ld	ra,8(sp)
    80003490:	6402                	ld	s0,0(sp)
    80003492:	0141                	addi	sp,sp,16
    80003494:	8082                	ret

0000000080003496 <sys_fork>:

uint64
sys_fork(void)
{
    80003496:	1141                	addi	sp,sp,-16
    80003498:	e406                	sd	ra,8(sp)
    8000349a:	e022                	sd	s0,0(sp)
    8000349c:	0800                	addi	s0,sp,16
  return fork();
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	bc4080e7          	jalr	-1084(ra) # 80002062 <fork>
}
    800034a6:	60a2                	ld	ra,8(sp)
    800034a8:	6402                	ld	s0,0(sp)
    800034aa:	0141                	addi	sp,sp,16
    800034ac:	8082                	ret

00000000800034ae <sys_wait>:

uint64
sys_wait(void)
{
    800034ae:	1101                	addi	sp,sp,-32
    800034b0:	ec06                	sd	ra,24(sp)
    800034b2:	e822                	sd	s0,16(sp)
    800034b4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800034b6:	fe840593          	addi	a1,s0,-24
    800034ba:	4501                	li	a0,0
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	ed0080e7          	jalr	-304(ra) # 8000338c <argaddr>
  return wait(p);
    800034c4:	fe843503          	ld	a0,-24(s0)
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	3c6080e7          	jalr	966(ra) # 8000288e <wait>
}
    800034d0:	60e2                	ld	ra,24(sp)
    800034d2:	6442                	ld	s0,16(sp)
    800034d4:	6105                	addi	sp,sp,32
    800034d6:	8082                	ret

00000000800034d8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800034d8:	7179                	addi	sp,sp,-48
    800034da:	f406                	sd	ra,40(sp)
    800034dc:	f022                	sd	s0,32(sp)
    800034de:	ec26                	sd	s1,24(sp)
    800034e0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800034e2:	fdc40593          	addi	a1,s0,-36
    800034e6:	4501                	li	a0,0
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	e84080e7          	jalr	-380(ra) # 8000336c <argint>
  addr = myproc()->sz;
    800034f0:	ffffe097          	auipc	ra,0xffffe
    800034f4:	788080e7          	jalr	1928(ra) # 80001c78 <myproc>
    800034f8:	6524                	ld	s1,72(a0)
  if (growproc(n) < 0)
    800034fa:	fdc42503          	lw	a0,-36(s0)
    800034fe:	fffff097          	auipc	ra,0xfffff
    80003502:	b08080e7          	jalr	-1272(ra) # 80002006 <growproc>
    80003506:	00054863          	bltz	a0,80003516 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000350a:	8526                	mv	a0,s1
    8000350c:	70a2                	ld	ra,40(sp)
    8000350e:	7402                	ld	s0,32(sp)
    80003510:	64e2                	ld	s1,24(sp)
    80003512:	6145                	addi	sp,sp,48
    80003514:	8082                	ret
    return -1;
    80003516:	54fd                	li	s1,-1
    80003518:	bfcd                	j	8000350a <sys_sbrk+0x32>

000000008000351a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000351a:	7139                	addi	sp,sp,-64
    8000351c:	fc06                	sd	ra,56(sp)
    8000351e:	f822                	sd	s0,48(sp)
    80003520:	f426                	sd	s1,40(sp)
    80003522:	f04a                	sd	s2,32(sp)
    80003524:	ec4e                	sd	s3,24(sp)
    80003526:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003528:	fcc40593          	addi	a1,s0,-52
    8000352c:	4501                	li	a0,0
    8000352e:	00000097          	auipc	ra,0x0
    80003532:	e3e080e7          	jalr	-450(ra) # 8000336c <argint>
  acquire(&tickslock);
    80003536:	00234517          	auipc	a0,0x234
    8000353a:	f0250513          	addi	a0,a0,-254 # 80237438 <tickslock>
    8000353e:	ffffe097          	auipc	ra,0xffffe
    80003542:	878080e7          	jalr	-1928(ra) # 80000db6 <acquire>
  ticks0 = ticks;
    80003546:	00005917          	auipc	s2,0x5
    8000354a:	43a92903          	lw	s2,1082(s2) # 80008980 <ticks>
  while (ticks - ticks0 < n)
    8000354e:	fcc42783          	lw	a5,-52(s0)
    80003552:	cf9d                	beqz	a5,80003590 <sys_sleep+0x76>
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003554:	00234997          	auipc	s3,0x234
    80003558:	ee498993          	addi	s3,s3,-284 # 80237438 <tickslock>
    8000355c:	00005497          	auipc	s1,0x5
    80003560:	42448493          	addi	s1,s1,1060 # 80008980 <ticks>
    if (killed(myproc()))
    80003564:	ffffe097          	auipc	ra,0xffffe
    80003568:	714080e7          	jalr	1812(ra) # 80001c78 <myproc>
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	2f0080e7          	jalr	752(ra) # 8000285c <killed>
    80003574:	ed15                	bnez	a0,800035b0 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80003576:	85ce                	mv	a1,s3
    80003578:	8526                	mv	a0,s1
    8000357a:	fffff097          	auipc	ra,0xfffff
    8000357e:	02e080e7          	jalr	46(ra) # 800025a8 <sleep>
  while (ticks - ticks0 < n)
    80003582:	409c                	lw	a5,0(s1)
    80003584:	412787bb          	subw	a5,a5,s2
    80003588:	fcc42703          	lw	a4,-52(s0)
    8000358c:	fce7ece3          	bltu	a5,a4,80003564 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80003590:	00234517          	auipc	a0,0x234
    80003594:	ea850513          	addi	a0,a0,-344 # 80237438 <tickslock>
    80003598:	ffffe097          	auipc	ra,0xffffe
    8000359c:	8d2080e7          	jalr	-1838(ra) # 80000e6a <release>
  return 0;
    800035a0:	4501                	li	a0,0
}
    800035a2:	70e2                	ld	ra,56(sp)
    800035a4:	7442                	ld	s0,48(sp)
    800035a6:	74a2                	ld	s1,40(sp)
    800035a8:	7902                	ld	s2,32(sp)
    800035aa:	69e2                	ld	s3,24(sp)
    800035ac:	6121                	addi	sp,sp,64
    800035ae:	8082                	ret
      release(&tickslock);
    800035b0:	00234517          	auipc	a0,0x234
    800035b4:	e8850513          	addi	a0,a0,-376 # 80237438 <tickslock>
    800035b8:	ffffe097          	auipc	ra,0xffffe
    800035bc:	8b2080e7          	jalr	-1870(ra) # 80000e6a <release>
      return -1;
    800035c0:	557d                	li	a0,-1
    800035c2:	b7c5                	j	800035a2 <sys_sleep+0x88>

00000000800035c4 <sys_kill>:

uint64
sys_kill(void)
{
    800035c4:	1101                	addi	sp,sp,-32
    800035c6:	ec06                	sd	ra,24(sp)
    800035c8:	e822                	sd	s0,16(sp)
    800035ca:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800035cc:	fec40593          	addi	a1,s0,-20
    800035d0:	4501                	li	a0,0
    800035d2:	00000097          	auipc	ra,0x0
    800035d6:	d9a080e7          	jalr	-614(ra) # 8000336c <argint>
  return kill(pid);
    800035da:	fec42503          	lw	a0,-20(s0)
    800035de:	fffff097          	auipc	ra,0xfffff
    800035e2:	1e0080e7          	jalr	480(ra) # 800027be <kill>
}
    800035e6:	60e2                	ld	ra,24(sp)
    800035e8:	6442                	ld	s0,16(sp)
    800035ea:	6105                	addi	sp,sp,32
    800035ec:	8082                	ret

00000000800035ee <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800035ee:	1101                	addi	sp,sp,-32
    800035f0:	ec06                	sd	ra,24(sp)
    800035f2:	e822                	sd	s0,16(sp)
    800035f4:	e426                	sd	s1,8(sp)
    800035f6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800035f8:	00234517          	auipc	a0,0x234
    800035fc:	e4050513          	addi	a0,a0,-448 # 80237438 <tickslock>
    80003600:	ffffd097          	auipc	ra,0xffffd
    80003604:	7b6080e7          	jalr	1974(ra) # 80000db6 <acquire>
  xticks = ticks;
    80003608:	00005497          	auipc	s1,0x5
    8000360c:	3784a483          	lw	s1,888(s1) # 80008980 <ticks>
  release(&tickslock);
    80003610:	00234517          	auipc	a0,0x234
    80003614:	e2850513          	addi	a0,a0,-472 # 80237438 <tickslock>
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	852080e7          	jalr	-1966(ra) # 80000e6a <release>
  return xticks;
}
    80003620:	02049513          	slli	a0,s1,0x20
    80003624:	9101                	srli	a0,a0,0x20
    80003626:	60e2                	ld	ra,24(sp)
    80003628:	6442                	ld	s0,16(sp)
    8000362a:	64a2                	ld	s1,8(sp)
    8000362c:	6105                	addi	sp,sp,32
    8000362e:	8082                	ret

0000000080003630 <sys_waitx>:

uint64
sys_waitx(void)
{
    80003630:	7139                	addi	sp,sp,-64
    80003632:	fc06                	sd	ra,56(sp)
    80003634:	f822                	sd	s0,48(sp)
    80003636:	f426                	sd	s1,40(sp)
    80003638:	f04a                	sd	s2,32(sp)
    8000363a:	0080                	addi	s0,sp,64
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
    8000363c:	fd840593          	addi	a1,s0,-40
    80003640:	4501                	li	a0,0
    80003642:	00000097          	auipc	ra,0x0
    80003646:	d4a080e7          	jalr	-694(ra) # 8000338c <argaddr>
  argaddr(1, &addr1); // user virtual memory
    8000364a:	fd040593          	addi	a1,s0,-48
    8000364e:	4505                	li	a0,1
    80003650:	00000097          	auipc	ra,0x0
    80003654:	d3c080e7          	jalr	-708(ra) # 8000338c <argaddr>
  argaddr(2, &addr2);
    80003658:	fc840593          	addi	a1,s0,-56
    8000365c:	4509                	li	a0,2
    8000365e:	00000097          	auipc	ra,0x0
    80003662:	d2e080e7          	jalr	-722(ra) # 8000338c <argaddr>
  int ret = waitx(addr, &wtime, &rtime);
    80003666:	fc040613          	addi	a2,s0,-64
    8000366a:	fc440593          	addi	a1,s0,-60
    8000366e:	fd843503          	ld	a0,-40(s0)
    80003672:	fffff097          	auipc	ra,0xfffff
    80003676:	4a4080e7          	jalr	1188(ra) # 80002b16 <waitx>
    8000367a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000367c:	ffffe097          	auipc	ra,0xffffe
    80003680:	5fc080e7          	jalr	1532(ra) # 80001c78 <myproc>
    80003684:	84aa                	mv	s1,a0
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    80003686:	4691                	li	a3,4
    80003688:	fc440613          	addi	a2,s0,-60
    8000368c:	fd043583          	ld	a1,-48(s0)
    80003690:	6928                	ld	a0,80(a0)
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	1f4080e7          	jalr	500(ra) # 80001886 <copyout>
    return -1;
    8000369a:	57fd                	li	a5,-1
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    8000369c:	00054f63          	bltz	a0,800036ba <sys_waitx+0x8a>
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    800036a0:	4691                	li	a3,4
    800036a2:	fc040613          	addi	a2,s0,-64
    800036a6:	fc843583          	ld	a1,-56(s0)
    800036aa:	68a8                	ld	a0,80(s1)
    800036ac:	ffffe097          	auipc	ra,0xffffe
    800036b0:	1da080e7          	jalr	474(ra) # 80001886 <copyout>
    800036b4:	00054a63          	bltz	a0,800036c8 <sys_waitx+0x98>
    return -1;
  return ret;
    800036b8:	87ca                	mv	a5,s2
    800036ba:	853e                	mv	a0,a5
    800036bc:	70e2                	ld	ra,56(sp)
    800036be:	7442                	ld	s0,48(sp)
    800036c0:	74a2                	ld	s1,40(sp)
    800036c2:	7902                	ld	s2,32(sp)
    800036c4:	6121                	addi	sp,sp,64
    800036c6:	8082                	ret
    return -1;
    800036c8:	57fd                	li	a5,-1
    800036ca:	bfc5                	j	800036ba <sys_waitx+0x8a>

00000000800036cc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800036cc:	7179                	addi	sp,sp,-48
    800036ce:	f406                	sd	ra,40(sp)
    800036d0:	f022                	sd	s0,32(sp)
    800036d2:	ec26                	sd	s1,24(sp)
    800036d4:	e84a                	sd	s2,16(sp)
    800036d6:	e44e                	sd	s3,8(sp)
    800036d8:	e052                	sd	s4,0(sp)
    800036da:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800036dc:	00005597          	auipc	a1,0x5
    800036e0:	ea458593          	addi	a1,a1,-348 # 80008580 <syscalls+0xc8>
    800036e4:	00234517          	auipc	a0,0x234
    800036e8:	d6c50513          	addi	a0,a0,-660 # 80237450 <bcache>
    800036ec:	ffffd097          	auipc	ra,0xffffd
    800036f0:	63a080e7          	jalr	1594(ra) # 80000d26 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800036f4:	0023c797          	auipc	a5,0x23c
    800036f8:	d5c78793          	addi	a5,a5,-676 # 8023f450 <bcache+0x8000>
    800036fc:	0023c717          	auipc	a4,0x23c
    80003700:	fbc70713          	addi	a4,a4,-68 # 8023f6b8 <bcache+0x8268>
    80003704:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003708:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000370c:	00234497          	auipc	s1,0x234
    80003710:	d5c48493          	addi	s1,s1,-676 # 80237468 <bcache+0x18>
    b->next = bcache.head.next;
    80003714:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003716:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003718:	00005a17          	auipc	s4,0x5
    8000371c:	e70a0a13          	addi	s4,s4,-400 # 80008588 <syscalls+0xd0>
    b->next = bcache.head.next;
    80003720:	2b893783          	ld	a5,696(s2)
    80003724:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003726:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000372a:	85d2                	mv	a1,s4
    8000372c:	01048513          	addi	a0,s1,16
    80003730:	00001097          	auipc	ra,0x1
    80003734:	4c4080e7          	jalr	1220(ra) # 80004bf4 <initsleeplock>
    bcache.head.next->prev = b;
    80003738:	2b893783          	ld	a5,696(s2)
    8000373c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000373e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003742:	45848493          	addi	s1,s1,1112
    80003746:	fd349de3          	bne	s1,s3,80003720 <binit+0x54>
  }
}
    8000374a:	70a2                	ld	ra,40(sp)
    8000374c:	7402                	ld	s0,32(sp)
    8000374e:	64e2                	ld	s1,24(sp)
    80003750:	6942                	ld	s2,16(sp)
    80003752:	69a2                	ld	s3,8(sp)
    80003754:	6a02                	ld	s4,0(sp)
    80003756:	6145                	addi	sp,sp,48
    80003758:	8082                	ret

000000008000375a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000375a:	7179                	addi	sp,sp,-48
    8000375c:	f406                	sd	ra,40(sp)
    8000375e:	f022                	sd	s0,32(sp)
    80003760:	ec26                	sd	s1,24(sp)
    80003762:	e84a                	sd	s2,16(sp)
    80003764:	e44e                	sd	s3,8(sp)
    80003766:	1800                	addi	s0,sp,48
    80003768:	892a                	mv	s2,a0
    8000376a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000376c:	00234517          	auipc	a0,0x234
    80003770:	ce450513          	addi	a0,a0,-796 # 80237450 <bcache>
    80003774:	ffffd097          	auipc	ra,0xffffd
    80003778:	642080e7          	jalr	1602(ra) # 80000db6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000377c:	0023c497          	auipc	s1,0x23c
    80003780:	f8c4b483          	ld	s1,-116(s1) # 8023f708 <bcache+0x82b8>
    80003784:	0023c797          	auipc	a5,0x23c
    80003788:	f3478793          	addi	a5,a5,-204 # 8023f6b8 <bcache+0x8268>
    8000378c:	02f48f63          	beq	s1,a5,800037ca <bread+0x70>
    80003790:	873e                	mv	a4,a5
    80003792:	a021                	j	8000379a <bread+0x40>
    80003794:	68a4                	ld	s1,80(s1)
    80003796:	02e48a63          	beq	s1,a4,800037ca <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000379a:	449c                	lw	a5,8(s1)
    8000379c:	ff279ce3          	bne	a5,s2,80003794 <bread+0x3a>
    800037a0:	44dc                	lw	a5,12(s1)
    800037a2:	ff3799e3          	bne	a5,s3,80003794 <bread+0x3a>
      b->refcnt++;
    800037a6:	40bc                	lw	a5,64(s1)
    800037a8:	2785                	addiw	a5,a5,1
    800037aa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800037ac:	00234517          	auipc	a0,0x234
    800037b0:	ca450513          	addi	a0,a0,-860 # 80237450 <bcache>
    800037b4:	ffffd097          	auipc	ra,0xffffd
    800037b8:	6b6080e7          	jalr	1718(ra) # 80000e6a <release>
      acquiresleep(&b->lock);
    800037bc:	01048513          	addi	a0,s1,16
    800037c0:	00001097          	auipc	ra,0x1
    800037c4:	46e080e7          	jalr	1134(ra) # 80004c2e <acquiresleep>
      return b;
    800037c8:	a8b9                	j	80003826 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037ca:	0023c497          	auipc	s1,0x23c
    800037ce:	f364b483          	ld	s1,-202(s1) # 8023f700 <bcache+0x82b0>
    800037d2:	0023c797          	auipc	a5,0x23c
    800037d6:	ee678793          	addi	a5,a5,-282 # 8023f6b8 <bcache+0x8268>
    800037da:	00f48863          	beq	s1,a5,800037ea <bread+0x90>
    800037de:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800037e0:	40bc                	lw	a5,64(s1)
    800037e2:	cf81                	beqz	a5,800037fa <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800037e4:	64a4                	ld	s1,72(s1)
    800037e6:	fee49de3          	bne	s1,a4,800037e0 <bread+0x86>
  panic("bget: no buffers");
    800037ea:	00005517          	auipc	a0,0x5
    800037ee:	da650513          	addi	a0,a0,-602 # 80008590 <syscalls+0xd8>
    800037f2:	ffffd097          	auipc	ra,0xffffd
    800037f6:	d4c080e7          	jalr	-692(ra) # 8000053e <panic>
      b->dev = dev;
    800037fa:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800037fe:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003802:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80003806:	4785                	li	a5,1
    80003808:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000380a:	00234517          	auipc	a0,0x234
    8000380e:	c4650513          	addi	a0,a0,-954 # 80237450 <bcache>
    80003812:	ffffd097          	auipc	ra,0xffffd
    80003816:	658080e7          	jalr	1624(ra) # 80000e6a <release>
      acquiresleep(&b->lock);
    8000381a:	01048513          	addi	a0,s1,16
    8000381e:	00001097          	auipc	ra,0x1
    80003822:	410080e7          	jalr	1040(ra) # 80004c2e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003826:	409c                	lw	a5,0(s1)
    80003828:	cb89                	beqz	a5,8000383a <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000382a:	8526                	mv	a0,s1
    8000382c:	70a2                	ld	ra,40(sp)
    8000382e:	7402                	ld	s0,32(sp)
    80003830:	64e2                	ld	s1,24(sp)
    80003832:	6942                	ld	s2,16(sp)
    80003834:	69a2                	ld	s3,8(sp)
    80003836:	6145                	addi	sp,sp,48
    80003838:	8082                	ret
    virtio_disk_rw(b, 0);
    8000383a:	4581                	li	a1,0
    8000383c:	8526                	mv	a0,s1
    8000383e:	00003097          	auipc	ra,0x3
    80003842:	106080e7          	jalr	262(ra) # 80006944 <virtio_disk_rw>
    b->valid = 1;
    80003846:	4785                	li	a5,1
    80003848:	c09c                	sw	a5,0(s1)
  return b;
    8000384a:	b7c5                	j	8000382a <bread+0xd0>

000000008000384c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000384c:	1101                	addi	sp,sp,-32
    8000384e:	ec06                	sd	ra,24(sp)
    80003850:	e822                	sd	s0,16(sp)
    80003852:	e426                	sd	s1,8(sp)
    80003854:	1000                	addi	s0,sp,32
    80003856:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003858:	0541                	addi	a0,a0,16
    8000385a:	00001097          	auipc	ra,0x1
    8000385e:	46e080e7          	jalr	1134(ra) # 80004cc8 <holdingsleep>
    80003862:	cd01                	beqz	a0,8000387a <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003864:	4585                	li	a1,1
    80003866:	8526                	mv	a0,s1
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	0dc080e7          	jalr	220(ra) # 80006944 <virtio_disk_rw>
}
    80003870:	60e2                	ld	ra,24(sp)
    80003872:	6442                	ld	s0,16(sp)
    80003874:	64a2                	ld	s1,8(sp)
    80003876:	6105                	addi	sp,sp,32
    80003878:	8082                	ret
    panic("bwrite");
    8000387a:	00005517          	auipc	a0,0x5
    8000387e:	d2e50513          	addi	a0,a0,-722 # 800085a8 <syscalls+0xf0>
    80003882:	ffffd097          	auipc	ra,0xffffd
    80003886:	cbc080e7          	jalr	-836(ra) # 8000053e <panic>

000000008000388a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000388a:	1101                	addi	sp,sp,-32
    8000388c:	ec06                	sd	ra,24(sp)
    8000388e:	e822                	sd	s0,16(sp)
    80003890:	e426                	sd	s1,8(sp)
    80003892:	e04a                	sd	s2,0(sp)
    80003894:	1000                	addi	s0,sp,32
    80003896:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003898:	01050913          	addi	s2,a0,16
    8000389c:	854a                	mv	a0,s2
    8000389e:	00001097          	auipc	ra,0x1
    800038a2:	42a080e7          	jalr	1066(ra) # 80004cc8 <holdingsleep>
    800038a6:	c92d                	beqz	a0,80003918 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800038a8:	854a                	mv	a0,s2
    800038aa:	00001097          	auipc	ra,0x1
    800038ae:	3da080e7          	jalr	986(ra) # 80004c84 <releasesleep>

  acquire(&bcache.lock);
    800038b2:	00234517          	auipc	a0,0x234
    800038b6:	b9e50513          	addi	a0,a0,-1122 # 80237450 <bcache>
    800038ba:	ffffd097          	auipc	ra,0xffffd
    800038be:	4fc080e7          	jalr	1276(ra) # 80000db6 <acquire>
  b->refcnt--;
    800038c2:	40bc                	lw	a5,64(s1)
    800038c4:	37fd                	addiw	a5,a5,-1
    800038c6:	0007871b          	sext.w	a4,a5
    800038ca:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800038cc:	eb05                	bnez	a4,800038fc <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800038ce:	68bc                	ld	a5,80(s1)
    800038d0:	64b8                	ld	a4,72(s1)
    800038d2:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800038d4:	64bc                	ld	a5,72(s1)
    800038d6:	68b8                	ld	a4,80(s1)
    800038d8:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800038da:	0023c797          	auipc	a5,0x23c
    800038de:	b7678793          	addi	a5,a5,-1162 # 8023f450 <bcache+0x8000>
    800038e2:	2b87b703          	ld	a4,696(a5)
    800038e6:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800038e8:	0023c717          	auipc	a4,0x23c
    800038ec:	dd070713          	addi	a4,a4,-560 # 8023f6b8 <bcache+0x8268>
    800038f0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800038f2:	2b87b703          	ld	a4,696(a5)
    800038f6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800038f8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800038fc:	00234517          	auipc	a0,0x234
    80003900:	b5450513          	addi	a0,a0,-1196 # 80237450 <bcache>
    80003904:	ffffd097          	auipc	ra,0xffffd
    80003908:	566080e7          	jalr	1382(ra) # 80000e6a <release>
}
    8000390c:	60e2                	ld	ra,24(sp)
    8000390e:	6442                	ld	s0,16(sp)
    80003910:	64a2                	ld	s1,8(sp)
    80003912:	6902                	ld	s2,0(sp)
    80003914:	6105                	addi	sp,sp,32
    80003916:	8082                	ret
    panic("brelse");
    80003918:	00005517          	auipc	a0,0x5
    8000391c:	c9850513          	addi	a0,a0,-872 # 800085b0 <syscalls+0xf8>
    80003920:	ffffd097          	auipc	ra,0xffffd
    80003924:	c1e080e7          	jalr	-994(ra) # 8000053e <panic>

0000000080003928 <bpin>:

void
bpin(struct buf *b) {
    80003928:	1101                	addi	sp,sp,-32
    8000392a:	ec06                	sd	ra,24(sp)
    8000392c:	e822                	sd	s0,16(sp)
    8000392e:	e426                	sd	s1,8(sp)
    80003930:	1000                	addi	s0,sp,32
    80003932:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003934:	00234517          	auipc	a0,0x234
    80003938:	b1c50513          	addi	a0,a0,-1252 # 80237450 <bcache>
    8000393c:	ffffd097          	auipc	ra,0xffffd
    80003940:	47a080e7          	jalr	1146(ra) # 80000db6 <acquire>
  b->refcnt++;
    80003944:	40bc                	lw	a5,64(s1)
    80003946:	2785                	addiw	a5,a5,1
    80003948:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000394a:	00234517          	auipc	a0,0x234
    8000394e:	b0650513          	addi	a0,a0,-1274 # 80237450 <bcache>
    80003952:	ffffd097          	auipc	ra,0xffffd
    80003956:	518080e7          	jalr	1304(ra) # 80000e6a <release>
}
    8000395a:	60e2                	ld	ra,24(sp)
    8000395c:	6442                	ld	s0,16(sp)
    8000395e:	64a2                	ld	s1,8(sp)
    80003960:	6105                	addi	sp,sp,32
    80003962:	8082                	ret

0000000080003964 <bunpin>:

void
bunpin(struct buf *b) {
    80003964:	1101                	addi	sp,sp,-32
    80003966:	ec06                	sd	ra,24(sp)
    80003968:	e822                	sd	s0,16(sp)
    8000396a:	e426                	sd	s1,8(sp)
    8000396c:	1000                	addi	s0,sp,32
    8000396e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003970:	00234517          	auipc	a0,0x234
    80003974:	ae050513          	addi	a0,a0,-1312 # 80237450 <bcache>
    80003978:	ffffd097          	auipc	ra,0xffffd
    8000397c:	43e080e7          	jalr	1086(ra) # 80000db6 <acquire>
  b->refcnt--;
    80003980:	40bc                	lw	a5,64(s1)
    80003982:	37fd                	addiw	a5,a5,-1
    80003984:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003986:	00234517          	auipc	a0,0x234
    8000398a:	aca50513          	addi	a0,a0,-1334 # 80237450 <bcache>
    8000398e:	ffffd097          	auipc	ra,0xffffd
    80003992:	4dc080e7          	jalr	1244(ra) # 80000e6a <release>
}
    80003996:	60e2                	ld	ra,24(sp)
    80003998:	6442                	ld	s0,16(sp)
    8000399a:	64a2                	ld	s1,8(sp)
    8000399c:	6105                	addi	sp,sp,32
    8000399e:	8082                	ret

00000000800039a0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800039a0:	1101                	addi	sp,sp,-32
    800039a2:	ec06                	sd	ra,24(sp)
    800039a4:	e822                	sd	s0,16(sp)
    800039a6:	e426                	sd	s1,8(sp)
    800039a8:	e04a                	sd	s2,0(sp)
    800039aa:	1000                	addi	s0,sp,32
    800039ac:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800039ae:	00d5d59b          	srliw	a1,a1,0xd
    800039b2:	0023c797          	auipc	a5,0x23c
    800039b6:	17a7a783          	lw	a5,378(a5) # 8023fb2c <sb+0x1c>
    800039ba:	9dbd                	addw	a1,a1,a5
    800039bc:	00000097          	auipc	ra,0x0
    800039c0:	d9e080e7          	jalr	-610(ra) # 8000375a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800039c4:	0074f713          	andi	a4,s1,7
    800039c8:	4785                	li	a5,1
    800039ca:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800039ce:	14ce                	slli	s1,s1,0x33
    800039d0:	90d9                	srli	s1,s1,0x36
    800039d2:	00950733          	add	a4,a0,s1
    800039d6:	05874703          	lbu	a4,88(a4)
    800039da:	00e7f6b3          	and	a3,a5,a4
    800039de:	c69d                	beqz	a3,80003a0c <bfree+0x6c>
    800039e0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800039e2:	94aa                	add	s1,s1,a0
    800039e4:	fff7c793          	not	a5,a5
    800039e8:	8ff9                	and	a5,a5,a4
    800039ea:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800039ee:	00001097          	auipc	ra,0x1
    800039f2:	120080e7          	jalr	288(ra) # 80004b0e <log_write>
  brelse(bp);
    800039f6:	854a                	mv	a0,s2
    800039f8:	00000097          	auipc	ra,0x0
    800039fc:	e92080e7          	jalr	-366(ra) # 8000388a <brelse>
}
    80003a00:	60e2                	ld	ra,24(sp)
    80003a02:	6442                	ld	s0,16(sp)
    80003a04:	64a2                	ld	s1,8(sp)
    80003a06:	6902                	ld	s2,0(sp)
    80003a08:	6105                	addi	sp,sp,32
    80003a0a:	8082                	ret
    panic("freeing free block");
    80003a0c:	00005517          	auipc	a0,0x5
    80003a10:	bac50513          	addi	a0,a0,-1108 # 800085b8 <syscalls+0x100>
    80003a14:	ffffd097          	auipc	ra,0xffffd
    80003a18:	b2a080e7          	jalr	-1238(ra) # 8000053e <panic>

0000000080003a1c <balloc>:
{
    80003a1c:	711d                	addi	sp,sp,-96
    80003a1e:	ec86                	sd	ra,88(sp)
    80003a20:	e8a2                	sd	s0,80(sp)
    80003a22:	e4a6                	sd	s1,72(sp)
    80003a24:	e0ca                	sd	s2,64(sp)
    80003a26:	fc4e                	sd	s3,56(sp)
    80003a28:	f852                	sd	s4,48(sp)
    80003a2a:	f456                	sd	s5,40(sp)
    80003a2c:	f05a                	sd	s6,32(sp)
    80003a2e:	ec5e                	sd	s7,24(sp)
    80003a30:	e862                	sd	s8,16(sp)
    80003a32:	e466                	sd	s9,8(sp)
    80003a34:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003a36:	0023c797          	auipc	a5,0x23c
    80003a3a:	0de7a783          	lw	a5,222(a5) # 8023fb14 <sb+0x4>
    80003a3e:	10078163          	beqz	a5,80003b40 <balloc+0x124>
    80003a42:	8baa                	mv	s7,a0
    80003a44:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003a46:	0023cb17          	auipc	s6,0x23c
    80003a4a:	0cab0b13          	addi	s6,s6,202 # 8023fb10 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a4e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003a50:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a52:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003a54:	6c89                	lui	s9,0x2
    80003a56:	a061                	j	80003ade <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003a58:	974a                	add	a4,a4,s2
    80003a5a:	8fd5                	or	a5,a5,a3
    80003a5c:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003a60:	854a                	mv	a0,s2
    80003a62:	00001097          	auipc	ra,0x1
    80003a66:	0ac080e7          	jalr	172(ra) # 80004b0e <log_write>
        brelse(bp);
    80003a6a:	854a                	mv	a0,s2
    80003a6c:	00000097          	auipc	ra,0x0
    80003a70:	e1e080e7          	jalr	-482(ra) # 8000388a <brelse>
  bp = bread(dev, bno);
    80003a74:	85a6                	mv	a1,s1
    80003a76:	855e                	mv	a0,s7
    80003a78:	00000097          	auipc	ra,0x0
    80003a7c:	ce2080e7          	jalr	-798(ra) # 8000375a <bread>
    80003a80:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003a82:	40000613          	li	a2,1024
    80003a86:	4581                	li	a1,0
    80003a88:	05850513          	addi	a0,a0,88
    80003a8c:	ffffd097          	auipc	ra,0xffffd
    80003a90:	426080e7          	jalr	1062(ra) # 80000eb2 <memset>
  log_write(bp);
    80003a94:	854a                	mv	a0,s2
    80003a96:	00001097          	auipc	ra,0x1
    80003a9a:	078080e7          	jalr	120(ra) # 80004b0e <log_write>
  brelse(bp);
    80003a9e:	854a                	mv	a0,s2
    80003aa0:	00000097          	auipc	ra,0x0
    80003aa4:	dea080e7          	jalr	-534(ra) # 8000388a <brelse>
}
    80003aa8:	8526                	mv	a0,s1
    80003aaa:	60e6                	ld	ra,88(sp)
    80003aac:	6446                	ld	s0,80(sp)
    80003aae:	64a6                	ld	s1,72(sp)
    80003ab0:	6906                	ld	s2,64(sp)
    80003ab2:	79e2                	ld	s3,56(sp)
    80003ab4:	7a42                	ld	s4,48(sp)
    80003ab6:	7aa2                	ld	s5,40(sp)
    80003ab8:	7b02                	ld	s6,32(sp)
    80003aba:	6be2                	ld	s7,24(sp)
    80003abc:	6c42                	ld	s8,16(sp)
    80003abe:	6ca2                	ld	s9,8(sp)
    80003ac0:	6125                	addi	sp,sp,96
    80003ac2:	8082                	ret
    brelse(bp);
    80003ac4:	854a                	mv	a0,s2
    80003ac6:	00000097          	auipc	ra,0x0
    80003aca:	dc4080e7          	jalr	-572(ra) # 8000388a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003ace:	015c87bb          	addw	a5,s9,s5
    80003ad2:	00078a9b          	sext.w	s5,a5
    80003ad6:	004b2703          	lw	a4,4(s6)
    80003ada:	06eaf363          	bgeu	s5,a4,80003b40 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80003ade:	41fad79b          	sraiw	a5,s5,0x1f
    80003ae2:	0137d79b          	srliw	a5,a5,0x13
    80003ae6:	015787bb          	addw	a5,a5,s5
    80003aea:	40d7d79b          	sraiw	a5,a5,0xd
    80003aee:	01cb2583          	lw	a1,28(s6)
    80003af2:	9dbd                	addw	a1,a1,a5
    80003af4:	855e                	mv	a0,s7
    80003af6:	00000097          	auipc	ra,0x0
    80003afa:	c64080e7          	jalr	-924(ra) # 8000375a <bread>
    80003afe:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b00:	004b2503          	lw	a0,4(s6)
    80003b04:	000a849b          	sext.w	s1,s5
    80003b08:	8662                	mv	a2,s8
    80003b0a:	faa4fde3          	bgeu	s1,a0,80003ac4 <balloc+0xa8>
      m = 1 << (bi % 8);
    80003b0e:	41f6579b          	sraiw	a5,a2,0x1f
    80003b12:	01d7d69b          	srliw	a3,a5,0x1d
    80003b16:	00c6873b          	addw	a4,a3,a2
    80003b1a:	00777793          	andi	a5,a4,7
    80003b1e:	9f95                	subw	a5,a5,a3
    80003b20:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003b24:	4037571b          	sraiw	a4,a4,0x3
    80003b28:	00e906b3          	add	a3,s2,a4
    80003b2c:	0586c683          	lbu	a3,88(a3)
    80003b30:	00d7f5b3          	and	a1,a5,a3
    80003b34:	d195                	beqz	a1,80003a58 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b36:	2605                	addiw	a2,a2,1
    80003b38:	2485                	addiw	s1,s1,1
    80003b3a:	fd4618e3          	bne	a2,s4,80003b0a <balloc+0xee>
    80003b3e:	b759                	j	80003ac4 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80003b40:	00005517          	auipc	a0,0x5
    80003b44:	a9050513          	addi	a0,a0,-1392 # 800085d0 <syscalls+0x118>
    80003b48:	ffffd097          	auipc	ra,0xffffd
    80003b4c:	a40080e7          	jalr	-1472(ra) # 80000588 <printf>
  return 0;
    80003b50:	4481                	li	s1,0
    80003b52:	bf99                	j	80003aa8 <balloc+0x8c>

0000000080003b54 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003b54:	7179                	addi	sp,sp,-48
    80003b56:	f406                	sd	ra,40(sp)
    80003b58:	f022                	sd	s0,32(sp)
    80003b5a:	ec26                	sd	s1,24(sp)
    80003b5c:	e84a                	sd	s2,16(sp)
    80003b5e:	e44e                	sd	s3,8(sp)
    80003b60:	e052                	sd	s4,0(sp)
    80003b62:	1800                	addi	s0,sp,48
    80003b64:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003b66:	47ad                	li	a5,11
    80003b68:	02b7e763          	bltu	a5,a1,80003b96 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80003b6c:	02059493          	slli	s1,a1,0x20
    80003b70:	9081                	srli	s1,s1,0x20
    80003b72:	048a                	slli	s1,s1,0x2
    80003b74:	94aa                	add	s1,s1,a0
    80003b76:	0504a903          	lw	s2,80(s1)
    80003b7a:	06091e63          	bnez	s2,80003bf6 <bmap+0xa2>
      addr = balloc(ip->dev);
    80003b7e:	4108                	lw	a0,0(a0)
    80003b80:	00000097          	auipc	ra,0x0
    80003b84:	e9c080e7          	jalr	-356(ra) # 80003a1c <balloc>
    80003b88:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003b8c:	06090563          	beqz	s2,80003bf6 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80003b90:	0524a823          	sw	s2,80(s1)
    80003b94:	a08d                	j	80003bf6 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003b96:	ff45849b          	addiw	s1,a1,-12
    80003b9a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003b9e:	0ff00793          	li	a5,255
    80003ba2:	08e7e563          	bltu	a5,a4,80003c2c <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003ba6:	08052903          	lw	s2,128(a0)
    80003baa:	00091d63          	bnez	s2,80003bc4 <bmap+0x70>
      addr = balloc(ip->dev);
    80003bae:	4108                	lw	a0,0(a0)
    80003bb0:	00000097          	auipc	ra,0x0
    80003bb4:	e6c080e7          	jalr	-404(ra) # 80003a1c <balloc>
    80003bb8:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003bbc:	02090d63          	beqz	s2,80003bf6 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003bc0:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80003bc4:	85ca                	mv	a1,s2
    80003bc6:	0009a503          	lw	a0,0(s3)
    80003bca:	00000097          	auipc	ra,0x0
    80003bce:	b90080e7          	jalr	-1136(ra) # 8000375a <bread>
    80003bd2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003bd4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003bd8:	02049593          	slli	a1,s1,0x20
    80003bdc:	9181                	srli	a1,a1,0x20
    80003bde:	058a                	slli	a1,a1,0x2
    80003be0:	00b784b3          	add	s1,a5,a1
    80003be4:	0004a903          	lw	s2,0(s1)
    80003be8:	02090063          	beqz	s2,80003c08 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003bec:	8552                	mv	a0,s4
    80003bee:	00000097          	auipc	ra,0x0
    80003bf2:	c9c080e7          	jalr	-868(ra) # 8000388a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003bf6:	854a                	mv	a0,s2
    80003bf8:	70a2                	ld	ra,40(sp)
    80003bfa:	7402                	ld	s0,32(sp)
    80003bfc:	64e2                	ld	s1,24(sp)
    80003bfe:	6942                	ld	s2,16(sp)
    80003c00:	69a2                	ld	s3,8(sp)
    80003c02:	6a02                	ld	s4,0(sp)
    80003c04:	6145                	addi	sp,sp,48
    80003c06:	8082                	ret
      addr = balloc(ip->dev);
    80003c08:	0009a503          	lw	a0,0(s3)
    80003c0c:	00000097          	auipc	ra,0x0
    80003c10:	e10080e7          	jalr	-496(ra) # 80003a1c <balloc>
    80003c14:	0005091b          	sext.w	s2,a0
      if(addr){
    80003c18:	fc090ae3          	beqz	s2,80003bec <bmap+0x98>
        a[bn] = addr;
    80003c1c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003c20:	8552                	mv	a0,s4
    80003c22:	00001097          	auipc	ra,0x1
    80003c26:	eec080e7          	jalr	-276(ra) # 80004b0e <log_write>
    80003c2a:	b7c9                	j	80003bec <bmap+0x98>
  panic("bmap: out of range");
    80003c2c:	00005517          	auipc	a0,0x5
    80003c30:	9bc50513          	addi	a0,a0,-1604 # 800085e8 <syscalls+0x130>
    80003c34:	ffffd097          	auipc	ra,0xffffd
    80003c38:	90a080e7          	jalr	-1782(ra) # 8000053e <panic>

0000000080003c3c <iget>:
{
    80003c3c:	7179                	addi	sp,sp,-48
    80003c3e:	f406                	sd	ra,40(sp)
    80003c40:	f022                	sd	s0,32(sp)
    80003c42:	ec26                	sd	s1,24(sp)
    80003c44:	e84a                	sd	s2,16(sp)
    80003c46:	e44e                	sd	s3,8(sp)
    80003c48:	e052                	sd	s4,0(sp)
    80003c4a:	1800                	addi	s0,sp,48
    80003c4c:	89aa                	mv	s3,a0
    80003c4e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003c50:	0023c517          	auipc	a0,0x23c
    80003c54:	ee050513          	addi	a0,a0,-288 # 8023fb30 <itable>
    80003c58:	ffffd097          	auipc	ra,0xffffd
    80003c5c:	15e080e7          	jalr	350(ra) # 80000db6 <acquire>
  empty = 0;
    80003c60:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003c62:	0023c497          	auipc	s1,0x23c
    80003c66:	ee648493          	addi	s1,s1,-282 # 8023fb48 <itable+0x18>
    80003c6a:	0023e697          	auipc	a3,0x23e
    80003c6e:	96e68693          	addi	a3,a3,-1682 # 802415d8 <log>
    80003c72:	a039                	j	80003c80 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003c74:	02090b63          	beqz	s2,80003caa <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003c78:	08848493          	addi	s1,s1,136
    80003c7c:	02d48a63          	beq	s1,a3,80003cb0 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003c80:	449c                	lw	a5,8(s1)
    80003c82:	fef059e3          	blez	a5,80003c74 <iget+0x38>
    80003c86:	4098                	lw	a4,0(s1)
    80003c88:	ff3716e3          	bne	a4,s3,80003c74 <iget+0x38>
    80003c8c:	40d8                	lw	a4,4(s1)
    80003c8e:	ff4713e3          	bne	a4,s4,80003c74 <iget+0x38>
      ip->ref++;
    80003c92:	2785                	addiw	a5,a5,1
    80003c94:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003c96:	0023c517          	auipc	a0,0x23c
    80003c9a:	e9a50513          	addi	a0,a0,-358 # 8023fb30 <itable>
    80003c9e:	ffffd097          	auipc	ra,0xffffd
    80003ca2:	1cc080e7          	jalr	460(ra) # 80000e6a <release>
      return ip;
    80003ca6:	8926                	mv	s2,s1
    80003ca8:	a03d                	j	80003cd6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003caa:	f7f9                	bnez	a5,80003c78 <iget+0x3c>
    80003cac:	8926                	mv	s2,s1
    80003cae:	b7e9                	j	80003c78 <iget+0x3c>
  if(empty == 0)
    80003cb0:	02090c63          	beqz	s2,80003ce8 <iget+0xac>
  ip->dev = dev;
    80003cb4:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003cb8:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003cbc:	4785                	li	a5,1
    80003cbe:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003cc2:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003cc6:	0023c517          	auipc	a0,0x23c
    80003cca:	e6a50513          	addi	a0,a0,-406 # 8023fb30 <itable>
    80003cce:	ffffd097          	auipc	ra,0xffffd
    80003cd2:	19c080e7          	jalr	412(ra) # 80000e6a <release>
}
    80003cd6:	854a                	mv	a0,s2
    80003cd8:	70a2                	ld	ra,40(sp)
    80003cda:	7402                	ld	s0,32(sp)
    80003cdc:	64e2                	ld	s1,24(sp)
    80003cde:	6942                	ld	s2,16(sp)
    80003ce0:	69a2                	ld	s3,8(sp)
    80003ce2:	6a02                	ld	s4,0(sp)
    80003ce4:	6145                	addi	sp,sp,48
    80003ce6:	8082                	ret
    panic("iget: no inodes");
    80003ce8:	00005517          	auipc	a0,0x5
    80003cec:	91850513          	addi	a0,a0,-1768 # 80008600 <syscalls+0x148>
    80003cf0:	ffffd097          	auipc	ra,0xffffd
    80003cf4:	84e080e7          	jalr	-1970(ra) # 8000053e <panic>

0000000080003cf8 <fsinit>:
fsinit(int dev) {
    80003cf8:	7179                	addi	sp,sp,-48
    80003cfa:	f406                	sd	ra,40(sp)
    80003cfc:	f022                	sd	s0,32(sp)
    80003cfe:	ec26                	sd	s1,24(sp)
    80003d00:	e84a                	sd	s2,16(sp)
    80003d02:	e44e                	sd	s3,8(sp)
    80003d04:	1800                	addi	s0,sp,48
    80003d06:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003d08:	4585                	li	a1,1
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	a50080e7          	jalr	-1456(ra) # 8000375a <bread>
    80003d12:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003d14:	0023c997          	auipc	s3,0x23c
    80003d18:	dfc98993          	addi	s3,s3,-516 # 8023fb10 <sb>
    80003d1c:	02000613          	li	a2,32
    80003d20:	05850593          	addi	a1,a0,88
    80003d24:	854e                	mv	a0,s3
    80003d26:	ffffd097          	auipc	ra,0xffffd
    80003d2a:	1e8080e7          	jalr	488(ra) # 80000f0e <memmove>
  brelse(bp);
    80003d2e:	8526                	mv	a0,s1
    80003d30:	00000097          	auipc	ra,0x0
    80003d34:	b5a080e7          	jalr	-1190(ra) # 8000388a <brelse>
  if(sb.magic != FSMAGIC)
    80003d38:	0009a703          	lw	a4,0(s3)
    80003d3c:	102037b7          	lui	a5,0x10203
    80003d40:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003d44:	02f71263          	bne	a4,a5,80003d68 <fsinit+0x70>
  initlog(dev, &sb);
    80003d48:	0023c597          	auipc	a1,0x23c
    80003d4c:	dc858593          	addi	a1,a1,-568 # 8023fb10 <sb>
    80003d50:	854a                	mv	a0,s2
    80003d52:	00001097          	auipc	ra,0x1
    80003d56:	b40080e7          	jalr	-1216(ra) # 80004892 <initlog>
}
    80003d5a:	70a2                	ld	ra,40(sp)
    80003d5c:	7402                	ld	s0,32(sp)
    80003d5e:	64e2                	ld	s1,24(sp)
    80003d60:	6942                	ld	s2,16(sp)
    80003d62:	69a2                	ld	s3,8(sp)
    80003d64:	6145                	addi	sp,sp,48
    80003d66:	8082                	ret
    panic("invalid file system");
    80003d68:	00005517          	auipc	a0,0x5
    80003d6c:	8a850513          	addi	a0,a0,-1880 # 80008610 <syscalls+0x158>
    80003d70:	ffffc097          	auipc	ra,0xffffc
    80003d74:	7ce080e7          	jalr	1998(ra) # 8000053e <panic>

0000000080003d78 <iinit>:
{
    80003d78:	7179                	addi	sp,sp,-48
    80003d7a:	f406                	sd	ra,40(sp)
    80003d7c:	f022                	sd	s0,32(sp)
    80003d7e:	ec26                	sd	s1,24(sp)
    80003d80:	e84a                	sd	s2,16(sp)
    80003d82:	e44e                	sd	s3,8(sp)
    80003d84:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003d86:	00005597          	auipc	a1,0x5
    80003d8a:	8a258593          	addi	a1,a1,-1886 # 80008628 <syscalls+0x170>
    80003d8e:	0023c517          	auipc	a0,0x23c
    80003d92:	da250513          	addi	a0,a0,-606 # 8023fb30 <itable>
    80003d96:	ffffd097          	auipc	ra,0xffffd
    80003d9a:	f90080e7          	jalr	-112(ra) # 80000d26 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003d9e:	0023c497          	auipc	s1,0x23c
    80003da2:	dba48493          	addi	s1,s1,-582 # 8023fb58 <itable+0x28>
    80003da6:	0023e997          	auipc	s3,0x23e
    80003daa:	84298993          	addi	s3,s3,-1982 # 802415e8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003dae:	00005917          	auipc	s2,0x5
    80003db2:	88290913          	addi	s2,s2,-1918 # 80008630 <syscalls+0x178>
    80003db6:	85ca                	mv	a1,s2
    80003db8:	8526                	mv	a0,s1
    80003dba:	00001097          	auipc	ra,0x1
    80003dbe:	e3a080e7          	jalr	-454(ra) # 80004bf4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003dc2:	08848493          	addi	s1,s1,136
    80003dc6:	ff3498e3          	bne	s1,s3,80003db6 <iinit+0x3e>
}
    80003dca:	70a2                	ld	ra,40(sp)
    80003dcc:	7402                	ld	s0,32(sp)
    80003dce:	64e2                	ld	s1,24(sp)
    80003dd0:	6942                	ld	s2,16(sp)
    80003dd2:	69a2                	ld	s3,8(sp)
    80003dd4:	6145                	addi	sp,sp,48
    80003dd6:	8082                	ret

0000000080003dd8 <ialloc>:
{
    80003dd8:	715d                	addi	sp,sp,-80
    80003dda:	e486                	sd	ra,72(sp)
    80003ddc:	e0a2                	sd	s0,64(sp)
    80003dde:	fc26                	sd	s1,56(sp)
    80003de0:	f84a                	sd	s2,48(sp)
    80003de2:	f44e                	sd	s3,40(sp)
    80003de4:	f052                	sd	s4,32(sp)
    80003de6:	ec56                	sd	s5,24(sp)
    80003de8:	e85a                	sd	s6,16(sp)
    80003dea:	e45e                	sd	s7,8(sp)
    80003dec:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003dee:	0023c717          	auipc	a4,0x23c
    80003df2:	d2e72703          	lw	a4,-722(a4) # 8023fb1c <sb+0xc>
    80003df6:	4785                	li	a5,1
    80003df8:	04e7fa63          	bgeu	a5,a4,80003e4c <ialloc+0x74>
    80003dfc:	8aaa                	mv	s5,a0
    80003dfe:	8bae                	mv	s7,a1
    80003e00:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003e02:	0023ca17          	auipc	s4,0x23c
    80003e06:	d0ea0a13          	addi	s4,s4,-754 # 8023fb10 <sb>
    80003e0a:	00048b1b          	sext.w	s6,s1
    80003e0e:	0044d793          	srli	a5,s1,0x4
    80003e12:	018a2583          	lw	a1,24(s4)
    80003e16:	9dbd                	addw	a1,a1,a5
    80003e18:	8556                	mv	a0,s5
    80003e1a:	00000097          	auipc	ra,0x0
    80003e1e:	940080e7          	jalr	-1728(ra) # 8000375a <bread>
    80003e22:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003e24:	05850993          	addi	s3,a0,88
    80003e28:	00f4f793          	andi	a5,s1,15
    80003e2c:	079a                	slli	a5,a5,0x6
    80003e2e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003e30:	00099783          	lh	a5,0(s3)
    80003e34:	c3a1                	beqz	a5,80003e74 <ialloc+0x9c>
    brelse(bp);
    80003e36:	00000097          	auipc	ra,0x0
    80003e3a:	a54080e7          	jalr	-1452(ra) # 8000388a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e3e:	0485                	addi	s1,s1,1
    80003e40:	00ca2703          	lw	a4,12(s4)
    80003e44:	0004879b          	sext.w	a5,s1
    80003e48:	fce7e1e3          	bltu	a5,a4,80003e0a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80003e4c:	00004517          	auipc	a0,0x4
    80003e50:	7ec50513          	addi	a0,a0,2028 # 80008638 <syscalls+0x180>
    80003e54:	ffffc097          	auipc	ra,0xffffc
    80003e58:	734080e7          	jalr	1844(ra) # 80000588 <printf>
  return 0;
    80003e5c:	4501                	li	a0,0
}
    80003e5e:	60a6                	ld	ra,72(sp)
    80003e60:	6406                	ld	s0,64(sp)
    80003e62:	74e2                	ld	s1,56(sp)
    80003e64:	7942                	ld	s2,48(sp)
    80003e66:	79a2                	ld	s3,40(sp)
    80003e68:	7a02                	ld	s4,32(sp)
    80003e6a:	6ae2                	ld	s5,24(sp)
    80003e6c:	6b42                	ld	s6,16(sp)
    80003e6e:	6ba2                	ld	s7,8(sp)
    80003e70:	6161                	addi	sp,sp,80
    80003e72:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003e74:	04000613          	li	a2,64
    80003e78:	4581                	li	a1,0
    80003e7a:	854e                	mv	a0,s3
    80003e7c:	ffffd097          	auipc	ra,0xffffd
    80003e80:	036080e7          	jalr	54(ra) # 80000eb2 <memset>
      dip->type = type;
    80003e84:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003e88:	854a                	mv	a0,s2
    80003e8a:	00001097          	auipc	ra,0x1
    80003e8e:	c84080e7          	jalr	-892(ra) # 80004b0e <log_write>
      brelse(bp);
    80003e92:	854a                	mv	a0,s2
    80003e94:	00000097          	auipc	ra,0x0
    80003e98:	9f6080e7          	jalr	-1546(ra) # 8000388a <brelse>
      return iget(dev, inum);
    80003e9c:	85da                	mv	a1,s6
    80003e9e:	8556                	mv	a0,s5
    80003ea0:	00000097          	auipc	ra,0x0
    80003ea4:	d9c080e7          	jalr	-612(ra) # 80003c3c <iget>
    80003ea8:	bf5d                	j	80003e5e <ialloc+0x86>

0000000080003eaa <iupdate>:
{
    80003eaa:	1101                	addi	sp,sp,-32
    80003eac:	ec06                	sd	ra,24(sp)
    80003eae:	e822                	sd	s0,16(sp)
    80003eb0:	e426                	sd	s1,8(sp)
    80003eb2:	e04a                	sd	s2,0(sp)
    80003eb4:	1000                	addi	s0,sp,32
    80003eb6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003eb8:	415c                	lw	a5,4(a0)
    80003eba:	0047d79b          	srliw	a5,a5,0x4
    80003ebe:	0023c597          	auipc	a1,0x23c
    80003ec2:	c6a5a583          	lw	a1,-918(a1) # 8023fb28 <sb+0x18>
    80003ec6:	9dbd                	addw	a1,a1,a5
    80003ec8:	4108                	lw	a0,0(a0)
    80003eca:	00000097          	auipc	ra,0x0
    80003ece:	890080e7          	jalr	-1904(ra) # 8000375a <bread>
    80003ed2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ed4:	05850793          	addi	a5,a0,88
    80003ed8:	40c8                	lw	a0,4(s1)
    80003eda:	893d                	andi	a0,a0,15
    80003edc:	051a                	slli	a0,a0,0x6
    80003ede:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003ee0:	04449703          	lh	a4,68(s1)
    80003ee4:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80003ee8:	04649703          	lh	a4,70(s1)
    80003eec:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003ef0:	04849703          	lh	a4,72(s1)
    80003ef4:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003ef8:	04a49703          	lh	a4,74(s1)
    80003efc:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003f00:	44f8                	lw	a4,76(s1)
    80003f02:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003f04:	03400613          	li	a2,52
    80003f08:	05048593          	addi	a1,s1,80
    80003f0c:	0531                	addi	a0,a0,12
    80003f0e:	ffffd097          	auipc	ra,0xffffd
    80003f12:	000080e7          	jalr	ra # 80000f0e <memmove>
  log_write(bp);
    80003f16:	854a                	mv	a0,s2
    80003f18:	00001097          	auipc	ra,0x1
    80003f1c:	bf6080e7          	jalr	-1034(ra) # 80004b0e <log_write>
  brelse(bp);
    80003f20:	854a                	mv	a0,s2
    80003f22:	00000097          	auipc	ra,0x0
    80003f26:	968080e7          	jalr	-1688(ra) # 8000388a <brelse>
}
    80003f2a:	60e2                	ld	ra,24(sp)
    80003f2c:	6442                	ld	s0,16(sp)
    80003f2e:	64a2                	ld	s1,8(sp)
    80003f30:	6902                	ld	s2,0(sp)
    80003f32:	6105                	addi	sp,sp,32
    80003f34:	8082                	ret

0000000080003f36 <idup>:
{
    80003f36:	1101                	addi	sp,sp,-32
    80003f38:	ec06                	sd	ra,24(sp)
    80003f3a:	e822                	sd	s0,16(sp)
    80003f3c:	e426                	sd	s1,8(sp)
    80003f3e:	1000                	addi	s0,sp,32
    80003f40:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f42:	0023c517          	auipc	a0,0x23c
    80003f46:	bee50513          	addi	a0,a0,-1042 # 8023fb30 <itable>
    80003f4a:	ffffd097          	auipc	ra,0xffffd
    80003f4e:	e6c080e7          	jalr	-404(ra) # 80000db6 <acquire>
  ip->ref++;
    80003f52:	449c                	lw	a5,8(s1)
    80003f54:	2785                	addiw	a5,a5,1
    80003f56:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f58:	0023c517          	auipc	a0,0x23c
    80003f5c:	bd850513          	addi	a0,a0,-1064 # 8023fb30 <itable>
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	f0a080e7          	jalr	-246(ra) # 80000e6a <release>
}
    80003f68:	8526                	mv	a0,s1
    80003f6a:	60e2                	ld	ra,24(sp)
    80003f6c:	6442                	ld	s0,16(sp)
    80003f6e:	64a2                	ld	s1,8(sp)
    80003f70:	6105                	addi	sp,sp,32
    80003f72:	8082                	ret

0000000080003f74 <ilock>:
{
    80003f74:	1101                	addi	sp,sp,-32
    80003f76:	ec06                	sd	ra,24(sp)
    80003f78:	e822                	sd	s0,16(sp)
    80003f7a:	e426                	sd	s1,8(sp)
    80003f7c:	e04a                	sd	s2,0(sp)
    80003f7e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003f80:	c115                	beqz	a0,80003fa4 <ilock+0x30>
    80003f82:	84aa                	mv	s1,a0
    80003f84:	451c                	lw	a5,8(a0)
    80003f86:	00f05f63          	blez	a5,80003fa4 <ilock+0x30>
  acquiresleep(&ip->lock);
    80003f8a:	0541                	addi	a0,a0,16
    80003f8c:	00001097          	auipc	ra,0x1
    80003f90:	ca2080e7          	jalr	-862(ra) # 80004c2e <acquiresleep>
  if(ip->valid == 0){
    80003f94:	40bc                	lw	a5,64(s1)
    80003f96:	cf99                	beqz	a5,80003fb4 <ilock+0x40>
}
    80003f98:	60e2                	ld	ra,24(sp)
    80003f9a:	6442                	ld	s0,16(sp)
    80003f9c:	64a2                	ld	s1,8(sp)
    80003f9e:	6902                	ld	s2,0(sp)
    80003fa0:	6105                	addi	sp,sp,32
    80003fa2:	8082                	ret
    panic("ilock");
    80003fa4:	00004517          	auipc	a0,0x4
    80003fa8:	6ac50513          	addi	a0,a0,1708 # 80008650 <syscalls+0x198>
    80003fac:	ffffc097          	auipc	ra,0xffffc
    80003fb0:	592080e7          	jalr	1426(ra) # 8000053e <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003fb4:	40dc                	lw	a5,4(s1)
    80003fb6:	0047d79b          	srliw	a5,a5,0x4
    80003fba:	0023c597          	auipc	a1,0x23c
    80003fbe:	b6e5a583          	lw	a1,-1170(a1) # 8023fb28 <sb+0x18>
    80003fc2:	9dbd                	addw	a1,a1,a5
    80003fc4:	4088                	lw	a0,0(s1)
    80003fc6:	fffff097          	auipc	ra,0xfffff
    80003fca:	794080e7          	jalr	1940(ra) # 8000375a <bread>
    80003fce:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003fd0:	05850593          	addi	a1,a0,88
    80003fd4:	40dc                	lw	a5,4(s1)
    80003fd6:	8bbd                	andi	a5,a5,15
    80003fd8:	079a                	slli	a5,a5,0x6
    80003fda:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003fdc:	00059783          	lh	a5,0(a1)
    80003fe0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003fe4:	00259783          	lh	a5,2(a1)
    80003fe8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003fec:	00459783          	lh	a5,4(a1)
    80003ff0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003ff4:	00659783          	lh	a5,6(a1)
    80003ff8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003ffc:	459c                	lw	a5,8(a1)
    80003ffe:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004000:	03400613          	li	a2,52
    80004004:	05b1                	addi	a1,a1,12
    80004006:	05048513          	addi	a0,s1,80
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	f04080e7          	jalr	-252(ra) # 80000f0e <memmove>
    brelse(bp);
    80004012:	854a                	mv	a0,s2
    80004014:	00000097          	auipc	ra,0x0
    80004018:	876080e7          	jalr	-1930(ra) # 8000388a <brelse>
    ip->valid = 1;
    8000401c:	4785                	li	a5,1
    8000401e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004020:	04449783          	lh	a5,68(s1)
    80004024:	fbb5                	bnez	a5,80003f98 <ilock+0x24>
      panic("ilock: no type");
    80004026:	00004517          	auipc	a0,0x4
    8000402a:	63250513          	addi	a0,a0,1586 # 80008658 <syscalls+0x1a0>
    8000402e:	ffffc097          	auipc	ra,0xffffc
    80004032:	510080e7          	jalr	1296(ra) # 8000053e <panic>

0000000080004036 <iunlock>:
{
    80004036:	1101                	addi	sp,sp,-32
    80004038:	ec06                	sd	ra,24(sp)
    8000403a:	e822                	sd	s0,16(sp)
    8000403c:	e426                	sd	s1,8(sp)
    8000403e:	e04a                	sd	s2,0(sp)
    80004040:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004042:	c905                	beqz	a0,80004072 <iunlock+0x3c>
    80004044:	84aa                	mv	s1,a0
    80004046:	01050913          	addi	s2,a0,16
    8000404a:	854a                	mv	a0,s2
    8000404c:	00001097          	auipc	ra,0x1
    80004050:	c7c080e7          	jalr	-900(ra) # 80004cc8 <holdingsleep>
    80004054:	cd19                	beqz	a0,80004072 <iunlock+0x3c>
    80004056:	449c                	lw	a5,8(s1)
    80004058:	00f05d63          	blez	a5,80004072 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000405c:	854a                	mv	a0,s2
    8000405e:	00001097          	auipc	ra,0x1
    80004062:	c26080e7          	jalr	-986(ra) # 80004c84 <releasesleep>
}
    80004066:	60e2                	ld	ra,24(sp)
    80004068:	6442                	ld	s0,16(sp)
    8000406a:	64a2                	ld	s1,8(sp)
    8000406c:	6902                	ld	s2,0(sp)
    8000406e:	6105                	addi	sp,sp,32
    80004070:	8082                	ret
    panic("iunlock");
    80004072:	00004517          	auipc	a0,0x4
    80004076:	5f650513          	addi	a0,a0,1526 # 80008668 <syscalls+0x1b0>
    8000407a:	ffffc097          	auipc	ra,0xffffc
    8000407e:	4c4080e7          	jalr	1220(ra) # 8000053e <panic>

0000000080004082 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004082:	7179                	addi	sp,sp,-48
    80004084:	f406                	sd	ra,40(sp)
    80004086:	f022                	sd	s0,32(sp)
    80004088:	ec26                	sd	s1,24(sp)
    8000408a:	e84a                	sd	s2,16(sp)
    8000408c:	e44e                	sd	s3,8(sp)
    8000408e:	e052                	sd	s4,0(sp)
    80004090:	1800                	addi	s0,sp,48
    80004092:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004094:	05050493          	addi	s1,a0,80
    80004098:	08050913          	addi	s2,a0,128
    8000409c:	a021                	j	800040a4 <itrunc+0x22>
    8000409e:	0491                	addi	s1,s1,4
    800040a0:	01248d63          	beq	s1,s2,800040ba <itrunc+0x38>
    if(ip->addrs[i]){
    800040a4:	408c                	lw	a1,0(s1)
    800040a6:	dde5                	beqz	a1,8000409e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    800040a8:	0009a503          	lw	a0,0(s3)
    800040ac:	00000097          	auipc	ra,0x0
    800040b0:	8f4080e7          	jalr	-1804(ra) # 800039a0 <bfree>
      ip->addrs[i] = 0;
    800040b4:	0004a023          	sw	zero,0(s1)
    800040b8:	b7dd                	j	8000409e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    800040ba:	0809a583          	lw	a1,128(s3)
    800040be:	e185                	bnez	a1,800040de <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800040c0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800040c4:	854e                	mv	a0,s3
    800040c6:	00000097          	auipc	ra,0x0
    800040ca:	de4080e7          	jalr	-540(ra) # 80003eaa <iupdate>
}
    800040ce:	70a2                	ld	ra,40(sp)
    800040d0:	7402                	ld	s0,32(sp)
    800040d2:	64e2                	ld	s1,24(sp)
    800040d4:	6942                	ld	s2,16(sp)
    800040d6:	69a2                	ld	s3,8(sp)
    800040d8:	6a02                	ld	s4,0(sp)
    800040da:	6145                	addi	sp,sp,48
    800040dc:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800040de:	0009a503          	lw	a0,0(s3)
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	678080e7          	jalr	1656(ra) # 8000375a <bread>
    800040ea:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800040ec:	05850493          	addi	s1,a0,88
    800040f0:	45850913          	addi	s2,a0,1112
    800040f4:	a021                	j	800040fc <itrunc+0x7a>
    800040f6:	0491                	addi	s1,s1,4
    800040f8:	01248b63          	beq	s1,s2,8000410e <itrunc+0x8c>
      if(a[j])
    800040fc:	408c                	lw	a1,0(s1)
    800040fe:	dde5                	beqz	a1,800040f6 <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80004100:	0009a503          	lw	a0,0(s3)
    80004104:	00000097          	auipc	ra,0x0
    80004108:	89c080e7          	jalr	-1892(ra) # 800039a0 <bfree>
    8000410c:	b7ed                	j	800040f6 <itrunc+0x74>
    brelse(bp);
    8000410e:	8552                	mv	a0,s4
    80004110:	fffff097          	auipc	ra,0xfffff
    80004114:	77a080e7          	jalr	1914(ra) # 8000388a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004118:	0809a583          	lw	a1,128(s3)
    8000411c:	0009a503          	lw	a0,0(s3)
    80004120:	00000097          	auipc	ra,0x0
    80004124:	880080e7          	jalr	-1920(ra) # 800039a0 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004128:	0809a023          	sw	zero,128(s3)
    8000412c:	bf51                	j	800040c0 <itrunc+0x3e>

000000008000412e <iput>:
{
    8000412e:	1101                	addi	sp,sp,-32
    80004130:	ec06                	sd	ra,24(sp)
    80004132:	e822                	sd	s0,16(sp)
    80004134:	e426                	sd	s1,8(sp)
    80004136:	e04a                	sd	s2,0(sp)
    80004138:	1000                	addi	s0,sp,32
    8000413a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000413c:	0023c517          	auipc	a0,0x23c
    80004140:	9f450513          	addi	a0,a0,-1548 # 8023fb30 <itable>
    80004144:	ffffd097          	auipc	ra,0xffffd
    80004148:	c72080e7          	jalr	-910(ra) # 80000db6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000414c:	4498                	lw	a4,8(s1)
    8000414e:	4785                	li	a5,1
    80004150:	02f70363          	beq	a4,a5,80004176 <iput+0x48>
  ip->ref--;
    80004154:	449c                	lw	a5,8(s1)
    80004156:	37fd                	addiw	a5,a5,-1
    80004158:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000415a:	0023c517          	auipc	a0,0x23c
    8000415e:	9d650513          	addi	a0,a0,-1578 # 8023fb30 <itable>
    80004162:	ffffd097          	auipc	ra,0xffffd
    80004166:	d08080e7          	jalr	-760(ra) # 80000e6a <release>
}
    8000416a:	60e2                	ld	ra,24(sp)
    8000416c:	6442                	ld	s0,16(sp)
    8000416e:	64a2                	ld	s1,8(sp)
    80004170:	6902                	ld	s2,0(sp)
    80004172:	6105                	addi	sp,sp,32
    80004174:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004176:	40bc                	lw	a5,64(s1)
    80004178:	dff1                	beqz	a5,80004154 <iput+0x26>
    8000417a:	04a49783          	lh	a5,74(s1)
    8000417e:	fbf9                	bnez	a5,80004154 <iput+0x26>
    acquiresleep(&ip->lock);
    80004180:	01048913          	addi	s2,s1,16
    80004184:	854a                	mv	a0,s2
    80004186:	00001097          	auipc	ra,0x1
    8000418a:	aa8080e7          	jalr	-1368(ra) # 80004c2e <acquiresleep>
    release(&itable.lock);
    8000418e:	0023c517          	auipc	a0,0x23c
    80004192:	9a250513          	addi	a0,a0,-1630 # 8023fb30 <itable>
    80004196:	ffffd097          	auipc	ra,0xffffd
    8000419a:	cd4080e7          	jalr	-812(ra) # 80000e6a <release>
    itrunc(ip);
    8000419e:	8526                	mv	a0,s1
    800041a0:	00000097          	auipc	ra,0x0
    800041a4:	ee2080e7          	jalr	-286(ra) # 80004082 <itrunc>
    ip->type = 0;
    800041a8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800041ac:	8526                	mv	a0,s1
    800041ae:	00000097          	auipc	ra,0x0
    800041b2:	cfc080e7          	jalr	-772(ra) # 80003eaa <iupdate>
    ip->valid = 0;
    800041b6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800041ba:	854a                	mv	a0,s2
    800041bc:	00001097          	auipc	ra,0x1
    800041c0:	ac8080e7          	jalr	-1336(ra) # 80004c84 <releasesleep>
    acquire(&itable.lock);
    800041c4:	0023c517          	auipc	a0,0x23c
    800041c8:	96c50513          	addi	a0,a0,-1684 # 8023fb30 <itable>
    800041cc:	ffffd097          	auipc	ra,0xffffd
    800041d0:	bea080e7          	jalr	-1046(ra) # 80000db6 <acquire>
    800041d4:	b741                	j	80004154 <iput+0x26>

00000000800041d6 <iunlockput>:
{
    800041d6:	1101                	addi	sp,sp,-32
    800041d8:	ec06                	sd	ra,24(sp)
    800041da:	e822                	sd	s0,16(sp)
    800041dc:	e426                	sd	s1,8(sp)
    800041de:	1000                	addi	s0,sp,32
    800041e0:	84aa                	mv	s1,a0
  iunlock(ip);
    800041e2:	00000097          	auipc	ra,0x0
    800041e6:	e54080e7          	jalr	-428(ra) # 80004036 <iunlock>
  iput(ip);
    800041ea:	8526                	mv	a0,s1
    800041ec:	00000097          	auipc	ra,0x0
    800041f0:	f42080e7          	jalr	-190(ra) # 8000412e <iput>
}
    800041f4:	60e2                	ld	ra,24(sp)
    800041f6:	6442                	ld	s0,16(sp)
    800041f8:	64a2                	ld	s1,8(sp)
    800041fa:	6105                	addi	sp,sp,32
    800041fc:	8082                	ret

00000000800041fe <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800041fe:	1141                	addi	sp,sp,-16
    80004200:	e422                	sd	s0,8(sp)
    80004202:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004204:	411c                	lw	a5,0(a0)
    80004206:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80004208:	415c                	lw	a5,4(a0)
    8000420a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000420c:	04451783          	lh	a5,68(a0)
    80004210:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004214:	04a51783          	lh	a5,74(a0)
    80004218:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000421c:	04c56783          	lwu	a5,76(a0)
    80004220:	e99c                	sd	a5,16(a1)
}
    80004222:	6422                	ld	s0,8(sp)
    80004224:	0141                	addi	sp,sp,16
    80004226:	8082                	ret

0000000080004228 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004228:	457c                	lw	a5,76(a0)
    8000422a:	0ed7e963          	bltu	a5,a3,8000431c <readi+0xf4>
{
    8000422e:	7159                	addi	sp,sp,-112
    80004230:	f486                	sd	ra,104(sp)
    80004232:	f0a2                	sd	s0,96(sp)
    80004234:	eca6                	sd	s1,88(sp)
    80004236:	e8ca                	sd	s2,80(sp)
    80004238:	e4ce                	sd	s3,72(sp)
    8000423a:	e0d2                	sd	s4,64(sp)
    8000423c:	fc56                	sd	s5,56(sp)
    8000423e:	f85a                	sd	s6,48(sp)
    80004240:	f45e                	sd	s7,40(sp)
    80004242:	f062                	sd	s8,32(sp)
    80004244:	ec66                	sd	s9,24(sp)
    80004246:	e86a                	sd	s10,16(sp)
    80004248:	e46e                	sd	s11,8(sp)
    8000424a:	1880                	addi	s0,sp,112
    8000424c:	8b2a                	mv	s6,a0
    8000424e:	8bae                	mv	s7,a1
    80004250:	8a32                	mv	s4,a2
    80004252:	84b6                	mv	s1,a3
    80004254:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004256:	9f35                	addw	a4,a4,a3
    return 0;
    80004258:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000425a:	0ad76063          	bltu	a4,a3,800042fa <readi+0xd2>
  if(off + n > ip->size)
    8000425e:	00e7f463          	bgeu	a5,a4,80004266 <readi+0x3e>
    n = ip->size - off;
    80004262:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004266:	0a0a8963          	beqz	s5,80004318 <readi+0xf0>
    8000426a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000426c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004270:	5c7d                	li	s8,-1
    80004272:	a82d                	j	800042ac <readi+0x84>
    80004274:	020d1d93          	slli	s11,s10,0x20
    80004278:	020ddd93          	srli	s11,s11,0x20
    8000427c:	05890793          	addi	a5,s2,88
    80004280:	86ee                	mv	a3,s11
    80004282:	963e                	add	a2,a2,a5
    80004284:	85d2                	mv	a1,s4
    80004286:	855e                	mv	a0,s7
    80004288:	ffffe097          	auipc	ra,0xffffe
    8000428c:	734080e7          	jalr	1844(ra) # 800029bc <either_copyout>
    80004290:	05850d63          	beq	a0,s8,800042ea <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004294:	854a                	mv	a0,s2
    80004296:	fffff097          	auipc	ra,0xfffff
    8000429a:	5f4080e7          	jalr	1524(ra) # 8000388a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000429e:	013d09bb          	addw	s3,s10,s3
    800042a2:	009d04bb          	addw	s1,s10,s1
    800042a6:	9a6e                	add	s4,s4,s11
    800042a8:	0559f763          	bgeu	s3,s5,800042f6 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800042ac:	00a4d59b          	srliw	a1,s1,0xa
    800042b0:	855a                	mv	a0,s6
    800042b2:	00000097          	auipc	ra,0x0
    800042b6:	8a2080e7          	jalr	-1886(ra) # 80003b54 <bmap>
    800042ba:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800042be:	cd85                	beqz	a1,800042f6 <readi+0xce>
    bp = bread(ip->dev, addr);
    800042c0:	000b2503          	lw	a0,0(s6)
    800042c4:	fffff097          	auipc	ra,0xfffff
    800042c8:	496080e7          	jalr	1174(ra) # 8000375a <bread>
    800042cc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800042ce:	3ff4f613          	andi	a2,s1,1023
    800042d2:	40cc87bb          	subw	a5,s9,a2
    800042d6:	413a873b          	subw	a4,s5,s3
    800042da:	8d3e                	mv	s10,a5
    800042dc:	2781                	sext.w	a5,a5
    800042de:	0007069b          	sext.w	a3,a4
    800042e2:	f8f6f9e3          	bgeu	a3,a5,80004274 <readi+0x4c>
    800042e6:	8d3a                	mv	s10,a4
    800042e8:	b771                	j	80004274 <readi+0x4c>
      brelse(bp);
    800042ea:	854a                	mv	a0,s2
    800042ec:	fffff097          	auipc	ra,0xfffff
    800042f0:	59e080e7          	jalr	1438(ra) # 8000388a <brelse>
      tot = -1;
    800042f4:	59fd                	li	s3,-1
  }
  return tot;
    800042f6:	0009851b          	sext.w	a0,s3
}
    800042fa:	70a6                	ld	ra,104(sp)
    800042fc:	7406                	ld	s0,96(sp)
    800042fe:	64e6                	ld	s1,88(sp)
    80004300:	6946                	ld	s2,80(sp)
    80004302:	69a6                	ld	s3,72(sp)
    80004304:	6a06                	ld	s4,64(sp)
    80004306:	7ae2                	ld	s5,56(sp)
    80004308:	7b42                	ld	s6,48(sp)
    8000430a:	7ba2                	ld	s7,40(sp)
    8000430c:	7c02                	ld	s8,32(sp)
    8000430e:	6ce2                	ld	s9,24(sp)
    80004310:	6d42                	ld	s10,16(sp)
    80004312:	6da2                	ld	s11,8(sp)
    80004314:	6165                	addi	sp,sp,112
    80004316:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004318:	89d6                	mv	s3,s5
    8000431a:	bff1                	j	800042f6 <readi+0xce>
    return 0;
    8000431c:	4501                	li	a0,0
}
    8000431e:	8082                	ret

0000000080004320 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004320:	457c                	lw	a5,76(a0)
    80004322:	10d7e863          	bltu	a5,a3,80004432 <writei+0x112>
{
    80004326:	7159                	addi	sp,sp,-112
    80004328:	f486                	sd	ra,104(sp)
    8000432a:	f0a2                	sd	s0,96(sp)
    8000432c:	eca6                	sd	s1,88(sp)
    8000432e:	e8ca                	sd	s2,80(sp)
    80004330:	e4ce                	sd	s3,72(sp)
    80004332:	e0d2                	sd	s4,64(sp)
    80004334:	fc56                	sd	s5,56(sp)
    80004336:	f85a                	sd	s6,48(sp)
    80004338:	f45e                	sd	s7,40(sp)
    8000433a:	f062                	sd	s8,32(sp)
    8000433c:	ec66                	sd	s9,24(sp)
    8000433e:	e86a                	sd	s10,16(sp)
    80004340:	e46e                	sd	s11,8(sp)
    80004342:	1880                	addi	s0,sp,112
    80004344:	8aaa                	mv	s5,a0
    80004346:	8bae                	mv	s7,a1
    80004348:	8a32                	mv	s4,a2
    8000434a:	8936                	mv	s2,a3
    8000434c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000434e:	00e687bb          	addw	a5,a3,a4
    80004352:	0ed7e263          	bltu	a5,a3,80004436 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80004356:	00043737          	lui	a4,0x43
    8000435a:	0ef76063          	bltu	a4,a5,8000443a <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000435e:	0c0b0863          	beqz	s6,8000442e <writei+0x10e>
    80004362:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004364:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004368:	5c7d                	li	s8,-1
    8000436a:	a091                	j	800043ae <writei+0x8e>
    8000436c:	020d1d93          	slli	s11,s10,0x20
    80004370:	020ddd93          	srli	s11,s11,0x20
    80004374:	05848793          	addi	a5,s1,88
    80004378:	86ee                	mv	a3,s11
    8000437a:	8652                	mv	a2,s4
    8000437c:	85de                	mv	a1,s7
    8000437e:	953e                	add	a0,a0,a5
    80004380:	ffffe097          	auipc	ra,0xffffe
    80004384:	692080e7          	jalr	1682(ra) # 80002a12 <either_copyin>
    80004388:	07850263          	beq	a0,s8,800043ec <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000438c:	8526                	mv	a0,s1
    8000438e:	00000097          	auipc	ra,0x0
    80004392:	780080e7          	jalr	1920(ra) # 80004b0e <log_write>
    brelse(bp);
    80004396:	8526                	mv	a0,s1
    80004398:	fffff097          	auipc	ra,0xfffff
    8000439c:	4f2080e7          	jalr	1266(ra) # 8000388a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043a0:	013d09bb          	addw	s3,s10,s3
    800043a4:	012d093b          	addw	s2,s10,s2
    800043a8:	9a6e                	add	s4,s4,s11
    800043aa:	0569f663          	bgeu	s3,s6,800043f6 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800043ae:	00a9559b          	srliw	a1,s2,0xa
    800043b2:	8556                	mv	a0,s5
    800043b4:	fffff097          	auipc	ra,0xfffff
    800043b8:	7a0080e7          	jalr	1952(ra) # 80003b54 <bmap>
    800043bc:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800043c0:	c99d                	beqz	a1,800043f6 <writei+0xd6>
    bp = bread(ip->dev, addr);
    800043c2:	000aa503          	lw	a0,0(s5)
    800043c6:	fffff097          	auipc	ra,0xfffff
    800043ca:	394080e7          	jalr	916(ra) # 8000375a <bread>
    800043ce:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800043d0:	3ff97513          	andi	a0,s2,1023
    800043d4:	40ac87bb          	subw	a5,s9,a0
    800043d8:	413b073b          	subw	a4,s6,s3
    800043dc:	8d3e                	mv	s10,a5
    800043de:	2781                	sext.w	a5,a5
    800043e0:	0007069b          	sext.w	a3,a4
    800043e4:	f8f6f4e3          	bgeu	a3,a5,8000436c <writei+0x4c>
    800043e8:	8d3a                	mv	s10,a4
    800043ea:	b749                	j	8000436c <writei+0x4c>
      brelse(bp);
    800043ec:	8526                	mv	a0,s1
    800043ee:	fffff097          	auipc	ra,0xfffff
    800043f2:	49c080e7          	jalr	1180(ra) # 8000388a <brelse>
  }

  if(off > ip->size)
    800043f6:	04caa783          	lw	a5,76(s5)
    800043fa:	0127f463          	bgeu	a5,s2,80004402 <writei+0xe2>
    ip->size = off;
    800043fe:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004402:	8556                	mv	a0,s5
    80004404:	00000097          	auipc	ra,0x0
    80004408:	aa6080e7          	jalr	-1370(ra) # 80003eaa <iupdate>

  return tot;
    8000440c:	0009851b          	sext.w	a0,s3
}
    80004410:	70a6                	ld	ra,104(sp)
    80004412:	7406                	ld	s0,96(sp)
    80004414:	64e6                	ld	s1,88(sp)
    80004416:	6946                	ld	s2,80(sp)
    80004418:	69a6                	ld	s3,72(sp)
    8000441a:	6a06                	ld	s4,64(sp)
    8000441c:	7ae2                	ld	s5,56(sp)
    8000441e:	7b42                	ld	s6,48(sp)
    80004420:	7ba2                	ld	s7,40(sp)
    80004422:	7c02                	ld	s8,32(sp)
    80004424:	6ce2                	ld	s9,24(sp)
    80004426:	6d42                	ld	s10,16(sp)
    80004428:	6da2                	ld	s11,8(sp)
    8000442a:	6165                	addi	sp,sp,112
    8000442c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000442e:	89da                	mv	s3,s6
    80004430:	bfc9                	j	80004402 <writei+0xe2>
    return -1;
    80004432:	557d                	li	a0,-1
}
    80004434:	8082                	ret
    return -1;
    80004436:	557d                	li	a0,-1
    80004438:	bfe1                	j	80004410 <writei+0xf0>
    return -1;
    8000443a:	557d                	li	a0,-1
    8000443c:	bfd1                	j	80004410 <writei+0xf0>

000000008000443e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000443e:	1141                	addi	sp,sp,-16
    80004440:	e406                	sd	ra,8(sp)
    80004442:	e022                	sd	s0,0(sp)
    80004444:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004446:	4639                	li	a2,14
    80004448:	ffffd097          	auipc	ra,0xffffd
    8000444c:	b3a080e7          	jalr	-1222(ra) # 80000f82 <strncmp>
}
    80004450:	60a2                	ld	ra,8(sp)
    80004452:	6402                	ld	s0,0(sp)
    80004454:	0141                	addi	sp,sp,16
    80004456:	8082                	ret

0000000080004458 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004458:	7139                	addi	sp,sp,-64
    8000445a:	fc06                	sd	ra,56(sp)
    8000445c:	f822                	sd	s0,48(sp)
    8000445e:	f426                	sd	s1,40(sp)
    80004460:	f04a                	sd	s2,32(sp)
    80004462:	ec4e                	sd	s3,24(sp)
    80004464:	e852                	sd	s4,16(sp)
    80004466:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004468:	04451703          	lh	a4,68(a0)
    8000446c:	4785                	li	a5,1
    8000446e:	00f71a63          	bne	a4,a5,80004482 <dirlookup+0x2a>
    80004472:	892a                	mv	s2,a0
    80004474:	89ae                	mv	s3,a1
    80004476:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004478:	457c                	lw	a5,76(a0)
    8000447a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000447c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000447e:	e79d                	bnez	a5,800044ac <dirlookup+0x54>
    80004480:	a8a5                	j	800044f8 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80004482:	00004517          	auipc	a0,0x4
    80004486:	1ee50513          	addi	a0,a0,494 # 80008670 <syscalls+0x1b8>
    8000448a:	ffffc097          	auipc	ra,0xffffc
    8000448e:	0b4080e7          	jalr	180(ra) # 8000053e <panic>
      panic("dirlookup read");
    80004492:	00004517          	auipc	a0,0x4
    80004496:	1f650513          	addi	a0,a0,502 # 80008688 <syscalls+0x1d0>
    8000449a:	ffffc097          	auipc	ra,0xffffc
    8000449e:	0a4080e7          	jalr	164(ra) # 8000053e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044a2:	24c1                	addiw	s1,s1,16
    800044a4:	04c92783          	lw	a5,76(s2)
    800044a8:	04f4f763          	bgeu	s1,a5,800044f6 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044ac:	4741                	li	a4,16
    800044ae:	86a6                	mv	a3,s1
    800044b0:	fc040613          	addi	a2,s0,-64
    800044b4:	4581                	li	a1,0
    800044b6:	854a                	mv	a0,s2
    800044b8:	00000097          	auipc	ra,0x0
    800044bc:	d70080e7          	jalr	-656(ra) # 80004228 <readi>
    800044c0:	47c1                	li	a5,16
    800044c2:	fcf518e3          	bne	a0,a5,80004492 <dirlookup+0x3a>
    if(de.inum == 0)
    800044c6:	fc045783          	lhu	a5,-64(s0)
    800044ca:	dfe1                	beqz	a5,800044a2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800044cc:	fc240593          	addi	a1,s0,-62
    800044d0:	854e                	mv	a0,s3
    800044d2:	00000097          	auipc	ra,0x0
    800044d6:	f6c080e7          	jalr	-148(ra) # 8000443e <namecmp>
    800044da:	f561                	bnez	a0,800044a2 <dirlookup+0x4a>
      if(poff)
    800044dc:	000a0463          	beqz	s4,800044e4 <dirlookup+0x8c>
        *poff = off;
    800044e0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800044e4:	fc045583          	lhu	a1,-64(s0)
    800044e8:	00092503          	lw	a0,0(s2)
    800044ec:	fffff097          	auipc	ra,0xfffff
    800044f0:	750080e7          	jalr	1872(ra) # 80003c3c <iget>
    800044f4:	a011                	j	800044f8 <dirlookup+0xa0>
  return 0;
    800044f6:	4501                	li	a0,0
}
    800044f8:	70e2                	ld	ra,56(sp)
    800044fa:	7442                	ld	s0,48(sp)
    800044fc:	74a2                	ld	s1,40(sp)
    800044fe:	7902                	ld	s2,32(sp)
    80004500:	69e2                	ld	s3,24(sp)
    80004502:	6a42                	ld	s4,16(sp)
    80004504:	6121                	addi	sp,sp,64
    80004506:	8082                	ret

0000000080004508 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004508:	711d                	addi	sp,sp,-96
    8000450a:	ec86                	sd	ra,88(sp)
    8000450c:	e8a2                	sd	s0,80(sp)
    8000450e:	e4a6                	sd	s1,72(sp)
    80004510:	e0ca                	sd	s2,64(sp)
    80004512:	fc4e                	sd	s3,56(sp)
    80004514:	f852                	sd	s4,48(sp)
    80004516:	f456                	sd	s5,40(sp)
    80004518:	f05a                	sd	s6,32(sp)
    8000451a:	ec5e                	sd	s7,24(sp)
    8000451c:	e862                	sd	s8,16(sp)
    8000451e:	e466                	sd	s9,8(sp)
    80004520:	1080                	addi	s0,sp,96
    80004522:	84aa                	mv	s1,a0
    80004524:	8aae                	mv	s5,a1
    80004526:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004528:	00054703          	lbu	a4,0(a0)
    8000452c:	02f00793          	li	a5,47
    80004530:	02f70363          	beq	a4,a5,80004556 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004534:	ffffd097          	auipc	ra,0xffffd
    80004538:	744080e7          	jalr	1860(ra) # 80001c78 <myproc>
    8000453c:	15053503          	ld	a0,336(a0)
    80004540:	00000097          	auipc	ra,0x0
    80004544:	9f6080e7          	jalr	-1546(ra) # 80003f36 <idup>
    80004548:	89aa                	mv	s3,a0
  while(*path == '/')
    8000454a:	02f00913          	li	s2,47
  len = path - s;
    8000454e:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80004550:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004552:	4b85                	li	s7,1
    80004554:	a865                	j	8000460c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80004556:	4585                	li	a1,1
    80004558:	4505                	li	a0,1
    8000455a:	fffff097          	auipc	ra,0xfffff
    8000455e:	6e2080e7          	jalr	1762(ra) # 80003c3c <iget>
    80004562:	89aa                	mv	s3,a0
    80004564:	b7dd                	j	8000454a <namex+0x42>
      iunlockput(ip);
    80004566:	854e                	mv	a0,s3
    80004568:	00000097          	auipc	ra,0x0
    8000456c:	c6e080e7          	jalr	-914(ra) # 800041d6 <iunlockput>
      return 0;
    80004570:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004572:	854e                	mv	a0,s3
    80004574:	60e6                	ld	ra,88(sp)
    80004576:	6446                	ld	s0,80(sp)
    80004578:	64a6                	ld	s1,72(sp)
    8000457a:	6906                	ld	s2,64(sp)
    8000457c:	79e2                	ld	s3,56(sp)
    8000457e:	7a42                	ld	s4,48(sp)
    80004580:	7aa2                	ld	s5,40(sp)
    80004582:	7b02                	ld	s6,32(sp)
    80004584:	6be2                	ld	s7,24(sp)
    80004586:	6c42                	ld	s8,16(sp)
    80004588:	6ca2                	ld	s9,8(sp)
    8000458a:	6125                	addi	sp,sp,96
    8000458c:	8082                	ret
      iunlock(ip);
    8000458e:	854e                	mv	a0,s3
    80004590:	00000097          	auipc	ra,0x0
    80004594:	aa6080e7          	jalr	-1370(ra) # 80004036 <iunlock>
      return ip;
    80004598:	bfe9                	j	80004572 <namex+0x6a>
      iunlockput(ip);
    8000459a:	854e                	mv	a0,s3
    8000459c:	00000097          	auipc	ra,0x0
    800045a0:	c3a080e7          	jalr	-966(ra) # 800041d6 <iunlockput>
      return 0;
    800045a4:	89e6                	mv	s3,s9
    800045a6:	b7f1                	j	80004572 <namex+0x6a>
  len = path - s;
    800045a8:	40b48633          	sub	a2,s1,a1
    800045ac:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800045b0:	099c5463          	bge	s8,s9,80004638 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800045b4:	4639                	li	a2,14
    800045b6:	8552                	mv	a0,s4
    800045b8:	ffffd097          	auipc	ra,0xffffd
    800045bc:	956080e7          	jalr	-1706(ra) # 80000f0e <memmove>
  while(*path == '/')
    800045c0:	0004c783          	lbu	a5,0(s1)
    800045c4:	01279763          	bne	a5,s2,800045d2 <namex+0xca>
    path++;
    800045c8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800045ca:	0004c783          	lbu	a5,0(s1)
    800045ce:	ff278de3          	beq	a5,s2,800045c8 <namex+0xc0>
    ilock(ip);
    800045d2:	854e                	mv	a0,s3
    800045d4:	00000097          	auipc	ra,0x0
    800045d8:	9a0080e7          	jalr	-1632(ra) # 80003f74 <ilock>
    if(ip->type != T_DIR){
    800045dc:	04499783          	lh	a5,68(s3)
    800045e0:	f97793e3          	bne	a5,s7,80004566 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800045e4:	000a8563          	beqz	s5,800045ee <namex+0xe6>
    800045e8:	0004c783          	lbu	a5,0(s1)
    800045ec:	d3cd                	beqz	a5,8000458e <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800045ee:	865a                	mv	a2,s6
    800045f0:	85d2                	mv	a1,s4
    800045f2:	854e                	mv	a0,s3
    800045f4:	00000097          	auipc	ra,0x0
    800045f8:	e64080e7          	jalr	-412(ra) # 80004458 <dirlookup>
    800045fc:	8caa                	mv	s9,a0
    800045fe:	dd51                	beqz	a0,8000459a <namex+0x92>
    iunlockput(ip);
    80004600:	854e                	mv	a0,s3
    80004602:	00000097          	auipc	ra,0x0
    80004606:	bd4080e7          	jalr	-1068(ra) # 800041d6 <iunlockput>
    ip = next;
    8000460a:	89e6                	mv	s3,s9
  while(*path == '/')
    8000460c:	0004c783          	lbu	a5,0(s1)
    80004610:	05279763          	bne	a5,s2,8000465e <namex+0x156>
    path++;
    80004614:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004616:	0004c783          	lbu	a5,0(s1)
    8000461a:	ff278de3          	beq	a5,s2,80004614 <namex+0x10c>
  if(*path == 0)
    8000461e:	c79d                	beqz	a5,8000464c <namex+0x144>
    path++;
    80004620:	85a6                	mv	a1,s1
  len = path - s;
    80004622:	8cda                	mv	s9,s6
    80004624:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80004626:	01278963          	beq	a5,s2,80004638 <namex+0x130>
    8000462a:	dfbd                	beqz	a5,800045a8 <namex+0xa0>
    path++;
    8000462c:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    8000462e:	0004c783          	lbu	a5,0(s1)
    80004632:	ff279ce3          	bne	a5,s2,8000462a <namex+0x122>
    80004636:	bf8d                	j	800045a8 <namex+0xa0>
    memmove(name, s, len);
    80004638:	2601                	sext.w	a2,a2
    8000463a:	8552                	mv	a0,s4
    8000463c:	ffffd097          	auipc	ra,0xffffd
    80004640:	8d2080e7          	jalr	-1838(ra) # 80000f0e <memmove>
    name[len] = 0;
    80004644:	9cd2                	add	s9,s9,s4
    80004646:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000464a:	bf9d                	j	800045c0 <namex+0xb8>
  if(nameiparent){
    8000464c:	f20a83e3          	beqz	s5,80004572 <namex+0x6a>
    iput(ip);
    80004650:	854e                	mv	a0,s3
    80004652:	00000097          	auipc	ra,0x0
    80004656:	adc080e7          	jalr	-1316(ra) # 8000412e <iput>
    return 0;
    8000465a:	4981                	li	s3,0
    8000465c:	bf19                	j	80004572 <namex+0x6a>
  if(*path == 0)
    8000465e:	d7fd                	beqz	a5,8000464c <namex+0x144>
  while(*path != '/' && *path != 0)
    80004660:	0004c783          	lbu	a5,0(s1)
    80004664:	85a6                	mv	a1,s1
    80004666:	b7d1                	j	8000462a <namex+0x122>

0000000080004668 <dirlink>:
{
    80004668:	7139                	addi	sp,sp,-64
    8000466a:	fc06                	sd	ra,56(sp)
    8000466c:	f822                	sd	s0,48(sp)
    8000466e:	f426                	sd	s1,40(sp)
    80004670:	f04a                	sd	s2,32(sp)
    80004672:	ec4e                	sd	s3,24(sp)
    80004674:	e852                	sd	s4,16(sp)
    80004676:	0080                	addi	s0,sp,64
    80004678:	892a                	mv	s2,a0
    8000467a:	8a2e                	mv	s4,a1
    8000467c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000467e:	4601                	li	a2,0
    80004680:	00000097          	auipc	ra,0x0
    80004684:	dd8080e7          	jalr	-552(ra) # 80004458 <dirlookup>
    80004688:	e93d                	bnez	a0,800046fe <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000468a:	04c92483          	lw	s1,76(s2)
    8000468e:	c49d                	beqz	s1,800046bc <dirlink+0x54>
    80004690:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004692:	4741                	li	a4,16
    80004694:	86a6                	mv	a3,s1
    80004696:	fc040613          	addi	a2,s0,-64
    8000469a:	4581                	li	a1,0
    8000469c:	854a                	mv	a0,s2
    8000469e:	00000097          	auipc	ra,0x0
    800046a2:	b8a080e7          	jalr	-1142(ra) # 80004228 <readi>
    800046a6:	47c1                	li	a5,16
    800046a8:	06f51163          	bne	a0,a5,8000470a <dirlink+0xa2>
    if(de.inum == 0)
    800046ac:	fc045783          	lhu	a5,-64(s0)
    800046b0:	c791                	beqz	a5,800046bc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800046b2:	24c1                	addiw	s1,s1,16
    800046b4:	04c92783          	lw	a5,76(s2)
    800046b8:	fcf4ede3          	bltu	s1,a5,80004692 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800046bc:	4639                	li	a2,14
    800046be:	85d2                	mv	a1,s4
    800046c0:	fc240513          	addi	a0,s0,-62
    800046c4:	ffffd097          	auipc	ra,0xffffd
    800046c8:	8fa080e7          	jalr	-1798(ra) # 80000fbe <strncpy>
  de.inum = inum;
    800046cc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800046d0:	4741                	li	a4,16
    800046d2:	86a6                	mv	a3,s1
    800046d4:	fc040613          	addi	a2,s0,-64
    800046d8:	4581                	li	a1,0
    800046da:	854a                	mv	a0,s2
    800046dc:	00000097          	auipc	ra,0x0
    800046e0:	c44080e7          	jalr	-956(ra) # 80004320 <writei>
    800046e4:	1541                	addi	a0,a0,-16
    800046e6:	00a03533          	snez	a0,a0
    800046ea:	40a00533          	neg	a0,a0
}
    800046ee:	70e2                	ld	ra,56(sp)
    800046f0:	7442                	ld	s0,48(sp)
    800046f2:	74a2                	ld	s1,40(sp)
    800046f4:	7902                	ld	s2,32(sp)
    800046f6:	69e2                	ld	s3,24(sp)
    800046f8:	6a42                	ld	s4,16(sp)
    800046fa:	6121                	addi	sp,sp,64
    800046fc:	8082                	ret
    iput(ip);
    800046fe:	00000097          	auipc	ra,0x0
    80004702:	a30080e7          	jalr	-1488(ra) # 8000412e <iput>
    return -1;
    80004706:	557d                	li	a0,-1
    80004708:	b7dd                	j	800046ee <dirlink+0x86>
      panic("dirlink read");
    8000470a:	00004517          	auipc	a0,0x4
    8000470e:	f8e50513          	addi	a0,a0,-114 # 80008698 <syscalls+0x1e0>
    80004712:	ffffc097          	auipc	ra,0xffffc
    80004716:	e2c080e7          	jalr	-468(ra) # 8000053e <panic>

000000008000471a <namei>:

struct inode*
namei(char *path)
{
    8000471a:	1101                	addi	sp,sp,-32
    8000471c:	ec06                	sd	ra,24(sp)
    8000471e:	e822                	sd	s0,16(sp)
    80004720:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004722:	fe040613          	addi	a2,s0,-32
    80004726:	4581                	li	a1,0
    80004728:	00000097          	auipc	ra,0x0
    8000472c:	de0080e7          	jalr	-544(ra) # 80004508 <namex>
}
    80004730:	60e2                	ld	ra,24(sp)
    80004732:	6442                	ld	s0,16(sp)
    80004734:	6105                	addi	sp,sp,32
    80004736:	8082                	ret

0000000080004738 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004738:	1141                	addi	sp,sp,-16
    8000473a:	e406                	sd	ra,8(sp)
    8000473c:	e022                	sd	s0,0(sp)
    8000473e:	0800                	addi	s0,sp,16
    80004740:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004742:	4585                	li	a1,1
    80004744:	00000097          	auipc	ra,0x0
    80004748:	dc4080e7          	jalr	-572(ra) # 80004508 <namex>
}
    8000474c:	60a2                	ld	ra,8(sp)
    8000474e:	6402                	ld	s0,0(sp)
    80004750:	0141                	addi	sp,sp,16
    80004752:	8082                	ret

0000000080004754 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004754:	1101                	addi	sp,sp,-32
    80004756:	ec06                	sd	ra,24(sp)
    80004758:	e822                	sd	s0,16(sp)
    8000475a:	e426                	sd	s1,8(sp)
    8000475c:	e04a                	sd	s2,0(sp)
    8000475e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004760:	0023d917          	auipc	s2,0x23d
    80004764:	e7890913          	addi	s2,s2,-392 # 802415d8 <log>
    80004768:	01892583          	lw	a1,24(s2)
    8000476c:	02892503          	lw	a0,40(s2)
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	fea080e7          	jalr	-22(ra) # 8000375a <bread>
    80004778:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000477a:	02c92683          	lw	a3,44(s2)
    8000477e:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004780:	02d05763          	blez	a3,800047ae <write_head+0x5a>
    80004784:	0023d797          	auipc	a5,0x23d
    80004788:	e8478793          	addi	a5,a5,-380 # 80241608 <log+0x30>
    8000478c:	05c50713          	addi	a4,a0,92
    80004790:	36fd                	addiw	a3,a3,-1
    80004792:	1682                	slli	a3,a3,0x20
    80004794:	9281                	srli	a3,a3,0x20
    80004796:	068a                	slli	a3,a3,0x2
    80004798:	0023d617          	auipc	a2,0x23d
    8000479c:	e7460613          	addi	a2,a2,-396 # 8024160c <log+0x34>
    800047a0:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800047a2:	4390                	lw	a2,0(a5)
    800047a4:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800047a6:	0791                	addi	a5,a5,4
    800047a8:	0711                	addi	a4,a4,4
    800047aa:	fed79ce3          	bne	a5,a3,800047a2 <write_head+0x4e>
  }
  bwrite(buf);
    800047ae:	8526                	mv	a0,s1
    800047b0:	fffff097          	auipc	ra,0xfffff
    800047b4:	09c080e7          	jalr	156(ra) # 8000384c <bwrite>
  brelse(buf);
    800047b8:	8526                	mv	a0,s1
    800047ba:	fffff097          	auipc	ra,0xfffff
    800047be:	0d0080e7          	jalr	208(ra) # 8000388a <brelse>
}
    800047c2:	60e2                	ld	ra,24(sp)
    800047c4:	6442                	ld	s0,16(sp)
    800047c6:	64a2                	ld	s1,8(sp)
    800047c8:	6902                	ld	s2,0(sp)
    800047ca:	6105                	addi	sp,sp,32
    800047cc:	8082                	ret

00000000800047ce <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800047ce:	0023d797          	auipc	a5,0x23d
    800047d2:	e367a783          	lw	a5,-458(a5) # 80241604 <log+0x2c>
    800047d6:	0af05d63          	blez	a5,80004890 <install_trans+0xc2>
{
    800047da:	7139                	addi	sp,sp,-64
    800047dc:	fc06                	sd	ra,56(sp)
    800047de:	f822                	sd	s0,48(sp)
    800047e0:	f426                	sd	s1,40(sp)
    800047e2:	f04a                	sd	s2,32(sp)
    800047e4:	ec4e                	sd	s3,24(sp)
    800047e6:	e852                	sd	s4,16(sp)
    800047e8:	e456                	sd	s5,8(sp)
    800047ea:	e05a                	sd	s6,0(sp)
    800047ec:	0080                	addi	s0,sp,64
    800047ee:	8b2a                	mv	s6,a0
    800047f0:	0023da97          	auipc	s5,0x23d
    800047f4:	e18a8a93          	addi	s5,s5,-488 # 80241608 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047f8:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800047fa:	0023d997          	auipc	s3,0x23d
    800047fe:	dde98993          	addi	s3,s3,-546 # 802415d8 <log>
    80004802:	a00d                	j	80004824 <install_trans+0x56>
    brelse(lbuf);
    80004804:	854a                	mv	a0,s2
    80004806:	fffff097          	auipc	ra,0xfffff
    8000480a:	084080e7          	jalr	132(ra) # 8000388a <brelse>
    brelse(dbuf);
    8000480e:	8526                	mv	a0,s1
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	07a080e7          	jalr	122(ra) # 8000388a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004818:	2a05                	addiw	s4,s4,1
    8000481a:	0a91                	addi	s5,s5,4
    8000481c:	02c9a783          	lw	a5,44(s3)
    80004820:	04fa5e63          	bge	s4,a5,8000487c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004824:	0189a583          	lw	a1,24(s3)
    80004828:	014585bb          	addw	a1,a1,s4
    8000482c:	2585                	addiw	a1,a1,1
    8000482e:	0289a503          	lw	a0,40(s3)
    80004832:	fffff097          	auipc	ra,0xfffff
    80004836:	f28080e7          	jalr	-216(ra) # 8000375a <bread>
    8000483a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000483c:	000aa583          	lw	a1,0(s5)
    80004840:	0289a503          	lw	a0,40(s3)
    80004844:	fffff097          	auipc	ra,0xfffff
    80004848:	f16080e7          	jalr	-234(ra) # 8000375a <bread>
    8000484c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000484e:	40000613          	li	a2,1024
    80004852:	05890593          	addi	a1,s2,88
    80004856:	05850513          	addi	a0,a0,88
    8000485a:	ffffc097          	auipc	ra,0xffffc
    8000485e:	6b4080e7          	jalr	1716(ra) # 80000f0e <memmove>
    bwrite(dbuf);  // write dst to disk
    80004862:	8526                	mv	a0,s1
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	fe8080e7          	jalr	-24(ra) # 8000384c <bwrite>
    if(recovering == 0)
    8000486c:	f80b1ce3          	bnez	s6,80004804 <install_trans+0x36>
      bunpin(dbuf);
    80004870:	8526                	mv	a0,s1
    80004872:	fffff097          	auipc	ra,0xfffff
    80004876:	0f2080e7          	jalr	242(ra) # 80003964 <bunpin>
    8000487a:	b769                	j	80004804 <install_trans+0x36>
}
    8000487c:	70e2                	ld	ra,56(sp)
    8000487e:	7442                	ld	s0,48(sp)
    80004880:	74a2                	ld	s1,40(sp)
    80004882:	7902                	ld	s2,32(sp)
    80004884:	69e2                	ld	s3,24(sp)
    80004886:	6a42                	ld	s4,16(sp)
    80004888:	6aa2                	ld	s5,8(sp)
    8000488a:	6b02                	ld	s6,0(sp)
    8000488c:	6121                	addi	sp,sp,64
    8000488e:	8082                	ret
    80004890:	8082                	ret

0000000080004892 <initlog>:
{
    80004892:	7179                	addi	sp,sp,-48
    80004894:	f406                	sd	ra,40(sp)
    80004896:	f022                	sd	s0,32(sp)
    80004898:	ec26                	sd	s1,24(sp)
    8000489a:	e84a                	sd	s2,16(sp)
    8000489c:	e44e                	sd	s3,8(sp)
    8000489e:	1800                	addi	s0,sp,48
    800048a0:	892a                	mv	s2,a0
    800048a2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800048a4:	0023d497          	auipc	s1,0x23d
    800048a8:	d3448493          	addi	s1,s1,-716 # 802415d8 <log>
    800048ac:	00004597          	auipc	a1,0x4
    800048b0:	dfc58593          	addi	a1,a1,-516 # 800086a8 <syscalls+0x1f0>
    800048b4:	8526                	mv	a0,s1
    800048b6:	ffffc097          	auipc	ra,0xffffc
    800048ba:	470080e7          	jalr	1136(ra) # 80000d26 <initlock>
  log.start = sb->logstart;
    800048be:	0149a583          	lw	a1,20(s3)
    800048c2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800048c4:	0109a783          	lw	a5,16(s3)
    800048c8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800048ca:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800048ce:	854a                	mv	a0,s2
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	e8a080e7          	jalr	-374(ra) # 8000375a <bread>
  log.lh.n = lh->n;
    800048d8:	4d34                	lw	a3,88(a0)
    800048da:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800048dc:	02d05563          	blez	a3,80004906 <initlog+0x74>
    800048e0:	05c50793          	addi	a5,a0,92
    800048e4:	0023d717          	auipc	a4,0x23d
    800048e8:	d2470713          	addi	a4,a4,-732 # 80241608 <log+0x30>
    800048ec:	36fd                	addiw	a3,a3,-1
    800048ee:	1682                	slli	a3,a3,0x20
    800048f0:	9281                	srli	a3,a3,0x20
    800048f2:	068a                	slli	a3,a3,0x2
    800048f4:	06050613          	addi	a2,a0,96
    800048f8:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800048fa:	4390                	lw	a2,0(a5)
    800048fc:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800048fe:	0791                	addi	a5,a5,4
    80004900:	0711                	addi	a4,a4,4
    80004902:	fed79ce3          	bne	a5,a3,800048fa <initlog+0x68>
  brelse(buf);
    80004906:	fffff097          	auipc	ra,0xfffff
    8000490a:	f84080e7          	jalr	-124(ra) # 8000388a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000490e:	4505                	li	a0,1
    80004910:	00000097          	auipc	ra,0x0
    80004914:	ebe080e7          	jalr	-322(ra) # 800047ce <install_trans>
  log.lh.n = 0;
    80004918:	0023d797          	auipc	a5,0x23d
    8000491c:	ce07a623          	sw	zero,-788(a5) # 80241604 <log+0x2c>
  write_head(); // clear the log
    80004920:	00000097          	auipc	ra,0x0
    80004924:	e34080e7          	jalr	-460(ra) # 80004754 <write_head>
}
    80004928:	70a2                	ld	ra,40(sp)
    8000492a:	7402                	ld	s0,32(sp)
    8000492c:	64e2                	ld	s1,24(sp)
    8000492e:	6942                	ld	s2,16(sp)
    80004930:	69a2                	ld	s3,8(sp)
    80004932:	6145                	addi	sp,sp,48
    80004934:	8082                	ret

0000000080004936 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004936:	1101                	addi	sp,sp,-32
    80004938:	ec06                	sd	ra,24(sp)
    8000493a:	e822                	sd	s0,16(sp)
    8000493c:	e426                	sd	s1,8(sp)
    8000493e:	e04a                	sd	s2,0(sp)
    80004940:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004942:	0023d517          	auipc	a0,0x23d
    80004946:	c9650513          	addi	a0,a0,-874 # 802415d8 <log>
    8000494a:	ffffc097          	auipc	ra,0xffffc
    8000494e:	46c080e7          	jalr	1132(ra) # 80000db6 <acquire>
  while(1){
    if(log.committing){
    80004952:	0023d497          	auipc	s1,0x23d
    80004956:	c8648493          	addi	s1,s1,-890 # 802415d8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000495a:	4979                	li	s2,30
    8000495c:	a039                	j	8000496a <begin_op+0x34>
      sleep(&log, &log.lock);
    8000495e:	85a6                	mv	a1,s1
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	c46080e7          	jalr	-954(ra) # 800025a8 <sleep>
    if(log.committing){
    8000496a:	50dc                	lw	a5,36(s1)
    8000496c:	fbed                	bnez	a5,8000495e <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000496e:	509c                	lw	a5,32(s1)
    80004970:	0017871b          	addiw	a4,a5,1
    80004974:	0007069b          	sext.w	a3,a4
    80004978:	0027179b          	slliw	a5,a4,0x2
    8000497c:	9fb9                	addw	a5,a5,a4
    8000497e:	0017979b          	slliw	a5,a5,0x1
    80004982:	54d8                	lw	a4,44(s1)
    80004984:	9fb9                	addw	a5,a5,a4
    80004986:	00f95963          	bge	s2,a5,80004998 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000498a:	85a6                	mv	a1,s1
    8000498c:	8526                	mv	a0,s1
    8000498e:	ffffe097          	auipc	ra,0xffffe
    80004992:	c1a080e7          	jalr	-998(ra) # 800025a8 <sleep>
    80004996:	bfd1                	j	8000496a <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004998:	0023d517          	auipc	a0,0x23d
    8000499c:	c4050513          	addi	a0,a0,-960 # 802415d8 <log>
    800049a0:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800049a2:	ffffc097          	auipc	ra,0xffffc
    800049a6:	4c8080e7          	jalr	1224(ra) # 80000e6a <release>
      break;
    }
  }
}
    800049aa:	60e2                	ld	ra,24(sp)
    800049ac:	6442                	ld	s0,16(sp)
    800049ae:	64a2                	ld	s1,8(sp)
    800049b0:	6902                	ld	s2,0(sp)
    800049b2:	6105                	addi	sp,sp,32
    800049b4:	8082                	ret

00000000800049b6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800049b6:	7139                	addi	sp,sp,-64
    800049b8:	fc06                	sd	ra,56(sp)
    800049ba:	f822                	sd	s0,48(sp)
    800049bc:	f426                	sd	s1,40(sp)
    800049be:	f04a                	sd	s2,32(sp)
    800049c0:	ec4e                	sd	s3,24(sp)
    800049c2:	e852                	sd	s4,16(sp)
    800049c4:	e456                	sd	s5,8(sp)
    800049c6:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800049c8:	0023d497          	auipc	s1,0x23d
    800049cc:	c1048493          	addi	s1,s1,-1008 # 802415d8 <log>
    800049d0:	8526                	mv	a0,s1
    800049d2:	ffffc097          	auipc	ra,0xffffc
    800049d6:	3e4080e7          	jalr	996(ra) # 80000db6 <acquire>
  log.outstanding -= 1;
    800049da:	509c                	lw	a5,32(s1)
    800049dc:	37fd                	addiw	a5,a5,-1
    800049de:	0007891b          	sext.w	s2,a5
    800049e2:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800049e4:	50dc                	lw	a5,36(s1)
    800049e6:	e7b9                	bnez	a5,80004a34 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800049e8:	04091e63          	bnez	s2,80004a44 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800049ec:	0023d497          	auipc	s1,0x23d
    800049f0:	bec48493          	addi	s1,s1,-1044 # 802415d8 <log>
    800049f4:	4785                	li	a5,1
    800049f6:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800049f8:	8526                	mv	a0,s1
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	470080e7          	jalr	1136(ra) # 80000e6a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004a02:	54dc                	lw	a5,44(s1)
    80004a04:	06f04763          	bgtz	a5,80004a72 <end_op+0xbc>
    acquire(&log.lock);
    80004a08:	0023d497          	auipc	s1,0x23d
    80004a0c:	bd048493          	addi	s1,s1,-1072 # 802415d8 <log>
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffc097          	auipc	ra,0xffffc
    80004a16:	3a4080e7          	jalr	932(ra) # 80000db6 <acquire>
    log.committing = 0;
    80004a1a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80004a1e:	8526                	mv	a0,s1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	bec080e7          	jalr	-1044(ra) # 8000260c <wakeup>
    release(&log.lock);
    80004a28:	8526                	mv	a0,s1
    80004a2a:	ffffc097          	auipc	ra,0xffffc
    80004a2e:	440080e7          	jalr	1088(ra) # 80000e6a <release>
}
    80004a32:	a03d                	j	80004a60 <end_op+0xaa>
    panic("log.committing");
    80004a34:	00004517          	auipc	a0,0x4
    80004a38:	c7c50513          	addi	a0,a0,-900 # 800086b0 <syscalls+0x1f8>
    80004a3c:	ffffc097          	auipc	ra,0xffffc
    80004a40:	b02080e7          	jalr	-1278(ra) # 8000053e <panic>
    wakeup(&log);
    80004a44:	0023d497          	auipc	s1,0x23d
    80004a48:	b9448493          	addi	s1,s1,-1132 # 802415d8 <log>
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	bbe080e7          	jalr	-1090(ra) # 8000260c <wakeup>
  release(&log.lock);
    80004a56:	8526                	mv	a0,s1
    80004a58:	ffffc097          	auipc	ra,0xffffc
    80004a5c:	412080e7          	jalr	1042(ra) # 80000e6a <release>
}
    80004a60:	70e2                	ld	ra,56(sp)
    80004a62:	7442                	ld	s0,48(sp)
    80004a64:	74a2                	ld	s1,40(sp)
    80004a66:	7902                	ld	s2,32(sp)
    80004a68:	69e2                	ld	s3,24(sp)
    80004a6a:	6a42                	ld	s4,16(sp)
    80004a6c:	6aa2                	ld	s5,8(sp)
    80004a6e:	6121                	addi	sp,sp,64
    80004a70:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a72:	0023da97          	auipc	s5,0x23d
    80004a76:	b96a8a93          	addi	s5,s5,-1130 # 80241608 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004a7a:	0023da17          	auipc	s4,0x23d
    80004a7e:	b5ea0a13          	addi	s4,s4,-1186 # 802415d8 <log>
    80004a82:	018a2583          	lw	a1,24(s4)
    80004a86:	012585bb          	addw	a1,a1,s2
    80004a8a:	2585                	addiw	a1,a1,1
    80004a8c:	028a2503          	lw	a0,40(s4)
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	cca080e7          	jalr	-822(ra) # 8000375a <bread>
    80004a98:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004a9a:	000aa583          	lw	a1,0(s5)
    80004a9e:	028a2503          	lw	a0,40(s4)
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	cb8080e7          	jalr	-840(ra) # 8000375a <bread>
    80004aaa:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004aac:	40000613          	li	a2,1024
    80004ab0:	05850593          	addi	a1,a0,88
    80004ab4:	05848513          	addi	a0,s1,88
    80004ab8:	ffffc097          	auipc	ra,0xffffc
    80004abc:	456080e7          	jalr	1110(ra) # 80000f0e <memmove>
    bwrite(to);  // write the log
    80004ac0:	8526                	mv	a0,s1
    80004ac2:	fffff097          	auipc	ra,0xfffff
    80004ac6:	d8a080e7          	jalr	-630(ra) # 8000384c <bwrite>
    brelse(from);
    80004aca:	854e                	mv	a0,s3
    80004acc:	fffff097          	auipc	ra,0xfffff
    80004ad0:	dbe080e7          	jalr	-578(ra) # 8000388a <brelse>
    brelse(to);
    80004ad4:	8526                	mv	a0,s1
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	db4080e7          	jalr	-588(ra) # 8000388a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ade:	2905                	addiw	s2,s2,1
    80004ae0:	0a91                	addi	s5,s5,4
    80004ae2:	02ca2783          	lw	a5,44(s4)
    80004ae6:	f8f94ee3          	blt	s2,a5,80004a82 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004aea:	00000097          	auipc	ra,0x0
    80004aee:	c6a080e7          	jalr	-918(ra) # 80004754 <write_head>
    install_trans(0); // Now install writes to home locations
    80004af2:	4501                	li	a0,0
    80004af4:	00000097          	auipc	ra,0x0
    80004af8:	cda080e7          	jalr	-806(ra) # 800047ce <install_trans>
    log.lh.n = 0;
    80004afc:	0023d797          	auipc	a5,0x23d
    80004b00:	b007a423          	sw	zero,-1272(a5) # 80241604 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004b04:	00000097          	auipc	ra,0x0
    80004b08:	c50080e7          	jalr	-944(ra) # 80004754 <write_head>
    80004b0c:	bdf5                	j	80004a08 <end_op+0x52>

0000000080004b0e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004b0e:	1101                	addi	sp,sp,-32
    80004b10:	ec06                	sd	ra,24(sp)
    80004b12:	e822                	sd	s0,16(sp)
    80004b14:	e426                	sd	s1,8(sp)
    80004b16:	e04a                	sd	s2,0(sp)
    80004b18:	1000                	addi	s0,sp,32
    80004b1a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004b1c:	0023d917          	auipc	s2,0x23d
    80004b20:	abc90913          	addi	s2,s2,-1348 # 802415d8 <log>
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffc097          	auipc	ra,0xffffc
    80004b2a:	290080e7          	jalr	656(ra) # 80000db6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004b2e:	02c92603          	lw	a2,44(s2)
    80004b32:	47f5                	li	a5,29
    80004b34:	06c7c563          	blt	a5,a2,80004b9e <log_write+0x90>
    80004b38:	0023d797          	auipc	a5,0x23d
    80004b3c:	abc7a783          	lw	a5,-1348(a5) # 802415f4 <log+0x1c>
    80004b40:	37fd                	addiw	a5,a5,-1
    80004b42:	04f65e63          	bge	a2,a5,80004b9e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004b46:	0023d797          	auipc	a5,0x23d
    80004b4a:	ab27a783          	lw	a5,-1358(a5) # 802415f8 <log+0x20>
    80004b4e:	06f05063          	blez	a5,80004bae <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004b52:	4781                	li	a5,0
    80004b54:	06c05563          	blez	a2,80004bbe <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b58:	44cc                	lw	a1,12(s1)
    80004b5a:	0023d717          	auipc	a4,0x23d
    80004b5e:	aae70713          	addi	a4,a4,-1362 # 80241608 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004b62:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b64:	4314                	lw	a3,0(a4)
    80004b66:	04b68c63          	beq	a3,a1,80004bbe <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004b6a:	2785                	addiw	a5,a5,1
    80004b6c:	0711                	addi	a4,a4,4
    80004b6e:	fef61be3          	bne	a2,a5,80004b64 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004b72:	0621                	addi	a2,a2,8
    80004b74:	060a                	slli	a2,a2,0x2
    80004b76:	0023d797          	auipc	a5,0x23d
    80004b7a:	a6278793          	addi	a5,a5,-1438 # 802415d8 <log>
    80004b7e:	963e                	add	a2,a2,a5
    80004b80:	44dc                	lw	a5,12(s1)
    80004b82:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004b84:	8526                	mv	a0,s1
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	da2080e7          	jalr	-606(ra) # 80003928 <bpin>
    log.lh.n++;
    80004b8e:	0023d717          	auipc	a4,0x23d
    80004b92:	a4a70713          	addi	a4,a4,-1462 # 802415d8 <log>
    80004b96:	575c                	lw	a5,44(a4)
    80004b98:	2785                	addiw	a5,a5,1
    80004b9a:	d75c                	sw	a5,44(a4)
    80004b9c:	a835                	j	80004bd8 <log_write+0xca>
    panic("too big a transaction");
    80004b9e:	00004517          	auipc	a0,0x4
    80004ba2:	b2250513          	addi	a0,a0,-1246 # 800086c0 <syscalls+0x208>
    80004ba6:	ffffc097          	auipc	ra,0xffffc
    80004baa:	998080e7          	jalr	-1640(ra) # 8000053e <panic>
    panic("log_write outside of trans");
    80004bae:	00004517          	auipc	a0,0x4
    80004bb2:	b2a50513          	addi	a0,a0,-1238 # 800086d8 <syscalls+0x220>
    80004bb6:	ffffc097          	auipc	ra,0xffffc
    80004bba:	988080e7          	jalr	-1656(ra) # 8000053e <panic>
  log.lh.block[i] = b->blockno;
    80004bbe:	00878713          	addi	a4,a5,8
    80004bc2:	00271693          	slli	a3,a4,0x2
    80004bc6:	0023d717          	auipc	a4,0x23d
    80004bca:	a1270713          	addi	a4,a4,-1518 # 802415d8 <log>
    80004bce:	9736                	add	a4,a4,a3
    80004bd0:	44d4                	lw	a3,12(s1)
    80004bd2:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004bd4:	faf608e3          	beq	a2,a5,80004b84 <log_write+0x76>
  }
  release(&log.lock);
    80004bd8:	0023d517          	auipc	a0,0x23d
    80004bdc:	a0050513          	addi	a0,a0,-1536 # 802415d8 <log>
    80004be0:	ffffc097          	auipc	ra,0xffffc
    80004be4:	28a080e7          	jalr	650(ra) # 80000e6a <release>
}
    80004be8:	60e2                	ld	ra,24(sp)
    80004bea:	6442                	ld	s0,16(sp)
    80004bec:	64a2                	ld	s1,8(sp)
    80004bee:	6902                	ld	s2,0(sp)
    80004bf0:	6105                	addi	sp,sp,32
    80004bf2:	8082                	ret

0000000080004bf4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004bf4:	1101                	addi	sp,sp,-32
    80004bf6:	ec06                	sd	ra,24(sp)
    80004bf8:	e822                	sd	s0,16(sp)
    80004bfa:	e426                	sd	s1,8(sp)
    80004bfc:	e04a                	sd	s2,0(sp)
    80004bfe:	1000                	addi	s0,sp,32
    80004c00:	84aa                	mv	s1,a0
    80004c02:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004c04:	00004597          	auipc	a1,0x4
    80004c08:	af458593          	addi	a1,a1,-1292 # 800086f8 <syscalls+0x240>
    80004c0c:	0521                	addi	a0,a0,8
    80004c0e:	ffffc097          	auipc	ra,0xffffc
    80004c12:	118080e7          	jalr	280(ra) # 80000d26 <initlock>
  lk->name = name;
    80004c16:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004c1a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c1e:	0204a423          	sw	zero,40(s1)
}
    80004c22:	60e2                	ld	ra,24(sp)
    80004c24:	6442                	ld	s0,16(sp)
    80004c26:	64a2                	ld	s1,8(sp)
    80004c28:	6902                	ld	s2,0(sp)
    80004c2a:	6105                	addi	sp,sp,32
    80004c2c:	8082                	ret

0000000080004c2e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004c2e:	1101                	addi	sp,sp,-32
    80004c30:	ec06                	sd	ra,24(sp)
    80004c32:	e822                	sd	s0,16(sp)
    80004c34:	e426                	sd	s1,8(sp)
    80004c36:	e04a                	sd	s2,0(sp)
    80004c38:	1000                	addi	s0,sp,32
    80004c3a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c3c:	00850913          	addi	s2,a0,8
    80004c40:	854a                	mv	a0,s2
    80004c42:	ffffc097          	auipc	ra,0xffffc
    80004c46:	174080e7          	jalr	372(ra) # 80000db6 <acquire>
  while (lk->locked) {
    80004c4a:	409c                	lw	a5,0(s1)
    80004c4c:	cb89                	beqz	a5,80004c5e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004c4e:	85ca                	mv	a1,s2
    80004c50:	8526                	mv	a0,s1
    80004c52:	ffffe097          	auipc	ra,0xffffe
    80004c56:	956080e7          	jalr	-1706(ra) # 800025a8 <sleep>
  while (lk->locked) {
    80004c5a:	409c                	lw	a5,0(s1)
    80004c5c:	fbed                	bnez	a5,80004c4e <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004c5e:	4785                	li	a5,1
    80004c60:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004c62:	ffffd097          	auipc	ra,0xffffd
    80004c66:	016080e7          	jalr	22(ra) # 80001c78 <myproc>
    80004c6a:	591c                	lw	a5,48(a0)
    80004c6c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004c6e:	854a                	mv	a0,s2
    80004c70:	ffffc097          	auipc	ra,0xffffc
    80004c74:	1fa080e7          	jalr	506(ra) # 80000e6a <release>
}
    80004c78:	60e2                	ld	ra,24(sp)
    80004c7a:	6442                	ld	s0,16(sp)
    80004c7c:	64a2                	ld	s1,8(sp)
    80004c7e:	6902                	ld	s2,0(sp)
    80004c80:	6105                	addi	sp,sp,32
    80004c82:	8082                	ret

0000000080004c84 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004c84:	1101                	addi	sp,sp,-32
    80004c86:	ec06                	sd	ra,24(sp)
    80004c88:	e822                	sd	s0,16(sp)
    80004c8a:	e426                	sd	s1,8(sp)
    80004c8c:	e04a                	sd	s2,0(sp)
    80004c8e:	1000                	addi	s0,sp,32
    80004c90:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c92:	00850913          	addi	s2,a0,8
    80004c96:	854a                	mv	a0,s2
    80004c98:	ffffc097          	auipc	ra,0xffffc
    80004c9c:	11e080e7          	jalr	286(ra) # 80000db6 <acquire>
  lk->locked = 0;
    80004ca0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004ca4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	962080e7          	jalr	-1694(ra) # 8000260c <wakeup>
  release(&lk->lk);
    80004cb2:	854a                	mv	a0,s2
    80004cb4:	ffffc097          	auipc	ra,0xffffc
    80004cb8:	1b6080e7          	jalr	438(ra) # 80000e6a <release>
}
    80004cbc:	60e2                	ld	ra,24(sp)
    80004cbe:	6442                	ld	s0,16(sp)
    80004cc0:	64a2                	ld	s1,8(sp)
    80004cc2:	6902                	ld	s2,0(sp)
    80004cc4:	6105                	addi	sp,sp,32
    80004cc6:	8082                	ret

0000000080004cc8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004cc8:	7179                	addi	sp,sp,-48
    80004cca:	f406                	sd	ra,40(sp)
    80004ccc:	f022                	sd	s0,32(sp)
    80004cce:	ec26                	sd	s1,24(sp)
    80004cd0:	e84a                	sd	s2,16(sp)
    80004cd2:	e44e                	sd	s3,8(sp)
    80004cd4:	1800                	addi	s0,sp,48
    80004cd6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004cd8:	00850913          	addi	s2,a0,8
    80004cdc:	854a                	mv	a0,s2
    80004cde:	ffffc097          	auipc	ra,0xffffc
    80004ce2:	0d8080e7          	jalr	216(ra) # 80000db6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ce6:	409c                	lw	a5,0(s1)
    80004ce8:	ef99                	bnez	a5,80004d06 <holdingsleep+0x3e>
    80004cea:	4481                	li	s1,0
  release(&lk->lk);
    80004cec:	854a                	mv	a0,s2
    80004cee:	ffffc097          	auipc	ra,0xffffc
    80004cf2:	17c080e7          	jalr	380(ra) # 80000e6a <release>
  return r;
}
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	70a2                	ld	ra,40(sp)
    80004cfa:	7402                	ld	s0,32(sp)
    80004cfc:	64e2                	ld	s1,24(sp)
    80004cfe:	6942                	ld	s2,16(sp)
    80004d00:	69a2                	ld	s3,8(sp)
    80004d02:	6145                	addi	sp,sp,48
    80004d04:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004d06:	0284a983          	lw	s3,40(s1)
    80004d0a:	ffffd097          	auipc	ra,0xffffd
    80004d0e:	f6e080e7          	jalr	-146(ra) # 80001c78 <myproc>
    80004d12:	5904                	lw	s1,48(a0)
    80004d14:	413484b3          	sub	s1,s1,s3
    80004d18:	0014b493          	seqz	s1,s1
    80004d1c:	bfc1                	j	80004cec <holdingsleep+0x24>

0000000080004d1e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004d1e:	1141                	addi	sp,sp,-16
    80004d20:	e406                	sd	ra,8(sp)
    80004d22:	e022                	sd	s0,0(sp)
    80004d24:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004d26:	00004597          	auipc	a1,0x4
    80004d2a:	9e258593          	addi	a1,a1,-1566 # 80008708 <syscalls+0x250>
    80004d2e:	0023d517          	auipc	a0,0x23d
    80004d32:	9f250513          	addi	a0,a0,-1550 # 80241720 <ftable>
    80004d36:	ffffc097          	auipc	ra,0xffffc
    80004d3a:	ff0080e7          	jalr	-16(ra) # 80000d26 <initlock>
}
    80004d3e:	60a2                	ld	ra,8(sp)
    80004d40:	6402                	ld	s0,0(sp)
    80004d42:	0141                	addi	sp,sp,16
    80004d44:	8082                	ret

0000000080004d46 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004d46:	1101                	addi	sp,sp,-32
    80004d48:	ec06                	sd	ra,24(sp)
    80004d4a:	e822                	sd	s0,16(sp)
    80004d4c:	e426                	sd	s1,8(sp)
    80004d4e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004d50:	0023d517          	auipc	a0,0x23d
    80004d54:	9d050513          	addi	a0,a0,-1584 # 80241720 <ftable>
    80004d58:	ffffc097          	auipc	ra,0xffffc
    80004d5c:	05e080e7          	jalr	94(ra) # 80000db6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d60:	0023d497          	auipc	s1,0x23d
    80004d64:	9d848493          	addi	s1,s1,-1576 # 80241738 <ftable+0x18>
    80004d68:	0023e717          	auipc	a4,0x23e
    80004d6c:	97070713          	addi	a4,a4,-1680 # 802426d8 <disk>
    if(f->ref == 0){
    80004d70:	40dc                	lw	a5,4(s1)
    80004d72:	cf99                	beqz	a5,80004d90 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d74:	02848493          	addi	s1,s1,40
    80004d78:	fee49ce3          	bne	s1,a4,80004d70 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004d7c:	0023d517          	auipc	a0,0x23d
    80004d80:	9a450513          	addi	a0,a0,-1628 # 80241720 <ftable>
    80004d84:	ffffc097          	auipc	ra,0xffffc
    80004d88:	0e6080e7          	jalr	230(ra) # 80000e6a <release>
  return 0;
    80004d8c:	4481                	li	s1,0
    80004d8e:	a819                	j	80004da4 <filealloc+0x5e>
      f->ref = 1;
    80004d90:	4785                	li	a5,1
    80004d92:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004d94:	0023d517          	auipc	a0,0x23d
    80004d98:	98c50513          	addi	a0,a0,-1652 # 80241720 <ftable>
    80004d9c:	ffffc097          	auipc	ra,0xffffc
    80004da0:	0ce080e7          	jalr	206(ra) # 80000e6a <release>
}
    80004da4:	8526                	mv	a0,s1
    80004da6:	60e2                	ld	ra,24(sp)
    80004da8:	6442                	ld	s0,16(sp)
    80004daa:	64a2                	ld	s1,8(sp)
    80004dac:	6105                	addi	sp,sp,32
    80004dae:	8082                	ret

0000000080004db0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004db0:	1101                	addi	sp,sp,-32
    80004db2:	ec06                	sd	ra,24(sp)
    80004db4:	e822                	sd	s0,16(sp)
    80004db6:	e426                	sd	s1,8(sp)
    80004db8:	1000                	addi	s0,sp,32
    80004dba:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004dbc:	0023d517          	auipc	a0,0x23d
    80004dc0:	96450513          	addi	a0,a0,-1692 # 80241720 <ftable>
    80004dc4:	ffffc097          	auipc	ra,0xffffc
    80004dc8:	ff2080e7          	jalr	-14(ra) # 80000db6 <acquire>
  if(f->ref < 1)
    80004dcc:	40dc                	lw	a5,4(s1)
    80004dce:	02f05263          	blez	a5,80004df2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004dd2:	2785                	addiw	a5,a5,1
    80004dd4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004dd6:	0023d517          	auipc	a0,0x23d
    80004dda:	94a50513          	addi	a0,a0,-1718 # 80241720 <ftable>
    80004dde:	ffffc097          	auipc	ra,0xffffc
    80004de2:	08c080e7          	jalr	140(ra) # 80000e6a <release>
  return f;
}
    80004de6:	8526                	mv	a0,s1
    80004de8:	60e2                	ld	ra,24(sp)
    80004dea:	6442                	ld	s0,16(sp)
    80004dec:	64a2                	ld	s1,8(sp)
    80004dee:	6105                	addi	sp,sp,32
    80004df0:	8082                	ret
    panic("filedup");
    80004df2:	00004517          	auipc	a0,0x4
    80004df6:	91e50513          	addi	a0,a0,-1762 # 80008710 <syscalls+0x258>
    80004dfa:	ffffb097          	auipc	ra,0xffffb
    80004dfe:	744080e7          	jalr	1860(ra) # 8000053e <panic>

0000000080004e02 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004e02:	7139                	addi	sp,sp,-64
    80004e04:	fc06                	sd	ra,56(sp)
    80004e06:	f822                	sd	s0,48(sp)
    80004e08:	f426                	sd	s1,40(sp)
    80004e0a:	f04a                	sd	s2,32(sp)
    80004e0c:	ec4e                	sd	s3,24(sp)
    80004e0e:	e852                	sd	s4,16(sp)
    80004e10:	e456                	sd	s5,8(sp)
    80004e12:	0080                	addi	s0,sp,64
    80004e14:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004e16:	0023d517          	auipc	a0,0x23d
    80004e1a:	90a50513          	addi	a0,a0,-1782 # 80241720 <ftable>
    80004e1e:	ffffc097          	auipc	ra,0xffffc
    80004e22:	f98080e7          	jalr	-104(ra) # 80000db6 <acquire>
  if(f->ref < 1)
    80004e26:	40dc                	lw	a5,4(s1)
    80004e28:	06f05163          	blez	a5,80004e8a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80004e2c:	37fd                	addiw	a5,a5,-1
    80004e2e:	0007871b          	sext.w	a4,a5
    80004e32:	c0dc                	sw	a5,4(s1)
    80004e34:	06e04363          	bgtz	a4,80004e9a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004e38:	0004a903          	lw	s2,0(s1)
    80004e3c:	0094ca83          	lbu	s5,9(s1)
    80004e40:	0104ba03          	ld	s4,16(s1)
    80004e44:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004e48:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004e4c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004e50:	0023d517          	auipc	a0,0x23d
    80004e54:	8d050513          	addi	a0,a0,-1840 # 80241720 <ftable>
    80004e58:	ffffc097          	auipc	ra,0xffffc
    80004e5c:	012080e7          	jalr	18(ra) # 80000e6a <release>

  if(ff.type == FD_PIPE){
    80004e60:	4785                	li	a5,1
    80004e62:	04f90d63          	beq	s2,a5,80004ebc <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004e66:	3979                	addiw	s2,s2,-2
    80004e68:	4785                	li	a5,1
    80004e6a:	0527e063          	bltu	a5,s2,80004eaa <fileclose+0xa8>
    begin_op();
    80004e6e:	00000097          	auipc	ra,0x0
    80004e72:	ac8080e7          	jalr	-1336(ra) # 80004936 <begin_op>
    iput(ff.ip);
    80004e76:	854e                	mv	a0,s3
    80004e78:	fffff097          	auipc	ra,0xfffff
    80004e7c:	2b6080e7          	jalr	694(ra) # 8000412e <iput>
    end_op();
    80004e80:	00000097          	auipc	ra,0x0
    80004e84:	b36080e7          	jalr	-1226(ra) # 800049b6 <end_op>
    80004e88:	a00d                	j	80004eaa <fileclose+0xa8>
    panic("fileclose");
    80004e8a:	00004517          	auipc	a0,0x4
    80004e8e:	88e50513          	addi	a0,a0,-1906 # 80008718 <syscalls+0x260>
    80004e92:	ffffb097          	auipc	ra,0xffffb
    80004e96:	6ac080e7          	jalr	1708(ra) # 8000053e <panic>
    release(&ftable.lock);
    80004e9a:	0023d517          	auipc	a0,0x23d
    80004e9e:	88650513          	addi	a0,a0,-1914 # 80241720 <ftable>
    80004ea2:	ffffc097          	auipc	ra,0xffffc
    80004ea6:	fc8080e7          	jalr	-56(ra) # 80000e6a <release>
  }
}
    80004eaa:	70e2                	ld	ra,56(sp)
    80004eac:	7442                	ld	s0,48(sp)
    80004eae:	74a2                	ld	s1,40(sp)
    80004eb0:	7902                	ld	s2,32(sp)
    80004eb2:	69e2                	ld	s3,24(sp)
    80004eb4:	6a42                	ld	s4,16(sp)
    80004eb6:	6aa2                	ld	s5,8(sp)
    80004eb8:	6121                	addi	sp,sp,64
    80004eba:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ebc:	85d6                	mv	a1,s5
    80004ebe:	8552                	mv	a0,s4
    80004ec0:	00000097          	auipc	ra,0x0
    80004ec4:	34c080e7          	jalr	844(ra) # 8000520c <pipeclose>
    80004ec8:	b7cd                	j	80004eaa <fileclose+0xa8>

0000000080004eca <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004eca:	715d                	addi	sp,sp,-80
    80004ecc:	e486                	sd	ra,72(sp)
    80004ece:	e0a2                	sd	s0,64(sp)
    80004ed0:	fc26                	sd	s1,56(sp)
    80004ed2:	f84a                	sd	s2,48(sp)
    80004ed4:	f44e                	sd	s3,40(sp)
    80004ed6:	0880                	addi	s0,sp,80
    80004ed8:	84aa                	mv	s1,a0
    80004eda:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004edc:	ffffd097          	auipc	ra,0xffffd
    80004ee0:	d9c080e7          	jalr	-612(ra) # 80001c78 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004ee4:	409c                	lw	a5,0(s1)
    80004ee6:	37f9                	addiw	a5,a5,-2
    80004ee8:	4705                	li	a4,1
    80004eea:	04f76763          	bltu	a4,a5,80004f38 <filestat+0x6e>
    80004eee:	892a                	mv	s2,a0
    ilock(f->ip);
    80004ef0:	6c88                	ld	a0,24(s1)
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	082080e7          	jalr	130(ra) # 80003f74 <ilock>
    stati(f->ip, &st);
    80004efa:	fb840593          	addi	a1,s0,-72
    80004efe:	6c88                	ld	a0,24(s1)
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	2fe080e7          	jalr	766(ra) # 800041fe <stati>
    iunlock(f->ip);
    80004f08:	6c88                	ld	a0,24(s1)
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	12c080e7          	jalr	300(ra) # 80004036 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004f12:	46e1                	li	a3,24
    80004f14:	fb840613          	addi	a2,s0,-72
    80004f18:	85ce                	mv	a1,s3
    80004f1a:	05093503          	ld	a0,80(s2)
    80004f1e:	ffffd097          	auipc	ra,0xffffd
    80004f22:	968080e7          	jalr	-1688(ra) # 80001886 <copyout>
    80004f26:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004f2a:	60a6                	ld	ra,72(sp)
    80004f2c:	6406                	ld	s0,64(sp)
    80004f2e:	74e2                	ld	s1,56(sp)
    80004f30:	7942                	ld	s2,48(sp)
    80004f32:	79a2                	ld	s3,40(sp)
    80004f34:	6161                	addi	sp,sp,80
    80004f36:	8082                	ret
  return -1;
    80004f38:	557d                	li	a0,-1
    80004f3a:	bfc5                	j	80004f2a <filestat+0x60>

0000000080004f3c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004f3c:	7179                	addi	sp,sp,-48
    80004f3e:	f406                	sd	ra,40(sp)
    80004f40:	f022                	sd	s0,32(sp)
    80004f42:	ec26                	sd	s1,24(sp)
    80004f44:	e84a                	sd	s2,16(sp)
    80004f46:	e44e                	sd	s3,8(sp)
    80004f48:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004f4a:	00854783          	lbu	a5,8(a0)
    80004f4e:	c3d5                	beqz	a5,80004ff2 <fileread+0xb6>
    80004f50:	84aa                	mv	s1,a0
    80004f52:	89ae                	mv	s3,a1
    80004f54:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f56:	411c                	lw	a5,0(a0)
    80004f58:	4705                	li	a4,1
    80004f5a:	04e78963          	beq	a5,a4,80004fac <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f5e:	470d                	li	a4,3
    80004f60:	04e78d63          	beq	a5,a4,80004fba <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f64:	4709                	li	a4,2
    80004f66:	06e79e63          	bne	a5,a4,80004fe2 <fileread+0xa6>
    ilock(f->ip);
    80004f6a:	6d08                	ld	a0,24(a0)
    80004f6c:	fffff097          	auipc	ra,0xfffff
    80004f70:	008080e7          	jalr	8(ra) # 80003f74 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004f74:	874a                	mv	a4,s2
    80004f76:	5094                	lw	a3,32(s1)
    80004f78:	864e                	mv	a2,s3
    80004f7a:	4585                	li	a1,1
    80004f7c:	6c88                	ld	a0,24(s1)
    80004f7e:	fffff097          	auipc	ra,0xfffff
    80004f82:	2aa080e7          	jalr	682(ra) # 80004228 <readi>
    80004f86:	892a                	mv	s2,a0
    80004f88:	00a05563          	blez	a0,80004f92 <fileread+0x56>
      f->off += r;
    80004f8c:	509c                	lw	a5,32(s1)
    80004f8e:	9fa9                	addw	a5,a5,a0
    80004f90:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004f92:	6c88                	ld	a0,24(s1)
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	0a2080e7          	jalr	162(ra) # 80004036 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004f9c:	854a                	mv	a0,s2
    80004f9e:	70a2                	ld	ra,40(sp)
    80004fa0:	7402                	ld	s0,32(sp)
    80004fa2:	64e2                	ld	s1,24(sp)
    80004fa4:	6942                	ld	s2,16(sp)
    80004fa6:	69a2                	ld	s3,8(sp)
    80004fa8:	6145                	addi	sp,sp,48
    80004faa:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004fac:	6908                	ld	a0,16(a0)
    80004fae:	00000097          	auipc	ra,0x0
    80004fb2:	3c6080e7          	jalr	966(ra) # 80005374 <piperead>
    80004fb6:	892a                	mv	s2,a0
    80004fb8:	b7d5                	j	80004f9c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004fba:	02451783          	lh	a5,36(a0)
    80004fbe:	03079693          	slli	a3,a5,0x30
    80004fc2:	92c1                	srli	a3,a3,0x30
    80004fc4:	4725                	li	a4,9
    80004fc6:	02d76863          	bltu	a4,a3,80004ff6 <fileread+0xba>
    80004fca:	0792                	slli	a5,a5,0x4
    80004fcc:	0023c717          	auipc	a4,0x23c
    80004fd0:	6b470713          	addi	a4,a4,1716 # 80241680 <devsw>
    80004fd4:	97ba                	add	a5,a5,a4
    80004fd6:	639c                	ld	a5,0(a5)
    80004fd8:	c38d                	beqz	a5,80004ffa <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004fda:	4505                	li	a0,1
    80004fdc:	9782                	jalr	a5
    80004fde:	892a                	mv	s2,a0
    80004fe0:	bf75                	j	80004f9c <fileread+0x60>
    panic("fileread");
    80004fe2:	00003517          	auipc	a0,0x3
    80004fe6:	74650513          	addi	a0,a0,1862 # 80008728 <syscalls+0x270>
    80004fea:	ffffb097          	auipc	ra,0xffffb
    80004fee:	554080e7          	jalr	1364(ra) # 8000053e <panic>
    return -1;
    80004ff2:	597d                	li	s2,-1
    80004ff4:	b765                	j	80004f9c <fileread+0x60>
      return -1;
    80004ff6:	597d                	li	s2,-1
    80004ff8:	b755                	j	80004f9c <fileread+0x60>
    80004ffa:	597d                	li	s2,-1
    80004ffc:	b745                	j	80004f9c <fileread+0x60>

0000000080004ffe <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80004ffe:	715d                	addi	sp,sp,-80
    80005000:	e486                	sd	ra,72(sp)
    80005002:	e0a2                	sd	s0,64(sp)
    80005004:	fc26                	sd	s1,56(sp)
    80005006:	f84a                	sd	s2,48(sp)
    80005008:	f44e                	sd	s3,40(sp)
    8000500a:	f052                	sd	s4,32(sp)
    8000500c:	ec56                	sd	s5,24(sp)
    8000500e:	e85a                	sd	s6,16(sp)
    80005010:	e45e                	sd	s7,8(sp)
    80005012:	e062                	sd	s8,0(sp)
    80005014:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80005016:	00954783          	lbu	a5,9(a0)
    8000501a:	10078663          	beqz	a5,80005126 <filewrite+0x128>
    8000501e:	892a                	mv	s2,a0
    80005020:	8aae                	mv	s5,a1
    80005022:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80005024:	411c                	lw	a5,0(a0)
    80005026:	4705                	li	a4,1
    80005028:	02e78263          	beq	a5,a4,8000504c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000502c:	470d                	li	a4,3
    8000502e:	02e78663          	beq	a5,a4,8000505a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005032:	4709                	li	a4,2
    80005034:	0ee79163          	bne	a5,a4,80005116 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005038:	0ac05d63          	blez	a2,800050f2 <filewrite+0xf4>
    int i = 0;
    8000503c:	4981                	li	s3,0
    8000503e:	6b05                	lui	s6,0x1
    80005040:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80005044:	6b85                	lui	s7,0x1
    80005046:	c00b8b9b          	addiw	s7,s7,-1024
    8000504a:	a861                	j	800050e2 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    8000504c:	6908                	ld	a0,16(a0)
    8000504e:	00000097          	auipc	ra,0x0
    80005052:	22e080e7          	jalr	558(ra) # 8000527c <pipewrite>
    80005056:	8a2a                	mv	s4,a0
    80005058:	a045                	j	800050f8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000505a:	02451783          	lh	a5,36(a0)
    8000505e:	03079693          	slli	a3,a5,0x30
    80005062:	92c1                	srli	a3,a3,0x30
    80005064:	4725                	li	a4,9
    80005066:	0cd76263          	bltu	a4,a3,8000512a <filewrite+0x12c>
    8000506a:	0792                	slli	a5,a5,0x4
    8000506c:	0023c717          	auipc	a4,0x23c
    80005070:	61470713          	addi	a4,a4,1556 # 80241680 <devsw>
    80005074:	97ba                	add	a5,a5,a4
    80005076:	679c                	ld	a5,8(a5)
    80005078:	cbdd                	beqz	a5,8000512e <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    8000507a:	4505                	li	a0,1
    8000507c:	9782                	jalr	a5
    8000507e:	8a2a                	mv	s4,a0
    80005080:	a8a5                	j	800050f8 <filewrite+0xfa>
    80005082:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80005086:	00000097          	auipc	ra,0x0
    8000508a:	8b0080e7          	jalr	-1872(ra) # 80004936 <begin_op>
      ilock(f->ip);
    8000508e:	01893503          	ld	a0,24(s2)
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	ee2080e7          	jalr	-286(ra) # 80003f74 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000509a:	8762                	mv	a4,s8
    8000509c:	02092683          	lw	a3,32(s2)
    800050a0:	01598633          	add	a2,s3,s5
    800050a4:	4585                	li	a1,1
    800050a6:	01893503          	ld	a0,24(s2)
    800050aa:	fffff097          	auipc	ra,0xfffff
    800050ae:	276080e7          	jalr	630(ra) # 80004320 <writei>
    800050b2:	84aa                	mv	s1,a0
    800050b4:	00a05763          	blez	a0,800050c2 <filewrite+0xc4>
        f->off += r;
    800050b8:	02092783          	lw	a5,32(s2)
    800050bc:	9fa9                	addw	a5,a5,a0
    800050be:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800050c2:	01893503          	ld	a0,24(s2)
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	f70080e7          	jalr	-144(ra) # 80004036 <iunlock>
      end_op();
    800050ce:	00000097          	auipc	ra,0x0
    800050d2:	8e8080e7          	jalr	-1816(ra) # 800049b6 <end_op>

      if(r != n1){
    800050d6:	009c1f63          	bne	s8,s1,800050f4 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    800050da:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800050de:	0149db63          	bge	s3,s4,800050f4 <filewrite+0xf6>
      int n1 = n - i;
    800050e2:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800050e6:	84be                	mv	s1,a5
    800050e8:	2781                	sext.w	a5,a5
    800050ea:	f8fb5ce3          	bge	s6,a5,80005082 <filewrite+0x84>
    800050ee:	84de                	mv	s1,s7
    800050f0:	bf49                	j	80005082 <filewrite+0x84>
    int i = 0;
    800050f2:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800050f4:	013a1f63          	bne	s4,s3,80005112 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800050f8:	8552                	mv	a0,s4
    800050fa:	60a6                	ld	ra,72(sp)
    800050fc:	6406                	ld	s0,64(sp)
    800050fe:	74e2                	ld	s1,56(sp)
    80005100:	7942                	ld	s2,48(sp)
    80005102:	79a2                	ld	s3,40(sp)
    80005104:	7a02                	ld	s4,32(sp)
    80005106:	6ae2                	ld	s5,24(sp)
    80005108:	6b42                	ld	s6,16(sp)
    8000510a:	6ba2                	ld	s7,8(sp)
    8000510c:	6c02                	ld	s8,0(sp)
    8000510e:	6161                	addi	sp,sp,80
    80005110:	8082                	ret
    ret = (i == n ? n : -1);
    80005112:	5a7d                	li	s4,-1
    80005114:	b7d5                	j	800050f8 <filewrite+0xfa>
    panic("filewrite");
    80005116:	00003517          	auipc	a0,0x3
    8000511a:	62250513          	addi	a0,a0,1570 # 80008738 <syscalls+0x280>
    8000511e:	ffffb097          	auipc	ra,0xffffb
    80005122:	420080e7          	jalr	1056(ra) # 8000053e <panic>
    return -1;
    80005126:	5a7d                	li	s4,-1
    80005128:	bfc1                	j	800050f8 <filewrite+0xfa>
      return -1;
    8000512a:	5a7d                	li	s4,-1
    8000512c:	b7f1                	j	800050f8 <filewrite+0xfa>
    8000512e:	5a7d                	li	s4,-1
    80005130:	b7e1                	j	800050f8 <filewrite+0xfa>

0000000080005132 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80005132:	7179                	addi	sp,sp,-48
    80005134:	f406                	sd	ra,40(sp)
    80005136:	f022                	sd	s0,32(sp)
    80005138:	ec26                	sd	s1,24(sp)
    8000513a:	e84a                	sd	s2,16(sp)
    8000513c:	e44e                	sd	s3,8(sp)
    8000513e:	e052                	sd	s4,0(sp)
    80005140:	1800                	addi	s0,sp,48
    80005142:	84aa                	mv	s1,a0
    80005144:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80005146:	0005b023          	sd	zero,0(a1)
    8000514a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000514e:	00000097          	auipc	ra,0x0
    80005152:	bf8080e7          	jalr	-1032(ra) # 80004d46 <filealloc>
    80005156:	e088                	sd	a0,0(s1)
    80005158:	c551                	beqz	a0,800051e4 <pipealloc+0xb2>
    8000515a:	00000097          	auipc	ra,0x0
    8000515e:	bec080e7          	jalr	-1044(ra) # 80004d46 <filealloc>
    80005162:	00aa3023          	sd	a0,0(s4)
    80005166:	c92d                	beqz	a0,800051d8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	b4a080e7          	jalr	-1206(ra) # 80000cb2 <kalloc>
    80005170:	892a                	mv	s2,a0
    80005172:	c125                	beqz	a0,800051d2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80005174:	4985                	li	s3,1
    80005176:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000517a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000517e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005182:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005186:	00003597          	auipc	a1,0x3
    8000518a:	5c258593          	addi	a1,a1,1474 # 80008748 <syscalls+0x290>
    8000518e:	ffffc097          	auipc	ra,0xffffc
    80005192:	b98080e7          	jalr	-1128(ra) # 80000d26 <initlock>
  (*f0)->type = FD_PIPE;
    80005196:	609c                	ld	a5,0(s1)
    80005198:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000519c:	609c                	ld	a5,0(s1)
    8000519e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800051a2:	609c                	ld	a5,0(s1)
    800051a4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800051a8:	609c                	ld	a5,0(s1)
    800051aa:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800051ae:	000a3783          	ld	a5,0(s4)
    800051b2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800051b6:	000a3783          	ld	a5,0(s4)
    800051ba:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800051be:	000a3783          	ld	a5,0(s4)
    800051c2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800051c6:	000a3783          	ld	a5,0(s4)
    800051ca:	0127b823          	sd	s2,16(a5)
  return 0;
    800051ce:	4501                	li	a0,0
    800051d0:	a025                	j	800051f8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800051d2:	6088                	ld	a0,0(s1)
    800051d4:	e501                	bnez	a0,800051dc <pipealloc+0xaa>
    800051d6:	a039                	j	800051e4 <pipealloc+0xb2>
    800051d8:	6088                	ld	a0,0(s1)
    800051da:	c51d                	beqz	a0,80005208 <pipealloc+0xd6>
    fileclose(*f0);
    800051dc:	00000097          	auipc	ra,0x0
    800051e0:	c26080e7          	jalr	-986(ra) # 80004e02 <fileclose>
  if(*f1)
    800051e4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800051e8:	557d                	li	a0,-1
  if(*f1)
    800051ea:	c799                	beqz	a5,800051f8 <pipealloc+0xc6>
    fileclose(*f1);
    800051ec:	853e                	mv	a0,a5
    800051ee:	00000097          	auipc	ra,0x0
    800051f2:	c14080e7          	jalr	-1004(ra) # 80004e02 <fileclose>
  return -1;
    800051f6:	557d                	li	a0,-1
}
    800051f8:	70a2                	ld	ra,40(sp)
    800051fa:	7402                	ld	s0,32(sp)
    800051fc:	64e2                	ld	s1,24(sp)
    800051fe:	6942                	ld	s2,16(sp)
    80005200:	69a2                	ld	s3,8(sp)
    80005202:	6a02                	ld	s4,0(sp)
    80005204:	6145                	addi	sp,sp,48
    80005206:	8082                	ret
  return -1;
    80005208:	557d                	li	a0,-1
    8000520a:	b7fd                	j	800051f8 <pipealloc+0xc6>

000000008000520c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000520c:	1101                	addi	sp,sp,-32
    8000520e:	ec06                	sd	ra,24(sp)
    80005210:	e822                	sd	s0,16(sp)
    80005212:	e426                	sd	s1,8(sp)
    80005214:	e04a                	sd	s2,0(sp)
    80005216:	1000                	addi	s0,sp,32
    80005218:	84aa                	mv	s1,a0
    8000521a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000521c:	ffffc097          	auipc	ra,0xffffc
    80005220:	b9a080e7          	jalr	-1126(ra) # 80000db6 <acquire>
  if(writable){
    80005224:	02090d63          	beqz	s2,8000525e <pipeclose+0x52>
    pi->writeopen = 0;
    80005228:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000522c:	21848513          	addi	a0,s1,536
    80005230:	ffffd097          	auipc	ra,0xffffd
    80005234:	3dc080e7          	jalr	988(ra) # 8000260c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80005238:	2204b783          	ld	a5,544(s1)
    8000523c:	eb95                	bnez	a5,80005270 <pipeclose+0x64>
    release(&pi->lock);
    8000523e:	8526                	mv	a0,s1
    80005240:	ffffc097          	auipc	ra,0xffffc
    80005244:	c2a080e7          	jalr	-982(ra) # 80000e6a <release>
    kfree((char*)pi);
    80005248:	8526                	mv	a0,s1
    8000524a:	ffffc097          	auipc	ra,0xffffc
    8000524e:	8ae080e7          	jalr	-1874(ra) # 80000af8 <kfree>
  } else
    release(&pi->lock);
}
    80005252:	60e2                	ld	ra,24(sp)
    80005254:	6442                	ld	s0,16(sp)
    80005256:	64a2                	ld	s1,8(sp)
    80005258:	6902                	ld	s2,0(sp)
    8000525a:	6105                	addi	sp,sp,32
    8000525c:	8082                	ret
    pi->readopen = 0;
    8000525e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005262:	21c48513          	addi	a0,s1,540
    80005266:	ffffd097          	auipc	ra,0xffffd
    8000526a:	3a6080e7          	jalr	934(ra) # 8000260c <wakeup>
    8000526e:	b7e9                	j	80005238 <pipeclose+0x2c>
    release(&pi->lock);
    80005270:	8526                	mv	a0,s1
    80005272:	ffffc097          	auipc	ra,0xffffc
    80005276:	bf8080e7          	jalr	-1032(ra) # 80000e6a <release>
}
    8000527a:	bfe1                	j	80005252 <pipeclose+0x46>

000000008000527c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000527c:	711d                	addi	sp,sp,-96
    8000527e:	ec86                	sd	ra,88(sp)
    80005280:	e8a2                	sd	s0,80(sp)
    80005282:	e4a6                	sd	s1,72(sp)
    80005284:	e0ca                	sd	s2,64(sp)
    80005286:	fc4e                	sd	s3,56(sp)
    80005288:	f852                	sd	s4,48(sp)
    8000528a:	f456                	sd	s5,40(sp)
    8000528c:	f05a                	sd	s6,32(sp)
    8000528e:	ec5e                	sd	s7,24(sp)
    80005290:	e862                	sd	s8,16(sp)
    80005292:	1080                	addi	s0,sp,96
    80005294:	84aa                	mv	s1,a0
    80005296:	8aae                	mv	s5,a1
    80005298:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000529a:	ffffd097          	auipc	ra,0xffffd
    8000529e:	9de080e7          	jalr	-1570(ra) # 80001c78 <myproc>
    800052a2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800052a4:	8526                	mv	a0,s1
    800052a6:	ffffc097          	auipc	ra,0xffffc
    800052aa:	b10080e7          	jalr	-1264(ra) # 80000db6 <acquire>
  while(i < n){
    800052ae:	0b405663          	blez	s4,8000535a <pipewrite+0xde>
  int i = 0;
    800052b2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052b4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800052b6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800052ba:	21c48b93          	addi	s7,s1,540
    800052be:	a089                	j	80005300 <pipewrite+0x84>
      release(&pi->lock);
    800052c0:	8526                	mv	a0,s1
    800052c2:	ffffc097          	auipc	ra,0xffffc
    800052c6:	ba8080e7          	jalr	-1112(ra) # 80000e6a <release>
      return -1;
    800052ca:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800052cc:	854a                	mv	a0,s2
    800052ce:	60e6                	ld	ra,88(sp)
    800052d0:	6446                	ld	s0,80(sp)
    800052d2:	64a6                	ld	s1,72(sp)
    800052d4:	6906                	ld	s2,64(sp)
    800052d6:	79e2                	ld	s3,56(sp)
    800052d8:	7a42                	ld	s4,48(sp)
    800052da:	7aa2                	ld	s5,40(sp)
    800052dc:	7b02                	ld	s6,32(sp)
    800052de:	6be2                	ld	s7,24(sp)
    800052e0:	6c42                	ld	s8,16(sp)
    800052e2:	6125                	addi	sp,sp,96
    800052e4:	8082                	ret
      wakeup(&pi->nread);
    800052e6:	8562                	mv	a0,s8
    800052e8:	ffffd097          	auipc	ra,0xffffd
    800052ec:	324080e7          	jalr	804(ra) # 8000260c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800052f0:	85a6                	mv	a1,s1
    800052f2:	855e                	mv	a0,s7
    800052f4:	ffffd097          	auipc	ra,0xffffd
    800052f8:	2b4080e7          	jalr	692(ra) # 800025a8 <sleep>
  while(i < n){
    800052fc:	07495063          	bge	s2,s4,8000535c <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80005300:	2204a783          	lw	a5,544(s1)
    80005304:	dfd5                	beqz	a5,800052c0 <pipewrite+0x44>
    80005306:	854e                	mv	a0,s3
    80005308:	ffffd097          	auipc	ra,0xffffd
    8000530c:	554080e7          	jalr	1364(ra) # 8000285c <killed>
    80005310:	f945                	bnez	a0,800052c0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005312:	2184a783          	lw	a5,536(s1)
    80005316:	21c4a703          	lw	a4,540(s1)
    8000531a:	2007879b          	addiw	a5,a5,512
    8000531e:	fcf704e3          	beq	a4,a5,800052e6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005322:	4685                	li	a3,1
    80005324:	01590633          	add	a2,s2,s5
    80005328:	faf40593          	addi	a1,s0,-81
    8000532c:	0509b503          	ld	a0,80(s3)
    80005330:	ffffc097          	auipc	ra,0xffffc
    80005334:	690080e7          	jalr	1680(ra) # 800019c0 <copyin>
    80005338:	03650263          	beq	a0,s6,8000535c <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000533c:	21c4a783          	lw	a5,540(s1)
    80005340:	0017871b          	addiw	a4,a5,1
    80005344:	20e4ae23          	sw	a4,540(s1)
    80005348:	1ff7f793          	andi	a5,a5,511
    8000534c:	97a6                	add	a5,a5,s1
    8000534e:	faf44703          	lbu	a4,-81(s0)
    80005352:	00e78c23          	sb	a4,24(a5)
      i++;
    80005356:	2905                	addiw	s2,s2,1
    80005358:	b755                	j	800052fc <pipewrite+0x80>
  int i = 0;
    8000535a:	4901                	li	s2,0
  wakeup(&pi->nread);
    8000535c:	21848513          	addi	a0,s1,536
    80005360:	ffffd097          	auipc	ra,0xffffd
    80005364:	2ac080e7          	jalr	684(ra) # 8000260c <wakeup>
  release(&pi->lock);
    80005368:	8526                	mv	a0,s1
    8000536a:	ffffc097          	auipc	ra,0xffffc
    8000536e:	b00080e7          	jalr	-1280(ra) # 80000e6a <release>
  return i;
    80005372:	bfa9                	j	800052cc <pipewrite+0x50>

0000000080005374 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005374:	715d                	addi	sp,sp,-80
    80005376:	e486                	sd	ra,72(sp)
    80005378:	e0a2                	sd	s0,64(sp)
    8000537a:	fc26                	sd	s1,56(sp)
    8000537c:	f84a                	sd	s2,48(sp)
    8000537e:	f44e                	sd	s3,40(sp)
    80005380:	f052                	sd	s4,32(sp)
    80005382:	ec56                	sd	s5,24(sp)
    80005384:	e85a                	sd	s6,16(sp)
    80005386:	0880                	addi	s0,sp,80
    80005388:	84aa                	mv	s1,a0
    8000538a:	892e                	mv	s2,a1
    8000538c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000538e:	ffffd097          	auipc	ra,0xffffd
    80005392:	8ea080e7          	jalr	-1814(ra) # 80001c78 <myproc>
    80005396:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005398:	8526                	mv	a0,s1
    8000539a:	ffffc097          	auipc	ra,0xffffc
    8000539e:	a1c080e7          	jalr	-1508(ra) # 80000db6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053a2:	2184a703          	lw	a4,536(s1)
    800053a6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053aa:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053ae:	02f71763          	bne	a4,a5,800053dc <piperead+0x68>
    800053b2:	2244a783          	lw	a5,548(s1)
    800053b6:	c39d                	beqz	a5,800053dc <piperead+0x68>
    if(killed(pr)){
    800053b8:	8552                	mv	a0,s4
    800053ba:	ffffd097          	auipc	ra,0xffffd
    800053be:	4a2080e7          	jalr	1186(ra) # 8000285c <killed>
    800053c2:	e941                	bnez	a0,80005452 <piperead+0xde>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053c4:	85a6                	mv	a1,s1
    800053c6:	854e                	mv	a0,s3
    800053c8:	ffffd097          	auipc	ra,0xffffd
    800053cc:	1e0080e7          	jalr	480(ra) # 800025a8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053d0:	2184a703          	lw	a4,536(s1)
    800053d4:	21c4a783          	lw	a5,540(s1)
    800053d8:	fcf70de3          	beq	a4,a5,800053b2 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053dc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800053de:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053e0:	05505363          	blez	s5,80005426 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800053e4:	2184a783          	lw	a5,536(s1)
    800053e8:	21c4a703          	lw	a4,540(s1)
    800053ec:	02f70d63          	beq	a4,a5,80005426 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800053f0:	0017871b          	addiw	a4,a5,1
    800053f4:	20e4ac23          	sw	a4,536(s1)
    800053f8:	1ff7f793          	andi	a5,a5,511
    800053fc:	97a6                	add	a5,a5,s1
    800053fe:	0187c783          	lbu	a5,24(a5)
    80005402:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80005406:	4685                	li	a3,1
    80005408:	fbf40613          	addi	a2,s0,-65
    8000540c:	85ca                	mv	a1,s2
    8000540e:	050a3503          	ld	a0,80(s4)
    80005412:	ffffc097          	auipc	ra,0xffffc
    80005416:	474080e7          	jalr	1140(ra) # 80001886 <copyout>
    8000541a:	01650663          	beq	a0,s6,80005426 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000541e:	2985                	addiw	s3,s3,1
    80005420:	0905                	addi	s2,s2,1
    80005422:	fd3a91e3          	bne	s5,s3,800053e4 <piperead+0x70>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005426:	21c48513          	addi	a0,s1,540
    8000542a:	ffffd097          	auipc	ra,0xffffd
    8000542e:	1e2080e7          	jalr	482(ra) # 8000260c <wakeup>
  release(&pi->lock);
    80005432:	8526                	mv	a0,s1
    80005434:	ffffc097          	auipc	ra,0xffffc
    80005438:	a36080e7          	jalr	-1482(ra) # 80000e6a <release>
  return i;
}
    8000543c:	854e                	mv	a0,s3
    8000543e:	60a6                	ld	ra,72(sp)
    80005440:	6406                	ld	s0,64(sp)
    80005442:	74e2                	ld	s1,56(sp)
    80005444:	7942                	ld	s2,48(sp)
    80005446:	79a2                	ld	s3,40(sp)
    80005448:	7a02                	ld	s4,32(sp)
    8000544a:	6ae2                	ld	s5,24(sp)
    8000544c:	6b42                	ld	s6,16(sp)
    8000544e:	6161                	addi	sp,sp,80
    80005450:	8082                	ret
      release(&pi->lock);
    80005452:	8526                	mv	a0,s1
    80005454:	ffffc097          	auipc	ra,0xffffc
    80005458:	a16080e7          	jalr	-1514(ra) # 80000e6a <release>
      return -1;
    8000545c:	59fd                	li	s3,-1
    8000545e:	bff9                	j	8000543c <piperead+0xc8>

0000000080005460 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005460:	1141                	addi	sp,sp,-16
    80005462:	e422                	sd	s0,8(sp)
    80005464:	0800                	addi	s0,sp,16
    80005466:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005468:	8905                	andi	a0,a0,1
    8000546a:	c111                	beqz	a0,8000546e <flags2perm+0xe>
      perm = PTE_X;
    8000546c:	4521                	li	a0,8
    if(flags & 0x2)
    8000546e:	8b89                	andi	a5,a5,2
    80005470:	c399                	beqz	a5,80005476 <flags2perm+0x16>
      perm |= PTE_W;
    80005472:	00456513          	ori	a0,a0,4
    return perm;
}
    80005476:	6422                	ld	s0,8(sp)
    80005478:	0141                	addi	sp,sp,16
    8000547a:	8082                	ret

000000008000547c <exec>:

int
exec(char *path, char **argv)
{
    8000547c:	de010113          	addi	sp,sp,-544
    80005480:	20113c23          	sd	ra,536(sp)
    80005484:	20813823          	sd	s0,528(sp)
    80005488:	20913423          	sd	s1,520(sp)
    8000548c:	21213023          	sd	s2,512(sp)
    80005490:	ffce                	sd	s3,504(sp)
    80005492:	fbd2                	sd	s4,496(sp)
    80005494:	f7d6                	sd	s5,488(sp)
    80005496:	f3da                	sd	s6,480(sp)
    80005498:	efde                	sd	s7,472(sp)
    8000549a:	ebe2                	sd	s8,464(sp)
    8000549c:	e7e6                	sd	s9,456(sp)
    8000549e:	e3ea                	sd	s10,448(sp)
    800054a0:	ff6e                	sd	s11,440(sp)
    800054a2:	1400                	addi	s0,sp,544
    800054a4:	892a                	mv	s2,a0
    800054a6:	dea43423          	sd	a0,-536(s0)
    800054aa:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800054ae:	ffffc097          	auipc	ra,0xffffc
    800054b2:	7ca080e7          	jalr	1994(ra) # 80001c78 <myproc>
    800054b6:	84aa                	mv	s1,a0

  begin_op();
    800054b8:	fffff097          	auipc	ra,0xfffff
    800054bc:	47e080e7          	jalr	1150(ra) # 80004936 <begin_op>

  if((ip = namei(path)) == 0){
    800054c0:	854a                	mv	a0,s2
    800054c2:	fffff097          	auipc	ra,0xfffff
    800054c6:	258080e7          	jalr	600(ra) # 8000471a <namei>
    800054ca:	c93d                	beqz	a0,80005540 <exec+0xc4>
    800054cc:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800054ce:	fffff097          	auipc	ra,0xfffff
    800054d2:	aa6080e7          	jalr	-1370(ra) # 80003f74 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800054d6:	04000713          	li	a4,64
    800054da:	4681                	li	a3,0
    800054dc:	e5040613          	addi	a2,s0,-432
    800054e0:	4581                	li	a1,0
    800054e2:	8556                	mv	a0,s5
    800054e4:	fffff097          	auipc	ra,0xfffff
    800054e8:	d44080e7          	jalr	-700(ra) # 80004228 <readi>
    800054ec:	04000793          	li	a5,64
    800054f0:	00f51a63          	bne	a0,a5,80005504 <exec+0x88>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800054f4:	e5042703          	lw	a4,-432(s0)
    800054f8:	464c47b7          	lui	a5,0x464c4
    800054fc:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005500:	04f70663          	beq	a4,a5,8000554c <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005504:	8556                	mv	a0,s5
    80005506:	fffff097          	auipc	ra,0xfffff
    8000550a:	cd0080e7          	jalr	-816(ra) # 800041d6 <iunlockput>
    end_op();
    8000550e:	fffff097          	auipc	ra,0xfffff
    80005512:	4a8080e7          	jalr	1192(ra) # 800049b6 <end_op>
  }
  return -1;
    80005516:	557d                	li	a0,-1
}
    80005518:	21813083          	ld	ra,536(sp)
    8000551c:	21013403          	ld	s0,528(sp)
    80005520:	20813483          	ld	s1,520(sp)
    80005524:	20013903          	ld	s2,512(sp)
    80005528:	79fe                	ld	s3,504(sp)
    8000552a:	7a5e                	ld	s4,496(sp)
    8000552c:	7abe                	ld	s5,488(sp)
    8000552e:	7b1e                	ld	s6,480(sp)
    80005530:	6bfe                	ld	s7,472(sp)
    80005532:	6c5e                	ld	s8,464(sp)
    80005534:	6cbe                	ld	s9,456(sp)
    80005536:	6d1e                	ld	s10,448(sp)
    80005538:	7dfa                	ld	s11,440(sp)
    8000553a:	22010113          	addi	sp,sp,544
    8000553e:	8082                	ret
    end_op();
    80005540:	fffff097          	auipc	ra,0xfffff
    80005544:	476080e7          	jalr	1142(ra) # 800049b6 <end_op>
    return -1;
    80005548:	557d                	li	a0,-1
    8000554a:	b7f9                	j	80005518 <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    8000554c:	8526                	mv	a0,s1
    8000554e:	ffffc097          	auipc	ra,0xffffc
    80005552:	7ee080e7          	jalr	2030(ra) # 80001d3c <proc_pagetable>
    80005556:	8b2a                	mv	s6,a0
    80005558:	d555                	beqz	a0,80005504 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000555a:	e7042783          	lw	a5,-400(s0)
    8000555e:	e8845703          	lhu	a4,-376(s0)
    80005562:	c735                	beqz	a4,800055ce <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005564:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005566:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    8000556a:	6a05                	lui	s4,0x1
    8000556c:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80005570:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80005574:	6d85                	lui	s11,0x1
    80005576:	7d7d                	lui	s10,0xfffff
    80005578:	a481                	j	800057b8 <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000557a:	00003517          	auipc	a0,0x3
    8000557e:	1d650513          	addi	a0,a0,470 # 80008750 <syscalls+0x298>
    80005582:	ffffb097          	auipc	ra,0xffffb
    80005586:	fbc080e7          	jalr	-68(ra) # 8000053e <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000558a:	874a                	mv	a4,s2
    8000558c:	009c86bb          	addw	a3,s9,s1
    80005590:	4581                	li	a1,0
    80005592:	8556                	mv	a0,s5
    80005594:	fffff097          	auipc	ra,0xfffff
    80005598:	c94080e7          	jalr	-876(ra) # 80004228 <readi>
    8000559c:	2501                	sext.w	a0,a0
    8000559e:	1aa91a63          	bne	s2,a0,80005752 <exec+0x2d6>
  for(i = 0; i < sz; i += PGSIZE){
    800055a2:	009d84bb          	addw	s1,s11,s1
    800055a6:	013d09bb          	addw	s3,s10,s3
    800055aa:	1f74f763          	bgeu	s1,s7,80005798 <exec+0x31c>
    pa = walkaddr(pagetable, va + i);
    800055ae:	02049593          	slli	a1,s1,0x20
    800055b2:	9181                	srli	a1,a1,0x20
    800055b4:	95e2                	add	a1,a1,s8
    800055b6:	855a                	mv	a0,s6
    800055b8:	ffffc097          	auipc	ra,0xffffc
    800055bc:	c84080e7          	jalr	-892(ra) # 8000123c <walkaddr>
    800055c0:	862a                	mv	a2,a0
    if(pa == 0)
    800055c2:	dd45                	beqz	a0,8000557a <exec+0xfe>
      n = PGSIZE;
    800055c4:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800055c6:	fd49f2e3          	bgeu	s3,s4,8000558a <exec+0x10e>
      n = sz - i;
    800055ca:	894e                	mv	s2,s3
    800055cc:	bf7d                	j	8000558a <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800055ce:	4901                	li	s2,0
  iunlockput(ip);
    800055d0:	8556                	mv	a0,s5
    800055d2:	fffff097          	auipc	ra,0xfffff
    800055d6:	c04080e7          	jalr	-1020(ra) # 800041d6 <iunlockput>
  end_op();
    800055da:	fffff097          	auipc	ra,0xfffff
    800055de:	3dc080e7          	jalr	988(ra) # 800049b6 <end_op>
  p = myproc();
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	696080e7          	jalr	1686(ra) # 80001c78 <myproc>
    800055ea:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800055ec:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800055f0:	6785                	lui	a5,0x1
    800055f2:	17fd                	addi	a5,a5,-1
    800055f4:	993e                	add	s2,s2,a5
    800055f6:	77fd                	lui	a5,0xfffff
    800055f8:	00f977b3          	and	a5,s2,a5
    800055fc:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005600:	4691                	li	a3,4
    80005602:	6609                	lui	a2,0x2
    80005604:	963e                	add	a2,a2,a5
    80005606:	85be                	mv	a1,a5
    80005608:	855a                	mv	a0,s6
    8000560a:	ffffc097          	auipc	ra,0xffffc
    8000560e:	fe6080e7          	jalr	-26(ra) # 800015f0 <uvmalloc>
    80005612:	8c2a                	mv	s8,a0
  ip = 0;
    80005614:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005616:	12050e63          	beqz	a0,80005752 <exec+0x2d6>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000561a:	75f9                	lui	a1,0xffffe
    8000561c:	95aa                	add	a1,a1,a0
    8000561e:	855a                	mv	a0,s6
    80005620:	ffffc097          	auipc	ra,0xffffc
    80005624:	234080e7          	jalr	564(ra) # 80001854 <uvmclear>
  stackbase = sp - PGSIZE;
    80005628:	7afd                	lui	s5,0xfffff
    8000562a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000562c:	df043783          	ld	a5,-528(s0)
    80005630:	6388                	ld	a0,0(a5)
    80005632:	c925                	beqz	a0,800056a2 <exec+0x226>
    80005634:	e9040993          	addi	s3,s0,-368
    80005638:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000563c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000563e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005640:	ffffc097          	auipc	ra,0xffffc
    80005644:	9ee080e7          	jalr	-1554(ra) # 8000102e <strlen>
    80005648:	0015079b          	addiw	a5,a0,1
    8000564c:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005650:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80005654:	13596663          	bltu	s2,s5,80005780 <exec+0x304>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005658:	df043d83          	ld	s11,-528(s0)
    8000565c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80005660:	8552                	mv	a0,s4
    80005662:	ffffc097          	auipc	ra,0xffffc
    80005666:	9cc080e7          	jalr	-1588(ra) # 8000102e <strlen>
    8000566a:	0015069b          	addiw	a3,a0,1
    8000566e:	8652                	mv	a2,s4
    80005670:	85ca                	mv	a1,s2
    80005672:	855a                	mv	a0,s6
    80005674:	ffffc097          	auipc	ra,0xffffc
    80005678:	212080e7          	jalr	530(ra) # 80001886 <copyout>
    8000567c:	10054663          	bltz	a0,80005788 <exec+0x30c>
    ustack[argc] = sp;
    80005680:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005684:	0485                	addi	s1,s1,1
    80005686:	008d8793          	addi	a5,s11,8
    8000568a:	def43823          	sd	a5,-528(s0)
    8000568e:	008db503          	ld	a0,8(s11)
    80005692:	c911                	beqz	a0,800056a6 <exec+0x22a>
    if(argc >= MAXARG)
    80005694:	09a1                	addi	s3,s3,8
    80005696:	fb3c95e3          	bne	s9,s3,80005640 <exec+0x1c4>
  sz = sz1;
    8000569a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000569e:	4a81                	li	s5,0
    800056a0:	a84d                	j	80005752 <exec+0x2d6>
  sp = sz;
    800056a2:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    800056a4:	4481                	li	s1,0
  ustack[argc] = 0;
    800056a6:	00349793          	slli	a5,s1,0x3
    800056aa:	f9040713          	addi	a4,s0,-112
    800056ae:	97ba                	add	a5,a5,a4
    800056b0:	f007b023          	sd	zero,-256(a5) # ffffffffffffef00 <end+0xffffffff7fdbc6e8>
  sp -= (argc+1) * sizeof(uint64);
    800056b4:	00148693          	addi	a3,s1,1
    800056b8:	068e                	slli	a3,a3,0x3
    800056ba:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800056be:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800056c2:	01597663          	bgeu	s2,s5,800056ce <exec+0x252>
  sz = sz1;
    800056c6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800056ca:	4a81                	li	s5,0
    800056cc:	a059                	j	80005752 <exec+0x2d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800056ce:	e9040613          	addi	a2,s0,-368
    800056d2:	85ca                	mv	a1,s2
    800056d4:	855a                	mv	a0,s6
    800056d6:	ffffc097          	auipc	ra,0xffffc
    800056da:	1b0080e7          	jalr	432(ra) # 80001886 <copyout>
    800056de:	0a054963          	bltz	a0,80005790 <exec+0x314>
  p->trapframe->a1 = sp;
    800056e2:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    800056e6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800056ea:	de843783          	ld	a5,-536(s0)
    800056ee:	0007c703          	lbu	a4,0(a5)
    800056f2:	cf11                	beqz	a4,8000570e <exec+0x292>
    800056f4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800056f6:	02f00693          	li	a3,47
    800056fa:	a039                	j	80005708 <exec+0x28c>
      last = s+1;
    800056fc:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80005700:	0785                	addi	a5,a5,1
    80005702:	fff7c703          	lbu	a4,-1(a5)
    80005706:	c701                	beqz	a4,8000570e <exec+0x292>
    if(*s == '/')
    80005708:	fed71ce3          	bne	a4,a3,80005700 <exec+0x284>
    8000570c:	bfc5                	j	800056fc <exec+0x280>
  safestrcpy(p->name, last, sizeof(p->name));
    8000570e:	4641                	li	a2,16
    80005710:	de843583          	ld	a1,-536(s0)
    80005714:	158b8513          	addi	a0,s7,344
    80005718:	ffffc097          	auipc	ra,0xffffc
    8000571c:	8e4080e7          	jalr	-1820(ra) # 80000ffc <safestrcpy>
  oldpagetable = p->pagetable;
    80005720:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80005724:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80005728:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000572c:	058bb783          	ld	a5,88(s7)
    80005730:	e6843703          	ld	a4,-408(s0)
    80005734:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005736:	058bb783          	ld	a5,88(s7)
    8000573a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000573e:	85ea                	mv	a1,s10
    80005740:	ffffc097          	auipc	ra,0xffffc
    80005744:	698080e7          	jalr	1688(ra) # 80001dd8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005748:	0004851b          	sext.w	a0,s1
    8000574c:	b3f1                	j	80005518 <exec+0x9c>
    8000574e:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005752:	df843583          	ld	a1,-520(s0)
    80005756:	855a                	mv	a0,s6
    80005758:	ffffc097          	auipc	ra,0xffffc
    8000575c:	680080e7          	jalr	1664(ra) # 80001dd8 <proc_freepagetable>
  if(ip){
    80005760:	da0a92e3          	bnez	s5,80005504 <exec+0x88>
  return -1;
    80005764:	557d                	li	a0,-1
    80005766:	bb4d                	j	80005518 <exec+0x9c>
    80005768:	df243c23          	sd	s2,-520(s0)
    8000576c:	b7dd                	j	80005752 <exec+0x2d6>
    8000576e:	df243c23          	sd	s2,-520(s0)
    80005772:	b7c5                	j	80005752 <exec+0x2d6>
    80005774:	df243c23          	sd	s2,-520(s0)
    80005778:	bfe9                	j	80005752 <exec+0x2d6>
    8000577a:	df243c23          	sd	s2,-520(s0)
    8000577e:	bfd1                	j	80005752 <exec+0x2d6>
  sz = sz1;
    80005780:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005784:	4a81                	li	s5,0
    80005786:	b7f1                	j	80005752 <exec+0x2d6>
  sz = sz1;
    80005788:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000578c:	4a81                	li	s5,0
    8000578e:	b7d1                	j	80005752 <exec+0x2d6>
  sz = sz1;
    80005790:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80005794:	4a81                	li	s5,0
    80005796:	bf75                	j	80005752 <exec+0x2d6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005798:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000579c:	e0843783          	ld	a5,-504(s0)
    800057a0:	0017869b          	addiw	a3,a5,1
    800057a4:	e0d43423          	sd	a3,-504(s0)
    800057a8:	e0043783          	ld	a5,-512(s0)
    800057ac:	0387879b          	addiw	a5,a5,56
    800057b0:	e8845703          	lhu	a4,-376(s0)
    800057b4:	e0e6dee3          	bge	a3,a4,800055d0 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800057b8:	2781                	sext.w	a5,a5
    800057ba:	e0f43023          	sd	a5,-512(s0)
    800057be:	03800713          	li	a4,56
    800057c2:	86be                	mv	a3,a5
    800057c4:	e1840613          	addi	a2,s0,-488
    800057c8:	4581                	li	a1,0
    800057ca:	8556                	mv	a0,s5
    800057cc:	fffff097          	auipc	ra,0xfffff
    800057d0:	a5c080e7          	jalr	-1444(ra) # 80004228 <readi>
    800057d4:	03800793          	li	a5,56
    800057d8:	f6f51be3          	bne	a0,a5,8000574e <exec+0x2d2>
    if(ph.type != ELF_PROG_LOAD)
    800057dc:	e1842783          	lw	a5,-488(s0)
    800057e0:	4705                	li	a4,1
    800057e2:	fae79de3          	bne	a5,a4,8000579c <exec+0x320>
    if(ph.memsz < ph.filesz)
    800057e6:	e4043483          	ld	s1,-448(s0)
    800057ea:	e3843783          	ld	a5,-456(s0)
    800057ee:	f6f4ede3          	bltu	s1,a5,80005768 <exec+0x2ec>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800057f2:	e2843783          	ld	a5,-472(s0)
    800057f6:	94be                	add	s1,s1,a5
    800057f8:	f6f4ebe3          	bltu	s1,a5,8000576e <exec+0x2f2>
    if(ph.vaddr % PGSIZE != 0)
    800057fc:	de043703          	ld	a4,-544(s0)
    80005800:	8ff9                	and	a5,a5,a4
    80005802:	fbad                	bnez	a5,80005774 <exec+0x2f8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005804:	e1c42503          	lw	a0,-484(s0)
    80005808:	00000097          	auipc	ra,0x0
    8000580c:	c58080e7          	jalr	-936(ra) # 80005460 <flags2perm>
    80005810:	86aa                	mv	a3,a0
    80005812:	8626                	mv	a2,s1
    80005814:	85ca                	mv	a1,s2
    80005816:	855a                	mv	a0,s6
    80005818:	ffffc097          	auipc	ra,0xffffc
    8000581c:	dd8080e7          	jalr	-552(ra) # 800015f0 <uvmalloc>
    80005820:	dea43c23          	sd	a0,-520(s0)
    80005824:	d939                	beqz	a0,8000577a <exec+0x2fe>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005826:	e2843c03          	ld	s8,-472(s0)
    8000582a:	e2042c83          	lw	s9,-480(s0)
    8000582e:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005832:	f60b83e3          	beqz	s7,80005798 <exec+0x31c>
    80005836:	89de                	mv	s3,s7
    80005838:	4481                	li	s1,0
    8000583a:	bb95                	j	800055ae <exec+0x132>

000000008000583c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000583c:	7179                	addi	sp,sp,-48
    8000583e:	f406                	sd	ra,40(sp)
    80005840:	f022                	sd	s0,32(sp)
    80005842:	ec26                	sd	s1,24(sp)
    80005844:	e84a                	sd	s2,16(sp)
    80005846:	1800                	addi	s0,sp,48
    80005848:	892e                	mv	s2,a1
    8000584a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000584c:	fdc40593          	addi	a1,s0,-36
    80005850:	ffffe097          	auipc	ra,0xffffe
    80005854:	b1c080e7          	jalr	-1252(ra) # 8000336c <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80005858:	fdc42703          	lw	a4,-36(s0)
    8000585c:	47bd                	li	a5,15
    8000585e:	02e7eb63          	bltu	a5,a4,80005894 <argfd+0x58>
    80005862:	ffffc097          	auipc	ra,0xffffc
    80005866:	416080e7          	jalr	1046(ra) # 80001c78 <myproc>
    8000586a:	fdc42703          	lw	a4,-36(s0)
    8000586e:	01a70793          	addi	a5,a4,26
    80005872:	078e                	slli	a5,a5,0x3
    80005874:	953e                	add	a0,a0,a5
    80005876:	611c                	ld	a5,0(a0)
    80005878:	c385                	beqz	a5,80005898 <argfd+0x5c>
    return -1;
  if (pfd)
    8000587a:	00090463          	beqz	s2,80005882 <argfd+0x46>
    *pfd = fd;
    8000587e:	00e92023          	sw	a4,0(s2)
  if (pf)
    *pf = f;
  return 0;
    80005882:	4501                	li	a0,0
  if (pf)
    80005884:	c091                	beqz	s1,80005888 <argfd+0x4c>
    *pf = f;
    80005886:	e09c                	sd	a5,0(s1)
}
    80005888:	70a2                	ld	ra,40(sp)
    8000588a:	7402                	ld	s0,32(sp)
    8000588c:	64e2                	ld	s1,24(sp)
    8000588e:	6942                	ld	s2,16(sp)
    80005890:	6145                	addi	sp,sp,48
    80005892:	8082                	ret
    return -1;
    80005894:	557d                	li	a0,-1
    80005896:	bfcd                	j	80005888 <argfd+0x4c>
    80005898:	557d                	li	a0,-1
    8000589a:	b7fd                	j	80005888 <argfd+0x4c>

000000008000589c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000589c:	1101                	addi	sp,sp,-32
    8000589e:	ec06                	sd	ra,24(sp)
    800058a0:	e822                	sd	s0,16(sp)
    800058a2:	e426                	sd	s1,8(sp)
    800058a4:	1000                	addi	s0,sp,32
    800058a6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800058a8:	ffffc097          	auipc	ra,0xffffc
    800058ac:	3d0080e7          	jalr	976(ra) # 80001c78 <myproc>
    800058b0:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++)
    800058b2:	0d050793          	addi	a5,a0,208
    800058b6:	4501                	li	a0,0
    800058b8:	46c1                	li	a3,16
  {
    if (p->ofile[fd] == 0)
    800058ba:	6398                	ld	a4,0(a5)
    800058bc:	cb19                	beqz	a4,800058d2 <fdalloc+0x36>
  for (fd = 0; fd < NOFILE; fd++)
    800058be:	2505                	addiw	a0,a0,1
    800058c0:	07a1                	addi	a5,a5,8
    800058c2:	fed51ce3          	bne	a0,a3,800058ba <fdalloc+0x1e>
    {
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800058c6:	557d                	li	a0,-1
}
    800058c8:	60e2                	ld	ra,24(sp)
    800058ca:	6442                	ld	s0,16(sp)
    800058cc:	64a2                	ld	s1,8(sp)
    800058ce:	6105                	addi	sp,sp,32
    800058d0:	8082                	ret
      p->ofile[fd] = f;
    800058d2:	01a50793          	addi	a5,a0,26
    800058d6:	078e                	slli	a5,a5,0x3
    800058d8:	963e                	add	a2,a2,a5
    800058da:	e204                	sd	s1,0(a2)
      return fd;
    800058dc:	b7f5                	j	800058c8 <fdalloc+0x2c>

00000000800058de <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800058de:	715d                	addi	sp,sp,-80
    800058e0:	e486                	sd	ra,72(sp)
    800058e2:	e0a2                	sd	s0,64(sp)
    800058e4:	fc26                	sd	s1,56(sp)
    800058e6:	f84a                	sd	s2,48(sp)
    800058e8:	f44e                	sd	s3,40(sp)
    800058ea:	f052                	sd	s4,32(sp)
    800058ec:	ec56                	sd	s5,24(sp)
    800058ee:	e85a                	sd	s6,16(sp)
    800058f0:	0880                	addi	s0,sp,80
    800058f2:	8b2e                	mv	s6,a1
    800058f4:	89b2                	mv	s3,a2
    800058f6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    800058f8:	fb040593          	addi	a1,s0,-80
    800058fc:	fffff097          	auipc	ra,0xfffff
    80005900:	e3c080e7          	jalr	-452(ra) # 80004738 <nameiparent>
    80005904:	84aa                	mv	s1,a0
    80005906:	14050f63          	beqz	a0,80005a64 <create+0x186>
    return 0;

  ilock(dp);
    8000590a:	ffffe097          	auipc	ra,0xffffe
    8000590e:	66a080e7          	jalr	1642(ra) # 80003f74 <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
    80005912:	4601                	li	a2,0
    80005914:	fb040593          	addi	a1,s0,-80
    80005918:	8526                	mv	a0,s1
    8000591a:	fffff097          	auipc	ra,0xfffff
    8000591e:	b3e080e7          	jalr	-1218(ra) # 80004458 <dirlookup>
    80005922:	8aaa                	mv	s5,a0
    80005924:	c931                	beqz	a0,80005978 <create+0x9a>
  {
    iunlockput(dp);
    80005926:	8526                	mv	a0,s1
    80005928:	fffff097          	auipc	ra,0xfffff
    8000592c:	8ae080e7          	jalr	-1874(ra) # 800041d6 <iunlockput>
    ilock(ip);
    80005930:	8556                	mv	a0,s5
    80005932:	ffffe097          	auipc	ra,0xffffe
    80005936:	642080e7          	jalr	1602(ra) # 80003f74 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000593a:	000b059b          	sext.w	a1,s6
    8000593e:	4789                	li	a5,2
    80005940:	02f59563          	bne	a1,a5,8000596a <create+0x8c>
    80005944:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7fdbc82c>
    80005948:	37f9                	addiw	a5,a5,-2
    8000594a:	17c2                	slli	a5,a5,0x30
    8000594c:	93c1                	srli	a5,a5,0x30
    8000594e:	4705                	li	a4,1
    80005950:	00f76d63          	bltu	a4,a5,8000596a <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005954:	8556                	mv	a0,s5
    80005956:	60a6                	ld	ra,72(sp)
    80005958:	6406                	ld	s0,64(sp)
    8000595a:	74e2                	ld	s1,56(sp)
    8000595c:	7942                	ld	s2,48(sp)
    8000595e:	79a2                	ld	s3,40(sp)
    80005960:	7a02                	ld	s4,32(sp)
    80005962:	6ae2                	ld	s5,24(sp)
    80005964:	6b42                	ld	s6,16(sp)
    80005966:	6161                	addi	sp,sp,80
    80005968:	8082                	ret
    iunlockput(ip);
    8000596a:	8556                	mv	a0,s5
    8000596c:	fffff097          	auipc	ra,0xfffff
    80005970:	86a080e7          	jalr	-1942(ra) # 800041d6 <iunlockput>
    return 0;
    80005974:	4a81                	li	s5,0
    80005976:	bff9                	j	80005954 <create+0x76>
  if ((ip = ialloc(dp->dev, type)) == 0)
    80005978:	85da                	mv	a1,s6
    8000597a:	4088                	lw	a0,0(s1)
    8000597c:	ffffe097          	auipc	ra,0xffffe
    80005980:	45c080e7          	jalr	1116(ra) # 80003dd8 <ialloc>
    80005984:	8a2a                	mv	s4,a0
    80005986:	c539                	beqz	a0,800059d4 <create+0xf6>
  ilock(ip);
    80005988:	ffffe097          	auipc	ra,0xffffe
    8000598c:	5ec080e7          	jalr	1516(ra) # 80003f74 <ilock>
  ip->major = major;
    80005990:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80005994:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80005998:	4905                	li	s2,1
    8000599a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    8000599e:	8552                	mv	a0,s4
    800059a0:	ffffe097          	auipc	ra,0xffffe
    800059a4:	50a080e7          	jalr	1290(ra) # 80003eaa <iupdate>
  if (type == T_DIR)
    800059a8:	000b059b          	sext.w	a1,s6
    800059ac:	03258b63          	beq	a1,s2,800059e2 <create+0x104>
  if (dirlink(dp, name, ip->inum) < 0)
    800059b0:	004a2603          	lw	a2,4(s4)
    800059b4:	fb040593          	addi	a1,s0,-80
    800059b8:	8526                	mv	a0,s1
    800059ba:	fffff097          	auipc	ra,0xfffff
    800059be:	cae080e7          	jalr	-850(ra) # 80004668 <dirlink>
    800059c2:	06054f63          	bltz	a0,80005a40 <create+0x162>
  iunlockput(dp);
    800059c6:	8526                	mv	a0,s1
    800059c8:	fffff097          	auipc	ra,0xfffff
    800059cc:	80e080e7          	jalr	-2034(ra) # 800041d6 <iunlockput>
  return ip;
    800059d0:	8ad2                	mv	s5,s4
    800059d2:	b749                	j	80005954 <create+0x76>
    iunlockput(dp);
    800059d4:	8526                	mv	a0,s1
    800059d6:	fffff097          	auipc	ra,0xfffff
    800059da:	800080e7          	jalr	-2048(ra) # 800041d6 <iunlockput>
    return 0;
    800059de:	8ad2                	mv	s5,s4
    800059e0:	bf95                	j	80005954 <create+0x76>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800059e2:	004a2603          	lw	a2,4(s4)
    800059e6:	00003597          	auipc	a1,0x3
    800059ea:	d8a58593          	addi	a1,a1,-630 # 80008770 <syscalls+0x2b8>
    800059ee:	8552                	mv	a0,s4
    800059f0:	fffff097          	auipc	ra,0xfffff
    800059f4:	c78080e7          	jalr	-904(ra) # 80004668 <dirlink>
    800059f8:	04054463          	bltz	a0,80005a40 <create+0x162>
    800059fc:	40d0                	lw	a2,4(s1)
    800059fe:	00003597          	auipc	a1,0x3
    80005a02:	d7a58593          	addi	a1,a1,-646 # 80008778 <syscalls+0x2c0>
    80005a06:	8552                	mv	a0,s4
    80005a08:	fffff097          	auipc	ra,0xfffff
    80005a0c:	c60080e7          	jalr	-928(ra) # 80004668 <dirlink>
    80005a10:	02054863          	bltz	a0,80005a40 <create+0x162>
  if (dirlink(dp, name, ip->inum) < 0)
    80005a14:	004a2603          	lw	a2,4(s4)
    80005a18:	fb040593          	addi	a1,s0,-80
    80005a1c:	8526                	mv	a0,s1
    80005a1e:	fffff097          	auipc	ra,0xfffff
    80005a22:	c4a080e7          	jalr	-950(ra) # 80004668 <dirlink>
    80005a26:	00054d63          	bltz	a0,80005a40 <create+0x162>
    dp->nlink++; // for ".."
    80005a2a:	04a4d783          	lhu	a5,74(s1)
    80005a2e:	2785                	addiw	a5,a5,1
    80005a30:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a34:	8526                	mv	a0,s1
    80005a36:	ffffe097          	auipc	ra,0xffffe
    80005a3a:	474080e7          	jalr	1140(ra) # 80003eaa <iupdate>
    80005a3e:	b761                	j	800059c6 <create+0xe8>
  ip->nlink = 0;
    80005a40:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005a44:	8552                	mv	a0,s4
    80005a46:	ffffe097          	auipc	ra,0xffffe
    80005a4a:	464080e7          	jalr	1124(ra) # 80003eaa <iupdate>
  iunlockput(ip);
    80005a4e:	8552                	mv	a0,s4
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	786080e7          	jalr	1926(ra) # 800041d6 <iunlockput>
  iunlockput(dp);
    80005a58:	8526                	mv	a0,s1
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	77c080e7          	jalr	1916(ra) # 800041d6 <iunlockput>
  return 0;
    80005a62:	bdcd                	j	80005954 <create+0x76>
    return 0;
    80005a64:	8aaa                	mv	s5,a0
    80005a66:	b5fd                	j	80005954 <create+0x76>

0000000080005a68 <sys_dup>:
{
    80005a68:	7179                	addi	sp,sp,-48
    80005a6a:	f406                	sd	ra,40(sp)
    80005a6c:	f022                	sd	s0,32(sp)
    80005a6e:	ec26                	sd	s1,24(sp)
    80005a70:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80005a72:	fd840613          	addi	a2,s0,-40
    80005a76:	4581                	li	a1,0
    80005a78:	4501                	li	a0,0
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	dc2080e7          	jalr	-574(ra) # 8000583c <argfd>
    return -1;
    80005a82:	57fd                	li	a5,-1
  if (argfd(0, 0, &f) < 0)
    80005a84:	02054363          	bltz	a0,80005aaa <sys_dup+0x42>
  if ((fd = fdalloc(f)) < 0)
    80005a88:	fd843503          	ld	a0,-40(s0)
    80005a8c:	00000097          	auipc	ra,0x0
    80005a90:	e10080e7          	jalr	-496(ra) # 8000589c <fdalloc>
    80005a94:	84aa                	mv	s1,a0
    return -1;
    80005a96:	57fd                	li	a5,-1
  if ((fd = fdalloc(f)) < 0)
    80005a98:	00054963          	bltz	a0,80005aaa <sys_dup+0x42>
  filedup(f);
    80005a9c:	fd843503          	ld	a0,-40(s0)
    80005aa0:	fffff097          	auipc	ra,0xfffff
    80005aa4:	310080e7          	jalr	784(ra) # 80004db0 <filedup>
  return fd;
    80005aa8:	87a6                	mv	a5,s1
}
    80005aaa:	853e                	mv	a0,a5
    80005aac:	70a2                	ld	ra,40(sp)
    80005aae:	7402                	ld	s0,32(sp)
    80005ab0:	64e2                	ld	s1,24(sp)
    80005ab2:	6145                	addi	sp,sp,48
    80005ab4:	8082                	ret

0000000080005ab6 <sys_getreadcount>:
{
    80005ab6:	1141                	addi	sp,sp,-16
    80005ab8:	e422                	sd	s0,8(sp)
    80005aba:	0800                	addi	s0,sp,16
}
    80005abc:	00003517          	auipc	a0,0x3
    80005ac0:	ec852503          	lw	a0,-312(a0) # 80008984 <readCount>
    80005ac4:	6422                	ld	s0,8(sp)
    80005ac6:	0141                	addi	sp,sp,16
    80005ac8:	8082                	ret

0000000080005aca <sys_read>:
{
    80005aca:	7179                	addi	sp,sp,-48
    80005acc:	f406                	sd	ra,40(sp)
    80005ace:	f022                	sd	s0,32(sp)
    80005ad0:	1800                	addi	s0,sp,48
  readCount++;
    80005ad2:	00003717          	auipc	a4,0x3
    80005ad6:	eb270713          	addi	a4,a4,-334 # 80008984 <readCount>
    80005ada:	431c                	lw	a5,0(a4)
    80005adc:	2785                	addiw	a5,a5,1
    80005ade:	c31c                	sw	a5,0(a4)
  argaddr(1, &p);
    80005ae0:	fd840593          	addi	a1,s0,-40
    80005ae4:	4505                	li	a0,1
    80005ae6:	ffffe097          	auipc	ra,0xffffe
    80005aea:	8a6080e7          	jalr	-1882(ra) # 8000338c <argaddr>
  argint(2, &n);
    80005aee:	fe440593          	addi	a1,s0,-28
    80005af2:	4509                	li	a0,2
    80005af4:	ffffe097          	auipc	ra,0xffffe
    80005af8:	878080e7          	jalr	-1928(ra) # 8000336c <argint>
  if (argfd(0, 0, &f) < 0)
    80005afc:	fe840613          	addi	a2,s0,-24
    80005b00:	4581                	li	a1,0
    80005b02:	4501                	li	a0,0
    80005b04:	00000097          	auipc	ra,0x0
    80005b08:	d38080e7          	jalr	-712(ra) # 8000583c <argfd>
    80005b0c:	87aa                	mv	a5,a0
    return -1;
    80005b0e:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005b10:	0007cc63          	bltz	a5,80005b28 <sys_read+0x5e>
  return fileread(f, p, n);
    80005b14:	fe442603          	lw	a2,-28(s0)
    80005b18:	fd843583          	ld	a1,-40(s0)
    80005b1c:	fe843503          	ld	a0,-24(s0)
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	41c080e7          	jalr	1052(ra) # 80004f3c <fileread>
}
    80005b28:	70a2                	ld	ra,40(sp)
    80005b2a:	7402                	ld	s0,32(sp)
    80005b2c:	6145                	addi	sp,sp,48
    80005b2e:	8082                	ret

0000000080005b30 <sys_write>:
{
    80005b30:	7179                	addi	sp,sp,-48
    80005b32:	f406                	sd	ra,40(sp)
    80005b34:	f022                	sd	s0,32(sp)
    80005b36:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005b38:	fd840593          	addi	a1,s0,-40
    80005b3c:	4505                	li	a0,1
    80005b3e:	ffffe097          	auipc	ra,0xffffe
    80005b42:	84e080e7          	jalr	-1970(ra) # 8000338c <argaddr>
  argint(2, &n);
    80005b46:	fe440593          	addi	a1,s0,-28
    80005b4a:	4509                	li	a0,2
    80005b4c:	ffffe097          	auipc	ra,0xffffe
    80005b50:	820080e7          	jalr	-2016(ra) # 8000336c <argint>
  if (argfd(0, 0, &f) < 0)
    80005b54:	fe840613          	addi	a2,s0,-24
    80005b58:	4581                	li	a1,0
    80005b5a:	4501                	li	a0,0
    80005b5c:	00000097          	auipc	ra,0x0
    80005b60:	ce0080e7          	jalr	-800(ra) # 8000583c <argfd>
    80005b64:	87aa                	mv	a5,a0
    return -1;
    80005b66:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005b68:	0007cc63          	bltz	a5,80005b80 <sys_write+0x50>
  return filewrite(f, p, n);
    80005b6c:	fe442603          	lw	a2,-28(s0)
    80005b70:	fd843583          	ld	a1,-40(s0)
    80005b74:	fe843503          	ld	a0,-24(s0)
    80005b78:	fffff097          	auipc	ra,0xfffff
    80005b7c:	486080e7          	jalr	1158(ra) # 80004ffe <filewrite>
}
    80005b80:	70a2                	ld	ra,40(sp)
    80005b82:	7402                	ld	s0,32(sp)
    80005b84:	6145                	addi	sp,sp,48
    80005b86:	8082                	ret

0000000080005b88 <sys_close>:
{
    80005b88:	1101                	addi	sp,sp,-32
    80005b8a:	ec06                	sd	ra,24(sp)
    80005b8c:	e822                	sd	s0,16(sp)
    80005b8e:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80005b90:	fe040613          	addi	a2,s0,-32
    80005b94:	fec40593          	addi	a1,s0,-20
    80005b98:	4501                	li	a0,0
    80005b9a:	00000097          	auipc	ra,0x0
    80005b9e:	ca2080e7          	jalr	-862(ra) # 8000583c <argfd>
    return -1;
    80005ba2:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80005ba4:	02054463          	bltz	a0,80005bcc <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005ba8:	ffffc097          	auipc	ra,0xffffc
    80005bac:	0d0080e7          	jalr	208(ra) # 80001c78 <myproc>
    80005bb0:	fec42783          	lw	a5,-20(s0)
    80005bb4:	07e9                	addi	a5,a5,26
    80005bb6:	078e                	slli	a5,a5,0x3
    80005bb8:	97aa                	add	a5,a5,a0
    80005bba:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005bbe:	fe043503          	ld	a0,-32(s0)
    80005bc2:	fffff097          	auipc	ra,0xfffff
    80005bc6:	240080e7          	jalr	576(ra) # 80004e02 <fileclose>
  return 0;
    80005bca:	4781                	li	a5,0
}
    80005bcc:	853e                	mv	a0,a5
    80005bce:	60e2                	ld	ra,24(sp)
    80005bd0:	6442                	ld	s0,16(sp)
    80005bd2:	6105                	addi	sp,sp,32
    80005bd4:	8082                	ret

0000000080005bd6 <sys_fstat>:
{
    80005bd6:	1101                	addi	sp,sp,-32
    80005bd8:	ec06                	sd	ra,24(sp)
    80005bda:	e822                	sd	s0,16(sp)
    80005bdc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005bde:	fe040593          	addi	a1,s0,-32
    80005be2:	4505                	li	a0,1
    80005be4:	ffffd097          	auipc	ra,0xffffd
    80005be8:	7a8080e7          	jalr	1960(ra) # 8000338c <argaddr>
  if (argfd(0, 0, &f) < 0)
    80005bec:	fe840613          	addi	a2,s0,-24
    80005bf0:	4581                	li	a1,0
    80005bf2:	4501                	li	a0,0
    80005bf4:	00000097          	auipc	ra,0x0
    80005bf8:	c48080e7          	jalr	-952(ra) # 8000583c <argfd>
    80005bfc:	87aa                	mv	a5,a0
    return -1;
    80005bfe:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80005c00:	0007ca63          	bltz	a5,80005c14 <sys_fstat+0x3e>
  return filestat(f, st);
    80005c04:	fe043583          	ld	a1,-32(s0)
    80005c08:	fe843503          	ld	a0,-24(s0)
    80005c0c:	fffff097          	auipc	ra,0xfffff
    80005c10:	2be080e7          	jalr	702(ra) # 80004eca <filestat>
}
    80005c14:	60e2                	ld	ra,24(sp)
    80005c16:	6442                	ld	s0,16(sp)
    80005c18:	6105                	addi	sp,sp,32
    80005c1a:	8082                	ret

0000000080005c1c <sys_link>:
{
    80005c1c:	7169                	addi	sp,sp,-304
    80005c1e:	f606                	sd	ra,296(sp)
    80005c20:	f222                	sd	s0,288(sp)
    80005c22:	ee26                	sd	s1,280(sp)
    80005c24:	ea4a                	sd	s2,272(sp)
    80005c26:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c28:	08000613          	li	a2,128
    80005c2c:	ed040593          	addi	a1,s0,-304
    80005c30:	4501                	li	a0,0
    80005c32:	ffffd097          	auipc	ra,0xffffd
    80005c36:	77a080e7          	jalr	1914(ra) # 800033ac <argstr>
    return -1;
    80005c3a:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c3c:	10054e63          	bltz	a0,80005d58 <sys_link+0x13c>
    80005c40:	08000613          	li	a2,128
    80005c44:	f5040593          	addi	a1,s0,-176
    80005c48:	4505                	li	a0,1
    80005c4a:	ffffd097          	auipc	ra,0xffffd
    80005c4e:	762080e7          	jalr	1890(ra) # 800033ac <argstr>
    return -1;
    80005c52:	57fd                	li	a5,-1
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c54:	10054263          	bltz	a0,80005d58 <sys_link+0x13c>
  begin_op();
    80005c58:	fffff097          	auipc	ra,0xfffff
    80005c5c:	cde080e7          	jalr	-802(ra) # 80004936 <begin_op>
  if ((ip = namei(old)) == 0)
    80005c60:	ed040513          	addi	a0,s0,-304
    80005c64:	fffff097          	auipc	ra,0xfffff
    80005c68:	ab6080e7          	jalr	-1354(ra) # 8000471a <namei>
    80005c6c:	84aa                	mv	s1,a0
    80005c6e:	c551                	beqz	a0,80005cfa <sys_link+0xde>
  ilock(ip);
    80005c70:	ffffe097          	auipc	ra,0xffffe
    80005c74:	304080e7          	jalr	772(ra) # 80003f74 <ilock>
  if (ip->type == T_DIR)
    80005c78:	04449703          	lh	a4,68(s1)
    80005c7c:	4785                	li	a5,1
    80005c7e:	08f70463          	beq	a4,a5,80005d06 <sys_link+0xea>
  ip->nlink++;
    80005c82:	04a4d783          	lhu	a5,74(s1)
    80005c86:	2785                	addiw	a5,a5,1
    80005c88:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c8c:	8526                	mv	a0,s1
    80005c8e:	ffffe097          	auipc	ra,0xffffe
    80005c92:	21c080e7          	jalr	540(ra) # 80003eaa <iupdate>
  iunlock(ip);
    80005c96:	8526                	mv	a0,s1
    80005c98:	ffffe097          	auipc	ra,0xffffe
    80005c9c:	39e080e7          	jalr	926(ra) # 80004036 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80005ca0:	fd040593          	addi	a1,s0,-48
    80005ca4:	f5040513          	addi	a0,s0,-176
    80005ca8:	fffff097          	auipc	ra,0xfffff
    80005cac:	a90080e7          	jalr	-1392(ra) # 80004738 <nameiparent>
    80005cb0:	892a                	mv	s2,a0
    80005cb2:	c935                	beqz	a0,80005d26 <sys_link+0x10a>
  ilock(dp);
    80005cb4:	ffffe097          	auipc	ra,0xffffe
    80005cb8:	2c0080e7          	jalr	704(ra) # 80003f74 <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80005cbc:	00092703          	lw	a4,0(s2)
    80005cc0:	409c                	lw	a5,0(s1)
    80005cc2:	04f71d63          	bne	a4,a5,80005d1c <sys_link+0x100>
    80005cc6:	40d0                	lw	a2,4(s1)
    80005cc8:	fd040593          	addi	a1,s0,-48
    80005ccc:	854a                	mv	a0,s2
    80005cce:	fffff097          	auipc	ra,0xfffff
    80005cd2:	99a080e7          	jalr	-1638(ra) # 80004668 <dirlink>
    80005cd6:	04054363          	bltz	a0,80005d1c <sys_link+0x100>
  iunlockput(dp);
    80005cda:	854a                	mv	a0,s2
    80005cdc:	ffffe097          	auipc	ra,0xffffe
    80005ce0:	4fa080e7          	jalr	1274(ra) # 800041d6 <iunlockput>
  iput(ip);
    80005ce4:	8526                	mv	a0,s1
    80005ce6:	ffffe097          	auipc	ra,0xffffe
    80005cea:	448080e7          	jalr	1096(ra) # 8000412e <iput>
  end_op();
    80005cee:	fffff097          	auipc	ra,0xfffff
    80005cf2:	cc8080e7          	jalr	-824(ra) # 800049b6 <end_op>
  return 0;
    80005cf6:	4781                	li	a5,0
    80005cf8:	a085                	j	80005d58 <sys_link+0x13c>
    end_op();
    80005cfa:	fffff097          	auipc	ra,0xfffff
    80005cfe:	cbc080e7          	jalr	-836(ra) # 800049b6 <end_op>
    return -1;
    80005d02:	57fd                	li	a5,-1
    80005d04:	a891                	j	80005d58 <sys_link+0x13c>
    iunlockput(ip);
    80005d06:	8526                	mv	a0,s1
    80005d08:	ffffe097          	auipc	ra,0xffffe
    80005d0c:	4ce080e7          	jalr	1230(ra) # 800041d6 <iunlockput>
    end_op();
    80005d10:	fffff097          	auipc	ra,0xfffff
    80005d14:	ca6080e7          	jalr	-858(ra) # 800049b6 <end_op>
    return -1;
    80005d18:	57fd                	li	a5,-1
    80005d1a:	a83d                	j	80005d58 <sys_link+0x13c>
    iunlockput(dp);
    80005d1c:	854a                	mv	a0,s2
    80005d1e:	ffffe097          	auipc	ra,0xffffe
    80005d22:	4b8080e7          	jalr	1208(ra) # 800041d6 <iunlockput>
  ilock(ip);
    80005d26:	8526                	mv	a0,s1
    80005d28:	ffffe097          	auipc	ra,0xffffe
    80005d2c:	24c080e7          	jalr	588(ra) # 80003f74 <ilock>
  ip->nlink--;
    80005d30:	04a4d783          	lhu	a5,74(s1)
    80005d34:	37fd                	addiw	a5,a5,-1
    80005d36:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005d3a:	8526                	mv	a0,s1
    80005d3c:	ffffe097          	auipc	ra,0xffffe
    80005d40:	16e080e7          	jalr	366(ra) # 80003eaa <iupdate>
  iunlockput(ip);
    80005d44:	8526                	mv	a0,s1
    80005d46:	ffffe097          	auipc	ra,0xffffe
    80005d4a:	490080e7          	jalr	1168(ra) # 800041d6 <iunlockput>
  end_op();
    80005d4e:	fffff097          	auipc	ra,0xfffff
    80005d52:	c68080e7          	jalr	-920(ra) # 800049b6 <end_op>
  return -1;
    80005d56:	57fd                	li	a5,-1
}
    80005d58:	853e                	mv	a0,a5
    80005d5a:	70b2                	ld	ra,296(sp)
    80005d5c:	7412                	ld	s0,288(sp)
    80005d5e:	64f2                	ld	s1,280(sp)
    80005d60:	6952                	ld	s2,272(sp)
    80005d62:	6155                	addi	sp,sp,304
    80005d64:	8082                	ret

0000000080005d66 <sys_unlink>:
{
    80005d66:	7151                	addi	sp,sp,-240
    80005d68:	f586                	sd	ra,232(sp)
    80005d6a:	f1a2                	sd	s0,224(sp)
    80005d6c:	eda6                	sd	s1,216(sp)
    80005d6e:	e9ca                	sd	s2,208(sp)
    80005d70:	e5ce                	sd	s3,200(sp)
    80005d72:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80005d74:	08000613          	li	a2,128
    80005d78:	f3040593          	addi	a1,s0,-208
    80005d7c:	4501                	li	a0,0
    80005d7e:	ffffd097          	auipc	ra,0xffffd
    80005d82:	62e080e7          	jalr	1582(ra) # 800033ac <argstr>
    80005d86:	18054163          	bltz	a0,80005f08 <sys_unlink+0x1a2>
  begin_op();
    80005d8a:	fffff097          	auipc	ra,0xfffff
    80005d8e:	bac080e7          	jalr	-1108(ra) # 80004936 <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
    80005d92:	fb040593          	addi	a1,s0,-80
    80005d96:	f3040513          	addi	a0,s0,-208
    80005d9a:	fffff097          	auipc	ra,0xfffff
    80005d9e:	99e080e7          	jalr	-1634(ra) # 80004738 <nameiparent>
    80005da2:	84aa                	mv	s1,a0
    80005da4:	c979                	beqz	a0,80005e7a <sys_unlink+0x114>
  ilock(dp);
    80005da6:	ffffe097          	auipc	ra,0xffffe
    80005daa:	1ce080e7          	jalr	462(ra) # 80003f74 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005dae:	00003597          	auipc	a1,0x3
    80005db2:	9c258593          	addi	a1,a1,-1598 # 80008770 <syscalls+0x2b8>
    80005db6:	fb040513          	addi	a0,s0,-80
    80005dba:	ffffe097          	auipc	ra,0xffffe
    80005dbe:	684080e7          	jalr	1668(ra) # 8000443e <namecmp>
    80005dc2:	14050a63          	beqz	a0,80005f16 <sys_unlink+0x1b0>
    80005dc6:	00003597          	auipc	a1,0x3
    80005dca:	9b258593          	addi	a1,a1,-1614 # 80008778 <syscalls+0x2c0>
    80005dce:	fb040513          	addi	a0,s0,-80
    80005dd2:	ffffe097          	auipc	ra,0xffffe
    80005dd6:	66c080e7          	jalr	1644(ra) # 8000443e <namecmp>
    80005dda:	12050e63          	beqz	a0,80005f16 <sys_unlink+0x1b0>
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005dde:	f2c40613          	addi	a2,s0,-212
    80005de2:	fb040593          	addi	a1,s0,-80
    80005de6:	8526                	mv	a0,s1
    80005de8:	ffffe097          	auipc	ra,0xffffe
    80005dec:	670080e7          	jalr	1648(ra) # 80004458 <dirlookup>
    80005df0:	892a                	mv	s2,a0
    80005df2:	12050263          	beqz	a0,80005f16 <sys_unlink+0x1b0>
  ilock(ip);
    80005df6:	ffffe097          	auipc	ra,0xffffe
    80005dfa:	17e080e7          	jalr	382(ra) # 80003f74 <ilock>
  if (ip->nlink < 1)
    80005dfe:	04a91783          	lh	a5,74(s2)
    80005e02:	08f05263          	blez	a5,80005e86 <sys_unlink+0x120>
  if (ip->type == T_DIR && !isdirempty(ip))
    80005e06:	04491703          	lh	a4,68(s2)
    80005e0a:	4785                	li	a5,1
    80005e0c:	08f70563          	beq	a4,a5,80005e96 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005e10:	4641                	li	a2,16
    80005e12:	4581                	li	a1,0
    80005e14:	fc040513          	addi	a0,s0,-64
    80005e18:	ffffb097          	auipc	ra,0xffffb
    80005e1c:	09a080e7          	jalr	154(ra) # 80000eb2 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e20:	4741                	li	a4,16
    80005e22:	f2c42683          	lw	a3,-212(s0)
    80005e26:	fc040613          	addi	a2,s0,-64
    80005e2a:	4581                	li	a1,0
    80005e2c:	8526                	mv	a0,s1
    80005e2e:	ffffe097          	auipc	ra,0xffffe
    80005e32:	4f2080e7          	jalr	1266(ra) # 80004320 <writei>
    80005e36:	47c1                	li	a5,16
    80005e38:	0af51563          	bne	a0,a5,80005ee2 <sys_unlink+0x17c>
  if (ip->type == T_DIR)
    80005e3c:	04491703          	lh	a4,68(s2)
    80005e40:	4785                	li	a5,1
    80005e42:	0af70863          	beq	a4,a5,80005ef2 <sys_unlink+0x18c>
  iunlockput(dp);
    80005e46:	8526                	mv	a0,s1
    80005e48:	ffffe097          	auipc	ra,0xffffe
    80005e4c:	38e080e7          	jalr	910(ra) # 800041d6 <iunlockput>
  ip->nlink--;
    80005e50:	04a95783          	lhu	a5,74(s2)
    80005e54:	37fd                	addiw	a5,a5,-1
    80005e56:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005e5a:	854a                	mv	a0,s2
    80005e5c:	ffffe097          	auipc	ra,0xffffe
    80005e60:	04e080e7          	jalr	78(ra) # 80003eaa <iupdate>
  iunlockput(ip);
    80005e64:	854a                	mv	a0,s2
    80005e66:	ffffe097          	auipc	ra,0xffffe
    80005e6a:	370080e7          	jalr	880(ra) # 800041d6 <iunlockput>
  end_op();
    80005e6e:	fffff097          	auipc	ra,0xfffff
    80005e72:	b48080e7          	jalr	-1208(ra) # 800049b6 <end_op>
  return 0;
    80005e76:	4501                	li	a0,0
    80005e78:	a84d                	j	80005f2a <sys_unlink+0x1c4>
    end_op();
    80005e7a:	fffff097          	auipc	ra,0xfffff
    80005e7e:	b3c080e7          	jalr	-1220(ra) # 800049b6 <end_op>
    return -1;
    80005e82:	557d                	li	a0,-1
    80005e84:	a05d                	j	80005f2a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80005e86:	00003517          	auipc	a0,0x3
    80005e8a:	8fa50513          	addi	a0,a0,-1798 # 80008780 <syscalls+0x2c8>
    80005e8e:	ffffa097          	auipc	ra,0xffffa
    80005e92:	6b0080e7          	jalr	1712(ra) # 8000053e <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80005e96:	04c92703          	lw	a4,76(s2)
    80005e9a:	02000793          	li	a5,32
    80005e9e:	f6e7f9e3          	bgeu	a5,a4,80005e10 <sys_unlink+0xaa>
    80005ea2:	02000993          	li	s3,32
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ea6:	4741                	li	a4,16
    80005ea8:	86ce                	mv	a3,s3
    80005eaa:	f1840613          	addi	a2,s0,-232
    80005eae:	4581                	li	a1,0
    80005eb0:	854a                	mv	a0,s2
    80005eb2:	ffffe097          	auipc	ra,0xffffe
    80005eb6:	376080e7          	jalr	886(ra) # 80004228 <readi>
    80005eba:	47c1                	li	a5,16
    80005ebc:	00f51b63          	bne	a0,a5,80005ed2 <sys_unlink+0x16c>
    if (de.inum != 0)
    80005ec0:	f1845783          	lhu	a5,-232(s0)
    80005ec4:	e7a1                	bnez	a5,80005f0c <sys_unlink+0x1a6>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80005ec6:	29c1                	addiw	s3,s3,16
    80005ec8:	04c92783          	lw	a5,76(s2)
    80005ecc:	fcf9ede3          	bltu	s3,a5,80005ea6 <sys_unlink+0x140>
    80005ed0:	b781                	j	80005e10 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005ed2:	00003517          	auipc	a0,0x3
    80005ed6:	8c650513          	addi	a0,a0,-1850 # 80008798 <syscalls+0x2e0>
    80005eda:	ffffa097          	auipc	ra,0xffffa
    80005ede:	664080e7          	jalr	1636(ra) # 8000053e <panic>
    panic("unlink: writei");
    80005ee2:	00003517          	auipc	a0,0x3
    80005ee6:	8ce50513          	addi	a0,a0,-1842 # 800087b0 <syscalls+0x2f8>
    80005eea:	ffffa097          	auipc	ra,0xffffa
    80005eee:	654080e7          	jalr	1620(ra) # 8000053e <panic>
    dp->nlink--;
    80005ef2:	04a4d783          	lhu	a5,74(s1)
    80005ef6:	37fd                	addiw	a5,a5,-1
    80005ef8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005efc:	8526                	mv	a0,s1
    80005efe:	ffffe097          	auipc	ra,0xffffe
    80005f02:	fac080e7          	jalr	-84(ra) # 80003eaa <iupdate>
    80005f06:	b781                	j	80005e46 <sys_unlink+0xe0>
    return -1;
    80005f08:	557d                	li	a0,-1
    80005f0a:	a005                	j	80005f2a <sys_unlink+0x1c4>
    iunlockput(ip);
    80005f0c:	854a                	mv	a0,s2
    80005f0e:	ffffe097          	auipc	ra,0xffffe
    80005f12:	2c8080e7          	jalr	712(ra) # 800041d6 <iunlockput>
  iunlockput(dp);
    80005f16:	8526                	mv	a0,s1
    80005f18:	ffffe097          	auipc	ra,0xffffe
    80005f1c:	2be080e7          	jalr	702(ra) # 800041d6 <iunlockput>
  end_op();
    80005f20:	fffff097          	auipc	ra,0xfffff
    80005f24:	a96080e7          	jalr	-1386(ra) # 800049b6 <end_op>
  return -1;
    80005f28:	557d                	li	a0,-1
}
    80005f2a:	70ae                	ld	ra,232(sp)
    80005f2c:	740e                	ld	s0,224(sp)
    80005f2e:	64ee                	ld	s1,216(sp)
    80005f30:	694e                	ld	s2,208(sp)
    80005f32:	69ae                	ld	s3,200(sp)
    80005f34:	616d                	addi	sp,sp,240
    80005f36:	8082                	ret

0000000080005f38 <sys_open>:

uint64
sys_open(void)
{
    80005f38:	7131                	addi	sp,sp,-192
    80005f3a:	fd06                	sd	ra,184(sp)
    80005f3c:	f922                	sd	s0,176(sp)
    80005f3e:	f526                	sd	s1,168(sp)
    80005f40:	f14a                	sd	s2,160(sp)
    80005f42:	ed4e                	sd	s3,152(sp)
    80005f44:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005f46:	f4c40593          	addi	a1,s0,-180
    80005f4a:	4505                	li	a0,1
    80005f4c:	ffffd097          	auipc	ra,0xffffd
    80005f50:	420080e7          	jalr	1056(ra) # 8000336c <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005f54:	08000613          	li	a2,128
    80005f58:	f5040593          	addi	a1,s0,-176
    80005f5c:	4501                	li	a0,0
    80005f5e:	ffffd097          	auipc	ra,0xffffd
    80005f62:	44e080e7          	jalr	1102(ra) # 800033ac <argstr>
    80005f66:	87aa                	mv	a5,a0
    return -1;
    80005f68:	557d                	li	a0,-1
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005f6a:	0a07c963          	bltz	a5,8000601c <sys_open+0xe4>

  begin_op();
    80005f6e:	fffff097          	auipc	ra,0xfffff
    80005f72:	9c8080e7          	jalr	-1592(ra) # 80004936 <begin_op>

  if (omode & O_CREATE)
    80005f76:	f4c42783          	lw	a5,-180(s0)
    80005f7a:	2007f793          	andi	a5,a5,512
    80005f7e:	cfc5                	beqz	a5,80006036 <sys_open+0xfe>
  {
    ip = create(path, T_FILE, 0, 0);
    80005f80:	4681                	li	a3,0
    80005f82:	4601                	li	a2,0
    80005f84:	4589                	li	a1,2
    80005f86:	f5040513          	addi	a0,s0,-176
    80005f8a:	00000097          	auipc	ra,0x0
    80005f8e:	954080e7          	jalr	-1708(ra) # 800058de <create>
    80005f92:	84aa                	mv	s1,a0
    if (ip == 0)
    80005f94:	c959                	beqz	a0,8000602a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80005f96:	04449703          	lh	a4,68(s1)
    80005f9a:	478d                	li	a5,3
    80005f9c:	00f71763          	bne	a4,a5,80005faa <sys_open+0x72>
    80005fa0:	0464d703          	lhu	a4,70(s1)
    80005fa4:	47a5                	li	a5,9
    80005fa6:	0ce7ed63          	bltu	a5,a4,80006080 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80005faa:	fffff097          	auipc	ra,0xfffff
    80005fae:	d9c080e7          	jalr	-612(ra) # 80004d46 <filealloc>
    80005fb2:	89aa                	mv	s3,a0
    80005fb4:	10050363          	beqz	a0,800060ba <sys_open+0x182>
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	8e4080e7          	jalr	-1820(ra) # 8000589c <fdalloc>
    80005fc0:	892a                	mv	s2,a0
    80005fc2:	0e054763          	bltz	a0,800060b0 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE)
    80005fc6:	04449703          	lh	a4,68(s1)
    80005fca:	478d                	li	a5,3
    80005fcc:	0cf70563          	beq	a4,a5,80006096 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  }
  else
  {
    f->type = FD_INODE;
    80005fd0:	4789                	li	a5,2
    80005fd2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005fd6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005fda:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005fde:	f4c42783          	lw	a5,-180(s0)
    80005fe2:	0017c713          	xori	a4,a5,1
    80005fe6:	8b05                	andi	a4,a4,1
    80005fe8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005fec:	0037f713          	andi	a4,a5,3
    80005ff0:	00e03733          	snez	a4,a4
    80005ff4:	00e984a3          	sb	a4,9(s3)

  if ((omode & O_TRUNC) && ip->type == T_FILE)
    80005ff8:	4007f793          	andi	a5,a5,1024
    80005ffc:	c791                	beqz	a5,80006008 <sys_open+0xd0>
    80005ffe:	04449703          	lh	a4,68(s1)
    80006002:	4789                	li	a5,2
    80006004:	0af70063          	beq	a4,a5,800060a4 <sys_open+0x16c>
  {
    itrunc(ip);
  }

  iunlock(ip);
    80006008:	8526                	mv	a0,s1
    8000600a:	ffffe097          	auipc	ra,0xffffe
    8000600e:	02c080e7          	jalr	44(ra) # 80004036 <iunlock>
  end_op();
    80006012:	fffff097          	auipc	ra,0xfffff
    80006016:	9a4080e7          	jalr	-1628(ra) # 800049b6 <end_op>

  return fd;
    8000601a:	854a                	mv	a0,s2
}
    8000601c:	70ea                	ld	ra,184(sp)
    8000601e:	744a                	ld	s0,176(sp)
    80006020:	74aa                	ld	s1,168(sp)
    80006022:	790a                	ld	s2,160(sp)
    80006024:	69ea                	ld	s3,152(sp)
    80006026:	6129                	addi	sp,sp,192
    80006028:	8082                	ret
      end_op();
    8000602a:	fffff097          	auipc	ra,0xfffff
    8000602e:	98c080e7          	jalr	-1652(ra) # 800049b6 <end_op>
      return -1;
    80006032:	557d                	li	a0,-1
    80006034:	b7e5                	j	8000601c <sys_open+0xe4>
    if ((ip = namei(path)) == 0)
    80006036:	f5040513          	addi	a0,s0,-176
    8000603a:	ffffe097          	auipc	ra,0xffffe
    8000603e:	6e0080e7          	jalr	1760(ra) # 8000471a <namei>
    80006042:	84aa                	mv	s1,a0
    80006044:	c905                	beqz	a0,80006074 <sys_open+0x13c>
    ilock(ip);
    80006046:	ffffe097          	auipc	ra,0xffffe
    8000604a:	f2e080e7          	jalr	-210(ra) # 80003f74 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
    8000604e:	04449703          	lh	a4,68(s1)
    80006052:	4785                	li	a5,1
    80006054:	f4f711e3          	bne	a4,a5,80005f96 <sys_open+0x5e>
    80006058:	f4c42783          	lw	a5,-180(s0)
    8000605c:	d7b9                	beqz	a5,80005faa <sys_open+0x72>
      iunlockput(ip);
    8000605e:	8526                	mv	a0,s1
    80006060:	ffffe097          	auipc	ra,0xffffe
    80006064:	176080e7          	jalr	374(ra) # 800041d6 <iunlockput>
      end_op();
    80006068:	fffff097          	auipc	ra,0xfffff
    8000606c:	94e080e7          	jalr	-1714(ra) # 800049b6 <end_op>
      return -1;
    80006070:	557d                	li	a0,-1
    80006072:	b76d                	j	8000601c <sys_open+0xe4>
      end_op();
    80006074:	fffff097          	auipc	ra,0xfffff
    80006078:	942080e7          	jalr	-1726(ra) # 800049b6 <end_op>
      return -1;
    8000607c:	557d                	li	a0,-1
    8000607e:	bf79                	j	8000601c <sys_open+0xe4>
    iunlockput(ip);
    80006080:	8526                	mv	a0,s1
    80006082:	ffffe097          	auipc	ra,0xffffe
    80006086:	154080e7          	jalr	340(ra) # 800041d6 <iunlockput>
    end_op();
    8000608a:	fffff097          	auipc	ra,0xfffff
    8000608e:	92c080e7          	jalr	-1748(ra) # 800049b6 <end_op>
    return -1;
    80006092:	557d                	li	a0,-1
    80006094:	b761                	j	8000601c <sys_open+0xe4>
    f->type = FD_DEVICE;
    80006096:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    8000609a:	04649783          	lh	a5,70(s1)
    8000609e:	02f99223          	sh	a5,36(s3)
    800060a2:	bf25                	j	80005fda <sys_open+0xa2>
    itrunc(ip);
    800060a4:	8526                	mv	a0,s1
    800060a6:	ffffe097          	auipc	ra,0xffffe
    800060aa:	fdc080e7          	jalr	-36(ra) # 80004082 <itrunc>
    800060ae:	bfa9                	j	80006008 <sys_open+0xd0>
      fileclose(f);
    800060b0:	854e                	mv	a0,s3
    800060b2:	fffff097          	auipc	ra,0xfffff
    800060b6:	d50080e7          	jalr	-688(ra) # 80004e02 <fileclose>
    iunlockput(ip);
    800060ba:	8526                	mv	a0,s1
    800060bc:	ffffe097          	auipc	ra,0xffffe
    800060c0:	11a080e7          	jalr	282(ra) # 800041d6 <iunlockput>
    end_op();
    800060c4:	fffff097          	auipc	ra,0xfffff
    800060c8:	8f2080e7          	jalr	-1806(ra) # 800049b6 <end_op>
    return -1;
    800060cc:	557d                	li	a0,-1
    800060ce:	b7b9                	j	8000601c <sys_open+0xe4>

00000000800060d0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800060d0:	7175                	addi	sp,sp,-144
    800060d2:	e506                	sd	ra,136(sp)
    800060d4:	e122                	sd	s0,128(sp)
    800060d6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800060d8:	fffff097          	auipc	ra,0xfffff
    800060dc:	85e080e7          	jalr	-1954(ra) # 80004936 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    800060e0:	08000613          	li	a2,128
    800060e4:	f7040593          	addi	a1,s0,-144
    800060e8:	4501                	li	a0,0
    800060ea:	ffffd097          	auipc	ra,0xffffd
    800060ee:	2c2080e7          	jalr	706(ra) # 800033ac <argstr>
    800060f2:	02054963          	bltz	a0,80006124 <sys_mkdir+0x54>
    800060f6:	4681                	li	a3,0
    800060f8:	4601                	li	a2,0
    800060fa:	4585                	li	a1,1
    800060fc:	f7040513          	addi	a0,s0,-144
    80006100:	fffff097          	auipc	ra,0xfffff
    80006104:	7de080e7          	jalr	2014(ra) # 800058de <create>
    80006108:	cd11                	beqz	a0,80006124 <sys_mkdir+0x54>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000610a:	ffffe097          	auipc	ra,0xffffe
    8000610e:	0cc080e7          	jalr	204(ra) # 800041d6 <iunlockput>
  end_op();
    80006112:	fffff097          	auipc	ra,0xfffff
    80006116:	8a4080e7          	jalr	-1884(ra) # 800049b6 <end_op>
  return 0;
    8000611a:	4501                	li	a0,0
}
    8000611c:	60aa                	ld	ra,136(sp)
    8000611e:	640a                	ld	s0,128(sp)
    80006120:	6149                	addi	sp,sp,144
    80006122:	8082                	ret
    end_op();
    80006124:	fffff097          	auipc	ra,0xfffff
    80006128:	892080e7          	jalr	-1902(ra) # 800049b6 <end_op>
    return -1;
    8000612c:	557d                	li	a0,-1
    8000612e:	b7fd                	j	8000611c <sys_mkdir+0x4c>

0000000080006130 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006130:	7135                	addi	sp,sp,-160
    80006132:	ed06                	sd	ra,152(sp)
    80006134:	e922                	sd	s0,144(sp)
    80006136:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80006138:	ffffe097          	auipc	ra,0xffffe
    8000613c:	7fe080e7          	jalr	2046(ra) # 80004936 <begin_op>
  argint(1, &major);
    80006140:	f6c40593          	addi	a1,s0,-148
    80006144:	4505                	li	a0,1
    80006146:	ffffd097          	auipc	ra,0xffffd
    8000614a:	226080e7          	jalr	550(ra) # 8000336c <argint>
  argint(2, &minor);
    8000614e:	f6840593          	addi	a1,s0,-152
    80006152:	4509                	li	a0,2
    80006154:	ffffd097          	auipc	ra,0xffffd
    80006158:	218080e7          	jalr	536(ra) # 8000336c <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000615c:	08000613          	li	a2,128
    80006160:	f7040593          	addi	a1,s0,-144
    80006164:	4501                	li	a0,0
    80006166:	ffffd097          	auipc	ra,0xffffd
    8000616a:	246080e7          	jalr	582(ra) # 800033ac <argstr>
    8000616e:	02054b63          	bltz	a0,800061a4 <sys_mknod+0x74>
      (ip = create(path, T_DEVICE, major, minor)) == 0)
    80006172:	f6841683          	lh	a3,-152(s0)
    80006176:	f6c41603          	lh	a2,-148(s0)
    8000617a:	458d                	li	a1,3
    8000617c:	f7040513          	addi	a0,s0,-144
    80006180:	fffff097          	auipc	ra,0xfffff
    80006184:	75e080e7          	jalr	1886(ra) # 800058de <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80006188:	cd11                	beqz	a0,800061a4 <sys_mknod+0x74>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000618a:	ffffe097          	auipc	ra,0xffffe
    8000618e:	04c080e7          	jalr	76(ra) # 800041d6 <iunlockput>
  end_op();
    80006192:	fffff097          	auipc	ra,0xfffff
    80006196:	824080e7          	jalr	-2012(ra) # 800049b6 <end_op>
  return 0;
    8000619a:	4501                	li	a0,0
}
    8000619c:	60ea                	ld	ra,152(sp)
    8000619e:	644a                	ld	s0,144(sp)
    800061a0:	610d                	addi	sp,sp,160
    800061a2:	8082                	ret
    end_op();
    800061a4:	fffff097          	auipc	ra,0xfffff
    800061a8:	812080e7          	jalr	-2030(ra) # 800049b6 <end_op>
    return -1;
    800061ac:	557d                	li	a0,-1
    800061ae:	b7fd                	j	8000619c <sys_mknod+0x6c>

00000000800061b0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800061b0:	7135                	addi	sp,sp,-160
    800061b2:	ed06                	sd	ra,152(sp)
    800061b4:	e922                	sd	s0,144(sp)
    800061b6:	e526                	sd	s1,136(sp)
    800061b8:	e14a                	sd	s2,128(sp)
    800061ba:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800061bc:	ffffc097          	auipc	ra,0xffffc
    800061c0:	abc080e7          	jalr	-1348(ra) # 80001c78 <myproc>
    800061c4:	892a                	mv	s2,a0

  begin_op();
    800061c6:	ffffe097          	auipc	ra,0xffffe
    800061ca:	770080e7          	jalr	1904(ra) # 80004936 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800061ce:	08000613          	li	a2,128
    800061d2:	f6040593          	addi	a1,s0,-160
    800061d6:	4501                	li	a0,0
    800061d8:	ffffd097          	auipc	ra,0xffffd
    800061dc:	1d4080e7          	jalr	468(ra) # 800033ac <argstr>
    800061e0:	04054b63          	bltz	a0,80006236 <sys_chdir+0x86>
    800061e4:	f6040513          	addi	a0,s0,-160
    800061e8:	ffffe097          	auipc	ra,0xffffe
    800061ec:	532080e7          	jalr	1330(ra) # 8000471a <namei>
    800061f0:	84aa                	mv	s1,a0
    800061f2:	c131                	beqz	a0,80006236 <sys_chdir+0x86>
  {
    end_op();
    return -1;
  }
  ilock(ip);
    800061f4:	ffffe097          	auipc	ra,0xffffe
    800061f8:	d80080e7          	jalr	-640(ra) # 80003f74 <ilock>
  if (ip->type != T_DIR)
    800061fc:	04449703          	lh	a4,68(s1)
    80006200:	4785                	li	a5,1
    80006202:	04f71063          	bne	a4,a5,80006242 <sys_chdir+0x92>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006206:	8526                	mv	a0,s1
    80006208:	ffffe097          	auipc	ra,0xffffe
    8000620c:	e2e080e7          	jalr	-466(ra) # 80004036 <iunlock>
  iput(p->cwd);
    80006210:	15093503          	ld	a0,336(s2)
    80006214:	ffffe097          	auipc	ra,0xffffe
    80006218:	f1a080e7          	jalr	-230(ra) # 8000412e <iput>
  end_op();
    8000621c:	ffffe097          	auipc	ra,0xffffe
    80006220:	79a080e7          	jalr	1946(ra) # 800049b6 <end_op>
  p->cwd = ip;
    80006224:	14993823          	sd	s1,336(s2)
  return 0;
    80006228:	4501                	li	a0,0
}
    8000622a:	60ea                	ld	ra,152(sp)
    8000622c:	644a                	ld	s0,144(sp)
    8000622e:	64aa                	ld	s1,136(sp)
    80006230:	690a                	ld	s2,128(sp)
    80006232:	610d                	addi	sp,sp,160
    80006234:	8082                	ret
    end_op();
    80006236:	ffffe097          	auipc	ra,0xffffe
    8000623a:	780080e7          	jalr	1920(ra) # 800049b6 <end_op>
    return -1;
    8000623e:	557d                	li	a0,-1
    80006240:	b7ed                	j	8000622a <sys_chdir+0x7a>
    iunlockput(ip);
    80006242:	8526                	mv	a0,s1
    80006244:	ffffe097          	auipc	ra,0xffffe
    80006248:	f92080e7          	jalr	-110(ra) # 800041d6 <iunlockput>
    end_op();
    8000624c:	ffffe097          	auipc	ra,0xffffe
    80006250:	76a080e7          	jalr	1898(ra) # 800049b6 <end_op>
    return -1;
    80006254:	557d                	li	a0,-1
    80006256:	bfd1                	j	8000622a <sys_chdir+0x7a>

0000000080006258 <sys_exec>:

uint64
sys_exec(void)
{
    80006258:	7145                	addi	sp,sp,-464
    8000625a:	e786                	sd	ra,456(sp)
    8000625c:	e3a2                	sd	s0,448(sp)
    8000625e:	ff26                	sd	s1,440(sp)
    80006260:	fb4a                	sd	s2,432(sp)
    80006262:	f74e                	sd	s3,424(sp)
    80006264:	f352                	sd	s4,416(sp)
    80006266:	ef56                	sd	s5,408(sp)
    80006268:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000626a:	e3840593          	addi	a1,s0,-456
    8000626e:	4505                	li	a0,1
    80006270:	ffffd097          	auipc	ra,0xffffd
    80006274:	11c080e7          	jalr	284(ra) # 8000338c <argaddr>
  if (argstr(0, path, MAXPATH) < 0)
    80006278:	08000613          	li	a2,128
    8000627c:	f4040593          	addi	a1,s0,-192
    80006280:	4501                	li	a0,0
    80006282:	ffffd097          	auipc	ra,0xffffd
    80006286:	12a080e7          	jalr	298(ra) # 800033ac <argstr>
    8000628a:	87aa                	mv	a5,a0
  {
    return -1;
    8000628c:	557d                	li	a0,-1
  if (argstr(0, path, MAXPATH) < 0)
    8000628e:	0c07c263          	bltz	a5,80006352 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80006292:	10000613          	li	a2,256
    80006296:	4581                	li	a1,0
    80006298:	e4040513          	addi	a0,s0,-448
    8000629c:	ffffb097          	auipc	ra,0xffffb
    800062a0:	c16080e7          	jalr	-1002(ra) # 80000eb2 <memset>
  for (i = 0;; i++)
  {
    if (i >= NELEM(argv))
    800062a4:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800062a8:	89a6                	mv	s3,s1
    800062aa:	4901                	li	s2,0
    if (i >= NELEM(argv))
    800062ac:	02000a13          	li	s4,32
    800062b0:	00090a9b          	sext.w	s5,s2
    {
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    800062b4:	00391793          	slli	a5,s2,0x3
    800062b8:	e3040593          	addi	a1,s0,-464
    800062bc:	e3843503          	ld	a0,-456(s0)
    800062c0:	953e                	add	a0,a0,a5
    800062c2:	ffffd097          	auipc	ra,0xffffd
    800062c6:	00c080e7          	jalr	12(ra) # 800032ce <fetchaddr>
    800062ca:	02054a63          	bltz	a0,800062fe <sys_exec+0xa6>
    {
      goto bad;
    }
    if (uarg == 0)
    800062ce:	e3043783          	ld	a5,-464(s0)
    800062d2:	c3b9                	beqz	a5,80006318 <sys_exec+0xc0>
    {
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800062d4:	ffffb097          	auipc	ra,0xffffb
    800062d8:	9de080e7          	jalr	-1570(ra) # 80000cb2 <kalloc>
    800062dc:	85aa                	mv	a1,a0
    800062de:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    800062e2:	cd11                	beqz	a0,800062fe <sys_exec+0xa6>
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800062e4:	6605                	lui	a2,0x1
    800062e6:	e3043503          	ld	a0,-464(s0)
    800062ea:	ffffd097          	auipc	ra,0xffffd
    800062ee:	036080e7          	jalr	54(ra) # 80003320 <fetchstr>
    800062f2:	00054663          	bltz	a0,800062fe <sys_exec+0xa6>
    if (i >= NELEM(argv))
    800062f6:	0905                	addi	s2,s2,1
    800062f8:	09a1                	addi	s3,s3,8
    800062fa:	fb491be3          	bne	s2,s4,800062b0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800062fe:	10048913          	addi	s2,s1,256
    80006302:	6088                	ld	a0,0(s1)
    80006304:	c531                	beqz	a0,80006350 <sys_exec+0xf8>
    kfree(argv[i]);
    80006306:	ffffa097          	auipc	ra,0xffffa
    8000630a:	7f2080e7          	jalr	2034(ra) # 80000af8 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000630e:	04a1                	addi	s1,s1,8
    80006310:	ff2499e3          	bne	s1,s2,80006302 <sys_exec+0xaa>
  return -1;
    80006314:	557d                	li	a0,-1
    80006316:	a835                	j	80006352 <sys_exec+0xfa>
      argv[i] = 0;
    80006318:	0a8e                	slli	s5,s5,0x3
    8000631a:	fc040793          	addi	a5,s0,-64
    8000631e:	9abe                	add	s5,s5,a5
    80006320:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80006324:	e4040593          	addi	a1,s0,-448
    80006328:	f4040513          	addi	a0,s0,-192
    8000632c:	fffff097          	auipc	ra,0xfffff
    80006330:	150080e7          	jalr	336(ra) # 8000547c <exec>
    80006334:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006336:	10048993          	addi	s3,s1,256
    8000633a:	6088                	ld	a0,0(s1)
    8000633c:	c901                	beqz	a0,8000634c <sys_exec+0xf4>
    kfree(argv[i]);
    8000633e:	ffffa097          	auipc	ra,0xffffa
    80006342:	7ba080e7          	jalr	1978(ra) # 80000af8 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006346:	04a1                	addi	s1,s1,8
    80006348:	ff3499e3          	bne	s1,s3,8000633a <sys_exec+0xe2>
  return ret;
    8000634c:	854a                	mv	a0,s2
    8000634e:	a011                	j	80006352 <sys_exec+0xfa>
  return -1;
    80006350:	557d                	li	a0,-1
}
    80006352:	60be                	ld	ra,456(sp)
    80006354:	641e                	ld	s0,448(sp)
    80006356:	74fa                	ld	s1,440(sp)
    80006358:	795a                	ld	s2,432(sp)
    8000635a:	79ba                	ld	s3,424(sp)
    8000635c:	7a1a                	ld	s4,416(sp)
    8000635e:	6afa                	ld	s5,408(sp)
    80006360:	6179                	addi	sp,sp,464
    80006362:	8082                	ret

0000000080006364 <sys_pipe>:

uint64
sys_pipe(void)
{
    80006364:	7139                	addi	sp,sp,-64
    80006366:	fc06                	sd	ra,56(sp)
    80006368:	f822                	sd	s0,48(sp)
    8000636a:	f426                	sd	s1,40(sp)
    8000636c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000636e:	ffffc097          	auipc	ra,0xffffc
    80006372:	90a080e7          	jalr	-1782(ra) # 80001c78 <myproc>
    80006376:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006378:	fd840593          	addi	a1,s0,-40
    8000637c:	4501                	li	a0,0
    8000637e:	ffffd097          	auipc	ra,0xffffd
    80006382:	00e080e7          	jalr	14(ra) # 8000338c <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    80006386:	fc840593          	addi	a1,s0,-56
    8000638a:	fd040513          	addi	a0,s0,-48
    8000638e:	fffff097          	auipc	ra,0xfffff
    80006392:	da4080e7          	jalr	-604(ra) # 80005132 <pipealloc>
    return -1;
    80006396:	57fd                	li	a5,-1
  if (pipealloc(&rf, &wf) < 0)
    80006398:	0c054463          	bltz	a0,80006460 <sys_pipe+0xfc>
  fd0 = -1;
    8000639c:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    800063a0:	fd043503          	ld	a0,-48(s0)
    800063a4:	fffff097          	auipc	ra,0xfffff
    800063a8:	4f8080e7          	jalr	1272(ra) # 8000589c <fdalloc>
    800063ac:	fca42223          	sw	a0,-60(s0)
    800063b0:	08054b63          	bltz	a0,80006446 <sys_pipe+0xe2>
    800063b4:	fc843503          	ld	a0,-56(s0)
    800063b8:	fffff097          	auipc	ra,0xfffff
    800063bc:	4e4080e7          	jalr	1252(ra) # 8000589c <fdalloc>
    800063c0:	fca42023          	sw	a0,-64(s0)
    800063c4:	06054863          	bltz	a0,80006434 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800063c8:	4691                	li	a3,4
    800063ca:	fc440613          	addi	a2,s0,-60
    800063ce:	fd843583          	ld	a1,-40(s0)
    800063d2:	68a8                	ld	a0,80(s1)
    800063d4:	ffffb097          	auipc	ra,0xffffb
    800063d8:	4b2080e7          	jalr	1202(ra) # 80001886 <copyout>
    800063dc:	02054063          	bltz	a0,800063fc <sys_pipe+0x98>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800063e0:	4691                	li	a3,4
    800063e2:	fc040613          	addi	a2,s0,-64
    800063e6:	fd843583          	ld	a1,-40(s0)
    800063ea:	0591                	addi	a1,a1,4
    800063ec:	68a8                	ld	a0,80(s1)
    800063ee:	ffffb097          	auipc	ra,0xffffb
    800063f2:	498080e7          	jalr	1176(ra) # 80001886 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800063f6:	4781                	li	a5,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800063f8:	06055463          	bgez	a0,80006460 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800063fc:	fc442783          	lw	a5,-60(s0)
    80006400:	07e9                	addi	a5,a5,26
    80006402:	078e                	slli	a5,a5,0x3
    80006404:	97a6                	add	a5,a5,s1
    80006406:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000640a:	fc042503          	lw	a0,-64(s0)
    8000640e:	0569                	addi	a0,a0,26
    80006410:	050e                	slli	a0,a0,0x3
    80006412:	94aa                	add	s1,s1,a0
    80006414:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006418:	fd043503          	ld	a0,-48(s0)
    8000641c:	fffff097          	auipc	ra,0xfffff
    80006420:	9e6080e7          	jalr	-1562(ra) # 80004e02 <fileclose>
    fileclose(wf);
    80006424:	fc843503          	ld	a0,-56(s0)
    80006428:	fffff097          	auipc	ra,0xfffff
    8000642c:	9da080e7          	jalr	-1574(ra) # 80004e02 <fileclose>
    return -1;
    80006430:	57fd                	li	a5,-1
    80006432:	a03d                	j	80006460 <sys_pipe+0xfc>
    if (fd0 >= 0)
    80006434:	fc442783          	lw	a5,-60(s0)
    80006438:	0007c763          	bltz	a5,80006446 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000643c:	07e9                	addi	a5,a5,26
    8000643e:	078e                	slli	a5,a5,0x3
    80006440:	94be                	add	s1,s1,a5
    80006442:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80006446:	fd043503          	ld	a0,-48(s0)
    8000644a:	fffff097          	auipc	ra,0xfffff
    8000644e:	9b8080e7          	jalr	-1608(ra) # 80004e02 <fileclose>
    fileclose(wf);
    80006452:	fc843503          	ld	a0,-56(s0)
    80006456:	fffff097          	auipc	ra,0xfffff
    8000645a:	9ac080e7          	jalr	-1620(ra) # 80004e02 <fileclose>
    return -1;
    8000645e:	57fd                	li	a5,-1
}
    80006460:	853e                	mv	a0,a5
    80006462:	70e2                	ld	ra,56(sp)
    80006464:	7442                	ld	s0,48(sp)
    80006466:	74a2                	ld	s1,40(sp)
    80006468:	6121                	addi	sp,sp,64
    8000646a:	8082                	ret

000000008000646c <sys_set_priority>:
//   argaddr(0, &(p->ticks));
//   argaddr(1, &(p->funcadr));
//   return 0;
// }
uint64 sys_set_priority(void)
{
    8000646c:	7139                	addi	sp,sp,-64
    8000646e:	fc06                	sd	ra,56(sp)
    80006470:	f822                	sd	s0,48(sp)
    80006472:	f426                	sd	s1,40(sp)
    80006474:	f04a                	sd	s2,32(sp)
    80006476:	ec4e                	sd	s3,24(sp)
    80006478:	0080                	addi	s0,sp,64
  uint64 pid;
  uint64 new_priority;
  argaddr(0, &(pid));
    8000647a:	fc840593          	addi	a1,s0,-56
    8000647e:	4501                	li	a0,0
    80006480:	ffffd097          	auipc	ra,0xffffd
    80006484:	f0c080e7          	jalr	-244(ra) # 8000338c <argaddr>
  argaddr(1, &(new_priority));
    80006488:	fc040593          	addi	a1,s0,-64
    8000648c:	4505                	li	a0,1
    8000648e:	ffffd097          	auipc	ra,0xffffd
    80006492:	efe080e7          	jalr	-258(ra) # 8000338c <argaddr>
  struct proc *p = myproc();
    80006496:	ffffb097          	auipc	ra,0xffffb
    8000649a:	7e2080e7          	jalr	2018(ra) # 80001c78 <myproc>
  int f = 0;
  for (p = proc; p < &proc[NPROC]; p++)
    8000649e:	0022b497          	auipc	s1,0x22b
    800064a2:	b9a48493          	addi	s1,s1,-1126 # 80231038 <proc>
    800064a6:	00231917          	auipc	s2,0x231
    800064aa:	f9290913          	addi	s2,s2,-110 # 80237438 <tickslock>
  {
    acquire(&p->lock);
    800064ae:	8526                	mv	a0,s1
    800064b0:	ffffb097          	auipc	ra,0xffffb
    800064b4:	906080e7          	jalr	-1786(ra) # 80000db6 <acquire>
    if (p->pid == pid)
    800064b8:	fc843583          	ld	a1,-56(s0)
    800064bc:	589c                	lw	a5,48(s1)
    800064be:	00b78c63          	beq	a5,a1,800064d6 <sys_set_priority+0x6a>
        f = 1;
      }
      release(&p->lock);
      break;
    }
    release(&p->lock);
    800064c2:	8526                	mv	a0,s1
    800064c4:	ffffb097          	auipc	ra,0xffffb
    800064c8:	9a6080e7          	jalr	-1626(ra) # 80000e6a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800064cc:	19048493          	addi	s1,s1,400
    800064d0:	fd249fe3          	bne	s1,s2,800064ae <sys_set_priority+0x42>
    800064d4:	a849                	j	80006566 <sys_set_priority+0xfa>
      int RBI = (3 * p->dynamicrtime - p->dynamicstime - p->wtime) * 50;
    800064d6:	1744a703          	lw	a4,372(s1)
    800064da:	17c4a603          	lw	a2,380(s1)
    800064de:	1784a683          	lw	a3,376(s1)
    800064e2:	0017179b          	slliw	a5,a4,0x1
    800064e6:	9fb9                	addw	a5,a5,a4
    800064e8:	9f91                	subw	a5,a5,a2
    800064ea:	9f95                	subw	a5,a5,a3
    800064ec:	03200513          	li	a0,50
    800064f0:	02a787bb          	mulw	a5,a5,a0
      RBI /= (p->dynamicrtime + p->dynamicstime + p->wtime + 1);
    800064f4:	9f31                	addw	a4,a4,a2
    800064f6:	9f35                	addw	a4,a4,a3
    800064f8:	2705                	addiw	a4,a4,1
    800064fa:	02e7c7bb          	divw	a5,a5,a4
      int DP = p->staticpriority + RBI;
    800064fe:	0007871b          	sext.w	a4,a5
    80006502:	fff74713          	not	a4,a4
    80006506:	977d                	srai	a4,a4,0x3f
    80006508:	8ff9                	and	a5,a5,a4
    8000650a:	1804a703          	lw	a4,384(s1)
    8000650e:	9fb9                	addw	a5,a5,a4
      if (DP > 100)
    80006510:	89be                	mv	s3,a5
    80006512:	2781                	sext.w	a5,a5
    80006514:	06400713          	li	a4,100
    80006518:	00f75463          	bge	a4,a5,80006520 <sys_set_priority+0xb4>
    8000651c:	06400993          	li	s3,100
    80006520:	2981                	sext.w	s3,s3
      p->staticpriority = new_priority;
    80006522:	fc042783          	lw	a5,-64(s0)
    80006526:	18f4a023          	sw	a5,384(s1)
      p->defaultflag = 1;
    8000652a:	4705                	li	a4,1
    8000652c:	18e4a423          	sw	a4,392(s1)
      int DP2 = p->staticpriority + 25;
    80006530:	27e5                	addiw	a5,a5,25
      if (DP2 > 100)
    80006532:	893e                	mv	s2,a5
    80006534:	2781                	sext.w	a5,a5
    80006536:	06400713          	li	a4,100
    8000653a:	00f75463          	bge	a4,a5,80006542 <sys_set_priority+0xd6>
    8000653e:	06400913          	li	s2,100
    80006542:	2901                	sext.w	s2,s2
      printf("priority of process with pid %d changed from %d to %d\n", pid, DP, DP2);
    80006544:	86ca                	mv	a3,s2
    80006546:	864e                	mv	a2,s3
    80006548:	00002517          	auipc	a0,0x2
    8000654c:	27850513          	addi	a0,a0,632 # 800087c0 <syscalls+0x308>
    80006550:	ffffa097          	auipc	ra,0xffffa
    80006554:	038080e7          	jalr	56(ra) # 80000588 <printf>
      release(&p->lock);
    80006558:	8526                	mv	a0,s1
    8000655a:	ffffb097          	auipc	ra,0xffffb
    8000655e:	910080e7          	jalr	-1776(ra) # 80000e6a <release>
  }
  if (f)
    80006562:	01394a63          	blt	s2,s3,80006576 <sys_set_priority+0x10a>
  {

    yield();
  }
  return 0;
    80006566:	4501                	li	a0,0
    80006568:	70e2                	ld	ra,56(sp)
    8000656a:	7442                	ld	s0,48(sp)
    8000656c:	74a2                	ld	s1,40(sp)
    8000656e:	7902                	ld	s2,32(sp)
    80006570:	69e2                	ld	s3,24(sp)
    80006572:	6121                	addi	sp,sp,64
    80006574:	8082                	ret
    yield();
    80006576:	ffffc097          	auipc	ra,0xffffc
    8000657a:	ff6080e7          	jalr	-10(ra) # 8000256c <yield>
    8000657e:	b7e5                	j	80006566 <sys_set_priority+0xfa>

0000000080006580 <kernelvec>:
    80006580:	7111                	addi	sp,sp,-256
    80006582:	e006                	sd	ra,0(sp)
    80006584:	e40a                	sd	sp,8(sp)
    80006586:	e80e                	sd	gp,16(sp)
    80006588:	ec12                	sd	tp,24(sp)
    8000658a:	f016                	sd	t0,32(sp)
    8000658c:	f41a                	sd	t1,40(sp)
    8000658e:	f81e                	sd	t2,48(sp)
    80006590:	fc22                	sd	s0,56(sp)
    80006592:	e0a6                	sd	s1,64(sp)
    80006594:	e4aa                	sd	a0,72(sp)
    80006596:	e8ae                	sd	a1,80(sp)
    80006598:	ecb2                	sd	a2,88(sp)
    8000659a:	f0b6                	sd	a3,96(sp)
    8000659c:	f4ba                	sd	a4,104(sp)
    8000659e:	f8be                	sd	a5,112(sp)
    800065a0:	fcc2                	sd	a6,120(sp)
    800065a2:	e146                	sd	a7,128(sp)
    800065a4:	e54a                	sd	s2,136(sp)
    800065a6:	e94e                	sd	s3,144(sp)
    800065a8:	ed52                	sd	s4,152(sp)
    800065aa:	f156                	sd	s5,160(sp)
    800065ac:	f55a                	sd	s6,168(sp)
    800065ae:	f95e                	sd	s7,176(sp)
    800065b0:	fd62                	sd	s8,184(sp)
    800065b2:	e1e6                	sd	s9,192(sp)
    800065b4:	e5ea                	sd	s10,200(sp)
    800065b6:	e9ee                	sd	s11,208(sp)
    800065b8:	edf2                	sd	t3,216(sp)
    800065ba:	f1f6                	sd	t4,224(sp)
    800065bc:	f5fa                	sd	t5,232(sp)
    800065be:	f9fe                	sd	t6,240(sp)
    800065c0:	bdbfc0ef          	jal	ra,8000319a <kerneltrap>
    800065c4:	6082                	ld	ra,0(sp)
    800065c6:	6122                	ld	sp,8(sp)
    800065c8:	61c2                	ld	gp,16(sp)
    800065ca:	7282                	ld	t0,32(sp)
    800065cc:	7322                	ld	t1,40(sp)
    800065ce:	73c2                	ld	t2,48(sp)
    800065d0:	7462                	ld	s0,56(sp)
    800065d2:	6486                	ld	s1,64(sp)
    800065d4:	6526                	ld	a0,72(sp)
    800065d6:	65c6                	ld	a1,80(sp)
    800065d8:	6666                	ld	a2,88(sp)
    800065da:	7686                	ld	a3,96(sp)
    800065dc:	7726                	ld	a4,104(sp)
    800065de:	77c6                	ld	a5,112(sp)
    800065e0:	7866                	ld	a6,120(sp)
    800065e2:	688a                	ld	a7,128(sp)
    800065e4:	692a                	ld	s2,136(sp)
    800065e6:	69ca                	ld	s3,144(sp)
    800065e8:	6a6a                	ld	s4,152(sp)
    800065ea:	7a8a                	ld	s5,160(sp)
    800065ec:	7b2a                	ld	s6,168(sp)
    800065ee:	7bca                	ld	s7,176(sp)
    800065f0:	7c6a                	ld	s8,184(sp)
    800065f2:	6c8e                	ld	s9,192(sp)
    800065f4:	6d2e                	ld	s10,200(sp)
    800065f6:	6dce                	ld	s11,208(sp)
    800065f8:	6e6e                	ld	t3,216(sp)
    800065fa:	7e8e                	ld	t4,224(sp)
    800065fc:	7f2e                	ld	t5,232(sp)
    800065fe:	7fce                	ld	t6,240(sp)
    80006600:	6111                	addi	sp,sp,256
    80006602:	10200073          	sret
    80006606:	00000013          	nop
    8000660a:	00000013          	nop
    8000660e:	0001                	nop

0000000080006610 <timervec>:
    80006610:	34051573          	csrrw	a0,mscratch,a0
    80006614:	e10c                	sd	a1,0(a0)
    80006616:	e510                	sd	a2,8(a0)
    80006618:	e914                	sd	a3,16(a0)
    8000661a:	6d0c                	ld	a1,24(a0)
    8000661c:	7110                	ld	a2,32(a0)
    8000661e:	6194                	ld	a3,0(a1)
    80006620:	96b2                	add	a3,a3,a2
    80006622:	e194                	sd	a3,0(a1)
    80006624:	4589                	li	a1,2
    80006626:	14459073          	csrw	sip,a1
    8000662a:	6914                	ld	a3,16(a0)
    8000662c:	6510                	ld	a2,8(a0)
    8000662e:	610c                	ld	a1,0(a0)
    80006630:	34051573          	csrrw	a0,mscratch,a0
    80006634:	30200073          	mret
	...

000000008000663a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000663a:	1141                	addi	sp,sp,-16
    8000663c:	e422                	sd	s0,8(sp)
    8000663e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006640:	0c0007b7          	lui	a5,0xc000
    80006644:	4705                	li	a4,1
    80006646:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80006648:	c3d8                	sw	a4,4(a5)
}
    8000664a:	6422                	ld	s0,8(sp)
    8000664c:	0141                	addi	sp,sp,16
    8000664e:	8082                	ret

0000000080006650 <plicinithart>:

void
plicinithart(void)
{
    80006650:	1141                	addi	sp,sp,-16
    80006652:	e406                	sd	ra,8(sp)
    80006654:	e022                	sd	s0,0(sp)
    80006656:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006658:	ffffb097          	auipc	ra,0xffffb
    8000665c:	5f4080e7          	jalr	1524(ra) # 80001c4c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006660:	0085171b          	slliw	a4,a0,0x8
    80006664:	0c0027b7          	lui	a5,0xc002
    80006668:	97ba                	add	a5,a5,a4
    8000666a:	40200713          	li	a4,1026
    8000666e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006672:	00d5151b          	slliw	a0,a0,0xd
    80006676:	0c2017b7          	lui	a5,0xc201
    8000667a:	953e                	add	a0,a0,a5
    8000667c:	00052023          	sw	zero,0(a0)
}
    80006680:	60a2                	ld	ra,8(sp)
    80006682:	6402                	ld	s0,0(sp)
    80006684:	0141                	addi	sp,sp,16
    80006686:	8082                	ret

0000000080006688 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80006688:	1141                	addi	sp,sp,-16
    8000668a:	e406                	sd	ra,8(sp)
    8000668c:	e022                	sd	s0,0(sp)
    8000668e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006690:	ffffb097          	auipc	ra,0xffffb
    80006694:	5bc080e7          	jalr	1468(ra) # 80001c4c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006698:	00d5179b          	slliw	a5,a0,0xd
    8000669c:	0c201537          	lui	a0,0xc201
    800066a0:	953e                	add	a0,a0,a5
  return irq;
}
    800066a2:	4148                	lw	a0,4(a0)
    800066a4:	60a2                	ld	ra,8(sp)
    800066a6:	6402                	ld	s0,0(sp)
    800066a8:	0141                	addi	sp,sp,16
    800066aa:	8082                	ret

00000000800066ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800066ac:	1101                	addi	sp,sp,-32
    800066ae:	ec06                	sd	ra,24(sp)
    800066b0:	e822                	sd	s0,16(sp)
    800066b2:	e426                	sd	s1,8(sp)
    800066b4:	1000                	addi	s0,sp,32
    800066b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800066b8:	ffffb097          	auipc	ra,0xffffb
    800066bc:	594080e7          	jalr	1428(ra) # 80001c4c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800066c0:	00d5151b          	slliw	a0,a0,0xd
    800066c4:	0c2017b7          	lui	a5,0xc201
    800066c8:	97aa                	add	a5,a5,a0
    800066ca:	c3c4                	sw	s1,4(a5)
}
    800066cc:	60e2                	ld	ra,24(sp)
    800066ce:	6442                	ld	s0,16(sp)
    800066d0:	64a2                	ld	s1,8(sp)
    800066d2:	6105                	addi	sp,sp,32
    800066d4:	8082                	ret

00000000800066d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800066d6:	1141                	addi	sp,sp,-16
    800066d8:	e406                	sd	ra,8(sp)
    800066da:	e022                	sd	s0,0(sp)
    800066dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800066de:	479d                	li	a5,7
    800066e0:	04a7cc63          	blt	a5,a0,80006738 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800066e4:	0023c797          	auipc	a5,0x23c
    800066e8:	ff478793          	addi	a5,a5,-12 # 802426d8 <disk>
    800066ec:	97aa                	add	a5,a5,a0
    800066ee:	0187c783          	lbu	a5,24(a5)
    800066f2:	ebb9                	bnez	a5,80006748 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800066f4:	00451613          	slli	a2,a0,0x4
    800066f8:	0023c797          	auipc	a5,0x23c
    800066fc:	fe078793          	addi	a5,a5,-32 # 802426d8 <disk>
    80006700:	6394                	ld	a3,0(a5)
    80006702:	96b2                	add	a3,a3,a2
    80006704:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80006708:	6398                	ld	a4,0(a5)
    8000670a:	9732                	add	a4,a4,a2
    8000670c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006710:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006714:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006718:	953e                	add	a0,a0,a5
    8000671a:	4785                	li	a5,1
    8000671c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80006720:	0023c517          	auipc	a0,0x23c
    80006724:	fd050513          	addi	a0,a0,-48 # 802426f0 <disk+0x18>
    80006728:	ffffc097          	auipc	ra,0xffffc
    8000672c:	ee4080e7          	jalr	-284(ra) # 8000260c <wakeup>
}
    80006730:	60a2                	ld	ra,8(sp)
    80006732:	6402                	ld	s0,0(sp)
    80006734:	0141                	addi	sp,sp,16
    80006736:	8082                	ret
    panic("free_desc 1");
    80006738:	00002517          	auipc	a0,0x2
    8000673c:	0c050513          	addi	a0,a0,192 # 800087f8 <syscalls+0x340>
    80006740:	ffffa097          	auipc	ra,0xffffa
    80006744:	dfe080e7          	jalr	-514(ra) # 8000053e <panic>
    panic("free_desc 2");
    80006748:	00002517          	auipc	a0,0x2
    8000674c:	0c050513          	addi	a0,a0,192 # 80008808 <syscalls+0x350>
    80006750:	ffffa097          	auipc	ra,0xffffa
    80006754:	dee080e7          	jalr	-530(ra) # 8000053e <panic>

0000000080006758 <virtio_disk_init>:
{
    80006758:	1101                	addi	sp,sp,-32
    8000675a:	ec06                	sd	ra,24(sp)
    8000675c:	e822                	sd	s0,16(sp)
    8000675e:	e426                	sd	s1,8(sp)
    80006760:	e04a                	sd	s2,0(sp)
    80006762:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006764:	00002597          	auipc	a1,0x2
    80006768:	0b458593          	addi	a1,a1,180 # 80008818 <syscalls+0x360>
    8000676c:	0023c517          	auipc	a0,0x23c
    80006770:	09450513          	addi	a0,a0,148 # 80242800 <disk+0x128>
    80006774:	ffffa097          	auipc	ra,0xffffa
    80006778:	5b2080e7          	jalr	1458(ra) # 80000d26 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000677c:	100017b7          	lui	a5,0x10001
    80006780:	4398                	lw	a4,0(a5)
    80006782:	2701                	sext.w	a4,a4
    80006784:	747277b7          	lui	a5,0x74727
    80006788:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000678c:	14f71c63          	bne	a4,a5,800068e4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006790:	100017b7          	lui	a5,0x10001
    80006794:	43dc                	lw	a5,4(a5)
    80006796:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006798:	4709                	li	a4,2
    8000679a:	14e79563          	bne	a5,a4,800068e4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000679e:	100017b7          	lui	a5,0x10001
    800067a2:	479c                	lw	a5,8(a5)
    800067a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800067a6:	12e79f63          	bne	a5,a4,800068e4 <virtio_disk_init+0x18c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800067aa:	100017b7          	lui	a5,0x10001
    800067ae:	47d8                	lw	a4,12(a5)
    800067b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800067b2:	554d47b7          	lui	a5,0x554d4
    800067b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800067ba:	12f71563          	bne	a4,a5,800068e4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800067be:	100017b7          	lui	a5,0x10001
    800067c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800067c6:	4705                	li	a4,1
    800067c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800067ca:	470d                	li	a4,3
    800067cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800067ce:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800067d0:	c7ffe737          	lui	a4,0xc7ffe
    800067d4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47dbbf47>
    800067d8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800067da:	2701                	sext.w	a4,a4
    800067dc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800067de:	472d                	li	a4,11
    800067e0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800067e2:	5bbc                	lw	a5,112(a5)
    800067e4:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800067e8:	8ba1                	andi	a5,a5,8
    800067ea:	10078563          	beqz	a5,800068f4 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800067ee:	100017b7          	lui	a5,0x10001
    800067f2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800067f6:	43fc                	lw	a5,68(a5)
    800067f8:	2781                	sext.w	a5,a5
    800067fa:	10079563          	bnez	a5,80006904 <virtio_disk_init+0x1ac>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800067fe:	100017b7          	lui	a5,0x10001
    80006802:	5bdc                	lw	a5,52(a5)
    80006804:	2781                	sext.w	a5,a5
  if(max == 0)
    80006806:	10078763          	beqz	a5,80006914 <virtio_disk_init+0x1bc>
  if(max < NUM)
    8000680a:	471d                	li	a4,7
    8000680c:	10f77c63          	bgeu	a4,a5,80006924 <virtio_disk_init+0x1cc>
  disk.desc = kalloc();
    80006810:	ffffa097          	auipc	ra,0xffffa
    80006814:	4a2080e7          	jalr	1186(ra) # 80000cb2 <kalloc>
    80006818:	0023c497          	auipc	s1,0x23c
    8000681c:	ec048493          	addi	s1,s1,-320 # 802426d8 <disk>
    80006820:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006822:	ffffa097          	auipc	ra,0xffffa
    80006826:	490080e7          	jalr	1168(ra) # 80000cb2 <kalloc>
    8000682a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000682c:	ffffa097          	auipc	ra,0xffffa
    80006830:	486080e7          	jalr	1158(ra) # 80000cb2 <kalloc>
    80006834:	87aa                	mv	a5,a0
    80006836:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006838:	6088                	ld	a0,0(s1)
    8000683a:	cd6d                	beqz	a0,80006934 <virtio_disk_init+0x1dc>
    8000683c:	0023c717          	auipc	a4,0x23c
    80006840:	ea473703          	ld	a4,-348(a4) # 802426e0 <disk+0x8>
    80006844:	cb65                	beqz	a4,80006934 <virtio_disk_init+0x1dc>
    80006846:	c7fd                	beqz	a5,80006934 <virtio_disk_init+0x1dc>
  memset(disk.desc, 0, PGSIZE);
    80006848:	6605                	lui	a2,0x1
    8000684a:	4581                	li	a1,0
    8000684c:	ffffa097          	auipc	ra,0xffffa
    80006850:	666080e7          	jalr	1638(ra) # 80000eb2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006854:	0023c497          	auipc	s1,0x23c
    80006858:	e8448493          	addi	s1,s1,-380 # 802426d8 <disk>
    8000685c:	6605                	lui	a2,0x1
    8000685e:	4581                	li	a1,0
    80006860:	6488                	ld	a0,8(s1)
    80006862:	ffffa097          	auipc	ra,0xffffa
    80006866:	650080e7          	jalr	1616(ra) # 80000eb2 <memset>
  memset(disk.used, 0, PGSIZE);
    8000686a:	6605                	lui	a2,0x1
    8000686c:	4581                	li	a1,0
    8000686e:	6888                	ld	a0,16(s1)
    80006870:	ffffa097          	auipc	ra,0xffffa
    80006874:	642080e7          	jalr	1602(ra) # 80000eb2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006878:	100017b7          	lui	a5,0x10001
    8000687c:	4721                	li	a4,8
    8000687e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006880:	4098                	lw	a4,0(s1)
    80006882:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006886:	40d8                	lw	a4,4(s1)
    80006888:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000688c:	6498                	ld	a4,8(s1)
    8000688e:	0007069b          	sext.w	a3,a4
    80006892:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006896:	9701                	srai	a4,a4,0x20
    80006898:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000689c:	6898                	ld	a4,16(s1)
    8000689e:	0007069b          	sext.w	a3,a4
    800068a2:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800068a6:	9701                	srai	a4,a4,0x20
    800068a8:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800068ac:	4705                	li	a4,1
    800068ae:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800068b0:	00e48c23          	sb	a4,24(s1)
    800068b4:	00e48ca3          	sb	a4,25(s1)
    800068b8:	00e48d23          	sb	a4,26(s1)
    800068bc:	00e48da3          	sb	a4,27(s1)
    800068c0:	00e48e23          	sb	a4,28(s1)
    800068c4:	00e48ea3          	sb	a4,29(s1)
    800068c8:	00e48f23          	sb	a4,30(s1)
    800068cc:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800068d0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800068d4:	0727a823          	sw	s2,112(a5)
}
    800068d8:	60e2                	ld	ra,24(sp)
    800068da:	6442                	ld	s0,16(sp)
    800068dc:	64a2                	ld	s1,8(sp)
    800068de:	6902                	ld	s2,0(sp)
    800068e0:	6105                	addi	sp,sp,32
    800068e2:	8082                	ret
    panic("could not find virtio disk");
    800068e4:	00002517          	auipc	a0,0x2
    800068e8:	f4450513          	addi	a0,a0,-188 # 80008828 <syscalls+0x370>
    800068ec:	ffffa097          	auipc	ra,0xffffa
    800068f0:	c52080e7          	jalr	-942(ra) # 8000053e <panic>
    panic("virtio disk FEATURES_OK unset");
    800068f4:	00002517          	auipc	a0,0x2
    800068f8:	f5450513          	addi	a0,a0,-172 # 80008848 <syscalls+0x390>
    800068fc:	ffffa097          	auipc	ra,0xffffa
    80006900:	c42080e7          	jalr	-958(ra) # 8000053e <panic>
    panic("virtio disk should not be ready");
    80006904:	00002517          	auipc	a0,0x2
    80006908:	f6450513          	addi	a0,a0,-156 # 80008868 <syscalls+0x3b0>
    8000690c:	ffffa097          	auipc	ra,0xffffa
    80006910:	c32080e7          	jalr	-974(ra) # 8000053e <panic>
    panic("virtio disk has no queue 0");
    80006914:	00002517          	auipc	a0,0x2
    80006918:	f7450513          	addi	a0,a0,-140 # 80008888 <syscalls+0x3d0>
    8000691c:	ffffa097          	auipc	ra,0xffffa
    80006920:	c22080e7          	jalr	-990(ra) # 8000053e <panic>
    panic("virtio disk max queue too short");
    80006924:	00002517          	auipc	a0,0x2
    80006928:	f8450513          	addi	a0,a0,-124 # 800088a8 <syscalls+0x3f0>
    8000692c:	ffffa097          	auipc	ra,0xffffa
    80006930:	c12080e7          	jalr	-1006(ra) # 8000053e <panic>
    panic("virtio disk kalloc");
    80006934:	00002517          	auipc	a0,0x2
    80006938:	f9450513          	addi	a0,a0,-108 # 800088c8 <syscalls+0x410>
    8000693c:	ffffa097          	auipc	ra,0xffffa
    80006940:	c02080e7          	jalr	-1022(ra) # 8000053e <panic>

0000000080006944 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006944:	7119                	addi	sp,sp,-128
    80006946:	fc86                	sd	ra,120(sp)
    80006948:	f8a2                	sd	s0,112(sp)
    8000694a:	f4a6                	sd	s1,104(sp)
    8000694c:	f0ca                	sd	s2,96(sp)
    8000694e:	ecce                	sd	s3,88(sp)
    80006950:	e8d2                	sd	s4,80(sp)
    80006952:	e4d6                	sd	s5,72(sp)
    80006954:	e0da                	sd	s6,64(sp)
    80006956:	fc5e                	sd	s7,56(sp)
    80006958:	f862                	sd	s8,48(sp)
    8000695a:	f466                	sd	s9,40(sp)
    8000695c:	f06a                	sd	s10,32(sp)
    8000695e:	ec6e                	sd	s11,24(sp)
    80006960:	0100                	addi	s0,sp,128
    80006962:	8aaa                	mv	s5,a0
    80006964:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006966:	00c52d03          	lw	s10,12(a0)
    8000696a:	001d1d1b          	slliw	s10,s10,0x1
    8000696e:	1d02                	slli	s10,s10,0x20
    80006970:	020d5d13          	srli	s10,s10,0x20

  acquire(&disk.vdisk_lock);
    80006974:	0023c517          	auipc	a0,0x23c
    80006978:	e8c50513          	addi	a0,a0,-372 # 80242800 <disk+0x128>
    8000697c:	ffffa097          	auipc	ra,0xffffa
    80006980:	43a080e7          	jalr	1082(ra) # 80000db6 <acquire>
  for(int i = 0; i < 3; i++){
    80006984:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80006986:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006988:	0023cb97          	auipc	s7,0x23c
    8000698c:	d50b8b93          	addi	s7,s7,-688 # 802426d8 <disk>
  for(int i = 0; i < 3; i++){
    80006990:	4b0d                	li	s6,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006992:	0023cc97          	auipc	s9,0x23c
    80006996:	e6ec8c93          	addi	s9,s9,-402 # 80242800 <disk+0x128>
    8000699a:	a08d                	j	800069fc <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    8000699c:	00fb8733          	add	a4,s7,a5
    800069a0:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800069a4:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800069a6:	0207c563          	bltz	a5,800069d0 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800069aa:	2905                	addiw	s2,s2,1
    800069ac:	0611                	addi	a2,a2,4
    800069ae:	05690c63          	beq	s2,s6,80006a06 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800069b2:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800069b4:	0023c717          	auipc	a4,0x23c
    800069b8:	d2470713          	addi	a4,a4,-732 # 802426d8 <disk>
    800069bc:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800069be:	01874683          	lbu	a3,24(a4)
    800069c2:	fee9                	bnez	a3,8000699c <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800069c4:	2785                	addiw	a5,a5,1
    800069c6:	0705                	addi	a4,a4,1
    800069c8:	fe979be3          	bne	a5,s1,800069be <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800069cc:	57fd                	li	a5,-1
    800069ce:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800069d0:	01205d63          	blez	s2,800069ea <virtio_disk_rw+0xa6>
    800069d4:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    800069d6:	000a2503          	lw	a0,0(s4)
    800069da:	00000097          	auipc	ra,0x0
    800069de:	cfc080e7          	jalr	-772(ra) # 800066d6 <free_desc>
      for(int j = 0; j < i; j++)
    800069e2:	2d85                	addiw	s11,s11,1
    800069e4:	0a11                	addi	s4,s4,4
    800069e6:	ffb918e3          	bne	s2,s11,800069d6 <virtio_disk_rw+0x92>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800069ea:	85e6                	mv	a1,s9
    800069ec:	0023c517          	auipc	a0,0x23c
    800069f0:	d0450513          	addi	a0,a0,-764 # 802426f0 <disk+0x18>
    800069f4:	ffffc097          	auipc	ra,0xffffc
    800069f8:	bb4080e7          	jalr	-1100(ra) # 800025a8 <sleep>
  for(int i = 0; i < 3; i++){
    800069fc:	f8040a13          	addi	s4,s0,-128
{
    80006a00:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80006a02:	894e                	mv	s2,s3
    80006a04:	b77d                	j	800069b2 <virtio_disk_rw+0x6e>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006a06:	f8042583          	lw	a1,-128(s0)
    80006a0a:	00a58793          	addi	a5,a1,10
    80006a0e:	0792                	slli	a5,a5,0x4

  if(write)
    80006a10:	0023c617          	auipc	a2,0x23c
    80006a14:	cc860613          	addi	a2,a2,-824 # 802426d8 <disk>
    80006a18:	00f60733          	add	a4,a2,a5
    80006a1c:	018036b3          	snez	a3,s8
    80006a20:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006a22:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006a26:	01a73823          	sd	s10,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006a2a:	f6078693          	addi	a3,a5,-160
    80006a2e:	6218                	ld	a4,0(a2)
    80006a30:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006a32:	00878513          	addi	a0,a5,8
    80006a36:	9532                	add	a0,a0,a2
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006a38:	e308                	sd	a0,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006a3a:	6208                	ld	a0,0(a2)
    80006a3c:	96aa                	add	a3,a3,a0
    80006a3e:	4741                	li	a4,16
    80006a40:	c698                	sw	a4,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006a42:	4705                	li	a4,1
    80006a44:	00e69623          	sh	a4,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80006a48:	f8442703          	lw	a4,-124(s0)
    80006a4c:	00e69723          	sh	a4,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006a50:	0712                	slli	a4,a4,0x4
    80006a52:	953a                	add	a0,a0,a4
    80006a54:	058a8693          	addi	a3,s5,88
    80006a58:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    80006a5a:	6208                	ld	a0,0(a2)
    80006a5c:	972a                	add	a4,a4,a0
    80006a5e:	40000693          	li	a3,1024
    80006a62:	c714                	sw	a3,8(a4)
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80006a64:	001c3c13          	seqz	s8,s8
    80006a68:	0c06                	slli	s8,s8,0x1
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006a6a:	001c6c13          	ori	s8,s8,1
    80006a6e:	01871623          	sh	s8,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006a72:	f8842603          	lw	a2,-120(s0)
    80006a76:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006a7a:	0023c697          	auipc	a3,0x23c
    80006a7e:	c5e68693          	addi	a3,a3,-930 # 802426d8 <disk>
    80006a82:	00258713          	addi	a4,a1,2
    80006a86:	0712                	slli	a4,a4,0x4
    80006a88:	9736                	add	a4,a4,a3
    80006a8a:	587d                	li	a6,-1
    80006a8c:	01070823          	sb	a6,16(a4)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006a90:	0612                	slli	a2,a2,0x4
    80006a92:	9532                	add	a0,a0,a2
    80006a94:	f9078793          	addi	a5,a5,-112
    80006a98:	97b6                	add	a5,a5,a3
    80006a9a:	e11c                	sd	a5,0(a0)
  disk.desc[idx[2]].len = 1;
    80006a9c:	629c                	ld	a5,0(a3)
    80006a9e:	97b2                	add	a5,a5,a2
    80006aa0:	4605                	li	a2,1
    80006aa2:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006aa4:	4509                	li	a0,2
    80006aa6:	00a79623          	sh	a0,12(a5)
  disk.desc[idx[2]].next = 0;
    80006aaa:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006aae:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006ab2:	01573423          	sd	s5,8(a4)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006ab6:	6698                	ld	a4,8(a3)
    80006ab8:	00275783          	lhu	a5,2(a4)
    80006abc:	8b9d                	andi	a5,a5,7
    80006abe:	0786                	slli	a5,a5,0x1
    80006ac0:	97ba                	add	a5,a5,a4
    80006ac2:	00b79223          	sh	a1,4(a5)

  __sync_synchronize();
    80006ac6:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006aca:	6698                	ld	a4,8(a3)
    80006acc:	00275783          	lhu	a5,2(a4)
    80006ad0:	2785                	addiw	a5,a5,1
    80006ad2:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006ad6:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006ada:	100017b7          	lui	a5,0x10001
    80006ade:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006ae2:	004aa783          	lw	a5,4(s5)
    80006ae6:	02c79163          	bne	a5,a2,80006b08 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006aea:	0023c917          	auipc	s2,0x23c
    80006aee:	d1690913          	addi	s2,s2,-746 # 80242800 <disk+0x128>
  while(b->disk == 1) {
    80006af2:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006af4:	85ca                	mv	a1,s2
    80006af6:	8556                	mv	a0,s5
    80006af8:	ffffc097          	auipc	ra,0xffffc
    80006afc:	ab0080e7          	jalr	-1360(ra) # 800025a8 <sleep>
  while(b->disk == 1) {
    80006b00:	004aa783          	lw	a5,4(s5)
    80006b04:	fe9788e3          	beq	a5,s1,80006af4 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006b08:	f8042903          	lw	s2,-128(s0)
    80006b0c:	00290793          	addi	a5,s2,2
    80006b10:	00479713          	slli	a4,a5,0x4
    80006b14:	0023c797          	auipc	a5,0x23c
    80006b18:	bc478793          	addi	a5,a5,-1084 # 802426d8 <disk>
    80006b1c:	97ba                	add	a5,a5,a4
    80006b1e:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006b22:	0023c997          	auipc	s3,0x23c
    80006b26:	bb698993          	addi	s3,s3,-1098 # 802426d8 <disk>
    80006b2a:	00491713          	slli	a4,s2,0x4
    80006b2e:	0009b783          	ld	a5,0(s3)
    80006b32:	97ba                	add	a5,a5,a4
    80006b34:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006b38:	854a                	mv	a0,s2
    80006b3a:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006b3e:	00000097          	auipc	ra,0x0
    80006b42:	b98080e7          	jalr	-1128(ra) # 800066d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006b46:	8885                	andi	s1,s1,1
    80006b48:	f0ed                	bnez	s1,80006b2a <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006b4a:	0023c517          	auipc	a0,0x23c
    80006b4e:	cb650513          	addi	a0,a0,-842 # 80242800 <disk+0x128>
    80006b52:	ffffa097          	auipc	ra,0xffffa
    80006b56:	318080e7          	jalr	792(ra) # 80000e6a <release>
}
    80006b5a:	70e6                	ld	ra,120(sp)
    80006b5c:	7446                	ld	s0,112(sp)
    80006b5e:	74a6                	ld	s1,104(sp)
    80006b60:	7906                	ld	s2,96(sp)
    80006b62:	69e6                	ld	s3,88(sp)
    80006b64:	6a46                	ld	s4,80(sp)
    80006b66:	6aa6                	ld	s5,72(sp)
    80006b68:	6b06                	ld	s6,64(sp)
    80006b6a:	7be2                	ld	s7,56(sp)
    80006b6c:	7c42                	ld	s8,48(sp)
    80006b6e:	7ca2                	ld	s9,40(sp)
    80006b70:	7d02                	ld	s10,32(sp)
    80006b72:	6de2                	ld	s11,24(sp)
    80006b74:	6109                	addi	sp,sp,128
    80006b76:	8082                	ret

0000000080006b78 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006b78:	1101                	addi	sp,sp,-32
    80006b7a:	ec06                	sd	ra,24(sp)
    80006b7c:	e822                	sd	s0,16(sp)
    80006b7e:	e426                	sd	s1,8(sp)
    80006b80:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006b82:	0023c497          	auipc	s1,0x23c
    80006b86:	b5648493          	addi	s1,s1,-1194 # 802426d8 <disk>
    80006b8a:	0023c517          	auipc	a0,0x23c
    80006b8e:	c7650513          	addi	a0,a0,-906 # 80242800 <disk+0x128>
    80006b92:	ffffa097          	auipc	ra,0xffffa
    80006b96:	224080e7          	jalr	548(ra) # 80000db6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006b9a:	10001737          	lui	a4,0x10001
    80006b9e:	533c                	lw	a5,96(a4)
    80006ba0:	8b8d                	andi	a5,a5,3
    80006ba2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006ba4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006ba8:	689c                	ld	a5,16(s1)
    80006baa:	0204d703          	lhu	a4,32(s1)
    80006bae:	0027d783          	lhu	a5,2(a5)
    80006bb2:	04f70863          	beq	a4,a5,80006c02 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006bb6:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006bba:	6898                	ld	a4,16(s1)
    80006bbc:	0204d783          	lhu	a5,32(s1)
    80006bc0:	8b9d                	andi	a5,a5,7
    80006bc2:	078e                	slli	a5,a5,0x3
    80006bc4:	97ba                	add	a5,a5,a4
    80006bc6:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006bc8:	00278713          	addi	a4,a5,2
    80006bcc:	0712                	slli	a4,a4,0x4
    80006bce:	9726                	add	a4,a4,s1
    80006bd0:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80006bd4:	e721                	bnez	a4,80006c1c <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006bd6:	0789                	addi	a5,a5,2
    80006bd8:	0792                	slli	a5,a5,0x4
    80006bda:	97a6                	add	a5,a5,s1
    80006bdc:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006bde:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006be2:	ffffc097          	auipc	ra,0xffffc
    80006be6:	a2a080e7          	jalr	-1494(ra) # 8000260c <wakeup>

    disk.used_idx += 1;
    80006bea:	0204d783          	lhu	a5,32(s1)
    80006bee:	2785                	addiw	a5,a5,1
    80006bf0:	17c2                	slli	a5,a5,0x30
    80006bf2:	93c1                	srli	a5,a5,0x30
    80006bf4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006bf8:	6898                	ld	a4,16(s1)
    80006bfa:	00275703          	lhu	a4,2(a4)
    80006bfe:	faf71ce3          	bne	a4,a5,80006bb6 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006c02:	0023c517          	auipc	a0,0x23c
    80006c06:	bfe50513          	addi	a0,a0,-1026 # 80242800 <disk+0x128>
    80006c0a:	ffffa097          	auipc	ra,0xffffa
    80006c0e:	260080e7          	jalr	608(ra) # 80000e6a <release>
}
    80006c12:	60e2                	ld	ra,24(sp)
    80006c14:	6442                	ld	s0,16(sp)
    80006c16:	64a2                	ld	s1,8(sp)
    80006c18:	6105                	addi	sp,sp,32
    80006c1a:	8082                	ret
      panic("virtio_disk_intr status");
    80006c1c:	00002517          	auipc	a0,0x2
    80006c20:	cc450513          	addi	a0,a0,-828 # 800088e0 <syscalls+0x428>
    80006c24:	ffffa097          	auipc	ra,0xffffa
    80006c28:	91a080e7          	jalr	-1766(ra) # 8000053e <panic>
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
