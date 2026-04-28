// 子育て編→シルバー編繋ぎ

#inc_start
	
	#replace	@イメージ_背景				0
	#replace	@イメージ_ボタン背景		1
	#replace	@ムービー_レンズフレア		2
	#replace	@ムービー_風				3
	#replace	@ボタン_アライブ 			11
	
	// 変数
	#property	$select_btn				// 選択しているボタン
	
#inc_end


#z00

// タイトルを空文字にする
set_title("")

// ユーザー制御を不可能にする
$$user_control_disabled

@bg(bg_siro, 4)

@bgm(bgm01a)

@bg_zoom(bg702_30, 6, 1100, 1000, 10000)
@waitkey(1000)

@bg_move(bg018_01, 6, 480, 0, -480, 0, 40000)
@waitkey(2000)

@bg_move(bg999_02, 6, 0, -270, 0, 270, 30000)
@waitkey(2000)

@bg_zoom(bg703_03, 6, 1100, 1000, 10000)
@waitkey(2000)

@bg_move(bg999_80, 6, 0, 0, 0, -270, 15000)
@waitkey(2000)

@bg_move(bg702_28, 6, 0, -130, 0, 130, 20000, 0, 1250)
@waitkey(2000)

@bg_zoom(bg703_02, 6, 1100, 1000, 10000)
@waitkey(2000)

back.object[@ムービー_レンズフレア].create_movie(ef_meteor01, 1, auto_free = 0, ready_only = 1)
back.object[@ムービー_レンズフレア].y = 200
back.object[@ムービー_レンズフレア].blend = 1
back.object[@ムービー_レンズフレア].tr = 128

@bg_move(bg999_09, 6, 0, -270, 0, 270, 30000)
front.object[@ムービー_レンズフレア].resume_movie
@waitkey(2000)

@bg_move(bg018_07, 6, 0, 0, 0, -270, 15000)
@waitkey(2000)

@bg_move(bg999_02, 6, -480, 0, 480, 0, 40000)
@waitkey(2000)

@bg_zoom(bg702_80, 6, 1100, 1000, 6000)
@waitkey(3000)

@cg(bg702_25, 6)

@se_volume(192, 0)
@se(ANB_outdoor_wheatfield_LOOP, 5000)

@bg_move(bg707_07, 6, 0, -500, 0, 0, 30000)
@waitkey(13000)

@se_stop(5000)

@bg(bg_siro, 6)
@waitkey(500)

@bg_zoom(bg708_11, -1, 1100, 1000, 15000)
@bright_in(3000)
@waitkey(6000)

@se_stop(0)
@se_volume_default(0)

@bg(bg_siro, 7)

// ムービー（レンズフレア）
back.object[@ムービー_レンズフレア].create_movie(ef_sun12, 1, auto_free = 0, ready_only = 1)
back.object[@ムービー_レンズフレア].scale_x = -1000
back.object[@ムービー_レンズフレア].x = <SCREEN_WIDTH>
back.object[@ムービー_レンズフレア].layer = <LAYER_ALL_FILTER>
$$set_screen_scale(back.object[@ムービー_レンズフレア])

// ムービー（風）
back.object[@ムービー_風].create_movie(ef_wind04, 1, ready_only = 1, real_time = 1)
back.object[@ムービー_風].y = 300
back.object[@ムービー_風].tr = 128
back.object[@ムービー_風].blend = 1
back.object[@ムービー_風].wipe_copy = 1

@bg_zoom(bg018_02, -1, 1050, 1000, 3000, 2)
@bright_in(5000, 0)

timewait(1000)

front.object[@ムービー_風].resume_movie

timewait(3000)

// 背景を作成する
back.object[@イメージ_背景].create(bg018_02, 1)

// 背景を作成する
back.object[@イメージ_ボタン背景].create(_menu_btn_bg, 1, 0, 818)
back.object[@イメージ_ボタン背景].y_rep.resize(1)
back.object[@イメージ_ボタン背景].y_rep[0] = 20
back.object[@イメージ_ボタン背景].y_rep_eve[0].set_real(0, 1500, 0, 0)
back.object[@イメージ_ボタン背景].tr = 0
back.object[@イメージ_ボタン背景].tr_eve.set_real(255, 1500, 0, 0)

// ボタンを作成する
$$create_ui_button(back.object[@ボタン_アライブ], _menu_route3_btn, 862, 949, @ボタン_アライブ, <OBJBTN_GROUP_NO_SELECT>, -1)
back.object[@ボタン_アライブ].y_rep.resize(1)
back.object[@ボタン_アライブ].y_rep[0] = 20
back.object[@ボタン_アライブ].y_rep_eve[0].set_real(0, 1000, 2000, 0)
back.object[@ボタン_アライブ].tr = 0
back.object[@ボタン_アライブ].tr_eve.set_real(255, 1000, 2000, 0)

// ワイプ
@wipe(3)

// ユーザー制御を可能にする
$$user_control_enabled

script.set_msg_back_disable				// メッセージバックを禁止する
$$menu_control_enabled

// ジョイパッドで最初に選択されているボタンを設定する
$$set_joypad_focus_button(@ボタン_アライブ)

// 入力制御を開始する
$$input_start(front, <OBJBTN_GROUP_NO_SELECT>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <OBJBTN_GROUP_NO_SELECT>)
	
	if( $select_btn == @ボタン_アライブ )
	{
		@se(SE_arrive_button)
		break
	}
	
	// キャンセルは何も押していないとして処理する
	if( $select_btn == -1 )
	{
		$$input_start(front, <OBJBTN_GROUP_NO_SELECT>)
		$select_btn = -2
	}
	
	// 何も押していないときは画面の更新のみ
	if( $select_btn == -2 )
	{
		input.next		// 入力の更新
		disp			// 画面の更新
		
		continue
	}
}

@all_sound_stop(8000)
@fade_w(7)
@waitkey(3000)

$$menu_control_disabled
script.set_msg_back_enable				// メッセージバックを許可する

return
