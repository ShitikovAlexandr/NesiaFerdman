//
//  NFStyleKit.m
//  Nesia
//
//  Created by Alex on 5/23/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//

#import "NFStyleKit.h"
#import "NFAddFooterView.h"


@implementation NFStyleKit

#pragma mark Cache

static UIColor* _bASE_GREEN = nil;
static UIColor* _lIGHT_GREEN = nil;
static UIColor* _sUPER_LIGHT_GREEN = nil;
static UIColor* _base_GREY = nil;
static UIColor* _borderDarkGrey = nil;
static UIColor* _lightGrey = nil;
static UIColor* _googleRed = nil;

#pragma mark Initialization

+ (void)initialize
{
    // Colors Initialization
    _bASE_GREEN = [UIColor colorWithRed: 0.141 green: 0.565 blue: 0.208 alpha: 1];
    _lIGHT_GREEN = [UIColor colorWithRed: 0.173 green: 0.631 blue: 0.255 alpha: 1];
    _sUPER_LIGHT_GREEN = [UIColor colorWithRed: 0.278 green: 0.682 blue: 0.361 alpha: 1];
    _base_GREY = [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1];
    _borderDarkGrey = [UIColor colorWithRed:206/255.0 green:206/255.0 blue:209/255.0 alpha:1];
    _lightGrey = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    _googleRed = [UIColor colorWithRed:244/255.0 green:48/255.0 blue:52/255.0 alpha:1];
    
}

#pragma mark Colors

+ (UIColor*)bASE_GREEN { return _bASE_GREEN; }
+ (UIColor*)lIGHT_GREEN { return _lIGHT_GREEN; }
+ (UIColor*)sUPER_LIGHT_GREEN { return _sUPER_LIGHT_GREEN; }
+ (UIColor*)_base_GREY { return _base_GREY; }
+ (UIColor*)_borderDarkGrey { return _borderDarkGrey; }
+ (UIColor*)_lightGrey { return  _lightGrey; }
+ (UIColor*) _googleRed {return _googleRed;}


#pragma mark Drawing Methods

+ (void)foterViewWithAddButtonAction:(SEL)action toTableView:(UITableView*)tableView withTarget:(id)target {
    CGRect footerRect = CGRectMake(0, 0, tableView.frame.size.width, 40.0);
    NFAddFooterView *tableFooter =[[NFAddFooterView alloc] initWithFrame:footerRect];
    [tableFooter.addButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    tableFooter.backgroundColor = _base_GREY;
    tableView.backgroundColor = _base_GREY;
    tableView.tableFooterView = tableFooter;
}

+ (void)foterViewWithAddTextFieldtoTableView:(UITableView*)tableView withTarget:(id)target {
    CGRect footerRect = CGRectMake(0, 0, tableView.frame.size.width, 40.0);
    NFAddFooterView *tableFooter =[[NFAddFooterView alloc] initWithFrame:footerRect];
    tableFooter.textField.delegate = target;
   
    tableFooter.backgroundColor = _base_GREY;
    tableView.backgroundColor = _base_GREY;
    tableView.tableFooterView = tableFooter;

}

+ (void)drawDownBorderWithView: (UIView* )view {
    CGRect sepFrame = CGRectMake(0, view.frame.size.height-1, view.frame.size.width, 1.0);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [NFStyleKit _borderDarkGrey];
    [view addSubview:seperatorView];

}

+ (void)drawDownBorderWithView: (UIView* )view withOffset:(CGFloat)offset {
    CGRect sepFrame = CGRectMake(offset, view.frame.size.height-1, view.frame.size.width - offset , 1.0);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [NFStyleKit _borderDarkGrey];
    [view addSubview:seperatorView];
}

+ (UIView*)returnDownBorderWithView:(UIView* )view withOffset:(CGFloat)offset {
    CGRect sepFrame = CGRectMake(offset, view.frame.size.height-1, CGRectGetWidth(view.frame) - offset , 1.0);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [NFStyleKit _borderDarkGrey];
    return seperatorView;
}

+ (void)drawTopBorderWithView: (UIView* )view withOffset:(CGFloat)offset {
    CGRect sepFrame = CGRectMake(offset, 1.0, CGRectGetWidth(view.frame) - offset , 1.0);
    UIView *seperatorView = [[UIView alloc] initWithFrame:sepFrame];
    seperatorView.backgroundColor = [NFStyleKit _borderDarkGrey];
    [view addSubview:seperatorView];
}


+ (void)drawRoundetViewWithFrame: (CGRect)frame
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor.blackColor colorWithAlphaComponent: 0.5];
    shadow.shadowOffset = CGSizeMake(0, 2);
    shadow.shadowBlurRadius = 15;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPath];
    [rectanglePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 1.00000 * frame.size.width, CGRectGetMaxY(frame) - 83.9)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMaxY(frame) - 15) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 1.00000 * frame.size.width, CGRectGetMaxY(frame) - 83.9) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75000 * frame.size.width, CGRectGetMaxY(frame) - 15)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.00000 * frame.size.width, CGRectGetMaxY(frame) - 83.9) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.25000 * frame.size.width, CGRectGetMaxY(frame) - 15) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.00000 * frame.size.width, CGRectGetMaxY(frame) - 83.9)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 1.00000 * frame.size.width, CGRectGetMaxY(frame) - 83.9)];
    [rectanglePath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
    [NFStyleKit.bASE_GREEN setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}

+ (void)drawCircleWithFrame: (CGRect)frame
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Shadow Declarations
    NSShadow* circleShadow = [[NSShadow alloc] init];
    circleShadow.shadowColor = [UIColor.blackColor colorWithAlphaComponent: 0.15];
    circleShadow.shadowOffset = CGSizeMake(0, 0);
    circleShadow.shadowBlurRadius = 17;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPath];
    [rectanglePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.75503 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.25715 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.74285 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75503 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.24497 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.74285 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.50000 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.25715 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.24497 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.06027 * frame.size.height)];
    [rectanglePath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, circleShadow.shadowOffset, circleShadow.shadowBlurRadius, [circleShadow.shadowColor CGColor]);
    [NFStyleKit.lIGHT_GREEN setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}

