//
//  IndexAdView.h
//  DrinkChart
//
//  Created by 技术部 on 2017/1/24.
//  Copyright © 2017年 技术部. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexAdView : UIImageView
@property (nonatomic,assign) NSUInteger duration;
@property (nonatomic,assign) NSUInteger waitTime;
@property (strong, nonatomic) NSURL *url;
@end
