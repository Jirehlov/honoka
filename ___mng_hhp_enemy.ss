//===========================================================================
//!
//!    @file     ___mng_hhp_enemy.ss
//!    @brief    ヘビヘビパニック敵／レア／ボス共通データ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     ライフ／状態異常／当たり判定などのすべての敵に共通するデータ
//!
//===========================================================================

#z00

//---------------------------------------------------------------------------
// 敵（共通）を初期化する
//---------------------------------------------------------------------------
command $$init_hhp_enemy_base(property $enemy_obj : object)
{
	$enemy_obj.x_rep.resize(2)
	$enemy_obj.y_rep.resize(2)
	
	// 状態異常（描画）を初期化する
	$$init_grp_status_effect($enemy_obj.c_enemy_status_effect)
	
	// エモーションを初期化する
	$$init_grp_emotion($enemy_obj.c_enemy_emotion)
}

//---------------------------------------------------------------------------
// 敵（共通）を更新する
//---------------------------------------------------------------------------
command $$update_hhp_enemy_base(property $enemy_obj : object)
{
	// 状態異常（描画）を更新する
	$$update_grp_status_effect($enemy_obj, $enemy_obj.c_enemy_status_effect)
	
	// エモーションを更新する
	$$update_grp_emotion($enemy_obj, $enemy_obj.c_enemy_emotion)
}

//---------------------------------------------------------------------------
// 敵（共通）にダメージを与える
//---------------------------------------------------------------------------
command $$damage_hhp_enemy_base(property $enemy_obj : object, property $damage)
{
	property $critical
	property $effect_x
	property $effect_y
	
	// クリティカルを判定する
	if( math.rand(0, 99) < $$get_hhp_player_total_critical_rate + $$hhp_item_trigger_on_player_attack_critical_rate_from_enemy($enemy_obj) )
	{
		// クリティカル発生
		$critical = 1
	}
	
	// 敵の状態によってダメージを増減する
	$damage += $$hhp_item_trigger_on_player_attack_power_from_enemy($enemy_obj, $critical)
	
	// クリティカルの場合はクリティカルダメージ倍率を乗算する
	if( $critical ) {
		$damage = $damage * $$get_hhp_player_critical_damage_rate / 100
	}
	
	// ライフを減らす
	$$add_hhp_enemy_life($enemy_obj, -$damage)
	
	// 敵が受けたダメージデータを保存する
	$enemy_obj.f_enemy_damage = $damage
	$enemy_obj.f_enemy_critical_damage = $critical
	$enemy_obj.f_enemy_over_damage = $enemy_obj.f_enemy_life * -1
	
	// プレイヤーの最大ダメージを更新した場合は保存する
	if( $$get_hhp_player_attacked_damage_max < $damage ) {
		$$set_hhp_player_attacked_damage_max($damage)
	}
	
	// プレイヤーのコンボ数を加算する
	$$add_hhp_player_combo(1)
	
	// スキルゲージを加算する
	$$add_hhp_skill_power(math.linear($$get_hhp_player_combo, 0, 1, 99, 10))
	
	// 敵がダメージを受けた際に発生するイベント
	$$hhp_item_trigger_on_enemy_damage($enemy_obj, $critical)
	
	// ライフがなくなった場合
	if( $enemy_obj.f_enemy_life <= 0 )
	{
		// 敵が死亡した際に発生するイベント
		$$hhp_item_trigger_on_enemy_dead($enemy_obj)
	}
	
	// ダメージ表現（光らせる）
	$enemy_obj.bright = 255
	$enemy_obj.bright_eve.set(0, 250, 0, 2)
	
	// ダメージエフェクトを作成する
	$effect_x = $$get_hhp_enemy_x($enemy_obj)
	$effect_y = $$get_hhp_enemy_y($enemy_obj)
	$effect_x = math.rand($effect_x, $effect_x + $$get_hhp_enemy_w($enemy_obj))
	$effect_y = math.rand($effect_y, $effect_y + $$get_hhp_enemy_h($enemy_obj))
	
	// クリティカルダメージエフェクト
	if( $critical )
	{
		@SE_ヘビパ_プレイヤー攻撃_クリティカル
		$$spawn_hhp_effect(<HHP_EF_CRITICAL_DAMAGE>, $effect_x, $effect_y, $damage)
	}
	// 通常ダメージエフェクト
	else
	{
		@SE_ヘビパ_プレイヤー攻撃_通常
		$$spawn_hhp_effect(<HHP_EF_DAMAGE>, $effect_x, $effect_y, $damage)
	}
	
}

