//
//  SWTableViewCell.h
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjSchedule.h"
@class SWTableViewCell;

@protocol SWTableViewCellDelegate <NSObject>

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)didSelectedTheCell:(SWTableViewCell *)cell;

@end

@interface SWTableViewCell : UITableViewCell
{
    /**** for Schedule cell ****/
    
    IBOutlet UILabel * lblVerticalStrip;
    IBOutlet UILabel * lblTitle;
    IBOutlet UILabel * lblSpeaker;
    IBOutlet UIButton * btnLocation;
    IBOutlet UILabel * lblTime;
    
    /**** end for Schedule cell ****/
}

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic) id <SWTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier height:(CGFloat)height leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

/**** for Schedule cell ****/
@property (nonatomic, strong) ObjSchedule * objSchedule;
- (void)loadTheViewWith:(ObjSchedule *)obj;
+ (CGFloat)heightForCellWithPost:(ObjSchedule *)obj;
- (CGFloat)heightForCellWithPureHeight:(ObjSchedule *)obj;
- (void) reloadTheScrollViewHeight:(float)cellHeight;
/**** end for Schedule cell ****/
@end

@interface NSMutableArray (SWUtilityButtons)

- (void)addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon;
- (void)addUtilityButtonWithColor:(UIColor *)color icon:(UIImage *)icon andTag:(int)tag;

@end
