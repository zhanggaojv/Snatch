//
//  CustomDefone.h
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#ifndef CustomDefone_h
#define CustomDefone_h

/**轻黑色字体颜色*/
#define LightBlackLabelTextColor [UIColor colorWithRed:0.26f green:0.26f blue:0.26f alpha:1.00f]
#define md_Wode_leftFontSize 15
#define GrayLineHeight 0.8
#define GrayLineUIColor [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f]


/**
 *define:颜色设置的宏定义
 *prame: _r -- RGB的红
 *parma: _g -- RGB的绿
 *parma: _g -- RGB的蓝
 *parma: _alpha -- RGB的透明度
 */
#define SELECT_COLOR(_r,_g,_b,_alpha) [UIColor colorWithRed:_r / 255.0 green:_g / 255.0 blue:_b / 255.0 alpha:_alpha]

/**
 *define:获取屏幕的宽
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/**
 *define:获取屏幕的高
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *define:iOS 7.0的版本判断
 */
#define iOS7_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 7.0

/**
 *define:iOS 8.0的版本判断
 */
#define iOS8_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 8.0

/**
 *define:屏幕的宽高比
 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_WIDTH

#define CreateHeadView @"createHeadView"

#define SETColor(color) [UIColor colorWithHexString:@"color"]

#define SYSTEM_FONT(__fontsize__)\
[UIFont systemFontOfSize:__fontsize__]
#define kDefaultColor [UIColor colorWithHexString:@"db3752"]
//#define kDefaultColor [UIColor colorWithHexString:@"e7445d"]
//#define kDefaultColor [UIColor colorWithHexString:@"ff1200"]
//#define kDefaultColor [UIColor colorWithHexString:@"eb4f38"]
#define IMAGE_NAMED(__imageName__)\
[UIImage imageNamed:__imageName__]

#define IFNEWVER [newver intValue]!=4
#define NEWAPPVALUE @"4"




/*** 日志 ***/
#ifdef DEBUG
#define MMLog(...) NSLog(__VA_ARGS__)
#else
#define MMLog(...)
#endif


#define kScreenW ([UIScreen mainScreen].bounds.size.width)
#define kScreenH ([UIScreen mainScreen].bounds.size.height)
#define kHeardViewH kScreenW * 3 / 7
#define kStatusBarH 20
#define kNavigationBarH 44
#define kTabBarH 47
#define kTitleViewH 50

#endif /* CustomDefone_h */

