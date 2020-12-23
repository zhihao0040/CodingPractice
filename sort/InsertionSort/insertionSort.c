#include <stdio.h>
#include <stdlib.h>
#include "../sortAuxiliary.h"



int main(int argc, char** argv){
    if (argc != 2){
        printf("Please provide file name");
        return 1;
    }

    char* fileName = argv[1];

    // FILE *fp = fopen(fileName, "r");

    // int numOfElems;
    // fscanf(fp, "%d\n", &numOfElems);

    // char* myTextArray = malloc();

    // Repeat Work! Let's make this a function.
    FileData fD = getFileData(fileName);
    int j;
    int key;
    for (int i = 1; i < fD.numOfElems; i++){
        j = i - 1;
        key = fD.textArray[i];
        while (j > 0 && fD.textArray[j] > key){
            fD.textArray[j + 1] = fD.textArray[j];
            j -= 1;
        }
        fD.textArray[j + 1] = key;
    }
    writeToFile(fileName, fD);
    return 0;
}

// char* getFileDataIntoArray(char* fileName){
//     FILE *fp = fopen(fileName, "r");

//     int numOfElems;
//     fscanf(fp, "%d\n", &numOfElems);

//     char* myTextArray = malloc(sizeof(char) * numOfElems);
    
//     // Fill up myTextArray
//     for (int i = 0; i < numOfElems; i++){
//         fscanf(fp, "%c\n", &myTextArray[i]);
//         // printf("%c\n", myTextArray[i]);
//     }

//     fclose(fp);

//     return myTextArray;
// }