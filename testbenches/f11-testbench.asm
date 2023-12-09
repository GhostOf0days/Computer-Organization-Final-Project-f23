Address Value Code
        ORG 100      / Fibonacci number 11 calculation
100 3128 Load  TempCounter / Load the loop counter (9)
102 Store Counter / Store the loop counter into counter
104 Load FibNum0 / Load FibNum0 into AC
106 Store   FibNum1     / Store the the first operand into the second
108 Loop, Load FibNum1     / Load first fibonacci operand into AC
10A Add FibNum0 / Add the first operand to the second operand 
10C Store   FibNum2 / Store result into second (second = 0, will be updated later)
10E Load FibNum1 / Load the second fibonacci operand into AC
110 Store FibNum0 / Store the second fibonacci operand into the first 
112 Load FibNum2  / Store second operand into first
114 Store FibNum1 / Store the second operand into the the first 
116 Load  Counter / Load  Counter into AC
118 Add Decrement / Dectement to the counter 
11A Store Counter / Update Counter
11C Skip 400 / Check if loop counter is 0 and end
11E Jump  Loop   / Jump back to the loop start
120 Halt               / End of the program
122 FibNum0, Dec  0     / Initial value of first fibonacci operand
124 FibNum1, Dec  1     / Initial value of second fibonacci operand
126 FibNum2, Dec  0     / Initial value for fibonacci nuber
128 TempCounter, Dec 9         / Counter set to 11 for F11
12A Counter, Hex 0       / Temporary counter for loop control
12C Decrement, Dec -1        / Used to decrement by 1
