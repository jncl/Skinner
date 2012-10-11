local aName, aObj = ...
if not aObj:isAddonEnabled("FarmIt2") then return end

function aObj:FarmIt2()

	local function skinGroups(gid)
		local group = FI_DB.select(FI_SVPC_DATA.Groups, {id = gid}, true)
		local gName = "FI_Group_"..group.id
		_G[gName]:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=_G[gName], x1=-1, x2=1, y2=-1}
		aObj:skinButton{obj=_G[gName.."_Less"], mp=true}
		aObj:skinButton{obj=_G[gName.."_More"], mp=true, plus=true}
		-- skin buttons
		for i, button in ipairs(FI_SVPC_DATA.Buttons) do
			if button.group == group.id then
				local bName = "FI_Button_"..button.id;
				_G[bName]:DisableDrawLayer("BACKGROUND")
				aObj:addButtonBorder{obj=_G[bName], ibt=true, sec=true, reParent={_G[bName.."_Bank"]}}
			end
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
