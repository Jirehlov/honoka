//===========================================================================
//!
//!    @file     ___mng_hhp_item.ss
//!    @brief    ヘビヘビパニックアイテムデータ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// アイテムリストデータタイプ（データ使用量削減のため32bitフラグを8bit分割する）
	// それぞれのタイプが8bit分割時にどのインデックスを参照するか
	#replace	<ITEM_LIST_8BIT_FLAG_ID>			0		// ID
	#replace	<ITEM_LIST_8BIT_FLAG_LEVEL>			1		// レベル
	
	#property	$items : intlist				// 所持アイテムリスト  8bit分割[ID／レベル／未使用／未使用]
	#property	$item_cooldown : intlist		// アイテムの現在のクールタイム
	#property	$item_cooldown_max : intlist	// アイテムのクールタイム値
	#property	$item_counter : intlist			// アイテムの汎用カウンター
	
#inc_end

#z00

//---------------------------------------------------------------------------
// アイテムデータの初期化(初回)
//---------------------------------------------------------------------------
command $$init_hhp_item_data
{
	$items.init
	$item_cooldown.init
	$item_cooldown_max.init
	$item_counter.init
}

//---------------------------------------------------------------------------
// アイテムデータの初期化(再ゲーム開始時)
//---------------------------------------------------------------------------
command $$restart_hhp_item_data
{
	property $i
	property $len
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		$item_cooldown[$i] = $item_cooldown_max[$i]
	}
}

//---------------------------------------------------------------------------
// アイテムリストの8bitデータを取得／設定する
//---------------------------------------------------------------------------
command $$get_8bit_data(property $index, property $8bit_type)
{
	return ($items.bit8[$index * 4 + $8bit_type])
}

command $$set_8bit_data(property $index, property $8bit_type, property $value)
{
	$items.bit8[$index * 4 + $8bit_type] = $value
}

//---------------------------------------------------------------------------
// リストインデックスから各アイテムデータを取得する
// (アイテムＩＤ／アイテムレベル／クールタイム／汎用カウンター)
//---------------------------------------------------------------------------
command $$get_hhp_item_id_from_list_index(property $index) : int
{
	return ($$get_8bit_data($index, <ITEM_LIST_8BIT_FLAG_ID>))
}

command $$get_hhp_item_level_from_list_index(property $index) : int
{
	return ($$get_8bit_data($index, <ITEM_LIST_8BIT_FLAG_LEVEL>))
}

command $$get_hhp_item_cooldown_from_list_index(property $index) : int
{
	return ($item_cooldown[$index])
}

command $$get_hhp_item_cooldown_max_from_list_index(property $index) : int
{
	return ($item_cooldown_max[$index])
}

command $$get_hhp_item_counter_from_list_index(property $index) : int
{
	return ($item_counter[$index])
}

//---------------------------------------------------------------------------
// アイテムの所持数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_count : int
{
	return ($items.get_size)
}

//---------------------------------------------------------------------------
// 指定したタイプの所持アイテムの数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_count_from_type(property $item_type) : int
{
	property $i
	property $len
	property $count
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $$get_hhp_item_type($$get_hhp_item_id_from_list_index($i)) == $item_type )
		{
			$count += 1
		}
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// 指定したレベルの所持アイテムの数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_count_from_level(property $item_level) : int
{
	property $i
	property $len
	property $count
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $$get_hhp_item_level_from_list_index($i) >= $item_level )
		{
			$count += 1
		}
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// アイテムを所持しているかどうか
//---------------------------------------------------------------------------
command $$has_hhp_item(property $item_id) : int
{
	property $i
	property $len
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $$get_hhp_item_id_from_list_index($i) == $item_id ) 
		{
			// 所持している場合はリストインデックスを返す
			return ($i)
		}
	}
	
	// 所持していない
	return (-1)
}

//---------------------------------------------------------------------------
// アイテムを追加する
//---------------------------------------------------------------------------
command $$add_hhp_item(property $item_id) : int
{
	property $index
	
	if( $$has_hhp_item($item_id) != -1 )
	{
		$$debug_message("既に取得済みのアイテムを追加しようとしています。\nid:" + math.tostr($item_id) + "\n処理をスキップします")
		return (0)
	}
	
	// リストサイズを増やす
	$index = $items.get_size
	$items.resize($index + 1)
	$item_cooldown.resize($index + 1)
	$item_cooldown_max.resize($index + 1)
	$item_counter.resize($index + 1)
	
	// リストにアイテムを追加する
	$$set_8bit_data($index, <ITEM_LIST_8BIT_FLAG_ID>, $item_id)			// アイテムID
	$$set_8bit_data($index, <ITEM_LIST_8BIT_FLAG_LEVEL>, $$get_hhp_item_default_level($item_id))	// アイテムレベル
	
	// アイテム取得時に発生するイベントを実行する
	$$hhp_item_trigger_on_get($item_id, <HHP_ITEM_LEVEL_MIN>)
	
	return (1)
}

