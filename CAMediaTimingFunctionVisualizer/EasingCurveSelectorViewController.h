//
//  EasingCurveSelectorViewController.h
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 6/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EasingCurveSelectorViewControllerDelegate <NSObject>
- (void)easingCurveSelector:(id)selector didSelectCurve:(NSString*)curveName controlPoints:(NSArray*)controlPoints;
@end

@interface EasingCurveSelectorViewController : UITableViewController
@property (nonatomic, weak) id<EasingCurveSelectorViewControllerDelegate> delegate;
@end
