//===========================================================================
//!
//!    @file     ___mng_urace_util.ss
//!    @brief    ＵＭＡ汎用関数群
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#z00

//---------------------------------------------------------------------------
// ＵＭＡパラメータのランクを取得する
//---------------------------------------------------------------------------
command $$uma_param_to_rank(property $value) : int
{
	//---------------------------------------
	// パラメータは0-99の間、ランクはF-SSの間
	// F  0-14
	// E  15-29
	// D  30-44
	// C  45-59
	// B  60-74
	// A  75-89
	// S  90-99
	// SS 100
	//---------------------------------------
	property $rank
	
	if( $value <= 14 )		{ $rank = 0 }
	elseif( $value <= 29 )	{ $rank = 1 }
	elseif( $value <= 44 )	{ $rank = 2 }
	elseif( $value <= 59 )	{ $rank = 3 }
	elseif( $value <= 74 )	{ $rank = 4 }
	elseif( $value <= 89 )	{ $rank = 5 }
	elseif( $value <= 99 )	{ $rank = 6 }
	else					{ $rank = 7 }
	
	return ($rank)
}


command $$get_urace_param_rarity(property $value) : int
{
	property $rarity
	
	if( $value <= 25 ) {
		$rarity = 1
	} elseif( $value <= 50 ) {
		$rarity = 2
	} elseif( $value <= 75 ) {
		$rarity = 3
	} else {
		$rarity = 4
	}
	
	return ($rarity)
}

command $$has_entry_race_uma : int
{
	property $i
	
	for( $i = 0, $i < $$get_my_uma_num, $i += 1 )
	{
		return (1)
	}
	
	return (0)
}
