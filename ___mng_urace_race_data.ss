//===========================================================================
//!
//!    @file     ___mng_urace_race_data.ss
//!    @brief    ＵＭＡレースデータ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レース画面中のＵＭＡ等のデータ管理
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// 速度上限／下限[１秒で進む距離(m)]
	#replace	<SPEED_MIN>				25			// 最低速度(25なら1秒に25m進む)
	#replace	<SPEED_MAX>				40			// 最高速度(40なら1秒に40m進む)
	
	// スタミナ切れの場合の速度[１秒で進む距離(m)]
	#replace	<STAMINA_MIN_SPEED>		20			// スタミナ切れ速度(20なら1秒に20m進む)
	
	// 加速上限／下限[速度上限時で最高速度に達する時間(s)]
	#replace	<ACCEL_MIM>				 6000		// 最低加速(速度上限時に6000なら6秒で最高速度になる)
	#replace	<ACCEL_MAX>				 1000		// 最高加速(速度上限時に1000なら1秒で最高速度になる)
	
	// テンション初期値上限／下限[レース開始時に設定される初期テンション値]
	#replace	<TENSION_DEFAULT_MIN>	100			// 最低初期値(100なら初期テンション値は100)
	#replace	<TENSION_DEFAULT_MAX>	300			// 最高初期値(300なら初期テンション値は300)
	
	// テンション加算値上限／下限[１秒で加算されるテンション値]
	#replace	<TENSION_PLUS_MIN>		10			// 最低加算(10なら1秒にテンション値が10加算される)
	#replace	<TENSION_PLUS_MAX>		25			// 最高加算(25なら1秒にテンション値が25加算される)
	
	// ジャンプの初期値
	#replace	<JUMP_POWER_DEFAULT>	150				// ジャンプ力
	#replace	<JUMP_TIME_DEFAULT>		500				// ジャンプ時間
	
	// 係数定義
	#replace	<DISTACE_SHIFT>			1000			// 距離係数(SHIFTが1000、距離が1000mの時、実際の変数としては距離=1000000として管理される)
	#replace	<TIME_SHIFT>			1000			// 時間係数
	#replace	<TENSION_SHIFT>			1000			// テンション係数
	#replace	<SKILL_POWER_SHIFT>		1000			// スキルゲージ係数
	
	// レースデータ
	#property	$race_id											// レースID
	#property	$race_distance										// 距離
	#property	$race_ground_type									// 地形
	#property	$last_spurt_distance								// ラストスパートが発生する距離
	#property	$race_total_goal_num								// ゴールしているＵＭＡの合計数
	
	// 参加者データ
	#property	$entry_pure_owners : intlist						// 参加しているオーナー(乙女)リスト
	
	// ＵＭＡデータ
	#property	$uma_id : intlist[<URACE_ENTRY_MAX>]					// ID
	#property	$uma_name : strlist[<URACE_ENTRY_MAX>]					// 名前
	#property	$uma_life : intlist[<URACE_ENTRY_MAX>]					// ライフ
	#property	$uma_life_max : intlist[<URACE_ENTRY_MAX>]				// 最大ライフ
	#property	$uma_speed : intlist[<URACE_ENTRY_MAX>]					// 現在の速度
	#property	$uma_speed_max : intlist[<URACE_ENTRY_MAX>]				// 最高速度
	#property	$uma_fixed_speed_max : intlist[<URACE_ENTRY_MAX>]		// ＵＭＡの固定最高速度
	#property	$uma_base_speed_max : intlist[<URACE_ENTRY_MAX>]		// ＵＭＡの基本最高速度
	#property	$uma_accel : intlist[<URACE_ENTRY_MAX>]					// 加速力
	#property	$uma_base_accel : intlist[<URACE_ENTRY_MAX>]			// ＵＭＡの基本加速力
	#property	$uma_plus_tension : intlist[<URACE_ENTRY_MAX>]			// 時間によって自動で加算されるテンション
	#property	$uma_action_state : intlist[<URACE_ENTRY_MAX>]			// 行動状態
	#property	$uma_action_time : intlist[<URACE_ENTRY_MAX>]			// 行動時間
	#property	$uma_action_trap_id : intlist[<URACE_ENTRY_MAX>]		// アクション中の障害物ID
	#property	$uma_action_trap_index : intlist[<URACE_ENTRY_MAX>]		// アクション中の障害物インデックス
	#property	$uma_jump_time : intlist[<URACE_ENTRY_MAX>]				// ジャンプ時間
	#property	$uma_jump_time_max : intlist[<URACE_ENTRY_MAX>]			// ジャンプ最大時間
	#property	$uma_jump_power : intlist[<URACE_ENTRY_MAX>]			// ジャンプ力
	#property	$uma_jump_power_max : intlist[<URACE_ENTRY_MAX>]		// ジャンプ最大力
	#property	$uma_hide_mode : intlist[<URACE_ENTRY_MAX>]				// 潜伏モード
	#property	$uma_hide_mode_time : intlist[<URACE_ENTRY_MAX>]		// 潜伏モード時間
	#property	$uma_hide_mode_time_max : intlist[<URACE_ENTRY_MAX>]	// 潜伏モード最大時間
	#property	$uma_hide_mode_power : intlist[<URACE_ENTRY_MAX>]		// 潜伏モード力
	#property	$uma_invincible_trap : intlist[<URACE_ENTRY_MAX>]		// 障害物無効
	#property	$uma_invincible_flag : intlist[<URACE_ENTRY_MAX>]		// 無敵フラグ
	#property	$uma_invincible_time : intlist[<URACE_ENTRY_MAX>]		// 無敵時間
	#property	$uma_block_flag : intlist[<URACE_ENTRY_MAX>]			// ブロックフラグ
	#property	$uma_stop_flag : intlist[<URACE_ENTRY_MAX>]				// 停止フラグ
	#property	$uma_ground_type_turf : intlist[<URACE_ENTRY_MAX>]		// 芝適性
	#property	$uma_ground_type_dirt : intlist[<URACE_ENTRY_MAX>]		// ダート適性
	#property	$uma_ground_type_surface : intlist[<URACE_ENTRY_MAX>]	// 砂質適性
	
	// 参加者（オーナー）データ
	#property	$owner_list           : intlist[<URACE_ENTRY_MAX>]		// オーナーリスト(ID)
	#property	$owner_uma_list       : intlist							// 所持ＵＭＡリスト
	#property	$owner_uma_index      : intlist[<URACE_ENTRY_MAX>]		// 走行中ＵＭＡインデックス
	#property	$owner_mileage        : intlist[<URACE_ENTRY_MAX>]		// 走行距離
	#property	$owner_skill_power    : intlist[<URACE_ENTRY_MAX>]		// スキルゲージ
	#property	$owner_retire         : intlist[<URACE_ENTRY_MAX>]		// 失格フラグ
	#property	$owner_goal_order     : intlist[<URACE_ENTRY_MAX>]		// 着順
	#property	$owner_goal_time      : intlist[<URACE_ENTRY_MAX>]		// ゴール時間
	#property	$owner_npc_think_time : intlist[<URACE_ENTRY_MAX>]		// ＮＰＣの思考時間(０になると行動選択が発生する)
	#property	$owner_voice_trigger  : intlist[<URACE_ENTRY_MAX>]		// ボイス再生トリガー
	
	#property	$uma_invincible       : intlist[<URACE_ENTRY_MAX>]
	#property	$uma_currnet_lane     : intlist[<URACE_ENTRY_MAX>]		// 現在のレーン
	#property	$uma_target_lane      : intlist[<URACE_ENTRY_MAX>]		// 移動先のレーン
	
	//2
	#replace	<GROUND_TYPE_DAMAGE>	5
	#replace	<COURSE_OUT_DAMAGE>		10
	
	#property	$now_lane : intlist[<URACE_ENTRY_MAX>]
	#property	$order : intlist[<URACE_ENTRY_MAX>]
	#property	$trap_use : intlist[<URACE_ENTRY_MAX>]
	
	// 元仕様のダッシュ板を毎フレーム踏む問題に $trap_use を使うとトラップまで無視する問題対策は下記の対応 ※交代でリセットはいるかも
	// | 同一ダッシュ板を短時間に2回踏む | 2回目は無視される    |
	// | 別のダッシュ板を連続で踏む      | 両方とも効果が出る   |
	// | ダッシュ板の後に岩を踏む        | 岩のダメージを受ける |
	// | 指定ms秒経過後に同じダッシュ板  | 再び効果が出る       | ※あまりやる意味はないので99999とか？トラップ上でスタンの扱いを設定値で変えられなくもない
	// | レーン変更後の同じindex         | 別レーンなので踏める | ※1個で複数レーンの物が出てきたら注意
	#property	$trap_last_stepped_lane : intlist[<URACE_ENTRY_MAX>]
	#property	$trap_last_stepped_index : intlist[<URACE_ENTRY_MAX>]
	#property	$trap_last_stepped_cooltime : intlist[<URACE_ENTRY_MAX>]
	#replace	<SAME_TRAP_INDEX_COOL_TIME>		99999
	
#inc_end

#z00

