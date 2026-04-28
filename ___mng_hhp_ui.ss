//===========================================================================
//!
//!    @file     ___mng_hhp_ui.ss
//!    @brief    ヘビヘビパニックＵＩ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	#replace	<ITEM_DISP_NUM>			4
	#replace	<SYS_MESSAGE_FONT_SIZE>		60
	
	// 各ＵＩ
	#replace	c_player_lifebar		child[0]	// プレイヤーライフバー
	#replace	c_game_level			child[1]	// ゲームレベル
	#replace	c_score					child[2]	// スコア
	#replace	c_rewards				child[3]	// 報酬ＢＯＸ
	#replace	c_item_list				child[4]	// アイテムリスト
	#replace	c_support				child[5]	// サポートキャラ
	#replace	c_combo					child[6]	// コンボカウンター
	#replace	c_time_limit			child[7]	// 時間制限
	#replace	c_boss_lifebar			child[8]	// ボスライフバー
	#replace	c_boss_warning			child[9]	// ボス出現
	#replace	c_caution_filter		child[10]	// ピンチフィルター
	#replace	c_sys_message			child[11]	// システムメッセージ
	#replace	c_max					13
	
	#replace	f_image_size_x			f[0]		// 読み込み画像サイズx
	
	#property	$player_life_disp			// 表示中のプレイヤーライフ
	#property	$player_life_target			// 表示目標のプレイヤーライフ
	#property	$score_disp					// 表示中のスコア
	#property	$score_target				// 表示目標のスコア
	#property	$score_interep				// 加算補正を行うスコア
	#property	$time_limit_old
	
	// ヘビヘビパニック専用ボタン
	#define		.f_btn_state			.f[7]		// ボタン状態
	#define		.f_btn_scale_normal		.f[8]		// 通常の拡縮率
	#define		.f_btn_scale_hit		.f[9]		// ボタンが当たっている場合の拡縮率
	#define		.f_btn_scale_push		.f[10]		// ボタンが押されている場合の拡縮率
	#replace	<HHP_BTN_F_FLAG_MAX>	11			// 確保するfフラグ最大数

#inc_end

#z00

//---------------------------------------------------------------------------
// オブジェクト／ＵＩ全般
//---------------------------------------------------------------------------
// 作成する
command $$create_hhp_scene_object(property $stage : stage)
{
	$$create_hhp_bg_back_object($stage.object[<HHP_OBJ_BG_BACK>])						// 背景(背面)
	$$create_hhp_bg_front_object($stage.object[<HHP_OBJ_BG_FFRONT>])					// 背景(前面)
	$$create_hhp_player_shield_object($stage.object[<HHP_OBJ_PLAYER_SHIELD>])			// プレイヤーシールド(フェンス)
	$$create_hhp_main_ui($stage.object[<HHP_OBJ_MAIN_UI>])								// メインＵＩ
	$$create_hhp_skill_button($stage.object[<HHP_BTN_SKILL>])							// 奥義ボタン
	$$create_hhp_pause_button($stage.object[<HHP_BTN_PAUSE>])							// 一時停止ボタン
	
	// 変更する(通常ウェーブ／ボスウェーブ)
	$$change_hhp_scene_object($stage, $$is_hhp_boss_wave)
	
	// deb
	$$create_ui_image($stage.object[<HHP_DUMMY>], "__mng_hp_defense_line", 0, 768)
	$stage.object[<HHP_DUMMY>].disp = 0
	
	// パッド入力の遷移を設定する
	$$set_joypad_navigation($stage)
}

// 更新する
command $$update_hhp_scene_object(property $stage : stage)
{
	$$update_hhp_player_shield_object($stage.object[<HHP_OBJ_PLAYER_SHIELD>])			// プレイヤーシールド(フェンス)
	$$update_hhp_main_ui($stage.object[<HHP_OBJ_MAIN_UI>])								// メインＵＩ
	$$update_hhp_skill_button($stage.object[<HHP_BTN_SKILL>])							// 奥義ボタン
	$$update_hhp_pause_button($stage.object[<HHP_BTN_PAUSE>])							// 一時停止ボタン
}

// 変更する(通常ウェーブ／ボスウェーブ)
command $$change_hhp_scene_object(property $stage : stage, property $mode)
{
	if( $mode )
	{
		// ボスウェーブ
		$stage.object[<HHP_OBJ_MAIN_UI>].c_time_limit.disp = 0
	}
	else
	{
		// 通常ウェーブ
		$stage.object[<HHP_OBJ_MAIN_UI>].c_time_limit.disp   = 1
		$stage.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.disp = 0
	}
}

