//
//  VVViewProtocol.h
//  VOVA
//
//  Created by JackLee on 2019/8/9.
//  Copyright © 2019 iOS. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "VVViewProtocol.h"

#ifndef VVViewProtocol_h
#define VVViewProtocol_h

@protocol VVViewProtocol<NSObject>

@optional

/**
 根据model动态改变view的height

 @param model 数据源
 @return 高度
 */
+ (CGFloat)viewHeightWithModel:(id)model;

/// 根据配置创建视图
/// @param config 配置
+ (instancetype)view_initWithConfig:(id)config;

/**
 配置view以及subViews
 */
- (void)setUpUI;

/**
 设置约束
 */
- (void)setUpConstraints;

/// 加载初始化数据
- (void)loadInitData;

/**
 绑定UI事件
 */
- (void)bindUIActions;

/**
 添加通知监听
 */
- (void)addNotificationObserver __deprecated_msg("已废弃，用view_addObservers替换");

/**
 移除通知监听
 */
- (void)removeNotificationObserver __deprecated_msg("已废弃，用view_removeObservers替换");

/// 添加监听，init的时候添加监听
- (void)view_addObservers;

/// 移除监听，dealloc的时候移除监听
- (void)view_removeObservers;

/**
 根据数据源更新视图

 @param model 数据源
 */
- (void)updateWithModel:(id)model;

/**
 下拉刷新
 */
- (void)pullRefresh;

/**
 下载加载更多
 */
- (void)loadMore;

@end

@protocol VVViewDelegate <NSObject>

@optional

/**
 子视图事件传递

 @param view 事件所在视图
 @param sender 事件响应者
 @param eventName 事件名称
 @param data 传递的参数
 */
- (void)eventFrom:(id)view
           sender:(id)sender
             name:(NSString *)eventName
             data:(id)data;

/**
 子视图事件传递

 @param view 事件所在视图
 @param sender 事件响应者
 @param eventName 事件名称
 @param data 传递的参数
 @param extra 额外参数
 @param complete 回调
 */
- (void)eventFrom:(UIView *)view
           sender:(id)sender
             name:(NSString *)eventName
             data:(id)data
            extra:(id)extra
         complete:(void(^)(id data))complete;

@end


@protocol VVListViewProtocol <NSObject,VVViewProtocol>

@optional

/**
 如果view上有tableView或者collectionView的时候 注册的相关的cell的class列表
 */
- (NSArray <Class>*)cellClasses;

/**
 如果view上有tableView或者collectionView的时候 注册的相关的ReuseView的class列表
 */
- (NSArray <Class>*)resuseViewClasses;

/**
 如果view上有tableView或者collectionView的时候注册相关的cell
 */
- (void)registerCells;

/**
 如果view上有tableView或者collectionView的时候注册相关的ReuseView
 */
- (void)registerReuseViews;

@optional

/// 设置tableView的样式
- (UITableViewStyle)tableViewStyle;


/// 设置collectionViewLayout
- (UICollectionViewLayout *)collectionViewLayout;

@end

@protocol VVReuseViewProtocol<NSObject,VVViewProtocol,VVViewDelegate>

/**
 重用是的标识
 
 @return 标识
 */
+ (NSString *)identifier;

/// 为重用视图添加对应viewModel的监听,禁止开发者主动调用
- (void)addReuseViewModelObservers;

/// 移除重用视图对应viewModel上的监听,禁止开发者主动调用
- (void)removeReuseViewModelObservers;

@end

@protocol VVTableCellProtocol <NSObject,VVReuseViewProtocol>

@optional

/**
 单元格的高度，根据model动态可变

 @param model 数据源
 @return 高度
 */
+ (CGFloat)cellHeightWithModel:(id)model;

/**
 单元格的预估高度，根据model动态可变

 @param model 数据源
 @return 预估高度
 */
+ (CGFloat)estimateHeightWithModel:(id)model;

@end

@protocol VVCollectionCellProtocol <NSObject,VVReuseViewProtocol>

@optional

/**
 单元格的size，根据model动态可变

 @param model 数据源
 @return size
 */
+ (CGSize)itemSizeWithModel:(id)model;

@end

@protocol VVTableReuseViewProtocol <NSObject,VVReuseViewProtocol>

/**
 tableView区头高度

 @param model 数据源
 @return 高度
 */
+ (CGFloat)headerViewHeightWithModel:(id)model;

+ (CGFloat)headerViewEstimateHeightWithModel:(id)model;
/**
 tableView区尾高度
 
 @param model 数据源
 @return 高度
 */
+ (CGFloat)footerViewHeightWithModel:(id)model;

+ (CGFloat)footerViewEstimateHeightWithModel:(id)model;

@end

@protocol VVCollectionReuseViewProtocol <NSObject,VVReuseViewProtocol>

///< section头视图的kind 类型只能为 UICollectionElementKindSectionHeader 或 UICollectionElementKindSectionFooter
+ (NSString *)kind;

@optional

/**
 section头视图的size，根据model动态可变

 @param model 数据源
 @return size
 */
+ (CGSize)headerViewSizeWithModel:(id)model;

/**
 section尾视图的size，根据model动态可变
 
 @param model 数据源
 @return size
 */
+ (CGSize)footerViewSizeWithModel:(id)model;

@end

@protocol VVContainerViewProtocol <NSObject,VVViewProtocol,VVViewDelegate>

@property (nonatomic, weak) id<VVViewDelegate> vv_delegate;
- (void)container_viewWillAppear:(BOOL)animated;
- (void)container_viewDidAppear:(BOOL)animated;
- (void)container_viewWillDisappear:(BOOL)animated;

@end

#endif /* VVViewProtocol_h */
