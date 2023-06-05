#!/bin/bash
FILE_NAME="round-2-contribution"
INPUT_PATH="./${FILE_NAME}.circom"
OUTPUT_PATH="../build/${FILE_NAME}"
mkdir -p $OUTPUT_PATH
circom $INPUT_PATH --r1cs --wasm --sym --c --output $OUTPUT_PATH