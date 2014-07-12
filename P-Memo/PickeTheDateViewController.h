//
//  PickeTheDateViewController.h
//  P-Memo
//
//  Created by gianni on 1/9/14.
//  Copyright (c) 2014 gianni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickeTheDateViewController : UIViewController {
    UIDatePicker *pickTheDate;
}

@property (retain, nonatomic) IBOutlet UIDatePicker *pickTheDate;
@property (retain, nonatomic) NSString *invisibleLabel;

@property (retain, nonatomic) NSDate *choosenDate;

@property (retain, nonatomic) NSString *soloPerProvare;



@end
