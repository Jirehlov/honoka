//===========================================================================
//!
//!    @file     __app_macro.inc
//!    @brief    アプリケーション専用マクロ
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     汎用的でないアプリケーション固有のマクロ
//!
//===========================================================================

//---------------------------------------------------------------------------
// オブジェクト定義
//---------------------------------------------------------------------------
#replace	<OBJ_APP_EFFECT01>		90			// エフェクト
#replace	<OBJ_APP_EFFECT02>		91			// エフェクト
#replace	<OBJ_APP_EFFECT03>		92			// エフェクト
#replace	<OBJ_APP_EFFECT04>		93			// エフェクト


//---------------------------------------------------------------------------
// フォント定義
//---------------------------------------------------------------------------
#replace	@アイテム獲得フォント		"M+ 1mn medium"


//---------------------------------------------------------------------------
// 視点変更
//---------------------------------------------------------------------------
#define		@麦視点				@視点変更(0)
#define		@スピカ視点			@視点変更(1)
#define		@愛乃視点			@視点変更(2)
#define		@淡雪視点			@視点変更(3)
#define		@小詠視点			@視点変更(4)
#define		@六花視点			@視点変更(5)
#define		@その他視点			@視点変更(6)

#macro		@視点変更(@chara_no)
	if( get_mwnd != 0 )
	{
		@dm("メッセージウィンドウ０番以外（通常メッセージウィンドウ）での視点変更は使用できません。処理をスキップします。")
	}
	else
	{
		close
		$$set_character_view_filter(@chara_no)
		@視点フラグ = @chara_no
	}

#define		@視点フラグ			F[0]

#command $$set_character_view_filter(int)		// 各視点のメッセージウィンドウフィルターを設定する

//---------------------------------------------------------------------------
// システム
//---------------------------------------------------------------------------
#macro	@本編ユーザー制御
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
	script.set_mouse_disp_off				// マウスカーソルを非表示にする
	script.set_msg_back_disable				// メッセージバックを禁止する
	script.set_shortcut_disable				// ショートカットを禁止する

#macro	@本編ユーザー制御解除
	syscom.set_syscom_menu_enable			// システムコマンドを許可する
	syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを許可する
	script.set_mouse_disp_on				// マウスカーソルを表示する
	script.set_msg_back_enable				// メッセージバックを許可する
	script.set_shortcut_enable				// ショートカットを許可する

#macro	@ゲームパッド早送り可能制御
	script.set_allow_joypad_mode_onoff(1)
	frame_action_ch[<FRAME_ACTION_CH_CHK_PAD_INPUT>].start(-1, "$$fa_check_joypad_input")

#macro	@ゲームパッド早送り可能制御解除
	script.set_allow_joypad_mode_onoff_default
	frame_action_ch[<FRAME_ACTION_CH_CHK_PAD_INPUT>].end
	frame		// フレームアクション終了処理が先に終わる保証がなさそうな気がするので念のため時間を更新する

// メッセージウィンドウが一度も表示されてないタイトルメニューなどから既読スキップを可能にする特殊な命令
// ※特殊なので冒頭など以外では使用しない※
#macro	@既読スキップ可能用空行挿入
	set_waku(2)			// 枠を透明に変更する
	""					// 空行
	clear				// メッセージウィンドウをクリアする
	close				// メッセージウィンドウを閉じる
	
	// タブレットモードによって戻す枠を変更する
	if( <TABLET_MODE> == <TABLET_MODE_OFF> ) {
		set_waku(__DEFAULT_MW_WAKU_NO)
	} else {
		set_waku(__TABLET_MODE_WAKU_NO)
	}

#replace	<FRAME_ACTION_CH_CHK_PAD_INPUT>		5		// パッド入力監視

#command $$fa_check_joypad_input(frameaction)			// ユーザー制御中にパッド入力を監視するフレームアクション

#macro	@レコード全クリアチェック
	if( @朱比華ルートクリア && @愛乃ルートクリア && @陽彩ルートクリア && @小詠ルートクリア && @六花ルートクリア &&
		@エタニクルルートクリア && @アネモイルートクリア &&
		@文弥ルートクリア && @塁ルートクリア && @つづらルートクリア && @千春ルートクリア && @健ルートクリア )
	{
		@レコード獲得(@レコード_全ルートをクリアした)
	}


//---------------------------------------------------------------------------
// ムービー
//---------------------------------------------------------------------------
#macro	@ＯＰムービー
	$$play_movie("anemoi_op", @ＯＰを見た)
	@ＯＰを見た = 1
	bgmtable.set_listen_by_name(BGM81, 1)		// ＢＧＭフラグ(ＯＰ)
	@fade(0, 1000)
	@waitkey(2000)


//---------------------------------------------------------------------------
// フェード系
//---------------------------------------------------------------------------
#macro	@時間経過(@wipe_no(3), @wait_time(1000), @se_fade_time(2000))
	@se_stop_all(@se_fade_time)
	@fade(@wipe_no, @wait_time)
	@waitkey(@wait_time)

#macro	@その場で時間経過(@fade_wipe_no(3), @wait_time(1000), @disp_wipe_no(3))
	K[0] = front.object[<OBJ_BG>].get_file_name
	@fade(@fade_wipe_no, @wait_time)
	@waitkey(@wait_time)
	@bg(K[0], @disp_wipe_no)

#macro	@移動(@wait_time(1000), @bgm_stop_time(2000))
	if( @bgm_stop_time != -1 ) {
		@bgm_stop(@bgm_stop_time)
	}
	@fade(25)
	if( @wait_time > 0 ) {
		@waitkey(@wait_time)
	}

#macro	@場所移動(@bg_name, @wait_time(1000))
	@fade(25)
	if( @wait_time > 0 ) {
		@waitkey(@wait_time)
	}
	@bg(@bg_name, 25)


//---------------------------------------------------------------------------
// ベース演出の拡張系
//---------------------------------------------------------------------------
// 立ち絵フォーカス
#macro	@focus(@bs_name, @wipe_no(__DEFAULT_BG_WIPE_NO), @bg_name(<NONE>), @close(__DEFAULT_BG_MSG_CLOSE), @bg_scale(2000), @bg_offset_x(0), @bg_offset_y(0))
	if( @close ) { close }
	if( @bg_name == <NONE> ) { K[0] = front.object[<OBJ_BG>].get_file_name }
	else { K[0] = $$get_bg_time_control_name(@bg_name) }
	if( K[0].left(2) != "b_" ) { K[0] = "b_" + K[0] }
	if( $$exists_g00(K[0]) == 0 ) { K[0] = K[0].mid(2, K[0].cnt) }
	@bg_set(K[0], @bg_scale, @bg_offset_x, @bg_offset_y)
	@bs_set(@bs_name)
	@wipe(@wipe_no)

// 立ち絵フォーカス終了
#macro	@focus_end(@bs_name, @wipe_no(__DEFAULT_BG_WIPE_NO), @bg_name(<NONE>), @close(__DEFAULT_BG_MSG_CLOSE))
	if( @close ) { close }
	if( @bg_name == <NONE> ) { K[0] = front.object[<OBJ_BG>].get_file_name }
	else { K[0] = $$get_bg_time_control_name(@bg_name) }
	if( K[0].left(2) == "b_" ) { K[0] = K[0].mid(2, K[0].cnt) }
	if( $$exists_g00(K[0]) == 0 ) { K[0] = K[0].mid(2, K[0].cnt) }
	@bg_set(K[0])
	@bs_set(@bs_name)
	@wipe(@wipe_no)

// 立ち絵パン(x)
#macro	@bgs_pan_x(@bs_name, @wipe_no(__DEFAULT_BG_WIPE_NO), @bg_name(<NONE>), @move_time(3000), @speed_mode(2), @bs_pos_x(0), @bs_pos_y(0), @move_x(100), @close(__DEFAULT_BG_MSG_CLOSE))
	if( @close ) { close }
	if( @bg_name == <NONE> ) { K[0] = front.object[<OBJ_BG>].get_file_name }
	else { K[0] = $$get_bg_time_control_name(@bg_name) }
	if( K[0].left(2) != "b_" ) { K[0] = "b_" + K[0] }
	if( $$exists_g00(K[0]) == 0 ) { K[0] = K[0].mid(2, K[0].cnt) }
	@bg_move(K[0], -1, -@move_x / 2, 0, 0, 0, @move_time, @speed_mode)
	@bs_set(@bs_name, @bs_pos_x - @move_x, @bs_pos_y)
	@bs_move_x(@bs_name, @move_x, @move_time, 0, @speed_mode, 0, 1)
	@wipe(@wipe_no)

// 立ち絵パン(y)
#macro	@bgs_pan_y(@bs_name, @wipe_no(__DEFAULT_BG_WIPE_NO), @bg_name(<NONE>), @move_time(3000), @speed_mode(2), @bs_pos_x(0), @bs_pos_y(0), @move_y(100), @close(__DEFAULT_BG_MSG_CLOSE))
	if( @close ) { close }
	if( @bg_name == <NONE> ) { K[0] = front.object[<OBJ_BG>].get_file_name }
	else { K[0] = $$get_bg_time_control_name(@bg_name) }
	if( K[0].left(2) != "b_" ) { K[0] = "b_" + K[0] }
	if( $$exists_g00(K[0]) == 0 ) { K[0] = K[0].mid(2, K[0].cnt) }
	@bg_move(K[0], -1, 0, -@move_y / 2, 0, 0, @move_time, @speed_mode)
	@bs_set(@bs_name, @bs_pos_x, @bs_pos_y - @move_y)
	@bs_move_y(@bs_name, @move_y, @move_time, 0, @speed_mode, 0, 1)
	@wipe(@wipe_no)

