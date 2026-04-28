//===========================================================================
//!
//!    @file     ___mng_urace.inc
//!    @brief    ＵＭＡレースインクルードファイル
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================


























//===========================================================================
// レースアイテム
//===========================================================================
#replace	<URACE_EMPTY_RACE_ITEM_ID>		0		// 空アイテムID

#command $$init_urace_race_item						// レースアイテムデータの初期化

#command $$is_urace_race_item_available(int) : int	// アイテムが使用可能かどうか
#command $$get_urace_race_item_id(int) : int		// 所持しているレースアイテムIDを取得する
#command $$add_urace_race_item(int, int) : int		// 指定したレースアイテムを入手する
#command $$has_urace_race_item(int) : int			// レースアイテムを所持しているか
#command $$use_urace_race_item(int) : int			// レースアイテムを使用する


//===========================================================================
// レース発射物
//===========================================================================
#command $$init_urace_projectile					// レース発射物データの初期化
#command $$update_urace_projectile					// レース発射物データを更新する

#command $$add_urace_projectile(int, int, int, int, int, int, int)		// レース発射物を追加する

// deb
#command $$get_projectile_num
#command $$get_projectile_obj_no(int)
#command $$get_projectile_child_no(int)
#command $$get_projectile_place(int)







#command $$is_hunter_request_max

#command $$damage_uma(int, int, int)

#command $$take_damage_uma(int, int) : int				// ＵＭＡにダメージを与える
#command $$heal_damage_uma(int, int) : int				// ＵＭＡのHPを回復する
#command $$drain_damage_uma(int, int, int, int) : int	// ＵＭＡダメージ+吸収























































//===========================================================================
// データ定義
//===========================================================================

// グランドレース出場条件(獲得メダル数)
#replace	<URACE_GRAND_ENTRY_MEDAL_NUM>	6		// 必要メダル数

// ＵＭＡレースが参加可能な日
#replace	<URACE_ENTRY_DATE>				12		// 7/12

// グランドレースが開催される日
#replace	<URACE_GRAND_ENTRY_DATE>		24		// 7/24

// オーナー
#define		<URACE_WILD_OWNER_ID>			-1		// 捕獲した野生ＵＭＡのオーナーID
#replace	<URACE_PLAYER_OWNER_ID>			1		// プレイヤーのオーナーID
#define		<URACE_NPC_OWNER_ID>			2		// ＮＰＣのオーナーID

// ＵＭＡ最大所持数
#replace	<PLAYER_UMA_SLOT_MAX>			24		// プレイヤーのＵＭＡ最大数
#replace	<NPC_UMA_SLOT_MAX>				(12*5)		// ＮＰＣのＵＭＡ最大数
#replace	<WILD_UMA_SLOT_MAX>				5		// 野生のＵＭＡ最大数

// 地形タイプ
#replace	<URACE_GROUND_TYPE_TURF>		1		// 芝
#replace	<URACE_GROUND_TYPE_DIRT>		2		// ダート
#replace	<URACE_GROUND_TYPE_SURFACE>		3		// 水面
#replace	<URACE_GROUND_TYPE_SPACE>		4		// 宇宙

// スキル発動条件
#replace	<UMA_SKILL_FILTER_TURF>					1		// レース地形が芝のとき
#replace	<UMA_SKILL_FILTER_DIRT>					2		// レース地形がダートのとき
#replace	<UMA_SKILL_FILTER_SURFACE>				3		// レース地形が水面のとき
#replace	<UMA_SKILL_FILTER_ENEMY_NEAR>			4		// 敵が近い
#replace	<UMA_SKILL_FILTER_ENEMY_NEAR_AHEAD>		5		// 敵が近い・自分より前
#replace	<UMA_SKILL_FILTER_ENEMY_NEAR_BEHIND>	6		// 敵が近い・自分より後ろ
#replace	<UMA_SKILL_FILTER_HEROINE>				7		// レースにヒロインがいるとき
#replace	<UMA_SKILL_FILTER_NOT_TOP>				8		// 自分が先頭ではない

// スキルタイプ
#replace	<UMA_SKILL_TYPE_ATTACK>				1		// 攻撃
#replace	<UMA_SKILL_TYPE_DEFENCE>			2		// 防御
#replace	<UMA_SKILL_TYPE_ACCEL>				3		// 加速
#replace	<UMA_SKILL_TYPE_HEAL>				4		// 回復
#replace	<UMA_SKILL_TYPE_INTERRUPT>			5		// 妨害
#replace	<UMA_SKILL_TYPE_FIELD>				6		// フィールド干渉
#replace	<UMA_SKILL_TYPE_GGET_ITEM>			7		// アイテム獲得

// スキルターゲット
#replace	<UMA_SKILL_TARGET_SELF>				1		// 自分
#replace	<UMA_SKILL_TARGET_RAND_ENEMY>		2		// ランダムな敵
#replace	<UMA_SKILL_TARGET_TOP_ENEMY>		3		// 先頭の敵
#replace	<UMA_SKILL_TARGET_ALL_ENEMY>		4		// 敵全員
#replace	<UMA_SKILL_TARGET_FIELD>			5		// フィールド

// スキル効果
#replace	<UMA_SKILL_EFFECT_TYPE_CONST_SPEED>				1		// 最大スピード(固定値)
#replace	<UMA_SKILL_EFFECT_TYPE_REDUCE_SPEED>			2		// 最大スピード(徐々に減少)
#replace	<UMA_SKILL_EFFECT_TYPE_ACCEL>					3		// 加速力
#replace	<UMA_SKILL_EFFECT_TYPE_STAMINA>					4		// スタミナ
#replace	<UMA_SKILL_EFFECT_TYPE_STAMINA_DRAIN>			5		// スタミナ吸収
#replace	<UMA_SKILL_EFFECT_TYPE_HIDE_MODE>				6		// 潜伏モード
#replace	<UMA_SKILL_EFFECT_TYPE_INTERRUPT_BLOCK>			7		// 妨害無効
#replace	<UMA_SKILL_EFFECT_TYPE_TRAP_BLOCK>				8		// 障害物無効
#replace	<UMA_SKILL_EFFECT_TYPE_REVERSE_RUN>				9		// 逆走
#replace	<UMA_SKILL_EFFECT_TYPE_STUN>					10		// 気絶・スタン
#replace	<UMA_SKILL_EFFECT_TYPE_GROUND_AFFINITY>			11		// 地形適正
#replace	<UMA_SKILL_EFFECT_TYPE_GROUND>					12		// 地形変更
#replace	<UMA_SKILL_EFFECT_TYPE_SKILL_SEAL>				13		// スキル封印
#replace	<UMA_SKILL_EFFECT_TYPE_ITEM_SEAL>				14		// アイテム封印
#replace	<UMA_SKILL_EFFECT_TYPE_STONE>					15		// 石化
//-
#replace	<UMA_SKILL_EFFECT_TYPE_SPEED_DOWN>				2		// 速度低下
#replace	<UMA_SKILL_EFFECT_TYPE_STAMINA_UP>				4		// スタミナ回復
#replace	<UMA_SKILL_EFFECT_TYPE_STAMINA_DOWN>			5		// スタミナ減少
#replace	<UMA_SKILL_EFFECT_TYPE_STAMINA_DRAIN			6		// スタミナ吸収
// ---- 新HP定義（定数番号維持） ----
//#replace	<UMA_SKILL_EFFECT_TYPE_HP_HEAL>					4		// HP回復（旧:STAMINA_UP）
//#replace	<UMA_SKILL_EFFECT_TYPE_HP_DAMAGE>				5		// HP減少（旧:STAMINA_DOWN）
//#replace	<UMA_SKILL_EFFECT_TYPE_HP_DRAIN>				6		// HP吸収 - 相手へダメージ+自己回復
#replace	<UMA_SKILL_EFFECT_TYPE_HP>						4		// HP変動（旧:STAMINA_UP & DOWN）
#replace	<UMA_SKILL_EFFECT_TYPE_HP_DRAIN>				5		// HP吸収 - 相手へダメージ+自己回復
//-

// レースグレード
#replace	<RACE_GRADE_NORMAL>					1		// ノーマル
#replace	<RACE_GRADE_GRAND>					2		// グランド

// レース開催時間
#replace	<RACE_TIME_AM>						1		// 午前
#replace	<RACE_TIME_PM>						2		// 午後



//===========================================================================
// ユーザーデータ
//===========================================================================
#command $$init_urace_user_data					// ユーザーデータの初期化

#command $$create_bbs_base_data

#command $$init_urace_am_data					// ＵＭＡレース午前の初期化処理
#command $$init_urace_pm_data					// ＵＭＡレース午後の初期化処理

// 所持ＵＭＡ
#command $$get_my_uma_num : int					// プレイヤーのＵＭＡ所持数を取得する
#command $$is_my_uma_max : int					// プレイヤーのＵＭＡ所持数が最大かどうかを取得する
#command $$del_my_uma(int) : int				// ＵＭＡを所持リストから削除する

