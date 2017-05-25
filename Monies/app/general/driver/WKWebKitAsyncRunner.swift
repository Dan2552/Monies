class WKWebKitAsyncRunner {
    fileprivate let tasks : [(String, (String) -> ()) -> ()]
    fileprivate var currentTaskIndex = 0
    fileprivate var lastResult = ""

    init(tasks: Array<(String, (String) -> ()) -> ()>) {
        self.tasks = tasks
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
            self.lastResult = result
            self.currentTaskIndex = self.currentTaskIndex + 1
            self.runTasks()
        }
    }
}
