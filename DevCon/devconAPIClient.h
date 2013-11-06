//
//  sampleTweetAPIClient.h
//  sampletweet
//
//  Created by Htain Lin Shwe on 12/3/13.
//  Copyright (c) 2013 comquas. All rights reserved.
//

#import "AFHTTPClient.h"

@interface devconAPIClient : AFHTTPClient
+ (devconAPIClient *)sharedClient;
@end