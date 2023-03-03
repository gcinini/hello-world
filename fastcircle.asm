**********************************************************
*                                                        *
* Fast Circle Generator                                  *
*                                                        *
* by Michael J. Mahon, Copyright 2022                    *
*                                                        *
* Plots an aspect ratio corrected, clipped circle with   *
* radius 'r' centered at 'xc,yc'. The time required is   *
* approximately 0.75r+22 milliseconds.                   *
*                                                        *
* POKE input parameters 'xclo', 'xchi', 'yc', and 'r'    *
* into locations 6, 7, 8, and 9 before calling.          *
*                                                        *
**********************************************************

CpuType 6502

* Apple II ROM subroutines
ERROR equ $D412 ; Print error message.
HPLOT0 equ $F457 ; Plot dot at (X,Y),(A)
HGLIN equ $F53A ; Plot line to (A,X),(Y)
COSTBL equ $F5BA ; 1-byte 1st quadrant cosines.
IORTS equ $FF58 ; Location of monitor RTS

* Input parameters
dum $06
0006: 00 25 xc db 0 ; Center x (0..255)
0007: 00 26 xchi db 0 ; Center xhi (0..1)
0008: 00 27 yc db 0 ; Center y (0..255)
0009: 00 28 r db 0 ; Radius (0..214) <== NOTE!
dend

* Page zero variables (swapped with Applesoft)
dum $34
pz equ * ; Start of page zero space.
x db 0
0035: 00 35 xhi db 0
0036: 00 36 y db 0
0037: 00 37 yhi db 0 ; Sign of y (00 or FF)
0038: 00 00 38 t dw 0 ; Temp word
003A: 00 39 prevr db 0 ; Previous call 'r'
003B: 00 40 clipping db 0 ; >0 = clipping, 0 = pl
savex   db 0
pzsize  equ *-pz    ; Size of 'pz' space.
dend
org $2400
