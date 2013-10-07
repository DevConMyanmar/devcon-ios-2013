//
//  AppDelegate.h
//  DevCon
//
//  Created by Zayar on 10/7/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString * databasePath;
    DBManager * db;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString * databasePath;
@property (nonatomic, strong) DBManager * db;
@end
