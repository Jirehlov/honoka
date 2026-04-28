//===========================================================================
//!
//!    @file     ___mng_urace_flow_paddock.ss
//!    @brief    ＵＭＡレース／パドック画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レース前の参加者などの詳細画面
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景				0
	#replace	@ボタン_レース開始				1
	#replace	@ボタン_ＵＭＡ詳細				2
	#define		@ボタン_ＵＭＡ詳細最大			(@ボタン_ＵＭＡ詳細 + <URACE_ENTRY_MAX>)
	
	// 変数
	#property	$select_btn		// 選択したボタン
	#property	$player_index	// プレイヤーインデックス
	
	// deb
	#property	$vote1_list : intlist
	#property	$vote2_list : intlist
	#property	$vote3_list : intlist
	#property	$vote4_list : intlist
	#property	$vote5_list : intlist
	#property	$vote6_list : intlist
	#property	$vote_order : intlist
	
#inc_end


//===========================================================================
// ＵＭＡパドックフロー
//===========================================================================
#z00

@bgm(bgm10)

@ＵＭＡレースシーン設定

if( @ＵＭＡレース_チュートリアル進行度 != 2 ) {
	$$create_vote_list	// deb
}
$$create_scene_object(back)			// シーンオブジェクトを作成する
$$set_joypad_navigation(back)		// パッド入力の遷移を設定する
$$show_scene_object(back)			// シーンオブジェクトを表示する

// チュートリアルシナリオ
if( @ＵＭＡレース_チュートリアル進行度 == 2 ) {
	@ＵＭＡレースチュートリアルシナリオ(12)
}

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_NORMAL>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_NORMAL>)
	
	// レース開始ボタンが押された場合はレース画面へ
	if( $select_btn == @ボタン_レース開始 )
	{
		$$hide_scene_object(front)			// シーンオブジェクトを非表示にする
		
		break
	}
	
	// ＵＭＡ詳細ボタンが押された場合はＵＭＡ詳細画へ
	elseif( $select_btn >= @ボタン_ＵＭＡ詳細 )
	{
		// プレイヤー詳細ボタンは編成へ
		if( $select_btn - @ボタン_ＵＭＡ詳細 == $player_index )
		{
			// 全てのオブジェクトのワイプコピーフラグをオフする
			$$set_front_wipe_copy_all(0)
			
			// デッキ編成フローへ
			farcall("___mng_urace_flow_edit_deck", 0, 1)
			
			goto #z00
		}
		else
		{
			// ＵＭＡ詳細フローへ
			farcall(___mng_urace_flow_entry_uma_info, 0, $select_btn - @ボタン_ＵＭＡ詳細)
			
			$$set_joypad_focus_button($select_btn)	// 選択されたボタンをジョイパッドで選択中のボタンに再設定する
			$$update_joypad_focus_button(front)		// 選択されたボタンの描画を更新する
		}
	}
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_NORMAL>)
	}
	
	// 何も押していないときは画面の更新のみ
	else
	{
		input.next		// 入力の更新
		disp			// 画面の更新
	}
}

// 全てのオブジェクトのワイプコピーフラグをオフする
$$set_front_wipe_copy_all(0)

@bgm_stop

