//===========================================================================
//!
//!    @file     ___mng_urace_flow_race.ss
//!    @brief    ＵＭＡレース／レース画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レース中の画面
//!
//===========================================================================
//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト番号
	#replace	<URACE_OBJ_BG>						 0		// 背景
	#replace	<URACE_OBJ_BG_FILTER>				 1		// 背景フィルター
	#replace	<URACE_OBJ_BG_EFFECT>				 2		// 背景エフェクト
	#replace	<URACE_OBJ_TRAP>					10		// 障害物
	#replace	<URACE_OBJ_ITEM>					16		// アイテム
	#replace	<URACE_OBJ_UMA_TIP>					22		// ＵＭＡチップ
	#replace	<URACE_OBJ_SCREEN_EFFECT>			28		// スクリーンエフェクト
	#replace	<URACE_OBJ_MINI_MAP>				29		// ミニマップ
	#replace	<URACE_OBJ_OFF_SCREEN_TIP>			30		// オフスクリーンチップ(ＵＭＡが画面内に収まらない場合の表示)
	#replace	<URACE_OBJ_PLAYER_ORDER>			31		// プレイヤーの順位
	#replace	<URACE_OBJ_CHEER_WINDOW>			32		// 応援ウィンドウ
	#replace	<URACE_OBJ_PAUSE_BTN>				33		// 一時停止ボタン
	#replace	<URACE_OBJ_SKIP_BTN>				34		// スキップボタン
	#replace	<URACE_OBJ_CHANGE_BTN>				35		// 交代ボタン
	#replace	<URACE_OBJ_SKILL_BTN>				36		// スキルボタン
	#replace	<URACE_OBJ_ITEM_BTN>				37		// アイテムボタン
	#replace	<URACE_OBJ_HELP>					40		// ヘルプ
	#replace	<URACE_OBJ_MODAL_WINDOW>			41		// モーダルウィンドウ
	#replace	<URACE_BTN_MODAL_WINDOW_OK>			42		// モーダルウィンドウ／決定ボタン
	#replace	<URACE_BTN_MODAL_WINDOW_CANCEL>		43		// モーダルウィンドウ／キャンセルボタン
	#replace	<URACE_OBJ_BULLET>					44		// 
	#replace	<URACE_OBJ_DEBUG>					99		// デバッグ
	
	// レイヤー値
	#replace	<URACE_LAYER_BG>			   0		// 背景
	#replace	<URACE_LAYER_BG_FILTER>		   1		// 背景フィルター
	#replace	<URACE_LAYER_TRAP>			  10		// 障害物
	#replace	<URACE_LAYER_UMA_TIP>		  11		// ＵＭＡチップ
	#replace	<URACE_LAYER_ALL_FILTER>	 100		// 全体フィルター
	#replace	<URACE_LAYER_UI>			 500		// ＵＩ
	#replace	<URACE_LAYER_ALL_EFFECT>	 500		// 最前面エフェクト
	#replace	<URACE_LAYER_MODAL>			1000		// モーダル
	#replace	<URACE_LAYER_DEBUG>			2000		// デバッグ表示
	
	// ＵＭＡチップオブジェクト定義
	#define		.cd_shadow					.child[0]
	#define		.cd_chara					.child[1]
	#define		.cd_chara_util_ef_back		.child[1].child[0]
	#define		.cd_chara_skill_ef_back		.child[1].child[1]
	#define		.cd_chara_tip				.child[1].child[2]
	#define		.cd_chara_util_ef_front		.child[1].child[3]
	#define		.cd_chara_skill_ef_front	.child[1].child[4]
	#define		.cd_chara_player_cursor		.child[1].child[5]
	#define		.cd_wave					.child[2]
	#define		.cd_dig						.child[3]
	#define		.cd_run_scatter				.child[4]
	#define		.cd_skill					.child[5]
	#define		.cd_life_bar				.child[6]
	
	// 描画縮尺
	#replace	<DISP_SHIFT>			100		// 1920pixelをレース距離何mとして扱うか(100なら100m=1920pixel)
	
	// カメラ
	#property	$camera_x				// カメラ座標(x)
	
	// レース管理データ
	#property	$entry_uma_num			// レースに参加している人数
	#property	$player_index			// プレイヤーのインデックス(プレイヤーの枠番が1の場合は0,枠番が2の場合は1…)
	#property	$rival_index			// ライバルのインデックス
	#property	$last_spurt				// ラストスパートが発生しているかどうか
	
	// ＵＩ管理変数
	#property	$select_btn							// 選択したボタン
	#property	$start_x : intlist					// 各レーンのスタート座標(x)
	#property	$goal_x : intlist					// 各レーンのゴールx座標(x)
	#property	$uma_action_state : intlist			// 各ＵＭＡの行動状態
	#property	$uma_active_skill_id : intlist		// 各ＵＭＡの発動中のスキル
	#property	$uma_block_action : intlist
	
	// ＵＩ／アクションバー変数
	#define		.f_state				.f[0]
	#define		.f_wait_time			.f[1]
	#define		.f_trap_index			.f[2]
	
#inc_end

//===========================================================================
// レースフロー
//===========================================================================
#z00

// レース管理データを初期化する
$$init_data

#z01

// オブジェクトを作成する
$$create_scene_object(back)			// シーンオブジェクトを作成する
$$update_scene_object(back)			// シーンオブジェクトを更新する
disp								// 画面を更新する
$$show_scene_object(back)			// シーンオブジェクトを表示する

// レース開始演出
$$start_effect(front.object[<OBJ_START_EFFECT>])
;		$$set_running_uma_action_state(0, <RUNNING_UMA_ACTION_STATE_START>)
;		$$set_running_uma_action_state(1, <RUNNING_UMA_ACTION_STATE_START>)
;		$$set_running_uma_action_state(2, <RUNNING_UMA_ACTION_STATE_START>)
;		$$set_running_uma_action_state(3, <RUNNING_UMA_ACTION_STATE_START>)

// ミニゲームで使用するカウンターを初期化する
$$init_mng_counter

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_NORMAL>)

// レース開始
while(1)
{
	// ミニゲームで使用するカウンターを更新する
	$$update_mng_counter
	
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_NORMAL>)
	
	// 一時停止ボタン／右クリックで一時停止
	if( $select_btn == <URACE_OBJ_PAUSE_BTN> || input.cancel.on_down )
	{
		// 入力制御を終了する
		front.objbtngroup[<URACE_BTN_GROUP_NORMAL>].end
		
		// 一時停止メニューへ
		$$pause(front)
		
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_NORMAL>)
	}
	
	if( $$get_running_uma_action_state($player_index) == <RUNNING_UMA_ACTION_STATE_RUN> )
	{
		if( key['W'].on_down || key[38].on_down || mouse.wheel < 0 )
		{
			//@SE_ＵＭＡレース_レーン移動
			$$move_lane($player_index, -1)
		}
		
		if( key['S'].on_down || key[40].on_down || mouse.wheel > 0 )
		{
			//@SE_ＵＭＡレース_レーン移動
			$$move_lane($player_index, 1)
		}
	}
	
	if( key['Y'].on_down )
	{
		if( $player_index != 0 ) {
			$$set_running_uma_stop_flag(0, $$reverse_flag($$get_running_uma_stop_flag(0)))
		}
		if( $player_index != 1 ) {
			$$set_running_uma_stop_flag(1, $$reverse_flag($$get_running_uma_stop_flag(1)))
		}
		if( $player_index != 2 ) {
			$$set_running_uma_stop_flag(2, $$reverse_flag($$get_running_uma_stop_flag(2)))
		}
		if( $player_index != 3 ) {
			$$set_running_uma_stop_flag(3, $$reverse_flag($$get_running_uma_stop_flag(3)))
		}
		if( $player_index != 4 ) {
			$$set_running_uma_stop_flag(4, $$reverse_flag($$get_running_uma_stop_flag(4)))
		}
		if( $player_index != 5 ) {
			$$set_running_uma_stop_flag(5, $$reverse_flag($$get_running_uma_stop_flag(5)))
		}
		$$add_urace_race_item($$get_player_from_entry_owner_list, 1)
;		$$activate_running_uma_skill($player_index, 27)
	}
	
	// ---------------- deb
	if( key['R'].on_down )
	{
;		$$activate_running_uma_skill(1, 27)
	}
	
	if( key['H'].on_down )
	{
;		$ultimate = 1
	}
	if( key['J'].on_down )
	{
;		$$create_urace_effect(front.object[<URACE_OBJ_SCREEN_EFFECT>], <URACE_EFFECT_AVOID>, front.object[<URACE_OBJ_UMA_TIP> + $$get_urace_my_lane_index].x, front.object[<URACE_OBJ_UMA_TIP> + $$get_urace_my_lane_index].y, 1)
;		front.object[<URACE_OBJ_SCREEN_EFFECT>].layer = <URACE_LAYER_ALL_FILTER>
	}
	
	if( $ultimate ) {
		
		$$skill_cutin(0, 25)
	}
	// ---------------- deb
	
	// レースを更新する
	$$update_race
	
	// プレイヤーがゴールしている場合はレース結果までスキップ可能にする
	if( $$get_entry_owner_goal_order($player_index) )
	{
		front.object[<URACE_OBJ_SKIP_BTN>].disp = 1
	}
	if( $select_btn == <URACE_OBJ_SKIP_BTN> )
	{
		if( $$skip(front) )
		{
			$$skip_to_goal_all_uma
		}
		$$update_scene_object(front)
	}
	
	//2
	if( $$get_entry_owner_goal_order($player_index) != 0 ) {
		front.object[<URACE_OBJ_CHANGE_BTN>].set_button_state_disable
	}
	if( $select_btn == <URACE_OBJ_CHANGE_BTN> )
	{
		$$change_runnig_uma($player_index, 0)
		
		if( $$has_next_uma($player_index) == 0 ) {
			front.object[<URACE_OBJ_CHANGE_BTN>].set_button_state_disable
		}
	}
	/*
	if( $$is_running_uma_active_skill_available($player_index) == 1 ) {
		front.object[<URACE_OBJ_SKILL_BTN>].set_button_state_normal
	} else {
		front.object[<URACE_OBJ_SKILL_BTN>].set_button_state_disable
	}
	*/
	if( $select_btn == <URACE_OBJ_SKILL_BTN> && $$is_running_uma_active_skill_available($player_index) == 1 )
	{
		$$activate_running_uma_skill($player_index, $$get_running_uma_skill_id($player_index), 0)
	}
	/*
	if( $$is_urace_race_item_available($player_index) == 1 ) {
		front.object[<URACE_OBJ_ITEM_BTN>].set_button_state_normal
	} else {
		front.object[<URACE_OBJ_ITEM_BTN>].set_button_state_disable
	}
	*/
	
	if( $select_btn == <URACE_OBJ_ITEM_BTN> && $$is_urace_race_item_available($player_index) == 1 )
	{
		$$use_urace_race_item($player_index)
	}
	
	// デバッグモードを更新する(レース中)
	if( $$check_debug_mode_enable )
	{
		if( $$update_urace_race_debug_mode(front.object[<URACE_OBJ_DEBUG>]) )
		{
			// レースデータをリセットする
			$$reset_entry_race_data
			
			goto #z01
		}
	}
	
	// レースが終了しているか判定する
	if( $$check_entry_race_finished )
	{
		if( $$check_entry_race_finished == 2 ) {
			$$skip_to_goal_all_uma
		}
		
		$$finished_urace_race_debug_mode(front.object[<URACE_OBJ_DEBUG>])
		
		break
	}
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_NORMAL>)
	}
	
	input.next
	disp
}

// ミニゲームで使用するカウンターを終了する
$$end_mng_counter

// 少し待つ
@se_stop_all(2500)
@bgm_stop(2500)
timewait_key(2500)

// 全てのオブジェクトのワイプコピーフラグをオフする
$$set_front_wipe_copy_all(0)

return


//---------------------------------------------------------------------------
// レース管理データを初期化する
//---------------------------------------------------------------------------
command $$init_data
{
	property $i
	
	$camera_x = 0								// カメラ座標を初期化する
	$entry_uma_num = $$get_entry_owner_num		// レースに参加している人数を設定する
	
	// ＵＭＡデータを初期化する
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$$init_running_uma_data($i)
	}
	
	// ---------debug setting
	$$create_entry_trap_data
	$$init_urace_projectile
	// ---------debug setting
	
	// プレイヤーのインデックスを設定する
	$player_index = $$get_player_from_entry_owner_list
	$rival_index = $$get_rival_from_entry_owner_list
	
	// ラストスパートフラグを初期化する
	$last_spurt = 0
	
	// ＵＩ管理データを初期化する
	// 各レーンのスタート、ゴール座標(x)を設定する
	$start_x.resize($entry_uma_num)
	$goal_x.resize($entry_uma_num)
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		// 左端オフセット 564
		// 右端オフセット 240
		// レース距離 + 564 + 240
;		$start_x[$i] = 564 - 135 * $i
		$start_x[$i] = 364;564 - 90 * $i
		$goal_x[$i] = (1920 * $$get_entry_race_distance_shift / <DISP_SHIFT>) - 240 ;- 90 * $i; - 135 * $i
	}
	
	// 各ＵＭＡ管理データを初期化する
	$uma_action_state.init
	$uma_action_state.resize($entry_uma_num)
	$uma_active_skill_id.init
	$uma_active_skill_id.resize($entry_uma_num)
	$uma_block_action.init
	$uma_block_action.resize($entry_uma_num)
}

