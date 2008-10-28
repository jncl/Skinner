
function Skinner:setupLDB()

	local Skinner = Skinner

	local ldb = LibStub("LibDataBroker-1.1", true)
	if not ldb then return end

	local icon = LibStub("LibDBIcon-1.0", true)
	if not icon then return end

	local dew = LibStub("Dewdrop-2.0", true)
	if not dew then return end

	local L = LibStub("AceLocale-2.2", true):new("Skinner")
	if not L then return end

	-- define the LDB data object
	SkinnerLDB = ldb:NewDataObject("Skinner", {
			type = "data source",
			text = "Skinner",
			icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
	})

	-- add to options table
	local mmkey = {}
	mmkey.type = "toggle"
	mmkey.name = L["Minimap icon"]
	mmkey.desc = L["Toggle the minimap icon"]
	mmkey.order = 230
	mmkey.get = function() return not Skinner.db.profile.minimap.hide end
	mmkey.set = function(v)
			local hide = not v
			Skinner.db.profile.minimap.hide = hide
			if hide then
				icon:Hide("Skinner")
			else
				icon:Show("Skinner")
			end
		end
	mmkey.hidden = function() return not icon end
	Skinner.options.args["minimap"] = mmkey

	-- register the data object to the Icon library
	icon:Register("Skinner", SkinnerLDB, Skinner.db.profile.minimap)

	-- copied from picoGuild Addon
	local function GetTipAnchor(frame)

		local x,y = frame:GetCenter()
		if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
		local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
		local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
		return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf

	end

	function SkinnerLDB.OnLeave() GameTooltip:Hide() end
	function SkinnerLDB.OnEnter(self)

	 	GameTooltip:SetOwner(self, "ANCHOR_NONE")
		GameTooltip:SetPoint(GetTipAnchor(self))
		GameTooltip:ClearLines()

		GameTooltip:AddLine("Skinner")
		GameTooltip:AddLine(L["Right Click to display menu"])

		GameTooltip:Show()

	end

	-- copied from Violation Addon
	function SkinnerLDB.OnClick(self, button)

		if button == "RightButton" then
			dew:Open(self, "children", function() dew:FeedAceOptionsTable(Skinner.options) end)
		end

	end

end
