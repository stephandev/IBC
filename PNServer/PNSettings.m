//
//  PNSettings.m
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 25.11.12.
//  Copyright (c) 2012 EagleEye. All rights reserved.
//

#import "PNSettings.h"

@implementation PNSettings

-(NSString*) getPushToken
{
    NSMutableDictionary* settings = [self openSettings];
    return [settings objectForKey:@"pushtoken"];
}

-(void) setPushToken:(NSString*)token;
{
    NSMutableDictionary* settings = [self openSettings];
    if(token==nil)
        [settings removeObjectForKey:@"pushtoken"];
    else
        [settings setObject:token forKey:@"pushtoken"];
    [self storeSettings:settings];
}

-(NSString*) getDeviceKey
{
    NSMutableDictionary* settings = [self openSettings];
    
    NSString* val = [settings  objectForKey:@"devicekey"];
    
    if (val)
        return val;
    
    int x = arc4random();
    NSString* s = [NSString stringWithFormat:@"%d",x];
    [settings setObject:s forKey:@"devicekey"];
    
    [self storeSettings:settings];
    return s;
}

-(NSMutableDictionary*)openSettings
{
    NSUserDefaults* defaults =  [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* settings;
    if ([defaults dictionaryForKey:@"pnsettings"]) 
    {
        NSDictionary* s = (NSDictionary*)[defaults dictionaryForKey:@"pnsettings"];
        settings = [NSMutableDictionary  dictionaryWithDictionary:s];
    }
    else
    {
        settings = [NSMutableDictionary dictionaryWithObject:@"1.0" forKey:@"version"];
        [defaults setObject:settings forKey:@"pnsettings"];
    }
    return settings;
}
- (void)storeSettings:(NSMutableDictionary*)settings
{
    NSUserDefaults* defaults =  [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:settings forKey:@"pnsettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
