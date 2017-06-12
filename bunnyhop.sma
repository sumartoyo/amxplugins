/*
 *
 *	Author:		Cheesy Peteza
 *	Date:		22-Apr-2004 (updated 2-March-2005)
 *
 *
 *	Description:	Enable bunny hopping in Counter-Strike.
 *
 *	Cvars:
 *			bh_enabled		1 to enable this plugin, 0 to disable.
 *			bh_autojump		If set to 1 players just need to hold down jump to bunny hop (no skill required)
 *			bh_showusage		If set to 1 it will inform joining players that bunny hopping has been enabled
 *						and how to use it if bh_autojump enabled.
 *
 *	Requirements:	AMXModX 0.16 or greater
 *
 *
 */

#include <amxmodx>
#include <engine>

#define	FL_WATERJUMP	(1<<11)	// player jumping out of water
#define	FL_ONGROUND	(1<<9)	// At rest / on the ground

/*
new g_flags;
new Float:g_velocity[3];
*/

public plugin_init() {
	register_plugin("Super Bunny Hopper", "1.2", "Cheesy Peteza");
}

public client_PreThink(id) {
    entity_set_float(id, EV_FL_fuser2, 0.0);

    /*
    if (entity_get_int(id, EV_INT_button) & 2) {    // If holding jump
        g_flags = entity_get_int(id, EV_INT_flags);

        if (!(g_flags & FL_ONGROUND))
            return;
        //if (g_flags & FL_WATERJUMP)
        //    return;
        //if (entity_get_int(id, EV_INT_waterlevel) >= 2)
        //    return;

        entity_get_vector(id, EV_VEC_velocity, g_velocity);
        g_velocity[2] += 250.0;
        entity_set_vector(id, EV_VEC_velocity, g_velocity);

        entity_set_int(id, EV_INT_gaitsequence, 6);  // Play the Jump Animation
    }
    */
}
