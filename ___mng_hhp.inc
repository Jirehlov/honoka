//===========================================================================
//!
//!    @file     ___mng_hhp.inc
//!    @brief    ヘビヘビパニック定義
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

//===========================================================================
// システム系定義
//===========================================================================

// オブジェクト
#replace	<HHP_OBJ_BG_BACK>				0		// 背景(背面)
#replace	<HHP_OBJ_BG_FFRONT>				1		// 背景(前面)
#replace	<HHP_OBJ_PLAYER_SHIELD>			3		// プレイヤーシールド(フェンス)
#replace	<HHP_BTN_SKILL>					4		// 奥義ボタン
#replace	<HHP_BTN_PAUSE>					5		// 一時停止ボタン
#replace	<HHP_OBJ_MAIN_UI>				6		// メインＵＩ
#replace	<HHP_OBJ_CUTIN>					7		// カットイン
#replace	<HHP_OBJ_SYS_MESSAGE>			8		// システムメッセージ
#replace	<HHP_DUMMY>					9		// ダミー
#replace	<HHP_OBJ_BOSS_SHADOW>			10		// ボス／影
#replace	<HHP_OBJ_ENEMY_SHADOW>			11		// 敵／影
#replace	<HHP_OBJ_BOSS>					99		// ボス
#replace	<HHP_OBJ_ENEMY_START>			100		// 敵（ループバッファ／最初）
#replace	<HHP_OBJ_ENEMY_END>				199		// 敵（ループバッファ／最終)）
#replace	<HHP_OBJ_ATTACK_HITBOX_START>	200		// プレイヤーの攻撃ヒットボックス（ループバッファ／最初）
#replace	<HHP_OBJ_ATTACK_HITBOX_END>		299		// プレイヤーの攻撃ヒットボックス（ループバッファ／最終）
#replace	<HHP_OBJ_EFFECT_START>			300								// エフェクト（最初）
#define		<HHP_OBJ_EFFECT_PLAYER_ATTACK>	(<HHP_OBJ_EFFECT_START> + 0)	// エフェクト（固定／プレイヤーの攻撃）
#define		<HHP_OBJ_EFFECT_BUF_START>		(<HHP_OBJ_EFFECT_START> + 1)	// エフェクト（ループバッファ／最初）
#define		<HHP_OBJ_EFFECT_BUF_END>		(<HHP_OBJ_EFFECT_END>)			// エフェクト（ループバッファ／最終)）
#replace	<HHP_OBJ_EFFECT_END>			399								// エフェクト（最終）
#replace	<HHP_OBJ_MODAL>					400		// モーダルＵＩ
#replace	<HHP_OBJ_DEBUG>					450		// デバッグ

// レイヤー値
#replace	<HHP_LAYER_BG_BACK>				0		// 背景(背面)
#replace	<HHP_LAYER_BG_FRONT>			5		// 背景(前面)
#replace	<HHP_LAYER_ENEMY_SPAWN_POINT>	10		// 敵スポーン位置(茂み)
#replace	<HHP_LAYER_BOSS>				1000	// ボス
#replace	<HHP_LAYER_PLAYER_SHIELD>		2000	// プレイヤーシールド(フェンス)
#replace	<HHP_LAYER_EFFECT>				5000	// エフェクト
#replace	<HHP_LAYER_UI>					10000	// ＵＩ
#replace	<HHP_LAYER_CUTIN>				15000	// カットイン
#replace	<HHP_LAYER_SYS_MESSAGE>			16000	// システムメッセージ
#replace	<HHP_LAYER_MODAL>				20000	// モーダルＵＩ
#replace	<HHP_LAYER_DEBUG>				40000	// デバッグ用

// ボタングループ
#replace	<HHP_BTNGROUP_NORMAL>			0		// 通常画面
#replace	<HHP_BTNGROUP_MODAL>			1		// 準備／報酬／一時停止画面
#replace	<HHP_BTNGROUP_ITEM_INFO>		2		// アイテム詳細

// キャラクター
#replace	<HHP_CHARA_ID_SP>				0		// スピカ
#replace	<HHP_CHARA_ID_AI>				1		// 愛乃
#replace	<HHP_CHARA_ID_HI>				2		// 淡雪
#replace	<HHP_CHARA_ID_KY>				3		// 小詠
#replace	<HHP_CHARA_ID_RK>				4		// 六花


//===========================================================================
// ユーザー／プレイデータ
//===========================================================================
#command $$init_hhp_player_data							// プレイヤーデータの初期化(初回)
#command $$restart_hhp_player_data						// プレイヤーデータの初期化(再ゲーム開始時)
#command $$update_hhp_player_data						// プレイヤーデータの更新

