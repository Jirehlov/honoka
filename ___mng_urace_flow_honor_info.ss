//===========================================================================
//!
//!    @file     ___mng_urace_flow_honor_info.ss
//!    @brief    ＵＭＡレース／名声ポイント画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     複数の画面から遷移してくるためオーバーレイとして表示する
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景					120
	#replace	@ボタン_閉じる						121
	#replace	@オブジェクト_システムメッセージ	122
	
	// 変数
	#property	$select_btn		// 選択したボタン
	
#inc_end


//===========================================================================
// 名声ポイントフロー
//===========================================================================
#z00

@ＵＭＡレースシーン設定

$$create_scene_object(back)		// シーンオブジェクトを作成する
$$set_joypad_navigation(back)	// パッド入力の遷移を設定する
$$show_scene_object(back, $$get_urace_honor - l[0], $$get_urace_honor)		// シーンオブジェクトを作成する

timewait_key(250)

// ジョイパッドで最初に選択されているボタンを設定する
$$set_joypad_focus_button(@ボタン_閉じる)

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_MODAL>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
	
	// キャンセルは閉じるボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_閉じる
	}
	
	// 閉じるボタンが押された場合は終了する
	if( $select_btn == @ボタン_閉じる )
	{
		break
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

// シーンオブジェクトを非表示にする
$$hide_scene_object(front)

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	// フィルター
	$stage.object[@オブジェクト_背景].create("__mng_ur_honor_filter", 1)
	$stage.object[@オブジェクト_背景].child.resize(4)
	
	// 背景
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_honor_bg", 1, 507, 166)
	$stage.object[@オブジェクト_背景].child[0].y_rep.resize(1)
	
	// ピラミッド
	$stage.object[@オブジェクト_背景].child[1].create("__mng_ur_honor_rank", 1, 652, 315)
	$stage.object[@オブジェクト_背景].child[1].y_rep.resize(1)
	
	$stage.object[@オブジェクト_背景].child[2].create("__mng_ur_honor_rank", 1, 652, 315, 1)
	$stage.object[@オブジェクト_背景].child[2].set_clip(1, 652, 315, 1098, 702)
	$stage.object[@オブジェクト_背景].child[2].y_rep.resize(1)
	
	// カーソル
	$stage.object[@オブジェクト_背景].child[3].create(__mng_ur_honor_cursor, 0, 597, 702)
	$stage.object[@オブジェクト_背景].child[3].center_y = $stage.object[@オブジェクト_背景].child[3].get_size_y / 2
	$stage.object[@オブジェクト_背景].child[3].x_rep.resize(2)
	$stage.object[@オブジェクト_背景].child[3].y_rep.resize(1)
	$stage.object[@オブジェクト_背景].child[3].x_rep[0] = $$get_cursor_x($$get_urace_honor)
	$stage.object[@オブジェクト_背景].child[3].y_rep[0] = $$get_cursor_y($$get_urace_honor)
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], __mng_ur_honor_close_btn, 792, 736, @ボタン_閉じる, <URACE_BTN_GROUP_MODAL>, 2)
	$stage.object[@ボタン_閉じる].disp = 0
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage, property $src_honor, property $dst_honor)
{
	property $i
	
	// アニメーション
	$stage.object[@オブジェクト_背景].child[0].y_rep[0] = 50
	$stage.object[@オブジェクト_背景].child[0].y_rep_eve[0].set(0, 500, 250, 2)
	$stage.object[@オブジェクト_背景].child[0].tr = 0
	$stage.object[@オブジェクト_背景].child[0].tr_eve.set(255, 500, 250, 2)
	
	$stage.object[@オブジェクト_背景].child[1].y_rep[0] = 50
	$stage.object[@オブジェクト_背景].child[1].y_rep_eve[0].set(0, 500, 250, 2)
	$stage.object[@オブジェクト_背景].child[1].tr = 0
	$stage.object[@オブジェクト_背景].child[1].tr_eve.set(255, 500, 250, 2)
	
	$stage.object[@オブジェクト_背景].child[2].y_rep[0] = 50
	$stage.object[@オブジェクト_背景].child[2].y_rep_eve[0].set(0, 500, 250, 2)
	$stage.object[@オブジェクト_背景].child[2].tr = 0
	$stage.object[@オブジェクト_背景].child[2].tr_eve.set(255, 500, 250, 2)
	$stage.object[@オブジェクト_背景].child[2].clip_top = $stage.object[@オブジェクト_背景].child[2].clip_bottom + $$get_cursor_y($src_honor)
	
	// ワイプ
	wipe(0, 250, wait=1)
	
	// イベント終了待ち
	front.object[@オブジェクト_背景].child[0].tr_eve.wait
	
	// 名声ポイントの変動がない場合はアニメーションしない
	if( $src_honor == $dst_honor )
	{
		// カーソルを表示する
		front.object[@オブジェクト_背景].child[3].disp = 1
		front.object[@オブジェクト_背景].child[3].x_rep[1] = -30
		front.object[@オブジェクト_背景].child[3].x_rep_eve[1].set(0, 300, 0, 2)
		front.object[@オブジェクト_背景].child[3].x_rep_eve[1].wait
		
		// 閉じるボタンを表示する
		front.object[@ボタン_閉じる].disp = 1
		
		return
	}
	
	// 名声ポイントに変動があったのでアニメーションを表示する
	$$play_honor_change_animation(front, $src_honor, $dst_honor)
	
	// アニメーション終了後に閉じるボタンを表示する
	front.object[@ボタン_閉じる].disp = 1
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_閉じる].init
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	$stage.object[@ボタン_閉じる].joypad_up    = -1
	$stage.object[@ボタン_閉じる].joypad_down  = -1
	$stage.object[@ボタン_閉じる].joypad_left  = -1
	$stage.object[@ボタン_閉じる].joypad_right = -1
}

