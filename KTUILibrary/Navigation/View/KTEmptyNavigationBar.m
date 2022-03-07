//
//  KTEmptyNavigationBar.m
//	KOTU
//
//  Created by KOTU on 2020/5/20.
//

#import "KTEmptyNavigationBar.h"
#import "KTNavigationBar.h"

@implementation KTEmptyNavigationBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger majorVersion = [[NSProcessInfo processInfo] operatingSystemVersion].majorVersion;
    if (majorVersion == 11) {
        
    } else {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    
    NSInteger majorVersion = [[NSProcessInfo processInfo] operatingSystemVersion].majorVersion;
    if (majorVersion == 11) {
        [subview removeFromSuperview];
    } else {
        
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([self pointInside:point withEvent:event]) {
        NSArray *subViews = self.superview.subviews;
        [self assert:self.navController desc:@"最好传入UINavigationController，便于寻找自定义navigationbar"];
        if (self.navController) {
            subViews = self.navController.view.subviews;
        }
        UIView *hitView = [self filterHitViews:subViews point:point withEvent:event];
        return hitView;
    } else {
        return [super hitTest:point withEvent:event];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.translucent) {
        return false;
    } else {
        return true;
    }
}

- (nullable UIView *)filterHitViews:(NSArray<UIView *> *)subViews
                              point:(CGPoint)point
                          withEvent:(UIEvent *)event
{
    if (subViews.count == 0) {
        return nil;
    }

    UIView *filterView = nil;
    for (UIView *subView in subViews) {
        filterView = [self filterHitView:subView point:point withEvent:event];
        if (filterView) {
            break;
        }
        if (subView.subviews) {
            filterView = [self filterHitViews:subView.subviews point:point withEvent:event];
        }
        if (filterView) {
            break;
        }
    }
    return filterView;
}

- (nullable UIView *)filterHitView:(UIView *)view
                             point:(CGPoint)point
                         withEvent:(UIEvent *)event
{
    if ([view isKindOfClass:[self class]]) {
        return nil;
    } else if ([view isKindOfClass:KTNavigationBar.class]) {
        CGPoint insidePoint = [self convertPoint:point toView:view];
        UIView *hitView = [view hitTest:insidePoint withEvent:event];
        return hitView;
    } else {
        return nil;
    }
}

#pragma mark - assert
- (void)assert:(BOOL)flag desc:(NSString *)desc
{
#if DEBUG
    NSAssert(flag, desc);
#endif
}

@end
