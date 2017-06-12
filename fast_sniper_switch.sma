/**
 *
 * Fast Sniper Switch (Awp Fast Switch)
 *  by Numb
 *
 *
 * Description:
 *  This plugins brings back the old feature from CS1.5 times.
 *  You were able to shoot a bullet with awp or scout, switch to
 *  knife or any other weapon really fast, and then switch back again.
 *  In result you get that you can fire your next bullet faster than
 *  if you would have waited for original bullet 'reload'.
 *
 *
 * Requires:
 *  FakeMeta
 *  HamSandWich
 *
 *
 * Additional Info:
 *  Tested in Counter-Strike 1.6 with amxmodx 1.8.2 (dev build hg21).
 *
 *
 * ChangeLog:
 *
 *  + 1.3
 *  - Added: Notification that plugin is active on the server.
 *  - Changed: Code now has original pdata offset names.
 *
 *  + 1.2
 *  - Cahnged: Plugin uses less resources.
 *
 *  + 1.1
 *  - Changed: Support for quake-style-switch plugin no longer needed (removed).
 *
 *  + 1.0
 *  - First release.
 *
 *
 * Downloads:
 *  Amx Mod X forums: http://forums.alliedmods.net/showthread.php?p=1193990#post1193990
 *
**/

// ----------------------------------------- CONFIG START -----------------------------------------

// Delay for awp fast switch (in cs1.5 it was 0.75 like any other weapon)
#define AWP_SWITCH_DELAY 0.75 // default: 0.75

// Delay for scout fast switch (in cs1.5 it was 0.75 like any other weapon)
#define SCOUT_SWITCH_DELAY 0.75 // default: 0.75

// Comment next line if you don't want people to be notified about the plugin
//#define PLUGIN_NOTIFICATION // default: uncommented

// ------------------------------------------ CONFIG END ------------------------------------------

#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN_NAME "Fast Sniper Switch"
#define PLUGIN_VERSION  "1.3"
#define PLUGIN_AUTHOR   "Numb"

#define m_pPlayer               41  // (weapon_*) owner entity
#define m_iId                   43  // (weapon_*) type of weapon CSW_
#define m_flNextPrimaryAttack   46  // (weapon_*) next prim attack
#define m_flNextSecondaryAttack 47  // (weapon_*) next sec attack
#define m_flDecreaseShotsFired  76  // (weapon_*) ??? right after Deploy has same value as get_gametime()
#define m_flNextAttack          83  // (player) next attack
#define m_pActiveItem           373 // (player) active weapon

public plugin_init()
{
    register_plugin(PLUGIN_NAME, PLUGIN_VERSION, PLUGIN_AUTHOR);

    RegisterHam(Ham_Item_Deploy, "weapon_awp",   "Ham_Item_Deploy_Post", 1);
    RegisterHam(Ham_Item_Deploy, "weapon_scout", "Ham_Item_Deploy_Post", 1);

#if defined PLUGIN_NOTIFICATION
    register_event("WeapPickup", "Event_WeapPickup", "be", "1=18"); // CSW_AWP
    register_event("WeapPickup", "Event_WeapPickup", "be", "1=3");  // CSW_SCOUT
#endif
}

#if defined PLUGIN_NOTIFICATION
public Event_WeapPickup(iPlrId)
    client_print(iPlrId, print_center, "%s%cis active", PLUGIN_NAME, 13);
#endif

public Ham_Item_Deploy_Post(iEnt)
{
    if( !pev_valid(iEnt) )
        return;

    static iPlrId;
    iPlrId = get_pdata_cbase(iEnt, m_pPlayer, 4);
    if( !is_user_alive(iPlrId) )
        return;

    if( iEnt!=get_pdata_cbase(iPlrId, m_pActiveItem, 5) || get_pdata_float(iEnt, m_flDecreaseShotsFired, 4)!=get_gametime() )
        return;

    switch( get_pdata_int(iEnt, m_iId, 4) )
    {
        case CSW_AWP:
        {
            set_pdata_float(iEnt, m_flNextPrimaryAttack, AWP_SWITCH_DELAY, 4);
            set_pdata_float(iEnt, m_flNextSecondaryAttack, AWP_SWITCH_DELAY, 4);
            set_pdata_float(iPlrId, m_flNextAttack, AWP_SWITCH_DELAY, 5);
        }
        case CSW_SCOUT:
        {
            set_pdata_float(iEnt, m_flNextPrimaryAttack, SCOUT_SWITCH_DELAY, 4);
            set_pdata_float(iEnt, m_flNextSecondaryAttack, SCOUT_SWITCH_DELAY, 4);
            set_pdata_float(iPlrId, m_flNextAttack, SCOUT_SWITCH_DELAY, 5);
        }
    }
}
