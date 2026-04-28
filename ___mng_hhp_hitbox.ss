//===========================================================================
//!
//!    @file     ___mng_hhp_hitbox.ss
//!    @brief    ヘビヘビパニック当たり判定管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// 敵全体管理
	#property	$current_spawn_index			// 当たり判定生成に使用するインデックス
	
	// 各当たり判定／パラメータ
	#replace	f_type					f[0]	// 当たり判定タイプ
	#replace	f_exists				f[1]	// 生存フラグ
	#replace	f_hitbox_id				f[2]	// 当たり判定ID
	#replace	f_time					f[3]	// 経過時間
	#replace	f_time_max				f[4]	// 最大時間
	#replace	f_rad					f[5]	// 半径
	#replace	f_flag_max				6		// フラグ最大数
	
#inc_end

#z00

//---------------------------------------------------------------------------
// 当たり判定を初期化する
//---------------------------------------------------------------------------
command $$init_hhp_hitbox
{
	property $i
	
	// 当たり判定生成に使用するインデックスを初期化する
	$current_spawn_index = <HHP_OBJ_ATTACK_HITBOX_START>
	
	// 各当たり判定を初期化する
	for( $i = <HHP_OBJ_ATTACK_HITBOX_START>, $i <= <HHP_OBJ_ATTACK_HITBOX_END>, $i += 1 )
	{
		$$init_hitbox(front.object[$i], $i)
	}
}

//---------------------------------------------------------------------------
// 当たり判定を更新する
//---------------------------------------------------------------------------
command $$update_hhp_hitbox
{
	property $i
	property $j
	property $delta_time
	
	// デルタタイムを取得する
	$delta_time = $$get_delta_time
	
	for( $i = <HHP_OBJ_ATTACK_HITBOX_START>, $i <= <HHP_OBJ_ATTACK_HITBOX_END>, $i += 1 )
	{
		// 生存していないオブジェクトは処理しない
		if( front.object[$i].f_exists == 0 ) {
			continue
		}
		
		// 経過時間を加算する
		front.object[$i].f_time += $delta_time
		
		// 経過時間が最大時間を超えている場合は当たり判定を消去する
		if( front.object[$i].f_time_max < front.object[$i].f_time )
		{
			front.object[$i].disp = 0
			front.object[$i].f_exists = 0
			
			continue
		}
		
		// 当たり判定の各タイプによって動作を変更する
		switch( front.object[$i].f_type ) {
		case(<HHP_HITBOX_TYPE_RADIAL>)		$$update_radial_hitbox(front.object[$i])		// 円形
		case(<HHP_HITBOX_TYPE_HORIZONTAL>)	$$update_horizontal_hitbox(front.object[$i])	// 水平
		case(<HHP_HITBOX_TYPE_VERTICAL>)	$$update_vertical_hitbox(front.object[$i])		// 垂直
		}
		
		// 敵との当たり判定をチェックする
		$$check_enemy_hitbox(front.object[$i])
	}
}

//---------------------------------------------------------------------------
// 敵との当たり判定をチェックする
//---------------------------------------------------------------------------
command $$check_enemy_hitbox(property $hitbox_obj : object)
{
	property $i
	property $hit
	
	// 各敵との当たり判定をチェックする
	for( $i = <HHP_OBJ_ENEMY_START>, $i <= <HHP_OBJ_ENEMY_END>, $i += 1 )
	{
		if( $$get_enemy_hit_enable(front.object[$i], $hitbox_obj.f_hitbox_id) == 0 ) {
			continue
		}
		
		// 各タイプによってチェックする当たり判定を変更する
		switch( $hitbox_obj.f_type ) {
		case(<HHP_HITBOX_TYPE_RADIAL>)			$hit = $$check_radial_hitbox($hitbox_obj, front.object[$i])
		case(<HHP_HITBOX_TYPE_HORIZONTAL>)		$hit = $$check_horizontal_hitbox($hitbox_obj, front.object[$i])
		case(<HHP_HITBOX_TYPE_VERTICAL>)		$hit = $$check_vertical_hitbox($hitbox_obj, front.object[$i])
		}
		
		if( $hit )
		{
			$$set_hhp_enemy_hitbox_id(front.object[$i], $hitbox_obj.f_hitbox_id)
			$$damage_hhp_enemy(front.object[$i], $$get_hhp_player_total_attack_power)
		}
	}
}