//---------------------------------------------------------------------------
// レース更新
//---------------------------------------------------------------------------
command $$update_race()
{
	property $i
	
	// ＵＭＡの状態を更新する
	$$update_running_uma_buff
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$$update_running_uma_action($i)
	}
	
	$$calc_running_uma_buff
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$$update_running_uma_skill_after($i)
	}
	
	//2
	$$update_order
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$$npc($i)
		$$check_trap($i)
		$$check_item($i)
	}
	$$update_urace_projectile
	
	// ラストスパート判定
	// プレイヤーが一定距離を走るとラストスパート
	if( $last_spurt == 0 )
	{
		if( $$get_entry_owner_mileage($player_index) >= $$get_entry_race_last_spurt_distance )
		{
			// todo se鐘
			
			@bgm(bgm43b, 1000, 1000)
			
			$last_spurt = 1
		}
	}
	
	// シーンオブジェクトを更新する
	$$update_scene_object(front)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	
	// 背景
	$$create_bg($stage.object[<URACE_OBJ_BG>])
	
	$$create_screen_effect($stage.object[<URACE_OBJ_SCREEN_EFFECT>])
	
	// 各レーン(障害物／ＵＭＡチップ)
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		// 障害物
		$$create_trap($stage.object[<URACE_OBJ_TRAP> + $i], $i)
		$$create_item($stage.object[<URACE_OBJ_ITEM> + $i], $i)
		
		// ＵＭＡチップ
		$$create_uma_tip($stage.object[<URACE_OBJ_UMA_TIP> + $i], $i)
	}
	
	// プレイヤーカーソル
	$$create_player_cursor($stage)
	
	// プレイヤーの順位
	$$create_player_order($stage.object[<URACE_OBJ_PLAYER_ORDER>])
	
	// ミニマップ
	$$create_minimap($stage.object[<URACE_OBJ_MINI_MAP>])
	
	// オフスクリーンチップ
	$$create_off_screen_tip($stage.object[<URACE_OBJ_OFF_SCREEN_TIP>])
	
	// キャラ情報
	$$create_chara_info($stage.object[<URACE_OBJ_CHEER_WINDOW>])
	
	// 一時停止ボタン
	$$create_ui_button($stage.object[<URACE_OBJ_PAUSE_BTN>], __mng_ur_race_pause_btn, 1823, 199, <URACE_OBJ_PAUSE_BTN>, <URACE_BTN_GROUP_NORMAL>, 1)
	$stage.object[<URACE_OBJ_PAUSE_BTN>].layer = <URACE_LAYER_UI>
	
	// スキップボタン
	$$create_ui_button($stage.object[<URACE_OBJ_SKIP_BTN>], _mng_ur_race_skip_btn, 1812, 806, <URACE_OBJ_SKIP_BTN>, <URACE_BTN_GROUP_NORMAL>, 1)
	$stage.object[<URACE_OBJ_SKIP_BTN>].disp = 0
	$stage.object[<URACE_OBJ_SKIP_BTN>].layer = <URACE_LAYER_UI>
	
	// 交代ボタン
	$$create_ui_button($stage.object[<URACE_OBJ_CHANGE_BTN>], __mng_ur_race_change_btn, 1386, 920, <URACE_OBJ_CHANGE_BTN>, <URACE_BTN_GROUP_NORMAL>, 1)
	$stage.object[<URACE_OBJ_CHANGE_BTN>].layer = <URACE_LAYER_UI>
	
	// スキルボタン
	$$create_skill_button($stage.object[<URACE_OBJ_SKILL_BTN>])
	
	// アイテムボタン
	$$create_item_button($stage.object[<URACE_OBJ_ITEM_BTN>])
	
	// デバッグページ
	if( $$check_debug_mode_enable ) {
		$$create_urace_race_debug_mode($stage.object[<URACE_OBJ_DEBUG>])
		$stage.object[<URACE_OBJ_DEBUG>].layer = <URACE_LAYER_DEBUG>
	}
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$stage.object[<URACE_OBJ_BULLET> + $i].init
		$stage.object[<URACE_OBJ_BULLET> + $i].disp = 1
		$stage.object[<URACE_OBJ_BULLET> + $i].layer = <URACE_LAYER_TRAP> + $i * 10
		$stage.object[<URACE_OBJ_BULLET> + $i].child.resize(10)
	}
	
	// レース開始演出
	$$create_start_object($stage.object[<OBJ_START_EFFECT>])
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	// ワイプ
	wipe(0, 0, wait=1)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage)
{
	property $i
	
	// カメラの位置を更新する
	$$update_camera_pos
	
	// 背景
	$$update_bg($stage.object[<URACE_OBJ_BG>])
	
	// 各レーン(障害物／ＵＭＡチップ)
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		// 障害物
		$$update_trap($stage.object[<URACE_OBJ_TRAP> + $i], $i)
		$$update_item($stage.object[<URACE_OBJ_ITEM> + $i], $i)
		$$update_bullet($stage.object[<URACE_OBJ_BULLET> + $i], $i)
		
		// ＵＭＡチップ
		$$update_uma_tip($stage.object[<URACE_OBJ_UMA_TIP> + $i], $i)
		
		
		if( $uma_block_action[$i] != $$get_running_uma_block_flag($i) )
		{
			$uma_block_action[$i] = $$get_running_uma_block_flag($i)
			if( $uma_block_action[$i] ) {
				$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $i].cd_chara_util_ef_front.child[8])
			}
		}
	}
	
	// プレイヤーカーソル
	$$update_player_cursor($stage.object[<URACE_OBJ_UMA_TIP> + $player_index].cd_chara_player_cursor)
	
	// プレイヤーの順位
	$$update_player_order($stage.object[<URACE_OBJ_PLAYER_ORDER>])
	
	// ミニマップ
	$$update_minimap($stage.object[<URACE_OBJ_MINI_MAP>])
	
	// オフスクリーンチップ
	$$update_off_screen_tip($stage.object[<URACE_OBJ_OFF_SCREEN_TIP>])
	
	// キャラ情報
	$$update_chara_info($stage.object[<URACE_OBJ_CHEER_WINDOW>])
	
	// 交代ボタン
	
	// スキルボタン
	$$update_skill_button($stage.object[<URACE_OBJ_SKILL_BTN>])
	
	// アイテムボタン
	$$update_item_button($stage.object[<URACE_OBJ_ITEM_BTN>])
	
	// スキル
	$$update_skill
}

//---------------------------------------------------------------------------
// カメラの位置を更新する
//---------------------------------------------------------------------------
command $$update_camera_pos
{
	// プレイヤーキャラに追従する
	$camera_x = math.linear($$get_entry_owner_mileage($player_index), 0, $start_x[$player_index], $$get_entry_race_distance, $goal_x[$player_index])
	
	if( $camera_x < <SCREEN_CENTER_X> )
	{
		$camera_x = 0
	}
	else
	{
		$camera_x = $camera_x - <SCREEN_CENTER_X>
		
		if( $camera_x > 1920 * ($$get_entry_race_distance_shift / <DISP_SHIFT> - 1) )
		{
			$camera_x = 1920 * ($$get_entry_race_distance_shift / <DISP_SHIFT> - 1)
		}
	}
}

//---------------------------------------------------------------------------
// スキルボタン
//---------------------------------------------------------------------------
// 作成する
command $$create_skill_button(property $obj : object)
{
	// ベースボタン
	$$create_ui_button($obj, "__mng_ur_race_skill_btn01", 1528, 888, <URACE_OBJ_SKILL_BTN>, <URACE_BTN_GROUP_NORMAL>, 1)
	$obj.layer = <URACE_LAYER_UI>
	$obj.set_button_state_disable
	$obj.child.resize(2)
	
	// ゲージ
	$obj.child[0].create("__mng_ur_race_skill_bar", 1, 17, 17)
	$obj.child[0].set_src_clip(1, 0, 0, $obj.child[0].get_size_x, $obj.child[0].get_size_y)
	
	// アイコン
	$obj.child[1].create("__mng_ur_race_skill_icon", 1, 31, 32)
}

// 更新する
command $$update_skill_button(property $obj : object)
{
	property $skill_type
	
	$skill_type = $$get_db_skill_type($$get_running_uma_skill_id($player_index))
	
	$obj.change_file("__mng_ur_race_skill_btn" + math.tostr_zero($skill_type, 2))
	$obj.child[0].patno = $skill_type - 1
	$obj.child[1].patno = $skill_type - 1
	
	if( $$get_entry_owner_skill_power($player_index) < <OWNER_SKILL_POWER_MAX> * 1000 )
	{
		$obj.child[0].src_clip_top = math.linear($$get_entry_owner_skill_power($player_index), 0, $obj.child[0].get_size_y, <OWNER_SKILL_POWER_MAX> * 1000, 0)
		
		$obj.child[0].disp = 1
		$obj.child[1].disp = 1
		
		$obj.set_button_state_disable
	}
	else
	{
		if( $obj.get_button_state == 4 )
		{
			$obj.bright = 255
			$obj.bright_eve.set(0, 350, 0, 2)
			$obj.set_scale(1050, 1050)
			$obj.scale_x_eve.set(1000, 350, 0, 2)
			$obj.scale_y_eve.set(1000, 350, 0, 2)
			
			//@SE_ＵＭＡレース_スキルゲージ最大
		}
		
		$obj.child[0].disp = 0
		$obj.child[1].disp = 0
		
		$obj.set_button_state_normal
	}
}

//---------------------------------------------------------------------------
// アイテムボタン
//---------------------------------------------------------------------------
// 作成する
command $$create_item_button(property $obj : object)
{
	$$create_ui_button($obj, "__mng_ur_race_item_btn01", 1686, 828, <URACE_OBJ_ITEM_BTN>, <URACE_BTN_GROUP_NORMAL>, 1)
	$obj.set_button_state_disable
	$obj.layer = <URACE_LAYER_UI>
}

// 更新する
command $$update_item_button(property $obj : object)
{
	if( $$has_urace_race_item($player_index) )
	{
		if( $obj.get_button_state == 4 )
		{
			$obj.change_file("__mng_ur_race_item_btn" + math.tostr_zero($$get_urace_race_item_id($player_index), 2))
			
			$obj.bright = 255
			$obj.bright_eve.set(0, 350, 0, 2)
			$obj.set_scale(1050, 1050)
			$obj.scale_x_eve.set(1000, 350, 0, 2)
			$obj.scale_y_eve.set(1000, 350, 0, 2)
			
			//@SE_ＵＭＡレース_アイテム取得
		}
		
		$obj.set_button_state_normal
	}
	else
	{
		$obj.set_button_state_disable
	}
}

//---------------------------------------------------------------------------
// 背景を作成する
//---------------------------------------------------------------------------
command $$create_bg(property $obj : object)
{
	property $i
	property $len
	property $filename : str
	
	// ベースオブジェクトの設定
	$$set_child_object($obj, 3)
	$obj.layer = <URACE_LAYER_BG>
	
	// レース距離から使用する背景枚数を計算する
	$len = $$get_entry_race_distance_shift / <DISP_SHIFT>
	
	// 背景
	$filename = "_mng_ur_race_bg" + math.tostr_zero($$get_db_race_ground_type($$get_entry_race_id), 2)
	$$set_child_object($obj.child[0], $len)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$obj.child[0].child[$i].create($filename, 1, 1920 * $i, 0, 4 + $$get_entry_race_ground_type)
		$obj.child[0].child[$i].child.resize(2)
		$obj.child[0].child[$i].child[0].create($filename, 1, 0, 0, 1)
		
		if( $i % 2 ) {
			$obj.child[0].child[$i].scale_x = -1000
			$obj.child[0].child[$i].x += 1920
		}
		
		if( $i == 0 ) {
			$obj.child[0].child[$i].child[1].create($filename, 1)
		}
	}
	
	// レーン
	$$set_child_object($obj.child[1], $len)
	$obj.child[1].y = 376
	for( $i = 0, $i < $len, $i += 1 )
	{
		$obj.child[1].child[$i].create("_mng_ur_race_bg_line", 1, 1920 * $i, 0)
		
		$obj.child[1].child[$i].patno = 0
		//2
		/*
		if( $i == 0 )
		{
			$obj.child[1].child[$i].patno = 0
		}
		elseif( $i == $len - 1 )
		{
			$obj.child[1].child[$i].patno = 2
		}
		else
		{
			$obj.child[1].child[$i].patno = 1
		}
		*/
	}
}

//---------------------------------------------------------------------------
// 背景を更新する
//---------------------------------------------------------------------------
command $$update_bg(property $obj : object)
{
	property $i
	property $len
	
	// カメラから座標を補正する
	$obj.x = -$camera_x
	
	$len = $$get_entry_race_distance_shift / <DISP_SHIFT>
	for( $i = 0, $i < $len, $i += 1 )
	{
		$obj.child[0].child[$i].patno = 4 + $$get_entry_race_ground_type
		
		if( $obj.child[0].child[$i].patno == 8 ) {
			$obj.child[0].child[$i].patno = 6
		}
	}
}

//---------------------------------------------------------------------------
// 障害物を作成する
//---------------------------------------------------------------------------
command $$create_trap(property $obj : object, property $lane_index)
{
	property $i
	property $len
	property $trap_id
	property $center_pos
	
	// ベースオブジェクトの設定
	$len = $$get_trap_num($lane_index)
	$$set_child_object($obj, $len)
	$obj.layer = <URACE_LAYER_TRAP> + $lane_index * 10
	
	// 各障害物の作成
	for( $i = 0, $i < $len, $i += 1 )
	{
		$trap_id = $$get_trap_id($lane_index, $i)
		
		$$create_urace_trap($obj.child[$i], $trap_id)
		
		$obj.child[$i].x = math.linear($$get_trap_place($lane_index, $i), 0, $start_x[$lane_index], $$get_entry_race_distance, $goal_x[$lane_index])
		$obj.child[$i].y = $$get_lane_y($lane_index + 1)
		
		// 各障害物ごとの処理
		switch( $trap_id ) {
		case(@レース障害物_海藻)		$obj.child[$i].frame_action.start(-1, "$$fa_water_float_trap", math.rand(0, 199))
		case(@レース障害物_岩礁)		$obj.child[$i].patno_eve.loop(0, 2, 1500, 0, 0)
										$obj.child[$i].y += 20
		case(@レース障害物_渦巻)		$obj.child[$i].patno_eve.loop(0, 2, 1500, 0, 0)
										$obj.child[$i].frame_action.start(-1, "$$fa_water_float_trap", math.rand(0, 199))
										$obj.child[$i].child.resize(1)
										$$create_urace_effect($obj.child[$i].child[0], <URACE_EFFECT_ENV_SWIRL_WATER>, $obj.child[$i].get_size_x / 2, $obj.child[$i].get_size_y / 2, 1)
		}
	}
}

//---------------------------------------------------------------------------
// 障害物を更新する
//---------------------------------------------------------------------------
command $$update_trap(property $obj : object, property $lane_index)
{
	// カメラから座標を補正する
	$obj.x = -$camera_x
}

//---------------------------------------------------------------------------
// 障害物が水面に浮いているフレームアクション
//---------------------------------------------------------------------------
command $$fa_water_float_trap(property $fa : frameaction, property $obj : object, property $rand)
{
	l[0] = ($fa.counter.get + $rand) / 200 % 10
	if( l[0] < 5 ) {
		$obj.y_rep[1] = l[0]
	} else {
		$obj.y_rep[1] = 10 - l[0]
	}
}

