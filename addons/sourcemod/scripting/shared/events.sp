#pragma semicolon 1
#pragma newdecls required

void Events_PluginStart()
{
	HookEvent("teamplay_round_start", OnRoundStart, EventHookMode_PostNoCopy);
	HookEvent("post_inventory_application", OnPlayerResupply, EventHookMode_Post);
	HookEvent("player_spawn", OnPlayerSpawn, EventHookMode_Post);
	HookEvent("player_death", OnPlayerDeath, EventHookMode_Pre);
	HookEvent("teamplay_broadcast_audio", OnBroadcast, EventHookMode_Pre);
	HookEvent("teamplay_win_panel", OnWinPanel, EventHookMode_Pre);
	HookEvent("player_team", OnPlayerTeam, EventHookMode_Pre);
	HookEvent("player_connect_client", OnPlayerConnect, EventHookMode_Pre);
	HookEvent("player_disconnect", OnPlayerConnect, EventHookMode_Pre);
	HookEvent("deploy_buff_banner", OnBannerDeploy, EventHookMode_Pre);
//	HookEvent("nav_blocked", NavBlocked, EventHookMode_Pre);
#if defined ZR
	HookEvent("teamplay_round_win", OnRoundEnd, EventHookMode_Pre);
	HookEvent("mvm_begin_wave", OnSetupFinished, EventHookMode_PostNoCopy);
	HookEvent("mvm_wave_failed", OnWinPanel, EventHookMode_Pre);
	HookEvent("mvm_mission_complete", OnWinPanel, EventHookMode_Pre);
	HookEvent("restart_timer_time", OnRestartTimer, EventHookMode_Pre);
#endif
	
	HookUserMessage(GetUserMessageId("SayText2"), Hook_BlockUserMessageEx, true);
	
	HookEntityOutput("logic_relay", "OnTrigger", OnRelayTrigger);
}

public void OnRoundStart(Event event, const char[] name, bool dontBroadcast)
{
#if defined ZR
	b_GameOnGoing = true;
	
	
	LastMann = false;
	Ammo_Count_Ready = 0;
	Zero(Ammo_Count_Used);
	Zero2(Armor_table_money_limit);
	Zero2(i_Healing_station_money_limit);
	Zero2(Perk_Machine_money_limit);
	Zero2(Pack_A_Punch_Machine_money_limit);
	Zero(Healing_done_in_total);
	Zero(Damage_dealt_in_total);
	Zero(Resupplies_Supplied);
	Zero(i_BarricadeHasBeenDamaged);
	Zero(i_ExtraPlayerPoints);
	WaveStart_SubWaveStart(GetGameTime());
	CurrentGibCount = 0;
	for(int client=1; client<=MaxClients; client++)
	{
		for(int i; i<Ammo_MAX; i++)
		{
			CurrentAmmo[client][i] = CurrentAmmo[0][i];
		}	
	}
	
	CreateMVMPopulator();
	
	if(RoundStartTime > GetGameTime())
		return;
	
	RoundStartTime = GetGameTime()+0.1;
	
	Escape_RoundStart();
	Waves_RoundStart();
	Blacksmith_RoundStart();
	Merchant_RoundStart();
#endif

#if defined RPG
	Zones_RoundStart();
#endif

#if defined RPG || defined RTS
	ServerCommand("mp_waitingforplayers_cancel 1");
#endif
}

#if defined ZR
public void OnSetupFinished(Event event, const char[] name, bool dontBroadcast)
{
	for(int client=1; client<=MaxClients; client++)
	{
		SetMusicTimer(client, 0);
	}
	BuildingVoteEndResetCD();
	Waves_SetReadyStatus(0);
	Waves_Progress();
}
#endif

public Action OnPlayerTeam(Event event, const char[] name, bool dontBroadcast)
{
	if(event.GetBool("autoteam"))
	{
		int client = GetClientOfUserId(event.GetInt("userid"));
		if(client)
		{
			ChangeClientTeam(client, 3);
			OnAutoTeam(client, name, 0);
		}
	}
	
	if(event.GetBool("silent"))
		return Plugin_Continue;
	
	event.BroadcastDisabled = true;
	return Plugin_Changed;
}

public Action OnBannerDeploy(Event event, const char[] name, bool dontBroadcast)
{
	return Plugin_Handled;
}

public Action OnPlayerConnect(Event event, const char[] name, bool dontBroadcast)
{
	if(!event.GetBool("bot"))
		return Plugin_Continue;
	
	event.BroadcastDisabled = true;
	return Plugin_Changed;
}