//---------------------------------------------------------------------------
// 名声ポイント変動アニメーションを再生する
//---------------------------------------------------------------------------
command $$play_honor_change_animation(property $stage : stage, property $src_honor, property $dst_honor)
{
	property $animation_time
	
	// 入力待ち
	timewait_key(500)
	
	// アニメーションにかける時間を設定する
	$animation_time = 3000
	
	// カーソル座標を変動前の名声ポイントに設定する
	$stage.object[@オブジェクト_背景].child[3].x_rep[0] = $$get_cursor_x($src_honor)
	$stage.object[@オブジェクト_背景].child[3].y_rep[0] = $$get_cursor_y($src_honor)
	
	// カーソルを表示する
	$stage.object[@オブジェクト_背景].child[3].disp = 1
	$stage.object[@オブジェクト_背景].child[3].x_rep[1] = -30
	$stage.object[@オブジェクト_背景].child[3].x_rep_eve[1].set(0, 300, 0, 2)
	$stage.object[@オブジェクト_背景].child[3].x_rep_eve[1].wait
	
	// pcmch[0].play("_urace_honor_cursor_move")	todo カーソルアニメＳＥ
	
	// カーソルアニメーションを開始する
	@mng_counter.start
	input.clear
	while(1) {
		
		// アニメーション時間が終了した場合は終了する
		if( @mng_counter.get > $animation_time ) {
			break
		}
		
		// 入力があった場合は終了する
		if( input.decide.on_down_up || input.cancel.on_down_up ) {
			break
		}
		
		// 表示矩形を獲得した名声ポイント分だけ移動する
		$stage.object[@オブジェクト_背景].child[2].clip_top = $stage.object[@オブジェクト_背景].child[2].clip_bottom + $$get_cursor_y(math.timetable(@mng_counter.get, 0, $src_honor, [0, $animation_time, $dst_honor, 2]))
		
		// カーソル座標を獲得した名声ポイント分だけ移動する
		$stage.object[@オブジェクト_背景].child[3].x_rep[0] = $$get_cursor_x(math.timetable(@mng_counter.get, 0, $src_honor, [0, $animation_time, $dst_honor, 2]))
		$stage.object[@オブジェクト_背景].child[3].y_rep[0] = $$get_cursor_y(math.timetable(@mng_counter.get, 0, $src_honor, [0, $animation_time, $dst_honor, 2]))
		
		input.next		// 入力の更新
		disp			// 画面の更新
	}
	
	// カーソル座標を変動後の名声ポイントに設定する
	$stage.object[@オブジェクト_背景].child[3].x_rep[0] = $$get_cursor_x($dst_honor)
	$stage.object[@オブジェクト_背景].child[3].y_rep[0] = $$get_cursor_y($dst_honor)
	
	// ランクの変動がない場合は終了する
	if( $$get_urace_honor_rank($src_honor) == $$get_urace_honor_rank($dst_honor) ) {
		return
	}
	
	// 入力待ち
	timewait_key(500)
	
	// pcmch[0].play("_urace_honor_rank_up")		todo ランクアップＳＥ
	// todo エフェクト（紙吹雪とかにぎやかし系）
	
	// ランクの変動があったのでシステムメッセージを表示する
	$$show_urace_system_message($stage.object[@オブジェクト_システムメッセージ], $$get_urace_honor_rank_up_text($$get_urace_honor_rank($dst_honor)))
	
	input.clear
	while(1) {
		
		// 入力があった場合は終了する
		if( input.decide.on_down_up || input.cancel.on_down_up ) {
			break
		}
		
		input.next		// 入力の更新
		disp			// 画面の更新
	}
	
	// システムメッセージを非表示にする
	$$hide_urace_system_message($stage.object[@オブジェクト_システムメッセージ])
	
	$stage.object[@オブジェクト_システムメッセージ].all_eve.wait
}

