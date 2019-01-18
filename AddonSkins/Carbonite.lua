local aName, aObj = ...
if not aObj:isAddonEnabled("Carbonite") then return end
local _G = _G

aObj.addonsToSkin.Carbonite = function(self) -- v 8.1

	local Nx = _G.LibStub("AceAddon-3.0"):GetAddon("Carbonite", true)
	if not Nx then return end

	-- create skin entry
	Nx.Skins["Skinner"] = {
		["Folder"] = "",
		["WinBrH"] = "WinBrH",
		["WinBrV"] = "WinBrV",
		["TabOff"] = "TabOff",
		["TabOn"] = "TabOn",
		["Backdrop"] = _G.CopyTable(self.backdrop),
		["BdCol"] = _G.tostring(self.bbClr.r .. "|" .. self.bbClr.g .. "|" .. self.bbClr.b .. "|" .. self.bbClr.a),
		["BgCol"] = _G.tostring(self.bClr.r .. "|" .. self.bClr.g .. "|" .. self.bClr.b .. "|" .. self.bClr.a),
	}

	-- add entry to options dropdown
	self:add2Table(Nx.Opts.Skins, "Skinner")

	-- skin Title frame
	self:addSkinFrame{obj=Nx.Title.Frm, ft="a", kfs=true, nb=true}

	local function addGradient(frame)

		aObj:applyGradient(frame)
		frame.tfade:Hide() -- hide the Gradient
		-- hook this to fade the frames' Gradient
		aObj:HookScript(frame, "OnUpdate", function(this, ...)
			local alpha, max = this.NxWin.BackgndFade, this.NxWin.BackgndFadeIn
			-- self:Debug("win_OnU: [%s, %s, %s]", this, alpha, max)
			if alpha >= max then this.tfade:Show()
			else this.tfade:Hide() end
		end)

	end

	-- add a gradient to the existing frames
	for win, _ in _G.pairs(Nx.Window.Wins) do
		addGradient(win.Frm)
	end
	-- add a gradient to the existing menu frames
	for menu, _ in _G.pairs(Nx.Menu.Menus) do
		self:applyGradient(menu.MainFrm)
	end

-->>-- Hooks
	-- hook this to manage the backdrop colour for fixed sized frames
	self:RawHook(Nx.Skin, "GetFixedSizeBGCol", function(this)
		return {self.bClr:GetRGBA()}
	end, true)
	-- hook this to add a Gradient to new frames
	self:RawHook(Nx.Window, "Create", function(this, ...)
		local win = self.hooks[this].Create(this, ...)
		addGradient(win.Frm)
		return win
	end)
	-- hook this to add a Gradient to new menu frames
	self:RawHook(Nx.Menu, "Create", function(this, ...)
		local menu = self.hooks[this].Create(this, ...)
		self:applyGradient(menu.MainFrm)
		return menu
	end)

	-- use Skinner skin
	Nx.Skin:Set("Skinner")

end