@ＵＭＡレースシーン設定解除

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $len
	property $owner_id
	property $filename : str
	property $pos_x
	property $pos_y
	property $base_x
	property $base_y
	property $offset_y
	
	$len = $$get_entry_owner_num
	
	// 背景
	$stage.object[@オブジェクト_背景].create(__mng_ur_paddock_bg, 1)
	$stage.object[@オブジェクト_背景].child.resize(3)
	
	// 出走者枠
	$base_x = 779
	$base_y = 32
	$offset_y = 148
	
	$stage.object[@オブジェクト_背景].child[2].disp = 1
	$stage.object[@オブジェクト_背景].child[2].child.resize($len)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$create_lane_info_object($stage.object[@オブジェクト_背景].child[2].child[$i], $i, $base_x, $base_y + $offset_y * $i)
	}
	
	// 出走ＵＭＡボタン
	$base_x = 1719
	$base_y = 45
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$owner_id = $$get_entry_owner_id($i)
		
		// 座標設定
		$pos_x = $base_x
		$pos_y = $base_y + $offset_y * $i
		
		// ファイル名設定
		if( $owner_id == <URACE_PLAYER_OWNER_ID> ) {
			$filename = __mng_ur_paddock_edit_btn
			$player_index = $i
		} elseif( $owner_id == $$get_db_race_entry_rival($$get_entry_race_id) ) {
			$filename = __mng_ur_result_uma_info_btn2
		} else {
			$filename = __mng_ur_result_uma_info_btn3
		}
		
		// 作成
		$$create_ui_button($stage.object[@ボタン_ＵＭＡ詳細 + $i], $filename, $pos_x, $pos_y, @ボタン_ＵＭＡ詳細 + $i, <URACE_BTN_GROUP_NORMAL>, 1)
	}
	
	// レース開始ボタン
	$$create_ui_button($stage.object[@ボタン_レース開始], __mng_ur_paddock_next_btn, 1348, 916, @ボタン_レース開始, <URACE_BTN_GROUP_NORMAL>, 1)
	
	
	//-------------
	property $race_id
	property $uma_id
	property $entry_num
	property $size_x
	property $filename : str
	
	$race_id = $$get_entry_race_id
	$entry_num = $$get_entry_owner_num
	
	
	// レース情報
	$stage.object[@オブジェクト_背景].child[0].disp = 1
	$stage.object[@オブジェクト_背景].child[0].child.resize(7)
	
	// レース情報／メダル
	$stage.object[@オブジェクト_背景].child[0].child[0].create(_mng_ur_race_logo + math.tostr_zero($race_id, 2), 1, 110, 63)
	$stage.object[@オブジェクト_背景].child[0].child[0].set_scale(450, 450)
	
	// レース情報／開催日
	$stage.object[@オブジェクト_背景].child[0].child[1].create(__mng_ur_paddock_race_info_bg, 1, 432, 136)
	$stage.object[@オブジェクト_背景].child[0].child[2].create_string($$get_urace_race_date_text($$get_db_race_month($race_id), $$get_db_race_day($race_id)), 1, 543, 133)
	$stage.object[@オブジェクト_背景].child[0].child[2].set_string_param(40, 0, 0, 10, 50, 0, 0)
	
	// レース情報／距離
	$stage.object[@オブジェクト_背景].child[0].child[3].create(__mng_ur_paddock_race_info_bg, 1, 432, 194, 1)
	$stage.object[@オブジェクト_背景].child[0].child[4].create_string($$get_urace_race_distance_text($$get_db_race_distance($race_id)), 1, 543, 192)
	$stage.object[@オブジェクト_背景].child[0].child[4].set_string_param(40, 0, 0, 10, 50, 0, 0)
	
	// レース情報／地形タイプ
	$stage.object[@オブジェクト_背景].child[0].child[5].create(__mng_ur_paddock_race_info_bg, 1, 432, 256, 2)
	$stage.object[@オブジェクト_背景].child[0].child[6].create_string($$get_urace_race_ground_type_text($$get_db_race_ground_type($race_id)), 1, 543, 253)
	$stage.object[@オブジェクト_背景].child[0].child[6].set_string_param(40, 0, 0, 10, 50, 0, 0)
	
	// ウォーミングアップ
	mask[1].create(__mng_ur_paddock_practice_mask)
	
	$stage.object[@オブジェクト_背景].child[1].create(_mng_ur_paddock_practice_bg, 1, 40, 298)
	$stage.object[@オブジェクト_背景].child[1].mask_no = 1
	$stage.object[@オブジェクト_背景].child[1].child.resize(1 + $entry_num + 1)
	
	// ウォーミングアップ／背景
	$$create_urace_race_base_bg($stage.object[@オブジェクト_背景].child[1].child[0], $race_id)
	$stage.object[@オブジェクト_背景].child[1].child[0].y = -280
