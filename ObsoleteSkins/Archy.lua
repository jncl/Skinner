local aName, aObj = ...
if not aObj:isAddonEnabled("Archy") then return end

function aObj:Archy()

	Archy.db.profile.artifact.fragmentBarTexture = self.db.profile.StatusBar.texture

	local function skinFragment(obj)

		aObj:Debug("skinFragment: [%s, %s]", obj, Archy.db.profile.artifact.style)
		obj.fragmentBar.barBackground:Hide()
		obj.fragmentBar.barTexture:SetTexCoord(0, 1, 0, 1)
		obj.fragmentBar.barTexture.SetTexCoord = function() end
		aObj:glazeStatusBar(obj.fragmentBar, 0, nil)
		-- skin button in "Extended" style
		if Archy.db.profile.artifact.style == "Extended" then aObj:skinButton{obj=obj.solveButton} end

	end
-->>-- DigSite Frame
	if self.modBtns
	and Archy.db.profile.general.theme == "Graphical"
	then
		self:skinButton{obj=ArchyDigSiteFrame.styleButton, mp2=true, as=true}
		self:SecureHookScript(ArchyDigSiteFrame.styleButton, "OnClick", function(this)
			if this:GetChecked() then this:SetText(self.modUIBtns.minus)
			else this:SetText(self.modUIBtns.plus) end
		end)
	end
	self:addSkinFrame{obj=ArchyDigSiteFrame, nb=true}
	-- stop frame backdrop from being changed
	ArchyDigSiteFrame.SetBackdrop = function() end
	ArchyDigSiteFrame.SetBackdropColor = function() end
	ArchyDigSiteFrame.SetBackdropBorderColor = function() end
	-- DistanceIndicator Frame

-->>-- Artifact Frame
	if Archy.db.profile.general.theme == "Graphical" then
		ArchyArtifactFrame.skillBar.border:Hide()
		self:glazeStatusBar(ArchyArtifactFrame.skillBar, 0,  nil)
		for _, v in pairs(ArchyArtifactFrame.children) do
			skinFragment(v)
		end
		self:SecureHook(getmetatable(ArchyArtifactFrame.children), "__index", function(t, k)
			skinFragment(t[k])
		end)
		if self.modBtns	then
			self:skinButton{obj=ArchyArtifactFrame.styleButton, mp2=true, as=true, plus=true}
			self:SecureHookScript(ArchyArtifactFrame.styleButton, "OnClick", function(this)
				if this:GetChecked() then this:SetText(self.modUIBtns.minus)
				else this:SetText(self.modUIBtns.plus) end
			end)
		end
	end
	self:addSkinFrame{obj=ArchyArtifactFrame, nb=true}
	-- stop frame backdrop from being changed
	ArchyArtifactFrame.SetBackdrop = function() end
	ArchyArtifactFrame.SetBackdropColor = function() end
	ArchyArtifactFrame.SetBackdropBorderColor = function() end

-->>-- Hook ldb object to skin status bars
	self:SecureHook(LibStub("LibDataBroker-1.1"):GetDataObjectByName("Archy"), "OnEnter", function(this)
		for i = 5, 15 do -- only 10 races
			if this.tooltip
			and this.tooltip.lines
			and this.tooltip.lines[i]
			and this.tooltip.lines[i].cells
			and this.tooltip.lines[i].cells[6]
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