// 各ＵＭＡデータ
// 名前
#replace	<UMA_NAME_MAX>			24				// ＵＭＡ名の最大文字数(半角=1、全角=2)

#command $$get_uma_name(int, int) : str				// 各ＵＭＡの名前を取得する
#command $$set_uma_name(int, int, str)				// 各ＵＭＡの名前を設定する

// タグ
#command $$get_uma_id(int, int) : int				// 各ＵＭＡのIDを取得する
#command $$set_uma_id(int, int, int)				// 各ＵＭＡのIDを設定する

#replace	<UMA_RARITY_MIN>		1				// レアリティ最小値(☆１)
#replace	<UMA_RARITY_MAX>		4				// レアリティ最大値(☆４)

#command $$get_uma_rarity(int, int) : int			// 各ＵＭＡのレアリティを取得する
#command $$set_uma_rarity(int, int, int)			// 各ＵＭＡのレアリティを設定する
#command $$add_uma_rarity(int, int, int)			// 各ＵＭＡのレアリティを加算する

#replace	<UMA_RUN_TYPE_WALK>		1				// 歩行
#replace	<UMA_RUN_TYPE_FLY>		2				// 飛行

#command $$get_uma_run_type(int, int) : int			// 各ＵＭＡの走行タイプを取得する
#command $$set_uma_run_type(int, int, int)			// 各ＵＭＡの走行タイプを設定する
#command $$get_uma_skill_id(int, int) : int			// 各ＵＭＡのスキルIDを取得する
#command $$set_uma_skill_id(int, int, int)			// 各ＵＭＡのスキルIDを設定する

// パラメータ
#replace	<UMA_PARAM_MIN>			1				// パラメータ最小値
#replace	<UMA_PARAM_MAX>			100				// パラメータ最大値

#command $$get_uma_life(int, int) : int				// 各ＵＭＡのライフを取得する
#command $$set_uma_life(int, int, int)				// 各ＵＭＡのライフを設定する
#command $$add_uma_life(int, int, int)				// 各ＵＭＡのライフを加算する
#command $$get_uma_speed(int, int) : int			// 各ＵＭＡのスピードを取得する
#command $$set_uma_speed(int, int, int)				// 各ＵＭＡのスピードを設定する
#command $$add_uma_speed(int, int, int)				// 各ＵＭＡのスピードを加算する
#command $$get_uma_attack(int, int) : int			// 各ＵＭＡの攻撃力を取得する
#command $$set_uma_attack(int, int, int)			// 各ＵＭＡの攻撃力を設定する
#command $$add_uma_attack(int, int, int)			// 各ＵＭＡの攻撃力を加算する
#command $$get_uma_accel(int, int) : int			// 各ＵＭＡの加速力を取得する
#command $$set_uma_accel(int, int, int)				// 各ＵＭＡの加速力を設定する
#command $$add_uma_accel(int, int, int)				// 各ＵＭＡの加速力を加算する
#command $$get_uma_total_param(int, int)			// 各ＵＭＡの総合パラメータを取得する

// 地形適性(×、△、〇)
#replace	<UMA_GROUND_TYPE_MIN>		1				// 適性最小値(×)
#replace	<UMA_GROUND_TYPE_MAX>		3				// 適性最大値(〇)

#replace	<UMA_GROUND_TYPE_C>			1				// 適性(×)
#replace	<UMA_GROUND_TYPE_B>			2				// 適性(△)
#replace	<UMA_GROUND_TYPE_A>			3				// 適性(○)

#command $$get_uma_ground_type(int, int, int) : int		// 各ＵＭＡの地形適性を取得する
#command $$set_uma_ground_type(int, int, int, int)		// 各ＵＭＡの地形適性を設定する
#command $$add_uma_ground_type(int, int, int, int)		// 各ＵＭＡの地形適性を加算する
#command $$get_uma_turf_type(int, int) : int			// 各ＵＭＡの芝適性を取得する
#command $$set_uma_turf_type(int, int, int)				// 各ＵＭＡの芝適性を設定する
#command $$add_uma_turf_type(int, int, int)				// 各ＵＭＡの芝適性を加算する
#command $$get_uma_dirt_type(int, int) : int			// 各ＵＭＡのダート適性を取得する
#command $$set_uma_dirt_type(int, int, int)				// 各ＵＭＡのダート適性を設定する
#command $$add_uma_dirt_type(int, int, int)				// 各ＵＭＡのダート適性を加算する
#command $$get_uma_surface_type(int, int) : int			// 各ＵＭＡの水面適性を取得する
#command $$set_uma_surface_type(int, int, int)			// 各ＵＭＡの水面適性を設定する
#command $$add_uma_surface_type(int, int, int)			// 各ＵＭＡの水面適性を加算する

// 状態
#command $$get_uma_new_flag(int, int) : int			// 各ＵＭＡのNewフラグを取得する
#command $$set_uma_new_flag(int, int, int)			// 各ＵＭＡのNewフラグを設定する

// 称号
#replace	<UMA_TITLE_SLOT>		1						// ＵＭＡの称号枠(32bitを8bit分割するため1を指定している場合の称号枠の最大は4x1=4枠)
#define		<UMA_TITLE_SLOT_MAX>	(<UMA_TITLE_SLOT> * 4)	// ＵＭＡの称号枠最大数

#command $$get_uma_title(int, int, int) : int				// 各ＵＭＡの称号を取得する
#command $$set_uma_title(int, int, int, int)				// 各ＵＭＡの称号を設定する
#command $$has_uma_title(int, int, int) : int				// 各ＵＭＡが指定した称号を所持しているかどうか

// ソート
#replace	<URACE_SORT_TYPE_GET>				0			// 入手順
#replace	<URACE_SORT_TYPE_STATUS>			1			// ステータス順
#replace	<URACE_SORT_TYPE_RARITY>			2			// レアリティ順
#replace	<URACE_SORT_TYPE_SKILL>				3			// スキル順

#command $$get_my_uma_list_sort_type : int			// ＵＭＡリストのソートタイプを取得する
#command $$set_my_uma_list_sort_type(int)			// ＵＭＡリストのソートタイプを設定する

#replace	<URACE_SORT_ORDER_ASC>				0			// 昇順
#replace	<URACE_SORT_ORDER_DESC>				1			// 降順

#command $$get_my_uma_list_sort_order : int			// ＵＭＡリストのソート並び順を取得する
#command $$set_my_uma_list_sort_order(int)			// ＵＭＡリストのソート並び順を設定する
#command $$reverse_my_uma_list_sort_order			// ＵＭＡリストのソート並び順を反転する
#command $$sort_my_uma_list							// ＵＭＡリストのソートを実行する

// ソート（図鑑）
#replace	<URACE_LIBRARY_SORT_TYPE_NO>		0			// 番号順
#replace	<URACE_LIBRARY_SORT_TYPE_SKILL>		1			// スキル順
#replace	<URACE_LIBRARY_SORT_TYPE_RARITY>	2			// レアリティ順

#command $$get_uma_library_sort_type : int			// ＵＭＡ図鑑のソートタイプを取得する
#command $$set_uma_library_sort_type(int)			// ＵＭＡ図鑑のソートタイプを設定する
#command $$get_uma_library_sort_order : int			// ＵＭＡ図鑑のソート並び順を取得する
#command $$set_uma_library_sort_order(int)			// ＵＭＡ図鑑のソート並び順を設定する
#command $$reverse_uma_library_sort_order			// ＵＭＡ図鑑のソート並び順を反転する
#command $$sort_uma_library							// ＵＭＡ図鑑のソートを実行する

#command $$get_uma_libray(int) : int				// 

// 捕獲したＵＭＡデータ
#command $$create_wild_uma_data(int, int)			// 捕獲したＵＭＡデータを作成する
#command $$add_my_uma_from_wild_uma(int) : int		// 捕獲したＵＭＡを所持リストに追加する
#command $$get_wild_uma_name(int) : str				// 捕獲したＵＭＡの名前を取得する
#command $$get_wild_uma_id(int) : int				// 捕獲したＵＭＡのIDを取得する
#command $$get_wild_uma_rarity(int) : int			// 捕獲したＵＭＡのレアリティを取得する
#command $$get_wild_uma_life(int) : int				// 捕獲したＵＭＡのライフを取得する
#command $$get_wild_uma_speed(int) : int			// 捕獲したＵＭＡのスピードを取得する
#command $$get_wild_uma_attack(int) : int			// 捕獲したＵＭＡの攻撃力を取得する
#command $$get_wild_uma_accel(int) : int			// 捕獲したＵＭＡの加速力を取得する
#command $$get_wild_uma_turf_type(int) : int		// 捕獲したＵＭＡの芝適性を取得する
#command $$get_wild_uma_dirt_type(int) : int		// 捕獲したＵＭＡのダート適性を取得する
#command $$get_wild_uma_surface_type(int) : int		// 捕獲したＵＭＡの水面適性を取得する

