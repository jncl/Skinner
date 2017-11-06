local aName, aObj = ...
local _G = _G
-- This is a Framework

local allHooked
aObj.otherAddons.tekKonfig = function(self) -- v1-Beta
	if not self.db.profile.MenuFrames then return end

	if allHooked then return end

	local tKAP = tKAP or _G.LibStub:GetLibrary("tekKonfig-AboutPanel", true)
	if tKAP then
		self:secureHook(tKAP, "OpenEditbox", function(this)
			if not tKAP.editbox.sknd then
				tKAP.editbox.sknd = true
				tKAP.editbox:SetHeight(24)
				local l, r, t, b = tKAP.editbox:GetTextInsets()
				tKAP.editbox:SetTextInsets(l + 5, r + 5, t, b)
				self:keepFontStrings(tKAP.editbox)
				self:skinUsingBD2(tKAP.editbox)
			end
			tKAP.editbox:SetPoint("LEFT", -5, 0)
		end)
	end

	local tKB = tKB or _G.LibStub:GetLibrary("tekKonfig-Button", true)
	if tKB then
		self:rawHook(tKB, "new", function(parent, ...)
			local btn = self.hooks[tKB].new(parent, ...)
			self:skinStdButton{obj=btn}
			return btn
		end)
	end

	local tKCb = tKCb or _G.LibStub:GetLibrary("tekKonfig-Checkbox", true)
	if tKCb then
		self:rawHook(tKCb, "new", function(parent, size, label, ...)
			local cBtn = self.hooks[tKCb].new(parent, size, label, ...)
			self:skinCheckButton{obj=cBtn}
			return cBtn
		end, true)
	end

	local tKDd = tKDd or _G.LibStub:GetLibrary("tekKonfig-Dropdown", true)
	if tKDd then
		self:rawHook(tKDd, "new", function(parent, label, ...)
			local frame, text, container, labeltext = self.hooks[tKDd].new(parent, label, ...)
			if not self.db.profile.TexturedDD then self:keepFontStrings(frame)
			else
				local leftTex, rightTex, icon, midTex = frame:GetRegions()
				leftTex:SetAlpha(0)
				midTex:SetTexture(self.itTex)
				midTex:SetPoint("LEFT", leftTex, "RIGHT", -5, 1)
				midTex:SetPoint("RIGHT", rightTex, "LEFT", 5, 1)
				midTex:SetHeight(18)
				midTex:SetTexCoord(0, 1, 0, 1)
				rightTex:SetAlpha(0)
			end
			if self.db.profile.DropDownButtons then
				self:addSkinFrame{obj=frame, ft="a", aso={ng=true}, nb=true, x1=16, y1=-1, x2=-15, y2=5}
				self:addButtonBorder{obj=self:getChild(frame, 1), es=12, ofs=-2}
			end
			return frame, text, container, labeltext
		end, true)
	end

	-- tekKonfig-FadeIn

	local tKG = tKG or _G.LibStub:GetLibrary("tekKonfig-Group", true)
	if tKG then
		self:rawHook(tKG, "new", function(parent, label, ...)
			local box = self.hooks[tKG].new(parent, label, ...)
			self:addSkinFrame{obj=box, ft="a", nb=true}
			return box
		end, true)
	end

	-- tekKonfig-Heading
	-- tekKonfig-Scroll

	local tKS = tKS or _G.LibStub:GetLibrary("tekKonfig-Slider", true)
	if tKS then
		self:rawHook(tKS, "new", function(parent, label, lowvalue, highvalue, ...)
			local slider, text, container, low, high = self.hooks[tKS].new(parent, label, lowvalue, highvalue, ...)
			self:skinSlider{obj=slider, size=3}
			return slider, text, container, low, high
		end, true)
		if tKS.newbare then
			self:rawHook(tKS, "newbare", function(parent, ...)
				local slider = self.hooks[tKS].newbare(parent, ...)
				self:skinSlider{obj=slider, size=3}
				return slider
			end, true)
		end
	end

	-- tekKonfig-TopTab

	if tKAP and tKB and tKCb and tKDd and tKG and tKS then allHooked = true end

end
