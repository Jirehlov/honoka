//===========================================================================
//!
//!    @file     ___mng_hhp_player.ss
//!    @brief    ヘビヘビパニックプレイヤーデータ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// プレイヤーデータ
	#replace	<LIFE_DEFAULT>			10		// ライフ初期値
	#replace	<LIFE_MAX>				999		// ライフ最大値
	
	#property	$life							// ライフ
	#property	$life_max						// 最大ライフ
	
	#replace	<LIFE_PERMANETLY_MAX>	100		// 永続ライフ最大値
	
	#property	$life_permanently				// 永続ライフ
	
	#replace	<ATTACK_POWER_DEFAULT>	10		// 攻撃力初期値
	#replace	<ATTACK_POWER_MAX>		999		// 攻撃力最大値
	
	#property	$attack_power					// 攻撃力／基礎
	#property	$total_attack_power				// 攻撃力／アイテム含む
	#property	$total_attack_power_rate		// 攻撃力補正値（乗算）／アイテム含む
	
	#replace	<ATTACK_POWER_PERMANETLY_MAX>	100		// 永続攻撃力最大値
	
	#property	$attack_power_permanently		// 永続攻撃力
	
	#replace	<ATTACK_RANGE_DEFAULT>	1		// 攻撃範囲初期値
	#replace	<ATTACK_RANGE_MAX>		5		// 攻撃範囲最大値
	
	#property	$attack_range					// 攻撃範囲
	#property	$attack_range_count				// 現在の広範囲攻撃になるまでの攻撃回数
	#property	$attack_range_count_max			// 広範囲攻撃になるまでの攻撃回数
	#property	$total_attack_range				// 攻撃範囲／アイテム含む
	
	#property	$attack_double					// 二重攻撃フラグ
	#property	$attack_penetration				// 貫通攻撃フラグ
	#property	$attack_horizontal				// 水平攻撃フラグ
	#property	$attack_vertical				// 垂直攻撃フラグ
	
	#replace	<CRITICAL_RATE_DEFAULT>	0		// クリティカル率初期値
	#replace	<CRITICAL_RATE_MAX>		200		// クリティカル率最大値
	
	#property	$critical_rate					// クリティカル率／基礎
	#property	$total_critical_rate			// クリティカル率／アイテム含む
	
	#replace	<CRITICAL_DAMAGE_RATE_DEFAULT>	200		// クリティカルダメージ倍率初期値
	#replace	<CRITICAL_DAMAGE_RATE_MAX>		500		// クリティカルダメージ倍率最大値
	
	#property	$critical_damage_rate			// クリティカルダメージ倍率
	
	#replace	<STUN_POWER_DEFAULT>	0		// スタン力初期値
	#replace	<STUN_POWER_MAX>		99		// スタン力最大値
	
	#property	$stun_power						// スタン力／基礎
	#property	$total_stun_power				// スタン力／アイテム含む
	
	#replace	<REGEN_POWER_DEFAULT>	100		// 回復力初期値
	#replace	<REGEN_POWER_MAX>		999		// 回復力最大値
	
	#property	$regen_power					// 回復力／基礎
	#property	$total_regen_power				// 回復力／アイテム含む
	
	#replace	<SPIKE_POWER_DEFAULT>	 100	// スパイク（カウンターダメージ）初期値
	#replace	<SPIKE_POWER_MAX>		1000	// スパイク（カウンターダメージ）最大値
	
	#property	$spike_power					// スパイク（カウンターダメージ）
	
	#property	$invincible_enable				// 無敵有効フラグ
	#property	$invincible_time				// 無敵時間
	#property	$invincible_time_rate			// 無敵時間補正
	#property	$invincible_stack_flag			// 無敵スタックフラグ
	
	#property	$rivival						// 蘇生フラグ
	
	#property	$combo							// コンボ数
	#property	$combo_max						// 最大コンボ数
	
	#replace	<COMBO_TIMER_MAX>				3000		// コンボ継続タイマー最大値
	
	#property	$combo_timer					// コンボ継続タイマー
	
	#property	$attacked_damage_max			// 最大ダメージ
	
	#replace	<SCORE_MAX>			99999999	// スコア最大値
	
	#property	$score							// スコア
	#property	$hi_score						// ハイスコア
	
	#property	$play_level						// プレイレベル(難易度)
	#property	$play_mode						// プレイモード
	#property	$play_count : intlist			// プレイ回数
	#property	$play_result					// プレイ結果
	
	// 入力
	#property	$push_attack_key				// 攻撃ボタンを押しているか
	#property	$push_attack_key_repeat			// 攻撃ボタン押下（キーリピートカウント）
	#property	$push_attack_key_repeat_max		// 攻撃ボタン押下（キーリピートカウント最大）
	
	// システム
	#property	$pause							// 一時停止
	#property	$auto_play						// オートプレイ
	
	// 報酬
	#replace	<REWARDS_SELECT_MAX>	3		// 報酬選択数最大値
	
	#property	$rewards_list : intlist			// 報酬リスト
	#property	$rewards_total					// 報酬総発生回数
	
	#replace	<REWARDS_NUM_MAX>		9		// 報酬個数最大数
	
	#property	$rewards_num					// 報酬個数
	
	#replace	<REWARDS_HIGH_TIER_RATE_MAX>	100		// 報酬高レアティ最大値
	
	#property	$rewards_high_tier_rate			// 報酬高レアリティ発生率
	
	#replace	<REWARDS_REROLL_DEFAULT>	1	// 報酬リロール回数初期値
	#replace	<REWARDS_REROLL_MAX>		9	// 報酬リロール回数最大値
	
	#property	$rewards_reroll					// 報酬リロール回数
	#property	$rewards_reroll_max				// 報酬リロール最大回数
	
	// デバッグ
	#property	$god_mode						// ゴッドモード（無敵／1=ダメージは受けるけど死なない／2=ダメージを受けない）
	#property	$rewards_weight : intlist[<HHP_ITEM_ID_MAX>]	// 報酬の各重み
	#property	$rewards_rand : intlist							// 報酬選択乱数値
	
	
	// todo
	#property	$se_type
	
	#property $direct_attack
	#property $attacking
	
