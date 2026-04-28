//===========================================================================
//!
//!    @file     102_小詠Play05ミニゲーム.ss
//!    @brief    小詠Play05のミニゲーム実行部
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     ポンっ！のたびに選択肢
//!              表示順は毎回ランダム
//!              制限時間２秒
//!              連続で１０回表示
//!              河瀬が何を出すかは河瀬の表情差分に紐づく、真顔＝チョキ、真顔口開け＝パー、真顔目閉じ＝グー
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start

	// オブジェクト
	#define		<PLAY05_OBJ_BUTTON>			(<OBJ_APP_EFFECT01> + 0)
	#define		<PLAY05_OBJ_BUTTON_MAX>		(<OBJ_APP_EFFECT01> + <HAND_NUM> - 1)
	#define		<PLAY05_OBJ_BASE>			(<PLAY05_OBJ_BUTTON_MAX> + 1)
	#define		<PLAY05_OBJ_CHARA>			(<PLAY05_OBJ_BUTTON_MAX> + 2)
	#define		<PLAY05_OBJ_CHARA_HNAD>		(<PLAY05_OBJ_BUTTON_MAX> + 3)
	
	// 定義
	#replace	<HAND_NUM>			6		// 選択最大数
	#replace	<TIME_LIMIT>		2500	// 制限時間（２．５秒）
	#replace	<BATTLE_MAX>		10		// 最大対戦数
	#replace	<MYSTERY_HAND_NUM>	6		// 謎手札最大数
	
	// 変数
	#property	$select_btn					// 選択したボタン
	#property	$state						// ゲームステート
	#property	$state_time					// ゲームステート管理時間
	#property	$battle_num					// 対戦数
	#property	$battle_result				// 対戦結果
	#property	$janken_list : intlist		// じゃんけんリスト
	#property	$hand_list : intlist		// 手札リスト
	#property	$mystery_hand : intlist		// 謎手札
	#property	$mystery_hand_index			// 謎手札インデックス
	
#inc_end

//---------------------------------------------------------------------------
// 050_小詠Play05（河瀬／高速じゃんけん）シーン開始
//---------------------------------------------------------------------------
#z00

close
@bg_set(b_bg008, 1250)
@wipe(2)

// システム系の設定
syscom.set_syscom_menu_disable			// システムコマンドを禁止する
syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
script.set_msg_back_disable				// メッセージバックを禁止する
script.set_shortcut_disable				// ショートカットを禁止する
script.set_ctrl_skip_disable			// 早送りを禁止する
script.set_allow_joypad_mode_onoff(1)	// ジョイパッドモードを許可する

// 初期化
$$init_game

// 説明表示
$$create_game_description(front.object[<PLAY05_OBJ_BASE>])

// クリック待ち
R

// ボタングループ初期化
front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].init

// シーンオブジェクトの作成
$$create_scene_object(front.object[<PLAY05_OBJ_BASE>])

// パッド遷移を設定する
$$set_joypad_navigation(front)

// 準備ウェイト
timewait(1500)

// カウンター開始
counter[0].start_real

// 入力制御を開始する
input.clear
front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].start

