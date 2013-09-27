//
//  BirdParser.h
//  iBirds
//
//  Created by Samuel Westrich on 10/12/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "JSONParser.h"
#import "User.h"
#import <CoreLocation/CoreLocation.h>

@interface BirdParser : JSONParser {
	User * user;
    Bird * bird;
    NSArray * topKeysToAdd;
    NSNumber * baseLocation_lat;
    NSNumber * baseLocation_lon;
}

@property (nonatomic,retain) User * user;
@property (nonatomic,retain) Bird * bird;
@property (nonatomic,retain) NSArray * topKeysToAdd;
@property (nonatomic,retain) NSNumber * baseLocation_lat;
@property (nonatomic,retain) NSNumber * baseLocation_lon;


@end
