//===========================================================================
//!
//!    @file     ___mng_urace_user_data.ss
//!    @brief    ＵＭＡレースユーザーデータ管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	// ＵＭＡタグタイプ[8bit分割時の各インデックス]
	#replace	<UMA_TAG_TYPE_ID>				0		// ID
	#replace	<UMA_TAG_TYPE_RARITY>			1		// レアリティ
	#replace	<UMA_TAG_TYPE_RUN_TYPE>			2		// 走行タイプ
	#replace	<UMA_TAG_TYPE_SKILL_ID>			3		// スキルID
	
	// ＵＭＡパラメータタイプ[8bit分割時の各インデックス]
	#replace	<UMA_PARAM_TYPE_LIFE>			0		// ライフ
	#replace	<UMA_PARAM_TYPE_SPEED>			1		// スピード
	#replace	<UMA_PARAM_TYPE_ATTACK>			2		// 攻撃力
	#replace	<UMA_PARAM_TYPE_ACCEL>			3		// 加速力
	
	// 地形タイプ[8bit分割時の各インデックス]
	#replace	<UMA_GROUND_TYPE_TURF>			0		// 芝
	#replace	<UMA_GROUND_TYPE_DIRT>			1		// ダート
	#replace	<UMA_GROUND_TYPE_SURFACE>		2		// 水面
	
	// 状態タイプ[8bit分割時の各インデックス]
	#replace	<UMA_STATE_TYPE_NEW>			0		// Newフラグ
	#replace	<UMA_STATE_TYPE_FATIGUE>		1		// 疲労
	
	// 各ＵＭＡデータ
	// リストは[プレイヤーの各ＵＭＡ／オーナー１の各ＵＭＡ, オーナー２の各ＵＭＡ...の順で格納される]
	#property	$uma_list_name : strlist			// 名前
	#property	$uma_list_tag : intlist				// 概要            8bit分割[ID／レアリティ／走行タイプ／スキルID]
	#property	$uma_list_param : intlist			// パラメータ      8bit分割[ライフ／スピード／攻撃力／加速力]
	#property	$uma_list_ground_type : intlist		// 地形適性        8bit分割[芝／ダート／水面／宇宙]
	#property	$uma_list_title : intlist			// 称号            8bit分割[称号１／称号２／称号３／称号４...] ※さらに[<UMA_TITLE_SLOT>]が乗算される
	#property	$uma_list_state : intlist			// 状態            8bit分割[Newフラグ／空き／空き／空き]
	
	// ＵＭＡソートデータ
	#property	$uma_list_sort_type					// ソートタイプ(入手順／ステータス順／レアリティ順／スキル順)
	#property	$uma_list_sort_order				// ソート並び順(昇順／降順)
	#property	$uma_list_sort_list : intlist		// ＵＭＡ並び
	
	#property	$uma_library_sort_type				// 図鑑／ソートタイプ(入手順／ステータス順／レアリティ順／スキル順)
	#property	$uma_library_sort_order				// 図鑑／ソート並び順(昇順／降順)
	#property	$uma_library_sort_list : intlist	// 図鑑／ＵＭＡ並び
	
	// ＵＭＡデッキデータ
	#property	$deck_name : strlist				// デッキ／名前
	#property	$deck_list : intlist				// デッキ／ＵＭＡリスト
	#property	$deck_select_index					// 選択しているデッキインデックス
	
	// 所持アイテムデータ
	#property	$my_item : intlist					// アイテム数
	
	// 獲得メダルデータ
	#property	$my_medal : intlist					// 獲得メダル
	
	// 掲示板データ
	#property	$bbs_race_list : intlist			// 掲示板に出現するレースリスト
	#property	$bbs_hunter_num : intlist			// 各日付で出現するハンター依頼数
	#property	$bbs_hunter_list : intlist			// 掲示板に出現するハンターリスト
	#property	$bbs_hunter_request : intlist		// 出現したハンターに依頼をしているかどうか
	
	// ハンターデータ
	#property	$hunter_result_id					// ハンター結果／ハンターID
	#property	$hunter_result_uma_id : intlist		// ハンター結果／捕まえたＵＭＡのID
	#property	$hunter_result_uma_new : intlist	// ハンター結果／捕まえたＵＭＡが初めて捕まえたＵＭＡかどうか
	
	// レースレコードデータ
	#property	$record_race_id : intlist			// レースID
	#property	$record_uma_name : strlist			// ＵＭＡ名
	#property	$record_uma_title : intlist			// ＵＭＡ称号
	#property	$record_goal_order : intlist		// 着順
	#property	$record_goal_time : intlist			// ゴールタイム
	
	// プレイヤー操作
	#property	$played_race_in_bbs					// 掲示板の選択でＵＭＡレースを遊んだかどうか
	#property	$pause								// 一時停止
	#property	$auto_play							// オートプレイ
	
	#property	$honor			// 名声ポイント
	#property	$hunter_request_num
	#property	$hunter_request_max
	
#inc_end

#z00

//---------------------------------------------------------------------------
// ユーザーデータの初期化
//---------------------------------------------------------------------------
command $$init_urace_user_data
{
	property $i
	property $j
	property $len
	property $index
	property $id
	property $num
	
	// 各ＵＭＡ／捕獲したＵＭＡデータ
	$len = <PLAYER_UMA_SLOT_MAX> + <NPC_UMA_SLOT_MAX> + <WILD_UMA_SLOT_MAX>
	
	$uma_list_tag.init
	$uma_list_name.init
	$uma_list_param.init
	$uma_list_ground_type.init
	$uma_list_title.init
	$uma_list_state.init
	
	$uma_list_tag.resize($len)
	$uma_list_name.resize($len)
	$uma_list_param.resize($len)
	$uma_list_ground_type.resize($len)
	$uma_list_title.resize($len * <UMA_TITLE_SLOT>)
	$uma_list_state.resize($len)
	
	// ＵＭＡソートデータ
	$len = <PLAYER_UMA_SLOT_MAX>
	
	$uma_list_sort_type  = <URACE_SORT_TYPE_GET>		// デフォルトは入手順
	$uma_list_sort_order = <URACE_SORT_ORDER_ASC>		// デフォルトは降順
	$uma_list_sort_list.resize($len)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$uma_list_sort_list[$i] = $i
	}
	
	// ＵＭＡ図鑑ソートデータ
	$len = $$get_db_uma_max
	$uma_library_sort_type  = <URACE_LIBRARY_SORT_TYPE_NO>		// デフォルトは番号順
	$uma_library_sort_order = <URACE_SORT_ORDER_ASC>			// デフォルトは昇順
	$uma_library_sort_list.resize($len)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$uma_library_sort_list[$i] = $i + 1
	}
	
	// デッキ／名前
	$len = <URACE_DECK_MAX>
	
	$deck_name.resize($len)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$deck_name[$i] = $$get_urace_default_deck_name($i)
	}
	
	// デッキ／ＵＭＡリスト
	$len = <URACE_DECK_MAX> * <URACE_DECK_UMA_MAX>
	
	$deck_list.resize($len)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$deck_list[$i] = -1
	}
	
	$deck_select_index = 0
	
	// 所持アイテムデータ
	$len = $$get_db_item_max
	$my_item.resize($len)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$id = $i + 1
		$num = $$get_db_item_default_num($id)
		
		if( $num ) {
			$$add_urace_item($id, $num)
		}
	}
	
	// 獲得メダルデータ
	$len = <URACE_MEDAL_MAX>
	$my_medal.resize($len)
	for( $i = 0, $i < $len, $i += 1 )
	{
		$my_medal[$i] = 0
	}
	
	// 掲示板データ
	$bbs_race_list.init
	$bbs_hunter_num.init
	$bbs_hunter_list.init
	$bbs_hunter_request.init
	
	// レースレコードデータ
	$$init_my_urace_record
	
	// 操作データ
	$played_race_in_bbs = 0
	$pause = 0
	$auto_play = 0
	
	//2
	$honor = 0
	$hunter_request_num = 0
	$hunter_request_max = 3
	
	// ＵＭＡレース一日の初期化処理
	$$init_urace_am_data
}

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
command $$create_bbs_base_data
{
	property $i
	property $j
	property $len
	property $index
	property $item_num
	property $num : intlist[4]
	property $tmp
	
	// 所持アイテム数を調べる
	$len = $$get_db_item_max
	for( $i = 1, $i < $len, $i += 1 )
	{
		if( $$get_urace_item_num($i) ) {
			$item_num += 1
		}
	}
	
	if( $item_num <= 2 )
	{
		$num[0] = 4		// １人枠：４回
		$num[1] = 10	// ２人枠：１０回
	}
	elseif( $item_num <= 6 )
	{
		$num[1] = 14	// ２人枠：１４回
	}
	elseif( $item_num <= 10 )
	{
		$num[1] = 10	// ２人枠：１０回
		$num[2] = 4		// ３人枠：４回
	}
	elseif( $item_num <= 14 )
	{
		$num[2] = 14	// ３人枠：１４回
	}
	elseif( $item_num <= 17 )
	{
		$num[2] = 10	// ３人枠：１０回
		$num[3] = 4		// ４人枠：４回
	}
	else
	{
		$num[3] = 14	// ４人枠：１４回
	}
}