//---------------------------------------------------------------------------
// 障害物エフェクトを作成する
//---------------------------------------------------------------------------
command $$play_trap_effect(property $owner_index, property $lane_index, property $trap_index)
{
	$$play_urace_trap_hit_animation(front.object[<URACE_OBJ_TRAP> + $lane_index].child[$trap_index])
	
	switch( $$get_trap_id($lane_index, $trap_index) ) {
	case(@レース障害物_小石)		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $owner_index].cd_chara_util_ef_front.child[1])
	case(@レース障害物_草むら)		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $owner_index].cd_chara_util_ef_front.child[3])
	case(@レース障害物_水たまり)	$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $owner_index].cd_chara_util_ef_front.child[5])
	case(@レース障害物_茂み)		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $owner_index].cd_chara_util_ef_front.child[4])
	case(@レース障害物_海藻)		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $owner_index].cd_chara_util_ef_front.child[5])
	}
}

//---------------------------------------------------------------------------
// アイテムを作成する
//---------------------------------------------------------------------------
command $$create_item(property $obj : object, property $lane_index)
{
	property $i
	property $len
	property $item_id
	property $center_pos
	
	// ベースオブジェクトの設定
	$len = $$get_item_size
	$$set_child_object($obj, $len)
	$obj.layer = <URACE_LAYER_TRAP> + $lane_index * 10
	
	// 各アイテムの作成
	for( $i = 0, $i < $len, $i += 1 )
	{
		$item_id = $$get_entry_lane_item_id($lane_index, $i)
		
		if( $item_id == 0 ) {
			continue
		}
		
		$obj.child[$i].create("__mng_ur_item00", 1, 0, 0, 1)
		$obj.child[$i].center_rep_x = $obj.child[$i].get_size_x / 2
		$obj.child[$i].f.resize(1)
		$obj.child[$i].child.resize(1)
		$obj.child[$i].child[0].create("__mng_ur_item00", 1)
		
		$obj.child[$i].x = math.linear($$get_entry_lane_item_place($lane_index, $i), 0, $start_x[$lane_index], $$get_entry_race_distance, $goal_x[$lane_index])
		$obj.child[$i].y = $$get_lane_y($lane_index)
		
		$obj.child[$i].child[0].y_rep.resize(2)
		$obj.child[$i].child[0].y_rep_eve[0].turn(-10, 0, 1000, 0, 2)
	}
}

//---------------------------------------------------------------------------
// アイテムを更新する
//---------------------------------------------------------------------------
command $$update_item(property $obj : object, property $lane_index)
{
	// カメラから座標を補正する
	$obj.x = -$camera_x
}

command $$del_item_box(property $lane, property $index)
{
	if(front.object[<URACE_OBJ_ITEM> + $lane].child[$index].f[0] == 0 )
	{
		front.object[<URACE_OBJ_ITEM> + $lane].child[$index].child[0].y_rep_eve[0].end
		front.object[<URACE_OBJ_ITEM> + $lane].child[$index].child[0].y_rep[0] = 0
		
		front.object[<URACE_OBJ_ITEM> + $lane].child[$index].child[0].y_rep_eve[1].set(-50, 250, 0, 2)
		front.object[<URACE_OBJ_ITEM> + $lane].child[$index].scale_x_eve.set(0, 250, 0, 2)
		front.object[<URACE_OBJ_ITEM> + $lane].child[$index].bright_eve.set(255, 250, 0, 2)
		front.object[<URACE_OBJ_ITEM> + $lane].child[$index].tr_eve.set(0, 250, 0, 2)
		
		front.object[<URACE_OBJ_ITEM> + $lane].child[$index].f[0] = 1
	}
}


//---------------------------------------------------------------------------
// ＵＭＡチップを作成する
//---------------------------------------------------------------------------
command $$create_uma_tip(property $obj : object, property $lane_index)
{
	property $i
	property $skill_id
	
	property $owner_id
	property $uma_index
	
	$owner_id = $$get_entry_owner_id($lane_index)
	$uma_index = $$get_entry_uma_index($lane_index)
	
	$$set_child_object($obj, 10)
	$$set_child_object($obj.cd_chara, 7)
	// --
	// child[0]				cd_shadow／影
	// child[1]				cd_chara／キャラベース
	// child[1].child[0]	cd_chara_util_ef_back／汎用エフェクト(キャラチップ背面)
	// child[1].child[1]	cd_chara_skill_ef_back／スキルエフェクト(キャラチップ背面)
	// child[1].child[2]	cd_chara_tip／キャラチップ
	// child[1].child[3]	cd_chara_util_ef_front／汎用エフェクト(キャラチップ前面)
	// child[1].child[4]	cd_chara_skill_ef_front／スキルエフェクト(キャラチップ前面)
	// child[1].child[5]	cd_chara_player_cursor／プレイヤーカーソル
	// child[2]				cd_wave／波
	// child[3]				cd_dig／穴掘り
	// child[4]				cd_run_scatter／地形ごとの走るエフェクト
	// child[5]				cd_skill／スキル表示
	// --
	
	$obj.y = $$get_lane_y($lane_index)
	$obj.layer = <URACE_LAYER_UMA_TIP> + $$get_now_lane($lane_index) * 10
	
	// ＵＭＡチップ
	$$create_uma_tip_object($obj.cd_chara_tip, $$get_running_uma_id($lane_index), 0, 70)
	
	$obj.cd_chara_tip.frame_action_ch.resize(1)
	$obj.cd_chara_tip.x_rep.resize(1)
	$obj.cd_chara_tip.y_rep.resize(3)
	
	// --- エフェクト先読み
	// 汎用エフェクト前面
	$$create_util_effect($obj)
	
	// 影／地形が水面でない場合は作成する
	if( $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_SURFACE> )
	{
		// 例外として、オキナのみ影を作成しない todo
		if( $$get_running_uma_id($lane_index) != @ＵＭＡ_オキナ ) {
			$obj.cd_shadow.create("urace_race_tip_shadow", 1, -110, 20)
		}
	}
	else
	{
		$obj.cd_chara_tip.frame_action_ch[0].start(-1, "$$fa_swim_uma_tip")
		
		$obj.cd_wave.disp = 1
		$obj.cd_wave.child.resize(2)
		$$create_urace_effect($obj.cd_wave.child[0], <URACE_EFFECT_WAVE>, 0, 50, 1)
		
		if( $$get_uma_run_type($owner_id, $uma_index) == <UMA_RUN_TYPE_FLY> ) {
			$obj.cd_wave.child[0].disp = 0
		}
	}
	
	// スキルエフェクト
	$$create_skill_effect($obj, $lane_index)
	
	// 地形ごとの走るエフェクト
	switch( $$get_db_race_ground_type($$get_entry_race_id) ) {
	case(<URACE_GROUND_TYPE_TURF>)			$$create_urace_effect($obj.cd_run_scatter, <URACE_EFFECT_RUN_SCATTER_TURF>, 0, 0, 0)
	case(<URACE_GROUND_TYPE_DIRT>)			$$create_urace_effect($obj.cd_run_scatter, <URACE_EFFECT_RUN_SCATTER_DIRT>, 0, 0, 0)
	case(<URACE_GROUND_TYPE_SURFACE>)		$$create_urace_effect($obj.cd_run_scatter, <URACE_EFFECT_RUN_SCATTER_WATER>, 0, 0, 0)
	case(<URACE_GROUND_TYPE_SPACE>)			$$create_urace_effect($obj.cd_run_scatter, <URACE_EFFECT_RUN_SCATTER_ALMIGHTY>, 0, 0, 0)
	}
	
	;/*
	// スキル発動表示
	$obj.cd_skill.create(_mng_ur_race_skill_frame, 1, -230, -96)
	$obj.cd_skill.y_rep.resize(1)
	$obj.cd_skill.f.resize(1)
	$obj.cd_skill.tr = 0
	$obj.cd_skill.tr_rep.resize(1)
	$obj.cd_skill.child.resize(1)
	$obj.cd_skill.child[0].create_string("", 1, 8, 8)
	$obj.cd_skill.child[0].set_string_param(20, 1, 5, 100, 0, 1, 2, 1)
	
	// ライフバー
	$$create_life_bar($obj.cd_life_bar, $lane_index)
	
	// 地形適性発動表示
	//switch( $$get_uma_ground_type($owner_id, $uma_index, $$get_db_race_ground_type($$get_entry_race_id)) ) {
	switch( $$get_running_uma_ground_type($lane_index, $$get_db_race_ground_type($$get_entry_race_id)) ) {
	case(<UMA_GROUND_TYPE_C>)		$obj.child[7].create_rect(0, 0, 128, 36, 255, 0, 255, 192, 1)
	case(<UMA_GROUND_TYPE_B>)		$obj.child[7].create_rect(0, 0, 128, 36, 0, 255, 0, 192, 1)
	case(<UMA_GROUND_TYPE_A>)		$obj.child[7].create_rect(0, 0, 128, 36, 255, 0, 0, 192, 1)
	}
	
	$obj.child[7].set_pos(80, 0)
	$obj.child[7].y_rep.resize(1)
	$obj.child[7].f.resize(1)
	$obj.child[7].tr = 0
	$obj.child[7].tr_rep.resize(1)
	$obj.child[7].child.resize(1)
	$obj.child[7].child[0].create_string("", 1, 8, 8)
	$obj.child[7].child[0].set_string_param(20, 1, 5, 100, 0, 1, 2, 1)
	
	$obj.child[8].create_rect(0, 0, 228, 36, 128, 0, 128, 192, 1)
	$obj.child[8].set_pos(80, -40)
	$obj.child[8].y_rep.resize(1)
	$obj.child[8].f.resize(1)
	$obj.child[8].tr = 0
	$obj.child[8].tr_rep.resize(1)
	$obj.child[8].child.resize(1)
	$obj.child[8].child[0].create_string("", 1, 8, 8)
	$obj.child[8].child[0].set_string_param(20, 1, 5, 100, 0, 1, 2, 1)
	
;	$obj.child[9].create_string(math.tostr($lane_index), 1, 8, 8)
;	$obj.child[9].set_string_param(30, 1, 5, 100, 0, 1, 2, 1)
	
;	$obj.child[9].create_rect(0, 0, 228, 36, 128, 128, 0, 192, 1)
;	$obj.child[9].set_pos(80, -40)
;	$obj.child[9].y_rep.resize(1)
;	$obj.child[9].f.resize(1)
;	$obj.child[9].tr = 0
;	$obj.child[9].tr_rep.resize(1)
;	$obj.child[9].child.resize(1)
;	$obj.child[9].child[0].create_string("ラストスパート発生", 1, 8, 8)
;	$obj.child[9].child[0].set_string_param(20, 1, 5, 100, 0, 1, 2, 1)
	;*/
}

//2
command $$recreate_uma_tip(property $lane_index)
{
	$$create_uma_tip(front.object[<URACE_OBJ_UMA_TIP> + $lane_index], $lane_index)
	
	for( l[0] = 0, l[0] < 25, l[0] += 1 ) {
		$$stop_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_util_ef_front.child[l[0]])
	}
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y = $$get_lane_y($$get_now_lane($lane_index))
	
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].tr = 255
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.bright_eve.end
}
command $$retire_uma_tip(property $lane_index)
{
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].tr_eve.set(0, 500, 0, 2)
}
command $$change_uma_tip(property $lane_index)
{
	$$create_uma_tip(front.object[<URACE_OBJ_UMA_TIP> + $lane_index], $lane_index)
	$$update_uma_tip(front.object[<URACE_OBJ_UMA_TIP> + $lane_index], $lane_index)
	
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y = $$get_lane_y($$get_now_lane($lane_index))
	
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].tr = 255
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.bright_eve.end
	
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
	
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].scale_x = 0
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].scale_x_eve.set(1000, 250, 0, 2)
	
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y_rep.resize(1)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y_rep[0] =-200
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y_rep_eve[0].set(0, 250, 0, 2)
}

command $$create_life_bar(property $obj : object, property $index)
{
	$obj.disp = 1
	$obj.set_pos(-80, 40)
	$obj.child.resize(7)
	
	/*
	// テンションカウント
	$obj.child[0].create_rect(0, 0, 40, 40, 0, 0, 0, 192, 1)
	$obj.child[1].create_rect(0, 0, 40, 40, 255, 0, 0, 192, 1)
	$obj.child[1].set_src_clip(1, 0, 0, 40, 40)
	$obj.child[2].create_string("1", 1, 12, 8)
	$obj.child[2].set_string_param(24, 1, 5, 100, 0, 1, 2, 1)
	
	// テンションバー
	$obj.child[3].create_rect(0, 0, 108, 24, 0, 0, 0, 192, 1)
	$obj.child[3].set_pos(42, 16)
	$obj.child[4].create_rect(0, 0, 100, 16, 255, 0, 0, 192, 1)
	$obj.child[4].set_pos(46, 20)
	$obj.child[4].set_src_clip(1, 0, 0, 100, 16)
	*/
	// スタミナバー
	$obj.child[5].create_rect(0, 0, 108, 12, 0, 0, 0, 192, 1)
	$obj.child[5].set_pos(42, 6)
	$obj.child[6].create_rect(0, 0, 100, 8, 255, 0, 0, 192, 1)
	$obj.child[6].set_pos(46, 10)
	$obj.child[6].set_src_clip(1, 0, 0, 100, 8)
}

command $$update_life_bar(property $obj : object, property $index)
{
	property $value
	/*
	// テンションカウント
	$value = $$get_running_uma_tension($index)
	$obj.child[1].src_clip_top = 40 - math.linear($value / 1000, <RUNNING_UMA_TENSION_MIN>, 0, <RUNNING_UMA_TENSION_MAX>, 40)
	$obj.child[2].set_string(math.tostr($value / 100000))
	
	// テンションバー
	$obj.child[4].src_clip_right = ($value / 1000) % 100
	*/
	// スタミナバー
	$value = $$get_running_uma_life($index) * 100 / $$get_running_uma_life_max($index)
	$obj.child[6].src_clip_right = $value
}

