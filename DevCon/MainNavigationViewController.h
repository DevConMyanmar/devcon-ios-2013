//
//  MainNavigationViewController.h
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulldownMenu.h"
@interface MainNavigationViewController : UINavigationController
<PulldownMenuDelegate> {
    PulldownMenu *pulldownMenu;
}

@property (nonatomic, retain) PulldownMenu *pulldownMenu;
- (void)animateDropDown;
@end
