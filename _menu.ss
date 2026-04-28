//===========================================================================
//!
//!    @file     _menu.ss
//!    @brief    タイトルメニューシーン(アプリケーション側)
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レイアウトなどアプリケーションごとに挙動を調整する必要がある処理
//!
//===========================================================================

#inc_start
	
	// オブジェクト
	#replace	@イメージ_空背景			0
	#replace	@イメージ_ブランドロゴ		1
	#replace	@イメージ_背景キャラなし	2
	#replace	@イメージ_背景キャラあり	3
	#replace	@イメージ_タイトルロゴ		4
	#replace	@イメージ_コピーライト		5
	#replace	@イメージ_フィルター		6
	#replace	@パーティクル_キャラ表示	7
	#replace	@パーティクル_空全体		8
	#replace	@イメージ_ボタン背景		9
	//@ボタン_メニュー_最初から 			11 ～
	//@ボタン_メニュー_別ルートから始める３	20
	#replace	@ムービー_塵_空				21
	#replace	@ムービー_塵_遠				22
	#replace	@ムービー_塵_近				23
	#replace	@ムービー_風_最初			24
	#replace	@ムービー_風上段_ループ		25
	#replace	@ムービー_風下段_ループ		26
	#replace	@イメージ_フェード			30
	
	// 変数
	#property	$hit_button_old				// 前回当たっていたボタン番号
	
#inc_end

#z00

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_menu_scene_object(property $stage : stage)
{
	$$create_ui_image($stage.object[0], _menu_bg01, 0, 0)
	$$create_ui_image($stage.object[2], _menu_bg01, 0, 0)
	$$create_ui_image($stage.object[3], _menu_bg02, 0, 0)
	$$create_ui_image($stage.object[4], _menu_title_logo, 703, 0)
	$$create_ui_image($stage.object[5], _menu_logo, 840, 1021)
	$$create_ui_image($stage.object[9], _menu_btn_bg, 0, 818)
	$$create_ui_button($stage.object[@ボタン_メニュー_最初から], _menu_start_btn, 153, 949, @ボタン_メニュー_最初から, <OBJBTN_GROUP_NO_SELECT>, 0)
	$$create_ui_button($stage.object[@ボタン_メニュー_別ルートから始める１], _menu_route1_btn, 355, 949, @ボタン_メニュー_別ルートから始める１, <OBJBTN_GROUP_NO_SELECT>, 0)
	$$create_ui_button($stage.object[@ボタン_メニュー_別ルートから始める２], _menu_route2_btn, 557, 949, @ボタン_メニュー_別ルートから始める２, <OBJBTN_GROUP_NO_SELECT>, 0)
	$$create_menu_continue_button($stage.object[@ボタン_メニュー_前回の続きから], _menu_continue_btn, 759, 949, @ボタン_メニュー_前回の続きから, <OBJBTN_GROUP_NO_SELECT>, 1)
	$$create_menu_load_button($stage.object[@ボタン_メニュー_続きから], _menu_load_btn, 961, 949, @ボタン_メニュー_続きから, <OBJBTN_GROUP_NO_SELECT>, 1)
	$$create_ui_button($stage.object[@ボタン_メニュー_コンフィグ], _menu_config_btn, 1163, 949, @ボタン_メニュー_コンフィグ, <OBJBTN_GROUP_NO_SELECT>, 1)
	$$create_menu_extra_button($stage.object[@ボタン_メニュー_エクストラ], _menu_extra_btn, 1365, 949, @ボタン_メニュー_エクストラ, <OBJBTN_GROUP_NO_SELECT>, 1)
	$$create_ui_button($stage.object[@ボタン_メニュー_ゲーム終了], _menu_exit_btn, 1567, 949, @ボタン_メニュー_ゲーム終了, <OBJBTN_GROUP_NO_SELECT>, 1)
}


