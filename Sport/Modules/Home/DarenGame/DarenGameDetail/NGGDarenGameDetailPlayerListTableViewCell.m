//
//  NGGDarenGameDetailPlayerListTableViewCell.m
//  Sport
//
//  Created by Jan on 11/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import "NGGDarenGameDetailPlayerListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JYCommonTool.h"
@interface NGGDarenGameDetailPlayerListTableViewCell () {
    
    __weak IBOutlet UIImageView *_avatarImageView;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_dateLabel;
}

@end
@implementation NGGDarenGameDetailPlayerListTableViewCell

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
//    "avatar_img": "http://wx7.bigh5.com/fb/web/uploads/default/avatar.png",
//    "nickname": "谁谁谁",
//    "ct": "1517550740"
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString: [cellInfo stringForKey:@"avatar_img"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _nameLabel.text = [cellInfo stringForKey:@"nickname"];
    
    _dateLabel.text = [JYCommonTool dateFormatWithInterval:[cellInfo intForKey:@"ct"] format:@"yyyy-MM-dd hh:mm:ss"];
}
@end
