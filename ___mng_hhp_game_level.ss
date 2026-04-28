//===========================================================================
//!
//!    @file     ___mng_hhp_game_level.ss
//!    @brief    ヘビヘビパニックゲームレベル管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	#property	$difficulty				// 難易度
	
	#property	$wave					// 現在進行中のウェーブ
	#property	$wave_max				// 最大ウェーブ
	
	#property	$time_limit				// プレイ制限時間
	#property	$time_limit_stop		// プレイ制限時間停止フラグ
	
	#property	$boss_type				// ボスタイプ
	
	// 敵生成データ
	#property	$spawn_enemy_list : intlist		// 出現する敵リスト
	#property	$spawn_enemy_index				// 敵生成に使用するインデックス
	#property	$enemy_spawn_count				// 敵生成位置数
	#property	$enemy_spawn_x : intlist		// 敵生成座標(x)
	#property	$enemy_spawn_y : intlist		// 敵生成座標(y)
	#property	$enemy_target_x : intlist		// 敵移動目標座標(x)
	#property	$enemy_target_y					// 敵移動目標座標(y)
	
	// 生成管理データ
	#property	$spawn_time					// 敵生成時間(０以下になると敵が生成される)
	#property	$spawn_start_time			// 最初に敵生成が実行される時間
	#property	$spawn_next_time			// 次に敵生成が実行される時間
	#property	$spawn_next_time_min		// 次に敵生成が実行される時間の最低値
	#property	$spawn_diff_time			// 前生成と次生成の差分時間
	#property	$spawn_shield_rate			// 敵生成時にシールドを発生させる確率
	#property	$multi_spawn_rate			// 一度の生成で複数の敵が生成する確率
	
	// デフォルト敵データ
	#replace	<DEFAULT_ENEMY_DATA_MAX>	7				//  敵データ（敵の種類）最大数
	
	#property	$enemy_life_default			: intlist		// ライフ
	#property	$enemy_move_speed_default	: intlist		// 移動速度
	#property	$enemy_attack_power_default	: intlist		// 攻撃力		[1回の攻撃で与えるダメージ、1なら攻撃時にプレイヤーに1のダメージを与える]
	#property	$enemy_attack_speed_default	: intlist		// 攻撃速度		[1回の攻撃にかける秒数、1000を指定すると1秒に1回攻撃をする]
	#property	$enemy_attack_count_default	: intlist		// 攻撃回数		[自動逃走するまでの攻撃回数、3を指定すると敵が3回攻撃をすると逃走する]
	
#inc_end

#z00

//---------------------------------------------------------------------------
// ステージデータを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_stage_data
{
	property $data : intlist[6]
	
	// 各レベルによってデータを設定する
	switch( $$get_hhp_play_level ) {
	
	//                        難易度(%),                 ボスID, ウェーブ数,   制限時間, 敵スポーン数, 敵マルチ生成率(%)
	case(1)		$data.sets(0,       100,                     -1,          2,  30 * 1000,            3,                 0)
	case(2)		$data.sets(0,       100,                     -1,          2,  30 * 1000,            3,                 0)
	case(3)		$data.sets(0,       100, <HHP_BOSS_TYPE_OROCHI>,          1,  30 * 1000,            4,                 0)
	case(4)		$data.sets(0,       100,                     -1,          2,  30 * 1000,            4,                30)
	case(5)		$data.sets(0,       300,                     -1,          2,  30 * 1000,            5,                20)
	case(6)		$data.sets(0,       180,  <HHP_BOSS_TYPE_HYDRA>,          1,  30 * 1000,            5,                30)
	case(7)		$data.sets(0,       210,                     -1,          2,  30 * 1000,            5,                40)
	case(8)		$data.sets(0,       200,                     -1,          2,  30 * 1000,            5,                50)
	case(9)		$data.sets(0,       400,                     -1,          2,  30 * 1000,            5,                60)
	case(10)	$data.sets(0,      1000, <HHP_BOSS_TYPE_MEDUSA>,          1,  30 * 1000,            5,                70)
	}
	
	// 難易度を設定する
	$difficulty = $data[0]
	
	// ウェーブデータを設定する
	$wave = 1
	$wave_max = $data[2]
	
	// 制限時間を設定する
	$time_limit = $data[3]
	$time_limit_stop = 0
	
	// ボスデータを設定する
	$boss_type = $data[1]
	
	if( $boss_type != -1 ) {
		$$init_hhp_boss(front.object[<HHP_OBJ_BOSS>], front.object[<HHP_OBJ_BOSS_SHADOW>], $boss_type, 500 * $data[0] / 100)
	}
	
	// 敵のデフォルトデータを作成する
	$$create_enemy_default_data
	
	// 敵スポーンデータを設定する
	$enemy_spawn_count = $data[4]
	$multi_spawn_rate = $data[5]
	
	$enemy_spawn_x.init
	$enemy_spawn_x.resize($enemy_spawn_count)
	$enemy_spawn_y.init
	$enemy_spawn_y.resize($enemy_spawn_count)
	
	// スポーン位置の設定
	switch( $enemy_spawn_count ) {
	case(3)
		$enemy_spawn_x[0] = 710		$enemy_spawn_y[0] =  -90
		$enemy_spawn_x[1] = 960		$enemy_spawn_y[1] = -110
		$enemy_spawn_x[2] = 1210	$enemy_spawn_y[2] =  -90
	case(4)
		$enemy_spawn_x[0] = 660		$enemy_spawn_y[0] = -110
		$enemy_spawn_x[1] = 860		$enemy_spawn_y[1] =  -90
		$enemy_spawn_x[2] = 1050	$enemy_spawn_y[2] =  -90
		$enemy_spawn_x[3] = 1260	$enemy_spawn_y[3] = -110
	case(5)
		$enemy_spawn_x[0] = 660		$enemy_spawn_y[0] = -90
		$enemy_spawn_x[1] = 810		$enemy_spawn_y[1] = -110
		$enemy_spawn_x[2] = 960		$enemy_spawn_y[2] = -90
		$enemy_spawn_x[3] = 1110	$enemy_spawn_y[3] = -110
		$enemy_spawn_x[4] = 1260	$enemy_spawn_y[4] = -90
	}
	
	// 移動目標位置の設定
	$enemy_target_x.resize(6)
	$enemy_target_x.sets(0, 302, 498, 694, 1212, 1408, 1604)
	$enemy_target_y = 750
}

