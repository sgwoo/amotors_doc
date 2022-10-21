//
//  BeforePayController.h
//  paySample-objective-C
//
//  Created by 서정현 on 2018. 12. 19..
//  Copyright © 2018년 서정현. All rights reserved.
//

#ifndef BeforePayController_h
#define BeforePayController_h

#import <DownPicker.h>
#import <UIDownPicker.h>
#import <UIKit/UIKit.h>
#import "BeforePayController.h"
@protocol sendBackDelegate;

@interface BeforePayController : UIViewController <sendBackDelegate , UITextFieldDelegate, UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITextField *midTextField;
@property (strong, nonatomic) IBOutlet UIDownPicker *pick;

@property (strong, nonatomic) IBOutlet UITextField *moidTextField;
@property (strong, nonatomic) IBOutlet UITextField *goodsNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *goodsAmtTextField;
@property (strong, nonatomic) IBOutlet UITextField *dutyFreeAmtTextField;
@property (strong, nonatomic) IBOutlet UITextField *goodsCntTextField;
@property (strong, nonatomic) IBOutlet UITextField *buyerNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *mallUserIDTextField;
@property (strong, nonatomic) IBOutlet UITextField *buyerTelTextField;
@property (strong, nonatomic) IBOutlet UITextField *buyerEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *offeringPeriodTextField;
- (IBAction)onPressPost:(id)sender;

- (void) dataReceived:(NSData*)data;
@end

#endif
