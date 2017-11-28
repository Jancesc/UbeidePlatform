//
//  NGGSystemMessageTableViewCell.h
//  Sport
//
//  Created by Jan on 27/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGGSystemMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *cellInfo;

+(CGFloat)rowHeightWithCellInfo:(NSDictionary *)cellInfo;

@end
