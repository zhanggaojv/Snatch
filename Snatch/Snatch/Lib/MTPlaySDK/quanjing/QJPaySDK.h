//
//  QJPaySDK.h
//  QJPaySDK
//
//  Created by WuXian on 16/5/20.
//  Copyright © 2016年 WuXian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol QJPayManagerDelegate <NSObject>

/**
 支付返回结果回调
 response：应答码:
 0：成功;
 -1：失败;
 1：用户取消;
 */
- (void)QJPayResponseResult:(int)response;




@end



@interface QJPaySDK : NSObject


//支付方式
+(NSString*)PAY_WEIXIN;
+(NSString*)PAY_BAIDU;
+(NSString*)PAY_APLIPAY;
+(NSString*)PAY_PONITCART;
+(NSString*)PAY_JINGDONG;
+(NSString*)PAY_UNIONAPPLE;
+(NSString*)PAY_UNION;





+(NSString*)WETCHAR;



+ (void)QJPayStart:(NSMutableDictionary *)param AppScheme:(NSString *)scheme appKey:(NSString *)appKey andCurrentViewController:(UIViewController *)vc andDelegate:(id<QJPayManagerDelegate>)delegate Flag:(int)flag;

+ (void)QJPayStart:(NSMutableDictionary *)param AppScheme:(NSString *)scheme Sign:(NSString *)sign andCurrentViewController:(UIViewController *)vc andDelegate:(id<QJPayManagerDelegate>)delegate Flag:(int)flag;




+ (BOOL)handleOpenURL:(NSURL *)url;

+ (BOOL)handleOpenWeChatURL:(NSURL *)url;








@end
