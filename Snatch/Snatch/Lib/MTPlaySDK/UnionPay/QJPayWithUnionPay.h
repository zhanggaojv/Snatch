//
//  QJPayWithUnionPay.h
//  QJPayWithUnionPay
//
//  Created by linkyun on 16/11/15.
//  Copyright © 2016年 linkyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QJPayWithUnionPay : NSObject

+ (void)sendUnionPayMessage:(NSString *)orderInfo  andAppScheme:(NSString *)UPAppScheme andRootViewController:(UIViewController *)rootVC response:(void(^)(NSString *code, NSDictionary *data))responseResultBlock;


+ (BOOL)handleOpenURL:(NSURL *)url;


@end
