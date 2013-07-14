//
//  TestCell.m
//  IBC
//
//  Created by Patrick Schwarz on 14.07.13.
//
//

#import "TestCell.h"
#import "ImageModell.h"

@implementation TestCell

- (CGFloat)groupedCellMarginWithTableWidth:(CGFloat)tableViewWidth
{
    CGFloat marginWidth;
    if(tableViewWidth > 20)
    {
        if(tableViewWidth < 400)
        {
            marginWidth = 10;
        }
        else
        {
            marginWidth = MAX(31, MIN(45, tableViewWidth*0.06));
        }
    }
    else
    {
        marginWidth = tableViewWidth - 10;
    }
    return marginWidth;
}

- (BOOL)validateUrlString:(NSString*)urlString
{
    if (!urlString)
    {
        return NO;
    }
    
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    
    NSRange urlStringRange = NSMakeRange(0, [urlString length]);
    NSMatchingOptions matchingOptions = 0;
    
    if (1 != [linkDetector numberOfMatchesInString:urlString options:matchingOptions range:urlStringRange])
    {
        return NO;
    }
    
    NSTextCheckingResult *checkingResult = [linkDetector firstMatchInString:urlString options:matchingOptions range:urlStringRange];
    
    return checkingResult.resultType == NSTextCheckingTypeLink
    && NSEqualRanges(checkingResult.range, urlStringRange);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier tableViewWidth:(CGFloat)tableViewWidth contents:(NSString *)contents
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *finalString = [contents componentsSeparatedByString:@"[CUT]"];
        
        float aktuellePostitionHeight = 5;
        int textviewtag = 0;
        
        for(int x = 0; x<=[finalString count]-1; x++)
        {
            if(![self validateUrlString:[finalString objectAtIndex:x]]) {
                UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, aktuellePostitionHeight, 250, 100)];
                textView.scrollEnabled = NO;
                textView.editable = NO;
                textView.layer.masksToBounds = YES;
                textView.layer.cornerRadius = 10.0;
                textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                textView.bounces = NO;
                textView.dataDetectorTypes = UIDataDetectorTypeLink;
                textView.backgroundColor = self.contentView.backgroundColor;
                textView.tag = textviewtag;
            
                UIFont *font = textView.font;
                textView.font = [font fontWithSize:[[NSUserDefaults standardUserDefaults] floatForKey:@"fontSize"]];
            
                textView.text = [finalString objectAtIndex:x];
            
                [self.contentView addSubview:textView];

                /*
                 CGRect frame = textView.frame;
                 frame.size.height = textView.contentSize.height;
                 textView.frame = frame;
                 */
                
                textviewtag += 1;
                aktuellePostitionHeight += textView.frame.size.height + 10;
                
            } else {
                ImageModell *imageModelController = [[ImageModell alloc] init];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, aktuellePostitionHeight, 100, 100)];
                
                UIImage *image = [imageModelController getCachedImage:[finalString objectAtIndex:x]];
                if([imageModelController getCachedImage:[finalString objectAtIndex:x]] != (UIImage*)nil) {
                    [imageView setImage:image];
                } else {
                    [imageModelController loadImageInBackground:[finalString objectAtIndex:x] forImageView:imageView];
                }
                
                imageView.layer.borderColor = [UIColor blackColor].CGColor;
                imageView.layer.borderWidth = 1;
                
                [self.contentView addSubview:imageView];
            }
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat margin = [self groupedCellMarginWithTableWidth:width];
    
    float aktuelleHoehe = 5.0;
    for (id view in [self.contentView subviews])
    {
        if ([view isKindOfClass:[UITextView class]])
        {
            [(UITextView *)view setFrame:CGRectMake(0.0, aktuelleHoehe, width - 2.0 * margin, [(UITextView *)view contentSize].height)];
            aktuelleHoehe += [(UITextView *)view frame].size.height;
        }
        else if([view isKindOfClass:[UIImageView class]])
        {
            CGSize boundsSize = self.bounds.size;
            CGRect frameToCenter = [(UIImageView *)view frame];
            
            [(UIImageView *)view setFrame:CGRectMake((boundsSize.width - frameToCenter.size.width) / 3, aktuelleHoehe, 250, 200)];
            aktuelleHoehe += [(UIImageView *)view frame].size.height;
        }
    }
    


}


@end
