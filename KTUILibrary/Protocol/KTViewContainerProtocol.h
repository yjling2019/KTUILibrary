//
//  KTViewContainerProtocol.h
//  KTListViewController
//
//  Created by KOTU on 2021/12/10.
//

#import <Foundation/Foundation.h>
#import "KTModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KTViewContainerProtocol <NSObject>

@optional
/// 是否自动初始化
- (BOOL)kt_autoSetup;

/// 容器配置
- (void)kt_setUp;

/// 容器中配置视图
- (void)kt_setUpUI;

/// 容器中配置约束
- (void)kt_setUpConstraints;

/// 容器中绑定ui事件
- (void)kt_bindUIActions;

/// 容器中加载Init数据
- (void)kt_loadInitialData;

/// 容器从接口加载Init数据
- (void)kt_loadInitialDataFromServer;

/// 容器中刷新UI
- (void)kt_refreshUI;

/// 添加监听，viewDidload时添加
- (void)kt_addObservers;

/// 移除监听，dealloc时移除
- (void)kt_removeObservers;

@end

NS_ASSUME_NONNULL_END
