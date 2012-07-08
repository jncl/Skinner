local aName, aObj = ...
if not aObj:isAddonEnabled("GuildBankSearch") then return end

function aObj:GuildBankSearch()
	if not self.db.profile.GuildBankUI then return end

	local GBS = GuildBankSearch
	self:skinEditBox{obj=GBS.Name, regs={9}}
	self:skinEditBox{obj=GBS.Text, regs={9}}
	self:skinDropDown{obj=GBS.Quality, x2=-6}
	self:skinEditBox{obj=GBS.ItemLevelMin, regs={9}}
	self:skinEditBox{obj=GBS.ItemLevelMax, regs={9}}
	self:moveObject{obj=GBS.ItemLevelMax, x=-6, relTo=GBS.ItemLevelMax.Label}
	self:skinEditBox{obj=GBS.ReqLevelMin, regs={9}}
	self:moveObject{obj=GBS.ReqLevelMin.Label, x=6, relTo=GBS.ReqLevelMax}
	self:skinEditBox{obj=GBS.ReqLevelMax, regs={9}}
	self:addSkinFrame{obj=GBS.CategorySection}
	self:skinDropDown{obj=GBS.Type, x2=-6}
	self:skinDropDown{obj=GBS.SubType, x2=-6}
	self:skinDropDown{obj=GBS.Slot, x2=-6}
	self:addSkinFrame{obj=GBS.Frame, kfs=true, x1=-1, y1=-3, x2=-2, y2=2}

end