// プレイヤーデータ
#command $$get_hhp_player_life : int					// ライフを取得する
#command $$set_hhp_player_life(int)						// ライフを設定する
#command $$add_hhp_player_life(int)						// ライフを加算する
#command $$get_hhp_player_life_max : int				// 最大ライフを取得する
#command $$set_hhp_player_life_max(int)					// 最大ライフを設定する
#command $$add_hhp_player_life_max(int)					// 最大ライフを加算する
#command $$get_hhp_player_life_permanently : int		// 永続ライフを取得する
#command $$add_hhp_player_life_permanently(int)			// 永続ライフを加算する
#command $$get_hhp_player_attack_power : int			// 攻撃力を取得する
#command $$set_hhp_player_attack_power(int)				// 攻撃力を設定する
#command $$add_hhp_player_attack_power(int)				// 攻撃力を加算する
#command $$get_hhp_player_total_attack_power_rate : int	// 攻撃力補正値／乗算を取得する（アイテム含む）
#command $$get_hhp_player_total_attack_power : int		// 攻撃力を取得する（アイテム含む）
#command $$get_hhp_player_attack_power_permanently : int// 永続攻撃力を取得する
#command $$add_hhp_player_attack_power_permanently(int)	// 永続攻撃力を加算する
#command $$get_hhp_player_attack_range : int			// 攻撃範囲を取得する
#command $$set_hhp_player_attack_range(int)				// 攻撃範囲を設定する
#command $$add_hhp_player_attack_range(int)				// 攻撃範囲を加算する
#command $$get_hhp_player_total_attack_range : int		// 攻撃範囲を取得する（アイテム含む）
#command $$get_hhp_player_attack_range_count : int		// 現在の広範囲攻撃になるまでの攻撃回数を取得する
#command $$add_hhp_player_attack_range_count(int)		// 現在の広範囲攻撃になるまでの攻撃回数を加算する
#command $$reset_hhp_player_attack_range_count			// 現在の広範囲攻撃になるまでの攻撃回数を初期化する
#command $$get_hhp_player_attack_range_count_max : int	// 広範囲攻撃になるまでの攻撃回数を取得する
#command $$set_hhp_player_attack_range_count_max(int)	// 広範囲攻撃になるまでの攻撃回数を設定する
#command $$get_hhp_player_attack_double : int			// 二重攻撃フラグを取得する
#command $$set_hhp_player_attack_double(int)			// 二重攻撃フラグを設定する
#command $$get_hhp_player_attack_penetration : int		// 貫通攻撃フラグを取得する
#command $$set_hhp_player_attack_penetration(int)		// 貫通攻撃フラグを設定する
#command $$get_hhp_player_attack_horizontal : int		// 水平攻撃フラグを取得する
#command $$set_hhp_player_attack_horizontal(int)		// 水平攻撃フラグを設定する
#command $$get_hhp_player_attack_vertical : int			// 垂直攻撃フラグを取得する
#command $$set_hhp_player_attack_vertical(int)			// 垂直攻撃フラグを設定する
#command $$get_hhp_player_critical_rate : int			// クリティカル率を取得する
#command $$set_hhp_player_critical_rate(int)			// クリティカル率を設定する
#command $$add_hhp_player_critical_rate(int)			// クリティカル率を加算する
#command $$get_hhp_player_total_critical_rate : int		// クリティカル率を取得する（アイテム含む）
#command $$get_hhp_player_critical_damage_rate : int	// クリティカルダメージ倍率を取得する
#command $$set_hhp_player_critical_damage_rate(int)		// クリティカルダメージ倍率を設定する
#command $$add_hhp_player_critical_damage_rate(int)		// クリティカルダメージ倍率を加算する
#command $$get_hhp_player_stun_power : int				// スタン力を取得する
#command $$set_hhp_player_stun_power(int)				// スタン力を設定する
#command $$add_hhp_player_stun_power(int)				// スタン力を加算する
#command $$get_hhp_player_total_stun_power : int		// スタン力を取得する（アイテム含む）
#command $$get_hhp_player_regen_power : int				// 回復率を取得する
#command $$set_hhp_player_regen_power(int)				// 回復率を設定する
#command $$add_hhp_player_regen_power(int)				// 回復率を加算する
#command $$get_hhp_player_total_regen_power : int		// 回復率を取得する（アイテム含む）
#command $$get_hhp_player_spike_power : int				// スパイク（カウンターダメージ）を取得する
#command $$add_hhp_player_spike_power(int)				// スパイク（カウンターダメージ）を加算する
#command $$reset_hhp_player_spike_power					// スパイク（カウンターダメージ）をリセットする
#command $$get_hhp_player_invincible_time : int			// 無敵時間を取得する
#command $$set_hhp_player_invincible_time(int)			// 無敵時間を設定する
#command $$get_hhp_player_invincible_time_rate : int	// 無敵時間補正を取得する
#command $$set_hhp_player_invincible_time_rate(int)		// 無敵時間補正を設定する
#command $$get_hhp_player_invincible_enable : int		// 無敵有効フラグを取得する
#command $$set_hhp_player_invincible_enable(int)		// 無敵有効フラグを設定する
#command $$get_hhp_player_invincible_stack_flag : int	// 無敵スタックフラグを取得する
#command $$set_hhp_player_invincible_stack_flag(int)	// 無敵スタックフラグを設定する
#command $$get_hhp_player_rivival_flag : int			// 蘇生フラグを取得する
#command $$set_hhp_player_rivival_flag(int)				// 蘇生フラグを設定する

#replace	<HHP_COMBO_MAX>				99999			// コンボ最大数

#command $$get_hhp_player_combo : int					// コンボ数を取得する
#command $$add_hhp_player_combo(int)					// コンボ数を加算する
#command $$reset_hhp_player_combo						// コンボ数をリセットする
#command $$get_hhp_player_combo_max : int				// 最大コンボ数を取得する
#command $$get_hhp_player_combo_timer : int				// コンボタイマーを取得する

#replace	<HHP_ATTACK_DAMAGE_MAX>		99999			// 最大ダメージ

#command $$get_hhp_player_attacked_damage_max : int		// 最大ダメージを取得する
#command $$set_hhp_player_attacked_damage_max(int)		// 最大ダメージを設定する
#command $$get_hhp_score : int							// スコアを取得する
#command $$set_hhp_score(int)							// スコアを設定する
#command $$add_hhp_score(int)							// スコアを加算する
#command $$get_hhp_hi_score : int						// ハイスコアを取得する
#command $$set_hhp_hi_score(int)						// ハイスコアを設定する

#replace	<HHP_PLAY_LEVEL_MIN>		1				// プレイレベル(難易度)最小値
#replace	<HHP_PLAY_LEVEL_MAX>		11				// プレイレベル(難易度)最大値

#command $$get_hhp_play_level : int						// プレイレベル(難易度)を取得する
#command $$set_hhp_play_level(int)						// プレイレベル(難易度)を設定する
#command $$add_hhp_play_level(int)						// プレイレベル(難易度)を加算する

#replace	<HHP_PLAY_MODE_NORMAL>		0				// 通常モード
#replace	<HHP_PLAY_MODE_ENDLESS>		1				// エンドレスモード

#command $$get_hhp_play_mode : int						// プレイモードを取得する
#command $$set_hhp_play_mode(int)						// プレイモードを設定する

#command $$get_hhp_play_count(int) : int				// プレイ回数（レベル別）を取得する
#command $$add_hhp_play_count(int)						// プレイ回数（レベル別）を加算する
#command $$get_hhp_total_play_count : int				// プレイ回数（総合）を取得する
#command $$get_hhp_global_play_count : int				// プレイ回数（グローバル）を取得する
#command $$add_hhp_global_play_count					// プレイ回数（グローバル）を加算する

#replace	<HHP_PLAY_RESULT_NONE>		-1				// バトル中
#replace	<HHP_PLAY_RESULT_WIN>		0				// 勝利
#replace	<HHP_PLAY_RESULT_LOSE>		1				// 敗北

#command $$get_hhp_play_result : int					// プレイ結果を取得する
#command $$set_hhp_play_result(int)						// プレイ結果を設定する

