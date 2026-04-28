//===========================================================================
//!
//!    @file     extra_settings.ss
//!    @brief    鑑賞シーンの設定
//!
//!    @author   Copyright (C)2023- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

#z00

//---------------------------------------------------------------------------
// エクストラが解放されているかどうか
//---------------------------------------------------------------------------
command $$open_extra : int
{
	if( @朱比華ルートクリア || @愛乃ルートクリア || @陽彩ルートクリア || @小詠ルートクリア || @六花ルートクリア || 
		@文弥ルートクリア || @塁ルートクリア || @つづらルートクリア || @千春ルートクリア || @健ルートクリア ) {
		return (1)
	}
	
	return (0)
}

//---------------------------------------------------------------------------
// チャプター選択が解放されているかどうか
//---------------------------------------------------------------------------
command $$open_chapter_select : int
{
	/* チャプター選択の機能は使用しないので何もしない */
	return (0)
}

//---------------------------------------------------------------------------
// コンフィグのキャラクター音量設定で使用するキャラクターリストを設定する
//---------------------------------------------------------------------------
command $$set_config_charakoe_list
{
	$$set_config_charakoe(001, 01)		// スピカ
	$$set_config_charakoe(002, 02)		// 愛乃
	$$set_config_charakoe(003, 03)		// 陽彩
	$$set_config_charakoe(004, 04)		// 小詠
	$$set_config_charakoe(005, 05)		// 六花
	$$set_config_charakoe(006, 07)		// 文弥
	$$set_config_charakoe(007, 08)		// 塁
	$$set_config_charakoe(008, 09)		// つづら
	$$set_config_charakoe(009, 12)		// 玖琉未
	$$set_config_charakoe(010, 06)		// 広美
	$$set_config_charakoe(011, 10)		// 千春
	$$set_config_charakoe(012, 11)		// 健
	$$set_config_charakoe(013, 14)		// 誠
	$$set_config_charakoe(014, 16)		// 湊
	$$set_config_charakoe(015, 13)		// ツミレ
	$$set_config_charakoe(016, 17)		// 絵美
	$$set_config_charakoe(017, 15)		// 穂乃夏
	$$set_config_charakoe(018, 18)		// 麦
	$$set_config_charakoe(019, 50)		// その他・男
	$$set_config_charakoe(020, 51)		// その他・女
	
	$$set_config_charakoe_sample_voice(001, 000800376)		// KOE(000800376,001)【スピカ】「何を驚くの。窯がないとピザは焼けないわ」R
	$$set_config_charakoe_sample_voice(001, 000401831)		// KOE(000401831,001)【スピカ】「でもこの風、泣いているわ」
	$$set_config_charakoe_sample_voice(001, 000200231)		// KOE(000200231,001)【スピカ／少女】「やぶからに、何を言ったっ」R
	$$set_config_charakoe_sample_voice(002, 000300882)		// KOE(000300882,002)【愛乃】「総羽愛乃（ふさばあいの）です」R
	$$set_config_charakoe_sample_voice(002, 000300900)		// KOE(000300900,002)【愛乃】「じゃあ、どうぞ。ぶい」R
	$$set_config_charakoe_sample_voice(002, 000300771)		// KOE(000300771,002)【愛乃／？？？】「そこにいると危ないですよー」R
	$$set_config_charakoe_sample_voice(003, 000401238)		// KOE(000401238,003)【陽彩／淡雪】「フルネームは淡雪陽彩」R
	$$set_config_charakoe_sample_voice(003, 000401012)		// KOE(000401012,003)【陽彩／女の子】「星空よりも……月よりも……美しい……」R
	$$set_config_charakoe_sample_voice(003, 000401084)		// KOE(000401084,003)【陽彩／女の子】「え？　淡雪の顔、美しすぎ！？」R
	$$set_config_charakoe_sample_voice(004, 000301356)		// KOE(000301356,004)【小詠】「小詠は、白渡小詠といいます」R
	$$set_config_charakoe_sample_voice(004, 000301212)		// KOE(000301212,004)【小詠／？？？】「ぴ、よ、ぴ、よ、とーどけるよっ」R
	$$set_config_charakoe_sample_voice(004, 000900235)		// KOE(000900235,004)【小詠】「ぴぃーーーーーー！」R
	$$set_config_charakoe_sample_voice(005, 000200761)		// KOE(000200761,005)【六花】「速川六花です」R
	$$set_config_charakoe_sample_voice(005, 000201858)		// KOE(000201858,005)【六花】「今日もお疲れ様です」R
	$$set_config_charakoe_sample_voice(005, 000301661)		// KOE(000301661,005)【六花】「過ちさえも貫く兄さん、ご立派です！」R
	$$set_config_charakoe_sample_voice(006, 000200986)		// KOE(000200986,007)【文弥／女の人】「あ、こちらこそ自己紹介が遅れてごめんね。尾道文弥よ」R
	$$set_config_charakoe_sample_voice(006, 000201036)		// KOE(000201036,007)【文弥】「あはは、いいのいいの。こちらこそ早とちりしてごめんね」R
	$$set_config_charakoe_sample_voice(006, 000201008)		// KOE(000201008,007)【文弥】「つまりそれぞれ別々に、がんばって。がんばるってのはほら、この町も、もっと子供が増えるといいなって。あはは。私ってば何を。アハハ」R
	$$set_config_charakoe_sample_voice(007, 000201256)		// KOE(000201256,008)【塁／女の子】「そう。私こそ、次期敦澤家当主、敦澤塁であーる」R
	$$set_config_charakoe_sample_voice(007, 000201344)		// KOE(000201344,008)【塁】「おお！　話をきいてくれるのか！」R
	$$set_config_charakoe_sample_voice(007, 000501130)		// KOE(000501130,008)【塁】「皆の安全は私が守る。この敦澤塁の名にかけてっ」R
	$$set_config_charakoe_sample_voice(008, 000201547)		// KOE(000201547,009)【つづら／文学少女】「私はつづら。華押つづら」R
	$$set_config_charakoe_sample_voice(008, 000201595)		// KOE(000201595,009)【つづら】「ありがとうございます。メニューを持ってまいります」R
	$$set_config_charakoe_sample_voice(008, 000201487)		// KOE(000201487,009)【つづら／文学少女】「完全無欠。余すところなく頭が悪い……それが私」R
	$$set_config_charakoe_sample_voice(009, 000400424)		// KOE(000400424,012)【玖琉未／？？？】「さすらいの恐竜ハンター、鉱玖琉未です！」R
	$$set_config_charakoe_sample_voice(009, 000400441)		// KOE(000400441,012)【玖琉未】「私たちは、深い絆で繋がれたソウルメイトですよ？」R
	$$set_config_charakoe_sample_voice(009, 000400457)		// KOE(000400457,012)【玖琉未】「また逃げられました！　待ってくださーーーい！！」R
	$$set_config_charakoe_sample_voice(010, 000200756)		// KOE(000200756,006)【広美／お婆さん】「ここは真澄町の動物病院。私は院長をしている花山広美だよ」R
	$$set_config_charakoe_sample_voice(010, 000300284)		// KOE(000300284,006)【広美】「いいよ。町に若い働き手が一時的にでも増えるのはありがたい」R
	$$set_config_charakoe_sample_voice(010, 000300133)		// KOE(000300133,006)【広美】「こんなピザが毎朝食べられるなら、結婚してもいいぐらいか？」R
	$$set_config_charakoe_sample_voice(011, 000300610)		// KOE(000300610,010)【河瀬】「さぁな。いつしか、よばれるようになったのさ。ジョー……走り屋のジョーってな」R
	$$set_config_charakoe_sample_voice(011, 000300596)		// KOE(000300596,010)【河瀬／男の人】「珍しいじゃねーか。この町で俺以外の走り屋を見かけるとは」R
	$$set_config_charakoe_sample_voice(011, 000300678)		// KOE(000300678,010)【河瀬】「いやああほおおおおおおお！」R
	$$set_config_charakoe_sample_voice(012, 000300350)		// KOE(000300350,011)【小森】「まあ、健さんとでも呼んでくれ」R
	$$set_config_charakoe_sample_voice(012, 000300330)		// KOE(000300330,011)【小森／男の人】「今を生きろ、少年」R
	$$set_config_charakoe_sample_voice(012, 000300370)		// KOE(000300370,011)【小森】「ほらよ。こいつは出会いの印だ。お前さんをイメージしてみたぜ」R
	$$set_config_charakoe_sample_voice(013, 000400138)		// KOE(000400138,014)【町長】「私、この町の町長をしている敦澤誠と申します」R
	$$set_config_charakoe_sample_voice(013, 000400786)		// KOE(000400786,014)【町長】「ほっほっほ。ピザにハチミツはよく合いますね」R
	$$set_config_charakoe_sample_voice(013, 000400148)		// KOE(000400148,014)【町長】「ほーーーーー！」R	;>>歓喜の咆吼
	$$set_config_charakoe_sample_voice(014, 000500921)		// KOE(000500921,016)【愛乃のおとーさん】「だいたい俺は人の寝息を聞きながら寝られないタチなんだ。デリケートにできてるんだよ」R
	$$set_config_charakoe_sample_voice(014, 000500917)		// KOE(000500917,016)【愛乃のおとーさん】「俺のような奴がいってもあれこれ、面倒をかけるだけだろう」R
	$$set_config_charakoe_sample_voice(014, 000500937)		// KOE(000500937,016)【愛乃のおとーさん】「はぁ、はぁ……。避難所で雑魚寝なんて、想像するだけで……」R
	$$set_config_charakoe_sample_voice(015, 000500276)		// KOE(000500276,013)【ツミレ】「オロロォ～」R
	$$set_config_charakoe_sample_voice(015, 000500133)		// KOE(000500133,013)【ツミレ／？？？】「オロロォーーーーー！」R
	$$set_config_charakoe_sample_voice(015, 306100099)		// KOE(306100099,013)【ツミレ】「オロロ～……」R
	$$set_config_charakoe_sample_voice(016, 400300116)		// KOE(400300116,017)【絵美】「ありがとうございます。では、お言葉に甘えて」R
	$$set_config_charakoe_sample_voice(016, 400300064)		// KOE(400300064,017)【絵美】「やっぱりこっち、かな」R
	$$set_config_charakoe_sample_voice(016, 400300154)		// KOE(400300154,017)【絵美】「……変態なのかしら」R
	$$set_config_charakoe_sample_voice(017, 603300312)		// KOE(603300312,015)【穂乃夏】「うーうー」R
	$$set_config_charakoe_sample_voice(017, 603701883)		// KOE(603701883,015)【穂乃夏】「がおー」R
	$$set_config_charakoe_sample_voice(017, 603300318)		// KOE(603300318,015)【穂乃夏】「ま、ま」R
	$$set_config_charakoe_sample_voice(018, 999100004)		// 不意に、強い風が吹いた。R
	$$set_config_charakoe_sample_voice(018, 611100532)		// KOE(611100532,018)【麦＿収録】「美味い……」R
	$$set_config_charakoe_sample_voice(018, 611100413)		// KOE(611100413,018)【麦＿収録】「いきなり乗れと言われても」R
	$$set_config_charakoe_sample_voice(019, 000300527)		// KOE(000300527,050)【燃料職人】「ガソリンはいりやーーーす！」R
	$$set_config_charakoe_sample_voice(019, 000501214)		// KOE(000501214,050)【陸呂】「サクセスマートにコロッケ買いに行こうぜ」R
	$$set_config_charakoe_sample_voice(019, 000400893)		// KOE(000400893,050)【池田さん】「やっぱり町長からびしっと言ってくれないと」R
	$$set_config_charakoe_sample_voice(020, 000900140)		// KOE(000900140,051)【灯莉】「おねーちゃん、おはよう」R
	$$set_config_charakoe_sample_voice(020, 000900255)		// KOE(000900255,051)【瑞希】「ここはわたしたちにまかせて、にげて！」R
	$$set_config_charakoe_sample_voice(020, 000301108)		// KOE(000301108,051)【祈祷ばーさん】「ほんじゃま、かー！！！」R
}

