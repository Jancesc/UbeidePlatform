//
//  DMAssetModel.m
//  DMMultiImagePicker
//
//  Created by Damai on 15/9/10.
//  Copyright (c) 2015年 Damai. All rights reserved.
//

#import "DMAssetModel.h"

@implementation DMAssetModel
-(instancetype)initWithAsset:(ALAsset *)asset Tag:(int)tag
{
    
    self = [ super init ];
    if ( self ) {
        
        self.asset = asset;
        self.tag = tag;

    }
    
    return self;
}


- (void)setAsset:(ALAsset *)asset
{
    
    _asset = asset ;
    
    self.selected = NO ;
}
@end
