#include "navy_macros.h"

class CfgPatches {
    class Navy {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.0;
        requiredAddons[] = {"CBA_MAIN", "Admiral"};
        author[] = {"Winter", "ARK"};
        authorUrl = "https://github.com/Winter259";
    };
};

class Extended_PreInit_EventHandlers {
    class Navy {
        init = "[] call compile preProcessFileLineNumbers 'x\ark\addons\navy\navy_preinit.sqf';";
    };
};

#include "navy.h"