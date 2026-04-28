//===========================================================================
//!
//!    @file     _staffroll.ss
//!    @brief    スタッフロール制御
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

	#replace	<PCM_CH>				0		// ＥＤで使用する効果音チャンネル
	#replace	<PCM_CH2>				1		// ＥＤで使用する効果音チャンネル２
	#replace	<VOLUME_TYPE>			16		// ＥＤで使用する汎用ボリュームチャンネル
	
	#replace	<OBJ_MOVIE>				10		// ＥＤで使用するムービーオブジェクト
	#replace	<OBJ_BG_IMAGE>			11		// ＥＤで使用する背景オブジェクト
	#replace	<OBJ_STAFF_IMAGE>		12		// ＥＤで使用する画像オブジェクト
	
	#replace	<COUNTER>				1		// ＥＤで使用するカウンター
	
#inc_end

#z00

//---------------------------------------------------------------------------
// ＢＧＭ音量の値を補正したムービー音量を取得する
//---------------------------------------------------------------------------
command $$get_bgm_to_mov_volume
{
	property $volume
	
	// ムービーの音量に従いつつＢＧＭ音量として補正する
	// Gameexe.iniの設定に依存する
	//
	// #CONFIG.VOLUME.BGM = 100
	// #CONFIG.VOLUME.MOV = 60
	// 
	// movの1.6666倍がbgmボリューム
	$volume = (syscom.get_mov_volume * (100 * 1000 / 60)) / 1000
	
	if( $volume > 255 ) {
		$volume = 255
	}
	return ($volume)
}

//---------------------------------------------------------------------------
// 汎用ＥＤ
//---------------------------------------------------------------------------
command $$common_ed(property $type)
{
	property $omv_file : str
	
	// スピカ    > $type = 0
	// それ以外  > $type = 1
	
	@all_sound_stop(0)
	
	// タイトルを空文字にする
	set_title("")
	
	// ユーザー制御を不可能にする
	$$user_control_disabled
	
	// 遅延を抑えるため、ムービーを先読み
	if( $type == 0 ) { $omv_file = "anemoi_ed01" }
	else 			 { $omv_file = "anemoi_ed02" }
	
	back.object[<OBJ_MOVIE>].create_movie($omv_file, 0, 0, 0, ready_only = 1, auto_free = 0)
	
	// 遅延を抑えるため、ＢＧＭを先読み
	pcmch[<PCM_CH>].ready(bgm_name = "BGM82", loop = 0, volume_type = <VOLUME_TYPE>)
	
	// 汎用ボリューム設定
	syscom.set_sound_volume(<VOLUME_TYPE>, $$get_bgm_to_mov_volume)
	
	// 読み込みがすべて終わった段階で一度更新
	disp
	
	//---------------------------------------------------------------------------
	// スタッフロール開始
	pcmch[<PCM_CH>].resume
	back.object[<OBJ_MOVIE>].disp = 1
	back.object[<OBJ_MOVIE>].resume_movie
	
	counter[<COUNTER>].start_real
	
	wipe(0, 1500)
	
	input.clear
	while(1)
	{
		// ＥＤを見たことがある＋２秒以下の場合はスキップを無効にする
		if( @汎用ＥＤを見た == 1 && counter[<COUNTER>].get >= 2000 )
		{
			if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
			{
				break
			}
		}
		
		// 2:50 - 0:03
		if( counter[<COUNTER>].get >= 167000 )
		{
			break
		}
		
		input.next
		disp
	}
	
	@all_sound_stop(5000)
	@fade_w(6)
	@waitkey(1000)
	
	@汎用ＥＤを見た = 1
	
	bgmtable.set_listen_by_name(BGM82, 1)		// ＢＧＭフラグ(汎用ＥＤ)
	
	// ユーザー制御を可能にする
	$$user_control_enabled
}

