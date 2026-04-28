//===========================================================================
//!
//!    @file     ___mng_urace_debug.ss
//!    @brief    ＵＭＡレースデバッグメニュー
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     デバッグメニュー(excall処理)
//!
//===========================================================================

#inc_start
	
	// 以下、excall前(デバッグ処理前)
	// ボタン番号
	#replace	<BTN_DEBUG>				96			// デバッグボタン
	
	// 以下、excall後(デバッグ処理中)
	// オブジェクト番号
	#replace	<OBJ_USER_DATA>			0			// ユーザーデータ
	#replace	<OBJ_DEBUG_BTN>			1			// デバッグボタン
	
	// ボタン番号
	#replace	<BTN_H1>				0			// ボタン(分類１)開始番号
	#replace	<BTN_H2>				100			// ボタン(分類２)開始番号
	#replace	<BTN_H3>				200			// ボタン(分類３)開始番号
	#replace	<BTN_H4>				300			// ボタン(分類４)開始番号
	
	// ボタン設定
	#replace	<BTN_BASE_X>			1782		// ボタン基本座標(x)
	#replace	<BTN_BASE_Y>			164			// ボタン基本座標(y)
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
	
	// ＵＭＡレースデータ
	#replace	<START_DATE>			12			// ＵＭＡレース開始日
	#replace	<ENTRY_DAY>				14			// ＵＭＡレース開催日数
	
	// 変数
	#property	$select_btn		// 選択しているボタン
	#property	$h1_index		// 分類１で選択されたボタン
	#property	$h2_index		// 分類２で選択されたボタン
	#property	$h3_index		// 分類３で選択されたボタン
	#property	$h4_index		// 分類４で選択されたボタン
	#property	$debug_pause	// 一時停止フラグ
	#property	$debug_page		// デバッグ表示中のページ
	#property	$jump_label		// ジャンプラベル(デバッグで日付変更時のシーンジャンプ)
	#property	$force_order	// 強制着順操作(1=プレイヤー処理／2=ライバル勝利／3=モブ勝利)
	
#inc_end

//===========================================================================
// ＵＭＡレースデバッグメニューフロー
//===========================================================================
#z00

// ジャンプラベルを初期化
$jump_label = -1

// システムコールを準備する
$$excall_ready

// シーンオブジェクトを作成する
$$create_scene_object

// 入力制御を開始する
$$input_start(excall.front, <MNG_OBJBTN_GROUP_DEBUG>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(excall.front, <MNG_OBJBTN_GROUP_DEBUG>)
	
	// キャンセルボタンは終了する
	if( $select_btn == -1 )
	{
		break
	}
	
	// マウスホイールによるページのスクロール
	$$scroll_obj(excall.front.object[<OBJ_DEBUG_BTN>])
	
	// 分類１ボタンが押された場合
	if( <BTN_H1> <= $select_btn && $select_btn < <BTN_H2> )
	{
		$h1_index = $select_btn - <BTN_H1>					// 選択されたボタンを保存する
		$h2_index = -1
		$h3_index = -1
		$h4_index = -1
		$$create_h2_button(excall.front.object[<OBJ_DEBUG_BTN>])	// 分類２ボタンを作成する
	}
	
	// 分類２ボタンが押された場合は対応した分類３ボタンを表示する
	elseif( <BTN_H2> <= $select_btn && $select_btn < <BTN_H3> )
	{
		$h2_index = $select_btn - <BTN_H2>					// 選択されたボタンを保存する
		$h3_index = -1
		$h4_index = -1
		$$create_h3_button(excall.front.object[<OBJ_DEBUG_BTN>])	// 分類３ボタンを作成する
	}
	
	// 分類３ボタンが押された場合は対応した分類４ボタンを表示する
	elseif( <BTN_H3> <= $select_btn && $select_btn < <BTN_H4> )
	{
		$h3_index = $select_btn - <BTN_H3>					// 選択されたボタンを保存する
		$h4_index = -1
		$$create_h4_button(excall.front.object[<OBJ_DEBUG_BTN>])	// 分類４ボタンを作成する
	}
	
	// 分類４ボタンが押された場合
	elseif( <BTN_H4> <= $select_btn )
	{
		$h4_index = $select_btn - <BTN_H4>					// 選択されたボタンを保存する
	}
	
	// 何らかのボタンが押された場合
	if( $select_btn != -2 )
	{
		// 選択されたボタンの処理を実行する
		$$execute_select_button
		
		// ユーザーデータを表示する
		$$draw_user_data(excall.front.object[<OBJ_USER_DATA>])
		
		// ボタンの選択状態をリセットして入力制御を開始する
		$select_btn = -2
		$$input_start(excall.front, <MNG_OBJBTN_GROUP_DEBUG>)
	}
	
	// ジャンプラベルが設定されている場合は終了する
	if( $jump_label != -1 )
	{
		break
	}
	
	input.next
	disp
}

// デバッグオブジェクトを破棄する
$$destroy_scene_object

// システムコールを解放する
$$excall_free

return


//---------------------------------------------------------------------------
// デバッグモードを作成する(各シーンからコールする側)
//---------------------------------------------------------------------------
command $$create_urace_debug_mode(property $button_group, property $type)
{
	if( $$check_debug_mode_enable == 0 ) {
		return
	}
	
	$$create_mng_debug_button(back.object[<BTN_DEBUG>], 10, 1006, <BTN_DEBUG>, $button_group, "ＵＭＡレースデバッグ機能", "#000000", 0)
	back.object[<BTN_DEBUG>].wipe_copy = 1
	
	// デバッグボタンが押されたときにレース中とそうでないときはデバッグ機能を分ける
	if( $type )
	{
		// レース中の場合
		back.object[<BTN_DEBUG>].child[0].set_button_call("$$call_urace_race_debug_menu")
	}
}

