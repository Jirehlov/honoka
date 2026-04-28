//===========================================================================
//!
//!    @file     ___mng_urace_grp_common.ss
//!    @brief    ＵＭＡレース／共通描画関数群
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#z00

//---------------------------------------------------------------------------
// ＵＭＡレースのフォントを有効にする
//---------------------------------------------------------------------------
command $$urace_font_enable
{
	script.set_font_name("Noto Sans JP Black")
	script.set_font_bold(0)
	script.set_font_shadow(0)
}

//---------------------------------------------------------------------------
// ＵＭＡレースのフォントを無効にする
//---------------------------------------------------------------------------
command $$urace_font_disable
{
	script.set_font_name_default
	script.set_font_bold_default
	script.set_font_shadow_default
}

//---------------------------------------------------------------------------
// ＵＭＡレースのシステムメッセージ（汎用）を表示する
//---------------------------------------------------------------------------
command $$show_urace_system_message(property $obj : object, property $text : str)
{
	property $font_size
	property $font_color
	
	$font_size = 50
	$font_color = 0
	
	// todo システムメッセージ表示ＳＥ
	// todo 仮データ
	
	// 背景
	$obj.create(_mng_ur_medal_complete_bg, 1, 151, 393)
	$obj.y_rep.resize(1)
	$obj.child.resize(2)
	
	// テキスト
	$$create_ui_string($obj.child[0], 0, $font_size / 2, $obj.get_size_x, $obj.get_size_y / 20,  $font_size)
	$obj.child[0].f_align = <STRING_ALIGN_CENTER>
	$$update_ui_string_param($obj.child[0], $font_size, 1, 5, 100, $font_color, -1, -1, -1)
	$$update_ui_string($obj.child[0], $text)
	
	$$create_ui_string($obj.child[1], 0, $obj.get_size_y / 2, $obj.get_size_x, $obj.get_size_y / 2,  $font_size)
	$obj.child[1].f_align = <STRING_ALIGN_CENTER>
	$$update_ui_string_param($obj.child[1], $font_size, 1, 5, 100, $font_color, -1, -1, -1)
	$$update_ui_string($obj.child[1], $$get_urace_new_hunter_text)
	
	// 表示アニメーション
	$obj.y_rep[0] = 50
	$obj.y_rep_eve[0].set(0, 350, 0, 2)
	$obj.tr = 0
	$obj.tr_eve.set(255, 350, 0, 2)
}

//---------------------------------------------------------------------------
// ＵＭＡレースのシステムメッセージ（汎用）を非表示にする
//---------------------------------------------------------------------------
command $$hide_urace_system_message(property $obj : object)
{
	// 非表示アニメーション
	$obj.y_rep_eve[0].set(50, 350, 0, 2)
	$obj.tr_eve.set(0, 350, 0, 2)
}

//---------------------------------------------------------------------------
// ＵＭＡカードを作成する
//---------------------------------------------------------------------------
command $$create_uma_card_object(property $obj : object, property $uma_id, property $x, property $y)
{
	// ベース
	$obj.create("__mng_ur_uma_card" + math.tostr_zero($uma_id, 2), 1, $x, $y)
	$obj.child.resize(1)
	
	// スキルアイコン
	$obj.child[0].create("__mng_ur_uma_card_skill_icon", 1, 25, 686)
	
	// 更新する
	$$update_uma_card_object($obj, $uma_id)
}

//---------------------------------------------------------------------------
// ＵＭＡカードを更新する
//---------------------------------------------------------------------------
command $$update_uma_card_object(property $obj : object, property $uma_id)
{
	// ベース
	$obj.change_file("__mng_ur_uma_card" + math.tostr_zero($uma_id, 2))
	
	// スキルアイコン
	$obj.child[0].patno = $$get_db_skill_type($$get_db_uma_skill_id($uma_id))
}













