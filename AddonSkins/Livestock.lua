local aName, aObj = ...
if not aObj:isAddonEnabled("Livestock") then return end

function aObj:Livestock()

	local mCnt = 5
	local lType = {["CRITTER"] = "Critter", ["LAND"] = "Land", ["FLYING"] = "Flying", ["WATER"] = "Water"}
	local function skinMenu(kind, cnt)

		local mFrame = _G["Livestock"..lType[kind].."Menu"..cnt]
		if mFrame and not aObj.skinned[mFrame] then aObj:addSkinFrame{obj=mFrame} end
		
	end
	-- hook this to handle menu rebuilds
	self:SecureHook(Livestock, "BuildMenu", function(kind)
		for i = 1, mCnt do
			skinMenu(kind, i)
		end
	end)
	
	-- main frame
	self:addSkinFrame{obj=LivestockMenuFrame}
	-- sub frames
	for i = 1, mCnt do
		for kind, _ in pairs(lType) do
			skinMenu(kind, i)
		end
	end
	-- model frame
	LivestockModel:ClearAllPoints()
	LivestockModel:SetPoint("TOP", 0, -20)
	self:addSkinFrame{obj=LivestockModelFrame}

end
