
//
//  DMPictureView.m
//  DMPictureBrowserViewControllerDemo
//
//  Created by Damai on 15/10/22.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import "DMPictureView.h"

@interface DMPictureView ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIImageView *imageView;
@end
@implementation DMPictureView

- (id)initWithFrame:(CGRect)frame
{
    
    if ((self = [super initWithFrame:frame])) {
        self.clipsToBounds = YES;
        
        // 图片
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        // 属性
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // 监听点击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delaysTouchesBegan = YES;
        singleTap.numberOfTapsRequired = 1;
        
        [self addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail: doubleTap];
        
    }
    return self;
}

-(void)setPictureModel:(DMPictureModel *)pictureModel
{
    _pictureModel = pictureModel;
    
    //显示图片
    [self showImage];
}

#pragma mark 显示图片
- (void)showImage
{
        _imageView.image = _pictureModel.image;
        // 调整frame参数
        [self adjustFrame];

    
}


- (void) adjustFrame
{
    if (_imageView.image == nil) return;
    
    
    
    // 重置
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    self.contentSize = CGSizeMake(0, 0);
    
    // 基本尺寸参数
    CGSize boundsSize = self.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    
    CGSize imageSize = _imageView.image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    
    // 设置伸缩比例
    // 计算最小的scale，适应屏幕
    CGFloat xScale = boundsWidth / imageWidth;
    CGFloat yScale = boundsHeight / imageHeight;
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat maxScale = minScale * 2;
    
    
    if (imageSize.width > imageSize.height ) {
        
        maxScale = yScale ;
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
    
    CGRect imageFrame = CGRectMake(0, 0, boundsWidth, imageHeight * boundsWidth / imageWidth);
    // 内容尺寸
    self.contentSize = CGSizeMake(0, imageFrame.size.height);
    
    //x值
    if (imageFrame.size.width < boundsWidth) {
        
        imageFrame.origin.x = floorf((boundsWidth - imageFrame.size.width) / 2.0);
    } else{
        imageFrame.origin.x = 0;
    }
    
    // y值
    if (imageFrame.size.height < boundsHeight) {
        imageFrame.origin.y = floorf((boundsHeight - imageFrame.size.height) / 2.0);
    } else {
        imageFrame.origin.y = 0;
    }
    
    _imageView.frame = imageFrame;
    
    [self layoutCenter];
    
    
}


#pragma mark - 手势处理
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    [self.pictureViewDelegate DMPictureViewHandleSingleTap: self];
    
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
    
        
    CGPoint touchPoint = [tap locationInView:_imageView];
    if (self.zoomScale != self.minimumZoomScale) {
        [self setZoomScale: self.minimumZoomScale animated: YES];
    }
    else
    {
        CGFloat xsize = self.frame.size.width / self.maximumZoomScale;
        CGFloat ysize = self.frame.size.height / self.maximumZoomScale;
        CGRect rect = CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize);
        [self zoomToRect:rect animated:YES];
    }
}


#pragma mark
- (void)layoutCenter
{
    
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(_imageView.frame, frameToCenter))
        _imageView.frame = frameToCenter;
}


#pragma mark scrollView代理方法
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    [self layoutCenter];
    
}


-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ( scale > self.minimumZoomScale ) {
        
        self.scrollEnabled = YES;
    }else
    {
        self.scrollEnabled = NO;
    }
}


@end