// 立ち絵ドラマパン(x)
#macro	@bgs_drama_pan_x(@bs_name, @wipe_no(__DEFAULT_BG_WIPE_NO), @bg_name(<NONE>), @move_time(3000), @speed_mode(2), @bs_pos_x(0), @bs_pos_y(0), @move_x(100), @close(__DEFAULT_BG_MSG_CLOSE))
	if( @close ) { close }
	if( @bg_name == <NONE> ) { K[0] = front.object[<OBJ_BG>].get_file_name }
	else { K[0] = $$get_bg_time_control_name(@bg_name) }
	if( K[0].left(2) != "b_" ) { K[0] = "b_" + K[0] }
	if( $$exists_g00(K[0]) == 0 ) { K[0] = K[0].mid(2, K[0].cnt) }
	@bg_move(K[0], -1, @move_x / 2, 0, 0, 0, @move_time, @speed_mode)
	@bs_set(@bs_name, @bs_pos_x - @move_x, @bs_pos_y)
	@bs_move_x(@bs_name, @move_x, @move_time, 0, @speed_mode, 0, 1)
	@wipe(@wipe_no)

// 立ち絵ドラマパン(y)
#macro	@bgs_drama_pan_y(@bs_name, @wipe_no(__DEFAULT_BG_WIPE_NO), @bg_name(<NONE>), @move_time(3000), @speed_mode(2), @bs_pos_x(0), @bs_pos_y(0), @move_y(100), @close(__DEFAULT_BG_MSG_CLOSE))
	if( @close ) { close }
	if( @bg_name == <NONE> ) { K[0] = front.object[<OBJ_BG>].get_file_name }
	else { K[0] = $$get_bg_time_control_name(@bg_name) }
	if( K[0].left(2) != "b_" ) { K[0] = "b_" + K[0] }
	if( $$exists_g00(K[0]) == 0 ) { K[0] = K[0].mid(2, K[0].cnt) }
	@bg_move(K[0], -1, 0, @move_y / 2, 0, 0, @move_time, @speed_mode)
	@bs_set(@bs_name, @bs_pos_x, @bs_pos_y - @move_y)
	@bs_move_y(@bs_name, @move_y, @move_time, 0, @speed_mode, 0, 1)
	@wipe(@wipe_no)

// 立ち絵影化
#macro	@bs_shadow(@bs_name, @dark(255), @tr(255))
	l[0] = $$get_bs_obj_index(@bs_name)
	back.object[l[0]].color_r = 0
	back.object[l[0]].color_g = 0
	back.object[l[0]].color_b = 0
	back.object[l[0]].color_rate = @dark
	back.object[l[0]].tr = @tr
	back.object[l[0]].dark = @dark

// 立ち絵明るい化
#macro	@bs_bright(@bs_name, @bright(255), @tr(255))
	l[0] = $$get_bs_obj_index(@bs_name)
	back.object[l[0]].tr = @tr
	back.object[l[0]].bright = @bright

// 立ち絵拡縮
#macro	@bs_scale(@bs_name, @src_zoom(1500), @dst_zoom(1000), @zoom_time(30000), @speed_mode(0), @center_rep_y(980))
	back.object[$$get_bs_obj_index(@bs_name)].center_rep_y = @center_rep_y
	$$set_scale_eve(back.object[$$get_bs_obj_index(@bs_name)], @src_zoom, @dst_zoom, @zoom_time, 0, @speed_mode)


//---------------------------------------------------------------------------
// 日付
//---------------------------------------------------------------------------
#command $$set_date(str)			// 日付の設定(文字列指定)


//---------------------------------------------------------------------------
// 称号（マクロは000_称号.inc）
//---------------------------------------------------------------------------
#command $$get_title : str								// 現在の称号を取得する
#command $$set_title(str)								// 現在の称号を設定する
#command $$has_title(str) : int							// 過去に称号を取得したことがあるか
#command $$get_title_get_text(str) : str				// 称号獲得時のテキストを取得する
#command $$play_title_get_animation(object, str, int)	// 称号獲得アニメーションを再生する


//---------------------------------------------------------------------------
// 小詠Play（マクロは000_称号.inc）
//---------------------------------------------------------------------------
#command $$get_kyplay07_question_text(int) : str		// 小詠Play07質問
#command $$get_kyplay07_anser_text(int, int) : str		// 小詠Play07回答


//---------------------------------------------------------------------------
// アイテム
//---------------------------------------------------------------------------
#macro	@アイテムを獲得(@メッセージ, @アニメーションタイプ(0))
	close
	$$play_item_get_animation(front.object[<OBJ_APP_EFFECT01>], @メッセージ, @アニメーションタイプ)

#command $$play_item_get_animation(object, str, int)	// アイテム獲得アニメーションを再生する


//---------------------------------------------------------------------------
// 画像文字（声再生のみ行わない）
//---------------------------------------------------------------------------
#macro	@画像文字_声再生なし(@filename, @patno(0), @name(""), @msg(""), @koe_no(-1), @chara_no(-1), @pos_x(0), @pos_y(0), @savepoint(1))

	// メッセージが設定されている／セーブポイントフラグがオンの場合はセーブポイントを設定する
	if( @msg != "" && @savepoint ) {
		savepoint
	}
	
	// ファイルネームは = デフォルトネーム + 末尾数字２桁(言語バージョン)にしています
	back.object[<OBJ_IMAGE_TEXT>].create(@filename + math.tostr_zero(@check_lang, 2), 1, @pos_x, @pos_y, @patno)
	back.object[<OBJ_IMAGE_TEXT>].layer = <LAYER_SCREEN>
	
	// メッセージバックに追加する
	$$add_msgback(@koe_no, @chara_no, @name, @msg)


//---------------------------------------------------------------------------
// アバン（冒頭）
//---------------------------------------------------------------------------
// 冒頭の画像文字
#macro	@アバン画像文字(@patno, @text, @koe_no(-1), @chara_no(-1), @wait_time(1500))
	@アバン画像文字表示(@patno, @text,				// 表示
						@koe_no, @chara_no)
	@アバン画像文字消去(@wait_time)					// 消去

// 冒頭の画像文字／個別制御版／表示
#macro	@アバン画像文字表示(@patno, @text, @koe_no(-1), @chara_no(-1))
	@画像文字_声再生なし(ef_avan_text, @patno, "",	// 画像文字作成
						@text, @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン
	@wipe_nowait(54, 2500)							// 表示
	@waitkey(500)									// 待ち時間
	exkoe(@koe_no, @chara_no)						// 声の再生
	@waitkey(1250)									// 待ち時間

// 冒頭の画像文字／個別制御版／消去
#macro	@アバン画像文字消去(@wait_time(2500), @end_wait_time(500))
	koe_wait_key									// 声終了待ち
	@waitkey(@wait_time)							// 待ち時間
	front.object[<OBJ_IMAGE_TEXT>].wipe_copy = 0	// ワイプコピーオフ
	@wipe(54, 1000)									// 消去
	@waitkey(@end_wait_time)						// 待ち時間


//---------------------------------------------------------------------------
// 過去ストーリー
//---------------------------------------------------------------------------
// 過去に起きたことの画像文字
#macro	@過去ストーリー文字(@patno, @text, @koe_no(-1), @chara_no(-1), @wait_time(1500), @end_wait_time(500))
	@過去ストーリー文字準備(@patno, @text, @koe_no, @chara_no)	// 準備
	@wipe(0, 1500)												// 表示
	@過去ストーリー文字待ち										// 待ち

// 過去に起きたことの画像文字／裏待機
#macro	@過去ストーリー文字準備(@patno, @text, @koe_no(-1), @chara_no(-1))
	@画像文字(ef_story_text, @patno, "", @text,		// 画像文字作成
			  @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン

// 過去に起きたことの画像文字／声終了待ち
#macro	@過去ストーリー文字待ち(@wait_time(1500), @end_wait_time(500))
	koe_wait_key									// 声終了待ち
	@waitkey(@wait_time)							// 待ち時間
	front.object[<OBJ_IMAGE_TEXT>].wipe_copy = 0	// ワイプコピーオフ
	@wipe(0, 2000)									// 消去
	@waitkey(@end_wait_time)						// 待ち時間

//---------------------------------------------------------------------------
// 火の粉（過去ストーリー）
//---------------------------------------------------------------------------
#macro	@過去ストーリー火の粉(@type(0))
	$$create_fire_spark_particle(back.object[<OBJ_APP_EFFECT01>], @type)

#macro	@過去ストーリー火の粉終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0

#command $$create_fire_spark_particle(object, int)		// 火の粉（過去ストーリー）



//---------------------------------------------------------------------------
// アイキャッチ
//---------------------------------------------------------------------------
#macro	@アイキャッチ(@date, @bg_name(ef_avan_bg02), @type(0))
	$$eye_catch(@date, @bg_name, @type)

#command $$eye_catch(str, str, int)			// アイキャッチ


//---------------------------------------------------------------------------
// オーロラ
//---------------------------------------------------------------------------
#macro	@オーロラ(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @close(__DEFAULT_BG_MSG_CLOSE), @type(0), @wipe_copy(0))
	if( @close ) { close }
	@オーロラ準備(@bg_name, @type, @wipe_copy)
	@オーロラ再生
	@wipe(@wipe_no)

#macro	@オーロラパン(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @src_block(4), @dst_block(6), @move_time(30000), @speed_mode(0), @scale(1500), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @type(0), @wipe_copy(0))
	if( @close ) { close }
	@オーロラ準備(@bg_name, @type, @wipe_copy)
	$$move_image_block(back.object[<OBJ_BG>], @src_block, @dst_block, @scale, @move_time, 0, @speed_mode)
	$$move_image_block(back.object[<OBJ_APP_EFFECT01>], @src_block, @dst_block, @scale, @move_time, 0, @speed_mode)
	@オーロラ再生
	@wipe(@wipe_no, -1, @wait, 0)

#macro	@オーロラパン→(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @time(30000), @speed_mode(0), @scale(1500), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @type(0), @wipe_copy(0))
	@オーロラパン(@bg_name, @wipe_no, 4, 6, @time, @speed_mode, @scale, @close, @wait, @type, @wipe_copy)

#macro	@オーロラパン←(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @time(30000), @speed_mode(0), @scale(1500), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @type(0), @wipe_copy(0))
	@オーロラパン(@bg_name, @wipe_no, 6, 4, @time, @speed_mode, @scale, @close, @wait, @type, @wipe_copy)

#macro	@オーロラパン↓(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @time(25000), @speed_mode(0), @scale(1500), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @type(0), @wipe_copy(0))
	@オーロラパン(@bg_name, @wipe_no, 2, 8, @time, @speed_mode, @scale, @close, @wait, @type, @wipe_copy)

#macro	@オーロラパン↑(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @time(25000), @speed_mode(0), @scale(1500), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @type(0), @wipe_copy(0))
	@オーロラパン(@bg_name, @wipe_no, 8, 2, @time, @speed_mode, @scale, @close, @wait, @type, @wipe_copy)

#macro	@オーロラ移動(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @src_x(0), @src_y(0), @dst_x(0), @dst_y(0), @move_time(30000), @speed_mode(0), @scale(1500), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @type(0), @wipe_copy(0))
	if( @close ) { close }
	@オーロラ準備(@bg_name, @type, @wipe_copy)
	back.object[<OBJ_BG>].set_scale(@scale, @scale)
	$$set_pos_eve(back.object[<OBJ_BG>], @src_x, @src_y, @dst_x, @dst_y, @move_time, 0, @speed_mode)
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	$$set_pos_eve(back.object[<OBJ_APP_EFFECT01>], @src_x, @src_y, @dst_x, @dst_y, @move_time, 0, @speed_mode)
	@オーロラ再生
	@wipe(@wipe_no, -1, @wait, 0)

#macro	@オーロラズーム(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @src_scale(1500), @dst_scale(1000), @zoom_time(30000), @speed_mode(0), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @center_rep_x(-1), @center_rep_y(-1), @type(0), @wipe_copy(0))
	@オーロラ準備(@bg_name, @type, @wipe_copy)
	$$set_scale_eve(back.object[<OBJ_BG>], @src_scale, @dst_scale, @zoom_time, 0, @speed_mode)
	if( @center_rep_x != -1 ) {
		back.object[<OBJ_BG>].center_rep_x = @center_rep_x
	}
	if( @center_rep_y != -1 ) {
		back.object[<OBJ_BG>].center_rep_y = @center_rep_y
	}
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], @src_scale, @dst_scale, @zoom_time, 0, @speed_mode)
	if( @center_rep_x != -1 ) {
		back.object[<OBJ_APP_EFFECT01>].center_rep_x = @center_rep_x
	}
	if( @center_rep_y != -1 ) {
		back.object[<OBJ_APP_EFFECT01>].center_rep_y = @center_rep_y
	}
	@オーロラ再生
	@wipe(@wipe_no)

