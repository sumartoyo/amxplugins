#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN "Pain Shock Free"
#define AUTHOR "Dimas"
#define VERSION "0.0.1"

#define m_flPainShock 108

#define MAX_PLAYERS 32

new Float:oldVelocity[MAX_PLAYERS][3]

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);
    RegisterHam(Ham_TakeDamage, "player", "TakeDamage_Pre", 0);
    RegisterHam(Ham_TakeDamage, "player", "TakeDamage_Post", 1);
}

public TakeDamage_Pre(id, inflictor, attacker, Float:damage, bits)
{
    pev(id, pev_velocity, oldVelocity[id]);
}

public TakeDamage_Post(id, inflictor, attacker, Float:damage, bits)
{
    static Float:painShock;
    painShock = get_pdata_float(id, m_flPainShock, 5);

    if (painShock < 1.0) {
        painShock = (1.0 + painShock) / 2.0;
        set_pdata_float(id, m_flPainShock, painShock, 5);

        static Float:velocity[3];
        pev(id, pev_velocity, velocity);
        velocity[0] = oldVelocity[id][0] * painShock;
        velocity[1] = oldVelocity[id][1] * painShock;
        set_pev(id, pev_velocity, velocity);
    }
}
