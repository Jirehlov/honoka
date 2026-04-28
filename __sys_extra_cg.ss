//===========================================================================
//!
//!    @file     __sys_extra_cg.ss
//!    @brief    イベントＣＧ鑑賞シーン(システム側)
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     アプリケーションに依存しないシステムの共通処理
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start

	#property	$select_btn		// 選択したボタン
	
	#property	$tab			// 現在のタブ
	#property	$page			// 現在のページ
	#property	$tab_max		// 最大タブ
	#property	$page_max		// 最大ページ
	#property	$thumb_max		// ページ中の最大サムネイル数
	#property	$thumb_type		// サムネイルタイプ(0=通常ボタン／1=オーバーレイボタン)
	
	#property	$cg_list : strlist		// イベントＣＧリスト

#inc_end

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーン開始
//---------------------------------------------------------------------------
#z00

$$create_extra_cg_scene_object(excall.back)							// シーンオブジェクトを作成する
$$set_scene_data(excall.back)										// シーンデータを設定する
$$update_all_thumb_diff
$$update_scene_object(excall.back)									// シーンオブジェクトの描画を更新する
$$auto_joypad_navigation(@ボタン_エクストラ_ＣＧ_閉じる,			// 自動でジョイパッド時のボタン遷移先を設定する
						 @ボタン_エクストラ_ＣＧ_サムネイル最大)
$$set_extra_cg_joypad_navigation(excall.back)						// 手動でジョイパッド時のボタン遷移先を設定する
$$set_joypad_focus_button_default(excall.back)						// ジョイパッドで最初に選択されているボタンをデフォルトで設定する
$$show_extra_cg_scene_object(excall.back)							// シーンオブジェクトを表示する

// 入力制御を開始する
$$input_start(excall.front, <OBJBTN_GROUP_NO_EXCALL>)

while( 1 )
{
	// 入力制御を更新する
	$select_btn = $$input_update(excall.front, <OBJBTN_GROUP_NO_EXCALL>)
	
	// キャンセルは閉じるボタンとして処理する
	if( $select_btn == -1 )
	{
		se.play_by_se_no(<BUTTON_SE_CANCEL>)
		$select_btn = @ボタン_エクストラ_ＣＧ_閉じる
	}
	
	// マウスホイールでページ送りをする
	if    ( mouse.wheel < 0 ) { $$prev_page }
	elseif( mouse.wheel > 0 ) { $$next_page }
	
	// Ｌ１／Ｒ１ボタンでページ送りをする
	// ※ Ｌ１／Ｒ１両方押している処理しないようにする ※
	if( joypad.key[<JOYPAD_L1>].is_down == 0 || joypad.key[<JOYPAD_R1>].is_down == 0 )
	{
		if    ( $$joypad_on_down(<JOYPAD_L1>) ) { $$prev_page }
		elseif( $$joypad_on_down(<JOYPAD_R1>) ) { $$next_page }
	}
	
	// タブボタンが押された場合は現在のタブを更新する
	if( @ボタン_エクストラ_ＣＧ_タブ <= $select_btn && $select_btn <= @ボタン_エクストラ_ＣＧ_タブ最大 )
	{
		$tab = $select_btn - @ボタン_エクストラ_ＣＧ_タブ					// 現在のタブを設定する
		$$rebuild_scene_object(@エクストラ_ＣＧ_描画更新_タブ切り替え)		// シーンオブジェクトを再構築する
	}
	
	// ページボタンが押された場合は現在のページを更新する
	if( @ボタン_エクストラ_ＣＧ_ページ <= $select_btn && $select_btn <= @ボタン_エクストラ_ＣＧ_ページ最大 )
	{
		$page = $select_btn - @ボタン_エクストラ_ＣＧ_ページ				// 現在のページを設定する
		$$rebuild_scene_object(@エクストラ_ＣＧ_描画更新_ページ切り替え)	// シーンオブジェクトを再構築する
	}
	
	// サムネイルボタンが押された場合
	if( @ボタン_エクストラ_ＣＧ_サムネイル <= $select_btn && $select_btn <= @ボタン_エクストラ_ＣＧ_サムネイル最大 )
	{
		// ＣＧ差分表示処理へ
		farcall(__sys_extra_cg_diff, 0, ($page * $thumb_max) + $select_btn - @ボタン_エクストラ_ＣＧ_サムネイル)
		
		// 入力制御を再開始する
		$$input_start(excall.front, <OBJBTN_GROUP_NO_EXCALL>)
		$select_btn = -2
	}
	
	// トラックリストボタンが押されている場合
	if( $select_btn == @ボタン_エクストラ_サウンド_トラックリスト )
	{
		farcall("__sys_extra_sound")
		
		$$set_joypad_focus_button(@ボタン_エクストラ_サウンド_トラックリスト)
		$$rebuild_scene_object(@エクストラ_ＣＧ_描画更新_タブ切り替え)		// シーンオブジェクトを再構築する
	}
	
	// 
	if( $thumb_type == 1 ) {
		$$update_overlay_thumb_button(excall.front)
	}
	
	if( $select_btn == @ボタン_エクストラ_ヘッダー_レコード ) {
		
		// 全てのシステムオブジェクトのワイプコピーフラグをオフにする
		$$off_system_front_wipe_copy_all
		
		jump(__sys_record)
	}
	if( $select_btn == @ボタン_エクストラ_ヘッダー_タイトル )
	{
		break
	}
	
	// アプリケーション側の処理を更新する
	$$update_extra_cg_scene_object(excall.front, $select_btn)
	
	// 閉じるボタンが押された場合は処理を終了する
	if( $select_btn == @ボタン_エクストラ_ＣＧ_閉じる ) {
		break
	}
	
	// 何も押していないときは画面の更新のみ
	if( $select_btn == -2 )
	{
		input.next		// 入力の更新
		disp			// 画面の更新
	}
}

