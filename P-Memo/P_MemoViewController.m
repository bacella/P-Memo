//
//  P_MemoViewController.m
//  P-Memo
//
//  Created by gianni on 1/5/14.
//  Copyright (c) 2014 gianni. All rights reserved.
//

#import "P_MemoViewController.h"

// Necessary to get the lable with rounded corners
#import <QuartzCore/QuartzCore.h>

@interface P_MemoViewController ()

@end

@implementation P_MemoViewController
@synthesize buttonAsDateLabel;
@synthesize selectedDateForReminder;
@synthesize parkingInfoLabel;
@synthesize myParkingNotes;
@synthesize parkingSelector;

//@synthesize hourlyStallArray;
@synthesize hourlyStallArray;
@synthesize dailyEastStallArray;
@synthesize dailyWestStallArray;
@synthesize dailyNorthStallArray;
@synthesize longTerm1StallArray;
@synthesize longTerm2StallArray;
@synthesize longTerm3StallArray;
@synthesize longTerm4StallArray;

@synthesize lotSelection;
@synthesize stallSelection;
@synthesize lotSelected;
@synthesize stallSelected;

// CLT-Parking.plist Global Variables
@synthesize plistReminderString;
@synthesize plistMemoString;
@synthesize plistPickerViewSelectedRow0;
@synthesize plistPickerViewSelectedRow1;


