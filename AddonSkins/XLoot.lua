local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot") then return end

function aObj:XLoot()

	-- check to see if this is the dummy plugin version
	if not XLoot.AddLootFrame then return end

	local function skinXLoot(frame)

		if frame.wrapper then
			frame.wrapper:SetBackdrop({edgeSize=0}) -- remove unwanted elements
			frame.wrapper.SetBackdropColor = function() end
			frame.wrapper.SetBackdropBorderColor = function() end
			aObj:addButtonBorder{obj=frame, ibt=true}
		else -- row frame
			aObj:addSkinFrame{obj=frame}
			frame.border:SetTexture(nil)
		end

	end
	-- disable the original skinning function
	XLoot.Skin = function() end

	-- hook this to skin new objects
	self:SecureHook(XLoot, "AddLootFrame", function(this, id)
		skinXLoot(XLoot.buttons[id])
		skinXLoot(XLoot.frames[id])
	end)

	-- skin the main frame
	self:addSkinFrame{obj=XLoot.frame, nb=true}
	self:skinButton{obj=XLoot.closebutton, cb=true}
	-- skin existing objects
	skinXLoot(XLoot.buttons[1])
	skinXLoot(XLoot.frames[1])

	if self.modBtnBs then
		local btn, br, bg, bb, ba
		local r, g, b, a = unpack(self.bbColour)
		 -- hook this to update buttons
		 self:SecureHook(XLoot, "Update", function(this)
		 	if this.swiftlooting then return end
			for i = 1, GetNumLootItems() do
				btn = XLoot.buttons[i]
				if btn.border:IsVisible() then
					btn.sb:SetBackdrop(aObj.modUIBtns.iqbDrop)
					br, bg, bb, ba = btn.border:GetVertexColor()
					btn.sb:SetBackdropBorderColor(br, bg, bb, 1)
					btn.sb:SetAlpha(1)
				else
					btn.sb:SetBackdrop(aObj.modUIBtns.bDrop)
					btn.sb:SetBackdropBorderColor(r, g, b, a)
				end
			end
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
