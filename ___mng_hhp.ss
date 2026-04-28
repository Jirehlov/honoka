//===========================================================================
//!
//!    @file     ___mng_hhp.ss
//!    @brief    ヘビヘビパニックエントリポイント
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
	
	// 変数
	#property	$select_btn				// 選択したボタン
	#property	$wait_time				// 待ち時間
	
	// デバッグ
	#property	$adv_debug_disp			// ＡＤＶモードのデバッグ表示保存用
	
#inc_end


//===========================================================================
// メインフロー
//===========================================================================
#z00

//----------------------------------------------
// シナリオ遷移
//----------------------------------------------
@ヘビパ_ユーザー制御解除

farcall("101_ヘビヘビパニック0001", 1)

// フェード
@all_sound_stop(2000)
@fade(3)

// すべてのオブジェクトを消去
$$set_front_wipe_copy_all(0)
@wipe(3)


//----------------------------------------------
// 初期化
//----------------------------------------------
#z01

@シーン開始
@ヘビパ_ユーザー制御開始

// ＡＤＶモードのデバッグシステムを非表示
if( system.check_debug_flag ) {
	$adv_debug_disp = front.object[<OBJ_DEBUG_SC_KEY>].disp		// ＡＤＶデバッグ表示状態を保存（ミニゲーム終了時に復帰）
	front.object[<OBJ_DEBUG_SC_KEY>].disp = 0					// ＡＤＶデバッグ表記を非表示にする
}

// プレイ回数によってプレイヤーデータの設定を変更する
if( $$get_hhp_total_play_count == 0 )
{
	$$init_hhp_player_data		// プレイヤーデータの初期化（初回）
}
else
{
	$$restart_hhp_player_data	// プレイヤーデータの初期化（二回目以降／再ゲーム開始時）
}

//----------------------------------------------
// サポート選択画面
//----------------------------------------------

// サポート選択画面へ（※初回プレイ時はサポート選択画面にはいかない）
if( 0 < $$get_hhp_total_play_count )
{
	farcall("___mng_hhp_flow_support_select")
}


//----------------------------------------------
// オブジェクト作成
//----------------------------------------------
#z02

// デバッグ用設定
if( system.check_debug_flag )
{
	// ミニゲームデバッグシステムを初期化する
	$$init_hhp_debug_system
	
	// デバッグ用個別設定
	$$debug_setting
}

// ステージデータを初期化する
$$init_hhp_stage_data

// デバッグ用設定
if( system.check_debug_flag )
{
	// デバッグ用個別設定
	$$debug_setting2
}

// 敵を初期化
$$init_hhp_enemy

// 当たり判定を初期化
$$init_hhp_hitbox

// エフェクトを初期化
$$init_hhp_effect

// ＵＩの作成
$$create_hhp_scene_object(front)

// チュートリアルメッセージ
if( $$get_hhp_total_play_count == 0 )
{
	if( $$get_hhp_global_play_count == 0 && $$get_hhp_tutorial_flag < 1 )
	{
		timewait_key(500)
		$$show_defegg_tutorial(1)
		$$show_defegg_tutorial(2)
		$$show_defegg_tutorial(3)
		$$show_defegg_tutorial(4)
		$$show_defegg_tutorial(5)
		$$show_defegg_tutorial(6)
	}
}
else
{
	// 報酬画面へ（二回目以降はウェーブ前に報酬を選択）
	farcall("___mng_hhp_flow_rewards")
}


//----------------------------------------------
// ウェーブ準備
//----------------------------------------------
#ready

// ウェーブデータを初期化する
$$init_hhp_wave_data

// ウェーブ準備フローへ
;farcall("___mng_hhp_flow_ready")	todo いるか微妙そう

// ボスウェーブの場合
if( $$is_hhp_boss_wave )
{
	// ボスの登場演出を再生する
	$$play_hhp_boss_intro(front.object[<HHP_OBJ_BOSS>], front.object[<HHP_OBJ_BOSS_SHADOW>])
	
	// ＢＧＭ再生
	@bgm(bgm18a)
}

// 通常ウェーブの場合
else
{
	// ＢＧＭ再生
	@bgm(bgm19)
}

//----------------------------------------------
// メインループ
//----------------------------------------------

// 一度画面を更新する
disp

// 入力制御を開始する
$$input_start(front, <HHP_BTNGROUP_NORMAL>)

// ミニゲームで使用するカウンターを初期化する
$$init_mng_counter