//---------------------------------------------------------------------------
// ＵＭＡサムネイルボタンを作成する
//---------------------------------------------------------------------------
command $$create_uma_thumb_button(property $obj : object, property $owner_id, property $uma_index, property $x, property $y, property $btn_no, property $objbtn_group_no)
{
	$$create_ui_button($obj, __mng_ur_library_uma_btn + math.tostr_zero($$get_uma_id($owner_id, $uma_index), 2), $x, $y, $btn_no, $objbtn_group_no, 1)
}

//---------------------------------------------------------------------------
// ＵＭＡサムネイルボタンを更新する
//---------------------------------------------------------------------------
command $$update_uma_thumb_button(property $obj : object, property $owner_id, property $uma_index)
{
	$obj.change_file(__mng_ur_library_uma_btn + math.tostr_zero($$get_uma_id($owner_id, $uma_index), 2))
}






// サムネイルボタンを作成する
command $$create_uma_thumb_btn(property $obj : object, property $owner_id, property $uma_index, property $x, property $y, property $btn_no, property $btn_group)
{
	property $i
	property $len
	
	// ボタン
	$$create_ui_button($obj, "__mng_ur_uma_thumb_btn01", $x, $y, $btn_no, $btn_group, 1)
	$obj.child.resize(5)
	
	// 出走順
	$obj.child[0].create("__mng_ur_uma_thumb_run_order", 1, 11, -8)
	
	// ランク
	$obj.child[1].create("__mng_ur_uma_thumb_rank", 1, 187, -15)
	
	// レアリティ
	$obj.child[2].disp = 1
	$obj.child[2].set_pos(224, -10)
	$obj.child[2].child.resize(<UMA_RARITY_MAX>)
	for( $i = 0, $i < <UMA_RARITY_MAX>, $i += 1 ) {
		$obj.child[2].child[$i].create("__mng_ur_uma_thumb_rarity", 1, -29 * $i, 0)
	}
	
	// スキルアイコン
	$obj.child[3].create("__mng_ur_uma_thumb_skill_icon", 1, 210, -14)
	
	// ＮＥＷアイコン
	if( $owner_id == <URACE_PLAYER_OWNER_ID> )
	{
		$obj.child[4].create(urace_library_new_mark, 1, 20, 0)
		$obj.child[4].set_scale(500, 500)
		$obj.child[4].disp = $$get_uma_new_flag(<URACE_PLAYER_OWNER_ID>, $i)
	}
	
	// ボタン動作
	$$set_urace_button($obj)
}

// サムネイルボタンを更新する
command $$update_uma_thumb_btn(property $obj : object, property $owner_id, property $uma_index, property $index, property $type)
{
	property $i
	property $owner_id
	property $uma_id
	property $rarity
	property $run_order
	
	if( $uma_index == -1 )
	{
		$obj.change_file("__mng_ur_uma_thumb_btn00")
		
		$obj.child[0].disp = 1
		$obj.child[0].patno = $index
		$obj.child[1].disp = 0
		$obj.child[2].disp = 0
		$obj.child[3].disp = 0
		
		return
	}
	
	if( $type == 1 || $type == 2 ) {
		$owner_id = <URACE_PLAYER_OWNER_ID>
	} else {
		$owner_id = -2
	}
	
	$uma_id = $$get_uma_id($owner_id, $uma_index)
	$rarity = $$get_uma_rarity($owner_id, $uma_index)
	$run_order = $$get_my_deck_run_order($uma_index)
	
	// ボタン
	$obj.change_file("__mng_ur_uma_thumb_btn" + math.tostr_zero($uma_id, 2))
	
	// 出走順
	if( $type == 1 ) {
		if( $run_order != -1 )
		{
			$obj.child[0].disp = 1
			$obj.child[0].patno = $run_order
		}
		else
		{
			$obj.child[0].disp = 0
		}
	} elseif( $type == 2 ) {
		$obj.child[0].disp = 0
	} else {
		$obj.child[0].disp = 1
		$obj.child[0].patno = $index
	}
	
	// ステータス
	if( $$get_my_uma_list_sort_type == <URACE_SORT_TYPE_STATUS> )
	{
		$obj.child[1].disp = 1
		$obj.child[1].patno = $$uma_param_to_rank($$get_uma_total_param(<URACE_PLAYER_OWNER_ID>, $uma_index) / 3)
	}
	else
	{
		$obj.child[1].disp = 0
	}
	
	// レアリティ
	if( $$get_my_uma_list_sort_type == <URACE_SORT_TYPE_RARITY> )
	{
		$obj.child[2].disp = 1
		
		for( $i = 0, $i < <UMA_RARITY_MAX>, $i += 1 )
		{
			if( $i < $rarity ) {
				$obj.child[2].child[$i].disp = 1
			} else {
				$obj.child[2].child[$i].disp = 0
			}
		}
	}
	else
	{
		$obj.child[2].disp = 0
	}
	
	// スキルアイコン
	if( $$get_my_uma_list_sort_type == <URACE_SORT_TYPE_SKILL> )
	{
		$obj.child[3].disp = 1
		$obj.child[3].patno = $$get_db_skill_type($$get_uma_skill_id(<URACE_PLAYER_OWNER_ID>, $uma_index)) - 1
	}
	else
	{
		$obj.child[3].disp = 0
	}
	
	// ＮＥＷアイコン
	if( $owner_id == <URACE_PLAYER_OWNER_ID> )
	{
		$obj.child[4].disp = $$get_uma_new_flag(<URACE_PLAYER_OWNER_ID>, $uma_index)
	}
}









