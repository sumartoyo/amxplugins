#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN  "Recoil Control"
#define AUTHOR  "Dimas"
#define VERSION "1.0"

#define m_iId 43
#define m_flNextPrimaryAttack 46
#define m_iClip 51
#define m_flAccuracy 62
#define m_iShotsFired 64

#define MAX_PLAYERS 32



new const g_arrLen[] = {
    // less than 1 is don't change
    0, // none
    0, // p228 - p250
    0, // shield
    0, // scout
    0, // hegrenade
    0, // xm1014
    0, // c4
    30, // mac10
    30, // aug
    0, // smokegrenade
    0, // elite
    0, // fiveseven
    25, // ump45
    0, // sg550
    35, // galil
    25, // famas
    0, // usp - usp-s
    0, // glock18
    0, // awp
    30, // mp5navy - mp7
    0, // m249
    0, // m3
    30, // m4a1 - m4a1-s
    30, // tmp - mp9
    0, // g3sg1
    0, // flashbang
    0, // deagle
    30, // sg552 - sg553
    30, // ak47
    0, // knife
    50  // p90
};

new const Float:g_punchangle0[][] = {
    // empty is don't change
    {}, // none
    {}, // p228 - p250
    {}, // shield
    {}, // scout
    {}, // hegrenade
    {}, // xm1014
    {}, // c4
    // mac10
    { 0.000000, -0.081753, -0.187526, -0.354849, -0.726953, -1.192797, -1.856040, -2.430028, -2.906919, -3.169778, -3.475822, -3.783217, -3.985482, -4.101602, -4.186336, -4.194922, -4.022159, -4.004988, -3.905308, -3.903124, -3.947453, -3.908168, -3.885827, -3.887452, -3.925086, -4.050947, -3.998112, -4.033564, -3.871220, -3.842483 },
    // aug
    { 0.000000, -0.165588, -0.535397, -1.134735, -1.862706, -2.662352, -3.507801, -4.060405, -4.483507, -4.824318, -5.134736, -5.304872, -5.285844, -5.482863, -5.568949, -5.274109, -4.930611, -5.095915, -5.252280, -5.228025, -5.266760, -5.355096, -5.503236, -5.536396, -5.468423, -5.349895, -5.287744, -5.302975, -5.346668, -5.391277 },
    {}, // smokegrenade
    {}, // elite
    {}, // fiveseven
    // ump45
    { 0.000000, -0.181494, -0.405001, -0.889756, -1.497762, -2.129016, -2.846491, -3.326869, -3.650969, -4.014584, -4.244461, -4.363118, -4.459549, -4.631807, -4.781236, -4.691988, -4.630734, -4.770832, -4.832559, -4.770004, -4.614952, -4.554082, -4.616942, -4.586863, -4.549823 },
    {}, // sg550
    // galil
    { 0.000000, -0.125869, -0.241752, -0.537133, -0.931053, -1.523010, -2.205318, -2.671680, -2.921049, -3.294288, -3.547725, -3.435378, -3.122424, -3.303858, -3.388927, -3.391558, -3.420647, -3.628668, -3.821273, -3.908419, -3.816746, -3.595074, -3.661824, -3.765322, -3.707270, -3.790318, -3.678186, -3.716415, -3.543304, -3.465609, -3.622939, -3.851475, -3.762266, -3.376132, -3.347945 },
    // famas
    { 0.000000, -0.116329, -0.228827, -0.512848, -0.979464, -1.565390, -2.063587, -2.377013, -2.712087, -2.918434, -3.086560, -3.126125, -3.286533, -3.395910, -3.537202, -3.456504, -3.483115, -3.480804, -3.617266, -3.697027, -3.649376, -3.731901, -3.709863, -3.536162, -3.237467 },
    {}, // usp - usp-s
    {}, // glock18
    {}, // awp
    // mp5navy - mp7
    { 0.000000, -0.156248, -0.278124, -0.589434, -1.080034, -1.678287, -2.258764, -2.870402, -3.258712, -3.523305, -3.525887, -3.357803, -3.627570, -3.931228, -4.137799, -4.378673, -4.577409, -4.746277, -4.714613, -4.431808, -4.497797, -4.575720, -4.604500, -4.665196, -4.610739, -4.543156, -4.621927, -4.658962, -4.759414, -4.887044 },
    {}, // m249
    {}, // m3
    // m4a1 - m4a1-s
    { 0.000000, -0.178978, -0.435156, -0.885983, -1.472106, -2.123506, -2.852992, -3.279079, -3.627612, -3.762760, -4.062345, -4.224209, -4.106351, -4.099690, -3.944739, -4.044021, -4.190119, -4.206122, -4.119755, -4.180519, -4.184138, -4.364868, -4.432045, -4.489854, -4.499510, -4.624836, -4.727562, -4.744309, -4.728577, -4.696702 },
    // tmp - mp9
    { 0.000000, -0.156248, -0.278124, -0.589434, -1.080034, -1.678287, -2.258764, -2.870402, -3.258712, -3.523305, -3.525887, -3.357803, -3.627570, -3.931228, -4.137799, -4.378673, -4.577409, -4.746277, -4.714613, -4.431808, -4.497797, -4.575720, -4.604500, -4.665196, -4.610739, -4.543156, -4.621927, -4.658962, -4.759414, -4.887044 },
    {}, // g3sg1
    {}, // flashbang
    {}, // deagle
    // sg552 - sg553
    { 0.000000, -0.213488, -0.657973, -1.352485, -2.158564, -3.047446, -4.006340, -4.398540, -4.866623, -5.203034, -5.414694, -5.538290, -5.672207, -5.845618, -6.123461, -5.988493, -5.497851, -5.294631, -5.211980, -5.297750, -5.155894, -5.134150, -5.400588, -5.634273, -5.810045, -5.737368, -5.636505, -5.838338, -5.970711, -5.840220 },
    // ak47
    { 0.000000, -0.197870, -0.719329, -1.529447, -2.377753, -3.210966, -3.943496, -4.599689, -5.021466, -4.905911, -4.962037, -5.246210, -5.400700, -5.163791, -5.294562, -5.333237, -5.519639, -5.801235, -5.755366, -5.518396, -5.451219, -5.524665, -5.788029, -5.877129, -5.795238, -5.749043, -5.826416, -5.862424, -5.333301, -5.330507 },
    {}, // knife
    // p90
    { -0.000000, -0.099842, -0.214479, -0.358094, -0.677546, -1.093175, -1.426588, -1.901503, -2.294375, -2.663735, -2.980811, -3.302939, -3.503794, -3.508719, -3.599440, -3.666869, -3.665457, -3.712412, -3.754736, -3.785810, -3.822684, -3.796551, -3.708493, -3.695011, -3.724171, -3.828316, -3.801914, -3.679642, -3.696275,
        -3.782478, -3.810683, -3.867798, -3.930560, -3.919786, -3.903362, -3.935951, -3.949503, -3.919843, -3.868016, -3.927035, -3.920005, -3.802097, -3.764574, -3.750187, -3.659241, -3.682871, -3.587096, -3.662600, -3.752666, -3.709551 }
}