#macro	@オーロラズームアップ(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @zoom_time(30000), @speed_mode(0), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @center_rep_x(-1), @center_rep_y(-1), @type(0), @wipe_copy(0))
	@オーロラズーム(@bg_name, @wipe_no, 1000, 1500, @zoom_time, @speed_mode, @close, @wait, @center_rep_x, @center_rep_y, @type, @wipe_copy)
	
#macro	@オーロラズームダウン(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @zoom_time(30000), @speed_mode(0), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @center_rep_x(-1), @center_rep_y(-1), @type(0), @wipe_copy(0))
	@オーロラズーム(@bg_name, @wipe_no, 1500, 1000, @zoom_time, @speed_mode, @close, @wait, @center_rep_x, @center_rep_y, @type, @wipe_copy)

#macro	@オーロラ消去
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0

#macro	@オーロラ準備(@bg_name(ef_bg05), @type(0), @wipe_copy(1))
	@bg_set(@bg_name)
	if( @type == 0 ) { back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_aurora_slow, 1, ready_only = 1) }
	else			 { back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_aurora_fast, 1, ready_only = 1) }
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	if( @wipe_copy ) { back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1 }
	disp

#macro	@オーロラ再生
	back.object[<OBJ_APP_EFFECT01>].resume_movie

#macro	@赤オーロラパン(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @src_block(4), @dst_block(6), @move_time(30000), @speed_mode(0), @scale(1500), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @type(0), @wipe_copy(0))
	if( @close ) { close }
	@赤オーロラ準備(@bg_name, @type, @wipe_copy)
	$$move_image_block(back.object[<OBJ_BG>], @src_block, @dst_block, @scale, @move_time, 0, @speed_mode)
	$$move_image_block(back.object[<OBJ_APP_EFFECT01>], @src_block, @dst_block, @scale, @move_time, 0, @speed_mode)
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	@赤オーロラ再生
	@wipe(@wipe_no, -1, @wait, 0)

#macro	@赤オーロラズーム(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @src_scale(1500), @dst_scale(1000), @zoom_time(30000), @speed_mode(0), @close(__DEFAULT_BG_MSG_CLOSE), @wait(__DEFAULT_BG_WAIT), @center_rep_x(-1), @center_rep_y(-1), @type(0), @wipe_copy(0))
	@赤オーロラ準備(@bg_name, @type, @wipe_copy)
	$$set_scale_eve(back.object[<OBJ_BG>], @src_scale, @dst_scale, @zoom_time, 0, @speed_mode)
	if( @center_rep_x != -1 ) {
		back.object[<OBJ_BG>].center_rep_x = @center_rep_x
	}
	if( @center_rep_y != -1 ) {
		back.object[<OBJ_BG>].center_rep_y = @center_rep_y
	}
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], @src_scale, @dst_scale, @zoom_time, 0, @speed_mode)
	if( @center_rep_x != -1 ) {
		back.object[<OBJ_APP_EFFECT01>].center_rep_x = @center_rep_x
	}
	if( @center_rep_y != -1 ) {
		back.object[<OBJ_APP_EFFECT01>].center_rep_y = @center_rep_y
	}
	@赤オーロラ再生
	@wipe(@wipe_no)

//---------------------------------------------------------------------------
// 光の葉
//---------------------------------------------------------------------------
// ワイプで表示
#macro	@光の葉
	$$create_light_leaf_particle(back.object[<OBJ_APP_EFFECT01>], 0)
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1

#macro	@光の葉大きめ
	$$create_large_light_leaf_particle(back.object[<OBJ_APP_EFFECT01>])
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1

#macro	@光の葉終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0

#macro	@光の葉＋レンズフレア
	// 葉
	$$create_light_leaf_particle(back.object[<OBJ_APP_EFFECT01>], 1)
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	// レンズフレア
	@レンズフレア(<LENS_FLARE_TYPE_EVENING_RL>, 255, 4)
	back.object[<OBJ_EFFECT_LENS_FLARE>].wipe_copy = 1

#macro	@光の葉＋レンズフレア_フェードアウト(@time(12000))
	front.object[<OBJ_APP_EFFECT01>].tr_eve.set(0, @time, 0, 0)
	front.object[<OBJ_EFFECT_LENS_FLARE>].tr_eve.set(0, @time, 0, 0)

#macro	@光の葉＋レンズフレア終了
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	back.object[<OBJ_EFFECT_LENS_FLARE>].wipe_copy = 0

#command $$create_light_leaf_particle(object, int)				// 光る葉っぱパーティクル
#command $$create_large_light_leaf_particle(object)				// 光る葉っぱパーティクル(大きめ)


//---------------------------------------------------------------------------
// 災獣
//---------------------------------------------------------------------------
#macro	@災獣_狼(@wipe_no(3))
	@災獣_表示(ef_dark_monster01, @wipe_no)

#macro	@災獣_猪(@wipe_no(3))
	@災獣_表示(ef_dark_monster02, @wipe_no)

#macro	@災獣_鯨(@wipe_no(3))
	@災獣_表示(ef_dark_monster03, @wipe_no)

#macro	@災獣_バロン(@wipe_no(3))
	@災獣_表示(ef_dark_monster04, @wipe_no)

#macro	@災獣_蛇(@wipe_no(3))
	@災獣_表示(ef_dark_monster05, @wipe_no)

#macro	@災獣_鳥(@wipe_no(3))
	@災獣_表示(ef_dark_monster06, @wipe_no)

#macro	@災獣_竜(@wipe_no(3))
	@災獣_表示(ef_dark_monster07, @wipe_no)

#macro	@災獣_表示(@filename, @wipe_no(3))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(@filename, 1)
	// 960x480
	back.object[<OBJ_APP_EFFECT01>].set_scale(2000, 2000)
	back.object[<OBJ_APP_EFFECT01>].set_center_rep(960 / 2, 540 / 2)
	back.object[<OBJ_APP_EFFECT01>].set_pos(960 / 2, 540 / 2)
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_CHARACTER>
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	@wipe(@wipe_no)

#macro	@災獣_拡大(@wipe_no(3), @scale(2500))
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	@wipe(@wipe_no)

#macro	@災獣_縦スクロール(@wipe_no(3), @src_y(0), @dst_y(0), @scale(3000), @move_time(10000), @speed_mode(0), @offset_x(0))
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].x += @offset_x
	back.object[<OBJ_APP_EFFECT01>].y = @src_y
	back.object[<OBJ_APP_EFFECT01>].y_eve.set(@dst_y, @move_time, 0, @speed_mode)
	@wipe(@wipe_no)

#macro	@災獣_横スクロール(@wipe_no(3), @src_x(0), @dst_x(0), @scale(3000), @move_time(10000), @speed_mode(0), @offset_y(0))
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].x = @src_x
	back.object[<OBJ_APP_EFFECT01>].x_eve.set(@dst_x, @move_time, 0, @speed_mode)
	back.object[<OBJ_APP_EFFECT01>].y += @offset_y
	@wipe(@wipe_no)

#macro	@災獣_ズーム(@wipe_no(3), @src_scale(2500), @dst_scale(2500), @move_time(10000), @speed_mode(0))
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], @src_scale, @dst_scale, @move_time, 0, @speed_mode)
	@wipe(@wipe_no)