#inc_start
	
	// ＵＭＡレース専用ボタン
	#define		.f_btn_state			.f[7]		// ボタン状態
	#define		.f_btn_scale_normal		.f[8]		// 通常の拡縮率
	#define		.f_btn_scale_hit		.f[9]		// ボタンが当たっている場合の拡縮率
	#define		.f_btn_scale_push		.f[10]		// ボタンが押されている場合の拡縮率
	#replace	<HHP_BTN_F_FLAG_MAX>	11			// 確保するfフラグ最大数

#inc_end


//---------------------------------------------------------------------------
// ＵＭＡレースで使用するボタンに設定する
//---------------------------------------------------------------------------
command $$set_urace_button(property $obj : object)
{
	$obj.set_center_rep($obj.get_size_x, $obj.get_size_y)
	
	$obj.f.resize(<HHP_BTN_F_FLAG_MAX>)
	$obj.f_btn_scale_normal = 1000		// 通常の拡縮率
	$obj.f_btn_scale_hit    = 1050		// ボタンが当たっている場合の拡縮率
	$obj.f_btn_scale_push   =  900		// ボタンが押されている場合の拡縮率
	
	$obj.frame_action.start(-1, "$$fa_urace_button")
}

// ＵＭＡレースで使用するボタンのフレームアクション
command $$fa_urace_button(property $fa : frameaction, property $obj : object)
{
	property $state
	
	if( syscom.check_joypad_mode == 0 ) {
		$state = $obj.get_button_real_state
	} else {
		if( $$get_joypad_decided ) {
			$state = 2
		} elseif( $obj.get_button_no == $$get_joypad_focus_button ) {
			$state = 1
		}
	}
	
	if( $obj.f_btn_state == 3 && ($state != 2 && $state != 1) )
	{
		if( $obj.scale_x_eve.check ) {
			return
		}
		
		$obj.scale_x_eve.set($obj.f_btn_scale_normal, 50, 0, 1)
		$obj.scale_y_eve.set($obj.f_btn_scale_normal, 50, 0, 1)
		
		$obj.f_btn_state = 0
	}
	
	switch( $state ) {
	case(0)
		
		if( $obj.f_btn_state == 1 || $obj.f_btn_state == 2 )
		{
			if( $obj.scale_x_eve.check ) {
				return
			}
			
			$obj.scale_x_eve.set($obj.f_btn_scale_normal, 50, 0, 2)
			$obj.scale_y_eve.set($obj.f_btn_scale_normal, 50, 0, 2)
			
			$obj.f_btn_state = 0
		}
		
	case(1)
		
		if( $obj.f_btn_state == 0 || $obj.f_btn_state == 2 )
		{
			if( $obj.scale_x_eve.check ) {
				return
			}
			
			$obj.scale_x_eve.set($obj.f_btn_scale_hit, 50, 0, 2)
			$obj.scale_y_eve.set($obj.f_btn_scale_hit, 50, 0, 2)
			
			$obj.f_btn_state = 1
		}
		
	case(2)
		
		if( $obj.f_btn_state == 1 )
		{
			if( $obj.scale_x_eve.check ) {
				return
			}
			
			$obj.scale_x_eve.set($obj.f_btn_scale_push, 50, 0, 2)
			$obj.scale_y_eve.set($obj.f_btn_scale_push, 50, 0, 2)
			
			$obj.f_btn_state = 3
		}
	}
}

