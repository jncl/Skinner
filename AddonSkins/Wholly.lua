local aName, aObj = ...
if not aObj:isAddonEnabled("Wholly") then return end

function aObj:Wholly()

	-- narrow frame
	self:SecureHookScript(com_mithrandir_whollyFrame, "OnShow", function(this)
		self:skinDropDown{obj=com_mithrandir_whollyFrameZoneButton, x2=35}
		self:Unhook(com_mithrandir_whollyFrame, "OnShow")
	end)
	self:skinSlider{obj=com_mithrandir_whollyFrameScrollFrame.scrollBar, adj=-4}
	self:addSkinFrame{obj=com_mithrandir_whollyFrame, kfs=true, x1=10, y1=-12, x2=-33, y2=71}
	-- wide frame
	if self.modBtns then
		-- hook these to manage changes to button textures
		self:SecureHook(Wholly, "ScrollFrameOne_Update", function()
			for i = 1, #com_mithrandir_whollyFrameWideScrollOneFrame.buttons do
				self:checkTex(com_mithrandir_whollyFrameWideScrollOneFrame.buttons[i])
			end
		end)
		self:SecureHook(com_mithrandir_whollyFrameWideScrollOneFrame, "update", function()
			for i = 1, #com_mithrandir_whollyFrameWideScrollOneFrame.buttons do
				self:checkTex(com_mithrandir_whollyFrameWideScrollOneFrame.buttons[i])
			end
		end)
		for i = 1, #com_mithrandir_whollyFrameWideScrollOneFrame.buttons do
			self:skinButton{obj=com_mithrandir_whollyFrameWideScrollOneFrame.buttons[i], mp=true, plus=true}
		end
	end
	self:skinSlider{obj=com_mithrandir_whollyFrameWideScrollOneFrame.scrollBar, adj=-4}
	self:skinSlider{obj=com_mithrandir_whollyFrameWideScrollTwoFrame.scrollBar, adj=-4}
	self:addSkinFrame{obj=com_mithrandir_whollyFrameWide, kfs=true, x1=10, y1=-11, x2=-1, y2=6}
	-- tooltip
	-- tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "com_mithrandir_WhollyTooltip")
		-- self:add2Table(self.ttList, "com_mithrandir_WhollyOtherTooltip")
	end
	
end