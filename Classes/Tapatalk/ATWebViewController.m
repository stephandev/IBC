//
//  ATWebViewController.m
//  IBC
//
//  Created by Manuel Burghard on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ATWebViewController.h"
#import "SHK.h"
#import "ATTabBarController.h"
#import "MBProgressHUD.h"

#define ReloadButtonIndex 4


@implementation ATWebViewController
@synthesize webView, url, toolbar, topBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil URL:(NSURL *)aUrl {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.url = aUrl;
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

- (void)dealloc {
    self.topBar = nil;
    self.toolbar = nil;
    self.webView = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark IBActions

- (IBAction)share:(UIBarButtonItem *)sender {
    
	SHKItem *item = [SHKItem URL:self.url title:@"Hat einen interessanten Link für Dich!"];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.toolbar];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*- (void)loadView {
}*/

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webView stopLoading];
}

- (void)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancel)];
        [self.topBar setItems:[NSArray arrayWithObject:doneButton] animated:YES];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)aWebView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    [items removeObjectAtIndex:ReloadButtonIndex];
    UIBarButtonItem *reloadButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop 
                                                                                 target:self.webView 
                                                                                 action:@selector(stopLoading)];
    [items insertObject:reloadButton atIndex:ReloadButtonIndex];
    
    //Show the activity Indicator
    
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    HUD.labelText = NSLocalizedStringFromTable(@"Loading", @"ATLocalizable", @"");
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    [HUD show:YES];
    [HUD hide:YES afterDelay:6];
    [HUD showWhileExecuting:@selector(doSomeFunkyStuff) onTarget:self withObject:nil animated:YES];

    [self.toolbar setItems:items];
}

- (void)doSomeFunkyStuff {
    float progress = 0.0;
    while (progress < 1.0) {
        progress += 0.01;
        HUD.progress = progress;
        usleep(50000);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    [items removeObjectAtIndex:ReloadButtonIndex];
    UIBarButtonItem *reloadButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                 target:self.webView 
                                                                                 action:@selector(reload)];
    [items insertObject:reloadButton atIndex:ReloadButtonIndex];
    
    [self.toolbar setItems:items];
    self.url = self.webView.request.URL;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [HUD removeFromSuperview];
    HUD.delegate = nil;
    HUD = nil;
    
    //Stop bouncing horizontally
    [webView.scrollView setContentSize: CGSizeMake(webView.bounds.size.width, webView.scrollView.contentSize.height)];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error: %@", [error localizedDescription]);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    [items removeObjectAtIndex:ReloadButtonIndex];
    UIBarButtonItem *reloadButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                 target:self.webView 
                                                                                 action:@selector(reload)];
    [items insertObject:reloadButton atIndex:ReloadButtonIndex];
    [self.toolbar setItems:items];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}
    
@end
