//
//  ImageModell.h
//  IBC
//
//  Created by Patrick Schwarz on 12.07.13.
//
//

#import <Foundation/Foundation.h>

@interface ImageModell : NSObject

    @property (nonatomic, strong) UITableView *tableView;

    - (void)loadImageInBackground:(NSString *)url forImageView:(UIImageView *)imageView;

    - (NSString *)getFileNameFromURL:(NSString *)url;
    - (NSString *)reverseString:(NSString*)theString;
    - (void)cacheImage:(NSString *)url image:(UIImage *)image;
    - (UIImage *)getCachedImage:(NSString *)ImageURLString;

@end
