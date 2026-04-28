//===========================================================================
//!
//!    @file     ___mng_urace_flow_barn.ss
//!    @brief    ＵＭＡレース／厩舎画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     所持ＵＭＡ確認画面／複数の画面から遷移してくる
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// 定数
	#replace	<EDITBOX_INDEX>				0	// 使用するエディットボックス
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景				0
	#replace	@ボタン_戻る					11
	#replace	@ボタン_編成					12
	#replace	@ボタン_ソート_スキル順			13
	#replace	@ボタン_ソート_ステータス順		14
	#replace	@ボタン_ソート_入手順			15
	#replace	@ボタン_ソート_レアリティ順		16
	#replace	@ボタン_ソート_昇順／降順		17
	
	#replace	@ボタン_名前変更				18
	#replace	@ボタン_スクロールビュー		20
	#replace	@ボタン_サムネイル				30
	#define		@ボタン_サムネイル最大			(@ボタン_サムネイル + <PLAYER_UMA_SLOT_MAX>)
	
	// スクロールビュー定義
	#replace	@スクロールビュー_サムネイル	1
	
	// オブジェクト／ボタン定義（モーダル）
	#replace	@オブジェクト_モーダル_背景		100
	#replace	@ボタン_モーダル_決定			101
	#replace	@ボタン_モーダル_キャンセル		102
	
	// 変数
	#property	$select_btn				// 選択したボタン
	#property	$mode					// 表示モード(0=通常／1=パドック画面からの遷移)
	#property	$uma_index				// 表示しているＵＭＡインデックス
	
	#property	$modal_select_btn		// モーダルウィンドウで選択したボタン
	#property	$editbox_text : str		// エディットボックスに入力されているテキスト
	
#inc_end


//===========================================================================
// ＵＭＡ厩舎フロー
//===========================================================================
#z00

@ＵＭＡレースシーン設定

$uma_index = 0
$$create_scene_object(back)			// シーンオブジェクトを作成する
$$update_scene_object(back)			// シーンオブジェクトを更新する
$$set_joypad_navigation(back)		// パッド入力の遷移を設定する
$$show_scene_object(back)			// シーンオブジェクトを表示する

// チュートリアルシナリオ
if( @ＵＭＡレース_チュートリアル進行度 == 6 ) {
	@ＵＭＡレースチュートリアルシナリオ(17)
	@ＵＭＡレース_チュートリアル進行度 = 7
}

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_NORMAL>)

while(1)
{
	// 入力制御を更新する
	$select_btn = $$input_update(front, <URACE_BTN_GROUP_NORMAL>)
	
	// キャンセルは戻るボタンとして処理する
	if( $select_btn == -1 )
	{
		@ＳＥ_ＵＭＡレース_ボタン_キャンセル
		
		$select_btn = @ボタン_戻る
	}
	
	// 戻るボタンが押された場合は終了する
	if( $select_btn == @ボタン_戻る )
	{
		break
	}
	
	// 編成ボタンが押された場合
	elseif( $select_btn == @ボタン_編成 )
	{
		// 全てのオブジェクトのワイプコピーフラグをオフする
		$$set_front_wipe_copy_all(0)
		
		// デッキ編成フローへ
		farcall("___mng_urace_flow_edit_deck")
		
		goto #z00
	}
	
	// 名前変更ボタンが押された場合
	elseif( $select_btn == @ボタン_名前変更 )
	{
		// 名前変更へ
		gosub #z01
		
		$$set_joypad_focus_button($select_btn)	// 選択されたボタンをジョイパッドで選択中のボタンに再設定する
		$$update_joypad_focus_button(front)		// 選択されたボタンの描画を更新する
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front)
	}
	
	// ＵＭＡサムネイルボタンが押された場合は表示しているＵＭＡを変更する
	elseif( @ボタン_サムネイル <= $select_btn && $select_btn <= @ボタン_サムネイル最大 )
	{
		$$update_uma_info($select_btn - @ボタン_サムネイル)
	}
	
	
	if( @ボタン_ソート_スキル順 <= $select_btn && $select_btn <= @ボタン_ソート_昇順／降順 )
	{
		// 各ソートを設定する
		switch( $select_btn ) {
		case(@ボタン_ソート_スキル順)		$$set_my_uma_list_sort_type(<URACE_SORT_TYPE_SKILL>)
		case(@ボタン_ソート_ステータス順)	$$set_my_uma_list_sort_type(<URACE_SORT_TYPE_STATUS>)
		case(@ボタン_ソート_入手順)			$$set_my_uma_list_sort_type(<URACE_SORT_TYPE_GET>)
		case(@ボタン_ソート_レアリティ順)	$$set_my_uma_list_sort_type(<URACE_SORT_TYPE_RARITY>)
		case(@ボタン_ソート_昇順／降順)		$$reverse_my_uma_list_sort_order
		}
		
		// ソートを実行する
		$$sort_my_uma_list
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front)
	}
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		// 入力制御を再開始する
		$$input_start(front, <URACE_BTN_GROUP_NORMAL>)
	}
	
	// 何も押していないときは画面の更新のみ
	else
	{
		input.next		// 入力の更新
		disp			// 画面の更新
	}
}

