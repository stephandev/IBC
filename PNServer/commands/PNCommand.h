//
//  PNRegisterCommand.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 15.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNRequestDelegate.h"
#import "PNPushServerConnection.h"

@class PNPushServerConnection;

@interface PNCommand : NSObject {
	
@protected
	NSString* serverUrl;
	NSData* requestData;
	NSString* httpMethod;
	NSURLConnection *connection;
	NSMutableData* responseData;
	int httpErrorCode;
	id<PNRequestDelegate> requestDelegate;
	PNPushServerConnection* pnConnection;
	
}

-(id) initWithConnection:(PNPushServerConnection*) pnconnection delegate:(id<PNRequestDelegate>) delegate;
-(void) execute;
-(void) receiveRequest:(NSString*) response  httpErrorCode:(int)httpErrorCode;
-(Boolean)prepareRequest:(NSURLRequest*) request;
-(Boolean)createRequest;


@property (readwrite,assign) id<PNRequestDelegate> requestDelegate;
@property (readwrite,retain) PNPushServerConnection* pnConnection;
@end
