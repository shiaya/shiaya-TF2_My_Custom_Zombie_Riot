#pragma semicolon 1
#pragma newdecls required

static const char g_DeathSounds[][] = {
	"weapons/rescue_ranger_teleport_receive_01.wav",
	"weapons/rescue_ranger_teleport_receive_02.wav",
};

static const char g_HurtSounds[][] = {
	"vo/heavy_painsharp01.mp3",
	"vo/heavy_painsharp02.mp3",
	"vo/heavy_painsharp03.mp3",
	"vo/heavy_painsharp04.mp3",
	"vo/heavy_painsharp05.mp3",
};

static const char g_IdleAlertedSounds[][] = {
	"vo/heavy_meleedare13.mp3",
	"vo/heavy_meleedare12.mp3",
	"vo/heavy_meleedare07.mp3",
	"vo/heavy_meleedare06.mp3",
	"vo/heavy_meleedare05.mp3",
};
static const char g_MeleeAttackSounds[][] = {
	"weapons/boxing_gloves_swing1.wav",
	"weapons/boxing_gloves_swing2.wav",
	"weapons/boxing_gloves_swing4.wav",
};
static const char g_MeleeHitSounds[][] = {
	"weapons/metal_gloves_hit_flesh1.wav",
	"weapons/metal_gloves_hit_flesh2.wav",
	"weapons/metal_gloves_hit_flesh3.wav",
	"weapons/metal_gloves_hit_flesh4.wav",
};
static const char g_RangedSound[][] = {
	"weapons/gauss/fire1.wav",
};

static const char g_HurtArmorSounds[][] = {
	")physics/metal/metal_box_impact_bullet1.wav",
	")physics/metal/metal_box_impact_bullet2.wav",
	")physics/metal/metal_box_impact_bullet3.wav",
};
static const char g_SuperJumpSound[][] = {
	"misc/halloween/spell_mirv_explode_primary.wav",
};

static char g_AngerSounds[][] = {
	"vo/taunts/soldier_taunts03.mp3",
};

static char g_SyctheHitSound[][] = {
	"ambient/machines/slicer1.wav",
	"ambient/machines/slicer2.wav",
	"ambient/machines/slicer3.wav",
	"ambient/machines/slicer4.wav",
};

static char g_SyctheInitiateSound[][] = {
	"npc/env_headcrabcanister/incoming.wav",
};


static char g_AngerSoundsPassed[][] = {
	"vo/taunts/soldier_taunts15.mp3",
};

static const char g_LaserGlobalAttackSound[][] = {
	"weapons/bumper_car_speed_boost_start.wav",
};

static const char g_MessengerThrowFire[][] = {
	"misc/halloween/spell_fireball_cast.wav",
};

static const char g_MessengerThrowIce[][] = {
	"weapons/icicle_freeze_victim_01.wav",
};


static const char g_BobSuperMeleeCharge[][] =
{
	"weapons/vaccinator_charge_tier_01.wav",
	"weapons/vaccinator_charge_tier_02.wav",
	"weapons/vaccinator_charge_tier_03.wav",
	"weapons/vaccinator_charge_tier_04.wav",
};

static const char g_BobSuperMeleeCharge_Hit[][] =
{
	"player/taunt_yeti_standee_break.wav",
};

static const char g_charge_sound[][] = {
	"misc/halloween/spell_blast_jump.wav",
};

static float f_MessengerSpeedUp[MAXENTITIES];
static bool b_khamlWeaponRage[MAXENTITIES];

static int i_khamlCutscene[MAXENTITIES];
static float f_khamlCutscene[MAXENTITIES];

static float f_KahmlResTemp[MAXENTITIES];

void ChaosKahmlstein_OnMapStart_NPC()
{
	for (int i = 0; i < (sizeof(g_DeathSounds));	   i++) { PrecacheSound(g_DeathSounds[i]);	   }
	for (int i = 0; i < (sizeof(g_MessengerThrowFire));	   i++) { PrecacheSound(g_MessengerThrowFire[i]);	   }
	for (int i = 0; i < (sizeof(g_MessengerThrowIce));	   i++) { PrecacheSound(g_MessengerThrowIce[i]);	   }
	for (int i = 0; i < (sizeof(g_MeleeAttackSounds)); i++) { PrecacheSound(g_MeleeAttackSounds[i]); }
	for (int i = 0; i < (sizeof(g_MeleeHitSounds)); i++) { PrecacheSound(g_MeleeHitSounds[i]); }
	for (int i = 0; i < (sizeof(g_RangedSound)); i++) { PrecacheSound(g_RangedSound[i]); }
	for (int i = 0; i < (sizeof(g_HurtArmorSounds)); i++) { PrecacheSound(g_HurtArmorSounds[i]); }
	for (int i = 0; i < (sizeof(g_SuperJumpSound)); i++) { PrecacheSound(g_SuperJumpSound[i]); }
	for (int i = 0; i < (sizeof(g_AngerSoundsPassed));   i++) { PrecacheSound(g_AngerSoundsPassed[i]);   }
	for (int i = 0; i < (sizeof(g_IdleAlertedSounds)); i++) { PrecacheSound(g_IdleAlertedSounds[i]); }
	for (int i = 0; i < (sizeof(g_SyctheHitSound));   i++) { PrecacheSound(g_SyctheHitSound[i]);   }
	for (int i = 0; i < (sizeof(g_SyctheInitiateSound));   i++) { PrecacheSound(g_SyctheInitiateSound[i]);   }
	for (int i = 0; i < (sizeof(g_LaserGlobalAttackSound));   i++) { PrecacheSound(g_LaserGlobalAttackSound[i]);   }
	for (int i = 0; i < (sizeof(g_HurtSounds));		i++) { PrecacheSound(g_HurtSounds[i]);		}
	for (int i = 0; i < (sizeof(g_charge_sound)); i++) { PrecacheSound(g_charge_sound[i]); }
	PrecacheSoundArray(g_BobSuperMeleeCharge_Hit);
	PrecacheSoundArray(g_BobSuperMeleeCharge);
	PrecacheSoundCustom("#zombiesurvival/internius/khamlstein.mp3");
	PrecacheSoundCustom("zombiesurvival/internius/blinkarrival.wav");
	PrecacheSound("player/taunt_knuckle_crack.wav");
	PrecacheSound("mvm/mvm_cpoint_klaxon.wav");
}


