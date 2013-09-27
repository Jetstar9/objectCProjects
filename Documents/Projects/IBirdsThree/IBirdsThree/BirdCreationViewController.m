 //
//  BirdCreationViewController.m
//  iBirds
//
//  Created by Samuel Westrich on 9/19/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "BirdCreationViewController.h"
#import "TextInputCell.h"
#import "AppDelegate.h"
#import "IBConnector.h"
#import "Utils.h"
#import "IBNavigationBarButtonItem.h"
#import "BirdGatheringViewController.h"
#import "NetworkNotifications.h"
#import "UserLocationManager.h"
#import "IBDataStore.h"
#import "Environment.h"

#define BIRDSECTION 0
#define NAMESSECTION 1
#define FIRSTNAMEROW 0
#define LASTNAMEROW 1
#define EMAILROW 2

#define _defaultFirstNameLabel @"John"
#define _defaultLastNameLabel @"Doe"
#define _defaultBirdNameLabel @"My bird's name"
#define _defaultEmailAdress @"JohnDoe@apple.com"

@interface BirdCreationViewController()
    
- (void)configureCell:(TextInputCell *)cell withTableView:(UITableView*)lTableView atIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath*)indexPathFromPosition;
-(void)birdRegistered:(NSNotification*)notification;
@property(nonatomic,retain) User * currentUser;
@property(nonatomic,retain) Bird * currentBird;
@end

@implementation BirdCreationViewController

