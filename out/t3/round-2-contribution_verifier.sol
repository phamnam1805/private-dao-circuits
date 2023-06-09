//
// Copyright 2017 Christian Reitwiessner
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// 2019 OKIMS
//      ported to solidity 0.6
//      fixed linter warnings
//      added requiere error messages
//
//
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.11;
library Pairing {
    struct G1Point {
        uint X;
        uint Y;
    }
    // Encoding of field elements is: X[0] * z + X[1]
    struct G2Point {
        uint[2] X;
        uint[2] Y;
    }
    /// @return the generator of G1
    function P1() internal pure returns (G1Point memory) {
        return G1Point(1, 2);
    }
    /// @return the generator of G2
    function P2() internal pure returns (G2Point memory) {
        // Original code point
        return G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );

/*
        // Changed by Jordi point
        return G2Point(
            [10857046999023057135944570762232829481370756359578518086990519993285655852781,
             11559732032986387107991004021392285783925812861821192530917403151452391805634],
            [8495653923123431417604973247489272438418190587263600148770280649306958101930,
             4082367875863433681332203403145435568316851327593401208105741076214120093531]
        );
*/
    }
    /// @return r the negation of p, i.e. p.addition(p.negate()) should be zero.
    function negate(G1Point memory p) internal pure returns (G1Point memory r) {
        // The prime q in the base field F_q for G1
        uint q = 21888242871839275222246405745257275088696311157297823662689037894645226208583;
        if (p.X == 0 && p.Y == 0)
            return G1Point(0, 0);
        return G1Point(p.X, q - (p.Y % q));
    }
    /// @return r the sum of two points of G1
    function addition(G1Point memory p1, G1Point memory p2) internal view returns (G1Point memory r) {
        uint[4] memory input;
        input[0] = p1.X;
        input[1] = p1.Y;
        input[2] = p2.X;
        input[3] = p2.Y;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success,"pairing-add-failed");
    }
    /// @return r the product of a point on G1 and a scalar, i.e.
    /// p == p.scalar_mul(1) and p.addition(p) == p.scalar_mul(2) for all points p.
    function scalar_mul(G1Point memory p, uint s) internal view returns (G1Point memory r) {
        uint[3] memory input;
        input[0] = p.X;
        input[1] = p.Y;
        input[2] = s;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require (success,"pairing-mul-failed");
    }
    /// @return the result of computing the pairing check
    /// e(p1[0], p2[0]) *  .... * e(p1[n], p2[n]) == 1
    /// For example pairing([P1(), P1().negate()], [P2(), P2()]) should
    /// return true.
    function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
        require(p1.length == p2.length,"pairing-lengths-failed");
        uint elements = p1.length;
        uint inputSize = elements * 6;
        uint[] memory input = new uint[](inputSize);
        for (uint i = 0; i < elements; i++)
        {
            input[i * 6 + 0] = p1[i].X;
            input[i * 6 + 1] = p1[i].Y;
            input[i * 6 + 2] = p2[i].X[0];
            input[i * 6 + 3] = p2[i].X[1];
            input[i * 6 + 4] = p2[i].Y[0];
            input[i * 6 + 5] = p2[i].Y[1];
        }
        uint[1] memory out;
        bool success;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
            // Use "invalid" to make gas estimation work
            switch success case 0 { invalid() }
        }
        require(success,"pairing-opcode-failed");
        return out[0] != 0;
    }
    /// Convenience method for a pairing check for two pairs.
    function pairingProd2(G1Point memory a1, G2Point memory a2, G1Point memory b1, G2Point memory b2) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](2);
        G2Point[] memory p2 = new G2Point[](2);
        p1[0] = a1;
        p1[1] = b1;
        p2[0] = a2;
        p2[1] = b2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for three pairs.
    function pairingProd3(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](3);
        G2Point[] memory p2 = new G2Point[](3);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        return pairing(p1, p2);
    }
    /// Convenience method for a pairing check for four pairs.
    function pairingProd4(
            G1Point memory a1, G2Point memory a2,
            G1Point memory b1, G2Point memory b2,
            G1Point memory c1, G2Point memory c2,
            G1Point memory d1, G2Point memory d2
    ) internal view returns (bool) {
        G1Point[] memory p1 = new G1Point[](4);
        G2Point[] memory p2 = new G2Point[](4);
        p1[0] = a1;
        p1[1] = b1;
        p1[2] = c1;
        p1[3] = d1;
        p2[0] = a2;
        p2[1] = b2;
        p2[2] = c2;
        p2[3] = d2;
        return pairing(p1, p2);
    }
}
contract Verifier {
    using Pairing for *;
    struct VerifyingKey {
        Pairing.G1Point alfa1;
        Pairing.G2Point beta2;
        Pairing.G2Point gamma2;
        Pairing.G2Point delta2;
        Pairing.G1Point[] IC;
    }
    struct Proof {
        Pairing.G1Point A;
        Pairing.G2Point B;
        Pairing.G1Point C;
    }
    function verifyingKey() internal pure returns (VerifyingKey memory vk) {
        vk.alfa1 = Pairing.G1Point(
            20491192805390485299153009773594534940189261866228447918068658471970481763042,
            9383485363053290200918347156157836566562967994039712273449902621266178545958
        );

        vk.beta2 = Pairing.G2Point(
            [4252822878758300859123897981450591353533073413197771768651442665752259397132,
             6375614351688725206403948262868962793625744043794305715222011528459656738731],
            [21847035105528745403288232691147584728191162732299865338377159692350059136679,
             10505242626370262277552901082094356697409835680220590971873171140371331206856]
        );
        vk.gamma2 = Pairing.G2Point(
            [11559732032986387107991004021392285783925812861821192530917403151452391805634,
             10857046999023057135944570762232829481370756359578518086990519993285655852781],
            [4082367875863433681332203403145435568316851327593401208105741076214120093531,
             8495653923123431417604973247489272438418190587263600148770280649306958101930]
        );
        vk.delta2 = Pairing.G2Point(
            [2938395045314737926288728979732057438869275189415604104636946965835181919325,
             6209830185949261069395122562627262883771381693761432862320057122542359882038],
            [2682412178834126578725971895056357647368129138845029705517705738997662681284,
             4470718631977013405937580604122051692751762721569613896202048079267593828442]
        );
        vk.IC = new Pairing.G1Point[](31);
        
        vk.IC[0] = Pairing.G1Point( 
            8720751783121153186991395843724313970624704982314831344099770398266467559300,
            17124926995185029559267780465171996116807304944169583009154301855027032244825
        );                                      
        
        vk.IC[1] = Pairing.G1Point( 
            19628714642215544309436779460525942535263861775558566439303900154779202424140,
            17869091680042197519854681504988267332037930998719258431063045489230701520231
        );                                      
        
        vk.IC[2] = Pairing.G1Point( 
            13835234216074747477118379074900724375382683503207217909491499361239830766481,
            21465446381227143367738546420281234940845289075607989817221242124270816760900
        );                                      
        
        vk.IC[3] = Pairing.G1Point( 
            342978062236767786304877841545244568931750858756956878122150163684254056706,
            11652219200268761404071564289517135978617352924488422071729597540251811676470
        );                                      
        
        vk.IC[4] = Pairing.G1Point( 
            2267863923444399386251069832948702042973976429323710273748560017528868534960,
            16620458778193229360107238431198879409228520441458949612439017234183613417008
        );                                      
        
        vk.IC[5] = Pairing.G1Point( 
            11843104076816254525160021412116178025779331034987540269513545679942222892118,
            5228788308247329074182669417822172008562685924055693965137007209575561605149
        );                                      
        
        vk.IC[6] = Pairing.G1Point( 
            12510195836642805388723174582966989036480772668828168325008466751473449706772,
            19506451375358365476898449214705252659997037506490127915926329863170860534043
        );                                      
        
        vk.IC[7] = Pairing.G1Point( 
            12183899621805862844490909298180510569603837172787672014429176091788398655879,
            17537654672737437530725340547538306006956069861900120915077452850575338641064
        );                                      
        
        vk.IC[8] = Pairing.G1Point( 
            6827683738921846182686967988610121149417396979891330085828533817991943051298,
            21085506188002378447060718530117978592873033307446293122329997254073131378506
        );                                      
        
        vk.IC[9] = Pairing.G1Point( 
            14608417422187041656667736295485873093268618940125713959986525980974147582502,
            5903992012896582831960736970818591498029567600848542439781164168318912435525
        );                                      
        
        vk.IC[10] = Pairing.G1Point( 
            3834581233826447088610764151942157226903950686596017958287840994693892218396,
            11139334269941935755094578609787964800359884424773681225703944651951179441580
        );                                      
        
        vk.IC[11] = Pairing.G1Point( 
            9171382872179976226859227755984343175368270395637562133765440648057304535190,
            7058177132291427236218106723295695849068721364340642592451326070509515490329
        );                                      
        
        vk.IC[12] = Pairing.G1Point( 
            17311235246550203498557396550125143463133976237975428346068023130062343895534,
            21810264561682388847961471338188557156519986310295622438160708899173482441806
        );                                      
        
        vk.IC[13] = Pairing.G1Point( 
            14078729957107828031511896002519669831411421319343736437900986559401185462314,
            6781340522699786891612801072211167094411176916497781737897529309949480026069
        );                                      
        
        vk.IC[14] = Pairing.G1Point( 
            11694515414565343187645066836004632542924430059829013630109497061049926760254,
            20774951926565093157607172283260688448094194104933298941614782265506760675678
        );                                      
        
        vk.IC[15] = Pairing.G1Point( 
            16653646199532383627549455163762853890265075688399109983655691638485090468816,
            8449593993968729577824322556319125298374315619870217364800408777311349720228
        );                                      
        
        vk.IC[16] = Pairing.G1Point( 
            11689871021711420279788838781909626700856868802657528900735707001157633397253,
            19126865385177072799805021491075083338735676644304149510047431990260139505651
        );                                      
        
        vk.IC[17] = Pairing.G1Point( 
            17311292754574098271666763715279868181779952702923701723391905054004299383967,
            667886443402292832878366740816009100752199093211154518695778437753449199010
        );                                      
        
        vk.IC[18] = Pairing.G1Point( 
            21315591318119522732976871193963554616368281158090316022156654047176828451318,
            13184333323384369063381137116423714797357055880116232431017300877429748278054
        );                                      
        
        vk.IC[19] = Pairing.G1Point( 
            13026126727727255086308601453535460704455012210946385363751092282918371082775,
            10043416559637483598339527508641379045777558670923762781578559964216015395199
        );                                      
        
        vk.IC[20] = Pairing.G1Point( 
            6120338575126595464716485525179453102694621847107340285163296408414296686453,
            14985603126690177010854620243502014828061963269351604704144334730143132157247
        );                                      
        
        vk.IC[21] = Pairing.G1Point( 
            423308869251825220858587615083744465547945959537280460060441582567737407396,
            13606673815947419501910164431451488750605029965297825722366117448806575831935
        );                                      
        
        vk.IC[22] = Pairing.G1Point( 
            4784600652229576815100733718930571846565740666695247119590959827256905388093,
            1884246841099427974020067525979183505211670704701859486708813162454246440015
        );                                      
        
        vk.IC[23] = Pairing.G1Point( 
            16824682134660856995092185298766167721228175788526129584233873688996979185976,
            7532680799547790622836974357122735933556371704553327730298415601568535467022
        );                                      
        
        vk.IC[24] = Pairing.G1Point( 
            5798708888435025741312375453278130726656849107887855610267189135202534380598,
            21456413599051716563451119064762279181212993975475967305704146717957157206136
        );                                      
        
        vk.IC[25] = Pairing.G1Point( 
            20998535296212980734703460232113399805475078536001343024648321215899850395323,
            3545933300505608782581141293843225795383302371229304814697385303959304727386
        );                                      
        
        vk.IC[26] = Pairing.G1Point( 
            154878407047572055891869140165893419730392368793944602635968627883939758588,
            14225444648742206589445641098055697976304997580904147693054746813878043585751
        );                                      
        
        vk.IC[27] = Pairing.G1Point( 
            2899289577686252091777381107813113454998582681176781216111455117061866100343,
            20340183145961408323469160841305464182898545882902665715975758834656296848738
        );                                      
        
        vk.IC[28] = Pairing.G1Point( 
            11291500476805652871006527104654619560825892952894666102785743440816790995827,
            15744017353984402202073690066623766960632710959837689114944508658787609178267
        );                                      
        
        vk.IC[29] = Pairing.G1Point( 
            13262534413859887941308460790438966871219123987766703768701934380883973550562,
            17273129217555868640075184878148495761068002903276397516562743818571891169391
        );                                      
        
        vk.IC[30] = Pairing.G1Point( 
            7703400283523116337672680475612307163498742425363656974830788847542813196845,
            419354686605577161580322152498465666766731267330478854380901213212080188094
        );                                      
        
    }
    function verify(uint[] memory input, Proof memory proof) internal view returns (uint) {
        uint256 snark_scalar_field = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
        VerifyingKey memory vk = verifyingKey();
        require(input.length + 1 == vk.IC.length,"verifier-bad-input");
        // Compute the linear combination vk_x
        Pairing.G1Point memory vk_x = Pairing.G1Point(0, 0);
        for (uint i = 0; i < input.length; i++) {
            require(input[i] < snark_scalar_field,"verifier-gte-snark-scalar-field");
            vk_x = Pairing.addition(vk_x, Pairing.scalar_mul(vk.IC[i + 1], input[i]));
        }
        vk_x = Pairing.addition(vk_x, vk.IC[0]);
        if (!Pairing.pairingProd4(
            Pairing.negate(proof.A), proof.B,
            vk.alfa1, vk.beta2,
            vk_x, vk.gamma2,
            proof.C, vk.delta2
        )) return 1;
        return 0;
    }
    /// @return r  bool true if proof is valid
    function verifyProof(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[30] memory input
        ) public view returns (bool r) {
        Proof memory proof;
        proof.A = Pairing.G1Point(a[0], a[1]);
        proof.B = Pairing.G2Point([b[0][0], b[0][1]], [b[1][0], b[1][1]]);
        proof.C = Pairing.G1Point(c[0], c[1]);
        uint[] memory inputValues = new uint[](input.length);
        for(uint i = 0; i < input.length; i++){
            inputValues[i] = input[i];
        }
        if (verify(inputValues, proof) == 0) {
            return true;
        } else {
            return false;
        }
    }
}
