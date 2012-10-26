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


@implementation Apfeltalk_MagazinAppDelegate

@synthesize window;
@synthesize tabBarController;

//These are the methods for push notifications and it's registration

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //NSLog(@"Eine Nachricht ist angekommen, während die App aktiv ist");
    
    NSString* alert = [[userInfo objectForKey:@"aps"] objectForKey:@"id"];

    NSLog(@"Nachricht: %@", alert);
    
    //This is to inform about new messages when the app is active
    
    //UIApplicationState state = [[UIApplication sharedApplication] applicationState];
    //if (state == UIApplicationStateActive) {
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Neuer Artikel" message:@"Nachricht" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //    [alertView show];
    //    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Device Token=%@", deviceToken);
    
    NSString* string = [NSString stringWithFormat:@"%@", deviceToken];
    
    string = [string substringWithRange:NSMakeRange(1, string.length - 2)];
    
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = [NSString stringWithFormat:@"http://byte-welt.net:8080/PushServer.php?deviceToken=%@", string];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *urlResponse, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error");
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Error bei der Registrierung");
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
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"showIconBadge"] == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showIconBadge"];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shakeToReload"];
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
    //This is the start of the push notification settings
	[self.window makeKeyAndVisible];
    
    //This is to show an UIAlertView when the app receives push notifications in inactive state (Only for testing purposes)
    
    //if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]) {
    //    NSString* alert = [[[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectforkey:@"alert"];
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Neuer Artikel" message:alert delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    //    [alertView show];
    //    }
    
	// Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
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


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end