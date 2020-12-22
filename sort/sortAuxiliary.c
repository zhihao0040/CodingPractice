#include "foo.h"
#include <stdio.h>

char* getFileDataIntoArray(char* fileName){
	FILE *fp = fopen(fileName, "r");

    int numOfElems;
    fscanf(fp, "%d\n", &numOfElems);

    char* myTextArray = malloc(sizeof(char) * numOfElems);
    
    // Fill up myTextArray
    for (int i = 0; i < numOfElems; i++){
        fscanf(fp, "%c\n", &myTextArray[i]);
        // printf("%c\n", myTextArray[i]);
    }

    fclose(fp);

    return myTextArray;	
}
