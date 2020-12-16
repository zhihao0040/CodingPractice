# We are in main implicitly. Don't need to make a main function
import random








n = 0
#print("Please insert the number of elements to sort: \n")
n = int(input("Please insert the number of elements to sort: \n")) # instead of getting a %d, we cast to int

random.seed(None) # use system time as seed



i = 0
f = open("randomTextsPy.txt", "w")
f.write("{numElems}\n".format(numElems = n))
# for i in range(0, n, 1):
for i in range(n):
    f.write("{elem}\n".format(elem = chr(random.randint(97, 97 + 25)))) # 25 because from alphabet 0: a -> alphabet 25: z

f.close()

