local aName, aObj = ...
if not aObj:isAddonEnabled("Livestock") then return end
local _G = _G

function aObj:Livestock()

	local mCnt = 4
	local lType = {["CRITTER"] = "Critter", ["LAND"] = "Land", ["FLYING"] = "Flying", ["WATER"] = "Water"}
	local function skinMenu(kind)

		kind = _G.string.upper(kind)
		local mFrame = _G["Livestock" .. lType[kind] .. "Menu"]
		if mFrame
		and not mFrame.sf
		then
			aObj:skinScrollBar{obj=_G["Livestock" .. lType[kind] .. "MenuScrollFrame"]}
			aObj:addSkinFrame{obj=mFrame}
		end
		
	end
	-- hook this to handle menu rebuilds
	self:SecureHook(_G.Livestock, "BuildMenu", function(kind)
		skinMenu(kind)
	end)
	
	-- main frame
	aObj:skinButton{obj=_G.LivestockMenuFrameClose, cb=true}
	self:addSkinFrame{obj=_G.LivestockMenuFrame}
	-- sub frames
	for kind, _ in _G.pairs(lType) do
		skinMenu(kind)
	end
	-- model frame
	_G.LivestockModel:ClearAllPoints()
	_G.LivestockModel:SetPoint("TOP", 0, -20)
	self:addSkinFrame{obj=_G.LivestockModelFrame}

end
