#inc_start

	// オブジェクト番号
	#replace	<OBJ_CH_TIP>			4			// キャラチップ
	#replace	<OBJ_DEBUG_BTN>			100			// デバッグボタン
	
	// ボタン番号
	#replace	<BTN_H1>				0			// ボタン(分類１)開始番号
	#replace	<BTN_H2>				100			// ボタン(分類２)開始番号
	#replace	<BTN_H3>				200			// ボタン(分類３)開始番号
	#replace	<BTN_H4>				300			// ボタン(分類４)開始番号
	
	// ボタン設定
	#replace	<BTN_BASE_X>			1782		// ボタン基本座標(x)
	#replace	<BTN_BASE_Y>			164			// ボタン基本座標(y)
	#replace	<BTN_SIZE_X>			128			// ボタンサイズ(x)
	#replace	<BTN_SIZE_Y>			64			// ボタンサイズ(y)
	#replace	<BTN_MARGIN_X>			10			// ボタン間のマージン(x)
	#replace	<BTN_MARGIN_Y>			10			// ボタン間のマージン(y)
	#replace	<BTN_SCROLL_NUM>		12			// スクロール処理が発生するボタン最大数
	
	// ボタンカラー
	#replace	<BTN_COLOR_RED>			"##F7402F"	// 赤
	#replace	<BTN_COLOR_GREEN>		"##5AA42B"	// 緑
	#replace	<BTN_COLOR_BLUE>		"##402FF7"	// 青
	#replace	<BTN_COLOR_YELLOW>		"##FFA500"	// 黄
	#replace	<BTN_COLOR_PURPLE>		"##F700F7"	// 紫
	#replace	<BTN_COLOR_ORANGE>		"##F15A22"	// 橙
	#replace	<BTN_COLOR_CYAN>		"##00FFFF"	// シアン
	
	#property	$select_btn		// 選択しているボタン
	#property	$h1_index		// 分類１で選択されたボタン
	#property	$h2_index		// 分類２で選択されたボタン
	#property	$h3_index		// 分類３で選択されたボタン
	#property	$h4_index		// 分類４で選択されたボタン
	
	#property	$effect_list : intlist
	#property	$bg_no
	#property	$chara_no
	
#inc_end

#z00

$effect_list.resize(46)
$effect_list.sets(0,
<URACE_EFFECT_RUN_SCATTER_TURF>,
<URACE_EFFECT_RUN_SCATTER_DIRT>,
<URACE_EFFECT_RUN_SCATTER_WATER>,
<URACE_EFFECT_RUN_SCATTER_ALMIGHTY>,
<URACE_EFFECT_LAST_SPURT>,
<URACE_EFFECT_LINE_TRAIL_GREEN>,
<URACE_EFFECT_LINE_TRAIL_YELLOW>,
<URACE_EFFECT_LINE_TRAIL_RAINBOW>,
<URACE_EFFECT_FIRE_TRAIL>,
<URACE_EFFECT_FIRE_TRAIL_ONESHOT>,
<URACE_EFFECT_FIRE_TRAIL_RAINBOW>,
<URACE_EFFECT_FIRE_TRAIL_RAINBOW_ONESHOT>,
<URACE_EFFECT_BLOCK>,
<URACE_EFFECT_AVOID>,
<URACE_EFFECT_CRASH_STAR_S>,
<URACE_EFFECT_CRASH_STAR_L>,
<URACE_EFFECT_SKILL_POWER_LV1>,
<URACE_EFFECT_SKILL_POWER_LV2>,
<URACE_EFFECT_SKILL_POWER_LV3>,
<URACE_EFFECT_SKILL_POWER_LV4>,
<URACE_EFFECT_ENV_BOUND_GRASS>,
<URACE_EFFECT_ENV_BOUND_LEAF>,
<URACE_EFFECT_ENV_BOUND_WATER>,
<URACE_EFFECT_ENV_DROP_WATER>,
<URACE_EFFECT_ENV_SWIRL_WATER>,
<URACE_EFFECT_ENV_DIG>,
<URACE_EFFECT_POP_DARK_BALL>,
<URACE_EFFECT_POP_HEART>,
<URACE_EFFECT_POP_FROZEN>,
<URACE_EFFECT_POP_LIGHT>,
<URACE_EFFECT_PRESSURE>,
<URACE_EFFECT_PRESSURE_TARGET>,
<URACE_EFFECT_OBSTACLE>,
<URACE_EFFECT_OBSTACLE_TARGET>,
<URACE_EFFECT_PULL_OUT>,
<URACE_EFFECT_PULL_OUT_TARGET>,
<URACE_EFFECT_WIND_SLASH>,
<URACE_EFFECT_WIND_SLASH_TARGET>,
<URACE_EFFECT_SHIRIKODAMA>,
<URACE_EFFECT_SHIRIKODAMA_TARGET>,
<URACE_EFFECT_BLOOD_STEEL>,
<URACE_EFFECT_BLOOD_STEEL_TARGET>,
<URACE_EFFECT_WIND>,
<URACE_EFFECT_WIND_REV>,
<URACE_EFFECT_SCREEN_SNOWSTORM>,
<URACE_EFFECT_SCREEN_LIGHT_GLITTER>
)
$bg_no = 1
$chara_no = 1