//---------------------------------------------------------------------------
// ＵＭＡチップを更新する
//---------------------------------------------------------------------------
command $$update_uma_tip(property $obj : object, property $lane_index)
{
	// 走行距離に応じて座標を設定する
	$obj.x = math.linear($$get_entry_owner_mileage($lane_index), 0, $start_x[$lane_index], $$get_entry_race_distance, $goal_x[$lane_index])
	
	// カメラ座標からチップ座標を補正する
	$obj.x -= $camera_x
	
	// ジャンプパワーからy座標を設定する
	if( $$get_running_uma_jump_power($lane_index) > 0 )
	{
		$obj.cd_chara.y = -$$get_running_uma_jump_power($lane_index)
	}
	else
	{
		if( $$get_running_uma_hide_mode_power($lane_index) == 0 ) {
			$obj.cd_run_scatter.disp = 1
		} else {
			$obj.cd_run_scatter.disp = 0
		}
		$obj.cd_chara.y = -$$get_running_uma_hide_mode_power($lane_index)
		
		if( $obj.cd_wave.child.get_size )
		{
			if( $obj.cd_wave.disp == 0 )
			{
				$$play_urace_effect($obj.cd_chara_util_ef_front.child[6])
			}
		}
	}
	
	// ＵＭＡの行動状態が変更されたらそれぞれの更新を行う
	if( $uma_action_state[$lane_index] != $$get_running_uma_action_state($lane_index) )
	{
		switch( $$get_running_uma_action_state($lane_index) ) {
		
		// 行動／スタート待機
		case(<RUNNING_UMA_ACTION_STATE_START_WAIT>)
			
			$obj.cd_run_scatter.disp = 0
			
			$$play_uma_tip_wait_anim($obj.cd_chara_tip)
			
		// 行動／スタート
		case(<RUNNING_UMA_ACTION_STATE_START>)
			
			$$play_uma_tip_move_anim($obj.cd_chara_tip)
			
			$obj.cd_chara_tip.bright_eve.end
			$obj.cd_chara_tip.tr_eve.end
			
			$obj.cd_run_scatter.disp = 1
			$$play_urace_effect($obj.cd_run_scatter)
			
			if( $obj.cd_wave.child.get_size )
			{
				$obj.cd_wave.disp = 1
			}
			
		// 行動／待機
		case(<RUNNING_UMA_ACTION_STATE_WAIT>)
			
			$$play_uma_tip_wait_anim($obj.cd_chara_tip)
			
		// 行動／走り
		case(<RUNNING_UMA_ACTION_STATE_RUN>)
			
			$$stop_urace_effect($obj.cd_chara_util_ef_front.child[2])
			
			$$play_uma_tip_move_anim($obj.cd_chara_tip)
			
			$obj.cd_chara_tip.rotate_z_eve.end
			$obj.cd_chara_tip.rotate_z = 0
			
			$obj.cd_chara_tip.scale_x = 1000
			
			if( $$get_running_uma_invincible_time($lane_index) <= 0 ) {
				$obj.cd_chara_tip.bright_eve.end
				$obj.cd_chara_tip.tr_eve.end
				$obj.cd_chara_tip.mono = 0
			}
			
			$obj.cd_run_scatter.disp = 1
			$$play_urace_effect($obj.cd_run_scatter)
			
			if( $obj.cd_wave.child.get_size )
			{
				$obj.cd_wave.disp = 1
			}
			
		// 行動／レーンチェンジ
		case(<RUNNING_UMA_ACTION_STATE_LANE_CHANGE>)
			
			$obj.cd_chara_tip.bright_eve.end
			$obj.cd_chara_tip.tr_eve.end
			
			$$play_uma_tip_jump_anim($obj.cd_chara_tip)
			
			$obj.y_eve.set($$get_lane_y($$get_now_lane($lane_index)), 150, 0, 2)
			$obj.layer = <URACE_LAYER_UMA_TIP> + $$get_now_lane($lane_index) * 10
			
		// 行動／交代中
		case(<RUNNING_UMA_ACTION_STATE_RUNNER_CHANGE>)
			
			$obj.cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
			$obj.cd_chara_tip.tr_eve.turn(255, 192, 150, 0, 0)
			
		// 行動／気絶
		case(<RUNNING_UMA_ACTION_STATE_STUN>)
			
			$$play_urace_effect($obj.cd_chara_util_ef_front.child[2])
			
			$$play_uma_tip_stun_anim($obj.cd_chara_tip)
			
			$obj.cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
			$obj.cd_chara_tip.tr_eve.turn(255, 192, 150, 0, 0)
			
			$obj.cd_run_scatter.disp = 0
			$$stop_urace_effect($obj.cd_run_scatter)
			
		// 行動／苦手地形
		case(<RUNNING_UMA_ACTION_STATE_GROUND_WEAK>)
			
			$$play_urace_effect($obj.cd_chara_util_ef_front.child[2])
			$$play_urace_effect($obj.cd_chara_util_ef_front.child[24])
			
			$$play_uma_tip_stun_anim($obj.cd_chara_tip)
			
			$obj.cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
			$obj.cd_chara_tip.tr_eve.turn(255, 192, 150, 0, 0)
			
			$obj.cd_run_scatter.disp = 0
			$$stop_urace_effect($obj.cd_run_scatter)
			
		// 行動／打ち上げ
		case(<RUNNING_UMA_ACTION_STATE_LAUNCH>)
			
			$obj.cd_chara_tip.rotate_z_eve.loop(0, -3600, 250, 0, 0)
			
			$obj.cd_chara.y = -$$get_running_uma_jump_power($lane_index)
			$obj.y_eve.set($$get_lane_y($$get_now_lane($lane_index)), 150, 0, 2)
			
			$obj.cd_run_scatter.disp = 0
			$$stop_urace_effect($obj.cd_run_scatter)
			
		// 行動／障害物アクション／失敗
		case(<RUNNING_UMA_ACTION_STATE_TRAP_FAILURE>)
			
			if( $lane_index == $player_index )
			{
				screen.quake[0].start(1, 180, 2, 0, 0, 0, [10, 0])
				screen.quake[1].start(1, 130, 2, 0, 0, 0, [10, 6])
			}
			
			$obj.cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
			$obj.cd_chara_tip.tr_eve.turn(255, 192, 150, 0, 0)
			
			if( $$get_db_trap_effect_type($$get_running_uma_action_trap_id($lane_index)) == <TRAP_EFFECT_TYPE_STUN> )
			{
				$$play_uma_tip_stun_anim($obj.cd_chara_tip)
				
				$$play_urace_effect($obj.cd_chara_util_ef_front.child[2])
				
				$obj.cd_run_scatter.disp = 0
				$$stop_urace_effect($obj.cd_run_scatter)
				
				if( $obj.cd_wave.child.get_size )
				{
					$$play_urace_effect($obj.cd_chara_util_ef_front.child[6])
				}
			}
			
			$$play_trap_effect($lane_index, $$get_now_lane($lane_index), $$get_running_uma_action_trap_index($lane_index))
			
		// 行動／ゴール
		case(<RUNNING_UMA_ACTION_STATE_GOAL>)
			
			$$play_uma_tip_wait_anim($obj.cd_chara_tip)
			
			$obj.cd_run_scatter.disp = 0
			$$stop_urace_effect($obj.cd_run_scatter)
			$$stop_urace_effect($obj.cd_chara_util_ef_front.child[22])
			
		case(<RUNNING_UMA_ACTION_STATE_DEAD>)
			
			if( $lane_index == $player_index )
			{
				screen.quake[0].start(1, 180, 2, 0, 0, 0, [10, 0])
				screen.quake[1].start(1, 130, 2, 0, 0, 0, [10, 6])
			}
			
			$obj.cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
			$obj.cd_chara_tip.tr_eve.turn(255, 192, 150, 0, 0)
			
			if( $$get_db_trap_effect_type($$get_running_uma_action_trap_id($lane_index)) == <TRAP_EFFECT_TYPE_STUN> )
			{
				$$play_uma_tip_stun_anim($obj.cd_chara_tip)
				
				$$play_urace_effect($obj.cd_chara_util_ef_front.child[2])
				
				$obj.cd_run_scatter.disp = 0
				$$stop_urace_effect($obj.cd_run_scatter)
				
				if( $obj.cd_wave.child.get_size )
				{
					$$play_urace_effect($obj.cd_chara_util_ef_front.child[6])
				}
			}
			
		case(<RUNNING_UMA_ACTION_STATE_COURSE_OUT>)
			
			$obj.cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
			$obj.cd_chara_tip.tr_eve.turn(255, 192, 150, 0, 0)
			
		// 行動／石化
		case(<RUNNING_UMA_ACTION_STATE_STONE>)
			
			$$play_urace_effect($obj.cd_chara_util_ef_front.child[2])
			
			$$play_uma_tip_stun_anim($obj.cd_chara_tip)
			
			$obj.cd_chara_tip.mono = 255
			$obj.cd_chara_tip.bright_eve.turn(96, 192, 150, 0, 0)
			$obj.cd_chara_tip.tr_eve.turn(255, 192, 150, 0, 0)
			
			$obj.cd_run_scatter.disp = 0
			$$stop_urace_effect($obj.cd_run_scatter)
		}
		
		$uma_action_state[$lane_index] = $$get_running_uma_action_state($lane_index)
	}
	
	// スタミナ切れの場合はエフェクトを表示する
	/*
	if( $$get_running_uma_stamina($lane_index) <= 0 )
	{
		if( $$get_running_uma_action_state($lane_index) == <RUNNING_UMA_ACTION_STATE_RUN> || $$get_running_uma_action_state($lane_index) == <RUNNING_UMA_ACTION_STATE_TRAP_SUCCESS> )
		{
			if( $obj.cd_chara_util_ef_front.child[0].disp == 0 )
			{
				$obj.cd_chara_util_ef_front.child[0].disp = 1
				$$play_urace_effect($obj.cd_chara_util_ef_front.child[0])
			}
		}
		else
		{
			if( $obj.cd_chara_util_ef_front.child[0].disp == 1 )
			{
				$obj.cd_chara_util_ef_front.child[0].disp = 0
				$$stop_urace_effect($obj.cd_chara_util_ef_front.child[0])
			}
		}
	}
	*/
	
	// スピードによってアニメーション速度を変える
;	$$set_urace_uma_tip_move_anim_time($obj.cd_chara_tip, math.linear($$get_running_uma_speed($lane_index), 0, 300, $$get_running_uma_speed_max($lane_index), 150))
	
	if( $$get_running_uma_action_state($lane_index) == <RUNNING_UMA_ACTION_STATE_RUN> )
	{
		if( $$get_running_uma_invincible_time($lane_index) <= 0 && $obj.cd_chara_tip.bright_eve.check )
		{
			$obj.cd_chara_tip.bright_eve.end
			$obj.cd_chara_tip.tr_eve.end
		}
	}
	
	$$update_life_bar($obj.cd_life_bar, $lane_index)
}

//---------------------------------------------------------------------------
// 泳ぎのフレームアクション
//---------------------------------------------------------------------------
command $$fa_swim_uma_tip(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get / 200 % 6
	if( l[0] < 3 ) {
		$obj.y_rep[1] = l[0] + 15
	} else {
		$obj.y_rep[1] = 6 - l[0] + 15
	}
}

//---------------------------------------------------------------------------
// プレイヤーカーソルを作成する
//---------------------------------------------------------------------------
command $$create_player_cursor(property $stage : stage)
{
	property $i
	property $patno
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		switch( $i ) {
		case($player_index)		$patno = 0
		case($rival_index)		$patno = 1
		default					$patno = 2
		}
		
		$stage.object[<URACE_OBJ_UMA_TIP> + $i].cd_chara_player_cursor.create(__mng_ur_race_chara_cursor, 1, -120, 10, $patno)
		
		if( $i == $player_index )
		{
			$stage.object[<URACE_OBJ_UMA_TIP> + $i].cd_chara_player_cursor.x_rep.resize(1)
			$stage.object[<URACE_OBJ_UMA_TIP> + $i].cd_chara_player_cursor.x_rep_eve[0].turn(-10, 0, 500, 0, 2)
		}
	}
}

//---------------------------------------------------------------------------
// プレイヤーカーソルを更新する
//---------------------------------------------------------------------------
command $$update_player_cursor(property $obj : object)
{
}

//---------------------------------------------------------------------------
// プレイヤーの順位を作成する
//---------------------------------------------------------------------------
command $$create_player_order(property $obj : object)
{
	$obj.create(__mng_ur_race_player_order, 1, 1585, 28)
	$$set_image_center_rep($obj)
	$obj.tr = 0
	$obj.f.resize(1)
}

//---------------------------------------------------------------------------
// プレイヤーの順位を更新する
//---------------------------------------------------------------------------
command $$update_player_order(property $obj : object)
{
	// ゴールしている場合は更新しない
	if( $$get_entry_owner_goal_order($player_index) != 0 ) {
		return
	}
	
	if( $obj.f[0] != $$get_order($player_index) )
	{
		$obj.patno = $$get_order($player_index) - 1
		
		$obj.set_scale(2000, 2000)
		$obj.scale_x_eve.set(1000, 250, 0, 2)
		$obj.scale_y_eve.set(1000, 250, 0, 2)
		
		$obj.tr = 0
		$obj.tr_eve.set(255, 250, 0, 2)
		
		$obj.bright = 255
		$obj.bright_eve.set(0, 250, 0, 2)
		
		$obj.f[0] = $$get_order($player_index)
	}
}

//---------------------------------------------------------------------------
// ミニマップを作成する
//---------------------------------------------------------------------------
command $$create_minimap(property $obj : object)
{
	property $i
	property $patno
	property $base_x
	property $base_y
	
	$base_x = 481
	$base_y = 92
	
	// ベース
	$obj.create(__mng_ur_race_minimap_bg, 1, $base_x, $base_y)
	$obj.layer = <URACE_LAYER_UI>
	
	// アイコン
	$$set_child_object($obj, $entry_uma_num)
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		switch( $i ) {
		case($player_index)		$patno = 0
		case($rival_index)		$patno = 1
		default					$patno = 2
		}
		
		$obj.child[$i].create(__mng_ur_race_minimap_icon, 1, 0, -31, $patno)
		
		if( $i == $player_index ) {
			$obj.child[$i].layer = 1
		}
	}
}

