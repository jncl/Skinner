local _, aObj = ...
if not aObj:isAddonEnabled("BetterWardrobe") then return end
local _G = _G

aObj.addonsToSkin.BetterWardrobe = function(self) -- v 3.0

	local ddName, ddObj
	self:SecureHook("BW_UIDropDownMenu_CreateFrames", function(level, index)
		for i = 1, index do
			ddName = "BW_DropDownList" .. i
			ddObj = _G[ddName]
			if ddObj then
				self:keepFontStrings(ddObj.Border)
				_G[ddName .. "MenuBackdrop"]:SetBackdrop(nil)
				if not _G[ddName].sf then
					self:skinObject("frame", {obj=ddObj, ofs=-2})
				end
			end
		end
		ddName, ddObj = nil, nil
	end)

	local skinPageBtns
	if self.modBtnBs then
		function skinPageBtns(frame)
			aObj:addButtonBorder{obj=frame.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
			aObj:addButtonBorder{obj=frame.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
			aObj:clrPNBtns(frame.PagingFrame, true)
			aObj:SecureHook(frame.PagingFrame, "Update", function(this)
				aObj:clrPNBtns(this, true)
			end)
		end
	end
	
	local x1Ofs, y1Ofs, x2Ofs, y2Ofs = -4, 2, 7, -4
	self:SecureHookScript(_G.BetterWardrobeCollectionFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-4, x2=-2, y2=self.isTT and -4 or 0}})
		self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
		self:skinStatusBar{obj=this.progressBar, fi=0}
		self:removeRegions(this.progressBar, {2, 3})
		self:skinObject("dropdown", {obj=_G.BW_SortDropDown})
		self:skinObject("dropdown", {obj=_G.BW_CollectionList_Dropdown, x2=109})
		if self.modBtns then
			self:skinStdButton{obj=this.FilterButton}
			self:SecureHook(this.FilterButton, "SetEnabled", function(this, _)
				self:clrBtnBdr(this)
			end)
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.BW_SetsHideSlotButton, ofs=-2, x1=1, clr="gold"}
			self:addButtonBorder{obj=_G.BW_CollectionListButton, ofs=2, x1=-1, y1=1}
			self:addButtonBorder{obj=_G.BW_CollectionListOptionsButton, ofs=-2, x1=1, clr="gold"}
		end
	
		local function updBtnClr(btn)
			local atlas = btn.Border:GetAtlas()
			if atlas:find("uncollected", 1, true) then
				aObj:clrBtnBdr(btn, "grey")
			elseif atlas:find("unusable", 1, true) then
				aObj:clrBtnBdr(btn, "unused")
			else
				aObj:clrBtnBdr(btn, "gold", 0.75)
			end
		end
		self:SecureHookScript(this.ItemsCollectionFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=this.WeaponDropDown})
			self:skinObject("frame", {obj=this, fType=ftype, fb=true, kfs=true, rns=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtnBs then
				skinPageBtns(this)
				for _, btn in _G.pairs(this.Models) do
					self:removeRegions(btn, {2}) -- background & border
					self:addButtonBorder{obj=btn, reParent={btn.NewString, btn.Favorite.Icon, btn.HideVisual.Icon}, ofs=6}
					updBtnClr(btn)
				end
				self:SecureHook(this, "UpdateItems", function(this)
					for _, btn in _G.pairs(this.Models) do
						updBtnClr(btn)
					end
				end)
			end
			
			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.ItemsCollectionFrame)
		
		self:SecureHookScript(this.SetsCollectionFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:keepFontStrings(this.RightInset)
			self:removeNineSlice(this.RightInset.NineSlice)
			self:skinObject("slider", {obj=this.ScrollFrame.scrollBar, fType=ftype})
			for _, btn in _G.pairs(this.ScrollFrame.buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					 self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Favorite}}
				end
			end
			this.DetailsFrame:DisableDrawLayer("BACKGROUND")
			this.DetailsFrame:DisableDrawLayer("BORDER")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtnBs then
				local function colourBtns(sFrame)
					for _, btn in _G.pairs(sFrame.buttons) do
						btn:DisableDrawLayer("BACKGROUND")
						aObj:clrBtnBdr(btn, btn.Icon:IsDesaturated() and "grey")
					end
				end
				colourBtns(this.ScrollFrame)
				self:SecureHook(this.ScrollFrame, "update", function(this) -- use lowercase for scrollframe function
					colourBtns(this)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
	
		self:SecureHookScript(this.SetsTransmogFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=this.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
				self:clrPNBtns(this.PagingFrame, true)
				self:SecureHook(this.PagingFrame, "Update", function(this)
					self:clrPNBtns(this, true)
				end)
				for _, btn in _G.pairs(this.Models) do
					self:removeRegions(btn, {2}) -- background & border
					self:addButtonBorder{obj=btn, reParent={btn.Favorite.Icon}, ofs=6}
					local atlas = btn.Border:GetAtlas()
					if atlas:find("uncollected", 1, true) then
						aObj:clrBtnBdr(btn, "grey")
					elseif atlas:find("unusable", 1, true) then
						aObj:clrBtnBdr(btn, "unused")
					else
						aObj:clrBtnBdr(btn, "gold", 0.75)
					end
				end
			end
			
			self:Unhook(this, "OnShow")
		end)
	
		self:Unhook(this, "OnShow")
	end)

end
