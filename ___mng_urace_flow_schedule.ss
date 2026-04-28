//===========================================================================
//!
//!    @file     ___mng_urace_flow_schedule.ss
//!    @brief    ＵＭＡレース／スケジュール画面
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
	#replace	@オブジェクト_背景		50
	#replace	@ボタン_閉じる			51
	#replace	@ボタン_カレンダー		52
	#define		@ボタン_カレンダー最大	(@ボタン_カレンダー + @カレンダーボタン数)
	
	// 表示するカレンダーボタンの数
	#replace	@カレンダーボタン開始日		12
	#replace	@カレンダーボタン数			13
	
	// 変数
	#property	$select_btn				// 選択したボタン
	#property	$select_date			// 選択している日付
	
#inc_end


//===========================================================================
// スケジュール詳細フロー
//===========================================================================
#z00

@ＵＭＡレースシーン設定

$$create_scene_object(front)		// シーンオブジェクトを作成する
$$set_joypad_navigation(front)		// パッド入力の遷移を設定する
$$show_scene_object(front)			// シーンオブジェクトを表示する

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
	
	// カレンダーボタンが押された場合
	if( $select_btn >= @ボタン_カレンダー )
	{
		$$update_scene_object(front, $select_btn - @ボタン_カレンダー + @カレンダーボタン開始日)
	}
	
	for( l[0] = 0, l[0] < @カレンダーボタン数, l[0] += 1 )
	{
		front.object[@ボタン_カレンダー + l[0]].layer = 0
		
		if( syscom.check_joypad_mode ) {
			if( $$get_joypad_focus_button == @ボタン_カレンダー + l[0] ) {
				front.object[@ボタン_カレンダー + l[0]].layer = 1
			}
		} else {
			if( $$get_hit_btn == @ボタン_カレンダー + l[0] ) {
				front.object[@ボタン_カレンダー + l[0]].layer = 1
			}
		}
	}
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_MODAL>)
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

