//
//  NGGDarenGameListTableViewCell.h
//  Sport
//
//  Created by Jan on 07/02/2018.
//  Copyright © 2018 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NGGDarenGameListTableViewCell;

@protocol NGGDarenGameListTableViewCellDelegate <NSObject>

- (void)gameListTableViewcellDidFinishCountDown:(NGGDarenGameListTableViewCell *)cell;
@end

@interface NGGDarenGameListTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *cellInfo;
@property (nonatomic, weak) id <NGGDarenGameListTableViewCellDelegate> delegate;

- (void)countTime;

@end
