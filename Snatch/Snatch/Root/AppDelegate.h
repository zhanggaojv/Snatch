//
//  AppDelegate.h
//  Snatch
//
//  Created by Zhanggaoju on 16/9/21.
//  Copyright © 2016年 Zhanggaoju. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BillViewController.h"
#import <CoreData/CoreData.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tab;

@property (nonatomic,strong) NSString *token;

@property (nonatomic,strong) NSDictionary *SystemInfoData;

@property (nonatomic,strong) NSString *version;


-(void)setWindowRootViewController;



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

@end