#define kOFFSET_FOR_KEYBOARD 158.0

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Necessary to get the lable with rounded corners
    parkingInfoLabel.layer.cornerRadius = 7;
    parkingInfoLabel.layer.borderColor = [UIColor grayColor].CGColor;
    parkingInfoLabel.layer.borderWidth = 1.0;
    
    //
    // Reading from plist to retrieve changes
    //
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"CLT-Parking.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"CLT-Parking" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    //
    // Initialize "Notes:" text field
    //
    myParkingNotes.text = [temp objectForKey:@"note"];
    
    //
    // Initialize SetReminder button text label
    //
    if (selectedDateForReminder) {
            [buttonAsDateLabel setTitle:[[NSString alloc]initWithFormat:@"%@", selectedDateForReminder] forState:UIControlStateNormal];
    } else {
            [buttonAsDateLabel setTitle:[[NSString alloc]initWithFormat:@"%@", @"Set Reminder"] forState:UIControlStateNormal];
    }
    
    parkingSelector.delegate = self;
    parkingSelector.dataSource = self;
    
    lotSelection = [[NSArray alloc] initWithObjects:@"Hourly", @"Daily East", @"Daily West", @"Daily North",
                    @"Long Term 1", @"Long Term 2", @"Long Term 3", @"Long Term 4", nil];
    
    hourlyStallArray = [[NSArray alloc] initWithObjects:
                        @"Lev. 2 Row A",@"Lev. 2 Row B", @"Lev. 2 Row C", @"Lev. 2 Row D", @"Lev. 2 Row E", @"Lev. 2 Row F", @"Lev. 2 Row G", @"Lev. 2 Row H", @"Lev. 2 Row J", @"Lev. 2 Row K", @"Lev. 2 Row L", @"Lev. 2 Row M", @"Lev. 2 Row N", @"Lev. 2 Row P", @"Lev. 2 Row Q",
                        @"Lev. 3 Row A",@"Lev. 3 Row B", @"Lev. 3 Row C", @"Lev. 3 Row D", @"Lev. 3 Row E", @"Lev. 3 Row F", @"Lev. 3 Row G", @"Lev. 3 Row H", @"Lev. 3 Row J", @"Lev. 3 Row K", @"Lev. 3 Row L", @"Lev. 3 Row M", @"Lev. 3 Row N", @"Lev. 3 Row P", @"Lev. 3 Row Q",
                        @"Lev. 4 Row A",@"Lev. 4 Row B", @"Lev. 4 Row C", @"Lev. 4 Row D", @"Lev. 4 Row E", @"Lev. 4 Row F", @"Lev. 4 Row G", @"Lev. 4 Row H", @"Lev. 4 Row J", @"Lev. 4 Row K", @"Lev. 4 Row L", @"Lev. 4 Row M", @"Lev. 4 Row N", @"Lev. 4 Row P", @"Lev. 4 Row Q",
                        @"Lev. 5 Row A",@"Lev. 5 Row B", @"Lev. 5 Row C", @"Lev. 5 Row D", @"Lev. 5 Row E", @"Lev. 5 Row F", @"Lev. 5 Row G", @"Lev. 5 Row H", @"Lev. 5 Row J", @"Lev. 5 Row K", @"Lev. 5 Row L", @"Lev. 5 Row M", @"Lev. 5 Row N", @"Lev. 5 Row P", @"Lev. 5 Row Q",
                        @"Lev. 6 Row A",@"Lev. 6 Row B", @"Lev. 6 Row C", @"Lev. 6 Row D", @"Lev. 6 Row E", @"Lev. 6 Row F", @"Lev. 6 Row G", @"Lev. 6 Row H", @"Lev. 6 Row J", @"Lev. 6 Row K", @"Lev. 6 Row L", @"Lev. 6 Row M", @"Lev. 6 Row N", @"Lev. 6 Row P", @"Lev. 6 Row Q",
                        @"Lev. 7 Row A",@"Lev. 7 Row B", @"Lev. 7 Row C", @"Lev. 7 Row D", @"Lev. 7 Row E", @"Lev. 7 Row F", @"Lev. 7 Row G", @"Lev. 7 Row H", @"Lev. 7 Row J", @"Lev. 7 Row K", @"Lev. 7 Row L", @"Lev. 7 Row M", @"Lev. 7 Row N", @"Lev. 7 Row P", @"Lev. 7 Row Q", nil];
    dailyEastStallArray = [[NSArray alloc] initWithObjects:@"Surf. Lot-A", @"Lev. 1 Row A", @"Lev. 1 Row B", @"Lev. 1 Row C", @"Lev. 1 Row D", @"Lev. 1 Row E", @"Lev. 1 Row F",
                           @"Lev. 1 Row G", @"Lev. 1 Row H", @"Lev. 1 Row J", @"Lev. 2 Row A",@"Lev. 2 Row B", @"Lev. 2 Row C", @"Lev. 2 Row D", @"Lev. 2 Row E", @"Lev. 2 Row F",
                           @"Lev. 2 Row G", @"Lev. 2 Row H", @"Lev. 2 Row J", @"Lev. 3 Row A",@"Lev. 3 Row B", @"Lev. 3 Row C", @"Lev. 3 Row D", @"Lev. 3 Row E", @"Lev. 3 Row F",
                           @"Lev. 3 Row G", @"Lev. 3 Row H", @"Lev. 3 Row J", @"Lev. 4 Row A",@"Lev. 4 Row B", @"Lev. 4 Row C", @"Lev. 4 Row D", @"Lev. 4 Row E", @"Lev. 4 Row F",
                           @"Lev. 4 Row G", @"Lev. 4 Row H", @"Lev. 4 Row J", @"Lev. 5 Row A",@"Lev. 5 Row B", @"Lev. 5 Row C", @"Lev. 5 Row D", @"Lev. 5 Row E", @"Lev. 5 Row F",
                           @"Lev. 5 Row G", @"Lev. 5 Row H", @"Lev. 5 Row J", nil];
    dailyWestStallArray = [[NSArray alloc] initWithObjects:@"Lev. 1 Row A",@"Lev. 1 Row B", @"Lev. 1 Row C", @"Lev. 1 Row D", @"Lev. 1 Row E", @"Lev. 1 Row F", @"Lev. 1 Row G", @"Lev. 1 Row H", @"Lev. 1 Row J",
                           @"Lev. 2 Row A",@"Lev. 2 Row B", @"Lev. 2 Row C", @"Lev. 2 Row D", @"Lev. 2 Row E", @"Lev. 2 Row F", @"Lev. 2 Row G", @"Lev. 2 Row H", @"Lev. 2 Row J",
                           @"Lev. 3 Row A",@"Lev. 3 Row B", @"Lev. 3 Row C", @"Lev. 3 Row D", @"Lev. 3 Row E", @"Lev. 3 Row F", @"Lev. 3 Row G", @"Lev. 3 Row H", @"Lev. 3 Row J",
                           @"Lev. 4 Row A",@"Lev. 4 Row B", @"Lev. 4 Row C", @"Lev. 4 Row D", @"Lev. 4 Row E", @"Lev. 4 Row F", @"Lev. 4 Row G", @"Lev. 4 Row H", @"Lev. 4 Row J",
                           @"Lev. 5 Row A",@"Lev. 5 Row B", @"Lev. 5 Row C", @"Lev. 5 Row D", @"Lev. 5 Row E", @"Lev. 5 Row F", @"Lev. 5 Row G", @"Lev. 5 Row H", @"Lev. 5 Row J", nil];
    dailyNorthStallArray = [[NSArray alloc] initWithObjects:@"'H' Lot", @"'J' Lot", @"'K' Lot", nil];
    longTerm1StallArray = [[NSArray alloc] initWithObjects:@"Shelter 'L'", @"Shelter 'M'", @"Shelter 'N'", @"Shelter 'O'", @"Shelter 'P'", @"Shelter 'Q'", @"Shelter 'R'",
                           @"Shelter 'S'", nil];
    longTerm2StallArray = [[NSArray alloc] initWithObjects:@"Shelter 'T'", @"Shelter 'U'", @"Shelter 'V'", @"Shelter 'W'", @"Shelter 'X'", nil];
    longTerm3StallArray = [[NSArray alloc] initWithObjects:@"'Z' Lot", nil];
    longTerm4StallArray = [[NSArray alloc] initWithObjects:@"A-1", @"A-3", @"A-5", @"B-1", @"B-3", @"B-5", @"C-1", @"C-3", @"C-5", @"D-1", @"D-3", @"D-5",
                           @"E-1", @"E-3", @"E-5", @"F-1", @"F-3", @"F-5", @"G-1", nil];
    