#if defined ZR
public Action OnRoundEnd(Event event, const char[] name, bool dontBroadcast)
{
	MVMHud_Disable();
	GameRules_SetProp("m_iRoundState", RoundState_TeamWin);
	Store_RandomizeNPCStore(1);
	f_FreeplayDamageExtra = 1.0;
	b_GameOnGoing = false;
	GlobalExtraCash = 0;
	for(int client=1; client<=MaxClients; client++)
	{
		if(IsClientInGame(client))
		{
			Escape_DropItem(client);
			Damage_dealt_in_total[client] = 0.0;
			Resupplies_Supplied[client] = 0;
			CashRecievedNonWave[client] = 0;
			Healing_done_in_total[client] = 0;
			Ammo_Count_Used[client] = 0;
			Armor_Charge[client] = 0;
			Building_ResetRewardValues(client);
		}
	}

	for(int client_check=1; client_check<=MaxClients; client_check++)
	{
		if(IsClientInGame(client_check) && TeutonType[client_check] != TEUTON_WAITING)
			TeutonType[client_check] = 0;
	}
	
	Store_Reset();
	Waves_RoundEnd();
	Escape_RoundEnd();
	Rogue_RoundEnd();
	CurrentGame = 0;
	if(event != INVALID_HANDLE && event.GetInt("team") == 3)
	{
		//enemy team won due to timer or something else.
		ZR_NpcTauntWin();
	}
	return Plugin_Continue;
}
#endif

