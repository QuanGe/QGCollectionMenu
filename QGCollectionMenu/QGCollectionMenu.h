//
//  QGCollectionMenu.h
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/1.
//  Copyright © 2016年 quange. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QGCollectionMenuDataSource <NSObject>
@required
//
- (NSArray*)menumTitles;
//
- (NSArray*)subVCClassStrsForStoryBoard;
//
- (NSArray*)subVCClassStrsForCode;
@end

@protocol QGCollectionMenuDelegate <NSObject>
@required
//
- (void)updateSubVCWithIndex:(NSInteger)index;
@end
@interface QGCollectionMenu : UIView
@property (nonatomic,readwrite,weak) id<QGCollectionMenuDataSource> dataSource;
@property (nonatomic,readwrite,weak) id<QGCollectionMenuDelegate> delegate;
@property (nonatomic,readwrite,strong) NSDictionary *titleNormalAtrributes;
@property (nonatomic,readwrite,strong) NSDictionary *titleSelectAtrributes;
@property (nonatomic,readwrite,assign) CGFloat titleMargin;
@property (nonatomic,readwrite,assign) CGFloat lineHeight;
@property (nonatomic,readwrite,strong) UIColor *lineColor;
@property (nonatomic,readwrite,strong) UIColor *menuBackGroundColor;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;
//
- (void)reload;
//
- (void)subVCCollectionContentInsetUpdate;
@end