//    stallSelection = dailyEastStallArray;

    //
    // Initialize pickerView positions
    //
    NSInteger parkingSpotPickerIndex0FromString = [[temp objectForKey:@"parkingSpotPickerIndex0"] integerValue];
    NSInteger parkingSpotPickerIndex1FromString = [[temp objectForKey:@"parkingSpotPickerIndex1"] integerValue];
    
    lotSelected = [[NSString alloc] initWithFormat:@"%@", [lotSelection objectAtIndex:parkingSpotPickerIndex0FromString]];
    if([lotSelected isEqualToString:@"Hourly"]) {
        stallSelection = hourlyStallArray;
    } else if ([lotSelected isEqualToString:@"Daily East"]) {
        stallSelection = dailyEastStallArray;
    } else if ([lotSelected isEqualToString:@"Daily West"]) {
        stallSelection = dailyWestStallArray;
    } else if ([lotSelected isEqualToString:@"Daily North"]) {
        stallSelection = dailyNorthStallArray;
    } else if ([lotSelected isEqualToString:@"Long Term 1"]) {
        stallSelection = longTerm1StallArray;
    } else if ([lotSelected isEqualToString:@"Long Term 2"]) {
        stallSelection = longTerm2StallArray;
    } else if ([lotSelected isEqualToString:@"Long Term 3"]) {
        stallSelection = longTerm3StallArray;
    } else if ([lotSelected isEqualToString:@"Long Term 4"]) {
        stallSelection = longTerm4StallArray;
    }
    [self.parkingSelector reloadComponent:1];
    
    stallSelected = [[NSString alloc] initWithFormat:@"%@", [stallSelection objectAtIndex:0]];
    
    [self.parkingSelector selectRow:parkingSpotPickerIndex0FromString inComponent:0 animated:YES];
    [self.parkingSelector selectRow:parkingSpotPickerIndex1FromString inComponent:1 animated:YES];
    
// Initialize parkingInfoLabel, it will change with selection
    lotSelected = [[NSString alloc] initWithFormat:@"%@", [lotSelection objectAtIndex:parkingSpotPickerIndex0FromString]];
    stallSelected = [[NSString alloc] initWithFormat:@"%@", [stallSelection objectAtIndex:parkingSpotPickerIndex1FromString]];
    parkingInfoLabel.text = [[NSString alloc] initWithFormat:@" %@ - %@",
                             [lotSelected stringByAppendingString:@""],
                             [stallSelected stringByAppendingString:@""]];
    
    plistReminderString = parkingInfoLabel.text;

// Necessary to dismiss keyboard when "Done" is touched
    self.myParkingNotes.delegate = self;
}

// Necessary to dismiss keyboard when "Done" is touched
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