//---------------------------------------------------------------------------
// チャプター選択シーンで遷移するチャプターリストを設定する
//
// -  チャプターは最大３００個まで設定できます。
// -  チャプター画面の最大サムネイル数の指定と各サムネイル選択時の遷移先を設定する必要があります。
//
//---------------------------------------------------------------------------
command $$set_extra_chapter_list
{
	/* チャプター選択の機能は使用しないので何もしない */
}

//---------------------------------------------------------------------------
// イベントＣＧ鑑賞シーンで表示するイベントＣＧリストを設定する
//
// -  ＣＧは最大３００個まで設定できます。
// -  ＣＧ鑑賞画面の最大サムネイル数の指定と各サムネイル選択時の遷移先を設定する必要があります。
//
//---------------------------------------------------------------------------
command $$set_extra_cg_list
{
	// イベントＣＧ鑑賞シーンの最大サムネイル数を設定する
	$$set_extra_cg_thumb_max(16)
	
	//             ページ番号, サムネイル番号,  イベントＣＧファイル名
	
	// スピカ
	$$set_extra_cg(        01,             01,         CG_SP01)
	$$set_extra_cg(        01,             02,         CG_SP02)
	$$set_extra_cg(        01,             03,         CG_SP03)
	$$set_extra_cg(        01,             04,         CG_SP04)
	$$set_extra_cg(        01,             05,         CG_SP05)
	$$set_extra_cg(        01,             06,         CG_SP06)
	$$set_extra_cg(        01,             07,         CG_SP07)
	$$set_extra_cg(        01,             08,         CG_SP08)
	$$set_extra_cg(        01,             09,         CG_SP09)
	$$set_extra_cg(        01,             10,         CG_SP10)
	$$set_extra_cg(        01,             11,         CG_SP11)
	$$set_extra_cg(        01,             12,         CG_SP12)
	$$set_extra_cg(        01,             13,         CG_SP13)
	
	// 愛乃
	$$set_extra_cg(        02,             01,         CG_AI01)
	$$set_extra_cg(        02,             02,         CG_AI02)
	$$set_extra_cg(        02,             03,         CG_AI03)
	$$set_extra_cg(        02,             04,         CG_AI04)
	$$set_extra_cg(        02,             05,         CG_AI05)
	$$set_extra_cg(        02,             06,         CG_AI06)
	$$set_extra_cg(        02,             07,         CG_AI07)
	$$set_extra_cg(        02,             08,         CG_AI08)
	$$set_extra_cg(        02,             09,         CG_AI09)
	$$set_extra_cg(        02,             10,         CG_AI10)
	$$set_extra_cg(        02,             11,         CG_AI11)
	$$set_extra_cg(        02,             12,         CG_AI12)
	$$set_extra_cg(        02,             13,         CG_AI13)
	$$set_extra_cg(        02,             14,         CG_AI14)
	$$set_extra_cg(        02,             15,         CG_AI15)
	
	// 淡雪
	$$set_extra_cg(        03,             01,         CG_HI01)
	$$set_extra_cg(        03,             02,         CG_HI02)
	$$set_extra_cg(        03,             03,         CG_HI03)
	$$set_extra_cg(        03,             04,         CG_HI04)
	$$set_extra_cg(        03,             05,         CG_HI05)
	$$set_extra_cg(        03,             06,         CG_HI06)
	$$set_extra_cg(        03,             07,         CG_HI07)
	$$set_extra_cg(        03,             08,         CG_HI08)
	$$set_extra_cg(        03,             09,         CG_HI09)
	$$set_extra_cg(        03,             10,         CG_HI10)
	$$set_extra_cg(        03,             11,         CG_HI11)
	$$set_extra_cg(        03,             12,         CG_HI12)
	$$set_extra_cg(        03,             13,         CG_HI13)
	
	// 小詠
	$$set_extra_cg(        04,             01,         CG_KY01)
	$$set_extra_cg(        04,             02,         CG_KY02)
	$$set_extra_cg(        04,             03,         CG_KY03)
	$$set_extra_cg(        04,             04,         CG_KY04)
	$$set_extra_cg(        04,             05,         CG_KY05)
	$$set_extra_cg(        04,             06,         CG_KY06)
	$$set_extra_cg(        04,             07,         CG_KY07)
	$$set_extra_cg(        04,             08,         CG_KY08)
	$$set_extra_cg(        04,             09,         CG_KY09)
	$$set_extra_cg(        04,             10,         CG_KY10)
	$$set_extra_cg(        04,             11,         CG_KY11)
	$$set_extra_cg(        04,             12,         CG_KY12)
	$$set_extra_cg(        04,             13,         CG_KY13)
	
	// 六花
	$$set_extra_cg(        05,             01,         CG_RK05)
	$$set_extra_cg(        05,             02,         CG_RK08)
	$$set_extra_cg(        05,             03,         CG_RK01)
	$$set_extra_cg(        05,             04,         CG_RK13)
	$$set_extra_cg(        05,             05,         CG_RK14)
	$$set_extra_cg(        05,             06,         CG_RK02)
	$$set_extra_cg(        05,             07,         CG_RK03)
	$$set_extra_cg(        05,             08,         CG_RK04)
	$$set_extra_cg(        05,             09,         CG_RK06)
	$$set_extra_cg(        05,             10,         CG_RK09)
	$$set_extra_cg(        05,             11,         CG_RK07)
	$$set_extra_cg(        05,             12,         CG_RK10)
	$$set_extra_cg(        05,             13,         CG_RK12)
	
	// つづら
	$$set_extra_cg(        06,             01,         CG_TD01)
	$$set_extra_cg(        06,             02,         CG_TD02)
	$$set_extra_cg(        06,             03,         CG_TD03)
	
	// 文弥
	$$set_extra_cg(        07,             01,         CG_FM01)
	$$set_extra_cg(        07,             02,         CG_FM02)
	$$set_extra_cg(        07,             03,         CG_FM03)
	
	// 塁
	$$set_extra_cg(        08,             01,         CG_RI01)
	$$set_extra_cg(        08,             02,         CG_RI02)
	$$set_extra_cg(        08,             03,         CG_RI03)
	
	// 玖琉未
	$$set_extra_cg(        09,             01,         CG_KR01)
	$$set_extra_cg(        09,             02,         CG_KR02)
	$$set_extra_cg(        09,             03,         CG_KR03)
	
	// 千春
	$$set_extra_cg(        10,             01,         CG_CH01)
	$$set_extra_cg(        10,             02,         CG_CH02)
	$$set_extra_cg(        10,             03,         CG_CH03)
	
	// 健
	$$set_extra_cg(        11,             01,         CG_KN01)
	$$set_extra_cg(        11,             02,         CG_KN02)
	
	// 広美
	$$set_extra_cg(        12,             01,         CG_HR01)
	$$set_extra_cg(        12,             02,         CG_HR02)
	$$set_extra_cg(        12,             03,         CG_HR03)
	
	// グランド
	$$set_extra_cg(        13,             01,         CG_GE01)
	$$set_extra_cg(        13,             02,         CG_GE03)
	$$set_extra_cg(        13,             03,         CG_GE04)
	$$set_extra_cg(        13,             04,         CG_GE05)
	$$set_extra_cg(        13,             05,         CG_GE06)
	$$set_extra_cg(        13,             06,         CG_GE16)
	$$set_extra_cg(        13,             07,         CG_GE07)
	$$set_extra_cg(        13,             08,         CG_GE08)
	$$set_extra_cg(        13,             09,         CG_GE09)
	$$set_extra_cg(        13,             10,         CG_GE10)
	$$set_extra_cg(        13,             11,         CG_GE11)
	$$set_extra_cg(        13,             12,         CG_GE12)
	$$set_extra_cg(        13,             13,         CG_GE13)
	$$set_extra_cg(        13,             14,         CG_GE14)
	$$set_extra_cg(        13,             15,         CG_GE15)
}

