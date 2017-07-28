#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <hamsandwich>

#define PLUGIN "Pain Shock Free"
#define AUTHOR "Dimas"
#define VERSION "0.0.1"

#define m_flPainShock 108

#define MAX_PLAYERS 32

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);
    RegisterHam(Ham_TakeDamage, "player", "TakeDamage_Post", 1);
}

public TakeDamage_Post(id, inflictor, attacker, Float:damage, bits)
{
    switch (is_user_bot(id)) {
        case 0: {
            switch (get_pdata_float(id, m_flPainShock, 5) < 1.0) {
                case 1: {
                    set_pev(id, pev_velocity, Float:{ 0.0, 0.0, 0.0 });
                    set_pdata_float(id, m_flPainShock, 1.0, 5);
                    entity_set_float(id, EV_FL_fuser2, 700.0);
                }
            }
        }
    }
}
