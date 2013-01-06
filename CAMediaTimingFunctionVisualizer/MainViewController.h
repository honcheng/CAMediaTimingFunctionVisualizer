//
//  MainViewController.h
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 5/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EasingCurveSelectorViewController.h"
#import "CubicBezierCurveView.h"

@interface MainViewController : UIViewController <EasingCurveSelectorViewControllerDelegate, CubicBezierCurveViewDelegate>

@end