//---------------------------------------------------------------------------
// アイテムを削除する
//---------------------------------------------------------------------------
command $$del_hhp_item(property $index)
{
	property $i
	property $len
	property $item_id
	property $item_level
	
	$item_id = $$get_hhp_item_id_from_list_index($index)
	$item_level = $$get_hhp_item_level_from_list_index($index)
	
	$len = $items.get_size - 1
	for( $i = $index, $i < $len, $i += 1 )
	{
		// 指定したインデックス以降のリストを前にずらす
		$items[$i] = $items[$i + 1]
		$item_cooldown[$i] = $item_cooldown[$i + 1]
		$item_cooldown_max[$i] = $item_cooldown_max[$i + 1]
		$item_counter[$i] = $item_counter[$i + 1]
	}
	
	// リストをリサイズする
	$items.resize($len)
	$item_cooldown.resize($len)
	$item_cooldown_max.resize($len)
	$item_counter.resize($len)
	
	// アイテム破棄時に発生するイベントを実行する
	$$hhp_item_trigger_on_del($item_id, $item_level)
}

//---------------------------------------------------------------------------
// アイテムをパワーアップする(未所持のアイテムはリストに追加／所持しているアイテムはレベルを加算する)
//---------------------------------------------------------------------------
command $$powerup_hhp_item(property $item_id)
{
	// アイテムを所持していない場合はアイテムを追加する
	if( $$has_hhp_item($item_id) == -1 )
	{
		$$add_hhp_item($item_id)
	}
	else
	{
		// アイテムを所持していてレベルが最大でない場合はアイテムレベルを上げる
		if( $$get_hhp_item_level($item_id) < <HHP_ITEM_LEVEL_MAX> )
		{
			$$add_hhp_item_level($item_id, 1)
		}
	}
}

//---------------------------------------------------------------------------
// アイテムＩＤからアイテムレベルを取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_level(property $item_id) : int
{
	property $i
	property $len
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $$get_hhp_item_id_from_list_index($i) != $item_id ) {
			continue
		}
		
		return ($$get_hhp_item_level_from_list_index($i))
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// アイテムレベルを加算する
//---------------------------------------------------------------------------
command $$add_hhp_item_level(property $item_id, property $value) : int
{
	property $index
	property $level
	
	$index = $$has_hhp_item($item_id)
	if( $index == -1 )
	{
		$$debug_message("取得していないアイテムのレベルを加算しようとしています。\nid:" + math.tostr($item_id) + "\n処理をスキップします")
		return (0)
	}
	
	if( $$get_hhp_item_level_from_list_index($index) >= <HHP_ITEM_LEVEL_MAX> )
	{
		$$debug_message("既に最大レベルのアイテムのレベルを加算しようとしています。\nid:" + math.tostr($item_id) + "\n処理をスキップします")
		return (0)
	}
	
	// アイテムレベルの範囲内に収める
	$level = math.limit(<HHP_ITEM_LEVEL_MIN>, $$get_hhp_item_level_from_list_index($index) + $value, <HHP_ITEM_LEVEL_MAX>)
	
	// アイテムレベルを設定する
	$$set_8bit_data($index, <ITEM_LIST_8BIT_FLAG_LEVEL>, $level)
	
	// アイテム取得時に発生するイベントを実行する
	$$hhp_item_trigger_on_get($item_id, $level)
	
	return (1)
}

//---------------------------------------------------------------------------
// アイテムＩＤからリストインデックスを取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_list_index(property $item_id) : int
{
	property $i
	property $len
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $$get_hhp_item_id_from_list_index($i) == $item_id ) {
			return ($i)
		}
	}
	
	return (-1)
}

//---------------------------------------------------------------------------
// アイテムタイプを取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_type(property $item_id) : int
{
	property $type
	
	switch( $item_id ) {
	case(<HHP_ITEM_ID_DAMAGE_UP>)						$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_ATTACK_SLASH>)					$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_CRITICAL>)						$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_INVINCIBLE>)						$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>)				$type = <HHP_ITEM_TYPE_STATUS_EFFECT>
	case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)			$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_SPIKE>)							$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_LIFE_REGENERATION>)				$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER>)		$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_DOUBLE_ATTACK>)					$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)				$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_ATTACK_RANGE_UP>)					$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_SKILL_POWER_REGENERATION>)		$type = <HHP_ITEM_TYPE_OTHER>
	case(<HHP_ITEM_ID_STATUS_EFFECT_CONVERT>)			$type = <HHP_ITEM_TYPE_STATUS_EFFECT>
	case(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)			$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP>)			$type = <HHP_ITEM_TYPE_STATUS_EFFECT>
	case(<HHP_ITEM_ID_LIFELESS_DAMAGE_UP>)				$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_ATTACKED_DAMAGE_UP>)				$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_SKILL_POWER_MAX_UP>)				$type = <HHP_ITEM_TYPE_OTHER>
	case(<HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP>)	$type = <HHP_ITEM_TYPE_STATUS_EFFECT>
	case(<HHP_ITEM_ID_COMBO_UP>)						$type = <HHP_ITEM_TYPE_ATTACK>
	case(<HHP_ITEM_ID_LIFE_UP>)							$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_STATUS_EFFECT_STUN>)				$type = <HHP_ITEM_TYPE_STATUS_EFFECT>
	case(<HHP_ITEM_ID_DAMAGE_LIFE_RECOVER>)				$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_RIVIVAL>)							$type = <HHP_ITEM_TYPE_OTHER>
	case(<HHP_ITEM_ID_SPIKE_DAMAGE_UP>)					$type = <HHP_ITEM_TYPE_DEFENCE>
	case(<HHP_ITEM_ID_REROLL>)							$type = <HHP_ITEM_TYPE_OTHER>
	case(<HHP_ITEM_ID_STATUS_EFFECT_EXCITED>)			$type = <HHP_ITEM_TYPE_STATUS_EFFECT>
	case(<HHP_ITEM_ID_SE_CHANGE>)						$type = <HHP_ITEM_TYPE_OTHER>
	}
	
	return ($type)
}