#inc_end

#z00

//---------------------------------------------------------------------------
// プレイヤーデータの初期化(初回)
//---------------------------------------------------------------------------
command $$init_hhp_player_data
{
	// ※初回に設定が必要なものだけ設定する
	// ※各プレイごとに初期化するものは"$$restart_hhp_player_data"へ
	
	// プレイヤー
	$life_max = <LIFE_DEFAULT>
	$life_permanently = 0
	$attack_power = <ATTACK_POWER_DEFAULT>
	$attack_power_permanently = 0
	$attack_range = <ATTACK_RANGE_DEFAULT>
	$attack_range_count_max = 0
	$attack_double = 0
	$attack_penetration = 0
	$attack_horizontal = 0
	$attack_vertical = 0
	$critical_rate = <CRITICAL_RATE_DEFAULT>
	$critical_damage_rate = <CRITICAL_DAMAGE_RATE_DEFAULT>
	$stun_power = <STUN_POWER_DEFAULT>
	$regen_power = <REGEN_POWER_DEFAULT>
	$invincible_enable = 1
	$invincible_time_rate = 1000
	$invincible_stack_flag = 0
	$hi_score = 0
	$play_level = <HHP_PLAY_LEVEL_MIN>
	$play_count.init
	$play_count.resize(<HHP_PLAY_LEVEL_MAX> - <HHP_PLAY_LEVEL_MIN> + 1)
	
	// アイテム
	$$init_hhp_item_data
	
	// スキル
	$$init_hhp_skill_data
	
	// 入力
	$push_attack_key_repeat_max = 250
	
	// 報酬
	$rewards_total = 0
	$rewards_reroll_max = <REWARDS_REROLL_DEFAULT>
	
	// プレイヤーデータの初期化(再ゲーム開始時)
	$$restart_hhp_player_data
}

//---------------------------------------------------------------------------
// プレイヤーデータの初期化(再ゲーム開始時)
//---------------------------------------------------------------------------
command $$restart_hhp_player_data
{
	// プレイヤー
	$life = $life_max
	$attack_range_count = 0
	$invincible_time = 0
	$spike_power = <SPIKE_POWER_DEFAULT>
	$rivival = 0
	$combo = 0
	$combo_max = 0
	$combo_timer = 0
	$attacked_damage_max = 0
	$score = 0
	$play_result = <HHP_PLAY_RESULT_NONE>
	
	$total_attack_power_rate = 100 + $$hhp_item_trigger_on_update_player_attack_power_rate
	$total_attack_power = ($attack_power + $$hhp_item_trigger_on_update_player_attack_power) * $total_attack_power_rate / 100
	$total_attack_range = $attack_range + $$hhp_item_trigger_on_update_player_attack_range
	$total_critical_rate = $critical_rate + $$hhp_item_trigger_on_update_player_critical_rate
	$total_stun_power = $stun_power + $$hhp_item_trigger_on_update_player_stun_power
	$total_regen_power = $regen_power + $$hhp_item_trigger_on_update_player_regen_power
	
	// アイテム
	$$restart_hhp_item_data
	
	// スキル
	$$restart_hhp_skill_data
	
	// 入力
	$push_attack_key = 0
	$push_attack_key_repeat = 0
	
	// システム
	$pause = 0
	$auto_play = 0
	
	// 報酬
	$rewards_list.init
	$rewards_num = 0
	$rewards_high_tier_rate = 0
	$rewards_reroll = $rewards_reroll_max
	
	// デバッグ
	$god_mode = 0
}

//---------------------------------------------------------------------------
// プレイヤーデータの更新
//---------------------------------------------------------------------------
command $$update_hhp_player_data
{
	// 無敵時間
	$invincible_time -= $$get_delta_time
	
	if( $invincible_time < 0 ) {
		$invincible_time = 0
	}
	
	// コンボ数
	$combo_timer -= $$get_delta_time
	
	if( $combo_timer < 0 ) {
		$combo_timer = 0
		$combo = 0
	}
	
	// 攻撃力補正値（乗算）の計算／アイテム含む
	$total_attack_power_rate = 100 + $$hhp_item_trigger_on_update_player_attack_power_rate
	
	// 攻撃力の計算／アイテム含む
	$total_attack_power = ($attack_power + $$hhp_item_trigger_on_update_player_attack_power) * $total_attack_power_rate / 100
	
	// 攻撃範囲の計算／アイテム含む
	$total_attack_range = $attack_range + $$hhp_item_trigger_on_update_player_attack_range
	
	// クリティカル率の計算／アイテム含む
	$total_critical_rate = $critical_rate + $$hhp_item_trigger_on_update_player_critical_rate
	
	// スタン力の計算／アイテム含む
	$total_stun_power = $stun_power + $$hhp_item_trigger_on_update_player_stun_power
	
	// 回復力の計算／アイテム含む
	$total_regen_power = $regen_power + $$hhp_item_trigger_on_update_player_regen_power
	
	// deb
	$attacking = 0
}

