//
//  NGGEnum.h
//  Sport
//
//  Created by Jan on 06/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#ifndef NGGEnum_h
#define NGGEnum_h

typedef NS_ENUM(NSUInteger, NGGGuessDetailCellType) {
    
    NGGGuessDetailCellTypeNormal = 0,//NGGGuessCollectionViewCell,每行最多3个cell
    NGGGuessDetailCellType2Rows = 1,//NGGGuess2RowsCollectionViewCell,每行最多4个cell
    NGGGuessDetailCellTypeDescription = 2,//NGGGuessCollectionViewCell + NGGGuessDescriptionCollectionViewCell,例如大小球：  大球2.1   1.5   小球1.7
};


//NS_ENUM(NSUInteger, NGGGuess) {
//
//    NGGGuessSPF = 1,///胜平负
//    NGGGuessHSPF,///让球胜平负
//
//    NGGGuessFSPF,///上半场胜平负
//    NGGGuessFHSPF,///上半场让球胜平负
//
//    NGGGuessDXQ,///大小球
//    NGGGuessFDXQ,///上半场大小球
//
//    NGGGuessHFDXQ,///主队上半场大小球
//    NGGGuessAFDXQ,///客队上半场大小球
//
//    NGGGuessBD, //波胆
//    NGGGuessFBD, //上半场波胆
//
//    NGGGuessJQS,//总进球数目
//    NGGGuessFJQS,//上半场总进球数目
//
//    NGGGuessSFJQ,//双方球队进球
//    NGGGuessHSFJQ,//上半场双方球队进球
//
//    NGGGuessHJQS,//主队总进球数目
//    NGGGuessAJQS,//客队总进球数目
//
//    NGGGuessHFJQS,//主队上半场总进球数目
//    NGGGuessAFJQS,//客队上半场总进球数目
//
//    NGGGuessDS,//进球单双
//    NGGGuessFDS,//上半场进球单双
//
//    NGGGuessJQ,//角球独赢
//    NGGGuessFJQ,//上半场角球独赢
//
//    NGGGuessHJQ,//角球让球
//    NGGGuessFHJQ,//上半场角球让球
//
//    NGGGuessJQDX,//角球大小
//    NGGGuessFJQDX,//上半场角球大小
//
//    NGGGuessJQDS,//角球单双
//    NGGGuessFJQDS,//上半场角球单双
//
//    NGGGuessFP,//罚牌独赢
//    NGGGuessFFP,//上半场罚牌独赢
//
//    NGGGuessHFP,//罚牌让球
//    NGGGuessFHFP,//上半场罚牌让球
//
//    NGGGuessFPDX,//罚牌大小
//    NGGGuessFFPDX,//上半场罚牌大小
//
//    NGGGuessFPDS,//罚牌单双
//    NGGGuessFFPDS,//上半场罚牌单双
//
//    NGGGuessSLJQ,//首粒进球
//    NGGGuessZHYLJQ,//最后一粒进球
//    NGGGuessXYLJQ,//下一粒进球
//
//    NGGGuessJSQ,//净胜球
//    NGGGuessBQC,//半全场
//};
#endif /* NGGEnum_h */
