//
//  NGGDarenGameResultDetailTableViewCell.m
//  Sport
//
//  Created by Jan on 08/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameResultDetailTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface NGGDarenGameResultDetailTableViewCell() {
    
    __weak IBOutlet UILabel *_rankLabel;
    
    __weak IBOutlet UIImageView *_avatarImageView;
    __weak IBOutlet UIImageView *_avatarBGImageVIew;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_pointLabel;
    __weak IBOutlet UILabel *_countLebel;
}

@end

@implementation NGGDarenGameResultDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setup];
}

- (void)setup {
    
    _rankLabel.textColor = NGGViceColor;
    _pointLabel.textColor = NGGViceColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellInfo:(NSDictionary *)cellInfo {
    
    _cellInfo = cellInfo;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[cellInfo stringForKey:@"avatar_img"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _countLebel.text = [NSString stringWithFormat:@"+%@个",[cellInfo stringForKey:@"award"]];
    _pointLabel.text = [NSString stringWithFormat:@"本场积分：%@",[cellInfo stringForKey:@"bean"]];
    _nameLabel.text = [cellInfo stringForKey:@"nickname"];
    
}

-(void)setRank:(NSInteger)rank {
    
    _rankLabel.text = [NSString stringWithFormat:@"第 %ld 名",(long)rank + 1];
    if (rank < 4) {
        
        NSString *imageStr = [NSString stringWithFormat:@"result_detail_%ld", rank + 1];
        _avatarBGImageVIew.image = [UIImage imageNamed:imageStr];
        _avatarBGImageVIew.hidden = NO;
    } else {
        
        _avatarBGImageVIew.hidden = YES;

    }
}

@end
