//
//  PNPushServerConnection.m
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 13.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import "PNPushServerConnection.h"
#import <Foundation/NSURLResponse.h>
#import "PNRegisterCommand.h"
#import "PNUnregisterCommand.h"

@class PNRegisterCommand;
@class PNUnregisterCommand;

@implementation PNPushServerConnection

@synthesize serverUrl;
@synthesize appkey;
@synthesize sandbox;

NSInteger PN_IOS_DEVICE = 4;
NSInteger PN_IOS_SANDBOX_DEVICE = 5;

-(PNPushServerConnection*) init
{
	self = [super init];
	if(self)
	{
		serverUrl = [@"http://byte-welt.net:8080/PushServer" copy];
//		serverUrl = [@"http://192.168.0.102:8080/PushServer" copy];
        [self setSandbox:false];
        
        settings = [[PNSettings alloc]init];
        
        
	}
	return self;
}

-(void)dealloc
{
    NSLog(@"PNPushServerConnection dealloc");
    //[serverUrl release];
    //[appkey release];
    [currentCommand release];
    [settings release];
    
    [super dealloc];
}

-(void)setPushToken:(NSString *)token
{
    [settings setPushToken:token];
}

-(NSString*) getPushToken
{
    return [settings  getPushToken];
}

-(void)registerClient:(id<PNRequestDelegate>) delegate
{
    NSLog(@"Register client");
    [self registerClient:delegate requestParameters:nil];
}

-(void)registerClient:(id<PNRequestDelegate>) delegate requestParameters:(NSArray *)params
{
    NSLog(@"Register client");
	PNRegisterCommand* command = [[PNRegisterCommand alloc] initWithConnection:self delegate:delegate parameters:params];
    
    [command setDeviceId:[settings getDeviceKey]];
    [command setPushToken:[settings getPushToken]];
    
	[self execute:command];
    [command release];
}

-(void)unregisterClient:(id<PNRequestDelegate>) delegate
{
    [self unregisterClient:delegate requestParameters:nil];
}

-(void)unregisterClient:(id<PNRequestDelegate>) delegate requestParameters:(NSArray *)params
{
    NSLog(@"Unregister client");
	PNUnregisterCommand* command = [[PNUnregisterCommand alloc] initWithConnection:self delegate:delegate parameters:params];
    
    [command setDeviceId:[settings getDeviceKey]];
    
	[self execute:command];
    [command release];
}

-(void) execute:(PNCommand *)command
{
    [currentCommand release];
    currentCommand = command;
    
    [currentCommand retain];
    
    [currentCommand execute];
}



@end