while( 1 )
{
	// 最大対戦数を超えた場合終了する
	if( $battle_num >= <BATTLE_MAX> ) {
		break
	}
	
	// ゲーム状態によって処理を変更する
	switch( $state ) {
		
	// 河瀬じゃんけん準備
	case(0)
		
		// ボイス
		exkoe(503800316,010)		// KOE(503800316,010)【河瀬】「ジャンケン──」
		$$change_ch_ready_face(front.object[<PLAY05_OBJ_CHARA>])
		
		// 手札リストを作成する
		$$create_hand_list
		
		$state += 1
		$state_time = counter[0].get + 250
		
	// 手札表示
	case(1)
		
		if( $state_time < counter[0].get )
		{
			// 入力制御を開始する
			input.clear
			front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].start
			
			// 手札を表示する
			$$show_hand
			
			// カウンターをリセット
			counter[0].reset
			counter[0].start_real
			
			$state += 1
		}
		
	// 入力
	case(2)
		
		// 入力制御を更新する
		$select_btn = $$input_update(front, <OBJBTN_GROUP_NO_SELECT>)
		
		// 何も選ばずに制限時間が過ぎた場合は敗北
		if( counter[0].get > <TIME_LIMIT> )
		{
			$state += 1
		}
		
		// じゃんけんボタンを押した時
		if( <PLAY05_OBJ_BUTTON> <= $select_btn && $select_btn <= <PLAY05_OBJ_BUTTON_MAX> )
		{
			$select_btn -= <PLAY05_OBJ_BUTTON>
			
			$state += 1
		}
		
	// 勝敗判定
	case(3)
		
		// 手札を選択できなくする
		$$hand_disable($select_btn)
		
		// 河瀬の表情を変更する
		$$change_ch_face(front.object[<PLAY05_OBJ_CHARA>], ch13_15)
		
		// 河瀬ボイス
		switch( $battle_num ) {
		case(0)		exkoe(503800331,010)
		case(1)		exkoe(503800333,010)
		case(2)		exkoe(503800335,010)
		case(3)		exkoe(503800337,010)
		case(4)		exkoe(503800339,010)
		case(5)		exkoe(503800341,010)
		case(6)		exkoe(503800343,010)
		case(7)		exkoe(503800345,010)
		case(8)		exkoe(503800347,010)
		case(9)		exkoe(503800349,010)
		}
		
		// 河瀬の手を表示する
		$$show_ch_hand(front.object[<PLAY05_OBJ_CHARA_HNAD>], $select_btn)
		
		$state += 1
		$state_time = counter[0].get + 750
		
	// 勝敗判定
	case(4)
		
		if( $state_time < counter[0].get )
		{
			// 河瀬がグー
			if( $janken_list[$battle_num] == 0 ) {
				
				// 時間切れ
				if( $select_btn == -2 )
				{
					$$result_lose
				}
				else
				{
					switch( $hand_list[$select_btn] ) {
					case(0)		$$result_draw		// グー
					case(1)		$$result_lose		// チョキ
					case(2)		$$result_win		// パー
					case(3)		$$result_lose		// 謎１
					case(4)		$$result_lose		// 謎２
					case(5)		$$result_lose		// 謎３
					}
				}
			}
			
			// 河瀬がチョキ
			elseif( $janken_list[$battle_num] == 1 ) {
				
				// 時間切れ
				if( $select_btn == -2 )
				{
					$$result_lose
				}
				else
				{
					switch( $hand_list[$select_btn] ) {
					case(0)		$$result_win		// グー
					case(1)		$$result_draw		// チョキ
					case(2)		$$result_lose		// パー
					case(3)		$$result_lose		// 謎１
					case(4)		$$result_lose		// 謎２
					case(5)		$$result_lose		// 謎３
					}
				}
			}
			
			// 河瀬がパー
			else {
				
				// 時間切れ
				if( $select_btn == -2 )
				{
					$$result_lose
				}
				else
				{
					switch( $hand_list[$select_btn] ) {
					case(0)		$$result_lose		// グー
					case(1)		$$result_win		// チョキ
					case(2)		$$result_draw		// パー
					case(3)		$$result_lose		// 謎１
					case(4)		$$result_lose		// 謎２
					case(5)		$$result_lose		// 謎３
					}
				}
			}
			
			// 対戦数を加算する
			$battle_num += 1
			
			// 手札を非表示にする
			$$hide_hand
			
			// 河瀬の手を非表示にする
			$$hide_ch_hand(front.object[<PLAY05_OBJ_CHARA_HNAD>])
			
			$state += 1
			$state_time = counter[0].get + 500
		}
		
	// 次へのウェイト
	case(5)
		
		if( $state_time < counter[0].get )
		{
			$state = 0
		}
	}
	
	// シーンオブジェクトを更新する
	$$update_scene_object(front.object[<PLAY05_OBJ_BASE>])
	
	// 画面の更新
	input.next
	disp
}

