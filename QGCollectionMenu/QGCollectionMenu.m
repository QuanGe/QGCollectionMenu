//
//  QGCollectionMenu.m
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/1.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "QGCollectionMenu.h"
#import "QGCMCollectionViewCell.h"
#import "UIViewController+QGCollectionMenu.h"
#import <objc/runtime.h>
#import <objc/message.h>
#define kMenuCell @"kQGMenuCell"
#define kVCCell @"kQGVCCell"
@interface QGCollectionMenu ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollection;
@property (weak, nonatomic) IBOutlet UIView *subVCContainer;
@property (weak, nonatomic) IBOutlet UICollectionView *subVCCollection;
@property (assign, nonatomic) NSInteger selectedMenum;



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

+ (QGCollectionMenu*)menuByCode {
    QGCollectionMenu* view = [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass([self class])
                                                                           owner:nil
                                                                         options:nil] objectAtIndex:0];
  
    return view;
}
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
    [super awakeFromNib];
    if(!self.menuCollection.delegate)
        [self initConfig];
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(self.topBoxViewLocked)
        return;
    if (self.superview && newSuperview == nil) {
        
        for (UIView *sub in self.subVCCollection.subviews) {
            if ([sub isKindOfClass:[UICollectionViewCell class]])
                for (UIView* view in ((UICollectionViewCell *)sub).contentView.subviews) {
                    for (UIView* subview in view.subviews) {
                        
                        if([subview isKindOfClass:[UIScrollView class]])
                        {
                            CGFloat x = sub.frame.origin.x;
                            CGFloat w = (subview).frame.size.width;
                            NSInteger scrollIndex = x/w;
                            if (scrollIndex == self.selectedMenum){
                                @try {
                                    [subview removeObserver:self forKeyPath:@"contentOffset"];
                                }
                                @catch (NSException *exception) {
                                }
                                
                            }
                            break;
                        }
                    }
                }
            
        }
    }
}