$$hide_scene_object(front)			// シーンオブジェクトを非表示にする

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	
	// 選択している日付を現在の日付にする
	$select_date = @日付_日
	
	// フィルター
	$stage.object[@オブジェクト_背景].create("__mng_ur_schedule_filter", 1)
	$stage.object[@オブジェクト_背景].child.resize(2)
	
	// 背景
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_schedule_bg", 1, 140, 138)
	
	// レース情報／フレーム
	$stage.object[@オブジェクト_背景].child[1].create("__mng_ur_schedule_race_info_frame", 1, 1242, 190)
	$stage.object[@オブジェクト_背景].child[1].child.resize(5)
	
	// レース情報／レース背景
	$stage.object[@オブジェクト_背景].child[1].child[0].create("__mng_ur_schedule_race_info_bg", 1, 23, 58)
	
	// レース情報／レースロゴ
	$stage.object[@オブジェクト_背景].child[1].child[1].create("__mng_ur_schedule_race_info_medal", 1, 30, 90)
	
	// レース情報／開催日
	$stage.object[@オブジェクト_背景].child[1].child[2].create_number("__mng_ur_schedule_race_info_number", 1, 339, 495)
	$stage.object[@オブジェクト_背景].child[1].child[2].set_number_param(2, 1, 0, 0, 0, 0)
	
	// レース情報／距離
	$stage.object[@オブジェクト_背景].child[1].child[3].create_number("__mng_ur_schedule_race_info_number", 1, 266, 546)
	$stage.object[@オブジェクト_背景].child[1].child[3].set_number_param(4, 0, 0, 0, 0, 0)
	
	// レース情報／地形タイプ
	$stage.object[@オブジェクト_背景].child[1].child[4].create("__mng_ur_schedule_race_info_ground", 1, 288, 596)
	
	// カレンダーボタン
	for( $i = 0, $i < @カレンダーボタン数, $i += 1 )
	{
		$$create_ui_button($stage.object[@ボタン_カレンダー + $i], "__mng_ur_schedule_date_btn" + math.tostr_zero(2, 2), 205 + ($i % 5) * 201, 370 + ($i / 5) * 151, @ボタン_カレンダー + $i, <URACE_BTN_GROUP_MODAL>, 1)
		
		if( $i < $select_date - @カレンダーボタン開始日 ) {
;			$stage.object[@ボタン_カレンダー + $i].set_button_state_disable
		}
	}
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], "__mng_ur_schedule_close_btn", 2, 973, @ボタン_閉じる, <URACE_BTN_GROUP_MODAL>, 2)
	
	// シーンオブジェクトを更新する
	$$update_scene_object($stage, $select_date)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage, property $date)
{
	property $i
	property $len
	property $race_id
	
	// 選択している日付を更新する
	$select_date = $date
	
	// 選択している日に開催されるレースIDを取得する
	$len = $$get_db_race_max
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $select_date != $$get_db_race_day($i + 1) ) {
			continue
		}
		
		$race_id = $i + 1
		
		break
	}
	
	// レース情報
	if( $race_id == 0 )
	{
		// レースが開催されていない日
		$stage.object[@オブジェクト_背景].child[1].disp = 0
	
		return
	}
	elseif( $race_id < 12 )
	{
		// レースが開催されている／通常レース
		$stage.object[@オブジェクト_背景].child[1].disp = 1
		
		// レース情報／レース背景
		$stage.object[@オブジェクト_背景].child[1].child[0].patno = $$get_db_race_ground_type($race_id) - 1
		
		// レース情報／レースロゴ
		$stage.object[@オブジェクト_背景].child[1].child[1].patno = $race_id - 1
		
		// レース情報／開催日
		$stage.object[@オブジェクト_背景].child[1].child[2].set_number($date)
		
		// レース情報／距離
		$stage.object[@オブジェクト_背景].child[1].child[3].set_number($$get_db_race_distance($race_id))
		
		// レース情報／地形タイプ
		$stage.object[@オブジェクト_背景].child[1].child[4].patno = $$get_db_race_ground_type($race_id) - 1
	}
	else
	{
		// レースが開催されている／グランドカップ
		$stage.object[@オブジェクト_背景].child[1].disp = 1
		
		/*
		// レース情報／レース背景
		$stage.object[@オブジェクト_背景].child[1].child[0].patno = $$get_db_race_ground_type($race_id) - 1
		
		// レース情報／レースロゴ
		$stage.object[@オブジェクト_背景].child[1].child[1].patno = $race_id - 1
		
		// レース情報／開催日
		$stage.object[@オブジェクト_背景].child[1].child[2].set_number($date)
		
		// レース情報／距離
		$stage.object[@オブジェクト_背景].child[1].child[3].set_number($$get_urace_unknown_text)
		
		// レース情報／地形タイプ
		$stage.object[@オブジェクト_背景].child[1].child[4].patno = 0
		*/
	}
	
	// カレンダーボタン
	/*
	for( $i = 0, $i < @カレンダーボタン数, $i += 1 )
	{
		if( $i == $select_date - @カレンダーボタン開始日 ) {
			$stage.object[@ボタン_カレンダー + $i].set_button_state_select
		} elseif( $i < @日付_日 - @カレンダーボタン開始日 ) {
			$stage.object[@ボタン_カレンダー + $i].set_button_state_disable
		} else {
			$stage.object[@ボタン_カレンダー + $i].set_button_state_normal
		}
	}
	*/
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	property $i
	
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_閉じる].init
	
	for( $i = 0, $i < @カレンダーボタン数, $i += 1 )
	{
		$stage.object[@ボタン_カレンダー + $i].init
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	property $i
	
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_閉じる)
	
	$stage.object[@ボタン_閉じる].joypad_up    = @ボタン_カレンダー + @カレンダーボタン数 - 1
	$stage.object[@ボタン_閉じる].joypad_down  = @ボタン_カレンダー
	$stage.object[@ボタン_閉じる].joypad_left  = -1
	$stage.object[@ボタン_閉じる].joypad_right = -1
	
	// カレンダーボタン
	for( $i = 0, $i < @カレンダーボタン数, $i += 1 )
	{
		$stage.object[@ボタン_カレンダー + $i].joypad_up    = @ボタン_カレンダー + $i - 1
		$stage.object[@ボタン_カレンダー + $i].joypad_down  = @ボタン_カレンダー + $i + 1
		$stage.object[@ボタン_カレンダー + $i].joypad_left  = @ボタン_カレンダー + $i - 1
		$stage.object[@ボタン_カレンダー + $i].joypad_right = @ボタン_カレンダー + $i + 1
		
		if( $i == 0 ) {
			$stage.object[@ボタン_カレンダー + $i].joypad_up    = @ボタン_閉じる
			$stage.object[@ボタン_カレンダー + $i].joypad_left  = @ボタン_閉じる
		}
		if( $i == @カレンダーボタン数 - 1 ) {
			$stage.object[@ボタン_カレンダー + $i].joypad_down  = @ボタン_閉じる
			$stage.object[@ボタン_カレンダー + $i].joypad_right = @ボタン_閉じる
		}
	}
}