//---------------------------------------------------------------------------
// ＵＭＡレース午前の初期化処理
//---------------------------------------------------------------------------
command $$init_urace_am_data
{
	// 掲示板に出現するレースを選出する
	$$create_bbs_race_list
	
	// 掲示板に出現するハンターを選出する
	$$create_bbs_hunter_list
	
	// 掲示板の選択でＵＭＡレースを遊んでいない状態にする
	$played_race_in_bbs = 0
	
	$hunter_request_num = 0
	$hunter_request_max = 3
}

//---------------------------------------------------------------------------
// ＵＭＡレース午後の初期化処理
//---------------------------------------------------------------------------
command $$init_urace_pm_data
{
	// 掲示板に出現するレースを選出する
	$$create_bbs_race_list
	
	// 掲示板の選択でＵＭＡレースを遊んでいない状態にする
	$played_race_in_bbs = 0
	
	$hunter_request_num = 0
	$hunter_request_max = 3
}


//===============================================================================================
// 所持ＵＭＡ
//===============================================================================================
//---------------------------------------------------------------------------
// ＵＭＡの所持数を取得する
//---------------------------------------------------------------------------
command $$get_my_uma_num : int
{
	property $i
	
	for( $i = 0, $i < <PLAYER_UMA_SLOT_MAX>, $i += 1 )
	{
		if( $$get_uma_id(<URACE_PLAYER_OWNER_ID>, $i) == 0 )
		{
			return ($i)
		}
	}
	
	return (<PLAYER_UMA_SLOT_MAX>)
}

//---------------------------------------------------------------------------
// プレイヤーのＵＭＡ所持数が最大かどうかを取得する
//---------------------------------------------------------------------------
command $$is_my_uma_max : int
{
	if( $$get_my_uma_num < <PLAYER_UMA_SLOT_MAX> )
	{
		return (0)
	}
	
	return (1)
}

//---------------------------------------------------------------------------
// ＵＭＡを所持リストから削除する
//---------------------------------------------------------------------------
command $$del_my_uma(property $index) : int
{
	property $i
	property $j
	property $len
	
	// 指定範囲外のIDをチェックする
	if( $index < 0 || $$get_my_uma_num < $index )
	{
		$$debug_message("削除するuma_indexの指定が範囲外です。\nindex:" + math.tostr($index) + "\n処理をスキップします")
		return (0)
	}
	
	// 所持数の最小をチェックする
	if( $$get_my_uma_num == 1 )
	{
		$$debug_message("所持uma数を1体以下にはできません。\nnum:" + math.tostr($$get_my_uma_num) + "\n処理をスキップします")
		return (0)
	}
	
	// データを削除する
	for( $i = $index, $i < <PLAYER_UMA_SLOT_MAX>, $i += 1 )
	{
		if( $i == <PLAYER_UMA_SLOT_MAX> - 1 )
		{
			$$init_uma_data(<URACE_PLAYER_OWNER_ID>, $i)
			break
		}
		
		$$set_uma_name         (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_name(<URACE_PLAYER_OWNER_ID>, $i + 1))			// 名前
		$$set_uma_id           (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_id(<URACE_PLAYER_OWNER_ID>, $i + 1))				// ID
		$$set_uma_rarity       (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $i + 1))			// レアリティ
		$$set_uma_run_type     (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_run_type(<URACE_PLAYER_OWNER_ID>, $i + 1))		// 走行タイプ
		$$set_uma_skill_id     (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_skill_id(<URACE_PLAYER_OWNER_ID>, $i + 1))		// スキルID
		$$set_uma_life         (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_life(<URACE_PLAYER_OWNER_ID>, $i + 1))			// ライフ
		$$set_uma_speed        (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_speed(<URACE_PLAYER_OWNER_ID>, $i + 1))			// スピード
		$$set_uma_attack       (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_attack(<URACE_PLAYER_OWNER_ID>, $i + 1))			// 攻撃力
		$$set_uma_accel        (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_accel(<URACE_PLAYER_OWNER_ID>, $i + 1))			// 加速力
		$$set_uma_turf_type    (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_turf_type(<URACE_PLAYER_OWNER_ID>, $i + 1))		// 芝適性
		$$set_uma_dirt_type    (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_dirt_type(<URACE_PLAYER_OWNER_ID>, $i + 1))		// ダート適性
		$$set_uma_surface_type (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_surface_type(<URACE_PLAYER_OWNER_ID>, $i + 1))	// 水面適性
		$$set_uma_new_flag     (<URACE_PLAYER_OWNER_ID>, $i, $$get_uma_new_flag(<URACE_PLAYER_OWNER_ID>, $i + 1))		// Newフラグ
	}
	
	return (1)
}


//===============================================================================================
// 各ＵＭＡデータ
//===============================================================================================
//---------------------------------------------------------------------------
// 指定したＵＭＡを初期化する
//---------------------------------------------------------------------------
command $$init_uma_data(property $owner_id, property $index)
{
	property $i
	
	$$set_uma_name         ($owner_id, $index, "")		// 名前
	$$set_uma_id           ($owner_id, $index, 0)		// ID
	$$set_uma_rarity       ($owner_id, $index, 0)		// レアリティ
	$$set_uma_run_type     ($owner_id, $index, 0)		// 走行タイプ
	$$set_uma_skill_id     ($owner_id, $index, 0)		// スキルID
	$$set_uma_life         ($owner_id, $index, 0)		// ライフ
	$$set_uma_speed        ($owner_id, $index, 0)		// スピード
	$$set_uma_attack       ($owner_id, $index, 0)		// 攻撃力
	$$set_uma_accel        ($owner_id, $index, 0)		// 加速力
	$$set_uma_turf_type    ($owner_id, $index, 0)		// 芝適性
	$$set_uma_dirt_type    ($owner_id, $index, 0)		// ダート適性
	$$set_uma_surface_type ($owner_id, $index, 0)		// 水面適性
	$$set_uma_new_flag     ($owner_id, $index, 0)		// Newフラグ
}

//---------------------------------------------------------------------------
// 各ＵＭＡの名前を取得する
//---------------------------------------------------------------------------
command $$get_uma_name(property $owner_id, property $index) : str
{
	return ($uma_list_name[$$get_uma_list_index($owner_id, $index)])
}

//---------------------------------------------------------------------------
// 各ＵＭＡの名前を設定する
//---------------------------------------------------------------------------
command $$set_uma_name(property $owner_id, property $index, property $name : str)
{
	// 文字数が最大数を超えている場合は丸める
	if( <UMA_NAME_MAX> < $name.len )
	{
		$name = $name.left_len(<UMA_NAME_MAX>)
	}
	
	$uma_list_name[$$get_uma_list_index($owner_id, $index)] = $name
}

