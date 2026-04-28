//===========================================================================
//!
//!    @file     ___mng_hhp_boss.ss
//!    @brief    ヘビヘビパニックボスデータ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// 座標
	#replace	<INTRO_POS_Y>			340			// 登場時
	#replace	<DEFEAT_POS_Y>			-500		// 討伐時
	#replace	<HIDE_POS_Y>			-350		// 隠れている（攻撃不可）時
	#replace	<SHOW_POS_Y>			440			// 現れている（攻撃可）時
	
	// ボス（オロチ）／アクション状態
	#replace	<BOSS_STATE_WAIT>			0		// 待機
	#replace	<BOSS_STATE_SPAWN_ENEMY>	1		// モブ敵生成
	
	// 変数
	#property	$boss_state				// ボス／アクション状態
	#property	$boss_state_time		// ボス／アクション時間
	#property	$boss_turn				// 現在のターン
	#property	$boss_turn_max			// 最大ターン
	#property	$boss_weak_point_x		// 弱点(x座標)
	#property	$boss_weak_point_y		// 弱点(y座標)
	
	// ボス／パラメータ
	#replace	f_action_state			f[28]	// アクション／状態
	#replace	f_action_time			f[29]	// アクション／時間
	#replace	f_flag_max				30		// フラグ最大数
	
#inc_end

#z00

//---------------------------------------------------------------------------
// ボスを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_boss(property $boss_obj : object, property $shadow_obj : object, property $type, property $life)
{
	// 初期化
	$boss_obj.init
	$boss_obj.set_pos(<SCREEN_CENTER_X>, -<SCREEN_HEIGHT>)	// 画面外に表示
	$boss_obj.layer = <HHP_LAYER_BOSS>
	
	// 子供オブジェクトを確保する
	$boss_obj.child.resize(c_enemy_base_max)
	
	// フラグ変数
	$boss_obj.f.resize(f_flag_max)
	
	// 画像読み込み
	$boss_obj.c_enemy_image.create("__mng_hp_boss" + math.tostr_zero($type, 2), 1)
	$boss_obj.c_enemy_image.set_center($boss_obj.c_enemy_image.get_size_x / 2, $boss_obj.c_enemy_image.get_size_y)
	$boss_obj.c_enemy_image.y = $boss_obj.c_enemy_image.get_size_y / 2
	
	// ボス／影を生成する
	$shadow_obj.create("__mng_hp_boss" + math.tostr_zero($type, 2), 0, $boss_obj.x, $boss_obj.y, 1)
	$shadow_obj.set_center($boss_obj.c_enemy_image.get_size_x / 2, $boss_obj.c_enemy_image.get_size_y)
	$shadow_obj.y_rep.resize(1)
	$shadow_obj.y_rep[0] = $boss_obj.c_enemy_image.get_size_y / 2
	$shadow_obj.add_hints(no_event = 0)
	
	// ライフを設定する
	$$init_hhp_enemy_life($boss_obj, $life)
	
	// 変数の初期化
	$boss_state = <BOSS_STATE_WAIT>
	$boss_state_time = 0
	$boss_turn = 0
	$boss_turn_max = 3
	$boss_weak_point_x = -1
	$boss_weak_point_y = -1
	
	// デバッグ用
	if( system.check_debug_flag )
	{
		property $x
		property $y
		property $w
		property $h
		
		$x = $boss_obj.c_enemy_image.x - $boss_obj.c_enemy_image.center_x + $boss_obj.c_enemy_image.get_size_x / 2 * (1000 - $boss_obj.c_enemy_image.scale_x) / 1000
		$y = $boss_obj.c_enemy_image.y - $boss_obj.c_enemy_image.center_y + $boss_obj.c_enemy_image.get_size_y * (1000 - $boss_obj.c_enemy_image.scale_y) / 1000
		$w = $boss_obj.c_enemy_image.get_size_x * $boss_obj.c_enemy_image.scale_x / 1000
		$h = $boss_obj.c_enemy_image.get_size_y * $boss_obj.c_enemy_image.scale_y / 1000
		
		$boss_obj.c_enemy_collision.create_rect($x, $y, $x + $w, $y + $h, 255, 0, 0, 128, $$get_hhp_debug_collision_disp_flag)
	}
	
	// 敵共通初期化
	$$init_hhp_enemy_base($boss_obj)
}

