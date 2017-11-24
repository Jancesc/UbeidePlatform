//
//  DMPhotoView.m
//  DMPhotoBrowser
//
//  Created by Damai on 15/9/25.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import "DMPhotoView.h"
#import "DMPhoto.h"
#import "SDWebImageManager.h"

@interface DMPhotoView ()<UIActionSheetDelegate>
{
    UIImageView *_imageView;
    BOOL _firstShow;
    UIView *_defaultSrcView;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end



@implementation DMPhotoView


//懒加载
- (UIActivityIndicatorView *)activityIndicator
{
    
    if (!_activityIndicator) {
        
        UIActivityIndicatorView *activityView = [[ UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
        activityView.center = CGPointMake( [UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        [self addSubview: activityView];
        _activityIndicator = activityView;
    }
    
    return _activityIndicator;
}


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
        
        UILongPressGestureRecognizer *longPressTap = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector( handleLongPressTap:)];
        longPressTap.minimumPressDuration = 1;
        [self addGestureRecognizer:longPressTap];
        [self.panGestureRecognizer requireGestureRecognizerToFail: longPressTap];
        [self.pinchGestureRecognizer requireGestureRecognizerToFail: longPressTap];
        [singleTap requireGestureRecognizerToFail: longPressTap];
    }
    return self;
}


#pragma mark - photoSetter
- (void)setPhoto:(DMPhoto *)photo {
    
    _photo = photo;
    
    //是否是第一次显示
    _firstShow = NO;
    if (photo.firstShow) {
        
        _firstShow = YES;
        photo.firstShow = NO;
    }
    
    // 隐藏activityIndicator
    [self.activityIndicator stopAnimating];
    
    //显示图片
    [self showImage];
}


#pragma mark 显示图片
- (void)showImage
{
    if (!_photo.srcView) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.35 * SCREEN_WIDTH, 0.5 * (SCREEN_HEIGHT - 0.3 * SCREEN_WIDTH), 0.3 * SCREEN_WIDTH, 0.3 * SCREEN_WIDTH)];
        _defaultSrcView = view;
        view.tag = 888;
        _photo.srcView = view;
    }
    if (!_photo.fullScreenImage) { //没有大图
        
        _imageView.image = _photo.thumbnail;
        _imageView.frame = [_photo.srcView convertRect:_photo.srcView.bounds toView:nil];
        _imageView.center = CGPointMake( [UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        
        //显示正在加载
        [self.activityIndicator startAnimating];
        __unsafe_unretained DMPhotoView *photoView = self;
        __unsafe_unretained DMPhoto *photo = _photo;
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:[NSURL URLWithString: _photo.url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            [photoView.activityIndicator stopAnimating];
            if(error) {
                _imageView.image = _photo.thumbnail;
                return ;
                
            }
            photo.fullScreenImage = image;
            _imageView.image = image;
            
            // 调整frame参数
            CGRect preFrame = _imageView.frame;
            [photoView adjustFrame];
            
            CGRect newFrame = _imageView.frame;
            _imageView.frame = preFrame;
            [UIView animateWithDuration: animationTime animations:^{
                
                _imageView.frame = newFrame;
                
            }];
            //通知代理
            [self.photoViewDelegate DMPhotoViewDownloadImageSuccessed: self];
        }];
        
    }
    else
    {
        if (_firstShow) {
            
            _imageView.image = _photo.fullScreenImage;
            [self adjustFrame];
            CGRect frame = _imageView.frame;

            _imageView.frame =_photo.srcView.frame;
            [UIView animateWithDuration: animationTime animations:^{
                
                _imageView.frame = frame;
                
            }];
            return;
        }
        
        _imageView.image = _photo.fullScreenImage;
        // 调整frame参数
        [self adjustFrame];

    }

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
    

    UIView *screenView = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.frame = _imageView.frame;
    imageView.image = _imageView.image;
    [screenView addSubview: imageView];
    [[UIApplication sharedApplication].keyWindow addSubview: screenView];
    [self.photoViewDelegate DMPhotoViewSingleTap:self];
    
    [UIView  animateWithDuration: animationTime delay: 0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (_photo.srcView && _photo.srcView.tag != 888)
        {
            imageView.frame = [_photo.srcView convertRect:_photo.srcView.bounds toView:nil];
        }
        else
        {
            imageView.transform = CGAffineTransformIdentity;
            imageView.frame = CGRectMake(0.5 * SCREEN_WIDTH, 0.5 * SCREEN_HEIGHT, 1, 1);
            imageView.alpha = 0.1;
        }
     
    } completion:^(BOOL finished) {
        
        if (finished) {
            [screenView removeFromSuperview];
            [self.photoViewDelegate DMPhotoViewDidEndZoom:self];
        }
    }];

  
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

- (void)handleLongPressTap:(UILongPressGestureRecognizer *) longPress {
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
         [ self showActionsheet];
    }

   

}

- (void)showActionsheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: @"返回" destructiveButtonTitle:nil otherButtonTitles: @"保存图片", @"举报",nil];

    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView: self];
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

#pragma mark actionSheet代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self saveImage];
            break;
            
       case 1:
            [self report];
            break;
            
        default:
            break;
    }
}


#pragma mark
- (void)saveImage
{
    UIImageWriteToSavedPhotosAlbum(_photo.fullScreenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


- (void)report
{
#warning 举报
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (!error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"已保存到相册" message: nil delegate: nil cancelButtonTitle: nil otherButtonTitles: nil];
            [alert show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0), dispatch_get_main_queue(), ^{
                
                [alert dismissWithClickedButtonIndex: alert.cancelButtonIndex animated: YES];
            });
        
        _photo.save = YES;
    } else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"无法保存到相册" message: nil delegate: nil cancelButtonTitle: @"我已经知道了" otherButtonTitles: nil];
        [alert show];
        
    }
}

@end
