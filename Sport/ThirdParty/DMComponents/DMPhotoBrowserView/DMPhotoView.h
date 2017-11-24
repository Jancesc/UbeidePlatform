//
//  DMPhotoView.h
//  DMPhotoBrowser
//
//  Created by Damai on 15/9/25.
//  Copyright © 2015年 Damai. All rights reserved.
//

#define animationTime 0.3

#import <UIKit/UIKit.h>

@class DMPhoto,DMPhotoView;
@protocol DMPhotoViewDelegate <NSObject>

- (void)DMPhotoViewSingleTap:(DMPhotoView *)photoView;
- (void)DMPhotoViewDidEndZoom:(DMPhotoView *)photoView;
- (void)DMPhotoViewDownloadImageFailed: (DMPhotoView *)photoView;
- (void)DMPhotoViewDownloadImageSuccessed:(DMPhotoView *)photoView;

@end


@interface DMPhotoView : UIScrollView<UIScrollViewDelegate>
//图片
@property (nonatomic, strong) DMPhoto *photo;
//代理
@property (nonatomic, weak) id <DMPhotoViewDelegate> photoViewDelegate;

@end
