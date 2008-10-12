
function Skinner:tekKonfig()
	-- only need to do this once
	if self.initialized.tekKonfig then return end
	self.initialized.tekKonfig = true
	
	if LibStub and LibStub:GetLibrary("tekKonfig-Dropdown", true) then
		local tKDd = LibStub("tekKonfig-Dropdown")
		self:Hook(tKDd, "new", function(parent, label, ...)
			self:Debug("tKDd:[%s, %s]", parent, label)
			local frame, text, container = self.hooks[tKDd].new(parent, label, ...)
			if not self.db.profile.TexturedDD then self:keepFontStrings(frame)
			else
				local leftTex, midTex, rightTex = select(1, frame:GetRegions())
				leftTex:SetAlpha(0)
				midTex:SetTexture(self.LSM:Fetch("background", "Inactive Tab"))
				midTex:SetHeight(18)
				midTex:SetTexCoord(0, 1, 0, 1)
				rightTex:SetAlpha(0)
				rightTex:ClearAllPoints()
				rightTex:SetPoint("LEFT", midTex, "RIGHT", -6, -2)
			end
			return frame, text, container
		end, true)
	end

	if LibStub and LibStub:GetLibrary("tekKonfig-Group", true) then
		local tKG = LibStub("tekKonfig-Group")
		self:Hook(tKG, "new", function(parent, label, ...)
			self:Debug("tKG:[%s, %s]", parent, label)
			local box = self.hooks[tKG].new(parent, label, ...)
			self:applySkin(box)
			return box
		end, true)
	end

	if LibStub and LibStub:GetLibrary("tekKonfig-AboutPanel", true) then
		local tKAP = LibStub("tekKonfig-AboutPanel")
		self:SecureHook(tKAP, "OpenEditbox", function(this)
			self:Debug("tKAP:[%s, %s]", this, tKAP.editbox)
			if not tKAP.editbox.skinned then
				tKAP.editbox:SetHeight(24)
				local l, r, t, b = tKAP.editbox:GetTextInsets()
				tKAP.editbox:SetTextInsets(l + 5, r + 5, t, b)
				self:keepFontStrings(tKAP.editbox)
				self:skinUsingBD2(tKAP.editbox)
				tKAP.editbox.skinned = true
			end
			tKAP.editbox:SetPoint("LEFT", -5, 0)
		end)
	end

end