@synthesize currentUser;
@synthesize currentBird;
@synthesize tempRightButton;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSManagedObjectContext * context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
        self.currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" 
                                                         inManagedObjectContext:context];
        self.currentBird = [NSEntityDescription insertNewObjectForEntityForName:@"Bird" 
                                                         inManagedObjectContext:context];
        needsCreation = TRUE;
        [UserLocationManager sharedInstance];
        
    }
    return self;
}
                       
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSUbiquitousKeyValueStore * store = [NSUbiquitousKeyValueStore defaultStore];
        NSString * cloudPassword = [store stringForKey:@"cloudPassword"];
        
        if (!cloudPassword) {
            NSLog(@"NEW ID");
            cloudPassword = [Utils createId];
            [store setString:cloudPassword forKey:@"cloudPassword"];
        }
        self.currentUser.cloudPassword = cloudPassword;
        
        NSString * email = [store stringForKey:@"email"];
        NSManagedObjectContext * context = [((AppDelegate*)[UIApplication sharedApplication].delegate) managedObjectContext];
        if (email) {
            needsCreation = FALSE;
            self.tempRightButton = self.navigationItem.rightBarButtonItem;
            self.navigationItem.rightBarButtonItem = [[IBNavigationBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(logIn)];
            self.currentUser = [[IBDataStore sharedInstance] userWithEmail:email];
            
            if (!self.currentUser) {
                needsCreation = TRUE;
                self.currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" 
                                                                 inManagedObjectContext:context];
                self.currentUser.email = email;
            }
            
            NSArray * birds = [[store stringForKey:@"birdIds"] componentsSeparatedByString:@";"];
            NSString * birdId;
            if ([birds count]) {
                birdId = [birds objectAtIndex:0];
                self.currentBird = [[IBDataStore sharedInstance] birdWithId:birdId];
                
                if (!self.currentBird) {
                    self.currentBird = [NSEntityDescription insertNewObjectForEntityForName:@"Bird" 
                                                                     inManagedObjectContext:context];
                }
            } else {
                self.currentBird = [NSEntityDescription insertNewObjectForEntityForName:@"Bird" 
                                                                 inManagedObjectContext:context];
            }
            
        } else {

        

            self.currentUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" 
                                                            inManagedObjectContext:context];
            self.currentBird = [NSEntityDescription insertNewObjectForEntityForName:@"Bird" 
                                                    inManagedObjectContext:context];
            needsCreation = TRUE;
        }
        
        [UserLocationManager sharedInstance];
       
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc {
    [currentUser release];
    [currentBird release];
    [tempRightButton release];
    [super dealloc];
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCreateBirds.png"]]];
    if (needsCreation)
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(wrongLogin:)
												 name:n_WrongCredentials object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(createBird:)
												 name:n_UserRegistered object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(birdRegistered:)
												 name:n_BirdRegistered object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(checkBird:)
												 name:n_UserConnected object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(birdRegistered:)
												 name:n_BirdInfoReceived object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)configureCell:(TextInputCell *)cell withTableView:(UITableView*)lTableView atIndexPath:(NSIndexPath *)indexPath {
    UITextField * textField = [cell textField];
    [textField setDelegate:self];
    if (needsCreation) {
    switch (indexPath.section) {
        case BIRDSECTION:
            cell.textLabel.text = @"Bird Name";
            if (currentBird.name) {
                cell.textField.text = currentBird.name; 
            } else {
                cell.textField.text = @"";
                cell.textField.placeholder = _defaultBirdNameLabel;
            }
            [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
            [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            [textField setKeyboardType:UIKeyboardTypeNamePhonePad];

            break;
            
        case NAMESSECTION:
            switch (indexPath.row) {
                case FIRSTNAMEROW:
                    
                    cell.textLabel.text = @"First Name";
                    if (currentUser.firstName) {
                        cell.textField.text = currentUser.firstName; 
                    } else {
                        cell.textField.text = @"";
                        cell.textField.placeholder = _defaultFirstNameLabel;
                    }
                    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
                    [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                    [textField setKeyboardType:UIKeyboardTypeNamePhonePad];
                    break;
                case LASTNAMEROW:			
                    cell.textLabel.text = @"Last Name";
                    if (currentUser.lastName) {
                        cell.textField.text = currentUser.lastName; 
                    } else {
                        cell.textField.text = @"";
                        cell.textField.placeholder = _defaultLastNameLabel;


                    }
                    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
                    [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
                    [textField setKeyboardType:UIKeyboardTypeNamePhonePad];
                    break;
                case EMAILROW:
                    cell.textLabel.text = @"Email";
                    if (currentUser.email) {
                        cell.textField.text = currentUser.email; 
                    } else {
                        cell.textField.text = @"";
                        cell.textField.placeholder = _defaultEmailAdress;
                        
                        
                    }
                    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
                    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
                    [textField setKeyboardType:UIKeyboardTypeEmailAddress];
                    break;
                    
            }
            break;
    }
    } else {
        cell.textLabel.text = @"Email";
        if (currentUser.email) {
            cell.textField.text = currentUser.email; 
        } else {
            cell.textField.text = @"";
            cell.textField.placeholder = _defaultEmailAdress;
            
            
        }
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [textField setKeyboardType:UIKeyboardTypeEmailAddress];
    }
	if (cell != nil) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	
	
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) return [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 12)] autorelease];
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) return 12;
    else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 12)];
    [label setBackgroundColor:[UIColor clearColor]];
    label.textColor = [UIColor colorWithWhite:0.71 alpha:1.0];
    label.font = [UIFont fontWithName:@"GillSans" size:17];
    label.textAlignment = UITextAlignmentCenter;
    [label setText:@"We will use your iCloud for your login"];
    if (section == 1) return  [label autorelease];
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) return 40;
    else return 0;
}


#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
if (needsCreation)
    // Return the number of sections.
    return 2;
else return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (needsCreation) {
    // Return the number of rows in the section.
    if (section) return 3;
    else return 1;
    } else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TextInputCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier hasTextField:TRUE isForNumbers:FALSE] autorelease];
    }
    
    [self configureCell:(TextInputCell*)cell withTableView:tableView atIndexPath:indexPath];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(void)isSwitchingFromPos:(int)pos1 toPos:(int)pos2 {
	if (pos1 == -1) {
		transientSwitchType = eLoginSwitchingTypeUndefined;
		return;
	} else {
        transientSwitchType = eLoginSwitchingTypeRealToReal;
	}
}

-(NSIndexPath*)indexPathFromPosition{
    int sectionCount = [self numberOfSectionsInTableView:self.tableView];
    int remainingPositionPoints = position;
    for (int s =0;s<sectionCount;s++) {
        int rows = [self tableView:self.tableView numberOfRowsInSection:s];
        if (remainingPositionPoints < rows)
            return [NSIndexPath indexPathForRow:remainingPositionPoints inSection:s];
        else
            remainingPositionPoints -= rows;
    }
    return nil;
}

