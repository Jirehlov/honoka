//===========================================================================
//!
//!    @file     ___mng_hhp_flow_rewards.ss
//!    @brief    ヘビヘビパニック報酬画面
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
	#define		@ボタン_報酬スキップ		(<HHP_OBJ_MODAL> + 1)
	#define		@ボタン_報酬リロール		(<HHP_OBJ_MODAL> + 2)
	#define		@ボタン_報酬選択			(<HHP_OBJ_MODAL> + 3)
	
	// 変数
	#property	$select_btn				// 選択したボタン
	#property	$focused_btn		// フォーカスされていたボタン
	
#inc_end


//===========================================================================
// 報酬画面フロー
//===========================================================================
#z00

// 初期化処理
@mng_counter.stop							// ミニゲームカウンターの一時停止
@bgm_stop									// ＢＧＭ停止
$$hhp_font_enable							// ヘビヘビパニックのフォントを有効にする
$focused_btn = $$get_joypad_focus_button	// フォーカスしていたボタンを保存する

// 報酬画面ループ位置
#loop

$$create_hhp_rewards_list			// 報酬リストを作成する

// 獲得可能な報酬がない場合は終了
if( $$get_hhp_rewards_list_count == 0 ) {
	goto #end
}

$$create_scene_object(front)		// シーンオブジェクトを作成する
$$set_joypad_navigation(front)		// パッド入力の遷移を設定する
$$show_scene_object(front)			// シーンオブジェクトを表示する

// deb 仮チュートリアル処理
if( $$get_hhp_global_play_count == 0 )
{
	if( $$get_hhp_tutorial_flag < 7 )
	{
		timewait_key(500)
		$$show_defegg_tutorial(7)
	}
}

@bgm(bgm44)				// ＢＧＭ再生

// 音声を再生する
$$play_hhp_voice(-1, <HHP_VOICE_TYPE_REWARDS_SELECT>)

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
	
	// 報酬スキップボタンが押された場合は何もしないで終了する
	if( $select_btn == @ボタン_報酬スキップ ) {
		break
	}
	
	// 報酬リロールボタンが押された場合は報酬を再作成する
	if( $select_btn == @ボタン_報酬リロール ) {
		
		$$add_hhp_rewards_reroll(-1)
		goto #loop
	}
	
	// 報酬選択ボタンが押された場合は選択した報酬を反映する
	if( @ボタン_報酬選択 <= $select_btn )
	{
		$$select_rewards_button($select_btn - @ボタン_報酬選択)
		$$powerup_hhp_item($$get_hhp_rewards_list($select_btn - @ボタン_報酬選択))
		$$update_hhp_item_list_force
		break
	}
	
	// デバッグシステムを更新する
	$$update_hhp_debug_system
	
	input.next
	disp
}

$$add_hhp_rewards_num(-1)
$$update_hhp_scene_object(front)

// 終了処理
$$hide_scene_object(front)			// シーンオブジェクトを非表示にする

#end

if( $$get_hhp_global_play_count == 0 )
{
	if( $$get_hhp_tutorial_flag < 8 )
	{
		timewait_key(500)
;		$$show_defegg_tutorial(8)		敵タイプ
		$$show_defegg_tutorial(9)
		$$show_defegg_tutorial(10)
	}
}

// 未開封の報酬がある場合はもう一度報酬選択へ
if( $$get_hhp_rewards_list_count != 0 && 0 < $$get_hhp_rewards_num )
{
	goto #loop
}

$$set_joypad_focus_button($focused_btn)		// フォーカスしていたボタンに戻す
$$destroy_scene_object(front)				// シーンオブジェクトを破棄する
@bgm_stop									// ＢＧＭ停止
@mng_counter.resume							// ミニゲームカウンターの一時停止を解除

return