;	$stage.object[@オブジェクト_背景].child[1].child[0].set_clip(1, 41, 299, 679, 860)
	
	$size_x = $stage.object[@オブジェクト_背景].child[1].child[0].child[0].get_size_x
	$stage.object[@オブジェクト_背景].child[1].child[0].x_eve.loop(0, -$size_x * 2, 45000, 0, 0)
	
	$stage.object[@オブジェクト_背景].child[1].child[0].child.resize(3 + 3)
	for( $i = 0, $i < 3, $i += 1 )
	{
		$stage.object[@オブジェクト_背景].child[1].child[0].child[3 + $i].create(_mng_ur_race_bg_line, 1, $size_x * $i, 0, 1)
		$stage.object[@オブジェクト_背景].child[1].child[0].child[3 + $i].scale_y = 650
		$stage.object[@オブジェクト_背景].child[1].child[0].child[3 + $i].y = 440
	}
	
	// ウォーミングアップ／ＵＭＡチップ
	for( $i = 0, $i < $entry_num, $i += 1 )
	{
		$stage.object[@オブジェクト_背景].child[1].child[1 + $i].disp = 1
		$stage.object[@オブジェクト_背景].child[1].child[1 + $i].child.resize(2)
;		$stage.object[@オブジェクト_背景].child[1].child[1 + $i].set_clip(1, 41, 299, 679, 860)
		$stage.object[@オブジェクト_背景].child[1].child[1 + $i].set_pos(100, 140 + $i * 110)
		$stage.object[@オブジェクト_背景].child[1].child[1 + $i].x_eve.loop(math.rand(-300, -100), math.rand(800, 1000), math.rand(10000, 20000), math.rand(0, 2000), 0)
		
		$uma_id = $$get_uma_id($$get_entry_owner_id($i), $$get_entry_uma_index($i))
		
		$$create_uma_tip_object($stage.object[@オブジェクト_背景].child[1].child[1 + $i].child[1], $uma_id, 0, 70)
		$$play_uma_tip_move_anim($stage.object[@オブジェクト_背景].child[1].child[1 + $i].child[1])
		
		if( $$get_db_race_ground_type($$get_entry_race_id) != <URACE_GROUND_TYPE_SURFACE> )
		{
			// 地形が水面でない場合は影を作成する
			$stage.object[@オブジェクト_背景].child[1].child[1 + $i].child[0].create(urace_race_tip_shadow, 1, -110, 20)
		}
	}
	
	// ウォーミングアップ／テキスト
	$stage.object[@オブジェクト_背景].child[1].child[1 + $entry_num].create(_mng_ur_paddock_practice_text, 1, 10, 512)
	$stage.object[@オブジェクト_背景].child[1].child[1 + $entry_num].patno_eve.loop(0, 3, 2500, 0, 0)
	
	//-------------
}

