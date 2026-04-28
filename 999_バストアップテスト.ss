//■■■■■■■■■■■■■■■■■■■■■■■■■■■■
#inc_start
//	#property	$bs_chr	: str
//	#property	$bs_pro	: str
//	#property	$bs_face_max

	#macro	@bs_test(@bs_name, @bs_face_max, @bs_muki(1), @bs_pose_max(1), @dress(1))
			k[0] = $$get_bs_size
			$$bs_test(k[0] + @bs_name, @bs_face_max, @bs_muki, @bs_pose_max, @dress)

#inc_end


//バストアップテスト、確認用シーン
#Z00
	set_title("バストアップテスト")
	@シーン開始


#select_00
	@bg(bg006_08,99)

	 @選択肢 = selbtn(1,
		 "■スピカ_正面"
		,"■スピカ_ななめ"
		,"■愛乃_正面"
		,"■愛乃_ななめ"
		,"■陽彩_正面"
		,"■陽彩_ななめ"
		,"■小詠_正面"

		,"■小詠_ななめ"
		,"■小詠_うつむき"
		,"■六花_正面"
		,"■六花_ななめ"
		,"■文弥"
		,"■塁"
		,"【次へ＞】"
		)@選択肢終了
	@シーン開始	//共通宣言
	switch(@選択){
				//	@bs_test(@bs_name, @bs_face_max, @bs_muki(1), @bs_pose_max(1))
		case(00)
		
			@選択肢 = selbtn("制服", "制服ジャケット", "私服", "私服ジャケット", "サロペ", "サロペジャケット", "アフターワンピ", "アフターパジャマ", "マタニティ")@選択肢終了
			switch( @選択 ) {
			case(0)		@スピカ制服
			case(1)		@スピカ制服ジャケット
			case(2)		@スピカ私服
			case(3)		@スピカ私服ジャケット
			case(4)		@スピカサロペ
			case(5)		@スピカサロペジャケット
			case(6)		@スピカアフターワンピ
			case(7)		@スピカアフターパジャマ	
			case(8)		@スピカマタニティ
			}
			
		
			@bs_test("_sp", 24, 01, 04, @選択)	//スピカ
		
		case(01)
		
			@選択肢 = selbtn("制服", "制服ジャケット", "私服", "私服ジャケット", "サロペ", "サロペジャケット", "アフターワンピ", "アフターパジャマ", "セーラー")@選択肢終了
			switch( @選択 ) {
			case(0)		@スピカ制服
			case(1)		@スピカ制服ジャケット
			case(2)		@スピカ私服
			case(3)		@スピカ私服ジャケット
			case(4)		@スピカサロペ
			case(5)		@スピカサロペジャケット
			case(6)		@スピカアフターワンピ
			case(7)		@スピカアフターパジャマ	
			case(8)		@スピカセーラー服
			}
			
			@bs_test("_sp", 20, 02, 04, @選択)	//
		
		case(02)
		
			@選択肢 = selbtn("制服", "制服ヘルメット", "ジャケット", "ジャケットヘルメット", "私服","愛乃ワカメ")@選択肢終了
			switch( @選択 ) {
			case(0)		@愛乃制服
			case(1)		@愛乃制服ヘルメット
			case(2)		@愛乃ジャケット
			case(3)		@愛乃ジャケットヘルメット
			case(4)		@愛乃私服
			case(5)		@愛乃ワカメ
			}
		
			@bs_test("_ai", 20, 01, 03, @選択)	//愛乃
		case(03)
			
			@選択肢 = selbtn("制服", "制服ヘルメット", "ジャケット", "ジャケットヘルメット", "私服","愛乃ワカメ")@選択肢終了
			switch( @選択 ) {
			case(0)		@愛乃制服
			case(1)		@愛乃制服ヘルメット
			case(2)		@愛乃ジャケット
			case(3)		@愛乃ジャケットヘルメット
			case(4)		@愛乃私服
			case(5)		@愛乃ワカメ
			}
		
			@bs_test("_ai", 20, 02, 02, @選択)	//
		
		case(04)
		
			@選択肢 = selbtn("制服", "私服", "水着")@選択肢終了
			switch( @選択 ) {
			case(0)		@陽彩制服
			case(1)		@陽彩私服
			case(2)		@陽彩水着
			}
		
			@bs_test("_hi", 16, 01, 03, @選択)	//陽彩
		case(05)
		
			@選択肢 = selbtn("制服", "私服", "水着")@選択肢終了
			switch( @選択 ) {
			case(0)		@陽彩制服
			case(1)		@陽彩私服
			case(2)		@陽彩水着
			}
		
			@bs_test("_hi", 17, 02, 03, @選択)	//
		
		case(06)
		
			@選択肢 = selbtn("制服", "制服帽子なし", "制服カバンなし", "制服帽子・カバンなし", "私服", "ペンキ")@選択肢終了
			switch( @選択 ) {
			case(0)		@小詠制服
			case(1)		@小詠制服帽子なし	
			case(2)		@小詠制服カバンなし
			case(3)		@小詠制服帽子・カバンなし
			case(4)		@小詠私服
			case(5)		@小詠ペンキ
			}
		
			@bs_test("_ky", 25, 01, 03, @選択)	//小詠
		
		case(07)
		
			@選択肢 = selbtn("制服", "制服帽子なし", "制服カバンなし", "制服帽子・カバンなし", "私服")@選択肢終了
			switch( @選択 ) {
			case(0)		@小詠制服
			case(1)		@小詠制服帽子なし	
			case(2)		@小詠制服カバンなし
			case(3)		@小詠制服帽子・カバンなし
			case(4)		@小詠私服
			}
		
			@bs_test("_ky", 25, 02, 01, @選択)	//
		
		case(08)
		
			@選択肢 = selbtn("制服")@選択肢終了
			switch( @選択 ) {
			case(0)		@小詠制服
			}
		
			@小詠制服
		
			@bs_test("_ky", 1, 03, 04, @選択)	//
		
		case(09)
		
			@選択肢 = selbtn("制服", "制服帽子・ポーチなし", "制服帽子なし", "私服１", "私服１帽子・ポーチなし", "私服１帽子なし", "私服２", "パジャマ")@選択肢終了
			switch( @選択 ) {
			case(0)		@六花制服
			case(1)		@六花制服帽子・ポーチなし
			case(2)		@六花制服帽子なし
			case(3)		@六花私服１
			case(4)		@六花私服１帽子・ポーチなし
			case(5)		@六花私服１帽子なし
			case(6)		@六花私服２
			case(7)		@六花パジャマ
			}
		
			@bs_test("_rk", 18, 01, 04, @選択)	//六花
		
		case(10)
		
			@選択肢 = selbtn("制服", "制服帽子・ポーチなし", "制服帽子なし", "私服１", "私服１帽子・ポーチなし", "私服１帽子なし", "私服２")@選択肢終了
			switch( @選択 ) {
			case(0)		@六花制服
			case(1)		@六花制服帽子・ポーチなし
			case(2)		@六花制服帽子なし
			case(3)		@六花私服１
			case(4)		@六花私服１帽子・ポーチなし
			case(5)		@六花私服１帽子なし
			case(6)		@六花私服２
			}
		
			@bs_test("_rk", 15, 02, 03, @選択)	//
		
		case(11)	@bs_test("_fm", 14, 01, 03, @選択)	//文弥
		case(12)
			
			@選択肢 = selbtn("制服", "大人")@選択肢終了
			switch( @選択 ) {
			case(0)		@塁制服
			case(1)		@塁大人
			}
			
			@bs_test("_ri", 17, 01, 03, @選択)	//塁
			
		case(13)	goto #select_01
	}
	close
	goto #select_00

