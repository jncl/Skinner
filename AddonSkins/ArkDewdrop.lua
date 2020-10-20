local aName, aObj = ...
-- This is a Library
local _G = _G

aObj.libsToSkin.ArkDewdrop = function(self) -- v 30109
	if self.initialized.ArkDewdrop then return end
	self.initialized.ArkDewdrop = true

	local ArkDewdrop, libver = _G.LibStub:GetLibrary("ArkDewdrop", true)
	local loopCnt = 127 -- not sure why it is, but it is

	local sf, eb
	local function skinArkDewdrop()
		local frame
		for i = 0, loopCnt do
			frame = _G["ArkDewdrop" .. libver .. "Level" .. i]
			if frame
			and not	frame.sf
			then
				aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
				aObj:removeBackdrop(aObj:getChild(frame, 1))
			end
		end
		frame = nil
		-- handle reuse of level 127 frame name
		local lc = aObj:getLastChild(_G.UIParent)
		if not lc.sf then
			aObj:addSkinFrame{obj=lc, ft="a", kfs=true, nb=true}
			aObj:removeBackdrop(aObj:getChild(lc, 1))
		end
		lc = nil
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
	self:SecureHook(ArkDewdrop, "Open", function(this, _)
		skinArkDewdrop()
	end)

	skinArkDewdrop()

end
