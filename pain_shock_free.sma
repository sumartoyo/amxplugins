#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN "Pain Shock Free"
#define AUTHOR "Dimas"
#define VERSION "0.0.1"

#define m_flPainShock 108

#define MAX_PLAYERS 32

new Float:g_velocity[MAX_PLAYERS][3];

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);
    RegisterHam(Ham_TakeDamage, "player", "TakeDamage_Pre", 0);
    RegisterHam(Ham_TakeDamage, "player", "TakeDamage_Post", 1);
}

public TakeDamage_Pre(id, inflictor, attacker, Float:damage, bits)
{
    pev(id, pev_velocity, g_velocity[id]);
}

public TakeDamage_Post(id, inflictor, attacker, Float:damage, bits)
{
    switch (!is_user_bot(id) && get_pdata_float(id, m_flPainShock, 5) < 1.0) {
        case 1: {
            g_velocity[id][0] = 0.0;
            g_velocity[id][1] = 0.0;
            set_pev(id, pev_velocity, g_velocity[id]);
            set_pdata_float(id, m_flPainShock, 0.9, 5);
            entity_set_float(id, EV_FL_fuser2, 699.0);
        }
    }
}