- (void)addObserverWithSelectedScrollIndex:(NSInteger)index {
    if(self.topBoxViewLocked)
        return;
    for (UIView *sub in self.subVCCollection.subviews) {
        if ([sub isKindOfClass:[UICollectionViewCell class]])
            for (UIView* view in ((UICollectionViewCell *)sub).contentView.subviews) {
                for (UIView* subview in view.subviews) {
                    
                    if([subview isKindOfClass:[UIScrollView class]])
                    {
                        CGFloat x = sub.frame.origin.x;
                        CGFloat w = (subview).frame.size.width;
                        NSInteger scrollIndex = x/w;
                        if(scrollIndex == index) {
                            [subview addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
                            [self  addGestureRecognizer:[(UIScrollView*)subview panGestureRecognizer]];
                        }
                        else if (scrollIndex == self.selectedMenum){
                            
                            @try {
                                [subview removeObserver:self forKeyPath:@"contentOffset"];
                                if(self.gestureRecognizers.count>0){
                                    [(UIScrollView*)subview addGestureRecognizer:self.gestureRecognizers[0]];
                                }
                            }
                            @catch (NSException *exception) {
                            }
                            
                        }
                        
                    }
                }
            }
        
    }
    
}

- (void)updateOrtherScrollWithContentY:(CGFloat)contentY{
    if(self.topBoxViewLocked)
        return;
    for (UIView *sub in self.subVCCollection.subviews) {
        if ([sub isKindOfClass:[UICollectionViewCell class]])
            for (UIView* view in ((UICollectionViewCell *)sub).contentView.subviews) {
                for (UIView* subview in view.subviews) {
                    
                    if([subview isKindOfClass:[UIScrollView class]])
                    {
                        CGFloat x = sub.frame.origin.x;
                        CGFloat w = (subview).frame.size.width;
                        NSInteger scrollIndex = x/w;
                        if(self.selectedMenum != scrollIndex ) {
                            CGFloat allLockedY = self.topBoxViewHeightConstraint.constant- self.topBoxViewOrtherLockedHeight-self.titleHeightConstraint.constant;
                            if (((UIScrollView*)subview).contentOffset.y>allLockedY && -contentY== allLockedY)
                            {
                                
                            }else{
                                ((UIScrollView*)subview).contentOffset = CGPointMake(0, -contentY);
                            }
                        }
                        
                        
                    }
                }
            }
        
    }
    
}

- (void)setSelectedMenum:(NSInteger)selectedMenum {
    if (_selectedMenum == selectedMenum)
        return;
    [self addObserverWithSelectedScrollIndex:selectedMenum];
    _selectedMenum = selectedMenum;
    
}


- (void)setTopBoxViewLocked:(BOOL)topBoxViewLocked {
    _topBoxViewLocked = topBoxViewLocked;
    self.subVCContainerTopConstraint.constant = _topBoxViewLocked?self.topBoxViewHeightConstraint.constant:0;
    
}

- (void)initConfig
{
    //
    self.menuBackGroundColor = [UIColor whiteColor];
    self.menuCollection.backgroundColor = self.menuBackGroundColor;
    self.menuCollection.delegate = self;
    self.menuCollection.dataSource = self;
    self.menuCollection.scrollsToTop = false;
    [self.menuCollection registerNib:[UINib nibWithNibName:@"QGCMCollectionViewCell" bundle:[NSBundle bundleForClass:self.class]] forCellWithReuseIdentifier:kMenuCell];
    
    //
    self.subVCCollection.backgroundColor = [UIColor whiteColor];
    self.subVCCollection.delegate = self;
    self.subVCCollection.dataSource = self;
    self.subVCCollection.scrollsToTop = false;
    self.subVCCollection.showsHorizontalScrollIndicator = NO;
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
    self.topBoxViewLocked = YES;
    self.topBoxViewOrtherLockedHeight = 0;
    self.titleWidthEquals = NO;
    self.titleWidthEqualsAuto = YES;
    self.srollSubVCAnimate = NO;
    self.selectedMenum = -1;
    self.lineInCenter = NO;
}

- (void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    self.line.backgroundColor =self.lineColor;
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
        if([self.dataSource respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
            ((UIViewController*)self.dataSource).automaticallyAdjustsScrollViewInsets = false;
        if([self.dataSource respondsToSelector:@selector(edgesForExtendedLayout)])
            ((UIViewController*)self.dataSource).edgesForExtendedLayout = UIRectEdgeNone;
        if([((UIViewController*)self.dataSource).tabBarController respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
            ((UIViewController*)self.dataSource).tabBarController.automaticallyAdjustsScrollViewInsets = false;
        if([((UIViewController*)self.dataSource).tabBarController respondsToSelector:@selector(edgesForExtendedLayout)])
            ((UIViewController*)self.dataSource).tabBarController.edgesForExtendedLayout = UIRectEdgeNone;
        self.menuCollection.backgroundColor = self.menuBackGroundColor;
        [self.menuCollection reloadData];
        [self.subVCCollection reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UICollectionViewCell *cell = [self.menuCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [UIView animateWithDuration:0.25 animations:^{
                self.line.frame = CGRectMake(cell.frame.origin.x, self.lineInCenter?(cell.frame.size.height-self.lineHeight)/2:(cell.frame.size.height-self.lineHeight), cell.frame.size.width, self.lineHeight);
                [self.menuCollection sendSubviewToBack:self.line];
                if (self.lineInCenter) {
                    self.line.layer.cornerRadius = self.lineHeight/2;
                }
                
            }];
            self.selectedMenum = 0;
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateSubVCWithIndex:)])
                [self.delegate updateSubVCWithIndex:0];
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
    
    return self.dataSource? [[self.dataSource menumTitles] count]:0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.menuCollection == collectionView)
    {
        QGCMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuCell forIndexPath:indexPath];
        cell.titleLabel.attributedText =  [[NSAttributedString alloc] initWithString: [[self.dataSource menumTitles] objectAtIndex:indexPath.row] attributes:indexPath.row == self.tag? self.titleSelectAtrributes: self.titleNormalAtrributes];
        cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor =  [UIColor clearColor];
        cell.titleLabel.backgroundColor = [UIColor clearColor];
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
            UIViewController* childViewController= nil;
            if ([self.dataSource subVCClassStrsForCode].count==0 ) {
                childViewController = [mainStoryboard instantiateViewControllerWithIdentifier:subVCClassStr];
            }else if ([objc_getClass(subVCClassStr.UTF8String) respondsToSelector:@selector(allocByMenum)]) {
                childViewController = ((id (*)(id, SEL))objc_msgSend)(objc_getClass(subVCClassStr.UTF8String), @selector(allocByMenum));
            }else {
                childViewController = [[objc_getClass(subVCClassStr.UTF8String) alloc] init];
            }
            
            if([childViewController respondsToSelector:@selector(updateParameters:)])
            {
                [childViewController updateParameters:[[self.dataSource subVCClassParameters] objectAtIndex:indexPath.row]];
            }
            childViewController.view.frame = collectionView.frame;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (UIView *subView in childViewController.view.subviews) {
                    if([subView isKindOfClass:[UIScrollView class]]){
                        ((UIScrollView*)subView).contentOffset = CGPointMake(0, -self.topBoxView.transform.ty);
                    }
                }
            });
            
            [cell.contentView addSubview:childViewController.view];
            [(UIViewController*)self.dataSource addChildViewController:childViewController];
        }
        ((UIView*)[cell.contentView subviews][0]).tag = indexPath.row;
        //
        {
            id view = nil;
            while (view && [view isKindOfClass:[UIScrollView class]] == NO) {
                view = [view superview];
            }
            if(view)
            {
                ((UIScrollView*)view).scrollsToTop = YES;
            }
        }
        return cell;
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(self.menuCollection == collectionView)
    {
        CGRect textRect = (indexPath.row >= [self.dataSource menumTitles].count) ? CGRectMake(0, 0, 100, 100):([[[self.dataSource menumTitles] objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                                                                                    options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                                 attributes:self.titleNormalAtrributes
                                                                                                    context:nil]);
        
        if(self.titleWidthEqualsAuto)
        {
            CGFloat allWidth = 0;
            for (NSString *title in [self.dataSource menumTitles]) {
                CGRect textRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                   attributes:self.titleNormalAtrributes
                                                      context:nil];
                allWidth += (textRect.size.width +self.titleMargin);
            }
            if (allWidth < collectionView.bounds.size.width)
            {
                self.titleWidthEquals = YES;
            }
        }
        
        if (self.titleWidthEquals) {
            return CGSizeMake((collectionView.bounds.size.width-2*self.titleCollectionLeftOrRightLayoutInset)/[[self.dataSource menumTitles] count], self.titleHeightConstraint.constant);
        }
        else {
            return CGSizeMake(textRect.size.width+self.titleMargin, self.titleHeightConstraint.constant);
        }
        
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    }
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(collectionView == self.menuCollection)
    {
        return UIEdgeInsetsMake(0, self.titleCollectionLeftOrRightLayoutInset, 0, self.titleCollectionLeftOrRightLayoutInset);
    }
    else {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.menuCollection)
    {
        [self menuChangUIByTapWithIndexPath:indexPath subVCCollectionScroll:YES];
        [self.subVCCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:self.srollSubVCAnimate];
        
        if(self.srollSubVCAnimate) {
            collectionView.tag = 1;
        }
    }
}

