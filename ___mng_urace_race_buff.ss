//===========================================================================
//!
//!    @file     ___mng_urace_race_buff.ss
//!    @brief    ＵＭＡレースバフ／デバフ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     すべてのバフ／デバフを一つの配列で管理する
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// ＵＭＡバフ／デバフ補正データ
	#property	$uma_buff_speed_max : intlist[<URACE_ENTRY_MAX>]			// 最大スピード
	#property	$uma_buff_accel : intlist[<URACE_ENTRY_MAX>]				// 加速力
	#property	$uma_buff_stamina : intlist[<URACE_ENTRY_MAX>]				// スタミナ
	#property	$uma_buff_interrupt_block : intlist[<URACE_ENTRY_MAX>]		// 妨害無効
	#property	$uma_buff_trap_block : intlist[<URACE_ENTRY_MAX>]			// 障害物無効
	#property	$uma_buff_reverse_run : intlist[<URACE_ENTRY_MAX>]			// 逆走
	#property	$uma_buff_hide_mode_float : intlist[<URACE_ENTRY_MAX>]		// 潜伏モード(浮遊)
	#property	$uma_buff_hide_mode_dive : intlist[<URACE_ENTRY_MAX>]		// 潜伏モード(潜る)
	#property	$uma_buff_ground_affinity : intlist[<URACE_ENTRY_MAX>]		// 地形適性アップ
	#property	$uma_buff_skill_seal : intlist[<URACE_ENTRY_MAX>]			// スキル封印
	#property	$uma_buff_item_seal : intlist[<URACE_ENTRY_MAX>]			// アイテム封印
	
	// バフ／デバフデータ
	#property	$buff_num : intlist[<URACE_ENTRY_MAX>]		// 各ＵＭＡごとに発生しているバフ／デバフの数
	
	#property	$buff_type : intlist				// バフ／デバフの種類
	#property	$buff_target : intlist				// バフ／デバフを発生させたＵＭＡインデックス
	#property	$buff_amount : intlist				// バフ／デバフの効果量
	#property	$buff_amount_max : intlist			// バフ／デバフの最大効果量
	#property	$buff_time : intlist				// バフ／デバフの効果時間
	#property	$buff_time_max : intlist			// バフ／デバフの効果最大時間
	#property	$buff_delay_time : intlist			// バフ／デバフのディレイ時間
	#property	$buff_delay_time_max : intlist		// バフ／デバフのディレイ最大時間
	#property	$buff_source_projectile_id : intlist	// バフの発生源projectile ID (0=projectile以外)
	#property	$buff_one_shot : intlist			// ワンショットバフか (0=毎フレーム適用型, 1=1回のみ適用型でスタン・石化のみ使用)
	
#inc_end

#z00

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのバフ／デバフを初期化する
//---------------------------------------------------------------------------
command $$init_running_uma_buff
{
	property $i
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		$uma_buff_speed_max[$i] = 100
		$uma_buff_accel[$i] = 100
		$uma_buff_stamina[$i] = 100
		$uma_buff_interrupt_block[$i] = 0
		$uma_buff_trap_block[$i] = 0
		$uma_buff_reverse_run[$i] = 0
		$uma_buff_hide_mode_float[$i] = 0
		$uma_buff_hide_mode_dive[$i] = 0
		$uma_buff_ground_affinity[$i] = 0
		$uma_buff_skill_seal[$i] = 0
		$uma_buff_item_seal[$i] = 0
		$buff_num[$i] = 0
	}
	
	$buff_type.init
	$buff_target.init
	$buff_amount.init
	$buff_amount_max.init
	$buff_time.init
	$buff_time_max.init
	$buff_delay_time.init
	$buff_delay_time_max.init
	$buff_source_projectile_id.init
	$buff_one_shot.init
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのバフ／デバフを更新する
//---------------------------------------------------------------------------
command $$update_running_uma_buff
{
	property $i
	property $len
	
	$len = $buff_type.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		// バフディレイ時間を計算する
		$buff_delay_time[$i] -= $$get_delta_time
		if( $buff_delay_time[$i] < 0 ) {
			$buff_delay_time[$i] = 0
		}
		
		// ディレイ時間が残っている場合はスキップする
		if( $buff_delay_time[$i] > 0 ) {
			continue
		}
		
		// バフ効果時間を計算する
		$buff_time[$i] -= $$get_delta_time
		if( $buff_time[$i] < 0 ) {
			$buff_time[$i] = 0
		}
	}
	
	$$calc_running_uma_buff
}