#macro	@災獣_咆哮(@type(0))
	if( @type == 0 ) {
		back.object[<OBJ_BG>].set_scale(1500, 1500)
		back.object[<OBJ_BG>].scale_x_eve.set(1000, 500, 0, 2)
		back.object[<OBJ_BG>].scale_y_eve.set(1000, 500, 0, 2)
		back.object[<OBJ_APP_EFFECT01>].set_scale(3000, 3000)
		back.object[<OBJ_APP_EFFECT01>].scale_x_eve.set(2000, 500, 0, 2)
		back.object[<OBJ_APP_EFFECT01>].scale_y_eve.set(2000, 500, 0, 2)
	}
	back.object[<OBJ_APP_EFFECT01>].blend = 0
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	@揺れ中
	@集中線(64)
	@wipe(122, 500)
	
	@集中線終了
	@wipe_nowait(121)
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	@揺れ強

#macro	@災獣_出現エフェクト(@bg_name)
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust02, 1)
	back.object[<OBJ_APP_EFFECT02>].blend = 4
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT02>].color_add_b = 128
	back.object[<OBJ_APP_EFFECT02>].set_scale(2000, 2000)
	back.object[<OBJ_APP_EFFECT02>].y = 400
	back.object[<OBJ_APP_EFFECT02>].y_eve.set(-400, 5000, 0, 2)
	@bg_move(@bg_name, 3, 0, -200, 0, 200, 1000, 2, 2000)
	@waitkey(1000)
	@se(SE_creature_appear1, 500, 1)
	
#macro	@災獣_出現エフェクト消去
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0

#macro	@災獣_出現一段階
	back.object[<OBJ_APP_EFFECT01>].set_scale(8000, 8000)
	back.object[<OBJ_APP_EFFECT01>].bright = 255
	back.object[<OBJ_APP_EFFECT01>].color_add_b = 128
	back.object[<OBJ_APP_EFFECT01>].color_add_r = 128
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].tr_eve.set(128, 1000, 0, 0)
	disp
	@wipe(122, 1500)
	@waitkey(1500)

#macro	@災獣_出現二段階
	back.object[<OBJ_APP_EFFECT01>].set_scale(5000, 5000)
	back.object[<OBJ_APP_EFFECT01>].y_eve.set(200, 5000, 0, 2)
	back.object[<OBJ_APP_EFFECT01>].bright = 128
	back.object[<OBJ_APP_EFFECT01>].color_add_b = 128
	back.object[<OBJ_APP_EFFECT01>].color_add_r = 128
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].tr_eve.set(128, 2000, 0, 0)
	disp
	@se(SE_creature_appear2)
	@wipe(112, 1500)

#macro	@災獣_出現三段階
	back.object[<OBJ_APP_EFFECT01>].color_add_r = 128
	back.object[<OBJ_APP_EFFECT01>].color_add_b = 128
	back.object[<OBJ_APP_EFFECT01>].color_add_r_eve.set(0, 1000, 0, 1)
	back.object[<OBJ_APP_EFFECT01>].color_add_b_eve.set(0, 1000, 0, 1)
	@災獣_咆哮
	@se(SE_creature_shout, 0, 1)
	@se(SE_creature_scream)
	
#macro	@災獣_消滅(@wipe_no(4), @color_time(1000), @scale_time(3000), @wait_time(1000))
	@災獣_消去
	front.object[<OBJ_APP_EFFECT01>].color_add_r_eve.set(255, @color_time, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].color_add_g_eve.set(255, @color_time, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].color_add_b_eve.set(255, @color_time, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].scale_x_eve.set(2500, @scale_time, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].scale_y_eve.set(2500, @scale_time, 0, 0)
	@waitkey(@wait_time)
	@wipe(@wipe_no)

#macro	@災獣_風化
	front.object[<OBJ_APP_EFFECT01>].color_add_r_eve.set(128, 1000, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].color_add_b_eve.set(128, 1000, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].scale_x_eve.set(2500, 3000, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].scale_y_eve.set(2500, 3000, 0, 0)

#macro	@災獣_消去
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0


//---------------------------------------------------------------------------
// 災獣（出現前）
//---------------------------------------------------------------------------
#macro	@災獣_予兆(@wipe_no(112), @wipe_time(1500), @offset_y(-30))
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_dark_ball, 1, <SCREEN_CENTER_X>, <SCREEN_CENTER_Y> + @offset_y)
	$$set_image_center(back.object[<OBJ_APP_EFFECT02>])
	back.object[<OBJ_APP_EFFECT02>].blend = 1
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_ALL_FILTER>
	@wipe(@wipe_no, @wipe_time)

#macro	@災獣_予兆_背景
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust01, 1)
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT01>].color_add_b = 128

#macro	@災獣_予兆_横パン(@move_time(1000), @speed_mode(2))
	@災獣_予兆_背景
	back.object[<OBJ_APP_EFFECT01>].set_scale(1100, 1100)
	$$set_tr_eve(back.object[<OBJ_APP_EFFECT01>], 0, 255, @move_time, 0, @speed_mode)
	@災獣_予兆(-1)
	disp
	$$set_pos_x_eve(back.object[<OBJ_APP_EFFECT01>], -100, 0, @move_time, 0, @speed_mode)
	$$set_pos_x_eve(back.object[<OBJ_APP_EFFECT02>], <SCREEN_CENTER_X> - 150, <SCREEN_CENTER_X>, @move_time, 0, @speed_mode)

#macro	@災獣_予兆_消去
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0


//---------------------------------------------------------------------------
// 黒風（災獣周り）
//---------------------------------------------------------------------------
#macro	@黒い風(@wipe_no(102), @wipe_time(500), @shake(1))
	$$create_black_wind(back.object[<OBJ_APP_EFFECT02>])
	@wipe(@wipe_no, @wipe_time)
	if( @shake ) {
		@揺れ中ループ
	}

#macro	@黒い風終了(@shake(1))
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0
	if( @shake ) {
		@揺れループ停止
	}

#command $$create_black_wind(object)

//---------------------------------------------------------------------------
// 赤風（災獣周り）
//---------------------------------------------------------------------------
#macro	@赤い風(@wipe_no(102), @wipe_time(500), @shake(1))
	$$create_red_wind(back.object[<OBJ_APP_EFFECT02>], 0)
	@wipe(@wipe_no, @wipe_time)
	if( @shake ) {
		@揺れ中ループ
	}

#macro	@赤い風終了(@shake(1))
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0
	if( @shake ) {
		@揺れループ停止
	}

#macro	@赤い風パン(@wipe_no(3), @src_y(-270), @dst_y(270), @move_time(30000), @speed_mode(0), @scale(1500), @shake(1))
	$$create_red_wind(back.object[<OBJ_APP_EFFECT02>], 0)
	back.object[<OBJ_APP_EFFECT02>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT02>].set_center_rep(960, 540)
	$$set_pos_y_eve(back.object[<OBJ_APP_EFFECT02>], @src_y, @dst_y, @move_time, 0, @speed_mode)
	@wipe(@wipe_no)
	if( @shake ) {
		@揺れ中ループ
	}

#macro	@赤い風２(@wipe_no(102), @wipe_time(500), @shake(1))
	@風の回廊_浅層(1500, 1, 0, 0)
	back.object[<OBJ_APP_EFFECT02>].layer += 1
	$$create_red_wind(back.object[<OBJ_APP_EFFECT01>], 1)
	@wipe(@wipe_no, @wipe_time)
	if( @shake ) {
		@揺れ中ループ
	}

#macro	@赤い風２終了(@shake(1))
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0
	if( @shake ) {
		@揺れループ停止
	}


#command $$create_red_wind(object, int)


//---------------------------------------------------------------------------
// 過剰集中
//---------------------------------------------------------------------------
#macro	@過剰集中(@bgm_pause_flag(1), @se_loop_flag(1))
	close
	if( @bgm_pause_flag ) {
		@bgm_pause(2000)
	}
	$$concentration_start(back.object[<OBJ_APP_EFFECT01>])
	if( @se_loop_flag ) {
		@se_loop(SE_pulse_heart_loop, 2000, 6)
	}
	@wipe(121, 1000)
	
#macro	@過剰集中終了(@bgm_pause_flag(1), @se_loop_flag(1))
	close
	if( @se_loop_flag ) {
		@se_loop_stop(2000, 6)
	}
	$$concentration_end(front.object[<OBJ_APP_EFFECT01>])
	@se(SE_trigger_out)
	@回想枠終了
	@mono_end
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	@wipe(121, 1000)
	if( @bgm_pause_flag ) {
		@bgm_resume(2000)
	}

#macro	@過剰集中_塵_回想用
	$$concentration_dust(back.object[<OBJ_APP_EFFECT01>])

#command $$concentration_start(object)
#command $$concentration_end(object)
#command $$concentration_dust(object)

//---------------------------------------------------------------------------
// 寝起きの薄目（上下に黒フィルター）
//---------------------------------------------------------------------------
#macro	@寝起きフィルター(@type(1))
	back.object[<OBJ_APP_EFFECT01>].create(ef_eye_filter, 1, 0, 0, @type)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1

#macro	@寝起きフィルター終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0


//---------------------------------------------------------------------------
// 淡雪スタンプ
//---------------------------------------------------------------------------
#macro	@淡雪スタンプハナマル(@wipe_no(2), @se_play(1), @bg_name(<NONE>))
	@淡雪スタンプ共通(1, @wipe_no, @se_play, @bg_name)

#macro	@淡雪スタンプハナマル２つ(@wipe_no(2), @se_play(1), @bg_name(<NONE>))
	@淡雪スタンプ共通(1, @wipe_no, @se_play, @bg_name, -420)
	@淡雪スタンプ共通(1, @wipe_no, @se_play, @bg_name,  420, 1)

#macro	@淡雪スタンプハート(@wipe_no(2), @se_play(1), @bg_name(<NONE>))
	@淡雪スタンプ共通(0, @wipe_no, @se_play, @bg_name)

#macro	@淡雪スタンプハナマルハート(@wipe_no(2), @se_play(1), @bg_name(<NONE>))
	@淡雪スタンプ共通(1, @wipe_no, @se_play, @bg_name, -420)
	@淡雪スタンプ共通(0, @wipe_no, @se_play, @bg_name,  420, 1)

