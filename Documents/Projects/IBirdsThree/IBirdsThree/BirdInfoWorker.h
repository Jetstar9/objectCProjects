//
//  BirdInfoWorker.h
//  iBirds
//
//  Created by Samuel Westrich on 10/12/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BasicWorker.h"
#import "Bird.h"

@interface BirdInfoWorker : BasicWorker{
    Bird * bird;
}

@property (nonatomic,retain) Bird * bird;

@end
