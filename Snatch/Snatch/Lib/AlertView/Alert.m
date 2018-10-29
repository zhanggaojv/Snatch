//
//  Alert.m
//  BSS
//
//  Created by zhangbo on 13-9-22.
//  Copyright (c) 2013年 YANGZQ. All rights reserved.
//

#import "Alert.h"
#import "AlertView.h"
//默认动画时间
#define ZKB_ANIMATION_DURATION 0.3
#define ZKB_MAIN_SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define ZKB_MAIN_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define ZKB_MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation Alert

+(void)show:(NSString *)str
{
    AlertView *alert = [[AlertView alloc] initWithTitle:@"" andMessage:str];
    [alert addButtonWithTitle:@"确定" type:0 handler:nil];
    [alert show];
}

+(void)show:(NSString *)str hasSuccessIcon:(BOOL)hasSuccessIcon AndShowInView:(UIView *)parentView
{
    if(hasSuccessIcon)
    {
        __block UIView *view = [[UIView alloc] initWithFrame:
                        CGRectMake((ZKB_MAIN_SCREEN_WIDTH-150)/2.0, (ZKB_MAIN_SCREEN_HEIGHT-200)/2.0, 150, 110)];
        [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [view.layer setCornerRadius:10];
        __block UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 25, 38, 30)];
        [imgView setImage:[UIImage imageNamed:@"success_icon"]];
        [view addSubview:imgView];
        
        __block UILabel *lblAlert = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 150, 20)];
        [lblAlert setText:str];
        [lblAlert setTextAlignment:NSTextAlignmentCenter];
        [lblAlert setTextColor:[UIColor whiteColor]];
        [lblAlert setFont:[UIFont systemFontOfSize:14]];
        [lblAlert setBackgroundColor:[UIColor clearColor]];
        [view addSubview:lblAlert];
        
        [parentView addSubview:view];
        
        [UIView animateWithDuration:0.3
                              delay:0.6
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [view setBackgroundColor:[UIColor clearColor]];
                             [lblAlert setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            if(finished)
            {
                [lblAlert removeFromSuperview];
                lblAlert = nil;
                [imgView removeFromSuperview];
                imgView = nil;
                [view removeFromSuperview];
                view = nil;
            }
        }];

    }
    else
    {
        UIFont *font = [UIFont systemFontOfSize:14];
        
        CGFloat width = 150;
        CGFloat height = 110;
        
        if(str.length >= 10){
            width = 180;
        }
        
        __block UIView *view = [[UIView alloc] initWithFrame:
                        CGRectMake((ZKB_MAIN_SCREEN_WIDTH-width)/2.0, (ZKB_MAIN_SCREEN_HEIGHT - height - 90)/2.0, width, height)];
        [view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [view.layer setCornerRadius:10];
        __block UILabel *lblAlert = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, height)];
        [lblAlert setText:str];
        [lblAlert setNumberOfLines:0];
        [lblAlert setTextAlignment:NSTextAlignmentCenter];
        [lblAlert setTextColor:[UIColor whiteColor]];
        [lblAlert setFont:font];
        [lblAlert setBackgroundColor:[UIColor clearColor]];
        [view addSubview:lblAlert];
        
        [parentView addSubview:view];
        
        [UIView animateWithDuration:0.3
                              delay:0.6
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [lblAlert setAlpha:0];
                         } completion:^(BOOL finished) {
                             if(finished)
                             {
                                 [lblAlert removeFromSuperview];
                                 lblAlert = nil;
                             }
                         }];
        [UIView animateWithDuration:0.3
                              delay:0.6
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [view setBackgroundColor:[UIColor clearColor]];
        } completion:^(BOOL finished) {
            if(finished)
            {
                [view removeFromSuperview];
                view = nil;
            }
        }];
        

    }
}

@end
