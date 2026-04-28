//===========================================================================
//!
//!    @file     ___mng_urace_race_item.ss
//!    @brief    ＵＭＡレースアイテム管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     レース画面中のアイテム処理
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// アイテムタイプ
	#replace	<ITEM_TYPE_PROJECTILE>		1			// 発射物
	
	// 所持アイテム
	#property	$items : intlist[<URACE_ENTRY_MAX>]
	
#inc_end

#z00

//---------------------------------------------------------------------------
// レースアイテムデータの初期化
//---------------------------------------------------------------------------
command $$init_urace_race_item
{
	$items.init
}

//---------------------------------------------------------------------------
// 所持しているレースアイテムを取得する
//---------------------------------------------------------------------------
command $$get_urace_race_item_id(property $entry_index)
{
	return ($items[$entry_index])
}

//---------------------------------------------------------------------------
// 指定したレースアイテムを入手する
//---------------------------------------------------------------------------
command $$add_urace_race_item(property $entry_index, property $item_id) : int
{
	// 何らかのアイテムを取得済みの場合は終了する
	if( $items[$entry_index] != <URACE_EMPTY_RACE_ITEM_ID> ) {
		return (-1)
	}
	
	$items[$entry_index] = $item_id
	
	return (1)
}

//---------------------------------------------------------------------------
// レースアイテムを所持しているか
//---------------------------------------------------------------------------
command $$has_urace_race_item(property $entry_index) : int
{
	if( $items[$entry_index] == <URACE_EMPTY_RACE_ITEM_ID> ) {
		return (0)
	}
	
	return (1)
}

//---------------------------------------------------------------------------
// レースアイテムを所持しているか
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
// レースアイテムを手に入れる
//---------------------------------------------------------------------------
command $$pick_urace_race_item(property $entry_index)
{
	property $item_list : intlist
	property $item_rate : intlist
	property $num_items
	property $random_value
	property $cumulative_rate
	property $i
	
	// レースアイテム持っている場合は新規に入手できない
	if( $$has_urace_race_item($entry_index) != 0 ) {
		return
	}
	
	// 着順によって入手できるアイテムリストを変更する
	/*
	switch( $$get_order($entry_index) ) {
	case(1)
		$item_list.resize(3)
		$item_rate.resize(3)
		$item_list.sets(0, @アイテム_バット, @アイテム_愛乃の傘, @アイテム_トラバサミ)
		$item_rate.sets(0, 20, 40, 40)
	case(2)
		$item_list.resize(3)
		$item_rate.resize(3)
		$item_list.sets(0, 1, 2, 3)
		$item_rate.sets(0, 60, 20, 20)
	case(3)
		$item_list.resize(3)
		$item_rate.resize(3)
		$item_list.sets(0, 1, 2, 3)
		$item_rate.sets(0, 30, 40, 30)
	case(4)
		$item_list.resize(3)
		$item_rate.resize(3)
		$item_list.sets(0, 1, 2, 3)
		$item_rate.sets(0, 30, 40, 30)
	case(5)
		$item_list.resize(2)
		$item_rate.resize(2)
		$item_list.sets(0, 1, 2)
		$item_rate.sets(0, 20, 80)
	case(6)
		$item_list.resize(1)
		$item_rate.resize(1)
		$item_list.sets(0, 2)
		$item_rate.sets(0, 100)
	}
	*/
	$item_list.resize(3)
	$item_rate.resize(3)
	$item_list.sets(0, @アイテム_バット, @アイテム_トラバサミ, @アイテム_愛乃の傘)
	$item_rate.sets(0, 30, 40, 30)
	
	
;	l[0] = math.rand(0, 99)
;	if( l[0] < $item_rate[0] ) {
;		$$add_urace_race_item($entry_index, $item_list[0])
;	}
;	elseif( l[0] < $item_rate[0] + $item_rate[1] ) {
;		$$add_urace_race_item($entry_index, $item_list[1])
;	}
;	elseif( l[0] < $item_rate[0] + $item_rate[1] + $item_rate[2] ) {
;		$$add_urace_race_item($entry_index, $item_list[2])
;	}
	// ループベースのランダム選出
	$num_items = $item_list.get_size
	$random_value = math.rand(0, 99)
	$cumulative_rate = 0

	for( $i = 0, $i < $num_items, $i += 1 )
	{
		$cumulative_rate += $item_rate[$i]
		if( $random_value < $cumulative_rate ) {
			$$add_urace_race_item($entry_index, $item_list[$i])
			return
		}
	}

	// フォールバック（確率の合計が100でない場合）
	if( $num_items > 0 ) {
		$$add_urace_race_item($entry_index, $item_list[$num_items - 1])
	}
}

//---------------------------------------------------------------------------
// アイテムが使用可能かどうかを判定する
//---------------------------------------------------------------------------
command $$is_urace_race_item_available(property $entry_index) : int
{
	// スタート／走り状態以外は使用不可
	if( $$get_running_uma_action_state($entry_index) != <RUNNING_UMA_ACTION_STATE_START> &&
		$$get_running_uma_action_state($entry_index) != <RUNNING_UMA_ACTION_STATE_RUN> ) {
		return (-1)
	}
	
	// アイテムを所持していない場合は使用不可
	if( $$has_urace_race_item($entry_index) == 0 ) {
		return (-2)
	}

	// アイテム封印中は使用不可
	if( $$get_running_uma_buff_item_seal($entry_index) > 0 ) {
		return (-3)
	}

    return (1)
}

