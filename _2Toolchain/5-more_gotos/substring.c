#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*int isSubstring(string s1, string s2) 
{ 
    int M = s1.length(); 
    int N = s2.length(); 
  
    for (int i = 0; i <= N - M; i++) { 
        int j; 
  
        for (j = 0; j < M; j++) 
            if (s2[i + j] != s1[j]) 
                break; 
  
        if (j == M) 
            return i; 
    } 
  
    return -1; 
} */

int main(){
	char s1[] = "searchme";
	char s2[] = "looking for searchme here";
	int n1 = strlen(s1);
	int n2 = strlen(s2);
	int i = -1, j;
	int index = -1;

loop_i_start:
	
	i++;
	j = -1;

	if (i > n2 - n1)
		goto out;

loop_j_start:

	j++;

	if (j == n1){
		index = i;
		goto out;
	}

	if (s2[i+j] != s1[j])
		goto loop_i_start;

	goto loop_j_start;


out:
	printf("found string '%s' in string '%s' at index %d\n", s1, s2, index);
	return 0;
}