//---------------------------------------------------------------------------
// エタニクルＥＤ
//---------------------------------------------------------------------------
command $$eternicle_ed
{
	property $i
	property $bg_cut
	property $staff_cut
	property $scroll_start_time
	property $scroll_time
	property $filename : str
	
	$bg_cut = 11				// 背景の画像カット数
	$staff_cut = 8				// スタッフロール画像のカット数
	$scroll_start_time = 3500	// スタッフロールのスクロール開始時間
	$scroll_time = 254000		// スクロール時間
	
	// タイトルを空文字にする
	set_title("")
	
	// ユーザー制御を不可能にする
	$$user_control_disabled
	
	//---------------------------------------------------------------------------
	// 遅延を抑えるため、オブジェクトとＢＧＭを先読み
	
	// 背景
	back.object[<OBJ_BG_IMAGE>].init
	back.object[<OBJ_BG_IMAGE>].child.resize($bg_cut)
	
	for( $i = 0, $i < $bg_cut, $i += 1 ) {
		switch( $i ) {
		case(0)		$filename = "ef_avan_bg02"
		case(1)		$filename = "ef_avan_bg01"
		case(2)		$filename = "cg_ge04_0103"
		case(3)		$filename = "cg_ge03_0103"
		case(4)		$filename = "cg_ge01_0202"
		case(5)		$filename = "cg_ge06_0102"
		case(6)		$filename = "cg_ge05_0103"
		case(7)		$filename = "bg703_02"
		case(8)		$filename = "ef_eternicle_menu"
		case(9)		$filename = "ef_eternicle_menu"
		case(10)	$filename = "ef_cutin_tenyeardiary"
		}
		back.object[<OBJ_BG_IMAGE>].child[$i].create($filename, 1)
		if( $i == 9 ) {
			back.object[<OBJ_BG_IMAGE>].child[$i].patno = 1
		}
		if( $i != 0 && $i != 1 ) {
			$$set_image_center_rep(back.object[<OBJ_BG_IMAGE>].child[$i])
			back.object[<OBJ_BG_IMAGE>].child[$i].set_center_rep(<SCREEN_CENTER_X>, <SCREEN_CENTER_Y>)
		}
		
		back.object[<OBJ_BG_IMAGE>].child[$i].tr = 0
		back.object[<OBJ_BG_IMAGE>].child[$i].tr_rep.resize(1)
		back.object[<OBJ_BG_IMAGE>].child[$i].tr_rep[0] = 255
	}
	
	// スタッフロール
	back.object[<OBJ_STAFF_IMAGE>].init
	back.object[<OBJ_STAFF_IMAGE>].layer = <LAYER_UI>
	back.object[<OBJ_STAFF_IMAGE>].child.resize($staff_cut)
	
	for( $i = 0, $i < $staff_cut, $i += 1 ) {
		// ファイルネームは = デフォルトネーム + 末尾数字２桁(言語バージョン)にしています
		back.object[<OBJ_STAFF_IMAGE>].child[$i].create("ef_staffroll_et" + math.tostr_zero(@check_lang, 2), 1)
		back.object[<OBJ_STAFF_IMAGE>].child[$i].patno = $i
		back.object[<OBJ_STAFF_IMAGE>].child[$i].y = $i * back.object[<OBJ_STAFF_IMAGE>].child[0].get_size_y
	}
	
	// 遅延を抑えるため、ＢＧＭを先読み
	pcmch[<PCM_CH>].ready(bgm_name = "BGM84B", loop = 0, volume_type = <VOLUME_TYPE>)
	
	// 汎用ボリューム設定
	syscom.set_sound_volume(<VOLUME_TYPE>, $$get_bgm_to_mov_volume)
	
	// 読み込みがすべて終わった段階で一度更新
	disp
	
	@bg(bg_siro, -1)
	wipe(0, 1500)
	
	//---------------------------------------------------------------------------
	// スタッフロール開始
	counter[<COUNTER>].start_real
	
	// オブジェクト／ＢＧＭ再生
	// 背景
	
	// 0:48
	front.object[<OBJ_BG_IMAGE>].disp = 1
	front.object[<OBJ_BG_IMAGE>].child[0].y = -968
	front.object[<OBJ_BG_IMAGE>].child[0].y_eve.set(               0, 80000,  47500, 0)
	front.object[<OBJ_BG_IMAGE>].child[0].tr_eve.set(            255,  6000,  47500, 0)
	front.object[<OBJ_BG_IMAGE>].child[0].tr_rep_eve[0].set(       0,  3000,  65000, 0)
	
	// 1:01
	front.object[<OBJ_BG_IMAGE>].child[1].y = -968
	front.object[<OBJ_BG_IMAGE>].child[1].y_eve.set(               0, 80000,  61000, 0)
	front.object[<OBJ_BG_IMAGE>].child[1].tr_eve.set(            255,  4000,  61000, 0)
	front.object[<OBJ_BG_IMAGE>].child[1].tr_rep_eve[0].set(       0,  5000,  76000, 0)
	
	// 1:30
	front.object[<OBJ_BG_IMAGE>].child[2].set_scale(1250, 1250)
	front.object[<OBJ_BG_IMAGE>].child[2].scale_x_eve.set(      1000, 20000,  90000, 0)
	front.object[<OBJ_BG_IMAGE>].child[2].scale_y_eve.set(      1000, 20000,  90000, 0)
	front.object[<OBJ_BG_IMAGE>].child[2].tr_eve.set(            192,  4000,  90000, 0)
	front.object[<OBJ_BG_IMAGE>].child[2].tr_rep_eve[0].set(       0,  4000, 104000, 0)
	
	// 1:44
	front.object[<OBJ_BG_IMAGE>].child[3].set_scale(1250, 1250)
	front.object[<OBJ_BG_IMAGE>].child[3].scale_x_eve.set(      1000, 20000, 104000, 0)
	front.object[<OBJ_BG_IMAGE>].child[3].scale_y_eve.set(      1000, 20000, 104000, 0)
	front.object[<OBJ_BG_IMAGE>].child[3].tr_eve.set(            192,  4000, 104000, 0)
	front.object[<OBJ_BG_IMAGE>].child[3].tr_rep_eve[0].set(       0,  7000, 118000, 0)
	
	// 2:08
	front.object[<OBJ_BG_IMAGE>].child[4].set_scale(1100, 1100)
	front.object[<OBJ_BG_IMAGE>].child[4].scale_x_eve.set(      1000,  8000, 128000, 2)
	front.object[<OBJ_BG_IMAGE>].child[4].scale_y_eve.set(      1000,  8000, 128000, 2)
	front.object[<OBJ_BG_IMAGE>].child[4].tr_eve.set(            192,  5000, 128000, 0)
	front.object[<OBJ_BG_IMAGE>].child[4].tr_rep_eve[0].set(       0,  4000, 131000, 1)
	
	// 2:15
	front.object[<OBJ_BG_IMAGE>].child[5].set_scale(1500, 1500)
	front.object[<OBJ_BG_IMAGE>].child[5].scale_x_eve.set(      1000, 35000, 135500, 0)
	front.object[<OBJ_BG_IMAGE>].child[5].scale_y_eve.set(      1000, 35000, 135500, 0)
	front.object[<OBJ_BG_IMAGE>].child[5].tr_eve.set(            170,  7000, 135500, 0)
	front.object[<OBJ_BG_IMAGE>].child[5].tr_rep_eve[0].set(       0,  8000, 157000, 0)
	
	// 2:58
	front.object[<OBJ_BG_IMAGE>].child[6].set_scale(1500, 1500)
	front.object[<OBJ_BG_IMAGE>].child[6].scale_x_eve.set(      1000, 35000, 178000, 0)
	front.object[<OBJ_BG_IMAGE>].child[6].scale_y_eve.set(      1000, 35000, 178000, 0)
	front.object[<OBJ_BG_IMAGE>].child[6].tr_eve.set(            128,  8000, 178000, 0)
	front.object[<OBJ_BG_IMAGE>].child[6].tr_rep_eve[0].set(       0,  5000, 190000, 0)
	
	// 3:16
	front.object[<OBJ_BG_IMAGE>].child[7].set_scale(1250, 1250)
	front.object[<OBJ_BG_IMAGE>].child[7].scale_x_eve.set(      1000, 20000, 197000, 0)
	front.object[<OBJ_BG_IMAGE>].child[7].scale_y_eve.set(      1000, 20000, 197000, 0)
	front.object[<OBJ_BG_IMAGE>].child[7].tr_eve.set(            128,  4000, 197000, 0)
	front.object[<OBJ_BG_IMAGE>].child[7].tr_rep_eve[0].set(       0,  4000, 211000, 0)
	
	// 3:31
	front.object[<OBJ_BG_IMAGE>].child[8].set_scale(1250, 1250)
	front.object[<OBJ_BG_IMAGE>].child[8].y = -130
	front.object[<OBJ_BG_IMAGE>].child[8].y_eve.set(               0, 15000, 211000, 0)
	front.object[<OBJ_BG_IMAGE>].child[8].tr_eve.set(            160,  4000, 211000, 0)
	front.object[<OBJ_BG_IMAGE>].child[8].tr_rep_eve[0].set(       0,  5000, 225000, 0)
	
	// 3:45
	front.object[<OBJ_BG_IMAGE>].child[9].set_scale(1500, 1500)
	front.object[<OBJ_BG_IMAGE>].child[9].x = 0
	front.object[<OBJ_BG_IMAGE>].child[9].y = 270
	front.object[<OBJ_BG_IMAGE>].child[9].x_eve.set(             480, 30000, 224000, 0)
	front.object[<OBJ_BG_IMAGE>].child[9].tr_eve.set(            160,  4000, 224000, 0)
	front.object[<OBJ_BG_IMAGE>].child[9].tr_rep_eve[0].set(       0, 10000, 237000, 0)
	
	// 4:01
	front.object[<OBJ_BG_IMAGE>].child[10].set_scale(1050, 1050)
	front.object[<OBJ_BG_IMAGE>].child[10].scale_x_eve.set(      1000,  4000, 254000, 0)
	front.object[<OBJ_BG_IMAGE>].child[10].scale_y_eve.set(      1000,  4000, 254000, 0)
	front.object[<OBJ_BG_IMAGE>].child[10].tr_eve.set(            255,  4000, 253000, 0)
	front.object[<OBJ_BG_IMAGE>].child[10].tr_rep_eve[0].set(       0,  5000, 265000, 0)
	
	// スタッフロール
	front.object[<OBJ_STAFF_IMAGE>].y = <SCREEN_HEIGHT>
	front.object[<OBJ_STAFF_IMAGE>].y_eve.set(-front.object[<OBJ_STAFF_IMAGE>].child[0].get_size_y * $staff_cut + <SCREEN_HEIGHT>, $scroll_time, $scroll_start_time, 0)
	front.object[<OBJ_STAFF_IMAGE>].disp = 1
	
	// ＢＧＭ
	pcmch[<PCM_CH>].resume
	
	input.clear
	while(1)
	{
		// ＥＤを見たことがある＋２秒以下の場合はスキップを無効にする
		if( @エタニクルＥＤを見た == 1 && counter[<COUNTER>].get >= 2000 )
		{
			if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
			{
				break
			}
		}
		
		if( counter[<COUNTER>].get >= $scroll_time + 3000 )
		{
			break
		}
		
		input.next
		disp
	}
	
	@waitkey(3000)
	@all_sound_stop(5000)
	@fade_w(7)
	
	@エタニクルＥＤを見た = 1
	
	// ユーザー制御を可能にする
	$$user_control_enabled
}

