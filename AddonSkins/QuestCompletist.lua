local aName, aObj = ...
if not aObj:isAddonEnabled("QuestCompletist") then return end

function aObj:QuestCompletist()

	-- Toast frame
	self:removeRegions(qcToast, {1, 2})
	self:addSkinFrame{obj=qcToast, x1=18, y1=-7, x2=-18, y2=7}
	-- Main frame
	self:skinDropDown{obj=qcCategoryDropdownMenu}
	self:adjWidth{obj=qcMenuSlider, adj=-12}
	self:skinSlider{obj=qcMenuSlider}
	self:skinEditBox{obj=qcSearchBox, regs={9}, mi=true}
	self:addSkinFrame{obj=qcQuestCompletistUI, kfs=true, x1=10, y1=-12, x2=-32, y2=71}
	-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			qcMapTooltip:SetBackdrop(self.Backdrop[1])
			qcQuestReputationTooltip:SetBackdrop(self.Backdrop[1])
			qcQuestInformationTooltip:SetBackdrop(self.Backdrop[1])
			qcToastTooltip:SetBackdrop(self.Backdrop[1])
			qcNewDataAlertTooltip:SetBackdrop(self.Backdrop[1])
			qcMutuallyExclusiveAlertTooltip:SetBackdrop(self.Backdrop[1])
		end
		self:SecureHookScript(qcMapTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(qcQuestReputationTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(qcQuestInformationTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(qcToastTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(qcNewDataAlertTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(qcMutuallyExclusiveAlertTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
