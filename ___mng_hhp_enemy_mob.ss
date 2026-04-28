//===========================================================================
//!
//!    @file     ___mng_hhp_enemy_mob.ss
//!    @brief    ヘビヘビパニック敵データ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// 敵データ管理
	#property	$current_spawn_index				// 敵生成に使用するインデックス
	
	// 各敵／アクション状態
	#replace	<ACTION_STATE_WAIT>			0		// 待機
	#replace	<ACTION_STATE_MOVE>			1		// 移動
	#replace	<ACTION_STATE_ATTACK>		2		// 攻撃
	#replace	<ACTION_STATE_ATTACK_OVER>	3		// 攻撃終了→逃走
	#replace	<ACTION_STATE_STUN>			4		// スタン
	#replace	<ACTION_STATE_STONE>		5		// 石化
	#replace	<ACTION_STATE_ESCAPE>		6		// 逃走
	
	// 各敵／パラメータ
	#replace	f_type					f[28]	// 敵タイプ
	#replace	f_exists				f[29]	// 生存フラグ
	#replace	f_action_state			f[30]	// アクション／状態
	#replace	f_action_time			f[31]	// アクション／時間
	#replace	f_move_time				f[32]	// 移動／現在の移動時間（移動時間が最大になると攻撃に移行する）
	#replace	f_move_time_max			f[33]	// 移動／最大時間
	#replace	f_attack_power			f[34]	// 攻撃力
	#replace	f_attack_speed			f[35]	// 攻撃／速度（１度の攻撃にかける時間）
	#replace	f_attack_count			f[36]	// 攻撃／現在の攻撃回数（最大攻撃数になると逃走に移行する）
	#replace	f_attack_count_max		f[37]	// 攻撃／最大回数
	#replace	f_start_pos_x			f[38]	// 初期座標(x)
	#replace	f_start_pos_y			f[39]	// 初期座標(y)
	#replace	f_end_pos_x				f[40]	// 移動目標座標(x)
	#replace	f_end_pos_y				f[41]	// 移動目標座標(y)
	#replace	f_obj_no				f[42]
	#replace	f_flag_max				43		// フラグ最大数
	
#inc_end

#z00

//---------------------------------------------------------------------------
// 敵を初期化する
//---------------------------------------------------------------------------
command $$init_hhp_enemy
{
	property $i
	
	// 敵生成に使用するインデックスを初期化する
	$current_spawn_index = <HHP_OBJ_ENEMY_START>
	
	// 敵／影を初期化する
	front.object[<HHP_OBJ_ENEMY_SHADOW>].init
	front.object[<HHP_OBJ_ENEMY_SHADOW>].disp = 1
	front.object[<HHP_OBJ_ENEMY_SHADOW>].child.resize(<HHP_OBJ_ENEMY_END> - <HHP_OBJ_ENEMY_START> + 1)
	
	// 各敵を初期化する
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		$$init_enemy(front.object[$i], $i)
	}
}

//---------------------------------------------------------------------------
// 敵を更新する
//---------------------------------------------------------------------------
command $$update_hhp_enemy
{
	property $i
	property $delta_time
	
	// デルタタイムを取得する
	$delta_time = $$get_delta_time
	
	// 各敵オブジェクトの更新をする
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		// 生存していない敵オブジェクトは処理しない
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		// オートプレイフラグがある場合は自動で敵にダメージを与える
		if( $$check_debug_mode_enable )
		{
			if( $$get_hhp_autoplay_flag )
			{
				if( $$get_hhp_enemy_attack_enable(front.object[$i]) )
				{
					$$damage_enemy(front.object[$i], 999)
				}
			}
		}
		
		// 敵を更新する
		$$update_enemy(front.object[$i], $delta_time)
		
		// 敵／影を更新する
		$$update_hhp_enemy_shadow(front.object[<HHP_OBJ_ENEMY_SHADOW>].child[$i - <HHP_OBJ_ENEMY_START>], front.object[$i])
	}
}

// 影
command $$update_hhp_enemy_shadow(property $shadow_obj : object, property $enemy_obj : object)
{
	$shadow_obj.disp = $enemy_obj.disp
	$shadow_obj.set_scale($enemy_obj.scale_x, $enemy_obj.scale_y)
	$shadow_obj.x = $enemy_obj.x + $enemy_obj.x_rep[0] + $enemy_obj.x_rep[1]
	$shadow_obj.y = $enemy_obj.y + $enemy_obj.y_rep[0] + $enemy_obj.y_rep[1]
	$shadow_obj.tr = $enemy_obj.tr
}

