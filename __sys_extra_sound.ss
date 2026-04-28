//===========================================================================
//!
//!    @file     _extra_sound.ss
//!    @brief    サウンド鑑賞シーン
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start

	#property	$select_btn		// 選択したボタン
	
	// ＢＧＭリスト
	#property	$music_list : strlist[@エクストラ_サウンド_登録ＢＧＭ最大数]
	
	#property	$play_index			// 再生中のＢＧＭインデックス
	#property	$is_play			// ＢＧＭを再生中かどうか
	#property	$is_pause			// ＢＧＭを一時停止中かどうか
	#property	$music_list_max		// ＢＧＭリストに登録されているＢＧＭの数

#inc_end

//---------------------------------------------------------------------------
// サウンド鑑賞シーン開始
//---------------------------------------------------------------------------
#z00

$$init_scene_data														// シーンデータを初期化する
$$create_extra_sound_scene_object(excall.front)							// シーンオブジェクトを作成する
$$update_scene_object(excall.front)										// シーンオブジェクトの描画を更新する
$$auto_joypad_navigation(@ボタン_エクストラ_サウンド_閉じる,			// 自動でジョイパッド時のボタン遷移先を設定する
						 @ボタン_エクストラ_サウンド_サムネイル最大)
$$set_extra_sound_joypad_navigation(excall.front)						// 手動でジョイパッド時のボタン遷移先を設定する
$$set_joypad_focus_button_default(excall.front)							// ジョイパッドで最初に選択されているボタンをデフォルトで設定する
$$show_extra_sound_scene_object(excall.front)							// シーンオブジェクトを表示する

// 入力制御を開始する
$$input_start(excall.front, <OBJBTN_GROUP_NO_MODAL>)

while( 1 )
{
	// 入力制御を更新する
	$select_btn = $$input_update(excall.front, <OBJBTN_GROUP_NO_MODAL>)
	
	// キャンセルは閉じるボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_エクストラ_サウンド_閉じる
	}
	
	// ＢＧＭボタンが押された場合はＢＧＭを再生する
	if( @ボタン_エクストラ_サウンド_サムネイル <= $select_btn && $select_btn <= @ボタン_エクストラ_サウンド_サムネイル最大 )
	{
		$$play_music($select_btn - @ボタン_エクストラ_サウンド_サムネイル)
	}
	
	// サウンドプレイヤーの更新
	$select_btn = $$update_extra_music_player($select_btn)
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		$$update_scene_object(excall.front)						// 描画を更新する
		$$input_start(excall.front, <OBJBTN_GROUP_NO_MODAL>)	// 入力制御を再開始する
	}
	
	// アプリケーション側の処理を更新する
	$$update_extra_sound_scene_object(excall.front, $select_btn)
	
	// 閉じるボタン／トラックリストボタンが押された場合は処理を終了する
	if( $select_btn == @ボタン_エクストラ_サウンド_閉じる || $select_btn == @ボタン_エクストラ_サウンド_トラックリスト ) {
		break
	}
	
	// 何も押していないときは画面の更新のみ
	if( $select_btn == -2 )
	{
		input.next		// 入力の更新
		disp			// 画面の更新
	}
}

// エクストラのモード選択シーンが有効の場合はモード選択オブジェクトを構成する
if( __EXTRA_MODE_SELECT_SCENE == 1 ) {
	$$build_extra_mode_select_scene(excall.back)
}

$$off_system_front_wipe_copy(110, 111)
$$off_system_front_wipe_copy(@ボタン_エクストラ_サウンド_サムネイル, @ボタン_エクストラ_サウンド_サムネイル最大)
$$hide_extra_sound_scene_object(excall.front)	// シーンオブジェクトを非表示にする

return


