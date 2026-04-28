// BGM first-seen toast. Uses the existing Extra sound info image cuts.
#z00

command $$try_show_bgm_toast(property $filename : str, property $fade_in_time, property $fade_out_time)
{
    $$show_bgm_toast($filename)
    bgm.play($filename, $fade_in_time, $fade_out_time)
}

command $$show_bgm_toast(property $filename : str)
{
    property $music_index

    if( z[3] != 0 ) {
        return
    }

    if( $filename == "" ) {
        return
    }

    if( bgmtable.get_listen_by_name($filename) == 1 ) {
        return
    }

    $music_index = $$get_bgm_toast_music_index($filename)
    if( $music_index < 0 ) {
        return
    }

    $$show_bgm_toast_info($music_index)
}

command $$get_bgm_toast_music_index(property $filename : str) : int
{
    property $i
    property $music_cnt

    $music_cnt = $$get_extra_music_cnt
    for( $i = 0, $i < $music_cnt, $i += 1 )
    {
        if( $$get_extra_music($i) == $filename ) {
            return ($i)
        }
    }

    return (-1)
}

command $$get_bgm_toast_info_x(property $music_index) : int
{
    switch( $music_index ) {
    case(0) return (-469)
    case(1) return (-439)
    case(2) return (-377)
    case(3) return (-303)
    case(4) return (-354)
    case(5) return (-327)
    case(6) return (-422)
    case(7) return (-400)
    case(8) return (-392)
    case(9) return (-397)
    case(10) return (-414)
    case(11) return (-419)
    case(12) return (-434)
    case(13) return (-224)
    case(14) return (-388)
    case(15) return (-416)
    case(16) return (-400)
    case(17) return (-423)
    case(18) return (-355)
    case(19) return (-312)
    case(20) return (-420)
    case(21) return (-438)
    case(22) return (-449)
    case(23) return (-333)
    case(24) return (-205)
    case(25) return (-394)
    case(26) return (-439)
    case(27) return (18)
    case(28) return (-379)
    case(29) return (-310)
    case(30) return (-384)
    case(31) return (-429)
    case(32) return (-450)
    case(33) return (-355)
    case(34) return (-437)
    case(35) return (-361)
    case(36) return (-438)
    case(37) return (-434)
    case(38) return (-439)
    case(39) return (-430)
    case(40) return (-308)
    case(41) return (-454)
    case(42) return (-446)
    case(43) return (-436)
    case(44) return (-469)
    case(45) return (-446)
    case(46) return (-327)
    case(47) return (-332)
    case(48) return (-266)
    case(49) return (-233)
    case(50) return (-250)
    case(51) return (-272)
    case(52) return (-235)
    case(53) return (-302)
    case(54) return (-314)
    case(55) return (-201)
    }

    return (18)
}

command $$show_bgm_toast_info(property $music_index)
{
    property $pos_x

    $pos_x = $$get_bgm_toast_info_x($music_index)

    front.object[<OBJ_BGM_TOAST>].init()
    front.object[<OBJ_BGM_TOAST>].create("_extra_sound_player_bgm_info", 1, $pos_x, 18, $music_index)
    front.object[<OBJ_BGM_TOAST>].patno = $music_index
    front.object[<OBJ_BGM_TOAST>].order = <ORDER_TOAST>
    front.object[<OBJ_BGM_TOAST>].tr = 0
    front.object[<OBJ_BGM_TOAST>].wipe_copy = 0

    front.object[<OBJ_BGM_TOAST>].frame_action.start(4500, "$$fa_bgm_toast")
}

command $$fa_bgm_toast(property $fa : frameaction, property $obj : object)
{
    l[0] = $fa.counter.get

    $obj.tr = math.timetable(l[0], 0, 0, [0, 500, 255, 2], [4000, 4500, 0, 2])
}
