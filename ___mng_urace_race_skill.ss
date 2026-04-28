//===========================================================================
//!
//!    @file     ___mng_urace_race_skill.ss
//!    @brief    ＵＭＡレース／スキル管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     各スキルデータを管理する
//!
//===========================================================================

























//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// ＵＭＡスキルデータ
	#property	$active_skill_id : intlist[<URACE_ENTRY_MAX>]		// 発動中のスキルID
	#property	$active_skill_time : intlist[<URACE_ENTRY_MAX>]		// 発動中のスキルの継続時間
	#property	$active_skill_target : intlist						// 発動中のスキルのターゲット
	
	#property	$uma_skill_cool_down_rate : intlist[<URACE_ENTRY_MAX>]
	
	#property	$after : intlist[<URACE_ENTRY_MAX>]
	
	// 各スキルデータ
	#property	$uma_skill_id : intlist				// 所持スキルID
	#property	$uma_skill_cool_down : intlist		// 所持スキルのクールタイム
	#property	$uma_skill_enable : intlist			// 所持スキルの有効／無効
	
#inc_end

#z00

//---------------------------------------------------------------------------
// レースデータ(スキル)の初期化
//---------------------------------------------------------------------------
command $$init_urace_race_skill_data
{
	$active_skill_id.init
	$active_skill_time.init
	$active_skill_target.init
	$active_skill_target.resize(<URACE_ENTRY_MAX> * <URACE_ENTRY_MAX>)
	
	$uma_skill_cool_down_rate.init
	
	$uma_skill_id.init
	$uma_skill_id.resize(<URACE_ENTRY_MAX>)
	$uma_skill_cool_down.init
	$uma_skill_cool_down.resize(<URACE_ENTRY_MAX>)
	$uma_skill_enable.init
	$uma_skill_enable.resize(<URACE_ENTRY_MAX>)
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのスキルを初期化する
//---------------------------------------------------------------------------
command $$init_running_uma_skill(property $lane_index)
{
	property $i
	property $skill_id
	
	// 発動中のスキルを初期化
	$active_skill_id[$lane_index] = 0
	$active_skill_time[$lane_index] = 0
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		$$set_running_uma_active_skill_target($lane_index, $i, -1)
	}
	
	// クールダウン倍率を幸運の値から設定する
	$uma_skill_cool_down_rate[$lane_index] = math.linear($$get_running_uma_accel($lane_index), <UMA_PARAM_MIN>, 100, <UMA_PARAM_MAX>, 50)
	
	// 所持スキルの設定をする
	$skill_id = $$get_db_uma_skill_id($$get_uma_id($$get_entry_owner_id($lane_index), $$get_entry_uma_index($lane_index)))
	
	if( $skill_id == 0 ) {
		return
	}
	
	// 発動条件をチェックする、条件を満たしていない場合は所持スキルとして追加しない
	switch( $$get_db_skill_filter($skill_id) ) {
	
	case(<UMA_SKILL_FILTER_HEROINE>)		// レースにヒロインがいるとき
		
		if( $$get_entry_pure_owner_num == 0 ) {
			return
		}
		/*
	case(<UMA_SKILL_FILTER_TURF>)			// レース地形が芝のとき
		
		if( $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_TURF> && $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_SPACE> ) {
			continue
		}
		
	case(<UMA_SKILL_FILTER_DIRT>)			// レース地形がダートのとき
		
		if( $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_DIRT> && $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_SPACE> ) {
			continue
		}
		
	case(<UMA_SKILL_FILTER_SURFACE>)		// レース地形が水面のとき
		
		if( $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_SURFACE> && $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_SPACE> ) {
			continue
		}
		*/
	}
	
	$$set_running_uma_skill_cool_down($lane_index, $$get_db_skill_start_time($skill_id) * $uma_skill_cool_down_rate[$lane_index] / 100)
	$$set_running_uma_skill_enable($lane_index, 1)
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのスキルを更新する
//---------------------------------------------------------------------------
command $$update_running_uma_skill(property $lane_index)
{
	property $skill_id
	property $enable_skill_list : intlist
	
	// 各スキルのクールダウンを行う
	$skill_id = $$get_running_uma_skill_id($lane_index)
	
	if( $skill_id == 0 ) {
		return
	}
	
	// 各スキルのクールタイムを減らす
	$$set_running_uma_skill_cool_down($lane_index, $$get_running_uma_skill_cool_down($lane_index) - $$get_delta_time)
	
	// クールタイムをチェックする
	if( $$get_running_uma_skill_cool_down($lane_index) > 0 ) {
		return
	}
	
	// クールタイムを元に戻す
	$$set_running_uma_skill_cool_down($lane_index, $$get_db_skill_cool_time($skill_id) * $uma_skill_cool_down_rate[$lane_index] / 100)
	
	// 各スキルの使用が有効かチェックする
	if( $$get_running_uma_skill_enable($lane_index) == 0 ) {
		return
	}
	
	// 発動条件をチェックする
	switch( $$get_db_skill_filter($skill_id) ) {
	
	case(<UMA_SKILL_FILTER_NOT_TOP>)		// 自分が先頭ではない
		
		if( $lane_index == $$get_top_lane_index ) {
			return
		}
		
	case(<UMA_SKILL_FILTER_ENEMY_NEAR>)		// 敵が近い
		
		if( $$is_enemy_nearby($lane_index, 30000) == 0 ) {
			return
		}
		
	case(<UMA_SKILL_FILTER_ENEMY_NEAR_AHEAD>)	// 敵が近い・自分より前
		
		if( $$is_enemy_front_of($lane_index, 30000) == 0 ) {
			return
		}
		
	case(<UMA_SKILL_FILTER_ENEMY_NEAR_BEHIND>)	// 敵が近い・自分より後ろ
		
		if( $$is_enemy_behind($lane_index, 30000) == 0 ) {
			return
		}
		
	// レースにヒロインがいるときの場合は、初期化時にスキルとして追加していないので発生しない
	// case(<UMA_SKILL_FILTER_HEROINE>)
	}
	
	// ここまでクリアすれば使用可能なスキルとして追加する
	$enable_skill_list.resize($enable_skill_list.get_size + 1)
	$enable_skill_list[$enable_skill_list.get_size - 1] = $skill_id
	
	// スキルを使用中の場合はスキルの継続時間を計算する
	if( $active_skill_id[$lane_index] != 0 )
	{
		$active_skill_time[$lane_index] -= $$get_delta_time
		
		// 継続時間を超過した場合
		if( $active_skill_time[$lane_index] < 0 )
		{
			// 発動中のスキルを停止する
			$$deactivate_running_uma_skill($lane_index)
		}
		
		return
	}
	
	/*
	// 使用可能なスキルがない場合は終了する
	if( $enable_skill_list.get_size == 0 ) {
		return
	}
	
	// スキルの使用可能状態を調べる
	if( $$is_running_uma_active_skill_available($lane_index) != 1 )
	{
		// スキル使用可能ではないので終了する
		return
	}
	
	// 使用可能なスキルリストから使用するスキルを選択する
	$skill_id = $enable_skill_list[$$mng_rand(0, $enable_skill_list.get_size - 1)]
	
	$after[$lane_index] = 0
	if( $$get_db_skill_type($skill_id) != <UMA_SKILL_TYPE_EVASION> ) {
		$after[$lane_index] = $skill_id
	}
	
	if( $after[$lane_index] == 0 )
	{
		// スキルを発動する
		$$activate_running_uma_skill($lane_index, $skill_id)
	}
	*/
}

command $$update_running_uma_skill_after(property $lane_index)
{
	if( $after[$lane_index] )
	{
		// スキルを発動する
		$$activate_running_uma_skill($lane_index, $after[$lane_index], 0)
		
		$after[$lane_index] = 0
	}
}

//---------------------------------------------------------------------------
// 指定したスキルを発動する
//---------------------------------------------------------------------------
command $$activate_running_uma_skill(property $lane_index, property $skill_id, property $deb)
{
	property $i
	property $j
	property $len
	property $time
	property $delay_time
	property $target_list : intlist
	property $type
	property $amount
	property $buff_type
	property $ramdom_enemy_index
	
	//2
	if( $skill_id == 59 ) {
		$$set_entry_race_ground_type(<URACE_GROUND_TYPE_SURFACE>)
		$$add_entry_owner_skill_power($lane_index, -<UMA_SKILL_CONSUMED_TENSION> * 1000)
		return
	}
	if( $skill_id == 32 ) {
		$skill_id = math.rand(1, 31)
	}
	if( $skill_id == 13 ) {
		$skill_id = math.rand(1, 3)
	}
	//2
	// スキルデータを取得する
	$time = $$get_db_skill_time($skill_id)
	$delay_time = $$get_db_skill_delay_time($skill_id)
	
	// スキルターゲットを初期化する
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$set_running_uma_active_skill_target($lane_index, $i, -1)
	}
	$ramdom_enemy_index = -1
	
	// 各スキルの効果を設定する
	for( $i = 0, $i < <DB_SKILL_EFFECT_SLOT_MAX>, $i += 1 )
	{
		// スキル効果の目標を設定する
		$target_list.init
		
		switch( $$get_db_skill_effect_target($skill_id, $i) ) {
			
		case(<UMA_SKILL_TARGET_SELF>)			// スキルの発動者
			
			$target_list.resize(1)
			$target_list[0] = $lane_index
			
		case(<UMA_SKILL_TARGET_RAND_ENEMY>)		// ランダムな敵
			
			// ランダムな敵がまだ設定されていない場合は設定する
			if( $ramdom_enemy_index == -1 )
			{
				for( $j = 0, $j < $len, $j += 1 )
				{
					if( $$check_enemy_target($lane_index, $j, $skill_id) == 0 ) {
						continue
					}
					
					$target_list.resize($target_list.get_size + 1)
					$target_list[$target_list.get_size - 1] = $j
					
					if( $target_list.get_size == 0 ) {
						continue
					}
					
					$ramdom_enemy_index = $target_list[$$mng_rand(0, $target_list.get_size - 1)]
					$target_list[0] = $ramdom_enemy_index
					$target_list.resize(1)
					
					system.debug_write_log("★$ランダム敵index=" + math.tostr($ramdom_enemy_index))
				}
			}
			else
			{
				$target_list.resize(1)
				$target_list[0] = $ramdom_enemy_index
			}
			
		case(<UMA_SKILL_TARGET_TOP_ENEMY>)		// 先頭の敵
			
			// 旧版（自身を含めて先頭を取得し、自身以外ならターゲットに追加）
			//$ramdom_enemy_index = $$get_top_lane_index
			//
			//if( $lane_index != $ramdom_enemy_index )
			//{
			//	$target_list.resize(1)
			//	$target_list[0] = $ramdom_enemy_index
			//}
			
			// 新版（自身を除外して先頭を取得し、有効であればターゲットに追加）
			$ramdom_enemy_index = $$get_top_lane_index_except($lane_index)
			
			if( $ramdom_enemy_index != -1 )
			{
				$target_list.resize(1)
				$target_list[0] = $ramdom_enemy_index
			}
			
			system.debug_write_log("★$先頭敵index=" + math.tostr($ramdom_enemy_index))
			
		case(<UMA_SKILL_TARGET_ALL_ENEMY>)		// 敵全員
			
			for( $j = 0, $j < $len, $j += 1 )
			{
				if( $$check_enemy_target($lane_index, $j, $skill_id) == 0 ) {
					continue
				}
				
				$target_list.resize($target_list.get_size + 1)
				$target_list[$target_list.get_size - 1] = $j
			}
		}
		
		// スキル効果を取得する
		$type = $$get_db_skill_effect_type($skill_id, $i)
		$amount = $$get_db_skill_effect_amount($skill_id, $i)
		
		// タイプ別に処理を行う
		switch( $type ) {
		case(<UMA_SKILL_EFFECT_TYPE_CONST_SPEED>)		$buff_type = <RUNNING_UMA_BUFF_TYPE_CONST_SPEED_MAX>	// 最大スピード(固定値)
		case(<UMA_SKILL_EFFECT_TYPE_REDUCE_SPEED>)		$buff_type = <RUNNING_UMA_BUFF_TYPE_REDUCE_SPEED_MAX>	// 最大スピード(徐々に減少)
		case(<UMA_SKILL_EFFECT_TYPE_ACCEL>)				$buff_type = <RUNNING_UMA_BUFF_TYPE_ACCEL>				// 加速力補正
		//case(<UMA_SKILL_EFFECT_TYPE_STAMINA>)			$buff_type = <RUNNING_UMA_BUFF_TYPE_STAMINA>			// スタミナ補正
		case(<UMA_SKILL_EFFECT_TYPE_HP>)				$buff_type = 0											// HP変動
		case(<UMA_SKILL_EFFECT_TYPE_HP_DRAIN>)			$buff_type = 0											// HP吸収
		case(<UMA_SKILL_EFFECT_TYPE_HIDE_MODE>)			$buff_type = <RUNNING_UMA_BUFF_TYPE_HIDE_MODE>			// 潜伏モード
		case(<UMA_SKILL_EFFECT_TYPE_INTERRUPT_BLOCK>)	$buff_type = <RUNNING_UMA_BUFF_TYPE_INTERRUPT_BLOCK>	// 妨害無効
		case(<UMA_SKILL_EFFECT_TYPE_TRAP_BLOCK>)		$buff_type = <RUNNING_UMA_BUFF_TYPE_TRAP_BLOCK>			// 障害物無効
		case(<UMA_SKILL_EFFECT_TYPE_REVERSE_RUN>)		$buff_type = <RUNNING_UMA_BUFF_TYPE_REVERSE_RUN>		// 逆走
		case(<UMA_SKILL_EFFECT_TYPE_STUN>)				$buff_type = <RUNNING_UMA_BUFF_TYPE_STUN>				// 気絶・スタン
		case(<UMA_SKILL_EFFECT_TYPE_GROUND_AFFINITY>)	$buff_type = <RUNNING_UMA_BUFF_TYPE_GROUND_AFFINITY>	// 地形適性
		case(<UMA_SKILL_EFFECT_TYPE_SKILL_SEAL>)		$buff_type = <RUNNING_UMA_BUFF_TYPE_SKILL_SEAL>			// スキル封印
		case(<UMA_SKILL_EFFECT_TYPE_ITEM_SEAL>)			$buff_type = <RUNNING_UMA_BUFF_TYPE_ITEM_SEAL>			// アイテム封印
		case(<UMA_SKILL_EFFECT_TYPE_STONE>)				$buff_type = <RUNNING_UMA_BUFF_TYPE_STONE>				// 石化
		}
		
		// すべてのターゲットにバフ／デバフを追加する
		for( $j = 0, $j < $target_list.get_size, $j += 1 )
		{
			// 旧
			//if( $$get_db_skill_type($skill_id) == <UMA_SKILL_TYPE_INTERRUPT> && $$get_running_uma_buff_interrupt_block($target_list[$j]) )
			//{
			//	$$set_running_uma_block_flag($target_list[$j], 1)
			//}
			//else
			//{
			//	$$add_running_uma_buff($target_list[$j], $lane_index, $skill_id, $buff_type, $time, $amount, $delay_time)
			//}
			
			// ---- HP変動 ----
			if( $type == <UMA_SKILL_EFFECT_TYPE_HP> )
			{
				// マイナスなら与ダメ
				if( $amount < 0 ) { $$take_damage_uma($target_list[$j], $amount * -1) }
				else { $$heal_damage_uma($target_list[$j], $amount) }
			}
			// ---- HPドレイン ----
			elseif( $type == <UMA_SKILL_EFFECT_TYPE_HP_DRAIN> )
			{
				$$drain_damage_uma($lane_index, $target_list[$j], $amount, <URACE_DAMAGE_TYPE_SKILL>)
			}
			// ---- バフ系スキル処理 ----
			elseif( $buff_type != 0 )
			{
				if( $$get_db_skill_type($skill_id) == <UMA_SKILL_TYPE_INTERRUPT> && $$get_running_uma_buff_interrupt_block($target_list[$j]) )
				{
					$$set_running_uma_block_flag($target_list[$j], 1)
				}
				else
				{
					$$add_running_uma_buff($target_list[$j], $lane_index, $skill_id, $buff_type, $time, $amount, $delay_time)
				}
			}
		}
		
		
		if( $$get_db_skill_effect_target($skill_id, $i) != <UMA_SKILL_TARGET_SELF> )
		{
			if( $$get_running_uma_active_skill_target($lane_index, $i) == -1 )
			{
				for( $j = 0, $j < $target_list.get_size, $j += 1 )
				{
					$$set_running_uma_active_skill_target($lane_index, $j, $target_list[$j])
				}
			}
		}
		
		// ターゲットがフィールドかつ効果タイプが地形変更
		if( $$get_db_skill_effect_target($skill_id, $i) ==  <UMA_SKILL_TARGET_FIELD> &&  $type == <UMA_SKILL_EFFECT_TYPE_GROUND>)
		{
			$$set_entry_race_ground_type($amount)
		}
	}
	
	// 発動中スキルの値を設定する
	$active_skill_id[$lane_index] = $skill_id
	$active_skill_time[$lane_index] = $$get_db_skill_time($skill_id) + $$get_db_skill_delay_time($skill_id)
	
	// テンションゲージを減らす
	if( $deb == 0 ) {
		$$add_entry_owner_skill_power($lane_index, -<UMA_SKILL_CONSUMED_TENSION> * 1000)
	}
	
	// レースにヒロインがいる条件の場合は特殊なボイストリガーを発行する
	if( $$get_db_skill_filter($skill_id) == <UMA_SKILL_FILTER_HEROINE> )
	{
		// えり好み系が発生したとき
		if( $skill_id == @スキル_えり好み )
		{
			if( $$get_entry_pure_owner_num > 0 )
			{
				$i = math.rand(0, $$get_entry_pure_owner_num - 1)
				$i = $$get_index_from_entry_owner_list($$get_entry_pure_owner_id($i))
				
				$$set_entry_owner_voice_trigger($i, <OWNER_VOICE_TRIGGER_UNICORN>)
			}
		}
	}
	;$uma_skill_cool_down[$lane_index] = $$get_db_skill_cool_time($skill_id)
	;
	;pcmch[0].play(_mng_se_test01)
	;
	;$owner_voice_trigger[$lane_index] = <OWNER_VOICE_TRIGGER_SKILL>
}

