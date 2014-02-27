//
//  FSFourSquareVenueSearchHelper.h
//  FourSquareDemo
//
//  Created by Bhanu Birani on 27/02/14.
//  Copyright (c) 2014 Inkoniq IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SuccessBlock)(NSArray *);
typedef void(^FailureBlock)(NSError *);

typedef enum FSLocationManagerErrorType {
    ErrorTypeGeneral,
    ErrorTypeDenied,
    ErrorTypeUnknown,
    ErrorTypeOther
} FSLocationManagerErrorType;

@protocol FSFourSquareVenueSearchDelegate <NSObject>

@required
- (void)userLocationServicesFailed:(FSLocationManagerErrorType)error;

@optional
- (void)userLocationUpdated:(CLLocation *)userLocation;
- (void)locationUpdateFailed;

@end

@interface FSFourSquareVenueSearchHelper : NSObject <CLLocationManagerDelegate>
{
    CLLocation *currentLocation;
@private
	CLLocationManager  *locationMan;
}

@property (nonatomic, weak) id <FSFourSquareVenueSearchDelegate> delegate;

+ (instancetype)sharedInstance;
- (CLLocation *)currentLocation;
- (void)restartLocationServices;
- (void)getVenueInformationForText:(NSString *)textString withSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure;

@end
