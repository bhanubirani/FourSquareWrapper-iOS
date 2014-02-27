//
//  FSFourSquareVenueObject.h
//  FourSquareDemo
//
//  Created by Bhanu Birani on 27/02/14.
//  Copyright (c) 2014 Inkoniq IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFourSquareVenueObject : NSObject

@property (nonatomic, strong)   NSString *locationId;
@property (nonatomic, strong)   NSString *locationName;
@property (nonatomic, strong)   NSNumber *locationLat;
@property (nonatomic, strong)   NSNumber *locationLong;
@property (nonatomic, strong)   NSString *locationCreator;
@property (nonatomic, strong)   NSString *locationType;
@property (nonatomic, strong)   NSNumber *locationVisitedCount;
@property (nonatomic, strong)   NSNumber *locationRatings;
@property (nonatomic, strong)   NSString *locationAddress;
@property (nonatomic, strong)   NSNumber *locationDistance;

- (id)initWithFourSquareDictionary:(NSDictionary *)dict;

@end