public void OnPlayerResupply(Event event, const char[] name, bool dontBroadcast)
{
	int userid = event.GetInt("userid");
	int client = GetClientOfUserId(userid);
	if(client)
	{
#if defined ZR
		TransferDispenserBackToOtherEntity(client, true);
#endif
#if defined RPG
		TextStore_DepositBackpack(client, false, Level[client] < 5);
#endif

		ForcePlayerCrouch(client, false);

#if defined RTS
		RTS_PlayerResupply(client);
#else
		TF2_RemoveAllWeapons(client); //Remove all weapons. No matter what.
		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 1.0);
		SetVariantString("");
	  	AcceptEntityInput(client, "SetCustomModel");

		CurrentClass[client] = view_as<TFClassType>(GetEntProp(client, Prop_Send, "m_iDesiredPlayerClass"));

		ViewChange_DeleteHands(client);
		ViewChange_UpdateHands(client, CurrentClass[client]);
		TF2_SetPlayerClass_ZR(client, CurrentClass[client], false, false);

		if(b_HideCosmeticsPlayer[client])
		{
		  	int entity = MaxClients+1;
			while(TF2_GetWearable(client, entity))
			{
				SetEntProp(entity, Prop_Send, "m_fEffects", GetEntProp(entity, Prop_Send, "m_fEffects") | EF_NODRAW);
			}
		}
#endif

#if defined ZR
		//DEFAULTS
		if(dieingstate[client] == 0)
		{
			b_ThisEntityIgnored[client] = false;
		}
	  	//DEFAULTS
		
		if(WaitingInQueue[client])
			TeutonType[client] = TEUTON_WAITING;

		if(i_ClientHasCustomGearEquipped[client])
		{
			SetAmmo(client, 1, 9999);
			SetAmmo(client, 2, 9999);
			SetAmmo(client, Ammo_Metal, CurrentAmmo[client][Ammo_Metal]);
			SetAmmo(client, Ammo_Jar, 1);
			for(int i=Ammo_Pistol; i<Ammo_MAX; i++)
			{
				SetAmmo(client, i, CurrentAmmo[client][i]);
			}

			ViewChange_PlayerModel(client);
			return;
		}
		
		if(TeutonType[client] != TEUTON_NONE)
		{
			FakeClientCommand(client, "menuselect 0");
			SDKHook(client, SDKHook_GetMaxHealth, OnTeutonHealth);
			SetEntityRenderMode(client, RENDER_NORMAL);
			SetEntityRenderColor(client, 255, 255, 255, 255);
			
			int entity = MaxClients+1;
			while(TF2_GetWearable(client, entity))
			{
				TF2_RemoveWearable(client, entity);
			}
			ViewChange_PlayerModel(client);
			
			TF2Attrib_RemoveAll(client);
			Attributes_Set(client, 68, -1.0);
			SetVariantString(COMBINE_CUSTOM_MODEL);
	  		AcceptEntityInput(client, "SetCustomModel");
	   		SetEntProp(client, Prop_Send, "m_bUseClassAnimations", true);
	   		
	   		b_ThisEntityIgnored[client] = true;
			
	   		int weapon_index = Store_GiveSpecificItem(client, "Teutonic Longsword");
		//	SetEntProp(client, Prop_Send, "m_nBody", 1);
			SetVariantInt(1);
			AcceptEntityInput(client, "SetBodyGroup");
			//apply model correctly.


	   		ViewChange_Switch(client, weapon_index, "tf_weapon_sword");

	   		TF2Attrib_RemoveAll(weapon_index);
	   		
	   		float damage = 1.0;
			
			if(TeutonType[client] == TEUTON_WAITING)
			{
				damage *= 0.65;
			}
			
	   		Attributes_Set(weapon_index, 2, damage);
	   		Attributes_Set(weapon_index, 264, 0.0);
	   		Attributes_Set(weapon_index, 263, 0.0);
	   		Attributes_Set(weapon_index, 6, 1.2);
	   		Attributes_Set(weapon_index, 412, 0.0);
	   		Attributes_Set(weapon_index, 442, 1.1);
	   		TFClassType ClassForStats = WeaponClass[client];
	   		
	   		Attributes_Set(weapon_index, 107, RemoveExtraSpeed(ClassForStats, 330.0));
	   		Attributes_Set(weapon_index, 476, 0.0);
	   		SetEntityCollisionGroup(client, 1);
	   		SetEntityCollisionGroup(weapon_index, 1);
	   		
	   		int wearable;
	   		
	   		wearable = GiveWearable(client, 30727);
	   		
	   		SetEntPropFloat(wearable, Prop_Send, "m_flModelScale", 0.9);
	   		
	   		wearable = GiveWearable(client, 30969);
	   		
	   		SetEntPropFloat(wearable, Prop_Send, "m_flModelScale", 1.25);
	   		
	   		SetEntPropFloat(weapon_index, Prop_Send, "m_flModelScale", 0.8);
	   		SetEntPropFloat(client, Prop_Send, "m_flModelScale", 0.7);
	   		
			SetAmmo(client, 1, 9999);
			SetAmmo(client, 2, 9999);
	   		SetAmmo(client, Ammo_Metal, CurrentAmmo[client][Ammo_Metal]);
			SetAmmo(client, Ammo_Jar, 1);
			for(int i=Ammo_Pistol; i<Ammo_MAX; i++)
			{
				SetAmmo(client, i, CurrentAmmo[client][i]);
			}
	   		
		}
		else
		{
			int entity = MaxClients+1;
			while(TF2_GetWearable(client, entity))
			{
				switch(GetEntProp(entity, Prop_Send, "m_iItemDefinitionIndex"))
				{
					case 57, 131, 133, 231, 405, 406, 444, 608, 642, 1099, 1144:
						TF2_RemoveWearable(client, entity);
				}
			}
			
			ViewChange_PlayerModel(client);
			Store_ApplyAttribs(client);
			Pets_PlayerResupply(client);
			
			if(dieingstate[client])
			{
			}
			else
			{
				Store_GiveAll(client, Waves_GetRound()>1 ? 50 : 300); //give 300 hp instead of 200 in escape.
			}
			
			SetAmmo(client, 1, 9999);
			SetAmmo(client, 2, 9999);
			SetAmmo(client, Ammo_Metal, CurrentAmmo[client][Ammo_Metal]);
			SetAmmo(client, Ammo_Jar, 1);
			for(int i=Ammo_Pistol; i<Ammo_MAX; i++)
			{
				SetAmmo(client, i, CurrentAmmo[client][i]);
			}
			
			PrintHintText(client, "%T", "Open Store", client);
		}
#endif

#if defined RPG
		int entity = MaxClients+1;
		while(TF2_GetWearable(client, entity))
		{
			switch(GetEntProp(entity, Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 57, 131, 133, 231, 405, 406, 444, 608, 642, 1099, 1144:
					TF2_RemoveWearable(client, entity);
			}
		}
		
		ViewChange_PlayerModel(client);
		Store_ApplyAttribs(client);
		Store_GiveAll(client, 1);
		
		SetAmmo(client, 1, 9999);
		SetAmmo(client, 2, 9999);
		SetAmmo(client, Ammo_Metal, 9999);
		SetAmmo(client, Ammo_Jar, 1);
		for(int i=Ammo_Pistol; i<Ammo_MAX; i++)
		{
			SetAmmo(client, i, 9999);
		}
		//In RPG Ammo is infinite and used in a different way.
		UpdateLevelAbovePlayerText(client);

		RequestFrame(UpdateHealthFrame, userid);
#endif
	}
}

