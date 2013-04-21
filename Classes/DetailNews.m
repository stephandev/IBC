//
// DetailNews.m
// IBC
//
// IBC Magazin -- An iPhone Application for the site http://www.mtb-news.de
// Copyright (C) 2011 Stephan König (s dot konig at me dot com), Manuel Burghard
// Alexander von Below
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.//
//

#import "DetailNews.h"
#import "NewsController.h"
#import "Apfeltalk_MagazinAppDelegate.h"
#import "ATMXMLUtilities.h"

#import "SHK.h"
#import "SHKTwitter.h"
#import "SHKFacebook.h"
#import "SHKFBStreamDialog.h"
#import "SHKMail.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

// Private interface
@interface DetailNews ()

- (NSString *)htmlString;
- (void)loadArticlePages:(NSArray *)pagesLinks;
- (void)internalUpdateInterface;
- (void)stopNetworkActivityIndicator;

@end


@interface DetailNews (private)
- (void)createMailComposer;
@end

@implementation DetailNews

@synthesize showSave;
@synthesize pageControl;
@synthesize currentPage;

// This is the new designated initializer for the class
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle story:(Story *)newStory
{
    self = [super initWithNibName:nibName bundle:nibBundle story:newStory];
    if (self != nil) {
        showSave = YES;
    }
    return self;
}


- (NSInteger)showSaveButton {
    UINavigationController *navController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        navController = [self navigationController];
    } else {
        navController = [self.splitViewController.viewControllers objectAtIndex:0];
    }
    NSArray *controllers = [navController viewControllers];
    NewsController *newsController = (NewsController *)[controllers objectAtIndex:0];
    
    if ([self showSave] && [newsController isSavedStory:[self story]])
        [self setShowSave:NO];
    
    if (![self showSave])
        return 0;
    return 1;
}

- (NSString *) Mailsendecode {
    if ([self showSaveButton])
        return NSLocalizedStringFromTable(@"Save", @"ATLocalizable", @"");
    return nil;
}

- (void) status_updateCallback: (NSData *) content {
    [loadingActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(IBAction)speichern:(id)sender
{
    [super speichern:sender];
    Apfeltalk_MagazinAppDelegate *appDelegate = [Apfeltalk_MagazinAppDelegate sharedAppDelegate];
    // :below:20090920 This is only to placate the analyzer
    
    myMenu = [[UIActionSheet alloc] init];
    myMenu.title = nil;
    myMenu.delegate = self;
    [myMenu addButtonWithTitle:NSLocalizedStringFromTable(@"Send Mail", @"ATLocalizable", @"")];
    if ([self showSaveButton]) // :below:20100101 This is something of a hack
        [myMenu addButtonWithTitle:[self Mailsendecode]];
    [myMenu addButtonWithTitle:@"Twitter"];
    // Check if the new SLComposerViewController is available, then hide the facebook button in the options for news if it is not available
    Class composeViewControllerClass = NSClassFromString(@"SLComposeViewController");
    if (composeViewControllerClass != nil)
        [myMenu addButtonWithTitle:@"Facebook"];
    //Airprint
    //[myMenu addButtonWithTitle:NSLocalizedStringFromTable(@"Print", @"ATLocalizable", @"")];
    
    
    
    
    NSInteger lastButtonIndex = [myMenu addButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"ATLocalizable", @"")];
    
    myMenu.cancelButtonIndex = lastButtonIndex;
    
    [myMenu showFromTabBar:[[appDelegate tabBarController] tabBar]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIdx
{
    // int numberOfButtons = [actionSheet numberOfButtons]; not used
    int saveEnabled = [self showSaveButton];
    
    // assume that when we have 3 buttons, the one with idx 1 is the save button
    // :below:20091220 This assumption is not correct, We should find a smarter way
    UINavigationController *navController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        navController = [self navigationController];
    } else {
        navController = [self.splitViewController.viewControllers objectAtIndex:0];
    }
    
    if (saveEnabled && buttonIdx == 1) {
        // Save
        
        NSArray *controllers = [navController viewControllers];
        
        NewsController *newsController = (NewsController*) [controllers objectAtIndex:0];
        [newsController addSavedStory:[self story]];
    }
    
    NSArray *controllers = [navController viewControllers];
    NewsController *newsController = (NewsController*) [controllers objectAtIndex:0];
    
    if ([self showSave] && [newsController isSavedStory:[self story]])
        [self setShowSave:NO];
    
    if (buttonIdx == 0) {
        NSMutableString *storyContent = [[NSMutableString alloc] init];
        for (NSString *pageContent in story.content) {
            [storyContent appendString:pageContent];
        }
        // Mail
        SHKItem *item = [SHKItem text:storyContent];
        item.title = story.title;
        item.text = @"Hier ist ein Link der dich interessieren könnte:";
        item.URL = [NSURL URLWithString:story.link];
        
        [SHKMail shareItem:item];
    }
    
    if (buttonIdx == 1 + saveEnabled) {
        // Twitter
        if(NSClassFromString(@"SLComposeViewController") != nil)
        {
            
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            [mySLComposerSheet setInitialText:[NSString stringWithFormat:story.title,mySLComposerSheet.serviceType]]; //the message you want to post
            [mySLComposerSheet addURL:[NSURL URLWithString:story.link]];
            //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
            
        } else {
            
            {
                TWTweetComposeViewController *tweetSheet =
                [[TWTweetComposeViewController alloc] init];
                [tweetSheet setInitialText:[NSString stringWithFormat:story.title]];
                [tweetSheet addURL:[NSURL URLWithString:story.link]];
                [self presentModalViewController:tweetSheet animated:YES];
            }
        }
    }
    
    if (buttonIdx == 2 + saveEnabled) {
        // FaceBook
        if(NSClassFromString(@"SLComposeViewController") != nil)
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]);
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            [mySLComposerSheet setInitialText:[NSString stringWithFormat:story.title,mySLComposerSheet.serviceType]]; //the message you want to post
            [mySLComposerSheet addURL:[NSURL URLWithString:story.link]];
            //for more instance methodes, go here:https://developer.apple.com/library/ios/#documentation/NetworkingInternet/Reference/SLComposeViewController_Class/Reference/Reference.html#//apple_ref/doc/uid/TP40012205
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        }
    }

    if (actionSheet == myMenu) {
        myMenu = nil;
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
}

