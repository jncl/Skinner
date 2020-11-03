local aName, aObj = ...
local _G = _G
-- These are Libraries

aObj.libsToSkin["tekKonfig-Button"] = function(self) -- v 5
	if self.initialized["tekKonfig-Button"] then return end
	self.initialized["tekKonfig-Button"] = true

	local tKB = _G.LibStub:GetLibrary("tekKonfig-Button", true)
	if tKB then
		self:RawHook(tKB, "new", function(...)
			local btn = self.hooks[tKB].new(...)
			self:skinStdButton{obj=btn}
			return btn
		end, true)
	end

end

aObj.libsToSkin["tekKonfig-Checkbox"] = function(self) -- v 3
	if self.initialized["tekKonfig-Checkbox"] then return end
	self.initialized["tekKonfig-Checkbox"] = true

	local tKCb = _G.LibStub:GetLibrary("tekKonfig-Checkbox", true)
	if tKCb then
		self:RawHook(tKCb, "new", function(...)
			local cBtn = self.hooks[tKCb].new(...)
			self:skinCheckButton{obj=cBtn}
			return cBtn
		end, true)
	end

end

aObj.libsToSkin["tekKonfig-Dropdown"] = function(self) -- v 3
	if self.initialized["tekKonfig-Dropdown"] then return end
	self.initialized["tekKonfig-Dropdown"] = true

	local tKDd = _G.LibStub:GetLibrary("tekKonfig-Dropdown", true)
	if tKDd then
		self:RawHook(tKDd, "new", function(...)
			local frame, text, container, labeltext = self.hooks[tKDd].new(...)
			if not self.db.profile.TexturedDD then self:keepFontStrings(frame)
			else
				local leftTex, rightTex, _, midTex = frame:GetRegions()
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
				if self.modBtnBs then
					self:addButtonBorder{obj=self:getChild(frame, 1), es=12, ofs=-2}
				end
			end
			return frame, text, container, labeltext
		end, true)
	end

end

-- tekKonfig-FadeIn

aObj.libsToSkin["tekKonfig-Group"] = function(self) -- v 2
	if self.initialized["tekKonfig-Group"] then return end
	self.initialized["tekKonfig-Group"] = true

	local tKG = _G.LibStub:GetLibrary("tekKonfig-Group", true)
	if tKG then
		self:RawHook(tKG, "new", function(...)
			local box = self.hooks[tKG].new(...)
			self:addSkinFrame{obj=box, ft="a", nb=true}
			return box
		end, true)
	end

end

-- tekKonfig-Heading
-- tekKonfig-Scroll

aObj.libsToSkin["tekKonfig-Slider"] = function(self) -- v 3
	if self.initialized["tekKonfig-Slider"] then return end
	self.initialized["tekKonfig-Slider"] = true

	local tKS = _G.LibStub:GetLibrary("tekKonfig-Slider", true)
	if tKS then
		self:RawHook(tKS, "new", function(...)
			local slider, text, container, low, high = self.hooks[tKS].new(...)
			self:skinSlider{obj=slider, size=3}
			return slider, text, container, low, high
		end, true)
		if tKS.newbare then
			self:RawHook(tKS, "newbare", function(...)
				local slider = self.hooks[tKS].newbare(...)
				self:skinSlider{obj=slider, size=3}
				return slider
			end, true)
		end
	end

end
