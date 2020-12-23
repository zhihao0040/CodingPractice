def getFileData(fileName):
    fp = open(fileName, "r")

    numOfElems = 0
    numOfElems = int(fp.readline().strip())

    myTextList = [0] * numOfElems

    for i in range(numOfElems):
        myTextList[i] = fp.readline().strip()

    fp.close()
    return numOfElems, myTextList# return as a tuple, no need structure, if needed we can create class.

def writeToFile(fileName, fileDataTuple):
    # fileDataTuple[0] is the numOfElems and fileDataTuple[1] is the text array.
    # a class would be a better job.
    # used to showcase how to access the things twice using 2 [][]. 
    # since this is python, we don't even need to do that, we can just use the text array and use len()
    fp = open(fileName, "w")
    # for i in range(len(fileDataTuple[1])): # remember fileDataTuple[1] is the textArray
    for i in range(fileDataTuple[0]): # remember fileDataTuple[0] is just the length of the list/total number of elements
        fp.write(fileDataTuple[1][i] + "\n")

class FileData:
    def __init__(self, numOfElems, textArray): # remember these parameters aren't just names. It's the position that matters
        # self can be replaced with this or whatever you want to call it ut for python, self is the standard
        self.numOfElems = numOfElems
        self.textArray = textArray

    # def __init__(me, numOfElems, textArray): # remember these parameters aren't just names. It's the position that matters
    #     # self can be replaced with this or whatever you want to call it ut for python, self is the standard
    #     me.numOfElems = numOfElems
    #     me.textArray = textArray

if __name__ == "__main__":
    x = FileData(3, [])
    print(x.numOfElems)
    print(x.textArray)