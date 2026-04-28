//===========================================================================
//!
//!    @file     ___mng_hhp_flow_support_select.ss
//!    @brief   ヘビヘビパニックサポート選択画面
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
	#replace	@オブジェクト_背景				0
	#replace	@ボタン_ゲーム開始				1
	#replace	@ボタン_キャラクター			2
	#define		@ボタン_キャラクター最大		(@ボタン_キャラクター + <HHP_SKILL_ID_MAX>)
	
	// 変数
	#property	$select_btn			// 選択したボタン
	
#inc_end


//===========================================================================
// サポート選択画面フロー
//===========================================================================
#z00

// 初期化処理
@bgm(bgm44)
$$hhp_font_enable							// ヘビヘビパニックのフォントを有効にする
$select_btn = @ボタン_キャラクター + $$get_hhp_skill_id_from_index(0)			// 初期選択を設定する
$$create_scene_object(back)					// シーンオブジェクトを作成する
$$show_scene_object(back)					// シーンオブジェクトを表示する
$$set_joypad_navigation(front)				// パッド入力の遷移を設定する

// 入力制御を開始する
$$input_start(front, <HHP_BTNGROUP_NORMAL>)

input.clear
while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <HHP_BTNGROUP_NORMAL>)
	
	// キャンセルは何もしない
	if( $select_btn == -1 ) {
		
		// 入力制御を再開始する
		$$input_start(front, <HHP_BTNGROUP_NORMAL>)
	}
	
	// キャラクターのボタンが押された場合はスキルを変更する
	if( @ボタン_キャラクター <= $select_btn && $select_btn <= @ボタン_キャラクター最大 )
	{
		// 指定したキャラクターのスキルを有効／無効にする
		if( $$has_hhp_skill($select_btn - @ボタン_キャラクター) )
		{
			$$off_hhp_skill($select_btn - @ボタン_キャラクター)
		}
		else
		{
			$$on_hhp_skill($select_btn - @ボタン_キャラクター)
		}
		
		// 音声を再生する
		$$play_hhp_voice($select_btn - @ボタン_キャラクター, <HHP_VOICE_TYPE_SUPPORT_SELECT>)
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front)
		
		// 入力制御を再開始する
		$$input_start(front, <HHP_BTNGROUP_NORMAL>)
	}
	
	// 次へボタンが押された場合は終了する
	if( $select_btn == @ボタン_ゲーム開始 ) {
		break
	}
	
	input.next
	disp
}

// 終了処理
timewait_key(500)							// ウェイト
$$hide_scene_object(front)					// シーンオブジェクトを非表示にする
$$destroy_scene_object(front)				// シーンオブジェクトを破棄する
$$hhp_font_enable							// ヘビヘビパニックのフォントを無効にする
koe_stop									// 声を停止する

return