//---------------------------------------------------------------------------
// サウンド鑑賞シーンで再生するＢＧＭリストを設定する
//
// -  デフォルトでＢＧＭは最大５０個まで設定できます。
// -  ５０個以上の登録が必要な場合は[_extra_sound.ss → <BGM_MAX>]の最大数を変更してください。
//
//---------------------------------------------------------------------------
command $$set_extra_music_list
{
	// ボタン番号, ＢＧＭ名
	$$set_extra_music(01, BGM01B)
	$$set_extra_music(02, BGM38)
	$$set_extra_music(03, BGM02)
	$$set_extra_music(04, BGM29)
	
	$$set_extra_music(05, BGM03)
	$$set_extra_music(06, BGM30)
	$$set_extra_music(07, BGM04)
	$$set_extra_music(08, BGM31)
	
	$$set_extra_music(09, BGM06)
	$$set_extra_music(10, BGM33)
	$$set_extra_music(11, BGM05)
	$$set_extra_music(12, BGM32)
	
	$$set_extra_music(13, BGM27)
	$$set_extra_music(14, BGM27B)
	$$set_extra_music(15, BGM07)
	$$set_extra_music(16, BGM08)
	
	$$set_extra_music(17, BGM09)
	$$set_extra_music(18, BGM10)
	$$set_extra_music(19, BGM25)
	$$set_extra_music(20, BGM26)
	
	$$set_extra_music(21, BGM42)
	$$set_extra_music(22, BGM40)
	$$set_extra_music(23, BGM35)
	$$set_extra_music(24, BGM21)
	
	$$set_extra_music(25, BGM21B)
	$$set_extra_music(26, BGM11)
	$$set_extra_music(27, BGM18A)
	$$set_extra_music(28, BGM18B)
	
	$$set_extra_music(29, BGM19)
	$$set_extra_music(30, BGM20)
	$$set_extra_music(31, BGM14)
	$$set_extra_music(32, BGM12)
	
	$$set_extra_music(33, BGM12B)
	$$set_extra_music(34, BGM13)
	$$set_extra_music(35, BGM41)
	$$set_extra_music(36, BGM23)
	
	$$set_extra_music(37, BGM15)
	$$set_extra_music(38, BGM16)
	$$set_extra_music(39, BGM36)
	$$set_extra_music(40, BGM28)
	
	$$set_extra_music(41, BGM17)
	$$set_extra_music(42, BGM22)
	$$set_extra_music(43, BGM24A)
	$$set_extra_music(44, BGM34)
	
	$$set_extra_music(45, BGM37)
	$$set_extra_music(46, BGM39)
	$$set_extra_music(47, BGM39B)
	$$set_extra_music(48, BGM45)
	
	$$set_extra_music(49, BGM45B)
	
	if( 0 ) {
		$$set_extra_music(50, BGM43A)
		$$set_extra_music(51, BGM43B)
		$$set_extra_music(52, BGM43C)
		
		$$set_extra_music(53, BGM43D)
		$$set_extra_music(54, BGM44)
		$$set_extra_music(55, BGM81)
		$$set_extra_music(56, BGM82)
		
		$$set_extra_music(57, BGM83)
		$$set_extra_music(58, BGM84)
		$$set_extra_music(59, BGM85)
		$$set_extra_music(60, BGM86)
		
		$$set_extra_music(61, BGM87)
	} else {
		$$set_extra_music(50, BGM81)
		$$set_extra_music(51, BGM82)
		$$set_extra_music(52, BGM83)
		
		$$set_extra_music(53, BGM84)
		$$set_extra_music(54, BGM85)
		$$set_extra_music(55, BGM86)
		$$set_extra_music(56, BGM87)
	}
}

