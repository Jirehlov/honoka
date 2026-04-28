//===========================================================================
//!
//!    @file     ___mng_urace_race_projectile.ss
//!    @brief    ＵＭＡレース発射物管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レース画面中の発射物処理
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// 発射物データ
	#property	$projectile_id : intlist		// ID
	#property	$projectile_place : intlist		// 現在の位置
	#property	$projectile_lane : intlist		// 現在のレーン
	#property	$projectile_speed : intlist		// 移動速度
	#property	$projectile_power : intlist		// 攻撃力
	
	#property	$projectile_persistent : intlist		// 持続型フラグ（0=通常、1=持続）
	#property	$projectile_lifetime : intlist			// 寿命（ミリ秒）
	#property	$projectile_spawn_time : intlist		// 生成時刻
	#property	$projectile_last_check_time : intlist	// 最終判定時刻
	#property	$projectile_global_time					// グローバルタイマー（累積時間）
	#property	$projectile_unique_id_counter			// 一意ID生成用カウンター
	#property	$projectile_unique_id : intlist			// 各projectileの一意ID
	
	// オブジェクトデータ
	#property	$use_obj_no : intlist			// 使用するオブジェクト番号
	#property	$use_child_no : intlist			// 使用する子供オブジェクト番号
	
#inc_end

#z00

//---------------------------------------------------------------------------
// レース発射物データの初期化
//---------------------------------------------------------------------------
command $$init_urace_projectile
{
	$projectile_id.init
	$projectile_place.init
	$projectile_lane.init
	$projectile_speed.init
	$projectile_power.init
	
	$projectile_persistent.init
	$projectile_lifetime.init
	$projectile_spawn_time.init
	$projectile_last_check_time.init
	$projectile_global_time = 0
	$projectile_unique_id_counter = 1
	$projectile_unique_id.init
	
	$use_obj_no.init
	$use_child_no.init
}

//---------------------------------------------------------------------------
// レース発射物データを更新する
//---------------------------------------------------------------------------
command $$update_urace_projectile
{
	property $i
	property $j
	property $len
	property $delta_time
	property $race_distance
	
	property $k
	property $center_lane
	property $check_lane
	
	$delta_time = $$get_delta_time
	$race_distance = $$get_entry_race_distance
	
	$projectile_global_time += $delta_time
	
	// 発射物処理
	for( $i = 0, $i < $projectile_id.get_size, $i += 1 )
	{
		// 移動速度が設定されている場合は移動する
		if( $projectile_speed[$i] != 0 )
		{
			$projectile_place[$i] += $projectile_speed[$i] * $delta_time
			
			// レース範囲外になった場合は削除する
			if( $projectile_place[$i] < 0 || $race_distance < $projectile_place[$i] || $projectile_lane[$i] < 0 || <URACE_LANE_MAX> < $projectile_lane[$i] )
			{
				$$del_urace_projectile($i)
				$i -= 1
				
				continue
			}
		}
		
		// 持続型projectileの寿命チェック
		if( $projectile_persistent[$i] == 1 && $projectile_lifetime[$i] > 0 )
		{
			// 経過時間が寿命を越えたら
			if( $projectile_global_time - $projectile_spawn_time[$i] > $projectile_lifetime[$i] )
			{
				$$del_urace_projectile($i)
				$i -= 1
				continue
			}
		}
	}
	
	
	// ＵＭＡと発射物の当たりチェック
	$len = $$get_entry_owner_num
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		// リタイア済みなら処理をスキップする
		if( $$get_entry_owner_retire($i) ) {
			continue
		}
		
		// ゴール済みなら処理をスキップする
		if( $$get_entry_owner_goal_order($i) != 0 ) {
			continue
		}
		
		// 各発射物との当たりをチェックする
		for( $j = 0, $j < $projectile_id.get_size, $j += 1 )
		{
			// シュールストレミングの場合（持続型）
			if( $projectile_id[$j] == @アイテム_蓋のついたシュールストレミング )
			{
				// 500msごとの定期判定
				if( $projectile_global_time - $projectile_last_check_time[$j] < 500 ) {
					continue
				}

				// 3レーン範囲判定
				$center_lane = $projectile_lane[$j]

				for( $check_lane = $center_lane - 1, $check_lane <= $center_lane + 1, $check_lane += 1 )
				{
					if( $check_lane < 0 || $check_lane >= <URACE_LANE_MAX> ) {
						continue
					}

					// 範囲内の全UMAをチェック
					for( $k = 0, $k < $len, $k += 1 )
					{
						// リタイア済みならスキップ
						if( $$get_entry_owner_retire($k) ) {
							continue
						}
						// ゴール済みならスキップ
						if( $$get_entry_owner_goal_order($k) != 0 ) {
							continue
						}
						if( $$get_now_lane($k) != $check_lane ) {
							continue
						}

						// 距離判定（前後2000の範囲）
						if( $$get_entry_owner_mileage($k) < $projectile_place[$j] - 2000 ) {
							continue
						}
						if( $$get_entry_owner_mileage($k) > $projectile_place[$j] + 2000 ) {
							continue
						}

						// スタンバフを付与
						$$add_running_uma_buff_ex(
							$k,                                    // target
							$k,                                    // user
							0,                                     // skill_id
							<RUNNING_UMA_BUFF_TYPE_STUN>,          // type
							100,                                   // time
							1000,                                  // amount
							0,                                     // delay
							$projectile_unique_id[$j]
						)
					}
				}

				$projectile_last_check_time[$j] = $projectile_global_time
				continue  // 削除しない
			}
			
			// ＵＭＡのレーンと発射物のレーンが違う場合は当たっていない
			if( $$get_now_lane($i) != $projectile_lane[$j] ) {
				continue
			}
			
			if( $$get_entry_owner_mileage($i) < $projectile_place[$j] ) {
				continue
			}
			
			if( $projectile_place[$j] + math.linear(110, 192, 10000, 1920, 100000) < $$get_entry_owner_mileage($i) ) {
				continue
			}
			
			// 当たっている場合
			if( $$damage_uma($i, $projectile_power[$j], <URACE_DAMAGE_TYPE_ITEM>) == 0 )
			{
				if( $projectile_id[$j] == 2 )
				{
					if( $$get_running_uma_action_state($i) != <RUNNING_UMA_ACTION_STATE_LAUNCH> )
					{
						$$set_running_uma_jump_param($i, 200, 1500)
						$$set_running_uma_action_state($i, <RUNNING_UMA_ACTION_STATE_LAUNCH>)
						$$set_running_uma_action_time($i, 1500)
					}
				}
				else
				{
					// 生存している場合はスタン
					$$set_running_uma_action_state($i, <RUNNING_UMA_ACTION_STATE_STUN>)
					$$set_running_uma_action_time($i, 2000)
				}
			}
			
			// 発射物を削除する
			$$del_urace_projectile($j)
			$j -= 1
		}
	}
}

