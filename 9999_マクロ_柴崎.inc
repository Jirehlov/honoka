//--------------------------------------------------------------------
// 柴崎マクロ作成用
//--------------------------------------------------------------------

//--------------------------------------------------------------------
//廃駅舎カフェへ
//--------------------------------------------------------------------
#macro	@カフェ移動
	@fade(25,1000)
	@se(SE_door_open_station_cafe)
	@waitkey(500)
	@bg(bg304_01, 25)


//--------------------------------------------------------------------
//並行世界移動
//--------------------------------------------------------------------
#macro	@マルチバース移動
	front.object[80].create_movie(ef_multiverse, 0, 0, 0, ready_only = 1)
	front.object[80].layer = <LAYER_BG_FILTER>
	front.object[80].blend = 0
	@se(SE_elec_bubblecosmos_move)
	timewait(150)
	front.object[80].disp = 1
	front.object[80].resume_movie
	@bright_out(800, 1, 1, 255)

#macro	@マルチバース背景移動(@bg_name)
	front.object[80].create_movie(ef_multiverse, 0, 0, 0, ready_only = 1)
	front.object[80].layer = <LAYER_ALL_FILTER>
	front.object[80].blend = 0
	@se(SE_elec_bubblecosmos_move)
	timewait(150)
	front.object[80].disp = 1
	front.object[80].resume_movie
	front.object[80].wipe_copy = 1
	@waitkey(200)
	@bg(@bg_name,99)
	@waitkey(1000)

#macro	@流星１
	front.object[80].create_movie(ef_meteor01, 0, 0, 0, ready_only = 1)
	front.object[80].layer = <LAYER_BG_FILTER>
	front.object[80].blend = 0
	front.object[80].disp = 1
	front.object[80].resume_movie

#macro	@流星２
	front.object[80].create_movie(ef_meteor02, 0, 0, 0, ready_only = 1)
	front.object[80].layer = <LAYER_BG_FILTER>
	front.object[80].blend = 0
	front.object[80].disp = 1
	front.object[80].resume_movie

#macro	@流星３
	front.object[80].create_movie(ef_meteor03, 0, 0, 0, ready_only = 1)
	front.object[80].layer = <LAYER_BG_FILTER>
	front.object[80].blend = 0
	front.object[80].disp = 1
	front.object[80].resume_movie

#macro	@淡雪旅(@movie_name)
	@fade_w(3)
	@bg(bg_white, 99)
	front.object[80].create_movie(@movie_name, 0, 0, 0, auto_free = 0, ready_only = 1)
	front.object[80].layer = <LAYER_ALL_FILTER>
	front.object[80].blend = 0
	front.object[80].disp = 1
	front.object[80].resume_movie
@se("SE_map_write_awayuki")
@waitkey(1800)

#macro	@淡雪スタンプクマザサ(@wipe_no(2), @se_play(1), @bg_name(<NONE>))
	@淡雪クマザサ共通(0, @wipe_no, @se_play, @bg_name)

#macro	@淡雪クマザサ共通(@patno, @wipe_no(2), @se_play(1), @bg_name(<NONE>), @offset_x(0), @offset_obj_no(0))
	close
	if( @se_play ) {
		@se(SE_kumazasa)
	}
	if( @bg_name != <NONE> ) {
		@bg_set(__BG_BLUR_PREFIX + $$chop_bg_blur_name(@bg_name))
	} else {
		@bg_set(__BG_BLUR_PREFIX + $$chop_bg_blur_name(front.object[<OBJ_BG>].get_file_name))
	}
	$$set_simple_cutin_object(back.object[<OBJ_CUTIN> + @offset_obj_no], ef_cutin_kumazasa, @offset_x, 0, @patno)
	back.object[<OBJ_CUTIN> + @offset_obj_no].wipe_copy = 1
	back.object[<OBJ_CUTIN> + @offset_obj_no].frame_action.start(-1, "$$fa_hi_stamp")
	@wipe(@wipe_no)
