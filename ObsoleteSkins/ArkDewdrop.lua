local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin.ArkDewdrop = function(self) -- v 30109
	if self.initialized.ArkDewdrop then return end
	self.initialized.ArkDewdrop = true

	local ArkDewdrop, libver = _G.LibStub:GetLibrary("ArkDewdrop", true)
	local loopCnt = 150 -- should be < 25, there is a bug in the AcquireLevel code

	local sf, eb
	local function skinArkDewdrop()
		local frame
		for i = 0, loopCnt do
			frame = _G["ArkDewdrop" .. libver .. "Level" .. i]
			if frame then
				aObj:removeBackdrop(aObj:getChild(frame, 1))
				if not frame.sf then
					aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
				end
			end
		end
		frame = nil
		local btn
		-- hook the OnEnter script for the buttons and use that to skin from
		for i = 1, loopCnt do
			btn = _G["ArkDewdrop" .. libver .. "Button" .. i]
			if btn then
				aObj:secureHookScript(btn, "OnEnter", function(this) -- do after original script
					if not this.disabled
					and this.hasArrow
					then
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
				aObj:skinEditBox(eb.editBox, {9})
				eb.editBox:SetWidth(180)
				aObj:applySkin(eb)
			end
		end
	end

	-- Hook this to skin new ArkDewdrop components
	self:SecureHook(ArkDewdrop, "Open", function(this, ...)
		skinArkDewdrop()
	end)

	skinArkDewdrop()

end
