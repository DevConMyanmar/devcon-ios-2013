//
//  MainNavigationViewController.h
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulldownMenu.h"
@protocol MainNavigationViewControllerDelegate
-(void)menuItemSelected:(NSIndexPath *)indexPath;
-(void)pullDownAnimated:(BOOL)open;
@end
@interface MainNavigationViewController : UINavigationController
<PulldownMenuDelegate> {
    PulldownMenu *pulldownMenu;
    id<MainNavigationViewControllerDelegate> owner;
}
@property id<MainNavigationViewControllerDelegate> owner;
@property (nonatomic, retain) PulldownMenu *pulldownMenu;
- (void)animateDropDown;
- (BOOL) getPullMenuBOOl;
@end
