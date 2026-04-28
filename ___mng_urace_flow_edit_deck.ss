//===========================================================================
//!
//!    @file     ___mng_urace_flow_edit_deck.ss
//!    @brief    ＵＭＡレース／編成画面
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     出走するＵＭＡのデッキ編成画面
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// 定数
	#replace	<MY_LIST_THUMB_NUM>			6	// 所持ＵＭＡ表示サムネイル数
	#replace	<EDITBOX_INDEX>				0	// 使用するエディットボックス
	
	// オブジェクト／ボタン定義
	#replace	@オブジェクト_背景				0
	#replace	@オブジェクト_デッキ			1
	#replace	@オブジェクト_所持ＵＭＡ		2
	
	#replace	@ボタン_戻る					11
	#replace	@ボタン_デッキ名変更			12
	#replace	@ボタン_デッキ					13
	#define		@ボタン_デッキ_最大				(@ボタン_デッキ + <URACE_DECK_MAX> - 1)
	#replace	@ボタン_ソート_スキル順			20
	#replace	@ボタン_ソート_ステータス順		21
	#replace	@ボタン_ソート_入手順			22
	#replace	@ボタン_ソート_レアリティ順		23
	#replace	@ボタン_ソート_昇順／降順		24
	
	#replace	@ボタン_デッキ_ページ戻る		25
	#replace	@ボタン_デッキ_ページ進む		26
	#replace	@ボタン_所持ＵＭＡ_ページ戻る	27
	#replace	@ボタン_所持ＵＭＡ_ページ進む	28
	#replace	@ボタン_デッキ_サムネイル		29
	#replace	@ボタン_所持ＵＭＡ_サムネイル	45
	
	// オブジェクト／ボタン定義（モーダル）
	#replace	@オブジェクト_モーダル_背景		100
	#replace	@ボタン_モーダル_決定			101
	#replace	@ボタン_モーダル_キャンセル		102
	
	
	// 変数
	#property	$select_btn				// 選択したボタン
	#property	$my_list_page_index		// 所持ＵＭＡページインデックス
	#property	$my_list_page_max		// 所持ＵＭＡページ最大数
	#property	$mode
	
	#property	$modal_select_btn		// モーダルウィンドウで選択したボタン
	#property	$editbox_text : str		// エディットボックスに入力されているテキスト
	
#inc_end


//===========================================================================
// 編成フロー
//===========================================================================
#z00

@ＵＭＡレースシーン設定

$$set_scene_data					// シーンデータを設定する
$$create_scene_object(back, l[0])	// シーンオブジェクトを作成する
$$set_joypad_navigation(back)		// パッド入力の遷移を設定する
$$show_scene_object(back)			// シーンオブジェクトを表示する

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
	
	// デッキ名変更ボタンが押された
	if( $select_btn == @ボタン_デッキ名変更 )
	{
		gosub #z01
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front)
	}
	
	// デッキボタン
	if( @ボタン_デッキ <= $select_btn && $select_btn <= @ボタン_デッキ_最大 )
	{
		$$set_my_deck_index($select_btn - @ボタン_デッキ)	// 選択中のデッキを変更する
		$$update_scene_object(front)						// シーンオブジェクトを更新する
	}
	
	// デッキページボタンが押された
	if( $select_btn == @ボタン_デッキ_ページ戻る )
	{
		$$prev_my_deck_index			// 選択中のデッキを変更する
		$$update_scene_object(front)	// シーンオブジェクトを更新する
	}
	elseif( $select_btn == @ボタン_デッキ_ページ進む )
	{
		$$next_my_deck_index			// 選択中のデッキを変更する
		$$update_scene_object(front)	// シーンオブジェクトを更新する
	}
	
	// 所持ＵＭＡページボタンが押された
	if( $select_btn == @ボタン_所持ＵＭＡ_ページ戻る )
	{
		// 所持ＵＭＡのページを変更する
		$my_list_page_index -= 1
		if( $my_list_page_index < 0 ) {
			$my_list_page_index = $my_list_page_max - 1
		}
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front)
	}
	elseif( $select_btn == @ボタン_所持ＵＭＡ_ページ進む )
	{
		// 所持ＵＭＡのページを変更する
		$my_list_page_index += 1
		if( $my_list_page_max <= $my_list_page_index ) {
			$my_list_page_index = 0
		}
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front)
	}
	
	// ソートボタンが押された
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

