#!/bin/bash
FILE_NAME="result-verifier"
INPUT_PATH="./inputs/result-verifier-input.json"
BUILD_PATH="../build/${FILE_NAME}"
CPP_PATH="${BUILD_PATH}/${FILE_NAME}_cpp"
CPP_FILE_PATH="${CPP_PATH}/${FILE_NAME}"
JS_PATH="${BUILD_PATH}/${FILE_NAME}_js"
JS_FILE_PATH="${JS_PATH}/generate_witness.js"
WASM_FILE_PATH="${JS_PATH}/${FILE_NAME}.wasm"
# cd $CPP_PATH
# make
# cd -
# COMMAND="${CPP_FILE_PATH} ${INPUT_PATH} ${BUILD_PATH}/witness.wtns"
COMMAND="node ${JS_FILE_PATH} ${WASM_FILE_PATH} ${INPUT_PATH} ${BUILD_PATH}/witness.wtns"
# echo $COMMAND
eval "$COMMAND";