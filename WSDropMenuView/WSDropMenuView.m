//
//  TWDropMenuView.m
//  WLMenu
//
//  Created by 万匿里 on 15/8/5.
//  Copyright (c) 2015年 万匿里. All rights reserved.
//

#import "WSDropMenuView.h"
#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width [[UIScreen mainScreen] bounds].size.width
#define KBgMaxHeight  Main_Screen_Height
#define KTableViewMaxHeight 300

#define KTopButtonHeight 44



@implementation WSIndexPath

+ (instancetype)twIndexPathWithColumn:(NSInteger)column
                                  row:(NSInteger)row
                                 item:(NSInteger)item
                                 rank:(NSInteger)rank{
    
    WSIndexPath *indexPath = [[self alloc] initWithColumn:column row:row item:item rank:rank];
    
    return indexPath;
}


- (instancetype)initWithColumn:(NSInteger )column
                           row:(NSInteger )row
                          item:(NSInteger )item
                          rank:(NSInteger )rank{
    
    if (self = [super init]) {
        
        self.column = column;
        self.row = row;
        self.item = item;
        self.rank = rank;
        
    }
    
    return self;
}


@end


static NSString *cellIdent = @"cellIdent";

@interface WSDropMenuView ()<UITableViewDataSource,UITableViewDelegate>
{
    
    NSInteger _currSelectColumn;
    NSInteger _currSelectRow;
    NSInteger _currSelectItem;
    NSInteger _currSelectRank;
    
    CGFloat _rightHeight;
    BOOL _isRightOpen;
    BOOL _isLeftOpen;
    
}

@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *leftTableView_1;
@property (nonatomic,strong) UITableView *leftTableView_2;

@property (nonatomic,strong) UITableView *rightTableView;

@property (nonatomic,strong) UIButton *bgButton; //背景

@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@end


@implementation WSDropMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        
        [self _setButton];
        [self _initialize];
        [self _setSubViews];
    }
    return self;
}


- (void)_initialize{
    
    _currSelectColumn = 0;
    _currSelectItem = WSNoFound;
    _currSelectRank = WSNoFound;
    _currSelectRow = WSNoFound;
    _isLeftOpen = NO;
    _isRightOpen = NO;
}


- (void)_setButton{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(0, 0, Main_Screen_Width/2, KTopButtonHeight);
    [self.leftButton setTitle:LeftButtonTitle forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor colorWithWhite:0.004 alpha:1.000] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftButton.frame), 12, 1, 20)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton .frame = CGRectMake(CGRectGetMaxX(self.leftButton .frame)+1, 0, Main_Screen_Width/2, KTopButtonHeight);
    [self.rightButton  setTitle:RightButtonTitle forState:UIControlStateNormal];
    [self.rightButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[UIColor colorWithWhite:0.004 alpha:1.000]  forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.rightButton ];
    
    
    UIView *bottomShadow = [[UIView alloc]
                            initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, Main_Screen_Width, 0.5)];
    bottomShadow.backgroundColor = [UIColor colorWithRed:0.468 green:0.485 blue:0.465 alpha:1.000];
    [self addSubview:bottomShadow];
}

- (void)_setSubViews{
    
    [self addSubview:self.bgButton];
    [self.bgButton addSubview:self.leftTableView];
    [self.bgButton addSubview:self.leftTableView_1];
    [self.bgButton addSubview:self.leftTableView_2];
    [self.bgButton addSubview:self.rightTableView];
    
}


#pragma mark -- public fun -- 
- (void)reloadLeftTableView{
    
    [self.leftTableView reloadData];
}

- (void)reloadRightTableView;
{
    
    [self.rightTableView reloadData];
}

#pragma mark -- getter -- 
- (UITableView *)leftTableView{
    
    if (!_leftTableView) {
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
        _leftTableView.frame = CGRectMake(0, 0, self.bgButton.frame.size.width/3.0, 0);
        _leftTableView.tableFooterView = [[UIView alloc]init];
    }
    
    return _leftTableView;
}

