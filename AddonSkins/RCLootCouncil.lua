local _, aObj = ...
if not aObj:isAddonEnabled("RCLootCouncil")
and not aObj:isAddonEnabled("RCLootCouncil_Classic")
then
	return
end
local _G = _G

local function skinFunction() -- v 3.13.3/0.23.0

	-- hook this to skin buttons
	if aObj.modBtns then
		aObj:RawHook(_G.RCLootCouncil, "CreateButton", function(this, ...)
			local btn = aObj.hooks[this].CreateButton(this, ...)
			aObj:skinStdButton{obj=btn, ofs=0}
			return btn
		end, true)
	end
	local function skinFrame(frame, yOfs)
		frame.title:SetBackdrop(nil)
		if yOfs == nil then
			aObj:moveObject{obj=frame.title, y=-10}
		end
		frame.content:SetBackdrop(nil)
		aObj:skinObject("frame", {obj=frame, kfs=true, ofs=0, y1=yOfs})
	end

	-- Loot frame
	local RCLF = _G.RCLootCouncil:GetModule("RCLootFrame", true)
	aObj:SecureHook(RCLF, "OnEnable", function(this)
		-- return nil to prevent errors with noteEditbox
		this.frame.title.GetBackdrop = function() return nil end
		this.frame.title.GetBackdropColor = function() return nil end
		this.frame.title.GetBackdropBorderColor = function() return nil end
		skinFrame(this.frame, 10)
		this.frame:SetFrameLevel(this.frame:GetFrameLevel() + 10) -- ensure the frame appears above the voting frame
		-- tooltip
		_G.C_Timer.After(0.1, function()
			aObj:add2Table(aObj.ttList, this.frame.itemTooltip)
		end)
		-- hook this to skin entries
		aObj:SecureHook(this, "Update", function(fObj)
			for _, entry in _G.pairs(fObj.EntryManager.entries) do
				entry.noteEditbox.eb = aObj:skinObject("editbox", {obj=entry.noteEditbox, ofs=-1})
				-- Add a frame around the editbox #163
				entry.noteEditbox.sf = nil
				aObj:skinObject("frame", {obj=entry.noteEditbox, fb=true, ofs=4})
				aObj:skinObject("statusbar", {obj=entry.timeoutBar, fi=0})
			end
			if not aObj.isRtl then
				fObj.frame:SetHeight(fObj.frame.content:GetHeight())
			end
		end)

		aObj:Unhook(this, "OnEnable")
	end)

	-- Loot History frame
	local RCLHF = _G.RCLootCouncil:GetModule("RCLootHistory", true)
	aObj:SecureHook(RCLHF, "OnEnable", function(this)
		this.frame.moreInfoBtn:DisableDrawLayer("BACKGROUND")
		skinFrame(this.frame)
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=this.frame.moreInfoBtn, ofs=-1, x1=0, clr="gold"}
		end
		-- tooltip
		_G.C_Timer.After(0.1, function()
			aObj:add2Table(aObj.ttList, this.moreInfo)
		end)

		aObj:Unhook(this, "OnEnable")
	end)

	-- Session frame
	local RCSF = _G.RCLootCouncil:GetModule("RCSessionFrame", true)
	aObj:SecureHook(RCSF, "Show", function(this, ...)
		skinFrame(this.frame)
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=this.frame.toggle}
		end

		aObj:Unhook(this, "Show")
	end)

	-- Version Check frame
	local RCVCF = _G.RCLootCouncil:GetModule("RCVersionCheck", true) or _G.RCLootCouncil:GetModule("VersionCheck", true) -- ver 3
	aObj:SecureHook(RCVCF, "OnEnable", function(this)
		skinFrame(this.frame)

		aObj:Unhook(this, "OnEnable")
	end)

	-- Voting frame
	local RCVF = _G.RCLootCouncil:GetModule("RCVotingFrame", true)
	aObj:SecureHook(RCVF, "OnEnable", function(this)
		this.frame.moreInfoBtn:DisableDrawLayer("BACKGROUND")
		skinFrame(this.frame)
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=this.frame.moreInfoBtn, ofs=-1, x1=0, clr="gold"}
		end
		-- tooltip
		_G.C_Timer.After(0.1, function()
			aObj:add2Table(aObj.ttList, this.frame.itemTooltip)
			aObj:add2Table(aObj.ttList, this.frame.moreInfo)
		end)

		aObj:Unhook(this, "OnEnable")
	end)

	-- TradeUI
	local RCTUI = _G.RCLootCouncil:GetModule("RCTradeUI", true) or _G.RCLootCouncil:GetModule("TradeUI", true) -- ver 3
	aObj:SecureHook(RCTUI, "OnEnable", function(this)
		skinFrame(this.frame)

		aObj:Unhook(this, "OnEnable")
	end)

	-- Syncroniser frame
	aObj:SecureHook(_G.RCLootCouncil.Sync, "Spawn", function(this)
		aObj:skinObject("statusbar", {obj=this.frame.statusBar, fi=0})
		skinFrame(this.frame)

		aObj:Unhook(this, "Spawn")
	end)

end

if aObj.isRtl then
	aObj.addonsToSkin.RCLootCouncil = skinFunction
else
	aObj.addonsToSkin.RCLootCouncil_Classic = skinFunction
end
