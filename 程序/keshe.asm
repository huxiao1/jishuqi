RS EQU P3.5		// *数据H/命令L选择端	  2.5
RW EQU P3.6		// 读H/*写L选择端		  2.6
E  EQU P3.7		// 使能信号				  2.7
LCD EQU P2		// P2口接LCD              开发板P0
BF EQU P2.7		


ORG  0000H
LJMP  MAIN
ORG 000BH
LJMP JISHI
ORG 0040H

/*中断函数*/
JISHI:	
		
		MOV DPTR,#TAB2
        JNB P1.0,START	 //位为0则计时开始跳转到计时函数
        AJMP RETURN		//位为1中断返回


    START: 
	JB P1.1,L2	  //jiaoda++ 位为1则跳转	扫描下一个按键
	/*以下为检测到P1.1按键按下时的解决办法*/
		   MOV  36H,#0FFH
	K1:		MOV   37H,#0FFH	  //延时
    DL0:DJNZ  37H,DL0   
	DL1:DJNZ  36H,K1
	JB P1.1,START
		SETB P1.1 		
	      LJMP DK1



    L2:   JB P1.2,L1	  //jiaoda-- 位为1则跳转	扫描下一个按键
	/*以下为检测到P1.2按键按下时的解决办法*/
	      MOV  36H,#0FFH
	K2:	  MOV   37H,#0FFH	//延时
	DL2:  DJNZ  37H,DL2
    DL3:  DJNZ  36H,K2
	JB P1.2,START
		SETB P1.2
		  LJMP DK2

	L1:	  JB P1.3,L		  //caida++ 位为1则跳转	扫描下一个按键
	      MOV  36H,#0FFH
	 /*以下为检测到P1.3按键按下时的解决办法*/
	K3:	  MOV   37H,#0FFH	 //延时
   DL4:   DJNZ  37H,DL4
   DL5:   DJNZ  36H,K3
   JB P1.3,START
		SETB P1.3
		  LJMP  DK3


	L:	  JB P1.4,START1	//caida--  位为1则跳转	扫描下一个按键
	      MOV  36H,#0FFH
	/*以下为检测到P1.4按键按下时的解决办法*/
	K4:	  MOV   37H,#0FFH	 //延时
   DL6:  DJNZ  37H,DL6
   DL7:   DJNZ  36H,K4
   JB P1.4,START
		SETB P1.4
		  LJMP DK4 


START1:   DEC P0
	      MOV A,P0
	      CJNE A,#00H,START2	//A不为00H则转移
		  MOV P0,#0FFH
	START2:    
	  MOV R1,#15   
	  
	  //秒位
	  MOV A,R2
	  MOVC A,@A+DPTR	//R2=0 从0开始加
	  CALL LCDP2
	  INC R2
	  CJNE R2,#10,RETURN  //R2没有到10就进入中断返回函数
	  MOV R2,#0			  
	  DEC R1
	  DEC R1		//R1=13

	  INC R3		//R3=1	 从1开始加
	  MOV A,R3
	  MOVC A,@A+DPTR
	  CALL LCDP2
	  CJNE R3,#10,RETURN
	  MOV R3,#0
	  DEC R1	   //R1=12

	   INC R4		   //R4=1
	   MOV A,R4
	   MOVC A,@A+DPTR
	   CALL LCDP2
	   CJNE R4,#6,RETURN
	   MOV R4,#0
	   MOV A,R4
	   MOVC A,@A+DPTR
	   CALL LCDP2
	   DEC R1
	   DEC R1		//R1=10

	   
	   INC R5
	   MOV A,R5
	   MOVC A,@A+DPTR
	   CALL LCDP2		   
	   CJNE R5,#10,RETURN
	   MOV R5,#0
	   MOV A,R5
	   MOVC A,@A+DPTR
	   CALL LCDP2
	   DEC R1		 //R1=9

	   
	   INC R6		 
	   MOV A,R6
	   MOVC A,@A+DPTR
	   CALL LCDP2
	   CJNE R6,#6,RETURN
	      
		  AJMP RING		//蜂鸣器
	      RET

