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

/// 此属性会记录上次强制修改前的方向
@property (nonatomic, assign, readonly) UIDeviceOrientation forceOrientation;
/// 此属性用于记录屏幕是否可以旋转，根据系统级别的UIDeviceOrientationDidChangeNotification通知处理
@property (nonatomic, assign, readonly) BOOL shouldAutorotate;

+ (instancetype)sharedInsatnce;

/// 根据forceOrientation自适应app界面方向
- (void)autorotateInterfaceOrientation;
/// 强制旋转app界面
- (void)rotateInterfaceOrientation:(UIInterfaceOrientation)orientation;

/// 开启屏幕旋转的检测
/// @param immediatelyUpdateUI 检测到屏幕方向发生改变是否立即更新界面，如果为NO，则会在autorotateInterfaceOrientation时更新界面方向
- (void)startListeningDirectionOfDeviceWithImmediately:(BOOL)immediatelyUpdateUI;

/// 开启屏幕旋转的检测
- (void)startListeningDirectionOfDevice;

/// 停止监听屏幕方向
- (void)stopListeningDirectionOfDevice;

@end

NS_ASSUME_NONNULL_END
