// エフェクトタイプ
#replace	<URACE_EF_HIT_TRAP>				1		// 障害物にぶつかった
#replace	<URACE_EF_STUN>					2		// スタン
#replace	<URACE_EF_CAPTURE>				3		// 捕獲
#replace	<URACE_EF_SPEED_UP>				4		// スピードアップ
#replace	<URACE_EF_SPEED_DOWN>			5		// スピードダウン
#replace	<URACE_EF_BLOCK>				6		// 妨害無効
#replace	<URACE_EF_REFLECT>				7		// 反射
#replace	<URACE_EF_RANDOM>				8		// ランダム
#replace	<URACE_EF_PROTECT>				9		// 地形適性無効
#replace	<URACE_EF_DAMAGE>				10		// ダメージ

#command $$get_urace_bbs_select_player_text(int) : str		// 掲示板選択時の主人公のテキストを取得する
#command $$get_urace_hunter_info_text(int) : str			// ハンター依頼時のハンターの詳細を取得する

#define		@ＵＭＡ勝利メダル	B[100]

#macro		@ＵＭＡレースチュートリアルシナリオ(@label_no)
	close
	$$urace_font_disable
	@ＵＭＡレースユーザー制御解除
	farcall("100_UMA0000", @label_no)
	close
	$$urace_font_enable
	@ＵＭＡレースユーザー制御開始

#macro		@ＵＭＡレースチュートリアル遷移(@jump_file)
	@ＵＭＡレースユーザー制御開始
	farcall(@jump_file)
	@ＵＭＡレースユーザー制御解除


//@ＵＭＡハンター結果処理へ


#define		@SE_ＵＭＡレース_アイテム取得			pcmch[2].play("_hhp_skill_max")
#define		@SE_ＵＭＡレース_スキルゲージ最大		pcmch[3].play("_hhp_skill_max")
#define		@SE_ＵＭＡレース_レーン移動				pcmch[4].play("_hhp_enemy_spawn01")

#command $$pick_urace_race_item(int)
