//
//  NSString+GJCutStr.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/12.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "NSString+GJCutStr.h"

@implementation NSString (GJCutStr)
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
    
}
@end
