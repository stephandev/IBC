//
//  ATActivityIndicator.h
//  IBC
//
//  Created by Manuel Burghard on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ATActivityIndicator : UIView {
    UIActivityIndicatorView *spinner;
    UILabel *messageLabel;
}

@property (strong) UIActivityIndicatorView *spinner;
@property (strong) UILabel *messageLabel;

+ (ATActivityIndicator *)activityIndicator;
- (void)dismiss;

- (void)startAnimating;
- (void)stopAnimating;

@end
