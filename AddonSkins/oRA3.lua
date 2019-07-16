local aName, aObj = ...
if not aObj:isAddonEnabled("oRA3") then return end
local _G = _G

aObj.addonsToSkin.oRA3 = function(self) -- v 8.2.2

	local oRA3 = _G.LibStub("AceAddon-3.0"):GetAddon("oRA3", true)

	local function skinFrame()
		aObj:skinSlider{obj=_G.oRA3ScrollFrame.ScrollBar}
		aObj:getChild(_G.oRA3ScrollFrameBottom, 1):SetAlpha(0)
		aObj:getChild(_G.oRA3ScrollFrameTop, 1):SetAlpha(0)
		-- Tabs
		aObj:skinTabs{obj=_G.oRA3Frame, lod=true}
		aObj:moveObject{obj=_G.oRA3FrameTab1, x=-2, y=3}
		aObj:addSkinFrame{obj=_G.oRA3Frame, ft="a", kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=73}
		if aObj.modBtns then
			 aObj:skinCloseButton{obj=aObj:getChild(_G.oRA3Frame, 1)}
			 aObj:skinStdButton{obj=_G.oRA3DisbandButton}
			 aObj:skinStdButton{obj=_G.oRA3CheckButton}
			 for i = 1, 5 do
				 btn = _G["oRA3ListButton" .. i]
				 if btn then
					 aObj:skinStdButton{obj=btn}
				 end
			 end
		end
	end

	-- ScrollHeaders
	self:SecureHook(oRA3, "CreateScrollEntry", function(this, header)
		-- self:Debug("oRA3 CreateScrollEntry: [%s, %s]", this, header)
		if not header.sf
		and header:GetName()
		then -- used by Tanks module as well
			self:removeRegions(header, {1, 2, 3})
			self:addSkinFrame{obj=header, ft="a", kfs=true, nb=true, x1=-2, x2=2}
		end
	end)

	self:SecureHook(oRA3, "ShowUIPanel", function(this, ...)
		skinFrame()

		self:Unhook(oRA3, "ShowUIPanel")
	end)

	-- Tanks module
	local tanks = oRA3:GetModule("Tanks", true)
	if tanks then
		self:SecureHook(tanks, "CreateFrame", function(this)
			self:skinSlider{obj=_G.oRA3TankTopScrollFrame.ScrollBar}
			self:skinSlider{obj=_G.oRA3TankBottomScrollFrame.ScrollBar}

			self:Unhook(tanks, "CreateFrame")
		end)
		tanks = nil
	end

	-- ReadyCheck Frame
	local rc = oRA3:GetModule("ReadyCheck", true)
	if rc then
		local function skinRCFrame()
			aObj:addSkinFrame{obj=_G.oRA3ReadyCheck, ft="a", kfs=true, y1=-2, x2=-1}
		end
		if _G.oRA3ReadyCheck then skinRCFrame()
		else
			self:SecureHook(rc, "READY_CHECK", function(this, ...)
				if _G.oRA3ReadyCheck then
					skinRCFrame()

					self:Unhook(rc, "READY_CHECK")
				end
			end)
		end
		rc = nil
	end

	-- the version of ACD packed with oRA3 has a tooltip
	local ACD = LibStub:GetLibrary("AceConfigDialog-3.0", true)
	if ACD
	and ACD.tooltip
	then
		-- tooltip
		_G.C_Timer.After(0.1, function()
			aObj:add2Table(aObj.ttList, ACD.tooltip)
			ACD = nil
		end)
	end

end