// デッキ
#replace	<URACE_DECK_MAX>			5			// デッキ最大数
#replace	<URACE_DECK_UMA_MAX>		12			// デッキ内に設定できるＵＭＡ最大数
#replace	<URACE_DECK_NAME_MAX>		24			// デッキ名の最大文字数(半角=1、全角=2)

#command $$get_my_deck_name(int) : str				// デッキ名を取得する
#command $$set_my_deck_name(int, str)				// デッキ名を設定する
#command $$get_my_deck(int) : int					// 選択しているデッキにＵＭＡを取得する
#command $$set_my_deck(int, int)					// 選択しているデッキにＵＭＡを設定する
#command $$get_my_deck_run_order(int) : int			// 指定したＵＭＡの出走順を取得する
#command $$get_my_deck_index : int					// 選択しているデッキを取得する
#command $$set_my_deck_index(int)					// 選択しているデッキを設定する
#command $$prev_my_deck_index						// 選択しているデッキを一つ戻す
#command $$next_my_deck_index						// 選択しているデッキを一つ進める

// アイテム
#replace	<URACE_ITEM_MAX>			99			// 各アイテムの所持最大数

#command $$add_urace_item(int, int)					// アイテムを加算する
#command $$get_urace_item_num(int) : int			// アイテムの所持数を取得する

// メダル
#replace	<URACE_MEDAL_MAX>			10			// メダルの最大数

#command $$get_urace_medal_flag(int) : int			// 獲得メダルフラグを取得する
#command $$set_urace_medal_flag(int, int)			// 獲得メダルフラグを設定する
#command $$get_urace_medal_complete_flag : int		// すべてのメダルを獲得しているか
#command $$get_urace_grand_entry_flag : int			// グランドレース出場条件のメダル数を獲得しているか

// 名声
#replace	<URACE_HONOR_MIN>			0			// 名声ポイント最低値
#replace	<URACE_HONOR_N>				30			// 名声ポイント／Ｎ
#replace	<URACE_HONOR_R>				60			// 名声ポイント／Ｒ
#replace	<URACE_HONOR_SR>			100			// 名声ポイント／ＳＲ
#replace	<URACE_HONOR_SSR>			150			// 名声ポイント／ＳＳＲ
#replace	<URACE_HONOR_MR>			200			// 名声ポイント／ＭＲ
#replace	<URACE_HONOR_MAX>			300			// 名声ポイント最大値

#replace	<URACE_HONOR_ADDED_1ST>		30			// １着で加算される名声ポイント
#replace	<URACE_HONOR_ADDED_2ND>		15			// ２着で加算される名声ポイント
#replace	<URACE_HONOR_ADDED_3RD>		5			// ３着で加算される名声ポイント
#replace	<URACE_HONOR_ADDED_4TH>		0			// ４着で加算される名声ポイント
#replace	<URACE_HONOR_ADDED_5TH>		0			// ５着で加算される名声ポイント
#replace	<URACE_HONOR_ADDED_6TH>		0			// ６着で加算される名声ポイント

#command $$get_urace_honor : int					// 名声ポイントを取得する
#command $$add_urace_honor(int)						// 名声ポイントを加算する

#replace	<URACE_HONOR_RANK_T>		0			// 名声ランク／見習い
#replace	<URACE_HONOR_RANK_N>		1			// 名声ランク／Ｎ
#replace	<URACE_HONOR_RANK_R>		2			// 名声ランク／Ｒ
#replace	<URACE_HONOR_RANK_SR>		3			// 名声ランク／ＳＲ
#replace	<URACE_HONOR_RANK_SSR>		4			// 名声ランク／ＳＳＲ
#replace	<URACE_HONOR_RANK_MR>		5			// 名声ランク／ＭＲ

#command $$get_urace_honor_rank(int) : int			// 名声ランクを取得する

// 掲示板／レースデータ
#replace	<BBS_RACE_MAX>				1			// 掲示板に表示されるレース最大数

#command $$create_bbs_race_list						// 掲示板に出現するレースリストを作成する
#command $$get_bbs_race(int) : int					// 掲示板に出現するレースを取得する
#command $$get_bbs_race_num : int					// 掲示板に出現するレースの数を取得する

// 掲示板／ハンター依頼
#replace	<BBS_HUNTER_MAX>			6			// 掲示板に表示されるハンター最大数

#command $$create_bbs_hunter_list					// 掲示板に出現するハンターリストを作成する
#command $$get_bbs_hunter(int) : int				// 掲示板に出現するハンターを取得する
#command $$get_bbs_hunter_num : int					// 掲示板に出現するハンターの数を取得する
#command $$get_bbs_hunter_request(int) : int		// 掲示板に出現したハンターに依頼をしているかどうかを取得する
#command $$set_bbs_hunter_request(int, int)			// 掲示板に出現したハンターに依頼をしているかどうかを設定する
#command $$execute_hunter_request(int)				// 掲示板に出現したハンターの依頼を実行する
#command $$get_hunter_request_result_id : int		// ハンター依頼結果／ハンターIDを取得する
#command $$get_hunter_request_result_uma_id(int) : int	// ハンター依頼結果／捕まえたＵＭＡのIDを取得する
#command $$get_hunter_request_result_uma_new(int) : int	// ハンター依頼結果／捕まえたＵＭＡが初めて捕まえたＵＭＡかどうかを取得する
#command $$get_hunter_request_result_uma_count : int
#command $$create_hunter_request_result_uma_new(int)

// レースレコード
#command $$init_my_urace_record								// プレイヤーのレースレコードを初期化する
#command $$add_my_urace_record(int, str, int, int, int)		// プレイヤーのレースレコードを追加する
#command $$del_my_urace_record(int)							// プレイヤーのレースレコードを削除する
#command $$get_my_urace_record_num : int					// プレイヤーのレースレコード数を取得する
#command $$get_my_urace_record_race_id(int) : int			// プレイヤーレースレコード／レースIDを取得する
#command $$get_my_urace_record_uma_name(int) : str			// プレイヤーレースレコード／ＵＭＡ名を取得する
#command $$get_my_urace_record_uma_title(int) : int			// プレイヤーレースレコード／ＵＭＡの称号を取得する
#command $$get_my_urace_record_goal_order(int) : int		// プレイヤーレースレコード／着順を取得する
#command $$get_my_urace_record_goal_time(int) : int			// プレイヤーレースレコード／ゴール時間を取得する

// 操作データ
#command $$get_urace_played_race_in_bbs : int	// 掲示板の選択でＵＭＡレースを遊んだかどうかを取得する
#command $$set_urace_played_race_in_bbs(int)	// 掲示板の選択でＵＭＡレースを遊んだかどうかを設定する
#command $$get_urace_pause_flag : int			// 一時停止フラグを取得する
#command $$set_urace_pause_flag(int)			// 一時停止フラグを設定する
#command $$get_urace_auto_play_flag : int		// オートプレイフラグを取得する
#command $$set_urace_auto_play_flag(int)		// オートプレイフラグを設定する

// ＵＭＡ図鑑
#replace	<URACE_LIBRARY_FLAG_NONE>			0		// 図鑑フラグ／未取得
#replace	<URACE_LIBRARY_FLAG_LOOK>			1		// 図鑑フラグ／見たことがある
#replace	<URACE_LIBRARY_FLAG_GET>			2		// 図鑑フラグ／取得済み
#replace	<URACE_LIBRARY_FLAG_READ>			3		// 図鑑フラグ／閲覧済み

#command $$init_uma_library_flag				// ＵＭＡ図鑑フラグを初期化する
#command $$get_uma_library_flag(int) : int		// ＵＭＡ図鑑フラグを取得する
#command $$set_uma_library_flag(int, int)		// ＵＭＡ図鑑フラグを設定する

// アイテム図鑑
#command $$init_item_library_flag				// アイテム図鑑フラグを初期化する
#command $$get_item_library_flag(int) : int		// アイテム図鑑フラグを取得する
#command $$set_item_library_flag(int, int)		// アイテム図鑑フラグを設定する


//===========================================================================
// レースデータ
//===========================================================================
#replace	<URACE_ENTRY_MAX>			6			// レース参加最大人数

#command $$init_entry_race_data						// レースデータの初期化
#command $$reset_entry_race_data					// レースデータのリセット

