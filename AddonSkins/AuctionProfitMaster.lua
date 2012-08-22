if not Skinner:isAddonEnabled("AuctionProfitMaster") then return end

function Skinner:AuctionProfitMaster()

	local APM = LibStub("AceAddon-3.0"):GetAddon("AuctionProfitMaster", true)
	if not APM then return end

-->>-- Info Panel
	local frame = self:findFrame2(UIParent, "Frame", "CENTER", UIParent, "CENTER", 0, 100)
	if frame then
		self:addSkinFrame{obj=frame, kfs=true, y1=6}
	end

-->>-- Status Frame
	self:SecureHook(APM, "CreateStatus", function(this)
	self:skinScrollBar{obj=APM.statusFrame.scroll}
		self:addSkinFrame{obj=APM.statusFrame}
		self:Unhook(APM, "CreateStatus")
	end)

-->>-- Summary Frame
	self:SecureHook(APM.Summary, "CreateGUI", function(this)
		self:moveObject{obj=self:getChild(this.frame, 1), y=-6}
		self:addSkinFrame{obj=this.leftFrame}
		this.topFrame:SetBackdrop(nil)
		self:addSkinFrame{obj=this.middleFrame}
		self:skinScrollBar{obj=this.middleFrame.scroll}
		self:glazeStatusBar(this.progressBar, 0,  nil)
		self:SecureHookScript(this.helpCraftQueue, "OnClick", function(btn)
			self:addSkinFrame{obj=this.helpFrame}
			self:Unhook(this.helpCraftQueue, "OnClick")
		end)
		self:addSkinFrame{obj=this.frame, kfs=true, ofs=-2}
		-- UIButton skinning
		if self.modBtns then
			for i = 1, #this.rows do
				self:skinButton{obj=this.rows[i].button, mp=true}
			end
			self:SecureHook(this, "Update", function()
				for i = 1, #this.rows do
					self:checkTex(this.rows[i].button)
				end
			end)
		end
		self:Unhook(APM.Summary, "CreateGUI")
	end)

-->>-- Post popup
	self:adjHeight{obj=APM.Post.post.skipButton, adj=6}
	self:adjHeight{obj=APM.Post.post.cancelButton, adj=6}
	self:addSkinFrame{obj=APM.Post.post}

-->>-- Cancel Frame
	self:SecureHook(APM.Manage, "FinalCancel", function(this)
		self:addSkinFrame{obj=self:getChild(AuctionFrame, AuctionFrame:GetNumChildren())} -- last child added
		self:Unhook(APM.Manage, "FinalCancel")
	end)

-->>--	Tradeskill Queue Frame
	self:SecureHook(APM.Tradeskill, "CreateFrame", function(this)
		self:adjWidth{obj=this.button, adj=6}
		self:adjWidth{obj=this.buy, adj=6}
		self:skinButton{obj=this.button}
		self:skinButton{obj=this.buy}
		self:skinScrollBar{obj=this.frame.scroll}
		self:addSkinFrame{obj=this.frame}
		self:Unhook(APM.Tradeskill, "CreateFrame")
	end)

end
