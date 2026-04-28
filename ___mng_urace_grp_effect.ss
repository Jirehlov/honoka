//===========================================================================
//!
//!    @file     ___mng_urace_grp_effect.ss
//!    @brief    ＵＭＡレース／エフェクト描画関数群
//!
//!    @author   Copyright (C)2024- VISUAL ARTS. All rights reserved.
//!    @author   Kazuya Takahashi
//!    @note     none
//!
//===========================================================================

//---------------------------------------------------------------------------
// 定義
//---------------------------------------------------------------------------
#inc_start
	
	// オブジェクト変数
	#define		f_type			f[0]			// エフェクトタイプ
	#define		f_delay_time	f[1]			// ディレイ時間
	
#inc_end

#z00

//---------------------------------------------------------------------------
// ＵＭＡレースで使用するエフェクトを作成する
//---------------------------------------------------------------------------
command $$create_urace_effect(property $obj : object, property $effect_type, property $x, property $y, property $play)
{
	switch( $effect_type ) {
		
	// 走り地形エフェクト(芝)
	case(<URACE_EFFECT_RUN_SCATTER_TURF>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect07,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 3000,							// 消滅する時間(最小、最大)
							-40, -30, -40, -20					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-50, 0, 30, 40					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							450, 850, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
							-450, 450, 0, 0					// 回転角(最小、最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 1500							// ディレイ時間(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							-10, 10, 60, 70					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
		$obj.tr = 128
		
	// 走り地形エフェクト(ダート)
	case(<URACE_EFFECT_RUN_SCATTER_DIRT>)
		
		$obj.child.resize(1)
		$obj.child[0].create(test_effect, 1, -100, 0)
		$obj.child[0].set_scale(500, 500)
		$obj.child[0].tr = 96
		$obj.child[0].blend = 4
		/*
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect10,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1500,							// 消滅する時間(最小、最大)
							-40, -30, -10, -10					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-50, 0, 50, 50					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							550, 850, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
							-450, 450, 0, 0					// 回転角(最小、最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 1250							// ディレイ時間(最小、最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$obj.tr = 224
		*/
		
	// 走り地形エフェクト(水)
	case(<URACE_EFFECT_RUN_SCATTER_WATER>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect09,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,							// 消滅する時間(最小、最大)
							-40, -30, -20, -10					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-50, 120, 30, 50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							350, 650, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							-10, 10, 40, 50					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 750							// ディレイ時間(最小、最大)
		)
		$$set_particle_color_add($obj.child[0],				// 使用するオブジェクト
							"#ffffff", "#ffffff"			// カラーコード範囲(最小、最大)
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
		$obj.tr = 128
		$obj.blend = 4
		
	// 走り地形エフェクト(すべて)
	case(<URACE_EFFECT_RUN_SCATTER_ALMIGHTY>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect11,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,							// 消滅する時間(最小、最大)
							-40, -30, -40, -30					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-100, -50, 30, 50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							350, 650, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							-10, 10, 40, 50					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 750							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC00", "#FF00CC", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
		$obj.tr = 128
		$obj.blend = 1
		
	// ラストスパート
	case(<URACE_EFFECT_LAST_SPURT>)
		
		$obj.child.resize(2)
		$$create_particle($obj.child[0], _mng_ur_pt_effect03,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							250, 500,							// 消滅する時間(最小、最大)
							-100, -200, 0, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-80, -80, -50, 50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1000, 1500, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 250							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#dddd11", "#ffff22", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		
		$$create_particle_radial($obj.child[1], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
							16, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 750,									// 消滅する時間(最小、最大)
							200, 300									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[1], 		// 使用するオブジェクト
							40								// 半径
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							450, 700, 700, 750				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							0, 2000							// ディレイ時間(最小、最大)
		)
		$obj.blend = 1
		
	// 線の軌跡(緑)
	case(<URACE_EFFECT_LINE_TRAIL_GREEN>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect03,	// 使用するオブジェクト, 画像
							50, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							250, 500,							// 消滅する時間(最小、最大)
							-100, -200, 0, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-80, -80, -50, 50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1000, 1500, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 250							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#00bfff", "#00fa9a", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		
	// 線の軌跡(黄色)
	case(<URACE_EFFECT_LINE_TRAIL_YELLOW>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect03,	// 使用するオブジェクト, 画像
							48, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							250, 500,							// 消滅する時間(最小、最大)
							-100, -200, 0, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-80, -80, -50, 50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1000, 1500, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 250							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#dddd11", "#ffff22", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		
	// 線の軌跡(虹色)
	case(<URACE_EFFECT_LINE_TRAIL_RAINBOW>)
		
		$obj.child.resize(2)
		$$create_particle($obj.child[0], _mng_ur_pt_effect03,	// 使用するオブジェクト, 画像
							30, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,							// 消滅する時間(最小、最大)
							-100, -200, 0, 1					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-80, -80, -50, 50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1000, 1500, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 750							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC00", "#FF00CC", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		
		$$create_particle($obj.child[1], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
							20, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 3000,							// 消滅する時間(最小、最大)
							-20, -30, 0, 10						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[1], 			// 使用するオブジェクト
							-50, 50, -10, 50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							0, 1500							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_color($obj.child[1],					// 使用するオブジェクト
							"#66CC00", "#FF00CC", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		
	// 火の軌跡
	case(<URACE_EFFECT_FIRE_TRAIL>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect12,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							150, 350,							// 消滅する時間(最小、最大)
							-100, -150, -30, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-40, -40, 60, 60				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 150							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[0], 0, 				// 使用するオブジェクト, アスペクト比を維持するか
							1250, 1750, 1250, 1750			// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$obj.blend = 1
		
	// 火の軌跡(ワンショット)
	case(<URACE_EFFECT_FIRE_TRAIL_ONESHOT>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect12,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							350, 500,							// 消滅する時間(最小、最大)
							-100, -150, -30, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-40, -40, 60, 60				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 350							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[0], 0, 				// 使用するオブジェクト, アスペクト比を維持するか
							1250, 1750, 1250, 1750			// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.blend = 1
		
	// 火の軌跡(虹色)
	case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect12,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							150, 500,							// 消滅する時間(最小、最大)
							-100, -150, -30, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-40, -40, 60, 60				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 150							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[0], 0, 				// 使用するオブジェクト, アスペクト比を維持するか
							1250, 1750, 1250, 1750			// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC00", "#FF00CC", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
		$obj.blend = 1
		
	// 火の軌跡(ワンショット・虹色)
	case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW_ONESHOT>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect12,	// 使用するオブジェクト, 画像
							32, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							350, 500,							// 消滅する時間(最小、最大)
							-100, -150, -30, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-40, -40, 60, 60				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 1000							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[0], 0, 				// 使用するオブジェクト, アスペクト比を維持するか
							1250, 1750, 1250, 1750			// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC00", "#FF00CC", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.blend = 1
		
	// ブロック
	case(<URACE_EFFECT_BLOCK>)
		
		$obj.child.resize(3)
		$obj.child[0].create(_mng_ur_st_effect02, 1, 0, 0, 1)
		$obj.child[0].blend = 1
		$$set_image_center($obj.child[0])
		
		$$create_particle_radial($obj.child[1], _mng_ur_st_effect02,	// 使用するオブジェクト, 画像
							8, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							350, 550,									// 消滅する時間(最小、最大)
							200, 250									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[1], 		// 使用するオブジェクト
							30								// 半径
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							250, 500, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							150, 250						// ディレイ時間(最小、最大)
		)
		$$set_particle_patno($obj.child[1], 				// 使用するオブジェクト
							1, 1							// パターン番号(最小、最大)
		)
		$$set_particle_oneshot($obj.child[1])				// 使用するオブジェクト
		$obj.child[1].blend = 1
		
		$obj.child[2].create(_mng_ur_st_effect02, 1)
		$obj.child[2].y_rep.resize(1)
		$obj.child[2].tr_rep.resize(1)
		$$set_image_center($obj.child[2])
		
	// 回避
	case(<URACE_EFFECT_AVOID>)
		
		$obj.child.resize(2)
		
		$obj.child[0].create(_mng_ur_sk_effect06, 1)
		$$set_image_center($obj.child[0])
		$obj.child[0].y_rep.resize(1)
		
		$$create_particle($obj.child[1], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 3000,							// 消滅する時間(最小、最大)
							0, 0, 0, 0							// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[1], 			// 使用するオブジェクト
							-30, 30, -30, 30				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							450, 700, 700, 750				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							350, 2000						// ディレイ時間(最小、最大)
		)
		$obj.child[1].blend = 1
		
	// 衝突(星・小)
	case(<URACE_EFFECT_CRASH_STAR_S>)
		
		$obj.create("__mng_ur_ef01", 1)
		$$set_image_center($obj)
		
		/*
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 750,							// 消滅する時間(最小、最大)
							-20, 20, -70, -70					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-20, 20, 0, 0					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							300, 550, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							0, 0, 150, 200					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.blend = 1
		*/
		
	// 衝突(星・大)
	case(<URACE_EFFECT_CRASH_STAR_L>)
		
		$obj.create("__mng_ur_ef02", 1)
		$$set_image_center($obj)
		/*
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 750,							// 消滅する時間(最小、最大)
							-30, 30, -80, -80					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-20, 20, 0, 0					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							0, 0, 150, 200					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.blend = 1
		*/
		
	// スキル発動(コモン)
	case(<URACE_EFFECT_SKILL_POWER_LV1>)
		
		$obj.child.resize(2)
		
		$obj.child[0].create(_mng_ur_pt_effect02, 1)
		$$set_image_center($obj.child[0])
		
		$$create_particle_radial($obj.child[1], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
						16, 1,											// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						350, 500,										// 消滅する時間(最小、最大)
						-500, -700										// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[1],		// 使用するオブジェクト
									120						// 半径
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_color($obj.child[1],					// 使用するオブジェクト
							"#dbe34a", "#71b4d0", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_oneshot($obj.child[1])				// 使用するオブジェクト
		$obj.blend = 1
		
	// スキル発動(レア)
	case(<URACE_EFFECT_SKILL_POWER_LV2>)
		
		$obj.child.resize(2)
		$obj.child[0].create(_mng_ur_pt_effect02, 1)
		$$set_image_center($obj.child[0])
		
		$$create_particle_radial($obj.child[1], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
						24, 1,											// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						350, 500,										// 消滅する時間(最小、最大)
						-600, -800										// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[1],		// 使用するオブジェクト
									220						// 半径
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							750, 1500, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_color($obj.child[1],					// 使用するオブジェクト
							"#0066CC", "#00CCFF", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_oneshot($obj.child[1])				// 使用するオブジェクト
		$obj.blend = 1
		
	// スキル発動(ユニーク)
	case(<URACE_EFFECT_SKILL_POWER_LV3>)
		
		$obj.child.resize(2)
		$obj.child[0].create(_mng_ur_pt_effect02, 1)
		$$set_image_center($obj.child[0])
		
		$$create_particle_radial($obj.child[1], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
						32, 1,											// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						350, 500,										// 消滅する時間(最小、最大)
						-700, -900										// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[1],		// 使用するオブジェクト
									320						// 半径
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1500, 2000, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_color($obj.child[1],					// 使用するオブジェクト
							"#663399", "#FF66FF", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_oneshot($obj.child[1])				// 使用するオブジェクト
		$obj.blend = 1
		
	// スキル発動(アルティメット)
	case(<URACE_EFFECT_SKILL_POWER_LV4>)
		
		$obj.child.resize(2)
		$obj.child[0].create(_mng_ur_pt_effect02, 1)
		$$set_image_center($obj.child[0])
		
		$$create_particle_radial($obj.child[1], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
						40, 1,											// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						350, 500,										// 消滅する時間(最小、最大)
						-800, -1000										// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[1],		// 使用するオブジェクト
									420						// 半径
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							2000, 2500, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[1], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_color($obj.child[1],					// 使用するオブジェクト
							"#FFFF00", "#FFFF99", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_oneshot($obj.child[1])				// 使用するオブジェクト
		$obj.blend = 1
		
	// 跳ねる草
	case(<URACE_EFFECT_ENV_BOUND_GRASS>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect07,	// 使用するオブジェクト, 画像
							12, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,							// 消滅する時間(最小、最大)
							-20, 20, -50, -50					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-120, 120, -50, -50				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							0, 0, 80, 100					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		
	// 跳ねる葉っぱ
	case(<URACE_EFFECT_ENV_BOUND_LEAF>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect08,	// 使用するオブジェクト, 画像
							12, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,							// 消滅する時間(最小、最大)
							-10, 10, -10, -30					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-40, 40, -40, -40				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 0, 				// 使用するオブジェクト, アスペクト比を維持するか
							250, 1000, 250, 1000			// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							0, 0, 40, 60					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		
	// 跳ねる水
	case(<URACE_EFFECT_ENV_BOUND_WATER>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect09,	// 使用するオブジェクト, 画像
							8, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,							// 消滅する時間(最小、最大)
							-20, 20, -30, -30					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-10, 10, 20, 20					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1000, 1000, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 200							// ディレイ時間(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							-10, 10, 50, 50					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		
	// 水への着地
	case(<URACE_EFFECT_ENV_DROP_WATER>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect09,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,							// 消滅する時間(最小、最大)
							-30, 30, -50, -70					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-30, 30, 50, 50					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1000, 2000, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							-10, 10, 80, 80					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color_add($obj.child[0],				// 使用するオブジェクト
							"#ffffff", "#ffffff"			// カラーコード範囲(最小、最大)
		)
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 不透明度を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.tr = 128
		$obj.blend = 4
		
	// 渦巻
	case(<URACE_EFFECT_ENV_SWIRL_WATER>)
		
		$obj.child.resize(1)
		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect09,	// 使用するオブジェクト, 画像
						4, 1,											// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						750, 1000,										// 消滅する時間(最小、最大)
						-20, -50										// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0],		// 使用するオブジェクト
									70						// 半径
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 1500							// ディレイ時間(最小、最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$obj.rotate_z_eve.loop(0, 3600, 5000, 0, 0)
		
	// 穴掘り
	case(<URACE_EFFECT_ENV_DIG>)
		
		$obj.child.resize(2)
		$obj.child[0].create(_mng_ur_gr_effect03, 1)
		$obj.child[0].y = 60
		$$set_image_center($obj.child[0])
		
		$$create_particle($obj.child[1], _mng_ur_pt_effect10,	// 使用するオブジェクト, 画像
							20, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 3000,							// 消滅する時間(最小、最大)
							-10, 10, -10, -20					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[1], 			// 使用するオブジェクト
							-50, 50, 30, 30					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							0, 1500							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1500, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		
	// 闇の玉
	case(<URACE_EFFECT_POP_DARK_BALL>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect02,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 2000,							// 消滅する時間(最小、最大)
							0, 0, -10, -20						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-70, 70, 0, 80					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							250, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 1500							// ディレイ時間(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							-10, 10, 0, 0					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#FF66FF", "#CC00FF", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		
	// ハート
	case(<URACE_EFFECT_POP_HEART>)
		
		$obj.child.resize(2)
		$$create_particle($obj.child[0], _mng_ur_pt_effect05,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1500,							// 消滅する時間(最小、最大)
							-30, 30, -10, -30					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-30, 30, 60, 60					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		
		$$create_particle($obj.child[1], _mng_ur_pt_effect05,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 2000,							// 消滅する時間(最小、最大)
							0, 0, 0, 0							// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[1], 			// 使用するオブジェクト
							60, 120, 0, 120					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							400, 650, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							500, 1500						// ディレイ時間(最小、最大)
		)
		
	// 凍結
	case(<URACE_EFFECT_POP_FROZEN>)
		
		$obj.create(_mng_ur_sk_effect09)
		$$set_image_center($obj)
		$obj.scale_y = 650
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		
	// 御来光
	case(<URACE_EFFECT_POP_LIGHT>)
		
		$obj.create(_mng_ur_sk_effect10)
		$$set_image_center($obj)
		$obj.scale_y = 650
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		
	// プレッシャー(発動側)
	case(<URACE_EFFECT_PRESSURE>)
		
		$obj.create(_mng_ur_sk_effect03)
		$$set_image_center($obj)
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		$obj.scale_y = 500
		
	// プレッシャー(受ける側)
	case(<URACE_EFFECT_PRESSURE_TARGET>)
		
		$obj.child.resize(2)
		
		$obj.child[0].create(_mng_ur_sk_effect03, 1)
		$$set_image_center($obj.child[0])
		$obj.child[0].y_rep.resize(1)
		$obj.child[0].tr_rep.resize(1)
		
		$$create_particle($obj.child[1], _mng_ur_pt_effect10,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 2000,							// 消滅する時間(最小、最大)
							-10, 10, 10, 20						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[1], 			// 使用するオブジェクト
							-30, 30, -30, -30				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[1], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							250, 1000						// ディレイ時間(最小、最大)
		)
		$$set_particle_outside_force($obj.child[1],			// 使用するオブジェクト
							-10, 10, -10, -20				// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[1],					// 使用するオブジェクト
							"#550099", "#442255", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.child[1].tr = 96
		
	// 抑え込み(発動側)
	case(<URACE_EFFECT_OBSTACLE>)
		
		$obj.create(_mng_ur_sk_effect04)
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		$obj.scale_y = 500
		$$set_image_center($obj)
		
	// 抑え込み(受ける側)
	case(<URACE_EFFECT_OBSTACLE_TARGET>)
		
		$obj.create(_mng_ur_sk_effect04)
		$obj.x_rep.resize(2)
		$$set_image_center($obj)
		
	// 引っこ抜く(発動側)
	case(<URACE_EFFECT_PULL_OUT>)
		
		$obj.create(_mng_ur_sk_effect05)
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		$obj.scale_y = 750
		$$set_image_center($obj)
		
	// 引っこ抜く(受ける側)
	case(<URACE_EFFECT_PULL_OUT_TARGET>)
		
		$obj.create(_mng_ur_sk_effect05)
		$obj.x_rep.resize(1)
		$$set_image_center($obj)
		
	// 風の斬撃(発動側)
	case(<URACE_EFFECT_WIND_SLASH>)
		
		$obj.create(_mng_ur_sk_effect02)
		$obj.scale_x = -1000
		$obj.x_rep.resize(1)
		$$set_image_center($obj)
		$obj.blend = 1
		
	// 風の斬撃(受ける側)
	case(<URACE_EFFECT_WIND_SLASH_TARGET>)
		
		$obj.child.resize(2)
		$obj.child[0].create(_mng_ur_sk_effect02, 1)
		$obj.child[0].x_rep.resize(1)
		$$set_image_center($obj.child[0])
		
		$$create_particle_radial($obj.child[1], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
						8, 1,											// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						250, 250,										// 消滅する時間(最小、最大)
						500, 800										// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[1], 		// 使用するオブジェクト
							10								// 半径
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							300, 550, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[1], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							500, 500						// ディレイ時間(最小、最大)
		)
		$$set_particle_auto_scale($obj.child[1], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[1])				// 使用するオブジェクト
		$obj.blend = 1
		
	// 尻子玉(発動側)
	case(<URACE_EFFECT_SHIRIKODAMA>)
		
		$obj.create(_mng_ur_sk_effect07)
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		$$set_image_center($obj)
		
	// 尻子玉(受ける側)
	case(<URACE_EFFECT_SHIRIKODAMA_TARGET>)
		
		$obj.child.resize(3)
		$obj.child[0].create(_mng_ur_sk_effect07, 1)
		$obj.child[0].tr_rep.resize(1)
		$$set_image_center($obj.child[0])
		
		$obj.child[1].create(_mng_ur_sk_effect08, 1)
		$obj.child[1].y_rep.resize(2)
		$obj.child[1].tr_rep.resize(2)
		$$set_image_center($obj.child[1])
		
		$$create_particle_radial($obj.child[2], _mng_ur_pt_effect02,	// 使用するオブジェクト, 画像
							8, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1000, 1500,									// 消滅する時間(最小、最大)
							100, 150									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[2], 		// 使用するオブジェクト
							20								// 半径
		)
		$$set_particle_scale($obj.child[2], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							250, 500, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[2], 				// 使用するオブジェクト
							750, 1500						// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[2],					// 使用するオブジェクト
							"#a19636", "#eddf5c", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.child[2].y = -100
		$obj.child[2].blend = 4
		
	// 吸血(発動側)
	case(<URACE_EFFECT_BLOOD_STEEL>)
		
		$obj.child.resize(1)
		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect09,	// 使用するオブジェクト, 画像
							16, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,									// 消滅する時間(最小、最大)
							-100, -150									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0], 		// 使用するオブジェクト
							140								// 半径
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							750, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 1500							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#440000", "#ff0000", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.rotate_z_eve.loop(0, 3600, 5000, 0, 0)
		
	// 吸血(受ける側)
	case(<URACE_EFFECT_BLOOD_STEEL_TARGET>)
		
		$obj.child.resize(2)
		$obj.child[0].create(urace_race_tip_shadow, 1)
		$obj.child[0].y = -50
		$obj.child[0].color_r = 255
		$obj.child[0].color_rate = 128
		$$set_image_center($obj.child[0])
		
		$$create_particle($obj.child[1], _mng_ur_pt_effect09,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 3000,							// 消滅する時間(最小、最大)
							0, 0, -10, -30						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[1], 			// 使用するオブジェクト
							-40, 40, -40, -40				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[1], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							750, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[1], 				// 使用するオブジェクト
							250, 1500						// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[1],					// 使用するオブジェクト
							"#440000", "#ff0000", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		
	// 苦手地形
	case(<URACE_EFFECT_GROUND_WEAK>)
		
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		
		$obj.child.resize(2)
		$obj.child[0].create(_mng_ur_race_skill_frame, 1, -100, -100)
		$obj.child[1].create_string("地形×", 1, 8 - 100, 8 - 100)
		$obj.child[1].set_string_param(20, 1, 5, 100, 0, 1, 2, 1)
		
	// 風
	case(<URACE_EFFECT_WIND>)
		
		$obj.create(_mng_ur_sk_effect01)
		$obj.x_rep.resize(1)
		$obj.tr = 128
		$$set_image_center($obj)
		$obj.center_rep_x = -$obj.get_size_x / 2
		
	// 逆風
	case(<URACE_EFFECT_WIND_REV>)
		
		$obj.create(_mng_ur_sk_effect01)
		$obj.x_rep.resize(2)
		$obj.x_rep[0] = $obj.get_size_x
		$obj.tr = 128
		$$set_image_center($obj)
		$obj.center_rep_x = -$obj.get_size_x / 2
		
	// 吹雪
	case(<URACE_EFFECT_SCREEN_SNOWSTORM>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], ef_snow,			// 使用するオブジェクト, 画像
							64, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 3000,						// 消滅する時間(最小、最大)
							-300, -500, 10, 30				// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							1920, 1920, -640, 340			// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1500, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 2500							// ディレイ時間(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							0, -20, -20, 40					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_auto_tr($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を透明度で下げるか
		
	// 御来光
	case(<URACE_EFFECT_SCREEN_LIGHT_GLITTER>)
		
		$obj.child.resize(1)
		
		$$create_particle($obj.child[0], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
							32, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							2500, 3000,							// 消滅する時間(最小、最大)
							-30, 30, 10, 30						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-960, 960, -540, -540			// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							250, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							250, 1000						// ディレイ時間(最小、最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$obj.blend = 1
		
		
		
		
		
		
		
		
		
		
	// 波
	case(<URACE_EFFECT_WAVE>)
		
		$obj.create(_mng_ur_gr_effect01)
		$$set_image_center($obj)
		$obj.tr = 224
		
	// 汗
	case(<URACE_EFFECT_SWEAT>)
		
		$obj.create(_mng_ur_st_effect01)
		
	// キラキラの軌跡
	case(<URACE_EFFECT_RUN_SPARKLE>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
							20, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							1500, 3000,							// 消滅する時間(最小、最大)
							-20, -30, 0, 0						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-50, 50, 0, 50					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 2000							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							250, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$obj.blend = 1
		
	// パワーをためる
	case(<URACE_EFFECT_COLLECT_POWER>)
		
		$obj.child.resize(1)
		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
						80, 1,											// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						500, 750,										// 消滅する時間(最小、最大)
						-800, -1500										// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0],		// 使用するオブジェクト
									960						// 半径
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 2000							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							750, 1500, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#FFFF66", "#0099FF", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		
	// 火花(横)
	case(<URACE_EFFECT_FIRE_SPARK_H>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], ef_fire_spark,		// 使用するオブジェクト, 画像
							20, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,						// 消滅する時間(最小、最大)
							-30, -100, -30, 30				// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							70, 70, -30, 30					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							2250, 2750, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.blend = 1
		
	// 火花(縦)
	case(<URACE_EFFECT_FIRE_SPARK_V>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], ef_fire_spark,		// 使用するオブジェクト, 画像
							20, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,						// 消滅する時間(最小、最大)
							-30, 30, -30, -50				// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-30, 30, 60, 60					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							2250, 2750, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.blend = 1
		
	// 放射する逆三角形（赤）
	case(<URACE_EFFECT_RADIAL_INV_TRI_R>)
		
		$obj.child.resize(1)
		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect06,	// 使用するオブジェクト, 画像
							16, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1500,									// 消滅する時間(最小、最大)
							400, 600									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0], 		// 使用するオブジェクト
							10								// 半径
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#FF3399", "#FF3300", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		
	// 放射する逆三角形（緑）
	case(<URACE_EFFECT_RADIAL_INV_TRI_G>)
		
		$obj.child.resize(1)
		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect06,	// 使用するオブジェクト, 画像
							16, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1500,									// 消滅する時間(最小、最大)
							400, 600									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0], 		// 使用するオブジェクト
							10								// 半径
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC33", "#66FF00", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		
	// 放射する逆三角形（青）
	case(<URACE_EFFECT_RADIAL_INV_TRI_B>)
		
		$obj.child.resize(1)
		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect06,	// 使用するオブジェクト, 画像
							16, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1500,									// 消滅する時間(最小、最大)
							400, 600									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0], 		// 使用するオブジェクト
							10								// 半径
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#0066FF", "#00CCFF", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		
	// スピードダウン
	case(<URACE_EFFECT_SPEED_DOWN>)
		
		$obj.create(_mng_ur_st_effect03)
		$$set_image_center($obj)
		$obj.y_rep.resize(1)
		$obj.tr_rep.resize(1)
		
	// 放射する星
	case(<URACE_EFFECT_RADIAL_STAR>)
		
		$obj.child.resize(1)
		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
							10, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,									// 消滅する時間(最小、最大)
							100, 300									// 動きの速さ(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0], 		// 使用するオブジェクト
							70								// 半径
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							450, 700, 700, 750				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 2000							// ディレイ時間(最小、最大)
		)
		$obj.blend = 1
	// 衝突(小・ループ)
		/*
	case(<URACE_EFFECT_CRASH_S_LOOP>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
							4, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 750,							// 消滅する時間(最小、最大)
							-2, 2, -7, -7						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-20, 20, 0, 0					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							300, 550, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							0, 0, 15, 20					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							500, 750						// ディレイ時間(最小、最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$obj.blend = 1
		*/
	case(<URACE_EFFECT_CRASH_S_LOOP>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect04,	// 使用するオブジェクト, 画像
							16, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 750,							// 消滅する時間(最小、最大)
							-30, 30, -80, -80					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-20, 20, 0, 0					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 750, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							0, 0, 150, 200					// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							500, 750						// ディレイ時間(最小、最大)
		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.blend = 1
		
	// 急ブレーキ
	case(<URACE_EFFECT_EMERGENCY_BRAKE>)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect10,	// 使用するオブジェクト, 画像
							8, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,							// 消滅する時間(最小、最大)
							0, 0, -30, -20						// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							0, 100, 50, 50					// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1500, 3000, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 0,				// 使用するオブジェクト, 角度を固定するか
							-450, 450, 0, 0					// 回転角(最小、最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 500							// ディレイ時間(最小、最大)
		)
;		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
;							"#ffffff", "#ffffff", 128		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
;		)
		$$set_particle_auto_scale($obj.child[0], 0)			// 使用するオブジェクト, 拡縮率を自動で下げるか
		$$set_particle_oneshot($obj.child[0])				// 使用するオブジェクト
		$obj.tr = 224
		
	case(89)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect02,	// 使用するオブジェクト, 画像
							30, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,							// 消滅する時間(最小、最大)
							-10, 10, -10, -20					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-30, 30, -30, 30				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							500, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 750							// ディレイ時間(最小、最大)
		)
		$$set_particle_outside_force($obj.child[0],			// 使用するオブジェクト
							-10, 10, -10, -20				// 外力(x最小、x最大、y最小、y最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC00", "#9900FF", 192		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		$obj.set_scale(1250, 1250)
		
	case(90)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect02,	// 使用するオブジェクト, 画像
							30, 1,								// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,							// 消滅する時間(最小、最大)
							-10, 10, -10, -20					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-10, 10, -10, 30				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							1000, 1500, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 750							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC00", "#9900FF", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		$obj.set_scale(1250, 1250)
		
	case(92)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], ef_fire_spark,	// 使用するオブジェクト, 画像
							30, 1,							// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							750, 1000,						// 消滅する時間(最小、最大)
							-10, 10, -10, -20				// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 			// 使用するオブジェクト
							-10, 10, -10, 30				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							10000, 15500, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 750							// ディレイ時間(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#66CC00", "#9900FF", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		$obj.set_scale(1250, 1250)
		
	case(93)
		
		$obj.child.resize(1)
		$$create_particle_circle($obj.child[0], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
					20, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
					3000, 5000,									// 消滅する時間(最小、最大)
					-1, 1000, 2000, 70, 110						// 向き(1=右回り、-1=左回り), 動きの速さ(最小、最大), 半径(最小、最大)
		)
		$$set_particle_delay($obj.child[0], 				// 使用するオブジェクト
							0, 3000							// ディレイ時間(最小、最大)
		)
		$$set_particle_scale($obj.child[0], 1, 				// 使用するオブジェクト, アスペクト比を維持するか
							250, 1000, 0, 0					// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_rotate($obj.child[0], 1,				// 使用するオブジェクト, 角度を固定するか
							-3600, 3600, 0, 0				// 回転角(最小、最大)
		)
		$$set_particle_color($obj.child[0],					// 使用するオブジェクト
							"#FF0033", "#0099FF", 255		// カラーコード範囲(最小、最大), どれぐらい色を適用するか
		)
		$obj.blend = 1
		
	case(94)
		
		$obj.child.resize(1)
		$$create_particle_vortex($obj.child[0], _mng_ur_pt_effect01,	// 使用するオブジェクト, 画像
						20, 1,										// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
						1000, 2000,									// 消滅する時間(最小、最大)
						1, 500, 2000, 50, 100						// 向き(1=右回り、-1=左回り), 動きの速さ(最小、最大), 半径(最小、最大)
		)
;		$$create_particle_radial($obj.child[0], _mng_ur_pt_effect01,// 使用するオブジェクト, 画像
;							10, 1,						// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
;							500, 1000,					// 消滅する時間(最小、最大)
;							10, 30						// 動きの速さ(最小、最大)
;		)
		$$set_particle_shape_to_circle($obj.child[0], 			// 使用するオブジェクト
							30							// 半径
		)
		$$set_particle_scale($obj.child[0], 1, 					// 使用するオブジェクト, アスペクト比を維持するか
							450, 700, 700, 750			// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 						// 使用するオブジェクト
							0, 1000						// ディレイ時間(最小、最大)
		)
		$obj.child[0].blend = 4
		
	case(95)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], _mng_ur_pt_effect01,		// 使用するオブジェクト, 画像
							10, 1,						// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							2000, 3000,					// 消滅する時間(最小、最大)
							0, 0, 0, 0					// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_circle($obj.child[0], 			// 使用するオブジェクト
							80							// 半径
		)
		$$set_particle_scale($obj.child[0], 0, 					// 使用するオブジェクト, アスペクト比を維持するか
							450, 700, 700, 750			// 拡縮率(x最小、x最大、y最小、y最大)
		)
		$$set_particle_delay($obj.child[0], 						// 使用するオブジェクト
							0, 2000						// ディレイ時間(最小、最大)
		)
		$obj.child[0].blend = 1
		
	case(96)
		
		$obj.child.resize(1)
		$$create_particle($obj.child[0], ef_fire_spark,		// 使用するオブジェクト, 画像
							20, 1,						// パーティクルの数, 中心座標を画像中心にするか(g00で設定しているなら0)
							500, 1000,					// 消滅する時間(最小、最大)
							-30, -100, -30, 30			// 動く方向x(最小、最大), 動く方向y(最小、最大)
		)
		$$set_particle_shape_to_box($obj.child[0], 				// 使用するオブジェクト
							70, 70, -30, 30				// 矩形範囲(x最小、x最大、y最小、y最大)
		)
;		$$set_particle_delay($obj, 						// 使用するオブジェクト
;							0, 2000						// ディレイ時間(最小、最大)
;		)
		$$set_particle_scale($obj.child[0], 1, 					// 使用するオブジェクト, アスペクト比を維持するか
							2250, 2750, 0, 0				// 拡縮率(x最小、x最大、y最小、y最大)
		)
	;	$$set_particle_rotate($obj, 0,					// 使用するオブジェクト, 角度を固定するか
	;						-3600, 3600, 0, 0			// 回転角(最小、最大)
	;	)
	;	$$set_particle_color($obj,						// 使用するオブジェクト
	;						"#FFFF66", "#0099FF", 255	// カラーコード範囲(最小、最大), どれぐらい色を適用するか
	;	)
		$$set_particle_oneshot($obj.child[0])					// 使用するオブジェクト
		$obj.blend = 1
		
	// スピードアップ
	case(97)
		
		$obj.create(_mng_ur_effect01, 1)
		$$set_image_center($obj)
		
		$obj.y_rep.resize(1)
		$obj.y_rep[0] = 50
		$obj.y_rep_eve[0].set(0, 500, 0, 2)
		$obj.tr_eve.set(0, 500, 750, 2)
		
	// テスト
	case(99)
		
		$obj.create(_mng_ur_skill_effect20, 1)
		$$set_image_center($obj)
		
		$obj.frame_action.start(-1, "$$fa_test")
		
	default
		$$debug_message("エフェクト番号エラー。\nindex:" + math.tostr($effect_type) + "\n処理をスキップします")
	}
	
	$obj.disp = 0
	$obj.set_pos($x, $y)
	$obj.f.resize(2)
	$obj.f_type = $effect_type
	$obj.f_delay_time = 0
	
	if( $play ) {
		$$play_urace_effect($obj)
	}
}

//---------------------------------------------------------------------------
// ＵＭＡレースで使用するエフェクトを再生する
//---------------------------------------------------------------------------
command $$play_urace_effect(property $obj : object)
{
	switch( $obj.f_type ) {
	case(<URACE_EFFECT_RUN_SCATTER_TURF>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_RUN_SCATTER_DIRT>)			$obj.child[0].patno_eve.loop(0, 44, 1500, 0, 0)//$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_RUN_SCATTER_WATER>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_RUN_SCATTER_ALMIGHTY>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_LAST_SPURT>)					$obj.child[0].frame_action.start(-1, "$$fa_particle")
													$obj.child[1].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_LINE_TRAIL_GREEN>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_LINE_TRAIL_YELLOW>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_LINE_TRAIL_RAINBOW>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
													$obj.child[1].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_FIRE_TRAIL>)					$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_FIRE_TRAIL_ONESHOT>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW_ONESHOT>)	$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_BLOCK>)
		
		$obj.child[0].set_scale(0, 0)
		$obj.child[0].scale_x_eve.set(1500, 350, 0, 2)
		$obj.child[0].scale_y_eve.set(1500, 350, 0, 2)
		$obj.child[0].tr = 255
		$obj.child[0].tr_eve.set(0, 500, 500, 2)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		$obj.child[2].y_rep[0] = 50
		$obj.child[2].y_rep_eve[0].set(0, 500, 0, 2)
		$obj.child[2].bright = 255
		$obj.child[2].bright_eve.set(0, 500, 250, 2)
		$obj.child[2].tr = 0
		$obj.child[2].tr_eve.set(255, 250, 250, 2)
		$obj.child[2].tr_rep[0] = 255
		$obj.child[2].tr_rep_eve[0].set(0, 500, 1000, 2)
		
	case(<URACE_EFFECT_AVOID>)
		
		$obj.child[0].scale_x = 0
		$obj.child[0].scale_x_eve.set(1000, 500, 0, 0)
		$obj.child[0].y_rep[0] = 150
		$obj.child[0].y_rep_eve[0].set(0, 500, 0, 2)
		$obj.child[0].tr = 0
		$obj.child[0].tr_eve.set(255, 250, 0, 2)
		$obj.child[0].bright = 0
		$obj.child[0].bright_eve.turn(0, 64, 1000, 0, 2)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_CRASH_STAR_S>)
		
		$obj.patno = 0
		$obj.patno_eve.set(14, 500, 0, 0)
		//$obj.child[0].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_CRASH_STAR_L>)
		
		$obj.patno_eve.loop(0, 47, 1500, 0, 0)
		//$obj.child[0].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_SKILL_POWER_LV1>)
		
		$obj.child[0].tr = 96
		$obj.child[0].tr_eve.set(0, 500, 400, 0)
		$obj.child[0].set_scale(0, 0)
		$obj.child[0].scale_x_eve.set(3000, 250, 150, 2)
		$obj.child[0].scale_y_eve.set(3000, 250, 150, 2)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_SKILL_POWER_LV2>)
		
		$obj.child[0].tr = 128
		$obj.child[0].tr_eve.set(0, 500, 400, 0)
		$obj.child[0].set_scale(0, 0)
		$obj.child[0].scale_x_eve.set(4000, 250, 150, 2)
		$obj.child[0].scale_y_eve.set(4000, 250, 150, 2)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_SKILL_POWER_LV3>)
		
		$obj.child[0].tr = 160
		$obj.child[0].tr_eve.set(0, 500, 400, 0)
		$obj.child[0].set_scale(0, 0)
		$obj.child[0].scale_x_eve.set(5000, 250, 150, 2)
		$obj.child[0].scale_y_eve.set(5000, 250, 150, 2)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_SKILL_POWER_LV4>)
		
		$obj.child[0].tr = 192
		$obj.child[0].tr_eve.set(0, 500, 400, 0)
		$obj.child[0].set_scale(0, 0)
		$obj.child[0].scale_x_eve.set(6000, 250, 150, 2)
		$obj.child[0].scale_y_eve.set(6000, 250, 150, 2)
		$obj.child[1].rotate_z = 0
		$obj.child[1].rotate_z_eve.set(1800, 750, 0, 0)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_ENV_BOUND_GRASS>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_ENV_BOUND_LEAF>)				$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_ENV_BOUND_WATER>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_ENV_DROP_WATER>)				$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_ENV_SWIRL_WATER>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_ENV_DIG>)
		
		$obj.child[0].scale_x = 0
		$obj.child[0].scale_x_eve.set(1000, 350, 300, 2)
		$obj.child[0].scale_y_eve.turn(1000, 1150, 250, 650, 1)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_POP_DARK_BALL>)				$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_POP_HEART>)					$obj.child[0].frame_action.start(-1, "$$fa_particle")
													$obj.child[1].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_POP_FROZEN>)
		
		$obj.rotate_z = 0
		$obj.rotate_z_eve.set(3600, 10000, 500, 0)
		$obj.scale_x = 0
		$obj.scale_x_eve.set(650, 500, 0, 0)
		$obj.y_rep[0] = 100
		$obj.y_rep_eve[0].set(0, 500, 0, 2)
		
	case(<URACE_EFFECT_POP_LIGHT>)
		
		$obj.bright = 0
		$obj.bright_eve.turn(0, 64, 500, 0, 2)
		$obj.scale_x = 0
		$obj.scale_x_eve.set(650, 500, 0, 0)
		$obj.y_rep[0] = 100
		$obj.y_rep_eve[0].set(0, 500, 0, 2)
		
	case(<URACE_EFFECT_PRESSURE>)
		
		$obj.scale_x = 0
		$obj.scale_x_eve.set(500, 500, 0, 0)
		$obj.y_rep[0] = 100
		$obj.y_rep_eve[0].set(0, 500, 0, 2)
		$obj.tr = 255
		$obj.tr_eve.set(0, 250, 750, 0)
		
	case(<URACE_EFFECT_PRESSURE_TARGET>)
		
		$obj.child[0].scale_x = 0
		$obj.child[0].scale_x_eve.set(1000, 500, 0, 0)
		$obj.child[0].y_rep[0] = -100
		$obj.child[0].y_rep_eve[0].set(0, 500, 0, 2)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_OBSTACLE>)
		
		$obj.scale_x = 0
		$obj.scale_x_eve.set(500, 250, 0, 0)
		$obj.y_rep[0] = 0
		$obj.y_rep_eve[0].set(-100, 250, 0, 2)
		$obj.tr = 128
		$obj.tr_eve.set(0, 250, 500, 0)
		
	case(<URACE_EFFECT_OBSTACLE_TARGET>)
		
		$obj.x_rep[0] = 100
		$obj.x_rep_eve[0].set(0, 500, 0, 2)
		$obj.x_rep_eve[1].turn(-10, 10, 250, 500, 2)
		$obj.tr = 192
		
	case(<URACE_EFFECT_PULL_OUT>)
		
		$obj.scale_x = 0
		$obj.scale_x_eve.set(750, 250, 0, 0)
		$obj.y_rep[0] = 0
		$obj.y_rep_eve[0].set(-100, 250, 0, 2)
		$obj.tr_eve.set(0, 250, 500, 0)
		
	case(<URACE_EFFECT_PULL_OUT_TARGET>)
		
		$obj.x_rep[0] = 0
		$obj.x_rep_eve[0].set(-100, 500, 0, 2)
		
	case(<URACE_EFFECT_SHIRIKODAMA>)
		
		$obj.scale_x = 0
		$obj.scale_y = 0
		$obj.scale_x_eve.set(750, 250, 0, 2)
		$obj.scale_y_eve.set(750, 250, 0, 2)
		$obj.y_rep[0] = 0
		$obj.y_rep_eve[0].set(-50, 250, 0, 2)
		$obj.tr_eve.set(0, 250, 500, 0)
		
	case(<URACE_EFFECT_SHIRIKODAMA_TARGET>)
		
		$obj.child[0].set_scale(2000, 2000)
		$obj.child[0].scale_x_eve.set(1000, 350, 0, 2)
		$obj.child[0].scale_y_eve.set(1000, 350, 0, 2)
		$obj.child[0].tr_rep[0] = 255
		$obj.child[0].tr_rep_eve[0].set(0, 350, 350, 2)
		$obj.child[1].bright_eve.turn(0, 128, 1000, 0, 2)
		$obj.child[1].set_scale(0, 0)
		$obj.child[1].scale_x_eve.set(1000, 350, 350, 2)
		$obj.child[1].scale_y_eve.set(1000, 350, 350, 2)
		$obj.child[1].y_rep[0] = 0
		$obj.child[1].y_rep_eve[0].set(-100, 350, 350, 2)
		$obj.child[1].tr_rep[0] = 0
		$obj.child[1].tr_rep_eve[0].set(255, 350, 350, 2)
		$obj.child[2].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_BLOOD_STEEL>)
		
		$obj.child[0].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_BLOOD_STEEL_TARGET>)
		
		$obj.child[0].scale_x = 0
		$obj.child[0].scale_x_eve.set(750, 250, 0, 0)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_GROUND_WEAK>)
		
		$obj.tr = 0
		$obj.tr_eve.set(255, 250, 0, 0)
		
		$obj.y_rep[0] = 50
		$obj.y_rep_eve[0].set(0, 250, 0, 0)
		
		$obj.tr_rep[0] = 255
		$obj.tr_rep_eve[0].set(0, 250, 3000, 0)
		
	case(<URACE_EFFECT_WIND>)
		
		$obj.x_rep[0] = -50
		$obj.x_rep_eve[0].set(0, 2000, 0, 1)
		$obj.scale_x = 0
		$obj.scale_x_eve.set(1000, 500, 0, 2)
		$obj.tr = 255
		$obj.tr_eve.set(0, 500, 1500, 2)
		
	case(<URACE_EFFECT_WIND_REV>)
		
		$obj.x_rep[1] = 50
		$obj.x_rep_eve[1].set(0, 2000, 0, 1)
		$obj.scale_x = 0
		$obj.scale_x_eve.set(-1000, 500, 0, 2)
		$obj.tr = 255
		$obj.tr_eve.set(0, 500, 1500, 2)
		
	case(<URACE_EFFECT_WIND_SLASH>)
		
		$obj.x_rep[0] = 0
		$obj.x_rep_eve[0].set(300, 500, 150, 2)
		$obj.bright = 255
		$obj.bright_eve.set(0, 500, 0, 0)
		$obj.scale_y = 0
		$obj.scale_y_eve.set(1000, 500, 0, 2)
		$obj.tr = 255
		$obj.tr_eve.set(0, 250, 250, 2)
		
	case(<URACE_EFFECT_WIND_SLASH_TARGET>)
		
		$obj.child[0].x_rep[0] = 300
		$obj.child[0].x_rep_eve[0].set(0, 500, 150, 2)
		$obj.child[0].bright = 255
		$obj.child[0].bright_eve.set(0, 500, 0, 0)
		$obj.child[0].scale_y = 0
		$obj.child[0].scale_y_eve.set(1000, 500, 0, 2)
		$obj.child[0].tr = 255
		$obj.child[0].tr_eve.set(0, 250, 750, 2)
		$obj.child[1].frame_action.start(-1, "$$fa_particle")
		
	case(<URACE_EFFECT_SCREEN_SNOWSTORM>)			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_SCREEN_LIGHT_GLITTER>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
		
		
		
		
	case(<URACE_EFFECT_WAVE>)		$obj.patno_eve.loop(0, 2, 1000, 0, 0)
	case(<URACE_EFFECT_SWEAT>)		$obj.patno_eve.loop(0, 2, 1000, 0, 0)
	case(<URACE_EFFECT_RUN_SPARKLE>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_COLLECT_POWER>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_FIRE_SPARK_H>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_FIRE_SPARK_V>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_RADIAL_STAR>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_RADIAL_INV_TRI_R>)	$obj.child[0].frame_action.start(-1, "$$fa_particle")
											$obj.rotate_z = 0
											$obj.rotate_z_eve.set(-3600, 1000, 0, 0)
	case(<URACE_EFFECT_RADIAL_INV_TRI_G>)	$obj.child[0].frame_action.start(-1, "$$fa_particle")
											$obj.rotate_z = 0
											$obj.rotate_z_eve.set(-3600, 1000, 0, 0)
	case(<URACE_EFFECT_RADIAL_INV_TRI_B>)	$obj.child[0].frame_action.start(-1, "$$fa_particle")
											$obj.rotate_z = 0
											$obj.rotate_z_eve.set(-3600, 1000, 0, 0)
	case(<URACE_EFFECT_SPEED_DOWN>)
		
		$obj.y_rep[0] = 0
		$obj.y_rep_eve[0].set(50, 750, 0, 2)
		$obj.tr = 0
		$obj.tr_eve.set(255, 250, 0, 2)
		$obj.tr_rep[0] = 255
		$obj.tr_rep_eve[0].set(0, 250, 1000, 2)
		
	case(<URACE_EFFECT_CRASH_S_LOOP>)		$obj.child[0].frame_action.start(-1, "$$fa_particle")
	case(<URACE_EFFECT_EMERGENCY_BRAKE>)	$obj.child[0].frame_action.start(-1, "$$fa_particle")
	default			$obj.child[0].frame_action.start(-1, "$$fa_particle")
	}
	
	$obj.disp = 1
}

//---------------------------------------------------------------------------
// ＵＭＡレースで使用するエフェクトを再生する(ディレイあり)
//---------------------------------------------------------------------------
command $$play_urace_effect_delay(property $obj : object, property $delay_time)
{
	$obj.f_delay_time = $delay_time
	$obj.frame_action.start(-1, "$$fa_effect_delay")
}

// ディレイフレームアクション
command $$fa_effect_delay(property $fa : frameaction, property $obj : object)
{
	if( $obj.f_delay_time < $fa.counter.get )
	{
		$$play_urace_effect($obj)
		$obj.frame_action.end
	}
}

//---------------------------------------------------------------------------
// ＵＭＡレースで使用するエフェクトを停止する
//---------------------------------------------------------------------------
command $$stop_urace_effect(property $obj : object)
{
	switch( $obj.f_type ) {
	case(<URACE_EFFECT_RUN_SCATTER_TURF>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_RUN_SCATTER_DIRT>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_RUN_SCATTER_WATER>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_RUN_SCATTER_ALMIGHTY>)		$obj.child[0].frame_action.end
	case(<URACE_EFFECT_LAST_SPURT>)					$obj.child[0].frame_action.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_LINE_TRAIL_GREEN>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_LINE_TRAIL_YELLOW>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_LINE_TRAIL_RAINBOW>)			$obj.child[0].frame_action.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_FIRE_TRAIL>)					$obj.child[0].frame_action.end
	case(<URACE_EFFECT_FIRE_TRAIL_ONESHOT>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_FIRE_TRAIL_RAINBOW_ONESHOT>)	$obj.child[0].frame_action.end
	case(<URACE_EFFECT_BLOCK>)						$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
													$obj.child[2].all_eve.end
	case(<URACE_EFFECT_AVOID>)						$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_CRASH_STAR_S>)
		;$obj.child[0].frame_action.end
	case(<URACE_EFFECT_CRASH_STAR_L>)
		$obj.patno_eve.end
		;$obj.child[0].frame_action.end
	case(<URACE_EFFECT_SKILL_POWER_LV1>)			$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_SKILL_POWER_LV2>)			$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_SKILL_POWER_LV3>)			$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_SKILL_POWER_LV4>)			$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_ENV_BOUND_GRASS>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_ENV_BOUND_LEAF>)				$obj.child[0].frame_action.end
	case(<URACE_EFFECT_ENV_BOUND_WATER>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_ENV_DROP_WATER>)				$obj.child[0].frame_action.end
	case(<URACE_EFFECT_ENV_SWIRL_WATER>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_ENV_DIG>)					$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_POP_DARK_BALL>)				$obj.child[0].frame_action.end
	case(<URACE_EFFECT_POP_HEART>)					$obj.child[0].frame_action.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_POP_FROZEN>)					$obj.all_eve.end
	case(<URACE_EFFECT_POP_LIGHT>)					$obj.all_eve.end
	case(<URACE_EFFECT_PRESSURE>)					$obj.all_eve.end
	case(<URACE_EFFECT_PRESSURE_TARGET>)			$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_OBSTACLE>)					$obj.all_eve.end
	case(<URACE_EFFECT_OBSTACLE_TARGET>)			$obj.all_eve.end
	case(<URACE_EFFECT_PULL_OUT>)					$obj.all_eve.end
	case(<URACE_EFFECT_PULL_OUT_TARGET>)			$obj.all_eve.end
	case(<URACE_EFFECT_SHIRIKODAMA>)				$obj.all_eve.end
	case(<URACE_EFFECT_SHIRIKODAMA_TARGET>)			$obj.child[0].all_eve.end
													$obj.child[1].all_eve.end
													$obj.child[2].frame_action.end
	case(<URACE_EFFECT_BLOOD_STEEL>)				$obj.all_eve.end
													$obj.child[0].frame_action.end
	case(<URACE_EFFECT_BLOOD_STEEL_TARGET>)			$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_WIND>)						$obj.all_eve.end
	case(<URACE_EFFECT_WIND_REV>)					$obj.all_eve.end
	case(<URACE_EFFECT_WIND_SLASH>)					$obj.all_eve.end
	case(<URACE_EFFECT_WIND_SLASH_TARGET>)			$obj.child[0].all_eve.end
													$obj.child[1].frame_action.end
	case(<URACE_EFFECT_SCREEN_SNOWSTORM>)			$obj.child[0].frame_action.end
	case(<URACE_EFFECT_SCREEN_LIGHT_GLITTER>)		$obj.child[0].frame_action.end
		
		
		
	case(<URACE_EFFECT_WAVE>)		$obj.patno_eve.end
	case(<URACE_EFFECT_SWEAT>)		$obj.patno_eve.end
	case(<URACE_EFFECT_RUN_SPARKLE>)		$obj.child[0].frame_action.end
	case(<URACE_EFFECT_COLLECT_POWER>)		$obj.child[0].frame_action.end
	case(<URACE_EFFECT_FIRE_SPARK_H>)		$obj.child[0].frame_action.end
	case(<URACE_EFFECT_FIRE_SPARK_V>)		$obj.child[0].frame_action.end
	case(<URACE_EFFECT_RADIAL_STAR>)		$obj.child[0].frame_action.end
	case(<URACE_EFFECT_RADIAL_INV_TRI_R>)	$obj.child[0].frame_action.end
											$obj.rotate_z_eve.end
	case(<URACE_EFFECT_RADIAL_INV_TRI_G>)	$obj.child[0].frame_action.end
											$obj.rotate_z_eve.end
	case(<URACE_EFFECT_RADIAL_INV_TRI_B>)	$obj.child[0].frame_action.end
											$obj.rotate_z_eve.end
	case(<URACE_EFFECT_SPEED_DOWN>)			$obj.all_eve.end
	case(<URACE_EFFECT_CRASH_S_LOOP>)		$obj.child[0].frame_action.end
	case(<URACE_EFFECT_EMERGENCY_BRAKE>)	$obj.child[0].frame_action.end
	default		$obj.child[0].frame_action.end
	}
	
	$obj.disp = 0
}


