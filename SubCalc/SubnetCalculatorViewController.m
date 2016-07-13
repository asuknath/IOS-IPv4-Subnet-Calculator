//
//  SubnetCalculatorViewController.m
//  Uptime
//
//  Created by Asuk Nath on 7/12/16.
//  Copyright (c) 2016 NathTel. All rights reserved.
//

#import "SubnetCalculatorViewController.h"
#include <net/ethernet.h>
#include <arpa/inet.h>


@interface SubnetCalculatorViewController ()

@end

@implementation SubnetCalculatorViewController{
    NSString *_networkAddress;
    NSArray *subnets;
    NSArray *subnetbits;
}

@synthesize fistusableIPAddress, lastusableIPAddress, ipaddressTextField, subnetbitsTextField, subnetmaskTextField, subnetIDLabel, subnetmaskLabel, numberofhostsLabel;
@synthesize netClassSegment;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ipaddressTextField.delegate = self;
    self.subnetmaskTextField.delegate = self;
    [self calculateSubnet];    
}

-(void)calculateIPaddress {
    int ipAddress = [IPMaskConvert IPtoInt:_networkAddress];
    int subnetMask = [IPMaskConvert IPtoInt:self.subnetmaskTextField.text];
    int subnetBits;
    for (subnetBits = 0; subnetBits < 32; subnetBits++) {
        if ((subnetMask << subnetBits) == 0){
            break;
        }
    }
    int IPs = 0;
    for (int n = 0; n < (32 - subnetBits); n++) {
        IPs = IPs << 1;
        IPs = IPs | 1;
    }
    self.fistusableIPAddress.text = [IPMaskConvert intIPtoStr:ipAddress + 1];
    self.lastusableIPAddress.text = [IPMaskConvert intIPtoStr:ipAddress + IPs-1];
    self.subnetmaskLabel.text = self.subnetmaskTextField.text;
    self.subnetIDLabel.text = _networkAddress;
    self.numberofhostsLabel.text = [NSString stringWithFormat:@"Number of Hosts: %d", IPs-1];
    self.subnetbitsTextField.text = [NSString stringWithFormat:@"%d", subnetBits];
}

-(NSString*)subnetID {
    int subnetid = [IPMaskConvert IPtoInt:self.ipaddressTextField.text];
    subnetid &= [IPMaskConvert IPtoInt:self.subnetmaskTextField.text];
    return [IPMaskConvert intIPtoStr:subnetid];
}

- (IBAction)subnetcalcButton:(id)sender {
    [self calculateIPaddress];
    NSArray *checkIPAddress = [self.ipaddressTextField.text componentsSeparatedByString: @"."];
    if (checkIPAddress.count != 4){
        [self showalertview:@"IP Address" :@"Invalid IP address"];
        [self resetlabels];
    }else{
        int octet1= [[checkIPAddress objectAtIndex:0] intValue];
        int octet2= [[checkIPAddress objectAtIndex:1] intValue];
        int octet3= [[checkIPAddress objectAtIndex:2] intValue];
        int octet4= [[checkIPAddress objectAtIndex:3] intValue];
        
        if((octet1 >= 0 && octet1 <224) && (octet2 >= 0 && octet2 <256) && (octet3 >= 0 && octet3 <256) && (octet4 >= 0 && octet4 <256)){
            NSArray *checkMask = [self.subnetmaskLabel.text componentsSeparatedByString: @"."];
            NSLog(@"%@", self.subnetmaskTextField.text);
            if (checkMask.count != 4){
                [self showalertview:@"Subnet Mask" :@"Invalid Subnet Mask"];
                [self resetlabels];
            }else{
                int maskoctet1= [[checkMask objectAtIndex:0] intValue];
                int maskoctet2= [[checkMask objectAtIndex:1] intValue];
                int maskoctet3= [[checkMask objectAtIndex:2] intValue];
                int maskoctet4= [[checkMask objectAtIndex:3] intValue];
                            if((maskoctet1 == 255) && ([IPMaskConvert maskOctetValidation:maskoctet2 :2] == 1) && ([IPMaskConvert maskOctetValidation:maskoctet3 :3] == 1) && ([IPMaskConvert maskOctetValidation:maskoctet4 :4] == 1)){
                    [self calculateIPaddress];
                     [self calculateSubnet];
                }else{
                    [self showalertview:@"Subnet Mask" :@"Invalid Subnet Mask"];
                    [self resetlabels];
                }
            }
        }else{
            [self showalertview:@"IP Address" :@"Invalid IP address"];
            [self resetlabels];
        }
    }
}

-(void)calculateSubnet{
    NSArray *chkClass = [self.ipaddressTextField.text componentsSeparatedByString: @"."];
    int abc;
    abc = [[chkClass objectAtIndex:0] intValue];
    if(abc >0 && abc <= 126){
        NSLog(@"Class A");
        netClassSegment.selectedSegmentIndex = 0;
    }else if(abc >= 128 && abc <= 191){
        NSLog(@"Class B");
        netClassSegment.selectedSegmentIndex = 1;
    }else if(abc >=192 && abc <= 223){
        NSLog(@"Class C");
        netClassSegment.selectedSegmentIndex = 2;
    }else{
        
    }
    _networkAddress = [self subnetID];
    [self calculateIPaddress];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[self ipaddressTextField]resignFirstResponder];
    [[self subnetmaskTextField]resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)netClassSegmentAction:(id)sender {
    if(netClassSegment.selectedSegmentIndex == 0){
        self.ipaddressTextField.text = @"10.0.0.1";
        self.subnetmaskTextField.text = @"255.0.0.0";
        self.subnetbitsTextField.text= @"8";
        [self calculateSubnet];
    }
    if(netClassSegment.selectedSegmentIndex == 1){
        self.ipaddressTextField.text = @"172.16.0.1";
        self.subnetmaskTextField.text = @"255.255.0.0";
        self.subnetbitsTextField.text= @"16";
        [self calculateSubnet];
    }
    if(netClassSegment.selectedSegmentIndex == 2){
        self.ipaddressTextField.text = @"192.168.0.1";
        self.subnetmaskTextField.text = @"255.255.255.0";
        self.subnetbitsTextField.text= @"24";
        [self calculateSubnet];
    }
}

- (void)showalertview :(NSString*)title :(NSString*)msg {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK action") style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                               }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)resetlabels{
    self.fistusableIPAddress.text = @"0.0.0.0";
    self.lastusableIPAddress.text = @"0.0.0.0";
    self.subnetmaskLabel.text = @"0.0.0.0";
    self.subnetIDLabel.text = @"0.0.0.0";
    self.numberofhostsLabel.text = [NSString stringWithFormat:@"Number of Hosts: %d", 0];
    self.subnetbitsTextField.text = [NSString stringWithFormat:@"%d", 0];
}
@end
