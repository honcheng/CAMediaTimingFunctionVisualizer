//
//  EasingCurveSelectorViewController.m
//  CAMediaTimingFunctionVisualizer
//
//  Created by honcheng on 6/1/13.
//  Copyright (c) 2013 Hon Cheng Muh. All rights reserved.
//

#import "EasingCurveSelectorViewController.h"
#import "KKCustomMediaTimingFunction.h"

@interface EasingCurveSelectorViewController ()

@end

@implementation EasingCurveSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self easingCurveArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *curveName = [[self easingCurveArray] objectAtIndex:indexPath.row];
    [cell.textLabel setText:curveName];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(easingCurveSelector:didSelectCurve:controlPoints:)])
    {
        NSArray *curveArray = [KKCustomMediaTimingFunction curveArrayForEasingCurve:(1 << indexPath.row)];
        NSString *curveName = [[self easingCurveArray] objectAtIndex:indexPath.row];
        [self.delegate easingCurveSelector:self didSelectCurve:curveName controlPoints:curveArray];
    }
}


/**
 * List of custom easing curve
 * from https://github.com/KinkumaDesign/CustomMediaTimingFunction
 */

- (NSArray *)easingCurveArray
{
    return @[
    @"Linear",
    
    @"EaseInSine",
    @"EaseOutSine",
    @"EaseInOutSine",
    @"EaseOutInSine",
    
    @"EaseInQuad",
    @"EaseOutQuad",
    @"EaseInOutQuad",
    @"EaseOutInQuad",
    
    @"EaseInCubic",
    @"EaseOutCubic",
    @"EaseInOutCubic",
    @"EaseOutInCubic",
    
    @"EaseInQuart",
    @"EaseOutQuart",
    @"EaseInOutQuart",
    @"EaseOutInQuart",
    
    @"EaseInQuint",
    @"EaseOutQuint",
    @"EaseInOutQuint",
    
    @"EaseOutInQuint",
    
    @"EaseInExpo",
    @"EaseOutExpo",
    @"EaseInOutExpo",
    @"EaseOutInExpo",
    
    @"EaseInCirc",
    @"EaseOutCirc",
    @"EaseInOutCirc",
    @"EaseOutInCirc",
    ];
}

@end
