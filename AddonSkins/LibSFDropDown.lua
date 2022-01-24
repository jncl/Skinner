local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibSFDropDown-1.3"] = function(self) -- v LibSFDropDown-1.3, 1
	if self.initialized.LibSFDropDown then return end
	self.initialized.LibSFDropDown = true

	local lSFdd = _G.LibStub:GetLibrary("LibSFDropDown-1.3", true)

	if lSFdd then
		for _, menu in lSFdd:IterateMenus() do
			self:skinObject("frame", {obj=menu.styles.backdrop, kfs=true})
			self:skinObject("frame", {obj=menu.styles.menuBackdrop, kfs=true})
		end
		lSFdd._v.menuStyles.backdrop = function(parent)
			local frame = _G.CreateFrame("FRAME", nil, parent, "DialogBorderDarkTemplate")
			aObj:skinObject("frame", {obj=frame, kfs=true})
			return frame
		end
		lSFdd._v.menuStyles.menuBackdrop = function(parent)
			local frame = _G.CreateFrame("FRAME", nil, parent, "TooltipBackdropTemplate")
			aObj:skinObject("frame", {obj=frame, kfs=true})
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
		local function skinStretchBtn(btn)
			if aObj.modBtns then
				aObj:skinStdButton{obj=btn}
			end
		end
		for _, btn in lSFdd:IterateCreatedStretchButtons() do
			skinStretchBtn(btn)
		end
		self:RawHook(lSFdd, "CreateStretchButtonOriginal", function(this, parent, width, height, wrap)
			local btn = self.hooks[this].CreateStretchButtonOriginal(this, parent, width, height, wrap)
			skinStretchBtn(btn)
			return btn
		end, true)
	end

end