// 入力
#command $$update_player_push_attack_key				// プレイヤーの攻撃ボタン入力を更新する

#command $$get_hhp_push_attack_key : int				// プレイヤーの攻撃ボタン入力を取得する
#command $$get_hhp_push_attack_key_repeat : int			// プレイヤーの攻撃ボタン入力(キーリピート)を取得する
#command $$get_hhp_push_attack_key_repeat_max : int		// プレイヤーの攻撃ボタン入力(キーリピート最大)を取得する

#command $$hhp_player_trigger_on_attack					// プレイヤー攻撃時に発生するイベント

// システム
#command $$get_hhp_pause_flag : int						// 一時停止フラグを取得する
#command $$set_hhp_pause_flag(int)						// 一時停止フラグを設定する
#command $$get_hhp_autoplay_flag : int					// オートプレイフラグを取得する
#command $$set_hhp_autoplay_flag(int)					// 一時停止フラグを設定する

// 報酬
#command $$create_hhp_rewards_list						// 報酬リストを作成する
#command $$get_hhp_rewards_list(int) : int				// 報酬リストを取得する
#command $$get_hhp_rewards_list_count : int				// 報酬リストの選択数を取得する
#command $$get_hhp_rewards_num : int					// 入手した報酬個数を取得する
#command $$add_hhp_rewards_num(int)						// 入手した報酬個数を加算する

#command $$get_hhp_rewards_high_tier_rate : int			// 高レアリティ報酬の発生率を取得する
#command $$add_hhp_rewards_high_tier_rate(int)			// 高レアリティ報酬の発生率を加算する

#command $$get_hhp_rewards_reroll : int					// 報酬リストのリロール数を取得する
#command $$add_hhp_rewards_reroll(int)					// 報酬リストのリロール数を加算する
#command $$get_hhp_rewards_reroll_max : int				// 報酬リストのリロール最大数を取得する
#command $$add_hhp_rewards_reroll_max(int)				// 報酬リストのリロール最大数を加算する

// チュートリアル
#command $$get_hhp_tutorial_flag : int					// チュートリアルの進行状況を取得する
#command $$set_hhp_tutorial_flag(int)					// チュートリアルの進行状況を設定する
#command $$next_hhp_tutorial_flag						// チュートリアルの進行状況を進める

// 図鑑フラグ
#command $$init_hhp_item_library_flag					// アイテム図鑑フラグを初期化する
#command $$get_hhp_item_library_flag(int, int) : int	// アイテム図鑑フラグを取得する
#command $$on_hhp_item_library_flag(int, int)			// アイテム図鑑フラグをＯＮにする
#command $$off_hhp_item_library_flag(int, int)			// アイテム図鑑フラグをＯＦＦにする
#command $$get_hhp_item_library_on_count : int			// アイテム図鑑フラグでＯＮになっている数を取得する

// デバッグ
#replace	<HHP_GOD_MODE_NONE>				0			// ゴッドモード／なし
#replace	<HHP_GOD_MODE_NORMAL>			1			// ゴッドモード／ダメージは受けるけど死なない
#replace	<HHP_GOD_MODE_NO_DAMAGE>		2			// ゴッドモード／ダメージを受けない
	
#command $$get_hhp_god_mode_flag : int					// ゴッドモード(無敵)を取得する
#command $$set_hhp_god_mode_flag(int)					// ゴッドモード(無敵)を設定する
#command $$get_hhp_rewards_weight(int) : int			// 各報酬の重みを取得する
#command $$get_hhp_rewards_total_weight : int			// 各報酬の重みの合計値を取得する
#command $$get_hhp_rewards_rand(int)					// 各報酬選択乱数値を取得する

// todo
#command $$get_hhp_player_se_type : int
#command $$set_hhp_player_se_type(int)
#command $$get_hhp_player_attacking
#command $$get_hhp_player_direct_attack


//===========================================================================
// ゲームレベル
//===========================================================================
#command $$init_hhp_stage_data						// ステージデータを初期化する
#command $$init_hhp_wave_data						// ウェーブデータを初期化する
#command $$update_hhp_wave_data						// ウェーブデータを更新する

#command $$handle_timed_enemy_spawn : int			// 敵を生成するルーチンを実行する

#command $$get_hhp_wave : int						// 現在のウェーブを取得する
#command $$set_hhp_wave(int)						// 現在のウェーブを設定する
#command $$next_hhp_wave							// 現在のウェーブを次に進める
#command $$get_hhp_wave_max : int					// 最大ウェーブを取得する
#command $$is_hhp_final_wave : int					// 最終ウェーブかどうか
#command $$is_hhp_boss_wave : int					// ボスウェーブかどうか
#command $$is_hhp_wave_over : int					// ウェーブが終了したかどうか
#command $$is_hhp_all_wave_over : int				// すべてのウェーブが終了したかどうか

#command $$get_hhp_time_limit : int					// 制限時間を取得する
#command $$get_hhp_time_limit_stop_flag : int		// 制限時間の更新フラグを取得する
#command $$set_hhp_time_limit_stop_flag(int)		// 制限時間の更新フラグを設定する

// ボスタイプ
#replace	<HHP_BOSS_TYPE_OROCHI>		1			// ヤマタノオロチ
#replace	<HHP_BOSS_TYPE_HYDRA>		2			// ヒュドラ
#replace	<HHP_BOSS_TYPE_MEDUSA>		3			// メデューサ
#replace	<HHP_BOSS_TYPE_MAX>			4

#command $$get_hhp_boss_type : int					// 出現するボスタイプを取得する

#command $$get_hhp_spawn_enemy_list(int) : int		// 生成する敵リストを取得する
#command $$get_hhp_spawn_enemy_list_count : int		// 生成する敵リストの数を取得する
#command $$get_hhp_enemy_spawn_count : int			// 敵生成位置数を取得する
#command $$get_hhp_enemy_spawn_x(int) : int			// 敵生成座標(x)を取得する
#command $$get_hhp_enemy_spawn_y(int) : int			// 敵生成座標(y)を取得する
#command $$get_hhp_enemy_target_x_count : int		// 敵移動目標位置数(x)を取得する
#command $$get_hhp_enemy_target_x(int) : int		// 敵移動目標座標(x)を取得する
#command $$get_hhp_enemy_target_y : int				// 敵移動目標座標(y)を取得する