//---------------------------------------------------------------------------
// レースデータの初期化
//---------------------------------------------------------------------------
command $$init_entry_race_data
{
	property $i
	property $len
	
	// レースデータ
	$race_id = 0
	$race_distance = 0
	$race_ground_type = 0
	$last_spurt_distance = 0
	$race_total_goal_num = 0
	
	// 参加者データ
	$entry_pure_owners.init
	
	// ＵＭＡデータ
	$uma_id.init
	$uma_name.init
	$uma_life.init
	$uma_life_max.init
	$uma_speed.init
	$uma_speed_max.init
	$uma_fixed_speed_max.init
	$uma_base_speed_max.init
	$uma_plus_tension.init
	$uma_accel.init
	$uma_base_accel.init
	$uma_action_state.init
	$uma_action_time.init
	$uma_action_trap_id.init
	$uma_action_trap_index.init
	$uma_jump_time.init
	$uma_jump_time_max.init
	$uma_jump_power.init
	$uma_jump_power_max.init
	$uma_hide_mode.init
	$uma_hide_mode_time.init
	$uma_hide_mode_time_max.init
	$uma_hide_mode_power.init
	$uma_invincible_trap.init
	$uma_invincible_flag.init
	$uma_invincible_time.init
	$uma_block_flag.init
	$uma_stop_flag.init
	
	// スキルデータ
	$$init_urace_race_skill_data
	
	// 障害物データ
	$$init_entry_race_trap_data
	
	// バフ／デバフデータ
	$$init_running_uma_buff
	
	// 参加者（オーナー）
	$owner_list.init
	$owner_uma_list.init
	
	$len = <URACE_DECK_UMA_MAX> * <URACE_ENTRY_MAX>	// 参加ＵＭＡ最大数 × 参加オーナー数
	$owner_uma_list.resize($len)
	for( $i = 0, $i < $len, $i += 1 ) {
		$owner_uma_list[$i] = -1
	}
	
	$owner_uma_index.init
	$owner_mileage.init
	$owner_skill_power.init
	$owner_retire.init
	$owner_goal_order.init
	$owner_goal_time.init
	$owner_npc_think_time.init
	$owner_voice_trigger.init
	
	$uma_currnet_lane.init
	$uma_target_lane.init
	
	$$init_urace_race_item
}

//---------------------------------------------------------------------------
// レースデータのリセット
//---------------------------------------------------------------------------
command $$reset_entry_race_data
{
	property $i
	property $len
	
	$len = $$get_entry_owner_num
	
	// レースデータ
	$race_ground_type = $$get_db_race_ground_type($race_id)
	$race_total_goal_num = 0
	
	// スキルデータ
	$$init_urace_race_skill_data
	
	// バフ／デバフデータ
	$$init_running_uma_buff
	
	// 参加者（オーナー）
	for( $i = 0, $i < $len, $i += 1 )
	{
		$owner_uma_index[$i] = 0
		$owner_mileage[$i] = 0
		$owner_skill_power[$i] = 0
		$owner_retire[$i] = 0
		$owner_goal_order[$i] = 0
		$owner_goal_time[$i] = 0
		$owner_npc_think_time[$i] = math.rand(1000, 3000)
		$owner_voice_trigger[$i] = 0
	}
	
	// ＵＭＡデータ
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$init_running_uma_data($i)
		$$reset_lane_trap_data($i)
		// ↓ 追加
		$trap_last_stepped_lane[$i] = -1
		$trap_last_stepped_index[$i] = -1
		$trap_last_stepped_cooltime[$i] = 0
	}
	
	//2
	for( $i = 0, $i < $len, $i += 1 )
	{
		$uma_currnet_lane[$i] = $i
		$uma_target_lane[$i]  = $i
		$now_lane[$i] = $i
		$order[$i] = 0
	}
	$$init_urace_race_item
}

//---------------------------------------------------------------------------
// 参加しているレースIDを取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_race_id : int
{
	return ($race_id)
}

command $$set_entry_race_id(property $id)
{
	$race_id = $id		// レースID
	$race_distance = $$get_db_race_distance($race_id) * <DISTACE_SHIFT>		// 補正したレース距離を設定する
	$race_ground_type = $$get_db_race_ground_type($race_id)					// 地形タイプ
	$last_spurt_distance = $race_distance * 70 / 100						// ラストスパートが発生する距離
}

//---------------------------------------------------------------------------
// レース距離を取得する(実数／距離係数補正済み)
//---------------------------------------------------------------------------
command $$get_entry_race_distance : int
{
	return ($race_distance)
}

command $$get_entry_race_distance_shift : int
{
	return ($race_distance / <DISTACE_SHIFT>)
}

//---------------------------------------------------------------------------
// 参加しているレースの現在の地形を取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_race_ground_type : int
{
	return ($race_ground_type)
}

command $$set_entry_race_ground_type(property $ground_type)
{
	$race_ground_type = $ground_type
}

//---------------------------------------------------------------------------
// ラストスパートが発生する距離を取得する(実数／距離係数補正済み)
//---------------------------------------------------------------------------
command $$get_entry_race_last_spurt_distance : int
{
	return ($last_spurt_distance)
}

command $$get_entry_race_last_spurt_distance_shift : int
{
	return ($last_spurt_distance / <DISTACE_SHIFT>)
}