- (void)menuChangUIByTapWithIndexPath:(NSIndexPath *)indexPath subVCCollectionScroll:(BOOL)scrool
{
    if(self.tag == indexPath.row)
        return;
    NSInteger last = self.tag;
    self.tag = indexPath.row;
    NSMutableArray *needReload = [NSMutableArray array];
    if ([self.menuCollection cellForItemAtIndexPath:indexPath]) {
        [needReload addObject:indexPath];
    }
    if ([self.menuCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:last inSection:indexPath.section]])
    {
        [needReload addObject:[NSIndexPath indexPathForRow:last inSection:indexPath.section]];
    }
    [self.menuCollection reloadItemsAtIndexPaths:needReload];
    
    if ([self.menuCollection cellForItemAtIndexPath:indexPath]) {
        [self.menuCollection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    UICollectionViewCell *cell = [self.menuCollection cellForItemAtIndexPath:indexPath];
    if (!cell)
        return;
    if(scrool)
        [UIView animateWithDuration:0.25 animations:^{
            self.line.frame = CGRectMake(cell.frame.origin.x, self.lineInCenter?(cell.frame.size.height-self.lineHeight)/2:(cell.frame.size.height-self.lineHeight), cell.frame.size.width, self.lineHeight);
            
        }];
    else
        self.line.frame = CGRectMake(cell.frame.origin.x, self.lineInCenter?(cell.frame.size.height-self.lineHeight)/2:(cell.frame.size.height-self.lineHeight), cell.frame.size.width, self.lineHeight);
    
    
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.menuCollection == collectionView) {
        return self.titleSpace;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.menuCollection == collectionView) {
        return self.titleSpace;
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.subVCCollection &&self.menuCollection.tag ==0)
    {
        
        int curPageIndex =  (scrollView.contentOffset.x - (int)scrollView.contentOffset.x%(int)scrollView.frame.size.width)/scrollView.frame.size.width;
        
        
        int realIndex = curPageIndex;
        if (abs( (int)scrollView.contentOffset.x%(int)scrollView.frame.size.width) > (scrollView.frame.size.width/2.0)) {
            realIndex = curPageIndex +1;
        }
        if (self.tag != realIndex) {
            NSInteger last = self.tag;
            self.tag = realIndex;
            if (last<[self.menuCollection numberOfItemsInSection:0])
                [self.menuCollection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:last inSection:0]]];
            if (realIndex<[self.menuCollection numberOfItemsInSection:0])
                [self.menuCollection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:realIndex inSection:0]]];
        }
        
        
        CGFloat curMove = ((int)scrollView.contentOffset.x%(int)scrollView.frame.size.width)/scrollView.frame.size.width;
        
        UICollectionViewCell *curCell = [self.menuCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:curPageIndex inSection:0]];
        
        self.line.frame = CGRectMake(curCell.frame.origin.x+curCell.frame.size.width * curMove+ curMove*self.titleSpace, self.lineInCenter?(curCell.frame.size.height-self.lineHeight)/2:(curCell.frame.size.height-self.lineHeight), curCell.frame.size.width, self.lineHeight);
        //NSLog(@"%.2f",scrollView.contentOffset.x);
        if(scrollView.contentOffset.x- scrollView.frame.size.width*curPageIndex == 0)
        {
            [self menuChangUIByTapWithIndexPath:[NSIndexPath indexPathForRow:curPageIndex inSection:0] subVCCollectionScroll:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.selectedMenum = curPageIndex;
                if (self.delegate && [self.delegate respondsToSelector:@selector(updateSubVCWithIndex:)])
                    [self.delegate updateSubVCWithIndex:curPageIndex];
            });
            
        }
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(scrollView == self.subVCCollection && self.menuCollection.tag == 1 &&self.srollSubVCAnimate)
    {
        self.menuCollection.tag = 0;
    }
}

