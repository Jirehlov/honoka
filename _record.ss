//===========================================================================
//!
//!    @file     _record.ss
//!    @brief    レコードシーン(アプリケーション側)
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レイアウトなどアプリケーションごとに挙動を調整する必要がある処理
//!
//===========================================================================

#z00

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_record_scene_object(property $stage : stage)
{
	$$create_ui_image($stage.object[0], _record_bg, 0, 0)
	$$create_ui_number_image($stage.object[@イメージ_レコード_達成率], _record_number, 1349, 92)
	$$create_record_all_thumb_object($stage, _record_thumb_bg, 183, 268, 794, 70, 2)
	$$create_record_scrollview($stage.object[@ボタン_レコード_スクロールビュー], _record_scroll, 1, 985, @ボタン_レコード_スクロールビュー, 881, 1817, -744, @ボタン_レコード_スクロールビュー, @ボタン_レコード_スクロールビュー + 1, <OBJBTN_GROUP_NO_EXCALL>, 1, 0, 0)
}

//---------------------------------------------------------------------------
// サムネイルオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_record_thumb_object(property $obj : object)
{
	$$create_ui_number_image($obj.child[@イメージ_レコード枠_番号_取得済], _record_thumb_number01, 260, 276)
	$$create_ui_number_image($obj.child[@イメージ_レコード枠_番号_未取得], _record_thumb_number02, 260, 276)
	$$create_ui_string($obj.child[@イメージ_レコード枠_テキスト], 359, 280, 550, 29, 24)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
// - 毎フレーム処理を追加することができます
//---------------------------------------------------------------------------
command $$update_record_scene_object(property $stage : stage, property $select_btn)
{
	// エクストラモードでない場合は終了する
	if( <EXTRA_MODE> == 0 ) {
		return
	}
	
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
	
	// パッド入力更新
	if( $$is_focused_on_btn(@スライダー_エクストラ_サウンド_音量) )
	{
		$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_up    = @動作_エクストラ_サウンド_音量_上げる
		$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_down  = @動作_エクストラ_サウンド_音量_下げる
	}
	else
	{
		$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_up    = -1
		$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_down  = -1
	}
	
	if( $$is_focused_on_btn(@ボタン_レコード_スクロールビュー) )
	{
		$stage.object[@ボタン_レコード_スクロールビュー].joypad_up    = @動作_レコード_スクロールアップ
		$stage.object[@ボタン_レコード_スクロールビュー].joypad_down  = @動作_レコード_スクロールダウン
		
		if( $stage.object[@ボタン_レコード_スクロールビュー].f_scview_now_y >= 0 ) {
			$stage.object[@ボタン_レコード_スクロールビュー].joypad_up = @ボタン_エクストラ_ヘッダー_レコード
		}
		if( $stage.object[@ボタン_レコード_スクロールビュー].f_scview_now_y <= $stage.object[@ボタン_レコード_スクロールビュー].f_scview_scroll_range ) {
			$stage.object[@ボタン_レコード_スクロールビュー].joypad_down = @ボタン_エクストラ_サウンド_再生
		}
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
// - シーン表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$show_record_scene_object(property $stage : stage)
{
	property $i
	property $anim_check_obj_no
	
	// エクストラから入る場合
	if( <EXTRA_MODE> )
	{
		// 背景を変更する
		$stage.object[0].change_file(_record_extra_bg)
		
		// 音楽プレイヤーを作成する
		$$init_extra_music_player
		$$create_extra_sound_player_object($stage)
		$$update_extra_music_player_object($stage)
		$$set_extra_sound_player_joypad_navigation($stage)
		$$set_extra_record_sound_player_joypad_navigation($stage)
		
		// ヘッダー
		$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].set_button_state_normal
		$stage.object[@ボタン_エクストラ_ヘッダー_レコード].set_button_state_select
	}
	
	// 達成率の数字／座標を設定する
	if( @レコード達成率 >= 100 )
	{
		// １００％は専用の画像
		$$create_ui_image($stage.object[@イメージ_レコード_達成率１００], _record_number100, 1349, 97)
		$stage.object[@イメージ_レコード_達成率].disp = 0
	}
	elseif( @レコード達成率 < 10 )
	{
		$stage.object[@イメージ_レコード_達成率].x = 1293
		$stage.object[@イメージ_レコード_達成率].set_number_param(3, 0, 0, 0, 0, 4)
	}
	else
	{
		$stage.object[@イメージ_レコード_達成率].x = 1317
		$stage.object[@イメージ_レコード_達成率].set_number_param(3, 0, 0, 0, 0, 4)
	}
	
	for( $i = 0, $i < @レコード最大数, $i += 1 )
	{
		// レコード番号の数字パラメータを設定する
		$stage.object[@イメージ_レコード枠].child[$i].child[@イメージ_レコード枠_番号_取得済].set_number_param(3, 1, 0, 0, 0, 3)
		$stage.object[@イメージ_レコード枠].child[$i].child[@イメージ_レコード枠_番号_未取得].set_number_param(3, 1, 0, 0, 0, 3)
	}
	
	// ワイプ（表示速度によって変更）
	if( <EFFECT_SPEED_SYS_MENU> )
	{
		// 瞬間表示
		wipe(0, 0, wait=1)
	}
	else
	{
		// 現在のページを右から表示
		$stage.object[@イメージ_レコード枠].x_rep.resize(2)
		$stage.object[@イメージ_レコード枠].x_rep[1] = <SCREEN_WIDTH>
		$stage.object[@イメージ_レコード枠].x_rep_eve[1].set(0, 500, 0, 2)
		
		// 通常表示
		wipe(0, 250, wait=1)
		
		// アニメーションの終了を待つ
		excall.front.object[@イメージ_レコード枠].all_eve.wait
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
// - シーン非表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$hide_record_scene_object(property $stage : stage)
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
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_record_joypad_navigation(property $stage : stage)
{
	property $i
	
	$stage.object[@ボタン_レコード_スクロールビュー].joypad_up    = @動作_レコード_スクロールアップ
	$stage.object[@ボタン_レコード_スクロールビュー].joypad_down  = @動作_レコード_スクロールダウン
	$stage.object[@ボタン_レコード_スクロールビュー].joypad_left  = @ボタン_フッター_コンフィグ
	$stage.object[@ボタン_レコード_スクロールビュー].joypad_right = @ボタン_フッター_タイトルに戻る
	
	if( <EXTRA_MODE> == 0 )
	{
		for( $i = @ボタン_フッター_セーブ, $i <= @ボタン_フッター_戻る, $i += 1 )
		{
			$stage.object[$i].joypad_up   = @動作_レコード_スクロールフォーカス
			$stage.object[$i].joypad_down = @動作_レコード_スクロールフォーカス
		}
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_extra_record_sound_player_joypad_navigation(property $stage : stage)
{
	property $i
	property $len
	
	$$set_joypad_focus_button(@ボタン_レコード_スクロールビュー)
	
	// ヘッダー
	$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].joypad_down  = @動作_レコード_スクロールフォーカス
	$stage.object[@ボタン_エクストラ_ヘッダー_レコード].joypad_down  = @動作_レコード_スクロールフォーカス
	$stage.object[@ボタン_エクストラ_ヘッダー_タイトル].joypad_down  = @動作_レコード_スクロールフォーカス
	
	// スクロールビュー
	$stage.object[@ボタン_レコード_スクロールビュー].joypad_left  = -1
	$stage.object[@ボタン_レコード_スクロールビュー].joypad_right = -1
	
	// ＣＧサムネイル
	for( $i = 0, $i < 4, $i += 1 )
	{
		if( $stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].disp ) {
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].joypad_up = @ボタン_エクストラ_サウンド_再生
		}
	}
	
	// サウンドプレイヤー
	$len = $$get_extra_cg_page_thumb_max
	
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_up    = @動作_レコード_スクロールフォーカス
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_down  = @ボタン_エクストラ_ヘッダー_レコード
	
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_up    = @動作_レコード_スクロールフォーカス
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_down  = @ボタン_エクストラ_ヘッダー_レコード
	
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_up    = @動作_レコード_スクロールフォーカス
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_down  = @ボタン_エクストラ_ヘッダー_レコード
	
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_up    = @動作_レコード_スクロールフォーカス
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_down  = @ボタン_エクストラ_ヘッダー_レコード
	
	$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_up    = -1
	$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_down  = -1
	
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_up    = @動作_レコード_スクロールフォーカス
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_down  = @ボタン_エクストラ_ヘッダー_レコード
}