//---------------------------------------------------------------------------
// 参加しているレースが終了しているか判定する
//---------------------------------------------------------------------------
command $$check_entry_race_finished : int
{
	if( $owner_retire[$$get_player_from_entry_owner_list] == 1 )
	{
		return (2)
	}
	
	if( $race_total_goal_num + $$get_entry_owner_retire_num >= $$get_entry_owner_num )
	{
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// 指定したオーナー／ＵＭＡをレースに参加させる
//---------------------------------------------------------------------------
command $$entry_urace(property $owner_id, property $uma_index, property $lane_index)
{
	property $i
	property $index
	
	// レーンが指定されていない場合はデータが空いている箇所を探す
	if( $lane_index == -1 )
	{
		for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
		{
			if( $owner_list[$i] == 0 )
			{
				$index = $i
				break
			}
			
			if( $i == <URACE_ENTRY_MAX> - 1)
			{
				$$debug_message("レースに参加する人数が既に最大です。\nnum:" + math.tostr($i) + "\n処理をスキップします")
				return
			}
		}
	}
	else
	{
		$index = $lane_index
	}
	
	// 参加者を設定する
	$owner_list[$index] = $owner_id
	
	// ヒロインがレースに参加しているかチェックする
	if( $$get_db_owner_pure_flag($owner_id) )
	{
		$entry_pure_owners.resize($entry_pure_owners.get_size + 1)
		$entry_pure_owners[$entry_pure_owners.get_size - 1] = $owner_id
	}
	
	//2
	$now_lane[$index] = $lane_index
	
	for( $i = 0, $i < <URACE_DECK_UMA_MAX>, $i += 1 )
	{
		// deb
		if( $owner_id == <URACE_PLAYER_OWNER_ID> )
		{
			$$set_entry_owner_uma_list($lane_index, $i, $$get_my_deck($i))
		}
		else
		{
			if( $$get_db_owner_uma_list($owner_id, $i) != 0 )
			{
				$$create_npc_uma_data($$get_db_owner_uma_list($owner_id, $i), $lane_index * <URACE_DECK_UMA_MAX> + $i)
				$$set_entry_owner_uma_list($lane_index, $i, $lane_index * <URACE_DECK_UMA_MAX> + $i)
			}
			else
			{
				$$set_entry_owner_uma_list($lane_index, $i, -1)
			}
		}
	}
}

//---------------------------------------------------------------------------
// 参加しているオーナー(乙女)ID／数を取得する
//---------------------------------------------------------------------------
command $$get_entry_pure_owner_id(property $index) : int
{
	return ($entry_pure_owners[$index])
}

command $$get_entry_pure_owner_num : int
{
	return ($entry_pure_owners.get_size)
}

//---------------------------------------------------------------------------
// 参加しているＵＭＡインデックスを取得／変更する
//---------------------------------------------------------------------------
command $$get_entry_uma_index(property $index) : int
{
	property $tmp
	
	$tmp = $$get_entry_owner_uma_list($index, $owner_uma_index[$index])
	
	if( $tmp == -1 ) {
		$tmp = $$get_entry_owner_uma_list($index, $owner_uma_index[$index] - 1)
	}
	return ($tmp)
}

//---------------------------------------------------------------------------
// ＵＭＡデータを初期化する
//---------------------------------------------------------------------------
command $$init_running_uma_data(property $index)
{
	property $owner_id
	property $uma_index
	property $speed
	property $accel
	
	// オーナー／ＵＭＡデータを取得する
	$owner_id = $owner_list[$index]
	$uma_index = $$get_entry_owner_uma_list($index, $owner_uma_index[$index])
	
	// ＵＭＡデータの設定
	$uma_id[$index] = $$get_uma_id($owner_id, $uma_index)
	$uma_name[$index] = $$get_uma_name($owner_id, $uma_index)
	$uma_speed[$index] = 0
	$uma_fixed_speed_max[$index] = -1
	$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_START_WAIT>
	$uma_action_time[$index] = 0
	$uma_action_trap_id[$index] = 0
	$uma_action_trap_index[$index] = 0
	$uma_jump_time[$index] = 0
	$uma_jump_time_max[$index] = 0
	$uma_jump_power[$index] = 0
	$uma_jump_power_max[$index] = 0
	$uma_hide_mode[$index] = 0
	$uma_hide_mode_time[$index] = 0
	$uma_hide_mode_time_max[$index] = 0
	$uma_hide_mode_power[$index] = 0
	$uma_invincible_trap[$index] = 0
	$uma_invincible_flag[$index] = 0
	$uma_invincible_time[$index] = 0
	$uma_block_flag[$index] = 0
	$uma_stop_flag[$index] = 0

	// ＵＭＡパラメータを取得する
	$speed = $$get_uma_speed($owner_id, $uma_index)
	$accel = $$get_uma_accel($owner_id, $uma_index)
	
	// =========================== 地形適性 ===========================
	$uma_ground_type_turf[$index] = $$get_uma_turf_type($owner_id, $uma_index)
	$uma_ground_type_dirt[$index] = $$get_uma_dirt_type($owner_id, $uma_index)
	$uma_ground_type_surface[$index] = $$get_uma_surface_type($owner_id, $uma_index)
	
	// =========================== 最高速度 ===========================

	$$calc_running_uma_speed_max($index)	// 下記の処理を関数化した
;	// ＵＭＡパラメータ(スピード)と速度上限／下限から補間した最高速度を求める
;	$uma_base_speed_max[$index] = math.linear($speed, <UMA_PARAM_MIN>, <SPEED_MIN> * <TIME_SHIFT>, <UMA_PARAM_MAX>, <SPEED_MAX> * <TIME_SHIFT>)
;	
;	// レース地形がすべての場合はそのままの速度、芝／ダート／水面の場合は適性を計算する
;	if( $$get_db_race_ground_type($race_id) != <URACE_GROUND_TYPE_SPACE> )
;	{
;		// 地形適性がない場合は最高速度が減少する
;		//switch( $$get_uma_ground_type($owner_id, $uma_index, $race_ground_type) ) {
;		switch( $$get_running_uma_ground_type($index, $race_ground_type) ) {
;		case(<UMA_GROUND_TYPE_C>)		// 何もしない																// 動けないデバフ付与中なので計算不要
;		case(<UMA_GROUND_TYPE_B>)		$uma_base_speed_max[$index] = $uma_base_speed_max[$index] *  500 / 10000		// △	75%
;		case(<UMA_GROUND_TYPE_A>)		// 何もしない																// ○	100%
;		}
;	}
;	
;	// 補正した結果、最低速度を下回っている場合は最低速度に丸める
;	if( $uma_base_speed_max[$index] < <SPEED_MIN> * <TIME_SHIFT> ) {
;		//$uma_base_speed_max[$index] = <SPEED_MIN> * <TIME_SHIFT>
;	}
;	
;	// 幸運値による最高速度追加補正を求める
;	$uma_base_speed_max[$index] *= math.linear(100, <UMA_PARAM_MIN>, 100, <UMA_PARAM_MAX>, 110) / 100
;	
;	// 最高速度を設定する
;	$uma_speed_max[$index] = $uma_base_speed_max[$index]
	
	// =========================== 加速度 ===========================
	
	// ＵＭＡパラメータ(テクニック)と加速上限／下限(速度上限時)から補間した加速度を求める
	$uma_base_accel[$index] = <SPEED_MAX> * <TIME_SHIFT> / math.linear($accel, <UMA_PARAM_MIN>, <ACCEL_MIM>, <UMA_PARAM_MAX>, <ACCEL_MAX>)
	
	// 加速度を設定する
	$uma_accel[$index] = $uma_base_accel[$index]
	
	// =========================== ライフ ===========================
	$uma_life_max[$index] = $$get_uma_life($owner_id, $uma_index)
	$uma_life[$index] = $uma_life_max[$index]
	
	// =========================== テンション ===========================
	
	// ＵＭＡパラメータ(絆)とテンション加算値上限／下限から補間したテンション加算値を求める
	$uma_plus_tension[$index] = math.linear($accel, <UMA_PARAM_MIN>, <TENSION_PLUS_MIN>, <UMA_PARAM_MAX>, <TENSION_PLUS_MAX>)
	
	// =========================== スキル ===========================
	// スキルデータ
	$$init_running_uma_skill($index)
}

//---------------------------------------------------------------------------
// ＵＭＡの最高速度を算出する
//---------------------------------------------------------------------------
command $$calc_running_uma_speed_max(property $index)
{
	//system.debug_write_log("[" + math.tostr($index) + "]calc:")
	property $owner_id
	property $uma_index
	property $speed
	property $accel
	
	// オーナー／ＵＭＡデータを取得する
	$owner_id = $owner_list[$index]
	$uma_index = $$get_entry_owner_uma_list($index, $owner_uma_index[$index])

	// ＵＭＡパラメータを取得する
	$speed = $$get_uma_speed($owner_id, $uma_index)
	$accel = $$get_uma_accel($owner_id, $uma_index)

	// =========================== 最高速度 ===========================
	
	// ＵＭＡパラメータ(スピード)と速度上限／下限から補間した最高速度を求める
	$uma_base_speed_max[$index] = math.linear($speed, <UMA_PARAM_MIN>, <SPEED_MIN> * <TIME_SHIFT>, <UMA_PARAM_MAX>, <SPEED_MAX> * <TIME_SHIFT>)
	
	// レース地形がすべての場合はそのままの速度、芝／ダート／水面の場合は適性を計算する
	if( $$get_db_race_ground_type($race_id) != <URACE_GROUND_TYPE_SPACE> )
	{
		property $ground_affinity
		$ground_affinity = $$get_running_uma_ground_type($index, $race_ground_type) + $$get_running_uma_buff_ground_affinity($index)
		$ground_affinity = math.limit(<UMA_GROUND_TYPE_MIN>, $ground_affinity, <UMA_GROUND_TYPE_MAX>)
		// 地形適性がない場合は最高速度が減少する
		//switch( $$get_uma_ground_type($owner_id, $uma_index, $race_ground_type) ) {
		//switch( $$get_running_uma_ground_type($index, $race_ground_type) ) {
		switch( $ground_affinity ) {
		case(<UMA_GROUND_TYPE_C>)		// 何もしない																// 動けないデバフ付与中なので計算不要
		case(<UMA_GROUND_TYPE_B>)		$uma_base_speed_max[$index] = $uma_base_speed_max[$index] *  7500 / 10000		// △	75%
;		case(<UMA_GROUND_TYPE_B>)		$uma_base_speed_max[$index] = $uma_base_speed_max[$index] *  500 / 10000		// △	デバッグ用5%
		case(<UMA_GROUND_TYPE_A>)		// 何もしない																// ○	100%
		}
	}
	
	// 補正した結果、最低速度を下回っている場合は最低速度に丸める
	if( $uma_base_speed_max[$index] < <SPEED_MIN> * <TIME_SHIFT> ) {
;		$uma_base_speed_max[$index] = <SPEED_MIN> * <TIME_SHIFT>	// 開発用のデバッグ時はコメントアウトして下限オフにしてわかりやすくする
	}
	
	// 幸運値による最高速度追加補正を求める
	$uma_base_speed_max[$index] *= math.linear(100, <UMA_PARAM_MIN>, 100, <UMA_PARAM_MAX>, 110) / 100
	
	// 最高速度を設定する
	$uma_speed_max[$index] = $uma_base_speed_max[$index]
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの各データを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_id(property $index) : int { return ($uma_id[$index]) }				// ID
command $$get_running_uma_name(property $index) : str { return ($uma_name[$index]) }			// 名前
command $$get_running_uma_life(property $index) : int { return ($uma_life[$index]) }			// ライフ
command $$get_running_uma_life_max(property $index) : int { return ($uma_life_max[$index]) }	// 最大ライフ
command $$get_running_uma_speed(property $index) : int { return ($uma_speed[$index]) }			// 速度
command $$get_running_uma_speed_max(property $index) : int { return ($uma_speed_max[$index]) }	// 最高速度
command $$get_running_uma_accel(property $index) : int { return ($uma_accel[$index]) }			// 加速力

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの地形適性を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_ground_type(property $lane_index, property $ground_type) : int
{
	switch($ground_type) {
	case(<URACE_GROUND_TYPE_TURF>)		return ($uma_ground_type_turf[$lane_index])
	case(<URACE_GROUND_TYPE_DIRT>)		return ($uma_ground_type_dirt[$lane_index])
	case(<URACE_GROUND_TYPE_SURFACE>)	return ($uma_ground_type_surface[$lane_index])
	case(<URACE_GROUND_TYPE_SPACE>)		return (<UMA_GROUND_TYPE_A>)		// 宇宙は常にＡ（適性判定なし）
	}
	return (<UMA_GROUND_TYPE_B>)		// デフォルト値
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの芝適性を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_turf_type(property $lane_index) : int
{
	return ($uma_ground_type_turf[$lane_index])
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのダート適性を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_dirt_type(property $lane_index) : int
{
	return ($uma_ground_type_dirt[$lane_index])
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの砂質適性を取得する
//---------------------------------------------------------------------------
command $$get_running_uma_surface_type(property $lane_index) : int
{
	return ($uma_ground_type_surface[$lane_index])
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの自動加算テンションを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_plus_tension(property $index) : int { return ($uma_plus_tension[$index]) }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのジャンプ時間／力を設定する
//---------------------------------------------------------------------------
command $$set_running_uma_jump_param(property $index, property $power, property $time) : int
{
	$uma_jump_power[$index] = 0
	$uma_jump_power_max[$index] = $power
	
	$uma_jump_time[$index] = $time
	$uma_jump_time_max[$index] = $time
}

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのジャンプ時間／力を設定する
//---------------------------------------------------------------------------
command $$get_running_uma_jump_power(property $index) : int { return ($uma_jump_power[$index]) }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの潜伏力を取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_hide_mode_power(property $index) : int { return ($uma_hide_mode_power[$index]) }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの無敵フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_invincible_flag(property $index) : int { return ($uma_invincible_flag[$index]) }
command $$set_running_uma_invincible_flag(property $index, property $flag) { $uma_invincible_flag[$index] = $flag }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの無敵時間を取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_invincible_time(property $index) : int { return ($uma_invincible_time[$index]) }
command $$set_running_uma_invincible_time(property $index, property $flag) { $uma_invincible_time[$index] = $flag }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのブロックフラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_block_flag(property $index) : int { return ($uma_block_flag[$index]) }
command $$set_running_uma_block_flag(property $index, property $flag) { $uma_block_flag[$index] = $flag }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの停止フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_stop_flag(property $index) : int { return ($uma_stop_flag[$index]) }
command $$set_running_uma_stop_flag(property $index, property $time) { $uma_stop_flag[$index] = $time }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの行動を取得／設定する
//---------------------------------------------------------------------------
command $$get_running_uma_action_state(property $index) : int { return ($uma_action_state[$index]) }
command $$set_running_uma_action_state(property $index, property $state) { $uma_action_state[$index] = $state }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡの行動時間を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_running_uma_action_time(property $index) : int { return ($uma_action_time[$index]) }
command $$set_running_uma_action_time(property $index, property $time) { $uma_action_time[$index] = $time }
command $$add_running_uma_action_time(property $index, property $time) { $uma_action_time[$index] += $time }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのアクション中の障害物IDを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_action_trap_id(property $index) : int { return ($uma_action_trap_id[$index]) }

//---------------------------------------------------------------------------
// レースに参加しているＵＭＡのアクション中の障害物インデックスを取得する
//---------------------------------------------------------------------------
command $$get_running_uma_action_trap_index(property $index) : int { return ($uma_action_trap_index[$index]) }

//---------------------------------------------------------------------------
// レースに参加中のＵＭＡの行動を更新する
//---------------------------------------------------------------------------
command $$update_running_uma_action(property $index)
{
	// 停止フラグがある場合は更新を行わない
	if( $uma_stop_flag[$index] != 0 ) {
		return
	}
	
	// 失格の場合は更新を行わない
	if( $owner_retire[$index] ) {
		return
	}
	
	// 無敵時間がある場合は無敵時間の計算をする
	if( $uma_invincible_time[$index] > 0 ) {
		$uma_invincible_time[$index] -= $$get_delta_time
		
		if( $uma_invincible_time[$index] < 0 ) {
			$uma_invincible_time[$index] = 0
		}
	}
	
	
	
	
	
	
	
	$trap_use[$index] -= $$get_delta_time
	if( $trap_last_stepped_cooltime[$index] > 0 ) {
		$trap_last_stepped_cooltime[$index] -= $$get_delta_time
		if( $trap_last_stepped_cooltime[$index] <= 0 ) {
			$trap_last_stepped_lane[$index] = -1
			$trap_last_stepped_index[$index] = -1
		}
	}
	
	$uma_invincible_trap[$index] = $$get_running_uma_buff_trap_block($index)
	$uma_invincible_flag[$index] = $$get_running_uma_buff_interrupt_block($index)
	
	if( $$get_running_uma_buff_hide_mode_float($index) > 0 )
	{
		if( $uma_hide_mode[$index] != <UMA_HIDE_MODE_FLOAT> )
		{
			$uma_hide_mode[$index] = <UMA_HIDE_MODE_FLOAT>
			$uma_hide_mode_time[$index] = 0
			$uma_hide_mode_time_max[$index] = 1000
		}
	}
	elseif( $$get_running_uma_buff_hide_mode_dive($index) > 0 )
	{
		if( $uma_hide_mode[$index] != <UMA_HIDE_MODE_DIVE> )
		{
			$uma_hide_mode[$index] = <UMA_HIDE_MODE_DIVE>
			$uma_hide_mode_time[$index] = 0
			$uma_hide_mode_time_max[$index] = 1000
		}
	}
	else
	{
		if( $uma_hide_mode[$index] == <UMA_HIDE_MODE_FLOAT> || $uma_hide_mode[$index] == <UMA_HIDE_MODE_DIVE> )
		{
			$uma_hide_mode[$index] = <UMA_HIDE_MODE_NONE>
			$uma_hide_mode_time[$index] = 0
			$uma_hide_mode_time_max[$index] = 350
		}
	}
	
	$$calc_jump_position($index)
	
	switch( $uma_action_state[$index] ) {
	case(<RUNNING_UMA_ACTION_STATE_NONE>)			$$update_uma_action_none($index)			// -
	case(<RUNNING_UMA_ACTION_STATE_START_WAIT>)		$$update_uma_action_start_wait($index)		// スタート待機
	case(<RUNNING_UMA_ACTION_STATE_START>)			$$update_uma_action_start($index)			// スタート
	case(<RUNNING_UMA_ACTION_STATE_WAIT>)			$$update_uma_action_wait($index)			// 待機
	case(<RUNNING_UMA_ACTION_STATE_RUN>)			$$update_uma_action_run($index)				// 走り
	case(<RUNNING_UMA_ACTION_STATE_LANE_CHANGE>)	$$update_uma_action_lane_change($index)		// レーンチェンジ
	case(<RUNNING_UMA_ACTION_STATE_RUNNER_CHANGE>)	$$update_uma_action_runner_change($index)	// 交代中
	case(<RUNNING_UMA_ACTION_STATE_STUN>)			$$update_uma_action_stun($index)			// 気絶
	case(<RUNNING_UMA_ACTION_STATE_GROUND_WEAK>)	$$update_uma_action_ground_weak($index)		// 苦手地形
	case(<RUNNING_UMA_ACTION_STATE_LAUNCH>)			$$update_uma_action_launch($index)			// 打ち上げ
	case(<RUNNING_UMA_ACTION_STATE_COURSE_OUT>)		$$update_uma_action_course_out($index)		// コースアウト
	case(<RUNNING_UMA_ACTION_STATE_DEAD>)			$$update_uma_action_dead($index)			// 死亡
	case(<RUNNING_UMA_ACTION_STATE_GOAL>)			$$update_uma_action_goal($index)			// ゴール
	case(<RUNNING_UMA_ACTION_STATE_STONE>)			$$update_uma_action_stone($index)			// 気絶
		
	case(<RUNNING_UMA_ACTION_STATE_TRAP_FAILURE>)	$$update_uma_action_trap_failure($index)	// 障害物アクション／失敗
	}
	
	if( $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_START_WAIT> && $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_START> ) {
		$$update_running_uma_skill($index)
	}
	
	// ゴールしているので行動の更新は行わない
	if( $owner_goal_order[$index] != 0 )
	{
		return
	}
	
	if( $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_WAIT> &&
		$uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_START_WAIT> &&
		$uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_GOAL> )
	{
		if( $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_TRAP_FAILURE> && $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_STUN> && $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_STONE> )
		{
			$$add_entry_owner_skill_power($index, $uma_plus_tension[$index] * $$get_delta_time)
		}
		
		if( $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_TRAP_FAILURE> && $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_STUN> && $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_STONE> )
		{
			//$$update_uma_skill_action($index)
		}
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／なしを更新する
//---------------------------------------------------------------------------
command $$update_uma_action_none(property $index)
{
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／スタート待機を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_start_wait(property $index)
{
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／スタートを更新する
//---------------------------------------------------------------------------
command $$update_uma_action_start(property $index)
{
	$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
	$owner_voice_trigger[$index] = <OWNER_VOICE_TRIGGER_START>
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／待機を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_wait(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	if( $uma_action_time[$index] <= 0 )
	{
		$uma_action_time[$index] = 0
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／走りを更新する
//---------------------------------------------------------------------------
command $$update_uma_action_run(property $index)
{
;	// 走りアクション(走行距離)を計算する
;	$$calc_run_position($index)
;	
;	// 現在の地形が適性×の場合はスタンする
;	if( $$get_uma_ground_type($owner_list[$index], $$get_entry_owner_uma_list($index, $owner_uma_index[$index]), $race_ground_type) == <UMA_GROUND_TYPE_C> )
;	{
;		if( $$damage_uma($index, <GROUND_TYPE_DAMAGE>, <URACE_DAMAGE_TYPE_GROUND>) == 0 )
;		{
;			$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_GROUND_WEAK>
;			$uma_action_time[$index] = 3000
;		}
;	}
	// 走りアクション(走行距離)を計算する
	$$calc_run_position($index)
	
	// 現在の地形が適性×の場合はスタンする
	property $current_affinity
	property $buff_affinity
	property $final_affinity
	
	//$current_affinity = $$get_uma_ground_type($owner_list[$index], $$get_entry_owner_uma_list($index, $owner_uma_index[$index]), $race_ground_type)
	$current_affinity = $$get_running_uma_ground_type($index, $race_ground_type)
	$buff_affinity = $current_affinity + $$get_running_uma_buff_ground_affinity($index)
	// 仕様が不明なので、地形適性の補正値側は範囲制限なし（重複可）で最終値のみ制限を掛けた
	$final_affinity = math.limit(<UMA_GROUND_TYPE_MIN>, $current_affinity + $buff_affinity, <UMA_GROUND_TYPE_MAX>)
	;system.debug_write_log("[" + math.tostr($index) + "]cur:" + math.tostr($current_affinity) + "  buf:" + math.tostr($buff_affinity) + "  lim:" + math.tostr($final_affinity))
	if( $final_affinity == <UMA_GROUND_TYPE_C> )
	{
		if( $$damage_uma($index, <GROUND_TYPE_DAMAGE>, <URACE_DAMAGE_TYPE_GROUND>) == 0 )
		{
			$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_GROUND_WEAK>
			$uma_action_time[$index] = 3000
		}
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／レーンチェンジを更新する
//---------------------------------------------------------------------------
command $$update_uma_action_lane_change(property $index)
{
	// 走りアクション(走行距離)を計算する
	$$calc_run_position($index)
	
	$uma_action_time[$index] -= $$get_delta_time
	
	if( $uma_action_time[$index] <= 0 )
	{
		// 正常なレーンの場合は通常の走りへ遷移する
		if( 0 <= $now_lane[$index] && $now_lane[$index] < <URACE_LANE_MAX> )
		{
			$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
			
			return
		}
		
		// レーンの範囲外の場合はライフを失う
		if( $$damage_uma($index, <COURSE_OUT_DAMAGE>, <URACE_DAMAGE_TYPE_COURSE_OUT>) )
		{
			// 死亡している場合は終了
			return
		}
		
		// 生きている場合はコースアウトへ遷移する
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_COURSE_OUT>
		$uma_action_time[$index] = 2000
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／交代中を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_runner_change(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	if( $uma_action_time[$index] < 0 )
	{
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／死亡を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_dead(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	if( $uma_action_time[$index] < 0 )
	{
		// レーンの範囲外の場合は正常なレーンに戻す
		if( $now_lane[$index] <= -1 )
		{
			$$move_lane($index, 1)
		}
		if( $now_lane[$index] >= <URACE_LANE_MAX> )
		{
			$$move_lane($index, -1)
		}
		
		$$change_runnig_uma($index, 1000)
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／気絶を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_stun(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	$uma_speed[$index] = 0
	
	if( $uma_action_time[$index] < 0 )
	{
		// 固定速度が設定されている場合は元に戻す
		$uma_fixed_speed_max[$index] = -1
		
		$uma_action_time[$index] = 0
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／苦手地形を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_ground_weak(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	$uma_speed[$index] = 0
	
	if( $uma_action_time[$index] < 0 )
	{
		// 固定速度が設定されている場合は元に戻す
		$uma_fixed_speed_max[$index] = -1
		
		$uma_action_time[$index] = 0
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／打ち上げを更新する
//---------------------------------------------------------------------------
command $$update_uma_action_launch(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	$uma_speed[$index] = 0
	
	if( $uma_action_time[$index] < 0 )
	{
		// 固定速度が設定されている場合は元に戻す
		$uma_fixed_speed_max[$index] = -1
		
		$uma_action_time[$index] = 0
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／コースアウトを更新する
//---------------------------------------------------------------------------
command $$update_uma_action_course_out(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	if( $uma_action_time[$index] <= 0 )
	{
		// コースアウト待機時間が終了したらコースに戻す
		if( $now_lane[$index] <= -1 )
		{
			$$move_lane($index, 1)
		}
		elseif( $now_lane[$index] >= <URACE_LANE_MAX> )
		{
			$$move_lane($index, -1)
		}
	}
}

//---------------------------------------------------------------------------
// ＵＭＡの行動(障害物アクション／失敗)を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_trap_failure(property $lane_index)
{
	property $type
	
	// 障害物効果によって挙動を変更する
	$type = $$get_db_trap_effect_type($uma_action_trap_id[$lane_index])
	
	// 速度ＤＯＷＮの場合は走りアクション(走行距離)を計算する
	if( $type == <TRAP_EFFECT_TYPE_SPEED_DOWN> || $type == <TRAP_EFFECT_TYPE_SPEED_STAMINA_DOWN> )
	{
		$$calc_run_position($lane_index)
	}
	
	// アクション時間を減算する
	$uma_action_time[$lane_index] -= $$get_delta_time
	
	// アクション時間がある場合はアクションを継続する
	if( $uma_action_time[$lane_index] > 0 ) {
		return
	}
	
	// アクションが終了したので失敗効果を終了する
	switch( $type ) {
	case(<TRAP_EFFECT_TYPE_SPEED_DOWN>)		// 速度ＤＯＷＮ
		
		// 速度ＤＯＷＮの場合は最高速度を戻す
		$uma_fixed_speed_max[$lane_index] = -1
		
	case(<TRAP_EFFECT_TYPE_STUN>)			// スタン
		
		$uma_invincible_time[$lane_index] = 2000
		
	case(<TRAP_EFFECT_TYPE_SPEED_STAMINA_DOWN>)		// 速度・スタミナＤＯＷＮ
		
		// 速度ＤＯＷＮの場合は最高速度を戻す
		$uma_fixed_speed_max[$lane_index] = -1
	}
	
	// 走り中アクションへ
	$uma_action_time[$lane_index] = 0
	$uma_action_state[$lane_index] = <RUNNING_UMA_ACTION_STATE_RUN>
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／ゴールを更新する
//---------------------------------------------------------------------------
command $$update_uma_action_goal(property $index)
{
	$$calc_hide_mode_position($index)
}

//---------------------------------------------------------------------------
// ＵＭＡの行動／石化を更新する
//---------------------------------------------------------------------------
command $$update_uma_action_stone(property $index)
{
	$uma_action_time[$index] -= $$get_delta_time
	
	$uma_speed[$index] = 0
	
	if( $uma_action_time[$index] < 0 )
	{
		// 固定速度が設定されている場合は元に戻す
		$uma_fixed_speed_max[$index] = -1
		
		$uma_action_time[$index] = 0
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUN>
	}
}


//---------------------------------------------------------------------------
// ＵＭＡがダメージを受ける
//---------------------------------------------------------------------------
command $$damage_uma(property $index, property $damage, property $damage_type) : int
{
	// 追加、スキルかアイテムダメージなら
	if( $damage_type == <URACE_DAMAGE_TYPE_SKILL> || $damage_type == <URACE_DAMAGE_TYPE_ITEM> ) {
		// 妨害無効バフがある場合はブロック
		if( $$get_running_uma_buff_interrupt_block($index) > 0 )
		{
			//system.debug_write_log("★ダメ計["+math.tostr($index)+"] ブロック")
			$$set_running_uma_block_flag($index, 1)
			return (-1)  // ブロック成功
		}
	}

	//system.debug_write_log("★ダメ計["+math.tostr($index)+"] 現"+ math.tostr($uma_life[$index]) + "  量" + math.tostr($damage))
	// ライフを減らす
	$uma_life[$index] -= $damage
	
	// 死亡している場合は死亡遷移へ
	if( $uma_life[$index] <= 0 )
	{
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_DEAD>
		
		$$retire_uma_tip($index)
		
		// 死亡している場合は1を返す
		return (1)
	}
	
	if( $uma_action_state[$index] == <RUNNING_UMA_ACTION_STATE_STUN> ) {	// 気絶・スタンからの非ダメで打ち上げ？
		$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_LAUNCH>
		$uma_action_time[$index] = 2000
		$$set_running_uma_jump_param($index, 200, 2000)
	}
	// 生存している場合は0を返す
	return (0)
}
//---------------------------------------------------------------------------
// ＵＭＡにダメージを与える
//---------------------------------------------------------------------------
command $$take_damage_uma(property $index, property $damage) : int
{
	//system.debug_write_log("★与ダメ["+ math.tostr($index) + "]" + math.tostr($damage))
	return ( $$damage_uma($index, $damage, <URACE_DAMAGE_TYPE_FORCE>) )
}

//---------------------------------------------------------------------------
// ＵＭＡのHPを回復する
//---------------------------------------------------------------------------
command $$heal_damage_uma(property $index, property $heal_amount) : int
{
	//system.debug_write_log("★回復["+ math.tostr($index) + "]" + math.tostr($heal_amount))
	// 死亡状態の場合は回復不可（復活不可）
	if( $uma_action_state[$index] == <RUNNING_UMA_ACTION_STATE_DEAD> ) {
		return (0)  // 回復失敗
	}

	// ライフを回復
	$uma_life[$index] += $heal_amount

	// 最大HPを超えないようにクランプ
	if( $uma_life[$index] > $uma_life_max[$index] ) {
		$uma_life[$index] = $uma_life_max[$index]
	}

	return (1)  // 回復成功
}

//---------------------------------------------------------------------------
// ＵＭＡへダメージを与えて、与えたダメージ分だけ自分のHPを回復する（吸収）
//---------------------------------------------------------------------------
command $$drain_damage_uma(property $attacker_index, property $target_index, property $damage, property $damage_type) : int
{
	property $actual_damage
	property $target_life_before

	// ターゲットの現在HP記録
	$target_life_before = $uma_life[$target_index]

	// ダメージ処理実行
	property $is_dead
	$is_dead = $$damage_uma($target_index, $damage, $damage_type)

	// 実際に与えたダメージ量を計算
	if( $is_dead == 1 ) {
		// ブロックされた、または死亡した
		if( $uma_life[$target_index] <= 0 ) {
			// 死亡: 死亡前のライフ分だけ吸収
			$actual_damage = $target_life_before
		}
		else {
			// ブロック: 吸収なし
			$actual_damage = 0
		}
	}
	else {
		// 通常ダメージ: 実際に減少した量を吸収
		$actual_damage = $target_life_before - $uma_life[$target_index]
	}

	// 攻撃者のHP回復（吸収量 = 与えたダメージ量）
	if( $actual_damage > 0 ) {
		$$heal_damage_uma($attacker_index, $actual_damage)
	}

	return ($is_dead)
}


//---------------------------------------------------------------------------
// ＵＭＡの走行距離を計算する
//---------------------------------------------------------------------------
command $$calc_run_position(property $lane_index)
{
	property $speed
	property $delta_time
	
	$delta_time = $$get_delta_time
	
	// 加速力を計算する
	// -> ベース加速力 * バフ／デバフ補正
	$uma_accel[$lane_index] = $uma_base_accel[$lane_index] * $$get_running_uma_buff_accel($lane_index) / 100
	
	// 加速力に前フレームから経過した時間を掛けて速度にする
	$uma_speed[$lane_index] += $uma_accel[$lane_index] * $delta_time
	
	// 最高速度を計算する
	// - 固定値が指定されている場合 > 固定値最高速度
	// - スタミナがある場合 > ベース最高速度 * バフ／デバフ補正
	// - スタミナがない場合 > スタミナ切れ速度 * バフ／デバフ補正
	if( $uma_fixed_speed_max[$lane_index] != -1 )
	{
		$uma_speed_max[$lane_index] = $uma_fixed_speed_max[$lane_index]
	}
	else
	{
;		if( $uma_life[$lane_index] > 0 )
;		{
			$$calc_running_uma_speed_max($lane_index)	// 追加
			$uma_speed_max[$lane_index] = $uma_base_speed_max[$lane_index] * $$get_running_uma_buff_speed_max($lane_index) / 100
;		}
;		else
;		{
;			$uma_speed_max[$lane_index] = (<STAMINA_MIN_SPEED> * <TIME_SHIFT>) * $$get_running_uma_buff_speed_max($lane_index) / 100
;		}
	}
	
	// 現在の速度が最高速度を超えている場合は丸める
	if( $uma_speed_max[$lane_index] < $uma_speed[$lane_index] )
	{
		$uma_speed[$lane_index] = $uma_speed_max[$lane_index]
	}
	
	// 補正速度(テンション)を乗算する
	// ※速度補正値によっては最大速度を超過する
	//$speed = $uma_speed[$lane_index] * $uma_tension[$lane_index] / 100
	$speed = $uma_speed[$lane_index]
	
	// 逆走
	if( $$get_running_uma_buff_reverse_run($lane_index) )
	{
		$speed *= -1
	}
	
	// 走行距離に速度を加算する
	$owner_mileage[$lane_index] += $speed * $delta_time / 1000
	
	// レース距離を超えている場合はゴールとする
	if( $race_distance < $owner_mileage[$lane_index] )
	{
		$owner_mileage[$lane_index] = $race_distance
		
		// 着順を設定する
		if( $owner_goal_order[$lane_index] == 0 )
		{
			$race_total_goal_num += 1
			$owner_goal_order[$lane_index] = $race_total_goal_num
			
			// スキル発動中の場合は停止する
			if( $$get_running_uma_active_skill_id($lane_index) != 0 ) {
				$$deactivate_running_uma_skill($lane_index)
			}
			
			$uma_action_state[$lane_index] = <RUNNING_UMA_ACTION_STATE_GOAL>
			
			// deb
			l[0] = @mng_counter.get
			l[1] = l[0]
			l[2] = l[0] % 1000
			$owner_goal_time[$lane_index] = l[1]
			//@todo($uma_name[$lane_index] + ">ゴール:" + math.tostr(l[1] / 1000) + "." + math.tostr(l[2]) + "秒")
			
			$owner_voice_trigger[$lane_index] = <OWNER_VOICE_TRIGGER_GOAL>
		}
	}
	
	// スタート地点以下の場合はスタート地点に丸める
	if( $owner_mileage[$lane_index] < 0 )
	{
		$owner_mileage[$lane_index] = 0
	}
}

//---------------------------------------------------------------------------
// ＵＭＡのジャンプ位置を計算する
//---------------------------------------------------------------------------
command $$calc_jump_position(property $lane_index)
{
	property $degree
	
	$uma_jump_time[$lane_index] -= $$get_delta_time
	if( $uma_jump_time[$lane_index] < 0 ) {
		$uma_jump_time[$lane_index] = 0
	}
	
	$degree = math.linear($uma_jump_time[$lane_index], 0, 0, $uma_jump_time_max[$lane_index], 1800)
	
	$uma_jump_power[$lane_index] = $uma_jump_power_max[$lane_index] * math.sin($degree, 100) / 100
	
	$$calc_hide_mode_position($lane_index)
}

//---------------------------------------------------------------------------
// ＵＭＡの潜伏モードの位置を計算をする
//---------------------------------------------------------------------------
command $$calc_hide_mode_position(property $lane_index)
{
	$uma_hide_mode_time[$lane_index] += $$get_delta_time
	if( $uma_hide_mode_time[$lane_index] > $uma_hide_mode_time_max[$lane_index] ) {
		$uma_hide_mode_time[$lane_index] = $uma_hide_mode_time_max[$lane_index]
	}
	
	if( $$get_running_uma_buff_hide_mode_float($lane_index) )
	{
		$uma_hide_mode_power[$lane_index] = math.timetable($uma_hide_mode_time[$lane_index], 0, 0, [0, 500, 0], [500, $uma_hide_mode_time_max[$lane_index], 100])
	}
	elseif( $$get_running_uma_buff_hide_mode_dive($lane_index) )
	{
		$uma_hide_mode_power[$lane_index] = math.timetable($uma_hide_mode_time[$lane_index], 0, 0, [0, 500, 0], [500, $uma_hide_mode_time_max[$lane_index], -100])
	}
	else
	{
		if( $uma_hide_mode_power[$lane_index] > 0 ) {
			$uma_hide_mode_power[$lane_index] = math.timetable($uma_hide_mode_time[$lane_index], 0, 100, [0, $uma_hide_mode_time_max[$lane_index], 0])
		}
		elseif( $uma_hide_mode_power[$lane_index] < 0 ) {
			$uma_hide_mode_power[$lane_index] = math.timetable($uma_hide_mode_time[$lane_index], 0, -100, [0, $uma_hide_mode_time_max[$lane_index], 0])
		}
	}
}

//---------------------------------------------------------------------------
// 障害物アクション判定（失敗）
//---------------------------------------------------------------------------
command $$failure_trap_input(property $owner_index, property $trap_id, property $trap_index)
{
	property $effect_type
	property $effect_amount
	
	//$trap_use[$owner_index] = 500
	$trap_last_stepped_lane[$owner_index] = $now_lane[$owner_index]
	$trap_last_stepped_index[$owner_index] = $trap_index
	$trap_last_stepped_cooltime[$owner_index] = <SAME_TRAP_INDEX_COOL_TIME>
	
	// 障害物の失敗効果を取得する
	$effect_type = $$get_db_trap_effect_type($trap_id)
	$effect_amount = $$get_db_trap_effect_amount($trap_id)
	
	// 障害物によって効果を変更する
	switch( $effect_type ) {
	case(<TRAP_EFFECT_TYPE_SPEED_DOWN>)		// 速度ＤＯＷＮ
		
		// 固定最高速度を設定する
		$uma_fixed_speed_max[$owner_index] = (<SPEED_MIN> / 2) * <TIME_SHIFT>
		
	case(<TRAP_EFFECT_TYPE_STUN>)			// スタン
		
		// 停止する
		$uma_speed[$owner_index] = 0
		
	case(<TRAP_EFFECT_TYPE_SPEED_STAMINA_DOWN>)		// 速度・スタミナＤＯＷＮ
		
		// 固定最高速度を設定する
		$uma_fixed_speed_max[$owner_index] = (<SPEED_MIN> / 2) * <TIME_SHIFT>
		
	case(<TRAP_EFFECT_TYPE_SPEED_UP>)		// 速度ＵＰ
		
		$$activate_running_uma_skill($owner_index, 1, 1)
		
		$uma_action_state[$owner_index] = <RUNNING_UMA_ACTION_STATE_RUN>
		
		return
	}
	
	// アクション中の障害物IDを設定する
	$uma_action_trap_id[$owner_index] = $trap_id
	$uma_action_trap_index[$owner_index] = $trap_index
	
	// スキル発動中の場合は停止する
	if( $$get_running_uma_active_skill_id($owner_index) != 0 ) {
		$$deactivate_running_uma_skill($owner_index)
	}
	
	// アクション失敗時の消失フラグがある場合は障害物を無効にする
	if( $$get_db_trap_vanishing_flag($trap_id) == <TRAP_VANISHING_TYPE_FAILURE> ) {
		$$set_trap_enable($now_lane[$owner_index], $trap_index, 0)
	}
	
	// 障害物アクション／失敗へ
	$uma_action_state[$owner_index] = <RUNNING_UMA_ACTION_STATE_TRAP_FAILURE>
	$uma_action_time[$owner_index] = $effect_amount
	
	// ボイス再生トリガーを発行する
	$owner_voice_trigger[$owner_index] = <OWNER_VOICE_TRIGGER_TRAP_FAILURE>
	
	//2
	$$damage_uma($owner_index, 3, <URACE_DAMAGE_TYPE_TRAP>)
}

//---------------------------------------------------------------------------
// すべてのＵＭＡをゴールへスキップする
//---------------------------------------------------------------------------
command $$skip_to_goal_all_uma
{
	property $i
	property $j
	property $len
	property $base_time
	property $min
	property $min_time
	
	$len = $$get_entry_owner_num
	$base_time = @mng_counter.get
	
	// ゴールしてないＵＭＡの残り距離を計算する
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $owner_goal_order[$i] != 0 ) {
			continue
		}
		
		// スキルを停止する
		$$deactivate_running_uma_skill($i)
		
		// ゴールタイムを設定する
		$$calc_running_uma_speed_max($i)	// ★追加 todo_suzuki:要検討 バフを含めた地形適性から $uma_base_speed_max を再計算しているのでバフ切れる前にスキップは実質得になる
		$owner_goal_time[$i] = $base_time + ($race_distance - $owner_mileage[$i]) / $uma_base_speed_max[$i] * <DISTACE_SHIFT> + math.rand(0, 999)
		
		$owner_mileage[$i] = $race_distance
		$uma_action_state[$i] = <RUNNING_UMA_ACTION_STATE_GOAL>
	}
	
	while( $race_total_goal_num < $len )
	{
		$min_time = 999 * <TIME_SHIFT>
		
		for( $i = 0, $i < $len, $i += 1 )
		{
			if( $owner_goal_order[$i] != 0 ) {
				continue
			}
			
			if( $owner_goal_time[$i] < $min_time )
			{
				$min_time = $owner_goal_time[$i]
				$min = $i
			}
		}
		
		$race_total_goal_num += 1
		$owner_goal_order[$min] = $race_total_goal_num
	}
}

//---------------------------------------------------------------------------
// 参加者（オーナー）のIDを取得する
//---------------------------------------------------------------------------
command $$get_entry_owner_id(property $owner_index) : int { return ($owner_list[$owner_index]) }

//---------------------------------------------------------------------------
// 参加者（オーナー）の総人数を取得する
//---------------------------------------------------------------------------
command $$get_entry_owner_num : int
{
	property $i
	property $count
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		if( $owner_list[$i] == 0 ) {
			break
		}
		
		$count += 1
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// 参加者（オーナー）からプレイヤーのインデックスを取得する
//---------------------------------------------------------------------------
command $$get_player_from_entry_owner_list : int
{
	return ($$get_index_from_entry_owner_list(<URACE_PLAYER_OWNER_ID>))
}

//---------------------------------------------------------------------------
// 参加者（オーナー）からライバルのインデックスを取得する
//---------------------------------------------------------------------------
command $$get_rival_from_entry_owner_list : int
{
	return ($$get_index_from_entry_owner_list($$get_db_race_entry_rival($$get_entry_race_id)))
}

//---------------------------------------------------------------------------
// 参加者（オーナー）から指定したオーナーのインデックスを取得する
//---------------------------------------------------------------------------
command $$get_index_from_entry_owner_list(property $owner_id) : int
{
	property $i
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		if( $owner_list[$i] == $owner_id ) {
			return ($i)
		}
	}
	
	return (-1)
}

//---------------------------------------------------------------------------
// 参加者（オーナー）のＵＭＡリストを取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_owner_uma_list(property $owner_index, property $uma_index) : int
{
	return ($owner_uma_list[<URACE_DECK_UMA_MAX> * $owner_index + $uma_index])
}

command $$set_entry_owner_uma_list(property $owner_index, property $uma_index, property $user_uma_index)
{
	$owner_uma_list[<URACE_DECK_UMA_MAX> * $owner_index + $uma_index] = $user_uma_index
}

//---------------------------------------------------------------------------
// 参加者（オーナー）の総ＵＭＡ数を取得する
//---------------------------------------------------------------------------
command $$get_entry_owner_uma_list_num(property $owner_index) : int
{
	property $i
	property $count
	
	for( $i = 0, $i < <URACE_DECK_UMA_MAX>, $i += 1 )
	{
		if( $owner_uma_list[<URACE_DECK_UMA_MAX> * $owner_index + $i] == -1 ) {
			break
		}
		
		$count += 1
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// 参加者（オーナー）の走行中ＵＭＡインデックスを取得する
//---------------------------------------------------------------------------
command $$get_entry_owner_uma_index(property $owner_index) : int { return ($owner_uma_index[$owner_index]) }

//---------------------------------------------------------------------------
// 参加者（オーナー）の走行距離を取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_owner_mileage(property $owner_index) : int { return ($owner_mileage[$owner_index]) }
command $$set_entry_owner_mileage(property $owner_index, property $value) { $owner_mileage[$owner_index] = $value }

//---------------------------------------------------------------------------
// 参加者（オーナー）のスキルゲージを取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_owner_skill_power(property $owner_index) : int { return ($owner_skill_power[$owner_index]) }
command $$set_entry_owner_skill_power(property $owner_index, property $value) { $owner_skill_power[$owner_index] = $value }
command $$set_entry_owner_skill_power_max(property $owner_index) { $owner_skill_power[$owner_index] = <OWNER_SKILL_POWER_MAX> * <SKILL_POWER_SHIFT> }
command $$add_entry_owner_skill_power(property $owner_index, property $value) { $owner_skill_power[$owner_index] = math.limit(<OWNER_SKILL_POWER_MIN> * <SKILL_POWER_SHIFT>, $owner_skill_power[$owner_index] + $value, <OWNER_SKILL_POWER_MAX> * <SKILL_POWER_SHIFT>) }

//---------------------------------------------------------------------------
// 参加者（オーナー）の失格フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_owner_retire(property $owner_index) : int { return ($owner_retire[$owner_index]) }
command $$set_entry_owner_retire(property $owner_index, property $flag) { $owner_retire[$owner_index] = $flag }

//---------------------------------------------------------------------------
// 参加者（オーナー）の総失格人数を取得する
//---------------------------------------------------------------------------
command $$get_entry_owner_retire_num : int
{
	property $i
	property $count
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		if( $owner_retire[$i] ) {
			$count += 1
		}
	}
	
	return ($count)
}

//---------------------------------------------------------------------------
// 参加者（オーナー）の着順を取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_owner_goal_order(property $owner_index) : int { return ($owner_goal_order[$owner_index]) }
command $$set_entry_owner_goal_order(property $owner_index, property $order) { $owner_goal_order[$owner_index] = $order }

//---------------------------------------------------------------------------
// １着の参加者（オーナー）を取得する
//---------------------------------------------------------------------------
command $$get_1st_goal_entry_owner_id : int
{
	property $i
	
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		if( $$get_entry_owner_goal_order($i) == 1 ) {
			return ($$get_entry_owner_id($i))
		}
	}
	
	return (-1)
}


//---------------------------------------------------------------------------
// 参加者（オーナー）のゴール時間を取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_owner_goal_time(property $owner_index) : int { return ($owner_goal_time[$owner_index]) }
command $$set_entry_owner_goal_time(property $owner_index, property $time) { $owner_goal_time[$owner_index] = $time }

//---------------------------------------------------------------------------
// 参加者（オーナー）のボイス再生トリガーを取得／設定する
//---------------------------------------------------------------------------
command $$get_entry_owner_voice_trigger(property $owner_index) : int { return ($owner_voice_trigger[$owner_index]) }
command $$set_entry_owner_voice_trigger(property $owner_index, property $value) { $owner_voice_trigger[$owner_index] = $value }

//---------------------------------------------------------------------------
// 参加者（オーナー）のＮＰＣの思考時間を取得する
//---------------------------------------------------------------------------
command $$get_entry_owner_npc_think_time(property $owner_index) : int { return ($owner_npc_think_time[$owner_index]) }





//2
command $$has_next_uma(property $index)
{
	if( $owner_uma_index[$index] == <URACE_DECK_UMA_MAX> - 1 ) {
		return (0)
	}
	
	if( $owner_uma_list[$index * <URACE_DECK_UMA_MAX> + $owner_uma_index[$index] + 1] == -1 ) {
		return (0)
	}
	
	return (1)
}

command $$get_left_uma(property $index)
{
	property $i
	property $count
	
	for( $i = $owner_uma_index[$index], $i < <URACE_DECK_UMA_MAX>, $i += 1 )
	{
		if( $owner_uma_list[$index * <URACE_DECK_UMA_MAX> + $i] == -1 ) {
			break
		}
		
		$count += 1
	}
	
	return ($count)
}

command $$change_runnig_uma(property $index, property $time)
{
	$owner_uma_index[$index] += 1
	
	if( $owner_uma_index[$index] >= <URACE_DECK_UMA_MAX> )
	{
		$owner_goal_order[$index] = $$get_entry_owner_num - $$get_entry_owner_retire_num
		$owner_retire[$index] = 1
		$$retire_uma_tip($index)
		return
	}
	
	if( $$get_entry_owner_uma_list($index, $owner_uma_index[$index]) == -1 )
	{
		$owner_goal_order[$index] = $$get_entry_owner_num - $$get_entry_owner_retire_num
		$owner_retire[$index] = 1
		$$retire_uma_tip($index)
		return
	}
	
	$$init_running_uma_data($index)
	$$init_running_uma_buff
	$uma_invincible_time[$index] = 3000
	
	$$change_uma_tip($index)
	
	$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_RUNNER_CHANGE>
	$uma_action_time[$index] = $time
}

command $$get_now_lane(property $index)
{
	return ($now_lane[$index])
}


command $$move_lane(property $index, property $dst)
{
	$now_lane[$index] = math.limit(0, $now_lane[$index] + $dst, <URACE_LANE_MAX> - 1)
	
	$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_LANE_CHANGE>
	$uma_action_time[$index] = 150
}

command $$move_lane_out(property $index, property $dst)
{
	$now_lane[$index] = math.limit(-1, $now_lane[$index] + $dst, <URACE_LANE_MAX>)
	
	$uma_action_state[$index] = <RUNNING_UMA_ACTION_STATE_LANE_CHANGE>
	$uma_action_time[$index] = 150
}

command $$check_trap(property $owner_index)
{
	property $i
	property $len
	property $trap_id
	property $trap_place
	property $trap_size
	
	if( $$get_running_uma_action_state($owner_index) != <RUNNING_UMA_ACTION_STATE_RUN> ) {
		return
	}
	
	if( $uma_invincible_time[$owner_index] > 0 ) {
		return
	}
	
	if( $uma_invincible_trap[$owner_index] > 0 ) {	// 追加
		return
	}
	
	if( $now_lane[$owner_index] <= -1 || $now_lane[$owner_index] >= <URACE_LANE_MAX> ) {
		return
	}
	
	$len = $$get_trap_num($now_lane[$owner_index])
	for( $i = 0, $i < $len, $i += 1 )
	{
		$trap_id = $$get_trap_id($now_lane[$owner_index], $i)
		$trap_place = $$get_trap_place($now_lane[$owner_index], $i)
		
		switch( $trap_id ) {
		case(1)		$trap_size = math.linear(88, 192, 10000, 1920, 100000)
		case(2)		$trap_size = math.linear(182, 192, 10000, 1920, 100000)
		case(3)		$trap_size = math.linear(324, 192, 10000, 1920, 100000)
		case(4)		$trap_size = math.linear(234, 192, 10000, 1920, 100000)
		case(5)		$trap_size = math.linear(120, 192, 10000, 1920, 100000)
		case(6)		$trap_size = math.linear(137, 192, 10000, 1920, 100000)
		case(7)		$trap_size = math.linear(269, 192, 10000, 1920, 100000)
		case(8)		$trap_size = math.linear(206, 192, 10000, 1920, 100000)
		case(9)		$trap_size = math.linear(216, 192, 10000, 1920, 100000)
		case(10)	$trap_size = math.linear(270, 192, 10000, 1920, 100000)
		case(11)	$trap_size = math.linear(194, 192, 10000, 1920, 100000)
		}
		
		if( $owner_mileage[$owner_index] < $trap_place ) {
			continue
		}
		
		if( $trap_place + $trap_size < $owner_mileage[$owner_index] ) {
			continue
		}
		
		if( $$get_trap_enable($now_lane[$owner_index], $i) == 0 ) {
			continue
		}
		
		if( $trap_use[$owner_index] > 0 ) {
			continue
		}
		
		// 追加: 同一トラップの再踏み判定
		if( $trap_last_stepped_cooltime[$owner_index] > 0 ) {
			if( $trap_last_stepped_lane[$owner_index] == $now_lane[$owner_index] &&
				$trap_last_stepped_index[$owner_index] == $i ) {
				continue  // 同じトラップは踏めない
			}
		}
		
		// 旧版：コマンド内で加速効果ならスキルID 1発動
		//$$failure_trap_input($owner_index, $trap_id, $i)
		
		// 新版：ダッシュ板なら直接バフ付与
		if( $trap_id == @レース障害物_ダッシュ板 ) {
			system.debug_write_log("★ダッシュ板 $owner_index:" + math.tostr($owner_index))
			
			// スキル経由せず直接バフ
			$$add_running_uma_buff($owner_index, $owner_index, 0,
				<RUNNING_UMA_BUFF_TYPE_REDUCE_SPEED_MAX>,
				2500,	// 効果時間
				100,	// 効果量
				0)		// ディレイなし
			$$add_running_uma_buff($owner_index, $owner_index, 0,
				<RUNNING_UMA_BUFF_TYPE_ACCEL>,
				2500,	// 効果時間
				1000,	// 効果量
				0)		// ディレイなし
				
			// 毎フレーム踏まないようにする処理、ただし他のトラップも抜けるので改良する？
			//$trap_use[$owner_index] = 500
			$trap_last_stepped_lane[$owner_index] = $now_lane[$owner_index]
			$trap_last_stepped_index[$owner_index] = $i
			$trap_last_stepped_cooltime[$owner_index] = <SAME_TRAP_INDEX_COOL_TIME>
			// 走り状態へ、本当に必要かは要調査
			$uma_action_state[$owner_index] = <RUNNING_UMA_ACTION_STATE_RUN>
		} else {
			$$failure_trap_input($owner_index, $trap_id, $i)
		}
		
		break
	}
}

command $$npc(property $index)
{
	property $i
	property $len
	property $npc_avoid
	property $trap_place
	property $trap_size
	property $lane
	
	if( $uma_action_state[$index] != <RUNNING_UMA_ACTION_STATE_RUN> ) {
		return
	}
	
	if( $$get_player_from_entry_owner_list != $index || $$get_urace_auto_play_flag )
	{
		$$npc_try_use_skill($index)		// ★スキル判定追加
		if( $$has_urace_race_item($index) )
		{
			if( $$get_urace_race_item_id($index) == 2 && $$get_now_lane($index) < $$get_now_lane($$get_1st_order) - 1 )
			{
				$$move_lane($index, 1)
				$owner_npc_think_time[$index] = math.rand(3000, 4000)
			}
			if( $$get_urace_race_item_id($index) == 2 && $$get_now_lane($index) > $$get_now_lane($$get_1st_order) + 1 )
			{
				$$move_lane($index, -1)
				$owner_npc_think_time[$index] = math.rand(3000, 4000)
			}
			
			if( $owner_npc_think_time[$index] <= 3000 )
			{
				$$use_urace_race_item($index)
				$owner_npc_think_time[$index] = math.rand(5000, 10000)
			}
			
		
		
		}
	}
	
	if( $$get_player_from_entry_owner_list != $index || $$get_urace_auto_play_flag )
	{
		// npc
		if( math.rand(0, 2) == 0 ) {
			$npc_avoid = 1
		} elseif( math.rand(0, 2) == 0 ) {
			$npc_avoid = -1
		}
	}
	
	if( $owner_npc_think_time[$index] <= 0 )
	{
		$$move_lane($index, $npc_avoid)
		$owner_npc_think_time[$index] = math.rand(5000, 10000)
	}
	else
	{
		$owner_npc_think_time[$index] -= $$get_delta_time
	}
	
	$lane = $$get_now_lane($index)
	$trap_size = math.linear(81, 192, 10000, 1920, 100000)
	
	$len = $$get_trap_num($index)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$trap_place = $$get_trap_place($lane, $i)
		
		if( $$get_player_from_entry_owner_list != $index || $$get_urace_auto_play_flag )
		{
			if( $owner_mileage[$index] < $trap_place ) {
				continue
			}
			
			if( $trap_place + $trap_size < $owner_mileage[$index] ) {
				continue
			}
			
			if( $owner_npc_think_time[$index] < 8000 ) {
				if( math.rand(0, 99) <= 90 )
				{
					if( math.rand(0, 1) ) {
						$$move_lane($index, 1)
					} else {
						$$move_lane($index, -1)
					}
				}
				
				$owner_npc_think_time[$index] = math.rand(5000, 6000)
			}
		}
	}
}
//---------------------------------------------------------------------------
// NPCのスキル使用判定（独立関数）
// 引数: $index - NPCのレーンインデックス
// 戻り値: なし（スキル発動時は内部で思考時間をリセット）
//---------------------------------------------------------------------------
command $$npc_try_use_skill(property $index)
{
	property $skill_id
	
	// スキルが有効でない場合は何もしない
	if( $$get_running_uma_skill_enable($index) != 1 ) {
		return
	}

	// 思考時間が0.5秒以下になったらスキル発動を検討
	if( $owner_npc_think_time[$index] > 500 ) {
		return
	}
	
	// スキル使用可能状態をチェック
	// （ゲージ満タン、使用中でない、特殊状態でない等）
	if( $$is_running_uma_active_skill_available($index) != 1 ) {
		return
	}

	// 8%の確率でスキル使用（0.5秒以下の8%はだいたいレーン変更発動前に9割型発動）
	if( math.rand(0, 99) >= 8 ) {
		return
	}

	// スキルID取得
	$skill_id = $$get_running_uma_skill_id($index)

	// スキルIDが無効な場合は何もしない
	if( $skill_id == 0 ) {
		return
	}

	// スキル発動
	$$activate_running_uma_skill($index, $skill_id, 0)

	// 思考時間をリセット
	$owner_npc_think_time[$index] = math.rand(1000, 2000)
}

command $$check_item(property $index)
{
	property $i
	property $len
	property $item_id
	property $item_place
	property $item_size
	property $item_list : intlist
	property $item_rate : intlist
	property $lane
	
	if( $now_lane[$index] <= -1 || $now_lane[$index] >= <URACE_LANE_MAX> ) {
		return
	}
	
	$lane = $$get_now_lane($index)
	$item_size = math.linear(75, 192, 10000, 1920, 100000)
	
	$len = $$get_item_size
	for( $i = 0, $i < $len, $i += 1 )
	{
		$item_id = $$get_entry_lane_item_id($lane, $i)
		$item_place = $$get_entry_lane_item_place($lane, $i)
		
		if( $item_id == <URACE_EMPTY_RACE_ITEM_ID> ) {
			continue
		}
		// 既に獲得済み（enableフラグが0）のアイテムはスキップ
		if( $$get_entry_lane_item_enable($lane, $i) == 0 ) {
			continue
		}
		
		if( $owner_mileage[$index] < $item_place ) {
			continue
		}
		
		if( $item_place + $item_size < $owner_mileage[$index] ) {
			continue
		}
		
		$$set_entry_lane_item_enable($lane, $i, 0)
		$$del_item_box($lane, $i)
		
		//2
		$$pick_urace_race_item($index)
		
		break
	}
}

command $$update_order
{
	property $i
	property $j
	property $len
	property $tmp
	property $mile  :intlist[6]
	property $orde  :intlist[6]
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		$orde[$i] = $i
		$mile[$i] = $owner_mileage[$i]
	}
	
	$len = $$get_entry_owner_num - 1
	for( $i = 0, $i < $len, $i += 1 )
	{
		for( $j = $len, $j > $i, $j -= 1 )
		{
			if( $mile[$j] > $mile[$j - 1] )
			{
				$tmp = $mile[$j]
				$mile[$j] = $mile[$j - 1]
				$mile[$j - 1] = $tmp
				
				$tmp = $orde[$j]
				$orde[$j] = $orde[$j - 1]
				$orde[$j - 1] = $tmp
			}
		}
	}
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		$order[$orde[$i]] = $i + 1
	}
}
command $$get_order(property $index) { return ($order[$index]) }

command $$get_1st_order
{
	property $i
	property $len
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $order[$i] == 1 )
		{
			return ($i)
		}
	}
}
