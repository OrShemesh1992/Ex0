#!/bin/bash

dirPath=$1
program=$2
file=./makefile
#testttttttttttttt
if [ -e "$dirPath/$file" ]; then
    make
    if [ $? -eq 0 ]; then
      echo "Compilation Pass"
      valgrind --leak-check=full -v ./$program  > leaks.txt 2>&1
      grep -q "no leaks are possible" leaks.txt
      if [ $? -eq 0 ]; then
        echo "Memory Leaks Pass"
        rm leaks.txt
        valgrind --tool=helgrind $dirPath/$program > threadRace.txt 2>&1
        grep -q "ERROR SUMMARY: 0 errors" threadRace.txt
        if [ $? -eq 0 ]; then
          echo "Thread Race Pass"
          rm threadRace.txt
          exit 0
        else
          echo "Thread Race Fail"
          rm threadRace.txt
          exit 1
        fi
      else
        echo "Memory Leaks Fail"
        rm leaks.txt
        exit 3
      fi
    else
      echo "Compilation Fail"
      exit 7
    fi
else
    echo "Compilation Fail"
    exit 7
fi