//---------------------------------------------------------------------------
// 敵を生成する
//---------------------------------------------------------------------------
command $$spawn_hhp_enemy(property $enemy_type, property $pos_index, property $shield)
{
	// 敵を生成する
	$$spawn_enemy(front.object[$current_spawn_index], $enemy_type, $pos_index, $shield)
	
	// 敵／影を生成する
	$$spawn_enemy_shadow(front.object[<HHP_OBJ_ENEMY_SHADOW>].child[$current_spawn_index - <HHP_OBJ_ENEMY_START>], front.object[$current_spawn_index], $enemy_type)
	
	// 次に使用する敵生成インデックスを設定する
	$current_spawn_index += 1
	if( <HHP_OBJ_ENEMY_END> < $current_spawn_index ) {
		$current_spawn_index = <HHP_OBJ_ENEMY_START>
	}
}

// 影
command $$spawn_enemy_shadow(property $shadow_obj : object, property $enemy_obj : object, property $type)
{
	$shadow_obj.disp = 1
	$shadow_obj.add_hints(no_event = 0)
	
	$shadow_obj.child.resize(1)
	$shadow_obj.child[0].create("__mng_hp_enemy" + math.tostr_zero($type + 1, 2), 1)
	$shadow_obj.child[0].patno = 1
	$shadow_obj.child[0].set_center($shadow_obj.child[0].get_size_x / 2, $shadow_obj.child[0].get_size_y)
	$shadow_obj.child[0].y_rep.resize(1)
	$shadow_obj.child[0].y_rep[0] = $shadow_obj.child[0].get_size_y / 2
}

//---------------------------------------------------------------------------
// 生存している敵の総数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_exists_enemy_count : int
{
	property $i
	property $count
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		// 生成されていない場合はスキップ
		if( front.object[$i].f.get_size == 0 ) {
			continue
		}
		
		// 生存していないオブジェクトはスキップ
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		$count += 1
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// 敵にダメージを与える
//---------------------------------------------------------------------------
command $$damage_hhp_enemy(property $enemy_obj : object, property $damage)
{
	$$damage_enemy($enemy_obj, $damage)
}

//---------------------------------------------------------------------------
// すべての敵にダメージを与える
//---------------------------------------------------------------------------
command $$damage_hhp_all_enemy(property $damage)
{
	property $i
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		// 生存していないオブジェクトは処理しない
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		// 敵にダメージを与える
		$$damage_enemy(front.object[$i], $damage)
	}
	
	// ボスがいる場合はボスにダメージを与える
	if( $$is_hhp_final_wave )
	{
		$$damage_hhp_boss(front.object[<HHP_OBJ_BOSS>], $damage)
	}
}

//---------------------------------------------------------------------------
// すべての敵にスタンを与える
//---------------------------------------------------------------------------
command $$stun_hhp_all_enemy(property $stun_time)
{
	property $i
	
	@ＳＥ_ヘビパ_敵_スタン
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		// 生存していない敵オブジェクトは処理しない
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		// 敵にスタンにする
		front.object[$i].f_action_state = <ACTION_STATE_STUN>
		front.object[$i].f_action_time = $stun_time
	}
	
	// ボスがいる場合はボスにスタンを与える
	if( $$is_hhp_final_wave ) {
		$$stun_hhp_boss(front.object[<HHP_OBJ_BOSS>], $stun_time)
	}
}





//2
//---------------------------------------------------------------------------
// 敵管理マネージャー／敵にダメージを与える
//---------------------------------------------------------------------------

command $$damage_defegg_enemy_near(property $enemy_obj : object, property $damage)
{
	property $i
	property $index
	
	$index = $enemy_obj.f_obj_no
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		if( $index == $i ) {
			continue
		}
		
		// 生存していないオブジェクトは処理しない
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		if( $$get_hhp_enemy_attack_enable(front.object[$i]) == 0 ) {
			continue
		}
		
		if( $$near(front.object[$index], front.object[$i]) ) {
			$$damage_enemy(front.object[$i], $damage)
		}
	}
}

