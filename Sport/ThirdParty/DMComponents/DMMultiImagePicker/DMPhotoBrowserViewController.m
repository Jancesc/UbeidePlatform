//
//  DMPhotoBrowserViewController.m
//  DMMultiImagePickerDemo
//
//  Created by Damai on 15/9/30.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import "DMPhotoBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DMAssetModel.h"
#import "DMPhotoBrowserViewCell.h"

#define DMPhotoBrowserViewCellTagOffset 1000
#define DMPhotoBrowserViewCellIndex(photoViewCell) ([photoViewCell tag] - DMPhotoBrowserViewCellTagOffset)

@interface DMPhotoBrowserViewController ()<UIScrollViewDelegate,DMPhotoBrowserViewCellDelegate>

@property ( nonatomic, assign ) BOOL hiddenBars;
@property ( nonatomic, strong ) NSArray *assetsModels;

//当前显示的browserCell索引
@property ( nonatomic, assign ) int  currentIndex;
@property ( nonatomic, strong ) UIButton *selectedButton;
@property ( nonatomic, strong ) UIButton *finishButton;
//显示已选中图片的标签
@property ( nonatomic, strong ) UILabel *countLabel;
//已选中的图片
@property ( nonatomic, assign ) int selectedCount;
//图片数目更改时的动画视图
@property ( nonatomic, strong ) UIView *animateView;
@property ( nonatomic, assign ) int maxCount;
// 所有的图片view
@property (nonatomic, strong) NSMutableSet *visiblePhotoViewCells;
@property (nonatomic, strong) NSMutableSet *reusablePhotoViewCells;
@property (nonatomic, assign) int assetCount;
//@property (nonatomic, assign) BOOL showPhotoIndex;
@end

@implementation DMPhotoBrowserViewController

- ( instancetype )initWithAssetsModels:(NSArray *)assetsModelArray
{
    
    if ( self = [ super init ]) {
        
        _assetCount = (int)[assetsModelArray count];
        if ([assetsModelArray count] > 1) {
            
            _visiblePhotoViewCells = [NSMutableSet set];
            _reusablePhotoViewCells = [NSMutableSet set];
        }
        _assetsModels = assetsModelArray ;
        
        _selectedCount = 0;

        [self setMaxCount:0];
        // 设置scrollView的frame
        CGRect bounds =[ UIScreen mainScreen ].bounds;
        bounds.size.width = bounds.size.width + 2 * padding;
        bounds.origin.x = bounds.origin.x - padding ;
        _browserView = [[ UIScrollView alloc ] init ];
        _browserView.frame =bounds;
        _browserView.contentSize = CGSizeMake( _assetCount * ( bounds.size.width ), 0 );
        _browserView.pagingEnabled =YES;
        _browserView.delegate = self;
        _browserView.backgroundColor = [ UIColor blackColor ];
        _browserView.showsHorizontalScrollIndicator = NO;
        _browserView.showsVerticalScrollIndicator = NO;
        [self.view  addSubview: _browserView ];
        
    }
    return self;
}