//---------------------------------------------------------------------------
// プレイヤーライフを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_life : int { return ($life) }
command $$set_hhp_player_life(property $value)
{
	// 無敵中の場合は処理しない
	if( $invincible_time > 0 ) {
		return
	}
	
	$life = $value
	
	// ゴッドモード(無敵)のライフを０にしない
	if( $god_mode && $life <= 0 ) {
		$life = 1
	}
}

command $$add_hhp_player_life(property $value)
{
	property $overflow
	
	// ゴッドモード（ダメージを受けない）の場合は処理しない
	if( $god_mode == <HHP_GOD_MODE_NO_DAMAGE> && $value < 0 ) {
		return
	}
	
	// 無敵かつダメージの場合は処理しない
	if( $invincible_time > 0 && $value < 0 ) {
		return
	}
	
	// 回復率を計算する
	if( 0 < $value ) {
		$value = $value * $total_regen_power / 100
	}
	
	// 超過した回復量を計算する
	$overflow = $value + $$get_hhp_player_life_max - $$get_hhp_player_life
	
	// ライフを増減する
	$life = math.limit(0, $life + $value, $life_max)
	
	// プレイヤーが回復した時に発生するイベント
	$$hhp_item_trigger_on_player_life_recover($value, $overflow)
	
	// ゴッドモード(無敵)の場合は処理しない
	if( $god_mode && $life <= 0 ) {
		$life = 1
	}
}

//---------------------------------------------------------------------------
// プレイヤー最大ライフを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_life_max : int { return ($life_max) }
command $$set_hhp_player_life_max(property $value) { $life_max = math.limit(1, $value, <LIFE_MAX>) }
command $$add_hhp_player_life_max(property $value)
{
	$life_max = math.limit(1, $life_max + $value, <LIFE_MAX>)
	$life = math.limit(0, $life + $value, $life_max)
}

