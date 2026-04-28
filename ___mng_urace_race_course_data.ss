//===========================================================================
//!
//!    @file     ___mng_urace_race_course_data.ss
//!    @brief    ＵＭＡレース／コースデータ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// 各レーンの障害物データ
	#property	$lane_trap_max
	#property	$trap_id : intlist					// 各レーン中の障害物ID
	#property	$trap_place : intlist				// 各レーン中の障害物の位置
	#property	$trap_enable : intlist				// 各レーン中の障害物の有効／無効
	
	// 各レーンのアイテムデータ
	#property	$lane_item_max
	#property	$item_id : intlist
	#property	$item_place : intlist
	#property	$item_enable : intlist
	
#inc_end

#z00

//---------------------------------------------------------------------------
// 障害物データの初期化
//---------------------------------------------------------------------------
command $$init_entry_race_trap_data
{
	$lane_trap_max = 0
	
	$trap_id.init
	$trap_place.init
	$trap_enable.init
	
	$lane_item_max = 0
	
	$item_id.init
	$item_place.init
	$item_enable.init
}

//---------------------------------------------------------------------------
// 障害物データを作成する
//---------------------------------------------------------------------------
command $$create_entry_trap_data
{
	switch( $$get_entry_race_id ) {
	case(@レース_さすらいＣ)					$$set_course_data
	case(@レース_銀河一記念)					$$set_course_data
	case(@レース_魂争覇戦)						$$set_course_data
	case(@レース_ＳＳ)							$$set_course_data
	case(@レース_夢に向かって飛び立ちま賞)		$$set_course_data
	case(@レース_真澄パラダイスＣ)				$$set_course_data
	case(@レース_妹チャンピオンシップ)			$$set_course_data
	case(@レース_記念杯大賞典ＳＣＦ)			$$set_course_data
	case(@レース_凱風賞)						$$set_course_data
	case(@レース_力こそ正義)					$$set_course_data
	case(@レース_ＵＭＡグランドカップ１回戦)	$$set_course_data
	case(@レース_ＵＭＡグランドカップ２回戦)	$$set_course_data
	case(@レース_ＵＭＡグランドカップ準決勝)	$$set_course_data
	case(@レース_ＵＭＡグランドカップ決勝)		$$set_course_data
	case(@レース_ラストレース)					$$set_course_data
	case(@レース_模擬レース)					$$set_course_data2
	}
}

//---------------------------------------------------------------------------
// 各レーンの障害物をリセットする
//---------------------------------------------------------------------------
command $$reset_lane_trap_data(property $lane_index)
{
	property $i
	
	for( $i = 0, $i < $lane_trap_max, $i += 1 )
	{
		$trap_enable[$lane_trap_max * $lane_index + $i] = 1
	}
}



//2
command $$get_trap_num(property $lane_index)
{
	property $i
	property $count
	
	for( $i = 0, $i < $lane_trap_max, $i += 1 )
	{
		if( $trap_id[$lane_trap_max * $lane_index + $i] != 0 )
		{
			$count += 1
		}
		else
		{
			break
		}
	}
	
	return ($count)
}

command $$get_trap_id(property $lane_index, property $index) { return ($trap_id[$lane_trap_max * $lane_index + $index]) }
command $$get_trap_place(property $lane_index, property $index) { return ($trap_place[$lane_trap_max * $lane_index + $index]) }
command $$get_trap_enable(property $lane_index, property $index) { return ($trap_enable[$lane_trap_max * $lane_index + $index]) }

command $$set_trap_enable(property $lane_index, property $index, property $value) { $trap_enable[$lane_trap_max * $lane_index + $index] = $value }


