//===========================================================================
//!
//!    @file     ___mng_hhp_sound.ss
//!    @brief   ヘビヘビパニックサウンド管理
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#inc_start
	
	#property $now_ch
	
#inc_end


#z00

//---------------------------------------------------------------------------
// 使用していない効果音チャンネルを取得する
//---------------------------------------------------------------------------
command $$get_empty_pcm_ch(property $min, property $max) : int
{
	property $ch
	
	$ch = $now_ch + $min
	
	$now_ch += 1
	if( $now_ch > $max - $min ) {
		$now_ch = 0
	}
	
	if( $ch < $min ) {
		$ch = $min
	}
	if( $max < $ch ) {
		$ch = $max
	}
	
	return ($ch)
}

//---------------------------------------------------------------------------
// ボイスを再生する
//---------------------------------------------------------------------------
command $$play_hhp_voice(property $chara_id, property $voice_type)
{
	// キャラＩＤが-1の場合はサポートキャラからランダムで選択する
	if( $chara_id == -1 )
	{
		$chara_id = $$get_hhp_skill_id_from_index(math.rand(0, $$get_hhp_skill_count - 1))
	}
	
	switch( $voice_type ) {
		
	case(<HHP_VOICE_TYPE_SUPPORT_SELECT>)	// サポート選択画面
		
		switch( $chara_id ) {
		case(<HHP_CHARA_ID_SP>)		exkoe(000800217,001)
		case(<HHP_CHARA_ID_AI>)		exkoe(000500780,002)
		case(<HHP_CHARA_ID_HI>)		exkoe(000900158,003)
		case(<HHP_CHARA_ID_KY>)		exkoe(000500521,004)
		case(<HHP_CHARA_ID_RK>)		exkoe(000501251,005)
		}
		
	case(<HHP_VOICE_TYPE_REWARDS_SELECT>)	// 報酬選択
		
		switch( $chara_id ) {
		case(<HHP_CHARA_ID_SP>)		exkoe(000800217,001)
		case(<HHP_CHARA_ID_AI>)		exkoe(000500780,002)
		case(<HHP_CHARA_ID_HI>)		exkoe(000900158,003)
		case(<HHP_CHARA_ID_KY>)		exkoe(000500521,004)
		case(<HHP_CHARA_ID_RK>)		exkoe(000501251,005)
		}
		
	case(<HHP_VOICE_TYPE_USE_SKILL>)		// 奥義使用
		
		switch( $chara_id ) {
		case(<HHP_CHARA_ID_SP>)		exkoe(000800217,001)
		case(<HHP_CHARA_ID_AI>)		exkoe(000500780,002)
		case(<HHP_CHARA_ID_HI>)		exkoe(000900158,003)
		case(<HHP_CHARA_ID_KY>)		exkoe(000500521,004)
		case(<HHP_CHARA_ID_RK>)		exkoe(000501251,005)
		}
		
	case(<HHP_VOICE_TYPE_RESULT>)			// リザルト
		
		switch( $chara_id ) {
		case(<HHP_CHARA_ID_SP>)		exkoe(000800217,001)
		case(<HHP_CHARA_ID_AI>)		exkoe(000500780,002)
		case(<HHP_CHARA_ID_HI>)		exkoe(000900158,003)
		case(<HHP_CHARA_ID_KY>)		exkoe(000500521,004)
		case(<HHP_CHARA_ID_RK>)		exkoe(000501251,005)
		}
	}
}
