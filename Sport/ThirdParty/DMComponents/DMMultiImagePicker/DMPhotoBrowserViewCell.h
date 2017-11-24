//
//  DMPhotoBrowserViewCell.h
//  DMMultiImagePickerDemo
//
//  Created by Damai on 15/9/30.
//  Copyright © 2015年 Damai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMAssetModel,DMPhotoBrowserViewCell;

@protocol DMPhotoBrowserViewCellDelegate <NSObject>

- (void)DMPhotoBrowserViewCellSingleTap:(DMPhotoBrowserViewCell *)photoViewCell;

@end
@interface DMPhotoBrowserViewCell : UIScrollView


//图片
@property (nonatomic, strong) DMAssetModel *assetModel;
//代理
@property (nonatomic, weak) id <DMPhotoBrowserViewCellDelegate> DMPhotoBrowserViewCellDelegate;
@end
