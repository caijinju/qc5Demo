;===============================================================================
; File Name     		:	file name
; Customer				:	Customer
; Project Name			:	ProjectName
; Project Number		:	ProjectNumber
; IC body       		:	ICBody
; Compiler Version		:	Q-Code 4.10 [Build 022417.00].zip
; Asm Version	  		:	NYASM 2.03 [Build 022317.00].zip
; Programmer	    	:	CaiJinJu
; Date of Creat 		:	2017/5/15
; Date of Last Edit		:	2017/5/15
;===============================================================================
; Log    (Detail of Modification)
;===============================================================================
; 2017/5/15
;	Code Version    -   Version 01(DEMO-5-V01-CJJ.bin)
;   -> 1st code
;       File Checksum	: 3982DE          
;		Code Checksum	: 1C852A          
;       ROM Usage		: 2017/05/15
;===============================================================================
; Program Description
;===============================================================================
; Function: 	
;			1.  Describe the function of program briefly
; I/O:    
;		----------------------   KEY   ------------------------------
;     ==>PA0 : KEY1						- input BL PH 
;     ==>PA1 : KEY2						- input BL PH 
;     ==>PA2 : KEY3						- input BL PH 
;     ==>PA3 : KEY4						- input BL PH 
;===============================================================================


[Option]
ICBody = NY5C185C
Client = LGW
Voltage = 4.5V
Oscillator = INT
Clock = 1MHz
TimeBase = 0.512ms
PWM Current = Large
Voice Output = PWM + DAC
RampUp/Down = Enable


[Voice File]
V0 = D:\cjj\workspace\查问题\3-KG问题\1-排查问题\voice\N00.wav /5
V1 = D:\cjj\workspace\查问题\3-KG问题\1-排查问题\voice\N01.wav /5
V2 = D:\cjj\workspace\查问题\3-KG问题\1-排查问题\voice\N02.wav /5
V3 = D:\cjj\workspace\查问题\3-KG问题\1-排查问题\voice\N03.wav /5





[Action File]

[Melody Database]



[I/O]
;  Input Pin
;     No.   1     2     3     4     
;     Name  PA.0  PA.1  PA.2  PA.3  
; 
;  Output Pin
;     No.   1     2     3     4     5     6     7     8     9     10    11    12    13    14    15    16    
;     Name  PB.0  PB.1  PB.2  PB.3  PC.0  PC.1  PC.2  PC.3  PD.0  PD.1  PD.2  PD.3  PE.0  PE.1  PE.2  PE.3  
; 
PA.0 = [Direction:Input, InputType:pull-high, Trigger:low]
PA.1 = [Direction:Input, InputType:pull-high, Trigger:low]
PA.2 = [Direction:Input, InputType:pull-high, Trigger:low]
PA.3 = [Direction:Input, InputType:pull-high, Trigger:low]
PB.0 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PB.1 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PB.2 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PB.3 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PC.0 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PC.1 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PC.2 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PC.3 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PD.0 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PD.1 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PD.2 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PD.3 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PE.0 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PE.1 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PE.2 = [Direction:Output, Current:normal, Initial:low, Busy:low]
PE.3 = [Direction:Output, Current:normal, Initial:low, Busy:low]
Input_Resistor = strong

[Input State]
Input_0:	TR1    TR2/TR2_Release    TR3    TR4
IS_Disable:	X/X    X/X    X/X    X/X

[Output State]
O_state0:	X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    X    

[WaveMark]

[MelodyMark]

[Note On]

[IR Receive]

[Symbol]
R_PlayIndex		= R1
R_PressFlag		= R2
; bit 1 - press flag
; bit 0 - loop flag
R_Temp			= R3

D_VoiceSum		= 4			; 声音总数

[Table]

[ASM]

[Macro]
M_Init:
	MIXCTRL(0,0,4,0),
	Vol				= 0x8,
	R_PlayIndex		= 0x0,
	R_PressFlag		= 0x0

[Sentence]

[QIO Custom]

[Subroutine]

[Path]
;-----------------------------------------------------
PowerOn: 												; 开机上电
				stop,
				IS_Disable,
				M_Init,                                 ;     初始化数据
				delay(100ms),
				L_StartUp
				
L_StartUp:												; 上电检测
				R_Temp=pa&1,                            ;     按键1是否按住？
				R_Temp=0?L_TestMode,                    ;     若是，进入测试模式
				L_NormalMode                            ;     若不是，进入正常模式

L_NormalMode:
				Input_0,                                ;     检测输入
				L_End

;-----------------------------------------------------
L_TestMode:												; 测试模式
				pb.0=1khz(1),                           ;     pb.0 输出1KHz的方波
				R_Temp=pa&1,                            ;     检测按键1是否仍按着，
				R_Temp=0?L_TestMode,                    ;         若是，继续输出方波
				L_Checksum                              ;     若按键1松开，检测checksum

L_Checksum:                                             ; 检测checksum
				checksum?L_ChecksumOk,                  ;     ROM DATA是否正确？正确则 pb.0=1
				L_CheckSumFail                          ;     不正确，则 pb.0=0

L_ChecksumOk:
				pb.0=1,
				L_NormalMode

L_CheckSumFail:
				pb.0=0,
				L_NormalMode
				
;-----------------------------------------------------
TR1:													; 按键1按下
				R_PlayIndex!=D_VoiceSum?L_PlayIndex,
				R_PlayIndex=0,
				L_PlayIndex								;     循环播放


		L_PlayIndex:                                    ; 循环播放
				playv(ch2,R_PlayIndex),                 ;     播放当前第 R_PlayIndex 个声音
				L_PlayIndex                             ;     循环播放


		L_CheckPlayLoop:                                ; 检测循环播放
				STOP,                                   ;     停止所有动作
				STOPBG,                                 ;     停止背景
				R_PressFlag.1=0,                        ;     按下标志位清零
				R_PlayIndex++,                          ;     取下一个播放声音
				R_PlayIndex<D_VoiceSum?L_PlayIndex,
				R_PlayIndex=D_VoiceSum?L_StopPlay,
				R_PlayIndex=0,                          ;     超出范围，则置为从头开始播放
				L_PlayIndex                             ;     播放声音
				
;-----------------------------------------------------
		L_StopPlay:										; 停止播放声音
				stopv,                                  ;     停止播放声音
				stop,                                   ;     停止背景
				L_End                                   ;     退出


;-----------------------------------------------------
TR2:													; 按键2按下处理
				bg(BG1_PressTimerCount,X)				;     启动背景处理
				
				
;-----------------------------------------------------
TR2_Release:											; 按键2松开处理
				stopbg1,                                ;     停止背景1
				R_PressFlag.1=1?L_CheckPlayLoop,        ;     若未到达长按时间，跳至播放下一个声音
				L_End                                   ;     退出

;-----------------------------------------------------
TR3:													; 按键3按下处理
				Vol++                                   ;     音量+
				
;-----------------------------------------------------
TR4:													; 按键4按下处理
				Vol--                                   ;     音量-
				
;-----------------------------------------------------
L_End:
				end
				
[Background1]
BG1_PressTimerCount:									; 背景长按计时处理
				R_PressFlag.1=1,                        ;     设置按下标志位
				Delay(2s),                              ;     延时2秒
				R_PressFlag.1=0,                        ;     长按2秒时间到，清空按下标志位
				L_StopPlay                              ;     停止播放
				
				
[Background2]