front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].end

// 河瀬の表情を変更する
$$change_ch_face(front.object[<PLAY05_OBJ_CHARA>], ch12_02)

timewait(1000)

@se(SE_kyplay_Whistle)

timewait(2000)

// システム系の設定
syscom.set_syscom_menu_enable				// システムコマンドを許可する
syscom.set_hide_mwnd_enable_flag(1)			// ウィンドウを消すを許可する
script.set_msg_back_enable					// メッセージバックを許可する
script.set_shortcut_enable					// ショートカットを許可する
script.set_ctrl_skip_enable					// 早送りを許可する
script.set_allow_joypad_mode_onoff_default	// ジョイパッドモードの許可をデフォルトに戻す

// オブジェクトの初期化
front.object[<PLAY05_OBJ_BUTTON> + 0].wipe_copy = 0
front.object[<PLAY05_OBJ_BUTTON> + 1].wipe_copy = 0
front.object[<PLAY05_OBJ_BUTTON> + 2].wipe_copy = 0
front.object[<PLAY05_OBJ_BUTTON> + 3].wipe_copy = 0
front.object[<PLAY05_OBJ_BUTTON> + 4].wipe_copy = 0
front.object[<PLAY05_OBJ_BUTTON> + 5].wipe_copy = 0
front.object[<PLAY05_OBJ_BASE>].wipe_copy = 0
front.object[<PLAY05_OBJ_CHARA>].wipe_copy = 0

@小詠_Ｐｌａｙ０５で遊んだ += 1

@all_sound_stop(2000)
@fade(25)

return


//---------------------------------------------------------------------------
// 初期化
//---------------------------------------------------------------------------
command $$init_game
{
	@小詠_Ｐｌａｙ０５勝利数 = 0
	@小詠_Ｐｌａｙ０５敗北数 = 0
	@小詠_Ｐｌａｙ０５引き分け数 = 0
	
	$state = 0
	$state_time = 0
	
	$battle_num = 0
	$battle_result = 0
	$$create_janken_list
	$$create_mystery_hand_list
	$mystery_hand_index = 0
}

//---------------------------------------------------------------------------
// 河瀬のじゃんけんリストを作成する
//---------------------------------------------------------------------------
command $$create_janken_list
{
	property $i
	
	$janken_list.init
	$janken_list.resize(<BATTLE_MAX>)
	
	for( $i = 0, $i < <BATTLE_MAX>, $i += 1 )
	{
		$janken_list[$i] = math.rand(0, 2)
	}
}

//---------------------------------------------------------------------------
// 手札リストを作成する
//---------------------------------------------------------------------------
command $$create_hand_list
{
	property $i
	property $index
	property $tmp
	
	// リストを作成
	$hand_list.init
	$hand_list.resize(<HAND_NUM>)
	
	// 手札をリストに追加
	for( $i = 0, $i < <HAND_NUM>, $i += 1 ) {
		$hand_list[$i] = $i
	}
	
	// リストをシャッフルする
	for( $i = $hand_list.get_size - 1, $i > 0, $i -= 1 )
	{
		$index = math.rand(0, $hand_list.get_size - 1)
		$tmp = $hand_list[$i]
		$hand_list[$i] = $hand_list[$index]
		$hand_list[$index] = $tmp
	}
}

//---------------------------------------------------------------------------
// 謎手札リストを作成する
//---------------------------------------------------------------------------
command $$create_mystery_hand_list
{
	property $i
	property $index
	property $tmp
	
	// リストを作成
	$mystery_hand.init
	$mystery_hand.resize(<MYSTERY_HAND_NUM>)
	
	// 謎手札をリストに追加
	for( $i = 0, $i < <MYSTERY_HAND_NUM>, $i += 1 ) {
		$mystery_hand[$i] = $i + 4
	}
	
	// リストをシャッフルする
	for( $i = $mystery_hand.get_size - 1, $i > 0, $i -= 1 )
	{
		$index = math.rand(0, $mystery_hand.get_size - 1)
		$tmp = $mystery_hand[$i]
		$mystery_hand[$i] = $mystery_hand[$index]
		$mystery_hand[$index] = $tmp
	}
}

