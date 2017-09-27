//
//  ViewController.m
//  GCD
//
//  Created by Stephen on 2017/9/27.
//  Copyright © 2017年 Stephen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   // [self gcdDemo1];
    
  //  [self gcdDemo2];
    
  //  [self gcdDemo3];
    
 //   [self serialQueueSync];
    
  //  [self serialQueueAsync];
    
       [self concurrentQueueAsync];
    
   // [self concurrentQueueSync];
}

//MARk: - GCD常见代码
/**
 同步执行方法sync: 上一个任务不执行完毕，就不会执行下一个任务，同步执行是不会开启子线程的
 */
- (void)gcdDemo1 {
    // 1.创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 2.将任务添加到队列
    // 2.1 定义一个任务 --block
    void (^task)() = ^{
        NSLog(@"-----%@", [NSThread currentThread]);
    };
    // 2.2 将任务添加到队列并且执行
    dispatch_sync(queue, task);
    
}

/**
 异步执行方法async:如果任务没有执行完毕，可以不用等待，异步执行下一个任务，具备开启线程的能力.异步通常是多线程的代名词
 */
- (void)gcdDemo2 {
    // 1.创建一个队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 2.将任务添加到队列
    // 2.1 定义一个任务 --block
    void (^task)() = ^{
        NSLog(@"-----%@", [NSThread currentThread]);
    };
    // 2.2 将任务添加到队列并且执行
    dispatch_async(queue, task);
}

/**
 线程间的通讯
 */
- (void)gcdDemo3 {
    //指定任务的执行方法--异步
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       //耗时操作
         NSLog(@"-----%@", [NSThread currentThread]);
        
        //更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"更新UI-----%@", [NSThread currentThread]);
        });
    });
}

/**
 GCD的核心概念：将任务添加到队列，指定任务执行的方法
 任务：1.使用block封装 2.block就是一个提前准备好的代码块，需要的时候执行
 队列：1.串行队列：一个接一个的执行任务 2.并发队列：可以同时调度多个任务
 任务执行函数，任务都需要在线程中执行
 同步执行：不会到线程池里面获取子线程
 异步执行：只要有任务就会去线程池中取子线程（主队列除外）
 
 小结：1、开不开线程取决于执行任务的函数，同步不开，异步就开
 2、开几条线程取决于队列，串行开一条，并发开多条（异步）
 
 */

//MARK: - 串行队列，同步执行

/**
 会不会开启线程？是否顺序执行？
 不会开启，按顺序执行
 */
- (void)serialQueueSync {
    // 1.创建一个串行队列  DISPATCH_QUEUE_SERIAL等价于NULL
    dispatch_queue_t queue = dispatch_queue_create("serialQueueSync", DISPATCH_QUEUE_SERIAL);
    
    // 2.同步执行任务
    for (int i = 0; i < 10; i++) {
        dispatch_sync(queue, ^{
            NSLog(@"%@-------%d", [NSThread currentThread], i);
        });
    }
}

//MARK: - 串行队列，异步执行

/**
 会不会开启线程？是否顺序执行？COME HERE的位置？
 会开启，会按顺序执行, 不确定
 */
- (void)serialQueueAsync {
    // 1.创建一个串行队列  DISPATCH_QUEUE_SERIAL等价于NULL
    dispatch_queue_t queue = dispatch_queue_create("serialQueueAsync", DISPATCH_QUEUE_SERIAL);
    
    // 2.同步执行任务
    for (int i = 0; i < 10; i++) {
        NSLog(@"%d-----------", i);
        dispatch_async(queue, ^{
            NSLog(@"%@-------%d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"COME HERE");//在主线程上面
}

//MARK: - 并发队列，异步执行
/**
 会不会开启线程？是否顺序执行？COME HERE的位置？
 会开启，不会按顺序执行, 不确定
 */
- (void)concurrentQueueAsync {
    // 1.创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("concurrentQueueAsync", DISPATCH_QUEUE_CONCURRENT);
    
    // 2.同步执行任务
    for (int i = 0; i < 10; i++) {
        NSLog(@"%d-----------", i);
        
        dispatch_async(queue, ^{
            NSLog(@"%@-------%d", [NSThread currentThread], i);
            
        });
    }
    
    NSLog(@"COME HERE");//在主线程上面
}

//MARK: - 并发队列，同步执行
/**
 会不会开启线程？是否顺序执行？COME HERE的位置？
 不会开启，会按顺序执行，最后
 */
- (void)concurrentQueueSync {
    // 1.创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("concurrentQueueSync", DISPATCH_QUEUE_CONCURRENT);
    
    // 2.同步执行任务
    for (int i = 0; i < 10; i++) {
        NSLog(@"%d-----------", i);
        dispatch_sync(queue, ^{
            NSLog(@"%@-------%d", [NSThread currentThread], i);
            
        });
    }
    
    NSLog(@"COME HERE");//在主线程上面
}
@end