//---------------------------------------------------------------------------
// プレイヤー永続ライフを取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_life_permanently : int { return ($life_permanently) }
command $$add_hhp_player_life_permanently(property $value) : int
{
	$life_permanently += $value
	
	if( $life_permanently > <LIFE_PERMANETLY_MAX> )
	{
		$life_permanently = $life_permanently - <LIFE_PERMANETLY_MAX>
		
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// プレイヤーの攻撃力を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_power : int { return ($attack_power) }
command $$set_hhp_player_attack_power(property $value) { $attack_power = $value }
command $$add_hhp_player_attack_power(property $value) { $attack_power = math.limit(0, $attack_power + $value, <ATTACK_POWER_MAX>) }

//---------------------------------------------------------------------------
// プレイヤーの攻撃力補正値／乗算を取得する（アイテム含む）
//---------------------------------------------------------------------------
command $$get_hhp_player_total_attack_power_rate : int { return ($total_attack_power_rate) }

//---------------------------------------------------------------------------
// プレイヤーの攻撃力を取得する（アイテム含む）
//---------------------------------------------------------------------------
command $$get_hhp_player_total_attack_power : int { return ($total_attack_power) }

//---------------------------------------------------------------------------
// プレイヤー永続攻撃力を取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_power_permanently : int { return ($attack_power_permanently) }
command $$add_hhp_player_attack_power_permanently(property $value) : int
{
	$attack_power_permanently += $value
	
	if( $attack_power_permanently > <ATTACK_POWER_PERMANETLY_MAX> )
	{
		$attack_power_permanently = $attack_power_permanently - <ATTACK_POWER_PERMANETLY_MAX>
		
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// プレイヤーの攻撃範囲を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_range : int { return ($attack_range) }
command $$set_hhp_player_attack_range(property $value) { $attack_range = $value }
command $$add_hhp_player_attack_range(property $value) { $attack_range = math.limit(0, $attack_range + $value, <ATTACK_RANGE_MAX>) }

//---------------------------------------------------------------------------
// プレイヤーの攻撃範囲を取得する（アイテム含む）
//---------------------------------------------------------------------------
command $$get_hhp_player_total_attack_range : int { return ($total_attack_range) }

//---------------------------------------------------------------------------
// プレイヤーの広範囲攻撃になるまでの攻撃回数を取得／加算／初期化する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_range_count : int { return ($attack_range_count) }
command $$add_hhp_player_attack_range_count(property $value) { $attack_range_count = math.limit(0, $attack_range_count + $value, $attack_range_count_max) }
command $$reset_hhp_player_attack_range_count { $attack_range_count = 0 }

//---------------------------------------------------------------------------
// プレイヤーの広範囲攻撃になるまでの攻撃回数を取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_range_count_max : int { return ($attack_range_count_max) }
command $$set_hhp_player_attack_range_count_max(property $value) { $attack_range_count_max = $value }

//---------------------------------------------------------------------------
// プレイヤーの二重攻撃フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_double : int { return ($attack_double) }
command $$set_hhp_player_attack_double(property $flag) { $attack_double = $flag }

//---------------------------------------------------------------------------
// プレイヤーの貫通攻撃フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_penetration : int { return ($attack_penetration) }
command $$set_hhp_player_attack_penetration(property $flag) { $attack_penetration = $flag }

//---------------------------------------------------------------------------
// プレイヤーの水平攻撃フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_horizontal : int { return ($attack_horizontal) }
command $$set_hhp_player_attack_horizontal(property $flag) { $attack_horizontal = $flag }

//---------------------------------------------------------------------------
// プレイヤーの垂直攻撃フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_attack_vertical : int { return ($attack_vertical) }
command $$set_hhp_player_attack_vertical(property $flag) { $attack_vertical = $flag }

//---------------------------------------------------------------------------
// プレイヤーのクリティカル率を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_critical_rate : int { return ($critical_rate) }
command $$set_hhp_player_critical_rate(property $value) { $critical_rate = math.limit(<CRITICAL_RATE_DEFAULT>, $value, <CRITICAL_RATE_MAX>) }
command $$add_hhp_player_critical_rate(property $value) { $critical_rate = math.limit(<CRITICAL_RATE_DEFAULT>, $critical_rate + $value, <CRITICAL_RATE_MAX>) }

//---------------------------------------------------------------------------
// プレイヤーのクリティカル率を取得する（アイテム含む）
//---------------------------------------------------------------------------
command $$get_hhp_player_total_critical_rate : int { return ($total_critical_rate) }

//---------------------------------------------------------------------------
// プレイヤーのクリティカルダメージ倍率を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_critical_damage_rate : int { return ($critical_damage_rate) }
command $$set_hhp_player_critical_damage_rate(property $value) { $critical_damage_rate = math.limit(<CRITICAL_DAMAGE_RATE_DEFAULT>, $value, <CRITICAL_DAMAGE_RATE_MAX>) }
command $$add_hhp_player_critical_damage_rate(property $value) { $critical_damage_rate = math.limit(<CRITICAL_DAMAGE_RATE_DEFAULT>, $critical_damage_rate + $value, <CRITICAL_DAMAGE_RATE_MAX>) }

//---------------------------------------------------------------------------
// プレイヤーのスタン力を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_stun_power : int { return ($stun_power) }
command $$set_hhp_player_stun_power(property $value) { $stun_power = $value }
command $$add_hhp_player_stun_power(property $value) { $stun_power = math.limit(0, $stun_power + $value, <STUN_POWER_MAX>) }

//---------------------------------------------------------------------------
// プレイヤーのスタン力を取得する（アイテム含む）
//---------------------------------------------------------------------------
command $$get_hhp_player_total_stun_power : int { return ($total_stun_power) }

//---------------------------------------------------------------------------
// プレイヤーの回復率を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_player_regen_power : int { return ($regen_power) }
command $$set_hhp_player_regen_power(property $value) { $regen_power = $value }
command $$add_hhp_player_regen_power(property $value) { $regen_power = math.limit(0, $regen_power + $value, <REGEN_POWER_MAX>) }

//---------------------------------------------------------------------------
// プレイヤーの回復率を取得する（アイテム含む）
//---------------------------------------------------------------------------
command $$get_hhp_player_total_regen_power : int { return ($total_regen_power) }

//---------------------------------------------------------------------------
// プレイヤーのスパイク（カウンターダメージ）を取得／加算／リセットする
//---------------------------------------------------------------------------
command $$get_hhp_player_spike_power : int { return ($spike_power) }
command $$add_hhp_player_spike_power(property $value) { $spike_power = math.limit(0, $spike_power + $value, <SPIKE_POWER_MAX>) }
command $$reset_hhp_player_spike_power { $spike_power = 0 }

//---------------------------------------------------------------------------
// プレイヤーの無敵時間を取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_invincible_time : int { return ($invincible_time) }
command $$set_hhp_player_invincible_time(property $value)
{
	// 無敵有効フラグがオフの場合は無敵時間加算処理を行わない
	if( $invincible_enable == 0 ) {
		return
	}
	
	// 無敵スタックフラグがある場合は無敵時間を加算する
	if( $invincible_stack_flag )
	{
		$invincible_time += $value * $invincible_time_rate / 1000
	}
	else
	{
		$invincible_time = $value * $invincible_time_rate / 1000
	}
}

//---------------------------------------------------------------------------
// プレイヤーの無敵時間補正を取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_invincible_time_rate : int { return ($invincible_time_rate) }
command $$set_hhp_player_invincible_time_rate(property $value) { $invincible_time_rate = math.limit(1000, $value, 10000)}

//---------------------------------------------------------------------------
// プレイヤーの無敵有効フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_invincible_enable : int { return ($invincible_enable) }
command $$set_hhp_player_invincible_enable(property $flag)
{
	$invincible_enable = $flag
	
	// 無敵有効フラグがオフの場合は無敵時間をリセットする
	if( $invincible_enable == 0 )
	{
		$invincible_time = 0
	}
}

//---------------------------------------------------------------------------
// プレイヤーの無敵スタックフラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_invincible_stack_flag : int { return ($invincible_stack_flag) }
command $$set_hhp_player_invincible_stack_flag(property $flag){ $invincible_stack_flag = $flag }

//---------------------------------------------------------------------------
// プレイヤーの蘇生フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_rivival_flag : int { return ($rivival) }
command $$set_hhp_player_rivival_flag(property $flag){ $rivival = $flag }

//---------------------------------------------------------------------------
// プレイヤーのコンボ数／最大コンボ数を取得／加算／リセットする
//---------------------------------------------------------------------------
command $$get_hhp_player_combo : int { return ($combo) }
command $$add_hhp_player_combo(property $value)
{
	$combo = math.limit(0, $combo + $value, <HHP_COMBO_MAX>)
	
	$combo_timer = <COMBO_TIMER_MAX>
	
	// 最大コンボ数を保存する
	if( $combo_max < $combo )
	{
		$combo_max = $combo
	}
}

command $$reset_hhp_player_combo { $combo = 0 }
command $$get_hhp_player_combo_max : int { return ($combo_max) }

//---------------------------------------------------------------------------
// プレイヤーのコンボタイマーを取得する
//---------------------------------------------------------------------------
command $$get_hhp_player_combo_timer : int { return ($combo_timer) }

//---------------------------------------------------------------------------
// プレイヤーの最大ダメージを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_player_attacked_damage_max : int { return ($attacked_damage_max) }
command $$set_hhp_player_attacked_damage_max(property $value) { $attacked_damage_max = math.limit(0, $value, <HHP_ATTACK_DAMAGE_MAX>) }

//---------------------------------------------------------------------------
// スコア／ハイスコアを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_score : int { return ($score) }
command $$set_hhp_score(property $value) { $score = $value }
command $$add_hhp_score(property $value) { $score = math.limit(0, $score + $value, <SCORE_MAX>) }
command $$get_hhp_hi_score : int { return ($hi_score) }
command $$set_hhp_hi_score(property $value) { $hi_score = math.limit(0, $value, <SCORE_MAX>) }

//---------------------------------------------------------------------------
// プレイレベル／最大プレイレベルを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_hhp_play_level : int { return ($play_level) }
command $$set_hhp_play_level(property $value) { $play_level = $value }
command $$add_hhp_play_level(property $value) { $play_level = math.limit(<HHP_PLAY_LEVEL_MIN>, $play_level + $value, <HHP_PLAY_LEVEL_MAX>) }

//---------------------------------------------------------------------------
// プレイモードを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_play_mode : int { return ($play_mode) }
command $$set_hhp_play_mode(property $value) { $play_mode = $value }

//---------------------------------------------------------------------------
// プレイ回数を取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_play_count(property $level) : int { return ($play_count[$level - 1]) }
command $$add_hhp_play_count(property $level) { $play_count[$level - 1] += 1 }

command $$get_hhp_total_play_count : int
{
	property $i
	property $count
	
	for( $i = 0, $i < $play_count.get_size, $i += 1 )
	{
		$count += $play_count[$i]
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// プレイ回数（グローバル）を取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_global_play_count : int { return (@mng_global_flag[<HHP_PLAY_COUNT>]) }
command $$add_hhp_global_play_count { @mng_global_flag[<HHP_PLAY_COUNT>] += 1 }

//---------------------------------------------------------------------------
// プレイ結果を取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_play_result : int { return ($play_result) }
command $$set_hhp_play_result(property $value) { $play_result = $value }

//---------------------------------------------------------------------------
// プレイヤーの攻撃ボタン入力を更新する
//---------------------------------------------------------------------------
command $$update_player_push_attack_key
{
	// 攻撃ボタンを押した判定を初期化する
	$push_attack_key = 0
	
	// 決定ボタンを押したとき
	if( input.decide.on_down )
	{
		$push_attack_key = 1			// 攻撃ボタンを押した判定
		$push_attack_key_repeat = 0		// キーリピートカウントを初期化する
	}
	
	// 決定ボタンを押しているとき
	elseif( input.decide.is_down )
	{
		$push_attack_key_repeat += $$get_delta_time
		
		// キーリピート最大を超えた時は押した判定にする
		if( $push_attack_key_repeat >= $push_attack_key_repeat_max )
		{
			$push_attack_key = 1			// 攻撃ボタンを押した判定
			$push_attack_key_repeat = 0		// キーリピートカウントを初期化する
		}
	}
	
	// 決定ボタンを押していないとき
	else
	{
		$push_attack_key_repeat = 0
	}
}

//---------------------------------------------------------------------------
// プレイヤーの攻撃ボタン入力を取得する
//---------------------------------------------------------------------------
command $$get_hhp_push_attack_key : int { return ($push_attack_key) }

//---------------------------------------------------------------------------
// プレイヤーの攻撃ボタン入力(キーリピート／キーリピート最大)を取得する
//---------------------------------------------------------------------------
command $$get_hhp_push_attack_key_repeat : int { return ($push_attack_key_repeat) }
command $$get_hhp_push_attack_key_repeat_max : int { return ($push_attack_key_repeat_max) }

//---------------------------------------------------------------------------
// プレイヤー攻撃時に発生するイベント
//---------------------------------------------------------------------------
command $$hhp_player_trigger_on_attack
{
	// 横範囲攻撃
	if( $attack_horizontal )
	{
		$$spawn_hhp_hitbox(<HHP_HITBOX_TYPE_HORIZONTAL>, mouse.get_pos_x, mouse.get_pos_y)
	}
	
	// 縦範囲攻撃
	if( $attack_vertical )
	{
		$$spawn_hhp_hitbox(<HHP_HITBOX_TYPE_VERTICAL>, mouse.get_pos_x, mouse.get_pos_y)
	}
	
	// 範囲攻撃
	$attack_range_count += 1
	
	$attacking = 1
	$direct_attack = 1
	if( $attack_range_count_max != 0 && $attack_range_count >= $attack_range_count_max )
	{
		$direct_attack = 0
		
		$$spawn_hhp_hitbox(<HHP_HITBOX_TYPE_RADIAL>, mouse.get_pos_x, mouse.get_pos_y)
		
		$attack_range_count = 0
	}
}

//---------------------------------------------------------------------------
// 一時停止フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_pause_flag : int { return ($pause) }
command $$set_hhp_pause_flag(property $flag) { $pause = $flag }

//---------------------------------------------------------------------------
// オートプレイフラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_autoplay_flag : int { return ($auto_play) }
command $$set_hhp_autoplay_flag(property $flag) { $auto_play = $flag }

//---------------------------------------------------------------------------
// 報酬リストを作成する
//---------------------------------------------------------------------------
command $$create_hhp_rewards_list
{
	property $i
	property $j
	property $weights : intlist[<HHP_ITEM_ID_MAX>]
	property $total_weight
	property $tmp_weight
	property $item_type
	property $item_level
	property $total_item_type
	property $rand
	
	// 報酬発生回数を加算する
	$rewards_total += 1
	
	// 報酬リストを初期化する
	$rewards_list.init
	$rewards_rand.init
	
	// 完全初回時のみ報酬を攻撃／防御／状態異常で固定
	if( $rewards_total == 1 )
	{
		$$create_hhp_rewards_list_first
		return
	}
	
	// 全アイテムそれぞれの重みを設定する
	for( $i = <HHP_ITEM_ID_MIN>, $i < <HHP_ITEM_ID_MAX>, $i += 1 )
	{
		// 最大レベルの場合は選択されない
		if( $$get_hhp_item_level($i) == <HHP_ITEM_LEVEL_MAX> )
		{
			$weights[$i] = 0
			continue
		}
		
		// ロックされている報酬は選択されない
		if( $$check_rewards_item_enable($i) == 0 )
		{
			$weights[$i] = 0
			continue
		}
		
		// アイテムデータを取得する
		$item_type = $$get_hhp_item_type($i)
		$item_level = $$get_hhp_item_level($i)
		$total_item_type = $$get_hhp_item_count_from_type($item_type)
		
		// アイテムレベルによってベースの重みを設定する
		switch( $item_level ) {
		case(1)		$weights[$i] = 150 + $$get_hhp_rewards_high_tier_rate		// Lv1アイテムを所持
		case(2)		$weights[$i] = 125 + $$get_hhp_rewards_high_tier_rate		// Lv2アイテムを所持
		default		$weights[$i] = 100											// アイテムを所持していない場合
			
			// 所持しているアイテムタイプの個数によって重みを変更する
			if( $total_item_type == 0 )
			{
				// このアイテムタイプを所持していない → 0.8
				$weights[$i] = $weights[$i] * 80 / 100
			}
			elseif( $total_item_type == 1 )
			{
				// このアイテムタイプを１つ所持している → 1.2
				$weights[$i] = $weights[$i] * 120 / 100
			}
			else
			{
				// このアイテムタイプを２つ以上所持している → 1.5
				$weights[$i] = $weights[$i] * 150 / 100
			}
		}
	}
	
	// デバッグ確認用／各報酬の重みを保存する
	for( $i = <HHP_ITEM_ID_MIN>, $i < <HHP_ITEM_ID_MAX>, $i += 1 )
	{
		$rewards_weight[$i] = $weights[$i]
	}
	
	// 獲得可能リストの中からランダムで選択する
	for( $i = 0, $i < <REWARDS_SELECT_MAX>, $i += 1 )
	{
		// 全ての重みを合計する
		$total_weight = 0
		for( $j = <HHP_ITEM_ID_MIN>, $j < <HHP_ITEM_ID_MAX>, $j += 1 )
		{
			$total_weight += $weights[$j]
		}
		
		// 取得できるアイテムが存在しない場合は終了する
		if( $total_weight == 0 ) {
			return
		}
		
		// 各重みから報酬をランダムに選択する
		$rand = $$mng_rand(0, $total_weight - 1)
		
		// デバッグ確認用／選択乱数を保存する
		$rewards_rand.resize($rewards_rand.get_size + 1)
		$rewards_rand[$rewards_rand.get_size - 1] = $rand
		
		$tmp_weight = 0
		for( $j = <HHP_ITEM_ID_MIN>, $j < <HHP_ITEM_ID_MAX>, $j += 1 )
		{
			// 重みづけされていない場合は選択されない
			if( $weights[$j] == 0 ) {
				continue
			}
			
			// 重みを加算する
			$tmp_weight += $weights[$j]
			
			// ランダム値が重み以下の場合は報酬として選択する
			if( $rand < $tmp_weight )
			{
				$rewards_list.resize($rewards_list.get_size + 1)
				$rewards_list[$rewards_list.get_size - 1] = $j
				
				// 選択された報酬は重みを０にする
				$weights[$j] = 0
				
				break
			}
		}
	}
}

// 初回時
command $$create_hhp_rewards_list_first
{
	property $i
	property $j
	property $index
	property $flag
	property $tmp_list : intlist
	
	// 攻撃／防御／状態異常の３つから選択する
	for( $i = 0, $i < <REWARDS_SELECT_MAX>, $i += 1 )
	{
		// 取得可能な報酬リストを取得する
		$tmp_list.init
		for( $j = <HHP_ITEM_ID_MIN>, $j < <HHP_ITEM_ID_MAX>, $j += 1 )
		{
			if( $$check_rewards_item_enable($j) == 0 )
			{
				continue
			}
			
			$flag = 0
			
			// 報酬１は攻撃タイプから
			if( $i == 0 && $$get_hhp_item_type($j) == <HHP_ITEM_TYPE_ATTACK> ) {
				$flag = 1
			}
			
			// 報酬２は防御タイプから
			elseif( $i == 1 && $$get_hhp_item_type($j) == <HHP_ITEM_TYPE_DEFENCE> ) {
				$flag = 1
			}
			
			// 報酬３は状態異常タイプから
			elseif( $i == 2 && $$get_hhp_item_type($j) == <HHP_ITEM_TYPE_STATUS_EFFECT> ) {
				$flag = 1
			}
			
			if( $flag ) {
				$tmp_list.resize($tmp_list.get_size + 1)
				$tmp_list[$tmp_list.get_size - 1] = $j
			}
		}
		
		// ランダムで獲得スキルを決める
		$index = $$mng_rand(0, $tmp_list.get_size - 1)
		
		$rewards_list.resize($rewards_list.get_size + 1)
		$rewards_list[$rewards_list.get_size - 1] = $tmp_list[$index]
	}
	
	// デバッグ確認用／選択乱数を保存する
	$rewards_rand.resize($rewards_list.get_size)
}

//---------------------------------------------------------------------------
// 報酬が獲得可能かチェックする
//---------------------------------------------------------------------------
command $$check_rewards_item_enable(property $item_id) : int
{
	// 「縦横攻撃追加」は「攻撃力アップ」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_ATTACK_SLASH> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_DAMAGE_UP>) == -1 ) {
			return (0)
		}
	}
	
	// 「無敵で攻撃を受けると攻撃力アップ」は「無敵発生」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_INVINCIBLE>) == -1 ) {
			return (0)
		}
	}
	
	// 「ウェーブ終了後ライフ回復」は「無敵発生」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_INVINCIBLE>) == -1 ) {
			return (0)
		}
	}
	
	// 「二重攻撃」は「クリティカル発生」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_DOUBLE_ATTACK> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_CRITICAL>) == -1 ) {
			return (0)
		}
	}
	
	// 「永続的なライフ増加」は「ライフ自動回復」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_PERMANENTLY_LIFE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_LIFE_REGENERATION>) == -1 ) {
			return (0)
		}
	}
	
	// 「攻撃範囲アップ」は「攻撃力アップ」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_ATTACK_RANGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_DAMAGE_UP>) == -1 ) {
			return (0)
		}
	}
	
	// 「相手が倒れた時、近くにいる敵に状態異常を移す」は「スロウ付与」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_STATUS_EFFECT_CONVERT> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>) == -1 ) {
			return (0)
		}
	}
	
	// 「無敵でないとき攻撃力アップ」は「攻撃力アップ」「無敵発生」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_DAMAGE_UP>) == -1 || $$has_hhp_item(<HHP_ITEM_ID_INVINCIBLE>) == -1 ) {
			return (0)
		}
	}
	
	// 「状態異常に攻撃力アップ」は「攻撃力アップ」「スロウ付与」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_DAMAGE_UP>) == -1 || $$has_hhp_item(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>) == -1 ) {
			return (0)
		}
	}
	
	// 「ダメージがある敵に攻撃力アップ」は「攻撃力アップ」「クリティカル発生」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_LIFELESS_DAMAGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_DAMAGE_UP>) == -1 || $$has_hhp_item(<HHP_ITEM_ID_CRITICAL>) == -1 ) {
			return (0)
		}
	}
	
	// 「ダメージがある敵に攻撃力アップ」は「無敵発生」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_ATTACKED_DAMAGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_INVINCIBLE>) == -1 ) {
			return (0)
		}
	}
	
	// 「敵の状態異常の数が多いほど攻撃力アップ」は「攻撃力アップ」「スロウ付与」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_DAMAGE_UP>) == -1 || $$has_hhp_item(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>) == -1 ) {
			return (0)
		}
	}
	
	// 「反射ダメージアップ」は「反射ダメージ」を取得する必要がある
	if( $item_id == <HHP_ITEM_ID_SPIKE_DAMAGE_UP> ) {
		if( $$has_hhp_item(<HHP_ITEM_ID_SPIKE>) == -1 ) {
			return (0)
		}
	}
	
	return (1)
}

