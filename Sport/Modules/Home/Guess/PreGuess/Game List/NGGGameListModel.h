//
//  NGGGameListModel.h
//  Sport
//
//  Created by Jan on 01/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"

@interface NGGGameListModel : NGGModel

@property (nonatomic, copy) NSString *matchID;
@property (nonatomic, copy) NSString *leagueName;
@property (nonatomic, copy) NSString *homeName;
@property (nonatomic, copy) NSString *awayName;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *homeLogo;
@property (nonatomic, copy) NSString *awayLogo;

// 达人赛专有属性 
@property (nonatomic, copy) NSString *registeryFee;

@end
