#include "Navy_Macros.h"

#define REINFORCEMENT_AMOUNT 0

Navy_Timeline =
{
	["NATO_WOODLAND","B_Heli_Light_01_F",6,spawn_item,drop_item,cleanup_item,attack_item] spawn Navy_RunParadrop;
	sleep 10;
	["NATO_WOODLAND","B_Heli_Light_01_F",4,spawn_item,drop_item_1,cleanup_item,attack_item] spawn Navy_RunParadrop;
	sleep 10;
	["NATO_WOODLAND","B_Heli_Light_01_F",2,spawn_item,drop_item_2,cleanup_item,attack_item] spawn Navy_RunParadrop;
	sleep 10;
	["NATO_WOODLAND","B_Heli_Light_01_F",1,spawn_item,drop_item_3,cleanup_item,attack_item] spawn Navy_RunParadrop;
	DEBUG
	{
		[["Timeline finished running"]] call Navy_Debug_HintRPT;
	};
};

Navy_Reinforcement_1 =
{

};