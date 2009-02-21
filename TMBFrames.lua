
local ftype = "s"

function Skinner:adjustTFOffset(reset)
--	self:Debug("adjustTFOffset:[%s, %s, %s]", reset, self.db.profile.TopFrame.height, UIParent:GetAttribute("TOP_OFFSET"))

	--	Adjust the UIParent TOP-OFFSET attribute if required
	if self.initialized.TopFrame then
		local topOfs = -self.db.profile.TopFrame.height
		local UIPtopOfs = -104
		if topOfs < UIPtopOfs and not reset then
			UIParent:SetAttribute("TOP_OFFSET", topOfs)
		elseif UIParent:GetAttribute("TOP_OFFSET") < UIPtopOfs then
			UIParent:SetAttribute("TOP_OFFSET", UIPtopOfs)
		end
	end

end

function Skinner:TopFrame()
	if not self.db.profile.TopFrame.shown then return end

	local fh = nil

	local frame = CreateFrame("Frame", "SkinnerTF", UIParent)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetFrameLevel(0)
	frame:EnableMouse(false)
	frame:SetMovable(false)
	frame:SetWidth(self.db.profile.TopFrame.width or 1920)
	frame:SetHeight(self.db.profile.TopFrame.height or 100)
	frame:ClearAllPoints()
	if self.db.profile.TopFrame.xyOff or self.db.profile.TopFrame.borderOff then
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -6, 6)
	else
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -3, 3)
	end
	local fb = self.db.profile.TopFrame.borderOff and 0 or 1
	-- set the fade height
	if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
		-- set the Fade Height to the global value if 'forced'
		-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= math.ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(frame:GetHeight())
	elseif self.db.profile.TopFrame.fheight then
		fh = self.db.profile.TopFrame.fheight <= math.ceil(frame:GetHeight()) and self.db.profile.TopFrame.fheight or math.ceil(frame:GetHeight())
	end
	self:storeAndSkin(ftype, frame, nil, fb, self.db.profile.TopFrame.alpha, fh)

	-- keep a reference to the frame
	self.topframe = frame

	self:adjustTFOffset(nil)

	if not self.db.profile.Gradient.skinner then return end

	-- TopFrame Gradient settings
	local orientation = self.db.profile.TopFrame.rotate and "HORIZONTAL" or "VERTICAL"
	self.gradientOnTF = self.db.profile.TopFrame.invert and {orientation, self.MaxR, self.MaxG, self.MaxB, self.MaxA, self.MinR, self.MinG, self.MinB, self.MinA} or {orientation, self.MinR, self.MinG, self.MinB, self.MinA, self.MaxR, self.MaxG, self.MaxB, self.MaxA}
	gradientOffTF = {orientation, 0, 0, 0, 1, 0, 0, 0, 1}

	if self.db.profile.TopFrame.invert then
		frame.tfade:ClearAllPoints()
		frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -4, 4)
		frame.tfade:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 4, (fh - 4))
	end
	--	apply the Gradient
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOnTF or gradientOffTF))

end

