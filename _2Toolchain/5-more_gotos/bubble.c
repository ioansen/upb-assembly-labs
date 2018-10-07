#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

/*void bubbleSort(int v[], int n){
    int i, j; 
    for (i = 0; i < n-1; i++)       
        for (j = 0; j < n-i-1; j++)  
           if (v[j] > v[j+1]){
                swap(&v[j], &v[j+1]); 
           }
}*/

int main ()
{
    int v[] = {2121, 495, 67, 988, 1122, 80, 912, 97, 1002, 1122};
    int size = 10;
    int i = -1, j;
    int aux;


loop_i_start:

    i++;
    j = -1;

    if ( i == size - 1) 
        goto out;

loop_j_start:

    j++;

    if ( j == size - i - 1) 
        goto loop_i_start;

    //printf("i: %d j: %d v[i]: %d v[j]: %d\n", i, j, v[j], v[j+1] );

    if (v[j] > v[j+1]){
        aux = v[j];
        v[j] = v[j+1];
        v[j+1] = aux;
    }
    goto loop_j_start;
    
out:

    for (i = 0; i < size; i++) 
        printf("%d ", v[i]); 
    printf("\n");
    return 0;
}