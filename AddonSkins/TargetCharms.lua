local aName, aObj = ...
if not aObj:isAddonEnabled("TargetCharms") then return end
local _G = _G

function aObj:TargetCharms()

	-- TopReady Frame
	self:skinButton{obj=_G.ReadyCharm}
	-- Setup frame
	self:SecureHook("ShowSetup", function()
		self:skinEditBox{obj=_G.EditBox, regs={6, 9}}
		self:skinDropDown{obj=_G.FormDropDownType}
		self:skinDropDown{obj=_G.DropDownPresetOptions}
		self:skinEditBox{obj=_G.FlareEditBox, regs={6, 9}}
		self:skinDropDown{obj=_G.FormDropDownTypeFlare}
		self:skinDropDown{obj=_G.FlareDropDownPresetOptions}
		self:skinEditBox{obj=_G.EditBox2, regs={6, 9}}
		self:skinDropDown{obj=_G.FormDropDownType2}
		self:addSkinFrame{obj=_G.TargetCharmsSetup, kfs=true, hdr=true, y1=3}
		self:Unhook("ShowSetup")
	end)

end
