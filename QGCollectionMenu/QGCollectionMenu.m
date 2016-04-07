//
//  QGCollectionMenu.m
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/1.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "QGCollectionMenu.h"
#import "QGCMCollectionViewCell.h"
#import <objc/runtime.h>
#define kMenuCell @"kQGMenuCell"
#define kVCCell @"kQGVCCell"
@interface QGCollectionMenu ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollection;
@property (weak, nonatomic) IBOutlet UIView *subVCContainer;
@property (weak, nonatomic) IBOutlet UICollectionView *subVCCollection;


@property (nonatomic,readwrite,strong) UIView * line;
@end

@implementation QGCollectionMenu

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    if(self.subviews.count > 0) {
        // loading xib
        return self;
    }
    else {
        // loading storyboard
        QGCollectionMenu* view = [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass([self class])
                                              owner:nil
                                            options:nil] objectAtIndex:0];
        
        [view copyPropertiesFromPrototype:self];
        
        return view;
    }
}


- (void)copyPropertiesFromPrototype:(UIView *)proto {
    self.frame = proto.frame;
    self.autoresizingMask = proto.autoresizingMask;
    self.translatesAutoresizingMaskIntoConstraints = proto.translatesAutoresizingMaskIntoConstraints;
    NSMutableArray *constraints = [NSMutableArray array];
    for(NSLayoutConstraint *constraint in proto.constraints) {
        id firstItem = constraint.firstItem;
        id secondItem = constraint.secondItem;
        if(firstItem == proto) firstItem = self;
        if(secondItem == proto) secondItem = self;
        [constraints addObject:[NSLayoutConstraint constraintWithItem:firstItem
                                                            attribute:constraint.firstAttribute
                                                            relatedBy:constraint.relation
                                                               toItem:secondItem
                                                            attribute:constraint.secondAttribute
                                                           multiplier:constraint.multiplier
                                                             constant:constraint.constant]];
    }
    for(UIView *subview in proto.subviews) {
        [self addSubview:subview];
    }
    [self addConstraints:constraints];
}

- (void)awakeFromNib
{
    if(!self.menuCollection.delegate)
        [self initConfig];
    
}

- (void)initConfig
{
    //
    self.menuBackGroundColor = [UIColor whiteColor];
    self.menuCollection.backgroundColor = self.menuBackGroundColor;
    self.menuCollection.delegate = self;
    self.menuCollection.dataSource = self;
    [self.menuCollection registerNib:[UINib nibWithNibName:@"QGCMCollectionViewCell" bundle:[NSBundle bundleForClass:self.class]] forCellWithReuseIdentifier:kMenuCell];
    
    //
    self.subVCCollection.backgroundColor = [UIColor whiteColor];
    self.subVCCollection.delegate = self;
    self.subVCCollection.dataSource = self;
    self.subVCCollection.pagingEnabled = YES;
    
    //
    
    self.titleNormalAtrributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0],
                                     NSFontAttributeName:[UIFont systemFontOfSize:13]};
    self.titleSelectAtrributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0],
                                   NSFontAttributeName:[UIFont systemFontOfSize:13]};
    self.lineColor = [UIColor colorWithRed:0.8 green:0 blue:0 alpha:1.0];
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 38, 50, self.lineHeight)];
    self.line.backgroundColor =self.lineColor;
    [self.menuCollection addSubview:self.line];
    self.titleHeightConstraint.constant = 40;
    self.titleMargin = 30;
    self.lineHeight = 2;
}

