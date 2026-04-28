//===========================================================================
//!
//!    @file     ___mng_urace_flow_library.ss
//!    @brief    ＵＭＡレース／図鑑画面
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
	
	// オブジェクト／スクロールビュー／ボタン定義
	#replace	@オブジェクト_背景					0
	#replace	@スクロールビュー_サムネイル		1
	#replace	@オブジェクト_詳細					2
	#replace	@ボタン_戻る						11
	#replace	@ボタン_タブ						12
	#replace	@ボタン_ソート_昇順／降順			13
	
	#replace	@ボタン_ソート_番号順				14
	#replace	@ボタン_ソート_レアリティ順			15
	#replace	@ボタン_ソート_スキル順				16
	#replace	@ボタン_スクロールビュー			18
	#replace	@ボタン_サムネイル					20
	#define		@ボタン_サムネイル最大				(@ボタン_サムネイル + $$get_db_uma_max)
	
	// タブ定義
	#replace	<TAB_UMA>			0			// ＵＭＡ
	#replace	<TAB_ITEM>			1			// アイテム
	
	// ページ管理
	#property	$tab_index						// タブ番号
	#property	$select_index					// 選択しているサムネイル
	
	// 選択したボタン
	#property	$select_btn						// 図鑑で選択しているボタン
	
#inc_end


//===========================================================================
// ＵＭＡ図鑑フロー
//===========================================================================
#z00

@ＵＭＡレースシーン設定

$$create_scene_object(back)			// シーンオブジェクトを作成する
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
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_戻る
	}
	
	// 戻るボタンが押された場合
	if( $select_btn == @ボタン_戻る )
	{
		break
	}
	
	// タブボタン（ＵＭＡ／アイテム図鑑）が押された場合
	if( @ボタン_タブ == $select_btn )
	{
		// 現在のタブから変更するタブを設定する
		switch( $tab_index ) {
		case(<TAB_UMA>)		$tab_index = <TAB_ITEM>
		case(<TAB_ITEM>)	$tab_index = <TAB_UMA>
		}
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front, 1)
	}
	
	// ソートボタン（昇順／降順）が押された場合
	if( @ボタン_ソート_昇順／降順 == $select_btn )
	{
		$$reverse_uma_library_sort_order	// 昇順／降順を切り替える
		$$sort_uma_library					// ソートを実行する
		$$update_scene_object(front, 1)		// シーンオブジェクトを更新する
	}
	
	// ソートボタンが押されている場合は各タイプのソートを設定する
	if( @ボタン_ソート_番号順 <= $select_btn && $select_btn <= @ボタン_ソート_レアリティ順 )
	{
		switch( $select_btn ) {
		case(@ボタン_ソート_番号順)			$$set_uma_library_sort_type(<URACE_LIBRARY_SORT_TYPE_NO>)
		case(@ボタン_ソート_スキル順)		$$set_uma_library_sort_type(<URACE_LIBRARY_SORT_TYPE_SKILL>)
		case(@ボタン_ソート_レアリティ順)	$$set_uma_library_sort_type(<URACE_LIBRARY_SORT_TYPE_RARITY>)
		}
		
		// ソートを実行する
		$$sort_uma_library
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front, 1)
	}
	
	// サムネイルボタンが押された場合
	if( @ボタン_サムネイル <= $select_btn && $select_btn <= @ボタン_サムネイル最大 )
	{
		// 選択しているサムネイルを設定する
		$select_index = $select_btn - @ボタン_サムネイル
		
		// スクロールビューが設定されている場合は一時的に無効にする
		if( $tab_index == <TAB_UMA> ) {
			front.object[@スクロールビュー_サムネイル].f_scview_enable = 0
		}
		
		// シーンオブジェクトを更新する
		$$update_scene_object(front, 0)
		
		// ＵＭＡ詳細オブジェクトを更新する
		$$update_uma_info_object(front.object[@オブジェクト_詳細])
		
		// スクロールビューが設定されている場合は有効に戻す
		if( $tab_index == <TAB_UMA> ) {
			front.object[@スクロールビュー_サムネイル].f_scview_enable = 1
		}
	}
	
	// 何らかのボタンが押されている場合
	if( $select_btn != -2 )
	{
		$$input_start(front, <URACE_BTN_GROUP_NORMAL>)		// 入力制御を再開始する
	}
	
	// 何も押していないときは画面の更新のみ
	if( $select_btn == -2 )
	{
		input.next		// 入力の更新
		disp			// 画面の更新
	}
}

// シーンオブジェクトを非表示にする
$$hide_scene_object(front)

@ＵＭＡレースシーン設定解除

return