// レース
#command $$get_entry_race_id : int					// 参加しているレースIDを取得する
#command $$set_entry_race_id(int)					// 参加しているレースIDを設定する
#command $$get_entry_race_distance : int			// 参加しているレース距離を取得する(実数[1000m = 1000 * <DISTACE_SHIFT>])
#command $$get_entry_race_distance_shift : int		// 参加しているレース距離を取得する(距離係数補正済み[1000m = 1000])
#command $$get_entry_race_ground_type : int			// 参加しているレースの現在の地形を取得する
#command $$set_entry_race_ground_type(int)			// 参加しているレースの現在の地形を設定する
#command $$get_entry_race_last_spurt_distance : int			// 参加しているラストスパート発生距離を取得する(実数[1000m = 1000 * <DISTACE_SHIFT>])
#command $$get_entry_race_last_spurt_distance_shift : int	// 参加しているラストスパート発生距離を取得する(距離係数補正済み[1000m = 1000])
#command $$check_entry_race_finished : int			// 参加しているレースが終了しているか判定する

// オーナー
#command $$entry_urace(int, int, int)				// 指定したオーナー／ＵＭＡをレースに参加させる
#command $$get_entry_pure_owner_id(int) : int		// 参加しているオーナー(乙女)IDを取得する
#command $$get_entry_pure_owner_num : int			// 参加しているオーナー(乙女)数を取得する
#command $$get_entry_uma_index(int) : int			// 参加しているＵＭＡインデックスを取得する

// レースに参加しているＵＭＡデータ
#command $$init_running_uma_data(int)					// ＵＭＡデータを初期化する
#command $$calc_running_uma_speed_max(int)				// ＵＭＡの最高速度を算出する
#command $$get_running_uma_id(int) : int				// ＵＭＡのIDを取得する
#command $$get_running_uma_name(int) : str				// ＵＭＡの名前を取得する
#command $$get_running_uma_life(int) : int				// ＵＭＡのライフを取得する
#command $$get_running_uma_life_max(int) : int			// ＵＭＡの最大ライフを取得する
#command $$get_running_uma_speed(int) : int				// ＵＭＡの速度を取得する
#command $$get_running_uma_speed_max(int) : int			// ＵＭＡの最高速度を取得する

#replace	<RUNNING_UMA_TENSION_MIN>		0			// テンション最低値
#replace	<RUNNING_UMA_TENSION_MAX>		100			// テンション最高値

#command $$get_running_uma_plus_tension(int) : int		// ＵＭＡの自動加算テンションを取得する
#command $$get_running_uma_accel(int) : int				// ＵＭＡの加速力を取得する
#command $$get_running_uma_ground_type(int, int) : int	// ＵＭＡの地形適性を取得する
#command $$get_running_uma_turf_type(int) : int			// ＵＭＡの芝適性を取得する
#command $$get_running_uma_dirt_type(int) : int			// ＵＭＡのダート適性を取得する
#command $$get_running_uma_surface_type(int) : int		// ＵＭＡの砂質適性を取得する
#command $$set_running_uma_jump_param(int, int, int)	// ＵＭＡのジャンプ時間／力を設定する
#command $$get_running_uma_jump_power(int) : int		// ＵＭＡのジャンプ力を取得する

#replace	<UMA_HIDE_MODE_NONE>			0			// 潜伏モード／-
#replace	<UMA_HIDE_MODE_FLOAT>			1			// 潜伏モード／浮遊
#replace	<UMA_HIDE_MODE_DIVE>			2			// 潜伏モード／潜る

#command $$get_running_uma_hide_mode_power(int) : int	// ＵＭＡの潜伏力を取得する
#command $$get_running_uma_invincible_flag(int) : int	// ＵＭＡの無敵フラグを取得する
#command $$set_running_uma_invincible_flag(int, int)	// ＵＭＡの無敵フラグを設定する
#command $$get_running_uma_invincible_time(int) : int	// ＵＭＡの無敵時間を取得する
#command $$set_running_uma_invincible_time(int, int)	// ＵＭＡの無敵時間を設定する
#command $$get_running_uma_block_flag(int) : int		// ＵＭＡのブロックフラグを取得する
#command $$set_running_uma_block_flag(int, int)			// ＵＭＡのブロックフラグを設定する
#command $$get_running_uma_stop_flag(int) : int			// ＵＭＡの停止フラグを取得する
#command $$set_running_uma_stop_flag(int, int)			// ＵＭＡの停止フラグを設定する

#replace	<RUNNING_UMA_ACTION_STATE_NONE>				0		// 行動／-
#replace	<RUNNING_UMA_ACTION_STATE_START_WAIT>		1		// 行動／スタート待機
#replace	<RUNNING_UMA_ACTION_STATE_START>			2		// 行動／スタート
#replace	<RUNNING_UMA_ACTION_STATE_WAIT>				3		// 行動／待機
#replace	<RUNNING_UMA_ACTION_STATE_RUN>				4		// 行動／走り
#replace	<RUNNING_UMA_ACTION_STATE_LANE_CHANGE>		5		// 行動／レーンチェンジ
#replace	<RUNNING_UMA_ACTION_STATE_RUNNER_CHANGE>	6		// 行動／交代中
#replace	<RUNNING_UMA_ACTION_STATE_STUN>				7		// 行動／気絶・スタン
#replace	<RUNNING_UMA_ACTION_STATE_GROUND_WEAK>		8		// 行動／苦手地形
#replace	<RUNNING_UMA_ACTION_STATE_LAUNCH>			9		// 行動／打ち上げ
#replace	<RUNNING_UMA_ACTION_STATE_COURSE_OUT>		10		// 行動／コースアウト
#replace	<RUNNING_UMA_ACTION_STATE_DEAD>				11		// 行動／死亡
#replace	<RUNNING_UMA_ACTION_STATE_GOAL>				12		// 行動／ゴール
#replace	<RUNNING_UMA_ACTION_STATE_STONE>			13		// 行動／石化

#replace	<RUNNING_UMA_ACTION_STATE_TRAP_FAILURE>		14		// 行動／障害物アクション／失敗

#command $$update_running_uma_action(int)				// ＵＭＡの行動を更新する
#command $$get_running_uma_action_state(int) : int		// ＵＭＡの行動を取得する
#command $$set_running_uma_action_state(int, int)		// ＵＭＡの行動を設定する
#command $$get_running_uma_action_time(int) : int		// ＵＭＡの行動時間を取得する
#command $$set_running_uma_action_time(int, int)		// ＵＭＡの行動時間を設定する
#command $$add_running_uma_action_time(int, int)		// ＵＭＡの行動時間を加算する

#replace	<RUNNING_UMA_ACTION_START_POINT>		1000		// アクションを開始する場所(障害物の手前の距離)

#command $$get_running_uma_action_trap_id(int) : int	// アクション中の障害物IDを取得する
#command $$get_running_uma_action_trap_index(int) : int	// アクション中の障害物インデックスを取得する

// スキル
#replace	<UMA_SKILL_CONSUMED_TENSION>			100		// スキル使用に消費するテンション値

#command $$init_urace_race_skill_data						// スキルデータを初期化する
#command $$init_running_uma_skill(int)						// ＵＭＡのスキルを初期化する
#command $$update_running_uma_skill(int)					// ＵＭＡのスキルを更新する
#command $$update_running_uma_skill_after(int)
#command $$activate_running_uma_skill(int, int, int)		// 指定したスキルを発動する
#command $$deactivate_running_uma_skill(int)				// スキルの発動を停止する

#command $$is_running_uma_active_skill_available(int) : int		// スキルが使用可能かどうか
#command $$get_running_uma_active_skill_id(int) : int			// 発動中のスキルIDを取得する
#command $$get_running_uma_active_skill_time(int) : int			// 発動中のスキル時間を取得する
#command $$get_running_uma_active_skill_target(int, int) : int	// 発動中のスキルのターゲットを取得する
#command $$get_running_uma_skill_cool_down_rate(int) : int		// スキルクールダウン倍率を取得する
#command $$get_running_uma_skill_id(int) : int					// ＵＭＡのスキルIDを取得する
#command $$get_running_uma_skill_cool_down(int) : int			// ＵＭＡのスキルクールタイムを取得する
#command $$get_running_uma_skill_enable(int) : int				// ＵＭＡのスキルの有効／無効を取得する

// バフ／デバフ
#replace	<RUNNING_UMA_BUFF_TYPE_CONST_SPEED_MAX>		1		// 最高速度(固定値)
#replace	<RUNNING_UMA_BUFF_TYPE_REDUCE_SPEED_MAX>	2		// 最高速度(徐々に減少する)
#replace	<RUNNING_UMA_BUFF_TYPE_ACCEL>				3		// 加速力
#replace	<RUNNING_UMA_BUFF_TYPE_STAMINA>				4		// スタミナ
//#replace	<RUNNING_UMA_BUFF_TYPE_STAMINA_DRAIN>				5		// スタミナ
#replace	<RUNNING_UMA_BUFF_TYPE_HIDE_MODE>			5		// 潜伏モード
#replace	<RUNNING_UMA_BUFF_TYPE_INTERRUPT_BLOCK>		6		// 妨害無効
#replace	<RUNNING_UMA_BUFF_TYPE_TRAP_BLOCK>			7		// 障害物無効
#replace	<RUNNING_UMA_BUFF_TYPE_REVERSE_RUN>			8		// 逆走
#replace	<RUNNING_UMA_BUFF_TYPE_STUN>				9		// スタン
#replace	<RUNNING_UMA_BUFF_TYPE_GROUND_AFFINITY>		10		// 地形適性
#replace	<RUNNING_UMA_BUFF_TYPE_SKILL_SEAL>			11		// スキル封印
#replace	<RUNNING_UMA_BUFF_TYPE_ITEM_SEAL>			12		// アイテム封印
#replace	<RUNNING_UMA_BUFF_TYPE_STONE>				13		// 石化

