local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot") then return end

function aObj:XLoot()

	-- check to see if this is the dummy plugin version
	if not XLoot.AddLootFrame then return end

	local btn, br, bg, bb, ba
	local r, g, b, a = unpack(self.bbColour)
	local function btnUpd()
		for i = 1, GetNumLootItems() do
			btn = XLoot.buttons[i]
			if btn.border:IsVisible() then
				btn.sknrBdr:SetBackdrop(aObj.modUIBtns.iqbDrop)
				br, bg, bb, ba = btn.border:GetVertexColor()
				btn.sknrBdr:SetBackdropBorderColor(br, bg, bb, 1)
				btn.sknrBdr:SetAlpha(1)
			else
				btn.sknrBdr:SetBackdrop(aObj.modUIBtns.bDrop)
				btn.sknrBdr:SetBackdropBorderColor(r, g, b, a)
			end
		end
	end
	local function skinXLoot(frame)

		if frame:GetName():find("Wrapper") then -- button wrapper
			frame:SetBackdrop({edgeSize=0}) -- remove unwanted elements
			frame.SetBackdropColor = function() end
			frame.SetBackdropBorderColor = function() end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame:GetParent(), ibt=true}
			end
		else -- row frame
			aObj:addSkinFrame{obj=frame}
			frame.border:SetTexture(nil)
		end

	end
	-- disable the original skinning function
	XLoot.Skin = function() end

	-- hook this to skin new objects
	self:SecureHook(XLoot, "AddLootFrame", function(this, id)
		skinXLoot(XLoot.buttons[id].wrapper)
		skinXLoot(XLoot.frames[id])
	end)

	self:addSkinFrame{obj=XLoot.frame}
	-- skin existing objects
	skinXLoot(XLoot.buttons[1].wrapper)
	skinXLoot(XLoot.frames[1])

	if self.modBtnBs then
		 -- hook this to update buttons
		 self:SecureHook(XLoot, "Update", function(this)
		 	if this.swiftlooting then return end
			btnUpd()
		 end)
	end

end

function aObj:XLootGroup()

	if XLootGroup.AA then
		self:applySkin(XLootGroup.AA.stacks.roll.frame)
	else
		self:addSkinFrame{obj=XLootGroup.anchor, kfs=true, nb=true}
	end

end

function aObj:XLootMonitor()

	self:applySkin(XLootMonitor.AA.stacks.loot.frame)

	self:SecureHook(XLootMonitor, "HistoryExportCopier", function(text)
		self:applySkin(XLootHistoryEditFrame)
		self:Unhook(XLootMonitor, "HistoryExportCopier")
	end)

end
