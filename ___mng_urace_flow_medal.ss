//===========================================================================
//!
//!    @file     ___mng_urace_flow_medal.ss
//!    @brief    ＵＭＡレース／メダル詳細画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     複数の画面から遷移してくるためオーバーレイとして表示する
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景		50
	#replace	@オブジェクト_演出		51
	#replace	@ボタン_閉じる			52
	
	// 変数
	#property	$select_btn				// 選択したボタン
	
#inc_end


//===========================================================================
// メダル詳細フロー
//===========================================================================
#z00

$$create_scene_object(front)		// シーンオブジェクトを作成する
$$set_joypad_navigation(front)		// パッド入力の遷移を設定する

// すべてのメダルをコンプリートした際に一度だけ発生する演出
if( $$get_urace_medal_complete_flag && @ＵＭＡレースのメダルコンプリート演出を見た == 0 )
{
	$$show_medal_complete_effect(front.object[@オブジェクト_演出])
	@ＵＭＡレースのメダルコンプリート演出を見た = 1
}

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_MODAL>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
	
	// キャンセルは閉じるボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_閉じる
	}
	
	// 閉じるボタンが押された場合は終了する
	if( $select_btn == @ボタン_閉じる )
	{
		break
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

$$hide_scene_object(front)			// シーンオブジェクトを非表示にする

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $base_x
	property $base_y
	property $offset_x
	property $offset_y
	
	// フィルター
	$stage.object[@オブジェクト_背景].create("__mng_ur_medal_filter", 1)
	$stage.object[@オブジェクト_背景].child.resize(<URACE_MEDAL_MAX> + 2)
	
	// 背景
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_medal_bg", 1, 177, 117)
	
	// タグ
	$stage.object[@オブジェクト_背景].child[1].create("__mng_ur_medal_tag", 1, 0, 0)
	
	// メダルボタン
	$base_x = 271
	$base_y = 289
	$offset_x = 284
	$offset_y = 285
	for( $i = 0, $i < <URACE_MEDAL_MAX>, $i += 1 ) {
		$stage.object[@オブジェクト_背景].child[2 + $i].create("__mng_ur_medal_icon", $$get_urace_medal_flag($i), $base_x + ($i % 5) * $offset_x, $base_y + ($i / 5) * $offset_y, $i)
	}
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], "__mng_ur_medal_back_btn", 2, 973, @ボタン_閉じる, <URACE_BTN_GROUP_MODAL>, 2)
	
	// todo メダルコンプリートしているときは賑やかしを入れる
	if( $$get_urace_medal_complete_flag )
	{
		$stage.object[@オブジェクト_演出].init
		$stage.object[@オブジェクト_演出].disp = 1
		$stage.object[@オブジェクト_演出].layer = <LAYER_SCREEN>
		// キラキラパーティクルとか
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	$stage.object[@オブジェクト_背景].init
	$stage.object[@オブジェクト_演出].init
	$stage.object[@ボタン_閉じる].init
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_閉じる)
}

//---------------------------------------------------------------------------
// すべてのメダルをコンプリートした際に一度だけ発生する演出
//---------------------------------------------------------------------------
command $$show_medal_complete_effect(property $obj : object)
{
	timewait(500)
	
	$obj.child.resize(2)
	$obj.child[0].create(_mng_ur_medal_complete_bg, 1, 151, 393)
	$obj.child[1].create(_mng_ur_medal_complete_font, 1, 646, 421)
	
	$obj.child[0].scale_x = 0
	$obj.child[0].scale_x_eve.set(1000, 250, 0, 2)
	$obj.child[0].tr_eve.set(0, 250, 1000, 2)
	$obj.child[1].tr = 0
	$obj.child[1].tr_eve.set(255, 250, 0, 2)
	$obj.child[1].tr_rep.resize(1)
	$obj.child[1].tr_rep[0] = 255
	$obj.child[1].tr_rep_eve[0].set(0, 250, 1000, 2)
}








//-----------------------------------------------------------------
// 称号獲得出現アニメーションを再生する
//-----------------------------------------------------------------
command $$play_medal_get_animation(property $obj : object, property $medal_no)
{
	property $message : str
	property $wait_time
	property $pcm_ch
	
	$message = $$get_urace_medal_get_text($medal_no)	// 表示するテキストを取得する
	msgbk.insert_msg($message)							// メッセージをバックログに追加
	
	// オブジェクト作成
	$$create_medal_get_object($obj, $message, $medal_no)
	
	// 効果音再生チャンネルを設定する
	$pcm_ch = 0
	
	// 効果音再生
	@se(se_fanfare01, 0, $pcm_ch)
	$wait_time = 1000
	
	// スキップでも何が表示されたか分かるようにウェイトを入れる
	$$set_ctrl_skip_disable($wait_time)
	
	// 効果音終了待ち
	pcmch[$pcm_ch].wait_key
	
	// 終了処理
	R
	@se_stop(2000, $pcm_ch)
	
	// オブジェクト終了アニメーション
	$obj.tr_eve.set(0, 500, 0, 0)
	$obj.child[0].scale_x_eve.set(0, 250, 0, 2)
	$obj.child[1].scale_x_eve.set(0, 250, 0, 2)
	$obj.child[2].tr_eve.set(0, 250, 0, 2)
	timewait(500)
}

// 称号獲得オブジェクトを作成する
command $$create_medal_get_object(property $obj : object, property $message : str, property $medal_no)
{
	property $font_size
	
	$font_size = 38
	
	$obj.init
	$obj.disp = 1
	$obj.child.resize(3)
	$obj.layer = <LAYER_UI>
	
	// 下地
	$obj.child[0].create("__mng_ur_medal_get_bg", 1, 0, 324)
	$$set_image_center_rep($obj.child[0])
	$obj.child[1].create("__mng_ur_medal_icon" + math.tostr_zero($medal_no, 2), 1, 850, 350)
	$$set_image_center_rep($obj.child[1])
	
	// テキスト
	$obj.child[2].create_string($message, 1)
	$obj.child[2].set_string_param($font_size, 0, 0, 99, 0, 1, -1, 1)
	// テキストのセンタリング
	$obj.child[2].x = $$get_centering_text_x($message, $font_size)
	$obj.child[2].y = 600
	
	// アニメーション
	$obj.child[0].y_rep.resize(1)
	$obj.child[2].y_rep.resize(1)
	
	$obj.child[0].bright = 255
	$obj.child[0].bright_eve.set(0, 500, 0, 1)
	$obj.child[0].y_rep[0] = 50
	$obj.child[0].y_rep_eve[0].set(0, 500, 0, 2)
	$obj.child[0].tr = 0
	$obj.child[0].tr_eve.set(255, 500, 0, 2)
	
	$obj.child[1].bright = 255
	$obj.child[1].bright_eve.set(0, 500, 0, 1)
	$obj.child[1].tr = 0
	$obj.child[1].tr_eve.set(255, 300, 0, 2)
	$obj.child[1].rotate_x = 3600
	$obj.child[1].rotate_x_eve.set(0, 500, 0, 2)
	
	$obj.child[2].tr = 0
	$obj.child[2].tr_eve.set(255, 250, 500, 2)
}

//---------------------------------------------------------------------------
// 指定した文字列をセンタリングした場合のx座標を取得する
//---------------------------------------------------------------------------
command $$get_centering_text_x(property $text : str, property $font_size) : int
{
	return ((<SCREEN_WIDTH> - $text.cnt * $font_size) / 2)
}