//---------------------------------------------------------------------------
// シーンオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_scene_object(property $stage : stage)
{
	// 背景
	$stage.object[@オブジェクト_背景].create("__mng_ur_library_bg", 1, 0, 0, 1)
	$stage.object[@オブジェクト_背景].child.resize(2)
	
	$stage.object[@オブジェクト_背景].child[0].create("__mng_ur_library_bg", 1)
	
	// タグ
	$stage.object[@オブジェクト_背景].child[1].create("__mng_ur_library_tag", 1)
	
	// 戻るボタン
	$$create_ui_button($stage.object[@ボタン_戻る], "__mng_ur_library_back_btn", 30, 949, @ボタン_戻る, <URACE_BTN_GROUP_NORMAL>, 2)
	
	// タブボタン
	$$create_ui_toggle_button($stage.object[@ボタン_タブ], "__mng_ur_library_tab_btn", 1558, 949, @ボタン_タブ, <URACE_BTN_GROUP_NORMAL>, 1, $tab_index)
	
	// ソート（昇順／降順）ボタン
	$$create_ui_toggle_button($stage.object[@ボタン_ソート_昇順／降順], "__mng_ur_library_sort_btn", 1839, 91, @ボタン_ソート_昇順／降順, <URACE_BTN_GROUP_NORMAL>, 1, $$get_uma_library_sort_order)
	
	// ＵＭＡ詳細
	$$create_uma_info_object($stage.object[@オブジェクト_詳細])
	
	
	
	
	// ソートボタン
	$$create_ui_button($stage.object[@ボタン_ソート_スキル順],     __mng_ur_library_sort_skill_btn,  1414, 91, @ボタン_ソート_スキル順,     <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_番号順],       __mng_ur_library_sort_no_btn,     1569, 91, @ボタン_ソート_番号順,       <URACE_BTN_GROUP_NORMAL>, 1)
	$$create_ui_button($stage.object[@ボタン_ソート_レアリティ順], __mng_ur_library_sort_rarity_btn, 1724, 91, @ボタン_ソート_レアリティ順, <URACE_BTN_GROUP_NORMAL>, 1)
	$stage.object[@ボタン_ソート_スキル順].layer += 1
	$stage.object[@ボタン_ソート_番号順].layer += 1
	$stage.object[@ボタン_ソート_レアリティ順].layer += 1
	
	$stage.object[@ボタン_ソート_スキル順].disp = 0
	$stage.object[@ボタン_ソート_番号順].disp = 0
	$stage.object[@ボタン_ソート_レアリティ順].disp = 0
	
	// シーンオブジェクトを更新する
	$$update_scene_object($stage, 1)
}

