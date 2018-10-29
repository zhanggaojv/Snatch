//
//  DocumentImage.m
//  Snatch
//
//  Created by Zhanggaoju on 2016/12/8.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "GJDocumentImage.h"

@implementation GJDocumentImage
//保存图片
+(void)saveImageDocuments:(UIImage *)image{
    //拿到图片
    UIImage *imagesave = image;
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
}
// 读取并存贮到相册
+(UIImage *)getDocumentImage{
    // 读取沙盒路径图片
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),@"test"];
    // 拿到沙盒路径图片
    UIImage *imgFromUrl=[[UIImage alloc]initWithContentsOfFile:aPath];
    return imgFromUrl;
}
+(UIImage *)getDocumentImageSaveImage{
    // 读取沙盒路径图片
    NSString *aPath=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),@"test"];
    // 拿到沙盒路径图片
    UIImage *imgFromUrl=[[UIImage alloc]initWithContentsOfFile:aPath];
    // 图片保存相册
    UIImageWriteToSavedPhotosAlbum(imgFromUrl, self, nil, nil);
    return imgFromUrl;
}
@end