//---------------------------------------------------------------------------
// グランドＥＤ
//---------------------------------------------------------------------------
command $$grand_ed
{
	property $bgm_play
	
	@all_sound_stop(0)
	
	// タイトルを空文字にする
	set_title("")
	
	// ユーザー制御を不可能にする
	$$user_control_disabled
	
	// 遅延を抑えるため、ムービーを先読み
	back.object[<OBJ_MOVIE>].create_movie("anemoi_ed03", 0, 0, 0, ready_only = 1, auto_free = 0)
	
	// 遅延を抑えるため、ＢＧＭ／効果音を先読み
	pcmch[<PCM_CH>].ready(bgm_name = "BGM87", loop = 0, volume_type = <VOLUME_TYPE>)
	pcmch[<PCM_CH2>].ready("ANB_outdoor_wheatfield_LOOP", loop = 0, volume_type = 2)
	
	// 汎用ボリューム設定
	syscom.set_sound_volume(<VOLUME_TYPE>, $$get_bgm_to_mov_volume)
	
	// 読み込みがすべて終わった段階で一度更新
	disp
	
	//---------------------------------------------------------------------------
	// スタッフロール開始
	pcmch[<PCM_CH2>].resume(3000)
	back.object[<OBJ_MOVIE>].resume_movie
	back.object[<OBJ_MOVIE>].disp = 1
	
	counter[<COUNTER>].start_real
	
	wipe(0, 1500)
	
	input.clear
	while(1)
	{
		// 15秒後にBGMスタート
		if( $bgm_play == 0 && counter[<COUNTER>].get >= 10000 ) {
			$bgm_play = 1
			pcmch[<PCM_CH2>].stop(3000)
		}
		if( $bgm_play == 1 && counter[<COUNTER>].get >= 15000 ) {
			$bgm_play = 2
			pcmch[<PCM_CH>].resume
		}
		
		// ＥＤを見たことがある＋２秒以下の場合はスキップを無効にする
		if( @グランドＥＤを見た == 1 && counter[<COUNTER>].get >= 2000 )
		{
			if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
			{
				break
			}
		}
		
		// 6:51 - 0:03
		if( counter[<COUNTER>].get >= 427000 )
		{
			break
		}
		
		input.next
		disp
	}
	
	@all_sound_stop(5000)
	@fade_w(6)
	
	@グランドＥＤを見た = 1
	bgmtable.set_listen_by_name(BGM87, 1)		// ＢＧＭフラグ(グランドＥＤ)
	
	// ユーザー制御を可能にする
	$$user_control_enabled
}


