#!/bin/bash

# Used to automatically check all input against solutions without manually doing it.

# Navigate to the tests directory
cd tests

# Loop through all the test files
for testfile in test*.txt; do
  echo "Running test: $testfile"
  
  # Extract the base number of the test file for matching with the solution
  testnum=${testfile#test}
  testnum=${testnum%.txt}

  # Run the program with the test file and capture its output
  ../main.out "$testfile" > ../test_output.txt

  # Now compare the output with the corresponding solution file
  if diff -w -B ../test_output.txt ../solutions/solution${testnum}.txt > /dev/null; then
    echo "Test $testnum PASS"
  else
    echo "Test $testnum FAIL"
    # Uncomment the line below if you want to see the diff for failed tests
    # diff -w -B ../test_output.txt ../solutions/solution${testnum}.txt
  fi
done

# Clean up: remove the generated test output file
rm ../test_output.txt

# Navigate back to the original directory
cd ..