#command $$get_hhp_spawn_time : int					// 敵生成時間を取得する

#command $$get_hhp_enemy_life_default(int) : int				// 敵設定データのライフを取得する
#command $$get_hhp_enemy_move_speed_default(int) : int			// 敵設定データの移動速度を取得する
#command $$get_hhp_enemy_attack_power_default(int) : int		// 敵設定データの攻撃力設定を取得する
#command $$get_hhp_enemy_attack_speed_default(int) : int		// 敵設定データの攻撃速度設定を取得する
#command $$get_hhp_enemy_attack_count_default(int) : int		// 敵設定データの攻撃回数設定を取得する


//===========================================================================
// 敵／レア／ボス共通
//===========================================================================
// オブジェクト
#replace	c_enemy_image				child[1]	// キャラ画像
#replace	c_enemy_status_effect		child[2]	// 状態異常
#replace	c_enemy_emotion				child[3]	// エモーション
#replace	c_enemy_collision			child[4]	// デバッグ：当たり判定確認用
#replace	c_enemy_base_max				  5

// パラメータ
#replace	f_enemy_life					f[0]	// ライフ／現在のライフ
#replace	f_enemy_life_max				f[1]	// ライフ／最大
#replace	f_enemy_status_effect			f[2]	// バフ／デバフ（1bitずつのフラグ(on/off)で管理する）
#replace	f_enemy_hitbox_index			f[3]	// 現在使用している当たり判定ＩＤ格納インデックス
#replace	f_enemy_damage					f[4]	// 受けたダメージ
#replace	f_enemy_critical_damage			f[5]	// ダメージ時にクリティカルヒットになったかどうか
#replace	f_enemy_over_damage				f[6]	// ライフを超過したダメージ
#replace	f_enemy_shield					f[7]	// シールド
// 											f[8]
//											f[27]   [8]～[27]は当たり判定ＩＤ格納に使用中
#replace	f_enemy_base_max				  28

// ベース
#command $$init_hhp_enemy_base(object)					// 敵（共通）を初期化する
#command $$update_hhp_enemy_base(object)				// 敵（共通）を更新する
#command $$damage_hhp_enemy_base(object, int)			// 敵（共通）にダメージを与える

// ライフ
#command $$init_hhp_enemy_life(object, int)				// ライフを初期化する
#command $$add_hhp_enemy_life(object, int)				// ライフを加算／減算する
#command $$is_hhp_enemy_life_max(object) : int			// ライフが最大かどうか

// バフ／デバフ
#replace	<HHP_ENEMY_STATUS_EFFECT_NONE>		0		// 状態異常なし
#replace	<HHP_ENEMY_STATUS_EFFECT_SLOW>		1		// スロウ
#replace	<HHP_ENEMY_STATUS_EFFECT_EXCITED>	2		// 興奮
#replace	<HHP_ENEMY_STATUS_EFFECT_ANGRY>		3		// 怒り
#replace	<HHP_ENEMY_STATUS_EFFECT_STONE>		4		// 石化
#replace	<HHP_ENEMY_STATUS_EFFECT_MAX>		5

#command $$init_hhp_enemy_status_effect(object)				// バフ／デバフを初期化する
#command $$on_hhp_enemy_status_effect(object, int)			// バフ／デバフを設定する
#command $$off_hhp_enemy_status_effect(object, int)			// バフ／デバフを解除する
#command $$has_hhp_enemy_status_effect(object, int) : int	// 指定したバフ／デバフ状態かどうか
#command $$has_hhp_enemy_any_status_effect(object) : int	// 何らかのバフ／デバフ状態かどうか
#command $$get_hhp_enemy_status_effect_count(object) : int	// 発生しているバフ／デバフの数を取得する

// 当たり判定フラグ最大数
#replace	<HHP_HITBOX_FLAG_START>		8				// 当たり判定フラグインデックス（最初）
#replace	<HHP_HITBOX_FLAG_END>		27				// 当たり判定フラグインデックス（最後）

#command $$init_hhp_enemy_hitbox(object)					// 当たり判定格納データを初期化する
#command $$has_hhp_enemy_hitbox_id(object, int) : int		// 指定した当たり判定ＩＤにすでに持っているか
#command $$set_hhp_enemy_hitbox_id(object, int)				// 当たり判定ＩＤを格納する

// 座標／サイズ
#command $$get_hhp_enemy_x(object) : int			// 敵の座標(x)を取得する
#command $$get_hhp_enemy_y(object) : int			// 敵の座標(y)を取得する
#command $$get_hhp_enemy_w(object) : int			// 敵のサイズ(w)を取得する
#command $$get_hhp_enemy_h(object) : int			// 敵のサイズ(h)を取得する


//===========================================================================
// 敵／モブ
//===========================================================================
// 敵／全体
#command $$init_hhp_enemy							// 敵を初期化する
#command $$update_hhp_enemy							// 敵を更新する
#command $$spawn_hhp_enemy(int, int, int)			// 敵を生成する
#command $$get_hhp_exists_enemy_count : int			// 生存している敵の総数を取得する
#command $$damage_hhp_enemy(object, int)			// 敵にダメージを与える
#command $$damage_hhp_all_enemy(int)				// すべての敵にダメージを与える
#command $$stun_hhp_all_enemy(int)					// すべての敵にスタンを与える

// 敵／個別
#command $$get_hhp_enemy_attack_enable(object) : int	// 敵に攻撃が可能かどうか


//===========================================================================
// 敵／ボス
//===========================================================================
#command $$init_hhp_boss(object, object, int, int)	// ボスを初期化する

#command $$play_hhp_boss_intro(object, object)		// ボスの登場演出を再生する



#command $$update_hhp_boss							// ボスを更新する
#command $$damage_hhp_boss(object, int)				// ボスにダメージを与える
#command $$stun_hhp_boss(object, int)				// ボスにスタンを与える

#command $$play_hhp_boss_defeat(object)				// ボスの討伐演出を再生する

#command $$get_hhp_boss_turn : int
#command $$is_hhp_boss_turn_max : int




















// 当たり判定
/*
#command $$get_hhp_enemy_hit_enable(object, int) : int	// 攻撃可能
#command $$get_hhp_enemy_hit_rect_x(object) : int		// 当たり判定(x)を取得する
#command $$get_hhp_enemy_hit_rect_y(object) : int		// 当たり判定(y)を取得する
#command $$get_hhp_enemy_hit_rect_w(object) : int		// 当たり判定(w)を取得する
#command $$get_hhp_enemy_hit_rect_h(object) : int		// 当たり判定(h)を取得する
*/
#command $$get_enemy_hit_enable(object, int)