//---------------------------------------------------------------------------
// サウンドプレイヤーの更新（外部呼出し）
//---------------------------------------------------------------------------
command $$update_extra_music_player(property $select_btn) : int
{
	property $i
	property $value
	
	// 再生ボタンが押された場合はＢＧＭを再生する
	if( $select_btn == @ボタン_エクストラ_サウンド_再生 )
	{
		// 再生中の場合は一時停止処理を行う
		if( $is_play )
		{
			// 一時停止中の場合は再開する
			if( $is_pause )
			{
				@bgm_resume(500)
				$is_pause = 0
			}
			else
			{
				// 一時停止中でない場合は一時停止をする
				@bgm_pause(500)
				$is_pause = 1
			}
		}
		else
		{
			// 再生中でない場合は再生をする
			$$play_music($play_index)
		}
	}
	
	// 停止ボタンが押された場合はＢＧＭを停止する
	if( $select_btn == @ボタン_エクストラ_サウンド_停止 ) {
		$is_play = 0
		@bgm_stop
	}
	
	// 前へボタンが押された場合は前のＢＧＭを再生する
	if( $select_btn == @ボタン_エクストラ_サウンド_前へ ) {
		$$prev_music
	}
	
	// 次へボタンが押された場合は次のＢＧＭを再生する
	if( $select_btn == @ボタン_エクストラ_サウンド_次へ ) {
		$$next_music
	}
	
	// ジョイパッド操作時、ボタンの選択が分かるように少しウェイトを入れる
	if( $select_btn == @ボタン_エクストラ_サウンド_再生 || $select_btn == @ボタン_エクストラ_サウンド_停止 || $select_btn == @ボタン_エクストラ_サウンド_前へ || $select_btn == @ボタン_エクストラ_サウンド_次へ )
	{
		if( syscom.check_joypad_mode == 1 ) {
			timewait_key(150)
		}
	}
	
	// マウスでスライダーを押している場合
	if( excall.front.object[@スライダー_エクストラ_サウンド_音量].f.get_size > 0 )
	{
		if( excall.front.object[@スライダー_エクストラ_サウンド_音量].f_slider_on_value_changed )
		{
			// スライダーの値を音量に反映する
			syscom.set_bgm_volume($$get_ui_slider_value(excall.front.object[@スライダー_エクストラ_サウンド_音量]))
		}
	}
	
	// ゲームパッドのキー入力の場合
	switch( $select_btn ) {
	case(@動作_エクストラ_サウンド_音量_下げる)			$$step_slider(excall.front, @スライダー_エクストラ_サウンド_音量, 0)
	case(@動作_エクストラ_サウンド_音量_上げる)			$$step_slider(excall.front, @スライダー_エクストラ_サウンド_音量, 1)
	}
	
	// 音量スライダー
	if( $select_btn == @スライダー_エクストラ_サウンド_音量 )
	{
		// スライダーの描画を更新する
		$$update_ui_slider(excall.front.object[@スライダー_エクストラ_サウンド_音量], syscom.get_bgm_volume)
	}
	
	return ($select_btn)
}

//---------------------------------------------------------------------------
// サウンド鑑賞シーンで再生するＢＧＭを設定する
//---------------------------------------------------------------------------
command $$set_extra_music(property $bgm_index, property $bgm_name : str)
{
	$music_list[$bgm_index - 1] = $bgm_name
}

//---------------------------------------------------------------------------
// サウンド鑑賞シーンで再生するＢＧＭを取得する
//---------------------------------------------------------------------------
command $$get_extra_music(property $bgm_index) : str
{
	return ($music_list[$bgm_index])
}

//---------------------------------------------------------------------------
// サウンド鑑賞シーンで再生するＢＧＭ数を取得する
//---------------------------------------------------------------------------
command $$get_extra_music_cnt : int
{
	property $i
	property $len
	
	$len = $music_list.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $music_list[$i] == "" ) {
			break
		}
	}
	
	return ($i)
}

//---------------------------------------------------------------------------
// サウンド鑑賞シーンで再生中のＢＧＭインデックスを取得する
//---------------------------------------------------------------------------
command $$get_extra_music_play_index : int
{
	return ($play_index)
}

