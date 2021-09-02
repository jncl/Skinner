local _, aObj = ...
if not aObj:isAddonEnabled("PetBattleMaster") then return end
local _G = _G

aObj.addonsToSkin.PetBattleMaster = function(self) -- v 9.0.1

	local pbm = _G.LibStub("AceAddon-3.0"):GetAddon("PetBattleMaster")
	
	-- Team View
	local ptv = pbm:GetModule("PetTeamView")
	ptv.background:SetAlpha(0)
	local btn
	for i = 1, 3 do -- pet portrait buttons
		btn = ptv["portrait" .. i]
		self:changeTandC(self:getRegion(btn, 4))
		self:removeRegions(btn.healthBar.frame, {1, 2, 3, 4})
		self:skinStatusBar{obj=btn.healthBar.statusBar, fi=0}
	end
	btn = nil
	self:skinObject("frame", {obj=ptv.frame, sec=true, ofs=0})
	if self.modBtnBs then
		self:addButtonBorder{obj=self:getChild(ptv.frame, 1), mb=true, ofs=0, y1=-21} -- pet journal button
		self:addButtonBorder{obj=self:getChild(ptv.frame, 8)} -- pet team name button
		self:addButtonBorder{obj=ptv.heal, sec=true} -- heal button
		for _, btn in _G.pairs(ptv.teamFrames) do
			self:addButtonBorder{obj=btn}
		end
		self:addButtonBorder{obj=ptv.left, ofs=0, y1=-1, x2=-1}
		self:addButtonBorder{obj=ptv.right, ofs=0, y1=-1, x2=-1}
	end

	-- Team Manager
	local ptm = pbm:GetModule("PetTeamManager")
	ptm.background:SetAlpha(0)
	self:skinObject("slider", {obj=ptm.scrollFrame.ScrollBar})
	for _, frame in _G.pairs(ptm.entries) do
		for _, obj in _G.pairs(frame.portraits) do
			self:changeTandC(self:getRegion(obj.frame, 2))
			self:changeTandC(obj.frame.catchIndicator.ownLevelBack)
			if self.modBtnBs then
				self:addButtonBorder{obj=obj.frame, reParent={self:getRegion(obj.frame, 2), obj.frame.level, obj.frame.petType}}
			end
		end
		self:skinObject("frame", {obj=frame, fb=true, ofs=0})
		if self.modBtnBs then
			self:addButtonBorder{obj=frame.teamIcon}
			self:addButtonBorder{obj=self:getChild(frame, 2)} -- pet team name button
		end
		-- update boder if selected or mouseover the team icon
		frame.SetBackdropBorderColor = function(this, r, g, b, a)
			-- aObj:Debug("SBBC: [%s, %s, %s, %s, %s, %s]", this:GetID(), r, g, b ,a, this.obj.currentTeamIndex)
			if a == 1 then
				frame.sf:SetBackdropBorderColor(r, g, b, a)
			else
				frame.sf:SetBackdropBorderColor(self.bbClr:GetRGBA())
			end
		end
	end
	self:moveObject{obj=ptm.frame, x=0, y=1}
	self:adjHeight{obj=ptm.scrollFrame, adj=-1}
	self:skinObject("slider", {obj=ptm.scrollFrame.ScrollBar})
	self:skinObject("frame", {obj=ptm.frame, ofs=0, y1=1, x2=3})
	if self.modBtns then
		self:skinStdButton{obj=ptm.createTeam}
		self:skinStdButton{obj=ptm.deleteTeam}
	end

	-- NameIconEditor
	self:skinObject("editbox", {obj=_G.petbmNameIconEditor.editBox})
	self:skinObject("slider", {obj=_G.petbmNameIconEditor.scrollFrame.ScrollBar})
	self:skinObject("frame", {obj=_G.petbmNameIconEditor, kfs=true})
	if self.modBtns then
		self:skinStdButton{obj=_G.petbmNameIconEditorCancelButton}
		self:skinStdButton{obj=_G.petbmNameIconEditorOkayButton}
	end
	if self.modBtnBs then
		local btn
		for i = 1, 8 do
			for j = 1, 10 do
				btn = _G.petbmNameIconEditor["iconLine" .. i]["icon" .. j]
				self:getRegion(btn, 2):SetTexture(nil) -- border
				self:addButtonBorder{obj=btn}
			end
		end
		btn = nil
	end

	-- BattlePetTooltip
	local pth = pbm:GetModule("TooltipHook")
	self:SecureHook(pth, "BattlePetTooltipTemplate_SetBattlePet", function(this, ...)
		if this.tooltipFrame then
			self:skinTooltip(this.tooltipFrame)
		end

		self:Unhook(pth, "BattlePetTooltipTemplate_SetBattlePet")
	end)

	-- Battle Info
	local pbi = pbm:GetModule("BattleInfo")
	for _, obj in _G.pairs(pbi.enemies) do
		self:changeTandC(obj.catchIndicator.ownLevelBack)
	end

	-- InfoView
	for _, frame in _G.pairs(pbm.view.tabs) do
		self:changeTandC(self:getRegion(frame.portrait.frame, 2))
	end
	self:removeRegions(pbm.view.allyModFrame.healthBar.frame, {1, 2, 3, 4})
	self:skinStatusBar{obj=pbm.view.allyModFrame.healthBar.statusBar, fi=0}
	self:removeRegions(pbm.view.enemyModFrame.healthBar.frame, {1, 2, 3, 4})
	self:skinStatusBar{obj=pbm.view.enemyModFrame.healthBar.statusBar, fi=0}
	self:skinObject("frame", {obj=pbm.view.frame})
	
end
