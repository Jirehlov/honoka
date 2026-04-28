//===========================================================================
//!
//!    @file     ___mng_hhp_effect.ss
//!    @brief    ヘビヘビパニックエフェクト管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	#property	$current_spawn_index	// エフェクト生成に使用するオブジェクトインデックス
	
	// ダメージ数字
	#replace	<DAMAGE_IMAGE_W>			43		// ダメージ数字の横サイズ
	#replace	<DAMAGE_IMAGE_H>			63		// ダメージ数字の縦サイズ
	#replace	<DAMAGE_DIGIT_W>			-6		// ダメージ数字の桁と桁の補正距離
	#define		<DAMAGE_DIGIT_OFFSET_X>		(<DAMAGE_IMAGE_W> + <DAMAGE_DIGIT_W>)	// ダメージ数字の桁と桁の実距離
	#define		<DAMAGE_DIGIT1_OFFSET_X>	(<DAMAGE_DIGIT_OFFSET_X> * 3 + <DAMAGE_DIGIT_OFFSET_X> / 2 * 0 + <DAMAGE_IMAGE_W> / 2)		// １桁のオフセットx座標
	#define		<DAMAGE_DIGIT2_OFFSET_X>	(<DAMAGE_DIGIT_OFFSET_X> * 2 + <DAMAGE_DIGIT_OFFSET_X> / 2 * 1 + <DAMAGE_IMAGE_W> / 2)		// ２桁のオフセットx座標
	#define		<DAMAGE_DIGIT3_OFFSET_X>	(<DAMAGE_DIGIT_OFFSET_X> * 1 + <DAMAGE_DIGIT_OFFSET_X> / 2 * 2 + <DAMAGE_IMAGE_W> / 2)		// ３桁のオフセットx座標
	#define		<DAMAGE_DIGIT4_OFFSET_X>	(<DAMAGE_DIGIT_OFFSET_X> * 0 + <DAMAGE_DIGIT_OFFSET_X> / 2 * 3 + <DAMAGE_IMAGE_W> / 2)		// ４桁のオフセットx座標
	
#inc_end

#z00

//---------------------------------------------------------------------------
// エフェクトを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_effect
{
	property $i
	
	// 各オブジェクトを初期化する
	for( $i = <HHP_OBJ_EFFECT_START>, $i <= <HHP_OBJ_EFFECT_END>, $i += 1 )
	{
		front.object[$i].init
	}
	
	// エフェクト管理変数を初期化する
	$current_spawn_index = <HHP_OBJ_EFFECT_BUF_START>
}

//---------------------------------------------------------------------------
// エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_hhp_effect(property $effect_type, property $x, property $y, property $value)
{
	// 固定エフェクト
	if( $effect_type == <HHP_EF_PLAYER_ATTACK> ) {
		$$spawn_player_attack_effect(front.object[<HHP_OBJ_EFFECT_PLAYER_ATTACK>], $x, $y)
	}
	
	// ループバッファ使用エフェクト
	else
	{
		// エフェクトに使用するオブジェクトを初期化する
		front.object[$current_spawn_index].init
		
		// 各エフェクトを生成する
		switch( $effect_type) {
		case(<HHP_EF_ENEMY_HIT>)			$$spawn_enemy_hit_effect(front.object[$current_spawn_index], $x, $y, $value)
		case(<HHP_EF_ENEMY_ATTACK>)			$$spawn_enemy_attack_effect(front.object[$current_spawn_index], $x, $y)
		case(<HHP_EF_BOSS_ATTACK>)			$$spawn_boss_attack_effect(front.object[$current_spawn_index], $x, $y)
		case(<HHP_EF_BOSS_LANDING>)			$$spawn_boss_landing_effect(front.object[$current_spawn_index], $x, $y)
		case(<HHP_EF_DAMAGE>)				$$spawn_damage_number(front.object[$current_spawn_index], $x, $y, $value)
		case(<HHP_EF_CRITICAL_DAMAGE>)		$$spawn_critical_damage_number(front.object[$current_spawn_index], $x, $y, $value)
		case(<HHP_EF_SLASH_H>)				$$spawn_slash_h_effect(front.object[$current_spawn_index], $x, $y)
		case(<HHP_EF_SLASH_V>)				$$spawn_slash_v_effect(front.object[$current_spawn_index], $x, $y)
			
			
			
		case(<HHP_EF_ENEMY_SHIELD_BREAK>)	$$spawn_enemy_shield_break(front.object[$current_spawn_index], $x, $y)
		case(<HHP_EF_TREASURE>)				$$spawn_treasure(front.object[$current_spawn_index], $x, $y)
			
		// deb
		case(99)		$$test_efect(front.object[$current_spawn_index], $effect_type, $x, $y)
		}
		
		// 次に使用するオブジェクトインデックスを設定する
		$current_spawn_index += 1
		if( <HHP_OBJ_EFFECT_BUF_END> < $current_spawn_index ) {
			$current_spawn_index = <HHP_OBJ_EFFECT_BUF_START>
		}
	}
}