//---------------------------------------------------------------------------
// ＵＭＡリストインデックスを取得する
// （オーナーIDとＵＭＡリストインデックスの指定からの取得）
//---------------------------------------------------------------------------
command $$get_uma_list_index(property $owner_id, property $list_index) : int
{
	// プレイヤーの場合はソートしたインデックスを返す
	if( $owner_id == <URACE_PLAYER_OWNER_ID> )
	{
		return ($uma_list_sort_list[$list_index])
	}
	
	elseif( $owner_id == <URACE_WILD_OWNER_ID> )
	{
		return ($$get_wild_uma_list_index($list_index))
	}
	
	return ($list_index)
	
	// ＮＰＣの場合はプレイヤー分のマージンを計算する
	//return (<PLAYER_UMA_SLOT_MAX> + $list_index)
}

//---------------------------------------------------------------------------
// 各タグデータの8bitインデックスを取得する
//---------------------------------------------------------------------------
command $$get_uma_tag_bit_index(property $owner_id, property $index, property $tag_type) : int
{
	return ($$get_uma_list_index($owner_id, $index) * 4 + $tag_type)
}

//---------------------------------------------------------------------------
// 各ＵＭＡのタグデータを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_tag(property $owner_id, property $index, property $tag_type) : int
{
	return ($uma_list_tag.bit8[$$get_uma_tag_bit_index($owner_id, $index, $tag_type)])
}

command $$set_uma_tag(property $owner_id, property $index, property $tag_type, property $value)
{
	$uma_list_tag.bit8[$$get_uma_tag_bit_index($owner_id, $index, $tag_type)] = $value
}

//---------------------------------------------------------------------------
// 各ＵＭＡのIDを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_id(property $owner_id, property $index) : int
{
	return ($$get_uma_tag($owner_id, $index, <UMA_TAG_TYPE_ID>))
}

command $$set_uma_id(property $owner_id, property $index, property $value)
{
	$$set_uma_tag($owner_id, $index, <UMA_TAG_TYPE_ID>, $value)
}

//---------------------------------------------------------------------------
// 各ＵＭＡのレアリティを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_rarity(property $owner_id, property $index) : int
{
	return ($$get_uma_tag($owner_id, $index, <UMA_TAG_TYPE_RARITY>))
}

command $$set_uma_rarity(property $owner_id, property $index, property $value)
{
	$$set_uma_tag($owner_id, $index, <UMA_TAG_TYPE_RARITY>, $value)
}

command $$add_uma_rarity(property $owner_id, property $index, property $value)
{
	$index = $$get_uma_tag_bit_index($owner_id, $index, <UMA_TAG_TYPE_RARITY>)
	
	$uma_list_tag.bit8[$index] = math.limit(<UMA_RARITY_MIN>, $uma_list_tag.bit8[$index] + $value, <UMA_RARITY_MAX>)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの走行タイプを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_run_type(property $owner_id, property $index) : int
{
	return ($$get_uma_tag($owner_id, $index, <UMA_TAG_TYPE_RUN_TYPE>))
}

command $$set_uma_run_type(property $owner_id, property $index, property $value)
{
	$$set_uma_tag($owner_id, $index, <UMA_TAG_TYPE_RUN_TYPE>, $value)
}

//---------------------------------------------------------------------------
// 各ＵＭＡのスキルIDを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_skill_id(property $owner_id, property $index) : int
{
	return ($$get_uma_tag($owner_id, $index, <UMA_TAG_TYPE_SKILL_ID>))
}

command $$set_uma_skill_id(property $owner_id, property $index, property $value)
{
	$$set_uma_tag($owner_id, $index, <UMA_TAG_TYPE_SKILL_ID>, $value)
}

//---------------------------------------------------------------------------
// 各パラメータデータの8bitインデックスを取得する
//---------------------------------------------------------------------------
command $$get_uma_param_bit_index(property $owner_id, property $index, property $param_type) : int
{
	return ($$get_uma_list_index($owner_id, $index) * 4 + $param_type)
}

//---------------------------------------------------------------------------
// 各ＵＭＡのパラメータデータを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_param(property $owner_id, property $index, property $param_type) : int
{
	return ($uma_list_param.bit8[$$get_uma_param_bit_index($owner_id, $index, $param_type)])
}

command $$set_uma_param(property $owner_id, property $index, property $param_type, property $value)
{
	$uma_list_param.bit8[$$get_uma_param_bit_index($owner_id, $index, $param_type)] = $value
}

command $$add_uma_param(property $owner_id, property $index, property $param_type, property $value, property $max_value)
{
	$index = $$get_uma_param_bit_index($owner_id, $index, $param_type)
	
	$uma_list_param.bit8[$index] = math.limit(<UMA_PARAM_MIN>, $uma_list_param.bit8[$index] + $value, $max_value)
}

//---------------------------------------------------------------------------
// 各ＵＭＡのライフを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_life(property $owner_id, property $index) : int
{
	return ($$get_uma_param($owner_id, $index, <UMA_PARAM_TYPE_LIFE>))
}

command $$set_uma_life(property $owner_id, property $index, property $value)
{
	$$set_uma_param($owner_id, $index, <UMA_PARAM_TYPE_LIFE>, $value)
}

command $$add_uma_life(property $owner_id, property $index, property $value)
{
	$$add_uma_param($owner_id, $index, <UMA_PARAM_TYPE_LIFE>, $value, <UMA_PARAM_MAX>)
}

//---------------------------------------------------------------------------
// 各ＵＭＡのスピードを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_speed(property $owner_id, property $index) : int
{
	return ($$get_uma_param($owner_id, $index, <UMA_PARAM_TYPE_SPEED>))
}

command $$set_uma_speed(property $owner_id, property $index, property $value)
{
	$$set_uma_param($owner_id, $index, <UMA_PARAM_TYPE_SPEED>, $value)
}

command $$add_uma_speed(property $owner_id, property $index, property $value)
{
	$$add_uma_param($owner_id, $index, <UMA_PARAM_TYPE_SPEED>, $value, <UMA_PARAM_MAX>)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの攻撃力を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_attack(property $owner_id, property $index) : int
{
	return ($$get_uma_param($owner_id, $index, <UMA_PARAM_TYPE_ATTACK>))
}

command $$set_uma_attack(property $owner_id, property $index, property $value)
{
	$$set_uma_param($owner_id, $index, <UMA_PARAM_TYPE_ATTACK>, $value)
}

command $$add_uma_attack(property $owner_id, property $index, property $value)
{
	$$add_uma_param($owner_id, $index, <UMA_PARAM_TYPE_ATTACK>, $value, <UMA_PARAM_MAX>)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの加速力を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_accel(property $owner_id, property $index) : int
{
	return ($$get_uma_param($owner_id, $index, <UMA_PARAM_TYPE_ACCEL>))
}

command $$set_uma_accel(property $owner_id, property $index, property $value)
{
	$$set_uma_param($owner_id, $index, <UMA_PARAM_TYPE_ACCEL>, $value)
}

command $$add_uma_accel(property $owner_id, property $index, property $value)
{
	$$add_uma_param($owner_id, $index, <UMA_PARAM_TYPE_ACCEL>, $value, <UMA_PARAM_MAX>)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの総合パラメータを取得する
//---------------------------------------------------------------------------
command $$get_uma_total_param(property $owner_id, property $index)
{
	return ($$get_uma_life($owner_id, $index) + $$get_uma_speed($owner_id, $index) + $$get_uma_attack($owner_id, $index))
}

//---------------------------------------------------------------------------
// 各地形適性データの8bitインデックスを取得する
//---------------------------------------------------------------------------
command $$get_uma_ground_type_bit_index(property $owner_id, property $index, property $ground_type) : int
{
	return ($$get_uma_list_index($owner_id, $index) * 4 + $ground_type)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの地形適性データを取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_ground_type(property $owner_id, property $index, property $ground_type) : int
{
	return ($uma_list_ground_type.bit8[$$get_uma_ground_type_bit_index($owner_id, $index, $ground_type)])
}

command $$set_uma_ground_type(property $owner_id, property $index, property $ground_type, property $value)
{
	system.debug_write_log("index[" + math.tostr($$get_uma_ground_type_bit_index($owner_id, $index, $ground_type)) + "]= " + math.tostr($value))
	$uma_list_ground_type.bit8[$$get_uma_ground_type_bit_index($owner_id, $index, $ground_type)] = $value
}

command $$add_uma_ground_type(property $owner_id, property $index, property $ground_type, property $value)
{
	$index = $$get_uma_ground_type_bit_index($owner_id, $index, $ground_type)
	
	$uma_list_ground_type.bit8[$index] = math.limit(<UMA_GROUND_TYPE_MIN>, $uma_list_ground_type.bit8[$index] + $value, <UMA_GROUND_TYPE_MAX>)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの芝適性を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_turf_type(property $owner_id, property $index) : int
{
	return ($$get_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_TURF>))
}

command $$set_uma_turf_type(property $owner_id, property $index, property $value)
{
	$$set_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_TURF>, $value)
}

command $$add_uma_turf_type(property $owner_id, property $index, property $value)
{
	$$add_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_TURF>, $value)
}

//---------------------------------------------------------------------------
// 各ＵＭＡのダート適性を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_dirt_type(property $owner_id, property $index) : int
{
	return ($$get_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_DIRT>))
}

command $$set_uma_dirt_type(property $owner_id, property $index, property $value)
{
	$$set_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_DIRT>, $value)
}

command $$add_uma_dirt_type(property $owner_id, property $index, property $value)
{
	$$add_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_DIRT>, $value)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの水面適性を取得／設定／加算する
//---------------------------------------------------------------------------
command $$get_uma_surface_type(property $owner_id, property $index) : int
{
	return ($$get_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_SURFACE>))
}

