pragma circom 2.1.4;

template Sigma() {
    signal input in;
    signal output out;

    signal in2;
    signal in4;

    in2 <== in*in;
    in4 <== in2*in2;

    out <== in4*in;
}

template Ark(t, C) {
    signal input in[t];
    signal output out[t];
    for (var i=0; i<t; i++) {
        out[i] <== in[i] + C;
    }
}

template Mix(t, M) {
    signal input in[t];
    signal output out[t];
    var lc;

    var i;
    var j;

    for (i=0; i<t; i++) {
        lc = 0;
        for (j=0; j<t; j++) {
            lc = lc + M[i][j]*in[j];
        }
        out[i] <== lc;
    }
}

//    var nRoundsF = 8;
//    var nRoundsP = 57;
//    var t = 6;

template Poseidon(nInputs, t, nRoundsF, nRoundsP) {

    var C[65] = [
        14397397413755236225575615486459253198602422701513067526754101844196324375522,
        10405129301473404666785234951972711717481302463898292859783056520670200613128,
        5179144822360023508491245509308555580251733042407187134628755730783052214509,
        9132640374240188374542843306219594180154739721841249568925550236430986592615,
        20360807315276763881209958738450444293273549928693737723235350358403012458514,
        17933600965499023212689924809448543050840131883187652471064418452962948061619,
        3636213416533737411392076250708419981662897009810345015164671602334517041153,
        2008540005368330234524962342006691994500273283000229509835662097352946198608,
        16018407964853379535338740313053768402596521780991140819786560130595652651567,
        20653139667070586705378398435856186172195806027708437373983929336015162186471,
        17887713874711369695406927657694993484804203950786446055999405564652412116765,
        4852706232225925756777361208698488277369799648067343227630786518486608711772,
        8969172011633935669771678412400911310465619639756845342775631896478908389850,
        20570199545627577691240476121888846460936245025392381957866134167601058684375,
        16442329894745639881165035015179028112772410105963688121820543219662832524136,
        20060625627350485876280451423010593928172611031611836167979515653463693899374,
        16637282689940520290130302519163090147511023430395200895953984829546679599107,
        15599196921909732993082127725908821049411366914683565306060493533569088698214,
        16894591341213863947423904025624185991098788054337051624251730868231322135455,
        1197934381747032348421303489683932612752526046745577259575778515005162320212,
        6172482022646932735745595886795230725225293469762393889050804649558459236626,
        21004037394166516054140386756510609698837211370585899203851827276330669555417,
        15262034989144652068456967541137853724140836132717012646544737680069032573006,
        15017690682054366744270630371095785995296470601172793770224691982518041139766,
        15159744167842240513848638419303545693472533086570469712794583342699782519832,
        11178069035565459212220861899558526502477231302924961773582350246646450941231,
        21154888769130549957415912997229564077486639529994598560737238811887296922114,
        20162517328110570500010831422938033120419484532231241180224283481905744633719,
        2777362604871784250419758188173029886707024739806641263170345377816177052018,
        15732290486829619144634131656503993123618032247178179298922551820261215487562,
        6024433414579583476444635447152826813568595303270846875177844482142230009826,
        17677827682004946431939402157761289497221048154630238117709539216286149983245,
        10716307389353583413755237303156291454109852751296156900963208377067748518748,
        14925386988604173087143546225719076187055229908444910452781922028996524347508,
        8940878636401797005293482068100797531020505636124892198091491586778667442523,
        18911747154199663060505302806894425160044925686870165583944475880789706164410,
        8821532432394939099312235292271438180996556457308429936910969094255825456935,
        20632576502437623790366878538516326728436616723089049415538037018093616927643,
        71447649211767888770311304010816315780740050029903404046389165015534756512,
        2781996465394730190470582631099299305677291329609718650018200531245670229393,
        12441376330954323535872906380510501637773629931719508864016287320488688345525,
        2558302139544901035700544058046419714227464650146159803703499681139469546006,
        10087036781939179132584550273563255199577525914374285705149349445480649057058,
        4267692623754666261749551533667592242661271409704769363166965280715887854739,
        4945579503584457514844595640661884835097077318604083061152997449742124905548,
        17742335354489274412669987990603079185096280484072783973732137326144230832311,
        6266270088302506215402996795500854910256503071464802875821837403486057988208,
        2716062168542520412498610856550519519760063668165561277991771577403400784706,
        19118392018538203167410421493487769944462015419023083813301166096764262134232,
        9386595745626044000666050847309903206827901310677406022353307960932745699524,
        9121640807890366356465620448383131419933298563527245687958865317869840082266,
        3078975275808111706229899605611544294904276390490742680006005661017864583210,
        7157404299437167354719786626667769956233708887934477609633504801472827442743,
        14056248655941725362944552761799461694550787028230120190862133165195793034373,
        14124396743304355958915937804966111851843703158171757752158388556919187839849,
        11851254356749068692552943732920045260402277343008629727465773766468466181076,
        9799099446406796696742256539758943483211846559715874347178722060519817626047,
        10156146186214948683880719664738535455146137901666656566575307300522957959544,
        19908645952733301583346063785055921934459499091029406575311417879963332475861,
        11766105336238068471342414351862472329437473380853789942065610694000443387471,
        11002137593249972174092192767251572171769044073555430468487809799220351297047,
        284136377911685911941431040940403846843630064858778505937392780738953624163,
        19448733709802908339787967270452055364068697565906862913410983275341804035680,
        14423660424692802524250720264041003098290275890428483723270346403986712981505,
        10635360132728137321700090133109897687122647659471659996419791842933639708516
    ];

    var M[6][6] = [
        [
            19167410339349846567561662441069598364702008768579734801591448511131028229281,
            14183033936038168803360723133013092560869148726790180682363054735190196956789,
            9067734253445064890734144122526450279189023719890032859456830213166173619761,
            16378664841697311562845443097199265623838619398287411428110917414833007677155,
            12968540216479938138647596899147650021419273189336843725176422194136033835172,
            3636162562566338420490575570584278737093584021456168183289112789616069756675
        ],[
            17034139127218860091985397764514160131253018178110701196935786874261236172431,
            2799255644797227968811798608332314218966179365168250111693473252876996230317,
            2482058150180648511543788012634934806465808146786082148795902594096349483974,
            16563522740626180338295201738437974404892092704059676533096069531044355099628,
            10468644849657689537028565510142839489302836569811003546969773105463051947124,
            3328913364598498171733622353010907641674136720305714432354138807013088636408
        ],[
            18985203040268814769637347880759846911264240088034262814847924884273017355969,
            8652975463545710606098548415650457376967119951977109072274595329619335974180,
            970943815872417895015626519859542525373809485973005165410533315057253476903,
            19406667490568134101658669326517700199745817783746545889094238643063688871948,
            17049854690034965250221386317058877242629221002521630573756355118745574274967,
            4964394613021008685803675656098849539153699842663541444414978877928878266244
        ],[
            19025623051770008118343718096455821045904242602531062247152770448380880817517,
            9077319817220936628089890431129759976815127354480867310384708941479362824016,
            4770370314098695913091200576539533727214143013236894216582648993741910829490,
            4298564056297802123194408918029088169104276109138370115401819933600955259473,
            6905514380186323693285869145872115273350947784558995755916362330070690839131,
            4783343257810358393326889022942241108539824540285247795235499223017138301952
        ],[
            16205238342129310687768799056463408647672389183328001070715567975181364448609,
            8303849270045876854140023508764676765932043944545416856530551331270859502246,
            20218246699596954048529384569730026273241102596326201163062133863539137060414,
            1712845821388089905746651754894206522004527237615042226559791118162382909269,
            13001155522144542028910638547179410124467185319212645031214919884423841839406,
            16037892369576300958623292723740289861626299352695838577330319504984091062115
        ],[
            15162889384227198851506890526431746552868519326873025085114621698588781611738,
            13272957914179340594010910867091459756043436017766464331915862093201960540910,
            9416416589114508529880440146952102328470363729880726115521103179442988482948,
            8035240799672199706102747147502951589635001418759394863664434079699838251138,
            21642389080762222565487157652540372010968704000567605990102641816691459811717,
            20261355950827657195644012399234591122288573679402601053407151083849785332516
        ]
    ];


    signal input inputs[nInputs];
    signal output out;

    component ark[nRoundsF + nRoundsP];
    component sigmaF[nRoundsF][t];
    component sigmaP[nRoundsP];
    component mix[nRoundsF + nRoundsP];

    var i;
    var j;
    var k;

    for (i=0; i<(nRoundsF + nRoundsP); i++) {
        ark[i] = Ark(t, C[i]);
        mix[i] = Mix(t, M);

        for (j=0; j<t; j++) {
            if (i==0) {
                if (j<nInputs) {
                    ark[i].in[j] <== inputs[j];
                } else {
                    ark[i].in[j] <== 0;
                }
            } else {
                ark[i].in[j] <== mix[i-1].out[j];
            }
        }

        if ((i<(nRoundsF/2)) || (i>= (nRoundsP + nRoundsF/2))) {
            k= i<nRoundsF/2 ? i : (i-nRoundsP);
            for (j=0; j<t; j++) {
                sigmaF[k][j] = Sigma();
                sigmaF[k][j].in <== ark[i].out[j];
                mix[i].in[j] <== sigmaF[k][j].out;
            }
        } else {
            k= i-nRoundsF/2;
            sigmaP[k] = Sigma();
            sigmaP[k].in <== ark[i].out[0];
            mix[i].in[0] <== sigmaP[k].out;
            for (j=1; j<t; j++) {
                mix[i].in[j] <== ark[i].out[j];
            }
        }
    }

    out <== mix[nRoundsF + nRoundsP -1].out[0];
}
