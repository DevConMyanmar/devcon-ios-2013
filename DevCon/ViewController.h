//
//  ViewController.h
//  DevCon
//
//  Created by Zayar on 10/7/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PulldownMenu.h"
@interface ViewController : UIViewController<PulldownMenuDelegate>{
    PulldownMenu *pulldownMenu;
}

@end
