#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>
#include <xs>

#define PLUGIN  "Recoil Control"
#define AUTHOR  "OT"
#define VERSION "1.5"

#define m_pPlayer 41
#define m_flAccuracy 62
#define m_iShotsFired 64
#define m_flDecreaseShotsFired 76

#define MAX_PLAYERS 32

new Float:oldPunchangle[MAX_PLAYERS][3];

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_ak47", "attack_020", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_aug", "attack_020", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_famas", "attack_020", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_galil", "attack_020", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_m249", "attack_020", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_m4a1", "attack_020", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_sg552", "attack_020", 0);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_mac10", "attack_015", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_p90", "attack_020", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_tmp", "attack_020", 0);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_mp5navy", "attack_000", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_ump45", "attack_000", 0);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_deagle", "attack_090", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_elite", "attack_088", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_fiveseven", "attack_092", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_glock18", "attack_090", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_p228", "attack_090", 0);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_usp", "attack_092", 0);

    /* ================ */

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_ak47", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_aug", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_famas", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_galil", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_m249", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_m4a1", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_sg552", "attack_post", 1);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_mac10", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_p90", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_tmp", "attack_post", 1);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_mp5navy", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_ump45", "attack_post", 1);

    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_deagle", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_elite", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_fiveseven", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_glock18", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_p228", "attack_post", 1);
    RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_usp", "attack_post", 1);

    /* ================ */

    RegisterHam(Ham_Item_PostFrame, "weapon_ak47", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_aug", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_famas", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_galil", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_m249", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_m4a1", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_sg552", "postframe_pre", 0);

    RegisterHam(Ham_Item_PostFrame, "weapon_mac10", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_p90", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_tmp", "postframe_pre", 0);

    RegisterHam(Ham_Item_PostFrame, "weapon_mp5navy", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_ump45", "postframe_pre", 0);

    RegisterHam(Ham_Item_PostFrame, "weapon_deagle", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_elite", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_fiveseven", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_glock18", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_p228", "postframe_pre", 0);
    RegisterHam(Ham_Item_PostFrame, "weapon_usp", "postframe_pre", 0);
}

accurating(const ent, const Float:accuracy)
{
    static owner;
    owner = pev(ent, pev_owner);
    pev(owner, pev_punchangle, oldPunchangle[owner]);

    static playerFlags, Float:velocity[3], Float:length2d;
    playerFlags = pev(owner, pev_flags);
    pev(owner, pev_velocity, velocity);
    length2d = (velocity[0] * velocity[0]) + (velocity[1] * velocity[1]);

    if (!(playerFlags & FL_ONGROUND)) {
    } else if (length2d > 19600) {
    } else {
        set_pdata_float(ent, m_flAccuracy, accuracy, 4);
    }

    /*
    // first shot accuracy
    static nShots;
    nShots = get_pdata_int(ent, m_iShotsFired, 4);
    if (nShots == 0) {
        set_pdata_float(ent, m_flAccuracy, accuracy, 4);
    }
    */
}

public attack_post(ent)
{
    static owner, nShots, Float:punchangle2[3];
    owner = pev(ent, pev_owner);
    nShots = get_pdata_int(ent, m_iShotsFired, 4);
    pev(owner, pev_punchangle, punchangle2);

    if (4 <= nShots <= 10) {
        punchangle2[0] -= oldPunchangle[owner][0];
        punchangle2[0] *= 0.85;
        punchangle2[0] += oldPunchangle[owner][0];
    }
    if (1 <= nShots <= 10) {
        punchangle2[1] -= oldPunchangle[owner][1];
        punchangle2[1] *= 0.1;
        punchangle2[1] += oldPunchangle[owner][1];
    }
    set_pev(owner, pev_punchangle, punchangle2);

    /*
    static nShots;
    nShots = get_pdata_int(ent, m_iShotsFired, 4);
    if (nShots < 30) {
        static owner, Float:punchangle2[3];
        owner = pev(ent, pev_owner);
        pev(owner, pev_punchangle, punchangle2);

        xs_vec_sub(punchangle2, oldPunchangle[owner], punchangle2);
        xs_vec_mul_scalar(punchangle2, 0.9, punchangle2);
        xs_vec_add(punchangle2, oldPunchangle[owner], punchangle2);
        set_pev(owner, pev_punchangle, punchangle2);
    } else if (2 < nShots <= 5) {
        static owner, Float:punchangle2[3];
        owner = pev(ent, pev_owner);
        pev(owner, pev_punchangle, punchangle2);

        punchangle2[1] *= 0.5; // move side
        set_pev(owner, pev_punchangle, punchangle2);
    }
    */
}

public attack_020(ent)
{
    accurating(ent, 0.001);

    // bot stand still when using rifles
    static player;
    player = get_pdata_cbase(ent, m_pPlayer, 4);
    if (is_user_bot(player)) {
        if (pev(player, pev_flags) & FL_ONGROUND) {
            static Float:velocity[3];
            pev(player, pev_velocity, velocity);
            velocity[0] = 0.0;
            velocity[1] = 0.0;
            set_pev(player, pev_velocity, velocity);
        }
    }
}

public attack_090(ent)
{
    accurating(ent, 0.999);
}

public attack_000(ent)
{
    accurating(ent, 0.00);
}

public attack_092(ent)
{
    accurating(ent, 0.999);
}

public attack_015(ent)
{
    accurating(ent, 0.001);
}

public attack_088(ent)
{
    accurating(ent, 0.999);
}

public postframe_pre(ent)
{
    if (!(pev(get_pdata_cbase(ent, m_pPlayer, 4), pev_button) & IN_ATTACK)) {
        static Float:decrease, Float:gametime, Float:delay;
        decrease = get_pdata_float(ent, m_flDecreaseShotsFired, 4);
        gametime = get_gametime();
        delay = decrease - gametime;

        // CS:GO reset shots count after decreased
        //if (delay < 0.015625) { // 1 fps of 64 tic lag compensation
        if (delay < 0) { // 1 fps of 64 tic lag compensation
            set_pdata_int(ent, m_iShotsFired, 0, 4);
        }
    }
}
