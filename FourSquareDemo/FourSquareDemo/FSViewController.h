//
//  FSViewController.h
//  FourSquareDemo
//
//  Created by Bhanu Birani on 26/02/14.
//  Copyright (c) 2014 Inkoniq IT Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activity;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;

@end
