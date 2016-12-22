//
//  DispatchSourceVC.m
//  GCD实践
//
//  Created by fang wang on 16/12/22.
//  Copyright © 2016年 wdy. All rights reserved.
//

#import "DispatchSourceVC.h"


@interface DispatchSourceVC ()

@end

@implementation DispatchSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Dispatch源";
    
    
}

#pragma mark - 定时器
/*
 定时器dispatch source定时产生事件，可以用来发起定时执行的任务，如游戏或其它图形应用，可以使用定时器来更新屏幕或动画。
 你也可以设置定时器，并在固定间隔事件中检查服务器的新信息。
 
 所有定时器dispatch source都是间隔定时器，一旦创建，会按你指定的间隔定期递送事件。
 你需要为定时器dispatch source指定一个期望的定时器事件精度，也就是leeway值，让系统能够灵活地管理电源并唤醒内核。
 例如系统可以使用leeway值来提前或延迟触发定时器，使其更好地与其它系统事件结合。创建自己的定时器时，你应该尽量指定一个leeway值。
 
 就算你指定leeway值为0，也不要期望定时器能够按照精确的纳秒来触发事件。系统会尽可能地满足你的需求，但是无法保证完全精确的触发时间。
 
 当计算机睡眠时，定时器dispatch source会被挂起，稍后系统唤醒时，定时器dispatch source也会自动唤醒。
 根据你提供的配置，暂停定时器可能会影响定时器下一次的触发。
 如果定时器dispatch source使用 dispatch_time 函数或DISPATCH_TIME_NOW 常量设置，
 定时器dispatch source会使用系统默认时钟来确定何时触发，但是默认时钟在计算机睡眠时不会继续。
 
 如果你使用dispatch_walltime函数来设置定时器dispatch source，
 则定时器会根据挂钟时间来跟踪，这种定时器比较适合触发间隔相对比较大的场合，可以防止定时器触发间隔出现太大的误差。
 
 下面是定时器dispatch source的一个例子，每30秒触发一次，leeway值为1，因为间隔相对较大，使用 dispatch_walltime 来创建定时器。
 定时器会立即触发第一次，随后每30秒触发一次。MyPeriodicTask 和 MyStoreTimer 是自定义函数，用于实现定时器的行为，并存储定时器到应用的数据结构
 */
dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                      uint64_t leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0, 0, queue);
    if (timer)
    {
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval, leeway);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

void MyCreateTimer()
{
    dispatch_source_t aTimer = CreateDispatchTimer(30ull * NSEC_PER_SEC, 1ull * NSEC_PER_SEC,  dispatch_get_main_queue(),  ^{
        // 自定义的函数，实现定时器的行为，
        // MyPeriodicTask();
    });
    
    // Store it somewhere for later use. 
    if (aTimer) 
    {   // 存储定时器到应用的数据结构
        // MyStoreTimer(aTimer);
    } 
}

#pragma mark - 从描述符中读取数据
/*
 要从文件或socket中读取数据，需要打开文件或socket，并创建一个 DISPATCH_SOURCE_TYPE_READ 类型的dispatch source。你指定的事件处理器必须能够读取和处理描述符中的内容。对于文件，需要读取文件数据，并为应用创建适当的数据结构;对于网络socket，需要处理最新接收到的网络数据。
 
 读取数据时，你总是应该配置描述符使用非阻塞操作，虽然你可以使用dispatch_source_get_data 函数查看当前有多少数据可读，但在你调用它和实际读取数据之间，可用的数据数量可能会发生变化。如果底层文件被截断，或发生网络错误，从描述符中读取会阻塞当前线程，停止在事件处理器中间并阻止dispatch queue去执行其它任务。对于串行queue，这样还可能会死锁，即使是并发queue，也会减少queue能够执行的任务数量。
 
 下面例子配置dispatch source从文件中读取数据，事件处理器读取指定文件的全部内容到缓冲区，并调用一个自定义函数来处理这些数据。调用方可以使用返回的dispatch source在读取操作完成之后，来取消这个事件。为了确保dispatch queue不会阻塞，这里使用了fcntl函数，配置文件描述符执行非阻塞操作。dispatch source安装了取消处理器，确保最后关闭了文件描述符
 */
