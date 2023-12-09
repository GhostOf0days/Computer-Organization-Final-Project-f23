Address Value Code
        ORG 100      // Fibonacci number 11 calculation
100 2128 Load  TempCounter / Load the loop counter (9)
102 312A Store Counter / Store the loop counter into counter
104 2122 Load FibNum0 / Load FibNum0 into AC
106 3124 Store   FibNum1     / Store the the first operand into the second
108 2124 Loop, Load FibNum1     / Load first fibonacci operand into AC
10A 0122 Add FibNum0 / Add the first operand to the second operand 
10C 3126 Store   FibNum2 / Store result into second (second = 0, will be updated later)
10E 2124 Load FibNum1 / Load the second fibonacci operand into AC
110 3122 Store FibNum0 / Store the second fibonacci operand into the first 
112 2126 Load FibNum2  / Store second operand into first
114 3124 Store FibNum1 / Store the second operand into the the first 
116 212A Load  Counter / Load  Counter into AC
118 012C Add Decrement / Dectement to the counter 
11A 312A Store Counter / Update Counter
11C 5400 Skip 400 / Check if loop counter is 0 and end
11E 6108 Jump Loop   / Jump back to the loop start
120 1000 Halt               / End of the program
122 0000 FibNum0, Dec  0     / Initial value of first fibonacci operand
124 0001 FibNum1, Dec  1     / Initial value of second fibonacci operand
126 0000 FibNum2, Dec  0     / Initial value for fibonacci nuber
128 0009 TempCounter, Dec 9         / Counter set to 11 for F11
12A 0000 Counter, Hex 0       / Temporary counter for loop control
12C FFFF Decrement, Dec -1        / Used to decrement by 1
