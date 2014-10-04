//
//  ScheduleDetailViewController.h
//  DevCon
//
//  Created by Zayar on 10/9/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjSchedule.h"
@interface ScheduleDetailViewController : UIViewController
@property (nonatomic,strong) ObjSchedule * objSchedule;
- (CGFloat)heightOfViewWithPureHeight:(NSString *)str andFontName:(NSString *)strFont andFontSize:(float)fSize andMinimumSize:(float)mSize andWidth:(float)width;
@end
