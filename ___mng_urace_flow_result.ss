//===========================================================================
//!
//!    @file     ___mng_urace_flow_result.ss
//!    @brief    ＵＭＡレース／レース結果画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レース後の着順などの詳細画面
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景		0		// ベース
	#replace	@ボタン_次へ			1		// 次へボタン
	#replace	@ボタン_ＵＭＡ詳細		2		// ＵＭＡ詳細ボタン
	
	// 変数
	#property	$select_btn					// 選択したボタン
	#property	$uma_order : intlist		// 着順リスト
	#property	$added_honor				// 加算された名声ポイント
	#property	$player_id					// プレイヤーＩＤ
	#property	$rival_id					// ライバルＩＤ
	
#inc_end


//===========================================================================
// レース結果フロー
//===========================================================================
#z00

@ＵＭＡレースシーン設定

pcmch[0].play("_hhp_wave_clear")
// pcmch[0].play("_urace_honor_result")		todo リザルトＳＥ

$$set_result_data					// レース結果データを設定する
$$create_scene_object(back)			// シーンオブジェクトを作成する
$$set_joypad_navigation(back)		// パッド入力の遷移を設定する
$$show_scene_object(back)			// シーンオブジェクトを表示する

@bgm(bgm10)

// 名声画面へ
farcall(___mng_urace_flow_honor_info, 0, $added_honor)

// ジョイパッドで最初に選択されているボタンを設定する
$$set_joypad_focus_button(@ボタン_次へ)

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_NORMAL>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_NORMAL>)
	
	// 次へボタンが押された場合は終了する
	if( $select_btn == @ボタン_次へ )
	{
		break
	}
	
	// ＵＭＡ詳細ボタンが押された場合はＵＭＡ詳細画へ
	elseif( $select_btn >= @ボタン_ＵＭＡ詳細 )
	{
		// ＵＭＡ詳細フローへ
		farcall(___mng_urace_flow_entry_uma_info, 0, $uma_order[$select_btn - @ボタン_ＵＭＡ詳細])
		
		// 選択されたボタンを元の状態に戻す
		front.object[$select_btn].set_button_state_normal
		
		$$set_joypad_focus_button($select_btn)	// 選択されたボタンをジョイパッドで選択中のボタンに再設定する
		$$update_joypad_focus_button(front)		// 選択されたボタンの描画を更新する
	}
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_NORMAL>)
	}
	
	// 何も押していないときは画面の更新のみ
	else
	{
		input.next		// 入力の更新
		disp			// 画面の更新
	}
}

@bgm_stop

$$hide_scene_object(front)		// シーンオブジェクトを非表示する

@ＵＭＡレースシーン設定解除

return


//---------------------------------------------------------------------------
// レース結果データを設定する
//---------------------------------------------------------------------------
command $$set_result_data
{
	property $i
	property $len
	property $honor
	
	// プレイヤー／ライバルＩＤを保存する
	$player_id = <URACE_PLAYER_OWNER_ID>
	$rival_id  = $$get_db_race_entry_rival($$get_entry_race_id)
	
	// 参加者を着順にソートする
	$len = $$get_entry_owner_num
	
	$uma_order.init
	$uma_order.resize($len)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$uma_order[$$get_entry_owner_goal_order($i) - 1] = $i
	}
	
	// チュートリアルレースの場合は名声ポイントを追加しない
	if( $$get_entry_race_id == @レース_模擬レース ) {
		return
	}
	
	// 着順によって加算する名声ポイントを変更する
	switch( $$get_entry_owner_goal_order($$get_player_from_entry_owner_list) ) {
	case(1)		$honor = <URACE_HONOR_ADDED_1ST>
	case(2)		$honor = <URACE_HONOR_ADDED_2ND>
	case(3)		$honor = <URACE_HONOR_ADDED_3RD>
	case(4)		$honor = <URACE_HONOR_ADDED_4TH>
	case(5)		$honor = <URACE_HONOR_ADDED_5TH>
	case(6)		$honor = <URACE_HONOR_ADDED_6TH>
	}
	
	// 名声ポイントを加算する
	$$add_urace_honor($honor)
	
	// 加算された名声ポイントを保存する
	$added_honor = $honor
}

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $len
	property $owner_id
	property $filename : str
	property $pos_x
	property $pos_y
	property $base_x
	property $base_y
	property $offset_x
	property $offset_y
	
	$len = $$get_entry_owner_num
	
	// 勝利ＵＭＡ
	$stage.object[@オブジェクト_背景].create("__mng_ur_result_uma_image" + math.tostr_zero($$get_uma_id($$get_entry_owner_id($uma_order[0]), $$get_entry_uma_index($uma_order[0])), 2), 1, 0, 0)
	$stage.object[@オブジェクト_背景].wipe_copy = 1
	$stage.object[@オブジェクト_背景].child.resize(2 + $len * 2)
	
	// 背景
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_result_bg", 1, 705, 0)
	$stage.object[@オブジェクト_背景].child[0].x_rep.resize(1)
	
	// タグ
	$stage.object[@オブジェクト_背景].child[1].create("__mng_ur_result_tag", 1, 1226, 38, 1)
	$stage.object[@オブジェクト_背景].child[2].create("__mng_ur_result_tag", 1, 1226, 38, 0)
	
	// 勝利アイコン
	$stage.object[@オブジェクト_背景].child[3].create("__mng_ur_result_win_icon", 1, 31, 800)
	$$set_image_center_rep($stage.object[@オブジェクト_背景].child[3])
	
	// 出走者枠
	$base_x = 829
	$base_y = 189
	$offset_x = 88
	$offset_y = 121
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$owner_id = $$get_entry_owner_id($uma_order[$i])
		
		// 座標設定
		$pos_x = $base_x
		$pos_y = $base_y + $offset_y * $i
		
		// 作成
		$$create_lane_info_object($stage.object[@オブジェクト_背景].child[4 + $i], $i, $pos_x, $pos_y)
	}
	
	// 出走ＵＭＡボタン
	$base_x = 1799
	$base_y = 193
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$owner_id = $$get_entry_owner_id($uma_order[$i])
		
		// 座標設定
		$pos_x = $base_x
		$pos_y = $base_y + $offset_y * $i
		
		// ファイル名設定
		switch( $owner_id ) {
		case($player_id)	$filename = "__mng_ur_result_uma_info_btn1"
		case($rival_id)		$filename = "__mng_ur_result_uma_info_btn2"
		default				$filename = "__mng_ur_result_uma_info_btn3"
		}
		
		// 作成
		$$create_ui_button($stage.object[@ボタン_ＵＭＡ詳細 + $i], $filename, $pos_x, $pos_y, @ボタン_ＵＭＡ詳細 + $i, <URACE_BTN_GROUP_NORMAL>, 1)
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].x_rep.resize(1)
	}
	
	// 次へボタン
	$$create_ui_button($stage.object[@ボタン_次へ], __mng_ur_result_next_btn, 1348, 916, @ボタン_次へ, <URACE_BTN_GROUP_NORMAL>, 1)
	$stage.object[@ボタン_次へ].x_rep.resize(1)
}

