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
@end