#macro	@淡雪スタンプハート２つ(@wipe_no(2), @se_play(1), @bg_name(<NONE>))
	@淡雪スタンプ共通(0, @wipe_no, @se_play, @bg_name, -420)
	@淡雪スタンプ共通(0, @wipe_no, @se_play, @bg_name,  420, 1)

#macro	@淡雪スタンプ共通(@patno, @wipe_no(2), @se_play(1), @bg_name(<NONE>), @offset_x(0), @offset_obj_no(0))
	close
	if( @se_play ) {
		@se(SE_stamp_pon)
	}
	if( @bg_name != <NONE> ) {
		@bg_set(__BG_BLUR_PREFIX + $$chop_bg_blur_name(@bg_name))
	} else {
		@bg_set(__BG_BLUR_PREFIX + $$chop_bg_blur_name(front.object[<OBJ_BG>].get_file_name))
	}
	$$set_simple_cutin_object(back.object[<OBJ_CUTIN> + @offset_obj_no], ef_cutin_hi_stamp, @offset_x, 0, @patno)
	back.object[<OBJ_CUTIN> + @offset_obj_no].wipe_copy = 1
	back.object[<OBJ_CUTIN> + @offset_obj_no].frame_action.start(-1, "$$fa_hi_stamp")
	@wipe(@wipe_no)

#macro	@淡雪スタンプ消去(@wipe_no(2), @bg_name(<NONE>))
	close
	if( @bg_name != <NONE> ) {
		@bg_set(@bg_name)
	} else {
		@bg_set($$chop_bg_blur_name(front.object[<OBJ_BG>].get_file_name))
	}
	front.object[<OBJ_CUTIN> + 0].wipe_copy = 0
	front.object[<OBJ_CUTIN> + 1].wipe_copy = 0
	@wipe(@wipe_no)

#command $$fa_hi_stamp(frameaction, object)		// スタンプフレームアクション


//---------------------------------------------------------------------------
// よい子はマネしないでください
//---------------------------------------------------------------------------
#macro	@よい子はマネしないでください(@text)
	@画像文字(ef_reminder_text, 0, "", @text)		// 画像文字作成
	back.object[<OBJ_IMAGE_TEXT>].y = 50
	back.object[<OBJ_IMAGE_TEXT>].y_eve.set(0, 1000, 0, 2)
	@wipe(0)

//---------------------------------------------------------------------------
// トイレに行きたい時は誤魔化さず正直に言いましょう
//---------------------------------------------------------------------------
#macro	@トイレに行きたい時は(@text)
	@画像文字(ef_reminder_text, 1, "", @text)		// 画像文字作成
	back.object[<OBJ_IMAGE_TEXT>].y = 50
	back.object[<OBJ_IMAGE_TEXT>].y_eve.set(0, 1000, 0, 2)
	@wipe(0)

#macro	@ツミレ看板_終了
	front.object[<OBJ_IMAGE_TEXT>].y = 0
	front.object[<OBJ_IMAGE_TEXT>].y_eve.set(50, 1000, 0, 2)
	@wipe(0)

//---------------------------------------------------------------------------
// 汎用演出系
//---------------------------------------------------------------------------


#macro	@空に浮かぶキャラ_左(@bs_name, @wipe_no(0))		@float_chara(@bs_name, @wipe_no, 0)
#macro	@空に浮かぶキャラ_右(@bs_name, @wipe_no(0))		@float_chara(@bs_name, @wipe_no, 1)
#macro	@空に浮かぶキャラ_中(@bs_name, @wipe_no(0))		@float_chara(@bs_name, @wipe_no, 2)

#macro	@float_chara(@bs_name, @wipe_no(0), @type(0))
	mask[2].init
	switch( @type ) {
	case(0)		mask[2].create(ef_bs_mask_l)
				@bs_set(@bs_name, -500)
	case(1)		mask[2].create(ef_bs_mask_r)
				@bs_set(@bs_name, 500)
	case(2)		mask[2].create(ef_bs_mask_c)
				@bs_set(@bs_name, 0)
	}
	back.object[$$get_bs_obj_index(@bs_name)].mask_no = 2
	@wipe(@wipe_no)


//---------------------------------------------------------------------------
// テスト中
//---------------------------------------------------------------------------
#macro	@bs_in(@bs_name, @wipe_no(2), @close(1))
	if( @close ) {
		close
	}
	@set_wipe_wait(1)
	@bs_w(@wipe_no, @bs_name)

#macro	@bs_out(@bs_name, @wipe_no(2), @close(1))
	if( @close ) {
		close
	}
	@set_wipe_wait(1)
	@bs_del_w(@wipe_no, @bs_name)

// レンズフレアパラメータ指定
#macro	@フェードアウトレンズフレア(@type, @tr(255), @blend(4), @fade_time(3000), @speed_mode(0))
	@レンズフレア(@type, @tr, @blend)
	$$set_tr_eve(back.object[<OBJ_EFFECT_LENS_FLARE>], @tr, 0, @fade_time, 0, @speed_mode)





//---------------------------------------------------------------------------
// 汎用エンジンに入れたほうがよさそうなもの
//---------------------------------------------------------------------------

// 立ち絵カットイン
#macro	@bs_cutin(@bs_name, @bg_name(bg_kuro), @wipe_no(0), @layer(<LAYER_CG>), @shadow(0))

	l[0] = $$get_bs_obj_index(@bs_name)
	
	if( front.object[<OBJ_APP_EFFECT01>].disp )
	{
		back.object[l[0]].create_copy_from(front.object[l[0]])
		$$change_bs_image(back.object[l[0]], @bs_name)
	}
	else
	{
		mask[1].init
		mask[1].create(cutin_maskc)
		mask[1].x = (1920 - 750) / 2 - 100
		mask[1].x_eve.set((1920 - 750) / 2, 500, 0, 2)
		
		$$set_bg_object(back.object[<OBJ_APP_EFFECT01>], @disp_bg)
		back.object[<OBJ_APP_EFFECT01>].change_file(@bg_name)
		back.object[<OBJ_APP_EFFECT01>].mask_no = 1
		back.object[<OBJ_APP_EFFECT01>].layer = @layer
		back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
		$$set_pos_x_eve(back.object[<OBJ_APP_EFFECT01>], -100, 0, 500, 0, 2)
		if( @bg_name == bg_kuro ) {
			back.object[<OBJ_APP_EFFECT01>].tr = 128
		}
		
		$$set_bs_object(back.object[l[0]], @bs_name)
		back.object[l[0]].mask_no = 1
		back.object[l[0]].layer = @layer + 1
		$$set_pos_x_eve(back.object[l[0]], <SCREEN_CENTER_X> - 100, <SCREEN_CENTER_X>, 500, 0, 2)
		if( @shadow ) {
			back.object[l[0]].dark = @shadow
		}
	}
	@wipe(@wipe_no, -1, __DEFAULT_BS_WAIT)

// 立ち絵カットイン消去
#macro	@bs_cutin_del(@bs_name, @wipe_no(0))
	l[0] = $$get_bs_obj_index(@bs_name)
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	front.object[l[0]].wipe_copy = 0
	$$set_pos_x_eve(front.object[<OBJ_APP_EFFECT01>], 0, 100, 500, 0, 2)
	$$set_pos_x_eve(front.object[l[0]], <SCREEN_CENTER_X>, <SCREEN_CENTER_X> + 100, 500, 0, 2)
	mask[1].x_eve.set((1920 - 750) / 2 + 100, 500, 0, 2)
	@wipe(@wipe_no, -1, __DEFAULT_BS_WAIT)

#macro	@回想シーン
	@回想枠
	@セピア_演出除外

#macro	@回想シーン終了
	@回想枠終了
	@セピア終了

#macro	@セピア_演出除外
	@セピア
	back.effect[0].begin_layer = 0
	back.effect[0].end_layer = <LAYER_SCREEN> - 1








































//---------------------------------------------------------------------------
// 風の回廊
//---------------------------------------------------------------------------
#macro	@風の回廊に入る
	@todo("サンプルムービーです。光は無数のアルミアス、時の流れが速い（現実）→遅い（回廊）移動のイメージです。現実に戻る場合は動きがゆっくりから速くなります")
	@fade_w
	back.object[<OBJ_APP_EFFECT01>].create_movie(move_world01, 1, auto_free = 0)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	@wipe(3)
	@waitkey(4000)
	front.object[<OBJ_APP_EFFECT01>].bright_eve.set(255, 2000, 0, 2)
	@fade_w
	@waitkey(1000)

#macro	@現実世界に戻る
	@todo("サンプルムービーです。光は無数のアルミアス、時の流れが速い（現実）→遅い（回廊）移動のイメージです。現実に戻る場合は動きがゆっくりから速くなります")
	@fade_w
	back.object[<OBJ_APP_EFFECT01>].create_movie(move_world11, 1, auto_free = 0)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	@wipe(3)
	@waitkey(4000)
	front.object[<OBJ_APP_EFFECT01>].bright_eve.set(255, 2000, 0, 2)
	@fade_w
	@waitkey(1000)


//---------------------------------------------------------------------------
// 風の回廊
//---------------------------------------------------------------------------
#macro	@風の回廊_浅層(@scale(1000), @blend(1), @bright(0), @back(1), @front(1))
	if( @back ) {
		back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust01, 1)
		back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
		back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG_FILTER>
		back.object[<OBJ_APP_EFFECT01>].blend = @blend
		back.object[<OBJ_APP_EFFECT01>].bright = @bright
		back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
		$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	}
	if( @front ) {
		back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust02, 1)
		back.object[<OBJ_APP_EFFECT02>].set_scale(@scale, @scale)
		back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_SCREEN>
		back.object[<OBJ_APP_EFFECT02>].blend = @blend
		back.object[<OBJ_APP_EFFECT02>].bright = @bright
		back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1
		$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	}
	disp