#if defined RPG
public void UpdateHealthFrame(int userid)
{
	int client = GetClientOfUserId(userid);
	if(client)
		SetEntityHealth(client, SDKCall_GetMaxHealth(client));
}
#endif

#if defined ZR
public Action OnTeutonHealth(int client, int &health)
{
	if(TeutonType[client])
	{
		SetEntityHealth(client, 1);
		health = 1;
		return Plugin_Changed;
	}
	
	SDKUnhook(client, SDKHook_GetMaxHealth, OnTeutonHealth);
	return Plugin_Continue;
}
#endif

public void OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(client)
	{
		
#if defined ZR
		Waves_PlayerSpawn(client);
#endif

#if defined ZR || defined RPG
		Thirdperson_PlayerSpawn(client);
#endif
		/*
		// Resets the hand/arm pos for melee weapons 
		//it doesnt do it on its own, and weapon such as the song of the ocean due to this
		//come out from behind and it litterally looks like a dick
		//Im unsure why this happens, something with the hothand probably as it looks like that.
		CClotBody npc = view_as<CClotBody>(client);
		int index = npc.LookupPoseParameter("r_hand_grip");
		if(index >= 0)
			npc.SetPoseParameter(index, 0.0);
		
		index = npc.LookupPoseParameter("r_arm");
		if(index >= 0)
			npc.SetPoseParameter(index, 0.0);

			THis now crashes in 64bit? perhaps?
		*/
	}
}

public Action OnPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(!client)
		return Plugin_Continue;
	
#if defined ZR || defined RPG
	TF2_SetPlayerClass_ZR(client, CurrentClass[client], false, false);
#endif

#if defined ZR
	KillFeed_Show(client, event.GetInt("inflictor_entindex"), EntRefToEntIndex(LastHitRef[client]), dieingstate[client] ? -69 : 0, event.GetInt("weaponid"), event.GetInt("damagebits"));
#elseif defined RPG
	KillFeed_Show(client, event.GetInt("inflictor_entindex"), EntRefToEntIndex(LastHitRef[client]), 0, event.GetInt("weaponid"), event.GetInt("damagebits"));
#endif

#if defined ZR
	UnequipDispenser(client, true);
	ArmorDisplayClient(client, true);
	DataPack pack = new DataPack();
	pack.WriteCell(GetClientUserId(client));
	pack.WriteCell(-1);
	Update_Ammo(pack);
	Escape_DropItem(client);

	//Incase they die, do suit!
	if(!Rogue_Mode())
		i_CurrentEquippedPerk[client] = 0;
		
	i_HealthBeforeSuit[client] = 0;
	f_HealthBeforeSuittime[client] = GetGameTime() + 0.25;
	i_ClientHasCustomGearEquipped[client] = false;
	UnequipQuantumSet(client);
//	CreateTimer(0.0, QuantumDeactivate, EntIndexToEntRef(client), TIMER_FLAG_NO_MAPCHANGE); //early cancel out!, save the wearer!
	//

	Citizen_PlayerDeath(client);
	Bob_player_killed(event, name, dontBroadcast);
	Skulls_PlayerKilled(client);
	// Save current uber.
	ClientSaveUber(client);
#endif

#if defined RPG
	TextStore_DepositBackpack(client, true);
	UpdateLevelAbovePlayerText(client, true);
	De_TransformClient(client);
#endif

#if defined ZR || defined RPG
	Store_WeaponSwitch(client, -1);
	RequestFrame(CheckAlivePlayersforward, client); //REQUEST frame cus isaliveplayer doesnt even get applied yet in this function instantly, so wait 1 frame
#endif

	event.BroadcastDisabled = true;
	return Plugin_Changed;
}

public Action OnBroadcast(Event event, const char[] name, bool dontBroadcast)
{
	static char sound[PLATFORM_MAX_PATH];
	event.GetString("sound", sound, sizeof(sound));
	if(!StrContains(sound, "Game.Your", false) || !StrContains(sound, "Game.Stalemate", false) || !StrContains(sound, "Announcer.", false))
		return Plugin_Handled;

	return Plugin_Continue;
}

