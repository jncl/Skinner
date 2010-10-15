-- This is a Library

function Skinner:ArkDewdrop()
	if self.initialized.ArkDewdrop then return end
	self.initialized.ArkDewdrop = true

	local frame, sf, eb

	local function skinArkDewdrop()

		local i = 1
		while _G["ArkDewdrop30Level"..i] do
			Skinner:Debug("ArkDewdrop30Level"..i)
			frame = _G["ArkDewdrop30Level"..i]
			if not Skinner.skinned[frame] then
				Skinner:applySkin(frame)
				-- change these to stop the Backdrop colours from being changed
				frame.SetBackdropColor = function() end
				frame.SetBackdropBorderColor = function() end
				-- hide the backdrop frame
				Skinner:getChild(frame, 1):Hide()
			end
			i = i + 1
		end
		-- hook the OnEnter script for the buttons and use that to skin from
		local i = 1
		while _G["ArkDewdrop30Button"..i] do
--			Skinner:Debug("DB found: [%s]", i)
			if not Skinner:IsHooked(_G["ArkDewdrop30Button"..i], "OnEnter") then
				Skinner:HookScript(_G["ArkDewdrop30Button"..i], "OnEnter", function(this)
					Skinner.hooks[this].OnEnter(this)
					if not this.disabled and this.hasArrow then
-- 						Skinner:Debug("DB has Arrow: [%s]", this:GetName())
						skinDewdrop()
					end
				end)
			end
			i = i + 1
		end
		-- Check to see if the SliderFrame and/or EditBox need to be skinned
		-- if so then check to see if they have been created yet
		-- if they have then skin them
		if not sf then
			sf = Skinner:findFrame(170, 100, {"Slider", "EditBox"})
			if sf and not Skinner.skinned[sf] then
				Skinner:skinEditBox(sf.currentText, {9})
				-- Make it wider to display 4 digits
				sf.currentText:ClearAllPoints()
				sf.currentText:SetPoint("RIGHT", sf, "RIGHT", -12, 0)
				sf.currentText:SetPoint("LEFT", sf.slider, "RIGHT", 8, 0)
				Skinner:applySkin(sf)
			end
		end
		if not eb then
			eb = Skinner:findFrame(40, 200, {"EditBox"})
			if eb and not Skinner.skinned[eb] then
				Skinner:skinEditBox(eb.editBox, {9})
				eb.editBox:SetWidth(180)
				Skinner:applySkin(eb)
			end
		end
	end

	-- Hook this to skin new ArkDewdrop components
	self:SecureHook(LibStub("ArkDewdrop-3.0", true), "Open", function(parent)
--		self:Debug("DewdropOpen: [%s]", parent)
		skinArkDewdrop()
	end)

	skinArkDewdrop()

end