command $$set_uma_surface_type(property $owner_id, property $index, property $value)
{
	$$set_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_SURFACE>, $value)
}

command $$add_uma_surface_type(property $owner_id, property $index, property $value)
{
	$$add_uma_ground_type($owner_id, $index, <URACE_GROUND_TYPE_SURFACE>, $value)
}

//---------------------------------------------------------------------------
// 各状態データの8bitインデックスを取得する
//---------------------------------------------------------------------------
command $$get_uma_state_bit_index(property $owner_id, property $index, property $state_type) : int
{
	return ($$get_uma_list_index($owner_id, $index) * 4 + $state_type)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの状態データを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_state(property $owner_id, property $index, property $state_type) : int
{
	return ($uma_list_state.bit8[$$get_uma_state_bit_index($owner_id, $index, $state_type)])
}

command $$set_uma_state(property $owner_id, property $index, property $state_type, property $value)
{
	$uma_list_state.bit8[$$get_uma_state_bit_index($owner_id, $index, $state_type)] = $value
}

//---------------------------------------------------------------------------
// 各ＵＭＡのNewフラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_new_flag(property $owner_id, property $index) : int
{
	return ($$get_uma_state($owner_id, $index, <UMA_STATE_TYPE_NEW>))
}

command $$set_uma_new_flag(property $owner_id, property $index, property $value)
{
	$$set_uma_state($owner_id, $index, <UMA_STATE_TYPE_NEW>, $value)
}

//---------------------------------------------------------------------------
// 各ＵＭＡの称号を取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_title(property $owner_id, property $index, property $title_index) : int
{
	return ($uma_list_title.bit8[$$get_uma_list_index($owner_id, $index) * 4 * <UMA_TITLE_SLOT> + $title_index])
}

command $$set_uma_title(property $owner_id, property $index, property $title_index, property $title_id)
{
	$uma_list_title.bit8[$$get_uma_list_index($owner_id, $index) * 4 * <UMA_TITLE_SLOT> + $title_index] = $title_id
}

//---------------------------------------------------------------------------
// 各ＵＭＡが指定した称号を所持しているかどうか
//---------------------------------------------------------------------------
command $$has_uma_title(property $owner_id, property $index, property $title_id) : int
{
	property $i
	
	for( $i = 0, $i < <UMA_TITLE_SLOT_MAX>, $i += 1 )
	{
		if( $$get_uma_title($owner_id, $index, $i) == $title_id )
		{
			return (1)
		}
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// ＵＭＡリストのソートタイプを取得／設定する
//---------------------------------------------------------------------------
command $$get_my_uma_list_sort_type : int
{
	return ($uma_list_sort_type)
}

command $$set_my_uma_list_sort_type(property $type)
{
	$uma_list_sort_type = $type
}

//---------------------------------------------------------------------------
// ＵＭＡリストのソート並び順を取得／設定／反転する
//---------------------------------------------------------------------------
command $$get_my_uma_list_sort_order : int
{
	return ($uma_list_sort_order)
}

command $$set_my_uma_list_sort_order(property $order)
{
	$uma_list_sort_order = $order
}

command $$reverse_my_uma_list_sort_order
{
	$uma_list_sort_order = $$reverse_flag($uma_list_sort_order)
}

//---------------------------------------------------------------------------
// ＵＭＡリストのソートを実行する
//---------------------------------------------------------------------------
command $$sort_my_uma_list
{
	property $i
	property $j
	property $len
	property $tmp
	
	$len = $$get_my_uma_num
	
	// ソートリストを入手順で初期化する
	// 昇順
	if( $uma_list_sort_order == <URACE_SORT_ORDER_ASC> )
	{
		for( $i = 0, $i < $len, $i += 1 )
		{
			$uma_list_sort_list[$i] = $i
		}
	}
	
	// 降順
	else
	{
		for( $i = 0, $i < $len, $i += 1 )
		{
			$uma_list_sort_list[$i] = ($len - 1) - $i
		}
	}
	
	// ソートリストの作成
	switch( $uma_list_sort_type ) {
	
	// 入手順
	case(<URACE_SORT_TYPE_GET>)
		
		// 入手順は初期化で行っているので特に何もしない
		
	// ステータス順
	case(<URACE_SORT_TYPE_STATUS>)
		
		$len = $$get_my_uma_num - 1
		
		// 昇順
		if( $uma_list_sort_order == <URACE_SORT_ORDER_ASC> )
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_uma_total_param(<URACE_PLAYER_OWNER_ID>, $j) < $$get_uma_total_param(<URACE_PLAYER_OWNER_ID>, $j - 1) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
		// 降順
		else
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_uma_total_param(<URACE_PLAYER_OWNER_ID>, $j) > $$get_uma_total_param(<URACE_PLAYER_OWNER_ID>, $j - 1) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
	// レアリティ順
	case(<URACE_SORT_TYPE_RARITY>)
		
		$len = $$get_my_uma_num - 1
		
		// 昇順
		if( $uma_list_sort_order == <URACE_SORT_ORDER_ASC> )
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j) < $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j - 1) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
		// 降順
		else
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j) > $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j - 1) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
	// スキル順
	case(<URACE_SORT_TYPE_SKILL>)
		
		$len = $$get_my_uma_num - 1
		
		// 昇順
		if( $uma_list_sort_order == <URACE_SORT_ORDER_ASC> )
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_db_skill_type($$get_uma_skill_id(<URACE_PLAYER_OWNER_ID>, $j)) < $$get_db_skill_type($$get_uma_skill_id(<URACE_PLAYER_OWNER_ID>, $j - 1)) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
		// 降順
		else
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_db_skill_type($$get_uma_skill_id(<URACE_PLAYER_OWNER_ID>, $j)) > $$get_db_skill_type($$get_uma_skill_id(<URACE_PLAYER_OWNER_ID>, $j - 1)) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
	}
}

//---------------------------------------------------------------------------
// ＵＭＡ図鑑のソートタイプを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_library_sort_type : int
{
	return ($uma_library_sort_type)
}

command $$set_uma_library_sort_type(property $type)
{
	$uma_library_sort_type = $type
}

//---------------------------------------------------------------------------
// ＵＭＡ図鑑のソート並び順を取得／設定／反転する
//---------------------------------------------------------------------------
command $$get_uma_library_sort_order : int
{
	return ($uma_library_sort_order)
}

command $$set_uma_library_sort_order(property $order)
{
	$uma_library_sort_order = $order
}

command $$reverse_uma_library_sort_order
{
	$uma_library_sort_order = $$reverse_flag($uma_library_sort_order)
}