// 全てのオブジェクトのワイプコピーフラグをオフする
$$set_front_wipe_copy_all(0)

@ＵＭＡレースシーン設定解除

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// 背景／厩舎
	$stage.object[@オブジェクト_背景].create("__mng_ur_barn_bg", 1)
	$stage.object[@オブジェクト_背景].child.resize(5)
	
	// タグ
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_barn_tag", 1)
	
	// 編成／戻るボタン
	$$create_ui_button($stage.object[@ボタン_編成], "__mng_ur_barn_edit_btn", 1238, 949, @ボタン_編成, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_戻る], "__mng_ur_barn_back_btn", 1558, 949, @ボタン_戻る, <URACE_BTN_GROUP_NORMAL>, 2)
	
	// 名前変更ボタン
	$$create_ui_button($stage.object[@ボタン_名前変更], __mng_ur_uma_info_rename_btn, 677, 81, @ボタン_名前変更, <URACE_BTN_GROUP_NORMAL>, 1)
	
	// ソートボタン
	$$create_ui_button($stage.object[@ボタン_ソート_スキル順], "__mng_ur_barn_sort_skill_btn", 1216, 91, @ボタン_ソート_スキル順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_ステータス順], "__mng_ur_barn_sort_param_btn", 1371, 91, @ボタン_ソート_ステータス順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_入手順], "__mng_ur_barn_sort_get_btn", 1526, 91, @ボタン_ソート_入手順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_レアリティ順], "__mng_ur_barn_sort_rarity_btn", 1681, 91, @ボタン_ソート_レアリティ順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_toggle_button($stage.object[@ボタン_ソート_昇順／降順], "__mng_ur_barn_sort_order_btn", 1839, 91, @ボタン_ソート_昇順／降順, <URACE_BTN_GROUP_NORMAL>, 1, $$get_my_uma_list_sort_order)
	
	// 名前／背景
	$stage.object[@オブジェクト_背景].child[1].create("__mng_ur_uma_info_name_bg", 1, 219, 80)
	
	// 名前／ＵＭＡ名
	$$create_ui_string($stage.object[@オブジェクト_背景].child[2], 244, 93, 428, 32, 30)
	$stage.object[@オブジェクト_背景].child[2].f_align = <STRING_ALIGN_CENTER>
	$$update_ui_string_param($stage.object[@オブジェクト_背景].child[2], 30, -2, 0, 12, 0, -1, -1, -1)
	
	// カード
	$$create_uma_card_object($stage.object[@オブジェクト_背景].child[3], $$get_uma_id(<URACE_PLAYER_OWNER_ID>, $uma_index), 214, 154)
	$stage.object[@オブジェクト_背景].child[3].set_scale(730, 730)
	
	// ステータス
	$$create_uma_status_object($stage.object[@オブジェクト_背景].child[4], <URACE_PLAYER_OWNER_ID>, $uma_index, 76, 789)
	
	// ＵＭＡサムネイルボタン
	$len = $$get_my_uma_num
	for( $i = 0, $i < $len, $i += 1 ) {
		$$create_uma_thumb_btn($stage.object[@ボタン_サムネイル + $i], <URACE_PLAYER_OWNER_ID>, $i, 1050 + 254 * ($i % 3), 185 + 150 * ($i / 3), @ボタン_サムネイル + $i, <URACE_BTN_GROUP_NORMAL>)
	}
	
	// スクロールビュー
	if( $$get_my_uma_num >= 20 )
	{
		$$create_ui_scrollview($stage.object[@スクロールビュー_サムネイル], __mng_ur_barn_scroll, 1045, 147, @スクロールビュー_サムネイル, $stage.object[@ボタン_サムネイル], $stage.object[@ボタン_サムネイル + $len - 1], 766, 814, 26, @ボタン_スクロールビュー, @ボタン_スクロールビュー + 1, <URACE_BTN_GROUP_NORMAL>, 1, 0, 0)
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$set_ui_scrollview_group($stage.object[@ボタン_サムネイル + $i], $stage.object[@スクロールビュー_サムネイル], @スクロールビュー_サムネイル)
		}
	}
	
	// Newフラグ
	$$set_uma_new_flag(<URACE_PLAYER_OWNER_ID>, $uma_index, 0)
	
	// シーンオブジェクトを更新する
	$$update_scene_object($stage)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// ソートボタン
	switch( $$get_my_uma_list_sort_type ) {
		
	case(<URACE_SORT_TYPE_SKILL>)		// スキル順
		
		$stage.object[@ボタン_ソート_スキル順].set_button_state_select
		$stage.object[@ボタン_ソート_ステータス順].set_button_state_normal
		$stage.object[@ボタン_ソート_入手順].set_button_state_normal
		$stage.object[@ボタン_ソート_レアリティ順].set_button_state_normal
		
	case(<URACE_SORT_TYPE_STATUS>)		// ステータス順
		
		$stage.object[@ボタン_ソート_スキル順].set_button_state_normal
		$stage.object[@ボタン_ソート_ステータス順].set_button_state_select
		$stage.object[@ボタン_ソート_入手順].set_button_state_normal
		$stage.object[@ボタン_ソート_レアリティ順].set_button_state_normal
		
	case(<URACE_SORT_TYPE_GET>)			// 入手順
		
		$stage.object[@ボタン_ソート_スキル順].set_button_state_normal
		$stage.object[@ボタン_ソート_ステータス順].set_button_state_normal
		$stage.object[@ボタン_ソート_入手順].set_button_state_select
		$stage.object[@ボタン_ソート_レアリティ順].set_button_state_normal
		
	case(<URACE_SORT_TYPE_RARITY>)		// レアリティ順
		
		$stage.object[@ボタン_ソート_スキル順].set_button_state_normal
		$stage.object[@ボタン_ソート_ステータス順].set_button_state_normal
		$stage.object[@ボタン_ソート_入手順].set_button_state_normal
		$stage.object[@ボタン_ソート_レアリティ順].set_button_state_select
		
	}
	
	// 昇順／降順
	$$update_ui_toggle_button($stage.object[@ボタン_ソート_昇順／降順], $$get_my_uma_list_sort_order)
	
	// 名前
	$$update_ui_string($stage.object[@オブジェクト_背景].child[2], $$get_uma_name(<URACE_PLAYER_OWNER_ID>, $uma_index))
	
	// カード
	$$update_uma_card_object($stage.object[@オブジェクト_背景].child[3], $$get_uma_id(<URACE_PLAYER_OWNER_ID>, $uma_index))
	
	// ステータス
	$$update_uma_status_object($stage.object[@オブジェクト_背景].child[4], <URACE_PLAYER_OWNER_ID>, $uma_index)
	
	// ＵＭＡサムネイルボタン
	$len = $$get_my_uma_num
	for( $i = 0, $i < $len, $i += 1 )
	{
		// サムネイルボタンを更新する
		$$update_uma_thumb_btn($stage.object[@ボタン_サムネイル + $i], <URACE_PLAYER_OWNER_ID>, $i, $i, 2)
		
		// 表示しているのＵＭＡサムネイルボタンは選択中にする
		if( $uma_index == $i )	{ $stage.object[@ボタン_サムネイル + $i].set_button_state_select }
		else					{ $stage.object[@ボタン_サムネイル + $i].set_button_state_normal }
	}
	
	// パッド入力の遷移を更新する
	$$update_joypad_navigation($stage)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_scene_object(property $stage : stage)
{
	// ワイプ
	wipe(0, 250, wait=1)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_サムネイル)
	
	/*
	$stage.object[@ボタン_名前変更].joypad_up    = -1
	$stage.object[@ボタン_名前変更].joypad_down  = -1
	$stage.object[@ボタン_名前変更].joypad_left  = @ボタン_ソート_レアリティ順
	$stage.object[@ボタン_名前変更].joypad_right = @ボタン_ソート_昇順
	
	$stage.object[@ボタン_ソート_昇順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_昇順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_昇順].joypad_left  = @ボタン_名前変更
	$stage.object[@ボタン_ソート_昇順].joypad_right = @ボタン_ソート_降順
	
	$stage.object[@ボタン_ソート_降順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_降順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_降順].joypad_left  = @ボタン_ソート_昇順
	$stage.object[@ボタン_ソート_降順].joypad_right = @ボタン_ソート_名前順
	
	$stage.object[@ボタン_ソート_名前順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_名前順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_名前順].joypad_left  = @ボタン_ソート_降順
	$stage.object[@ボタン_ソート_名前順].joypad_right = @ボタン_ソート_番号順
	
	$stage.object[@ボタン_ソート_番号順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_番号順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_番号順].joypad_left  = @ボタン_ソート_名前順
	$stage.object[@ボタン_ソート_番号順].joypad_right = @ボタン_ソート_レアリティ順
	
	$stage.object[@ボタン_ソート_レアリティ順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_レアリティ順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_レアリティ順].joypad_left  = @ボタン_ソート_番号順
	$stage.object[@ボタン_ソート_レアリティ順].joypad_right = @ボタン_名前変更
	
	$stage.object[@ボタン_編成].joypad_up    = -1
	$stage.object[@ボタン_編成].joypad_down  = -1
	$stage.object[@ボタン_編成].joypad_left  = @ボタン_戻る
	$stage.object[@ボタン_編成].joypad_right = @ボタン_戻る
	
	$stage.object[@ボタン_戻る].joypad_up    = -1
	$stage.object[@ボタン_戻る].joypad_down  = -1
	$stage.object[@ボタン_戻る].joypad_left  = @ボタン_編成
	$stage.object[@ボタン_戻る].joypad_right = @ボタン_編成
	*/
	
	// パッド入力の遷移を更新する
	$$update_joypad_navigation($stage)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を更新する
