//===========================================================================
//!
//!    @file     __sys_extra_cg_diff.ss
//!    @brief    イベントＣＧ鑑賞／差分表示シーン(システム側)
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start

	#property	$diff_no					// 現在のイベントＣＧ差分番号
	#property	$old_diff_no				// 前のイベントＣＧ差分番号
	
	#property	$diff_list : strlist		// イベントＣＧ差分リスト

#inc_end

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞／差分表示シーン開始
//---------------------------------------------------------------------------
#z00

$diff_no = 0												// 差分番号を初期化する
$$set_cg_diff(l[0])											// イベントＣＧの差分リストを設定する
$$create_scene_object(excall.back, $diff_list[$diff_no])	// シーンオブジェクトを作成する
$$show_extra_cg_diff(excall.back)							// シーンオブジェクトを表示する

// 入力制御を開始する
input.clear

while( 1 )
{
	// ジョイパッドのキーリピート処理
	$$update_joypad_key_repeat
	
	// キャンセルキーが入力された場合はＣＧ表示を終了する
	if( input.cancel.on_down )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		break
	}
	
	// 決定キー、マウスホイール、Ｒ１が入力された場合は差分を進める
	if( input.decide.on_down || mouse.wheel > 0 || $$joypad_on_down(<JOYPAD_R1>) )
	{
		if( $$prev_diff ) {
			break
		}
	}
	
	// マウスホイール、Ｌ１が入力された場合は差分を戻す
	elseif( mouse.wheel < 0 || $$joypad_on_down(<JOYPAD_L1>) )
	{
		if( $$next_diff ) {
			break
		}
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

// イベントＣＧオブジェクトのワイプコピーフラグをオフにする
excall.front.object[@オブジェクト_エクストラ_表示中のＣＧ].wipe_copy = 0

// シーンオブジェクトを非表示にする
$$hide_extra_cg_diff(excall.front)

return


//---------------------------------------------------------------------------
// 現在表示中のＣＧファイル名を取得する
//---------------------------------------------------------------------------
command $$get_extra_cg_disp_filename : str
{
	return ($diff_list[$diff_no])
}

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
command $$get_extra_cg_diff_cnt(property $cg_index, property $is_max)
{
    property $i
    property $filename : str
    property $count
    property $diff_cnt
    
    $count = 0
    $diff_cnt = $$get_extra_cg_static_diff_cnt($cg_index)
    
    if( $is_max ) {
        return ($diff_cnt)
    }
    
    for( $i = 0, $i < $diff_cnt, $i += 1 )
    {
        $filename = $$get_extra_cg_static_diff_filename($cg_index, $i)
        
        if( $filename == "" ) {
            continue
        }
        
        if( cgtable.get_look_by_name($filename) == 1 )
        {
            $count += 1
        }
    }
    
    return ($count)
}

//---------------------------------------------------------------------------
// イベントＣＧの差分リストを設定する
//---------------------------------------------------------------------------
command $$set_cg_diff(property $cg_list_index)
{
    property $i
    property $filename : str
    property $diff_cnt
    
    $diff_list.init
    $diff_cnt = $$get_extra_cg_static_diff_cnt($cg_list_index)
    
    for( $i = 0, $i < $diff_cnt, $i += 1 )
    {
        $filename = $$get_extra_cg_static_diff_filename($cg_list_index, $i)
        
        if( $filename == "" ) {
            continue
        }
        
        if( cgtable.get_look_by_name($filename) == 1 )
        {
            $diff_list.resize($diff_list.get_size + 1)
            $diff_list[$diff_list.get_size - 1] = $filename
        }
    }
}

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage, property $filename : str)
{
	$$set_cg_object($stage.object[@オブジェクト_エクストラ_表示中のＣＧ], $filename)
}

