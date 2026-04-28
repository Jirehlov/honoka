//===========================================================================
//!
//!    @file     ___mng_hhp_skill.ss
//!    @brief    ヘビヘビパニックスキルデータ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	#property	$skills : intlist				// 使用可能なスキル
	
	#replace	<SKILL_MIN>					1	// 所持可能なスキル最小数
	#replace	<SKILL_MAX>					3	// 所持可能なスキル最大数
	
	#property	$skill_max						// 所持可能なスキル最大数
	
	#replace	<SKILL_POWER_DEFAULT>		0		// スキルパワー初期値
	#replace	<SKILL_POWER_DEFAULT_MAX>	100		// スキルパワー最大初期値
	
	#property	$skill_power					// スキルパワー(<HHP_ACTIVATE_SKILL_POWER>=100おきにスキル発動可能)
	#property	$skill_power_max				// スキルパワー最大値
	
	#property	$skill_use_count				// スキル使用回数
	
	// 継続回復スキル用
	#property	$skill_cooldown					// スキルの現在のクールタイム
	#property	$skill_cooldown_max				// スキルのクールタイム値
	#property	$skill_counter					// スキルの汎用カウンター
	
#inc_end

#z00

//---------------------------------------------------------------------------
// スキルデータの初期化(初回)
//---------------------------------------------------------------------------
command $$init_hhp_skill_data
{
	$skill_max = 1
	$skills.resize($skill_max)
	$$on_hhp_skill(<HHP_SKILL_ID_SP>)
	$skill_power = <SKILL_POWER_DEFAULT>
	$skill_power_max = <SKILL_POWER_DEFAULT_MAX>
	$skill_use_count = 0
}

//---------------------------------------------------------------------------
// スキルデータの初期化(再ゲーム開始時)
//---------------------------------------------------------------------------
command $$restart_hhp_skill_data
{
	$skill_power = <SKILL_POWER_DEFAULT>
	$skill_cooldown = 0
	$skill_cooldown_max = 0
	$skill_counter = 0
	
	// ４レベルからサポートの人数は２人
	if( $$get_hhp_skill_max == 1 && 4 <= $$get_hhp_play_level )
	{
		$$add_hhp_skill_max(1)
	}
	
	// ７レベルからサポートの人数は３人
	if( $$get_hhp_skill_max == 2 && 7 <= $$get_hhp_play_level )
	{
		$$add_hhp_skill_max(1)
	}
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するイベント
//---------------------------------------------------------------------------
command $$hhp_skill_trigger_on_update
{
	if( $skill_counter <= 0 ) {
		return
	}
	
	$skill_cooldown -= $$get_delta_time
	
	if( $skill_cooldown <= 0 )
	{
		$skill_cooldown = $skill_cooldown_max
		$skill_counter -= 1
		
		// ライフを５回復
		$$add_hhp_player_life(5)
	}
}

//---------------------------------------------------------------------------
// 所持しているスキル数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_skill_count : int
{
	return ($skills.get_size)
}

//---------------------------------------------------------------------------
// インデックスからスキルＩＤを取得する
//---------------------------------------------------------------------------
command $$get_hhp_skill_id_from_index(property $index) : int
{
	return ($skills[$index])
}

//---------------------------------------------------------------------------
// スキルＩＤからインデックスを取得する
//---------------------------------------------------------------------------
command $$get_hhp_skill_index_from_id(property $skill_id) : int
{
	property $i
	property $len
	
	$len = $skills.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $skills[$i] == $skill_id )
		{
			return ($i)
		}
	}
	
	return (-1)
}

//---------------------------------------------------------------------------
// 指定したスキルを所持しているかどうか
//---------------------------------------------------------------------------
command $$has_hhp_skill(property $skill_id) : int
{
	property $i
	property $len
	
	$len = $skills.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $skills[$i] == $skill_id )
		{
			return (1)
		}
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// 指定したスキルを有効／無効にする
//---------------------------------------------------------------------------
command $$on_hhp_skill(property $skill_id)
{
	property $i
	
	if( $$has_hhp_skill($skill_id) ) {
		return
	}
	
	$skills.resize($skills.get_size + 1)
	$skills[$skills.get_size - 1] = $skill_id
	
	while( $skill_max < $skills.get_size )
	{
		for( $i = 0, $i < $skills.get_size - 1, $i += 1 )
		{
			$skills[$i] = $skills[$i + 1]
		}
		
		$skills.resize($skills.get_size - 1)
	}
}