#command $$init_running_uma_buff									// ＵＭＡのバフ／デバフを初期化する
#command $$update_running_uma_buff									// ＵＭＡのバフ／デバフを更新する
#command $$calc_running_uma_buff
#command $$add_running_uma_buff(int, int, int, int, int, int, int)	// ＵＭＡにバフ／デバフを追加する
#command $$add_running_uma_buff_ex(int, int, int, int, int, int, int, int)	// ＵＭＡにバフ／デバフを追加する★拡張版
#command $$del_running_uma_buff(int, int)							// ＵＭＡのバフ／デバフを削除する
#command $$get_running_uma_buff_num(int) : int						// 発生しているバフ／デバフの数を取得する
#command $$get_running_uma_buff_speed_max(int) : int				// バフ／デバフによる最高速度補正を取得する
#command $$get_running_uma_buff_accel(int) : int					// バフ／デバフによる加速力補正を取得する
#command $$get_running_uma_buff_stamina(int) : int					// バフ／デバフによるスタミナ補正を取得する
#command $$get_running_uma_buff_interrupt_block(int) : int			// バフ／デバフによる妨害無効補正を取得する
#command $$get_running_uma_buff_trap_block(int) : int				// バフ／デバフによる障害物無効補正を取得する
#command $$get_running_uma_buff_reverse_run(int) : int				// バフ／デバフによる逆走補正を取得する
#command $$get_running_uma_buff_hide_mode_float(int) : int			// バフ／デバフによる潜伏モード補正(浮遊)を取得する
#command $$get_running_uma_buff_hide_mode_dive(int) : int			// バフ／デバフによる潜伏モード補正(潜る)を取得する
#command $$get_running_uma_buff_ground_affinity(int) : int			// バフ／デバフによる地形適性アップバフの補正値を取得する
#command $$get_running_uma_buff_skill_seal(int) : int				// バフ／デバフによるスキル封印補正値を取得する
#command $$get_running_uma_buff_item_seal(int) : int				// バフ／デバフによるアイテム封印補正値を取得する

#command $$get_running_uma_buff_user_index(int, int) : int			// バフ／デバフを発生させたレーン(このバフを発生させたＵＭＡ)インデックスを取得する
#command $$get_running_uma_buff_type(int, int) : int				// バフ／デバフタイプを取得する
#command $$get_running_uma_buff_amount(int, int) : int				// バフ／デバフ効果量を取得する
#command $$get_running_uma_buff_time(int, int) : int				// バフ／デバフ効果時間を取得する
#command $$get_running_uma_buff_time_max(int, int) : int			// バフ／デバフ効果最大時間を取得する
#command $$get_running_uma_buff_delay_time(int, int) : int			// バフ／デバフディレイ時間を取得する
#command $$get_running_uma_buff_delay_time_max(int, int) : int		// バフ／デバフディレイ最大時間を取得する

// 障害物データ
#replace	<TRAP_TYPE_SHIELD>			1		// タイプ／遮蔽
#replace	<TRAP_TYPE_GROUND>			2		// タイプ／地面

#replace	<TRAP_EFFECT_TYPE_SPEED_DOWN>			1		// 効果／速度ＤＯＷＮ
#replace	<TRAP_EFFECT_TYPE_STUN>					2		// 効果／スタン
#replace	<TRAP_EFFECT_TYPE_SPEED_STAMINA_DOWN>	3		// 効果／速度・スタミナＤＯＷＮ
#replace	<TRAP_EFFECT_TYPE_SPEED_UP>				4		// 効果／スタミナＵＰ

#replace	<TRAP_SUCCESS_ACTION_TYPE_JUMP>		1		// アクション／ジャンプ
#replace	<TRAP_SUCCESS_ACTION_TYPE_TACKLE>	2		// アクション／タックル

#replace	<TRAP_VANISHING_TYPE_NONE>			1		// 消失タイプ／消失しない
#replace	<TRAP_VANISHING_TYPE_SUCCESS>		2		// 消失タイプ／アクション成功時に消失する
#replace	<TRAP_VANISHING_TYPE_FAILURE>		3		// 消失タイプ／アクション失敗時に消失する

#command $$init_entry_race_trap_data					// 障害物データを初期化する
#command $$create_entry_trap_data						// 障害物データを作成する

#command $$reset_lane_trap_data(int)							// 各レーンの障害物をリセットする

#command $$get_entry_lane_item_id(int, int) : int				// 各アイテムの障害物IDを取得する
#command $$get_entry_lane_item_place(int, int) : int			// 各アイテムの障害物の位置を取得する
#command $$get_entry_lane_item_enable(int, int) : int			// 各アイテムの障害物の有効／無効を取得する
#command $$set_entry_lane_item_enable(int, int, int)

#command $$get_trap_num(int)
#command $$get_trap_id(int, int)
#command $$get_trap_place(int, int)
#command $$get_trap_enable(int, int)
#command $$set_trap_enable(int, int, int)

// 参加者（オーナー）
#command $$get_entry_owner_id(int) : int				// 参加者（オーナー）のIDを取得する
#command $$get_entry_owner_num : int					// 参加者（オーナー）の総人数を取得する
#command $$get_player_from_entry_owner_list : int		// 参加者（オーナー）からプレイヤーのインデックスを取得する
#command $$get_rival_from_entry_owner_list : int		// 参加者（オーナー）からライバルのインデックスを取得する
#command $$get_index_from_entry_owner_list(int) : int	// 参加者（オーナー）から指定したオーナーのインデックスを取得する
#command $$get_entry_owner_uma_list(int, int) : int		// 参加者（オーナー）のＵＭＡリストを取得する
#command $$set_entry_owner_uma_list(int, int, int)		// 参加者（オーナー）のＵＭＡリストを設定する
#command $$get_entry_owner_uma_list_num(int) : int		// 参加者（オーナー）の総ＵＭＡ数を取得する
#command $$get_entry_owner_uma_index(int) : int			// 参加者（オーナー）の走行中ＵＭＡインデックスを取得する
#command $$get_entry_owner_mileage(int) : int			// 参加者（オーナー）の走行距離を取得する
#command $$set_entry_owner_mileage(int, int)			// 参加者（オーナー）の走行距離を設定する

#replace	<OWNER_SKILL_POWER_MIN>			0			// スキルゲージ最低値
#replace	<OWNER_SKILL_POWER_MAX>			100			// スキルゲージ最高値

#command $$get_entry_owner_skill_power(int) : int		// 参加者（オーナー）のスキルゲージを取得する
#command $$set_entry_owner_skill_power(int, int)		// 参加者（オーナー）のスキルゲージを設定する
#command $$set_entry_owner_skill_power_max(int)			// 参加者（オーナー）のスキルゲージを最大に設定する
#command $$add_entry_owner_skill_power(int, int)		// 参加者（オーナー）のスキルゲージを加算する
#command $$get_entry_owner_retire(int) : int			// 参加者（オーナー）の失格フラグを取得する
#command $$get_entry_owner_retire_num : int				// 参加者（オーナー）の総失格人数を取得する
#command $$get_entry_owner_goal_order(int) : int		// 参加者（オーナー）の着順を取得する
#command $$set_entry_owner_goal_order(int, int)			// 参加者（オーナー）の着順を設定する
#command $$get_1st_goal_entry_owner_id : int			// １着の参加者（オーナー）を取得する
#command $$get_entry_owner_goal_time(int) : int			// 参加者（オーナー）のゴール時間を取得する
#command $$set_entry_owner_goal_time(int, int)			// 参加者（オーナー）のゴール時間を取得する
#command $$get_entry_owner_npc_think_time(int) : int	// 参加者（オーナー）のＮＰＣの思考時間を取得する

// ボイス再生トリガー
#replace	<OWNER_VOICE_TRIGGER_READY>			1		// 準備(スタートカウントダウン前)
#replace	<OWNER_VOICE_TRIGGER_START>			2		// スタート
#replace	<OWNER_VOICE_TRIGGER_GOAL>			3		// ゴール
#replace	<OWNER_VOICE_TRIGGER_TRAP_SUCCESS>	4
#replace	<OWNER_VOICE_TRIGGER_TRAP_FAILURE>	5
#replace	<OWNER_VOICE_TRIGGER_SKILL>			6
#replace	<OWNER_VOICE_TRIGGER_UNICORN>		8		// ユニコーンがスキルを発動したとき

