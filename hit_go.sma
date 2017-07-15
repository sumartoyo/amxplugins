#include <amxmodx>
#include <fakemeta>
#include <hamsandwich>

new const Float:g_factors[][] = {
	// -1.0 is don't change
	// head, chest, stomach, leftarm, rightarm, leftleg, rightleg
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // none
	{1.39, 1.37, 1.38, 1.37, 1.37, 1.13, 1.13}, // p228 - p250
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // shield
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // scout
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // hegrenade
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // xm1014
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // c4
	{1.20, 1.23, 1.18, 1.23, 1.23, -1.0, -1.0}, // mac10
	{1.12, 1.14, 1.15, 1.14, 1.14, 0.91, 0.91}, // aug
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // smokegrenade
	{1.18, 1.17, 1.23, 1.17, 1.17, 1.08, 1.08}, // elite
	{2.02, 2.00, 2.06, 2.00, 2.00, 1.64, 1.64}, // fiveseven
	{1.53, 1.57, 1.56, 1.57, 1.57, 1.19, 1.19}, // ump45
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // sg550
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // galil
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // famas
	{1.06, 1.06, 1.05, 1.06, 1.06, 1.08, 1.08}, // usp - usp-s
	{1.02, 1.08, -1.0, 1.08, 1.08, 1.17, 1.17}, // glock18
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // awp
	{1.39, 1.42, 1.38, 1.42, 1.42, 1.11, 1.11}, // mp5navy - mp7
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // m249
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // m3
	{1.07, 1.10, 1.04, 1.10, 1.10, 1.04, 1.04}, // m4a1 - m4a1-s
	{1.60, 1.67, 1.90, 1.67, 1.67, 1.36, 1.36}, // tmp - mp9
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // g3sg1
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // flashbang
	{1.49, 1.49, 1.47, 1.49, 1.49, 1.18, 1.18}, // deagle
	{1.32, 1.36, 1.32, 1.36, 1.36, 0.91, 0.91}, // sg552 - sg553
	{-1.0, -1.0, 1.03, -1.0, -1.0, -1.0, -1.0}, // ak47
	{-1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0}, // knife
	{1.18, 1.13, 1.22, 1.13, 1.13, 1.27, 1.27} // p90
}

public plugin_init()
{
	register_plugin("Hit:GO", "1.0.0", "Dimas");
	RegisterHam(Ham_TraceAttack, "player", "HitGoTraceAttack", 0);
}

public HitGoTraceAttack(victim, attacker, Float:damage, Float:direction[3], tr, damagebits)
{
	static hitgroup;
	hitgroup = get_tr2(tr, TR_iHitgroup);
	if (hitgroup >= HIT_HEAD && hitgroup <= HIT_RIGHTLEG) {
		static weapon;
		weapon = get_user_weapon(attacker);
		switch (weapon) {
			case CSW_USP,
				CSW_GLOCK18,
				CSW_P228,
				CSW_ELITE,
				CSW_FIVESEVEN,
				CSW_DEAGLE,
				CSW_MP5NAVY,
				CSW_UMP45,
				CSW_MAC10,
				CSW_TMP,
				CSW_P90,
				CSW_AK47,
				CSW_M4A1,
				CSW_AUG,
				CSW_SG552
			: {
				static Float:factor;
				factor = g_factors[weapon][hitgroup];
				if (factor > 0.01) {
					SetHamParamFloat(3, damage * factor);
				}
			}
		}
	}
}