//---------------------------------------------------------------------------
// サポート選択シーンを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $pos_x
	property $pos_y
	
	$stage.object[@オブジェクト_背景].disp = 1
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_UI>
	$stage.object[@オブジェクト_背景].child.resize(10)
	
	// 背景／ベース
	$stage.object[@オブジェクト_背景].child[0].create("__mng_hp_support_bg", 1, -64, -64, 2)
	$stage.object[@オブジェクト_背景].child[0].x_eve.loop(-64, 0, 2000, 0, 0)
	$stage.object[@オブジェクト_背景].child[0].y_eve.loop(-64, 0, 2000, 0, 0)
	
	// 背景／左上
	$stage.object[@オブジェクト_背景].child[1].create("__mng_hp_support_bg", 1, -64, -64, 1)
	$stage.object[@オブジェクト_背景].child[1].y_rep.resize(1)
	
	// 背景／右下
	$stage.object[@オブジェクト_背景].child[2].create("__mng_hp_support_bg", 1, -64, -64, 0)
	$stage.object[@オブジェクト_背景].child[2].y_rep.resize(1)
	
	// 選択キャラクター／影
	$stage.object[@オブジェクト_背景].child[3].create("__mng_hp_support_chara", 1, -88, -64, 1)
	$stage.object[@オブジェクト_背景].child[3].x_rep.resize(1)
	
	// 選択キャラクター／本体
	$stage.object[@オブジェクト_背景].child[4].create("__mng_hp_support_chara", 1, -88, -64)
	$stage.object[@オブジェクト_背景].child[4].x_rep.resize(1)
	
	// 選択枠／枠
	$stage.object[@オブジェクト_背景].child[5].create("__mng_hp_support_frame", 1, 987, 64, 1)
	$stage.object[@オブジェクト_背景].child[5].x_rep.resize(1)
	$stage.object[@オブジェクト_背景].child[5].child.resize(5)
	
	// 選択枠／テキスト
	$stage.object[@オブジェクト_背景].child[5].child[0].create("__mng_hp_support_frame", 1)
	$stage.object[@オブジェクト_背景].child[5].child[0].y_rep.resize(1)
	
	// キャラクター効果／枠
	$stage.object[@オブジェクト_背景].child[5].child[1].create("__mng_hp_support_text_bg", 1, 48, 587)
	
	// キャラクター効果／名前
	$stage.object[@オブジェクト_背景].child[5].child[2].create("__mng_hp_support_text_name", 1, 108, 618)
	
	// キャラクター効果／奥義名
	$stage.object[@オブジェクト_背景].child[5].child[3].create_string("", 1, 107, 700)
	$stage.object[@オブジェクト_背景].child[5].child[3].set_string_param(30, -1, 4, 26, 0, -1, -1, -1)
	
	// キャラクター効果／効果
	$stage.object[@オブジェクト_背景].child[5].child[4].create_string("", 1, 107, 736)
	$stage.object[@オブジェクト_背景].child[5].child[4].set_string_param(25, -1, 4, 26, 0, -1, -1, -1)
	
	// キャラクターボタン
	for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
	{
		switch( $i ) {
		case(0)		$pos_x = 1075		$pos_y = 188
		case(1)		$pos_x = 1299		$pos_y = 188
		case(2)		$pos_x = 1522		$pos_y = 188
		case(3)		$pos_x = 1184		$pos_y = 407
		case(4)		$pos_x = 1407		$pos_y = 407
		}
		
		$$create_ui_button($stage.object[@ボタン_キャラクター + $i], "__mng_hp_support_chara_btn" + math.tostr_zero($i + 1, 2), $pos_x, $pos_y, @ボタン_キャラクター + $i, <HHP_BTNGROUP_NORMAL>, 5)
		$$set_image_center_rep($stage.object[@ボタン_キャラクター + $i])
		$stage.object[@ボタン_キャラクター + $i].layer = <HHP_LAYER_UI>
		$stage.object[@ボタン_キャラクター + $i].frame_action_ch.resize(1)
		
		// 選択マーク
		$stage.object[@ボタン_キャラクター + $i].child.resize(1)
		$stage.object[@ボタン_キャラクター + $i].child[0].create("__mng_hp_support_chara_select_mark", 1, 144, 9)
		$stage.object[@ボタン_キャラクター + $i].child[0].y_rep.resize(1)
	}
	
	// 開始するボタン
	$$create_ui_button($stage.object[@ボタン_ゲーム開始], "__mng_hp_support_start_btn", 1227, 872, @ボタン_ゲーム開始, <HHP_BTNGROUP_NORMAL>, 5)
	$stage.object[@ボタン_ゲーム開始].layer = <HHP_LAYER_UI>
	
	// 更新する
	$$update_scene_object($stage)
	
	// 画面を更新する
	disp
}