//---------------------------------------------------------------------------
// 前の差分へ戻る
//---------------------------------------------------------------------------
command $$prev_diff
{
	$old_diff_no = $diff_no
	
	$diff_no += 1
	if( $diff_no > $diff_list.get_size - 1 )
	{
		// 差分の終点で始点にループするが有効の場合はループさせる
		if( __EXTRA_CG_DIFF_END_LOOP )
		{
			$diff_no = 0
		}
		else
		{
			// 効果音を再生する
			se.play_by_se_no(<BUTTON_SE_CANCEL>)
			
			// 差分の終点で始点にループするが無効の場合は終了する
			return (1)
		}
	}
	
	// 差分の変更があった場合
	if( $old_diff_no != $diff_no )
	{
		// 効果音を再生する
		se.play_by_se_no(<BUTTON_SE_CHANGE_PAGE>)
		
		// シーンオブジェクトを再構築する
		$$rebuild_scene_object
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// 次の差分へ進む
//---------------------------------------------------------------------------
command $$next_diff
{
	$old_diff_no = $diff_no
	
	$diff_no -= 1
	if( $diff_no < 0 )
	{
		// 差分の終点で始点にループするが有効の場合はループさせる
		if( __EXTRA_CG_DIFF_END_LOOP )
		{
			$diff_no = $diff_list.get_size - 1
		}
		else
		{
			// 効果音を再生する
			se.play_by_se_no(<BUTTON_SE_CANCEL>)
			
			// 差分の終点で始点にループするが無効の場合は終了する
			return (1)
		}
	}
	
	// 差分の変更があった場合
	if( $old_diff_no != $diff_no )
	{
		// 効果音を再生する
		se.play_by_se_no(<BUTTON_SE_CHANGE_PAGE>)
		
		// シーンオブジェクトを再構築する
		$$rebuild_scene_object
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを再構築する
//---------------------------------------------------------------------------
command $$rebuild_scene_object
{
	// シーンオブジェクトを作成する
	$$create_scene_object(excall.back, $diff_list[$diff_no])
	
	// シーンオブジェクトを更新する
	$$change_extra_cg_diff(excall.back)
}

// Static extra CG diff table restored from the known-good Scene.chs implementation.
command $$get_extra_cg_static_diff_cnt(property $cg_index) : int
{
    switch( $cg_index ) {
    case(0) return (3)
    case(1) return (9)
    case(2) return (3)
    case(3) return (5)
    case(4) return (5)
    case(5) return (8)
    case(6) return (4)
    case(7) return (2)
    case(8) return (7)
    case(9) return (5)
    case(10) return (10)
    case(11) return (4)
    case(12) return (1)
    case(16) return (4)
    case(17) return (11)
    case(18) return (4)
    case(19) return (6)
    case(20) return (3)
    case(21) return (4)
    case(22) return (5)
    case(23) return (5)
    case(24) return (3)
    case(25) return (3)
    case(26) return (19)
    case(27) return (5)
    case(28) return (2)
    case(29) return (2)
    case(30) return (4)
    case(32) return (5)
    case(33) return (6)
    case(34) return (16)
    case(35) return (6)
    case(36) return (13)
    case(37) return (9)
    case(38) return (5)
    case(39) return (14)
    case(40) return (4)
    case(41) return (3)
    case(42) return (3)
    case(43) return (10)
    case(44) return (1)
    case(48) return (8)
    case(49) return (2)
    case(50) return (3)
    case(51) return (7)
    case(52) return (6)
    case(53) return (6)
    case(54) return (3)
    case(55) return (4)
    case(56) return (7)
    case(57) return (7)
    case(58) return (10)
    case(59) return (18)
    case(60) return (1)
    case(64) return (4)
    case(65) return (2)
    case(66) return (2)
    case(67) return (3)
    case(68) return (11)
    case(69) return (5)
    case(70) return (3)
    case(71) return (10)
    case(72) return (5)
    case(73) return (5)
    case(74) return (5)
    case(75) return (10)
    case(76) return (1)
    case(80) return (3)
    case(81) return (13)
    case(82) return (1)
    case(96) return (5)
    case(97) return (4)
    case(98) return (5)
    case(112) return (8)
    case(113) return (5)
    case(114) return (3)
    case(128) return (4)
    case(129) return (4)
    case(130) return (5)
    case(144) return (5)
    case(145) return (7)
    case(146) return (3)
    case(160) return (4)
    case(161) return (3)
    case(176) return (5)
    case(177) return (3)
    case(178) return (1)
    case(192) return (6)
    case(193) return (6)
    case(194) return (2)
    case(195) return (9)
    case(196) return (8)
    case(197) return (2)
    case(198) return (4)
    case(199) return (6)
    case(200) return (3)
    case(201) return (2)
    case(202) return (1)
    case(203) return (7)
    case(204) return (4)
    case(205) return (2)
    case(206) return (2)
    }
    return (0)
}

command $$get_extra_cg_static_diff_filename(property $cg_index, property $diff_index) : str
{
    switch( $cg_index ) {
    case(0)
        switch( $diff_index ) {
        case(0) return (CG_SP01_0101)
        case(1) return (CG_SP01_0102)
        case(2) return (CG_SP01_0201)
        }
    case(1)
        switch( $diff_index ) {
        case(0) return (CG_SP02_0101)
        case(1) return (CG_SP02_0102)
        case(2) return (CG_SP02_0201)
        case(3) return (CG_SP02_0202)
        case(4) return (CG_SP02_0204)
        case(5) return (CG_SP02_0301)
        case(6) return (CG_SP02_0302)
        case(7) return (CG_SP02_0303)
        case(8) return (CG_SP02_0304)
        }
    case(2)
        switch( $diff_index ) {
        case(0) return (CG_SP03_0101)
        case(1) return (CG_SP03_0201)
        case(2) return (CG_SP03_0202)
        }
    case(3)
        switch( $diff_index ) {
        case(0) return (CG_SP04_0101)
        case(1) return (CG_SP04_0102)
        case(2) return (CG_SP04_0103)
        case(3) return (CG_SP04_0104)
        case(4) return (CG_SP04_0105)
        }
    case(4)
        switch( $diff_index ) {
        case(0) return (CG_SP05_0101)
        case(1) return (CG_SP05_0102)
        case(2) return (CG_SP05_0201)
        case(3) return (CG_SP05_0301)
        case(4) return (CG_SP05_0302)
        }
    case(5)
        switch( $diff_index ) {
        case(0) return (CG_SP06_0101)
        case(1) return (CG_SP06_0102)
        case(2) return (CG_SP06_0201)
        case(3) return (CG_SP06_0202)
        case(4) return (CG_SP06_0203)
        case(5) return (CG_SP06_0204)
        case(6) return (CG_SP06_0205)
        case(7) return (CG_SP06_0206)
        }
    case(6)
        switch( $diff_index ) {
        case(0) return (CG_SP07_0101)
        case(1) return (CG_SP07_0102)
        case(2) return (CG_SP07_0103)
        case(3) return (CG_SP07_0201)
        }
    case(7)
        switch( $diff_index ) {
        case(0) return (CG_SP08_0101)
        case(1) return (CG_SP08_0102)
        }
    case(8)
        switch( $diff_index ) {
        case(0) return (CG_SP09_0101)
        case(1) return (CG_SP09_0102)
        case(2) return (CG_SP09_0103)
        case(3) return (CG_SP09_0104)
        case(4) return (CG_SP09_0105)
        case(5) return (CG_SP09_0201)
        case(6) return (CG_SP09_0202)
        }
    case(9)
        switch( $diff_index ) {
        case(0) return (CG_SP10_0101)
        case(1) return (CG_SP10_0102)
        case(2) return (CG_SP10_0103)
        case(3) return (CG_SP10_0201)
        case(4) return (CG_SP10_0301)
        }
    case(10)
        switch( $diff_index ) {
        case(0) return (CG_SP11_0101)
        case(1) return (CG_SP11_0102)
        case(2) return (CG_SP11_0105)
        case(3) return (CG_SP11_0201)
        case(4) return (CG_SP11_0202)
        case(5) return (CG_SP11_0301)
        case(6) return (CG_SP11_0302)
        case(7) return (CG_SP11_0303)
        case(8) return (CG_SP11_0304)
        case(9) return (CG_SP11_0305)
        }
    case(11)
        switch( $diff_index ) {
        case(0) return (CG_SP12_0101)
        case(1) return (CG_SP12_0102)
        case(2) return (CG_SP12_0103)
        case(3) return (CG_SP12_0104)
        }
    case(12)
        switch( $diff_index ) {
        case(0) return (CG_SP13_0101)
        }
    case(16)
        switch( $diff_index ) {
        case(0) return (CG_AI01_0101)
        case(1) return (CG_AI01_0102)
        case(2) return (CG_AI01_0103)
        case(3) return (CG_AI01_0201)
        }
    case(17)
        switch( $diff_index ) {
        case(0) return (CG_AI02_0101)
        case(1) return (CG_AI02_0102)
        case(2) return (CG_AI02_0103)
        case(3) return (CG_AI02_0104)
        case(4) return (CG_AI02_0105)
        case(5) return (CG_AI02_0106)
        case(6) return (CG_AI02_0201)
        case(7) return (CG_AI02_0202)
        case(8) return (CG_AI02_0203)
        case(9) return (CG_AI02_0204)
        case(10) return (CG_AI02_0206)
        }
    case(18)
        switch( $diff_index ) {
        case(0) return (CG_AI03_0101)
        case(1) return (CG_AI03_0102)
        case(2) return (CG_AI03_0103)
        case(3) return (CG_AI03_0104)
        }
    case(19)
        switch( $diff_index ) {
        case(0) return (CG_AI04_0101)
        case(1) return (CG_AI04_0102)
        case(2) return (CG_AI04_0103)
        case(3) return (CG_AI04_0104)
        case(4) return (CG_AI04_0201)
        case(5) return (CG_AI04_0202)
        }
    case(20)
        switch( $diff_index ) {
        case(0) return (CG_AI05_0101)
        case(1) return (CG_AI05_0102)
        case(2) return (CG_AI05_0103)
        }
    case(21)
        switch( $diff_index ) {
        case(0) return (CG_AI06_0101)
        case(1) return (CG_AI06_0102)
        case(2) return (CG_AI06_0201)
        case(3) return (CG_AI06_0202)
        }
    case(22)
        switch( $diff_index ) {
        case(0) return (CG_AI07_0101)
        case(1) return (CG_AI07_0102)
        case(2) return (CG_AI07_0103)
        case(3) return (CG_AI07_0104)
        case(4) return (CG_AI07_0105)
        }
    case(23)
        switch( $diff_index ) {
        case(0) return (CG_AI08_0101)
        case(1) return (CG_AI08_0102)
        case(2) return (CG_AI08_0103)
        case(3) return (CG_AI08_0104)
        case(4) return (CG_AI08_0301)
        }
    case(24)
        switch( $diff_index ) {
        case(0) return (CG_AI09_0101)
        case(1) return (CG_AI09_0102)
        case(2) return (CG_AI09_0103)
        }
    case(25)
        switch( $diff_index ) {
        case(0) return (CG_AI10_0101)
        case(1) return (CG_AI10_0102)
        case(2) return (CG_AI10_0201)
        }
    case(26)
        switch( $diff_index ) {
        case(0) return (CG_AI11_0101)
        case(1) return (CG_AI11_0102)
        case(2) return (CG_AI11_0104)
        case(3) return (CG_AI11_0105)
        case(4) return (CG_AI11_0107)
        case(5) return (CG_AI11_0108)
        case(6) return (CG_AI11_0110)
        case(7) return (CG_AI11_0111)
        case(8) return (CG_AI11_0112)
        case(9) return (CG_AI11_0114)
        case(10) return (CG_AI11_0115)
        case(11) return (CG_AI11_0201)
        case(12) return (CG_AI11_0202)
        case(13) return (CG_AI11_0301)
        case(14) return (CG_AI11_0302)
        case(15) return (CG_AI11_0303)
        case(16) return (CG_AI11_0304)
        case(17) return (CG_AI11_0305)
        case(18) return (CG_AI11_0306)
        }
    case(27)
        switch( $diff_index ) {
        case(0) return (CG_AI12_0101)
        case(1) return (CG_AI12_0102)
        case(2) return (CG_AI12_0103)
        case(3) return (CG_AI12_0104)
        case(4) return (CG_AI12_0201)
        }
    case(28)
        switch( $diff_index ) {
        case(0) return (CG_AI13_0101)
        case(1) return (CG_AI13_0102)
        }
    case(29)
        switch( $diff_index ) {
        case(0) return (CG_AI14_0101)
        case(1) return (CG_AI14_0201)
        }
    case(30)
        switch( $diff_index ) {
        case(0) return (CG_AI15_0101)
        case(1) return (CG_AI15_0102)
        case(2) return (CG_AI15_0103)
        case(3) return (CG_AI15_0201)
        }
    case(32)
        switch( $diff_index ) {
        case(0) return (CG_HI01_0101)
        case(1) return (CG_HI01_0102)
        case(2) return (CG_HI01_0301)
        case(3) return (CG_HI01_0401)
        case(4) return (CG_HI01_0402)
        }
    case(33)
        switch( $diff_index ) {
        case(0) return (CG_HI02_0101)
        case(1) return (CG_HI02_0102)
        case(2) return (CG_HI02_0103)
        case(3) return (CG_HI02_0104)
        case(4) return (CG_HI02_0201)
        case(5) return (CG_HI02_0204)
        }
    case(34)
        switch( $diff_index ) {
        case(0) return (CG_HI03_0101)
        case(1) return (CG_HI03_0102)
        case(2) return (CG_HI03_0103)
        case(3) return (CG_HI03_0301)
        case(4) return (CG_HI03_0303)
        case(5) return (CG_HI03_0304)
        case(6) return (CG_HI03_0401)
        case(7) return (CG_HI03_0402)
        case(8) return (CG_HI03_0501)
        case(9) return (CG_HI03_0502)
        case(10) return (CG_HI03_0512)
        case(11) return (CG_HI03_0701)
        case(12) return (CG_HI03_0702)
        case(13) return (CG_HI03_0712)
        case(14) return (CG_HI03_0902)
        case(15) return (CG_HI03_0911)
        }
    case(35)
        switch( $diff_index ) {
        case(0) return (CG_HI04_0101)
        case(1) return (CG_HI04_0102)
        case(2) return (CG_HI04_0103)
        case(3) return (CG_HI04_0202)
        case(4) return (CG_HI04_0203)
        case(5) return (CG_HI04_0204)
        }
    case(36)
        switch( $diff_index ) {
        case(0) return (CG_HI05_0101)
        case(1) return (CG_HI05_0102)
        case(2) return (CG_HI05_0103)
        case(3) return (CG_HI05_0201)
        case(4) return (CG_HI05_0203)
        case(5) return (CG_HI05_0211)
        case(6) return (CG_HI05_0212)
        case(7) return (CG_HI05_0213)
        case(8) return (CG_HI05_0221)
        case(9) return (CG_HI05_0222)
        case(10) return (CG_HI05_0223)
        case(11) return (CG_HI05_0301)
        case(12) return (CG_HI05_0401)
        }
    case(37)
        switch( $diff_index ) {
        case(0) return (CG_HI06_0101)
        case(1) return (CG_HI06_0102)
        case(2) return (CG_HI06_0201)
        case(3) return (CG_HI06_0202)
        case(4) return (CG_HI06_0203)
        case(5) return (CG_HI06_0301)
        case(6) return (CG_HI06_0401)
        case(7) return (CG_HI06_0501)
        case(8) return (CG_HI06_0503)
        }
    case(38)
        switch( $diff_index ) {
        case(0) return (CG_HI07_0101)
        case(1) return (CG_HI07_0201)
        case(2) return (CG_HI07_0202)
        case(3) return (CG_HI07_0203)
        case(4) return (CG_HI07_0204)
        }
    case(39)
        switch( $diff_index ) {
        case(0) return (CG_HI08_0101)
        case(1) return (CG_HI08_0102)
        case(2) return (CG_HI08_0103)
        case(3) return (CG_HI08_0201)
        case(4) return (CG_HI08_0202)
        case(5) return (CG_HI08_0203)
        case(6) return (CG_HI08_0301)
        case(7) return (CG_HI08_0403)
        case(8) return (CG_HI08_0405)
        case(9) return (CG_HI08_0601)
        case(10) return (CG_HI08_0604)
        case(11) return (CG_HI08_0605)
        case(12) return (CG_HI08_0701)
        case(13) return (CG_HI08_0705)
        }
    case(40)
        switch( $diff_index ) {
        case(0) return (CG_HI09_0101)
        case(1) return (CG_HI09_0102)
        case(2) return (CG_HI09_0201)
        case(3) return (CG_HI09_0301)
        }
    case(41)
        switch( $diff_index ) {
        case(0) return (CG_HI10_0101)
        case(1) return (CG_HI10_0102)
        case(2) return (CG_HI10_0103)
        }
    case(42)
        switch( $diff_index ) {
        case(0) return (CG_HI11_0101)
        case(1) return (CG_HI11_0201)
        case(2) return (CG_HI11_0202)
        }
    case(43)
        switch( $diff_index ) {
        case(0) return (CG_HI12_0101)
        case(1) return (CG_HI12_0102)
        case(2) return (CG_HI12_0103)
        case(3) return (CG_HI12_0201)
        case(4) return (CG_HI12_0202)
        case(5) return (CG_HI12_0203)
        case(6) return (CG_HI12_0301)
        case(7) return (CG_HI12_0401)
        case(8) return (CG_HI12_0402)
        case(9) return (CG_HI12_0403)
        }
    case(44)
        switch( $diff_index ) {
        case(0) return (CG_HI13_0101)
        }
    case(48)
        switch( $diff_index ) {
        case(0) return (CG_KY01_0101)
        case(1) return (CG_KY01_0102)
        case(2) return (CG_KY01_0103)
        case(3) return (CG_KY01_0104)
        case(4) return (CG_KY01_0105)
        case(5) return (CG_KY01_0204)
        case(6) return (CG_KY01_0205)
        case(7) return (CG_KY01_0206)
        }
    case(49)
        switch( $diff_index ) {
        case(0) return (CG_KY02_0101)
        case(1) return (CG_KY02_0201)
        }
    case(50)
        switch( $diff_index ) {
        case(0) return (CG_KY03_0101)
        case(1) return (CG_KY03_0102)
        case(2) return (CG_KY03_0103)
        }
    case(51)
        switch( $diff_index ) {
        case(0) return (CG_KY04_0101)
        case(1) return (CG_KY04_0103)
        case(2) return (CG_KY04_0104)
        case(3) return (CG_KY04_0222)
        case(4) return (CG_KY04_0232)
        case(5) return (CG_KY04_0303)
        case(6) return (CG_KY04_0304)
        }
    case(52)
        switch( $diff_index ) {
        case(0) return (CG_KY05_0101)
        case(1) return (CG_KY05_0102)
        case(2) return (CG_KY05_0201)
        case(3) return (CG_KY05_0202)
        case(4) return (CG_KY05_0301)
        case(5) return (CG_KY05_0302)
        }
    case(53)
        switch( $diff_index ) {
        case(0) return (CG_KY06_0101)
        case(1) return (CG_KY06_0102)
        case(2) return (CG_KY06_0201)
        case(3) return (CG_KY06_0301)
        case(4) return (CG_KY06_0401)
        case(5) return (CG_KY06_0402)
        }
    case(54)
        switch( $diff_index ) {
        case(0) return (CG_KY07_0101)
        case(1) return (CG_KY07_0102)
        case(2) return (CG_KY07_0103)
        }
    case(55)
        switch( $diff_index ) {
        case(0) return (CG_KY08_0101)
        case(1) return (CG_KY08_0102)
        case(2) return (CG_KY08_0201)
        case(3) return (CG_KY08_0202)
        }
    case(56)
        switch( $diff_index ) {
        case(0) return (CG_KY09_0101)
        case(1) return (CG_KY09_0201)
        case(2) return (CG_KY09_0202)
        case(3) return (CG_KY09_0203)
        case(4) return (CG_KY09_0204)
        case(5) return (CG_KY09_0301)
        case(6) return (CG_KY09_0303)
        }
    case(57)
        switch( $diff_index ) {
        case(0) return (CG_KY10_0101)
        case(1) return (CG_KY10_0201)
        case(2) return (CG_KY10_0202)
        case(3) return (CG_KY10_0203)
        case(4) return (CG_KY10_0204)
        case(5) return (CG_KY10_0205)
        case(6) return (CG_KY10_0206)
        }
    case(58)
        switch( $diff_index ) {
        case(0) return (CG_KY11_0101)
        case(1) return (CG_KY11_0201)
        case(2) return (CG_KY11_0301)
        case(3) return (CG_KY11_0302)
        case(4) return (CG_KY11_0401)
        case(5) return (CG_KY11_0402)
        case(6) return (CG_KY11_0501)
        case(7) return (CG_KY11_0601)
        case(8) return (CG_KY11_0702)
        case(9) return (CG_KY11_0704)
        }
    case(59)
        switch( $diff_index ) {
        case(0) return (CG_KY12_0101)
        case(1) return (CG_KY12_0102)
        case(2) return (CG_KY12_0104)
        case(3) return (CG_KY12_0111)
        case(4) return (CG_KY12_0114)
        case(5) return (CG_KY12_0122)
        case(6) return (CG_KY12_0201)
        case(7) return (CG_KY12_0202)
        case(8) return (CG_KY12_0203)
        case(9) return (CG_KY12_0204)
        case(10) return (CG_KY12_0205)
        case(11) return (CG_KY12_0211)
        case(12) return (CG_KY12_0212)
        case(13) return (CG_KY12_0213)
        case(14) return (CG_KY12_0214)
        case(15) return (CG_KY12_0222)
        case(16) return (CG_KY12_0232)
        case(17) return (CG_KY12_0235)
        }
    case(60)
        switch( $diff_index ) {
        case(0) return (CG_KY13_0101)
        }
    case(64)
        switch( $diff_index ) {
        case(0) return (CG_RK05_0101)
        case(1) return (CG_RK05_0103)
        case(2) return (CG_RK05_0104)
        case(3) return (CG_RK05_0105)
        }
    case(65)
        switch( $diff_index ) {
        case(0) return (CG_RK08_0101)
        case(1) return (CG_RK08_0102)
        }
    case(66)
        switch( $diff_index ) {
        case(0) return (CG_RK01_0101)
        case(1) return (CG_RK01_0102)
        }
    case(67)
        switch( $diff_index ) {
        case(0) return (CG_RK13_0101)
        case(1) return (CG_RK13_0102)
        case(2) return (CG_RK13_0103)
        }
    case(68)
        switch( $diff_index ) {
        case(0) return (CG_RK14_0101)
        case(1) return (CG_RK14_0102)
        case(2) return (CG_RK14_0103)
        case(3) return (CG_RK14_0104)
        case(4) return (CG_RK14_0201)
        case(5) return (CG_RK14_0202)
        case(6) return (CG_RK14_0203)
        case(7) return (CG_RK14_0301)
        case(8) return (CG_RK14_0302)
        case(9) return (CG_RK14_0303)
        case(10) return (CG_RK14_0304)
        }
    case(69)
        switch( $diff_index ) {
        case(0) return (CG_RK02_0101)
        case(1) return (CG_RK02_0102)
        case(2) return (CG_RK02_0103)
        case(3) return (CG_RK02_0104)
        case(4) return (CG_RK02_0105)
        }
    case(70)
        switch( $diff_index ) {
        case(0) return (CG_RK03_0101)
        case(1) return (CG_RK03_0102)
        case(2) return (CG_RK03_0103)
        }
    case(71)
        switch( $diff_index ) {
        case(0) return (CG_RK04_0101)
        case(1) return (CG_RK04_0102)
        case(2) return (CG_RK04_0103)
        case(3) return (CG_RK04_0104)
        case(4) return (CG_RK04_0105)
        case(5) return (CG_RK04_0201)
        case(6) return (CG_RK04_0202)
        case(7) return (CG_RK04_0203)
        case(8) return (CG_RK04_0204)
        case(9) return (CG_RK04_0205)
        }
    case(72)
        switch( $diff_index ) {
        case(0) return (CG_RK06_0101)
        case(1) return (CG_RK06_0201)
        case(2) return (CG_RK06_0202)
        case(3) return (CG_RK06_0301)
        case(4) return (CG_RK06_0401)
        }
    case(73)
        switch( $diff_index ) {
        case(0) return (CG_RK09_0101)
        case(1) return (CG_RK09_0102)
        case(2) return (CG_RK09_0103)
        case(3) return (CG_RK09_0201)
        case(4) return (CG_RK09_0202)
        }
    case(74)
        switch( $diff_index ) {
        case(0) return (CG_RK07_0101)
        case(1) return (CG_RK07_0102)
        case(2) return (CG_RK07_0103)
        case(3) return (CG_RK07_0201)
        case(4) return (CG_RK07_0203)
        }
    case(75)
        switch( $diff_index ) {
        case(0) return (CG_RK10_0101)
        case(1) return (CG_RK10_0201)
        case(2) return (CG_RK10_0301)
        case(3) return (CG_RK10_0302)
        case(4) return (CG_RK10_0303)
        case(5) return (CG_RK10_0401)
        case(6) return (CG_RK10_0501)
        case(7) return (CG_RK10_0502)
        case(8) return (CG_RK10_0503)
        case(9) return (CG_RK10_0601)
        }
    case(76)
        switch( $diff_index ) {
        case(0) return (CG_RK12_0101)
        }
    case(80)
        switch( $diff_index ) {
        case(0) return (CG_TD01_0101)
        case(1) return (CG_TD01_0102)
        case(2) return (CG_TD01_0103)
        }
    case(81)
        switch( $diff_index ) {
        case(0) return (CG_TD02_0101)
        case(1) return (CG_TD02_0102)
        case(2) return (CG_TD02_0103)
        case(3) return (CG_TD02_0201)
        case(4) return (CG_TD02_0202)
        case(5) return (CG_TD02_0203)
        case(6) return (CG_TD02_0204)
        case(7) return (CG_TD02_0205)
        case(8) return (CG_TD02_0206)
        case(9) return (CG_TD02_0207)
        case(10) return (CG_TD02_0208)
        case(11) return (CG_TD02_0209)
        case(12) return (CG_TD02_0310)
        }
    case(82)
        switch( $diff_index ) {
        case(0) return (CG_TD03_0101)
        }
    case(96)
        switch( $diff_index ) {
        case(0) return (CG_FM01_0101)
        case(1) return (CG_FM01_0102)
        case(2) return (CG_FM01_0103)
        case(3) return (CG_FM01_0104)
        case(4) return (CG_FM01_0105)
        }
    case(97)
        switch( $diff_index ) {
        case(0) return (CG_FM02_0101)
        case(1) return (CG_FM02_0102)
        case(2) return (CG_FM02_0103)
        case(3) return (CG_FM02_0104)
        }
    case(98)
        switch( $diff_index ) {
        case(0) return (CG_FM03_0101)
        case(1) return (CG_FM03_0102)
        case(2) return (CG_FM03_0201)
        case(3) return (CG_FM03_0202)
        case(4) return (CG_FM03_0203)
        }
    case(112)
        switch( $diff_index ) {
        case(0) return (CG_RI01_0101)
        case(1) return (CG_RI01_0102)
        case(2) return (CG_RI01_0103)
        case(3) return (CG_RI01_0104)
        case(4) return (CG_RI01_0105)
        case(5) return (CG_RI01_0106)
        case(6) return (CG_RI01_0107)
        case(7) return (CG_RI01_0108)
        }
    case(113)
        switch( $diff_index ) {
        case(0) return (CG_RI02_0101)
        case(1) return (CG_RI02_0102)
        case(2) return (CG_RI02_0103)
        case(3) return (CG_RI02_0104)
        case(4) return (CG_RI02_0105)
        }
    case(114)
        switch( $diff_index ) {
        case(0) return (CG_RI03_0101)
        case(1) return (CG_RI03_0102)
        case(2) return (CG_RI03_0103)
        }
    case(128)
        switch( $diff_index ) {
        case(0) return (CG_KR01_0101)
        case(1) return (CG_KR01_0102)
        case(2) return (CG_KR01_0103)
        case(3) return (CG_KR01_0104)
        }
    case(129)
        switch( $diff_index ) {
        case(0) return (CG_KR02_0101)
        case(1) return (CG_KR02_0102)
        case(2) return (CG_KR02_0103)
        case(3) return (CG_KR02_0104)
        }
    case(130)
        switch( $diff_index ) {
        case(0) return (CG_KR03_0101)
        case(1) return (CG_KR03_0102)
        case(2) return (CG_KR03_0103)
        case(3) return (CG_KR03_0104)
        case(4) return (CG_KR03_0105)
        }
    case(144)
        switch( $diff_index ) {
        case(0) return (CG_CH01_0101)
        case(1) return (CG_CH01_0102)
        case(2) return (CG_CH01_0103)
        case(3) return (CG_CH01_0104)
        case(4) return (CG_CH01_0105)
        }
    case(145)
        switch( $diff_index ) {
        case(0) return (CG_CH02_0101)
        case(1) return (CG_CH02_0102)
        case(2) return (CG_CH02_0103)
        case(3) return (CG_CH02_0204)
        case(4) return (CG_CH02_0205)
        case(5) return (CG_CH02_0206)
        case(6) return (CG_CH02_0207)
        }
    case(146)
        switch( $diff_index ) {
        case(0) return (CG_CH03_0101)
        case(1) return (CG_CH03_0102)
        case(2) return (CG_CH03_0103)
        }
    case(160)
        switch( $diff_index ) {
        case(0) return (CG_KN01_0103)
        case(1) return (CG_KN01_0201)
        case(2) return (CG_KN01_0202)
        case(3) return (CG_KN01_0203)
        }
    case(161)
        switch( $diff_index ) {
        case(0) return (CG_KN02_0101)
        case(1) return (CG_KN02_0102)
        case(2) return (CG_KN02_0103)
        }
    case(176)
        switch( $diff_index ) {
        case(0) return (CG_HR01_0101)
        case(1) return (CG_HR01_0102)
        case(2) return (CG_HR01_0103)
        case(3) return (CG_HR01_0104)
        case(4) return (CG_HR01_0105)
        }
    case(177)
        switch( $diff_index ) {
        case(0) return (CG_HR02_0101)
        case(1) return (CG_HR02_0102)
        case(2) return (CG_HR02_0201)
        }
    case(178)
        switch( $diff_index ) {
        case(0) return (CG_HR03_0101)
        }
    case(192)
        switch( $diff_index ) {
        case(0) return (CG_GE01_0101)
        case(1) return (CG_GE01_0201)
        case(2) return (CG_GE01_0202)
        case(3) return (CG_GE01_0301)
        case(4) return (CG_GE01_0401)
        case(5) return (CG_GE01_0402)
        }
    case(193)
        switch( $diff_index ) {
        case(0) return (CG_GE03_0101)
        case(1) return (CG_GE03_0102)
        case(2) return (CG_GE03_0103)
        case(3) return (CG_GE03_0201)
        case(4) return (CG_GE03_0202)
        case(5) return (CG_GE03_0203)
        }
    case(194)
        switch( $diff_index ) {
        case(0) return (CG_GE04_0102)
        case(1) return (CG_GE04_0103)
        }
    case(195)
        switch( $diff_index ) {
        case(0) return (CG_GE05_0101)
        case(1) return (CG_GE05_0102)
        case(2) return (CG_GE05_0103)
        case(3) return (CG_GE05_0104)
        case(4) return (CG_GE05_0105)
        case(5) return (CG_GE05_0203)
        case(6) return (CG_GE05_0213)
        case(7) return (CG_GE05_0215)
        case(8) return (CG_GE05_0235)
        }
    case(196)
        switch( $diff_index ) {
        case(0) return (CG_GE06_0101)
        case(1) return (CG_GE06_0102)
        case(2) return (CG_GE06_0103)
        case(3) return (CG_GE06_0104)
        case(4) return (CG_GE06_0105)
        case(5) return (CG_GE06_0106)
        case(6) return (CG_GE06_0107)
        case(7) return (CG_GE06_0201)
        }
    case(197)
        switch( $diff_index ) {
        case(0) return (CG_GE16_0101)
        case(1) return (CG_GE16_0102)
        }
    case(198)
        switch( $diff_index ) {
        case(0) return (CG_GE07_0101)
        case(1) return (CG_GE07_0102)
        case(2) return (CG_GE07_0201)
        case(3) return (CG_GE07_0202)
        }
    case(199)
        switch( $diff_index ) {
        case(0) return (CG_GE08_0101)
        case(1) return (CG_GE08_0103)
        case(2) return (CG_GE08_0105)
        case(3) return (CG_GE08_0107)
        case(4) return (CG_GE08_0208)
        case(5) return (CG_GE08_0308)
        }
    case(200)
        switch( $diff_index ) {
        case(0) return (CG_GE09_0101)
        case(1) return (CG_GE09_0102)
        case(2) return (CG_GE09_0103)
        }
    case(201)
        switch( $diff_index ) {
        case(0) return (CG_GE10_0101)
        case(1) return (CG_GE10_0201)
        }
    case(202)
        switch( $diff_index ) {
        case(0) return (CG_GE11_0101)
        }
    case(203)
        switch( $diff_index ) {
        case(0) return (CG_GE12_0101)
        case(1) return (CG_GE12_0102)
        case(2) return (CG_GE12_0201)
        case(3) return (CG_GE12_0202)
        case(4) return (CG_GE12_0301)
        case(5) return (CG_GE12_0302)
        case(6) return (CG_GE12_0303)
        }
    case(204)
        switch( $diff_index ) {
        case(0) return (CG_GE13_0101)
        case(1) return (CG_GE13_0102)
        case(2) return (CG_GE13_0103)
        case(3) return (CG_GE13_0104)
        }
    case(205)
        switch( $diff_index ) {
        case(0) return (CG_GE14_0101)
        case(1) return (CG_GE14_0102)
        }
    case(206)
        switch( $diff_index ) {
        case(0) return (CG_GE15_0201)
        case(1) return (CG_GE15_0301)
        }
    }
    return ("")
}
