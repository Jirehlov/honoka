//===========================================================================
//!
//!    @file     ___mng_hhp_debug.ss
//!    @brief    ヘビヘビパニックデバッグ機能
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// ボタン番号
	#replace	<BTN_H1>			100			// ボタン(分類１)開始番号
	#replace	<BTN_H2>			110			// ボタン(分類２)開始番号
	
	// ボタン設定
	#replace	<BTN_BASE_X>			380			// ボタン基本座標(x)
	#replace	<BTN_BASE_Y>			20			// ボタン基本座標(y)
	#replace	<BTN_SIZE_X>			128			// ボタンサイズ(x)
	#replace	<BTN_SIZE_Y>			64			// ボタンサイズ(y)
	#replace	<BTN_MARGIN_X>			10			// ボタン間のマージン(x)
	#replace	<BTN_MARGIN_Y>			10			// ボタン間のマージン(y)
	#replace	<BTN_SCROLL_NUM>		12			// スクロール処理が発生するボタン最大数
	
	// ボタンカラー
	#replace	<BTN_COLOR_RED>			"##F7402F"	// 赤
	#replace	<BTN_COLOR_GREEN>		"##5AA42B"	// 緑
	#replace	<BTN_COLOR_BLUE>		"##402FF7"	// 青
	#replace	<BTN_COLOR_YELLOW>		"##FFA500"	// 黄
	#replace	<BTN_COLOR_PURPLE>		"##F700F7"	// 紫
	#replace	<BTN_COLOR_ORANGE>		"##F15A22"	// 橙
	#replace	<BTN_COLOR_CYAN>		"##00FFFF"	// シアン
	
	// 変数
	#property	$select_btn			// 選択しているボタン
	#property	$h1_index			// 分類１で選択されたボタン
	#property	$h2_index			// 分類２で選択されたボタン
	
	#property	$collision_disp		// 当たり判定表示フラグ
	
#inc_end

#z00

//---------------------------------------------------------------------------
// デバッグシステムを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_debug_system
{
	if( system.check_debug_flag == 0 ) {
		return
	}
	
	// デバッグＵＩを作成する
	$$create_hhp_debug_ui(front.object[<HHP_OBJ_DEBUG>])
	
	// ボタン入力制御を開始する
	front.objbtngroup[<MNG_OBJBTN_GROUP_DEBUG>].start
}

