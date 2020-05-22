local _, aObj = ...
if not aObj:isAddonEnabled("ProfessionsComplete") then return end
local _G = _G

aObj.addonsToSkin.ProfessionsComplete = function(self) -- v 3.0

	self:SecureHookScript(_G.ProfessionsCompleteUIMainFrame, "OnShow", function(this)

		local fName = this:GetName()

		local function addTabFrame(id)
			aObj:addSkinFrame{obj=_G[fName .. "Tab" .. id .. "SubFrame"], ft="a", kfs=true, nb=true, aso={bd=10, ng=true}, ofs=10, y2=-5}
		end

		self:removeNineSlice(this.NineSlice)
		self:addSkinFrame{obj=this, ft="a", kfs=true, ri=true}
		self:skinTabs{obj=_G[fName .. "SubFrameHeader"], regs={}, ignore=true, up=true, lod=true, x1=2, y1=-2, x2=-2, y2=-2}

		-- Monitor
		local btn = _G[fName .. "Tab1SubFrameNameColumnHeaderButton"]
		self:removeRegions(btn, {1, 2, 3})
		self:addSkinFrame{obj=btn, ft="a", nb=true, ofs=1}
		btn = _G[fName .. "Tab1SubFrameCooldownsColumnHeaderButton"]
		self:removeRegions(btn, {1, 2, 3})
		self:addSkinFrame{obj=btn, ft="a", nb=true, ofs=1}
		btn = nil
		self:skinSlider{obj=_G[fName .. "Tab1SubFrameScrollFrame"].ScrollBar, rt="artwork"}
		addTabFrame(1)
		if self.modBtnBs then
			for i = 1, 12 do
				for j = 1, 16 do
					self:addButtonBorder{obj=_G[fName .. "Tab1SubFrame_ScrollFrameButton" .. i .. "Cooldowns" .. j], ofs=3, clr="grey"}
				end
			end
		end

		-- Characters
		self:skinDropDown{obj=_G[fName .. "Tab2SubFrameCharacterDropDownMenu"]}
		self:skinSlider{obj=_G[fName .. "Tab2SubFrameScrollFrame"].ScrollBar, rt="artwork"}
		addTabFrame(2)
		if self.modBtns then
			self:skinStdButton{obj=_G[fName .. "Tab2SubFrameUncheckAllButton"]}
			self:skinStdButton{obj=_G[fName .. "Tab2SubFrameDeleteCharacterButton"]}
			self:skinStdButton{obj=_G[fName .. "Tab2SubFrameCheckAllButton"]}
		end
		if self.modBtnBs then
			for i = 1, _G[fName .. "Tab2SubFrameScrollFrame"].numToDisplay do
				self:addButtonBorder{obj=_G[fName .. "Tab2SubFrame_ScrollFrameButton" .. i .. "_IconTexture"], clr="grey"}
			end
		end
		if self.modChkBtns then
			for i = 1, _G[fName .. "Tab2SubFrameScrollFrame"].numToDisplay do
				self:skinCheckButton{obj=_G[fName .. "Tab2SubFrame_ScrollFrameButton" .. i .. "_Check"]}
			end
		end

		-- Professions
		self:skinDropDown{obj=_G[fName .. "Tab3SubFrameProfessionDropDownMenu"]}
		self:skinSlider{obj=_G[fName .. "Tab3SubFrameScrollFrame"].ScrollBar, rt="artwork"}
		addTabFrame(3)
		if self.modBtns then
			self:skinStdButton{obj=_G[fName .. "Tab3SubFrameImportButton"]}
			self:skinStdButton{obj=_G[fName .. "Tab3SubFrameDefaultsButton"]}
			self:skinStdButton{obj=_G[fName .. "Tab3SubFrameExportButton"]}
			for i = 1, _G[fName .. "Tab3SubFrameScrollFrame"].numToDisplay do
				self:skinExpandButton{obj=_G[fName .. "Tab3SubFrame_ScrollFrameButton" .. i .. "_DeleteButton"], as=true}
			end
		end
		if self.modBtnBs then
			for i = 1, _G[fName .. "Tab3SubFrameScrollFrame"].numToDisplay do
				self:addButtonBorder{obj=_G[fName .. "Tab3SubFrame_ScrollFrameButton" .. i .. "_IconTexture"], clr="grey"}
			end
		end

		-- Options
		addTabFrame(4)
		if self.modChkBtns then
			self:skinCheckButton{obj=_G[fName .. "Tab4SubFrameOpenWithTradeSKillCheckButton"]}
			self:skinCheckButton{obj=_G[fName .. "Tab4SubFrameShowMinimapButtonCheckButton"]}
			self:skinCheckButton{obj=_G[fName .. "Tab4SubFrameShowCharacterRealmsCheckButton"]}
			self:skinCheckButton{obj=_G[fName .. "Tab4SubFrameShowDeleteCooldownConfirmDialogCheckButton"]}
		end

		-- Help
		addTabFrame(5)

		fName = nil
		self:Unhook(this, "OnShow")
	end)

end
