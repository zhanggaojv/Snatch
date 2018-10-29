//
//  silderMode.m
//  Snatch
//
//  Created by Zhanggaoju on 16/9/28.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import "silderMode.h"

@implementation silderMode

-(void)setPath:(NSString *)path{
    
    _imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",path]];
    
}

@end