//---------------------------------------------------------------------------
// ミニマップを更新する
//---------------------------------------------------------------------------
command $$update_minimap(property $obj : object)
{
	property $i
	property $map_l
	property $map_r
	
	$map_l = 490 - $obj.x - $obj.child[0].get_size_x / 2
	$map_r = 1416 - $obj.x - $obj.child[0].get_size_x / 2
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$obj.child[$i].x = math.linear($$get_entry_owner_mileage($i), 0, $map_l, $$get_entry_race_distance, $map_r)
		
		if( $$get_entry_owner_retire($i) ) {
			$obj.child[$i].disp = 0
		}
	}
}

//---------------------------------------------------------------------------
// オフスクリーンチップを作成する
//---------------------------------------------------------------------------
command $$create_off_screen_tip(property $obj : object)
{
	property $i
	property $index
	property $frame_patno
	property $icon_patno
	property $filename : str
	
	$$set_child_object($obj, $entry_uma_num * 2)
	$obj.layer = <URACE_LAYER_UI>
	
	// 各レーンのチップを作成する
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		// プレイヤーはカメラの中心なので作成しない
		if( $i == $player_index ) {
			continue
		}
		
		$index = $i * 2
		$frame_patno = 1
		$icon_patno = $$get_running_uma_id($i)
		
		// ライバルはフレームを変更する
		if( $i == $rival_index ) {
			$frame_patno = 0
		}
		
		// 左枠
		$obj.child[$index + 0].create(__mng_ur_race_off_screen_tip_l, 1, 44, 362 + $i * 90, $frame_patno)
		$obj.child[$index + 0].child.resize(1)
		$obj.child[$index + 0].child[0].create(__mng_ur_race_off_screen_tip, 1, 35, 14, $icon_patno)
		
		// 右枠
		$obj.child[$index + 1].create(__mng_ur_race_off_screen_tip_r, 1, 1531, 322 + $i * 90, $frame_patno)
		$obj.child[$index + 1].child.resize(1)
		$obj.child[$index + 1].child[0].create(__mng_ur_race_off_screen_tip, 1, 15, 14, $icon_patno)
	}
}

//---------------------------------------------------------------------------
// オフスクリーンチップを更新する
//---------------------------------------------------------------------------
command $$update_off_screen_tip(property $obj : object)
{
	property $i
	property $distance
	property $disp_l
	property $disp_r
	property $offset
	
	$offset = (<SCREEN_CENTER_X> - front.object[<URACE_OBJ_UMA_TIP> + $player_index].x) * 52
	
	// 各レーンの表示／非表示を判定する
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		// プレイヤーはカメラの中心なので処理しない
		if( $i == $player_index ) {
			continue
		}
		
		// 各レーンのＵＭＡとプレイヤーＵＭＡとの距離を計算する
		$distance = $$get_entry_owner_mileage($player_index) - $$get_entry_owner_mileage($i)
		
		// deb
		// out_screen  960pixel = 50m
		//             1pixel = 0.05m
		// lane_offset 160pixel = 8m
		// chara_tip   189 / 2pixel = 4.725m
		$disp_l = (<DISP_SHIFT> / 2 - $i * 6 + 5) * 1000 - $offset + 28000
		$disp_r = -(<DISP_SHIFT> / 2 + $i * 6 + 5) * 1000 + $offset + 28000
		
		if( $distance == 0 ) {
			// 画面内に収まっている
			$obj.child[$i * 2 + 0].disp = 0
			$obj.child[$i * 2 + 1].disp = 0
		}
		elseif( $disp_l < $distance )
		{
			// 画面外(左)
			//$obj.child[$i * 2 + 0].disp = 1
			$obj.child[$i * 2 + 1].disp = 0
		}
		elseif( $distance < $disp_r )
		{
			// 画面外(右)
			$obj.child[$i * 2 + 0].disp = 0
			$obj.child[$i * 2 + 1].disp = 1
		}
		else
		{
			// 画面内に収まっている
			$obj.child[$i * 2 + 0].disp = 0
			$obj.child[$i * 2 + 1].disp = 0
		}
		
		$obj.child[$i * 2 + 0].y = $$get_lane_y($$get_now_lane($i))
		$obj.child[$i * 2 + 1].y = $obj.child[$i * 2 + 0].y
	}
}

//---------------------------------------------------------------------------
// キャラ情報を作成する
//---------------------------------------------------------------------------
command $$create_chara_info(property $obj : object)
{
	property $i
	
	$obj.disp = 1
	$obj.layer = <URACE_LAYER_UI> - 1
	$obj.child.resize($entry_uma_num)
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		// 背景
		$obj.child[$i].create(__mng_ur_race_order_bg, 1, 0, 24 + 47 * $i)
		$obj.child[$i].child.resize(5)
		$obj.child[$i].x_rep.resize(1)
		$obj.child[$i].f.resize(1)
		$obj.child[$i].f[0] = $i
		
		switch( $i ) {
		case($player_index)		$obj.child[$i].patno = 0		// プレイヤー
		case($rival_index)		$obj.child[$i].patno = 1		// ライバル
		default					$obj.child[$i].patno = 2		// モブ
		}
		
		// 順位
		$obj.child[$i].child[0].create(__mng_ur_race_order_number, 1, 23, 8)
		$obj.child[$i].child[0].patno = $i
		
		// キャラアイコン
		$obj.child[$i].child[1].create(__mng_ur_race_order_chara, 1, 93, 12)
		$obj.child[$i].child[1].patno = $$get_db_owner_image_no($$get_entry_owner_id($i)) - 1
		
		// ＵＭＡアイコン
		$obj.child[$i].child[2].create(__mng_ur_race_order_uma_image, 1, 240, 25)
		
		// 残ＵＭＡ数（十の位）
		$obj.child[$i].child[3].create_number(__mng_ur_race_order_uma_number, 1, 291, 36)
		$obj.child[$i].child[3].set_number_param(1, 1, 0, 0, 0, 0)
		$obj.child[$i].child[3].set_number($$get_left_uma($i) / 10)
		
		// 残ＵＭＡ数（一の位）
		$obj.child[$i].child[4].create_number(__mng_ur_race_order_uma_number, 1, 313, 38)
		$obj.child[$i].child[4].set_number_param(1, 1, 0, 0, 0, 0)
		$obj.child[$i].child[4].set_number($$get_left_uma($i) % 10)
	}
}

command $$show_chara_info(property $obj : object)
{
	property $i
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$obj.child[$i].x_rep_eve[0].set(0, 500, 1500 + $i * 50, 2)
	}
}

//---------------------------------------------------------------------------
// キャラ情報を更新する
//---------------------------------------------------------------------------
command $$update_chara_info(property $obj : object)
{
	property $i
	property $trigger
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		if( $$get_order($i) == 0 ) {
			continue
		}
		
		if( $obj.child[$i].f[0] != $$get_order($i) )
		{
			if( $$get_order($i) == 1 )
			{
				$obj.child[$i].set_scale(1000, 1000)
				$obj.child[$i].y_eve.set(24, 250, 0, 2)
			}
			else
			{
				$obj.child[$i].set_scale(830, 830)
				$obj.child[$i].y_eve.set(73 + 41 * ($$get_order($i) - 2), 250, 0, 2)
			}
			
			$obj.child[$i].f[0] = $$get_order($i)
			$obj.child[$i].child[0].patno = $$get_order($i) - 1
		}
		
		$obj.child[$i].child[3].set_number($$get_left_uma($i) / 10)
		$obj.child[$i].child[4].set_number($$get_left_uma($i) % 10)
		
	/*
		if( pcmch[$i].check == 1 ) {
			continue
		}
		
		$trigger = $$get_owner_voice_trigger($i)
		if( $obj.child[$i].f[0] != $trigger )
		{
			$obj.child[$i].f[0] = $trigger
			
			if( $trigger != 0 ) {
				$$show_cheer_window($obj, $i, $$get_cheer_text($i, $$get_entry_owner_id($i), $trigger))
			}
		}
	*/
	}
}


command $$get_cheer_text(property $lane_index, property $owner_id, property $voice_type) : str
{
	property $text : str
	property $koe_no
	property $chara_no
	
	$text = "テストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテストテスト"
	
	if( $owner_id > @オーナー_淡雪陽彩 ) {
		$owner_id = ($owner_id - 2) % 3 + 2
	}
	
	switch( $owner_id ) {
	case(@オーナー_速川麦)
		
		$chara_no = 0
		
		switch( $voice_type ) {
		case(<OWNER_VOICE_TRIGGER_READY>)		$text = "麦：スタート前"
		case(<OWNER_VOICE_TRIGGER_START>)		$text = "麦：スタート"
		case(<OWNER_VOICE_TRIGGER_GOAL>)		$text = "麦：ゴール"
		case(<OWNER_VOICE_TRIGGER_TRAP_SUCCESS>)		$text = "麦：アクション成功"
		case(<OWNER_VOICE_TRIGGER_TRAP_FAILURE>)		$text = "麦：アクション失敗"
		case(<OWNER_VOICE_TRIGGER_SKILL>)		$text = "麦：スキル"
		}
	case(@オーナー_辻倉朱比華)
		
		$chara_no = 1
		
		switch( $voice_type ) {
		case(<OWNER_VOICE_TRIGGER_READY>)		$koe_no = 018501742		$text = "がんばって"
		case(<OWNER_VOICE_TRIGGER_START>)		$koe_no = 018501741		$text = "いってらっしゃい"
		case(<OWNER_VOICE_TRIGGER_GOAL>)		$koe_no = 018501750		$text = "ふっ……"
		case(<OWNER_VOICE_TRIGGER_TRAP_SUCCESS>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 018501748		$text = "その調子で頑張って"
			case(1)		$koe_no = 018501749		$text = "やれば出来る子"
			case(2)		$koe_no = 018501750		$text = "ふっ……"
			}
		case(<OWNER_VOICE_TRIGGER_TRAP_FAILURE>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 018501744		$text = "えっ！"
			case(1)		$koe_no = 018501745		$text = "まだ、平気だし"
			case(2)		$koe_no = 018501746		$text = "あっ……"
			}
		case(<OWNER_VOICE_TRIGGER_SKILL>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 513400328		$text = "これで……うんっ！"
			case(1)		$koe_no = 513400329		$text = "鳴瀬の渦潮！"
			case(2)		$koe_no = 513400405		$text = "見切ってるし！"
			}
		case(<OWNER_VOICE_TRIGGER_UNICORN>)
						$koe_no = 0				$text = "何かこっちを見ていた気がする"
		}
	case(@オーナー_総羽愛乃)
		
		$chara_no = 2
		
		switch( $voice_type ) {
		case(<OWNER_VOICE_TRIGGER_READY>)		$koe_no = 018501756		$text = "さーて、やっちゃいましょうか～"
		case(<OWNER_VOICE_TRIGGER_START>)		$koe_no = 018501758		$text = "イナリ、出番よ！"
		case(<OWNER_VOICE_TRIGGER_GOAL>)		$koe_no = 018501770		$text = "イナリの勝ちー"
		case(<OWNER_VOICE_TRIGGER_TRAP_SUCCESS>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 018501766		$text = "もうちょっと手応えが欲しいわねぇ"
			case(1)		$koe_no = 018501767		$text = "もう後がないわよ？"
			case(2)		$koe_no = 018501768		$text = "これでおしまいよ"
			}
		case(<OWNER_VOICE_TRIGGER_TRAP_FAILURE>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 018501760		$text = "なかなかやるじゃない"
			case(1)		$koe_no = 018501761		$text = "ま、まだ本気じゃないわよ！"
			case(2)		$koe_no = 018501762		$text = "うそっ……"
			}
		case(<OWNER_VOICE_TRIGGER_SKILL>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 513400332		$text = "秘技！　胡蝶の夢！"
			case(1)		$koe_no = 513400333		$text = "ほら、やり直しなさい！"
			case(2)		$koe_no = 513400407		$text = "油断大敵よ！"
			}
		case(<OWNER_VOICE_TRIGGER_UNICORN>)
						$koe_no = 0				$text = "何かこっちを見ていた気がする"
		}
		
	case(@オーナー_淡雪陽彩)
		
		$chara_no = 3
		
		switch( $voice_type ) {
		case(<OWNER_VOICE_TRIGGER_READY>)		$koe_no = 018501780		$text = "それじゃ、君からいこっか"
		case(<OWNER_VOICE_TRIGGER_START>)		$koe_no = 018501782		$text = "最後は君、がんばれー"
		case(<OWNER_VOICE_TRIGGER_GOAL>)		$koe_no = 018501792		$text = "ヨーソローーーー"
		case(<OWNER_VOICE_TRIGGER_TRAP_SUCCESS>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 018501788		$text = "さすが私の島モン"
			case(1)		$koe_no = 018501789		$text = "これは才能かな？"
			case(2)		$koe_no = 018501790		$text = "まさに冒険だね"
			}
		case(<OWNER_VOICE_TRIGGER_TRAP_FAILURE>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 018501784		$text = "ああっ！"
			case(1)		$koe_no = 018501785		$text = "負けちゃった……"
			case(2)		$koe_no = 018501786		$text = "みんな、頑張ったね"
			}
		case(<OWNER_VOICE_TRIGGER_SKILL>)
			switch( math.rand(0, 2) ) {
			case(0)		$koe_no = 513400336		$text = "必殺！　テトロドキドキーン！"
			case(1)		$koe_no = 513400337		$text = "しびれちゃえー！"
			case(2)		$koe_no = 513400411		$text = "まだまだ余裕だよ！"
			}
		case(<OWNER_VOICE_TRIGGER_UNICORN>)
						$koe_no = 0				$text = "何かこっちを見ていた気がする"
		}
	}
	
	if( $text.len > 27 * 2 ) {
		$text = $text.left_len(27 * 2)
	}
	
	if( $chara_no != 0 && $koe_no != 0 ) {
		pcmch[$lane_index].play(koe_no = $koe_no, volume_type = 1, chara_no = $chara_no)
		;exkoe($koe_no, $chara_no)
	}
	
	return ($text)
}

//---------------------------------------------------------------------------
// 応援ウィンドウを表示する
//---------------------------------------------------------------------------
command $$show_cheer_window(property $obj : object, property $index, property $message : str)
{
	$obj.child[$index].child[1].set_string($message)
	$obj.child[$index].y_rep[0] = 20
	$obj.child[$index].y_rep_eve[0].set(0, 250, 0, 2)
	$obj.child[$index].tr = 0
	$obj.child[$index].tr_eve.set(255, 250, 0, 2)
	$obj.child[$index].tr_rep[0] = 255
	$obj.child[$index].tr_rep_eve[0].set(0, 500, 3000, 0)
}

