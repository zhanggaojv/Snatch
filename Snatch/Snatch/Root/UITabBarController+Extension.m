//
//  UITabBarController+Extension.m
//  夺你所爱
//
//  Created by Zhanggaoju on 16/9/20.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "UITabBarController+Extension.h"

@implementation UITabBarController (Extension)

-(void)addViewController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName seleteImageName:(NSString *)seleteImageName{
    
    //设置标题
    controller.title=title;
    
    //创建视图导航控制器
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [UINavigationBar appearance].barTintColor=kDefaultColor;
//   [UINavigationBar appearance].barTintColor=SELECT_COLOR(240, 20, 50, .3);
    nav.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19]};
    
    UIImage *oringnalImage=[UIImage imageNamed:imageName];
    
    if (iOS7_OR_LATER) {
        oringnalImage =[oringnalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    
    UIImage *selectdImage=[UIImage imageNamed:seleteImageName];
    
    if (iOS7_OR_LATER) {
        selectdImage = [selectdImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    nav.tabBarItem =[[UITabBarItem alloc]initWithTitle:title image:oringnalImage selectedImage:selectdImage];
    
    [self addChildViewController:nav];
}
@end
