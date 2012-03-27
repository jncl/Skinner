local aName, aObj = ...
if not aObj:isAddonEnabled("GnomeWorks") then return end

function aObj:GnomeWorks() --r161

	local function hideBD(frame)

		for k, v in pairs(frame.backDrop) do
			if type(v) == "table" and k:find("texture") then
				v:SetAlpha(0)
			end
		end

	end
	local function skinBtn(obj)

		if obj:IsObjectType("Button")
		and aObj.modBtns
		then
			for _, state in pairs{"Disabled", "Up", "Down"} do
				obj.state[state]:DisableDrawLayer("BACKGROUND")
			end
			aObj:applySkin{obj=obj, bd=6}
		end

	end
	local gwEvt
	local function skinFrame()

		if GnomeWorks:GetMainFrame() then
			aObj:CancelTimer(gwEvt, true)
			gwEvt = nil
		-->>-- GnomeWorks.MainWindow
			aObj:keepFontStrings(GnomeWorks.MainWindow.title)
			aObj:skinDropDown{obj=GnomeWorksGrouping, x2=133}
			hideBD(GnomeWorks.levelStatusBar.estimatedLevel)
			aObj:glazeStatusBar(GnomeWorks.levelStatusBar, 0, nil)
			hideBD(GnomeWorks.detailFrame.levelsBar.bg)
			hideBD(GnomeWorks.detailFrame.textScroll)
			hideBD(GnomeWorks.detailFrame)
			aObj:addSkinFrame{obj=GnomeWorks.detailFrame, ofs=4}
			aObj:skinEditBox{obj=GnomeWorks.searchBoxFrame}
			for _, child in pairs{GnomeWorks.controlFrame.QueueButtons:GetChildren()} do
				skinBtn(child)
				if child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj=child, noHeight=true, noWidth=true}
				end
			end
			for _, child in pairs{GnomeWorks.controlFrame.OptionButtons:GetChildren()} do
				skinBtn(child)
			end
			skinBtn(GnomeWorks.queryCraftersButton)
			aObj:addSkinFrame{obj=GnomeWorks.MainWindow, kfs=true, y1=3, x2=3}
		-->>-- GnomeWorks.QueueWindow
			-- Dock Tab
			aObj:addSkinButton{obj=GnomeWorks.QueueWindow.dockTab, bg=true, y1=-6, x2=-3, y2=6}
			aObj:getRegion(GnomeWorks.QueueWindow.dockTab, 1):SetTexture(nil)
			-- Buttons
			local cf = aObj:getChild(GnomeWorks.QueueWindow, GnomeWorks.QueueWindow:GetNumChildren())
			for _, child in pairs{cf:GetChildren()} do
				skinBtn(child)
			end
			aObj:addSkinFrame{obj=GnomeWorks.QueueWindow, kfs=true, y1=3, x2=3}
		-->>-- Scroll Frame(s)
			for _, sf in pairs(GnomeWorks.scrollFrameList) do
				for _, sc in pairs(sf.columnFrames) do
					hideBD(sc)
				end
				aObj:addSkinFrame{obj=sf:GetParent(), ofs=4, y1=3} -- skin scroll frame
			end
		end

	end

	if not GnomeWorks.MainWindow then
		gwEvt = self:ScheduleRepeatingTimer(skinFrame, 0.2)
	else
		skinFrame()
	end

-->-- AuctionHouse features
	self:SecureHook(GnomeWorks, "CreateAuctionWindow", function(this)
		local tab = _G["AuctionFrameTab"..AuctionFrame.numTabs]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if self.isTT then self:setInactiveTab(tabSF) end
		self:addButtonBorder{obj=GWAuctionItemIcon, abt=true}
		for k, child in pairs{GWAuctionItemIcon:GetParent():GetParent():GetChildren()} do
			if k == 1 -- buyFrame
			or k == 2 then -- reagentFrame
				for _, sc in pairs(child.sf.columnFrames) do
					hideBD(sc)
				end
				self:addSkinFrame{obj=child.sf:GetParent(), ofs=4, y1=3} -- skin scroll frame
			elseif k == 3 then -- scanButton
				skinBtn(child)
			end
		end
		self:Unhook(GnomeWorks, "CreateAuctionWindow")
	end)

end
