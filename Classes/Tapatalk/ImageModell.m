//
//  ImageModell.m
//  IBC
//
//  Created by Patrick Schwarz on 12.07.13.
//
//

#import "ImageModell.h"

@implementation ImageModell

// Ermittelt den Filename anand der URL
- (NSString *)getFileNameFromURL:(NSString *)url
{
    BOOL end = FALSE;
    int x = [url length]-1;
    NSString *newName = @"";
    
    while(end != TRUE) {
        if([url characterAtIndex:x] == '/' || [url characterAtIndex:x] == '\\' ) {
            end = TRUE;
        } else {
            newName = [newName stringByAppendingString:[NSString stringWithFormat:@"%c", [url characterAtIndex:x]]];
        }
        x--;
    }
    
    return newName;
}

// Wenn ein String verdreht ist, drehen wir ihn einfach um!
-(NSString *)reverseString:(NSString*)theString
{
    NSMutableString *reversedStr;
    int len = [theString length];
    
    reversedStr = [NSMutableString stringWithCapacity:len];
    
    while (len > 0) {
        [reversedStr appendString:
         [NSString stringWithFormat:@"%C", [theString characterAtIndex:--len]]];
    }
    return reversedStr;
}

// Cacht das image ub deb TMP ordner
- (void)cacheImage:(NSString *)url image:(UIImage *)image
{
    NSString *pathWithName = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), [self reverseString:[self getFileNameFromURL:url]]];
    
    // Is it PNG or JPG/JPEG?
    // Running the image representation function writes the data from the image to a file
    if([url rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
    {
        [UIImagePNGRepresentation(image) writeToFile:pathWithName atomically: YES];
    }else if([url rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound || [url rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound)
    {
        [UIImageJPEGRepresentation(image, 100) writeToFile:pathWithName atomically:YES];
    }
}

// lädt das gecached Image
- (UIImage *)getCachedImage:(NSString *)ImageURLString
{
    NSString *pathWithName = [NSTemporaryDirectory() stringByAppendingString:[self reverseString:[self getFileNameFromURL:ImageURLString]]];
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath:pathWithName])
    {
        return [UIImage imageWithContentsOfFile:pathWithName]; // this is the cached image
    }
    else
    {
        return nil;
    }
}

- (void)loadImageInBackground:(NSString *)url forImageView:(UIImageView *)imageView
{
    if(!imageView && !self.tableView) {
        return;
    }
    
    // Start Background Therad
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void)
    {
        NSURL *imgURL     = [NSURL URLWithString:url];
        NSData *imgData   = [NSData dataWithContentsOfURL:imgURL];
        UIImage *img    =  [[UIImage alloc] initWithData:imgData];
    
        if(img != (UIImage *)nil)
        {
            // Bild größe noch im Background runterrechnen
            float newWidth = img.size.width;
            float newHeight = img.size.height;
            
            while(newHeight > 200)
            {
                if(newHeight < 300 && newHeight > 200) {
                    newWidth = newWidth / 1.05;
                    newHeight = newHeight / 1.05;
                } else if(newHeight > 300) {
                    newWidth = newWidth / 1.5;
                    newHeight = newHeight / 1.5;
                }
            }
            
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            [img drawInRect:CGRectMake(0,0, CGSizeMake(newWidth, newHeight).width, CGSizeMake(newWidth, newHeight).height)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // Image Cachen
            [self cacheImage:url image:img];
            
            // In den Maintherad wechseln
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [imageView setFrame:CGRectMake((CGRectGetWidth(self.tableView.frame) / 2) - (newWidth / 4), (100 / 2) - (newHeight / 4), newWidth / 2, newHeight / 2)];
                [imageView setImage:newImage];
            }];
        }
    });
}

@end
