//
//  GJVideoFunctions.m
//  Snatch
//
//  Created by Zhanggaoju on 16/10/8.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "GJVideoFunctions.h"
#import "GJConstants.h"

@implementation GJVideoFunctions
#pragma mark - Video URL

+(NSDictionary *)getUrlInfo{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"GJVideoController-Info" ofType:@"plist"];
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:plistPath];
    return dict;
}

+(NSString *) getVideoUrl{
    
    NSString *videoUrl;
    
    if (IS_IPHONE_5) {
        videoUrl=[NSString stringWithFormat:@"%@-568h",[[GJVideoFunctions getUrlInfo] objectForKey:@"VideoUrl"]];
    }else{
        videoUrl = [[GJVideoFunctions getUrlInfo] objectForKey:@"Video"];
    }
    
    return videoUrl;
    
}

+(NSString *) getVideoType{
    return [[GJVideoFunctions getUrlInfo] objectForKey:@"Type"];
}

+(BOOL) getLoopMode{
    return [[[GJVideoFunctions getUrlInfo] objectForKey:@"Mode Loop"] boolValue];
}

@end
