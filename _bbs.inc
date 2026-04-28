//===========================================================================
//!
//!    @file     _bbs.inc
//!    @brief    掲示板定義
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     掲示板システムの制御
//!
//===========================================================================

// 時間帯
#replace	@午前				1
#replace	@午後				2

// 依頼にかける時間
#replace	@依頼時間_半日		0			// 午前に実行しても午後に行動可能
#replace	@依頼時間_一日		1			// 午前に実行すると午後の行動はできなくなる

// 依頼者
#replace	@依頼者_スピカ		1
#replace	@依頼者_愛乃		2
#replace	@依頼者_陽彩		3
#replace	@依頼者_小詠		4
#replace	@依頼者_六花		5
#replace	@依頼者_文弥		6
#replace	@依頼者_塁			7
#replace	@依頼者_つづら		8
#replace	@依頼者_千春		9
#replace	@依頼者_健			10
#replace	@依頼者_玖琉未		11
#replace	@依頼者_町民１		12
#replace	@依頼者_町民２		13
#replace	@依頼者_町民３		14
#replace	@依頼者_町民４		15
#replace	@依頼者_町民５		16
#replace	@依頼者_町民６		17
#replace	@依頼者_町民７		18
#replace	@依頼者_町民８		19
#replace	@依頼者_町民９		20
#replace	@依頼者_ＵＭＡ		21
#replace	@依頼者_ヘビヘビ	22

// 依頼書表示位置
// -----------
// 1|2|3|4|5
// -+-+-+-+-+
// 6|7|8|9|10
// -----------
#replace	@依頼書_表示位置１		0
#replace	@依頼書_表示位置２		1
#replace	@依頼書_表示位置３		2
#replace	@依頼書_表示位置４		3
#replace	@依頼書_表示位置５		4
#replace	@依頼書_表示位置６		5
#replace	@依頼書_表示位置７		6
#replace	@依頼書_表示位置８		7
#replace	@依頼書_表示位置９		8
#replace	@依頼書_表示位置１０	9
#define		@依頼書_表示最大		10


// 依頼書の設定
#macro	@依頼書表示(@thumbnail, @info_image, @pos, @character, @time, @request_file, @request_label, @board_file(""), @board_label(0))
	$$set_bbs_request_data(@thumbnail, @info_image, @pos, @character, @time, @request_file, @request_label, @board_file, @board_label)

// 掲示板データ初期化
#macro	@掲示板初期化
	@依頼にかける時間 = @依頼時間_半日
	$$init_bbs_data

// 掲示板表示
#macro	@掲示板表示		farcall(_bbs)

#command $$init_bbs_data														// 掲示板データ初期化
#command $$set_bbs_request_data(str, str, int, int, int, str, int, str, int)	// 掲示板の依頼書データを設定する
