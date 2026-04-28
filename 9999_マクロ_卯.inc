//--------------------------------------------------------------------
// 榊原マクロ作成用
//--------------------------------------------------------------------



//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
// 汎用のもの
//■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■

//ワイプ指定秒数とウェイト秒数を別にしたい時用
#macro	@時間経過２(@wipe_no(3), @wipe_time(-1), @wait_time(1000), @se_fade_time(2000))
	@se_stop_all(@se_fade_time)
	@fade(@wipe_no, @wipe_time)
	@waitkey(@wait_time)

#macro	@その場で時間経過２(@fade_wipe_no(3), @wipe_time(-1), @wait_time(1000), @disp_wipe_no(3))
	K[0] = front.object[<OBJ_BG>].get_file_name
	@fade(@fade_wipe_no, @wipe_time)
	@waitkey(@wait_time)
	@bg(K[0], @disp_wipe_no)




//--------------------------------------------------------------------
//仮作成：愛乃成長が語り掛けてきている時用
// 豪センタリングから一旦ノイズを抜いたもの
//--------------------------------------------------------------------
#macro	@愛乃成長_センタリング開始
	@fade_w
	@bg(bg_siro, 2)
	@テキストセンタリング開始
	color(1)


#macro	@愛乃成長_センタリング終了
	color
	@テキストセンタリング終了
	@fade_w



//--------------------------------------------------------------------
//仮作成：愛乃成長が語り掛けてきている時用 @カレイドワールド
//--------------------------------------------------------------------
#macro	@愛乃成長_カレイド_センタリング開始(@wipe_no(3))
	@テキストセンタリング開始
	@黒フィルター全体(144)
	@wipe(@wipe_no)


#macro	@愛乃成長_カレイド_センタリング終了(@wipe_no(3))
	@フィルター終了
	@テキストセンタリング終了
	@wipe(@wipe_no)


//--------------------------------------------------------------------
//仮作成：カレイドワールド用
//--------------------------------------------------------------------

#macro	@カレイドワールド(@type)			$$ef_kaleido(@type)

#command $$ef_kaleido(int)

// →1、2合わせたものを希望する場合は「@風の回廊_浅層」を使用する



#macro	@カレイドワールド終了(@wipe_no(3))
	front.object[90].wipe_copy = 0
	@wipe(@wipe_no)


//--------------------------------------------------------------------
//仮作成：豪が語り掛けてきている時用
//--------------------------------------------------------------------
#macro	@豪_センタリング開始
	@fade_w
	@フィルムノイズ
	@bg(bg_siro, 2)
	@テキストセンタリング開始
	color(1)


#macro	@豪_センタリング終了
	color
	@テキストセンタリング終了
	@フィルムノイズ終了
	@fade_w



//--------------------------------------------------------------------
// 仮作成：豪とリンクする時用 ※要ワイプ
//--------------------------------------------------------------------

#macro	@豪_夢演出小
	back.object[80].create_movie(ef_light_dust1, 0, 0, 0, ready_only = 1)
	back.object[80].layer = <LAYER_SCREEN>
	back.object[80].blend = 1
	back.object[80].disp = 1
	back.object[80].resume_movie


#macro	@豪_夢演出大
	back.object[80].create_movie(ef_light_dust2, 0, 0, 0, ready_only = 1)
	back.object[80].layer = <LAYER_SCREEN>
	back.object[80].blend = 1
	back.object[80].disp = 1
	back.object[80].resume_movie



//--------------------------------------------------------------------
// 仮作成：赤オーロラ関連
//--------------------------------------------------------------------

#macro	@赤オーロラ(@bg_name(ef_bg05), @wipe_no(__DEFAULT_BG_WIPE_NO), @close(__DEFAULT_BG_MSG_CLOSE), @type(0), @wipe_copy(0), @tr(64))
	if( @close ) { close }
	@黒フィルター(@tr)
	@赤オーロラ準備(@bg_name, @type, @wipe_copy)
	@赤オーロラ再生
	@wipe(@wipe_no)

