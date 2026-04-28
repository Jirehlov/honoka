//===========================================================================
//!
//!    @file     ___mng_hhp_flow_result.ss
//!    @brief    ヘビヘビパニックリザルト画面
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
	#replace	@オブジェクト_背景					0
	#replace	@オブジェクト_スクロール			1		// スクロールビューはボタンを２つ使用する
	#replace	@オブジェクト_次のレベル			3
	#replace	@ボタン_次へ						4
	#replace	@ボタン_アイテム					5
	
	// ゲームパッド動作
	#replace	@動作_スクロールフォーカス			-11
	#replace	@動作_スクロールアップ				-12
	#replace	@動作_スクロールダウン				-13
	
	// 変数
	#property	$select_btn			// 選択したボタン
	#property	$result				// 勝敗結果
	#property	$hi_score			// ハイスコア更新
	
#inc_end


//===========================================================================
// リザルト画面フロー
//===========================================================================
#z00

// ＢＧＭ停止
@bgm_stop

// 勝敗を取得する
$result = $$get_hhp_play_result

// プレイヤーデータを更新する
$$update_player_data

// 勝利／敗北で表示演出を変更する
if( $result == <HHP_PLAY_RESULT_WIN> )
{
	@SE_ヘビパ_ゲーム勝利
	
	// 音声を再生する
	$$play_hhp_voice(-1, <HHP_VOICE_TYPE_RESULT>)
}
else
{
;	@SE_ヘビパ_ゲーム敗北
}

// 初期化処理
@mng_counter.stop					// ミニゲームカウンターの一時停止
$$create_result_scene_object(back)	// ＵＩを作成する
$$set_joypad_navigation(back)		// パッド入力の遷移を設定する
$$show_result_scene_object(back)	// ＵＩを表示する

// レベルアップ画面へ
if( $result == <HHP_PLAY_RESULT_WIN> && $$get_hhp_play_level < <HHP_PLAY_LEVEL_MAX> ) {
	farcall("___mng_hhp_flow_levelup")
	front.object[@ボタン_次へ].set_button_state_normal
}

// 入力制御を開始する
$$input_start(front, <HHP_BTNGROUP_NORMAL>)

input.clear
while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <HHP_BTNGROUP_NORMAL>)
	
	// キャンセルは何もしない
	if( $select_btn == -1 ) {
		// 入力制御を開始する
		$$input_start(front, <HHP_BTNGROUP_NORMAL>)
	}
	
	// 次へボタンが押された場合は終了する
	if( $select_btn == @ボタン_次へ ) {
		break
	}
	
	// アイテムボタンが押された場合はアイテム詳細へ
	if( $select_btn >= @ボタン_アイテム ) {
		farcall("___mng_hhp_flow_item_info", 0, $select_btn - @ボタン_アイテム)
	}
	
	// ゲームパッド動作
	switch( $select_btn ) {
	case(@動作_レコード_スクロールフォーカス)
		
		front.object[@オブジェクト_スクロール].f_scview_target_obj_no = @オブジェクト_スクロール
		$$reset_joypad_focus_button(front)
		$$set_joypad_focus_button(@オブジェクト_スクロール)
		
	case(@動作_レコード_スクロールダウン)	$$trigger_ui_scrollview_scroll(front.object[@オブジェクト_スクロール], <MOUSE_WHEEL_TYPE_DOWN>)
	case(@動作_レコード_スクロールアップ)	$$trigger_ui_scrollview_scroll(front.object[@オブジェクト_スクロール], <MOUSE_WHEEL_TYPE_UP>)
	}
	
	// 何かのボタンが押された
	if( $select_btn != -2 ) {
		$$input_start(front, <HHP_BTNGROUP_NORMAL>)
	}
	
	input.next
	disp
}

// 終了処理
@all_sound_stop						// すべてのサウンドを停止する
$$hide_result_scene_object(front)	// ＵＩを非表示にする
@mng_counter.resume					// ミニゲームカウンターの一時停止を解除

return


