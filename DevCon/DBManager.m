//
//  DBManager.m
//  zBox
//
//  Created by Zayar Cn on 6/3/12.
//  Copyright (c) 2012 MCC. All rights reserved.
//

#import "DBManager.h"
#import "StringTable.h"
#import "AppDelegate.h"
#import "ObjSchedule.h"
#import "ObjSpeaker.h"
#import "ObjLocation.h"
#import "ObjScheduleSpeaker.h"
@implementation DBManager

- (void) checkAndCreateDatabase{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString * databasePath = [documentsDir stringByAppendingPathComponent: DBNAME];
	
	NSLog(@"checking at %@", databasePath);
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success){
		NSLog(@"db found");
		delegate.databasePath = databasePath;
		return;
	}
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DBNAME];
	
	NSLog(@"copying db...");
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];	
	
	
	delegate.databasePath = databasePath;
	
	NSLog(@"db transfered!");
}

- (NSMutableArray *) getAllSchedules{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	NSMutableArray * list = [[NSMutableArray alloc] init];
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM talks";
        //const char *sqlStatement = "SELECT * FROM tbl_reminder";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            //sqlite3_bind_int(compiledStatement, 1, catId);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                ObjSchedule * obj = [[ObjSchedule alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strTime = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil ){
                    obj.strTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strTitle = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil ){
                    obj.strTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                obj.strSpeakerName = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 3) != nil ){
                    obj.strSpeakerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                obj.strDescription = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 4) != nil ){
                    obj.strDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                obj.isFav = sqlite3_column_int(compiledStatement, 5);
                
                obj.speakerId = sqlite3_column_int(compiledStatement, 6);
                
                obj.timetick = sqlite3_column_int(compiledStatement, 7);
                
                obj.locationId = sqlite3_column_int(compiledStatement, 8);
                
                obj.strServerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 9) != nil){
                    obj.strServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                }
                
                obj.strSpeakerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 10) != nil){
                    obj.strSpeakerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                obj.strLocationId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 11) != nil){
                    obj.strLocationId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                
                
                [list addObject: obj];
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return list;
}

- (NSMutableArray *) getAllSchedulesByFav{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	NSMutableArray * list = [[NSMutableArray alloc] init];
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM talks WHERE fav = 1";
        //const char *sqlStatement = "SELECT * FROM tbl_reminder";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            //sqlite3_bind_int(compiledStatement, 1, catId);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                ObjSchedule * obj = [[ObjSchedule alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strTime = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil ){
                    obj.strTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strTitle = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil ){
                    obj.strTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                obj.strSpeakerName = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 3) != nil ){
                    obj.strSpeakerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                obj.strDescription = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 4) != nil ){
                    obj.strDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                obj.isFav = sqlite3_column_int(compiledStatement, 5);
                
                obj.speakerId = sqlite3_column_int(compiledStatement, 6);
                
                obj.timetick = sqlite3_column_int(compiledStatement, 7);
                
                obj.locationId = sqlite3_column_int(compiledStatement, 8);
                
                obj.strServerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 9) != nil){
                    obj.strServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 9)];
                }
                
                obj.strSpeakerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 10) != nil){
                    obj.strSpeakerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 10)];
                }
                
                obj.strLocationId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 11) != nil){
                    obj.strLocationId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 11)];
                }
                
                [list addObject: obj];
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return list;
}

- (NSMutableArray *) getAllSpeakers{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	NSMutableArray * list = [[NSMutableArray alloc] init];
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM speakers";
        //const char *sqlStatement = "SELECT * FROM tbl_reminder";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            //sqlite3_bind_int(compiledStatement, 1, catId);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                ObjSpeaker * obj = [[ObjSpeaker alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strSpeakerName = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil){
                    obj.strSpeakerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strDescription = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil){
                    obj.strDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                obj.strEmail = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 3) != nil){
                    obj.strEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                obj.strJobTitle = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 4) != nil){
                    obj.strJobTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                obj.strCompany = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 5) != nil){
                    obj.strCompany = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                obj.strProfilePic = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 6) != nil){
                    obj.strProfilePic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                obj.strProfileCoverPic = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 7) != nil){
                    obj.strProfileCoverPic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                obj.strServerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 8) != nil){
                    obj.strServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
                
                [list addObject: obj];
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return list;
}

