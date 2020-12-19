#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv){
    char* fileName = argv[1];
     
    FILE *fp = fopen(fileName, "r");
    
    int numOfElems;
    fscanf(fp, "%d", &numOfElems);
    
    char* myTextArray = malloc(sizeof(char) * numOfElems);
    
    // Fill up myTextArray
    for (int i = 0; i < numOfElems; i++){
        fscanf(fp, "%c", myTextArray[i]);
    }
    
    // Selection Sort
    int smallestCharIndex; 
    for (int i = 0; i < numOfElems - 1; i++){
        smallestCharIndex = i;
        for (int j = i + 1; j < numOfElems; j++){
            if (myTextArray[smallestCharIndex] > myTextArray[j]){
                smallestCharIndex = j;
            }
        }
        // Swap smallest with current
        myTextArray[i], myTextArray[smallestCharIndex] = myTextArray[smallestCharIndex], myTextArray[i];
    }
}
