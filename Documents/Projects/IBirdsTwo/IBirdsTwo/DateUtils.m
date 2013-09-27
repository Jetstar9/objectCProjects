//
//  DateUtils.m
//  iBirds
//
//  Created by Samuel Westrich on 10/11/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+(NSDate*)getDateFromTimeStamp:(id)string {
	NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:([string floatValue] /1000.0)];
	return currentDate;
}

@end
