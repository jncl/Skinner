local _, aObj = ...
if not aObj:isAddonEnabled("AtlasLoot")
and not aObj:isAddonEnabled("AtlasLootClassic")
then
	return
end
local _G = _G

local function skinAtlasLoot()

	local function skinDropDown(obj)
		obj.frame:SetBackdrop(nil)
		if aObj.db.profile.TexturedDD then
			-- add texture
			obj.frame.ddTex = obj.frame:CreateTexture(nil, "ARTWORK")
			obj.frame.ddTex:SetTexture(aObj.db.profile.TexturedDD and aObj.itTex or nil)
			obj.frame.ddTex:SetPoint("LEFT", obj.frame, "LEFT", 2, 0)
			obj.frame.ddTex:SetPoint("RIGHT", obj.frame, "RIGHT", -1, 0)
			obj.frame.ddTex:SetHeight(20)
		end
		aObj:skinObject("frame", {obj=obj.frame, kfs=true, ng=true})
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=obj.frame.button, es=12, ofs=-2}
		end
		-- hook this to skin dropdown frame(s)
		aObj:SecureHookScript(obj.frame.button, "OnClick", function(this)
			for _, child in _G.ipairs{this.par.frame:GetChildren()} do
				if child.label
				and child.buttons
				and child.type == "frame"
				then
					aObj:skinObject("frame", {obj=child, kfs=true})
				end
			end

			aObj:Unhook(obj.frame.button, "OnClick")
		end)
	end
	local function skinSelect(obj)
		aObj:skinObject("slider", {obj=obj.frame.scrollbar})
		aObj:skinObject("frame", {obj=obj.frame, kfs=true, fb=true})
	end

	local frame = _G.AtlasLoot.GUI.frame
	frame.titleFrame:SetBackdrop(nil)
	skinDropDown(frame.moduleSelect)
	skinDropDown(frame.subCatSelect)
	skinSelect(frame.difficulty)
	skinSelect(frame.boss)
	skinSelect(frame.extra)
	aObj:skinObject("frame", {obj=frame, kfs=true, cb=true, ofs=0, y1=-3, x2=-3})
	if not aObj.isRtl then
		frame.gameVersionLogo:SetAlpha(1)
	end

	frame.contentFrame:DisableDrawLayer("BACKGROUND")
	if not aObj.isRtl then
		aObj:skinObject("editbox", {obj=frame.contentFrame.searchBox, si=true, y1=-4, y2=4})
	end
	aObj:SecureHookScript(frame.contentFrame.clasFilterButton, "OnClick", function(this)
		if this.selectionFrame then
			aObj:skinObject("frame", {obj=this.selectionFrame, kfs=true, fb=true, ofs=0})
			aObj:Unhook(this, "OnClick")
		end
	end)
	if aObj.modBtns then
		aObj:skinStdButton{obj=frame.contentFrame.itemsButton}
		aObj:skinStdButton{obj=frame.contentFrame.modelButton}
	end
	if aObj.modBtnBs then
		aObj:addButtonBorder{obj=frame.contentFrame.nextPageButton, ofs=-2, x1=1, y2=1, clr="gold"}
		aObj:addButtonBorder{obj=frame.contentFrame.prevPageButton, ofs=-2, x1=1, y2=1, clr="gold"}
		aObj:addButtonBorder{obj=frame.contentFrame.mapButton, ofs=-1, x1=2, x2=-2}
		aObj:addButtonBorder{obj=frame.contentFrame.clasFilterButton}
		if aObj.isRtl then
			aObj:addButtonBorder{obj=frame.contentFrame.transmogButton}
		end
	end

	-- Tooltip(s)
	if aObj.db.profile.Tooltips.skin then
		-- tooltip
		_G.C_Timer.After(0.1, function()
			aObj:add2Table(aObj.ttList, _G.AtlasLootTooltip)
		end)
		if aObj.isRtl then
			-- skin Mount tooltip
			local mTT = _G.AtlasLoot.Button:GetType("Mount")
			if mTT then
				aObj:SecureHook(mTT, "ShowToolTipFrame", function(_)
					aObj:skinObject("frame", {obj=mTT.tooltipFrame, kfs=true})

					aObj:Unhook(mTT, "ShowToolTipFrame")
				end)
			end
			-- skin Pet tooltip
			local pTT = _G.AtlasLoot.Button:GetType("Pet")
			if pTT then
				aObj:SecureHook(pTT, "ShowToolTipFrame", function(_)
					aObj:skinObject("frame", {obj=pTT.tooltipFrame, kfs=true})

					aObj:Unhook(pTT, "ShowToolTipFrame")
				end)
			end
		end
		local fTT = _G.AtlasLoot.Button:GetType("Faction")
		if fTT then
			aObj:SecureHook(fTT, "ShowToolTipFrame", function(button)
				if aObj.isClsc
				and not _G.GetFactionInfoByID(button.FactionID)
				then
					return
				end
				aObj:removeBackdrop(fTT.tooltipFrame.standing)
				aObj:skinObject("statusbar", {obj=fTT.tooltipFrame.standing.bar, fi=0})
				aObj:skinObject("frame", {obj=fTT.tooltipFrame, kfs=true})

				aObj:Unhook(fTT, "ShowToolTipFrame")
			end)
		end
		local sTT = _G.AtlasLoot.Button:GetType("Set")
		if sTT then
			aObj:SecureHook(sTT, "ShowToolTipFrame", function(button)
				if not button.Items then return end
				aObj:removeBackdrop(sTT.tooltipFrame.modelFrame)
				if aObj.isClsc then
					aObj:skinObject("frame", {obj=sTT.tooltipFrame.bonusDataFrame, kfs=true})
				end
				aObj:skinObject("frame", {obj=sTT.tooltipFrame, kfs=true})

				aObj:Unhook(sTT, "ShowToolTipFrame")
			end)
		end
		local iTT = _G.AtlasLoot.Button:GetType("Item")
		if iTT then
			aObj:SecureHook(iTT, "ShowQuickDressUp", function(itemLink, ttFrame)
				if aObj.isRtl then
					if not itemLink
					or not _G.IsEquippableItem(itemLink)
					then
						return
					end
				else
					if not itemLink
					or not ttFrame
					or (not _G.IsEquippableItem(itemLink) and not _G.AtlasLoot.Data.Companion.IsCompanion(itemLink))
					then
						return
					end
				end
				aObj:skinObject("frame", {obj=iTT.previewTooltipFrame, kfs=true})

				aObj:Unhook(iTT, "ShowQuickDressUp")
			end)
		end
	end

	-- Minimap Button
	if _G.AtlasLoot.MiniMapButton.frame then
		aObj:removeRegions(_G.AtlasLoot.MiniMapButton.frame, {2, 3}) -- Border & Background
		aObj:addSkinButton{obj=_G.AtlasLoot.MiniMapButton.frame, parent=_G.AtlasLoot.MiniMapButton.frame, sap=true}
	end

	if aObj.isRtl
	and aObj.modBtnBs
	then
		_G.AtlasLootToggleFromWorldMap2:GetNormalTexture():SetTexture([[Interface\Icons\INV_Box_01]])
		_G.AtlasLootToggleFromWorldMap2:SetScale(0.5)
		aObj:addButtonBorder{obj=_G.AtlasLootToggleFromWorldMap2}
	end

	if not aObj.isRtl then
		aObj:RawHook(_G.AtlasLoot.Button, "ExtraItemFrame_GetFrame", function(this, ...)
			local eiFrame = aObj.hooks[this].ExtraItemFrame_GetFrame(this, ...)
			aObj:skinObject("frame", {obj=eiFrame, ofs=0})
			aObj:Unhook(this, "ExtraItemFrame_GetFrame")
			return eiFrame
		end, true)
		local Fav = _G.AtlasLoot.Addons:GetAddon("Favourites")
		if Fav then
			aObj:SecureHook(Fav.GUI, "Create", function(this)
				aObj:removeBackdrop(this.frame.titleFrame)
				aObj:removeBackdrop(this.frame.content.slotBg)
				aObj:removeBackdrop(this.frame.content.headerBg)
				aObj:removeBackdrop(this.frame.content.bottomBg)
				aObj:removeBackdrop(this.frame.content.itemListBg)
				aObj:skinObject("dropdown", {obj=this.frame.content.listSelect})
				aObj:skinObject("editbox", {obj=this.frame.content.editBox, y1=-4, y2=4})
				aObj:skinObject("slider", {obj=this.frame.content.scrollFrame.scrollbar})
				aObj:skinObject("frame", {obj=this.frame, kfs=true, cb=true, ofs=0, y1=-1})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.frame.content.optionsButton}
					aObj:skinStdButton{obj=this.frame.content.showAllItems}
				end
				if aObj.modBtnBs then
					local function setBtnClr(tex, quality)
						aObj:Debug("AL setBtnClr: [%s, %s]", tex, quality)
						aObj:setBtnClr(tex:GetParent(), quality)
					end
					for _, btn in _G.pairs(this.frame.content.slotFrame.slots) do
						btn.overlay:SetAlpha(0)
						btn.overlay.SetQualityBorder = setBtnClr
						aObj:addButtonBorder{obj=btn, reParent={btn.count, btn.ownedItem}}
						aObj:setBtnClr(btn)
					end
					aObj:SecureHook(this.frame.content.slotFrame, "ResetSlots", function(slObj)
						for _, btn in _G.pairs(slObj.slots) do
							aObj:setBtnClr(btn)
						end
					end)
					aObj:SecureHook(this.frame.content.scrollFrame, "SetItems", function(sfObj)
						for _, btn in _G.pairs(sfObj.itemButtons) do
							btn.overlay:SetAlpha(0)
							btn.overlay.SetQualityBorder = setBtnClr
							aObj:addButtonBorder{obj=btn, reParent={btn.count, btn.ownedItem}}
							aObj:setBtnClr(btn, _G.C_Item.GetItemQualityByID(btn.ItemID))
						end
					end)
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=this.frame.content.isGlobal.frame}
				end

				aObj:Unhook(Fav.GUI, "Create")
			end)
		end
	end

end

aObj.addonsToSkin.AtlasLoot = function(_) -- v 8.13.01

	skinAtlasLoot()

end
aObj.addonsToSkin.AtlasLootClassic = function(_) -- v 3.0.6

	skinAtlasLoot()

end