//---------------------------------------------------------------------------
// デバッグシステムを更新する
//---------------------------------------------------------------------------
command $$update_hhp_debug_system
{
	property $select_btn
	
	if( system.check_debug_flag == 0 ) {
		return
	}
	
	// ボタン入力制御を更新する
	$select_btn = front.objbtngroup[<MNG_OBJBTN_GROUP_DEBUG>].get_decided_no
	
	// 一時停止／解除
	if( key['1'].on_down ) {
		$$set_hhp_pause_flag($$reverse_flag($$get_hhp_pause_flag))
		script.set_time_stop_flag($$get_hhp_pause_flag)
	}
	
	// デバッグ表示／非表示
	if( key['2'].on_down ) {
		front.object[<HHP_OBJ_DEBUG>].disp = $$reverse_flag(front.object[<HHP_OBJ_DEBUG>].disp)
	}
	
	// オートプレイ／解除
	if( key['3'].on_down ) {
		$$set_hhp_autoplay_flag($$reverse_flag($$get_hhp_autoplay_flag))
	}
	
	// ゴッドモード有効／無効
	if( key['4'].on_down ) {
		switch( $$get_hhp_god_mode_flag ) {
		case(<HHP_GOD_MODE_NONE>)		$$set_hhp_god_mode_flag(<HHP_GOD_MODE_NORMAL>)
		case(<HHP_GOD_MODE_NORMAL>)		$$set_hhp_god_mode_flag(<HHP_GOD_MODE_NO_DAMAGE>)
		case(<HHP_GOD_MODE_NO_DAMAGE>)	$$set_hhp_god_mode_flag(<HHP_GOD_MODE_NONE>)
		}
	}
	
	// 当たり判定表示有効／無効
	if( key['5'].on_down ) {
		$collision_disp = $$reverse_flag($collision_disp)
	}
	
	// 制限時間の更新有効／無効
	if( key['6'].on_down ) {
		$$set_hhp_time_limit_stop_flag($$reverse_flag($$get_hhp_time_limit_stop_flag))
	}
	
	// 強制勝利
	if( key['7'].on_down ) {
		$$set_hhp_play_result(<HHP_PLAY_RESULT_WIN>)
		return (1)
	}
	
	// 強制敗北
	if( key['8'].on_down ) {
		$$set_hhp_play_result(<HHP_PLAY_RESULT_LOSE>)
		return (1)
	}
	
	// 分類１ボタンが押された場合
	if( <BTN_H1> <= $select_btn && $select_btn < <BTN_H2> )
	{
		$h1_index = $select_btn - <BTN_H1>					// 選択されたボタンを保存する
		$h2_index = -1
		$$create_h2_button(front.object[<HHP_OBJ_DEBUG>].child[2].child[1])		// 分類２ボタンを作成する
	}
	
	// 分類２ボタンが押された場合
	elseif( <BTN_H2> <= $select_btn )
	{
		$h2_index = $select_btn - <BTN_H2>					// 選択されたボタンを保存する
	}
	
	// 何らかのボタンが押された場合
	if( $select_btn != -2 )
	{
		// 選択されたボタンの処理を実行する
		$$execute_select_button
		
		// ボタン入力制御を開始する
		front.objbtngroup[<MNG_OBJBTN_GROUP_DEBUG>].start
	}
	
	// ポップアップテスト
	if( key['B'].on_down ) {
		farcall("___mng_hhp_flow_popup", 0, <HHP_RESULT_POPUP_TYPE_ALL_WIN>)
	}
	if( key['N'].on_down ) {
		farcall("___mng_hhp_flow_popup", 0, <HHP_RESULT_POPUP_TYPE_WAVE_WIN>)
	}
	if( key['M'].on_down ) {
		farcall("___mng_hhp_flow_popup", 0, <HHP_RESULT_POPUP_TYPE_WAVE_LOSE>)
	}
	
		// todo 報酬取得
		if( key['E'].on_down ) {
			farcall(___mng_hhp_flow_rewards)
		}
		
		// 奥義ゲージ最大
		if( key['V'].on_down ) {
			$$add_hhp_skill_power($$get_hhp_skill_power_max)
		}
		
	// デバッグ表示がされている場合のみ
	if( front.object[<HHP_OBJ_DEBUG>].disp )
	{
		
		// リスタート
		if( key['R'].on_down ) {
			$$restart_hhp_player_data
		}
		
		// スキルテスト
		if( key['F'].on_down ) {
			$$powerup_hhp_item(1)
		}
	}
	
	// デバッグＵＩを更新する
	if( front.object[<HHP_OBJ_DEBUG>].disp ) {
		$$update_hhp_debug_ui(front.object[<HHP_OBJ_DEBUG>])
	}
}

//---------------------------------------------------------------------------
// デバッグシステムＵＩを作成する
//---------------------------------------------------------------------------
command $$create_hhp_debug_ui(property $obj : object)
{
	property $i
	
	$obj.init
	$obj.disp = 0
	$obj.layer = <HHP_LAYER_DEBUG>
	$obj.child.resize(9)
	
	// 黒背景(半透明)
	$obj.child[0].create_rect(0, 0, 360, <SCREEN_HEIGHT>, 0, 0, 0, 128, 1)
	
	// ベース > 文字
	$obj.child[1].create_string("", 1, 0, 10)
	$obj.child[1].set_string_param(20, 0, 0, 60, 0, 0, 2, 1)
	
	// 分類１ボタン
	$obj.child[2].create_rect(370, 10, 1370, 460, 0, 0, 0, 128, 1)
	$obj.child[2].child.resize(2)
	$$create_h1_button($obj.child[2].child[0])
	
	// アイテム／スキル
	$obj.child[3].create_rect(370, 470, 1370, <SCREEN_HEIGHT>, 0, 0, 0, 128, 1)
	
	// アイテム／スキル > 文字
	$obj.child[4].create_string("", 1, 370, 480)
	$obj.child[4].set_string_param(20, 0, 0, 60, 0, 0, 2, 1)
	$obj.child[5].create_string("", 1, 770, 480)
	$obj.child[5].set_string_param(20, 0, 0, 60, 0, 0, 2, 1)
	
	// 報酬
	$obj.child[6].create_rect(1380, 0, <SCREEN_WIDTH>, <SCREEN_HEIGHT>, 0, 0, 0, 128, 1)
	
	// 報酬 > 文字
	$obj.child[7].create_string("", 1, 1380, 10)
	$obj.child[7].set_string_param(20, 0, 0, 60, 0, 0, 2, 1)
	$obj.child[8].create_string("", 1, 1420, 10)
	$obj.child[8].set_string_param(20, 0, 0, 60, 0, 0, 2, 1)
	
	// 更新する
	$$update_hhp_debug_ui($obj)
}

