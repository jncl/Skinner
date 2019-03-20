local aName, aObj = ...
if not aObj:isAddonEnabled("LiteBag") then return end
local _G = _G

aObj.addonsToSkin.LiteBag = function(self) -- v 8.1.2

	local function skinFrame(frame)
		-- bags panel
		if aObj.modBtnBs then
			local btn
			for i = 1, #_G[frame .. "Panel"].bagButtons do
				btn = _G[frame .. "Panel"].bagButtons[i]
				aObj:addButtonBorder{obj=btn, reParent={btn.FilterIcon}, x1=-3, y2=-3}
			end
			btn = nil
			aObj:addButtonBorder{obj=_G[frame].sortButton, ofs=0, y1=1}
		end
		aObj:skinEditBox{obj=_G[frame].searchBox, regs={6, 7}, mi=true, noInsert=true} -- 6 is text, 7 is icon
		-- hook this to move the search box on the Inventory frame
		-- body
		_G[frame .. "MoneyFrameBorder"]:DisableDrawLayer("BACKGROUND")
		_G[frame .. "TokenFrameBorder"]:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=_G[frame], ft="a", kfs=true, ri=true}

		-- tabs
		_G[frame].numTabs = 2
		self:skinTabs{obj=_G[frame], lod=true}
	end

	-- Inventory Panel
	skinFrame("LiteBagInventory")

	-- Bank Panel
	_G.ReagentBankFrame:DisableDrawLayer("ARTWORK") -- bank slots texture
	_G.ReagentBankFrame:DisableDrawLayer("BACKGROUND") -- bank slots shadow texture
	_G.ReagentBankFrame:DisableDrawLayer("BORDER") -- shadow textures
	skinFrame("LiteBagBank")
	if self.modBtns then
		self:skinStdButton{obj=_G.ReagentBankFrame.DespositButton}
	end

	-- skin itemButtons if required
	if self.modBtnBs then
		self:SecureHook("LiteBagPanel_UpdateBagSlotCounts", function(this)
			local btn
			for i = 1, #this.itemButtons do
				btn = this.itemButtons[i]
				btn:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=btn, ibt=true, reParent={btn.IconQuestTexture}, grey=true}
			end
			btn = nil
		end)
		self:SecureHookScript(_G.ReagentBankFrame, "OnShow", function(this)
			for i = 1, this.size do
				self:addButtonBorder{obj=this["Item" .. i], ibt=true, reParent={this["Item" .. i].IconQuestTexture}, grey=true}
			end
			self:Unhook(this, "OnShow")
		end)

	end

	-- Options
	self.RegisterCallback("LiteBag", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "LiteBag" then return end
		self.iofSkinnedPanels[panel] = true

		-- Global
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.LiteBagOptionsConfirmSort}
			self:skinCheckButton{obj=_G.LiteBagOptionsEquipsetDisplay}
			self:skinCheckButton{obj=_G.LiteBagOptionsBindsOnDisplay}
			self:skinCheckButton{obj=_G.LiteBagOptionsSnapToPosition}
		end
		self:skinDropDown{obj=_G.LiteBagOptionsIconBorder, x2=56}
		self:addSkinFrame{obj=_G.LiteBagOptionsGlobalBox, ft="a", kfs=true, nb=true, aso={bd=10, ng=true}}

		-- Bank
		self:skinSlider{obj=_G.LiteBagOptionsBankColumns, hgt=-2}
		self:skinSlider{obj=_G.LiteBagOptionsBankScale, hgt=-2}
		self:skinSlider{obj=_G.LiteBagOptionsBankXBreak, hgt=-2}
		self:skinSlider{obj=_G.LiteBagOptionsBankYBreak, hgt=-2}
		self:skinDropDown{obj=_G.LiteBagOptionsBankOrder, x2=109}
		self:skinDropDown{obj=_G.LiteBagOptionsBankLayout, x2=109}
		self:addSkinFrame{obj=_G.LiteBagOptionsBankBox, ft="a", kfs=true, nb=true, aso={bd=10, ng=true}}

		-- Inventory
		self:skinSlider{obj=_G.LiteBagOptionsInventoryColumns, hgt=-2}
		self:skinSlider{obj=_G.LiteBagOptionsInventoryScale, hgt=-2}
		self:skinSlider{obj=_G.LiteBagOptionsInventoryXBreak, hgt=-2}
		self:skinSlider{obj=_G.LiteBagOptionsInventoryYBreak, hgt=-2}
		self:skinDropDown{obj=_G.LiteBagOptionsInventoryOrder, x2=109}
		self:skinDropDown{obj=_G.LiteBagOptionsInventoryLayout, x2=109}
		self:addSkinFrame{obj=_G.LiteBagOptionsInventoryBox, ft="a", kfs=true, nb=true, aso={bd=10, ng=true}}

		self.UnregisterCallback("LiteBag", "IOFPanel_Before_Skinning")
	end)

end
