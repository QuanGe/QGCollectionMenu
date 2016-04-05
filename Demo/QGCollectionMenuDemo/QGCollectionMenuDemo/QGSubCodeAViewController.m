//
//  QGSubCodeAViewController.m
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/5.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "QGSubCodeAViewController.h"
#import "Masonry.h"
@interface QGSubCodeAViewController ()

@end

@implementation QGSubCodeAViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    UILabel * textLabel = [[UILabel alloc] init];
    {
        textLabel.text = @"你好，我来自QGSubCodeAViewController";
        textLabel.textColor = [UIColor blackColor];
        textLabel.backgroundColor = [UIColor orangeColor];
        textLabel.font = [UIFont systemFontOfSize:9];
        [self.view addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