// 各レーン(ＵＭＡ、オーナー)詳細オブジェクトを作成する
command $$create_lane_info_object(property $obj : object, property $index, property $x, property $y)
{
	property $owner_id
	property $uma_index
	property $patno
	property $goal_time
	property $filename1 : str
	property $filename2 : str
	
	$owner_id = $$get_entry_owner_id($uma_order[$index])
	$uma_index = $$get_entry_uma_index($uma_order[$index])
	$goal_time = $$get_entry_owner_goal_time($uma_order[$index])
	
	// プレイヤー／ライバル／モブで背景パターンを変更する
	switch( $owner_id ) {
	case($player_id)	$patno = 0
	case($rival_id)		$patno = 1
	default				$patno = 2
	}
	
	// 背景
	$obj.create("__mng_ur_result_lane_bg", 1, $x, $y, $patno)
	$obj.x_rep.resize(1)
	$obj.child.resize(7)
	
	// プレイヤー／その他で表示位置等を変更する
	if( $owner_id == $player_id )
	{
		// 着順
		$obj.child[0].create("__mng_ur_result_lane_order_number1", 1, 36, 25, $index)
		
		// オーナーサムネイル
	$obj.child[1].create("__mng_ur_result_owner_icon" + math.tostr_zero($$get_db_owner_image_no($owner_id), 2), 1, 120, 5)
		// オーナー称号
	$obj.child[2].create_string($$get_db_owner_title($owner_id), 1, 319, 30)
	$obj.child[2].set_string_param(16, 0, 0, 12, 0, 0, 0)
		// オーナー名
	$obj.child[3].create_string($$get_db_owner_name($owner_id), 1, 318, 63)
	$obj.child[3].set_string_param(33, 0, 0, 6, 0, 0, 0)
		
		// ゴールタイム（分）
		$obj.child[4].create_number("__mng_ur_result_lane_time_number11", 1, 769, 47)
		$obj.child[4].set_number_param(2, 1, 0, 0, 0, -5)
		
		// ゴールタイム（秒）
		$obj.child[5].create_number("__mng_ur_result_lane_time_number11", 1, 844, 47)
		$obj.child[5].set_number_param(2, 1, 0, 0, 0, -4)
		
		// ゴールタイム（小数点以下）
		$obj.child[6].create_number("__mng_ur_result_lane_time_number12", 1, 913, 72)
		$obj.child[6].set_number_param(2, 1, 0, 0, 0, -2)
	}
	else
	{
		// 着順
		$obj.child[0].create("__mng_ur_result_lane_order_number2", 1, 125, 28, $index)
		
		// オーナーサムネイル
	$obj.child[1].create("__mng_ur_result_owner_icon" + math.tostr_zero($$get_db_owner_image_no($owner_id), 2), 1, 200, 5)
		// オーナー称号
	$obj.child[2].create_string($$get_db_owner_title($owner_id), 1, 399, 30)
	$obj.child[2].set_string_param(16, 0, 0, 15, 0, 0, 0)
		// オーナー名
	$obj.child[3].create_string($$get_db_owner_name($owner_id), 1, 398, 63)
	$obj.child[3].set_string_param(33, 0, 0, 15, 0, 0, 0)
		
		// ゴールタイム（分）
		$obj.child[4].create_number("__mng_ur_result_lane_time_number21", 1, 841, 51)
		$obj.child[4].set_number_param(2, 1, 0, 0, 0, -3)
		
		// ゴールタイム（秒）
		$obj.child[5].create_number("__mng_ur_result_lane_time_number21", 1, 894, 51)
		$obj.child[5].set_number_param(2, 1, 0, 0, 0, -3)
		
		// ゴールタイム（小数点以下）
		$obj.child[6].create_number("__mng_ur_result_lane_time_number22", 1, 942, 68)
		$obj.child[6].set_number_param(2, 1, 0, 0, 0, -2)
	}
	
	
	$obj.child[4].set_number($goal_time / 1000 / 60)
	$obj.child[5].set_number($goal_time / 1000 % 60)
	$obj.child[6].set_number(($goal_time / 10) % 100)
	
	/*
	// プレイヤー／その他で画像パターンを変更する
	switch( $owner_id ) {
	case($player_id)	$filename1 = "__mng_ur_result_lane_order_number1"
	default				$filename1 = "__mng_ur_result_lane_order_number2"
	}
	$obj.child[0].create($filename1, 1, 36, 28, $index)
	
	// オーナーサムネイル
	$obj.child[1].create("__mng_ur_result_owner_icon" + math.tostr_zero($$get_db_owner_image_no($owner_id), 2), 1, 120, 5)
	$obj.child[1].disp = 0
	
	// オーナー称号
	
	// オーナー名
	$obj.child[3].create_string($$get_db_owner_name($owner_id), 1, 318, 63)
	$obj.child[3].set_string_param(40, 0, 0, 6, 0, 0, 0)
	*/
	
	// ゴールタイム
	// プレイヤー／その他で画像パターンを変更する
	switch( $owner_id ) {
	case($player_id)	$filename1 = "__mng_ur_result_lane_time_number11"
						$filename2 = "__mng_ur_result_lane_time_number12"
	default				$filename1 = "__mng_ur_result_lane_time_number21"
						$filename2 = "__mng_ur_result_lane_time_number22"
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// アニメーション
	$stage.object[@オブジェクト_背景].child[3].set_scale(5000, 5000)
	$stage.object[@オブジェクト_背景].child[3].scale_x_eve.set(1000, 350, 250, 2)
	$stage.object[@オブジェクト_背景].child[3].scale_y_eve.set(1000, 350, 250, 2)
	$stage.object[@オブジェクト_背景].child[3].bright = 255
	$stage.object[@オブジェクト_背景].child[3].bright_eve.set(0, 350, 250, 2)
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@オブジェクト_背景].child[4 + $i].tr = 0
		$stage.object[@オブジェクト_背景].child[4 + $i].tr_eve.set(255, 250, 600 + $i * 50, 2)
		$stage.object[@オブジェクト_背景].child[4 + $i].x_rep[0] = 50
		$stage.object[@オブジェクト_背景].child[4 + $i].x_rep_eve[0].set(0, 250, 600 + $i * 50, 2)
		
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].tr = 0
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].tr_eve.set(255, 250, 600 + $i * 50, 2)
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].x_rep[0] = 50
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].x_rep_eve[0].set(0, 250, 600 + $i * 50, 2)
	}
	
	$stage.object[@ボタン_次へ].tr = 0
	$stage.object[@ボタン_次へ].tr_eve.set(255, 350, 900, 2)
	$stage.object[@ボタン_次へ].x_rep[0] = 200
	$stage.object[@ボタン_次へ].x_rep_eve[0].set(0, 350, 900, 2)
	
	// ワイプ
	wipe(0, 250, wait=1)
	
	timewait_key(1000)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	$$set_front_wipe_copy_all(0)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	property $i
	property $len
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_up    = @ボタン_ＵＭＡ詳細 + $i - 1
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_down  = @ボタン_ＵＭＡ詳細 + $i + 1
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_left  = -1
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_right = -1
		
		if( $i == 0 ) {
			$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_up = @ボタン_次へ
		}
		elseif( $i == $len - 1 ) {
			$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_down = @ボタン_次へ
		}
	}
	
	$stage.object[@ボタン_次へ].joypad_up    = @ボタン_ＵＭＡ詳細 + $len - 1
	$stage.object[@ボタン_次へ].joypad_down  = @ボタン_ＵＭＡ詳細
	$stage.object[@ボタン_次へ].joypad_left  = -1
	$stage.object[@ボタン_次へ].joypad_right = -1
}