// 非表示にする
command $$hide_hhp_scene_object(property $stage : stage)
{
	$stage.object[<HHP_OBJ_BG_BACK>].init
	$stage.object[<HHP_OBJ_BG_FFRONT>].init
	$stage.object[<HHP_OBJ_PLAYER_SHIELD>].init
	$stage.object[<HHP_OBJ_MAIN_UI>].init
	$stage.object[<HHP_BTN_SKILL>].init
	$stage.object[<HHP_BTN_PAUSE>].init
}

//---------------------------------------------------------------------------
// 背景
//---------------------------------------------------------------------------
// 背景(背面)を作成する
command $$create_hhp_bg_back_object(property $obj : object)
{
	$obj.create("__mng_hp_bg", 1, 0, 0, 1)
	$obj.layer = <HHP_LAYER_BG_BACK>
}

// 背景(前面)を作成する
command $$create_hhp_bg_front_object(property $obj : object)
{
	$obj.create("__mng_hp_bg", 1)
	$obj.layer = <HHP_LAYER_BG_FRONT>
}

//---------------------------------------------------------------------------
// プレイヤーシールド(フェンス)
//---------------------------------------------------------------------------
// 作成する
command $$create_hhp_player_shield_object(property $obj : object)
{
	// deb
	;$obj.create("_mng_hp_defense_line", 1, 0, 768, $$get_hhp_item_level(<HHP_ITEM_ID_LIFE_UP>))
	$obj.create("__mng_hp_defense_line", 1, 0, 768)
	$obj.layer = <HHP_LAYER_PLAYER_SHIELD>
	
	// 無敵アニメーション管理フラグ
	$obj.f.resize(1)
}

// 更新する
command $$update_hhp_player_shield_object(property $obj : object)
{
	// 無敵が発動する場合は明滅アニメーションを開始する
	if( $obj.f[0] == 0 && $$get_hhp_player_invincible_time > 0 )
	{
		$obj.bright_eve.turn(128, 196, 1000, 0, 0)
		$obj.f[0] = 1
	}
	
	// 無敵が終了する場合はアニメーションを終了する
	elseif( $obj.f[0] == 1 && $$get_hhp_player_invincible_time <= 0 )
	{
		$obj.f[0] = 0
		$obj.bright_eve.set(0, 1000, 0, 0)
	}
}

// プレイヤーシールド(フェンス)の画像を更新する(アイテムレベルに応じて)
command $$update_hhp_player_shield_image(property $item_level)
{
	// deb
	;front.object[<HHP_OBJ_PLAYER_SHIELD>].patno = $item_level
}

//---------------------------------------------------------------------------
// 奥義ボタン
//---------------------------------------------------------------------------
// 作成する
command $$create_hhp_skill_button(property $obj : object)
{
	$$create_ui_button($obj, "__mng_hp_skill_btn", 812, 776, <HHP_BTN_SKILL>, <HHP_BTNGROUP_NORMAL>, 1)
	$obj.layer = <HHP_LAYER_UI>
	$obj.set_button_state_disable
	
	$obj.child.resize(2)
	$obj.child[0].create("__mng_hp_skill_bar", 1, 34, 34)
	$obj.child[0].set_src_clip(1, 0, 0, $obj.child[0].get_size_x, $obj.child[0].get_size_y)
	
	$obj.child[1].create("__mng_hp_skill_overlay", 1, 63, 100)
	
	$$set_hhp_button($obj)
	
	// 更新する
	$$update_hhp_skill_button($obj)
}

// 更新する
command $$update_hhp_skill_button(property $obj : object)
{
	// 終了している場合
	if( $$is_hhp_wave_over )
	{
		$obj.all_eve.end
		return
	}
	
	// 奥義が使用可能の場合
	if( $$get_hhp_skill_power >= <HHP_ACTIVATE_SKILL_POWER> )
	{
		$obj.child[0].disp = 0
		$obj.child[1].disp = 0
		
		$obj.set_button_state_normal
		if( $obj.bright_eve.check == 0 )
		{
			@SE_ヘビパ_スキルゲージ最大
			$obj.bright_eve.turn(0, 192, 1000, 0, 2)
		}
	}
	
	// 奥義が使用不可の場合
	else
	{
		b[1] = $$get_hhp_skill_power
		b[2] = <HHP_ACTIVATE_SKILL_POWER>
		$obj.child[0].disp = 1
		$obj.child[1].disp = 1
		$obj.child[0].src_clip_top = math.linear($$get_hhp_skill_power, 0, $obj.child[0].get_size_y, <HHP_ACTIVATE_SKILL_POWER>, 0)
		
		$obj.set_button_state_disable
		if( $obj.bright_eve.check ) {
			$obj.bright_eve.end
		}
	}
}

//---------------------------------------------------------------------------
// 一時停止ボタン
//---------------------------------------------------------------------------
// 作成する
command $$create_hhp_pause_button(property $obj : object)
{
	$$create_ui_button($obj, "__mng_hp_pause_btn", 1810, 416, <HHP_BTN_PAUSE>, <HHP_BTNGROUP_NORMAL>, 1)
	$obj.layer = <HHP_LAYER_UI>
	
	$$set_hhp_button($obj)
	
	// 更新する
	$$update_hhp_pause_button($obj)
}

