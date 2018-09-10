//
//  InterfaceOrientationUtil.m
//  InterfaceOrientationDemo
//
//  Created by xiaoyuan on 2018/7/17.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "InterfaceOrientationUtil.h"
#import <CoreMotion/CoreMotion.h>

@interface InterfaceOrientationUtil ()

@property (strong, nonatomic) CMMotionManager *motionManager;
/// 记录是否为强制修改屏幕方向
@property (nonatomic, assign) BOOL isForceApplyOrientation;
@property (nonatomic, assign) BOOL shouldAutorotate;
@property (nonatomic, assign) BOOL isListening;
@property (nonatomic, assign) BOOL immediatelyUpdateUI;
@property (nonatomic, assign) UIDeviceOrientation forceOrientation;

@end

@implementation InterfaceOrientationUtil

+ (instancetype)sharedInsatnce {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = self.new;
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /// @note 需要在app的rootViewController中初始化InterfaceOrientationUtil，以便在设备方向改变时记录forceOrientation
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientaionDidChange:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
        /// 初始化时确保forceOrientation知道当前设备真实的方向，保证在启动app时用户未选择屏幕时，强制旋转屏幕后还能再旋转回来
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        self.forceOrientation = orientation;
        self.immediatelyUpdateUI = YES;
    }
    return self;
}

/// 当用户锁定了屏幕旋转开关时，且app在前台时，设备旋转不会触发此通知，当app启动、从后台进入前台或者被激活时，都会触发此通知
- (void)deviceOrientaionDidChange:(NSNotification *)noty {
    BOOL isForceApplyOrientation = self.isForceApplyOrientation;
    if (isForceApplyOrientation) {
        // 如果是强制修改屏幕方向而发的通知则不处理shouldAutorotate属性，只记录系统更新的屏幕方向
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice] ;
    /**
     *  取得当前Device的方向，Device的方向类型为Integer
     *
     *  必须调用beginGeneratingDeviceOrientationNotifications方法后，此orientation属性才有效，否则一直是0。orientation用于判断设备的朝向，与应用UI方向无关
     *
     *  @param device.orientation
     *
     */
    NSLog(@"%@", noty.userInfo);
    
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            self.forceOrientation = device.orientation;
            // 只有当用户把手机旋转到横屏的时候来去触发判断是否支持横屏
            [self setShouldAutorotate:YES];
            break;
        default:
            /// 屏幕方向不需要自动旋转，需要将forceOrientation设置为竖屏，防止界面被强制修改了
            self.forceOrientation = UIDeviceOrientationPortrait;
            [self setShouldAutorotate:NO];
            break;
    }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - 强制屏幕旋转
////////////////////////////////////////////////////////////////////////

- (void)applyInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (self.immediatelyUpdateUI) {
        [self rotateInterfaceOrientation:orientation];
    }
    
    [self setForceOrientation:(UIDeviceOrientation)orientation];
}

- (void)startListeningDirectionOfDevice {
    
    [self startListeningDirectionOfDeviceWithImmediately:YES];
}

- (void)rotateInterfaceOrientation:(UIInterfaceOrientation)orientation {
    self.isForceApplyOrientation = YES;
    UIDevice *currentDevice = [UIDevice currentDevice];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    /// mark:强制旋转有时无效的解决方案: 强制前先设置为UIDeviceOrientationUnknown
    [currentDevice setValue:@(UIDeviceOrientationUnknown) forKey:@"orientation"];
    
    SEL selector = NSSelectorFromString(@"setOrientation:");
    if (![currentDevice respondsToSelector:selector]) {
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:currentDevice];
    // 从2开始是因为0 1 两个参数已经被selector和target占用
    [invocation setArgument:&orientation atIndex:2];
    [invocation invoke];
    [currentDevice endGeneratingDeviceOrientationNotifications];
    self.isForceApplyOrientation = NO;
}

/// 开启屏幕旋转的检测
- (void)startListeningDirectionOfDeviceWithImmediately:(BOOL)immediatelyUpdateUI {
    self.immediatelyUpdateUI = immediatelyUpdateUI;
    if (self.isListening) {
        return;
    }
    self.isListening = YES;
    if (self.motionManager == nil) {
        self.motionManager = [[CMMotionManager alloc] init];
    }
    
    // 提供设备运动数据到指定的时间间隔 刷新数据的评率
    self.motionManager.deviceMotionUpdateInterval = 0.3;
    
    // 判断设备传感器是否可用
    if (self.motionManager.deviceMotionAvailable) {
        // 启动设备的运动更新，通过给定的队列向给定的处理程序提供数据。
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        [self setMotionManager:nil];
    }
}

- (void)stopListeningDirectionOfDevice {
    if (_motionManager) {
        [_motionManager stopDeviceMotionUpdates];
        _motionManager = nil;
    }
    self.isListening = NO;
    self.immediatelyUpdateUI = YES;
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {
    if ([self shouldAutorotate] == NO) {
        return;
    }
    
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    
    if (fabs(y) >= fabs(x)) {// 竖屏
        if (y < 0) {
            [self applyInterfaceOrientation:UIInterfaceOrientationPortrait];
        }
        else {
            [self applyInterfaceOrientation:UIInterfaceOrientationPortraitUpsideDown];
        }
    }
    else { // 横屏
        if (x < 0) {
            [self applyInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
        else {
            [self applyInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        }
    }
}

- (void)autorotateInterfaceOrientation {
    self.immediatelyUpdateUI = YES;
    UIDeviceOrientation forceOrientation = self.forceOrientation;
    if (forceOrientation == UIDeviceOrientationFaceUp ||
        forceOrientation == UIDeviceOrientationFaceDown ||
        forceOrientation == UIDeviceOrientationUnknown) {
        return;
    }
    [self applyInterfaceOrientation:(UIInterfaceOrientation)forceOrientation];
}

- (void)setForceOrientation:(UIDeviceOrientation)forceOrientation {
    _forceOrientation = forceOrientation;
}

@end
