//
//  PAViewController.m
//  PieAni
//
//  Created by duan on 13-7-1.
//  Copyright (c) 2013年 duan. All rights reserved.
//

#import "PAViewController.h"
#import "PAPieAniView.h"
@interface PAViewController ()
{
    PAPieAniView *pieAniView;
}
@end

@implementation PAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    pieAniView=[[PAPieAniView alloc] initWithFrame:CGRectMake(10, 20, 300, 300)];
    [self.view addSubview:pieAniView];
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake(10, 330, 60, 25);
    [btn setTitle:@"Show" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showBtn_TouchupInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)showBtn_TouchupInside
{
    NSArray *dataArr=[NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:3],[NSNumber numberWithInt:7],[NSNumber numberWithInt:1],[NSNumber numberWithInt:9],[NSNumber numberWithInt:5], nil];
    [pieAniView showPieAni:dataArr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
