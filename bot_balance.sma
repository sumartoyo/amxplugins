#include <amxmodx>
#include <cstrike>
#include <csx>

public plugin_init()
{
    register_plugin("Bot Balance", "1.0.0", "Dimas");
}

public client_death(killer, victim, wpnindex, hitplace, TK)
{
    if (is_user_bot(victim)) {
        static n_ts, n_cts, players[32]
        get_players(players, n_ts, "e", "TERRORIST")
        get_players(players, n_cts, "e", "CT")

        static diff
        diff = n_ts - n_cts
        if (diff > 1) { // more Ts than CTs
            if (cs_get_user_team(victim) == CS_TEAM_T) {
                cs_set_user_team(victim, CS_TEAM_CT)
            }
        } else if (diff < -1) { // // more CTs than Ts
            if (cs_get_user_team(victim) == CS_TEAM_CT) {
                cs_set_user_team(victim, CS_TEAM_T)
            }
        }
    }
}