command $$near(property $enemy_obj : object, property $hitbox : object)
{
	property $x1
	property $y1
	property $w1
	property $h1
	
	property $x2
	property $y2
	property $w2
	property $h2
	
	$x1 = $$get_hhp_enemy_x($enemy_obj)
	$y1 = $$get_hhp_enemy_y($enemy_obj)
	$w1 = $$get_hhp_enemy_w($enemy_obj)
	$h1 = $$get_hhp_enemy_h($enemy_obj)
	
	$x2 = $$get_hhp_enemy_x($hitbox)
	$y2 = $$get_hhp_enemy_y($hitbox)
	$w2 = $$get_hhp_enemy_w($hitbox)
	$h2 = $$get_hhp_enemy_h($hitbox)
	
	$x2 = $x2 + $w2 / 2
	$y2 = $y2 + $h2 / 2
	
	if( $x1 <= $x2 && $x2 < $x1 + $w1 )
	{
		if( $y1 <= $y2 && $y2 < $y1 + $h1 )
		{
			return (1)
		}
	}
	
	return(0)
}




command $$is_defegg_all_enemy_escape : int
{
	property $i
	property $flag
	
	$flag = 1
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		if( front.object[$i].f_exists ) {
			$flag = 0
			break
		}
	}
	
	return ($flag)
}

command $$defegg_all_enemy_wait
{
	property $i
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		if( front.object[$i].f_action_state == <ACTION_STATE_MOVE> || front.object[$i].f_action_state == <ACTION_STATE_ATTACK> )
		{
			front.object[$i].f_action_state = <ACTION_STATE_WAIT>
		}
	}
}

command $$defegg_all_enemy_escape
{
	property $i
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		// 生存していない敵オブジェクトは処理しない
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		// 逃走へ
		front.object[$i].f_action_state = <ACTION_STATE_ESCAPE>
		front.object[$i].f_action_time = 500
	}
}

command $$hhp_all_enemy_attack_over
{
	property $i
	
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		// 生存していない敵オブジェクトは処理しない
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		// 逃走へ
		front.object[$i].f_action_state = <ACTION_STATE_ATTACK_OVER>
		front.object[$i].f_action_time = 500
	}
}

command $$check_hhp_all_enemy_hit
{
	property $i
	property $flag
	property $hit_list : intlist
	property $primary_hit
	property $primary_obj
	
	if( $$get_hhp_player_attacking && $$get_hhp_player_direct_attack )
	{
		for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
		{
			if( front.object[$i].f_exists == 0 ) {
				continue
			}
			
			if( $$get_hhp_enemy_attack_enable(front.object[$i]) == 0 ) {
				continue
			}
			
			if( $$check_hhp_enemy_hit(front.object[$i]) )
			{
				$hit_list.resize($hit_list.get_size + 1)
				$hit_list[$hit_list.get_size - 1] = $i
				
				if( front.object[$i].layer > $primary_hit )
				{
					$primary_hit = front.object[$i].layer
					$primary_obj = $i
				}
			}
		}
		
		// 貫通攻撃でない場合は一体のみ
		if( $$get_hhp_player_attack_penetration == 0 )
		{
			if( $hit_list.get_size )
			{
				$$enemy_hit(front.object[$primary_obj])
				$flag = 1
			}
		}
		else
		{
			for( $i = 0, $i < $hit_list.get_size, $i += 1 )
			{
				$$enemy_hit(front.object[$hit_list[$i]])
				$flag = 1
			}
		}
		
		// ボス
		if( $$get_hhp_boss_type != -1 )
		{
			if( $$check_hhp_enemy_hit(front.object[<HHP_OBJ_BOSS>]) )
			{
				$$boss_hit(front.object[<HHP_OBJ_BOSS>])
				
				$flag = 1
			}
		}
	}
	
	return ($flag)
}

command $$check_hhp_enemy_hit(property $enemy_obj : object)
{
	property $x
	property $y
	property $w
	property $h
	property $mouse_x
	property $mouse_y
	
	$x = $$get_hhp_enemy_x($enemy_obj)
	$y = $$get_hhp_enemy_y($enemy_obj)
	$w = $$get_hhp_enemy_w($enemy_obj)
	$h = $$get_hhp_enemy_h($enemy_obj)
	
	$mouse_x = mouse.get_pos_x
	$mouse_y = mouse.get_pos_y
	
	if( $x < $mouse_x && $mouse_x < $x + $w )
	{
		if( $y < $mouse_y && $mouse_y < $y + $h )
		{
			return (1)
		}
	}
	
	return(0)
}

