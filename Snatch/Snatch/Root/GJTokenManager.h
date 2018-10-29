//
//  GJTokenManager.h
//  Snatch
//
//  Created by Zhanggaoju on 16/10/9.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJTokenManager : NSObject

//--------------token-----------------

#pragma mark - 获得企业TOKEN
+(NSString *)accessToken;

#pragma mark - 保存TOKEN
+(void)saveToken:(NSString *)token;

#pragma mark - 判断是否有TOKEN
+(BOOL)hasAvalibleToken;

#pragma mark - 清除TOKEN
+(BOOL)removelibleToken;

//--------------userAccount-----------------
#pragma mark - 获取用户账号
+(NSString *)userAccount;

#pragma mark - 保存用户账号
+(void)saveUserAccount:(NSString *)account;

#pragma mark - 判断是否有用户账号
+(BOOL)hasAvalibleUserAccount;

#pragma mark - 清除用户账号
+(BOOL)removelibleUserAccount;

//--------------userPassword-----------------
#pragma mark - 获取用户密码
+(NSString *)userPassword;

#pragma mark - 保存用户密码
+(void)saveUserPassword:(NSString *)password;

#pragma mark - 判断是否有用户密码
+(BOOL)hasAvalibleUserPassword;

#pragma mark - 清除用户密码
+(BOOL)removelibleUserPassword;


//--------------accessSercet-----------------

#pragma mark - 获得企业sercet
+(NSString *)accessSercet;

#pragma mark - 保存企业sercet
+(void)saveSercet:(NSString *)sercet;

#pragma mark - 判断是否有企业sercet
+(BOOL)hasAvalibleSercet;

//异地登录
+(void)exit;
// 清空账号的id

+(void)clearChuangquID;
//清空账号
+(void)clearChuangquRooter;

//清空密码；
+(void)clearChuangqupassword;

//清空
+(void)clearchuangquall;

@end
