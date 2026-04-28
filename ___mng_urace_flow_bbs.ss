//===========================================================================
//!
//!    @file     ___mng_urace_flow_bbs.ss
//!    @brief    ＵＭＡレース／掲示板画面
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
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景								0
	#replace	@ボタン_戻る									1
	#replace	@ボタン_厩舎									2
	#replace	@ボタン_スケジュール							3
	#replace	@ボタン_メダル									4
	#replace	@ボタン_図鑑									5
	#replace	@ボタン_名声									6
	#replace	@ボタン_レース									7
	#define		@ボタン_レース最大								(@ボタン_レース + <BBS_RACE_MAX>)
	#define		@ボタン_ハンター								(@ボタン_レース最大)
	#define		@ボタン_ハンター最大							(@ボタン_ハンター + <BBS_HUNTER_MAX>)
	#replace	@ボタン_デバッグ_ターン終了						19
	#replace	@オブジェクト_選択後共通						20
	#replace	@オブジェクト_モーダル_フィルター				21
	#replace	@オブジェクト_モーダル_メッセージウィンドウ		22
	#replace	@オブジェクト_モーダル_背景						23
	#replace	@ボタン_モーダル_はい							24
	#replace	@ボタン_モーダル_いいえ							25
	#replace	@オブジェクト_モーダル_ＵＭＡステータス			26
	#replace	@オブジェクト_モーダル_ＵＭＡリスト				27
	#define		@オブジェクト_モーダル_ＵＭＡリスト最大			(@オブジェクト_モーダル_ＵＭＡリスト + 20)
	
	// 変数
	#property	$select_btn						// 通常掲示板で選択しているボタン
	#property	$info_select_btn				// 各情報で選択しているボタン
	
#inc_end


//===========================================================================
// ＵＭＡ掲示板フロー
//===========================================================================
#z00

@ＵＭＡレースシーン設定

@bgm(bgm10)

$$create_scene_object(back)			// シーンオブジェクトを作成する
$$set_joypad_navigation(back)		// パッド入力の遷移を設定する
$$show_scene_object(back)			// シーンオブジェクトを表示する

// チュートリアルシナリオ
if( @ＵＭＡレース_チュートリアル進行度 == 1 ) {
	@ＵＭＡレースチュートリアルシナリオ(11)
}
if( @ＵＭＡレース_チュートリアル進行度 == 5 ) {
	@ＵＭＡレースチュートリアルシナリオ(15)
}

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_NORMAL>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_NORMAL>)
	
	// キャンセルは掲示板に戻るとして処理する
	if( $select_btn == -1 )
	{
		if( @ＵＭＡレース_チュートリアル進行度 == 0 )
		{
			$select_btn = @ボタン_戻る
		}
	}
	
	// 戻るボタンが押された場合
	if( $select_btn == @ボタン_戻る )
	{
		// 処理を終了する
		break
	}
	
	// 厩舎ボタンが押された場合
	elseif( $select_btn == @ボタン_厩舎 )
	{
		$$set_front_wipe_copy_all(0)		// 現在表示しているものをすべてワイプコピーをオフにする
		farcall(___mng_urace_flow_barn)		// 厩舎フローへ
		
		// オブジェクトを再作成する
		goto #z00
	}
	
	// スケジュールボタンが押された場合
	elseif( $select_btn == @ボタン_スケジュール )
	{
		farcall(___mng_urace_flow_schedule)		// レーススケジュール詳細フローへ
		
		$$set_joypad_focus_button($select_btn)	// 選択されたボタンをジョイパッドで選択中のボタンに再設定する
		$$update_joypad_focus_button(front)		// 選択されたボタンの描画を更新する
	}
	
	// メダルボタンが押された場合
	elseif( $select_btn == @ボタン_メダル )
	{
		farcall("___mng_urace_flow_medal")	// メダル詳細フローへ
		
		$$set_joypad_focus_button($select_btn)	// 選択されたボタンをジョイパッドで選択中のボタンに再設定する
		$$update_joypad_focus_button(front)		// 選択されたボタンの描画を更新する
	}
	
	// 図鑑ボタンが押された場合
	if( $select_btn == @ボタン_図鑑 )
	{
		$$set_front_wipe_copy_all(0)			// 現在表示しているものをすべてワイプコピーをオフにする
		farcall(___mng_urace_flow_library)		// 図鑑フローへ
		
		// オブジェクトを再作成する
		goto #z00
	}
	
	// 名声ボタンが押された場合
	elseif( $select_btn == @ボタン_名声 )
	{
		farcall(___mng_urace_flow_honor_info)	// 名声詳細フローへ
		
		$$set_joypad_focus_button($select_btn)	// 選択されたボタンをジョイパッドで選択中のボタンに再設定する
		$$update_joypad_focus_button(front)		// 選択されたボタンの描画を更新する
	}
	
	// レースボタンが押された場合
	if( @ボタン_レース <= $select_btn && $select_btn < @ボタン_レース最大 )
	{
		gosub #race_info		// レース情報フローへ
		
		// レースをプレイした場合は処理を終了する
		if( $$get_urace_played_race_in_bbs )
		{
			break
		}
	}
	
	// ハンターボタンが押された場合
	if( @ボタン_ハンター <= $select_btn && $select_btn < @ボタン_ハンター最大 )
	{
		gosub #hunter_request		// ハンター依頼フローへ
		
		// チュートリアル／ハンター
		if( @ＵＭＡレース_チュートリアル進行度 == 5 ) {
			if( $$get_bbs_hunter_request($select_btn - @ボタン_ハンター) == 2 )
			{
				break
			}
		}
		
		$$set_joypad_focus_button($select_btn)	// 選択されたボタンをジョイパッドで選択中のボタンに再設定する
		$$update_joypad_focus_button(front)		// 選択されたボタンの描画を更新する
	}
	
	// デバッグモードを更新する(各シーンからコールする側)
	$$update_urace_debug_mode($select_btn)
	
	// デバッグターン終了ボタンが押された場合
	if( $select_btn == @ボタン_デバッグ_ターン終了 )
	{
		// ＵＭＡレースで遊んだフラグを特殊な値に設定して終了する
		$$set_urace_played_race_in_bbs(-1)
		
		break
	}
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_NORMAL>)
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