#macro	@赤オーロラ消去
	@フィルター終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0

#macro	@赤オーロラ準備(@bg_name(ef_bg05), @type(0), @wipe_copy(1))
	@bg_set(@bg_name)
	if( @type == 0 ) { back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_red_aurora_slow, 1, ready_only = 1) }
	else			 { back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_red_aurora_fast, 1, ready_only = 1) }
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	if( @wipe_copy ) { back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1 }
	disp

#macro	@赤オーロラ再生
	back.object[<OBJ_APP_EFFECT01>].resume_movie



//--------------------------------------------------------------------
// 仮作成：ダウンバースト関連一部
//--------------------------------------------------------------------

#macro	@ダウンバースト_葉(@wipe_no(3), @wipe_time(-1))
	back.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_downburst_lief, 1)
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_BG> + 1
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	@wipe(@wipe_no,  @wipe_time)


#macro	@ダウンバースト_空(@wipe_no(3), @wipe_time(-1))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_downburst_sky, 1)
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG>
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT01>])
	@wipe(@wipe_no,  @wipe_time)



//--------------------------------------------------------------------
// 災獣_鯨バージョン違い
//--------------------------------------------------------------------
#macro	@災獣_鯨波(@wipe_no(3))
	@災獣_表示(ef_dark_monster03b, @wipe_no)


//↑ループ
//↓ワンショット
#macro	@災獣_鯨波ワンショット(@wipe_no(3))
back.object[<OBJ_APP_EFFECT02>].create_movie(ef_dark_monster03b, 1)
	// 960x480
	back.object[<OBJ_APP_EFFECT02>].set_scale(2000, 2000)
	back.object[<OBJ_APP_EFFECT02>].set_center_rep(960 / 2, 540 / 2)
	back.object[<OBJ_APP_EFFECT02>].set_pos(960 / 2, 540 / 2)
	back.object[<OBJ_APP_EFFECT02>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT02>].layer = <LAYER_CHARACTER> + 1
	$$set_image_center_rep(back.object[<OBJ_APP_EFFECT02>])
	@wipe(@wipe_no)


//--------------------------------------------------------------------
// 仮作成：10年日記演出関連
//--------------------------------------------------------------------

#macro	@日記演出開始
	@cinema

#macro	@日記(@filename, @wipe_no(3), @name(""), @msg(""), @koe_no(-1), @chara_no(-1), @pos_x(0), @pos_y(0), @savepoint(1))
	// メッセージが設定されている／セーブポイントフラグがオンの場合はセーブポイントを設定する
	if( @msg != "" && @savepoint ) {
		savepoint
	}
	// 声の再生
	if( @koe_no != -1 ) {
		exkoe(@koe_no, @chara_no)
	}
	// 画像の読み込み
	back.object[<OBJ_IMAGE_TEXT>].create(@filename, 1, @pos_x, @pos_y, 0)
	back.object[<OBJ_IMAGE_TEXT>].layer = <LAYER_SCREEN>
	// メッセージバックに追加する
	$$add_msgback(@koe_no, @chara_no, @name, @msg)
	@wipe(@wipe_no)


#macro	@日記演出終了
	@cinema_end
	//front.object[<OBJ_IMAGE_TEXT>].wipe_copy = 0


//--------------------------------------------------------------------
// 仮作成：愛乃_霧
//--------------------------------------------------------------------

#macro	@愛乃_霧(@tr(96), @blend(4))
	$$set_fogA_object(back.object[<OBJ_APP_EFFECT01>], back.object[<OBJ_APP_EFFECT02>])
	back.object[<OBJ_APP_EFFECT01>].tr = @tr
	back.object[<OBJ_APP_EFFECT02>].tr = @tr
	back.object[<OBJ_APP_EFFECT01>].blend = @blend
	back.object[<OBJ_APP_EFFECT02>].blend = @blend
	back.object[<OBJ_APP_EFFECT01>].layer = 1100
	back.object[<OBJ_APP_EFFECT02>].layer = 1101


