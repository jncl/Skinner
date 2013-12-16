local aName, aObj = ...
if not aObj:isAddonEnabled("Bartender4") then return end
local _G = _G

function aObj:Bartender4()

	local BT4ABs = _G.Bartender4:GetModule("ActionBars", true)
	if not BT4ABs then return end

	self:SecureHook(_G.Bartender4, "ShowUnlockDialog", function(this)
		self:skinButton{obj=self:getChild(this.unlock_dialog, 2)} -- it's a checkbutton
		self:addSkinFrame{obj=this.unlock_dialog, kfs=true, nb=true, y1=6}
		self:Unhook(_G.Bartender4, "ShowUnlockDialog")
	end)

	-- skin ActionBar buttons
	for _, ab in _G.pairs(BT4ABs.actionbars) do
		for _, btn in _G.pairs(ab.buttons) do
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
	end

end
