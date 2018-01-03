//
//  TXLiveDemoUITests.m
//  TXLiveDemoUITests
//
//  Created by shiguorui on 2017/11/30.
//  Copyright © 2017年 shiguorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TXLiveDemoUITests : XCTestCase

@end

@implementation TXLiveDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElement *mobilePushStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"mobile push"]/*[[".cells.staticTexts[@\"mobile push\"]",".staticTexts[@\"mobile push\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [mobilePushStaticText tap];
    
    XCUIElement *functionsButton = app.navigationBars[@"live pusher"].buttons[@"Functions"];
    [functionsButton tap];
    [mobilePushStaticText tap];
    [app.buttons[@"start push"] tap];
    
    XCUIElement *stopPushButton = app.buttons[@"stop push"];
    [stopPushButton tap];
    [app.switches[@"1"] tap];
    [app.switches[@"0"] tap];
    [stopPushButton tap];
    [functionsButton tap];
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"mobile player"]/*[[".cells.staticTexts[@\"mobile player\"]",".staticTexts[@\"mobile player\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app.buttons[@"start play"] tap];
    [app.buttons[@"stop play"] tap];
    
    XCUIElement *sendMessageTestButton = app.buttons[@"send message test"];
    [sendMessageTestButton tap];
    [sendMessageTestButton tap];
    [app.navigationBars[@"live player"].buttons[@"Functions"] tap];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
}

@end