$$hide_scene_object(back)			// シーンオブジェクトを非表示にする

@ＵＭＡレースシーン設定解除

return


//---------------------------------------------------------------------------
// シーンデータを設定する
//---------------------------------------------------------------------------
command $$set_scene_data
{
	// 所持ＵＭＡのページ最大数を計算する
	$my_list_page_max = (($$get_my_uma_num - 1) / <MY_LIST_THUMB_NUM>) + 1
}

//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage, property $mode)
{
	property $i
	property $len
	
	// 背景／厩舎
	$stage.object[@オブジェクト_背景].create("__mng_ur_edit_bg", 1)
	$stage.object[@オブジェクト_背景].child.resize(1)
	
	// タグ
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_edit_tag", 1)
	
	// 戻る／出走登録ボタン（パドックからの遷移は出走登録に変更）
	if( $mode == 1 ) {
		$$create_ui_button($stage.object[@ボタン_戻る], "__mng_ur_edit_entry_btn", 1556, 950, @ボタン_戻る, <URACE_BTN_GROUP_NORMAL>, 1)
	} else {
		$$create_ui_button($stage.object[@ボタン_戻る], "__mng_ur_edit_back_btn", 1556, 950, @ボタン_戻る, <URACE_BTN_GROUP_NORMAL>, 1)
	}
	
	// デッキ名変更
	$$create_ui_button($stage.object[@ボタン_デッキ名変更], "__mng_ur_edit_deck_rename_btn", 582, 155, @ボタン_デッキ名変更, <URACE_BTN_GROUP_NORMAL>, 1)
	
	// デッキボタン
	for( $i = 0, $i < <URACE_DECK_MAX>, $i += 1 ) {
		$$create_ui_button($stage.object[@ボタン_デッキ + $i], "__mng_ur_edit_deck_btn" + math.tostr($i + 1), 1212 + 116 * $i, 157, @ボタン_デッキ + $i, <URACE_BTN_GROUP_NORMAL>, 1)
	}
	
	// ソートボタン
	$$create_ui_button($stage.object[@ボタン_ソート_スキル順], "__mng_ur_edit_sort_skill_btn", 1214, 644, @ボタン_ソート_スキル順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_ステータス順], "__mng_ur_edit_sort_param_btn", 1369, 644, @ボタン_ソート_ステータス順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_入手順], "__mng_ur_edit_sort_get_btn", 1524, 644, @ボタン_ソート_入手順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_レアリティ順], "__mng_ur_edit_sort_rarity_btn", 1679, 644, @ボタン_ソート_レアリティ順, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_toggle_button($stage.object[@ボタン_ソート_昇順／降順], "__mng_ur_edit_sort_order_btn", 1837, 644, @ボタン_ソート_昇順／降順, <URACE_BTN_GROUP_NORMAL>, 1, $$get_my_uma_list_sort_order)
	
	// デッキ
	$stage.object[@オブジェクト_デッキ].create("__mng_ur_edit_deck_bg", 1, 73, 126)
	$stage.object[@オブジェクト_デッキ].child.resize(2)
	$$create_ui_button($stage.object[@ボタン_デッキ_ページ戻る], "__mng_ur_edit_list_prev_btn", 104, 356, @ボタン_デッキ_ページ戻る, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_デッキ_ページ進む], "__mng_ur_edit_list_next_btn", 1741, 356, @ボタン_デッキ_ページ進む, <URACE_BTN_GROUP_NORMAL>, 1)
	
	// デッキ名
	$stage.object[@オブジェクト_デッキ].child[0].create_string("", 1, 110, 44)
	$stage.object[@オブジェクト_デッキ].child[0].set_string_param(30, -2, 0, 12, 0, -1, -1, -1)
	
	// デッキＵＭＡサムネイル
	$len = <URACE_DECK_UMA_MAX>
	for( $i = 0, $i < $len, $i += 1 ) {
		$$create_uma_thumb_btn($stage.object[@ボタン_デッキ_サムネイル + $i], <URACE_PLAYER_OWNER_ID>, $i, 180 + ($i % 6) * 259, 264 + ($i / 6) * 152, @ボタン_デッキ_サムネイル + $i, <URACE_BTN_GROUP_NORMAL>)
	}
	
	// デッキページ
	$len = <URACE_DECK_MAX>
	
	$stage.object[@オブジェクト_デッキ].child[1].disp = 1
	$stage.object[@オブジェクト_デッキ].child[1].set_pos(889 - ($len * 24 - 6) / 2, 428)
	$stage.object[@オブジェクト_デッキ].child[1].child.resize($len)
	for( $i = 0, $i < $len, $i += 1 ) {
		$stage.object[@オブジェクト_デッキ].child[1].child[$i].create("__mng_ur_edit_deck_page", 1, $i * 24, 0)
	}
	
	// 所持ＵＭＡリスト
	$stage.object[@オブジェクト_所持ＵＭＡ].create("__mng_ur_edit_my_list_bg", 1, 0, 659)
	$stage.object[@オブジェクト_所持ＵＭＡ].child.resize(1)
	$$create_ui_button($stage.object[@ボタン_所持ＵＭＡ_ページ戻る], "__mng_ur_edit_list_prev_btn", 104, 785, @ボタン_所持ＵＭＡ_ページ戻る, <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_所持ＵＭＡ_ページ進む], "__mng_ur_edit_list_next_btn", 1741, 785, @ボタン_所持ＵＭＡ_ページ進む, <URACE_BTN_GROUP_NORMAL>, 1)
	
	// 所持ＵＭＡサムネイル
	$len = <MY_LIST_THUMB_NUM>
	for( $i = 0, $i < $len, $i += 1 ) {
		$$create_uma_thumb_btn($stage.object[@ボタン_所持ＵＭＡ_サムネイル + $i], <URACE_PLAYER_OWNER_ID>, $my_list_page_index * <MY_LIST_THUMB_NUM> + $i, 180 + $i * 259, 754, @ボタン_所持ＵＭＡ_サムネイル + $i, <URACE_BTN_GROUP_NORMAL>)
	}
	
	// 所持ＵＭＡリストページ
	$len = $my_list_page_max
	
	$stage.object[@オブジェクト_所持ＵＭＡ].child[0].disp = 1
	$stage.object[@オブジェクト_所持ＵＭＡ].child[0].set_pos(962 - ($len * 24 - 6) / 2, 236)
	$stage.object[@オブジェクト_所持ＵＭＡ].child[0].child.resize($len)
	for( $i = 0, $i < $len, $i += 1 ) {
		$stage.object[@オブジェクト_所持ＵＭＡ].child[0].child[$i].create("__mng_ur_edit_my_list_page", 1, $i * 24, 0)
	}
	
	// 更新する
	$$update_scene_object($stage)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage)
{
	property $i
	property $len
	
	// デッキボタン
	for( $i = 0, $i < <URACE_DECK_MAX>, $i += 1 )
	{
		if( $i == $$get_my_deck_index ) {
			$stage.object[@ボタン_デッキ + $i].set_button_state_select
		} else {
			$stage.object[@ボタン_デッキ + $i].set_button_state_normal
		}
	}
	
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
	
	// デッキＵＭＡサムネイル
	$len = <URACE_DECK_UMA_MAX>
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$update_uma_thumb_btn($stage.object[@ボタン_デッキ_サムネイル + $i], <URACE_PLAYER_OWNER_ID>, $$get_my_deck($i), $i, 0)
	}
	
	// デッキ名
	$stage.object[@オブジェクト_デッキ].child[0].set_string($$get_my_deck_name($$get_my_deck_index))
	
	// デッキページ
	$len = $stage.object[@オブジェクト_デッキ].child[1].child.get_size
	for( $i = 0, $i < $len, $i += 1 ) {
		if( $i == $$get_my_deck_index ) {
			$stage.object[@オブジェクト_デッキ].child[1].child[$i].patno = 1
		} else {
			$stage.object[@オブジェクト_デッキ].child[1].child[$i].patno = 0
		}
	}
	
	// 所持ＵＭＡサムネイル
	$len = <MY_LIST_THUMB_NUM>
	for( $i = 0, $i < $len, $i += 1 )
	{
		if( $my_list_page_index == $my_list_page_max - 1 && $$get_my_uma_num % <MY_LIST_THUMB_NUM> > 0 && $$get_my_uma_num % <MY_LIST_THUMB_NUM> <= $i )
		{
			$stage.object[@ボタン_所持ＵＭＡ_サムネイル + $i].disp = 0
		}
		else
		{
			$stage.object[@ボタン_所持ＵＭＡ_サムネイル + $i].disp = 1
			$$update_uma_thumb_btn($stage.object[@ボタン_所持ＵＭＡ_サムネイル + $i], <URACE_PLAYER_OWNER_ID>, $my_list_page_index * <MY_LIST_THUMB_NUM> + $i, $i, 1)
		}
	}
	
	// 所持ＵＭＡリストページ
	$len = $stage.object[@オブジェクト_所持ＵＭＡ].child[0].child.get_size
	for( $i = 0, $i < $len, $i += 1 ) {
		if( $i == $my_list_page_index ) {
			$stage.object[@オブジェクト_所持ＵＭＡ].child[0].child[$i].patno = 1
		} else {
			$stage.object[@オブジェクト_所持ＵＭＡ].child[0].child[$i].patno = 0
		}
	}
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
// シーンオブジェクトを非表示にする
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	// 全てのオブジェクトのワイプコピーフラグをオフする
	$$set_front_wipe_copy_all(0)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
