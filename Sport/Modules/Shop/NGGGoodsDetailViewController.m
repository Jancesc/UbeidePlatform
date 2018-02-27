//
//  NGGGoodsDetailViewController.m
//  Sport
//
//  Created by Jan on 07/12/2017.
//  Copyright © 2017 NGG. All rights reserved.
//

#import "NGGGoodsDetailViewController.h"
#import "PSCarouselView.h"
#import "UIImageView+WebCache.h"
#import "NGGGoodsDescriptionViewController.h"

@interface NGGGoodsDetailViewController ()<PSCarouselDelegate> {
    
    __weak IBOutlet PSCarouselView *_carouselView;
    
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UIButton *_submitButton;
    __weak IBOutlet UIButton *_InfoButton;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_countLabel;
    
    __weak IBOutlet UIView *_rewordView;
    __weak IBOutlet UIImageView *_rewordAniImageView;
    __weak IBOutlet UILabel *_rewordDescLabel;
    __weak IBOutlet UIImageView *_rewordImageView;
}

@end

@implementation NGGGoodsDetailViewController

#pragma mark - view life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configueUIComponents];
    self.title = @"金豆抽奖";
    self.view.backgroundColor = NGGGlobalBGColor;
    [self refreshUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)configueUIComponents {
  
    _carouselView.pageDelegate = self;
    _carouselView.imageURLs = @[@"http://www.hangge.com/blog_uploads/201707/2017072719181777126.png"];
    
    NSMutableAttributedString *mAttributedString = [NSMutableAttributedString new];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 16.f;
    style.lineSpacing = 3.f;
    style.paragraphSpacing = 5.f;
    NSAttributedString *titleAttributedString = [[NSAttributedString alloc] initWithString:@"金豆抽奖声明" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName : NGGColor333, NSParagraphStyleAttributeName : style}];
    
    NSAttributedString *contentAttributedString = [[NSAttributedString alloc] initWithString:@"\n1. 抽奖活动的原则是公平、公正、公开\n2. 奖项在截止时间内无其他限制，每个奖项用户可参加多次\n3. 每抽奖一次消耗对应的金豆，中奖结果立即公布\n4. 实物奖品请在领奖截止期内领取，过期作废\n5. 请仔细填写收货地址、联系方式，因收货地址信息有误造成的快递配送失败，奖品视为作废\n6. 虚拟奖品以虚拟卡号的形式由系统自动发放到用户中奖纪录中\n7. 本活动最终解释权归本公司所有" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : NGGColor333, NSParagraphStyleAttributeName : style}];
 
    [mAttributedString appendAttributedString:titleAttributedString];
    [mAttributedString appendAttributedString:contentAttributedString];
    _textView.attributedText = [mAttributedString copy];
    _textView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    _textView.editable = NO;
    [_InfoButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_submitButton setBackgroundImage:[UIImage imageWithColor:NGGViceColor] forState:UIControlStateNormal];
    [_InfoButton addTarget:self action:@selector(handleInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(handleSubmitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _rewordView.backgroundColor = UIColorWithRGBA(0x00, 0x000, 0x00, 230);
    _rewordDescLabel.textColor = NGGViceColor;
    _rewordView.hidden = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissRewordView)];
    [_rewordView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    _textView.contentOffset = CGPointMake(0, 0);

}
- (void)refreshUI {
    
    _carouselView.imageURLs = @[[_goodsInfo stringForKey:@"goods_pic"]];
    _nameLabel.text = [_goodsInfo stringForKey:@"goods_name"];
    _countLabel.text = [_goodsInfo stringForKey:@"need_bean"];
}


/*
 @{
 @"image" : @"wwww.image.baidu.com",
 @"title" : @"1000积分",
 }
 */

- (void)showRewordView:(NSDictionary *)rewordInfo{
    
    if (rewordInfo) {
        
        [_rewordImageView sd_setImageWithURL:[NSURL URLWithString:[rewordInfo stringForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _rewordDescLabel.text = [rewordInfo stringForKey:@"title"];
    }
    
    _rewordView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _rewordView.alpha = 0.0;
    _rewordView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _rewordView.alpha = 1.0;
        _rewordView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        CABasicAnimation *rotationAnimation;
        
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        
        rotationAnimation.duration = 7.0;
        
        rotationAnimation.cumulative = NO;
        
        rotationAnimation.repeatCount = HUGE_VAL;
        
        [_rewordAniImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }];
}

- (void)dismissRewordView {
    
    _rewordView.hidden = YES;
    [_rewordAniImageView.layer removeAllAnimations];
}

#pragma mark - button actions

- (void)handleInfoButtonClicked:(UIButton *) button {
    
    NGGGoodsDescriptionViewController *controller = [[NGGGoodsDescriptionViewController alloc] initWithNibName:@"NGGGoodsDescriptionViewController" bundle:nil];
    controller.goodsID = [_goodsInfo stringForKey:@"goods_id"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)handleSubmitButtonClicked:(UIButton *) button {
    
    NGGUser *currentUser = [NGGLoginSession activeSession].currentUser;
    if (currentUser == nil) {
        
        [self presentLoginViewControllerWithAlertView];
        return;
    }
    [self showLoadingHUDWithText:nil];
    [[NGGHTTPClient defaultClient] postPath:@"/api.php?method=goods.lucky" parameters:@{@"goods_id" : [_goodsInfo stringForKey:@"goods_id"]} willContainsLoginSession:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
            [self dismissHUD];
            NSDictionary *dict = [self dictionaryData:responseObject errorHandler:^(NSInteger code, NSString *msg) {
                
                [self showErrorHUDWithText:msg];
            }];
            if (dict) {
                
                NSInteger isWin = [dict intForKey:@"is_win"];
                if (isWin) {
                    //                "goods_id": "5",
                    //                "goods_name": "2014巴西世界杯大力神杯",
                    //                "goods_pic": "http://wx7.bigh5.com/fb/web/uploads/1710/091829177731.jpg",
                    //                "need_bean": "580000",
                    //                "et": "1510396159"
                    NSDictionary *rewordInfo = @{@"image" : _goodsInfo[@"goods_pic"],
                                                 @"title" : _goodsInfo[@"goods_name"]
                                                 };
                    [self showRewordView:rewordInfo];
                } else {
                    
                    [self showAlertText:@"很遗憾，未中奖" completion:nil];
                }
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dismissHUD];
    }];
}

@end