-(void)validateEntry {
	if ((self.currentUser.firstName != nil)
		&& (self.currentUser.lastName != nil)
        && (self.currentUser.email != nil)
        && (self.currentBird.name != nil))
		self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void)exitTextFieldWithHideKeyboard:(BOOL)hideKB {
	if (position == -1) {
		return;
	}
    NSIndexPath * indexPath = [self indexPathFromPosition];
    if (!indexPath) return;
	//NSUInteger indexArr[] = {0,position};
	TextInputCell * cell = (TextInputCell *)[self.tableView cellForRowAtIndexPath:indexPath];
	UITextField * textField = (UITextField *)[cell textField];
	if ([textField isFirstResponder]) {
		if (![[textField text] isEqualToString:@""]) {
            NSIndexPath * indexPath = [self indexPathFromPosition];
			switch (indexPath.section) {
                    case BIRDSECTION:
                    [currentBird setName:[textField text]];
					[self validateEntry];
                    break;
                    case NAMESSECTION:
                    switch (indexPath.row) {
				case LASTNAMEROW:
					[currentUser setLastName:[textField text]];
					[self validateEntry];
					break;
				case FIRSTNAMEROW:			
					[currentUser setFirstName:[textField text]];
					[self validateEntry];
					break;
                        case EMAILROW:			
                            [currentUser setEmail:[textField text]];
                            [self validateEntry];
                            break;
                    }
                    break;
			}
		}
		[textField resignFirstResponder];
	}
}
- (void)tableView:(UITableView *)ltableView didSelectKeyboardInputRowAtIndexPath:(NSIndexPath *)indexPath {
    TextInputCell *cell = (TextInputCell*)[ltableView cellForRowAtIndexPath:indexPath];
    UILabel *detailLabel = [cell detailTextLabel];
    detailLabel.text = nil;
    [[cell textField] becomeFirstResponder];
    [ltableView setNeedsDisplay];
	if (position == -1) return;
}

- (void)tableView:(UITableView *)ltableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = [ltableView cellForRowAtIndexPath:indexPath];
    UITextField *tmpView = (UITextField *) cell.accessoryView;
    UILabel *llabel = [cell detailTextLabel];
	
    llabel.text = tmpView.text; 
    cell.accessoryView = nil;
	
    [ltableView setNeedsDisplay];
}

    - (void)tableView:(UITableView *)lTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        [self isSwitchingFromPos:position toPos:indexPath.row];
        [self exitTextFieldWithHideKeyboard:TRUE];
        position = indexPath.row;
        switch (indexPath.section) {
            case BIRDSECTION:
                [self.tableView reloadData];
                [self tableView:lTableView didSelectKeyboardInputRowAtIndexPath:indexPath];
                break;
            case NAMESSECTION:
                switch (indexPath.row) {
                    case LASTNAMEROW:
                        [self.tableView reloadData];
                        [self tableView:lTableView didSelectKeyboardInputRowAtIndexPath:indexPath];
                        break;
                    case FIRSTNAMEROW:			
                        [self.tableView reloadData];
                        [self tableView:lTableView didSelectKeyboardInputRowAtIndexPath:indexPath];
                        break;
                    case EMAILROW:			
                        [self.tableView reloadData];
                        [self tableView:lTableView didSelectKeyboardInputRowAtIndexPath:indexPath];
                        break;
                }
                break;
        }
        [lTableView deselectRowAtIndexPath:indexPath animated:YES];
    }

