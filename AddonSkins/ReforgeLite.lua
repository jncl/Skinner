local aName, aObj = ...
if not aObj:isAddonEnabled("ReforgeLite") then return end

function aObj:ReforgeLite()

	local function checkTexture(self)
		if self:GetParent().expanded then
			self:SetText(aObj.modUIBtns.minus)
		else
			self:SetText(aObj.modUIBtns.plus)
		end
	end
	local function skinDropDown(obj)
		aObj:skinDropDown{obj=obj, rp=true, y1=7, y2=13}
		obj.ddTex:SetHeight(16)
		_G[obj:GetName().."Button"]:SetPoint ("TOPRIGHT", _G[obj:GetName().."Right"], "TOPRIGHT", -17, -12)
	end

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

	-- Main frame
	self:skinSlider{obj=ReforgeLite.scrollBar}
	ReforgeLite.scrollBg:SetTexture(nil)
	ReforgeLite.scrollFrame:SetPoint ("BOTTOMRIGHT", ReforgeLite, "BOTTOMRIGHT", -26, 15)
	self:addSkinFrame{obj=ReforgeLite, bas=true, y1=-8}
	-- Content Frame
	self:skinAllButtons{obj=ReforgeLite.content, as=true}
	local bType, oTex
	local function skinChildren(obj)
		
		for _, child in ipairs{obj:GetChildren()} do
			if self:isDropDown(child) then
				skinDropDown(child)
			elseif child:IsObjectType("EditBox") then
				self:skinEditBox{obj=child}
			elseif child:IsObjectType("Button") then
				bType, oTex = self:isButton(child)
				if bType == "mp" then
					self:skinButton{obj=child, mp2=true, as=true, plus=oTex:find("Plus") and true or nil}
					if child.UpdateTexture then
						child.UpdateTexture = checkTexture
					end
				end
			elseif child:IsObjectType("Frame") then
				skinChildren(child)
			end
		end
	end
	skinChildren(ReforgeLite.content)
	
	-- Calculate Method subframe
	self:SecureHook(ReforgeLite, "UpdateMethodCategory", function(this)
		self:skinButton{obj=ReforgeLite.methodCategory.button, mp=true}
		self:skinButton{obj=ReforgeLiteMethodShowButton}
		self:skinButton{obj=ReforgeLiteMethodResetButton}
		self:Unhook(ReforgeLite, "UpdateMethodCategory")
	end)
	-- Output Frame
	self:SecureHook(ReforgeLite, "ShowMethodWindow", function(this)
		self:addSkinFrame{obj=ReforgeLite.methodWindow, y1=-8}
		self:Unhook(ReforgeLite, "ShowMethodWindow")
	end)
	
end
