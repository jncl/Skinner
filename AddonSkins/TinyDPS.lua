if not Skinner:isAddonEnabled("TinyDPS") then return end

function Skinner:TinyDPS()

	self:addSkinFrame{obj=tdpsFrame, ofs=2, aso={ng=true}} -- no gradient (Animation)
	
	local function skinSBs()

		for _, child in ipairs{tdpsFrame:GetChildren()} do
			if child:IsObjectType("StatusBar") then
				child:SetBackdrop(nil)
				child:SetStatusBarTexture(Skinner.sbTexture)
				child.bg = child:CreateTexture(nil, "BACKGROUND")
				child.bg:SetTexture(Skinner.sbTexture)
				child.bg:SetVertexColor(unpack(Skinner.sbColour))
			end
		end

	end
	-- add a metatable to the Player table so that new bars can be skinned
	if tdpsPlayer then
		local mt = {__newindex = function(t, k, v)
			rawset(t, k, v)
			Skinner:ScheduleTimer(skinSBs, 0.1) -- wait for 1/10th second for bar to be created before skinning it
		end}
		-- hook this as it is used when the tables are reset
		self:SecureHook(noData, "Show", function(this)
			setmetatable(tdpsPlayer, mt)
		end)
	end
	-- skin any existing StatusBars
	skinSBs()

end