// 敵管理マネージャー
#command $$damage_defegg_enemy_near(object, int)

#command $$defegg_all_enemy_escape
#command $$defegg_all_enemy_wait
#command $$hhp_all_enemy_attack_over
#command $$check_hhp_all_enemy_hit
#command $$check_hhp_all_enemy_hitbox

#command $$is_defegg_all_enemy_escape : int			// すべての敵が逃走済みかどうか





//===========================================================================
// 当たり判定
//===========================================================================
#command $$init_hhp_hitbox							// 当たり判定を初期化する
#command $$update_hhp_hitbox						// 当たり判定を更新する

// 当たり判定タイプ
#replace	<HHP_HITBOX_TYPE_RADIAL>		0		// 円形
#replace	<HHP_HITBOX_TYPE_HORIZONTAL>	1		// 水平
#replace	<HHP_HITBOX_TYPE_VERTICAL>		2		// 垂直

#command $$spawn_hhp_hitbox(int, int, int)			// 当たり判定を生成する



//===========================================================================
// アイテム
//===========================================================================
#command $$init_hhp_item_data					// アイテムデータの初期化(初回)
#command $$restart_hhp_item_data				// アイテムデータの初期化(再ゲーム開始時)

#command $$get_hhp_item_id_from_list_index(int) : int			// リストインデックスからアイテムＩＤを取得する
#command $$get_hhp_item_level_from_list_index(int) : int		// リストインデックスからアイテムレベルを取得する
#command $$get_hhp_item_cooldown_from_list_index(int) : int		// リストインデックスからアイテムクールタイムを取得する
#command $$get_hhp_item_cooldown_max_from_list_index(int) : int	// リストインデックスからアイテムクールタイム最大値を取得する
#command $$get_hhp_item_counter_from_list_index(int) : int		// リストインデックスからアイテム汎用カウンターを取得する

// アイテム一覧
#replace	<HHP_ITEM_ID_MIN>							1
#replace	<HHP_ITEM_ID_DAMAGE_UP>						1		// 攻撃／攻撃力アップ
#replace	<HHP_ITEM_ID_ATTACK_SLASH>					2		// 攻撃／縦横攻撃追加
#replace	<HHP_ITEM_ID_CRITICAL>						3		// 攻撃／クリティカル発生
#replace	<HHP_ITEM_ID_INVINCIBLE>					4		// 防御／無敵発生
#replace	<HHP_ITEM_ID_STATUS_EFFECT_SLOW>			5		// 状態異常／スロウ付与
#replace	<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>			6		// 防御／無敵で攻撃を受けると攻撃力アップ
#replace	<HHP_ITEM_ID_SPIKE>							7		// 防御／反射ダメージ
#replace	<HHP_ITEM_ID_LIFE_REGENERATION>				8		// 防御／ライフ自動回復
#replace	<HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER>	9		// 防御／ウェーブ終了後ライフ回復
#replace	<HHP_ITEM_ID_DOUBLE_ATTACK>					10		// 攻撃／二重攻撃
#replace	<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>			11		// 防御／永続的なライフ増加
#replace	<HHP_ITEM_ID_ATTACK_RANGE_UP>				12		// 攻撃／攻撃範囲アップ
#replace	<HHP_ITEM_ID_SKILL_POWER_REGENERATION>		13		// その他／スキルパワー自動回復
#replace	<HHP_ITEM_ID_STATUS_EFFECT_CONVERT>			14		// 状態異常／相手が倒れた時、近くにいる敵に状態異常を移す
#replace	<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>		15		// 攻撃／無敵でないとき攻撃力アップ
#replace	<HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP>		16		// 状態異常／状態異常に攻撃力アップ
#replace	<HHP_ITEM_ID_LIFELESS_DAMAGE_UP>			17		// 攻撃／ダメージがある敵に攻撃力アップ
#replace	<HHP_ITEM_ID_ATTACKED_DAMAGE_UP>			18		// 攻撃／敵からダメージを受けると攻撃力アップ
#replace	<HHP_ITEM_ID_SKILL_POWER_MAX_UP>			19		// その他／スキルパワー最大値増加
#replace	<HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP>	20		// 状態異常／敵の状態異常の数が多いほど攻撃力アップ
#replace	<HHP_ITEM_ID_COMBO_UP>						21		// 攻撃防御／コンボ数が多いほど攻撃力／回復力アップ
#replace	<HHP_ITEM_ID_LIFE_UP>						22		// 防御／ライフ増加
#replace	<HHP_ITEM_ID_STATUS_EFFECT_STUN>			23		// 状態異常／スタン付与
#replace	<HHP_ITEM_ID_DAMAGE_LIFE_RECOVER>			24		// 攻撃／敵ダメージ発生時にライフ回復
#replace	<HHP_ITEM_ID_RIVIVAL>						25		// 防御／ライフ０時に復活
#replace	<HHP_ITEM_ID_SPIKE_DAMAGE_UP>				26		// 防御／反射ダメージアップ
#replace	<HHP_ITEM_ID_REROLL>						27		// その他／リロール増加
#replace	<HHP_ITEM_ID_STATUS_EFFECT_EXCITED>			28		// 状態異常／興奮付与
#replace	<HHP_ITEM_ID_SE_CHANGE>						29		// その他／ＳＥ変更
#replace	<HHP_ITEM_ID_MAX>							30

// アイテムタイプ一覧
#replace	<HHP_ITEM_TYPE_ATTACK>				1		// アイテムタイプ／攻撃
#replace	<HHP_ITEM_TYPE_DEFENCE>				2		// アイテムタイプ／防御
#replace	<HHP_ITEM_TYPE_STATUS_EFFECT>		3		// アイテムタイプ／状態異常
#replace	<HHP_ITEM_TYPE_OTHER>				4		// アイテムタイプ／その他

// アイテムレベル
#replace	<HHP_ITEM_LEVEL_MIN>				1		// アイテムレベル／最小
#replace	<HHP_ITEM_LEVEL_MAX>				3		// アイテムレベル／最大