//---------------------------------------------------------------------------
// アイテムのデフォルトレベルを取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_default_level(property $item_id) : int
{
	property $level
	
	switch( $item_id ) {
	case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)			$level = 3
	case(<HHP_ITEM_ID_STATUS_EFFECT_CONVERT>)			$level = 3
	case(<HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP>)	$level = 3
	case(<HHP_ITEM_ID_RIVIVAL>)							$level = 3
	case(<HHP_ITEM_ID_STATUS_EFFECT_EXCITED>)			$level = 3
	case(<HHP_ITEM_ID_SE_CHANGE>)						$level = 3
	default												$level = 1
	}
	
	return ($level)
}

//---------------------------------------------------------------------------
// アイテムアイコン番号を取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_icon_no(property $item_id, property $item_level) : int
{
	property $icon_no
	
	switch( $item_id ) {
	case(<HHP_ITEM_ID_DAMAGE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 0
		case(2)		$icon_no = 1
		case(3)		$icon_no = 2
		}
	case(<HHP_ITEM_ID_ATTACK_SLASH>)
		switch( $item_level ) {
		case(1)		$icon_no = 3
		case(2)		$icon_no = 4
		case(3)		$icon_no = 5
		}
	case(<HHP_ITEM_ID_CRITICAL>)
		switch( $item_level ) {
		case(1)		$icon_no = 6
		case(2)		$icon_no = 7
		case(3)		$icon_no = 8
		}
	case(<HHP_ITEM_ID_INVINCIBLE>)
		switch( $item_level ) {
		case(1)		$icon_no = 9
		case(2)		$icon_no = 10
		case(3)		$icon_no = 11
		}
	case(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>)
		switch( $item_level ) {
		case(1)		$icon_no = 12
		case(2)		$icon_no = 13
		case(3)		$icon_no = 14
		}
	case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)
					$icon_no = 15
	case(<HHP_ITEM_ID_SPIKE>)
		switch( $item_level ) {
		case(1)		$icon_no = 16
		case(2)		$icon_no = 17
		case(3)		$icon_no = 18
		}
	case(<HHP_ITEM_ID_LIFE_REGENERATION>)
		switch( $item_level ) {
		case(1)		$icon_no = 19
		case(2)		$icon_no = 20
		case(3)		$icon_no = 21
		}
	case(<HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER>)
		switch( $item_level ) {
		case(1)		$icon_no = 22
		case(2)		$icon_no = 23
		case(3)		$icon_no = 24
		}
	case(<HHP_ITEM_ID_DOUBLE_ATTACK>)
		switch( $item_level ) {
		case(1)		$icon_no = 25
		case(2)		$icon_no = 26
		case(3)		$icon_no = 27
		}
	case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 28
		case(2)		$icon_no = 29
		case(3)		$icon_no = 30
		}
	case(<HHP_ITEM_ID_ATTACK_RANGE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 31
		case(2)		$icon_no = 32
		case(3)		$icon_no = 33
		}
	case(<HHP_ITEM_ID_SKILL_POWER_REGENERATION>)
		switch( $item_level ) {
		case(1)		$icon_no = 34
		case(2)		$icon_no = 35
		case(3)		$icon_no = 36
		}
	case(<HHP_ITEM_ID_STATUS_EFFECT_CONVERT>)
					$icon_no = 37
	case(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 38
		case(2)		$icon_no = 39
		case(3)		$icon_no = 40
		}
	case(<HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 41
		case(2)		$icon_no = 42
		case(3)		$icon_no = 43
		}
	case(<HHP_ITEM_ID_LIFELESS_DAMAGE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 44
		case(2)		$icon_no = 45
		case(3)		$icon_no = 46
		}
	case(<HHP_ITEM_ID_ATTACKED_DAMAGE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 47
		case(2)		$icon_no = 48
		case(3)		$icon_no = 49
		}
	case(<HHP_ITEM_ID_SKILL_POWER_MAX_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 50
		case(2)		$icon_no = 51
		case(3)		$icon_no = 52
		}
	case(<HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP>)
					$icon_no = 53
	case(<HHP_ITEM_ID_COMBO_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 54
		case(2)		$icon_no = 55
		case(3)		$icon_no = 56
		}
	case(<HHP_ITEM_ID_LIFE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 57
		case(2)		$icon_no = 58
		case(3)		$icon_no = 59
		}
	case(<HHP_ITEM_ID_STATUS_EFFECT_STUN>)
		switch( $item_level ) {
		case(1)		$icon_no = 60
		case(2)		$icon_no = 61
		case(3)		$icon_no = 62
		}
	case(<HHP_ITEM_ID_DAMAGE_LIFE_RECOVER>)
		switch( $item_level ) {
		case(1)		$icon_no = 63
		case(2)		$icon_no = 64
		case(3)		$icon_no = 65
		}
	case(<HHP_ITEM_ID_RIVIVAL>)
					$icon_no = 66
	case(<HHP_ITEM_ID_SPIKE_DAMAGE_UP>)
		switch( $item_level ) {
		case(1)		$icon_no = 67
		case(2)		$icon_no = 68
		case(3)		$icon_no = 69
		}
	case(<HHP_ITEM_ID_REROLL>)
		switch( $item_level ) {
		case(1)		$icon_no = 70
		case(2)		$icon_no = 71
		case(3)		$icon_no = 72
		}
	case(<HHP_ITEM_ID_STATUS_EFFECT_EXCITED>)
					$icon_no = 73
	case(<HHP_ITEM_ID_SE_CHANGE>)
					$icon_no = 74
	}
	
	return ($icon_no)
}

