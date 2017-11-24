//
//  ComMacro.h
//  ZSLayerTest
//
//  Created by 朱 圣 on 8/29/13.
//  Copyright (c) 2013 37wan. All rights reserved.
//

#ifndef COMMACRO_H_
#define COMMACRO_H_

#pragma mark ---- APPLICATION

/**
 @brief 获取系统版本号
 */
#define VERSION_FLOAT [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 @brief 获取当前状态栏的方向
 */
#define STATUS_BAR_ORIENTATION [[UIApplication sharedApplication] statusBarOrientation]

/**
 @brief 判断是否为iPad
 */
#define isIpad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

/**
 @brief 判断是否iphone6Plus
 */
#define isIphone6Plus ([[UIScreen mainScreen] bounds].size.height == 736 || [[UIScreen mainScreen] bounds].size.width == 736)

/**
 @brief 判断是否iphone6
 */
#define isIphone6 ([[UIScreen mainScreen] bounds].size.height == 667 || [[UIScreen mainScreen] bounds].size.width == 667)

/**
 @brief 判断是否为iphone5
 */
#define isIphone5 ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.width == 568)

/**
 @brief 判断是否为iphone4
 */
#define isIphone4 ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.width == 480)


/**
 @brief 判断是否为iphoneX
 */
#define isIphoneX ([[UIScreen mainScreen] bounds].size.height == 812 || [[UIScreen mainScreen] bounds].size.width == 812)

/**
 @brief UIApplicationDelegate Object
 */
#define APPDELEGATE [[UIApplication sharedApplication] delegate]
/**
 @brief UIApplication Object
 */
#define APP [UIApplication sharedApplication]

/**
 @brief 屏幕CGRect
 */
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

/**
 @brief 屏幕高度
 */
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/**
 @brief 屏幕宽度
 */
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 @brief UIImage imageNamed
 */
#define IMG(name) [UIImage imageNamed:name]

/**
 @brief frame 左上角x view.frame.origin.x
 */
#define VIEW_TLX(view) (view.frame.origin.x)

/**
 @brief view frame 左上角y view.frame.origin.y
 */
#define VIEW_TLY(view) (view.frame.origin.y)

/**
 @brief view frame 右下角x
 */
#define VIEW_BRX(view) (view.frame.origin.x + view.frame.size.width)

/**
 @brief view frame 右下角y
 */
#define VIEW_BRY(view) (view.frame.origin.y + view.frame.size.height)

/**
 @brief view frame width
 */
#define VIEW_W(view) (view.bounds.size.width)

/**
 @brief view frame height
 */
#define VIEW_H(view) (view.bounds.size.height)

/**
 @brief CGRect 左上角x
 */
#define FRAME_TLX(frame) (frame.origin.x)

/**
 @brief CGRect 左上角y
 */
#define FRAME_TLY(frame) (frame.origin.y)

/**
 @brief CGRect width
 */
#define FRAME_W(frame) (((frame).size).width)

/**
 @brief CGRect height
 */
#define FRAME_H(frame) (((frame).size).height)

/**
 @brief 点相加
 */
#define cgpAdd(p, q) CGPointMake((p).x + (q).x, (p).y + (q).y)

/**
 @brief 点相减
 */
#define cgpSub(p, q) CGPointMake((p).x - (q).x, (p).y - (q).y)

/**
 @brief 点的字符串形式
 */
#define cgpStr(p) [NSString stringWithFormat:@"(%.1f, %.1f)", (p).x, (p).y]

/**
 @brief 设置CGRect 的 x 和 y
 */
#define cgrOrigin(r, x, y) CGRectMake((x), (y), (((r).size).width), (((r).size).height))

/**
 @brief 设置CGRect 的 x
 */
#define cgrX(r, x) cgrOrigin((r), (x), ((r).origin.y))

/**
 @brief 设置CGRect 的 y
 */
#define cgrY(r, y) cgrOrigin((r), ((r).origin.x), (y))

/**
 @brief 设置CGRect 的 width 和 height
 */
#define cgrSize(r, w, h) CGRectMake(((r).origin.x), ((r).origin.y), (w), (h))

