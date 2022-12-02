local _, aObj = ...
if not aObj:isAddonEnabled("Healium") then return end
local _G = _G

aObj.addonsToSkin.Healium = function(self) -- v 2.9.8/2.8.14Classic/2.8.15BC

	-- UnitFrames
	for _, fName in _G.pairs{"Party", "Pet", "Me", "Friends", "Damagers", "Healers", "Tanks", "Target"} do
		self:skinObject("frame", {obj=_G["Healium" .. fName .. "Frame"].CaptionBar, kfs=true, cbns=true, ofs=0})
	end
	for i = 1, 8 do
		self:skinObject("frame", {obj=_G["HealiumGroup" .. i .. "Frame"].CaptionBar, kfs=true, cbns=true, ofs=0})
	end

	self.mmButs["Healium"] = _G.HealiumMiniMap
	_G.HealiumMiniMap.icon:SetSize(18, 18)
	_G.HealiumMiniMap:SetSize(24, 24)

	-- Code to skin DropDowns, taken from LibUIDropDownMenu skin
	local function skinDDL(frame)
		if frame
		and not frame.sf then
			if frame.Border then
				aObj:removeBackdrop(frame.Border)
			end
			aObj:removeBackdrop(_G[frame:GetName() .. "MenuBackdrop"])
			aObj:skinObject("frame", {obj=frame, ofs=-4})
		end
	end

	local function skinDropDowns()
		local ddPrefix = "Lib_DropDownList"
		if _G[ddPrefix .. 1] then
			skinDDL(_G[ddPrefix .. 1])
		end
		if _G[ddPrefix .. 2] then
			skinDDL(_G[ddPrefix .. 2])
		end
		aObj:SecureHook("Lib_UIDropDownMenu_CreateFrames", function(level, _)
			for i = 1, level do
				skinDDL(_G[ddPrefix .. i])
			end
		end)
	end

	skinDropDowns()

end