//---------------------------------------------------------------------------
// サポート選択シーンを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage)
{
	property $i
	property $index
	property $chara_id
	
	// 選択キャラクター
	$chara_id = $select_btn - @ボタン_キャラクター
	
	// 背景／ベース
	$stage.object[@オブジェクト_背景].child[0].patno = $chara_id * 3 + 2
	
	// 背景／左上
	$stage.object[@オブジェクト_背景].child[1].patno = $chara_id * 3 + 1
	$stage.object[@オブジェクト_背景].child[1].y_rep[0] = -200
	$stage.object[@オブジェクト_背景].child[1].y_rep_eve[0].set(0, 250, 0, 2)
	
	// 背景／右下
	$stage.object[@オブジェクト_背景].child[2].patno = $chara_id * 3 + 0
	$stage.object[@オブジェクト_背景].child[2].y_rep[0] = 200
	$stage.object[@オブジェクト_背景].child[2].y_rep_eve[0].set(0, 250, 0, 2)
	
	// 選択キャラクター／影
	$stage.object[@オブジェクト_背景].child[3].patno = $chara_id * 2 + 1
	$stage.object[@オブジェクト_背景].child[3].x_rep[0] = 200
	$stage.object[@オブジェクト_背景].child[3].x_rep_eve[0].set(0, 250, 0, 2)
	$stage.object[@オブジェクト_背景].child[3].tr = 0
	$stage.object[@オブジェクト_背景].child[3].tr_eve.set(255, 150, 0, 2)
	
	// 選択キャラクター／本体
	$stage.object[@オブジェクト_背景].child[4].patno = $chara_id * 2
	$stage.object[@オブジェクト_背景].child[4].x_rep[0] = 100
	$stage.object[@オブジェクト_背景].child[4].x_rep_eve[0].set(0, 300, 150, 2)
	$stage.object[@オブジェクト_背景].child[4].tr = 0
	$stage.object[@オブジェクト_背景].child[4].tr_eve.set(255, 300, 150, 2)
	
	// キャラクター効果／名前
	$stage.object[@オブジェクト_背景].child[5].child[2].patno = $chara_id
	
	// キャラクター効果／奥義名
	$stage.object[@オブジェクト_背景].child[5].child[3].set_string($$get_hhp_skill_name($chara_id))
	
	// キャラクター効果／効果
	$stage.object[@オブジェクト_背景].child[5].child[4].set_string($$get_hhp_skill_description($chara_id))
	
	// キャラクターボタン
	for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
	{
		if( $$has_hhp_skill($i) )
		{
			$stage.object[@ボタン_キャラクター + $i].child[0].patno = $$get_hhp_skill_index_from_id($i)
			
			// 選択マーク
			$stage.object[@ボタン_キャラクター + $i].child[0].y_rep_eve[0].set(0, 100, 50, 2)
			$stage.object[@ボタン_キャラクター + $i].child[0].tr_eve.set(255, 50, 50, 2)
			$stage.object[@ボタン_キャラクター + $i].child[0].bright_eve.set(0, 100, 50, 2)
		}
		else
		{
			// 選択マーク
			$stage.object[@ボタン_キャラクター + $i].child[0].y_rep[0] = 20
			$stage.object[@ボタン_キャラクター + $i].child[0].tr = 0
			$stage.object[@ボタン_キャラクター + $i].child[0].bright = 255
		}
	}
	
	// 開始するボタン
	if( $$get_hhp_skill_count == 0 ) {
		$stage.object[@ボタン_ゲーム開始].set_button_state_disable
	} else {
		$stage.object[@ボタン_ゲーム開始].set_button_state_normal
	}
}

//---------------------------------------------------------------------------
// サポート選択シーンを破棄する
//---------------------------------------------------------------------------
command $$destroy_scene_object(property $stage : stage)
{
	property $i
	
	// すべてのイベントが終了するまで待つ
	$stage.object[@オブジェクト_背景].all_eve.wait
	
	// オブジェクトの初期化
	$stage.object[@オブジェクト_背景].init
	for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
	{
		$stage.object[@ボタン_キャラクター + $i].init
	}
	$stage.object[@ボタン_ゲーム開始].init
}

//---------------------------------------------------------------------------
// サポート選択シーンを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	property $i
	property $time
	property $scale
	
	// 選択枠／枠
	$stage.object[@オブジェクト_背景].child[5].x_rep[0] = 300
	$stage.object[@オブジェクト_背景].child[5].x_rep_eve[0].set(0, 350, 250, 2)
	$stage.object[@オブジェクト_背景].child[5].tr = 0
	$stage.object[@オブジェクト_背景].child[5].tr_eve.set(255, 350, 250, 2)
	
	// 選択枠／テキスト
	$stage.object[@オブジェクト_背景].child[5].child[0].y_rep[0] = 30
	$stage.object[@オブジェクト_背景].child[5].child[0].y_rep_eve[0].set(0, 250, 600, 2)
	$stage.object[@オブジェクト_背景].child[5].child[0].tr = 0
	$stage.object[@オブジェクト_背景].child[5].child[0].tr_eve.set(255, 250, 600, 2)
	
	// キャラクターボタン
	for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
	{
		$stage.object[@ボタン_キャラクター + $i].set_scale(0, 0)
	}
	
	// 開始ボタン
	$stage.object[@ボタン_ゲーム開始].set_scale(0, 0)
	
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
		
		// キャラクターボタン
		for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
		{
			$scale = math.timetable($time, 600 + $i * 150, 0, [0, 250, 1250, 2], [250, 400, 1000, 1], [400, 550, 1150, 2], [550, 650, 1000, 1], [650, 750, 1050, 2], [750, 800, 1000, 1], [800, 850, 1020, 2], [850, 900, 1000, 1])
			front.object[@ボタン_キャラクター + $i].set_scale($scale, $scale)
		}
		
		// 開始ボタン
		$scale = math.timetable($time, 1900, 0, [0, 250, 1250, 2], [250, 400, 1000, 1], [400, 550, 1150, 2], [550, 650, 1000, 1], [650, 750, 1050, 2], [750, 800, 1000, 1], [800, 850, 1020, 2], [850, 900, 1000, 1])
		front.object[@ボタン_ゲーム開始].set_scale($scale, $scale)
		
		input.next
		disp
	}
	
	//---------------------------------------------------------------------------
	// 表示演出終了
	
	// 選択枠／枠
	front.object[@オブジェクト_背景].child[5].all_eve.end
	
	// 選択枠／テキスト
	front.object[@オブジェクト_背景].child[5].child[0].all_eve.end
	
	// キャラクターボタン
	for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
	{
		front.object[@ボタン_キャラクター + $i].set_scale(1000, 1000)
		$$set_hhp_button(front.object[@ボタン_キャラクター + $i])
	}
	
	// 開始ボタン
	front.object[@ボタン_ゲーム開始].set_scale(1000, 1000)
	/*
	$$set_hhp_button(front.object[@ボタン_ゲーム開始])
	*/
	
	@mng_counter.stop
}