//---------------------------------------------------------------------------
// ウェーブデータを初期化する
//---------------------------------------------------------------------------
command $$init_hhp_wave_data
{
	property $data : intlist[5]
	
	// 各レベル／ウェーブによってデータを設定する
	switch( $$get_hhp_play_level ) {
	
	//                 最初の敵生成時間, 敵生成間隔, 間隔差分値,  間隔最低値, 敵シールド生成率(%)
	case(1)
		switch( $wave ) {
		case(1)		$data.sets(0,  1000,       1900,         50,         750,                  0)
		case(2)		$data.sets(0,   500,       1000,         50,         650,                  0)
		}
	case(2)
		switch( $wave ) {
		case(1)		$data.sets(0,   800,       1600,         70,         650,                  0)
		case(2)		$data.sets(0,   500,       1300,         70,         650,                  0)
		}
	case(3)
		switch( $wave ) {
		case(1)		$data.sets(0,   600,       1400,        100,         550,                  0)
		case(2)		$data.sets(0,   500,       1100,        100,         550,                  0)
		}
	case(4)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1400,        100,         550,                  0)
		case(2)		$data.sets(0,   500,        900,        100,         550,                  0)
		}
	case(5)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1400,        100,         450,                 30)
		case(2)		$data.sets(0,   500,        700,        100,         450,                 30)
		}
	case(6)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1300,        100,         450,                 40)
		case(2)		$data.sets(0,   500,        700,        100,         450,                 40)
		}
	case(7)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1200,        100,         450,                 50)
		case(2)		$data.sets(0,   500,        700,        100,         450,                 50)
		}
	case(8)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1200,        100,         450,                 60)
		case(2)		$data.sets(0,  2500,        500,        100,         450,                 60)
		}
	case(9)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1200,        100,         450,                 70)
		case(2)		$data.sets(0,  2500,        500,        100,         450,                 70)
		}
	case(10)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1200,        100,         450,                 80)
		case(2)		$data.sets(0,  2500,        500,        100,         450,                 80)
		}
	case(11)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1200,        100,         450,                 90)
		case(2)		$data.sets(0,  2500,        500,        100,         450,                 90)
		}
	case(12)
		switch( $wave ) {
		case(1)		$data.sets(0,   500,       1200,        100,         450,                100)
		case(2)		$data.sets(0,  2500,        500,        100,         450,                100)
		}
	}
	
	// スポーンデータを設定する
	$spawn_start_time		= $data[0]
	$spawn_next_time		= $data[1]
	$spawn_diff_time		= $data[2]
	$spawn_next_time_min	= $data[3]
	$spawn_shield_rate		= $data[4]
	
	$spawn_time = $spawn_start_time
	
	// 出現する敵リストを作成する
	$$create_enemy_list
}

