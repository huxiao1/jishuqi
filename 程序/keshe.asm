RS EQU P3.5		// *����H/����Lѡ���	  2.5
RW EQU P3.6		// ��H/*дLѡ���		  2.6
E  EQU P3.7		// ʹ���ź�				  2.7
LCD EQU P2		// P2�ڽ�LCD              ������P0
BF EQU P2.7		


ORG  0000H
LJMP  MAIN
ORG 000BH
LJMP JISHI
ORG 0040H

/*�жϺ���*/
JISHI:	
		
		MOV DPTR,#TAB2
        JNB P1.0,START	 //λΪ0���ʱ��ʼ��ת����ʱ����
        AJMP RETURN		//λΪ1�жϷ���


    START: 
	JB P1.1,L2	  //jiaoda++ λΪ1����ת	ɨ����һ������
	/*����Ϊ��⵽P1.1��������ʱ�Ľ���취*/
		   MOV  36H,#0FFH
	K1:		MOV   37H,#0FFH	  //��ʱ
    DL0:DJNZ  37H,DL0   
	DL1:DJNZ  36H,K1
	JB P1.1,START
		SETB P1.1 		
	      LJMP DK1



    L2:   JB P1.2,L1	  //jiaoda-- λΪ1����ת	ɨ����һ������
	/*����Ϊ��⵽P1.2��������ʱ�Ľ���취*/
	      MOV  36H,#0FFH
	K2:	  MOV   37H,#0FFH	//��ʱ
	DL2:  DJNZ  37H,DL2
    DL3:  DJNZ  36H,K2
	JB P1.2,START
		SETB P1.2
		  LJMP DK2

	L1:	  JB P1.3,L		  //caida++ λΪ1����ת	ɨ����һ������
	      MOV  36H,#0FFH
	 /*����Ϊ��⵽P1.3��������ʱ�Ľ���취*/
	K3:	  MOV   37H,#0FFH	 //��ʱ
   DL4:   DJNZ  37H,DL4
   DL5:   DJNZ  36H,K3
   JB P1.3,START
		SETB P1.3
		  LJMP  DK3


	L:	  JB P1.4,START1	//caida--  λΪ1����ת	ɨ����һ������
	      MOV  36H,#0FFH
	/*����Ϊ��⵽P1.4��������ʱ�Ľ���취*/
	K4:	  MOV   37H,#0FFH	 //��ʱ
   DL6:  DJNZ  37H,DL6
   DL7:   DJNZ  36H,K4
   JB P1.4,START
		SETB P1.4
		  LJMP DK4 


START1:   DEC P0
	      MOV A,P0
	      CJNE A,#00H,START2	//A��Ϊ00H��ת��
		  MOV P0,#0FFH
	START2:    
	  MOV R1,#15   
	  
	  //��λ
	  MOV A,R2
	  MOVC A,@A+DPTR	//R2=0 ��0��ʼ��
	  CALL LCDP2
	  INC R2
	  CJNE R2,#10,RETURN  //R2û�е�10�ͽ����жϷ��غ���
	  MOV R2,#0			  
	  DEC R1
	  DEC R1		//R1=13

	  INC R3		//R3=1	 ��1��ʼ��
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
	      
		  AJMP RING		//������
	      RET