//---------------------------------------------------------------------------
// 一時停止メニュー
//---------------------------------------------------------------------------
command $$pause(property $stage : stage)
{
	property $modal_select_btn
	
	// 時間を停止する
	script.set_time_stop_flag(1)
	
	// ポーズメニューを作成する
	// フィルター
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].create("__mng_ur_pause_filter", 1)
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].layer = <URACE_LAYER_MODAL>
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].child.resize(2)
	
	// 背景
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].child[0].create("__mng_ur_pause_bg", 1, 218, 199)
	
	// タグ
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].child[1].create("__mng_ur_pause_tag", 1)
	
	// 再開する／ウィンドウを消すボタン
	$$create_ui_button($stage.object[<URACE_BTN_MODAL_WINDOW_OK>], "__mng_ur_pause_resume_btn", 588, 745, <URACE_BTN_MODAL_WINDOW_OK>, <URACE_BTN_GROUP_MODAL>, 1)
	$$create_ui_button($stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>], "__mng_ur_pause_erase_btn", 1002, 745, <URACE_BTN_MODAL_WINDOW_CANCEL>, <URACE_BTN_GROUP_MODAL>, 1)
	$stage.object[<URACE_BTN_MODAL_WINDOW_OK>].layer = <URACE_LAYER_MODAL>
	$stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>].layer = <URACE_LAYER_MODAL>
	
	// 入力制御を開始する
	$$input_start(front, <URACE_BTN_GROUP_MODAL>)
	
	// ポーズメニューの入力開始
	while(1)
	{
		// 入力制御を更新する
		$modal_select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
		
		// ポーズメニューが非表示の時は何らかのボタンを押すとポーズメニューを表示する
		if( $stage.object[<URACE_OBJ_MODAL_WINDOW>].disp == 0 )
		{
			if( input.decide.on_down || input.cancel.on_down )
			{
				$stage.object[<URACE_OBJ_MODAL_WINDOW>].disp = 1
				$stage.object[<URACE_BTN_MODAL_WINDOW_OK>].disp = 1
				$stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>].disp = 1
				
				// 入力制御を再開始する
				$$input_start(front, <URACE_BTN_GROUP_MODAL>)
				
				continue
			}
		}
		
		// キャンセルは戻るボタンとして処理する
		if( $modal_select_btn == -1 )
		{
			$modal_select_btn = <URACE_BTN_MODAL_WINDOW_OK>
		}
		
		// 戻るボタンが押された場合は終了する
		if( $modal_select_btn == <URACE_BTN_MODAL_WINDOW_OK> )
		{
			break
		}
		
		// ウィンドウを消すボタンが押された場合はポーズメニューを非表示にする
		if( $modal_select_btn == <URACE_BTN_MODAL_WINDOW_CANCEL> )
		{
			$stage.object[<URACE_OBJ_MODAL_WINDOW>].disp = 0
			$stage.object[<URACE_BTN_MODAL_WINDOW_OK>].disp = 0
			$stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>].disp = 0
		}
		
		// 何らかのボタンが押されている場合
		if( $modal_select_btn != -2 )
		{
			// 入力制御を再開始する
			$$input_start(front, <URACE_BTN_GROUP_MODAL>)
		}
		
		input.next
		disp
	}
	
	// ポーズメニューを非表示にする
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].init
	$stage.object[<URACE_BTN_MODAL_WINDOW_OK>].init
	$stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>].init
	
	// 時間の停止を解除する
	script.set_time_stop_flag(0)
}

//---------------------------------------------------------------------------
// スキップメニュー
//---------------------------------------------------------------------------
command $$skip(property $stage : stage)
{
	property $modal_select_btn
	
	// 時間を停止する
	script.set_time_stop_flag(1)
	
	// スキップメニューを作成する
	// フィルター
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].create(_mng_ur_race_skip_filter, 1)
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].layer = <URACE_LAYER_MODAL>
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].child.resize(1)
	// 背景
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].child[0].create(_mng_ur_race_skip_bg, 1, 0, 300)
	// スキップする／スキップしないボタン
	$$create_ui_button($stage.object[<URACE_BTN_MODAL_WINDOW_OK>], _mng_ur_race_skip_ok_btn, 626, 528, <URACE_BTN_MODAL_WINDOW_OK>, <URACE_BTN_GROUP_MODAL>, 1)
	$$create_ui_button($stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>], _mng_ur_race_skip_cancel_btn, 1008, 528, <URACE_BTN_MODAL_WINDOW_CANCEL>, <URACE_BTN_GROUP_MODAL>, 1)
	$stage.object[<URACE_BTN_MODAL_WINDOW_OK>].layer = <URACE_LAYER_MODAL>
	$stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>].layer = <URACE_LAYER_MODAL>
	
	// 入力制御を開始する
	$$input_start(front, <URACE_BTN_GROUP_MODAL>)
	
	// ポーズメニューの入力開始
	while(1)
	{
		// 入力制御を更新する
		$modal_select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
		
		// キャンセルはスキップしないボタンとして処理する
		if( $modal_select_btn == -1 )
		{
			$modal_select_btn = <URACE_BTN_MODAL_WINDOW_CANCEL>
		}
		
		// スキップしないボタンが押された場合は終了する
		if( $modal_select_btn == <URACE_BTN_MODAL_WINDOW_CANCEL> )
		{
			break
		}
		
		// スキップするボタンが押された場合は終了する
		if( $modal_select_btn == <URACE_BTN_MODAL_WINDOW_OK> )
		{
			break
		}
		
		// 何らかのボタンが押されている場合
		if( $modal_select_btn != -2 )
		{
			// 入力制御を再開始する
			$$input_start(front, <URACE_BTN_GROUP_MODAL>)
		}
		
		input.next
		disp
	}
	
	// スキップメニューを非表示にする
	$stage.object[<URACE_OBJ_MODAL_WINDOW>].init
	$stage.object[<URACE_BTN_MODAL_WINDOW_OK>].init
	$stage.object[<URACE_BTN_MODAL_WINDOW_CANCEL>].init
	
	// 時間の停止を解除する
	script.set_time_stop_flag(0)
	
	// スキップする場合は1を戻す
	if( $modal_select_btn == <URACE_BTN_MODAL_WINDOW_OK> ) {
		return (1)
	}
	
	return (0)
}



















//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト番号
	#replace	<OBJ_START_EFFECT>			50		// スタート演出
	
	// テスト
	#property	$ultimate
	
#inc_end

//---------------------------------------------------------------------------
// レース開始演出オブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_start_object(property $obj : object)
{
	$$set_child_object($obj, 3)
	$obj.layer = <URACE_LAYER_ALL_EFFECT>
	
	// 空を作成する
	$obj.child[0].create(bg999_01)
	$obj.child[0].set_scale(1500, 1500)
	$obj.child[0].y = 0
	$obj.child[0].y_eve.set(-540, 4000, 0, 2)
	$obj.child[0].disp = 1
	$obj.child[0].tr_eve.set(0, 500, 5000, 0)
	
	// ロゴ背景を作成する
	$obj.child[1].create(_mng_ur_race_logo_bg)
	$obj.child[1].set_pos(<SCREEN_CENTER_X>, <SCREEN_CENTER_Y>)
	$obj.child[1].set_center($obj.child[1].get_size_x / 2, $obj.child[1].get_size_y / 2)
	$obj.child[1].set_scale(10, 1000)
	$obj.child[1].scale_x_eve.set(1000, 1000, 1500, 2)
	$obj.child[1].tr_rep.resize(1)
	$obj.child[1].tr_rep[0] = 255
	$obj.child[1].tr = 0
	$obj.child[1].tr_eve.set(255, 1000, 1500, 0)
	$obj.child[1].tr_rep_eve[0].set(0, 500, 4500, 0)
	$obj.child[1].disp = 1
	
	// ロゴを作成する
	$obj.child[2].create(_mng_ur_race_logo + math.tostr_zero($$get_entry_race_id, 2))
	$obj.child[2].set_pos(<SCREEN_CENTER_X>, <SCREEN_CENTER_Y>)
	$obj.child[2].set_center($obj.child[2].get_size_x / 2, $obj.child[2].get_size_y / 2)
	$obj.child[2].set_scale(1500, 1500)
	$obj.child[2].scale_x_eve.set(1000, 1000, 1500, 2)
	$obj.child[2].scale_y_eve.set(1000, 1000, 1500, 2)
	$obj.child[2].tr_rep.resize(1)
	$obj.child[2].tr_rep[0] = 255
	$obj.child[2].tr = 0
	$obj.child[2].tr_eve.set(255, 1000, 1500, 0)
	$obj.child[2].tr_rep_eve[0].set(0, 500, 4500, 0)
	$obj.child[2].disp = 1
}

//---------------------------------------------------------------------------
// レース開始演出
//---------------------------------------------------------------------------
command $$start_effect(property $obj : object)
{
	property $i
	property $list : intlist
	property $debug_skip
	
	// 演出スキップ用
;	$debug_skip = 1
	
	// ファンファーレ
	if( $$get_entry_race_id == 15 ) {
		pcmch[0].play("_urace_se_fanfare02")		// ラストレース
	} else {
		pcmch[0].play("_urace_se_fanfare01")		// 通常レース
	}
	
	// ロゴ表示
	input.clear
	while(1)
	{
		// デバッグモードを更新する(レース中)
		if( $$check_debug_mode_enable ) {
			$$update_urace_race_debug_mode(front.object[<URACE_OBJ_DEBUG>])
		}
		
		if( $debug_skip == 1 ) {
			break
		}
		
		// 演出が終了した or 入力がある場合は終了する
		if( input.decide.on_down == 1 || $obj.child[0].all_eve.check == 0 )
		{
			break
		}
		
		input.next
		disp
	}
	
	// 演出アニメーション終了
	$obj.child[0].all_eve.end
	$obj.child[1].all_eve.end
	$obj.child[2].all_eve.end
	pcmch[0].stop(1000)
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$$ground_disp(front.object[<URACE_OBJ_UMA_TIP> + $i].child[7], $i)
	}
	
	if( $debug_skip == 0 )
	{
		$list.resize($entry_uma_num)
		
		switch( math.rand(0, 3) ) {
		case(0)		$list[0] = 0	$list[1] = 2
					if( 3 <= $entry_uma_num ) { $list[2] = 3 }
					if( 4 <= $entry_uma_num ) { $list[3] = 1 }
		case(1)		$list[0] = 1	$list[1] = 3
					if( 3 <= $entry_uma_num ) { $list[2] = 2 }
					if( 4 <= $entry_uma_num ) { $list[3] = 0 }
		case(2)		$list[0] = 2	$list[1] = 0
					if( 3 <= $entry_uma_num ) { $list[2] = 1 }
					if( 4 <= $entry_uma_num ) { $list[3] = 3 }
		case(3)		$list[0] = 3	$list[1] = 1
					if( 3 <= $entry_uma_num ) { $list[2] = 0 }
					if( 4 <= $entry_uma_num ) { $list[3] = 2 }
		}
		
		@mng_counter.start
		
		while(1)
		{
			if( @mng_counter.get > 150 ) {
				$$set_entry_owner_voice_trigger($list[0], <OWNER_VOICE_TRIGGER_READY>)
			}
			if( @mng_counter.get > 300 ) {
				$$set_entry_owner_voice_trigger($list[1], <OWNER_VOICE_TRIGGER_READY>)
			}
			if( @mng_counter.get > 450 && 3 <= $entry_uma_num ) {
				$$set_entry_owner_voice_trigger($list[2], <OWNER_VOICE_TRIGGER_READY>)
			}
			if( @mng_counter.get > 600 && 4 <= $entry_uma_num ) {
				$$set_entry_owner_voice_trigger($list[3], <OWNER_VOICE_TRIGGER_READY>)
			}
			
;			$$update_cheer_window(front.object[<URACE_OBJ_CHEER_WINDOW>])
			
			if( @mng_counter.get > 1500 ) {
				break
			}
			input.next
			disp
		}
	
		timewait_key(1000)
	}
	
	// 応援ウィンドウ
	for( $i = 0, $i < $entry_uma_num, $i += 1 ) {
		$$set_entry_owner_voice_trigger($i, <OWNER_VOICE_TRIGGER_READY>)
	}
	
	// チュートリアル／レース
	/*
	if( @ＵＭＡレース_チュートリアル進行度 == 3 )
	{
		front.object[<URACE_OBJ_HELP>].create(_mng_ur_race_help, 1, 192, 72, 0)
		front.object[<URACE_OBJ_HELP>].layer = <URACE_LAYER_MODAL>
		front.object[<URACE_OBJ_HELP>].y_rep.resize(1)
		front.object[<URACE_OBJ_HELP>].tr = 0
		front.object[<URACE_OBJ_HELP>].tr_eve.set(255, 500, 0, 2)
		front.object[<URACE_OBJ_HELP>].y_rep[0] = 50
		front.object[<URACE_OBJ_HELP>].y_rep_eve[0].set(0, 500, 0, 2)
		R
		front.object[<URACE_OBJ_HELP>].create(_mng_ur_race_help, 1, 192, 72, 1)
		front.object[<URACE_OBJ_HELP>].layer = <URACE_LAYER_MODAL>
		front.object[<URACE_OBJ_HELP>].y_rep.resize(1)
		front.object[<URACE_OBJ_HELP>].tr = 0
		front.object[<URACE_OBJ_HELP>].tr_eve.set(255, 500, 0, 2)
		front.object[<URACE_OBJ_HELP>].y_rep[0] = 50
		front.object[<URACE_OBJ_HELP>].y_rep_eve[0].set(0, 500, 0, 2)
		R
		front.object[<URACE_OBJ_HELP>].create(_mng_ur_race_help, 1, 192, 72, 2)
		front.object[<URACE_OBJ_HELP>].layer = <URACE_LAYER_MODAL>
		front.object[<URACE_OBJ_HELP>].y_rep.resize(1)
		front.object[<URACE_OBJ_HELP>].tr = 0
		front.object[<URACE_OBJ_HELP>].tr_eve.set(255, 500, 0, 2)
		front.object[<URACE_OBJ_HELP>].y_rep[0] = 50
		front.object[<URACE_OBJ_HELP>].y_rep_eve[0].set(0, 500, 0, 2)
		R
		front.object[<URACE_OBJ_HELP>].tr_eve.set(0, 500, 0, 2)
		front.object[<URACE_OBJ_HELP>].y_rep_eve[0].set(50, 500, 0, 2)
		front.object[<URACE_OBJ_HELP>].y_rep_eve[0].wait
		front.object[<URACE_OBJ_HELP>].init
	}
	*/
	
	// スタートカウントダウンを作成する
	$obj.child[0].create(__mng_ur_effect_start_text)
	$obj.child[0].set_pos(<SCREEN_CENTER_X>, <SCREEN_CENTER_Y>)
	$obj.child[0].set_center($obj.child[0].get_size_x / 2, $obj.child[0].get_size_y / 2)
	$obj.child[0].set_scale(1500, 1500)
	$obj.child[0].scale_x_eve.set(1000, 500, 0, 2)
	$obj.child[0].scale_y_eve.set(1000, 500, 0, 2)
	$obj.child[0].disp = 1
	
	@mng_counter.start
	
	// スタートカウントダウン
	input.clear
	while(1)
	{
		// deb
	// ミニゲームで使用するカウンターを更新する
	$$update_mng_counter
		for( $i = 0, $i < $entry_uma_num, $i += 1 )
		{
			$$update_running_uma_action($i)
		}
		// deb
		
		// デバッグモードを更新する(レース中)
		if( $$check_debug_mode_enable ) {
			$$update_urace_race_debug_mode(front.object[<URACE_OBJ_DEBUG>])
		}
		
		if( $debug_skip == 1 )
		{
			$obj.child[0].tr = 0
			if( input.decide.on_down == 1 || input.cancel.on_down == 1 )
			{
				break
			}
			input.next
			disp
			continue
		}
		
		if( @mng_counter.get > 1000 && $obj.child[0].patno == 0 )
		{
			$obj.child[0].patno = 1
			$obj.child[0].set_scale(1500, 1500)
			$obj.child[0].scale_x_eve.set(1000, 500, 0, 2)
			$obj.child[0].scale_y_eve.set(1000, 500, 0, 2)
		}
		elseif( @mng_counter.get > 2000 && $obj.child[0].patno == 1 )
		{
			$obj.child[0].patno = 2
			$obj.child[0].set_scale(1500, 1500)
			$obj.child[0].scale_x_eve.set(1000, 500, 0, 2)
			$obj.child[0].scale_y_eve.set(1000, 500, 0, 2)
		}
		elseif( @mng_counter.get > 3000 && $obj.child[0].patno == 2 )
		{
			$obj.child[0].patno = 3
			$obj.child[0].set_scale(1000, 1000)
			$obj.child[0].scale_x_eve.set(1500, 500, 0, 2)
			$obj.child[0].scale_y_eve.set(1500, 500, 0, 2)
			$obj.child[0].tr_eve.set(0, 250, 250, 2)
			break
		}
		
		input.next
		disp
	}
	
	@mng_counter.reset
	
	@bgm(bgm43a)
	
	// 各ＵＭＡの状態をスタートに変更する
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$$set_running_uma_action_state($i, <RUNNING_UMA_ACTION_STATE_RUN>)
	}
	$$show_chara_info(front.object[<URACE_OBJ_CHEER_WINDOW>])
}

