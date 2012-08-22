local aName, aObj = ...
if not aObj:isAddonEnabled("ScrollMaster") then return end

function aObj:ScrollMaster()

	-- Scan button
	local Scan = LibStub("AceAddon-3.0"):GetAddon("ScrollMaster"):GetModule("Scan")
	if Scan then
		self:SecureHook(Scan, "ShowScanButton", function(this)
			if Scan.scanButtonFrame then
				self:skinButton{obj=self:getChild(Scan.scanButtonFrame, 1)}
				self:Unhook(scan, "ShowScanButton")
			end
		end)
	end

	-- Crafting Frame
	local Enchanting = LibStub("AceAddon-3.0"):GetAddon("ScrollMaster"):GetModule("Enchanting")
	if Enchanting then
		self:SecureHook(Enchanting, "Create", function(this)
			self:skinScrollBar{obj=Enchanting.frame.scroll}
			self:addSkinFrame{obj=Enchanting.frame, ofs=-2}
			self:Unhook(Enchanting, "Create")
		end)
	end

end
