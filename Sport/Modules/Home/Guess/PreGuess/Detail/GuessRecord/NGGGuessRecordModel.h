//
//  NGGGuessRecordModel.h
//  Sport
//
//  Created by Jan on 18/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGModel.h"

@interface NGGGuessRecordModel : NGGModel

@property (nonatomic,strong) NSString *timeStamp;
@property (nonatomic,strong) NSString *sectionName;
@property (nonatomic,strong) NSString *itemName;
@property (nonatomic,strong) NSString *odds;
@property (nonatomic,strong) NSString *money;
@property (nonatomic,strong) NSString *profit;
@property (nonatomic,strong) NSString *itemID;

@end
