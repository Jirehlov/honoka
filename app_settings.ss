//===========================================================================
//!
//!    @file     app_settings.ss
//!    @brief    アプリケーションごとの設定
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#z00

//---------------------------------------------------------------------------
// デフォルトワイプデータの設定
//
// -  指定したワイプ番号に各ワイプデータを設定できます
// -  各タイトルごとによく使うワイプを登録してください
//
//---------------------------------------------------------------------------
command $$set_wipe_data_default(property $wipe_no)
{
	switch( $wipe_no ) {
	//                                $type, $time, $speed_mode, $opt0, $opt1, $opt2, $opt3, $opt4, $opt5, $opt6, $opt7
	case(99)	$$set_wipe_simple_data(   0,     0,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// 瞬間表示
	
	case(00)	$$set_wipe_simple_data(   0,   250,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：0.25秒
	case(01)	$$set_wipe_simple_data(   0,   100,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：0.1秒
	case(02)	$$set_wipe_simple_data(   0,   500,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：0.5秒
	case(03)	$$set_wipe_simple_data(   0,  1000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：1秒
	case(04)	$$set_wipe_simple_data(   0,  1500,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：1.5秒
	case(05)	$$set_wipe_simple_data(   0,  2000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：2秒
	case(06)	$$set_wipe_simple_data(   0,  2500,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：2.5秒
	case(07)	$$set_wipe_simple_data(   0,  5000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：5秒
	case(08)	$$set_wipe_simple_data(   0,  7500,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：7.5秒
	case(09)	$$set_wipe_simple_data(   0, 10000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスフェード：10秒
	
	case(11)	$$set_wipe_simple_data(  60,  1000,           0,     8,     1,     0,      0,     0,    0,     0,     0)	// 時計回りに一周(上から)：1秒
	case(12)	$$set_wipe_simple_data(  60,  1000,           0,     8,     1,     1,      0,     0,    0,     0,     0)	// 反時計回りに一周(上から)：1秒
	case(13)	$$set_wipe_simple_data(  60,  1000,           0,     8,     3,     0,      0,     0,    0,     0,     0)	// 時計回りに一周(下から)：1秒
	case(14)	$$set_wipe_simple_data(  60,  1000,           0,     8,     3,     1,      0,     0,    0,     0,     0)	// 反時計回りに一周(下から)：1秒
	
	case(20)	$$set_wipe_simple_data( 101,   500,           0,     0,     3,    20,      0,     0,    0,     0,     0)	// スライス指定方向：0.5秒右から (←)
	case(21)	$$set_wipe_simple_data( 101,  1000,           0,     0,     3,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1秒右から   (←)
	case(22)	$$set_wipe_simple_data( 101,  1500,           0,     0,     3,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1.5秒右から (←)
	case(23)	$$set_wipe_simple_data( 101,  2000,           0,     0,     3,    20,      0,     0,    0,     0,     0)	// スライス指定方向：2秒右から   (←)
	case(24)	$$set_wipe_simple_data( 101,   500,           0,     0,     2,    20,      0,     0,    0,     0,     0)	// スライス指定方向：0.5秒左から (→)
	case(25)	$$set_wipe_simple_data( 101,  1000,           0,     0,     2,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1秒左から   (→)
	case(26)	$$set_wipe_simple_data( 101,  1500,           0,     0,     2,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1.5秒左から (→)
	case(27)	$$set_wipe_simple_data( 101,  2000,           0,     0,     2,    20,      0,     0,    0,     0,     0)	// スライス指定方向：2秒左から   (→)
	
	case(30)	$$set_wipe_simple_data( 101,   500,           0,     0,     0,    20,      0,     0,    0,     0,     0)	// スライス指定方向：0.5秒上から (↓)
	case(31)	$$set_wipe_simple_data( 101,  1000,           0,     0,     0,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1秒上から   (↓)
	case(32)	$$set_wipe_simple_data( 101,  1500,           0,     0,     0,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1.5秒上から (↓)
	case(33)	$$set_wipe_simple_data( 101,  2000,           0,     0,     0,    20,      0,     0,    0,     0,     0)	// スライス指定方向：2秒上から   (↓)
	case(34)	$$set_wipe_simple_data( 101,   500,           0,     0,     1,    20,      0,     0,    0,     0,     0)	// スライス指定方向：0.5秒下から (↑)
	case(35)	$$set_wipe_simple_data( 101,  1000,           0,     0,     1,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1秒下から   (↑)
	case(36)	$$set_wipe_simple_data( 101,  1500,           0,     0,     1,    20,      0,     0,    0,     0,     0)	// スライス指定方向：1.5秒下から (↑)
	case(37)	$$set_wipe_simple_data( 101,  2000,           0,     0,     1,    20,      0,     0,    0,     0,     0)	// スライス指定方向：2秒下から   (↑)
	
	case(40)	$$set_wipe_simple_data( 120,   500,           0,     8,     0,     1,      0,     0,    0,     0,     0)	// 目を開ける：0.5秒
	case(41)	$$set_wipe_simple_data( 120,  1000,           0,     8,     0,     1,      0,     0,    0,     0,     0)	// 目を開ける：1秒
	case(42)	$$set_wipe_simple_data( 120,  1500,           0,     8,     0,     1,      0,     0,    0,     0,     0)	// 目を開ける：1.5秒
	case(43)	$$set_wipe_simple_data( 120,  2000,           0,     8,     0,     1,      0,     0,    0,     0,     0)	// 目を開ける：2秒
	case(44)	$$set_wipe_simple_data( 120,   500,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 目を閉じる：0.5秒
	case(45)	$$set_wipe_simple_data( 120,  1000,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 目を閉じる：1秒
	case(46)	$$set_wipe_simple_data( 120,  1500,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 目を閉じる：1.5秒
	case(47)	$$set_wipe_simple_data( 120,  2000,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 目を閉じる：2秒
	
	case(51)	$$set_wipe_simple_data( 110,  1000,           0,     8,     2,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒左下から
	case(52)	$$set_wipe_simple_data( 100,  1000,           0,     8,     1,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒下から   (↑)
	case(53)	$$set_wipe_simple_data( 110,  1000,           0,     8,     3,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒右下から
	case(54)	$$set_wipe_simple_data( 100,  1000,           0,     8,     2,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒左から   (→)
	case(56)	$$set_wipe_simple_data( 100,  1000,           0,     8,     3,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒右から   (←)
	case(57)	$$set_wipe_simple_data( 110,  1000,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒左上から
	case(58)	$$set_wipe_simple_data( 100,  1000,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒上から   (↓)
	case(59)	$$set_wipe_simple_data( 110,  1000,           0,     8,     1,     0,      0,     0,    0,     0,     0)	// テンキー指定方向：1秒右上から
	
	case(100)	$$set_wipe_simple_data( 120,  1000,           0,     8,     1,     1,      0,     0,    0,     0,     0)	// 扉を開ける：1秒
	case(101)	$$set_wipe_simple_data( 120,  1000,           0,     8,     1,     0,      0,     0,    0,     0,     0)	// 扉を閉じる：1秒
	case(102)	$$set_wipe_simple_data(  80,  1000,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 四角に外から内へ：1秒
	case(103)	$$set_wipe_simple_data(  80,  1000,           0,     8,     1,     0,      0,     0,    0,     0,     0)	// 四角に内から外へ：1秒
	case(104)	$$set_wipe_simple_data(  81,  1000,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 菱形に外から内へ：1秒
	case(105)	$$set_wipe_simple_data(  81,  1000,           0,     8,     1,     0,      0,     0,    0,     0,     0)	// 菱形に内から外へ：1秒
	case(106)	$$set_wipe_simple_data(  40,  1000,           0,     0,     1,     1,      0,     0,    0,     0,     0)	// ランダム小：1秒
	case(107)	$$set_wipe_simple_data(  40,  1000,           0,     0,     3,     3,      0,     0,    0,     0,     0)	// ランダム大：1秒
	case(108)	$$set_wipe_simple_data(  41,  1000,           0,     0,     1,     1,      0,     0,    0,     0,     0)	// ランダムライン(横)：1秒
	case(109)	$$set_wipe_simple_data(  41,  1000,           0,     0,     0,     1,      0,     0,    0,     0,     0)	// ランダムライン(縦)：1秒
	case(110)	$$set_wipe_simple_data(  42,  1000,           0,     0,     1,     1,      0,     0,    0,     0,     0)	// ランダムライン(左斜め)：1秒
	case(111)	$$set_wipe_simple_data(  42,  1000,           0,     0,     0,     1,      0,     0,    0,     0,     0)	// ランダムライン(右斜め)：1秒
	case(112)	$$set_wipe_simple_data(  50,  1000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// シミ（暗→明）：1秒
	case(113)	$$set_wipe_simple_data(  50,  1000,           0,     0,     1,     0,      0,     0,    0,     0,     0)	// シミ（明→暗）：1秒
	case(114)	$$set_wipe_simple_data(  83,  1000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// テレビＯＦＦ：1秒
	case(115)	$$set_wipe_simple_data(  83,  1000,           0,     0,     1,     0,      0,     0,    0,     0,     0)	// テレビＯＮ：1秒
	case(116)	$$set_wipe_simple_data( 221,  1000,           0,     1,     1,   100,     10,     0,    0,     0,     0)	// ラスタワイプ：1秒
	case(117)	$$set_wipe_simple_data( 231,  1000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// フェードインモザイク：1秒
	case(118)	$$set_wipe_simple_data( 231,  1000,           0,     0,     1,     0,      0,     0,    0,     0,     0)	// フェードアウトモザイク：1秒
	case(119)	$$set_wipe_simple_data( 230,  1000,           0,     0,     0,     0,      0,     0,    0,     0,     0)	// クロスモザイク：1秒
	case(120)	$$set_wipe_simple_data( 240,  1000,           0, <SCREEN_CENTER_X>, <SCREEN_CENTER_Y>,
				                                                                   0,      0,     5,    0,    50,     0)	// クロス爆発ブラー：1秒
	case(121)	$$set_wipe_simple_data( 241,  1000,           0, <SCREEN_CENTER_X>, <SCREEN_CENTER_Y>,
				                                                                   0,      0,    10,    0,   200,     0)	// 爆発ブラー内から外へ：1秒
	case(122)	$$set_wipe_simple_data( 241,  1000,           0, <SCREEN_CENTER_X>, <SCREEN_CENTER_Y>,
				                                                                   0,      0,    10,    0,  -200,     0)	// 爆発ブラー外から内へ：1秒
	case(123)	$$set_wipe_simple_data( 242,  1000,           0,     0,     0,    10,      1,   200,    0,     0,     0)	// クロスクェイクブラー：1秒
	
	case(202)	$$set_wipe_mask_file(__mask11)
				$$set_wipe_simple_data( 900,   300,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 素早い移動マスクワイプ(↑)：0.3秒
	case(204)	$$set_wipe_mask_file(__mask12)
				$$set_wipe_simple_data( 900,   300,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 素早い移動マスクワイプ(→)：0.3秒
	case(206)	$$set_wipe_mask_file(__mask13)
				$$set_wipe_simple_data( 900,   300,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 素早い移動マスクワイプ(←)：0.3秒
	case(208)	$$set_wipe_mask_file(__mask10)
				$$set_wipe_simple_data( 900,   300,           0,     8,     0,     0,      0,     0,    0,     0,     0)	// 素早い移動マスクワイプ(↓)：0.3秒
	
	case(300)	//$$set_wipe_mask_file(mask_test)	// （※アップデート対応※）存在しないファイルを指定していたので存在するファイルを指定するよう変更
				$$set_wipe_mask_file(__mask11)
				$$set_wipe_simple_data( 900,   1500,          0,     8,     0,     0,      0,     0,    0,     0,     0)	// システム
		
	default		$$set_wipe_simple_data(   0,     0,           0,     0,     0,     0,      0,     0,    0,     0,     0)
				@dm("app_settings.ss → $$set_wipe_data_default\n定義されていないワイプ番号が選択されました。\nワイプ番号 : " + math.tostr($wipe_no) + "\n瞬間表示を行います。")
	}
}

//---------------------------------------------------------------------------
// 画像ファイルの座標補正設定
//
// -  ゲーム画面より大きなサイズの画像を表示する場合等、デフォルトの表示位置を変更する中心座標の設定ができます
// -  .psdで#cタグなど中心座標の設定ができる場合はそちらを推奨します
// -  jpegコンバートなどで#cタグが使えない場合はこちらに登録してください
//
//---------------------------------------------------------------------------
command $$set_image_offset_data_default
{
	// CG_SP01は2048x1920なので座標を補正する
	$$set_image_offset_data(CG_SP01_0101, 128, 0)
	$$set_image_offset_data(CG_SP01_0102, 128, 0)
	$$set_image_offset_data(CG_SP01_0201, 128, 0)
	//$$set_image_offset_data(CG_SP01_0202, 128, 0)
}

//---------------------------------------------------------------------------
// 立ち絵キャラクターの登録
//
// -  @bsなど立ち絵系コマンドで指定できるキャラクターの設定ができます
//
//---------------------------------------------------------------------------
command $$set_bs_data_default
{
	// スクリプト中のキャラクター名, 読み込みファイル名, デフォルト服装番号, 補正x座標, 補正y座標, 補正レイヤー値
	$$register_bs_character("sp", "sp", 2, 0, 0, 2)		// スピカ
	$$register_bs_character("ai", "ai", 4, 0, 0, 2)		// 愛乃
	$$register_bs_character("hi", "hi", 1, 0, 0, 2)		// 陽彩
	$$register_bs_character("ky", "ky", 1, 0, 0, 2)		// 小詠
	$$register_bs_character("rk", "rk", 1, 0, 0, 2)		// 六花
	$$register_bs_character("fm", "fm", 1, 0, 0, 2)		// 文弥
	$$register_bs_character("ri", "ri", 1, 0, 0, 2)		// 塁
	$$register_bs_character("td", "td", 1, 0, 0, 2)		// つづら
	$$register_bs_character("ch", "ch", 1, 0, 0, 1)		// 千春
	$$register_bs_character("kn", "kn", 1, 0, 0, 1)		// 健
	$$register_bs_character("hr", "hr", 1, 0, 0, 2)		// 広美
	$$register_bs_character("kr", "kr", 1, 0, 0, 2)		// 玖琉未
	$$register_bs_character("mg", "mg", 1, 0, 0, 2)		// 麦
	$$register_bs_character("mn", "mn", 1, 0, 0, 1)		// 総羽湊
	$$register_bs_character("mk", "mk", 1, 0, 0, 0)		// 敦澤誠
	$$register_bs_character("tm", "tm", 1, 0, 0, 0)		// ツミレ
	$$register_bs_character("em", "em", 1, 0, 0, 2)		// 絵美
	$$register_bs_character("jt", "jt", 1, 0, 0, 2)		// ジェット
	$$register_bs_character("km", "km", 1, 0, 0, 2)		// 熊の着ぐるみ
	$$register_bs_character("hn", "hn", 1, 0, 0, 2)		// 穂乃夏
	
	$$register_bs_character("xs", "xs", 1, 0, 0, 1)		// スピカ恐竜
	$$register_bs_character("xm", "xm", 1, 0, 0, 1)		// 誠恐竜
	$$register_bs_character("xc", "xc", 1, 0, 0, 1)		// 千春恐竜
	$$register_bs_character("xk", "xk", 1, 0, 0, 1)		// 健恐竜
	$$register_bs_character("sn", "sn", 1, 0, 0, 1)		// スピカ裸枕

	
	// ↓以下、演出用の立ち絵複製
	$$register_bs_character("sq", "sp", 7, 0, 0, -1)	// スピカ２
	
	$$register_bs_character("ta", "tm", 1, 0, 0, 0)		// ツミレ（複数表示用）
	$$register_bs_character("tb", "tm", 1, 0, 0, 0)		// ツミレ（複数表示用）
	$$register_bs_character("tc", "tm", 1, 0, 0, 0)		// ツミレ（複数表示用）
	
	// ↓以下、演出用のフェイス専用立ち絵
	$$register_bs_character("br", "br", 1, 0, 0, 0)		// バロン
	$$register_bs_character("au", "au", 1, 0, 0, 0)		// 愛乃の傘
	$$register_bs_character("sf", "sf", 1, 0, 0, 1)		// スピカ裸
	$$register_bs_character("kf", "kf", 1, 0, 0, 1)		// 玖琉未首輪なし
	$$register_bs_character("hf", "hf", 1, 0, 0, 1)		// 広美シャツなし
}


//---------------------------------------------------------------------------
// 立ち絵のデフォルトx座標の設定
//
// -  @bsなど立ち絵系コマンドで自動に配置されるx座標を設定できます
// -  0と設定すれば画面の中心に表示されるようになり、-200にすると画面の中心から-200した座標に表示されます
//
//---------------------------------------------------------------------------
command $$set_bs_pos_x_default
{
	$$set_default_pos_bs1(0)						// 立ち絵が１人の時のデフォルト表示位置
	$$set_default_pos_bs2(-370, 370)				// 立ち絵が２人の時のデフォルト表示位置
	$$set_default_pos_bs3(-600, 0, 600)				// 立ち絵が３人の時のデフォルト表示位置
	$$set_default_pos_bs4(-720, -240, 240, 720)		// 立ち絵が４人の時のデフォルト表示位置
	$$set_default_pos_bs5(-750, -375, 0, 375, 750)	// 立ち絵が５人の時のデフォルト表示位置
}

//---------------------------------------------------------------------------
// 立ち絵キャラクターの顔グラ登録
//
// -  @faceなど顔グラ系コマンドで指定できるキャラクターの設定ができます
//
//---------------------------------------------------------------------------
command $$set_face_data_default
{
	// スクリプト中のキャラクター名, 拡縮率, 補正x座標, 補正y座標
	$$register_bs_face("sp", 900, 150, -630)	// スピカ
	$$register_bs_face("ai", 900, 150, -630)	// 愛乃
	$$register_bs_face("hi", 900, 150, -500)	// 陽彩
	$$register_bs_face("ky", 900, 140, -570)	// 小詠
	$$register_bs_face("rk", 900, 160, -550)	// 六花
	$$register_bs_face("fm", 900, 150, -540)	// 文弥
	$$register_bs_face("ri", 900, 150, -640)	// 塁
	$$register_bs_face("td", 900, 140, -550)	// つづら
	$$register_bs_face("ch", 900, 160, -460)	// 千春
	$$register_bs_face("kn", 900, 150, -420)	// 健
	$$register_bs_face("hr", 900, 150, -570)	// 広美
	$$register_bs_face("kr", 900, 150, -520)	// 玖琉未
	$$register_bs_face("mg", 900, 150, -430)	// 麦
	$$register_bs_face("mk", 900, 150, -530)	// 敦澤誠
	$$register_bs_face("mn", 900, 240, -480)	// 総羽湊
	$$register_bs_face("tm", 900, 140, -650)	// ツミレ
	$$register_bs_face("em", 900, 140, -550)	// 絵美
	$$register_bs_face("jt", 850, 150, -750)	// ジェット
	$$register_bs_face("km", 600, 140, -320)	// 熊の着ぐるみ
	$$register_bs_face("hn", 1000, 130, -820)	// 穂乃夏
	
	$$register_bs_face("xs", 900, 150, -630)	// スピカ恐竜
	$$register_bs_face("xm", 900, 150, -530)	// 誠恐竜
	$$register_bs_face("xc", 900, 160, -460)	// 千春恐竜
	$$register_bs_face("xk", 900, 150, -420)	// 健恐竜
	$$register_bs_face("sn", 900, 150, -630)	// スピカ裸枕
	
	// ↓以下、演出用のフェイス専用立ち絵
	$$register_bs_face("br", 800, 150, -670)	// バロン
	$$register_bs_face("au", 900, 160, -820)	// 愛乃の傘
	$$register_bs_face("sf", 900, 150, -630)	// スピカ裸
	$$register_bs_face("kf", 900, 150, -520)	// 玖琉未首輪なし
	$$register_bs_face("hf", 900, 150, -570)	// 広美シャツなし
}

//---------------------------------------------------------------------------
// アクションコマンドの登録
//
// -  システムで登録されているプリセットアクションとは別で独自のアクションコマンドを設定できます
// - [@0a]～[@0z]はシステムプリセットとして定義されていますので、それ以外の文字列で設定してください
//
//---------------------------------------------------------------------------
command $$set_action_command_default(property $obj : object, property $action : str, property $ch_index)
{
	switch( $action ) {
	case(@1a)		$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_1a")
	case(@u1_ai)	$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_u1_ai")
	case(@1p)		$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_1p")
	case(@1l)		$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_1l")
	case(@1a_td)	$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_1a_td")
	case(@1a_hi)	$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_1a_hi")
	case(@2a_hi)	$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_2a_hi")
	case(@1j)		$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_1j")
	case(@1c)		$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_1c")
	case(@d1_au)	$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_d1_au")
	case(@u1_au)	$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_u1_au")
	case(@ss_hi)	$obj.frame_action_ch[$ch_index].start(-1, "$$action_command_ss_hi")
	default		@dm("app_settings.ss → $$set_action_command_default\n定義されていないアクションコマンドが選択されました。\nアクションコマンド : " + $action + "\n処理をスキップします。")
	}
}

// サンプル "1a" ぴょんぴょんぴょんと３回飛ぶ
command $$action_command_1a(property $fa : frameaction, property $obj : object)
{
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 100, -30, 2], [100, 200, 0, 0], [200, 300, -30, 2], [300, 400, 0, 0], [400, 500, -30, 2], [500, 600, 0, 0])
}

// "@u1_ai" 愛乃用／傘で上から降ってくる
command $$action_command_u1_ai(property $fa : frameaction, property $obj : object)
{
	// 開始を０にするため１秒に初期座標を設定する
	$obj.x_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 1, 100, 0], [1, 750, 10, 2], [750, 1000, 0, 0])
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 1, -250, 0], [1, 1000, 0, 2])
}

// "@1p ふらふらと立ち上がる
command $$action_command_1p(property $fa : frameaction, property $obj : object)
{
	$obj.x_rep[<ACTION_REP_INDEX_ACTION>]  = math.timetable($fa.counter.get, 0, 0, [0, 400, 30, 2], [400, 800, 0, 1], [800, 1200, -30, 2])
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>]  = math.timetable($fa.counter.get, 0, 200, [0, 1200, 0, 0])
	$obj.tr_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 255,[0, 1, 0, 0], [0, 1000, 255 ,0])
}

// "@1l ため息
command $$action_command_1l(property $fa : frameaction, property $obj : object)
{
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 750, 15, 2], [800, 1800, 0, 2])
}

// "@1a_td" つづら_嗅ぎ
command $$action_command_1a_td(property $fa : frameaction, property $obj : object)
{
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 400, 30, 2], [500, 1000, 0, 2])
}

// "@1a_hi" ど？ど？ど？と３回
command $$action_command_1a_hi(property $fa : frameaction, property $obj : object)
{
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 100, -30, 2], [150, 200, 0, 0], [500, 600, -30, 2], [600, 750, 0, 0], [1200, 1300, -40, 2], [1300, 1450, 0, 0])
}

// "@2a_hi" とんとん
command $$action_command_2a_hi(property $fa : frameaction, property $obj : object)
{
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 200, 15, 2], [200, 400, 0, 0], [500, 700, 15, 2], [700, 900, 0, 0])
}


// "@1j" がくぶると動揺する（ループ）２
command $$action_command_1j(property $fa : frameaction, property $obj : object)
{
	L[0] = $fa.counter.get % 200
	$obj.x_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable(L[0], 0, 0, [0, 120,  1, 0], [120, 240, 1, 0], [240, 360,  0, 0], [360, 480,  0, 0], [600, 720, 0, 0], [720, 840, 0, 0])
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable(L[0], 0, 0, [0, 120, -2, 0], [120, 240, 0, 0], [240, 360,  2, 0], [360, 480, -2, 0], [600, 720, 2, 0], [720, 840, 0, 0])
}

// "1c" 横に攻撃
command $$action_command_1c(property $fa : frameaction, property $obj : object)
{
	$obj.x_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 100, 150, 2],[100,150, 0, 0])
}


// "@d1_au" 愛乃用／傘 下から中央へ表示
command $$action_command_d1_au(property $fa : frameaction, property $obj : object)
{
	// 開始を０にするため１秒に初期座標を設定する
	$obj.x_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 1, -100, 0], [1, 2250, -10, 2], [2250, 3000, 0, 0])
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 1, 250, 0], [1, 3000, 0, 2])
	$obj.tr_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 255,[0, 1, 0, 0], [0, 1000, 255, 0])
}


// "@u1_au" 愛乃用／傘 中央から上へ消える時に使うもの
command $$action_command_u1_au(property $fa : frameaction, property $obj : object)
{
	$obj.x_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 2250, 90, 0], [2250, 3000, 100, 1])
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 3000, -250, 0])
	$obj.tr_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 255, [2250, 3000, 0, 1])
}

// "@ss_hi" クマザサ
command $$action_command_ss_hi(property $fa : frameaction, property $obj : object)
{
	// 開始を０にするため１秒に初期座標を設定する
	$obj.x_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 100, 20, 2], [100, 300, 0, 1], [300, 500, -15, 2])
	$obj.y_rep[<ACTION_REP_INDEX_ACTION>] = math.timetable($fa.counter.get, 0, 0, [0, 500, 20, 2])
}

//---------------------------------------------------------------------------
// トーンカーブの登録
//
// - 指定した背景が表示されている際の立ち絵にかかるトーンカーブの設定ができます
//
//---------------------------------------------------------------------------
command $$set_bs_tonecurve(property $filename : str)
{
	property $tonecurve_no
	
	// トーンカーブの設定は「tcdata.tcr」に左右されます
	// サンプルのデータは「0=夜」「3=夕方」になっています
	switch( $filename ) {
	case(bg000_01)			$tonecurve_no = 0		// 黒背景
	case(bg001_03)			$tonecurve_no = 0		// 夜：動物病院／内観
	case(bg001_06)			$tonecurve_no = 0		// 夜：雨：動物病院／内観
	case(bg002_02)			$tonecurve_no = 3		// 夕：バーめぐり逢い
	case(bg002_06)			$tonecurve_no = 0		// 夜：バーめぐり逢い
	case(bg003_02)			$tonecurve_no = 3		// 夕：役場
	case(bg003_90)			$tonecurve_no = 1		// 曇り：役場
	case(bg003_06)			$tonecurve_no = 1		// 曇り(嵐)：役場
	case(bg004_02)			$tonecurve_no = 3		// 夕：学校校舎／廊下
	case(bg004_03)			$tonecurve_no = 0		// 夜：学校校舎／廊下
	case(bg004_07)			$tonecurve_no = 0		// 夜：学校校舎／廊下／修繕後
	case(bg004_11)			$tonecurve_no = 0		// 夜：学校校舎／廊下／修繕後
	case(bg005_03)			$tonecurve_no = 0		// 夜：学校校舎／教室
	case(bg005_07)			$tonecurve_no = 3		// 夕：学校校舎／廊下／修繕後
	case(bg005_08)			$tonecurve_no = 0		// 夜：学校校舎／教室／修繕後
	case(bg005_11)			$tonecurve_no = 0		// 夜：学校校舎／教室／修繕後
	case(bg006_02)			$tonecurve_no = 3		// 夕：学校／宿直室／ちゃぶ台無し状態／階段無し状態
	case(bg006_07)			$tonecurve_no = 0		// 夜：学校／宿直室／ちゃぶ台無し状態／階段無し状態／ライト無し
	case(bg006_09)			$tonecurve_no = 0		// 夜：学校／宿直室／ちゃぶ台無し状態／階段無し状態／布団あり／ライト無し
	case(bg006_11)			$tonecurve_no = 3		// 夕：学校／宿直室／ちゃぶ台あり状態／階段無し状態／
	case(bg006_13)			$tonecurve_no = 0		// 夜：学校／宿直室／ちゃぶ台あり状態／階段無し状態／ライト無し
	case(bg006_16)			$tonecurve_no = 3		// 夕：学校／宿直室／ちゃぶ台あり状態／階段あり状態／
	case(bg006_18)			$tonecurve_no = 0		// 夜：学校／宿直室／ちゃぶ台あり状態／階段あり状態／ライト無し
	case(bg006_20)			$tonecurve_no = 0		// 夜：学校／宿直室／ちゃぶ台無し状態／階段無し状態／麦のみ布団あり
	case(bg006_90)			$tonecurve_no = 1		// 曇り：学校／宿直室／ちゃぶ台無し状態／階段無し状態／
	case(bg006_91)			$tonecurve_no = 1		// 曇り雨：学校／宿直室／ちゃぶ台無し状態／階段無し状態／
	case(bg006_92)			$tonecurve_no = 1		// 曇り：学校／宿直室／ちゃぶ台あり状態／階段無し状態／
	case(bg006_93)			$tonecurve_no = 1		// 曇り雨：学校／宿直室／ちゃぶ台無し状態／階段無し状態／
	case(bg008_02)			$tonecurve_no = 3		// 夕：真澄町近くの草原
	case(bg008_03)			$tonecurve_no = 0		// 夜：真澄町近くの草原
	case(bg008_07)			$tonecurve_no = 0		// 夜：テント：真澄町近くの草原
	case(bg008_90)			$tonecurve_no = 1		// 雲り：真澄町近くの草原
	case(bg008_91)			$tonecurve_no = 1		// 曇り：テント：真澄町近くの草原
	case(bg009_02)			$tonecurve_no = 3		// 夕：真澄町／大通り
	case(bg009_03)			$tonecurve_no = 0		// 夜：真澄町／大通り
	case(bg009_90)			$tonecurve_no = 1		// 曇り：真澄町／大通り
	case(bg009_06)			$tonecurve_no = 0		// 夜：真澄町／大通り／松明
	case(bg009_91)			$tonecurve_no = 1		// 曇り：曇：真澄町／大通り
	case(bg010_02)			$tonecurve_no = 3		// 夕：真澄町へと続く道
	case(bg011_02)			$tonecurve_no = 3		// 夕：真澄町／住宅街
	case(bg011_03)			$tonecurve_no = 0		// 夜：真澄町／住宅街
	case(bg011_90)			$tonecurve_no = 1		// 曇り：真澄町／住宅街	
	case(bg012_02)			$tonecurve_no = 3		// 夕：真澄町／広場
	case(bg012_03)			$tonecurve_no = 0		// 夜：真澄町／広場
	case(bg012_09)			$tonecurve_no = 3		// 夕：真澄町／広場／合唱団
	case(bg012_10)			$tonecurve_no = 3		// 夕：真澄町／広場／合唱団／草無し
	case(bg014_03)			$tonecurve_no = 0		// 夜：風車下側
	case(bg015_02)			$tonecurve_no = 3		// 夕：役所／外観
	case(bg015_06)			$tonecurve_no = 1		// 曇り(嵐)：役所／外観
	case(bg015_90)			$tonecurve_no = 1		// 曇り：役場／外観
	case(bg016_02)			$tonecurve_no = 3		// 夕：学校校舎／外観／修繕前
	case(bg016_03)			$tonecurve_no = 0		// 夜：学校校舎／外観／修繕前
	case(bg016_09)			$tonecurve_no = 3		// 夕：学校校舎／外観
	case(bg016_10)			$tonecurve_no = 3		// 夕：学校校舎／外観／キャンプファイヤー
	case(bg016_11)			$tonecurve_no = 0		// 夜：学校校舎／外観
	case(bg016_12)			$tonecurve_no = 0		// 夜：学校校舎／外観／ライトあり
	case(bg016_13)			$tonecurve_no = 0		// 夜：学校校舎／外観／キャンプファイヤー
	case(bg016_14)			$tonecurve_no = 0		// 夜：学校校舎／外観／キャンプファイヤー／ライトあり
	case(bg016_15)			$tonecurve_no = 0		// 夜：学校校舎／外観／キャンプファイヤー付き
	case(bg016_16)			$tonecurve_no = 0		// 夜：学校校舎／外観／キャンプファイヤー消灯／ライトあり
	case(bg016_18)			$tonecurve_no = 0		// 夜赤：学校校舎／外観／キャンプファイヤー消灯
	case(bg016_21)			$tonecurve_no = 3		// 夕：学校校舎／外観／キャンプファイヤー消灯
	case(bg016_22)			$tonecurve_no = 0		// 夜：学校校舎／外観／
	case(bg016_24)			$tonecurve_no = 0		// 夜：学校校舎／外観／キャンプファイヤー消灯
	case(bg016_90)			$tonecurve_no = 1		// 曇り：学校校舎／外観／修繕前
	case(bg016_91)			$tonecurve_no = 1		// 曇り：学校校舎／外観
	case(bg018_02)			$tonecurve_no = 3		// 夕：麦畑
	case(bg018_03)			$tonecurve_no = 0		// 夜：麦畑
	case(bg018_08)			$tonecurve_no = 3		// 夕：麦畑／青麦
	case(bg019_02)			$tonecurve_no = 3		// 夕：山
	case(bg019_03)			$tonecurve_no = 0		// 夜：山
	case(bg019_07)			$tonecurve_no = 1		// 雨：山
	case(bg019_08)			$tonecurve_no = 0		// 夜雨：山
	case(bg020_02)			$tonecurve_no = 3		// 夕：湖畔
	case(bg020_03)			$tonecurve_no = 0		// 夜：湖畔
	case(bg020_07)			$tonecurve_no = 3		// 夕：湖畔／鳥やろうコンテスト
	case(bg020_08)			$tonecurve_no = 0		// 夜：湖畔／鳥やろうコンテスト
	case(bg020_10)			$tonecurve_no = 0		// 夜：湖畔／何も無し
	case(bg021_02)			$tonecurve_no = 3		// 夕：牧場
	case(bg021_03)			$tonecurve_no = 0		// 夜：牧場
	case(bg022_02)			$tonecurve_no = 3		// 夕：森
	case(bg022_03)			$tonecurve_no = 0		// 夜：森
	case(bg022_06)			$tonecurve_no = 0		// 夜：森／松明
	case(bg022_08)			$tonecurve_no = 3		// 夕：森／松明無し
	case(bg022_09)			$tonecurve_no = 0		// 夜：森／松明無し
	case(bg023_02)			$tonecurve_no = 3		// 夕：役所／内観
	case(bg023_03)			$tonecurve_no = 0		// 夜（ランプあり）：役所／内観
	case(bg023_06)			$tonecurve_no = 0		// 夜嵐（ランプあり）：役所／内観
	case(bg023_07)			$tonecurve_no = 0		// 夜（ランプなし）：役所／内観
	case(bg023_08)			$tonecurve_no = 0		// 夜嵐（ランプなし）：役所／内観
	case(bg101_02)			$tonecurve_no = 3		// 夕：トレーラーハウス／外観
	case(bg101_03)			$tonecurve_no = 0		// 夜：トレーラーハウス／外観
	case(bg101_90)			$tonecurve_no = 1		// 曇り：トレーラーハウス／外観
	case(bg201_02)			$tonecurve_no = 3		// 夕：愛乃工房／内観
	case(bg201_03)			$tonecurve_no = 0		// 夜：愛乃工房／内観
	case(bg201_90)			$tonecurve_no = 1		// 曇り：愛乃工房／内観
	case(bg202_02)			$tonecurve_no = 3		// 夕：愛乃工房／外観
	case(bg202_03)			$tonecurve_no = 0		// 夜：愛乃工房／外観
	case(bg202_90)			$tonecurve_no = 1		// 曇り：愛乃工房／外観
	case(bg203_06)			$tonecurve_no = 1		// 特殊：荒野
	case(bg203_90)			$tonecurve_no = 1		// 曇り：荒野
	case(bg205_02)			$tonecurve_no = 3		// 夕：ガンボウトウ(浜辺)
	case(bg205_03)			$tonecurve_no = 0		// 夜：ガンボウトウ(浜辺)
	case(bg205_06)			$tonecurve_no = 0		// 夜：ガンボウトウ(浜辺)／ランプあり
	case(bg205_07)			$tonecurve_no = 1		// 特殊：ガンボウトウ(浜辺)
	case(bg205_90)			$tonecurve_no = 1		// 曇り：ガンボウトウ(浜辺)
	case(bg205_91)			$tonecurve_no = 1		// 曇り（嵐）：ガンボウトウ(浜辺)
	case(bg209_02)			$tonecurve_no = 3		// 夕：真澄町_サクセスマート	
	case(bg301_02)			$tonecurve_no = 3		// 夕：天文台／外観
	case(bg301_03)			$tonecurve_no = 0		// 夜：天文台／外観
	case(bg302_02)			$tonecurve_no = 3		// 夕：天文台／内観
	case(bg302_03)			$tonecurve_no = 0		// 夜：天文台／内観
	case(bg302_06)			$tonecurve_no = 0		// 夜：天文台／内観／ライトあり
	case(bg303_02)			$tonecurve_no = 3		// 夕：駅廃舎
	case(bg303_03)			$tonecurve_no = 0		// 夜：駅廃舎
	case(bg303_07)			$tonecurve_no = 0		// 夜：駅廃舎／看板正
	case(bg303_08)			$tonecurve_no = 0		// 夜：駅廃舎／ライトあり
	case(bg303_09)			$tonecurve_no = 0		// 夜：駅廃舎／看板正／ライトあり
	case(bg304_02)			$tonecurve_no = 3		// 夕：駅廃舎カフェ
	case(bg304_03)			$tonecurve_no = 0		// 夜：駅廃舎カフェ
	case(bg304_08)			$tonecurve_no = 0		// 夜：駅廃舎カフェ／看板正
	case(bg305_02)			$tonecurve_no = 3		// 夕：山の中／温泉
	case(bg306_03)			$tonecurve_no = 0		// 夜：山の中／湖
	case(bg501_02)			$tonecurve_no = 3		// 夕：小鳥郵便屋／外観
	case(bg501_03)			$tonecurve_no = 0		// 夜：小鳥郵便屋／外観
	case(bg501_90)			$tonecurve_no = 1		// 曇り：小鳥郵便屋／外観
	case(bg502_02)			$tonecurve_no = 3		// 夕：小鳥郵便屋／内観
	case(bg502_03)			$tonecurve_no = 0		// 夜：小鳥郵便屋／内観
	case(bg502_90)			$tonecurve_no = 1		// 曇り：小鳥郵便屋／内観
	case(bg504_01)			$tonecurve_no = 0		// 夜：雨
	case(bg507_02)			$tonecurve_no = 3		// 夕：旅の道中（下道）
	case(bg508_90)			$tonecurve_no = 1		// 曇り：復興の町／慰霊館
	case(bg509_90)			$tonecurve_no = 1		// 曇り：復興の町／町中
	case(bg510_90)			$tonecurve_no = 1		// 曇り：復興の町／高台
	case(bg518_90)			$tonecurve_no = 1		// 曇り：空（森から見た空）
	case(bg601_02)			$tonecurve_no = 3		// 夕：放送室
	case(bg601_03)			$tonecurve_no = 0		// 夜：放送室
	case(bg601_07)			$tonecurve_no = 0		// 夜：放送室／ライト無し
	case(bg702_02)			$tonecurve_no = 3		// 夕：ログハウス外観／新地
	case(bg702_03)			$tonecurve_no = 0		// 夜：ログハウス外観／新地
	case(bg702_07)			$tonecurve_no = 3		// 夕：ログハウス外観／建築途中（初期）
	case(bg702_08)			$tonecurve_no = 0		// 夜：ログハウス外観／建築途中（初期）
	case(bg702_10)			$tonecurve_no = 3		// 夕：ログハウス外観／建築途中（中期）
	case(bg702_11)			$tonecurve_no = 0		// 夜：ログハウス外観／建築途中（初期）
	case(bg702_13)			$tonecurve_no = 3		// 夕：ログハウス外観／建築途中（完成）
	case(bg702_14)			$tonecurve_no = 0		// 夜：ログハウス外観／建築途中（完成）
	case(bg702_17)			$tonecurve_no = 3		// 夕：ログハウス外観／建築途中（完成）／風車無し
	case(bg702_18)			$tonecurve_no = 0		// 夜：ログハウス外観／建築途中（完成）／風車無し
	case(bg702_20)			$tonecurve_no = 3		// 夕：ログハウス外観／建築途中（完成）／ベンチ無し
	case(bg702_21)			$tonecurve_no = 0		// 夜：ログハウス外観／建築途中（完成）／ベンチ無し
	case(bg702_80)			$tonecurve_no = 0		// 朝方夜：ログハウス外観／建築途中（完成）／ベンチ無し
	case(bg702_26)			$tonecurve_no = 3		// 夕：ログハウス外観／建築途中（完成）／ベンチあり／釜無し
	case(bg702_27)			$tonecurve_no = 0		// 夜：ログハウス外観／建築途中（完成）／ベンチあり／釜無し
	case(bg702_81)			$tonecurve_no = 0		// 朝方夜：ログハウス外観／建築途中（完成）／ベンチ無し
	case(bg019_25)			$tonecurve_no = 1		// ：山
	case(bg703_02)			$tonecurve_no = 3		// 夕：ログハウス／リビング
	case(bg703_07)			$tonecurve_no = 3		// 夕：ログハウス／リビング／家具なし
	case(bg703_09)			$tonecurve_no = 0		// 夜：ログハウス／リビング／家具あり／ライト無し
	case(bg703_10)			$tonecurve_no = 0		// 夜：ログハウス／リビング／家具無し／ライト無し
	case(bg704_02)			$tonecurve_no = 3		// 夕：ログハウス／麦の寝室
	case(bg704_06)			$tonecurve_no = 0		// 夜：ログハウス／麦の寝室／ライト無し
	case(bg705_02)			$tonecurve_no = 3		// 夕：動物病院／寝室
	case(bg708_02)			$tonecurve_no = 3		// 夕：ログハウス／スピカ寝室
	case(bg708_03)			$tonecurve_no = 0		// 夜：ログハウス／スピカ寝室
	case(bg708_06)			$tonecurve_no = 0		// 夜：ログハウス／スピカ寝室／ライト無し
	case(bg708_08)			$tonecurve_no = 3		// 夕：ログハウス／スピカ寝室／yes枕
	case(bg708_09)			$tonecurve_no = 0		// 夜：ログハウス／スピカ寝室／yes枕_ライトあり
	case(bg708_11)			$tonecurve_no = 3		// 夕：ログハウス／スピカ寝室／go枕
	case(bg708_12)			$tonecurve_no = 0		// 夜：ログハウス／スピカ寝室／go枕_ライトあり
	case(bg801_03)			$tonecurve_no = 0		// 夜：秘密基地
	case(bg999_02)			$tonecurve_no = 3		// 夕：空
	case(bg999_03)			$tonecurve_no = 0		// 夜：空
	case(bg999_08)			$tonecurve_no = 0		// 夜：空
	case(bg999_09)			$tonecurve_no = 0		// 夜：空
	case(bg999_10)			$tonecurve_no = 1		// 嵐：空
	case(bg999_11)			$tonecurve_no = 1		// 落雷：空
	case(bg999_90)			$tonecurve_no = 1		// 曇り：空
	case(bg999_91)			$tonecurve_no = 0		// 赤夜：空
	case(ef_bg02)			$tonecurve_no = 0		// 夜：空
	default					$tonecurve_no = -1		// それ以外はトーンカーブをかけない
	}
	
	return ($tonecurve_no)
}

//---------------------------------------------------------------------------
// シーンの初期化（アプリケーション側）
//
// - @シーン開始（$$init_scene）時に実行する独自コマンドの設定ができます
//
//---------------------------------------------------------------------------
command $$init_scene_default(property $init_flag)
{
	@麦視点
}
