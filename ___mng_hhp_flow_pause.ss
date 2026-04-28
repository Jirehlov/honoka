//===========================================================================
//!
//!    @file     ___mng_hhp_flow_pause.ss
//!    @brief    ヘビヘビパニック一時停止画面
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
	
	// オブジェクト番号／ボタン番号
	#define		@オブジェクト_背景			0
	#define		@ボタン_再開する			1
	#define		@ボタン_ウィンドウを消す	2
	#define		@ボタン_アイテム			3
	
	// 変数
	#property	$select_btn			// 選択したボタン
	#property	$focused_btn		// フォーカスされていたボタン
	
#inc_end


//===========================================================================
// 一時停止画面フロー
//===========================================================================
#z00

// 初期化処理
$$excall_ready								// システムコールを準備する
$$hhp_font_enable							// ヘビヘビパニックのフォントを有効にする
$focused_btn = $$get_joypad_focus_button	// フォーカスしていたボタンを保存する
$$create_scene_object(excall.front)			// シーンオブジェクトを作成する
$$set_joypad_navigation(excall.front)		// パッド入力の遷移を設定する
$$show_scene_object(excall.front)			// シーンオブジェクトを表示する

// 入力制御を開始する
$$input_start(excall.front, <HHP_BTNGROUP_MODAL>)

input.clear
while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(excall.front, <HHP_BTNGROUP_MODAL>)
	
	// キャンセルは再開するボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<HHP_BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_再開する
	}
	
	// 再開するボタンが押された場合
	if( $select_btn == @ボタン_再開する )
	{
		// 一時停止画面が表示されている場合は終了する
		if( excall.front.object[@オブジェクト_背景].disp )
		{
			break
		}
		
		// 一時停止画面が表示されていない場合は一時停止画面を表示する
		else
		{
			$select_btn = @ボタン_ウィンドウを消す
		}
	}
	
	// アイテムボタンが押された場合はアイテム詳細へ
	if( $select_btn >= @ボタン_アイテム )
	{
		farcall("___mng_hhp_flow_item_info", 0, $select_btn - @ボタン_アイテム)
		
		// 入力制御を再開始する
		$$input_start(excall.front, <HHP_BTNGROUP_MODAL>)
	}
	
	// ウィンドウを消すボタンが押された場合は一時停止ウィンドウを消す
	if( $select_btn == @ボタン_ウィンドウを消す )
	{
		excall.front.object[@オブジェクト_背景].disp = $$reverse_flag(excall.front.object[@オブジェクト_背景].disp)
		excall.front.object[@ボタン_再開する].disp = excall.front.object[@オブジェクト_背景].disp
		excall.front.object[@ボタン_ウィンドウを消す].disp = excall.front.object[@オブジェクト_背景].disp
		for( l[0] = 0, l[0] < $$get_hhp_item_count, l[0] += 1 ) {
			excall.front.object[@ボタン_アイテム + l[0]].disp = excall.front.object[@オブジェクト_背景].disp
		}
		
		// 入力制御を再開始する
		$$input_start(excall.front, <HHP_BTNGROUP_MODAL>)
	}
	
	// デバッグシステムを更新する
	$$update_hhp_debug_system
	
	input.next
	disp
}

// 終了処理
$$hide_scene_object(excall.front)			// シーンオブジェクトを非表示にする
$$set_joypad_focus_button($focused_btn)		// フォーカスしていたボタンに戻す
$$destroy_scene_object(excall.front)		// シーンオブジェクトを破棄する
$$hhp_font_enable							// ヘビヘビパニックのフォントを無効にする
$$excall_free								// システムコールを解放する

return


//---------------------------------------------------------------------------
// 一時停止シーンを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $len
	property $item_id
	property $item_level
	
	// フィルター
	$stage.object[@オブジェクト_背景].create_rect(0, 0, <SCREEN_WIDTH>, <SCREEN_HEIGHT>, 0, 0, 0, 128, 1)
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_MODAL>
	$stage.object[@オブジェクト_背景].child.resize(1)
	
	// 背景
	$stage.object[@オブジェクト_背景].child[0].create("__mng_hp_pause_bg", 1, 232, 153)
	
	// 再開するボタン
	$$create_ui_button($stage.object[@ボタン_再開する], "__mng_hp_pause_back_btn", 477, 774, @ボタン_再開する, <HHP_BTNGROUP_MODAL>, 1)
	$stage.object[@ボタン_再開する].layer = <HHP_LAYER_MODAL>
	
	// ウィンドウを消すボタン
	$$create_ui_button($stage.object[@ボタン_ウィンドウを消す], "__mng_hp_pause_window_btn", 1012, 774, @ボタン_ウィンドウを消す, <HHP_BTNGROUP_MODAL>, 1)
	$stage.object[@ボタン_ウィンドウを消す].layer = <HHP_LAYER_MODAL>
	
	// アイテム
	$len = $$get_hhp_item_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$item_id = $$get_hhp_item_id_from_list_index($i)
		$item_level = $$get_hhp_item_level_from_list_index($i)
		
		$$create_ui_button($stage.object[@ボタン_アイテム + $i], "__mng_hp_pause_item_btn" + math.tostr_zero($$get_hhp_item_icon_no($item_id, $item_level) + 1, 2), 369 + 119 * ($i % 10), 379 + 125 * ($i / 10), @ボタン_アイテム + $i, <HHP_BTNGROUP_MODAL>, 1)
		$stage.object[@ボタン_アイテム + $i].layer = <HHP_LAYER_MODAL>
	}
}

