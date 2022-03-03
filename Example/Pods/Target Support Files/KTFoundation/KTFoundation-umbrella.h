#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSArray+KTHelp.h"
#import "NSBundle+KTHelp.h"
#import "NSData+KTHelp.h"
#import "NSDate+KTHelp.h"
#import "NSDictionary+KTHelp.h"
#import "NSKeyedUnarchiver+KTHelp.h"
#import "NSNotificationCenter+KTHelp.h"
#import "NSNumber+KTHelp.h"
#import "NSObject+KTHelp.h"
#import "NSObject+KTHelpForKVC.h"
#import "NSObject+KTHelpForKVO.h"
#import "NSString+KTHelp.h"
#import "NSTimer+KTHelp.h"
#import "CALayer+KTHelp.h"
#import "KTCGUtilities.h"
#import "UIApplication+KTHelp.h"
#import "UIBarButtonItem+KTHelp.h"
#import "UIBezierPath+KTHelp.h"
#import "UIColor+KTHelp.h"
#import "UIControl+KTHelp.h"
#import "UIDevice+KTHelp.h"
#import "UIFont+KTHelp.h"
#import "UIGestureRecognizer+KTHelp.h"
#import "UIImage+KTHelp.h"
#import "UIScreen+KTHelp.h"
#import "UIScrollView+KTHelp.h"
#import "UITableView+KTHelp.h"
#import "UITextField+KTHelp.h"
#import "UIView+KTHelp.h"
#import "UIViewController+KTKeyboard.h"
#import <KTFoundation/KTMacros.h>
#import "KTMetamacros.h"
#import "KTQuickMacros.h"
#import "KTScope.h"
#import "KTSingle.h"

FOUNDATION_EXPORT double KTFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char KTFoundationVersionString[];

