#z00

//---------------------------------------------------------------------------
// アイテムの名前を取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_name(property $item_id, property $item_level) : str
{
	property $text : str
	
	switch( $item_id ) {
		
	case(<HHP_ITEM_ID_DAMAGE_UP>)				// 攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text = "バット"
		case(2)		$text = "釘バット"
		case(3)		$text = "輝くバット"
		}
		
	case(<HHP_ITEM_ID_ATTACK_SLASH>)			// 縦横攻撃追加
		
		switch( $item_level ) {
		case(1)		$text = "細い木の棒"
		case(2)		$text = "新鮮な木の棒"
		case(3)		$text = "神々しい木の棒"
		}
		
	case(<HHP_ITEM_ID_CRITICAL>)				// クリティカル発生
		
		switch( $item_level ) {
		case(1)		$text = "小吉のおみくじ"
		case(2)		$text = "中吉のおみくじ"
		case(3)		$text = "大吉のおみくじ"
		}
		
	case(<HHP_ITEM_ID_INVINCIBLE>)				// 無敵発生
		
		switch( $item_level ) {
		case(1)		$text = "ビニール傘"
		case(2)		$text = "普通の傘"
		case(3)		$text = "愛乃の傘"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>)		// スロウ付与
		
		switch( $item_level ) {
		case(1)		$text = "古ぼけたトラバサミ"
		case(2)		$text = "市販のトラバサミ"
		case(3)		$text = "超強力トラバサミ"
		}
		
	case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)		// 無敵で攻撃を受けると攻撃力アップ
		
		$text = "子供の案山子"
		
	case(<HHP_ITEM_ID_SPIKE>)					// 反射ダメージ
		
		switch( $item_level ) {
		case(1)		$text = "フェンス"
		case(2)		$text = "有刺鉄線のフェンス"
		case(3)		$text = "電流フェンス"
		}
		
	case(<HHP_ITEM_ID_LIFE_REGENERATION>)		// ライフ自動回復
		
		switch( $item_level ) {
		case(1)		$text = "子供用絆創膏"
		case(2)		$text = "普通の絆創膏"
		case(3)		$text = "高級絆創膏"
		}
		
	case(<HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER>)	// ウェーブ終了後ライフ回復
		
		switch( $item_level ) {
		case(1)		$text = "老舗のいももち"
		case(2)		$text = "老舗のいももち（タレ）"
		case(3)		$text = "老舗のいももち（金粉かけ）"
		}
		
	case(<HHP_ITEM_ID_DOUBLE_ATTACK>)	// 二重攻撃
		
		switch( $item_level ) {
		case(1)		$text = "ネオ新生町議会一般会員バッジ"
		case(2)		$text = "ネオ新生町議会幹部バッジ"
		case(3)		$text = "ネオ新生町議会副会長バッジ"
		}
		
	case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)		// 永続的なライフ増加
		
		switch( $item_level ) {
		case(1)		$text = "特製プロテイン"
		case(2)		$text = "健特製イノセンスフラッシュ"
		case(3)		$text = "六花特製兄さん元気ドリンク"
		}
		
	case(<HHP_ITEM_ID_ATTACK_RANGE_UP>)			// 攻撃範囲アップ
		
		switch( $item_level ) {
		case(1)		$text = "ヘビ除けスプレー"
		case(2)		$text = "ヘビ除けスプレー改"
		case(3)		$text = "ヘビ除けスプレー改零式"
		}
		
	case(<HHP_ITEM_ID_SKILL_POWER_REGENERATION>)	// スキルパワー自動回復
		
		switch( $item_level ) {
		case(1)		$text = "やる気スイッチサプリＸ"
		case(2)		$text = "やる気スイッチサプリＸＹ"
		case(3)		$text = "やる気スイッチサプリＸＹＺ"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_CONVERT>)		// 相手が倒れた時、近くにいる敵に状態異常を移す
		
		$text = "ハッピーでターンな粉"
		
	case(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)		// 無敵でないとき攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text = "全裸の極意書・初級編"
		case(2)		$text = "全裸の極意書・中級編"
		case(3)		$text = "全裸の極意書・上級編"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP>)	// 状態異常に攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text = "伊達メガネ"
		case(2)		$text = "イカしたメガネ"
		case(3)		$text = "つづらのメガネ"
		}
		
	case(<HHP_ITEM_ID_LIFELESS_DAMAGE_UP>)		// ダメージを受けている相手に攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text = "ドＳの極意書・１巻"
		case(2)		$text = "ドＳの極意書・２巻"
		case(3)		$text = "ドＳの極意書・３巻"
		}
		
	case(<HHP_ITEM_ID_ATTACKED_DAMAGE_UP>)		// 敵からダメージを受けると攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text = "使い捨て手袋"
		case(2)		$text = "作業用手袋"
		case(3)		$text = "防刃手袋"
		}
		
	case(<HHP_ITEM_ID_SKILL_POWER_MAX_UP>)	// スキルパワー最大値増加
		
		switch( $item_level ) {
		case(1)		$text = "スピカ直筆ピザの奥義書・上巻"
		case(2)		$text = "スピカ直筆ピザの奥義書・中巻"
		case(3)		$text = "スピカ直筆ピザの奥義書・下巻"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP>)	// 状態異常の数が多いほど攻撃力アップ
		
		$text = "河瀬作・リミッター解除装置β"
		
	case(<HHP_ITEM_ID_COMBO_UP>)			// コンボ数が多いほど攻撃力／回復力アップ
		switch( $item_level ) {
		case(1)		$text = "使いかけの便箋"
		case(2)		$text = "新品の便箋"
		case(3)		$text = "小鳥郵便局の便箋"
		}
		
	case(<HHP_ITEM_ID_LIFE_UP>)					// ライフ増加
		
		switch( $item_level ) {
		case(1)		$text = "木の板"
		case(2)		$text = "頑丈な木の板"
		case(3)		$text = "血染めの木の板"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_STUN>)		// スタン付与
		
		switch( $item_level ) {
		case(1)		$text = "蓋のついたシュールストレミング"
		case(2)		$text = "蓋の開きかけたシュールストレミング"
		case(3)		$text = "蓋の開いたシュールストレミング"
		}
		
	case(<HHP_ITEM_ID_DAMAGE_LIFE_RECOVER>)		// 攻撃ダメージ発生時にライフ回復
		
		switch( $item_level ) {
		case(1)		$text = "滋養強壮のパワーストーン（梅）"
		case(2)		$text = "滋養強壮のパワーストーン（竹）"
		case(3)		$text = "滋養強壮のパワーストーン（松）"
		}
		
	case(<HHP_ITEM_ID_RIVIVAL>)					// ライフ０時に復活
		
		$text = "つみれの抜け羽"
		
	case(<HHP_ITEM_ID_SPIKE_DAMAGE_UP>)			// 反射ダメージアップ
		
		switch( $item_level ) {
		case(1)		$text = "枯れたクマザザ"
		case(2)		$text = "クマザザ"
		case(3)		$text = "輝くクマザザ"
		}
		
	case(<HHP_ITEM_ID_REROLL>)					// リロール増加
		switch( $item_level ) {
		case(1)		$text = "リロールダイス"
		case(2)		$text = "高級リロールダイス"
		case(3)		$text = "超高級リロールダイス"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_EXCITED>)	// 興奮付与
		
		$text = "ヘビ用の撒き餌"
		
	case(<HHP_ITEM_ID_SE_CHANGE>)				// ＳＥ変更
		
		$text = "つみれの笑い袋"
		
	}
	
	return ($text)
}

