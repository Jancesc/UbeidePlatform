//
//  DMPhotoBrowserView.h
//  DMPhotoBrowserView
//
//  Created by Damai on 15/9/24.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPhoto.h"
@class DMPhotoBrowserView;

@protocol DMPhotoBrowserViewDelegate<NSObject>

@optional

- (void) DMPhotoBrowserViewDownloadFullScreenImageSuccessed:(DMPhotoBrowserView *)photoBrowserView withPhotoModel:(DMPhoto *)photo;
- (void) DMPhotoBrowserViewDownloadFullScreenImageFailed:(DMPhotoBrowserView *)photoBrowserView withphotoModel:(DMPhoto *)photo;
- (void) DMPhotoBrowserViewDismissed:(DMPhotoBrowserView *)photoBrowserView;

- (void) photoBrowserView:(DMPhotoBrowserView *) browserView didScrollToPage:(NSInteger) index;

@end

@interface DMPhotoBrowserView : UIView


/**DMPhoto模型的URL和fullScreenImage两者其中一个必须有值，srcView，thumbnail 必须有值*/
- (instancetype) initWithPhotoArray:(NSArray *)photos currentIndex : (NSInteger)currentIndex;

/**图片浏览时会占用整个屏幕*/
- (void)showOnView:(UIView *)view;
- (void)showOnKeyWindow;
- (void)showOnRootView;
- (void)dismiss;

@property (nonatomic, weak) id<DMPhotoBrowserViewDelegate> delegate;
@end
