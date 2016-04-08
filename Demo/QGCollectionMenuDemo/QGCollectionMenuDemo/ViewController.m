//
//  ViewController.m
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/1.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "ViewController.h"
#import "QGCollectionMenu.h"

@interface ViewController ()<QGCollectionMenuDataSource,QGCollectionMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.menu.delegate = self;
    self.menu.dataSource = self;
    self.menu.menuBackGroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    [self.menu reload];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view layoutSubviews];
    
}

- (void)viewDidLayoutSubviews
{
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        [self.menu subVCCollectionContentInsetUpdate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)menumTitles
{
    return @[@"太阳",@"后裔",@"机会",@"宋钟基",@"韩国电视剧"];
}

- (NSArray*)subVCClassStrsForStoryBoard
{
    return @[];
}

- (NSArray*)subVCClassStrsForCode
{
    return @[@"QGSubCodeAViewController",@"QGSubCodeAViewController",@"QGSubCodeBViewController",@"QGSubCodeAViewController",@"QGSubCodeAViewController"];
}

- (void)updateSubVCWithIndex:(NSInteger)index
{
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * subs = [self childViewControllers];
        for (UIViewController *vc in subs) {
            if(vc.view.tag == index)
            {
                NSLog(@" 当前的vc的tag是：%@,当前页面需要刷新数据",self.menumTitles[vc.view.tag]);
                vc.view.backgroundColor = [UIColor colorWithRed:(CGFloat)(index+1.0)/[self.menumTitles count] green:(CGFloat)(index+1.0)/[self.menumTitles count] blue:(CGFloat)(index+1.0)/[self.menumTitles count] alpha:1];
            }
        }
    //});
    
}
@end
