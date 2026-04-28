//===========================================================================
//!
//!    @file     ___mng_urace_data_settings.ss
//!    @brief    ＵＭＡレースデータ設定
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#z00

command $$set_urace_npc_race_entry_data
{
	property $i
	property $j
	property $len
	property $index
	property $race_id
	property $owner_list : intlist
	property $owner_index : intlist
	property $tmp_list : intlist
	property $tmp_list2 : intlist
	
	$race_id = $$get_entry_race_id
	
	// プレイヤー
	$owner_list.resize(1)
	$owner_list[0] = <URACE_PLAYER_OWNER_ID>
	
	$owner_index.resize(1)
	$owner_index[0] = 0
	
	// ＮＰＣ
	for( $i = 0, $i < <URACE_ENTRY_MAX> - 1, $i += 1 )
	{
		if( $$get_db_race_entry_owner($race_id, $i) ) 
		{
			$owner_list.resize($owner_list.get_size + 1)
			$owner_list[$i + 1] = $$get_db_race_entry_owner($race_id, $i)
			
			for( $j = 0, $j < <URACE_DECK_UMA_MAX>, $j += 1 )
			{
				if( $$get_db_owner_uma_list($owner_list[$i + 1], $j) != 0 )
				{
			//		$$create_npc_uma_data($$get_db_owner_uma_list($owner_list[$i + 1], $j), <URACE_ENTRY_UMA_MAX> + $i * <URACE_ENTRY_MAX> + $j)
				}
			}
			
			$owner_index.resize($owner_index.get_size + 1)
			$owner_index[$i + 1] = $i
		}
	}
	
	// 枠番をランダムに決定する
	$len = $owner_list.get_size
	$tmp_list.resize($len)
	$tmp_list2.resize($len)
	
	for( $i = 0, $i < $len, $i += 1)
	{
		$tmp_list[$i] = $owner_list[$i]
		$tmp_list2[$i] = $owner_index[$i]
	}
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$index = $$mng_rand(0, $tmp_list.get_size - 1)
		
		$owner_list[$i] = $tmp_list[$index]
		$owner_index[$i] = $tmp_list2[$index]
		
		for( $j = $index, $j < $tmp_list.get_size - 1, $j += 1 )
		{
			$tmp_list[$j] = $tmp_list[$j + 1]
			$tmp_list2[$j] = $tmp_list2[$j + 1]
		}
		$tmp_list.resize($tmp_list.get_size -1)
		$tmp_list2.resize($tmp_list2.get_size -1)
	}
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $owner_list[$i] == 0 ) {
			continue
		}
		
		$$entry_urace($owner_list[$i], $owner_index[$i], $i)
	}
}

/*
command $$create_npc_uma_data(property $npc_uma_id, property $npc_index)
{
	property $i
	
	$$set_uma_name(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_name($npc_uma_id))
	$$set_uma_id(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_base_uma_id($npc_uma_id))
	$$set_uma_rarity(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_rarity($npc_uma_id))
	$$set_uma_run_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_run_type($npc_uma_id))
	$$set_uma_life(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_life($npc_uma_id))
	$$set_uma_speed(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_speed($npc_uma_id))
	$$set_uma_attack(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_attack($npc_uma_id))
	$$set_uma_accel(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_accel($npc_uma_id))
	$$set_uma_turf_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_turf_type($npc_uma_id))
	$$set_uma_dirt_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_dirt_type($npc_uma_id))
	$$set_uma_surface_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_surface_type($npc_uma_id))
	
;	for( $i = 0, $i < <DB_NPC_UMA_SKILL_SLOT_MAX>, $i += 1 )
;	{
;		$$set_uma_skill(<URACE_NPC_OWNER_ID>, $npc_index, $i, $$get_db_npc_uma_skill($npc_uma_id, $i))
;	}
}
*/
command $$create_npc_uma_data(property $npc_uma_id, property $npc_index)
{
	property $i
	property $base_uma_id  // ← 追加: ベースUMA IDを保存する変数

	// NPC UMAのベースとなるUMA IDを取得
	$base_uma_id = $$get_db_npc_uma_base_uma_id($npc_uma_id)  // ← 追加

	// NPC固有のデータ（NPC UMAデータベースから）
	$$set_uma_name(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_name($npc_uma_id))
	$$set_uma_id(<URACE_NPC_OWNER_ID>, $npc_index, $base_uma_id)  // ← 変更

       // 共通属性（通常のUMAデータベースから、ベースUMA ID経由）
	$$set_uma_rarity(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_rarity($base_uma_id))      // ← 修正
	$$set_uma_run_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_run_type($base_uma_id))  // ← 修正

       // NPC固有のステータス（NPC UMAデータベースから）
	$$set_uma_life(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_life($npc_uma_id))
	$$set_uma_speed(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_speed($npc_uma_id))
	$$set_uma_attack(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_attack($npc_uma_id))
	$$set_uma_accel(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_npc_uma_accel($npc_uma_id))
	
	// 地形適性（通常のUMAデータベースから、ベースUMA ID経由）
	$$set_uma_turf_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_turf_type($base_uma_id))      // ← 修正
	$$set_uma_dirt_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_dirt_type($base_uma_id))      // ← 修正
	$$set_uma_surface_type(<URACE_NPC_OWNER_ID>, $npc_index, $$get_db_uma_surface_type($base_uma_id))// ← 修正

;	for( $i = 0, $i < <DB_NPC_UMA_SKILL_SLOT_MAX>, $i += 1 )
;	{
;		$$set_uma_skill(<URACE_NPC_OWNER_ID>, $npc_index, $i, $$get_db_npc_uma_skill($npc_uma_id, $i))
;	}
}
