//
//  UserInfoViewController.m
//  iBirds
//
//  Created by Samuel Westrich on 9/27/11.
//  Copyright (c) 2011 ADYLITICA. All rights reserved.
//

#import "UserInfoViewController.h"
#import "TextInputCell.h"
#import "AppDelegate.h"


#define NAMESTABLE 0

#define FIRSTNAMEROW 0
#define LASTNAMEROW 1

#define BIRDSECTION 0
#define BIRDNAMEROW 0
#define EMAILROW 1

#define _defaultFirstNameLabel @"John"
#define _defaultLastNameLabel @"Doe"
#define _defaultBirdNameLabel @"My bird's name"
#define _defaultEmailAdress @"JohnDoe@apple.com"
#define _defaultPassword @"Password"

@interface UserInfoViewController() 

@property(nonatomic,retain) UITableView * namesTableView;
@property(nonatomic,retain) UITableView * tableView;
@property(nonatomic,retain) User * currentUser;
@property(nonatomic,retain) Bird * currentBird;

@end

@implementation UserInfoViewController

@synthesize tableView;
@synthesize namesTableView;
@synthesize currentUser;
@synthesize currentBird;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    [namesTableView release];
    [tableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundCreateBirds.png"]]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)configureCell:(TextInputCell *)cell withTableView:(UITableView*)lTableView atIndexPath:(NSIndexPath *)indexPath {
    
    UITextField * textField = [cell textField];
    [textField setDelegate:self];
    switch (lTableView.tag) {
        case NAMESTABLE:
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
            }
            break;
            
        default:break;
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

#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)lTableView
{
    switch (lTableView.tag) {
        case 0:
            return 1;
            break;
            
        default:
            return 2;
            break;
    }
}

- (NSInteger)tableView:(UITableView *)lTableView numberOfRowsInSection:(NSInteger)section
{
    switch (lTableView.tag) {
        case 0:
            return 2;
            break;
            
        default:
            if (section) return 4;
            else return 1;
            break;
    }

}

- (UITableViewCell *)tableView:(UITableView *)lTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [lTableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
	/*		switch (indexPath.section) {
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
                        case PASSWORDROW:			
                            [currentUser setPassword:[textField text]];
                            [self validateEntry];
                            break;
                    }
                    break;
			}*/
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
/*    switch (indexPath.section) {
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
                case PASSWORDROW:			
                    [self.tableView reloadData];
                    [self tableView:lTableView didSelectKeyboardInputRowAtIndexPath:indexPath];
                    break;
            }
            break;
    }*/
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
 /*           switch (indexPath.section) {
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
                        case PASSWORDROW:			
                            [currentUser setPassword:string];
                            [self validateEntry];
                            break;
                    }
                    break;
            }*/
		}
		return TRUE;
	}
    NSIndexPath * indexPath = [self.tableView indexPathForCell:((AdyCellTextField*)textField).cell];
    NSString * string2 = [NSString stringWithFormat:@"%@%@",[textField text],string];
/*    switch (indexPath.section) {
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
                case PASSWORDROW:			
                    [currentUser setPassword:string2];
                    [self validateEntry];
                    break;
            }
            break;
    }*/
    
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
/*    switch (lTableView.tag) {
        case NAMESTABLE:
            switch (indexPath.row) {
                case FIRSTNAMEROW:
                    [self tableView:self.namesTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:LASTNAMEROW inSection:0]];
                    break;
                case LASTNAMEROW:
                    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:BIRDNAMEROW inSection:BIRDSECTION]];
                    break;
            }
        default:
            switch (indexPath.se) {
            [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:BIRDSECTION + 1]];
            break;
        case NAMESSECTION:

                case EMAILROW:
                    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:PASSWORDROW inSection:NAMESSECTION]];
                    break;
            }
            break;
    }*/
	return YES;
	
}


@end