//---------------------------------------------------------------------------
// ＵＭＡレースで使用するボタンの拡縮率を設定する
//---------------------------------------------------------------------------
command $$set_urace_button_scale(property $obj : object, property $normal, property $hit, property $push)
{
	$obj.f_btn_scale_normal = $normal		// 通常の拡縮率
	$obj.f_btn_scale_hit    = $hit			// ボタンが当たっている場合の拡縮率
	$obj.f_btn_scale_push   = $push			// ボタンが押されている場合の拡縮率
}




//---------------------------------------------------------------------------
// ＵＭＡステータス
//---------------------------------------------------------------------------
// 作成する
command $$create_uma_status_object(property $obj : object, property $owner_id, property $uma_index, property $x, property $y)
{
	// 背景
	$obj.create("__mng_ur_uma_info_status_bg", 1, $x, $y)
	$obj.child.resize(6)
	
	// ＵＭＡチップ
	$$create_uma_status_tip($obj.child[0], 21, 10, $owner_id, $uma_index, $x, $y)
	
	// ライフ
	$$create_uma_status_param($obj.child[1], 240, 81, $$get_uma_life($owner_id, $uma_index))
	
	// スピード
	$$create_uma_status_param($obj.child[2], 240, 142, $$get_uma_speed($owner_id, $uma_index))
	
	// 攻撃力
	$$create_uma_status_param($obj.child[3], 240, 203, $$get_uma_attack($owner_id, $uma_index))
	
	// スキルアイコン
	$$create_uma_skill_icon($obj.child[4], 466, 56, $$get_uma_id($owner_id, $uma_index))
	$obj.child[4].set_scale(830, 830)
	
	// スキル詳細
	$obj.child[5].create_string("", 1, 468, 106)
	$obj.child[5].set_string_param(13, 0, 0, 19, 0, -1, -1, -1)
	
	// 更新する
	$$update_uma_status_object($obj, $owner_id, $uma_index)
}

// 更新する
command $$update_uma_status_object(property $obj : object, property $owner_id, property $uma_index)
{
	property $uma_id
	property $x
	property $y
	property $offset_x
	property $offset_y
	
	$uma_id = $$get_uma_id($owner_id, $uma_index)
	
	$x = $obj.child[0].x
	$y = $obj.child[0].y
	$offset_x = $obj.x
	$offset_y = $obj.y
	
	// ＵＭＡチップ
	$$create_uma_status_tip($obj.child[0], $x, $y, $owner_id, $uma_index, $offset_x, $offset_y)
	
	// ライフ
	$$update_uma_status_param($obj.child[1], $$get_uma_life($owner_id, $uma_index))
	
	// スピード
	$$update_uma_status_param($obj.child[2], $$get_uma_speed($owner_id, $uma_index))
	
	// 攻撃力
	$$update_uma_status_param($obj.child[3], $$get_uma_attack($owner_id, $uma_index))
	
	// スキル名
	$$update_uma_skill_icon($obj.child[4], $uma_id)
	
	// スキル詳細
	$obj.child[5].set_string($$get_db_skill_details($$get_db_uma_skill_id($uma_id)))
}

