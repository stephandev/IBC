//
//  AnswerViewController.h
//  IBC
//
//  Created by Manuel Burghard on 14.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "XMLRPCResponseParser.h"
#import "SHK.h"

@interface AnswerViewController : UIViewController <XMLRPCResponseParserDelegate, UIAlertViewDelegate> {
    UITextView *textView;
    Topic *topic;
    NSMutableData *receivedData;
    BOOL isNotLoggedIn;
    
}

@property (strong) UITextView *textView;
@property (strong) Topic *topic;
@property (strong) NSMutableData *receivedData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil topic:(Topic *)aTopic;
- (void)cancel;

@end