// 各レーン(ＵＭＡ、オーナー)詳細オブジェクトを作成する
command $$create_lane_info_object(property $obj : object, property $index, property $x, property $y)
{
	property $i
	property $len
	property $owner_id
	property $uma_index
	property $patno
	
	$owner_id = $$get_entry_owner_id($index)
	$uma_index = $$get_entry_uma_index($index)
	
	// 背景
	if( $owner_id == <URACE_PLAYER_OWNER_ID> ) {
		$patno = 0
	} elseif( $owner_id == $$get_db_race_entry_rival($$get_entry_race_id) ) {
		$patno = 1
	} else {
		$patno = 2
	}
	
	$obj.create(__mng_ur_paddock_lane_bg, 1, $x, $y, $patno)
	$obj.child.resize(6)
	
	// 着順
	$obj.child[0].create(__mng_ur_paddock_lane_order_number, 1, 36, 47, $index)
	
	// オーナーサムネイル
	$obj.child[1].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($owner_id), 2), 1, 95, 5)
	
	// オーナー称号
	$obj.child[2].create_string($$get_db_owner_title($owner_id), 1, 294, 30)
	$obj.child[2].set_string_param(20, 0, 0, 12, 0, 0, 0)
	
	// オーナー名
	$obj.child[3].create_string($$get_db_owner_name($owner_id), 1, 294, 63)
	$obj.child[3].set_string_param(40, 0, 0, 6, 0, 0, 0)
	
	if( @ＵＭＡレース_チュートリアル進行度 == 2 ) {
		return
	}
	
	// 人気（数字）
	$obj.child[4].create(__mng_ur_paddock_lane_favorite_number, 1, 600, 31)
	$obj.child[4].patno = $$get_vote_order($index) - 1
	
	// 人気
	$obj.child[5].disp = 1
	switch( $index ) {
	case(0)
		$len = $vote1_list.get_size
		$obj.child[5].child.resize($len)
		for( $i = 0, $i < $len, $i += 1 ) {
			$obj.child[5].child[$i].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($vote1_list[$i]), 2), 1, 579 + 60 * $i, 70)
			$obj.child[5].child[$i].set_scale(350, 350)
		}
	case(1)
		$len = $vote2_list.get_size
		$obj.child[5].child.resize($len)
		for( $i = 0, $i < $len, $i += 1 ) {
			$obj.child[5].child[$i].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($vote2_list[$i]), 2), 1, 579 + 60 * $i, 70)
			$obj.child[5].child[$i].set_scale(350, 350)
		}
	case(2)
		$len = $vote3_list.get_size
		$obj.child[5].child.resize($len)
		for( $i = 0, $i < $len, $i += 1 ) {
			$obj.child[5].child[$i].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($vote3_list[$i]), 2), 1, 579 + 60 * $i, 70)
			$obj.child[5].child[$i].set_scale(350, 350)
		}
	case(3)
		$len = $vote4_list.get_size
		$obj.child[5].child.resize($len)
		for( $i = 0, $i < $len, $i += 1 ) {
			$obj.child[5].child[$i].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($vote4_list[$i]), 2), 1, 579 + 60 * $i, 70)
			$obj.child[5].child[$i].set_scale(350, 350)
		}
	case(4)
		$len = $vote5_list.get_size
		$obj.child[5].child.resize($len)
		for( $i = 0, $i < $len, $i += 1 ) {
			$obj.child[5].child[$i].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($vote5_list[$i]), 2), 1, 579 + 60 * $i, 70)
			$obj.child[5].child[$i].set_scale(350, 350)
		}
	case(5)
		$len = $vote6_list.get_size
		$obj.child[5].child.resize($len)
		for( $i = 0, $i < $len, $i += 1 ) {
			$obj.child[5].child[$i].create(__mng_ur_result_owner_icon + math.tostr_zero($$get_db_owner_image_no($vote6_list[$i]), 2), 1, 579 + 60 * $i, 70)
			$obj.child[5].child[$i].set_scale(350, 350)
		}
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	// ワイプ
	wipe(0, 250, wait=1)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	// 全てのオブジェクトのワイプコピーフラグをオフする
	$$set_front_wipe_copy_all(0)
	
	// ワイプ
	wipe(0, 250, wait=1)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	property $i
	property $len
	
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_レース開始)
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_up    = @ボタン_ＵＭＡ詳細 + $i - 1
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_down  = @ボタン_ＵＭＡ詳細 + $i + 1
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_left  = -1
		$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_right = -1
		
		if( $i == 0 ) {
			$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_up = @ボタン_レース開始
		}
		elseif( $i == $len - 1 ) {
			$stage.object[@ボタン_ＵＭＡ詳細 + $i].joypad_down = @ボタン_レース開始
		}
	}
	
	$stage.object[@ボタン_レース開始].joypad_up    = @ボタン_ＵＭＡ詳細 + $len - 1
	$stage.object[@ボタン_レース開始].joypad_down  = @ボタン_ＵＭＡ詳細
	$stage.object[@ボタン_レース開始].joypad_left  = -1
	$stage.object[@ボタン_レース開始].joypad_right = -1
}