// シーンオブジェクトを非表示にする
$$hide_scene_object(front)

@bgm_stop

@ＵＭＡレースシーン設定解除

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// 背景
	$stage.object[@オブジェクト_背景].create("__mng_ur_bbs_bg", 1)
	$stage.object[@オブジェクト_背景].wipe_copy = 1
	$stage.object[@オブジェクト_背景].child.resize(1)
	
	// タグ
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_bbs_tag", 1)
	
	// 各情報ボタン
	$$create_ui_button($stage.object[@ボタン_厩舎], "__mng_ur_bbs_barn_btn", 4, 972, @ボタン_厩舎, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_スケジュール], "__mng_ur_bbs_schedule_btn", 320, 972, @ボタン_スケジュール, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_メダル], "__mng_ur_bbs_medal_btn", 636, 972, @ボタン_メダル, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_図鑑], "__mng_ur_bbs_library_btn", 952, 972, @ボタン_図鑑, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_名声], "__mng_ur_bbs_honor_btn", 1268, 972, @ボタン_名声, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_戻る], "__mng_ur_bbs_back_btn", 1584, 972, @ボタン_戻る, <URACE_BTN_GROUP_NORMAL>, 1)
	
	// レースボタン
	if( @ＵＭＡレース_チュートリアル進行度 != 5 )
	{
		$len = $$get_bbs_race_num
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$create_ui_button($stage.object[@ボタン_レース], "__mng_ur_bbs_race_btn" + math.tostr_zero($$get_bbs_race($i), 2), 706, 210, @ボタン_レース, <URACE_BTN_GROUP_NORMAL>, 1)
		}
	}
	
	//グランドカップ前に敗退の場合はハンターは表示されない
	if( @グランドカップ前に敗退した == 0 && @ＵＭＡレース_チュートリアル進行度 != 1 )
	{
		// ハンターボタン
		$len = $$get_bbs_hunter_num
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$create_bbs_hunter_button($stage.object[@ボタン_ハンター + $i], $i)
		}
	}
	
	if( @グランドカップ前に敗退した )
	{
		$stage.object[@ボタン_ハンター].create_string("グランドカップ前に敗退した", 1, 600, 500)
		$stage.object[@ボタン_ハンター].set_string_param(60, 1, 5, 100, 0, 1, 2, 1)
	}
	
	// デバッグ処理
	if( $$check_debug_mode_enable )
	{
		// デバッグモードを作成する(各シーンからコールする側)
		$$create_urace_debug_mode(<URACE_BTN_GROUP_NORMAL>, 0)
		
		// ターンスキップ用のデバッグボタンを作成する
		$$create_mng_debug_button($stage.object[@ボタン_デバッグ_ターン終了], 10, 930, @ボタン_デバッグ_ターン終了, <URACE_BTN_GROUP_NORMAL>, "[デバッグボタン]何もしないで終了", "#F7402F", 1)
	}
	
	// シーンオブジェクトを更新する
	$$update_scene_object($stage)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage)
{
	property $i
	property $len
	property $flag
	
	// 所持ＵＭＡがいない場合は厩舎ボタンは選択できないようにする
	if( $$get_my_uma_num == 0 ) {
		$stage.object[@ボタン_厩舎].set_button_state_disable
	}
	
	//グランドカップ前に敗退の場合はハンター／トレーナーは表示されない
	if( @グランドカップ前に敗退した == 0 && @ＵＭＡレース_チュートリアル進行度 != 1 )
	{
		// ハンターボタン
		$len = $$get_bbs_hunter_num
		for( $i = 0, $i < $len, $i += 1 )
		{
			if( $$get_bbs_hunter_request($i) == 2 ) {
				$flag = 1
			}
		}
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			if( $flag ) {
				$stage.object[@ボタン_ハンター + $i].set_button_state_disable
			}
		}
	}
	
	// チュートリアル遷移時のボタン表示／非表示
	if( @ＵＭＡレース_チュートリアル進行度 == 1 || @ＵＭＡレース_チュートリアル進行度 == 5 )
	{
		$stage.object[@ボタン_厩舎].set_button_state_disable
		$stage.object[@ボタン_スケジュール].set_button_state_disable
		$stage.object[@ボタン_メダル].set_button_state_disable
		$stage.object[@ボタン_図鑑].set_button_state_disable
		$stage.object[@ボタン_名声].set_button_state_disable
		$stage.object[@ボタン_戻る].set_button_state_disable
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	// ワイプ
	wipe(0, 250, wait=1)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	$$set_front_wipe_copy_all(0)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	
	// レースボタンが存在している場合はレースボタン
	if( $stage.object[@ボタン_レース].f.get_size )
	{
		$$set_joypad_focus_button(@ボタン_レース)
	}
	
	// レースボタンが存在していない場合はハンターボタン
	else
	{
		$$set_joypad_focus_button(@ボタン_ハンター)
	}
	
	if( $stage.object[@ボタン_ハンター + 0].f.get_size ) {
		$stage.object[@ボタン_ハンター + 0].joypad_up    = @ボタン_スケジュール
		$stage.object[@ボタン_ハンター + 0].joypad_down  = @ボタン_ハンター + 2
		$stage.object[@ボタン_ハンター + 0].joypad_left  = @ボタン_ハンター + 1
		$stage.object[@ボタン_ハンター + 0].joypad_right = @ボタン_レース
	}
	
	if( $stage.object[@ボタン_ハンター + 1].f.get_size ) {
		$stage.object[@ボタン_ハンター + 1].joypad_up    = @ボタン_厩舎
		$stage.object[@ボタン_ハンター + 1].joypad_down  = @ボタン_厩舎
		$stage.object[@ボタン_ハンター + 1].joypad_left  = @ボタン_ハンター + 4
		$stage.object[@ボタン_ハンター + 1].joypad_right = @ボタン_ハンター + 0
	}
	
	if( $stage.object[@ボタン_ハンター + 2].f.get_size ) {
		$stage.object[@ボタン_ハンター + 2].joypad_up    = @ボタン_ハンター + 0
		$stage.object[@ボタン_ハンター + 2].joypad_down  = @ボタン_スケジュール
		$stage.object[@ボタン_ハンター + 2].joypad_left  = @ボタン_ハンター + 1
		$stage.object[@ボタン_ハンター + 2].joypad_right = @ボタン_レース
	}
	
	if( $stage.object[@ボタン_ハンター + 3].f.get_size ) {
		$stage.object[@ボタン_ハンター + 3].joypad_up    = @ボタン_名声
		$stage.object[@ボタン_ハンター + 3].joypad_down  = @ボタン_ハンター + 5
		$stage.object[@ボタン_ハンター + 3].joypad_left  = @ボタン_レース
		$stage.object[@ボタン_ハンター + 3].joypad_right = @ボタン_ハンター + 4
	}
	
	if( $stage.object[@ボタン_ハンター + 4].f.get_size ) {
		$stage.object[@ボタン_ハンター + 4].joypad_up    = @ボタン_戻る
		$stage.object[@ボタン_ハンター + 4].joypad_down  = @ボタン_戻る
		$stage.object[@ボタン_ハンター + 4].joypad_left  = @ボタン_ハンター + 3
		$stage.object[@ボタン_ハンター + 4].joypad_right = @ボタン_ハンター + 1
	}
	
	if( $stage.object[@ボタン_ハンター + 5].f.get_size ) {
		$stage.object[@ボタン_ハンター + 5].joypad_up    = @ボタン_ハンター + 3
		$stage.object[@ボタン_ハンター + 5].joypad_down  = @ボタン_名声
		$stage.object[@ボタン_ハンター + 5].joypad_left  = @ボタン_レース
		$stage.object[@ボタン_ハンター + 5].joypad_right = @ボタン_ハンター + 4
	}
	
	if( $stage.object[@ボタン_レース].f.get_size ) {
		$stage.object[@ボタン_レース].joypad_up    = @ボタン_メダル
		$stage.object[@ボタン_レース].joypad_down  = @ボタン_メダル
		$stage.object[@ボタン_レース].joypad_left  = @ボタン_ハンター + 0
		$stage.object[@ボタン_レース].joypad_right = @ボタン_ハンター + 3
	}
	
	$stage.object[@ボタン_厩舎].joypad_up    = @ボタン_ハンター + 1
	$stage.object[@ボタン_厩舎].joypad_down  = @ボタン_ハンター + 1
	$stage.object[@ボタン_厩舎].joypad_left  = @ボタン_戻る
	$stage.object[@ボタン_厩舎].joypad_right = @ボタン_スケジュール
	
	$stage.object[@ボタン_スケジュール].joypad_up    = @ボタン_ハンター + 2
	$stage.object[@ボタン_スケジュール].joypad_down  = @ボタン_ハンター + 0
	$stage.object[@ボタン_スケジュール].joypad_left  = @ボタン_厩舎
	$stage.object[@ボタン_スケジュール].joypad_right = @ボタン_メダル
	
	$stage.object[@ボタン_メダル].joypad_up    = @ボタン_レース
	$stage.object[@ボタン_メダル].joypad_down  = @ボタン_レース
	$stage.object[@ボタン_メダル].joypad_left  = @ボタン_スケジュール
	$stage.object[@ボタン_メダル].joypad_right = @ボタン_図鑑
	
	$stage.object[@ボタン_図鑑].joypad_up    = @ボタン_レース
	$stage.object[@ボタン_図鑑].joypad_down  = @ボタン_レース
	$stage.object[@ボタン_図鑑].joypad_left  = @ボタン_メダル
	$stage.object[@ボタン_図鑑].joypad_right = @ボタン_名声
	
	$stage.object[@ボタン_名声].joypad_up    = @ボタン_ハンター + 5
	$stage.object[@ボタン_名声].joypad_down  = @ボタン_ハンター + 3
	$stage.object[@ボタン_名声].joypad_left  = @ボタン_図鑑
	$stage.object[@ボタン_名声].joypad_right = @ボタン_戻る
	
	$stage.object[@ボタン_戻る].joypad_up    = @ボタン_ハンター + 4
	$stage.object[@ボタン_戻る].joypad_down  = @ボタン_ハンター + 4
	$stage.object[@ボタン_戻る].joypad_left  = @ボタン_名声
	$stage.object[@ボタン_戻る].joypad_right = @ボタン_厩舎
}