//---------------------------------------------------------------------------
// デバッグモードを更新する(各シーンからコールする側)
//---------------------------------------------------------------------------
command $$update_urace_debug_mode(property $select_btn)
{
	if( $$check_debug_mode_enable == 0 ) {
		return
	}
	
	if( $select_btn == <BTN_DEBUG> )
	{
		syscom.call_ex(___mng_urace_debug, 0)
		
		// ジャンプラベルが設定されている場合は初期化処理を行ってジャンプ
		if( $jump_label != -1 )
		{
			@ＵＭＡレースユーザー制御解除
			init_call_stack
			$$set_front_wipe_copy_all(0)
			wipe(0, 0)
			
			if( $jump_label == 9999 )
			{
				jump("001_シナリオフロー", 11 + $jump_label)
			}
			else
			{
				jump("001_シナリオフロー", 11 + $jump_label)
			}
		}
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object
{
	// 各分類で選択されているボタンの値を初期化する
	$h1_index = -1
	$h2_index = -1
	$h3_index = -1
	$h4_index = -1
	
	// 各分類の管理オブジェクトを作成する
	$$set_child_object(excall.front.object[<OBJ_DEBUG_BTN>], 5)
	
	// デバッグメッセージ
	excall.front.object[<OBJ_DEBUG_BTN>].child[0].create_string("範囲外にあるボタンはマウスホイールでスクロールできます", 1, 1500, <BTN_BASE_Y> - 20)
	excall.front.object[<OBJ_DEBUG_BTN>].child[0].set_string_param(15, 0, 0, 60, 0, 0, 2, 1)
	
	// 分類１ボタンを作成する
	$$create_h1_button(excall.front.object[<OBJ_DEBUG_BTN>])
	
	// ユーザーデータを表示する
	$$draw_user_data(excall.front.object[<OBJ_USER_DATA>])
}

//---------------------------------------------------------------------------
// シーンオブジェクトを破棄する
//---------------------------------------------------------------------------
command $$destroy_scene_object
{
	// 使用しているオブジェクトを初期化する
	excall.front.object[<OBJ_USER_DATA>].init
	excall.front.object[<OBJ_DEBUG_BTN>].init
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
	
	$obj.child[1].init
	
	$button_num = 6
	$$set_child_object($obj.child[1], $button_num)
	
	for( $i = 0, $i < $button_num, $i += 1 )
	{
		switch( $i ) {
		case(0)		$text = "所持ＵＭＡ"	$color = <BTN_COLOR_RED>
		case(1)		$text = "アイテム"		$color = <BTN_COLOR_GREEN>
		case(2)		$text = "図鑑"			$color = <BTN_COLOR_BLUE>
		case(3)		$text = "メダル"		$color = <BTN_COLOR_YELLOW>
		case(4)		$text = "日付変更"		$color = <BTN_COLOR_PURPLE>
		case(5)		$text = "その他"		$color = <BTN_COLOR_ORANGE>
		}
		$$create_debug_button($obj.child[1].child[$i], <BTN_BASE_X>, <BTN_BASE_Y> + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H1> + $i, $text, $color, 1)
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
	
	$obj.child[2].init
	$obj.child[2].f.resize(2)
	$obj.child[3].init
	$obj.child[4].init
	
	$base_x = <BTN_BASE_X> - (<BTN_SIZE_X> + <BTN_MARGIN_X>)
	$base_y = <BTN_BASE_Y>
	
	// 所持ＵＭＡ
	if( $h1_index == 0 )
	{
		$len = 7
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "ＵＭＡを追加"				$color = <BTN_COLOR_RED>
			case(1)		$text = "ＵＭＡを削除"				$color = <BTN_COLOR_PURPLE>
			case(2)		$text = "ＵＭＡのステータス変更"	$color = <BTN_COLOR_YELLOW>
			case(3)		$text = "ＵＭＡ最強化"				$color = <BTN_COLOR_GREEN>
			case(4)		$text = "ＵＭＡ最弱化"				$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// アイテム
	if( $h1_index == 1 )
	{
		$len = 3
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "全アイテム最大"		$color = <BTN_COLOR_RED>
			case(1)		$text = "全アイテム最小"		$color = <BTN_COLOR_PURPLE>
			case(2)		$text = "各アイテムの変更"		$color = <BTN_COLOR_YELLOW>
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// 図鑑
	if( $h1_index == 2 )
	{
		$len = 10
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "すべての図鑑／全フラグＯＮ"		$color = <BTN_COLOR_RED>
			case(1)		$text = "すべての図鑑／全フラグＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(2)		$text = "ＵＭＡ図鑑／全フラグＯＮ"			$color = <BTN_COLOR_RED>
			case(3)		$text = "ＵＭＡ図鑑／全フラグＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(4)		$text = "ＵＭＡ図鑑／各フラグＯＮ"			$color = <BTN_COLOR_GREEN>
			case(5)		$text = "ＵＭＡ図鑑／各フラグＯＦＦ"		$color = <BTN_COLOR_BLUE>
			case(6)		$text = "アイテム図鑑／全フラグＯＮ"		$color = <BTN_COLOR_RED>
			case(7)		$text = "アイテム図鑑／全フラグＯＦＦ"		$color = <BTN_COLOR_PURPLE>
			case(8)		$text = "アイテム図鑑／各フラグＯＮ"		$color = <BTN_COLOR_GREEN>
			case(9)		$text = "アイテム図鑑／各フラグＯＦＦ"		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// メダル
	if( $h1_index == 3 )
	{
		$len = 4
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "すべてのメダル取得ＯＮ"	$color = <BTN_COLOR_RED>
			case(1)		$text = "すべてのメダル取得ＯＦＦ"	$color = <BTN_COLOR_PURPLE>
			case(2)		$text = "各メダル取得ＯＮ"			$color = <BTN_COLOR_GREEN>
			case(3)		$text = "各メダル取得ＯＦＦ"		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// 日付変更
	if( $h1_index == 4 )
	{
		$len = 3
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "日付を変更して一日の頭にジャンプ"	$color = <BTN_COLOR_YELLOW>
			case(1)		$text = "日付だけ変更する"					$color = <BTN_COLOR_GREEN>
			case(2)		$text = "ラストレース確認"					$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// その他
	if( $h1_index == 5 )
	{
		$len = 6
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "名声ポイントを-1する"		$color = <BTN_COLOR_BLUE>
			case(1)		$text = "名声ポイントを+1する"		$color = <BTN_COLOR_BLUE>
			case(2)		$text = "名声ポイントを-10する"		$color = <BTN_COLOR_BLUE>
			case(3)		$text = "名声ポイントを+10する"		$color = <BTN_COLOR_BLUE>
			case(4)		$text = "名声ポイントを-100する"	$color = <BTN_COLOR_BLUE>
			case(5)		$text = "名声ポイントを+100する"	$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 1)
		}
	}
}

//---------------------------------------------------------------------------
// 分類３ボタンを作成する
//---------------------------------------------------------------------------
command $$create_h3_button(property $obj : object)
{
	property $i
	property $len
	property $base_x
	property $base_y
	property $text : str
	property $color : str
	property $value
	
	$obj.child[3].init
	$obj.child[3].f.resize(2)
	$obj.child[4].init
	
	$base_x = <BTN_BASE_X> - (<BTN_SIZE_X> + <BTN_MARGIN_X>) * 2
	$base_y = <BTN_BASE_Y>
	
	// ＵＭＡを追加
	if( $h1_index == 0 && $h2_index == 0 )
	{
		$len = $$get_db_uma_max
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = "[" + $$get_urace_rarity_star_text($$get_db_uma_rarity($i + 1)) + "]" +  $$get_db_uma_name($i + 1)
			$color = <BTN_COLOR_RED>
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 0)
		}
	}
	
	// ＵＭＡを削除／ステータス変更／最強化／最弱化
	elseif( $h1_index == 0 && ($h2_index == 1 || $h2_index == 2 || $h2_index == 3 || $h2_index == 4 || $h2_index == 5 || $h2_index == 6 ) )
	{
		$len = $$get_my_uma_num
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = $$get_debug_uma_name($i)
			switch( $h2_index ) {
			case(1)		$color = <BTN_COLOR_PURPLE>
			case(2)		$color = <BTN_COLOR_YELLOW>
			case(3)		$color = <BTN_COLOR_GREEN>
			case(4)		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 0)
		}
	}
	
	// 各アイテムの変更
	elseif( $h1_index == 1 && $h2_index == 2 )
	{
		$len = $$get_db_item_max
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = $$get_db_item_name($i + 1)
			$color = <BTN_COLOR_YELLOW>
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 1)
		}
	}
	
	// ＵＭＡ図鑑／各フラグＯＮＯＦＦ
	if( $h1_index == 2 && ($h2_index == 4 || $h2_index == 5) )
	{
		$len = $$get_db_uma_max
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = $$get_db_uma_name($i + 1)
			switch( $h2_index ) {
			case(4)		$color = <BTN_COLOR_GREEN>
			case(5)		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 1)
		}
	}
	
	// アイテム図鑑／各フラグＯＮＯＦＦ
	if( $h1_index == 2 && ($h2_index == 8 || $h2_index == 9) )
	{
		$len = $$get_db_item_max
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = $$get_db_item_name($i + 1)
			switch( $h2_index ) {
			case(8)		$color = <BTN_COLOR_GREEN>
			case(9)		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 1)
		}
	}
	
	// 各メダル取得ＯＮ／ＯＦＦ
	if( $h1_index == 3 && ($h2_index == 2 || $h2_index == 3) )
	{
		$len = <URACE_MEDAL_MAX>
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = $$get_db_race_name($i + 1)
			switch( $h2_index ) {
			case(2)		$color = <BTN_COLOR_GREEN>
			case(3)		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 1)
		}
	}
	
	// 日付変更(日付変更後に一日の頭にジャンプ)
	if( $h1_index == 4 && ($h2_index == 0 || $h2_index == 1) )
	{
		$len = <ENTRY_DAY>
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$value = <START_DATE>
			$text = "7/" + math.tostr($value + $i)
			switch( $h2_index ) {
			case(0)		$color = <BTN_COLOR_YELLOW>
			case(1)		$color = <BTN_COLOR_GREEN>
			}
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 1)
		}
	}
}

//---------------------------------------------------------------------------
// 分類４ボタンを作成する
//---------------------------------------------------------------------------
command $$create_h4_button(property $obj : object)
{
	property $i
	property $len
	property $base_x
	property $base_y
	property $text : str
	property $color : str
	
	$obj.child[4].init
	$obj.child[4].f.resize(2)
	
	$base_x = <BTN_BASE_X> - (<BTN_SIZE_X> + <BTN_MARGIN_X>) * 3
	$base_y = <BTN_BASE_Y>
	
	// ＵＭＡのステータス変更
	if( $h1_index == 0 && $h2_index == 2 )
	{
		$len = 24
		$$set_child_object($obj.child[4], $len)
		$obj.child[4].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "レアリティを-1する"		$color = <BTN_COLOR_PURPLE>
			case(1)		$text = "レアリティを+1する"		$color = <BTN_COLOR_PURPLE>
			case(2)		$text = "ライフを-1する"			$color = <BTN_COLOR_YELLOW>
			case(3)		$text = "ライフを+1する"			$color = <BTN_COLOR_YELLOW>
			case(4)		$text = "ライフを-10する"			$color = <BTN_COLOR_YELLOW>
			case(5)		$text = "ライフを+10する"			$color = <BTN_COLOR_YELLOW>
			case(6)		$text = "スピードを-1する"			$color = <BTN_COLOR_BLUE>
			case(7)		$text = "スピードを+1する"			$color = <BTN_COLOR_BLUE>
			case(8)		$text = "スピードを-10する"			$color = <BTN_COLOR_BLUE>
			case(9)		$text = "スピードを+10する"			$color = <BTN_COLOR_BLUE>
			case(10)	$text = "攻撃力を-1する"			$color = <BTN_COLOR_GREEN>
			case(11)	$text = "攻撃力を+1する"			$color = <BTN_COLOR_GREEN>
			case(12)	$text = "攻撃力を-10する"			$color = <BTN_COLOR_GREEN>
			case(13)	$text = "攻撃力を+10する"			$color = <BTN_COLOR_GREEN>
			case(14)	$text = "加速力を-1する"			$color = <BTN_COLOR_CYAN>
			case(15)	$text = "加速力を+1する"			$color = <BTN_COLOR_CYAN>
			case(16)	$text = "加速力を-10する"			$color = <BTN_COLOR_CYAN>
			case(17)	$text = "加速力を+10する"			$color = <BTN_COLOR_CYAN>
			case(18)	$text = "芝適性を-1する"			$color = <BTN_COLOR_ORANGE>
			case(19)	$text = "芝適性を+1する"			$color = <BTN_COLOR_ORANGE>
			case(20)	$text = "ダート適性を-1する"		$color = <BTN_COLOR_ORANGE>
			case(21)	$text = "ダート適性を+1する"		$color = <BTN_COLOR_ORANGE>
			case(22)	$text = "水面適性を-1する"			$color = <BTN_COLOR_ORANGE>
			case(23)	$text = "水面適性を+1する"			$color = <BTN_COLOR_ORANGE>
			}
			$$create_debug_button($obj.child[4].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H4> + $i, $text, $color, 0)
		}
	}
	
	// 各アイテムの変更
	elseif( $h1_index == 1 && $h2_index == 2 && $h3_index != -1 )
	{
		$len = 6
		$$set_child_object($obj.child[4], $len)
		$obj.child[4].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "アイテム数を-1する"		$color = <BTN_COLOR_BLUE>
			case(1)		$text = "アイテム数を+1する"		$color = <BTN_COLOR_GREEN>
			case(2)		$text = "アイテム数を-10する"		$color = <BTN_COLOR_BLUE>
			case(3)		$text = "アイテム数を+10する"		$color = <BTN_COLOR_GREEN>
			case(4)		$text = "アイテム数を最小にする"	$color = <BTN_COLOR_PURPLE>
			case(5)		$text = "アイテム数を最大にする"	$color = <BTN_COLOR_RED>
			}
			$$create_debug_button($obj.child[4].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H4> + $i, $text, $color, 1)
		}
	}
	
	// 日付変更(午前／午後)
	elseif( $h1_index == 4 && $h2_index == 1 && $h3_index != -1 )
	{
		$len = 2
		$$set_child_object($obj.child[4], $len)
		$obj.child[4].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = "7/" + math.tostr(<START_DATE> + $h3_index)
			
			switch( $i ) {
			case(0)		$text += "午前"		$color = <BTN_COLOR_ORANGE>
			case(1)		$text += "午後"		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[4].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H4> + $i, $text, $color, 1)
		}
	}
}

