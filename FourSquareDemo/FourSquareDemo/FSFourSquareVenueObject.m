//
//  FSFourSquareVenueObject.m
//  FourSquareDemo
//
//  Created by Bhanu Birani on 27/02/14.
//  Copyright (c) 2014 Inkoniq IT Solutions. All rights reserved.
//

#import "FSFourSquareVenueObject.h"

@implementation FSFourSquareVenueObject

- (id)initWithFourSquareDictionary:(NSDictionary *)dict {
    if ((self = [super init])) {
        self.locationId = [dict objectForKey:@"id"];
        self.locationName = [dict objectForKey:@"name"];
        self.locationLat = [NSNumber numberWithFloat:[[[dict objectForKey:@"location"] objectForKey:@"lat"] floatValue]];
        self.locationLong = [NSNumber numberWithFloat:[[[dict objectForKey:@"location"] objectForKey:@"lng"] floatValue]];
        self.locationAddress = [[dict objectForKey:@"location"] objectForKey:@"address"];
        self.locationRatings = [NSNumber numberWithFloat:0.0f];
        self.locationDistance = [NSNumber numberWithFloat:[[[dict objectForKey:@"location"] objectForKey:@"distance"]floatValue] / 1000];
    }
    return self;
}

@end
