local aName, aObj = ...
if not aObj:isAddonEnabled("Skada") then return end

function aObj:Skada()

	local function changeSettings(db)

		db.barcolor = CopyTable(aObj.db.profile.StatusBar)
		db.bartexture = db.bartexture == "Empty" and db.bartexture or db.barcolor.texture -- change if not "Empty" texture
		db.barcolor.texture = nil -- remove texture element
		-- background settings
		db.background.texture = aObj.db.profile.BdTexture
		db.background.margin = aObj.db.profile.BdInset
		db.background.borderthickness = aObj.db.profile.BdEdgeSize
		db.background.bordertexture = aObj.db.profile.BdBorderTexture
		db.background.color = aObj.db.profile.Backdrop

	end
	local function skinFrame(win)

		-- skin windows if required
		if not aObj.skinFrame[win.bargroup]
		then
			-- print(win.bargroup.bgframe, win.bargroup.button)
			aObj:addSkinFrame{obj=win.bargroup}
			win.bargroup:SetBackdrop(nil)
			win.bargroup.SetBackdrop = function() end
		end

	end
	local barDisplay = Skada:GetModule("BarDisplay", true)
	if barDisplay then
		-- hook this to skin new frames
		self:SecureHook(barDisplay, "ApplySettings", function(this, win)
			skinFrame(win)
		end)
	end

	-- change the default settings
	changeSettings(Skada.windowdefaults)

	-- change existing ones
	for _, win in pairs(Skada:GetWindows()) do
		changeSettings(win.db)
		skinFrame(win)
		-- apply these changes
		win.display:ApplySettings(win)
	end

end
