//
//  PNSettings.h
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 25.11.12.
//  Copyright (c) 2012 EagleEye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PNSettings : NSObject
{
}

-(NSMutableDictionary*)openSettings;
-(void)storeSettings:(NSMutableDictionary*)settings;
-(NSString*)  getPushToken;
-(void) setPushToken:(NSString*)token;
-(NSString*)  getDeviceKey;

@end