//---------------------------------------------------------------------------
// ウェーブデータを更新する
//---------------------------------------------------------------------------
command $$update_hhp_wave_data
{
	if( $$is_hhp_boss_wave )
	{
		// ボスルーチンを実行する
		$$update_hhp_boss
	}
	else
	{
		// 敵を生成するルーチンを実行する
		$$handle_timed_enemy_spawn
	}
}

//---------------------------------------------------------------------------
// 出現する敵リストを作成する
//---------------------------------------------------------------------------
command $$create_enemy_list
{
	property $i
	property $index
	property $tmp
	property $data : intlist[4]
	
	// 各レベルによってデータを設定する
	// ※各敵の合計数２０を１ロットとして生成に使用する
	// ※敵を２０生成すると再びループする
	switch( $$get_hhp_play_level ) {
	
	//                         ノーマル, タンク, スピード,  エリート
	case(1)
		switch( $wave ) {
		case(1)		$data.sets(0,    20,      0,        0,        0)		// ノーマルスネーク[100%]
		case(2)		$data.sets(0,    20,      0,        0,        0)		// ノーマルスネーク[100%]
		}
	case(2)
		switch( $wave ) {
		case(1)		$data.sets(0,    16,      2,        2,        0)		// ノーマルスネーク[80%]／タンクスネーク[10%]／スピードスネーク[10%]
		case(2)		$data.sets(0,    16,      2,        2,        0)		// ノーマルスネーク[80%]／タンクスネーク[10%]／スピードスネーク[10%]
		}
	case(3)
		switch( $wave ) {
		case(1)		$data.sets(0,    12,      4,        4,        0)		// ノーマルスネーク[60%]／タンクスネーク[20%]／スピードスネーク[20%]
		case(2)		$data.sets(0,    10,      5,        5,        0)		// ノーマルスネーク[50%]／タンクスネーク[25%]／スピードスネーク[25%]
		}
	case(4)
		switch( $wave ) {
		case(1)		$data.sets(0,     6,      6,        6,        2)		// ノーマルスネーク[30%]／タンクスネーク[30%]／スピードスネーク[30%]／エリートスネーク[10%]
		case(2)		$data.sets(0,     4,      7,        7,        2)		// ノーマルスネーク[20%]／タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[10%]
		}
	case(5)
		switch( $wave ) {
		case(1)		$data.sets(0,     9,      5,        5,        1)		// ノーマルスネーク[45%]／タンクスネーク[25%]／スピードスネーク[25%]／エリートスネーク[5%]
		case(2)		$data.sets(0,     8,      5,        5,        2)		// ノーマルスネーク[40%]／タンクスネーク[25%]／スピードスネーク[25%]／エリートスネーク[10%]
		}
	case(6)
		switch( $wave ) {
		case(1)		$data.sets(0,     2,      8,        8,        2)		// ノーマルスネーク[10%]／タンクスネーク[40%]／スピードスネーク[40%]／エリートスネーク[10%]
		case(2)		$data.sets(0,     0,      8,        8,        4)		// タンクスネーク[40%]／スピードスネーク[40%]／エリートスネーク[20%]
		}
	case(7)
		switch( $wave ) {
		case(1)		$data.sets(0,     0,      8,        8,        4)		// タンクスネーク[40%]／スピードスネーク[40%]／エリートスネーク[20%]
		case(2)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		}
	case(8)
		switch( $wave ) {
		case(1)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		case(2)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		}
	case(9)
		switch( $wave ) {
		case(1)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		case(2)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		}
	case(10)
		switch( $wave ) {
		case(1)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		case(2)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		}
	case(11)
		switch( $wave ) {
		case(1)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		case(2)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		}
	case(12)
		switch( $wave ) {
		case(1)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		case(2)		$data.sets(0,     0,      7,        7,        6)		// タンクスネーク[35%]／スピードスネーク[35%]／エリートスネーク[30%]
		}
	}
	
	// 敵リストを初期化する
	$spawn_enemy_list.init
	$spawn_enemy_index = 0
	
	// リストに追加する
	for( $i = 0, $i < $data.get_size, $i += 1 )
	{
		while( 0 < $data[$i] )
		{
			$spawn_enemy_list.resize($spawn_enemy_list.get_size + 1)
			$spawn_enemy_list[$spawn_enemy_list.get_size - 1] = $i
			
			$data[$i] -= 1
		}
	}
	
	// リストをシャッフルする
	for( $i = $spawn_enemy_list.get_size - 1, $i > 0, $i -= 1 )
	{
		$index = math.rand(0, $spawn_enemy_list.get_size - 1)
		$tmp = $spawn_enemy_list[$i]
		$spawn_enemy_list[$i] = $spawn_enemy_list[$index]
		$spawn_enemy_list[$index] = $tmp
	}
}

