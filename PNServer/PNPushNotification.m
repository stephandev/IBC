//
//  PNPushNotification.m
//  PushServerTestApp
//
//  Created by Kay Czarnotta on 02.12.12.
//  Copyright (c) 2012 EagleEye. All rights reserved.
//

#import "PNPushNotification.h"

@implementation PNPushNotification

@synthesize enablePush;
@synthesize delegate;
@synthesize requestParams;

-(id) initWithDelegate:(id<PNNotificationDelegate>)del
{
    return [self initForPushType: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound) delegate:del];
}

-(id) initForPushType:(int)type delegate:(id<PNNotificationDelegate>)del
{
    self = [super init];
    if(self)
    {
        [self update];
        [self setDelegate:del];
        pushConnection = [[PNPushServerConnection alloc] init];
    }
    
    return self;
}

-(void)dealloc
{
    [pushConnection release];
    
    [super dealloc];
}

-(void) update
{
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    enablePush = ([UIApplication sharedApplication].enabledRemoteNotificationTypes & UIRemoteNotificationTypeAlert) == UIRemoteNotificationTypeAlert;
    NSLog(@"Pushoption %d",([UIApplication sharedApplication].enabledRemoteNotificationTypes & UIRemoteNotificationTypeAlert) );
    if(enablePush)
        NSLog(@"Push On");
    else
        NSLog(@"Push Off");
}

-(void) setPushToken:(NSData *)token
{
    /*NSUInteger length = [token length];
     NSMutableString *stringToken = [NSMutableString stringWithCapacity:2 * length];
     unsigned char const *theBytes = [token bytes];
     
     for(NSUInteger i = 0; i < length; ++i) {
     [stringToken appendFormat:@"%x", theBytes[i]];
     }
     NSLog(@"Token %@",stringToken);*/
    
    NSString* stringToken = [[token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    stringToken = [stringToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"Token %@",stringToken);
    if(enablePush)
    {
        [pushConnection setPushToken:stringToken];
        [pushConnection registerClient:self];
    }
    else
    {
        if([pushConnection getPushToken])
            [pushConnection unregisterClient:self];
        [pushConnection setPushToken:nil];
    }
}

-(void) setAppKey:(NSString *)key
{
    [pushConnection setAppkey:key];
}

-(void) setSandboxEnabled:(Boolean)b
{
    [pushConnection setSandbox:b];
}

-(void) receivePushNotification:(NSDictionary*) dict
{
    NSLog(@"Receive Notification: %@", dict);
    
    NSDictionary* apsDict = [dict objectForKey:@"aps"];
    
    [delegate notificationReceived:[apsDict objectForKey:@"title"] message:[apsDict objectForKey:@"alert"] badget:[apsDict objectForKey:@"badget"] target:[dict objectForKey:@"messageTarget"]];
    
    if ([delegate respondsToSelector:@selector(customNotificationReceived:)]) {
        [delegate  customNotificationReceived:[apsDict objectForKey:@"title"] message:[apsDict objectForKey:@"alert"] badget:[apsDict objectForKey:@"badget"] additionalInformations: dict];
    }
}


-(void) requestSucceed:(PNPushServerConnection*) connection
{
    if(enablePush)
        NSLog(@"PN Register succeed");
    else
        NSLog(@"PN Unregister succeed");
}

-(void) requestFailed:(PNPushServerConnection*) connection
{
    if(enablePush)
        NSLog(@"PN Register failed");
    else
        NSLog(@"PN Unregister failed");
}

-(void) requestCanceled:(PNPushServerConnection*) connection
{
    if(enablePush)
        NSLog(@"PN Register canceled");
    else
        NSLog(@"PN Unregister canceled");
}

@end
