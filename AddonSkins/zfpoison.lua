
function Skinner:zfpoison()

	-- Main frame
	self:skinAllButtons{obj=zfpoisonframe1}
	self:addSkinFrame{obj=zfpoisonframe1, sap=true}
	-- Dialog frame
	self:skinAllButtons(where_zfpoison)
	self:addSkinFrame{obj=where_zfpoison, sap=true}

end
