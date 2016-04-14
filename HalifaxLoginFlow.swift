protocol HalifaxLoginFlowDataSource {
    func halifaxLoginUsername() -> String
    func halifaxLoginPassword() -> String
    func halifaxLoginMemorableInformation() -> String
}

class HalifaxLoginFlow: WebDriverFlow {
    let baseUrls = [
        "https://www.halifax-online.co.uk",
        "https://secure.halifax-online.co.uk"
    ]
    let login1Page = "login.jsp"
    let login2Page = "entermemorableinformation.jsp"

    let dataSource: HalifaxLoginFlowDataSource

    init(driver: WebViewDriver, dataSource: HalifaxLoginFlowDataSource) {
        self.dataSource = dataSource
        super.init(driver: driver)
    }

    func isHalifax(page: String) -> Bool {
        for url in baseUrls {
            if page.hasPrefix(url) {
                return true
            }
        }
        return false
    }

    override func startActionForPage(var page: String) -> Bool {
        guard isHalifax(page) else { return false }

        page = page.componentsSeparatedByString("?")[0]

        if page.hasSuffix(login1Page) {
            loginStep1()
            return true
        } else if page.hasSuffix(login2Page) {
            loginStep2()
            return true
        }

        return false
    }

    func loginStep1() {
        WKWebKitAsyncRunner(tasks: [
            { self.driver.fillIn("frmLogin:strCustomerLogin_userID", with: self.dataSource.halifaxLoginUsername(), completion: $1) },
            { self.driver.fillIn("frmLogin:strCustomerLogin_pwd", with: self.dataSource.halifaxLoginPassword(), redactPrint: true, completion: $1) },
            { self.driver.click("frmLogin:lnkLogin1", completion: $1)},
        ]).runTasks()
    }

    func loginStep2(i: Int = 1) {
        guard i < 4 else { return }

        let element = "frmEnterMemorableInformation1:formMem\(i)"
        WKWebKitAsyncRunner(tasks: [
            { self.driver.labelFor(element, completion: $1) },
            { self.driver.fillIn(element, with: self.characterForLabel($0), redactPrint: true, completion: $1)},
            {
                if i == 3 {
                    self.driver.click("frmEnterMemorableInformation1:lnkSubmit", completion: $1)
                } else {
                    $1("")
                }
            },
            { _,_ in self.loginStep2(i + 1) }
        ]).runTasks()
    }

    private func characterForLabel(key:String) -> String {
        var labels = [String]()
        
        for i in 1...100 {
            labels.append("\(i.ordinalizedString):")
        }

        var n = -1
        for (index, label) in labels.enumerate() {
            if (key == label) { n = index }
        }

        if n > -1 {
            return "&nbsp;\(Array(self.dataSource.halifaxLoginMemorableInformation().characters)[n])"
        }
        return ""
    }
}