//---------------------------------------------------------------------------
command $$update_joypad_navigation(property $stage : stage)
{
	property $i
	property $w
	property $len
	
	/*
	$w = 3
	$len = $$get_my_uma_num
	
	// タブ／戻るボタンの下入力は現在のソートボタンへ
	$stage.object[@ボタン_編成].joypad_down  = @ボタン_ソート_名前順 + $$get_my_uma_list_sort_type
	$stage.object[@ボタン_戻る].joypad_down  = @ボタン_ソート_名前順 + $$get_my_uma_list_sort_type
	
	// タブ／戻るボタンの上入力は現在のサムネイルボタンの最後へ
	$stage.object[@ボタン_編成].joypad_up    = @ボタン_サムネイル + $len - 1
	$stage.object[@ボタン_戻る].joypad_up    = @ボタン_サムネイル + $len - 1
	
	// サムネイルボタン
	for( $i = 0, $i < $len, $i += 1 )
	{
		$stage.object[@ボタン_サムネイル + $i].joypad_up    = @ボタン_サムネイル + $i - $w
		$stage.object[@ボタン_サムネイル + $i].joypad_down  = @ボタン_サムネイル + $i + $w
		$stage.object[@ボタン_サムネイル + $i].joypad_left  = @ボタン_サムネイル + $i - 1
		$stage.object[@ボタン_サムネイル + $i].joypad_right = @ボタン_サムネイル + $i + 1
		
		// 最左は最右へ
		if( $i % $w == 0 )
		{
			$stage.object[@ボタン_サムネイル + $i].joypad_left  = @ボタン_サムネイル + $i + $w - 1
		}
		
		// 最右は最左へ
		if( $i % $w == $w - 1 )
		{
			$stage.object[@ボタン_サムネイル + $i].joypad_right = @ボタン_サムネイル + $i - ($w - 1)
		}
		
		// 最上段
		if( $i < $w )
		{
			$stage.object[@ボタン_サムネイル + $i].joypad_up = @ボタン_ソート_名前順 + $$get_my_uma_list_sort_type
		}
		
		// 最下段
		if( $len - $w <= $i )
		{
			$stage.object[@ボタン_サムネイル + $i].joypad_down  = @ボタン_戻る
		}
	}
	*/
}

