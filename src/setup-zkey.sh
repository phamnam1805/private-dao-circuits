#!/bin/bash
FILE_NAME="result-verifier"
PTAU_PATH="../build/ptau/pot15_final.ptau"
ZKEY_PATH="../build/zkey"
BUILD_PATH="../build/${FILE_NAME}"
R1CS_PATH="${BUILD_PATH}/${FILE_NAME}.r1cs"
WASM_PATH="${BUILD_PATH}/${FILE_NAME}_js/${FILE_NAME}.wasm"
mkdir -p $ZKEY_PATH
snarkjs groth16 setup $R1CS_PATH $PTAU_PATH "${ZKEY_PATH}/${FILE_NAME}_0.zkey"
snarkjs zkey contribute "${ZKEY_PATH}/${FILE_NAME}_0.zkey" "${ZKEY_PATH}/${FILE_NAME}_1.zkey" --name="1st Contributor Name" -v
snarkjs zkey contribute "${ZKEY_PATH}/${FILE_NAME}_1.zkey" "${ZKEY_PATH}/${FILE_NAME}_2.zkey" --name="Second contribution Name" -v -e="Another random entropy"
snarkjs zkey export bellman "${ZKEY_PATH}/${FILE_NAME}_2.zkey"  "${ZKEY_PATH}/challenge_phase2_0003"
snarkjs zkey bellman contribute bn128 "${ZKEY_PATH}/challenge_phase2_0003" "${ZKEY_PATH}/response_phase2_0003" -e="some random text"
snarkjs zkey import bellman "${ZKEY_PATH}/${FILE_NAME}_2.zkey" "${ZKEY_PATH}/response_phase2_0003" "${ZKEY_PATH}/${FILE_NAME}_3.zkey" -n="Third contribution name"
snarkjs zkey verify $R1CS_PATH $PTAU_PATH  "${ZKEY_PATH}/${FILE_NAME}_3.zkey"
snarkjs zkey beacon "${ZKEY_PATH}/${FILE_NAME}_3.zkey" "${ZKEY_PATH}/${FILE_NAME}_final.zkey" 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10 -n="Final Beacon phase2"
snarkjs zkey verify $R1CS_PATH $PTAU_PATH  "${ZKEY_PATH}/${FILE_NAME}_final.zkey"
snarkjs zkey export verificationkey "${ZKEY_PATH}/${FILE_NAME}_final.zkey" "${ZKEY_PATH}/${FILE_NAME}_verification-key.json"
snarkjs zkey export solidityverifier "${ZKEY_PATH}/${FILE_NAME}_final.zkey" "${ZKEY_PATH}/${FILE_NAME}_verifier.sol"
rm "${ZKEY_PATH}/${FILE_NAME}_0.zkey" "${ZKEY_PATH}/${FILE_NAME}_1.zkey" "${ZKEY_PATH}/${FILE_NAME}_2.zkey" "${ZKEY_PATH}/${FILE_NAME}_3.zkey" "${ZKEY_PATH}/challenge_phase2_0003" "${ZKEY_PATH}/response_phase2_0003"

