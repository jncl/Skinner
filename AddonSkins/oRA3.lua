local aName, aObj = ...
if not aObj:isAddonEnabled("oRA3") then return end
local _G = _G

function aObj:oRA3()-- last tested with r623

	local oRA3 = _G.LibStub("AceAddon-3.0"):GetAddon("oRA3", true)

	-- hook this to manage textured tabs
	if self.isTT then
		self:SecureHook(oRA3, "SelectPanel", function(this, name)
			-- self:Debug("SP: [%s, %s, %s]", this, name, _G.oRA3Frame.selectedTab)
			for i = 1, _G.oRA3Frame.numTabs do
				local tabSF = _G["oRA3FrameTab" .. i].sf
				if i == _G.oRA3Frame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	local function skinFrame()

		aObj:addSkinFrame{obj=_G.oRA3Frame, kfs=true, x1=10 , y1=-11, x2=-33, y2=73}

		aObj:skinScrollBar{obj=_G.oRA3ScrollFrame}
		aObj:getChild(_G.oRA3ScrollFrameBottom, 1):SetAlpha(0)
		aObj:getChild(_G.oRA3ScrollFrameTop, 1):SetAlpha(0)

		-- ScrollHeaders
		aObj:SecureHook(oRA3, "CreateScrollEntry", function(this, header)
			if not header.sf and header:GetName() then -- used by Tanks module as well
				aObj:removeRegions(header, {1, 2, 3})
				aObj:addSkinFrame{obj=header}
			end
		end)

		-- Tabs
		aObj:skinTabs{obj=_G.oRA3Frame}
		aObj.tabFrames[_G.oRA3Frame] = nil -- don't handle tabs automatically
		aObj:moveObject{obj=_G.oRA3FrameTab1, x=-2, y=2}

	end

	self:SecureHook(oRA3, "ToggleFrame", function(this, ...)
		skinFrame()
		self:Unhook(oRA3, "ToggleFrame")
	end)

-->-- Tanks module
	local tanks = oRA3:GetModule("Tanks", true)
	if tanks then
		self:SecureHook(tanks, "CreateFrame", function(this)
			self:skinScrollBar{obj=_G.oRA3TankTopScrollFrame}
			self:skinScrollBar{obj=_G.oRA3TankBottomScrollFrame}
			self:Unhook(tanks, "CreateFrame")
		end)
	end

-->>-- ReadyCheck Frame
	local rc = oRA3:GetModule("ReadyCheck", true)
	if rc then
		local function skinRCFrame()

			aObj:addSkinFrame{obj=_G.oRA3ReadyCheck, kfs=true, y1=-2, x2=-1}

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
	end

end