//---------------------------------------------------------------------------
// マウスホイールによるページのスクロール
//---------------------------------------------------------------------------
command $$scroll_obj(property $obj : object)
{
	property $focus_index
	property $mouse_x
	property $button_w
	
	$mouse_x = mouse.get_pos_x
	$button_w = <BTN_SIZE_X> + <BTN_MARGIN_X>
	
	// マウス座標から現在選択中の分類を判定する
	if( <BTN_BASE_X> - $button_w * 0 < mouse.get_pos_x )
	{
		$focus_index = 1
	}
	elseif( <BTN_BASE_X> - $button_w * 1 < mouse.get_pos_x && mouse.get_pos_x < <BTN_BASE_X> - $button_w * 0 )
	{
		$focus_index = 2
	}
	elseif( <BTN_BASE_X> - $button_w * 2 < mouse.get_pos_x && mouse.get_pos_x < <BTN_BASE_X> - $button_w * 1 )
	{
		$focus_index = 3
	}
	elseif( <BTN_BASE_X> - $button_w * 3 < mouse.get_pos_x && mouse.get_pos_x < <BTN_BASE_X> - $button_w * 2 )
	{
		$focus_index = 4
	}
	
	if( $focus_index == 0 || $obj.child[$focus_index].f.get_size == 0 ) {
		return
	}
	
	// スクロールが発生する個数のボタンが作成されていない場合は処理しない
	if( $obj.child[$focus_index].f[1] < <BTN_SCROLL_NUM> )
	{
		return
	}
	
	// マウスホイールによるページのスクロール
	if( mouse.wheel > 0 )
	{
		$obj.child[$focus_index].f[0] +=1
		if( $obj.child[$focus_index].f[0] > $obj.child[$focus_index].f[1] - 12 )
		{
			$obj.child[$focus_index].f[0] = $obj.child[$focus_index].f[1] - 12
		}
		
		$obj.child[$focus_index].y_eve.set(-(<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $obj.child[$focus_index].f[0], 100, 0, 0)
	}
	elseif( mouse.wheel < 0 )
	{
		$obj.child[$focus_index].f[0] -= 1
		if( $obj.child[$focus_index].f[0] < 0 )
		{
			$obj.child[$focus_index].f[0] = 0
		}
		
		$obj.child[$focus_index].y_eve.set(-(<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $obj.child[$focus_index].f[0], 100, 0, 0)
	}
}

//---------------------------------------------------------------------------
// 選択されたボタンの処理を実行する
//---------------------------------------------------------------------------
command $$execute_select_button
{
	property $i
	property $j
	property $len
	property $value
	
	// ＵＭＡを追加
	if( $h1_index == 0 && $h2_index == 0 && $h3_index != -1 )
	{
		$$create_wild_uma_data($h3_index + 1, 0)
		$$add_my_uma_from_wild_uma(0)
		$h3_index = -1
	}
	
	// ＵＭＡを削除
	elseif( $h1_index == 0 && $h2_index == 1 && $h3_index != -1 )
	{
		$$del_my_uma($h3_index)
		
		// 分類３ボタンを作成する
		$$create_h3_button(excall.front.object[<OBJ_DEBUG_BTN>])
		$h3_index = -1
	}
	
	// ＵＭＡのステータスを変更
	elseif( $h1_index == 0 && $h2_index == 2 && $h4_index != -1 )
	{
		switch( $h4_index ) {
		case(0)		$$add_uma_rarity(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)			// レアリティを-1する
		case(1)		$$add_uma_rarity(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)			// レアリティを+1する
		case(2)		$$add_uma_life(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)				// ライフを-1する
		case(3)		$$add_uma_life(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)				// ライフを+1する
		case(4)		$$add_uma_life(<URACE_PLAYER_OWNER_ID>, $h3_index, -10)				// ライフを-10する
		case(5)		$$add_uma_life(<URACE_PLAYER_OWNER_ID>, $h3_index, +10)				// ライフを+10する
		case(6)		$$add_uma_speed(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)				// スピードを-1する
		case(7)		$$add_uma_speed(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)				// スピードを+1する
		case(8)		$$add_uma_speed(<URACE_PLAYER_OWNER_ID>, $h3_index, -10)			// スピードを-10する
		case(9)		$$add_uma_speed(<URACE_PLAYER_OWNER_ID>, $h3_index, +10)			// スピードを+10する
		case(10)	$$add_uma_attack(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)			// 攻撃力を-1する
		case(11)	$$add_uma_attack(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)			// 攻撃力を+1する
		case(12)	$$add_uma_attack(<URACE_PLAYER_OWNER_ID>, $h3_index, -10)			// 攻撃力を-10する
		case(13)	$$add_uma_attack(<URACE_PLAYER_OWNER_ID>, $h3_index, +10)			// 攻撃力を+10する
		case(14)	$$add_uma_accel(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)				// 加速力を-1する
		case(15)	$$add_uma_accel(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)				// 加速力を+1する
		case(16)	$$add_uma_accel(<URACE_PLAYER_OWNER_ID>, $h3_index, -10)			// 加速力を-10する
		case(17)	$$add_uma_accel(<URACE_PLAYER_OWNER_ID>, $h3_index, +10)			// 加速力を+10する
		case(18)	$$add_uma_turf_type(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)			// 芝適性を-1する
		case(19)	$$add_uma_turf_type(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)			// 芝適性を+1する
		case(20)	$$add_uma_dirt_type(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)			// ダート適性を-1する
		case(21)	$$add_uma_dirt_type(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)			// ダート適性を+1する
		case(22)	$$add_uma_surface_type(<URACE_PLAYER_OWNER_ID>, $h3_index, -1)		// 水面適性を-1する
		case(23)	$$add_uma_surface_type(<URACE_PLAYER_OWNER_ID>, $h3_index, +1)		// 水面適性を+1する
		}
	}
	
	// ＵＭＡ最強化
	elseif( $h1_index == 0 && $h2_index == 5 && $h3_index != -1 )
	{
		$$add_uma_life(<URACE_PLAYER_OWNER_ID>, $h3_index, <UMA_PARAM_MAX>)
		$$add_uma_speed(<URACE_PLAYER_OWNER_ID>, $h3_index, <UMA_PARAM_MAX>)
		$$add_uma_attack(<URACE_PLAYER_OWNER_ID>, $h3_index, <UMA_PARAM_MAX>)
		$$add_uma_accel(<URACE_PLAYER_OWNER_ID>, $h3_index, <UMA_PARAM_MAX>)
		$$add_uma_turf_type(<URACE_PLAYER_OWNER_ID>, $h3_index, <UMA_GROUND_TYPE_MAX>)
		$$add_uma_dirt_type(<URACE_PLAYER_OWNER_ID>, $h3_index, <UMA_GROUND_TYPE_MAX>)
		$$add_uma_surface_type(<URACE_PLAYER_OWNER_ID>, $h3_index, <UMA_GROUND_TYPE_MAX>)
	}
	
	// ＵＭＡ最弱化
	elseif( $h1_index == 0 && $h2_index == 6 && $h3_index != -1 )
	{
		$$add_uma_life(<URACE_PLAYER_OWNER_ID>, $h3_index, -<UMA_PARAM_MAX>)
		$$add_uma_speed(<URACE_PLAYER_OWNER_ID>, $h3_index, -<UMA_PARAM_MAX>)
		$$add_uma_attack(<URACE_PLAYER_OWNER_ID>, $h3_index, -<UMA_PARAM_MAX>)
		$$add_uma_accel(<URACE_PLAYER_OWNER_ID>, $h3_index, -<UMA_PARAM_MAX>)
		$$add_uma_turf_type(<URACE_PLAYER_OWNER_ID>, $h3_index, -<UMA_GROUND_TYPE_MAX>)
		$$add_uma_dirt_type(<URACE_PLAYER_OWNER_ID>, $h3_index, -<UMA_GROUND_TYPE_MAX>)
		$$add_uma_surface_type(<URACE_PLAYER_OWNER_ID>, $h3_index, -<UMA_GROUND_TYPE_MAX>)
	}
	
	// 全アイテム最大
	elseif( $h1_index == 1 && $h2_index == 0 )
	{
		$len = $$get_db_item_max
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$add_urace_item($i + 1, <URACE_ITEM_MAX>)
		}
	}
	
	// 全アイテム最小
	elseif( $h1_index == 1 && $h2_index == 1 )
	{
		$len = $$get_db_item_max
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$add_urace_item($i + 1, -<URACE_ITEM_MAX>)
		}
	}
	
	// アイテム
	elseif( $h1_index == 1 && $h2_index == 2 && $h4_index != -1 )
	{
		switch( $h4_index ) {
		case(0)		$$add_urace_item($h3_index + 1, -1)					// アイテム数を-1する
		case(1)		$$add_urace_item($h3_index + 1, +1)					// アイテム数を+1する
		case(2)		$$add_urace_item($h3_index + 1, -10)				// アイテム数を-10する
		case(3)		$$add_urace_item($h3_index + 1, +10)				// アイテム数を+10する
		case(4)		$$add_urace_item($h3_index + 1, -<URACE_ITEM_MAX>)	// アイテム数を最小にする
		case(5)		$$add_urace_item($h3_index + 1, +<URACE_ITEM_MAX>)	// アイテム数を最大にする
		}
	}
	
	// 図鑑フラグ
	elseif( $h1_index == 2 )
	{
		// ＵＭＡ図鑑／全フラグＯＮ
		if( $h2_index == 0 || $h2_index == 2 )
		{
			$len = $$get_db_uma_max
			for( $i = 1, $i <= $len, $i += 1 ) {
				$$set_uma_library_flag($i, <URACE_LIBRARY_FLAG_GET>)
			}
		}
		
		// ＵＭＡ図鑑／全フラグＯＦＦ
		if( $h2_index == 1 || $h2_index == 3 )
		{
			$len = $$get_db_uma_max
			for( $i = 1, $i <= $len, $i += 1 ) {
				$$set_uma_library_flag($i, 0)
			}
		}
		
		// ＵＭＡ図鑑／各フラグＯＮ
		if( $h2_index == 4 )
		{
			$$set_uma_library_flag($h3_index + 1, <URACE_LIBRARY_FLAG_GET>)
		}
		
		// ＵＭＡ図鑑／各フラグＯＦＦ
		if( $h2_index == 5 )
		{
			$$set_uma_library_flag($h3_index + 1, 0)
		}
		
		// アイテム図鑑／全フラグＯＮ
		if( $h2_index == 0 || $h2_index == 6 )
		{
			$len = $$get_db_item_max
			for( $i = 1, $i <= $len, $i += 1 ) {
				$$set_item_library_flag($i, 1)
			}
		}
		
		// アイテム図鑑／全フラグＯＦＦ
		if( $h2_index == 1 || $h2_index == 7 )
		{
			$len = $$get_db_item_max
			for( $i = 1, $i <= $len, $i += 1 ) {
				$$set_item_library_flag($i, 0)
			}
		}
		
		// アイテム図鑑／各フラグＯＮ
		if( $h2_index == 8 )
		{
			$$set_item_library_flag($h3_index + 1, 1)
		}
		
		// アイテム図鑑／各フラグＯＦＦ
		if( $h2_index == 9 )
		{
			$$set_item_library_flag($h3_index + 1, 0)
		}
		
	}
	
	// 全アイテム最大
	elseif( $h1_index == 1 && $h2_index == 0 )
	{
		$len = $$get_db_item_max
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$add_urace_item($i + 1, <URACE_ITEM_MAX>)
		}
	}
	
	// 全アイテム最小
	elseif( $h1_index == 1 && $h2_index == 1 )
	{
		$len = $$get_db_item_max
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$add_urace_item($i + 1, -<URACE_ITEM_MAX>)
		}
	}
	// メダル
	elseif( $h1_index == 3 )
	{
		// すべてのメダルＯＮ
		if( $h2_index == 0 )
		{
			for( $i = 0, $i < <URACE_MEDAL_MAX>, $i += 1 ) {
				$$set_urace_medal_flag($i, 1)
			}
		}
		
		// すべてのメダルＯＦＦ
		if( $h2_index == 1 )
		{
			for( $i = 0, $i < <URACE_MEDAL_MAX>, $i += 1 ) {
				$$set_urace_medal_flag($i, 0)
			}
		}
		
		if( $h3_index != -1 )
		{
			// フラグＯＮ
			if( $h2_index == 2 ) {
				$$set_urace_medal_flag($h3_index, 1)
			}
			
			// フラグＯＦＦ
			elseif( $h2_index == 3 ) {
				$$set_urace_medal_flag($h3_index, 0)
			}
		}
	}
	
	// 日付変更
	elseif( $h1_index == 4 )
	{
		// 日付変更してジャンプ
		if( $h2_index == 0 )
		{
			if( $h3_index != -1 )
			{
				$jump_label = $h3_index
			}
		}
		
		// 日付のみ変更
		elseif( $h2_index == 1 )
		{
			if( $h3_index != -1 && $h4_index != -1 )
			{
				$value = <START_DATE>
				@日付_日 = $value + $h3_index
				
				if( $h4_index != -1 )
				{
					if( $h4_index == 0 ) { @日付_時間帯 = @午前 }
					else				 { @日付_時間帯 = @午後 }
				}
			}
		}
		
		// ラストレース確認
		elseif( $h2_index == 2 )
		{
			$jump_label = 9999
		}
	}
	
	
	// その他
	elseif( $h1_index == 5 )
	{
		switch( $h2_index ) {
		case(0)		$$add_urace_honor(-1)			// 名声ポイントを-1する
		case(1)		$$add_urace_honor(1)			// 名声ポイントを+1する
		case(2)		$$add_urace_honor(-10)			// 名声ポイントを-10する
		case(3)		$$add_urace_honor(10)			// 名声ポイントを+10する
		case(4)		$$add_urace_honor(-100)			// 名声ポイントを-100する
		case(5)		$$add_urace_honor(100)			// 名声ポイントを+100する
		}
	}
}

