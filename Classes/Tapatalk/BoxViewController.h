//
//  BoxViewController.h
//  IBC
//
//  Created by Manuel Burghard on 25.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATTableViewController.h"
#import "Box.h"
#import "Three20/Three20.h"
#import "ATContactPicker.h"

@interface BoxViewController : ATTableViewController {
    NSMutableArray *messages;
    Box *box;
    BOOL isDeletingMessage;
}

@property (strong) NSMutableArray *messages;
@property (strong) Box *box;
@property (assign) BOOL isDeletingMessage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil box:(Box *)aBox;

@end