//---------------------------------------------------------------------------
// ボスを更新する
//---------------------------------------------------------------------------
command $$update_hhp_boss
{
	property $delta_time
	
	$delta_time = $$get_delta_time
	
	// ボスによって処理を変更する
	switch( $$get_hhp_boss_type ) {
	case(<HHP_BOSS_TYPE_OROCHI>)	$$update_boss_orochi($delta_time)
	case(<HHP_BOSS_TYPE_HYDRA>)		$$update_boss_orochi($delta_time)
	case(<HHP_BOSS_TYPE_MEDUSA>)	$$update_boss_orochi($delta_time)
	}
	
	// 敵共通更新
	$$update_hhp_enemy_base(front.object[<HHP_OBJ_BOSS>])
}

//---------------------------------------------------------------------------
// ボス（オロチ）を更新する
//---------------------------------------------------------------------------
command $$update_boss_orochi(property $delta_time)
{
	switch( $boss_state ) {
	
	// モブ生成ターン
	case(0)
		
		// デルタタイムをステート管理時間に加算する
		$boss_state_time += $delta_time
		
		// 敵を生成するルーチンを実行する
		if( $$handle_timed_enemy_spawn )
		{
			front.object[<HHP_OBJ_BOSS>].frame_action.start(-1, "$$fa_spawn_enemy")
		}
		
		// １５秒耐えると次のステートへ移行
		if( 15000 <= $boss_state_time )
		{
			$boss_state += 1
			$boss_state_time = 0
		}
		
	// 全モブ消滅待ち
	case(1)
		
		// デルタタイムをステート管理時間に加算する
		$boss_state_time += $delta_time
		
		// 全モブを倒した場合ボスに攻撃が可能になる
		if( $$is_defegg_all_enemy_escape )
		{
			// ボスを表示する
			$$boss_attack_enable(front.object[<HHP_OBJ_BOSS>])
			
			$boss_state += 1
			$boss_state_time = 0
		}
		
	// ボスの表示待ち
	case(2)
		
		// デルタタイムをステート管理時間に加算する
		$boss_state_time += $delta_time
		
		if( 750 <= $boss_state_time )
		{
			// チュートリアル
			if( $$get_hhp_global_play_count == 0 )
			{
				if( $$get_hhp_tutorial_flag < 13 )
				{
					$$show_defegg_tutorial(13)
				}
			}
			
			$boss_state += 1
			$boss_state_time = 0
		}
		
	// プレイヤーの直接攻撃
	case(3)
		
		/*
		// スタン
		if( 0 < $boss_status_effect_time )
		{
			front.object[<HHP_OBJ_BOSS>].child[0].disp = 0
			front.object[<HHP_OBJ_BOSS>].child[1].disp = 1
			
			$boss_status_effect_time -= $delta_time
			
			if( $boss_status_effect_time < 0 )
			{
				front.object[<HHP_OBJ_BOSS>].child[0].disp = 1
				front.object[<HHP_OBJ_BOSS>].child[1].disp = 0
				$boss_status_effect_time = 0
			}
			
			return
		}
		*/
		
		// デルタタイムをステート管理時間に加算する
		$boss_state_time += $delta_time
		
		// ７秒間ボスを攻撃可能
		if( 7000 <= $boss_state_time )
		{
			// ボスを攻撃不可にする
			$$boss_attack_disable(front.object[<HHP_OBJ_BOSS>])
			
			$boss_state += 1
			$boss_state_time = 0
			
			if( $boss_turn >= $boss_turn_max ) {
				$boss_state += 1
			}
		}
		
	// ボスの非表示待ち
	case(4)
		
		// デルタタイムをステート管理時間に加算する
		$boss_state_time += $delta_time
		
		if( 3000 <= $boss_state_time )
		{
			$boss_state = 0
			$boss_state_time = 0
			$boss_turn += 1
		}
		
	// ボスに強制敗北
	case(5)
		
	}
}

