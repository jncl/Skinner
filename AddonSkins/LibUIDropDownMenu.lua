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

aObj.libsToSkin["LibUIDropDownMenu-4.0"] = function(self) -- v 90100
	if self.initialized.LibUIDropDownMenu then return end
	self.initialized.LibUIDropDownMenu = true

	local lDD = _G.LibStub:GetLibrary("LibUIDropDownMenu-4.0", true)

	-- handle drop downs not yet created
	if lDD
	and not _G.L_DropDownList2
	then
		self.initialized.LibUIDropDownMenu = false
		return
	end

	if lDD then
		skinDDL(_G.L_DropDownList1)
		skinDDL(_G.L_DropDownList2)
		local maxLvl = _G.L_UIDROPDOWNMENU_MAXLEVELS
		self:SecureHook(lDD, "UIDropDownMenu_CreateFrames", function(this, _, _)
			for i = maxLvl + 1, _G.L_UIDROPDOWNMENU_MAXLEVELS do
				skinDDL(_G["L_DropDownList" .. i])
			end
			maxLvl = _G.L_UIDROPDOWNMENU_MAXLEVELS
		end)
	end

end

aObj.libsToSkin["LibUIDropDownMenuQuestie-4.0"] = function(self) -- v 90080
	if self.initialized.LibUIDropDownMenuQuestie then return end
	self.initialized.LibUIDropDownMenuQuestie = true

	local lDD = _G.LibStub:GetLibrary("LibUIDropDownMenuQuestie-4.0", true)

	if lDD then
		skinDDL(_G.L_DropDownListQuestie1)
		skinDDL(_G.L_DropDownListQuestie2)
		local maxLvl = _G.L_UIDROPDOWNMENUQUESTIE_MAXLEVELS
		self:SecureHook(lDD, "UIDropDownMenu_CreateFrames", function(this, _, _)
			for i = maxLvl + 1, _G.L_UIDROPDOWNMENUQUESTIE_MAXLEVELS do
				skinDDL(_G["L_DropDownListQuestie" .. i])
			end
			maxLvl = _G.L_UIDROPDOWNMENUQUESTIE_MAXLEVELS
		end)
	end

end