//---------------------------------------------------------------------------
// ハンター依頼ボタンを作成する
//---------------------------------------------------------------------------
command $$create_bbs_hunter_button(property $obj : object, property $index)
{
	property $hunter_id
	property $x
	property $y
	
	$hunter_id = $$get_bbs_hunter($index)
	
	// チュートリアル中は表示位置を調整する
	if( @ＵＭＡレース_チュートリアル進行度 == 5 )
	{
		switch( $index ) {
		case(0)		$x = 366		$y = 360
		case(1)		$x = 796		$y = 360
		case(2)		$x = 1294		$y = 360
		}
	}
	else
	{
		switch( $index ) {
		case(0)		$x = 353		$y = 105
		case(1)		$x = 68			$y = 360
		case(2)		$x = 366		$y = 583
		case(3)		$x = 1294		$y = 122
		case(4)		$x = 1602		$y = 360
		case(5)		$x = 1294		$y = 582
		}
	}
	
	$$create_ui_button($obj, "__mng_ur_bbs_hunter_btn" + math.tostr_zero($hunter_id, 2), $x, $y, @ボタン_ハンター + $index, <URACE_BTN_GROUP_NORMAL>, 1)
	
	
	// ベースボタン
;	if( $$get_db_hunter_rarity($hunter_id) == 1 ) {
;		$$create_ui_button($obj, __mng_ur_bbs_hunter_btn0, $x, $y, @ボタン_ハンター + $index, <URACE_BTN_GROUP_NORMAL>, 1)
;		$obj.set_center_rep($obj.get_size_x, $obj.get_size_y)
;		$$set_urace_button($obj)
;	} else {
;		$$create_ui_button($obj, __mng_ur_bbs_hunter_btn + math.tostr(1), $x, $y, @ボタン_ハンター + $index, <URACE_BTN_GROUP_NORMAL>, 1)
;		$$create_ui_button($obj, __mng_ur_bbs_hunter_btn + math.tostr($$get_db_hunter_rarity($hunter_id)), $x, $y, @ボタン_ハンター + $index, <URACE_BTN_GROUP_NORMAL>, 1)
;	}
	$obj.child.resize(5)
	
	// キャラ
;	$obj.child[1].create(__mng_ur_bbs_hunter_image02, 1, 36, 67)
	
	// 名前
;	$obj.child[2].create(__mng_ur_bbs_hunter_name, 1, 41, 306, $hunter_id - 1)
	
}