//---------------------------------------------------------------------------
// ＵＭＡ図鑑のソートを実行する
//---------------------------------------------------------------------------
command $$sort_uma_library
{
	property $i
	property $j
	property $len
	property $tmp
	
	$len = $$get_db_uma_max
	
	// ソートリストを入手順で初期化する
	// 昇順
	if( $uma_library_sort_order == <URACE_SORT_ORDER_ASC> )
	{
		for( $i = 0, $i < $len, $i += 1 )
		{
			$uma_library_sort_list[$i] = $i + 1
		}
	}
	
	// 降順
	else
	{
		for( $i = 0, $i < $len, $i += 1 )
		{
			$uma_library_sort_list[$i] = $len - $i
		}
	}
	
	// ソートリストの作成
	switch( $uma_library_sort_type ) {
	
	// 入手順
	case(<URACE_LIBRARY_SORT_TYPE_NO>)
		
		// 入手順は初期化で行っているので特に何もしない
		
	// レアリティ順
	case(<URACE_LIBRARY_SORT_TYPE_RARITY>)
		
		$len = $$get_my_uma_num - 1
		
		// 昇順
		if( $uma_list_sort_order == <URACE_SORT_ORDER_ASC> )
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j) < $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j - 1) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
		// 降順
		else
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j) > $$get_uma_rarity(<URACE_PLAYER_OWNER_ID>, $j - 1) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
	// スキル順
	case(<URACE_LIBRARY_SORT_TYPE_SKILL>)
		
		$len = $$get_my_uma_num - 1
		
		// 昇順
		if( $uma_list_sort_order == <URACE_SORT_ORDER_ASC> )
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_db_skill_type($$get_db_uma_skill_id($$get_uma_id(<URACE_PLAYER_OWNER_ID>, $j))) < $$get_db_skill_type($$get_db_uma_skill_id($$get_uma_id(<URACE_PLAYER_OWNER_ID>, $j - 1))) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
		
		// 降順
		else
		{
			for( $i = 0, $i < $len, $i += 1 )
			{
				for( $j = $len, $j > $i, $j -= 1 )
				{
					if( $$get_db_skill_type($$get_db_uma_skill_id($$get_uma_id(<URACE_PLAYER_OWNER_ID>, $j))) > $$get_db_skill_type($$get_db_uma_skill_id($$get_uma_id(<URACE_PLAYER_OWNER_ID>, $j - 1))) )
					{
						$tmp = $uma_list_sort_list[$j]
						$uma_list_sort_list[$j] = $uma_list_sort_list[$j - 1]
						$uma_list_sort_list[$j - 1] = $tmp
					}
				}
			}
		}
	}
}

//---------------------------------------------------------------------------
// 
//---------------------------------------------------------------------------
command $$get_uma_libray(property $index) : int
{
	return ($uma_library_sort_list[$index])
}

//===============================================================================================
// 捕獲したＵＭＡデータ
//===============================================================================================
//---------------------------------------------------------------------------
// 捕獲ＵＭＡリストインデックスを取得する
//---------------------------------------------------------------------------
command $$get_wild_uma_list_index(property $wild_uma_index) : int
{
	return (<PLAYER_UMA_SLOT_MAX> + <NPC_UMA_SLOT_MAX> + $wild_uma_index)
}

//---------------------------------------------------------------------------
// 捕獲したＵＭＡデータを作成する
//---------------------------------------------------------------------------
command $$create_wild_uma_data(property $id, property $wild_uma_index)
{
	property $i
	property $j
	property $index
	property $rand
	property $slot_index
	
	// 指定範囲外のIDをチェックする
	if( $id < 1 || $$get_db_uma_max < $id )
	{
		$$debug_message("追加するuma_idの指定が範囲外です。\nid:" + math.tostr($id) + "\n処理をスキップします")
		return (0)
	}
	
	// 捕獲ＵＭＡのリストインデックスを取得する
	$index = $$get_wild_uma_list_index($wild_uma_index)
	
	// 捕獲ＵＭＡのデータを設定する
	$uma_list_name[$index] = $$get_db_uma_name($id)		// 名前
	$uma_list_tag.bit8[$index * 4 + <UMA_TAG_TYPE_ID>]            = $id							// ID
	$uma_list_tag.bit8[$index * 4 + <UMA_TAG_TYPE_RARITY>]        = $$get_db_uma_rarity($id)	// レアリティ
	$uma_list_tag.bit8[$index * 4 + <UMA_TAG_TYPE_RUN_TYPE>]      = $$get_db_uma_run_type($id)	// 走行タイプ
	$uma_list_tag.bit8[$index * 4 + <UMA_TAG_TYPE_SKILL_ID>]      = $$get_db_uma_skill_id($id)	// スキルID
	$uma_list_param.bit8[$index * 4 + <UMA_PARAM_TYPE_LIFE>]      = $$get_db_uma_life($id)		// ライフ
	$uma_list_param.bit8[$index * 4 + <UMA_PARAM_TYPE_SPEED>]     = $$get_db_uma_speed($id)		// スピード
	$uma_list_param.bit8[$index * 4 + <UMA_PARAM_TYPE_ATTACK>]    = $$get_db_uma_attack($id)	// 攻撃力
	$uma_list_param.bit8[$index * 4 + <UMA_PARAM_TYPE_ACCEL>]     = $$get_db_uma_accel($id)		// 加速力
	$uma_list_ground_type.bit8[$index * 4 + <URACE_GROUND_TYPE_TURF>]    = $$get_db_uma_turf_type($id)		// 芝適性
	$uma_list_ground_type.bit8[$index * 4 + <URACE_GROUND_TYPE_DIRT>]    = $$get_db_uma_dirt_type($id)		// ダート適性
	$uma_list_ground_type.bit8[$index * 4 + <URACE_GROUND_TYPE_SURFACE>] = $$get_db_uma_surface_type($id)	// 水面適性
	
	// 称号
	for( $i = 0, $i < <UMA_TITLE_SLOT>, $i += 1 )
	{
		$uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = 0
		$uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 1] = 0
		$uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 2] = 0
		$uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 3] = 0
	}
	
	$rand = $$mng_rand(0, 99)
	if( $rand < 2 )			{ $uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = @称号_全成長率３０％ＵＰ }				// 2%
	elseif( $rand < 6 )		{ $uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = @称号_トレーナー成長率２５％ＵＰ }		// 4%
	elseif( $rand < 10 )	{ $uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = @称号_レース成長率２５％ＵＰ }			// 4%
	elseif( $rand < 15 )	{ $uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = @称号_スピード成長率２５％ＵＰ }		// 5%
	elseif( $rand < 20 )	{ $uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = @称号_スタミナ成長率２５％ＵＰ }		// 5%
	elseif( $rand < 25 )	{ $uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = @称号_テクニック成長率２５％ＵＰ }		// 5%
	elseif( $rand < 30 )	{ $uma_list_title.bit8[$index * 4 * <UMA_TITLE_SLOT> + 0] = @称号_幸運成長率２５％ＵＰ }			// 5%
}

//---------------------------------------------------------------------------
// 捕獲したＵＭＡを所持リストに追加する
//---------------------------------------------------------------------------
command $$add_my_uma_from_wild_uma(property $wild_uma_index) : int
{
	property $i
	property $index
	
	// 所持数の最大をチェックする
	if( $$is_my_uma_max )
	{
		$$debug_message("所持uma数が既に最大です。\nnum:" + math.tostr($$get_my_uma_num) + "\n処理をスキップします")
		return (0)
	}
	
	// プレイヤーの所持ＵＭＡに追加する
	$index = $$get_my_uma_num
	
	$$set_uma_name(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_name($wild_uma_index))
	$$set_uma_id(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_id($wild_uma_index))
	$$set_uma_rarity(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_rarity($wild_uma_index))
	$$set_uma_run_type(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_run_type($wild_uma_index))
	$$set_uma_skill_id(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_skill_id($wild_uma_index))
	$$set_uma_life(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_life($wild_uma_index))
	$$set_uma_speed(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_speed($wild_uma_index))
	$$set_uma_attack(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_attack($wild_uma_index))
	$$set_uma_accel(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_accel($wild_uma_index))
	$$set_uma_turf_type(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_turf_type($wild_uma_index))
	$$set_uma_dirt_type(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_dirt_type($wild_uma_index))
	$$set_uma_surface_type(<URACE_PLAYER_OWNER_ID>, $index, $$get_wild_uma_surface_type($wild_uma_index))
	
	for( $i = 0, $i < <UMA_TITLE_SLOT_MAX>, $i += 1 )
	{
		$$set_uma_title(<URACE_PLAYER_OWNER_ID>, $index, $i, $$get_wild_uma_title($wild_uma_index, $i))
	}
	
	// Newフラグ
	$$set_uma_new_flag(<URACE_PLAYER_OWNER_ID>, $index, 1)
	
	// デッキに空きがある場合は自動的に追加する
	for( $i = 0, $i < <URACE_DECK_UMA_MAX>, $i += 1 )
	{
		if( $$get_my_deck($i) == -1 )
		{
			$$set_my_deck($i, $index)
			break
		}
	}
	
	// 図鑑フラグを取得済みにする
	if( $$get_uma_library_flag($$get_wild_uma_id($wild_uma_index)) == 0 )
	{
		$$set_uma_library_flag($$get_wild_uma_id($wild_uma_index), <URACE_LIBRARY_FLAG_GET>)
		return (2)
	}
	
	// ソートを実行する
	$$sort_my_uma_list
	
	return (1)
}