// エクストラのモード選択シーンが有効の場合はモード選択オブジェクトを構成する
if( __EXTRA_MODE_SELECT_SCENE == 1 ) {
	$$build_extra_mode_select_scene(excall.back)
}

$$off_system_front_wipe_copy_all			// 全てのシステムオブジェクトのワイプコピーフラグをオフにする
$$hide_extra_cg_scene_object(excall.front)	// シーンオブジェクトを非表示にする

return


//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンの最大サムネイル数を設定する
//---------------------------------------------------------------------------
command $$set_extra_cg_thumb_max(property $max)
{
	$thumb_max = $max
}

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンで表示するイベントＣＧを設定する
//---------------------------------------------------------------------------
command $$set_extra_cg(property $page_no, property $thumb_no, property $file : str)
{
	property $index
	property $tmp_page_max
	property $tmp_thumb_max
	
	$tmp_page_max = @ボタン_エクストラ_ＣＧ_ページ最大 - @ボタン_エクストラ_ＣＧ_ページ
	$tmp_thumb_max = @ボタン_エクストラ_ＣＧ_サムネイル最大 - @ボタン_エクストラ_ＣＧ_サムネイル
	
	// リストのサイズが設定されていない場合はサイズを確保する
	if( $cg_list.get_size == 0 ) {
		$cg_list.resize($tmp_page_max * $tmp_thumb_max)
	}
	
	$index = ($page_no - 1) * $thumb_max + ($thumb_no - 1)
	
	$cg_list[$index] = $file
}

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンで表示するイベントＣＧを取得する
//---------------------------------------------------------------------------
command $$get_extra_cg(property $cg_index) : str
{
	return ($cg_list[$cg_index])
}

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンで表示するイベントＣＧ数を取得する
//---------------------------------------------------------------------------
command $$get_extra_cg_cnt : int
{
	return ($cg_list.get_size)
}

