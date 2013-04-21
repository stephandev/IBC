//
//  PNNotificationDelegate.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 02.12.12.
//  Copyright (c) 2012 EagleEye. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PNNotificationDelegate <NSObject>

-(void) notificationReceived:(NSString*) title message:(NSString*)message badget:(NSString*) count target:(NSString*)target;

@optional
-(void) customNotificationReceived:(NSString*) title message:(NSString*)message badget:(NSString*) count additionalInformations:(NSDictionary*) dict;

@end
