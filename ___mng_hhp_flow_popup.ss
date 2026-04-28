//===========================================================================
//!
//!    @file     ___mng_hhp_flow_popup.ss
//!    @brief    ヘビヘビパニックポップアップ画面
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
// ポップアップ画面フロー
//===========================================================================
#z00

// 初期化処理
$$create_scene_object(front, l[0])	// シーンオブジェクトを作成する
$$set_joypad_navigation(front)		// パッド入力の遷移を設定する
$$show_scene_object(front, l[0])	// シーンオブジェクトを表示する

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
// ポップアップシーンを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage, property $type)
{
	property $pos_x
	property $pos_y
	property $btn_pos_x
	property $btn_pos_y
	property $filter_filename : str
	property $bg_filename : str
	property $btn_filename : str
	
	// タイプによって表示するオブジェクトを変更する
	switch( $type ) {
		
	// 全ウェーブ勝利
	case(<HHP_RESULT_POPUP_TYPE_ALL_WIN>)
		
		$pos_x = 363
		$pos_y = 288
		$btn_pos_x = 721
		$btn_pos_y = 671
		$filter_filename = "__mng_hp_popup_filter"
		$bg_filename = "__mng_hp_result_popup_bg1"
		$btn_filename = "__mng_hp_result_popup_btn1"
		
	// ウェーブ勝利
	case(<HHP_RESULT_POPUP_TYPE_WAVE_WIN>)
		
		$pos_x = 363
		$pos_y = 288
		$btn_pos_x = 721
		$btn_pos_y = 671
		$filter_filename = "__mng_hp_popup_filter"
		$bg_filename = "__mng_hp_result_popup_bg2"
		$btn_filename = "__mng_hp_result_popup_btn2"
		
	// 敗北
	case(<HHP_RESULT_POPUP_TYPE_WAVE_LOSE>)
		
		$pos_x = 363
		$pos_y = 288
		$btn_pos_x = 721
		$btn_pos_y = 671
		$filter_filename = "__mng_hp_popup_filter2"
		$bg_filename = "__mng_hp_result_popup_bg3"
		$btn_filename = "__mng_hp_result_popup_btn3"
		
	// サポート解禁
	case(<HHP_RESULT_POPUP_TYPE_RELEASE_SUPPORT>)
		
		$pos_x = 288
		$pos_y = 286
		$btn_pos_x = 770
		$btn_pos_y = 663
		$filter_filename = "__mng_hp_popup_filter"
		$bg_filename = "__mng_hp_release_support_bg"
		$btn_filename = "__mng_hp_release_close_btn"
	}
	
	// フィルター
	$stage.object[@オブジェクト_フィルター].create($filter_filename, 1)
	$stage.object[@オブジェクト_フィルター].layer = <HHP_LAYER_UI>
	$stage.object[@オブジェクト_フィルター].tr = 0
	
	// ポップアップ
	$stage.object[@オブジェクト_背景].create($bg_filename, 1, $pos_x, $pos_y)
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_UI>
	$stage.object[@オブジェクト_背景].tr = 0
	$stage.object[@オブジェクト_背景].y_rep.resize(1)
	$stage.object[@オブジェクト_背景].set_scale(0, 0)
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], $btn_filename, $btn_pos_x, $btn_pos_y, @ボタン_閉じる, <HHP_BTNGROUP_MODAL>, 7)
	$stage.object[@ボタン_閉じる].layer = <HHP_LAYER_UI>
	$stage.object[@ボタン_閉じる].tr = 0
	$stage.object[@ボタン_閉じる].set_scale(0, 0)
	
	// 描画を更新する
	disp
}

//---------------------------------------------------------------------------
// ポップアップシーンを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage, property $type)
{
	// タイプによって表示アニメーションを変更する
	switch( $type ) {
		
	// 全ウェーブ勝利
	case(<HHP_RESULT_POPUP_TYPE_ALL_WIN>)
		
		$stage.object[@オブジェクト_フィルター].tr_eve.set(255, 250, 0, 2)
		
		$stage.object[@オブジェクト_背景].tr_eve.set(255, 250, 250, 2)
		$stage.object[@オブジェクト_背景].y_rep[0] = 50
		$stage.object[@オブジェクト_背景].y_rep_eve[0].set(0, 250, 250, 2)
		$stage.object[@オブジェクト_背景].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@オブジェクト_背景].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@オブジェクト_背景].all_eve.wait
		
		$stage.object[@ボタン_閉じる].tr_eve.set(255, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@ボタン_閉じる].all_eve.wait
		
	// ウェーブ勝利
	case(<HHP_RESULT_POPUP_TYPE_WAVE_WIN>)
		
		$stage.object[@オブジェクト_フィルター].tr_eve.set(255, 250, 0, 2)
		
		$stage.object[@オブジェクト_背景].tr_eve.set(255, 250, 250, 2)
		$stage.object[@オブジェクト_背景].y_rep[0] = 50
		$stage.object[@オブジェクト_背景].y_rep_eve[0].set(0, 250, 250, 2)
		$stage.object[@オブジェクト_背景].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@オブジェクト_背景].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@オブジェクト_背景].all_eve.wait
		
		$stage.object[@ボタン_閉じる].tr_eve.set(255, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@ボタン_閉じる].all_eve.wait
		
	// 敗北
	case(<HHP_RESULT_POPUP_TYPE_WAVE_LOSE>)
		
		$stage.object[@オブジェクト_フィルター].tr_eve.set(255, 250, 0, 2)
		
		$stage.object[@オブジェクト_背景].tr_eve.set(255, 250, 250, 2)
		$stage.object[@オブジェクト_背景].y_rep[0] = 50
		$stage.object[@オブジェクト_背景].y_rep_eve[0].set(0, 250, 250, 2)
		$stage.object[@オブジェクト_背景].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@オブジェクト_背景].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@オブジェクト_背景].all_eve.wait
		
		$stage.object[@ボタン_閉じる].tr_eve.set(255, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@ボタン_閉じる].all_eve.wait
		
	// サポート解禁
	case(<HHP_RESULT_POPUP_TYPE_RELEASE_SUPPORT>)
		
		@ＳＥ_ヘビパ_機能解放
		
		$stage.object[@オブジェクト_背景].tr_eve.set(255, 250, 250, 2)
		$stage.object[@オブジェクト_背景].y_rep[0] = 50
		$stage.object[@オブジェクト_背景].y_rep_eve[0].set(0, 250, 250, 2)
		$stage.object[@オブジェクト_背景].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@オブジェクト_背景].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@オブジェクト_背景].all_eve.wait
		
		$stage.object[@ボタン_閉じる].tr_eve.set(255, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_x_eve.set(1000, 250, 0, 2)
		$stage.object[@ボタン_閉じる].scale_y_eve.set(1000, 250, 0, 2)
		
		$stage.object[@ボタン_閉じる].all_eve.wait
		
	}
}

//---------------------------------------------------------------------------
// ポップアップシーンを非表示にする
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
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_閉じる)
	
	$stage.object[@ボタン_閉じる].joypad_up    = -1
	$stage.object[@ボタン_閉じる].joypad_down  = -1
	$stage.object[@ボタン_閉じる].joypad_left  = -1
	$stage.object[@ボタン_閉じる].joypad_right = -1
}
