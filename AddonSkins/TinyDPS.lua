if not Skinner:isAddonEnabled("TinyDPS") then return end

function Skinner:TinyDPS()

	self:addSkinFrame{obj=tdpsFrame, ofs=2}
	
	local function skinSBs()

		for _, child in ipairs{tdpsFrame:GetChildren()} do
			if child:IsObjectType("StatusBar")
			and not Skinner.sbGlazed[child]
			then
				Skinner:glazeStatusBar(child, 0,  nil)
			end
		end

	end
	-- add a metatable to the Player table so that new bars can be skinned
	if tdpsPlayer then
		-- print("TinyDPS", tdpsPlayer)
		local mt = {__newindex = function(t, k, v)
			print("tdpsPlayer", t, k, v)
			skinSBs()
		end}
		setmetatable(tdpsPlayer, mt)
	end
	-- skin any existing StatusBars
	skinSBs()

end
