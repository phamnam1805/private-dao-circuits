pragma circom 2.1.4;

include "../node_modules/circomlib/circuits/escalarmulany.circom";
include "../node_modules/circomlib/circuits/gates.circom";

template ResultVerifier (d) {
    // public input
    signal input result[d];
    signal input resultVector[d][2];

    var baseX = 5299619240641551281634865583518297030282874472190772894086521144482721001553;
    var baseY = 16950150798460657717958625567821834550301663161624707787222815936182638968203;

    component escalarMul[d];
    component resultBits[d];
    for(var i = 0; i < d; i++){
        resultBits[i] = Num2Bits(256);
        resultBits[i].in <== result[i];
        escalarMul[i] = EscalarMulAny(256);
        escalarMul[i].p[0] <== baseX;
        escalarMul[i].p[1] <== baseY;
        for (var j = 0; j < 256; j++){
            escalarMul[i].e[j] <== resultBits[i].out[j];
        }

        escalarMul[i].out[0] === resultVector[i][0];
        escalarMul[i].out[1] === resultVector[i][1];
    }
}

component main {public [result, resultVector]} = ResultVerifier(3);