command $$check_hhp_all_enemy_hitbox
{
	/*
	property $i
	property $j
	property $flag
	
	for( $i = <HHP_OBJ_ATTACK_HITBOX_START>, $i < <HHP_OBJ_ATTACK_HITBOX_END>, $i += 1 )
	{
		if( front.object[$i].f.get_size == 0 ) {
			continue
		}
		
		for( $j = <HHP_OBJ_ENEMY_START>, $j <= <HHP_OBJ_ENEMY_END>, $j += 1 )
		{
			if( front.object[$j].f_exists == 0 ) {
				continue
			}
			
			if( front.object[$i].f[1] == 0  ) {
				continue
			}
			
			if( front.object[$j].f_hitbox_id == front.object[$i].f[2] ) {
				continue
			}
			
			if( $$get_hhp_enemy_attack_enable(front.object[$j]) == 0 ) {
				continue
			}
			
			if( $$check_hhp_enemy_hitbox(front.object[$j], front.object[$i]) )
			{
				$$enemy_hit(front.object[$j])
				
				front.object[$j].f_hitbox_id = front.object[$i].f[0]
				
				$flag = 1
			}
		}
		
		if( front.object[<HHP_OBJ_BOSS>].f_hitbox_id != front.object[$i].f[0] )
		{
			if( $$check_hhp_enemy_hitbox(front.object[<HHP_OBJ_BOSS>], front.object[$i]) )
			{
				$$boss_hit(front.object[<HHP_OBJ_BOSS>])
				
				front.object[<HHP_OBJ_BOSS>].f_hitbox_id = front.object[$i].f[0]
				
				$flag = 1
			}
		}
	}
	
	return ($flag)
	*/
}

command $$check_hhp_enemy_hitbox(property $enemy_obj : object, property $hitbox : object)
{
	property $x
	property $y
	property $w
	property $h
	property $cx
	property $cy
	property $rad
	property $dx
	property $dy
	
	$x = $$get_hhp_enemy_x($enemy_obj)
	$y = $$get_hhp_enemy_y($enemy_obj)
	$w = $$get_hhp_enemy_w($enemy_obj)
	$h = $$get_hhp_enemy_h($enemy_obj)
	
	if( $hitbox.f.get_size == 0 ) {
		return (0)
	}
	
	$cx = $hitbox.x - $hitbox.center_x + $hitbox.get_size_x / 2 * (1000 - $hitbox.scale_x) / 1000
	$cy = $hitbox.y - $hitbox.center_y + $hitbox.get_size_y / 2 * (1000 - $hitbox.scale_y) / 1000
	$rad = $hitbox.f[5]
	
	$dx = math.max(math.abs($cx + $rad - ($x + $w / 2)) - $w / 2, 0)
	$dy = math.max(math.abs($cy + $rad - ($y + $h / 2)) - $h / 2, 0)
	
	if( $dx * $dx + $dy * $dy <= $rad * $rad )
	{
		return (1)
	}
	
	return(0)
}

command $$get_enemy_hit_enable(property $enemy_obj : object, property $hitbox_id) : int
{
	if( $enemy_obj.f_exists == 0 ) {
		return (0)
	}
	
	if( $$get_hhp_enemy_attack_enable($enemy_obj) == 0 ) {
		return (0)
	}
	
	if( $$has_hhp_enemy_hitbox_id($enemy_obj, $hitbox_id) ) {
		return (0)
	}
	
	return (1)
}

command $$enemy_hit(property $obj : object)
{
	// エフェクト
	$$spawn_hhp_effect(<HHP_EF_PLAYER_ATTACK>, mouse.get_pos_x, mouse.get_pos_y, 0)
	$$spawn_hhp_effect(<HHP_EF_ENEMY_HIT>, mouse.get_pos_x, mouse.get_pos_y, 0)
	
	$$damage_hhp_enemy($obj, $$get_hhp_player_total_attack_power)
}

command $$boss_hit(property $obj : object)
{
	// エフェクト
	$$spawn_hhp_effect(<HHP_EF_PLAYER_ATTACK>, mouse.get_pos_x, mouse.get_pos_y, 0)
	$$spawn_hhp_effect(<HHP_EF_ENEMY_HIT>, mouse.get_pos_x, mouse.get_pos_y, 0)
	
	
	$$damage_hhp_boss($obj, $$get_hhp_player_total_attack_power)
}
//2

