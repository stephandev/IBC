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
    
    // Bilder fertig geladen
    //NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[self getFileNameFromURL:url] forKey:@"imageName"];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"imageIsReadyLoading" object:nil userInfo:userInfo];
}

// lädt das gecached Image
- (UIImage *)getCachedImage:(NSString *)ImageURLString
{
    NSString *pathWithName = [NSTemporaryDirectory() stringByAppendingString:[self getFileNameFromURL:ImageURLString]];
    
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
            float newWidth = img.size.width;
            float newHeight = img.size.height;
            
            while(newHeight > 200)
            {
                if(newHeight < 300 && newHeight > 200) {
                    newWidth = newWidth / 1.02;
                    newHeight = newHeight / 1.02;
                } else if(newHeight > 300) {
                    newWidth = newWidth / 1.5;
                    newHeight = newHeight / 1.5;
                }
            }
            
            UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
            [img drawInRect:CGRectMake(0,0, CGSizeMake(newWidth, newHeight).width, CGSizeMake(newWidth, newHeight).height)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSLog(@"H: %f W: %f", newImage.size.height, newImage.size.width);
            
            // Image Cachen
            [self cacheImage:url image:img];
            
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
