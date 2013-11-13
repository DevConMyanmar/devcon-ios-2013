//
//  AppDelegate.h
//  DevCon
//
//  Created by Zayar on 10/7/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString * databasePath;
    DBManager * db;
    AVAudioPlayer *audioPlayer;
    AVAudioPlayer *audioFavPlayer;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSString * databasePath;
@property (nonatomic, strong) DBManager * db;
@property BOOL isOnline;
@property (nonatomic) Reachability *internetReachability;

- (void) clickPopSoundPlay;
- (void) clickFavSoundPlay;
- (void) clickPopSoundStop;
- (void) clickFavSoundStop;
@end
