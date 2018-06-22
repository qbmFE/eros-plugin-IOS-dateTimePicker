//
//  QBMDatePickerView.m
//  WeexEros
//
//  Created by qbm_ios on 2018/5/24.
//  Copyright © 2018年 qbm Company. All rights reserved.


#import "QBMDatePickerView.h"
#import "QBMDefine.h"
#import "QBMUtil.h"

#define QBMTOOLBAR_HEIGHT 45.0*BILI //顶部工具栏高度。
#define QBMROW_HEIGHT 44.0*BILI
#define QBMDURATION 0.3 //动画时长。
#define QBMTITLE_LABEL_START_TAG 1 //从左往右第一个标题Label的Tag值。

@interface QBMDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *datePickerView;
    
    
    //数据源。
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSMutableArray *dayArray;
    NSMutableArray *hourArray;
    NSMutableArray *minuteArray;
    
    //最大值。
    NSInteger maxMonth;
    NSInteger maxDay;
    NSInteger maxHour;
    NSInteger maxMinute;
    
    //最小值
    NSInteger minMonth;
    NSInteger minDay;
    NSInteger minHour;
    NSInteger minMinute;
    
    NSMutableArray *minYearArray;
    NSMutableArray *minMonthArray;
    NSMutableArray *minDayArray;
    NSMutableArray *minHourArray;
    NSMutableArray *minMinuteArray;
    
    //选中行数。
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    NSInteger selectedHourRow;
    NSInteger selectedMinuteRow;
    
    UILabel  *titleLabel;
    CGSize sizeOfYear;
    CGSize sizeOfOther;
    CGSize sizeOfTitle;
}
    @property(nonatomic,strong)UIView *contentView;
    @end
@implementation QBMDatePickerView
    
- (id)initWithFrame:(CGRect)frame  withDic:(NSDictionary *)dict{
    if (self = [super initWithFrame:frame]) {
        NSDictionary *dict16 = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:16*BILIWIDTH],NSFontAttributeName, nil];
        sizeOfYear= [@"2008" sizeWithAttributes:dict16];
        sizeOfOther= [@"20" sizeWithAttributes:dict16];
        
        NSDictionary *dict12 = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:12*BILIWIDTH],NSFontAttributeName, nil];
        sizeOfTitle=[@"年" sizeWithAttributes:dict12];
        UIControl *backGroundView=[[UIControl  alloc]initWithFrame:self.bounds];
        backGroundView.backgroundColor=[UIColor  blackColor];
        [backGroundView addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        backGroundView.alpha=0.65;
        [self  addSubview:backGroundView];
        
        self.contentView=[[UIView alloc]init];
        if (kDevice_Is_iPhoneX)
        {
            self.contentView.frame=CGRectMake(0, backGroundView.frame.size.height-265*BILI-34, Screen_width, 265*BILI+34);
        }
        else{
            self.contentView.frame=CGRectMake(0, backGroundView.frame.size.height-265*BILI, Screen_width, 265*BILI);
        }
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self  addSubview:self.contentView];
        
        _visible = NO;
        _datePickerViewShowModel = QBMDatePickerViewShowModelDefalut;
        _datePickerViewDateRangeModel = QBMDatePickerViewDateRangeModelCustom;
        [self __initView:(NSDictionary *)dict];
        [self __initData:(NSDictionary *)dict];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = self.contentView.frame.size.width;
    CGFloat height = self.contentView.frame.size.height;
    if (kDevice_Is_iPhoneX)
    {
        datePickerView.frame = CGRectMake(0, QBMTOOLBAR_HEIGHT,width, height - QBMTOOLBAR_HEIGHT-34);
    }
    else{
        datePickerView.frame = CGRectMake(0, QBMTOOLBAR_HEIGHT,width, height - QBMTOOLBAR_HEIGHT);
    }
    
}
    