//---------------------------------------------------------------------------
// 淡雪0833ＥＤ
//---------------------------------------------------------------------------
command $$hi0833_ed
{
	property $i
	property $bg_cut
	property $staff_cut
	property $scroll_start_time
	property $scroll_time
	property $filename : str
	
	$bg_cut = 9					// 背景の画像カット数
	$staff_cut = 10				// スタッフロール画像のカット数
	$scroll_start_time = 2000	// スタッフロールのスクロール開始時間
	$scroll_time = 153000		// スクロール時間
	
	// タイトルを空文字にする
	set_title("")
	
	// ユーザー制御を不可能にする
	$$user_control_disabled
	
	//---------------------------------------------------------------------------
	// 遅延を抑えるため、オブジェクトとＢＧＭを先読み
	
	// 背景
	back.object[<OBJ_BG_IMAGE>].init
	back.object[<OBJ_BG_IMAGE>].disp = 1
	back.object[<OBJ_BG_IMAGE>].child.resize($bg_cut)
	
	for( $i = 0, $i < $bg_cut, $i += 1 ) {
		switch( $i ) {
		case(0)		$filename = "bg301_01"
		case(1)		$filename = "bg303_01"
		case(2)		$filename = "bg305_01"
		case(3)		$filename = "bg014_01"
		case(4)		$filename = "bg018_01"
		case(5)		$filename = "bg306_01"
		case(6)		$filename = "bg307_01"
		case(7)		$filename = "bg308_01"
		case(8)		$filename = "bg_siro"
		}
		back.object[<OBJ_BG_IMAGE>].child[$i].create($filename, 1)
		back.object[<OBJ_BG_IMAGE>].child[$i].set_scale(1500, 1500)
		back.object[<OBJ_BG_IMAGE>].child[$i].set_center_rep(<SCREEN_CENTER_X>, <SCREEN_CENTER_Y>)
		if( $i != 8 ) {
			back.object[<OBJ_BG_IMAGE>].child[$i].mono = 192
		}
		back.object[<OBJ_BG_IMAGE>].child[$i].tr = 0
		back.object[<OBJ_BG_IMAGE>].child[$i].tr_rep.resize(1)
		back.object[<OBJ_BG_IMAGE>].child[$i].tr_rep[0] = 255
	}
	
	// スタッフロール
	back.object[<OBJ_STAFF_IMAGE>].init
	back.object[<OBJ_STAFF_IMAGE>].disp = 1
	back.object[<OBJ_STAFF_IMAGE>].child.resize($staff_cut)
	
	for( $i = 0, $i < $staff_cut, $i += 1 ) {
		// ファイルネームは = デフォルトネーム + 末尾数字２桁(言語バージョン)にしています
		back.object[<OBJ_STAFF_IMAGE>].child[$i].create("ef_staffroll_hi" + math.tostr_zero(@check_lang, 2), 1)
		back.object[<OBJ_STAFF_IMAGE>].child[$i].patno = $i
		back.object[<OBJ_STAFF_IMAGE>].child[$i].y = $i * back.object[<OBJ_STAFF_IMAGE>].child[0].get_size_y
	}
	
	// ＢＧＭ
	bgm.ready(BGM31)
	
	// 読み込みがすべて終わった段階で一度更新
	disp
	
	//---------------------------------------------------------------------------
	// スタッフロール開始
	counter[<COUNTER>].start_real
	
	// オブジェクト／ＢＧＭ再生
	// 背景
	for( $i = 0, $i < $bg_cut, $i += 1 ) {
		if( $i % 2 ) {
			back.object[<OBJ_BG_IMAGE>].child[$i].x = 480
			back.object[<OBJ_BG_IMAGE>].child[$i].x_eve.set(-480, 50000, $i * 19500, 0)
		} else {
			back.object[<OBJ_BG_IMAGE>].child[$i].x = -480
			back.object[<OBJ_BG_IMAGE>].child[$i].x_eve.set(480, 50000, $i * 19500, 0)
		}
		back.object[<OBJ_BG_IMAGE>].child[$i].tr_eve.set(255, 3000, $i * 19500, 0)
		back.object[<OBJ_BG_IMAGE>].child[$i].tr_rep_eve[0].set(0, 3000, ($i + 1) * 19500, 0)
	}
	
	// スタッフロール
	back.object[<OBJ_STAFF_IMAGE>].y = <SCREEN_HEIGHT>
	back.object[<OBJ_STAFF_IMAGE>].y_eve.set(-back.object[<OBJ_STAFF_IMAGE>].child[0].get_size_y * ($staff_cut - 1), $scroll_time, $scroll_start_time, 0)
	
	// ＢＧＭ
	bgm.resume
	
	wipe(0, 1500)
	
	input.clear
	while(1)
	{
		// ＥＤを見たことがある＋２秒以下の場合はスキップを無効にする
		if( @淡雪0833ＥＤを見た == 1 && counter[<COUNTER>].get >= 2000 )
		{
			if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
			{
				break
			}
		}
		
		if( counter[<COUNTER>].get >= $scroll_time )
		{
			break
		}
		
		input.next
		disp
	}
	
	@bgm_stop(8000)
	@fade_w(7)
	@waitkey(1000)
	
	@淡雪0833ＥＤを見た = 1
	
	// ユーザー制御を可能にする
	$$user_control_enabled
}