// 更新する
command $$update_hhp_pause_button(property $obj : object)
{
	if( $$is_hhp_wave_over )
	{
		$obj.set_button_state_disable
	}
	else
	{
		$obj.set_button_state_normal
	}
}

//---------------------------------------------------------------------------
// メインＵＩ
//---------------------------------------------------------------------------
// 作成する
command $$create_hhp_main_ui(property $obj : object)
{
	$obj.disp = 1
	$obj.layer = <HHP_LAYER_UI>
	$obj.child.resize(c_max)
	
	$player_life_disp = $$get_hhp_player_life
	$player_life_target = $player_life_disp
	$score_disp		= 0
	$score_target	= 0
	$score_interep	= 0
	
	$$create_player_lifebar($obj.c_player_lifebar)	// プレイヤーライフバー
	$$create_game_level($obj.c_game_level)			// ゲームレベル
	$$create_score($obj.c_score)					// スコア
	$$create_rewards($obj.c_rewards)				// 報酬ＢＯＸ
	$$create_item_list($obj.c_item_list)			// アイテムリスト
	$$create_support_chara($obj.c_support)			// サポートキャラ
	$$create_combo_counter($obj.c_combo)			// コンボカウンター
	$$create_time_limit($obj.c_time_limit)			// 時間制限
	$$create_boss_lifebar($obj.c_boss_lifebar)		// ボスライフバー
	$$create_caution_filter($obj.c_caution_filter)	// ピンチフィルター
	
	// システムメッセージ
	$$create_sys_message(front.object[<HHP_OBJ_SYS_MESSAGE>])
	
	/*
	$$create_defegg_countdown($obj.child[10])			// 終了までのカウントダウン(5秒前から)
	*/
}

// 更新する
command $$update_hhp_main_ui(property $obj : object)
{
	$$update_player_lifebar($obj.c_player_lifebar)		// プレイヤーライフバー
	$$update_game_level($obj.c_game_level)				// ゲームレベル
	$$update_score($obj.c_score)						// スコア
	$$update_rewards($obj.c_rewards)					// 報酬ＢＯＸ
	$$update_item_list($obj.c_item_list)				// アイテムリスト
	$$update_combo_counter($obj.c_combo)				// コンボカウンター
	$$update_time_limit($obj.c_time_limit)				// 時間制限
	$$update_boss_lifebar($obj.c_boss_lifebar)			// ボスライフバー
	$$update_caution_filter($obj.c_caution_filter)		// ピンチフィルター
	
	/*
	$$update_defegg_time_limit($obj.child[<UI_TIME_LIMIT>])					// 時間制限
	$$update_defegg_countdown($obj.child[10])			// 終了までのカウントダウン(5秒前から)
	*/
}

//---------------------------------------------------------------------------
// プレイヤーライフバー
//---------------------------------------------------------------------------
// 作成する
command $$create_player_lifebar(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_player_life_bar_bg", 1, 55, 905)
	$obj.child.resize(6)
	
	// バー背景
	$obj.child[0].create("__mng_hp_player_life_bar", 1, 21, 63, 1)
	
	// バー
	$obj.child[1].create("__mng_hp_player_life_bar", 1, 21, 63)
	$obj.child[1].f.resize(1)
	$obj.child[1].f_image_size_x = $obj.child[1].get_size_x		// 画像サイズを保存する
	$obj.child[1].set_src_clip(1, 0, 0, $obj.child[1].f_image_size_x, $obj.child[1].get_size_y)
	
	// 回復エフェクト
	$obj.child[2].create("__mng_hp_ef_recover", 1, 23, -82)
	$obj.child[2].blend = 4
	
	// 現在のライフ
	$obj.child[3].create_number("__mng_hp_player_life_bar_number", 1, 521, 69)
	$obj.child[3].set_number_param(3, 0, 0, 0, 0, 0)
	
	// ライフ最大値
	$obj.child[4].create_number("__mng_hp_player_life_bar_number", 1, 601, 69)
	$obj.child[4].set_number_param(3, 0, 0, 0, 0, 0)
	
	// オーバーレイ
	$obj.child[5].create("__mng_hp_player_life_bar_overlay", 1, 587, 69)
	
	// 更新する
	$$update_player_lifebar($obj)
}