+ (void)drawLogoCircleWithFrame: (CGRect)frame
{
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPath];
    [rectanglePath moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.75503 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.24864 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.96176 * frame.size.width, CGRectGetMinY(frame) + 0.74040 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.75503 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.24497 * frame.size.width, CGRectGetMinY(frame) + 0.93973 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.74040 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.49452 * frame.size.height)];
    [rectanglePath addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 0.03824 * frame.size.width, CGRectGetMinY(frame) + 0.24864 * frame.size.height) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 0.24497 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height)];
    [rectanglePath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0.50000 * frame.size.width, CGRectGetMinY(frame) + 0.04932 * frame.size.height)];
    [rectanglePath closePath];
    [NFStyleKit.sUPER_LIGHT_GREEN setFill];
    [rectanglePath fill];
}

+ (void)drawLeftRoundButtonWithFrame: (CGRect)frame
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* blueButtonColor = [UIColor colorWithRed: 0.267 green: 0.29 blue: 0.706 alpha: 1];
    
    //// Shadow Declarations
    NSShadow* buttonShadow = [[NSShadow alloc] init];
    buttonShadow.shadowColor = [UIColor.blackColor colorWithAlphaComponent: 0.44];
    buttonShadow.shadowOffset = CGSizeMake(0, 0);
    buttonShadow.shadowBlurRadius = 10;
    
    //// Variable Declarations
    CGFloat height = 68;
    CGFloat cornerRadius = height / 2.0;
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(5, 7, 195, (height - 8)) byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(cornerRadius, cornerRadius)];
    [rectanglePath closePath];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, buttonShadow.shadowOffset, buttonShadow.shadowBlurRadius, [buttonShadow.shadowColor CGColor]);
    [blueButtonColor setFill];
    [rectanglePath fill];
    CGContextRestoreGState(context);
}

#pragma mark Generated Images

+ (UIImage*)imageOfRoundetViewWithSize: (CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [NFStyleKit drawRoundetViewWithFrame: CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    UIImage* imageOfRoundetView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageOfRoundetView;
}

+ (UIImage*)imageOfCircleWithSize: (CGSize)imageSize
{
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    [NFStyleKit drawCircleWithFrame: CGRectMake(0, 0, imageSize.width, imageSize.height)];
    
    UIImage* imageOfCircle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageOfCircle;
}

@end
