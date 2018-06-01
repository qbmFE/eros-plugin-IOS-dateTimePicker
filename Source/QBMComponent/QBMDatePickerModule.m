//
//  QBMDatePickerModule.m
//  WeexEros
//
//  Created by qbm_ios on 2018/5/24.
//  Copyright © 2018年 qbm Company. All rights reserved.

#import "QBMDatePickerModule.h"
#import <UIKit/UIKit.h>
#import "QBMDefine.h"
#import "WXComponentManager.h"
#import "QBMDatePickerView.h"
#import "WXConvert.h"
#import <WeexPluginLoader/WeexPluginLoader.h>

@interface QBMDatePickerModule()<QBMDatePickerViewDelegate>

@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,copy)NSString *cancelTitle;
@property(nonatomic,copy)NSString *confirmTitle;
@property(nonatomic,strong)UIColor *cancelTitleColor;
@property(nonatomic,strong)UIColor *confirmTitleColor;

@property(nonatomic,strong)QBMDatePickerView  *pickerView;
@property (nonatomic, strong) NSDate *selectedDate;
@property(nonatomic,copy)WXModuleKeepAliveCallback callback;
@end

WX_PlUGIN_EXPORT_MODULE(dateTimePicker, QBMDatePickerModule)
@implementation QBMDatePickerModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(open:callback:))

-(void)open:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    if (options[@"title"]) {
        self.title = [WXConvert NSString:options[@"title"]];
    }
    if (options[@"titleColor"]) {
        self.titleColor = [WXConvert UIColor:options[@"titleColor"]];
    }
    if (options[@"cancelTitle"]) {
        self.cancelTitle = [WXConvert NSString:options[@"cancelTitle"]];
    }
    if (options[@"confirmTitle"]) {
        self.confirmTitle = [WXConvert NSString:options[@"confirmTitle"]];
    }
    if (options[@"cancelTitleColor"]) {
        self.cancelTitleColor = [WXConvert UIColor:options[@"cancelTitleColor"]];
    }
    if (options[@"confirmTitleColor"]) {
        self.confirmTitleColor = [WXConvert UIColor:options[@"confirmTitleColor"]];
    }
    
    [self createBouncedView:options callback:(WXModuleKeepAliveCallback)callback];
    
}
-(void)createBouncedView:(NSDictionary *)options callback:(WXModuleKeepAliveCallback)callback
{
    self.callback = callback;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [self.pickerView  removeFromSuperview];
    self.pickerView = [[QBMDatePickerView alloc]initWithFrame:CGRectMake(0, 0, Screen_width,Screen_height) withDic:options];
    self.pickerView.delegate = self;
    [window addSubview:self.pickerView];
    if (options[@"value"] && ![options[@"value"] isEqualToString:@""]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [dateFormatter dateFromString:options[@"value"]];
        [self.pickerView showViewWithDate:date animation:YES];
    }
    else{
        [self.pickerView showViewWithDate:nil animation:YES];
    }
    
}

#pragma mark - QBMDatePickerViewDelegate
- (void)datePickerView:(QBMDatePickerView *)datePickerView didSelectDate:(NSDate *)date {
    self.selectedDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *value = [dateFormatter stringFromDate:self.selectedDate];
    if (self.callback) {
        self.callback(@{ @"result": @"success",@"data":value},NO);
        self.callback=nil;
    }
}
-(void)cancleEvent{
    if (self.callback) {
        self.callback(@{ @"result": @"cancel"},NO);
        self.callback = nil;
    }
}
@end