#command $$get_hhp_item_count							// 所持アイテムの数を取得する
#command $$get_hhp_item_count_from_type(int) : int		// 指定したタイプの所持アイテムの数を取得する
#command $$get_hhp_item_count_from_level(int) : int		// 指定したレベルの所持アイテムの数を取得する
#command $$has_hhp_item(int) : int						// アイテムを所持しているかどうか
#command $$del_hhp_item(int)							// アイテムを削除する
#command $$powerup_hhp_item(int) : int					// アイテムをパワーアップする(未所持のアイテムはリストに追加／所持しているアイテムはレベルを加算する)

#command $$get_hhp_item_name(int, int) : str			// アイテムの名前を取得する
#command $$get_hhp_item_type(int) : int					// アイテムタイプを取得する
#command $$get_hhp_item_level(int) : int				// アイテムレベルを取得する
#command $$get_hhp_item_default_level(int) : int		// アイテムのデフォルトレベルを取得する
#command $$get_hhp_item_description(int, int) : str		// アイテムの詳細を取得する
#command $$get_hhp_item_icon_no(int, int) : int			// アイテムアイコン番号を取得する

// イベントトリガー
#command $$hhp_item_trigger_on_get(int, int)						// アイテム取得時に発生するイベント
#command $$hhp_item_trigger_on_del(int, int)						// アイテム破棄時に発生するイベント
#command $$hhp_item_trigger_on_update								// 毎フレームごとに発生するイベント
#command $$hhp_item_trigger_on_update_player_attack_power : int		// 毎フレームごとに発生するプレイヤーの攻撃力を計算するイベント
#command $$hhp_item_trigger_on_update_player_attack_power_rate : int// 毎フレームごとに発生するプレイヤーの攻撃力補正値（乗算）を計算するイベント
#command $$hhp_item_trigger_on_update_player_attack_range : int		// 毎フレームごとに発生するプレイヤーの攻撃範囲を計算するイベント
#command $$hhp_item_trigger_on_update_player_critical_rate : int	// 毎フレームごとに発生するプレイヤーのクリティカル率を計算するイベント
#command $$hhp_item_trigger_on_update_player_stun_power : int		// 毎フレームごとに発生するプレイヤーのスタン力を計算するイベント
#command $$hhp_item_trigger_on_update_player_regen_power : int		// 毎フレームごとに発生するプレイヤーの回復力を計算するイベント
#command $$hhp_item_trigger_on_player_skill_power_stock				// プレイヤーのスキルパワーがストックされた時に発生するイベント
#command $$hhp_item_trigger_on_player_life_recover(int, int)		// プレイヤーが回復した時に発生するイベント
#command $$hhp_item_trigger_on_player_damage(object)				// プレイヤーがダメージを受けた時に発生するイベント
#command $$hhp_item_trigger_on_player_dead							// プレイヤーのライフがなくなった時に発生するイベント
#command $$hhp_item_trigger_on_spawn_enemy(object)					// 敵が出現した時に発生するイベント
#command $$hhp_item_trigger_on_enemy_damage(object, int)			// 敵がダメージ受けた時に発生するイベント
#command $$hhp_item_trigger_on_enemy_dead(object)					// 敵のライフがなくなった時に発生するイベント
#command $$hhp_item_trigger_on_player_attack_power_from_enemy(object, int) : int		// プレイヤーがダメージを与える際に発生するイベント（敵の状態からの総攻撃力を取得）
#command $$hhp_item_trigger_on_player_attack_critical_rate_from_enemy(object) : int		// プレイヤーがダメージを与える際に発生するイベント（クリティカル発生率を取得）
#command $$hhp_item_trigger_on_wave_finished						// ウェーブ終了時に発生するイベント


//===========================================================================
// スキル
//===========================================================================
#command $$init_hhp_skill_data						// スキルデータの初期化(初回)
#command $$restart_hhp_skill_data					// スキルデータの初期化(再ゲーム開始時)

// スキル一覧
#replace	<HHP_SKILL_ID_SP>				0		// スピカ／全体攻撃
#replace	<HHP_SKILL_ID_AI>				1		// 愛乃／無敵
#replace	<HHP_SKILL_ID_HI>				2		// 淡雪／ランダム効果（報酬増加／スカ／すべての敵のライフ１／攻撃力増加）
#replace	<HHP_SKILL_ID_KY>				3		// 小詠／状態異常
#replace	<HHP_SKILL_ID_RK>				4		// 六花／回復
#replace	<HHP_SKILL_ID_MAX>				5

#command $$get_hhp_skill_count : int				// 所持しているスキル数を取得する
#command $$get_hhp_skill_id_from_index(int) : int	// インデックスからスキルＩＤを取得する
#command $$get_hhp_skill_index_from_id(int) : int	// スキルＩＤからインデックスを取得する
#command $$has_hhp_skill(int)						// 指定したスキルを所持しているかどうか
#command $$on_hhp_skill(int)						// 指定したスキルを有効にする
#command $$off_hhp_skill(int)						// 指定したスキルを無効にする
#command $$get_hhp_skill_max : int					// 所持可能なスキルの最大数を取得する
#command $$add_hhp_skill_max(int)					// 所持可能なスキルの最大数を加算する

#replace	<HHP_SKILL_POWER_MAX>			900		// スキルパワー最大値
#replace	<HHP_ACTIVATE_SKILL_POWER>		100		// スキルの発動に必要なスキルパワー

#command $$get_hhp_skill_power : int				// スキルパワーを取得する
#command $$set_hhp_skill_power(int)					// スキルパワーを設定する
#command $$add_hhp_skill_power(int)					// スキルパワーを加算する
#command $$get_hhp_skill_power_max : int			// スキルパワー最大値を取得する
#command $$set_hhp_skill_power_max(int)				// スキルパワー最大値を設定する
#command $$add_hhp_skill_power_max(int)				// スキルパワー最大値を加算する

#command $$get_hhp_skill_use_count : int			// スキル使用回数を取得する

#command $$get_hhp_skill_name(int) : str			// スキルの名前を取得する
#command $$get_hhp_skill_description(int) : str		// スキルの詳細を取得する

// イベントトリガー
#command $$hhp_skill_trigger_on_update				// 毎フレームごとに発生するイベント
#command $$hhp_skill_trigger_on_activate			// スキル発動時に発生するイベント


//===========================================================================
// エフェクト
//===========================================================================
#command $$init_hhp_effect							// エフェクトを初期化する