//---------------------------------------------------------------------------
// deb 依頼書(ハンター)オブジェクトのテキストを作成する
//---------------------------------------------------------------------------
command $$create_ht_request_text_object(property $obj : object, property $id)
{
	property $i
	property $value
	
	// 背景
	$obj.child.resize(5)
	$obj.child[0].create(__mng_ur_bbs_request_frame, 1, 0, 0, $$get_db_hunter_rarity($id) - 1)
	
	// キャラ
	$obj.child[1].create(_mng_ur_bbs_chara_btn + math.tostr_zero($$get_db_hunter_image_no($id), 2), 1, 20, 50)
	$obj.child[1].set_scale(800, 800)
	
	// 名前
	$$create_centering_text($obj.child[2], $$get_db_hunter_name($id), 10, 285, 220, 26, 25, 0)
	
	// 依頼済み
	$obj.child[4].create(_mng_ur_bbs_chara_btn_request, 0, 7, 7)
}

//---------------------------------------------------------------------------
// deb 依頼書(ハンター/トレーナー)オブジェクトを依頼済みにする
//---------------------------------------------------------------------------
command $$set_ht_request_complete(property $obj : object, property $type)
{
	$obj.child[4].disp = $type
	if( $type == 1 || $type == 2 ) {
		$obj.set_button_state_disable
	}
}