$$create_scene_object

$$input_start(front, <MNG_OBJBTN_GROUP_DEBUG>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <MNG_OBJBTN_GROUP_DEBUG>)
	
	// マウスホイールによるページのスクロール
	$$scroll_obj(front.object[<OBJ_DEBUG_BTN>])
	
	// 分類１ボタンが押された場合
	if( <BTN_H1> <= $select_btn && $select_btn < <BTN_H2> )
	{
		$h1_index = $select_btn - <BTN_H1>					// 選択されたボタンを保存する
		$h2_index = -1
		$h3_index = -1
		$h4_index = -1
		$$create_h2_button(front.object[<OBJ_DEBUG_BTN>])	// 分類２ボタンを作成する
	}
	
	// 分類２ボタンが押された場合は対応した分類３ボタンを表示する
	elseif( <BTN_H2> <= $select_btn && $select_btn < <BTN_H3> )
	{
		$h2_index = $select_btn - <BTN_H2>					// 選択されたボタンを保存する
		$h3_index = -1
		$h4_index = -1
		$$create_h3_button(front.object[<OBJ_DEBUG_BTN>])	// 分類３ボタンを作成する
	}
	
	// 分類３ボタンが押された場合は対応した分類４ボタンを表示する
	elseif( <BTN_H3> <= $select_btn && $select_btn < <BTN_H4> )
	{
		$h3_index = $select_btn - <BTN_H3>					// 選択されたボタンを保存する
		$h4_index = -1
	}
	
	// 何らかのボタンが押された場合
	if( $select_btn != -2 )
	{
		// 選択されたボタンの処理を実行する
		$$execute_select_button
		
		// ボタンの選択状態をリセットして入力制御を開始する
		$select_btn = -2
		$$input_start(front, <MNG_OBJBTN_GROUP_DEBUG>)
	}
	
	input.next
	disp
}

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object
{
	// 背景
	front.object[0].create(_mng_ur_race_bg + math.tostr_zero($bg_no, 2), 1, 0, 0, 1)
	front.object[1].create(_mng_ur_race_bg + math.tostr_zero($bg_no, 2), 1, 0, 0, 5)
	front.object[2].create(_mng_ur_race_bg_line, 1, 0, 252)
	front.object[3].create(sample_test, 1)
	
	// キャラ
	$$create_uma_tip_object(front.object[<OBJ_CH_TIP>], $chara_no, 960, 540)
	
	// 各分類で選択されているボタンの値を初期化する
	$h1_index = -1
	$h2_index = -1
	$h3_index = -1
	$h4_index = -1
	
	// 各分類の管理オブジェクトを作成する
	$$set_child_object(front.object[<OBJ_DEBUG_BTN>], 5)
	
	// 分類１ボタンを作成する
	$$create_h1_button(front.object[<OBJ_DEBUG_BTN>])
}

//---------------------------------------------------------------------------
// デバッグボタンを作成する
//---------------------------------------------------------------------------
command $$create_debug_button(property $obj : object, property $x, property $y, property $button_no, property $text : str, property $color : str, property $centering)
{
	$$create_mng_debug_button($obj, $x, $y, $button_no, <MNG_OBJBTN_GROUP_DEBUG>, $text, $color, $centering)
}

//---------------------------------------------------------------------------
// 分類１ボタンを作成する
//---------------------------------------------------------------------------
command $$create_h1_button(property $obj : object)
{
	property $i
	property $text : str
	property $color : str
	property $button_num
	
	$obj.child[1].init
	
	$button_num = 4
	$$set_child_object($obj.child[1], $button_num)
	
	for( $i = 0, $i < $button_num, $i += 1 )
	{
		switch( $i ) {
		case(0)		$text = "背景"			$color = <BTN_COLOR_GREEN>
		case(1)		$text = "キャラ"		$color = <BTN_COLOR_RED>
		case(2)		$text = "エフェクト"	$color = <BTN_COLOR_PURPLE>
		case(3)		$text = "トラップ"		$color = <BTN_COLOR_BLUE>
		}
		$$create_debug_button($obj.child[1].child[$i], <BTN_BASE_X>, <BTN_BASE_Y> + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H1> + $i, $text, $color, 1)
	}
}

