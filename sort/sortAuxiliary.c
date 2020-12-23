#include "sortAuxiliary.h"
#include <stdio.h>
#include <stdlib.h>

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

void writeToFile(char* fileName, FileData fD){
    FILE *fp = fopen(fileName, "w");
    for (int i = 0; i < fD.numOfElems; i++){
        fprintf(fp, "%c\n", fD.textArray[i]);
    }
    fclose(fp);
}
