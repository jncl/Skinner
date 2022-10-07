local _, aObj = ...
if not aObj:isAddonEnabled("Skada") then return end
local _G = _G

aObj.addonsToSkin.Skada = function(self) -- v 1.8.3

	local function changeSettings(db)
		db.barcolor                   = _G.CopyTable(aObj.db.profile.StatusBar)
		db.bartexture                 = db.bartexture == "Empty" and db.bartexture or db.barcolor.texture -- change if not "Empty" texture
		db.barcolor.texture           = nil -- remove texture element
		db.background.texture         = aObj.db.profile.BdTexture
		db.background.bordertexture   = aObj.db.profile.BdBorderTexture
		db.background.color           = {aObj.db.profile.Backdrop:GetRGBA()}
		db.background.borderthickness = db.background.borderthickness == 2 and 0 or db.background.borderthickness
	end
	changeSettings(_G.Skada.windowdefaults)

	for _, win in _G.pairs(_G.Skada:GetWindows()) do
		changeSettings(win.db)
	end

	local offset = 4
	local function skinFrame(win)
		aObj:skinObject("frame", {obj=win.bargroup, ofs=offset, y1=(win.db.title.height or 15) + offset})
		win.bargroup.SetBackdrop = _G.nop
	end
	local barDisplay = _G.Skada:GetModule("BarDisplay", true)
	if barDisplay then
		self:SecureHook(barDisplay, "ApplySettings", function(_, win)
			skinFrame(win)
		end)
	end

	if _G.SkadaWarn then
		self:skinObject("frame", {obj=_G.SkadaWarn})
	end

	-- skin popup frame
	self.RegisterCallback("Skada", "UIParent_GetChildren", function(_, child)
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and _G.Round(child:GetWidth()) == 250
		and _G.Round(child:GetHeight()) == 100
		then
			self:skinObject("frame", {obj=child})
			self.UnregisterCallback("Skada", "UIParent_GetChildren")
		end
	end)

end
