//
//  QuestionModel.h
//  WinTreasure
//
//  Created by Apple on 16/6/13.
//  Copyright © 2016年 linitial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (nonatomic, copy) NSString *question;

@property (nonatomic, strong) NSArray *answers;

@end