//---------------------------------------------------------------------------
// プレイヤーデータを更新する
//---------------------------------------------------------------------------
command $$update_player_data
{
	// プレイ回数を加算する
	$$add_hhp_play_count($$get_hhp_play_level)
	$$add_hhp_global_play_count
	
	// ハイスコアを保存する
	if( $$get_hhp_hi_score < $$get_hhp_score )
	{
		$$set_hhp_hi_score($$get_hhp_score)
		$hi_score = 1
	}
	
	// 勝利の場合は
	if( $result == <HHP_PLAY_RESULT_WIN> )
	{
		// メデューサを倒した場合はクリアフラグをオンにする
		// ※ＵＭＡレース「メデューサ出現フラグ」
		if( @ヘビパ_メデューサ発生中 ) {
			@mng_global_flag[<HHP_CLEAR>] = 1
		}
		
		// プレイレベル（難易度）を加算する
		$$add_hhp_play_level(1)
	}
}

//---------------------------------------------------------------------------
// リザルトシーンを作成する
//---------------------------------------------------------------------------
command $$create_result_scene_object(property $stage : stage)
{
	property $i
	property $len
	property $index
	property $filename : str
	property $offset_x
	property $score
	property $div
	property $item_id
	property $item_level
	
	$stage.object[@オブジェクト_背景].disp = 1
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_UI>
	$stage.object[@オブジェクト_背景].child.resize(11)
	
	// 背景／ベース
	$stage.object[@オブジェクト_背景].child[0].create("__mng_hp_result_bg", 1, -64, -21, $result * 2 + 1)
	$stage.object[@オブジェクト_背景].child[0].x_eve.loop(-64, 0, 2000, 0, 0)
	$stage.object[@オブジェクト_背景].child[0].y_eve.loop(-21, 0, 2000, 0, 0)
	
	// 背景／枠
	$stage.object[@オブジェクト_背景].child[1].create("__mng_hp_result_bg", 1, -64, -64, $result * 2 + 0)
	
	// 勝敗
	$stage.object[@オブジェクト_背景].child[2].create("__mng_hp_result_title", 1, 698, 89, $result)
	
	// レベル
	if( $result == <HHP_PLAY_RESULT_WIN> )	{ $filename = "__mng_hp_result_level_win" }
	else									{ $filename = "__mng_hp_result_level_lose" }
	$stage.object[@オブジェクト_背景].child[3].create($filename, 1, 134, 100, $$get_hhp_play_level - 2)
	
	// サポートキャラ／タグ
	$stage.object[@オブジェクト_背景].child[4].create("__mng_hp_result_support_bg", 1, 134, 244, $result)
	$stage.object[@オブジェクト_背景].child[4].child.resize(3)
	
	// サポートキャラ／アイコン
	for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
	{
		if( $$has_hhp_skill($i) )
		{
			$stage.object[@オブジェクト_背景].child[4].child[$index].create("__mng_hp_result_support_icon", 1, 12 + $index * 224, 68, $result * <HHP_SKILL_ID_MAX> + $i)
			$index += 1
		}
	}
	
	// 討伐ボス／タグ
	if( $$get_hhp_boss_type != - 1 )
	{
		$stage.object[@オブジェクト_背景].child[5].create("__mng_hp_result_boss_bg", 1, 134, 585, $result)
		$stage.object[@オブジェクト_背景].child[5].child.resize(1)
		
		// 討伐ボス／サムネイル
		$stage.object[@オブジェクト_背景].child[5].child[0].create("__mng_hp_result_boss_icon", 1, 10, 65, $result * <HHP_BOSS_TYPE_MAX> - 1 + $$get_hhp_boss_type - 1)
		if( $$get_hhp_boss_type == -1 ) {
			$stage.object[@オブジェクト_背景].child[5].child[0].disp = 0
		}
	}
	
	// 最大コンボ／タグ
	$stage.object[@オブジェクト_背景].child[6].create("__mng_hp_result_combo_bg", 1, 462, 585, $result)
	$stage.object[@オブジェクト_背景].child[6].child.resize(3)
	
	// 最大コンボ／背景
	$stage.object[@オブジェクト_背景].child[6].child[0].create("__mng_hp_result_combo_bg", 1, 0, 0, 2 + $result)
	
	// 最大コンボ／combo文字
	$stage.object[@オブジェクト_背景].child[6].child[1].create("__mng_hp_result_combo_bg", 1, 0, 0, 4)
	
	// 最大コンボ／数字
	$stage.object[@オブジェクト_背景].child[6].child[2].create_number("__mng_hp_result_combo_number", 1, 47, 125)
	$stage.object[@オブジェクト_背景].child[6].child[2].set_number_param(3, 0, 0, 0, 0, 0)
	$stage.object[@オブジェクト_背景].child[6].child[2].set_number($$get_hhp_player_combo_max)
	if( $$get_hhp_player_combo_max < 10 ) {
		// １桁
		$stage.object[@オブジェクト_背景].child[6].child[2].x -= $stage.object[@オブジェクト_背景].child[6].child[2].get_size_x
	}
	elseif( $$get_hhp_player_combo_max < 100 ) {
		// ２桁
		$stage.object[@オブジェクト_背景].child[6].child[2].x -= $stage.object[@オブジェクト_背景].child[6].child[2].get_size_x / 2
	}
	
	// ボスレベルでないときは最大コンボを討伐ボスの位置に表示する
	if( $$get_hhp_boss_type == - 1 ) {
		$stage.object[@オブジェクト_背景].child[6].set_pos(134, 585)
	}
	
	// アイテム／タグ
	$len = $$get_hhp_item_count
	$stage.object[@オブジェクト_背景].child[7].create("__mng_hp_result_item_bg", 1, 900, 244, $result)
	$stage.object[@オブジェクト_背景].child[7].child.resize(1)
	
	// アイテム／背景
	$stage.object[@オブジェクト_背景].child[7].child[0].create("__mng_hp_result_item_bg", 1, 0, 0, 2 + $result)
	
	// アイテム／アイコン
	for( $i = 0, $i < $len, $i += 1 )
	{
		$item_id = $$get_hhp_item_id_from_list_index($i)
		$item_level = $$get_hhp_item_level_from_list_index($i)
		
		$$create_ui_button($stage.object[@ボタン_アイテム + $i], "__mng_hp_pause_item_btn" + math.tostr_zero($$get_hhp_item_icon_no($item_id, $item_level) + 1, 2), 950 + 127 * ($i % 6), 341 + 125 * ($i / 6), @ボタン_アイテム + $i, <HHP_BTNGROUP_NORMAL>, 0)
		$stage.object[@ボタン_アイテム + $i].layer = <HHP_LAYER_UI>
	}
	
	// アイテムが１９個以上の場合はスクロールバーを作成する
	if( $len > 18 )
	{
		if( $result == <HHP_PLAY_RESULT_WIN> )	{ $filename = "__mng_hp_result_item_scroll_win" }
		else									{ $filename = "__mng_hp_result_item_scroll_lose" }
		
		$$create_ui_scrollview($stage.object[@オブジェクト_スクロール], $filename, 950, 340, @オブジェクト_スクロール,
							   $stage.object[@ボタン_アイテム], $stage.object[@ボタン_アイテム + $len - 1],
							   380, 793, 2, @オブジェクト_スクロール, @オブジェクト_スクロール + 1, <HHP_BTNGROUP_NORMAL>, 1, 0, 0)
		$$set_ui_scrollview_margin($stage.object[@オブジェクト_スクロール], -340 + 20)
		$stage.object[@オブジェクト_スクロール].layer = <HHP_LAYER_UI>
		// アイコンをスクロールビューのグループとして設定する
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$set_ui_scrollview_group($stage.object[@ボタン_アイテム + $i], $stage.object[@オブジェクト_スクロール], @オブジェクト_スクロール)
		}
	}
	
	// スコア／タグ
	$stage.object[@オブジェクト_背景].child[8].create("__mng_hp_result_score_bg", 1, 1127, 759, $result)
	$stage.object[@オブジェクト_背景].child[8].child.resize(10)
	
	// スコア／数字
	$score = $$get_hhp_score
	for( $i = 0, $i < 10, $i += 1 )
	{
		if( $i % 4 == 3 )
		{
			// カンマ
			$stage.object[@オブジェクト_背景].child[8].child[$i].create("__mng_hp_result_score_number", 1, 628 - $offset_x, 18, 10)
			$offset_x += 25
		}
		else
		{
			// 数字
			$div = $score % 10
			$stage.object[@オブジェクト_背景].child[8].child[$i].create("__mng_hp_result_score_number", 1, 628 - $offset_x, 18, $div)
			$offset_x += 50
			$score = $score / 10
		}
		
		if( $score <= 0 ) {
			break
		}
	}
	
	// スコア／新記録
	if( $hi_score )
	{
		$stage.object[@オブジェクト_背景].child[9].create("__mng_hp_result_new_record", 1, 944, 767, $result)
		$stage.object[@オブジェクト_背景].child[9].bright_eve.turn(0, 64, 1500, 500, 0)
	}
	
	// ハイスコア／タグ
	$stage.object[@オブジェクト_背景].child[10].create("__mng_hp_result_hiscore_bg", 1, 1280, 882, $result)
	$stage.object[@オブジェクト_背景].child[10].child.resize(10)
	
	// ハイスコア／数字
	if( $result == <HHP_PLAY_RESULT_WIN> )	{ $filename = "__mng_hp_result_hiscore_win_number" }
	else									{ $filename = "__mng_hp_result_hiscore_lose_number" }
	
	$score = $$get_hhp_hi_score
	$offset_x = 0
	for( $i = 0, $i < 10, $i += 1 )
	{
		if( $i % 4 == 3 )
		{
			// カンマ
			$stage.object[@オブジェクト_背景].child[10].child[$i].create($filename, 1, 480 - $offset_x, -19, 10)
			$offset_x += 22
		}
		else
		{
			// 数字
			$div = $score % 10
			$stage.object[@オブジェクト_背景].child[10].child[$i].create($filename, 1, 480 - $offset_x, -19, $div)
			$offset_x += 36
			$score = $score / 10
		}
		
		if( $score <= 0 ) {
			break
		}
	}
	
	// 終了ボタン
	if( $result == <HHP_PLAY_RESULT_WIN> )	{ $filename = "__mng_hp_result_end_win_btn" }
	else									{ $filename = "__mng_hp_result_end_lose_btn" }
	
	$$create_ui_button($stage.object[@ボタン_次へ], $filename, 779, 915, @ボタン_次へ, <HHP_BTNGROUP_NORMAL>, 0)
	$stage.object[@ボタン_次へ].set_button_state_disable
	$stage.object[@ボタン_次へ].layer = <HHP_LAYER_UI>
}