//---------------------------------------------------------------------------
// Play05ミニゲーム説明
//---------------------------------------------------------------------------
command $$create_game_description(property $obj : object)
{
	// フィルター
	$obj.create("_kyplay05_description_filter", 1)
	$obj.child.resize(1)
	
	// ベース
	$obj.child[0].create("_kyplay05_description_bg", 1, 395, 178)
	$$set_image_center_rep($obj.child[0])
	$obj.child[0].x_rep.resize(1)
	$obj.child[0].child.resize(1)
	
	// 説明
	$obj.child[0].child[0].create("_kyplay05_description", 1, 242, 168)
	
	// アニメーション
	$obj.tr = 0
	$obj.tr_eve.set_real(255, 300, 0, 2)
	
	$obj.child[0].tr = 0
	$obj.child[0].tr_eve.set_real(255, 250, 300, 2)
	$obj.child[0].set_scale(1500, 1500)
	$obj.child[0].scale_x_eve.set_real(1000, 250, 300, 2)
	$obj.child[0].scale_y_eve.set_real(1000, 250, 300, 2)
	
	@se(SE_elec_body_float_up)
	
	// スキップでも何が表示されたか分かるようにウェイトを入れる
	$$set_ctrl_skip_disable(1000)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $obj : object)
{
	property $i
	
	$obj.init
	$obj.disp = 1
	$obj.layer = <LAYER_UI>
	$obj.child.resize(7)
	
	// 得点／背景
	$obj.child[0].create("_kyplay05_score_bg", 1, 528, 837)
	
	// 得点／勝
	$obj.child[1].create_number("_kyplay05_score_win_number", 1, 635, 812)
	$obj.child[1].set_number_param(2, 0, 0, 0, 0, -9)
	
	// 得点／分
	$obj.child[2].create_number("_kyplay05_score_number", 1, 874, 812)
	$obj.child[2].set_number_param(2, 0, 0, 0, 0, -9)
	
	// 得点／負け
	$obj.child[3].create_number("_kyplay05_score_number", 1, 1111, 812)
	$obj.child[3].set_number_param(2, 0, 0, 0, 0, -9)
	
	// 制限時間／背景
	$obj.child[4].create("_kyplay07_time", 1, 396, 952, 1)
	
	// 制限時間／バー
	$obj.child[5].create("_kyplay07_time", 1, 396, 952)
	$obj.child[5].set_src_clip(1, 0, 0, $obj.child[5].get_size_x, $obj.child[5].get_size_y)
	
	// デバッグ用
	if( $$check_debug_mode_enable ) {
		$obj.child[6].create_string("", 1)
		$obj.child[6].set_string_param(18, 0, 0, 100, 1, 0, 0, 0)
	}
	
	// 河瀬
	$$create_ch_bs_object(front.object[<PLAY05_OBJ_CHARA>])
	
	// 河瀬の手
	$$create_ch_hand(front.object[<PLAY05_OBJ_CHARA_HNAD>])
	
	// 各ボタン
	for( $i = 0, $i < <HAND_NUM>, $i += 1 )
	{
		$$create_janken_button(front.object[<PLAY05_OBJ_BUTTON> + $i], <PLAY05_OBJ_BUTTON> + $i, $i)
	}
}

