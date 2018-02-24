//
//  NGGHomeItemCollectionViewCell.m
//  sport
//
//  Created by Jan on 27/10/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGHomeItemCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface NGGHomeItemCollectionViewCell () {
    
    __weak IBOutlet UIImageView *_activityImageView;
    __weak IBOutlet UILabel *_titleLabel;
}

@end

@implementation NGGHomeItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItemInfo:(NSDictionary *)itemInfo {
    
    _itemInfo = itemInfo;
    [_activityImageView sd_setImageWithURL:[NSURL URLWithString:[itemInfo stringForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _titleLabel.text = [itemInfo stringForKey:@"title"];
    
}

@end
