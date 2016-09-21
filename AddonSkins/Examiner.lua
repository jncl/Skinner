local aName, aObj = ...
if not aObj:isAddonEnabled("Examiner") then return end
local _G = _G

function aObj:Examiner()
	if not self.db.profile.InspectUI then return end

	-- this is used to add a texture to the dropdown
	local function textureDD(dd)

		aObj:keepFontStrings(dd)
		if aObj.db.profile.TexturedDD then
			dd.ddTex = dd:CreateTexture(nil, "BORDER")
			dd.ddTex:SetTexture(aObj.itTex)
			dd.ddTex:ClearAllPoints()
			dd.ddTex:SetPoint("TOPLEFT", dd, "TOPLEFT", 0, -2)
			dd.ddTex:SetPoint("BOTTOMRIGHT", dd, "BOTTOMRIGHT", -3, 3)
		end
		if aObj.db.profile.DropDownButtons then
			aObj:addSkinFrame{obj=dd, aso={ng=true}, ofs=1, x1=-2}
		end
		-- add a button border around the dd button
		aObj:addButtonBorder{obj=dd.button, es=12, ofs=-2}

	end

	-- hook this to skin the dropdown menu (also used by TipTac skin)
	if not self:IsHooked(_G.AzDropDown, "ToggleMenu") then
		self:SecureHook(_G.AzDropDown, "ToggleMenu", function(this, ...)
			self:skinScrollBar{obj=_G["AzDropDownScroll" .. _G.AzDropDown.vers]}
			self:addSkinFrame{obj=_G["AzDropDownScroll" .. _G.AzDropDown.vers]:GetParent()}
			self:Unhook(_G.AzDropDown, "ToggleMenu")
		end)
	end

	self:removeRegions(_G.Examiner, {1, 5, 6, 7, 8}) -- N.B. other regions are text or background
	self:addSkinFrame{obj=_G.Examiner, x1=10, y1=-11, x2=-33}
	self:skinButton{obj=self:getChild(_G.Examiner, 1), cb=true}

	-- skin sub frames
	for k, mod in pairs(_G.Examiner.modules) do
		-- self:Debug("Examiner.modules: [%d, %s, %s]", k, mod.token, mod.page or "nil")
		if mod.page then
			if     mod.token == "More" then
			elseif mod.token == "ItemSlots" then
			elseif mod.token == "Config" then
				self:SecureHookScript(mod.page, "OnShow", function(this)
					textureDD(self:getChild(this, 1))
					self:Unhook(mod.page, "OnShow")
				end)
			elseif mod.token == "Cache" then
			elseif mod.token == "Stats" then
				self:SecureHookScript(mod.page, "OnShow", function(this)
					for i = 1, 5 do
						local resist = self:getChild(this, i)
						resist:SetSize(32, 32)
						self:addButtonBorder{obj=resist, ofs=1, x1=1}
					end
					self:Unhook(mod.page, "OnShow")
				end)
			elseif mod.token == "PvP" then
			elseif mod.token == "Feats" then
				self:SecureHookScript(mod.page, "OnShow", function(this)
					textureDD(self:getChild(this, 1))
					self:Unhook(mod.page, "OnShow")
				end)
			elseif mod.token == "Talent" then
			elseif mod.token == "Gear" then
			elseif mod.token == "Items" then
			elseif mod.token == "Guild" then
			end
			if mod.scroll then self:skinScrollBar{obj=mod.scroll} end
			if mod.token ~= "Talent" or mod.token ~= "Stats" then self:addSkinFrame{obj=mod.page} end
		end
	end

end
