local aName, aObj = ...
if not aObj:isAddonEnabled("Auc-Advanced") then return end
local _G = _G

aObj.addonsToSkin["Auc-Advanced"] = function(self) -- v 7.5.5724
	if not self.db.profile.AuctionUI then return end

	-- progress bars
	local lib = --[[ver == 1 and _G.AucAdvanced.Scan or--]] _G.AucAdvanced.API
	self:SecureHook(lib , "ProgressBars", function(sbObj, ...)
		self.RegisterCallback("AucAdvanced", "UIParent_GetChildren", function(this, child)
			if child:IsObjectType("StatusBar")
			and child:GetName() == nil
			and _G.Round(child:GetWidth()) == 300
			and _G.Round(child:GetHeight()) == 18
			and not self.sbGlazed[child]
			then
      			child:SetBackdrop(nil)
       			self:skinStatusBar{obj=child, fi=0}
			end
		end)
		self:scanUIParentsChildren()
	end)

	-- Simple Auction (tab labelled Post)
	local mod = _G.AucAdvanced.Modules.Util.SimpleAuction
	if mod then
		self:SecureHook(mod.Private, "CreateFrames", function()
			local frame = mod.Private.frame
			frame.slot:SetTexture(self.esTex)
			self:skinMoneyFrame{obj=frame.minprice, noWidth=true, moveSEB=true}
			self:skinMoneyFrame{obj=frame.buyout, noWidth=true, moveSEB=true}
			self:skinEditBox{obj=frame.stacks.num, regs={6}}
			self:moveObject{obj=frame.stacks.mult, y=5}
			self:skinEditBox{obj=frame.stacks.size, regs={6}}
			self:moveObject{obj=frame.stacks.equals, y=5}
			self:skinStdButton{obj=frame.create}
			self:skinStdButton{obj=frame.clear}
			self:skinStdButton{obj=frame.config}
			self:skinStdButton{obj=frame.scanbutton} -- on Browse Frame
			self:skinStdButton{obj=frame.refresh}
			self:skinStdButton{obj=frame.bid}
			self:skinStdButton{obj=frame.buy}
			if self.modChkBtns then
				for _, child in pairs{frame.duration:GetChildren()} do
					self:skinCheckButton{obj=child}
				end
				self:skinCheckButton{obj=frame.options.matchmy}
				self:skinCheckButton{obj=frame.options.undercut}
				self:skinCheckButton{obj=frame.options.remember}
			end
			self:Unhook(mod.Private, "CreateFrames")
		end)
	end

	-- skin the buttons for the Basic Filter
	local mod = _G.AucAdvanced.Modules.Filter.Basic
	if mod then
		self:SecureHook(mod.Processors, "config", function(callbackType, gui)
			local lf = mod.Private.ListButtons[1]:GetParent()
			self:skinStdButton{obj=self:getPenultimateChild(lf)}
			self:skinStdButton{obj=self:getChild(lf, lf:GetNumChildren() - 2)}
			self:Unhook(this, "config")
		end)
		self:addSkinFrame{obj=mod.Private.IgnorePrompt, ft="a",nb=true}
		self:skinStdButton{obj=mod.Private.IgnorePrompt.yes}
		self:skinStdButton{obj=mod.Private.IgnorePrompt.no}
	end

	-- SearchUI
	local mod = _G.AucAdvanced.Modules.Util.SearchUI
	if mod then
		self:SecureHook(mod.Processors, "auctionui", function()
			local gui = mod.Private.gui
			gui.frame.progressbar:SetBackdrop(nil)
			self:skinStatusBar{obj=gui.frame.progressbar, fi=0}
			self:skinEditBox{obj=gui.saves.name, regs={6}}
			self:skinMoneyFrame{obj=gui.frame.bidbox, noWidth=true, moveSEB=true}
			self:skinStdButton{obj=gui.saves.load}
			self:skinStdButton{obj=gui.saves.save}
			self:skinStdButton{obj=gui.saves.delete}
			self:skinStdButton{obj=gui.saves.reset}
			self:skinStdButton{obj=gui.Search}
			self:skinStdButton{obj=gui.frame.purchase}
			self:skinStdButton{obj=gui.frame.notnow}
			self:skinStdButton{obj=gui.frame.ignore}
			self:skinStdButton{obj=gui.frame.ignoreperm}
			self:skinStdButton{obj=gui.frame.snatch}
			self:skinStdButton{obj=gui.frame.clear}
			self:skinStdButton{obj=gui.frame.cancel, x1=-2, y1=1, x2=2}
			self:skinStdButton{obj=gui.frame.buyout}
			self:skinStdButton{obj=gui.frame.bid}
			self:skinStdButton{obj=gui.frame.progressbar.cancel}
			gui.AuctionFrame.money:SetTexture(nil)
			self:addSkinFrame{obj=gui.AuctionFrame.backing, ft="a", nb=true}
			self:Unhook(mod.Processors, "auctionui")
		end)
		-- control button for the RealTimeSearch
		local lib = mod.Searchers["RealTime"]
		if lib then
			self:RawHook(lib, "CreateRTSButton", function(...)
				local btn = self.hooks[lib].CreateRTSButton(...)
				-- self:Debug("CreateRTSButton: [%s, %s]", lib, btn.hasRight)
				self:skinStdButton{obj=btn, y1=1}
				if not btn.hasRight then
					self:Unhook(lib, "CreateRTSButton") -- both are now skinnned
				end
				return btn
			end, true)
		end
		-- controls for the SnatchSearcher
		local lib = mod.Searchers["Snatch"]
		if lib then
			local function skinSnatch()

				lib.Private.frame.slot:SetTexture(aObj.esTex)
				aObj:skinEditBox{obj=lib.Private.frame.pctBox, regs={6}}
				aObj:skinStdButton{obj=lib.Private.frame.additem, as=true} -- just skin it otherwise text is hidden
				aObj:skinStdButton{obj=lib.Private.frame.removeitem, as=true} -- just skin it otherwise text is hidden
				aObj:skinStdButton{obj=lib.Private.frame.resetList, as=true} -- just skin it otherwise text is hidden

			end
			if lib.MakeGuiConfig then
				self:SecureHook(lib, "MakeGuiConfig", function(this, gui)
					skinSnatch()
					self:Unhook(lib, "MakeGuiConfig")
				end)
 			elseif lib.Private.frame then
				skinSnatch()
			end
		end
		-- skin the remove button for the ItemPriceFilter
		local lib = mod.Filters["ItemPrice"]
		if lib then
			self:SecureHook(lib, "MakeGuiConfig", function(this, gui)
				local exists, id = gui:GetTabByName(lib.tabname, "Filters")
				if exists then
					self:skinStdButton{obj=self:getLastChild(gui.tabs[id][3]), as=true} -- just skin it otherwise text is hidden}
				end
				self:Unhook(lib, "MakeGuiConfig")
			end)
		end
	end

	-- Appraiser
	local mod = _G.AucAdvanced.Modules.Util.Appraiser
	if mod then
		local function skinFrame()

			local frame = _G.AucAdvAppraiserFrame
			aObj:skinStdButton{obj=frame.toggleManifest}
			aObj:skinStdButton{obj=frame.config}
			aObj:moveObject{obj=frame.itembox.showAuctions, x=-10}
			aObj:addSkinFrame{obj=frame.itembox, ft="a", nb=true}
			aObj:skinSlider(frame.scroller)
			aObj:skinStdButton{obj=frame.switchToStack, y1=1}
			aObj:skinStdButton{obj=frame.switchToStack2, y1=1}
			aObj:addSkinFrame{obj=frame.salebox, ft="a", nb=true}
			frame.salebox.slot:SetTexture(aObj.esTex)
			aObj:skinEditBox{obj=frame.salebox.stackentry, regs={6}, noWidth=true}
			aObj:adjWidth{obj=frame.salebox.stackentry, adj=14}
			aObj:skinEditBox{obj=frame.salebox.numberentry, regs={6}, noWidth=true}
			aObj:adjWidth{obj=frame.salebox.numberentry, adj=14}
			aObj:skinDropDown{obj=frame.salebox.model}
			aObj:skinMoneyFrame{obj=frame.salebox.bid, noWidth=true, moveSEB=true, moveGEB=true}
			aObj:skinMoneyFrame{obj=frame.salebox.buy, noWidth=true, moveSEB=true, moveGEB=true}
			aObj:skinMoneyFrame{obj=frame.salebox.bid.stack, noWidth=true, moveSEB=true, moveGEB=true}
			aObj:skinMoneyFrame{obj=frame.salebox.buy.stack, noWidth=true, moveSEB=true, moveGEB=true}
			aObj:skinCloseButton{obj=frame.manifest.close, x1=3, y1=-3, x2=-3, y2=3}
			aObj:addSkinFrame{obj=frame.manifest, ft="a", nb=true, bg=true} -- a.k.a. Sidebar, put behind AH frame
			aObj:skinStdButton{obj=frame.imageview.purchase.buy, x1=-1}
			aObj:skinStdButton{obj=frame.imageview.purchase.bid, x1=-1}
			frame.imageview.purchase:SetBackdrop(nil)
			frame.imageview.purchase:SetBackdropColor(0, 0, 0, 0)
			aObj:skinStdButton{obj=frame.go}
			aObj:skinStdButton{obj=frame.gobatch}
			aObj:skinStdButton{obj=frame.refresh}
			aObj:skinStdButton{obj=frame.cancel, x1=-2, y1=1, x2=2}

		end
		if not _G.AucAdvAppraiserFrame then
			self:SecureHook(mod.Processors, "auctionui", function()
				skinFrame()
				self:Unhook(mod.Processors,"auctionui")
			end)
		else
			skinFrame()
		end
	end

	-- ScanButtons
	local mod = _G.AucAdvanced.Modules.Util.ScanButton
	if mod then
		self:SecureHook(mod.Private, "HookAH", function(this)
			local obj = mod.Private
			self:skinStdButton{obj=obj.buttons.stop, x1=-2, y1=1, x2=2}
			self:skinStdButton{obj=obj.buttons.play, x1=-2, y1=1, x2=2}
			self:skinStdButton{obj=obj.buttons.pause, x1=-2, y1=1, x2=2}
			self:skinStdButton{obj=obj.buttons.getall, x1=-2, y1=1, x2=2}
			self:skinStdButton{obj=obj.message.Done}
			self:addSkinFrame{obj=obj.message, ft="a", kfs=true, nb=true}
			self:Unhook(mod.Private, "HookAH")
		end)
	end

	--	AutoSell
	if _G.autosellframe then
		self:skinStdButton{obj=_G.autosellframe.closeButton}
		self:skinStdButton{obj=_G.autosellframe.additem}
		self:skinStdButton{obj=_G.autosellframe.removeitem}
		self:skinUsingBD{obj=_G.autosellframe.resultlist.sheet.panel.hScroll}
		self:skinUsingBD{obj=_G.autosellframe.resultlist.sheet.panel.vScroll}
		self:applySkin{obj=_G.autosellframe.resultlist}
		self:skinUsingBD{obj=_G.autosellframe.baglist.sheet.panel.hScroll}
		self:skinUsingBD{obj=_G.autosellframe.baglist.sheet.panel.vScroll}
		self:applySkin{obj=_G.autosellframe.baglist}
		self:skinStdButton{obj=_G.autosellframe.bagList}
		self:addSkinFrame{obj=_G.autosellframe, ft="a", kfs=true, nb=trueStd}
		self:getRegion(_G.autosellframe, 2):SetAlpha(1) -- make slot texture visible
	end

    -- Glypher
    local mod = _G.AucAdvanced.Modules.Util.Glypher
    if mod then
        self:SecureHook(mod.Private, "SetupConfigGui", function(this, gui)
            local frame = mod.Private.frame
            self:skinStdButton{obj=frame.refreshButton, as=true} -- just skin it otherwise text is hidden
            self:skinStdButton{obj=frame.searchButton, as=true} -- just skin it otherwise text is hidden
            self:skinStdButton{obj=frame.skilletButton, as=true} -- just skin it otherwise text is hidden
            self:Unhook(mod.Private, "SetupConfigGui")
        end)
    end

    -- GlypherPost
    local mod = _G.AucAdvanced.Modules.Util.GlypherPost
    if mod then
        self:SecureHook(mod.Private, "SetupConfigGui", function(this, gui)
            local frame = mod.Private.frame
            self:skinStdButton{obj=frame.refreshButton, as=true} -- just skin it otherwise text is hidden
            self:Unhook(mod.Private, "SetupConfigGui")
        end)
    end

	--	CompactUI module
	--	configure button on AH frame
	local mod = _G.AucAdvanced.Modules.Util.CompactUI
	if mod then
		self:skinStdButton{obj=mod.Private.switchUI, y1=2, y2=-3}
	end

--	Settings frames(s) ??

	-- Buy prompt
	if _G.AucAdvanced.Buy then
		self:skinEditBox{obj=_G.AucAdvanced.Buy.Private.Prompt.Reason, regs={6}}
		self:skinStdButton{obj=_G.AucAdvanced.Buy.Private.Prompt.Yes}
		self:skinStdButton{obj=_G.AucAdvanced.Buy.Private.Prompt.No}
		self:addSkinFrame{obj=_G.AucAdvanced.Buy.Private.Prompt.Frame, ft="a", nb=true}
	end

	-- Post prompt
	if _G.AucAdvanced.Post then
		self:skinStdButton{obj=_G.AucAdvanced.Post.Private.Prompt.Yes}
		self:skinStdButton{obj=_G.AucAdvanced.Post.Private.Prompt.No}
		self:addSkinFrame{obj=_G.AucAdvanced.Post.Private.Prompt.Frame, ft="a", nb=true}
	end

end
