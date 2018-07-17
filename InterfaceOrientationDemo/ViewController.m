//
//  ViewController.m
//  InterfaceOrientationDemo
//
//  Created by xiaoyuan on 2018/7/17.
//  Copyright © 2018 xiaoyuan. All rights reserved.
//

#import "ViewController.h"
#import "SupportViewController.h"
#import "NaviController.h"
#import "InterfaceOrientationUtil.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[InterfaceOrientationUtil sharedInsatnce] applyInterfaceOrientation:UIInterfaceOrientationPortrait];
}

- (IBAction)naviAction:(id)sender {
    
    NaviController *navi = [NaviController new];
    navi.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:navi animated:YES];
    
}
- (IBAction)supportAction:(id)sender {
    SupportViewController *support = [SupportViewController new];
    support.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:support animated:YES];
}


@end