//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
// - 毎フレーム処理を追加することができます
//---------------------------------------------------------------------------
command $$update_menu_scene_object(property $stage : stage, property $select_btn)
{
	property $i
	property $hit_button
	
	// キャンセルは何も処理しない
	if( $select_btn == -1 ) {
		return
	}
	
	// 当たっているボタンを取得する
	if( syscom.check_joypad_mode )
	{
		$hit_button = $$get_joypad_focus_button
	}
	else
	{
		$hit_button = $$get_hit_btn
		
		if( $hit_button == -1 || $hit_button == -2 )
		{
			$hit_button = $$get_pushed_btn
		}
		
		if( $hit_button == -1 || $hit_button == -2 )
		{
			$hit_button = $select_btn
		}
		
		if( $hit_button == -1 || $hit_button == -2 )
		{
		}
	}
	
	if( @ボタン_メニュー_最初から <= $hit_button && $hit_button <= @ボタン_メニュー_別ルートから始める３ )
	{
		if( $hit_button != $hit_button_old )
		{
			// 前回当たっているボタンがある場合は下に移動する
			if( @ボタン_メニュー_最初から <= $hit_button_old && $hit_button_old <= @ボタン_メニュー_別ルートから始める３ )
			{
		;		$stage.object[@イメージ_ボタンテキスト + $hit_button_old].y_rep[0] = -10
		;		$stage.object[@イメージ_ボタンテキスト + $hit_button_old].y_rep_eve[0].set_real(0, 250, 0, 2)
			}
			
			// 当たっているボタンが選択不可の場合はボタン背景を非表示にする
			if( $stage.object[$hit_button].get_button_state == 4 )
			{
			}
			else
			{
			}
			
			// 今回当たっているボタンを上に移動する
			/*
			$stage.object[@イメージ_ボタンテキスト + $hit_button].y_rep[0] = 0
			$stage.object[@イメージ_ボタンテキスト + $hit_button].y_rep_eve[0].set_real(-10, 250, 0, 2)
			
			// ボタン背景の表示アニメーションを開始する
			$stage.object[@イメージ_ボタン背景].x = $stage.object[$hit_button].x + ($stage.object[$hit_button].get_size_x - $stage.object[@イメージ_ボタン背景].get_size_x) / 2
			$stage.object[@イメージ_ボタン背景].y = $stage.object[$hit_button].y - 10
			$stage.object[@イメージ_ボタン背景].x_rep[0] = -50
			$stage.object[@イメージ_ボタン背景].x_rep_eve[0].set_real(0, 250, 0, 2)
			$stage.object[@イメージ_ボタン背景].tr = 0
			$stage.object[@イメージ_ボタン背景].tr_eve.set_real(255, 250, 0, 2)
			
			$stage.object[@イメージ_ボタン背景].disp = 0
			
			// パッド背景の表示アニメーションを開始する
			$stage.object[@イメージ_パッド背景].x = $stage.object[$hit_button].x + ($stage.object[$hit_button].get_size_x - $stage.object[@イメージ_パッド背景].get_size_x) / 2
			$stage.object[@イメージ_パッド背景].y = $stage.object[$hit_button].y - 10
			$stage.object[@イメージ_パッド背景].tr = 0
			$stage.object[@イメージ_パッド背景].tr_eve.set_real(255, 250, 0, 2)
			$stage.object[@イメージ_パッド背景].set_scale(0, 0)
			$stage.object[@イメージ_パッド背景].scale_x_eve.set_real(1000, 250, 0, 2)
			$stage.object[@イメージ_パッド背景].scale_y_eve.set_real(1000, 250, 0, 2)
			
			$stage.object[@イメージ_パッド背景].disp = 0
			*/
			
			// 当たっているボタンを保存する
			$hit_button_old = $hit_button
		}
	}
	else
	{
		if( input.cancel.on_down_up == 0 && $hit_button != $hit_button_old )
		{
			// 前回当たっているボタンがある場合は下に移動する
			if( @ボタン_メニュー_最初から <= $hit_button_old && $hit_button_old <= @ボタン_メニュー_別ルートから始める３ )
			{
		;		$stage.object[@イメージ_ボタンテキスト + $hit_button_old].y_rep[0] = -10
		;		$stage.object[@イメージ_ボタンテキスト + $hit_button_old].y_rep_eve[0].set_real(0, 250, 0, 2)
			}
			
			/*
			// ボタン背景の非表示アニメーションを開始する
			$stage.object[@イメージ_ボタン背景].x_rep[0] = 0
			$stage.object[@イメージ_ボタン背景].x_rep_eve[0].set_real(50, 200, 0, 2)
			$stage.object[@イメージ_ボタン背景].tr_eve.set(0, 200, 0, 2)
			
			// パッド背景の非表示アニメーションを開始する
			$stage.object[@イメージ_パッド背景].scale_x_eve.set_real(0, 250, 0, 2)
			$stage.object[@イメージ_パッド背景].scale_y_eve.set_real(0, 250, 0, 2)
			*/
			
			// 当たっているボタンを保存する
			$hit_button_old = $hit_button
		}
	}
	
	// ボタンテキストはボタンの状態に追従させる
	for( $i = @ボタン_メニュー_最初から, $i <= @ボタン_メニュー_別ルートから始める３, $i += 1 )
	{
		if( $stage.object[$i].f.get_size == 0 ) {
			continue
		}
		
//		$stage.object[@イメージ_ボタンテキスト + $i].patno = $stage.object[$i].get_button_real_state
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
// - シーン表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$show_menu_scene_object(property $stage : stage)
{
	// タイトルメニューレベルごとに画面構築を変更する
	switch( @タイトルメニューレベル ) {
	case(0)		$$set_menu_scene_object_normal($stage)			// 通常
	case(1)		$$show_menu_scene_object_eternicle($stage, 1)	// エタニクルonly
				// ジョイパッドで最初に選択されているボタンを設定する
				$$set_joypad_focus_button(@ボタン_メニュー_別ルートから始める１)
				@タイトルメニューレベル = 2						// エタニクルonlyが表示されるのは一度のみ
	case(2)		$$show_menu_scene_object_eternicle($stage, 0)	// エタニクル＋通常メニュー
	case(3)		$$show_menu_scene_object_anemoi($stage, 1)		// アネモイonly
				@タイトルメニューレベル = 4						// アネモイonlyが表示されるのは一度のみ
				// ジョイパッドで最初に選択されているボタンを設定する
				$$set_joypad_focus_button(@ボタン_メニュー_別ルートから始める２)
	case(4)		$$show_menu_scene_object_anemoi($stage, 0)		// アネモイ＋通常メニュー
	case(5)		$$show_menu_scene_object_all_clear($stage)		// フルコンプ
	}
}

//---------------------------------------------------------------------------
// タイトルメニュー遷移時のフェードを表示する
//---------------------------------------------------------------------------
command $$show_menu_start_fade
{
}

//---------------------------------------------------------------------------
// スタートボタンを押したときの処理
// - シーン表示時の処理を追加することができます
//---------------------------------------------------------------------------
command $$push_menu_start_button
{
	// ボタン効果音を再生する
	se.play_by_se_no(<BUTTON_SE_COMPLETE>)
	
	@bgm_stop(3000)
	@fade_w(0, 3000)
	
	// メニュー画面でのユーザー制御を解除する
	$$menu_control_disabled
	
	// エピソード選択画面へ
	jump("001_シナリオフロー", 00)
}

//---------------------------------------------------------------------------
// 別ルートから始めるボタンを押したときの処理
// ※システム画面psdで別ルートから始めるボタンが指定されていない場合は実行されません
//---------------------------------------------------------------------------
command $$push_menu_route_button(property $route_no)
{
	// ボタン効果音を再生する
	se.play_by_se_no(<BUTTON_SE_COMPLETE>)
	
	@bgm_stop(3000)
	@fade_w(0, 3000)
	
	// メニュー画面でのユーザー制御を解除する
	$$menu_control_disabled
	
	// 各シナリオへ
	switch( $route_no ) {
	case(1)		timewait_key(2000)
				jump("001_シナリオフロー", 400)		// エタニクル
	case(2)		timewait_key(2000)
				jump("001_シナリオフロー", 450)		// アネモイ
	}
}

//---------------------------------------------------------------------------
// タイトルメニューオブジェクトを設定する（通常）
//---------------------------------------------------------------------------
command $$set_menu_scene_object_normal(property $stage : stage)
{
	property $i
	property $omv_animation_flag
	property $animation_end_flag
	
	// ボタンを調整する
	$$adjust_menu_button($stage)
	
	// シーンオブジェクトを追加で作成する
	$$create_add_menu_scene_object_normal($stage)
	
	// タイトルＢＧＭを準備する
	bgm.ready(bgm27)
	
	// シーンオブジェクトのアニメーションを設定する
	$$set_scene_object_animation_normal($stage)
	
	// タイトルＢＧＭを再生する
	bgm.resume
	
	// ワイプ
	wipe(0, 1000)
	
	counter[0].start_real
	$omv_animation_flag = 0
	
	//---------------------------------------------------------------------------
	// アニメーション終了 or 入力待ち
	while( 1 )
	{
		$animation_end_flag = 0
		
		if( counter[0].get > 0 && $omv_animation_flag == 0 )
		{
			// ムービー（風）再生
			front.object[@ムービー_風_最初].seek_movie(0)
			front.object[@ムービー_風_最初].resume_movie
			
			$omv_animation_flag = 1
		}
		
		// 決定、キャンセルキーいずれかの入力があったとき、アニメーションをスキップする
		if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
		{
			for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
			{
				// オブジェクトが表示されている場合はイベントを終了する
				if( front.object[$i].disp ) {
					front.object[$i].all_eve.end
				}
			}
			
			// パーティクル（キャラ表示時）を終了する
			front.object[@パーティクル_キャラ表示].child[0].frame_action.end
			front.object[@パーティクル_キャラ表示].child[1].frame_action.end
		}
		
		for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
		{
			// オブジェクトがイベント中か判定する
			if( front.object[$i].disp && front.object[$i].all_eve.check )
			{
				$animation_end_flag = 1
				break
			}
		}
		// アニメーションが終了している場合はループから抜ける
		if( $animation_end_flag == 0 )
		{
			// ムービー（風）は非表示にする
			front.object[@ムービー_風_最初].set_movie_auto_free(1)
			front.object[@ムービー_風_最初].disp = 0
			
			// パーティクル（空全体）を再生する
			$$play_menu_particle_sky(front.object[@パーティクル_空全体])
			
			break
		}
		
		input.next
		disp
	}
}

// シーンオブジェクトを追加で作成する
command $$create_add_menu_scene_object_normal(property $stage : stage)
{
	property $i
	property $filename : str
	
	// ブランドロゴの設定をする
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].layer = 1
	front.object[@イメージ_ブランドロゴ].wipe_copy = 1
	
	// 背景（キャラなし）に子供オブジェクトを追加して縦長にする
	$stage.object[@イメージ_背景キャラなし].child.resize(1)
	$stage.object[@イメージ_背景キャラなし].child[0].create(_menu_bg01, 1, 0, -1080, 1)
	
	// 背景キャラあり
	$stage.object[@イメージ_背景キャラあり].child.resize(5)
	$stage.object[@イメージ_背景キャラあり].child[0].create(_menu_chara, 1, 128, 194, 0)
	$stage.object[@イメージ_背景キャラあり].child[1].create(_menu_chara, 1, 128, 194, 1)
	$stage.object[@イメージ_背景キャラあり].child[2].create(_menu_chara, 1, 128, 194, 2)
	$stage.object[@イメージ_背景キャラあり].child[3].create(_menu_chara, 1, 128, 194, 3)
	$stage.object[@イメージ_背景キャラあり].child[3].layer = -1
	$stage.object[@イメージ_背景キャラあり].child[4].create(_menu_chara, 1, 128, 194, 4)
	$stage.object[@イメージ_背景キャラあり].child[4].layer = -1
	
	// クリアフラグによってキャラクターを消去する
	if( @朱比華ルートクリア ) { $stage.object[@イメージ_背景キャラあり].child[0].disp = 0 }
	if( @愛乃ルートクリア ) { $stage.object[@イメージ_背景キャラあり].child[1].disp = 0 }
	if( @陽彩ルートクリア ) { $stage.object[@イメージ_背景キャラあり].child[2].disp = 0 }
	if( @小詠ルートクリア ) { $stage.object[@イメージ_背景キャラあり].child[3].disp = 0 }
	if( @六花ルートクリア ) { $stage.object[@イメージ_背景キャラあり].child[4].disp = 0 }
	
	// タイトルロゴの設定をする
	$stage.object[@イメージ_タイトルロゴ].layer = 1
	
	// フィルター
	$stage.object[@イメージ_フィルター].create(ef_eye_catch_filter, 1)
	$stage.object[@イメージ_フィルター].blend = 1
	
	// パーティクル（キャラ表示時）
	$$create_menu_particle_disp_chara($stage.object[@パーティクル_キャラ表示], 18500)
	
	// パーティクル（空全体）
	$$create_menu_particle_sky($stage.object[@パーティクル_空全体])
	
	// ムービー（塵／空）
	$stage.object[@ムービー_塵_空].create_movie_loop(ef_wind_dust02, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_空].blend = 1
	$$set_image_center_rep($stage.object[@ムービー_塵_空])
	
	// ムービー（塵／遠）
	$stage.object[@ムービー_塵_遠].create_movie_loop(ef_wind_dust01, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_遠].blend = 1
	$stage.object[@ムービー_塵_遠].tr_rep.resize(1)
	$$set_image_center_rep($stage.object[@ムービー_塵_遠])
	
	// ムービー（塵／近）
	$stage.object[@ムービー_塵_近].create_movie_loop(ef_wind_dust02, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_近].blend = 1
	$stage.object[@ムービー_塵_近].tr_rep.resize(1)
	$$set_image_center_rep($stage.object[@ムービー_塵_近])
	
	// ムービー（風）
	$stage.object[@ムービー_風_最初].create_movie(ef_wind04, 1, ready_only = 1, real_time = 1, auto_free = 0)
	$stage.object[@ムービー_風_最初].y = 300
	$stage.object[@ムービー_風_最初].tr = 128
	$stage.object[@ムービー_風_最初].blend = 1
	
	// ムービー（風ループ）
	$stage.object[@ムービー_風上段_ループ].create_movie(ef_wind04, 1, 0, -50, real_time = 1, auto_free = 0)
	$stage.object[@ムービー_風上段_ループ].tr = 0
	$stage.object[@ムービー_風上段_ループ].blend = 1
	$stage.object[@ムービー_風上段_ループ].wipe_copy = 1
	$stage.object[@ムービー_風上段_ループ].f.resize(1)
	$stage.object[@ムービー_風上段_ループ].frame_action.start_real(-1, "$$fa_movie_loop", 7000)
	
	$stage.object[@ムービー_風下段_ループ].create_movie(ef_wind03, 1, 0, 600, real_time = 1, auto_free = 0)
	$stage.object[@ムービー_風下段_ループ].tr = 0
	$stage.object[@ムービー_風下段_ループ].blend = 4
	$stage.object[@ムービー_風下段_ループ].wipe_copy = 1
	$stage.object[@ムービー_風下段_ループ].f.resize(1)
	$stage.object[@ムービー_風下段_ループ].frame_action.start_real(-1, "$$fa_movie_loop", 9000)
}

// シーンオブジェクトのアニメーションを設定する
command $$set_scene_object_animation_normal(property $stage : stage)
{
	property $i
	
	// 空背景
	$stage.object[@イメージ_空背景].patno = 1
	$stage.object[@イメージ_空背景].set_scale(2000, 2000)
	$stage.object[@イメージ_空背景].scale_x_eve.set_real(1500, 12000, 0, 0)
	$stage.object[@イメージ_空背景].scale_y_eve.set_real(1500, 12000, 0, 0)
	$stage.object[@イメージ_空背景].bright = 255
	$stage.object[@イメージ_空背景].bright_eve.set_real(0, 2500, 0, 0)
	
	// フィルター
	$stage.object[@イメージ_フィルター].tr = 255
	$stage.object[@イメージ_フィルター].tr_eve.set_real(0, 1500, 0, 2)
	
	// 背景（キャラなし）
	$stage.object[@イメージ_背景キャラなし].tr = 0
	$stage.object[@イメージ_背景キャラなし].tr_eve.set_real(255, 2000, 7500, 0)
	$stage.object[@イメージ_背景キャラなし].y = 1080
	$stage.object[@イメージ_背景キャラなし].y_eve.set_real(0, 18000, 0, 0)
	$stage.object[@イメージ_背景キャラなし].bright = 255
	$stage.object[@イメージ_背景キャラなし].bright_eve.set_real(0, 4000, 8500, 0)
	
	// 背景（キャラあり）
	$stage.object[@イメージ_背景キャラあり].set_scale(1020, 1020)
	$stage.object[@イメージ_背景キャラあり].scale_x_eve.set_real(1000, 500, 18000, 2)
	$stage.object[@イメージ_背景キャラあり].scale_y_eve.set_real(1000, 500, 18000, 2)
	$stage.object[@イメージ_背景キャラあり].tr = 0
	$stage.object[@イメージ_背景キャラあり].tr_eve.set_real(255, 1000, 18000, 0)
	$stage.object[@イメージ_背景キャラあり].bright = 196
	$stage.object[@イメージ_背景キャラあり].bright_eve.set_real(0, 1000, 18000, 0)
	
	// ブランドロゴ
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].tr_eve.set_real(0, 2000, 4500, 0)
	
	// タイトルロゴ
	$stage.object[@イメージ_タイトルロゴ].tr = 0
	$stage.object[@イメージ_タイトルロゴ].tr_eve.set_real(255, 1500, 19000, 0)
	$stage.object[@イメージ_タイトルロゴ].set_scale(1250, 1250)
	$stage.object[@イメージ_タイトルロゴ].scale_x_eve.set_real(1000, 1500, 19000, 0)
	$stage.object[@イメージ_タイトルロゴ].scale_y_eve.set_real(1000, 1500, 19000, 0)
	
	// copyright
	$stage.object[@イメージ_コピーライト].layer = 1
	$stage.object[@イメージ_コピーライト].tr = 0
	$stage.object[@イメージ_コピーライト].tr_eve.set_real(255, 1000, 21000, 0)
	
	// ボタン背景
	$stage.object[@イメージ_ボタン背景].y_rep.resize(1)
	$stage.object[@イメージ_ボタン背景].y_rep[0] = 20
	$stage.object[@イメージ_ボタン背景].y_rep_eve[0].set_real(0, 1000, 18000, 0)
	$stage.object[@イメージ_ボタン背景].tr = 0
	$stage.object[@イメージ_ボタン背景].tr_eve.set_real(255, 1000, 18000, 0)
	
	// ボタン
	for( $i = @ボタン_メニュー_最初から, $i < @ボタン_メニュー_別ルートから始める３, $i += 1 )
	{
		if( $stage.object[$i].disp == 0 ) {
			continue
		}
		
		$stage.object[$i].tr = 0
		$stage.object[$i].tr_eve.set_real(255, 1000, 21000, 0)
		$stage.object[$i].y_rep[0] = 20
		$stage.object[$i].y_rep_eve[0].set_real(0, 1000, 21000, 0)
	}
	
	// ムービー（塵／空）
	$stage.object[@ムービー_塵_空].set_scale(2000, 2000)
	$stage.object[@ムービー_塵_空].scale_x_eve.set_real(1500, 12000, 0, 0)
	$stage.object[@ムービー_塵_空].scale_y_eve.set_real(1500, 12000, 0, 0)
	$stage.object[@ムービー_塵_空].tr_eve.set_real(0, 1000, 9500, 0)
	$stage.object[@ムービー_塵_空].resume_movie
	
	// ムービー（塵／遠）
	$stage.object[@ムービー_塵_遠].set_scale(1000, 1000)
	$stage.object[@ムービー_塵_遠].scale_x_eve.set_real(1500, 10000, 8500, 0)
	$stage.object[@ムービー_塵_遠].scale_y_eve.set_real(1500, 10000, 8500, 0)
	$stage.object[@ムービー_塵_遠].tr = 0
	$stage.object[@ムービー_塵_遠].tr_eve.set_real(255, 2000, 8500, 2)
	$stage.object[@ムービー_塵_遠].tr_rep[0] = 255
	$stage.object[@ムービー_塵_遠].tr_rep_eve[0].set_real(0, 2000, 17500, 2)
	$stage.object[@ムービー_塵_遠].resume_movie
	
	// ムービー（塵／近）
	$stage.object[@ムービー_塵_近].set_scale(1000, 1000)
	$stage.object[@ムービー_塵_近].scale_x_eve.set_real(1500, 10000, 8500, 0)
	$stage.object[@ムービー_塵_近].scale_y_eve.set_real(1500, 10000, 8500, 0)
	$stage.object[@ムービー_塵_近].tr = 0
	$stage.object[@ムービー_塵_近].tr_eve.set_real(255, 2000, 8500, 2)
	$stage.object[@ムービー_塵_近].tr_rep[0] = 255
	$stage.object[@ムービー_塵_近].tr_rep_eve[0].set_real(0, 2000, 17500, 2)
	$stage.object[@ムービー_塵_近].resume_movie
	
	// ムービー（風ループ）
	$stage.object[@ムービー_風上段_ループ].tr_eve.set_real( 32, 500, 12500, 0)
	$stage.object[@ムービー_風下段_ループ].tr_eve.set_real(128, 500, 12500, 0)
}



