//
//  PNPushServerConnection.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 13.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import <Foundation/Foundation.h>	
#import "PNRequestDelegate.h"
#import "PNCommand.h"
#import "PNSettings.h"

@class PNCommand;
@class PNSettings;


extern NSInteger PN_IOS_DEVICE;
extern NSInteger PN_IOS_SANDBOX_DEVICE;

@interface PNPushServerConnection : NSObject {
	
@protected
	NSString * serverUrl;
	NSString* appkey;
	
    Boolean sandbox;
	PNCommand* currentCommand;
    PNSettings* settings;
}
-(void) registerClient:(id<PNRequestDelegate>) delegate;
-(void) registerClient:(id<PNRequestDelegate>) delegate requestParameters:(NSArray*) params;
-(void) unregisterClient:(id<PNRequestDelegate>) delegate;
-(void) unregisterClient:(id<PNRequestDelegate>) delegate requestParameters:(NSArray*) params;
-(void) execute:(PNCommand*) command;
-(void) setPushToken:(NSString*) token;
-(NSString*) getPushToken;



@property (readwrite,copy) NSString* serverUrl;
@property (readwrite,copy) NSString* appkey;
@property (readwrite,assign) Boolean sandbox;
@end