#select_01
	@bg(bg006_08)
	 @選択肢 = selbtn(1,
		 "【＜前へ】"
		,"■つづら"
		,"■千春"
		,"■健"
		,"■広美"
		,"■玖琉未"
		,"■麦"
		,"■湊"
		,"■誠"
		,"■つみれ"
		,"■つみれ鍋"
		,"■絵美"
		,"■穂乃夏"
		,"【次へ＞】"
		)@選択肢終了
	@シーン開始	//共通宣言
	switch(@選択){
		case(00)	goto #select_00
		
		case(01)
		
			@選択肢 = selbtn("制服", "水着", "私服", "エプロン", "制服（眼鏡なし）", "水着（眼鏡なし）", "私服（眼鏡なし）", "エプロン（眼鏡なし）")@選択肢終了
			switch( @選択 ) {
			case(0)		@つづら制服
			case(1)		@つづら水着
			case(2)		@つづら私服
			case(3)		@つづら私服エプロン
			case(4)		@つづら制服眼鏡なし
			case(5)		@つづら水着眼鏡なし
			case(6)		@つづら私服眼鏡なし
			case(7)		@つづら私服エプロン眼鏡なし
			}
		
		@bs_test("_td", 16, 01, 04, @選択)	//つづら
		
		case(02)
		
			@選択肢 = selbtn("私服", "私服メット", "私服メット閉", "法被", "法被メット", "法被メット閉", "お面")@選択肢終了
			switch( @選択 ) {
			case(0)		@千春私服
			case(1)		@千春私服メット
			case(2)		@千春私服メット閉
			case(3)		@千春法被
			case(4)		@千春法被メット
			case(5)		@千春法被メット閉
			case(6)		@お面
			}
		
			@bs_test("_ch", 18, 01, 03, @選択)	//千春
		
		case(03)	@bs_test("_kn", 20, 01, 04, @選択)	//健
		
		case(04)
		
			@選択肢 = selbtn("白衣", "私服", "私服聴診器", "白衣モモンガ", "私服モモンガ", "私服モモンガ聴診器",
						"白衣（眼鏡なし）", "私服（眼鏡なし）", "私服聴診器（眼鏡なし）", "白衣モモンガ（眼鏡なし）", "私服モモンガ（眼鏡なし）", "私服モモンガ聴診器（眼鏡なし）")@選択肢終了
			switch( @選択 ) {
			case(0)		@広美白衣
			case(1)		@広美私服
			case(2)		@広美私服聴診器
			case(3)		@広美白衣モモンガ
			case(4)		@広美私服モモンガ
			case(5)		@広美私服モモンガ聴診器
			case(6)		@広美白衣眼鏡なし
			case(7)		@広美私服眼鏡なし
			case(8)		@広美私服聴診器眼鏡なし
			case(9)		@広美白衣モモンガ眼鏡なし
			case(10)	@広美私服モモンガ眼鏡なし
			case(11)	@広美私服モモンガ聴診器眼鏡なし
			}
		
			@bs_test("_hr", 23, 01, 03, @選択)	//広美
		
		case(05)
		
			@選択肢 = selbtn("私服", "私服腰巻なし", "ティラノ")@選択肢終了
			switch( @選択 ) {
			case(0)		@玖琉未私服
			case(1)		@玖琉未私服腰巻なし
			case(2)		@玖琉未ティラノ
			}
		
			@bs_test("_kr", 17, 01, 03, @選択)	//玖琉未
		
		case(06)	@bs_test("_mg",  1, 01, 01, @選択)	//麦
		case(07)	@bs_test("_mn", 21, 01, 02, @選択)	//湊
		case(08)
		
			@選択肢 = selbtn("私服", "肌着")@選択肢終了
			switch( @選択 ) {
			case(0)		@誠私服
			case(1)		@誠肌着
			}
		
			@bs_test("_mk", 16, 01, 02, @選択)	//誠
		
		case(09)
		
			@選択肢 = selbtn("吹き出しあり", "吹き出しなし")@選択肢終了
			switch( @選択 ) {
			case(0)		@ツミレ通常
			case(1)		@ツミレ吹き出しなし
			}
		
			@bs_test("_tm", 23, 01, 03, @選択)	//ツミレ
		
		case(10)
		
			@選択肢 = selbtn("吹き出しあり", "吹き出しなし")@選択肢終了
			switch( @選択 ) {
			case(0)		@ツミレ通常
			case(1)		@ツミレ吹き出しなし
			}
		
			@bs_test("_tm", 01, 02, 01, @選択)	//ツミレ
		
		case(11)	@bs_test("_em", 12, 01, 02, @選択)	//絵美
		case(12)
		
			@選択肢 = selbtn("穂乃夏私服", "穂乃夏私服ジャケット", "穂乃夏制服")@選択肢終了
			switch( @選択 ) {
			case(0)		@穂乃夏私服
			case(1)		@穂乃夏私服ジャケット
			case(2)		@穂乃夏制服
			}
		
			@bs_test("_hn", 25, 01, 04, @選択)	//穂乃夏
		case(13)	goto #select_02
	}
	close
	goto #select_01

