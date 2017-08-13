//
//  QGHomeViewController.m
//  QGCollectionMenuDemo
//
//  Created by 张汝泉 on 2017/8/14.
//  Copyright © 2017年 quange. All rights reserved.
//

#import "QGHomeViewController.h"
#import "QGCodeViewController.h"
@interface QGHomeViewController ()

@end

@implementation QGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoCodeVc:(id)sender {
    QGCodeViewController *vc = [[QGCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