//---------------------------------------------------------------------------
// サポート選択シーンを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	property $i
	
	$stage.object[@オブジェクト_背景].disp = 0
	for( $i = 0, $i < <HHP_SKILL_ID_MAX>, $i += 1 )
	{
		$stage.object[@ボタン_キャラクター + $i].disp = 0
	}
	$stage.object[@ボタン_ゲーム開始].disp = 0
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	$stage.object[@ボタン_キャラクター + 0].joypad_up    = @ボタン_ゲーム開始
	$stage.object[@ボタン_キャラクター + 0].joypad_down  = @ボタン_キャラクター + 3
	$stage.object[@ボタン_キャラクター + 0].joypad_left  = @ボタン_キャラクター + 2
	$stage.object[@ボタン_キャラクター + 0].joypad_right = @ボタン_キャラクター + 1
	
	$stage.object[@ボタン_キャラクター + 1].joypad_up    = @ボタン_ゲーム開始
	$stage.object[@ボタン_キャラクター + 1].joypad_down  = @ボタン_キャラクター + 4
	$stage.object[@ボタン_キャラクター + 1].joypad_left  = @ボタン_キャラクター + 0
	$stage.object[@ボタン_キャラクター + 1].joypad_right = @ボタン_キャラクター + 2
	
	$stage.object[@ボタン_キャラクター + 2].joypad_up    = @ボタン_ゲーム開始
	$stage.object[@ボタン_キャラクター + 2].joypad_down  = @ボタン_キャラクター + 4
	$stage.object[@ボタン_キャラクター + 2].joypad_left  = @ボタン_キャラクター + 1
	$stage.object[@ボタン_キャラクター + 2].joypad_right = @ボタン_キャラクター + 0
	
	$stage.object[@ボタン_キャラクター + 3].joypad_up    = @ボタン_キャラクター + 0
	$stage.object[@ボタン_キャラクター + 3].joypad_down  = @ボタン_ゲーム開始
	$stage.object[@ボタン_キャラクター + 3].joypad_left  = @ボタン_キャラクター + 4
	$stage.object[@ボタン_キャラクター + 3].joypad_right = @ボタン_キャラクター + 4
	
	$stage.object[@ボタン_キャラクター + 4].joypad_up    = @ボタン_キャラクター + 1
	$stage.object[@ボタン_キャラクター + 4].joypad_down  = @ボタン_ゲーム開始
	$stage.object[@ボタン_キャラクター + 4].joypad_left  = @ボタン_キャラクター + 3
	$stage.object[@ボタン_キャラクター + 4].joypad_right = @ボタン_キャラクター + 3
	
	$stage.object[@ボタン_ゲーム開始].joypad_up    = @ボタン_キャラクター + 3
	$stage.object[@ボタン_ゲーム開始].joypad_down  = @ボタン_キャラクター + 0
	$stage.object[@ボタン_ゲーム開始].joypad_left  = -1
	$stage.object[@ボタン_ゲーム開始].joypad_right = -1
	
	// 次へボタンをデフォルトにする
	$$set_joypad_focus_button(@ボタン_キャラクター)
}
