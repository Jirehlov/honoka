//===========================================================================
//!
//!    @file     ___mng_hhp_flow_ready.ss
//!    @brief    ヘビヘビパニック準備画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト番号／ボタン番号
	#replace	@オブジェクト_背景		10
	#replace	@ボタン_次へ			11
	
	// 変数
	#property	$select_btn			// 選択したボタン
	
#inc_end


//===========================================================================
// ウェーブ準備画面フロー
//===========================================================================
#z00

// 初期化処理
@mng_counter.stop					// ミニゲームカウンターの一時停止
$$show_ready_ui_object(front)		// ウェーブ準備ＵＩを表示する

// 入力制御を開始する
$$input_start(front, <HHP_BTNGROUP_MODAL>)

input.clear
while(1)
{
	// デバッグシステムを更新する
	$$update_hhp_debug_system
	
	// 入力制御を更新する
	$select_btn = $$input_update(front, <HHP_BTNGROUP_MODAL>)
	
	// キャンセルは何もしない
	if( $select_btn == -1 ) {
		// 入力制御を開始する
		$$input_start(front, <HHP_BTNGROUP_MODAL>)
	}
	
	// 次へボタンが押された場合は終了する
	if( $select_btn == @ボタン_次へ ) {
		break
	}
	
	input.next
	disp
}

// 終了処理
$$hide_ready_ui_object(front)	// ウェーブ準備ＵＩを非表示にする
@mng_counter.resume				// ミニゲームカウンターの一時停止を解除

return


//---------------------------------------------------------------------------
// ウェーブ準備ＵＩを表示する
//---------------------------------------------------------------------------
command $$show_ready_ui_object(property $stage : stage)
{
	// 背景
	$stage.object[@オブジェクト_背景].create(_mng_df_ready_bg, 1, 327, 136)
	$stage.object[@オブジェクト_背景].layer = <HHP_LAYER_UI>
	$stage.object[@オブジェクト_背景].child.resize(4)
	
	// サムネイル
	$stage.object[@オブジェクト_背景].child[0].create(_mng_df_ready_thumb01, 1, 25, 46)
	
	// 最大ウェーブ数
	$stage.object[@オブジェクト_背景].child[1].create_number(_mng_df_ready_wave_number, 1, 867, 426)
	$stage.object[@オブジェクト_背景].child[1].set_number($$get_hhp_wave)
	
	// 現在のウェーブ数
	$stage.object[@オブジェクト_背景].child[2].create_number(_mng_df_ready_wave_number, 1, 963, 426)
	$stage.object[@オブジェクト_背景].child[2].set_number($$get_hhp_wave_max)
	
	// レベル
	$stage.object[@オブジェクト_背景].child[3].create_number(_mng_df_ready_wave_number, 1, 1060, 180)
	$stage.object[@オブジェクト_背景].child[3].set_number($$get_hhp_play_level)
	
	// 次へボタン
	$$create_ui_button($stage.object[@ボタン_次へ], _mng_df_ready_ok_btn, 785, 728, @ボタン_次へ, <HHP_BTNGROUP_MODAL>, 7)
	$stage.object[@ボタン_次へ].layer = <HHP_LAYER_UI>
	
	// 表示アニメーション
	$stage.object[@オブジェクト_背景].tr = 0
	$stage.object[@オブジェクト_背景].tr_eve.set(255, 350, 0, 2)
	$stage.object[@オブジェクト_背景].y_rep.resize(1)
	$stage.object[@オブジェクト_背景].y_rep[0] = 50
	$stage.object[@オブジェクト_背景].y_rep_eve[0].set(0, 350, 0, 2)
	$stage.object[@ボタン_次へ].tr = 0
	
	// 時間待ち
	timewait_key(750)
	
	// 準備完了ボタン
	$stage.object[@ボタン_次へ].tr_eve.set(255, 150, 0, 2)
	$stage.object[@ボタン_次へ].set_scale(500, 500)
	$stage.object[@ボタン_次へ].scale_x_eve.set(1000, 150, 0, 2)
	$stage.object[@ボタン_次へ].scale_y_eve.set(1000, 150, 0, 2)
}

//---------------------------------------------------------------------------
// ウェーブ準備ＵＩを非表示にする
//---------------------------------------------------------------------------
command $$hide_ready_ui_object(property $stage : stage)
{
	// 消去アニメーション
	$stage.object[@ボタン_次へ].tr_eve.set(0, 150, 0, 2)
	$stage.object[@ボタン_次へ].scale_x_eve.set(500, 150, 0, 2)
	$stage.object[@ボタン_次へ].scale_y_eve.set(500, 150, 0, 2)
	
	$stage.object[@オブジェクト_背景].y_rep_eve[0].set(50, 250, 150, 2)
	$stage.object[@オブジェクト_背景].tr_eve.set(0, 250, 150, 2)
	
	// 時間待ち
	timewait_key(500)
}