-(instancetype)initWithAssetsModels:(NSArray *)assetsModelArray maxSelectedCount:(int)maxCount selectedCount:(NSUInteger)selectedCount{
    
    self = [ self initWithAssetsModels: assetsModelArray ];
    [self setMaxCount: maxCount];
    _selectedCount = (int) selectedCount;
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //创建toolbar的完成视图
    UIView *view = [ self setupFinishView];
    UIBarButtonItem *finishBarButton = [[ UIBarButtonItem alloc ] initWithCustomView:view];
    
    UIBarButtonItem *spaceButton = [[ UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[ spaceButton , finishBarButton ] animated:YES ];
    self.automaticallyAdjustsScrollViewInsets = NO ;
    

    DMAssetModel *currentAssetModel = _assetsModels[self.currentIndex];
    //添加选择状态按钮
    UIButton *selectedButton = [[ UIButton alloc ] initWithFrame: CGRectMake( 0, 0, 25, 25)];
    selectedButton.selected = currentAssetModel.selected ;
    [selectedButton addTarget: self action: @selector(selectedButtonOnClick:) forControlEvents: UIControlEventTouchUpInside ];
    
    [ selectedButton setImage: [UIImage imageNamed: @"DMMultiImagePicker.bundle/unclick" ] forState: UIControlStateNormal] ;
    
    [ selectedButton setImage: [UIImage imageNamed: @"DMMultiImagePicker.bundle/clicked" ] forState:UIControlStateSelected] ;
    
    self.navigationItem.rightBarButtonItem = [[ UIBarButtonItem alloc ] initWithCustomView: selectedButton];
    //添加返回按钮
    UIButton *backButton = [[ UIButton alloc ] initWithFrame: CGRectMake( 0, 0,  40, 40)];
    [ backButton setTitle: @"返回" forState: UIControlStateNormal ];
    [backButton setTitleColor:UIColorWithRGB(0x0a, 0xcb, 0x7c) forState:UIControlStateNormal];
    [backButton addTarget: self action: @selector( backButtonOnClick:) forControlEvents: UIControlEventTouchUpInside ];
    self.navigationItem.leftBarButtonItem = [[ UIBarButtonItem alloc ] initWithCustomView: backButton ];
    
    // 加载图片
    [self showPhotos];
    _selectedButton =selectedButton;
}


-(void)viewWillAppear:(BOOL)animated
{
    //默认不隐藏navigationBar 和 toolBar
    _hiddenBars = NO;
    [self.navigationController setNavigationBarHidden: _hiddenBars ];
    [self.navigationController setToolbarHidden: _hiddenBars ];
    [self setSelectedCount: _selectedCount];
}

-(void)setBrowserViewContentOffet:(CGPoint)offet
{
    
    _browserView.contentOffset = offet;
    
    CGFloat length = _browserView.contentOffset.x;
     self.currentIndex = (int) ( length   / ([ UIScreen mainScreen ].bounds.size.width + 2 * padding ));

    
}

- ( UIView * ) setupFinishView
{
    
    UIView *view = [[ UIView alloc ] init ];
    view.frame = CGRectMake( 0, 0, 60, 44);
    
    //完成按钮
    UIButton *finishbutton = [[ UIButton alloc ] initWithFrame: view.frame ];
    
    [ finishbutton setTitle: @"完成" forState: UIControlStateNormal ];
    finishbutton.titleEdgeInsets = UIEdgeInsetsMake( 0, 18, 0, 0);
    [ finishbutton addTarget: self action: @selector( finishButtonOnClick:) forControlEvents:UIControlEventTouchUpInside ];
    self.finishButton = finishbutton ;
    [view addSubview: finishbutton ];
    
    //左边的动画view
    UIView *animateView = [[ UIView alloc ] init ];
    animateView.frame = CGRectMake(2, 13, 18, 18);
    animateView.layer.cornerRadius = animateView.frame.size.width * 0.5 ;
    animateView.layer.masksToBounds = YES;
    self.animateView = animateView ;
    [view addSubview:animateView ];
    
    //左边的数字label
    UILabel *countlabel = [[ UILabel alloc ] init ];
    countlabel.textColor = [ UIColor whiteColor ];
    countlabel.textAlignment = NSTextAlignmentCenter ;
    countlabel.frame = animateView.frame;
    self.countLabel = countlabel;
    [view addSubview:countlabel ];
    
    [ self setSelectedCount: _selectedCount];
    return view ;
    
    
}

#pragma mark

- ( void )finishButtonOnClick : (UIButton *)button
{
    
    NSMutableArray *arrayM = [ NSMutableArray array ];
    for ( DMAssetModel *assetModel in _assetsModels ) {
        
        if ( assetModel.selected == YES ) {
            
            [arrayM addObject: assetModel ];
        }
    }
    if ([self.delegate respondsToSelector:@selector(DMPhotoBrowserViewController:finishBrowserWithAssetModels:)])
    {
        [ self.delegate DMPhotoBrowserViewController: self finishBrowserWithAssetModels: arrayM ];
    }

    
    
    
}


- (void) backButtonOnClick : ( UIButton *) backButton
{
    if (self.delegate)
    {
        [ self.delegate DMPhotoBrowserViewController: self backButtonOnClickWithAssetModels: self.assetsModels ];
        [self.navigationController popViewControllerAnimated: YES ];
    }
}

- (void) selectedButtonOnClick : (UIButton *) selectedButton
{
    
    if ( !selectedButton.selected )   {
        
        //最大只能选9张
        if ( self.selectedCount == self.maxCount ) {
            
            UIAlertView *alertView =  [[ UIAlertView alloc] initWithTitle: nil message: [ NSString stringWithFormat: @"你最多只能选择%d张图片" , self.maxCount ] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil ];
            [ alertView show ];
            
            return;
            
        }
        self.selectedCount ++;
        selectedButton.selected = !selectedButton.selected;
        DMAssetModel * assetModel = self.assetsModels [self.currentIndex];
        assetModel.selected = selectedButton.selected;
        
    }else
    {
        self.selectedCount --;
        selectedButton.selected = !selectedButton.selected;
        DMAssetModel * assetModel = self.assetsModels [self.currentIndex];
        assetModel.selected = selectedButton.selected;
    }
}




#pragma mark 显示照片
- (void) showPhotos
{
    // 只有一张图片
    if (_assetCount == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _browserView.bounds;
    int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds) + padding * 2) / CGRectGetWidth(visibleBounds));
    int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds) - padding * 2 - 1) / CGRectGetWidth(visibleBounds));
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex >= _assetCount) firstIndex = (int)_assetCount - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex >= _assetCount) lastIndex = (int)_assetCount - 1;
    
    // 回收不再显示的ImageView
    NSInteger photoViewCellIndex;
    for (DMPhotoBrowserViewCell *photoViewCell in _visiblePhotoViewCells) {
        photoViewCellIndex = DMPhotoBrowserViewCellIndex(photoViewCell);
        if (photoViewCellIndex < firstIndex || photoViewCellIndex > lastIndex) {
            [_reusablePhotoViewCells addObject:photoViewCell];
            [photoViewCell removeFromSuperview];
        }
    }
    
    [_visiblePhotoViewCells minusSet:_reusablePhotoViewCells];
    while (_reusablePhotoViewCells.count > 2) {
        [_reusablePhotoViewCells removeObject:[_reusablePhotoViewCells anyObject]];
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
    DMPhotoBrowserViewCell *photoViewCell = [self dequeueReusablePhotoView];
    if (!photoViewCell) { // 添加新的图片view
        photoViewCell = [[DMPhotoBrowserViewCell alloc] init];
        photoViewCell.DMPhotoBrowserViewCellDelegate  = self;
    }
    
    // 调整当期页的frame
    CGRect bounds = _browserView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.size.width -= (2 * padding);
    photoViewFrame.origin.x = (bounds.size.width * index) + padding;
    photoViewCell.tag = DMPhotoBrowserViewCellTagOffset + index;
    
    DMAssetModel *assetModel = _assetsModels[index];
    photoViewCell.frame = photoViewFrame;
    photoViewCell.assetModel = assetModel;
    
    [_visiblePhotoViewCells addObject:photoViewCell];
    [_browserView addSubview:photoViewCell];
    
}


