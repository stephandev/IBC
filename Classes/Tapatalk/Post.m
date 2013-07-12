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
@synthesize postID, title, content, author, authorID, postDate, userIsOnline, imageUrl;

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
        
        imageUrl = [[NSMutableArray alloc] init];
        
        [self searchAndFindUrl];
    }

    return self;
}

- (void)searchAndFindUrl
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"disableImageView"] == FALSE)
    {
        NSArray *extensions = [NSArray arrayWithObjects:@"tiff", @"tif", @"jpg", @"JPG", @"jpeg", @"gif", @"png",@"bmp", @"BMP", @"ico", @"cur", @"xbm", @"PNG", @"JPEG", @"GIF", @"ICO", @"XBM", @"CUR", @"TIF", @"TIFF", nil];
        
        // Work!
        NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil]; 
        NSArray *matches = [linkDetector matchesInString:content options:0 range:NSMakeRange(0, [content length])];
        
        for (NSTextCheckingResult *match in matches)
        {
            NSURL *url = [match URL];
            if ([[url scheme] isEqual:@"http"]) {
                NSURL *FoundURL = [match URL];
                NSString *extension = [[FoundURL absoluteString] pathExtension];
                
                for (NSString *e in extensions) {
                    if ([extension isEqualToString:e]) {
                        NSString *url = [FoundURL absoluteString];
                        [imageUrl addObject:url];
                        
                        // Remove this URL!
                        content = [content stringByReplacingOccurrencesOfString:url withString:@""];
                        
                        break;
                    }
                }
            }
        }
    }
}

- (void)dealloc {
    self.userIsOnline = NO;
    self.authorID = 0;
    self.postID = 0;
}

@end