- (NSMutableArray *) getAllScheduleSpeakersBy:(NSString *)strScheduleId{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	NSMutableArray * list = [[NSMutableArray alloc] init];
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM talk_speaker WHERE talk_id=?";
        //const char *sqlStatement = "SELECT * FROM tbl_reminder";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(compiledStatement, 1, [strScheduleId UTF8String], -1, SQLITE_TRANSIENT);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                ObjScheduleSpeaker * obj = [[ObjScheduleSpeaker alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strSpeakerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil){
                    obj.strSpeakerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strScheduleId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil){
                    obj.strScheduleId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                [list addObject: obj];
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return list;
}

- (ObjSpeaker *) getSpeakerById:(int)idx{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	ObjSpeaker * obj;
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM speakers WHERE _id = ?";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(compiledStatement, 1, idx);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                obj = [[ObjSpeaker alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strSpeakerName = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil){
                    obj.strSpeakerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strDescription = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil){
                    obj.strDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                obj.strEmail = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 3) != nil){
                    obj.strEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                obj.strJobTitle = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 4) != nil){
                    obj.strJobTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                obj.strCompany = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 5) != nil){
                    obj.strCompany = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                obj.strProfilePic = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 6) != nil){
                    obj.strProfilePic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                obj.strProfileCoverPic = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 7) != nil){
                    obj.strProfileCoverPic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                obj.strServerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 8) != nil){
                    obj.strServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return obj;
}

- (ObjSpeaker *) getSpeakerByStringId:(NSString *)strServerId{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	ObjSpeaker * obj;
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM speakers WHERE server_id = ?";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(compiledStatement, 1, [strServerId UTF8String], -1, SQLITE_TRANSIENT);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                obj = [[ObjSpeaker alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strSpeakerName = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil){
                    obj.strSpeakerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strDescription = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil){
                    obj.strDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                obj.strEmail = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 3) != nil){
                    obj.strEmail = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
                }
                
                obj.strJobTitle = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 4) != nil){
                    obj.strJobTitle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
                }
                
                obj.strCompany = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 5) != nil){
                    obj.strCompany = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                obj.strProfilePic = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 6) != nil){
                    obj.strProfilePic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
                
                obj.strProfileCoverPic = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 7) != nil){
                    obj.strProfileCoverPic = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
                }
                
                obj.strServerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 8) != nil){
                    obj.strServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
                }
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return obj;
}

- (ObjLocation *) getLocationById:(int)idx{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	ObjLocation * obj;
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM location WHERE _id = ?";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_int(compiledStatement, 1, idx);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                obj = [[ObjLocation alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strName = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil){
                    obj.strName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strDescription = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil){
                    obj.strDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                obj.log = sqlite3_column_double(compiledStatement, 3);
                
                obj.lat = sqlite3_column_double(compiledStatement, 4);
                
                obj.strColorHex = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 5) != nil){
                    obj.strColorHex = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                obj.strServerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 6) != nil){
                    obj.strServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return obj;
}

