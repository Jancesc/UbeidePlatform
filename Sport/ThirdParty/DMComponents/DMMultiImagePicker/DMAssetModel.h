//
//  DMAssetModel.h
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ALAsset;

@interface DMAssetModel : NSObject


@property ( nonatomic, assign ,getter=isSected ) BOOL selected;
@property ( nonatomic, assign ) int tag;
@property ( nonatomic, strong ) ALAsset *asset;
- ( instancetype ) initWithAsset : ( ALAsset * ) asset Tag : (int) tag;
@end