/**
 @brief 设置CGRect 的 width
 */
#define cgrWidth(r, w) cgrSize((r), (w), (r).size.height)

/**
 @brief 设置CGRect 的 height
 */
#define cgrHeight(r, h) cgrSize((r), (r).size.width, (h))

/**
 @brief 获取CGRect 的 x
 */
#define cgrGetX(r) (((r).origin).x)

/**
 @brief 获取CGRect 的 y
 */
#define cgrGetY(r) (((r).origin).y)

/**
 @brief 获取CGRect 的 width
 */
#define cgrGetWidth(r) (((r).size).width)

/**
 @brief 获取CGRect 的 height
 */
#define cgrGetHeight(r) (((r).size).height)

/**
 @brief CGRect的字符串形式
 */
#define cgrStr(r) [NSString stringWithFormat:@"(%.1f, %.1f, %.1f, %.1f)", cgrGetX((r)), cgrGetY((r)), cgrGetWidth((r)), cgrGetHeight((r))]

/**
 @brief 打印 CGPoint
 */
#define LogPt(s, p) NSLog(@"%@%@", s, cgpStr(p))

/**
 @brief 打印 CGRect
 */
#define LogRect(s, r) NSLog(@"%@%@", s, cgrStr(r))

/**
 @brief 根据r,g,b的值(0~255)创建UIColor
 */
#define UIColorWithRGB(r, g, b) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:1.0f]

/**
 @brief 根据r,g,b,a的值(0~255)创建UIColor
 */
#define UIColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0f green:(g) / 255.0f blue:(b) / 255.0f alpha:(a) / 255.0f]

/**
 @brief 判断NSString是否为空
 */
#define isStringEmpty(str)  ((str) == nil || [(str) isEqual:@""] || [(str) isKindOfClass:[NSNull class]])

/**
 @brief 判断NSArray是否为空
 
 @deprecated 请使用isCollectionEmpty
 */
#define isArrayEmpty(array) (((array) == nil) || ([(array) count] == 0) || [(array) isKindOfClass:[NSNull class]])

/**
 @brief 判断NSArray, NSDictionary, NSSet是否为空
 */
#define isCollectionEmpty(collection) (((collection) == nil) || [(collection) isKindOfClass:[NSNull class]] || ([(collection) count] == 0))

/**
 @brief Path Of Documents Directory
 */
#define DOCUMENTS_DIR_PATH  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

/**
 @brief Path Of Tmp Directory
 */
#define TMP_DIR_PATH        [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]

/**
 @brief Path Of Cache Directory
 */
#define CACHES_DIR_PATH        [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]

/**
 @brief "documents directory path"/name
 */
#define PathInDocumentsDirectory(name)   [(DOCUMENTS_DIR_PATH) stringByAppendingPathComponent:(name)]

/**
 @brief "tmp directory path"/name
 */
#define PathInTmpDirectory(name)   [(DOCUMENTS_DIR_PATH) stringByAppendingPathComponent:(name)]

/**
 @brief "Library/Caches directory path"/name
 */
#define PathInCachesDirectory(name)   [(CACHES_DIR_PATH) stringByAppendingPathComponent:(name)]

/**
 @brief status bar height
 */
#define STATUS_BAR_HEIGHT   (isIphoneX ? 44.f : 20.f)

/**
 @brief navigation bar height
 */
#define NAVIGATION_BAR_HEIGHT 44

/**
 @brief tab bar height
 */
#define TAB_BAR_HEIGHT  (isIphoneX ? (49.f) : 49.f)

/**
 @brief tab bar height
 */
#define HOME_INDICATOR  (isIphoneX ? (34.f) : 0.f)

/**
 @brief 没有候选时的键盘高度
 */
#define KEYBOARD_HEIGHT  216

/**
 @brief 出了候选词之后的键盘高度
 */
#define KEYBOARD_HEIGHT_CANDIDATES  252

/**
 @brief weakSelf
 */
#define NGGWeakSelf __weak typeof(self) weakSelf = self;

#endif

