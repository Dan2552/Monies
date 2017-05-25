import then

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
    let login1MobilePageUrl = "https://www.halifax-online.co.uk/personal/logon/login.jsp?mobile=true"
    
    let dataSource: HalifaxLoginFlowDataSource

    init(driver: WebViewDriver, dataSource: HalifaxLoginFlowDataSource) {
        self.dataSource = dataSource
        super.init(driver: driver)
    }

    func isHalifax(_ page: String) -> Bool {
        for url in baseUrls {
            if page.hasPrefix(url) {
                return true
            }
        }
        return false
    }

    override func startActionForPage(_ page: String) -> Bool {
        var page = page
        guard isHalifax(page) else { return false }

        let urlComponents = page.components(separatedBy: "?")
        var params = ""
        page = urlComponents[0]
        
        if urlComponents.count > 1 {
            params = urlComponents[1]
        }

        if page.hasSuffix(login1Page) {
            if params.contains("mobile=true") {
                loginStep1()
            } else {
                driver.visit(login1MobilePageUrl)
            }
            return true
        } else if page.hasSuffix(login2Page) {
            loginStep2()
            return true
        }

        return false
    }

    func loginStep1() {
        run(
            driver.fillIn("frmLogin:strCustomerLogin_userID", with: self.dataSource.halifaxLoginUsername())
                .then(driver.fillIn("frmLogin:strCustomerLogin_pwd", with: self.dataSource.halifaxLoginPassword(), redactPrint: true))
                .then(driver.click("frmLogin:lnkLogin1"))
        )
    }

    func loginStep2() {
        run(
            driver.labelFor(memorableField(1))
                .then({ label in self.driver.fillIn("frmEnterMemorableInformation1:formMem\(1)", with: self.characterForLabel(label), redactPrint: true) })
                .then(driver.labelFor(memorableField(2)))
                .then({ label in self.driver.fillIn("frmEnterMemorableInformation1:formMem\(2)", with: self.characterForLabel(label), redactPrint: true) })
                .then(driver.labelFor(memorableField(3)))
                .then({ label in self.driver.fillIn("frmEnterMemorableInformation1:formMem\(3)", with: self.characterForLabel(label), redactPrint: true) })
                .then(driver.click("frmEnterMemorableInformation1:lnkSubmit"))
        )
    }
    
    private func memorableField(_ index: Int) -> String {
        return "frmEnterMemorableInformation1:formMem\(index)"
    }

    fileprivate func characterForLabel(_ key:String) -> String {
        var labels = [String]()
        
        for i in 1...100 {
            labels.append("\(i.ordinalizedString):")
        }

        var n = -1
        for (index, label) in labels.enumerated() {
            if (key == label) { n = index }
        }

        if n > -1 {
            return "&nbsp;\(Array(self.dataSource.halifaxLoginMemorableInformation().characters)[n])"
        }
        return ""
    }
}