//---------------------------------------------------------------------------
// サムネイルオブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_thumbnail_object(property $stage : stage)
{
	property $i
	property $len
	property $id
	property $filename : str
	
	// スクロールビューの初期化
	$stage.object[@スクロールビュー_サムネイル].init
	
	// サムネイルオブジェクトの初期化
	for( $i = @ボタン_サムネイル, $i <= @ボタン_サムネイル最大, $i += 1 )
	{
		$stage.object[$i].init
	}
	
	// ＵＭＡ図鑑
	if( $tab_index == <TAB_UMA> )
	{
		// サムネイル
		$len = $$get_db_uma_max
		for( $i = 0, $i < $len, $i += 1 )
		{
			$id = $$get_uma_libray($i)
			
			if( $$get_uma_library_flag($id) == <URACE_LIBRARY_FLAG_NONE> ) {
				$filename = __mng_ur_library_uma_btn00
			} else {
				$filename = __mng_ur_library_uma_btn + math.tostr_zero($id, 2)
			}
			
			if( $i == 0 ) {
				$$create_ui_button($stage.object[@ボタン_サムネイル + $i], $filename, 1121 - 13 + 235 * ($i % 3), 199 - 5 + 150 * ($i / 3), @ボタン_サムネイル + $i, <URACE_BTN_GROUP_NORMAL>, 1)
			} else {
				$$create_ui_button($stage.object[@ボタン_サムネイル + $i], $filename, 1121 + 235 * ($i % 3), 199 + 150 * ($i / 3), @ボタン_サムネイル + $i, <URACE_BTN_GROUP_NORMAL>, 1)
			}
			
			if( $$get_uma_library_flag($id) <= <URACE_LIBRARY_FLAG_LOOK> ) {
				$stage.object[@ボタン_サムネイル + $i].set_button_state_disable
			} else {
				$stage.object[@ボタン_サムネイル + $i].set_button_state_normal
			}
			
			if( $i == $select_index ) {
				$stage.object[@ボタン_サムネイル + $i].set_button_state_select
			}
		}
		
		// スクロールビュー
		$$create_ui_scrollview($stage.object[@スクロールビュー_サムネイル], __mng_ur_library_scroll, 873, 187, @スクロールビュー_サムネイル, $stage.object[@ボタン_サムネイル], $stage.object[@ボタン_サムネイル + $len - 1], 765, 986, -32, @ボタン_スクロールビュー, @ボタン_スクロールビュー + 1, <URACE_BTN_GROUP_NORMAL>, 1, 0, 0)
		for( $i = 0, $i < $len, $i += 1 )
		{
			$$set_ui_scrollview_group($stage.object[@ボタン_サムネイル + $i], $stage.object[@スクロールビュー_サムネイル], @スクロールビュー_サムネイル)
		}
	}
	
	// アイテム図鑑
	elseif( $tab_index == <TAB_ITEM> )
	{
		// サムネイル
		$len = $$get_db_item_max
		for( $i = 0, $i < $len, $i += 1 )
		{
			$id = $i + 1
			
			if( $$get_item_library_flag($id) == <URACE_LIBRARY_FLAG_NONE> ) {
				$filename = urace_library_empty_btn
			} else {
				$filename = urace_library_item01_btn
			}
			
			$$create_ui_button($stage.object[@ボタン_サムネイル + $i], $filename, 460 + 182 * ($i % 6), 76 + 182 * ($i / 6), @ボタン_サムネイル + $i, <URACE_BTN_GROUP_NORMAL>, 1)
		}
	}
	
	// 図鑑番号、ＮＥＷマーク
	for( $i = 0, $i < $len, $i += 1 )
	{
		$id = $$get_uma_libray($i)
		
		$stage.object[@ボタン_サムネイル + $i].child.resize(3)
		
		// No.
		$stage.object[@ボタン_サムネイル + $i].child[0].create(__mng_ur_library_id_bg, 1, 160, -8)
		
		// 番号
		$stage.object[@ボタン_サムネイル + $i].child[1].create_number(__mng_ur_library_id_number, 1, 198, -14)
		$stage.object[@ボタン_サムネイル + $i].child[1].set_number_param(2, 1, 0, 0, 0, -11)
		$stage.object[@ボタン_サムネイル + $i].child[1].set_number($id)
		
		// ＮＥＷマーク
		if( $$get_library_flag($id) == <URACE_LIBRARY_FLAG_GET> ) {
			$stage.object[@ボタン_サムネイル + $i].child[2].create(urace_library_new_mark, 1, 20, 0)
			$stage.object[@ボタン_サムネイル + $i].child[2].set_scale(500, 500)
		}
		
		// 図鑑未取得
		if( $$get_library_flag($id) == <URACE_LIBRARY_FLAG_NONE> ) {
			$stage.object[@ボタン_サムネイル + $i].set_button_state_disable
		}
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage, property $thumb_create)
{
	// タブボタンを更新する
	$$update_ui_toggle_button($stage.object[@ボタン_タブ], $tab_index)
	
	// ソートボタンを更新する
	$$update_ui_toggle_button($stage.object[@ボタン_ソート_昇順／降順], $$get_uma_library_sort_order)
	
	// ソートボタン(タイプ)
	switch( $$get_uma_library_sort_type ) {
	case(<URACE_LIBRARY_SORT_TYPE_NO>)		// 番号順
		
		$stage.object[@ボタン_ソート_番号順].set_button_state_select
		$stage.object[@ボタン_ソート_スキル順].set_button_state_normal
		$stage.object[@ボタン_ソート_レアリティ順].set_button_state_normal
		
	case(<URACE_LIBRARY_SORT_TYPE_SKILL>)	// スキル順
		
		$stage.object[@ボタン_ソート_番号順].set_button_state_normal
		$stage.object[@ボタン_ソート_スキル順].set_button_state_select
		$stage.object[@ボタン_ソート_レアリティ順].set_button_state_normal
		
	case(<URACE_SORT_TYPE_RARITY>)			// レアリティ順
		
		$stage.object[@ボタン_ソート_番号順].set_button_state_normal
		$stage.object[@ボタン_ソート_スキル順].set_button_state_normal
		$stage.object[@ボタン_ソート_レアリティ順].set_button_state_select
	}
	
	// サムネイルオブジェクトの作成
	if( $thumb_create ) {
		$$create_thumbnail_object($stage)
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
	wipe(0, 150, wait=1)
}

//---------------------------------------------------------------------------
// シーンオブジェクトを表示する
//---------------------------------------------------------------------------
command $$hide_scene_object(property $stage : stage)
{
	property $i
	
	for( $i = 0, $i < $$get_db_uma_max, $i += 1 ) {
		if( front.object[@ボタン_サムネイル + $i].frame_action_ch.get_size > 0 ) {
			front.object[@ボタン_サムネイル + $i].frame_action_ch[0].end
		}
	}
	$stage.object[@スクロールビュー_サムネイル].init
	$$set_front_wipe_copy(0, 1, 128)
}

//---------------------------------------------------------------------------
// パッド入力の遷移を設定する
//---------------------------------------------------------------------------
command $$set_joypad_navigation(property $stage : stage)
{
	// ジョイパッドで最初に選択されているボタンを設定する
	$$set_joypad_focus_button(@ボタン_サムネイル)
	
	/*
	$stage.object[@ボタン_ソート_番号順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_番号順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_番号順].joypad_left  = @ボタン_ソート_降順
	$stage.object[@ボタン_ソート_番号順].joypad_right = @ボタン_ソート_レアリティ順
	
	$stage.object[@ボタン_ソート_レアリティ順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_レアリティ順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_レアリティ順].joypad_left  = @ボタン_ソート_番号順
	$stage.object[@ボタン_ソート_レアリティ順].joypad_right = @ボタン_ソート_スキル順
	
	$stage.object[@ボタン_ソート_スキル順].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート_スキル順].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート_スキル順].joypad_left  = @ボタン_ソート_レアリティ順
	$stage.object[@ボタン_ソート_スキル順].joypad_right = @ボタン_ソート_昇順
	
	$stage.object[@ボタン_ソート].joypad_up    = @ボタン_戻る
	$stage.object[@ボタン_ソート].joypad_down  = @ボタン_サムネイル
	$stage.object[@ボタン_ソート].joypad_left  = @ボタン_ソート_スキル順
	$stage.object[@ボタン_ソート].joypad_right = @ボタン_ソート_降順
	
	$stage.object[@ボタン_タブ].joypad_up    = @ボタン_サムネイル
	$stage.object[@ボタン_タブ].joypad_down  = @ボタン_ソート
	$stage.object[@ボタン_タブ].joypad_left  = @ボタン_戻る
	$stage.object[@ボタン_タブ].joypad_right = @ボタン_戻る
	
	$stage.object[@ボタン_戻る].joypad_up    = @ボタン_サムネイル
	$stage.object[@ボタン_戻る].joypad_down  = @ボタン_ソート
	$stage.object[@ボタン_戻る].joypad_left  = @ボタン_タブ
	$stage.object[@ボタン_戻る].joypad_right = @ボタン_タブ
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
	
	// 現在のタブから情報を取得する
	switch( $tab_index ) {
	case(<TAB_UMA>)		$len = $$get_db_uma_max		$w = 3
	case(<TAB_ITEM>)	$len = $$get_db_item_max	$w = 6
	}
	
	// タブ／戻るボタンの下入力は現在のソートボタンへ
	$stage.object[@ボタン_タブ].joypad_down  = @ボタン_ソート_番号順 + $$get_my_uma_list_sort_type
	$stage.object[@ボタン_戻る].joypad_down  = @ボタン_ソート_番号順 + $$get_my_uma_list_sort_type
	
	// タブ／戻るボタンの上入力は現在のサムネイルボタンの最後へ
	$stage.object[@ボタン_タブ].joypad_up    = @ボタン_サムネイル + $len - 1
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
			$stage.object[@ボタン_サムネイル + $i].joypad_up = @ボタン_ソート_番号順 + $$get_my_uma_list_sort_type
		}
		
		// 最下段
		if( $len - $w <= $i )
		{
			$stage.object[@ボタン_サムネイル + $i].joypad_down  = @ボタン_戻る
		}
	}
}

//---------------------------------------------------------------------------
// 選択しているタブに対応したデータベース最大数を取得する
//---------------------------------------------------------------------------
command $$get_db_max : int
{
	if( $tab_index == <TAB_UMA> )
	{
		return ($$get_db_uma_max)
	}
	elseif( $tab_index == <TAB_ITEM> )
	{
		return ($$get_db_item_max)
	}
}

//---------------------------------------------------------------------------
// 選択しているタブに対応した図鑑フラグを取得する
//---------------------------------------------------------------------------
command $$get_library_flag(property $id) : int
{
	if( $tab_index == <TAB_UMA> )
	{
		return ($$get_uma_library_flag($id))
	}
	elseif( $tab_index == <TAB_ITEM> )
	{
		return ($$get_item_library_flag($id))
	}
}

//---------------------------------------------------------------------------
// 選択しているタブに対応した図鑑フラグを設定する
//---------------------------------------------------------------------------
command $$set_library_flag(property $id, property $flag)
{
	if( $tab_index == <TAB_UMA> )
	{
		$$set_uma_library_flag($id, $flag)
	}
	elseif( $tab_index == <TAB_ITEM> )
	{
		$$set_item_library_flag($id, $flag)
	}
}

//---------------------------------------------------------------------------
// ＵＭＡ詳細オブジェクトを作成する
//---------------------------------------------------------------------------
command $$create_uma_info_object(property $obj : object)
{
	property $i
	property $uma_id
	
	// 選択しているＵＭＡのＩＤを取得する
	$uma_id = $$get_uma_libray($select_index)
	
	// 背景
	$obj.create("__mng_ur_library_uma_info_bg", 1, 0, 115)
	$obj.layer = 1
	$obj.child.resize(11)
	
	// 図鑑番号
	$obj.child[0].create_number(__mng_ur_library_no, 1, 585, 104)
	$obj.child[0].set_number_param(2, 1, 0, 0, 0, -4)
	
	// 名前
	$obj.child[1].create("__mng_ur_library_uma_info_name", 1, 542, 137, $uma_id - 1)
	
	// レアリティ
	$obj.child[2].disp = 1
	$obj.child[2].child.resize(<UMA_RARITY_MAX>)
	for( $i = 0, $i < <UMA_RARITY_MAX>, $i += 1 )
	{
		$obj.child[2].child[$i].create("__mng_ur_library_uma_info_rarity", 1, 690 + 40 * $i, 211)
	}
	
	// 走行タイプ
	$obj.child[3].create_number("__mng_ur_library_uma_run_type", 1, 691, 273)
	
	// 地形適性
	$obj.child[4].create("__mng_ur_library_uma_info_ground_type", 1, 720, 328)
	$obj.child[5].create("__mng_ur_library_uma_info_ground_type", 1, 838, 328)
	$obj.child[6].create("__mng_ur_library_uma_info_ground_type", 1, 936, 328)
	
	// スキルアイコン
	$$create_uma_skill_icon($obj.child[7], 690, 381, $uma_id)
	
	// スキル詳細
	$obj.child[8].create_string("", 1, 704, 452)
	$obj.child[8].set_string_param(18, 0, 4, 15, 50, 0, 0)
	
	// 詳細
	$obj.child[9].create_string("", 1, 540, 569)
	$obj.child[9].set_string_param(18, 0, 0, 26, 50, 0, 0)
	
	// カード（※updateで作成する）
	// $obj.child[10]
	
	// オブジェクトを更新する
	$$update_uma_info_object($obj)
}

//---------------------------------------------------------------------------
// ＵＭＡ詳細オブジェクトを更新する
//---------------------------------------------------------------------------
command $$update_uma_info_object(property $obj : object)
{
	property $i
	property $uma_id
	property $skill_id
	
	// 選択しているＵＭＡの情報を取得する
	$uma_id = $$get_uma_libray($select_index)
	$skill_id = $$get_db_uma_skill_id($uma_id)
	
	// 図鑑番号
	$obj.child[0].set_number($uma_id)
	
	// 名前
	$obj.child[1].patno = $uma_id - 1
	
	// レアリティ
	for( $i = 0, $i < <UMA_RARITY_MAX>, $i += 1 )
	{
		$obj.child[2].child[$i].disp = 1
		
		if( $$get_db_uma_rarity($uma_id) - 1 < $i ) {
			$obj.child[2].child[$i].disp = 0
		}
	}
	
	// 走行タイプ
	$obj.child[3].patno = $$get_db_uma_run_type($uma_id) - 1
	
	// 地形適性
	$obj.child[4].patno = $$get_db_uma_turf_type($uma_id) - 1
	$obj.child[5].patno = $$get_db_uma_dirt_type($uma_id) - 1
	$obj.child[6].patno = $$get_db_uma_surface_type($uma_id) - 1
	
	// スキルアイコン
	$$update_uma_skill_icon($obj.child[7], $uma_id)
	
	// スキル詳細
	$obj.child[8].set_string($$get_db_skill_details($skill_id))
	
	// 詳細
	$obj.child[9].set_string($$get_db_uma_details($uma_id))
	
	// カード
	$$create_uma_card_object($obj.child[10], $uma_id, 33, 100)
	$obj.child[10].set_scale(735, 735)
	
	// 図鑑フラグが取得済みの場合は閲覧済みにする
	if( $$get_library_flag($uma_id) == <URACE_LIBRARY_FLAG_GET> ) {
		$$set_library_flag($uma_id, <URACE_LIBRARY_FLAG_READ>)
	}
}
