//===========================================================================
//!
//!    @file     102_小詠Play07ミニゲーム.ss
//!    @brief    小詠Play07のミニゲーム実行部
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     一つの早口言葉につき、三回正解の選択肢をクリック
//!              三回正解を選ぶと1点、一度でも誤答を選ぶと得点なし
//!              これを時間いっぱいに繰り返し
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start

	// オブジェクト
	#define		<PLAY07_OBJ_BUTTON>			(<OBJ_APP_EFFECT01> + 0)
	#define		<PLAY07_OBJ_BUTTON_MAX>		(<OBJ_APP_EFFECT01> + <ANSWER_NUM> - 1)
	#define		<PLAY07_OBJ_BASE>			(<PLAY07_OBJ_BUTTON_MAX> + 1)
	
	// 定義
	#replace	<TIME_LIMIT>			60000		// 制限時間（１分）
	#replace	<QUESTION_NUM>			10			// 問題最大数
	#replace	<ANSWER_NUM>			4			// 回答最大数
	#replace	<ANSWER_STREAK_NUM>		3			// 連続正解最大数
	#replace	<SCORE_MAX>				99			// 最大スコア
	
	// 変数
	#property	$select_btn					// 選択したボタン
	#property	$state						// ゲームステート
	#property	$state_time					// ゲームステート管理時間
	#property	$question_list : intlist	// 問題リスト
	#property	$question_index				// 現在の問題
	#property	$answer_list : intlist		// 回答リスト
	#property	$answer_streak				// 連続正解数
	
#inc_end

//---------------------------------------------------------------------------
// 050_小詠Play07（塁／早口言葉）シーン開始
//---------------------------------------------------------------------------
#z00

close

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
$$create_game_description(front.object[<PLAY07_OBJ_BASE>])

// クリック待ち
R

// ボタングループ初期化
front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].init

// オブジェクトの作成
$$create_scene_object(front.object[<PLAY07_OBJ_BASE>])

// パッド遷移を設定する
$$set_joypad_navigation(front)

// カウンター開始
counter[0].start_real

// 入力制御を開始する
input.clear
front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].start

while( 1 )
{
	// ゲーム状態によって処理を変更する
	switch( $state ) {
	
	// 問題表示
	case(0)
		
		@se(SE_elec_quiz_start_deden)
		
		// 問題を表示する
		$$show_question(front.object[<PLAY07_OBJ_BASE>])
		
		$state += 1
		$state_time = counter[0].get + 500
		
	// 回答表示
	case(1)
		
		if( $state_time < counter[0].get )
		{
			// 入力制御を開始する
			input.clear
			front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].start
			
			// 回答ボタンを表示する
			$$show_answer_button
			
			$state += 1
		}
		
	// 入力待ち
	case(2)
	
		// 入力制御を更新する
		$select_btn = $$input_update(front, <OBJBTN_GROUP_NO_SELECT>)
		
		// 回答ボタンを押した時
		if( <PLAY07_OBJ_BUTTON> <= $select_btn && $select_btn <= <PLAY07_OBJ_BUTTON_MAX> )
		{
			$select_btn -= <PLAY07_OBJ_BUTTON>
			
			// 正解
			if( $answer_list[$select_btn] == 0 )
			{
				// 効果音
				switch( $answer_streak ) {
				case(0)		@se(SE_kyplay_clear1, 0, 0)
				case(1)		@se(SE_kyplay_clear2, 0, 1)
				case(2)		@se(SE_kyplay_clear3, 0, 2)
				}
				
				// 正解／不正解表示
				$$show_result(front.object[<PLAY07_OBJ_BASE>], $select_btn)
				
				// 連続正解数を増やす
				$answer_streak += 1
				
				// 連続正解最大数を超えた場合は得点して次の質問へ進む
				if( $answer_streak >= <ANSWER_STREAK_NUM> )
				{
					@小詠_Ｐｌａｙ０７得点 += 1
					if( <SCORE_MAX> < @小詠_Ｐｌａｙ０７得点 ) {
						@小詠_Ｐｌａｙ０７得点 = <SCORE_MAX>
					}
					
					// 質問ボタンを非表示にする／連続正解／得点
					$$hide_answer_button($select_btn, 2)
					
					$state += 1
					$state_time = counter[0].get + 500
				}
				
				// 連続正解最大数でない場合は回答を再作成する
				else
				{
					// 質問ボタンを非表示にする／正解
					$$hide_answer_button($select_btn, 1)
					
					$state = 4
					$state_time = counter[0].get + 500
				}
			}
			
			// 不正解
			else
			{
				// 効果音
				@se(SE_elec_quiz_wrong, 0, 3)
				
				// 連続正解数をリセットする
				$answer_streak = 0
				
				// 正解／不正解表示
				$$show_result(front.object[<PLAY07_OBJ_BASE>], $select_btn)
				
				// 質問ボタンを非表示にする／不正解
				$$hide_answer_button($select_btn, 0)
				
				$state += 1
				$state_time = counter[0].get + 1000
			}
		}
	
	// 正解／不正解判定
	case(3)
		
		if( $state_time < counter[0].get )
		{
			// 次の質問へ進める
			$$next_question(front.object[<PLAY07_OBJ_BASE>])
			
			$state = 0
		}
		
	// 連続正解
	case(4)
		
		if( $state_time < counter[0].get )
		{
			// 回答リストを作成する
			$$create_answer_list
			
			$state = 1
		}
	}
	
	// 制限時間を超えると終了
	if( counter[0].get >= <TIME_LIMIT> ) {
		break
	}
	
	// オブジェクトの更新
	$$update_scene_object(front.object[<PLAY07_OBJ_BASE>])
	
	// 画面の更新
	input.next
	disp
}