//---------------------------------------------------------------------------
// deb 中央寄せテキストを作成する
//---------------------------------------------------------------------------
command $$create_centering_text(property $obj : object, property $text : str, property $x, property $y, property $w, property $h, property $font_size, property $font_color)
{
	$$create_ui_string($obj, $x, $y, $w, $h, $font_size)
	$obj.f_align = <STRING_ALIGN_CENTER>
	$$update_ui_string_param($obj, $font_size, 1, 5, 100, $font_color, -1, -1, -1)
	$$update_ui_string($obj, $text)
}


//===========================================================================
// 選択後共通
//===========================================================================

//---------------------------------------------------------------------------
// 選択後／共通メッセージウィンドウオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_bbs_common_message_window(property $stage : stage, property $type)
{
	// フィルター
	$stage.object[@オブジェクト_選択後共通].create("__mng_ur_bbs_mw_filter", 1)
	$stage.object[@オブジェクト_選択後共通].child.resize(3)
	
	// メッセージウィンドウ
	$stage.object[@オブジェクト_選択後共通].child[0].create("__mng_ur_bbs_mw_bg", 1, 1130, 918)
	$stage.object[@オブジェクト_選択後共通].child[0].x_rep.resize(1)
	
	// メッセージウィンドウ／テキスト
	$stage.object[@オブジェクト_選択後共通].child[1].create_string("", 1, 1162, 941)
	$stage.object[@オブジェクト_選択後共通].child[1].set_string_param(28, 1, 4, 17, 0, 0, -1)
	$stage.object[@オブジェクト_選択後共通].child[1].set_string($$get_urace_bbs_select_player_text($type))
	
	// キャラ
	$stage.object[@オブジェクト_選択後共通].child[2].create("__mng_ur_bbs_mw_chara", 1, 1647, 798)
	$stage.object[@オブジェクト_選択後共通].child[2].x_rep.resize(1)
	
	//---------------------------------------------------------------------------
	// アニメーション
	
	// メッセージウィンドウ
	$stage.object[@オブジェクト_選択後共通].child[0].x_rep[0] = 800
	$stage.object[@オブジェクト_選択後共通].child[0].x_rep_eve[0].set(0, 300, 0, 2)
	
	// メッセージウィンドウ／テキスト
	$stage.object[@オブジェクト_選択後共通].child[1].tr = 0
	$stage.object[@オブジェクト_選択後共通].child[1].tr_eve.set(255, 300, 300, 2)
	
	// キャラ
	$stage.object[@オブジェクト_選択後共通].child[2].x_rep[0] = 300
	$stage.object[@オブジェクト_選択後共通].child[2].x_rep_eve[0].set(0, 300, 300, 2)
}