//---------------------------------------------------------------------------
// アニメーション制御フレームアクション
//---------------------------------------------------------------------------
command $$fa_effect_anim(property $fa : frameaction, property $obj : object, property $patno_max, property $end_time, property $delay_time)
{
	$obj.patno = math.linear($fa.counter.get, $delay_time, 0, $delay_time + $end_time, $patno_max)
	
	// 終了時間を超えた場合はフレームアクションを終了する
	if( $fa.counter.get > $delay_time + $end_time )
	{
		$obj.disp = 0
		$obj.frame_action.end
	}
}

//---------------------------------------------------------------------------
// プレイヤーの攻撃／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_player_attack_effect(property $obj : object, property $x, property $y)
{
	// エフェクトデータが読み込まれてない場合はファイルを読み込む
	if( $obj.exist_type == 0 )
	{
		$obj.create("__mng_hp_ef_player_attack", 1)
		$obj.center_y = $obj.get_size_y
		$obj.layer = <HHP_LAYER_EFFECT> + 1
		$obj.add_hints(no_event = 0)
		
		// 枝の先がマウスカーソルの先端になるように座標を補正する
		$obj.x_rep.resize(1)
		$obj.y_rep.resize(1)
		$obj.x_rep[0] = -40
		$obj.y_rep[0] = 90
	}
	else
	{
		$obj.disp = 1
	}
	
	$obj.set_pos($x, $y)
	$obj.frame_action.start(-1, "$$fa_effect_anim", 7, 20 * 7, 0)
}

//---------------------------------------------------------------------------
// 敵ヒット／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_enemy_hit_effect(property $obj : object, property $x, property $y, property $delay_time)
{
	$obj.create("__mng_hp_ef_enemy_hit", 1, $x, $y - 80)
	$$set_image_center($obj)
	$obj.layer = <HHP_LAYER_EFFECT>
	
	$obj.frame_action.start(-1, "$$fa_effect_anim", 5, 30 * 5, $delay_time)
}

//---------------------------------------------------------------------------
// 敵攻撃／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_enemy_attack_effect(property $obj : object, property $x, property $y)
{
	$obj.create("__mng_hp_ef_enemy_attack", 1, $x, $y - 80)
	$$set_image_center($obj)
	$obj.layer = <HHP_LAYER_EFFECT>
	$obj.bright = 255
	$obj.bright_eve.set(0, 150, 0, 2)
	
	$obj.frame_action.start(-1, "$$fa_effect_anim", 4, 30 * 4, 0)
}

//---------------------------------------------------------------------------
// ボス攻撃／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_boss_attack_effect(property $obj : object, property $x, property $y)
{
	$obj.create("__mng_hp_ef_boss_attack", 1, $x, $y - 80)
	$$set_image_center($obj)
	$obj.layer = <HHP_LAYER_EFFECT>
	
	$obj.frame_action.start(-1, "$$fa_effect_anim", 28, 30 * 28, 0)
}

