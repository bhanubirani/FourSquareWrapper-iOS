//
//  FSFourSquareVenueSearchHelper.m
//  FourSquareDemo
//
//  Created by Bhanu Birani on 27/02/14.
//  Copyright (c) 2014 Inkoniq IT Solutions. All rights reserved.
//

#import "FSFourSquareVenueSearchHelper.h"
#import "FSFourSquareVenueObject.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#define kFourSquareVenueAPI @"https://api.foursquare.com/v2/venues/search?client_id=RGIWRQR2FN02A3PN03HW2FEGESVGCUBTGMDEW4DXQPLLHB4D&client_secret=IIJSOUL1R1CH0VJWPM44ZD0FPSMMJ0IIJIVXXX4W2NWNIXWC"

#define kFourSquareCategoryAPI @"https://api.foursquare.com/v2/venues/categories?client_id=RGIWRQR2FN02A3PN03HW2FEGESVGCUBTGMDEW4DXQPLLHB4D&client_secret=IIJSOUL1R1CH0VJWPM44ZD0FPSMMJ0IIJIVXXX4W2NWNIXWC"

static FSFourSquareVenueSearchHelper *fourSquareHelper;

@interface FSFourSquareVenueSearchHelper ()

- (void)restartLocationServices;

@end

@implementation FSFourSquareVenueSearchHelper

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fourSquareHelper = [[FSFourSquareVenueSearchHelper alloc] init];
    });
    
    return fourSquareHelper;
}

- (NSString *)getFourSquareFormatDate
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    return  [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:[NSDate date]]];
}

- (void)getVenueInformationForText:(NSString *)textString withSuccess:(SuccessBlock) success andFailure:(FailureBlock) failure
{
    CLLocationCoordinate2D userLocationCoordinate = currentLocation.coordinate;
    
    /*
     NSString *fourSquareAPI = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=12.913636,77.651694&categoryId=4d4b7105d754a06374d81259&query=%@&v=20130710&client_id=RGIWRQR2FN02A3PN03HW2FEGESVGCUBTGMDEW4DXQPLLHB4D&client_secret=IIJSOUL1R1CH0VJWPM44ZD0FPSMMJ0IIJIVXXX4W2NWNIXWC",textString];
     
     NSString *fourSquareAPI = [NSString stringWithFormat:@"%@&ll=%f,%f&categoryId=%@&query=%@&v=%@&limit=10",kFourSquareVenueAPI, userLocationCoordinate.latitude, userLocationCoordinate.longitude, [self getCategoryIdForEventType:eventType],textString,[[NSDate date] getFourSquareFormatDate]];
     */

    NSString *fourSquareAPI = [NSString stringWithFormat:@"%@&ll=%f,%f&query=%@&v=%@", kFourSquareVenueAPI, userLocationCoordinate.latitude, userLocationCoordinate.longitude, textString, [self getFourSquareFormatDate]];
    
    NSLog(@"%@", fourSquareAPI);
    
    dispatch_async(kBgQueue, ^{
        
        NSData* responseData = [NSData dataWithContentsOfURL: [NSURL URLWithString:fourSquareAPI]];
        NSError* error;
        
        if ([responseData length] <= 0) {
            failure([NSError errorWithDomain:@"NoData" code:404 userInfo:nil]);
            return;
        }
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions
                                                               error:&error];
        
        if (error == nil) {
            NSArray *venueArray = [[json objectForKey:@"response"] objectForKey:@"venues"];
            NSMutableArray *locationArray = [[NSMutableArray alloc] initWithCapacity:[venueArray count]];
            for (NSDictionary *eachVenue in venueArray) {
                FSFourSquareVenueObject *location = [[FSFourSquareVenueObject alloc] initWithFourSquareDictionary:eachVenue];
                [locationArray addObject:location];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                success((NSArray *)locationArray);
            });
        }
        else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                failure(error);
            });
        }
    });

}

#pragma mark Location methods

- (void)startLocationServices
{
    if (!locationMan)
        locationMan = [[CLLocationManager alloc] init];
	[locationMan setDelegate:self];
	[locationMan setDesiredAccuracy:kCLLocationAccuracyBest];
	[locationMan startUpdatingLocation];
}

- (void)stopLocationServices
{
	[locationMan stopUpdatingLocation];
	locationMan = nil;
}

- (void)restartLocationServices
{
    [self startLocationServices];
}

- (CLLocation *)currentLocation
{
    return currentLocation;
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self stopLocationServices];
    currentLocation = nil;
    FSLocationManagerErrorType errorType;
    switch ([error code]) {
        case kCLErrorNetwork: {
            errorType = ErrorTypeGeneral;
            break;
        }
        case kCLErrorDenied: {
            errorType = ErrorTypeDenied;
            break;
        }
        case kCLErrorLocationUnknown: {
            errorType = ErrorTypeUnknown;
            break;
        }
        default:{
            errorType = ErrorTypeOther;
            break;
        }
    }

    if ([self.delegate respondsToSelector:@selector(userLocationServicesFailed:)]) {
        [self.delegate userLocationServicesFailed:errorType];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationMan stopUpdatingLocation];
    if (!currentLocation)
        currentLocation = [[CLLocation alloc] init];
    currentLocation = newLocation;
    
    if ([self.delegate respondsToSelector:@selector(userLocationUpdated:)]) {
        [self.delegate userLocationUpdated:newLocation];
    }
}

@end