#command $$get_entry_owner_voice_trigger(int) : int		// 参加者（オーナー）のボイス再生トリガーを取得する
#command $$set_entry_owner_voice_trigger(int, int)		// 参加者（オーナー）のボイス再生トリガーを設定する







#command $$skip_to_goal_all_uma							// すべてのＵＭＡをゴールへスキップする



//===========================================================================
// データベース
//===========================================================================
// ＵＭＡ
#command $$get_db_uma_name(int) : str						// 名前を取得する
#command $$get_db_uma_rarity(int) : int						// レアリティを取得する
#command $$get_db_uma_run_type(int) : int					// 走行タイプを取得する
#command $$get_db_uma_life(int) : int						// ライフを取得する
#command $$get_db_uma_speed(int) : int						// スピードを取得する
#command $$get_db_uma_attack(int) : int						// 攻撃力を取得する
#command $$get_db_uma_accel(int) : int						// 加速力を取得する
#command $$get_db_uma_turf_type(int) : int					// 芝適性を取得する
#command $$get_db_uma_dirt_type(int) : int					// ダート適性を取得する
#command $$get_db_uma_surface_type(int) : int				// 水面適性を取得する
#command $$get_db_uma_skill_id(int) : int					// スキルIDを取得する
#command $$get_db_uma_details(int) : str					// 詳細を取得する
#command $$get_db_uma_max : int								// データベースに登録されているＵＭＡの最大数を取得する

// ＵＭＡ（ＮＰＣ）
#command $$get_db_npc_uma_name(int) : str					// 名前を取得する
#command $$get_db_npc_uma_base_uma_id(int) : int			// 元となる種族ＩＤを取得する
#command $$get_db_npc_uma_life(int) : int					// ライフを取得する
#command $$get_db_npc_uma_speed(int) : int					// スピードを取得する
#command $$get_db_npc_uma_attack(int) : int					// 攻撃力を取得する
#command $$get_db_npc_uma_accel(int) : int					// 加速力を取得する

// スキル
#replace	<DB_SKILL_EFFECT_SLOT_MAX>		4				// スキル効果枠最大数

#command $$get_db_skill_name(int) : str						// 名前を取得する
#command $$get_db_skill_type(int) : int						// スキルタイプを取得する
#command $$get_db_skill_start_time(int) : int				// スキル開始時間を取得する
#command $$get_db_skill_time(int) : int						// スキル効果時間を取得する
#command $$get_db_skill_cool_time(int) : int				// スキルクールタイム(発動間隔)を取得する
#command $$get_db_skill_delay_time(int) : int				// スキルディレイ時間を取得する
#command $$get_db_skill_filter(int) : int					// スキルの発動条件を取得する
#command $$get_db_skill_effect_target(int, int) : int		// スキル効果ターゲットを取得する
#command $$get_db_skill_effect_type(int, int) : int			// スキル効果を取得する
#command $$get_db_skill_effect_amount(int, int) : int		// スキル効果量を取得する
#command $$get_db_skill_details(int) : str					// 詳細を取得する
#command $$get_db_skill_max : int							// データベースに登録されているスキルの最大数を取得する

// レース
#command $$get_db_race_name(int) : str						// 名前を取得する
#command $$get_db_race_grade(int) : int						// レースグレードを取得する
#command $$get_db_race_distance(int) : int					// レース距離を取得する
#command $$get_db_race_ground_type(int) : int				// レース地形を取得する
#command $$get_db_race_month(int) : int						// 開催月を取得する
#command $$get_db_race_day(int) : int						// 開催日を取得する
#command $$get_db_race_time(int) : int						// 開催時間を取得する
#command $$get_db_race_entry_rival(int) : int				// 参加するライバル(各レースに一人／ＤＢの先頭インデックス)オーナーを取得する
#command $$get_db_race_entry_owner(int, int) : int			// 参加するオーナーを取得する
#command $$get_db_race_details(int) : str					// 詳細を取得する
#command $$get_db_race_max : int							// データベースに登録されているレースの最大数を取得する

// レース障害物
#command $$get_db_trap_name(int) : str						// 名前を取得する
#command $$get_db_trap_type(int) : int						// 障害物タイプを取得する
#command $$get_db_trap_effect_type(int) : int				// 効果を取得する
#command $$get_db_trap_effect_amount(int) : int				// 効果量を取得する
#command $$get_db_trap_vanishing_flag(int) : int			// 衝突時の挙動を取得する
#command $$get_db_trap_max : int							// データベースに登録されている障害物の最大数を取得する

// アイテム
#command $$get_db_item_name(int) : str						// 名前を取得する
#command $$get_db_item_rarity(int) : int					// レアリティを取得する
#command $$get_db_item_default_num(int) : int				// 初期所持数を取得する
#command $$get_db_item_details(int) : str					// 詳細を取得する
#command $$get_db_item_max : int							// データベースに登録されているアイテムの最大数を取得する

// ハンター
#replace	<DB_HUNTER_UMA_SLOT_MAX>			4			// ハンターの捕獲ＵＭＡスロット最大数

#command $$get_db_hunter_name(int) : str					// 名前を取得する
#command $$get_db_hunter_rarity(int) : int					// レアリティを取得する
#command $$get_db_hunter_image_no(int) : int				// 画像番号を取得する
#command $$get_db_hunter_unique_id(int) : int				// ユニークIDを取得する
#command $$get_db_hunter_found_rate(int) : int				// ＵＭＡ発見率を取得する
#command $$get_db_hunter_captured_uma_id(int, int) : int	// 捕獲ＵＭＡを取得する
#command $$get_db_hunter_details(int) : str					// 詳細を取得する
#command $$get_db_hunter_max : int							// データベースに登録されているハンターの最大数を取得する
#command $$get_db_hunter_id_max : int						// データベースに登録されているハンターの最大IDを取得する

// オーナー
#command $$get_db_owner_name(int) : str					// 名前を取得する
#command $$get_db_owner_image_no(int) : int				// 画像番号を取得する
#command $$get_db_owner_pure_flag(int) : int			// 乙女フラグを取得する
#command $$get_db_owner_title(int) : str				// 称号を取得する
#command $$get_db_owner_uma_list(int, int) : int		// 所持ＵＭＡを取得する
#command $$get_db_owner_max : int						// データベースに登録されているオーナーの最大数を取得する


//===========================================================================
// 汎用描画
//===========================================================================
#define		@ＵＭＡレースシーン設定				$$urace_font_enable
												script.set_allow_joypad_mode_onoff(1)
#define		@ＵＭＡレースシーン設定解除			$$urace_font_disable
												script.set_allow_joypad_mode_onoff_default

// フォント設定
#command $$urace_font_enable				// ＵＭＡレースのフォントを有効にする
#command $$urace_font_disable				// ＵＭＡレースのフォントを無効にする

// システムメッセージ
#command $$show_urace_system_message(object, str)				// ＵＭＡレースのシステムメッセージ（汎用）を表示する
#command $$hide_urace_system_message(object)					// ＵＭＡレースのシステムメッセージ（汎用）を非表示にする

// ＵＭＡチップ
#command $$create_uma_tip_object(object, int, int, int)			// ＵＭＡチップを作成する
#command $$play_uma_tip_wait_anim(object)						// ＵＭＡチップアニメーションを再生する（待機）
#command $$play_uma_tip_move_anim(object)						// ＵＭＡチップアニメーションを再生する（走り）
#command $$play_uma_tip_jump_anim(object)						// ＵＭＡチップアニメーションを再生する（ジャンプ）
#command $$play_uma_tip_stun_anim(object)						// ＵＭＡチップアニメーションを再生する（スタン）
#command $$set_uma_tip_move_anim_time(object, int)				// ＵＭＡチップアニメーションにかける時間を設定する（待機）

// ＵＭＡデータ
#command $$create_uma_card_object(object, int, int, int)		// ＵＭＡカードを作成する
#command $$update_uma_card_object(object, int)					// ＵＭＡカードを更新する




#command $$create_uma_status_object(object, int, int, int, int)				// ＵＭＡステータスを作成する
#command $$update_uma_status_object(object, int, int)						// ＵＭＡステータスを作成する
#command $$create_uma_thumb_button(object, int, int, int, int, int, int)	// ＵＭＡサムネイルボタンを作成する
#command $$update_uma_thumb_button(object, int, int)						// ＵＭＡサムネイルボタンを更新する

#command $$create_uma_thumb_btn(object, int, int, int, int, int, int)
#command $$update_uma_thumb_btn(object, int, int, int, int)

#command $$create_uma_skill_icon(object, int, int, int)				// スキルアイコンを作成する
#command $$update_uma_skill_icon(object, int)						// スキルアイコンを更新する

