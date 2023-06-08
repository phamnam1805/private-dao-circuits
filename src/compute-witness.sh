#!/bin/bash
FILE_NAME="multiple-leaves-insert"
INPUT_PATH="./inputs/multiple-leaves-insert-input.json"
BUILD_PATH="../build/${FILE_NAME}"
CPP_PATH="${BUILD_PATH}/${FILE_NAME}_cpp"
CPP_FILE_PATH="${CPP_PATH}/${FILE_NAME}"
cd $CPP_PATH
make
cd -
COMMAND="${CPP_FILE_PATH} ${INPUT_PATH} ${BUILD_PATH}/witness.wtns"
# echo $COMMAND
eval "$COMMAND";