//---------------------------------------------------------------------------
// レース発射物を追加する
//---------------------------------------------------------------------------
command $$add_urace_projectile(property $id, property $place, property $lane, property $speed, property $power, property $persistent, property $lifetime)
{
	property $index
	
	// 発射物のリストを確保する
	$index = $$resize_projectile
	
	$projectile_id[$index]    = $id
	$projectile_place[$index] = $place
	$projectile_lane[$index]  = $lane
	$projectile_speed[$index] = $speed
	$projectile_power[$index] = $power
	
	$projectile_persistent[$index] = $persistent
	$projectile_lifetime[$index] = $lifetime
	$projectile_spawn_time[$index] = $projectile_global_time
	$projectile_last_check_time[$index] = $projectile_global_time
	$projectile_unique_id[$index] = $projectile_unique_id_counter
	$projectile_unique_id_counter += 1
	
	$$add_bullet($projectile_lane[$index], $projectile_id[$index], $projectile_place[$index])
	
	$use_obj_no[$index] = $$get_o
	$use_child_no[$index] = $$get_c
}

//---------------------------------------------------------------------------
// レース発射物を削除する
//---------------------------------------------------------------------------
command $$del_urace_projectile(property $index)
{
	property $i
	property $len
	
	$$del_bullet($use_obj_no[$index], $use_child_no[$index])
	
	$len = $projectile_id.get_size - 1
	for( $i = $index, $i < $len, $i += 1 )
	{
		$projectile_id[$i]    = $projectile_id[$i + 1]
		$projectile_place[$i] = $projectile_place[$i + 1]
		$projectile_lane[$i]  = $projectile_lane[$i + 1]
		$projectile_speed[$i] = $projectile_speed[$i + 1]
		$projectile_power[$i] = $projectile_power[$i + 1]
		
		$projectile_persistent[$i] = $projectile_persistent[$i + 1]
		$projectile_lifetime[$i] = $projectile_lifetime[$i + 1]
		$projectile_spawn_time[$i] = $projectile_spawn_time[$i + 1]
		$projectile_last_check_time[$i] = $projectile_last_check_time[$i + 1]
		$projectile_unique_id[$i] = $projectile_unique_id[$i + 1]
		
		$use_obj_no[$i]   = $use_obj_no[$i + 1]
		$use_child_no[$i] = $use_child_no[$i + 1]
	}
	
	$projectile_id.resize($len)
	$projectile_place.resize($len)
	$projectile_lane.resize($len)
	$projectile_speed.resize($len)
	$projectile_power.resize($len)
	
	$projectile_persistent.resize($len)
	$projectile_lifetime.resize($len)
	$projectile_spawn_time.resize($len)
	$projectile_last_check_time.resize($len)
	$projectile_unique_id.resize($len)
	
	$use_obj_no.resize($len)
	$use_child_no.resize($len)
}

//---------------------------------------------------------------------------
// レース発射物のリストを確保する
//---------------------------------------------------------------------------
command $$resize_projectile : int
{
	property $len
	
	$len = $projectile_id.get_size + 1
	
	$projectile_id.resize($len)
	$projectile_place.resize($len)
	$projectile_lane.resize($len)
	$projectile_speed.resize($len)
	$projectile_power.resize($len)
	
	$projectile_persistent.resize($len)
	$projectile_lifetime.resize($len)
	$projectile_spawn_time.resize($len)
	$projectile_last_check_time.resize($len)
	$projectile_unique_id.resize($len)
	
	$use_obj_no.resize($len)
	$use_child_no.resize($len)
	
	return ($len - 1)
}



// deb
command $$get_projectile_num { return ($projectile_id.get_size) }
command $$get_projectile_place(property $index) { return ($projectile_place[$index]) }
command $$get_projectile_obj_no(property $index) { return ($use_obj_no[$index]) }
command $$get_projectile_child_no(property $index) { return ($use_child_no[$index]) }
