local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibSFDropDown-1.4"] = function(self) -- v LibSFDropDown-1.4, 5
	if self.initialized.LibSFDropDown then return end
	self.initialized.LibSFDropDown = true

	local lSFdd = _G.LibStub:GetLibrary("LibSFDropDown-1.4", true)

	if lSFdd then
		for _, menu in lSFdd:IterateMenus() do
			self:skinObject("frame", {obj=menu.styles.backdrop, kfs=true})
			self:skinObject("frame", {obj=menu.styles.menuBackdrop, kfs=true, rns=true})
		end
		lSFdd._v.menuStyles.backdrop = function(parent)
			aObj:Debug("backdrop: [%s, %s]", parent)
			local frame = _G.CreateFrame("FRAME", nil, parent, "DialogBorderDarkTemplate")
			aObj:skinObject("frame", {obj=frame, kfs=true})
			return frame
		end
		lSFdd._v.menuStyles.menuBackdrop = function(parent)
			aObj:Debug("menuBackdrop: [%s, %s]", parent)
			local frame = _G.CreateFrame("FRAME", nil, parent, "TooltipBackdropTemplate")
			aObj:skinObject("frame", {obj=frame, kfs=true, rns=true})
			return frame
		end
		local function skinSearchFrame(frame)
			aObj:skinObject("editbox", {obj=frame.searchBox, si=true})
			aObj:skinObject("slider", {obj=frame.listScroll.scrollBar, rpTex="background"})
		end
		for _, frame in lSFdd:IterateSearchFrames() do
			skinSearchFrame(frame)
		end
		_G.setmetatable(lSFdd._v.dropDownSearchFrames, {__newindex = function(tab, key, frame)
			_G.rawset(tab, key, frame)
			skinSearchFrame(frame)
		end})
		self:RawHook(lSFdd, "CreateButtonOriginal", function(this, parent, width)
			local btn = self.hooks[this].CreateButtonOriginal(this, parent, width)
			self:skinObject("dropdown", {obj=btn, x1=1, y1=2, x2=-1, y2=0})
			return btn
		end, true)
		if self.modBtns then
			local function skinStretchBtn(btn)
				aObj:skinStdButton{obj=btn, clr="grey"}
			end
			for _, btn in lSFdd:IterateCreatedStretchButtons() do
				skinStretchBtn(btn)
			end
			self:RawHook(lSFdd, "CreateStretchButtonOriginal", function(this, ...)
				local btn = self.hooks[this].CreateStretchButtonOriginal(this, ...)
				skinStretchBtn(btn)
				return btn
			end, true)
		end
	end

end
