//
//  ViewController.m
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/1.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "ViewController.h"
#import "QGCollectionMenu.h"
@interface ViewController ()<QGCollectionMenuDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.menu reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)menumTitles
{
    return @[@"太阳",@"后裔",@"机会",@"宋钟基",@"韩国电视剧"];
}

- (NSString*)subVCClassStr
{
    return @"QGSubViewController";
}

@end
