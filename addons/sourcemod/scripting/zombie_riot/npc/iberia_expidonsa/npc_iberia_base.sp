float f_MoraleBoostCurrent[MAXENTITIES];
float f_TimeSinceMoraleBoost[MAXENTITIES];
bool b_EntityHasthink[MAXENTITIES];

void IberiaEntityCreated(int entity)
{
	b_EntityHasthink[entity] = false;
	f_MoraleBoostCurrent[entity] = 0.0;
}
#define IBERIA_MAX_MORALE_ALLOWED 1000.0

int MoraleBoostLevelAt(int entity)
{
	int ReturnSet = 0;

	if(f_MoraleBoostCurrent[entity] >= 15.0)
		ReturnSet = 1;
	//Small morale boosting

	if(f_MoraleBoostCurrent[entity] >= 100.0)
		ReturnSet = 2;
	//Medium morale boosting

	if(f_MoraleBoostCurrent[entity] >= 250.0)
		ReturnSet = 3;
		
	//Big Morale boosting
	if(f_MoraleBoostCurrent[entity] >= 650.0)
		ReturnSet = 4;
	//MAX Morale boosting, any higher will do this.

	return ReturnSet;
}

void GiveEntityMoraleBoost(int giver, int entity, float MoraleValue)
{
	//We need to scale this with players, the less players,
	//the more morale they give, as theres more NPCS that give morale and its overall shorter
	//In this case, me might aswell re-use PlayerCountBuffScaling!

	//you cant morale boost buildings...
	if(i_NpcIsABuilding[entity])
		return;

	if(i_NpcInternalId[giver] != LighthouseGlobaID())
		MoraleValue *= PlayerCountBuffScaling;
	//dont scale if its the lighthouse.

	f_MoraleBoostCurrent[entity] += MoraleValue;
	f_TimeSinceMoraleBoost[entity] = GetGameTime() + 7.5;
	
	if(!b_EntityHasthink[entity])
	{
		b_EntityHasthink[entity] = true;
		if(entity <= MaxClients)
			SDKHook(entity, SDKHook_PostThink, MoraleLevelThink);
		else
			SDKHook(entity, SDKHook_Think, MoraleLevelThink);	
	}

	if(f_MoraleBoostCurrent[entity] >= IBERIA_MAX_MORALE_ALLOWED)
		f_MoraleBoostCurrent[entity] = IBERIA_MAX_MORALE_ALLOWED;
}

void MoraleLevelThink(int entity)
{
	if(f_TimeSinceMoraleBoost[entity] > GetGameTime())
		return;

	//lose morale dynamically
	f_MoraleBoostCurrent[entity] -= ((f_MoraleBoostCurrent[entity] * 0.005) * TickrateModify);
	f_MoraleBoostCurrent[entity] -= (0.05 * TickrateModify);

	if(f_MoraleBoostCurrent[entity] <= 0.0)
	{
		b_EntityHasthink[entity] = false;
		if(entity <= MaxClients)
			SDKUnhook(entity, SDKHook_PostThink, MoraleLevelThink);
		else
			SDKUnhook(entity, SDKHook_Think, MoraleLevelThink);	
	}
}


float EntityMoraleBoostReturn(int entity, int Mode)
{
	int CurrentMoraleAt = MoraleBoostLevelAt(entity);
	switch(Mode)
	{
		//case 1 is speed.
		case 1:
		{
			switch(CurrentMoraleAt)
			{
				case 1:
					return 1.05;
				case 2:
					return 1.1;
				case 3:
					return 1.15;
				case 4:
					return 1.35;
			}
		}
		//case 2 is damage bonus.
		case 2:
		{
			switch(CurrentMoraleAt)
			{
				case 1:
					return 0.1;
				case 2:
					return 0.25;
				case 3:
					return 0.35;
				case 4:
					return 0.60;
			}
		}
		//case 3 is Resistance bonus.
		case 3:
		{
			switch(CurrentMoraleAt)
			{
				case 1:
					return 0.9;
				case 2:
					return 0.85;
				case 3:
					return 0.8;
				case 4:
					return 0.65;
			}
		}
	}

	return 1.0;
}


void MoraleIconShowHud(int entity, char[] HudChar, int HudSizeOf)
{
	int CurrentMoraleAt = MoraleBoostLevelAt(entity);
	switch(CurrentMoraleAt)
	{
		case 1:
			Format(HudChar, HudSizeOf, "%sW(1)",HudChar);
		case 2:
			Format(HudChar, HudSizeOf, "%sW(2)",HudChar);
		case 3:
			Format(HudChar, HudSizeOf, "%sW(3)",HudChar);
		case 4:
			Format(HudChar, HudSizeOf, "%sW(4)",HudChar);
	}
}


