local _, aObj = ...
if not aObj:isAddonEnabled("Immersion") then return end
local _G = _G

aObj.addonsToSkin.Immersion = function(self) -- v 1.3.6

	-- use a metatable to skin title buttons
	local mt = {__newindex = function(table, key, btn)
		aObj:removeBackdrop(btn.Overlay)
		aObj:skinObject("frame", {obj=btn, ofs=0, y2=1})
		_G.rawset(table, key, btn)
	end}
	_G.setmetatable(_G.ImmersionFrame.TitleButtons.Buttons, mt)
	-- use a metatable to skin Elements buttons
	local mt = {__newindex = function(table, key, btn)
		btn.NameFrame:SetTexture(nil)
		_G.rawset(table, key, btn)
	end}
	_G.setmetatable(_G.ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.Buttons, mt)
	_G.setmetatable(_G.ImmersionFrame.TalkBox.Elements.Progress.Buttons, mt)
	mt = nil
	
	self:RawHook(_G.ImmersionFrame.Inspector.tooltipFramePool, "Acquire", function(this)
		local tTip = self.hooks[this].Acquire(this)
		if self.modBtnBs then
			self:addButtonBorder{obj=tTip.Icon, fType=ftype, relTo=tTip.Icon.Texture}
		end
		tTip.Icon:DisableDrawLayer("OVERLAY") -- Border
		if not _G.rawget(self.ttList, tTip) then
			self:add2Table(self.ttList, tTip)
		end
		return tTip
	end, true)

	_G.ImmersionFrame.TalkBox.Elements.Content.SpecialObjectivesFrame.SpellObjectiveFrame.NameFrame:SetTexture(nil)
	_G.ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.HonorFrame.NameFrame:SetTexture(nil)
	_G.ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.Buttons[1].NameFrame:SetTexture(nil)
	_G.ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.SkillPointFrame.NameFrame:SetTexture(nil)
	_G.ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.ArtifactXPFrame.NameFrame:SetTexture(nil)
	self:removeRegions(_G.ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.TitleFrame, {2, 3, 4}) -- NameFrame textures
	self:RawHook(_G.ImmersionFrame.TalkBox.Elements.Content.RewardsFrame.spellRewardPool, "Acquire", function(this)
		local frame = self.hooks[this].Acquire(this)
		frame.NameFrame:SetTexture(nil)
		return frame
	end, true)
	_G.ImmersionFrame.TalkBox.Elements.Progress.Buttons[1].NameFrame:SetTexture(nil)

	self:nilTexture(_G.ImmersionFrame.TalkBox.BackgroundFrame.TextBackground, true)
	self:nilTexture(_G.ImmersionFrame.TalkBox.BackgroundFrame.SolidBackground, true)
	self:nilTexture(_G.ImmersionFrame.TalkBox.BackgroundFrame.OverlayKit, true)
	self:nilTexture(_G.ImmersionFrame.TalkBox.BackgroundFrame.Mask, true)
	self:nilTexture(_G.ImmersionFrame.TalkBox.PortraitFrame.Portrait, true)
	self:nilTexture(_G.ImmersionFrame.TalkBox.MainFrame.Model.PortraitBG, true)
	self:nilTexture(_G.ImmersionFrame.TalkBox.MainFrame.Model.ModelShadow, true)
	
	local function skinFrame(frame)
		aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, nb=true, aso={bd=11, ng=true}, ofs=-8}
		frame.sf:SetBackdropColor(.1, .1, .1, .75) -- use dark background
	end
	skinFrame(_G.ImmersionFrame.TalkBox.Elements)
	skinFrame(_G.ImmersionFrame.TalkBox)
	if self.modBtns then
		self:skinCloseButton{obj=_G.ImmersionFrame.TalkBox.MainFrame.CloseButton, noSkin=true}
	end

	self:removeRegions(_G.ImmersionFrame.TalkBox.ProgressionBar, {1, 2, 3})
	self:skinStatusBar{obj=_G.ImmersionFrame.TalkBox.ProgressionBar, fi=0, bgTex=self:getRegion(_G.ImmersionFrame.TalkBox.ProgressionBar, 4)}
	self:removeRegions(_G.ImmersionFrame.TalkBox.ReputationBar, {1, 3, 4, 5, 6})
	self:skinStatusBar{obj=_G.ImmersionFrame.TalkBox.ReputationBar, fi=0, bgTex=self:getRegion(_G.ImmersionFrame.TalkBox.ReputationBar, 7)}

end