//---------------------------------------------------------------------------
// シーンデータを初期化する
//---------------------------------------------------------------------------
command $$init_scene_data
{
	property $i
	
	for( $i = 0, $i < @エクストラ_サウンド_登録ＢＧＭ最大数, $i += 1 )
	{
		// 再生中のＢＧＭインデックスを取得する
		if( bgm.get_regist_name != "" )
		{
			if( $music_list[$i] == bgm.get_regist_name )
			{
				$play_index = $i
				$is_play = 1
			}
		}
		
		// ＢＧＭリストに登録されているＢＧＭの数を取得する
		if( $music_list[$i] == "" )
		{
			$music_list_max = $i
			
			break
		}
	}
	
	if( $is_play == 0 ) {
		$$play_music(44)
	}
}

//---------------------------------------------------------------------------
// サウンドプレイヤーの初期化（外部呼出し）
//---------------------------------------------------------------------------
command $$init_extra_music_player
{
	property $i
	
	$$init_scene_data
	
	// 現在再生中のＢＧＭを取得して再生インデックスを設定する
	for( $i = 0, $i < @エクストラ_サウンド_登録ＢＧＭ最大数, $i += 1 )
	{
		if( $music_list[$i] == bgm.get_regist_name )
		{
			$play_index = $i
			
			break
		}
	}
}

//---------------------------------------------------------------------------
// ＢＧＭを再生する
//---------------------------------------------------------------------------
command $$play_music(property $bgm_index)
{
	// 少し待つ
	timewait(250)
	
	// システム効果音を停止する
	se.stop(100)
	
	$play_index = $bgm_index
	$is_play = 1
	$is_pause = 0
	
	if( $music_list[$play_index] == "" ) {
		@dm("_extra_sound.ss → $$play_music\nＢＧＭリストに登録されていないＢＧＭが再生されました。\n再生ボタン番号 : " + math.tostr($play_index + 1) + "\n処理をスキップします。")
	}
	
	bgm.play($music_list[$play_index])
}

//---------------------------------------------------------------------------
// 前のＢＧＭを再生する
//---------------------------------------------------------------------------
command $$prev_music
{
	while( 1 )
	{
		$play_index -= 1
		
		if( $play_index < 0 ) {
			$play_index = $music_list_max - 1
		}
		
		if( bgmtable.get_listen_by_name($music_list[$play_index]) == 1 )
		{
			break
		}
	}
	
	$$play_music($play_index)
}

//---------------------------------------------------------------------------
// 次のＢＧＭを再生する
//---------------------------------------------------------------------------
command $$next_music
{
	while( 1 )
	{
		$play_index += 1
		
		if( $play_index > $music_list_max - 1 ) {
			$play_index = 0
		}
		
		if( bgmtable.get_listen_by_name($music_list[$play_index]) == 1 )
		{
			break
		}
	}
	
	$$play_music($play_index)
}

//---------------------------------------------------------------------------
// サウンド鑑賞シーンで使用する再生ボタンを作成する
//---------------------------------------------------------------------------
command $$create_extra_sound_play_button(property $obj : object, property $filename : str, property $x, property $y, property $button_no, property $button_group_no, property $button_se_no)
{
	// トグルボタンを作成する
	$$create_ui_toggle_button($obj, $filename, $x, $y, $button_no, $button_group_no, $button_se_no, $is_play)
}

//---------------------------------------------------------------------------
// サウンド鑑賞シーンで使用する音量スライダーを作成する
//---------------------------------------------------------------------------
command $$create_extra_sound_volume_slider(property $obj : object, property $filename : str, property $x, property $y, property $button_no, property $button_group_no, property $button_se_no, property $overlay_x, property $overlay_y)
{
	$$create_ui_slider($obj, $filename, $x, $y, $button_no, $button_no + 1, $button_group_no, $button_se_no, $overlay_x, $overlay_y, <SLIDER_DIRECTION_LR>, syscom.get_bgm_volume, 0, 255)
}