//---------------------------------------------------------------------------
// アイテムのクールタイムを更新する
//---------------------------------------------------------------------------
command $$update_item_cooldown(property $index)
{
	$item_cooldown[$index] -= $$get_delta_time
	
	if( $item_cooldown[$index] <= 0 )
	{
		$item_cooldown[$index] = $item_cooldown_max[$index]
		
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// アイテム取得時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_get(property $item_id, property $item_level)
{
	property $index
	
	switch( $item_id ) {
	
	case(<HHP_ITEM_ID_DAMAGE_UP>)		// 攻撃力アップ
		
		// 貫通攻撃
		switch( $item_level ) {
		case(2)		$$set_hhp_player_attack_penetration(1)		// Lv.2
		case(3)		$$set_hhp_player_attack_penetration(1)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_ATTACK_SLASH>)	// 縦横攻撃追加
		
		switch( $item_level ) {
		case(1)		$$set_hhp_player_attack_horizontal(1)		// Lv.1
		case(2)		$$set_hhp_player_attack_horizontal(1)		// Lv.2
					$$set_hhp_player_attack_vertical(1)
		case(3)		$$set_hhp_player_attack_horizontal(1)		// Lv.3
					$$set_hhp_player_attack_vertical(1)
		}
		
	case(<HHP_ITEM_ID_CRITICAL>)		// クリティカル発生
		
		// クリティカルダメージ倍率
		if( $item_level == 3 ) {
			$$add_hhp_player_critical_damage_rate(100)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_INVINCIBLE>)				// 無敵発生
		
		$index = $$get_hhp_item_list_index($item_id)
		
		$item_cooldown_max[$index] = 10000
		$item_cooldown[$index] = $item_cooldown_max[$index]
		
		// 無敵スタック
		if( $item_level == 3 ) {
			$$set_hhp_player_invincible_stack_flag(1)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)	// 無敵で攻撃を受けると攻撃力アップ
		
		$item_cooldown_max[$index] = 5000
		
	case(<HHP_ITEM_ID_LIFE_REGENERATION>)		// ライフ自動回復
		
		$index = $$get_hhp_item_list_index($item_id)
		
		switch( $item_level ) {
		case(1)		$item_cooldown_max[$index] = 10000		// Lv.1
		case(2)		$item_cooldown_max[$index] =  5000		// Lv.2
		case(3)		$item_cooldown_max[$index] =  5000		// Lv.3
		}
		
		$item_cooldown[$index] = $item_cooldown_max[$index]
		
	case(<HHP_ITEM_ID_DOUBLE_ATTACK>)		// 二重攻撃
		
		switch( $item_level ) {
		case(3)		$$set_hhp_player_attack_double(1)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)		// 永続的なライフ増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_player_life_max(10)		// Lv.1
		case(2)		$$add_hhp_player_life_max(10)		// Lv.2
		}
		
	case(<HHP_ITEM_ID_ATTACK_RANGE_UP>)	// 攻撃範囲アップ
		
		switch( $item_level ) {
		case(1)		$$set_hhp_player_attack_range_count_max(10)			// Lv.1
		case(2)		$$set_hhp_player_attack_range_count_max(7)			// Lv.2
		case(3)		$$set_hhp_player_attack_range_count_max(3)			// Lv.3
		}
		
	case(<HHP_ITEM_ID_SKILL_POWER_REGENERATION>)	// スキルパワー自動回復
		
		$index = $$get_hhp_item_list_index($item_id)
		
		switch( $item_level ) {
		case(1)		$item_cooldown_max[$index] = 2000		// Lv.1
		case(2)		$item_cooldown_max[$index] = 2000		// Lv.2
		case(3)		$item_cooldown_max[$index] = 2000		// Lv.3
		}
		
		$item_cooldown[$index] = $item_cooldown_max[$index]
		
	case(<HHP_ITEM_ID_SKILL_POWER_MAX_UP>)		// スキルパワー最大値増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_skill_power_max(<HHP_ACTIVATE_SKILL_POWER>)		// Lv.1
		case(2)		$$add_hhp_skill_power_max(<HHP_ACTIVATE_SKILL_POWER>)		// Lv.2
		case(3)		$$add_hhp_skill_power_max(<HHP_ACTIVATE_SKILL_POWER>)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_LIFE_UP>)					// ライフ増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_player_life_max(20)		// Lv.1
		case(2)		$$add_hhp_player_life_max(50)		// Lv.2
		case(3)		$$add_hhp_player_life_max(50)		// Lv.3
		}
		
		// プレイヤーシールド(フェンス)の画像を更新する(アイテムレベルに応じて)
		$$update_hhp_player_shield_image($$get_hhp_item_level($item_id))
		
	case(<HHP_ITEM_ID_SPIKE_DAMAGE_UP>)			// 反射ダメージアップ
		
		switch( $item_level ) {
		case(1)		$$add_hhp_player_spike_power(100)	// Lv.1
		case(2)		$$add_hhp_player_spike_power(100)	// Lv.2
		}
		
		
		
		
		
	case(<HHP_ITEM_ID_REROLL>)					// リロール増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_rewards_reroll_max(3)		// Lv.1
					$$add_hhp_rewards_reroll(3)
		case(2)		$$add_hhp_rewards_reroll_max(3)		// Lv.2
					$$add_hhp_rewards_reroll(3)
					$$add_hhp_rewards_high_tier_rate(100)
		case(3)		$$add_hhp_rewards_reroll_max(2)		// Lv.3
					$$add_hhp_rewards_reroll(2)
					$$add_hhp_rewards_high_tier_rate(300)
		}
		
	case(<HHP_ITEM_ID_SE_CHANGE>)				// ＳＥ変更
		
		$$set_hhp_player_se_type(1)
		
	}
}

