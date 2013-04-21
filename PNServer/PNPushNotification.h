//
//  PNPushNotification.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 02.12.12.
//  Copyright (c) 2012 EagleEye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PNPushServerConnection.h"
#import "PNRequestDelegate.h"
#import "PNNotificationDelegate.h"

@class PNPushServerConnection;
@class PNNotificationDelegate;

@interface PNPushNotification : NSObject<PNRequestDelegate>
{
    @protected
    PNPushServerConnection* pushConnection;
    Boolean enablePush;
    id<PNNotificationDelegate> delegate;
}

-(id) initWithDelegate:(id<PNNotificationDelegate>) del;
-(id) initForPushType:(int)type delegate:(id<PNNotificationDelegate>)del;
-(void) update;
-(void) receivePushNotification:(NSDictionary*) dict;
-(void) setPushToken:(NSData*)token;
-(void) setAppKey:(NSString*) key;
-(void) setSandboxEnabled:(Boolean) b;

@property(readwrite,assign) Boolean enablePush;
@property(readwrite,assign) id<PNNotificationDelegate> delegate;
@property(readwrite,retain) NSArray* requestParams;
@end
