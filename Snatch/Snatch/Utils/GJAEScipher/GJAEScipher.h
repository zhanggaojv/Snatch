//
//  GJAEScipher.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/24.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJAEScipher : NSObject
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;

+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key;

@end
