local _, aObj = ...
local _G = _G
-- This is a Library

local function skinDDL(frame)
	if frame.Border then
		aObj:removeBackdrop(frame.Border)
	end
	if frame.Backdrop then
		aObj:removeBackdrop(frame.Backdrop)
	end
	aObj:removeBackdrop(frame.MenuBackdrop)
	aObj:skinObject("frame", {obj=frame, ofs=-2})
end
local function skinDropDowns(lDD, ddPrefix)
	local maxLvl = 0
	if _G[ddPrefix .. 1] then
		skinDDL(_G[ddPrefix .. 1])
		maxlvl = 1
	end
	if _G[ddPrefix .. 2] then
		skinDDL(_G[ddPrefix .. 2])
		maxlvl = 2
	end
	aObj:SecureHook(lDD, "UIDropDownMenu_CreateFrames", function(this, _, _)
		for i = maxLvl + 1, _G.L_UIDROPDOWNMENU_MAXLEVELS do
			skinDDL(_G[ddPrefix .. i])
		end
		maxLvl = _G.L_UIDROPDOWNMENU_MAXLEVELS
	end)
end
aObj.libsToSkin["LibUIDropDownMenu-4.0"] = function(self) -- v 90100
	if self.initialized.LibUIDropDownMenu then return end
	self.initialized.LibUIDropDownMenu = true

	local lDD = _G.LibStub:GetLibrary("LibUIDropDownMenu-4.0", true)

	local ddPrefix = "L_DropDownList"
	if _G.IsAddOnLoaded("TLDRMissions") then
		ddPrefix = "L_TLDR_DropDownList"
	end

	if lDD then
		skinDropDowns(lDD, ddPrefix)
	end

end

aObj.libsToSkin["LibUIDropDownMenuQuestie-4.0"] = function(self) -- v 90080
	if self.initialized.LibUIDropDownMenuQuestie then return end
	self.initialized.LibUIDropDownMenuQuestie = true

	local lDD = _G.LibStub:GetLibrary("LibUIDropDownMenuQuestie-4.0", true)

	local ddPrefix = "L_DropDownListQuestie"
	if lDD then
		skinDropDowns(lDD, ddPrefix)
	end

end
