//
//  ImageModell.m
//  IBC
//
//  Created by Patrick Schwarz on 12.07.13.
//
//

#import "ImageModell.h"

@implementation ImageModell
@synthesize tableView;

// Ermittelt den Filename anand der URL
- (NSString *)getFileNameFromURL:(NSString *)url
{
    NSString* theFileName = [url lastPathComponent];
    return theFileName;
}

// Cacht das image ub deb TMP ordner
- (void)cacheImage:(NSString *)url image:(UIImage *)image
{
    NSString *pathWithName = [NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), [self getFileNameFromURL:url]];
    
    // Is it PNG or JPG/JPEG?
    // Running the image representation function writes the data from the image to a file
    if([url rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound ||
       [url rangeOfString: @".PNG" options: NSCaseInsensitiveSearch].location != NSNotFound )
    {
        [UIImagePNGRepresentation(image) writeToFile:pathWithName atomically: YES];
    }else if([url rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
             [url rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
             [url rangeOfString: @".JPEG" options: NSCaseInsensitiveSearch].location != NSNotFound ||
             [url rangeOfString: @".JPG" options: NSCaseInsensitiveSearch].location != NSNotFound  )
    {
        [UIImageJPEGRepresentation(image, 100) writeToFile:pathWithName atomically:YES];
    }
}

// lädt das gecached Image
- (UIImage *)getCachedImage:(NSString *)ImageURLString
{
    NSString *pathWithName = [NSTemporaryDirectory() stringByAppendingString:[self getFileNameFromURL:ImageURLString]];
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath:pathWithName]) {
        return [UIImage imageWithContentsOfFile:pathWithName]; // this is the cached image
    } else {
        return nil;
    }
}

- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float)i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToHight:(float)i_height
{
    float oldHight = sourceImage.size.height;
    float scaleFactor = i_height / oldHight;
    
    float newWidth = sourceImage.size.width * scaleFactor;
    float newHeight = oldHight * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)loadImageInBackground:(NSString *)url forImageView:(UIImageView *)imageView
{
    // Start Background Therad
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void)
    {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(100, 75, 50, 50);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [imageView addSubview:activityView];
            [activityView startAnimating];
        }];
        
        NSURL *imgURL     = [NSURL URLWithString:url];
        NSData *imgData   = [NSData dataWithContentsOfURL:imgURL];
        UIImage *img    =  [[UIImage alloc] initWithData:imgData];
    
        if(img != (UIImage *)nil)
        {
            // Bild größe noch im Background runterrechnen
            UIImage* newImage = [self imageWithImage:img scaledToHight:400];
            
            // wenn größer als 620 die breite ist muss diese runtergrechnet werden!
            if(newImage.size.width > 620) {
                newImage = [self imageWithImage:img scaledToWidth:310];
            }
            
            // Image Cachen
            [self cacheImage:url image:newImage];
            
            // In den Maintherad wechseln
            if(imageView) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [activityView stopAnimating];
                    [activityView removeFromSuperview];
                    
                    //[imageView setImage:newImage];
                    [self.delegate imageDidFinishLoading:newImage imageView:imageView];
                }];
            }
        }
    });
}

@end