command $$ground_disp(property $obj : object, property $index)
{
	property $owner_id
	property $uma_index
	property $pos_y
	property $text : str
	
	$owner_id = $$get_entry_owner_id($index)
	$uma_index = $$get_entry_uma_index($index)
	
	$text = $$get_urace_race_ground_type_text($$get_db_race_ground_type($$get_entry_race_id))
	
	//switch( $$get_uma_ground_type($owner_id, $uma_index, $$get_db_race_ground_type($$get_entry_race_id)) ) {
	switch( $$get_running_uma_ground_type($index, $$get_db_race_ground_type($$get_entry_race_id)) ) {
	case(<UMA_GROUND_TYPE_C>)		$text += "×"		$pos_y = -50
	case(<UMA_GROUND_TYPE_B>)		$text += "△"		$pos_y = 20
	case(<UMA_GROUND_TYPE_A>)		$text += "○"		$pos_y = 50
	}
	
	$obj.child[0].set_string($text)
	
	$obj.tr = 0
	$obj.tr_eve.set(255, 250, 0, 0)
	
	$obj.y_rep[0] = $pos_y
	$obj.y_rep_eve[0].set(0, 250, 0, 0)
	
	$obj.tr_rep[0] = 255
	$obj.tr_rep_eve[0].set(0, 250, 3000, 0)
}


command $$skill_cutin(property $lane_index, property $skill_id)
{
	property $i
	property $skill_name : str
	property $x
	property $y
	
	@mng_counter.stop
	
	front.object[<URACE_OBJ_BG_FILTER>].create_rect(0, 0, 1920, 1080, 0, 0, 0, 228, 1)
	front.object[<URACE_OBJ_BG_FILTER>].layer = <URACE_LAYER_TRAP> + 1
	front.object[<URACE_OBJ_BG_FILTER>].child.resize(3)
	
	front.object[<URACE_OBJ_BG_FILTER>].child[0].create(ef_line03, 1)
	$$set_screen_scale(front.object[<URACE_OBJ_BG_FILTER>].child[0])
	front.object[<URACE_OBJ_BG_FILTER>].child[0].blend = 4
	front.object[<URACE_OBJ_BG_FILTER>].child[0].tr = 64
	front.object[<URACE_OBJ_BG_FILTER>].child[0].patno_eve.loop(0, 29, 500, 0, 0)
	
	front.object[<URACE_OBJ_BG_FILTER>].child[1].create("_mng_ur_uma_image" + math.tostr_zero($$get_running_uma_id($lane_index), 2), 1)
	front.object[<URACE_OBJ_BG_FILTER>].child[1].tr = 0
	front.object[<URACE_OBJ_BG_FILTER>].child[1].x = 0 - 500
	
	front.object[<URACE_OBJ_BG_FILTER>].child[2].create(ef_syougou_bg2, 1, 960, 200)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].child.resize(1)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].tr = 0
	front.object[<URACE_OBJ_BG_FILTER>].child[2].y_rep.resize(1)
	
	$skill_name = $$get_db_skill_name($skill_id)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].child[0].create_string($skill_name, 1, -$skill_name.len / 2 / 2 * 40, -16)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].child[0].set_string_param(40, 1, 5, 100, 0, 1, 2, 1)
	
	front.object[<URACE_OBJ_BG_FILTER>].child[1].x_eve.set(0, 500, 0, 2)
	front.object[<URACE_OBJ_BG_FILTER>].child[1].tr_eve.set(255, 500, 0, 2)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].y_rep[0] = 200
	front.object[<URACE_OBJ_BG_FILTER>].child[2].y_rep_eve[0].set(0, 500, 0, 2)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].tr_eve.set(255, 500, 0, 2)
	$x = front.object[<URACE_OBJ_UMA_TIP> + $lane_index].x
	$y = front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_wave.disp = 0
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].x_eve.set(960, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y_eve.set(540, 500, 0, 2)
	front.object[<URACE_OBJ_BG>].center_rep_x = $camera_x + 960
	front.object[<URACE_OBJ_BG>].scale_x_eve.set(2000, 500, 0, 2)
	front.object[<URACE_OBJ_BG>].scale_y_eve.set(2000, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].scale_x_eve.set(2000, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].scale_y_eve.set(2000, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_run_scatter.disp = 0
	if( front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_wave.child.get_size )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.frame_action_ch[0].end
	}
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		if( $i != $lane_index ) {
			front.object[<URACE_OBJ_UMA_TIP> + $i].disp = 0
		}
	}
	
	timewait_key(1500)
	
	front.object[<URACE_OBJ_BG_FILTER>].child[1].x_eve.set(-500, 500, 0, 2)
	front.object[<URACE_OBJ_BG_FILTER>].child[1].tr_eve.set(0, 500, 0, 2)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].y_rep_eve[0].set(-200, 500, 0, 2)
	front.object[<URACE_OBJ_BG_FILTER>].child[2].tr_eve.set(0, 500, 0, 2)
	front.object[<URACE_OBJ_BG>].scale_x_eve.set(1000, 500, 0, 2)
	front.object[<URACE_OBJ_BG>].scale_y_eve.set(1000, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].scale_x_eve.set(1000, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].scale_y_eve.set(1000, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].x_eve.set($x, 500, 0, 2)
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].y_eve.set($y, 500, 0, 2)
	
	timewait_key(500)
	@mng_counter.resume
	
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_run_scatter.disp = 1
	front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_wave.disp = 1
	if( front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_wave.child.get_size )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.frame_action_ch[0].start(-1, "$$fa_swim_uma_tip")
	}
	front.object[<URACE_OBJ_BG_FILTER>].init
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		if( $i != $lane_index ) {
			front.object[<URACE_OBJ_UMA_TIP> + $i].disp = 1
		}
	}
	
	$ultimate = 0
}

command $$update_skill
{
	property $i
	property $active_skill_id
	
	for( $i = 0, $i < $entry_uma_num, $i += 1 )
	{
		$active_skill_id = $$get_running_uma_active_skill_id($i)
		
		if( $uma_active_skill_id[$i] == $active_skill_id ) {
			continue
		}
		
		if( $active_skill_id == 0 )
		{
			$$stop_skill_effect($i)
		}
		else
		{
;			if( $active_skill_id != @スキル_加速 ) {
;				$$skill_cutin($i, $active_skill_id)
;			}
			
			$$skill_disp(front.object[<URACE_OBJ_UMA_TIP> + $i].cd_skill, $active_skill_id)
			$$play_skill_effect($i)
		}
		
		$uma_active_skill_id[$i] = $active_skill_id
	}
}

command $$skill_disp(property $obj : object, property $skill_id)
{
	$obj.patno = 3
	$obj.child[0].set_string($$get_db_skill_name($skill_id))
	
	$obj.y_rep[0] = 20
	$obj.y_rep_eve[0].set(0, 150, 0, 0)
	$obj.tr = 0
	$obj.tr_eve.set(255, 150, 0, 0)
	$obj.tr_rep[0] = 255
	$obj.tr_rep_eve[0].set(0, 150, 1500, 0)
}

command $$create_util_effect(property $obj : object)
{
	$obj.cd_chara_util_ef_front.disp = 1
	$obj.cd_chara_util_ef_front.child.resize(25)
	
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[0], <URACE_EFFECT_SWEAT>, 50, -80, 0)			// 汗（スタミナ切れ）エフェクト
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[1], <URACE_EFFECT_CRASH_STAR_S>, 0, -20, 0)		// 衝突(星・小)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[2], <URACE_EFFECT_CRASH_STAR_L>, 0, -40, 0)		// 衝突(星・大)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[3], <URACE_EFFECT_ENV_BOUND_GRASS>, 80, 0, 0)	// 飛び散る草
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[4], <URACE_EFFECT_ENV_BOUND_LEAF>, 0, 0, 0)		// 飛び散る葉っぱ
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[5], <URACE_EFFECT_ENV_BOUND_WATER>, 0, 0, 0)	// 飛び散る水
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[6], <URACE_EFFECT_ENV_DROP_WATER>, 0, 0, 0)		// 水への着地
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[7], <URACE_EFFECT_WIND_SLASH_TARGET>, 0, 0, 0)	// 風の斬撃
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[8], <URACE_EFFECT_BLOCK>, 0, 0, 0)				// ブロック
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[9], <URACE_EFFECT_PRESSURE_TARGET>, 0, -80, 0)	// プレッシャー(受ける側)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[10], <URACE_EFFECT_CRASH_S_LOOP>, 0, -80, 0)	// 衝突(小・ループ)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[11], <URACE_EFFECT_EMERGENCY_BRAKE>, 0, 0, 0)	// 急ブレーキ
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[12], <URACE_EFFECT_SKILL_POWER_LV1>, 0, 0, 0)	// スキル発動(コモン)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[13], <URACE_EFFECT_SKILL_POWER_LV2>, 0, 0, 0)	// スキル発動(レア)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[14], <URACE_EFFECT_SKILL_POWER_LV3>, 0, 0, 0)	// スキル発動(ユニーク)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[15], <URACE_EFFECT_SKILL_POWER_LV4>, 0, 0, 0)	// スキル発動(アルティメット)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[16], <URACE_EFFECT_OBSTACLE_TARGET>, 0, 0, 0)	// 抑え込み(受ける側)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[17], <URACE_EFFECT_PULL_OUT_TARGET>, 0, 0, 0)	// 引っこ抜き(受ける側)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[18], <URACE_EFFECT_WIND_REV>, 200, 0, 0)		// 逆風
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[19], <URACE_EFFECT_SHIRIKODAMA_TARGET>, 0, 0, 0)// 尻子玉(受ける側)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[20], <URACE_EFFECT_POP_FROZEN>, 0, -80, 0)		// 凍結
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[21], <URACE_EFFECT_POP_LIGHT>, 0, -80, 0)		// 御来光
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[22], <URACE_EFFECT_LAST_SPURT>, 0, -80, 0)		// ラストスパート
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[23], <URACE_EFFECT_BLOOD_STEEL_TARGET>, 0, 0, 0)// 吸血(受ける側)
	$$create_urace_effect($obj.cd_chara_util_ef_front.child[24], <URACE_EFFECT_GROUND_WEAK>, 0, 0, 0)		// 苦手地形
}

command $$create_screen_effect(property $obj : object)
{
	$obj.disp = 1
	$obj.layer = <URACE_LAYER_ALL_FILTER>
	$obj.child.resize(2)
	
	$$create_urace_effect($obj.child[0], <URACE_EFFECT_SCREEN_LIGHT_GLITTER>, 0, 540, 0)
	$$create_urace_effect($obj.child[1], <URACE_EFFECT_SCREEN_SNOWSTORM>, 0, 540, 0)
}