- (UITableView *)leftTableView_1{
    
    if (!_leftTableView_1) {
        
        _leftTableView_1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView_1.delegate = self;
        _leftTableView_1.dataSource = self;
        [_leftTableView_1 registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
        _leftTableView_1.frame = CGRectMake( self.bgButton.frame.size.width/3.0, 0 , self.bgButton.frame.size.width/3.0, 0);
        _leftTableView_1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        _leftTableView_1.tableFooterView = [[UIView alloc]init];

        
    }
    
    return _leftTableView_1;

}

- (UITableView *)leftTableView_2{
    
    
    
    if (!_leftTableView_2) {
        
        _leftTableView_2 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView_2.delegate = self;
        _leftTableView_2.dataSource = self;
        [_leftTableView_2 registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
        _leftTableView_2.frame = CGRectMake( self.bgButton.frame.size.width/3.0 * 2, 0 , self.bgButton.frame.size.width/3.0, 0);
        _leftTableView_2.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        _leftTableView_2.tableFooterView = [[UIView alloc]init];

    }
    
    return _leftTableView_2;
    

    
}

- (UITableView *)rightTableView{
    
    if (!_rightTableView) {
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdent];
        _rightTableView.frame = CGRectMake(0, 0 , self.bgButton.frame.size.width, 0);

        
    }
    
    return _rightTableView;

    
}

- (UIButton *)bgButton{
    
    if (!_bgButton) {
        
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.backgroundColor = [UIColor clearColor];
        _bgButton.frame = CGRectMake(0, KTopButtonHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - KTopButtonHeight);
        [_bgButton addTarget:self action:@selector(bgAction:) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.clipsToBounds = YES;
        
    }
    
    return _bgButton;
}


#pragma mark -- tableViews Change - 
- (void)_hiddenLeftTableViews{
    
    self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.leftTableView.frame.size.width, 0);
    self.leftTableView_1.frame = CGRectMake(self.leftTableView_1.frame.origin.x, self.leftTableView_1.frame.origin.y, self.leftTableView_1.frame.size.width, 0);
    self.leftTableView_2.frame = CGRectMake(self.leftTableView_2.frame.origin.x, self.leftTableView_2.frame.origin.y, self.leftTableView_2.frame.size.width, 0);
   

    
}

- (void)_showLeftTableViews{
    
    self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.leftTableView.frame.size.width, KTableViewMaxHeight);
    self.leftTableView_1.frame = CGRectMake(self.leftTableView_1.frame.origin.x, self.leftTableView_1.frame.origin.y, self.leftTableView_1.frame.size.width, KTableViewMaxHeight);
    self.leftTableView_2.frame = CGRectMake(self.leftTableView_2.frame.origin.x, self.leftTableView_2.frame.origin.y, self.leftTableView_2.frame.size.width, KTableViewMaxHeight);
//    if (_currSelectItem == WSNoFound) {
//        
//        self.leftTableView_1.alpha = 0;
//        self.leftTableView_2.alpha = 0;
//    }
//    if (_currSelectRank == WSNoFound) {
//     
//        self.leftTableView_2.alpha = 0;
//    }
}

- (void)_showRightTableView{
    
    CGFloat height = MIN(_rightHeight, KTableViewMaxHeight);
    
    self.rightTableView.frame = CGRectMake(self.rightTableView.frame.origin.x, self.rightTableView.frame.origin.y, self.rightTableView.frame.size.width, height);
}

- (void)_HiddenRightTableView{
    
    
    self.rightTableView.frame = CGRectMake(self.rightTableView.frame.origin.x, self.rightTableView.frame.origin.y, self.rightTableView.frame.size.width, 0);
}

- (void)_changeTopButton:(NSString *)string{
    
    
    if (_currSelectColumn == 0) {
        
        [self.leftButton setTitle:string forState:UIControlStateNormal];
    }
    if (_currSelectColumn == 1) {
        
        [self.rightButton setTitle:string forState:UIControlStateNormal];
    }
    
}

#pragma mark -- Action ----

- (void)buttonAction:(UIButton *)sender{
    if (self.leftButton == sender) {
        if (_isLeftOpen) {
            _isLeftOpen = !_isLeftOpen;
            [self bgAction:nil];
            return ;
        }
        _currSelectColumn = 0;
        _isLeftOpen = YES;
        _isRightOpen = NO;
        [self _HiddenRightTableView];
        
    }
    if (self.rightButton == sender) {
        
        if (_isRightOpen) {
            _isRightOpen = !_isRightOpen;
            [self bgAction:nil];
            return ;
        }
        
        _currSelectColumn = 1;
        _isRightOpen = YES;
        _isLeftOpen = NO;
        [self _hiddenLeftTableViews];
        
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, Main_Screen_Width, Main_Screen_Height);
    self.bgButton.frame = CGRectMake(self.bgButton.frame.origin.x, self.bgButton.frame.origin.y, self.bounds.size.width, self.bounds.size.height - KTopButtonHeight);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgButton.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];
        
        if (_currSelectColumn == 0) {
            [self _showLeftTableViews];
        }
        if (_currSelectColumn == 1) {
            
            [self _showRightTableView];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bgAction:(UIButton *)sender{

    _isRightOpen = NO;
    _isLeftOpen = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        

        self.bgButton.backgroundColor = [UIColor clearColor];
        [self _hiddenLeftTableViews];
        [self _HiddenRightTableView];

        
    } completion:^(BOOL finished) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, Main_Screen_Width, KTopButtonHeight);
        self.bgButton.frame = CGRectMake(self.bgButton.frame.origin.x, self.bgButton.frame.origin.y, self.bounds.size.width, 0);
        

        
    }];

}


