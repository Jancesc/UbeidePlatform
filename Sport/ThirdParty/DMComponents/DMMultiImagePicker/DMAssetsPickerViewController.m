//
//  DMAssetsPickerViewController.m
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import "DMAssetsPickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DMAssetsPickerCollectionViewCell.h"
#import "DMAssetModel.h"
#import "DMPhotoBrowserViewController.h"

#define CellIdentifier @"imageCell"
#define imageCellMargin 3.0

static int maxcol;
@interface DMAssetsPickerViewController () <DMAssetsPickerCollectionViewCellDelegate , DMPhotoBrowserViewControllerDelegate>


@property ( nonatomic, strong ) NSMutableArray *assetModels;
//完成按钮
@property ( nonatomic, strong ) UIButton *finishButton;
//显示已选中图片的标签
@property ( nonatomic, strong ) UILabel *countLabel;
// 已选中的图片
@property ( nonatomic, assign ) int selectedCount;
//图片数目更改时的动画视图
@property ( nonatomic, strong ) UIView *animateView;
//预览按钮
@property ( nonatomic, strong ) UIButton *previewbutton;
//一个ALAssetsGroup代表一个相册
@property ( nonatomic, strong ) ALAssetsGroup *group;
//图片最大值
@property ( nonatomic, assign) int maxCount;
//cell的size
@property ( nonatomic, assign ) CGSize cellSize;
//刚加载界面
@property ( nonatomic, assign ) BOOL firstTime;
@end


@implementation DMAssetsPickerViewController

//懒加载
- (NSMutableArray *)assetModels
{
    
    if (!_assetModels) {
        
        _assetModels = [[ NSMutableArray alloc ] init ];
    }
    return _assetModels;
}


- (instancetype)initWithMaxCount:(int)maxcount group:(ALAssetsGroup *)group
{
    //创建UICollectionViewFlowLayout
    UICollectionViewFlowLayout *flowLayout = [[ UICollectionViewFlowLayout alloc ] init ];
    flowLayout =  [ self setupCollectionViewFlowLayout:flowLayout];
    
    self.maxCount = maxcount;
    self.group = group;
    self.firstTime = YES;
    return [ super initWithCollectionViewLayout: flowLayout ];
}

- (instancetype)init
{
    
    //创建UICollectionViewFlowLayout
    UICollectionViewFlowLayout *flowLayout = [[ UICollectionViewFlowLayout alloc ] init ];
    flowLayout =  [ self setupCollectionViewFlowLayout:flowLayout];
    self.firstTime = YES;
    return [ super initWithCollectionViewLayout: flowLayout ];

}