//---------------------------------------------------------------------------
// ボス着地／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_boss_landing_effect(property $obj : object, property $x, property $y)
{
	$obj.create("__mng_hp_ef_boss_attack", 1, $x, $y)
	$$set_image_center($obj)
	$obj.set_scale(5000, 5000)
	$obj.dark = 96
	$obj.layer = <HHP_LAYER_BOSS> + 1
	
	$obj.frame_action.start(-1, "$$fa_effect_anim", 28, 40 * 28, 0)
}

//---------------------------------------------------------------------------
// ダメージ数字／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_damage_number(property $obj : object, property $x, property $y, property $damage)
{
	$obj.create_number("__mng_hp_damage_number", 1, $x, $y - <DAMAGE_IMAGE_H> / 2)
	$obj.layer = <HHP_LAYER_EFFECT>
	$obj.set_number_param(4, 0, 0, 0, 0, <DAMAGE_DIGIT_W>)
	$obj.set_number($damage)
	$obj.y_rep.resize(1)
	
	// ダメージの桁数によってx座標を補正する
		if( $damage < 10 )		{ $obj.x -= <DAMAGE_DIGIT1_OFFSET_X> }
	elseif( $damage < 100 )		{ $obj.x -= <DAMAGE_DIGIT2_OFFSET_X> }
	elseif( $damage < 1000 )	{ $obj.x -= <DAMAGE_DIGIT3_OFFSET_X> }
	else						{ $obj.x -= <DAMAGE_DIGIT4_OFFSET_X> }
	
	$obj.frame_action.start(-1, "$$fa_damage_number")
}

// ダメージ数字フレームアクション
command $$fa_damage_number(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.y_rep[0] = math.timetable(l[0], 0, 50, [0, 100, -25, 2], [100, 200, 0, 1], [400, 550, -50, 2])
	$obj.tr = math.timetable(l[0], 0, 255, [400, 550, 0, 2])
	$obj.bright = math.timetable(l[0], 0, 255, [0, 250, 0, 2])
	
	if( 550 < l[0] )
	{
		$obj.disp = 0
		$obj.frame_action.end
	}
}

//---------------------------------------------------------------------------
// クリティカルダメージ数字／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_critical_damage_number(property $obj : object, property $x, property $y, property $damage)
{
	// critical文字
	$obj.create("__mng_hp_critical_damage_text", 1, $x, $y + 75 - <DAMAGE_IMAGE_H> / 2)
	$obj.layer = <HHP_LAYER_EFFECT>
	$obj.y_rep.resize(1)
	$$set_image_center($obj)
	
	// critical数字
	$obj.child.resize(1)
	$obj.child[0].create_number("__mng_hp_critical_damage_number", 1, 0, -75)
	$obj.child[0].set_number_param(4, 0, 0, 0, 0, <DAMAGE_DIGIT_W>)
	$obj.child[0].set_number($damage)
	$obj.child[0].center_rep_y = <DAMAGE_IMAGE_H> / 2
	
	// ダメージの桁数によってx座標を補正する
		if( $damage < 10 )		{ $obj.child[0].x -= <DAMAGE_DIGIT1_OFFSET_X> }
	elseif( $damage < 100 )		{ $obj.child[0].x -= <DAMAGE_DIGIT2_OFFSET_X> }
	elseif( $damage < 1000 )	{ $obj.child[0].x -= <DAMAGE_DIGIT3_OFFSET_X> }
	else						{ $obj.child[0].x -= <DAMAGE_DIGIT4_OFFSET_X> }
	
	$obj.frame_action.start(-1, "$$fa_critical_damage_number")
}

// クリティカルダメージ数字フレームアクション
command $$fa_critical_damage_number(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.tr = math.timetable(l[0], 0, 255, [500, 750, 0, 2])
	$obj.y_rep[0] = math.timetable(l[0], 0, 50, [0, 150, -25, 2], [150, 300, 0, 1], [500, 750, -50, 2])
	$obj.bright = math.timetable(l[0], 0, 255, [0, 500, 0, 1])
	
	$obj.child[0].rotate_y = math.timetable(l[0], 0, 0, [0, 300, 3600, 2])
	
	if( 750 <= l[0] )
	{
		$obj.disp = 0
		$obj.frame_action.end
	}
}

