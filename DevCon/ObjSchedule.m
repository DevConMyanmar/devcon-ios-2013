//
//  ObjSchedule.m
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import "ObjSchedule.h"
#import "AppDelegate.h"
@implementation ObjSchedule
@synthesize idx,timetick,speakerId,isFav,strTime,strTitle,strDescription,strSpeakerName,locationId,objSpeaker,objLocation;

- (ObjLocation *) getLocation{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    objLocation = [delegate.db getLocationById:locationId];
    return objLocation;
}

- (ObjSpeaker *) getSpeaker{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    objSpeaker = [delegate.db getSpeakerById:speakerId];
    return objSpeaker;
}
@end
