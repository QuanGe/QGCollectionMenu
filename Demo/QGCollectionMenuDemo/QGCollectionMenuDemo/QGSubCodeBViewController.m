//
//  QGSubCodeBViewController.m
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/5.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "QGSubCodeBViewController.h"
#import "Masonry.h"
@interface QGSubCodeBViewController ()

@end

@implementation QGSubCodeBViewController

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"acell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

@end
