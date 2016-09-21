local aName, aObj = ...
if not aObj:isAddonEnabled("Skada") then return end
local _G = _G

function aObj:Skada() -- 1.5-8

	local function changeSettings(db)

		db.barcolor = _G.CopyTable(aObj.db.profile.StatusBar)
		db.bartexture = db.bartexture == "Empty" and db.bartexture or db.barcolor.texture -- change if not "Empty" texture
		db.barcolor.texture = nil -- remove texture element
		-- background settings
		db.background.texture = aObj.db.profile.BdTexture
		db.background.margin = aObj.db.profile.BdInset
		-- change if using default value
		if db.background.borderthickness == 2 then db.background.borderthickness = 0 end
		db.background.bordertexture = aObj.db.profile.BdBorderTexture
		db.background.color = aObj.db.profile.Backdrop

	end
	local offset = 4
	local function skinFrame(win)

		-- skin windows if required
		if not win.bargroup.sf then
			aObj:addSkinFrame{obj=win.bargroup, ofs=offset, y1=(win.db.title.height or 15) + offset}
			win.bargroup.SetBackdrop = function() end
		end

	end
	local barDisplay = _G.Skada:GetModule("BarDisplay", true)
	if barDisplay then
		-- hook this to skin new frames
		self:SecureHook(barDisplay, "ApplySettings", function(this, win)
			skinFrame(win)
		end)
	end

	-- change the default settings
	changeSettings(_G.Skada.windowdefaults)

	-- change existing ones
	for _, win in _G.pairs(_G.Skada:GetWindows()) do
		changeSettings(win.db)
		-- skinFrame(win)
		-- apply these changes
		-- win.display:ApplySettings(win)
	end

	-- Temp upgrade popup
	if _G.SkadaWarn then
		self:addSkinFrame{obj=_G.SkadaWarn}
	end

	-- skin popup frame
	self.RegisterCallback("Skada", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Frame")
		and child:GetName() == nil
		and self:getInt(child:GetWidth()) == 250
		and self:getInt(child:GetHeight()) == 100
		then
			self:addSkinFrame{obj=child}
		end
	end)

end