// ループへ
input.clear
while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <HHP_BTNGROUP_NORMAL>)
	
	// デバッグシステムを更新する
	if( $$update_hhp_debug_system ) {
		break
	}
	
	// キャンセルは一時停止ボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<HHP_BUTTON_SE_CANCEL>)
		$select_btn = <HHP_BTN_PAUSE>
	}
	
	// 一時停止ボタンが押された場合
	if( $select_btn == <HHP_BTN_PAUSE> )
	{
		$$set_hhp_pause_flag($$reverse_flag($$get_hhp_pause_flag))
		
		if( $$get_hhp_pause_flag )
		{
			syscom.call_ex("___mng_hhp_flow_pause")
			$$set_hhp_pause_flag($$reverse_flag($$get_hhp_pause_flag))
			
			input.clear
		}
	}
	
	$$update_player_push_attack_key
	if( $$get_hhp_push_attack_key ) {
		$$hhp_player_trigger_on_attack
	}
	
	if( $$get_hhp_pause_flag == 0 )
	{
		l[1] = $$check_hhp_all_enemy_hit
;		l[2] = $$check_hhp_all_enemy_hitbox
		
		if( $select_btn == <HHP_BTN_SKILL> ) {
			
			$$add_hhp_skill_power(-<HHP_ACTIVATE_SKILL_POWER>)
			
			@mng_counter.stop
			
			$$hhp_skill_trigger_on_activate
			
			front.objbtngroup[<HHP_BTNGROUP_NORMAL>].start_cancel
			
			@mng_counter.resume
		}
		
		elseif( $$get_hhp_push_attack_key && l[1] == 0 ) {
			
;			@SE_ヘビパ_タップ_ミス
			
			// エフェクト
			$$spawn_hhp_effect(<HHP_EF_PLAYER_ATTACK>, mouse.get_pos_x, mouse.get_pos_y, 0)
			
;			$$spawn_hhp_effect(<DEFEGG_EF_TAP_CHECK>, mouse.get_pos_x + 80, mouse.get_pos_y, 0)
		}
	}
	
	$$update
	
	// ゲーム終了判定
	if( $$is_hhp_wave_over ) {
		
		$$defegg_all_enemy_wait
		
		if( $$is_hhp_boss_wave && $$is_hhp_boss_turn_max )
		{
			$$add_hhp_player_life(-999)
			$$set_hhp_play_result(<HHP_PLAY_RESULT_LOSE>)
		}
		elseif( $$is_hhp_boss_wave ) {
			
			front.object[<HHP_OBJ_BOSS>].bright_eve.turn(0, 128, 250, 0, 2)
			$$set_hhp_play_result(<HHP_PLAY_RESULT_WIN>)
		} else {
			$$set_hhp_play_result(<HHP_PLAY_RESULT_WIN>)
		}
		
		break
	}
	
	if( $$get_hhp_player_life <= 0 )
	{
		l[1] = $$hhp_item_trigger_on_player_dead
		
		if( l[1] == 0 )
		{
			$$set_hhp_play_result(<HHP_PLAY_RESULT_LOSE>)
			break
		}
	}
	
	// 何かのボタンが押された場合
	if( $select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <HHP_BTNGROUP_NORMAL>)
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}


//----------------------------------------------
// ウェーブ終了
//----------------------------------------------

$wait_time = @mng_counter.get
input.clear
while(1)
{
	if( $wait_time + 1000 < @mng_counter.get )
	{
		$$hhp_all_enemy_attack_over
		
		$$spawn_hhp_effect(<HHP_EF_TREASURE>, <SCREEN_CENTER_X>, <SCREEN_CENTER_Y>, 0)
		
		break
	}
	
	$$update
	
	input.next
	disp
}

$wait_time = @mng_counter.get
input.clear
while(1)
{
	if( $wait_time + 1000 < @mng_counter.get )
	{
		if( $$get_hhp_play_result == <HHP_PLAY_RESULT_WIN> )
		{
			// ウェーブが終了した場合
			if( $$is_hhp_all_wave_over == 0 )
			{
				// deb 報酬追加
				$$add_hhp_rewards_num(1)
			}
		}
		break
	}
	
	$$update
	
	input.next
	disp
}

// すべての効果音を停止する
@se_stop_all

