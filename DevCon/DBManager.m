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

@end