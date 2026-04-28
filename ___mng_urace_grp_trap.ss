//===========================================================================
//!
//!    @file     ___mng_urace_grp_trap.ss
//!    @brief    ‚t‚l‚`ƒŒ[ƒX^áŠQ•¨^ƒAƒCƒeƒ€•`‰æŠÖ”ŒQ
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// ‚t‚h^ƒAƒNƒVƒ‡ƒ“ƒo[•Ï”
	#define		.f_id			.f[0]
	#replace	<F_FLAG_MAX>		1			// Šm•Û‚·‚éfƒtƒ‰ƒOÅ‘å”
	
#inc_end

#z00

//---------------------------------------------------------------------------
// áŠQ•¨‚ğì¬‚·‚é
//---------------------------------------------------------------------------
command $$create_urace_trap(property $obj : object, property $trap_id)
{
	property $filename : str
	property $center_type
	
	$filename = "__mng_ur_trap" + math.tostr_zero($trap_id, 2)
	
	$obj.create($filename, 1)
	
	if( $trap_id == @ƒŒ[ƒXáŠQ•¨_–Î‚İ ) {
;		$obj.child.resize(1)
;		$obj.child[$i].child[0].create($filename, 1)
	}
	
	$obj.x_rep.resize(1)
	$obj.y_rep.resize(2)
	$obj.f.resize(<F_FLAG_MAX>)
	$obj.f_id = $trap_id
	
	// ŠeáŠQ•¨‚²‚Æ‚Ìˆ—
	switch( $trap_id ) {
	case(@ƒŒ[ƒXáŠQ•¨_¬Î)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_‘åŠâ)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_‘‚Ş‚ç)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_…‚½‚Ü‚è)	$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_–Î‚İ)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_ŠC‘”)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_ŠâÊ)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_ò)			$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_‰QŠª)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_Œf¦”Â)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_‰ñ“]–_)		$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_ƒXƒpƒCƒN)	$center_type = 1
	case(@ƒŒ[ƒXáŠQ•¨_—³Šª)		$center_type = 1
	}
	
	// áŠQ•¨‚²‚Æ‚É’†S“_‚ğ•ÏX‚·‚é
	switch( $center_type ) {
	case(0)			// xAy‚Æ‚à‚É’†S
		$$set_image_center($obj)
	case(1)			// x‚Í’†SAy‚Í‰º
		$obj.set_center($obj.get_size_x / 2,  $obj.get_size_y)
	}
	
	// ‘Ò‹@ƒAƒjƒ[ƒVƒ‡ƒ“‚ğì¬‚·‚é
	$$play_urace_trap_wait_animation($obj)
}