public Action OnWinPanel(Event event, const char[] name, bool dontBroadcast)
{
	return Plugin_Handled;
}

public Action OnRestartTimer(Event event, const char[] name, bool dontBroadcast)
{
	if(event.GetInt("time") != 9)
		return Plugin_Continue;
	
	event.BroadcastDisabled = true;
	return Plugin_Changed;
}

/*
public Action NavBlocked(Event event, const char[] name, bool dontBroadcast)
{
	PrintHintText(1, "t");
	
	int area = event.GetInt("area");
	bool blocked = event.GetBool("blocked");
	if(blocked)
	{
		PrintToChatAll("%i", area);
	}
	
	return Plugin_Stop;
}
*/

public Action Hook_BlockUserMessageEx(UserMsg msg_id, BfRead msg, const int[] players, int playersNum, bool reliable, bool init)
{
	char message[32];
	msg.ReadByte();
	msg.ReadByte();
	msg.ReadString(message, sizeof(message));
	
	if(strcmp(message, "#TF_Name_Change") == 0)
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action OnRelayTrigger(const char[] output, int entity, int caller, float delay)
{
	char name[32];
	GetEntPropString(entity, Prop_Data, "m_iName", name, sizeof(name));
	if(!StrContains(name, "nav_reloader", false)) //Sometimes blocking shit doesnt work.
	{
		UpdateBlockedNavmesh();
	}
#if defined ZR
	else if(!StrContains(name, "zr_respawn", false))
	{
		for(int client=1; client<=MaxClients; client++)
		{
			if(IsClientInGame(client))
			{
				DoOverlay(client, "", 2);
				if(GetClientTeam(client)==2)
				{
					if(!IsPlayerAlive(client) || TeutonType[client] == TEUTON_DEAD)
					{
						DHook_RespawnPlayer(client);
					}
					else if(dieingstate[client] > 0)
					{
						dieingstate[client] = 0;
						Store_ApplyAttribs(client);
						TF2_AddCondition(client, TFCond_SpeedBuffAlly, 0.00001);
						int entity_wearable, i;
						while(TF2U_GetWearable(client, entity_wearable, i))
						{
							if(entity == EntRefToEntIndex(Armor_Wearable[client]) || i_WeaponVMTExtraSetting[entity_wearable] != -1)
								continue;

							SetEntityRenderMode(entity_wearable, RENDER_NORMAL);
							SetEntityRenderColor(entity_wearable, 255, 255, 255, 255);
						}
						SetEntityRenderMode(client, RENDER_NORMAL);
						SetEntityRenderColor(client, 255, 255, 255, 255);
						SetEntityCollisionGroup(client, 5);
						SetEntityHealth(client, SDKCall_GetMaxHealth(client));
					}
				}
			}
		}
		
		CheckAlivePlayers();
	}
	else if(!StrContains(name, "zr_cash_", false))
	{
		char buffers[4][12];
		ExplodeString(name, "_", buffers, sizeof(buffers), sizeof(buffers[]));
		
		int cash = StringToInt(buffers[2]);
		CurrentCash += cash;
		PrintToChatAll("Gained %d cash!", cash);
	}
#endif

	// DO NOT DO 
	// return Plugin_Handled;!!!!!!
	//This breaks maps.
	return Plugin_Continue;
}
/*
#if defined ZR
public Action OnRelayFireUser1(const char[] output, int entity, int caller, float delay)
{
	int client = caller;
	if(client > MaxClients)
		client = GetOwnerLoop(client);

	if(client > 0 && client <= MaxClients)
	{


		char name[32];
		GetEntPropString(entity, Prop_Data, "m_iName", name, sizeof(name));

		if(!StrContains(name, "zr_cash_", false))
		{
			float gameTime = GetGameTime();
			if(GiveCashDelay[client] > gameTime)
				return Plugin_Continue;
		
			GiveCashDelay[client] = gameTime + 0.5;

			char buffers[4][12];
			ExplodeString(name, "_", buffers, sizeof(buffers), sizeof(buffers[]));
			
			int cash = StringToInt(buffers[2]);
			CashSpent[client] -= cash;
			CashRecievedNonWave[client] += cash;
			
			PrintToChat(client, "Gained %d cash!", cash);
		}
	}
	// DO NOT DO 
	// return Plugin_Handled;!!!!!!
	//This breaks maps.
	return Plugin_Continue;
}
#endif*/