//---------------------------------------------------------------------------
// ライフを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_enemy_life(property $enemy_obj : object, property $life_max)
{
	$enemy_obj.f_enemy_life_max = $life_max
	$enemy_obj.f_enemy_life = $enemy_obj.f_enemy_life_max
}

//---------------------------------------------------------------------------
// ライフを加算／減算する
//---------------------------------------------------------------------------
command $$add_hhp_enemy_life(property $enemy_obj : object, property $value)
{
	$enemy_obj.f_enemy_life = math.limit(-<HHP_ATTACK_DAMAGE_MAX>, $enemy_obj.f_enemy_life + $value, $enemy_obj.f_enemy_life_max)
}

//---------------------------------------------------------------------------
// ライフが最大かどうか
//---------------------------------------------------------------------------
command $$is_hhp_enemy_life_max(property $enemy_obj : object)
{
	if( $enemy_obj.f_enemy_life >= $enemy_obj.f_enemy_life_max ) {
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// バフ／デバフを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_enemy_status_effect(property $enemy_obj : object)
{
	$enemy_obj.f_enemy_status_effect = <HHP_ENEMY_STATUS_EFFECT_NONE>
}

//---------------------------------------------------------------------------
// バフ／デバフを設定する
//---------------------------------------------------------------------------
command $$on_hhp_enemy_status_effect(property $enemy_obj : object, property $status_effect_type)
{
	$enemy_obj.f_enemy_status_effect |= (1 << $status_effect_type)
}

//---------------------------------------------------------------------------
// バフ／デバフを解除する
//---------------------------------------------------------------------------
command $$off_hhp_enemy_status_effect(property $enemy_obj : object, property $status_effect_type)
{
	$enemy_obj.f_enemy_status_effect &= ~(1 << $status_effect_type)
}

//---------------------------------------------------------------------------
// 指定したバフ／デバフ状態かどうか
//---------------------------------------------------------------------------
command $$has_hhp_enemy_status_effect(property $enemy_obj : object, property $status_effect_type) : int
{
	return ($enemy_obj.f_enemy_status_effect & (1 << $status_effect_type))
}

//---------------------------------------------------------------------------
// 何らかのバフ／デバフ状態かどうか
//---------------------------------------------------------------------------
command $$has_hhp_enemy_any_status_effect(property $enemy_obj : object) : int
{
	if( $enemy_obj.f_enemy_status_effect ) {
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// 発生しているバフ／デバフの数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_status_effect_count(property $enemy_obj : object) : int
{
	property $i
	property $count
	
	for( $i = 1, $i < <HHP_ENEMY_STATUS_EFFECT_MAX>, $i += 1 )
	{
		if( $$has_hhp_enemy_status_effect($enemy_obj, $i) )
		{
			$count += 1
		}
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// 当たり判定格納データを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_enemy_hitbox(property $enemy_obj : object)
{
	property $i
	
	$enemy_obj.f_enemy_hitbox_index = <HHP_HITBOX_FLAG_START>
	
	for( $i = <HHP_HITBOX_FLAG_START>, $i <= <HHP_HITBOX_FLAG_END>, $i += 1 )
	{
		$enemy_obj.f[$i] = 0
	}
}

//---------------------------------------------------------------------------
// 指定した当たり判定ＩＤにすでに持っているか
//---------------------------------------------------------------------------
command $$has_hhp_enemy_hitbox_id(property $enemy_obj : object, property $hitbox_id) : int
{
	property $i
	
	for( $i = <HHP_HITBOX_FLAG_START>, $i <= <HHP_HITBOX_FLAG_END>, $i += 1 )
	{
		if( $enemy_obj.f[$i] == $hitbox_id ) {
			return (1)
		}
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// 当たり判定ＩＤを格納する
//---------------------------------------------------------------------------
command $$set_hhp_enemy_hitbox_id(property $enemy_obj : object, property $hitbox_id)
{
	$enemy_obj.f[$enemy_obj.f_enemy_hitbox_index] = $hitbox_id
	
	$enemy_obj.f_enemy_hitbox_index += 1
	if( $enemy_obj.f_enemy_hitbox_index > <HHP_HITBOX_FLAG_END> ) {
		$enemy_obj.f_enemy_hitbox_index = <HHP_HITBOX_FLAG_START>
	}
}

//---------------------------------------------------------------------------
// 敵の座標(x)を取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_x(property $enemy_obj : object) : int
{
	property $x
	
	$x = $enemy_obj.c_enemy_image.x - $enemy_obj.c_enemy_image.center_x + $enemy_obj.c_enemy_image.get_size_x / 2 * (1000 - $enemy_obj.scale_x) / 1000
	$x += $enemy_obj.x + $enemy_obj.x_rep[0] + $enemy_obj.x_rep[1]
	
	return ($x)
}

//---------------------------------------------------------------------------
// 敵の座標(y)を取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_y(property $enemy_obj : object) : int
{
	property $y
	
	$y = $enemy_obj.c_enemy_image.y - $enemy_obj.c_enemy_image.center_y + $enemy_obj.c_enemy_image.get_size_y / 2 * (1000 - $enemy_obj.scale_y) / 1000
	$y += $enemy_obj.y + $enemy_obj.y_rep[0] + $enemy_obj.y_rep[1]
	
	return ($y)
}

//---------------------------------------------------------------------------
//  敵のサイズ(w)を取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_w(property $enemy_obj : object) : int
{
	property $w
	
	$w = $enemy_obj.c_enemy_image.get_size_x * $enemy_obj.scale_x / 1000
	
	return ($w)
}

//---------------------------------------------------------------------------
//  敵のサイズ(h)を取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_h(property $enemy_obj : object) : int
{
	property $h
	
	$h = $enemy_obj.c_enemy_image.get_size_y * $enemy_obj.scale_y / 1000
	
	return ($h)
}

//---------------------------------------------------------------------------
//  状態異常（描画）を初期化する
//---------------------------------------------------------------------------
command $$init_grp_status_effect(property $effect_obj : object)
{
	$effect_obj.disp = 1
	$effect_obj.child.resize(<HHP_ENEMY_STATUS_EFFECT_MAX>)
	
	// シールド
	$effect_obj.child[0].create(_mng_ur_st_effect02, 0, 0, 0, 1)
	$$set_image_center($effect_obj.child[0])
	$effect_obj.child[0].set_scale(3000, 3000)
	$effect_obj.child[0].blend = 4
	$effect_obj.child[0].bright_eve.turn(0, 128, 1000, 0, 2)
	
	// スロウ
	$effect_obj.child[1].create(_mng_df_enemy_slow, 0, 0, 0)
	
	// 興奮
	$effect_obj.child[2].create_string("EXCITED", 0)
	$effect_obj.child[2].set_string_param(30, 0, 0, 10, 0, 0, 2, 1)
	
	// 怒り
	$effect_obj.child[3].create_string("ANGRY", 0)
	$effect_obj.child[3].set_string_param(30, 0, 0, 10, 0, 0, 2, 1)
	
	// 石化 todo
}

//---------------------------------------------------------------------------
//  状態異常（描画）を更新する
//---------------------------------------------------------------------------
command $$update_grp_status_effect(property $enemy_obj : object, property $effect_obj : object)
{
	// シールド
	$effect_obj.child[0].disp = $enemy_obj.f_enemy_shield
	
	// スロウ
	$effect_obj.child[1].disp = $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_SLOW>)
	
	// 興奮
	$effect_obj.child[2].disp = $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_EXCITED>)
	
	// 怒り
	$effect_obj.child[3].disp = $$has_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_ANGRY>)
}

//---------------------------------------------------------------------------
//  エモーション（描画）を初期化する
//---------------------------------------------------------------------------
command $$init_grp_emotion(property $effect_obj : object)
{
	$effect_obj.disp = 1
	$effect_obj.child.resize(2)
	
	// 汗
	if( math.rand(0, 1) )
	{
		$effect_obj.child[0].create(_mng_ur_st_effect01, 0, 0, -100)
		$effect_obj.child[0].set_scale(2000, 2000)
	}
	else
	{
		$effect_obj.child[0].create(_mng_ur_st_effect01, 0, -100, -100)
		$effect_obj.child[0].set_scale(-2000, 2000)
	}
	$effect_obj.child[0].patno_eve.loop(0, 2, 1000, 0, 0)
	
	// ピヨリ
	$effect_obj.child[1].disp = 0
	$effect_obj.child[1].child.resize(2)
	$effect_obj.child[1].child[0].create(_mng_ur_pt_effect04, 1, -100, -150)
	$effect_obj.child[1].child[1].create(_mng_ur_pt_effect04, 1,  100, -150)
	$effect_obj.child[1].child[0].x_eve.loop(-100, 100, 350, 0, 2)
	$effect_obj.child[1].child[1].x_eve.loop(100, -100, 350, 0, 2)
}

//---------------------------------------------------------------------------
//  エモーション（描画）を更新する
//---------------------------------------------------------------------------
command $$update_grp_emotion(property $enemy_obj : object,  property $effect_obj : object)
{
}
