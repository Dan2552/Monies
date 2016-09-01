class HalifaxAccountsOverviewFlow: WebDriverFlow {
    let url = "https://secure.halifax-online.co.uk/personal/a/mobile/account_overview"

    override func startFlow() -> Bool {
        driver.visit(url)
        return true
    }

    override func startActionForPage(page: String) -> Bool {
        if page.hasPrefix(url) {
            getAccounts()
            return true
        }
        return false
    }

    private func getAccounts() {
        print("Accounts")
        driver.run("$('.balance').length") { accountCountStr in
            if let accountCount = Int(accountCountStr) {
                for i in 0..<accountCount {
                    self.parseAccount(i)
                }
            }
        }
    }

    private func parseAccount(index: Int) {
        let creator = AsyncronousAccountCreator()

        driver.run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.account-number').text()") { accountNumber in
            creator.accountNumber = accountNumber
        }
        driver.run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.balance span').text()") { balance in
            creator.balance = balance
        }
        driver.run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.available-balance').text()") { availableBalance in
            var ab = availableBalance
            if ab.isEmpty { ab = "-" }
            creator.availableBalance = ab
        }
        driver.run("$($('.des-m-sat-xx-account-information')[\(index)]).find('.account-name a').text()") { title in
            creator.title = title
        }
    }
}