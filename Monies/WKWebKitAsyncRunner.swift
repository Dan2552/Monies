//
//  WKWebKitAsyncRunner.swift
//  MoniesMac
//
//  Created by Daniel Green on 25/01/2015.
//  Copyright (c) 2015 Daniel Green. All rights reserved.
//

class WKWebKitAsyncRunner {
    private let tasks : Array<(String, (String) -> ()) -> ()>
    private var currentTaskIndex = 0
    private var lastResult = ""
    
    init(tasks: Array<(String, (String) -> ()) -> ()>) {
        self.tasks = tasks
        runTasks()
    }
    
    func currentTask() -> (String, (String) -> ()) -> () {
        if currentTaskIndex < tasks.count {
            return tasks[currentTaskIndex]
        } else {
            return { result, next in }
        }
    }
    
    func runTasks() {
        let task = currentTask()
        task(lastResult) { result in
            self.lastResult = result ?? ""
            self.currentTaskIndex = self.currentTaskIndex + 1
            self.runTasks()
        }
    }
}
