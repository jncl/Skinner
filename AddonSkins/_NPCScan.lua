local aName, aObj = ...
if not aObj:isAddonEnabled("_NPCScan") then return end

function aObj:_NPCScan()

-->>-- NPC Alert Button
	self:getRegion(_NPCScanButton, 4):SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_NPCScanButton, kfs=true, nb=true}
	self:skinButton{obj=self:getChild(_NPCScanButton, 2), cb=true}
	_NPCScanButton.SetBackdropBorderColor = function() end

-->>-- Config settings
	self:skinDropDown{obj=_NPCScanConfigSoundDropdown, x2=-6}
	self:addSkinFrame{obj=_NPCScanConfigAlert}

-->>-- Search Frame
	self:skinEditBox{obj=_NPCScanSearchNpcName, regs={9}}
	self:skinEditBox{obj=_NPCScanSearchNpcID, regs={9}}
	self:skinEditBox{obj=_NPCScanSearchNpcWorld, regs={9}}
	self:addSkinFrame{obj=_NPCScan.Config.Search.TableContainer, ofs=4}

	--hook this to skin slider
	local function hookAndSkin()

		local obj = _NPCScan.Config.Search.Table.View
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
	if not _NPCScan.Config.Search.Table then
		self:SecureHookScript(_NPCScan.Config.Search, "OnShow", function(this)
			hookAndSkin()
			self:Unhook(_NPCScan.Config.Search, "OnShow")
		end)
	else
		hookAndSkin()
	end

end
