//--------------------------------------------------------------------
// 榊原マクロ作成用
//--------------------------------------------------------------------

#z00

//--------------------------------------------------------------------
//仮作成：カレイドワールド用
//--------------------------------------------------------------------
command $$ef_kaleido(property $type)
{
	switch( $type ) {
	case(1)
	
		back.object[90].create_movie_loop(ef_wind_dust01, 1)
		back.object[90].layer = <LAYER_BG_FILTER>
		back.object[90].blend = 1
		back.object[90].wipe_copy = 1
		
	case(2)
	
		back.object[90].create_movie_loop(ef_wind_dust02, 1)
		back.object[90].layer = <LAYER_BG_FILTER>
		back.object[90].blend = 1
		back.object[90].wipe_copy = 1
	}
}


//--------------------------------------------------------------------
//仮作成：にいさんらっしゅで使用するもの
//--------------------------------------------------------------------

command $$create_nisan_rush(property $offset_x, property $offset_y, property $koe_no, property $end_scale)
{
	property $index

	//音声の再生
	//KOE($koe_no, 005)
	
	exkoe($koe_no, 005)
	//pcmch[$index].play(koe_no = $koe_no, volume_type = 1, chara_no = 005)
	
	//オブジェクトの再生
	front.object[<OBJ_APP_EFFECT01>].disp = 1
	front.object[<OBJ_APP_EFFECT01>].layer = 500
	front.object[<OBJ_APP_EFFECT01>].child.resize(front.object[<OBJ_APP_EFFECT01>].child.get_size + 1)
	
	$index = front.object[<OBJ_APP_EFFECT01>].child.get_size - 1
	
	front.object[<OBJ_APP_EFFECT01>].child[$index].create(ef_moji_nisan, 1, <SCREEN_CENTER_X> + $offset_x, <SCREEN_CENTER_Y> + $offset_y)
	front.object[<OBJ_APP_EFFECT01>].child[$index].layer = 500
	
	switch( $end_scale ) {
	case(1)		front.object[<OBJ_APP_EFFECT01>].child[$index].frame_action.start(-1, "$$nisan_rush_fade1")
	case(2)		front.object[<OBJ_APP_EFFECT01>].child[$index].frame_action.start(-1, "$$nisan_rush_fade2")
	case(3)		front.object[<OBJ_APP_EFFECT01>].child[$index].frame_action.start(-1, "$$nisan_rush_fade3")
	
	}
	
	
	
	//待ち
	@waitkey(1000)


}


command $$nisan_rush_fade1(property $fa : frameaction, property $obj : object)
{
	L[0] = $fa.counter.get
	
	$obj.tr = math.timetable(L[0], 0, 0, [0, 2000, 255, 1], [3000, 4000, 0, 2])
	
    $obj.scale_x = math.timetable(L[0], 0, 700, [0, 2000, 1000, 0], [2000, 4000, 1280, 0])
    $obj.scale_y = math.timetable(L[0], 0, 800, [0, 2000, 1000, 0], [2000, 4000, 1200, 0])
}

command $$nisan_rush_fade2(property $fa : frameaction, property $obj : object)
{
	L[0] = $fa.counter.get
	
	$obj.tr = math.timetable(L[0], 0, 0, [0, 2000, 255, 1], [2500, 4000, 0, 2])
	
    $obj.scale_x = math.timetable(L[0], 0, 800, [0, 4000, 1000, 0])
    $obj.scale_y = math.timetable(L[0], 0, 800, [0, 4000, 1000, 0])
}

command $$nisan_rush_fade3(property $fa : frameaction, property $obj : object)
{
	L[0] = $fa.counter.get
	
	$obj.tr = math.timetable(L[0], 0, 0, [0, 2000, 255, 1], [6000, 8000, 0, 2])
	
    $obj.scale_x = math.timetable(L[0], 0, 800, [0, 4000, 1000, 0])
    $obj.scale_y = math.timetable(L[0], 0, 800, [0, 4000, 1000, 0])
}