//---------------------------------------------------------------------------
// 横一列スラッシュ／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_slash_h_effect(property $obj : object, property $x, property $y)
{
	$obj.create("__mng_hp_ef_flare01", 1, $x, $y)
	$obj.center_x = $obj.get_size_x / 2
	$obj.blend = 1
	$obj.layer = <HHP_LAYER_EFFECT>
	
	$obj.scale_x = 0
	$obj.scale_x_eve.set(1000, 250, 0, 2)
	$obj.tr_eve.set(0, 250, 250, 2)
}

//---------------------------------------------------------------------------
// 縦一列スラッシュ／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_slash_v_effect(property $obj : object, property $x, property $y)
{
	$obj.create("__mng_hp_ef_flare02", 1, $x, $y)
	$obj.center_y = $obj.get_size_y / 2
	$obj.blend = 1
	$obj.layer = <HHP_LAYER_EFFECT>
	
	$obj.scale_y = 0
	$obj.scale_y_eve.set(1000, 250, 0, 2)
	$obj.tr_eve.set(0, 250, 250, 2)
}










//---------------------------------------------------------------------------
// 敵シールドブレイク／エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_enemy_shield_break(property $obj : object, property $x, property $y)
{
	$obj.disp = 1
	$obj.set_pos($x, $y)
	$obj.layer = <HHP_LAYER_EFFECT>
	$obj.blend = 1
	$obj.child.resize(1)
	
	$$create_particle_radial($obj.child[0], "__mng_particle02",		// 使用するオブジェクト, 画像
						8, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						250, 500,									// 消滅する時間(最小、最大)
						500, 750									// 動きの速さ(最小、最大)
								)
	$$set_particle_shape_to_circle($obj.child[0], 20)
	$$set_particle_color($obj.child[0], "#0000cd", "#00bfff", 255)
	$$set_particle_oneshot($obj.child[0])
	
	$obj.child[0].frame_action.start(-1, "$$fa_particle")
}

//---------------------------------------------------------------------------
// 宝箱エフェクトを生成する
//---------------------------------------------------------------------------
command $$spawn_treasure(property $obj : object, property $x, property $y)
{
	$obj.disp = 1
	$obj.set_pos($x, $y)
	$obj.layer = <HHP_LAYER_UI> + 1
	$obj.child.resize(1)
	
	@ＳＥ_ヘビパ_宝箱ドロップ		// todo ＳＥ
	
	$obj.child[0].create("__mng_hp_ef_treasure", 1)
	$$set_image_center_rep($obj.child[0])
	
	$obj.frame_action.start(-1, "$$fa_treasure", $x, $y)
}

command $$fa_treasure(property $fa : frameaction, property $obj : object, property $start_x, property $start_y)
{
	l[0] = $fa.counter.get
	
	$obj.child[0].scale_y = math.timetable(l[0], 0, 500, [0, 250, 1250, 2], [250, 500, 1000, 1])
	$obj.child[0].y = math.timetable(l[0], 0, 0, [0, 250, -50, 2], [250, 500, 0, 1])
	$obj.child[0].tr = math.timetable(l[0], 0, 0, [0, 250, 255, 1], [1250, 1350, 0, 2])
	
	if( 750 <= l[0] )
	{
		$obj.x = math.timetable(l[0] - 750, 0, $start_x, [0, 500, 1812, 2])
		$obj.y = math.timetable(l[0] - 750, 0, $start_y, [0, 500,  196, 2])
	}
	
	if( 1350 <= l[0] )
	{
		@ＳＥ_ヘビパ_宝箱追加		// todo ＳＥ
		
		$obj.disp = 0
		$obj.frame_action.end
	}
}




