pragma circom 2.1.4;
include "./libs/elgamal.circom";

template Round2Contribution(t) {
    // public signal
    signal input receiverIndex;
    signal input receiverPublicKey[2];
    signal input C[t][2];
    signal input u[2];
    signal input c;

    // private signal
    signal input f;
    signal input b;

    var baseX = 5299619240641551281634865583518297030282874472190772894086521144482721001553;
    var baseY = 16950150798460657717958625567821834550301663161624707787222815936182638968203;

    component elgamal = ElgamalEncrypt();
    elgamal.u[0] <== u[0];
    elgamal.u[1] <== u[1];
    elgamal.publicKey[0] <== receiverPublicKey[0];
    elgamal.publicKey[1] <== receiverPublicKey[1];
    elgamal.c <== c;
    elgamal.m <== f;
    elgamal.b <== b;
    
    component fBits = Num2Bits(256);
    component escalarMulLeft = EscalarMulAny(256);
    fBits.in <== f;
    escalarMulLeft.p[0] <== baseX;
    escalarMulLeft.p[1] <== baseY;
    for (var i = 0; i < 256; i++) {
        escalarMulLeft.e[i] <== fBits.out[i];
    }

    var x = 1;
    component iBits[t];
    component escalarMulRights[t];
    iBits[0] = Num2Bits(256);
    escalarMulRights[0] = EscalarMulAny(256);
    iBits[0].in <-- x;
    escalarMulRights[0].p[0] <== C[0][0];
    escalarMulRights[0].p[1] <== C[0][1];
    for (var i = 0; i < 256; i++){
        escalarMulRights[0].e[i] <== iBits[0].out[i];
    }
    for (var i = 1 ; i < t; i++) {
        x = x * receiverIndex;
        iBits[i] = Num2Bits(256);
        escalarMulRights[i] = EscalarMulAny(256);
        iBits[i].in <-- x;
        escalarMulRights[i].p[0] <== C[i][0];
        escalarMulRights[i].p[1] <== C[i][1];
        for( var j = 0; j < 256; j++){
            escalarMulRights[i].e[j] <== iBits[i].out[j];
        }
    }

    component adder[t];
    adder[0] = BabyAdd();
    adder[0].x1 <== 0;
    adder[0].y1 <== 1;
    adder[0].x2 <== escalarMulRights[0].out[0];
    adder[0].y2 <== escalarMulRights[0].out[1];
    
    for(var i = 1; i < t; i++){
        adder[i] = BabyAdd();
        adder[i].x1 <== adder[i-1].xout;
        adder[i].y1 <== adder[i-1].yout;
        adder[i].x2 <== escalarMulRights[i].out[0];
        adder[i].y2 <== escalarMulRights[i].out[1];
    }

    adder[t-1].xout === escalarMulLeft.out[0];
    adder[t-1].yout === escalarMulLeft.out[1];
}

component main {public [receiverIndex, receiverPublicKey, C, u, c]} = Round2Contribution(3);