//---------------------------------------------------------------------------
// 表示しているＵＭＡを更新する
//---------------------------------------------------------------------------
command $$update_uma_info(property $index)
{
	$uma_index = $index
	
	$$set_uma_new_flag(<URACE_PLAYER_OWNER_ID>, $uma_index, 0)
	
	// シーンオブジェクトを更新する
	$$update_scene_object(front)
}




//===========================================================================
// ＵＭＡ名変更フロー
//===========================================================================
#z01

$$create_rename_scene_object(front)			// シーンオブジェクトを作成する
$$set_rename_joypad_navigation(front)		// パッド入力の遷移を設定する
$$show_rename_scene_object(front)			// シーンオブジェクトを表示する

// 入力制御を開始する
$$input_start(front, <URACE_BTN_GROUP_MODAL>)

while(1)
{
	// エディットボックスに入力されているテキストを取得する
	$editbox_text = editbox[<EDITBOX_INDEX>].get_text
	
	// 入力制御を更新する
	$modal_select_btn = $$input_update(front, <URACE_BTN_GROUP_MODAL>)
	
	// キャンセルは終了する
	if( $modal_select_btn == -1 )
	{
		@ＳＥ_ＵＭＡレース_ボタン_キャンセル
		
		break
	}
	
	// エディットボックスで決定した
	if( editbox[<EDITBOX_INDEX>].check_decided == 1 )
	{
		if( $editbox_text.len > <URACE_DECK_NAME_MAX> )
		{
			@ＳＥ_ＵＭＡレース_ボタン_キャンセル
			
			editbox[<EDITBOX_INDEX>].clear_input
		}
		else
		{
			@ＳＥ_ＵＭＡレース_ボタン_決定
			
			// ＵＭＡ名を設定する
			$$set_uma_name(<URACE_PLAYER_OWNER_ID>, $uma_index, editbox[<EDITBOX_INDEX>].get_text)
			
			break
		}
	}
	
	// 決定ボタンを押した
	elseif( $modal_select_btn == @ボタン_モーダル_決定 )
	{
		// ＵＭＡ名を設定する
		$$set_uma_name(<URACE_PLAYER_OWNER_ID>, $uma_index, editbox[<EDITBOX_INDEX>].get_text)
		
		break
	}
	
	// エディットボックスでキャンセルした／キャンセルボタンを押した
	elseif( editbox[<EDITBOX_INDEX>].check_canceled == 1 || $modal_select_btn == @ボタン_モーダル_キャンセル )
	{
		// ＳＥ再生
		if( editbox[<EDITBOX_INDEX>].check_canceled == 1 ) {
			@ＳＥ_ＵＭＡレース_ボタン_キャンセル
		}
		
		break
	}
	
	// シーンオブジェクトを更新する
	$$update_rename_scene_object(front)
	
	// 画面の更新
	disp
}

