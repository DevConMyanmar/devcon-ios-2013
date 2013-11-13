//
//  AppDelegate.m
//  DevCon
//
//  Created by Zayar on 10/7/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import "AppDelegate.h"
#import "devconAPIClient.h"
#import "ObjSpeaker.h"
#import "StringTable.h"
#import "Utility.h"
#import "ObjScheduleSpeaker.h"
#import "SVProgressHUD.h"
#import "UIColor+Expanded.h"
#import "GAI.h"
#import "Utility.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation AppDelegate
@synthesize databasePath,db;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.db = [[DBManager alloc] init];
	[self.db checkAndCreateDatabase];
    
    if ([Utility isGreaterOREqualOSVersion:@"7.0" ]) {
        self.window.tintColor = [UIColor colorWithHexString:@"D28029"];
    }
    
    /*// Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-45590085-1"];*/
    
    /*
     Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the method reachabilityChanged will be called.
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
	[self.internetReachability startNotifier];
	[self updateInterfaceWithReachability:self.internetReachability];

    return YES;
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
	[self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    
	if (reachability == self.internetReachability)
	{
		//[self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        BOOL connectionRequired = [reachability connectionRequired];
        //NSString* statusString = @"";
        if (netStatus == NotReachable) {
            self.isOnline = FALSE;
            NSLog(@"it is offline!!");
        }
        else{
            self.isOnline = TRUE;
            NSLog(@"it is online!!");
        }
        /*switch (netStatus)
        {
            case NotReachable:        {
                self.isOnline = FALSE;
                NSLog(@"")
                break;
            }
                
            case ReachableViaWWAN:        {
                self.isOnline = TRUE;
                break;
            }
            
        }
        
        
        if (connectionRequired)
        {
            NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
            statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
            NSLog(@"connection status %@",statusString);
        }*/
        
	}
}


- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            imageView.image = [UIImage imageNamed:@"stop-32.png"] ;
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
            
        case ReachableViaWWAN:        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            imageView.image = [UIImage imageNamed:@"WWAN5.png"];
            break;
        }
        case ReachableViaWiFi:        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            imageView.image = [UIImage imageNamed:@"Airport.png"];
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    textField.text= statusString;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self syncSpeaker];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)syncSpeaker{
    if(self.isOnline){
        [SVProgressHUD show];
        //[SVProgressHUD appearance].hudBackgroundColor = [UIColor whiteColor];
        //[SVProgressHUD appearance].hudRingBackgroundColor = [UIColor darkGrayColor];
        [[devconAPIClient sharedClient] getPath:[NSString stringWithFormat:@"%@",SPEAKER_LINK] parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
            NSLog(@"successfully return!!! %@",json);
            NSDictionary * dics = (NSDictionary *)json;
            
                NSArray *  arr = (NSArray *)dics;
            
                for(NSInteger i=0;i<[arr count];i++){
                    NSDictionary * dicNewsFeed = [arr objectAtIndex:i];
                    NSDictionary * dicSpeaker = [dicNewsFeed objectForKey:@"speaker"];
                    ObjSpeaker * objSpeaker = [[ObjSpeaker alloc]init];
                    if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"speaker_id"] shouldCleanWhiteSpace:YES])
                    objSpeaker.strServerId = [dicSpeaker objectForKey:@"speaker_id"];
                    else objSpeaker.strServerId = @"";
                    
                    if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"speaker_name"] shouldCleanWhiteSpace:YES])
                        objSpeaker.strSpeakerName = [dicSpeaker objectForKey:@"speaker_name"];
                    else objSpeaker.strSpeakerName = @"";
                    
                    if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"title"] shouldCleanWhiteSpace:YES])
                        objSpeaker.strJobTitle = [dicSpeaker objectForKey:@"title"];
                    else objSpeaker.strJobTitle = @"";
                    
                    if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"email"] shouldCleanWhiteSpace:YES])
                        objSpeaker.strEmail = [dicSpeaker objectForKey:@"email"];
                    else objSpeaker.strEmail = @"";
                    
                    if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"biography"] shouldCleanWhiteSpace:YES])
                        objSpeaker.strDescription = [dicSpeaker objectForKey:@"biography"];
                    else objSpeaker.strDescription = @"";
                    
                    if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"speaker_photo"] shouldCleanWhiteSpace:YES])
                        objSpeaker.strProfilePic = [dicSpeaker objectForKey:@"speaker_photo"];
                    else objSpeaker.strProfilePic = @"";
                    
                    [self saveORupdateSpeaker:objSpeaker];
                    
                }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshSpeakerView" object:nil];
            [SVProgressHUD dismiss];
            [self syncLocation];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error %@",error);
            [SVProgressHUD dismiss];
            //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        }];
    }
}

