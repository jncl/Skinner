local aName, aObj = ...
if not aObj:isAddonEnabled("Archy") then return end

function aObj:Archy()

	-- DigSite Frame
	self:skinButton{obj=ArchyDigSiteFrame.styleButton, mp2=true, as=true}
	self:SecureHookScript(ArchyDigSiteFrame.styleButton, "OnClick", function(this)
		if this:GetChecked() then this:SetText(self.modUIBtns.minus)
		else this:SetText(self.modUIBtns.plus) end
	end)
	self:addSkinFrame{obj=ArchyDigSiteFrame}

	-- Artifact Frame
	self:skinButton{obj=ArchyArtifactFrame.styleButton, mp2=true, as=true, plus=true}
	self:SecureHookScript(ArchyArtifactFrame.styleButton, "OnClick", function(this)
		if this:GetChecked() then this:SetText(self.modUIBtns.minus)
		else this:SetText(self.modUIBtns.plus) end
	end)
	ArchyArtifactFrame.skillBar.border:Hide()
	self:glazeStatusBar(ArchyArtifactFrame.skillBar, 0,  nil)
	for _, v in pairs(ArchyArtifactFrame.children) do
		v.fragmentBar.barBackground:Hide()
		v.fragmentBar.barTexture:SetTexCoord(0, 1, 0, 1)
		v.fragmentBar.barTexture.SetTexCoord = function() end
		self:glazeStatusBar(v.fragmentBar, 0, nil)
		self:skinButton{obj=v.solveButton}
	end
	self:SecureHook(getmetatable(ArchyArtifactFrame.children), "__index", function(this, t, k)
		t[k].fragmentBar.barBackground:Hide()
		t[k].fragmentBar.barTexture:SetTexCoord(0, 1, 0, 1)
		t[k].fragmentBar.barTexture.SetTexCoord = function() end
		self:glazeStatusBar(t[k].fragmentBar, 0, nil)
		self:skinButton{obj=t[k].solveButton}
	end)
	self:addSkinFrame{obj=ArchyArtifactFrame}

	-- Hook ldb object to skin status bars
	self:SecureHook(LibStub("LibDataBroker-1.1"):GetDataObjectByName("Archy"), "OnEnter", function(this)
		for i = 5, 15 do -- only 10 races
			if this.tooltip.lines[i].cells[6]
			and	this.tooltip.lines[i].cells[6].bar
			and this.tooltip.lines[i].cells[6].bar:IsObjectType("Texture")
			then
				this.tooltip.lines[i].cells[6].bar:SetTexture(self.sbTexture)
				this.tooltip.lines[i].cells[6].bg:SetTexture(self.sbTexture)
				this.tooltip.lines[i].cells[6].bg:SetWidth(100)
				this.tooltip.lines[i].cells[6].bg:SetHeight(12)
				this.tooltip.lines[i].cells[6].bg:SetPoint("LEFT", this.tooltip.lines[i].cells[6], "LEFT", 1, 0)
			end
		end
	end)

end