// じゃんけんボタンの作成
command $$create_janken_button(property $obj : object, property $button_no, property $index)
{
	$$create_ui_button($obj, "_kyplay05_btn00", 211 + $index * 252, 580, $button_no, <OBJBTN_GROUP_NO_SELECT>, 0)
	
	$obj.layer = <LAYER_UI>
	$obj.tr = 0
	$obj.y_rep.resize(1)
	$obj.child.resize(1)
	
	$obj.child[0].create("_kyplay05_btn" + math.tostr_zero($index + 1, 2), 1)
	$obj.child[0].y_rep.resize(1)
	$obj.child[0].f.resize(1)
	$obj.child[0].f[0] = 1
	
	$obj.frame_action.start(-1, "$$fa_jyanken_button")
}

// じゃんけんボタンのフレームアクション
command $$fa_jyanken_button(property $fa : frameaction, property $obj : object)
{
	property $button_no
	
	// 入力可能なステート以外はスキップする
	if( $state != 2 ) {
		return
	}
	
	$button_no = $obj.get_button_no
	
	// 疑似ボタンに空ボタンのパターン番号を合わせる
	$obj.child[0].patno = $obj.patno
	
	// 選択されているとき↑に移動
	if( $obj.child[0].f[0] )
	{
		if( syscom.check_joypad_mode == 0 && $$get_hit_btn == $button_no || syscom.check_joypad_mode == 1 && $$get_joypad_focus_button == $button_no )
		{
			$obj.child[0].y_rep[0] = 0
			$obj.child[0].y_rep_eve[0].set_real(-50, 150, 0, 2)
			
			$obj.child[0].f[0] = 0
		}
	}
	
	// 選択されていないとき↓に移動
	else
	{
		if( (syscom.check_joypad_mode == 0 && ($$get_hit_btn == $button_no || $$get_pushed_btn == $button_no) || syscom.check_joypad_mode == 1 && $$get_joypad_focus_button == $button_no) == 0 )
		{
			$obj.child[0].y_rep[0] = -50
			$obj.child[0].y_rep_eve[0].set_real(0, 150, 0, 2)
			
			$obj.child[0].f[0] = 1
		}
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $obj : object)
{
	property $i
	property $j
	property $text: str
	
	// 得点／勝
	$obj.child[1].set_number(@小詠_Ｐｌａｙ０５勝利数)
	
	// 得点／分
	$obj.child[2].set_number(@小詠_Ｐｌａｙ０５引き分け数)
	
	// 得点／負
	$obj.child[3].set_number(@小詠_Ｐｌａｙ０５敗北数)
	
	// 得点が２桁の場合は座標を調整する
	if( 9 < @小詠_Ｐｌａｙ０５勝利数 ) {
		$obj.child[1].x = 673
	}
	if( 9 < @小詠_Ｐｌａｙ０５引き分け数 ) {
		$obj.child[2].x = 912
	}
	if( 9 < @小詠_Ｐｌａｙ０５敗北数 ) {
		$obj.child[3].x = 1150
	}
	
	// 制限時間／バー
	if( $state == 2 ) {
		$obj.child[5].src_clip_right = math.linear(counter[0].get, 0, $obj.child[5].get_size_x, <TIME_LIMIT>, 0)
	}
	
	// デバッグ用
	if( $$check_debug_mode_enable )
	{
		$text = "じゃんけんリスト#D"
		for( $i = 0, $i < <BATTLE_MAX>, $i += 1 )
		{
			switch( $janken_list[$i] ) {
			case(0)		$text += "グー   > "
			case(1)		$text += "チョキ > "
			case(2)		$text += "パー   > "
			}
			
			if( $battle_num == $i )
			{
				for( $j = 0, $j < <HAND_NUM>, $j += 1 ) {
					switch( $hand_list[$j] ) {
					case(0)
						switch( $janken_list[$i] ) {
						case(0)		$text += "△"
						case(1)		$text += "〇"
						case(2)		$text += "×"
						}
					case(1)
						switch( $janken_list[$i] ) {
						case(0)		$text += "×"
						case(1)		$text += "△"
						case(2)		$text += "〇"
						}
					case(2)
						switch( $janken_list[$i] ) {
						case(0)		$text += "〇"
						case(1)		$text += "×"
						case(2)		$text += "△"
						}
					case(3)		$text += "×"
					case(4)		$text += "×"
					case(5)		$text += "×"
					}
				}
			}
			$text += "#D"
		}
		
		$text += "謎の手並び#D"
		for( $i = 0, $i < <MYSTERY_HAND_NUM>, $i += 1 )
		{
			$text += math.tostr($mystery_hand[$i]) + ","
		}
		
		$obj.child[6].set_string($text)
		$obj.child[6].disp = front.object[<OBJ_DEBUG_SC_KEY>].disp
	}
}

//---------------------------------------------------------------------------
// 河瀬の立ち絵を作成する
//---------------------------------------------------------------------------
command $$create_ch_bs_object(property $obj : object)
{
	// 立ち絵
	$$set_bs_object($obj, bs3_ch11_09)
	
	// 河瀬の手／確認用
	
	// ボイス
	exkoe(503800157,010)		// KOE(503800157,010)【河瀬】「いくぞ」R
	
	// アニメーション
	$obj.x_rep[0] = 200
	$obj.x_rep_eve[0].set_real(0, 500, 0, 2)
	$obj.tr = 0
	$obj.tr_eve.set_real(255, 500, 0, 2)
}

//---------------------------------------------------------------------------
// 河瀬の表情を変更する
//---------------------------------------------------------------------------
command $$change_ch_face(property $obj : object, property $face : str)
{
	$$change_bs_image($obj, $face)
}

//---------------------------------------------------------------------------
// 河瀬の表情を変更する（じゃんけん準備）
//---------------------------------------------------------------------------
command $$change_ch_ready_face(property $obj : object)
{
	property $face : str
	
	switch( $janken_list[$battle_num] ) {
	case(0)		$face = "ch11_08"
	case(1)		$face = "ch11_02"
	case(2)		$face = "ch11_19"
	}
	
	$$change_bs_image($obj, $face)
}

//---------------------------------------------------------------------------
// 河瀬の手を作成する
//---------------------------------------------------------------------------
command $$create_ch_hand(property $obj : object)
{
	$obj.create("_kyplay05_btn01", 1, 860, 50)
	$obj.layer = <LAYER_UI>
	$obj.tr = 0
	$obj.y_rep.resize(1)
}

//---------------------------------------------------------------------------
// 河瀬の手を表示する
//---------------------------------------------------------------------------
command $$show_ch_hand(property $obj : object, property $select_index)
{
	switch( $janken_list[$battle_num] ) {
	case(0)		$obj.change_file("_kyplay05_btn01")
	case(1)		$obj.change_file("_kyplay05_btn02")
	case(2)		$obj.change_file("_kyplay05_btn03")
	}
	
	$obj.tr = 0
	$obj.tr_eve.set_real(255, 250, 0, 2)
	$obj.y_rep[0] = -50
	$obj.y_rep_eve[0].set_real(0, 250, 0, 2)
	
	if( $select_index == -2 ) {
		$obj.x = 860
	} else {
		$obj.x = front.object[<PLAY05_OBJ_BUTTON> + $select_index].x
	}
}

//---------------------------------------------------------------------------
// 河瀬の手を非表示にする
//---------------------------------------------------------------------------
command $$hide_ch_hand(property $obj : object)
{
	$obj.tr = 255
	$obj.tr_eve.set_real(0, 250, 0, 2)
	$obj.y_rep[0] = 0
	$obj.y_rep_eve[0].set_real(50, 250, 0, 2)
}

//---------------------------------------------------------------------------
// 手札を表示する
//---------------------------------------------------------------------------
command $$show_hand
{
	property $i
	property $filename : str
	
	for( $i = 0, $i < <HAND_NUM>, $i += 1 )
	{
		if( $hand_list[$i] >= 3 )
		{
			$filename = "_kyplay05_btn" + math.tostr_zero($mystery_hand[$mystery_hand_index], 2)
			
			$mystery_hand_index += 1
			if( <MYSTERY_HAND_NUM> <= $mystery_hand_index ) {
				$mystery_hand_index = 0
			}
		}
		else
		{
			$filename = "_kyplay05_btn" + math.tostr_zero($hand_list[$i] + 1, 2)
		}
		
		front.object[<PLAY05_OBJ_BUTTON> + $i].child[0].change_file($filename)
		front.object[<PLAY05_OBJ_BUTTON> + $i].y_rep[0] = 100
		front.object[<PLAY05_OBJ_BUTTON> + $i].y_rep_eve[0].set_real(0, 250, 0, 2)
		front.object[<PLAY05_OBJ_BUTTON> + $i].tr = 0
		front.object[<PLAY05_OBJ_BUTTON> + $i].tr_eve.set_real(255, 250, 0, 2)
		
		front.object[<PLAY05_OBJ_BUTTON> + $i].set_button_state_normal
	}
}

//---------------------------------------------------------------------------
// 手札を無効にする
//---------------------------------------------------------------------------
command $$hand_disable(property $select_index)
{
	property $i
	
	for( $i = 0, $i < <HAND_NUM>, $i += 1 )
	{
		front.object[<PLAY05_OBJ_BUTTON> + $i].set_button_state_disable
		
		if( $i != $select_index )
		{
			front.object[<PLAY05_OBJ_BUTTON> + $i].y_rep[0] = 0
			front.object[<PLAY05_OBJ_BUTTON> + $i].y_rep_eve[0].set_real(100, 250, 0, 2)
			front.object[<PLAY05_OBJ_BUTTON> + $i].tr = 255
			front.object[<PLAY05_OBJ_BUTTON> + $i].tr_eve.set_real(0, 250, 0, 2)
		}
	}
}

//---------------------------------------------------------------------------
// 手札を非表示にする
//---------------------------------------------------------------------------
command $$hide_hand
{
	property $i
	
	for( $i = 0, $i < <HAND_NUM>, $i += 1 )
	{
		front.object[<PLAY05_OBJ_BUTTON> + $i].tr_eve.set_real(0, 250, 0, 2)
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	property $i
	
	$$set_joypad_focus_button(<PLAY05_OBJ_BUTTON>)
	
	for( $i = 0, $i < <HAND_NUM>, $i += 1 )
	{
		$stage.object[<PLAY05_OBJ_BUTTON> + $i].joypad_up    = -1
		$stage.object[<PLAY05_OBJ_BUTTON> + $i].joypad_down  = -1
		$stage.object[<PLAY05_OBJ_BUTTON> + $i].joypad_left  = <PLAY05_OBJ_BUTTON> + $i - 1
		$stage.object[<PLAY05_OBJ_BUTTON> + $i].joypad_right = <PLAY05_OBJ_BUTTON> + $i + 1
	}
	
	$stage.object[<PLAY05_OBJ_BUTTON> + 0].joypad_left = <PLAY05_OBJ_BUTTON> + <HAND_NUM> - 1
	
	$stage.object[<PLAY05_OBJ_BUTTON> + <HAND_NUM> - 1].joypad_right = <PLAY05_OBJ_BUTTON> + 0
}

//---------------------------------------------------------------------------
// じゃんけん結果／勝利
//---------------------------------------------------------------------------
command $$result_win
{
	@小詠_Ｐｌａｙ０５勝利数 += 1
	
	// 効果音
	@se(SE_kyplay_pingpong, 0, 1)
}

//---------------------------------------------------------------------------
// じゃんけん結果／引き分け
//---------------------------------------------------------------------------
command $$result_draw
{
	@小詠_Ｐｌａｙ０５引き分け数 += 1
	
	// 効果音
	@se(SE_buzzer_wrong, 0, 2)
}

//---------------------------------------------------------------------------
// じゃんけん結果／敗北
//---------------------------------------------------------------------------
command $$result_lose
{
	@小詠_Ｐｌａｙ０５敗北数 += 1
	
	// 効果音
	@se(SE_buzzer_wrong, 0, 2)
}
