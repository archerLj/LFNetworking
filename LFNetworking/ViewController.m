//
//  ViewController.m
//  LFNetworking
//
//  Created by archerLj on 16/3/24.
//  Copyright © 2016年 archerLj. All rights reserved.
//

#import "ViewController.h"
#import "LFDoctorInfoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [nextButton setBackgroundColor:[UIColor blueColor]];
    [nextButton setTitle:@"next page" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(pushNextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

-(void)pushNextVC {
    LFDoctorInfoViewController *doctoInfo = [[LFDoctorInfoViewController alloc] init];
    [self.navigationController pushViewController:doctoInfo animated:YES];
}


@end
