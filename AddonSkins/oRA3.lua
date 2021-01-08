local _, aObj = ...
if not aObj:isAddonEnabled("oRA3") then return end
local _G = _G

aObj.addonsToSkin.oRA3 = function(self) -- v 9.0.12

	local oRA3 = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("oRA3", true)

	self:SecureHook(oRA3, "ShowUIPanel", function(this, ...)
		self:skinObject("slider", {obj=_G.oRA3ScrollFrame.ScrollBar})
		self:getChild(_G.oRA3ScrollFrameTop, 1):SetAlpha(0) -- bar texture
		self:getChild(_G.oRA3ScrollFrameBottom, 1):SetAlpha(0) -- bar texture
		self:skinObject("tabs", {obj=_G.oRA3Frame, prefix=_G.oRA3Frame:GetName(), numTabs=5, lod=true})
		self:moveObject{obj=_G.oRA3FrameTab1, x=-2, y=3}
		self:skinObject("frame", {obj=_G.oRA3Frame, kfs=true, x1=10, y1=-11, x2=-33, y2=73})
		if self.modBtns then
			 self:skinCloseButton{obj=aObj:getChild(_G.oRA3Frame, 1)}
			 self:skinStdButton{obj=_G.oRA3DisbandButton}
			 self:SecureHook(_G.oRA3DisbandButton, "Disable", function(this, _)
			 	self:clrBtnBdr(this)
			 end)
			 self:SecureHook(_G.oRA3DisbandButton, "Enable", function(this, _)
			 	self:clrBtnBdr(this)
			 end)
			 self:skinStdButton{obj=_G.oRA3CheckButton}
			 self:SecureHook(_G.oRA3CheckButton, "Disable", function(this, _)
			 	self:clrBtnBdr(this)
			 end)
			 self:SecureHook(_G.oRA3CheckButton, "Enable", function(this, _)
			 	self:clrBtnBdr(this)
			 end)
			 for i = 1, 5 do
				 btn = _G["oRA3ListButton" .. i]
				 if btn then
					 self:skinStdButton{obj=btn}
				 end
			 end
		end

		self:Unhook(oRA3, "ShowUIPanel")
	end)

	self:SecureHook(oRA3, "CreateScrollEntry", function(this, header)
		if not header.sf
		and header:GetName()
		then -- used by Tanks module as well
			self:removeRegions(header, {1, 2, 3})
			self:skinObject("frame", {obj=header, kfs=true, x1=-2, x2=2})
		end
	end)

	local tanks = oRA3:GetModule("Tanks", true)
	if tanks then
		self:SecureHook(tanks, "CreateFrame", function(this)
			self:getChild(_G.oRA3TankTopScrollFrame:GetParent(), 1):SetAlpha(0) -- centerBar texture
			if self:getChild(_G.oRA3TankTopScrollFrame:GetParent(), 2):IsObjectType("Button") then
				self:getChild(_G.oRA3TankTopScrollFrame:GetParent(), 2):SetAlpha(0) -- topBar texture
			end
			self:skinObject("slider", {obj=_G.oRA3TankTopScrollFrame.ScrollBar})
			self:skinObject("slider", {obj=_G.oRA3TankBottomScrollFrame.ScrollBar})

			self:Unhook(tanks, "CreateFrame")
		end)
		tanks = nil
	end

	local rc = oRA3:GetModule("ReadyCheck", true)
	if rc then
		local function skinRCFrame()
			aObj:skinObject("frame", {obj=_G.oRA3ReadyCheck, kfs=true, cb=true, y1=-2, x2=-1})
		end
		if _G.oRA3ReadyCheck then
			skinRCFrame()
		else
			self:SecureHook(rc, "READY_CHECK", function(this, _)
				if _G.oRA3ReadyCheck then
					skinRCFrame()

					self:Unhook(rc, "READY_CHECK")
				end
			end)
		end
		rc = nil
	end

	local cooldowns = oRA3:GetModule("Cooldowns", true)
	if cooldowns then
		cooldowns.db.profile.displays.Default.barColor = {self.sbClr:GetRGBA()}
		cooldowns.db.profile.displays.Default.barTexture = self.prdb.StatusBar.texture
		cooldowns = nil
	end

end