//---------------------------------------------------------------------------
// アイテム破棄時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_del(property $item_id, property $item_level)
{
	switch( $item_id ) {
	
	case(<HHP_ITEM_ID_DAMAGE_UP>)		// 攻撃力アップ
		
		// 貫通攻撃
		switch( $item_level ) {
		case(2)		$$set_hhp_player_attack_penetration(0)		// Lv.2
		case(3)		$$set_hhp_player_attack_penetration(0)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_ATTACK_SLASH>)	// 縦横攻撃追加
		
		switch( $item_level ) {
		case(1)		$$set_hhp_player_attack_horizontal(0)		// Lv.1
		case(2)		$$set_hhp_player_attack_horizontal(0)		// Lv.2
					$$set_hhp_player_attack_vertical(0)
		case(3)		$$set_hhp_player_attack_horizontal(0)		// Lv.3
					$$set_hhp_player_attack_vertical(0)
		}
		
	case(<HHP_ITEM_ID_CRITICAL>)		// クリティカル発生
		
		// クリティカルダメージ倍率
		if( $item_level == 3 ) {
			$$add_hhp_player_critical_damage_rate(-100)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_INVINCIBLE>)				// 無敵発生
		
		// 無敵スタック
		if( $item_level == 3 ) {
			$$set_hhp_player_invincible_stack_flag(0)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)		// 永続的なライフ増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_player_life_max(-10)		// Lv.1
		}
		
	case(<HHP_ITEM_ID_DOUBLE_ATTACK>)		// 二重攻撃
		
		switch( $item_level ) {
		case(3)		$$set_hhp_player_attack_double(0)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_ATTACK_RANGE_UP>)	// 攻撃範囲アップ
		
		switch( $item_level ) {
		case(1)		$$set_hhp_player_attack_range_count_max(0)			// Lv.1
		case(2)		$$set_hhp_player_attack_range_count_max(0)			// Lv.2
		case(3)		$$set_hhp_player_attack_range_count_max(0)			// Lv.3
		}
		
	case(<HHP_ITEM_ID_SKILL_POWER_MAX_UP>)		// スキルパワー最大値増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_skill_power_max(-<HHP_ACTIVATE_SKILL_POWER> * 1)		// Lv.1
		case(2)		$$add_hhp_skill_power_max(-<HHP_ACTIVATE_SKILL_POWER> * 2)		// Lv.2
		case(3)		$$add_hhp_skill_power_max(-<HHP_ACTIVATE_SKILL_POWER> * 3)		// Lv.3
		}
		
	case(<HHP_ITEM_ID_LIFE_UP>)					// ライフ増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_player_life_max(-20)					// Lv.1
		case(2)		$$add_hhp_player_life_max(-(20 + 50))			// Lv.2
		case(3)		$$add_hhp_player_life_max(-(20 + 50 + 50))		// Lv.3
		}
		
		// プレイヤーシールド(フェンス)の画像を更新する(アイテムレベルに応じて)
		$$update_hhp_player_shield_image($$get_hhp_item_level($item_id))
		
	case(<HHP_ITEM_ID_SPIKE_DAMAGE_UP>)			// 反射ダメージアップ
		
		switch( $item_level ) {
		case(1)		$$add_hhp_player_spike_power(-100)				// Lv.1
		case(2)		$$add_hhp_player_spike_power(-(100 + 100))		// Lv.2
		}
		
	case(<HHP_ITEM_ID_REROLL>)					// リロール増加
		
		switch( $item_level ) {
		case(1)		$$add_hhp_rewards_reroll_max(-3)				// Lv.1
					$$add_hhp_rewards_reroll(-3)
		case(2)		$$add_hhp_rewards_reroll_max(-(3 + 3))			// Lv.2
					$$add_hhp_rewards_reroll(-(3 + 3))
					$$add_hhp_rewards_high_tier_rate(-100)
		case(3)		$$add_hhp_rewards_reroll_max(-(3 + 3 + 2))		// Lv.3
					$$add_hhp_rewards_reroll(-(3 + 3 + 2))
					$$add_hhp_rewards_high_tier_rate(-(100 + 300))
		}
		
		
		
		
		
		
	case(<HHP_ITEM_ID_SE_CHANGE>)				// ＳＥ変更
		
		$$set_hhp_player_se_type(0)
		
	}
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_update
{
	property $i
	property $len
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)		// 無敵で攻撃を受けると攻撃力アップ
			
			if( $item_cooldown[$i] > 0 ) {
				$item_cooldown[$i] -= $$get_delta_time
			}
			
		case(<HHP_ITEM_ID_LIFE_REGENERATION>)		// ライフ自動回復
			
			if( $$update_item_cooldown($i) )
			{
				switch( $$get_hhp_item_level_from_list_index($i) ) {
				case(1)		$$add_hhp_player_life(3)		// Lv.1
				case(2)		$$add_hhp_player_life(3)		// Lv.2
				case(3)		$$add_hhp_player_life(7)		// Lv.3
				}
			}
			
		case(<HHP_ITEM_ID_INVINCIBLE>)				// 無敵発生
			
			if( $$update_item_cooldown($i) )
			{
				switch( $$get_hhp_item_level_from_list_index($i) ) {
				case(1)		$$set_hhp_player_invincible_time(1000)		// Lv.1
				case(2)		$$set_hhp_player_invincible_time(2000)		// Lv.2
				case(3)		$$set_hhp_player_invincible_time(2000)		// Lv.3
				}
			}
			
		case(<HHP_ITEM_ID_SKILL_POWER_REGENERATION>)	// スキルパワー自動回復
			
			if( $$update_item_cooldown($i) )
			{
				switch( $$get_hhp_item_level_from_list_index($i) ) {
				case(1)		$$add_hhp_skill_power(5)		// Lv.1
				case(2)		$$add_hhp_skill_power(10)		// Lv.2
				case(3)		$$add_hhp_skill_power(10)		// Lv.3
				}
			}
		}
	}
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するプレイヤーの攻撃力を計算するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_update_player_attack_power : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_DAMAGE_UP>)				// 攻撃力アップ
			
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$power += 10			// Lv.1
			case(2)		$power += 10			// Lv.2
			case(3)		$power += 40			// Lv.3
			}
			
		case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)		// 永続的なライフ増加
			
			$power += 10
			
		case(<HHP_ITEM_ID_SKILL_POWER_REGENERATION>)	// スキルパワー自動回復
			
			if( $$get_hhp_item_level_from_list_index($i) == 3 ) {
				$power += 10 * ($$get_hhp_skill_power / <HHP_ACTIVATE_SKILL_POWER>)
			}
			
		case(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)		// 無敵でないとき攻撃力アップ
			
			// 無敵状態でないとき
			if( $$get_hhp_player_invincible_time == 0 )
			{
				switch( $$get_hhp_item_level_from_list_index($i) ) {
				case(1)		$power += 10			// Lv.1
				case(2)		$power += 10			// Lv.2
				case(3)		$power += 40			// Lv.3
				}
			}
			
		case(<HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP>)		// 状態異常に攻撃力アップ
			
			if( $$get_hhp_item_level_from_list_index($i) >= 3 )
			{
				$power += 40					// Lv.3
			}
			
		case(<HHP_ITEM_ID_COMBO_UP>)		// コンボ数が多いほど攻撃力／回復力アップ
			
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$power += math.linear(math.limit(0, $$get_hhp_player_combo, 99), 0, 0, 99, 20)		// Lv.1
			case(2)		$power += math.linear(math.limit(0, $$get_hhp_player_combo, 99), 0, 0, 99, 20)		// Lv.2
			case(3)		$power += math.linear(math.limit(0, $$get_hhp_player_combo, 99), 0, 0, 99, 40)		// Lv.3
			}
			
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するプレイヤーの攻撃力補正値（乗算）を計算するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_update_player_attack_power_rate : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)		// 無敵で攻撃を受けると攻撃力アップ
			
			if( $item_cooldown[$i] > 0 ) {
				$power += 100
			}
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するプレイヤーの攻撃範囲を計算するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_update_player_attack_range : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_ATTACK_RANGE_UP>)	// 攻撃範囲アップ
			
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$power += 1			// Lv.1
			case(2)		$power += 2			// Lv.2
			case(3)		$power += 3			// Lv.3
			}
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するプレイヤーのクリティカル率を計算するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_update_player_critical_rate : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_CRITICAL>)		// クリティカル発生
			
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$power += 15		// Lv.1
			case(2)		$power += 50		// Lv.2
			case(3)		$power += 50		// Lv.3
			}
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するプレイヤーのスタン力を計算するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_update_player_stun_power : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_STATUS_EFFECT_STUN>)	// スタン付与
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$power +=  500			// Lv.1
			case(2)		$power += 1000			// Lv.2
			case(3)		$power += 2000			// Lv.3
			}
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// 毎フレームごとに発生するプレイヤーの回復力を計算するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_update_player_regen_power : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_COMBO_UP>)		// コンボ数が多いほど攻撃力／回復力アップ
			
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$power += math.linear(math.limit(0, $$get_hhp_player_combo, 99), 0, 0, 99, 50)		// Lv.1
			case(2)		$power += math.linear(math.limit(0, $$get_hhp_player_combo, 99), 0, 0, 99, 50)		// Lv.2
			case(3)		$power += math.linear(math.limit(0, $$get_hhp_player_combo, 99), 0, 0, 99, 100)		// Lv.3
			}
			
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// プレイヤーのスキルパワーがストックされた時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_player_skill_power_stock : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_SKILL_POWER_MAX_UP>)		// スキルパワー最大値増加
			
			// Lv.3
			if( $$get_hhp_item_level_from_list_index($i) >= 3 )
			{
				// すべての敵にダメージを与える
				$$damage_hhp_all_enemy($$get_hhp_player_total_attack_power)
			}
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// プレイヤーが回復した時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_player_life_recover(property $value, property $over_value)
{
	property $i
	property $len
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)			// 永続的なライフ増加
			
			if( $over_value <= 0 ) {
				continue
			}
			
			if( $$get_hhp_item_level_from_list_index($i) >= 2 )
			{
				$$add_hhp_score($over_value * 100)
			}
			
			if( $$get_hhp_item_level_from_list_index($i) >= 3 )
			{
				if( $$add_hhp_player_life_permanently($over_value) )
				{
					$$add_hhp_player_life_max(1)
					$$add_hhp_player_life(1)
				}
			}
			
		case(<HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER>)	// ウェーブ終了後ライフ回復
			
			if( $over_value <= 0 ) {
				continue
			}
			
			if( $$get_hhp_item_level_from_list_index($i) >= 2 )
			{
				$over_value = $over_value * 100 / $$get_hhp_player_life_max
				$$set_hhp_player_invincible_time_rate(1000 + $over_value * 10)
			}
			
		case(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)		// 無敵でないとき攻撃力アップ
			
			if( $over_value <= 0 ) {
				continue
			}
			
			// 永続的な攻撃力増加
			if( $$get_hhp_item_level_from_list_index($i) >= 3 )
			{
				if( $$add_hhp_player_attack_power_permanently($over_value) )
				{
					$$add_hhp_player_attack_power(1)
				}
			}
			
		}
	}
}