- (void)updateInterface
{
    NewsController *newsController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        newsController = [[[self.splitViewController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
    }
    else
    {
        NSArray *controllers = [[self navigationController] viewControllers];
        newsController = (NewsController *)[controllers objectAtIndex:[controllers count] - 2];
    }
    
    [self setShowSave:![newsController isSavedStory:[self story]]];
    
    Story *theStory = self.story;
    
    if (theStory && !theStory.author) // Check if the author and content is already loaded
    {
        if (!self.activityIndicator)
            self.activityIndicator = [[ATActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
        
        self.activityIndicator.center = CGPointMake(webview.frame.size.width / 2.0, webview.frame.size.height / 2.0);
        
        [webview addSubview:self.activityIndicator];
        [self.activityIndicator startAnimating];
    }
    
    self.currentPage = 0;
    [self performSelector:@selector(internalUpdateInterface) withObject:nil afterDelay:0.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.pageControl setHidesForSinglePage:YES];
    
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [webview addGestureRecognizer:leftSwipeGestureRecognizer];
    
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [webview addGestureRecognizer:rightSwipeGestureRecognizer];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        NSArray *imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"Up.png"], [UIImage imageNamed:@"Down.png"], nil];
        UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:imgArray];
        
        [segControl addTarget:[[[self navigationController] viewControllers] objectAtIndex:0] action:@selector(changeStory:)
             forControlEvents:UIControlEventValueChanged];
        [segControl setFrame:CGRectMake(0.0, 0.0, 110.0, 30.0)];
        [segControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segControl setMomentary:YES];
        self.navigationItem.titleView = segControl;
        [[[[self navigationController] viewControllers] objectAtIndex:0] changeStory:segControl];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NewsController *newsController;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        newsController = [[[self.splitViewController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:0];
    } else {
        NSArray *controllers = [[self navigationController] viewControllers];
        newsController = (NewsController *)[controllers objectAtIndex:[controllers count] - 2];
    }
    
    if ([self showSave] && [newsController isSavedStory:[self story]])
        [self setShowSave:NO];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)changePage:(UIPageControl *)sender
{
    /*[UIView beginAnimations:nil context:NULL];
     [UIView setAnimationDuration:0.5];*/
    NSInteger page = sender.currentPage;
    
    if (page != self.currentPage)
    {
        if (page >= [self.story.content count])
        {
            sender.currentPage = self.currentPage;
        }
        else
        {
            /*if (self.currentPage > page)
             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:webview cache:NO];
             else
             [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:webview cache:NO];*/
            self.currentPage = page;
            [webview loadHTMLString:[self htmlString] baseURL:nil];
        }
    }
    //[UIView commitAnimations];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.pageControl.currentPage < self.pageControl.numberOfPages -1) {
            self.pageControl.currentPage += 1;
        }
        
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.pageControl.currentPage > 0) {
            self.pageControl.currentPage -= 1;
        }
    }
    [self changePage:self.pageControl];
}

