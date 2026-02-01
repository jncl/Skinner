local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin.ArkDewdrop = function(self) -- v 30111
	if self.initialized.ArkDewdrop then return end
	self.initialized.ArkDewdrop = true

	local libAD, libver = _G.LibStub:GetLibrary("ArkDewdrop", true)

	if not libAD then
		return
	end

	local foundKid
	local function findADobj(adObj)
		for _, child in _G.ipairs_reverse{_G.UIParent:GetChildren()} do
			-- check for forbidden objects (StoreUI components etc.)
			if not child:IsForbidden() then
				if child.parent
				and child.parent == adObj
				then
					foundKid = child
					break
				end
			end
			foundKid = nil
		end

		return foundKid
	end
	local function skinDropdownPanel(panel)
		if not panel then
			return
		end
		aObj:skinObject("frame", {obj=aObj:getChild(panel, 1), kfs=true, ofs=0})
		panel.sknd = true
		for _, btn in _G.pairs(panel.buttons) do
			if btn.value then
				aObj:SecureHookScript(btn, "OnEnter", function(this)
					_G.C_Timer.After(0.05, function()
						skinDropdownPanel(findADobj(this))
					end)
					aObj:Unhook(this, "OnEnter")
				end)
			end
		end
	end
	local function skinArkDewdrop(adObj)
		if not adObj then
			return
		end
		if adObj:IsObjectType("Button") then -- Dropdown menu panel
			_G.C_Timer.After(0.05, function()
				skinDropdownPanel(adObj)
			end)
		end

		-- .hasSlider
		-- .hasEditBox

	-- 	-- Check to see if the SliderFrame and/or EditBox need to be skinned
	-- 	-- if so then check to see if they have been created yet
	-- 	-- if they have then skin them
	-- 	if not sf then
	-- 		sf = aObj:findFrame(170, 100, {"Slider", "EditBox"})
	-- 		if sf
	-- 		and not sf.sknd
	-- 		then
	-- 			aObj:skinEditBox(sf.currentText, {9})
	-- 			-- Make it wider to display 4 digits
	-- 			sf.currentText:ClearAllPoints()
	-- 			sf.currentText:SetPoint("RIGHT", sf, "RIGHT", -12, 0)
	-- 			sf.currentText:SetPoint("LEFT", sf.slider, "RIGHT", 8, 0)
	-- 			aObj:applySkin(sf)
	-- 		end
	-- 	end
	-- 	if not eb then
	-- 		eb = aObj:findFrame(40, 200, {"EditBox"})
	-- 		if eb
	-- 		and not eb.sknd
	-- 		then
	-- 			aObj:skinEditBox(eb.editBox, {9})
	-- 			eb.editBox:SetWidth(180)
	-- 			aObj:applySkin(eb)
	-- 		end
	-- 	end
	end

	-- Hook this to skin new ArkDewdrop components
	self:SecureHook(libAD, "Open", function(_, parent, ...)
		_G.C_Timer.After(0.05, function()
			skinArkDewdrop(findADobj(parent))
		end)

	end)

end
