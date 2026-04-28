//===========================================================================
//!
//!    @file     ___mng_urace_flow_entry_uma_info.ss
//!    @brief    ＵＭＡレース／参加ＵＭＡ詳細画面
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
	#replace	@オブジェクト_背景		100
	#replace	@ボタン_閉じる			101
	#replace	@ボタン_ＵＭＡ			102
	
	// 変数
	#property	$owner_index
	#property	$owner_id		// 詳細を表示するＵＭＡのオーナーID
	#property	$select_btn		// 選択したボタン
	
#inc_end

//===========================================================================
// ＵＭＡ詳細フロー
//===========================================================================
#z00

$owner_index = l[0]					// ＵＭＡのオーナーIDを設定する
$owner_id = $$get_entry_owner_id($owner_index)
$$create_scene_object(front)		// シーンオブジェクトを作成する
$$set_joypad_navigation(front)		// パッド入力の遷移を設定する

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_MODAL>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
	
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
	
	// ＵＭＡボタンが押された場合はＵＭＡ詳細へ
	elseif( $select_btn >= @ボタン_ＵＭＡ )
	{
		$select_btn -= @ボタン_ＵＭＡ
		
		// ＵＭＡ詳細フローへ
		if( $owner_id == <URACE_PLAYER_OWNER_ID> ) {
			farcall(___mng_urace_flow_uma_info, 0, $owner_id, $$get_entry_owner_uma_list($owner_index, $select_btn))
		} else {
			farcall(___mng_urace_flow_uma_info, 0, <URACE_NPC_OWNER_ID>, $$get_entry_owner_uma_list($owner_index, $select_btn))
		}
		
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_MODAL>)
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
	property $i
	property $uma_id
	
	// フィルター
	$stage.object[@オブジェクト_背景].create(_mng_ur_skill_info_filter, 1)
	$stage.object[@オブジェクト_背景].child.resize(2)
	
	$stage.object[@オブジェクト_背景].child[0].create(_mng_ur_entry_uma_bg, 1, 54, 268)
	
	for( $i = 0, $i < <URACE_DECK_UMA_MAX>, $i += 1 )
	{
		if( $$get_entry_owner_uma_list($owner_index, $i) != -1 ) {
			
			if( $owner_id == <URACE_PLAYER_OWNER_ID> ) {
				$$create_uma_thumb_button($stage.object[@ボタン_ＵＭＡ + $i], $owner_id, $$get_entry_owner_uma_list($owner_index, $i), 158 + 274 * ($i % 6), 368 + 170 * ($i / 6), @ボタン_ＵＭＡ + $i, <URACE_BTN_GROUP_MODAL>)
			} else {
				$$create_uma_thumb_button($stage.object[@ボタン_ＵＭＡ + $i], <URACE_NPC_OWNER_ID>, $$get_entry_owner_uma_list($owner_index, $i), 158 + 274 * ($i % 6), 368 + 170 * ($i / 6), @ボタン_ＵＭＡ + $i, <URACE_BTN_GROUP_MODAL>)
			}
			
			$uma_id = $$get_uma_id(<URACE_NPC_OWNER_ID>, $$get_entry_owner_uma_list($owner_index, $i))
			
			if( $$get_uma_library_flag($uma_id) == <URACE_LIBRARY_FLAG_NONE> ) {
				$$set_uma_library_flag($uma_id, <URACE_LIBRARY_FLAG_LOOK>)
			}
		}
	}
	
	// 閉じるボタン
	$$create_ui_button($stage.object[@ボタン_閉じる], _mng_ur_common_close_btn, 813, 705, @ボタン_閉じる, <URACE_BTN_GROUP_MODAL>, 2)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	property $i
	
	$stage.object[@オブジェクト_背景].init
	$stage.object[@ボタン_閉じる].init
	for( $i = 0, $i < <URACE_DECK_UMA_MAX>, $i += 1 ) {
		$stage.object[@ボタン_ＵＭＡ + $i].init
	}
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_閉じる)
	
	$stage.object[@ボタン_閉じる].joypad_up    = -1
	$stage.object[@ボタン_閉じる].joypad_down  = -1
	$stage.object[@ボタン_閉じる].joypad_left  = -1
	$stage.object[@ボタン_閉じる].joypad_right = -1
}

