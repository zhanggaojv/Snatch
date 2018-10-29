//
//  DataMD5.m
//  WeChatDemo
//
//  Created by 尹俊雄 on 15/7/2.
//  Copyright (c) 2015年 yjx. All rights reserved.
//

#import "DataMD5.h"
#import <CommonCrypto/CommonDigest.h>
@interface DataMD5()
@property (nonatomic,strong) NSString *appid;
@property (nonatomic,strong) NSString *mch_id;
@property (nonatomic,strong) NSString *nonce_str;
@property (nonatomic,strong) NSString *partnerkey;
@property (nonatomic,strong) NSString *body;
@property (nonatomic,strong) NSString *out_trade_no;
@property (nonatomic,strong) NSString *total_fee;
@property (nonatomic,strong) NSString *spbill_create_ip;
@property (nonatomic,strong) NSString *notify_url;
@property (nonatomic,strong) NSString *trade_type;
@end

@implementation DataMD5
-(instancetype)initWithAppid:(NSString *)appid_key
                      mch_id:(NSString *)mch_id_key
                   nonce_str:(NSString *)noce_str_key
                  partner_id:(NSString *)partner_id
                        body:(NSString *)body_key
               out_trade_no :(NSString *)out_trade_no_key
                   total_fee:(NSString *)total_fee_key
            spbill_create_ip:(NSString *)spbill_create_ip_key
                  notify_url:(NSString *)notify_url_key
                  trade_type:(NSString *)trade_type_key{
    self = [super init];
    if (self) {
        _appid = appid_key;
        _mch_id = mch_id_key;
        _nonce_str = noce_str_key;
        _partnerkey = partner_id;
        _body = body_key;
        _out_trade_no = out_trade_no_key;
        _total_fee = total_fee_key;
        _spbill_create_ip = spbill_create_ip_key;
        _notify_url = notify_url_key;
        _trade_type = trade_type_key;
        
    }
    return self;
}
///获取sign签名
- (NSString *)getSignForMD5{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:_appid forKey:@"appid"];
    [dic setValue:_mch_id forKey:@"mch_id"];
    [dic setValue:_nonce_str forKey:@"nonce_str"];
    [dic setValue:_body forKey:@"body"];
    [dic setValue:_out_trade_no forKey:@"out_trade_no"];
    [dic setValue:_total_fee forKey:@"total_fee"];
    [dic setValue:_spbill_create_ip forKey:@"spbill_create_ip"];
    [dic setValue:_notify_url forKey:@"notify_url"];
    [dic setValue:_trade_type forKey:@"trade_type"];
    return [self createMd5Sign:dic];
}

//创建签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    
    
    
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@",@"TVMGtgPDrgZEPfxbUTOfag6fUkPm0UYL"];// _partnerkey];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

//创建发起支付时的sige签名
-(NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32*)timestamp_key {
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
//    [signParams setObject:timestamp_key forKey:@"timestamp"];
    [signParams setObject:[NSString stringWithFormat:@"%u",timestamp_key] forKey:@"timestamp"];
    
    
    
    
    
    NSLog(@"自己---------------> %@",signParams);
    
    NSMutableString *contentString  =[NSMutableString string];
    
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSLog(@"字母排序-------->%@",sortedArray);
    
    
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        //if(contentString.length>0)
        {
            
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
            NSLog(@"contentString--------------->%@",contentString);
        }
    }
    NSLog(@"拼接------------>%@",sortedArray);
    //添加商户密钥key字段
    
    [contentString appendFormat:@"key=%@", @"TVMGtgPDrgZEPfxbUTOfag6fUkPm0UYL"];
    
    NSLog(@"contentString-------------------->%@",contentString);
    
    
    NSLog(@"key------------->%@",contentString);
    NSString *result = [self md5:contentString];
    
    NSLog(@"result------------->%@",result);
    return result;
    
    
    
    
    
    
    
    
}


-(NSString *) md5:(NSString *)str
{

    
    
    const char *cStr = [str UTF8String];
   
    unsigned char result[16];
    
    
  
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    
    CC_MD5( cStr,[num intValue], result );
 
    
   
    return [[NSString stringWithFormat:
             
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            
             result[0], result[1], result[2], result[3],
            
             result[4], result[5], result[6], result[7],
             
             result[8], result[9], result[10], result[11],
             
             result[12], result[13], result[14], result[15]
             
             ] uppercaseString];


}

@end