//---------------------------------------------------------------------------
// タイトルメニューオブジェクトを設定する（エタニクル）
//---------------------------------------------------------------------------
command $$show_menu_scene_object_eternicle(property $stage : stage, property $type)
{
	property $i
	property $omv_animation_flag
	property $animation_end_flag
	
	// ボタンを調整する
	$$adjust_menu_button($stage)
	
	// シーンオブジェクトを追加で作成する
	$$create_add_menu_scene_object_eternicle($stage)
	
	// 一度のみの演出
	if( $type == 1 )
	{
		// 早送りを禁止する
		script.set_ctrl_skip_disable
		
		// シーンオブジェクトのアニメーションを設定する
		$$set_scene_object_animation_eternicle_once($stage)
		
		// ワイプ
		wipe(0, 3000, key_skip = 0)
		
		// ＳＥ
		@se(SE_wheat_sway_wind)
		
		timewait(4000)
		
		@se_stop(1000)
		
		// 音声
		exkoe(403600144,001)	// 【スピカ】「私はずっと探していた」R
		koe_wait
		
		timewait(4500)
		
		exkoe(403600146,001)	// 【スピカ】「風の回廊をさまよいながら……」R
		koe_wait
		
		timewait(5000)
		
		// タイトルＢＧＭを準備する
		bgm.ready(bgm29)
		
		// シーンオブジェクトのアニメーションを設定する
		$$set_scene_object_animation_eternicle(front)
		
		// 早送りを許可する
		script.set_ctrl_skip_enable
	}
	else
	{
		// タイトルＢＧＭを準備する
		bgm.ready(bgm29)
		
		// シーンオブジェクトのアニメーションを設定する
		$$set_scene_object_animation_eternicle($stage)
		
		// ワイプ
		wipe(0, 1000)
	}
	
	// タイトルＢＧＭを再生する
	bgm.resume
	
	//---------------------------------------------------------------------------
	// アニメーション終了 or 入力待ち
	while( 1 )
	{
		$animation_end_flag = 0
		
		// 決定、キャンセルキーいずれかの入力があったとき、アニメーションをスキップする
		if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
		{
			for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
			{
				// オブジェクトが表示されている場合はイベントを終了する
				if( front.object[$i].disp ) {
					front.object[$i].all_eve.end
				}
			}
		}
		
		for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
		{
			// オブジェクトがイベント中か判定する
			if( front.object[$i].disp && front.object[$i].all_eve.check )
			{
				$animation_end_flag = 1
				break
			}
		}
		
		// アニメーションが終了している場合はループから抜ける
		if( $animation_end_flag == 0 )
		{
			break
		}
		
		input.next
		disp
	}
}