//---------------------------------------------------------------------------
// 立ち絵鑑賞シーンで使用できるキャラクターを設定する
//
// -  登録できる各種最大数
// -  > 背景         - 200
// -  > キャラクター - 20
// -  > 服装         - 10    (キャラクターごと)
// -  > ポーズ       - 10    (キャラクターごと)
// -  > 表情         - 40    (表情パターンごと)
// -  > 表情パターン - 100   (すべてのキャラクター)
//
//---------------------------------------------------------------------------
command $$set_extra_character_list
{
	/*
	// 背景
	@立ち絵鑑賞_背景登録("bg001_01")
	@立ち絵鑑賞_背景登録("bg001_02")
	@立ち絵鑑賞_背景登録("bg001_03")
	
	// 立ち絵
	@立ち絵鑑賞_立ち絵登録("hz")
	@立ち絵鑑賞_立ち絵登録("kb")
	@立ち絵鑑賞_立ち絵登録("zz")
	
	// 服装
	@立ち絵鑑賞_服装登録("hz", 1, 2)				// 通常、スス
	@立ち絵鑑賞_服装登録("kb", 1, 2, 3)				// 通常、軍服、軍服＋マント
	@立ち絵鑑賞_服装登録("zz", 2, 1, 2, 1, 2, 1)
	
	// ポーズ
	@立ち絵鑑賞_ポーズ登録("hz", 11, 12)
	@立ち絵鑑賞_ポーズ登録("kb", 11, 12, 21, 22)
	@立ち絵鑑賞_ポーズ登録("zz", 12, 11, 12, 11, 12)
	
	// 表情
	// > 表情パターンを番号で設定し、その中に対応する表情を設定します。
	// > サンプルでは表情パターン１に灰桜の表情１～２１、表情パターン２に鴉羽の表情(正面)１～１７、表情パターン３に鴉羽の表情(斜め)１～１７を設定しています。
	// > g00で確認 > _extra_character_face_list_thumb01.g00 > thumb01は表情パターン１、thumb02は表情パターン２...と対応しています。
	// > psdで確認 > エクストラ立ち絵鑑賞画面_サマポケ.psd  > [表情/サムネイル]フォルダ内の各フォルダに表情パターンは対応しています。
	@立ち絵鑑賞_表情登録(1, "hz", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21)	// [表情パターン１]に[hz(灰桜)]の表情[1～21]を設定する
	@立ち絵鑑賞_表情登録(2, "hz", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17)					// [表情パターン２]に[hz(灰桜)]の表情[1～17]を設定する
	@立ち絵鑑賞_表情登録(3, "kb", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17)					// [表情パターン３]に[kb(鴉羽)]の表情[1～17]を設定する
	@立ち絵鑑賞_表情登録(4, "kb", 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17)					// [表情パターン４]に[kb(鴉羽)]の表情[1～17]を設定する
	@立ち絵鑑賞_表情登録(5, "zz", 16, 15, 14)																	// [表情パターン５]に[zz(灰桜複製)]の表情[16～14]を設定する
	@立ち絵鑑賞_表情登録(6, "zz", 16, 15, 14)																	// [表情パターン６]に[zz(灰桜複製)]の表情[16～14]を設定する
	
	// 表情パターン
	// 各表情パターンがどのようなときに表示されるかを設定します。
	// キャラ、服装、向き、腕差分の状態によって表示する表情パターンが変更できます。
	// 服装、向き、腕差分に[-1]を設定すると指定を無視します。例えば、下のような場合だと
	// @立ち絵鑑賞_表情パターン登録(1, "hz", -1, -1, -1)
	// [服装 = -1][向き = -1][腕差分 = -1]指定なので、灰桜が表示されたとき服装、向き、腕差分の状態にかかわらず表情パターン１が表示されます。
	// 表情パターンの設定がかぶっている場合は一番下にある表情パターンから優先されるので注意してください。
	
	//                          表情パターン, キャラ, 服装, 向き, 腕差分
	@立ち絵鑑賞_表情パターン登録(1,           "hz",   -1,   -1,   -1)		// [hz(灰桜)]が表示されたとき、服装、向き、腕差分がどれでも[表情パターン１]が表示
	@立ち絵鑑賞_表情パターン登録(2,           "hz",    2,   -1,   -1)		// [hz(灰桜)]が表示されたとき、[服装=2(すす)]の場合、[表情パターン２]が表示
	@立ち絵鑑賞_表情パターン登録(3,           "kb",   -1,   -1,   -1)		// [kb(鴉羽)]が表示されたとき、服装、向き、腕差分がどれでも[表情パターン３]が表示
	@立ち絵鑑賞_表情パターン登録(4,           "kb",   -1,    2,   -1)		// [kb(鴉羽)]が表示されたとき、[向き=2(斜め)]の場合、[表情パターン４]が表示
	@立ち絵鑑賞_表情パターン登録(5,           "zz",   -1,   -1,   -1)		// [zz(灰桜複製)]が表示されたとき、服装、向き、腕差分がどれでも[表情パターン５]が表示
	@立ち絵鑑賞_表情パターン登録(6,           "zz",    2,   -1,   -1)		// [zz(灰桜複製)]が表示されたとき、[服装=2(すす)]の場合、[表情パターン６]が表示
	
	// メッセージウィンドウ
	@立ち絵鑑賞_名前欄_位置登録(533, 772)						// 名前欄を表示する位置
	@立ち絵鑑賞_本文欄_位置登録(369, 851)						// 本文欄を表示する位置
	@立ち絵鑑賞_名前欄_最大文字数登録(10)						// 半角１０文字
	@立ち絵鑑賞_本文欄_最大文字数登録(32 * 3)					// 半角３２×３文字
	@立ち絵鑑賞_デフォルト名前欄登録("名前入力欄")				// 名前欄のデフォルトテキスト
	@立ち絵鑑賞_デフォルト本文欄登録("「テキスト入力欄です」")	// 本文欄のデフォルトテキスト
	@立ち絵鑑賞_名前欄_センタリング_オン						// 名前欄のテキストをセンタリングする
	
	// エディットボックス
	// 表示する座標(x), 座標(y), サイズ(x), サイズ(y), 文字サイズ
	@立ち絵鑑賞_エディットボックス登録(521, 673, 852, 32, 30)
	*/
}
