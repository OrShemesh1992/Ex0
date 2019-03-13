#!/bin/bash
dirPath=$1
program=$2
argu="$3"

cd $dirPath
    make
    if [ $? -eq 0 ]; then
      echo "Compilation Pass"
      valgrind --leak-check=full --error-exitcode=1  ./$program "${@:2}" > /dev/null 2>&1
      if [ $? -eq 0 ]; then
        echo "Memory Leaks Pass"
        valgrind --tool=helgrind --error-exitcode=1 ./$program "${@:2}"> /dev/null 2>&1
        if [ $? -eq 0 ]; then
          echo "Thread Race Pass"
          exit 0
        else
          echo "Thread Race Fail"
          exit 1
        fi
      else
        echo "Memory Leaks Fail"
          valgrind --tool=helgrind --error-exitcode=1 ./$program "${@:2}"> /dev/null 2>&1
        if [ $? -eq 0 ]; then
          echo "Thread Race Pass"
          exit 2
        else
          echo "Thread Race Fail"
          exit 3
        fi
      fi
    else
      echo "Compilation Fail"
      exit 7
    fi
