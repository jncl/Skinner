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

	local BT4ABs = _G.Bartender4:GetModule("ActionBars", true)
	if BT4ABs
	and BT4ABs.enabledState
	then
		-- skin ActionBar buttons
		for _, bar in BT4ABs:GetAll() do
			for _, btn in _G.ipairs(bar.buttons) do
				self:addButtonBorder{obj=btn, abt=true, sec=true}
			end
		end
	end

	local BT4STB = _G.Bartender4:GetModule("StatusTrackingBar", true)
	if BT4STB
	and BT4STB.enabledState
	then
		-- skin Status bars
		BT4STB.bar.manager.SingleBarLarge:SetTexture(nil)
		for _, bar in _G.ipairs(BT4STB.bar.manager.bars) do
			self:skinStatusBar{obj=bar.StatusBar, fi=0, bgTex=bar.StatusBar.Background}
		end
	end

	BT4ABs, BT4STB = nil, nil

end