#select_02
	@bg(bg006_08)
	 @選択肢 = selbtn(1,
		 "【＜前へ】"
		,"■ジェット"
		,"■熊の着ぐるみ"
		,"■"
//		,"【次へ＞】"
		)@選択肢終了
	@シーン開始	//共通宣言
	switch(@選択){
		case(00)	goto #select_01
		
		case(01)	@bs_test("_jt", 01, 01, 08, 01)	//ジェット
		
		case(02)
		
			@選択肢 = selbtn("ボードなし", "ボード美","ボードNOTクマ","麦の恋人","ボード髙梨")@選択肢終了
			switch( @選択 ) {
			case(0)		@熊の着ぐるみボードなし
			case(1)		@熊の着ぐるみボード美
			case(2)		@熊の着ぐるみボードNOTクマ
			case(3)		@熊の着ぐるみボード麦の恋人
			case(4)		@熊の着ぐるみボード無地	
			}
		
			@bs_test("_km", 03, 01, 02, @選択)	//熊の着ぐるみ
			
		case(03)
		
			@選択肢 = selbtn( "セーラー")@選択肢終了
			switch( @選択 ) {
			case(0)		@スピカ制服
			}
		
			@bs_test("_sp", 24, 3, 01, @選択)	//スピカセーラー
			
//		case(12)	goto #select_01
	}
	close
	goto #select_02