//---------------------------------------------------------------------------
// 報酬リスト／報酬リストの選択数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_rewards_list(property $index) : int { return ($rewards_list[$index]) }
command $$get_hhp_rewards_list_count : int { return ($rewards_list.get_size) }

//---------------------------------------------------------------------------
// 入手した報酬個数を取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_rewards_num : int { return ($rewards_num) }
command $$add_hhp_rewards_num(property $value) { $rewards_num = math.limit(0, $rewards_num + $value, <REWARDS_NUM_MAX>) }

//---------------------------------------------------------------------------
// 高レアリティ報酬の発生率を取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_rewards_high_tier_rate : int { return ($rewards_high_tier_rate) }
command $$add_hhp_rewards_high_tier_rate(property $value) { $rewards_high_tier_rate = math.limit(0, $rewards_high_tier_rate + $value, <REWARDS_HIGH_TIER_RATE_MAX>) }

//---------------------------------------------------------------------------
// 報酬リストのリロール数／リロール最大数を取得／加算する
//---------------------------------------------------------------------------
command $$get_hhp_rewards_reroll : int { return ($rewards_reroll) }
command $$add_hhp_rewards_reroll(property $value) { $rewards_reroll = math.limit(0, $rewards_reroll + $value, $rewards_reroll_max) }
command $$get_hhp_rewards_reroll_max : int { return ($rewards_reroll_max) }
command $$add_hhp_rewards_reroll_max(property $value) { $rewards_reroll_max = math.limit(1, $rewards_reroll_max + $value, <REWARDS_REROLL_MAX>) }

