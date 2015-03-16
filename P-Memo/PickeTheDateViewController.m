//
//  PickeTheDateViewController.m
//  P-Memo
//
//  Created by gianni on 1/9/14.
//  Copyright (c) 2014 gianni. All rights reserved.
//

#import "PickeTheDateViewController.h"
#import "P_MemoViewController.h"
#import <EventKit/EventKit.h>

@interface PickeTheDateViewController ()

@property (nonatomic, strong) EKEventStore *eventStore;
@property BOOL eventStoreAccessGranted;

@end

@implementation PickeTheDateViewController

@synthesize pickTheDate;
@synthesize invisibleLabel;

@synthesize soloPerProvare;


@synthesize choosenDate;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToMainView"]) {
        P_MemoViewController *mainView = [segue destinationViewController];
        mainView.selectedDateForReminder = invisibleLabel;
        
        soloPerProvare = invisibleLabel;
        soloPerProvare = mainView.parkingInfoLabel.text;
    }
}

- (IBAction)addReminderWithAlarm:(id)sender {
    if (!self.eventStoreAccessGranted)
        return;
    
    // Handling plist to store changes
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
    
    // Popup message if date is NOT selected
    if (!choosenDate) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:@"No reminder have been set. Please pick a date and time to set a reminder."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        if ([choosenDate timeIntervalSinceNow] < 0.0) {
            [self warningDateInThePast];
        } else {
    
    EKAlarm *ourAlarm = [EKAlarm alarmWithAbsoluteDate:choosenDate];
    EKReminder *newReminder = [EKReminder reminderWithEventStore:self.eventStore];

    
    newReminder.title = [NSString stringWithFormat:@"%@\r%@",
                         [temp objectForKey:@"selectedParkingSpot"],
                         [temp objectForKey:@"note"]];

    newReminder.calendar = [_eventStore defaultCalendarForNewReminders];
    [newReminder addAlarm:ourAlarm];
    
    NSError *error = nil;
    
    [self.eventStore saveReminder:newReminder
                           commit:YES
                            error:&error];
        }
    }
}

- (void)warningDateInThePast {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                    message:@"A reminder cannot be set in the past. Please choose a date and time in the future."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(IBAction)dateValueChanged:(id)sender {
    
    choosenDate = [pickTheDate date];
    
    if ([choosenDate timeIntervalSinceNow] < 0.0) {
        [self warningDateInThePast];
    } else {
        
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *dateForReminder = [dateFormat stringFromDate:choosenDate];

    invisibleLabel = dateForReminder;
        
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventStore = [[EKEventStore alloc] init];
    self.eventStoreAccessGranted =NO;
    [self.eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL success, NSError *error) {
        self.eventStoreAccessGranted = success;
        if (!success)
            NSLog(@"User has not granted access to add reminder.");
    }];
    
    // Set UIDatepicker Text Color
    [pickTheDate setValue:[UIColor whiteColor] forKeyPath:@"textColor"];
    
    SEL selector = NSSelectorFromString( @"setHighlightsToday:" );
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature :
                                [UIDatePicker
                                 instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:pickTheDate];
    
    // Status bar color
    [self setNeedsStatusBarAppearanceUpdate];
    
}

// Status bar color
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
