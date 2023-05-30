pragma circom 2.1.4;
include "./elgamal.circom";

template AddMod(n) {
    signal input elements[n];
    signal output out;

    var modulo = 2736030358979909402780800718157159386076813972158567259200215660948447373041;

    var sum = 0;
    for (var i = 0; i < n; i++) {
        sum = (sum + elements[i]) % modulo;
    }
    out <-- sum;
}

template RevealContribute(n, d) {
    // public signal
    signal input u[n-1][2];
    signal input c[n-1];
    signal input R[d][2];
    signal input D[d][2];

    // private signal
    signal input decryptedF[n-1];
    signal input f;
    signal input privateKey;
    signal input partialSecret;

    component fDecryption[n-1];
    component fSum = AddMod(n);
    
    for (var i = 0; i < n-1; i++) {
        fDecryption[i] = ElgamalDecrypt();

        fDecryption[i].u[0] <== u[i][0];
        fDecryption[i].u[1] <== u[i][1];
        fDecryption[i].c <== c[i];
        fDecryption[i].m <== decryptedF[i];
        fDecryption[i].privateKey <== privateKey;

        fSum.elements[i] <== decryptedF[i];
    }
    fSum.elements[n-1] <== f;
    
    partialSecret === fSum.out;

    component skBits = Num2Bits(256);
    component escalarmulSecret[d];
    skBits.in <== partialSecret;
    for (var i = 0; i < d; i++) {
        escalarmulSecret[i] = EscalarMulAny(256);
        
        escalarmulSecret[i].p[0] <== R[i][0];
        escalarmulSecret[i].p[1] <== R[i][1];
        for (var j = 0; j < 256; j++) {
            escalarmulSecret[i].e[j] <== skBits.out[j];
        }

        D[i][0] === escalarmulSecret[i].out[0];
        D[i][1] === escalarmulSecret[i].out[1];
    }
}