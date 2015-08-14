#include "Navy_Macros.h"

Navy_Debug_Init =
{
	Navy_Debug_Markers = [];
	[["Navy Debug successfully initialised."]] call Navy_Debug_SideChatRPT;
};

Navy_Debug_HintRPT =
{
	FUN_ARGS_1(_message);
	[_message] call Navy_Debug_RPT;
	[_message,false] call Navy_Debug_Hint;
};

Navy_Debug_SideChatRPT =
{
	FUN_ARGS_1(_message);
	[_message] call Navy_Debug_RPT;
	[_message] call Navy_Debug_SideChat;
};

Navy_Debug_RPT =
{
	FUN_ARGS_1(_message);
	if (DEBUG_RPT) then
	{
		diag_log format ["%1%2",DEBUG_HEADER,format _message];
	};
};

Navy_Debug_Hint =
{
	FUN_ARGS_2(_message,_silent);
	// _silent parameter: decided whether hint or hintSilent is used. Default is true
	if (DEBUG_HINTS) then
	{
		if (isNil "_silent") then
		{
			_silent = true;
		};
		if (_silent) then
		{
			hintSilent format ["%1%2",DEBUG_HEADER,format _message];
		}
		else
		{
			hint format ["%1%2",DEBUG_HEADER,format _message];
		};
	};
};

Navy_Debug_SideChat =
{
	FUN_ARGS_1(_message);
	if (DEBUG_SIDECHAT) then
	{
		player sideChat format ["%1%2",DEBUG_HEADER,format _message];
	};
};

Navy_Debug_ReturnConfigType =
{
	FUN_ARGS_1(_type);
	DECLARE(_string) = "";
	switch (_type) do
	{
		case CONFIG_TYPE_ARRAY: 	{_string = "ARRAY";};
		case CONFIG_TYPE_NUMBER: 	{_string = "NUMBER";};
		case CONFIG_TYPE_STRING: 	{_string = "STRING";};
	};
	_string;
};

Navy_Debug_DebugMarker =
{
	FUN_ARGS_4(_name_str,_position,_size,_text);
	if (isNil "_size") then
	{
		_size = [1,1];
	};
	DECLARE(_marker) = [_name_str,_position,"ICON","hd_dot","ColorRed",_size] call adm_common_fnc_createLocalMarker;
	_marker setMarkerTextLocal format _text;
};

Navy_Debug_WaypointMarker =
{
	FUN_ARGS_3(_name_str,_position,_text);
	[_name_str,_position,DEBUG_MARKER_SIZE_WAYPOINT,_text] call Navy_Debug_DebugMarker;
};

Navy_Debug_InitMarker =
{
	FUN_ARGS_2(_unit,_vehicle);
	PVT_5(_vehicle_str,_marker_name,_marker_counter,_marker_colour,_marker_size);
	if (_vehicle) then
	{
		_vehicle_str = "Vehi";
		_marker_colour = DEBUG_MARKER_COLOUR_VEHICLE;
		_marker_size = DEBUG_MARKER_SIZE_VEHICLE;
		_marker_counter = Navy_Vehicle_Counter;
		
	}
	else
	{
		_vehicle_str = "Unit";
		_marker_colour = DEBUG_MARKER_COLOUR_UNIT;
		_marker_size = DEBUG_MARKER_SIZE_UNIT;
		_marker_counter = Navy_Unit_Counter;
	};
	_marker_name = format ["Navy_%1_%2",_vehicle_str,_marker_counter];
	[_marker_name,getposATL _unit,"ICON","mil_triangle_noShadow",_marker_colour,_marker_size] call adm_common_fnc_createLocalMarker;
	Navy_Debug_Markers pushBack _marker_name;
	_marker_name;
};

Navy_Debug_DeleteMarker =
{
	FUN_ARGS_1(_marker_name);
	REMOVE_ELEMENT(Navy_Debug_Markers,_marker_name);
	deleteMarkerLocal _marker_name;
};

Navy_Debug_TrackWithMarker =
{
	FUN_ARGS_3(_object,_vehicle,_delay);
	PVT_1(_pos_and_dir);
	if (_vehicle) then
	{
		_delay = DEBUG_MARKER_VEHI_DELAY;
	}
	else
	{
		_delay = DEBUG_MARKER_UNIT_DELAY;
		//WAIT_DELAY(1,(_object == (vehicle _object)) || !alive _object);
	};
	DECLARE(_marker_name) = [_object,_vehicle] call Navy_Debug_InitMarker;
	//_marker_name setMarkerTextLocal str(_marker_name);
	_marker_name setMarkerTextLocal _marker_name;
	while {alive _object} do
	{
		_pos_and_dir = [_object] call Navy_ReturnPosAndDir;
		_marker_name setMarkerPosLocal (_pos_and_dir select 0);
		_marker_name setMarkerDirLocal (_pos_and_dir select 1);
		sleep _delay;
	};
	[_marker_name] call Navy_Debug_DeleteMarker;
};

Navy_Debug_TrackVehicle =
{
	FUN_ARGS_1(_vehicle);
	[_vehicle,true] call Navy_Debug_TrackWithMarker;
};

Navy_Debug_TrackUnit =
{
	FUN_ARGS_1(_unit);
	[_unit,false] call Navy_Debug_TrackWithMarker;
};

Navy_Debug_SpawnZoneMarker =
{
	FUN_ARGS_1(_trigger);
	DECLARE(_area) = triggerArea _trigger; // [a, b, angle, rectangle]
	DECLARE(_position) = getPosATL _trigger; // [x,y,z]
	DECLARE(_marker_name) = format ["Navy_Spawn_%1",Navy_Spawn_Counter];
	DECLARE(_marker_shape) = "ELLIPSE";
	DECLARE(_marker_size) = [(_area select 0),(_area select 1)];
	if ((_area select 3)) then
	{
		_marker_shape = "RECTANGLE";
	};
	[_marker_name,_position,_marker_shape,"Empty","ColorBlue",_marker_size] call adm_common_fnc_createLocalMarker;
	_marker_name setMarkerDirLocal (_area select 2);
	_marker_name setMarkerBrushLocal "Border";
	Navy_Spawn_Markers pushBack _marker_name;
	INC(Navy_Spawn_Counter);
	[["Spawn Trigger created at position %1 with a: %2 b: %3 angle: %4 rectangle: %5",_position,(_area select 0),(_area select 1),(_area select 2),(_area select 3),(_area select 4)]] call Navy_Debug_HintRPT;
};

Navy_Debug_HintCurrentNavyUnits =
{
	while {true} do
	{
		hintSilent format ["TIME: %1\nNavy Units:\n%2\nNavy Vehicles:\n%3\nNavy Cargo Groups:\n%4",time,Navy_Units,Navy_Vehicles,Navy_Cargo_Unit_Groups];
		sleep 0.2;
	};
};

Navy_Debug_TrackCurrentWaypoints = 
{
	FUN_ARGS_1(_unit);
	PVT_2(_waypoint_list,_current_waypoint);
	while {alive _unit} do
	{
		_waypoint_list = waypoints (group _unit);
		_current_waypoint = currentWaypoint (group _unit);
		hintSilent format ["TIME: %1\nUnit: %2\nGroup: %3\nCurrent Waypoint: %4\nWaypoint list;\n%5",time,_unit,(group _unit),_current_waypoint,_waypoint_list];
		sleep 0.2;
	};
	hint format ["%1 is no longer alive.",_unit];
};