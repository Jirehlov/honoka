//===========================================================================
//!
//!    @file     ___mng_hhp_flow_levelup.ss
//!    @brief    ヘビヘビパニックレベルアップ画面
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
	#define		@オブジェクト_フィルター	(<HHP_OBJ_MODAL> + 0)
	#define		@オブジェクト_背景			(<HHP_OBJ_MODAL> + 1)
	#define		@ボタン_閉じる				(<HHP_OBJ_MODAL> + 2)
	
	// 変数
	#property	$select_btn				// 選択したボタン
	
#inc_end


//===========================================================================
// レベルアップ画面フロー
//===========================================================================
#z00

// 初期化処理
$$create_scene_object(front)		// シーンオブジェクトを作成する
$$set_joypad_navigation(front)		// パッド入力の遷移を設定する
$$show_scene_object(front)			// シーンオブジェクトを表示する

// 入力制御を開始する
$$input_start(front, <HHP_BTNGROUP_MODAL>)

input.clear
while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <HHP_BTNGROUP_MODAL>)
	
	// キャンセルは何もしない
	if( $select_btn == -1 ) {
		
		// 入力制御を開始する
		$$input_start(front, <HHP_BTNGROUP_MODAL>)
	}
	
	// 閉じるボタンが押された場合は終了する
	if( $select_btn == @ボタン_閉じる ) {
		
		// 入力制御を開始する
		$$input_start(front, <HHP_BTNGROUP_MODAL>)
		
		break
	}
	
	// デバッグシステムを更新する
	$$update_hhp_debug_system
	
	input.next
	disp
}

// 終了処理
$$hide_scene_object(front)			// シーンオブジェクトを非表示にする

return


//---------------------------------------------------------------------------
// レベルアップシーンを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	// フィルター
	$stage.object[@オブジェクト_フィルター].create("__mng_hp_levelup_filter", 1)
	$stage.object[@オブジェクト_フィルター].layer = <HHP_LAYER_UI>
	
	// 背景
	$stage.object[@オブジェクト_背景].create("__mng_hp_levelup_bg", 1, 570, 199)
	$stage.object[@オブジェクト_背景].tr = 0
	$stage.object[@オブジェクト_背景].y_rep.resize(1)
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_UI>
	$stage.object[@オブジェクト_背景].child.resize(7)
	
	// タイトル
	$stage.object[@オブジェクト_背景].child[0].create("__mng_hp_levelup_title", 1, 240, 55)
	
	// レベル／背景
	$stage.object[@オブジェクト_背景].child[1].create("__mng_hp_levelup_level_bg", 1, 293, 155)
	$stage.object[@オブジェクト_背景].child[2].create("__mng_hp_levelup_level_bg", 1, 293, 155, 1)
	
	// レベル／元
	$stage.object[@オブジェクト_背景].child[3].create_number("__mng_hp_levelup_number", 1, 335, 145)
	$stage.object[@オブジェクト_背景].child[3].set_number_param(1, 0, 0, 0, 0, 0)
	$stage.object[@オブジェクト_背景].child[3].set_number($$get_hhp_play_level - 1)
	
	// レベル／新
	$stage.object[@オブジェクト_背景].child[4].create_number("__mng_hp_levelup_new_number", 1, 433, 124)
	$stage.object[@オブジェクト_背景].child[4].set_number_param(1, 0, 0, 0, 0, 0)
	$stage.object[@オブジェクト_背景].child[4].set_number($$get_hhp_play_level)
	
	// 画像
	$stage.object[@オブジェクト_背景].child[5].create("__mng_hp_levelup_image", 1, 67, 308)
	
	// テキスト
	$stage.object[@オブジェクト_背景].child[6].create("__mng_hp_levelup_text", 1, 68, 258)
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], "__mng_hp_levelup_close_btn", 770, 737, @ボタン_閉じる, <HHP_BTNGROUP_MODAL>, 7)
	$stage.object[@ボタン_閉じる].layer = <HHP_LAYER_UI>
	$stage.object[@ボタン_閉じる].tr = 0
	$stage.object[@ボタン_閉じる].set_scale(0, 0)
	
	// レベルによって表示内容を変更する
	switch( $$get_hhp_play_level ) {
		
	case(2)		// Lv2 > 青ヘビ登場
		
		$stage.object[@オブジェクト_背景].child[5].patno = 0
		$stage.object[@オブジェクト_背景].child[6].patno = 0
		
	case(3)		// Lv3 > ヤマタノオロチ登場
		
		$stage.object[@オブジェクト_背景].child[5].patno = 1
		$stage.object[@オブジェクト_背景].child[6].patno = 1
		
	case(4)		// Lv4 > サポート追加
		
		$stage.object[@オブジェクト_背景].child[5].patno = 2
		$stage.object[@オブジェクト_背景].child[6].patno = 2
		
	case(5)		// Lv5 > 赤ヘビ登場
		
		$stage.object[@オブジェクト_背景].child[5].patno = 3
		$stage.object[@オブジェクト_背景].child[6].patno = 0
		
	case(6)		// Lv6 > ヒュドラ登場
		
		$stage.object[@オブジェクト_背景].child[5].patno = 4
		$stage.object[@オブジェクト_背景].child[6].patno = 1
		
	case(7)		// Lv7 > サポート追加
		
		$stage.object[@オブジェクト_背景].child[5].patno = 2
		$stage.object[@オブジェクト_背景].child[6].patno = 3
		
	case(8)		// Lv8 > 紫ヘビ登場
		
		$stage.object[@オブジェクト_背景].child[5].patno = 5
		$stage.object[@オブジェクト_背景].child[6].patno = 0
		
	case(10)	// Lv10 > メデューサ登場
		
		$stage.object[@オブジェクト_背景].child[5].patno = 6
		$stage.object[@オブジェクト_背景].child[6].patno = 1
	}
	
	// 描画を更新する
	disp
}

//---------------------------------------------------------------------------
// レベルアップシーンを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	// 背景
	$stage.object[@オブジェクト_背景].y_rep[0] = 50
	$stage.object[@オブジェクト_背景].y_rep_eve[0].set(0, 500, 0, 2)
	$stage.object[@オブジェクト_背景].tr_eve.set(255, 500, 0, 2)
	
	// 閉じるボタン
	$stage.object[@ボタン_閉じる].tr_eve.set(255, 250, 1000, 2)
	$stage.object[@ボタン_閉じる].scale_x_eve.set(1000, 250, 1000, 2)
	$stage.object[@ボタン_閉じる].scale_y_eve.set(1000, 250, 1000, 2)
	
	$stage.object[@ボタン_閉じる].all_eve.wait
}

//---------------------------------------------------------------------------
// レベルアップシーンを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	$stage.object[@オブジェクト_フィルター].init
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_閉じる].init
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
