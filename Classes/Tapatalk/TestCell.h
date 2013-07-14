//
//  TestCell.h
//  IBC
//
//  Created by Patrick Schwarz on 14.07.13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface TestCell : UITableViewCell

    - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableViewWidth:(CGFloat)tableViewWidth contents:(NSString *)contents;

@end
