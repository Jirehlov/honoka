//===========================================================================
//!
//!    @file     ___mng_utils.ss
//!    @brief    ミニゲーム汎用関数群
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

	// 時間管理
	#property	$now_time		// 現在のフレーム時間
	#property	$old_time		// １フレーム前の時間
	#property	$delta_time		// 直前のフレームから経過した時間
	
	// 乱数生成用シード値(Xorshift)
	#property	$seed_x
	#property	$seed_y
	#property	$seed_z
	#property	$seed_w
	
	// デバッグボタン設定
	#replace	<DEBUG_BTN_FONT_SIZE>		20			// ボタン文字サイズ
	#replace	<DEBUG_BTN_FONT_MAX>		36			// ボタンの最大文字数(半角=1、全角=2)
	#replace	<DEBUG_BTN_SIZE_X>			128			// ボタンサイズ(x)
	#replace	<DEBUG_BTN_SIZE_Y>			64			// ボタンサイズ(y)
	#replace	<DEBUG_BTN_FONT_MARGIN_X>	3			// ボタン文字マージン(x)
	#replace	<DEBUG_BTN_FONT_MARGIN_Y>	2			// ボタン文字マージン(y)
	
#inc_end

#z00

//---------------------------------------------------------------------------
// ミニゲームで使用するカウンターを初期化する
//---------------------------------------------------------------------------
command $$init_mng_counter
{
	@mng_counter.start
	$old_time = 0
	$now_time = @mng_counter.get
	$delta_time = 0
}

//---------------------------------------------------------------------------
// ミニゲームで使用するカウンターを更新する
//---------------------------------------------------------------------------
command $$update_mng_counter
{
	$old_time = $now_time
	$now_time = @mng_counter.get
	$delta_time = $now_time - $old_time
}

//---------------------------------------------------------------------------
// ミニゲームで使用するカウンターを終了する
//---------------------------------------------------------------------------
command $$end_mng_counter
{
	@mng_counter.stop
}

//---------------------------------------------------------------------------
// 直前のフレームから経過した時間を取得する
//---------------------------------------------------------------------------
command $$get_delta_time : int
{
	return ($delta_time)
}

//---------------------------------------------------------------------------
// ミニゲームで使用するランダムのシード値を初期化する(Xorshift)
//---------------------------------------------------------------------------
command $$mng_rand_init(property $time)
{
	$seed_x = 123456789 + $time
	$seed_y = 362436069 + $time
	$seed_z = 521288629 + $time
	$seed_w = 88675123 + $time
	
	if( $seed_x == 0 && $seed_y == 0 && $seed_z == 0 && $seed_w == 0 )
	{
		$seed_x = 123456789
		$seed_y = 362436069
		$seed_z = 521288629
		$seed_w = 88675123
		
		$$debug_message("$$mng_rand_initエラー→デフォルトのシード値を使用します")
	}
}

//---------------------------------------------------------------------------
// ミニゲームで使用するランダム関数(Xorshift)
//---------------------------------------------------------------------------
command $$mng_rand(property $min, property $max) : int
{
	property $t
	property $s
	
	$t = $seed_x ^ ($seed_x << 11)
	$seed_x = $seed_y
	$seed_y = $seed_z
	$seed_z = $seed_w
	$seed_w = ($seed_w ^ ($seed_w >> 19) ^ ($t ^ ($t >> 8)))
	
	$s = $max - $min
	
	if( $s == 0 )
	{
		return ($min)
	}
	elseif( $s > 0 )
	{
		return (($seed_w % ($max - $min + 1)) + $min)
	}
	
	$$debug_message("$$mng_randエラー→$minより$maxの値が小さいため$minの数値を返します。\n$min:" + math.tostr($min) + " $max:" + math.tostr($max))
	
	return ($min)
}

//---------------------------------------------------------------------------
// ミニゲームで使用するデバッグボタンを作成する(デバッグページ中)
//---------------------------------------------------------------------------
command $$create_mng_debug_button(property $obj : object, property $x, property $y, property $button_no, property $button_group, property $text : str, property $color : str, property $centering)
{
	property $i
	property $len
	
	// ベースオブジェクトの設定
	$obj.init
	$$set_child_object($obj, 2)
	$obj.set_pos($x, $y)
	$obj.wipe_copy = 1
	
	// 文字数が最大を超えている場合は文字を丸める
	if( $text.len > <DEBUG_BTN_FONT_MAX> )
	{
		$text = $text.left_len(<DEBUG_BTN_FONT_MAX> - 2)
		$text += "…"
	}
	
	// 文字を中央寄せにする
	if( $centering )
	{
		$len = (<DEBUG_BTN_FONT_MAX> - $text.len) / 2
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = " " + $text + " "
		}
	}
	
	// 下地
	$obj.child[0].create_rect(0, 0, <DEBUG_BTN_SIZE_X>, <DEBUG_BTN_SIZE_Y>, $$color_code_to_r($color), $$color_code_to_g($color), $$color_code_to_b($color), 160, 1)
	$obj.child[0].set_button($button_no, $button_group, <MNG_BTN_ACTION_DEBUG>, <MNG_BTN_SE_DEBUG>)
	
	// 文字
	$obj.child[1].create_string($text, 1, <DEBUG_BTN_FONT_MARGIN_X>, <DEBUG_BTN_FONT_MARGIN_Y>)
	$obj.child[1].set_string_param(<DEBUG_BTN_FONT_SIZE>, 0, 0, 6, 0, 0, 2, 1)
}
