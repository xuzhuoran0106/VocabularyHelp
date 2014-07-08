//
//  HowToUseViewController.m
//  VocabularyHelp
//
//  Created by xu zhuoran on 7/8/14.
//  Copyright (c) 2014 xu zhuoran. All rights reserved.
//

#import "HowToUseViewController.h"

@interface HowToUseViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *howToUseView;

@end

@implementation HowToUseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"HowToUse" ofType:@"rtf"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (request)
    {
        // Additional configuration
    }
    _howToUseView.delegate = self;
    //Adding the content of the webiew
    [_howToUseView loadRequest:request];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return true;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
