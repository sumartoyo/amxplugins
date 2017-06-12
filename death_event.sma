#include <amxmodx>
#include <hamsandwich>
#include <csx>

#define MAX_PLAYERS 32

new give_dmg[MAX_PLAYERS][MAX_PLAYERS];
new give_hit[MAX_PLAYERS][MAX_PLAYERS];

public plugin_init()
{
    register_plugin("Victim Tell", "1.0.0", "Dimas");
    RegisterHam(Ham_Spawn, "player", "spawnPlayer", 1);
}

public spawnPlayer(id) {
    static i;
    for (i = 0; i < MAX_PLAYERS; i++) {
        give_dmg[id][i] = 0;
        give_hit[id][i] = 0;
        give_dmg[i][id] = 0;
        give_hit[i][id] = 0;
    }
}

public client_damage(attacker, victim, damage, wpnindex, hitplace, TA)
{
    if (1 <= victim <= MAX_PLAYERS && 1 <= attacker <= MAX_PLAYERS && victim != attacker) {
        if (is_user_alive(attacker)) {
            give_dmg[attacker][victim] += damage;
            give_hit[attacker][victim] += 1;
        }
    }
}

public client_death(killer, victim, wpnindex, hitplace, TK)
{
    if (1 <= killer <= MAX_PLAYERS && 1 <= victim <= MAX_PLAYERS && killer != victim) {
        static isHs;
        isHs = hitplace == HIT_HEAD;

        if (!is_user_bot(killer)) {
            static victimName[32];
            get_user_name(victim, victimName, 31);
            // client_cmd(killer, "spk ^"%s^"", KILL_DING_SOUND);

            set_hudmessage(255, 255, 255, 0.8, 0.2, 0, 0.0, 0.1, 0.0, 3.9, 4);
            show_hudmessage(killer, "%s: %s^n%i in %i %s",
                isHs ? "HS" : "Dead",
                victimName,
                give_dmg[killer][victim],
                give_hit[killer][victim],
                give_hit[killer][victim] == 1 ? "hit" : "hits"
            );
        }

        if (!is_user_bot(victim)) {
            static killerName[32], weaponName[32];
            get_user_name(killer, killerName, 31);
            get_weaponname(wpnindex, weaponName, 31);

            set_hudmessage(255, 255, 255, -1.0, 0.6, 0, 0.0, 3.0, 0.0, 0.5, 3);
            show_hudmessage(victim, "%s | %s%s^nYou took %i in %i %s^nYou gave %i in %i %s",
                killerName,
                weaponName,
                isHs ? " (HS)" : "",
                give_dmg[killer][victim],
                give_hit[killer][victim],
                give_hit[killer][victim] == 1 ? "hit" : "hits",
                give_dmg[victim][killer],
                give_hit[victim][killer],
                give_hit[victim][killer] == 1 ? "hit" : "hits"
            );
        }
    }
}