//---------------------------------------------------------------------------
// チュートリアルの進行状況を取得／設定する／進める
//---------------------------------------------------------------------------
command $$get_hhp_tutorial_flag : int { return (@mng_global_flag[<HHP_TUTORIAL_FLAG>]) }
command $$set_hhp_tutorial_flag(property $value) { @mng_global_flag[<HHP_TUTORIAL_FLAG>] = $value }
command $$next_hhp_tutorial_flag { @mng_global_flag[<HHP_TUTORIAL_FLAG>] += 1 }

//---------------------------------------------------------------------------
// アイテム図鑑フラグを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_item_library_flag
{
	property $i
	property $j
	
	for( $i = <HHP_ITEM_ID_MIN>, $i < <HHP_ITEM_ID_MAX>, $i += 1 )
	{
		for( $j = <HHP_ITEM_LEVEL_MIN>, $j < <HHP_ITEM_LEVEL_MAX>, $j += 1 )
		{
			$$off_hhp_item_library_flag($i, $j)
		}
	}
}

//---------------------------------------------------------------------------
// アイテム図鑑フラグを取得／ＯＮ／ＯＦＦにする
//---------------------------------------------------------------------------
command $$get_hhp_item_library_flag(property $item_id, property $item_level) : int { return (@mng_global_flag[$$get_hhp_item_icon_no($item_id, $item_level)]) }
command $$on_hhp_item_library_flag(property $item_id, property $item_level) { @mng_global_flag[$$get_hhp_item_icon_no($item_id, $item_level)] = 1 }
command $$off_hhp_item_library_flag(property $item_id, property $item_level) { @mng_global_flag[$$get_hhp_item_icon_no($item_id, $item_level)] = 0 }