// test
command $$fa_test(property $fa : frameaction, property $obj : object)
{
	$$line_test($obj, $fa.counter.get / 10)
}

command $$line_test(property $obj : object, property $_u) : int
{
	property $i
	property $u
	property $p1
	property $p2
	property $p3
	property $p4
	property $m
	
	property $1 : intlist[2]
	property $2 : intlist[2]
	property $3 : intlist[2]
	property $4 : intlist[2]
	
	$1.sets(0, 960, 540)
	$2.sets(0, 460, 240)
	$3.sets(0, 460, 1080)
	$4.sets(0, 960, 1080)
	
	$m = 100
	
	if( $_u > $m ) {
		return
	}
;	for( $i = 0, $i < $dev, $i += 1 )
;	{
		$u = $_u
	;	$u = $i * 100 / ($dev - 1)
		$p1 = ($m - $u) * ($m - $u) * ($m - $u)
		$p2 = 3 * $u * ($m - $u) * ($m - $u)
		$p3 = 3 * $u * $u * ($m - $u)
		$p4 = $u * $u * $u
		
		b[0] = $u
		b[1] = $p1
		b[2] = $p2
		b[3] = $p3
		b[4] = $p4
	$obj.x = ($1[0] * $p1 + $2[0] * $p2 + $3[0] * $p3 + $4[0] * $p4) / ($m * $m * $m);1000000
	$obj.y = ($1[1] * $p1 + $2[1] * $p2 + $3[1] * $p3 + $4[1] * $p4) / ($m * $m * $m);1000000
;	$obj.x = (960 * $p1 + 1920 * $p2 + 1920 * $p3 + 960 * $p4) / 1000000
;	$obj.y = (540 * $p1 + 540 * $p2 + 540 * $p3 + 1080 * $p4) / 1000000
		
		b[5] = $obj.x
		b[6] = $obj.y
;	}
}