//---------------------------------------------------------------------------
// スキルの発動を停止する
//---------------------------------------------------------------------------
command $$deactivate_running_uma_skill(property $lane_index)
{
	property $i
	property $target_index
	
	// スキルの効果を設定する
	for( $i = 0, $i < <DB_SKILL_EFFECT_SLOT_MAX>, $i += 1 )
	{
		// バフ／デバフを削除する
		$$del_running_uma_buff($lane_index, $active_skill_id[$lane_index])
	}
	
	// 発動中スキルの値を初期化する
	$active_skill_id[$lane_index] = 0
	$active_skill_time[$lane_index] = 0
}

//---------------------------------------------------------------------------
// スキルが使用可能かどうか
//---------------------------------------------------------------------------
command $$is_running_uma_active_skill_available(property $lane_index) : int
{
	// スタート／走り状態以外は使用不可
	if( $$get_running_uma_action_state($lane_index) != <RUNNING_UMA_ACTION_STATE_START> &&
		$$get_running_uma_action_state($lane_index) != <RUNNING_UMA_ACTION_STATE_RUN> ) {
		return (-1)
	}
	
	// テンションゲージが溜まっていない場合は不可
	if( $$get_entry_owner_skill_power($lane_index) / 100 / 100 < 1 ) {
		return (-2)
	}
	
	// スキル使用中は不可
	if( $active_skill_id[$lane_index] != 0 ) {
		return (-3)
	}
	
	// 逆走中は不可
	if( $$get_running_uma_buff_reverse_run($lane_index) ) {
		return (-4)
	}
	
	// ジャンプ中は不可
	if( $$get_running_uma_jump_power($lane_index) != 0 )
	{
		return (-6)
	}
	
	// スキル封印中は不可
	if( $$get_running_uma_buff_skill_seal($lane_index) > 0 )
	{
		return (-7)
	}
	
	return (1)
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの発動中のスキルIDを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_active_skill_id(property $lane_index) : int
{
	return ($active_skill_id[$lane_index])
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの発動中のスキル時間を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_active_skill_time(property $lane_index) : int
{
	return ($active_skill_time[$lane_index])
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの発動中のスキルターゲットを取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_active_skill_target(property $lane_index, property $target_index) : int
{
	return ($active_skill_target[$lane_index * <URACE_ENTRY_MAX> + $target_index])
}

command $$set_running_uma_active_skill_target(property $lane_index, property $target_index, property $target_lane_index)
{
	$active_skill_target[$lane_index * <URACE_ENTRY_MAX> + $target_index] = $target_lane_index
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのスキルクールダウン倍率を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_skill_cool_down_rate(property $lane_index) : int
{
	return ($uma_skill_cool_down_rate[$lane_index])
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのスキルIDを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_skill_id(property $lane_index) : int
{
	return ($$get_db_uma_skill_id($$get_running_uma_id($lane_index)))
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのスキルクールタイムを取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_skill_cool_down(property $lane_index) : int
{
	return ($uma_skill_cool_down[$lane_index])
}

command $$set_running_uma_skill_cool_down(property $lane_index, property $time)
{
	$uma_skill_cool_down[$lane_index] = $time
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのスキル有効／無効を取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_skill_enable(property $lane_index) : int
{
	return ($uma_skill_enable[$lane_index])
}

command $$set_running_uma_skill_enable(property $lane_index, property $enable) : int
{
	$uma_skill_enable[$lane_index] = $enable
}




command $$check_enemy_target(property $lane_index, property $target_lane_index, property $skill_id)
{
	// 指定したレーンが自身のレーンのとき
	if( $lane_index == $target_lane_index )
	{
		return (0)
	}
	
	// 指定したレーンがゴールしているとき
	if( $$get_entry_owner_goal_order($target_lane_index) != 0 )
	{
		return (0)
	}
	
	switch( $$get_db_skill_filter($skill_id) ) {
	
	// 敵が近い
	case(<UMA_SKILL_FILTER_ENEMY_NEAR>)
		
		if( math.abs($$get_entry_owner_mileage($lane_index) - $$get_entry_owner_mileage($target_lane_index)) >= 30000 )
		{
			return (0)
		}
		
	// 敵が近い・自分より前
	case(<UMA_SKILL_FILTER_ENEMY_NEAR_AHEAD>)
		
		if( $$get_entry_owner_mileage($lane_index) >= $$get_entry_owner_mileage($target_lane_index) )
		{
			return (0)
		}
		
		if( math.abs($$get_entry_owner_mileage($lane_index) - $$get_entry_owner_mileage($target_lane_index)) >= 30000 )
		{
			return (0)
		}
		
	// 敵が近い・自分より後ろ
	case(<UMA_SKILL_FILTER_ENEMY_NEAR_BEHIND>)
		
		if( $$get_entry_owner_mileage($lane_index) < $$get_entry_owner_mileage($target_lane_index) )
		{
			return (0)
		}
		
		if( math.abs($$get_entry_owner_mileage($lane_index) - $$get_entry_owner_mileage($target_lane_index)) >= 30000 )
		{
			return (0)
		}
	}
	
	return (1)
}

command $$get_top_lane_index : int
{
	property $i
	property $top_mileage
	property $top_lane
	
	for( $i = 0, $i < $$get_entry_owner_num, $i += 1 )
	{
		if( $$get_entry_owner_goal_order($i) != 0 ) {
			continue
		}
		
		if( $top_mileage < $$get_entry_owner_mileage($i) )
		{
			$top_mileage = $$get_entry_owner_mileage($i)
			$top_lane = $i
		}
	}
	
	return ($top_lane)
}

//---------------------------------------------------------------------------
// 先頭の敵レーンインデックスを取得（実行者を除外）
//---------------------------------------------------------------------------
command $$get_top_lane_index_except(property $exclude_lane_index) : int
{
	property $i
	property $top_mileage
	property $top_lane

	$top_lane = -1  // 初期値: 該当者なし

	for( $i = 0, $i < $$get_entry_owner_num, $i += 1 )
	{
		// 実行者自身は除外
		if( $i == $exclude_lane_index ) {
			continue
		}

		// ゴール済みは除外
		if( $$get_entry_owner_goal_order($i) != 0 ) {
			continue
		}

		// 最も走行距離が長い敵を探す
		if( $top_mileage < $$get_entry_owner_mileage($i) )
		{
			$top_mileage = $$get_entry_owner_mileage($i)
			$top_lane = $i
		}
	}

	return ($top_lane)
}

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
command $$is_enemy_nearby(property $lane_index, property $distance)
{
	property $i
	
	for( $i = 0, $i < $$get_entry_owner_num, $i += 1 )
	{
		if( $i == $lane_index ) {
			continue
		}
		
		if( $$get_entry_owner_goal_order($i) != 0 ) {
			continue
		}
		
		if( math.abs($$get_entry_owner_mileage($lane_index) - $$get_entry_owner_mileage($i)) >= $distance ) {
			continue
		}
		
		return (1)
	}
	
	return (0)
}

command $$is_enemy_behind(property $lane_index, property $distance)
{
	property $i
	
	for( $i = 0, $i < $$get_entry_owner_num, $i += 1 )
	{
		if( $i == $lane_index ) {
			continue
		}
		
		if( $$get_entry_owner_goal_order($i) != 0 ) {
			continue
		}
		
		if( $$get_entry_owner_mileage($lane_index) < $$get_entry_owner_mileage($i) ) {
			continue
		}
		
		if( $$get_entry_owner_mileage($lane_index) - $$get_entry_owner_mileage($i) > $distance ) {
			continue
		}
		
		return (1)
	}
	
	return (0)
}

command $$is_enemy_front_of(property $lane_index, property $distance)
{
	property $i
	
	for( $i = 0, $i < $$get_entry_owner_num, $i += 1 )
	{
		if( $i == $lane_index ) {
			continue
		}
		
		if( $$get_entry_owner_goal_order($i) != 0 ) {
			continue
		}
		
		if( $$get_entry_owner_mileage($lane_index) >= $$get_entry_owner_mileage($i) ) {
			continue
		}
		
		if( $$get_entry_owner_mileage($i) - $$get_entry_owner_mileage($lane_index) > $distance ) {
			continue
		}
		
		return (1)
	}
	
	return (0)
}