//---------------------------------------------------------------------------
// 報酬シーンを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// フィルター
	$stage.object[@オブジェクト_背景].create("__mng_hp_rewards_filter", 1)
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_UI>
	$stage.object[@オブジェクト_背景].tr = 0
	$stage.object[@オブジェクト_背景].child.resize(3)
	
	// 背景
	$stage.object[@オブジェクト_背景].child[0].create("__mng_hp_rewards_bg", 1, 145, 84)
	
	// リロール／背景
	$stage.object[@オブジェクト_背景].child[1].create("__mng_hp_rewards_reroll_bg", 1, 1092, 933)
	
	// リロール／回数
	$stage.object[@オブジェクト_背景].child[2].create_number("__mng_hp_rewards_reroll_number", 1, 1267, 933)
	$stage.object[@オブジェクト_背景].child[2].set_number_param(1, 0, 0, 0, 0, 0)
	$stage.object[@オブジェクト_背景].child[2].set_number($$get_hhp_rewards_reroll)
	
	// 報酬ボタン
	$len = $$get_hhp_rewards_list_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$create_rewards_button($stage.object[@ボタン_報酬選択 + $i], $i, $len)
	}
	
	// スキップボタン
	$$create_ui_button($stage.object[@ボタン_報酬スキップ], "__mng_hp_rewards_skip_btn", 579, 802, @ボタン_報酬スキップ, <HHP_BTNGROUP_MODAL>, 6)
	$stage.object[@ボタン_報酬スキップ].layer = <HHP_LAYER_UI>
	$stage.object[@ボタン_報酬スキップ].tr = 0
	
	// リロールボタン
	$$create_ui_button($stage.object[@ボタン_報酬リロール], "__mng_hp_rewards_reroll_btn", 1035, 802, @ボタン_報酬リロール, <HHP_BTNGROUP_MODAL>, 5)
	$stage.object[@ボタン_報酬リロール].layer = <HHP_LAYER_UI>
	$stage.object[@ボタン_報酬リロール].tr = 0
	if( $$get_hhp_rewards_reroll < 1 ) {
		$stage.object[@ボタン_報酬リロール].set_button_state_disable
	}
	
	// 描画を更新する
	disp
}

// 報酬ボタンを作成する
command $$create_rewards_button(property $obj : object, property $index, property $max)
{
	property $item_id
	property $item_level
	property $item_icon_no
	
	// アイテムデータを取得する
	$item_id = $$get_hhp_rewards_list($index)
	$item_level = $$get_hhp_item_level($item_id) + $$get_hhp_item_default_level($item_id)
	$item_icon_no = $$get_hhp_item_icon_no($item_id, $item_level)
	
	// 背景ボタン
	$$create_ui_button($obj, "__mng_hp_rewards_item_btn" + math.tostr($item_level), 742 + 482 * $index - 241 * ($max - 1), 262, @ボタン_報酬選択 + $index, <HHP_BTNGROUP_MODAL>, 7)
	$obj.layer = <HHP_LAYER_UI>
	$obj.tr = 0
	$obj.child.resize(3)
	
	// アイコン
	$obj.child[0].create("__mng_hp_rewards_item_icon", 1, 110, 39, $item_icon_no)
	
	// アイテム名
	$obj.child[1].create("__mng_hp_rewards_item_name", 1, 29, 266, $item_icon_no)
	
	// アイテム説明
	$obj.child[2].create_string($$get_hhp_item_description($item_id, $item_level), 1, 36, 336)
	$obj.child[2].set_string_param(20, -1, 4, 19, 0, -1, -1, -1)
}

//---------------------------------------------------------------------------
// 報酬シーンを破棄する
//---------------------------------------------------------------------------
command $$destroy_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// すべてのイベントが終了するまで待つ
	$stage.object[@オブジェクト_背景].all_eve.wait
	
	// オブジェクトの初期化
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_報酬スキップ].init
	$stage.object[@ボタン_報酬リロール].init
	
	$len = $$get_hhp_rewards_list_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_報酬選択 + $i].init
	}
}

//---------------------------------------------------------------------------
// 報酬シーンを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	$stage.object[@オブジェクト_背景].tr_eve.set(255, 350, 0, 2)
	
	for( $i = 0, $i < 3, $i += 1 )
	{
		$stage.object[@オブジェクト_背景].child[$i].tr = 0
		$stage.object[@オブジェクト_背景].child[$i].y_rep.resize(1)
		$stage.object[@オブジェクト_背景].child[$i].y_rep[0] = 50
		$stage.object[@オブジェクト_背景].child[$i].y_rep_eve[0].set(0, 350, 0, 2)
	}
	
	// 時間待ち
	timewait_key(500)
	
	$stage.object[@オブジェクト_背景].child[0].tr_eve.set(255, 150, 0, 2)
	$stage.object[@オブジェクト_背景].child[1].tr_eve.set(255, 150, 0, 2)
	$stage.object[@オブジェクト_背景].child[2].tr_eve.set(255, 150, 0, 2)
	
	$len = $$get_hhp_rewards_list_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_報酬選択 + $i].tr_eve.set(255, 150, 0, 2)
		$stage.object[@ボタン_報酬選択 + $i].set_scale(500, 500)
		$stage.object[@ボタン_報酬選択 + $i].scale_x_eve.set(1000, 150, 0, 2)
		$stage.object[@ボタン_報酬選択 + $i].scale_y_eve.set(1000, 150, 0, 2)
	}
	$stage.object[@ボタン_報酬スキップ].tr_eve.set(255, 150, 0, 2)
	$stage.object[@ボタン_報酬スキップ].set_scale(500, 500)
	$stage.object[@ボタン_報酬スキップ].scale_x_eve.set(1000, 150, 0, 2)
	$stage.object[@ボタン_報酬スキップ].scale_y_eve.set(1000, 150, 0, 2)
	$stage.object[@ボタン_報酬リロール].tr_eve.set(255, 150, 0, 2)
	$stage.object[@ボタン_報酬リロール].set_scale(500, 500)
	$stage.object[@ボタン_報酬リロール].scale_x_eve.set(1000, 150, 0, 2)
	$stage.object[@ボタン_報酬リロール].scale_y_eve.set(1000, 150, 0, 2)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$set_hhp_button($stage.object[@ボタン_報酬選択 + $i])
		
		// 報酬ボタンのマウスオーバーはデフォルト指定だと大きすぎるので少し小さくする
		$$set_hhp_button_scale($stage.object[@ボタン_報酬選択 + $i], 1000, 1100, 950)
	}
}

