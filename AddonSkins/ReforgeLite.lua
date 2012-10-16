local aName, aObj = ...
if not aObj:isAddonEnabled("ReforgeLite") then return end

function aObj:ReforgeLite()

	local function checkTexture(this)
		if this:GetParent().expanded then
			aObj.sBtn[this]:SetText(aObj.modUIBtns.minus)
		else
			aObj.sBtn[this]:SetText(aObj.modUIBtns.plus)
		end
	end
	local function skinDropDown(obj)
		aObj:skinDropDown{obj=obj, rp=true, y1=7, y2=13}
		if obj.ddTex then obj.ddTex:SetHeight(16) end
		_G[obj:GetName().."Button"]:SetPoint ("TOPRIGHT", _G[obj:GetName().."Right"], "TOPRIGHT", -17, -12)
	end
	local bType, oTex

	-- hook this to skin editboxes
	self:RawHook(ReforgeLiteGUI, "CreateEditBox", function(this, ...)
		local eb = self.hooks[this].CreateEditBox(this, ...)
		self:skinEditBox{obj=eb}
		return eb
	end, true)
	-- hook this to skin dropdowns
	self:RawHook(ReforgeLiteGUI, "CreateDropdown", function(this, ...)
		local dd = self.hooks[this].CreateDropdown(this, ...)
		skinDropDown(dd)
		return dd
	end, true)

	self:SecureHook(ReforgeLite, "Show", function(this)
		-- Main frame
		self:skinSlider{obj=ReforgeLite.scrollBar}
		ReforgeLite.scrollBg:SetTexture(nil)
		ReforgeLite.scrollFrame:SetPoint ("BOTTOMRIGHT", ReforgeLite, "BOTTOMRIGHT", -26, 15)
		self:addSkinFrame{obj=ReforgeLite, nb=true, y1=-8}
		self:skinButton{obj=ReforgeLite.close, cb=true}
		-- Content Frame
		self:skinAllButtons{obj=ReforgeLite.content, as=true}
		self:skinButton{obj=ReforgeLite.statWeightsCategory.button, mp=true}
		ReforgeLite.statWeightsCategory.button.UpdateTexture = checkTexture
		self:skinButton{obj=ReforgeLite.settingsCategory.button, mp=true, plus=true}
		ReforgeLite.settingsCategory.button.UpdateTexture = checkTexture
		self:skinButton{obj=ReforgeLite.task.caps[1].add, mp2=true, as=true, plus=true}
		self:skinButton{obj=ReforgeLite.task.caps[2].add, mp2=true, as=true, plus=true}
		self:Unhook(ReforgeLite, "Show")
	end)

	-- Calculate Method subframe
	self:SecureHook(ReforgeLite, "UpdateMethodCategory", function(this)
		self:skinButton{obj=ReforgeLite.methodCategory.button, mp=true}
		ReforgeLite.methodCategory.button.UpdateTexture = checkTexture
		self:skinButton{obj=ReforgeLiteMethodShowButton, as=true}
		self:skinButton{obj=ReforgeLiteMethodResetButton, as=true}
		self:Unhook(ReforgeLite, "UpdateMethodCategory")
	end)
	-- Output Frame
	self:SecureHook(ReforgeLite, "ShowMethodWindow", function(this)
		self:addSkinFrame{obj=ReforgeLite.methodWindow, y1=-8}
		self:Unhook(ReforgeLite, "ShowMethodWindow")
	end)

	-- Debug frame
	self:skinSlider{obj=ReforgeLiteErrorFrameScroll.ScrollBar, size=3}
	self:addSkinFrame{obj=ReforgeLiteErrorFrame}

end