command $$create_skill_effect(property $obj : object, property $lane_index)
{
	/*
	property $i
	property $skill_id
	
	$obj.cd_chara_skill_ef_back.disp = 1
	$obj.cd_chara_skill_ef_back.child.resize(1)
	$obj.cd_chara_skill_ef_front.disp = 1
	$obj.cd_chara_skill_ef_front.child.resize(1)
	
	for( $i = 0, $i < 1, $i += 1 )
	{
		$skill_id = $$get_running_uma_skill_id($lane_index)
		
		if( $skill_id == 0 ) {
			continue
		}
		
		switch( $skill_id ) {
;		case(@スキル_加速)						$$create_urace_effect($obj.cd_chara_skill_ef_back.child[$i], <URACE_EFFECT_LINE_TRAIL_GREEN>, 0, 0, 0)
;		case(@スキル_加速／強化)				$$create_urace_effect($obj.cd_chara_skill_ef_back.child[$i], <URACE_EFFECT_LINE_TRAIL_YELLOW>, 0, 0, 0)
		case(@スキル_瞬足)						$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_FIRE_TRAIL>, 0, 0, 0)
		case(@スキル_瞬足／強化)				$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_FIRE_TRAIL_RAINBOW>, 0, 0, 0)
		case(@スキル_スタートダッシュ)			$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_FIRE_TRAIL_ONESHOT>, 0, 0, 0)
		case(@スキル_スタートダッシュ／強化)	$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_FIRE_TRAIL_RAINBOW_ONESHOT>, 0, 0, 0)
		case(@スキル_プレッシャー)				$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_PRESSURE>, 0, -80, 0)
		case(@スキル_プレッシャー／強化)		$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_PRESSURE>, 0, -80, 0)
		case(@スキル_抑え込み)					$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_OBSTACLE>, 0, 0, 0)
		case(@スキル_抑え込み／強化)			$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_OBSTACLE>, 0, 0, 0)
		case(@スキル_引っこ抜き)				$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_PULL_OUT>, 0, 0, 0)
		case(@スキル_引っこ抜き／強化)			$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_PULL_OUT>, 0, 0, 0)
		case(@スキル_危機回避)					$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_AVOID>, 100, 0, 0)
		case(@スキル_危機回避／強化)			$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_AVOID>, 100, 0, 0)
		case(@スキル_幸運の追い風)				$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_WIND>, -200, 0, 0)
		case(@スキル_ブラー現象)				;$$create_urace_effect($obj.cd_chara_skill_ef_back.child[$i], <URACE_EFFECT_LINE_TRAIL_GREEN>, 0, 0, 0)
		case(@スキル_つむじ風)					$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_WIND_SLASH>, 0, 0, 0)
		case(@スキル_闇からの強襲)				$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_POP_DARK_BALL>, 0, 0, 0)
		case(@スキル_尻子玉を抜く)				$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_SHIRIKODAMA>, 100, 0, 0)
		case(@スキル_吸血)						$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_BLOOD_STEEL>, 0, 0, 0)
		case(@スキル_津波)						$obj.cd_shadow.create("urace_race_tip_shadow", 0, -110, 20)
		case(@スキル_えり好み)					$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_POP_HEART>, 0, -80, 0)
		case(@スキル_水没)						$$create_urace_effect($obj.cd_dig, <URACE_EFFECT_ENV_DIG>, 0, 0, 0)
		case(@スキル_迅雷)						$$create_urace_effect($obj.cd_chara_skill_ef_back.child[$i], <URACE_EFFECT_LINE_TRAIL_RAINBOW>, 0, 0, 0)
			
		case(@スキル_宝石の力)					$$create_urace_effect($obj.cd_chara_skill_ef_front.child[$i], <URACE_EFFECT_RADIAL_INV_TRI_R>, 0, 0, 0)
		default									$$create_urace_effect($obj.cd_chara_skill_ef_back.child[$i], <URACE_EFFECT_LINE_TRAIL_GREEN>, 0, 0, 0)
		}
	}
	*/
}

command $$play_skill_effect(property $lane_index)
{
	/*
	property $i
	property $skill_id
	property $skill_index
	property $play_type
	property $target_play_type
	property $color_type
	property $screen_type
	property $hide_mode_type
	property $delay_time
	property $add_time
	
	$skill_id = $$get_running_uma_active_skill_id($lane_index)
	$skill_index = 0
	
	//2
	if( $skill_id == @スキル_加速 ) {
		return
	}
	
	$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_util_ef_front.child[15])
	
	switch( $skill_id ) {
	case(@スキル_加速)						$play_type = 1		$color_type = 1
	case(@スキル_加速／強化)				$play_type = 1		$color_type = 1
	case(@スキル_瞬足)						$play_type = 2		$color_type = 1
	case(@スキル_瞬足／強化)				$play_type = 2		$color_type = 1
	case(@スキル_幸運の追い風)				$play_type = 2		$color_type = 1
	case(@スキル_アンジュレーション)		$color_type = 1;$play_type = 1		$color_type = 1
	case(@スキル_つむじ風)					$play_type = 2		$target_play_type = 7		$add_time = 500
	case(@スキル_闇に紛れる)				$play_type = 2		$color_type = 2		$screen_type = 1
	case(@スキル_尻子玉を抜く)				$play_type = 2		$target_play_type = 19
	case(@スキル_吸血（調整中）)			$play_type = 2		$target_play_type = 23
	case(@スキル_潜水)						$hide_mode_type = 1
	case(@スキル_えり好み)					$play_type = 2		$color_type = 1
	case(@スキル_御来光)					$play_type = 3		$skill_index = 0	$screen_type = 3	$target_play_type = 21
	case(@スキル_吹雪)						$play_type = 3		$skill_index = 1	$screen_type = 1	$target_play_type = 20
	case(@スキル_潜行)						$hide_mode_type = 2
	case(@スキル_迅雷)						$play_type = 1		$color_type = 3
	}
	
	if( $play_type == 1 ) {
		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_skill_ef_back.child[$skill_index])
	}
	elseif( $play_type == 2 ) {
		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_skill_ef_front.child[$skill_index])
	}
	elseif( $play_type == 3 ) {
		$$play_urace_effect(front.object[<URACE_OBJ_SCREEN_EFFECT>].child[$skill_index])
	}
	
	if( $target_play_type )
	{
		$delay_time = $$get_db_skill_delay_time($skill_id)
		
		for( $i = 0, $i < $entry_uma_num, $i += 1 )
		{
			if( $$get_running_uma_active_skill_target($lane_index, $i) != -1 )
			{
				if( $$get_running_uma_block_flag($$get_running_uma_active_skill_target($lane_index, $i)) == 0 )
				{
					$$play_urace_effect_delay(front.object[<URACE_OBJ_UMA_TIP> + $$get_running_uma_active_skill_target($lane_index, $i)].cd_chara_util_ef_front.child[$target_play_type], $delay_time - $add_time)
				}
			}
		}
	}
	
	if( $color_type == 1 )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.bright = 128
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.color_add_r = 64
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.color_add_g = 64
	}
	elseif( $color_type == 2 )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.tr_eve.turn(0, 192, 1000, 0, 2)
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.dark = 255
	}
	elseif( $color_type == 3 )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.bright = 64
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.color_add_r = 64
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.color_add_g = 64
	}
	
	if( $screen_type == 1 )
	{
		front.object[<URACE_OBJ_BG_FILTER>].create_rect(0, 0, <SCREEN_WIDTH>, <SCREEN_HEIGHT>, 0, 0, 0, 192, 1)
	}
	elseif( $screen_type == 2 )
	{
		front.object[<URACE_OBJ_BG_FILTER>].create_rect(0, 0, <SCREEN_WIDTH>, <SCREEN_HEIGHT>, 0, 0, 0, 192, 1)
	}
	elseif( $screen_type == 3 )
	{
		front.object[<URACE_OBJ_BG_FILTER>].create(_mng_ur_skill_filter, 1)
		front.object[<URACE_OBJ_BG_FILTER>].tr = 96
		front.object[<URACE_OBJ_BG_FILTER>].blend = 1
	}
	
	if( $hide_mode_type == 1 )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.tr_eve.set(0, 500, 0, 2)
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_shadow.disp = 1
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_run_scatter.disp = 0
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_wave.disp = 0
	}
	elseif( $hide_mode_type == 2 )
	{
		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_dig)
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.tr_eve.set(0, 250, 0, 2)
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_shadow.disp = 0
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_run_scatter.disp = 0
	}
	
	/*
	elseif( $skill_id == @スキル_宝石の力 || $skill_id == @スキル_宝石の力／強化 )
	{
		$$play_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_skill_ef_front.child[$skill_index])
	}
	*/
}

command $$stop_skill_effect(property $lane_index)
{
	/*
	property $i
	property $skill_index
	property $stop_type
	property $target_stop_type
	property $color_type
	property $screen_type
	property $hide_mode_type
	
	$skill_index = 0
	
	//2
	if( $uma_active_skill_id[$lane_index] == @スキル_加速 ) {
		return
	}
	
	$$stop_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_util_ef_front.child[15])
	
	switch( $uma_active_skill_id[$lane_index] ) {
	case(@スキル_加速)						$stop_type = 1		$color_type = 1
	case(@スキル_加速／強化)				$stop_type = 1		$color_type = 1
	case(@スキル_瞬足)						$stop_type = 2		$color_type = 1
	case(@スキル_瞬足／強化)				$stop_type = 2		$color_type = 1
	case(@スキル_幸運の追い風)				$stop_type = 2		$color_type = 1
	case(@スキル_アンジュレーション)		$color_type = 1;$stop_type = 1		$color_type = 1
	case(@スキル_つむじ風)					$stop_type = 2		$target_stop_type = 7
	case(@スキル_闇に紛れる)				$stop_type = 2		$color_type = 2		$screen_type = 1
	case(@スキル_尻子玉を抜く)				$stop_type = 2		$target_stop_type = 19
	case(@スキル_吸血（調整中）)						$stop_type = 2		$target_stop_type = 23
	case(@スキル_潜水)						$hide_mode_type = 1
	case(@スキル_えり好み)					$stop_type = 2		$color_type = 1
	case(@スキル_御来光)					$stop_type = 3		$skill_index = 0		$target_stop_type = 21		$screen_type = 1
	case(@スキル_吹雪)						$stop_type = 3		$skill_index = 1		$target_stop_type = 20		$screen_type = 1
	case(@スキル_潜行)						$hide_mode_type = 2
	case(@スキル_迅雷)						$stop_type = 1		$color_type = 1
	}
	
	if( $stop_type == 1 ) {
		$$stop_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_skill_ef_back.child[$skill_index])
	}
	elseif( $stop_type == 2 ) {
		$$stop_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_skill_ef_front.child[$skill_index])
	}
	elseif( $stop_type == 3 ) {
		$$stop_urace_effect(front.object[<URACE_OBJ_SCREEN_EFFECT>].child[$skill_index])
	}
	
	if( $target_stop_type )
	{
		for( $i = 0, $i < $entry_uma_num, $i += 1 )
		{
			if( $$get_running_uma_active_skill_target($lane_index, $i) != -1 )
			{
				$$stop_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $$get_running_uma_active_skill_target($lane_index, $i)].cd_chara_util_ef_front.child[$target_stop_type])
			}
		}
	}
	
	if( $color_type == 1 )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.bright = 0
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.color_add_r = 0
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.color_add_g = 0
	}
	elseif( $color_type == 2 )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.tr_eve.end
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.tr = 255
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.dark = 0
	}
	
	if( $screen_type == 1 )
	{
		front.object[<URACE_OBJ_BG_FILTER>].init
	}
	
	if( $hide_mode_type == 1 )
	{
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.tr_eve.set(255, 250, 0, 1)
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_shadow.disp = 0
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_run_scatter.disp = 1
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_wave.disp = 1
	}
	elseif( $hide_mode_type == 2 )
	{
		$$stop_urace_effect(front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_dig)
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_chara_tip.tr_eve.set(255, 250, 0, 1)
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_shadow.disp = 1
		front.object[<URACE_OBJ_UMA_TIP> + $lane_index].cd_run_scatter.disp = 1
	}
	*/
}



//2
command $$get_lane_y(property $lane_index)
{
	property $base_y
	property $offset_y
	
	$base_y = 362
	$offset_y = 90
	
	return ($base_y + $offset_y * $lane_index)
}
#inc_start
	#property $tes_o
	#property $tes_c
#inc_end
command $$add_bullet(property $lane_index, property $id, property $place)
{
	property $i
	property $len
	property $index
	
	// 空いているオブジェクトを取得する
	$len = front.object[<URACE_OBJ_BULLET> + $lane_index].child.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( front.object[<URACE_OBJ_BULLET> + $lane_index].child[$i].disp == 0 )
		{
			$index = $i
			break
		}
	}
	
	front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].create("__mng_ur_item" + math.tostr_zero($id, 2), 1, 0, 0, 1)
	front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].x = math.linear($place, 0, $start_x[$lane_index], $$get_entry_race_distance, $goal_x[$lane_index])
	front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].y = $$get_lane_y($lane_index)
	
	front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child.resize(1)
	front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].create("__mng_ur_item" + math.tostr_zero($id, 2), 1)
	if( $id == 1 ) {
		
		front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].center_rep_x = 67
		front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].center_rep_y = 50
;		$$set_image_center_rep()
		front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].rotate_z_eve.loop(0, -3600, 500, 0, 0)
	}
	
	// シュールストレミングの場合
	if( $id == @アイテム_蓋のついたシュールストレミング )
	{
		// 子オブジェクトで範囲エフェクト表現
		//front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child.resize(1)
		//front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].create("__mng_ur_item04", 1)
		front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].center_rep_x = 42
		front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].center_rep_y = 41
		// スケールアニメ
		front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].scale_x_eve.turn(4000, 3500, 500, 0, 0)
		front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].scale_y_eve.turn(4000, 3500, 500, 0, 0)
		// 透明度変化
		//front.object[<URACE_OBJ_BULLET> + $lane_index].child[$index].child[0].tr_eve.loop(255, 128, 5000, 0, 0)
	}
	
	$tes_o = <URACE_OBJ_BULLET> + $lane_index
	$tes_c = $index
}
command $$del_bullet(property $o, property $c)
{
	front.object[$o].child[$c].init
;	front.object[$o].child[$c].tr_eve.set(0, 250, 0, 2)
}

command $$update_bullet(property $obj : object, property $lane_index)
{
	$obj.x = -$camera_x
	
	property $i
	
	for( $i = 0, $i < $$get_projectile_num, $i += 1 )
	{
;		if( $$get_bullet_type($i) == 2 )
;		{
			front.object[$$get_projectile_obj_no($i)].child[$$get_projectile_child_no($i)].x = math.linear($$get_projectile_place($i), 0, $start_x[$lane_index], $$get_entry_race_distance, $goal_x[$lane_index])
;		}
	}
}

command $$get_o { return ($tes_o) }
command $$get_c { return ($tes_c) }