//---------------------------------------------------------------------------
// 淡雪2816ＥＤ制御開始
//---------------------------------------------------------------------------
command $$hi2816_ed_control(property $flag)
{
	property $i
	property $len
	
	if( $flag )
	{
		// セーブポイントをオフにする
		script.set_auto_savepoint_off
		
		// 各種ユーザー制御を禁止する
		syscom.set_hide_mwnd_enable_flag(0)		// 「ウィンドウを消す」の設定を不可に
		script.set_msg_back_disable				// 一時的にメッセージバックに入るのを禁止する
		syscom.set_syscom_menu_disable			// システムコマンドメニューを禁止
		script.set_shortcut_disable				// ショートカット機能を禁止
		script.set_mouse_disp_off				// 一時的にマウスカーソルを非表示にする
		syscom.set_mwnd_btn_touch_disable		// メッセージウィンドウのボタンを触れなくする
		script.set_end_msg_by_key_disable		// 一時的に「クリックすると文章を最後まで表示する」機能を無効にする
		
		if( @淡雪2816ＥＤを見た == 0 ) {
			script.set_ctrl_skip_disable		// 一時的に早送りを禁止する（Ctrl キーを含む）
		}
		
		// メッセージウィンドウボタンを非表示にする
		$len = front.mwnd[get_mwnd].button.get_size
		for( $i = 0, $i < $len, $i += 1 )
		{
			front.mwnd[get_mwnd].button[$i].disp = 0
		}
		
		// 一時的にオートモードにする
		script.start_auto_mode
		
		// 一時的にメッセージ速度を変更する（小さいほど速い）
		script.set_message_speed(45)
	}
	else
	{
		// 各種ユーザー制御の禁止を解除する
		syscom.set_hide_mwnd_enable_flag(1)		// 「ウィンドウを消す」の設定を可に
		script.set_msg_back_enable				// 一時的にメッセージバック禁止を解除
		syscom.set_syscom_menu_enable			// システムコマンドメニュー禁止を解除
		script.set_shortcut_enable				// ショートカット機能禁止を解除
		script.set_mouse_disp_on				// 一時的にマウスカーソル非表示を解除
		script.set_ctrl_skip_enable				// 一時的に早送り禁止を解除（Ctrl キーを含む）
		syscom.set_mwnd_btn_touch_enable		// メッセージウィンドウのボタンの触れなくするを解除する
		script.set_end_msg_by_key_enable		// 一時的に「クリックすると文章を最後まで表示する」機能を有効にする
		
		// メッセージウィンドウボタンを表示する
		$len = front.mwnd[get_mwnd].button.get_size
		for( $i = 0, $i < $len, $i += 1 )
		{
			front.mwnd[get_mwnd].button[$i].disp = 1
		}
		
		// オートモードを解除する
		script.end_auto_mode
		
		// 一時的にメッセージ速度を変更するを解除する
		script.set_message_speed_default
		
		// セーブポイントをオフにする
		script.set_auto_savepoint_on
		
		@淡雪2816ＥＤを見た = 1
	}
}