//---------------------------------------------------------------------------
// 一時停止シーンを破棄する
//---------------------------------------------------------------------------
command $$destroy_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// すべてのイベントが終了するまで待つ
	$stage.object[@オブジェクト_背景].all_eve.wait
	
	// オブジェクトの初期化
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_再開する].init
	$stage.object[@ボタン_ウィンドウを消す].init
	
	$len = $$get_hhp_item_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_アイテム + $i].init
	}
}

//---------------------------------------------------------------------------
// 一時停止シーンを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	/*
	$$set_hhp_button($stage.object[@ボタン_再開する])
	$$set_hhp_button($stage.object[@ボタン_ウィンドウを消す])
	*/
	
	$len = $$get_hhp_item_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$set_hhp_button($stage.object[@ボタン_アイテム + $i])
	}
}

//---------------------------------------------------------------------------
// 一時停止シーンを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	$stage.object[@オブジェクト_背景].disp = 0
	$stage.object[@ボタン_再開する].disp = 0
	$stage.object[@ボタン_ウィンドウを消す].disp = 0
	
	$len = $$get_hhp_item_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_アイテム + $i].disp = 0
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	property $i
	property $len
	property $w
	property $max_line
	
	$len = $$get_hhp_item_count
	$w = 10
	$max_line = $len / $w
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_アイテム + $i].joypad_up    = @ボタン_アイテム + $i - $w
		$stage.object[@ボタン_アイテム + $i].joypad_down  = @ボタン_アイテム + $i + $w
		$stage.object[@ボタン_アイテム + $i].joypad_left  = @ボタン_アイテム + $i - 1
		$stage.object[@ボタン_アイテム + $i].joypad_right = @ボタン_アイテム + $i + 1
		
		if( $i < $w )
		{
			$stage.object[@ボタン_アイテム + $i].joypad_up = @ボタン_再開する
		}
		
		if( $i > $len - $w - 1 )
		{
			$stage.object[@ボタン_アイテム + $i].joypad_down = @ボタン_再開する
		}
		
		if( $i % $w == 0 )
		{
			$stage.object[@ボタン_アイテム + $i].joypad_left = @ボタン_アイテム + $i + $w - 1
			
			if( $i / $w == $max_line )
			{
				$stage.object[@ボタン_アイテム + $i].joypad_left = @ボタン_アイテム + $len - 1
			}
		}
		
		if( $i % $w == $w - 1 )
		{
			$stage.object[@ボタン_アイテム + $i].joypad_right = @ボタン_アイテム + $i / $w * $w
		}
		
		if( $i == $len - 1 && $i % $w != 5 )
		{
			if( $i % $w == 0 ) {
				$stage.object[@ボタン_アイテム + $i].joypad_left  = -1
				$stage.object[@ボタン_アイテム + $i].joypad_right = -1
			}
			
			elseif( $i % $w != 5 ) {
				$stage.object[@ボタン_アイテム + $i].joypad_right = @ボタン_アイテム + $max_line * $w
			}
		}
	}
	
	$stage.object[@ボタン_再開する].joypad_left  = @ボタン_ウィンドウを消す
	$stage.object[@ボタン_再開する].joypad_right = @ボタン_ウィンドウを消す
	
	$stage.object[@ボタン_ウィンドウを消す].joypad_left  = @ボタン_再開する
	$stage.object[@ボタン_ウィンドウを消す].joypad_right = @ボタン_再開する
	
	if( $len == 0 )
	{
		$stage.object[@ボタン_再開する].joypad_up    = -1
		$stage.object[@ボタン_再開する].joypad_down  = -1
		
		$stage.object[@ボタン_ウィンドウを消す].joypad_up    = -1
		$stage.object[@ボタン_ウィンドウを消す].joypad_down  = -1
	}
	else
	{
		$stage.object[@ボタン_再開する].joypad_up    = @ボタン_アイテム + $len - 1
		$stage.object[@ボタン_再開する].joypad_down  = @ボタン_アイテム + 0
		
		$stage.object[@ボタン_ウィンドウを消す].joypad_up    = @ボタン_アイテム + $len - 1
		$stage.object[@ボタン_ウィンドウを消す].joypad_down  = @ボタン_アイテム + 0
	}
	
	$$set_joypad_focus_button(@ボタン_再開する)
}