// プレイヤーが敗北した場合
if( $$get_hhp_play_result == <HHP_PLAY_RESULT_LOSE> )
{
	// ポップアップシーンへ
	farcall("___mng_hhp_flow_popup", 0, <HHP_RESULT_POPUP_TYPE_WAVE_LOSE>)
	
	$$hide_hhp_scene_object(front)
	
	// リザルト画面へ
	farcall("___mng_hhp_flow_result")
}

// プレイヤーが勝利した場合
elseif( $$get_hhp_play_result == <HHP_PLAY_RESULT_WIN> )
{
	// ウェーブが終了した場合
	if( $$is_hhp_all_wave_over )
	{
		// ボスを倒した
		if( $$is_hhp_boss_wave ) {
			$$play_hhp_boss_defeat(front.object[<HHP_OBJ_BOSS>])
		}
		
		// ポップアップシーンへ
		farcall("___mng_hhp_flow_popup", 0, <HHP_RESULT_POPUP_TYPE_ALL_WIN>)
		
		$$hide_hhp_scene_object(front)
		
		// リザルト画面へ
		farcall("___mng_hhp_flow_result")
	}
	
	// ウェーブが終了していない場合（次のウェーブへ）
	else
	{
		$$hhp_item_trigger_on_wave_finished						// ウェーブ終了時に発生するイベント
		$$update_hhp_scene_object(front)						// シーンオブジェクトを更新する
		
		@SE_ヘビパ_ウェーブクリア
		
		// ポップアップシーンへ
		farcall("___mng_hhp_flow_popup", 0, <HHP_RESULT_POPUP_TYPE_WAVE_WIN>)
		
		// 報酬画面へ
		farcall("___mng_hhp_flow_rewards")
		
		// ウェーブを次に進める
		$$next_hhp_wave
		
		// シーンオブジェクトを変更する(通常ウェーブ／ボスウェーブ)
		$$change_hhp_scene_object(front, $$is_hhp_boss_wave)
		
		// ウェーブ準備へ
		goto #ready
	}
}


//----------------------------------------------
// 終了処理
//----------------------------------------------

syscom.set_syscom_menu_enable			// システムコマンドを許可する
syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを許可する
script.set_msg_back_enable				// メッセージバックを許可する

// ＡＤＶデバッグ表示状態を復帰する
if( system.check_debug_flag ) {
	front.object[<OBJ_DEBUG_SC_KEY>].disp = $adv_debug_disp
}

@all_sound_stop(1000)	// すべてのサウンドを停止する
@fade(25)				// フェード
@all_sound_stop(0)		// 完全にサウンドを停止する

// レコード獲得判定
$$check_record

@ヘビパ_ユーザー制御解除

farcall("101_ヘビヘビパニック0001", 2)

return



//---------------------------------------------------------------------------
// 更新処理（毎フレーム）
//---------------------------------------------------------------------------
command $$update
{
	// ミニゲームで使用するカウンターを更新する
	$$update_mng_counter
	
	// ゲームが終了していない場合のみ実行する
	if( $$get_hhp_player_life > 0 && $$is_hhp_wave_over == 0 )
	{
		// 毎フレームごとに発生するスキルイベント
		$$hhp_skill_trigger_on_update
		
		// 毎フレームごとに発生するアイテムイベント
		$$hhp_item_trigger_on_update
		
		// プレイヤーデータの更新
		$$update_hhp_player_data
		
		// ウェーブデータを更新する
		$$update_hhp_wave_data
		
		// 当たり判定を更新する
		$$update_hhp_hitbox
	}
	
	// 敵を更新する
	$$update_hhp_enemy
	
	// シーンオブジェクトを更新する
	$$update_hhp_scene_object(front)
}

