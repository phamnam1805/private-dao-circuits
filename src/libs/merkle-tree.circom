pragma circom 2.1.4;
include "./poseidon.circom";
include "../../node_modules/circomlib/circuits/mimcsponge.circom";

// Computes Poseidon([left, right])
template HashLeftRight() {
    signal input left;
    signal input right;
    signal output out;

    component hasher = Poseidon(2, 6, 8, 57);
    hasher.inputs[0] <== left;
    hasher.inputs[1] <== right;
    out <== hasher.out;
}

// Computes MiMC([left, right])
// template HashLeftRight() {
//     signal input left;
//     signal input right;
//     signal output out;

//     component hasher = MiMCSponge(2, 220, 1);
//     hasher.ins[0] <== left;
//     hasher.ins[1] <== right;
//     hasher.k <== 0;
//     out <== hasher.outs[0];
// }

// if s == 0 returns [in[0], in[1]]
// if s == 1 returns [in[1], in[0]]
template DualMux() {
    signal input in[2];
    signal input s;
    signal output out[2];

    s * (1 - s) === 0;
    out[0] <== (in[1] - in[0])*s + in[0];
    out[1] <== (in[0] - in[1])*s + in[1];
}

// Verifies that merkle proof is correct for given merkle root and a leaf
// pathIndices input is an array of 0/1 selectors telling whether given pathElement is on the left or right side of merkle path
template MerkleTreeChecker(levels) {
    signal input leaf;
    signal input pathRoot;
    signal input pathElements[levels];
    signal input pathIndices[levels];

    component selectors[levels];
    component hashers[levels];

    for (var i = 0; i < levels; i++) {
        selectors[i] = DualMux();
        selectors[i].in[0] <== i == 0 ? leaf : hashers[i - 1].out;
        selectors[i].in[1] <== pathElements[i];
        selectors[i].s <== pathIndices[i];

        hashers[i] = HashLeftRight();
        hashers[i].left <== selectors[i].out[0];
        hashers[i].right <== selectors[i].out[1];
    }

    // log(pathRoot);
    // log(hashers[levels - 1].out);
    pathRoot === hashers[levels - 1].out;
}
