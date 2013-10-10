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

@interface DBManager : NSObject{
    
}

- (void) checkAndCreateDatabase;
- (NSMutableArray *) getAllSchedules;
- (ObjSpeaker *) getSpeakerById:(int)idx;
- (ObjLocation *) getLocationById:(int)idx;
- (void) updateScheduleFav:(int)idx andFav:(int)fav;
@end
