//
//  MainViewController.m
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 5/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import "MainViewController.h"
#import "CubicBezierCurveView.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()
@property (nonatomic, weak) CubicBezierCurveView *graphView;
@property (nonatomic, weak) UIView *animatedView;
@property (nonatomic, weak) UIButton *translateButton, *scaleButton;
@end

@implementation MainViewController

- (id)init
{
    self = [super init];
    if (self) {
 
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    CubicBezierCurveView *graphView = [[CubicBezierCurveView alloc] initWithFrame:CGRectMake(40, 40, [self.view bounds].size.width-2*40, 500)];
    [self.view addSubview:graphView];
    self.graphView = graphView;
    
    UIButton *translateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [translateButton setFrame:CGRectMake(40, [self.view bounds].size.height-80, 100, 40)];
    [translateButton setTitle:@"Translate" forState:UIControlStateNormal];
    [self.view addSubview:translateButton];
    [translateButton addTarget:self action:@selector(onTranslateButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.translateButton = translateButton;
    
    UIButton *scaleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scaleButton setFrame:CGRectMake(160, [self.view bounds].size.height-80, 100, 40)];
    [scaleButton setTitle:@"Scale" forState:UIControlStateNormal];
    [self.view addSubview:scaleButton];
    [scaleButton addTarget:self action:@selector(onScaleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.scaleButton = scaleButton;

    UIView *animatedView = [[UIView alloc] initWithFrame:CGRectMake(graphView.frame.origin.x+40, graphView.frame.origin.y+graphView.frame.size.height+50+80, 180,180)];
    [animatedView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:animatedView];
    self.animatedView = animatedView;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)onScaleButtonPressed:(id)sender
{
    [self.translateButton setEnabled:NO];
    [self.scaleButton setEnabled:NO];
    
    CGPoint c1 = self.graphView.controlPoint1;
    CGPoint c2 = self.graphView.controlPoint2;
    
    CGPoint finalScale = CGPointMake(1.2, 1.2);
    [CATransaction begin];
    {
        float animation_duration = 0.5;
        
        [CATransaction setCompletionBlock:^{
            [self performSelector:@selector(reset) withObject:nil afterDelay:0.5];
        }];
        
        CAMediaTimingFunction *scaleFunction = [CAMediaTimingFunction functionWithControlPoints:c1.x :c1.y :c2.x :c2.y];
        [CATransaction setAnimationTimingFunction:scaleFunction];
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        scaleAnimation.toValue = [NSValue valueWithCGPoint:finalScale];
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.duration = animation_duration;
        [self.animatedView setTransform:CGAffineTransformMakeScale(finalScale.x, finalScale.y)];
        [self.animatedView.layer addAnimation:scaleAnimation forKey:@"animateViewSize"];
        
    }
    [CATransaction commit];
}

- (void)onTranslateButtonPressed:(id)sender
{
    CGPoint initialPosition = CGPointMake(130+20, 760);
    CGPoint finalPosition = CGPointMake(638, 760);
    
    [self.translateButton setEnabled:NO];
    [self.scaleButton setEnabled:NO];
    
    CGPoint c1 = self.graphView.controlPoint1;
    CGPoint c2 = self.graphView.controlPoint2;
    
    [CATransaction begin];
    {
        float animation_duration = 0.5;
        
        [CATransaction setCompletionBlock:^{
            [self performSelector:@selector(reset) withObject:nil afterDelay:0.5];
        }];
        
        CAMediaTimingFunction *translateFunction = [CAMediaTimingFunction functionWithControlPoints:c1.x :c1.y :c2.x :c2.y];
        [CATransaction setAnimationTimingFunction:translateFunction];
        
        CABasicAnimation *translateAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        translateAnimation.fromValue = [NSValue valueWithCGPoint:initialPosition];
        translateAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
        translateAnimation.fillMode = kCAFillModeForwards;
        translateAnimation.duration = animation_duration;
        [self.animatedView setCenter:finalPosition];
        [self.animatedView.layer addAnimation:translateAnimation forKey:@"animateViewPosition"];
        
    }
    [CATransaction commit];
    
}

- (void)reset
{
    CGPoint initialPosition = CGPointMake(130+20, 760);
    [self.translateButton setEnabled:YES];
    [self.scaleButton setEnabled:YES];
    [self.animatedView setCenter:initialPosition];
    [self.animatedView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
}

@end
