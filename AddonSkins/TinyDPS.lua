local aName, aObj = ...
if not aObj:isAddonEnabled("TinyDPS") then return end
local _G = _G

-- minimap button
aObj.mmButs["TinyDPS"] = _G.tdpsButtonFrame

function aObj:TinyDPS()

	-- main frame
	self:addSkinFrame{obj=_G.tdpsFrame, ofs=2, aso={ng=true}} -- no gradient (Animation)

	local function skinSBs()

		for _, child in ipairs{_G.tdpsFrame:GetChildren()} do
			if child:IsObjectType("StatusBar") then
				child:SetBackdrop(nil)
				child:SetStatusBarTexture(aObj.sbTexture)
				child.bg = child:CreateTexture(nil, "BACKGROUND")
				child.bg:SetTexture(aObj.sbTexture)
				child.bg:SetVertexColor(aObj.sbColour[1], aObj.sbColour[2], aObj.sbColour[3], aObj.sbColour[4])
			end
		end

	end
	-- add a metatable to the Player table so that new bars can be skinned
	if _G.tdpsPlayer then
		local mt = {__newindex = function(t, k, v)
			rawset(t, k, v)
			_G.C_Timer.After(0.1, skinSBs)	-- wait for bar to be created before skinning it
		end}
		-- hook this as it is used when the tables are reset
		self:SecureHook(_G.noData, "Show", function(this)
			setmetatable(_G.tdpsPlayer, mt)
		end)
	end
	-- skin any existing StatusBars
	skinSBs()

end
