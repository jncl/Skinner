local _, aObj = ...
local _G = _G
-- This is a Library

local function skinDDL(frame)
	if frame
	and not frame.sf
	then
		if frame.Border then
			aObj:removeBackdrop(frame.Border)
		end
		if frame.Backdrop then
			aObj:removeBackdrop(frame.Backdrop)
		end
		aObj:removeBackdrop(frame.MenuBackdrop)
		aObj:skinObject("frame", {obj=frame, ofs=-4})
	end
end
local function skinDropDowns(lDD, lVer)
	local ddPrefix = "L_DropDownList"
	if lVer == 90080 then
		ddPrefix = "L_DropDownListQuestie"
	elseif lVer == 90096 then
		ddPrefix = "L_TLDR_DropDownList"
	end
	if _G[ddPrefix .. 1] then
		skinDDL(_G[ddPrefix .. 1])
	end
	if _G[ddPrefix .. 2] then
		skinDDL(_G[ddPrefix .. 2])
	end
	aObj:SecureHook(lDD, "UIDropDownMenu_CreateFrames", function(_, level, _)
		for i = 1, level do
			skinDDL(_G[ddPrefix .. i])
		end
	end)
end

aObj.libsToSkin["LibUIDropDownMenu-4.0"] = function(self) -- v 90100/90096
	if self.initialized.LibUIDropDownMenu then return end
	self.initialized.LibUIDropDownMenu = true

	local lDD, lVer = _G.LibStub:GetLibrary("LibUIDropDownMenu-4.0", true)

	if lDD then
		skinDropDowns(lDD, lVer)
	end

end

aObj.libsToSkin["LibUIDropDownMenuQuestie-4.0"] = function(self) -- v 90080
	if self.initialized.LibUIDropDownMenuQuestie then return end
	self.initialized.LibUIDropDownMenuQuestie = true

	local lDD, lVer = _G.LibStub:GetLibrary("LibUIDropDownMenuQuestie-4.0", true)

	if lDD then
		skinDropDowns(lDD, lVer)
	end

end
