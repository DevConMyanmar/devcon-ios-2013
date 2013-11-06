//
//  DBManager.h
//  zBox
//
//  Created by Zayar Cn on 6/3/12.
//  Copyright (c) 2012 MCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ObjSpeaker.h"
#import "ObjLocation.h"
#import "ObjSchedule.h"
#import "ObjScheduleSpeaker.h"
@interface DBManager : NSObject{
    
}

- (void) checkAndCreateDatabase;
- (NSMutableArray *) getAllSchedules;
- (NSMutableArray *) getAllSpeakers;
- (ObjSpeaker *) getSpeakerById:(int)idx;
- (ObjLocation *) getLocationById:(int)idx;
- (void) updateScheduleFav:(int)idx andFav:(int)fav;
- (NSMutableArray *) getAllSchedulesByFav;
- (NSInteger) checkSpeakerBy:(NSString *)strId;
- (NSInteger) insertSpeakerBy:(ObjSpeaker *) obj;
- (NSInteger) updateSpeakerBy:(ObjSpeaker *) obj;
- (NSInteger) checkLocationBy:(NSString *)strId;
- (NSInteger) insertLocationBy:(ObjLocation *) obj;
- (NSInteger) updateLocationBy:(ObjLocation *) obj;
- (NSInteger) checkScheduleBy:(NSString *)strId;
- (NSInteger) insertScheduleBy:(ObjSchedule *) obj;
- (NSInteger) updateScheduleBy:(ObjSchedule *) obj;
- (NSInteger) checkScheduleSpeakerBy:(NSString *)strId andSchedule:(NSString *)strScheduleId;
- (NSInteger) insertScheduleSpeakerBy:(ObjScheduleSpeaker *) obj;
- (NSInteger) updateScheduleSpeakerBy:(ObjScheduleSpeaker *) obj;
- (NSMutableArray *) getAllScheduleSpeakersBy:(NSString *)strScheduleId;
- (ObjSpeaker *) getSpeakerByStringId:(NSString *)strServerId;
- (ObjLocation *) getLocationByStringId:(NSString *)strServerId;
@end
