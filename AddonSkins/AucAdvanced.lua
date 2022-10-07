local _, aObj = ...
if not aObj:isAddonEnabled("Auc-Advanced") then return end
local _G = _G

-- ONLY supported in Classic
if not aObj.isClsc then return end

aObj.addonsToSkin["Auc-Advanced"] = function(self) -- v 1.13.6718
	if not self.db.profile.AuctionUI then return end

	-- progress bars
	local api = _G.AucAdvanced.API
	self:SecureHook(api , "ProgressBars", function(_, _)
		self.RegisterCallback("AucAdvanced", "UIParent_GetChildren", function(_, child, _)
			if child:IsObjectType("StatusBar")
			and child:GetName() == nil
			and _G.Round(child:GetWidth()) == 300
			and _G.Round(child:GetHeight()) == 18
			and not self.sbGlazed[child]
			then
				child:SetBackdrop(nil)
				self:skinObject("statusbar", {obj=child})
			end
		end)
		self:scanUIParentsChildren()
	end)

	-- Appraiser
	local apr = _G.AucAdvanced.Modules.Util.Appraiser
	if apr then
		local function skinFrame()
			local frame = _G.AucAdvAppraiserFrame
			aObj:moveObject{obj=frame.itembox.showAuctions, x=-10}
			aObj:skinObject("frame", {obj=frame.itembox, fb=true, ofs=0})
			aObj:skinObject("slider", {obj=frame.scroller})
			aObj:skinObject("frame", {obj=frame.salebox, fb=true, ofs=0})
			frame.salebox.slot:SetTexture(aObj.tFDIDs.esTex)
			aObj:skinObject("slider", {obj=frame.salebox.stack})
			aObj:skinObject("editbox", {obj=frame.salebox.stackentry})
			aObj:adjWidth{obj=frame.salebox.stackentry, adj=14}
			aObj:skinObject("slider", {obj=frame.salebox.number})
			aObj:skinObject("editbox", {obj=frame.salebox.numberentry})
			aObj:adjWidth{obj=frame.salebox.numberentry, adj=14}
			aObj:skinObject("slider", {obj=frame.salebox.duration})
			aObj:skinObject("dropdown", {obj=frame.salebox.model})
			aObj:skinMoneyFrame{obj=frame.salebox.bid, moveSEB=true, moveGEB=true}
			aObj:skinMoneyFrame{obj=frame.salebox.buy, moveSEB=true, moveGEB=true}
			aObj:skinMoneyFrame{obj=frame.salebox.bid.stack}
			aObj:skinMoneyFrame{obj=frame.salebox.buy.stack}
			frame.switchToStack:SetHeight(20)
			frame.switchToStack2:SetHeight(20)
			aObj:skinObject("frame", {obj=frame.manifest, ofs=0, x1=19}) -- a.k.a. Sidebar
			frame.imageview.purchase:SetBackdrop(nil)
			frame.imageview.purchase:SetBackdropColor(0, 0, 0, 0)
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.toggleManifest}
				aObj:skinStdButton{obj=frame.config}
				aObj:skinStdButton{obj=frame.switchToStack}
				aObj:skinStdButton{obj=frame.switchToStack2}
				aObj:skinCloseButton{obj=frame.manifest.close, x1=3, y1=-3, x2=-3, y2=3}
				aObj:skinStdButton{obj=frame.imageview.purchase.buy}
				aObj:skinStdButton{obj=frame.imageview.purchase.bid}
				aObj:skinStdButton{obj=frame.go}
				aObj:skinStdButton{obj=frame.gobatch}
				aObj:skinStdButton{obj=frame.refresh}
				aObj:skinStdButton{obj=frame.cancel, x1=-2, y1=1, x2=2}
				aObj:SecureHook(frame, "UpdateDisplay", function()
					aObj:clrBtnBdr(_G.AucAdvAppraiserFrame.toggleManifest)
					aObj:clrBtnBdr(_G.AucAdvAppraiserFrame.go)
				end)
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.itembox.showAuctions}
				aObj:skinCheckButton{obj=frame.itembox.showHidden}
				aObj:skinCheckButton{obj=frame.salebox.numberonly}
				aObj:skinCheckButton{obj=frame.salebox.matcher}
				aObj:skinCheckButton{obj=frame.salebox.ignore}
				aObj:skinCheckButton{obj=frame.salebox.bulk}
			end
		end
		if not _G.AucAdvAppraiserFrame then
			self:SecureHook(apr.Processors, "auctionui", function()
				skinFrame()

				self:Unhook(apr.Processors,"auctionui")
			end)
		else
			skinFrame()
		end
	end

	-- SearchUI
	local sUI = _G.AucAdvanced.Modules.Util.SearchUI
	if sUI then
		self:SecureHook(sUI.Private, "CreateAuctionFrames", function()
			local gui = sUI.Private.gui
			gui.AuctionFrame.money:SetTexture(nil)
			self:skinObject("frame", {obj=gui.AuctionFrame.backing, fb=true, ofs=0})

			self:Unhook(sUI.Private, "CreateAuctionFrames")
		end)
		self:SecureHook(sUI.Private, "MakeGuiConfig", function()
			local gui = sUI.Private.gui
			gui.frame.progressbar:SetBackdrop(nil)
			self:skinObject("statusbar", {obj=gui.frame.progressbar})
			self:skinObject("editbox", {obj=gui.saves.name})
			self:skinMoneyFrame{obj=gui.frame.bidbox, noWidth=true, moveSEB=true}
			if self.modBtns then
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
				self:skinStdButton{obj=gui.frame.cancel}--, x1=-2, y1=1, x2=2}
				self:skinStdButton{obj=gui.frame.buyout}
				self:skinStdButton{obj=gui.frame.bid}
				self:skinStdButton{obj=gui.frame.progressbar.cancel}
				self:SecureHook(gui.Search, "updateDisplay", function()
					self:clrBtnBdr(_G.AucSearchUISearchButton)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=gui.saves.select.button, ofs=0}
			end

			self:Unhook(sUI.Private, "MakeGuiConfig")
		end)
		if self.modBtns then
			-- control button for the RealTimeSearch
			local rt = sUI.Searchers["RealTime"]
			if rt then
				self:RawHook(rt, "CreateRTSButton", function(...)
					local btn = self.hooks[rt].CreateRTSButton(...)
					-- self:Debug("CreateRTSButton: [%s, %s]", lib, btn.hasRight)
					self:skinStdButton{obj=btn, y1=1}
					if not btn.hasRight then
						self:Unhook(rt, "CreateRTSButton") -- both are now skinnned
					end
					return btn
				end, true)
			end
		end
		-- controls for the SnatchSearcher
		local ls = sUI.Searchers["Snatch"]
		if ls then
			local function skinSnatch()
				ls.Private.frame.slot:SetTexture(aObj.tFDIDs.esTex)
				aObj:skinObject("editbox", {obj=ls.Private.frame.pctBox, y1=-4, y2=4})
				aObj:skinMoneyFrame{obj=ls.Private.frame.money, noWidth=true, moveSEB=true}
				if aObj.modBtns then
					aObj:skinStdButton{obj=ls.Private.frame.additem}
					aObj:skinStdButton{obj=ls.Private.frame.removeitem}
					aObj:skinStdButton{obj=ls.Private.frame.resetList}
				end
			end
			if ls.MakeGuiConfig then
				self:SecureHook(ls, "MakeGuiConfig", function(_, _)
					skinSnatch()

					self:Unhook(ls, "MakeGuiConfig")
				end)
			elseif ls.Private.frame then
				skinSnatch()
			end
		end
		if self.modBtns then
			-- skin the remove button for the ItemPriceFilter
			local ip = sUI.Filters["ItemPrice"]
			if ip then
				self:SecureHook(ip, "MakeGuiConfig", function(_, gui)
					local exists, id = gui:GetTabByName(ip.tabname, "Filters")
					if exists then
						self:skinStdButton{obj=self:getPenultimateChild(gui.tabs[id][3])}
						self:skinStdButton{obj=self:getLastChild(gui.tabs[id][3])}
						self:SecureHook(self:getPenultimateChild(gui.tabs[id][3]), "Disable", function(bObj, _)
							self:clrBtnBdr(bObj)
						end)
						self:SecureHook(self:getPenultimateChild(gui.tabs[id][3]), "Enable", function(bObj, _)
							self:clrBtnBdr(bObj)
						end)
					end

					self:Unhook(ip, "MakeGuiConfig")
				end)
			end
		end
	end

	-- Simple Auction (tab labelled Post)
	local sa = _G.AucAdvanced.Modules.Util.SimpleAuction
	if sa then
		self:SecureHook(sa.Private, "CreateFrames", function()
			local frame = sa.Private.frame
			frame.slot:SetTexture(self.tFDIDs.esTex)
			self:skinMoneyFrame{obj=frame.minprice, noWidth=true, moveSEB=true}
			self:skinMoneyFrame{obj=frame.buyout, noWidth=true, moveSEB=true}
			self:skinObject("editbox", {obj=frame.stacks.num})
			self:moveObject{obj=frame.stacks.mult, y=5}
			self:skinObject("editbox", {obj=frame.stacks.size})
			self:moveObject{obj=frame.stacks.equals, y=5}
			if self.modBtns then
				self:skinStdButton{obj=frame.create}
				self:skinStdButton{obj=frame.clear}
				self:skinStdButton{obj=frame.config}
				self:skinStdButton{obj=frame.scanbutton} -- on Browse Frame
				self:skinStdButton{obj=frame.refresh}
				self:skinStdButton{obj=frame.bid}
				self:skinStdButton{obj=frame.buy}
				self:SecureHook(_G.AucAdvanced.Modules.Util.SimpleAuction.Private, "UpdateDisplay", function()
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.SimpleAuction.Private.frame.create)
				end)
				self:SecureHook(_G.AucAdvanced.Modules.Util.SimpleAuction.Private, "onSelect", function()
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.SimpleAuction.Private.frame.bid)
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.SimpleAuction.Private.frame.buy)
				end)
			end
			if self.modChkBtns then
				for _, child in pairs{frame.duration:GetChildren()} do
					self:skinCheckButton{obj=child}
				end
				self:skinCheckButton{obj=frame.options.matchmy}
				self:skinCheckButton{obj=frame.options.undercut}
				self:skinCheckButton{obj=frame.options.remember}
			end

			self:Unhook(sa.Private, "CreateFrames")
		end)
	end

	-- skin the buttons for the Basic Filter
	local bas = _G.AucAdvanced.Modules.Filter.Basic
	if bas then
		self:skinObject("slider", {obj=_G.AucFilterBasicScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=bas.Private.IgnorePrompt, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=bas.Private.IgnorePrompt.yes}
			self:skinStdButton{obj=bas.Private.IgnorePrompt.no}
			self:SecureHook(bas.Processors, "config", function(_, _)
				local lf = bas.Private.ListButtons[1]:GetParent()
				self:skinStdButton{obj=self:getChild(lf, lf:GetNumChildren() - 2)}
				self:skinStdButton{obj=self:getPenultimateChild(lf)}

				self:Unhook(bas.Processors, "config")
			end)
		end
	end

	local sh = _G.AucAdvanced.Modules.Stat.Histogram
	if sh then
		self:SecureHook(sh.Private, "SetupConfigGui", function(_)
			local frame = sh.Private.frame
			frame.slot:SetTexture(self.tFDIDs.esTex)
			self:skinObject("frame", {obj=frame.bargraph, fb=true, ofs=0})

			self:Unhook(sh.Private, "SetupConfigGui")
		end)
	end

	local am = _G.AucAdvanced.Modules.Util.AutoMagic
	if am then
		self:SecureHookScript(am.ammailgui, "OnShow", function(this)
			self:skinObject("frame", {obj=this, cb=true})
			-- TODO:b skin other buttons

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(am.CustomMailerFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=this.resultlist.sheet.panel.hScroll})
			self:skinObject("slider", {obj=this.resultlist.sheet.panel.vScroll})
			self:skinObject("frame", {obj=this.resultlist, ofs=0})
			self:skinObject("editbox", {obj=this.listEditBox})
			self:skinObject("slider", {obj=this.buttonList.sheet.panel.hScroll})
			self:skinObject("slider", {obj=this.buttonList.sheet.panel.vScroll})
			self:skinObject("frame", {obj=this.buttonList, ofs=0})
			self:skinObject("button", {obj=this.slot})
			self:skinObject("frame", {obj=this, ofs=0, x1=-5})
			if self.modBtns then
				self:skinStdButton{obj=this.closeButton}
				self:skinStdButton{obj=this.removeListButton}
				self:skinStdButton{obj=this.addButton}
				self:skinStdButton{obj=this.removeButton}
				self:SecureHook(_G.AucAdvanced.Modules.Util.AutoMagic, "MailListUpdate", function()
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.AutoMagic.CustomMailerFrame.removeListButton)
				end)
				self:SecureHook(this, "slotclear", function(_)
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.AutoMagic.CustomMailerFrame.addButton)
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.AutoMagic.CustomMailerFrame.removeButton)
				end)
				self:SecureHook(this, "slotadd", function(_)
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.AutoMagic.CustomMailerFrame.addButton)
					self:clrBtnBdr(_G.AucAdvanced.Modules.Util.AutoMagic.CustomMailerFrame.removeButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
	end

	-- ScanButtons
	local sb = _G.AucAdvanced.Modules.Util.ScanButton
	if sb then
		self:SecureHook(sb.Private, "HookAH", function()
			self:skinObject("frame", {obj=sb.Private.message, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=sb.Private.buttons.stop, x1=-2, y1=1, x2=2}
				self:skinStdButton{obj=sb.Private.buttons.play, x1=-2, y1=1, x2=2}
				self:skinStdButton{obj=sb.Private.buttons.pause, x1=-2, y1=1, x2=2}
				self:skinStdButton{obj=sb.Private.buttons.getall, x1=-2, y1=1, x2=2}
				self:skinStdButton{obj=sb.Private.message.Done}
			end

			self:Unhook(sb.Private, "HookAH")
		end)
	end

	if self.modBtns then
	    -- Glypher
	    local gl = _G.AucAdvanced.Modules.Util.Glypher
	    if gl then
	        self:SecureHook(gl.Private, "SetupConfigGui", function()
	            self:skinStdButton{obj=gl.Private.frame.refreshButton, as=true} -- just skin it otherwise text is hidden
	            self:skinStdButton{obj=gl.Private.frame.searchButton, as=true} -- just skin it otherwise text is hidden
	            self:skinStdButton{obj=gl.Private.frame.skilletButton, as=true} -- just skin it otherwise text is hidden

				gl = nil
	        end)
	    end
	    -- GlypherPost
	    local gp = _G.AucAdvanced.Modules.Util.GlypherPost
	    if gp then
	        self:SecureHook(gp.Private, "SetupConfigGui", function()
	            self:skinStdButton{obj=gp.Private.frame.refreshButton, as=true} -- just skin it otherwise text is hidden

	            self:Unhook(gp.Private, "SetupConfigGui")
	        end)
	    end
		--	CompactUI module
		--	configure button on AH frame
		local cUI = _G.AucAdvanced.Modules.Util.CompactUI
		if cUI then
			self:skinStdButton{obj=cUI.Private.switchUI, y1=2, y2=-3}
		end
	end

	--	AutoSell
	if _G.autosellframe then
		self:SecureHookScript(_G.autosellframe, "OnShow", function(this)
			self:skinObject("button", {obj=this.slot})
			self:skinObject("slider", {obj=this.resultlist.sheet.panel.hScroll})
			self:skinObject("slider", {obj=this.resultlist.sheet.panel.vScroll})
			self:skinObject("frame", {obj=this.resultlist, ofs=0})
			self:skinObject("slider", {obj=this.baglist.sheet.panel.hScroll})
			self:skinObject("slider", {obj=this.baglist.sheet.panel.vScroll})
			self:skinObject("frame", {obj=this.baglist, ofs=0})
			self:skinObject("frame", {obj=this, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.closeButton}
				self:skinStdButton{obj=this.additem}
				self:skinStdButton{obj=this.removeitem}
				self:skinStdButton{obj=this.bagList}
			end

			self:Unhook(this, "OnShow")
		end)
	end

	-- Buy prompt
	if _G.AucAdvanced.Buy then
		self:skinObject("editbox", {obj=_G.AucAdvanced.Buy.Private.Prompt.Reason})
		self:skinObject("frame", {obj=_G.AucAdvanced.Buy.Private.Prompt.Frame, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G.AucAdvanced.Buy.Private.Prompt.Yes}
			self:skinStdButton{obj=_G.AucAdvanced.Buy.Private.Prompt.No}
		end
	end

	-- Post prompt
	if _G.AucAdvanced.Post then
		self:skinObject("frame", {obj=_G.AucAdvanced.Post.Private.Prompt.Frame, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G.AucAdvanced.Post.Private.Prompt.Yes}
			self:skinStdButton{obj=_G.AucAdvanced.Post.Private.Prompt.No}
		end
	end

end

aObj.addonsToSkin.BeanCounter = function(self) -- v 1.13.6682

	self:SecureHookScript(_G.BeanCounterBaseFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.Done}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Resizer, clr="gold", ofs=-3, x1=1, x2=-2}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BeanCounterUiFrame, "OnShow", function(this)
		this.slot:SetTexture(self.tFDIDs.esTex)
		self:adjHeight{obj=this.selectbox.box, adj=60}
		self:skinObject("dropdown", {obj=this.selectbox.box, y2=-15})
		self:skinObject("editbox", {obj=this.searchBox})
		self:skinObject("editbox", {obj=_G.BeanCounterLower.month, chginset=true, inset=2, x1=-2})
		self:skinObject("editbox", {obj=_G.BeanCounterLower.day, chginset=true, inset=2, x1=-2})
		self:skinObject("editbox", {obj=_G.BeanCounterLower.year})
		self:skinObject("editbox", {obj=_G.BeanCounterUpper.month, chginset=true, inset=2, x1=-2})
		self:skinObject("editbox", {obj=_G.BeanCounterUpper.day, chginset=true, inset=2, x1=-2})
		self:skinObject("editbox", {obj=_G.BeanCounterUpper.year})
		self:skinObject("editbox", {obj=this.reasonEditBox})
		self:skinObject("slider", {obj=this.resultlist.sheet.panel.hScroll})
		self:skinObject("slider", {obj=this.resultlist.sheet.panel.vScroll})
		self:skinObject("frame", {obj=this.resultlist, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.Config}
			self:skinStdButton{obj=this.searchButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.exactCheck}
			self:skinCheckButton{obj=this.neutralCheck}
			self:skinCheckButton{obj=this.bidCheck}
			self:skinCheckButton{obj=this.bidFailedCheck}
			self:skinCheckButton{obj=this.auctionCheck}
			self:skinCheckButton{obj=this.auctionFailedCheck}
			self:skinCheckButton{obj=this.useDateCheck}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BeanCounter.Private.deletePromptFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.yes}
			self:skinStdButton{obj=this.no}
		end

		self:Unhook(this, "OnShow")
	end)

	if _G.BeanCounter.Private.scriptframe.loadError then
		self:skinObject("frame", {obj=_G.BeanCounter.Private.scriptframe.loadError, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G.BeanCounter.Private.scriptframe.loadError.close}
		end
	end

end
