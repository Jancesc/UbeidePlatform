//
//  NGGHomePageMenuCollectionViewCell.h
//  sport
//
//  Created by Jan on 26/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGGHomePageMenuCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^pageTappedHandler)(NSInteger index);

@end
