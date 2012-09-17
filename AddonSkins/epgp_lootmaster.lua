local aName, aObj = ...
if not aObj:isAddonEnabled("epgp_lootmaster") then return end

function aObj:epgp_lootmaster()

	local EPGPLM = LibStub("AceAddon-3.0"):GetAddon("EPGPLootMaster", true)
	if not EPGPLM then return end

	if not EPGPLM.frame then
		self:SecureHook(EPGPLM, "InitUI", function(this)
			self:addSkinFrame{obj=this.frame.titleFrame}
			self:addSkinFrame{obj=this.frame, y1=-7}
			self:Unhook(EPGPLM, "InitUI")
		end)
	end
	if not EPGPLM.versioncheckframe then
		self:SecureHook(EPGPLM, "ShowVersionCheckFrame", function(this)
			self:addSkinFrame{obj=this.versioncheckframe.titleFrame}
			self:skinScrollBar{obj=self:getChild(this.versioncheckframe.sstScroll.frame, 1)}
			self:addSkinFrame{obj=this.versioncheckframe.sstScroll.frame}
			self:addSkinFrame{obj=this.versioncheckframe, y1=-7}
			self:Unhook(EPGPLM, "ShowVersionCheckFrame")
		end)
	end
	self:SecureHook(EPGPLM, "UpdateLootUI", function(this)
		for i = 1, #this.lootSelectFrames do
			local frame = this.lootSelectFrames[i]
			if frame
			and not self.skinFrame[frame]
			then
				frame.tbGPValueFrame:SetBackdrop(nil)
				self:skinEditBox{obj=frame.tbGPValue, regs={9}}
				self:glazeStatusBar(frame.progressBar, 0,  nil)
				frame.timerFrame:SetBackdrop(nil)
				self:getChild(frame.timerFrame, 2):SetBackdrop(nil) -- timerBorderFrame
				self:skinEditBox{obj=frame.tbNote, regs={9}}
				self:getRegion(frame.btnNote, 3):SetTexture() -- remove overlay texture
				self:addSkinFrame{obj=frame}
				if self.modBtnBs then
					self:addButtonBorder{obj=frame.itemIcon}
				end
			end
		end
	end)

end

function aObj:epgp_lootmaster_ml()

	local LMML = LibStub("AceAddon-3.0"):GetAddon("LootMasterML", true)
	if not LMML then return end

	if not LMML.mainframe then
		self:SecureHook(LMML, "GetFrame", function(this)
			self:addSkinFrame{obj=this.frame.titleFrame}
			self:addSkinFrame{obj=this.frame.extralootframe}
			self:skinScrollBar{obj=self:getChild(this.frame.sstScroll.frame, 1)}
			self:addSkinFrame{obj=this.frame.sstScroll.frame}
			this.frame.tbGPValueFrame:SetBackdrop(nil)
			self:skinEditBox{obj=this.frame.tbGPValue, regs={9}}
			-- self:skinDropDown{obj=this.CandidateDropDown}
			self:addSkinFrame{obj=this.frame, y1=-7}
			if self.modBtnBs then
				self:addButtonBorder{obj=this.frame.itemIcon}
			end
			self:Unhook(LMML, "GetFrame")
		end)
	end
	if not LMML.raidinfoframe then
		self:SecureHook(LMML, "ShowRaidInfoLookup", function(this)
			self:addSkinFrame{obj=this.raidinfoframe.titleFrame}
			self:skinScrollBar{obj=self:getChild(this.raidinfoframe.sstScroll.frame, 1)}
			self:addSkinFrame{obj=this.raidinfoframe.sstScroll.frame}
			this.raidinfoframe.tbWhisperFrame:SetBackdrop(nil)
			self:skinEditBox{obj=this.raidinfoframe.tbWhisperBox, regs={9}}
			self:adjHeight{obj=self:getChild(this.raidinfoframe, 6), adj=-18} -- dropdown
			self:addSkinFrame{obj=this.raidinfoframe, y1=-7}
			self:Unhook(LMML, "ShowRaidInfoLookup")
		end)
	end
	-- hook this to skin Vote buttons
	if self.modBtns then
		self:SecureHook(LMML, "SetCandidateVotesCellUserDraw", function(this, cell, ...)
			if cell.votebutton then
				self:skinButton{obj=cell.votebutton}
			end
		end)
	end

end
