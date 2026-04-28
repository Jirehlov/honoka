//===========================================================================
//! (スクリプト中のキャラクター名, 服装番号)で服装の制御ができます。
//! 服装番号は立ち絵素材で指定した服装番号に連動します。
//! 立ち絵素材のレイヤー名が[■11制服]であれば服装番号は１番、
//! 立ち絵素材のレイヤー名が[■21私服]であれば服装番号は２番になります。
//===========================================================================

#define		@スピカセーラー服				$$set_bs_dress_type("sp", 0)		$$set_bs_overlay_face_type("sp", "0x")		// 強制的に表示する
#define		@スピカ制服						$$set_bs_dress_type("sp", 1)
#define		@スピカ制服ジャケット			$$set_bs_dress_type("sp", 2)
#define		@スピカ私服						$$set_bs_dress_type("sp", 3)
#define		@スピカ私服ジャケット			$$set_bs_dress_type("sp", 4)
#define		@スピカサロペ					$$set_bs_dress_type("sp", 5)
#define		@スピカサロペジャケット			$$set_bs_dress_type("sp", 6)
#define		@スピカアフターワンピ			$$set_bs_dress_type("sp", 7)
#define		@スピカアフターパジャマ			$$set_bs_dress_type("sp", 8)
#define		@スピカマタニティ				$$set_bs_dress_type("sp", 9)

#define		@愛乃制服						$$set_bs_dress_type("ai", 1)
#define		@愛乃制服ヘルメット				$$set_bs_dress_type("ai", 2)
#define		@愛乃ジャケット					$$set_bs_dress_type("ai", 3)
#define		@愛乃ジャケットヘルメット		$$set_bs_dress_type("ai", 4)
#define		@愛乃私服						$$set_bs_dress_type("ai", 5)
#define		@愛乃ワカメ						$$set_bs_dress_type("ai", 6)		$$set_bs_overlay_face_type("ai", "6x")		// face06を強制的に表示する

#define		@陽彩制服						$$set_bs_dress_type("hi", 1)
#define		@陽彩私服						$$set_bs_dress_type("hi", 2)
#define		@陽彩水着						$$set_bs_dress_type("hi", 3)

#define		@小詠制服						$$set_bs_dress_type("ky", 1)
#define		@小詠制服帽子なし				$$set_bs_dress_type("ky", 2)
#define		@小詠制服カバンなし				$$set_bs_dress_type("ky", 3)
#define		@小詠制服帽子・カバンなし		$$set_bs_dress_type("ky", 4)
#define		@小詠私服						$$set_bs_dress_type("ky", 5)
#define		@小詠ペンキ						$$set_bs_dress_type("ky", 6)

#define		@六花制服						$$set_bs_dress_type("rk", 1)
#define		@六花制服帽子・ポーチなし		$$set_bs_dress_type("rk", 2)
#define		@六花制服帽子なし				$$set_bs_dress_type("rk", 3)
#define		@六花私服１						$$set_bs_dress_type("rk", 4)
#define		@六花私服１帽子・ポーチなし		$$set_bs_dress_type("rk", 5)
#define		@六花私服１帽子なし				$$set_bs_dress_type("rk", 6)
#define		@六花私服２						$$set_bs_dress_type("rk", 7)
#define		@六花パジャマ					$$set_bs_dress_type("rk", 8)
#define		@六花黒もや						$$set_bs_dress_type("rk", 9)

#define		@文弥私服						$$set_bs_dress_type("fm", 1)
#define		@文弥グランド私服				$$set_bs_dress_type("fm", 2)

#define		@塁制服							$$set_bs_dress_type("ri", 1)
#define		@塁大人							$$set_bs_dress_type("ri", 2)

#define		@つづら制服						$$set_bs_dress_type("td", 1)
#define		@つづら水着						$$set_bs_dress_type("td", 2)
#define		@つづら私服						$$set_bs_dress_type("td", 3)
#define		@つづら私服エプロン				$$set_bs_dress_type("td", 4)
#define		@つづら制服眼鏡なし				$$set_bs_dress_type("td", 1)		$$set_bs_overlay_face_type("td", "9x")		// face09を強制的に表示する
#define		@つづら水着眼鏡なし				$$set_bs_dress_type("td", 2)		$$set_bs_overlay_face_type("td", "9x")		// face09を強制的に表示する
#define		@つづら私服眼鏡なし				$$set_bs_dress_type("td", 3)		$$set_bs_overlay_face_type("td", "9x")		// face09を強制的に表示する
#define		@つづら私服エプロン眼鏡なし		$$set_bs_dress_type("td", 4)		$$set_bs_overlay_face_type("td", "9x")		// face09を強制的に表示する

