//
//  MainViewController.m
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 5/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()
@property (nonatomic, weak) CubicBezierCurveView *graphView;
@property (nonatomic, weak) ControlPoint *animatedView;
@property (nonatomic, weak) UIButton *translateButton, *scaleButton;
@property (nonatomic, weak) UIButton *easingCurveButton;
@property (nonatomic, strong) UIPopoverController *easingCurveSelectorPopoverController;
@property (nonatomic, weak) UILabel *functionLabel;
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
    [graphView setDelegate:self];
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
    
    UIButton *easingCurveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [easingCurveButton setFrame:CGRectMake(40, graphView.frame.origin.y+graphView.frame.size.height+20, 200, 40)];
    [easingCurveButton setTitle:@"Custom Curve" forState:UIControlStateNormal];
    [self.view addSubview:easingCurveButton];
    [easingCurveButton addTarget:self action:@selector(onEasingCurveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.easingCurveButton = easingCurveButton;
    
    UILabel *functionLabel = [[UILabel alloc] initWithFrame:CGRectMake(easingCurveButton.frame.origin.x+easingCurveButton.frame.size.width+20, easingCurveButton.frame.origin.y, 480, easingCurveButton.frame.size.height)];
    [functionLabel setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:functionLabel];
    self.functionLabel = functionLabel;
    [self fillFunctionLabel];

    ControlPoint *animatedView = [[ControlPoint alloc] initWithFrame:CGRectMake(graphView.frame.origin.x+40, graphView.frame.origin.y+graphView.frame.size.height+50+80, 180,180)];
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
        float animation_duration = 1.0;
        
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

- (void)fillFunctionLabel
{
    NSString *function = [NSString stringWithFormat:@"[CAMediaTimingFunction functionWithControlPoints:%.3f :%.3f :%.3f :%.3f]",
                          self.graphView.controlPoint1.x,
                          self.graphView.controlPoint1.y,
                          self.graphView.controlPoint2.x,
                          self.graphView.controlPoint2.y];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:function];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(48, [function length]-49)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(48, [function length]-49)];
    [self.functionLabel setAttributedText:attributedString];
}

#pragma mark EasingCurveSelector, based on https://github.com/KinkumaDesign/CustomMediaTimingFunction

- (void)onEasingCurveButtonPressed:(UIButton*)sender
{
    if (!self.easingCurveSelectorPopoverController)
    {
        EasingCurveSelectorViewController *selector = [[EasingCurveSelectorViewController alloc] initWithStyle:UITableViewStylePlain];
        self.easingCurveSelectorPopoverController = [[UIPopoverController alloc] initWithContentViewController:selector];
        [selector setDelegate:self];
    }
    [self.easingCurveSelectorPopoverController presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)easingCurveSelector:(EasingCurveSelectorViewController*)selector didSelectCurve:(NSString*)curveName controlPoints:(NSArray*)controlPoints
{
    [self.easingCurveButton setTitle:curveName forState:UIControlStateNormal];
    CGPoint controlPoint1 = CGPointMake([controlPoints[0] floatValue], [controlPoints[1] floatValue]);
    CGPoint controlPoint2 = CGPointMake([controlPoints[2] floatValue], [controlPoints[3] floatValue]);
    [self.graphView setControlPoint1:controlPoint1];
    [self.graphView setControlPoint2:controlPoint2];
    [self.graphView setNeedsDisplay];
    
    [self.easingCurveSelectorPopoverController dismissPopoverAnimated:YES];
    [self fillFunctionLabel];
}

- (void)onCurveChanged
{
    [self.easingCurveButton setTitle:@"Custom Curve" forState:UIControlStateNormal];
    [self fillFunctionLabel];
}

@end
