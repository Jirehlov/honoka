//===========================================================================
//!
//!    @file     _extra_sound_player.ss
//!    @brief    サウンドプレイヤー(アプリケーション側)
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
command $$create_extra_sound_player_object(property $stage : stage)
{
	$$create_ui_image($stage.object[@イメージ_エクストラ_サウンド_背景], _extra_sound_player_bg, 857, 993)
	$$create_ui_image($stage.object[@イメージ_エクストラ_サウンド_曲情報], _extra_sound_player_bgm_info, 311, 934)
	$$create_extra_sound_play_button($stage.object[@ボタン_エクストラ_サウンド_再生], _extra_sound_player_play_btn, 540, 983, @ボタン_エクストラ_サウンド_再生, <OBJBTN_GROUP_NO_EXCALL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_停止], _extra_sound_player_stop_btn, 651, 983, @ボタン_エクストラ_サウンド_停止, <OBJBTN_GROUP_NO_EXCALL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_前へ], _extra_sound_player_prev_btn, 715, 983, @ボタン_エクストラ_サウンド_前へ, <OBJBTN_GROUP_NO_EXCALL>, 0)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_次へ], _extra_sound_player_next_btn, 779, 983, @ボタン_エクストラ_サウンド_次へ, <OBJBTN_GROUP_NO_EXCALL>, 0)
	$$create_extra_sound_volume_slider($stage.object[@スライダー_エクストラ_サウンド_音量], _extra_sound_player_slider, 903, 996, @スライダー_エクストラ_サウンド_音量, <OBJBTN_GROUP_NO_EXCALL>, 0, 32, 33)
	$$create_ui_button($stage.object[@ボタン_エクストラ_サウンド_トラックリスト], _extra_sound_player_list_btn, 1281, 983, @ボタン_エクストラ_サウンド_トラックリスト, <OBJBTN_GROUP_NO_EXCALL>, 0)
	
	$$create_ui_button($stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー], _extra_header_gallery_btn, 420, 20, @ボタン_エクストラ_ヘッダー_ギャラリー, <OBJBTN_GROUP_NO_EXCALL>, 1)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ヘッダー_レコード], _extra_header_record_btn, 637, 20, @ボタン_エクストラ_ヘッダー_レコード, <OBJBTN_GROUP_NO_EXCALL>, 1)
	$$create_ui_button($stage.object[@ボタン_エクストラ_ヘッダー_タイトル], _extra_header_title_btn, 848, 20, @ボタン_エクストラ_ヘッダー_タイトル, <OBJBTN_GROUP_NO_EXCALL>, 2)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_extra_sound_player_joypad_navigation(property $stage : stage)
{
	$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].joypad_up    = @ボタン_エクストラ_サウンド_再生
	$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].joypad_left  = @ボタン_エクストラ_ヘッダー_タイトル
	$stage.object[@ボタン_エクストラ_ヘッダー_ギャラリー].joypad_right = @ボタン_エクストラ_ヘッダー_レコード
	
	$stage.object[@ボタン_エクストラ_ヘッダー_レコード].joypad_up    = @ボタン_エクストラ_サウンド_再生
	$stage.object[@ボタン_エクストラ_ヘッダー_レコード].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_ヘッダー_レコード].joypad_left  = @ボタン_エクストラ_ヘッダー_ギャラリー
	$stage.object[@ボタン_エクストラ_ヘッダー_レコード].joypad_right = @ボタン_エクストラ_ヘッダー_タイトル
	
	$stage.object[@ボタン_エクストラ_ヘッダー_タイトル].joypad_up    = @ボタン_エクストラ_サウンド_再生
	$stage.object[@ボタン_エクストラ_ヘッダー_タイトル].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_ヘッダー_タイトル].joypad_left  = @ボタン_エクストラ_ヘッダー_レコード
	$stage.object[@ボタン_エクストラ_ヘッダー_タイトル].joypad_right = @ボタン_エクストラ_ヘッダー_ギャラリー
	
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_up    = -1
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_left  = @ボタン_エクストラ_サウンド_トラックリスト
	$stage.object[@ボタン_エクストラ_サウンド_再生].joypad_right = @ボタン_エクストラ_サウンド_停止
	
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_up    = -1
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_left  = @ボタン_エクストラ_サウンド_再生
	$stage.object[@ボタン_エクストラ_サウンド_停止].joypad_right = @ボタン_エクストラ_サウンド_前へ
	
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_up    = -1
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_left  = @ボタン_エクストラ_サウンド_停止
	$stage.object[@ボタン_エクストラ_サウンド_前へ].joypad_right = @ボタン_エクストラ_サウンド_次へ
	
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_up    = -1
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_left  = @ボタン_エクストラ_サウンド_前へ
	$stage.object[@ボタン_エクストラ_サウンド_次へ].joypad_right = @スライダー_エクストラ_サウンド_音量
	
	$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_up    = @動作_エクストラ_サウンド_音量_上げる
	$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_down  = @動作_エクストラ_サウンド_音量_下げる
	$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_left  = @ボタン_エクストラ_サウンド_次へ
	$stage.object[@スライダー_エクストラ_サウンド_音量].joypad_right = @ボタン_エクストラ_サウンド_トラックリスト
	
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_up    = -1
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_down  = -1
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_left  = @スライダー_エクストラ_サウンド_音量
	$stage.object[@ボタン_エクストラ_サウンド_トラックリスト].joypad_right = @ボタン_エクストラ_サウンド_再生
}