// レース障害物
#command $$create_urace_trap(object, int)			// 障害物を作成する
#command $$play_urace_trap_wait_animation(object)	// 障害物の待機アニメーションを作成する
#command $$play_urace_trap_hit_animation(object)	// 障害物に当たったときのエフェクトを再生する




#command $$set_urace_button(object)										// ＵＭＡレースで使用するボタンに設定する
#command $$set_urace_button_scale(object, int, int, int)				// ＵＭＡレースで使用するボタンに設定する



#command $$show_catch_uma_card_animation(object)								// 捕獲したＵＭＡカードアニメーションを表示する
#command $$show_catch_uma_status_animation(object, object)						// 捕獲したＵＭＡステータスアニメーションを表示する

#command $$create_urace_race_base_bg(object, int)


//===========================================================================
// エフェクト描画
//===========================================================================
#replace	<URACE_EFFECT_RUN_SCATTER_TURF>				1			// 走り地形エフェクト(芝)
#replace	<URACE_EFFECT_RUN_SCATTER_DIRT>				2			// 走り地形エフェクト(ダート)
#replace	<URACE_EFFECT_RUN_SCATTER_WATER>			3			// 走り地形エフェクト(水)
#replace	<URACE_EFFECT_RUN_SCATTER_ALMIGHTY>			4			// 走り地形エフェクト(すべて)
#replace	<URACE_EFFECT_LAST_SPURT>					5			// ラストスパート
#replace	<URACE_EFFECT_LINE_TRAIL_GREEN>				10			// 線の軌跡(緑)
#replace	<URACE_EFFECT_LINE_TRAIL_YELLOW>			11			// 線の軌跡(黄色)
#replace	<URACE_EFFECT_LINE_TRAIL_RAINBOW>			12			// 線の軌跡(虹色)
#replace	<URACE_EFFECT_FIRE_TRAIL>					20			// 火の軌跡
#replace	<URACE_EFFECT_FIRE_TRAIL_ONESHOT>			21			// 火の軌跡(ワンショット)
#replace	<URACE_EFFECT_FIRE_TRAIL_RAINBOW>			22			// 火の軌跡(虹色)
#replace	<URACE_EFFECT_FIRE_TRAIL_RAINBOW_ONESHOT>	23			// 火の軌跡(ワンショット・虹色)
#replace	<URACE_EFFECT_BLOCK>						30			// ブロック
#replace	<URACE_EFFECT_AVOID>						31			// 回避
#replace	<URACE_EFFECT_CRASH_STAR_S>					40			// 衝突(星・小)
#replace	<URACE_EFFECT_CRASH_STAR_L>					41			// 衝突(星・大)
#replace	<URACE_EFFECT_SKILL_POWER_LV1>				50			// スキル発動(コモン)
#replace	<URACE_EFFECT_SKILL_POWER_LV2>				51			// スキル発動(レア)
#replace	<URACE_EFFECT_SKILL_POWER_LV3>				52			// スキル発動(ユニーク)
#replace	<URACE_EFFECT_SKILL_POWER_LV4>				53			// スキル発動(アルティメット)
#replace	<URACE_EFFECT_ENV_BOUND_GRASS>				60			// 跳ねる草
#replace	<URACE_EFFECT_ENV_BOUND_LEAF>				61			// 跳ねる葉っぱ
#replace	<URACE_EFFECT_ENV_BOUND_WATER>				62			// 跳ねる水
#replace	<URACE_EFFECT_ENV_DROP_WATER>				63			// 水への着地
#replace	<URACE_EFFECT_ENV_SWIRL_WATER>				64			// 渦巻
#replace	<URACE_EFFECT_ENV_DIG>						65			// 穴掘り
#replace	<URACE_EFFECT_POP_DARK_BALL>				80			// 闇の玉
#replace	<URACE_EFFECT_POP_HEART>					81			// ハート
#replace	<URACE_EFFECT_POP_FROZEN>					82			// 凍結
#replace	<URACE_EFFECT_POP_LIGHT>					83			// 御来光
#replace	<URACE_EFFECT_PRESSURE>						100			// プレッシャー(発動側)
#replace	<URACE_EFFECT_PRESSURE_TARGET>				101			// プレッシャー(受ける側)
#replace	<URACE_EFFECT_OBSTACLE>						102			// 抑え込み(発動側)
#replace	<URACE_EFFECT_OBSTACLE_TARGET>				103			// 抑え込み(受ける側)
#replace	<URACE_EFFECT_PULL_OUT>						104			// 引っこ抜く(発動側)
#replace	<URACE_EFFECT_PULL_OUT_TARGET>				105			// 引っこ抜く(受ける側)
#replace	<URACE_EFFECT_WIND_SLASH>					106			// 風の斬撃(発動側)
#replace	<URACE_EFFECT_WIND_SLASH_TARGET>			107			// 風の斬撃(受ける側)
#replace	<URACE_EFFECT_SHIRIKODAMA>					108			// 尻子玉(発動側)
#replace	<URACE_EFFECT_SHIRIKODAMA_TARGET>			109			// 尻子玉(受ける側)
#replace	<URACE_EFFECT_BLOOD_STEEL>					110			// 吸血(発動側)
#replace	<URACE_EFFECT_BLOOD_STEEL_TARGET>			111			// 吸血(受ける側)
#replace	<URACE_EFFECT_GROUND_WEAK>					112			// 苦手地形
#replace	<URACE_EFFECT_WIND>							200			// 風
#replace	<URACE_EFFECT_WIND_REV>						201			// 逆風
#replace	<URACE_EFFECT_SCREEN_SNOWSTORM>				300			// 吹雪
#replace	<URACE_EFFECT_SCREEN_LIGHT_GLITTER>			301			// 御来光


#replace	<URACE_EFFECT_FIRE_SPARK_H>				100			// 火花(横)
#replace	<URACE_EFFECT_FIRE_SPARK_V>				110			// 火花(縦)
#replace	<URACE_EFFECT_WAVE>						991			// 波
#replace	<URACE_EFFECT_SWEAT>					992			// 汗
#replace	<URACE_EFFECT_RUN_SPARKLE>				996			// キラキラの軌跡
#replace	<URACE_EFFECT_COLLECT_POWER>			997			// パワーをためる
#replace	<URACE_EFFECT_RADIAL_INV_TRI_R>			160			// 放射する逆三角形（赤）
#replace	<URACE_EFFECT_RADIAL_INV_TRI_G>			170			// 放射する逆三角形（緑）
#replace	<URACE_EFFECT_RADIAL_INV_TRI_B>			180			// 放射する逆三角形（青）
#replace	<URACE_EFFECT_SPEED_DOWN>				370			// スピードダウン
#replace	<URACE_EFFECT_CRASH_S_LOOP>				400			// 衝突(小・ループ)
#replace	<URACE_EFFECT_EMERGENCY_BRAKE>			430			// 急ブレーキ

#replace	<URACE_EFFECT_RADIAL_STAR>				120			// 放射する星

#command $$create_urace_effect(object, int, int, int, int)	// エフェクトを作成する
#command $$play_urace_effect(object)						// エフェクトを再生する
#command $$play_urace_effect_delay(object, int)				// エフェクトを再生する(ディレイあり)
#command $$stop_urace_effect(object)						// エフェクトを停止する


//===========================================================================
// システム文字
//===========================================================================
#command $$get_urace_unknown_text : str						// 名称が不明な場合の文字列を取得する
#command $$get_urace_rarity_star_text(int) : str			// レアリティ(★表記)の文字列を取得する
#command $$get_urace_run_type_text(int) : str				// 走行タイプの文字列を取得する
#command $$get_urace_param_rarity_text(int) : str			// パラメーターレアリティの文字列を取得する
#command $$get_urace_ground_type_rank_text(int) : str		// 地形タイプのランクの文字列を取得する
#command $$get_urace_default_deck_name(int) : str			// デフォルトのデッキ名を取得する
#command $$get_urace_race_date_text(int, int) : str			// レース開催日の文字列を取得する
#command $$get_urace_race_time_text(int) : str				// レース開催時間の文字列を取得する
#command $$get_urace_race_grade_text(int) : str				// レースグレードの文字列を取得する
#command $$get_urace_race_ground_type_text(int) : str		// レース地形の文字列を取得する
#command $$get_urace_race_distance_text(int) : str			// レース距離の文字列を取得する
#command $$get_urace_time_text(int) : str					// 時間の文字列を取得する
#command $$get_urace_uma_title_text(int) : str				// ＵＭＡの称号の文字列を取得する
#command $$get_urace_hunter_commnet_text(int) : str			// ハンター依頼時のハンターの意気込みを取得する
#command $$get_urace_medal_get_text(int) : str				// メダル獲得時の文字列を取得する
#command $$get_urace_medal_info_text(int) : str				// メダル詳細の文字列を取得する
#command $$get_urace_honor_rank_up_text(int) : str			// 名声ランクが昇格した時の文字列を取得する
#command $$get_urace_new_hunter_text : str					// 新しいハンターが出現した時の文字列を取得する

