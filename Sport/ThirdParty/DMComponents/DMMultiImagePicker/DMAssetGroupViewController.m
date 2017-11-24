//
//  DMAssetGroupViewController.m
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import "DMAssetGroupViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DMAssetsPickerViewController.h"
#import "DMAssetGroupTableViewCell.h"

@interface DMAssetGroupViewController () < DMAssetsPickerViewControllerDelegate >

//图片库
@property ( nonatomic, strong) ALAssetsLibrary *assetsLibrary;
//一个assetsGroup代表一个相册
@property ( nonatomic, strong) NSMutableArray *assetsGroup;
//图片最大限制
@property ( nonatomic, assign) int maxCount;
@property ( nonatomic, assign) BOOL direct;

@property ( nonatomic, strong) ALAssetsGroup *cameraRoll;
@end

@implementation DMAssetGroupViewController

//懒加载
- (NSMutableArray *)assetsGroup
{
    if ( !_assetsGroup) {
        _assetsGroup = [[ NSMutableArray alloc ] init ];
    }
    return _assetsGroup;
}


- (instancetype)initWithMaxCount:(int)MaxCount directToPickerView:(BOOL)direct
{
    
    if ( self = [super initWithStyle: UITableViewStyleGrouped]) {
        
        self.maxCount = MaxCount;
        self.direct = direct;
    }
    return  self;
}
-(instancetype)initWithDirectToPickerView:(BOOL)direct
{
    
    if ( self = [super initWithStyle: UITableViewStyleGrouped]) {
        
        self.maxCount = 0;
        self.direct = direct;
    }
    return  self;
}

- (instancetype)initWithMaxCount:(int)MaxCount
{
    
    if ( self = [super initWithStyle: UITableViewStyleGrouped]) {
        
        self.maxCount = MaxCount;
        self.direct = YES;
    }
    return  self;
}


- (instancetype)init
{
    
    self.maxCount = 0;
    self.direct = YES;
    return [super initWithStyle: UITableViewStyleGrouped];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //设置返回按钮
//    UIButton *cancelButton = [[ UIButton alloc ] init ];
//    [ cancelButton addTarget: self action: @selector(cancelButtonOnClick: ) forControlEvents: UIControlEventTouchUpInside ];
//    cancelButton.frame = CGRectMake( 0 , 0, 40, 44);
//    [ cancelButton setTitle: @"取消" forState: UIControlStateNormal ];
//    [cancelButton setTitleColor:UIColorWithRGB(0x0a, 0xcb, 0x7c) forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[ UIBarButtonItem alloc ] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self  action:@selector(cancelButtonOnClick:)];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:UIColorWithRGB(0x0a, 0xcb, 0x7c)];

    
    //初始化图片库对象
    ALAssetsLibrary *assetsLibrary = [[ ALAssetsLibrary alloc ] init ];
    self.assetsLibrary = assetsLibrary;
    
    //获取到相册对象
    [ self getAssetsGroupData ];
    
}


- ( void )cancelButtonOnClick : (UIButton *)button
{
    
    [self.navigationController dismissViewControllerAnimated: YES  completion: nil ];
}


- (void) getAssetsGroupData
{
    
    [ self.assetsLibrary enumerateGroupsWithTypes: ALAssetsGroupAll  usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if ( group == nil) {
            
            dispatch_async( dispatch_get_main_queue() , ^{
                
                self.navigationItem.title = @"照片";
                
                //跳到默认的图片选择界面
                [self defaultPickerView];
            });
            return ;
        }
        
        //把group加入数组
        [ self.assetsGroup addObject:group ];
        //判断是否是Camera Roll或者相机胶卷或者所有照片
        NSString *groupName = [group valueForProperty: ALAssetsGroupPropertyName ];
        if ( [ groupName isEqualToString: @"Camera Roll"] || [groupName isEqualToString: @"相机胶卷"] || [groupName isEqualToString: @"所有照片"]) {
            
            self.cameraRoll = group;
        }
        dispatch_async( dispatch_get_main_queue(), ^{
             
            [ self.tableView reloadData ];
        });
    } failureBlock:^(NSError *error) {
        
        UIAlertView *alertView = [[ UIAlertView alloc] initWithTitle: nil message: @"获取相册信息失败"  delegate: nil cancelButtonTitle: @"我知道了" otherButtonTitles: nil ];
        [ alertView show ];
        
        [ self.navigationController dismissViewControllerAnimated: YES completion: nil ];
    }];
}



- (void) defaultPickerView
{
    
        if (self.cameraRoll && self.direct) {
            
            DMAssetsPickerViewController *assetsPickerVC = [[ DMAssetsPickerViewController alloc ] initWithMaxCount: self.maxCount group:self.cameraRoll ];
            assetsPickerVC.delegate = self ;
            [ self.navigationController pushViewController: assetsPickerVC animated: NO ];
    }

}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ self.assetsGroup count ];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ImageCell";
    DMAssetGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier ];
    
    if ( cell == nil ) {
        
        cell = [[ DMAssetGroupTableViewCell alloc ] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier ];
    }
    
    //获取对应的组数据
    ALAssetsGroup *group = [ self.assetsGroup objectAtIndex: indexPath.row ];
    [ group setAssetsFilter: [ ALAssetsFilter allPhotos ]];
    
    //设置cell的内容
    NSString *groupName = [ group valueForProperty: ALAssetsGroupPropertyName ];
    cell.textLabel.text = [ NSString stringWithFormat: @"%@  (%ld)" , groupName, (long) [ group numberOfAssets ]];
    cell.imageView.image = [ UIImage imageWithCGImage: [ group posterImage ]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取对应的group
    ALAssetsGroup *group = self.assetsGroup [ indexPath.row ];
    DMAssetsPickerViewController *assetsPickerVC = [[ DMAssetsPickerViewController alloc ] initWithMaxCount:self.maxCount group: group ];

    assetsPickerVC.delegate = self ;
    [ self.navigationController pushViewController: assetsPickerVC animated: YES ];
}


# pragma mark DMAssetsPickerViewControllerDelegate的代理方法
- (void) DMAssetsPickerViewController:(DMAssetsPickerViewController *)assetsPickerViewController finishedPickingWithAssets:(NSArray *)assets
{
    if ( [ self.delegate respondsToSelector: @selector( DMAssetGroupViewController:didFinishPickingImagesWithAssets:)]) {
        
        [ self.delegate DMAssetGroupViewController: self didFinishPickingImagesWithAssets:assets ];
    }
    
    if (_completion) {
        
        _completion(assets);
    }
}


#pragma mark tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
@end