//---------------------------------------------------------------------------
// 敵のデフォルトデータを作成する
//---------------------------------------------------------------------------
command $$create_enemy_default_data
{
	property $i
	
	// データサイズを確保する
	$enemy_life_default.resize(<DEFAULT_ENEMY_DATA_MAX>)
	$enemy_move_speed_default.resize(<DEFAULT_ENEMY_DATA_MAX>)
	$enemy_attack_power_default.resize(<DEFAULT_ENEMY_DATA_MAX>)
	$enemy_attack_speed_default.resize(<DEFAULT_ENEMY_DATA_MAX>)
	$enemy_attack_count_default.resize(<DEFAULT_ENEMY_DATA_MAX>)
	
	// 敵データを設定する
	//                                  ノーマル, タンク, スピード, エリート, ヤマタノオロチ, ヒュドラ, メドゥーサ
	$enemy_life_default.sets(        0,       10,     30,       10,       60,            500,      500,       500)		// ライフ
	$enemy_move_speed_default.sets(  0,     4000,   7000,     2000,     3000,              0,        0,         0)		// 移動速度
	$enemy_attack_power_default.sets(0,        1,      2,        1,        3,              0,        0,         0)		// 攻撃力
	$enemy_attack_speed_default.sets(0,     1000,   2000,     1000,     1500,              0,        0,         0)		// 攻撃速度
	$enemy_attack_count_default.sets(0,        2,      2,        1,        3,              0,        0,         0)		// 攻撃回数
	
	// 難易度補正をする
	for( $i = 0, $i < <DEFAULT_ENEMY_DATA_MAX>, $i += 1 )
	{
		$enemy_life_default[$i]			= $enemy_life_default[$i] * $difficulty / 100
		$enemy_attack_power_default[$i]	= $enemy_attack_power_default[$i] * $difficulty / 100
		$enemy_attack_speed_default[$i]	= $enemy_attack_speed_default[$i] / ($difficulty / 100)
	}
}

//---------------------------------------------------------------------------
// 敵を生成するルーチンを実行する
//---------------------------------------------------------------------------
command $$handle_timed_enemy_spawn : int
{
	property $i
	property $spawn_count
	property $enemy_type
	property $spawn_pos
	property $shield_buff
	
	// 敵生成クールタイムを計算する
	$spawn_time -= $$get_delta_time
	
	// まだクールタイムが残っている場合はスキップ
	if( 0 < $spawn_time ) {
		return (0)
	}
	
	// 同時生成数を計算する
	$spawn_count = 1
	if( math.rand(0, 99) < $multi_spawn_rate ) {
		$spawn_count = 2
	}
	
	// 同時生成の数だけ敵を生成する
	for( $i = 0, $i < $spawn_count, $i += 1 )
	{
		// 生成する敵を取得する
		$enemy_type = $spawn_enemy_list[$spawn_enemy_index]
		
		// 次に生成する敵を設定する
		$spawn_enemy_index += 1
		if( $spawn_enemy_list.get_size <= $spawn_enemy_index )
		{
			$spawn_enemy_index = 0
		}
		
		// スポーン位置を設定する
		$spawn_pos = math.rand(0, $enemy_spawn_count - 1)
		
		// シールドバフを設定する
		if( math.rand(0, 99) < $spawn_shield_rate )
		{
			$shield_buff = 1
		}
		
		// 敵を生成する
		$$spawn_hhp_enemy($enemy_type, $spawn_pos, $shield_buff)
	}
	
	// 生成ＳＥ
	@SE_ヘビパ_敵スポーン
	
	// 次の敵生成時間を計算する
	$spawn_next_time -= $spawn_diff_time
	if( $spawn_next_time < $spawn_next_time_min )
	{
		// 最低値以下にはならないようにする
		$spawn_next_time = $spawn_next_time_min
	}
	
	// 次の敵生成時間を設定する
	$spawn_time = $spawn_next_time
	
	return (1)
}