return

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■
command	$$bs_test(
	property $bs_name		: str,	//キャラ名　bs1等の指定もＯＫ
	property $bs_face_max	: int,	//表情最大数
	property $bs_muki		: int,	//向き　1 or 2
	property $bs_pose_max	: int,	//ポーズ差分	
	property $dress	: int			//服装差分	
){
	property $bs_chr : str
	property $bs_prm : str
	property $bs_dsp : str

	$dress+=1
	
	back.object[100].create($bs_name + math.tostr($bs_muki) + "_face001")
	$bs_face_max = back.object[100].get_pat_cnt
	back.object[100].init
	
	L[01] = 00
	$bs_chr =  $bs_name + math.tostr( $bs_muki )	// bs1_sp1
	//表情差分の最大値ぶんループ
	for(L[00] = 1 , L[00] <= $bs_face_max , L[00] += 1){

;		L[01] = $$loop_inc(1,L[01],$bs_pose_max)	//ポーズ差分番号をループ
		for(l[3]=1,l[3]<=$bs_pose_max,l[3]+=1)
		{
			//------------------
			// スキップリスト
			// スピカ正面のパジャマ
			if( $bs_name.right(2) == "sp" && $bs_muki == 1 && $dress == 8 && l[3]==4 ) {
				continue
			}
			
			// スピカ正面のマタニティ
			if( $bs_name.right(2) == "sp" && $bs_muki == 1 && $dress == 9 && (l[3]==2 || l[3]==3 || l[3]==4) ) {
				continue
			}
			
			// スピカ斜めのポーズ３
			if( $bs_name.right(2) == "sp" && $bs_muki == 2 && l[3]==3 ) {
				continue
			}
			// スピカ斜めワンピーズのポーズ２
			if( $bs_name.right(2) == "sp" && $bs_muki == 2 && $dress == 7 && (l[3]==2 || l[3]==3) ) {
				continue
			}
			// スピカ斜めパジャマのピザ
			if( $bs_name.right(2) == "sp" && $bs_muki == 2 && $dress == 8 && (l[3]==2 || l[3]==3 || l[3]==4) ) {
				continue
			}
			// 小詠正面制服_カバンなし
			if( $bs_name.right(2) == "ky" && $bs_muki == 1 && $dress == 3 && l[3]==3 ) {
				continue
			}
			// 小詠正面制服_カバンなし
			if( $bs_name.right(2) == "ky" && $bs_muki == 1 && $dress == 4 && l[3]==3 ) {
				continue
			}
			// 小詠正面ペンキ
			if( $bs_name.right(2) == "ky" && $bs_muki == 1 && $dress == 6 && (l[3]==2 || l[3]==3) ) {
				continue
			}
			// 広美メガネなし腕２
			if( $bs_name.right(2) == "hr" && $bs_muki == 1 && $$get_bs_overlay_face_type("hr") != <NONE> && l[3]==2 ) {
				continue
			}
			//------------------
			
			$bs_prm = $bs_chr + math.tostr( L[03] ) + "_" + math.tostr_zero( L[00] ,2)	//表情番号作成
			
			@bs( $bs_prm )
			$bs_dsp = $bs_prm + "　（" + math.tostr_zero( L[00] ,2 ) + "／" + math.tostr_zero($bs_face_max,2) + "）"
			print($bs_dsp)
			R
		}
	}

	return
}

//■■■■■■■■■■■■■■■■■■■■■■■■■■■■
//　木本の定番マクロ
//	戻り値＝$$loop_inc(最小値,対象フラグ,最大値)
command	$$loop_inc(property $min : int, property $flag : int, property $max : int):int
{
	$flag+=1
	if(($flag > $max)||($flag < $min)){ $flag=$min }
	return($flag)	//戻り値引渡し
}



command $$get_bs_size : str
{
	script.set_font_shadow(0)
	@選択肢マーカー
	l[0] = selbtn("bs1", "bs2", "bs3")@選択肢終了
	switch( l[0] ) {
	case(0)		return("bs1")
	case(1)		return("bs2")
	case(2)		return("bs3")
	}
}
