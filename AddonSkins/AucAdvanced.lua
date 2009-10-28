
function Skinner:AucAdvanced()
	if not self.db.profile.AuctionUI then return end

	-- progress bars
	self:SecureHook(AucAdvanced.Scan , "ProgressBars", function(sbObj, value, show, text)
		if not self.sbGlazed[sbObj] then
			sbObj:SetBackdrop(nil)
			self:glazeStatusBar(sbObj, 0)
		end
	end)

	-- Simple Auction (tab labelled Post)
	local sAuc = AucAdvanced.Modules.Util.SimpleAuction
	if sAuc then
		self:SecureHook(sAuc.Private, "CreateFrames", function()
			local frame = sAuc.Private.frame
			self:skinMoneyFrame{obj=frame.minprice, noWidth=true, moveSEB=true, moveGEB=true}
			self:skinMoneyFrame{obj=frame.buyout, noWidth=true, moveSEB=true, moveGEB=true}
			self:skinEditBox{obj=frame.stacks.num, regs={9}}
			self:skinEditBox{obj=frame.stacks.size, regs={9}}
			self:skinButton{obj=frame.create}
			self:skinButton{obj=frame.clear}
			self:skinButton{obj=frame.config}
			self:skinButton{obj=frame.scanbutton} -- on Browse Frame
			self:skinButton{obj=frame.refresh}
			self:skinButton{obj=frame.bid}
			self:skinButton{obj=frame.buy}
			self:Unhook(sAuc.Private, "CreateFrames")
		end)
	end

	-- SearchUI
	local sUI = AucAdvanced.Modules.Util.SearchUI
	if sUI then
		self:SecureHook(sUI, "CreateAuctionFrames", function()
			self:addSkinFrame{obj=AucAdvSearchUiAuctionFrame.backing}
			AucAdvSearchUiAuctionFrame.money:SetAlpha(0)
			self:Unhook(sUI, "CreateAuctionFrames")
		end)
		self:SecureHook(sUI, "MakeGuiConfig", function()
			local gui = sUI.Private.gui
			gui.frame.progressbar:SetBackdrop(nil)
			self:glazeStatusBar(gui.frame.progressbar, 0)
			self:skinEditBox{obj=gui.saves.name, regs={9}}
			self:skinMoneyFrame{obj=gui.frame.bidbox, noWidth=true, moveSEB=true}
			self:skinButton{obj=gui.saves.load}
			self:skinButton{obj=gui.saves.save}
			self:skinButton{obj=gui.saves.delete}
			self:skinButton{obj=gui.saves.reset}
			self:skinButton{obj=gui.Search}
			self:skinButton{obj=gui.frame.purchase}
			self:skinButton{obj=gui.frame.notnow}
			self:skinButton{obj=gui.frame.ignore}
			self:skinButton{obj=gui.frame.ignoreperm}
			self:skinButton{obj=gui.frame.snatch}
			self:skinButton{obj=gui.frame.clear}
			self:skinButton{obj=gui.frame.cancel, x1=-2, y1=1, x2=2}
			self:skinButton{obj=gui.frame.buyout}
			self:skinButton{obj=gui.frame.bid}
			self:skinButton{obj=gui.frame.progressbar.cancel}
			-- scan the gui tabs for known objects
			for i = 1, #gui.tabs do
				local frame = gui.tabs[i].content
				if frame.money and frame.money.isMoneyFrame then
					Skinner:skinMoneyFrame{obj=frame.money, noWidth=true, moveSEB=true}
				end
			end
			self:Unhook(sUI, "MakeGuiConfig")
		end)
		-- control button for the RealTimeSearch
		local lib = sUI.Searchers["RealTime"]
		self:SecureHook(lib, "HookAH", function()
			local frame = self:getChild(AuctionFrameBrowse, AuctionFrameBrowse:GetNumChildren()) -- get last child
			self:skinButton{obj=frame.control, x1=-2, y1=1, x2=2}
			self:Unhook(lib, "HookAH")
		end)
		-- controls for the SnatchSearcher
		local lib = sUI.Searchers["Snatch"]
		self:SecureHook(lib, "MakeGuiConfig", function(this, gui)
			self:skinEditBox{obj=lib.Private.frame.pctBox, regs={9}}
			self:skinButton{obj=lib.Private.frame.additem, as=true} -- just skin it otherwise text is hidden
			self:skinButton{obj=lib.Private.frame.removeitem, as=true} -- just skin it otherwise text is hidden
			self:skinButton{obj=lib.Private.frame.resetList, as=true} -- just skin it otherwise text is hidden
			self:Unhook(lib, "MakeGuiConfig")
		end)
		-- remove button for the ItemPriceFilter
		local lib = sUI.Filters["ItemPrice"]
		self:SecureHook(lib, "MakeGuiConfig", function(this, gui)
			local exists, id = gui:GetTabByName(lib.tabname, "Filters")
			if exists then
				local btn = self:getChild(gui.tabs[id][3], gui.tabs[id][3]:GetNumChildren()) -- last child
				self:skinButton{obj=btn, as=true} -- just skin it otherwise text is hidden}
			end
			self:Unhook(lib, "MakeGuiConfig")
		end)
	end

	-- Appraiser
	local apr = AucAdvanced.Modules.Util.Appraiser
	if apr then
		self:SecureHook(apr.Private, "CreateFrames", function()
			local frame = apr.Private.frame
			self:skinButton{obj=frame.toggleManifest}
			self:skinButton{obj=frame.config}
			self:addSkinFrame{obj=frame.itembox}
			self:skinSlider(frame.scroller)
			self:skinButton{obj=frame.switchToStack}
			self:skinButton{obj=frame.switchToStack2}
			self:addSkinFrame{obj=frame.salebox}
			self:skinEditBox{obj=frame.salebox.numberentry, regs={9}}
			self:skinEditBox{obj=frame.salebox.stackentry, regs={9}}
			self:skinDropDown{obj=frame.salebox.model}
			self:skinMoneyFrame{obj=frame.salebox.bid, noWidth=true, moveSEB=true, moveGEB=true}
			self:skinMoneyFrame{obj=frame.salebox.buy, noWidth=true, moveSEB=true, moveGEB=true}
			self:skinButton{obj=frame.manifest.close, cb=true}
			self:addSkinFrame{obj=frame.manifest, bg=true, y1=-2, x2=-2} -- a.k.a. Sidebar, put behind AH frame
			self:skinButton{obj=frame.imageview.purchase.buy}
			self:skinButton{obj=frame.imageview.purchase.bid}
			frame.imageview.purchase:SetBackdrop(nil)
			frame.imageview.purchase:SetBackdropColor(0, 0, 0, 0)
			self:skinButton{obj=frame.go}
			self:skinButton{obj=frame.gobatch}
			self:skinButton{obj=frame.refresh}
			self:skinButton{obj=frame.cancel, x1=-2, y1=1, x2=2}
			self:Unhook(apr.Private,"CreateFrames")
		end)
	end

	-- ScanButtons
	local sBtn = AucAdvanced.Modules.Util.ScanButton
	if sBtn then
		self:SecureHook(sBtn.Private, "HookAH", function(this)
			local obj = sBtn.Private
			self:skinButton{obj=obj.buttons.stop, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.buttons.play, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.buttons.pause, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.buttons.getall, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.message.Done}
			self:addSkinFrame{obj=obj.message, kfs=true}
			self:Unhook(sBtn.Private, "HookAH")
		end)
	end

	--	AutoSell
	if autosellframe then
		self:skinButton{obj=autosellframe.closeButton}
		self:skinButton{obj=autosellframe.additem}
		self:skinButton{obj=autosellframe.removeitem}
		self:skinUsingBD{obj=autosellframe.resultlist.sheet.panel.hScroll}
		self:skinUsingBD{obj=autosellframe.resultlist.sheet.panel.vScroll}
		self:applySkin{obj=autosellframe.resultlist}
		self:skinUsingBD{obj=autosellframe.baglist.sheet.panel.hScroll}
		self:skinUsingBD{obj=autosellframe.baglist.sheet.panel.vScroll}
		self:applySkin{obj=autosellframe.baglist}
		self:skinButton{obj=autosellframe.bagList}
		self:addSkinFrame{obj=autosellframe, kfs=true}
		self:getRegion(autosellframe, 2):SetAlpha(1) -- make slot texture visible
	end

	--	configure button on AH frame
	local cUI = AucAdvanced.Modules.Util.CompactUI
	if cUI then
		self:skinButton{obj=cUI.Private.switchUI, y1=2, y2=-3}
	end
--	CompactUI module ?


--	Settings frames(s) ??

	-- Buy prompt
	if AucAdvanced.Buy then
		self:skinEditBox{obj=AucAdvanced.Buy.Private.Prompt.Reason, regs={9}}
		self:skinButton{obj=AucAdvanced.Buy.Private.Prompt.Yes}
		self:skinButton{obj=AucAdvanced.Buy.Private.Prompt.No}
		self:addSkinFrame{obj=AucAdvanced.Buy.Private.Prompt.Frame}
	end

end
