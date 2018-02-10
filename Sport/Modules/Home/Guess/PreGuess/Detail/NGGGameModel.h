//
//  NGGGameModel.h
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"
#import "NGGGuessSectionModel.h"


typedef NS_ENUM(NSUInteger, NGGGameType) {
 
    NGGGameTypePreGame = 1,
    NGGGameTypeLive = 2,
    NGGGameTypeDaren = 3,
};

@interface NGGGameModel : NGGModel

@property (nonatomic, assign) BOOL isForbid;
@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) NSString *homeScore;//主场比分
@property (nonatomic, strong) NSString *awayScore;//客场比分
@property (nonatomic, strong) NSString *status;//比赛状态，0未开赛 1取消 2关闭 3完结 4赛果录入 5彩果计算完毕;ps：3之后都算比赛结束
@property (nonatomic, strong) NSString *homeLogo;
@property (nonatomic, strong) NSString *awayLogo;
//当更新投注记录才时候，才更新下面几项
@property (nonatomic, strong) NSString *profit;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString  *winCount;
@property (nonatomic, strong) NSString  *duration;

@property (nonatomic, strong) NSArray *arrayOfSection;

@property (nonatomic, strong) NSString  *darenPoint;

@property (nonatomic, assign) NGGGameType gameType;

@end
