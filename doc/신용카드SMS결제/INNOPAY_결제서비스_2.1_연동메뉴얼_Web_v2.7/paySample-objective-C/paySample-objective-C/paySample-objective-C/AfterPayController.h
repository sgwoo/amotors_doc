//
//  AfterPayController.h
//  paySample-objective-C
//
//  Created by 서정현 on 2018. 12. 19..
//  Copyright © 2018년 서정현. All rights reserved.
//

#ifndef AfterPayController_h
#define AfterPayController_h



#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol sendBackDelegate //프로토콜의 정의시작 @end 까지

@required //반드시 구현해야 할 부분
- (void) dataReceived:(NSData*)data;

@end

@interface AfterPayController : UIViewController <WKNavigationDelegate, WKUIDelegate , WKScriptMessageHandler>

@property(copy , nonatomic) NSString* param;
@property(weak , nonatomic) id<sendBackDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *webViewBox;
- (IBAction)onPressBack:(UIBarButtonItem *)sender;


@end

#endif