//---------------------------------------------------------------------------
// アイテム図鑑フラグでＯＮになっている数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_library_on_count : int
{
	property $i
	property $j
	property $count
	
	for( $i = <HHP_ITEM_ID_MIN>, $i < <HHP_ITEM_ID_MAX>, $i += 1 )
	{
		for( $j = <HHP_ITEM_LEVEL_MIN>, $j < <HHP_ITEM_LEVEL_MAX>, $j += 1 )
		{
			if( $$get_hhp_item_library_flag($i, $j) ) {
				$count += 1
			}
		}
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// ゴッドモード(無敵)を取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_god_mode_flag : int { return ($god_mode) }
command $$set_hhp_god_mode_flag(property $value) { $god_mode = $value }

//---------------------------------------------------------------------------
// 各報酬の重みを取得する
//---------------------------------------------------------------------------
command $$get_hhp_rewards_weight(property $item_id) : int { return ($rewards_weight[$item_id]) }

//---------------------------------------------------------------------------
// 各報酬の重みの合計値を取得する
//---------------------------------------------------------------------------
command $$get_hhp_rewards_total_weight : int
{
	property $i
	property $total
	
	for( $i = <HHP_ITEM_ID_MIN>, $i < <HHP_ITEM_ID_MAX>, $i += 1 )
	{
		$total += $rewards_weight[$i]
	}
	return ($total)
}

//---------------------------------------------------------------------------
// 各報酬選択乱数値を取得する
//---------------------------------------------------------------------------
command $$get_hhp_rewards_rand(property $rewards_index) : int { return ($rewards_rand[$rewards_index]) }


//---------------------------------------------------------------------------
// todo
//---------------------------------------------------------------------------
command $$get_hhp_player_se_type : int { return ($se_type) }
command $$set_hhp_player_se_type(property $type) { $se_type = $type }

command $$get_hhp_player_attacking : int { return ($attacking) }
command $$get_hhp_player_direct_attack : int { return ($direct_attack) }
