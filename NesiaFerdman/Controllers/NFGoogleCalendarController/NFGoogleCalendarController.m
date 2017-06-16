//
//  NFGoogleCalendarController.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 6/7/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFGoogleCalendarController.h"
#import <WebKit/WebKit.h>


@interface NFGoogleCalendarController ()
<
WKNavigationDelegate,
WKUIDelegate,
UIWebViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) WKWebView *wkWebV;
@property (strong, nonatomic) NSString *baseAddress;

@end

@implementation NFGoogleCalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Календарь";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"отмена" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    backButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backButton;

    
    self.baseAddress = @"http://www.google.com/calendar/";
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    
    self.wkWebV = [[WKWebView alloc] initWithFrame:self.mainView.frame configuration:wkWebConfig];
    self.wkWebV.navigationDelegate = self;
    self.wkWebV.UIDelegate = self;
    [self.view addSubview:self.wkWebV];
    [self addWebViewWithURL:_baseAddress];
}

- (void) addWebViewWithURL: (NSString*) urlString {
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    // wkWebV.UIDelegate = self;
    //self.wkWebV.navigationDelegate = self;
    [self.wkWebV loadRequest:nsrequest];
    [self.view addSubview:self.wkWebV];
    
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