new const Float:g_punchangle1[][] = {
    // empty is don't change
    {}, // none
    {}, // p228 - p250
    {}, // shield
    {}, // scout
    {}, // hegrenade
    {}, // xm1014
    {}, // c4
    // mac10
    { 0.000000, -0.124005, -0.158706, -0.078687, 0.031151, 0.318079, 0.637084, 0.873808, 0.717144, 0.959687, 1.068298, 1.194060, 1.126325, 1.063811, 0.799005, 0.224799, -0.576198, -0.626502, -0.944641, -0.760862, -0.933702, -1.312546, -1.557767, -1.096623, -0.730220, -0.350729, 0.337992, 0.352850, -0.246357, -0.181414 },
    // aug
    { 0.000000, 0.124375, 0.129330, 0.002035, -0.195087, -0.038948, 0.190590, 0.572420, 0.762728, 1.124760, 0.685204, 0.545231, 0.921460, 0.945789, 0.304394, -0.710554, -1.584630, -1.678519, -1.830110, -2.053419, -1.383505, -0.506761, -0.084527, -0.229146, 0.232699, 1.020169, 1.641143, 1.129243, 0.648356, 0.557485 },
    {}, // smokegrenade
    {}, // elite
    {}, // fiveseven
    // ump45
    { 0.000000, -0.025041, -0.124856, -0.166556, -0.299741, -0.566099, -0.623911, -0.319042, -0.439359, -0.186376, 0.339420, 0.722943, 0.710025, 0.843281, 0.834288, 1.090470, 1.248281, 0.890247, 0.363346, 0.380541, 0.751487, 1.212389, 1.104895, 0.506322, 0.399306 },
    {}, // sg550
    // galil
    { 0.000000, 0.116261, 0.047507, 0.219702, 0.552648, 0.537699, 0.578969, 0.757632, 1.054671, 0.936994, 0.326535, -0.518259, -1.322699, -1.578922, -1.909685, -2.078151, -2.092437, -1.974022, -1.273228, -0.888385, -0.196081, 0.664785, 0.830395, 0.508295, 0.854564, 1.155808, 1.644343, 1.317144, 0.404932, -0.279245, -0.662835, -0.482194, -0.884217, -1.533135, -1.923467 },
    // famas
    { 0.000000, -0.105068, -0.079798, -0.261526, -0.283108, -0.270229, 0.119360, 0.560772, 0.380426, -0.157134, -0.628839, -0.991558, -0.852925, -0.212095, 0.111837, 0.658441, 0.821597, 1.231678, 1.322779, 1.199121, 0.497360, 0.427560, 0.723023, 1.137555, 1.575360 },
    {}, // usp - usp-s
    {}, // glock18
    {}, // awp
    // mp5navy - mp7
    { 0.000000, -0.017000, -0.095916, -0.007219, -0.050429, 0.223729, 0.186988, -0.035868, 0.258916, 0.842610, 1.460493, 2.169510, 2.143792, 2.167248, 1.517585, 1.150487, 0.646813, 0.255644, -0.331086, -1.167383, -1.024147, -0.565310, 0.012860, 0.096079, -0.389154, -1.066786, -1.314883, -1.592436, -1.316668, -1.174756 },
    {}, // m249
    {}, // m3
    // m4a1 - m4a1-s
    { 0.000000, 0.039103, 0.040588, -0.108996, 0.050801, -0.161304, -0.296306, 0.160125, 0.440147, 1.050651, 0.929271, 0.444584, -0.391508, -1.055712, -1.783371, -1.783912, -1.538369, -1.844440, -2.254493, -2.177089, -1.218916, -0.937080, -0.192055, 0.058471, 0.380991, 0.097899, 0.235538, 0.328582, 0.415631, 0.537707 },
    // tmp - mp9
    { 0.000000, -0.017000, -0.095916, -0.007219, -0.050429, 0.223729, 0.186988, -0.035868, 0.258916, 0.842610, 1.460493, 2.169510, 2.143792, 2.167248, 1.517585, 1.150487, 0.646813, 0.255644, -0.331086, -1.167383, -1.024147, -0.565310, 0.012860, 0.096079, -0.389154, -1.066786, -1.314883, -1.592436, -1.316668, -1.174756 },
    {}, // g3sg1
    {}, // flashbang
    {}, // deagle
    // sg552 - sg553
    { 0.000000, -0.097864, -0.473275, -0.703781, -0.895419, -1.110645, -1.304635, -1.852322, -1.461890, -1.696117, -2.137609, -2.266982, -2.104067, -2.315996, -2.265270, -2.652572, -3.201844, -3.680819, -3.904435, -2.785591, -1.212323, -0.014912, 0.476514, 0.887759, 1.047483, 1.652655, 2.430387, 2.250185, 1.877522, 0.787281 },
    // ak47
    { 0.000000, -0.102261, 0.006779, -0.071126, -0.093620, 0.259707, 0.461747, 0.839999, 0.382124, -0.788387, -1.410138, -1.046687, -1.486485, -2.201159, -2.283130, -1.172455, -0.644418, -0.250049, 0.503981, 1.429630, 0.857003, 1.027802, 0.847848, 0.603743, 1.132221, 1.289225, 0.736852, -0.187750, -1.460931, -1.863596 },
    {}, // knife
    // p90
    { 0.000000, -0.084604, -0.066131, -0.014793, -0.100715, -0.400796, -0.745061, -1.022798, -0.779173, -0.505276, -0.450025, -0.363592, -0.450063, -0.803576, -0.950215, -1.141126, -1.430235, -1.089844, -0.639256, -0.352484, -0.070202, 0.324782, 0.726855, 0.608352, 0.729776, 0.451704, -0.031353, -0.568324, -0.636112,
        -0.481452, -0.583160, -0.705857, -0.548222, -0.130325, 0.098939, -0.004534, -0.063867, -0.410388, -0.733785, -0.678482, -0.336089, 0.202963, 0.452909, 0.784609, 1.215684, 1.450961, 1.774760, 1.662900, 1.332376, 1.453853 }
}

