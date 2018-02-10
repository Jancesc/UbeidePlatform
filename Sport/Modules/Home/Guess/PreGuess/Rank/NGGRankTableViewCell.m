//
//  NGGRankTableViewCell.m
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGRankTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface NGGRankTableViewCell() {
    
    __weak IBOutlet UIImageView *_rankImageView;
    __weak IBOutlet UIImageView *_avatarImageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_coinLabel;
    __weak IBOutlet UILabel *_rankLabel;
}

@end
@implementation NGGRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"avatar_img"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _nameLabel.text = [cellInfo stringForKey:@"nickname"];
    _coinLabel.text = [cellInfo stringForKey:@"total"];
    NSInteger rank = [cellInfo intForKey:@"rank"];
    if (rank < 4) {
        
        _rankLabel.hidden = YES;
        _rankImageView.hidden = NO;
        NSString *imageStr = [NSString stringWithFormat:@"rank%ld", rank];
        _rankImageView.image = [UIImage imageNamed:imageStr];
    } else {
        
        _rankLabel.hidden = NO;
        _rankImageView.hidden = YES;
        _rankLabel.text = @(rank).stringValue;
    }
}
@end