//---------------------------------------------------------------------------
// リザルトシーンを表示する
//---------------------------------------------------------------------------
command $$show_result_scene_object(property $stage : stage)
{
	property $i
	property $len
	property $time
	
	// ワイプ(即表示)
	wipe(0, 0, wait=1)
	
	//---------------------------------------------------------------------------
	// 表示演出
	@mng_counter.reset
	@mng_counter.start
	
	input.clear
	while(1)
	{
		$time = @mng_counter.get
		
		if( input.decide.on_down_up || input.cancel.on_down_up || $time > 2800 )
		{
			break
		}
		
		input.next
		disp
	}
	
	//---------------------------------------------------------------------------
	// 表示演出終了
	
	// アイテム／アイコン
	$len = $$get_hhp_item_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$set_hhp_button(front.object[@ボタン_アイテム + $i])
	}
	/*
	$$set_hhp_button(front.object[@ボタン_次へ])
	*/
	@mng_counter.stop
}

//---------------------------------------------------------------------------
// リザルトシーンを非表示にする
//---------------------------------------------------------------------------
command $$hide_result_scene_object(property $stage : stage)
{
	$$set_front_wipe_copy_all(0)
	
	// ワイプ
	wipe(0, 250, wait=1)
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
	$w = 6
	$max_line = $len / $w
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_アイテム + $i].joypad_up    = @ボタン_アイテム + $i - $w
		$stage.object[@ボタン_アイテム + $i].joypad_down  = @ボタン_アイテム + $i + $w
		$stage.object[@ボタン_アイテム + $i].joypad_left  = @ボタン_アイテム + $i - 1
		$stage.object[@ボタン_アイテム + $i].joypad_right = @ボタン_アイテム + $i + 1
		
		if( $i < $w )
		{
			$stage.object[@ボタン_アイテム + $i].joypad_up = @ボタン_次へ
		}
		
		if( $i > $len - $w - 1 )
		{
			$stage.object[@ボタン_アイテム + $i].joypad_down = @ボタン_次へ
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
	
	if( $len == 0 )
	{
		$stage.object[@ボタン_次へ].joypad_up    = -1
		$stage.object[@ボタン_次へ].joypad_down  = -1
		$stage.object[@ボタン_次へ].joypad_left  = -1
		$stage.object[@ボタン_次へ].joypad_right = -1
	}
	else
	{
		$stage.object[@ボタン_次へ].joypad_up    = @ボタン_アイテム + $len - 1
		$stage.object[@ボタン_次へ].joypad_down  = @ボタン_アイテム + 0
		$stage.object[@ボタン_次へ].joypad_left  = -1
		$stage.object[@ボタン_次へ].joypad_right = -1
	}
	
	// 次へボタンをデフォルトにする
	$$set_joypad_focus_button(@ボタン_次へ)
}
