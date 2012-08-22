local aName, aObj = ...
if not aObj:isAddonEnabled("BugSack") then return end

function aObj:BugSack()

	self:SecureHook(BugSack, "OpenSack", function(this)
		self:skinScrollBar{obj=BugSackScroll or BugSackFrameScroll}
		self:addSkinFrame{obj=BugSackFrame, kfs=true, y1=-2, x2=-1, y2=2}
		-- tabs
		local tabs = {BugSackTabAll, BugSackTabSession, BugSackTabLast}
		for _, tabObj in pairs(tabs) do
			self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
			self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
			local tabSF = self.skinFrame[tabObj]
			if self.isTT then
				if tabObj == BugSackTabAll then self:setActiveTab(tabSF)
				else self:setInactiveTab(tabSF) end
				-- hook this to change the texture for the Active and Inactive tabs
				self:SecureHookScript(tabObj, "OnClick", function(this)
					for _, tabObj in pairs(tabs) do
						local tabSF = self.skinFrame[tabObj]
						if tabObj == this then self:setActiveTab(tabSF)
						else self:setInactiveTab(tabSF) end
					end
				end)
			end
		end
		self:Unhook(BugSack, "OpenSack")
	end)

end
