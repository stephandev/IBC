//
//  PNUnregisterCommand.m
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 27.11.12.
//  Copyright (c) 2012 EagleEye. All rights reserved.
//

#import "PNUnregisterCommand.h"
#import "SBJsonWriter.h"
#import "PNRequestProperty.h"

@class PNRequestProperty;

@implementation PNUnregisterCommand

@synthesize appkey;
@synthesize deviceId;
@synthesize requestParameters;

-(id)initWithConnection:(PNPushServerConnection *)pnconnection delegate:(id<PNRequestDelegate>)delegate
{
    self = [super initWithConnection:pnconnection delegate:delegate];
    if(self)
		serverUrl = [[NSString alloc] initWithFormat: @"%@/client/register", [pnconnection serverUrl]];
    
    return self;
}

-(id)initWithConnection:(PNPushServerConnection *)pnconnection delegate:(id<PNRequestDelegate>)delegate parameters:(NSArray *)params
{
    self =  [self initWithConnection:pnconnection delegate:delegate];
    if(self)
        [self setRequestParameters:params];
    
    return self;
}

-(void)dealloc
{
    NSLog(@"PNUnregisterCommand dealoc");
    
    // [appkey release];
    // [deviceId release];
    // [pushToken release];
    [httpMethod release];
    [requestParameters release];
    
    [super dealloc];
}


-(Boolean)createRequest
{
	NSMutableDictionary* dir = [[NSMutableDictionary alloc] init];
	//"{\"deviceid\":123,\"pushtoken\":\"möp\",\"devicetype\":1000,\"appkey\":\"testApp\"}"
    
	if(requestParameters)
    {
        for (PNRequestProperty* prop in requestParameters) 
        {
            [dir setObject:[prop value] forKey:[prop key]];
        }
    }
    [dir setObject:deviceId forKey:@"deviceid"];
	[dir setObject:[pnConnection  appkey] forKey:@"appkey"];
	
	SBJsonWriter* json = [[SBJsonWriter alloc] init];
	requestData = [json dataWithObject:dir];
	
	[json release];
	[dir release];
	
	httpMethod =  [@"DELETE" copy];
	return true;
}

@end
