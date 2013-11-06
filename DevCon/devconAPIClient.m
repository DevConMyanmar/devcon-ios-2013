
//  sampleTweetAPIClient.m
//  sampletweet
//
//  Created by Htain Lin Shwe on 12/3/13.
//  Copyright (c) 2013 comquas. All rights reserved.
//

#import "devconAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "StringTable.h"
//#import "Post.h"

//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://pos-nex.herokuapp.com/";
//static NSString * const kAFAppDotNetAPIBaseURLString = @"http://192.168.0.100:3000/";

//Pet Nex UAT
static NSString * const kAFAppDotNetAPIBaseURLString = @"http://devconmyanmar.herokuapp.com/";

@implementation devconAPIClient
+ (devconAPIClient *)sharedClient {
    static devconAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[devconAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAFAppDotNetAPIBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