//定位到所需位置并改数据
LCDP2:PUSH  ACC 
      MOV  A,R1
	  ADD  A,#0C0H
	  CALL WAIT
	  CALL  W_CMD
	  POP ACC
	  CALL WAIT
	  CALL  W_DATA
	  RET


	/*最高位溢出蜂鸣器函数*/
	RING: CLR P3.0
	      MOV 38H,#0FFH
	RING1: DJNZ 38H, RING1	  //响的延时函数
	       RET



     /*P1.1按下交大++*/
	  DK1:
	      MOV R1,#2	    //交大的个位
	      MOV A,R7
		  MOVC A,@A+DPTR
		  CALL LCDP2
		  INC R7			   //从 1到9再变化到 0
		  CJNE R7,#11,RETURN  
  		  MOV R7,#0

		   MOV R1,#1	//交大的十位
		   MOV A,30H
		   MOVC A,@A+DPTR
		   CALL LCDP2
		   INC 30H
		   MOV A,30H
		   CJNE A,#11,RETURN
			MOV 30H,#0
					 
			MOV R1,#0	 //交大的百位
			MOV A,31H
			MOVC A,@A+DPTR
			CALL LCDP2
			INC 31H
		  AJMP RETURN

		  RETURN:  MOV TH0,#3CH	   //从新赋初值中断结束
     			   MOV TL0,#0B0H
	 			   RETI	 

		DEC R7

		
			
		  /*P1.2按下交大--*/
		DK2: MOV R1,#2		   //交大的个位
		  	 CJNE R7,#00H,DO
				AJMP GAI
		DO:  
			 INC R7
			 CJNE R7,#0AH,GAI2
			  	
			DO2: 	
			 DEC R7
			 CJNE R7,#00H,DO3
			 	 MOV R7,#0AH
				 MOV R1,#1			 //交大的十位
		  		 DEC 30H
		  		 DEC 30H
		  		 MOV A,30H
		  		 MOVC A,@A+DPTR
		  		 CALL LCDP2
		  		 MOV R1,#2
		  		 INC 30H
				 AJMP DO3
		 DO3:
		 	 CJNE R7,#0DH,DO5
			 MOV R7,#07H
		   	 MOV A,R7
			 MOVC A,@A+DPTR
			 CALL LCDP2
			INC R7
			CJNE R7,#0,RETURN
		DO5: 
			 CJNE R7,#09H,DO4
			 MOV R7,#08H
			 MOV A,R7
			 MOVC A,@A+DPTR
			 CALL LCDP2
			 MOV R7,#0EH
			CJNE R7,#0,RETURN	
 	
		DO4: DEC R7			   		   
			 MOV A,R7
			 MOVC A,@A+DPTR
			 CALL LCDP2
			INC R7
			CJNE R7,#0,RETURN
		
			MOV R7,#10
			MOV A,R7
	   MOVC A,@A+DPTR
	   CALL LCDP2



			DEC 30H
			DEC 30H
			MOV R1,#1		//交大的十位
			MOV A,30H
			MOVC A,@A+DPTR
			CALL LCDP2
			AJMP RETURN



GAI:	  MOV R7,#0BH
		  MOV R1,#1		//交大的十位
		  DEC 30H
		  DEC 30H
		  MOV A,30H
		  MOVC A,@A+DPTR
		  CALL LCDP2
		  MOV R1,#2
		  INC 30H
		  AJMP DO

GAI2:	
		DEC R7
		//INC R7
		AJMP DO2	
			