#macro	@風の回廊_中層(@scale(1000), @blend(1), @bright(0), @back(1), @front(1))
	if( @back ) {
		back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust03, 1)
		back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
		back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG_FILTER>
		back.object[<OBJ_APP_EFFECT01>].blend = @blend
		back.object[<OBJ_APP_EFFECT01>].bright = @bright
		back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
		$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	}
	if( @front ) {
		back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust04, 1)
		back.object[<OBJ_APP_EFFECT02>].set_scale(@scale, @scale)
		back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_SCREEN>
		back.object[<OBJ_APP_EFFECT02>].blend = @blend
		back.object[<OBJ_APP_EFFECT02>].bright = @bright
		back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1
		$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	}
	disp

#macro	@風の回廊_深層(@scale(1000), @blend(1), @bright(0), @back(1), @front(1))
	if( @back ) {
		back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust05, 1)
		back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
		back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG_FILTER>
		back.object[<OBJ_APP_EFFECT01>].blend = @blend
		back.object[<OBJ_APP_EFFECT01>].bright = @bright
		back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
		$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	}
	if( @front ) {
		back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust06, 1)
		back.object[<OBJ_APP_EFFECT02>].set_scale(@scale, @scale)
		back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_SCREEN>
		back.object[<OBJ_APP_EFFECT02>].blend = @blend
		back.object[<OBJ_APP_EFFECT02>].bright = @bright
		back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1
		$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	}
	disp

#macro	@風の回廊_終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0

#macro	@風の回廊_ズーム(@src_scale, @dst_scale, @zoom_time(30000), @speed_mode(0), @back(1), @front(1))
	if( @back ) {
		$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], @src_scale, @dst_scale, @zoom_time, 0, @speed_mode)
	}
	if( @front ) {
		$$set_scale_eve(back.object[<OBJ_APP_EFFECT02>], @src_scale, @dst_scale, @zoom_time, 0, @speed_mode)
	}


//---------------------------------------------------------------------------
// 風の回廊の門
//---------------------------------------------------------------------------
#macro	@風の回廊門(@type(1), @wipe_no(3), @scale(1000), @offset_x(0), @offset_y(0))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_gate_ + math.tostr_zero(@type, 2), 1, @offset_x, @offset_y)
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT01>].set_center_rep(960, 840)
	@wipe(@wipe_no)

#macro	@風の回廊門_吸収(@type(1), @wipe_no(3), @scale(1000), @offset_x(0), @offset_y(0))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_absorb_ + math.tostr_zero(@type, 2), 1, @offset_x, @offset_y)
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT01>].set_center_rep(960, 840)
	@wipe(@wipe_no)

#macro	@風の回廊門_縦スクロール(@wipe_no(3), @src_y(0), @dst_y(0), @scale(1500), @move_time(30000), @speed_mode(0), @offset_x(0))
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].x += @offset_x
	back.object[<OBJ_APP_EFFECT01>].y = @src_y
	back.object[<OBJ_APP_EFFECT01>].y_eve.set(@dst_y, @move_time, 0, @speed_mode)
	@wipe(@wipe_no)

#macro	@風の回廊門_横スクロール(@wipe_no(3), @src_x(0), @dst_x(0), @scale(1500), @move_time(30000), @speed_mode(0), @offset_y(0))
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].x = @src_x
	back.object[<OBJ_APP_EFFECT01>].x_eve.set(@dst_x, @move_time, 0, @speed_mode)
	back.object[<OBJ_APP_EFFECT01>].y += @offset_y
	@wipe(@wipe_no)
	
#macro	@風の回廊門が現れる_前半(@wipe_no(3), @wait_time(2000), @fade_wipe_no(3), @se_play(1))
	
	if( @se_play ) {
		@se(SE_elec_light_swallow_disappear, 2000, 2)
		@se_stop(5000, 2)
	}
	
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust01, 1)
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_BG_FILTER>
	back.object[<OBJ_APP_EFFECT02>].blend = 1
	back.object[<OBJ_APP_EFFECT02>].scale_x_eve.set(1250, 3000, 1000, 2)
	back.object[<OBJ_APP_EFFECT02>].scale_y_eve.set(1250, 3000, 1000, 2)
	back.object[<OBJ_APP_EFFECT02>].color_add_r_eve.set(128, 3000, 1000, 1)
	back.object[<OBJ_APP_EFFECT02>].bright_eve.set(255, 3000, 1000, 2)
	@wipe(@wipe_no)
	@waitkey(@wait_time)
	@fade_w(@fade_wipe_no)

#macro	@風の回廊門が現れる_後半(@type(1), @wipe_no(122), @se_play(1))
	
	if( @se_play ) {
		@se(SE_elec_light_pop, 1000, 0)
		@se(SE_elec_alumias_collective_to_individual, 1000, 1)
		@se_stop_all(5000)
	}
	
	$$gate_open_particle(back.object[<OBJ_APP_EFFECT02>])
	
	if( @type == 1 ) {
		back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_gate_ + math.tostr_zero(@type, 2), 1, 880, 740)
	} else {
		back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_gate_ + math.tostr_zero(@type, 2), 1, 960, 740)
	}
	back.object[<OBJ_APP_EFFECT01>].set_center(889, 702)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	back.object[<OBJ_APP_EFFECT01>].blend = 4
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT01>].set_scale(0, 0)
	back.object[<OBJ_APP_EFFECT01>].scale_x_eve.set(1000, 2000, 0, 2)
	back.object[<OBJ_APP_EFFECT01>].scale_y_eve.set(1000, 2000, 0, 2)
	
	back.object[<OBJ_APP_EFFECT01>].tr = 0
	back.object[<OBJ_APP_EFFECT01>].tr_eve.set(255, 250, 750, 2)
	
	back.object[<OBJ_APP_EFFECT01>].bright = 255
	back.object[<OBJ_APP_EFFECT01>].bright_eve.set(0, 2000, 0, 2)
	@wipe(@wipe_no)

#macro	@風の回廊門_終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0

#command $$gate_open_particle(object)


//---------------------------------------------------------------------------
// ダウンバースト
//---------------------------------------------------------------------------
#macro	@ダウンバースト(@wipe_no(3), @wipe_time(-1))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_downburst, 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG>
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	@wipe(@wipe_no,  @wipe_time)

#macro	@ダウンバースト_雨(@wipe_no(3), @wipe_time(-1))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_downburst_rain, 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG>
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	@wipe(@wipe_no,  @wipe_time)

#macro	@ダウンバースト_縦パン(@wipe_no(3), @src_y(0), @dst_y(0), @move_time(10000), @speed_mode(0), @scale(1500), @offset_x(0))
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].x += @offset_x
	back.object[<OBJ_APP_EFFECT01>].y = @src_y
	back.object[<OBJ_APP_EFFECT01>].y_eve.set(@dst_y, @move_time, 0, @speed_mode)
	@wipe(@wipe_no)

#macro	@ダウンバースト_横パン(@wipe_no(3), @src_x(0), @dst_x(0), @move_time(10000), @speed_mode(0), @scale(1500), @offset_y(0))
	back.object[<OBJ_APP_EFFECT01>].set_scale(@scale, @scale)
	back.object[<OBJ_APP_EFFECT01>].x = @src_x
	back.object[<OBJ_APP_EFFECT01>].x_eve.set(@dst_x, @move_time, 0, @speed_mode)
	back.object[<OBJ_APP_EFFECT01>].y += @offset_y
	@wipe(@wipe_no)

#macro	@ダウンバースト_ズーム(@wipe_no(3), @src_scale(1000), @dst_scale(1000), @zoom_time(10000), @speed_mode(0), @scale(1500))
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], @src_scale, @dst_scale, @zoom_time, 0, @speed_mode)
	@wipe(@wipe_no)

#macro	@ダウンバースト_終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0

#macro	@ダウンバースト_葉_準備(@wipe_copy(1), @layer(<LAYER_BG_FILTER>))
	@ダウンバースト_葉(-1)
	back.object[<OBJ_APP_EFFECT02>].layer = @layer
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = @wipe_copy

#macro	@ダウンバースト_葉_準備_ループなし(@layer(<LAYER_BG_FILTER>))
	back.object[<OBJ_APP_EFFECT02>].create_movie(ef_downburst_lief, 1)
	back.object[<OBJ_APP_EFFECT02>].layer = @layer
	back.object[<OBJ_APP_EFFECT02>].tr_Eve.set(0, 2000, 8000, 0)
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])

#macro	@ダウンバースト_葉_終了
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0

#macro	@ダウンバースト_赤葉_準備(@wipe_copy(1), @layer(<LAYER_BG_FILTER>))
	@ダウンバースト_葉(-1)
	back.object[<OBJ_APP_EFFECT02>].color_add_r = 128
	back.object[<OBJ_APP_EFFECT02>].layer = @layer
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = @wipe_copy


//---------------------------------------------------------------------------
// ダウンバーストシーンの背景色補正
//---------------------------------------------------------------------------
#macro	@ダウンバーストの前背景補正
	@ダウンバースト背景補正(24, 8)

#macro	@ダウンバースト背景補正(@dark(48), @add_r(16))
	back.object[<OBJ_BG>].dark = @dark
	back.object[<OBJ_BG>].color_add_r = @add_r

//---------------------------------------------------------------------------
// 同棲編ラスト災厄シーンの背景色補正
//---------------------------------------------------------------------------
#macro	@同棲編ラスト災厄の前背景補正
	@ダウンバースト背景補正(32, 16)
	back.object[<OBJ_BG>].mono = 96

#macro	@同棲編ラスト災厄の前背景補正_空
	@ダウンバースト背景補正(96, 0)
	back.object[<OBJ_BG>].mono = 128


//---------------------------------------------------------------------------
// モノクロ薄め（CG_SP11あたりと乖離しすぎないよう）
//---------------------------------------------------------------------------
#macro	@薄いモノクロ(@mono(128))
	back.effect[0].mono = @mono
	back.effect[0].wipe_copy = 1