- (void)__initView:(NSDictionary *)dict {
    
    
    //顶部工具栏。
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((Screen_width-200)/2, 0, 200, QBMTOOLBAR_HEIGHT)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    if (dict[@"title"]) {
        titleLabel.text=[NSString  stringWithFormat:@"%@",dict[@"title"]];
    }
    else{
        titleLabel.text=@"";
    }
    if (dict[@"titleColor"]) {
        [titleLabel setTextColor:[QBMUtil colorWithHexString:dict[@"titleColor"]]];
    }
    else{
        [titleLabel setTextColor:[QBMUtil colorWithHexString:@"#313131"]];
    }
    [titleLabel setFont:[UIFont systemFontOfSize:15.0*BILIWIDTH]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:titleLabel];
    
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRectMake(0, 0,(Screen_width-200)/2 , QBMTOOLBAR_HEIGHT);
    if (dict[@"cancelTitle"] && ![dict[@"cancelTitle"] isEqualToString:@""]) {
        [cancel setTitle:[NSString  stringWithFormat:@"%@",dict[@"cancelTitle"]] forState:UIControlStateNormal];
    }
    else{
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
    }
    if (dict[@"cancelTitleColor"] && ![dict[@"cancelTitleColor"] isEqualToString:@""]) {
        [cancel setTitleColor:[QBMUtil  colorWithHexString:dict[@"cancelTitleColor"]] forState:UIControlStateNormal];
    }
    else{
        [cancel setTitleColor:[QBMUtil  colorWithHexString:@"#313131"] forState:UIControlStateNormal];
    }
    cancel.titleLabel.font = [UIFont systemFontOfSize:15*BILIWIDTH];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    cancel.tag = 100;
    [self.contentView  addSubview:cancel];
    
    UIButton * confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    confirm.frame=CGRectMake(Screen_width-(Screen_width-200)/2, 0,(Screen_width-200)/2, QBMTOOLBAR_HEIGHT);
    
    if (dict[@"confirmTitle"] && ![dict[@"confirmTitle"] isEqualToString:@""]) {
        [confirm setTitle:[NSString  stringWithFormat:@"%@",dict[@"confirmTitle"]] forState:UIControlStateNormal];
    }
    else{
        [confirm setTitle:@"完成" forState:UIControlStateNormal];
    }
    if (dict[@"confirmTitleColor"] && ![dict[@"confirmTitleColor"] isEqualToString:@""]) {
        [confirm setTitleColor:[QBMUtil  colorWithHexString:dict[@"confirmTitleColor"]] forState:UIControlStateNormal];
    }
    else{
        [confirm setTitleColor:[QBMUtil  colorWithHexString:@"#00B4FF"] forState:UIControlStateNormal];
    }
    
    confirm.titleLabel.font = [UIFont systemFontOfSize:15*BILIWIDTH];
    [confirm addTarget:self action:@selector(completion) forControlEvents:UIControlEventTouchUpInside];
    confirm.tag = 200;
    [self.contentView addSubview:confirm];
    
    //分割线
    UIView *lineView=[[UIView  alloc]initWithFrame:CGRectMake(0, QBMTOOLBAR_HEIGHT-0.5, self.frame.size.width, 0.5)];
    lineView.backgroundColor=[QBMUtil  colorWithHexString:@"#e5e5e5"];
    [self.contentView  addSubview:lineView];
    
    //UIPickerView.
    datePickerView = [[UIPickerView alloc]init];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.showsSelectionIndicator = YES;
    datePickerView.delegate = self;
    datePickerView.dataSource = self;
    [self.contentView addSubview:datePickerView];
    
    //年月日
    // CGFloat   frameOri=0.0f;
    NSArray *titleArray=[NSArray  arrayWithObjects:@"年", @"月",@"日",@":",nil];
    for(int i=0;i<4;i++){
        UILabel *lable=[[UILabel  alloc]init];
        lable.textAlignment=NSTextAlignmentCenter;
        lable.font=[UIFont systemFontOfSize:12*BILIWIDTH];
        lable.textColor=[QBMUtil  colorWithHexString:@"#666666"];
        lable.text=[NSString  stringWithFormat:@"%@",titleArray[i]];
        [self.contentView  addSubview:lable];
        
        switch (i) {
            case 0:
            lable.frame=CGRectMake(70*BILIWIDTH, 133*BILI, sizeOfTitle.width, QBMROW_HEIGHT);
            break;
            case 1:
            lable.frame=CGRectMake(133*BILIWIDTH, 133*BILI, sizeOfTitle.width, QBMROW_HEIGHT);
            break;
            case 2:
            lable.frame=CGRectMake(190*BILIWIDTH, 133*BILI, sizeOfTitle.width, QBMROW_HEIGHT);
            break;
            case 3:
            lable.frame=CGRectMake(285*BILIWIDTH, 133*BILI, sizeOfTitle.width, QBMROW_HEIGHT);
            break;
            default:
            break;
        }
    }
}
- (void)__initData:(NSDictionary *)dict {
    //初始化最大值。
    NSDate *minDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    if (dict[@"min"] && ![dict[@"min"] isEqualToString:@""]) {
        minDate = [formatter dateFromString:[NSString  stringWithFormat:@"%@",dict[@"min"]]];
    }
    else{
        minDate = [formatter dateFromString:@"1900-12-31 00:00"];
    }
    NSDate* maxDate;
    if (dict[@"max"] && ![dict[@"max"] isEqualToString:@""]) {
        maxDate = [formatter dateFromString:[NSString  stringWithFormat:@"%@",dict[@"max"]]];
    }
    else{
        maxDate = [formatter dateFromString:@"2099-12-31 23:59"];
    }
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *minDateComponents = [calendar components:calendarUnit fromDate:minDate];
    _minYear = [minDateComponents year];
    minMonth = [minDateComponents month];
    minDay= [minDateComponents day];
    minHour = [minDateComponents hour];
    minMinute = [minDateComponents minute];
    //初始化最小时间。
    
    NSInteger oriMonth = minMonth;
    NSInteger oriDay = minDay;
    NSInteger oriHour = minHour;
    NSInteger oriMinute = minMinute;
    //初始化最小月  天 时分
    minMonthArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < (12-oriMonth+1); i++) {
        [minMonthArray addObject:[NSString stringWithFormat:@"%ld",oriMonth+i]];
    }
    minDayArray = [[NSMutableArray alloc]init];
    
    int days=31;
    if (oriMonth==2) {
        //2月份的处理
        if (((_minYear % 4 == 0 && _minYear % 100 != 0 ))|| (_minYear % 400 == 0)) {
            //最小年是闰年
            days = 29;
        }
        else
        {
            days = 28;
        }
    }
    for (NSInteger i = 0; i < (days-oriDay+1); i++) {
        [minDayArray addObject:[NSString stringWithFormat:@"%ld",oriDay+i]];
    }
    
    minHourArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < (23-oriHour+1); i++) {
        [minHourArray addObject:[NSString stringWithFormat:@"%ld",oriHour+i]];
    }
    minMinuteArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < (59-oriMinute+1); i++) {
        [minMinuteArray addObject:[NSString stringWithFormat:@"%ld",oriMinute+i]];
    }
    
    NSDateComponents *currentDateComponents = [calendar components:calendarUnit fromDate:maxDate];
    _maxYear = [currentDateComponents year];
    maxMonth = [currentDateComponents month];
    maxDay = [currentDateComponents day];
    maxHour = [currentDateComponents hour];
    maxMinute = [currentDateComponents minute];
    //初始化最大时间。
    NSInteger lastYear = _maxYear;
    NSInteger lastMonth = maxMonth;
    NSInteger lastDay = maxDay;
    NSInteger lastHour = maxHour;
    NSInteger lastMinute = maxMinute;
    
    //初始化年份数组(范围自定义)。
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = _minYear; i <= lastYear; i ++) {
        [yearArray addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
    //初始化月份数组(1-12)。
    monthArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i <= lastMonth; i++) {
        [monthArray addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
    //初始化天数数组(1-31)。
    dayArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1; i <= lastDay; i++) {
        [dayArray addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
    //初始化小时数组(0-23)。
    hourArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= lastHour; i++) {
        [hourArray addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
    //初始化分钟数组(0-59)。
    minuteArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i <= lastMinute; i++) {
        [minuteArray addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
}
    
#pragma mark - Public
- (void)showViewWithDate:(NSDate *)date animation:(BOOL)animation{
    [self __showWithAnimation:animation];
    
    if (!date) {
        date = [NSDate date];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponents = [calendar components:calendarUnit fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger hour = [dateComponents hour];
    NSInteger minute = [dateComponents minute];
    //加0处理
    NSString *monthStr;
    NSString *dayStr;
    NSString *hourStr;
    NSString *minuteStr;
    monthStr=month<10?[NSString stringWithFormat:@"0%ld",month]:[NSString stringWithFormat:@"%ld",month];
    dayStr=day<10?[NSString stringWithFormat:@"0%ld",day]:[NSString stringWithFormat:@"%ld",day];
    hourStr=hour<10?[NSString stringWithFormat:@"0%ld",hour]:[NSString stringWithFormat:@"%ld",hour];
    minuteStr=minute<10?[NSString stringWithFormat:@"0%ld",minute]:[NSString stringWithFormat:@"%ld",minute];
    
    if (_datePickerViewDateRangeModel == QBMDatePickerViewDateRangeModelCurrent) {
        //更新时间最大值为当前系统时间。
        NSDateComponents *currentDateComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
        _maxYear = [currentDateComponents year];
        maxMonth = [currentDateComponents month];
        maxDay = [currentDateComponents day];
        maxHour = [currentDateComponents hour];
        maxMinute = [currentDateComponents minute];
        
        /**
         *  显示时间是否小于等于当前系统时间。
         *  PS:这里比较时间之所以不用earlierDate:或laterDate:方法，是因为这里没有比较秒数。
         */
        BOOL isEarly = NO;
        if (year == _maxYear && month == maxMonth && day == maxDay && hour == maxHour && minute && maxMinute) {
            //相等情况。
            isEarly = YES;
        }else {
            if (year < _maxYear) {
                isEarly = YES;
            }else if (month < maxMonth) {
                isEarly = YES;
            }else if (day < maxDay) {
                isEarly = YES;
            }else if (hour < maxHour) {
                isEarly = YES;
            }else if (minute < maxMinute) {
                isEarly = YES;
            }
        }
        NSAssert(isEarly, @"当前模式下不允许显示时间大于当前系统时间，如有需要请更换时间范围模式！");
        
    }else if (_datePickerViewDateRangeModel == QBMDatePickerViewDateRangeModelCustom) {
        /**
         *  下面两个步骤，可以根据自己需要自选一个。
         *  步骤1:限定最大年份，如果超出大值则终止。
         *  步骤2:如果超出最大年份，则更新最大年份值继续显示。
         *
         *  PS:这里选择步骤2.
         */
        
        /*
         
         //步骤1.
         NSAssert(_maxYear > year, @"年份超出最大范围，如有需要请更新最大年份范围！");
         
         */
        
        //步骤2。
        if (year > _maxYear) {
            _maxYear = year;
        }
    }
    
    
    [self resetYearArray];
    [self resetMonthArrayWithYear:year];
    [self resetDayArrayWithYear:year month:month];
    [self resetHourArrayWithYear:year month:month day:day];
    [self resetMinuteArrayWithYear:year month:month day:day hour:hour];
    [datePickerView reloadAllComponents];
    
    if (_minYear>year || (_minYear==year && minMonth>month) || (_minYear==year && minMonth==month && minDay>day)) {
        //        UIAlertView *alertView= [[UIAlertView  alloc]initWithTitle:@"提示" message:@"数据异常！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alertView show];
        //        return;
        
        [datePickerView selectRow:0 inComponent:0 animated:YES];
        [datePickerView selectRow:0 inComponent:1 animated:YES];
        [datePickerView selectRow:0 inComponent:2 animated:YES];
        
        if (_datePickerViewShowModel == QBMDatePickerViewShowModelDefalut) {
            [datePickerView selectRow:0 inComponent:3 animated:YES];
            [datePickerView selectRow:0 inComponent:4 animated:YES];
        }else if (_datePickerViewShowModel == QBMDatePickerViewShowModelYearMonthDayHour) {
            [datePickerView selectRow:0 inComponent:3 animated:YES];
        }
        //赋值
        selectedYearRow=0;
        selectedMonthRow=0;
        selectedDayRow=0;
        selectedHourRow=0;
        selectedMinuteRow=0;
    }
    else{
        [datePickerView selectRow:[yearArray indexOfObject:[NSString stringWithFormat:@"%ld",year]] inComponent:0 animated:YES];
        [datePickerView selectRow:[monthArray indexOfObject:monthStr] inComponent:1 animated:YES];
        [datePickerView selectRow:[dayArray indexOfObject:dayStr] inComponent:2 animated:YES];
        
        if (_datePickerViewShowModel == QBMDatePickerViewShowModelDefalut) {
            if ([hourArray containsObject:hourStr]) {
                [datePickerView selectRow:[hourArray indexOfObject:hourStr] inComponent:3 animated:YES];
            }
            if ([minuteArray containsObject:minuteStr]) {
                [datePickerView selectRow:[minuteArray indexOfObject:minuteStr] inComponent:4 animated:YES];
            }
            
        }else if (_datePickerViewShowModel == QBMDatePickerViewShowModelYearMonthDayHour) {
            [datePickerView selectRow:[hourArray indexOfObject:hourStr] inComponent:3 animated:YES];
        }
        //赋值
        selectedYearRow=[yearArray indexOfObject:[NSString stringWithFormat:@"%ld",year]];
        selectedMonthRow=[monthArray indexOfObject:monthStr];
        selectedDayRow=[dayArray indexOfObject:dayStr];
        selectedHourRow=[hourArray indexOfObject:hourStr];
        selectedMinuteRow=[minuteArray indexOfObject:minuteStr];
        
    }
    
}
    
- (void)hideViewWithAnimation:(BOOL)animation {
    [self __hideWithAnimation:animation];
}
    
#pragma mark - Private
    /**
     *  除了重置年份外，月、天、时和分均在原有基础上新增或减少，避免过多无谓的循环。
     */
    
#pragma mark 重置年份
- (void)resetYearArray
    {
        //先判断是否需要重置。
        NSInteger minYear =_minYear;
        NSInteger maxYear = _maxYear;
        if (_minYear == minYear && _maxYear == maxYear) {
            return;
        }
        
        [yearArray removeAllObjects];
        for (NSInteger i = _minYear; i <= _maxYear; i++) {
            [yearArray addObject:[NSString stringWithFormat:@"%ld",i]];
        }
        
        //重置年份选中行，防止越界。
        selectedYearRow = selectedYearRow > [yearArray count] - 1 ? [yearArray count] - 1 : selectedYearRow;
    }
    
#pragma mark 重置月份
- (void)resetMonthArrayWithYear:(NSInteger)year
    {
        NSInteger totalMonth = 12;
        NSInteger origMonth = 1;
        [monthArray  removeAllObjects];
        if(_minYear == year){
            origMonth = minMonth; //限制月份。
            NSInteger lastMonth=12;
            if(_maxYear == _minYear) {
                lastMonth=maxMonth;
            }
            for (NSInteger i=0; i<(lastMonth-origMonth+1);i++) {
                
                if (origMonth+i<10) {
                    [monthArray addObject:[NSString stringWithFormat:@"0%d",origMonth+i]];
                }
                else{
                    [monthArray addObject:[NSString stringWithFormat:@"%d",origMonth+i]];
                }
            }
        }
        else if (_maxYear == year) {
            totalMonth = maxMonth; //限制月份。
            for (NSInteger i=1; i<=totalMonth;i++) {
                if (i<10) {
                    [monthArray addObject:[NSString stringWithFormat:@"0%d",i]];
                }
                else{
                    [monthArray addObject:[NSString stringWithFormat:@"%d",i]];
                }
            }
        }
        else{
            for ( int i=0; i< 12; i++) {
                if (i+1<10) {
                    [monthArray addObject:[NSString stringWithFormat:@"0%d",i+1]];
                }
                else{
                    [monthArray addObject:[NSString stringWithFormat:@"%d",i+1]];
                }
            }
        }
        //重置月份选中行，防止越界。
        selectedMonthRow = selectedMonthRow > [monthArray count] - 1 ? [monthArray count] - 1: selectedMonthRow;
    }
    
#pragma mark 重置天数
- (void)resetDayArrayWithYear:(NSInteger)year month:(NSInteger)month {
    NSInteger oriDay=0;
    NSInteger totalDay = 0;
    [dayArray  removeAllObjects];
    if (_minYear == year && minMonth == month) {
        oriDay = minDay;
        totalDay=[self  getDaysWithSelectYear:_minYear andMonth:minMonth];
        if (_minYear ==_maxYear) {
            //最大年与最小年相同 且月份相同
            totalDay=maxDay;
        }
        for (NSInteger i=0; i<(totalDay-oriDay+1);i++) {
            
            if (oriDay+i<10) {
                [dayArray addObject:[NSString stringWithFormat:@"0%d",oriDay+i]];
            }
            else{
                [dayArray addObject:[NSString stringWithFormat:@"%d",oriDay+i]];
            }
        }
    }
    else if (_maxYear == year) {
        
        if (_maxYear == year && maxMonth == month) {
            totalDay = maxDay; //限制最大天数。
        }else {
            totalDay=[self  getDaysWithSelectYear:year andMonth:month];
        }
        
        for (int i=0; i<totalDay; i++) {
            if (i+1<10) {
                [dayArray addObject:[NSString stringWithFormat:@"0%d",i+1]];
            }
            else{
                [dayArray addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
        }
    }
    else{
        totalDay=[self  getDaysWithSelectYear:year andMonth:month];
        for (NSInteger i=0; i<totalDay;i++) {
            if (i+1<10) {
                [dayArray addObject:[NSString stringWithFormat:@"0%d",i+1]];
            }
            else{
                [dayArray addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
        }
    }
    
    //重置天数选中行，防止越界。
    selectedDayRow = selectedDayRow > [dayArray count] - 1 ? [dayArray count] - 1 : selectedDayRow;
}
    
#pragma mark 重置小时
- (void)resetHourArrayWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSInteger totalHour = 23;
    NSInteger oriHour=0;
    [hourArray  removeAllObjects];
    
    if(_minYear == year && minMonth == month && minDay == day){
        oriHour = minHour;
        //最大年与最小年相同 且月份相同  天数相同（2018.5.30 9：00-2018.5.30 19：00）
        if (_maxYear==_minYear) {
            totalHour=maxHour;
        }
        for (NSInteger i=0; i<(totalHour-oriHour+1);i++) {
            if (oriHour+i<10) {
                [hourArray addObject:[NSString stringWithFormat:@"0%ld",oriHour+i]];
            }
            else{
                [hourArray addObject:[NSString stringWithFormat:@"%ld",oriHour+i]];
            }
        }
    }
    else if (_maxYear == year) {
        if (_maxYear == year && maxMonth == month && maxDay == day) {
            totalHour = maxHour; //限制小时。
        }
        for (int i=0; i<=totalHour; i++) {
            if (i<10) {
                [hourArray addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else{
                [hourArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    else{
        for (int i=0; i<=totalHour; i++) {
            
            if (i<10) {
                [hourArray addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else{
                [hourArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    //重置小时选中行，防止越界。
    selectedHourRow = selectedHourRow > [hourArray count] - 1 ? [hourArray count] - 1 : selectedHourRow;
}
    
#pragma mark 重置分钟
- (void)resetMinuteArrayWithYear:(NSInteger)year
                           month:(NSInteger)month
                             day:(NSInteger)day
                            hour:(NSInteger)hour {
    NSInteger oriMinute=0;
    NSInteger totalMinute = 59;
    [minuteArray  removeAllObjects];
    if (_minYear == year && minMonth == month && minDay == day && minHour == hour){
        oriMinute = minMinute;
        for (NSInteger i=0; i<(totalMinute-oriMinute+1);i++) {
            if (oriMinute+i<10) {
                [minuteArray addObject:[NSString stringWithFormat:@"0%ld",oriMinute+i]];
            }
            else{
                [minuteArray addObject:[NSString stringWithFormat:@"%ld",oriMinute+i]];
            }
            
        }
    }
    else  if (_maxYear == year) {
        if (_maxYear == year && maxMonth == month && maxDay == day && maxHour == hour) {
            totalMinute = maxMinute; //限制分钟。
        }
        for (int i=0; i<=totalMinute; i++) {
            if (i<10) {
                [minuteArray addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else{
                [minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    
    else{
        for (int i=0; i<=totalMinute; i++) {
            
            if (i<10) {
                [minuteArray addObject:[NSString stringWithFormat:@"0%d",i]];
            }
            else{
                [minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
    }
    //重置分钟选中行，防止越界。
    selectedMinuteRow = selectedHourRow > [minuteArray count] - 1 ? [minuteArray count] - 1 : selectedMinuteRow;
}
-(int)getDaysWithSelectYear:(NSInteger)year andMonth:(NSInteger)month{
    
    int totalDay;
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        totalDay = 31;
    }
    else if(month == 2)
    {
        if (((year % 4 == 0 && year % 100 != 0 ))|| (year % 400 == 0)) {
            totalDay = 29;
        }
        else
        {
            totalDay = 28;
        }
    }
    else
    {
        totalDay = 30;
    }
    return totalDay;
}
#pragma mark 取消
- (void)cancel {
    
    [self __hideWithAnimation:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(cancleEvent)]) {
        [_delegate cancleEvent];
    }
}
    
#pragma mark 完成
- (void)completion {
    NSDateComponents *dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setYear:[[yearArray objectAtIndex:[datePickerView selectedRowInComponent:0]] integerValue]];
    [dateComponents setMonth:[[monthArray objectAtIndex:[datePickerView selectedRowInComponent:1]] integerValue]];
    [dateComponents setDay:[[dayArray objectAtIndex:[datePickerView selectedRowInComponent:2]] integerValue]];
    if (_datePickerViewShowModel == QBMDatePickerViewShowModelDefalut) {
        [dateComponents setHour:[[hourArray objectAtIndex:[datePickerView selectedRowInComponent:3]] integerValue]];
        [dateComponents setMinute:[[minuteArray objectAtIndex:[datePickerView selectedRowInComponent:4]] integerValue]];
    }else if (_datePickerViewShowModel == QBMDatePickerViewShowModelYearMonthDayHour) {
        [dateComponents setHour:[[hourArray objectAtIndex:[datePickerView selectedRowInComponent:3]] integerValue]];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    if (_delegate && [_delegate respondsToSelector:@selector(datePickerView:didSelectDate:)]) {
        [_delegate datePickerView:self didSelectDate:selectedDate];
    }
    
    [self __hideWithAnimation:YES];
}
    
#pragma mark 显示
- (void)__showWithAnimation:(BOOL)animation {
    _visible = YES;
    
    UIView *spView = self.superview;
    CGFloat originY = CGRectGetHeight(spView.frame) - CGRectGetHeight(self.frame);
    if (animation) {
        [UIView animateWithDuration:QBMDURATION animations:^{
            self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
        }];
    }else {
        self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
    }
    
}
    
#pragma mark 隐藏
- (void)__hideWithAnimation:(BOOL)animation {
    
    [UIView animateWithDuration:QBMDURATION animations:^{
        [self removeFromSuperview];
    }];
}
    
#pragma mark 更新但前时间数组中的数据
- (void)updateCurrentDateArray {
    //获取当前选中时间。
    NSInteger currentYear = [[yearArray objectAtIndex:selectedYearRow] integerValue];
    NSInteger currentMonth = [[monthArray objectAtIndex:selectedMonthRow] integerValue];
    NSInteger currentDay = [[dayArray objectAtIndex:selectedDayRow] integerValue];
    NSInteger currentHour = [[hourArray objectAtIndex:selectedHourRow] integerValue];
    
    //更新时间数组中的数据。
    [self resetYearArray];
    [self resetMonthArrayWithYear:currentYear];
    [self resetDayArrayWithYear:currentYear month:currentMonth];
    [self resetHourArrayWithYear:currentYear month:currentMonth day:currentDay];
    [self resetMinuteArrayWithYear:currentYear month:currentMonth day:currentDay hour:currentHour];
}
    
#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    switch (_datePickerViewShowModel) {
        case QBMDatePickerViewShowModelDefalut:
        return 5;
        break;
        case QBMDatePickerViewShowModelYearMonthDay:
        return 3;
        break;
        case QBMDatePickerViewShowModelYearMonthDayHour:
        return 4;
        break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
    {
        
        switch (component) {
            case 0:
            return 83*BILIWIDTH;
            break;
            case 1:
            return 60*BILIWIDTH;
            break;
            case 2:
            return 57*BILIWIDTH;
            break;
            case 3:
            return 70*BILIWIDTH;
            break;
            case 4:
            return  Screen_width-(83+60+57+70)*BILIWIDTH;
            break;
            default:
            return 0;
            break;
        }
        
        
    }
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
        return [yearArray count];
        break;
        case 1:
        return [monthArray count];
        break;
        case 2:
        return [dayArray count];
        break;
        case 3:
        return [hourArray count];
        break;
        case 4:
        return [minuteArray count];
        break;
        default:
        return 0;
        break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return QBMROW_HEIGHT;
}
    
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
    {
        UILabel *pickerLabel = (UILabel *)view;
        if (pickerLabel == nil) {
            CGFloat labelWidth = 0.0;
            pickerLabel = [[UILabel alloc]init];
            pickerLabel.backgroundColor = [UIColor clearColor];
            pickerLabel.font = [UIFont systemFontOfSize:16*BILIWIDTH];
            pickerLabel.textColor=[QBMUtil colorWithHexString:@"#313131"];
            pickerLabel.textAlignment = NSTextAlignmentCenter;
            switch (_datePickerViewShowModel) {
                case QBMDatePickerViewShowModelDefalut:
                {
                    switch (component) {
                        case 0:
                        labelWidth=sizeOfYear.width+10*BILIWIDTH;
                        pickerLabel.frame=CGRectMake(25*BILIWIDTH, 0.0f, labelWidth, QBMROW_HEIGHT);
                        pickerLabel.textAlignment = NSTextAlignmentRight;
                        break;
                        case 1:
                        labelWidth=sizeOfOther.width+10*BILIWIDTH;
                        pickerLabel.frame=CGRectMake(20*BILIWIDTH, 0.0f, labelWidth, QBMROW_HEIGHT);
                        break;
                        case 2:
                        labelWidth=sizeOfOther.width+10*BILIWIDTH;
                        pickerLabel.frame=CGRectMake(20*BILIWIDTH, 0.0f, labelWidth, QBMROW_HEIGHT);
                        pickerLabel.textAlignment = NSTextAlignmentLeft;
                        break;
                        case 3:
                        labelWidth=sizeOfOther.width+10*BILIWIDTH;
                        pickerLabel.frame=CGRectMake(60*BILIWIDTH, 0.0f, labelWidth, QBMROW_HEIGHT);
                        pickerLabel.textAlignment = NSTextAlignmentRight;
                        break;
                        case 4:
                        labelWidth=sizeOfOther.width+10*BILIWIDTH;
                        pickerLabel.frame=CGRectMake(0.0f, 0.0f, labelWidth, QBMROW_HEIGHT);
                        pickerLabel.textAlignment = NSTextAlignmentLeft;
                        break;
                        default:
                        break;
                    }
                }
                break;
                case QBMDatePickerViewShowModelYearMonthDay:
                labelWidth = CGRectGetWidth(pickerView.frame) / 3;
                pickerLabel.frame=CGRectMake(0.0f, 0.0f, labelWidth, QBMROW_HEIGHT);
                break;
                case QBMDatePickerViewShowModelYearMonthDayHour:
                labelWidth = CGRectGetWidth(pickerView.frame) / 4;
                pickerLabel.frame=CGRectMake(0.0f, 0.0f, labelWidth, QBMROW_HEIGHT);
                break;
            }
        }
        
        switch (component) {
            case 0:
            
            pickerLabel.text = [yearArray objectAtIndex:row];
            break;
            case 1:
            pickerLabel.text = [monthArray objectAtIndex:row];
            break;
            case 2:
            pickerLabel.text = [dayArray objectAtIndex:row];
            break;
            case 3:
            pickerLabel.text = [hourArray objectAtIndex:row];
            break;
            case 4:
            pickerLabel.text = [minuteArray objectAtIndex:row];
            break;
            default:
            break;
        }
        
        return pickerLabel;
    }
    
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            selectedYearRow = row;
            
            NSInteger selectedYear = [[yearArray objectAtIndex:row] integerValue]; //获取选择的年份。
            [self resetMonthArrayWithYear:selectedYear]; //重置月份。
            
            NSInteger selectedMonth = [[monthArray objectAtIndex:selectedMonthRow] integerValue]; //获取选择的月份。
            [self resetDayArrayWithYear:selectedYear month:selectedMonth]; //重置天数。
            
            if (_datePickerViewShowModel == QBMDatePickerViewShowModelDefalut) {
                NSInteger selectedDay = [[dayArray objectAtIndex:selectedDayRow] integerValue]; //获取选择的天数。
                [self resetHourArrayWithYear:selectedYear month:selectedMonth day:selectedDay]; //重置小时。
                
                NSInteger selectedHour = [[hourArray objectAtIndex:selectedHourRow] integerValue]; //获取选择的小时。
                [self resetMinuteArrayWithYear:selectedYear month:selectedMonth day:selectedDay hour:selectedHour]; //重置分钟。
                
            }else if (_datePickerViewShowModel == QBMDatePickerViewShowModelYearMonthDayHour) {
                NSInteger selectedDay = [[dayArray objectAtIndex:selectedDayRow] integerValue]; //获取选择的天数。
                [self resetHourArrayWithYear:selectedYear month:selectedMonth day:selectedDay]; //重置小时。
            }
            
            [pickerView reloadAllComponents];
        }
        break;
        case 1:
        {
            selectedMonthRow = row;
            
            NSInteger selectedMonth = [[monthArray objectAtIndex:row]integerValue];
            NSInteger selectedYear = [[yearArray objectAtIndex:selectedYearRow] intValue];
            [self resetDayArrayWithYear:selectedYear month:selectedMonth]; //重置天数
            
            if (_datePickerViewShowModel == QBMDatePickerViewShowModelDefalut) {
                NSInteger selectedDay = [[dayArray objectAtIndex:selectedDayRow] integerValue]; //获取选择的天数。
                [self resetHourArrayWithYear:selectedYear month:selectedMonth day:selectedDay]; //重置小时。
                
                NSInteger selectedHour = [[hourArray objectAtIndex:selectedHourRow] integerValue]; //获取选择的小时。
                [self resetMinuteArrayWithYear:selectedYear month:selectedMonth day:selectedDay hour:selectedHour]; //重置分钟。
                
            }else if (_datePickerViewShowModel == QBMDatePickerViewShowModelYearMonthDayHour) {
                NSInteger selectedDay = [[dayArray objectAtIndex:selectedDayRow] integerValue]; //获取选择的天数。
                [self resetHourArrayWithYear:selectedYear month:selectedMonth day:selectedDay]; //重置小时。
            }
            
            [pickerView reloadAllComponents];
        }
        break;
        case 2:
        {
            selectedDayRow = row;
            
            
            NSInteger selectedDay = [[dayArray objectAtIndex:row] integerValue];
            NSInteger selectedYear = [[yearArray objectAtIndex:selectedYearRow] integerValue];
            NSInteger selectedMonth = [[monthArray objectAtIndex:selectedMonthRow] integerValue];
            if (_datePickerViewShowModel == QBMDatePickerViewShowModelDefalut) {
                [self resetHourArrayWithYear:selectedYear month:selectedMonth day:selectedDay]; //重置小时。
                
                NSInteger selectedHour = [[hourArray objectAtIndex:selectedHourRow] integerValue]; //获取选择的小时。
                [self resetMinuteArrayWithYear:selectedYear month:selectedMonth day:selectedDay hour:selectedHour]; //重置分钟。
                
            }else if (_datePickerViewShowModel == QBMDatePickerViewShowModelYearMonthDayHour) {
                [self resetHourArrayWithYear:selectedYear month:selectedMonth day:selectedDay]; //重置小时。
            }
            
            [pickerView reloadAllComponents];
        }
        break;
        case 3:
        {
            selectedHourRow = row;
            
            NSInteger selectedHour = [[hourArray objectAtIndex:row] integerValue];
            NSInteger selectedYear = [[yearArray objectAtIndex:selectedYearRow] integerValue];
            NSInteger selectedMonth = [[monthArray objectAtIndex:selectedMonthRow] integerValue];
            NSInteger selectedDay = [[dayArray objectAtIndex:selectedDayRow] integerValue];
            if (_datePickerViewShowModel == QBMDatePickerViewShowModelDefalut) {
                [self resetMinuteArrayWithYear:selectedYear month:selectedMonth day:selectedDay hour:selectedHour]; //重置分钟。
                
            }
            
            [pickerView reloadAllComponents];
        }
        break;
        case 4:
        break;
        default:
        break;
    }
}
    
#pragma mark - Setter
- (void)setMinYear:(NSInteger)minYear {
    NSAssert(minYear < _maxYear, @"最小年份必须小于最大年份！");
    
    _minYear = minYear;
    
    [self resetYearArray];
    [datePickerView reloadAllComponents];
}
    
- (void)setMaxYear:(NSInteger)maxYear {
    NSAssert(maxYear > _minYear, @"最大年份必须大于最小年份！");
    NSAssert(_datePickerViewDateRangeModel == QBMDatePickerViewDateRangeModelCustom, @"当前模式下只允许显示当前系统最大时间，所以不允许设置最大年份！");
    
    //更新最大值。
    _maxYear = maxYear;
    
    [self updateCurrentDateArray];
    [datePickerView reloadAllComponents];
}
    
- (void)setDatePickerViewShowModel:(QBMDatePickerViewShowModel)datePickerViewShowModel {
    _datePickerViewShowModel = datePickerViewShowModel;
    [datePickerView reloadAllComponents];
    
}
    
- (void)setDatePickerViewDateRangeModel:(QBMDatePickerViewDateRangeModel)datePickerViewDateRangeModel {
    QBMDatePickerViewDateRangeModel tempModel = datePickerViewDateRangeModel;
    _datePickerViewDateRangeModel = datePickerViewDateRangeModel;
    
    if (tempModel == QBMDatePickerViewDateRangeModelCurrent) {
        //更新时间最大值为当前系统时间。
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSCalendarUnit calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSDateComponents *currentDateComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
        
        _maxYear = [currentDateComponents year];
        maxMonth = [currentDateComponents month];
        maxDay = [currentDateComponents day];
        maxHour = [currentDateComponents hour];
        maxMinute = [currentDateComponents minute];
        
    }else if (tempModel == QBMDatePickerViewDateRangeModelCustom) {
        //年份不变，其它更新为最大值。
        maxMonth = 12;
        maxDay = 31;
        maxHour = 23;
        maxMinute = 59;
    }
    
    [self updateCurrentDateArray];
    [datePickerView reloadAllComponents];
}
    @end