- (void)viewDidLoad
{
    
    [ super viewDidLoad] ;
    
    //初始化导航栏
    self.navigationController.navigationBar.alpha = 0.8;
    
    //创建导航栏的返回按钮
    UIButton *backButton = [ self setupBackButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ] initWithCustomView:  backButton ];
    
    //创建导航栏的取消按钮
    UIButton *cancelButton = [ self setupCancelButton ];
    self.navigationItem.rightBarButtonItem = [[ UIBarButtonItem alloc ] initWithCustomView: cancelButton ];
    
    //创建toolbar的完成视图
    UIView *view = [ self setupFinishView];
    UIBarButtonItem *finishBarButton = [[ UIBarButtonItem alloc ] initWithCustomView:view];
    
    //toolbar的预览按钮
    UIButton *previewButton = [ self setupPreviewButton ];
    UIBarButtonItem *previewBarButton = [[ UIBarButtonItem alloc ] initWithCustomView:previewButton];
    
    UIBarButtonItem *spaceButton = [[ UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[ previewBarButton , spaceButton , finishBarButton ] animated:YES ];
        // Register cell classes
    [ self.collectionView registerClass:[DMAssetsPickerCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [ self.collectionView setBackgroundColor: [ UIColor whiteColor ]];
    
    self.selectedCount = 0;

}


- (void) viewWillAppear:(BOOL)animated
{
    
    
    //显示toolbar
    [ self.navigationController setToolbarHidden: NO animated: YES ];
    
    //设置collectionView的contentOffset

   
    if ( self.firstTime) {
    
        CGFloat offsetY = (([self.group numberOfAssets] + maxcol - 1) / maxcol) * (imageCellMargin + self.cellSize.height) - [ UIScreen mainScreen].bounds.size.height +self.navigationController.toolbar.bounds.size.height;
        if  ( offsetY > (- self.navigationController.toolbar.bounds.size.height ))
        {
            CGPoint offsetPoint = CGPointMake(0, offsetY);
            //        self.collectionView.contentSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width, offsetY);
            [self.collectionView setContentOffset: offsetPoint animated: NO ];
        }
        self.firstTime = NO;

    }
}
- (void) viewWillDisappear:(BOOL)animated
{
    
    [ self.navigationController setToolbarHidden:YES animated:YES ];
}

-( UIButton * ) setupPreviewButton
{
    UIButton *previewButton = [[ UIButton alloc ] init ];
    [previewButton addTarget: self action: @selector( previewButtonOnClick: ) forControlEvents: UIControlEventTouchUpInside ];
    previewButton.frame = CGRectMake( 0 , 0, 40, 44);
    [ previewButton setTitle: @"预览" forState: UIControlStateNormal ];
    [previewButton setTitleColor: [ UIColor colorWithRed: 124 / 255.0 green: 124 / 255.0 blue: 124 / 255.0 alpha: 1 ] forState: UIControlStateNormal ];
    self.previewbutton = previewButton;
    return  previewButton ;
}

- ( UIView * ) setupFinishView
{
    
    UIView *view = [[ UIView alloc ] init ];
    view.frame = CGRectMake( 0, 0, 64, 44);
    
    //完成按钮
    UIButton *finishbutton = [[ UIButton alloc ] initWithFrame: view.bounds];
    [ finishbutton setTitleColor: [ UIColor colorWithRed: 124 / 255.0 green: 124 / 255.0 blue: 124 / 255.0 alpha: 1 ] forState: UIControlStateNormal ];
    [ finishbutton setTitle: @"完成" forState: UIControlStateNormal ];
    
    finishbutton.titleEdgeInsets = UIEdgeInsetsMake( 0, 20, 0, 0);
    [ finishbutton addTarget: self action: @selector( finishButtonOnClick:) forControlEvents:UIControlEventTouchUpInside ];
    self.finishButton = finishbutton ;
    [view addSubview: finishbutton ];
    
    //左边的动画view
    UIView *animateView = [[ UIView alloc ] init ];
    animateView.frame = CGRectMake(5, 13, 18, 18);
    animateView.layer.cornerRadius = animateView.frame.size.width * 0.5 ;
    animateView.layer.masksToBounds = YES;
    self.animateView = animateView ;
    [view addSubview:animateView ];
    
    //左边的数字label
    UILabel *countlabel = [[ UILabel alloc ] init ];
    countlabel.textColor = [ UIColor whiteColor ];
    countlabel.textAlignment = NSTextAlignmentCenter ;
    countlabel.frame = animateView.frame;
    self.countLabel = countlabel ;
    [view addSubview:countlabel ];

    return view ;

    
}


- ( UIButton * )setupCancelButton
{
    
    UIButton *cancelButton = [[ UIButton alloc ] init ];
    [ cancelButton addTarget: self action: @selector(cancelButtonOnClick: ) forControlEvents: UIControlEventTouchUpInside ];
    cancelButton.frame = CGRectMake( 0 , 0, 40, 44);
    [ cancelButton setTitle: @"取消" forState: UIControlStateNormal ];
    [cancelButton setTitleColor:UIColorWithRGB(0x0a, 0xcb, 0x7c) forState:UIControlStateNormal];
    return cancelButton;
}


- ( UIButton * )setupBackButton
{
    
    UIButton *backButton = [[ UIButton alloc ] init ];
    [ backButton addTarget: self  action: @selector( backButtonOnClick: ) forControlEvents:UIControlEventTouchUpInside ];
    backButton.frame = CGRectMake( 0 , 0, 40, 44);
    [ backButton setTitle: @"返回" forState: UIControlStateNormal ];
    [backButton setTitleColor:UIColorWithRGB(0x0a, 0xcb, 0x7c) forState:UIControlStateNormal];
    return backButton ;
    
}


- ( UICollectionViewFlowLayout * ) setupCollectionViewFlowLayout : ( UICollectionViewFlowLayout * ) flowLayout
{
    
    flowLayout.minimumLineSpacing = imageCellMargin;
    flowLayout.minimumInteritemSpacing = imageCellMargin;
    flowLayout.sectionInset = UIEdgeInsetsMake( imageCellMargin, imageCellMargin, imageCellMargin, imageCellMargin );
    
    CGFloat ImageCellWH = 0;
    //判断屏幕宽度是否大于 320
    if (( [UIScreen mainScreen].bounds.size.width > 320)) {
        maxcol = 4;
    } else
    {
        maxcol = 3;
    }
    
    ImageCellWH = (([UIScreen mainScreen].bounds.size.width - imageCellMargin ) - maxcol * imageCellMargin ) / maxcol ;
    
    flowLayout.itemSize = CGSizeMake(ImageCellWH, ImageCellWH);
    self.cellSize = flowLayout.itemSize;
    return flowLayout;

}


- ( void )finishButtonOnClick : (UIButton *)button
{
    
    NSMutableArray *array = [ NSMutableArray array];
    for ( DMAssetModel *assetModel in self.assetModels) {
        
        if ( assetModel.selected == YES ) {
            
            ALAsset *asset = assetModel.asset;
            [array addObject: asset ];
        }
        
    }
    if ( [self.delegate respondsToSelector: @selector( DMAssetsPickerViewController:finishedPickingWithAssets: )]) {
        [self.delegate DMAssetsPickerViewController: self finishedPickingWithAssets: array ];
    }
    
    [ self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


- ( void )previewButtonOnClick : (UIButton *)button
{
    
    NSMutableArray *array = [ NSMutableArray array];
    for ( DMAssetModel *assetModel in self.assetModels) {
        
        if ( assetModel.selected == YES ) {
            
            [array addObject: assetModel ];
        }
        
    }
    

    DMPhotoBrowserViewController *photoBrowserViewController = [[ DMPhotoBrowserViewController alloc ] initWithAssetsModels:array maxSelectedCount:self.maxCount selectedCount:self.selectedCount];
    photoBrowserViewController.delegate = self ;
    
    [self.navigationController pushViewController: photoBrowserViewController  animated: YES ];

}


- ( void )cancelButtonOnClick : (UIButton *)button
{
    
    [self.navigationController dismissViewControllerAnimated: YES  completion: nil ];
}


-( void )backButtonOnClick : (UIButton *)button
{
    
    [self.navigationController popViewControllerAnimated: YES ];
}




- (void)setGroup:(ALAssetsGroup *)group
{
    
    _group = group;
    
        [ group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if ( !result || index == NSNotFound ) {
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    
                    [ self.collectionView reloadData ];
                    NSString *groupName = [ group valueForProperty: ALAssetsGroupPropertyName ];
                    self.navigationItem.title = [ NSString stringWithFormat: @"%@" , groupName];

                });
                return ;
            }
            DMAssetModel *assetModel = [[ DMAssetModel alloc ] initWithAsset: result Tag: (int)[ self.assetModels count ]];
            [ self.assetModels addObject: assetModel ];
            
        }];
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



-(void)setSelectedCount:(int)selectedCount
{
    _selectedCount = selectedCount ;
    if ( selectedCount == 0) {
        
        self.countLabel.text = nil ;
        [ self.finishButton setTitleColor: [ UIColor colorWithRed: 124 / 255.0 green: 124 / 255.0 blue: 124 / 255.0 alpha: 1 ] forState: UIControlStateNormal ];
        self.animateView.backgroundColor = nil ;
        self.previewbutton.enabled = NO;
        [self.previewbutton setTitleColor: [ UIColor colorWithRed: 124 / 255.0 green: 124 / 255.0 blue: 124 / 255.0 alpha: 1 ] forState: UIControlStateNormal ];
        self.finishButton.enabled = NO;
    }else
    {
        self.previewbutton.enabled = YES;
        [ self.previewbutton setTitleColor: [ UIColor colorWithRed: 61 / 255.0 green: 200 / 255.0 blue: 55 / 255.0 alpha: 1 ]  forState: UIControlStateNormal  ];
        self.finishButton.enabled = YES;
        self.countLabel.text = [ NSString stringWithFormat: @"%d", selectedCount ];
        [ self.finishButton setTitleColor: [ UIColor colorWithRed: 61 / 255.0 green: 200 / 255.0 blue: 55 / 255.0 alpha: 1 ]  forState: UIControlStateNormal  ];
        self.animateView.backgroundColor = [ UIColor colorWithRed: 61 / 255.0 green: 200 / 255.0 blue: 55 / 255.0 alpha: 1 ] ;
        
        
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


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [ self.assetModels count ];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DMAssetsPickerCollectionViewCell *cell = [ collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath ];
    
    // Configure the cell
    cell.assetModel = self.assetModels[indexPath.row];
    cell.delegate = self ;
    return cell;
}


#pragma  mark DMAssetsPickerCollectionViewCell的代理方法

- (void)DidSelectedDMAssetsPickerCollectionViewCell:(DMAssetsPickerCollectionViewCell * )assetsPickerCollectionViewCell
{
    
    DMAssetModel *assetModel = self.assetModels [ assetsPickerCollectionViewCell.tag ];
    
    //选中collectionViewCell
    if ( !assetModel.selected ) {
        
        //最大只能选9张
        if ( self.selectedCount == self.maxCount ) {
            
           UIAlertView *alertView =  [[ UIAlertView alloc] initWithTitle: nil message: [ NSString stringWithFormat: @"你最多只能选择%d张图片" , self.maxCount ] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil ];
            [ alertView show ];
            
            return;
            
        }
        self.selectedCount ++;
         [ assetsPickerCollectionViewCell changSelectedButtonStatus];
        assetModel.selected = !assetModel.selected;
        
    } else
    {//取消选中collectionViewCell
       
        self.selectedCount --;
      [ assetsPickerCollectionViewCell changSelectedButtonStatus];
        assetModel.selected = !assetModel.selected;

    }
    
}


- (void)DidClickDMAssetsPickerCollectionViewCell:(DMAssetsPickerCollectionViewCell *)assetsPickerCollectionViewCell
{
    
    DMPhotoBrowserViewController *photoBrowserViewController = [[ DMPhotoBrowserViewController alloc ] initWithAssetsModels: self.assetModels maxSelectedCount: self.maxCount selectedCount: self.selectedCount];
    photoBrowserViewController.delegate = self;
    
    CGFloat offsetX = ([ UIScreen mainScreen ].bounds.size.width + 2 * padding ) * assetsPickerCollectionViewCell.tag;
    CGFloat offsetY = 0;
    [photoBrowserViewController setBrowserViewContentOffet: CGPointMake( offsetX,  offsetY )];
    
    [self.navigationController pushViewController: photoBrowserViewController animated: YES ];


}

#pragma mark DMPhotoBrowserViewController代理方法
- (void)DMPhotoBrowserViewController:(DMPhotoBrowserViewController *)photoBrowserViewController finishBrowserWithAssetModels:(NSArray *)assetModels
{
    
    NSMutableArray *array = [ NSMutableArray array];
    for ( DMAssetModel *assetModel in assetModels) {
        
        if ( assetModel.selected == YES ) {
            
            ALAsset *asset = assetModel.asset;
            [array addObject: asset ];
        }
        
    }
    if ( [self.delegate respondsToSelector: @selector( DMAssetsPickerViewController:finishedPickingWithAssets:)]) {
        [self.delegate DMAssetsPickerViewController: self finishedPickingWithAssets:array];
    }
    
    [ self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void) DMPhotoBrowserViewController:(DMPhotoBrowserViewController *)photoBrowserViewController backButtonOnClickWithAssetModels:(NSArray *)assetModels
{
    
    [self.collectionView reloadData ];
    
    int temp = 0;
    for ( DMAssetModel *assetModel in  assetModels ) {
        
        if ( assetModel.selected ) {
            
            temp ++;
        }
    }
    
    self.selectedCount = temp ;
    
}



@end