#pragma mark index这页是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
    for (DMPhotoBrowserViewCell *photoViewCell in _visiblePhotoViewCells) {
        if (DMPhotoBrowserViewCellIndex(photoViewCell) == index) {
            return YES;
        }
    }
    return  NO;
}


#pragma mark 循环利用某个view
- (DMPhotoBrowserViewCell *)dequeueReusablePhotoView
{
    DMPhotoBrowserViewCell *photoViewCell = [_reusablePhotoViewCells anyObject];
    if (photoViewCell) {
        [_reusablePhotoViewCells removeObject:photoViewCell];
    }
    return photoViewCell;
}


#pragma mark scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self showPhotos];

    CGFloat length = self.browserView.contentOffset.x;
    
    int index = (int) (( length + padding )  + 0.5 * [ UIScreen mainScreen ].bounds.size.width ) / ([ UIScreen mainScreen ].bounds.size.width + 2 * padding );
    if (index < 0) index = 0;
    
    if (index > (_assetCount - 1) ) index = _assetCount - 1;
    
    if ( index != self.currentIndex ) {
        
        //判断selectedButton的对应的imageCell
        [self changeSelectedButtonStatus : index ];
        
         self.currentIndex = index;
    }
}


#pragma mark

- ( void )changeSelectedButtonStatus : ( int )index
{
    DMAssetModel *assetModel = self.assetsModels [index];
    self.selectedButton.selected = assetModel.selected;
}

