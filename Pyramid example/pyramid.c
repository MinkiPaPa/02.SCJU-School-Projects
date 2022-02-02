/* 
Author : Minkipapa
this source code for Newby of C language.
This code makes you understand how you can use "for" in C language. 
*/ 

#include <stdio.h>

int main(void)
{
    int floor; // user can to set how floor make
    printf("how many floor you want to make? ");
    scanf("%d", &floor); // input number from user. and when useing g++ some issue when use scanf_s

    for (int i = 0; i < floor; i++)
    {
        for ( int j = i; j < floor-1; j++)
        {
            printf("S");
            // printf(" "); if you want to output an empty spaces.
        }
        for ( int k = 0; k < i*2+1; k++)
        {
            printf("*");
        }
        printf("\n");
    }
    return 0;
}