//---------------------------------------------------------------------------
// デバッグシステムＵＩを更新する
//---------------------------------------------------------------------------
command $$update_hhp_debug_ui(property $obj : object)
{
	property $i
	property $len
	property $min
	property $max
	property $str : str
	
	$str += "'2'キーでデバッグデータ表示/非表示#D" +
			"---------------------------------#D" +
			"'1'キーで一時停止→" + $$get_enabled_text($$get_hhp_pause_flag) + "#D" +
			"'3'キーでオートプレイ→" + $$get_enabled_text($$get_hhp_autoplay_flag) + "#D" +
			"'4'キーでゴッドモード(無敵)→" + $$get_god_mode_text($$get_hhp_god_mode_flag) + "#D" +
			"'5'キーで当たり判定表示→" + $$get_enabled_text($collision_disp) + "#D" +
			"'6'キーで制限時間有効無効→" + $$get_enabled_text($$get_hhp_time_limit_stop_flag) + "#D" +
			"'V'キーで奥義ゲージ最大へ#D" +
			"'E'キーで報酬画面へ#D" +
			"'R'キーでリスタート#D" +
			"---------------------------------#D" +
			"      プレイ回数：" + math.tostr($$get_hhp_total_play_count) + "[" + math.tostr($$get_hhp_global_play_count) + "]#D" +
			"  レベル別＞["
			for( $i = <HHP_PLAY_LEVEL_MIN>, $i <= <HHP_PLAY_LEVEL_MAX>, $i += 1 )
			{
				$str += math.tostr($$get_hhp_play_count($i))
				if( $i != <HHP_PLAY_LEVEL_MAX> ) {
					$str += ","
				} else {
					$str += "]#D"
				}
			}
	$str += "          スコア：" + math.tostr($$get_hhp_score) + "#D" +
			"      ハイスコア：" + math.tostr($$get_hhp_hi_score) + "#D" +
			"---------------------------------#D" +
			"    プレイレベル：" + math.tostr($$get_hhp_play_level) + "/" + math.tostr(<HHP_PLAY_LEVEL_MAX>) + "#D" +
			"    プレイモード："
			if( $$get_hhp_play_mode == <HHP_PLAY_MODE_NORMAL> )		{ $str += "通常#D" }
			else													{ $str += "エンドレス#D" }
	$str += "  ウェーブレベル：" + math.tostr($$get_hhp_wave) + "/" + math.tostr($$get_hhp_wave_max) + "#D" +
			"    スポーン時間：" + math.tostr($$get_hhp_spawn_time) + "#D" +
			"---------------------------------#D" +
			"        攻撃入力：" + math.tostr($$get_hhp_push_attack_key) + " > (" + math.tostr($$get_hhp_push_attack_key_repeat) + "/" + math.tostr($$get_hhp_push_attack_key_repeat_max) + ")#D" +
			"---------------------------------#D" +
			"          ライフ：" + math.tostr($$get_hhp_player_life) + "/" + math.tostr($$get_hhp_player_life_max) + "#D" +
			"      永続ライフ：" + math.tostr($$get_hhp_player_life_permanently) + "#D" +
			"          攻撃力：" + math.tostr($$get_hhp_player_total_attack_power) + "#D" +
			"      永続攻撃力：" + math.tostr($$get_hhp_player_attack_power_permanently) + "#D" +
			"      攻撃力補正：" + math.tostr($$get_hhp_player_total_attack_power_rate) + "%#D" +
			"        攻撃範囲：" + math.tostr($$get_hhp_player_total_attack_range) + "#D" +
			"    範囲攻撃回数：" + math.tostr($$get_hhp_player_attack_range_count) + "/" + math.tostr($$get_hhp_player_attack_range_count_max) + "#D" +
			"        スタン値：" + math.tostr($$get_hhp_player_total_stun_power) + "#D" +
			"          回復率：" + math.tostr($$get_hhp_player_total_regen_power) + "#D" +
			"  クリティカル率：" + math.tostr($$get_hhp_player_total_critical_rate) + "#D" +
			"    クリダメ倍率：" + math.tostr($$get_hhp_player_critical_damage_rate) + "#D" +
			"          ダブル：" + $$get_enabled_text($$get_hhp_player_attack_double) + "#D" +
			"            貫通：" + $$get_enabled_text($$get_hhp_player_attack_penetration) + "#D" +
			"          縦範囲：" + $$get_enabled_text($$get_hhp_player_attack_vertical) + "#D" +
			"          横範囲：" + $$get_enabled_text($$get_hhp_player_attack_horizontal) + "#D" +
			"        無敵有効：" + $$get_enabled_text($$get_hhp_player_invincible_enable) + "#D" +
			"        無敵時間：" + math.tostr($$get_hhp_player_invincible_time) + "#D" +
			"    無敵時間補正：" + "x" + math.tostr($$get_hhp_player_invincible_time_rate / 1000) + "." + math.tostr($$get_hhp_player_invincible_time_rate % 1000) + "#D" +
			"    無敵スタック：" + $$get_enabled_text($$get_hhp_player_invincible_stack_flag) + "#D" +
			"        スパイク：" + math.tostr($$get_hhp_player_spike_power) + "#D" +
			"        蘇生回数：" + math.tostr($$get_hhp_player_rivival_flag) + "#D" +
			"        コンボ数：" + math.tostr($$get_hhp_player_combo) + "#D" +
			"    最大コンボ数：" + math.tostr($$get_hhp_player_combo_max) + "#D" +
			"  コンボタイマー：" + math.tostr($$get_hhp_player_combo_timer) + "#D"
	$str += "---------------------------------#D" +
			"        報酬個数：" + math.tostr($$get_hhp_rewards_num) + "#D" +
			"  高報酬発生補正：" + math.tostr($$get_hhp_rewards_high_tier_rate) + "#D" +
			"報酬リロール回数：" + math.tostr($$get_hhp_rewards_reroll) + "/" + math.tostr($$get_hhp_rewards_reroll_max) + "#D" +
			"      ＳＥタイプ：" + math.tostr($$get_hhp_player_se_type) + "#D"
	
	// 敵リスト
	$str += "---------------------------------#D" +
			"---       敵生成リスト        ---#D" +
			"["
	$len = $$get_hhp_spawn_enemy_list_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$str += math.tostr($$get_hhp_spawn_enemy_list($i)) + ","
	}
	$str += "]#D" +
			"          敵総数：" + math.tostr($$get_hhp_exists_enemy_count) + "#D" +
			"---------------------------------#D"
	
	// 文字列が変更されたときに再描画する
	if( $obj.child[1].get_string != $str ) {
		$obj.child[1].set_string($str)
	}
	
	// スキル
	$str =  "    最大スキル数：" + math.tostr($$get_hhp_skill_max) + "#D" +
			"    スキルパワー：" + math.tostr($$get_hhp_skill_power) + "/" + math.tostr($$get_hhp_skill_power_max) + "#D" +
			"---        所持スキル         ---#D"
	$len = $$get_hhp_skill_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$str += "・" + $$get_hhp_skill_name($$get_hhp_skill_id_from_index($i)) + "#D"
	}
	
	// 文字列が変更されたときに再描画する
	if( $obj.child[4].get_string != $str ) {
		$obj.child[4].set_string($str)
	}
	
	// アイテム
	$str = "---       所持アイテム        ---#D"
	$len = $$get_hhp_item_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$str += "・" + $$get_hhp_item_name($$get_hhp_item_id_from_list_index($i), $$get_hhp_item_level_from_list_index($i)) + "(Lv." + math.tostr($$get_hhp_item_level_from_list_index($i)) + ")"
		
		if( $$get_hhp_item_cooldown_max_from_list_index($i) > 0 )
		{
			$str += "[cool_time=" + math.tostr($$get_hhp_item_cooldown_from_list_index($i)) + "/" + math.tostr($$get_hhp_item_cooldown_max_from_list_index($i)) + "]"
		}
		if( $$get_hhp_item_counter_from_list_index($i) > 0 )
		{
			$str += "[counter=" + math.tostr($$get_hhp_item_counter_from_list_index($i)) + "]"
		}
		
		$str += "#D"
	}
	
	// 文字列が変更されたときに再描画する
	if( $obj.child[5].get_string != $str ) {
		$obj.child[5].set_string($str)
	}
	
	// 報酬
	$str = "各報酬確率#D"
	for( $i = <HHP_ITEM_ID_MIN>, $i < <HHP_ITEM_ID_MAX>, $i += 1 )
	{
		$str += math.tostr($$get_hhp_rewards_weight($i)) + "#D"
	}
	$str += math.tostr($$get_hhp_rewards_total_weight) + "#D"
	
	$str += "選択乱数値 > ["
	$len = $$get_hhp_rewards_list_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$str += math.tostr($$get_hhp_rewards_rand($i)) + ","
	}
	$str += "]#D"
	
	// 文字列が変更されたときに再描画する
	if( $obj.child[7].get_string != $str ) {
		$obj.child[7].set_string($str)
	}
	
	$str = "#D"
	$min = 0
	$max = 0
	for( $i = <HHP_ITEM_ID_MIN>, $i < <HHP_ITEM_ID_MAX>, $i += 1 )
	{
		
		if( $$has_hhp_item($i) != -1 ) {
			$str += ":" + $$get_hhp_item_name($i, $$get_hhp_item_level($i))
		} else {
			$str += ":" + $$get_hhp_item_name($i, 1)
		}
		
		if( $$get_hhp_rewards_weight($i) != 0 )
		{
			$min = $max
			$max = $min + $$get_hhp_rewards_weight($i)
			$str += "(" + math.tostr($min) + "-" + math.tostr($max) + ")#D"
		}
		else
		{
			$str += "(-)#D"
		}
	}
	$str += ":合計#D"
	
	// 文字列が変更されたときに再描画する
	if( $obj.child[8].get_string != $str ) {
		$obj.child[8].set_string($str)
	}
}

