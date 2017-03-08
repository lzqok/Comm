//
//  IndexAdView.m
//  DrinkChart
//
//  Created by 技术部 on 2017/1/24.
//  Copyright © 2017年 技术部. All rights reserved.
//

#import "IndexAdView.h"
#import <UIImageView+WebCache.h>
@interface IndexAdView (){

}
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) dispatch_source_t waitTimer;
@end
@implementation IndexAdView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfiguration];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self defaultConfiguration];
}

- (void)defaultConfiguration{
    self.userInteractionEnabled = YES;
    self.image = [self getLaunchImage];
    [self addSubview:self.closeBtn];
    self.frame = [[UIScreen mainScreen] bounds];
}



/** 获取启动图片 */
- (UIImage *)getLaunchImage
{
    UIImage *lauchImage = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        viewOrientation = @"Landscape";
        
    }else{
        
        viewOrientation = @"Portrait";
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}


- (void)setUrl:(NSURL *)url{
    if(url){
        KweakSelf;
        [weakSelf scheduledTimer];
        [self sd_setImageWithURL:url placeholderImage:[self getLaunchImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
}

- (void)scheduledTimer{
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0*NSEC_PER_SEC));
    
    uint64_t interval = (int64_t)(1.0*NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    KweakSelf;
    dispatch_source_set_event_handler(self.timer, ^{
        _duration--;
        
        [weakSelf showBtnTitleTime:_duration];
        
        if(_duration <= 0){
            [weakSelf skipAction];
        }
    });
    
    dispatch_resume(self.timer);
}


- (void) scheduledWaitTimer{
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.waitTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (int64_t)(1.0*NSEC_PER_SEC);
    
    dispatch_source_set_timer(self.waitTimer, start, interval, 0);
    
    dispatch_source_set_event_handler(self.waitTimer, ^{
        if (_waitTime <= 0) {
            
            dispatch_source_cancel(_waitTimer);
            [self dismiss];
        }
        _waitTime--;
    });
    dispatch_resume(_waitTimer);
}

- (void)setWaitTime:(NSUInteger)waitTime{
    _waitTime = waitTime;
    if(_waitTime < 1) _waitTime = 1;
    
}

- (void) dismiss{
    [UIView animateWithDuration:1 animations:^{
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showBtnTitleTime:(NSInteger)timeLeave{
    [self.closeBtn setTitle:[NSString stringWithFormat:@"%ldS关闭",timeLeave] forState:UIControlStateNormal];
}

- (UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc]init];
        _closeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 30, 60, 30);
        _closeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        _closeBtn.userInteractionEnabled = YES;
        _closeBtn.layer.cornerRadius = 15;
        _closeBtn.layer.masksToBounds = YES;
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:13.5];
        [_closeBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (void) skipAction{
    dispatch_source_cancel(self.timer);
    self.timer = nil;
    [self dismiss];
}

- (void)setFrame:(CGRect)frame{
    frame = [[UIScreen mainScreen] bounds];
    
    [super setFrame:frame];
}

@end