// シーンオブジェクトを追加で作成する
command $$create_add_menu_scene_object_eternicle(property $stage : stage)
{
	property $i
	
	// ブランドロゴの設定をする
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].layer = 1
	front.object[@イメージ_ブランドロゴ].wipe_copy = 1
	
	// 背景（キャラなし）
	$stage.object[@イメージ_背景キャラなし].create(_menu_bg02, 1)
	$$set_image_center_rep($stage.object[@イメージ_背景キャラなし])
	$stage.object[@イメージ_背景キャラなし].mono = 192
	$stage.object[@イメージ_背景キャラなし].bright = 255
	$stage.object[@イメージ_背景キャラなし].wipe_copy = 1
	
	// 背景（キャラあり）
	$stage.object[@イメージ_背景キャラあり].create(_menu_chara, 1, 88, 194)
	$$set_image_center_rep($stage.object[@イメージ_背景キャラあり])
	$stage.object[@イメージ_背景キャラあり].mono = 64
	$stage.object[@イメージ_背景キャラあり].tr = 0
	$stage.object[@イメージ_背景キャラあり].wipe_copy = 1
	
	// タイトルロゴの設定をする
	$stage.object[@イメージ_タイトルロゴ].tr = 0
	$stage.object[@イメージ_タイトルロゴ].mono = 192
	$stage.object[@イメージ_タイトルロゴ].layer = 1
	
	// copyright
	$stage.object[@イメージ_コピーライト].tr = 0
	
	// ボタン
	for( $i = @ボタン_メニュー_最初から, $i < @ボタン_メニュー_別ルートから始める３, $i += 1 )
	{
		if( $stage.object[$i].disp == 0 ) {
			continue
		}
		
		$stage.object[$i].tr = 0
	}
	
	// ムービー（塵／遠）
	$stage.object[@ムービー_塵_遠].create_movie_loop(ef_wind_dust01, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_遠].blend = 1
	$stage.object[@ムービー_塵_遠].wipe_copy = 1
	$stage.object[@ムービー_塵_遠].tr = 0
	$stage.object[@ムービー_塵_遠].tr_rep.resize(1)
	$$set_image_center_rep($stage.object[@ムービー_塵_遠])
	
	// ムービー（塵／近）
	$stage.object[@ムービー_塵_近].create_movie_loop(ef_wind_dust02, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_近].blend = 1
	$stage.object[@ムービー_塵_近].wipe_copy = 1
	$stage.object[@ムービー_塵_近].tr = 0
	$stage.object[@ムービー_塵_近].tr_rep.resize(1)
	$$set_image_center_rep($stage.object[@ムービー_塵_近])
	
	// フェード
	$stage.object[@イメージ_フェード].create(bg_siro, 1)
	$stage.object[@イメージ_フェード].layer = 100
}

// シーンオブジェクトのアニメーションを設定する
command $$set_scene_object_animation_eternicle_once(property $stage : stage)
{
	$stage.object[@イメージ_フェード].tr_eve.set_real(0, 5000, 5000, 0)
	
	// 特殊演出用（ティザー足元）
	$stage.object[31].create(ef_eternicle_menu, 1)
	$stage.object[31].x = -200
	$stage.object[31].set_scale(1250, 1250)
	$stage.object[31].frame_action.start_real(-1, "$$fa_eternicle1")
	
	// 特殊演出用（ティザー顔）
	$stage.object[32].create(ef_eternicle_menu, 1, 0, 0, 1)
	$stage.object[32].set_scale(1250, 1250)
	$stage.object[32].frame_action.start_real(-1, "$$fa_eternicle2")
	
	// 特殊演出用（レンズフレア）
	$stage.object[33].create_movie(ef_sun14, 1, ready_only = 1, real_time = 1, auto_free = 0)
	$$set_screen_scale($stage.object[33])
	$stage.object[33].scale_x *= -1
	$stage.object[33].x = <SCREEN_WIDTH>
	$stage.object[33].blend = 1
	$stage.object[33].resume_movie
	
	// 特殊演出用（テキスト１）
	$stage.object[34].create(ef_eternicle_menu, 1, 0, 0, 2)
	$stage.object[34].frame_action.start_real(-1, "$$fa_eternicle3")
	
	// 特殊演出用（テキスト２）
	$stage.object[35].create(ef_eternicle_menu, 1, 0, 0, 3)
	$stage.object[35].frame_action.start_real(-1, "$$fa_eternicle4")
}

command $$fa_eternicle1(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.y = math.timetable(l[0], 0, -270, [0, 12000, 0, 0])
	$obj.tr = math.timetable(l[0], 0, 255, [14000, 16000, 0, 0])
}

command $$fa_eternicle2(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	
	$obj.x = math.timetable(l[0], 0, -480, [220, 25000, 0, 0])
	$obj.tr = math.timetable(l[0], 0, 0, [11500, 14500, 255, 0], [20000, 24000, 0, 0])
}

command $$fa_eternicle3(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	$obj.tr = math.timetable(l[0], 0, 0, [7000, 9000, 255, 0], [10500, 12500, 0, 0])
}

command $$fa_eternicle4(property $fa : frameaction, property $obj : object)
{
	l[0] = $fa.counter.get
	$obj.tr = math.timetable(l[0], 0, 0, [14000, 16000, 255, 0], [18000, 20000, 0, 0])
}


// シーンオブジェクトのアニメーションを設定する
command $$set_scene_object_animation_eternicle(property $stage : stage)
{
	property $i
	
	// 空背景
	$stage.object[@イメージ_空背景].init
	
	// フィルター
	$stage.object[@イメージ_フィルター].tr = 255
	$stage.object[@イメージ_フィルター].tr_eve.set_real(0, 1500, 0, 2)
	
	// 背景
	$stage.object[@イメージ_背景キャラなし].set_scale(1250, 1250)
	$stage.object[@イメージ_背景キャラなし].scale_x_eve.set_real(1000, 10000, 0, 2)
	$stage.object[@イメージ_背景キャラなし].scale_y_eve.set_real(1000, 10000, 0, 2)
	$stage.object[@イメージ_背景キャラなし].bright_eve.set_real(0, 8000, 0, 2)
	
	// キャラ
	$stage.object[@イメージ_背景キャラあり].set_scale(1150, 1150)
	$stage.object[@イメージ_背景キャラあり].scale_x_eve.set_real(1000, 3000, 7000, 2)
	$stage.object[@イメージ_背景キャラあり].scale_y_eve.set_real(1000, 3000, 7000, 2)
	$stage.object[@イメージ_背景キャラあり].tr_eve.set_real(255, 3000, 7000, 2)
	$stage.object[@イメージ_背景キャラあり].bright = 255
	$stage.object[@イメージ_背景キャラあり].bright_eve.set_real(0, 1000, 10000, 2)
	
	// ブランドロゴ
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].tr_eve.set_real(0, 2000, 0, 0)
	
	// タイトルロゴ
	$stage.object[@イメージ_タイトルロゴ].tr_eve.set_real(255, 1500, 12000, 0)
	
	// copyright
	$stage.object[@イメージ_コピーライト].layer = 1
	$stage.object[@イメージ_コピーライト].tr_eve.set_real(255, 1000, 12000, 0)
	
	// ボタン背景
	$stage.object[@イメージ_ボタン背景].tr = 0
	$stage.object[@イメージ_ボタン背景].tr_eve.set_real(255, 1000, 12000, 0)
	
	// ボタン
	for( $i = @ボタン_メニュー_最初から, $i < @ボタン_メニュー_別ルートから始める３, $i += 1 )
	{
		if( $stage.object[$i].disp == 0 ) {
			continue
		}
		
		$stage.object[$i].tr_eve.set_real(255, 1000, 13000, 0)
		$stage.object[$i].y_rep[0] = 20
		$stage.object[$i].y_rep_eve[0].set_real(0, 1000, 13000, 0)
	}
	
	// ムービー（塵／遠）
	$stage.object[@ムービー_塵_遠].set_scale(1000, 1000)
	$stage.object[@ムービー_塵_遠].scale_x_eve.set_real(1500, 10000, 1000, 0)
	$stage.object[@ムービー_塵_遠].scale_y_eve.set_real(1500, 10000, 1000, 0)
	$stage.object[@ムービー_塵_遠].tr_eve.set_real(255, 2000, 1000, 2)
	$stage.object[@ムービー_塵_遠].resume_movie
	
	// ムービー（塵／近）
	$stage.object[@ムービー_塵_近].set_scale(1000, 1000)
	$stage.object[@ムービー_塵_近].scale_x_eve.set_real(1500, 10000, 1000, 0)
	$stage.object[@ムービー_塵_近].scale_y_eve.set_real(1500, 10000, 1000, 0)
	$stage.object[@ムービー_塵_近].tr_eve.set_real(255, 2000, 8500, 2)
	$stage.object[@ムービー_塵_近].resume_movie
	
	// フェード
	$stage.object[@イメージ_フェード].tr_eve.set_real(0, 2000, 3000, 0)
	
	// 特殊演出用
	$stage.object[33].tr_eve.set_real(0, 3000, 0, 0)
}



