#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] =
{
	"npc/metropolice/die1.wav",
	"npc/metropolice/die2.wav",
	"npc/metropolice/die3.wav",
	"npc/metropolice/die4.wav"
};

static const char g_IdleSounds[][] =
{
	"npc/metropolice/vo/takecover.wav",
	"npc/metropolice/vo/readytojudge.wav",
	"npc/metropolice/vo/subject.wav",
	"npc/metropolice/vo/subjectis505.wav"
};


static const char g_MeleeHitSounds[][] = {
	"weapons/halloween_boss/knight_axe_hit.wav",
};

static const char g_MeleeAttackSounds[][] = {
	"weapons/demo_sword_swing1.wav",
	"weapons/demo_sword_swing2.wav",
	"weapons/demo_sword_swing3.wav",
};

static const char g_MeleeMissSounds[][] = {
	"weapons/cbar_miss1.wav",
};

static const char g_IdleAlertedSounds[][] =
{
	"npc/metropolice/vo/airwatchsubjectis505.wav",
	"npc/metropolice/vo/allunitscloseonsuspect.wav",
	"npc/metropolice/vo/allunitsmovein.wav",
	"npc/metropolice/vo/breakhiscover.wav",
	"npc/metropolice/vo/destroythatcover.wav"
};
static const char g_MeleeDeflectAttack[][] = {
	"weapons/samurai/tf_katana_impact_object_02.wav",
};

void Barracks_Combine_Parry_Precache()
{
	PrecacheSoundArray(g_DeathSounds);
	PrecacheSoundArray(g_IdleSounds);
	PrecacheSoundArray(g_MeleeHitSounds);
	PrecacheSoundArray(g_MeleeAttackSounds);
	PrecacheSoundArray(g_MeleeMissSounds);
	PrecacheSoundArray(g_IdleAlertedSounds);
	PrecacheSoundArray(g_MeleeDeflectAttack);
	
	
	NPCData data;
	strcopy(data.Name, sizeof(data.Name), "Barracks Deflector");
	strcopy(data.Plugin, sizeof(data.Plugin), "npc_barrack_combine_parry");
	data.IconCustom = false;
	data.Flags = 0;
	data.Category = Type_Ally;
	data.Func = ClotSummon;
	NPC_Add(data);
}

static any ClotSummon(int client, float vecPos[3], float vecAng[3], int ally)
{
	return Barrack_Combine_Parry(client, vecPos, vecAng, ally);
}

