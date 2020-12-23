#ifndef SORT_AUXILIARY_H 
#define SORT_AUXILIARY_H

struct FileData {
    int numOfElems;
    char* textArray;
};

typedef struct FileData FileData;

FileData getFileData(char* fileName);
void writeToFile(char* fileName, FileData fD);

#endif
