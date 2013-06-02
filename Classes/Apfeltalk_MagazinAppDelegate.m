//
//  Apfeltalk_MagazinAppDelegate.m
//  IBC
//
//	IBC Magazin -- An iPhone Application for the site http://www.mtb-news.de
//	Copyright (C) 2011	Stephan König (s dot konig at me dot com), Manuel Burghard
//						Alexander von Below
//
//	This program is free software; you can redistribute it and/or
//	modify it under the terms of the GNU General Public License
//	as published by the Free Software Foundation; either version 2
//	of the License, or (at your option) any later version.
//
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with this program; if not, write to the Free Software
//	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.//
//

#import "Apfeltalk_MagazinAppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"
#import "DetailNews.h"
#import "DetailGallery.h"
#import "DetailLiveticker.h"
#import "User.h"
#import "NewsController.h"
#import "iRate.h"
#import "PNPushNotification.h"

@implementation Apfeltalk_MagazinAppDelegate
@synthesize window;
@synthesize tabBarController;

#pragma mark Application lifecycle

-(void)initialize

{
    
    //set the bundle ID. normally you wouldn't need to do this
    //as it is picked up automatically from your Info.plist file
    //but we want to test with an app that's actually on the store
    
  
    
    [iRate sharedInstance].applicationBundleID = @"com.ibc.de";
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    [iRate sharedInstance].daysUntilPrompt = 2; //5
    [iRate sharedInstance].usesUntilPrompt = 15; //15
    
    //enable preview mode
    
    [iRate sharedInstance].previewMode = NO;
        
}

#pragma mark - Push Notifications

//These are the methods for push notifications and it's registration

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Eine Nachricht ist angekommen, während die App aktiv ist");
    
    NSString* alert = [[userInfo objectForKey:@"aps"] objectForKey:@"id"];
    
    NSLog(@"Nachricht: %@", alert);
    NSLog(@"receive pn: %@",userInfo);
    [pushNotifications receivePushNotification:userInfo];
    
    
}

-(void) notificationReceived:(NSString*) title message:(NSString*)message badget:(NSString*) count target:(NSString*)target
{
    NSLog(@"Message %@ %@  %@ %@", title,message,count,target);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device Token=%@", deviceToken);
    [pushNotifications setPushToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Fehler bei der Registrierung");
}
//This is the end of the methods for push notifications

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (Apfeltalk_MagazinAppDelegate*)sharedAppDelegate {
    return (Apfeltalk_MagazinAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)setApplicationDefaults {
	// !!!:below:20091018 This is not the Apple recommended way of doing this!
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"vibrateOnReload"] == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"vibrateOnReload"];
        [[NSUserDefaults standardUserDefaults] setFloat:12 forKey:@"fontSize"];
	}
    
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"fontSize"] == 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:12 forKey:@"fontSize"];
    }
}

- (void)login {
    [[User sharedUser] login];
}

- (void)deleteCookies {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://.mtb-news.de"]];
    for (NSHTTPCookie *c in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:c];
    }
}

/*- (void)applicationDidFinishLaunching:(UIApplication *)application {
 [self setApplicationDefaults];
 // Add the tab bar controller's current view as a subview of the window
 [window addSubview:tabBarController.view];
 [self login];
 }*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.frame = [[UIScreen mainScreen] bounds];
    [self setApplicationDefaults];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
	[self.window makeKeyAndVisible];
    sleep(3);
    
    
    
    //This is the start of the general push notification settings
	// Let the device know we want to receive push notifications
    
    pushNotifications = [[PNPushNotification alloc] initWithDelegate:self];
    [pushNotifications setAppKey:@"23e409isaeroakse23sae0"];
    [pushNotifications setSandboxEnabled:true];
    
    
    //Clear the notification center when the app has been launched
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    // Add the tab bar controller's current view as a subview of the window
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSMutableArray *viewControllers = (NSMutableArray *)tabBarController.viewControllers;
        
        UISplitViewController *splitviewController = [[UISplitViewController alloc] init];
        splitviewController.delegate = [newsController.viewControllers objectAtIndex:0];
        splitviewController.tabBarItem = newsController.tabBarItem;
        DetailNews *detailNews = [[DetailNews alloc] initWithNibName:[(NewsController *)splitviewController.delegate detailNibName] bundle:nil story:nil];
        
        splitviewController.viewControllers = [NSArray arrayWithObjects:newsController, detailNews,nil];
        [viewControllers replaceObjectAtIndex:0 withObject:splitviewController];
        [splitviewController release];
        [detailNews release];
        
        
        
        tabBarController.viewControllers = viewControllers;
    }
    
    window.rootViewController = tabBarController;
    NSURL *ubiq = [[NSFileManager defaultManager]
                   URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud access at %@", ubiq);
        // TODO: Load document...
    } else {
        NSLog(@"No iCloud access");
    }
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self deleteCookies];
    [self login];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self deleteCookies];
    [[User sharedUser] setLoggedIn:NO];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self deleteCookies];
    [[User sharedUser] setLoggedIn:NO];
}
/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */

//clearing caches

-(void) clearCache
{
    for(int i=0; i< 100;i++)
    {
        NSLog(@"warning CLEAR CACHE--------");
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError * error;
    NSArray * cacheFiles = [fileManager contentsOfDirectoryAtPath:NSTemporaryDirectory() error:&error];
    
    for(NSString * file in cacheFiles)
    {
        error=nil;
        NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:file ];
        NSLog(@"filePath to remove = %@",filePath);
        
        BOOL removed =[fileManager removeItemAtPath:filePath error:&error];
        if(removed ==NO)
        {
            NSLog(@"removed ==NO");
        }
        if(error)
        {
            NSLog(@"%@", [error description]);
        }
    }
    
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end