//---------------------------------------------------------------------------
// 麦の腕が光る
//---------------------------------------------------------------------------
#macro	@麦の腕が光る(@change_time(1000), @delay_time(1000), @src_scale(1000), @dst_scale(1000))
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust01, 1)
	if( @src_scale != @dst_scale ) {
		back.object[<OBJ_APP_EFFECT02>].set_scale(@src_scale, @src_scale)
		back.object[<OBJ_APP_EFFECT02>].scale_x_eve.set(@dst_scale, @change_time, @delay_time, 2)
		back.object[<OBJ_APP_EFFECT02>].scale_y_eve.set(@dst_scale, @change_time, @delay_time, 2)
	}
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_BG_FILTER>
	back.object[<OBJ_APP_EFFECT02>].blend = 1
	back.object[<OBJ_APP_EFFECT02>].color_add_r_eve.set(128, @change_time, @delay_time, 1)
	back.object[<OBJ_APP_EFFECT02>].bright = 255
	back.object[<OBJ_APP_EFFECT02>].bright_eve.set(0, @change_time, @delay_time, 2)
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])

#macro	@麦の腕が光る終了
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0

//---------------------------------------------------------------------------
// 風
//---------------------------------------------------------------------------
#macro	@風_スピカ(@type(0), @wipe_no(3), @wipe_time(-1))
	$$sp_wind(@type)
	@wipe(@wipe_no,  @wipe_time)

#macro	@風_スピカフィルター
	back.object[<OBJ_APP_EFFECT02>].create(ef_eye_catch_filter, 1)
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1

#command $$sp_wind(int)
#command $$create_sp_wind_particle(object)


//---------------------------------------------------------------------------
// スピカ消える
//---------------------------------------------------------------------------
#macro	@スピカ消える
	$$sp_del_particle(back.object[<OBJ_APP_EFFECT02>])

#command $$sp_del_particle(object)


//---------------------------------------------------------------------------
// 小森健アナグラム
//---------------------------------------------------------------------------
#macro	@小森健アナグラム(@type, @text)
	$$kn_anagram(front.object[<OBJ_APP_EFFECT01>], @type, @text)

#command $$kn_anagram(object, int, str)


//---------------------------------------------------------------------------
// 電撃が横に走る
//---------------------------------------------------------------------------
#macro	@電撃(@type(0))
	@todo("ムービー：ムービーにしたほうがよさそう")
	front.object[<OBJ_APP_EFFECT01>].create(ef_spark01, 1)
	front.object[<OBJ_APP_EFFECT01>].blend = 1
	front.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	$$set_image_center_rep(front.object[<OBJ_APP_EFFECT01>])
	front.object[<OBJ_APP_EFFECT01>].patno_eve.loop(0, 15, 500, 0, 0)
	front.object[<OBJ_APP_EFFECT01>].set_clip(1, 0, 0, 1920, 1080)
	if( @type == 0 )
	{
		front.object[<OBJ_APP_EFFECT01>].clip_left = 1920
		disp
		front.object[<OBJ_APP_EFFECT01>].clip_left_eve.set(0, 200, 0, 0)
		front.object[<OBJ_APP_EFFECT01>].clip_right_eve.set(0, 200, 200, 0)
	}
	else
	{
		front.object[<OBJ_APP_EFFECT01>].clip_right = 0
		disp
		front.object[<OBJ_APP_EFFECT01>].clip_right_eve.set(1920, 200, 0, 0)
		front.object[<OBJ_APP_EFFECT01>].clip_left_eve.set(1920, 200, 200, 0)
	}


//---------------------------------------------------------------------------
// 同棲編ラスト画像文字
//---------------------------------------------------------------------------
// 同棲編ラストの画像文字
#macro	@同棲編ラスト文字(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""), @wait_time(500), @end_wait_time(0))
	close
	@同棲編ラスト文字準備(@patno, @text, @koe_no, @chara_no, @name)	// 準備
	@wipe(0, 1500)												// 表示
	@同棲編ラスト文字待ち(@wait_time, @end_wait_time)				// 待ち

// 同棲編ラストの画像文字／裏待機
#macro	@同棲編ラスト文字準備(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""))
	@画像文字(ef_eternicle_text, @patno, @name, @text,		// 画像文字作成
			  @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン

// 同棲編ラストの画像文字／声終了待ち
#macro	@同棲編ラスト文字待ち(@wait_time(500), @end_wait_time(0), @wipe_time(1500))
	koe_wait_key									// 声終了待ち
	@waitkey(@wait_time)							// 待ち時間
	front.object[<OBJ_IMAGE_TEXT>].wipe_copy = 0	// ワイプコピーオフ
	@wipe(0, @wipe_time)									// 消去
	@waitkey(@end_wait_time)						// 待ち時間

// 同棲編ラストフィルター
#macro	@同棲編ラストフィルター
	back.object[<OBJ_APP_EFFECT02>].create(ef_eye_catch_filter, 1)
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1

#macro	@同棲編ラストフィルター終了
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0

#macro	@同棲編ラスト_スピカ通常(@bs_name, @wipe_no(4))
	@風の回廊_中層
	@bs_set(@bs_name)
	@bg(bg_white, @wipe_no)

#macro	@同棲編ラスト_スピカ心(@bs_name, @wipe_no(3), @direct(0))
	@bg(bg_siro, -1)
	@寝起きフィルター(0)
	if( @direct == 0 ) {
		@bs_set(@bs_name, -50, -2000, 2500)
		@bs_move_x(sq, 50, 8000)
	} elseif( @direct == 1 ) {
		@bs_set(@bs_name, 0, -2050, 2500)
		@bs_move_y(sq, 50, 8000)
	} else {
		@bs_set(@bs_name, 0, -2000, 2600)
	}
	@bs_tr(sq, 255, 128)
	back.object[$$get_bs_index(sq)].bright = 64
	@wipe(@wipe_no)

#macro @スピカ光る(@bright(32))
	back.object[$$get_bs_obj_index("sp")].bright = @bright

#macro	@同棲編ラスト_スピカ消える
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust01, 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_ALL_FILTER>
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].color_add_b = 192
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], 1000, 5000, 10000, 0, 1)
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust02, 1)
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_ALL_FILTER>
	back.object[<OBJ_APP_EFFECT02>].blend = 1
	back.object[<OBJ_APP_EFFECT02>].color_add_b = 192
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT02>], 1000, 5000, 10000, 0, 1)
	disp
	front.object[$$get_bs_obj_index("sp")].bright_eve.set(255, 5000, 0, 0)

#macro	@同棲編ラスト_災厄消える(@wipe_no(121))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust01, 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_ALL_FILTER>
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].color_add_b = 192
	back.object[<OBJ_APP_EFFECT01>].tr_eve.set(0, 5000, 10000, 0)
	back.object[<OBJ_APP_EFFECT01>].bright = 255
	back.object[<OBJ_APP_EFFECT01>].bright_eve.set(0, 3000, 0, 2)
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], 1000, 5000, 10000, 0, 2)
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust02, 1)
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_ALL_FILTER>
	back.object[<OBJ_APP_EFFECT02>].blend = 1
	back.object[<OBJ_APP_EFFECT02>].color_add_b = 192
	back.object[<OBJ_APP_EFFECT02>].tr_eve.set(0, 5000, 10000, 0)
	back.object[<OBJ_APP_EFFECT02>].bright = 255
	back.object[<OBJ_APP_EFFECT02>].bright_eve.set(0, 3000, 0, 2)
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT02>], 1000, 5000, 10000, 0, 2)
	@wipe(@wipe_no)

//---------------------------------------------------------------------------
// 同棲編ラストスピカモノローグ
//---------------------------------------------------------------------------
#macro	@同棲編ラストスピカモノローグ(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""), @wait_time(500), @end_wait_time(0))
	@同棲編ラストスピカモノローグ準備(@patno, @text, @koe_no, @chara_no, @name)	// 準備
	@wipe(0, 1500)												// 表示
	@同棲編ラストスピカモノローグ待ち(@wait_time, @end_wait_time)				// 待ち

#macro	@同棲編ラストスピカモノローグ準備(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""))
	@画像文字(ef_sp_text, @patno, @name, @text,		// 画像文字作成
			  @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン

#macro	@同棲編ラストスピカモノローグ待ち(@wait_time(500), @end_wait_time(0), @wipe_time(2000))
	koe_wait_key									// 声終了待ち
	@waitkey(@wait_time)							// 待ち時間
	front.object[<OBJ_IMAGE_TEXT>].wipe_copy = 0	// ワイプコピーオフ
	@wipe(0, @wipe_time)									// 消去
	@waitkey(@end_wait_time)						// 待ち時間


//---------------------------------------------------------------------------
// 愛乃コックピット
//---------------------------------------------------------------------------
#macro	@コックピット_準備
	back.object[<OBJ_APP_EFFECT03>].create(ef_cutin_cockpit, 1)
	back.object[<OBJ_APP_EFFECT03>].layer = <LAYER_SCREEN>
	back.object[<OBJ_APP_EFFECT03>].wipe_copy = 1

#macro	@コックピット_終了
	front.object[<OBJ_APP_EFFECT03>].wipe_copy = 0

#macro	@愛乃ペンダント光る
	back.object[<OBJ_APP_EFFECT03>].create(ef_cutin_ainospendant, 1, 440, -350, 1)
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT03>])
	back.object[<OBJ_APP_EFFECT03>].set_scale(1500, 1500)
	back.object[<OBJ_APP_EFFECT03>].layer = <LAYER_SCREEN>
	$$set_pos_y_eve(back.object[<OBJ_APP_EFFECT03>], -400, -350, 1000, 0, 2)
	@wipe(3)
	@se(SE_elec_pendant_glow)
	@愛乃ペンダント光った後(0)

