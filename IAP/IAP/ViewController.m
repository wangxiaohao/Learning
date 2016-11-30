//
//  ViewController.m
//  IAP
//
//  Created by CXY on 16/11/2.
//  Copyright © 2016年 CXY. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>


@interface ViewController ()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation ViewController

#pragma mark 将购买页面设置成购买的Observer
- (void)viewDidLoad {
    [super viewDidLoad];
    // 监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)payment {
    //当用户点击了一个IAP项目，我们先查询用户是否允许应用内付费，如果不允许则不用进行以下步骤
    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
    }
    
}

// 下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfo {
    NSSet * set = [NSSet setWithArray:@[@"ProductId"]];
    //IAP购买项目查询
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}

#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    //添加到支付队列，
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSString *receipt = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL] encoding:NSUTF8StringEncoding error:nil];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        //服务器验证凭证(Optional)。如果购买成功，我们需要将凭证发送到服务器上进行验证。考虑到网络异常情况，iOS端的发送凭证操作应该进行持久化，如果程序退出，崩溃或网络异常，可以恢复重试
    }
    
    // Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

@end