// 更新する
command $$update_player_lifebar(property $obj : object)
{
	// 回復エフェクト
	if( $$get_hhp_player_life != $player_life_target )
	{
		if( $player_life_target < $$get_hhp_player_life )
		{
			@ＳＥ_ヘビパ_回復			// todo 回復SE
			
			$obj.child[2].disp = 1
			$obj.child[2].patno = 0
			$obj.child[2].patno_eve.set(39, 1500, 0, 0)
		}
		
		$player_life_target = $$get_hhp_player_life
		$player_life_disp = $player_life_target
	}
	
	// バー
	$obj.child[1].src_clip_right = math.linear($player_life_disp, 0, 0, $$get_hhp_player_life_max, $obj.child[1].f_image_size_x)
	
	// 現在のライフ
	$obj.child[3].set_number($$get_hhp_player_life)
	
	// ライフ最大値
	$obj.child[4].set_number($$get_hhp_player_life_max)
}

//---------------------------------------------------------------------------
// ゲームレベル
//---------------------------------------------------------------------------
// 作成する
command $$create_game_level(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_level", 1, 39, 33)
	$obj.child.resize(1)
	
	// 更新する
	$$update_game_level($obj)
}

// 更新する
command $$update_game_level(property $obj : object)
{
	$obj.patno = $$get_hhp_play_level - 1
}

//---------------------------------------------------------------------------
// スコア
//---------------------------------------------------------------------------
// 作成する
command $$create_score(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_score_bg", 1, 1456, 29)
	$obj.child.resize(1)
	
	// 数値
	$obj.child[0].create_number("__mng_hp_score_number", 1, 100, 47)
	$obj.child[0].set_number_param(8, 0, 0, 0, 0, -6)
	
	// 更新する
	$$update_score($obj)
}

// 更新する
command $$update_score(property $obj : object)
{
	property $score
	
	// 現在のスコアを取得する
	$score = $$get_hhp_score
	
	// 現在のスコアと目標スコアが違う場合
	if( $score != $score_target )
	{
		// 目標スコアを更新する
		$score_target = $score
		
		// 目標スコアと表示スコアの差から加算するスコアを取得する
		$score_interep = ($score_target - $score_disp) /  25
		if( $score_interep <= 0 )
		{
			$score_interep = 1
		}
	}
	
	// 目標スコアに表示スコアが追い付いていない場合は加算表示をする
	if( $score_disp < $score_target )
	{
		$score_disp += $score_interep
		
		if( $score_disp > $score_target )
		{
			$score_disp = $score_target
		}
		
		// 数値
		$obj.child[0].set_number($score_disp)
	}
	
	if( $score_disp > $score_target )
	{
		$score_disp -= $score_interep
		
		if( $score_disp < $score_target )
		{
			$score_disp = $score_target
		}
		
		// 数値
		$obj.child[0].set_number($score_disp)
	}
}

//---------------------------------------------------------------------------
// 報酬ＢＯＸ
//---------------------------------------------------------------------------
// 作成する
command $$create_rewards(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_rewards_icon_bg", 1, 1667, 160)
	$obj.child.resize(1)
	
	// 数値
	$obj.child[0].create_number("__mng_hp_score_number", 1, 62, 30)
	$obj.child[0].set_number_param(3, 0, 0, 0, 0, 0)
	
	// 更新する
	$$update_rewards($obj)
}

// 更新する
command $$update_rewards(property $obj : object)
{
	// 数値
	$obj.child[0].set_number($$get_hhp_rewards_num)
}

//---------------------------------------------------------------------------
// アイテムリスト
//---------------------------------------------------------------------------
// 作成する
command $$create_item_list(property $obj : object)
{
	$obj.disp = 1
	$obj.f.resize(5)
	
	// 更新する
	$$update_item_list($obj)
}

// 更新する
command $$update_item_list(property $obj : object)
{
	property $i
	property $len
	
	$len = $$get_hhp_item_count
	
	// 所持アイテム数が変わっている場合は更新する
	if( $obj.f[0] != $len || $obj.f[4] == 1 )
	{
		$obj.f[4] = 0
		
		$obj.child.resize($len)
		for( $i = 0, $i < $len, $i += 1 )
		{
			$obj.child[$i].create("__mng_hp_item_icon", 1, 32, 147 + 162 * ($i % <ITEM_DISP_NUM>))
			$obj.child[$i].patno = $$get_hhp_item_icon_no($$get_hhp_item_id_from_list_index($i), $$get_hhp_item_level_from_list_index($i))
		}
		
		$obj.f[0] = $len
		
		if( $len > <ITEM_DISP_NUM> )
		{
			$obj.f[1] = $len / <ITEM_DISP_NUM>
			$obj.f[2] = 0
			$obj.f[3] = 0
			
			for( $i = <ITEM_DISP_NUM>, $i < $len, $i += 1 )
			{
				$obj.child[$i].disp = 0
			}
		}
	}
	
	if( $obj.f[1] )
	{
		$obj.f[3] += $$get_delta_time
		
		if( $obj.f[3] >= 5000 )
		{
			$obj.f[2] += 1
			if( $obj.f[2] > $len / <ITEM_DISP_NUM> ) {
				$obj.f[2] = 0
			}
			
			for( $i = 0, $i < $len, $i += 1 )
			{
				if( $i / <ITEM_DISP_NUM> == $obj.f[2] ) {
					$obj.child[$i].disp = 1
				} else {
					$obj.child[$i].disp = 0
				}
			}
			
			$obj.f[3] = 0
		}
	}
}