//---------------------------------------------------------------------------
// 名声ポイントに応じたカーソルの位置を取得する
//---------------------------------------------------------------------------
command $$get_cursor_x(property $honor)
{
	property $x
	
	// それぞれのランクからピラミッド左辺、右辺の座標を取得する
	switch( $$get_urace_honor_rank($honor) ) {
	case(<URACE_HONOR_RANK_T>)		$x = math.linear($honor, 0, 0, <URACE_HONOR_N>, 34)
	case(<URACE_HONOR_RANK_N>)		$x = math.linear($honor, <URACE_HONOR_N>, 34, <URACE_HONOR_R>, 70)
	case(<URACE_HONOR_RANK_R>)		$x = math.linear($honor, <URACE_HONOR_R>, 70, <URACE_HONOR_SR>, 105)
	case(<URACE_HONOR_RANK_SR>)		$x = math.linear($honor, <URACE_HONOR_SR>, 105, <URACE_HONOR_SSR>, 141)
	case(<URACE_HONOR_RANK_SSR>)	$x = math.linear($honor, <URACE_HONOR_SSR>, 141, <URACE_HONOR_MR>, 177)
	case(<URACE_HONOR_RANK_MR>)		$x = math.linear($honor, <URACE_HONOR_MR>, 177, <URACE_HONOR_MAX>, 223)
	}
	
	return ($x)
}

command $$get_cursor_y(property $honor)
{
	property $y
	
	// それぞれのランクからピラミッド上辺、下辺の座標を取得する
	switch( $$get_urace_honor_rank($honor) ) {
	case(<URACE_HONOR_RANK_T>)		$y = math.linear($honor, 0, 0, <URACE_HONOR_N>, 64)
	case(<URACE_HONOR_RANK_N>)		$y = math.linear($honor, <URACE_HONOR_N>, 64, <URACE_HONOR_R>, 126)
	case(<URACE_HONOR_RANK_R>)		$y = math.linear($honor, <URACE_HONOR_R>, 126, <URACE_HONOR_SR>, 187)
	case(<URACE_HONOR_RANK_SR>)		$y = math.linear($honor, <URACE_HONOR_SR>, 187, <URACE_HONOR_SSR>, 249)
	case(<URACE_HONOR_RANK_SSR>)	$y = math.linear($honor, <URACE_HONOR_SSR>, 249, <URACE_HONOR_MR>, 311)
	case(<URACE_HONOR_RANK_MR>)		$y = math.linear($honor, <URACE_HONOR_MR>, 311, <URACE_HONOR_MAX>, 387)
	}
	
	return (-$y)
}