//---------------------------------------------------------------------------
// タイトルメニューオブジェクトを設定する（アネモイ）
//---------------------------------------------------------------------------
command $$show_menu_scene_object_anemoi(property $stage : stage, property $type)
{
	property $i
	property $omv_animation_flag
	property $animation_end_flag
	
	// ボタンを調整する
	$$adjust_menu_button($stage)
	
	// シーンオブジェクトを追加で作成する
	$$create_add_menu_scene_object_anemoi($stage)
	
	// 一度のみの演出
	if( $type == 1 )
	{
		// 早送りを禁止する
		script.set_ctrl_skip_disable
		
		// タイトルＢＧＭを準備する
		//bgm.ready(bgm21b)
		@se_loop(ANB_outdoor_calm_wind_LOOP, 4000, 0)
		
		// シーンオブジェクトのアニメーションを設定する
		$$set_scene_object_animation_anemoi_once($stage)
		
		// ワイプ
		wipe(0, 3000, key_skip = 0)
		
		// タイトルＢＧＭを再生する
		bgm.resume
		
		timewait(6000)
		
		// シーンオブジェクトのアニメーションを設定する
		$$set_scene_object_animation_anemoi(front)
		
		// 早送りを許可する
		script.set_ctrl_skip_enable
	}
	else
	{
		// タイトルＢＧＭを準備する
		//bgm.ready(bgm21b)
		@se_loop(ANB_outdoor_calm_wind_LOOP, 1000, 0)
		
		// シーンオブジェクトのアニメーションを設定する
		$$set_scene_object_animation_anemoi($stage)
		
		// ワイプ
		wipe(0, 1000)
	}
	
	// タイトルＢＧＭを再生する
	//bgm.resume
	
	counter[0].start_real
	
	//---------------------------------------------------------------------------
	// アニメーション終了 or 入力待ち
	while( 1 )
	{
		if( counter[0].get > 4500 && $omv_animation_flag == 0 )
		{
			// ムービー（風ループ）
			front.object[@ムービー_風上段_ループ].resume_movie
			
			// パーティクルの実行
			front.object[31].disp = 1
			front.object[31].child[0].frame_action.start(-1, "$$fa_particle")
			front.object[31].child[1].frame_action.start(-1, "$$fa_particle")
			
			$omv_animation_flag = 1
		}
		
		$animation_end_flag = 0
		
		// 決定、キャンセルキーいずれかの入力があったとき、アニメーションをスキップする
		if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
		{
			for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
			{
				// オブジェクトが表示されている場合はイベントを終了する
				if( front.object[$i].disp ) {
					front.object[$i].all_eve.end
				}
			}
		}
		
		for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
		{
			// オブジェクトがイベント中か判定する
			if( front.object[$i].disp && front.object[$i].all_eve.check )
			{
				$animation_end_flag = 1
				break
			}
		}
		
		// アニメーションが終了している場合はループから抜ける
		if( $animation_end_flag == 0 )
		{
			break
		}
		
		input.next
		disp
	}
}


// シーンオブジェクトを追加で作成する
command $$create_add_menu_scene_object_anemoi(property $stage : stage)
{
	property $i
	
	// 空背景
	$stage.object[@イメージ_空背景].init
	
	// ブランドロゴの設定をする
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].layer = 1
	front.object[@イメージ_ブランドロゴ].wipe_copy = 1
	
	// 背景（キャラなし）
	$stage.object[@イメージ_背景キャラなし].create(bg702_30, 1)
	$stage.object[@イメージ_背景キャラなし].bright = 255
	$stage.object[@イメージ_背景キャラなし].wipe_copy = 1
	$$set_image_center_rep($stage.object[@イメージ_背景キャラなし])
	
	// 背景（キャラあり）
	$stage.object[@イメージ_背景キャラあり].init
	
	// タイトルロゴの設定をする
	$stage.object[@イメージ_タイトルロゴ].tr = 0
	$stage.object[@イメージ_タイトルロゴ].layer = 1
	
	// copyright
	$stage.object[@イメージ_コピーライト].layer = 1
	$stage.object[@イメージ_コピーライト].tr = 0
	
	// ボタン背景
	$stage.object[@イメージ_ボタン背景].y_rep.resize(1)
	$stage.object[@イメージ_ボタン背景].tr = 0
	
	// ボタン
	for( $i = @ボタン_メニュー_最初から, $i < @ボタン_メニュー_別ルートから始める３, $i += 1 )
	{
		if( $stage.object[$i].disp == 0 ) {
			continue
		}
		
		$stage.object[$i].tr = 0
	}
	
	// ムービー（風ループ）
	$stage.object[@ムービー_風上段_ループ].create_movie(ef_wind04, 1, 0, -120, ready_only = 1, real_time = 1, auto_free = 0)
	$stage.object[@ムービー_風上段_ループ].set_scale(1050, 1050)
	$stage.object[@ムービー_風上段_ループ].x -= 60
	$stage.object[@ムービー_風上段_ループ].y -= 40
	$stage.object[@ムービー_風上段_ループ].wipe_copy = 1
	$stage.object[@ムービー_風上段_ループ].blend = 1
	
	// フェード
	$stage.object[@イメージ_フェード].create(bg_siro, 1)
	$stage.object[@イメージ_フェード].layer = 100
	
	// パーティクル
	$$create_anemoi_particle(back.object[31])
	back.object[31].disp = 0
}

// シーンオブジェクトのアニメーションを設定する
command $$set_scene_object_animation_anemoi_once(property $stage : stage)
{
	$$load_image($stage.object[@イメージ_背景キャラあり], bg707_07)
	
	$stage.object[@イメージ_背景キャラあり].y = 0
	$stage.object[@イメージ_背景キャラあり].y_eve.set(-500, 12000, 4000, 0)
	$stage.object[@イメージ_背景キャラあり].tr_eve.set(0, 3000, 10000, 0)
	$stage.object[@イメージ_背景キャラあり].bright = 255
	$stage.object[@イメージ_背景キャラあり].bright_eve.set_real(0, 3000, 4000, 0)
	
	// フェード
	$stage.object[@イメージ_フェード].tr_eve.set_real(0, 5000, 4000, 0)
}

// シーンオブジェクトのアニメーションを設定する
command $$set_scene_object_animation_anemoi(property $stage : stage)
{
	property $i
	
	// 背景
	$stage.object[@イメージ_背景キャラなし].set_scale(1250, 1250)
	$stage.object[@イメージ_背景キャラなし].scale_x_eve.set_real(1000, 5000, 0, 2)
	$stage.object[@イメージ_背景キャラなし].scale_y_eve.set_real(1000, 5000, 0, 2)
	$stage.object[@イメージ_背景キャラなし].bright_eve.set_real(0, 6500, 0, 1)
	
	// ブランドロゴ
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].tr_eve.set_real(0, 2000, 0, 0)
	
	// タイトルロゴ
	$stage.object[@イメージ_タイトルロゴ].tr_eve.set_real(255, 1500, 7000, 0)
	
	// copyright
	$stage.object[@イメージ_コピーライト].tr_eve.set_real(255, 1000, 7000, 0)
	
	// ボタン背景
	$stage.object[@イメージ_ボタン背景].y_rep[0] = 20
	$stage.object[@イメージ_ボタン背景].y_rep_eve[0].set_real(0, 1000, 7000, 0)
	$stage.object[@イメージ_ボタン背景].tr_eve.set_real(255, 1000, 7000, 0)
	
	// ボタン
	for( $i = @ボタン_メニュー_最初から, $i < @ボタン_メニュー_別ルートから始める３, $i += 1 )
	{
		if( $stage.object[$i].disp == 0 ) {
			continue
		}
		
		$stage.object[$i].tr_eve.set_real(255, 1000, 9000, 0)
		$stage.object[$i].y_rep[0] = 20
		$stage.object[$i].y_rep_eve[0].set_real(0, 1000, 9000, 0)
	}
	
	// フェード
	$stage.object[@イメージ_フェード].tr_eve.set_real(0, 2000, 3000, 0)
}




//---------------------------------------------------------------------------
// タイトルメニューオブジェクトを設定する（フルコンプ）
//---------------------------------------------------------------------------
command $$show_menu_scene_object_all_clear(property $stage : stage)
{
	property $i
	property $omv_animation_flag
	property $animation_end_flag
	
	// ボタンを調整する
	$$adjust_menu_button($stage)
	
	// シーンオブジェクトを追加で作成する
	$$create_add_menu_scene_object_all_clear($stage)
	
	// タイトルＢＧＭを準備する
	bgm.ready(bgm45)
	
	// シーンオブジェクトのアニメーションを設定する
	$$set_scene_object_animation_all_clear($stage)
	
	// タイトルＢＧＭを再生する
	bgm.resume
	
	// ワイプ
	wipe(0, 1000)
	
	counter[0].start_real
	$omv_animation_flag = 0
	
	//---------------------------------------------------------------------------
	// アニメーション終了 or 入力待ち
	while( 1 )
	{
		$animation_end_flag = 0
		
		if( counter[0].get > 0 && $omv_animation_flag == 0 )
		{
			// ムービー（風）再生
			front.object[@ムービー_風_最初].seek_movie(0)
			front.object[@ムービー_風_最初].resume_movie
			
			$omv_animation_flag = 1
		}
		
		// 決定、キャンセルキーいずれかの入力があったとき、アニメーションをスキップする
		if( input.decide.on_down_up == 1 || input.cancel.on_down_up == 1 )
		{
			for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
			{
				// オブジェクトが表示されている場合はイベントを終了する
				if( front.object[$i].disp ) {
					front.object[$i].all_eve.end
				}
			}
			
			// パーティクル（キャラ表示時）を終了する
			front.object[@パーティクル_キャラ表示].child[0].frame_action.end
			front.object[@パーティクル_キャラ表示].child[1].frame_action.end
		}
		
		for( $i = 0, $i < <OBJ_MAX>, $i += 1 )
		{
			// オブジェクトがイベント中か判定する
			if( front.object[$i].disp && front.object[$i].all_eve.check )
			{
				$animation_end_flag = 1
				break
			}
		}
		// アニメーションが終了している場合はループから抜ける
		if( $animation_end_flag == 0 )
		{
			// ムービー（風）は非表示にする
			front.object[@ムービー_風_最初].set_movie_auto_free(1)
			front.object[@ムービー_風_最初].disp = 0
			
			// パーティクル（空全体）を再生する
			$$play_menu_particle_sky(front.object[@パーティクル_空全体])
			
			break
		}
		
		input.next
		disp
	}
}

