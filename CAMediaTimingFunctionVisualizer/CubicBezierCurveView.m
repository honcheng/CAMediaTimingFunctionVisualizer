//
//  CubicBezierCurveView.m
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 5/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import "CubicBezierCurveView.h"
#import <QuartzCore/QuartzCore.h>

@interface CubicBezierCurveView()
@property (nonatomic, weak) UIView *controlPoint1View, *controlPoint2View;
@property (nonatomic, assign) CGPoint initialControlPoint1ViewPosition, initialControlPoint2ViewPosition;
@end

@implementation CubicBezierCurveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _controlPoint1 = CGPointMake(0.05, 0.1);
        _controlPoint2 = CGPointMake(0.9, 0.95);
        
        float controlPointDiameter = 40.0;
        
        CGRect controlPoint1ViewFrame = CGRectMake(frame.size.width/2+frame.size.width/2*_controlPoint1.x-controlPointDiameter/2,frame.size.height/2*(1-_controlPoint1.y)-controlPointDiameter/2,controlPointDiameter,controlPointDiameter);
        UIView *controlPoint1View = [[UIView alloc] initWithFrame:controlPoint1ViewFrame];
        [controlPoint1View.layer setCornerRadius:controlPointDiameter/2];
        [controlPoint1View setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:controlPoint1View];
        self.controlPoint1View = controlPoint1View;
        
        CGRect controlPoint2ViewFrame = CGRectMake(frame.size.width/2+frame.size.width/2*_controlPoint2.x-controlPointDiameter/2,frame.size.height/2*(1-_controlPoint2.y)-controlPointDiameter/2,controlPointDiameter,controlPointDiameter);
        UIView *controlPoint2View = [[UIView alloc] initWithFrame:controlPoint2ViewFrame];
        [controlPoint2View.layer setCornerRadius:controlPointDiameter/2];
        [controlPoint2View setBackgroundColor:[UIColor darkGrayColor]];
        [self addSubview:controlPoint2View];
        self.controlPoint2View = controlPoint2View;
        
        UIPanGestureRecognizer *controlPoint1GestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onControlPointPanned:)];
        [controlPoint1View addGestureRecognizer:controlPoint1GestureRecognizer];
        UIPanGestureRecognizer *controlPoint2GestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onControlPointPanned:)];
        [controlPoint2View addGestureRecognizer:controlPoint2GestureRecognizer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPathRef outlinePath = CGPathCreateWithRect(rect, NULL);
    CGContextSetLineWidth(context, 1.0);
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    CGContextAddPath(context, outlinePath);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(outlinePath);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    CGContextMoveToPoint(context, rect.size.width/2, 0);
    CGContextAddLineToPoint(context, rect.size.width/2,rect.size.height);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 2.0);
    
    CGPoint startPoint = CGPointMake(rect.size.width/2, rect.size.height/2);
    CGPoint endPoint = CGPointMake(rect.size.width, 0);
    CGPoint controlPoint1 = CGPointMake(rect.size.width/2+rect.size.width/2*self.controlPoint1.x,rect.size.height/2*(1-self.controlPoint1.y));
    CGPoint controlPoint2 = CGPointMake(rect.size.width/2+rect.size.width/2*self.controlPoint2.x,rect.size.height/2*(1-self.controlPoint2.y));
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
//    CGPathRelease(bezierPath.CGPath);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, controlPoint1.x, controlPoint1.y);
    CGContextMoveToPoint(context, endPoint.x, endPoint.y);
    CGContextAddLineToPoint(context, controlPoint2.x, controlPoint2.y);
    CGContextStrokePath(context);
    
    [[UIColor blackColor] setFill];
    CGRect controlPoint1CoordinateFrame = CGRectMake(controlPoint1.x+self.controlPoint1View.frame.size.width,controlPoint1.y-10,100,20);
    if (controlPoint1CoordinateFrame.origin.x+controlPoint1CoordinateFrame.size.width > self.frame.size.width)
    {
        controlPoint1CoordinateFrame.origin.x = controlPoint1.x - controlPoint1CoordinateFrame.size.width - self.controlPoint1View.frame.size.width;
    }
    NSString *controlPoint1Coordinate = [NSString stringWithFormat:@"(%.3f,%.3f)", self.controlPoint1.x, self.controlPoint1.y];
    [controlPoint1Coordinate drawInRect:controlPoint1CoordinateFrame withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    
    CGRect controlPoint2CoordinateFrame = CGRectMake(controlPoint2.x+self.controlPoint2View.frame.size.width,controlPoint2.y-10,100,20);
    if (controlPoint2CoordinateFrame.origin.x+controlPoint2CoordinateFrame.size.width > self.frame.size.width)
    {
        controlPoint2CoordinateFrame.origin.x = controlPoint2.x - controlPoint2CoordinateFrame.size.width - self.controlPoint2View.frame.size.width;
    }
    NSString *controlPoint2Coordinate = [NSString stringWithFormat:@"(%.3f,%.3f)", self.controlPoint2.x, self.controlPoint2.y];
    [controlPoint2Coordinate drawInRect:controlPoint2CoordinateFrame withFont:[UIFont boldSystemFontOfSize:15] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    
}

- (void)onControlPointPanned:(UIPanGestureRecognizer*)gestureRecognizer
{
    UIView *view = [gestureRecognizer view];
    UIGestureRecognizerState state = [gestureRecognizer state];
    if (state==UIGestureRecognizerStateBegan)
    {
        if (view==self.controlPoint1View) self.initialControlPoint1ViewPosition = [self.controlPoint1View frame].origin;
        else self.initialControlPoint2ViewPosition = [self.controlPoint2View frame].origin;
    }
    else
    {
        UIView *controlPointView = nil;
        CGPoint initialControlPointViewPosition;
        if (view==self.controlPoint1View)
        {
            controlPointView = self.controlPoint1View;
            initialControlPointViewPosition = self.initialControlPoint1ViewPosition;
        }
        else
        {
            controlPointView = self.controlPoint2View;
            initialControlPointViewPosition = self.initialControlPoint2ViewPosition;
        }
        
        CGPoint translation = [gestureRecognizer translationInView:self];
        CGRect controlPointFrame = [controlPointView frame];
        controlPointFrame.origin.x = initialControlPointViewPosition.x + translation.x;
        controlPointFrame.origin.y = initialControlPointViewPosition.y + translation.y;
        
        if (controlPointFrame.origin.x<-1*controlPointView.frame.size.width/2)
        {
            controlPointFrame.origin.x = -1*controlPointView.frame.size.width/2;
        }
        else if (controlPointFrame.origin.x>self.frame.size.width-controlPointView.frame.size.width/2)
        {
            controlPointFrame.origin.x = self.frame.size.width-controlPointView.frame.size.width/2;
        }
        if (controlPointFrame.origin.y<-1*controlPointView.frame.size.height/2)
        {
            controlPointFrame.origin.y = -1*controlPointView.frame.size.height/2;
        }
        else if (controlPointFrame.origin.y>self.frame.size.height-controlPointView.frame.size.height/2)
        {
            controlPointFrame.origin.y = self.frame.size.height-controlPointView.frame.size.height/2;
        }
        
        [controlPointView setFrame:controlPointFrame];
        
        CGPoint newCenter = controlPointView.center;
        CGPoint newControlPointPosition = CGPointMake( (newCenter.x)/self.frame.size.width*2-1, (1-newCenter.y/self.frame.size.height*2));
        
        if (view==self.controlPoint1View) self.controlPoint1 = newControlPointPosition;
        else self.controlPoint2 = newControlPointPosition;
        
        [self setNeedsDisplay];
    }
}

@end
