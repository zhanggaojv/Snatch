//
//  JSONStrToDict.m
//  ybt
//
//  Created by cocoabanana on 14/10/25.
//  Copyright (c) 2014年 hnzdkj. All rights reserved.
//

#import "JSONStrToDict.h"

@implementation JSONStrToDict
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
       // YBLogInfo(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
