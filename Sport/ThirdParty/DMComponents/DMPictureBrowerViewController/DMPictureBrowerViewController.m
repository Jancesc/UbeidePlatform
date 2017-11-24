//
//  DMPictureBrowerViewController.m
//  DMPictureBrowserViewControllerDemo
//
//  Created by Damai on 15/10/22.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import "DMPictureBrowerViewController.h"
#import "DMPictureView.h"
#import "DMPictureModel.h"
#import "UIImage+ImageWithColor.h"

#define pictureMargin 10
#define DMPictureViewTagOffset 1000
#define DMPictureIndex(pictureView) ([pictureView tag] - DMPictureViewTagOffset)

static float const kDMAnimationTime = 0.5;

@interface DMPictureBrowerViewController ()<DMPictureViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger currentPictureIndex;
@property (nonatomic, assign) NSUInteger pictureCount;
@property (nonatomic, strong) NSMutableArray *pictureModelArray;
// 所有的图片view
@property (nonatomic, strong) NSMutableSet *visiblePictureViews;
@property (nonatomic, strong) NSMutableSet *reusablePictureViews;
@property (nonatomic, assign) BOOL ishiddenNavBar;
@property (nonatomic, strong) UIButton *trashButton;
@end

@implementation DMPictureBrowerViewController

- (instancetype)initWithImageArray:(NSArray *)imageArray currentIndex:(NSUInteger)currentIndex
{
    if (self = [super init]) {
        _showDeleteButton = YES;
        _pictureCount = [imageArray count];
        _currentPictureIndex  = currentIndex;
        _pictureModelArray = [NSMutableArray array];
        _visiblePictureViews = [NSMutableSet set];
        _reusablePictureViews = [NSMutableSet set];
        _ishiddenNavBar = NO;
        for (NSInteger i = 0; i <[imageArray count] ; i++)
        {
            UIImage *image = imageArray[i];
            DMPictureModel *pictureModel = [[DMPictureModel alloc] initWithImage: image index: i];
            [_pictureModelArray addObject: pictureModel];

        }
        
    }
    
    return  self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat: @"%ld/%lu", (long)_currentPictureIndex + 1, (unsigned long)_pictureCount];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1.0];

    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x -= pictureMargin;
    frame.size.width += (2 * pictureMargin);
    _scrollView = [[UIScrollView alloc] initWithFrame: frame];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor =  [UIColor clearColor];//[UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1.0];
    CGFloat offsetX =frame.size.width * _currentPictureIndex;
    _scrollView.contentOffset = CGPointMake(offsetX, 0);
    _scrollView.contentSize = CGSizeMake(frame.size.width * _pictureCount, 0);
    _scrollView.delegate = self;
    [self.view  addSubview: _scrollView];
    
    if (_showDeleteButton) {
        _trashButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 22, 22)];
        [_trashButton setImage: [[UIImage imageNamed: @"DMPictureBrowserViewController.Bundle/trash"] imageWithColor:UIColorWithRGB(0x0a, 0xcb, 0x7c)] forState: UIControlStateNormal];
        [_trashButton setImage: [[UIImage imageNamed: @"DMPictureBrowserViewController.Bundle/trash"] imageWithColor:UIColorWithRGB(0x0a, 0xcb, 0x7c)]forState: UIControlStateHighlighted];
        [_trashButton addTarget: self action: @selector(trashButtonOnClick:) forControlEvents: UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: _trashButton];
    }
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 44)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:UIColorWithRGB(0x0a, 0xcb, 0x7c) forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [backButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    // Do any additional setup after loading the view.
    [self showPhotos];
}

- (void)trashButtonOnClick: (UIButton *)button
{
    UIAlertController *actionSheetVC = [UIAlertController alertControllerWithTitle: @"要删除这张照片吗？" message: nil  preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle: @"删除" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deletePicture];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheetVC addAction: deleteAction];
    [actionSheetVC addAction: cancelAction];
    [self presentViewController: actionSheetVC animated: YES completion: nil];
}

- (void)backButtonOnClick:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) deletePicture
{
    if (_currentPictureIndex != 0) {
    
        [_pictureModelArray removeObjectAtIndex: _currentPictureIndex];
        if ([self.delegate respondsToSelector:@selector(DMPictureBrowerViewControllerDidDeleteAllPictures:)])
        {
            [self.delegate DMPictureBrowerViewController: self DidDeletePictureWithIndex: _currentPictureIndex];

        }
        _pictureCount = [_pictureModelArray count];
        CGFloat offsetX = _scrollView.contentOffset.x - [UIScreen mainScreen].bounds.size.width - 2 * pictureMargin ;
        _scrollView.contentOffset = CGPointMake( offsetX, 0);
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width *  _pictureCount, 0) ;

        return;
 
    }else
    {
        if (_pictureCount > 1) {
            
            [_pictureModelArray removeObjectAtIndex: _currentPictureIndex];
            if ([self.delegate respondsToSelector:@selector(DMPictureBrowerViewController:DidDeletePictureWithIndex:)])
            {
                [self.delegate DMPictureBrowerViewController: self DidDeletePictureWithIndex: _currentPictureIndex];
            }
            _pictureCount = [_pictureModelArray count];
            //移除当前的pictureView
            [self removePictureView];
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width *  _pictureCount, 0);
            [self scrollViewDidScroll: _scrollView];

            return;
        }
        
        [_pictureModelArray removeObjectAtIndex: _currentPictureIndex];
        if ([self.delegate respondsToSelector:@selector(DMPictureBrowerViewController:DidDeletePictureWithIndex:)])
        {
            [self.delegate DMPictureBrowerViewController: self DidDeletePictureWithIndex: _currentPictureIndex];
        }
        if ([self.delegate respondsToSelector:@selector(DMPictureBrowerViewControllerDidDeleteAllPictures:)])
        {
             [self.delegate DMPictureBrowerViewControllerDidDeleteAllPictures: self];
        }
    }
    


}