// アイテムリストを強制更新する
command $$update_hhp_item_list_force
{
	front.object[<HHP_OBJ_MAIN_UI>].c_item_list.f[4] = 1
}

//---------------------------------------------------------------------------
// サポートキャラ
//---------------------------------------------------------------------------
// 作成する
command $$create_support_chara(property $obj : object)
{
	property $i
	property $len
	
	$len = $$get_hhp_skill_count
	
	$obj.disp = 1
	$obj.child.resize($len)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$obj.child[$i].create(_mng_hp_support_icon, 1, 1187 + $i * 220, 875, $$get_hhp_skill_id_from_index($i))
	}
}

//---------------------------------------------------------------------------
// コンボカウンター
//---------------------------------------------------------------------------
// 作成する
command $$create_combo_counter(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_combo_bg", 1, 1682, 271, 1)
	$$set_image_center_rep($obj)
	$obj.f.resize(1)
	$obj.child.resize(2)
	
	// コンボ文字
	$obj.child[0].create("__mng_hp_combo_bg", 1)
	
	// 数値
	$obj.child[1].create_number("__mng_hp_combo_number", 1, 42, 41)
	$obj.child[1].set_number_param(3, 0, 0, 0, 0, 0)
	$obj.child[1].x_rep.resize(1)
	
	// 更新する
	$$update_combo_counter($obj)
}

// 更新する
command $$update_combo_counter(property $obj : object)
{
	if( $$get_hhp_player_combo < 10 ) {
		// １桁
		$obj.child[1].x_rep[0] = -$obj.child[1].get_size_x
	}
	elseif( $$get_hhp_player_combo < 100 ) {
		// ２桁
		$obj.child[1].x_rep[0] = -$obj.child[1].get_size_x / 2
	}
	elseif( $$get_hhp_player_combo < 1000 ) {
		// ３桁
		$obj.child[1].x_rep[0] = 0
	}
	elseif( $$get_hhp_player_combo < 10000 ) {
		// ４桁
		$obj.child[1].x_rep[0] = -$obj.child[1].get_size_x / 2
	} else {
		// ５桁
		$obj.child[1].x_rep[0] = -$obj.child[1].get_size_x
	}
	
	if( $obj.f[0] != $$get_hhp_player_combo )
	{
		$obj.child[1].set_number($$get_hhp_player_combo)
		$obj.f[0] = $$get_hhp_player_combo
		
		$obj.bright = 128
		$obj.bright_eve.set(0, 250, 0, 2)
		$obj.set_scale(1500, 1500)
		$obj.scale_x_eve.set(1000, 250, 0, 2)
		$obj.scale_y_eve.set(1000, 250, 0, 2)
	}
}

//---------------------------------------------------------------------------
// 時間制限
//---------------------------------------------------------------------------
// 作成する
command $$create_time_limit(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_time_bg", 1, 824, 41)
	$obj.child.resize(1)
	
	// 数値
	$obj.child[0].create_number("__mng_hp_time_number", 1, 109, 25)
	$obj.child[0].set_number_param(2, 0, 0, 0, 0, 0)
	$obj.child[0].color_r = 255
	
	// 更新する
	$$update_time_limit($obj)
}

// 更新する
command $$update_time_limit(property $obj : object)
{
	property $time
	
	if( $$is_hhp_boss_wave ) {
		return
	}
	
	$time = $$get_hhp_time_limit
	
	if( $time_limit_old == $time ) {
		return
	}
	
	$time_limit_old = $time
	
	// 数値
	$obj.child[0].set_number($time)
	
	// 残り５秒以下で色を変更する todo shake
	if( $time <= 5 )
	{
		$obj.child[0].color_rate = 255
	}
	else
	{
		$obj.child[0].color_rate = 0
	}
}

//---------------------------------------------------------------------------
// ボスライフバー
//---------------------------------------------------------------------------
// 作成する
command $$create_boss_lifebar(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_boss_life_bar_bg", 0, 481, 42)
	$obj.child.resize(2)
	
	// バー背景
	$obj.child[0].create("__mng_hp_boss_life_bar", 1, 153, 34, 1)
	
	// バー本体
	$obj.child[1].create("__mng_hp_boss_life_bar", 1, 153, 34)
	$obj.child[1].f.resize(1)
	$obj.child[1].f_image_size_x = $obj.child[1].get_size_x		// 画像サイズを保存する
	$obj.child[1].set_src_clip(1, 0, 0, $obj.child[1].f_image_size_x, $obj.child[1].get_size_y)
	
	// 更新する
	$$update_boss_lifebar($obj)
}