//��λ������λ�ò�������
LCDP2:PUSH  ACC 
      MOV  A,R1
	  ADD  A,#0C0H
	  CALL WAIT
	  CALL  W_CMD
	  POP ACC
	  CALL WAIT
	  CALL  W_DATA
	  RET


	/*���λ�������������*/
	RING: CLR P3.0
	      MOV 38H,#0FFH
	RING1: DJNZ 38H, RING1	  //�����ʱ����
	       RET



     /*P1.1���½���++*/
	  DK1:
	      MOV R1,#2	    //����ĸ�λ
	      MOV A,R7
		  MOVC A,@A+DPTR
		  CALL LCDP2
		  INC R7			   //�� 1��9�ٱ仯�� 0
		  CJNE R7,#11,RETURN  
  		  MOV R7,#0

		   MOV R1,#1	//�����ʮλ
		   MOV A,30H
		   MOVC A,@A+DPTR
		   CALL LCDP2
		   INC 30H
		   MOV A,30H
		   CJNE A,#11,RETURN
			MOV 30H,#0
					 
			MOV R1,#0	 //����İ�λ
			MOV A,31H
			MOVC A,@A+DPTR
			CALL LCDP2
			INC 31H
		  AJMP RETURN

		  RETURN:  MOV TH0,#3CH	   //���¸���ֵ�жϽ���
     			   MOV TL0,#0B0H
	 			   RETI	 

		DEC R7

		
			
		  /*P1.2���½���--*/
		DK2: MOV R1,#2		   //����ĸ�λ
		  	 CJNE R7,#00H,DO
				AJMP GAI
		DO:  
			 INC R7
			 CJNE R7,#0AH,GAI2
			  	
			DO2: 	
			 DEC R7
			 CJNE R7,#00H,DO3
			 	 MOV R7,#0AH
				 MOV R1,#1			 //�����ʮλ
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
			MOV R1,#1		//�����ʮλ
			MOV A,30H
			MOVC A,@A+DPTR
			CALL LCDP2
			AJMP RETURN



GAI:	  MOV R7,#0BH
		  MOV R1,#1		//�����ʮλ
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


//RS=1/0      ����/����(���꣩ѡ���
//R/W=1/0     ��/дѡ���
//E           ʹ��


/*��ʼ��*/  
  WAIT:MOV LCD,#0FFH
     CLR RS		 //����ѡ��
	 SETB RW	 
	 CLR E
	 NOP
	 SETB E		 //��ȡBUSY��־
	 JB BF,WAIT	 //BFΪ1��ת��
	 RET

/*дָ��*/
W_CMD:ACALL WAIT
      MOV LCD,A	  //�����߸�ֵ
	  CLR RS		
	  CLR RW	   //д��һ���ֽڵĿ���ָ��
	  SETB E
	  NOP
	  CLR E		  //������ָ��
	  RET

/*д����*/
W_DATA:ACALL WAIT
       MOV LCD,A
	   SETB RS		  //д����
	   CLR RW	    
	   SETB E
	   NOP 
	   CLR E
	   RET


TAB:DB 'HAINAN VS HEBEI'
	DB '000:000  00:00:0'
TAB2: DB 30H,31H,32H,33H,34H,35H,36H,37H,38H,39H,30H   //����ת����ascIIֵ


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

	 /*1602�ܽ�����*/
     MOV A,#00000001B	  //����ָ�����λ,ddr�ڲ��������
     ACALL W_CMD
	 MOV A,#00111000B	   //����ʾ 8λ�������ߣ���ʾ���� 5*7����ÿ�ַ�
	 ACALL W_CMD
	 MOV A,#00001100B	   //��ʾ���ܿ��޹��  ��ʾ���ؿ���ָ��
	 ACALL W_CMD
	 MOV A,#00010100B	   // ÿ����һ��ָ�AC��һ�����廭�治���� 
	 ACALL W_CMD
	 MOV A,#10000000B	   //  ��������ָ����㣬��һ�е�һ��λ��
	 ACALL W_CMD


	 MOV DPTR,#TAB
	 MOV R0,0

/*д��һ������*/
LOOP1:MOV A,R0
      MOVC A,@A+DPTR
	  ACALL W_DATA
	  INC R0
	  CJNE R0,#15,LOOP1	//��һ�е�����Ҫȫд��
	   MOV A,#0C0H	   //��һ��д���ݵ�λ��Ϊ�ڶ��п�ͷ
	  ACALL W_CMD


/*д�ڶ�������*/
 LOOP2:MOV A,R0
      MOVC A,@A+DPTR
	  ACALL W_DATA
	  INC R0
	  CJNE R0,#31,LOOP2

/*T0��ʱ�жϳ�ʼ�� 16λ��ʱ����ʱ15536*/
	 MOV TMOD,#0000001B
     MOV TH0,#3CH
     MOV TL0,#0B0H
     SETB EA	  
   	 SETB ET0
	 SETB TR0
	 	 
LOOP3:AJMP LOOP3   //�ȴ��ж�
END