//---------------------------------------------------------------------------
// 捕獲したＵＭＡの各データを取得する
//---------------------------------------------------------------------------
// 名前
command $$get_wild_uma_name(property $wild_uma_index) : str
{
	return ($uma_list_name[$$get_wild_uma_list_index($wild_uma_index)])
}

// ID
command $$get_wild_uma_id(property $wild_uma_index) : int
{
	return ($uma_list_tag.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_TAG_TYPE_ID>])
}

// レアリティ
command $$get_wild_uma_rarity(property $wild_uma_index) : int
{
	return ($uma_list_tag.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_TAG_TYPE_RARITY>])
}

// 走行タイプ
command $$get_wild_uma_run_type(property $wild_uma_index) : int
{
	return ($uma_list_tag.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_TAG_TYPE_RUN_TYPE>])
}

// スキルID
command $$get_wild_uma_skill_id(property $wild_uma_index) : int
{
	return ($uma_list_tag.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_TAG_TYPE_SKILL_ID>])
}

// ライフ
command $$get_wild_uma_life(property $wild_uma_index) : int
{
	return ($uma_list_param.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_PARAM_TYPE_LIFE>])
}

// スピード
command $$get_wild_uma_speed(property $wild_uma_index) : int
{
	return ($uma_list_param.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_PARAM_TYPE_SPEED>])
}

// 攻撃力
command $$get_wild_uma_attack(property $wild_uma_index) : int
{
	return ($uma_list_param.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_PARAM_TYPE_ATTACK>])
}

// 加速力
command $$get_wild_uma_accel(property $wild_uma_index) : int
{
	return ($uma_list_param.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <UMA_PARAM_TYPE_ACCEL>])
}

// 芝適性
command $$get_wild_uma_turf_type(property $wild_uma_index) : int
{
	return ($uma_list_ground_type.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <URACE_GROUND_TYPE_TURF>])
}

// ダート適性
command $$get_wild_uma_dirt_type(property $wild_uma_index) : int
{
	return ($uma_list_ground_type.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <URACE_GROUND_TYPE_DIRT>])
}

// 水面適性
command $$get_wild_uma_surface_type(property $wild_uma_index) : int
{
	return ($uma_list_ground_type.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 + <URACE_GROUND_TYPE_SURFACE>])
}

// 称号
command $$get_wild_uma_title(property $wild_uma_index, property $title_index) : int
{
	return ($uma_list_title.bit8[$$get_wild_uma_list_index($wild_uma_index) * 4 * <UMA_TITLE_SLOT> + $title_index])
}


//===============================================================================================
// デッキ
//===============================================================================================

//---------------------------------------------------------------------------
// デッキ名を取得／設定する
//---------------------------------------------------------------------------
command $$get_my_deck_name(property $deck_index) : str { return ($deck_name[$deck_index]) }
command $$set_my_deck_name(property $deck_index, property $name : str)
{
	// 文字数が最大数を超えている場合は丸める
	if( <URACE_DECK_NAME_MAX> < $name.len )
	{
		$name = $name.left_len(<URACE_DECK_NAME_MAX>)
	}
	
	$deck_name[$deck_index] = $name
}

//---------------------------------------------------------------------------
// 選択しているデッキにＵＭＡを取得／設定する
//---------------------------------------------------------------------------
command $$get_my_deck(property $run_order) : int
{
	return ($deck_list[$deck_select_index * <URACE_DECK_UMA_MAX> + $run_order])
}

command $$set_my_deck(property $run_order, property $uma_index)
{
	$deck_list[$deck_select_index * <URACE_DECK_UMA_MAX> + $run_order] = $uma_list_sort_list[$uma_index]
}

//---------------------------------------------------------------------------
// 指定したＵＭＡの出走順を取得する
//---------------------------------------------------------------------------
command $$get_my_deck_run_order(property $uma_index) : int
{
	property $i
	
	for( $i = 0, $i < <URACE_DECK_UMA_MAX>, $i += 1 )
	{
		if( $deck_list[$deck_select_index * <URACE_DECK_UMA_MAX> + $i] == $uma_list_sort_list[$uma_index] ) {
			return ($i)
		}
	}
	
	return (-1)
}

//---------------------------------------------------------------------------
// 選択しているデッキを取得／設定する
//---------------------------------------------------------------------------
command $$get_my_deck_index : int { return ($deck_select_index) }
command $$set_my_deck_index(property $index) { $deck_select_index = $index }

//---------------------------------------------------------------------------
// 選択しているデッキを一つ戻す／進める
//---------------------------------------------------------------------------
command $$prev_my_deck_index
{
	$deck_select_index -= 1
	
	if( $deck_select_index < 0 ) {
		$deck_select_index = <URACE_DECK_MAX> - 1
	}
}

command $$next_my_deck_index
{
	$deck_select_index += 1
	
	if( <URACE_DECK_MAX> <= $deck_select_index ) {
		$deck_select_index = 0
	}
}

//===============================================================================================
// アイテム
//===============================================================================================
//---------------------------------------------------------------------------
// アイテムを加算する
//---------------------------------------------------------------------------
command $$add_urace_item(property $id, property $value) : int
{
	// 図鑑フラグをオンにする
	if( $$get_item_library_flag($id) == 0 ) {
		$$set_item_library_flag($id, 1)
	}
	
	$my_item[$id - 1] = math.limit(0, $my_item[$id - 1] + $value, <URACE_ITEM_MAX>)
}

//---------------------------------------------------------------------------
// アイテムの所持数を取得する
//---------------------------------------------------------------------------
command $$get_urace_item_num(property $id) : int
{
	return ($my_item[$id - 1])
}


//===============================================================================================
// メダル
//===============================================================================================
//---------------------------------------------------------------------------
// 獲得メダルフラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_urace_medal_flag(property $index) : int
{
	return ($my_medal[$index])
}

command $$set_urace_medal_flag(property $index, property $flag)
{
	$my_medal[$index] = $flag
}

//---------------------------------------------------------------------------
// すべてのメダルを獲得しているか
//---------------------------------------------------------------------------
command $$get_urace_medal_complete_flag : int
{
	property $i
	
	for( $i = 0, $i < <URACE_MEDAL_MAX>, $i += 1 )
	{
		if( $$get_urace_medal_flag($i) == 0 ) {
			return (0)
		}
		
	}
	
	return (1)
}

//---------------------------------------------------------------------------
// グランドレース出場条件のメダル数を獲得しているか
//---------------------------------------------------------------------------
command $$get_urace_grand_entry_flag : int
{
	property $i
	property $num
	
	for( $i = 0, $i < <URACE_MEDAL_MAX>, $i += 1 )
	{
		if( $$get_urace_medal_flag($i) == 1 ) {
			$num += 1
		}
	}
	
	if( $num == <URACE_GRAND_ENTRY_MEDAL_NUM> ) {
		return (1)
	}
	
	if( $num > <URACE_GRAND_ENTRY_MEDAL_NUM> ) {
		return (2)
	}
	
	return (0)
}


//===============================================================================================
// 名声
//===============================================================================================
//---------------------------------------------------------------------------
// 名声ポイントを取得する
//---------------------------------------------------------------------------
command $$get_urace_honor : int
{
	return ($honor)
}

