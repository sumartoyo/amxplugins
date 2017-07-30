#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <fun>

#define PLUGIN  "Speed CS:GO"
#define AUTHOR  "Dimas"
#define VERSION "1.0"

#define MAX_PLAYERS 32
#define MAX_WEAPONS CSW_P90

#define XO_WEAPON 4
#define m_pPlayer 41
#define m_iId 43
#define m_iClip 51

#define XO_PLAYER 5
#define m_bResumeZoom 110
#define m_iFOV 363
#define OFFSET_SHIELD 510
#define HAS_SHIELD  (1<<24)
#define USES_SHIELD  (1<<16)
const HAS_AND_USES_SHIELD = HAS_SHIELD|USES_SHIELD

#define SHIELD_WEAPONS_BITSUM ((1<<CSW_P228)|(1<<CSW_HEGRENADE)|(1<<CSW_SMOKEGRENADE)|(1<<CSW_FIVESEVEN)|(1<<CSW_USP)|(1<<CSW_GLOCK18)|(1<<CSW_FLASHBANG)|(1<<CSW_DEAGLE)|(1<<CSW_KNIFE))

enum _:MaxSpeedType {
    Float:DefaultMaxSpeed,
    Float:ZoomedMaxSpeed,
    Float:ShieldMaxSpeed
}

new const Float:g_speedDefault[] = {
    250.0, // none
    240.0, // p228 - p250
    250.0, // shield
    230.0, // scout
    245.0, // hegrenade
    215.0, // xm1014
    250.0, // c4
    240.0, // mac10
    220.0, // aug
    245.0, // smokegrenade
    240.0, // elite
    240.0, // fiveseven
    230.0, // ump45
    215.0, // sg550 - scar20
    215.0, // galil
    220.0, // famas
    240.0, // usp - usp-s
    240.0, // glock18
    200.0, // awp
    220.0, // mp5navy - mp7
    195.0, // m249
    220.0, // m3
    225.0, // m4a1 - m4a1-s
    240.0, // tmp - mp9
    215.0, // g3sg1
    245.0, // flashbang
    230.0, // deagle
    210.0, // sg552 - sg553
    215.0, // ak47
    250.0, // knife
    230.0  // p90
};

new const Float:g_speedScoped[] = {
    250.0, // none
    240.0, // p228 - p250
    250.0, // shield
    230.0, // scout
    245.0, // hegrenade
    215.0, // xm1014
    250.0, // c4
    240.0, // mac10
    150.0, // aug
    245.0, // smokegrenade
    240.0, // elite
    240.0, // fiveseven
    230.0, // ump45
    120.0, // sg550 - scar20
    215.0, // galil
    220.0, // famas
    240.0, // usp - usp-s
    240.0, // glock18
    100.0, // awp
    220.0, // mp5navy - mp7
    195.0, // m249
    220.0, // m3
    225.0, // m4a1 - m4a1-s
    240.0, // tmp - mp9
    120.0, // g3sg1
    245.0, // flashbang
    230.0, // deagle
    150.0, // sg552 - sg553
    215.0, // ak47
    250.0, // knife
    230.0  // p90
};

new g_bResumeZoom[MAX_PLAYERS];


public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);

    new i = 0;
    while (i < MAX_PLAYERS) {
        g_bResumeZoom[i] = 0;
        i++;
    }

    new weaponid, weaponname[32];
    for (weaponid = 1; weaponid <= CSW_P90; weaponid++) {
        switch (weaponid != 2) {
            case 1: {
                get_weaponname(weaponid, weaponname, 31);
                RegisterHam(Ham_CS_Item_GetMaxSpeed, weaponname, "Item_GetMaxSpeed");
            }
        }
    }

    RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_aug", "Item_ChangeZoom", 1);
    RegisterHam(Ham_Weapon_SecondaryAttack, "weapon_sg552", "Item_ChangeZoom", 1);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_awp", "AWP_AfterShot", 1);
    RegisterHam(Ham_Item_PostFrame, "weapon_awp", "AWP_PostFramePre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_awp", "AWP_PostFramePost", 1);
}

public Item_GetMaxSpeed(ent) {
    static owner, weapon;
    owner = pev(ent, pev_owner);
    weapon = get_pdata_int(ent, m_iId, XO_WEAPON);
    switch (pev(owner, pev_fov) != 90 && pev(owner, pev_fov) != 0) {
        case 1: {
            SetHamReturnFloat(g_speedScoped[weapon]);
        }
        default: {
            SetHamReturnFloat(g_speedDefault[weapon]);
        }
    }
    return HAM_SUPERCEDE;
}

public Item_ChangeZoom(ent) {
    static owner, weapon;
    owner = pev(ent, pev_owner);
    weapon = get_pdata_int(ent, m_iId, XO_WEAPON);
    switch (pev(owner, pev_fov) != 90) {
        case 1: {
            set_pev(owner, pev_maxspeed, g_speedScoped[weapon]);
        }
        default: {
            set_pev(owner, pev_maxspeed, g_speedDefault[weapon]);
        }
    }
}

public AWP_AfterShot(ent) {
    static owner;
    owner = pev(ent, pev_owner);
    set_pev(owner, pev_maxspeed, g_speedDefault[CSW_AWP]);
}

public AWP_PostFramePre(ent) {
    static owner;
    owner = pev(ent, pev_owner);
    g_bResumeZoom[owner] = get_pdata_int(owner, m_bResumeZoom, 5);
}

public AWP_PostFramePost(ent) {
    static owner;
    owner = pev(ent, pev_owner);
    switch (g_bResumeZoom[owner] && !get_pdata_int(owner, m_bResumeZoom, 5) && get_pdata_int(ent, m_iClip, 4) > 0) {
        case 1: {
            set_pev(owner, pev_maxspeed, g_speedScoped[CSW_AWP]);
        }
    }
}