function Skinner:MiddleFrames()

	local function createMiddleFrame(frameId)

		local dbkey = "MiddleFrame"..frameId
		if Skinner.initialized[dbkey] then return end -- already created
		Skinner.initialized[dbkey] = true

		local mfkey = Skinner.db.profile[dbkey]
		local mfp = Skinner.db.profile.MiddleFrame

		local frame = CreateFrame("Frame", "SkinnerMF"..frameId, UIParent)
		frame:SetID(frameId)
		frame:SetFrameStrata(mfkey.fstrata)
		frame:SetFrameLevel(mfkey.flevel)
		frame:SetMovable(true)
		frame:SetResizable(true)
		frame:SetWidth(mfkey.width)
		frame:SetHeight(mfkey.height)
		frame:SetPoint("CENTER", UIParent, "CENTER", mfkey.xOfs, mfkey.yOfs)
		frame:RegisterForDrag("LeftButtonUp")

		if not OnMouseDown then
			function OnMouseDown()
				if arg1 == "LeftButton" and IsAltKeyDown() then
					this.isMoving = true
					this:StartMoving()
					this:Raise()
				end
				if arg1 == "LeftButton" and IsControlKeyDown() then
					this.isMoving = true
					this:StartSizing("BOTTOMRIGHT")
					this:Raise()
				end
			end
		end
		if mfp.lock then
			frame:SetScript("OnMouseDown", function() end)
			frame:EnableMouse(false)
		else
			frame:SetScript("OnMouseDown", OnMouseDown)
			frame:EnableMouse(true)
		end
		if not OnMouseUp then
			function OnMouseUp()
				if arg1 == "LeftButton" then
					if this.isMoving then
						this:StopMovingOrSizing()
						this.isMoving = nil
						this:SetFrameStrata("BACKGROUND")
						this:SetFrameLevel(0)
						local x, y = this:GetCenter()
						local px, py = this:GetParent():GetCenter()
						local dbkey	= "MiddleFrame"..this:GetID()
						Skinner.db.profile[dbkey].xOfs = x - px
						Skinner.db.profile[dbkey].yOfs = y - py
						Skinner.db.profile[dbkey].width = math.floor(this:GetWidth())
						Skinner.db.profile[dbkey].height = math.floor(this:GetHeight())
					end
				end
			end
		end
		frame:SetScript("OnMouseUp", OnMouseUp)
		if not OnHide then
			function OnHide()
				if this.isMoving then
					this:StopMovingOrSizing()
					this.isMoving = nil
				end
			end
		end
		frame:SetScript("OnHide", OnHide)

		local fhp = Skinner.db.profile.FadeHeight
		-- set the fade height
		if fhp.enable and fhp.force then
		-- set the Fade Height to the global value if 'forced'
		-- making sure that it isn't greater than the frame height
			fh = fhp.value <= math.ceil(frame:GetHeight()) and fhp.value or math.ceil(frame:GetHeight())
		elseif mfp.fheight then
			fh = mfp.fheight <= math.ceil(frame:GetHeight()) and mfp.fheight or math.ceil(frame:GetHeight())
		end
		local fb = mfp.borderOff and 0 or 1
		Skinner:storeAndSkin(ftype, frame, nil, fb, nil, fh)
		frame:SetBackdropColor(mfp.r, mfp.g, mfp.b, mfp.a)

		Skinner["middleframe"..frameId] = frame

		frame:Show()

	end

	for i = 1, 9 do
		if self.db.profile["MiddleFrame"..i].shown then createMiddleFrame(i) end
	end

end

function Skinner:BottomFrame()
	if not self.db.profile.BottomFrame.shown then return end

	local fh = nil

	local frame = CreateFrame("Frame", "SkinnerBF", UIParent)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetFrameLevel(0)
	frame:EnableMouse(false)
	frame:SetMovable(false)
	frame:SetWidth(self.db.profile.BottomFrame.width or 1920)
	frame:SetHeight(self.db.profile.BottomFrame.height or 200)
	frame:ClearAllPoints()
	if self.db.profile.BottomFrame.xyOff  or self.db.profile.BottomFrame.borderOff then
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -6, -6)
	else
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3, -3)
	end
	local fb = self.db.profile.BottomFrame.borderOff and 0 or 1
	-- set the fade height
	if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
	-- set the Fade Height to the global value if 'forced'
	-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= math.ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(frame:GetHeight())
	elseif self.db.profile.BottomFrame.fheight then
		fh = self.db.profile.BottomFrame.fheight <= math.ceil(frame:GetHeight()) and self.db.profile.BottomFrame.fheight or math.ceil(frame:GetHeight())
	end
	self:storeAndSkin(ftype, frame, nil, fb, self.db.profile.BottomFrame.alpha, fh)

	-- keep a reference to the frame
	self.bottomframe = frame

	if not self.db.profile.Gradient.skinner then return end

	-- BottomFrame Gradient settings
	local orientation = self.db.profile.BottomFrame.rotate and "HORIZONTAL" or "VERTICAL"
	self.gradientOnBF = self.db.profile.BottomFrame.invert and {orientation, self.MaxR, self.MaxG, self.MaxB, self.MaxA, self.MinR, self.MinG, self.MinB, self.MinA} or {orientation, self.MinR, self.MinG, self.MinB, self.MinA, self.MaxR, self.MaxG, self.MaxB, self.MaxA}
	gradientOffBF = {orientation, 0, 0, 0, 1, 0, 0, 0, 1}

	if self.db.profile.BottomFrame.invert then
		frame.tfade:ClearAllPoints()
		frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -4, 4)
		frame.tfade:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 4, (fh - 4))
	end
	--	apply the Gradient
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOnBF or gradientOffBF))

end
