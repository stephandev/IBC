//
//  Post.m
//  Tapatalk
//
//  Created by Manuel Burghard on 21.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Post.h"
#import "ContentTranslator.h"


@implementation Post
@synthesize postID, title, content, author, authorID, postDate, userIsOnline, imageUrl, images;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.author = [dictionary valueForKey:@"post_author_name"];
        self.authorID = [[dictionary valueForKey:@"post_author_id"] integerValue];
        //self.title = [dictionary valueForKey:@"post_title"];
        ContentTranslator *contentTranslator = [[ContentTranslator alloc] init];
        self.content = [contentTranslator translateStringForiOS:[dictionary valueForKey:@"post_content"]];
        self.userIsOnline = [[dictionary valueForKey:@"is_online"] boolValue];
        self.postID = [[dictionary valueForKey:@"post_id"] integerValue];
        
        NSString *dateString = [[dictionary valueForKey:@"post_time"] stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange(20, 1)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
        [dateFormatter setLocale:locale];
        NSString *dateFormat = @"yyyyMMdd'T'HH:mm:ssZZZ";
        [dateFormatter setDateFormat:dateFormat];
        self.postDate = [dateFormatter dateFromString:dateString];
        
        //NSLog(@"%@", content);
        imageUrl = [[NSMutableArray alloc] init];
        images = [[NSMutableArray alloc] init];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"disableImageView"] == FALSE) {
            NSArray *extensions = [NSArray arrayWithObjects:@"tiff", @"tif", @"jpg", @"JPG", @"jpeg", @"gif", @"png",@"bmp", @"BMP", @"ico", @"cur", @"xbm", @"PNG", @"JPEG", @"GIF", @"ICO", @"XBM", @"CUR", @"TIF", @"TIFF", nil];
            for(int x = 0; x<=extensions.count-1; x++)
            {
                NSString *regEx = [NSString stringWithFormat:@"http://(.*)\\.%@", [extensions objectAtIndex:x]];
            
            
                [content enumerateStringsMatchedByRegex:regEx options:RKLNoOptions inRange:NSMakeRange(0UL, [content length]) error:NULL enumerationOptions:RKLRegexEnumerationCapturedStringsNotRequired usingBlock:^(NSInteger captureCount, NSString * const capturedStrings[captureCount], const NSRange capturedRanges[captureCount], volatile BOOL * const stop)
                {
                
                    NSString *url = [content substringWithRange:(NSRange){capturedRanges[0].location, capturedRanges[0].length}];
                    [imageUrl addObject:url];

                    NSLog(@"Range: %@", url);
                }];
            }
        }
    }

    return self;
}

- (void)dealloc {
    self.userIsOnline = NO;
    self.authorID = 0;
    self.postID = 0;
}

@end
