local _, aObj = ...
local _G = _G
-- This is a Library

local fName, bdObj
local function skinDDL(frame)
	if frame then
		fName = frame:GetName()
		for _, backdrop in _G.pairs{"Border", "Backdrop", "MenuBackdrop"} do
			bdObj = frame[backdrop] or _G[fName .. backdrop]
			if bdObj then
				if bdObj.ApplyBackdrop then
					aObj:removeBackdrop(bdObj)
				else
					aObj:keepFontStrings(bdObj)
				end
				if bdObj.NineSlice then
					aObj:removeNineSlice(bdObj.NineSlice)
				end
			end
		end
		aObj:skinObject("frame", {obj=frame, kfs=true, ofs=-4})
	end
end
local ddPrefix
local function skinAndHook(lDD, lVer)
	if lVer == 90117 then -- Questie uses this
		ddPrefix = "L_DropDownListQuestie"
	elseif lVer == 90096 then -- TLDRMissions uses this
		ddPrefix = "L_TLDR_DropDownList"
	elseif lVer == 41 then -- Broker_Everything uses this
		ddPrefix = "LibDropDownMenu_List"
	else
		ddPrefix = "L_DropDownList"
	end
	aObj:Debug("skinAndHook: [%s, %s]", ddPrefix)
	for i = 1, 3 do
		if _G[ddPrefix .. i] then
			skinDDL(_G[ddPrefix .. i])
		end
	end
	aObj:SecureHook(lDD, "UIDropDownMenu_CreateFrames", function(_, level, _)
		for i = 1, level do
			skinDDL(_G[ddPrefix .. i])
		end
	end)
end

local libsToSkin = {
	"LibUIDropDownMenu-4.0",
	"LibUIDropDownMenuQuestie-4.0",
	"LibDropDownMenu",
}

do
	for _, lib in _G.pairs(libsToSkin) do
		aObj.libsToSkin[lib] = function(self)
			if self.initialized[lib] then return end
			self.initialized[lib] = true
			local lDD, lVer = _G.LibStub:GetLibrary(lib, true)
			aObj:Debug("LibUIDropDownMenu: [%s, %s, %s]", lib, lDD, lVer)
			if lDD then
				skinAndHook(lDD, lVer)
			end
		end
	end
end
