
function Skinner:KLHThreatMeter()

-- Skin supplied by arkan, Thanks

	-- backdrop
	bd = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}

	-- i forbid you to change border color...
	self:Hook(klhtm.raidtable, "setcolour", function() end, true)

	-- sex up the header
	for k, v in pairs(klhtm.raidtable.instances) do
		i = klhtm.raidtable.instances[k]
		self:applySkin(i.gui.table, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header)
		self:applySkin(i.gui.header.identifier, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.options, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.setmt, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.minimise, nil, nil, nil, nil, bd)
		self:applySkin(i.gui.header.close, nil, nil, nil, nil, bd)
	end

	-- all option frames are deferred creation, therefore skin them just after they are created
	-- options menu section buttons not created on load so let's hijack their creation, ugly yes?
	self:SecureHook(klhtm.helpmenu, "showsection", function(sectionname)
--		self:Debug("HelpMenu_showsection: [%s]", sectionname)
		if sectionname == "raidtable"  and not klhtm.menuraidtable.skinned then
			self:applySkin(klhtm.menuraidtable.mainframe)
			self:applySkin(klhtm.menuraidtable.mainframe.button)
			for index,value in pairs(klhtm.helpmenu.button) do
				if (type(value) == "table") then
				self:applySkin(klhtm.helpmenu.button[index], nil, nil, nil, nil, bd)
				end
			end
			klhtm.menuraidtable.skinned = true
		end
		if sectionname == "raidtable-colour" and not klhtm.menuraidtable.colourframe.skinned then
			self:applySkin(klhtm.menuraidtable.colourframe)
			self:applySkin(klhtm.menuraidtable.colourframe.button1)
			self:applySkin(klhtm.menuraidtable.colourframe.button2)
			self:applySkin(klhtm.menuraidtable.colourframe.button3)
			klhtm.menuraidtable.colourframe.skinned = true
		end
		if sectionname == "raidtable-layout" and not klhtm.menuraidtable.layoutframe.skinned then
			self:applySkin(klhtm.menuraidtable.layoutframe)
			self:applySkin(klhtm.menuraidtable.layoutframe.button1)
			self:applySkin(klhtm.menuraidtable.layoutframe.button2)
			self:applySkin(klhtm.menuraidtable.layoutframe.button3)
			self:applySkin(klhtm.menuraidtable.layoutframe.button4)
			klhtm.menuraidtable.layoutframe.skinned = true
		end
		if sectionname == "raidtable-filter" and not klhtm.menuraidtable.filterframe.skinned then
			self:applySkin(klhtm.menuraidtable.filterframe)
			klhtm.menuraidtable.filterframe.skinned = true
		end
		if sectionname == "raidtable-misc" and not klhtm.menuraidtable.miscframe.skinned then
			self:applySkin(klhtm.menuraidtable.miscframe)
			klhtm.menuraidtable.miscframe.skinned = true
		end
		if sectionname == "mythreat" and not klhtm.menumythreat.mainframe.skinned then
			self:applySkin(klhtm.menumythreat.mainframe)
			self:applySkin(klhtm.menumythreat.mainframe.reset)
			self:applySkin(klhtm.menumythreat.mainframe.update)
			self:applySkin(klhtm.menumythreat.mainframe.mytable)
			klhtm.menumythreat.mainframe.skinned = true
		end
		if sectionname == "errorlog" and not klhtm.menuerror.frame.skinned then
			self:applySkin(klhtm.menuerror.frame)
			self:applySkin(klhtm.menuerror.frame.button1)
			self:applySkin(klhtm.menuerror.frame.button2)
			self:applySkin(klhtm.menuerror.frame.button3)
			self:applySkin(klhtm.menuerror.frame.button4)
			klhtm.menuerror.frame.skinned = true
		end
	end)

	-- skin the weird ass options window
	self:applySkin(klhtm.helpmenu.sections.raidtable.frame.button)
	self:applySkin(klhtm.menuhome.frame)
	self:applySkin(klhtm.error.frame)
	self:applySkin(klhtm.menudiag.frame)

	-- skin the copy box because i'm anal-retentive
	self:SecureHook(klhtm.gui, "showcopybox", function(text)
		self:applySkin(klhtm.gui.copybox)
		self:applySkin(klhtm.gui.copybox.button)
		self:Unhook(klhtm.gui, "showcopybox")
	end)

end