- (void)setMaxCount:(int)maxCount
{
    
    _maxCount = maxCount;
    //如果没有图片限制，设置图片最大值为9；
    //图片限制的数量不能大于9
    if ( _maxCount == 0 || _maxCount > 9) {
        _maxCount = 9;
    }
}


- (void)setSelectedCount:(int)selectedCount
{
    _selectedCount = selectedCount ;
    
    if ( selectedCount == 0) {
        
        self.countLabel.text = nil ;
        [ self.finishButton setTitleColor: [ UIColor colorWithRed: 124 / 255.0 green: 124 / 255.0 blue: 124 / 255.0 alpha: 1 ] forState: UIControlStateNormal ];
        self.finishButton.enabled = NO;
        self.animateView.backgroundColor = nil ;
    }else
    {
        self.countLabel.text = [ NSString stringWithFormat: @"%d", _selectedCount ];
        [ self.finishButton setTitleColor: [ UIColor colorWithRed: 61 / 255.0 green: 200 / 255.0 blue: 55 / 255.0 alpha: 1 ] forState: UIControlStateNormal  ];
        self.finishButton.enabled = YES;
        
        self.animateView.backgroundColor = [ UIColor colorWithRed: 61 / 255.0 green: 200 / 255.0 blue: 55 / 255.0 alpha: 1 ];
        
        
        //设置动画
        CGRect frame = self.animateView.frame ;
        CGPoint center = self.animateView.center;
        
        [ UIView animateKeyframesWithDuration: 0.75 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
            
            [ UIView addKeyframeWithRelativeStartTime: 0.0 relativeDuration: 0.25 animations:^{
                
                self.animateView.frame = CGRectMake( center.x, center.y , frame.size.width * 0.5, frame.size.width * 0.5 );
                self.animateView.center = center ;
                
            }];
            
            [ UIView addKeyframeWithRelativeStartTime: 0.25 relativeDuration: 0.25 animations:^{
                
                self.animateView.frame = frame ;
            }];
            
            [ UIView addKeyframeWithRelativeStartTime: 0.5 relativeDuration: 0.25 animations:^{
                
                self.animateView.frame = CGRectMake( 0, 0, frame.size.width * 0.85, frame.size.width * 0.85 );
                self.animateView.center = center ;
            }];
            
            [ UIView addKeyframeWithRelativeStartTime: 0.75 relativeDuration: 0.25 animations:^{
                
                self.animateView.frame = frame ;
            }];
        } completion:nil ];
        
        
    }
    
}


#pragma mark DMPhotoBrowserViewCell的代理方法
-(void)DMPhotoBrowserViewCellSingleTap:(DMPhotoBrowserViewCell *)photoViewCell{
    [self changeBars];
}


#pragma mark
- (void)changeBars
{
    self.hiddenBars = !self.hiddenBars ;
    [self.navigationController setNavigationBarHidden: self.hiddenBars ];
    [self.navigationController setToolbarHidden: self.hiddenBars ];
    
}

@end