//---------------------------------------------------------------------------
// 分類２ボタンを作成する
//---------------------------------------------------------------------------
command $$create_h2_button(property $obj : object)
{
	property $i
	property $len
	property $base_x
	property $base_y
	property $text : str
	property $color : str
	
	$obj.child[2].init
	$obj.child[2].f.resize(2)
	$obj.child[3].init
	$obj.child[4].init
	
	$base_x = <BTN_BASE_X> - (<BTN_SIZE_X> + <BTN_MARGIN_X>)
	$base_y = <BTN_BASE_Y>
	
	// 背景
	if( $h1_index == 0 )
	{
		$len = 4
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "芝"						$color = <BTN_COLOR_GREEN>
			case(1)		$text = "ダート"					$color = <BTN_COLOR_RED>
			case(2)		$text = "水面"						$color = <BTN_COLOR_BLUE>
			case(3)		$text = "ラストバトル的なところ"	$color = <BTN_COLOR_YELLOW>
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 1)
		}
	}
	
	// キャラ
	if( $h1_index == 1 )
	{
		$len = $$get_db_uma_max
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		$color = <BTN_COLOR_RED>
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = "[" + $$get_urace_rarity_star_text($$get_db_uma_rarity($i + 1)) + "]" +  $$get_db_uma_name($i + 1)
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 0)
		}
	}
	
	// エフェクト
	if( $h1_index == 2 )
	{
		$len = $effect_list.get_size + 1
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		$color = <BTN_COLOR_PURPLE>
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			if( $i == 0 )
			{
				$color = <BTN_COLOR_BLUE>
				$text = "エフェクト停止"
			}
			else
			{
				$color = <BTN_COLOR_PURPLE>
				
				switch( $effect_list[$i - 1] ) {
				case(<URACE_EFFECT_RUN_SCATTER_TURF>)			$text = "走り地形エフェクト(芝)"
				case(<URACE_EFFECT_RUN_SCATTER_DIRT>)			$text = "走り地形エフェクト(ダート)"
				case(<URACE_EFFECT_RUN_SCATTER_WATER>)			$text = "走り地形エフェクト(水)"
				case(<URACE_EFFECT_RUN_SCATTER_ALMIGHTY>)		$text = "走り地形エフェクト(すべて)"
				case(<URACE_EFFECT_LAST_SPURT>)					$text = "ラストスパート"
				case(<URACE_EFFECT_LINE_TRAIL_GREEN>)			$text = "線の軌跡(緑)"
				case(<URACE_EFFECT_LINE_TRAIL_YELLOW>)			$text = "線の軌跡(黄色)"
				case(<URACE_EFFECT_LINE_TRAIL_RAINBOW>)			$text = "線の軌跡(虹色)"
				case(<URACE_EFFECT_FIRE_TRAIL>)					$text = "火の軌跡"
				case(<URACE_EFFECT_FIRE_TRAIL_ONESHOT>)			$text = "火の軌跡(ワンショット)"
				case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW>)			$text = "火の軌跡(虹色)"
				case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW_ONESHOT>)	$text = "火の軌跡(ワンショット・虹色)"
				case(<URACE_EFFECT_BLOCK>)						$text = "ブロック"
				case(<URACE_EFFECT_AVOID>)						$text = "回避"
				case(<URACE_EFFECT_CRASH_STAR_S>)				$text = "衝突(星・小)"
				case(<URACE_EFFECT_CRASH_STAR_L>)				$text = "衝突(星・大)"
				case(<URACE_EFFECT_SKILL_POWER_LV1>)			$text = "スキル発動(コモン)"
				case(<URACE_EFFECT_SKILL_POWER_LV2>)			$text = "スキル発動(レア)"
				case(<URACE_EFFECT_SKILL_POWER_LV3>)			$text = "スキル発動(ユニーク)"
				case(<URACE_EFFECT_SKILL_POWER_LV4>)			$text = "スキル発動(アルティメット)"
				case(<URACE_EFFECT_ENV_BOUND_GRASS>)			$text = "跳ねる草"
				case(<URACE_EFFECT_ENV_BOUND_LEAF>)				$text = "跳ねる葉っぱ"
				case(<URACE_EFFECT_ENV_BOUND_WATER>)			$text = "跳ねる水"
				case(<URACE_EFFECT_ENV_DROP_WATER>)				$text = "水への着地"
				case(<URACE_EFFECT_ENV_SWIRL_WATER>)			$text = "渦巻"
				case(<URACE_EFFECT_ENV_DIG>)					$text = "穴掘り"
				case(<URACE_EFFECT_POP_DARK_BALL>)				$text = "闇の玉"
				case(<URACE_EFFECT_POP_HEART>)					$text = "ハート"
				case(<URACE_EFFECT_POP_FROZEN>)					$text = "凍結"
				case(<URACE_EFFECT_POP_LIGHT>)					$text = "御来光"
				case(<URACE_EFFECT_PRESSURE>)					$text = "プレッシャー(発動側)"
				case(<URACE_EFFECT_PRESSURE_TARGET>)			$text = "プレッシャー(受ける側)"
				case(<URACE_EFFECT_OBSTACLE>)					$text = "抑え込み(発動側)"
				case(<URACE_EFFECT_OBSTACLE_TARGET>)			$text = "抑え込み(受ける側)"
				case(<URACE_EFFECT_PULL_OUT>)					$text = "引っこ抜く(発動側)"
				case(<URACE_EFFECT_PULL_OUT_TARGET>)			$text = "引っこ抜く(受ける側)"
				case(<URACE_EFFECT_WIND_SLASH>)					$text = "風の斬撃(発動側)"
				case(<URACE_EFFECT_WIND_SLASH_TARGET>)			$text = "風の斬撃(受ける側)"
				case(<URACE_EFFECT_SHIRIKODAMA>)				$text = "尻子玉(発動側)"
				case(<URACE_EFFECT_SHIRIKODAMA_TARGET>)			$text = "尻子玉(受ける側)"
				case(<URACE_EFFECT_BLOOD_STEEL>)				$text = "吸血(発動側)"
				case(<URACE_EFFECT_BLOOD_STEEL_TARGET>)			$text = "吸血(受ける側)"
				case(<URACE_EFFECT_WIND>)						$text = "風"
				case(<URACE_EFFECT_WIND_REV>)					$text = "逆風"
				case(<URACE_EFFECT_SCREEN_SNOWSTORM>)			$text = "吹雪"
				case(<URACE_EFFECT_SCREEN_LIGHT_GLITTER>)		$text = "御来光"
				}
			}
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 0)
		}
	}
	
	// トラップ
	if( $h1_index == 3 )
	{
		$len = $$get_db_trap_max
		$$set_child_object($obj.child[2], $len)
		$obj.child[2].f[1] = $len
		
		$color = <BTN_COLOR_BLUE>
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			$text = $$get_db_trap_name($i + 1)
			$$create_debug_button($obj.child[2].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H2> + $i, $text, $color, 0)
		}
	}
}