//---------------------------------------------------------------------------
// ＵＭＡステータス／パラメータ
//---------------------------------------------------------------------------
// 作成する
command $$create_uma_status_param(property $obj : object, property $x, property $y, property $value)
{
	property $i
	
	$obj.disp = 1
	$obj.set_pos($x, $y)
	$obj.child.resize(3)
	
	// ランク
	$obj.child[0].create("__mng_ur_uma_info_status_rank", 1, 1, -1)
	
	// バー
	$obj.child[1].disp = 1
	$obj.child[1].set_pos(47, 0)
	$obj.child[1].child.resize(10)
	for( $i = 0, $i < 10, $i += 1 )
	{
		$obj.child[1].child[$i].create("__mng_ur_uma_info_status_bar", 1, 12 * $i, 0)
	}
	
	// 数値
	$obj.child[2].create_number("__mng_ur_uma_info_status_number", 1, 174, 5)
	$obj.child[2].set_number_param(3, 0, 0, 0, 0, 0)
	
	// 更新する
	$$update_uma_status_param($obj, $value)
}

// 更新する
command $$update_uma_status_param(property $obj : object, property $value)
{
	property $i
	property $patno
	
	// ランク
	$obj.child[0].patno = $$uma_param_to_rank($value)
	
	// バー
	for( $i = 0, $i < 10, $i += 1 )
	{
		$patno = 0
		if( $i < $value / 10 ) {
			$patno = 1
		}
		
		if( $i == 0 && $patno == 0 ) {
			$patno = 1
		}
		
		$obj.child[1].child[$i].patno = $patno
	}
	
	// 数値
	$obj.child[2].set_number($value)
}


















command $$create_uma_skill_icon(property $obj : object, property $x, property $y, property $uma_id)
{
	property $skill_id
	
	$skill_id = $$get_db_uma_skill_id($uma_id)
	
	// アイコン
	$obj.create("__mng_ur_library_uma_skill_icon", 1, $x, $y)
	$obj.child.resize(1)
	
	// スキル名
	$obj.child[0].create("__mng_ur_library_uma_skill_name", 1, 42, 3)
	
	// 更新する
	$$update_uma_skill_icon($obj, $uma_id)
}

command $$update_uma_skill_icon(property $obj : object, property $uma_id)
{
	property $skill_id
	
	$skill_id = $$get_db_uma_skill_id($uma_id)
	
	// アイコン
	$obj.patno = $$get_db_skill_type($skill_id) - 1
	
	// スキル名
	$obj.child[0].patno = $skill_id - 1
}









//---------------------------------------------------------------------------
// ＵＭＡステータス／パラメータを作成する
//---------------------------------------------------------------------------
command $$create_uma_status_tip(property $obj : object, property $x, property $y, property $owner_id, property $uma_index, property $offset_x, property $offset_y)
{
	property $filename : str
	property $focus_ground_type
	
	$obj.disp = 1
	$obj.set_pos($x, $y)
	$obj.set_clip(1, 102 + $offset_x - 81, 816 + $offset_y - 806, 302 + $offset_x - 81, 1024 + $offset_y - 806)
	$obj.child.resize(2)
	
	// チップアニメーション／背景
	$obj.child[0].create(_mng_ur_race_bg01, 1, 0, -300, 5)
	$obj.child[0].x_eve.loop(0, -1920 + (264 + 8), 10000, 0, 0)
	
	// チップアニメーション／ＵＭＡチップ
	$$create_uma_tip_object($obj.child[1], $$get_uma_id($owner_id, $uma_index), 20, 20)
	$$play_uma_tip_move_anim($obj.child[1])
	
	/*
	// チップアニメーション／背景
	if( $obj.child[0].child[0].get_file_name != $filename ) {
		
		if( $focus_ground_type == -1 ) {
			$obj.child[0].change_file("_mng_ur_race_bg01")
		} else {
			$obj.child[0].change_file("_mng_ur_race_bg" + math.tostr_zero($$get_db_race_ground_type($focus_ground_type), 2))
		}
	}
	
	// チップアニメーション／ＵＭＡチップ
	$filename = $$get_uma_tip_filename($$get_uma_id($owner_id, $uma_index))
	if( $obj.child[2].get_file_name != $filename )
	{
		$obj.child[2].change_file($filename)
		
		$$init_urace_uma_tip_anim
		$$set_urace_uma_tip_anim($obj.child[2], $$get_uma_id($owner_id, $uma_index), 0)
		$$start_urace_uma_tip_move_anim($obj.child[2])
	}
	*/
}