- (void)syncLocation{
    if(self.isOnline){
        [SVProgressHUD show];
        //[SVProgressHUD appearance].hudBackgroundColor = [UIColor whiteColor];
        //[SVProgressHUD appearance].hudRingBackgroundColor = [UIColor darkGrayColor];
        [[devconAPIClient sharedClient] getPath:[NSString stringWithFormat:@"%@",LOCATION_LINK] parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
            NSLog(@"successfully return!!! %@",json);
            NSDictionary * dics = (NSDictionary *)json;
            
            NSArray *  arr = (NSArray *)dics;
            
            for(NSInteger i=0;i<[arr count];i++){
                NSDictionary * dicNewsFeed = [arr objectAtIndex:i];
                NSDictionary * dicSpeaker = [dicNewsFeed objectForKey:@"location"];
                ObjLocation * obj = [[ObjLocation alloc]init];
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"location_id"] shouldCleanWhiteSpace:YES])
                    obj.strServerId = [dicSpeaker objectForKey:@"location_id"];
                else obj.strServerId = @"";
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"name"] shouldCleanWhiteSpace:YES])
                    obj.strName = [dicSpeaker objectForKey:@"name"];
                else obj.strName = @"";
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"desc"] shouldCleanWhiteSpace:YES])
                    obj.strDescription = [dicSpeaker objectForKey:@"desc"];
                else obj.strDescription = @"";
                
                obj.log = [[dicSpeaker objectForKey:@"long"] doubleValue];
                obj.lat = [[dicSpeaker objectForKey:@"lat"] doubleValue];
                
                /*if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"long"] shouldCleanWhiteSpace:YES])
                    obj.log = [[dicSpeaker objectForKey:@"long"] doubleValue];
                else obj.log = 0;
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"lat"] shouldCleanWhiteSpace:YES])
                    obj.lat = [[dicSpeaker objectForKey:@"lat"] doubleValue];
                else obj.lat = 0;*/
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"color"] shouldCleanWhiteSpace:YES])
                    obj.strColorHex = [dicSpeaker objectForKey:@"color"];
                else obj.strColorHex = @"";
                
                [self saveORupdateLocation:obj];
                [SVProgressHUD dismiss];
            }
            [self syncSchedule];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error %@",error);
            [SVProgressHUD dismiss];
            //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        }];
    }
}

