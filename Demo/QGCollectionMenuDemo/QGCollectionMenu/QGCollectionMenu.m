//
//  QGCollectionMenu.m
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/1.
//  Copyright © 2016年 quange. All rights reserved.
//

#import "QGCollectionMenu.h"
#import "QGCMCollectionViewCell.h"
#define kMenuCell @"kQGMenuCell"
@interface QGCollectionMenu ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollection;
@property (weak, nonatomic) IBOutlet UIView *subVCContainer;


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
        QGCollectionMenu* view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
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
    self.menuCollection.backgroundColor = [UIColor whiteColor];
    self.menuCollection.delegate = self;
    self.menuCollection.dataSource = self;
    [self.menuCollection registerNib:[UINib nibWithNibName:@"QGCMCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kMenuCell];
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
}

- (void)reload
{
    if(!self.dataSource)
    {
        NSLog(@"u must set datasoure before reload");
    }
    else
    {
        [self.menuCollection reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UICollectionViewCell *cell = [self collectionView:self.menuCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [UIView animateWithDuration:0.25 animations:^{
                self.line.frame = CGRectMake(cell.frame.origin.x, cell.frame.size.height-2, cell.frame.size.width, self.lineHeight);
                
            }];
        });
        
        for (NSString * title in [self.dataSource menumTitles]) {
            NSLog(@"%@",self.subVCContainer);
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
    QGCMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuCell forIndexPath:indexPath];
    cell.titleLabel.attributedText =  [[NSAttributedString alloc] initWithString: [[self.dataSource menumTitles] objectAtIndex:indexPath.row] attributes:indexPath.row == self.tag? self.titleSelectAtrributes: self.titleNormalAtrributes];
    cell.titleLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect textRect = [[[self.dataSource menumTitles] objectAtIndex:indexPath.row] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                                                                                options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                                                             attributes:self.titleNormalAtrributes
                                                                                                context:nil];
    return CGSizeMake(textRect.size.width+self.titleMargin, 40);
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tag == indexPath.row)
        return;
    NSInteger last = self.tag;
    self.tag = indexPath.row;
    [collectionView reloadItemsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:last inSection:indexPath.section]]];
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.25 animations:^{
        self.line.frame = CGRectMake(cell.frame.origin.x, cell.frame.size.height-2, cell.frame.size.width, self.lineHeight);
        
    }];
}

@end