//---------------------------------------------------------------------------
// アイテムの説明を取得する
//---------------------------------------------------------------------------
command $$get_hhp_item_description(property $item_id, property $item_level) : str
{
	property $text : str
	
	switch( $item_id ) {
		
	case(<HHP_ITEM_ID_DAMAGE_UP>)				// 攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text  = "攻撃ダメージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "攻撃ダメージが" + $$bold("少し") + "増加する。#D"
					$text += "重なった敵に攻撃が" + $$bold("貫通") + "するようになる。"
		case(3)		$text  = "攻撃ダメージが" + $$bold("かなり") + "増加する。#D"
					$text += "重なった敵に攻撃が" + $$bold("貫通") + "するようになる。"
		}
		
	case(<HHP_ITEM_ID_ATTACK_SLASH>)			// 縦横攻撃追加
		
		switch( $item_level ) {
		case(1)		$text  = "攻撃に" + $$bold("横一列") + "の" + $$bold("範囲攻撃") + "を追加する。"
		case(2)		$text  = "攻撃に" + $$bold("横一列") + "の" + $$bold("範囲攻撃") + "を追加する。#D"
					$text += "さらに" + $$bold("縦一列") + "の" + $$bold("範囲攻撃") + "を追加する。"
		case(3)		$text  = "攻撃に" + $$bold("横一列") + "の" + $$bold("範囲攻撃") + "を追加する。#D"
					$text += "さらに" + $$bold("縦一列") + "の" + $$bold("範囲攻撃") + "を追加する。#D"
					$text += "敵を倒した時に" + $$bold("周りの敵に追加で") + "攻撃ダメージを与える。"
		}
		
	case(<HHP_ITEM_ID_CRITICAL>)				// クリティカル発生
		
		switch( $item_level ) {
		case(1)		$text  = "敵にダメージを与えるときに" + $$bold("クリティカル") + "が" + $$bold("低確率") + "で発生するようになる。#D"
					$text += "（クリティカルダメージは" + $$bold("２倍") + "）"
		case(2)		$text  = "敵にダメージを与えるときに" + $$bold("クリティカル") + "が" + $$bold("中確率") + "で発生するようになる。#D"
					$text += "（クリティカルダメージは" + $$bold("２倍") + "）"
		case(3)		$text  = "敵にダメージを与えるときに" + $$bold("クリティカル") + "が" + $$bold("中確率") + "で発生するようになる。#D"
					$text += "（クリティカルダメージは" + $$bold("３倍") + "）"
		}
		
	case(<HHP_ITEM_ID_INVINCIBLE>)				// 無敵発生
		
		switch( $item_level ) {
		case(1)		$text  = "一定時間ごとにすべてのダメージを防ぐ" + $$bold("無敵") + "が発生するようになる。#D"
					$text += "（無敵は重複すると効果時間が" + $$bold("上書き") + "される）"
		case(2)		$text  = "一定時間ごとにすべてのダメージを防ぐ" + $$bold("無敵") + "が発生するようになる。"
					$text += "無敵効果時間が" + $$bold("少し") + "長くなる。#D"
					$text += "（無敵は重複すると効果時間が" + $$bold("上書き") + "される）"
		case(3)		$text  = "一定時間ごとにすべてのダメージを防ぐ" + $$bold("無敵") + "が発生するようになる。"
					$text += "無敵効果時間が" + $$bold("少し") + "長くなる。#D"
					$text += "（無敵効果時間が" + $$bold("重複") + "するようになる）"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_SLOW>)		// スロウ付与
		
		switch( $item_level ) {
		case(1)		$text  = "敵出現時に" + $$bold("中確率") + "で移動速度を低下させる。"
		case(2)		$text  = "敵出現時に" + $$bold("必ず") + "移動速度を低下させる。"
		case(3)		$text  = "敵出現時に" + $$bold("必ず") + "移動速度を低下させる。#D"
					$text += "さらに敵は" + $$bold("ダメージを受けた状態") + "で出現する。"
		}
		
	case(<HHP_ITEM_ID_INVINCIBLE_DAMAGE_UP>)	// 無敵で攻撃を受けると攻撃力アップ
		
		$text = "無敵中に攻撃を受けたときに" + $$bold("少しの間攻撃ダメージが増加") + "する。"
		
	case(<HHP_ITEM_ID_SPIKE>)					// 反射ダメージ
		
		switch( $item_level ) {
		case(1)		$text  = "攻撃を受けたときに" + $$bold("最大ライフの５０％") + "を敵にダメージとして与える。"
		case(2)		$text  = "攻撃を受けたときに" + $$bold("最大ライフの１００％") + "を敵にダメージとして与える。"
		case(3)		$text  = "攻撃を受けたときに" + $$bold("最大ライフの１００％") + "を敵にダメージとして与える。#D"
					$text += "さらに近くに敵がいる場合は" + $$bold("その敵にもダメージを与える") + "。"
		}
		
	case(<HHP_ITEM_ID_LIFE_REGENERATION>)		// ライフ自動回復
		
		switch( $item_level ) {
		case(1)		$text  = "一定時間おきに" + $$bold("ライフの自動回復") + "が発生するようになる。"
		case(2)		$text  = "一定時間おきに" + $$bold("ライフの自動回復") + "が発生するようになる。#D"
					$text += "自動回復が" + $$bold("より短い時間") + "で発生するようになる。"
		case(3)		$text  = "一定時間おきにライフの" + $$bold("自動回復") + "が発生するようになる。#D"
					$text += "さらに敵は" + $$bold("ダメージを受けた状態") + "で出現する。#D"
					$text += "さらにライフの" + $$bold("回復量が増加") + "する。"
		}
		
	case(<HHP_ITEM_ID_WAVE_FINISHED_LIFE_RECOVER>)	// ウェーブ終了後ライフ回復
		
		switch( $item_level ) {
		case(1)		$text  = "襲撃終了時に" + $$bold("最大ライフの３０％") + "、ライフを回復する。"
		case(2)		$text  = "襲撃終了時に" + $$bold("最大ライフの５０％") + "、ライフを回復する。#D"
					$text += "さらに" + $$bold("ライフ回復で溢れたライフ分だけ") + "発生した無敵時間を延長する。"
		case(3)		$text  = "襲撃終了時に" + $$bold("最大ライフの１００％") + "、ライフを回復する。#D"
					$text += "さらに" + $$bold("ライフ回復で溢れたライフ分だけ") + "発生した無敵時間を延長する。"
		}
		
	case(<HHP_ITEM_ID_DOUBLE_ATTACK>)	// 二重攻撃
		
		switch( $item_level ) {
		case(1)		$text  = "クリティカルが発生した時に奥義ゲージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "クリティカルが発生した時に奥義ゲージが" + $$bold("少し") + "増加する。#D"
					$text += "状態異常の敵にクリティカルが発生すると" + $$bold("与えるダメージが増加") + "する。"
		case(3)		$text  = "クリティカルが発生した時に奥義ゲージが" + $$bold("少し") + "増加する。#D"
					$text += "状態異常の敵にクリティカルが発生すると" + $$bold("与えるダメージが増加") + "する。#D"
					$text += "さらにクリティカルが発生すると" + $$bold("攻撃が２回発生") + "する。"
		}
		
	case(<HHP_ITEM_ID_PERMANENTLY_LIFE_UP>)		// 永続的なライフ増加
		
		switch( $item_level ) {
		case(1)		$text  = "最大ライフを" + $$bold("少し") + "増加、攻撃ダメージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "最大ライフを" + $$bold("少し") + "増加、攻撃ダメージが" + $$bold("少し") + "増加する。#D"
					$text += "ライフ回復で溢れたライフ分だけ、" + $$bold("スコアが増加") + "する。"
		case(3)		$text  = "最大ライフを" + $$bold("少し") + "増加、攻撃ダメージが" + $$bold("少し") + "増加する。#D"
					$text += "ライフ回復で溢れたライフ分だけ、" + $$bold("スコアが増加") + "する。#D"
					$text += "さらにライフ回復で溢れたライフ１００ごとに" + $$bold("永続的に最大ライフが少し増加") + "する。"
		}
		
	case(<HHP_ITEM_ID_ATTACK_RANGE_UP>)			// 攻撃範囲アップ
		
		switch( $item_level ) {
		case(1)		$text  = $$bold("低確率で") + "通常攻撃が範囲攻撃になる。"
		case(2)		$text  = $$bold("中確率で") + "通常攻撃が範囲攻撃になる。#D"
					$text += "攻撃範囲が" + $$bold("少し") + "拡大する。"
		case(3)		$text  = $$bold("高確率で") + "通常攻撃が範囲攻撃になる。#D"
					$text += "攻撃範囲が" + $$bold("かなり") + "拡大する。"
		}
		
	case(<HHP_ITEM_ID_SKILL_POWER_REGENERATION>)	// スキルパワー自動回復
		
		switch( $item_level ) {
		case(1)		$text  = "一定時間ごとに奥義ゲージが" + $$bold("自動で増加") + "する。"
		case(2)		$text  = "一定時間ごとに奥義ゲージが" + $$bold("自動で増加") + "する。#D"
					$text += "奥義ゲージの回復量が" + $$bold("少し") + "増加する。"
		case(3)		$text  = "一定時間おきに奥義ゲージが" + $$bold("自動で増加") + "する。#D"
					$text += "奥義ゲージの回復量が" + $$bold("少し") + "増加する。#D"
					$text += "奥義ゲージのストック数が多いほど与えるダメージが" + $$bold("増加") + "する。"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_CONVERT>)		// 相手が倒れた時、近くにいる敵に状態異常を移す
		
		$text = "状態異常の敵を倒した時、近くにいる敵に" + $$bold("同等の状態異常を与える") + "。"
		
	case(<HHP_ITEM_ID_NO_INVINCIBLE_DAMAGE_UP>)		// 攻撃／無敵でないとき攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text  = "無敵状態でないときに攻撃ダメージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "無敵状態でないときに攻撃ダメージが" + $$bold("かなり") + "増加する。"
		case(3)		$text  = "無敵状態でないときに攻撃ダメージが" + $$bold("かなり") + "増加する。#D"
					$text += "さらにライフ回復で溢れたライフ１００ごとに" + $$bold("永続的に攻撃力が少し増加") + "する。"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_DAMAGE_UP>)		// 状態異常に攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text  = "状態異常の敵に与えるダメージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "状態異常の敵に与えるダメージが" + $$bold("かなり") + "増加する。"
		case(3)		$text  = "状態異常の敵に与えるダメージが" + $$bold("かなり") + "増加する。#D"
					$text += "さらに攻撃ダメージが" + $$bold("かなり") + "増加する。"
		}
		
	case(<HHP_ITEM_ID_LIFELESS_DAMAGE_UP>)		// ダメージを受けている相手に攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text  = "ライフが減っている敵に与えるダメージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "ライフが減っている敵に与えるダメージが" + $$bold("かなり") + "増加する。"
		case(3)		$text  = "ライフが減っている敵に与えるダメージが" + $$bold("かなり") + "増加する。#D"
					$text += "さらに" + $$bold("クリティカル") + "が" + $$bold("高確率") + "で発生するようになる。"
		}
		
	case(<HHP_ITEM_ID_ATTACKED_DAMAGE_UP>)		// 敵からダメージを受けると攻撃力アップ
		
		switch( $item_level ) {
		case(1)		$text  = "敵から攻撃を受けたときに一定時間与えるダメージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "敵から攻撃を受けたときに一定時間与えるダメージが" + $$bold("少し") + "増加する。#D"
					$text += "敵から攻撃を受けたときに奥義ゲージが" + $$bold("少し") + "増加する。"
		case(3)		$text  = "敵から攻撃を受けたときに一定時間与えるダメージが" + $$bold("少し") + "増加する。#D"
					$text += "敵から攻撃を受けたときに奥義ゲージが" + $$bold("少し") + "増加する。#D"
					$text += "ライフが少ないときに敵からダメージを受けると、少しの間、" + $$bold("無敵時間が発生") + "する。"
		}
		
	case(<HHP_ITEM_ID_SKILL_POWER_MAX_UP>)		// スキルパワー最大値増加
		
		switch( $item_level ) {
		case(1)		$text  = "奥義ゲージの最大ストック数を" + $$bold("１") + "増加する。"
		case(2)		$text  = "奥義ゲージの最大ストック数を" + $$bold("１") + "増加する。"
		case(3)		$text  = "奥義ゲージの最大ストック数を" + $$bold("１") + "増加する。#D"
					$text += "奥義ゲージがストックされると" + $$bold("全体攻撃が発生") + "する。"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_COUNT_DAMAGE_UP>)	// 状態異常の数が多いほど攻撃力アップ
		
		$text = "敵の" + $$bold("状態異常の数が多いほど") + "与えるダメージが増加する。"
		
	case(<HHP_ITEM_ID_COMBO_UP>)		// コンボ数が多いほど攻撃力／回復力アップ
		
		switch( $item_level ) {
		case(1)		$text  = "コンボ数が多いほど与えるダメージが" + $$bold("少し") + "増加する。"
		case(2)		$text  = "コンボ数が多いほど与えるダメージが" + $$bold("少し") + "増加する。#D"
					$text += "さらに回復するライフの量が" + $$bold("少し") + "増加する。"
		case(3)		$text  = "コンボ数が多いほど与えるダメージが" + $$bold("かなり") + "増加する。#D"
					$text += "さらに回復するライフの量が" + $$bold("かなり") + "増加する。"
		}
		
	case(<HHP_ITEM_ID_LIFE_UP>)					// ライフ増加
		
		switch( $item_level ) {
		case(1)		$text = "最大ライフを" + $$bold("少し") + "増加する。"
		case(2)		$text = "最大ライフを" + $$bold("かなり") + "増加する。"
		case(3)		$text = "最大ライフを" + $$bold("少し") + "増加する。" + 
							"#D" + "さらに襲撃終了時に最大ライフを" + $$bold("少し") + "増加する。"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_STUN>)		// スタン付与
		
		switch( $item_level ) {
		case(1)		$text  = "敵にダメージを与えると" + $$bold("スタン") + "するようになる。"
		case(2)		$text  = "敵にダメージを与えると" + $$bold("スタン") + "するようになる。#D"
					$text += "スタン時間が" + $$bold("少し") + "増加する。"
		case(3)		$text  = "敵にダメージを与えると" + $$bold("スタン") + "するようになる。#D"
					$text += "スタン時間が" + $$bold("かなり") + "増加する。"
		}
		
	case(<HHP_ITEM_ID_DAMAGE_LIFE_RECOVER>)		// 敵ダメージ発生時にライフ回復
		
		switch( $item_level ) {
		case(1)		$text  = "敵がダメージを受けたときに" + $$bold("低確率") + "でライフを" + $$bold("少し") + "回復する。"
		case(2)		$text  = "敵がダメージを受けたときに" + $$bold("低確率") + "でライフを" + $$bold("少し") + "回復する。#D"
					$text += "ライフが最大の場合は奥義ゲージを" + $$bold("少し") + "回復する。"
		case(3)		$text  = "敵がダメージを受けたときに" + $$bold("低確率") + "でライフを" + $$bold("かなり") + "回復する。#D"
					$text += "ライフが最大の場合は奥義ゲージを" + $$bold("かなり") + "回復する。"
		}
		
	case(<HHP_ITEM_ID_RIVIVAL>)					// ライフ０時に復活
		
		$text = "ライフが０になった場合、一度だけライフを１にして" + $$bold("復活") + "する。"
		
	case(<HHP_ITEM_ID_SPIKE_DAMAGE_UP>)			// 反射ダメージアップ
		
		switch( $item_level ) {
		case(1)		$text  = "敵から攻撃を受けた時の反射ダメージを" + $$bold("少し") + "増加する。"
		case(2)		$text  = "敵から攻撃を受けた時の反射ダメージを" + $$bold("かなり") + "増加する。"
		case(3)		$text  = "敵から攻撃を受けた時の反射ダメージを" + $$bold("かなり") + "増加する。#D"
					$text += "さらに攻撃した敵に" + $$bold("怒り") + "の状態異常を与える。"
		}
		
	case(<HHP_ITEM_ID_REROLL>)					// リロール増加
		
		switch( $item_level ) {
		case(1)		$text  = "リロール回数が" + $$bold("３回") + "増加する。"
		case(2)		$text  = "さらにリロール回数が" + $$bold("３回") + "増加する。#D"
					$text += "高レベルのアイテムが" + $$bold("少し") + "出現しやすくなる。"
		case(3)		$text  = "さらにリロール回数が" + $$bold("２回") + "増加する。#D"
					$text += "高レベルのアイテムが" + $$bold("かなり") + "出現しやすくなる。"
		}
		
	case(<HHP_ITEM_ID_STATUS_EFFECT_EXCITED>)	// 興奮付与
		
		$text = $$bold("難易度が上昇") + "するが、" + $$bold("獲得スコアが増加") + "する。"
		
	case(<HHP_ITEM_ID_SE_CHANGE>)				// ＳＥ変更
		
		$text = "叩くときの音が変わる。" + $$bold("獲得スコアが増加") + "する。"
	}
	
	return ($text)
}

