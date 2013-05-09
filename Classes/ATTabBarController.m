//
//  ATTabBarController.m
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


#import "ATTabBarController.h"
#import "ATWebViewController.h"

@interface ATTabBarController () <UITabBarControllerDelegate>

@end

@implementation ATTabBarController


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.delegate = self;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark - UITabBarControllerDelegate
- (void)dismissWebView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[ATWebViewController class]]) {
        NSURL *url = nil;
        if (viewController.tabBarItem.tag == 0) {
            url = [NSURL URLWithString:@"http://m.bikemarkt.mtb-news.de"];
        }
        else if (viewController.tabBarItem.tag == 1) {
            url = [NSURL URLWithString:@"http://winterpokal.mtb-news.de"];
        }
//        if viewController.tabBarItem.tag==0 
        ATWebViewController *webViewController = [[ATWebViewController alloc] initWithNibName:nil bundle:nil URL:url];
        
        UINavigationController *navigationBarController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        
        navigationBarController.navigationBar.tintColor = ATNavigationBarTintColor;
        
        webViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissWebView)];
        navigationBarController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentModalViewController:navigationBarController animated:YES];
        return NO;
    }
    return YES;
}

@end
