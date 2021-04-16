import os
import string
from random import *

allowed = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

def getRandomInput(inBase):
    len = randint(3, 30);
    
    idx = randint(1, inBase-1);
    out = allowed[idx]
    
    for x in range(len):
        idx = randint(0, inBase-1);
        out = out + allowed[idx]
    return out
    
def printLine(num, res, ib, ob):
    print("@('" + num.strip() + "', " + str(ib) + ", " + str(ob) + ", '" + res.strip() + "'),")
  
max = 36 #36
cnt = 0

for fromBase in range(2, max+1):
    for toBase in range(2, max+1):
        if fromBase == toBase:
            continue
        numTests = randint(10, 25)
        for x in range(numTests):
            
            rand = randint(0, len(allowed)-1);
            input = getRandomInput(fromBase);
            command = 'echo "obase='+str(toBase)+'; ibase='+str(fromBase)+'; '+input+'" | bc'
            #print(command)
            response = (os.popen(command).read())
            
            if " " in response:
                number = ""
                split = response.replace("\n", "").replace("\\", "").strip().split(' ')
                for item in split:
                    if len(item) == 0:
                        continue
                    number += allowed[int(item.strip(string.ascii_letters))];
                response = number
            
            printLine(input, response, fromBase, toBase);
                
            cnt = cnt+1
  
print("Generated: " + str(cnt))