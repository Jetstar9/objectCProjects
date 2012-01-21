//
//  ViewController.h
//  PGA Magazine
//
//  Created by Derek Smith on 1/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController  {

    
    
    NSMutableArray *pgaTopicList;
    NSNumber *selectedRow;
    NSNumber *selectedSection;

}

//Methods
//- (int)getRow;
//- (void)setRow:(int)value;


@property (nonatomic, retain) NSMutableArray *pgaTopicList;
@property (nonatomic, retain) NSNumber *selectedRow;
@property (nonatomic, retain) NSNumber *selectedSection;



@end
