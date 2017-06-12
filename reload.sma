#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN "Reload Speed"
#define AUTHOR "ConnorMcLeod"
#define VERSION "0.2.0"

#define m_pPlayer 41
#define m_iId 43
#define m_fInReload 54
#define m_flNextAttack 83

#define n_weapons 8
new const g_weapons[n_weapons] = {
    CSW_USP, CSW_FIVESEVEN, CSW_DEAGLE,
    CSW_MP5NAVY, CSW_UMP45,
    CSW_M4A1, CSW_AK47,
    CSW_AWP
}

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)

    new szWeapon[17]
    for (new i = 0; i < n_weapons; i++) {
        get_weaponname(g_weapons[i], szWeapon, charsmax(szWeapon))
        RegisterHam(Ham_Item_PostFrame, szWeapon, "Item_PostFrame_Post", 1)
    }
}

public Item_PostFrame_Post(iEnt)
{
    if (get_pdata_int(iEnt, m_fInReload, 4)) {
        // delay as with model animation
        static Float:delay
        switch (get_pdata_int(iEnt, m_iId, 4)) {
            case CSW_USP: delay = 2.51
            case CSW_FIVESEVEN: delay = 2.6
            case CSW_DEAGLE: delay = 1.73
            case CSW_MP5NAVY: delay = 2.26
            case CSW_UMP45: delay = 2.76
            case CSW_M4A1: delay = 2.6
            case CSW_AK47: delay = 1.85
            case CSW_AWP: delay = 2.2
        }
        set_pdata_float(get_pdata_cbase(iEnt, m_pPlayer, 4), m_flNextAttack, delay, 5)
    }
}