//	$$set_joypad_focus_button(@ボタン_サムネイル)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を更新する
//---------------------------------------------------------------------------
command $$update_joypad_navigation(property $stage : stage)
{
}



//===========================================================================
// デッキ名変更フロー
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
			
			// デッキ名を設定する
			$$set_my_deck_name($$get_my_deck_index, editbox[<EDITBOX_INDEX>].get_text)
			
			break
		}
	}
	
	// 決定ボタンを押した
	elseif( $modal_select_btn == @ボタン_モーダル_決定 )
	{
		// デッキ名を設定する
		$$set_my_deck_name($$get_my_deck_index, editbox[<EDITBOX_INDEX>].get_text)
		
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
	$stage.object[@オブジェクト_モーダル_背景].create("__mng_ur_edit_rename_filter", 1)
	$stage.object[@オブジェクト_モーダル_背景].child.resize(2)
	
	// 背景
	$stage.object[@オブジェクト_モーダル_背景].child[0].create("__mng_ur_edit_rename_bg", 1, 418, 355)
	
	// 文字数
	$stage.object[@オブジェクト_モーダル_背景].child[1].create_number("__mng_ur_edit_rename_number", 1, 1317, 537)
	$stage.object[@オブジェクト_モーダル_背景].child[1].set_number_param(2, 0, 0, 0, 0, 0)
	$stage.object[@オブジェクト_モーダル_背景].child[1].color_r = 255		// 最大文字数超え用
	
	// 決定／キャンセルボタン
	$$create_ui_button($stage.object[@ボタン_モーダル_決定], "__mng_ur_edit_rename_ok_btn", 585, 595, @ボタン_モーダル_決定, <URACE_BTN_GROUP_MODAL>, 1)
	$$create_ui_button($stage.object[@ボタン_モーダル_キャンセル], "__mng_ur_edit_rename_cancel_btn", 999, 595, @ボタン_モーダル_キャンセル, <URACE_BTN_GROUP_MODAL>, 2)
	
	// エディットボックス
	editbox[<EDITBOX_INDEX>].create(685, 494, 560, 42, 45)
	editbox[<EDITBOX_INDEX>].set_text($$get_my_deck_name($$get_my_deck_index))
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
	if( $editbox_text.len > <URACE_DECK_NAME_MAX> ) 
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

