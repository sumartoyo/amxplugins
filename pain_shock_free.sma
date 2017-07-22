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
    if (!is_user_bot(id)) {
        pev(id, pev_velocity, oldVelocity[id]);
    }
}

public TakeDamage_Post(id, inflictor, attacker, Float:damage, bits)
{
    if (!is_user_bot(id)) {
        static Float:painShock;
        painShock = get_pdata_float(id, m_flPainShock, 5);

        if (painShock < 1.0) {
            set_pdata_float(id, m_flPainShock, floatmin(0.9, painShock + 0.1), 5);

            static Float:velocity[3];
            pev(id, pev_velocity, velocity);
            velocity[0] = floatmin(100.0 * painShock, oldVelocity[id][0]);
            velocity[1] = floatmin(100.0 * painShock, oldVelocity[id][1]);
            set_pev(id, pev_velocity, velocity);
        }
    }
}
