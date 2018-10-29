//
//  HttpCommunicateDefine.h
//  MumMum
//
//  Created by shlity on 16/6/16.
//  Copyright © 2016年 Moresing Inc. All rights reserved.
//

#ifndef GoddessClock_HttpCommunicateDefine_h
#define GoddessClock_HttpCommunicateDefine_h

typedef NS_ENUM (NSInteger , HttpResponseCode)
{
    HttpResponseOk = 0,
    HttpResponseError,
    HttpResponseLoginError,
    HttpResponseCnout
};


#define URL_BASE          @"http://www.duonisuoai.com"

//#define URL_BASE          @"http://192.168.1.105/"
//http后缀
typedef NS_ENUM(NSInteger,HTTP_COMMAND_LIST){
    //APP主接口
    HTTP_Home,
    HTTP_GetSystemInfo,
    HTTP_Image,
    HTTP_WX,
    HTTP_WXWeb,

    
    /*******************/
    HTTP_METHOD_RESERVE,
    HTTP_METHOD_COUNT
};

//#ifdef __ONLY_FOR_HTTP_COMMUNICATE__
//****************************************************************************/

static char cHttpMethod[HTTP_METHOD_COUNT][256] = {
    
    "/App/api",
    "/App/getSystemInfo",
    "/App/upLoadImage",
    "/pay/pay_weixin_app",
    "/pay/pay_weixin",
};

/*****************************************************************************/

typedef NS_ENUM(NSUInteger,ServiceStatusTypeDefine){
    
    ServiceStatusTypeWaitingDefine = 1,
    ServiceStatusTypeWorkingDefine,
    ServiceStatusTypeFinishedDefine,
    ServiceStatusTypeDefineCount,
};

#endif
