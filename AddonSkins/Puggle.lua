local aName, aObj = ...
if not aObj:isAddonEnabled("Puggle") then return end
local _G = _G

aObj.addonsToSkin.Puggle = function(self) -- v 1.5

	self:SecureHookScript(_G.myTabContainerFrame, "OnShow", function(this)
		self:skinTabs{obj=_G.myTabContainerFrame, ignore=true}
		self:skinSlider{obj=_G.Puggle_ScrollFrame.ScrollBar}--, rt="artwork", wdth=-4, size=3, hgt=-10}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, hdr=true, y1=4, y2=-3}
		if self.modBtns then
			self:skinCloseButton{obj=_G.myTabContainerFrame_closeButton}
			local function skinBtns()
				for _, toon in ipairs{_G.Puggle_ScrollChildFrame:GetChildren()} do
					if toon:GetNumChildren() == 2 then
						aObj:skinStdButton{obj=self:getChild(toon, 2), ofs=0}
					end
				end
			end
			self:SecureHook("Puggle_UpdateList", function()
				skinBtns()
			end)
			skinBtns()
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.logoIcon}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.myTabPage2_showMinimapButton}
			self:skinCheckButton{obj=_G.myTabPage2_showMessageOnNewRequest}
			self:skinCheckButton{obj=_G.myTabPage2_playSoundOnNewRequest}
			self:skinCheckButton{obj=_G.myTabPage2_showLevelColorCoding}
			self:skinCheckButton{obj=_G.myTabPage2_showOnlyRelevant}
		end

		self:Unhook(this, "OnShow")
	end)

	self.mmButs["Puggle"] = _G.Puggle_MinimapButton

end