//---------------------------------------------------------------------------
// イベントＣＧが閲覧済みかどうか
//---------------------------------------------------------------------------
command $$open_cg(property $cg_list_index) : int
{
    property $i
    property $filename : str
    property $diff_cnt
    
    if( $cg_list[$cg_list_index] == "" ) {
        return (0)
    }
    
    $diff_cnt = $$get_extra_cg_static_diff_cnt($cg_list_index)
    for( $i = 0, $i < $diff_cnt, $i += 1 )
    {
        $filename = $$get_extra_cg_static_diff_filename($cg_list_index, $i)
        
        if( $filename == "" ) {
            continue
        }
        
        if( cgtable.get_look_by_name($filename) == 1 )
        {
            return (1)
        }
    }
    
    return (0)
}

//---------------------------------------------------------------------------
// 現在のタブを取得する
//---------------------------------------------------------------------------
command $$get_extra_cg_tab_index : int
{
	return ($tab)
}

//---------------------------------------------------------------------------
// 現在のページを取得する
//---------------------------------------------------------------------------
command $$get_extra_cg_page_index : int
{
	return ($page)
}

//---------------------------------------------------------------------------
// 現在のページのサムネイル最大数を取得する
//---------------------------------------------------------------------------
command $$get_extra_cg_page_thumb_max : int
{
	property $i
	
	for( $i = 0, $i < @エクストラ_ＣＧ_サムネイル最大数, $i += 1 )
	{
		if( $cg_list[$page * $thumb_max + $i] == "" ) {
			break
		}
	}
	
	return ($i)
}

//---------------------------------------------------------------------------
// 現在の最大ページ数を設定する
//---------------------------------------------------------------------------
command $$set_extra_cg_page_max(property $max)
{
	$page_max = $max
}

//---------------------------------------------------------------------------
// シーンデータを設定する
//---------------------------------------------------------------------------
command $$set_scene_data(property $stage : stage)
{
	property $tmp
	
	// タブ最大数を取得する
	$tab_max = $$get_system_disp_object_max($stage, @ボタン_エクストラ_ＣＧ_タブ, @ボタン_エクストラ_ＣＧ_タブ最大) - @ボタン_エクストラ_ＣＧ_タブ
	
	// ページ最大数を取得する
	$page_max = $$get_system_disp_object_max($stage, @ボタン_エクストラ_ＣＧ_ページ, @ボタン_エクストラ_ＣＧ_ページ最大) - @ボタン_エクストラ_ＣＧ_ページ
	
	// サムネイル最大数を取得する
	$tmp = $thumb_max
	$thumb_max = $$get_system_disp_object_max($stage, @ボタン_エクストラ_ＣＧ_サムネイル, @ボタン_エクストラ_ＣＧ_サムネイル最大) - @ボタン_エクストラ_ＣＧ_サムネイル
	
	// エラーチェック
	if( $tmp != $thumb_max ) {
		@dm("_extra_cg.ss → $$set_scene_data\n$$set_extra_cg_listで定義されたサムネイル最大数とシステム画面出力で出力したサムネイル最大数に違いがあります。\n$$set_extra_cg_list : " + math.tostr($tmp) + "\nシステム画面出力 : " + math.tostr($thumb_max) + "\nイベントＣＧ表示が正しい動作をしない可能性があります。")
	}
}

//---------------------------------------------------------------------------
// 前のページへ戻る
//---------------------------------------------------------------------------
command $$prev_page
{
	$page -= 1
	if( $page < 0 ) {
		$page = $page_max - 1
	}
	
	// システム決定音を再生する
	se.play_by_se_no(<BUTTON_SE_CHANGE_PAGE>)
	
	// シーンオブジェクトを再構築する
	$$rebuild_scene_object(@エクストラ_ＣＧ_描画更新_ページ切り替え)
}

//---------------------------------------------------------------------------
// 次のページへ進む
//---------------------------------------------------------------------------
command $$next_page
{
	$page += 1
	if( $page >= $page_max ) {
		$page = 0
	}
	
	// システム決定音を再生する
	se.play_by_se_no(<BUTTON_SE_CHANGE_PAGE>)
	
	// シーンオブジェクトを再構築する
	$$rebuild_scene_object(@エクストラ_ＣＧ_描画更新_ページ切り替え)
}