//---------------------------------------------------------------------------
// 名声ポイントを加算する
//---------------------------------------------------------------------------
command $$add_urace_honor(property $value)
{
	$honor = math.limit(<URACE_HONOR_MIN>, $honor + $value, <URACE_HONOR_MAX>)
}

//---------------------------------------------------------------------------
// 名声ランクを取得する
//---------------------------------------------------------------------------
command $$get_urace_honor_rank(property $value) : int
{
	if( $value < <URACE_HONOR_N> )			{ return (<URACE_HONOR_RANK_T>) }
	elseif( $value < <URACE_HONOR_R> )		{ return (<URACE_HONOR_RANK_N>) }
	elseif( $value < <URACE_HONOR_SR> )		{ return (<URACE_HONOR_RANK_R>) }
	elseif( $value < <URACE_HONOR_SSR> )	{ return (<URACE_HONOR_RANK_SR>) }
	elseif( $value < <URACE_HONOR_MR> )		{ return (<URACE_HONOR_RANK_SSR>) }
	else									{ return (<URACE_HONOR_RANK_MR>) }
}


//===============================================================================================
// 掲示板
//===============================================================================================
//---------------------------------------------------------------------------
// 掲示板に出現するレースリストを作成する
//---------------------------------------------------------------------------
command $$create_bbs_race_list
{
	property $i
	property $len
	property $race_id
	
	// 掲示板に出現するレースリストを初期化する
	$bbs_race_list.init
	
	// データベースから開催日を判定してレースリストを作成する
	$len = $$get_db_race_max
	for( $i = 0, $i < $len, $i += 1 )
	{
		$race_id = $i + 1
		
		if( @日付_月 != $$get_db_race_month($race_id) ) {
			continue
		}
		
		if( @日付_日 != $$get_db_race_day($race_id) ) {
			continue
		}
		
		if( @日付_時間帯 != $$get_db_race_time($race_id) ) {
			continue
		}
		
		$bbs_race_list.resize($bbs_race_list.get_size + 1)
		$bbs_race_list[$bbs_race_list.get_size - 1] = $race_id
	}
}

//---------------------------------------------------------------------------
// 掲示板に出現するレースを取得する
//---------------------------------------------------------------------------
command $$get_bbs_race(property $index) : int { return ($bbs_race_list[$index]) }

//---------------------------------------------------------------------------
// 掲示板に出現するレースの数を取得する
//---------------------------------------------------------------------------
command $$get_bbs_race_num : int { return ($bbs_race_list.get_size) }

//---------------------------------------------------------------------------
// 掲示板に出現するハンターリストを作成する
//---------------------------------------------------------------------------
command $$create_bbs_hunter_list
{
	property $i
	property $j
	property $k
	property $len
	property $index
	property $list : intlist
	property $flag
	
	// 掲示板に出現するハンターリストを初期化する
	$bbs_hunter_list.init
	$bbs_hunter_list.resize(<BBS_HUNTER_MAX>)
	$bbs_hunter_request.init
	$bbs_hunter_request.resize(<BBS_HUNTER_MAX>)
	
	// 名声ポイントから条件を満たしているハンターリストを作成する
	$len = $$get_db_hunter_id_max
	for( $i = 1, $i <= $len, $i += 1 )
	{
		switch( $$get_db_hunter_rarity($i) ) {
		case(1)
		case(2)
			if(  $$get_urace_honor < <URACE_HONOR_N> ) {
				continue
			}
		case(3)
			if(  $$get_urace_honor < <URACE_HONOR_R> ) {
				continue
			}
		case(4)
			if(  $$get_urace_honor < <URACE_HONOR_SR> ) {
				continue
			}
		case(5)
			if(  $$get_urace_honor < <URACE_HONOR_SSR> ) {
				continue
			}
		case(6)
			if(  $$get_urace_honor < <URACE_HONOR_MR> ) {
				continue
			}
		}
		
		$list.resize($list.get_size + 1)
		$list[$list.get_size - 1] = $i
	}
	
	// 掲示板に出現するハンターを選別する
	/*
	for( $i = 0, $i < <BBS_HUNTER_MAX>, $i += 1 )
	{
		$index = $$mng_rand(0, $list.get_size - 1)
		
		$flag = 0
		
		// 選別したハンターのユニークIDがかぶっている場合はレアリティの高いほうを採用する
		for( $j = 0, $j < $i, $j += 1 )
		{
			if( $$get_db_hunter_unique_id($bbs_hunter_list[$j]) == $$get_db_hunter_unique_id($list[$index]) )
			{
				if( $$get_db_hunter_rarity($bbs_hunter_list[$j]) < $$get_db_hunter_rarity($list[$index]) )
				{
					$bbs_hunter_list[$j] = $list[$index]
				}
				
				// 選別したハンターはリストから削除する
				for( $k = $index, $k < $list.get_size - 1, $k += 1 )
				{
					$list[$k] = $list[$k + 1]
				}
				$list.resize($list.get_size - 1)
				
				$i -= 1
				$flag = 1
			}
		}
		
		if( $flag == 1 ) {
			continue
		}
		
		// 選別したハンターでユニークIDがかぶっていない場合はそのまま採用する
		$bbs_hunter_list[$i] = $list[$index]
		
		// 選別したハンターはリストから削除する
		for( $j = $index, $j < $list.get_size - 1, $j += 1 )
		{
			$list[$j] = $list[$j + 1]
		}
		$list.resize($list.get_size - 1)
	}
	*/
	
	//
	$bbs_hunter_list[0] = 1
	$bbs_hunter_list[1] = 2
	$bbs_hunter_list[2] = 3
	$bbs_hunter_list[3] = 4
	$bbs_hunter_list[4] = 5
	$bbs_hunter_list[5] = 6
}

command $$create_bbs_tutorial_hunter_list
{
	$bbs_hunter_list.init
	$bbs_hunter_list.resize(3)
	$bbs_hunter_request.init
	$bbs_hunter_request.resize(3)
	
	$bbs_hunter_list[0] = @ハンター_ランナー草太
	$bbs_hunter_list[1] = @ハンター_フライヤー空見
	$bbs_hunter_list[2] = @ハンター_スイマー船田
}

command $$deb_hunter_list
{
	// todo
	$bbs_hunter_list.sets(0, 29, 29, 29)
}

//---------------------------------------------------------------------------
// 掲示板に出現するハンターを取得する
//---------------------------------------------------------------------------
command $$get_bbs_hunter(property $index) : int { return ($bbs_hunter_list[$index]) }

//---------------------------------------------------------------------------
// 掲示板に出現するハンターの数を取得する
//---------------------------------------------------------------------------
command $$get_bbs_hunter_num : int { return ($bbs_hunter_list.get_size) }

//---------------------------------------------------------------------------
// 掲示板に出現したハンターに依頼をしているかどうかを取得する
//---------------------------------------------------------------------------
command $$get_bbs_hunter_request(property $index) : int
{
	return ($bbs_hunter_request[$index])
}

//---------------------------------------------------------------------------
// 掲示板に出現したハンターに依頼をしているかどうかを設定する
//---------------------------------------------------------------------------
command $$set_bbs_hunter_request(property $index, property $value)
{
	$bbs_hunter_request[$index] = $value
}