//---------------------------------------------------------------------------
// プレイヤーがダメージを受けた時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_player_damage(property $enemy_obj : object)
{
	property $i
	property $len
	property $value
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)	// 無敵で攻撃を受けると攻撃力アップ
			
			$item_cooldown[$i] = $item_cooldown_max[$i]
			
		case(<HHP_ITEM_ID_SPIKE>)				// 反射ダメージ
			
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$value = $$get_hhp_player_life_max / 2		// Lv.1
			case(2)		$value = $$get_hhp_player_life_max			// Lv.2
			case(3)		$value = $$get_hhp_player_life_max			// Lv.3
			}
			
			$value = ($value + $$hhp_item_trigger_on_player_attack_power_from_enemy($enemy_obj, 0)) * $$get_hhp_player_spike_power / 100
			$value = 1
			$$damage_hhp_enemy($enemy_obj, $value)
			
			// 近くの敵にダメージを連鎖する
			if( $$get_hhp_item_level_from_list_index($i) == 3 ) {
				$$damage_defegg_enemy_near($enemy_obj, $$get_hhp_player_life_max)
			}
			
		case(<HHP_ITEM_ID_SPIKE_DAMAGE_UP>)			// 反射ダメージアップ
			
			if( $$get_hhp_item_level_from_list_index($i) == 3 ) {
				$$on_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_ANGRY>)
			}
		}
	}
}

