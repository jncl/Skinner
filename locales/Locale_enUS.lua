local aName, aObj = ...
local silent = false
--@debug@
silent = true
--@end-debug@

local L = LibStub:GetLibrary("AceLocale-3.0", true):NewLocale(aName, "enUS", true, silent)

if not L then return end

--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true)@
