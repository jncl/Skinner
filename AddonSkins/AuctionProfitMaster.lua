if not Skinner:isAddonEnabled("AuctionProfitMaster") then return end

function Skinner:AuctionProfitMaster()

	local APM = LibStub("AceAddon-3.0"):GetAddon("AuctionProfitMaster", true)
	if not APM then return end

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

end
