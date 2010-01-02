
function Skinner:Auctionsnatch()

	self:skinAllButtons{obj=ASmainframe}
	self:skinEditBox{obj=AS.mainframe.headerframe.editbox, regs={9}, noWidth=true, x=-14}
	self:skinScrollBar{obj=AS.mainframe.listframe.scrollbarframe}
	self:addSkinFrame{obj=ASmainframe, y1=2, x2=2}
	-- Option frame
	self:addSkinFrame{obj=ASoptionframe}
	-- DropDown frame
	self:skinDropDown{obj=ASdropDownMenu}
	-- Prompt frame
	self:skinAllButtons{obj=ASpromptframe, x1=-6, x2=6}
	self:skinEditBox{obj=AS.prompt.priceoverride, regs={9}}
	self:addSkinFrame{obj=ASpromptframe}

end
