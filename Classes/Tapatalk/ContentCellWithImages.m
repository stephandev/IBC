//
//  TestCell.m
//  IBC
//
//  Created by Patrick Schwarz on 14.07.13.
//
//

#import "ContentCellWithImages.h"

@implementation ContentCellWithImages

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
            if(![self validateUrlString:[finalString objectAtIndex:x]] && [finalString objectAtIndex:x] != nil ) {
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
                
                textviewtag += 1;
                aktuellePostitionHeight += textView.frame.size.height + 10;
                
            } else {
                ImageModell *imageModelController = [[ImageModell alloc] init];
                imageModelController.delegate = self;
                
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, aktuellePostitionHeight, 100, 100)];
                
                UIImage *image = [imageModelController getCachedImage:[finalString objectAtIndex:x]];
                if([imageModelController getCachedImage:[finalString objectAtIndex:x]] != (UIImage*)nil) {
                    [imageView setImage:image];
                } else {
                    [imageModelController loadImageInBackground:[finalString objectAtIndex:x] forImageView:imageView];
                }
                
                //imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
                //imageView.contentMode = UIViewContentModeScaleAspectFit;
                
                imageView.layer.borderColor = [UIColor blackColor].CGColor;
                imageView.layer.borderWidth = 1;
                
                [self.contentView addSubview:imageView];
            }
        }
    }
    return self;
}

- (void)imageDidFinishLoading:(UIImage *)image imageView:(UIImageView *)imageView
{
    CGFloat width = CGRectGetWidth(self.frame);
    
    [imageView setImage:image];
    [imageView setFrame:CGRectMake((width - ([imageView image].size.width / 2) - 20) / 2, imageView.frame.origin.y, [imageView image].size.width / 2, [imageView image].size.height / 2)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat margin = [self groupedCellMarginWithTableWidth:width];
    
    float aktuelleHoehe = 5.0;
    
    for (id view in [self.contentView subviews])
    {
        if ([view isKindOfClass:[UITextView class]]) {
            [(UITextView *)view setFrame:CGRectMake(0.0, aktuelleHoehe, width - 2.0 * margin, [(UITextView *)view contentSize].height)];
            aktuelleHoehe += [(UITextView *)view frame].size.height;
        } else if([view isKindOfClass:[UIImageView class]]) {
            if([(UIImageView *)view image] != (UIImage *)nil) {
                [(UIImageView *)view setFrame:CGRectMake((width - ([(UIImageView *)view image].size.width / 2) - 20) / 2, aktuelleHoehe, [(UIImageView *)view image].size.width / 2, [(UIImageView *)view image].size.height / 2)];
            } else {
                [(UIImageView *)view setFrame:CGRectMake((width - 250 - 20) / 2, aktuelleHoehe, 250, 200)];
            }
            aktuelleHoehe += [(UIImageView *)view frame].size.height;
        }
    }
    


}


@end