//---------------------------------------------------------------------------
// レコード取得判定
//---------------------------------------------------------------------------
command $$check_record
{
	/*
	if( $$get_hhp_global_play_count >= 1 ) {
		@レコード獲得(@レコード_ヘビパで初めて遊んだ)
	}
	
	if( $$get_hhp_skill_use_count >= 1 ) {
		@レコード獲得(@レコード_ヘビパで初めて奥義を使用した)
	}
	
	if( $$get_hhp_skill_use_count >= 1 && $$get_hhp_skill_count >= 3 ) {
		@レコード獲得(@レコード_ヘビパで初めて３人奥義を使用した)
	}
	
	if( $$get_hhp_item_count_from_level(2) ) {
		@レコード獲得(@レコード_ヘビパで初めてレアリティの高いアイテムを手に入れた)
	}
	
	if( $$get_hhp_item_library_on_count >= 25 ) {
		@レコード獲得(@レコード_ヘビパで合計２５個のアイテムを見つけた)
	}
	
	if( $$get_hhp_item_library_on_count >= 50 ) {
		@レコード獲得(@レコード_ヘビパで合計５０個のアイテムを見つけた)
	}
	
	if( $$get_hhp_item_library_on_count >= 75 ) {
		@レコード獲得(@レコード_ヘビパですべてのアイテムを見つけた)
	}
	
	if( $$get_hhp_player_attacked_damage_max >= 100 ) {
		@レコード獲得(@レコード_ヘビパで一回の攻撃で１００ダメージ以上与えた)
	}
	
	if( $$get_hhp_player_attacked_damage_max >= 500 ) {
		@レコード獲得(@レコード_ヘビパで一回の攻撃で５００ダメージ以上与えた)
	}
	
	if( $$get_hhp_player_attacked_damage_max >= 1000 ) {
		@レコード獲得(@レコード_ヘビパで一回の攻撃で１０００ダメージ以上与えた)
	}
	
	if( $$get_hhp_player_combo_max >= 30 ) {
		@レコード獲得(@レコード_ヘビパで最大コンボ３０を達成した)
	}
	
	if( $$get_hhp_player_combo_max >= 60 ) {
		@レコード獲得(@レコード_ヘビパで最大コンボ６０を達成した)
	}
	
	if( $$get_hhp_player_combo_max >= 100 ) {
		@レコード獲得(@レコード_ヘビパで最大コンボ１００を達成した)
	}
	
	if( $$get_hhp_hi_score >= 10000 ) {
		@レコード獲得(@レコード_ヘビパでスコア１００００を獲得した)
	}
	
	if( $$get_hhp_hi_score >= 50000 ) {
		@レコード獲得(@レコード_ヘビパでスコア５００００を獲得した)
	}
	
	if( $$get_hhp_hi_score >= 100000 ) {
		@レコード獲得(@レコード_ヘビパでスコア１０００００を獲得した)
	}
	
	if( $$get_hhp_boss_type != -1 && $$get_hhp_boss_turn == 0 ) {
		@レコード獲得(@レコード_ヘビパでボスを１ターン以内に倒した)
	}
	
	if( 0 ) {
		@レコード獲得(@レコード_ヘビパで河瀬を倒した)
	}
	
	if( 0 ) {
		@レコード獲得(@レコード_ヘビパで小森を倒した)
	}
	
	if( $$get_hhp_play_level >= 4 ) {
		@レコード獲得(@レコード_ヘビパでヤマタノオロチを倒した)
	}
	
	if( $$get_hhp_play_level >= 8 ) {
		@レコード獲得(@レコード_ヘビパでヒュドラを倒した)
	}
	
	if( $$get_hhp_play_level >= <HHP_PLAY_LEVEL_MAX> ) {
		@レコード獲得(@レコード_ヘビパでメデューサを倒した)
	}
	*/
}

//----------------------------------------------
// デバッグ用個別設定
//----------------------------------------------
command $$debug_setting
{
	return
	
	if( 1 ) { $$set_hhp_play_level(9) }
	
;	$$powerup_hhp_item(<HHP_ITEM_ID_RIVIVAL>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_LIFE_REGENERATION>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_LIFE_REGENERATION>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_LIFE_REGENERATION>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_COMBO_UP>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_COMBO_UP>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_COMBO_UP>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_RIVIVAL>)
;	$$powerup_hhp_item(<HHP_ITEM_ID_COMBO_UP>)
	;$$powerup_hhp_item(<HHP_ITEM_IfD_PERMANENTLY_LIFE_UP>)
	;$$powerup_hhp_item(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)
	;$$powerup_hhp_item(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)
	
	if( 1 ) {
		for( l[0] = 1, l[0] <= 29, l[0] += 1 ) {
			
			if( l[0] == 28 || l[0] == 5 || l[0] == 26 || l[0] == 7  ) {
				continue
			}
			
			$$powerup_hhp_item(l[0])
			$$powerup_hhp_item(l[0])
			if( l[0] != 2 ) {
				$$powerup_hhp_item(l[0])
			}
		}
	}
	
	for( l[0] = 0, l[0] < <RECORD_FLAG_MAX>, l[0] += 1 )
	{
		$$record_flag_off(l[0])
	}
}

command $$debug_setting2
{
;	return
	
	if( 0 ) { $$set_hhp_wave(2) }
}