//---------------------------------------------------------------------------
// 捕獲したＵＭＡカードアニメーションを表示する
//---------------------------------------------------------------------------
command $$show_catch_uma_card_animation(property $obj : object)
{
	$$set_image_center_rep($obj)
	$obj.set_pos(<SCREEN_CENTER_X> - $obj.get_size_x / 2, <SCREEN_CENTER_Y> - $obj.get_size_y / 2)
	
	if( $$get_hunter_request_result_uma_new(0) )
	{
		$obj.child.resize($obj.child.get_size + 1)
		$obj.child[$obj.child.get_size - 1].create(urace_library_new_mark, 1, 0, 50)
		$obj.child[$obj.child.get_size - 1].tr = 0
		$obj.child[$obj.child.get_size - 1].tr_eve.set(255, 250, 500, 0)
		$obj.child[$obj.child.get_size - 1].set_scale(2000, 2000)
		$obj.child[$obj.child.get_size - 1].scale_x_eve.set(1000, 250, 500, 2)
		$obj.child[$obj.child.get_size - 1].scale_y_eve.set(1000, 250, 500, 2)
		$obj.child[$obj.child.get_size - 1].bright_eve.turn(0, 128, 500, 0, 2)
	}
	
	$obj.set_scale(2000, 2000)
	$obj.scale_x_eve.set(1000, 500, 0, 2)
	$obj.scale_y_eve.set(1000, 500, 0, 2)
	$obj.bright = 255
	$obj.bright_eve.set(0, 250, 500, 2)
	$obj.rotate_z = 3600
	$obj.rotate_z_eve.set(0, 500, 0, 2)
}

//---------------------------------------------------------------------------
// 捕獲したＵＭＡステータスアニメーションを表示する
//---------------------------------------------------------------------------
command $$show_catch_uma_status_animation(property $obj_card : object, property $obj_status : object)
{
	property $i
	property $value
	
	$obj_card.x_eve.set(360, 250, 0, 2)
	
	$obj_status.x_eve.set(920, 250, 250, 2)
	$obj_status.tr = 0
	$obj_status.tr_eve.set(255, 250, 250, 2)
}

command $$create_urace_race_base_bg(property $obj : object, property $ground_type)
{
	property $filename : str
	
	$filename = "_mng_ur_race_bg" + math.tostr_zero($$get_db_race_ground_type($ground_type), 2)
	
	$obj.disp = 1
	$obj.child.resize(3)
	
	$obj.child[0].create($filename, 1, 0, 0, 1)
	$obj.child[0].child.resize(1)
	$obj.child[0].child[0].create($filename, 1, 0, 0, 4 + $$get_entry_race_ground_type)
	
	$obj.child[1].create($filename, 1, 1920 * 2, 0, 1)
	$obj.child[1].scale_x = -1000
	$obj.child[1].child.resize(1)
	$obj.child[1].child[0].create($filename, 1, 0, 0, 4 + $$get_entry_race_ground_type)
	
	$obj.child[2].create($filename, 1, 1920 * 2, 0, 1)
	$obj.child[2].child.resize(1)
	$obj.child[2].child[0].create($filename, 1, 0, 0, 4 + $$get_entry_race_ground_type)
}
