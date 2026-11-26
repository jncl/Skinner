local _, aObj = ...
if not aObj:isAddonEnabled("HuntersFieldGuide") then return end
local _G = _G

aObj.addonsToSkin.HuntersFieldGuide = function(self) -- v 1.1.1

	local function setTextClr(fStr, heading)
		if heading then
			fStr:SetTextColor(aObj.HT:GetRGB())
		else
			fStr:SetTextColor(aObj.BT:GetRGB())
		end
		fStr.SetTextColor = _G.nop
	end
	self:SecureHookScript(_G.FieldGuideFrame, "OnShow", function(this)
		if _G.InCombatLockdown() then
			self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			return
		end

		-- find and identify Grid entries, Page buttons, Tabs, Detail & Map View child frames
		local gridEntries, tabs, pageBtns, detail, mapView = {}, {}
		if self.modBtnBs then
			pageBtns = {}
		end
		this.tabs = {}
		for _, child in _G.ipairs_reverse{this:GetChildren()} do
			if child.backplate
			and child.border
			and child.slot
			then
				aObj:add2Table(gridEntries, child) -- Forever
			elseif child.bg
			and child.band
			and child.glow
			then
				aObj:add2Table(gridEntries, child) -- Classic
			elseif child:IsObjectType("Button")
			and aObj.modBtnBs
			and child.GetNormalTexture
			and child:GetNormalTexture()
			and child:GetNormalTexture():GetTexture()
			and (child:GetNormalTexture():GetTexture() == 130866
			  or child:GetNormalTexture():GetTexture() == 130869)
			then
				aObj:add2Table(pageBtns, child)
			elseif child.tab then
				aObj:add2Table(tabs, child)
			elseif child.icon
			and child.fav
			and child.mini
			then
				detail = child
			elseif child.idxKey
			and child.M
			then
				mapView = child
			end
		end

		local isForever = false
		-- grid (Forever: 3 cols * 6 rows, Classic: 2 cols * 6 rows)
		if #gridEntries == 18 then
			isForever = true
		end

		local function skinEntry(entry)
			setTextClr(entry.sub)
			if isForever then
				entry.backplate:SetTexture(nil)
				aObj:getRegion(entry.slot, 1):SetTexture(nil) -- shadow texture
				entry.border:SetAlpha(0) -- texture changed in code)
				aObj:getRegion(entry, 3):SetTexture(nil) -- backplate glow
				-- hook this to handle rare text colouring
				local text
				aObj:RawHook(entry.name, "SetTextColor", function(fStr, r, g, b)
					if g <= 0.15 then
						text = aObj.hooks[fStr].SetTextColor(fStr, aObj.HT:GetRGB())
					else
						text = aObj.hooks[fStr].SetTextColor(fStr, r, g, b)
					end
					return text
				end, true)
				entry.name:SetTextColor(entry.name:GetTextColor())
			else
				entry.bg:SetAlpha(0)
				entry.band:SetTexture(nil)
				entry.glow:SetTexture(nil)
			end
		end
		self:moveObject{obj=this.portrait, x=5, y=-8}
		if this.header then
			self:keepFontStrings(this.header)
			setTextClr(this.header.text, true)
		end
		self:skinObject("editbox", {obj=this.search, si=true})
		for _, tab in _G.pairs(tabs) do
			if tab.frame then
				tab.frame:SetTexture(nil)
			else
				self:getRegion(tab, 1):SetTexture(nil)
			end
		end
		if isForever then
			-- skin NineSlice frame so Tab buttons don't just float
			self:skinObject("frame", {obj=this.NineSlice, kfs=true, fb=true, ofs=-1, y1=-69})
		end
		for _, entry in _G.pairs(gridEntries) do
			skinEntry(entry)
		end
		setTextClr(self:getLastRegion(this)) -- Pager text
		if isForever then
			self:skinObject("frame", {obj=this, kfs=true, cb=true})
		else
			self:skinObject("frame", {obj=this, kfs=true, ofs=-10, x2=-30, y2=60})
			this.portrait:SetAlpha(1)
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 1)}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=this.back}
			self:skinStdButton{obj=this.map}
			self:skinStdButton{obj=this.model}
			self:skinStdButton{obj=this.filter}
		end
		if self.modBtnBs then
			for _, pBtn in _G.pairs(pageBtns) do
				self:addButtonBorder{obj=pBtn, ofs=-2, x1=1, clr="gold", sechk=true}
			end
		end

		self:SecureHookScript(_G.FieldGuideFilterMenu, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.clear}
			end

			self:Unhook(_G.FieldGuideFilterMenu, "OnShow")
		end)

		local skinSubFrame = _G.nop
		if isForever then
			function skinSubFrame(frame)
				aObj:skinObject("frame", {obj=frame, kfs=true, fb=true, x1=-84, y1=35, x2=93, y2=-95})
			end
		end
		self:SecureHookScript(this.famInfo, "OnShow", function(fObj)
			for _, col in _G.pairs(this.progress.cols) do
				setTextClr(col.label, true)
				setTextClr(col.value)
				setTextClr(col.count)
			end
			for _, stat in _G.pairs(fObj.stats) do
				setTextClr(stat.label, true)
				setTextClr(stat.value)
			end
			setTextClr(fObj.found.label, true)
			setTextClr(fObj.found.value)
			setTextClr(fObj.found.count)
			if fObj.inHeader then
				setTextClr(fObj.studied.label, true)
				setTextClr(fObj.studied.value)
				setTextClr(fObj.studied.count)
			end
			if fObj.wide and not fObj.inHeader then
				setTextClr(fObj.diet.label, true)
				setTextClr(fObj.diet.value)
			else
				setTextClr(fObj.dietLabel, true)
				setTextClr(fObj.dietText)
			end
			setTextClr(fObj.abLabel, true)
			for _, chip in _G.pairs(fObj.chips) do
				setTextClr(chip.name)
			end
		end)
		self:checkShown(this.famInfo)

		self:SecureHookScript(this.abInfo, "OnShow", function(fObj)
			setTextClr(fObj.cost)
			setTextClr(fObj.desc)
			setTextClr(fObj.fams)
			setTextClr(fObj.rankLabel)
		end)

		local function skinMap(map)
			setTextClr(map.zone, true)
			setTextClr(map.count)
			setTextClr(map.empty)
			for _, row in _G.pairs(map.legend) do
				if row.label then
					setTextClr(row.label, true)
				end
				setTextClr(row.text)
			end
		end
		self:SecureHookScript(detail, "OnShow", function(fObj)
			skinEntry(fObj.icon)
			skinSubFrame(fObj)
			_G.RunNextFrame(function()
				for _, line in _G.pairs(fObj.lines) do
					setTextClr(line)
				end
				if fObj.side then
					for _, line in _G.pairs(fObj.side) do
						setTextClr(line)
					end
				end
			end)
			for _, mapType in _G.pairs{"map", "mapBelow"} do
				skinMap(fObj[mapType])
			end
		end)

		self:SecureHookScript(mapView, "OnShow", function(fObj)
			skinMap(fObj)
		end)

		self:SecureHookScript(this.modelView, "OnShow", function(fObj)
			setTextClr(fObj.name, true)
			setTextClr(fObj.sub)
			setTextClr(fObj.hint)
			setTextClr(fObj.none)
		end)

		self:SecureHookScript(this.petView, "OnShow", function(fObj)
			_G.RunNextFrame(function()
				setTextClr(fObj.none)
				setTextClr(fObj.name, true)
				setTextClr(fObj.level)
				setTextClr(fObj.seen)
				setTextClr(fObj.tamed.text)
				setTextClr(fObj.happy.text)
				setTextClr(fObj.loyal.text)
				setTextClr(fObj.armor)
				for _, res in _G.pairs(fObj.resRow.items) do
					setTextClr(res.text)
				end
				setTextClr(fObj.points)
				setTextClr(fObj.diet)
				setTextClr(fObj.foodRow.label)
				setTextClr(fObj.abHead, true)
				for _, tile in _G.pairs(fObj.tiles) do
					setTextClr(tile.label)
					if tile.step then
						setTextClr(tile.step)
					end
				end
				setTextClr(fObj.abNever)
				setTextClr(fObj.trHead, true)
				for _, tile in _G.pairs(fObj.trTiles) do
					setTextClr(tile.label)
				end
				setTextClr(fObj.stHead, true)
				setTextClr(fObj.stDate)
				setTextClr(fObj.more)
				setTextClr(fObj.stNone)
				for _, card in _G.pairs(fObj.cards) do
					setTextClr(card.name)
					setTextClr(card.sub)
				end
			end)
		end)

		local function skinSectionHead(page)
			for idx, child in _G.ipairs_reverse{page:GetRegions()} do
				if child:IsObjectType("Texture") then
					child:SetAlpha(0)
					setTextClr(self:getRegion(page, idx - 1), true)
				end
			end
		end
		self:SecureHookScript(this.settingsView, "OnShow", function(fObj)
			if fObj.heading then
				setTextClr(fObj.heading, true)
			end
			for _, row in _G.pairs(fObj.rows) do
				setTextClr(row.label)
				-- TODO: skin Checkbox texture
			end
			setTextClr(fObj.unhideText)
			setTextClr(fObj.scanLabel)
			setTextClr(fObj.scanText)
			setTextClr(fObj.discLabel)
			setTextClr(fObj.discText)
			setTextClr(fObj.padLabel)
			setTextClr(fObj.debug.label)
			setTextClr(fObj.lookLabel)
			setTextClr(fObj.sizeLabel)
			setTextClr(fObj.sizeText)
			for _, look in _G.pairs(fObj.looks) do
				setTextClr(look.label)
			end
			setTextClr(fObj.iconLabel)
			self:skinObject("editbox", {obj=fObj.discord})
			setTextClr(fObj.discordNote)
			skinSubFrame(fObj)
			if self.modBtns then
				self:skinStdButton{obj=fObj.unhide, sechk=true}
				self:skinStdButton{obj=fObj.scan}
				self:skinStdButton{obj=fObj.clear}
				self:skinStdButton{obj=fObj.pad}
				self:skinStdButton{obj=fObj.minus}
				self:skinStdButton{obj=fObj.plus}
				self:skinStdButton{obj=fObj.auto}
			end
			-- handle Section Headers
			for _, page in _G.pairs(fObj.pages) do
				skinSectionHead(page)
			end
		end)

		self:SecureHookScript(this.modeChoice, "OnShow", function(fObj)
			--@debug@
			-- _G.Spew("modeChoice", fObj)
			-- _G.Spew("modeChoice step 1", fObj.step1)
			-- _G.Spew("modeChoice step 2", fObj.step2)
			-- _G.Spew("modeChoice sP 1", fObj.subPages[1])
			-- _G.Spew("modeChoice sP 2", fObj.subPages[2])
			--@end-debug@
			-- step1
			setTextClr(fObj.question, true)
			setTextClr(fObj.immersive.name)
			setTextClr(fObj.immersive.what)
			setTextClr(fObj.reveal.name)
			setTextClr(fObj.reveal.what)
			setTextClr(fObj.note)
			-- step3
			setTextClr(fObj.markHead, true)
			setTextClr(fObj.markText)
			setTextClr(fObj.markNote)
			-- step2
			setTextClr(fObj.more)
			setTextClr(fObj.intro)
			setTextClr(fObj.pageText)
			for _, row in _G.pairs(fObj.extras) do
				setTextClr(row.name)
				setTextClr(row.what)
				-- TODO: skin Checkbox texture
			end
			for _, page in _G.pairs(fObj.subPages) do
				skinSectionHead(page)
			end
			skinSubFrame(fObj)
			if self.modBtns then
				self:skinStdButton{obj=fObj.back2}
				self:skinStdButton{obj=fObj.done}
				self:skinStdButton{obj=fObj.next}
				self:skinStdButton{obj=fObj.markNext}
			end
		end)

		self:Unhook(_G.FieldGuideFrame, "OnShow")
	end)
	self:checkShown(_G.FieldGuideFrame)

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0})
		end)
	end}, "FieldGuidePadCapture")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.done}
			end
		end)
	end}, "FieldGuideTargetPanel")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			setTextClr(fObj.head, true)
			setTextClr(fObj.name, true)
			setTextClr(fObj.sub, true)
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.done}
			end
		end)
	end}, "FieldGuideToast")

	self:add2Table(self.createFrames, {func = function(fObj)
		_G.RunNextFrame(function()
			setTextClr(fObj.title, true)
			setTextClr(fObj.hint)
			self:skinObject("slider", {obj=_G.FieldGuideExportScroll.ScrollBar})
			self:skinObject("editbox", {obj=fObj.link})
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=-2})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(fObj, 1)}
			end
		end)
	end}, "FieldGuideExport")

	self.RegisterCallback("HuntersFieldGuide", "SettingsPanel_DisplayCategory", function(_, panel)
		if panel.name ~= "Hunter's Field Guide"
		or self.spSkinnedPanels[panel]
		then
			return
		end
		self.spSkinnedPanels[panel] = true
		for _, child in _G.ipairs_reverse{panel:GetChildren()} do
			if child:IsObjectType("CheckButton")
			and self.modChkBtns
			then
				self:skinCheckButton{obj=child}
			elseif child:IsObjectType("EditBox") then
				self:skinObject("editbox", {obj=child})
			elseif child:IsObjectType("Button")
			and not child.iconName
			and self.modBtns
			then
				self:skinStdButton{obj=child, sechk=true}
			end
		end
		self.UnregisterCallback("HuntersFieldGuide", "SettingsPanel_DisplayCategory")
	end)

end
