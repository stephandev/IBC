//
//  WriteMessageViewController.h
//  IBC
//
//  Created by Manuel Burghard on 21.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteMessageViewController : UIViewController {
    NSMutableData *receivedData;
}

@property (strong) NSMutableData *receivedData;

@end