//---------------------------------------------------------------------------
// スキル使用エフェクトを再生する
//---------------------------------------------------------------------------
command $$play_hhp_skill_effect(property $obj : object, property $skill_id)
{
	property $i
	property $len
	property $bs_name : str
	
	$len = $$get_hhp_skill_count
	
	// ムービー
	$obj.create_movie("hhp_ef_skill_cutin", ready_only = 1)
	$obj.layer = <HHP_LAYER_CUTIN>
	$obj.child.resize(1)
	
	// 立ち絵
	switch( $skill_id ) {
	case(<HHP_SKILL_ID_SP>)		$bs_name = "bs3_sp21_07"
	case(<HHP_SKILL_ID_AI>)		$bs_name = "bs3_ai12_13"
	case(<HHP_SKILL_ID_HI>)		$bs_name = "bs3_hi21_07"
	case(<HHP_SKILL_ID_KY>)		$bs_name = "bs3_ky21_07"
	case(<HHP_SKILL_ID_RK>)		$bs_name = "bs3_rk22_08"
	}
	
	$$set_bs_object($obj.child[0], $bs_name)
	
	$obj.child[0].tonecurve_no = -1
	$obj.child[0].x_rep.resize(2)
	$obj.child[0].tr_rep.resize(1)
	$obj.child[0].x_rep[0] = -200
	$obj.child[0].x_rep[1] = 0
	$obj.child[0].tr = 0
	$obj.child[0].tr_rep[0] = 255
	
	// 画面更新
	disp
	
	// ムービー
	$obj.disp = 1
	$obj.resume_movie
	
	// 待ち
	timewait_key(500)
	
	// 声再生
	switch( $skill_id ) {
	case(<HHP_SKILL_ID_SP>)		exkoe(000200071,001)
	case(<HHP_SKILL_ID_AI>)		exkoe(000300784,002)
	case(<HHP_SKILL_ID_HI>)		exkoe(000401084,003)
	case(<HHP_SKILL_ID_KY>)		exkoe(000301218,004)
	case(<HHP_SKILL_ID_RK>)		exkoe(004100185,005)
	}
	
	// 立ち絵
	$obj.child[0].x_rep_eve[0].set(0, 500, 0, 2)
	$obj.child[0].x_rep_eve[1].set(200, 250, 1250, 2)
	
	$obj.child[0].tr_eve.set(255, 500, 0, 2)
	$obj.child[0].tr_rep_eve[0].set(0, 250, 1250, 2)
	
	// システムメッセージ表示
	$$show_hhp_sys_message($$get_hhp_skill_name($skill_id), -300)
	
	// 終了待ち
	$obj.child[0].tr_rep_eve[0].wait
	
	// システムメッセージ消去
	$$hide_hhp_sys_message
	
	// 初期化
	$obj.init
}

