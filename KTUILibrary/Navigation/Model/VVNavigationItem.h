//
//  VVNavigationItem.h
//  VOVA
//
//  Created by fwzhou on 2020/5/13.
//  Copyright © 2020 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VVBarBackgroundModel.h"
#import "VVBarButtonItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 自定义，对UINavigationItem的补充
@interface VVNavigationItem : NSObject

/// 是否隐藏导航栏
/// 如果隐藏导航栏，那么viewMoveDown失效
@property (nonatomic, assign) BOOL hidden;

/// 半透明
/// 与背景色冲突
@property (nonatomic, assign) BOOL translucent;

/// 整个页面向下移动“状态栏+导航栏”高度
@property (nonatomic, assign) BOOL viewMoveDown;

/// 背景及分割设置
@property (nonatomic, strong) VVBarBackgroundModel *barBGModel;

/// 当前透明度
@property (nonatomic, assign) CGFloat alpha;

/// 手势穿过导航栏
/// 页面未下移且导航栏透明度为0的时候，手势穿过导航栏
@property (nonatomic, assign) BOOL passThroughTouches;

/// 初时状态栏的样式
/// 由于导航栏透明度变化而导致状态栏可能变化，需设置初时状态栏的样式
@property (nonatomic, assign) UIStatusBarStyle originStatusBarStyle;

/// 根据背景颜色计算出的状态栏的样式
@property (nonatomic, assign, readonly) UIStatusBarStyle bgColorStatusBarStyle;

/// 标题
@property (nonatomic, strong, nullable) NSString *title;

/// 亮色个性化标题
@property (nonatomic, strong, nullable) NSAttributedString *lightAttrTitle;

/// 暗色个性化标题
@property (nonatomic, strong, nullable) NSAttributedString *darkAttrTitle;

/// 返回按钮
@property (nonatomic, strong, nullable) __kindof VVBarButtonItem *backBarButtonItem;

/// 右侧按钮
@property (nonatomic, strong, nullable) __kindof VVBarButtonItem *rightBarButtonItem;

/// 右侧多个按钮，优先级比rightBarButtonItem高
@property (nonatomic, strong, nullable) NSArray<__kindof VVBarButtonItem *> *rightBarButtonItems;

/// 自定义view
@property (nonatomic, strong, nullable) UIView *customView;

/// 自定义view是否包含状态栏的高度
@property (nonatomic, assign) BOOL containStatusBar;

/// 根据statusBarStyle得到的attributedString
- (NSAttributedString *)realityAttrTitle;

/// 实际的statusBarStyle
- (UIStatusBarStyle)realityStatusBarStyle;

@end

NS_ASSUME_NONNULL_END