methodmap Barrack_Combine_Parry < BarrackBody
{
	public void PlayIdleSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		EmitSoundToAll(g_IdleSounds[GetRandomInt(0, sizeof(g_IdleSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(24.0, 48.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleSound()");
		#endif
	}
	
	public void PlayIdleAlertSound() {
		if(this.m_flNextIdleSound > GetGameTime(this.index))
			return;
		
		EmitSoundToAll(g_IdleAlertedSounds[GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		this.m_flNextIdleSound = GetGameTime(this.index) + GetRandomFloat(12.0, 24.0);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayIdleAlertSound()");
		#endif
	}
	
	public void PlayNPCDeath() {
	
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_VOICE, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		
		#if defined DEBUG_SOUND
		PrintToServer("CClot::PlayDeathSound()");
		#endif
	}
	
	public void PlayMeleeSound() {
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		

	}

	public void PlayMeleeHitSound() {
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		

	}
	public void PlayDeflectSound() 
	{
		EmitSoundToAll(g_MeleeDeflectAttack[GetRandomInt(0, sizeof(g_MeleeDeflectAttack) - 1)], this.index, _, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		EmitSoundToAll(g_MeleeDeflectAttack[GetRandomInt(0, sizeof(g_MeleeDeflectAttack) - 1)], this.index, _, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		
	}

	public void PlayMeleeMissSound() {
		EmitSoundToAll(g_MeleeMissSounds[GetRandomInt(0, sizeof(g_MeleeMissSounds) - 1)], this.index, SNDCHAN_STATIC, NORMAL_ZOMBIE_SOUNDLEVEL, _, NORMAL_ZOMBIE_VOLUME, 100);
		
		#if defined DEBUG_SOUND
		PrintToServer("CGoreFast::PlayMeleeMissSound()");
		#endif
	}

	public Barrack_Combine_Parry(int client, float vecPos[3], float vecAng[3], int ally)
	{
		Barrack_Combine_Parry npc = view_as<Barrack_Combine_Parry>(BarrackBody(client, vecPos, vecAng, "900", COMBINE_CUSTOM_MODEL, STEPTYPE_COMBINE,_,_,"models/pickups/pickup_powerup_strength_arm.mdl"));
		
		i_NpcWeight[npc.index] = 1;
		
		func_NPCOnTakeDamage[npc.index] = BarrackBody_OnTakeDamage;
		func_NPCDeath[npc.index] = Barrack_Combine_Parry_NPCDeath;
		func_NPCThink[npc.index] = Barrack_Combine_Parry_ClotThink;
		func_NPCOnTakeDamage[npc.index] = Barrack_Combine_Parry_OnTakeDamage;
		npc.m_flSpeed = 250.0;
		
		npc.m_flNextMeleeAttack = 0.0;
		npc.m_flAttackHappenswillhappen = false;
		npc.m_flAttackHappens_bullshit = 0.0;
		npc.m_flNextRangedAttack = 0.0;
		npc.m_fbRangedSpecialOn = true;

		KillFeed_SetKillIcon(npc.index, "sword");
		
		int skin = 1;

		npc.m_iWearable1 = npc.EquipItem("weapon_bone", "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl");
		SetVariantString("0.8");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		SetEntityRenderMode(npc.m_iWearable1, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable1, 100, 100, 100, 255);
		
		npc.m_iWearable2 = npc.EquipItem("head", "models/player/items/engineer/clockwerk_hat.mdl");
		SetVariantString("1.25");
		AcceptEntityInput(npc.m_iWearable2, "SetModelScale");
		SetEntityRenderMode(npc.m_iWearable2, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable2, 175, 175, 175, 255);
		SetEntProp(npc.m_iWearable2, Prop_Send, "m_nSkin", skin);
		
		SetEntityRenderMode(npc.index, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.index, 192, 192, 192, 255);
		
		return npc;
	}
}

public void Barrack_Combine_Parry_ClotThink(int iNPC)
{
	Barrack_Combine_Parry npc = view_as<Barrack_Combine_Parry>(iNPC);
	float GameTime = GetGameTime(iNPC);
	if(BarrackBody_ThinkStart(npc.index, GameTime))
	{
		int client = BarrackBody_ThinkTarget(npc.index, true, GameTime);

		if(npc.m_iTarget > 0)
		{
			npc.PlayIdleAlertSound();
			float vecTarget[3]; WorldSpaceCenter(npc.m_iTarget, vecTarget );
			float VecSelfNpc[3]; WorldSpaceCenter(npc.index, VecSelfNpc);
			float flDistanceToTarget = GetVectorDistance(vecTarget, VecSelfNpc, true);

			//Target close enough to hit
			if(flDistanceToTarget < NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED || npc.m_flAttackHappenswillhappen)
			{
				if(npc.m_fbRangedSpecialOn)
				{
					npc.AddGesture("ACT_SEABORN_DEFEND_TOOL_1");
					npc.m_flNextMeleeAttack = GameTime + 0.25;
					npc.m_fbRangedSpecialOn = false;
				}
				if(npc.m_flNextMeleeAttack < GameTime || npc.m_flAttackHappenswillhappen && !npc.m_fbRangedSpecialOn)
				{
					if(!npc.m_flAttackHappenswillhappen)
					{
						npc.AddGesture("ACT_MELEE_ATTACK_SWING_GESTURE");
						npc.PlaySwordSound();
						npc.m_flAttackHappens = GameTime + 0.3;
						npc.m_flAttackHappens_bullshit = GameTime + 0.44;
						npc.m_flNextMeleeAttack = GameTime + (1.25 * npc.BonusFireRate);
						npc.m_flAttackHappenswillhappen = true;
					}
					if(npc.m_flAttackHappens < GameTime && npc.m_flAttackHappens_bullshit >= GameTime && npc.m_flAttackHappenswillhappen && !npc.m_fbRangedSpecialOn)
					{
						Handle swingTrace;
						npc.FaceTowards(vecTarget, 20000.0);
						if(npc.DoSwingTrace(swingTrace, npc.m_iTarget))
						{
							int target = TR_GetEntityIndex(swingTrace);	
							
							float vecHit[3];
							TR_GetEndPosition(vecHit, swingTrace);
							
							if(target > 0) 
							{
								SDKHooks_TakeDamage(target, npc.index, client, Barracks_UnitExtraDamageCalc(npc.index, GetClientOfUserId(npc.OwnerUserId),6400.0, 0), DMG_CLUB, -1, _, vecHit);
								npc.PlaySwordHitSound();
							} 
						}
						delete swingTrace;
						npc.m_flAttackHappenswillhappen = false;
					}
					else if(npc.m_flAttackHappens_bullshit < GameTime && npc.m_flAttackHappenswillhappen)
					{
						npc.m_flAttackHappenswillhappen = false;
					}
				}
			}
		}
		else
		{
			npc.PlayIdleSound();
		}
		BarrackBody_ThinkMove(npc.index, 250.0, "ACT_IDLE", "ACT_COLOSUS_WALK");
	}
}

public Action Barrack_Combine_Parry_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	//Valid attackers only.
	if(attacker <= 0)
		return Plugin_Continue;
		
	Barrack_Combine_Parry npc = view_as<Barrack_Combine_Parry>(victim);
	
	if(npc.m_flNextRangedAttack < GetGameTime(npc.index))
	{
		if((damagetype & DMG_CLUB)) //Needs to be here because it already gets it from the top.
		{	
			npc.m_fbRangedSpecialOn = true;
			npc.m_flNextRangedAttack = GetGameTime(npc.index) + 2.0;
			damage *= 0.4;
			npc.PlayDeflectSound();
		}
	}

	
	/*
	if(attacker > MaxClients && !IsValidEnemy(npc.index, attacker))
		return Plugin_Continue;
	*/
	
	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}
	
	
	return Plugin_Changed;
}

void Barrack_Combine_Parry_NPCDeath(int entity)
{
	Barrack_Combine_Parry npc = view_as<Barrack_Combine_Parry>(entity);
	BarrackBody_NPCDeath(npc.index);
	npc.PlayNPCDeath();
}