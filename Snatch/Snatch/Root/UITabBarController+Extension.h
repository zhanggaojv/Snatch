//
//  UITabBarController+Extension.h
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Extension)

/**
 *快速添加跟视图控制器的方法
 */
-(void)addViewController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName seleteImageName:(NSString *)seleteImageName;
@end
