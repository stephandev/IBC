//
//  PNRequestDelegate.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 19.11.12.
//  Copyright 2012 EagleEye. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PNPushServerConnection;

@protocol PNRequestDelegate <NSObject>

-(void) requestSucceed:(PNPushServerConnection*) connection;
-(void) requestFailed:(PNPushServerConnection*) connection;
-(void) requestCanceled:(PNPushServerConnection*) connection;

@end