//---------------------------------------------------------------------------
// デバッグボタンを作成する
//---------------------------------------------------------------------------
command $$create_debug_button(property $obj : object, property $x, property $y, property $button_no, property $text : str, property $color : str, property $centering)
{
	$$create_mng_debug_button($obj, $x, $y, $button_no, <MNG_OBJBTN_GROUP_DEBUG>, $text, $color, $centering)
}

//---------------------------------------------------------------------------
// 分類１ボタンを作成する
//---------------------------------------------------------------------------
command $$create_h1_button(property $obj : object)
{
	property $i
	property $text : str
	property $color : str
	property $button_num
	
	$obj.init
	
	$button_num = 5
	$$set_child_object($obj, $button_num)
	
	for( $i = 0, $i < $button_num, $i += 1 )
	{
		switch( $i ) {
		case(0)		$text = "アイテムの追加／レベルアップ"		$color = <BTN_COLOR_RED>
		case(1)		$text = "アイテムの削除"					$color = <BTN_COLOR_PURPLE>
		case(2)		$text = "プレイヤーステータス"				$color = <BTN_COLOR_GREEN>
		case(3)		$text = "スキル"							$color = <BTN_COLOR_BLUE>
		case(4)		$text = "報酬"								$color = <BTN_COLOR_CYAN>
		}
		$$create_debug_button($obj.child[$i], <BTN_BASE_X> + (<BTN_SIZE_X> + <BTN_MARGIN_X>) * $i, <BTN_BASE_Y>, <BTN_H1> + $i, $text, $color, 0)
	}
}

