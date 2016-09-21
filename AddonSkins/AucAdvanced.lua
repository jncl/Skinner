local aName, aObj = ...
if not aObj:isAddonEnabled("Auc-Advanced") then return end
local _G = _G

function aObj:AucAdvanced() -- 7.1.5675
	if not self.db.profile.AuctionUI then return end

	-- check version, if not a specified release or beta then default the version to 9
	local vTab = {
		["5.8"] = 1,
		["5.9"] = 2,
		["5.10"] = 3,
		["5.11"] = 4,
		["5.15"] = 5,
		["7.1"] = 5,
	}
	local aVer = _G.GetAddOnMetadata("Auc-Advanced", "Version")
	local ver = vTab[aVer:match("(%d.%d+).%d+")] or 9

	-- progress bars
	local lib = ver == 1 and _G.AucAdvanced.Scan or _G.AucAdvanced.API
	self:SecureHook(lib , "ProgressBars", function(sbObj, ...)
		if ver >= 4 then
			self.RegisterCallback("AucAdvanced", "UIParent_GetChildren", function(this, child)
				if child:IsObjectType("StatusBar")
				and child:GetName() == nil
				and self:getInt(child:GetWidth()) == 300
				and self:getInt(child:GetHeight()) == 18
				and not self.sbGlazed[child]
				then
	      			child:SetBackdrop(nil)
	       			self:glazeStatusBar(child, 0)
				end
			end)
			self:scanUIParentsChildren()
	    elseif ver > 1
		and ver < 4
		then
			local i = 1
			while lib["GenericProgressBar"..i] do
	           local gpb = lib["GenericProgressBar"..i]
           		if gpb and not self.sbGlazed[gpb] then
           			gpb:SetBackdrop(nil)
           			self:glazeStatusBar(gpb, 0)
           		end
				i = i + 1
			end
	    elseif ver == 1 then
	        for i = 1, #lib.availableBars do
	           local gpb = lib["GenericProgressBar"..i]
           		if gpb and not self.sbGlazed[gpb] then
           			gpb:SetBackdrop(nil)
           			self:glazeStatusBar(gpb, 0)
           		end
	        end
    	end
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
			self:skinEditBox{obj=frame.stacks.size, regs={6}}
			self:skinButton{obj=frame.create}
			self:skinButton{obj=frame.clear}
			self:skinButton{obj=frame.config}
			self:skinButton{obj=frame.scanbutton} -- on Browse Frame
			self:skinButton{obj=frame.refresh}
			self:skinButton{obj=frame.bid}
			self:skinButton{obj=frame.buy}
			self:Unhook(mod.Private, "CreateFrames")
		end)
	end

	-- SearchUI
	local mod = _G.AucAdvanced.Modules.Util.SearchUI
	if mod then
		if ver <= 4 then
			self:SecureHook(mod, "CreateAuctionFrames", function()
				local frame = mod.Private.gui.AuctionFrame
				if frame then
					frame.money:SetAlpha(0)
					self:addSkinFrame{obj=frame.backing}
				end
				self:Unhook(mod, "CreateAuctionFrames")
			end)
		end
		self:SecureHook(mod.Processors, "auctionui", function()
			local gui = mod.Private.gui
			gui.frame.progressbar:SetBackdrop(nil)
			self:glazeStatusBar(gui.frame.progressbar, 0)
			self:skinEditBox{obj=gui.saves.name, regs={6}}
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
			gui.AuctionFrame.money:SetTexture(nil)
			self:addSkinFrame{obj=gui.AuctionFrame.backing}
			self:Unhook(mod.Processors, "auctionui")
		end)
		-- control button for the RealTimeSearch
		local lib = mod.Searchers["RealTime"]
		if lib then
			if ver <= 4 then
				self:SecureHook(lib, "HookAH", function(this)
					local frame = self:getChild(_G.AuctionFrameBrowse, _G.AuctionFrameBrowse:GetNumChildren()) -- get last child
					self:skinButton{obj=frame.control, x1=-2, y1=1, x2=2}
					self:Unhook(lib, "HookAH")
				end)
			else
				self:RawHook(lib, "CreateRTSButton", function(...)
					local btn = self.hooks[lib].CreateRTSButton(...)
					-- self:Debug("CreateRTSButton: [%s, %s]", lib, btn.hasRight)
					self:skinButton{obj=btn, y1=1}
					if not btn.hasRight then
						self:Unhook(lib, "CreateRTSButton") -- both are now skinnned
					end
					return btn
				end, true)
			end
		end
		-- controls for the SnatchSearcher
		local lib = mod.Searchers["Snatch"]
		if lib then
			local function skinSnatch()

				lib.Private.frame.slot:SetTexture(aObj.esTex)
				aObj:skinEditBox{obj=lib.Private.frame.pctBox, regs={6}}
				aObj:skinButton{obj=lib.Private.frame.additem, as=true} -- just skin it otherwise text is hidden
				aObj:skinButton{obj=lib.Private.frame.removeitem, as=true} -- just skin it otherwise text is hidden
				aObj:skinButton{obj=lib.Private.frame.resetList, as=true} -- just skin it otherwise text is hidden

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
					local btn = self:getChild(gui.tabs[id][3], gui.tabs[id][3]:GetNumChildren()) -- last child
					self:skinButton{obj=btn, as=true} -- just skin it otherwise text is hidden}
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
			aObj:skinButton{obj=frame.toggleManifest}
			aObj:skinButton{obj=frame.config}
			aObj:moveObject{obj=frame.itembox.showAuctions, x=-10}
			aObj:addSkinFrame{obj=frame.itembox}
			aObj:skinSlider(frame.scroller)
			aObj:skinButton{obj=frame.switchToStack, y1=1}
			aObj:skinButton{obj=frame.switchToStack2, y1=1}
			aObj:addSkinFrame{obj=frame.salebox}
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
			aObj:skinButton{obj=frame.manifest.close, cb=true, x1=3, y1=-3, x2=-3, y2=3}
			aObj:addSkinFrame{obj=frame.manifest, bg=true} -- a.k.a. Sidebar, put behind AH frame
			aObj:skinButton{obj=frame.imageview.purchase.buy, x1=-1}
			aObj:skinButton{obj=frame.imageview.purchase.bid, x1=-1}
			frame.imageview.purchase:SetBackdrop(nil)
			frame.imageview.purchase:SetBackdropColor(0, 0, 0, 0)
			aObj:skinButton{obj=frame.go}
			aObj:skinButton{obj=frame.gobatch}
			aObj:skinButton{obj=frame.refresh}
			aObj:skinButton{obj=frame.cancel, x1=-2, y1=1, x2=2}

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
			self:skinButton{obj=obj.buttons.stop, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.buttons.play, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.buttons.pause, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.buttons.getall, x1=-2, y1=1, x2=2}
			self:skinButton{obj=obj.message.Done}
			self:addSkinFrame{obj=obj.message, kfs=true}
			self:Unhook(mod.Private, "HookAH")
		end)
	end

	--	AutoSell
	if _G.autosellframe then
		self:skinButton{obj=_G.autosellframe.closeButton}
		self:skinButton{obj=_G.autosellframe.additem}
		self:skinButton{obj=_G.autosellframe.removeitem}
		self:skinUsingBD{obj=_G.autosellframe.resultlist.sheet.panel.hScroll}
		self:skinUsingBD{obj=_G.autosellframe.resultlist.sheet.panel.vScroll}
		self:applySkin{obj=_G.autosellframe.resultlist}
		self:skinUsingBD{obj=_G.autosellframe.baglist.sheet.panel.hScroll}
		self:skinUsingBD{obj=_G.autosellframe.baglist.sheet.panel.vScroll}
		self:applySkin{obj=_G.autosellframe.baglist}
		self:skinButton{obj=_G.autosellframe.bagList}
		self:addSkinFrame{obj=_G.autosellframe, kfs=true}
		self:getRegion(_G.autosellframe, 2):SetAlpha(1) -- make slot texture visible
	end

    -- Glypher
    local mod = _G.AucAdvanced.Modules.Util.Glypher
    if mod then
        self:SecureHook(mod.Private, "SetupConfigGui", function(this, gui)
            local frame = mod.Private.frame
            self:skinButton{obj=frame.refreshButton, as=true} -- just skin it otherwise text is hidden
            self:skinButton{obj=frame.searchButton, as=true} -- just skin it otherwise text is hidden
            self:skinButton{obj=frame.skilletButton, as=true} -- just skin it otherwise text is hidden
            self:Unhook(mod.Private, "SetupConfigGui")
        end)
    end

    -- GlypherPost
    local mod = _G.AucAdvanced.Modules.Util.GlypherPost
    if mod then
        self:SecureHook(mod.Private, "SetupConfigGui", function(this, gui)
            local frame = mod.Private.frame
            self:skinButton{obj=frame.refreshButton, as=true} -- just skin it otherwise text is hidden
            self:Unhook(mod.Private, "SetupConfigGui")
        end)
    end

	--	CompactUI module
	--	configure button on AH frame
	local mod = _G.AucAdvanced.Modules.Util.CompactUI
	if mod then
		self:skinButton{obj=mod.Private.switchUI, y1=2, y2=-3}
	end

--	Settings frames(s) ??

	-- Buy prompt
	if _G.AucAdvanced.Buy then
		self:skinEditBox{obj=_G.AucAdvanced.Buy.Private.Prompt.Reason, regs={6}}
		self:skinButton{obj=_G.AucAdvanced.Buy.Private.Prompt.Yes}
		self:skinButton{obj=_G.AucAdvanced.Buy.Private.Prompt.No}
		self:addSkinFrame{obj=_G.AucAdvanced.Buy.Private.Prompt.Frame, nb=true}
	end

	-- Post prompt
	if _G.AucAdvanced.Post then
		self:skinButton{obj=_G.AucAdvanced.Post.Private.Prompt.Yes}
		self:skinButton{obj=_G.AucAdvanced.Post.Private.Prompt.No}
		self:addSkinFrame{obj=_G.AucAdvanced.Post.Private.Prompt.Frame, nb=true}
	end

end
