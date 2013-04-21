//
//  PNRegisterCommand.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 20.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNCommand.h"


@interface PNRegisterCommand : PNCommand {

@protected
	NSString* appkey;
	NSString* deviceId;
	NSString* pushToken;
    NSArray*  requestParameters;
}

-(id)initWithConnection:(PNPushServerConnection *)pnconnection delegate:(id<PNRequestDelegate>)delegate parameters:(NSArray*) params;

@property (readwrite,copy) NSString* appkey;
@property (readwrite,copy) NSString* deviceId;
@property (readwrite,copy) NSString* pushToken;
@property (readwrite,retain) NSArray* requestParameters;

@end