//---------------------------------------------------------------------------
// ユーザーデータを表示する
//---------------------------------------------------------------------------
command $$draw_user_data(property $obj : object)
{
	property $i
	property $id
	property $len
	property $index
	property $text : str
	property $color : str
	property $name_color : str
	property $text_color : str
	
	$obj.init
	$color = "#000000"
	$obj.create_rect(0, 0, <SCREEN_WIDTH>, <SCREEN_HEIGHT>, $$color_code_to_r($color), $$color_code_to_g($color), $$color_code_to_b($color), 0, 1)
	$$set_child_object($obj, 5)
	
	//---------------------------------------------------------------------------
	// 所持ＵＭＡ
	$index = 0
	$color = "#000000"
	$$set_child_object($obj.child[$index], 2)
	$obj.child[$index].set_pos(20, 20)
	
	// 下地
	$obj.child[$index].child[0].create_rect(0, 0, 1000, 940, $$color_code_to_r($color), $$color_code_to_g($color), $$color_code_to_b($color), 160, 1)
	
	// 文字
	$len = $$get_my_uma_num + 1
	$$set_child_object($obj.child[$index].child[1], $len)
	
	$obj.child[$index].child[1].child[0].create_string("", 1, 10, 10)
	$obj.child[$index].child[1].child[0].set_string_param(18, 0, 0, 100, 0, 0, 2, 1)
	for( $i = 1, $i < $len, $i += 1 )
	{
		$obj.child[$index].child[1].child[$i].create_string("", 1, 10 + 500 * (($i - 1) / 15), 30 + 60 * (($i - 1) % 15))
		$obj.child[$index].child[1].child[$i].set_string_param(15, 0, 0, 100, 0, 0, 2, 1)
	}
	
	$text = "#5C所持ＵＭＡリスト：" + math.tostr($$get_my_uma_num) + "/" + math.tostr(<PLAYER_UMA_SLOT_MAX>) + "体#0C"
	$text += "  #3C" + math.tostr(@日付_月) + "/" + math.tostr(@日付_日) + " "
	$text += $$get_urace_race_time_text(@日付_時間帯) + "#0C"
	$text += "  #7C名声ポイント→" + math.tostr($$get_urace_honor) + "#0C"
	$obj.child[$index].child[1].child[0].set_string($text)
	
	$len = $$get_my_uma_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		// ＵＭＡのステータス変更が選択されている場合は選択されているＵＭＡの文字色を変更する
		if( $h1_index == 0 && $h2_index == 2 && $h3_index == $i ) {
			$name_color = "#2C"
			$text_color = "#2C"
		} else {
			$name_color = "#3C"
			$text_color = "#0C"
		}
		
		$text = $name_color + $$get_debug_uma_name($i) + $text_color
		
		$text += "#Dレア→#7C" + $$get_urace_rarity_star_text($$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		$text += "ライフ→#7C" + math.tostr($$get_uma_life(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		$text += "スピード→#7C" + math.tostr($$get_uma_speed(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		$text += "攻撃力→#7C" + math.tostr($$get_uma_attack(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		$text += "加速力→#7C" + math.tostr($$get_uma_accel(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		$text += "芝→#7C" + $$get_urace_ground_type_rank_text($$get_uma_turf_type(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		$text += "ダート→#7C" + $$get_urace_ground_type_rank_text($$get_uma_dirt_type(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		$text += "水面→#7C" + $$get_urace_ground_type_rank_text($$get_uma_surface_type(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "：#D"
		$text += "スキル→#7C" + $$get_db_skill_name($$get_uma_id(<URACE_PLAYER_OWNER_ID>, $i)) + $text_color + "："
		
		$obj.child[$index].child[1].child[1 + $i].set_string($text)
	}
	
	//---------------------------------------------------------------------------
	// 所持アイテム
	$index = 1
	$color = "#000000"
	$$set_child_object($obj.child[$index], 2)
	$obj.child[$index].set_pos(1040, 20)
	
	// 下地
	$obj.child[$index].child[0].create_rect(0, 0, 280, 440, $$color_code_to_r($color), $$color_code_to_g($color), $$color_code_to_b($color), 160, 1)
	
	// 文字
	$len = $$get_db_item_max
	$$set_child_object($obj.child[$index].child[1], $len + 1)
	
	$obj.child[$index].child[1].child[0].create_string("#5C所持アイテムリスト#0C", 1, 10, 10)
	$obj.child[$index].child[1].child[0].set_string_param(18, 0, 0, 100, 0, 0, 2, 1)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		// アイテムが選択されている場合は選択されているアイテムの文字色を変更する
		if( $h1_index == 1 && $h2_index == 2 && $h3_index == $i ) {
			$text_color = "#2C"
		} else {
			$text_color = "#0C"
		}
		
		$text = $text_color + $$get_db_item_name($i + 1) + "：" + math.tostr($$get_urace_item_num($i + 1))
		
		$obj.child[$index].child[1].child[1 + $i].create_string($text, 1, 10, 30 + 15 * $i)
		$obj.child[$index].child[1].child[1 + $i].set_string_param(15, 0, 0, 100, 0, 0, 2, 1)
	}
	
	//---------------------------------------------------------------------------
	// 獲得メダル
	$index = 2
	$color = "#000000"
	$$set_child_object($obj.child[$index], 2)
	$obj.child[$index].set_pos(1040, 480)
	
	// 下地
	$obj.child[$index].child[0].create_rect(0, 0, 280, 440, $$color_code_to_r($color), $$color_code_to_g($color), $$color_code_to_b($color), 160, 1)
	
	// 文字
	$len = <URACE_MEDAL_MAX>
	$$set_child_object($obj.child[$index].child[1], $len + 1)
	
	$obj.child[$index].child[1].child[0].create_string("#5C獲得メダルリスト#0C", 1, 10, 10)
	$obj.child[$index].child[1].child[0].set_string_param(18, 0, 0, 100, 0, 0, 2, 1)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		// アイテムが選択されている場合は選択されているアイテムの文字色を変更する
		if( $h1_index == 3 && ($h2_index == 2 || $h2_index == 3 ) && $h3_index == $i ) {
			$text_color = "#2C"
		} else {
			$text_color = "#0C"
		}
		
		$text = $text_color + $$get_db_race_name($i + 1) + "：" + math.tostr($$get_urace_medal_flag($i))
		
		$obj.child[$index].child[1].child[1 + $i].create_string($text, 1, 10, 30 + 15 * $i)
		$obj.child[$index].child[1].child[1 + $i].set_string_param(15, 0, 0, 100, 0, 0, 2, 1)
	}
	
	//---------------------------------------------------------------------------
	// ＵＭＡ図鑑フラグ
	$index = 3
	$color = "#000000"
	$$set_child_object($obj.child[$index], 2)
	$obj.child[$index].set_pos(1340, 20)
	
	// 下地
	$obj.child[$index].child[0].create_rect(0, 0, 250, 500, $$color_code_to_r($color), $$color_code_to_g($color), $$color_code_to_b($color), 160, 1)
	
	// 文字
	$len = $$get_db_uma_max
	$$set_child_object($obj.child[$index].child[1], $len + 1)
	
	$obj.child[$index].child[1].child[0].create_string("#5CＵＭＡ図鑑#0C", 1, 10, 10)
	$obj.child[$index].child[1].child[0].set_string_param(18, 0, 0, 100, 0, 0, 2, 1)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		// アイテムが選択されている場合は選択されているアイテムの文字色を変更する
		if( $h1_index == 2 && ($h2_index == 4 || $h2_index == 5 ) && $h3_index == $i ) {
			$text_color = "#2C"
		} else {
			$text_color = "#0C"
		}
		
		$id = $i + 1
		$text = $text_color + $$get_db_uma_name($id) + "：" + math.tostr($$get_uma_library_flag($id))
		
		$obj.child[$index].child[1].child[1 + $i].create_string($text, 1, 10, 30 + 15 * $i)
		$obj.child[$index].child[1].child[1 + $i].set_string_param(15, 0, 0, 100, 0, 0, 2, 1)
	}
	
	//---------------------------------------------------------------------------
	// アイテム図鑑フラグ
	$index = 4
	$color = "#000000"
	$$set_child_object($obj.child[$index], 2)
	$obj.child[$index].set_pos(1340, 540)
	
	// 下地
	$obj.child[$index].child[0].create_rect(0, 0, 250, 400, $$color_code_to_r($color), $$color_code_to_g($color), $$color_code_to_b($color), 160, 1)
	
	// 文字
	$len = $$get_db_item_max
	$$set_child_object($obj.child[$index].child[1], $len + 1)
	
	$obj.child[$index].child[1].child[0].create_string("#5Cアイテム図鑑#0C", 1, 10, 10)
	$obj.child[$index].child[1].child[0].set_string_param(18, 0, 0, 100, 0, 0, 2, 1)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		// アイテムが選択されている場合は選択されているアイテムの文字色を変更する
		if( $h1_index == 2 && ($h2_index == 8 || $h2_index == 9 ) && $h3_index == $i ) {
			$text_color = "#2C"
		} else {
			$text_color = "#0C"
		}
		
		$id = $i + 1
		$text = $text_color + $$get_db_item_name($id) + "：" + math.tostr($$get_item_library_flag($id))
		
		$obj.child[$index].child[1].child[1 + $i].create_string($text, 1, 10, 30 + 15 * $i)
		$obj.child[$index].child[1].child[1 + $i].set_string_param(15, 0, 0, 100, 0, 0, 2, 1)
	}
}

//---------------------------------------------------------------------------
// ＵＭＡ名を取得する(頭にインデックス番号付き)
//---------------------------------------------------------------------------
command $$get_debug_uma_name(property $index) : str
{
	return (math.tostr($index + 1) + "." + $$get_uma_name(<URACE_PLAYER_OWNER_ID>, $index))
}



//---------------------------------------------------------------------------
// レース中／デバッグページを作成する
//---------------------------------------------------------------------------
command $$create_urace_race_debug_mode(property $obj : object)
{
	property $i
	property $len
	
	$len = $$get_entry_owner_num
	
	// 背景
	$obj.create_rect(0, 0, 1670, 19 * 55, 0, 0, 0, 128, 1, 48, 22)
	$obj.child.resize($len + 2)
	
	// テキスト
	$obj.child[0].create_string("", 1, 10, 10)
	$obj.child[0].set_string_param(15, 1, 4, 500, 0, 1, 2, 1)
	$obj.child[1].create_string("", 1, 610, 10)
	$obj.child[1].set_string_param(15, 1, 4, 500, 0, 1, 2, 1)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$obj.child[2 + $i].create_string("", 1, 10 + $i * 300, 100 + 23 * 5)
		$obj.child[2 + $i].set_string_param(15, 1, 4, 500, 0, 1, 2, 1)
	}
	
	$debug_page = 0
	$force_order = 0
	$obj.disp = 0
}

//---------------------------------------------------------------------------
// レース中／デバッグページを更新する
//---------------------------------------------------------------------------
command $$update_debug_page(property $obj : object)
{
	property $i
	property $len
	
	$obj.child[0].set_string($$get_debug_race_command_text)
	$obj.child[1].set_string($$get_debug_race_info_text)
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		$obj.child[2 + $i].set_string($$get_debug_running_uma_param_text($i))
	}
}

//---------------------------------------------------------------------------
// レース中／デバッグモードを更新する
//---------------------------------------------------------------------------
command $$update_urace_race_debug_mode(property $obj : object)
{
	property $i
	property $player_lane_index
	property $player_owner_id
	property $player_uma_index
	property $current_ground_type
	property $current_affinity
	property $ukey_target_index
	property $stun_time
	property $speed_reduce_time
	property $speed_reduce_rate

	if( $$check_debug_mode_enable == 0 ) {
		return
	}
	
	// 一時停止／解除
	if( key['1'].on_down )
	{
		$$race_debug_pause
	}
	
	// デバッグ表示／非表示
	if( key['2'].on_down )
	{
		$obj.disp = $$reverse_flag($obj.disp)
	}
	
	// オートプレイ／解除
	if( key['3'].on_down ) {
		$$set_urace_auto_play_flag($$reverse_flag($$get_urace_auto_play_flag))
	}
	
	// デバッグページのページ変更
	if( key['4'].on_down )
	{
		$debug_page += 1
		if( $debug_page > 1 ) {
			$debug_page = 0
		}
	}
	
	// レースリスタート
	if( key['5'].on_down ) {
		return (1)
	}
	
	// 指定したキャラクターの強制勝利
	if( key['6'].on_down ) {	// プレイヤー
		if( $force_order == 1 ) { $force_order = 0 }
		else					{ $force_order = 1 }
	}
	
	if( key['7'].on_down ) {	// ライバル
		if( $force_order == 2 ) { $force_order = 0 }
		else					{ $force_order = 2 }
	}
	
	if( key['8'].on_down ) {	// モブ
		if( $force_order == 3 ) { $force_order = 0 }
		else					{ $force_order = 3 }
	}
	
	// deb
	if( key['9'].on_down ) {
	}
	
	// 各レーンのＵＭＡにダメージを与える(Alt + Num1～4)
	if( key[18].is_down && key[97].on_down )		{ $$damage_uma(0, 1000, <URACE_DAMAGE_TYPE_SKILL>) }
	elseif( key[18].is_down && key[98].on_down )	{ $$damage_uma(1, 1000, <URACE_DAMAGE_TYPE_SKILL>) }
	elseif( key[18].is_down && key[99].on_down )	{ $$damage_uma(2, 1000, <URACE_DAMAGE_TYPE_SKILL>) }
	elseif( key[18].is_down && key[100].on_down )	{ $$damage_uma(3, 1000, <URACE_DAMAGE_TYPE_SKILL>) }
	elseif( key[18].is_down && key[101].on_down )	{ $$damage_uma(4, 1000, <URACE_DAMAGE_TYPE_SKILL>) }
	elseif(key[18].is_down &&  key[102].on_down )	{ $$damage_uma(5, 1000, <URACE_DAMAGE_TYPE_SKILL>) }
	
	// 各レーンのＵＭＡの行動停止／再開(Num1～4)
	elseif( key[97].on_down )	{ $$set_running_uma_stop_flag(0, $$reverse_flag($$get_running_uma_stop_flag(0))) }
	elseif( key[98].on_down )	{ $$set_running_uma_stop_flag(1, $$reverse_flag($$get_running_uma_stop_flag(1))) }
	elseif( key[99].on_down )	{ $$set_running_uma_stop_flag(2, $$reverse_flag($$get_running_uma_stop_flag(2))) }
	elseif( key[100].on_down )	{ $$set_running_uma_stop_flag(3, $$reverse_flag($$get_running_uma_stop_flag(3))) }
	elseif( key[101].on_down )	{ $$set_running_uma_stop_flag(4, $$reverse_flag($$get_running_uma_stop_flag(4))) }
	elseif( key[102].on_down )	{ $$set_running_uma_stop_flag(5, $$reverse_flag($$get_running_uma_stop_flag(5))) }
	
	// スキルゲージを最大にする
	if( key['T'].on_down )
	{
		$$set_entry_owner_skill_power_max($$get_player_from_entry_owner_list)
	}
		
	if( key['E'].on_down )
	{
		switch( $$get_entry_race_ground_type ) {
			case(1)		$$set_entry_race_ground_type(2)
			case(2)		$$set_entry_race_ground_type(3)
			case(3)		$$set_entry_race_ground_type(1)
			case(4)		$$set_entry_race_ground_type(3)
		}
		
;		$$add_running_uma_buff(1, 1, 1, <RUNNING_UMA_BUFF_TYPE_REVERSE_RUN>, 500, 50, 500)
;		$$add_running_uma_buff(0, 0, 1, <RUNNING_UMA_BUFF_TYPE_ACCEL>, 100)
;		$$add_running_uma_buff(0, 0, 2, <RUNNING_UMA_BUFF_TYPE_SPEED_MAX>, 100)
;		$$add_buff_speed_max(0, 0, 13, 200, 5000)
;		$$add_buff(0, 0, 13, 2, 50)
;		$$add_buff(1, 0, 13, 3, 50)
;		$$add_buff(1, 0, 1, 2, 50)
;		$$add_buff(0, 0, 1, 1, 150)
;		$$add_buff(1, 0, 1, 1, 50)
;command $$add_buff(property $target, property $user, property $skill_id, property $type, property $amount)
	;	$$active_running_uma_skill(0, 13)
	}
	if( key['R'].on_down )
	{
		$$add_urace_race_item($$get_player_from_entry_owner_list, 2)
;		$$set_running_uma_jump_param($$get_player_from_entry_owner_list, 200, 2000)
;		$$set_running_uma_action_state($$get_player_from_entry_owner_list, <RUNNING_UMA_ACTION_STATE_LAUNCH>)
;		$$set_running_uma_action_time($$get_player_from_entry_owner_list, 2000)
;		$$add_urace_race_item($$get_player_from_entry_owner_list, 3)
;		$$del_running_uma_buff(0, 0, 1)
;		$$del_running_uma_buff(0, 0, 2)
;		$$del_buff(0, 0, 13)
;		$$del_buff(0, 0, 13)
;		$$del_buff(1, 0, 13)
;		$$del_buff(0, 0, 2)
;		$$del_buff(1, 0, 2)
;		$$del_buff(0, 0, 1)
;		$$del_buff(1, 0, 1)
;command $$del_buff(property $target, property $user, property $skill_id)
	}
	
	if( key['Y'].on_down )
	{	
		$player_lane_index = $$get_player_from_entry_owner_list
		$player_owner_id = $$get_entry_owner_id($player_lane_index)
		$player_owner_id = $$get_entry_owner_uma_index($player_lane_index)
		$current_ground_type = $$get_entry_race_ground_type
		//$current_affinity = $$get_uma_ground_type($player_owner_id, $$get_entry_owner_uma_list($player_lane_index, $player_owner_id), $current_ground_type)
		$current_affinity = $$get_running_uma_ground_type($player_lane_index, $current_ground_type)
		
		if( $current_affinity < <UMA_GROUND_TYPE_MAX> )
		{
			$$add_running_uma_buff($player_lane_index, $player_lane_index, 0, <RUNNING_UMA_BUFF_TYPE_GROUND_AFFINITY>, 3000, 1, 0)
			system.debug_write_log("★★★地形適性バフ★★★")
		}
	}
	
	if( key['U'].on_down )
	{
		$$debug_force_player_skill(31)	// 石化
		//$ukey_target_index = $$get_player_from_entry_owner_list
		//// ヘビ睨み（石化）デバッグ - NPC1に対して発動
		//// レース中かつスタン中でない場合のみ実行
		//if( $$get_running_uma_action_state($ukey_target_index) != <RUNNING_UMA_ACTION_STATE_STONE> )
		//{
		//	$stun_time = 5000          // スタン時間: 5秒（通常より長い
		//	$speed_reduce_time = 2000  // 速度低下時間: 2
		//	$speed_reduce_rate = -50   // 速度低下率: -50%（負の値で減速
        //
		//	// 1. スタンバフを追加（石化状態
		//	$$add_running_uma_buff(
		//		$ukey_target_index,                                // target: NPC1（レーン
		//		$ukey_target_index,                                // user: NPC1自
		//		0,                                // skill_id: 0（デバッグ用
		//		<RUNNING_UMA_ACTION_STATE_STONE>,    // type: 
		//		$stun_time,                       // time: 
		//		0,                                // amount: 未使
		//		0                                 // delay: 0ms（即座に発動
		//	)
        //
		//	// 2. 速度低下バフをディレイ付きで追加（復帰後の後遺症
		//	$$add_running_uma_buff(
		//		$ukey_target_index,                                        // target: NPC1（レーン
		//		$ukey_target_index,                                        // user: NPC1自
		//		0,                                        // skill_id: 0（デバッグ用
		//		<RUNNING_UMA_BUFF_TYPE_REDUCE_SPEED_MAX>, // type: 2（速度低下
		//		$speed_reduce_time,                       // time: 200
		//		$speed_reduce_rate,                       // amount: -50（50%減速
		//		$stun_time                                // delay: 5000ms（スタン終了後に発動
		//	)
		//	
		//	//system.debug_write_log("ヘビ睨み発動 index[" + math.tostr($ukey_target_index) + "]に石化効果を付与")
		//	system.debug_write_log("ヘビ睨み[" + math.tostr($ukey_target_index) + "]付与（スタン"+ math.tostr($stun_time) + "ms → 速度低下" + math.tostr($speed_reduce_rate) + "%を"+ math.tostr($speed_reduce_time) + "ms）")
		//}
	}
	// 妨害無効テスト実行('I'キー)
	if( key['I'].on_down )
	{
		$$execute_interrupt_block_test
	}
	
	// スキル実行テスト
	if( key['J'].on_down )
	{
		$$debug_force_player_skill(24)	// 24全体弱スタン
	}
	
	// アイテム使用テスト
	if( key['M'].on_down )
	{
		if(math.rand(0,1) == 0) {
		$$debug_force_use_item(@アイテム_蓋のついたシュールストレミング, 0)	// item_id、lane_index
		}else{
		$$debug_force_use_item(@アイテム_蓋のついたシュールストレミング, 0)	// item_id、lane_index
		}
	}
	
	// フレームレートチェック（負荷処理）
	if( @mng_counter.get % 2 ) {
		;front.object[10].create(ef_line02, 1)
	}
	
	// デバッグページを更新する
	$$update_debug_page($obj)
	
	return (0)
}

//---------------------------------------------------------------------------
// プレイヤーにスキルを強制的に発動させることができるデバッグ関数
//---------------------------------------------------------------------------
command $$debug_force_player_skill(property $skill_id)
{
    property $player_index
    
	system.debug_write_log("★スキル強制発動 ID:" + math.tostr($skill_id))

    // プレイヤーのエントリーインデックスを取得する
    $player_index = $$get_player_from_entry_owner_list

    // プレイヤーが指定したスキルIDを発動する
    // 第3パラメータ: 1 = テンションゲージを消費しない（デバッグ用）
    $$activate_running_uma_skill($player_index, $skill_id, 1)
}

//---------------------------------------------------------------------------
// アイテムを強制的に使用させることができるデバッグ関数
//---------------------------------------------------------------------------
command $$debug_force_use_item(property $item_id, property $lane_index)
{
	// リタイア済みならスキップ
	if( $$get_entry_owner_retire($lane_index) ) {
		return
	}

	// ゴール済みならスキップ
	if( $$get_entry_owner_goal_order($lane_index) != 0 ) {
		return
	}

	// 既にアイテムを持っている場合は先に使用してクリア
	if( $$has_urace_race_item($lane_index) ) {
		$$use_urace_race_item($lane_index)  // APIを使用
	}

	// アイテムを付与
	if( $$add_urace_race_item($lane_index, $item_id) == -1 ) {
		system.debug_write_log("アイテム付与失敗: エントリ[" + math.tostr($lane_index) + "]")
		return
	}

	// アイテム使用(飛び道具生成)
	if( $$use_urace_race_item($lane_index) == -1 ) {
		system.debug_write_log("アイテム使用失敗: エントリ[" + math.tostr($lane_index) + "]")
	} else {
		system.debug_write_log("アイテム使用: エントリ[" + math.tostr($lane_index) + "] アイテムID[" + math.tostr($item_id) + "]")
	}
}


//---------------------------------------------------------------------------
// レース中妨害無効テスト実行、プレイヤーに妨害無効、NPC5体にアイテムを使用させる
//---------------------------------------------------------------------------
command $$execute_interrupt_block_test
{
	property $i
	property $player_lane_index
	property $buff_duration
	property $item_id

	// プレイヤーのレーンインデックスを取得
	$player_lane_index = $$get_player_from_entry_owner_list

	// 妨害無効バフの持続時間(10秒)
	$buff_duration = 10000

	// 使用アイテムID（1固定：バット）
	$item_id = @アイテム_バット

	// プレイヤーに妨害無効バフを付与
	$$add_running_uma_buff(
		$player_lane_index,                          // target: プレイヤー
		$player_lane_index,                          // user: プレイヤー
		0,                                           // skill_id: 0(デバッグ用)
		<RUNNING_UMA_BUFF_TYPE_INTERRUPT_BLOCK>,    // type: 6(妨害無効)
		$buff_duration,                              // time: 10000ms
		1,                                           // amount: 1(有効フラグ)
		0                                            // delay: 0ms(即座に発動)
	)

	system.debug_write_log("妨害無効バフ付与: レーン[" + math.tostr($player_lane_index) + "] 持続時間[" + math.tostr($buff_duration) + "ms]")

	// 全ての敵(entry_index=1~5)にアイテムを使わせる
	for( $i = 1, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		// リタイア済みならスキップ
		if( $$get_entry_owner_retire($i) ) {
			continue
		}

		// ゴール済みならスキップ
		if( $$get_entry_owner_goal_order($i) != 0 ) {
			continue
		}

		// 既にアイテムを持っている場合は先に使用してクリア
		if( $$has_urace_race_item($i) ) {
			$$use_urace_race_item($i)  // APIを使用
		}

		// アイテムを付与
		if( $$add_urace_race_item($i, $item_id) == -1 ) {
			system.debug_write_log("アイテム付与失敗: エントリ[" + math.tostr($i) + "]")
			continue
		}

		// アイテム使用(飛び道具生成)
		if( $$use_urace_race_item($i) == -1 ) {
			system.debug_write_log("アイテム使用失敗: エントリ[" + math.tostr($i) + "]")
		} else {
			system.debug_write_log("アイテム使用: エントリ[" + math.tostr($i) + "] アイテムID[" + math.tostr($item_id) + "]")
		}
	}

	system.debug_write_log("妨害無効テスト完了: アイテムID[" + math.tostr($item_id) + "]")
}

//---------------------------------------------------------------------------
// レース中／デバッグモードを終了する
//---------------------------------------------------------------------------
command $$finished_urace_race_debug_mode(property $obj : object)
{
	property $i
	property $player_index
	property $rival_index
	property $mob1_index
	property $mob2_index
	
	// 各レーンが誰なのかを取得する
	$player_index = $$get_player_from_entry_owner_list
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		if( $$get_entry_owner_id($i) == $$get_db_race_entry_rival($$get_entry_race_id) )
		{
			$rival_index = $i
			break
		}
	}
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		if( $i == $player_index || $i == $rival_index ) {
			continue
		}
		
		$mob1_index = $i
		
		break
	}
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		if( $i == $player_index || $i == $rival_index || $i == $mob1_index ) {
			continue
		}
		
		$mob2_index = $i
		
		break
	}
	
	// 強制着順操作フラグが設定されている場合は着順を変更する
	if( $force_order == 1 )
	{
		// プレイヤー勝利
		$$set_entry_owner_goal_order($player_index, 1)
		$$set_entry_owner_goal_order($rival_index, 2)
		$$set_entry_owner_goal_order($mob1_index, 3)
		$$set_entry_owner_goal_order($mob2_index, 4)
		$$set_entry_owner_goal_order($mob2_index, 5)
		$$set_entry_owner_goal_order($mob2_index, 6)
	}
	elseif( $force_order == 2 )
	{
		// ライバル勝利
		$$set_entry_owner_goal_order($player_index, 2)
		$$set_entry_owner_goal_order($rival_index, 1)
		$$set_entry_owner_goal_order($mob1_index, 3)
		$$set_entry_owner_goal_order($mob2_index, 4)
		$$set_entry_owner_goal_order($mob2_index, 5)
		$$set_entry_owner_goal_order($mob2_index, 6)
	}
	elseif( $force_order == 3 )
	{
		// モブ勝利
		$$set_entry_owner_goal_order($mob1_index, 1)
		$$set_entry_owner_goal_order($mob2_index, 2)
		$$set_entry_owner_goal_order($rival_index, 3)
		$$set_entry_owner_goal_order($player_index, 4)
		$$set_entry_owner_goal_order($player_index, 5)
		$$set_entry_owner_goal_order($player_index, 6)
	}
}

//---------------------------------------------------------------------------
// レース中／一時停止／解除する
//---------------------------------------------------------------------------
command $$race_debug_pause
{
	$debug_pause = $$reverse_flag($debug_pause)
	
	if( $debug_pause )
	{
		script.set_time_stop_flag(1)
	}
	else
	{
		script.set_time_stop_flag(0)
	}
}

//---------------------------------------------------------------------------
// レース中／コマンド情報を取得する
//---------------------------------------------------------------------------
command $$get_debug_race_command_text : str
{
	k[0] += "'2'キーでデバッグデータ表示/非表示#D" +
			"---------------------------------#D" +
			"'1'キーで一時停止→"
	if( $debug_pause )	{ k[0] += "〇#D" }
	else				{ k[0] += "×#D" }
	k[0] += "'3'キーでオートプレイ→"
	if( $$get_urace_auto_play_flag )	{ k[0] += "〇#D" }
	else								{ k[0] += "×#D" }
	k[0] += "'4'キーでデバッグページ変更#D" +
			"'5'キーでレース再スタート#D" +
			"'6'キーでプレイヤー強制勝利 → "
	if( $force_order == 1 )	{ k[0] += "〇#D" }
	else					{ k[0] += "×#D" }
	k[0] += "'7'キーでライバル強制勝利 → "
	if( $force_order == 2 )	{ k[0] += "〇#D" }
	else					{ k[0] += "×#D" }
	k[0] += "'8'キーでモブ強制勝利 → "
	if( $force_order == 3 )	{ k[0] += "〇#D" }
	else					{ k[0] += "×#D" }
	k[0] += "'Num1～6'キーで各レーンのＵＭＡの動作を再生／停止#D"
	
	return (k[0])
}

//---------------------------------------------------------------------------
// レース中／レース情報を取得する
//---------------------------------------------------------------------------
command $$get_debug_race_info_text : str
{
	property $i
	property $j
	property $len
	
	k[0] += "◆" + $$get_db_race_name($$get_entry_race_id) + " → 距離："
	if( $debug_page == 0 )
	{
		k[0] += math.tostr($$get_entry_race_distance_shift) + "m"
	}
	elseif( $debug_page == 1 )
	{
		k[0] += math.tostr($$get_entry_race_distance)
	}
	k[0] += "[ラストスパート距離："
	if( $debug_page == 0 )
	{
		k[0] += math.tostr($$get_entry_race_last_spurt_distance_shift) + "m]#D"
	}
	elseif( $debug_page == 1 )
	{
		k[0] += math.tostr($$get_entry_race_last_spurt_distance) + "]#D"
	}
	k[0] += "> " + $$get_urace_race_ground_type_text($$get_entry_race_ground_type)
	k[0] += "  → 経過時間：" + math.tostr(@mng_counter.get / 1000) + "." + math.tostr(@mng_counter.get % 1000) + "#D"
	
	/*
	$len = $$get_entry_urace_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		k[0] += "レーン" + math.tostr($i + 1) + "> "
		for( $j = 0, $j < $$get_trap_num($i), $j += 1 )
		{
			k[0] += "[" + math.tostr($$get_trap_enable($i, $j)) + ":" + $$get_db_trap_name($$get_trap_id($i, $j)) + ":"
			if( $debug_page == 0 )
			{
				k[0] += math.tostr($$get_trap_place($i, $j) / 1000) + "]"
			}
			else
			{
				k[0] += math.tostr($$get_trap_place($i, $j)) + "]"
			}
		}
		k[0] += "#D"
	}
	*/
	
	return (k[0])
}

//---------------------------------------------------------------------------
// レース中／レース参加中のＵＭＡ情報を取得する
//---------------------------------------------------------------------------
command $$get_debug_running_uma_param_text(property $index) : str
{
	k[0] = "-------------------------------#D"
	k[0] += math.tostr($index + 1) + "枠> " + $$get_db_owner_name($$get_entry_owner_id($index)) + "#D"
	k[0] += "失格>" + $$get_debug_enable_text($$get_entry_owner_retire($index), 0) + "#D"
	if( $debug_page == 0 )
	{
		k[0] += "走行距離> " + math.tostr($$get_entry_owner_mileage($index) / 1000) + "m#D"
		k[0] += "ゴール時間> " + $$get_urace_time_text($$get_entry_owner_goal_time($index)) + "(" + $$get_debug_goal_order_text($$get_entry_owner_goal_order($index)) + ")#D"
		k[0] += "スキルゲージ> " + math.tostr($$get_entry_owner_skill_power($index) / 1000) + "#D"
	}
	elseif( $debug_page == 1 )
	{
		k[0] += "走行距離> " + math.tostr($$get_entry_owner_mileage($index)) + "#D"
		k[0] += "ゴール時間> " + math.tostr($$get_entry_owner_goal_time($index)) + "(" + $$get_debug_goal_order_text($$get_entry_owner_goal_order($index)) + ")#D"
		k[0] += "スキルゲージ> " + math.tostr($$get_entry_owner_skill_power($index)) + "#D"
	}
	k[0] += "NPC思考> " + math.tostr($$get_entry_owner_npc_think_time($index)) + "#D"
	k[0] += "-------------------------------#D"
	k[0] += "名前> " + $$get_running_uma_name($index) + "#D"
	k[0] += "種> " + $$get_db_uma_name($$get_running_uma_id($index)) + "#D"
	k[0] += "能力> " + math.tostr($$get_uma_life($$get_entry_owner_id($index), $$get_entry_uma_index($index))) + "/" +
			math.tostr($$get_uma_speed($$get_entry_owner_id($index), $$get_entry_uma_index($index))) + "/" +
			math.tostr($$get_uma_attack($$get_entry_owner_id($index), $$get_entry_uma_index($index))) + "/" +
			math.tostr($$get_uma_accel($$get_entry_owner_id($index), $$get_entry_uma_index($index))) + "#D"
	
	if( $debug_page == 0 )
	{
		k[0] += "ＨＰ> " + math.tostr($$get_running_uma_life($index)) + "/" + math.tostr($$get_running_uma_life_max($index)) + "#D"
		k[0] += "速度> " + math.tostr($$get_running_uma_speed($index) / 1000) + "/" + math.tostr($$get_running_uma_speed_max($index) / 1000) + "(" + math.tostr($$get_running_uma_buff_speed_max($index)) + "%)#D"
		k[0] += " +加速> " + math.tostr($$get_running_uma_accel($index)) + "#D"
		k[0] += " +自動加算> " + math.tostr($$get_running_uma_plus_tension($index)) + "#D"
	}
	elseif( $debug_page == 1 )
	{
		k[0] += "  HP> " + math.tostr($$get_running_uma_life($index)) + "/" + math.tostr($$get_running_uma_life_max($index)) + "#D"
		k[0] += "速度> " + math.tostr($$get_running_uma_speed($index)) + "/" + math.tostr($$get_running_uma_speed_max($index)) + "(" + math.tostr($$get_running_uma_buff_speed_max($index)) + "%)#D"
		k[0] += "加速> " + math.tostr($$get_running_uma_accel($index)) + "#D"
		k[0] += " +自動加算> " + math.tostr($$get_running_uma_plus_tension($index)) + "#D"
	}
	
	k[0] += "行動> " + $$get_debug_running_uma_action_state_text($index) + "#D"
	k[0] += "行動時間> " + math.tostr($$get_running_uma_action_time($index)) + "#D"
	k[0] += "無敵フラグ> " + $$get_debug_enable_text($$get_running_uma_invincible_flag($index), 1) + "#D"
	k[0] += "無敵時間>" + math.tostr($$get_running_uma_invincible_time($index)) + "#D"
	k[0] += "潜伏モード> " + $$get_debug_hide_mode_text($index) + "#D"
	k[0] += "アイテム> " + math.tostr($$get_urace_race_item_id($index)) + "#D"
	k[0] += "現在の順位> " + math.tostr($$get_order($index)) + "#D"
	k[0] += "現在のレーン> " + math.tostr($$get_now_lane($index)) + "#D"
	k[0] += "スキル使用> " + $$get_debug_skill_enable_text($$is_running_uma_active_skill_available($index)) + "#D"
	k[0] += "クールダウン倍率> " + math.tostr($$get_running_uma_skill_cool_down_rate($index)) + "%#D"
	k[0] += "発動中のスキル> " + $$get_db_skill_name($$get_running_uma_active_skill_id($index)) + "[" + math.tostr($$get_running_uma_active_skill_time($index)) + "]#D"
	k[0] += "所持スキル[クールタイム]#D"
	k[0] += ">" + math.tostr($$get_running_uma_skill_id($index)) + "." + $$get_db_skill_name($$get_running_uma_skill_id($index)) + "[" + math.tostr($$get_running_uma_skill_cool_down($index)) + "]#D"
	k[0] += "地形適性補正> #3C" + math.tostr($$get_running_uma_buff_ground_affinity($index)) + "#0C#D"
	k[0] += "バフ／デバフ[" + math.tostr($$get_running_uma_buff_num($index)) + "]#D"
	for( l[0] = 0, l[0] < $$get_running_uma_buff_num($index), l[0] += 1 )
	{
		k[0] += $$get_debug_buff_type_text($index, l[0]) + "#D"
	}
	k[0] += "-------------------------------#D"
	k[0] += "所持> " + math.tostr($$get_entry_owner_uma_list_num($index)) + "体#D"
	for( l[0] = 0, l[0] < <URACE_DECK_UMA_MAX>, l[0] += 1 )
	{
		if( $$get_entry_owner_uma_list($index, l[0]) == -1 ) {
			continue
		}
		if( $$get_entry_owner_uma_index($index) == l[0] ) {
			k[0] += "#3C"
		} else {
			k[0] += "#0C"
		}
		k[0] += " +" + $$get_uma_name($$get_entry_owner_id($index), $$get_entry_owner_uma_list($index, l[0])) + "#0C#D"
	}
	
	return (k[0])
}

//---------------------------------------------------------------------------
// レース中／レース参加中のＵＭＡの状態テキストを取得する
//---------------------------------------------------------------------------
command $$get_debug_running_uma_action_state_text(property $index) : str
{
	property $action_state
	
	if( $$get_running_uma_stop_flag($index) )
	{
		k[0] = "#2C停止中#0C"
	}
	else
	{
		$action_state = $$get_running_uma_action_state($index)
		
		switch( $action_state ) {
		case(<RUNNING_UMA_ACTION_STATE_NONE>)				k[0] = "なし"
		case(<RUNNING_UMA_ACTION_STATE_START_WAIT>)			k[0] = "スタート待機"
		case(<RUNNING_UMA_ACTION_STATE_START>)				k[0] = "スタート"
		case(<RUNNING_UMA_ACTION_STATE_WAIT>)				k[0] = "待機"
		case(<RUNNING_UMA_ACTION_STATE_RUN>)				k[0] = "走り"
		case(<RUNNING_UMA_ACTION_STATE_LANE_CHANGE>)		k[0] = "レーンチェンジ"
		case(<RUNNING_UMA_ACTION_STATE_RUNNER_CHANGE>)		k[0] = "交代中"
		case(<RUNNING_UMA_ACTION_STATE_STUN>)				k[0] = "気絶"
		case(<RUNNING_UMA_ACTION_STATE_GROUND_WEAK>)		k[0] = "苦手地形"
		case(<RUNNING_UMA_ACTION_STATE_LAUNCH>)				k[0] = "打ち上げ"
		case(<RUNNING_UMA_ACTION_STATE_COURSE_OUT>)			k[0] = "コースアウト"
		case(<RUNNING_UMA_ACTION_STATE_DEAD>)				k[0] = "死亡"
		case(<RUNNING_UMA_ACTION_STATE_GOAL>)				k[0] = "ゴール"
		case(<RUNNING_UMA_ACTION_STATE_STONE>)				k[0] = "石化"
			
		case(<RUNNING_UMA_ACTION_STATE_TRAP_FAILURE>)		k[0] = "障害物アクション／失敗"
		default												k[0] = "error"
		}
	}
	
	return (k[0])
}

//---------------------------------------------------------------------------
// レース中／ゴール着順テキストを取得する
//---------------------------------------------------------------------------
command $$get_debug_goal_order_text(property $order) : str
{
	if( $order == 0 ) {
		k[0] = "-"
	} else {
		k[0] = math.tostr($order) + "着"
	}
	
	return (k[0])
}
 
//---------------------------------------------------------------------------
// レース中の有効／無効テキストを取得する
//---------------------------------------------------------------------------
command $$get_debug_enable_text(property $flag, property $add_text) : str
{
	if( $add_text == 1 )
	{
		if( $flag == 1 ) { k[0] = "〇有効" }
		else			 { k[0] = "×無効" }
	}
	else
	{
		if( $flag == 1 ) { k[0] = "〇" }
		else			 { k[0] = "×" }
	}
	
	return (k[0])
}

//---------------------------------------------------------------------------
// レース中／潜伏タイプテキストを取得する
//---------------------------------------------------------------------------
command $$get_debug_hide_mode_text(property $index) : str
{
	if( $$get_running_uma_buff_hide_mode_float($index) )
	{
		k[0] = "浮遊"
	}
	elseif( $$get_running_uma_buff_hide_mode_dive($index) )
	{
		k[0] = "潜る"
	}
	else
	{
		k[0] = "-"
	}
	
	return (k[0])
}

//---------------------------------------------------------------------------
// レース中／スキルの発動有効／無効テキストを取得する
//---------------------------------------------------------------------------
command $$get_debug_skill_enable_text(property $flag) : str
{
	if( $flag == 1 )		{ k[0] = "〇可能" }
	elseif( $flag == -1 )	{ k[0] = "×アクション状態" }
	elseif( $flag == -2 )	{ k[0] = "×テンション" }
	elseif( $flag == -3 )	{ k[0] = "×スキル使用中" }
	elseif( $flag == -4 )	{ k[0] = "×逆走中" }
	elseif( $flag == -6 )	{ k[0] = "×ジャンプ中" }
	
	return (k[0])
}

//---------------------------------------------------------------------------
// レース中／バフタイプのテキストを取得する
//---------------------------------------------------------------------------
command $$get_debug_buff_type_text(property $lane_index, property $buff_index) : str
{
	switch( $$get_running_uma_buff_type($lane_index, $buff_index) ) {
	case(<RUNNING_UMA_BUFF_TYPE_CONST_SPEED_MAX>)		k[0] = "最高速度(固定)"
	case(<RUNNING_UMA_BUFF_TYPE_REDUCE_SPEED_MAX>)		k[0] = "最高速度(減少)"
	case(<RUNNING_UMA_BUFF_TYPE_ACCEL>)					k[0] = "加速力"
	case(<RUNNING_UMA_BUFF_TYPE_STAMINA>)				k[0] = "スタミナ"
	case(<RUNNING_UMA_BUFF_TYPE_HIDE_MODE>)				k[0] = "潜伏モード"
	case(<RUNNING_UMA_BUFF_TYPE_INTERRUPT_BLOCK>)		k[0] = "妨害無効"
	case(<RUNNING_UMA_BUFF_TYPE_TRAP_BLOCK>)			k[0] = "障害物無効"
	case(<RUNNING_UMA_BUFF_TYPE_REVERSE_RUN>)			k[0] = "逆走"
	case(<RUNNING_UMA_BUFF_TYPE_STUN>)					k[0] = "気絶"
	case(<RUNNING_UMA_BUFF_TYPE_GROUND_AFFINITY>)		k[0] = "地形適性"
	default												k[0] = "××××××"
	}
	
	k[0] += ">" + math.tostr($$get_running_uma_buff_amount($lane_index, $buff_index)) +
			"[#3C" + math.tostr($$get_running_uma_buff_delay_time($lane_index, $buff_index)) + "#0C/" + math.tostr($$get_running_uma_buff_delay_time_max($lane_index, $buff_index)) + "]" + 
			"[#3C" + math.tostr($$get_running_uma_buff_time($lane_index, $buff_index)) + "#0C/" + math.tostr($$get_running_uma_buff_time_max($lane_index, $buff_index)) + "]#D"
//	k[0] += " ↑" + "[" + $$get_db_skill_name($$get_running_uma_buff_skill_id($lane_index, $buff_index)) + "]" + $$get_running_uma_name($$get_running_uma_buff_user_index($lane_index, $buff_index))
	
	return (k[0])
}
