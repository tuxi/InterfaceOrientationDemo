//
//  InterfaceOrientationUtil.h
//  InterfaceOrientationDemo
//
//  Created by xiaoyuan on 2018/7/17.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InterfaceOrientationUtil : NSObject

// 此属性会记录上次强制修改前的方向
@property (nonatomic, assign) UIDeviceOrientation forceOrientation;
/// 此属性用于记录屏幕是否可以旋转，根据系统级别的UIDeviceOrientationDidChangeNotification通知处理
@property (nonatomic, assign) BOOL shouldAutorotate;

+ (instancetype)sharedInsatnce;

/// 强制屏幕转屏
/// @param orientation 屏幕方向
- (void)applyInterfaceOrientation:(UIInterfaceOrientation)orientation;

/// 强制屏幕转屏 (自适应方向)
- (void)autorotateInterfaceOrientation;

/// 开启屏幕旋转的检测
- (void)startListeningDirectionOfDevice;
/// 停止监听屏幕方向
- (void)stopListeningDirectionOfDevice;

@end

NS_ASSUME_NONNULL_END
