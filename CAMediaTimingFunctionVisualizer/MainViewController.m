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
@property (nonatomic, weak) UIButton *animateButton;
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
    
    UIButton *animateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [animateButton setFrame:CGRectMake( ([self.view bounds].size.width-80)/2, [self.view bounds].size.height-80, 80, 40)];
    [animateButton setTitle:@"Start" forState:UIControlStateNormal];
    [animateButton setTitle:@"Reset" forState:UIControlStateSelected];
    [self.view addSubview:animateButton];
    [animateButton addTarget:self action:@selector(onTestButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.animateButton = animateButton;

    UIView *animatedView = [[UIView alloc] initWithFrame:CGRectMake(graphView.frame.origin.x, graphView.frame.origin.y+graphView.frame.size.height+50+80, 180,180)];
    [animatedView setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:animatedView];
    self.animatedView = animatedView;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (void)onTestButtonPressed:(id)sender
{
    CGPoint initialPosition = CGPointMake(130, 760);
    CGPoint finalPosition = CGPointMake(638, 760);
    if ([sender isSelected])
    {
        [sender setSelected:NO];
        [self.animatedView setCenter:initialPosition];
    }
    else
    {
        [sender setEnabled:NO];

        CGPoint c1 = self.graphView.controlPoint1;
        CGPoint c2 = self.graphView.controlPoint2;
        
        [CATransaction begin];
        {
            float animation_duration = 0.3;
            
            [CATransaction setCompletionBlock:^{
                [sender setEnabled:YES];
                [sender setSelected:YES];
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
    
}

@end