dispatch_source_t ProcessContentsOfFile(const char* filename)
{
    // Prepare the file for reading.
    int fd = open(filename, O_RDONLY);
    if (fd == -1)
        return NULL;
    fcntl(fd, F_SETFL, O_NONBLOCK); // Avoid blocking the read operation
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t readSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ,
                                                          fd, 0, queue);
    if (!readSource)
    {
        close(fd);
        return NULL;
    }
    
    // Install the event handler
    dispatch_source_set_event_handler(readSource, ^{
        size_t estimated = dispatch_source_get_data(readSource) + 1;
        // Read the data into a text buffer.
        char* buffer = (char*)malloc(estimated);
        if (buffer)
        {
            ssize_t actual = read(fd, buffer, (estimated));
//            Boolean done = MyProcessFileData(buffer, actual); // Process the data.
            
            // Release the buffer when done.
            free(buffer);
            
            // If there is no more data, cancel the source.
//            if (done)
                dispatch_source_cancel(readSource);
        } 
    }); 
    // Install the cancellation handler 
    dispatch_source_set_cancel_handler(readSource, ^{close(fd);});
    
    // Start reading the file. 
    dispatch_resume(readSource); 
    return readSource; 
}

#pragma mark - 向描述符写入数据
/*
 向文件或socket写入数据非常类似于读取数据，配置描述符为写入操作后，创建一个DISPATCH_SOURCE_TYPE_WRITE类型的dispatch source，创建好之后，系统会调用事件处理器，让它开始向文件或socket写入数据。当你完成写入后，使用 dispatch_source_cancel 函数取消dispatch source。
 
 写入数据也应该配置文件描述符使用非阻塞操作，虽然 dispatch_source_get_data 函数可以查看当前有多少可用写入空间，但这个值只是建议性的，而且在你执行写入操作时可能会发生变化。如果发生错误，写入数据到阻塞描述符，也会使事件处理器停止在执行中途，并阻止dispatch queue执行其它任务。串行queue会产生死锁，并发queue则会减少能够执行的任务数量。
 
 下面是使用dispatch source写入数据到文件的例子，创建文件后，函数传递文件描述符到事件处理器。MyGetData函数负责提供要写入的数据，在数据写入到文件之后，事件处理器取消dispatch source，阻止再次调用。此时dispatch source的拥有者需负责释放dispatch source。
 */
dispatch_source_t WriteDataToFile(const char* filename)
{
    int fd = open(filename, O_WRONLY | O_CREAT | O_TRUNC,
                  (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID));
    if (fd == -1)
        return NULL;
    fcntl(fd, F_SETFL); // Block during the write.
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t writeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE,
                                                           fd, 0, queue);
    if (!writeSource)
    {
        close(fd);
        return NULL;
    }
    
    dispatch_source_set_event_handler(writeSource, ^{
//        size_t bufferSize = MyGetDataSize();
//        void* buffer = malloc(bufferSize);
//        
//        size_t actual = MyGetData(buffer, bufferSize);
//        write(fd, buffer, actual);
//        
//        free(buffer);
        
        // Cancel and release the dispatch source when done.
        dispatch_source_cancel(writeSource);
    }); 
    
    dispatch_source_set_cancel_handler(writeSource, ^{close(fd);}); 
    dispatch_resume(writeSource); 
    return (writeSource); 
}

#pragma mark - 监控文件系统对象
/*
 如果需要监控文件系统对象的变化，可以设置一个 DISPATCH_SOURCE_TYPE_VNODE 类型的dispatch source，你可以从这个dispatch source中接收文件删除、写入、重命名等通知。你还可以得到文件的特定元数据信息变化通知。
 
 在dispatch source正在处理事件时，dispatch source中指定的文件描述符必须保持打开状态。
 
 下面例子监控一个文件的文件名变化，并在文件名变化时执行一些操作(自定义的 MyUpdateFileName 函数)。由于文件描述符专门为dispatch source打开，dispatch source安装了取消处理器来关闭文件描述符。这个例子中的文件描述符关联到底层的文件系统对象，因此同一个dispatch source可以用来检测多次文件名变化。
 */
