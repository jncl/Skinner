local _, aObj = ...
if not aObj:isAddonEnabled("CEPGP") then return end
local _G = _G

aObj.addonsToSkin.CEPGP = function(self) -- v 1.12.9

	local function skinOptions(frame)
		for _, child in pairs{frame:GetChildren()} do
			if aObj:isDropDown(child) then
				aObj:skinDropDown{obj=child}
			elseif child:IsObjectType("EditBox") then
				aObj:skinEditBox{obj=child, regs={6}} -- 6 is text
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("button")
			and not aObj:hasAnyTextInName(child, {"prev", "next"})
			and aObj.modBtns
			then
				aObj:skinStdButton{obj=child}
			elseif child:IsObjectType("button")
			and aObj:hasAnyTextInName(child, {"prev", "next"})
			and aObj.modBtnBs
			then
				self:addButtonBorder{obj=child, ofs=-2, x2=-3, clr="gold"}
			end
		end
	end
	self:SecureHookScript(_G.CEPGP_frame, "OnShow", function(this)
		_G.CEPGP_frame_close:SetSize(30, 30)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_frame_close}
			self:skinStdButton{obj=_G.CEPGP_button_guild}
			self:skinStdButton{obj=_G.CEPGP_button_raid}
			self:skinStdButton{obj=_G.CEPGP_button_options}
			self:skinStdButton{obj=_G.CEPGP_button_loot_dist}
			self:skinStdButton{obj=_G.CEPGP_distributing_button}
		end

		-- CEPGP_guild
		self:skinSlider{obj=_G.GuildScrollFrame.ScrollBar}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_button_guild_dump}
			self:skinStdButton{obj=_G.CEPGP_button_guild_export}
			self:skinStdButton{obj=_G.CEPGP_button_guild_import}
			self:skinStdButton{obj=_G.CEPGP_button_options_attendance}
			self:skinStdButton{obj=_G.CEPGP_button_guild_restore}
			self:skinStdButton{obj=_G.CEPGP_button_guild_traffic}
			self:skinStdButton{obj=_G.CEPGP_guild_add_EP}
			self:skinStdButton{obj=_G.CEPGP_guild_decay}
			self:skinStdButton{obj=_G.CEPGP_guild_reset}
		end
		-- CEPGP_raid
		self:skinSlider{obj=_G.RaidScrollFrame.ScrollBar}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_raid_add_EP}
		end
		-- CEPGP_loot
		-- CEPGP_distribute
		self:skinSlider{obj=_G.DistScrollFrame.ScrollBar}
		-- CEPGP_options
		skinOptions(_G.CEPGP_options)
		skinOptions(_G.CEPGP_options_gp_container)
		skinOptions(_G.CEPGP_options_slots_container)
		skinOptions(_G.CEPGP_options_standby_ep_options)
		skinOptions(_G.CEPGP_options_page_2)
		skinOptions(_G.CEPGP_options_page_3)
		skinOptions(_G.CEPGP_options_page_3_mc)
		skinOptions(_G.CEPGP_options_page_3_bwl)
		skinOptions(_G.CEPGP_options_page_3_zg)
		skinOptions(_G.CEPGP_options_page_3_aq20)
		skinOptions(_G.CEPGP_options_page_3_aq40)
		skinOptions(_G.CEPGP_options_page_3_naxx)
		skinOptions(_G.CEPGP_options_page_3_worldboss)
		-- CEPGP_options_plugins
		-- CEPGP_standby
		self:skinSlider{obj=_G.CEPGP_standby_scrollframe.ScrollBar}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_standby_ep_list_add}
			self:skinStdButton{obj=_G.CEPGP_standby_ep_list_addbyrank}
			self:skinStdButton{obj=_G.CEPGP_standby_ep_list_purge}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_version, "OnShow", function(this)
		self:skinSlider{obj=_G.CEPGP_version_scrollframe.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_version_close}
			self:skinStdButton{obj=_G.CEPGP_version_raid_check}
			self:skinStdButton{obj=_G.CEPGP_version_guild_check}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G._G.CEPGP_version_offline_check}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_distribute_popup, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G._G.CEPGP_distribute_popup_pass}
			self:skinStdButton{obj=_G.CEPGP_distribute_popup_gp}
			self:skinStdButton{obj=_G.CEPGP_distribute_popup_gp_full}
			self:skinStdButton{obj=_G.CEPGP_distribute_popup_free}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_context_popup, "OnShow", function(this)
		self:skinEditBox{obj=_G.CEPGP_context_amount, regs={6}} -- 6 is text
		self:skinEditBox{obj=_G.CEPGP_context_reason, regs={6}} -- 6 is text
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_context_popup_cancel}
			self:skinStdButton{obj=_G.CEPGP_context_popup_confirm}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CEPGP_context_popup_EP_check}
			self:skinCheckButton{obj=_G.CEPGP_context_popup_GP_check}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_save_guild_logs, "OnShow", function(this)
		self:skinEditBox{obj=_G.CEPGP_guild_log_save_name, regs={6}} -- 6 is text
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_guild_log_save_cancel}
			self:skinStdButton{obj=_G.CEPGP_guild_log_save_confirm}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_restore_guild_logs, "OnShow", function(this)
		self:skinDropDown{obj=_G.CEPGP_restoreDropdown}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_guild_log_restore_cancel}
			self:skinStdButton{obj=_G.CEPGP_guild_log_restore_delete}
			self:skinStdButton{obj=_G.CEPGP_guild_log_restore_confirm}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_settings_import, "OnShow", function(this)
		self:skinEditBox{obj=_G.CEPGP_settings_import_name, regs={6}} -- 6 is text
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_settings_import_cancel}
			self:skinStdButton{obj=_G.CEPGP_settings_import_confirm}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_override, "OnShow", function(this)
		_G.CEPGP_override_close:SetSize(30, 30)
		self:skinEditBox{obj=_G.CEPGP_override_item_name, regs={6}} -- 6 is text
		self:skinEditBox{obj=_G.CEPGP_override_item_id, regs={6}} -- 6 is text
		self:skinEditBox{obj=_G.CEPGP_override_item_gp, regs={6}} -- 6 is text
		self:skinSlider{obj=_G.OverrideScrollFrame.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_override_close}
			self:skinStdButton{obj=self:getChild(this, 5)} -- N.B. CEPGP_override_confirm is also defined as a boolean value within the code
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_traffic, "OnShow", function(this)
		self:skinEditBox{obj=_G.CEPGP_traffic_search, regs={6}, x=-10} -- 6 is text
		_G.CEPGP_traffic_close:SetSize(30, 30)
		self:skinSlider{obj=_G.trafficScrollFrame.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_traffic_close}
			self:skinStdButton{obj=self:getChild(this, 2)} -- N. B. CEPGP_traffic_clear is also defined as a boolean within the code
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_debuginfo, "OnShow", function(this)
		_G.CEPGP_debuginfo_close:SetSize(30, 30)
		self:skinSlider{obj=_G.CEPGP_debug_scrollframe.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_debuginfo_close}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_notice_frame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_notice_accept}
			self:skinStdButton{obj=_G.CEPGP_notice_cancel}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CEPGP_notice_frame)
	self:SecureHookScript(_G.CEPGP_attendance, "OnShow", function(this)
		self:skinDropDown{obj=_G.CEPGP_attendance_dropdown}
		self:skinSlider{obj=_G.CEPGP_attendance_scrollframe.ScrollBar}
		self:skinSlider{obj=_G.CEPGP_attendance_scrollframe_standby.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_attendance_close}
			self:skinStdButton{obj=_G.CEPGP_attendance_record}
			self:skinStdButton{obj=_G.CEPGP_attendance_record_view}
			self:skinStdButton{obj=_G.CEPGP_attendance_delete}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_respond, "OnShow", function(this)
		-- don't remove item texture by using kfs=true on addSkinFrame
		this:DisableDrawLayer("ARTWORK")
		self:addSkinFrame{obj=this, ft="a", nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_respond_1}
			self:skinStdButton{obj=_G.CEPGP_respond_2}
			self:skinStdButton{obj=_G.CEPGP_respond_3}
			self:skinStdButton{obj=_G.CEPGP_respond_4}
			self:skinStdButton{obj=_G.CEPGP_respond_pass}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_export, "OnShow", function(this)
		_G.CEPGP_export_close:SetSize(30, 30)
		self:skinSlider{obj=CEPGP_export_scrollframe.ScrollBar}
		self:moveObject{obj=_G.CEPGP_export_attr_trailing, x=20}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_export_close}
			self:skinStdButton{obj=_G.CEPGP_export_csv}
			self:skinStdButton{obj=_G.CEPGP_export_json}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CEPGP_export_class_check}
			self:skinCheckButton{obj=_G.CEPGP_export_rank_check}
			self:skinCheckButton{obj=_G.CEPGP_export_PR_check}
			self:skinCheckButton{obj=_G.CEPGP_export_trailing_check}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_confirmation, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_confirmation_yes}
			self:skinStdButton{obj=_G.CEPGP_confirmation_no}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_standby_addRank, "OnShow", function(this)
		_G.CEPGP_standby_addRank_close:SetSize(30, 30)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_standby_addRank_confirm}
			self:skinCloseButton{obj=_G.CEPGP_standby_addRank_close}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_1_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_2_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_3_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_4_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_5_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_6_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_7_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_8_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_9_check}
			self:skinCheckButton{obj=_G.CEPGP_standby_addRank_10_check}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_loot_gui_options, "OnShow", function(this)
		_G.CEPGP_loot_gui_options_close:SetSize(30, 30)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CEPGP_loot_gui_options_close}
		end
		skinOptions(_G.CEPGP_loot_gui_options_1)
		skinOptions(_G.CEPGP_loot_gui_options_2)
		skinOptions(_G.CEPGP_loot_gui_options_3)
		skinOptions(_G.CEPGP_loot_gui_options_4)
		skinOptions(_G.CEPGP_loot_gui_options_timer)
		skinOptions(_G.CEPGP_loot_gui_options_preview)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_import, "OnShow", function(this)
		self:skinSlider{obj=_G.CEPGP_import_scrollframe}
		self:skinSlider{obj=_G.CEPGP_import_progress_scrollframe}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G._G.CEPGP_import_confirm}
		end

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.CEPGP_ep_award_confirm, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CEPGP_ep_award_confirm_yes}
			self:skinStdButton{obj=_G.CEPGP_ep_award_confirm_no}
		end

		self:Unhook(this, "OnShow")
	end)

end
