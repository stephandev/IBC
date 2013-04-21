//
//  PNRegisterCommand.m
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 20.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import "PNRegisterCommand.h"
#import "PNRequestDelegate.h"
#import  "SBJsonWriter.h"
#import "PNRequestProperty.h"

@class PNRequestProperty;

@implementation PNRegisterCommand

@synthesize appkey;
@synthesize deviceId;
@synthesize pushToken;
@synthesize requestParameters;

-(id)initWithConnection:(PNPushServerConnection *)c delegate:(id<PNRequestDelegate>)d
{
	self =  [super initWithConnection:c delegate:d];
	if (self) 
	{
		serverUrl = [[NSString alloc] initWithFormat: @"%@/client/register", [c serverUrl]];
	}
	return self;
}

-(id)initWithConnection:(PNPushServerConnection *)pnconnection delegate:(id<PNRequestDelegate>)delegate parameters:(NSArray *)params
{
    self =  [self initWithConnection:pnconnection delegate:delegate];
    if(self)
        [self setRequestParameters:params];
    
    return self;
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
    
    if([pnConnection sandbox])
        [dir setObject:[NSNumber numberWithInt:PN_IOS_SANDBOX_DEVICE] forKey:@"devicetype" ];
    else
        [dir setObject:[NSNumber numberWithInt:PN_IOS_DEVICE] forKey:@"devicetype" ];
	[dir setObject:deviceId forKey:@"deviceid"];
	[dir setObject:pushToken forKey:@"pushtoken"];
	[dir setObject:[pnConnection  appkey] forKey:@"appkey"];
	
	SBJsonWriter* json = [[SBJsonWriter alloc] init];
	requestData = [json dataWithObject:dir];
	
	[json release];
	[dir release];
	
	httpMethod =  @"PUT";
	return true;
}


-(void)dealloc
{
    NSLog(@"PNRegisterCommand dealoc");
    
   // [appkey release];
   // [deviceId release];
   // [pushToken release];
    [requestParameters release];
    
    [super dealloc];
}

@end
