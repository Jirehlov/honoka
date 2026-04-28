//===========================================================================
//!
//!    @file     ___mng_hhp_flow_item_info.ss
//!    @brief    ヘビヘビパニックアイテム詳細画面
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
	#define		@オブジェクト_背景			(<HHP_OBJ_MODAL> + 0)
	#define		@ボタン_閉じる				(<HHP_OBJ_MODAL> + 1)
	
	// 変数
	#property	$select_btn			// 選択したボタン
	#property	$focused_btn		// フォーカスされていたボタン
	#property	$item_index			// 選択されているアイテムインデックス
	#property	$is_excall			// システムコール中かどうか
	
#inc_end


//===========================================================================
// アイテム詳細画面フロー
//===========================================================================
#z00

// システムコール中か判定する
$is_excall = excall.check_alloc

// 初期化処理
$$hhp_font_enable									// ヘビヘビパニックのフォントを有効にする
$focused_btn = $$get_joypad_focus_button			// フォーカスしていたボタンを保存する
$item_index  = l[0]									// 選択されているアイテムインデックスを取得する
$$create_scene_object(excall[$is_excall].front)		// シーンオブジェクトを作成する
$$show_scene_object(excall[$is_excall].front)		// シーンオブジェクトを表示する
$$set_joypad_navigation(excall[$is_excall].front)	// パッド入力の遷移を設定する

// 入力制御を開始する
$$input_start(excall[$is_excall].front, <HHP_BTNGROUP_ITEM_INFO>)

input.clear
while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(excall[$is_excall].front, <HHP_BTNGROUP_ITEM_INFO>)
	
	// キャンセルは閉じるボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<HHP_BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_閉じる
	}
	
	// 閉じるボタンの場合は終了する
	if( $select_btn == @ボタン_閉じる ) {
		break
	}
	
	// デバッグシステムを更新する
	$$update_hhp_debug_system
	
	input.next
	disp
}

// 終了処理
$$hide_scene_object(excall[$is_excall].front)		// シーンオブジェクトを非表示にする
$$set_joypad_focus_button($focused_btn)				// フォーカスしていたボタンに戻す
$$destroy_scene_object(excall[$is_excall].front)	// シーンオブジェクトを破棄する

return


//---------------------------------------------------------------------------
// アイテム詳細シーンを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $item_id
	property $item_level
	property $item_icon_no
	
	// アイテムデータを取得する
	$item_id = $$get_hhp_item_id_from_list_index($item_index)
	$item_level = $$get_hhp_item_level_from_list_index($item_index)
	$item_icon_no = $$get_hhp_item_icon_no($item_id, $item_level)
	
	// フィルター
	$stage.object[@オブジェクト_背景].create_rect(0, 0, <SCREEN_WIDTH>, <SCREEN_HEIGHT>, 0, 0, 0, 128, 1)
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_MODAL> + 1
	$stage.object[@オブジェクト_背景].child.resize(4)
	
	// 背景
	$stage.object[@オブジェクト_背景].child[0].create("__mng_hp_rewards_item_btn" + math.tostr($item_level), 1, 742, 262)
	
	// アイコン
	$stage.object[@オブジェクト_背景].child[1].create("__mng_hp_rewards_item_icon", 1, 852, 301, $item_icon_no)
	
	// アイテム名
	$stage.object[@オブジェクト_背景].child[2].create("__mng_hp_rewards_item_name", 1, 771, 528, $item_icon_no)
	
	// アイテム説明
	$stage.object[@オブジェクト_背景].child[3].create_string($$get_hhp_item_description($item_id, $item_level), 1, 778, 598)
	$stage.object[@オブジェクト_背景].child[3].set_string_param(20, -1, 4, 19, 0, -1, -1, -1)
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], "__mng_hp_release_close_btn", 787, 816, @ボタン_閉じる, <HHP_BTNGROUP_ITEM_INFO>, 2)
	$stage.object[@ボタン_閉じる].layer = <HHP_LAYER_MODAL> + 1
}

//---------------------------------------------------------------------------
// アイテム詳細シーンを破棄する
//---------------------------------------------------------------------------
command $$destroy_scene_object(property $stage : stage)
{
	// すべてのイベントが終了するまで待つ
	$stage.object[@オブジェクト_背景].all_eve.wait
	
	// オブジェクトの初期化
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_閉じる].init
}

//---------------------------------------------------------------------------
// アイテム詳細シーンを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	$$set_hhp_button(front.object[@ボタン_閉じる])
}

//---------------------------------------------------------------------------
// アイテム詳細シーンを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	$stage.object[@オブジェクト_背景].disp = 0
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
	
	// 閉じるボタンをデフォルトにする
	$$set_joypad_focus_button(@ボタン_閉じる)
}
