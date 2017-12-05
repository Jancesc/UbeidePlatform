//
//  NGGGameListView.h
//  Sport
//
//  Created by Jan on 30/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGGGameListModel.h"
#import "NGGLeagueModel.h"

@protocol NGGGameListViewDelegate <NSObject>

///nil 为选择全部
- (void)gameListViewUpdateInfoWithLeagueID:(NSString *)leagueID timeStamp:(NSString *)timeStamp;

- (void)gameListViewDidSelectCellWithModel:(NGGGameListModel *)model;

@end

@interface NGGGameListView : UIView
@property (nonatomic, strong)NSDictionary *dictionaryOfGameList;
@property (nonatomic, weak) id <NGGGameListViewDelegate> delegate;
@end
