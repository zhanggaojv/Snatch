//
//  NSObject+Property.m
//  自动生成属性
//
//  Created by 袁伟森 on 16/2/13.
//  Copyright © 2016年 袁伟森. All rights reserved.
//

#import "NSObject+Property.h"

@implementation NSObject (Property)

+ (void)createPropertyCodeWithDic:(NSDictionary *)dict
{
    
    
    NSMutableString *strM = [NSMutableString string];
    //遍历字典
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {

        NSString *code;
        if ([obj isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSString *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) BOOL %@;",key];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic ,assign) NSInteger %@;",key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSArray *%@;",key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic ,strong) NSDictionary *%@;",key];
        }
        
        [strM appendFormat:@"\n%@\n",code];
        
        
    }];
    
    NSLog(@"%@",strM);
    
//    code = [NSString stringWithFormat:@"@property (nonatomic,%@) %@ *%@",code,polity,type,propertyName];
//    
//    
//    
    
}


@end
