//
//  DocumentImage.h
//  Snatch
//
//  Created by Zhanggaoju on 2016/12/8.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GJDocumentImage : NSObject
//保存图片
+(void)saveImageDocuments:(UIImage *)image;

// 读取图片
+(UIImage *)getDocumentImage;
// 读取并存贮到相册
+(UIImage *)getDocumentImageSaveImage;

@end
