import sys # to get command line arguments


fileName = sys.argv[1]

f = open(fileName, "r")


numOfElems = 0
numOfElems = int(f.readline().strip()) # cast to int type after taking off "\n"

myTextList = [0] * numOfElems # this is a list, not an array. Think of lists as resizable arrays

# Fill up myTextList
for i in range(numOfElems):
    myTextList[i] = f.readline().strip() # strip off \n, the newline character
#print(myTextList)
f.close()

# similarly, rather than doing this, since myTextList is a list and not an array, we no longer need the number
# which tells us how many elements there are, as we do not need to preallocate memory for it.
f = open(fileName, "r")
myTextListTest = []
while True:
    element = f.readline().strip()
    # if not element: # not empty string, short hand for it
    if not element != "":
        break
    myTextListTest.append(element) 
    
print(myTextListTest) # we would expect the 10 to be part of the elements, simple if statement to ignore it,
                      # we can see from this though that we no longer need the nmber of elements.
f.close()

# Selection Sort
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
    f.write(myTextList[i])