#define		@千春私服						$$set_bs_dress_type("ch", 1)
#define		@千春私服メット					$$set_bs_dress_type("ch", 2)
#define		@千春私服メット閉				$$set_bs_dress_type("ch", 3)
#define		@千春法被						$$set_bs_dress_type("ch", 4)
#define		@千春法被メット					$$set_bs_dress_type("ch", 5)
#define		@千春法被メット閉				$$set_bs_dress_type("ch", 6)
#define		@お面							$$set_bs_dress_type("ch", 7)		$$set_bs_overlay_face_type("ch", "7x")		// face07を強制的に表示する

#define		@健私服							$$set_bs_dress_type("kn", 1)

#define		@広美白衣						$$set_bs_dress_type("hr", 1)
#define		@広美私服						$$set_bs_dress_type("hr", 2)
#define		@広美私服聴診器					$$set_bs_dress_type("hr", 3)
#define		@広美白衣モモンガ				$$set_bs_dress_type("hr", 4)
#define		@広美私服モモンガ				$$set_bs_dress_type("hr", 5)
#define		@広美私服モモンガ聴診器			$$set_bs_dress_type("hr", 6)
#define		@広美白衣眼鏡なし				$$set_bs_dress_type("hr", 1)		$$set_bs_overlay_face_type("hr", "9x")		$$set_bs_overlay_pose_disable("hr", "2")	// face09を強制的に表示する／腕差分2は使用禁止にする
#define		@広美私服眼鏡なし				$$set_bs_dress_type("hr", 2)		$$set_bs_overlay_face_type("hr", "9x")		$$set_bs_overlay_pose_disable("hr", "2")	// face09を強制的に表示する／腕差分2は使用禁止にする
#define		@広美私服聴診器眼鏡なし			$$set_bs_dress_type("hr", 3)		$$set_bs_overlay_face_type("hr", "9x")		$$set_bs_overlay_pose_disable("hr", "2")	// face09を強制的に表示する／腕差分2は使用禁止にする
#define		@広美白衣モモンガ眼鏡なし		$$set_bs_dress_type("hr", 4)		$$set_bs_overlay_face_type("hr", "9x")		$$set_bs_overlay_pose_disable("hr", "2")	// face09を強制的に表示する／腕差分2は使用禁止にする
#define		@広美私服モモンガ眼鏡なし		$$set_bs_dress_type("hr", 5)		$$set_bs_overlay_face_type("hr", "9x")		$$set_bs_overlay_pose_disable("hr", "2")	// face09を強制的に表示する／腕差分2は使用禁止にする
#define		@広美私服モモンガ聴診器眼鏡なし	$$set_bs_dress_type("hr", 6)		$$set_bs_overlay_face_type("hr", "9x")		$$set_bs_overlay_pose_disable("hr", "2")	// face09を強制的に表示する／腕差分2は使用禁止にする

#define		@玖琉未私服						$$set_bs_dress_type("kr", 1)
#define		@玖琉未私服腰巻なし				$$set_bs_dress_type("kr", 2)
#define		@玖琉未ティラノ					$$set_bs_dress_type("kr", 3)

#define		@湊私服							$$set_bs_dress_type("mn", 1)

#define		@誠私服							$$set_bs_dress_type("mk", 1)
#define		@誠肌着							$$set_bs_dress_type("mk", 2)
#define		@誠裸							$$set_bs_dress_type("mk", 3)

#define		@ツミレ通常						$$set_bs_dress_type("tm", 1)
#define		@ツミレ吹き出しなし				$$set_bs_dress_type("tm", 2)
#define		@ツミレハウス斜め				$$set_bs_dress_type("tm", 3)
#define		@ツミレハウス斜め吹き出しなし	$$set_bs_dress_type("tm", 4)

#define		@絵美私服						$$set_bs_dress_type("em", 1)
#define		@絵美私服２						$$set_bs_dress_type("em", 2)

#define		@熊の着ぐるみボードなし			$$set_bs_dress_type("km", 1)
#define		@熊の着ぐるみボード美			$$set_bs_dress_type("km", 2)
#define		@熊の着ぐるみボードNOTクマ		$$set_bs_dress_type("km", 3)
#define		@熊の着ぐるみボード麦の恋人		$$set_bs_dress_type("km", 4)
#define		@熊の着ぐるみボード無地			$$set_bs_dress_type("km", 5)

#define		@穂乃夏私服						$$set_bs_dress_type("hn", 1)
#define		@穂乃夏私服ジャケット			$$set_bs_dress_type("hn", 2)
#define		@穂乃夏制服						$$set_bs_dress_type("hn", 3)

