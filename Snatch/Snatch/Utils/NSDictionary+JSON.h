//
//  NSDictionary+JSON.h
//  ybt
//
//  Created by dsd on 14-9-26.
//  Copyright (c) 2014年 hnzdkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSON)
- (id)JSONObjectForKey:(NSString *)aKey;
- (NSInteger)JSONIntegerObjectForKey:(NSString *)aKey;
@end
