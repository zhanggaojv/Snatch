//
//  WSHttpCache.h
//  Snatch
//
//  Created by 袁伟森 on 2016/9/27.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSHttpCache : NSObject

/**
 *  手动写入/更新缓存
 *
 *  @param jsonResponse 要写入的数据
 *  @param URL    请求URL
 *
 *  @return 是否写入成功
 */
+(BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL;

/**
 *  获取缓存的对象
 *
 *  @param URL 请求URL
 *
 *  @return 缓存对象
 */
+(id )cacheJsonWithURL:(NSString *)URL;


@end
