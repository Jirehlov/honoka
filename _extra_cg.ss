//===========================================================================
//!
//!    @file     _extra_cg.ss
//!    @brief    イベントＣＧ鑑賞シーン(アプリケーション側)
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   [ここにアプリケーションごとの担当者の名前を記述してください]
//!    @note     レイアウトなどアプリケーションごとに挙動を調整する必要がある処理
//!
//===========================================================================

#z00

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_extra_cg_scene_object(property $stage : stage)
{
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 0], _extra_cg_page_btn01, 0, 259, @ボタン_エクストラ_ＣＧ_ページ + 0, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 1], _extra_cg_page_btn02, 0, 314, @ボタン_エクストラ_ＣＧ_ページ + 1, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 2], _extra_cg_page_btn03, 0, 369, @ボタン_エクストラ_ＣＧ_ページ + 2, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 3], _extra_cg_page_btn04, 0, 424, @ボタン_エクストラ_ＣＧ_ページ + 3, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 4], _extra_cg_page_btn05, 0, 479, @ボタン_エクストラ_ＣＧ_ページ + 4, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 5], _extra_cg_page_btn06, 0, 534, @ボタン_エクストラ_ＣＧ_ページ + 5, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 6], _extra_cg_page_btn07, 0, 589, @ボタン_エクストラ_ＣＧ_ページ + 6, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 7], _extra_cg_page_btn08, 0, 644, @ボタン_エクストラ_ＣＧ_ページ + 7, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 8], _extra_cg_page_btn09, 0, 699, @ボタン_エクストラ_ＣＧ_ページ + 8, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 9], _extra_cg_page_btn10, 0, 754, @ボタン_エクストラ_ＣＧ_ページ + 9, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 10], _extra_cg_page_btn11, 0, 809, @ボタン_エクストラ_ＣＧ_ページ + 10, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 11], _extra_cg_page_btn12, 0, 864, @ボタン_エクストラ_ＣＧ_ページ + 11, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_ページ + 12], _extra_cg_page_btn13, 0, 919, @ボタン_エクストラ_ＣＧ_ページ + 12, <OBJBTN_GROUP_NO_EXCALL>, 4)
	$$create_ui_image($stage.object[0], _extra_cg_bg01, 0, 0)
	$$create_ui_image($stage.object[1], _extra_cg_ch, 1320, 0)
	$$create_ui_image($stage.object[2], _extra_cg_ch_name, 431, 136)
	$$create_overlay_thumb_button($stage, _extra_cg_thumb_btn, 421, 267, 270, 161, 4, 4)
	$$create_ui_image($stage.object[@イメージ_エクストラ_達成率_背景], _extra_cg_complete_bg, 1302, 0)
	$$create_extra_cg_complete_number($stage.object[@イメージ_エクストラ_達成率_数値], _extra_cg_complete_number, 1349, 92)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