//---------------------------------------------------------------------------
// レースアイテムを使用する
//---------------------------------------------------------------------------
command $$use_urace_race_item(property $entry_index) : int
{
	property $item_id
	property $item_type
	property $available
	property $is_omikuji
	property $omikuji_list : intlist
	
	$item_id = $items[$entry_index]
	
	// アイテムを所持していない場合は終了する
	if( $item_id == <URACE_EMPTY_RACE_ITEM_ID> ) {
		return (-1)
	}
	
	// アイテム使用可能判定
	$available = $$is_urace_race_item_available($entry_index)
	if ( $available != 1 ) {
		return (-1)
	}
	
	// 各アイテム処理
	switch( $item_id ) {
	case(@アイテム_バット)
		
		;正面にバットを投げてUMAを攻撃する。バットに当たったUMAは一定時間スタンする。
		
		// そのまま採用
		$$add_urace_projectile($item_id, $$get_entry_owner_mileage($entry_index) + 3000, $$get_now_lane($entry_index), 80, 5, 0, 0)
		
	case(@アイテム_大吉のおみくじ)
		
		;ランダムでアイテムの効果が発動する。
		// 持っていればOKと矛盾。効果発動だと結局どれかわからず、繰り返し学習する機会も少ないのでノイズ要素。
		// もし採用するなら再抽選で別のアイテム化、操作性の問題もあり、面白さに繋がるかと言うと難しい。
		
		// とりあえず再抽選
		$is_omikuji = 1
		$omikuji_list.sets(@アイテム_バット, @アイテム_バット, @アイテム_トラバサミ, @アイテム_フェンス)
		$$add_urace_item($omikuji_list[ math.rand(0, $omikuji_list.get_size - 1) ], 1)
		
	case(@アイテム_愛乃の傘)
		
		;風に吹かれて前方に飛んでいく。敵UMAに向かって誘導して進み、当たるとスタンさせる。
		// 赤甲羅は、緑甲羅(バット)の対比になっているのと一つ前の順位かつカメラ的に進行方向で挙動も直感的で狙う価値がある。
		// 自由なレーンチェンジとUMA同士重なる仕様から別キャラに当たる問題、誘導対象がわかりづらい問題等があり
		// 相手も画面内にいるとも限らず、自己効力感が低くシステムとあまり合っていない。
		// 傘というモチーフからアフォーダンス(見た目から連想される効果)を考えるなら防御アイテム、機能的には緑甲羅のバージョン違いとして後方発射があたりが妥当。
		
		// とりあえず後方にゆっくり飛ばす
		$$add_urace_projectile($item_id, $$get_entry_owner_mileage($entry_index) -10000, $$get_now_lane($entry_index), -10, 3, 0, 0)
		
	case(@アイテム_トラバサミ)
		
		;トラバサミをレーンの上に置く。トラバサミを踏んだ相手はスタンしてスタミナが下がる。
		
		// そのまま採用
		$$add_urace_projectile($item_id, $$get_entry_owner_mileage($entry_index) - 10000, $$get_now_lane($entry_index), 0, 5, 0, 0)
		
	case(@アイテム_フェンス)
		
		;フェンスを置いて、レーンを封鎖する。ぶつかった相手のスピードとスタミナを下げる。
		// スタンは完全に一定時間足が止まり、加速時間が必要になるので、実質ただの劣化トラバサミ
		// 前方にフェンスを設置に変更すれば、留まるバットのような扱いになりバリエーションは増える。
		//$$add_urace_projectile($item_id, $$get_entry_owner_mileage($entry_index) - 10000, $$get_now_lane($entry_index), 0, 5, 0, 0)
		
		// とりあえず前方設置
		$$add_urace_projectile($item_id, $$get_entry_owner_mileage($entry_index) + 50000, $$get_now_lane($entry_index), 0, 5, 0, 0)
		
	case(@アイテム_絆創膏)
		
		;もっていると敵のアイテムや妨害効果を引き受けてくれる。
		// 使いたくなるけど使えない特殊な学習が必要な枠でわかりやすいUIが必須。消滅しない系や連射系の場合貫通する。どちらかと言うと回復しそう
		
		// プレイヤーに妨害無効バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_INTERRUPT_BLOCK>,	// type: 妨害無効
			5000,										// time
			1,											// amount: 1(有効フラグ)
			0											// delay: 0ms(即座に発動)
		)
		
	case(@アイテム_老舗のいももち)
		
		;美味しいいももちを食べてスタミナが回復する。
		// 直感的で絆創膏よりは優先的に採用したいが、最大値の時どうする問題。使えなくしてしまうと捨てて別アイテム取得が出来ない
		
		// 回復
		$$heal_damage_uma($$get_entry_owner_uma_index($entry_index), 30)
		
	case(@アイテム_特製プロテイン)
		
		;プロテインを飲み、一瞬だけ加速させる。３回まで使用できる。
		// リカバリー3回は強力すぎる、基本システムから逸れた使ったら消える系ではなく覚える事が増えるので、とりあえず1回で実装
		
		// とりあえず、見た目にわかりやすいスキルのバネジャンプの一瞬の加速を再現
		// プレイヤーに最高速度(固定)バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_CONST_SPEED_MAX>,	// type: 
			500,										// time
			200,										// amount
			0											// delay: 0ms(即座に発動)
		)
		// プレイヤーに加速バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_ACCEL>,				// type: 
			500,										// time
			10000,										// amount
			0											// delay: 0ms(即座に発動)
		)
		
	case(@アイテム_やる気スイッチサプリＸ)
		
		;やる気がＭＡＸになり、障害物を無視して走れるようになる。
		// 覚える事が増えるので、ハッピーでターンな粉で良いのでは？
		
		// プレイヤーに障害物無効バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_TRAP_BLOCK>,			// type: 障害物無効
			5000,										// time
			1,											// amount: 1(有効フラグ)
			0											// delay: 0ms(即座に発動)
		)
		
	case(@アイテム_河瀬作・リミッター解除装置β)
		
		;一定時間、加速し続ける。レースの順位が低いほど、効果の持続が長い。
		// キラー枠？プロテインで良いのでは
		
		// プレイヤーに最高速度(固定)バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_CONST_SPEED_MAX>,	// type: 
			500 * $$get_order($entry_index),			// time
			125,										// amount
			0											// delay: 0ms(即座に発動)
		)
		// プレイヤーに加速バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_ACCEL>,				// type: 
			500 * $$get_order($entry_index),			// time
			10000,										// amount
			0											// delay: 0ms(即座に発動)
		)
		
		
	case(@アイテム_蓋のついたシュールストレミング)
		
		;設置するとあまりの臭さに設置したレーンと両隣のレーンのUMAをスタンする。一定時間、場に残り続ける。
		// 絶対に視覚的な表現が必要で、エフェクトと判定を順次拡大するスタイルじゃないと相手が使ってきた時の納得感が0になる。
		
		// とりあえず3レーン固定型
		$$add_urace_projectile($item_id, $$get_entry_owner_mileage($entry_index) - 10000, $$get_now_lane($entry_index), 0, 0, 1, 6000)
		
	case(@アイテム_便箋)
		
		;ランダムな敵UMAに想いのこもった便箋を送る。お返しに持っているアイテムをくれる。
		// 視覚表現必須、画面外で事が起きる可能性が高い、演出分ラグがある、失敗もある
		// テレサは透明化部分も重要
		
	case(@アイテム_ハッピーでターンな粉)
		
		;一定時間ハッピーになる。あらゆる効果や地形適正無効にし、加速する。
		// いわゆるスター状態で、わかりやすいので採用。
		
		// プレイヤーに最高速度(固定)バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_CONST_SPEED_MAX>,	// type: 
			5000,										// time
			125,										// amount
			0											// delay: 0ms(即座に発動)
		)
		// プレイヤーに加速バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_ACCEL>,				// type: 
			5000,										// time
			10000,										// amount
			0											// delay: 0ms(即座に発動)
		)
		// プレイヤーに妨害無効バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_INTERRUPT_BLOCK>,	// type: 妨害無効
			5000,										// time
			1,											// amount: 1(有効フラグ)
			0											// delay: 0ms(即座に発動)
		)
		// プレイヤーに障害物無効バフを付与
		$$add_running_uma_buff(
			$$get_entry_owner_uma_index($entry_index),	// target: プレイヤー
			$$get_entry_owner_uma_index($entry_index),	// user: プレイヤー
			0,											// skill_id: 0(デバッグ用)
			<RUNNING_UMA_BUFF_TYPE_TRAP_BLOCK>,			// type: 障害物無効
			5000,										// time
			1,											// amount: 1(有効フラグ)
			0											// delay: 0ms(即座に発動)
		)
		
	}
	
	switch( $item_type ) {
	case(<ITEM_TYPE_PROJECTILE>)
		
		
		// 多重
		/*
		if($item_id == 2)
		{
			if( $$get_now_lane($entry_index) > 0 ) {
				$$add_urace_projectile($item_id, $$get_item_place($entry_index, $item_id), $$get_now_lane($entry_index) - 1, $$get_item_move_speed($item_id), $$get_item_power($item_id), 0, 0)
			}
			if( $$get_now_lane($entry_index) < <URACE_LANE_MAX> - 1 ) {
				$$add_urace_projectile($item_id, $$get_item_place($entry_index, $item_id), $$get_now_lane($entry_index) + 1, $$get_item_move_speed($item_id), $$get_item_power($item_id), 0, 0)
			}
		}
		*/
	}
	
	// おみくじ以外ならアイテムを消費して空にする
	if( $is_omikuji != 1) {
		$items[$entry_index] = <URACE_EMPTY_RACE_ITEM_ID>
	}
}

