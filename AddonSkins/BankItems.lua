local aName, aObj = ...
if not aObj:isAddonEnabled("BankItems") then return end

function aObj:BankItems()
	if not self.db.profile.BankFrame then return end

	self:SecureHook("BankItems_CreateFrames", function()
		-- Bank Frame
		self:skinDropDown{obj=BankItems_UserDropdown}
		self:skinEditBox{obj=BankItems_SearchBox, regs={9}, mi=true}
		self:addSkinFrame{obj=BankItems_Frame, kfs=true, x1=10, y1=-10, x2=-3, y2=6}
		-- container frames
		local BAGNUMBERS = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 100, 101, 102, 103, 104} -- Equipped is 100, Mail is 101, Currency is 102, AH is 103, VoidStorage is 104
		for _, v in pairs(BAGNUMBERS) do
			self:addSkinFrame{obj=_G["BankItems_ContainerFrame" .. v], kfs=true, x1=6, y1=-5, x2=-3}
		end
		-- GuildBank Frame
		self:skinDropDown{obj=BankItems_GuildDropdown}
		self:addSkinFrame{obj=BankItems_GBFrame, kfs=true, y1=-11}
		-- remove tab texture
		for _, child in pairs{BankItems_GBFrame:GetChildren()} do
			if child:IsObjectType("Frame")
			and self:getInt(child:GetWidth()) == 42
			and self:getInt(child:GetHeight()) == 50
			then
				self:keepFontStrings(child)
				if self.modBtnBs then
					self:addButtonBorder{obj=self:getChild(child, 1)}
				end
			end
		end
		-- add button borders if required
		if self.modBtnBs then
			-- Bag buttons
			for _, v in ipairs(BAGNUMBERS) do
				self:addButtonBorder{obj=_G["BankItems_Bag" .. v], ibt=true}
			end
			-- Bank buttons
			for i = 1, 28 do
				self:addButtonBorder{obj=_G["BankItems_Item" .. i], ibt=true}
			end
			-- Bag Container buttons
			for _, v in ipairs(BAGNUMBERS) do
				for j = 1, MAX_CONTAINER_ITEMS do
					self:addButtonBorder{obj=_G["BankItems_ContainerFrame" .. v .. "Item" .. j], ibt=true}
				end
			end
			-- GuildBank buttons
			for i = 1, 98 do
				self:addButtonBorder{obj=_G["BankItems_GBFrame_Button" .. i], ibt=true}
			end
		end
		self:Unhook("BankItems_CreateFrames")
	end)

-->>--	Export/Search Frame
	self:skinScrollBar{obj=BankItems_ExportFrame_Scroll}
	self:skinDropDown{obj=BankItems_ExportFrame_SearchDropDown}
	self:skinEditBox{obj=BankItems_ExportFrame_SearchTextbox, regs={9}}
	self:skinButton{obj=BankItems_ExportFrameButton}
	self:skinButton{obj=BankItems_ExportFrame_ResetButton}
	self:addSkinFrame{obj=BankItems_ExportFrame, kfs=true}

end
