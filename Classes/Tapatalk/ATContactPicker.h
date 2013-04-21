//
//  ATContactPicker.h
//  IBC
//
//  Created by Manuel Burghard on 30.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATContactPicker;

@protocol ATContactPickerDelegate

- (void)contactPicker:(ATContactPicker *)contactPicker didSelectContact:(NSString *)contactName;

@end

@interface ATContactPicker : UITableViewController {
    NSArray *groups;
    NSArray *groupTitles;
    id <ATContactPickerDelegate> __weak delegate;
}

@property (strong) NSArray *groups;
@property (strong) NSArray *groupTitles;
@property (weak) id <ATContactPickerDelegate> delegate;

- (id)initWithStyle:(UITableViewStyle)style groups:(NSArray *)_groups titles:(NSArray *)titles;

@end
