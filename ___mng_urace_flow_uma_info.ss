//===========================================================================
//!
//!    @file     ___mng_urace_flow_uma_info.ss
//!    @brief    ＵＭＡレース／ＵＭＡ詳細画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     複数の画面から遷移してくるためオーバーレイとして表示する
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景		120
	#replace	@ボタン_閉じる			121
	
	// 変数
	#property	$owner_id		// 詳細を表示するＵＭＡのオーナーID
	#property	$uma_index		// 詳細を表示するＵＭＡインデックス
	#property	$select_btn		// 選択したボタン
	
#inc_end

//===========================================================================
// ＵＭＡ詳細フロー
//===========================================================================
#z00

$owner_id  = l[0]					// ＵＭＡのオーナーIDを設定する
$uma_index = l[1]					// ＵＭＡインデックスを設定する
$$create_scene_object(front)		// シーンオブジェクトを作成する

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_UMA_INFO>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_UMA_INFO>)
	
	// キャンセルは閉じるボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_閉じる
	}
	
	// 閉じるボタンが押された場合は終了する
	if( $select_btn == @ボタン_閉じる )
	{
		break
	}
	
	input.next		// 入力の更新
	disp			// 画面の更新
}

// シーンオブジェクトを非表示にする
$$hide_scene_object(front)

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	// フィルター
	$stage.object[@オブジェクト_背景].create(_mng_ur_skill_info_filter, 1)
	$stage.object[@オブジェクト_背景].child.resize(2)
	
	// カード
	$$create_uma_card_object($stage.object[@オブジェクト_背景].child[0], $$get_uma_id($owner_id, $uma_index), 400, 94)
	
	// ステータス
	$$create_uma_status_object($stage.object[@オブジェクト_背景].child[1], $owner_id, $uma_index, 1078, 352)
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], _mng_ur_common_close_btn, 813, 988, @ボタン_閉じる, <URACE_BTN_GROUP_UMA_INFO>, 2)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_閉じる].init
}