dispatch_source_t MonitorNameChangesToFile(const char* filename)
{
    int fd = open(filename, O_EVTONLY);
    if (fd == -1)
        return NULL;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                                      fd, DISPATCH_VNODE_RENAME, queue);
    if (source)
    {
        // Copy the filename for later use.
        int length = strlen(filename);
        char* newString = (char*)malloc(length + 1);
        newString = strcpy(newString, filename);
        dispatch_set_context(source, newString);
        
        // Install the event handler to process the name change
        dispatch_source_set_event_handler(source, ^{
            const char*  oldFilename = (char*)dispatch_get_context(source);
//            MyUpdateFileName(oldFilename, fd);
        });
        
        // Install a cancellation handler to free the descriptor
        // and the stored string.
        dispatch_source_set_cancel_handler(source, ^{
            char* fileStr = (char*)dispatch_get_context(source);
            free(fileStr); 
            close(fd); 
        }); 
        
        // Start processing events. 
        dispatch_resume(source); 
    } 
    else 
        close(fd);
    
    return source; 
}

#pragma mark - 监测信号
/*
 应用可以接收许多不同类型的信号，如不可恢复的错误(非法指令)、或重要信息的通知(如子进程退出)。传统编程中，应用使用 sigaction 函数安装信号处理器函数，信号到达时同步处理信号。如果你只是想信号到达时得到通知，并不想实际地处理该信号，可以使用信号dispatch source来异步处理信号。
 
 信号dispatch source不能替代 sigaction 函数提供的同步信号处理机制。同步信号处理器可以捕获一个信号，并阻止它中止应用。而信号dispatch source只允许你监测信号的到达。此外，你不能使用信号dispatch source获取所有类型的信号，如SIGILL, SIGBUS, SIGSEGV信号。
 
 由于信号dispatch source在dispatch queue中异步执行，它没有同步信号处理器的一些限制。例如信号dispatch source的事件处理器可以调用任何函数。灵活性增大的代价是，信号到达和dispatch source事件处理器被调用的延迟可能会增大。
 
 下面例子配置信号dispatch source来处理SIGHUP信号，事件处理器调用 MyProcessSIGHUP 函数，用来处理信号
 */
void InstallSignalHandler()
{
    // Make sure the signal does not terminate the application.
    signal(SIGHUP, SIG_IGN);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGHUP, 0, queue);
    
    if (source)
    {
        dispatch_source_set_event_handler(source, ^{
//            MyProcessSIGHUP();
        });
        
        // Start processing signals 
        dispatch_resume(source); 
    } 
}

#pragma mark - 监控进程

/*
 进程dispatch source可以监控特定进程的行为，并适当地响应。父进程可以使用dispatch source来监控自己创建的所有子进程，例如监控子进程的死亡;类似地，子进程也可以使用dispatch source来监控父进程，例如在父进程退出时自己也退出。
 
 下面例子安装了一个进程dispatch source，监控父进程的终止。当父进程退出时，dispatch source设置一些内部状态信息，告知子进程自己应该退出。MySetAppExitFlag函数应该设置一个适当的标志，允许子进程终止。由于dispatch source自主运行，因此自己拥有自己，在程序关闭时会取消并释放自己。
 */
void MonitorParentProcess()
{
    pid_t parentPID = getppid();
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC,
                                                      parentPID, DISPATCH_PROC_EXIT, queue);
    if (source)
    {
        dispatch_source_set_event_handler(source, ^{
//            MySetAppExitFlag();
            dispatch_source_cancel(source);
//            dispatch_release(source); 
        });
        dispatch_resume(source); 
    } 
}