// returns the # of 'columns' to display
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [lotSelection count];
    } else {
        return [stallSelection count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row0 forComponent:(NSInteger)component{
    
    if (component == 0) {
        return [lotSelection objectAtIndex:row0];
    } else {
        return [stallSelection objectAtIndex:row0];
    }
}

// if user choose from pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row0 inComponent:(NSInteger)component{
    
    //
    // Reset "Set Reminder" Button Label upon pickerView changes
    //
    [buttonAsDateLabel setTitle:[[NSString alloc]initWithFormat:@"%@", @"Set Reminder"] forState:UIControlStateNormal];
    
    if (component == 0) {
        lotSelected = [[NSString alloc] initWithFormat:@"%@", [lotSelection objectAtIndex:row0]];
        
        if([lotSelected isEqualToString:@"Hourly"]) {
            stallSelection = hourlyStallArray;
        } else if ([lotSelected isEqualToString:@"Daily East"]) {
            stallSelection = dailyEastStallArray;        } else if ([lotSelected isEqualToString:@"Daily West"]) {
            stallSelection = dailyWestStallArray;
        } else if ([lotSelected isEqualToString:@"Daily North"]) {
            stallSelection = dailyNorthStallArray;
        } else if ([lotSelected isEqualToString:@"Long Term 1"]) {
            stallSelection = longTerm1StallArray;
        } else if ([lotSelected isEqualToString:@"Long Term 2"]) {
            stallSelection = longTerm2StallArray;
        } else if ([lotSelected isEqualToString:@"Long Term 3"]) {
            stallSelection = longTerm3StallArray;
        } else if ([lotSelected isEqualToString:@"Long Term 4"]) {
            stallSelection = longTerm4StallArray;
        }
        
        [pickerView reloadComponent:1];
        
        // Reset StallSelection wheel at index 0 when a different parking lot is selected
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        stallSelected = [[NSString alloc] initWithFormat:@"%@", [stallSelection objectAtIndex:0]];
        
    } else {
        NSInteger row1 = [self.parkingSelector selectedRowInComponent:1];
        stallSelected = [[NSString alloc] initWithFormat:@"%@", [stallSelection objectAtIndex:row1]];
    }
    
    //
    // Update the "I parked at:" label
    //
    parkingInfoLabel.text = [[NSString alloc] initWithFormat:@" %@ - %@",
                       [lotSelected stringByAppendingString:@""],
                     [stallSelected stringByAppendingString:@""]];
    //
    // Update UIPickerView Wheels position into global variable
    //
    NSInteger tpmPlistPickerViewSelectedRow0 = [parkingSelector selectedRowInComponent:0];
    NSInteger tpmPlistPickerViewSelectedRow1 = [parkingSelector selectedRowInComponent:1];
    plistPickerViewSelectedRow0 = [NSString stringWithFormat:@"%ld", (long)tpmPlistPickerViewSelectedRow0];
    plistPickerViewSelectedRow1 = [NSString stringWithFormat:@"%ld", (long)tpmPlistPickerViewSelectedRow1];

    // Write plist upon pickerView changes
    [self savingPlist];
}

- (IBAction)notesHaveBeenEdited:(id)sender {
    [self savingPlist];
}

- (IBAction)saveSelectionsInPlist:(id)sender {
    [self savingPlist];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self savingPlist];
}

- (void)savingPlist {
    plistReminderString = parkingInfoLabel.text;
    plistMemoString = myParkingNotes.text;
    
    NSInteger tpmPlistPickerViewSelectedRow0 = [parkingSelector selectedRowInComponent:0];
    NSInteger tpmPlistPickerViewSelectedRow1 = [parkingSelector selectedRowInComponent:1];
    plistPickerViewSelectedRow0 = [NSString stringWithFormat:@"%ld", (long)tpmPlistPickerViewSelectedRow0];
    plistPickerViewSelectedRow1 = [NSString stringWithFormat:@"%ld", (long)tpmPlistPickerViewSelectedRow1];
    
    //
    // Writing plist
    //
    
    NSString *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CLT-Parking.plist"];
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: plistReminderString,
                                plistMemoString,
                                plistPickerViewSelectedRow0,
                                plistPickerViewSelectedRow1, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"selectedParkingSpot",
                                                                   @"note",
                                                                   @"parkingSpotPickerIndex0",
                                                                   @"parkingSpotPickerIndex1", nil]];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
    }
}




-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
