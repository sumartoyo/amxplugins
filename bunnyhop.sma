#include <amxmodx>
#include <engine>
#include <fakemeta>

#define	FL_ONGROUND	(1<<9)	// At rest / on the ground

#define MAX_PLAYERS 32

new g_jumping[MAX_PLAYERS];

public plugin_init() {
    register_plugin("Super Bunny Hopper", "1.2", "Dimas");

    new id = 0;
    while (id < MAX_PLAYERS) {
        g_jumping[id] = 0;
        id++;
    }
}

public client_PreThink(id) {
    switch (is_user_bot(id)) {
        case 0: {
            switch (1 && (entity_get_int(id, EV_INT_flags) & FL_ONGROUND)) {
                case 0: {
                    g_jumping[id] = 1;
                }
                case 1: {
                    switch (g_jumping[id]) {
                        case 1: {
                            g_jumping[id] = 0;
                            switch (entity_get_float(id, EV_FL_fuser2) > 0.0) {
                                case 1: {
                                    entity_set_float(id, EV_FL_fuser2, 300.0);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