//===========================================================================
// レース情報詳細フロー
//===========================================================================
#race_info

// レース情報詳細オブジェクトを作成する
$$create_bbs_race_info_object(front)

// 選択後／共通メッセージウィンドウオブジェクトを作成する
if( @ＵＭＡレース_チュートリアル進行度 == 1 )
{
	// チュートリアルとそうでないときでテキストを変更する
	$$create_bbs_common_message_window(front, 2)
}
else
{
	$$create_bbs_common_message_window(front, 0)
}

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_MODAL>)

while(1)
{
	// 入力制御を更新する
	$info_select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
	
	// キャンセルはいいえボタンとして処理する
	if( $info_select_btn == -1 )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$info_select_btn = @ボタン_モーダル_いいえ
	}
	
	// いいえボタンが押された場合
	if( $info_select_btn == @ボタン_モーダル_いいえ )
	{
		// 処理を終了する
		break
	}
	
	// はいボタンが押された場合
	if( $info_select_btn == @ボタン_モーダル_はい )
	{
		if( $$has_entry_race_uma == 0 )
		{
			;clear
			;farcall(@ＵＭＡレースシナリオファイル, 501)R
		}
		
		elseif( @ボタン_レース <= $select_btn &&  $select_btn < @ボタン_レース最大 )
		{
			// レースIDを設定する
			$$set_entry_race_id($$get_bbs_race($select_btn - @ボタン_レース))
			
			clear
			close
			
			$$set_urace_played_race_in_bbs(1)
			
			// レースデータを初期化する
			$$init_entry_race_data
			
			// レースIDを設定する
			$$set_entry_race_id($$get_bbs_race($select_btn - @ボタン_レース))
			
			// 参加者を設定する
			$$set_urace_npc_race_entry_data
		}
		
		break
	}
	
	// 何らかのボタンが押されている場合
	if( $info_select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_MODAL>)
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

// レース情報詳細オブジェクトを非表示にする
$$hide_bbs_race_info_object(front)

return


//---------------------------------------------------------------------------
// レース情報詳細オブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_bbs_race_info_object(property $stage : stage)
{
	property $i
	property $len
	property $race_id
	property $owner_id
	
	// 選択したレースIDを取得する
	$race_id = $$get_bbs_race($select_btn - @ボタン_レース)
	
	// 背景
	$stage.object[@オブジェクト_モーダル_背景].create("__mng_ur_bbs_race_bg", 1, 418, 218)
	$stage.object[@オブジェクト_モーダル_背景].child.resize(6)
	
	// レースロゴ
	$stage.object[@オブジェクト_モーダル_背景].child[0].create("__mng_ur_bbs_race_logo", 1, 94, 62, $race_id - 1)
	
	// レース情報／開催日
	$stage.object[@オブジェクト_モーダル_背景].child[2].create_number("__mng_ur_bbs_race_info_number", 1, 313, 372)
	$stage.object[@オブジェクト_モーダル_背景].child[2].set_number_param(2, 1, 0, 0, 0, 0)
	$stage.object[@オブジェクト_モーダル_背景].child[2].set_number(@日付_日)
	
	// レース情報／距離
	$stage.object[@オブジェクト_モーダル_背景].child[3].create_number("__mng_ur_bbs_race_info_number", 1, 262, 410)
	$stage.object[@オブジェクト_モーダル_背景].child[3].set_number_param(4, 0, 0, 0, 0, -1)
	$stage.object[@オブジェクト_モーダル_背景].child[3].set_number($$get_db_race_distance($race_id))
	
	// レース情報／地形タイプ
	$stage.object[@オブジェクト_モーダル_背景].child[4].create("__mng_ur_bbs_race_info_ground", 1, 276, 447, $$get_db_race_ground_type($race_id) - 1)
	
	// 参加するオーナー
	$len = <URACE_ENTRY_MAX> - 1
	
	$stage.object[@オブジェクト_モーダル_背景].child[5].disp = 1
	$stage.object[@オブジェクト_モーダル_背景].child[5].child.resize($len)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$owner_id = $$get_db_race_entry_owner($race_id, $i)
		
		if( $owner_id == 0 ) {
			continue
		}
		
		$$create_bbs_race_entry_owner_object($stage.object[@オブジェクト_モーダル_背景].child[5].child[$i], $owner_id, 490, 79 + $i * 86)
	}
	
	// レース参加はい／いいえボタン
	$$create_ui_button($stage.object[@ボタン_モーダル_はい], __mng_ur_bbs_race_yes_btn, 587, 735, @ボタン_モーダル_はい, <URACE_BTN_GROUP_MODAL>, 1)
	$$create_ui_button($stage.object[@ボタン_モーダル_いいえ], __mng_ur_bbs_race_no_btn, 1001, 735, @ボタン_モーダル_いいえ, <URACE_BTN_GROUP_MODAL>, 2)
}