//---------------------------------------------------------------------------
// ボスにダメージを与える
//---------------------------------------------------------------------------
command $$damage_hhp_boss(property $boss_obj : object, property $damage)
{
	if( $boss_state != 3 ) {
		return
	}
	
	// 敵にダメージを与える
	$$damage_hhp_enemy_base($boss_obj, $damage)
	
	// スコアを加算する
	$$add_hhp_score(100)
	
	// 効果音を再生する
	@SE_ヘビパ_タップ_エクセレント
	
	// エフェクト
	$$spawn_hhp_effect(<HHP_EF_PLAYER_ATTACK>, mouse.get_pos_x, mouse.get_pos_y, 0)
	$$spawn_hhp_effect(<HHP_EF_ENEMY_HIT>, mouse.get_pos_x, mouse.get_pos_y, 0)
}

//---------------------------------------------------------------------------
// ボスにスタンを与える
//---------------------------------------------------------------------------
command $$stun_hhp_boss(property $boss_obj : object, property $stun_time)
{
	;$boss_status_effect_time = $stun_time
}

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
command $$get_hhp_boss_turn : int
{
	return ($boss_turn)
}

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
command $$is_hhp_boss_turn_max : int
{
	if( $boss_turn >= $boss_turn_max ) {
		return (1)
	}
	return (0)
}

//---------------------------------------------------------------------------
// ボスを攻撃可能にする
//---------------------------------------------------------------------------
command $$boss_attack_enable(property $obj : object)
{
	$obj.child[2].disp = 1
	$obj.y = 240 - 500
	$obj.frame_action.start(-1, "$$fa_boss_attack_enable")
}

command $$fa_boss_attack_enable(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	$obj.y = math.timetable(l[0], 0, 240 - 500, [0, 750, 740 - 500, 1])
}

//---------------------------------------------------------------------------
// ボスを攻撃不可にする
//---------------------------------------------------------------------------
command $$boss_attack_disable(property $obj : object)
{
	$obj.child[2].disp = 0
	$obj.y = 740 - 500
	$obj.frame_action.start(-1, "$$fa_boss_attack_disable")
}

command $$fa_boss_attack_disable(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	$obj.y = math.timetable(l[0], 0, 740 - 500, [0, 750, 240 - 500, 1])
}










//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
command $$fa_spawn_enemy(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.bright = math.timetable(l[0], 0, 0, [0, 150, 96, 2], [150, 300, 0, 1])
	
	$obj.c_enemy_image.scale_x = math.timetable(l[0], 0, 1000, [0, 150, 1250, 2], [150, 300, 1000, 1])
	$obj.c_enemy_image.scale_y = math.timetable(l[0], 0, 1000, [0, 150, 1250, 2], [150, 300, 1000, 1])
}

