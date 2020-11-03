local _, aObj = ...
if not aObj:isAddonEnabled("mOnArs_WardrobeHelper") then return end
local _G = _G

aObj.addonsToSkin.mOnArs_WardrobeHelper = function(self) -- v 1.20

	self:SecureHookScript(_G.mOnWD_MainFrame, "OnShow", function(this)
		this.ListFrame.RowFrame.BG:SetTexture(nil)
		self:addSkinFrame{obj=this.ListFrame.col1Header, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=this.ListFrame.col2Header, ft="a", kfs=true, nb=true}
		self:moveObject{obj=this.ListFrame.ColL2, x=-10}
		for i = 1, 2 do
			for _, ltr in _G.pairs{"L", "M", "R"} do
				this.ListFrame["Col" .. ltr .. i]:SetTexture(nil)
			end
			for _, ltr in _G.pairs{"T", "TT"} do
				this.ListFrame["Col" .. ltr .. i]:SetParent(this.ListFrame["col" .. i .. "Header"].sf)
			end
		end
		for _, row in pairs(this.ListFrame.RowFrame.rows) do
			self:skinStatusBar{obj=row.status, fi=0}
		end
		self:skinSlider{obj=this.ListFrame.scrollbar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true}
		if self.modBtns then
			self:skinStdButton{obj=this.ListFrame.bRefresh}
			self:skinStdButton{obj=this.ListFrame.bInstance}
		end
		if self.modBtnBs then
			-- hook this to add button borders to items on ItemFrame
			self:SecureHook(_G.mOnWardrobe, "refreshItemContent", function()
				for _, btn in _G.pairs(_G.mOnWD_MainFrame.ItemFrame.contentFrame.Items) do
					self:addButtonBorder{obj=btn, relTo=btn.texture}
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.hideList}
		end

		self:SecureHookScript(this.ItemFrame, "OnShow", function(this)
			self:skinSlider{obj=this.scrollbar}
			self:skinDropDown{obj=_G.mOnWD_ItemFrame_DropDown}
			self:moveObject{obj=this.bHide, y=2}
			self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 2), noSkin=true}
				self:skinStdButton{obj=this.bMiniList, ofs=0}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.bHide, ofs=-2, x1=0, clr="gold"}
				self:addButtonBorder{obj=this.bRefresh, ofs=-3, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.mOnWD_OptionsFrame, "OnShow", function(this)
		self:moveObject{obj=this.title, y=-6}
		self:addFrameBorder{obj=self:getChild(this.panelSelect, 1), ft="a"} -- LHS panel
		self:addFrameBorder{obj=this.panel.border, ft="a"} -- RHS panel
		for i = 1, #this.tabOptions do
			for _, tab in _G.pairs{this.tabItems[i]} do
				for _, obj in _G.pairs(tab) do
					if obj:IsObjectType("EditBox") then
						self:skinEditBox{obj=obj, regs={6}} -- 6 is text
					elseif obj:IsObjectType("CheckButton")
					and self.modChkBtns
					then
						self:skinCheckButton{obj=obj}
					end
				end
			end
		end
		this.blacklist.bg:SetTexture(nil)
		self:skinSlider{obj=this.blacklist.scrollbar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=this.bClose, ofs=-2}
			self:skinStdButton{obj=this.bDef, ofs=-2}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.mOnWD_MiniList, "OnShow", function(this)
		self:skinStatusBar{obj=this.status, fi=0}
		self:skinSlider{obj=this.list.scrollbar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=5}
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(this, 1)}
		end

		self:Unhook(this, "OnShow")
	end)

end
