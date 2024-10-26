
%Advertencias: se ocupa el paquete symbolic
%la progra viene preparada para instalarlo si no lo tiene, pero si aun así
% el código no corre correctamente: instale el paquete desde el terminal con:
% sudo apt-get install octave-symbolic



clc
clear all
close all
%Punto1________________________________________________
pkg load control

pkg_list = pkg("list");
symbolic_exist = false;
for i = 1:length(pkg_list)
  if strcmp(pkg_list{i}.name, 'symbolic')
    symbolic_exist = true
  endif
end

if symbolic_exist == false
    disp('No tienes el paquete symbolic, procedo a instalarlo');
    pkg install -forge symbolic
else
    disp('Tienes el paquete symbolic instalado, genial')
endif

pkg load symbolic

%Punto 2____________________________________________________________________
s = tf('s');

G1 = tf([-0.35498 -0.5164959],[1 0.006691 35.32]) % función de transferencia del angulo
G2 = tf([0.25293],[1 10.5 0]) % función de transferencia del la posición

##%Punto 3____________________________________________________________________
##figure('Name', 'Polos y ceros de las funciones de transferencia')
##%polos y ceros del angulo y de la posición
##subplot(1,2,1)
##pzmap(G1)
##title('Polos y ceros de la funcion \n de transferencia del ángulo')
##legend('Polos ángulo','Ceros ángulo')
##grid on; grid minor;
##hold on;
##
##subplot(1,2,2)
##pzmap(G2)
##title('Polos y ceros de la funcion \n de transferencia de la posición')
##legend('Polos posición','Ceros posición')
##grid on; grid minor;
##hold on;
##
##% Punto 4__________________________________________________________________________
##figure('Name', 'Respuestas ante el escalón TF angulo')
##subplot(1,2,1)
##step(G1)
##title('Respuesta al escalón del ángulo lazo abierto')
##subplot(1,2,2)
##step(feedback(G1,1))
##title('Respuesta al escalón del ángulo lazo cerrado')
##
##figure('Name', 'Respuestas ante el escalón TF posición')
##subplot(1,2,1)
##step(G2)
##title('Respuesta al escalón de la posición lazo abierto')
##subplot(1,2,2)
##step(feedback(G2,1))
##title('Respuesta al escalón de la posición lazo cerrado ')

%Punto 5____________________________________________________________
%conversión de las funciones de transferencia a espacio de estados
G1ss = ss(G1);%espacioo de estados de la funcioń del angulo no controlable
G2ss = ss(G2);%espacio de estados de la funcioń de la posición no controlable


%obsConv es una función creada por el estudiante, no es de ningún paquete, va adjunta con el scrip
SSA = obsConv(G1ss)
SSP = obsConv(G2ss)

%Punto 6____________________________________________________________
% Las matrices están dadas por A: nxn, B = nx1
% donde n es el grado máximo en la ec característica.
% Como ambos sistemas son de grado 2, las matrices de ambos deben ser de
% 4x4 para que posteriormente sean compatibles al unirlas en un solo simo

%ss aumentado a 4x4 de la posicion, una salida
SSaP = ss([0 0 1 0;0 0 0 0;0 0 -10.5 0;0 0 0 0],[0;0;0.2529;0],[1 0 0 0],0)
%ss aumentado a 4x4 del águlo, una salida
SSaA = ss([0 0 0 0;0 0 0 1;0 0 0 0;0 -35.32 0 -0.006691],[0;-0.355;0;-0.5141],[0 1 0 0],0)%


%comprobaciones angulo, como G1 es la tf del angulo:
disp("Tf del angulo original")
zpk(G1)
disp("Tf del angulo a partir del sistema aumentado SSaA")
zpk(SSaA)

%comprobaciones posicion x, como G2 es la tf de la posicion:
disp("Tf de la posición original")
zpk(G2)
disp("Tf de la posicion a partir del sistema aumentado SSaP")
zpk(SSaP)


