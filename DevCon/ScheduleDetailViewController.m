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
#import "NavFavBarButton.h"
#import "AppDelegate.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FXBlurView.h"
@interface ScheduleDetailViewController ()
{
    IBOutlet UIImageView * imgViewProfileCover;
    IBOutlet UIImageView * imgViewProfile;
    IBOutlet UILabel * lblProfileName;
    IBOutlet UILabel * lblTitle;
    IBOutlet UILabel * lblDate;
    IBOutlet UILabel * lblTime;
    IBOutlet UILabel * lblBgTitle;
    IBOutlet UILabel * lblSperator1;
    IBOutlet UILabel * lblSperator2;
    
    IBOutlet UITextView * txtViewDescription;
    IBOutlet UIScrollView * scrollDetail;
    NavFavBarButton *btnFav;
}
@property (nonatomic, weak) IBOutlet FXBlurView *blurView;
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
    txtViewDescription.scrollEnabled = NO;
    btnFav = [[NavFavBarButton alloc] init];
    [btnFav addTarget:self action:@selector(onFav:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * favButton = [[UIBarButtonItem alloc] initWithCustomView:btnFav];
    self.navigationItem.rightBarButtonItem = favButton;
    
}

- (void)onFav:(NavFavBarButton *)sender{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    if (objSchedule.isFav == 0) {
        [sender setFavImage:YES];
        objSchedule.isFav = 1;
        [delegate.db updateScheduleFav:objSchedule.idx andFav:objSchedule.isFav];
    }
    else if (objSchedule.isFav == 1){
        [sender setFavImage:NO];
        objSchedule.isFav = 0;
        [delegate.db updateScheduleFav:objSchedule.idx andFav:objSchedule.isFav];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self loadTheViewWith:objSchedule];
    
    if (objSchedule.isFav == 0) {
        [btnFav setFavImage:NO];
    }
    else if(objSchedule.isFav == 1){
        [btnFav setFavImage:YES];
    }
}

- (void)loadTheViewWith:(ObjSchedule *)obj{
    UIImage * imageProfileDefault = [UIImage imageNamed:@"zawym.png"];
    //[imgViewProfileCover setImageWithURL:[NSURL URLWithString:obj.objSpeaker.strProfilePic] placeholderImage:imageProfileDefault];
    //mgViewProfileCover.image = [imgViewProfileCover.image stackBlur:10];
    /*[imgViewProfileCover setImageWithURLRequest:[NSURL URLWithString:obj.objSpeaker.strProfilePic] placeholderImage:imageProfileDefault success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        imgViewProfileCover.image = [image stackBlur:10];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
    }];*/
     
    
    //imgViewProfileCover.image = image;
    imgViewProfileCover.image = [imageProfileDefault stackBlur:10];
    [imgViewProfileCover setImageWithURL:[NSURL URLWithString:obj.objSpeaker.strProfilePic] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
     {

     }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
        
         //imgViewProfileCover.image = [imageProfileDefault stackBlur:10];
         [self setCoverPhoto:image];
     }];
    
    
    UIImage * image2 = [UIImage imageNamed:@"img_profile_default"];
    [imgViewProfile setImageWithURL:[NSURL URLWithString:obj.objSpeaker.strProfilePic] placeholderImage:image2];
    [imgViewProfile setImage:image2];
    [Utility makeCornerRadius:imgViewProfile andRadius:imgViewProfile.frame.size.width/2];
    lblProfileName.text = obj.objSpeaker.strSpeakerName;
    
    float titleHeight = [self heightOfViewWithPureHeight:obj.strTitle andFontName:@"Avenir Next Medium" andFontSize:16.0f andMinimumSize:30 andWidth:299];
    CGRect newTitleFrame = lblTitle.frame;
    newTitleFrame.size.height = titleHeight;
    lblTitle.frame = newTitleFrame;
    lblTitle.text = obj.strTitle;
    
    float speratorHieght = 0.5f;
    CGRect newSperator1Frame = lblSperator1.frame;
    newSperator1Frame.origin.y = newTitleFrame.origin.y + newTitleFrame.size.height + 3;
    newSperator1Frame.size.height = speratorHieght;
    lblSperator1.frame = newSperator1Frame;
    
    CGRect newDateFrame = lblDate.frame;
    newDateFrame.origin.y = newSperator1Frame.origin.y  + newSperator1Frame.size.height + 9;
    lblDate.frame = newDateFrame;
    
    CGRect newTimeFrame = lblTime.frame;
    newTimeFrame.origin.y = newSperator1Frame.origin.y  + newSperator1Frame.size.height + 11;
    lblTime.frame = newTimeFrame;
    
    CGRect newSperator2Frame = lblSperator2.frame;
    newSperator2Frame.origin.y = newDateFrame.origin.y + newDateFrame.size.height + 7;
    newSperator2Frame.size.height = speratorHieght;
    lblSperator2.frame = newSperator2Frame;
    
    CGRect newBgFrame = lblBgTitle.frame;
    newBgFrame.size.height -= 30;
    newBgFrame.size.height += newTitleFrame.size.height;
    lblBgTitle.frame = newBgFrame;
    
    //NSDate * date = [NSDate dateWithTimeIntervalSince1970:obj.timetick];
    //NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"MMMM dd,yyyy"];
    //NSString * strDate = [dateFormatter stringFromDate:date];
    lblDate.text =[obj getSystemDateOnlyByDate];
    
    //NSDateFormatter * dateFormatter2 = [[NSDateFormatter alloc]init];
    //[dateFormatter2 setDateFormat:@"HH:mma"];
    //NSString * strTime = [dateFormatter2 stringFromDate:date];
    lblTime.text =[obj getSystemTimeOnlyByDate];
    
    CGRect newTextViewFrame = txtViewDescription.frame;
    newTextViewFrame.origin.y = newSperator2Frame.origin.y + newSperator2Frame.size.height + 7;
    float newTextHeight = [self heightOfViewWithPureHeight:obj.strDescription andFontName:@"Avenir Next Medium" andFontSize:14.0f andMinimumSize:282 andWidth:299];
    newTextViewFrame.size.height = newTextHeight;
    txtViewDescription.frame = newTextViewFrame;
    txtViewDescription.text = obj.strDescription;
    
    [scrollDetail setContentSize:CGSizeMake(320, txtViewDescription.frame.origin.y + txtViewDescription.frame.size.height)];
}

- (void) setCoverPhoto:(UIImage *)image{
    UIImage * imagePro = [[UIImage alloc] init];
    imagePro = image;
    [imgViewProfileCover setImage:imagePro];
    self.blurView.blurRadius = 10;
}

- (CGFloat)heightOfViewWithPureHeight:(NSString *)str andFontName:(NSString *)strFont andFontSize:(float)fSize andMinimumSize:(float)mSize andWidth:(float)width{
    CGSize sizeToFit = [str sizeWithFont:[UIFont fontWithName:strFont size:fSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    return fmaxf(mSize, sizeToFit.height+5);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
