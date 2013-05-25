//
//  ATWebViewController.h
//  IBC
//
//  Created by Manuel Burghard on 28.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;


@interface ATWebViewController : UIViewController <UIWebViewDelegate> {
    MBProgressHUD *HUD;
    IBOutlet UIWebView *__weak webView;
    IBOutlet UIToolbar *__weak topBar;
    IBOutlet UIToolbar *__weak toolbar;
    NSURL *url;
}

@property (weak) IBOutlet UIToolbar *topBar;
@property (weak) IBOutlet UIWebView *webView;
@property (weak) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (strong) NSURL *url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil URL:(NSURL *)url;
- (IBAction)share:(UIBarButtonItem *)sender;

@end
