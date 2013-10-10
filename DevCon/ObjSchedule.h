//
//  ObjSchedule.h
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjSpeaker.h"
#import "ObjSchedule.h"
#import "ObjLocation.h"
@interface ObjSchedule : NSObject
@property int idx;
@property int timetick;
@property int speakerId;
@property int isFav;
@property int locationId;
@property (nonatomic,strong) NSString * strTime;
@property (nonatomic,strong) NSString * strTitle;
@property (nonatomic,strong) NSString * strDescription;
@property (nonatomic,strong) NSString * strSpeakerName;
@property (nonatomic,strong) ObjSpeaker * objSpeaker;
@property (nonatomic,strong) ObjLocation * objLocation;
- (ObjLocation *) getLocation;
- (ObjSpeaker *) getSpeaker;
@end