//---------------------------------------------------------------------------
// 分類２ボタンを作成する
//---------------------------------------------------------------------------
command $$create_h2_button(property $obj : object)
{
	property $i
	property $len
	property $base_x
	property $base_y
	property $text : str
	property $color : str
	
	$obj.init
	
	$base_x = <BTN_BASE_X>
	$base_y = <BTN_BASE_Y> + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>)
	
	// アイテムの追加／レベルアップ
	if( $h1_index == 0 )
	{
		$len = <HHP_ITEM_ID_MAX> - 1
		$$set_child_object($obj, $len)
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			if( $$get_hhp_item_level($i + 1) < <HHP_ITEM_LEVEL_MAX> ) {
				$text = $$get_hhp_item_name($i + 1, $$get_hhp_item_level($i + 1) + 1) + "(Lv." + math.tostr($$get_hhp_item_level($i + 1) + 1) + ")"
			} else {
				$text = "-"
			}
			$$create_debug_button($obj.child[$i], $base_x + (<BTN_SIZE_X> + <BTN_MARGIN_X>) * ($i % 7), $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * ($i / 7), <BTN_H2> + $i, $text, <BTN_COLOR_RED>, 0)
		}
	}
	
	// アイテムの削除
	elseif( $h1_index == 1 )
	{
		$len = $$get_hhp_item_count
		$$set_child_object($obj, $len)
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = $$get_hhp_item_name($$get_hhp_item_id_from_list_index($i), $$get_hhp_item_level_from_list_index($i)) +
					"（Lv." + math.tostr($$get_hhp_item_level_from_list_index($i)) + "）"
			$$create_debug_button($obj.child[$i], $base_x + (<BTN_SIZE_X> + <BTN_MARGIN_X>) * ($i % 7), $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * ($i / 7), <BTN_H2> + $i, $text, <BTN_COLOR_RED>, 0)
		}
	}
	
	// プレイヤーステータス
	elseif( $h1_index == 2 )
	{
		$len = 14
		$$set_child_object($obj, $len)
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "ライフ全回復"			$color = <BTN_COLOR_GREEN>
			case(1)		$text = "ライフ-10"				$color = <BTN_COLOR_RED>
			case(2)		$text = "ライフ-1"				$color = <BTN_COLOR_RED>
			case(3)		$text = "ライフ+1"				$color = <BTN_COLOR_YELLOW>
			case(4)		$text = "ライフ+10"				$color = <BTN_COLOR_YELLOW>
			case(5)		$text = "ライフ1にする"			$color = <BTN_COLOR_ORANGE>
			case(6)		$text = "ライフ最大値-10"		$color = <BTN_COLOR_PURPLE>
			case(7)		$text = "ライフ最大値-1"		$color = <BTN_COLOR_PURPLE>
			case(8)		$text = "ライフ最大値+1"		$color = <BTN_COLOR_CYAN>
			case(9)		$text = "ライフ最大値+10"		$color = <BTN_COLOR_CYAN>
			case(10)	$text = "無敵-10秒"				$color = <BTN_COLOR_RED>
			case(11)	$text = "無敵+10秒"				$color = <BTN_COLOR_YELLOW>
			case(12)	$text = "コンボ-100"			$color = <BTN_COLOR_RED>
			case(13)	$text = "コンボ+100"			$color = <BTN_COLOR_YELLOW>
			}
			$$create_debug_button($obj.child[$i], $base_x + (<BTN_SIZE_X> + <BTN_MARGIN_X>) * ($i % 5), $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * ($i / 5), <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// スキル
	elseif( $h1_index == 3 )
	{
		$len = 18
		$$set_child_object($obj, $len)
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "スピカＯＮ"		$color = <BTN_COLOR_RED>
			case(1)		$text = "愛乃ＯＮ"			$color = <BTN_COLOR_RED>
			case(2)		$text = "淡雪ＯＮ"			$color = <BTN_COLOR_RED>
			case(3)		$text = "小詠ＯＮ"			$color = <BTN_COLOR_RED>
			case(4)		$text = "六花ＯＮ"			$color = <BTN_COLOR_RED>
			case(5)		$text = "スピカＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(6)		$text = "愛乃ＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(7)		$text = "淡雪ＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(8)		$text = "小詠ＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(9)		$text = "六花ＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(10)	$text = "ゲージ最小"		$color = <BTN_COLOR_BLUE>
			case(11)	$text = "ゲージ最大"		$color = <BTN_COLOR_BLUE>
			case(12)	$text = "ゲージ -10"		$color = <BTN_COLOR_BLUE>
			case(13)	$text = "ゲージ +10"		$color = <BTN_COLOR_BLUE>
			case(14)	$text = "最大ゲージ -100"	$color = <BTN_COLOR_GREEN>
			case(15)	$text = "最大ゲージ +100"	$color = <BTN_COLOR_GREEN>
			case(16)	$text = "スキル人数 - 1"	$color = <BTN_COLOR_ORANGE>
			case(17)	$text = "スキル人数 + 1"	$color = <BTN_COLOR_ORANGE>
			}
			$$create_debug_button($obj.child[$i], $base_x + (<BTN_SIZE_X> + <BTN_MARGIN_X>) * ($i % 5), $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * ($i / 5), <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// 報酬
	elseif( $h1_index == 4 )
	{
		$len = 11
		$$set_child_object($obj, $len)
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "報酬個数 -1"			$color = <BTN_COLOR_BLUE>
			case(1)		$text = "報酬個数 +1"			$color = <BTN_COLOR_ORANGE>
			case(2)		$text = "リロール全回復"		$color = <BTN_COLOR_GREEN>
			case(3)		$text = "リロール -10"			$color = <BTN_COLOR_RED>
			case(4)		$text = "リロール -1"			$color = <BTN_COLOR_RED>
			case(5)		$text = "リロール +1"			$color = <BTN_COLOR_YELLOW>
			case(6)		$text = "リロール +10"			$color = <BTN_COLOR_YELLOW>
			case(7)		$text = "リロール最大値 -10"	$color = <BTN_COLOR_PURPLE>
			case(8)		$text = "リロール最大値 -1"		$color = <BTN_COLOR_PURPLE>
			case(9)		$text = "リロール最大値 +1"		$color = <BTN_COLOR_CYAN>
			case(10)	$text = "リロール最大値 +10"	$color = <BTN_COLOR_CYAN>
			}
			$$create_debug_button($obj.child[$i], $base_x + (<BTN_SIZE_X> + <BTN_MARGIN_X>) * ($i % 5), $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * ($i / 5), <BTN_H2> + $i, $text, $color, 1)
		}
	}
}