//---------------------------------------------------------------------------
// 当たり判定を生成する
//---------------------------------------------------------------------------
command $$spawn_hhp_hitbox(property $hitbox_type, property $x, property $y)
{
	// 各タイプによって生成する当たり判定を変更する
	switch( $hitbox_type ) {
	case(<HHP_HITBOX_TYPE_RADIAL>)		$$spawn_radial_hitbox(front.object[$current_spawn_index], $x, $y, 350)			// 円形
	case(<HHP_HITBOX_TYPE_HORIZONTAL>)	$$spawn_horizontal_hitbox(front.object[$current_spawn_index], $x, $y, 250)		// 水平
	case(<HHP_HITBOX_TYPE_VERTICAL>)	$$spawn_vertical_hitbox(front.object[$current_spawn_index], $x, $y, 250)		// 垂直
	}
	
	front.object[$current_spawn_index].f_type = $hitbox_type
	front.object[$current_spawn_index].f_exists = 1
	front.object[$current_spawn_index].f_hitbox_id = $current_spawn_index
	front.object[$current_spawn_index].f_time = 0
	
	// 次に使用する敵生成インデックスを設定する
	$current_spawn_index += 1
	if( <HHP_OBJ_ATTACK_HITBOX_END> < $current_spawn_index ) {
		$current_spawn_index = <HHP_OBJ_ATTACK_HITBOX_START>
	}
}


//---------------------------------------------------------------------------
// 各当たり判定／初期化する
//---------------------------------------------------------------------------
command $$init_hitbox(property $hitbox_obj : object, property $obj_no)
{
	// ベース／デフォルト画像を読み込んでおく
	$hitbox_obj.create("_mng_df_ef_attack_range")
	
	// フラグ変数
	$hitbox_obj.f.resize(f_flag_max)
}

//---------------------------------------------------------------------------
// 各当たり判定（円形）／生成する
//---------------------------------------------------------------------------
command $$spawn_radial_hitbox(property $hitbox_obj : object, property $x, property $y, property $time_max)
{
	// 円形当たり判定のパラメータを設定する
	$hitbox_obj.change_file("_mng_df_ef_attack_range")
	$hitbox_obj.set_pos($x, $y)
	$hitbox_obj.bright = 128
	$hitbox_obj.tr = 128
	$$set_image_center($hitbox_obj)
	$hitbox_obj.disp = 1
	
	// 当たり判定のパラメータを設定する
	$hitbox_obj.f_time_max = $time_max
}

//---------------------------------------------------------------------------
// 各当たり判定（円形）／更新する
//---------------------------------------------------------------------------
command $$update_radial_hitbox(property $hitbox_obj : object)
{
	property $scale
	
	// 経過時間によって当たり判定のサイズを変更する
	$scale = math.linear($hitbox_obj.f_time, 0, 0, $hitbox_obj.f_time_max, 1000 * ($$get_hhp_player_total_attack_range))
	$hitbox_obj.set_scale($scale, $scale)
	$hitbox_obj.f_rad = $hitbox_obj.get_size_x * $scale / 1000 / 2
}

//---------------------------------------------------------------------------
// 各当たり判定（円形）／敵との当たりをチェックする
//---------------------------------------------------------------------------
command $$check_radial_hitbox(property $hitbox_obj : object, property $enemy_obj : object) : int
{
	property $w
	property $h
	property $cx
	property $cy
	property $dx
	property $dy
	
	$w = $$get_hhp_enemy_w($enemy_obj)
	$h = $$get_hhp_enemy_h($enemy_obj)
	$cx = $hitbox_obj.x - $hitbox_obj.center_x + $hitbox_obj.get_size_x / 2 * (1000 - $hitbox_obj.scale_x) / 1000
	$cy = $hitbox_obj.y - $hitbox_obj.center_y + $hitbox_obj.get_size_y / 2 * (1000 - $hitbox_obj.scale_y) / 1000
	
	$dx = math.max(math.abs($cx + $hitbox_obj.f_rad - ($$get_hhp_enemy_x($enemy_obj) + $w / 2)) - $w / 2, 0)
	$dy = math.max(math.abs($cy + $hitbox_obj.f_rad - ($$get_hhp_enemy_y($enemy_obj) + $h / 2)) - $h / 2, 0)
	
	if( $dx * $dx + $dy * $dy <= $hitbox_obj.f_rad * $hitbox_obj.f_rad )
	{
		return (1)
	}
	
	return(0)
}



