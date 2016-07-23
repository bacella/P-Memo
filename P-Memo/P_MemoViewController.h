//
//  P_MemoViewController.h
//  P-Memo
//
//  Created by gianni on 1/5/14.
//  Copyright (c) 2014 gianni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface P_MemoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

/*
UITextFieldDelegate in < > is necessary to dismiss keyboard when "Done" is touched
together with more code in the implementation file:
 - (BOOL)textFieldShouldReturn:(UITextField *)textField {
 [textField resignFirstResponder];
 return NO;
 }
 AND
 self.myParkingNotes.delegate = self;
 http://stackoverflow.com/questions/10965357/how-to-hide-textbox-keyboard-when-done-return-button-is-pressed-xcode-4-2
*/

@property (weak, nonatomic) IBOutlet UIButton *buttonAsDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkingInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *myParkingNotes;
@property (weak, nonatomic) IBOutlet UIPickerView *parkingSelector;

@property (strong, nonatomic) NSArray *lotSelection;
@property (strong, nonatomic) NSArray *stallSelection;

@property (strong, nonatomic) NSArray *hourlyStallArray;
@property (strong, nonatomic) NSArray *dailyEastStallArray;
@property (strong, nonatomic) NSArray *dailyWestStallArray;
@property (strong, nonatomic) NSArray *dailyNorthStallArray;
@property (strong, nonatomic) NSArray *longTerm1StallArray;
@property (strong, nonatomic) NSArray *longTerm2StallArray;
@property (strong, nonatomic) NSArray *longTerm3StallArray;
@property (strong, nonatomic) NSArray *longTerm4StallArray;

@property (strong, nonatomic) NSString *lotSelected;
@property (strong, nonatomic) NSString *stallSelected;

@property (weak, nonatomic) NSString *selectedDateForReminder;

// CLT-Parking.plist Global Variables
@property (strong, nonatomic) NSString *plistReminderString;
@property (strong, nonatomic) NSString *plistMemoString;
@property (strong, nonatomic) NSString *plistPickerViewSelectedRow0;
@property (strong, nonatomic) NSString *plistPickerViewSelectedRow1;


@end
