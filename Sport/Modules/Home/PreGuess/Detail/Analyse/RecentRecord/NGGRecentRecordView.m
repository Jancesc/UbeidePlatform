//
//  NGGRecentRecordView.m
//  Sport
//
//  Created by Jan on 21/11/2017.
//  Copyright © 2017 NGG. All rights reserved.
//


#import "NGGRecentRecordView.h"
#import "NGGRecentRecordCollectionViewCell.h"
static NSString *kRecentRecordCellIdentifier = @"NGGRecentRecordCollectionViewCell";

@interface NGGRecentRecordView()<UICollectionViewDelegate, UICollectionViewDataSource>{
    
    __weak IBOutlet UICollectionView *_homeCollectionView;
    __weak IBOutlet UICollectionView *_awayCollectionView;
}
@end

@implementation NGGRecentRecordView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [_homeCollectionView registerNib:[UINib nibWithNibName:@"NGGRecentRecordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kRecentRecordCellIdentifier];
   
    _homeCollectionView.dataSource = self;
    _homeCollectionView.delegate = self;
    _homeCollectionView.backgroundColor =UIColorWithRGB(0xea, 0xea, 0xea);
    
    [_homeCollectionView registerNib:[UINib nibWithNibName:@"NGGRecentRecordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kRecentRecordCellIdentifier];
    
    _awayCollectionView.dataSource = self;
    _awayCollectionView.delegate = self;
    _awayCollectionView.backgroundColor =UIColorWithRGB(0xea, 0xea, 0xea);
    
    [_awayCollectionView registerNib:[UINib nibWithNibName:@"NGGRecentRecordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kRecentRecordCellIdentifier];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NGGRecentRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kRecentRecordCellIdentifier forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 0) {
//        return CGSizeMake((SCREEN_WIDTH - 40) / 3.0, 40);
//    }
//    else if (indexPath.section == 1)
//    {
//        return CGSizeMake((SCREEN_WIDTH - 35) / 2.0, 40);
//    }
//    else if (indexPath.section == 2)
//    {
//        return CGSizeMake((SCREEN_WIDTH - 45) / 4.0, 40);
//    }
//    else if (indexPath.section == 3) {
//        return CGSizeMake((SCREEN_WIDTH - 40) / 3.0, 40);
//    }
//    return CGSizeMake(SCREEN_WIDTH, 0);
//}
//- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    
//    return CGSizeMake(SCREEN_WIDTH, 40);
//}
//
//- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//    return CGSizeMake(SCREEN_WIDTH, 0);
//}
//
//
//- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    
//    return UIEdgeInsetsMake(0, 15, 0, 15);
//}
//
//- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    //    NSInteger section = indexPath.section;
//    //    NSInteger item = indexPath.item;
//    //    NSDictionary *selectedCity = nil;
//    //    if (section == 2) {
//    //        selectedCity = [_arrayOfRecentCities objectAtIndex:item];
//    //    }
//    //    else if (section == 3)
//    //    {
//    //        selectedCity = [_arrayOfServingCities objectAtIndex:item];
//    //    }
//    //
//    //    [self handleSelectCity:selectedCity];
//}

@end
