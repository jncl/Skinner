local aName, aObj = ...
-- This is a Library
local _G = _G

function aObj:ArkDewdrop()
	if self.initialized.ArkDewdrop then return end
	self.initialized.ArkDewdrop = true

	local frame, sf, eb, i

	local function skinArkDewdrop()

		i = 1
		while _G["ArkDewdrop30Level" .. i] do
			-- aObj:Debug("ArkDewdrop30Level" .. i)
			frame = _G["ArkDewdrop30Level" .. i]
			if not aObj.skinned[frame] then
				aObj:applySkin(frame)
				-- change these to stop the Backdrop colours from being changed
				frame.SetBackdropColor = function() end
				frame.SetBackdropBorderColor = function() end
				-- hide the backdrop frame
				aObj:getChild(frame, 1):Hide()
			end
			i = i + 1
		end
		-- hook the OnEnter script for the buttons and use that to skin from
		i = 1
		while _G["ArkDewdrop30Button" .. i] do
			if not aObj:IsHooked(_G["ArkDewdrop30Button" .. i], "OnEnter") then
				aObj:HookScript(_G["ArkDewdrop30Button" .. i], "OnEnter", function(this)
					aObj.hooks[this].OnEnter(this)
					if not this.disabled and this.hasArrow then
						skinArkDewdrop()
					end
				end)
			end
			i = i + 1
		end
		-- Check to see if the SliderFrame and/or EditBox need to be skinned
		-- if so then check to see if they have been created yet
		-- if they have then skin them
		if not sf then
			sf = aObj:findFrame(170, 100, {"Slider", "EditBox"})
			if sf and not aObj.skinned[sf] then
				aObj:skinEditBox(sf.currentText, {9})
				-- Make it wider to display 4 digits
				sf.currentText:ClearAllPoints()
				sf.currentText:SetPoint("RIGHT", sf, "RIGHT", -12, 0)
				sf.currentText:SetPoint("LEFT", sf.slider, "RIGHT", 8, 0)
				aObj:applySkin(sf)
			end
		end
		if not eb then
			eb = aObj:findFrame(40, 200, {"EditBox"})
			if eb and not aObj.skinned[eb] then
				aObj:skinEditBox(eb.editBox, {9})
				eb.editBox:SetWidth(180)
				aObj:applySkin(eb)
			end
		end
	end

	-- Hook this to skin new ArkDewdrop components
	self:SecureHook(_G.LibStub("ArkDewdrop-3.0", true), "Open", function(parent)
		skinArkDewdrop()
	end)

	skinArkDewdrop()

end
