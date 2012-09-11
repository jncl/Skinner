local aName, aObj = ...
if not aObj:isAddonEnabled("FarmIt2") then return end

function aObj:FarmIt2()

	local function skinGroups(gid)
		local group = FI_DB.select(FI_SVPC_DATA.Groups, {id = gid}, true)
		local fObj = _G["FI_Group_"..group.id]
		fObj:DisableDrawLayer("BACKGROUND")
		self:skinButton{obj=_G["FI_Group_"..group.id.."_Less"], mp=true}
		self:skinButton{obj=_G["FI_Group_"..group.id.."_More"], mp=true, plus=true}
		self:addSkinFrame{obj=fObj, x1=-1, x2=1, y2=-1}
		-- skin buttons
		for i, bid in ipairs(FI_Group_Members(group.id)) do
			local button = FI_DB.select(FI_SVPC_DATA.Buttons, {id = bid}, true)
			local bObj = _G["FI_Button_"..button.id]
			bObj:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=bObj, ibt=true, sec=true, reParent={_G["FI_Button_"..button.id.."_Bank"]}}
		end
	end
	-- skin existing group(s)
	for _, group in ipairs(FI_SVPC_DATA.Groups) do
		skinGroups(group.id)
	end
	-- hook this to skin new groups
	self:SecureHook("FI_Group_Style", function(gid)
		skinGroups(gid)
	end)

end