/*
new const Float:g_punch0[] = {
    0.0, // none
    0.0, // p228 - p250
    0.0, // shield
    0.0, // scout
    0.0, // hegrenade
    0.0, // xm1014
    0.0, // c4
    -0.3, // mac10
    -0.625, // aug
    0.0, // smokegrenade
    0.0, // elite
    0.0, // fiveseven
    -0.275, // ump45
    0.0, // sg550
    -0.65, // galil
    -0.625, // famas
    0.0, // usp - usp-s
    0.0, // glock18
    0.0, // awp
    -0.25, // mp5navy - mp7
    0.0, // m249
    0.0, // m3
    -0.65, // m4a1 - m4a1-s
    -0.3, // tmp - mp9
    0.0, // g3sg1
    0.0, // flashbang
    0.0, // deagle
    -0.625, // sg552 - sg553
    -0.825, // ak47
    0.0, // knife
    -0.3  // p90
};
*/



new g_isContinue[MAX_PLAYERS];
new g_isHolding[MAX_PLAYERS];
new Float:g_lastTime[MAX_PLAYERS];
new Float:g_lastPunchangle[MAX_PLAYERS][3];
new Float:g_prevPunchangle[MAX_PLAYERS][3];



public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);

    new owner = 0;
    while (owner < MAX_PLAYERS) {
        g_isContinue[owner] = 0;
        g_isHolding[owner] = 0;
        g_lastTime[owner] = 0.0;
        copy2d(Float:{ 0.0, 0.0, 0.0 }, g_lastPunchangle[owner]);
        owner++;
    }

    new weaponid, weaponname[32];
    for (weaponid = 1; weaponid <= CSW_P90; weaponid++) {
        switch (g_arrLen[weaponid] > 0) {
            case 1: {
                get_weaponname(weaponid, weaponname, 31);
                RegisterHam(Ham_Weapon_PrimaryAttack, weaponname, "attack_pre", 0);
                RegisterHam(Ham_Weapon_PrimaryAttack, weaponname, "attack_post", 1);
            }
        }
    }
}