command $$get_entry_lane_item_id(property $lane_index, property $index) : int
{
	if( $index == -1 ) {
		return (-1)
	}
	
	return ($item_id[$lane_item_max * $lane_index + $index])
}
command $$get_entry_lane_item_place(property $lane_index, property $index) : int
{
	if( $index == -1 ) {
		return (-1)
	}
	
	return ($item_place[$lane_item_max * $lane_index + $index])
}
command $$get_entry_lane_item_enable(property $lane_index, property $index) : int
{
	if( $index == -1 ) {
		return (-1)
	}
	
	return ($item_enable[$lane_item_max * $lane_index + $index])
}

command $$set_entry_lane_item_enable(property $lane_index, property $index, property $flag) : int
{
	$item_enable[$lane_item_max * $lane_index + $index] = $flag
}

command $$get_item_size
{
	return ($lane_item_max)
}


command $$set_course_data
{
	property $i
	property $lane
	
	$lane_trap_max = 40
	$lane = <URACE_LANE_MAX>;$$get_entry_owner_num
	$trap_id.resize($lane_trap_max * $lane)
	$trap_place.resize($lane_trap_max * $lane)
	$trap_enable.resize($lane_trap_max * $lane)
	
	$lane_item_max = 20
	$item_id.resize($lane_item_max * $lane)
	$item_place.resize($lane_item_max * $lane)
	$item_enable.resize($lane_item_max * $lane)
	
	$$add_item(1,  95, 0)
	$$add_item(1, 100, 1)
	$$add_item(1,  95, 2)
	$$add_item(1, 100, 3)
	$$add_item(1,  95, 4)
	$$add_item(1, 100, 5)
	
	$$add_item(1, 430, 0)
	$$add_item(1, 425, 1)
	$$add_item(1, 430, 2)
	$$add_item(1, 425, 3)
	$$add_item(1, 430, 4)
	$$add_item(1, 425, 5)
	
	$$add_item(1, 695, 0)
	$$add_item(1, 700, 1)
	$$add_item(1, 695, 2)
	$$add_item(1, 700, 3)
	$$add_item(1, 695, 4)
	$$add_item(1, 700, 5)
	
	$$add_item(1, 990, 0)
	$$add_item(1, 985, 1)
	$$add_item(1, 990, 2)
	$$add_item(1, 985, 3)
	$$add_item(1, 990, 4)
	$$add_item(1, 985, 5)
	
	$$add_item(1, 1255, 0)
	$$add_item(1, 1260, 1)
	$$add_item(1, 1255, 2)
	$$add_item(1, 1260, 3)
	$$add_item(1, 1255, 4)
	$$add_item(1, 1260, 5)
	
	if( 0 ) {
		$$add_trap(@レース障害物_小石, 10, 0)
		$$add_trap(@レース障害物_小石, 15, 1)
		$$add_trap(@レース障害物_小石, 20, 2)
		$$add_trap(@レース障害物_小石, 25, 3)
		$$add_trap(@レース障害物_小石, 30, 4)
		$$add_trap(@レース障害物_小石, 35, 5)
	}
	
	$$add_trap(@レース障害物_茂み, 50, 0)
	$$add_trap(@レース障害物_茂み, 50, 5)
	
	$$add_trap(@レース障害物_大岩, 75, 1)
	$$add_trap(@レース障害物_大岩, 75, 4)
	
	$$add_trap(@レース障害物_茂み, 125, 0)
	$$add_trap(@レース障害物_茂み, 125, 2)
	$$add_trap(@レース障害物_茂み, 125, 3)
	$$add_trap(@レース障害物_茂み, 125, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 135, 1)
	$$add_trap(@レース障害物_ダッシュ板, 135, 4)
	
	$$add_trap(@レース障害物_柵, 180, 0)
	$$add_trap(@レース障害物_柵, 190, 1)
	$$add_trap(@レース障害物_柵, 190, 4)
	$$add_trap(@レース障害物_柵, 180, 5)
	
	$$add_trap(@レース障害物_小石, 240, 1)
	$$add_trap(@レース障害物_小石, 240, 3)
	$$add_trap(@レース障害物_小石, 250, 2)
	$$add_trap(@レース障害物_小石, 250, 5)
	$$add_trap(@レース障害物_小石, 260, 0)
	$$add_trap(@レース障害物_ダッシュ板, 260, 2)
	$$add_trap(@レース障害物_小石, 270, 3)
	$$add_trap(@レース障害物_小石, 270, 5)
	$$add_trap(@レース障害物_小石, 280, 4)
	$$add_trap(@レース障害物_小石, 290, 3)
	$$add_trap(@レース障害物_小石, 300, 0)
	$$add_trap(@レース障害物_小石, 300, 2)
	$$add_trap(@レース障害物_小石, 310, 4)
	$$add_trap(@レース障害物_小石, 320, 2)
	$$add_trap(@レース障害物_小石, 330, 0)
	$$add_trap(@レース障害物_ダッシュ板, 330, 3)
	$$add_trap(@レース障害物_小石, 330, 5)
	
	$$add_trap(@レース障害物_柵, 370, 0)
	$$add_trap(@レース障害物_柵, 370, 2)
	$$add_trap(@レース障害物_柵, 370, 3)
	$$add_trap(@レース障害物_柵, 370, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 390, 1)
	$$add_trap(@レース障害物_ダッシュ板, 400, 2)
	$$add_trap(@レース障害物_ダッシュ板, 400, 3)
	$$add_trap(@レース障害物_ダッシュ板, 390, 4)
	
	$$add_trap(@レース障害物_大岩, 490, 0)
	$$add_trap(@レース障害物_大岩, 490, 1)
	$$add_trap(@レース障害物_大岩, 490, 3)
	$$add_trap(@レース障害物_大岩, 490, 5)
	
	$$add_trap(@レース障害物_大岩, 530, 0)
	$$add_trap(@レース障害物_大岩, 530, 2)
	$$add_trap(@レース障害物_大岩, 530, 4)
	$$add_trap(@レース障害物_大岩, 530, 5)
	
	$$add_trap(@レース障害物_大岩, 550, 1)
	
	$$add_trap(@レース障害物_大岩, 570, 0)
	$$add_trap(@レース障害物_大岩, 570, 3)
	$$add_trap(@レース障害物_大岩, 570, 4)
	$$add_trap(@レース障害物_大岩, 570, 5)
	
	$$add_trap(@レース障害物_大岩, 590, 1)
	$$add_trap(@レース障害物_大岩, 590, 4)
	
	$$add_trap(@レース障害物_大岩, 610, 0)
	$$add_trap(@レース障害物_大岩, 610, 1)
	$$add_trap(@レース障害物_大岩, 610, 2)
	$$add_trap(@レース障害物_大岩, 610, 5)
	
	$$add_trap(@レース障害物_大岩, 630, 2)
	$$add_trap(@レース障害物_大岩, 630, 4)
	
	$$add_trap(@レース障害物_大岩, 650, 0)
	$$add_trap(@レース障害物_大岩, 650, 3)
	$$add_trap(@レース障害物_大岩, 650, 4)
	$$add_trap(@レース障害物_大岩, 650, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 760, 0)
	$$add_trap(@レース障害物_ダッシュ板, 720, 1)
	$$add_trap(@レース障害物_ダッシュ板, 740, 2)
	$$add_trap(@レース障害物_ダッシュ板, 740, 3)
	$$add_trap(@レース障害物_ダッシュ板, 720, 4)
	$$add_trap(@レース障害物_ダッシュ板, 760, 5)
	
	$$add_trap(@レース障害物_柵, 820, 0)
	$$add_trap(@レース障害物_柵, 820, 1)
	$$add_trap(@レース障害物_柵, 820, 4)
	$$add_trap(@レース障害物_柵, 820, 5)
	
	$$add_trap(@レース障害物_柵, 850, 0)
	$$add_trap(@レース障害物_柵, 850, 1)
	$$add_trap(@レース障害物_柵, 850, 4)
	$$add_trap(@レース障害物_柵, 850, 5)
	
	$$add_trap(@レース障害物_柵, 880, 0)
	$$add_trap(@レース障害物_柵, 880, 1)
	$$add_trap(@レース障害物_柵, 880, 4)
	$$add_trap(@レース障害物_柵, 880, 5)
	
	$$add_trap(@レース障害物_柵, 910, 0)
	$$add_trap(@レース障害物_柵, 910, 1)
	$$add_trap(@レース障害物_柵, 910, 4)
	$$add_trap(@レース障害物_柵, 910, 5)
	
	$$add_trap(@レース障害物_柵, 940, 0)
	$$add_trap(@レース障害物_柵, 940, 1)
	$$add_trap(@レース障害物_柵, 940, 4)
	$$add_trap(@レース障害物_柵, 940, 5)
	
	$$add_trap(@レース障害物_茂み, 1020, 2)
	$$add_trap(@レース障害物_茂み, 1020, 3)
	
	$$add_trap(@レース障害物_ダッシュ板, 1050, 0)
	$$add_trap(@レース障害物_大岩, 1050, 1)
	$$add_trap(@レース障害物_大岩, 1050, 4)
	$$add_trap(@レース障害物_ダッシュ板, 1050, 5)
	
	$$add_trap(@レース障害物_大岩, 1100, 0)
	$$add_trap(@レース障害物_ダッシュ板, 1100, 1)
	$$add_trap(@レース障害物_大岩, 1100, 2)
	$$add_trap(@レース障害物_大岩, 1100, 3)
	$$add_trap(@レース障害物_ダッシュ板, 1100, 4)
	$$add_trap(@レース障害物_大岩, 1100, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 1150, 0)
	$$add_trap(@レース障害物_大岩, 1150, 1)
	$$add_trap(@レース障害物_大岩, 1150, 2)
	$$add_trap(@レース障害物_大岩, 1150, 3)
	$$add_trap(@レース障害物_大岩, 1150, 4)
	$$add_trap(@レース障害物_ダッシュ板, 1150, 5)
	
	$$add_trap(@レース障害物_大岩, 1200, 0)
	$$add_trap(@レース障害物_大岩, 1200, 1)
	$$add_trap(@レース障害物_ダッシュ板, 1200, 2)
	$$add_trap(@レース障害物_ダッシュ板, 1200, 3)
	$$add_trap(@レース障害物_大岩, 1200, 4)
	$$add_trap(@レース障害物_大岩, 1200, 5)
	
	$$add_trap(@レース障害物_小石, 1340, 4)
	$$add_trap(@レース障害物_小石, 1340, 2)
	$$add_trap(@レース障害物_小石, 1350, 3)
	$$add_trap(@レース障害物_小石, 1350, 0)
	$$add_trap(@レース障害物_小石, 1360, 5)
	$$add_trap(@レース障害物_大岩, 1360, 1)
	$$add_trap(@レース障害物_小石, 1370, 0)
	$$add_trap(@レース障害物_小石, 1370, 3)
	$$add_trap(@レース障害物_小石, 1380, 2)
	$$add_trap(@レース障害物_小石, 1390, 4)
	$$add_trap(@レース障害物_大岩, 1400, 0)
	$$add_trap(@レース障害物_小石, 1400, 3)
	$$add_trap(@レース障害物_小石, 1400, 5)
	$$add_trap(@レース障害物_小石, 1400, 3)
	$$add_trap(@レース障害物_小石, 1410, 1)
	$$add_trap(@レース障害物_小石, 1420, 2)
	$$add_trap(@レース障害物_小石, 1430, 5)
	$$add_trap(@レース障害物_大岩, 1430, 3)
	$$add_trap(@レース障害物_小石, 1430, 0)
	
	$$add_trap(@レース障害物_柵, 1480, 0)
	$$add_trap(@レース障害物_柵, 1480, 1)
	$$add_trap(@レース障害物_柵, 1480, 4)
	$$add_trap(@レース障害物_柵, 1480, 5)
	
	$$add_trap(@レース障害物_柵, 1520, 0)
	$$add_trap(@レース障害物_柵, 1520, 3)
	$$add_trap(@レース障害物_柵, 1520, 4)
	$$add_trap(@レース障害物_柵, 1520, 5)
	
	$$add_trap(@レース障害物_柵, 1560, 0)
	$$add_trap(@レース障害物_柵, 1560, 1)
	$$add_trap(@レース障害物_柵, 1560, 2)
	$$add_trap(@レース障害物_柵, 1560, 5)
	
	$$add_trap(@レース障害物_大岩, 1600, 0)
	$$add_trap(@レース障害物_大岩, 1590, 2)
	$$add_trap(@レース障害物_大岩, 1590, 3)
	$$add_trap(@レース障害物_大岩, 1600, 5)
	
	$$add_trap(@レース障害物_大岩, 1640, 0)
	$$add_trap(@レース障害物_大岩, 1630, 2)
	$$add_trap(@レース障害物_大岩, 1630, 3)
	$$add_trap(@レース障害物_大岩, 1640, 5)
	
	$$add_trap(@レース障害物_大岩, 1680, 1)
	$$add_trap(@レース障害物_大岩, 1670, 2)
	$$add_trap(@レース障害物_大岩, 1670, 3)
	$$add_trap(@レース障害物_大岩, 1680, 4)
	
	$$add_trap(@レース障害物_大岩, 1720, 0)
	$$add_trap(@レース障害物_大岩, 1720, 5)
}

