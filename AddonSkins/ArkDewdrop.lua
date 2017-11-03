local aName, aObj = ...
-- This is a Library
local _G = _G

aObj.libsToSkin.ArkDewdrop = function(self) -- v 30102
	if self.initialized.ArkDewdrop then return end
	self.initialized.ArkDewdrop = true

	local libver = 30102
	local loopcnt = 100

	local sf, eb
	local function skinArkDewdrop(parent, ...)

		local frame
		for i = 0, loopcnt do
			frame = _G["ArkDewdrop" .. libver .. "Level" .. i]
			aObj:Debug("ArkDewdropLevel: [%s, %s]", i, frame or nil)
			if frame
			and not frame.sf
			then
				aObj:addSkinFrame{obj=frame, ft="a"}
				aObj:getChild(frame, 1):SetBackdrop(nil)
			end
		end
		frame = nil
		local btn
		-- hook the OnEnter script for the buttons and use that to skin from
		for i = 0, loopcnt do
			btn = _G["ArkDewdrop" .. libver .. "Button" .. i]
			if btn then
				aObj:secureHookScript(btn, "OnEnter", function(this) -- do after original script
					if not this.disabled and this.hasArrow then
						skinArkDewdrop()
					end
				end)
			end
		end
		btn = nil
		-- Check to see if the SliderFrame and/or EditBox need to be skinned
		-- if so then check to see if they have been created yet
		-- if they have then skin them
		if not sf then
			sf = aObj:findFrame(170, 100, {"Slider", "EditBox"})
			if sf
			and not sf.sknd
			then
				sf.sknd = true
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
			if eb
			and not eb.sknd
			then
				eb.sknd = true
				aObj:skinEditBox(eb.editBox, {9})
				eb.editBox:SetWidth(180)
				aObj:applySkin(eb)
			end
		end
	end

	-- Hook this to skin new ArkDewdrop components
	self:SecureHook(_G.LibStub("ArkDewdrop", true), "Open", function(this, parent, ...)
		skinArkDewdrop(parent, ...)
	end)

	skinArkDewdrop()

end