- (ObjLocation *) getLocationByStringId:(NSString *)strServerId{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	sqlite3 *database;
	ObjLocation * obj;
	
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        
        const char *sqlStatement = "SELECT * FROM location WHERE server_id = ?";
        
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
            sqlite3_bind_text(compiledStatement, 1, [strServerId UTF8String], -1, SQLITE_TRANSIENT);
            
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                obj = [[ObjLocation alloc] init];
                
                obj.idx = sqlite3_column_int(compiledStatement, 0);
                
                obj.strName = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 1) != nil){
                    obj.strName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                }
                
                obj.strDescription = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 2) != nil){
                    obj.strDescription = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                }
                
                obj.log = sqlite3_column_double(compiledStatement, 3);
                
                obj.lat = sqlite3_column_double(compiledStatement, 4);
                
                obj.strColorHex = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 5) != nil){
                    obj.strColorHex = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
                }
                
                obj.strServerId = @"";
                if( (char *)sqlite3_column_text(compiledStatement, 6) != nil){
                    obj.strServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
                }
            }
        }
        
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database);
    
	return obj;
}

- (void) updateScheduleFav:(int)idx andFav:(int)fav{
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    sqlite3 *database;
	sqlite3_stmt * update_statment;
	
	if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sql = "UPDATE talks SET fav = ? WHERE _id = ?";
		if (sqlite3_prepare_v2(database, sql, -1, &update_statment, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        sqlite3_bind_int(update_statment, 1, fav);
        
		sqlite3_bind_int(update_statment, 2, idx);
        int success = sqlite3_step(update_statment);
		
		if (success != SQLITE_DONE) {
			NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(database));
		}
        //NSLog(@"update statement for this %s ",update_statment);
        sqlite3_reset(update_statment);
	}
	
	sqlite3_close(database);
}

- (NSInteger) checkSpeakerBy:(NSString *)strId{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
	sqlite3 *database;
	NSInteger total=0;
	
	if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT count(*) FROM speakers WHERE server_id = ?";
        
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            sqlite3_bind_text(compiledStatement, 1, [strId UTF8String], -1, SQLITE_TRANSIENT);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				total = sqlite3_column_int(compiledStatement, 0);
                
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	
	return total;
}