//---------------------------------------------------------------------------
// 分類３ボタンを作成する
//---------------------------------------------------------------------------
command $$create_h3_button(property $obj : object)
{
	property $i
	property $len
	property $base_x
	property $base_y
	property $text : str
	property $color : str
	property $value
	
	$obj.child[3].init
	$obj.child[3].f.resize(2)
	$obj.child[4].init
	
	$base_x = <BTN_BASE_X> - (<BTN_SIZE_X> + <BTN_MARGIN_X>) * 2
	$base_y = <BTN_BASE_Y>
	
	// ＵＭＡを追加
	if( $h1_index == 1 && $h2_index != -1 )
	{
		$len = 4
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "待機"			$color = <BTN_COLOR_GREEN>
			case(1)		$text = "走り"			$color = <BTN_COLOR_RED>
			case(2)		$text = "ジャンプ"		$color = <BTN_COLOR_BLUE>
			case(3)		$text = "スタン"		$color = <BTN_COLOR_YELLOW>
			}
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 1)
		}
	}
	
	// トラップの状態
	if( $h1_index == 3 && $h2_index != -1 )
	{
		$len = 2
		$$set_child_object($obj.child[3], $len)
		$obj.child[3].f[1] = $len
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			switch( $i ) {
			case(0)		$text = "待機"			$color = <BTN_COLOR_BLUE>
			case(1)		$text = "ヒット"		$color = <BTN_COLOR_BLUE>
			}
			$$create_debug_button($obj.child[3].child[$i], $base_x, $base_y + (<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $i, <BTN_H3> + $i, $text, $color, 1)
		}
	}
}