//---------------------------------------------------------------------------
// áŠQ•¨‚Ì‘Ò‹@ƒAƒjƒ[ƒVƒ‡ƒ“‚ğì¬‚·‚é
//---------------------------------------------------------------------------
command $$play_urace_trap_wait_animation(property $obj : object)
{
	switch( $obj.f_id ) {
	case(@ƒŒ[ƒXáŠQ•¨_Œf¦”Â)		$obj.patno_eve.loop(0, 4, 200 * 4, 0, 0)
	case(@ƒŒ[ƒXáŠQ•¨_‰ñ“]–_)		$obj.patno_eve.loop(0, 4, 150 * 4, 0, 0)
	case(@ƒŒ[ƒXáŠQ•¨_ƒXƒpƒCƒN)	$obj.patno_eve.loop(0, 3, 200 * 3, 0, 0)
	case(@ƒŒ[ƒXáŠQ•¨_—³Šª)		$obj.patno_eve.loop(0, 3, 150 * 3, 0, 0)
	}
}

//---------------------------------------------------------------------------
// áŠQ•¨‚É“–‚½‚Á‚½‚Æ‚«‚ÌƒGƒtƒFƒNƒg‚ğÄ¶‚·‚é
//---------------------------------------------------------------------------
command $$play_urace_trap_hit_animation(property $obj : object)
{
	switch( $obj.f_id ) {
	case(@ƒŒ[ƒXáŠQ•¨_¬Î)
		$obj.frame_action.start(-1, "$$fa_effect_trap01")
	case(@ƒŒ[ƒXáŠQ•¨_‘‚Ş‚ç)
		$obj.frame_action.start(-1, "$$fa_effect_trap03")
	case(@ƒŒ[ƒXáŠQ•¨_…‚½‚Ü‚è)
		$obj.frame_action.start(-1, "$$fa_effect_trap04")
	case(@ƒŒ[ƒXáŠQ•¨_–Î‚İ)
		$obj.frame_action.start(-1, "$$fa_effect_trap05")
	case(@ƒŒ[ƒXáŠQ•¨_ŠC‘”)
		$obj.frame_action.start(-1, "$$fa_effect_trap06")
	case(@ƒŒ[ƒXáŠQ•¨_ò)
		$obj.frame_action.start(-1, "$$fa_effect_trap08")
	case(@ƒŒ[ƒXáŠQ•¨_‰QŠª)
		$obj.frame_action.start(-1, "$$fa_effect_trap09")
	}
}

// áŠQ•¨01^¬Î
command $$fa_effect_trap01(property $fa : frameaction, property $obj : object)
{
	$obj.tr = math.timetable($fa.counter.get, 0, 255, [250, 500, 0, 2])
	$obj.x_rep[0] = math.timetable($fa.counter.get, 0, 0, [0, 500, 120, 2])
	$obj.y_rep[0] = math.timetable($fa.counter.get, 0, 0, [0, 250, -140, 2], [250, 500, 120, 1])
	$obj.rotate_z = math.timetable($fa.counter.get, 0, 0, [0, 500, 350, 1])
	
	if( $fa.counter.get > 500 ) {
		$obj.disp = 0
		$obj.frame_action.end
	}
}

// áŠQ•¨03^‘‚Ş‚ç
command $$fa_effect_trap03(property $fa : frameaction, property $obj : object)
{
	$obj.scale_y = math.timetable($fa.counter.get, 0, 1000, [0, 250, 450, 2], [250, 500, 1100, 1], [500, 750, 850, 2], [750, 1000, 1050, 1], [1000, 1150, 950, 2], [1150, 1250, 1000, 1])
	
	if( $fa.counter.get > 1250 ) {
		$obj.frame_action.end
	}
}

// áŠQ•¨04^…‚½‚Ü‚è
command $$fa_effect_trap04(property $fa : frameaction, property $obj : object)
{
	$obj.scale_y = math.timetable($fa.counter.get, 0, 1000, [0, 250, 950, 2], [250, 450, 1050, 1], [450, 600, 970, 2], [600, 850, 1010, 1], [850, 1000, 1000, 2])
	$obj.tr = math.timetable($fa.counter.get, 0, 224, [0, 250, 255, 2], [250, 450, 224, 1], [450, 600, 255, 2], [600, 850, 224, 1], [850, 1000, 255, 2])
	
	if( $fa.counter.get > 1000 ) {
		$obj.frame_action.end
	}
}

// áŠQ•¨05^–Î‚İ
command $$fa_effect_trap05(property $fa : frameaction, property $obj : object)
{
	$obj.scale_x = math.timetable($fa.counter.get, 0, 1000, [0, 250, 1100, 2], [250, 450,  850, 1], [450, 600, 1050, 2], [600, 850, 1000, 2])
	$obj.scale_y = math.timetable($fa.counter.get, 0, 1000, [0, 250,  750, 2], [250, 450, 1100, 1], [450, 600,  950, 2], [600, 850, 1000, 2])
	
	if( $fa.counter.get > 1000 ) {
		$obj.frame_action.end
	}
}

// áŠQ•¨06^ŠC‘”
command $$fa_effect_trap06(property $fa : frameaction, property $obj : object)
{
	$obj.y_rep[0] = math.timetable($fa.counter.get, 0, 0, [0, 500, 120, 1])
	$obj.scale_x = math.timetable($fa.counter.get, 0, 1000, [0, 250, 500, 2])
	$obj.tr = math.timetable($fa.counter.get, 0, 255, [250, 500, 0, 2])
	
	if( $fa.counter.get > 500 ) {
		$obj.disp = 0
		$obj.frame_action.end
	}
}

// áŠQ•¨08^ò
command $$fa_effect_trap08(property $fa : frameaction, property $obj : object)
{
	$obj.scale_x = math.timetable($fa.counter.get, 0, 1000, [0, 150, 1050, 2], [150, 300,  950, 1], [300, 450, 1010, 2], [450, 600,  970, 1], [600, 750, 1000, 2])
	$obj.scale_y = math.timetable($fa.counter.get, 0, 1000, [0, 150,  950, 2], [150, 300, 1050, 1], [300, 450,  970, 2], [450, 600, 1010, 1], [600, 750, 1000, 2])
	
	if( $fa.counter.get > 750 ) {
		$obj.frame_action.end
	}
}

// áŠQ•¨09^‰QŠª
command $$fa_effect_trap09(property $fa : frameaction, property $obj : object)
{
	$obj.scale_x = math.timetable($fa.counter.get, 0, 1000, [0, 500, 100, 1])
	$obj.scale_y = math.timetable($fa.counter.get, 0, 1000, [0, 500, 100, 1])
	$obj.tr = math.timetable($fa.counter.get, 0, 255, [250, 500, 0, 2])
	
	if( $fa.counter.get > 500 ) {
		$obj.disp = 0
		$obj.frame_action.end
	}
}
