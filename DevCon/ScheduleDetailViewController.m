//
//  ScheduleDetailViewController.m
//  DevCon
//
//  Created by Zayar on 10/9/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import "ScheduleDetailViewController.h"
#import "UIImage+StackBlur.h"
#import "Utility.h"
@interface ScheduleDetailViewController ()
{
    IBOutlet UIImageView * imgViewProfileCover;
    IBOutlet UIImageView * imgViewProfile;
    IBOutlet UILabel * lblProfileName;
    IBOutlet UILabel * lblTitle;
    IBOutlet UILabel * lblDate;
    IBOutlet UILabel * lblTime;
    IBOutlet UITextView * txtViewDescription;
    
}
@end

@implementation ScheduleDetailViewController
@synthesize objSchedule;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadTheViewWith:objSchedule];
}

- (void)loadTheViewWith:(ObjSchedule *)obj{
    UIImage * image = [UIImage imageNamed:@"temp_profile"];
    imgViewProfileCover.image = [image stackBlur:10];
    
    //imgViewProfileCover.image = image;
    
    UIImage * image2 = [UIImage imageNamed:@"temp_profile"];
    [imgViewProfile setImage:image2];
    [Utility makeCornerRadius:imgViewProfile andRadius:imgViewProfile.frame.size.width/2];
    
    lblProfileName.text = obj.strSpeakerName;
    lblTitle.text = obj.strTitle;
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:obj.timetick];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMMM dd,yyyy"];
    NSString * strDate = [dateFormatter stringFromDate:date];
    lblDate.text =strDate;
    
    NSDateFormatter * dateFormatter2 = [[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm a"];
    NSString * strTime = [dateFormatter2 stringFromDate:date];
    lblTime.text =strTime;
    
    txtViewDescription.text = obj.strDescription;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
