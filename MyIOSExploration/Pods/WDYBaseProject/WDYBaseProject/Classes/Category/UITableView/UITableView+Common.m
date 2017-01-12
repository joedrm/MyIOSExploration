
#import "UITableView+Common.h"

@implementation UITableView (Common)

- (void)addRadiusforCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)])
    {
        CGFloat cornerRadius = 5.f;
        
        cell.backgroundColor = UIColor.clearColor;
        
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        CGRect bounds = CGRectInset(cell.bounds, 0, 0);
        
        BOOL addLine = NO;
        
        if (indexPath.row == 0 && indexPath.row == [self numberOfRowsInSection:indexPath.section]-1)
        {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        }
        else if (indexPath.row == 0)
        {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            
            addLine = YES;
        }
        else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]-1)
        {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }
        else
        {
            CGPathAddRect(pathRef, nil, bounds);
            
            addLine = YES;
        }
        
        layer.path = pathRef;
        
        CFRelease(pathRef);
        
        if (cell.backgroundColor)
        {
            layer.fillColor = cell.backgroundColor.CGColor;
        }
        else if (cell.backgroundView && cell.backgroundView.backgroundColor)
        {
            layer.fillColor = cell.backgroundView.backgroundColor.CGColor;
        }
        else
        {
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        }
        
        if (addLine == YES)
        {
            CALayer *lineLayer = [[CALayer alloc] init];
            
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+2, bounds.size.height-lineHeight, bounds.size.width-2, lineHeight);
            
            lineLayer.backgroundColor = self.separatorColor.CGColor;
            
            [layer addSublayer:lineLayer];
        }
        
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        
        [testView.layer insertSublayer:layer atIndex:0];
        
        testView.backgroundColor = UIColor.clearColor;
        
        cell.backgroundView = testView;
    }
}

- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpace:(CGFloat)leftSpace hasSectionLine:(BOOL)hasSectionLine
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGRect cellbounds = cell.bounds;
    
    cellbounds.size.width = [UIApplication sharedApplication].keyWindow.frame.size.width;
    
    cell.bounds = cellbounds;
    
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    
    CGPathAddRect(pathRef, nil, bounds);
    
    layer.path = pathRef;
    
    CFRelease(pathRef);
    if (cell.backgroundColor)
    {
        layer.fillColor = cell.backgroundColor.CGColor;
    }
    else if (cell.backgroundView && cell.backgroundView.backgroundColor)
    {
        layer.fillColor = cell.backgroundView.backgroundColor.CGColor;
    }
    else
    {
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    }
    
    CGColorRef lineColor = [UIColor grayColor].CGColor;
    
    CGColorRef sectionLineColor = lineColor;
    
    if (indexPath.row == 0 && indexPath.row == [self numberOfRowsInSection:indexPath.section]-1)
    {
        //只有一个cell。加上长线&下长线
        if (hasSectionLine)
        {
            [self layer:layer addLineUp:YES andLong:YES andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
            [self layer:layer addLineUp:NO andLong:YES andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
        }
    }
    else if (indexPath.row == 0)
    {
        //第一个cell。加上长线&下短线
        if (hasSectionLine)
        {
            [self layer:layer addLineUp:YES andLong:YES andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
        }
        [self layer:layer addLineUp:NO andLong:NO andColor:lineColor andBounds:bounds withLeftSpace:leftSpace];
    }
    else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]-1)
    {
        //最后一个cell。加下长线
        if (hasSectionLine)
        {
            [self layer:layer addLineUp:NO andLong:YES andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
        }
    }
    else
    {
        //中间的cell。只加下短线
        [self layer:layer addLineUp:NO andLong:NO andColor:lineColor andBounds:bounds withLeftSpace:leftSpace];
    }
    UIView *testView = [[UIView alloc] initWithFrame:bounds];
    [testView.layer insertSublayer:layer atIndex:0];
    cell.backgroundView = testView;
}
- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpace:(CGFloat)leftSpace
{
    [self addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:leftSpace hasSectionLine:YES];
}

- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpace:(CGFloat)leftSpace withLineColor:(UIColor*)lineColor
{
    [self addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:leftSpace hasSectionLine:YES withLineColor:lineColor];
}

- (void)addLineforPlainCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath withLeftSpace:(CGFloat)leftSpace hasSectionLine:(BOOL)hasSectionLine withLineColor:(UIColor*)lineColor
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGRect cellbounds = cell.bounds;
    
    cellbounds.size.width = [UIApplication sharedApplication].keyWindow.frame.size.width;
    
    cell.bounds = cellbounds;
    
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    
    CGPathAddRect(pathRef, nil, bounds);
    
    layer.path = pathRef;
    
    CFRelease(pathRef);
    
    if (cell.backgroundColor)
    {
        layer.fillColor = cell.backgroundColor.CGColor;//layer的填充色用cell原本的颜色
    }
    else if (cell.backgroundView && cell.backgroundView.backgroundColor)
    {
        layer.fillColor = cell.backgroundView.backgroundColor.CGColor;
    }
    else
    {
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    }
    
    CGColorRef sectionLineColor = lineColor.CGColor;
    
    if (indexPath.row == 0 && indexPath.row == [self numberOfRowsInSection:indexPath.section]-1)
    {
        //只有一个cell。加上长线&下长线
        if (hasSectionLine)
        {
            [self layer:layer addLineUp:YES andLong:YES andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
            [self layer:layer addLineUp:NO andLong:NO andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
        }
    }
    else if (indexPath.row == 0)
    {
        //第一个cell。加上长线&下短线
        if (hasSectionLine)
        {
            [self layer:layer addLineUp:YES andLong:NO andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
        }
        [self layer:layer addLineUp:NO andLong:NO andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
    }
    else if (indexPath.row == [self numberOfRowsInSection:indexPath.section]-1)
    {
        //最后一个cell。加下长线
        if (hasSectionLine)
        {
            [self layer:layer addLineUp:NO andLong:NO andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
        }
    }
    else
    {
        //中间的cell。只加下短线
        [self layer:layer addLineUp:NO andLong:NO andColor:sectionLineColor andBounds:bounds withLeftSpace:leftSpace];
    }
    UIView *testView = [[UIView alloc] initWithFrame:bounds];
    [testView.layer insertSublayer:layer atIndex:0];
    cell.backgroundView = testView;
}

- (void)layer:(CALayer *)layer addLineUp:(BOOL)isUp andLong:(BOOL)isLong andColor:(CGColorRef)color andBounds:(CGRect)bounds withLeftSpace:(CGFloat)leftSpace
{
    CALayer *lineLayer = [[CALayer alloc] init];
    CGFloat lineHeight = (1.0f / [UIScreen mainScreen].scale);
    CGFloat left, top;
    if (isUp)
    {
        top = 0;
    }
    else
    {
        top = bounds.size.height-lineHeight;
    }
    
    if (isLong)
    {
        left = 0;
    }
    else
    {
        left = leftSpace;
    }
    
    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+left, top, self.frame.size.width-2*left, lineHeight);
    
    lineLayer.backgroundColor = color;
    [layer addSublayer:lineLayer];
}


-(NSIndexPath *)nextIndexPath:(NSIndexPath *)indexPath
{
    if ([self numberOfRowsInSection:indexPath.section] > (indexPath.row + 1)){
        return [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
    }
    else if ([self numberOfSections] > (indexPath.section + 1)){
        if ([self numberOfRowsInSection:(indexPath.section + 1)] > 0){
            return [NSIndexPath indexPathForRow:0 inSection:(indexPath.section + 1)];
        }
    }
    return nil;
}

-(NSIndexPath *)previousIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row - 1 >= 0) {
        return [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
    }
    else {
        if (indexPath.section - 1 >= 0) {
            NSInteger preRows = [self numberOfRowsInSection:(indexPath.section - 1)];
            if (preRows - 1 >= 0) {
                return [NSIndexPath indexPathForRow:preRows - 1 inSection:(indexPath.section - 1)];
            }
            
        }
    }
    
    return nil;
}

-(UITableViewCell *)previousTableViewCellIndexPath: (NSIndexPath *)currentIndexPath {
    return [self nextOrPreTableViewCellIndexPath:currentIndexPath flag:0];
    
}
-(UITableViewCell *)nextTableViewCellIndexPath: (NSIndexPath *)currentIndexPath {
    return [self nextOrPreTableViewCellIndexPath:currentIndexPath flag:1];
    
}



-(UITableViewCell *)nextOrPreTableViewCellIndexPath: (NSIndexPath *)currentIndexPath flag:(NSInteger)flag{
    NSAssert(currentIndexPath == nil,@"当前cell的索引不能为空");
    NSIndexPath *nextPath = nil;
    if (flag == 0) {
        nextPath = [self previousIndexPath:currentIndexPath];
    }
    else {
        nextPath = [self nextIndexPath:currentIndexPath];
    }
    
    if (nextPath!= nil) {
        UITableViewCell *cellWillShow = [self cellForRowAtIndexPath: nextPath];
        if (!cellWillShow) {
            [self scrollToRowAtIndexPath:nextPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            cellWillShow = [self cellForRowAtIndexPath: nextPath];
        }
        return cellWillShow;
    }
    return nil;
    
}

-(UITableViewCell *)nextOrPreTableViewCell: (UITableViewCell *)currentCell flag:(NSInteger)flag{
    NSAssert(currentCell == nil,@"当前cell不能为空");
    NSIndexPath *nextPath = nil;
    NSIndexPath *currentIndexPath = [self indexPathForCell:currentCell];
    if (flag == 0) {
        nextPath = [self previousIndexPath:currentIndexPath];
    }
    else {
        nextPath = [self nextIndexPath:currentIndexPath];
    }
    
    if (nextPath!= nil) {
        UITableViewCell *cellWillShow = [self cellForRowAtIndexPath: nextPath];
        if (!cellWillShow) {
            [self scrollToRowAtIndexPath:nextPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            cellWillShow = [self cellForRowAtIndexPath: nextPath];
        }
        return cellWillShow;
    }
    return nil;
    
}



- (void)setFirstResponder
{
    NSInteger sections = [self numberOfSections];
    for (int i = 0; i < sections ; i++) {
        NSInteger rows = [self numberOfRowsInSection:i];
        for (int j = 0; j < rows ; j++) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:j inSection:i];
            UITableViewCell * cell = [self cellForRowAtIndexPath:indexpath];
            
            if (!cell) {
                [self scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                cell = [self cellForRowAtIndexPath: indexpath];
            }
            
            if ([cell canBecomeFirstResponder]) {//这个需要能够响应FirstResponder的cell(一般是包含了一个可以响应键盘的textview或者textFeild)重载了 canBecomeFirstResponder 和 becomeFirstResponder
                [cell becomeFirstResponder];
                return ;
            }
            
        }
    }
    
}



-(void)registerCellName :(NSString *)cellName forCellReuseIdentifier:(NSString *)identifier;
{
    if (!cellName || cellName.length == 0) {
        return ;
    }
    
    NSString *cellReuseID = identifier;//
    if (!identifier || identifier.length == 0) {
        cellReuseID = cellName;
    }
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSBundle mainBundle] pathForResource:cellName ofType:@"nib"];//虽然文件名的后缀是xib,但是这里需要使用nib
    BOOL flag =  [fileManager fileExistsAtPath:path];
    if (flag) {
        UINib *nib = [UINib nibWithNibName:cellName bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:cellReuseID];
    }
    else {
        Class cellClass = NSClassFromString(cellName);
        [self registerClass:cellClass forCellReuseIdentifier:cellReuseID ];
    }
}

-(void)registerCellName :(NSString *)cellName {
    [self registerCellName:cellName forCellReuseIdentifier:nil];
}

-(NSString *)deafultCellReuseIdentifier:(NSString *)cellName {
    NSString *cellReuseID = nil;//
    cellReuseID = cellName;
    return cellReuseID;
}

///< 创建一个cell
- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath cellClass:(Class)cellCalss{
    UITableViewCell *cell = nil;
    if ([cellCalss isSubclassOfClass:UITableViewCell.class]) {
        id cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellCalss)];
        if (!cell) {
            [self registerCellName:NSStringFromClass(cellCalss)];
            cell = [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellCalss) forIndexPath:indexPath];
        }
    }
    return cell;
}


@end
