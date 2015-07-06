local aName, aObj = ...
if not aObj:isAddonEnabled("BaudBag") then return end
local _G = _G

function aObj:BaudBag()
	if not self.db.profile.ContainerFrames.skin then return end

	-- hook this to skin the bag frames
	self:SecureHook("BaudBagUpdateContainer", function(Container)
		local frame = Container:GetName()
		_G[frame .. "BackdropTextures"]:Hide()
		if not _G[frame .. "Backdrop"].sknd then
			self:skinButton{obj=_G[frame .. "MenuButton"], mp=true, plus=true}
			self:skinAllButtons{obj=Container}
			self:addSkinFrame{obj=_G[frame .. "Backdrop"], nb=true}
			-- hook this to skin the Search Frame
			self:SecureHookScript(_G[frame .. "SearchButton"], "OnClick", function(this, ...)
				if not _G.BaudBagSearchFrameBackdrop.sknd then
					self:skinEditBox{obj=_G.BaudBagSearchFrameEditBox, regs={9}, noHeight=true}
					self:adjHeight{obj=_G.BaudBagSearchFrameEditBox, adj=10}
					self:skinButton{obj=_G.BaudBagSearchFrameCloseButton, cb=true}
					self:addSkinFrame{obj=_G.BaudBagSearchFrameBackdrop, y1=1, y2=25}
				end
				_G.BaudBagSearchFrameEditBox:SetPoint("TOPLEFT", -3, 23)
				self:keepFontStrings(_G.BaudBagSearchFrameBackdropTextures)
			end)
		end
	end)
	self:skinDropDown{obj=_G.BaudBagContainerDropDown, x2=-10}
	self:addSkinFrame{obj=_G.BaudBagContainer1_1BagsFrame}
	self:addSkinFrame{obj=_G.BaudBagContainer2_1BagsFrame}

-->>-- Options Frame
	self:skinDropDown{obj=_G.BaudBagOptionsSetDropDown, x2=-10}
	self:skinEditBox(_G.BaudBagOptionsNameEditBox, {9})
	self:skinDropDown{obj=_G.BaudBagOptionsBackgroundDropDown, x2=-10}

end