- (NSInteger) insertSpeakerBy:(ObjSpeaker *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "INSERT INTO speakers(s_name,s_desc,s_email,job_title,company,profile_pic,profile_cover_pic,server_id) VALUES(?,?,?,?,?,?,?,?)";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strSpeakerName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strDescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 3, [obj.strEmail UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 4, [obj.strJobTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 5, [obj.strCompany UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 6, [obj.strProfilePic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 7, [obj.strProfileCoverPic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 8, [obj.strServerId UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"speaker inserted!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
    
    
}

- (NSInteger) updateSpeakerBy:(ObjSpeaker *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "UPDATE speakers SET s_name=?, s_desc=?,s_email=?,job_title=?,company=?,profile_pic=?,profile_cover_pic=? WHERE server_id=?";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strSpeakerName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strDescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 3, [obj.strEmail UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 4, [obj.strJobTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 5, [obj.strCompany UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 6, [obj.strProfilePic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 7, [obj.strProfileCoverPic UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 8, [obj.strServerId UTF8String], -1, SQLITE_TRANSIENT);
        
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"character updated!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
    
}

- (NSInteger) checkLocationBy:(NSString *)strId{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
	sqlite3 *database;
	NSInteger total=0;
	
	if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT count(*) FROM location WHERE server_id = ?";
        
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            sqlite3_bind_text(compiledStatement, 1, [strId UTF8String], -1, SQLITE_TRANSIENT);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				total = sqlite3_column_int(compiledStatement, 0);
                
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	
	return total;
}

- (NSInteger) insertLocationBy:(ObjLocation *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "INSERT INTO location(name,description,long,lat,color,server_id) VALUES(?,?,?,?,?,?)";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strDescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(insert_statement, 3, obj.log);
        sqlite3_bind_double(insert_statement, 4, obj.lat);
        sqlite3_bind_text(insert_statement, 5, [obj.strColorHex UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 6, [obj.strServerId UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"location inserted!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
}

- (NSInteger) updateLocationBy:(ObjLocation *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "UPDATE location SET name=?, description=?,long=?,lat=?,color=? WHERE server_id=?";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strName UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strDescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(insert_statement, 3, obj.log);
        sqlite3_bind_double(insert_statement, 4, obj.lat);
        sqlite3_bind_text(insert_statement, 5, [obj.strColorHex UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 6, [obj.strServerId UTF8String], -1, SQLITE_TRANSIENT);
        
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"location updated!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
    
}

- (NSInteger) checkScheduleBy:(NSString *)strId{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
	sqlite3 *database;
	NSInteger total=0;
	
	if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT count(*) FROM talks WHERE server_id = ?";
        
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            sqlite3_bind_text(compiledStatement, 1, [strId UTF8String], -1, SQLITE_TRANSIENT);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				total = sqlite3_column_int(compiledStatement, 0);
                
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	
	return total;
}

- (NSInteger) insertScheduleBy:(ObjSchedule *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "INSERT INTO talks(time,title,desc,timetick,server_id,speaker_server_id,location_server_id) VALUES(?,?,?,?,?,?,?)";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 3, [obj.strDescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(insert_statement, 4, obj.timetick);
        
        sqlite3_bind_text(insert_statement, 5, [obj.strServerId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 6, [obj.strSpeakerId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 7, [obj.strLocationId UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"location inserted!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
}

- (NSInteger) updateScheduleBy:(ObjSchedule *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "UPDATE talks SET time = ?,title = ?,desc = ?,timetick= ?,speaker_server_id = ?,location_server_id = ? WHERE server_id=?";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strTime UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strTitle UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 3, [obj.strDescription UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(insert_statement, 4, obj.timetick);
        
        sqlite3_bind_text(insert_statement, 5, [obj.strSpeakerId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 6, [obj.strLocationId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 7, [obj.strServerId UTF8String], -1, SQLITE_TRANSIENT);
        
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"location updated!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
    
}

- (NSInteger) checkScheduleSpeakerBy:(NSString *)strId andSchedule:(NSString *)strScheduleId{
    
	AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
	sqlite3 *database;
	NSInteger total=0;
	
	if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = "SELECT count(*) FROM talk_speaker WHERE speaker_id = ? AND talk_id=?";
        
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			
            sqlite3_bind_text(compiledStatement, 1, [strId UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(compiledStatement, 2, [strScheduleId UTF8String], -1, SQLITE_TRANSIENT);
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				total = sqlite3_column_int(compiledStatement, 0);
                
			}
		}
		
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
	
	return total;
}

- (NSInteger) insertScheduleSpeakerBy:(ObjScheduleSpeaker *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "INSERT INTO talk_speaker(speaker_id,talk_id) VALUES(?,?)";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strSpeakerId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strScheduleId UTF8String], -1, SQLITE_TRANSIENT);
		
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"talk_speaker inserted!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
}

- (NSInteger) updateScheduleSpeakerBy:(ObjScheduleSpeaker *) obj{
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSInteger result;
	BOOL opSuccessful = FALSE;
    
    sqlite3 *database;
    sqlite3_stmt * insert_statement;
    
    if(sqlite3_open([delegate.databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "UPDATE talk_speaker SET speaker_id = ?, talk_id=? WHERE speaker_id=? AND talk_id=?";
        
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
			NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
		}
        
        sqlite3_bind_text(insert_statement, 1, [obj.strSpeakerId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 2, [obj.strScheduleId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 3, [obj.strSpeakerId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert_statement, 4, [obj.strScheduleId UTF8String], -1, SQLITE_TRANSIENT);
        
		int success = sqlite3_step(insert_statement);
		
		sqlite3_reset(insert_statement);
		if (success != SQLITE_ERROR) {
			NSLog(@"talk_speaker updated!");
			result = sqlite3_last_insert_rowid(database);
			opSuccessful = TRUE;
		}
		
		sqlite3_finalize(insert_statement);
    }
    if( opSuccessful ){
		sqlite3_close(database);
		
		return result;
	}
	
	NSAssert1(0, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
	sqlite3_close(database);
	
	return -1;
    
}

@end