//
//  NGGHomeBannerCollectionViewCell.h
//  sport
//
//  Created by Jan on 26/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGGHomeBannerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSArray *arrayOfURL;
@property (nonatomic, copy) void (^imageTappedHandler)(NSInteger index);

@end