// シーンオブジェクトを追加で作成する
command $$create_add_menu_scene_object_all_clear(property $stage : stage)
{
	property $i
	property $filename : str
	
	// ブランドロゴの設定をする
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].layer = 1
	front.object[@イメージ_ブランドロゴ].wipe_copy = 1
	
	// 背景（キャラなし）に子供オブジェクトを追加して縦長にする
	$stage.object[@イメージ_背景キャラなし].child.resize(1)
	$stage.object[@イメージ_背景キャラなし].child[0].create(_menu_bg01, 1, 0, -1080, 1)
	
	// 背景キャラあり
	$stage.object[@イメージ_背景キャラあり].child.resize(5)
	$stage.object[@イメージ_背景キャラあり].child[0].create(_menu_chara, 1, 128, 194, 0)
	$stage.object[@イメージ_背景キャラあり].child[1].create(_menu_chara, 1, 128, 194, 1)
	$stage.object[@イメージ_背景キャラあり].child[2].create(_menu_chara, 1, 128, 194, 2)
	$stage.object[@イメージ_背景キャラあり].child[3].create(_menu_chara, 1, 128, 194, 3)
	$stage.object[@イメージ_背景キャラあり].child[3].layer = -1
	$stage.object[@イメージ_背景キャラあり].child[4].create(_menu_chara, 1, 128, 194, 4)
	$stage.object[@イメージ_背景キャラあり].child[4].layer = -1
	
	// タイトルロゴの設定をする
	$stage.object[@イメージ_タイトルロゴ].layer = 1
	
	// フィルター
	$stage.object[@イメージ_フィルター].create(ef_eye_catch_filter, 1)
	$stage.object[@イメージ_フィルター].blend = 1
	
	// パーティクル（キャラ表示時）
	$$create_menu_particle_disp_chara($stage.object[@パーティクル_キャラ表示], 18500)
	
	// パーティクル（空全体）
	$$create_menu_particle_sky($stage.object[@パーティクル_空全体])
	
	// ムービー（塵／空）
	$stage.object[@ムービー_塵_空].create_movie_loop(ef_wind_dust02, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_空].blend = 1
	$$set_image_center_rep($stage.object[@ムービー_塵_空])
	
	// ムービー（塵／遠）
	$stage.object[@ムービー_塵_遠].create_movie_loop(ef_wind_dust01, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_遠].blend = 1
	$stage.object[@ムービー_塵_遠].tr_rep.resize(1)
	$$set_image_center_rep($stage.object[@ムービー_塵_遠])
	
	// ムービー（塵／近）
	$stage.object[@ムービー_塵_近].create_movie_loop(ef_wind_dust02, 1, ready_only = 1, real_time = 1)
	$stage.object[@ムービー_塵_近].blend = 1
	$stage.object[@ムービー_塵_近].tr_rep.resize(1)
	$$set_image_center_rep($stage.object[@ムービー_塵_近])
	
	// ムービー（風）
	$stage.object[@ムービー_風_最初].create_movie(ef_wind04, 1, ready_only = 1, real_time = 1, auto_free = 0)
	$stage.object[@ムービー_風_最初].y = 300
	$stage.object[@ムービー_風_最初].tr = 128
	$stage.object[@ムービー_風_最初].blend = 1
	
	// ムービー（風ループ）
	$stage.object[@ムービー_風上段_ループ].create_movie(ef_wind04, 1, 0, -50, real_time = 1, auto_free = 0)
	$stage.object[@ムービー_風上段_ループ].tr = 0
	$stage.object[@ムービー_風上段_ループ].blend = 1
	$stage.object[@ムービー_風上段_ループ].wipe_copy = 1
	$stage.object[@ムービー_風上段_ループ].f.resize(1)
	$stage.object[@ムービー_風上段_ループ].frame_action.start_real(-1, "$$fa_movie_loop", 7000)
	
	$stage.object[@ムービー_風下段_ループ].create_movie(ef_wind03, 1, 0, 600, real_time = 1, auto_free = 0)
	$stage.object[@ムービー_風下段_ループ].tr = 0
	$stage.object[@ムービー_風下段_ループ].blend = 4
	$stage.object[@ムービー_風下段_ループ].wipe_copy = 1
	$stage.object[@ムービー_風下段_ループ].f.resize(1)
	$stage.object[@ムービー_風下段_ループ].frame_action.start_real(-1, "$$fa_movie_loop", 9000)
}

// シーンオブジェクトのアニメーションを設定する
command $$set_scene_object_animation_all_clear(property $stage : stage)
{
	property $i
	
	// 空背景
	$stage.object[@イメージ_空背景].patno = 1
	$stage.object[@イメージ_空背景].set_scale(2000, 2000)
	$stage.object[@イメージ_空背景].scale_x_eve.set_real(1500, 12000, 0, 0)
	$stage.object[@イメージ_空背景].scale_y_eve.set_real(1500, 12000, 0, 0)
	$stage.object[@イメージ_空背景].bright = 255
	$stage.object[@イメージ_空背景].bright_eve.set_real(0, 2500, 0, 0)
	
	// フィルター
	$stage.object[@イメージ_フィルター].tr = 255
	$stage.object[@イメージ_フィルター].tr_eve.set_real(0, 1500, 0, 2)
	
	// 背景（キャラなし）
	$stage.object[@イメージ_背景キャラなし].tr = 0
	$stage.object[@イメージ_背景キャラなし].tr_eve.set_real(255, 2000, 5500, 0)
	$stage.object[@イメージ_背景キャラなし].y = 1080
	$stage.object[@イメージ_背景キャラなし].y_eve.set_real(0, 18000, 0, 0)
	$stage.object[@イメージ_背景キャラなし].bright = 255
	$stage.object[@イメージ_背景キャラなし].bright_eve.set_real(0, 4000, 6500, 0)
	
	// 背景（キャラあり）
	$stage.object[@イメージ_背景キャラあり].set_scale(1020, 1020)
	$stage.object[@イメージ_背景キャラあり].scale_x_eve.set_real(1000, 500, 14000, 2)
	$stage.object[@イメージ_背景キャラあり].scale_y_eve.set_real(1000, 500, 14000, 2)
	$stage.object[@イメージ_背景キャラあり].tr = 0
	$stage.object[@イメージ_背景キャラあり].tr_eve.set_real(255, 1000, 14000, 0)
	$stage.object[@イメージ_背景キャラあり].bright = 196
	$stage.object[@イメージ_背景キャラあり].bright_eve.set_real(0, 1000, 14000, 0)
	
	// ブランドロゴ
	// ※スタートシーンで作成済みのためfront
	front.object[@イメージ_ブランドロゴ].tr_eve.set_real(0, 2000, 2500, 0)
	
	// タイトルロゴ
	$stage.object[@イメージ_タイトルロゴ].tr = 0
	$stage.object[@イメージ_タイトルロゴ].tr_eve.set_real(255, 1500, 15000, 0)
	$stage.object[@イメージ_タイトルロゴ].set_scale(1250, 1250)
	$stage.object[@イメージ_タイトルロゴ].scale_x_eve.set_real(1000, 1500, 15000, 0)
	$stage.object[@イメージ_タイトルロゴ].scale_y_eve.set_real(1000, 1500, 15000, 0)
	
	// copyright
	$stage.object[@イメージ_コピーライト].layer = 1
	$stage.object[@イメージ_コピーライト].tr = 0
	$stage.object[@イメージ_コピーライト].tr_eve.set_real(255, 1000, 17000, 0)
	
	// ボタン背景
	$stage.object[@イメージ_ボタン背景].y_rep.resize(1)
	$stage.object[@イメージ_ボタン背景].y_rep[0] = 20
	$stage.object[@イメージ_ボタン背景].y_rep_eve[0].set_real(0, 1000, 18000, 0)
	$stage.object[@イメージ_ボタン背景].tr = 0
	$stage.object[@イメージ_ボタン背景].tr_eve.set_real(255, 1000, 18000, 0)
	
	// ボタン
	for( $i = @ボタン_メニュー_最初から, $i < @ボタン_メニュー_別ルートから始める３, $i += 1 )
	{
		if( $stage.object[$i].disp == 0 ) {
			continue
		}
		
		$stage.object[$i].tr = 0
		$stage.object[$i].tr_eve.set_real(255, 1000, 17000, 0)
		$stage.object[$i].y_rep[0] = 20
		$stage.object[$i].y_rep_eve[0].set_real(0, 1000, 17000, 0)
	}
	
	// ムービー（塵／空）
	$stage.object[@ムービー_塵_空].set_scale(2000, 2000)
	$stage.object[@ムービー_塵_空].scale_x_eve.set_real(1500, 10000, 0, 0)
	$stage.object[@ムービー_塵_空].scale_y_eve.set_real(1500, 10000, 0, 0)
	$stage.object[@ムービー_塵_空].tr_eve.set_real(0, 1000, 9500, 0)
	$stage.object[@ムービー_塵_空].resume_movie
	
	// ムービー（塵／遠）
	$stage.object[@ムービー_塵_遠].set_scale(1000, 1000)
	$stage.object[@ムービー_塵_遠].scale_x_eve.set_real(1500, 10000, 6500, 0)
	$stage.object[@ムービー_塵_遠].scale_y_eve.set_real(1500, 10000, 6500, 0)
	$stage.object[@ムービー_塵_遠].tr = 0
	$stage.object[@ムービー_塵_遠].tr_eve.set_real(255, 2000, 6500, 2)
	$stage.object[@ムービー_塵_遠].tr_rep[0] = 255
	$stage.object[@ムービー_塵_遠].tr_rep_eve[0].set_real(0, 2000, 15500, 2)
	$stage.object[@ムービー_塵_遠].resume_movie
	
	// ムービー（塵／近）
	$stage.object[@ムービー_塵_近].set_scale(1000, 1000)
	$stage.object[@ムービー_塵_近].scale_x_eve.set_real(1500, 10000, 6500, 0)
	$stage.object[@ムービー_塵_近].scale_y_eve.set_real(1500, 10000, 6500, 0)
	$stage.object[@ムービー_塵_近].tr = 0
	$stage.object[@ムービー_塵_近].tr_eve.set_real(255, 2000, 6500, 2)
	$stage.object[@ムービー_塵_近].tr_rep[0] = 255
	$stage.object[@ムービー_塵_近].tr_rep_eve[0].set_real(0, 2000, 15500, 2)
	$stage.object[@ムービー_塵_近].resume_movie
	
	// ムービー（風ループ）
	$stage.object[@ムービー_風上段_ループ].tr_eve.set_real( 32, 500, 10500, 0)
	$stage.object[@ムービー_風下段_ループ].tr_eve.set_real(128, 500, 10500, 0)
}


