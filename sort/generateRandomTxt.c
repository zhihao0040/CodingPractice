#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char** argv){

    // if (argc != 2){
    //     printf("Please insert text file length");
    //     return 1;
    // }
    
    int n;
    printf("Please insert the number of elements to sort: \n");
    scanf("%d", &n);
    
    // seed
    int seed = time(NULL);

    int i;
    FILE *fp;
    fp = fopen("randomTexts.txt", "w");
    fprintf(fp, "%d\n", n);
    for (i = 0; i < n; i++){
        fprintf(fp, "%c\n", (97 + rand_r(&seed) % 26));
    }
    fclose(fp);
    return 0;
}