front.objbtngroup[<OBJBTN_GROUP_NO_SELECT>].end

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
front.object[<PLAY07_OBJ_BASE>].init
front.object[<PLAY07_OBJ_BUTTON> + 0].init
front.object[<PLAY07_OBJ_BUTTON> + 1].init
front.object[<PLAY07_OBJ_BUTTON> + 2].init
front.object[<PLAY07_OBJ_BUTTON> + 3].init

@小詠_Ｐｌａｙ０７で遊んだ += 1

return


//---------------------------------------------------------------------------
// 初期化
//---------------------------------------------------------------------------
command $$init_game
{
	@小詠_Ｐｌａｙ０７得点 = 0
	
	$state = 0
	$state_time = 0
	
	$$create_question_list
	$$create_answer_list
	$answer_streak = 0
}

//---------------------------------------------------------------------------
// 問題リストを作成する
//---------------------------------------------------------------------------
command $$create_question_list
{
	property $i
	property $index
	property $tmp
	
	// リストを作成
	$question_list.init
	$question_list.resize(<QUESTION_NUM>)
	
	// 質問をリストに追加
	for( $i = 0, $i < <QUESTION_NUM>, $i += 1 ) {
		$question_list[$i] = $i
	}
	
	// リストをシャッフルする
	for( $i = $question_list.get_size - 1, $i > 0, $i -= 1 )
	{
		$index = math.rand(0, $question_list.get_size - 1)
		$tmp = $question_list[$i]
		$question_list[$i] = $question_list[$index]
		$question_list[$index] = $tmp
	}
	
	$question_index = 0
}

//---------------------------------------------------------------------------
// 回答リストを作成する
//---------------------------------------------------------------------------
command $$create_answer_list
{
	property $i
	property $index
	property $tmp
	
	// リストを作成
	$answer_list.init
	$answer_list.resize(<ANSWER_NUM>)
	
	// 回答をリストに追加
	for( $i = 0, $i < <ANSWER_NUM>, $i += 1 ) {
		$answer_list[$i] = $i
	}
	
	// リストをシャッフルする
	for( $i = $answer_list.get_size - 1, $i > 0, $i -= 1 )
	{
		$index = math.rand(0, $answer_list.get_size - 1)
		$tmp = $answer_list[$i]
		$answer_list[$i] = $answer_list[$index]
		$answer_list[$index] = $tmp
	}
}