//---------------------------------------------------------------------------
// 選択されたボタンの処理を実行する
//---------------------------------------------------------------------------
command $$execute_select_button
{
	// アイテムの追加／レベルアップ
	if( $h1_index == 0 && $h2_index != -1 )
	{
		$$powerup_hhp_item($h2_index + 1)
		$$update_hhp_item_list_force
		
		// 分類２ボタンを作成する
		$$create_h2_button(front.object[<HHP_OBJ_DEBUG>].child[2].child[1])
		$h2_index = -1
	}
	
	// アイテムの削除
	elseif( $h1_index == 1 && $h2_index != -1 )
	{
		$$del_hhp_item($h2_index)
		
		// 分類２ボタンを作成する
		$$create_h2_button(front.object[<HHP_OBJ_DEBUG>].child[2].child[1])
		$h2_index = -1
	}
	
	// プレイヤーライフ
	elseif( $h1_index == 2 )
	{
		switch( $h2_index ) {
		case(0)		$$add_hhp_player_life($$get_hhp_player_life_max)
		case(1)		$$add_hhp_player_life(-10)
		case(2)		$$add_hhp_player_life(-1)
		case(3)		$$add_hhp_player_life(1)
		case(4)		$$add_hhp_player_life(10)
		case(5)		$$set_hhp_player_life(1)
		case(6)		$$add_hhp_player_life_max(-10)
		case(7)		$$add_hhp_player_life_max(-1)
		case(8)		$$add_hhp_player_life_max(1)
		case(9)		$$add_hhp_player_life_max(10)
		case(10)	$$set_hhp_player_invincible_time(-10000)
		case(11)	$$set_hhp_player_invincible_time(10000)
		case(12)	$$add_hhp_player_combo(-100)
		case(13)	$$add_hhp_player_combo(100)
		}
		
		if( $$get_hhp_player_life <= 0 ) {
			$$set_hhp_player_life(1)
		}
		
		if( $$get_hhp_player_life_max < $$get_hhp_player_life ) {
			$$set_hhp_player_life($$get_hhp_player_life_max)
		}
	}
	
	// スキル
	elseif( $h1_index == 3 )
	{
		switch( $h2_index ) {
		case(0)		$$on_hhp_skill(<HHP_SKILL_ID_SP>)
		case(1)		$$on_hhp_skill(<HHP_SKILL_ID_AI>)
		case(2)		$$on_hhp_skill(<HHP_SKILL_ID_HI>)
		case(3)		$$on_hhp_skill(<HHP_SKILL_ID_KY>)
		case(4)		$$on_hhp_skill(<HHP_SKILL_ID_RK>)
		case(5)		$$off_hhp_skill(<HHP_SKILL_ID_SP>)
		case(6)		$$off_hhp_skill(<HHP_SKILL_ID_AI>)
		case(7)		$$off_hhp_skill(<HHP_SKILL_ID_HI>)
		case(8)		$$off_hhp_skill(<HHP_SKILL_ID_KY>)
		case(9)		$$off_hhp_skill(<HHP_SKILL_ID_RK>)
		case(10)	$$add_hhp_skill_power(-$$get_hhp_skill_power_max)
		case(11)	$$add_hhp_skill_power($$get_hhp_skill_power_max)
		case(12)	$$add_hhp_skill_power(-10)
		case(13)	$$add_hhp_skill_power(10)
		case(14)	$$add_hhp_skill_power_max(-100)
		case(15)	$$add_hhp_skill_power_max(100)
		case(16)	$$add_hhp_skill_max(-1)
		case(17)	$$add_hhp_skill_max(1)
		}
	}
	
	// 報酬
	elseif( $h1_index == 4 )
	{
		switch( $h2_index ) {
		case(0)		$$add_hhp_rewards_num(-1)
		case(1)		$$add_hhp_rewards_num(1)
		case(2)		$$add_hhp_rewards_reroll($$get_hhp_rewards_reroll_max)
		case(3)		$$add_hhp_rewards_reroll(-10)
		case(4)		$$add_hhp_rewards_reroll(-1)
		case(5)		$$add_hhp_rewards_reroll(1)
		case(6)		$$add_hhp_rewards_reroll(10)
		case(7)		$$add_hhp_rewards_reroll_max(-10)
		case(8)		$$add_hhp_rewards_reroll_max(-1)
		case(9)		$$add_hhp_rewards_reroll_max(1)
		case(10)	$$add_hhp_rewards_reroll_max(10)
		}
	}
	
	$$create_hhp_scene_object(front)
	$$update_hhp_scene_object(front)
}

//---------------------------------------------------------------------------
// デバッグ／当たり判定表示フラグを取得する
//---------------------------------------------------------------------------
command $$get_hhp_debug_collision_disp_flag : int
{
	return ($collision_disp)
}

//---------------------------------------------------------------------------
// 有効／無効フラグのテキストを取得する
//---------------------------------------------------------------------------
command $$get_enabled_text(property $flag) : str
{
	if( $flag ) {
		return ("〇")
	}
	
	return ("×")
}

//---------------------------------------------------------------------------
// ゴッドモードのテキストを取得する
//---------------------------------------------------------------------------
command $$get_god_mode_text(property $flag) : str
{
	switch( $$get_hhp_god_mode_flag ) {
	case(<HHP_GOD_MODE_NONE>)		return ("×")
	case(<HHP_GOD_MODE_NORMAL>)		return ("〇")
	case(<HHP_GOD_MODE_NO_DAMAGE>)	return ("◎")
	}
}