// エフェクトタイプ
#replace	<HHP_EF_PLAYER_ATTACK>			1			// プレイヤー攻撃
#replace	<HHP_EF_ENEMY_HIT>				2			// 敵ヒット
#replace	<HHP_EF_ENEMY_ATTACK>			3			// 敵（モブ）攻撃
#replace	<HHP_EF_BOSS_ATTACK>			4			// 敵（ボス）攻撃
#replace	<HHP_EF_BOSS_LANDING>			5			// 敵（ボス）着地
#replace	<HHP_EF_DAMAGE>					6			// ダメージ
#replace	<HHP_EF_CRITICAL_DAMAGE>		7			// クリティカルダメージ
#replace	<HHP_EF_SLASH_H>				8			// 横一列
#replace	<HHP_EF_SLASH_V>				9			// 縦一列


#replace	<HHP_EF_ENEMY_SHIELD_BREAK>		13			// シールドブレイク
#replace	<HHP_EF_TREASURE>				14			// 宝箱


#command $$spawn_hhp_effect(int, int, int, int)		// エフェクトを生成する
#command $$play_hhp_skill_effect(object, int)		// スキル使用エフェクトを再生する
#command $$play_hhp_rivive_effect(object)			// 蘇生エフェクトを再生する


// 個別エフェクト確認用
#command $$spawn_enemy_shield_break(object, int, int)
#command $$spawn_treasure(object, int, int)

#command $$tap_effect(object, int, int)



//===========================================================================
// デバッグ
//===========================================================================
#command $$init_hhp_debug_system					// デバッグシステムを初期化する
#command $$update_hhp_debug_system					// デバッグシステムを更新する

#command $$get_hhp_debug_collision_disp_flag		// デバッグ／当たり判定表示フラグを取得する























//===========================================================================
// ＵＩ
//===========================================================================
#command $$create_hhp_scene_object(stage)				// ヘビヘビパニックのシーンオブジェクトを作成する
#command $$update_hhp_scene_object(stage)				// ヘビヘビパニックのシーンオブジェクトを更新する
#command $$change_hhp_scene_object(stage, int)			// ヘビヘビパニックのシーンオブジェクトを変更する(通常ウェーブ／ボスウェーブ)
#command $$hide_hhp_scene_object(stage)					// ヘビヘビパニックのシーンオブジェクトを非表示にする

#command $$update_hhp_player_shield_image(int)			// プレイヤーシールド(フェンス)の画像を更新する(アイテムレベルに応じて)
#command $$update_hhp_item_list_force					// アイテムリストを強制更新する

#command $$show_hhp_boss_lifebar_animation				// ボスライフバーの表示アニメーション
#command $$show_hhp_boss_warning_animation				// ボス出現アニメーションを表示する
#command $$hide_hhp_boss_warning_animation				// ボス出現アニメーションを非表示にする
#command $$show_hhp_sys_message(str, int)				// システムメッセージを表示する
#command $$hide_hhp_sys_message							// システムメッセージを非表示にする
#command $$shake_hhp_screen(int)						// 画面を揺らす

#command $$hhp_font_enable								// ヘビヘビパニックのフォントを有効にする
#command $$hhp_font_disable								// ヘビヘビパニックのフォントを無効にする

#command $$set_hhp_button(object)						// ヘビヘビパニックで使用するボタンにする
#command $$set_hhp_button_scale(object, int, int, int)	// ヘビヘビパニックで使用するボタンの拡縮率を設定する

// リザルトポップアップタイプ
#replace	<HHP_RESULT_POPUP_TYPE_ALL_WIN>			0		// 全ウェーブ勝利
#replace	<HHP_RESULT_POPUP_TYPE_WAVE_WIN>		1		// ウェーブ勝利
#replace	<HHP_RESULT_POPUP_TYPE_WAVE_LOSE>		2		// 敗北
#replace	<HHP_RESULT_POPUP_TYPE_RELEASE_SUPPORT> 3		// サポート解禁

#command $$show_defegg_tutorial(int)


//===========================================================================
// シナリオ遷移
//===========================================================================
#define		@ヘビパ_通常モード					$$set_hhp_play_mode(<HHP_PLAY_MODE_NORMAL>)
#define		@ヘビパ_エンドレスモード			$$set_hhp_play_mode(<HHP_PLAY_MODE_ENDLESS>)
#define		@ヘビパ_プレイ回数					$$get_hhp_total_play_count
#define		@ヘビパ_サポートキャラ_スピカ		$$has_hhp_skill(<HHP_SKILL_ID_SP>)
#define		@ヘビパ_サポートキャラ_愛乃			$$has_hhp_skill(<HHP_SKILL_ID_AI>)
#define		@ヘビパ_サポートキャラ_淡雪			$$has_hhp_skill(<HHP_SKILL_ID_HI>)
#define		@ヘビパ_サポートキャラ_小詠			$$has_hhp_skill(<HHP_SKILL_ID_KY>)
#define		@ヘビパ_サポートキャラ_六花			$$has_hhp_skill(<HHP_SKILL_ID_RK>)
#define		@ヘビパ_勝利						($$get_hhp_play_result == <HHP_PLAY_RESULT_WIN>)
#define		@ヘビパ_敗北						($$get_hhp_play_result == <HHP_PLAY_RESULT_LOSE>)
#define		@ヘビパ_ヤマタノオロチ発生中		($$get_hhp_play_level == 3)
#define		@ヘビパ_ヤマタノオロチリベンジ中	(@ヘビパ_ヤマタノオロチ発生中 && $$get_hhp_play_count($$get_hhp_play_level) > 0)
#define		@ヘビパ_ヤマタノオロチ討伐			($$get_hhp_play_level == 4 && @ヘビパ_勝利)
#define		@ヘビパ_ヒュドラ発生中				($$get_hhp_play_level == 6)
#define		@ヘビパ_ヒュドラリベンジ中			(@ヘビパ_ヒュドラ発生中 && $$get_hhp_play_count($$get_hhp_play_level) > 0)
#define		@ヘビパ_ヒュドラ討伐				($$get_hhp_play_level == 7 && @ヘビパ_勝利)
#define		@ヘビパ_メデューサ発生中			($$get_hhp_play_level == 10)
#define		@ヘビパ_メデューサリベンジ中		(@ヘビパ_メデューサ発生中 && $$get_hhp_play_count($$get_hhp_play_level) > 0)
#define		@ヘビパ_メデューサ討伐				($$get_hhp_play_level == 11 && @ヘビパ_勝利)
#define		@ヘビパ_サポート解禁ウィンドウ		close
												@ヘビパ_ユーザー制御開始
												farcall("___mng_hhp_flow_popup", 0, <HHP_RESULT_POPUP_TYPE_RELEASE_SUPPORT>)
												@ヘビパ_ユーザー制御解除
