local aName, aObj = ...
if not aObj:isAddonEnabled("PetBattleMaster") then return end
local _G = _G

function aObj:PetBattleMaster()

	local pbm = _G.LibStub("AceAddon-3.0"):GetAddon("PetBattleMaster")
	
	-- Team View
	local ptv = pbm:GetModule("PetTeamView")
	ptv.background:SetAlpha(0)
	self:addButtonBorder{obj=self:getChild(ptv.frame, 1), mb=true, ofs=0, y1=-21} -- pet journal button
	for i = 1, 3 do -- pet portrait buttons
		local btn = ptv["portrait" .. i]
		self:changeTandC(self:getRegion(btn, 4), self.lvlBG)
		self:removeRegions(btn.healthBar.frame, {1, 2, 3, 4})
		self:glazeStatusBar(btn.healthBar.statusBar, 0,  nil)
	end
	self:addButtonBorder{obj=self:getChild(ptv.frame, 8)} -- pet team name button
	self:addButtonBorder{obj=ptv.heal, sec=true} -- heal button
	self:addSkinFrame{obj=ptv.frame, sec=true}
	-- TeamFrames
	for i = 1, #ptv.teamFrames do
		self:addButtonBorder{obj=ptv.teamFrames[i]}
	end
	self:addButtonBorder{obj=ptv.left, ofs=0, y1=-1, x2=-1}
	self:addButtonBorder{obj=ptv.right, ofs=0, y1=-1, x2=-1}

	-- Team Manager
	local ptm = pbm:GetModule("PetTeamManager")
	ptm.background:SetAlpha(0)
	self:skinScrollBar{obj=ptm.scrollFrame}
	for i = 1, #ptm.entries do -- teams
		local frame = ptm.entries[i]
		self:addButtonBorder{obj=frame.teamIcon}
		self:addButtonBorder{obj=self:getChild(frame, 2)} -- pet team name button
		for j = 1, #frame.portraits do -- pet portrait buttons
			local btn = frame.portraits[j].frame
			local levelBG = self:getRegion(btn, 2)
			self:addButtonBorder{obj=btn, reParent={levelBG, btn.level, btn.petType}}
			self:changeTandC(levelBG, self.lvlBG)
			self:changeTandC(btn.catchIndicator.ownLevelBack, self.lvlBG)
		end
		self:addSkinFrame{obj=frame}
		-- update backdrop & boder if selected and/or mouseovered
		frame.SetBackdropColor = function(this, r, g, b, a)
			if a == 0.5
			and this:GetID() ~= this.obj.currentTeamIndex
			then
				frame.sf:SetBackdropColor(r, g, b, a)
				frame.sf.tfade:Hide()
			else
				frame.sf:SetBackdropColor(_G.unpack(aObj.bColour))
				frame.sf.tfade:Show()
			end
		end
		frame.SetBackdropBorderColor = function(this, r, g, b, a)
			if a == 1
			and this:GetID() ~= this.obj.currentTeamIndex
			then
				frame.sf:SetBackdropBorderColor(r, g, b, a)
			else
				frame.sf:SetBackdropBorderColor(_G.unpack(aObj.bbColour))
			end
		end
	end
	self:addSkinFrame{obj=ptm.frame, ofs=2, x2=3, y2=-3}

	-- NameIconEditor
	self:skinEditBox{obj=_G.petbmNameIconEditor.editBox, regs={9}}
	self:skinScrollBar{obj=_G.petbmNameIconEditor.scrollFrame, size=3}
	for i = 1, 8 do
		for j = 1, 10 do
			local btn = _G.petbmNameIconEditor["iconLine" .. i]["icon" .. j]
			self:addButtonBorder{obj=btn}
			self:getRegion(btn, 2):SetTexture(nil) -- border
		end
	end
	self:addSkinFrame{obj=_G.petbmNameIconEditor, kfs=true}

	-- BattlePetTooltip
	local pth = pbm:GetModule("TooltipHook")
	self:SecureHook(pth, "BattlePetTooltipTemplate_SetBattlePet", function(this, ...)
		aObj:Debug("PTH BPTT_SBP: [%s, %s]", this, ...)
		if this.tooltipFrame then
			self:skinTooltip(this.tooltipFrame)
		end
		self:Unhook(pth, "BattlePetTooltipTemplate_SetBattlePet")
	end)

	-- Battle Info
	local pbi = pbm:GetModule("BattleInfo")
	for i = 1, #pbi.enemies do
		self:changeTandC(pbi.enemies[i].catchIndicator.ownLevelBack, self.lvlBG)
	end

	-- InfoView
	for i = 1, #pbm.view.tabs do
		local frame = pbm.view.tabs[i].portrait.frame
		local levelBG = self:getRegion(frame, 2)
		self:changeTandC(levelBG, self.lvlBG)
	end
	self:removeRegions(pbm.view.allyModFrame.healthBar.frame, {1, 2, 3, 4})
	self:glazeStatusBar(pbm.view.allyModFrame.healthBar.statusBar, 0,  nil)
	self:removeRegions(pbm.view.enemyModFrame.healthBar.frame, {1, 2, 3, 4})
	self:glazeStatusBar(pbm.view.enemyModFrame.healthBar.statusBar, 0,  nil)
	self:addSkinFrame{obj=pbm.view.frame}
	
end