// 更新する
command $$update_boss_lifebar(property $obj : object)
{
	if( $$is_hhp_boss_wave == 0 ) {
		return
	}
	
	// バー
	$obj.child[1].src_clip_right = math.linear(front.object[<HHP_OBJ_BOSS>].f_enemy_life, 0, 0, front.object[<HHP_OBJ_BOSS>].f_enemy_life_max, $obj.child[1].get_size_x)
}

// 表示アニメーション
command $$show_hhp_boss_lifebar_animation
{
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.y_rep.resize(1)
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.y_rep[0] = 20
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.y_rep_eve[0].set(0, 500, 0, 2)
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.tr = 0
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.tr_eve.set(255, 500, 0, 2)
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.disp = 1
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.disp = 1
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.child[1].src_clip_right = 0
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.child[1].src_clip_right_eve.set(front.object[<HHP_OBJ_MAIN_UI>].c_boss_lifebar.child[1].get_size_x, 500, 750, 2)
}

//---------------------------------------------------------------------------
// ボス出現（warning）アニメーション
//---------------------------------------------------------------------------
// 表示する
command $$show_hhp_boss_warning_animation
{
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_warning.create("__mng_hp_boss_warning", 1, 0, 411)
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_warning.child.resize(1)
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_warning.child[0].create("__mng_hp_boss_warning", 1, 1792, 0)
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_warning.x_eve.loop(0, -1343, 5000, 0, 0)
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_warning.bright_eve.turn(0, 64, 750, 0, 2)
}

// 非表示にする
command $$hide_hhp_boss_warning_animation
{
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_warning.disp = 0
	front.object[<HHP_OBJ_MAIN_UI>].c_boss_warning.all_eve.end
}

//---------------------------------------------------------------------------
// ピンチフィルター
//---------------------------------------------------------------------------
// 作成する
command $$create_caution_filter(property $obj : object)
{
	front.object[<HHP_OBJ_MAIN_UI>].c_caution_filter.create("ef_eye_filter")
	front.object[<HHP_OBJ_MAIN_UI>].c_caution_filter.color_r = 255
	front.object[<HHP_OBJ_MAIN_UI>].c_caution_filter.color_rate = 255
	front.object[<HHP_OBJ_MAIN_UI>].c_caution_filter.tr_eve.turn(32, 96, 1000, 0, 2)
}

// 更新する
command $$update_caution_filter(property $obj : object)
{
	if( $$get_hhp_player_life <=  $$get_hhp_player_life_max / 5 )
	{
		front.object[<HHP_OBJ_MAIN_UI>].c_caution_filter.disp = 1
	}
	else
	{
		front.object[<HHP_OBJ_MAIN_UI>].c_caution_filter.disp = 0
	}
}

//---------------------------------------------------------------------------
// システムメッセージ
//---------------------------------------------------------------------------
// 作成する
command $$create_sys_message(property $obj : object)
{
	// 背景
	$obj.create("__mng_hp_sys_message", 0, 0, 420)
	$obj.layer = <HHP_LAYER_SYS_MESSAGE>
	$obj.y_rep.resize(2)
	$obj.tr_rep.resize(1)
	$obj.child.resize(1)
	
	// テキスト
	$obj.child[0].create_string("", 1)
	$obj.child[0].set_string_param(<SYS_MESSAGE_FONT_SIZE>, 0, 0, 99, 0, -1, -1, -1)
}

// 更新する
command $$update_sys_message(property $obj : object, property $text : str)
{
	$obj.child[0].set_string($text)
	
	// テキストのセンタリング
	$obj.child[0].x = <SCREEN_CENTER_X> + ($obj.get_size_x - $text.len * <SYS_MESSAGE_FONT_SIZE> / 2) / 2 - $obj.get_size_x / 2
	$obj.child[0].y = ($obj.get_size_y - <SYS_MESSAGE_FONT_SIZE>) / 2 - 5
}

// 表示する
command $$show_hhp_sys_message(property $text : str, property $offset_y)
{
	$$update_sys_message(front.object[<HHP_OBJ_SYS_MESSAGE>], $text)
	
	front.object[<HHP_OBJ_SYS_MESSAGE>].disp = 1
	front.object[<HHP_OBJ_SYS_MESSAGE>].y_rep[0] = $offset_y
	front.object[<HHP_OBJ_SYS_MESSAGE>].y_rep[1] = 50
	front.object[<HHP_OBJ_SYS_MESSAGE>].y_rep_eve[1].set(0, 500, 0, 2)
	front.object[<HHP_OBJ_SYS_MESSAGE>].tr = 0
	front.object[<HHP_OBJ_SYS_MESSAGE>].tr_eve.set(255, 500, 0, 2)
	front.object[<HHP_OBJ_SYS_MESSAGE>].tr_rep[0] = 255
	front.object[<HHP_OBJ_SYS_MESSAGE>].tr_rep_eve[0].set(0, 250, 5000, 2)
	front.object[<HHP_OBJ_SYS_MESSAGE>].bright_eve.turn(0, 32, 1000, 0, 2)
}