- (void)syncSchedule{
    if(self.isOnline){
        [SVProgressHUD show];
        //[SVProgressHUD appearance].hudBackgroundColor = [UIColor whiteColor];
        //[SVProgressHUD appearance].hudRingBackgroundColor = [UIColor darkGrayColor];
        [[devconAPIClient sharedClient] getPath:[NSString stringWithFormat:@"%@",SCHEDULES_LINK] parameters:nil success:^(AFHTTPRequestOperation *operation, id json) {
            NSLog(@"successfully return!!! %@",json);
            NSDictionary * dics = (NSDictionary *)json;
            
            NSArray *  arr = (NSArray *)dics;
            
            for(NSInteger i=0;i<[arr count];i++){
                NSDictionary * dicNewsFeed = [arr objectAtIndex:i];
                NSDictionary * dicSpeaker = [dicNewsFeed objectForKey:@"schedule"];
                ObjSchedule * obj = [[ObjSchedule alloc]init];
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"schedule_id"] shouldCleanWhiteSpace:YES])
                    obj.strServerId = [dicSpeaker objectForKey:@"schedule_id"];
                else obj.strServerId = @"";
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"title"] shouldCleanWhiteSpace:YES])
                    obj.strTitle = [dicSpeaker objectForKey:@"title"];
                else obj.strTitle = @"";
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"description"] shouldCleanWhiteSpace:YES])
                    obj.strDescription = [dicSpeaker objectForKey:@"description"];
                else obj.strDescription = @"";
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"session_time"] shouldCleanWhiteSpace:YES])
                    obj.strTime = [dicSpeaker objectForKey:@"session_time"];
                else obj.strTime = @"";
                
                /*if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"speaker_id"] shouldCleanWhiteSpace:YES])
                {
                     obj.strSpeakerId = [dicSpeaker objectForKey:@"speaker_id"];
                    
                }
                else obj.strSpeakerId = 0;*/
                /*if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"speaker_ids"] shouldCleanWhiteSpace:YES])
                {
                    NSArray * arrSId = [dicSpeaker objectForKey:@"speaker_ids"];
                    NSLog(@"speaker arr count %d",[arrSId count]);
                    for(NSInteger y=0;y<[arrSId count];y++){
                        NSString * str = [arrSId objectAtIndex:y];
                        ObjScheduleSpeaker * objSchSpeaker = [[ObjScheduleSpeaker alloc] init];
                        objSchSpeaker.strScheduleId = obj.strServerId;
                        objSchSpeaker.strSpeakerId = str;
                        [self saveORupdateScheduleSpeaker:objSchSpeaker];
                        NSLog(@"speaker id%@",str);
                    }
                }*/
                //else obj.strSpeakerId = 0;
                NSArray * arrSId = [dicSpeaker objectForKey:@"speaker_ids"];
                NSLog(@"speaker arr count %d",[arrSId count]);
                for(NSInteger y=0;y<[arrSId count];y++){
                    NSString * str = [arrSId objectAtIndex:y];
                    ObjScheduleSpeaker * objSchSpeaker = [[ObjScheduleSpeaker alloc] init];
                    objSchSpeaker.strScheduleId = obj.strServerId;
                    objSchSpeaker.strSpeakerId = str;
                    [self saveORupdateScheduleSpeaker:objSchSpeaker];
                    NSLog(@"speaker id%@",str);
                }
                
                if(![Utility stringIsEmpty:[dicSpeaker objectForKey:@"location"] shouldCleanWhiteSpace:YES])
                {
                    obj.strLocationId = [dicSpeaker objectForKey:@"location"];
                    
                }
                else obj.strLocationId = 0;
                
                [self saveORupdateSchedule:obj];
                
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshScheduleView" object:nil];
            [SVProgressHUD dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error %@",error);
            [SVProgressHUD dismiss];
            //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        }];
    }
}

- (void) saveORupdateSpeaker:(ObjSpeaker *)obj{
    int i=[self.db checkSpeakerBy:obj.strServerId];
               if(i==0)
                   [self.db insertSpeakerBy:obj];
               else [self.db updateSpeakerBy:obj];
}

- (void) saveORupdateLocation:(ObjLocation *)obj{
    int i=[self.db checkLocationBy:obj.strServerId];
    if(i==0)
        [self.db insertLocationBy:obj];
    else [self.db updateLocationBy:obj];
}

- (void) saveORupdateSchedule:(ObjSchedule *)obj{
    int i=[self.db checkScheduleBy:obj.strServerId];
    if(i==0)
        [self.db insertScheduleBy:obj];
    else [self.db updateScheduleBy:obj];
}

- (void) saveORupdateScheduleSpeaker:(ObjScheduleSpeaker *)obj{
    int i=[self.db checkScheduleSpeakerBy:obj.strSpeakerId andSchedule:obj.strScheduleId];
    if(i==0)
        [self.db insertScheduleSpeakerBy:obj];
    else [self.db updateScheduleSpeakerBy:obj];
}

- (void) clickPopSoundPlay{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"dropdown" ofType:@"mp3"];
    //NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    /*if (audioPlayer == nil) {
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    }
    [audioPlayer prepareToPlay];
    [audioPlayer play];*/
    SystemSoundID soundID;
    
    //NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileURL ofType:@"caf"];
    NSURL *soundUrl = [NSURL fileURLWithPath:filePath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) clickPopSoundStop{
    [audioPlayer stop];
    audioPlayer = nil;
}

- (void) clickFavSoundPlay{
    NSString * fileFavPath = [[NSBundle mainBundle] pathForResource:@"fav" ofType:@"mp3"];
    /*NSURL *fileFavURL = [[NSURL alloc] initFileURLWithPath:fileFavPath];
    if (audioFavPlayer == nil) {
        audioFavPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileFavURL error:nil];
    }
    [audioFavPlayer prepareToPlay];
    [audioFavPlayer play];*/
    SystemSoundID soundID;
    
    //NSString *soundPath = [[NSBundle mainBundle] pathForResource:fileURL ofType:@"caf"];
    NSURL *soundUrl = [NSURL fileURLWithPath:fileFavPath];
    
    AudioServicesCreateSystemSoundID ((__bridge CFURLRef)soundUrl, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

- (void) clickFavSoundStop{
    [audioFavPlayer stop];
    audioFavPlayer = nil;
}

@end
