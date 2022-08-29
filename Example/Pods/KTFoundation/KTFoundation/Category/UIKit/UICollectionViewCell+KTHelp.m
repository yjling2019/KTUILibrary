//
//  UICollectionViewCell+KTHelp.m
//  KTFoundation
//
//  Created by KOTU on 2022/6/30.
//

#import "UICollectionViewCell+KTHelp.h"
#import "UIResponder+KTHelp.h"

@implementation UICollectionViewCell (KTHelp)

- (UICollectionView *)kt_collectionView
{
	return [self nextResponderOfClass:[UICollectionView class]];
}

@end
