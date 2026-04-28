//-----------------------------------------------------------------
// クイックロード
//-----------------------------------------------------------------
#z00

$$quick_load


//-----------------------------------------------------------------
// 共通から
//-----------------------------------------------------------------
#z01

jump("001_シナリオフロー", 11)


//-----------------------------------------------------------------
// ＵＭＡレースデバッグ用
//-----------------------------------------------------------------
#z02

#inc_start
	#macro	@ＵＭＡレースデバッグ設定
		@シーン開始
		@日付_月 = 7
		@日付_日 = 20
		@日付_時間帯 = @午前
		@ＵＭＡデバッグ参加
		@ＵＭＡレースユーザー制御開始

#inc_end

@start_debug_shortcut

@ミニゲーム用乱数初期化
@ＵＭＡレースに参加している = 1
@ＵＭＡレースデータ初期化

@ＵＭＡレースユーザー制御開始

gosub #create_deb_data

$$reset_entry_race_data

farcall(___mng_urace_flow_race)
farcall(___mng_urace_flow_result)

goto #z02

#create_deb_data

$$init_entry_race_data

l[0] = 2	// race_id

$$set_entry_race_id(l[0])

$$create_wild_uma_data(32, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(31, 0)	$$add_my_uma_from_wild_uma(0)
;$$create_wild_uma_data(30, 0)	$$add_my_uma_from_wild_uma(0)
;$$create_wild_uma_data(29, 0)	$$add_my_uma_from_wild_uma(0)
;$$create_wild_uma_data(28, 0)	$$add_my_uma_from_wild_uma(0)

$$set_uma_life(1, 0, 10)
$$set_uma_speed(1, 0, 3)

$$set_entry_owner_uma_list(0, 0, 0)
$$set_entry_owner_uma_list(0, 1, 1)
$$set_entry_owner_uma_list(0, 2, 2)
$$set_entry_owner_uma_list(0, 3, 3)
$$set_entry_owner_uma_list(0, 4, 4)

// 参加者を設定する
$$set_urace_npc_race_entry_data

for( l[2] = 0, l[2] < 6, l[2] += 1 )
{
	for( l[3] = 0, l[3] < 12, l[3] += 1 )
	{
		b[l[2] * 12 + l[3]] = $$get_entry_owner_uma_list(l[2], l[3])
	}
}

return

/*
障害物配置ルーチン

アイテム配置ルーチン

プレイヤーインプット
	アイテム使用
	交代
		クールタイム発生

レースUI
	順位
		残りuma
	上／下ボタン
	アイテムボタン
	next uma

ポーズUI
	オーナー
		メンバー
			スキル

厩舎UI
	交代並び
		ソート×

NPCルーチン
	弱
	普
	強

障害物当たり判定
妨害系当たり判定
	lane & mileage

-owner
	-umalist
	-umaindex
	-lane
	-mileage
	-skill
	-item
	-runnningumadata
		-hp
		-speed
		-accel
		-attack
		-actionstate
			-run
			-change lane
			-damage(stun)
			-dead
			-change uma

trap_data
	-speedup

item_data
	-wing
	-banana
	-lane atk r
	-lane atk g
	-lane atk b
	-thunder
	
*/

@日付_月 = 7
@日付_日 = 14
@日付_時間帯 = @午前
if( 1 ) {
	@ＵＭＡデバッグ参加
}

@ＵＭＡレースユーザー制御開始
$$init_entry_race_data

if( 0 )
{
	l[0] = 14	// race_id
	$$set_entry_race_id(l[0])
	
	switch( l[0] ) {
	case(1)		$$create_wild_uma_data(1, 0)
	case(2)		$$create_wild_uma_data(2, 0)
	case(3)		$$create_wild_uma_data(3, 0)
	case(4)		$$create_wild_uma_data(1, 0)
	case(5)		$$create_wild_uma_data(12, 0)
	case(6)		$$create_wild_uma_data(11, 0)
	case(7)		$$create_wild_uma_data(11, 0)
	case(8)		$$create_wild_uma_data(10, 0)
	case(9)		$$create_wild_uma_data(23, 0)
	case(10)	$$create_wild_uma_data(19, 0)
	case(11)	$$create_wild_uma_data(18, 0)
	case(12)	$$create_wild_uma_data(27, 0)
	case(13)	$$create_wild_uma_data(28, 0)
	case(14)	$$create_wild_uma_data(26, 0)
	case(15)	$$create_wild_uma_data(29, 0)
	}
	$$add_my_uma_from_wild_uma(0)
	/*
	switch( l[0] ) {
	case(1)		l[1] = 10	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(2)		l[1] = 13	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(3)		l[1] = 20	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(4)		l[1] = 23	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(5)		l[1] = 26	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(6)		l[1] = 35	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(7)		l[1] = 43	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(8)		l[1] = 50	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(9)		l[1] = 55	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(10)	l[1] = 65	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(11)	l[1] = 70	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(12)	l[1] = 80	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(13)	l[1] = 83	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(14)	l[1] = 86	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	case(15)	l[1] = 90	$$set_uma_speed(1, 1, l[1])		$$set_uma_stamina(1, 1, l[1])		$$set_uma_technique(1, 1, l[1])
	}
	*/
	
	$$create_npc_uma_data($$get_db_owner_uma_list(l[0], 0), 50)
	$$create_npc_uma_data($$get_db_owner_uma_list(l[0], 1), 51)
	$$create_npc_uma_data($$get_db_owner_uma_list(l[0], 2), 52)
	
	$$entry_urace(1, 1, 1)
	$$entry_urace($$get_db_race_entry_owner(l[0], 0), 50, 0)
	$$entry_urace($$get_db_race_entry_owner(l[0], 1), 51, 2)
	$$entry_urace($$get_db_race_entry_owner(l[0], 2), 52, 3)
}
else
{
	$$set_entry_race_id(6)
	
	$$create_wild_uma_data(2, 0)
	$$add_my_uma_from_wild_uma(0)
	
	$$create_npc_uma_data($$get_db_owner_uma_list(1, 0), 50)
;	$$create_npc_uma_data($$get_db_owner_uma_list(1, 1), 51)
;	$$create_npc_uma_data($$get_db_owner_uma_list(1, 2), 52)
	$$create_npc_uma_data($$get_db_owner_uma_list(8, 2), 51)
	$$create_npc_uma_data($$get_db_owner_uma_list(10, 1), 52)
	
	$$set_uma_life(1, 1, 40)
	$$set_uma_speed(1, 1, 40)
	$$set_uma_attack(1, 1, 40)
	$$set_uma_accel(1, 1, 40)
	$$set_uma_ground_type(1, 1, 2, 3)

;	$$set_uma_fatigue(1, 1, 5)
	
	$$entry_urace(1, 1, 1)
	$$entry_urace(2, 50, 0)
	$$entry_urace(3, 51, 2)
	$$entry_urace(4, 52, 3)
}

farcall(___mng_urace_flow_paddock)
farcall(___mng_urace_flow_race)
farcall(___mng_urace_flow_result)

goto #z02

//-----------------------------------------------------------------
// ＵＭＡレースフローテスト
//-----------------------------------------------------------------
#z03

@ＵＭＡレースデバッグ設定

gosub #create_deb_data

$$reset_entry_race_data

farcall(___mng_urace_flow_paddock)
farcall(___mng_urace_flow_race)
farcall(___mng_urace_flow_result)

goto #z03

//-----------------------------------------------------------------
// ＵＭＡレースリザルトテスト
//-----------------------------------------------------------------
#z04

@シーン開始

@日付_月 = 7
@日付_日 = 14
@日付_時間帯 = @午前

@ＵＭＡデバッグ参加
@ＵＭＡレースユーザー制御開始

gosub #create_deb_data

$$reset_entry_race_data

$$init_running_uma_data(0)
$$init_running_uma_data(1)
$$init_running_uma_data(2)
$$init_running_uma_data(3)
$$init_running_uma_data(4)
$$init_running_uma_data(5)
$$set_entry_owner_goal_order(0, 1)
$$set_entry_owner_goal_order(1, 2)
$$set_entry_owner_goal_order(2, 3)
$$set_entry_owner_goal_order(3, 4)
$$set_entry_owner_goal_order(4, 5)
$$set_entry_owner_goal_order(5, 6)

farcall(___mng_urace_flow_result)

goto #z04

//-----------------------------------------------------------------
// ＵＭＡレース掲示板テスト
//-----------------------------------------------------------------
#z05

@日付_月 = 7
@日付_日 = 21
@日付_時間帯 = @午前

@ＵＭＡデバッグ参加
;@ＵＭＡデバッグ_ＵＭＡを適当に追加

$$create_wild_uma_data(1, 0)
$$add_my_uma_from_wild_uma(0)

$$create_wild_uma_data(3, 0)
$$add_my_uma_from_wild_uma(0)

$$create_wild_uma_data(5, 0)
$$add_my_uma_from_wild_uma(0)

$$create_wild_uma_data(7, 0)
$$add_my_uma_from_wild_uma(0)

$$create_wild_uma_data(9, 0)
$$add_my_uma_from_wild_uma(0)

$$create_wild_uma_data(22, 0)
$$add_my_uma_from_wild_uma(0)

;$$set_uma_skill(1, 1, 0, 41)
;$$set_uma_skill(1, 1, 1, 42)

;$$set_uma_skill(1, 0, 0, 20)
;$$set_uma_skill(1, 0, 1, 21)
;$$set_uma_skill(1, 0, 0, 24)
;$$set_uma_skill(1, 0, 1, 25)
;$$set_uma_skill(1, 0, 0, 20)
;$$set_uma_skill(1, 0, 1, 21)

$$add_urace_honor(9999)

$$add_urace_item(1, 1)
$$add_urace_item(2, 1)
$$add_urace_item(3, 1)
$$add_urace_item(4, 1)
$$add_urace_item(5, 1)
$$add_urace_item(6, 1)
$$add_urace_item(7, 1)
$$add_urace_item(8, 1)
$$add_urace_item(9, 1)
$$add_urace_item(10, 1)
$$add_urace_item(11, 1)
$$add_urace_item(12, 1)
$$add_urace_item(13, 1)
$$add_urace_item(14, 1)
$$add_urace_item(15, 1)
$$create_bbs_hunter_list

$$create_bbs_base_data
$$create_bbs_race_list
farcall(___mng_urace)

goto #z05


//-----------------------------------------------------------------
// ＵＭＡレースエフェクトテスト
//-----------------------------------------------------------------
#z06

jump(___mng_urace_grp_test)

goto #z06

//-----------------------------------------------------------------
// ＵＭＡレース捕獲テスト
//-----------------------------------------------------------------
#z07

@ＵＭＡレースデバッグ設定

@ＵＭＡデバッグ参加
;@ＵＭＡデバッグ_ＵＭＡを適当に追加

$$deb_hunter_list
;$$create_bbs_hunter_list

$$set_bbs_hunter_request(0, 1)
$$set_bbs_hunter_request(1, 1)
;$$set_bbs_hunter_request(2, 1)

farcall(___mng_urace, 10)
farcall(___mng_urace)

goto #z07

//-----------------------------------------------------------------
// ＵＭＡレースグラフィックテスト
//-----------------------------------------------------------------
#z08

@日付_月 = 7
@日付_日 = 14
@日付_時間帯 = @午前

@ＵＭＡデバッグ参加
@ＵＭＡレースユーザー制御開始
$$init_entry_race_data

@選択肢 = selbtn(芝, ダート, 水面, 宇宙)@選択肢終了
switch( @選択 ) {
case(0)		$$set_entry_race_id(1)
case(1)		$$set_entry_race_id(2)
case(2)		$$set_entry_race_id(3)
case(3)		$$set_entry_race_id(15)
}

$$create_wild_uma_data(2, 0)
$$add_my_uma_from_wild_uma(0)

$$create_npc_uma_data($$get_db_owner_uma_list(1, 0), 50)
$$create_npc_uma_data($$get_db_owner_uma_list(8, 2), 51)
$$create_npc_uma_data($$get_db_owner_uma_list(10, 1), 52)

$$set_uma_life(1, 1, 40)
$$set_uma_speed(1, 1, 40)
$$set_uma_attack(1, 1, 40)
$$set_uma_accel(1, 1, 40)
$$set_uma_ground_type(1, 1, 2, 3)

$$entry_urace(1, 1, 1)
$$entry_urace(2, 50, 0)
$$entry_urace(3, 51, 2)
$$entry_urace(4, 52, 3)

farcall(___mng_urace_flow_paddock)
farcall(___mng_urace_flow_race)
farcall(___mng_urace_flow_result)

goto #z08



//-----------------------------------------------------------------
// ＵＭＡレース／厩舎
//-----------------------------------------------------------------
#z10

@ＵＭＡレースデバッグ設定

$$create_wild_uma_data(27, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(26, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)

farcall(___mng_urace_flow_barn)

goto #z10


//-----------------------------------------------------------------
// ＵＭＡレース／スケジュール
//-----------------------------------------------------------------
#z11

@ＵＭＡレースデバッグ設定

farcall(___mng_urace_flow_schedule)

goto #z11


//-----------------------------------------------------------------
// ＵＭＡレース／メダル
//-----------------------------------------------------------------
#z12

@ＵＭＡレースデバッグ設定

farcall(___mng_urace_flow_medal)

goto #z12

//-----------------------------------------------------------------
// ＵＭＡレース／図鑑
//-----------------------------------------------------------------
#z13

@ＵＭＡレースデバッグ設定

l[0] = selbtn("図鑑フラグリセット", "そのまま")
if( l[0] == 0 ) {
	$$init_uma_library_flag
	リセットR
}

farcall(___mng_urace_flow_library)

goto #z13

//-----------------------------------------------------------------
// ＵＭＡレース／名声
//-----------------------------------------------------------------
#z14

@ＵＭＡレースデバッグ設定

l[0] = 10
$$add_urace_honor(l[0])
farcall(___mng_urace_flow_honor_info, 0, l[0])

goto #z14

//-----------------------------------------------------------------
// ＵＭＡレース／編成
//-----------------------------------------------------------------
#z15

@シーン開始

@日付_月 = 7
@日付_日 = 14
@日付_時間帯 = @午前

@ミニゲーム用乱数初期化
@ＵＭＡレースに参加している = 1
@ＵＭＡレースデータ初期化
@ＵＭＡレースユーザー制御開始

$$create_wild_uma_data(32, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(31, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(30, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(29, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(28, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(27, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(26, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(25, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(24, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(23, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(22, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(21, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(20, 0)	$$add_my_uma_from_wild_uma(0)
$$create_wild_uma_data(19, 0)	$$add_my_uma_from_wild_uma(0)

$$set_my_deck(0, 13)
$$set_my_deck(1, 12)
$$set_my_deck(2, 11)
$$set_my_deck(3, 10)
$$set_my_deck(4, 9)
$$set_my_deck(5, 8)
$$set_my_deck(6, 7)
$$set_my_deck(7, 6)
$$set_my_deck(8, 5)
$$set_my_deck(9, 4)
$$set_my_deck(10, 3)
$$set_my_deck(11, 2)

farcall(___mng_urace_flow_edit_deck, 0)

goto #z14









//-----------------------------------------------------------------
// ヘビヘビパニックデバッグ用
//-----------------------------------------------------------------
#z20

@シーン開始

@ミニゲーム用乱数初期化

farcall(___mng_hhp, 1, 1)

goto #z20


//-----------------------------------------------------------------
// ヘビヘビパニック（サポート選択テスト）
//-----------------------------------------------------------------
#z21

@シーン開始
syscom.set_syscom_menu_disable
syscom.set_hide_mwnd_enable_flag(0)

@ミニゲーム用乱数初期化

$$set_front_wipe_copy_all(0)

$$init_hhp_player_data
$$add_hhp_skill_max(2)

farcall(___mng_hhp_flow_support_select)

@fade(0)

goto #z21


//-----------------------------------------------------------------
// ヘビヘビパニック（リザルトテスト）
//-----------------------------------------------------------------
#z22

@シーン開始
syscom.set_syscom_menu_disable
syscom.set_hide_mwnd_enable_flag(0)

@ミニゲーム用乱数初期化

$$init_hhp_player_data

$$set_hhp_play_level(10)
$$add_hhp_skill_max(2)
$$add_hhp_score(12345678)
$$add_hhp_player_combo(0)
$$add_hhp_player_combo(24)
$$add_hhp_player_combo(159)
$$on_hhp_skill(0)
$$on_hhp_skill(1)
$$on_hhp_skill(2)
for( l[0] = 1, l[0] <= 19, l[0] += 1 ) {
	$$powerup_hhp_item(l[0])
}
$$set_hhp_play_result(<HHP_PLAY_RESULT_LOSE>)
$$set_hhp_play_result(<HHP_PLAY_RESULT_WIN>)
farcall(___mng_hhp_flow_result, 1)

goto #z22


//-----------------------------------------------------------------
// ヘビヘビパニックフローテスト用
//-----------------------------------------------------------------
#z23

jump("001_シナリオフロー", 11)

//-----------------------------------------------------------------
// ヘビヘビパニックチュートリアル操作用
//-----------------------------------------------------------------
#z24

$$set_hhp_tutorial_flag(0)

goto #z20

//-----------------------------------------------------------------
// ヘビヘビパニックチュートリアル操作用
//-----------------------------------------------------------------
#z25

@シーン開始
$$init_hhp_skill_data

$$set_hhp_tutorial_flag(0)

front.object[0].create(__mng_hp_bg, 1, 0, 0, 1)
front.object[1].create(__mng_hp_bg, 1, 0, 0, 0)

"ready"

R

;$$play_hhp_skill_effect(front.object[5])
$$spawn_treasure(front.object[5], 960, 540)
;$$spawn_enemy_shield_break(front.object[5], 960, 540)

"start"
R

goto #z25




//-----------------------------------------------------------------
// 表示速度のテスト
//-----------------------------------------------------------------
#z74

@シーン開始

@bg(bg007,3)あR
@bg_pan(bg006,3)あR
@bg(bg001,3)あR
@bs(sp11_01)あR
@bs(sp, ai11_01@r1)あR
@cg(cg_sp01_0101,3)あR
@cg(cg_sp01_0102,3)あR
@bg(bg006,3)あR


goto #z74


//-----------------------------------------------------------------
// アイテム獲得のテスト
//-----------------------------------------------------------------
#z75

@シーン開始

close
@bg(bg007,99)
@アイテムを獲得("塩と神酒を手に入れた", 0)
あああR

goto #z75


//-----------------------------------------------------------------
// アイキャッチのテスト
//-----------------------------------------------------------------
#z76

@シーン開始

;back.object[0].create(a, 1)
@bg(bg002)
@bg(bg003)
@bg(bg004)
@bg(bg005)
@bg(bg006)
@bg(bg007)
あR
;@アイキャッチ("0712", b_bg009)

goto #z76


//-----------------------------------------------------------------
// バックログのテスト
//-----------------------------------------------------------------
#z77

@シーン開始

#inc_start
	// 日付設定
	#macro	@set_title(@title, @date, @eyecatch(1))
		set_title(@title)
		$$set_date(@date)
		if( @eyecatch ) {
			@アイキャッチ(@date)
		}
#inc_end

@シーン開始
;R
@bg(bg007,99)

set_title(ああああああああああああああああああああああああああ)
ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああR

【スピカ／少女】「言ってみなさい。何歳だと思っているわけ」R
@set_title("Ｄａｙ １",   "0702")

@bg(bg_kuro,5)

@bg(bg007,99)

慎重に答えないと……R

@set_title("Ｄａｙ １",   "0703")

慎重に答えないと……R

script.set_auto_savepoint_off

慎重に答えないと……R

@bg(bg007,99)

@選択肢 = selbtn(
	生意気盛りの１０歳ああああああああああああああ,
	夢見る年頃の１５歳,
	少し疲れた２１歳,
	なんとびっくり３５歳
)@選択肢終了

慎重に答えないと……R

close

KOE(000200259,001)【スピカ／少女】「言ってみなさい。何歳だと思っているわけ」R

close

慎重に答えないと……R

script.set_auto_savepoint_on

KOE(000200259,001)ああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああR

KOE(000200259,001)あああああR
KOE(000200259,001)あああああR
KOE(000200259,001)あああああR
KOE(000200259,001)【スピカ／少女】「言ってみなさい。何歳だと思っているわけ」R

【麦】「君はさながら……」R

KOE(000200259,001)【スピカ／少女】「言ってみなさい。何歳だと思っているわけ」R
KOE(000200259,001)【スピカ／少女】「言ってみなさい。何歳だと思っているわけ」R
KOE(000200259,001)【スピカ／少女】「言ってみなさい。何歳だと思っているわけ」R

@選択肢 = selbtn(
	生意気盛りの１０歳,
	夢見る年頃の１５歳,
	少し疲れた２１歳,
	なんとびっくり３５歳
)@選択肢終了

あR

goto #z77


//-----------------------------------------------------------------
// フェイスウィンドウのテスト
//-----------------------------------------------------------------
#z78

@シーン開始

@bg(bg007,99)

@bs(ai11_01, hi11_01)
@bs(sp11_01, hi11_01)

@face(sp11_01)あR
@face(sp21_01)あR
@face(ai11_01)あR
@face(ai21_01)あR
@face(hi11_01)あR
@face(hi21_01)あR
@face(ky11_01)あR
@face(ky21_01)あR
@face(rk11_01)あR
@face(rk21_01)あR
@face(fm11_01)あR
@face(ri11_01)あR
@face(td11_01)あR
@face(kr11_01)あR
@face(hr11_01)あR
@face(ch11_01)あR
@face(kn11_01)あR
@face(mk11_01)あR
@face(mn11_01)あR
@face(tm11_01)あR
@face(em11_01)あR
@face(hn11_01)あR

てすとR

goto #z78

//-----------------------------------------------------------------
// ゲーム本編系のテスト用
//-----------------------------------------------------------------
#z79


@シーン開始
;　　　;夕

syscom.set_syscom_menu_disable			// システムコマンドを禁止する

@bg(bg001,99)

@face(sp11_01)
ああああああああああああああR

// バロン／用具あり
@face(br11_01)
ああああああああああああああR

// バロン／用具なし
@face(br12_01)
ああああああああああああああR

// 愛乃傘
@face(au11_01)
ああああああああああああああR

ああああああああああああああR
あああああああああああああR
ああああああああああああR
ああああああああああああR
ああああああああああああああR
ああああああああああああR
ああああああああああR
ああああああああああああああR
あああああああああああああR
ああああああああああああR
ああああああああああああああR
あああああああああああああR
ああああああああああああR
ああああああああああああああR
あああああああああああああR
ああああああああああああR
ああああああああああああああR
あああああああああああああR
あR

//-------------------------------------------------------------------------------------
goto #z79

front.object[3].create_movie_loop(ef_dark_ball, 1)
front.object[3].blend = 0
てすとR

front.object[3].create_movie_loop(ef_dark_wind01, 1)
front.object[3].blend = 1
front.object[3].tr = 60
てすとR

front.object[4].create_movie_loop(ef_dark_wind01, 1)
front.object[4].blend = 3
てすとR


@bg(_menu_bg01, 99)
$$create_menu_particle_all(front.object[2], 0)

あR


command $$create_menu_particle_all(property $obj : object, property $start_time)
{
	$obj.disp = 1
	$obj.child.resize(2)
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[0], ef_light_ball,		// 使用するオブジェクト, 画像
						64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						5000, 7000,						// 消滅する時間(最小、最大)
						-3, 3, -3, 3					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[0],			// 使用するオブジェクト
								100, 1820, 100, 980		// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						50, 75, 50, 75					// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[0],					// 使用するオブジェクト
						"#98fb98", "#1e90ff", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルをワンショットにする
	$$set_particle_oneshot($obj.child[0])
	
	$obj.child[0].blend = 1									// 合成タイプを加算にする
	$obj.child[0].frame_action.start(-1, "$$fa_particle")	// パーティクルの実行
	
	// パーティクル(直線)を作成する
	$$create_particle($obj.child[1], ef_light_ball,		// 使用するオブジェクト, 画像
						64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						5000, 7000,						// 消滅する時間(最小、最大)
						-2, 2, -2, 2					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	// パーティクルの発生範囲を矩形にする
	$$set_particle_shape_to_box($obj.child[1],			// 使用するオブジェクト
								100, 1820, 100, 980		// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						25, 50, 25, 50					// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj.child[1],					// 使用するオブジェクト
						"#98fb98", "#1e90ff", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)
	// パーティクルをワンショットにする
	$$set_particle_oneshot($obj.child[1])
	
	$obj.child[1].blend = 1									// 合成タイプを加算にする
	$obj.child[1].tr = 128									// 不透明度を160=62%にする
	$obj.child[1].frame_action.start(-1, "$$fa_particle")	// パーティクルの実行
}



@bg(bg005_03)

@黒い突風

あR


@bg(bg004_03)

あR

@黒い突風終了

@bg(bg005_03)

あR


#inc_start

#macro	@黒い突風(@wipe_no(102), @wipe_time(500))
	back.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_dark_wind01, 1)
	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
	back.object[<OBJ_APP_EFFECT01>].blend = 3
	back.object[<OBJ_APP_EFFECT01>].layer = <LAYER_CG> + 1
	@wipe(@wipe_no, @wipe_time)
	@揺れ弱ループ
	
#macro	@黒い突風終了
	@揺れループ停止
	front.object[<OBJ_APP_EFFECT01>].wipe_copy = 0

#inc_end

@bs(bs1_ky11_01)

あR

@bs(ky21_01)

あR

$$create_light_leaf_particle2(back.object[<OBJ_APP_EFFECT01>], 0)
back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
back.object[<OBJ_APP_EFFECT01>].dark = 224
command $$create_light_leaf_particle2(property $obj : object, property $type)
{
	
	// パーティクル(放射)を作成する
	$$create_particle_radial($obj, ef_light_ball,		// 使用するオブジェクト, 画像
							80, 1,						// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1000, 1500,					// 消滅する時間(最小、最大)
							300, 800					// 動きの速さ(最小、最大)
	)
	// パーティクルの発生範囲を円にする
	$$set_particle_shape_to_circle($obj,				// 使用するオブジェクト
								260						// 半径
	)
	// パーティクルの拡縮率を設定する
	$$set_particle_scale($obj, 0, 						// 使用するオブジェクト, アスペクト比を維持するか
						500, 1500, 500, 1500			// 拡縮率(x最小、x最大、y最小、y最大)
	)
	// [パーティクルの回転角を設定する]
	$$set_particle_rotate($obj, 0,						// 使用するオブジェクト, 角度を固定するか
						-3600, 3600, -7200, 7200		// 回転角(初期角度最小、初期角度最大、終了角度最小、終了角度最大)
	)
	// パーティクルのディレイ時間を設定する
	$$set_particle_delay($obj,							// 使用するオブジェクト
						0, 1500							// ディレイ時間(最小、最大)
	)
	// パーティクルの色を設定する
	$$set_particle_color($obj,							// 使用するオブジェクト
						"#4169e1", "#ff1493", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	)

	$obj.set_pos(960, 540)							// 座標を[960, 540]にする
	$obj.blend = 2									// 合成タイプを加算にする
	$obj.frame_action.start(-1, "$$fa_particle")	
}


@bg_pan_lr(bg008, 4)

ああああR

@bg(bg001)
@bs(ai11_01)
ああああR

@bg(b_bg001)
ああああR

@focus(bs3_ai11_01)
ああああR

@夜
@bg(bg301)

@face(hi12_01)
ああああR

@face(ai21_12)
ああああR

"おういえaaaaasrgoetryn@umhoicwejpr;geaaa%ss“あああ”aas"R
ああああR
@選択肢 = selbtn(掲示板を見に行く, 見に行かない)@選択肢終了
いいいR
うR
ええええR
おおおR


@称号を獲得(@称号_幼女ハンター)

てすとR

@称号を獲得(@称号_幼女ハンター, 1)

てすとR

goto #z11


//-----------------------------------------------------------------
// 汎用演出テスト
//-----------------------------------------------------------------
#z80

@シーン開始

@bg(_menu_bg01)
front.object[<OBJ_BG>].patno = 1

	front.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust02, 1)
	front.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG_FILTER>
	front.object[<OBJ_APP_EFFECT01>].blend = 1
	front.object[<OBJ_APP_EFFECT01>].tr = 128

;	front.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_aurora, 1)
;	front.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG_FILTER>
;	front.object[<OBJ_APP_EFFECT01>].blend = 4
;	front.object[<OBJ_APP_EFFECT01>].tr = 128

あR
@bg(_menu_bg02)

	front.object[<OBJ_APP_EFFECT01>].create_movie_loop(ef_wind_dust01, 1)
	front.object[<OBJ_APP_EFFECT01>].layer = <LAYER_BG_FILTER>
	front.object[<OBJ_APP_EFFECT01>].blend = 1
	front.object[<OBJ_APP_EFFECT01>].tr = 128

	front.object[<OBJ_APP_EFFECT02>].create_movie_loop(ef_wind_dust04, 1)
	front.object[<OBJ_APP_EFFECT02>].layer = <LAYER_BG_FILTER>
	front.object[<OBJ_APP_EFFECT02>].blend = 4

テストR

@bg_set(bg999_08,1500)
@wipe(99)
front.object[2].create_movie_loop(ef_aurora, 1)
オーロラ１９２０R

@風の回廊_浅層

@bg(bg103,99)
@bs(sp11_01)

浅層R

@風の回廊_中層

@bg(bg103,99)
@bs(sp11_01)

中層R

@風の回廊_深層

@bg(bg103,99)
@bs(sp11_01)

深層R

@風の回廊_終了

@bs(sp11_01)

終了R

/*
@bg(bg999_03,99)
front.object[2].create_movie_loop(ef_aurora, 1)
オーロラ１９２０R


@bg(bg004_03,99)

front.object[2].create_movie_loop(ef_dark_monster01, 1)
front.object[2].set_scale(2000, 2000)		// 960x540
front.object[2].set_pos(480, 270)
front.object[2].set_center_rep(480, 270)
front.object[2].blend = 0
front.object[2].scale_x_eve.set(3000, 5000, 0, 0)
front.object[2].scale_y_eve.set(3000, 5000, 0, 0)
１４４０R

front.object[2].create_movie_loop(ef_dark_monster01_1440, 1)
front.object[2].set_scale(1333, 1333)		// 1440x810
front.object[2].blend = 0
９６０R
*/


set_title("しろは")
翌日昼まで寝込んでR

@bs(sp11_01)

テスト２R

@bg(bg002,54)

テスト３R

@bs(ai11_01)

テスト４R

@fade(54)
@bg(bg001,54)

テスト５R

@bs(ai11_01)

テスト６R

goto #z80

front.mwnd[0].button[1].blend = 3
@bg_set(ef_avan_bg02, 1000, 0, -968)
$$create_light_leaf_particle3(back.object[<OBJ_APP_EFFECT01>], 0)
@wipe(0)

【キャラ名】サンプルテキストサンプルテキストサンプルテキストサンプルテキストサンプルテキストR

@電撃(0)

てすとR

@電撃(1)

てすとR

goto #z80

	back.object[<OBJ_APP_EFFECT01>].wipe_copy = 1
@bg_pan_du(tes_bg)


;@bg(bg002, -1)
;@bs(bs3_ky11_01)

;@回想枠
;@bg(bg_siro, -1)
;@filter(252, 181, 254, 255)
;@顔キラキラ(960, 490, 220)
;@wipe(0)

//-----------------------------------------------------------------
// 光る葉っぱパーティクル
//-----------------------------------------------------------------
command $$create_light_leaf_particle3(property $obj : object, property $type)
{
	// $type = 1の場合は[中]を生成しない
	
	$obj.init
	$obj.disp = 1
	$obj.child.resize(4)
	
	// [遠]／玉
	$$create_particle($obj.child[0], ef_light_ball,	// 使用するオブジェクト, 画像
						128, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						15000, 18000,					// 消滅する時間(最小、最大)
						5, 5, -8, -5					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
						0, 1160, 1100, 1120				// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						25, 25, 100, 100				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
						-1, 1, -1, 1					// 外力(x最小、x最大、y最小、y最大)
	)
	$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
						0, 12000						// ディレイ時間(最小、最大)
	)
	
	// [遠]／葉
	$$create_particle($obj.child[1], ef_particle01,	// 使用するオブジェクト, 画像
						48, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						15000, 18000,					// 消滅する時間(最小、最大)
						5, 10, -20, -10					// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	$$set_particle_shape_to_box($obj.child[1], 			// 使用するオブジェクト
						100, 1060, 1180, 1180			// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						100, 100, 450, 450				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	$$set_particle_outside_force($obj.child[1],			// 使用するオブジェクト
						-1, 1, -2, 0					// 外力(x最小、x最大、y最小、y最大)
	)
	$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
						0, 12000							// ディレイ時間(最小、最大)
	)
	$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
						-1800, 1800, -1800, 1800		// 回転角(最小、最大)
	)
	$$set_particle_patno($obj.child[1], 				// 使用するオブジェクト
						0, 3							// パターン番号(最小、最大)
	)
	$$set_particle_auto_tr($obj.child[1], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
	
	// [中]／葉
	if( $type != 1 )
	{
		$$create_particle($obj.child[2], ef_avan_particle,	// 使用するオブジェクト, 画像
							18, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							10000, 15000,					// 消滅する時間(最小、最大)
							10, 20, -40, -30				// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[2], 			// 使用するオブジェクト
							100, 1060, 1180, 1180			// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[2], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							300, 300, 450, 450				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_outside_force($obj.child[2],			// 使用するオブジェクト
							-3, 3, -3, 0					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[2], 				// 使用するオブジェクト
							0, 8000							// ディレイ時間(最小、最大)
		)
		$$set_particle_rotate($obj.child[2], 0,				// 使用するオブジェクト, 角度を固定するか
							-1800, 1800, -1800, 1800		// 回転角(最小、最大)
		)
		$$set_particle_patno($obj.child[2], 				// 使用するオブジェクト
							0, 3							// パターン番号(最小、最大)
		)
		$$set_particle_auto_tr($obj.child[2], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
	}
	
	// [近]／葉
	$$create_particle($obj.child[3], ef_avan_particle,	// 使用するオブジェクト, 画像
						4, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						10000, 12000,					// 消滅する時間(最小、最大)
						30, 40, -50, -40				// 動く方向x(最小、最大), 動く方向y(最小、最大)
	)
	$$set_particle_shape_to_box($obj.child[3], 			// 使用するオブジェクト
						100, 1060, 1380, 1380			// 矩形範囲(x最小、x最大、y最小、y最大)
	)
	$$set_particle_scale($obj.child[3], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
						700, 700, 850, 850				// 拡縮率(x最小、x最大、y最小、y最大)
	)
	$$set_particle_outside_force($obj.child[3],			// 使用するオブジェクト
						-5, 5, -5, 0					// 外力(x最小、x最大、y最小、y最大)
	)
	$$set_particle_delay($obj.child[3], 				// 使用するオブジェクト
						0, 5000							// ディレイ時間(最小、最大)
	)
	$$set_particle_rotate($obj.child[3], 0,				// 使用するオブジェクト, 角度を固定するか
						-1800, 1800, -1800, 1800		// 回転角(最小、最大)
	)
	$$set_particle_patno($obj.child[3], 				// 使用するオブジェクト
						0, 3							// パターン番号(最小、最大)
	)
	$$set_particle_auto_tr($obj.child[3], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
	
	$obj.child[0].bright = 255
	$obj.child[1].bright = 255
	if( $type != 1 ) {
		$obj.child[2].bright = 64
	}
	$obj.child[3].bright = 32
	
	$obj.child[0].blend = 1
	$obj.child[1].blend = 1
	if( $type != 1 ) {
		$obj.child[2].blend = 4
	}
	$obj.child[3].blend = 4
	
	$obj.child[0].frame_action.start(-1, "$$fa_particle")
	$obj.child[1].frame_action.start(-1, "$$fa_particle")
	if( $type != 1 ) {
;		$obj.child[2].frame_action.start(-1, "$$fa_particle")
	}
;	$obj.child[3].frame_action.start(-1, "$$fa_particle")
}

てすとR

savepoint

	@選択肢 = selbtn(
		プロローグから,
		共通ルートから
	)@選択肢終了

@bg(bg014, 99)
@bs_w(3, bs1_ai13_01@u1_ai)

てすとR

@bs(bs1_ai13_01@0z)

てすとR

@bs_del(bs1_ai13_01@r1)

てすとR

goto #z80

//-----------------------------------------------------------------
// 掲示板テスト
//-----------------------------------------------------------------
#z90

@シーン開始

@bg(bg007,99)

てすと１R

@fade(99)

@掲示板初期化
farcall("110_掲示板", 1)
@掲示板表示

goto #z90

//-----------------------------------------------------------------
// システムテスト
//-----------------------------------------------------------------
#z91

;@シーン開始
;syscom.call_ex(__sys_extra_mode_select)	// エクストラ画面へ

returnmenu

farcall(_trial)

goto #z91

//-----------------------------------------------------------------
// 立ち絵確認
//-----------------------------------------------------------------
#z92

@シーン開始

if( system.check_debug_flag )
{
	cgtable.set_all_flag(0)
	
	for( l[0] = 0, l[0] < $$get_extra_cg_cnt, l[0] += 1 )
	{
		if( math.rand(0, 1) )
		{
			if( __EXTRA_CG_DIFF_MODE )
			{
				for( l[1] = 0, l[1] < __EXTRA_CG_L_DIFF_MAX, l[1] += 1 )
				{
					for( l[2] = 0, l[2] < __EXTRA_CG_S_DIFF_MAX, l[2] += 1 )
					{
						k[0] = $$get_extra_cg(l[0]) + "_" + math.tostr_zero(l[1], 2) + math.tostr_zero(l[2], 2)
						
						if( $$exists_g00(k[0]) )
						{
							cgtable.set_look_by_name(k[0], 1)
						}
					}
				}
			}
			else
			{
				for( l[1] = 0, l[1] < __EXTRA_CG_S_DIFF_MAX, l[1] += 1 )
				{
					k[0] = $$get_extra_cg(l[0]) + "_" + math.tostr_zero(l[1], 2)
					
					if( $$exists_g00(k[0]) )
					{
						cgtable.set_look_by_name(k[0], 1)
					}
				}
			}
		}
	}
}

syscom.call_ex(__sys_extra_mode_select)

goto #z92

//-----------------------------------------------------------------
// タイトルテスト
//-----------------------------------------------------------------
#z93

@選択肢 = selbtn(1,
	通常,
	通常＋スピカクリア,
	通常＋愛乃クリア,
	通常＋陽彩クリア,
	通常＋小詠クリア,
	通常＋六花クリア,
	通常＋サブクリア,
	エタニクルのみ,
	エタニクル＋通常,
	アネモイのみ,
	アネモイ＋通常,
	フルコンプ
)@選択肢終了

switch( @選択 ) {
case(0)		@タイトルメニューレベル = 0
			@朱比華ルートクリア = 0
			@愛乃ルートクリア = 0
			@陽彩ルートクリア = 0
			@小詠ルートクリア = 0
			@六花ルートクリア = 0
			@文弥ルートクリア = 0
			@エタニクルルートクリア = 0
			@アネモイルートクリア = 0
case(1)		@タイトルメニューレベル = 0
			@朱比華ルートクリア = 1
case(2)		@タイトルメニューレベル = 0
			@愛乃ルートクリア = 1
case(3)		@タイトルメニューレベル = 0
			@陽彩ルートクリア = 1
case(4)		@タイトルメニューレベル = 0
			@小詠ルートクリア = 1
case(5)		@タイトルメニューレベル = 0
			@六花ルートクリア = 1
case(6)		@タイトルメニューレベル = 0
			@文弥ルートクリア = 1
case(7)		@タイトルメニューレベル = 1
			@朱比華ルートクリア = 1
			@愛乃ルートクリア = 1
			@陽彩ルートクリア = 1
			@小詠ルートクリア = 1
			@六花ルートクリア = 1
case(8)		@タイトルメニューレベル = 2
			@朱比華ルートクリア = 1
			@愛乃ルートクリア = 1
			@陽彩ルートクリア = 1
			@小詠ルートクリア = 1
			@六花ルートクリア = 1
case(9)		@タイトルメニューレベル = 3
			@朱比華ルートクリア = 1
			@愛乃ルートクリア = 1
			@陽彩ルートクリア = 1
			@小詠ルートクリア = 1
			@六花ルートクリア = 1
			@エタニクルルートクリア = 1
case(10)	@タイトルメニューレベル = 4
			@朱比華ルートクリア = 1
			@愛乃ルートクリア = 1
			@陽彩ルートクリア = 1
			@小詠ルートクリア = 1
			@六花ルートクリア = 1
			@エタニクルルートクリア = 1
case(11)	@タイトルメニューレベル = 5
			@朱比華ルートクリア = 1
			@愛乃ルートクリア = 1
			@陽彩ルートクリア = 1
			@小詠ルートクリア = 1
			@六花ルートクリア = 1
			@エタニクルルートクリア = 1
			@アネモイルートクリア = 1
}

returnmenu


//-----------------------------------------------------------------
// スタッフロールテスト
//-----------------------------------------------------------------
#z94

@シーン開始

@bs_set(td11_01)
@bs_bright(td, 128)		// 半分明るい
@wipe(0)

てすとR

@bs_set(td11_01)
@bs_bright(td, 255)		// MAX明るい
@wipe(0)

てすとR

@bs_set(td11_01)
@bs_bright(td, 255, 128)		// MAX明るい＋半透明
@wipe(0)

てすとR

@アイキャッチ("0110", ef_avan_bg02, 1)

てすとR

@bs_x_rev(td, 1)

@bs(td11_01)
てすとR

@bs_x_rev(td, 0)

@bs(td11_01)
てすとR

;@風の回廊_浅層(2000, 4, 64)
;@mono //トリガーと合わせるため仮
;back.effect[0].end_layer = 49 //トリガーと合わせるため仮

@エタニクルＥＤ
@淡雪0833ＥＤ

@bgm(bgm36)

@風の回廊_浅層
@bg(bg001, 99)R

@風の回廊_中層
@bg(bg001, 99)R

@風の回廊_深層
@bg(bg001, 99)R

@システム_絵美出現 = 0
@システム_穂乃夏出現 = 0

なしR

@システム_絵美出現 = 1
@システム_穂乃夏出現 = 0

絵美R

@システム_絵美出現 = 0
@システム_穂乃夏出現 = 1

穂乃夏１R

@システム_絵美出現 = 0
@システム_穂乃夏出現 = 2

穂乃夏２R

@システム_絵美出現 = 1
@システム_穂乃夏出現 = 1

両方１R

@システム_絵美出現 = 1
@システム_穂乃夏出現 = 2

両方２R


@麦視点
あああああああああああああああああああああああああああああああああああああああああR

@スピカ視点

あああああああああああああああああああああああああああああああああああああああああR

@愛乃視点

あああああああああああああああああああああああああああああああああああああああああR

@淡雪視点

あああああああああああああああああああああああああああああああああああああああああR

@小詠視点

あああああああああああああああああああああああああああああああああああああああああR

@六花視点

あああああああああああああああああああああああああああああああああああああああああR

@その他視点
あああああああああああああああああああああああああああああああああああああああああR

@bg_zoom(b_bg008_03, 4, 1100, 1000, 3000, 2)
@waitkey(1000)

@風の回廊_浅層
@bg_pan_lr(bg008_03, 4, 40000)

ああああR


@風の回廊_深層
@雪(1, 1, 1)
@bg_set(b_bg008_03, 1500)
	back.object[<OBJ_BG>].color_r = 128
	back.object[<OBJ_BG>].color_b = 64
	back.object[<OBJ_BG>].color_rate = 128
	back.object[<OBJ_BG>].dark = 128
@wipe(3)

@bs(bs3_sp11_10)
front.object[3].tonecurve_no = 3

ああああR

// 通常
@ダウンバースト(4) R

// 雨ver
@ダウンバースト_雨(0, 10000) R

// 通常、上から下にパン
@ダウンバースト(-1)
@ダウンバースト_縦パン(3, 270, -270, 30000) R

// 雨ver、左から右にパン
@ダウンバースト_雨(-1)
@ダウンバースト_横パン(3, 480, -480, 30000) R

@災獣_狼 あああああR
@災獣_猪 あああああR
@災獣_鯨 あああああR
@災獣_バロン あああああR
@災獣_蛇 あああああR
@災獣_鳥 あああああR
@災獣_竜 あああああR

@麦視点 あああああR
@スピカ視点 あああああR
@愛乃視点 あああああR
@淡雪視点 あああああR
@小詠視点 あああああR
@六花視点 あああああR
@その他視点 あああああR

@淡雪0833ＥＤ
//@淡雪2816ＥＤ

goto #z94