//---------------------------------------------------------------------------
// プレイヤーのライフがなくなった時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_player_dead : int
{
	property $i
	property $len
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_RIVIVAL>)		// ライフ０時に復活
			
			// 復活可能なら復活処理
			if( $$get_hhp_player_rivival_flag == 0 )
			{
				@mng_counter.stop
				
				// 蘇生エフェクト再生
				$$play_hhp_rivive_effect(front.object[<HHP_OBJ_CUTIN>])
				
				// プレイヤーのＨＰを１加算する
				$$add_hhp_player_life(1)
				
				// 蘇生後の無敵時間を設定する
				$$set_hhp_player_invincible_time(3000)
				
				// 蘇生実行済みフラグをオンにする
				$$set_hhp_player_rivival_flag(1)
				
				@mng_counter.resume
				
				return (1)
			}
		}
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// 敵が出現した時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_spawn_enemy(property $enemy_obj : object)
{
	property $i
	property $len
	property $value
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>)	// スロウ付与
			
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$value = 50		// Lv.1
			case(2)		$value = 100	// Lv.2
			case(3)		$value = 100	// Lv.3
			}
			
			// ミニゲーム用の疑似乱数は使わない
			if( math.rand(0, 99) < $value )
			{
				// スロウを付与する
				$$on_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_SLOW>)
			}
			
			// Lv.3はダメージを受けた状態で出現する
			if( $$get_hhp_item_level_from_list_index($i) >= 3 ) {
				$$add_hhp_enemy_life($enemy_obj, -9)
			}
			
		case(<HHP_ITEM_ID_STATUS_EFFECT_EXCITED>)	// 興奮付与
			
			// 興奮を付与する
			$$on_hhp_enemy_status_effect($enemy_obj, <HHP_ENEMY_STATUS_EFFECT_EXCITED>)
		}
	}
}