//---------------------------------------------------------------------------
// Play07ミニゲーム説明
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
	$obj.child[0].child[0].create("_kyplay07_description", 1, 168, 169)
	
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
	$obj.init
	$obj.disp = 1
	$obj.child.resize(9)
	
	// 問題／枠
	$obj.child[0].create("_kyplay07_question_bg", 1, 142, 59)
	$obj.child[0].y_rep.resize(1)
	$obj.child[0].child.resize(1)
	
	// 問題／テキスト
	$obj.child[0].child[0].create("_kyplay07_question_text", 1, 227, 63)
	
	// 得点／背景
	$obj.child[2].create("_kyplay07_score_bg", 1, 727, 816)
	
	// 得点／数字
	$obj.child[3].create_number("_kyplay07_score_number", 1, 836, 811)
	$obj.child[3].set_number_param(2, 0, 0, 0, 0, -9)
	
	// 制限時間／背景
	$obj.child[4].create("_kyplay07_time", 1, 396, 952, 1)
	
	// 制限時間／バー
	$obj.child[5].create("_kyplay07_time", 1, 396, 952)
	$obj.child[5].set_src_clip(1, 0, 0, $obj.child[5].get_size_x, $obj.child[5].get_size_y)
	
	// 回答結果
	$obj.child[6].create("_kyplay07_result", 1, 846, 913)
	$obj.child[6].tr = 0
	$$set_image_center_rep($obj.child[6])
	
	// 連続正解
	$obj.child[7].create_number("_kyplay07_streak", 1, 741, 996)
	$obj.child[7].y_rep.resize(1)
	$obj.child[7].tr = 0
	$$set_image_center_rep($obj.child[7])
	
	// デバッグ用
	if( $$check_debug_mode_enable ) {
		$obj.child[8].create_string("", 1)
		$obj.child[8].set_string_param(18, 0, 0, 100, 1, 0, 0, 0)
	}
	
	// 回答ボタン
	$$create_play07_button(front.object[<PLAY07_OBJ_BUTTON> + 0], 504, 314 + 130 * 0, <PLAY07_OBJ_BUTTON> + 0)
	$$create_play07_button(front.object[<PLAY07_OBJ_BUTTON> + 1], 504, 314 + 130 * 1, <PLAY07_OBJ_BUTTON> + 1)
	$$create_play07_button(front.object[<PLAY07_OBJ_BUTTON> + 2], 504, 314 + 130 * 2, <PLAY07_OBJ_BUTTON> + 2)
	$$create_play07_button(front.object[<PLAY07_OBJ_BUTTON> + 3], 504, 314 + 130 * 3, <PLAY07_OBJ_BUTTON> + 3)
}

//---------------------------------------------------------------------------
// オブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $obj : object)
{
	property $i
	property $text: str
	
	// 得点／数字
	$obj.child[3].set_number(@小詠_Ｐｌａｙ０７得点)
	
	// 得点が２桁の場合は座標を調整する
	if( 9 < @小詠_Ｐｌａｙ０７得点 ) {
		$obj.child[3].x = 875
	}
	
	// 制限時間／バー
	$obj.child[5].src_clip_right = math.linear(counter[0].get, 0, $obj.child[5].get_size_x, <TIME_LIMIT>, 0)
	
	// フォーカスされている回答ボタンは文字色を変更する
	if( $state == 2 )
	{
		for( $i = 0, $i < <ANSWER_NUM>, $i += 1 )
		{
			$$update_ui_string_param(front.object[<PLAY07_OBJ_BUTTON> + $i].child[0], 36, 0, 0, 100, 1, 0, 0, 0)
			
			if( syscom.check_joypad_mode == 0 && ($$get_pushed_btn == <PLAY07_OBJ_BUTTON> + $i || $$get_hit_btn == <PLAY07_OBJ_BUTTON> + $i) ) {
				$$update_ui_string_param(front.object[<PLAY07_OBJ_BUTTON> + $i].child[0], 36, 0, 0, 100, 0, 0, 0, 0)
			}
			if( syscom.check_joypad_mode == 1 && $$get_joypad_focus_button == <PLAY07_OBJ_BUTTON> + $i ) {
				$$update_ui_string_param(front.object[<PLAY07_OBJ_BUTTON> + $i].child[0], 36, 0, 0, 100, 0, 0, 0, 0)
			}
		}
	}
	
	// デバッグ用
	if( $$check_debug_mode_enable )
	{
		$text = "質問順#D"
		for( $i = 0, $i < <QUESTION_NUM>, $i += 1 ) {
			$text += math.tostr($i) + "." + $$get_kyplay07_question_text($i) + "#D"
		}
		$text += "回答#D"
		for( $i = 0, $i < <ANSWER_NUM>, $i += 1 ) {
			$text += math.tostr($i) + "."
			if( $answer_list[$i] == 0 ) {
				$text += "〇"
			} else {
				$text += "×"
			}
			$text += $$get_kyplay07_anser_text($question_index, $answer_list[$i]) + "#D"
		}
		$obj.child[8].set_string($text)
		$obj.child[8].disp = front.object[<OBJ_DEBUG_SC_KEY>].disp
	}
}

