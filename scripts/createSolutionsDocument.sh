#!/bin/bash

# Navigate to the tests directory
cd solutions

# Create or clear the solutions.txt file
> solutions.txt

# Loop through all the solution files
for solution in solution*.c; do
  # Add a header for the solution test file in solutions.txt
  echo "===== Content of $solution =====" >> solutions.txt

  # Append the content of the test file to solutions.txt
  cat "$solution" >> solutions.txt

  # Optionally, add a separator or newline for readability
  echo -e "\n\n" >> solutions.txt
done

# Navigate back to the original directory
cd ..