//---------------------------------------------------------------------------
// 蘇生エフェクトを再生する
//---------------------------------------------------------------------------
command $$play_hhp_rivive_effect(property $obj : object)
{
	@ツミレ吹き出しなし
	
	$obj.init
	$obj.disp = 1
	$obj.layer = <HHP_LAYER_CUTIN>
	$obj.child.resize(5)
	
	$obj.tr = 0
	$obj.tr_eve.set(255, 1000, 0, 2)
	
	// 背景
	$obj.child[0].create("bg_kuro", 1)
	$obj.child[0].tr = 128
	
	// フィルター
	$obj.child[1].create("__mng_hp_filter01", 1)
	$$set_screen_scale($obj.child[1])
	$obj.child[1].mono = 255
	$obj.child[1].blend = 1
	$obj.child[1].tr_eve.turn(64, 255, 5000, 0, 2)
	
	// パーティクル
	$$create_particle($obj.child[2], "ef_particle01",	// 使用するオブジェクト, 画像
						64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						6000, 8000,						// 消滅する時間(最小、最大)
						-10, 10, -150, -100				// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[2],			// 使用するオブジェクト
								0, 1920, 1180, 1280		// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[2], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						750, 1000, 750, 1000			// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj.child[2],					// 使用するオブジェクト
						0, 2000							// ディレイ時間(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[2],					// 使用するオブジェクト
						"#32cd32", "#00fa9a", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルの回転角を設定する
	$$set_particle_rotate($obj.child[2], 0,				// 使用するオブジェクト, 角度を固定するか
						-1800, -1800, 1800, 1800		// 回転角(最小、最大)
	)
	
	// 立ち絵
	$$set_bs_object($obj.child[3], "bs3_tm12_08")
	$obj.child[3].tonecurve_no = -1
	$obj.child[3].x_rep.resize(1)
	$obj.child[3].tr_rep.resize(1)
	
	$obj.child[3].x_rep[0] = -200
	$obj.child[3].x_rep_eve[0].set(0, 500, 1500, 2)
	$obj.child[3].tr_rep[0] = 0
	$obj.child[3].tr_rep_eve[0].set(255, 500, 1500, 2)
	
	// 画面更新
	disp
	
	// 時間待ち
	timewait_key(1500)
	
	// 声再生
	exkoe(000500276,013)
	
	// 時間待ち
	timewait_key(1500)
	
	@ＳＥ_ヘビパ_蘇生		// todo ＳＥ
	
	// パーティクル再生
	$obj.child[2].frame_action.start(-1, "$$fa_particle")	// パーティクルの実行
	$obj.child[2].blend = 1									// 合成タイプを加算にする
	
	// 声再生
	exkoe(000600291,013)
	
	// 「復活した」システムメッセージ必要かも	todo
	
	// 表情変更
	$$set_bs_object($obj.child[4], "bs3_tm13_18")
	$obj.child[4].tonecurve_no = -1
	$obj.child[4].x_rep.resize(1)
	$obj.child[4].tr_rep.resize(1)
	
	$obj.child[4].x_rep_eve[0].set(200, 500, 2500, 2)
	$obj.child[4].tr = 0
	$obj.child[4].tr_eve.set(255, 250, 0, 0)
	$obj.child[4].tr_rep_eve[0].set(0, 500, 2500, 0)
	
	$obj.child[3].tr_eve.set(0, 250, 0, 0)
	
	// 時間待ち
	timewait_key(4000)
	
	// 消去
	$obj.tr_eve.set(0, 500, 0, 2)
	$obj.tr_eve.wait
	
	// 初期化
	$obj.init
}



//---------------------------------------------------------------------------
// タップエフェクト
//---------------------------------------------------------------------------
command $$tap_effect(property $obj : object, property $x, property $y)
{
	$obj.create(_mng_df_ef_tap, 1, $x, $y)
	$$set_image_center($obj)
	$obj.set_scale(0, 0)
	$obj.scale_x_eve.set(1500, 500, 0, 2)
	$obj.scale_y_eve.set(1500, 500, 0, 2)
	$obj.tr_eve.set(0, 250, 150, 2)
	$obj.blend = 1
	$obj.layer = <HHP_LAYER_EFFECT>
	
	$obj.child.resize(1)
	$$create_particle_radial($obj.child[0], ef_fire_spark,
								10, 1, 250, 500,
								50, 70
								)
	$$set_particle_shape_to_circle($obj.child[0], 10)
	$$set_particle_duration($obj.child[0], 1500, 0)
	$$set_particle_oneshot($obj.child[0])
	$$set_particle_auto_tr($obj.child[0], 0)
	$$set_particle_scale($obj.child[0], 1, 2500, 3500, 2500, 3500)
	$$set_particle_color($obj.child[0], "#ff4500", "#dc143c", 128)
	$obj.child[0].frame_action.start(-1, "$$fa_particle")
}

//---------------------------------------------------------------------------
// テスト
//---------------------------------------------------------------------------
command $$test_efect(property $obj : object, property $no, property $x, property $y)
{
	$$create_particle_radial($obj, ef_fire_spark,
								10, 1, 250, 500,
								50, 70
								)
	$$set_particle_shape_to_circle($obj, 10)
	$$set_particle_duration($obj, 1500, 0)
	$$set_particle_oneshot($obj)
	$$set_particle_auto_tr($obj, 0)
	$$set_particle_scale($obj, 1, 2500, 3500, 2500, 3500)
	$$set_particle_color($obj, "#ff4500", "#dc143c", 128)
;	$$set_particle_outside_force($obj, -2, 2, 3, 5)
	$obj.set_pos($x - 10, $y - 10)
	$obj.blend = 1
	$obj.layer = <HHP_LAYER_EFFECT>
	$obj.frame_action.start(-1, "$$fa_particle")
}