command $$calc_running_uma_buff
{
	property $i
	property $len
	property $lane_index
	
	// バフ／デバフの効果量を初期化する
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		$uma_buff_speed_max[$i] = 100
		$uma_buff_accel[$i] = 100
		$uma_buff_stamina[$i] = 100
		$uma_buff_interrupt_block[$i] = 0
		$uma_buff_trap_block[$i] = 0
		$uma_buff_reverse_run[$i] = 0
		$uma_buff_hide_mode_float[$i] = 0
		$uma_buff_hide_mode_dive[$i] = 0
		$uma_buff_ground_affinity[$i] = 0
		$uma_buff_skill_seal[$i] = 0
		$uma_buff_item_seal[$i] = 0
		
		$$set_running_uma_block_flag($i, 0)
	}
	
	$len = $buff_type.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		// ディレイ時間が残っている場合はスキップする
		if( $buff_delay_time[$i] > 0 ) {
			continue
		}
		// ★追加：効果時間が切れている場合もスキップ★
		if( $buff_time[$i] <= 0 ) {
			continue
		}
		
		// 現在のバフ／デバフが発生しているレーンインデックスを取得する
		$lane_index = $$get_lane_index_from_buff_index($i)
		
		// バフの種類によって効果が変わる
		switch( $buff_type[$i] ) {
			
		// 最高速度(固定値)
		case(<RUNNING_UMA_BUFF_TYPE_CONST_SPEED_MAX>)
			
			$uma_buff_speed_max[$lane_index] += $buff_amount[$i]
			
		// 最高速度(徐々に減少する)
		case(<RUNNING_UMA_BUFF_TYPE_REDUCE_SPEED_MAX>)
			
			$buff_amount[$i] = math.linear($buff_time[$i], $buff_time_max[$i], $buff_amount_max[$i], 0, 0)
			$uma_buff_speed_max[$lane_index] += $buff_amount[$i]
			
		// 加速力
		case(<RUNNING_UMA_BUFF_TYPE_ACCEL>)
			
			$uma_buff_accel[$lane_index] += $buff_amount[$i]
			
		// スタミナ
		case(<RUNNING_UMA_BUFF_TYPE_STAMINA>)
			
			$uma_buff_stamina[$lane_index] += $buff_amount[$i]
			
		// スタミナ吸収
		//case(<RUNNING_UMA_BUFF_TYPE_STAMINA_DRAIN>)
			
		// 潜伏モード
		case(<RUNNING_UMA_BUFF_TYPE_HIDE_MODE>)
			
			switch( $buff_amount[$i] ) {
			case(<UMA_HIDE_MODE_FLOAT>)		$uma_buff_hide_mode_float[$lane_index] += 1
			case(<UMA_HIDE_MODE_DIVE>)		$uma_buff_hide_mode_dive[$lane_index] += 1
			}
			
		// 妨害無効
		case(<RUNNING_UMA_BUFF_TYPE_INTERRUPT_BLOCK>)
			
			$uma_buff_interrupt_block[$lane_index] += 1
			
		// 障害物無効
		case(<RUNNING_UMA_BUFF_TYPE_TRAP_BLOCK>)
			
			$uma_buff_trap_block[$lane_index] += 1
			
		// 逆走
		case(<RUNNING_UMA_BUFF_TYPE_REVERSE_RUN>)
			
			$uma_buff_reverse_run[$lane_index] += 1
			
		// 気絶・スタン
		case(<RUNNING_UMA_BUFF_TYPE_STUN>)
			
			// 既に適用済みならスキップ
			if( $buff_one_shot[$i] == 1 ) {
				continue
			}
			
			if( $$get_running_uma_action_state($lane_index) == <RUNNING_UMA_ACTION_STATE_STUN> )
			{
				//  元
				//$$add_running_uma_action_time($lane_index, $buff_amount[$i])
				// 追加、スタン残り時間より長い場合のみ更新
				if( $$get_running_uma_action_time($lane_index) < $buff_amount[$i] )
				{
					$$set_running_uma_action_time($lane_index, $buff_amount[$i])
					$buff_one_shot[$i] = 1
				}
			}
			else
			{
				// 石化を上書きするかは要検討
				$$set_running_uma_action_state($lane_index, <RUNNING_UMA_ACTION_STATE_STUN>)
				$$set_running_uma_action_time($lane_index, $buff_amount[$i])
				$buff_one_shot[$i] = 1
			}
		
		// 地形適性アップ
		case(<RUNNING_UMA_BUFF_TYPE_GROUND_AFFINITY>)
			
			$uma_buff_ground_affinity[$lane_index] += $buff_amount[$i]
		// スキル封印
		case(<RUNNING_UMA_BUFF_TYPE_SKILL_SEAL>)

			$uma_buff_skill_seal[$lane_index] += 1
		// アイテム封印
		case(<RUNNING_UMA_BUFF_TYPE_ITEM_SEAL>)

			$uma_buff_item_seal[$lane_index] += 1
			
		// 石化
		case(<RUNNING_UMA_BUFF_TYPE_STONE>)
			
			// 既に適用済みならスキップ
			if( $buff_one_shot[$i] == 1 ) {
				continue
			}
			
			if( $$get_running_uma_action_state($lane_index) == <RUNNING_UMA_ACTION_STATE_STONE> )
			{
				//  元
				//$$add_running_uma_action_time($lane_index, $buff_amount[$i])
				// 追加、スタン残り時間より長い場合のみ更新
				if( $$get_running_uma_action_time($lane_index) < $buff_amount[$i] )
				{
					$$set_running_uma_action_time($lane_index, $buff_amount[$i])
					$buff_one_shot[$i] = 1
				}
			}
			else
			{
				$$set_running_uma_action_state($lane_index, <RUNNING_UMA_ACTION_STATE_STONE>)
				$$set_running_uma_action_time($lane_index, $buff_amount[$i])
				$buff_one_shot[$i] = 1
			}
			
		}
	}
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡにバフ／デバフを追加する ★未使用になった
//---------------------------------------------------------------------------
command $$_________add_running_uma_buff(property $target_lane_index, property $user_lane_index, property $skill_id, property $type, property $time, property $amount, property $delay_time)
{
	property $i
	property $len
	property $start_index
	property $end_index
	
	// 配列をリサイズする
	$len = $buff_type.get_size + 1
	
	$buff_type.resize($len)
	$buff_target.resize($len)
	$buff_amount.resize($len)
	$buff_amount_max.resize($len)
	$buff_time.resize($len)
	$buff_time_max.resize($len)
	$buff_delay_time.resize($len)
	$buff_delay_time_max.resize($len)
	
	// バフ／デバフが付与されるレーンの開始インデックス／終了インデックスを取得する
	$start_index = $$get_lane_start_index($target_lane_index)
	$end_index = $start_index + $buff_num[$target_lane_index]
	
	// バフ／デバフが追加されるインデックス以降のデータをずらす
	for( $i = $len - 1, $i > $end_index, $i -= 1 )
	{
		$buff_type[$i] = $buff_type[$i - 1]
		$buff_target[$i] = $buff_target[$i - 1]
		$buff_amount[$i] = $buff_amount[$i - 1]
		$buff_amount_max[$i] = $buff_amount_max[$i - 1]
		$buff_time[$i] = $buff_time[$i - 1]
		$buff_time_max[$i] = $buff_time_max[$i - 1]
		$buff_delay_time[$i] = $buff_delay_time[$i - 1]
		$buff_delay_time_max[$i] = $buff_delay_time_max[$i - 1]
	}
	
	// バフ／デバフデータを設定する
	$buff_type[$end_index] = $type
	$buff_target[$end_index] = $user_lane_index
	$buff_amount_max[$end_index] = $amount
	$buff_amount[$end_index] = $buff_amount_max[$end_index]
	$buff_time_max[$end_index] = $time
	$buff_time[$end_index] = $buff_time_max[$end_index]
	$buff_delay_time_max[$end_index] = $delay_time
	$buff_delay_time[$end_index] = $buff_delay_time_max[$end_index]
	
	// 各レーンで発生しているバフ／デバフの個数を加算する
	$buff_num[$target_lane_index] += 1
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡにバフ・デバフを追加する
//---------------------------------------------------------------------------
command $$add_running_uma_buff(property $target_lane_index, property $user_lane_index, property $skill_id, property $type, property $time, property $amount, property $delay_time)
{
	$$add_running_uma_buff_ex($target_lane_index, $user_lane_index, $skill_id, $type, $time, $amount, $delay_time, 0)
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡにバフ・デバフを追加する（拡張版：projectile ID対応）
//---------------------------------------------------------------------------
command $$add_running_uma_buff_ex(property $target_lane_index, property $user_lane_index, property $skill_id, property $type, property $time, property $amount, property $delay_time, property $projectile_id)
{
	property $i
	property $len
	property $start_index
	property $end_index
	property $check_lane_index

	// projectile由来のスタンバフの重複チェック
	if( $projectile_id != 0 && $type == <RUNNING_UMA_BUFF_TYPE_STUN> )
	{
		$len = $buff_type.get_size
		for( $i = 0, $i < $len, $i += 1 )
		{
			$check_lane_index = $$get_lane_index_from_buff_index($i)

			// 同一projectile + 同一target + STUNバフが既に存在
			if( $buff_source_projectile_id[$i] == $projectile_id && $buff_type[$i] == <RUNNING_UMA_BUFF_TYPE_STUN> && $check_lane_index == $target_lane_index )
			{
				return  // 重複付与を防ぐ
			}
		}
	}

	// 配列のサイズを増やす
	$len = $buff_type.get_size + 1

	$buff_type.resize($len)
	$buff_target.resize($len)
	$buff_amount.resize($len)
	$buff_amount_max.resize($len)
	$buff_time.resize($len)
	$buff_time_max.resize($len)
	$buff_delay_time.resize($len)
	$buff_delay_time_max.resize($len)
	$buff_source_projectile_id.resize($len)
	$buff_one_shot.resize($len)

	// バフ・デバフを付与するレーンの開始インデックス・終了インデックスを取得する
	$start_index = $$get_lane_start_index($target_lane_index)
	$end_index = $start_index + $buff_num[$target_lane_index]

	// バフ・デバフを追加するインデックス以降のデータをずらす
	for( $i = $len - 1, $i > $end_index, $i -= 1 )
	{
		$buff_type[$i] = $buff_type[$i - 1]
		$buff_target[$i] = $buff_target[$i - 1]
		$buff_amount[$i] = $buff_amount[$i - 1]
		$buff_amount_max[$i] = $buff_amount_max[$i - 1]
		$buff_time[$i] = $buff_time[$i - 1]
		$buff_time_max[$i] = $buff_time_max[$i - 1]
		$buff_delay_time[$i] = $buff_delay_time[$i - 1]
		$buff_delay_time_max[$i] = $buff_delay_time_max[$i - 1]
		$buff_source_projectile_id[$i] = $buff_source_projectile_id[$i - 1]
		$buff_one_shot[$i] = $buff_one_shot[$i - 1]
	}

	// バフ・デバフデータを設定する
	$buff_type[$end_index] = $type
	$buff_target[$end_index] = $user_lane_index
	$buff_amount_max[$end_index] = $amount
	$buff_amount[$end_index] = $buff_amount_max[$end_index]
	$buff_time_max[$end_index] = $time
	$buff_time[$end_index] = $buff_time_max[$end_index]
	$buff_delay_time_max[$end_index] = $delay_time
	$buff_delay_time[$end_index] = $buff_delay_time_max[$end_index]
	$buff_source_projectile_id[$end_index] = $projectile_id
	$buff_one_shot[$end_index] = 0

	// 各レーンで発動しているバフ・デバフの個数を足す
	$buff_num[$target_lane_index] += 1
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのバフ／デバフを削除する
//---------------------------------------------------------------------------
command $$del_running_uma_buff(property $user_lane_index, property $skill_id)
{
	property $i
	property $j
	property $len
	property $count
	property $target_lane_index
	
	// 配列のサイズを取得する
	$len = $buff_type.get_size
	
	// データがない場合は終了する
	if( $len == 0 ) {
		return
	}
	
	// 継続中のバフ／デバフに使用者とスキルIDが一致するものがある場合は削除する
	for( $i = 0, $i < $buff_type.get_size, $i += 1 )
	{
		if( $buff_target[$i] != $user_lane_index ) {
			continue
		}
		
		// 現在のバフ／デバフが発生しているレーンインデックスを取得する
		$target_lane_index = $$get_lane_index_from_buff_index($i)
		
		// 各レーンで発生しているバフ／デバフの個数を減算する
		$buff_num[$target_lane_index] -= 1
		
		// 削除するバフ／デバフ以降のデータをずらす
		for( $j = $i, $j < $len - 1, $j += 1 )
		{
			$buff_type[$j] = $buff_type[$j + 1]
			$buff_target[$j] = $buff_target[$j + 1]
			$buff_amount[$j] = $buff_amount[$j + 1]
			$buff_amount_max[$j] = $buff_amount_max[$j + 1]
			$buff_time[$j] = $buff_time[$j + 1]
			$buff_time_max[$j] = $buff_time_max[$j + 1]
			$buff_delay_time[$j] = $buff_delay_time[$j + 1]
			$buff_delay_time_max[$j] = $buff_delay_time_max[$j + 1]
			$buff_source_projectile_id[$j] = $buff_source_projectile_id[$j + 1]
			$buff_one_shot[$j] = $buff_one_shot[$j + 1]
			
		}
		
		$len = $buff_type.get_size - 1
		$buff_type.resize($len)
		$buff_target.resize($len)
		$buff_amount.resize($len)
		$buff_amount_max.resize($len)
		$buff_time.resize($len)
		$buff_time_max.resize($len)
		$buff_delay_time.resize($len)
		$buff_delay_time_max.resize($len)
		$buff_source_projectile_id.resize($len)
		$buff_one_shot.resize($len)
		
		$i -= 1
	}
}

//---------------------------------------------------------------------------
// 指定したレーンのバフ／デバフ配列開始インデックスを取得する
//---------------------------------------------------------------------------
command $$get_lane_start_index(property $target_lane_index) : int
{
	property $i
	property $index
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		// 指定したレーンの場合は処理を終了する
		if( $i == $target_lane_index ) {
			break
		}
		
		// レーンごとに保持しているバフ／デバフの個数を追加する
		$index += $buff_num[$i]
	}
	
	return ($index)
}

command $$get_lane_index_from_buff_index(property $buff_index) : int
{
	property $i
	property $index
	property $count
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		$count += $buff_num[$i]
		
		if( $buff_index < $count ) {
			return ($i)
		}
	}
	
	return (-1)
}

//---------------------------------------------------------------------------
// 発生しているバフ／デバフの数を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_num(property $lane_index) : int
{
	return ($buff_num[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによる最高速度補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_speed_max(property $lane_index) : int
{
	return ($uma_buff_speed_max[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによる加速力補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_accel(property $lane_index) : int
{
	return ($uma_buff_accel[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによるスタミナ補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_stamina(property $lane_index) : int
{
	return ($uma_buff_stamina[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによる妨害無効補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_interrupt_block(property $lane_index) : int
{
	return ($uma_buff_interrupt_block[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによる障害物無効補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_trap_block(property $lane_index) : int
{
	return ($uma_buff_trap_block[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによる逆走補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_reverse_run(property $lane_index) : int
{
	return ($uma_buff_reverse_run[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによる潜伏モード補正(浮遊／潜る)を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_hide_mode_float(property $lane_index) : int
{
	return ($uma_buff_hide_mode_float[$lane_index])
}

command $$get_running_uma_buff_hide_mode_dive(property $lane_index) : int
{
	return ($uma_buff_hide_mode_dive[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフによる地形適性アップバフの補正値を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_ground_affinity(property $lane_index) : int	// 他と合わせるなら$lane_indexで正しいけど実体は$entry_index
{
	return ($uma_buff_ground_affinity[$lane_index])
}


//---------------------------------------------------------------------------
// バフ／デバフを発生させたレーン(このバフを発生させたＵＭＡ)インデックスを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_user_index(property $lane_index, property $buff_index) : int
{
	return ($buff_target[$$get_lane_start_index($lane_index) + $buff_index])
}

//---------------------------------------------------------------------------
// バフ・デバフによるスキル封印補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_skill_seal(property $lane_index) : int
{
	return ($uma_buff_skill_seal[$lane_index])
}

//---------------------------------------------------------------------------
// バフ・デバフによるアイテム封印補正を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_item_seal(property $lane_index) : int
{
	return ($uma_buff_item_seal[$lane_index])
}

//---------------------------------------------------------------------------
// バフ／デバフタイプを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_type(property $lane_index, property $buff_index) : int
{
	return ($buff_type[$$get_lane_start_index($lane_index) + $buff_index])
}

//---------------------------------------------------------------------------
// バフ／デバフ効果量を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_amount(property $lane_index, property $buff_index) : int
{
	return ($buff_amount[$$get_lane_start_index($lane_index) + $buff_index])
}

//---------------------------------------------------------------------------
// バフ／デバフ効果時間を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_time(property $lane_index, property $buff_index) : int
{
	return ($buff_time[$$get_lane_start_index($lane_index) + $buff_index])
}

//---------------------------------------------------------------------------
// バフ／デバフ効果最大時間を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_time_max(property $lane_index, property $buff_index) : int
{
	return ($buff_time_max[$$get_lane_start_index($lane_index) + $buff_index])
}

//---------------------------------------------------------------------------
// バフ／デバフディレイ時間を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_delay_time(property $lane_index, property $buff_index) : int
{
	return ($buff_delay_time[$$get_lane_start_index($lane_index) + $buff_index])
}

//---------------------------------------------------------------------------
// バフ／デバフディレイ最大時間を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_buff_delay_time_max(property $lane_index, property $buff_index) : int
{
	return ($buff_delay_time_max[$$get_lane_start_index($lane_index) + $buff_index])
}