//---------------------------------------------------------------------------
// シーンオブジェクトの描画を更新する
//---------------------------------------------------------------------------
command $$update_scene_object(property $stage : stage)
{
	property $i
	property $len
	property $filename : str
	
	// タブボタンの更新
	for( $i = 0, $i < $tab_max, $i += 1 )
	{
		// 現在のタブであれば選択状態／なければ通常状態にする
		if( $tab == $i ) {
			$stage.object[@ボタン_エクストラ_ＣＧ_タブ + $i].set_button_state_select
		} else {
			$stage.object[@ボタン_エクストラ_ＣＧ_タブ + $i].set_button_state_normal
		}
	}
	
	// ページボタンの更新
	for( $i = 0, $i < $page_max, $i += 1 )
	{
		// 現在のページであれば選択状態／なければ通常状態にする
		if( $page == $i ) {
			$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].set_button_state_select
		} else {
			$stage.object[@ボタン_エクストラ_ＣＧ_ページ + $i].set_button_state_normal
		}
	}
	
	// サムネイルボタンの更新
	for( $i = 0, $i < $thumb_max, $i += 1 )
	{
		if( $thumb_type == 0 )
		{
			// サムネイルのファイル名を取得
			$filename = $stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].get_file_name
			$filename = $filename.left_len($filename.len - 2)
			
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].change_file($filename + math.tostr_zero($page * $thumb_max + ($i + 1), 2))
		}
		else
		{
			// サムネイルのファイル名を取得
			$len = $cg_list[$page * $thumb_max + $i].len
			$filename = $stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[0].get_file_name
			$filename = $filename.left_len($filename.len - $len) + $cg_list[$page * $thumb_max + $i]
			
			if( $$exists_g00($filename) && $cg_list[$page * $thumb_max + $i] != "" )
			{
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].disp = 1
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[0].change_file($filename)
			}
			else
			{
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].disp = 0
			}
			
			if( $$open_cg($page * $thumb_max + $i) )
			{
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[0].disp = 1
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].disp = 1
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[2].tr = 0
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].set_button_state_normal
			}
			else
			{
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[0].disp = 0
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].disp = 0
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[2].tr = 0
				$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].set_button_state_disable
			}
		}
	}
}

//---------------------------------------------------------------------------
// シーンオブジェクトを再構築する
//---------------------------------------------------------------------------
command $$rebuild_scene_object(property $redraw_type)
{
	// すべてのシーンオブジェクトを裏画面にコピーする
	$$copy_all_scene_object_to_back
	
	$$update_all_thumb_diff
	
	// 裏画面のシーンオブジェクトを更新する
	$$update_scene_object(excall.back)
	
	// 裏画面のジョイパッドで選択中のボタンの描画を更新する
	$$update_joypad_focus_button(excall.back)
	
	// アプリケーション側の処理を更新する
	$$redraw_extra_cg_scene_object(excall.back, $redraw_type)
	
	// 入力制御を再開始する
	$$input_start(excall.front, <OBJBTN_GROUP_NO_EXCALL>)
}

//---------------------------------------------------------------------------
// オーバーレイサムネイルボタンを作成する
//---------------------------------------------------------------------------
command $$create_overlay_thumb_button(property $stage : stage, property $filename : str, property $x, property $y, property $offset_x, property $offset_y, property $w, property $h)
{
	property $i
	property $len
	
	$len = $w * $h
	for( $i = 0, $i < $len, $i += 1 )
	{
		$$create_ui_button($stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i], $filename, $x + $offset_x * ($i % $w), $y + $offset_y * ($i / $w), @ボタン_エクストラ_ＣＧ_サムネイル + $i, <OBJBTN_GROUP_NO_EXCALL>, 4)
		
		$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child.resize(3)
		$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[0].create("_extra_cg_thumb_" + $cg_list[0], 1, __EXTRA_CG_THUMB_OFFSET_X, __EXTRA_CG_THUMB_OFFSET_Y)
		$$create_thumb_diff($stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1], $page * $thumb_max + $i)
		$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[2].create("_extra_cg_thumb_overlay", 1, __EXTRA_CG_THUMB_OFFSET_X, __EXTRA_CG_THUMB_OFFSET_Y)
	}
	
	// サムネイルボタンをオーバーレイタイプとして扱う
	$thumb_type = 1
	
	$$update_all_thumb_diff
}