//---------------------------------------------------------------------------
// ボスの登場演出を再生する
//---------------------------------------------------------------------------
command $$play_hhp_boss_intro(property $boss_obj : object, property $shadow_obj : object)
{
	//------------------------------------------
	// warning表示
	@bgm_stop(2000)
	
	$$show_hhp_boss_warning_animation
	
	timewait_key(2000)
	
	//------------------------------------------
	// ボス出現
	$shadow_obj.y = <INTRO_POS_Y>
	$boss_obj.disp = 1
	$shadow_obj.disp = 1
	
	$boss_obj.frame_action.start(-1, "$$fa_show_boss")
	$shadow_obj.frame_action.start(-1, "$$fa_show_boss_shadow")
	
	timewait_key(750)
	
	//------------------------------------------
	// 着地エフェクト
	$$spawn_hhp_effect(<HHP_EF_BOSS_LANDING>, 960, 560, 0)
	$$shake_hhp_screen(1)
	
	timewait_key(1500)
	
	//------------------------------------------
	// ライフバーを表示する
	$$show_hhp_boss_lifebar_animation
	
	timewait_key(2000)
	
	//------------------------------------------
	// todo ボスチュートリアル
	/*
	if( $$get_hhp_global_play_count == 0 )
	{
		if( $$get_hhp_tutorial_flag < 11 )
		{
			$$show_defegg_tutorial(11)
			$$show_defegg_tutorial(12)
		}
	}
	*/
	$$show_hhp_sys_message("敵の攻撃をしのぎきれ！", 0)
	
	//------------------------------------------
	// 初期状態へ
	$$hide_hhp_boss_warning_animation
	
	$boss_obj.frame_action.start(-1, "$$fa_boss_init")
	$shadow_obj.frame_action.start(-1, "$$fa_boss_shadow")
	
	timewait_key(1000)
}

// ボス出現
command $$fa_show_boss(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.y = math.timetable(l[0], 0, -$obj.c_enemy_image.get_size_y, [0, 750, <INTRO_POS_Y>, 1])
	
	$obj.c_enemy_image.scale_x = math.timetable(l[0], 0, 1000, [700, 900, 1250, 2], [900, 1050,  850, 2], [1050, 1200, 1050, 2], [1200, 1300, 1000, 2])
	$obj.c_enemy_image.scale_y = math.timetable(l[0], 0, 1000, [700, 900,  750, 2], [900, 1050, 1150, 2], [1050, 1200,  950, 2], [1200, 1300, 1000, 2])
	
	if( l[0] > 1300 )
	{
		$obj.frame_action.end
		$obj.y = <INTRO_POS_Y>
		$obj.c_enemy_image.set_scale(1000, 1000)
	}
}

// ボス／影出現
command $$fa_show_boss_shadow(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.scale_x = math.timetable(l[0], 0, 0, [0, 750, 1000, 1])
	$obj.scale_y = math.timetable(l[0], 0, 0, [0, 750, 1000, 1])
	
	if( l[0] > 750 )
	{
		$obj.frame_action.end
		$obj.set_scale(1000, 1000)
	}
}

// ボス／初期状態へ
command $$fa_boss_init(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.y = math.timetable(l[0], 0, <INTRO_POS_Y>, [0, 750, <HIDE_POS_Y>, 2])
	
	if( l[0] > 750 )
	{
		$obj.frame_action.end
		$obj.y = <HIDE_POS_Y>
	}
}

// ボス／影を更新する
command $$fa_boss_shadow(property $fa : frameaction, property $obj : object)
{
	$obj.set_pos(front.object[<HHP_OBJ_BOSS>].x, front.object[<HHP_OBJ_BOSS>].y)
}

//---------------------------------------------------------------------------
// ボスの討伐演出を再生する
//---------------------------------------------------------------------------
command $$play_hhp_boss_defeat(property $boss_obj : object)
{
	$boss_obj.frame_action.start(-1, "$$fa_defeat_boss")
	
	timewait_key(3500)
	
	@bgm_stop(2000)
}

// ボス討伐
command $$fa_defeat_boss(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.bright = math.timetable(l[0], 0, 0, [100, 250, 192, 2], [250, 300, 0, 1], [500, 600, 192, 2], [600, 650, 0, 1], [1000, 1500, 255, 1], [1500, 2500, 0, 2])
	$obj.y = math.timetable(l[0], 0, <SHOW_POS_Y>, [2500, 3000, <DEFEAT_POS_Y>, 2])
	$obj.scale_x = math.timetable(l[0], 0, 1000, [2500, 3000, 750, 2])
	$obj.scale_y = $obj.scale_x
	
	if( l[0] > 3500 )
	{
		$obj.frame_action.end
		$obj.y = <DEFEAT_POS_Y>
	}
}
