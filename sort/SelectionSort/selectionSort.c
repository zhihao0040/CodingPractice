#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv){
    if (argc != 2){
        printf("Please provide file name");
        return 1;
    }

    char* fileName = argv[1];

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
	printf("num: %d\n", numOfElems);

	// Open file for writing
    fp = fopen("selectionSortCOutput.txt", "w");
    char temp;
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
        temp = myTextArray[i];
        myTextArray[i] = myTextArray[smallestCharIndex];
        myTextArray[smallestCharIndex] = temp;
        // myTextArray[i], myTextArray[smallestCharIndex] = myTextArray[smallestCharIndex], myTextArray[i]; // shorthand doesn't work, works in python though
        // printf("%c ", myTextArray[i]);
		// Write to file rather than print
		fprintf(fp, "%c\n", myTextArray[i]);
		//printf("%c\n", myTextArray[i]);
		if (i == numOfElems - 2){
			fprintf(fp, "%c\n", myTextArray[i + 1]);
		}
    }
	

    printf("myTextArray[0] = %c\n", myTextArray[0]);
	
	// remember to close file
    fclose(fp);

    return 0;
}