//---------------------------------------------------------------------------
// 選択されたボタンの処理を実行する
//---------------------------------------------------------------------------
command $$execute_select_button
{
	// 背景
	if( $h1_index == 0 && $h2_index != -1 )
	{
		$bg_no = $h2_index + 1
		front.object[0].change_file(_mng_ur_race_bg + math.tostr_zero($bg_no, 2))
	}
	
	// キャラ
	if( $h1_index == 1 && $h2_index != -1 )
	{
		$chara_no = $h2_index + 1
		$$create_uma_tip_object(front.object[<OBJ_CH_TIP>], $chara_no, 960, 540)
	}
	
	// 動き
	if( $h1_index == 1 && $h2_index != -1 && $h3_index != -1 )
	{
		switch( $h3_index ) {
		case(0)		$$play_uma_tip_wait_anim(front.object[<OBJ_CH_TIP>])
		case(1)		$$play_uma_tip_move_anim(front.object[<OBJ_CH_TIP>])
		case(2)		$$play_uma_tip_jump_anim(front.object[<OBJ_CH_TIP>])
		case(3)		$$play_uma_tip_stun_anim(front.object[<OBJ_CH_TIP>])
		}
	}
	
	// エフェクト
	if( $h1_index == 2 && $h2_index != -1 )
	{
		if( $h2_index == 0 )
		{
			front.object[4].init
		}
		else
		{
			front.object[4].init
			$$create_urace_effect(front.object[4], $effect_list[$h2_index - 1], 960, 540, 0)
			disp
			$$play_urace_effect(front.object[4])
		}
	}
	
	// トラップ
	if( $h1_index == 3 && $h2_index != -1 )
	{
		front.object[5].init
		$$create_urace_trap(front.object[5], $h2_index + 1)
		front.object[5].set_pos(960, 540)
	}
	
	// トラップの状態
	if( $h1_index == 3 && $h2_index != -1 && $h3_index != -1 )
	{
		switch( $h3_index ) {
		case(0)		$$play_urace_trap_wait_animation(front.object[5])
		case(1)		$$play_urace_trap_hit_animation(front.object[5])
		}
	}
}

//---------------------------------------------------------------------------
// マウスホイールによるページのスクロール
//---------------------------------------------------------------------------
command $$scroll_obj(property $obj : object)
{
	property $focus_index
	property $mouse_x
	property $button_w
	
	$mouse_x = mouse.get_pos_x
	$button_w = <BTN_SIZE_X> + <BTN_MARGIN_X>
	
	// マウス座標から現在選択中の分類を判定する
	if( <BTN_BASE_X> - $button_w * 0 < mouse.get_pos_x )
	{
		$focus_index = 1
	}
	elseif( <BTN_BASE_X> - $button_w * 1 < mouse.get_pos_x && mouse.get_pos_x < <BTN_BASE_X> - $button_w * 0 )
	{
		$focus_index = 2
	}
	elseif( <BTN_BASE_X> - $button_w * 2 < mouse.get_pos_x && mouse.get_pos_x < <BTN_BASE_X> - $button_w * 1 )
	{
		$focus_index = 3
	}
	elseif( <BTN_BASE_X> - $button_w * 3 < mouse.get_pos_x && mouse.get_pos_x < <BTN_BASE_X> - $button_w * 2 )
	{
		$focus_index = 4
	}
	
	if( $focus_index == 0 || $obj.child[$focus_index].f.get_size == 0 ) {
		return
	}
	
	// スクロールが発生する個数のボタンが作成されていない場合は処理しない
	if( $obj.child[$focus_index].f[1] < <BTN_SCROLL_NUM> )
	{
		return
	}
	
	// マウスホイールによるページのスクロール
	if( mouse.wheel > 0 )
	{
		$obj.child[$focus_index].f[0] +=1
		if( $obj.child[$focus_index].f[0] > $obj.child[$focus_index].f[1] - 12 )
		{
			$obj.child[$focus_index].f[0] = $obj.child[$focus_index].f[1] - 12
		}
		
		$obj.child[$focus_index].y_eve.set(-(<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $obj.child[$focus_index].f[0], 100, 0, 0)
	}
	elseif( mouse.wheel < 0 )
	{
		$obj.child[$focus_index].f[0] -= 1
		if( $obj.child[$focus_index].f[0] < 0 )
		{
			$obj.child[$focus_index].f[0] = 0
		}
		
		$obj.child[$focus_index].y_eve.set(-(<BTN_SIZE_Y> + <BTN_MARGIN_Y>) * $obj.child[$focus_index].f[0], 100, 0, 0)
	}
}
