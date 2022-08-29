//
//  UICollectionViewCell+KTHelp.h
//  KTFoundation
//
//  Created by KOTU on 2022/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (KTHelp)

/// 从响应链获取，非绑定
@property (nonatomic, readonly, nullable) UICollectionView *kt_collectionView;

@end

NS_ASSUME_NONNULL_END
