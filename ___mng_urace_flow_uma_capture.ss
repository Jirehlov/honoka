//===========================================================================
//!
//!    @file     ___mng_urace_flow_uma_capture.ss
//!    @brief    ＵＭＡレース／ＵＭＡ捕獲画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景		100
	#replace	@ボタン_閉じる			101
	#replace	@ボタン_ＵＭＡ			102
	
	// 変数
	#property	$select_btn		// 選択したボタン
	#property	$hunter_index
	
#inc_end

//===========================================================================
// ＵＭＡ捕獲フロー
//===========================================================================
#z00

$hunter_index = l[0]
$$create_scene_object(front)		// シーンオブジェクトを作成する
$$set_joypad_navigation(front)		// パッド入力の遷移を設定する

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_MODAL_2>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL_2>)
	
	// キャンセルは何もしない
	if( $select_btn == -1 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_MODAL_2>)
	}
	
	// 閉じるボタンが押された場合は終了する
	if( $select_btn == @ボタン_閉じる )
	{
		break
	}
	
	// ＵＭＡボタンが押された場合はＵＭＡ詳細へ
	/*
	elseif( $select_btn >= @ボタン_ＵＭＡ )
	{
		$select_btn -= @ボタン_ＵＭＡ
		
		// ＵＭＡ詳細フローへ
		farcall(___mng_urace_flow_uma_info, 0, <URACE_PLAYER_OWNER_ID>, $$get_entry_owner_uma_list($owner_index, $select_btn))
		
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_MODAL_2>)
	}
	*/
	
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
	property $i
	property $uma_id
	property $label_no
	
	// 背景
	$$create_urace_race_base_bg($stage.object[@オブジェクト_背景], <URACE_GROUND_TYPE_TURF>)
	$stage.object[@オブジェクト_背景].child[0].child[0].patno = 4 + <URACE_GROUND_TYPE_TURF>
	
	// 檻
	
	// 捕獲処理実行
	$$execute_hunter_request($hunter_index)
	
	for( $i = 0, $i < $$get_hunter_request_result_uma_count, $i += 1 )
	{
		$$create_uma_card_object(front.object[@ボタン_ＵＭＡ + $i], $$get_uma_id(<URACE_WILD_OWNER_ID>, $i), 204 + $i * 524, 204)
		front.object[@ボタン_ＵＭＡ + $i].set_scale(750,750)
		
		front.object[@ボタン_ＵＭＡ + $i].y = 204 + 50
		front.object[@ボタン_ＵＭＡ + $i].y_eve.set(204, 500, 0, 2)
		front.object[@ボタン_ＵＭＡ + $i].bright = 255
		front.object[@ボタン_ＵＭＡ + $i].bright_eve.set(0, 500, 0, 2)
		
		timewait_key(500)
		
		$uma_id = $$get_uma_id(<URACE_WILD_OWNER_ID>, $i)
		$label_no = 0
		
		if( $$get_uma_library_flag($uma_id) >= <URACE_LIBRARY_FLAG_GET> ) {
			$label_no += 1
		}
		switch( $uma_id ) {
		case(@ＵＭＡ_ツミレ)					$label_no += 80
		case(@ＵＭＡ_河瀬)						$label_no += 50
		case(@ＵＭＡ_小森)						$label_no += 60
		case(@ＵＭＡ_東の風神・エウロス)		$label_no += 10
		case(@ＵＭＡ_南の風神・ノトス)			$label_no += 20
		case(@ＵＭＡ_西の風神・ゼピュロス)		$label_no += 30
		case(@ＵＭＡ_北の風神・ボレアス)		$label_no += 40
		case(@ＵＭＡ_メドゥーサ)				$label_no += 70
		case(@ＵＭＡ_Ｔ－ＲＥＸ玖琉未)			$label_no += 70
		}
		
		if( $label_no >= 10 ) {
	;		farcall("100_UMA9999", $label_no)
		}
	}
	
	if( <PLAYER_UMA_SLOT_MAX> - $$get_my_uma_num >= l[0] )
	{
		for( $i = 0, $i < l[0], $i += 1 )
		{
			$$add_my_uma_from_wild_uma($i)
		}
	}
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], _mng_ur_common_close_btn, 57, 951, @ボタン_閉じる, <URACE_BTN_GROUP_MODAL_2>, 2)
	
	return
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	property $i
	
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_閉じる].init
	for( $i = 0, $i < <URACE_DECK_UMA_MAX>, $i += 1 ) {
		$stage.object[@ボタン_ＵＭＡ + $i].init
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_閉じる)
	
	$stage.object[@ボタン_閉じる].joypad_up    = -1
	$stage.object[@ボタン_閉じる].joypad_down  = -1
	$stage.object[@ボタン_閉じる].joypad_left  = -1
	$stage.object[@ボタン_閉じる].joypad_right = -1
}
