local aName, aObj = ...
if not aObj:isAddonEnabled("RCLootCouncil") then return end
local _G = _G

aObj.addonsToSkin.RCLootCouncil = function(self) -- v 2.10.0

	-- Loot frame
	local RCLF = _G.RCLootCouncil:GetModule("RCLootFrame", true)
	self:SecureHook(RCLF, "OnEnable", function(this)
		this.frame.title:SetBackdrop(nil)
		self:moveObject{obj=this.frame.title, y=-10}
		-- return nil to prevent errors with noteEditbox
		this.frame.title.GetBackdrop = function() return nil end
		this.frame.title.GetBackdropColor = function() return nil end
		this.frame.title.GetBackdropBorderColor = function() return nil end
		this.frame.content:SetBackdrop(nil)
		self:addSkinFrame{obj=this.frame, ft="a", kfs=true}
		self:Unhook(this, "OnEnable")
	end)

	-- Loot History frame
	local RCLHF = _G.RCLootCouncil:GetModule("RCLootHistory", true)
	self:SecureHook(RCLHF, "OnEnable", function(this)
		this.frame.moreInfoBtn:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=this.frame.moreInfoBtn, ofs=-1, x1=0}
		end
		if self.modBtns then
			self:skinStdButton{obj=this.frame.closeBtn}
			self:skinStdButton{obj=this.frame.exportBtn}
			self:skinStdButton{obj=this.frame.importBtn}
			self:skinStdButton{obj=this.frame.filter}
			self:skinStdButton{obj=this.frame.clearSelectionBtn}
		end
		this.frame.title:SetBackdrop(nil)
		self:moveObject{obj=this.frame.title, y=-10}
		this.frame.content:SetBackdrop(nil)
		self:addSkinFrame{obj=this.frame, ft="a", kfs=true}
		self:Unhook(this, "OnEnable")
	end)

	-- Session frame
	local RCSF = _G.RCLootCouncil:GetModule("RCSessionFrame", true)
	self:SecureHook(RCSF, "Show", function(this, ...)
		if self.modChkBtns then
			self:skinCheckButton{obj=this.frame.toggle}
		end
		if self.modBtns then
			self:skinStdButton{obj=this.frame.startBtn}
			self:skinStdButton{obj=this.frame.closeBtn}
		end
		this.frame.title:SetBackdrop(nil)
		self:moveObject{obj=this.frame.title, y=-10}
		this.frame.content:SetBackdrop(nil)
		self:addSkinFrame{obj=this.frame, ft="a", kfs=true}
		self:Unhook(this, "Show")
	end)

	-- Version Check frame
	local RCVCF = _G.RCLootCouncil:GetModule("RCVersionCheck", true)
	self:SecureHook(RCVCF, "OnEnable", function(this)
		if self.modBtns then
			self:skinStdButton{obj=this.frame.guildBtn}
			self:skinStdButton{obj=this.frame.raidBtn}
			self:skinStdButton{obj=this.frame.closeBtn}
		end
		this.frame.title:SetBackdrop(nil)
		self:moveObject{obj=this.frame.title, y=-10}
		this.frame.content:SetBackdrop(nil)
		self:addSkinFrame{obj=this.frame, ft="a", kfs=true}
		self:Unhook(this, "OnEnable")
	end)

	-- Voting frame
	local RCVF = _G.RCLootCouncil:GetModule("RCVotingFrame", true)
	self:SecureHook(RCVF, "OnEnable", function(this)
		this.frame.moreInfoBtn:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=this.frame.moreInfoBtn, ofs=-1, x1=0}
		end
		if self.modBtns then
			self:skinStdButton{obj=this.frame.abortBtn}
			self:skinStdButton{obj=this.frame.filter}
			self:skinStdButton{obj=this.frame.disenchant}
		end
		this.frame.title:SetBackdrop(nil)
		self:moveObject{obj=this.frame.title, y=-10}
		this.frame.content:SetBackdrop(nil)
		self:addSkinFrame{obj=this.frame, ft="a", kfs=true}
		self:Unhook(this, "OnEnable")
	end)

	-- Syncroniser frame
	self:SecureHook(_G.RCLootCouncil.Sync, "Spawn", function(this)
		if self.modBtns then
			self:skinStdButton{obj=this.frame.syncButton}
			self:skinStdButton{obj=this.frame.exitButton}
		end
		self:skinStatusBar{obj=this.frame.statusBar, fi=0}
		this.frame.title:SetBackdrop(nil)
		self:moveObject{obj=this.frame.title, y=-10}
		this.frame.content:SetBackdrop(nil)
		self:addSkinFrame{obj=this.frame, ft="a", kfs=true}
		self:Unhook(this, "Spawn")
	end)

	RCLF, RCLHF, RCSF, RCVCF, RCVF = nil, nil, nil, nil, nil

end