copy2d(const Float:src[], Float:dest[])
{
    dest[0] = src[0];
    dest[1] = src[1];
}

Float:calc_delta(const Float:arr[], const i, const j)
{
    return arr[i] - arr[j];
}

get_nShots(const Float:arr[], const len, const Float:punchangle0)
{
    new i = 0;
    while (i < len) {
        switch (punchangle0 >= arr[i]) {
            case 1: {
                return i;
            }
        }
        i++;
    }
    return i;
}



public attack_pre(const ent)
{
    static owner;
    owner = pev(ent, pev_owner);
    switch (is_user_bot(owner)) {
        case 0: {
            g_isContinue[owner] = 0;

            static weapon, arrLen;
            weapon = get_pdata_int(ent, m_iId, 4);
            arrLen = g_arrLen[weapon];
            switch (arrLen > 0) {
                case 1: {
                    static playerFlags, Float:velocity[3], Float:length;
                    playerFlags = pev(owner, pev_flags);
                    pev(owner, pev_velocity, velocity);
                    length = (velocity[0] * velocity[0]) + (velocity[1] * velocity[1]);
                    switch ((playerFlags & FL_ONGROUND) && length <= 6930.5625) {
                        case 1: { // on ground AND not more than crouch speed
                            switch (get_gametime() - g_lastTime[owner] >= 0.25) {
                                case 1: {
                                    set_pdata_float(ent, m_flAccuracy, 0.2, 4);
                                }
                                case 0: {
                                    switch (g_isHolding[owner]) {
                                        case 0: {
                                            set_pdata_float(ent, m_flAccuracy, 1.25, 4);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    pev(owner, pev_punchangle, g_lastPunchangle[owner]);
                    switch (g_isHolding[owner]) {
                        case 0: {
                            static nShots, a_nShots;
                            nShots = get_pdata_int(ent, m_iShotsFired, 4);
                            a_nShots = get_nShots(g_punchangle0[weapon], arrLen, g_lastPunchangle[owner][0]);
                            switch (a_nShots < nShots) {
                                case 1: {
                                    set_pdata_int(ent, m_iShotsFired, a_nShots, 4);
                                    //g_lastPunchangle[owner][1] *= 0.1;
                                }
                            }
                        }
                    }

                    g_isHolding[owner] = 1;
                    g_lastTime[owner] = get_gametime();
                    g_isContinue[owner] = get_pdata_int(ent, m_iClip, 4) > 0;
                }
            }
        }
    }
}

public attack_post(const ent)
{
    static owner;
    owner = pev(ent, pev_owner);
    switch (is_user_bot(owner)) {
        case 0: {
            switch (g_isContinue[owner]) {
                case 1: {
                    static weapon, nShots;
                    weapon = get_pdata_int(ent, m_iId, 4);
                    nShots = get_pdata_int(ent, m_iShotsFired, 4);

                    static Float:lastPunchangle[3];
                    copy2d(g_lastPunchangle[owner], lastPunchangle);
                    switch (nShots > g_arrLen[weapon] - 1) {
                        case 1: {}
                        default: {
                            lastPunchangle[0] += calc_delta(g_punchangle0[weapon], nShots, nShots - 1);
                            lastPunchangle[1] += calc_delta(g_punchangle1[weapon], nShots, nShots - 1);
                            copy2d(lastPunchangle, g_lastPunchangle[owner]);
                        }
                    }

                    /*
                    static Float:length, Float:grow, Float:factor;
                    length = floatsqroot((lastPunchangle[0] * lastPunchangle[0]) + (lastPunchangle[1] * lastPunchangle[1]));
                    grow = floatmin(0.2, (nShots - 1) * 0.02);
                    factor = (length + 0.4 + grow) / length;
                    */

                    static Float:punchangle[3];
                    //punchangle[0] = floatmin(g_punch0[weapon], lastPunchangle[0] * factor);
                    punchangle[0] = lastPunchangle[0] - 0.55;
                    punchangle[1] = lastPunchangle[1];
                    set_pev(owner, pev_punchangle, punchangle);
                }
            }
        }
    }
}

public client_PreThink(owner) {
    switch (is_user_bot(owner)) {
        case 0: {
            pev(owner, pev_punchangle, g_prevPunchangle[owner]);
        }
    }
}

public client_PostThink(owner) {
    switch (is_user_bot(owner)) {
        case 0: {
            static Float:punchangle[3], Float:prevPunchangle[3], Float:lastPunchangle[3];
            pev(owner, pev_punchangle, punchangle);
            copy2d(g_prevPunchangle[owner], prevPunchangle);
            copy2d(g_lastPunchangle[owner], lastPunchangle);

            if (prevPunchangle[0] <= lastPunchangle[0]) {
                static Float:delta0;
                delta0 = punchangle[0] - prevPunchangle[0];
                delta0 *= 0.5;
                punchangle[0] = delta0 + prevPunchangle[0];
                punchangle[1] = prevPunchangle[1];
            }

            switch (1 && pev(owner, pev_button) & IN_ATTACK) {
                case 1: {
                    switch (g_isContinue[owner]) {
                        case 1: {
                            switch (punchangle[0] > lastPunchangle[0]) {
                                case 1: {
                                    punchangle[0] = lastPunchangle[0];
                                }
                            }
                            punchangle[1] = lastPunchangle[1];
                        }
                    }
                }
                default: {
                    g_isContinue[owner] = 0;
                    g_isHolding[owner] = 0;
                }
            }

            set_pev(owner, pev_punchangle, punchangle);
        }
    }
}
