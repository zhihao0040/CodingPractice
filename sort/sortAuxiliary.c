#include "sortAuxiliary.h"
#include <stdio.h>

FileData getFileData(char* fileName){
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
    FileData fd;
    fd.numOfElems = numOfElems;
    fd.textArray = myTextArray;
    return fd;	
}
