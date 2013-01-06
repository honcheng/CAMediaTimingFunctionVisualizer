//
//  CubicBezierCurveView.m
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 5/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import "CubicBezierCurveView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ControlPoint

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    float radius = rect.size.width;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:0.660].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake((rect.size.width-radius)/2, (rect.size.height-radius)/2 ,radius,radius));
    
    float stroke_width = 1.0;
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(stroke_width, stroke_width, rect.size.width-2*stroke_width, rect.size.height-2*stroke_width));
}

@end

@interface CubicBezierCurveView()
@property (nonatomic, weak) ControlPoint *controlPoint1View, *controlPoint2View;
@property (nonatomic, assign) CGPoint initialControlPoint1ViewPosition, initialControlPoint2ViewPosition;
@end

#define CONTROL_POINT_DIAMETER 40.0

@implementation CubicBezierCurveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _controlPoint1 = CGPointMake(0.326, 1.512);
        _controlPoint2 = CGPointMake(0.814, 0.850);

        CGRect controlPoint1ViewFrame = CGRectMake(frame.size.width/3*(1+_controlPoint1.x)-CONTROL_POINT_DIAMETER/2,
                                                   frame.size.height/3*(2-_controlPoint1.y)-CONTROL_POINT_DIAMETER/2,
                                                   CONTROL_POINT_DIAMETER,
                                                   CONTROL_POINT_DIAMETER);
        ControlPoint *controlPoint1View = [[ControlPoint alloc] initWithFrame:controlPoint1ViewFrame];
        [self addSubview:controlPoint1View];
        self.controlPoint1View = controlPoint1View;
        
        CGRect controlPoint2ViewFrame = CGRectMake(frame.size.width/3*(1+_controlPoint2.x)-CONTROL_POINT_DIAMETER/2,
                                                   frame.size.height/3*(2-_controlPoint2.y)-CONTROL_POINT_DIAMETER/2,
                                                   CONTROL_POINT_DIAMETER,
                                                   CONTROL_POINT_DIAMETER);
        ControlPoint *controlPoint2View = [[ControlPoint alloc] initWithFrame:controlPoint2ViewFrame];
        [self addSubview:controlPoint2View];
        self.controlPoint2View = controlPoint2View;
        
        UIPanGestureRecognizer *controlPoint1GestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onControlPointPanned:)];
        [controlPoint1View addGestureRecognizer:controlPoint1GestureRecognizer];
        UIPanGestureRecognizer *controlPoint2GestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onControlPointPanned:)];
        [controlPoint2View addGestureRecognizer:controlPoint2GestureRecognizer];
    }
    return self;
}

- (void)setControlPoint1:(CGPoint)controlPoint1
{
    _controlPoint1 = controlPoint1;
    
    CGRect controlPoint1ViewFrame = CGRectMake(self.frame.size.width/3*(1+_controlPoint1.x)-CONTROL_POINT_DIAMETER/2,
                                               self.frame.size.height/3*(2-_controlPoint1.y)-CONTROL_POINT_DIAMETER/2,
                                               CONTROL_POINT_DIAMETER,
                                               CONTROL_POINT_DIAMETER);
    [self.controlPoint1View setFrame:controlPoint1ViewFrame];
}

- (void)setControlPoint2:(CGPoint)controlPoint2
{
    _controlPoint2 = controlPoint2;
    
    CGRect controlPoint2ViewFrame = CGRectMake(self.frame.size.width/3*(1+_controlPoint2.x)-CONTROL_POINT_DIAMETER/2,
                                               self.frame.size.height/3*(2-_controlPoint2.y)-CONTROL_POINT_DIAMETER/2,
                                               CONTROL_POINT_DIAMETER,
                                               CONTROL_POINT_DIAMETER);
    [self.controlPoint2View setFrame:controlPoint2ViewFrame];
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
    CGContextMoveToPoint(context, 0, rect.size.height/3);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/3);
    CGContextMoveToPoint(context, 0, rect.size.height/3*2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/3*2);
    CGContextMoveToPoint(context, rect.size.width/3, 0);
    CGContextAddLineToPoint(context, rect.size.width/3,rect.size.height);
    CGContextMoveToPoint(context, rect.size.width/3*2, 0);
    CGContextAddLineToPoint(context, rect.size.width/3*2,rect.size.height);
    float dash[2] = {2,2};
    CGContextSetLineDash(context, 0, dash, 2);
    CGContextStrokePath(context);
    
    CGContextSetLineWidth(context, 2.0);
    float dash2[2] = {0,0};
    CGContextSetLineDash(context, 0, dash2, 0);
    [[UIColor blueColor] setStroke];
    
    CGPoint startPoint = CGPointMake(rect.size.width/3, rect.size.height/3*2);
    CGPoint endPoint = CGPointMake(rect.size.width/3*2, rect.size.height/3);
    CGPoint controlPoint1 = CGPointMake(rect.size.width/3*(1+self.controlPoint1.x),rect.size.height/3*(2-self.controlPoint1.y));
    CGPoint controlPoint2 = CGPointMake(rect.size.width/3*(1+self.controlPoint2.x),rect.size.height/3*(2-self.controlPoint2.y));
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
//    CGPathRelease(bezierPath.CGPath);
    
    [[UIColor redColor] setStroke];
    CGContextSetLineDash(context, 0, dash, 2);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, controlPoint1.x, controlPoint1.y);
    CGContextMoveToPoint(context, endPoint.x, endPoint.y);
    CGContextAddLineToPoint(context, controlPoint2.x, controlPoint2.y);
    CGContextStrokePath(context);
    
    [[UIColor redColor] setFill];
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
        CGPoint newControlPointPosition = CGPointMake( (newCenter.x)/self.frame.size.width*3-1, (2-newCenter.y/self.frame.size.height*3));
        
        if (view==self.controlPoint1View) self.controlPoint1 = newControlPointPosition;
        else self.controlPoint2 = newControlPointPosition;
        
        [self setNeedsDisplay];
    }
    
    if ([self.delegate respondsToSelector:@selector(onCurveChanged)])
    {
        [self.delegate onCurveChanged];
    }
}

@end
