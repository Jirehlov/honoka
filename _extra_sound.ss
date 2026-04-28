//===========================================================================
//!
//!    @file     _extra_sound.ss
//!    @brief    サウンド鑑賞シーン(アプリケーション側)
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
command $$create_extra_sound_scene_object(property $stage : stage)
{
	$$create_ui_image($stage.object[110], _extra_sound_bg, 357, 123)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 0], _extra_sound_bgm_btn01, 411, 240, @ボタン_エクストラ_サウンド_サムネイル + 0, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 1], _extra_sound_bgm_btn02, 690, 240, @ボタン_エクストラ_サウンド_サムネイル + 1, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 2], _extra_sound_bgm_btn03, 970, 240, @ボタン_エクストラ_サウンド_サムネイル + 2, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 3], _extra_sound_bgm_btn04, 1250, 240, @ボタン_エクストラ_サウンド_サムネイル + 3, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 4], _extra_sound_bgm_btn05, 411, 282, @ボタン_エクストラ_サウンド_サムネイル + 4, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 5], _extra_sound_bgm_btn06, 690, 282, @ボタン_エクストラ_サウンド_サムネイル + 5, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 6], _extra_sound_bgm_btn07, 970, 282, @ボタン_エクストラ_サウンド_サムネイル + 6, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 7], _extra_sound_bgm_btn08, 1250, 282, @ボタン_エクストラ_サウンド_サムネイル + 7, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 8], _extra_sound_bgm_btn09, 411, 324, @ボタン_エクストラ_サウンド_サムネイル + 8, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 9], _extra_sound_bgm_btn10, 690, 324, @ボタン_エクストラ_サウンド_サムネイル + 9, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 10], _extra_sound_bgm_btn11, 970, 324, @ボタン_エクストラ_サウンド_サムネイル + 10, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 11], _extra_sound_bgm_btn12, 1249, 324, @ボタン_エクストラ_サウンド_サムネイル + 11, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 12], _extra_sound_bgm_btn13, 411, 366, @ボタン_エクストラ_サウンド_サムネイル + 12, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 13], _extra_sound_bgm_btn14, 690, 366, @ボタン_エクストラ_サウンド_サムネイル + 13, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 14], _extra_sound_bgm_btn15, 694, 303, @ボタン_エクストラ_サウンド_サムネイル + 14, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 15], _extra_sound_bgm_btn16, 1250, 366, @ボタン_エクストラ_サウンド_サムネイル + 15, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 16], _extra_sound_bgm_btn17, 411, 407, @ボタン_エクストラ_サウンド_サムネイル + 16, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 17], _extra_sound_bgm_btn18, 690, 407, @ボタン_エクストラ_サウンド_サムネイル + 17, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 18], _extra_sound_bgm_btn19, 970, 407, @ボタン_エクストラ_サウンド_サムネイル + 18, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 19], _extra_sound_bgm_btn20, 1250, 407, @ボタン_エクストラ_サウンド_サムネイル + 19, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 20], _extra_sound_bgm_btn21, 410, 449, @ボタン_エクストラ_サウンド_サムネイル + 20, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 21], _extra_sound_bgm_btn22, 690, 449, @ボタン_エクストラ_サウンド_サムネイル + 21, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 22], _extra_sound_bgm_btn23, 970, 449, @ボタン_エクストラ_サウンド_サムネイル + 22, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 23], _extra_sound_bgm_btn24, 1250, 449, @ボタン_エクストラ_サウンド_サムネイル + 23, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 24], _extra_sound_bgm_btn25, 411, 490, @ボタン_エクストラ_サウンド_サムネイル + 24, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 25], _extra_sound_bgm_btn26, 690, 490, @ボタン_エクストラ_サウンド_サムネイル + 25, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 26], _extra_sound_bgm_btn27, 970, 490, @ボタン_エクストラ_サウンド_サムネイル + 26, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 27], _extra_sound_bgm_btn28, 1250, 490, @ボタン_エクストラ_サウンド_サムネイル + 27, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 28], _extra_sound_bgm_btn29, 411, 531, @ボタン_エクストラ_サウンド_サムネイル + 28, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 29], _extra_sound_bgm_btn30, 690, 531, @ボタン_エクストラ_サウンド_サムネイル + 29, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 30], _extra_sound_bgm_btn31, 970, 531, @ボタン_エクストラ_サウンド_サムネイル + 30, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 31], _extra_sound_bgm_btn32, 1250, 531, @ボタン_エクストラ_サウンド_サムネイル + 31, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 32], _extra_sound_bgm_btn33, 411, 565, @ボタン_エクストラ_サウンド_サムネイル + 32, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 33], _extra_sound_bgm_btn34, 690, 565, @ボタン_エクストラ_サウンド_サムネイル + 33, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 34], _extra_sound_bgm_btn35, 970, 565, @ボタン_エクストラ_サウンド_サムネイル + 34, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 35], _extra_sound_bgm_btn36, 1250, 565, @ボタン_エクストラ_サウンド_サムネイル + 35, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 36], _extra_sound_bgm_btn37, 411, 607, @ボタン_エクストラ_サウンド_サムネイル + 36, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 37], _extra_sound_bgm_btn38, 690, 607, @ボタン_エクストラ_サウンド_サムネイル + 37, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 38], _extra_sound_bgm_btn39, 970, 607, @ボタン_エクストラ_サウンド_サムネイル + 38, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 39], _extra_sound_bgm_btn40, 1250, 607, @ボタン_エクストラ_サウンド_サムネイル + 39, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 40], _extra_sound_bgm_btn41, 411, 649, @ボタン_エクストラ_サウンド_サムネイル + 40, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 41], _extra_sound_bgm_btn42, 690, 649, @ボタン_エクストラ_サウンド_サムネイル + 41, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 42], _extra_sound_bgm_btn43, 970, 649, @ボタン_エクストラ_サウンド_サムネイル + 42, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 43], _extra_sound_bgm_btn44, 1250, 649, @ボタン_エクストラ_サウンド_サムネイル + 43, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 44], _extra_sound_bgm_btn45, 411, 690, @ボタン_エクストラ_サウンド_サムネイル + 44, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 45], _extra_sound_bgm_btn46, 690, 690, @ボタン_エクストラ_サウンド_サムネイル + 45, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 46], _extra_sound_bgm_btn47, 970, 690, @ボタン_エクストラ_サウンド_サムネイル + 46, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 47], _extra_sound_bgm_btn48, 1250, 690, @ボタン_エクストラ_サウンド_サムネイル + 47, <OBJBTN_GROUP_NO_MODAL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 48], _extra_sound_bgm_btn49, 411, 732, @ボタン_エクストラ_サウンド_サムネイル + 48, <OBJBTN_GROUP_NO_MODAL>, 0)
	
	if( 0 ) {
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 49], _extra_sound_bgm_btn50, 690, 732, @ボタン_エクストラ_サウンド_サムネイル + 49, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 50], _extra_sound_bgm_btn51, 970, 732, @ボタン_エクストラ_サウンド_サムネイル + 50, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 51], _extra_sound_bgm_btn52, 1250, 732, @ボタン_エクストラ_サウンド_サムネイル + 51, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 52], _extra_sound_bgm_btn53, 411, 773, @ボタン_エクストラ_サウンド_サムネイル + 52, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 53], _extra_sound_bgm_btn54, 690, 773, @ボタン_エクストラ_サウンド_サムネイル + 53, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 54], _extra_sound_bgm_btn55, 970, 773, @ボタン_エクストラ_サウンド_サムネイル + 54, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 55], _extra_sound_bgm_btn56, 1250, 773, @ボタン_エクストラ_サウンド_サムネイル + 55, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 56], _extra_sound_bgm_btn57, 411, 814, @ボタン_エクストラ_サウンド_サムネイル + 56, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 57], _extra_sound_bgm_btn58, 690, 814, @ボタン_エクストラ_サウンド_サムネイル + 57, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 58], _extra_sound_bgm_btn59, 970, 814, @ボタン_エクストラ_サウンド_サムネイル + 58, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 59], _extra_sound_bgm_btn60, 1250, 814, @ボタン_エクストラ_サウンド_サムネイル + 59, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 60], _extra_sound_bgm_btn61, 411, 853, @ボタン_エクストラ_サウンド_サムネイル + 60, <OBJBTN_GROUP_NO_MODAL>, 0)
	} else {
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 49], _extra_sound_bgm_btn55, 690, 732, @ボタン_エクストラ_サウンド_サムネイル + 49, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 50], _extra_sound_bgm_btn56, 970, 732, @ボタン_エクストラ_サウンド_サムネイル + 50, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 51], _extra_sound_bgm_btn57, 1250, 732, @ボタン_エクストラ_サウンド_サムネイル + 51, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 52], _extra_sound_bgm_btn58, 411, 773, @ボタン_エクストラ_サウンド_サムネイル + 52, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 53], _extra_sound_bgm_btn59, 690, 773, @ボタン_エクストラ_サウンド_サムネイル + 53, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 54], _extra_sound_bgm_btn60, 970, 773, @ボタン_エクストラ_サウンド_サムネイル + 54, <OBJBTN_GROUP_NO_MODAL>, 0)
		$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_サムネイル + 55], _extra_sound_bgm_btn61, 1250, 773, @ボタン_エクストラ_サウンド_サムネイル + 55, <OBJBTN_GROUP_NO_MODAL>, 0)
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
// - 毎フレーム処理を追加することができます
//---------------------------------------------------------------------------
command $$update_extra_sound_scene_object(property $stage : stage, property $select_btn)
{
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
// - シーン表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$show_extra_sound_scene_object(property $stage : stage)
{
	property $i
	
	// レイヤー値を上げる
	$stage.object[110].layer = 1
	for( $i = 0, $i < @エクストラ_サウンド_登録ＢＧＭ最大数, $i += 1 )
	{
		// 生成されていないボタンは処理しない
		if( $stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].f.get_size == 0 ) {
			continue
		}
		
		$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].layer += 1
	}
	
	// サウンドプレイヤーのボタンをモーダルにする
	$stage.object[@ボタン_エクストラ_サウンド_再生].set_button($stage.object[@ボタン_エクストラ_サウンド_再生].get_button_no, <OBJBTN_GROUP_NO_MODAL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_停止].set_button($stage.object[@ボタン_エクストラ_サウンド_停止].get_button_no, <OBJBTN_GROUP_NO_MODAL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_前へ].set_button($stage.object[@ボタン_エクストラ_サウンド_前へ].get_button_no, <OBJBTN_GROUP_NO_MODAL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_次へ].set_button($stage.object[@ボタン_エクストラ_サウンド_次へ].get_button_no, <OBJBTN_GROUP_NO_MODAL>, 1, 0)
	$stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_bg.set_button($stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_bg.get_button_no, <OBJBTN_GROUP_NO_MODAL>, 1, 0)
	$stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_handle.set_button($stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_handle.get_button_no, <OBJBTN_GROUP_NO_MODAL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].set_button($stage.object[@ボタン_エクストラ_サウンド_トラックリスト].get_button_no, <OBJBTN_GROUP_NO_MODAL>, 1, 0)
	
	// レコードから飛んできている場合はスクロールビューを無効にする
	if( $stage.object[@ボタン_レコード_スクロールビュー].type == <UI_TYPE_SCROLLVIEW> ) {
		$stage.object[@ボタン_レコード_スクロールビュー].f_scview_enable = 0
	}
	
	// ワイプ（表示速度によって変更）
	if( <EFFECT_SPEED_SYS_MENU> )
	{
		// 瞬間表示
		wipe(0, 0, wait=1)
	}
	else
	{
		$stage.object[110].y_rep.resize(1)
		$stage.object[110].y_rep[0] = 20
		$stage.object[110].y_rep_eve[0].set(0, 500, 0, 2)
		$stage.object[110].tr = 0
		$stage.object[110].tr_eve.set(255, 500, 0, 2)
		
		for( $i = 0, $i < @エクストラ_サウンド_登録ＢＧＭ最大数, $i += 1 )
		{
			// 生成されていないボタンは処理しない
			if( $stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].f.get_size == 0 ) {
				continue
			}
			
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].y_rep.resize(1)
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].y_rep[0] = 20
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].y_rep_eve[0].set(0, 500, 0, 2)
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].tr = 0
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].tr_eve.set(255, 500, 0, 2)
		}
		
		// 通常表示
		wipe(0, 500, wait=1)
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
// - シーン非表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$hide_extra_sound_scene_object(property $stage : stage)
{
	property $i
	
	// レコードから飛んできている場合はスクロールビューを有効にする
	if( $stage.object[@ボタン_レコード_スクロールビュー].type == <UI_TYPE_SCROLLVIEW> ) {
		$stage.object[@ボタン_レコード_スクロールビュー].f_scview_enable = 1
	}
	
	// サウンドプレイヤーのボタンをモーダルにする
	$stage.object[@ボタン_エクストラ_サウンド_再生].set_button($stage.object[@ボタン_エクストラ_サウンド_再生].get_button_no, <OBJBTN_GROUP_NO_EXCALL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_停止].set_button($stage.object[@ボタン_エクストラ_サウンド_停止].get_button_no, <OBJBTN_GROUP_NO_EXCALL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_前へ].set_button($stage.object[@ボタン_エクストラ_サウンド_前へ].get_button_no, <OBJBTN_GROUP_NO_EXCALL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_次へ].set_button($stage.object[@ボタン_エクストラ_サウンド_次へ].get_button_no, <OBJBTN_GROUP_NO_EXCALL>, 1, 0)
	$stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_bg.set_button($stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_bg.get_button_no, <OBJBTN_GROUP_NO_EXCALL>, 1, 0)
	$stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_handle.set_button($stage.object[@スライダー_エクストラ_サウンド_音量].ui_slider_handle.get_button_no, <OBJBTN_GROUP_NO_EXCALL>, 1, 0)
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].set_button($stage.object[@ボタン_エクストラ_サウンド_トラックリスト].get_button_no, <OBJBTN_GROUP_NO_EXCALL>, 1, 0)
	
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
command $$set_extra_sound_joypad_navigation(property $stage : stage)
{
	property $i
	
	for( $i = 0, $i < @エクストラ_サウンド_登録ＢＧＭ最大数, $i += 1 )
	{
		// 生成されていないボタンは処理しない
		if( $stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].f.get_size == 0 ) {
			continue
		}
		
		$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_up    = @ボタン_エクストラ_サウンド_サムネイル + $i - 4
		$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_down  = @ボタン_エクストラ_サウンド_サムネイル + $i + 4
		$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_left  = @ボタン_エクストラ_サウンド_サムネイル + $i - 1
		$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_right = @ボタン_エクストラ_サウンド_サムネイル + $i + 1
		
		// 最左列
		if( $i % 4 == 0 )
		{
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_left = @ボタン_エクストラ_サウンド_サムネイル + $i + 3
		}
		
		// 最右列
		if( $i % 4 == 3 )
		{
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_right = @ボタン_エクストラ_サウンド_サムネイル + $i - 3
		}
		
		// 最上段
		if( $i < 4 )
		{
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_up = @ボタン_エクストラ_サウンド_トラックリスト
		}
		
		// 最下段
		if( @エクストラ_サウンド_登録ＢＧＭ数 - 5 < $i )
		{
			$stage.object[@ボタン_エクストラ_サウンド_サムネイル + $i].joypad_down = @ボタン_エクストラ_サウンド_トラックリスト
		}
	}
	
	// サウンドプレイヤー
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_up    = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_down  = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_up    = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_down  = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_up    = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_down  = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_up    = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_down  = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_up    = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_down  = @ボタン_エクストラ_サウンド_再生中のＢＧＭ
}
