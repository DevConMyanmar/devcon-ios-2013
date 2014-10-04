//
//  ObjSpeaker.h
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjSpeaker : NSObject
@property int idx;
@property (nonatomic,retain) NSString * strSpeakerName;
@property (nonatomic,retain) NSString * strEmail;
@property (nonatomic,retain) NSString * strDescription;
@property (nonatomic,retain) NSString * strJobTitle;
@property (nonatomic,retain) NSString * strCompany;
@property (nonatomic,retain) NSString * strProfilePic;
@property (nonatomic,retain) NSString * strProfileCoverPic;
@property (nonatomic,retain) NSString * strServerId;
@property (nonatomic,retain) NSString * strSpeakerServerId;
@property (nonatomic,retain) NSString * strLocationServerId;
@end
