# ASM-DRAWING

## PRESENTATION
This assembler project allows to draw a defined number of triangles. Indeed with the function rdrand you can generate 3 points which will be stored in an array and then sent to the XDrawLine function. Then we calculate a determinant of the triangle to know if the triangle is direct or indirect.

Afterwards, we want to draw in the triangle, so for this we will define a point P that we will increment by 1 at each turn. We will calculate its determinant with all the other points of the triangle (APB, BPC, CPA) in order to know if it is inside or outside the triangle.

In the case of an indirect triangle, the determinant of the triangle must be positive, and for the point to be inside the three determinants of the points must be negative.

In the case of a direct triangle, the determinant of the triangle must be negative, and for the point to be inside the three determinants of the point must be positive.
Once the window has been browsed and the points drawn, the function is restarted for a second triangle and performs the calculations again.

## EXECUTION
To run the project, start the terminal and execute the following commands: 

wget http://nn7.free.fr/ASM_install.sh

chmod +x ASM_install.sh

./ASM_install.sh

To assemble a program written in NASM assembly :

nasm -felf64 -o ESGI_AlgorithmederemplissageenAssembleur-2A3_E1_02-23-09.16.21_projet.o ESGI_AlgorithmederemplissageenAssembleur-2A3_E1_02-23-09.16.21_projet.asm

Then generate the executable with :

gcc -m64 -no-pie -o program_executable ESGI_AlgorithmederemplissageenAssembleur-2A3_E1_02-23-09.16.21_projet.o

./ESGI_AlgorithmederemplissageenAssembleur-2A3_E1_02-23-09.16.21_projet