//---------------------------------------------------------------------------
// 各敵／初期化する
//---------------------------------------------------------------------------
command $$init_enemy(property $enemy_obj : object, property $obj_no)
{
	// 子供オブジェクトを確保する
	$enemy_obj.child.resize(c_enemy_base_max)
	
	// ベース
	$enemy_obj.c_enemy_image.create("__mng_hp_enemy01", 1)		// デフォルト画像を読み込んでおく
	$enemy_obj.c_enemy_image.set_center($enemy_obj.c_enemy_image.get_size_x / 2, $enemy_obj.c_enemy_image.get_size_y)
	$enemy_obj.c_enemy_image.y = $enemy_obj.c_enemy_image.get_size_y / 2
	
	// フラグ変数
	$enemy_obj.f.resize(f_flag_max)
	$enemy_obj.f_obj_no = $obj_no
	
	// 当たり判定格納データを初期化する
	$$init_hhp_enemy_hitbox($enemy_obj)
	
	// 表示座標
	$enemy_obj.x_rep.resize(2)
	$enemy_obj.y_rep.resize(2)
	
	// ベース
	$$init_hhp_enemy_base($enemy_obj)
}

//---------------------------------------------------------------------------
// 各敵／生成する
//---------------------------------------------------------------------------
command $$spawn_enemy(property $enemy_obj : object, property $type, property $pos_index, property $shield)
{
	property $filename : str
	
	// 各パラメータ設定
	$enemy_obj.f_type = $type							// 敵タイプ
	$enemy_obj.f_exists = 1								// 生存フラグ
	$enemy_obj.f_action_state = <ACTION_STATE_MOVE>		// アクションステート
	$enemy_obj.f_action_time = 3000						// アクション時間
	
	$enemy_obj.f_move_time = 0														// 移動時間
	$enemy_obj.f_move_time_max = $$get_hhp_enemy_move_speed_default($type)			// 最大移動時間
	$$init_hhp_enemy_life($enemy_obj, $$get_hhp_enemy_life_default($type))			// ライフ
	$enemy_obj.f_attack_power = $$get_hhp_enemy_attack_power_default($type)			// 攻撃力
	$enemy_obj.f_attack_count_max = $$get_hhp_enemy_attack_count_default($type)		// 最大攻撃回数
	$enemy_obj.f_attack_count = $enemy_obj.f_attack_count_max						// 攻撃回数
	$enemy_obj.f_attack_speed = $$get_hhp_enemy_attack_speed_default($type)			// 攻撃速度
	
	// バフ／デバフを初期化する
	$$init_hhp_enemy_status_effect($enemy_obj)
	
	// 敵生成時に発生するイベントを発動する
	$$hhp_item_trigger_on_spawn_enemy($enemy_obj)
	
	// 興奮の場合は移動時間を０．５倍にする
	if( $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_EXCITED>) )
	{
		$enemy_obj.f_move_time_max = $enemy_obj.f_move_time_max * 500 / 1000
		
		// deb
		$enemy_obj.f_attack_speed = $enemy_obj.f_attack_speed * 500 / 1000
	}
	// スロウの場合は移動時間を１．５倍にする
	elseif( $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_SLOW>) )
	{
		$enemy_obj.f_move_time_max = $enemy_obj.f_move_time_max * 1500 / 1000
	}
	
	// シールドバフの場合はシールドを追加する
	if( $shield )
	{
		$enemy_obj.f_enemy_shield = 1
	}
	
	// ＵＩを初期化する
	$enemy_obj.disp = 1								// オブジェクトを表示する
	$enemy_obj.tr = 255								// 不透明度を初期化する
	
	// 画像の設定
	$filename = "__mng_hp_enemy" + math.tostr_zero($type + 1, 2)
	$enemy_obj.c_enemy_image.change_file($filename)
	$enemy_obj.c_enemy_image.set_center($enemy_obj.c_enemy_image.get_size_x / 2, $enemy_obj.c_enemy_image.get_size_y)
	$enemy_obj.c_enemy_image.y = $enemy_obj.c_enemy_image.get_size_y / 2
	
	$enemy_obj.f_start_pos_x = $$get_hhp_enemy_spawn_x($pos_index)
	$enemy_obj.f_start_pos_y = $$get_hhp_enemy_spawn_y($pos_index)
	$enemy_obj.f_end_pos_x = $$get_hhp_enemy_target_x(math.rand(0, $$get_hhp_enemy_target_x_count - 1)) - $enemy_obj.f_start_pos_x
	$enemy_obj.f_end_pos_y = $$get_hhp_enemy_target_y - $enemy_obj.f_start_pos_y
	
	// --- deb
	$enemy_obj.x = $$get_hhp_enemy_spawn_x($pos_index)
	$enemy_obj.y = $$get_hhp_enemy_spawn_y($pos_index)
	$enemy_obj.x_rep[0] = 0
	$enemy_obj.x_rep[1] = 0
	$enemy_obj.y_rep[0] = 0