//---------------------------------------------------------------------------
// deb 人気を作る
//---------------------------------------------------------------------------
command $$create_vote_list
{
	property $i
	property $j
	property $flag
	property $vote_chara_list : intlist
	property $param_list : intlist
	property $rand
	
	for( $i = <URACE_PLAYER_OWNER_ID>, $i <= $$get_db_owner_max, $i += 1 )
	{
		$flag = 0
		
		for( $j = 0, $j < <URACE_ENTRY_MAX>, $j += 1 )
		{
			if( $i == $$get_entry_owner_id($j) ) {
				$flag = 1
			}
		}
		
		if( $flag == 0 ) {
			$vote_chara_list.resize($vote_chara_list.get_size + 1)
			$vote_chara_list[$vote_chara_list.get_size - 1] = $i
		}
	}
	
	$param_list.resize(<URACE_ENTRY_MAX>)
	for( $i = 0, $i < <URACE_ENTRY_MAX>, $i += 1 )
	{
		$param_list[$i] = $$get_uma_total_param($$get_entry_owner_id($i), $$get_entry_uma_index($i))
	}
	
	$vote1_list.init
	$vote2_list.init
	$vote3_list.init
	$vote4_list.init
	$vote5_list.init
	$vote6_list.init
	
	for( $i = 0, $i < $vote_chara_list.get_size - 1, $i += 1 )
	{
		$rand = $$mng_rand(0, $param_list[0] + $param_list[1] + $param_list[2] + $param_list[3] + $param_list[4] + $param_list[5])
		
		if( $rand < $param_list[0] ) {
			$vote1_list.resize($vote1_list.get_size + 1)
			$vote1_list[$vote1_list.get_size - 1] = $vote_chara_list[$i]
		}
		elseif( $rand < $param_list[0] + $param_list[1] ) {
			$vote2_list.resize($vote2_list.get_size + 1)
			$vote2_list[$vote2_list.get_size - 1] = $vote_chara_list[$i]
		}
		elseif( $rand < $param_list[0] + $param_list[1] + $param_list[2] ) {
			$vote3_list.resize($vote3_list.get_size + 1)
			$vote3_list[$vote3_list.get_size - 1] = $vote_chara_list[$i]
		}
		elseif( $rand < $param_list[0] + $param_list[1] + $param_list[2] + $param_list[3] ) {
			$vote4_list.resize($vote4_list.get_size + 1)
			$vote4_list[$vote4_list.get_size - 1] = $vote_chara_list[$i]
		}
		elseif( $rand < $param_list[0] + $param_list[1] + $param_list[2] + $param_list[3] + $param_list[4] ) {
			$vote5_list.resize($vote5_list.get_size + 1)
			$vote5_list[$vote5_list.get_size - 1] = $vote_chara_list[$i]
		}
		else {
			$vote6_list.resize($vote6_list.get_size + 1)
			$vote6_list[$vote6_list.get_size - 1] = $vote_chara_list[$i]
		}
	}
	
	// 人気順
	property $len
	property $size : intlist
	property $index : intlist
	property $tmp
	
	$len = $$get_entry_owner_num
	
	$size.resize($len)
	$size.sets(0, $vote1_list.get_size, $vote2_list.get_size, $vote3_list.get_size, $vote4_list.get_size, $vote5_list.get_size, $vote6_list.get_size)
	
	$index.resize($len)
	$index.sets(0, 0, 1, 2, 3, 4, 5)
	
	$vote_order.resize($len)
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		for( $j = $len - 1, $j > $i, $j -= 1 )
		{
			if( $size[$j] > $size[$j - 1] )
			{
				$tmp = $size[$j]
				$size[$j] = $size[$j - 1]
				$size[$j - 1] = $tmp
				
				$tmp = $index[$j]
				$index[$j] = $index[$j - 1]
				$index[$j - 1] = $tmp
			}
		}
	}
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$vote_order[$i] = $index[$i]
	}
}

command $$get_vote_order(property $index) : int
{
	property $i
	property $len
	
	$len = $$get_entry_owner_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $vote_order[$i] == $index ) {
			return ($i + 1)
		}
	}
}