- (void)reload
{
    if(!self.dataSource)
    {
        NSLog(@"u must set datasoure before reload");
    }
    else if(([self.dataSource subVCClassStrsForStoryBoard].count == 0 && [self.dataSource subVCClassStrsForCode].count == 0)||([self.dataSource subVCClassStrsForStoryBoard].count != 0 && [self.dataSource subVCClassStrsForCode].count != 0))
    {
        NSLog(@"u must return subVC class from the storyBoard or code");
    }
    else
    {
        ((UIViewController*)self.dataSource).automaticallyAdjustsScrollViewInsets = false;
        self.menuCollection.backgroundColor = self.menuBackGroundColor;
        [self.menuCollection reloadData];
        [self.subVCCollection reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UICollectionViewCell *cell = [self.menuCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [UIView animateWithDuration:0.25 animations:^{
                self.line.frame = CGRectMake(cell.frame.origin.x, cell.frame.size.height-2, cell.frame.size.width, self.lineHeight);
                
            }];
            
            //[self.delegate updateSubVCWithIndex:0];
        });
        
        for (NSString * subVCClassStr in [self.dataSource subVCClassStrsForStoryBoard]) {
            [self.subVCCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:subVCClassStr];
        }
        
        for (NSString * subVCClassStr in [self.dataSource subVCClassStrsForCode]) {
            [self.subVCCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:subVCClassStr];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self.dataSource menumTitles] count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.menuCollection == collectionView)
    {
        QGCMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuCell forIndexPath:indexPath];
        cell.titleLabel.attributedText =  [[NSAttributedString alloc] initWithString: [[self.dataSource menumTitles] objectAtIndex:indexPath.row] attributes:indexPath.row == self.tag? self.titleSelectAtrributes: self.titleNormalAtrributes];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor =  self.menuBackGroundColor;
        cell.titleLabel.backgroundColor = self.menuBackGroundColor;
        return cell;
        
    }
    else
    {
        NSString *subVCClassStr =  [[self.dataSource subVCClassStrsForCode].count==0?[self.dataSource subVCClassStrsForStoryBoard]:[self.dataSource subVCClassStrsForCode] objectAtIndex:indexPath.row];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:subVCClassStr forIndexPath:indexPath];
        if(cell.contentView.subviews.count == 0)
        {
            //UIViewController *childViewController = [[objc_getClass(([self.dataSource subVCClassStr]).UTF8String) alloc] init];
            UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController* childViewController=[self.dataSource subVCClassStrsForCode].count==0?[mainStoryboard instantiateViewControllerWithIdentifier:subVCClassStr]:[[objc_getClass(subVCClassStr.UTF8String) alloc] init];
            
            
            childViewController.view.frame = collectionView.frame;
            [cell.contentView addSubview:childViewController.view];
            [(UIViewController*)self.dataSource addChildViewController:childViewController];
        }
        ((UIView*)[cell.contentView subviews][0]).tag = indexPath.row;
        [self.delegate updateSubVCWithIndex:indexPath.row];
        return cell;
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect textRect = [[[self.dataSource menumTitles] objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                                                                                options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                             attributes:self.titleNormalAtrributes
                                                                                                context:nil];
    if(self.menuCollection == collectionView)
    {
        return CGSizeMake(textRect.size.width+self.titleMargin, 40);
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    }
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.menuCollection)
    {
        [self menuChangUIByTapWithIndexPath:indexPath subVCCollectionScroll:YES];
        [self.subVCCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        collectionView.tag = 1;
    }
}

- (void)menuChangUIByTapWithIndexPath:(NSIndexPath *)indexPath subVCCollectionScroll:(BOOL)scrool
{
    if(self.tag == indexPath.row)
        return;
    NSInteger last = self.tag;
    self.tag = indexPath.row;
    [self.menuCollection reloadItemsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:last inSection:indexPath.section]]];
    [self.menuCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    UICollectionViewCell *cell = [self.menuCollection cellForItemAtIndexPath:indexPath];
    if(scrool)
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake(cell.frame.origin.x, cell.frame.size.height-2, cell.frame.size.width, self.lineHeight);
        
    }];
    else
        self.line.frame = CGRectMake(cell.frame.origin.x, cell.frame.size.height-2, cell.frame.size.width, self.lineHeight);
    
    
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.subVCCollection &&self.menuCollection.tag ==0)
    {
        int curPageIndex =  (scrollView.contentOffset.x - (int)scrollView.contentOffset.x%(int)scrollView.frame.size.width)/scrollView.frame.size.width;
        CGFloat curMove = ((int)scrollView.contentOffset.x%(int)scrollView.frame.size.width)/scrollView.frame.size.width;
    
        UICollectionViewCell *curCell = [self.menuCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:curPageIndex inSection:0]];
        
        self.line.frame = CGRectMake(curCell.frame.origin.x+curCell.frame.size.width * curMove, curCell.frame.size.height-2, curCell.frame.size.width, self.lineHeight);
        
        if(fabs(curMove)<0.02)
        {
            [self menuChangUIByTapWithIndexPath:[NSIndexPath indexPathForRow:curPageIndex inSection:0] subVCCollectionScroll:NO];
        }
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(scrollView == self.subVCCollection && self.menuCollection.tag == 1)
    {
        self.menuCollection.tag = 0;
    }
}

- (void)clearCollectionDelegateAndDataSource
{
    self.menuCollection.dataSource = nil;
    self.subVCCollection.delegate = nil;
    self.menuCollection.delegate = nil;
    self.subVCCollection.dataSource = nil;
}

- (void)resetCollectionDelegateAndDataSource
{
    self.menuCollection.dataSource = self;
    self.subVCCollection.dataSource = self;
    self.menuCollection.delegate = self;
    self.subVCCollection.delegate = self;
}
@end