#define		@ヘビパ_ユーザー制御開始
	close
	syscom.set_hide_mwnd_enable_flag(0)		// ウィンドウを消すを禁止する
	syscom.set_syscom_menu_disable			// システムコマンドを禁止する
	syscom.set_auto_mode_onoff_flag(0)		// オートモードを解除する
	script.set_auto_savepoint_off			// セーブポイントをオフにする
	script.set_msg_back_disable				// メッセージバックを禁止する
	script.set_msg_back_off					// メッセージバックを追加しない

#define		@ヘビパ_ユーザー制御解除
	close
	$$hhp_font_disable
	syscom.set_hide_mwnd_enable_flag(1)		// ウィンドウを消すを解除する
	syscom.set_syscom_menu_enable			// システムコマンドを解除する
	script.set_auto_savepoint_on			// セーブポイントをオンにする
	script.set_msg_back_enable				// メッセージバックを許可する
	script.set_msg_back_on					// メッセージバックを追加する

#macro		@ヘビパ_ＡＤＶモード_ボス表示(@type)
	@bg_set(__BG_BLUR_PREFIX + $$chop_bg_blur_name(@disp_bg), 1500)
	@cutin("__mng_hp_cutin_boss" + math.tostr_zero(@type, 2), -1, -1, 0, 960)
	back.object[<OBJ_CUTIN>].center_x = back.object[<OBJ_CUTIN>].get_size_x / 2
	@wipe(204)

#macro		@ヘビパ_ＡＤＶモード_ボス消去			@cutin_del()

//===========================================================================
// サウンド
//===========================================================================
#replace	<HHP_BUTTON_SE_HIT>				0			// マウスオーバー
#replace	<HHP_BUTTON_SE_DECIDE>			1			// 決定
#replace	<HHP_BUTTON_SE_CANCEL>			2			// キャンセル

#define		@SE_ヘビパ_プレイヤー攻撃_通常				if( $$get_hhp_player_se_type ) { pcmch[$$get_empty_pcm_ch(0, 2)].play("_hhp_player_attack01") }
														else						   { pcmch[$$get_empty_pcm_ch(0, 2)].play("_hhp_player_attack01") }
#define		@SE_ヘビパ_プレイヤー攻撃_クリティカル		if( $$get_hhp_player_se_type ) { pcmch[$$get_empty_pcm_ch(0, 2)].play("_hhp_player_attack02") }
														else						   { pcmch[$$get_empty_pcm_ch(0, 2)].play("_hhp_player_attack02") }
#define		@SE_ヘビパ_タップ_ミス						pcmch[$$get_empty_pcm_ch(0, 2)].play("_hhp_tap_miss")
#define		@SE_ヘビパ_タップ_グレイト					pcmch[$$get_empty_pcm_ch(0, 2)].play("_hhp_tap_great")
#define		@SE_ヘビパ_タップ_エクセレント				pcmch[$$get_empty_pcm_ch(0, 2)].play("_hhp_tap_excellent")
#define		@SE_ヘビパ_スキルゲージ最大					pcmch[3].play("_hhp_skill_max")
#define		@SE_ヘビパ_敵スポーン						pcmch[4].play("_hhp_enemy_spawn01")
#define		@SE_ヘビパ_敵攻撃							pcmch[$$get_empty_pcm_ch(6, 7)].play("_hhp_enemy_attack01")
#define		@SE_ヘビパ_ウェーブクリア					pcmch[0].play("_hhp_wave_clear")
#define		@SE_ヘビパ_ゲーム勝利						pcmch[0].play("_hhp_win")
#define		@SE_ヘビパ_ゲーム敗北						pcmch[0].play("_hhp_lose")

#define		@ＳＥ_ヘビパ_蘇生							pcmch[3].play("_hhp_enemy_shield_break01")
#define		@ＳＥ_ヘビパ_回復							nop//pcmch[4].play("_hhp_player_life_recover")
#define		@ＳＥ_ヘビパ_敵_スタン						pcmch[3].play("_hhp_enemy_shield_break01")
#define		@ＳＥ_ヘビパ_敵_シールドブレイク			pcmch[5].play("_hhp_enemy_shield_break01")
#define		@ＳＥ_ヘビパ_宝箱ドロップ					pcmch[3].play("_hhp_enemy_shield_break01")
#define		@ＳＥ_ヘビパ_宝箱追加						pcmch[3].play("_hhp_enemy_shield_break01")
#define		@ＳＥ_ヘビパ_ウェーブ終了カウントダウン		pcmch[3].play("_hhp_enemy_shield_break01")
#define		@ＳＥ_ヘビパ_ウェーブ終了					pcmch[3].play("_hhp_enemy_shield_break01")
#define		@ＳＥ_ヘビパ_機能解放						pcmch[0].play("_hhp_wave_clear")

#command $$get_empty_pcm_ch(int, int) : int				// 使用していない効果音チャンネルを取得する


//===========================================================================
// ボイス
//===========================================================================
#command $$play_hhp_voice(int, int)						// ボイスを再生する

// ボイスタイプ
#replace	<HHP_VOICE_TYPE_SUPPORT_SELECT>		0		// サポート選択画面
#replace	<HHP_VOICE_TYPE_REWARDS_SELECT>		1		// 報酬選択
#replace	<HHP_VOICE_TYPE_USE_SKILL>			2		// 奥義使用
#replace	<HHP_VOICE_TYPE_RESULT>				3		// リザルト


//===========================================================================
// アップデートパッチ用
//===========================================================================
#property	$hhp_update_int_flag : intlist[256]				// アップデートで必要になった際の予備フラグ
#property	$hhp_update_str_flag : strlist[256]				// アップデートで必要になった際の予備フラグ

/*
// アップデートで追加する必要がある場合はここに定義する
#replace	<HHP_UPDATE_INT_FLAG_XXX>		0				// int XXX
#replace	<HHP_UPDATE_INT_FLAG_XXX>		1				// int XXX
#replace	<HHP_UPDATE_STR_FLAG_XXX>		0				// str XXX
#replace	<HHP_UPDATE_STR_FLAG_XXX>		1				// str XXX
*/