;	$obj.scale_y_eve.turn(950, 1000, 500, 0, 2)
	
	if( system.check_debug_flag )
	{
		property $x
		property $y
		property $w
		property $h
		
		$x = $enemy_obj.c_enemy_image.x - $enemy_obj.c_enemy_image.center_x + $enemy_obj.c_enemy_image.get_size_x / 2 * (1000 - $enemy_obj.c_enemy_image.scale_x) / 1000
		$y = $enemy_obj.c_enemy_image.y - $enemy_obj.c_enemy_image.center_y + $enemy_obj.c_enemy_image.get_size_y * (1000 - $enemy_obj.c_enemy_image.scale_y) / 1000
		$w = $enemy_obj.c_enemy_image.get_size_x * $enemy_obj.c_enemy_image.scale_x / 1000
		$h = $enemy_obj.c_enemy_image.get_size_y * $enemy_obj.c_enemy_image.scale_y / 1000
		
		$enemy_obj.c_enemy_collision.create_rect($x, $y, $x + $w, $y + $h, 255, 0, 0, 128, $$get_hhp_debug_collision_disp_flag)
	}
}

//---------------------------------------------------------------------------
// 各敵／更新する
//---------------------------------------------------------------------------
command $$update_enemy(property $enemy_obj : object, property $delta_time)
{
	$$update_hhp_enemy_base($enemy_obj)
	
	switch( $enemy_obj.f_action_state ) {
	
	// 待機
	case(<ACTION_STATE_WAIT>)
		
		// 処理なし
		
	// 移動
	case(<ACTION_STATE_MOVE>)
		
		$enemy_obj.f_move_time += $delta_time
		
		// 移動時間に応じて座標、レイヤー値を変更する
		$enemy_obj.x_rep[0] = math.linear($enemy_obj.f_move_time, 0, 0, $enemy_obj.f_move_time_max, $enemy_obj.f_end_pos_x)
		$enemy_obj.y_rep[0] = math.linear($enemy_obj.f_move_time, 0, 0, $enemy_obj.f_move_time_max, $enemy_obj.f_end_pos_y)
		$enemy_obj.layer = $enemy_obj.y_rep[0]
		
		// 移動時間に応じて拡縮率を変更する
		$enemy_obj.scale_x = math.linear($enemy_obj.f_move_time, 0, 350, $enemy_obj.f_move_time_max, 1000)
		$enemy_obj.scale_y = $enemy_obj.scale_x
		
		// 移動時間が最大になった場合は攻撃ステートへ
		if( $enemy_obj.f_move_time_max <= $enemy_obj.f_move_time )
		{
			$enemy_obj.f_move_time = $enemy_obj.f_move_time_max
			
			$enemy_obj.f_action_state = <ACTION_STATE_ATTACK>
			$enemy_obj.f_action_time = $enemy_obj.f_attack_speed
		}
		
	// 攻撃
	case(<ACTION_STATE_ATTACK>)
		
		$enemy_obj.f_action_time -= $delta_time
		
		// 待ち時間がない場合は攻撃が発生する
		if( $enemy_obj.f_action_time <= 0 )
		{
			// 状態異常／怒りがある場合攻撃速度が速くなる
			if( $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_ANGRY>) )
			{
				$enemy_obj.f_attack_speed /= 2
			}
			
			$enemy_obj.f_action_time = $enemy_obj.f_attack_speed
			$enemy_obj.f_attack_count -= 1
			
			// プレイヤーのライフを減らす
			$$add_hhp_player_life(-$enemy_obj.f_attack_power)
			
			// プレイヤーダメージ時に発生するアイテムトリガーを発動する
			$$hhp_item_trigger_on_player_damage($enemy_obj)
			
			// 無敵が発生していない場合は画面を揺らす
			if( $$get_hhp_player_invincible_time <= 0 )
			{
				@SE_ヘビパ_敵攻撃
				
				$$spawn_hhp_effect(<HHP_EF_ENEMY_ATTACK>, $$get_hhp_enemy_x($enemy_obj) + $$get_hhp_enemy_w($enemy_obj) / 2, 850, 0)
				$$shake_hhp_screen(0)
			}
			else
			{
			}
			
			// オブジェクトを赤く光らせる
			$enemy_obj.color_add_r = 196
			$enemy_obj.color_add_r_eve.set(0, 500, 0, 0)
			
			// 攻撃回数がなくなった場合は逃走ステートへ
			if( $enemy_obj.f_attack_count < 0 )
			{
				$enemy_obj.f_action_state = <ACTION_STATE_ATTACK_OVER>
				$enemy_obj.f_action_time = 500
			}
		}
		
	// 攻撃終了
	case(<ACTION_STATE_ATTACK_OVER>)
		
		// deb 逃走処理としてオブジェクトの座標移動を行う
		if( $enemy_obj.f_exists == 1 )
		{
			$enemy_obj.f_exists = 2
		}
		
		$enemy_obj.f_action_time -= $delta_time
		
		// 敵の座標移動
		$enemy_obj.tr = math.timetable(500 - $enemy_obj.f_action_time, 0, 255, [150, 800, 0, 2])
		
		if( $enemy_obj.x >= 960 ) {
			$enemy_obj.x_rep[1] = math.timetable(500 - $enemy_obj.f_action_time, 0, 0, [300, 800, $enemy_obj.x_rep[0] + 300, 2])
		} else {
			$enemy_obj.x_rep[1] = math.timetable(500 - $enemy_obj.f_action_time, 0, 0, [300, 800, $enemy_obj.x_rep[0] - 300, 2])
		}
		
		// 待ち時間がない場合は逃走終了処理を行う
		if( $enemy_obj.f_action_time <= 0 )
		{
			// 逃走終了処理
			$enemy_obj.disp = 0			// 敵を非表示にする
			$enemy_obj.f_exists = 0		// 生存フラグをオフにする
			$enemy_obj.f_action_state = <ACTION_STATE_WAIT>		// 待機状態にする
	;		$enemy_obj.all_eve.end		// すべてのイベントを終了する
		}
		
	// スタン
	case(<ACTION_STATE_STUN>)
		
		$enemy_obj.f_action_time -= $delta_time
		
		// 待ち時間がない場合は移動ステートへ
		if( $enemy_obj.f_action_time <= 0 )
		{
			$enemy_obj.f_action_state = <ACTION_STATE_MOVE>	// 移動へ
		}
		
	// 石化
	case(<ACTION_STATE_STONE>)
		
		$enemy_obj.f_action_time -= $delta_time
		
		// 待ち時間がない場合は移動ステートへ
		if( $enemy_obj.f_action_time <= 0 )
		{
			$enemy_obj.mono = 0
			
			$enemy_obj.f_action_state = <ACTION_STATE_MOVE>	// 移動へ
		}
		
	// 逃走
	case(<ACTION_STATE_ESCAPE>)
		
		// deb 逃走処理としてオブジェクトの座標移動を行う
		if( $enemy_obj.f_exists == 1 )
		{
			$enemy_obj.f_exists = 2
		}
		
		$enemy_obj.f_action_time -= $delta_time
		
		// 敵の座標移動
		$enemy_obj.bright = math.timetable(500 - $enemy_obj.f_action_time, 0, 128, [150, 700, 0, 2])
		$enemy_obj.tr = math.timetable(500 - $enemy_obj.f_action_time, 0, 255, [150, 700, 0, 2])
		
		$enemy_obj.c_enemy_image.scale_y = math.timetable(500 - $enemy_obj.f_action_time, 0, 1000, [0, 100, 650, 2], [100, 200, 1000, 2])
		if( $enemy_obj.x >= 960 ) {
			$enemy_obj.x_rep[1] = math.timetable(500 - $enemy_obj.f_action_time, 0, 0, [0, 700, $enemy_obj.x_rep[0] + 500, 2])
		} else {
			$enemy_obj.x_rep[1] = math.timetable(500 - $enemy_obj.f_action_time, 0, 0, [0, 700, $enemy_obj.x_rep[0] - 500, 2])
		}
		
		// 待ち時間がない場合は逃走終了処理を行う
		if( $enemy_obj.f_action_time <= 0 )
		{
			// 逃走終了処理
			$enemy_obj.disp = 0			// 敵を非表示にする
			$enemy_obj.f_exists = 0		// 生存フラグをオフにする
			$enemy_obj.f_action_state = <ACTION_STATE_WAIT>		// 待機状態にする
	;		$enemy_obj.all_eve.end		// すべてのイベントを終了する
		}
	}
	
	// ＵＩ／更新する
	$enemy_obj.c_enemy_image.dark = math.linear($enemy_obj.f_enemy_life, 0, 192, $enemy_obj.f_enemy_life_max, 0)
	$enemy_obj.c_enemy_image.color_add_r = $enemy_obj.c_enemy_image.dark
	
	$$update_ui_emotion($enemy_obj, $enemy_obj.c_enemy_emotion)				// エモーション
	
	if( system.check_debug_flag )
	{
		$enemy_obj.c_enemy_collision.disp = $$get_hhp_debug_collision_disp_flag
	}
}