#pragma mark -- DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    WSIndexPath *twIndexPath =[self _getTwIndexPathForNumWithtableView:tableView];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:numberWithIndexPath:)]) {
        
        NSInteger count =  [self.dataSource dropMenuView:self numberWithIndexPath:twIndexPath];
        if (twIndexPath.column == 1) {
            _rightHeight = count * 44.0;
        }
        return count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WSIndexPath *twIndexPath = [self _getTwIndexPathForCellWithTableView:tableView indexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor =  [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.004 alpha:1.000];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
//    [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:titleWithIndexPath:)]) {
        
       cell.textLabel.text =  [self.dataSource dropMenuView:self titleWithIndexPath:twIndexPath];
    }else{
        
        cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    }
    
    
    return cell;
    
}


#pragma mark - tableView delegate - 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self _changeTopButton:cell.textLabel.text ];
    
    if (tableView == self.leftTableView) {
        _currSelectRow = indexPath.row;
        _currSelectItem = WSNoFound;
        _currSelectRank = WSNoFound;
        
        [self.leftTableView_1 reloadData];
        [self.leftTableView_2 reloadData];
    }
    if (tableView == self.leftTableView_1) {
        _currSelectRank = WSNoFound;
        _currSelectItem = indexPath.row;
        [self.leftTableView_2 reloadData];
    }
    
    
    
    if (self.leftTableView_2 == tableView) {
        
        [self bgAction:nil];
        
    }
    if (self.rightTableView == tableView) {
        [self bgAction:nil];
    }
    
    
}



- (WSIndexPath *)_getTwIndexPathForNumWithtableView:(UITableView *)tableView{
    
    
    if (tableView == self.leftTableView) {
        
        return  [WSIndexPath twIndexPathWithColumn:_currSelectColumn row:WSNoFound item:WSNoFound rank:WSNoFound];

    }
    
    if (tableView == self.leftTableView_1 && _currSelectRow != WSNoFound) {
        
        
        return [WSIndexPath twIndexPathWithColumn:_currSelectColumn row:_currSelectRow item:WSNoFound rank:WSNoFound];
    }
    
    if (tableView == self.leftTableView_2 && _currSelectRow != WSNoFound && _currSelectItem != WSNoFound) {
        return [WSIndexPath twIndexPathWithColumn:_currSelectColumn row:_currSelectRow item:_currSelectItem  rank:WSNoFound];
    }
    
    if (tableView == self.rightTableView) {
        
        return [WSIndexPath twIndexPathWithColumn:1 row:WSNoFound item:WSNoFound  rank:WSNoFound];
    }
    
    
    return  0;
}

- (WSIndexPath *)_getTwIndexPathForCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.leftTableView) {
        
        return  [WSIndexPath twIndexPathWithColumn:0 row:indexPath.row item:WSNoFound rank:WSNoFound];
        
    }
    
    if (tableView == self.leftTableView_1) {
        
        
        return [WSIndexPath twIndexPathWithColumn:_currSelectColumn row:_currSelectRow item:indexPath.row rank:WSNoFound];
    }
    
    if (tableView == self.leftTableView_2) {
        return [WSIndexPath twIndexPathWithColumn:_currSelectColumn row:_currSelectRow item:_currSelectItem  rank:indexPath.row];
    }
    
    if (tableView == self.rightTableView) {
        
        return [WSIndexPath twIndexPathWithColumn:1 row:indexPath.row item:WSNoFound  rank:WSNoFound];
    }
    
    
    return  [WSIndexPath twIndexPathWithColumn:0 row:indexPath.row item:WSNoFound rank:WSNoFound];

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}



@end
