//
//  FSViewController.m
//  FourSquareDemo
//
//  Created by Bhanu Birani on 26/02/14.
//  Copyright (c) 2014 Inkoniq IT Solutions. All rights reserved.
//

#import "FSViewController.h"
#import "FSFourSquareVenueSearchHelper.h"
#import "FSFourSquareVenueObject.h"

@interface FSViewController () <FSFourSquareVenueSearchDelegate>

@end

@implementation FSViewController

#pragma mark View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ButtonActions

- (IBAction)updateLocationButtonAction:(id)sender
{
    [[FSFourSquareVenueSearchHelper sharedInstance] setDelegate:self];
    [[FSFourSquareVenueSearchHelper sharedInstance] restartLocationServices];
    [self.activity startAnimating];
    self.locationLabel.text = @"";
}

- (void)userLocationServicesFailed:(FSLocationManagerErrorType)error
{
    [self.activity stopAnimating];
    self.locationLabel.text = @"Failed";
}

- (void)userLocationUpdated:(CLLocation *)userLocation
{
    [self.activity stopAnimating];
    self.locationLabel.text = [NSString stringWithFormat:@"%.1f, %.1f", userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    
    [[FSFourSquareVenueSearchHelper sharedInstance] getVenueInformationForText:@"juice" withSuccess:^(NSArray *array) {
        NSLog(@"____________");
        for (FSFourSquareVenueObject *object in array) {
            NSLog(@"%@", object.locationName);
        }
        NSLog(@"____________");
    } andFailure:^(NSError *error) {
        
    }];
}




@end
