//===========================================================================
//!
//!    @file     ___mng_urace_grp_uma_tip.ss
//!    @brief    ＵＭＡレース／ＵＭＡチップアニメーション関数群
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     各ＵＭＡの待機／走り／ジャンプ／スタンのアニメーションを管理する
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// アニメーションステート
	#replace	<STATE_WAIT>		0		// 待機
	#replace	<STATE_MOVE>		1		// 走り
	#replace	<STATE_JUMP>		2		// ジャンプ
	#replace	<STATE_STUN>		3		// スタン
	
	// 各種／パラメータ
	#replace	f_state					f[0]	// ステート
	#replace	f_state_old				f[1]	// １フレーム前のステート
	#replace	f_anim_index			f[2]	// 現在表示中のコマ
	#replace	f_anim_loop_index		f[3]	// アニメーションループの最初のコマ
	#replace	f_anim_time				f[4]	// １コマのアニメーションにかける時間
	#replace	f_anim_time_next		f[5]	// １コマのアニメーションにかける時間（次のコマから）
	#replace	f_anim_time_wait		f[6]	// １コマのアニメーションにかける時間／待機
	#replace	f_anim_time_move		f[7]	// １コマのアニメーションにかける時間／走り
	#replace	f_anim_time_jump		f[8]	// １コマのアニメーションにかける時間／ジャンプ
	#replace	f_anim_time_stun		f[9]	// １コマのアニメーションにかける時間／スタン
	#replace	f_wait_anim_start		10		// 待機アニメーション／最初のコマ
	#replace	f_wait_anim_end			22		// 待機アニメーション／最後のコマ
	#replace	f_move_anim_start		23		// 走りアニメーション／最初のコマ
	#replace	f_move_anim_end			29		// 走りアニメーション／最後のコマ
	#replace	f_jump_anim_start		30		// ジャンプアニメーション／最初のコマ
	#replace	f_jump_anim_end			39		// ジャンプアニメーション／最後のコマ
	#replace	f_stun_anim_start		40		// スタンアニメーション／最初のコマ
	#replace	f_stun_anim_end			49		// スタンアニメーション／最後のコマ
	#replace	f_flag_max				50		// フラグ最大数
	
#inc_end

#z00

