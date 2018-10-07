#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int main ()
{
    int v[] = {21, 45, 67, 98, 122, 870, 912, 976, 1002, 1122};
    int left = 0;
    int right = 10;
    int middle;
    int searchFor = 0;
    int index = -1;

loop_start:
    middle = (left + right) /2;
	printf("left: %d right: %d middle: %d v[middle] %d\n", left, right, middle, v[middle] );

	if (left >= right){
    	goto out;
    }
    if ( v[middle] == searchFor ){
		index = middle;
		goto out;
    }
    if ( v[middle] < searchFor){
    	left = middle + 1;
    	goto loop_start;
    }
    if ( v[middle] > searchFor ){
    	right = middle -1;
		goto loop_start;
    }
    
out:
	printf("found %d in array at index %d\n", searchFor, index );
    return 0;
}