#pragma mark 移除当前的pictureView
- (void)removePictureView
{
    for (DMPictureView *pictureView in _visiblePictureViews) {
        if (pictureView.frame.origin.x == _currentPictureIndex * _scrollView.frame.size.width + pictureMargin) {
            
            [_reusablePictureViews addObject: pictureView];
            [pictureView removeFromSuperview];
        }
    }
}


#pragma mark 显示照片
- (void) showPhotos
{
    CGRect visibleBounds = _scrollView.bounds;
    NSInteger firstIndex = floorf((CGRectGetMinX(visibleBounds) + pictureMargin * 2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floorf((CGRectGetMaxX(visibleBounds) - pictureMargin * 2 - 1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _pictureCount) firstIndex = _pictureCount - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _pictureCount) lastIndex = _pictureCount - 1;
    
    // 回收不再显示的ImageView
    NSInteger pictureViewIndex;
    for (DMPictureView *pictureView in _visiblePictureViews) {
        pictureViewIndex = DMPictureIndex(pictureView);
        if (pictureViewIndex < firstIndex || pictureViewIndex > lastIndex) {
            [_reusablePictureViews addObject: pictureView];
            [pictureView removeFromSuperview];
        }
    }
    
    [_visiblePictureViews minusSet: _reusablePictureViews];
    while (_reusablePictureViews.count > 2) {
        [_reusablePictureViews removeObject:[_reusablePictureViews anyObject]];
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
    DMPictureView *pictureView = [self dequeueReusablePictureView];
    if (!pictureView) { // 添加新的图片view
        pictureView = [[DMPictureView alloc] init];
        pictureView.pictureViewDelegate = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _scrollView.bounds;
    CGRect pictureViewFrame = bounds;
    pictureViewFrame.size.width -= (2 * pictureMargin);
    pictureViewFrame.origin.x = (bounds.size.width * index) + pictureMargin;
    pictureView.tag = DMPictureViewTagOffset + index;
    
    DMPictureModel *pictureModel = _pictureModelArray[index];
    pictureView.frame = pictureViewFrame;
    pictureView.pictureModel = pictureModel;
    
    [_visiblePictureViews addObject: pictureView];
    [_scrollView addSubview: pictureView];
    
}

#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (DMPictureView *pictureView in _visiblePictureViews) {
        if (DMPictureIndex(pictureView) == index) {
            return YES;
        }
    }
    return  NO;
}


#pragma mark 循环利用某个view
- (DMPictureView *)dequeueReusablePictureView
{
    DMPictureView *pictureView = [_reusablePictureViews anyObject];
    if (pictureView) {
        [_reusablePictureViews removeObject:pictureView];
    }
    return pictureView;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_currentPictureIndex != (NSInteger) _scrollView.contentOffset.x / _scrollView.frame.size.width)
    {
        _currentPictureIndex = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    }
    [self showPhotos];


    _ishiddenNavBar = YES;
    [self changeBarsStatusWithHidden: _ishiddenNavBar];

    self.navigationItem.title = [NSString stringWithFormat: @"%ld/%lu", (long)_currentPictureIndex + 1, (unsigned long)_pictureCount];
}

#pragma mark DMPictureViewDelegate
- (void)DMPictureViewHandleSingleTap:(DMPictureView *)pictureView
{
    _ishiddenNavBar = !_ishiddenNavBar;

    [self changeBarsStatusWithHidden: _ishiddenNavBar];
}

- (void)changeBarsStatusWithHidden: (BOOL) isHidden
{
    if (isHidden) {
        
     [UIView animateWithDuration: kDMAnimationTime animations:^{
         [self setNeedsStatusBarAppearanceUpdate];

     } completion:^(BOOL finished) {
             [self.navigationController setNavigationBarHidden: YES animated: YES];

     }];
        
    }else
    {
        
        [UIView animateWithDuration: kDMAnimationTime animations:^{
            
            [self setNeedsStatusBarAppearanceUpdate];
            [self.navigationController setNavigationBarHidden: NO animated: NO ];
        }];
    }
    
}

#pragma mark -

- (BOOL)prefersStatusBarHidden
{
    return _ishiddenNavBar;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}


@end


