local _, aObj = ...
local _G = _G
-- This is a Library

local function skinDDL(frame)
	if frame then
		if frame.Border then
			aObj:removeBackdrop(frame.Border)
		end
		if _G[frame:GetName() ..  "Backdrop"] then
			aObj:removeBackdrop(_G[frame:GetName() ..  "Backdrop"])
		end
		if _G[frame:GetName() ..  "MenuBackdrop"] then
			aObj:removeBackdrop(_G[frame:GetName() ..  "MenuBackdrop"])
			if _G[frame:GetName() ..  "MenuBackdrop"].NineSlice then
				aObj:removeNineSlice(_G[frame:GetName() ..  "MenuBackdrop"].NineSlice)
			end
		end
		aObj:skinObject("frame", {obj=frame, ofs=-4})
	end
end
local function skinAndHook(lDD, lVer)
	local ddPrefix = "L_DropDownList"
	if lVer == 90117 then -- Questie uses this
		ddPrefix = "L_DropDownListQuestie"
	elseif lVer == 90096 then -- TLDRMissions uses this
		ddPrefix = "L_TLDR_DropDownList"
	elseif lVer == 41 then -- Broker_Everything uses this
		ddPrefix = "LibDropDownMenu_List"
	end
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
			if lDD then
				skinAndHook(lDD, lVer)
			end
		end
	end
end
