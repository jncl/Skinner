local aName, aObj = ...
if not aObj:isAddonEnabled("_NPCScan") then return end
local _G = _G

function aObj:_NPCScan()

-->>-- NPC Alert Button
	self:getRegion(_G._NPCScanButton, _G._NPCScanButton:GetNumRegions() - 1):SetTextColor(self.BTr, self.BTg, self.BTb) -- subtitle
	self:addSkinFrame{obj=_G._NPCScanButton, kfs=true, nb=true}
	self:skinButton{obj=self:getChild(_G._NPCScanButton, 1), cb=true}
	_G._NPCScanButton.SetBackdropBorderColor = function() end

-->>-- Config settings
	self:skinDropDown{obj=_G._NPCScanConfigSoundDropdown, x2=-6}
	self:addSkinFrame{obj=_G._NPCScanConfigAlert}

-->>-- Search Frame
	self:skinEditBox{obj=_G._NPCScanSearchNpcNameEditBox, regs={9}}
	self:skinEditBox{obj=_G._NPCScanSearchNpcIDEditBox, regs={9}}
	self:skinEditBox{obj=_G._NPCScanSearchNpcWorldEditBox, regs={9}}
	self:addSkinFrame{obj=_G._NPCScan.Config.Search.table_container, ofs=4}

	--hook this to skin slider
	local function hookAndSkin()

		local obj = _G._NPCScan.Config.Search.table.View
		if not aObj:getChild(obj, 2) then -- if not already created
			aObj:SecureHookScript(obj, "OnScrollRangeChanged", function(this)
				aObj:ShowInfo(this, true, true)
				aObj:skinSlider(aObj:getChild(this, 2))
				aObj:Unhook(obj, "OnScrollRangeChanged")
			end)
		else
			aObj:skinSlider(aObj:getChild(obj, 2))
		end

	end
	if not _G._NPCScan.Config.Search.table then
		self:SecureHookScript(_G._NPCScan.Config.Search, "OnShow", function(this)
			hookAndSkin()
			self:Unhook(_G._NPCScan.Config.Search, "OnShow")
		end)
	else
		hookAndSkin()
	end

end
