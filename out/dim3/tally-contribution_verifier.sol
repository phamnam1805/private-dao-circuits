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
            [12486698628806201510112288440650627182827227169029298584929749073010790701890,
             21411725411801503106388415468964470396104210239126575419147605092006850143942],
            [5749249448105612029915198091888177068081718529695914911592800674465803148447,
             21482736107449401979813811462761474153260481446097476494275936842158468184838]
        );
        vk.IC = new Pairing.G1Point[](25);
        
        vk.IC[0] = Pairing.G1Point( 
            452366793807916199534076289202280194213451467593667552799503095213772413982,
            21580891909919945553584123619432918900632149566858927482607405923162160502090
        );                                      
        
        vk.IC[1] = Pairing.G1Point( 
            17589011415141308395217272029034232131134323984048942792038903261335690704292,
            9546149956855998703218957615461027017768332338513675568809316995497171479337
        );                                      
        
        vk.IC[2] = Pairing.G1Point( 
            18746565557057039986308953426105338266841754682844933201185996038468961860282,
            11576600205251939720932885727405102300387133794662579257520357432367279827292
        );                                      
        
        vk.IC[3] = Pairing.G1Point( 
            15634400577463621313225949737649015006436406010024239555480942403194382271464,
            9457120118692544347070140080749967796172977631978511872666668724828797375478
        );                                      
        
        vk.IC[4] = Pairing.G1Point( 
            16183414158560631024448904422613867888759823937970658529678316668397482186552,
            21772043565850082383805296838659579846035439885327642107943394022364966671849
        );                                      
        
        vk.IC[5] = Pairing.G1Point( 
            18410731242337956986341864639761307125662327345215158632479784479896000997400,
            8481508450072475314917256797939739174777591079348747922381253638826762188856
        );                                      
        
        vk.IC[6] = Pairing.G1Point( 
            10422157685277421394258203441649561732294010239954635889243995504143333166374,
            5390601995421014239341034518929131425124568890008960656011317049463112566418
        );                                      
        
        vk.IC[7] = Pairing.G1Point( 
            11397727327187756950138766917536741398749049865072445076019088994033492574374,
            9284174614916073372311195576039188003707106222719429890569314396236419161767
        );                                      
        
        vk.IC[8] = Pairing.G1Point( 
            6304369591997290091294957381050326263188979657443333945308191887439682702014,
            3398684724681302167459457253200443605248028003868014188389672201081858134283
        );                                      
        
        vk.IC[9] = Pairing.G1Point( 
            20852617267834967754826516968812213822368366919954312031243862816267206047343,
            12521501736886504254526711413916014250327162934833157783247611425844237443295
        );                                      
        
        vk.IC[10] = Pairing.G1Point( 
            388107784774822930003241307218894237859739340465727804124061165929974147578,
            16141788249229869490544607669567435641342588068392684241166481882878591091351
        );                                      
        
        vk.IC[11] = Pairing.G1Point( 
            20018494952048147955422847525305715225162449503101881856650945527524399416425,
            6903555876632173918556361424953135950466110009985352878552077396206383418045
        );                                      
        
        vk.IC[12] = Pairing.G1Point( 
            15602844963871823642450808313081710456286882991948339407189881004607573977226,
            17462256384252988484099436041489001838174061913588457024390554504158551987182
        );                                      
        
        vk.IC[13] = Pairing.G1Point( 
            13959253335256506962265657544148501143820726852668554868635248757397110110354,
            413747414144172162557053463638342173017895877837779865868950269183718959179
        );                                      
        
        vk.IC[14] = Pairing.G1Point( 
            413498681683593755292962487259238178321672310228274817811496588102254271628,
            11720391303985756870647675775617672163454067329618052166040991092671245446597
        );                                      
        
        vk.IC[15] = Pairing.G1Point( 
            20911444005694324948427902131565432964050819193250382506318002764139007094668,
            17806048379337339100105187366870712624923445843212771513012517748247628736330
        );                                      
        
        vk.IC[16] = Pairing.G1Point( 
            1710229216045601765083578861395075244935274905033736092514825023681082804154,
            15280637239550740241680724140082025906071242432633429504189067577094253821482
        );                                      
        
        vk.IC[17] = Pairing.G1Point( 
            8849986482830439428328206108302340787970345040318918410457099515085339496369,
            4601238692933644186882598767484968136781821065964773621050037697121846257207
        );                                      
        
        vk.IC[18] = Pairing.G1Point( 
            21801479896441731000451621865606304079453024520674828581402198305752511324005,
            14941170053335383314715800254570734592084977819683665751239424990533374929978
        );                                      
        
        vk.IC[19] = Pairing.G1Point( 
            19490253453075650400360939271030470046782999608209374770121242345412374349980,
            19558188824964690227051531154580610203755045273813120255551156625609735611148
        );                                      
        
        vk.IC[20] = Pairing.G1Point( 
            7946204687612633153580966904396202804600938860897530291621060674432552178749,
            9476706623288932004754689021095128653332193143500126303355357434805895264952
        );                                      
        
        vk.IC[21] = Pairing.G1Point( 
            19058746816154615591884466952566516234110355135900686577787020975101035498515,
            21236763955243562008739190296209586550360973025903526810635406665694023560847
        );                                      
        
        vk.IC[22] = Pairing.G1Point( 
            13767289895774910512988460012948941727292179750115113503679890882682378464888,
            7132652152313019456396283056722208750747674170584652831177190941783043305123
        );                                      
        
        vk.IC[23] = Pairing.G1Point( 
            14776753444069880420363606035053247052141444450476487577620717712896529204718,
            2607434893685197579499410585266676250488746897872608571008896639151358555435
        );                                      
        
        vk.IC[24] = Pairing.G1Point( 
            14028851389439856662538207723726362884121999730481763003814767162684131891265,
            20670143271722698911836685307312307829368475661264333222084160654604607608624
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
            uint[24] memory input
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
