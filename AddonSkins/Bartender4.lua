local aName, aObj = ...
if not aObj:isAddonEnabled("Bartender4") then return end
local _G = _G

aObj.addonsToSkin.Bartender4 = function(self) -- v 4.8.1

	self:SecureHook(_G.Bartender4, "ShowUnlockDialog", function(this)
		self:skinCheckButton{obj=_G.Bartender4Snapping}
		self:skinStdButton{obj=_G.Bartender4DialogLock}
		self:addSkinFrame{obj=this.unlock_dialog, ft="a", kfs=true, nb=true, y1=6}
		self:Unhook(_G.Bartender4, "ShowUnlockDialog")
	end)

	local mod = _G.Bartender4:GetModule("ActionBars", true)
	if mod
	and mod.enabledState
	then
		-- skin ActionBar buttons
		for _, bar in mod:GetAll() do
			for _, btn in _G.ipairs(bar.buttons) do
				self:addButtonBorder{obj=btn, abt=true, sec=true}
			end
		end
	end

	local mod = _G.Bartender4:GetModule("StatusTrackingBar", true)
	if mod
	and mod.enabledState
	then
		-- skin Status bars
		mod.bar.manager.SingleBarLarge:SetTexture(nil)
		for _, bar in _G.ipairs(mod.bar.manager.bars) do
			self:skinStatusBar{obj=bar.StatusBar, fi=0, bgTex=bar.StatusBar.Background}
		end
	end

	local mod = _G.Bartender4:GetModule("BlizzardArt", true)
	if mod
	and mod.enabledState
	then
		-- disable Art
		mod:ToggleModule(nil, false)
	end

	mod = nil

end