- (void)subVCCollectionContentInsetUpdate
{
    UIEdgeInsets mei = self.subVCCollection.contentInset;
    NSLog(@"当前的顶是 %.3f",((UIViewController*)self.dataSource).topLayoutGuide.length);
    CGFloat h = mei.top;
    if(((UIViewController*)self.dataSource).navigationController && !((UIViewController*)self.dataSource).navigationController.navigationBarHidden)
        h = 64;
    
    self.subVCCollection.contentInset = UIEdgeInsetsMake(h, mei.left, mei.bottom, mei.right);
}

- (void)selectOneMenuWithIndex:(NSInteger)index animated:(BOOL)animated{
    [self.subVCCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == self.subVCCollection)
    {
        id view = nil;
        while (view && [view isKindOfClass:[UIScrollView class]] == NO) {
            view = [view superview];
        }
        if(view)
        {
            ((UIScrollView*)view).scrollsToTop = NO;
        }
    }
    
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(self.topBoxViewLocked)
        return;
    if([keyPath isEqualToString:@"contentOffset"])
    {
        CGFloat changeY = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue].y;
        CGFloat allLockedY = self.topBoxViewHeightConstraint.constant- self.topBoxViewOrtherLockedHeight-self.titleHeightConstraint.constant;
        CGFloat needTransformY = 0;
        if(changeY<=allLockedY)
            needTransformY = -changeY;
        else
            needTransformY = -allLockedY;
        
        self.topBoxView.transform = CGAffineTransformMakeTranslation(0, needTransformY);
        
        if([self.dataSource isKindOfClass:[UIViewController class]]) {
            NSInteger index = 0;
            
            UICollectionViewCell *cell = [self theSuper:object];
            CGFloat x = cell.frame.origin.x;
            CGFloat w = ((UIScrollView*)object).frame.size.width;
            index = x/w;
            if (index == self.selectedMenum) {
                [self updateOrtherScrollWithContentY:needTransformY];
                [[NSNotificationCenter defaultCenter] postNotificationName:QGCollectionMenumTopViewOriginYDidChangeNotification object:@[@(needTransformY),object]];
                
            }
            
        }
        
        
        
    }
    
}

- (id )theSuper:(UIView*)view {
    while (![view.superview isMemberOfClass:[UICollectionViewCell class]]) {
        
        view = view.superview;
    }
    return view.superview;
}
@end