// 非表示にする
command $$hide_hhp_sys_message
{
	front.object[<HHP_OBJ_SYS_MESSAGE>].all_eve.end
	
	front.object[<HHP_OBJ_SYS_MESSAGE>].y_rep[1] = 0
	front.object[<HHP_OBJ_SYS_MESSAGE>].y_rep_eve[1].set(-50, 500, 0, 2)
	
	front.object[<HHP_OBJ_SYS_MESSAGE>].tr_rep[0] = 255
	front.object[<HHP_OBJ_SYS_MESSAGE>].tr_rep_eve[0].set(0, 250, 0, 2)
}

//---------------------------------------------------------------------------
// 画面を揺らす
//---------------------------------------------------------------------------
command $$shake_hhp_screen(property $type)
{
	switch( $type ) {
		
	case(0)		// 揺れ（小）
		screen.quake[0].start(1, 120, 2, 0, 0, 0, [10, 0])
		screen.quake[1].start(1,  70, 2, 0, 0, 0, [10, 6])
		
	case(1)		// 揺れ（中）
		screen.quake[0].start(1, 240, 3, 0, 0, 0, [20, 0])
		screen.quake[1].start(1, 190, 3, 0, 0, 0, [20, 6])
		
	case(2)		// 揺れ（大）
		screen.quake[0].start(1, 360, 4, 0, 0, 0, [30, 0])
		screen.quake[1].start(1, 310, 4, 0, 0, 0, [30, 6])
	}
}


//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	$stage.object[<HHP_DUMMY>].joypad_up    = <HHP_BTN_SKILL>
	$stage.object[<HHP_DUMMY>].joypad_down  = <HHP_BTN_SKILL>
	$stage.object[<HHP_DUMMY>].joypad_left  = <HHP_BTN_SKILL>
	$stage.object[<HHP_DUMMY>].joypad_right = <HHP_BTN_SKILL>
	
	$stage.object[<HHP_BTN_SKILL>].joypad_up    = <HHP_BTN_PAUSE>
	$stage.object[<HHP_BTN_SKILL>].joypad_down  = <HHP_DUMMY>
	$stage.object[<HHP_BTN_SKILL>].joypad_left  = <HHP_DUMMY>
	$stage.object[<HHP_BTN_SKILL>].joypad_right = <HHP_DUMMY>
	
	$stage.object[<HHP_BTN_PAUSE>].joypad_up    = <HHP_DUMMY>
	$stage.object[<HHP_BTN_PAUSE>].joypad_down  = <HHP_BTN_SKILL>
	$stage.object[<HHP_BTN_PAUSE>].joypad_left  = <HHP_DUMMY>
	$stage.object[<HHP_BTN_PAUSE>].joypad_right = <HHP_DUMMY>
	
	$$set_joypad_focus_button(<HHP_DUMMY>)
}


//---------------------------------------------------------------------------
// ヘビヘビパニックのフォントを有効にする
//---------------------------------------------------------------------------
command $$hhp_font_enable
{
	script.set_allow_joypad_mode_onoff(1)
	
	if( excall.check_alloc )
	{
		excall.script.set_font_name("Zen Maru Gothic Black")
		excall.script.set_font_bold(0)
		excall.script.set_font_shadow(0)
	}
	else
	{
		script.set_font_name("Zen Maru Gothic Black")
		script.set_font_bold(0)
		script.set_font_shadow(0)
	}
}

//---------------------------------------------------------------------------
// ヘビヘビパニックのフォントを無効にする
//---------------------------------------------------------------------------
command $$hhp_font_disable
{
	script.set_allow_joypad_mode_onoff_default
	
	if( excall.check_alloc )
	{
		excall.script.set_font_name_default
		excall.script.set_font_bold_default
		excall.script.set_font_shadow_default
	}
	else
	{
		script.set_font_name_default
		script.set_font_bold_default
		script.set_font_shadow_default
	}
}


//---------------------------------------------------------------------------
// ヘビヘビパニックで使用するボタンにする
//---------------------------------------------------------------------------
command $$set_hhp_button(property $obj : object)
{
	$obj.f.resize(<HHP_BTN_F_FLAG_MAX>)
	$obj.f_btn_scale_normal = 1000		// 通常の拡縮率
	$obj.f_btn_scale_hit    = 1050		// ボタンが当たっている場合の拡縮率
	$obj.f_btn_scale_push   =  950		// ボタンが押されている場合の拡縮率
	
	$obj.frame_action.start(-1, "$$fa_hhp_button")
}

