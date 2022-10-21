//
//  BeforePayController.m
//  paySample-objective-C
//
//  Created by 서정현 on 2018. 12. 19..
//  Copyright © 2018년 서정현. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"

#import "BeforePayController.h"
#import "AfterPayController.h"

@implementation BeforePayController

NSString *mid = @"testpay01m";//발급받은 mid
NSString *merchantKey = @"Ma29gyAFhvv/+e4/AHpV6pISQIvSKziLIbrNoXPbRS5nfTx2DOs8OJve+NzwyoaQ8p9Uy1AN4S1I0Um5v7oNUg=="; //발급받은 라이센스키 입력

@synthesize moidTextField;
@synthesize goodsNameTextField;
@synthesize goodsAmtTextField;
@synthesize dutyFreeAmtTextField;
@synthesize goodsCntTextField;
@synthesize buyerNameTextField;
@synthesize mallUserIDTextField;
@synthesize buyerTelTextField;
@synthesize buyerEmailTextField;
@synthesize offeringPeriodTextField;
@synthesize midTextField;
@synthesize pick;

-(void)viewDidLoad {
    NSLog(@"%s" , __PRETTY_FUNCTION__ ) ;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    moidTextField.delegate = self;
    goodsNameTextField.delegate = self;
    goodsAmtTextField.delegate = self;
    dutyFreeAmtTextField.delegate = self;
    goodsCntTextField.delegate = self;
    buyerNameTextField.delegate = self;
    mallUserIDTextField.delegate = self;
    buyerTelTextField.delegate = self;
    buyerEmailTextField.delegate = self;
    offeringPeriodTextField.delegate = self;
    pick.delegate = self;
    midTextField.delegate = self;
     NSMutableArray* bandArray = [[NSMutableArray alloc] init];

       // add some sample data
      [bandArray addObject:@"신용카드(일반)"];
        [bandArray addObject:@"계좌이체"];
        [bandArray addObject:@"무통장입금"];
       [bandArray addObject:@"수기결제 WebLink"];

       // bind yourTextField to DownPicker
       self.pick = [[DownPicker alloc] initWithTextField:self.pick withData:bandArray];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self makeMoid];
    
    // create the array of data
   
  
   
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%s" , __PRETTY_FUNCTION__ ) ;
    if ([segue.identifier  isEqualToString: @"goWeb"]) {
        AfterPayController *controller = [segue destinationViewController];
        NSString *temp = [self makeStringPostParameter];
        controller.param = [temp description];
        controller.delegate = self;
        
        [self makeMoid];
    }
    
//    if segue.identifier == "goWeb"{//웹뷰 호출시 data부분을 파라메터 생성후 화면전환
//        let afterPayController = segue.destination as! AfterPayController
//        afterPayController.data = makeStringPostParameter()
//        afterPayController.delegate = self
//
//        makeMoid()
//    }
}


- (IBAction)onPressPost:(id)sender {
    NSLog(@"%s" , __PRETTY_FUNCTION__ ) ;
    [self performSegueWithIdentifier:@"goWeb" sender:self];
}

- (void) dataReceived:(NSData*)data{
//    let receivedData = data
//    print("dataReceived [\(receivedData)]")
    NSLog(@"%s ReceivedData : %@" , __PRETTY_FUNCTION__ ,data) ;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    // Try to find next responder
    UITextField *nextField = [textField.superview.superview viewWithTag:textField.tag +1];
    
    if (nextField != nil) {
        [nextField becomeFirstResponder];
        return true;
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
        return true;
    }
    // Do not add a line break
    return false;
}

- (void) makeMoid{//moid임의생성
    NSDate *now = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    [moidTextField setText: [@"test" stringByAppendingString: [dateFormatter stringFromDate:now]]];
}

-(NSString*) makeStringPostParameter{//파라메터생성
    NSString *returnVal = @"";
    
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"MID=%@" , midTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&Moid=%@" , moidTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&GoodsName=%@" , goodsNameTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&Amt=%@" , goodsAmtTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&DutyFreeAmt=%@" , dutyFreeAmtTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&GoodsCnt=%@" , goodsCntTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&BuyerName=%@" , buyerNameTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&MallUserID=%@" , mallUserIDTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&BuyerTel=%@" , buyerTelTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&BuyerEmail=%@" , buyerEmailTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&OfferingPeriod=%@" , offeringPeriodTextField.text]];
    returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&MerchantKey=%@" , merchantKey]];
     returnVal = [returnVal stringByAppendingString : [NSString stringWithFormat: @"&PayMethod=%@" , pick.text]];    return returnVal;
    
}
//func dataReceived(data: [String: Any]) {
//    let receivedData = data
//    print("dataReceived [\(receivedData)]")
//}
//
//func textFieldShouldReturn(_ textField: UITextField) -> Bool
//{
//    // Try to find next responder
//    if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
//        nextField.becomeFirstResponder()
//    } else {
//        // Not found, so remove keyboard.
//        textField.resignFirstResponder()
//    }
//    // Do not add a line break
//    return false
//}
//
//func makeMoid (){//moid임의생성
//    let now = Date()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
//    moidTextField.text="test" + dateFormatter.string(from: now)
//}
//
//func makeStringPostParameter () -> String {//파라메터생성
//    var returnVal = "";
//
//    returnVal += "mid=\(mid)"
//    returnVal += "&moid=\(moidTextField.text!)"
//    returnVal += "&goodsName=\(goodsNameTextField.text!)"
//    returnVal += "&goodsAmt=\(goodsAmtTextField.text!)"
//    returnVal += "&dutyFreeAmt=\(dutyFreeAmtTextField.text!)"
//    returnVal += "&goodsCnt=\(goodsCntTextField.text!)"
//    returnVal += "&buyerName=\(buyerNameTextField.text!)"
//    returnVal += "&mallUserID=\(mallUserIDTextField.text!)"
//    returnVal += "&buyerTel=\(buyerTelTextField.text!)"
//    returnVal += "&buyerEmail=\(buyerEmailTextField.text!)"
//    returnVal += "&offeringPeriod=\(offeringPeriodTextField.text!)"
//    returnVal += "&merchantKey=\(merchantKey)"
//
//    return returnVal
//
//}
@end
