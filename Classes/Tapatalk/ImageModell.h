//
//  ImageModell.h
//  IBC
//
//  Created by Patrick Schwarz on 12.07.13.
//
//

#import <Foundation/Foundation.h>

#define MAX_IMAGEHEIGT 400 //px

@protocol ImageModellDelegate;

@interface ImageModell : NSObject

    @property (nonatomic, strong) id <ImageModellDelegate> delegate;
    @property (nonatomic, strong) UITableView *tableView;

    - (void)loadImageInBackground:(NSString *)url forImageView:(UIImageView *)imageView;

    - (NSString *)getFileNameFromURL:(NSString *)url;
    - (void)cacheImage:(NSString *)url image:(UIImage *)image;
    - (UIImage *)getCachedImage:(NSString *)ImageURLString;

@end

@protocol ImageModellDelegate
- (void)imageDidFinishLoading:(UIImage*)image imageView:(UIImageView *)imageView;
@end