methodmap ChaosKahmlstein < CClotBody
{
	property int i_GunMode
	{
		public get()							{ return i_AttacksTillMegahit[this.index]; }
		public set(int TempValueForProperty) 	{ i_AttacksTillMegahit[this.index] = TempValueForProperty; }
	}
	property float f_ChaosKahmlsteinMeleeCooldown
	{
		public get()							{ return fl_NextChargeSpecialAttack[this.index]; }
		public set(float TempValueForProperty) 	{ fl_NextChargeSpecialAttack[this.index] = TempValueForProperty; }
	}
	property float f_ChaosKahmlsteinRocketJumpCD
	{
		public get()							{ return fl_NextRangedBarrage_Singular[this.index]; }
		public set(float TempValueForProperty) 	{ fl_NextRangedBarrage_Singular[this.index] = TempValueForProperty; }
	}
	property float f_ChaosKahmlsteinRocketJumpCD_Wearoff
	{
		public get()							{ return fl_AttackHappensMaximum[this.index]; }
		public set(float TempValueForProperty) 	{ fl_AttackHappensMaximum[this.index] = TempValueForProperty; }
	}
	property bool b_ChaosKahmlsteinRocketJump
	{
		public get()							{ return b_NextRangedBarrage_OnGoing[this.index]; }
		public set(bool TempValueForProperty) 	{ b_NextRangedBarrage_OnGoing[this.index] = TempValueForProperty; }
	}
	public void PlayAngerSoundPassed() 
	{
		int sound = GetRandomInt(0, sizeof(g_AngerSoundsPassed) - 1);
		EmitSoundToAll(g_AngerSoundsPassed[sound], this.index, SNDCHAN_STATIC, 120, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll(g_AngerSoundsPassed[sound], this.index, SNDCHAN_STATIC, 120, _, BOSS_ZOMBIE_VOLUME);

		EmitSoundToAll("mvm/mvm_tele_deliver.wav", this.index, SNDCHAN_STATIC, 80, _, 0.8);
	}
	public void PlaySytheInitSound() {
	
		int sound = GetRandomInt(0, sizeof(g_SyctheInitiateSound) - 1);
		EmitSoundToAll(g_SyctheInitiateSound[sound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll(g_SyctheInitiateSound[sound], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayAngerSound() {
	
		int sound = GetRandomInt(0, sizeof(g_AngerSounds) - 1);
		EmitSoundToAll(g_AngerSounds[sound], _, SNDCHAN_STATIC, _, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll(g_AngerSounds[sound], _, SNDCHAN_STATIC, _, _, BOSS_ZOMBIE_VOLUME);
	}
	
	public void PlayDeathSound() 
	{
		EmitSoundToAll(g_DeathSounds[GetRandomInt(0, sizeof(g_DeathSounds) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayChargeSound() 
	{
		EmitSoundToAll(g_charge_sound[GetRandomInt(0, sizeof(g_charge_sound) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME, GetRandomInt(80, 85));

	}
	public void PlayProjectileSound() 
	{
		if(this.m_flidle_talk > GetGameTime(this.index))
			return;
			
		this.m_flidle_talk = GetGameTime(this.index) + 0.1;
		if(ZR_GetWaveCount()+1 <= 15)
			EmitSoundToAll(g_MessengerThrowFire[GetRandomInt(0, sizeof(g_MessengerThrowFire) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		else
			EmitSoundToAll(g_MessengerThrowIce[GetRandomInt(0, sizeof(g_MessengerThrowIce) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayIdleAlertSound() 
	{
		int sound = GetRandomInt(0, sizeof(g_IdleAlertedSounds) - 1);
		EmitSoundToAll(g_IdleAlertedSounds[sound], _, SNDCHAN_STATIC, _, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll(g_IdleAlertedSounds[sound], _, SNDCHAN_STATIC, _, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll("mvm/mvm_cpoint_klaxon.wav", _, _, _, _, 1.0);
		EmitSoundToAll("mvm/mvm_cpoint_klaxon.wav", _, _, _, _, 1.0);
	}
	public void PlaySuperJumpSound()
	{
		EmitSoundToAll(g_SuperJumpSound[GetRandomInt(0, sizeof(g_SuperJumpSound) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll(g_SuperJumpSound[GetRandomInt(0, sizeof(g_SuperJumpSound) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayMeleeSound()
	{
		EmitSoundToAll(g_MeleeAttackSounds[GetRandomInt(0, sizeof(g_MeleeAttackSounds) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayMeleeHitSound() 
	{
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
		EmitSoundToAll(g_MeleeHitSounds[GetRandomInt(0, sizeof(g_MeleeHitSounds) - 1)], this.index, SNDCHAN_AUTO, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayRangedSound() 
	{
		EmitSoundToAll(g_RangedSound[GetRandomInt(0, sizeof(g_RangedSound) - 1)], this.index, SNDCHAN_WEAPON, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME, 80);
	}
	public void PlayHurtArmorSound() 
	{
		EmitSoundToAll(g_HurtArmorSounds[GetRandomInt(0, sizeof(g_HurtArmorSounds) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayBobMeleePostHit()
	{
		int pitch = GetRandomInt(70,80);
		EmitSoundToAll(g_BobSuperMeleeCharge_Hit[GetRandomInt(0, sizeof(g_BobSuperMeleeCharge_Hit) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, 0.7, pitch);
		EmitSoundToAll(g_BobSuperMeleeCharge_Hit[GetRandomInt(0, sizeof(g_BobSuperMeleeCharge_Hit) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, 0.7, pitch);
	}
	public void PlayBobMeleePreHit()
	{
		EmitSoundToAll(g_BobSuperMeleeCharge[GetRandomInt(0, sizeof(g_BobSuperMeleeCharge) - 1)], this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, 0.7, GetRandomInt(80,90));
	}
	
	public void PlayHurtSound() 
	{
		EmitSoundToAll(g_HurtSounds[GetRandomInt(0, sizeof(g_HurtSounds) - 1)], this.index, _, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);
	}
	public void PlayTeleportSound() 
	{
		EmitCustomToAll("zombiesurvival/internius/blinkarrival.wav", this.index, SNDCHAN_STATIC, RAIDBOSS_ZOMBIE_SOUNDLEVEL, _, BOSS_ZOMBIE_VOLUME);	
	}
	
	public ChaosKahmlstein(int client, float vecPos[3], float vecAng[3], int ally, const char[] data)
	{
		ChaosKahmlstein npc = view_as<ChaosKahmlstein>(CClotBody(vecPos, vecAng, "models/player/heavy.mdl", "1.35", "40000", ally, false, true, true,_)); //giant!
		
		i_NpcInternalId[npc.index] = RAIDMODE_CHAOS_KAHMLSTEIN;
		i_NpcWeight[npc.index] = 4;

		FormatEx(c_HeadPlaceAttachmentGibName[npc.index], sizeof(c_HeadPlaceAttachmentGibName[]), "head");
		
		int iActivity = npc.LookupActivity("ACT_MP_RUN_MELEE");
		if(iActivity > 0) npc.StartActivity(iActivity);
		
///		SetVariantInt(4);
//		AcceptEntityInput(npc.index, "SetBodyGroup");
		
		npc.m_flNextMeleeAttack = 0.0;
		
		npc.m_iBleedType = BLEEDTYPE_NORMAL;
		npc.m_iStepNoiseType = STEPSOUND_GIANT;	
		npc.m_iNpcStepVariation = STEPTYPE_NORMAL;
		npc.m_bDissapearOnDeath = true;
		npc.m_flMeleeArmor = 1.25;	
		b_khamlWeaponRage[npc.index] = false;



		func_NPCDeath[npc.index] = view_as<Function>(ChaosKahmlstein_NPCDeath);
		func_NPCOnTakeDamage[npc.index] = view_as<Function>(ChaosKahmlstein_OnTakeDamage);
		func_NPCThink[npc.index] = view_as<Function>(ChaosKahmlstein_ClotThink);


		//IDLE
		npc.m_iState = 0;
		npc.m_flGetClosestTargetTime = 0.0;
		npc.StartPathing();
		npc.m_flSpeed = 330.0;
		npc.i_GunMode = 0;
		npc.m_flRangedSpecialDelay = GetGameTime() + 10.0;
		npc.m_flNextRangedSpecialAttackHappens = GetGameTime() + 5.0;
		npc.m_flAngerDelay = GetGameTime() + 15.0;
		BlockLoseSay = false;
		npc.m_flAttackHappens_bullshit = GetGameTime(npc.index) + 9999.0;
		npc.m_flNextChargeSpecialAttack = GetGameTime(npc.index) + 5.0;
		npc.m_flJumpCooldown = GetGameTime(npc.index) + 10.0;
		f_MessengerSpeedUp[npc.index] = 1.0;
		npc.g_TimesSummoned = 0;
		
		b_thisNpcIsARaid[npc.index] = true;
		

		bool final = StrContains(data, "final_item") != -1;
		
		if(final)
		{
			f_khamlCutscene[npc.index] = GetGameTime() + 45.0;
			i_khamlCutscene[npc.index] = 14;
			i_RaidGrantExtra[npc.index] = 1;
		}

		if(StrContains(data, "fake_2") != -1)
		{
			SetEntityCollisionGroup(npc.index, 1); //Dont Touch Anything.
			SetEntProp(npc.index, Prop_Send, "m_usSolidFlags", 12); 
			SetEntProp(npc.index, Prop_Data, "m_nSolidType", 6);
			i_RaidGrantExtra[npc.index] = 2;
			b_DoNotUnStuck[npc.index] = true;
			b_ThisNpcIsImmuneToNuke[npc.index] = true;
			b_NoKnockbackFromSources[npc.index] = true;
			b_ThisEntityIgnored[npc.index] = true;
			b_thisNpcIsARaid[npc.index] = true;
			npc.m_flNextChargeSpecialAttack = 0.0;
			b_NoKillFeed[npc.index] = true;
		}
		else if(StrContains(data, "fake_3") != -1)
		{
			SetEntityCollisionGroup(npc.index, 1); //Dont Touch Anything.
			SetEntProp(npc.index, Prop_Send, "m_usSolidFlags", 12); 
			SetEntProp(npc.index, Prop_Data, "m_nSolidType", 6);
			i_RaidGrantExtra[npc.index] = 3;
			b_DoNotUnStuck[npc.index] = true;
			b_ThisNpcIsImmuneToNuke[npc.index] = true;
			b_NoKnockbackFromSources[npc.index] = true;
			b_ThisEntityIgnored[npc.index] = true;
			b_thisNpcIsARaid[npc.index] = true;
			npc.m_flNextRangedBarrage_Spam = GetGameTime(npc.index) + 10.0;
			npc.i_GunMode = 1;
			b_NoKillFeed[npc.index] = true;
		}
		else if(StrContains(data, "fake_4") != -1)
		{
			SetEntityCollisionGroup(npc.index, 1); //Dont Touch Anything.
			SetEntProp(npc.index, Prop_Send, "m_usSolidFlags", 12); 
			SetEntProp(npc.index, Prop_Data, "m_nSolidType", 6);
			i_RaidGrantExtra[npc.index] = 4;
			b_DoNotUnStuck[npc.index] = true;
			b_ThisNpcIsImmuneToNuke[npc.index] = true;
			b_NoKnockbackFromSources[npc.index] = true;
			b_ThisEntityIgnored[npc.index] = true;
			b_thisNpcIsARaid[npc.index] = true;
			npc.m_flRangedSpecialDelay = 0.0;
			b_NoKillFeed[npc.index] = true;
		}
		else
		{
			func_NPCFuncWin[npc.index] = view_as<Function>(ChaosKahmlstein_Win);
			SDKHook(npc.index, SDKHook_OnTakeDamagePost, ChaosKahmlstein_OnTakeDamagePost);
			EmitSoundToAll("mvm/mvm_tank_start.wav", _, _, _, _, 1.0);	
			EmitSoundToAll("mvm/mvm_tank_start.wav", _, _, _, _, 1.0);	
			for(int client_check=1; client_check<=MaxClients; client_check++)
			{
				if(IsClientInGame(client_check) && !IsFakeClient(client_check))
				{
					SetGlobalTransTarget(client_check);
					ShowGameText(client_check, "item_armor", 1, "%t", "Chaos Kahmlstein Arrived");
				}
			}
			RaidModeTime = GetGameTime(npc.index) + 250.0;
			if(final)
			{
				RaidModeTime += 45.0;
				Music_SetRaidMusic("vo/null.mp3", 30, false, 0.5);
			}
			else
			{
				Music_SetRaidMusic("#zombiesurvival/internius/khamlstein.mp3", 294, true, 1.5);
			}

			RaidBossActive = EntIndexToEntRef(npc.index);
			RaidAllowsBuildings = false;
					
			RaidModeScaling = float(ZR_GetWaveCount()+1);
			if(RaidModeScaling < 55)
			{
				RaidModeScaling *= 0.19; //abit low, inreacing
			}
			else
			{
				RaidModeScaling *= 0.38;
			}
			
			float amount_of_people = float(CountPlayersOnRed());
			if(amount_of_people > 12.0)
			{
				amount_of_people = 12.0;
			}
			amount_of_people *= 0.12;
			
			if(amount_of_people < 1.0)
				amount_of_people = 1.0;

			RaidModeScaling *= amount_of_people; //More then 9 and he raidboss gets some troubles, bufffffffff
			
			if(ZR_GetWaveCount()+1 > 40 && ZR_GetWaveCount()+1 < 55)
			{
				RaidModeScaling *= 0.85;
			}
			else if(ZR_GetWaveCount()+1 > 55)
			{
				RaidModeScaling *= 0.7;
			}
			RaidModeScaling *= 0.7;
		}

		
		npc.m_iChanged_WalkCycle = -1;

		int skin = 1;
		SetEntProp(npc.index, Prop_Send, "m_nSkin", skin);

	//	Weapon
		npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_fists_of_steel/c_fists_of_steel.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
		
		npc.m_iWearable4 = npc.EquipItem("head", "models/workshop_partner/player/items/all_class/dex_glasses/dex_glasses_heavy.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable4, "SetModelScale");
		
		npc.m_iWearable5 = npc.EquipItem("head", "models/workshop/player/items/heavy/Robo_Heavy_Chief/Robo_Heavy_Chief.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable5, "SetModelScale");
		
		npc.m_iWearable6 = npc.EquipItem("head", "models/player/items/heavy/heavy_wolf_chest.mdl");
		SetVariantString("1.0");
		AcceptEntityInput(npc.m_iWearable6, "SetModelScale");
		
		int Alpha = 255;
		if(i_RaidGrantExtra[npc.index] >= 2)
			Alpha = 180;

		SetEntityRenderMode(npc.index, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.index, 21, 71, 171, Alpha);
		
		SetEntityRenderMode(npc.m_iWearable4, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable4, 21, 71, 171, Alpha);
		SetEntityRenderMode(npc.m_iWearable5, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable5, 21, 71, 171, Alpha);
		SetEntityRenderMode(npc.m_iWearable6, RENDER_TRANSCOLOR);
		SetEntityRenderColor(npc.m_iWearable6, 21, 71, 171, Alpha);

//		SetEntProp(npc.m_iWearable2, Prop_Send, "m_nSkin", skin);
		SetEntProp(npc.m_iWearable4, Prop_Send, "m_nSkin", skin);
		SetEntProp(npc.m_iWearable5, Prop_Send, "m_nSkin", skin);
		SetEntProp(npc.m_iWearable6, Prop_Send, "m_nSkin", skin);

		float flPos[3]; // original
		float flAng[3]; // original
	
		npc.GetAttachment("effect_hand_r", flPos, flAng);
		npc.m_iWearable2 = ParticleEffectAt_Parent(flPos, "raygun_projectile_blue_crit", npc.index, "effect_hand_r", {0.0,0.0,0.0});
		npc.GetAttachment("root", flPos, flAng);
		
		npc.GetAttachment("effect_hand_l", flPos, flAng);
		npc.m_iWearable3 = ParticleEffectAt_Parent(flPos, "raygun_projectile_blue_crit", npc.index, "effect_hand_l", {0.0,0.0,0.0});
		npc.GetAttachment("root", flPos, flAng);

		
		npc.m_iTeamGlow = TF2_CreateGlow(npc.index);
		npc.m_bTeamGlowDefault = false;

		SetVariantColor(view_as<int>({173, 216, 230, 200}));
		AcceptEntityInput(npc.m_iTeamGlow, "SetGlowColor");
		
		return npc;
	}
}

public void ChaosKahmlstein_ClotThink(int iNPC)
{
	ChaosKahmlstein npc = view_as<ChaosKahmlstein>(iNPC);
	if(npc.m_flNextDelayTime > GetGameTime(npc.index))
	{
		return;
	}
	npc.m_flNextDelayTime = GetGameTime(npc.index) + DEFAULT_UPDATE_DELAY_FLOAT;
	npc.Update();

	if(i_RaidGrantExtra[npc.index] == 1 && i_khamlCutscene[npc.index] != 0)
	{
		if(i_khamlCutscene[npc.index] == 14)
		{
			bool foundEm = false;
			float Pos[3];
			for(int i; i < i_MaxcountNpcTotal; i++)
			{
				int entity = EntRefToEntIndex(i_ObjectsNpcsTotal[i]);
				if(entity != INVALID_ENT_REFERENCE && (i_NpcInternalId[entity] == RAIDMODE_THE_MESSENGER && IsEntityAlive(entity)))
				{
					foundEm = true;
					GetEntPropVector(entity, Prop_Data, "m_vecAbsOrigin", Pos);
					b_DissapearOnDeath[entity] = false;
					b_thisNpcIsARaid[entity] = false;
					SmiteNpcToDeath(entity);
				}
			}
			if(foundEm)
			{
				EmitSoundToAll("player/taunt_knuckle_crack.wav", _, _, _, _, 1.0);	
				EmitSoundToAll("player/taunt_knuckle_crack.wav", _, _, _, _, 1.0);	
				EmitSoundToAll("player/taunt_knuckle_crack.wav", _, _, _, _, 1.0);	
				EmitSoundToAll("player/taunt_knuckle_crack.wav", _, _, _, _, 1.0);	
				b_NpcIsInvulnerable[npc.index] = true;
				npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE",true);
				TeleportEntity(npc.index, Pos);
				NPC_StopPathing(npc.index);
				npc.m_bPathing = false;
				i_khamlCutscene[npc.index] = 13;
				CPrintToChatAll("{darkblue}Kahmlstein{default}: That's enough. You have done well beyond my expectations.... {crimson}Which were very low from the start.");
			}
			else
			{
				CPrintToChatAll("{darkblue}Kahmlstein{default}: Let's fight!");
				Music_SetRaidMusic("#zombiesurvival/internius/khamlstein.mp3", 294, true, 1.5);
				i_khamlCutscene[npc.index] = 0;
			}
		}
		float TimeLeft = f_khamlCutscene[npc.index] - GetGameTime();

		switch(i_khamlCutscene[npc.index])
		{
			case 13:
			{
				if(TimeLeft < 41.0)
				{
					i_khamlCutscene[npc.index] = 12;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: You. You must remember me don't you?");
				}
			}
			case 12:
			{
				if(TimeLeft < 37.0)
				{
					i_khamlCutscene[npc.index] = 11;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: My almost ideal copy of myself gave you a hard time before, didn't it?");
				}
			}
			case 11:
			{
				if(TimeLeft < 33.0)
				{
					i_khamlCutscene[npc.index] = 10;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: Now, the real deal stands before you.");
				}
			}
			case 10:
			{
				if(TimeLeft < 30.0)
				{
					i_khamlCutscene[npc.index] = 9;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: You know what mine goal is? Burn everything and turn it into ash.");
				}
			}
			case 9:
			{
				if(TimeLeft < 26.0)
				{
					i_khamlCutscene[npc.index] = 8;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: From all of the ashes, a new world will be born.");
				}
			}
			case 8:
			{
				if(TimeLeft < 22.0)
				{
					i_khamlCutscene[npc.index] = 7;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: I really hate this world.");
				}
			}
			case 7:
			{
				if(TimeLeft < 18.0)
				{
					i_khamlCutscene[npc.index] = 6;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: hate these fucks who think so high of themselves. {crimson}Politicans.");
				}
			}
			case 6:
			{
				if(TimeLeft < 12.0)
				{
					i_khamlCutscene[npc.index] = 5;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: The goverments? Fuck them too. Burn them to the ground.");
				}
			}
			case 5:
			{
				if(TimeLeft < 9.0)
				{
					i_khamlCutscene[npc.index] = 4;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: And you know what I hate the most?");
				}
			}
			case 4:
			{
				if(TimeLeft < 4.0)
				{
					i_khamlCutscene[npc.index] = 3;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: {crimson}V i o l e n c e.... a g a i n s t.. a n i m a l s.");
				}
			}
			case 3:
			{
				if(TimeLeft < 2.0)
				{
					i_khamlCutscene[npc.index] = 2;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: I will purge this world from everything I hate, including you.");
				}
			}
			case 2:
			{
				if(TimeLeft < 0.0)
				{
					i_khamlCutscene[npc.index] = 0;
					CPrintToChatAll("{darkblue}Kahmlstein{default}: Let's begin.");
					RaidBossActive = EntIndexToEntRef(npc.index);
					RaidAllowsBuildings = false;
					Music_SetRaidMusic("#zombiesurvival/internius/khamlstein.mp3", 294, true, 1.5);
				}
			}
		}
		return;
	}
	b_NpcIsInvulnerable[npc.index] = false;
	if(LastMann && i_RaidGrantExtra[npc.index] < 2)
	{
		if(!npc.m_fbGunout)
		{
			npc.m_fbGunout = true;
			switch(GetRandomInt(0,3))
			{
				case 0:
				{
					CPrintToChatAll("{darkblue}Kahmlstein{default}: I am going to break every single bone in your body.");
				}
				case 1:
				{
					CPrintToChatAll("{darkblue}Kahmlstein{default}: You're all alone against Chaos now.");
				}
				case 2:
				{
					CPrintToChatAll("{darkblue}Kahmlstein{default}: I will drag you face down to the bottoms of the Deep Sea.");
				}
				case 3:
				{
					CPrintToChatAll("{darkblue}Kahmlstein{default}: Blitzkrierg was weak, that's why he failed. {crimson}Just like you are.");
				}
			}
		}
	}
	float RaidModeTimeLeft = RaidModeTime - GetGameTime();

	if(RaidModeTimeLeft < 190.0 && f_MessengerSpeedUp[npc.index] == 1.0)
	{
		f_MessengerSpeedUp[npc.index] = 1.25;
		if(i_RaidGrantExtra[npc.index] < 2)
			CPrintToChatAll("{darkblue}Kahmlstein{default}: I'm literally half asleep, let's heat things up.");
	}
	else if(RaidModeTimeLeft < 130.0 && f_MessengerSpeedUp[npc.index] == 1.25)
	{
		f_MessengerSpeedUp[npc.index] = 1.35;
		if(i_RaidGrantExtra[npc.index] < 2)
			CPrintToChatAll("{darkblue}Kahmlstein{default}: Even mine dead grandma is more entertaining than this.");
	}
	else if(RaidModeTimeLeft < 70 && f_MessengerSpeedUp[npc.index] == 1.35)
	{
		f_MessengerSpeedUp[npc.index] = 1.5;
		if(i_RaidGrantExtra[npc.index] < 2)
			CPrintToChatAll("{darkblue}Kahmlstein{default}:{crimson} RAAAAAAH, I'M UNSTOPPABLE!!!.");
	}
	else if(RaidModeTimeLeft < 0.0 && f_MessengerSpeedUp[npc.index] == 1.5)
	{
		f_MessengerSpeedUp[npc.index] = 5.0;
		npc.m_flSpeed = 600.0;
		if(i_RaidGrantExtra[npc.index] < 2)
			CPrintToChatAll("{darkblue}Kahmlstein{default}:{crimson} YAAAAAAAAAAAAAAAAAAAAAAA.");
	}

	if(npc.m_blPlayHurtAnimation)
	{
		npc.AddGesture("ACT_MP_GESTURE_FLINCH_CHEST", false);
		npc.m_blPlayHurtAnimation = false;
		npc.PlayHurtSound();
	}



	if(npc.m_flNextThinkTime > GetGameTime(npc.index))
	{
		return;
	}
	if(i_RaidGrantExtra[npc.index] >= 2)
	{
		if(!IsValidAlly(npc.index, npc.m_iTargetAlly))
		{
			SmiteNpcToDeath(npc.index);
		}
	}
	npc.m_flNextThinkTime = GetGameTime(npc.index) + (0.1 * (1.0 / f_MessengerSpeedUp[npc.index]));

	if(i_RaidGrantExtra[npc.index] == 4)
	{
		if(ChaosKahmlstein_Attack_Melee_BodySlam_thing(npc, 0))
		{
			return;
		}
		return;
	}

	if(i_RaidGrantExtra[npc.index] == 2)
	{
		if(ChaosKahmlstein_Attack_Melee_Uppercut(npc, 0))
		{
			return;
		}
		return;
	}
	if(Kahmlstein_Attack_TempPowerup(npc))
		return;

	if(f_KahmlResTemp[npc.index] > GetGameTime())
	{
		if(NpcStats_IsEnemySilenced(npc.index))
		{
			npc.m_flMeleeArmor = 0.65;
			npc.m_flRangedArmor = 0.5;	
		}
		else
		{
			npc.m_flMeleeArmor = 0.75;
			npc.m_flRangedArmor = 0.6;	
		}
	}
	else
	{
		npc.m_flMeleeArmor = 1.25;
		npc.m_flRangedArmor = 1.0;	
	}	

	if(npc.m_flGetClosestTargetTime < GetGameTime(npc.index))
	{
		if(i_RaidGrantExtra[npc.index] < 2)
		{
			npc.m_iTarget = GetClosestTarget(npc.index);
		}
		else
		{
			ChaosKahmlstein allynpc = view_as<ChaosKahmlstein>(npc.m_iTargetAlly);
			npc.m_iTarget = GetClosestTarget(npc.index,_,_,_,_,allynpc.m_iTarget);
		}

		npc.m_flGetClosestTargetTime = GetGameTime(npc.index) + GetRandomRetargetTime();
	}
	if(IsValidEnemy(npc.index, npc.m_iTarget))
	{
		if(ChaosKahmlstein_Attack_Melee_Uppercut(npc, npc.m_iTarget))
			return;

		if(ChaosKahmlstein_Attack_Melee_BodySlam_thing(npc, npc.m_iTarget))
			return;

		float vecTarget[3]; vecTarget = WorldSpaceCenterOld(npc.m_iTarget);
		float flDistanceToTarget = GetVectorDistance(vecTarget, WorldSpaceCenterOld(npc.index), true);
		int SetGoalVectorIndex = 0;
		SetGoalVectorIndex = ChaosKahmlsteinSelfDefense(npc,GetGameTime(npc.index), npc.m_iTarget, flDistanceToTarget); 
		switch(SetGoalVectorIndex)
		{
			case 0:
			{
				npc.m_bAllowBackWalking = false;
				//Get the normal prediction code.
				if(flDistanceToTarget < npc.GetLeadRadius()) 
				{
					float vPredictedPos[3];
					vPredictedPos = PredictSubjectPositionOld(npc, npc.m_iTarget);
					NPC_SetGoalVector(npc.index, vPredictedPos);
					if(npc.m_flCharge_delay < GetGameTime(npc.index))
					{
						if(npc.IsOnGround() && flDistanceToTarget > NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED && flDistanceToTarget < NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 10.0)
						{
							npc.PlayChargeSound();
							npc.m_flCharge_delay = GetGameTime(npc.index) +  (5.0 *(1.0 / f_MessengerSpeedUp[npc.index]));
							PluginBot_Jump(npc.index, vecTarget);
							float flPos[3];
							float flAng[3];
							int Particle_1;
							int Particle_2;
							npc.GetAttachment("foot_L", flPos, flAng);
							Particle_1 = ParticleEffectAt_Parent(flPos, "raygun_projectile_blue_crit", npc.index, "foot_L", {0.0,0.0,0.0});
							
							npc.GetAttachment("foot_R", flPos, flAng);
							Particle_2 = ParticleEffectAt_Parent(flPos, "raygun_projectile_red_crit", npc.index, "foot_R", {0.0,0.0,0.0});
							CreateTimer(1.0, Timer_RemoveEntity, EntIndexToEntRef(Particle_1), TIMER_FLAG_NO_MAPCHANGE);
							CreateTimer(1.0, Timer_RemoveEntity, EntIndexToEntRef(Particle_2), TIMER_FLAG_NO_MAPCHANGE);
						}
					}
				//	ChaosKahmlstein_Attack_FingerPoint(npc);
				}
				else 
				{
					NPC_SetGoalEntity(npc.index, npc.m_iTarget);
				}
			}
			case 1:
			{
				npc.m_bAllowBackWalking = true;
				float vBackoffPos[3];
				vBackoffPos = BackoffFromOwnPositionAndAwayFromEnemyOld(npc, npc.m_iTarget);
				NPC_SetGoalVector(npc.index, vBackoffPos, true); //update more often, we need it
			}
		}
	}
	else
	{
		npc.m_flGetClosestTargetTime = 0.0;
		if(i_RaidGrantExtra[npc.index] < 2)
		{
			npc.m_iTarget = GetClosestTarget(npc.index);
		}
		else
		{
			ChaosKahmlstein allynpc = view_as<ChaosKahmlstein>(npc.m_iTargetAlly);
			npc.m_iTarget = GetClosestTarget(npc.index,_,_,_,_,allynpc.m_iTarget);
		}
	}
	if(npc.m_flDoingAnimation < GetGameTime(npc.index))
	{
		ChaosKahmlsteinAnimationChange(npc);
	}
}

bool ChaosKahmlstein_Attack_Melee_Uppercut(ChaosKahmlstein npc, int Target)
{
	if(i_RaidGrantExtra[npc.index] < 2)
	{
		if(!npc.m_flAttackHappens_2 && npc.m_flNextChargeSpecialAttack < GetGameTime(npc.index))
		{
			npc.PlayIdleAlertSound();
			npc.m_flNextChargeSpecialAttack = GetGameTime(npc.index) + (15.0 * (1.0 / f_MessengerSpeedUp[npc.index]));
			NPC_StopPathing(npc.index);
			npc.m_bPathing = false;
			npc.AddActivityViaSequence("taunt_the_fist_bump");
			npc.m_flAttackHappens = 0.0;
			npc.SetCycle(0.01);
			npc.SetPlaybackRate(f_MessengerSpeedUp[npc.index]);
			npc.m_flDoingAnimation = GetGameTime(npc.index) + (1.85 * (1.0 / f_MessengerSpeedUp[npc.index]));	
			npc.m_iOverlordComboAttack = 555;
			npc.m_iChanged_WalkCycle = 0;
			npc.m_flAttackHappens_2 = GetGameTime(npc.index) + (0.7 * (1.0 / f_MessengerSpeedUp[npc.index]));
		}
		if(npc.m_flAttackHappens_2 > GetGameTime(npc.index))
		{
			return true;
		}
	}
	if(i_RaidGrantExtra[npc.index] == 2 && npc.m_iOverlordComboAttack == 0)
	{
		npc.m_iOverlordComboAttack = 555;
		npc.m_flNextChargeSpecialAttack = GetGameTime(npc.index) + (35.0 * (1.0 / f_MessengerSpeedUp[npc.index]));
	}
	if(npc.m_flNextChargeSpecialAttack > GetGameTime(npc.index) && npc.m_flAttackHappens_2 < GetGameTime(npc.index) && npc.m_iOverlordComboAttack == 555)
	{
		npc.m_flAttackHappens_2 = GetGameTime(npc.index) + (1.35 * (1.0 / f_MessengerSpeedUp[npc.index]));
		npc.m_iOverlordComboAttack = 666;
		if(Target > 0)
		{
			UnderTides npcGetInfo = view_as<UnderTides>(npc.index);
			int enemy[MAXENTITIES];
			GetHighDefTargets(npcGetInfo, enemy, sizeof(enemy), true, false);
			for(int i; i < sizeof(enemy); i++)
			{
				if(enemy[i])
				{
					Target = enemy[i];
					float vPredictedPos[3];
					vPredictedPos = PredictSubjectPositionOld(npc, Target);
					vPredictedPos = GetBehindTarget(Target, 30.0 ,vPredictedPos);
					static float hullcheckmaxs[3];
					static float hullcheckmins[3];
					hullcheckmaxs = view_as<float>( { 30.0, 30.0, 120.0 } );
					hullcheckmins = view_as<float>( { -30.0, -30.0, 0.0 } );	

					float SelfPos[3];
					GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", SelfPos);
					float AllyAng[3];
					GetEntPropVector(npc.index, Prop_Data, "m_angRotation", AllyAng);
					
					bool Succeed = Npc_Teleport_Safe(npc.index, vPredictedPos, hullcheckmins, hullcheckmaxs, false, false);
					if(Succeed)
					{
						npc.PlayTeleportSound();
						ParticleEffectAt(SelfPos, "teleported_blue", 0.5); //This is a permanent particle, gotta delete it manually...
						ParticleEffectAt(vPredictedPos, "teleported_blue", 0.5); //This is a permanent particle, gotta delete it manually...
						npc.FaceTowards(WorldSpaceCenterOld(Target), 15000.0);

						if(i_RaidGrantExtra[npc.index] < 2)
						{
							CreateCloneTempKahmlsteinFakeout(npc.index, 2, vPredictedPos, AllyAng);
						}

						SDKCall_SetLocalOrigin(npc.index, SelfPos);	
					}
				}
			}

		}
		npc.m_flNextChargeSpecialAttack = GetGameTime(npc.index) + (25.0 * (1.0 / f_MessengerSpeedUp[npc.index]));
		NPC_StopPathing(npc.index);
		npc.m_bPathing = false;
		npc.AddActivityViaSequence("taunt_bare_knuckle_beatdown_outro");
		npc.m_flAttackHappens = 0.0;
		npc.SetCycle(0.01);
		npc.SetPlaybackRate(f_MessengerSpeedUp[npc.index] * 0.50);
		npc.m_iOverlordComboAttack = 666;
		npc.m_iChanged_WalkCycle = 0;
		float vecMe[3]; vecMe = WorldSpaceCenterOld(npc.index);
		float damage = 70.0;
		int Enemypunch = npc.m_iTarget;
		if(!IsValidEnemy(npc.index, npc.m_iTarget))
		{
			Enemypunch = GetClosestTarget(npc.index);
		}
		if(IsValidEnemy(npc.index, Enemypunch))
		{
			float vecThem[3]; vecThem = WorldSpaceCenterOld(Enemypunch);
			vecThem[2] += 35.0;
			KahmlsteinInitiatePunch(npc.index, vecThem, vecMe, (1.0 * (1.0 / f_MessengerSpeedUp[npc.index])) , damage * RaidModeScaling, false, 250.0);
		}
	}

	if(npc.m_flAttackHappens_2)
	{
		//one second into the ability
		if(npc.m_flAttackHappens_2 < GetGameTime(npc.index))
		{
			if(i_RaidGrantExtra[npc.index] >= 2)
			{
				SmiteNpcToDeath(npc.index);
			}
			npc.m_flAttackHappens_2 = 0.0;
		}
		return true;
	}
	return false;
}




bool ChaosKahmlstein_Attack_Melee_BodySlam_thing(ChaosKahmlstein npc, int Target)
{
	if(!npc.m_flInJump && npc.m_flRangedSpecialDelay < GetGameTime(npc.index))
	{
		npc.m_flRangedSpecialDelay = GetGameTime(npc.index) + (15.0 * (1.0 / f_MessengerSpeedUp[npc.index]));
		NPC_StopPathing(npc.index);
		npc.m_bPathing = false;
		npc.AddActivityViaSequence("taunt_yetipunch");
		npc.m_flAttackHappens = 0.0;
		if(i_RaidGrantExtra[npc.index] < 2)
		{
			npc.SetCycle(0.35);
			npc.PlayIdleAlertSound();
		}
		else
			npc.SetCycle(0.55);

		npc.SetPlaybackRate(1.2 *f_MessengerSpeedUp[npc.index]);
		npc.m_flDoingAnimation = GetGameTime(npc.index) + (1.85 * (1.0 / f_MessengerSpeedUp[npc.index]));	
		npc.m_iOverlordComboAttack = 5555;
		npc.m_iChanged_WalkCycle = 0;
		if(i_RaidGrantExtra[npc.index] < 2)
			npc.m_flInJump = GetGameTime(npc.index) + (0.7 * (1.0 / f_MessengerSpeedUp[npc.index]));

		npc.m_flInJump = GetGameTime(npc.index) + (0.7 * (1.0 / f_MessengerSpeedUp[npc.index]));
	}
	if(i_RaidGrantExtra[npc.index] == 4 && npc.m_iOverlordComboAttack == 0)
	{
		npc.m_iOverlordComboAttack = 5555;
		npc.m_flRangedSpecialDelay = GetGameTime(npc.index) + (35.0 * (1.0 / f_MessengerSpeedUp[npc.index]));
	}
	if(npc.m_flRangedSpecialDelay > GetGameTime(npc.index) && (npc.m_flInJump < GetGameTime(npc.index) || i_RaidGrantExtra[npc.index] == 4) && npc.m_iOverlordComboAttack == 5555)
	{
		if(Target > 0)
		{
			UnderTides npcGetInfo = view_as<UnderTides>(npc.index);
			int enemy[MAXENTITIES];
			GetHighDefTargets(npcGetInfo, enemy, sizeof(enemy), true, false);
			for(int i; i < sizeof(enemy); i++)
			{
				if(enemy[i])
				{
					Target = enemy[i];
					float vPredictedPos[3];
					vPredictedPos = PredictSubjectPositionOld(npc, Target);
					vPredictedPos = GetBehindTarget(Target, 30.0 ,vPredictedPos);
					static float hullcheckmaxs[3];
					static float hullcheckmins[3];
					hullcheckmaxs = view_as<float>( { 30.0, 30.0, 120.0 } );
					hullcheckmins = view_as<float>( { -30.0, -30.0, 0.0 } );	

					float SelfPos[3];
					GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", SelfPos);
					float AllyAng[3];
					GetEntPropVector(npc.index, Prop_Data, "m_angRotation", AllyAng);
					
					bool Succeed = Npc_Teleport_Safe(npc.index, vPredictedPos, hullcheckmins, hullcheckmaxs, false, false);
					if(Succeed)
					{
						npc.PlayTeleportSound();
						ParticleEffectAt(SelfPos, "teleported_blue", 0.5); //This is a permanent particle, gotta delete it manually...
						ParticleEffectAt(vPredictedPos, "teleported_blue", 0.5); //This is a permanent particle, gotta delete it manually...
						npc.FaceTowards(WorldSpaceCenterOld(Target), 15000.0);

						if(i_RaidGrantExtra[npc.index] < 2)
						{
							CreateCloneTempKahmlsteinFakeout(npc.index, 4, vPredictedPos, AllyAng);
						}

						SDKCall_SetLocalOrigin(npc.index, SelfPos);	
					}
				}
			}

		}
		npc.m_iOverlordComboAttack = 6666;
		npc.m_flAttackHappens = 0.0;
		float vecMe[3]; vecMe = WorldSpaceCenterOld(npc.index);
		float damage = 80.0;
		int Enemypunch = npc.m_iTarget;
		if(!IsValidEnemy(npc.index, npc.m_iTarget))
		{
			Enemypunch = GetClosestTarget(npc.index);
		}
		if(IsValidEnemy(npc.index, Enemypunch))
		{
			float vecThem[3]; vecThem = WorldSpaceCenterOld(Enemypunch);
			vecThem[2] += 35.0;
			KahmlsteinInitiatePunch(npc.index, vecThem, vecMe, (1.0 * (1.0 / f_MessengerSpeedUp[npc.index])) , damage * RaidModeScaling, false, 300.0);
		}
	}

	if(npc.m_flInJump)
	{
		//one second into the ability
		if(npc.m_flInJump < GetGameTime(npc.index))
		{
			if(i_RaidGrantExtra[npc.index] >= 2)
			{
				SmiteNpcToDeath(npc.index);
			}
			npc.m_flInJump = 0.0;
		}
		return true;
	}
	return false;
}

public Action ChaosKahmlstein_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	ChaosKahmlstein npc = view_as<ChaosKahmlstein>(victim);
		
	if(attacker <= 0)
		return Plugin_Continue;

	if (npc.m_flHeadshotCooldown < GetGameTime(npc.index))
	{
		npc.m_flHeadshotCooldown = GetGameTime(npc.index) + DEFAULT_HURTDELAY;
		npc.m_blPlayHurtAnimation = true;
	}		
	
	if(weapon > 0)
	{
		if(!b_khamlWeaponRage[npc.index])
		{
			if(i_CustomWeaponEquipLogic[weapon] == WEAPON_KAHMLFIST)
			{
				b_khamlWeaponRage[npc.index] = true;
				CPrintToChatAll("{darkblue}Kahmlstein{default}: You dare to use my OWN fists against ME? Man fuck you.");
			}
		}
	}
	return Plugin_Changed;
}

public void ChaosKahmlstein_NPCDeath(int entity)
{
	ChaosKahmlstein npc = view_as<ChaosKahmlstein>(entity);
	/*
		Explode on death code here please

	*/
		
	if(IsValidEntity(npc.m_iWearable7))
		RemoveEntity(npc.m_iWearable7);
	if(IsValidEntity(npc.m_iWearable6))
		RemoveEntity(npc.m_iWearable6);
	if(IsValidEntity(npc.m_iWearable5))
		RemoveEntity(npc.m_iWearable5);
	if(IsValidEntity(npc.m_iWearable4))
		RemoveEntity(npc.m_iWearable4);
	if(IsValidEntity(npc.m_iWearable3))
		RemoveEntity(npc.m_iWearable3);
	if(IsValidEntity(npc.m_iWearable2))
		RemoveEntity(npc.m_iWearable2);
	if(IsValidEntity(npc.m_iWearable1))
		RemoveEntity(npc.m_iWearable1);

	if(i_RaidGrantExtra[npc.index] >= 2)
		return;

	ParticleEffectAt(WorldSpaceCenterOld(npc.index), "teleported_blue", 0.5);
	npc.PlayDeathSound();	

	RaidBossActive = INVALID_ENT_REFERENCE;
	if(BlockLoseSay)
		return;

	if(i_RaidGrantExtra[npc.index] == 1)
	{
		if(GameRules_GetRoundState() == RoundState_RoundRunning)
		{
			for (int client = 0; client < MaxClients; client++)
			{
				if(IsValidClient(client) && GetClientTeam(client) == 2 && TeutonType[client] != TEUTON_WAITING)
				{
					Items_GiveNamedItem(client, "Kahml's Contained Chaos");
					CPrintToChat(client,"{default}Kahml thanks your.. efforts? You get: {red}''Kahml's Contained Chaos''{default}!");
				}
			}
			CPrintToChatAll("{darkblue}Kahmlstein{default}: This sensation.. Did I... lose? Haha, I never felt like this for a long time now.");
		}
	}
	else
	{
		CPrintToChatAll("{darkblue}Kahmlstein{default}: That was good, next time ill be sure to actually try, now factor in the chance i lied.");
	}
}
/*


*/
void ChaosKahmlsteinAnimationChange(ChaosKahmlstein npc)
{
	if(npc.m_iChanged_WalkCycle == 0)
	{
		npc.m_iChanged_WalkCycle = -1;
	}
	switch(npc.i_GunMode)
	{
		case 1: //primary
		{
			if (npc.IsOnGround())
			{
				if(npc.m_iChanged_WalkCycle != 1)
				{
				// ResetChaosKahmlsteinWeapon(npc, 1);
					npc.m_bisWalking = true;
					npc.m_iChanged_WalkCycle = 1;
					npc.SetActivity("ACT_MP_RUN_MELEE");
					npc.StartPathing();
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
				}	
			}
			else
			{
				if(npc.m_iChanged_WalkCycle != 2)
				{
				//	ResetChaosKahmlsteinWeapon(npc, 1);
					npc.m_bisWalking = false;
					npc.m_iChanged_WalkCycle = 2;
					npc.SetActivity("ACT_MP_JUMP_FLOAT_MELEE");
					npc.StartPathing();
					if(IsValidEntity(npc.m_iWearable1))
						RemoveEntity(npc.m_iWearable1);
				}	
			}
		}
		case 0: //Melee
		{
			if (npc.IsOnGround())
			{
				if(npc.m_iChanged_WalkCycle != 3)
				{
				//	ResetChaosKahmlsteinWeapon(npc, 0);
					npc.m_bisWalking = true;
					npc.m_iChanged_WalkCycle = 3;
					npc.SetActivity("ACT_MP_RUN_MELEE");
					npc.StartPathing();
					if(!IsValidEntity(npc.m_iWearable1))
					{
						npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_fists_of_steel/c_fists_of_steel.mdl");
						SetVariantString("1.0");
						AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
					}
				}	
			}
			else
			{
				if(npc.m_iChanged_WalkCycle != 4)
				{
				//	ResetChaosKahmlsteinWeapon(npc, 0);
					npc.m_bisWalking = false;
					npc.m_iChanged_WalkCycle = 4;
					npc.SetActivity("ACT_MP_JUMP_FLOAT_MELEE");
					npc.StartPathing();
					if(!IsValidEntity(npc.m_iWearable1))
					{
						npc.m_iWearable1 = npc.EquipItem("head", "models/weapons/c_models/c_fists_of_steel/c_fists_of_steel.mdl");
						SetVariantString("1.0");
						AcceptEntityInput(npc.m_iWearable1, "SetModelScale");
					}
				}	
			}
		}
	}

}

int ChaosKahmlsteinSelfDefense(ChaosKahmlstein npc, float gameTime, int target, float distance)
{
	if(npc.i_GunMode == 1)
	{
		if(gameTime > npc.m_flNextMeleeAttack)
		{
			if(distance < (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 20.5))
			{
				int Enemy_I_See = Can_I_See_Enemy(npc.index, npc.m_iTarget);
						
				if(IsValidEnemy(npc.index, Enemy_I_See))
				{
					npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE",true, 0.09, _, 4.0 * f_MessengerSpeedUp[npc.index]);
					npc.m_iTarget = Enemy_I_See;
					npc.PlayRangedSound();
					float vecTarget[3]; vecTarget = WorldSpaceCenterOld(target);
					npc.FaceTowards(vecTarget, 20000.0);
					int projectile;
					float Proj_Damage = 10.0 * RaidModeScaling;
					vecTarget[0] += GetRandomFloat(-10.0, 10.0);
					vecTarget[1] += GetRandomFloat(-10.0, 10.0);
					vecTarget[2] += GetRandomFloat(-10.0, 10.0);
					switch(GetRandomInt(1,2))
					{
						case 1:
						{
							projectile = npc.FireParticleRocket(vecTarget, Proj_Damage, 1200.0, 150.0, "raygun_projectile_blue_crit", false);
						}
						case 2:
						{
							projectile = npc.FireParticleRocket(vecTarget, Proj_Damage, 1200.0, 150.0, "raygun_projectile_red_crit", false);
						}
					}
			
					SDKUnhook(projectile, SDKHook_StartTouch, Rocket_Particle_StartTouch);
					int particle = EntRefToEntIndex(i_rocket_particle[projectile]);
					CreateTimer(3.5, Timer_RemoveEntity, EntIndexToEntRef(projectile), TIMER_FLAG_NO_MAPCHANGE);
					CreateTimer(3.5, Timer_RemoveEntity, EntIndexToEntRef(particle), TIMER_FLAG_NO_MAPCHANGE);
					
					SDKHook(projectile, SDKHook_StartTouch, TheMessenger_Rocket_Particle_StartTouch);		
					
				}
				if(distance > (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 5.5))
				{
					//target is too far, try to close in
					return 0;
				}
				else if(distance < (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 2.5))
				{
					if(Can_I_See_Enemy_Only(npc.index, target))
					{
						//target is too close, try to keep distance
						return 1;
					}
				}
				return 0;
			}
			else
			{
				if(distance > (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 5.5))
				{
					//target is too far, try to close in
					return 0;
				}
				else if(distance < (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 2.5))
				{
					if(Can_I_See_Enemy_Only(npc.index, target))
					{
						//target is too close, try to keep distance
						return 1;
					}
				}
			}
		}
		else
		{
			if(distance > (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 5.5))
			{
				//target is too far, try to close in
				return 0;
			}
			else if(distance < (NORMAL_ENEMY_MELEE_RANGE_FLOAT_SQUARED * 2.5))
			{
				if(Can_I_See_Enemy_Only(npc.index, target))
				{
					//target is too close, try to keep distance
					return 1;
				}
			}
		}
	}
	else if(npc.m_flAttackHappens)
	{
		if(npc.m_flAttackHappens < GetGameTime(npc.index))
		{
			npc.m_flAttackHappens = 0.0;
			
			if(IsValidEnemy(npc.index, target))
			{
				int HowManyEnemeisAoeMelee = 64;
				Handle swingTrace;
				npc.FaceTowards(WorldSpaceCenterOld(npc.m_iTarget), 15000.0);
				npc.DoSwingTrace(swingTrace, npc.m_iTarget,_,_,_,1,_,HowManyEnemeisAoeMelee);
				delete swingTrace;
				bool PlaySound = false;
				for (int counter = 1; counter <= HowManyEnemeisAoeMelee; counter++)
				{
					if (i_EntitiesHitAoeSwing_NpcSwing[counter] > 0)
					{
						if(IsValidEntity(i_EntitiesHitAoeSwing_NpcSwing[counter]))
						{
							PlaySound = true;
							int targetTrace = i_EntitiesHitAoeSwing_NpcSwing[counter];
							float vecHit[3];
							vecHit = WorldSpaceCenterOld(targetTrace);

							float damage = 24.0;
							damage *= 1.2;

							SDKHooks_TakeDamage(targetTrace, npc.index, npc.index, damage * RaidModeScaling, DMG_CLUB, -1, _, vecHit);								
								
							
							// Hit particle
							
							bool Knocked = false;
										
							if(IsValidClient(targetTrace))
							{
								if (IsInvuln(targetTrace))
								{
									Knocked = true;
									Custom_Knockback(npc.index, targetTrace, 900.0, true);
									if(!NpcStats_IsEnemySilenced(npc.index))
									{
										TF2_AddCondition(targetTrace, TFCond_LostFooting, 0.5);
										TF2_AddCondition(targetTrace, TFCond_AirCurrent, 0.5);
									}
								}
								else
								{
									if(!NpcStats_IsEnemySilenced(npc.index))
									{
										TF2_AddCondition(targetTrace, TFCond_LostFooting, 0.5);
										TF2_AddCondition(targetTrace, TFCond_AirCurrent, 0.5);
									}
								}
							}

							Sakratan_AddNeuralDamage(targetTrace, npc.index, 100, true, true);

							if(!Knocked)
								Custom_Knockback(npc.index, targetTrace, 650.0); 
						} 
					}
				}
				if(PlaySound)
				{
					npc.PlayMeleeHitSound();
				}
			}
		}
	}
	//Melee attack, last prio
	else if(GetGameTime(npc.index) > npc.m_flNextMeleeAttack)
	{
		if(IsValidEnemy(npc.index, target)) 
		{
			if(distance < (GIANT_ENEMY_MELEE_RANGE_FLOAT_SQUARED))
			{
				int Enemy_I_See;
									
				Enemy_I_See = Can_I_See_Enemy(npc.index, target);
						
				if(IsValidEntity(Enemy_I_See) && IsValidEnemy(npc.index, Enemy_I_See))
				{
					target = Enemy_I_See;

					npc.PlayMeleeSound();
					npc.AddGesture("ACT_MP_ATTACK_STAND_MELEE",true, 1.0, _, f_MessengerSpeedUp[npc.index]);
							
					npc.m_flAttackHappens = gameTime + (0.25 * (1.0 / f_MessengerSpeedUp[npc.index]));
					npc.m_flNextMeleeAttack = gameTime + (0.7 * (1.0 / f_MessengerSpeedUp[npc.index]));
					npc.m_flDoingAnimation = gameTime + (0.25 * (1.0 / f_MessengerSpeedUp[npc.index]));
				}
			}
		}
		else
		{
			npc.m_flGetClosestTargetTime = 0.0;
			npc.m_iTarget = GetClosestTarget(npc.index);
		}	
	}
	return 0;
}

public void ChaosKahmlstein_OnTakeDamagePost(int victim, int attacker, int inflictor, float damage, int damagetype) 
{
	ChaosKahmlstein npc = view_as<ChaosKahmlstein>(victim);
	if(npc.g_TimesSummoned < 199)
	{
		int nextLoss = (GetEntProp(npc.index, Prop_Data, "m_iMaxHealth") / 10) * (199 - npc.g_TimesSummoned) / 200;
		if((GetEntProp(npc.index, Prop_Data, "m_iHealth") / 10) < nextLoss)
		{
			npc.g_TimesSummoned++;
			if((npc.g_TimesSummoned % 25) == 0)
			{
				RaidModeScaling *= 1.05;
				switch(GetRandomInt(0,3))
				{
					case 0:
					{
						CPrintToChatAll("{darkblue}Kahmlstein{default}: Thanks for the tickles.");
					}
					case 1:
					{
						CPrintToChatAll("{darkblue}Kahmlstein{default}: Oh no im so scared.");
					}
					case 2:
					{
						CPrintToChatAll("{darkblue}Kahmlstein{default}: Even bugs hit harder.");
					}
					case 3:
					{
						CPrintToChatAll("{darkblue}Kahmlstein{default}: Keep running, that'll help.");
					}
				}
				f_KahmlResTemp[npc.index] = GetGameTime() + 5.0;
			}
			npc.m_flNextChargeSpecialAttack -= 0.5;
			npc.m_flRangedSpecialDelay -= 0.5;
			npc.m_flCharge_delay -= 0.15;
		}
	}

	if((GetEntProp(npc.index, Prop_Data, "m_iMaxHealth")/4) >= GetEntProp(npc.index, Prop_Data, "m_iHealth") && !npc.Anger) //npc.Anger after half hp/400 hp
	{
		switch(GetRandomInt(0,3))
		{
			case 0:
			{
				CPrintToChatAll("{darkblue}Kahmlstein{default}: You should give it 200%.");
			}
			case 1:
			{
				CPrintToChatAll("{darkblue}Kahmlstein{default}: Pathetic.");
			}
			case 2:
			{
				CPrintToChatAll("{darkblue}Kahmlstein{default}: Such idiots.");
			}
			case 3:
			{
				CPrintToChatAll("{darkblue}Kahmlstein{default}: All your curelty, worse then states.");
			}
		}
		RaidModeScaling *= 1.2;
		npc.g_TimesSummoned = 100;
		npc.Anger = true;
		npc.m_flNextChargeSpecialAttack = GetGameTime(npc.index) + 0.0;
		npc.m_flRangedSpecialDelay = GetGameTime(npc.index) + 0.0;
		npc.m_flSpeed = 340.0;
	}
}



void CreateCloneTempKahmlsteinFakeout(int entity, int TypeOfFake, float SelfPos[3], float AllyAng[3])
{
	int KamlcloneSpawn;
	
	switch(TypeOfFake)
	{
		case 2:
		{
			KamlcloneSpawn = NPC_CreateById(RAIDMODE_CHAOS_KAHMLSTEIN, -1, SelfPos, AllyAng, GetTeam(entity), "fake_2"); //can only be enemy
		}
		case 3:
		{
			KamlcloneSpawn = NPC_CreateById(RAIDMODE_CHAOS_KAHMLSTEIN, -1, SelfPos, AllyAng, GetTeam(entity), "fake_3"); //can only be enemy
		}
		case 4:
		{
			KamlcloneSpawn = NPC_CreateById(RAIDMODE_CHAOS_KAHMLSTEIN, -1, SelfPos, AllyAng, GetTeam(entity), "fake_4"); //can only be enemy
		}
	}
	if(IsValidEntity(KamlcloneSpawn))
	{
		SetEntityCollisionGroup(KamlcloneSpawn, 1); //Dont Touch Anything.
		SetEntProp(KamlcloneSpawn, Prop_Send, "m_usSolidFlags", 12); 
		SetEntProp(KamlcloneSpawn, Prop_Data, "m_nSolidType", 6);
		b_DoNotUnStuck[KamlcloneSpawn] = true;
		b_ThisNpcIsImmuneToNuke[KamlcloneSpawn] = true;
		b_NoKnockbackFromSources[KamlcloneSpawn] = true;
		b_ThisEntityIgnored[KamlcloneSpawn] = true;
		b_thisNpcIsARaid[KamlcloneSpawn] = true;
		i_RaidGrantExtra[KamlcloneSpawn] = TypeOfFake;
		ChaosKahmlstein npc = view_as<ChaosKahmlstein>(KamlcloneSpawn);
		npc.m_iTargetAlly = entity;
		f_MessengerSpeedUp[KamlcloneSpawn] = f_MessengerSpeedUp[entity];
	}
}


#define KAHML_MELEE_SIZE 50
#define KAHML_MELEE_SIZE_F 50.0

static int SensalHitDetected_2[MAXENTITIES];

void KahmlsteinInitiatePunch(int entity, float VectorTarget[3], float VectorStart[3], float TimeUntillHit, float damage, bool kick, float RangeOfPunch)
{

	ChaosKahmlstein npc = view_as<ChaosKahmlstein>(entity);
	npc.PlayBobMeleePreHit();
	npc.FaceTowards(VectorTarget, 20000.0);
	int FramesUntillHit = RoundToNearest(TimeUntillHit * 66.0);

	float vecForward[3], Angles[3];

	GetVectorAnglesTwoPoints(VectorStart, VectorTarget, Angles);

	GetAngleVectors(Angles, vecForward, NULL_VECTOR, NULL_VECTOR);

	float VectorTarget_2[3];
	float VectorForward = RangeOfPunch; //a really high number.
	
	VectorTarget_2[0] = VectorStart[0] + vecForward[0] * VectorForward;
	VectorTarget_2[1] = VectorStart[1] + vecForward[1] * VectorForward;
	VectorTarget_2[2] = VectorStart[2] + vecForward[2] * VectorForward;


	int red = 25;
	int green = 25;
	int blue = 255;
	int Alpha = 255;

	int colorLayer4[4];
	float diameter = float(BOB_MELEE_SIZE * 4);
	SetColorRGBA(colorLayer4, red, green, blue, Alpha);
	//we set colours of the differnet laser effects to give it more of an effect
	int colorLayer1[4];
	SetColorRGBA(colorLayer1, colorLayer4[0] * 5 + 765 / 8, colorLayer4[1] * 5 + 765 / 8, colorLayer4[2] * 5 + 765 / 8, Alpha);
	int glowColor[4];

	for(int BeamCube = 0; BeamCube < 4 ; BeamCube++)
	{
		float OffsetFromMiddle[3];
		switch(BeamCube)
		{
			case 0:
			{
				OffsetFromMiddle = {0.0, BOB_MELEE_SIZE_F,BOB_MELEE_SIZE_F};
			}
			case 1:
			{
				OffsetFromMiddle = {0.0, -BOB_MELEE_SIZE_F,-BOB_MELEE_SIZE_F};
			}
			case 2:
			{
				OffsetFromMiddle = {0.0, BOB_MELEE_SIZE_F,-BOB_MELEE_SIZE_F};
			}
			case 3:
			{
				OffsetFromMiddle = {0.0, -BOB_MELEE_SIZE_F,BOB_MELEE_SIZE_F};
			}
		}
		float AnglesEdit[3];
		AnglesEdit[0] = Angles[0];
		AnglesEdit[1] = Angles[1];
		AnglesEdit[2] = Angles[2];

		float VectorStartEdit[3];
		VectorStartEdit[0] = VectorStart[0];
		VectorStartEdit[1] = VectorStart[1];
		VectorStartEdit[2] = VectorStart[2];

		float VectorStartEdit_2[3];
		VectorStartEdit_2[0] = VectorTarget_2[0];
		VectorStartEdit_2[1] = VectorTarget_2[1];
		VectorStartEdit_2[2] = VectorTarget_2[2];

		GetBeamDrawStartPoint_Stock(entity, VectorStartEdit,OffsetFromMiddle, AnglesEdit);
		GetBeamDrawStartPoint_Stock(entity, VectorStartEdit_2,OffsetFromMiddle, AnglesEdit);

		SetColorRGBA(glowColor, red, green, blue, Alpha);
		TE_SetupBeamPoints(VectorStartEdit, VectorStartEdit_2, Shared_BEAM_Laser, 0, 0, 0, TimeUntillHit, ClampBeamWidth(diameter * 0.1), ClampBeamWidth(diameter * 0.1), 0, 0.0, glowColor, 0);
		TE_SendToAll(0.0);
	}
	
	
	DataPack pack = new DataPack();
	pack.WriteCell(EntIndexToEntRef(entity));
	pack.WriteFloat(VectorTarget_2[0]);
	pack.WriteFloat(VectorTarget_2[1]);
	pack.WriteFloat(VectorTarget_2[2]);
	pack.WriteFloat(VectorStart[0]);
	pack.WriteFloat(VectorStart[1]);
	pack.WriteFloat(VectorStart[2]);
	pack.WriteFloat(damage);
	pack.WriteCell(kick);
	RequestFrames(KahmlsteinInitiatePunch_DamagePart, FramesUntillHit, pack);
}

void KahmlsteinInitiatePunch_DamagePart(DataPack pack)
{
	pack.Reset();
	int entity = EntRefToEntIndex(pack.ReadCell());
	if(!IsValidEntity(entity))
		entity = 0;

	for (int i = 1; i < MAXENTITIES; i++)
	{
		SensalHitDetected_2[i] = false;
	}
	float VectorTarget[3];
	float VectorStart[3];
	VectorTarget[0] = pack.ReadFloat();
	VectorTarget[1] = pack.ReadFloat();
	VectorTarget[2] = pack.ReadFloat();
	VectorStart[0] = pack.ReadFloat();
	VectorStart[1] = pack.ReadFloat();
	VectorStart[2] = pack.ReadFloat();
	float damagedata = pack.ReadFloat();
	bool kick = pack.ReadCell();

	int red = 50;
	int green = 50;
	int blue = 255;
	int Alpha = 222;
	int colorLayer4[4];

	float diameter = float(BOB_MELEE_SIZE * 4);
	SetColorRGBA(colorLayer4, red, green, blue, Alpha);
	//we set colours of the differnet laser effects to give it more of an effect
	int colorLayer1[4];
	SetColorRGBA(colorLayer1, colorLayer4[0] * 5 + 765 / 8, colorLayer4[1] * 5 + 765 / 8, colorLayer4[2] * 5 + 765 / 8, Alpha);
	TE_SetupBeamPoints(VectorStart, VectorTarget, Shared_BEAM_Laser, 0, 0, 0, 0.11, ClampBeamWidth(diameter * 0.5), ClampBeamWidth(diameter * 0.8), 0, 5.0, colorLayer1, 3);
	TE_SendToAll(0.0);
	TE_SetupBeamPoints(VectorStart, VectorTarget, Shared_BEAM_Laser, 0, 0, 0, 0.11, ClampBeamWidth(diameter * 0.4), ClampBeamWidth(diameter * 0.5), 0, 5.0, colorLayer1, 3);
	TE_SendToAll(0.0);
	TE_SetupBeamPoints(VectorStart, VectorTarget, Shared_BEAM_Laser, 0, 0, 0, 0.11, ClampBeamWidth(diameter * 0.3), ClampBeamWidth(diameter * 0.3), 0, 5.0, colorLayer1, 3);
	TE_SendToAll(0.0);

	float hullMin[3];
	float hullMax[3];
	hullMin[0] = -float(BOB_MELEE_SIZE);
	hullMin[1] = hullMin[0];
	hullMin[2] = hullMin[0];
	hullMax[0] = -hullMin[0];
	hullMax[1] = -hullMin[1];
	hullMax[2] = -hullMin[2];
	ChaosKahmlstein npc = view_as<ChaosKahmlstein>(entity);
	npc.PlayBobMeleePostHit();

	Handle trace;
	trace = TR_TraceHullFilterEx(VectorStart, VectorTarget, hullMin, hullMax, 1073741824, Sensal_BEAM_TraceUsers_3, entity);	// 1073741824 is CONTENTS_LADDER?
	delete trace;
			
	KillFeed_SetKillIcon(entity, kick ? "mantreads" : "fists");

	if(NpcStats_IsEnemySilenced(entity))
		kick = false;
	
	float playerPos[3];
	for (int victim = 1; victim < MAXENTITIES; victim++)
	{
		if (SensalHitDetected_2[victim] && GetTeam(entity) != GetTeam(victim))
		{
			GetEntPropVector(victim, Prop_Send, "m_vecOrigin", playerPos, 0);
			float damage = damagedata;

			if(victim > MaxClients) //make sure barracks units arent bad
				damage *= 0.5;

			SDKHooks_TakeDamage(victim, entity, entity, damage, DMG_CLUB, -1, NULL_VECTOR, playerPos);	// 2048 is DMG_NOGIB?
			
			if(kick)
			{
				if(victim <= MaxClients)
				{
					hullMin[0] = 0.0;
					hullMin[1] = 0.0;
					hullMin[2] = 400.0;
					TeleportEntity(victim, _, _, hullMin, true);
				}
				else if(!b_NpcHasDied[victim])
				{
					FreezeNpcInTime(victim, 1.5);
					
					hullMin = WorldSpaceCenterOld(victim);
					hullMin[2] += 100.0; //Jump up.
					PluginBot_Jump(victim, hullMin);
				}
			}
		}
	}
	delete pack;

	KillFeed_SetKillIcon(entity, "tf_projectile_rocket");
}


public bool Sensal_BEAM_TraceUsers_3(int entity, int contentsMask, int client)
{
	if (IsEntityAlive(entity))
	{
		SensalHitDetected_2[entity] = true;
	}
	return false;
}



bool Kahmlstein_Attack_TempPowerup(ChaosKahmlstein npc)
{
	if(!npc.m_flNextRangedBarrage_Spam && npc.m_flJumpCooldown < GetGameTime(npc.index))
	{
		npc.m_flJumpCooldown = GetGameTime(npc.index) + (35.0 * (1.0 / f_MessengerSpeedUp[npc.index]));
		NPC_StopPathing(npc.index);
		npc.m_bPathing = false;
		npc.AddActivityViaSequence("taunt_bare_knuckle_beatdown");
		npc.m_flAttackHappens = 0.0;
		npc.SetCycle(0.01);
		npc.SetPlaybackRate(f_MessengerSpeedUp[npc.index]);
		npc.m_flNextRangedBarrage_Singular = GetGameTime(npc.index) + (1.85 * (1.0 / f_MessengerSpeedUp[npc.index]));	
		npc.m_flDoingAnimation = GetGameTime(npc.index) + (1.85 * (1.0 / f_MessengerSpeedUp[npc.index]));	
		npc.m_iOverlordComboAttack = 0;
		npc.m_iChanged_WalkCycle = 0;
		npc.m_flNextRangedBarrage_Spam = GetGameTime(npc.index) + (10.0 * (1.0 / f_MessengerSpeedUp[npc.index]));
		EmitSoundToAll("mvm/mvm_tank_horn.wav");
	}
	if(npc.m_flNextRangedBarrage_Spam)
	{

		if(npc.m_flNextRangedBarrage_Spam < GetGameTime(npc.index))
		{
			if(i_RaidGrantExtra[npc.index] == 3)
			{
				SmiteNpcToDeath(npc.index);
			}
			npc.i_GunMode = 0;
			npc.m_flNextRangedBarrage_Spam = 0.0;
		}
	}
	if(npc.m_flNextRangedBarrage_Singular)
	{
		float TimeUntillOver = npc.m_flNextRangedBarrage_Singular - GetGameTime(npc.index);

		if(TimeUntillOver < (1.2 * (1.0 / f_MessengerSpeedUp[npc.index])))
		{
			if(npc.m_iOverlordComboAttack != 1)
			{
				npc.m_iOverlordComboAttack = 1;
			}
		}
		if(npc.m_flNextRangedBarrage_Singular < GetGameTime(npc.index))
		{
			npc.i_GunMode = 1;
			npc.m_flNextRangedBarrage_Singular = 0.0;
			float SelfPos[3];
			GetEntPropVector(npc.index, Prop_Data, "m_vecAbsOrigin", SelfPos);
			float AllyAng[3];
			GetEntPropVector(npc.index, Prop_Data, "m_angRotation", AllyAng);
			CreateCloneTempKahmlsteinFakeout(npc.index, 3, SelfPos, AllyAng);
		}
		return true;
	}
	return false;
}


public void ChaosKahmlstein_Win(int entity)
{
	switch(GetRandomInt(0,2))
	{
		case 0:
		{
			CPrintToChatAll("{darkblue}Kahmlstein{default}: You are no more.");
		}
		case 1:
		{
			CPrintToChatAll("{darkblue}Kahmlstein{default}: Everything burns.");
		}
		case 2:
		{
			CPrintToChatAll("{darkblue}Kahmlstein{default}: Chaos shall reign.");
		}
	}
}