// ボタンを調整する
command $$adjust_menu_button(property $stage : stage)
{
	property $i
	property $len
	property $button_list : intlist
	property $button_x
	property $button_y
	property $button_margin
	property $total_button_size
	
	// ボタン間のマージン
	$button_margin = 10
	
	// ボタンの表示／非表示を設定する
	switch( @タイトルメニューレベル ) {
	case(0)		// 通常
		
		$stage.object[@ボタン_メニュー_別ルートから始める１].disp = 0
		$stage.object[@ボタン_メニュー_別ルートから始める２].disp = 0
		
		if( $$open_extra )
		{
			$button_list.resize(6)
			$button_list.sets(0,
				@ボタン_メニュー_最初から,
				@ボタン_メニュー_前回の続きから,
				@ボタン_メニュー_続きから,
				@ボタン_メニュー_コンフィグ,
				@ボタン_メニュー_エクストラ,
				@ボタン_メニュー_ゲーム終了
			)
		}
		else
		{
			$stage.object[@ボタン_メニュー_エクストラ].disp = 0
			
			$button_list.resize(5)
			$button_list.sets(0,
				@ボタン_メニュー_最初から,
				@ボタン_メニュー_前回の続きから,
				@ボタン_メニュー_続きから,
				@ボタン_メニュー_コンフィグ,
				@ボタン_メニュー_ゲーム終了
			)
		}
		
	case(1)		// エタニクルonly
		
		$stage.object[@ボタン_メニュー_最初から].disp = 0
		$stage.object[@ボタン_メニュー_別ルートから始める２].disp = 0
		$stage.object[@ボタン_メニュー_前回の続きから].disp = 0
		$stage.object[@ボタン_メニュー_続きから].disp = 0
		$stage.object[@ボタン_メニュー_コンフィグ].disp = 0
		$stage.object[@ボタン_メニュー_エクストラ].disp = 0
		$stage.object[@ボタン_メニュー_ゲーム終了].disp = 0
		
		$button_list.resize(1)
		$button_list.sets(0,
			@ボタン_メニュー_別ルートから始める１
		)
		
	case(2)		// エタニクル＋通常
		
		$stage.object[@ボタン_メニュー_最初から].disp = 0
		$stage.object[@ボタン_メニュー_別ルートから始める２].disp = 0
		
		$button_list.resize(6)
		$button_list.sets(0,
			@ボタン_メニュー_別ルートから始める１,
			@ボタン_メニュー_前回の続きから,
			@ボタン_メニュー_続きから,
			@ボタン_メニュー_コンフィグ,
			@ボタン_メニュー_エクストラ,
			@ボタン_メニュー_ゲーム終了
		)
		
	case(3)		// アネモイonly
		
		$stage.object[@ボタン_メニュー_最初から].disp = 0
		$stage.object[@ボタン_メニュー_別ルートから始める１].disp = 0
		$stage.object[@ボタン_メニュー_前回の続きから].disp = 0
		$stage.object[@ボタン_メニュー_続きから].disp = 0
		$stage.object[@ボタン_メニュー_コンフィグ].disp = 0
		$stage.object[@ボタン_メニュー_エクストラ].disp = 0
		$stage.object[@ボタン_メニュー_ゲーム終了].disp = 0
		
		$button_list.resize(1)
		$button_list.sets(0,
			@ボタン_メニュー_別ルートから始める２
		)
		
	case(4)		// アネモイ＋通常
		
		$stage.object[@ボタン_メニュー_最初から].disp = 0
		$stage.object[@ボタン_メニュー_別ルートから始める１].disp = 0
		
		$button_list.resize(6)
		$button_list.sets(0,
			@ボタン_メニュー_別ルートから始める２,
			@ボタン_メニュー_前回の続きから,
			@ボタン_メニュー_続きから,
			@ボタン_メニュー_コンフィグ,
			@ボタン_メニュー_エクストラ,
			@ボタン_メニュー_ゲーム終了
		)
		
	case(5)		// フルコンプ
		
		$button_list.resize(8)
		$button_list.sets(0,
			@ボタン_メニュー_最初から,
			@ボタン_メニュー_別ルートから始める１,
			@ボタン_メニュー_別ルートから始める２,
			@ボタン_メニュー_前回の続きから,
			@ボタン_メニュー_続きから,
			@ボタン_メニュー_コンフィグ,
			@ボタン_メニュー_エクストラ,
			@ボタン_メニュー_ゲーム終了
		)
	}
	
	// ボタンサイズを計算する
	$len = $button_list.get_size
	for( $i = 0, $i < $len, $i += 1 ) {
		$total_button_size += $stage.object[$button_list[$i]].get_size_x
	}
	
	// ボタンマージンを加算する
	$total_button_size += ($button_list.get_size - 1) * $button_margin
	
	// ボタンを配置する
	$button_x = (<SCREEN_WIDTH> - $total_button_size) / 2
	
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[$button_list[$i]].disp = 1
		$stage.object[$button_list[$i]].y_rep.resize(1)
		
		$stage.object[$button_list[$i]].x = $button_x
		$button_x += $stage.object[$button_list[$i]].get_size_x + $button_margin
		
		switch( @タイトルメニューレベル ) {
		case(0)		$button_y = 982
		case(1)		$button_y = 972
		case(2)		$button_y = 982
		case(3)		$button_y = 972
		case(4)		$button_y = 982
		case(5)		$button_y = 982
		}
		$stage.object[$button_list[$i]].y = $button_y
		$stage.object[$button_list[$i]].center_y = $stage.object[$button_list[$i]].get_size_y / 2
	}
}