// 参加キャラクター
command $$create_bbs_race_entry_owner_object(property $obj : object, property $owner_id, property $x, property $y)
{
	property $patno
	
	// 背景
	if( $owner_id != $$get_db_race_entry_rival($$get_bbs_race($select_btn - @ボタン_レース)) ) {
		$patno = 1
	}
	
	$obj.create("__mng_ur_bbs_race_owner_bg", 1, $x, $y, $patno)
	$obj.child.resize(3)
	
	///*
	// キャラクター
	$obj.child[0].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($owner_id), 2), 1, 8, 5)
	$obj.child[0].set_scale(510, 510)
	
	// 称号
	$obj.child[1].create_string($$get_db_owner_title($owner_id), 1, 146, 12)
	$obj.child[1].set_string_param(18, 0, 0, 20, 0, 0, 0)
	
	// 名前
	$obj.child[2].create_string($$get_db_owner_name($owner_id), 1, 144, 36)
	$obj.child[2].set_string_param(26, 0, 0, 14, 0, 0, 0)
	//*/
}

//---------------------------------------------------------------------------
// レース情報詳細オブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_bbs_race_info_object(property $stage : stage)
{
	// メッセ―ウィンドウのテキストを消去
	clear
	close
	
	// モーダルオブジェクトのワイプコピーをオフにする
	$$set_front_wipe_copy(0, @オブジェクト_モーダル_フィルター, @ボタン_モーダル_いいえ + 1)
	
	// ワイプ
	wipe(0, 150, wait=1)
}



//===========================================================================
// ハンター依頼フロー
//===========================================================================
#hunter_request

$$create_hunter_request_object(front)			// ハンター依頼オブジェクトを作成する
$$set_hunter_request_joypad_navigation(front)	// パッド入力の遷移を設定する
$$create_bbs_common_message_window(front, 1)	// 選択後／共通メッセージウィンドウオブジェクトを作成する

// 分岐テキストへ
$$call_hunter_scene_text

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_MODAL>)

while(1)
{
	// 入力制御を更新する
	$info_select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
	
	// キャンセルはいいえボタンとして処理する
	if( $info_select_btn == -1 )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$info_select_btn = @ボタン_モーダル_いいえ
	}
	
	// いいえボタンが押された場合
	if( $info_select_btn == @ボタン_モーダル_いいえ )
	{
		// 処理を終了する
		break
	}
	
	// はいボタンが押された場合
	if( $info_select_btn == @ボタン_モーダル_はい )
	{
		// 依頼キャンセル
		if( $$get_bbs_hunter_request($select_btn - @ボタン_ハンター) )
		{
			// ハンター依頼フラグを解除する
			$$set_bbs_hunter_request($select_btn - @ボタン_ハンター, 0)
		}
		
		// 依頼実行
		else
		{
			// ハンター依頼フラグを設定する
			$$set_bbs_hunter_request($select_btn - @ボタン_ハンター, 1)
			
			// ＵＭＡ捕獲フローへ
			farcall("___mng_urace_flow_uma_capture", 0, $select_btn - @ボタン_ハンター)
			
			if( @ＵＭＡレース_チュートリアル進行度 == 5 ) {
				goto #end
			}
		}
		
		break
	}
	
	// 何らかのボタンが押されている場合
	if( $info_select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_MODAL>)
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

#end

// ハンター情報詳細オブジェクトを非表示にする
$$hide_bbs_hunter_request_object(front)

// シーンオブジェクトを更新する
$$update_scene_object(front)

return


