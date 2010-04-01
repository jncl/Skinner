if not Skinner:isAddonEnabled("XLoot") then return end

function Skinner:XLoot()

	-- Hook the XLoot copy of the original skinning function ;-)
	self:RawHook(XLoot, "Skin", function(this, frame)
--		self:Debug("XL_Skin [%s, %s]", this, frame:GetName())
		self:skinXLoot(frame)
	end, true)

	self:SecureHook(XLoot, "AddLootFrame", function(this, id)
--		self:Debug("XL_ALF [%s, %s]", this, id)
		for _, frame in pairs(XLoot.frames) do
			self:skinXLoot(frame)
		end
		for _, button in pairs(XLoot.buttons) do
			self:skinXLoot(button.wrapper)
		end
	end)

	self:skinXLoot(XLootFrame)
	self:skinXLoot(XLootButton1.wrapper)
	self:skinXLoot(XLootButtonFrame1)

end

function Skinner:XLootGroup()

	self:applySkin(XLootGroup.AA.stacks.roll.frame)

end

function Skinner:XLootMonitor()

	self:applySkin(XLootMonitor.AA.stacks.loot.frame)

	self:SecureHook(XLootMonitor, "HistoryExportCopier", function(text)
		self:applySkin(XLootHistoryEditFrame)
		self:Unhook(XLootMonitor, "HistoryExportCopier")
	end)

end

function Skinner:skinXLoot(frame)

--	self:Debug("skinXLoot [%s, %s]", frame:GetName(), self.skinned[frame])

	if not self.skinned[frame] then
		self:applySkin(frame)
		frame.SetBackdropBorderColor = function() end
		if strfind(frame:GetName(), "Wrapper") then
			LowerFrameLevel(frame)
			frame.SetBackdrop = function() end
			local button = frame:GetParent()
			frame:SetWidth(button:GetWidth() + 9)
			frame:SetHeight(button:GetHeight() + 9)
			local xlr = strfind(frame:GetName(), "XLRow")
			if xlr and button.border then
				button.border:SetTexture(nil)
				button.border.Show = function() end
			end
		end
	end

end
