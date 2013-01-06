//
//  CubicBezierCurveView.h
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 5/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ControlPoint : UIView
@end

@protocol CubicBezierCurveViewDelegate <NSObject>
- (void)onCurveChanged;
@end

@interface CubicBezierCurveView : UIView
@property (nonatomic, assign) CGPoint controlPoint1, controlPoint2;
@property (nonatomic, weak) id<CubicBezierCurveViewDelegate> delegate;
@end