// 強調文字に変換する
command $$bold(property $text : str) : str
{
	return ("#100C" + $text + "#0C")
}

//---------------------------------------------------------------------------
// スキルの名前を取得する
//---------------------------------------------------------------------------
command $$get_hhp_skill_name(property $skill_id) : str
{
	property $text : str
	
	switch( $skill_id ) {
	case(<HHP_SKILL_ID_SP>)		$text = "ピザ窯の支配者"
	case(<HHP_SKILL_ID_AI>)		$text = "スカイ昇竜ミックス盛り"
	case(<HHP_SKILL_ID_HI>)		$text = "ビューティフル・ビューティー"
	case(<HHP_SKILL_ID_KY>)		$text = "お手紙・絶対到達宣言"
	case(<HHP_SKILL_ID_RK>)		$text = "天上天下兄我独尊"
	}
	
	return ($text)
}

//---------------------------------------------------------------------------
// スキルの説明を取得する
//---------------------------------------------------------------------------
command $$get_hhp_skill_description(property $skill_id) : str
{
	property $text : str
	
	switch( $skill_id ) {
	case(<HHP_SKILL_ID_SP>)		$text = "すべての敵に攻撃ダメージを与える"
	case(<HHP_SKILL_ID_AI>)		$text = "すべての攻撃に対して５秒間の無敵が発生する"
	case(<HHP_SKILL_ID_HI>)		$text = "奥義使用ごとに反射ダメージが１００％増加する"
	case(<HHP_SKILL_ID_KY>)		$text = "すべての敵に３秒間のスタンを与える"
	case(<HHP_SKILL_ID_RK>)		$text = "１０秒間継続してライフが回復する"
	}
	
	return ($text)
}
