//
//  PNUnregisterCommand.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 27.11.12.
//  Copyright (c) 2012 EagleEye. All rights reserved.
//

#import "PNCommand.h"

@interface PNUnregisterCommand : PNCommand
{
@protected
	NSString* appkey;
	NSString* deviceId;
    NSArray*  requestParameters;
}
-(id)initWithConnection:(PNPushServerConnection *)pnconnection delegate:(id<PNRequestDelegate>)delegate parameters:(NSArray*) params;


@property (readwrite,copy) NSString* appkey;
@property (readwrite,copy) NSString* deviceId;
@property (readwrite,retain) NSArray* requestParameters;
@end
