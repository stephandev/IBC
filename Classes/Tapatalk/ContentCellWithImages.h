//
//  TestCell.h
//  IBC
//
//  Created by Patrick Schwarz on 14.07.13.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageModell.h"

@interface ContentCellWithImages : UITableViewCell <ImageModellDelegate>

    @property (nonatomic, strong) ImageModell *imageModelController;

    - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableViewWidth:(CGFloat)tableViewWidth contents:(NSString *)contents;

@end
