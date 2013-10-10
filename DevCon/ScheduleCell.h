//
//  ScheduleCell.h
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjSchedule.h"
#import "SWTableViewCell.h"

@interface ScheduleCell : UITableViewCell
{
    IBOutlet UILabel * lblVerticalStrip;
    IBOutlet UILabel * lblTitle;
    IBOutlet UILabel * lblSpeaker;
    IBOutlet UIButton * btnLocation;
    IBOutlet UILabel * lblTime;
}
@property (nonatomic, strong) ObjSchedule * objSchedule;

- (void)loadTheViewWith:(ObjSchedule *)obj;
+ (CGFloat)heightForCellWithPost:(ObjSchedule *)obj;
- (CGFloat)heightForCellWithPureHeight:(ObjSchedule *)obj;
@end