//---------------------------------------------------------------------------
// ハンター依頼オブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_hunter_request_object(property $stage : stage)
{
	property $hunter_id
	property $rarity
	property $image_no
	
	// 各情報を取得する
	$hunter_id = $$get_bbs_hunter($select_btn - @ボタン_ハンター)
	$rarity = $$get_db_hunter_rarity($hunter_id)
	$image_no = $$get_db_hunter_image_no($hunter_id)
	
	// 背景
	$stage.object[@オブジェクト_モーダル_背景].create("__mng_ur_bbs_hunter_request_bg", 1, 421, 224)
	$stage.object[@オブジェクト_モーダル_背景].child.resize(6)
	
	// キャラ画像
	$stage.object[@オブジェクト_モーダル_背景].child[0].create("__mng_ur_bbs_hunter_request_image" + math.tostr_zero($image_no, 2), 1, 56, 103)
	
	// 詳細
	$stage.object[@オブジェクト_モーダル_背景].child[1].create("__mng_ur_bbs_hunter_request_info", 1, 451, 92, $rarity - 1)
	
	// 詳細／テキスト
	$stage.object[@オブジェクト_モーダル_背景].child[2].create_string($$get_urace_hunter_info_text($hunter_id), 1, 493, 190)
	$stage.object[@オブジェクト_モーダル_背景].child[2].set_string_param(23, 0, 4, 22, 50, 0, 0)
	
	// 名前
	$stage.object[@オブジェクト_モーダル_背景].child[3].create("__mng_ur_bbs_hunter_request_name", 1, 479, 114, $hunter_id - 1)
	
	// メッセージウィンドウ
	$stage.object[@オブジェクト_モーダル_背景].child[4].create("__mng_ur_bbs_hunter_request_message", 1, 445, 332, $rarity - 1)
	
	// メッセージウィンドウ／テキスト
	$stage.object[@オブジェクト_モーダル_背景].child[5].create_string($$get_urace_hunter_commnet_text($hunter_id), 1, 561, 374)
	$stage.object[@オブジェクト_モーダル_背景].child[5].set_string_param(25, 0, 4, 15, 0, 0, 0)
	
	// 依頼する／しないボタン
	$$create_ui_button($stage.object[@ボタン_モーダル_はい], "__mng_ur_bbs_hunter_request_yes_btn", 587, 724, @ボタン_モーダル_はい, <URACE_BTN_GROUP_MODAL>, 1)
	$$create_ui_button($stage.object[@ボタン_モーダル_いいえ], "__mng_ur_bbs_hunter_request_no_btn", 1001, 724, @ボタン_モーダル_いいえ, <URACE_BTN_GROUP_MODAL>, 2)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_hunter_request_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_モーダル_はい)
	
	$stage.object[@ボタン_モーダル_はい].joypad_up    = -1
	$stage.object[@ボタン_モーダル_はい].joypad_down  = -1
	$stage.object[@ボタン_モーダル_はい].joypad_left  = @ボタン_モーダル_いいえ
	$stage.object[@ボタン_モーダル_はい].joypad_right = @ボタン_モーダル_いいえ
	
	$stage.object[@ボタン_モーダル_いいえ].joypad_up    = -1
	$stage.object[@ボタン_モーダル_いいえ].joypad_down  = -1
	$stage.object[@ボタン_モーダル_いいえ].joypad_left  = @ボタン_モーダル_はい
	$stage.object[@ボタン_モーダル_いいえ].joypad_right = @ボタン_モーダル_はい
}

//---------------------------------------------------------------------------
// ハンター情報詳細オブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_bbs_hunter_request_object(property $stage : stage)
{
	// メッセ―ウィンドウのテキストを消去
	clear
	close
	
	// モーダルオブジェクトのワイプコピーをオフにする
	$$set_front_wipe_copy(0, @オブジェクト_モーダル_フィルター, @ボタン_モーダル_いいえ + 1)
	
	// ワイプ
	wipe(0, 150, wait=1)
}

//---------------------------------------------------------------------------
// ハンター分岐テキストへ遷移する
//---------------------------------------------------------------------------
command $$call_hunter_scene_text
{
	clear
	
	if( $$get_bbs_hunter_request($select_btn - @ボタン_ハンター) )
	{
		// ハンター依頼をキャンセルするとき
		;farcall(@ＵＭＡレースシナリオファイル, 551)
	}
	else
	{
		// ハンター依頼を選択したとき
		;farcall(@ＵＭＡレースシナリオファイル, 550)
	}
}