//---------------------------------------------------------------------------
// 問題を表示する
//---------------------------------------------------------------------------
command $$show_question(property $obj : object)
{
	// 問題／テキスト
	$obj.child[0].child[0].patno = $question_index
	
	$obj.child[0].tr = 0
	$obj.child[0].tr_eve.set_real(255, 500, 0, 2)
	$obj.child[0].y_rep[0] = 100
	$obj.child[0].y_rep_eve[0].set_real(0, 500, 0, 2)
}

//---------------------------------------------------------------------------
// 回答ボタンを作成する
//---------------------------------------------------------------------------
command $$create_play07_button(property $obj : object, property $x, property $y, property $button_no)
{
	$$create_ui_button($obj, "_kyplay07_answer_btn", $x, $y, $button_no, <OBJBTN_GROUP_NO_SELECT>, 0)
	$obj.tr = 0
	$obj.x_rep.resize(1)
	$obj.y_rep.resize(1)
	
	$obj.child.resize(1)
	$$create_ui_string($obj.child[0], 0, 24, 906, 156, 80)
	$$update_ui_string_param($obj.child[0], 36, 0, 0, 100, 1, 0, 0, 0)
	$obj.child[0].f_align = <STRING_ALIGN_CENTER>
}

//---------------------------------------------------------------------------
// 回答ボタンを表示する
//---------------------------------------------------------------------------
command $$show_answer_button
{
	property $i
	
	for( $i = 0, $i < <ANSWER_NUM>, $i += 1 )
	{
		$$update_ui_string(front.object[<PLAY07_OBJ_BUTTON> + $i].child[0], $$get_kyplay07_anser_text($question_index, $answer_list[$i]))
		
		front.object[<PLAY07_OBJ_BUTTON> + $i].tr = 0
		front.object[<PLAY07_OBJ_BUTTON> + $i].tr_eve.set_real(255, 500, 0, 2)
		front.object[<PLAY07_OBJ_BUTTON> + $i].x_rep[0] = 200
		front.object[<PLAY07_OBJ_BUTTON> + $i].x_rep_eve[0].set_real(0, 500, 0, 2)
		front.object[<PLAY07_OBJ_BUTTON> + $i].y_rep[0] = 0
		
		front.object[<PLAY07_OBJ_BUTTON> + $i].bright_eve.end
	}
}

//---------------------------------------------------------------------------
// 回答ボタンを非表示にする
//---------------------------------------------------------------------------
command $$hide_answer_button(property $select_index, property $result)
{
	property $i
	
	for( $i = 0, $i < <ANSWER_NUM>, $i += 1 )
	{
		switch( $result ) {
		case(0)		// 不正解
			
			if( $i == $select_index )
			{
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr = 255
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr_eve.set_real(0, 250, 750, 2)
			}
			else
			{
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr = 255
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr_eve.set_real(0, 500, 0, 2)
				front.object[<PLAY07_OBJ_BUTTON> + $i].x_rep[0] = 0
				front.object[<PLAY07_OBJ_BUTTON> + $i].x_rep_eve[0].set_real(-200, 500, 0, 2)
			}
			
		case(1)		// 正解
			
			if( $i == $select_index )
			{
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr = 255
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr_eve.set_real(0, 250, 250, 2)
			}
			else
			{
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr = 255
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr_eve.set_real(0, 500, 0, 2)
				front.object[<PLAY07_OBJ_BUTTON> + $i].y_rep[0] = 0
				front.object[<PLAY07_OBJ_BUTTON> + $i].y_rep_eve[0].set_real(50, 500, 0, 2)
			}
			
		case(2)		// 連続正解／得点
			
			if( $i == $select_index )
			{
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr = 255
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr_eve.set_real(0, 250, 250, 2)
			}
			else
			{
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr = 255
				front.object[<PLAY07_OBJ_BUTTON> + $i].tr_eve.set_real(0, 500, 0, 2)
				front.object[<PLAY07_OBJ_BUTTON> + $i].y_rep[0] = 0
				front.object[<PLAY07_OBJ_BUTTON> + $i].y_rep_eve[0].set_real(50, 500, 0, 2)
			}
		}
	}
}