//---------------------------------------------------------------------------
// 掲示板に出現したハンターの依頼を実行する
//---------------------------------------------------------------------------
command $$execute_hunter_request(property $index)
{
	property $i
	property $catch_uma_id
	property $catch_uma_count
	
	$hunter_result_uma_id.init
	$hunter_result_uma_new.init
	
	if( $bbs_hunter_request[$index] == 0 )
	{
		// このハンターに依頼はしていないので終了する
		$hunter_result_id = 0
		$hunter_result_uma_id.init
		$hunter_result_uma_new.init
		
		return
	}
	
	if( $bbs_hunter_request[$index] == 2 )
	{
		return
	}
	
	if( $hunter_request_num >= $hunter_request_max ) {
		return
	}
	
	// 依頼しているハンターIDを保存する
	$hunter_result_id = $bbs_hunter_list[$index]
	
	for( $i = 0, $i < <DB_HUNTER_UMA_SLOT_MAX>, $i += 1 )
	{
		$catch_uma_id = $$get_db_hunter_captured_uma_id($hunter_result_id, $i)
		
		// 捕獲ＵＭＡが設定されていない場合は処理をスキップする
		if( $catch_uma_id == 0 ) {
			continue
		}
		
		// 捕獲されたＵＭＡデータを作成する
		$$create_wild_uma_data($catch_uma_id, $catch_uma_count)
		$$add_my_uma_from_wild_uma($catch_uma_count)
		
		$catch_uma_count += 1
		
		// 捕まえたＵＭＡのIDを保存して終了する
		$hunter_result_uma_id.resize($hunter_result_uma_id.get_size + 1)
		$hunter_result_uma_id[$hunter_result_uma_id.get_size - 1] = $catch_uma_id
		
		$hunter_result_uma_new.resize($hunter_result_uma_new.get_size + 1)
		$hunter_result_uma_new[$hunter_result_uma_new.get_size - 1] = 0
		if( $$get_uma_library_flag($catch_uma_id) == 0 ) {
			$hunter_result_uma_new[$hunter_result_uma_new.get_size - 1] = 1
		}
		
		$bbs_hunter_request[$index] = 2
	}
	
	$hunter_request_num += 1
;	$hunter_result_uma_id = 0
;	$hunter_result_uma_new = 0
}

command $$is_hunter_request_max
{
	if( $hunter_request_num >= $hunter_request_max ) {
		return (1)
	}
	return (0)
}

//---------------------------------------------------------------------------
// ハンター依頼結果／ハンターIDを取得する
//---------------------------------------------------------------------------
command $$get_hunter_request_result_id : int { return ($hunter_result_id) }

//---------------------------------------------------------------------------
// ハンター依頼結果／捕まえたＵＭＡのIDを取得する
//---------------------------------------------------------------------------
command $$get_hunter_request_result_uma_id(property $index) : int { return ($hunter_result_uma_id[$index]) }

//---------------------------------------------------------------------------
// ハンター依頼結果／捕まえたＵＭＡが初めて捕まえたＵＭＡかどうかを取得する
//---------------------------------------------------------------------------
command $$get_hunter_request_result_uma_new(property $index) : int { return ($hunter_result_uma_new[$index]) }

command $$get_hunter_request_result_uma_count : int { return ($hunter_result_uma_id.get_size) }

command $$create_hunter_request_result_uma_new(property $uma_id)
{
	$hunter_result_uma_new.init
	$hunter_result_uma_new.resize($hunter_result_uma_new.get_size + 1)
	$hunter_result_uma_new[$hunter_result_uma_new.get_size - 1] = 0
	if( $$get_uma_library_flag($uma_id) == 0 ) {
		$hunter_result_uma_new[$hunter_result_uma_new.get_size - 1] = 1
	}

}

//===============================================================================================
// レースレコード
//===============================================================================================
//---------------------------------------------------------------------------
// プレイヤーのレースレコードを初期化する
//---------------------------------------------------------------------------
command $$init_my_urace_record
{
	$record_race_id.init
	$record_uma_name.init
	$record_uma_title.init
	$record_goal_order.init
	$record_goal_time.init
}

//---------------------------------------------------------------------------
// プレイヤーのレースレコードを追加する
//---------------------------------------------------------------------------
command $$add_my_urace_record(property $race_id, property $uma_name : str, property $uma_title_id, property $goal_order, property $goal_time)
{
	property $len
	
	// リストのサイズを追加する
	$len = $record_race_id.get_size + 1
	$record_race_id.resize($len)
	$record_uma_name.resize($len)
	$record_uma_title.resize($len)
	$record_goal_order.resize($len)
	$record_goal_time.resize($len)
	
	// レースレコードを設定する
	$len = $record_race_id.get_size - 1
	$record_race_id[$len]    = $race_id
	$record_uma_name[$len]   = $uma_name
	$record_uma_title[$len]  = $uma_title_id
	$record_goal_order[$len] = $goal_order
	$record_goal_time[$len]  = $goal_time
}

//---------------------------------------------------------------------------
// プレイヤーのレースレコードを削除する
//---------------------------------------------------------------------------
command $$del_my_urace_record(property $index)
{
	property $i
	property $len
	
	$len = $record_race_id.get_size - 1
	for( $i = $index, $i < $len, $i += 1 )
	{
		$record_race_id[$i]    = $record_race_id[$i + 1]
		$record_uma_name[$i]   = $record_uma_name[$i + 1]
		$record_uma_title[$i]  = $record_uma_title[$i + 1]
		$record_goal_order[$i] = $record_goal_order[$i + 1]
		$record_goal_time[$i]  = $record_goal_time[$i + 1]
	}
	
	$record_race_id.resize($len)
	$record_uma_name.resize($len)
	$record_uma_title.resize($len)
	$record_goal_order.resize($len)
	$record_goal_time.resize($len)
}

//---------------------------------------------------------------------------
// プレイヤーのレースレコード数を取得する
//---------------------------------------------------------------------------
command $$get_my_urace_record_num : int { return ($record_race_id.get_size) }

//---------------------------------------------------------------------------
// プレイヤーのレースレコードの各データを取得する
//---------------------------------------------------------------------------
command $$get_my_urace_record_race_id(property $index)    : int { return ($record_race_id[$index]) }
command $$get_my_urace_record_uma_name(property $index)   : str { return ($record_uma_name[$index]) }
command $$get_my_urace_record_uma_title(property $index)  : int { return ($record_uma_title[$index]) }
command $$get_my_urace_record_goal_order(property $index) : int { return ($record_goal_order[$index]) }
command $$get_my_urace_record_goal_time(property $index)  : int { return ($record_goal_time[$index]) }



//===============================================================================================
// 操作データ
//===============================================================================================
//---------------------------------------------------------------------------
// 掲示板の選択でＵＭＡレースを遊んだかどうかフラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_urace_played_race_in_bbs : int { return ($played_race_in_bbs) }
command $$set_urace_played_race_in_bbs(property $flag) { $played_race_in_bbs = $flag }

//---------------------------------------------------------------------------
// 一時停止フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_urace_pause_flag : int { return ($pause) }
command $$set_urace_pause_flag(property $flag) { $pause = $flag }

//---------------------------------------------------------------------------
// オートプレイフラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_urace_auto_play_flag : int { return ($auto_play) }
command $$set_urace_auto_play_flag(property $flag) { $auto_play = $flag }


//===============================================================================================
// 図鑑
//===============================================================================================
//---------------------------------------------------------------------------
// ＵＭＡ図鑑フラグを初期化する
//---------------------------------------------------------------------------
command $$init_uma_library_flag
{
	property $i
	property $len
	property $id
	
	$len = $$get_db_uma_max
	for( $i = 0, $i < $len, $i += 1 )
	{
		$id = $i + 1
		$$set_uma_library_flag($id, <URACE_LIBRARY_FLAG_NONE>)
	}
}

//---------------------------------------------------------------------------
// ＵＭＡ図鑑フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_uma_library_flag(property $uma_id) : int { return (@mng_global_flag[<URACE_LIBRARY_UMA_FLAG> + $uma_id - 1]) }
command $$set_uma_library_flag(property $uma_id, property $flag) { @mng_global_flag[<URACE_LIBRARY_UMA_FLAG> + $uma_id - 1] = $flag }

//---------------------------------------------------------------------------
// アイテム図鑑フラグを初期化する
//---------------------------------------------------------------------------
command $$init_item_library_flag
{
	property $i
	property $len
	property $id
	
	$len = $$get_db_item_max
	for( $i = 0, $i < $len, $i += 1 )
	{
		$id = $i + 1
		$$set_item_library_flag($id, <URACE_LIBRARY_FLAG_NONE>)
	}
}

//---------------------------------------------------------------------------
// アイテム図鑑フラグを取得／設定する
//---------------------------------------------------------------------------
command $$get_item_library_flag(property $item_id) : int { return (@mng_global_flag[<URACE_LIBRARY_ITEM_FLAG> + $item_id - 1]) }
command $$set_item_library_flag(property $item_id, property $flag) { @mng_global_flag[<URACE_LIBRARY_ITEM_FLAG> + $item_id - 1] = $flag }