#macro	@愛乃ペンダント光った後(@wipe_no)
	back.object[<OBJ_APP_EFFECT03>].create(ef_cutin_ainospendant, 1, 440, -350)
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT03>])
	back.object[<OBJ_APP_EFFECT03>].bright = 255
	back.object[<OBJ_APP_EFFECT03>].bright_eve.set(0, 1500, 0, 2)
	back.object[<OBJ_BG>].bright = 160
	back.object[<OBJ_BG>].bright_eve.set(0, 1500, 0, 2)
	back.object[<OBJ_APP_EFFECT03>].set_scale(1500, 1500)
	back.object[<OBJ_APP_EFFECT03>].layer = <LAYER_SCREEN>
	@wipe(@wipe_no)

#macro	@愛乃成長_カットイン
	@寝起きフィルター(0)
	@cg_move(cg_ai11_0305, -1, 0, 0, -100, 0, 3000, 2, 4000)
	back.object[<OBJ_CG>].blend = 4
	back.object[<OBJ_CG>].tr = 128
	back.object[<OBJ_CG>].layer = <LAYER_SCREEN> + 1
	@wipe(4)


//---------------------------------------------------------------------------
// 淡雪2816ＥＤ／ＨＩ１１切り替え演出
//---------------------------------------------------------------------------
#macro	@淡雪2816ＥＤ_ＨＩ１１切り替え演出(@wipe_no(5))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust06, 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_SCREEN>
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	@wipe(@wipe_no)

//---------------------------------------------------------------------------
// 淡雪エピローグ用背景
//---------------------------------------------------------------------------
#macro	@淡雪エピローグ背景(@wipe_no(3), @wipe_time(-1), @type(6))
	@bg(bg_siro, -1)
	back.object[<OBJ_BG>].color_r = 64
	back.object[<OBJ_BG>].color_b = 128
	back.object[<OBJ_BG>].color_rate = 128
	back.object[<OBJ_BG>].tr_eve.turn(192, 64, 10000, 0, 0)
	back.object[<OBJ_BG>].bright_eve.turn(96, 192, 5000, 0, 0)
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust + math.tostr_zero(@type, 2), 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG_FILTER>
	back.object[<OBJ_APP_EFFECT01>].blend = 4
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT02>].create(ef_eye_catch_filter, 1)
	back.object[<OBJ_APP_EFFECT02>].color_r = 64
	back.object[<OBJ_APP_EFFECT02>].color_b = 128
	back.object[<OBJ_APP_EFFECT02>].color_rate = 128
	@wipe(@wipe_no, @wipe_time)


#command $$get_day : int

//---------------------------------------------------------------------------
// 小詠ラスト消える
//---------------------------------------------------------------------------
#macro	@小詠ラスト消える
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust01, 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_ALL_FILTER>
	back.object[<OBJ_APP_EFFECT01>].blend = 1
	back.object[<OBJ_APP_EFFECT01>].color_add_b = 192
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT01>], 1000, 5000, 10000, 0, 1)
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust02, 1)
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_ALL_FILTER>
	back.object[<OBJ_APP_EFFECT02>].blend = 1
	back.object[<OBJ_APP_EFFECT02>].color_add_b = 192
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	$$set_scale_eve(back.object[<OBJ_APP_EFFECT02>], 1000, 5000, 10000, 0, 1)
	disp


//---------------------------------------------------------------------------
// 立ち絵アルミアスっぽく
//---------------------------------------------------------------------------
#macro	@立ち絵アルミアスっぽく(@bs_name)
	back.object[$$get_bs_obj_index(@bs_name)].blend = 4


//---------------------------------------------------------------------------
// 小詠手紙
//---------------------------------------------------------------------------
// 小詠手紙の画像文字
#macro	@小詠手紙文字(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""), @wait_time(500), @end_wait_time(0))
	@小詠手紙文字準備(@patno, @text, @koe_no, @chara_no, @name)	// 準備
	@wipe(0, 1500)												// 表示
	@小詠手紙文字待ち(@wait_time, @end_wait_time)				// 待ち

// 小詠手紙の画像文字／裏待機
#macro	@小詠手紙文字準備(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""))
	@画像文字(ef_ky_text, @patno, @name, @text,		// 画像文字作成
			  @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン

// 小詠手紙の画像文字／声終了待ち
#macro	@小詠手紙文字待ち(@wait_time(500), @end_wait_time(0), @wipe_time(2000))
	koe_wait_key									// 声終了待ち
	@waitkey(@wait_time)							// 待ち時間
	front.object[<OBJ_IMAGE_TEXT>].wipe_copy = 0	// ワイプコピーオフ
	@wipe(0, @wipe_time)									// 消去
	@waitkey(@end_wait_time)						// 待ち時間

// 小詠手紙フィルター
#macro	@小詠手紙フィルター
	back.object[<OBJ_APP_EFFECT02>].create(ef_eye_catch_filter, 1)
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1

#macro	@小詠手紙フィルター終了
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0


//---------------------------------------------------------------------------
// 六花手紙
//---------------------------------------------------------------------------
// 六花手紙の画像文字
#macro	@六花手紙文字(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""), @wait_time(500), @end_wait_time(0))
	@六花手紙文字準備(@patno, @text, @koe_no, @chara_no, @name)	// 準備
	@wipe(0, 1500)												// 表示
	@六花手紙文字待ち(@wait_time, @end_wait_time)				// 待ち

// 六花手紙の画像文字／裏待機
#macro	@六花手紙文字準備(@patno, @text, @koe_no(-1), @chara_no(-1), @name(""))
	@画像文字(ef_rk_text, @patno, @name, @text,		// 画像文字作成
			  @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン

// 六花手紙の画像文字／声終了待ち
#macro	@六花手紙文字待ち(@wait_time(500), @end_wait_time(0), @wipe_time(2000))
	koe_wait_key									// 声終了待ち
	@waitkey(@wait_time)							// 待ち時間
	front.object[<OBJ_IMAGE_TEXT>].wipe_copy = 0	// ワイプコピーオフ
	@wipe(0, @wipe_time)									// 消去
	@waitkey(@end_wait_time)						// 待ち時間

// 六花手紙フィルター
#macro	@六花手紙フィルター
	back.object[<OBJ_APP_EFFECT02>].create(ef_eye_catch_filter, 1)
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1

#macro	@六花手紙フィルター終了
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0


//---------------------------------------------------------------------------
// テスト中
//---------------------------------------------------------------------------
#macro	@bg_r(@filename(@disp_bg), @wipe_no(-1))
	@bg_set(@filename, 1000, -50, 0)
	@wipe(@wipe_no)

#macro	@bg_l(@filename(@disp_bg), @wipe_no(-1))
	@bg_set(@filename, 1000, 50, 0)
	@wipe(@wipe_no)

#macro	@bg_c@filename(@disp_bg), @wipe_no(-1))
	@bg_set(@filename, 1000, 0, 0)
	@wipe(@wipe_no)




//---------------------------------------------------------------------------
// 汎用エンジンに入れたほうがよさそうなもの
//---------------------------------------------------------------------------

// 背景カットイン
#macro	@bg_cutin(@bg_name, @wipe_no(0), @bg_offset_x(0), @bg_offset_y(0), @cutin_mask_file(cutin_mask_c01))
	mask[1].init
	mask[1].create(@cutin_mask_file)
	mask[1].x = -100
	mask[1].x_eve.set(0, 500, 0, 2)
	
	$$set_bg_object(back.object[<OBJ_APP_EFFECT01>], @bg_name)
	back.object[<OBJ_APP_EFFECT01>].x += @bg_offset_x
	back.object[<OBJ_APP_EFFECT01>].y += @bg_offset_y
	back.object[<OBJ_APP_EFFECT01>].mask_no = 1
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_CG>
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	$$set_pos_x_eve(back.object[<OBJ_APP_EFFECT01>], -100, 0, 500, 0, 2)
	@wipe(@wipe_no)

// 背景カットイン消去
#macro	@bg_cutin_del(@wipe_no(0))
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	$$set_pos_x_eve(front.object[<OBJ_APP_EFFECT01>], 0, 100, 500, 0, 2)
	mask[1].x_eve.set(100, 500, 0, 2)
	@wipe(@wipe_no)

#macro	@シネスコ逆アニメ(@time(1000), @speed_mode(0), @length(150), @red(0), @green(0), @blue(0), @tr(255), @offset_layer(0))
	$$set_child_object(back.object[<OBJ_EFFECT_CINEMA_SCOPE>], 2)
	back.object[<OBJ_EFFECT_CINEMA_SCOPE>].layer = <LAYER_SCREEN>
	back.object[<OBJ_EFFECT_CINEMA_SCOPE>].child[0].create_rect(0, 0, <SCREEN_WIDTH>, <SCREEN_CENTER_Y> + @length, @red, @green, @blue, @tr, 1)
	back.object[<OBJ_EFFECT_CINEMA_SCOPE>].child[1].create_rect(0, 0, <SCREEN_WIDTH>, <SCREEN_CENTER_Y> + @length, @red, @green, @blue, @tr, 1)
	back.object[<OBJ_EFFECT_CINEMA_SCOPE>].child[0].y = 0
	back.object[<OBJ_EFFECT_CINEMA_SCOPE>].child[0].y_eve.set(-<SCREEN_CENTER_Y>, @time, 0, @speed_mode)
	back.object[<OBJ_EFFECT_CINEMA_SCOPE>].child[1].y = <SCREEN_CENTER_Y> - @length
	back.object[<OBJ_EFFECT_CINEMA_SCOPE>].child[1].y_eve.set(<SCREEN_HEIGHT> - @length, @time, 0, @speed_mode)

// イベントＣＧ拡大
#macro	@cg_scale(@scale(1500), @time(30000), @speed_mode(0))
	$$set_scale_eve(front.object[<OBJ_CG>], front.object[<OBJ_CG>].scale_x, @scale, @time, 0, @speed_mode)

// 立ち絵顔キラキラ
#macro	@顔キラキラ(@pos_x(960), @pos_y(340), @r(220))
	$$create_face_kirakira_particle(back.object[<OBJ_APP_EFFECT01>], @pos_x, @pos_y, @r)

#command $$create_face_kirakira_particle(object, int, int, int)
