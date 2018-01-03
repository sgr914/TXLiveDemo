//
//  TXLiveDemoTests.m
//  TXLiveDemoTests
//
//  Created by shiguorui on 2017/11/30.
//  Copyright © 2017年 shiguorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TXLiveDemoTests : XCTestCase

@end

@implementation TXLiveDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

    UIViewController *rootVC = (UIViewController *)([UIApplication sharedApplication]. delegate.window.rootViewController);
    UIView *view = rootVC.view;
    
    XCTAssertNotNil(view, @"Cannot find view instance");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