DK3:      MOV R1,#6
	      MOV A,32H
		  MOVC A,@A+DPTR
		  CALL LCDP2
		  INC 32H
		  MOV A,32H
		  CJNE A,#11,S
		   MOV 32H,#0

		   MOV R1,#5
		   MOV A,33H
		   MOVC A,@A+DPTR
		   CALL LCDP2
		   INC 33H
		   MOV A,33H
		   CJNE A,#11,S
		  	MOV 33H,#0
		

			MOV R1,#4
			MOV A,34H
			MOVC A,@A+DPTR
			CALL LCDP2
			INC 34H
			AJMP RETURN

DK4:        MOV R1,#6
		     DEC 32H
			 DEC 32H
			 MOV A,32H
			 MOVC A,@A+DPTR
			 CALL LCDP2
			INC 32H
			MOV A,32H
			CJNE A,#0,S
			MOV 32H,#10
			  MOV A,32H
	   MOVC A,@A+DPTR
	   CALL LCDP2
			DEC 33H
			DEC 33H

			MOV R1,#5
			MOV A,33H
			MOVC A,@A+DPTR
			CALL LCDP2
			AJMP RETURN
S:	AJMP RETURN


//RS=1/0      数据/命令(坐标）选择端
//R/W=1/0     读/写选择端
//E           使能


/*初始化*/  
  WAIT:MOV LCD,#0FFH
     CLR RS		 //命令选择
	 SETB RW	 
	 CLR E
	 NOP
	 SETB E		 //读取BUSY标志
	 JB BF,WAIT	 //BF为1则转移
	 RET

/*写指令*/
W_CMD:ACALL WAIT
      MOV LCD,A	  //数据线赋值
	  CLR RS		
	  CLR RW	   //写入一个字节的控制指令
	  SETB E
	  NOP
	  CLR E		  //结束关指令
	  RET

/*写数据*/
W_DATA:ACALL WAIT
       MOV LCD,A
	   SETB RS		  //写数据
	   CLR RW	    
	   SETB E
	   NOP 
	   CLR E
	   RET


TAB:DB 'HAINAN VS HEBEI'
	DB '000:000  00:00:0'
TAB2: DB 30H,31H,32H,33H,34H,35H,36H,37H,38H,39H,30H   //数字转换成ascII值


MAIN:
	  //CLR P3.2
	  MOV R0,#0
	  MOV R2,#0
	  MOV R3,#0
	  MOV R4,#0
	  MOV R5,#0
	  MOV R6,#0
	  MOV R7,#1
	  MOV 30H,#1
	  MOV 31H,#1
	  MOV 32H,#1
	  MOV 33H,#1
	  MOV 34H,#1
	  MOV P0,#0FFH

	 /*1602管脚配置*/
     MOV A,#00000001B	  //清屏指令，光标归位,ddr内部数据清空
     ACALL W_CMD
	 MOV A,#00111000B	   //开显示 8位数据总线，显示两行 5*7点阵每字符
	 ACALL W_CMD
	 MOV A,#00001100B	   //显示功能开无光标  显示开关控制指令
	 ACALL W_CMD
	 MOV A,#00010100B	   // 每输入一次指令，AC加一，整体画面不滚动 
	 ACALL W_CMD
	 MOV A,#10000000B	   //  设置数据指针起点，第一行第一个位置
	 ACALL W_CMD


	 MOV DPTR,#TAB
	 MOV R0,0

/*写第一行数据*/
LOOP1:MOV A,R0
      MOVC A,@A+DPTR
	  ACALL W_DATA
	  INC R0
	  CJNE R0,#15,LOOP1	//第一行的数据要全写入
	   MOV A,#0C0H	   //下一步写数据的位置为第二行开头
	  ACALL W_CMD


/*写第二行数据*/
 LOOP2:MOV A,R0
      MOVC A,@A+DPTR
	  ACALL W_DATA
	  INC R0
	  CJNE R0,#31,LOOP2

/*T0定时中断初始化 16位定时器定时15536*/
	 MOV TMOD,#0000001B
     MOV TH0,#3CH
     MOV TL0,#0B0H
     SETB EA	  
   	 SETB ET0
	 SETB TR0
	 	 
LOOP3:AJMP LOOP3   //等待中断
END