//---------------------------------------------------------------------------
// ＵＭＡチップを作成する
//---------------------------------------------------------------------------
command $$create_uma_tip_object(property $obj : object, property $uma_id, property $x, property $y)
{
	property $i
	
	// チップ画像を作成する
	$obj.create("__mng_ur_uma_tip" + math.tostr_zero($uma_id, 2), 1, $x, $y)
	$obj.set_center($obj.get_size_x / 2, $obj.get_size_y)
	$obj.f.resize(f_flag_max)
	
	// 各フラグデータの初期設定
	$obj.f_state_old = -1
	$obj.f_anim_time_wait = 130			// 待機アニメーションの１コマの時間
	$obj.f_anim_time_move = 100			// 走りアニメーションの１コマの時間
	$obj.f_anim_time_jump = 100			// ジャンプアニメーションの１コマの時間
	$obj.f_anim_time_stun = 100			// スタンアニメーションの１コマの時間
	
	// アニメーションデータの初期化
	for( $i = f_wait_anim_start, $i <= f_stun_anim_end, $i += 1 )
	{
		$obj.f[$i] = -1
	}
	
	// 各ＵＭＡごとのアニメーションを設定する
	switch( $uma_id ) {
		
	case(@ＵＭＡ_ケセランパセラン)
		$obj.f.sets(f_wait_anim_start, 0, 0, 1, 1, 2, 2, 3, 3)	// 待機
		$obj.f.sets(f_move_anim_start, 4, 5, 6)					// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_ツチノコ)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 1, 3)			// 待機
		$obj.f.sets(f_move_anim_start, 4, 5, 6)					// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_スカイフィッシュ)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 0, 6, 7)					// 走り
		$obj.f.sets(f_jump_anim_start, 3, 4, 5, 0)				// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_鎌鼬)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 2, 3)			// 待機
		$obj.f.sets(f_move_anim_start, 4, 5, 6)					// 走り
		$obj.f.sets(f_jump_anim_start, 7, 8, 8, 8)				// ジャンプ
		$obj.f.sets(f_stun_anim_start, 9, 9, 9)					// スタン
		
	case(@ＵＭＡ_ジャージー・デビル)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2, 2)			// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_河童)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_コロポックル)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 2, 2)			// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_ビッグフット)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 1, 2, 2, 2, 2, 2)	// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)					// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)						// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)						// スタン
		
	case(@ＵＭＡ_モスマン)
		$obj.f.sets(f_wait_anim_start, 0, 0, 0, 1, 2, 1, 2)		// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_グレイ・タイプ)
		$obj.f.sets(f_wait_anim_start, 0, 0, 1, 1, 1, 1, 2, 3, 2, 1, 1, 1)	// 待機
		$obj.f.sets(f_move_anim_start, 4, 5, 6, 7)							// 走り
		$obj.f.sets(f_jump_anim_start, 8, 8, 8)								// ジャンプ
		$obj.f.sets(f_stun_anim_start, 9, 9, 9)								// スタン
		
	case(@ＵＭＡ_チュパカブラ)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 1, 2, 3, 3)		// 待機
		$obj.f.sets(f_move_anim_start, 8, 5, 6, 7)				// 走り
		$obj.f.sets(f_jump_anim_start, 5, 5, 5)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 9, 9, 9)					// スタン
		
	case(@ＵＭＡ_ネッシー)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2)				// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_カーバンクル)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_ビバゴン)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2)				// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_オキナ)		// todo tipデータ後で直す
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 2, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 6, 7, 8)							// 走り
		$obj.f.sets(f_jump_anim_start, 3, 9, 10, 11)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 3, 4, 5, 11, 12, 12, 12, 12, 12)	// スタン
		
	case(@ＵＭＡ_ユニコーン)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2)				// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7, 5)				// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_モケーレ・ムベンベ)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 2, 2)			// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 4)				// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_ヤタガラス)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_イエティ)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 3, 3)			// 待機
		$obj.f.sets(f_move_anim_start, 4, 5, 6, 7)				// 走り
		$obj.f.sets(f_jump_anim_start, 8, 8, 8)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 9, 9, 9)					// スタン
		
	case(@ＵＭＡ_クラーケン)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 2, 2)			// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_ケツァルコアトルス)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_モンゴリアン・デスワーム)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2, 2)				// 待機
		$obj.f.sets(f_move_anim_start, 4, 6, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 3, 7, 7, 7)				// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_ペガサス)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2)				// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_ツミレ)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2)				// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_河瀬)
		$obj.f.sets(f_wait_anim_start, 0, 1, 0, 0)				// 待機
		$obj.f.sets(f_move_anim_start, 2, 3, 2, 3)				// 走り
		$obj.f.sets(f_jump_anim_start, 4, 5, 5, 6)				// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_小森)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2)				// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6, 7)				// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_東の風神・エウロス)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 9)					// スタン
		
	case(@ＵＭＡ_南の風神・ノトス)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	case(@ＵＭＡ_西の風神・ゼピュロス)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_北の風神・ボレアス)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 6, 6, 6)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 7, 7, 7)					// スタン
		
	case(@ＵＭＡ_メドゥーサ)
		$obj.f.sets(f_wait_anim_start, 0, 1, 2)					// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5)					// 走り
		$obj.f.sets(f_jump_anim_start, 4, 6, 6, 6)				// ジャンプ
		$obj.f.sets(f_stun_anim_start, 4, 7, 7, 7)				// スタン
		
	case(@ＵＭＡ_Ｔ－ＲＥＸ玖琉未)
		$obj.f.sets(f_wait_anim_start, 0, 1, 1, 2, 2, 2)		// 待機
		$obj.f.sets(f_move_anim_start, 3, 4, 5, 6)				// 走り
		$obj.f.sets(f_jump_anim_start, 7, 7, 7)					// ジャンプ
		$obj.f.sets(f_stun_anim_start, 8, 8, 8)					// スタン
		
	}
	
	// 待機アニメーションを再生する
	$$play_uma_tip_wait_anim($obj)
	
	// フレームアクションを開始する
	$obj.frame_action.start(-1, "$$fa_update")
}

