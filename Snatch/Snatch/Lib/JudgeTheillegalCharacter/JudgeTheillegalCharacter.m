//
//  JudgeTheillegalCharacter.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/11/12.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "JudgeTheillegalCharacter.h"

@implementation JudgeTheillegalCharacter
+ (BOOL)JudgeTheillegalCharacter:(NSString *)content{
    //提示 标签不能输入特殊字符(正则表达式)
    //^[\u4E00-\u9FA5A-Za-z0-9]+$
    //[A-Za-z0-9\\u4e00-\u9fa5]+$
    //^([\u4e00-\u9fa5]|[a-zA-Z0-9])+$
    //^([u4e00\u9fa5]|[azAZ09]|\s|[\x00\xff])+$

    NSString *str =@"^[\u4E00-\u9FA5A-Za-z0-9_'?!.,*@]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}
@end