$$hide_rename_scene_object(front)			// シーンオブジェクトを非表示にする

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_rename_scene_object(property $stage : stage)
{
	// フィルター
	$stage.object[@オブジェクト_モーダル_背景].create("__mng_ur_barn_rename_filter", 1)
	$stage.object[@オブジェクト_モーダル_背景].child.resize(2)
	
	// 背景
	$stage.object[@オブジェクト_モーダル_背景].child[0].create("__mng_ur_barn_rename_bg", 1, 420, 353)
	
	// 文字数
	$stage.object[@オブジェクト_モーダル_背景].child[1].create_number("__mng_ur_barn_rename_number", 1, 1317, 543)
	$stage.object[@オブジェクト_モーダル_背景].child[1].set_number_param(2, 0, 0, 0, 0, 0)
	$stage.object[@オブジェクト_モーダル_背景].child[1].color_r = 255		// 最大文字数超え用
	
	// 決定／キャンセルボタン
	$$create_ui_button($stage.object[@ボタン_モーダル_決定], "__mng_ur_barn_rename_ok_btn", 587, 599, @ボタン_モーダル_決定, <URACE_BTN_GROUP_MODAL>, 1)
	$$create_ui_button($stage.object[@ボタン_モーダル_キャンセル], "__mng_ur_barn_rename_cancel_btn", 1001, 599, @ボタン_モーダル_キャンセル, <URACE_BTN_GROUP_MODAL>, 2)
	
	// エディットボックス
	editbox[<EDITBOX_INDEX>].create(685, 500, 560, 42, 45)
	editbox[<EDITBOX_INDEX>].set_text($$get_uma_name(<URACE_PLAYER_OWNER_ID>, $uma_index))
	editbox[<EDITBOX_INDEX>].set_focus
	
	// シーンオブジェクトを更新する
	$$update_rename_scene_object($stage)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_rename_scene_object(property $stage : stage)
{
	// 文字数
	$stage.object[@オブジェクト_モーダル_背景].child[1].set_number(($editbox_text.len + 1) / 2)
	
	// 最大文字数を超えた場合
	if( $editbox_text.len > <UMA_NAME_MAX> ) 
	{
		// 決定ボタン
		$stage.object[@ボタン_モーダル_決定].set_button_state_disable
		
		// 文字数
		$stage.object[@オブジェクト_モーダル_背景].child[1].color_rate = 255
	}
	else
	{
		// 決定ボタン
		$stage.object[@ボタン_モーダル_決定].set_button_state_normal
		
		// 文字数
		$stage.object[@オブジェクト_モーダル_背景].child[1].color_rate = 0
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$show_rename_scene_object(property $stage : stage)
{
}

//---------------------------------------------------------------------------
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_rename_scene_object(property $stage : stage)
{
	editbox[<EDITBOX_INDEX>].destroy
	input.clear
	
	$stage.object[@オブジェクト_モーダル_背景].init
	$stage.object[@ボタン_モーダル_決定].init
	$stage.object[@ボタン_モーダル_キャンセル].init
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_rename_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_モーダル_キャンセル)
	
	$stage.object[@ボタン_モーダル_決定].joypad_up    = -1
	$stage.object[@ボタン_モーダル_決定].joypad_down  = -1
	$stage.object[@ボタン_モーダル_決定].joypad_left  = @ボタン_モーダル_キャンセル
	$stage.object[@ボタン_モーダル_決定].joypad_right = @ボタン_モーダル_キャンセル
	
	$stage.object[@ボタン_モーダル_キャンセル].joypad_up    = -1
	$stage.object[@ボタン_モーダル_キャンセル].joypad_down  = -1
	$stage.object[@ボタン_モーダル_キャンセル].joypad_left  = @ボタン_モーダル_決定
	$stage.object[@ボタン_モーダル_キャンセル].joypad_right = @ボタン_モーダル_決定
}