//---------------------------------------------------------------------------
// シーンオブジェクトの描画を更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage)
{
	property $i
	
	// ＢＧＭボタンの描画更新
	for( $i = 0, $i < @エクストラ_サウンド_登録ＢＧＭ最大数, $i += 1 )
	{
		// ＢＧＭ設定されていない場合は処理を終了する
		if( $music_list[$i] == "" ) {
			break
		}
		
		// ＢＧＭを聴いていない場合は選択不可にする
		if( bgmtable.get_listen_by_name($music_list[$i]) == 0 )
		{
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].set_button_state_disable
		}
		
		// 再生中のＢＧＭボタンは選択状態にする
		elseif( $music_list[$i] == bgm.get_regist_name )
		{
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].set_button_state_select
		}
		else
		{
			// 再生中でないＢＧＭボタンは通常状態に戻す
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].set_button_state_normal
		}
	}
	
	// サウンドプレイヤーの更新
	$$update_extra_music_player_object($stage)
}

//---------------------------------------------------------------------------
// サウンドプレイヤーの更新（外部呼出し）
//---------------------------------------------------------------------------
command $$update_extra_music_player_object(property $stage : stage)
{
	// 曲情報を更新する
	$stage.object[@イメージ_エクストラ_サウンド_曲情報].patno = $play_index
	
	// 再生ボタンを更新する
	if( $is_pause )
	{
		// 一時停止中の場合は再生ボタンにする
		$$update_ui_toggle_button($stage.object[@ボタン_エクストラ_サウンド_再生], 0)
	}
	else
	{
		// 一時停止中でない場合は再生中かどうかで一時停止ボタンか再生ボタンにする
		$$update_ui_toggle_button($stage.object[@ボタン_エクストラ_サウンド_再生], $is_play)
	}
	
	// ＢＧＭが再生中の場合
	if( $is_play == 1 )
	{
		$stage.object[@ボタン_エクストラ_サウンド_停止].set_button_state_normal		// 停止ボタンを選択不可にする
	}
	else
	{
		$stage.object[@ボタン_エクストラ_サウンド_停止].set_button_state_disable	// 停止ボタンを通常状態にする
	}
}

//---------------------------------------------------------------------------
// スライダーのステップ処理を行う
//---------------------------------------------------------------------------
command $$step_slider(property $stage : stage, property $btn_no, property $step_direction)
{
	property $value
	property $slider_limit
	
	// 指定方向によってスライダーの増減処理を変更する
	switch( $step_direction ) {
	case(0)		$slider_limit = $$prev_step_ui_slider($stage.object[$btn_no])
	case(1)		$slider_limit = $$next_step_ui_slider($stage.object[$btn_no])
	}
	
	// スライダーの増減処理が限界だった場合
	if( $slider_limit )
	{
		// キャンセル音を再生する
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
	}
	else
	{
		// 決定音を再生する
		se.play_by_se_no(<BUTTON_SE_DECIDE>)
	}
	
	// スライダーの現在値を取得する
	$value = $$get_ui_slider_value($stage.object[$btn_no])
	
	// 値を各音量に設定する
	switch( $btn_no ) {
	case(@スライダー_エクストラ_サウンド_音量)		syscom.set_bgm_volume($value)
	}
	
	// スライダーの描画を更新する
	$$update_ui_slider($stage.object[$btn_no], $value)
}

//---------------------------------------------------------------------------
// ジョイパッドで最初に選択されているボタンをデフォルトで設定する
//---------------------------------------------------------------------------
command $$set_joypad_focus_button_default(property $stage : stage)
{
	// 先頭のサムネイルボタンをデフォルトにする
	$$set_joypad_focus_button(@ボタン_エクストラ_サウンド_サムネイル + $play_index)
	
	// ジョイパッドモードがオフの場合はフォーカスボタンを更新する
	if( syscom.check_joypad_mode == 0 ) {
		$$update_joypad_focus_button(excall.front)
	}
}