// deb
command $$set_course_data2
{
	property $i
	property $lane
	
	$lane_trap_max = 40
	$lane = <URACE_LANE_MAX>;$$get_entry_owner_num
	$trap_id.resize($lane_trap_max * $lane)
	$trap_place.resize($lane_trap_max * $lane)
	$trap_enable.resize($lane_trap_max * $lane)
	
	$lane_item_max = 20
	$item_id.resize($lane_item_max * $lane)
	$item_place.resize($lane_item_max * $lane)
	$item_enable.resize($lane_item_max * $lane)
	
	$$add_item(1,  95, 0)
	$$add_item(1, 100, 1)
	$$add_item(1,  95, 2)
	$$add_item(1, 100, 3)
	$$add_item(1,  95, 4)
	$$add_item(1, 100, 5)
	
	$$add_item(1, 430, 0)
	$$add_item(1, 425, 1)
	$$add_item(1, 430, 2)
	$$add_item(1, 425, 3)
	$$add_item(1, 430, 4)
	$$add_item(1, 425, 5)
	
	$$add_item(1, 695, 0)
	$$add_item(1, 700, 1)
	$$add_item(1, 695, 2)
	$$add_item(1, 700, 3)
	$$add_item(1, 695, 4)
	$$add_item(1, 700, 5)
	
	$$add_item(1, 990, 0)
	$$add_item(1, 985, 1)
	$$add_item(1, 990, 2)
	$$add_item(1, 985, 3)
	$$add_item(1, 990, 4)
	$$add_item(1, 985, 5)
	
	$$add_item(1, 1255, 0)
	$$add_item(1, 1260, 1)
	$$add_item(1, 1255, 2)
	$$add_item(1, 1260, 3)
	$$add_item(1, 1255, 4)
	$$add_item(1, 1260, 5)
	
	if( 0 ) {
		$$add_trap(@レース障害物_小石, 10, 0)
		$$add_trap(@レース障害物_小石, 15, 1)
		$$add_trap(@レース障害物_小石, 20, 2)
		$$add_trap(@レース障害物_小石, 25, 3)
		$$add_trap(@レース障害物_小石, 30, 4)
		$$add_trap(@レース障害物_小石, 35, 5)
	}
	
	$$add_trap(@レース障害物_茂み, 50, 0)
	$$add_trap(@レース障害物_茂み, 50, 5)
	
	$$add_trap(@レース障害物_大岩, 75, 1)
	$$add_trap(@レース障害物_大岩, 75, 4)
	
	$$add_trap(@レース障害物_茂み, 125, 0)
	$$add_trap(@レース障害物_茂み, 125, 2)
	$$add_trap(@レース障害物_茂み, 125, 3)
	$$add_trap(@レース障害物_茂み, 125, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 135, 1)
	$$add_trap(@レース障害物_ダッシュ板, 135, 4)
	
	$$add_trap(@レース障害物_柵, 180, 0)
	$$add_trap(@レース障害物_柵, 190, 1)
	$$add_trap(@レース障害物_柵, 190, 4)
	$$add_trap(@レース障害物_柵, 180, 5)
	
	$$add_trap(@レース障害物_小石, 240, 1)
	$$add_trap(@レース障害物_小石, 240, 3)
	$$add_trap(@レース障害物_小石, 250, 2)
	$$add_trap(@レース障害物_小石, 250, 5)
	$$add_trap(@レース障害物_小石, 260, 0)
	$$add_trap(@レース障害物_ダッシュ板, 260, 2)
	$$add_trap(@レース障害物_小石, 270, 3)
	$$add_trap(@レース障害物_小石, 270, 5)
	$$add_trap(@レース障害物_小石, 280, 4)
	$$add_trap(@レース障害物_小石, 290, 3)
	$$add_trap(@レース障害物_小石, 300, 0)
	$$add_trap(@レース障害物_小石, 300, 2)
	$$add_trap(@レース障害物_小石, 310, 4)
	$$add_trap(@レース障害物_小石, 320, 2)
	$$add_trap(@レース障害物_小石, 330, 0)
	$$add_trap(@レース障害物_ダッシュ板, 330, 3)
	$$add_trap(@レース障害物_小石, 330, 5)
	
	$$add_trap(@レース障害物_柵, 370, 0)
	$$add_trap(@レース障害物_柵, 370, 2)
	$$add_trap(@レース障害物_柵, 370, 3)
	$$add_trap(@レース障害物_柵, 370, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 390, 1)
	$$add_trap(@レース障害物_ダッシュ板, 400, 2)
	$$add_trap(@レース障害物_ダッシュ板, 400, 3)
	$$add_trap(@レース障害物_ダッシュ板, 390, 4)
	
	$$add_trap(@レース障害物_大岩, 490, 0)
	$$add_trap(@レース障害物_大岩, 490, 1)
	$$add_trap(@レース障害物_大岩, 490, 3)
	$$add_trap(@レース障害物_大岩, 490, 5)
	
	$$add_trap(@レース障害物_大岩, 530, 0)
	$$add_trap(@レース障害物_大岩, 530, 2)
	$$add_trap(@レース障害物_大岩, 530, 4)
	$$add_trap(@レース障害物_大岩, 530, 5)
	
	$$add_trap(@レース障害物_大岩, 550, 1)
	
	$$add_trap(@レース障害物_大岩, 570, 0)
	$$add_trap(@レース障害物_大岩, 570, 3)
	$$add_trap(@レース障害物_大岩, 570, 4)
	$$add_trap(@レース障害物_大岩, 570, 5)
	
	$$add_trap(@レース障害物_大岩, 590, 1)
	$$add_trap(@レース障害物_大岩, 590, 4)
	
	$$add_trap(@レース障害物_大岩, 610, 0)
	$$add_trap(@レース障害物_大岩, 610, 1)
	$$add_trap(@レース障害物_大岩, 610, 2)
	$$add_trap(@レース障害物_大岩, 610, 5)
	
	$$add_trap(@レース障害物_大岩, 630, 2)
	$$add_trap(@レース障害物_大岩, 630, 4)
	
	$$add_trap(@レース障害物_大岩, 650, 0)
	$$add_trap(@レース障害物_大岩, 650, 3)
	$$add_trap(@レース障害物_大岩, 650, 4)
	$$add_trap(@レース障害物_大岩, 650, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 760, 0)
	$$add_trap(@レース障害物_ダッシュ板, 720, 1)
	$$add_trap(@レース障害物_ダッシュ板, 740, 2)
	$$add_trap(@レース障害物_ダッシュ板, 740, 3)
	$$add_trap(@レース障害物_ダッシュ板, 720, 4)
	$$add_trap(@レース障害物_ダッシュ板, 760, 5)
	
	$$add_trap(@レース障害物_柵, 820, 0)
	$$add_trap(@レース障害物_柵, 820, 1)
	$$add_trap(@レース障害物_柵, 820, 4)
	$$add_trap(@レース障害物_柵, 820, 5)
	
	$$add_trap(@レース障害物_柵, 850, 0)
	$$add_trap(@レース障害物_柵, 850, 1)
	$$add_trap(@レース障害物_柵, 850, 4)
	$$add_trap(@レース障害物_柵, 850, 5)
	
	$$add_trap(@レース障害物_柵, 880, 0)
	$$add_trap(@レース障害物_柵, 880, 1)
	$$add_trap(@レース障害物_柵, 880, 4)
	$$add_trap(@レース障害物_柵, 880, 5)
	
	$$add_trap(@レース障害物_柵, 910, 0)
	$$add_trap(@レース障害物_柵, 910, 1)
	$$add_trap(@レース障害物_柵, 910, 4)
	$$add_trap(@レース障害物_柵, 910, 5)
	
	$$add_trap(@レース障害物_柵, 940, 0)
	$$add_trap(@レース障害物_柵, 940, 1)
	$$add_trap(@レース障害物_柵, 940, 4)
	$$add_trap(@レース障害物_柵, 940, 5)
	
	$$add_trap(@レース障害物_茂み, 1020, 2)
	$$add_trap(@レース障害物_茂み, 1020, 3)
	
	$$add_trap(@レース障害物_ダッシュ板, 1050, 0)
	$$add_trap(@レース障害物_大岩, 1050, 1)
	$$add_trap(@レース障害物_大岩, 1050, 4)
	$$add_trap(@レース障害物_ダッシュ板, 1050, 5)
	
	$$add_trap(@レース障害物_大岩, 1100, 0)
	$$add_trap(@レース障害物_ダッシュ板, 1100, 1)
	$$add_trap(@レース障害物_大岩, 1100, 2)
	$$add_trap(@レース障害物_大岩, 1100, 3)
	$$add_trap(@レース障害物_ダッシュ板, 1100, 4)
	$$add_trap(@レース障害物_大岩, 1100, 5)
	
	$$add_trap(@レース障害物_ダッシュ板, 1150, 0)
	$$add_trap(@レース障害物_大岩, 1150, 1)
	$$add_trap(@レース障害物_大岩, 1150, 2)
	$$add_trap(@レース障害物_大岩, 1150, 3)
	$$add_trap(@レース障害物_大岩, 1150, 4)
	$$add_trap(@レース障害物_ダッシュ板, 1150, 5)
	
	$$add_trap(@レース障害物_大岩, 1200, 0)
	$$add_trap(@レース障害物_大岩, 1200, 1)
	$$add_trap(@レース障害物_ダッシュ板, 1200, 2)
	$$add_trap(@レース障害物_ダッシュ板, 1200, 3)
	$$add_trap(@レース障害物_大岩, 1200, 4)
	$$add_trap(@レース障害物_大岩, 1200, 5)
	
	$$add_trap(@レース障害物_小石, 1340, 4)
	$$add_trap(@レース障害物_小石, 1340, 2)
	$$add_trap(@レース障害物_小石, 1350, 3)
	$$add_trap(@レース障害物_小石, 1350, 0)
	$$add_trap(@レース障害物_小石, 1360, 5)
	$$add_trap(@レース障害物_大岩, 1360, 1)
	$$add_trap(@レース障害物_小石, 1370, 0)
	$$add_trap(@レース障害物_小石, 1370, 3)
	$$add_trap(@レース障害物_小石, 1380, 2)
	$$add_trap(@レース障害物_小石, 1390, 4)
	$$add_trap(@レース障害物_大岩, 1400, 0)
	$$add_trap(@レース障害物_小石, 1400, 3)
	$$add_trap(@レース障害物_小石, 1400, 5)
	$$add_trap(@レース障害物_小石, 1400, 3)
	$$add_trap(@レース障害物_小石, 1410, 1)
	$$add_trap(@レース障害物_小石, 1420, 2)
	$$add_trap(@レース障害物_小石, 1430, 5)
	$$add_trap(@レース障害物_大岩, 1430, 3)
	$$add_trap(@レース障害物_小石, 1430, 0)
	
	$$add_trap(@レース障害物_柵, 1480, 0)
	$$add_trap(@レース障害物_柵, 1480, 1)
	$$add_trap(@レース障害物_柵, 1480, 4)
	$$add_trap(@レース障害物_柵, 1480, 5)
	
	$$add_trap(@レース障害物_柵, 1520, 0)
	$$add_trap(@レース障害物_柵, 1520, 3)
	$$add_trap(@レース障害物_柵, 1520, 4)
	$$add_trap(@レース障害物_柵, 1520, 5)
	
	$$add_trap(@レース障害物_柵, 1560, 0)
	$$add_trap(@レース障害物_柵, 1560, 1)
	$$add_trap(@レース障害物_柵, 1560, 2)
	$$add_trap(@レース障害物_柵, 1560, 5)
	
	$$add_trap(@レース障害物_大岩, 1600, 0)
	$$add_trap(@レース障害物_大岩, 1590, 2)
	$$add_trap(@レース障害物_大岩, 1590, 3)
	$$add_trap(@レース障害物_大岩, 1600, 5)
	
	$$add_trap(@レース障害物_大岩, 1640, 0)
	$$add_trap(@レース障害物_大岩, 1630, 2)
	$$add_trap(@レース障害物_大岩, 1630, 3)
	$$add_trap(@レース障害物_大岩, 1640, 5)
	
	$$add_trap(@レース障害物_大岩, 1680, 1)
	$$add_trap(@レース障害物_大岩, 1670, 2)
	$$add_trap(@レース障害物_大岩, 1670, 3)
	$$add_trap(@レース障害物_大岩, 1680, 4)
	
	$$add_trap(@レース障害物_大岩, 1720, 0)
	$$add_trap(@レース障害物_大岩, 1720, 5)
}

command $$add_trap(property $id, property $place, property $lane)
{
	property $i
	property $index
	
	for( $i = 0, $i < $lane_trap_max, $i += 1 )
	{
		$index = $lane_trap_max * $lane + $i
		
		if( $trap_id[$index] == 0 )
		{
			$trap_id[$index] = $id
			$trap_place[$index] = $place * 1000
			$trap_enable[$index] = 1
			
			break
		}
	}
	
	if( $i == $lane_trap_max - 1 ) {
		@dm("trap out of range")
	}
}

command $$add_item(property $id, property $place, property $lane)
{
	property $i
	property $index
	
	for( $i = 0, $i < $lane_item_max, $i += 1 )
	{
		$index = $lane_item_max * $lane + $i
		
		if( $item_id[$index] == 0 )
		{
			$item_id[$index] = $id
			$item_place[$index] = $place * 1000
			$item_enable[$index] = 1
			
			break
		}
	}
	
	if( $i == $lane_item_max - 1 ) {
		@dm("item out of range")
	}
}
