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
@synthesize idx,timetick,speakerId,isFav,strTime,strTitle,strDescription,strSpeakerName,locationId,objSpeaker,objLocation,strServerId,strSpeakerId,strLocationId,arrSpeaker;

- (ObjLocation *) getLocation{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    objLocation = [delegate.db getLocationById:locationId];
    return objLocation;
}

- (ObjLocation *) getLocationByStringID{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    NSLog(@"location server id %@",strLocationId);
    objLocation = [delegate.db getLocationByStringId:strLocationId];
    return objLocation;
}


- (ObjSpeaker *) getSpeaker{
    //AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    objSpeaker = [arrSpeaker objectAtIndex:0];
    return objSpeaker;
}

- (NSMutableArray *) getScheduleSpeaker{
    AppDelegate * delegate = [[UIApplication sharedApplication]delegate];
    //objSpeaker = [delegate.db getSpeakerById:speakerId];
    NSMutableArray * arr= [delegate.db getAllScheduleSpeakersBy:strServerId];
    if ([arr count]>0) {
        arrSpeaker = [[NSMutableArray alloc] initWithCapacity:[arr count]];
    }
    for (ObjScheduleSpeaker * objSchSpeak in arr) {
        NSLog(@"obj speaker id %@",objSchSpeak.strSpeakerId);
        ObjSpeaker * objS = [delegate.db getSpeakerByStringId:objSchSpeak.strSpeakerId];
        [arrSpeaker addObject:objS];
        NSLog(@"obj speaker name %@",objS.strSpeakerName);
    }
    return arrSpeaker;
}

- (NSString *) getSystemTimeOnlyByDate{
    NSString * strTime2;
    //2013-11-04T20:00:00Z
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    NSDate * date = [dateFormatter dateFromString:strTime];
    NSDateFormatter * dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter2 setDateFormat:@"HH:mma"];
    
    strTime2 = [dateFormatter2 stringFromDate:date];
    NSLog(@"time format only %@",strTime2);
    return strTime2;
}

- (NSString *) getSystemDateOnlyByDate{
    NSString * strTime2;
    //2013-11-04T20:00:00Z
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDate * date = [dateFormatter dateFromString:strTime];
    NSDateFormatter * dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter2 setDateFormat:@"MMMM dd,yyyy"];
    
    strTime2 = [dateFormatter2 stringFromDate:date];
    NSLog(@"time format only %@",strTime2);
    return strTime2;
}


@end
