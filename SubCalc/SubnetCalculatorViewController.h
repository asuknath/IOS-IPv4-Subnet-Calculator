//
//  SubnetCalculatorViewController.h
//  Uptime
//
//  Created by Asuk Nath on 7/12/16.
//  Copyright (c) 2016 NathTel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPMaskConvert.h"

@interface SubnetCalculatorViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UILabel *fistusableIPAddress;
@property (weak, nonatomic) IBOutlet UILabel *lastusableIPAddress;

@property (weak, nonatomic) IBOutlet UITextField *ipaddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *subnetmaskTextField;
@property (weak, nonatomic) IBOutlet UITextField *subnetbitsTextField;

@property (weak, nonatomic) IBOutlet UILabel *subnetmaskLabel;
@property (weak, nonatomic) IBOutlet UILabel *subnetIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberofhostsLabel;


- (IBAction)subnetcalcButton:(id)sender;


@property (weak, nonatomic) IBOutlet UISegmentedControl *netClassSegment;
- (IBAction)netClassSegmentAction:(id)sender;



@end
