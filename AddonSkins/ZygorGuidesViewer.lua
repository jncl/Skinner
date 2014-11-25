local aName, aObj = ...
if not aObj:isAddonEnabled("ZygorGuidesViewer") then return end
local _G = _G

function aObj:ZygorGuidesViewer()

	local ZGV = _G.ZygorGuidesViewer

	-- Maintenance Frame
	self:addSkinFrame{obj=_G.ZygorGuidesViewerMaintenanceFrame}

	-- Viewer frame
	_G.ZygorGuidesViewerFrame:SetBackdrop(nil)
	_G.ZygorGuidesViewerFrame_Border:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.ZygorGuidesViewerFrame, nb=true, ofs=4}

	-- Config Frame
	self:SecureHook(ZGV.Config, "CreateFrame", function(this)
		this.Base:SetBackdrop(nil)
		this.Frame1:SetBackdrop(nil)
		this.Frame2:SetBackdrop(nil)
		this.Frame3:SetBackdrop(nil)
		this.Frame4:SetBackdrop(nil)
		this.Frame5:SetBackdrop(nil)
		self:addSkinFrame{obj=this.Base, ofs=4}
		self:Unhook(ZGV.Config, "CreateFrame")
	end)

	-- hook this to skin the menu frame
	self:SecureHook(ZGV.Menu, "CreateFrame", function(this)
		self:addSkinFrame{obj=this.Frame, nb=true, anim=true, ofs=4}
		self:Unhook(ZGV.Menu, "CreateFrame")
	end)

	-- Tutorial frame
	self:SecureHook(ZGV.Tutorial, "CreateFrame", function(this)
		self:addSkinFrame{obj=this.TooltipFrame, nb=true, ofs=4}
		self:Unhook(ZGV.Tutorial, "CreateFrame")
	end)

	-- Creature Viewer
	self:SecureHook(ZGV.CreatureViewer, "CreateFrame", function(this)
		self:addSkinFrame{obj=this.Frame, ofs=4}
		self:Unhook(ZGV.CreatureViewer, "CreateFrame")
	end)

	-- Loot Grey Frame
	self:SecureHook(ZGV.Loot, "CreateFrame", function(this)
		self:addSkinFrame{obj=this.GreyFrame, ofs=4}
		self:Unhook(ZGV.Loot, "CreateFrame")
	end)

	-- Pet Battles frame(s)
	self:SecureHook(ZGV.PetBattle, "CreateFrame", function(this)
		self:skinAllButtons{obj=this.BattleFrame}
		self:addSkinFrame{obj=this.BattleFrame.Main, kfs=true}
		self:addSkinFrame{obj=this.BattleFrame.Enemy, kfs=true}
		self:addSkinFrame{obj=this.BattleFrame.Ally, kfs=true}
		self:Unhook(ZGV.PetBattle, "CreateFrame")
	end)

	-- Gear Finder
	self:SecureHookScript(CharacterFrame, "OnShow", function(this)
		if ZygorGearFinderFrame then
			local tab = PaperDollSidebarTab4
			tab.TabBg:SetAlpha(0)
			tab.Hider:SetAlpha(0)
			-- use a button border to indicate the active tab
			self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=4, y1=9, x2=6} -- use module function here to force creation
			tab.sbb:SetBackdropBorderColor(1, 0.6, 0, 1)
			tab.sbb:SetShown(ZygorGearFinderFrame:IsShown())
			self:keepFontStrings(ZygorGearFinderFrame)
			self:skinSlider{obj=ZygorGearFinderFrameScrollBar}
			for i = 1, #ZygorGearFinderFrame.Items do
				local btn = ZygorGearFinderFrame.Items[i]
				btn.BgTop:SetTexture(nil)
				btn.BgBottom:SetTexture(nil)
				btn.BgMiddle:SetTexture(nil)
			end
		end
		self:Unhook(CharacterFrame, "OnShow")
	end)

	-- TalentAdvisor Popout
	ZygorTalentAdvisorPopoutButton:SetSize(36, 32)
	self:addButtonBorder{obj=ZygorTalentAdvisorPopoutButton, x1=2, x2=-2}
	ZygorTalentAdvisorPopoutButton:SetNormalTexture(ZGV.DIR .. [[\ZygorTalentAdvisor\Skin\popout-button]])
	ZygorTalentAdvisorPopoutButton:SetPushedTexture(ZGV.DIR .. [[\ZygorTalentAdvisor\Skin\popout-button-pushed]])
	ZygorTalentAdvisorPopout.accept:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=ZygorTalentAdvisorPopout, kfs=true}


	-- AutoEquip Popup
	self:SecureHook(ZGV.ItemScore.AutoEquip, "CreatePopup", function(this)
		self:addSkinFrame{obj=this.Popup, nb=true, ofs=4}
		self:skinButton{obj=this.Popup.acceptbutton}
		self:skinButton{obj=this.Popup.declinebutton}
		self:Unhook(ZGV.ItemScore.AutoEquip, "CreatePopup")
	end)

end