// - 毎フレーム処理を追加することができます
//---------------------------------------------------------------------------
command $$update_extra_cg_scene_object(property $stage : stage, property $select_btn)
{
	// 音楽プレイヤーの更新
	$select_btn = $$update_extra_music_player($select_btn)
	
	// 音楽プレイヤーのボタンが押された場合
	if( $select_btn != -2 )
	{
		// 音楽プレイヤーオブジェクトの更新
		$$update_extra_music_player_object($stage)
		
		// 入力制御を再開始する
		$$input_start(excall.front, <OBJBTN_GROUP_NO_EXCALL>)
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトの再描画
// - ページ、サムネイルなどを再描画する際の処理を追加することができます
//---------------------------------------------------------------------------
command $$redraw_extra_cg_scene_object(property $stage : stage, property $redraw_type)
{
	// タブ切り替えによる描画更新が行われた場合
	if( $redraw_type == @エクストラ_ＣＧ_描画更新_タブ切り替え )
	{
		// パッド入力の遷移を再設定する
		$$set_extra_cg_joypad_navigation($stage)
		$$set_extra_cg_sound_player_joypad_navigation($stage)
	}
	elseif( $redraw_type == @エクストラ_ＣＧ_描画更新_ページ切り替え )
	{
		// 背景／キャラ／キャラ名を現在のページに合わせる
		$stage.object[0].change_file(_extra_cg_bg + math.tostr_zero(@エクストラ_ＣＧ_現在のページ + 1, 2))
		$stage.object[1].patno = @エクストラ_ＣＧ_現在のページ
		$stage.object[2].patno = @エクストラ_ＣＧ_現在のページ
		
		// キャラの移動
		$stage.object[1].x_rep[0] = 100
		$stage.object[1].x_rep_eve[0].set(0, 500, 0, 2)
		$stage.object[1].tr_rep[0] = 0
		$stage.object[1].tr_rep_eve[0].set(255, 500, 0, 2)
		
		// 名前の移動
		$stage.object[2].x_rep[0] = 100
		$stage.object[2].x_rep_eve[0].set(0, 500, 0, 2)
		$stage.object[2].tr_rep[0] = 0
		$stage.object[2].tr_rep_eve[0].set(255, 500, 0, 2)
		
		// サムネイルボタンにフォーカスがある場合はフォーカスを最初のサムネイルに設定する
		if( @ボタン_エクストラ_ＣＧ_サムネイル <= $$get_joypad_focus_button ) {
			$$set_joypad_focus_button(@ボタン_エクストラ_ＣＧ_サムネイル + 0)
		}
		
		// パッド入力の遷移を再設定する
		$$set_extra_cg_joypad_navigation($stage)
		$$set_extra_cg_sound_player_joypad_navigation($stage)
	}
	
	// ワイプ(ジョイパッドのＲ１がキースキップするのでキースキップできないようにする)
	wipe(0, 150, wait=1, key_skip=0)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
// - シーン表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$show_extra_cg_scene_object(property $stage : stage)
{
	
	// 音楽プレイヤーの作成
	$$init_extra_music_player
	$$create_extra_sound_player_object($stage)
	$$update_extra_music_player_object($stage)
	$$set_extra_sound_player_joypad_navigation($stage)
	$$set_extra_cg_sound_player_joypad_navigation($stage)
	
	// ヘッダー
	$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].set_button_state_select
	$stage.object[@ボタン_エクストラ_ヘッダー_レコード].set_button_state_normal
	
	// 背景／キャラ／キャラ名を現在のページに合わせる
	$stage.object[0].change_file(_extra_cg_bg + math.tostr_zero(@エクストラ_ＣＧ_現在のページ + 1, 2))
	$stage.object[1].patno = @エクストラ_ＣＧ_現在のページ
	$stage.object[2].patno = @エクストラ_ＣＧ_現在のページ
	
	// 達成率の数字／座標を設定する
	if( @エクストラ_ＣＧ達成率 >= 100 )
	{
		// １００％は専用の画像
		$$create_ui_image($stage.object[@イメージ_エクストラ_達成率_数値１００], _record_number100, 1349, 97)
		$stage.object[@イメージ_エクストラ_達成率_数値].disp = 0
	}
	elseif( @エクストラ_ＣＧ達成率 < 10 )
	{
		$stage.object[@イメージ_エクストラ_達成率_数値].x = 1293
		$stage.object[@イメージ_エクストラ_達成率_数値].set_number_param(3, 0, 0, 0, 0, 4)
	}
	else
	{
		$stage.object[@イメージ_エクストラ_達成率_数値].x = 1317
		$stage.object[@イメージ_エクストラ_達成率_数値].set_number_param(3, 0, 0, 0, 0, 4)
	}
	
	// アネモイルートをクリアしていない場合はグランドページを表示しない
	if( @アネモイルートクリア == 0 ) {
		// ページ最大数を上書き
		$$set_extra_cg_page_max($$get_system_disp_object_max($stage, @ボタン_エクストラ_ＣＧ_ページ, @ボタン_エクストラ_ＣＧ_ページ最大) - @ボタン_エクストラ_ＣＧ_ページ - 1)
		$stage.object[@ボタン_エクストラ_ＣＧ_ページ + 12].disp = 0
	}
	
	// キャラ／名前移動用にイベント確保
	$stage.object[1].x_rep.resize(1)
	$stage.object[1].tr_rep.resize(1)
	$stage.object[2].x_rep.resize(1)
	$stage.object[2].tr_rep.resize(1)
	
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_エクストラ_ＣＧ_サムネイル)
	
	// ワイプ（表示速度によって変更）
	if( <EFFECT_SPEED_SYS_MENU> )
	{
		// 瞬間表示
		wipe(0, 0, wait=1)
	}
	else
	{
		// 通常表示
		wipe(0, 250, wait=1)
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
// - シーン非表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$hide_extra_cg_scene_object(property $stage : stage)
{
	// ワイプ（表示速度によって変更）
	if( <EFFECT_SPEED_SYS_MENU> )
	{
		// 瞬間表示
		wipe(0, 0, wait=1)
	}
	else
	{
		// 通常表示
		wipe(0, 250, wait=1)
	}
}

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンのイベントＣＧを表示する
// - サムネイルからイベントＣＧを選択→表示した際の処理を追加できます
//---------------------------------------------------------------------------
command $$show_extra_cg_diff(property $stage : stage)
{
	// ワイプ(ジョイパッドのＲ１がキースキップするのでキースキップできないようにする)
	wipe(0, 250, wait=1, key_skip=0)
}

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンで閲覧中のＣＧ差分を変更する
// - 閲覧中のＣＧ差分を変更した際の処理を追加できます
//---------------------------------------------------------------------------
command $$change_extra_cg_diff(property $stage : stage)
{
	// ワイプ(ジョイパッドのＲ１がキースキップするのでキースキップできないようにする)
	wipe(0, 250, wait=1, key_skip=0)
}

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンのイベントＣＧを非表示にする
// - 閲覧中のイベントＣＧを非表示にする際の処理を追加できます
//---------------------------------------------------------------------------
command $$hide_extra_cg_diff(property $stage : stage)
{
	// ワイプ(ジョイパッドのＲ１がキースキップするのでキースキップできないようにする)
	wipe(0, 250, wait=1, key_skip=0)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_extra_cg_joypad_navigation(property $stage : stage)
{
	property $i
	property $len
	
	$len = 13
	if( @アネモイルートクリア == 0 ) {
		$len = 12
	}
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].joypad_up    = @ボタン_エクストラ_ＣＧ_ページ + $i - 1
		$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].joypad_down  = @ボタン_エクストラ_ＣＧ_ページ + $i + 1
		$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].joypad_left  = @ボタン_エクストラ_ＣＧ_サムネイル + 0
		$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].joypad_right = @ボタン_エクストラ_ＣＧ_サムネイル + 0
		
		if( $i == 0 ) {
			$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].joypad_up    = @ボタン_エクストラ_ＣＧ_ページ + $len - 1
		}
		
		if( $i == $len - 1 ) {
			$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].joypad_down    = @ボタン_エクストラ_ＣＧ_ページ + 0
		}
	}
	
	$len = $$get_extra_cg_page_thumb_max
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_up    = @ボタン_エクストラ_ＣＧ_サムネイル + $i - 4
		$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_down  = @ボタン_エクストラ_ＣＧ_サムネイル + $i + 4
		$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_left  = @ボタン_エクストラ_ＣＧ_サムネイル + $i - 1
		$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_right = @ボタン_エクストラ_ＣＧ_サムネイル + $i + 1
		
		// 最上段
		if( $i < 4 )
		{
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_up = -1
		}
		
		// 最下段
		if( $len - 5 < $i && 0 <= $i )
		{
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_down = @ボタン_エクストラ_サウンド_再生
		}
		
		// 最左列
		if( $i % 4 == 0 )
		{
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_left = @ボタン_エクストラ_ＣＧ_ページ + @エクストラ_ＣＧ_現在のページ
		}
		
		// 最右列
		if( $i % 4 == 3 )
		{
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_right = @ボタン_エクストラ_ＣＧ_ページ + @エクストラ_ＣＧ_現在のページ
		}
		
		// 最後
		if( $i == $len - 1 )
		{
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_right = @ボタン_エクストラ_ＣＧ_ページ + @エクストラ_ＣＧ_現在のページ
		}
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_extra_cg_sound_player_joypad_navigation(property $stage : stage)
{
	property $i
	property $len
	
	// ヘッダー
	$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].joypad_down  = @ボタン_エクストラ_ＣＧ_サムネイル + 0
	$stage.object[@ボタン_エクストラ_ヘッダー_レコード].joypad_down  = @ボタン_エクストラ_ＣＧ_サムネイル + 0
	$stage.object[@ボタン_エクストラ_ヘッダー_タイトル].joypad_down  = @ボタン_エクストラ_ＣＧ_サムネイル + 0
	
	// ＣＧサムネイル
	for( $i = 0, $i < 4, $i += 1 )
	{
		if( $stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].disp ) {
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_up = @ボタン_エクストラ_ヘッダー_ギャラリー
		}
	}
	
	// サウンドプレイヤー
	$len = $$get_extra_cg_page_thumb_max
	
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_up    = @ボタン_エクストラ_ＣＧ_サムネイル + $len - 1
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_down  = @ボタン_エクストラ_ヘッダー_ギャラリー
	
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_up    = @ボタン_エクストラ_ＣＧ_サムネイル + $len - 1
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_down  = @ボタン_エクストラ_ヘッダー_ギャラリー
	
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_up    = @ボタン_エクストラ_ＣＧ_サムネイル + $len - 1
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_down  = @ボタン_エクストラ_ヘッダー_ギャラリー
	
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_up    = @ボタン_エクストラ_ＣＧ_サムネイル + $len - 1
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_down  = @ボタン_エクストラ_ヘッダー_ギャラリー
	
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_up    = @ボタン_エクストラ_ＣＧ_サムネイル + $len - 1
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_down  = @ボタン_エクストラ_ヘッダー_ギャラリー
}