// 指定した間隔でムービーをループ再生するフレームアクション
command $$fa_movie_loop(property $fa : frameaction, property $obj : object, property $loop_time)
{
	l[0] = $fa.counter.get / $loop_time
	
	if( l[0] != $obj.f[0] )
	{
		$obj.seek_movie(0)
		$obj.resume_movie
		
		$obj.f[0] = l[0]
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_menu_joypad_navigation(property $stage : stage)
{
	switch( @タイトルメニューレベル ) {
	case(0)		// 通常
	case(1)		// エタニクルonly
	case(2)		// エタニクル＋通常
	case(3)		// アネモイonly
	case(4)		// アネモイ＋通常
	case(5)		// フルコンプ
	}
	
	$stage.object[@ボタン_メニュー_最初から].joypad_up    = -1
	$stage.object[@ボタン_メニュー_最初から].joypad_down  = -1
	$stage.object[@ボタン_メニュー_最初から].joypad_left  = @ボタン_メニュー_ゲーム終了
	$stage.object[@ボタン_メニュー_最初から].joypad_right = @ボタン_メニュー_前回の続きから
	
	$stage.object[@ボタン_メニュー_前回の続きから].joypad_up    = -1
	$stage.object[@ボタン_メニュー_前回の続きから].joypad_down  = -1
	$stage.object[@ボタン_メニュー_前回の続きから].joypad_left  = @ボタン_メニュー_最初から
	$stage.object[@ボタン_メニュー_前回の続きから].joypad_right = @ボタン_メニュー_続きから
	
	$stage.object[@ボタン_メニュー_続きから].joypad_up    = -1
	$stage.object[@ボタン_メニュー_続きから].joypad_down  = -1
	$stage.object[@ボタン_メニュー_続きから].joypad_left  = @ボタン_メニュー_前回の続きから
	$stage.object[@ボタン_メニュー_続きから].joypad_right = @ボタン_メニュー_コンフィグ
	
	$stage.object[@ボタン_メニュー_コンフィグ].joypad_up    = -1
	$stage.object[@ボタン_メニュー_コンフィグ].joypad_down  = -1
	$stage.object[@ボタン_メニュー_コンフィグ].joypad_left  = @ボタン_メニュー_続きから
	$stage.object[@ボタン_メニュー_コンフィグ].joypad_right = @ボタン_メニュー_エクストラ
	
	$stage.object[@ボタン_メニュー_エクストラ].joypad_up    = -1
	$stage.object[@ボタン_メニュー_エクストラ].joypad_down  = -1
	$stage.object[@ボタン_メニュー_エクストラ].joypad_left  = @ボタン_メニュー_コンフィグ
	$stage.object[@ボタン_メニュー_エクストラ].joypad_right = @ボタン_メニュー_ゲーム終了
	
	$stage.object[@ボタン_メニュー_ゲーム終了].joypad_up    = -1
	$stage.object[@ボタン_メニュー_ゲーム終了].joypad_down  = -1
	$stage.object[@ボタン_メニュー_ゲーム終了].joypad_left  = @ボタン_メニュー_エクストラ
	$stage.object[@ボタン_メニュー_ゲーム終了].joypad_right = @ボタン_メニュー_最初から
	
	// 通常＋エクストラ解放
	if( @タイトルメニューレベル == 0 && $$open_extra == 0 )
	{
		$stage.object[@ボタン_メニュー_コンフィグ].joypad_right = @ボタン_メニュー_ゲーム終了
		
		$stage.object[@ボタン_メニュー_ゲーム終了].joypad_left  = @ボタン_メニュー_コンフィグ
	}
	
	// 通常＋エクストラ未解放
	elseif( @タイトルメニューレベル == 0 && $$open_extra == 1 )
	{
		// すでに設定済みなので何もしない
	}
	
	// エタニクルonly
	elseif( @タイトルメニューレベル == 1 )
	{
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_up    = -1
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_down  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_left  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_right = -1
	}
	
	// エタニクル＋通常
	elseif( @タイトルメニューレベル == 2 )
	{
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_up    = -1
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_down  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_left  = @ボタン_メニュー_ゲーム終了
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_right = @ボタン_メニュー_前回の続きから
		
		$stage.object[@ボタン_メニュー_前回の続きから].joypad_left  = @ボタン_メニュー_別ルートから始める１
		
		$stage.object[@ボタン_メニュー_ゲーム終了].joypad_right = @ボタン_メニュー_別ルートから始める１
	}
	
	// アネモイonly
	elseif( @タイトルメニューレベル == 3 )
	{
		// ジョイパッドで最初に選択されているボタンを設定する
		$$set_joypad_focus_button(@ボタン_メニュー_別ルートから始める２)
		
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_up    = -1
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_down  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_left  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_right = -1
	}
	
	// アネモイ＋通常
	elseif( @タイトルメニューレベル == 4 )
	{
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_up    = -1
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_down  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_left  = @ボタン_メニュー_ゲーム終了
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_right = @ボタン_メニュー_前回の続きから
		
		$stage.object[@ボタン_メニュー_前回の続きから].joypad_left  = @ボタン_メニュー_別ルートから始める２
		
		$stage.object[@ボタン_メニュー_ゲーム終了].joypad_right = @ボタン_メニュー_別ルートから始める２
	}
	
	// フルコンプ
	else
	{
		$stage.object[@ボタン_メニュー_最初から].joypad_right = @ボタン_メニュー_別ルートから始める１
		
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_up    = -1
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_down  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_left  = @ボタン_メニュー_最初から
		$stage.object[@ボタン_メニュー_別ルートから始める１].joypad_right = @ボタン_メニュー_別ルートから始める２
		
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_up    = -1
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_down  = -1
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_left  = @ボタン_メニュー_別ルートから始める１
		$stage.object[@ボタン_メニュー_別ルートから始める２].joypad_right = @ボタン_メニュー_前回の続きから
		
		$stage.object[@ボタン_メニュー_前回の続きから].joypad_left  = @ボタン_メニュー_別ルートから始める２
	}
	
}

//---------------------------------------------------------------------------
// パーティクル（キャラ表示時）
//---------------------------------------------------------------------------
command $$create_menu_particle_disp_chara(property $obj : object, property $start_time)
{
	$obj.disp = 1
	$obj.child.resize(2)
	$obj.blend = 1
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[0], ef_light_ball,		// 使用するオブジェクト, 画像
						64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						5000, 7000,						// 消滅する時間(最小、最大)
						4, 8, -10, -2					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[0],			// 使用するオブジェクト
								300, 1060, 700, 930		// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						25, 50, 25, 50				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj.child[0],					// 使用するオブジェクト
						$start_time, $start_time		// ディレイ時間(最小、最大)
	)
	// パーティクルの回転角を設定する
	$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
						-7200, 7200, -3600, 3600		// 回転角(最小、最大)
	)
	// パーティクルの外力を設定する
	$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
						-2, 1, -1, 0					// 外力(x最小、x最大、y最小、y最大)
	)
	// パーティクルのパターン番号を設定する
	$$set_particle_patno($obj.child[0], 				// 使用するオブジェクト
						0, 1							// パターン番号(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[0],					// 使用するオブジェクト
						"#00fa9a", "#7fff00", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルをワンショットにする
	$$set_particle_oneshot($obj.child[0])
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[1], ef_particle01,		// 使用するオブジェクト, 画像
						64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						5000, 7000,						// 消滅する時間(最小、最大)
						4, 6, -10, -2					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[1],			// 使用するオブジェクト
								760, 1520, 700, 930		// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						125, 150, 125, 150				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj.child[1],					// 使用するオブジェクト
						$start_time, $start_time		// ディレイ時間(最小、最大)
	)
	// パーティクルの回転角を設定する
	$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
						-7200, 7200, -3600, 3600		// 回転角(最小、最大)
	)
	// パーティクルの外力を設定する
	$$set_particle_outside_force($obj.child[1],			// 使用するオブジェクト
						-1, 2, -1, 0					// 外力(x最小、x最大、y最小、y最大)
	)
	// パーティクルのパターン番号を設定する
	$$set_particle_patno($obj.child[1], 				// 使用するオブジェクト
						0, 1							// パターン番号(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[1],					// 使用するオブジェクト
						"#00fa9a", "#7fff00", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルをワンショットにする
	$$set_particle_oneshot($obj.child[1])
	
	// パーティクルの実行
	$obj.child[0].frame_action.start_real(-1, "$$fa_particle")
	$obj.child[1].frame_action.start_real(-1, "$$fa_particle")
}

//---------------------------------------------------------------------------
// パーティクル（空）
//---------------------------------------------------------------------------
command $$create_menu_particle_sky(property $obj : object)
{
	$obj.disp = 0
	$obj.wipe_copy = 1
	$obj.child.resize(2)
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[0], ef_particle01,		// 使用するオブジェクト, 画像
						48, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						10000, 12000,					// 消滅する時間(最小、最大)
						-2, 2, -2, 2					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[0],			// 使用するオブジェクト
								0, 1920, 0, 200			// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						100, 125, 100, 125				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj.child[0],					// 使用するオブジェクト
						0, 8000							// ディレイ時間(最小、最大)
	)
	// パーティクルの回転角を設定する
	$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
						-3600, 3600, -3600, 3600		// 回転角(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[0],					// 使用するオブジェクト
						"#98fb98", "#1e90ff", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルのパターン番号を設定する
	$$set_particle_patno($obj.child[0], 				// 使用するオブジェクト
						0, 1							// パターン番号(最小、最大)
	)
	
	$obj.child[0].blend = 1									// 合成タイプを加算にする
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[1], ef_particle01,		// 使用するオブジェクト, 画像
						48, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						10000, 12000,					// 消滅する時間(最小、最大)
						-1, 1, -1, 1					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[1],			// 使用するオブジェクト
								0, 1920, 0, 200			// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						50, 75, 50, 75					// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj.child[1],					// 使用するオブジェクト
						0, 8000							// ディレイ時間(最小、最大)
	)
	// パーティクルの回転角を設定する
	$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
						-1800, 1800, -1800, 1800		// 回転角(最小、最大)
	)
	// パーティクルのパターン番号を設定する
	$$set_particle_patno($obj.child[1], 				// 使用するオブジェクト
						0, 1							// パターン番号(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[1],					// 使用するオブジェクト
						"#98fb98", "#1e90ff", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	
	$obj.child[1].blend = 1									// 合成タイプを加算にする
	$obj.child[1].tr = 128									// 不透明度を160=62%にする
}

command $$play_menu_particle_sky(property $obj : object)
{
	$obj.child[0].frame_action.start_real(-1, "$$fa_particle")	// パーティクルの実行
	$obj.child[1].frame_action.start_real(-1, "$$fa_particle")	// パーティクルの実行
	$obj.disp = 1
}

// パーティクル（アネモイ）
command $$create_anemoi_particle(property $obj : object)
{
	$obj.disp = 1
	$obj.child.resize(2)
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[0], ef_particle01,		// 使用するオブジェクト, 画像
						64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						1000, 3000,						// 消滅する時間(最小、最大)
						2, 6, -8, 4						// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[0],			// 使用するオブジェクト
								0, 1720, 56, 286		// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						150, 175, 150, 175				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj.child[0],					// 使用するオブジェクト
						1000, 3000						// ディレイ時間(最小、最大)
	)
	// パーティクルの回転角を設定する
	$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
						-1800, -1800, 1800, 1800		// 回転角(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[0],					// 使用するオブジェクト
						"#658bc5", "#63c8eb", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルのパターン番号を設定する
	$$set_particle_patno($obj.child[0], 				// 使用するオブジェクト
						0, 1							// パターン番号(最小、最大)
	)
	// 自動縮小アニメーションを設定する
	$$set_particle_auto_scale($obj.child[0], 0)
	// パーティクルをワンショットにする
	$$set_particle_oneshot($obj.child[0])
	
	$obj.child[0].blend = 1									// 合成タイプを加算にする
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[1], ef_particle01,		// 使用するオブジェクト, 画像
						64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						1000, 3000,						// 消滅する時間(最小、最大)
						1, 4, -5, 2						// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[1],			// 使用するオブジェクト
								0, 1720, 56, 286		// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						100, 150, 100, 150				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj.child[1],					// 使用するオブジェクト
						1000, 3000						// ディレイ時間(最小、最大)
	)
	// パーティクルの回転角を設定する
	$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
						-1800, -1800, 1800, 1800		// 回転角(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[1],					// 使用するオブジェクト
						"#98fb98", "#1e90ff", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルのパターン番号を設定する
	$$set_particle_patno($obj.child[1], 				// 使用するオブジェクト
						0, 1							// パターン番号(最小、最大)
	)
	// 自動縮小アニメーションを設定する
	$$set_particle_auto_scale($obj.child[1], 0)
	// パーティクルをワンショットにする
	$$set_particle_oneshot($obj.child[1])
	
	$obj.child[1].blend = 1									// 合成タイプを加算にする
}
