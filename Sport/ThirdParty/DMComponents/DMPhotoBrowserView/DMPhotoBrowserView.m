//
//  DMPhotoBrowserView.m
//  DMPhotoBrowserView
//
//  Created by Damai on 15/9/24.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import "DMPhotoBrowserView.h"
#import "SDWebImageManager.h"
#import "DMPhotoView.h"

#define photoMargin 10
#define DMPhotoViewTagOffset 1000
#define DMPhotoViewIndex(photoView) ([photoView tag] - DMPhotoViewTagOffset)
@interface DMPhotoBrowserView ()<DMPhotoViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@property (nonatomic, assign, readonly) NSUInteger photoCount;
@property (nonatomic, strong) NSArray *photoArray;
// 所有的图片view
@property (nonatomic, strong) NSMutableSet *visiblePhotoViews;
@property (nonatomic, strong) NSMutableSet *reusablePhotoViews;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSURLSession *session;
@end


@implementation DMPhotoBrowserView

-(instancetype)initWithPhotoArray:(NSArray *)photos currentIndex:(NSInteger)currentIndex
{
    
    if ( self = [super init] ) {
        
        
        self.frame = [UIScreen mainScreen].bounds;
        
        
        _currentPhotoIndex = currentIndex;
        
        _photoArray  = photos;
        
        if (photos.count > 1) {
            _visiblePhotoViews = [NSMutableSet set];
            _reusablePhotoViews = [NSMutableSet set];
        }
        
        for (NSInteger i = 0; i<photos.count; i++) {
            DMPhoto *photo = photos[i];
            photo.index = i;
            photo.firstShow = i == currentIndex;
        }
        
        
        _photoCount = photos.count;
        _backgroundView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
        [_backgroundView setBackgroundColor: [UIColor blackColor]];
        [self addSubview: _backgroundView];
        
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.x -= photoMargin;
        frame.size.width += (2 * photoMargin);
        _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
        _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _photoScrollView.pagingEnabled = YES;
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.showsVerticalScrollIndicator = NO;
        _photoScrollView.backgroundColor = [UIColor clearColor];
        _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photoCount, 0);
        
        _photoScrollView.delegate = self;
        [self addSubview:_photoScrollView];
        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
        
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        CGRect pageFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height * 0.9, [UIScreen mainScreen].bounds.size.width, 35);
        pageControl.frame = pageFrame;
        pageControl.numberOfPages = _photoCount;
        pageControl.currentPage = _currentPhotoIndex;
        pageControl.hidesForSinglePage = YES;
        pageControl.enabled = NO;
        self.pageControl = pageControl;
        [self addSubview: pageControl];

    }
    
    return self;
}


- (void)dismiss
{
    
    [self removeFromSuperview];
}



#pragma mark 显示照片
- (void)showOnKeyWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview: self];
    [self showPhotos];
}


-(void)showOnRootView
{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *rootView = window.rootViewController.view;
    [rootView addSubview: self];
    [self showPhotos];
}

-(void)showOnView:(UIView *)view
{
    
    [view addSubview: self];
    [self showPhotos];
}



- (void) showPhotos
{
    // 只有一张图片
    if (_photoCount == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = floorf((CGRectGetMinX(visibleBounds) + photoMargin*2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floorf((CGRectGetMaxX(visibleBounds) - photoMargin*2 - 1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _photoCount) firstIndex = _photoCount - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _photoCount) lastIndex = _photoCount - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex;
    for (DMPhotoView *photoView in _visiblePhotoViews) {
        photoViewIndex = DMPhotoViewIndex(photoView);
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [_reusablePhotoViews addObject:photoView];
            [photoView removeFromSuperview];
        }
    }
    
    [_visiblePhotoViews minusSet:_reusablePhotoViews];
    while (_reusablePhotoViews.count > 2) {
        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
    }
    
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
    
}


#pragma mark 显示一个图片view
- (void)showPhotoViewAtIndex:(NSUInteger)index
{
    DMPhotoView *photoView = [self dequeueReusablePhotoView];
    if (!photoView) { // 添加新的图片view
        photoView = [[DMPhotoView alloc] init];
        photoView.photoViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * photoMargin);
    photoViewFrame.origin.x = (bounds.size.width * index) + photoMargin;
    photoView.tag = DMPhotoViewTagOffset + index;
    
   DMPhoto *photo = _photoArray[index];
    photoView.frame = photoViewFrame;
    photoView.photo = photo;
    
    [_visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
    
    [self loadImageNearIndex:index];
}


#pragma mark 加载index附近的图片
- (void)loadImageNearIndex:(NSUInteger)index
{
    if (index > 0) {
        DMPhoto *photo = _photoArray[index - 1];
        if ( !photo.fullScreenImage) {
            
            [self downloadImageWithPhotoModel:photo];
        }
        
    }
    
    if (index < _photoCount - 1) {
        DMPhoto *photo = _photoArray[index + 1];
        if ( !photo.fullScreenImage) {
            
            [self downloadImageWithPhotoModel:photo];
        }
    }
}


#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (DMPhotoView *photoView in _visiblePhotoViews) {
        if (DMPhotoViewIndex(photoView) == index) {
            return YES;
        }
    }
    return  NO;
}


#pragma mark 循环利用某个view
- (DMPhotoView *)dequeueReusablePhotoView
{
    DMPhotoView *photoView = [_reusablePhotoViews anyObject];
    if (photoView) {
        [_reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}


#pragma mark
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self showPhotos];
    [self changePage];

}



- (void) changePage
{
    _currentPhotoIndex = _photoScrollView.contentOffset.x / _photoScrollView.frame.size.width;
    _pageControl.currentPage = _currentPhotoIndex;
    if ([_delegate respondsToSelector:@selector(photoBrowserView:didScrollToPage:)]) {
        [_delegate photoBrowserView:self didScrollToPage:_currentPhotoIndex];
    }
}


- (void) downloadImageWithPhotoModel : (DMPhoto *)photo
{
    //先加入缓存
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString: photo.url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        
    }];
//    [manager downloadImageWithURL: [NSURL URLWithString: photo.url] options: SDWebImageRetryFailed progress: nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//    } ];
}

#pragma mark DMphotoView的代理方法
- (void)DMPhotoViewSingleTap:(DMPhotoView *)photoView
{
    
    [UIView  animateWithDuration: animationTime animations:^{
        
        self.hidden = YES;
        self.backgroundView.backgroundColor = [UIColor clearColor];
    }];
    
}


- (void)DMPhotoViewDidEndZoom:(DMPhotoView *)photoView
{
    
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(DMPhotoBrowserViewDismissed:)]) {
        [self.delegate DMPhotoBrowserViewDismissed:self];
    }
}



- (void) DMPhotoViewDownloadImageSuccessed:(DMPhotoView *)photoView
{
    if ([_delegate respondsToSelector:@selector(DMPhotoBrowserViewDownloadFullScreenImageSuccessed:withPhotoModel:)]) {
        [self.delegate DMPhotoBrowserViewDownloadFullScreenImageSuccessed: self withPhotoModel: photoView.photo];
    }
}

- (void) DMPhotoViewDownloadImageFailed:(DMPhotoView *)photoView
{
    if ([_delegate respondsToSelector:@selector(DMPhotoBrowserViewDownloadFullScreenImageFailed:withphotoModel:)]) {
        [self.delegate DMPhotoBrowserViewDownloadFullScreenImageFailed: self withphotoModel: photoView.photo];
    }
}
@end