//---------------------------------------------------------------------------
// ＵＭＡチップを更新する
//---------------------------------------------------------------------------
command $$fa_update(property $fa : frameaction, property $obj : object)
{
	// ステートが変更された場合
	if( $obj.f_state != $obj.f_state_old )
	{
		// アニメーションのコマと時間を再設定する
		$obj.f_anim_index = $obj.f_anim_loop_index
		$obj.f_anim_time = $obj.f_anim_time_next
		
		// カウンタをリセットする
		$fa.counter.set(0)
		
		// ステートを保存する
		$obj.f_state_old = $obj.f_state
	}
	
	// コマを更新する時間になっていなければ終了する
	if( $fa.counter.get < $obj.f_anim_time ) {
		return
	}
	
	// コマを更新する
	$obj.f_anim_index += 1
	if( $obj.f[$obj.f_anim_index] == -1 ) {
		$obj.f_anim_index = $obj.f_anim_loop_index
	}
	
	$obj.patno = $obj.f[$obj.f_anim_index]
	
	// 次のアニメーションにかける時間を反映する
	$obj.f_anim_time = $obj.f_anim_time_next
	
	// カウンタをリセットする
	$fa.counter.set(0)
}

//---------------------------------------------------------------------------
// ＵＭＡチップアニメーションを再生する
//---------------------------------------------------------------------------
command $$play_uma_tip_wait_anim(property $obj : object) { $$play_uma_tip_anim($obj, <STATE_WAIT>) }
command $$play_uma_tip_move_anim(property $obj : object)  { $$play_uma_tip_anim($obj, <STATE_MOVE>)  }
command $$play_uma_tip_jump_anim(property $obj : object) { $$play_uma_tip_anim($obj, <STATE_JUMP>) }
command $$play_uma_tip_stun_anim(property $obj : object) { $$play_uma_tip_anim($obj, <STATE_STUN>) }

command $$play_uma_tip_anim(property $obj : object, property $state)
{
	// 各ステートごとにアニメーションの設定を反映する
	switch( $state ) {
	case(<STATE_WAIT>)	$obj.f_anim_loop_index = f_wait_anim_start
						$obj.f_anim_time_next = $obj.f_anim_time_wait
	case(<STATE_MOVE>)	$obj.f_anim_loop_index = f_move_anim_start
						$obj.f_anim_time_next = $obj.f_anim_time_move
	case(<STATE_JUMP>)	$obj.f_anim_loop_index = f_jump_anim_start
						$obj.f_anim_time_next = $obj.f_anim_time_jump
	case(<STATE_STUN>)	$obj.f_anim_loop_index = f_stun_anim_start
						$obj.f_anim_time_next = $obj.f_anim_time_stun
	}
	
	// ステートを変更する
	$obj.f_state = $state
}

//---------------------------------------------------------------------------
// チップアニメーションにかける時間を設定する
//---------------------------------------------------------------------------
command $$set_uma_tip_move_anim_time(property $obj : object, property $time)  { $$set_uma_tip_anim_time($obj, <STATE_MOVE>, $time)  }

command $$set_uma_tip_anim_time(property $obj : object, property $state, property $time)
{
	// 各ステートごとにアニメーション時間の設定を設定する
	switch( $state ) {
	case(<STATE_WAIT>)	$obj.f_anim_time_wait = $time
	case(<STATE_MOVE>)	$obj.f_anim_time_move = $time
	case(<STATE_JUMP>)	$obj.f_anim_time_jump = $time
	case(<STATE_STUN>)	$obj.f_anim_time_stun = $time
	}
	
	// 次のアニメーションにかける時間を設定する
	$obj.f_anim_time_next = $time
}