//---------------------------------------------------------------------------
// 各敵／ダメージを受ける
//---------------------------------------------------------------------------
command $$damage_enemy(property $enemy_obj : object, property $damage)
{
#start
	property $double_attack
	property $critical
	property $value
	
	// 石化の場合はダメージを受けない
	if( $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_STONE>) )
	{
		return
	}
	
	// シールドを持っている場合はシールドを解除する
	if( $enemy_obj.f_enemy_shield )
	{
		$enemy_obj.f_enemy_shield -= 1
		
		@ＳＥ_ヘビパ_敵_シールドブレイク
		
		// エフェクト
		$$spawn_hhp_effect(<HHP_EF_ENEMY_SHIELD_BREAK>, $$get_hhp_enemy_x($enemy_obj) + $$get_hhp_enemy_w($enemy_obj) / 2, $$get_hhp_enemy_y($enemy_obj) + $$get_hhp_enemy_h($enemy_obj) / 2, 0)
		
		return
	}
	
	// 敵にダメージを与える
	$$damage_hhp_enemy_base($enemy_obj, $damage)
	
	// ライフがなくなった場合
	if( $enemy_obj.f_enemy_life <= 0 )
	{
		// 逃走ステートへ
		$enemy_obj.f_action_state = <ACTION_STATE_ESCAPE>
		$enemy_obj.f_action_time = 500
		
		// スコアを追加する
		$value = math.linear($enemy_obj.f_move_time, 0, $enemy_obj.f_enemy_life_max, $enemy_obj.f_move_time_max, $enemy_obj.f_enemy_life_max)
		
		// オーバーキル
		if( $enemy_obj.f_enemy_life < 0 )
		{
			$value += $enemy_obj.f_enemy_life * -1
		}
		
		if( $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_EXCITED>) )
		{
			$value = $value * 1500 / 1000
		}
		
		$$add_hhp_score($value)
		
		// タップ精密度を判定する
		if( $enemy_obj.f_move_time_max / 4 * 3 <= $enemy_obj.f_move_time )
		{
			@SE_ヘビパ_タップ_エクセレント
			$value = 2
		}
		else
		{
			@SE_ヘビパ_タップ_グレイト
			$value = 1
		}
		
		// 敵が死亡した際に発生するイベント
		$$hhp_item_trigger_on_enemy_dead($enemy_obj)
	}
	else
	{
		// スタン力がある場合はスタンステートへ
		if( $$get_hhp_player_total_stun_power > 0 )
		{
			$enemy_obj.f_action_state = <ACTION_STATE_STUN>
			$enemy_obj.f_action_time = $$get_hhp_player_total_stun_power
		}
		else
		{
			// スタンパワーがない場合は移動へ
			$enemy_obj.f_action_state = <ACTION_STATE_MOVE>
		}
	}
	
	if( $$get_hhp_player_attack_double && $double_attack == 0 ) {
		$double_attack = 1
		goto #start
	}
}

//---------------------------------------------------------------------------
// 敵に攻撃が可能かどうか
//---------------------------------------------------------------------------
command $$get_hhp_enemy_attack_enable(property $obj : object) : int
{
	if( $obj.f_action_state == <ACTION_STATE_MOVE> || $obj.f_action_state == <ACTION_STATE_ATTACK> || $obj.f_action_state == <ACTION_STATE_STUN> ) {
		return (1)
	}
	
	return (0)
}

// 更新する
command $$update_ui_emotion(property $enemy_obj : object, property $ui_obj : object)
{
	/*
	if( $enemy_obj.f_action_state == <ACTION_STATE_ESCAPE> || $enemy_obj.f_action_state == <ACTION_STATE_WAIT> )
	{
		$ui_obj.child[0].disp = 1
	}
	else
	{
		$ui_obj.child[0].disp = 0
	}
	
	if( $enemy_obj.f_action_state == <ACTION_STATE_STUN> )
	{
		$ui_obj.child[1].disp = 1
	}
	else
	{
		$ui_obj.child[1].disp = 0
	}
	*/
}
