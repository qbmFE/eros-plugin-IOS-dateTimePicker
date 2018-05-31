//
//  QBMDatePickerView.h
//  WeexEros
//
//  Created by qbm_ios on 2018/5/24.
//  Copyright © 2018年 qbm Company. All rights reserved.

#import <UIKit/UIKit.h>

/**
 *  日期选择器显示模式。
 */
typedef NS_ENUM(NSInteger, QBMDatePickerViewShowModel) {
    QBMDatePickerViewShowModelDefalut, //显示年，月，日，时，分。
    QBMDatePickerViewShowModelYearMonthDayHour, //显示年，月，日，时。
    QBMDatePickerViewShowModelYearMonthDay, //显示年，月，日。
};

/**
 *  日期选择器时间范围。
 */
typedef NS_ENUM(NSInteger, QBMDatePickerViewDateRangeModel) {
    QBMDatePickerViewDateRangeModelCurrent, //最大时间为当前系统时间。用途：例如选择生日的时候不可能大于当前时间。
    QBMDatePickerViewDateRangeModelCustom //自定义时间范围。可通过下面的属性minYear和maxYear设定。
};

@protocol QBMDatePickerViewDelegate;

@interface QBMDatePickerView : UIView

@property (nonatomic, assign) NSInteger minYear; //时间列表最小年份，不能大于最大年份。默认为1970年。
@property (nonatomic, assign) NSInteger maxYear; //时间列表最大年份，不能小于最小年份。默认为当前年份。注意：仅当属性datePickerViewDateRangeModel的值为QBMDatePickerViewDateRangeModelCustom时才有效。

@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible; //YES:处于显示状态，NO:处于隐藏状态。

@property (nonatomic, assign) QBMDatePickerViewShowModel datePickerViewShowModel; //日期显示模式，默认为QBMDatePickerViewShowModelDefalut。

@property (nonatomic, assign) QBMDatePickerViewDateRangeModel  datePickerViewDateRangeModel; //时间范围模式，默认为QBMDatePickerViewDateRangeModelCurrent。

@property (nonatomic, assign) id<QBMDatePickerViewDelegate> delegate;

/**
 *  显示时间选择器。
 *
 *  @param date 初始显示日期，传nil则默认显示当前日期。
 *  @param animation YES:有动画，NO:无动画。
 */
- (void)showViewWithDate:(NSDate *)date animation:(BOOL)animation;

/**
 *  隐藏时间选择器。
 *
 *  @param animation YES:有动画，NO:无动画。
 */
- (void)hideViewWithAnimation:(BOOL)animation;
- (id)initWithFrame:(CGRect)frame  withDic:(NSDictionary *)dict;
@end

@protocol QBMDatePickerViewDelegate <NSObject>

- (void)datePickerView:(QBMDatePickerView *)datePickerView didSelectDate:(NSDate *)date;
-(void)cancleEvent;
@end

