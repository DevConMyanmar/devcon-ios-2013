//
//  ObjLocation.h
//  DevCon
//
//  Created by Zayar on 10/8/13.
//  Copyright (c) 2013 devcon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjLocation : NSObject
@property int idx;
@property float lat;
@property float log;
@property (nonatomic,retain) NSString * strName;
@property (nonatomic,retain) NSString * strColorHex;
@property (nonatomic,retain) NSString * strDescription;
@end
