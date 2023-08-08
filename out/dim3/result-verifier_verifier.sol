// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 20491192805390485299153009773594534940189261866228447918068658471970481763042;
    uint256 constant alphay  = 9383485363053290200918347156157836566562967994039712273449902621266178545958;
    uint256 constant betax1  = 4252822878758300859123897981450591353533073413197771768651442665752259397132;
    uint256 constant betax2  = 6375614351688725206403948262868962793625744043794305715222011528459656738731;
    uint256 constant betay1  = 21847035105528745403288232691147584728191162732299865338377159692350059136679;
    uint256 constant betay2  = 10505242626370262277552901082094356697409835680220590971873171140371331206856;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 20874166774567846249142019994695130409031048180657922654312421881836984633275;
    uint256 constant deltax2 = 13774550616877834422483767879288560518675781299019066969630881892480927380186;
    uint256 constant deltay1 = 13232247056846671659229066227954960389882623788681967944408122977031485763322;
    uint256 constant deltay2 = 21092584069359746820145307226288988012135877726704427781091217015611040620158;

    
    uint256 constant IC0x = 15498526668381704486149173031836031945742834643325313827243672806251595792765;
    uint256 constant IC0y = 11646474446578899152564520393577600600350625551265204376120185038771177860736;
    
    uint256 constant IC1x = 17692295012978539812057624945204877626941305400223603439669178725168378920980;
    uint256 constant IC1y = 12804132944403958043588476394604758429647721386351074715731268999724843048012;
    
    uint256 constant IC2x = 7826989056779313702151809098964172586760469036566513359582217699069884409583;
    uint256 constant IC2y = 1376369301216622907590199143721910376772726794883475827904107572933247615796;
    
    uint256 constant IC3x = 20179093122948106316513051646808897559935275338374607819697936242179501293603;
    uint256 constant IC3y = 16038491786570387348074289712035624637012084012735356143803530378594586704634;
    
    uint256 constant IC4x = 7361260567956574206323553317281837756350602150420769356721998675167025864533;
    uint256 constant IC4y = 1572584166920321160755760147972024797766461183401291163185879000317117198675;
    
    uint256 constant IC5x = 2445792664894395108613415365806680202141759631984203348698437230416440599018;
    uint256 constant IC5y = 3546389040166706097213494791989376547080323218433008003530465125397488987496;
    
    uint256 constant IC6x = 9041925906250914357111139520495547102298112558260486271765462669277484839330;
    uint256 constant IC6y = 15983785075892266061323833947076865932285312867568338195132139283672400760017;
    
    uint256 constant IC7x = 12833815726579244353578189493741851802434224044555175091769986319501448011034;
    uint256 constant IC7y = 8273168982725115549257269704225630004112081746845761722836470611861853859923;
    
    uint256 constant IC8x = 19869580225059398547591212066311191451619104893518495581557381257574812426333;
    uint256 constant IC8y = 1926296867109255475220952658146800898845272952416578250963149244269052755249;
    
    uint256 constant IC9x = 4245197762848487987422970668962666561842095959775117962134800883453425042675;
    uint256 constant IC9y = 12350429053602387258299339194160134866743154489620514866516407983438253714366;
    
    uint256 constant IC10x = 12302545488806474037074667635798440724234148009943638079542275050515263702704;
    uint256 constant IC10y = 12413082608221254412952903633406162378344730946500556883574404907212830306525;
    
    uint256 constant IC11x = 2443455975966767131363436669890487423174678597307090080211945851852444897215;
    uint256 constant IC11y = 1634424297985459337933003809882797180138721800080840991753543543709709404303;
    
    uint256 constant IC12x = 8791427445326091182986632841081046517684409638981820771400369963622809988184;
    uint256 constant IC12y = 7001805818989479752146434588387009976363696823830042416395149382293330609448;
    
    uint256 constant IC13x = 7218037418526988387326256188117738523961360686554859044477385529458312460751;
    uint256 constant IC13y = 18198434416792654234678783683876521848765308345474780656629030114848065944823;
    
    uint256 constant IC14x = 6032007833863379059687911648913419468653665296073446831288292791799902594700;
    uint256 constant IC14y = 1059238400219894517579367832421960802273045361204698936811452923084501429828;
    
    uint256 constant IC15x = 18937246838915752953965143220418823028317225009808770685436502332477512411791;
    uint256 constant IC15y = 1509256469870465554108187782758199677680226022537395856222772414311168666559;
    
    uint256 constant IC16x = 10238713151817941701675596641355644901831858237488564186502414516036626540802;
    uint256 constant IC16y = 5625658046504598075901993688155279421354484361032351877166660137165648049557;
    
    uint256 constant IC17x = 13784305431902000769061629673070326807795875352880835173554262671680250294846;
    uint256 constant IC17y = 11781482733583924309105436255977692188778802204139951259183148154281359544720;
    
    uint256 constant IC18x = 11835978418667778324668901812986427462153197610377432665327648618640299337093;
    uint256 constant IC18y = 13686304547533468371867537183729610247750492922082331625427412805095209246130;
    
    uint256 constant IC19x = 14728431734859440698610455305794806317042579264948030523199836358769046275184;
    uint256 constant IC19y = 11454323711926139306021877281537631043024555160436283579507153312096929447058;
    
    uint256 constant IC20x = 21690743754095004671567375418157291695945319299074610292219568362207844582555;
    uint256 constant IC20y = 1784962484891751208020712068871318584803864832744000432216027105665920066151;
    
    uint256 constant IC21x = 17166533876832539776564125968583144649145334906403699461277834122997786888915;
    uint256 constant IC21y = 5938798526041487323153528522519924164464581298464767738839102076890271672865;
    
    uint256 constant IC22x = 2013254735886245662878799536178513027639018066275812026470459133276216137766;
    uint256 constant IC22y = 9992442668567974732392917063797716777262454131725760893745410898930464405235;
    
    uint256 constant IC23x = 9093600533082580272240308819951121354509243130318789232714879829475853731870;
    uint256 constant IC23y = 21084454140980511165925692128101923109393737904225180048570293382191254209774;
    
    uint256 constant IC24x = 11520110560146403470181364257409303130706033992333350144775154509316127952443;
    uint256 constant IC24y = 2300509496035513713078633005929273643184135010878291446594604549095697179869;
    
    uint256 constant IC25x = 35130768348867910844688629756472823639383221875113974277409880748142744916;
    uint256 constant IC25y = 18850533211519290366307867704804996248145499908200880351360021376463603111474;
    
    uint256 constant IC26x = 5423212934318635923126311261938776600088147582986305860651490140713269190226;
    uint256 constant IC26y = 11627820440666335812812152368610061675281787720738682921683789711583530789595;
    
    uint256 constant IC27x = 15194332627079852924995789867493059224448373159888391212500757554790842362352;
    uint256 constant IC27y = 9025966247161787658890396533321984739669373962495993112436602651247771960263;
    
    uint256 constant IC28x = 5226814480339965087780254007627839192687789608037411818182322398288563151266;
    uint256 constant IC28y = 15429409547450083689160305612716253004070630297958673431809608358522426369587;
    
    uint256 constant IC29x = 8713128764534117189142425346849546466946287367817283192170042849887347133029;
    uint256 constant IC29y = 841492547613674806419167611199357695802075524284850388760339679088118935388;
    
    uint256 constant IC30x = 15858350358188690128257700227027668358669749757259796902907299303885375598258;
    uint256 constant IC30y = 18694237750672000219119764761046963255333530325166100292473319867267587520114;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[30] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            
            checkField(calldataload(add(_pubSignals, 64)))
            
            checkField(calldataload(add(_pubSignals, 96)))
            
            checkField(calldataload(add(_pubSignals, 128)))
            
            checkField(calldataload(add(_pubSignals, 160)))
            
            checkField(calldataload(add(_pubSignals, 192)))
            
            checkField(calldataload(add(_pubSignals, 224)))
            
            checkField(calldataload(add(_pubSignals, 256)))
            
            checkField(calldataload(add(_pubSignals, 288)))
            
            checkField(calldataload(add(_pubSignals, 320)))
            
            checkField(calldataload(add(_pubSignals, 352)))
            
            checkField(calldataload(add(_pubSignals, 384)))
            
            checkField(calldataload(add(_pubSignals, 416)))
            
            checkField(calldataload(add(_pubSignals, 448)))
            
            checkField(calldataload(add(_pubSignals, 480)))
            
            checkField(calldataload(add(_pubSignals, 512)))
            
            checkField(calldataload(add(_pubSignals, 544)))
            
            checkField(calldataload(add(_pubSignals, 576)))
            
            checkField(calldataload(add(_pubSignals, 608)))
            
            checkField(calldataload(add(_pubSignals, 640)))
            
            checkField(calldataload(add(_pubSignals, 672)))
            
            checkField(calldataload(add(_pubSignals, 704)))
            
            checkField(calldataload(add(_pubSignals, 736)))
            
            checkField(calldataload(add(_pubSignals, 768)))
            
            checkField(calldataload(add(_pubSignals, 800)))
            
            checkField(calldataload(add(_pubSignals, 832)))
            
            checkField(calldataload(add(_pubSignals, 864)))
            
            checkField(calldataload(add(_pubSignals, 896)))
            
            checkField(calldataload(add(_pubSignals, 928)))
            
            checkField(calldataload(add(_pubSignals, 960)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