//---------------------------------------------------------------------------
// 現在のウェーブを取得／設定する／次に進める
//---------------------------------------------------------------------------
command $$get_hhp_wave : int { return ($wave) }
command $$set_hhp_wave(property $value) { $wave = math.limit(0, $value, $wave_max) }
command $$next_hhp_wave { $wave = math.limit(0, $wave + 1, $wave_max) }

//---------------------------------------------------------------------------
// 最大ウェーブを取得する
//---------------------------------------------------------------------------
command $$get_hhp_wave_max : int { return ($wave_max) }

//---------------------------------------------------------------------------
// 最終ウェーブかどうか
//---------------------------------------------------------------------------
command $$is_hhp_final_wave : int
{
	if( $wave == $wave_max ) {
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// ボスウェーブかどうか
//---------------------------------------------------------------------------
command $$is_hhp_boss_wave : int
{
	if( $boss_type != -1 && $$is_hhp_final_wave ) {
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// ウェーブが終了したかどうか
//---------------------------------------------------------------------------
command $$is_hhp_wave_over : int
{
	if( $$is_hhp_boss_wave )
	{
		if( front.object[<HHP_OBJ_BOSS>].f_enemy_life <= 0 ) {
			return (1)
		}
		
		if( $$is_hhp_boss_turn_max ) {
			return (1)
		}
	}
	else
	{
		if( $$get_hhp_time_limit == 0 ) {
			return (1)
		}
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// すべてのウェーブが終了したかどうか
//---------------------------------------------------------------------------
command $$is_hhp_all_wave_over : int
{
	if( $wave_max <= $wave ) {
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// 制限時間を取得する
//---------------------------------------------------------------------------
command $$get_hhp_time_limit : int
{
	property $time
	
	$time = $time_limit - @mng_counter.get
	
	if( $time < 0 ) {
		$time = 0
	}
	
	// デバッグ用／制限時間停止フラグがオンの場合１秒以下にはならない
	if( system.check_debug_flag )
	{
		if( $time_limit_stop )
		{
			if( $time < 1000 ) {
				$time = 1000
			}
		}
	}
	
	if( $time > 0 ) {
		return (($time / 1000) + 1)
	} else {
		return ($time / 1000)
	}
}

//---------------------------------------------------------------------------
// 制限時間の更新フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_hhp_time_limit_stop_flag : int
{
	return ($time_limit_stop)
}

command $$set_hhp_time_limit_stop_flag(property $flag)
{
	$time_limit_stop = $flag
}

//---------------------------------------------------------------------------
// 出現するボスタイプを取得する
//---------------------------------------------------------------------------
command $$get_hhp_boss_type : int { return ($boss_type) }

//---------------------------------------------------------------------------
// 生成する敵リスト／リストの数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_spawn_enemy_list(property $index) : int { return ($spawn_enemy_list[$index]) }
command $$get_hhp_spawn_enemy_list_count : int { return ($spawn_enemy_list.get_size) }

//---------------------------------------------------------------------------
// 敵生成座標／位置数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_spawn_count : int { return ($enemy_spawn_count) }
command $$get_hhp_enemy_spawn_x(property $index) : int { return ($enemy_spawn_x[$index]) }
command $$get_hhp_enemy_spawn_y(property $index) : int { return ($enemy_spawn_y[$index]) }

//---------------------------------------------------------------------------
// 敵移動目標座標／位置数を取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_target_x_count : int { return ($enemy_target_x.get_size) }
command $$get_hhp_enemy_target_x(property $index) : int { return ($enemy_target_x[$index]) }
command $$get_hhp_enemy_target_y : int { return ($enemy_target_y) }

//---------------------------------------------------------------------------
// 敵生成時間を取得する
//---------------------------------------------------------------------------
command $$get_hhp_spawn_time : int { return ($spawn_time) }

//---------------------------------------------------------------------------
// 敵の各デフォルトデータを取得する
//---------------------------------------------------------------------------
command $$get_hhp_enemy_life_default(property $id) : int			{ return ($enemy_life_default[$id]) }
command $$get_hhp_enemy_move_speed_default(property $id) : int		{ return ($enemy_move_speed_default[$id]) }
command $$get_hhp_enemy_attack_power_default(property $id) : int	{ return ($enemy_attack_power_default[$id]) }
command $$get_hhp_enemy_attack_speed_default(property $id) : int	{ return ($enemy_attack_speed_default[$id]) }
command $$get_hhp_enemy_attack_count_default(property $id) : int	{ return ($enemy_attack_count_default[$id]) }
