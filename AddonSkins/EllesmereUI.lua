local aName, aObj = ...
if not aObj:isAddonEnabled("EllesmereUI") then return end
local _G = _G

-- The following code handles the Initial setup of Skinner when the EllesmereUI is loaded
aObj.otherAddons.EllesmereUIInit = function(self) -- v 9.6.1

	-- register EllesmereUI callback
	if _G.EllesmereUI and _G.EllesmereUI.RegisterSkin then
		_G.EllesmereUI.RegisterSkin(aName, function(S) self.euiCB = S _G.Spew("euiCB", S) end)
	else
		aObj:CustomPrint(1, 0, 0, "EllesmereUI AddOn not loaded")
		aObj:Debug("EllesmereUIInit, AddOn or function NOT found: [%s, %s]", _G.EllesmereUI, _G.EllesmereUI.RegisterSkin)
		return
	end

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("SetupDefaults", "opt", false, true)
		self.SetupDefaults = nil -- only need to run this once

		local prdb = self.db.profile
		local profName = "EllesmereUI"

		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= profName then
			self.db:SetProfile(profName) -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile
			prdb = self.db.profile
			-- change settings
			prdb.Warnings                  = false
			prdb.DisableAllNPC             = true
			prdb.DisableAllP               = true
			prdb.DisableAllUI              = true
		end

		-- run the function
		self.hooks[this].OnInitialize(this)

		self.isEllesmereUI = true

		self:Unhook(self, "OnInitialize")
	end)

	-- use EllesmereUI skinning functions
	aObj.skinTPLs = nil
	self.skinObject = function(_, oType, oTab)
		aObj:Debug("skinObject: [%s, %s, %s]", oType, oTab, oTab.obj)
		if oType == "skin" then _G.nop()
		elseif oType == "button" then self.euiCB.Button(oTab.obj)
		elseif oType == "ddbutton" then self.euiCB.Dropdown(oTab.obj)
		elseif oType == "ddlist" then self.euiCB.Panel(oTab.obj)
		elseif oType == "dropdown" then self.euiCB.Dropdown(oTab.obj)
		elseif oType == "editbox" then self.euiCB.EditBox(oTab.obj)
		elseif oType == "frame" then self.euiCB.Shell(oTab.obj)
		elseif oType == "glowbox" then self.euiCB.Panel(oTab.obj)
		elseif oType == "moneyframe" then _G.nop()
		elseif oType == "progressbar" then self.euiCB.ApplyBarFill(oTab.obj)
		elseif oType == "scrollbar" then self.euiCB.ScrollBar(oTab.obj)
		elseif oType == "sidetabs" then _G.nop()
		elseif oType == "slider" then self.euiCB.ScrollBar(oTab.obj)
		elseif oType == "statusbar" then self.euiCB.ApplyBarFill(oTab.obj)
		elseif oType == "tabs" then
			if oTab.obj.Tabs then
				for _, tab in _G.ipairs(oTab.obj.Tabs) do
					self.euiCB.Tab(tab)
				end
	        end
		elseif oType == "tooltip" then self.euiCB.Panel(oTab.obj)
		end
	end

	self.keepFontStrings   = function(_, frame) self.euiCB.FadeRegions(frame) end
	self.removeInset       = function(_, frame) self.euiCB.Inset(frame) end
	self.removeNineSlice   = function(_, frame) self.euiCB.FadeNineSlice(frame) end
	self.removeRegions     = function(_, frame) self.euiCB.FadeRegions(frame) end
	self.setActiveTab      = function(tabSF) self.euiCB.SetTabSelection(tabSF:GetParent(), true) end
	self.setInactiveTab    = function(tabSF) self.euiCB.SetTabSelection(tabSF:GetParent(), false) end
	self.makeIconSquare    = function(_, obj, iconTexture) self.euiCB.SquareIcon(iconTexture, obj) end
	self.skinColumnDisplay = function(_, frame) self.euiCB.SortHeaderBar(frame.columnHeaders) end

	self.makeMFRotatable   = _G.nop
	self.updateSBTexture   = _G.nop

	local modUIBtns = self:GetModule("UIButtons", true)
	if modUIBtns
	and modUIBtns:IsEnabled()
	then
		-- disable skinning functions
		modUIBtns.checkTex         = _G.nop
		modUIBtns.skinActionBtn    = _G.nop
		modUIBtns.skinExpandButton = _G.nop
		modUIBtns.skinOtherButton  = _G.nop
		modUIBtns.addButtonBorder  = _G.nop
		-- hook this as UIButton code is now in a module
		self:SecureHook(modUIBtns, "OnEnable", function(_)
			modUIBtns.skinCloseButton = function(_, opts) aObj.euiCB.CloseButton(opts.obj) end
			-- self.euiCB.PageButton
			modUIBtns.skinStdButton = function(_, opts) aObj.euiCB.Button(opts.obj) end
			modUIBtns.skinCheckButton = function(_, opts) aObj.euiCB.Checkbox(opts.obj) end
			self:Unhook(modUIBtns, "OnEnable")
		end)
	end

end

-- Load support for EllesmereUI
local success, _ = _G.xpcall(function() return aObj.otherAddons.EllesmereUIInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running EllesmereUIInit")
end
