import sys # to get command line arguments
sys.path.append("C:/Users/61491/Desktop/Youtube/Code/CodingPractice/sort")
import sortAuxiliary

# print(sys.path)
# print(len(sys.path))
fileName = sys.argv[1]
fileDataTuple = sortAuxiliary.getFileData(fileName)
# print(fileDataTuple)

# Insertion Sort
j = 0
key = 0
for i in range(1, fileDataTuple[0]):
    j = i - 1
    key = fileDataTuple[1][i]
    while (j >= 0 and fileDataTuple[1][j] > key):
        fileDataTuple[1][j + 1] = fileDataTuple[1][j]
        j -= 1
    fileDataTuple[1][j + 1] = key 
    # insertion sort is basically saying 
    # "hey we have sorted the first x elements/cards, now looking at my x + 1th element/card
    # ask myself, where should I put it between my first x elements.
    # Imagine having a 1,2,5,7 in your hand and now you are dealt a 4, you will scan through your cards
    # and realize, 2 is biggest number smaller than 4, that's where you will put it. 
    # Since it is already sorted, the first number you find that is smaller than the number you want to insert is the
    # biggest number smaller than the 'key'"
sortAuxiliary.writeToFile("insertionSortPyOutput.txt", fileDataTuple)


# print(myTextList)

# f = open("selectionSortPyOutput.txt", "w")
# for i in range(numOfElems):
#     f.write(myTextList[i] + "\n")