//---------------------------------------------------------------------------
// 敵がダメージ受けた時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_enemy_damage(property $enemy_obj : object, property $critical)
{
	property $i
	property $len
	property $value1
	property $value2
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
		
		case(<HHP_ITEM_ID_DOUBLE_ATTACK>)		// 二重攻撃
			
			if( $critical ) {
				$$add_hhp_skill_power(5)
			}
			
		case(<HHP_ITEM_ID_DAMAGE_LIFE_RECOVER>)	// 攻撃ダメージ発生時にライフ回復
			
			// ライフ回復の発生率（％）を設定する
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$value1 = 10	$value2 = 1		// Lv.1
			case(2)		$value1 = 10	$value2 = 1		// Lv.2
			case(3)		$value1 = 10	$value2 = 2		// Lv.3
			}
			
			// ミニゲーム用の疑似乱数は使わない
			if( math.rand(0, 99) < $value1 )
			{
				// プレイヤーが最大ライフの場合はスキルパワーも回復する
				if( $$get_hhp_player_life == $$get_hhp_player_life_max )
				{
					switch( $$get_hhp_item_level_from_list_index($i) ) {
					case(2)		$value2 = 1		// Lv.2
					case(3)		$value2 = 2		// Lv.3
					}
					
					$$add_hhp_skill_power($value2)
				}
				
				// ライフを回復する
				$$add_hhp_player_life($value2)
			}
		}
	}
}

//---------------------------------------------------------------------------
// 敵のライフがなくなった時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_enemy_dead(property $enemy_obj : object)
{
	property $i
	property $len
	property $value
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_ATTACK_SLASH>)	// 縦横攻撃追加
			
			if( $$get_hhp_item_level_from_list_index($i) == 3 )
			{
				$$damage_defegg_enemy_near($enemy_obj, $$get_hhp_player_total_attack_power)
			}
			
		case(<HHP_ITEM_ID_STATUS_EFFECT_CONVERT>)		// 相手が倒れた時、近くにいる敵に状態異常を移す
			
		}
	}
}

//---------------------------------------------------------------------------
// プレイヤーがダメージを与える際に発生するイベント（敵の状態からの総攻撃力を取得）
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_player_attack_power_from_enemy(property $enemy_obj : object, property $critical) : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_DOUBLE_ATTACK>)		// 二重攻撃
			
			// クリティカルが発生している場合
			if( $critical )
			{
				// 敵が何らかのバフ／デバフ状態になっている場合
				if( $$has_hhp_enemy_any_status_effect($enemy_obj) )
				{
					if( $$get_hhp_item_level_from_list_index($i) >= 2 ) {
						$power += 20
					}
				}
			}
			
		case(<HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP>)		// 状態異常に攻撃力アップ
			
			// 敵が何らかのバフ／デバフ状態になっている場合
			if( $$has_hhp_enemy_any_status_effect($enemy_obj) )
			{
				switch( $$get_hhp_item_level_from_list_index($i) ) {
				case(1)		$power += 10		// Lv.1
				case(2)		$power += 40		// Lv.2
				case(3)		$power += 40		// Lv.3
				}
			}
			
		case(<HHP_ITEM_ID_LIFELESS_DAMAGE_UP>)		// ダメージを受けている相手に攻撃力アップ
			
			// 敵のライフが最大でない場合
			if( $$is_hhp_enemy_life_max($enemy_obj) == 0 )
			{
				switch( $$get_hhp_item_level_from_list_index($i) ) {
				case(1)		$power += 10		// Lv.1
				case(2)		$power += 40		// Lv.2
				case(3)		$power += 40		// Lv.3
				}
			}
			
		case(<HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP>)		// 状態異常の数が多いほど攻撃力アップ
			
			$power += 2 * $$get_hhp_enemy_status_effect_count($enemy_obj)
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// プレイヤーがダメージを与える際に発生するイベント（敵の状態からのクリティカル発生率を取得）
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_player_attack_critical_rate_from_enemy(property $enemy_obj : object) : int
{
	property $i
	property $len
	property $power
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_LIFELESS_DAMAGE_UP>)		// ダメージを受けている相手に攻撃力アップ
			
			if( $$is_hhp_enemy_life_max($enemy_obj) == 0 )
			{
				switch( $$get_hhp_item_level_from_list_index($i) ) {
				case(3)		$power += 50		// Lv.3
				}
			}
		}
	}
	
	return ($power)
}

//---------------------------------------------------------------------------
// ウェーブ終了時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_item_trigger_on_wave_finished
{
	property $i
	property $len
	property $value
	
	$len = $items.get_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		switch( $$get_hhp_item_id_from_list_index($i) ) {
			
		case(<HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER>)	// ウェーブ終了後ライフ回復
			
			// ライフの回復率を取得する（最大ライフ％）
			switch( $$get_hhp_item_level_from_list_index($i) ) {
			case(1)		$value = $$get_hhp_player_life_max *  30 / 100		// Lv.1
			case(2)		$value = $$get_hhp_player_life_max *  50 / 100		// Lv.2
			case(3)		$value = $$get_hhp_player_life_max * 100 / 100		// Lv.3
			}
			
			// ライフを回復する
			$$add_hhp_player_life($value)
			
		case(<HHP_ITEM_ID_LIFE_UP>)					// ライフ増加
			
			// Lv.3は最大ライフを増加する
			if( $$get_hhp_item_level_from_list_index($i) >= 3 ) {
				$$add_hhp_player_life_max(20)
				$$add_hhp_player_life(20)
			}
		}
	}
}
