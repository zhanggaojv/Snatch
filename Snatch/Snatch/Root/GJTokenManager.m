//
//  GJTokenManager.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/9.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "GJTokenManager.h"
NSString *const TOKEN_KEY = @"token";
NSString *const Secr_Cet = @"sercet";
NSString *const USER_ACCOUNT=@"userAccount";
NSString *const USER_PASSWORD=@"userPassword";

@implementation GJTokenManager

//获得token
+(NSString *)accessToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:TOKEN_KEY];
    [userDefaults synchronize];
    return token;
}
//保存token
+(void)saveToken:(NSString *)token {
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:token forKey:TOKEN_KEY];
    [userDefaults synchronize];
}
//判断是否有可用的token
+(BOOL)hasAvalibleToken {
    
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    
    NSString *token = [userDefalts objectForKey:TOKEN_KEY];
    if (token) {
        
        return YES;
    }else{
        
        return NO;
        
    }

}
+(BOOL)removelibleToken{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:TOKEN_KEY];
    
    [defaults synchronize];
    
    return self;
}

//--------------userAccount-----------------
#pragma mark - 获取用户账号
+(NSString *)userAccount{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userAccount = [userDefaults objectForKey:USER_ACCOUNT];
    [userDefaults synchronize];
    return userAccount;
}

#pragma mark - 保存用户账号
+(void)saveUserAccount:(NSString *)account{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:account forKey:USER_ACCOUNT];
    [userDefaults synchronize];
}


#pragma mark - 判断是否有用户账号
+(BOOL)hasAvalibleUserAccount{
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    
    NSString *userAccount = [userDefalts objectForKey:USER_ACCOUNT];
    if (userAccount) {
        
        return YES;
    }else{
        
        return NO;
        
    }
   
}
#pragma mark - 清除用户账号
+(BOOL)removelibleUserAccount{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:USER_ACCOUNT];
    
    [defaults synchronize];
    
    return self;
}
//--------------userPassword-----------------
#pragma mark - 获取用户密码
+(NSString *)userPassword{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userPassword = [userDefaults objectForKey:USER_PASSWORD];
    [userDefaults synchronize];
    return userPassword;
}
#pragma mark - 保存用户密码
+(void)saveUserPassword:(NSString *)password{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:password forKey:USER_PASSWORD];
    [userDefaults synchronize];
}

#pragma mark - 判断是否有用户密码
+(BOOL)hasAvalibleUserPassword{
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    
    NSString *userPassword = [userDefalts objectForKey:USER_PASSWORD];
    if (userPassword) {
        
        return YES;
    }else{
        
        return NO;
        
    }
  
}
#pragma mark - 清除用户密码
+(BOOL)removelibleUserPassword{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:USER_PASSWORD];
    
    [defaults synchronize];
    
    return self;
    
}


#pragma mark - 获得企业sercet
+(NSString *)accessSercet{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *sercet = [userDefaults objectForKey:Secr_Cet];
    [userDefaults synchronize];
    return sercet;
    
}

#pragma mark - 保存TOKEN
+(void)saveSercet:(NSString *)sercet{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:sercet forKey:Secr_Cet];
    [userDefaults synchronize];
}

#pragma mark - 判断是否有TOKEN
+(BOOL)hasAvalibleSercet{
    
    NSUserDefaults *userDefalts = [NSUserDefaults standardUserDefaults];
    
    NSString *sercet = [userDefalts objectForKey:Secr_Cet];
    if (sercet) {
        
        return YES;
    }else{
        
        return NO;
        
    }
    
}

//异地登录
+(void)exit{
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"帐号异地登录！" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
//清空
#pragma mark - 清空本地的数据库数据
+(void)clearChuangquID{
    
}
//清空账号
+(void)clearChuangquRooter{
    
}

//清空密码；
+(void)clearChuangqupassword{
    
}

//清空
+(void)clearchuangquall{
    
}
///< name="code" class="objc">#pragma mark - 保存token
//
//NSDictionary *token = data[@“xxx"];
//                           
//                           [LXPTokenManager saveToken:token[@“xxx"]];
//                                                            [LXPTokenManager saveSercet:token[@“xxx"]];
//+(void)clearchuangquall{ NSUserDefaults *UserLoginState = [NSUserDefaults standardUserDefaults]; [UserLoginState removeObjectForKey:@“xxx"]; [UserLoginState synchronize]; NSUserDefaults *UserName = [NSUserDefaults standardUserDefaults]; [UserName removeObjectForKey:@"xxx"]; [UserName synchronize];
@end
