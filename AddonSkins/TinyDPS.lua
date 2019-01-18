local aName, aObj = ...
if not aObj:isAddonEnabled("TinyDPS") then return end
local _G = _G

aObj.addonsToSkin.TinyDPS = function(self) -- v 8.0.1.1

	-- main frame
	self:addSkinFrame{obj=_G.tdpsFrame, ft="a", nb=true, ofs=2, aso={ng=true}} -- no gradient (Animation)

	local function skinSBs()

		for _, child in _G.ipairs{_G.tdpsFrame:GetChildren()} do
			if child:IsObjectType("StatusBar") then
				child:SetBackdrop(nil)
				child:SetStatusBarTexture(aObj.sbTexture)
				child.bg = child:CreateTexture(nil, "BACKGROUND")
				child.bg:SetTexture(aObj.sbTexture)
				child.bg:SetVertexColor(aObj.sbClr:GetRGBA())
			end
		end

	end
	-- add a metatable to the Player table so that new bars can be skinned
	if _G.tdpsPlayer then
		local mt = {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			_G.C_Timer.After(0.1, skinSBs)	-- wait for bar to be created before skinning it
		end}
		-- hook this as it is used when the tables are reset
		self:SecureHook(_G.noData, "Show", function(this)
			_G.setmetatable(_G.tdpsPlayer, mt)
		end)
	end
	-- skin any existing StatusBars
	skinSBs()

	-- minimap button
	self.mmButs["TinyDPS"] = _G.tdpsButtonFrame

end