% Punto 7 Sistema completo con ambas salidas y una entrada__________________
Planta = ss(SSaP.a+SSaA.a, SSaP.b+SSaA.b ,[SSaP.c;SSaA.c], 0)
%Sistema simo


% Demostrar que Planta contiene adecuadamente las dos tf

%ss2_TF es una funcion creada por el estudiante, no se encuentra en ningún paquete
## Gx = ss2_TF(Planta)% funcion para obtener funciones de transferencia a partir de ss
##
##
##disp("_________No encontré una manera de convertir en tf lo que había dentro de Gx \n así que lo hice manualmente, compare visualmente_____________")
##
## Gn1 = (-3601651151*s-1667911240*pi - 9766177)/(21608*(469525*s^2  + 1000*pi*s + 16583623));
## Gn2 = (431*pi)/(2677*s*(2*s +21));
##
## disp("_______Creo que las aproximaciones hacen que las tf no sean numéricamente igual, pero las gráficas sí lo son__________")
## figure("name", "Graficas de tf originales vs tf extraídas desde el sistema simo")
## subplot(2,2,1)
## step(G1,400)% G2 origianl
## title("Gráficas de step G1 (original) lazo abierto")
## subplot(2,2,2)
## step(G2)% G1 original
## title("Gráficas de step G2 (original) lazo abierto")
## subplot(2,2,3)
## step(Gn1,400)%tf obtenida de ss Planta
## title("Gráfica de step obtenida mediante \n Gn1(s) = C(sI-A)⁻¹B desde Planta l. abierto")
## subplot(2,2,4)
## step(Gn2)% tf obtenida de ss Planta
## title("Gráfica de step obtenida mediante \n Gn2(s) = C(sI-A)⁻¹B desde Planta l. abierto")
##
## %zpk de las originales y las extraídas del sistema simo
## zpk(G1)
## zpk(Gn1)
## zpk(G2)
## zpk(Gn2)


 %Fin del punto 7, nada de lo posterior depende de esta parte, si tiene problemas con el symbolic,
 %puede comentar toda esta sección y correr el resto del codigo sin problema.


 %Punto 8: sistema siso 4x4, matriz C recortada
##Planta.c = [1 0 0 0;0 0 0 0]
## disp("________sistema simo con ambas tf pero solo una salida________")
## Planta %
## SIsO = ss2_TF(Planta)
## disp('______Devuelve una matriz con dos filas, pero una vale 0, es decir, solo hay una salida_________')

B = Planta.b
A = Planta.a
K = [48.2751,-21.5023,2.0831,-0.9708,-20.4]
K = [1,-2.5023,2.0831,-0.9708,-0.4]
s = tf('s')

SA = tf(1) %1
SC = -K(1,5)/s  %2

SD = tf(1)   %3
SE = tf(1) %4
b31 = B(3,1) %5
b21 = B(2,1) % 6
b41 = B(4,1) %7
SF = tf(1) %8
a33 = A(3,3) %9
SG = 1/s  %10
a42 = A(4,2) %11
a44 = A(4,4)%12
SH = 1/s %13
SI = 1/s %14
K2 = K(1,2) %15
K4 = K(1,4) %16
K3 = K(1,3) %17
K1 = K(1,1) %18
SB = tf(1) %19


in = 1;out = 19;
sys = append(SA,SC,SD,SE,b31,b21,b41,SF,a33,SG,a42,a44,SH,SI,K2,K3,K3,K1,SB);
Conectar = [1,-19,0,0,0;2,1,0,0,0;3,-15,-16,-17,-18;4,2,3,0,0;5,4,0,0,0;6,4,0,0,0;7,4,0,0,0;8,5,9,0,0;
            10,6,13,0,0;11,10,0,0,0;12,13,0,0,0;14,8,0,0,0;15,10,0,0,0;16,13,0,0,0;17,8,0,0,0;18,14,0,0,0;19,14,0,0,0;]
PlantaREI_C = connect(sys,Conectar,in,out)
%g = tf(PlantaREI_C)
figure("name", "Rspuesta al escalón modo de control REI para grúa")
step(0.5*PlantaREI_C,30)






