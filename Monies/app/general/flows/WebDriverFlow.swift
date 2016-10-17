class WebDriverFlow {
    let driver: WebViewDriver

    init(driver: WebViewDriver) {
        self.driver = driver
    }

    /**
      Use page load as a trigger for starting actions within a flow

      To prevent multiple flows running into conflict, return whether the flow is in progress

      - Return true if the flow will take an action
      - Return false if the flow will not
    */
    func startActionForPage(page: String) -> Bool {
        return false
    }

    /**
     Start off a flow. Usually this would just be loading a specific page.
     
     Only override this on flows that you want to start a process. (i.e. with a login flow,
     it would be best to not override because if you try starting another process, it'll 
     probably redirect to the login page)
    */
    func startFlow() -> Bool {
        return false
    }
}

