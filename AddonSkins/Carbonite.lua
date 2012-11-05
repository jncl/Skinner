local aName, aObj = ...
if not aObj:isAddonEnabled("Carbonite") then return end

function aObj:Carbonite()

	local function P_23(r, g, b, a)

		local clr = r * 255
		clr = bit.lshift(clr, 8) + g * 255
		clr = bit.lshift(clr, 8) + b * 255
		clr = bit.lshift(clr, 8) + a * 255
		return clr

	end

	local BdC = self.db.profile.Backdrop
	local BdBC = self.db.profile.BackdropBorder

	-- create skin entry
	Nx.Skins["Skinner"] = {
		["Folder"] = "",
		["WinBrH"] = "WinBrH",
		["WinBrV"] = "WinBrV",
		["TabOff"] = "TabOff",
		["TabOn"] = "TabOn",
		["Backdrop"] = CopyTable(self.backdrop),
		["BdCol"] = P_23(BdBC.r, BdBC.g, BdBC.b, BdBC.a),
		["BgCol"] = P_23(BdC.r, BdC.g, BdC.b, BdC.a),
	}
	Spew("Nx.Skins", Nx.Skins)

	-- add entry to options
	for i, v in pairs(Nx.OptsData) do
--		self:Debug("Carbonite: [%s, %s]", i, v.N)
		if v.N == "Skin" then
			table.insert(Nx.OptsData[i], {N = "Skinner", F = "NXCmdSkin", Data = "Skinner"})
			break
		end
	end

	local function onUpdate(win)

		local alpha, max = win.NxWin.BackgndFade, win.NxWin.BackgndFadeIn
		-- self:Debug("win_OnU: [%s, %s, %s]", win, alpha, max)
		if alpha >= max then win.tfade:Show()
		else win.tfade:Hide() end

	end

	-- skin Title frame
	self:addSkinFrame{obj=Nx.Title.Frm, kfs=true}

	-- add a gradient to the existing frames
	for win, _ in pairs(Nx.Window.Wins) do
		self:applyGradient(win.Frm)
		win.Frm.tfade:Hide() -- hide the Gradient
		-- hook this to fade the frames' Gradient
		self:HookScript(win.Frm, "OnUpdate", function(this, ...)
			onUpdate(this)
		end)
	end
	-- add a gradient to the existing menu frames
	for menu, _ in pairs(Nx.Menu.Menus) do
		self:applyGradient(menu.MainFrm)
	end

-->>-- Hooks
	-- hook this to manage the backdrop colour for fixed sized frames
	self:RawHook(Nx.Skin, "GetFixedSizeBGCol", function(this)
		return {BdC.r, BdC.g, BdC.b, BdC.a}
	end, true)
	-- hook this to add a Gradient to new frames
	self:RawHook(Nx.Window, "Create", function(this, ...)
		local win = self.hooks[this].Create(this, ...)
		self:applyGradient(win.Frm)
		win.Frm.tfade:Hide() -- hide the Gradient
		-- hook this to fade the frames' Gradient
		self:HookScript(win.Frm, "OnUpdate", function(this, ...)
			onUpdate(this)
		end)
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
