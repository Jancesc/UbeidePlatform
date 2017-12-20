//
//  NGGGameModel.h
//  Sport
//
//  Created by Jan on 05/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"
#import "NGGGuessSectionModel.h"
@interface NGGGameModel : NGGModel

@property (nonatomic, assign) BOOL isForbid;
@property (nonatomic, strong) NSString *matchID;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *homeName;
@property (nonatomic, strong) NSString *awayName;
@property (nonatomic, strong) NSString *score;//比分
@property (nonatomic, strong) NSString *status;//比赛状态，0未开赛 1取消 2关闭 3完结 4赛果录入 5彩果计算完毕;ps：3之后都算比赛结束

//当更新投注记录才时候，才更新下面几项
@property (nonatomic, assign) CGFloat profit;
@property (nonatomic, assign) CGFloat count;
@property (nonatomic, assign) CGFloat winCount;

@property (nonatomic, strong) NSArray *arrayOfSection;

@end
