local aName, aObj = ...
if not (aObj:isAddonEnabled("RCLootCouncil") or aObj:isAddonEnabled("RCLootCouncil_Classic")) then return end
local _G = _G

local skinFunction = function(self) -- v 2.19.3/3.0.0/0.11.2

	-- hook this to skin buttons
	if self.modBtns then
		self:RawHook(_G.RCLootCouncil, "CreateButton", function(this, ...)
			local btn = self.hooks[this].CreateButton(this, ...)
			self:skinStdButton{obj=btn, ofs=0}
			return btn
		end, true)
	end
	local function skinFrame(frame, noTitleMove)
		frame.title:SetBackdrop(nil)
		if not noTitleMove then
			aObj:moveObject{obj=frame.title, y=-10}
		end
		frame.content:SetBackdrop(nil)
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
	end

	-- Loot frame
	local RCLF = _G.RCLootCouncil:GetModule("RCLootFrame", true)
	self:SecureHook(RCLF, "OnEnable", function(this)
		-- return nil to prevent errors with noteEditbox
		this.frame.title.GetBackdrop = function() return nil end
		this.frame.title.GetBackdropColor = function() return nil end
		this.frame.title.GetBackdropBorderColor = function() return nil end
		skinFrame(this.frame, true)
		this.frame:SetFrameLevel(this.frame:GetFrameLevel() + 10) -- ensure the frame appears above the voting frame
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, this.frame.itemTooltip)
		end)
		-- hook this to skin entries
		self:SecureHook(this, "Update", function(this)
			for i = 1, #this.EntryManager.entries do
				local entry = this.EntryManager.entries[i]
				self:skinEditBox{obj=entry.noteEditbox, regs={6}} -- 6 is text
				self:skinStatusBar{obj=entry.timeoutBar, fi=0}
			end
			if not self.isRtl then
				this.frame:SetHeight(this.frame.content:GetHeight())
			end
		end)

		self:Unhook(this, "OnEnable")
	end)

	-- Loot History frame
	local RCLHF = _G.RCLootCouncil:GetModule("RCLootHistory", true)
	self:SecureHook(RCLHF, "OnEnable", function(this)
		this.frame.moreInfoBtn:DisableDrawLayer("BACKGROUND")
		skinFrame(this.frame)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.frame.moreInfoBtn, ofs=-1, x1=0, clr="gold"}
		end
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, this.moreInfo)
		end)

		self:Unhook(this, "OnEnable")
	end)

	-- Session frame
	local RCSF = _G.RCLootCouncil:GetModule("RCSessionFrame", true)
	self:SecureHook(RCSF, "Show", function(this, ...)
		skinFrame(this.frame)
		if self.modChkBtns then
			self:skinCheckButton{obj=this.frame.toggle}
		end

		self:Unhook(this, "Show")
	end)

	-- Version Check frame
	local RCVCF = _G.RCLootCouncil:GetModule("RCVersionCheck", true) or _G.RCLootCouncil:GetModule("VersionCheck", true) -- ver 3
	self:SecureHook(RCVCF, "OnEnable", function(this)
		skinFrame(this.frame)

		self:Unhook(this, "OnEnable")
	end)

	-- Voting frame
	local RCVF = _G.RCLootCouncil:GetModule("RCVotingFrame", true)
	self:SecureHook(RCVF, "OnEnable", function(this)
		this.frame.moreInfoBtn:DisableDrawLayer("BACKGROUND")
		skinFrame(this.frame)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.frame.moreInfoBtn, ofs=-1, x1=0, clr="gold"}
		end
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, this.frame.itemTooltip)
			self:add2Table(self.ttList, this.frame.moreInfo)
		end)

		self:Unhook(this, "OnEnable")
	end)

	-- TradeUI
	local RCTUI = _G.RCLootCouncil:GetModule("RCTradeUI", true) or _G.RCLootCouncil:GetModule("TradeUI", true) -- ver 3
	self:SecureHook(RCTUI, "OnEnable", function(this)
		skinFrame(this.frame)

		self:Unhook(this, "OnEnable")
	end)

	-- Syncroniser frame
	self:SecureHook(_G.RCLootCouncil.Sync, "Spawn", function(this)
		self:skinStatusBar{obj=this.frame.statusBar, fi=0}
		skinFunction(this.frame)

		self:Unhook(this, "Spawn")
	end)

	RCLF, RCLHF, RCSF, RCVCF, RCVF, RCTUI = nil, nil, nil, nil, nil, nil

end

if aObj.isRtl then
	aObj.addonsToSkin.RCLootCouncil = skinFunction
else
	aObj.addonsToSkin.RCLootCouncil_Classic = skinFunction
end
