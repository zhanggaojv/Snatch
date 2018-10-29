//
//  QJPayWithUnionApplePay.h
//  QJPayWithUnionApplePay
//
//  Created by linkyun on 16/10/31.
//  Copyright © 2016年 linkyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QJPayWithUnionApplePay : NSObject

+ (void)sendUnionApplePayMessage:(NSString *)tn andModeParams:(NSString *)modeParams andAPMechantIDParams:(NSString *)aPMechantIDParams  andRootViewController:(UIViewController *)rootVC response:(void(^)(int statusCode))responseResultBlock;

+ (void)sendUnionApplePayMessage:(NSString *)orderInfo andRootViewController:(UIViewController *)rootVC response:(void(^)(int statusCode))responseResultBlock;




@end
