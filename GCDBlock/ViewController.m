//
//  ViewController.m
//  GCDBlock
//
//  Created by pactera on 17/3/1.
//  Copyright © 2017年 pactera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic , strong) UIWebView *webview;
@property (nonatomic , strong) UIActivityIndicatorView *indicator;

@end

@implementation ViewController{
    NSString * string;
    NSString * number;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.webview];
    [self.view addSubview:self.indicator];
    [self setframe];
    
    NSURL *_url = [NSURL URLWithString: @"http://baidu.com"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
    [self.webview loadRequest:request];
    
    [self gcdGroup];
#pragma mark block 调用
    [self had:^{
        NSLog(@"12345");
    }];
}
- (UIWebView *)webview{
    if (!_webview) {
        _webview = [[UIWebView alloc]init];
        _webview.delegate = self;
        [_webview setScalesPageToFit:YES];
        _webview.backgroundColor = [UIColor orangeColor];
    }
    return _webview;
}
- (UIActivityIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = self.view.center;
        [_indicator setHidesWhenStopped:YES];
        
    }
    return _indicator;
}
- (void)setframe{
    self.webview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);

}
#pragma  mark UIWebView Delegate
-(BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request navigationType:(UIWebViewNavigationType)navigationType
{
    //网页加载之前会调用此方法
    [self.indicator startAnimating];
  
    //retrun YES 表示正常加载网页 返回NO 将停止网页加载
    return YES;
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载网页调用此方法
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
    //网页加载完成调用此方法
    [self.indicator stopAnimating];
//后台执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(10);
        NSLog(@"10");
        double deleInseconds = 4.0;
        /*
         延迟更新 要用秒 乘以 NSEC_PER_SEC 宏定义如下
         #define NSEC_PER_SEC 1000000000ull
         #define NSEC_PER_MSEC 1000000ull
         #define USEC_PER_SEC 1000000ull
         #define NSEC_PER_USEC 1000ull
         */
        dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, deleInseconds * NSEC_PER_SEC);
        dispatch_after(poptime, dispatch_get_main_queue(), ^{
            self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            [self once];
        });
        
    });
}

-(void)webView:(UIWebView* )webView didFailLoadWithError:(NSError* )error
{
    //网页加载失败 调用此方法
    [self.indicator stopAnimating];
   
 
}
/*
 线程一次性执行
 **/
- (void)once{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        NSLog(@"http://www.hao123.com  dispatch_once");

        NSURL *_url = [NSURL URLWithString: @"http://www.hao123.com"];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:_url];
        [self.webview loadRequest:request];
    });
}
/*
 线程并行执行
 **/
- (void)gcdGroup{
    
    
    dispatch_group_t group = dispatch_group_create();
    //并行执行线程一
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1000====%@",[NSDate date]);
        sleep(100);
        string = @"10";
    });
    //并行执行线程二
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        number = @"5";
        NSLog(@"5=======%@",[NSDate date]);
    });
    //汇总结果
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSLog(@"------------- %f",string.floatValue + number.floatValue);
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