//===========================================================================
// ボタングループ
//===========================================================================
#replace	<URACE_BTN_GROUP_NORMAL>			0			// 汎用
#replace	<URACE_BTN_GROUP_MODAL>				1			// モーダル(階層＝１)
#replace	<URACE_BTN_GROUP_MODAL_2>			2			// モーダル(階層＝２)
#replace	<URACE_BTN_GROUP_UMA_INFO>			2			// ＵＭＡ詳細

#define		@mng_btngroup				front.objbtngroup[<MNG_BTNGROUP_NO>]			// ミニゲームで使用するボタングループ


//===========================================================================
// シナリオ遷移
//===========================================================================
#define		@ＵＭＡハンター結果処理へ			if( @ＵＭＡレースに参加している ) { farcall("___mng_urace", 10) }
#define		@ＵＭＡハンターの結果表示			farcall("___mng_urace", 11)
#define		@ＵＭＡハンター結果シナリオへ		farcall(@ＵＭＡレースシナリオファイル, 300)		@fade(25)

#define		@ＵＭＡレースユーザー制御開始
	close
	set_mwnd(3)
	syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	syscom.set_auto_mode_onoff_flag(0)		// オートモードを解除する
	script.set_auto_savepoint_off			// セーブポイントをオフにする
	script.set_msg_back_disable				// メッセージバックを禁止する
	script.set_msg_back_off					// メッセージバックを追加しない

#define		@ＵＭＡレースユーザー制御解除
	close
	syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを解除する
	syscom.set_syscom_menu_enable			// システムコマンドを解除する
	script.set_auto_savepoint_on			// セーブポイントをオンにする
	script.set_msg_back_enable				// メッセージバックを許可する
	script.set_msg_back_on					// メッセージバックを追加する
	set_mwnd(0)


//===========================================================================
// マクロ
//===========================================================================
#define		@ＵＭＡレースデータ初期化		@ミニゲーム用乱数初期化
											$$init_urace_user_data
											$$init_entry_race_data

// ＵＭＡ
#macro		@ＵＭＡを手に入れる(@ＵＭＡ名)
	$$create_wild_uma_data(@ＵＭＡ名, 0)
	$$add_my_uma_from_wild_uma(0)
	$$create_hunter_request_result_uma_new(@ＵＭＡ名)
	farcall("___mng_urace", 11)

// アイテム
#macro		@ＵＭＡレースアイテム獲得(@アイテム名)
	$$add_urace_item(@アイテム名, 1)

// メダル
#macro		@ＵＭＡレース_メダル獲得(@レース名)
	@bs
	close
	$$urace_font_enable
	$$set_urace_medal_flag(@レース名 - 1, 1)
	$$play_medal_get_animation(front.object[<OBJ_APP_EFFECT02>], @レース名)
	$$urace_font_disable()

#command $$play_medal_get_animation(object, int)

#define		@グランドカップ出場に必要なメダルを初めて集めた		($$get_urace_grand_entry_flag == 1)
#define		@グランドカップ出場に必要なメダルを集めている		($$get_urace_grand_entry_flag == 2)
#define		@グランドカップ前に敗退した							($$get_urace_grand_entry_flag == 0 && ((<URACE_GRAND_ENTRY_DATE> - 1 <= @日付_日 && @日付_時間帯 == @午後) || (<URACE_GRAND_ENTRY_DATE> <= @日付_日)) )

// レース
#define		@参加しているレース				$$get_entry_race_id
#define		@レースの勝利者					$$get_1st_goal_entry_owner_id
#define		@レースのライバル				$$get_db_race_entry_rival($$get_entry_race_id)

// ＵＭＡハンター
#define		@会話中のＵＭＡハンター			$$get_hunter_request_result_id
#define		@ハンターが捕まえたＵＭＡ		$$get_hunter_request_result_uma_id(0)

// ランダム
#define		@ミニゲーム用乱数初期化			$$mng_rand_init(system.get_unix_time)


//===========================================================================
// サウンド
//===========================================================================
#replace	<URACE_BUTTON_SE_HIT>			0			// ボタン／マウスオーバー
#replace	<URACE_BUTTON_SE_DECIDE>		1			// ボタン／決定
#replace	<URACE_BUTTON_SE_CANCEL>		2			// ボタン／キャンセル

#define		@ＳＥ_ＵＭＡレース_ボタン_決定				se.play_by_se_no(<URACE_BUTTON_SE_DECIDE>)
#define		@ＳＥ_ＵＭＡレース_ボタン_キャンセル		se.play_by_se_no(<URACE_BUTTON_SE_CANCEL>)


//===========================================================================
// デバッグ
//===========================================================================
#command $$create_urace_debug_mode(int, int)		// デバッグモードを作成する(各シーンからコールする側)
#command $$update_urace_debug_mode(int)				// デバッグモードを更新する(各シーンからコールする側)
#command $$create_urace_race_debug_mode(object)		// デバッグモードを作成する(レース中)
#command $$update_urace_race_debug_mode(object)		// デバッグモードを更新する(レース中)
#command $$finished_urace_race_debug_mode(object)	// デバッグモードを終了する(レース中)

#define		@ＵＭＡデバッグ参加
	@ミニゲーム用乱数初期化
	@ＵＭＡレースに参加している = 1
	@ＵＭＡレースデータ初期化
	if( 1 ) {
		$$create_wild_uma_data(math.rand(5,6), 0)
		$$add_my_uma_from_wild_uma(0)
	}
	elseif( 0 ) {
		for( l[0] = 0, l[0] < 30, l[0] += 1 )
		{
			if( 1 )
			{
				$$create_wild_uma_data(l[0] + 1, 0)
				$$add_my_uma_from_wild_uma(0)
			}
		}
	}

#define		@ＵＭＡデバッグ_ＵＭＡを適当に追加
	for( l[0] = 0, l[0] < 30, l[0] += 1 )
	{
		if( math.rand(0, 1) )
		{
			$$create_wild_uma_data(l[0] + 1, 0)
			$$add_my_uma_from_wild_uma(0)
		}
	}


//===========================================================================
// テスト
//===========================================================================
#command $$uma_param_to_rank(int) : int
#command $$has_entry_race_uma : int

#command $$set_urace_npc_race_entry_data

#command $$create_npc_uma_data(int, int)


#command $$deb_hunter_list
#command $$create_bbs_tutorial_hunter_list

//2
#replace	<URACE_LANE_MAX>		6

#replace	<URACE_DAMAGE_TYPE_GROUND>			1	// 地形適正なし
#replace	<URACE_DAMAGE_TYPE_COURSE_OUT>		2	// コースアウト（多分もう仕様にない
#replace	<URACE_DAMAGE_TYPE_TRAP>			3	// 障害物
#replace	<URACE_DAMAGE_TYPE_ITEM>			4	// アイテム
#replace	<URACE_DAMAGE_TYPE_SKILL>			5	// スキル
#replace	<URACE_DAMAGE_TYPE_FORCE>			6	// 全て貫通の強制ダメージ（存在するのか？

#command $$has_next_uma(int)
#command $$get_left_uma(int)
#command $$move_lane(int, int)
#command $$get_now_lane(int)
#command $$check_trap(int)
#command $$check_item(int)
#command $$recreate_uma_tip(int)
#command $$retire_uma_tip(int)
#command $$change_runnig_uma(int, int)
#command $$change_uma_tip(int)
#command $$add_bullet(int, int, int)
#command $$del_bullet(int, int)
#command $$get_o
#command $$get_c
#command $$del_item_box(int, int)
#command $$get_item_size
#command $$update_order
#command $$get_order(int)
#command $$set_course_data
#command $$npc(int)


//===========================================================================
// アップデートパッチ用
//===========================================================================
#property   $urace_il00 : intlist
#property   $urace_il01 : intlist
#property   $urace_il02 : intlist
#property   $urace_il03 : intlist
#property   $urace_il04 : intlist
#property   $urace_il05 : intlist
#property   $urace_il06 : intlist
#property   $urace_il07 : intlist
#property   $urace_il08 : intlist
#property   $urace_il09 : intlist
#property   $urace_il10 : intlist
#property   $urace_il11 : intlist
#property   $urace_il12 : intlist
#property   $urace_il13 : intlist
#property   $urace_il14 : intlist
#property   $urace_il15 : intlist
#property   $urace_il16 : intlist
#property   $urace_il17 : intlist
#property   $urace_il18 : intlist
#property   $urace_il19 : intlist

#property   $urace_sl00 : strlist
#property   $urace_sl01 : strlist
#property   $urace_sl02 : strlist
#property   $urace_sl03 : strlist
#property   $urace_sl04 : strlist
#property   $urace_sl05 : strlist
#property   $urace_sl06 : strlist
#property   $urace_sl07 : strlist
#property   $urace_sl08 : strlist
#property   $urace_sl09 : strlist
 