#macro	@愛乃_霧終了
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0
	front.object[<OBJ_APP_EFFECT02>].wipe_copy = 0



//--------------------------------------------------------------------
// 仮作成：にいさんらっしゅ
//--------------------------------------------------------------------

//いったん気持ち
#macro	 @兄さんラッシュ(@pos_x, @pos_y, @koe_no, @end_scale)
	$$create_nisan_rush(@pos_x, @pos_y, @koe_no, @end_scale)

#command $$create_nisan_rush(int, int, int, int)


//--------------------------------------------------------------------
// 仮作成：シルバー編画像文字
//--------------------------------------------------------------------

#macro	@シルバー画像文字(@patno, @text, @koe_no(-1), @chara_no(-1), @wait_time(1500))
	@シルバー画像文字表示(@patno, @text,				// 表示
						@koe_no, @chara_no)
	@アバン画像文字消去(@wait_time)					// 消去


#macro	@シルバー画像文字_麦(@patno, @text, @koe_no(-1), @chara_no(-1), @wait_time(1500))
	@シルバー画像文字表示_麦(@patno, @text,				// 表示
						@koe_no, @chara_no)
	@アバン画像文字消去(@wait_time)					// 消去



// 個別制御版／表示
#macro	@シルバー画像文字表示(@patno, @text, @koe_no(-1), @chara_no(-1))
	@画像文字_声再生なし(ef_silver_text, @patno, "",	// 画像文字作成
						@text, @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン
	@wipe_nowait(54, 2500)							// 表示
	@waitkey(500)									// 待ち時間
	exkoe(@koe_no, @chara_no)						// 声の再生
	@waitkey(1250)									// 待ち時間



// 個別制御版／表示
#macro	@シルバー画像文字表示_麦(@patno, @text, @koe_no(-1), @chara_no(-1))
	@画像文字_声再生なし(ef_silver_text, @patno, "",	// 画像文字作成
						@text, @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン
	@bg_set(bg_siro)
	@wipe_nowait(54, 2500)							// 表示
	@waitkey(500)									// 待ち時間
	exkoe(@koe_no, @chara_no)						// 声の再生
	@waitkey(1250)									// 待ち時間


//--------------------------------------------------------------------
// 六花手紙の画像文字
//--------------------------------------------------------------------

#macro	@六花手紙_画像文字(@patno, @text, @koe_no(-1), @chara_no(-1), @wait_time(1500))
	@六花手紙_画像文字表示(@patno, @text,				// 表示
						@koe_no, @chara_no)
	@アバン画像文字消去(@wait_time)					// 消去

#macro	@六花手紙_画像文字表示(@patno, @text, @koe_no(-1), @chara_no(-1))
	@画像文字_声再生なし(ef_rk_text_letter, @patno, "",	// 画像文字作成
						@text, @koe_no, @chara_no)
	back.object[<OBJ_IMAGE_TEXT>].wipe_copy = 1		// ワイプコピーオン
	@wipe_nowait(54, 2500)							// 表示
	@waitkey(500)									// 待ち時間
	exkoe(@koe_no, @chara_no)						// 声の再生
	@waitkey(1250)									// 待ち時間



//--------------------------------------------------------------------
// くまざさ
//--------------------------------------------------------------------

#macro	@淡雪クマザサ(@wipe_no(2), @se_play(1), @bg_name(<NONE>))
	close
	if( @se_play ) {
		@se(SE_kumazasa)
	}
	if( @bg_name != <NONE> ) {
		@bg_set(__BG_BLUR_PREFIX + $$chop_bg_blur_name(@bg_name))
	} else {
		@bg_set(__BG_BLUR_PREFIX + $$chop_bg_blur_name(front.object[<OBJ_BG>].get_file_name))
	}
	@cutin(ef_cutin_kumazasa@ss_hi, -1, -1, 1, 0, -50)
	@wipe(@wipe_no)