command $$update_overlay_thumb_button(property $stage : stage)
{
	property $i
	property $len
	property $button_no
	
	for( $i = 0, $i < @エクストラ_ＣＧ_サムネイル最大数, $i += 1 )
	{
		if( $stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].f.get_size == 0 ) {
			continue
		}
		
		$button_no = $stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].get_button_no
		
		if( (syscom.check_joypad_mode == 0 && ($$get_hit_btn == $button_no || $$get_pushed_btn == $button_no) || syscom.check_joypad_mode == 1 && $$get_joypad_focus_button == $button_no) == 0 )
		{
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[2].tr = 0
		}
		else
		{
			$stage.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[2].tr = 128
		}
	}
}


command $$create_thumb_diff(property $obj : object, property $thumb_index)
{
	$obj.disp = 1
	$obj.child.resize(3)
	$obj.child[0].create(_extra_cg_diff_bg, 1, 204, 119)
	
	$obj.child[1].create_number(_extra_cg_diff_number, 1, 172, 120)
	$obj.child[1].set_number_param(2, 0, 0, 0, 0, 0)
	$obj.child[1].set_number($$get_extra_cg_diff_cnt($page * $thumb_max + $thumb_index, 0))
	$obj.child[2].create_number(_extra_cg_diff_number, 1, 218, 120)
	$obj.child[2].set_number_param(2, 0, 0, 0, 0, 0)
	$obj.child[2].set_number($$get_extra_cg_diff_cnt($page * $thumb_max + $thumb_index, 1))
}

command $$update_all_thumb_diff
{
	property $i
	property $len
	property $button_no
	
	for( $i = 0, $i < @エクストラ_ＣＧ_サムネイル最大数, $i += 1 )
	{
		if( excall.back.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].f.get_size == 0 ) {
			continue
		}
		
		excall.back.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].child[1].create_number(_extra_cg_diff_number, 1, 172, 120)
		excall.back.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].child[1].set_number_param(2, 0, 0, 0, 0, 0)
		excall.back.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].child[1].set_number($$get_extra_cg_diff_cnt($page * $thumb_max + $i, 0))
		excall.back.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].child[2].create_number(_extra_cg_diff_number, 1, 218, 120)
		excall.back.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].child[2].set_number_param(2, 0, 0, 0, 0, 0)
		excall.back.object[@ボタン_エクストラ_ＣＧ_サムネイル + $i].child[1].child[2].set_number($$get_extra_cg_diff_cnt($page * $thumb_max + $i, 1))
	}
}

//---------------------------------------------------------------------------
// イベントＣＧの達成率を作成する
//---------------------------------------------------------------------------
command $$create_extra_cg_complete_number(property $obj : object, property $filename : str, property $x, property $y)
{
	$$create_ui_number_image($obj, $filename, $x, $y)
	
	$obj.set_number_param(3, 0, 0, 0, 0, 0)
	$obj.set_number(cgtable.get_look_percent)
}

//---------------------------------------------------------------------------
// ジョイパッドで最初に選択されているボタンをデフォルトで設定する
//---------------------------------------------------------------------------
command $$set_joypad_focus_button_default(property $stage : stage)
{
	// 先頭のサムネイルボタンをデフォルトにする
	$$set_joypad_focus_button(@ボタン_エクストラ_ＣＧ_サムネイル)
}