command $$spawn_horizontal_hitbox(property $hitbox_obj : object, property $x, property $y, property $time_max)
{
	// 矩形当たり判定のパラメータを設定する
	$hitbox_obj.change_file("__mng_hp_ef_flare01")
	$hitbox_obj.set_pos($x, $y)
	$$set_image_center($hitbox_obj)
	
	// 当たり判定のパラメータを設定する
	$hitbox_obj.f_time_max = $time_max
	
	// エフェクトを生成する
	$$spawn_hhp_effect(<HHP_EF_SLASH_H>, $x, $y, 0)
}

command $$update_horizontal_hitbox(property $hitbox_obj : object)
{
	// 経過時間によって当たり判定のサイズを変更する
	$hitbox_obj.scale_x = math.linear($hitbox_obj.f_time, 0, 0, $hitbox_obj.f_time_max, $hitbox_obj.get_size_x)
}

command $$check_horizontal_hitbox(property $hitbox_obj : object, property $enemy_obj : object) : int
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
	
	$x2 = $hitbox_obj.x - $hitbox_obj.get_size_x * $hitbox_obj.scale_x / 1000 / 2
	$y2 = $hitbox_obj.y - $hitbox_obj.get_size_y * $hitbox_obj.scale_y / 1000 / 2
	$w2 = $hitbox_obj.get_size_x * $hitbox_obj.scale_x / 1000
	$h2 = $hitbox_obj.get_size_y * $hitbox_obj.scale_y / 1000
	
	if( $x1 <= $x2 + $w2 && $x2 <= $x1 + $w1 )
	{
		if( $y1 <= $y2 + $h2 && $y2 <= $y1 + $h1 )
		{
			return (1)
		}
	}
	
	return(0)
}

command $$spawn_vertical_hitbox(property $hitbox_obj : object, property $x, property $y, property $time_max)
{
	// 矩形当たり判定のパラメータを設定する
	$hitbox_obj.change_file("_mng_df_ef_slash02")
	$hitbox_obj.set_pos($x, $y)
	$$set_image_center($hitbox_obj)
	
	// 当たり判定のパラメータを設定する
	$hitbox_obj.f_time_max = $time_max
	
	// エフェクトを生成する
	$$spawn_hhp_effect(<HHP_EF_SLASH_V>, $x, $y, 0)
}

command $$update_vertical_hitbox(property $hitbox_obj : object)
{
	// 経過時間によって当たり判定のサイズを変更する
	$hitbox_obj.scale_y = math.linear($hitbox_obj.f_time, 0, 0, $hitbox_obj.f_time_max, $hitbox_obj.get_size_y)
}

command $$check_vertical_hitbox(property $hitbox_obj : object, property $enemy_obj : object) : int
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
	
	$x2 = $hitbox_obj.x - $hitbox_obj.get_size_x * $hitbox_obj.scale_x / 1000 / 2
	$y2 = $hitbox_obj.y - $hitbox_obj.get_size_y * $hitbox_obj.scale_y / 1000 / 2
	$w2 = $hitbox_obj.get_size_x * $hitbox_obj.scale_x / 1000
	$h2 = $hitbox_obj.get_size_y * $hitbox_obj.scale_y / 1000
	
	if( $x1 <= $x2 + $w2 && $x2 <= $x1 + $w1 )
	{
		if( $y1 <= $y2 + $h2 && $y2 <= $y1 + $h1 )
		{
			return (1)
		}
	}
	
	return(0)
}
