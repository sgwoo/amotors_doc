//
//  AfterPayController.m
//  paySample-objective-C
//
//  Created by 서정현 on 2018. 12. 19..
//  Copyright © 2018년 서정현. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <WebKit/WebKit.h>

#import "AppDelegate.h"

#import "AfterPayController.h"

@interface AfterPayController ()

@end

@implementation AfterPayController

@synthesize param;
@synthesize delegate;
@synthesize webViewBox;


NSString *url = @"http://172.16.10.211:8080/ipay/appLink.jsp";

//결제 결과 키값
NSString *RESULT_PAY_METHOD = @"PayMethod";
NSString *RESULT_MID = @"MID";
NSString *RESULT_TID = @"TID";
NSString *RESULT_MALL_USER_ID = @"mallUserID";
NSString *RESULT_AMT = @"Amt";
NSString *RESULT_NAME = @"name";
NSString *RESULT_GOODS_NAME = @"GoodsName";
NSString *RESULT_OID = @"OID";
NSString *RESULT_MOID = @"MOID";
NSString *RESULT_AUTH_DATE = @"AuthDate";
NSString *RESULT_AUTH_CODE = @"AuthCode";
NSString *RESULT_RESULT_CODE = @"ResultCode";
NSString *RESULT_RESULT_MSG = @"ResultMsg";
NSString *RESULT_MALL_RESERVED = @"MallReserved";
NSString *RESULT_FN_CD = @"fn_cd";
NSString *RESULT_FN_NAME = @"fn_name";
NSString *RESULT_CARD_QUOTA = @"CardQuota";
NSString *RESULT_BUYER_EMAIL = @"BuyerEmail";

WKWebView *webView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *userConfig = [[WKWebViewConfiguration alloc] init];
    [userConfig.userContentController addScriptMessageHandler:self name:@"payResult"];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:webViewBox.frame configuration:userConfig];//웹킷웹뷰의 설정을 초기화하여 웹뷰생성
    webView.navigationDelegate = self;
    
    if (webView != nil) {
        webView.frame = webView.frame;
        [webViewBox.superview addSubview:webView];
        webView.navigationDelegate=self;
        webView.UIDelegate = self;
    }
    NSString *encodedParamWithURL = [url stringByAppendingString:@"?"];
    encodedParamWithURL = [encodedParamWithURL stringByAppendingString:param];
    encodedParamWithURL = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                (CFStringRef)encodedParamWithURL,
                                                                                                nil,
                                                                                                (CFStringRef)@"+",
                                                                                                kCFStringEncodingUTF8 ));
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:encodedParamWithURL]];
    /*GET start*/
    //만약 GET방식으로 처리하려면 이블럭을 해제하면 동작 (POST블럭 주석처리 필요)
    /*[request setHTTPMethod:@"GET"];
    [webView loadRequest:request];*/
    /*GET end*/
    /*POST start*/
    // 만약 POST방식으로 처리하려면 이블럭을 해제하면 동작 (GET블럭 주석처리 필요)
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc]initWithString:url]];
    [postRequest setHTTPMethod:@"POST"];
    NSString *encodedParam = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                                                         (CFStringRef)param,
                                                                                                                         nil,
                                                                                                                         (CFStringRef)@"+",
                                                                                                                         kCFStringEncodingUTF8 ));
    NSData *postData = [encodedParam dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [postRequest setHTTPBody:postData];
    //[postRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
    //WKWebView의 load 메소드의 경우 PostRequest.httpBody 에 데이터를 실어 POST할경우 데이터가 null로 전송되는 문제때문에 URLSession.shared.dataTask를 사용하여 POST후 웹뷰에 처리
    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data != nil) {
            // Handle error, optionally using
            NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (returnString != nil) {
                [webView loadHTMLString:returnString baseURL:[[NSURL alloc] initWithString:url]];
            }
        }
    }];
    [dataTask resume];
    
    /*POST end*/
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              completionHandler();
                                                          }];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              completionHandler(YES);
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              completionHandler(NO);
                                                          }];
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:prompt
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              NSString *text = alertController.textFields.firstObject.text;
                                                              if(text != nil){
                                                                  completionHandler(text);
                                                              }else{
                                                                  completionHandler(defaultText);
                                                              }
                                                          }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             completionHandler(nil);
                                                         }];
    
    [alertController addAction:defaultAction];
    [alertController addAction:cancelAction];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *requestString = navigationAction.request.URL.absoluteString;
    if (![requestString hasPrefix:@"http"]){//http계열 url이 아닐경우 url을 오픈처리
        NSURL *rurl = [NSURL URLWithString:requestString];
        //[[UIApplication sharedApplication] openURL:rurl];
         [[UIApplication sharedApplication] openURL:rurl options:@{} completionHandler:nil];
        decisionHandler(WKNavigationActionPolicyCancel);
        
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [webView reload];
}

 //message값이 success일 경우 동작함
 //결제 성공 시 결과값을 메시지로 출력
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"payResult"]) {
        NSData *json = [self convertToDictionary:message.body];
        NSLog(@"%s : %@[%@]", __PRETTY_FUNCTION__  , message.name , message.body) ;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"success"
                                                                                 message:message.body
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self.delegate dataReceived:json];
                                                                  [self dismissViewControllerAnimated:true completion:nil];
                                                              }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"error"
                                                                                 message:@"정의된 userContentController가 없습니다."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self dismissViewControllerAnimated:true completion:nil];
                                                              }];
        [alertController addAction:defaultAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (NSData *) convertToDictionary:(NSString *) text{
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (data != nil) {
        @try {
            return [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableLeaves||NSJSONReadingMutableContainers error:nil];
        } @catch (NSException *exception) {
            NSLog(@"%s : %@", __PRETTY_FUNCTION__  , [exception description]) ;
        }
    }
    return nil;
}

- (IBAction)onPressBack:(UIBarButtonItem *)sender {
    [delegate dataReceived:nil];
    [self dismissViewControllerAnimated:true completion:nil];
}
@end