#pragma mark UITextField Delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	//NSString * initString;
	//if (textField
	//[textField text]
	if ([string length] == 0) {
		NSString * string;
		if ( [[textField text] length] > 0 ) { 
			string = [[textField text] substringToIndex:[[textField text] length] - 1];
            NSIndexPath * indexPath = [self.tableView indexPathForCell:((AdyCellTextField*)textField).cell];
            switch (indexPath.section) {
                case BIRDSECTION:
                    [currentBird setName:string];
                    break;
                case NAMESSECTION:
                    switch (indexPath.row) {
                        case LASTNAMEROW:
                            [currentUser setLastName:string];
                            [self validateEntry];
                            break;
                        case FIRSTNAMEROW:			
                            [currentUser setFirstName:string];
                            [self validateEntry];
                            break;
                        case EMAILROW:			
                            [currentUser setEmail:string];
                            [self validateEntry];
                            break;
                    }
                    break;
            }
		}
		return TRUE;
	}
    NSIndexPath * indexPath = [self.tableView indexPathForCell:((AdyCellTextField*)textField).cell];
    NSString * string2 = [NSString stringWithFormat:@"%@%@",[textField text],string];
    switch (indexPath.section) {
        case BIRDSECTION:
            [currentBird setName:string2];
            break;
        case NAMESSECTION:
            switch (indexPath.row) {
                case LASTNAMEROW:
                    [currentUser setLastName:string2];
                    [self validateEntry];
                    break;
                case FIRSTNAMEROW:			
                    [currentUser setFirstName:string2];
                    [self validateEntry];
                    break;
                case EMAILROW:			
                    [currentUser setEmail:string2];
                    [self validateEntry];
                    break;
            }
            break;
    }

	return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	NSString *content = textField.text;
	
	if([content length] !=0){
        
	}
	[self validateEntry];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSIndexPath * indexPath = [self.tableView indexPathForCell:((AdyCellTextField*)textField).cell];
    switch (indexPath.section) {
        case BIRDSECTION:
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:BIRDSECTION + 1]];
            break;
        case NAMESSECTION:
            switch (indexPath.row) {
                case FIRSTNAMEROW:
                    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:LASTNAMEROW inSection:NAMESSECTION]];
                    break;
                case LASTNAMEROW:
                    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:EMAILROW inSection:NAMESSECTION]];
                    break;
                case EMAILROW:
                    [self hasBeenValidatedByButtonWithIdentifier:nil];
                    break;
            }
            break;
    }
	return YES;
	
}


-(IBAction)createBird:(id)sender {
    [self.currentBird setLocation:[[UserLocationManager sharedInstance] currentLocation]];
    IBConnector * connector = [IBConnector sharedInstance];
    [connector createBird:self.currentBird forUser:self.currentUser];
}

-(void)logIn {
    IBConnector * connector = [IBConnector sharedInstance];
    [connector refreshBird:self.currentBird forUser:self.currentUser];
}

-(void)wrongLogin:(NSNotification*)notification {
    needsCreation = TRUE;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = self.tempRightButton;
}

-(void)birdRegistered:(NSNotification*)notification {
    [[IBDataStore sharedInstance] saveContext];
    NSDictionary * userInfo = [notification userInfo];
    Bird * bird = [[userInfo objectForKey:@"birds"] objectAtIndex:0];
    if (!bird) bird = currentBird;
    NSUbiquitousKeyValueStore * store = [NSUbiquitousKeyValueStore defaultStore];
    [store setString:bird.birdId forKey:@"birdIds"];
    [[Environment sharedInstance] setCurrentBird:bird]; //should be the same as self.currentBird but this is more safe
    [[Environment sharedInstance] setCurrentUser:self.currentUser];
    {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    BirdGatheringViewController * dController = [storyboard instantiateViewControllerWithIdentifier:@"BirdGatheringViewController"];
    dController.navigationItem.hidesBackButton = YES;
    [self.navigationController pushViewController:dController animated:TRUE];
    }
}

-(void)checkBird:(NSNotification*)notification {
    IBConnector * connector = [IBConnector sharedInstance];
    [connector refreshBird:self.currentBird forUser:self.currentUser];
}

#pragma mark --
#pragma mark BirdViewController protocol methods

-(BOOL)needsNetworkValidation {
    return TRUE;
}



-(void)hasBeenValidatedByButtonWithIdentifier:(NSString*)identifier {
    
    self.currentBird.location = [[UserLocationManager sharedInstance] currentLocation];
    
    NSUbiquitousKeyValueStore * store = [NSUbiquitousKeyValueStore defaultStore];
    NSString * cloudPassword = [store stringForKey:@"cloudPassword"];
    
    if (!cloudPassword) {
        NSLog(@"NEW ID");
        cloudPassword = [Utils createId];
        [store setString:cloudPassword forKey:@"cloudPassword"];
    }
    self.currentUser.cloudPassword = cloudPassword;
    
    [store setString:self.currentUser.email forKey:@"email"];
    
    IBConnector * connector = [IBConnector sharedInstance];
    [connector registerUser:self.currentUser];
}

@end
