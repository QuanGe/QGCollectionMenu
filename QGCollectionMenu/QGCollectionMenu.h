//
//  QGCollectionMenu.h
//  QGCollectionMenuDemo
//
//  Created by 张如泉 on 16/4/1.
//  Copyright © 2016年 quange. All rights reserved.
//

#import <UIKit/UIKit.h>
#define QGCollectionMenumTopViewOriginYDidChangeNotification @"QGCollectionMenumTopViewOriginYDidChangeNotification"
@protocol QGCollectionMenuDataSource <NSObject>
@required
//
- (NSArray*)menumTitles;
//
- (NSArray*)subVCClassStrsForStoryBoard;
//
- (NSArray*)subVCClassStrsForCode;
//
- (NSArray*)subVCClassParameters;
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
@property (nonatomic,readwrite,assign) BOOL titleWidthEquals;
@property (nonatomic,readwrite,assign) BOOL titleWidthEqualsAuto;
@property (nonatomic,readwrite,assign) CGFloat lineHeight;
@property (nonatomic,readwrite,strong) UIColor *lineColor;
@property (nonatomic,readwrite,strong) UIColor *menuBackGroundColor;
@property (nonatomic,readwrite,assign) BOOL topBoxViewLocked;
@property (nonatomic,readwrite,assign) BOOL srollSubVCAnimate;
@property (weak, nonatomic) IBOutlet UIView *titleTopLineView;
@property (weak, nonatomic) IBOutlet UIView *titleBottomLineView;

@property (nonatomic,readwrite,assign) CGFloat topBoxViewOrtherLockedHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBoxViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subVCContainerTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *topBoxView;
//
- (void)selectOneMenuWithIndex:(NSInteger)index animated:(BOOL)animated;
//
- (void)reload;
//
- (void)subVCCollectionContentInsetUpdate;
@end