//---------------------------------------------------------------------------
// 次の質問へ進める
//---------------------------------------------------------------------------
command $$next_question(property $obj : object)
{
	$answer_streak = 0
	$question_index += 1
	
	if( $question_index >= <QUESTION_NUM> ) {
		$$create_question_list
	}
}

//---------------------------------------------------------------------------
// 正解／不正解表示
//---------------------------------------------------------------------------
command $$show_result(property $obj : object, property $select_index)
{
	$obj.child[6].y = front.object[<PLAY07_OBJ_BUTTON> + $select_index].y - 52
	
	// 正解
	if( $answer_list[$select_index] == 0 )
	{
		// 正解／不正解
		$obj.child[6].patno = 0
		$obj.child[6].set_scale(500, 500)
		$obj.child[6].scale_x_eve.set_real(1000, 150, 0, 2)
		$obj.child[6].scale_y_eve.set_real(1000, 150, 0, 2)
		$obj.child[6].tr = 255
		$obj.child[6].tr_eve.set_real(0, 250, 500, 2)
		
		// 連続正解
		$obj.child[7].disp = 1
		$obj.child[7].patno = $answer_streak
		$obj.child[7].y = front.object[<PLAY07_OBJ_BUTTON> + $select_index].y - 7
		$obj.child[7].tr = 255
		$obj.child[7].tr_eve.set_real(0, 250, 500, 2)
		$obj.child[7].bright = 255
		$obj.child[7].bright_eve.set_real(0, 250, 0, 2)
		
		switch( $answer_streak ) {
		case(0)		$obj.child[7].set_scale(1500, 1500)
		case(1)		$obj.child[7].set_scale(2000, 2000)
		case(2)		$obj.child[7].set_scale(2500, 2500)
		}
		
		$obj.child[7].scale_x_eve.set_real(1000, 150, 0, 2)
		$obj.child[7].scale_y_eve.set_real(1000, 150, 0, 2)
	}
	
	// 不正解
	else
	{
		// 正解／不正解
		$obj.child[6].patno = 1
		$obj.child[6].set_scale(1500, 1500)
		$obj.child[6].scale_x_eve.set_real(1000, 250, 0, 2)
		$obj.child[6].scale_y_eve.set_real(1000, 250, 0, 2)
		$obj.child[6].tr = 255
		$obj.child[6].tr_eve.set_real(0, 250, 750, 2)
		
		$obj.child[7].disp = 0
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	$$set_joypad_focus_button(<PLAY07_OBJ_BUTTON> + 0)
	
	$stage.object[<PLAY07_OBJ_BUTTON> + 0].joypad_up    = <PLAY07_OBJ_BUTTON> + 3
	$stage.object[<PLAY07_OBJ_BUTTON> + 0].joypad_down  = <PLAY07_OBJ_BUTTON> + 1
	$stage.object[<PLAY07_OBJ_BUTTON> + 0].joypad_left  = -1
	$stage.object[<PLAY07_OBJ_BUTTON> + 0].joypad_right = -1
	
	$stage.object[<PLAY07_OBJ_BUTTON> + 1].joypad_up    = <PLAY07_OBJ_BUTTON> + 0
	$stage.object[<PLAY07_OBJ_BUTTON> + 1].joypad_down  = <PLAY07_OBJ_BUTTON> + 2
	$stage.object[<PLAY07_OBJ_BUTTON> + 1].joypad_left  = -1
	$stage.object[<PLAY07_OBJ_BUTTON> + 1].joypad_right = -1
	
	$stage.object[<PLAY07_OBJ_BUTTON> + 2].joypad_up    = <PLAY07_OBJ_BUTTON> + 1
	$stage.object[<PLAY07_OBJ_BUTTON> + 2].joypad_down  = <PLAY07_OBJ_BUTTON> + 3
	$stage.object[<PLAY07_OBJ_BUTTON> + 2].joypad_left  = -1
	$stage.object[<PLAY07_OBJ_BUTTON> + 2].joypad_right = -1
	
	$stage.object[<PLAY07_OBJ_BUTTON> + 3].joypad_up    = <PLAY07_OBJ_BUTTON> + 2
	$stage.object[<PLAY07_OBJ_BUTTON> + 3].joypad_down  = <PLAY07_OBJ_BUTTON> + 0
	$stage.object[<PLAY07_OBJ_BUTTON> + 3].joypad_left  = -1
	$stage.object[<PLAY07_OBJ_BUTTON> + 3].joypad_right = -1
}
