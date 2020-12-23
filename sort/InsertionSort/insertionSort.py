import sys # to get command line arguments


fileName = sys.argv[1]


# Insertion Sort
smallestCharIndex = 0
for i in range(numOfElems - 1):
    smallestCharIndex = i
    for j in range(i + 1, numOfElems):
        if (myTextList[j] < myTextList[smallestCharIndex]): # strictly smaller, not <= because we want to preserve order.
            smallestCharIndex = j
    
    # swap smallest with current
    myTextList[i], myTextList[smallestCharIndex] = myTextList[smallestCharIndex], myTextList[i]

print(myTextList)

f = open("selectionSortPyOutput.txt", "w")
for i in range(numOfElems):
    f.write(myTextList[i] + "\n")