// へビヘビヘビパニックで使用するボタンのフレームアクション
command $$fa_hhp_button(property $fa : frameaction, property $obj : object)
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
	
	if( $obj.f_btn_state == 3 )
	{
		if( $obj.get_button_real_state == 2 ) {
			return
		}
		
		if( $obj.scale_x_eve.check ) {
			return
		}
		
		$obj.scale_x_eve.set($obj.f_btn_scale_normal, 0, 0, 1)
		$obj.scale_y_eve.set($obj.f_btn_scale_normal, 0, 0, 1)
		
		$obj.f_btn_state = 0
	}
	
	switch( $state ) {
	case(0)
		
		if( $obj.f_btn_state == 1 || $obj.f_btn_state == 2 )
		{
			if( $obj.scale_x_eve.check ) {
				return
			}
			
			$obj.scale_x_eve.set($obj.f_btn_scale_normal, 0, 0, 2)
			$obj.scale_y_eve.set($obj.f_btn_scale_normal, 0, 0, 2)
			
			$obj.f_btn_state = 0
		}
		
	case(1)
		
		if( $obj.f_btn_state == 0 || $obj.f_btn_state == 2 )
		{
			if( $obj.scale_x_eve.check ) {
				return
			}
			
			$obj.scale_x_eve.set($obj.f_btn_scale_hit, 0, 0, 2)
			$obj.scale_y_eve.set($obj.f_btn_scale_hit, 0, 0, 2)
			
			$obj.f_btn_state = 1
		}
		
	case(2)
		
		if( $obj.f_btn_state == 1 )
		{
			if( $obj.scale_x_eve.check ) {
				return
			}
			
			$obj.scale_x_eve.set($obj.f_btn_scale_push, 0, 0, 2)
			$obj.scale_y_eve.set($obj.f_btn_scale_push, 0, 0, 2)
			
			$obj.f_btn_state = 3
		}
	}
}

//---------------------------------------------------------------------------
// ヘビヘビパニックで使用するボタンの拡縮率を設定する
//---------------------------------------------------------------------------
command $$set_hhp_button_scale(property $obj : object, property $normal, property $hit, property $push)
{
	$obj.f_btn_scale_normal = $normal		// 通常の拡縮率
	$obj.f_btn_scale_hit    = $hit			// ボタンが当たっている場合の拡縮率
	$obj.f_btn_scale_push   = $push			// ボタンが押されている場合の拡縮率
}












//---------------------------------------------------------------------------
// 終了カウントダウン
//---------------------------------------------------------------------------
// 作成する
command $$create_defegg_countdown(property $obj : object)
{
	// 背景
	$obj.create(_mng_df_countdown, 0, 770, 290)
	$obj.tr = 128
	$obj.child.resize(1)
	
	// 数値
	$obj.child[0].create(_mng_df_countdown, 1, 10, 30, 1)
	$$set_image_center_rep($obj.child[0])
	
	$obj.f.resize(1)
	$obj.f[0] = 0
	$obj.disp = 0
}

// 更新する
command $$update_defegg_countdown(property $obj : object)
{
	if( $$is_hhp_boss_wave ) {
		return
	}
	
	if( $$get_hhp_time_limit <= 5 )
	{
		if( $$get_hhp_time_limit != $obj.f[0] )
		{
			$obj.disp = 1
			
			$obj.f[0] = $$get_hhp_time_limit
			$obj.child[0].patno = $obj.f[0] + 1
			$obj.child[0].set_scale(1100, 1100)
			$obj.child[0].scale_x_eve.set(1000, 500, 0, 2)
			$obj.child[0].scale_y_eve.set(1000, 500, 0, 2)
			
			if( $obj.f[0] == 0 )
			{
				$obj.tr_eve.set(0, 500, 1000, 2)
			}
		}
	}
}

// 表示する
#inc_start
	#define		@obj_tutorial	front.object[19]
#inc_end

//---------------------------------------------------------------------------
// チュートリアル
//---------------------------------------------------------------------------
command $$show_defegg_tutorial(property $no)
{
	if( $no <= $$get_hhp_tutorial_flag) {
		return
	}
	
	@mng_counter.stop
	
	@obj_tutorial.create(_mng_df_tutorial + math.tostr_zero($no, 2), 1)
	@obj_tutorial.layer = 10000
	@obj_tutorial.tr = 0
	@obj_tutorial.tr_eve.set(255, 500, 0, 2)
	@obj_tutorial.y = 50
	@obj_tutorial.y_eve.set(0, 500, 0, 2)
	@obj_tutorial.y_eve.wait
	R
	@obj_tutorial.tr_eve.set(0, 500, 0, 2)
	@obj_tutorial.y_eve.set(50, 500, 0, 2)
	@obj_tutorial.y_eve.wait
	
	$$set_hhp_tutorial_flag($no)
	
	@mng_counter.resume
}
