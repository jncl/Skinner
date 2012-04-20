local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot") then return end

local function skinXLoot(frame)

	if not aObj.skinned[frame] then
		aObj:applySkin(frame)
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

function aObj:XLoot()

	-- check to see if this is the dummy plugin version
	if not XLoot.AddLootFrame then return end

	-- Hook the XLoot copy of the original skinning function
	self:RawHook(XLoot, "Skin", function(this, frame)
		skinXLoot(frame)
	end, true)

	self:SecureHook(XLoot, "AddLootFrame", function(this, id)
		skinXLoot(XLoot.frames[id])
		skinXLoot(XLoot.buttons[id].wrapper)
	end)

	self:skinButton{obj=XLootCloseButton, cb=true}
	skinXLoot(XLoot.frame)
	skinXLoot(XLoot.frames[1])
	skinXLoot(XLoot.buttons[1].wrapper)

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