#pragma mark - Internal used methods

- (NSString *)htmlString
{
    Story *theStory = self.story;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:[NSString stringWithFormat:@"%@ HH:mm", [dateFormatter dateFormat]]];
    
    float fontSize = [[NSUserDefaults standardUserDefaults] floatForKey:@"fontSize"];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DetailView" ofType:@"html"];
    NSString *htmlString = [NSString stringWithFormat:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL],
                            fontSize, [self imageWidth], (fontSize + 3.0), [theStory.title stringByReplacingOccurrencesOfString:@"width=\"640\"" withString:@""], (fontSize - 1.0), theStory.author, [dateFormatter stringFromDate:theStory.date], fontSize,
                            [theStory.summary stringByReplacingOccurrencesOfString:@"width=\"640\"" withString:@""]];
    return htmlString;
}

- (void)loadArticlePages:(NSArray *)pagesLinks
{
    @autoreleasepool {
        
        for (NSUInteger index = 1; index < [pagesLinks count]; index++)
        {
            ATMXMLUtilities *xmlUtilities = [[ATMXMLUtilities alloc] initWithURLString:[pagesLinks objectAtIndex:index]];
            [self.story addStoryPage:[xmlUtilities articleContent]];
        }
        
        [self performSelectorOnMainThread:@selector(stopNetworkActivityIndicator) withObject:nil waitUntilDone:NO];
        
    }
}


- (void)internalUpdateInterface
{
    NSArray *pagesLinks = nil;
    Story *theStory= self.story;
    
    if (theStory.link && !theStory.author) // Fill the empty attributes of the current item
    {
        ATMXMLUtilities *xmlUtilities = [ATMXMLUtilities xmlUtilitiesWithURLString:theStory.link];
        theStory.author = [xmlUtilities authorName];
        [theStory addStoryPage:[xmlUtilities articleContent]];
        /*NSString *string = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:theStory.link]];
         NSString *s = extractTextFromHTMLForQuery(string, @"//form[@id='form_widget_comments']/@action");
         NSArray *parameters = [s componentsSeparatedByString:@"&"];
         NSInteger i = 0;
         for (NSString *str in parameters) {
         if ([str rangeOfString:@"t="].location != NSNotFound) {
         i = [[str stringByReplacingOccurrencesOfString:@"t=" withString:@""] integerValue];
         break;
         }
         }
         [string release];*/
        pagesLinks = [xmlUtilities articlePagesLinks];
        if (pagesLinks)
            [self performSelectorInBackground:@selector(loadArticlePages:) withObject:pagesLinks];
    }
    
    [webview loadHTMLString:[self htmlString] baseURL:nil];
    
    NSInteger pageCount = [theStory.content count];
    
    if (pageCount == 0)
        pageCount = 1;
    
    if (pagesLinks)
        pageCount = [pagesLinks count];
    else
        [self stopNetworkActivityIndicator];
    self.view.backgroundColor = [UIColor colorWithRed:0.811 green:0.812 blue:0.811 alpha:1.000];
    CGRect frame = self.pageControl.frame;
    if (pageCount == 1)
        frame.origin.y = self.view.frame.size.height;
    else
        frame.origin.y = self.view.frame.size.height - frame.size.height;
    CGRect webviewFrame = webview.frame;
    webviewFrame.size.height = frame.origin.y - self.toolbar.frame.size.height;
    webview.frame = webviewFrame;
    self.pageControl.frame = frame;
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = 0;
    self.currentPage = 0;
}


- (void)stopNetworkActivityIndicator
{
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
}

@end