command $$off_hhp_skill(property $skill_id)
{
	property $i
	property $j
	
	for( $i = 0, $i < $skills.get_size, $i += 1 )
	{
		if( $skills[$i] == $skill_id )
		{
			for( $j = $i, $j < $skills.get_size - 1, $j += 1 )
			{
				$skills[$j] = $skills[$j + 1]
			}
			
			$skills.resize($skills.get_size - 1)
		}
	}
}

//---------------------------------------------------------------------------
// 所持可能なスキルの最大数を取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_skill_max : int { return ($skill_max) }
command $$add_hhp_skill_max(property $value) { $skill_max = math.limit(<SKILL_MIN>, $skill_max + $value, <SKILL_MAX>) }

//---------------------------------------------------------------------------
// スキルパワー／最大スキルパワーを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_skill_power : int { return ($skill_power) }
command $$set_hhp_skill_power(property $value) { $skill_power = $value }
command $$add_hhp_skill_power(property $value)
{
	property $skill_power_old
	
	$skill_power_old = $skill_power
	$skill_power = math.limit(0, $skill_power + $value, $skill_power_max)
	
	if( $skill_power_old / <HHP_ACTIVATE_SKILL_POWER> < $skill_power / <HHP_ACTIVATE_SKILL_POWER> ) {
		$$hhp_item_trigger_on_player_skill_power_stock
	}
}

command $$get_hhp_skill_power_max : int { return ($skill_power_max) }
command $$set_hhp_skill_power_max(property $value) { $skill_power_max = $value }
command $$add_hhp_skill_power_max(property $value) { $skill_power_max = math.limit(<SKILL_POWER_DEFAULT_MAX>, $skill_power_max + $value, <HHP_SKILL_POWER_MAX>) }

//---------------------------------------------------------------------------
// スキル使用回数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_skill_use_count : int { return ($skill_use_count) }

//---------------------------------------------------------------------------
// スキル発動時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_skill_trigger_on_activate
{
	property $i
	property $len
	property $skill_id
	
	if( $skills.get_size == 0 )
	{
		$$debug_message("使用可能なスキルが設定されていません。\n処理をスキップします")
		return
	}
	
	// スキル数だけ発生させる
	$len = $$get_hhp_skill_count
	for( $i = 0, $i < $len, $i += 1 )
	{
		$skill_id = $$get_hhp_skill_id_from_index($i)
		
		// スキル使用エフェクトを再生する
		$$play_hhp_skill_effect(front.object[<HHP_OBJ_CUTIN>], $skill_id)
		
		// スキル効果を発動する
		switch( $skill_id ) {
		
		// スピカ
		case(<HHP_SKILL_ID_SP>)
		
			// すべての敵にダメージを与える
			$$damage_hhp_all_enemy($$get_hhp_player_total_attack_power)
			
		// 愛乃
		case(<HHP_SKILL_ID_AI>)
			
			// 無敵を設定する
			$$set_hhp_player_invincible_time(8000)
			
		// 小詠
		case(<HHP_SKILL_ID_KY>)
			
			// すべての敵にスタンを与える
			$$stun_hhp_all_enemy(3000)
			
		// 淡雪
		case(<HHP_SKILL_ID_HI>)
			
			// 反射ダメージ+100%
			$$add_hhp_player_spike_power(100)
			
		// 六花
		case(<HHP_SKILL_ID_RK>)
			
			// 継続回復スキル設定（１秒に１回発動を１０回実行する）
			$skill_counter = 10
			$skill_cooldown_max = 1000
			$skill_cooldown = $skill_cooldown_max
		}
	}
	
	// スキル使用回数を加算する
	$skill_use_count += 1
}