#pragma mark - 取消一个Dispatch Source
/*
 除非你显式地调用 dispatch_source_cancel函数，dispatch source将一直保持活动，取消一个dispatch source会停止递送新事件，并且不能撤销。因此你通常在取消dispatch source后立即释放它
 */
void RemoveDispatchSource(dispatch_source_t mySource)
{
    dispatch_source_cancel(mySource);
//    dispatch_release(mySource);
}

/*
 
 参数：
 type	dispatch源可处理的事件
 handle	可以理解为句柄、索引或id，假如要监听进程，需要传入进程的ID
 mask	可以理解为描述，提供更详细的描述，让它知道具体要监听什么
 queue	自定义源需要的一个队列，用来处理所有的响应句柄（block）
 
 Dispatch Source可处理的所有事件
 DISPATCH_SOURCE_TYPE_DATA_ADD	自定义的事件，变量增加
 DISPATCH_SOURCE_TYPE_DATA_OR	自定义的事件，变量OR
 DISPATCH_SOURCE_TYPE_MACH_SEND	MACH端口发送
 DISPATCH_SOURCE_TYPE_MACH_RECV	MACH端口接收
 DISPATCH_SOURCE_TYPE_PROC      进程监听,如进程的退出、创建一个或更多的子线程、进程收到UNIX信号
 DISPATCH_SOURCE_TYPE_READ      IO操作，如对文件的操作、socket操作的读响应
 DISPATCH_SOURCE_TYPE_SIGNAL	接收到UNIX信号时响应
 DISPATCH_SOURCE_TYPE_TIMER	定时器
 DISPATCH_SOURCE_TYPE_VNODE	文件状态监听，文件被删除、移动、重命名
 DISPATCH_SOURCE_TYPE_WRITE	IO操作，如对文件的操作、socket操作的写响应
 
 DISPATCH_SOURCE_TYPE_DATA_ADD: 当同一时间，一个事件的的触发频率很高，那么Dispatch Source会将这些响应以ADD的方式进行累积，然后等系统空闲时最终处理，如果触发频率比较零散，那么Dispatch Source会将这些事件分别响应。
 DISPATCH_SOURCE_TYPE_DATA_OR: 和上面的一样，是自定义的事件，但是它是以OR的方式进行累积
 
 一些函数
 dispatch_suspend(queue) //挂起队列
 dispatch_resume(source) //分派源创建时默认处于暂停状态，在分派源分派处理程序之前必须先恢复
 dispatch_source_merge_data //向分派源发送事件，需要注意的是，不可以传递0值(事件不会被触发)，同样也不可以传递负数。
 dispatch_source_set_event_handler //设置响应分派源事件的block，在分派源指定的队列上运行
 dispatch_source_get_data //得到分派源的数据
 uintptr_t dispatch_source_get_handle(dispatch_source_t source); //得到dispatch源创建，即调用dispatch_source_create的第二个参数
 unsigned long dispatch_source_get_mask(dispatch_source_t source); //得到dispatch源创建，即调用dispatch_source_create的第三个参数
 void dispatch_source_cancel(dispatch_source_t source); //取消dispatch源的事件处理--即不再调用block。如果调用dispatch_suspend只是暂停dispatch源。
 long dispatch_source_testcancel(dispatch_source_t source); //检测是否dispatch源被取消，如果返回非0值则表明dispatch源已经被取消
 void dispatch_source_set_cancel_handler(dispatch_source_t source, dispatch_block_t cancel_handler); //dispatch源取消时调用的block，一般用于关闭文件或socket等，释放相关资源
 void dispatch_source_set_registration_handler(dispatch_source_t source, dispatch_block_t registration_handler); //可用于设置dispatch源启动时调用block，调用完成后即释放这个block。也可在dispatch源运行当中随时调用这个函数。
 

 
 参考资料：
 
 IOS dispatch source 学习篇： http://www.jianshu.com/p/2f6eed90bb9d
 iOS多线程——Dispatch Source： http://www.jianshu.com/p/880c2f9301b6
 */
@end