//---------------------------------------------------------------------------
// 報酬シーンを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// 消去アニメーション
	$stage.object[@オブジェクト_背景].tr_eve.set(0, 150, 0, 2)
	
	$len = $$get_hhp_rewards_list_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_報酬選択 + $i].tr_eve.set(0, 150, 0, 2)
		$stage.object[@ボタン_報酬選択 + $i].scale_x_eve.set(500, 150, 0, 2)
		$stage.object[@ボタン_報酬選択 + $i].scale_y_eve.set(500, 150, 0, 2)
	}
	
	$stage.object[@ボタン_報酬スキップ].tr_eve.set(0, 150, 0, 2)
	$stage.object[@ボタン_報酬スキップ].scale_x_eve.set(500, 150, 0, 2)
	$stage.object[@ボタン_報酬スキップ].scale_y_eve.set(500, 150, 0, 2)
	
	$stage.object[@ボタン_報酬リロール].tr_eve.set(0, 150, 0, 2)
	$stage.object[@ボタン_報酬リロール].scale_x_eve.set(500, 150, 0, 2)
	$stage.object[@ボタン_報酬リロール].scale_y_eve.set(500, 150, 0, 2)
	
	// 時間待ち
	timewait_key(500)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	property $i
	property $rewards_num
	property $default_button_no
	
	$rewards_num = $$get_hhp_rewards_list_count
	
	// デフォルトボタンを決定する
	switch( $rewards_num ) {
	case(1)		$default_button_no = 0
	case(2)		$default_button_no = 0
	case(3)		$default_button_no = 1
	}
	
	for( $i = 0, $i < $rewards_num, $i += 1 )
	{
		$stage.object[@ボタン_報酬選択 + $i].joypad_up    = @ボタン_報酬リロール
		$stage.object[@ボタン_報酬選択 + $i].joypad_down  = @ボタン_報酬リロール
		$stage.object[@ボタン_報酬選択 + $i].joypad_left  = @ボタン_報酬選択 + $i - 1
		$stage.object[@ボタン_報酬選択 + $i].joypad_right = @ボタン_報酬選択 + $i + 1
		
		if( $i == 0 ) {
			$stage.object[@ボタン_報酬選択 + $i].joypad_left  = @ボタン_報酬選択 + $rewards_num - 1
		}
		if( $i == $rewards_num - 1 ) {
			$stage.object[@ボタン_報酬選択 + $i].joypad_right = @ボタン_報酬選択
		}
	}
	
	$stage.object[@ボタン_報酬スキップ].joypad_up    = @ボタン_報酬選択 + $default_button_no
	$stage.object[@ボタン_報酬スキップ].joypad_down  = @ボタン_報酬選択 + $default_button_no
	$stage.object[@ボタン_報酬スキップ].joypad_left  = @ボタン_報酬リロール
	$stage.object[@ボタン_報酬スキップ].joypad_right = @ボタン_報酬リロール
	
	$stage.object[@ボタン_報酬リロール].joypad_up    = @ボタン_報酬選択 + $default_button_no
	$stage.object[@ボタン_報酬リロール].joypad_down  = @ボタン_報酬選択 + $default_button_no
	$stage.object[@ボタン_報酬リロール].joypad_left  = @ボタン_報酬スキップ
	$stage.object[@ボタン_報酬リロール].joypad_right = @ボタン_報酬スキップ
	
	$$set_joypad_focus_button(@ボタン_報酬選択 + $default_button_no)
}

// deb
command $$select_rewards_button(property $index)
{
	// 選択したボタンをアニメーション
	front.object[@ボタン_報酬選択 + $index].bright_eve.turn(0, 128, 150, 0, 2)
	front.object[@ボタン_報酬選択 + $index].scale_x_eve.set(1050, 150, 0, 2)
	front.object[@ボタン_報酬選択 + $index].scale_y_eve.set(1050, 150, 0, 2)
	
	// 時間待ち
	timewait_key(750)
}
