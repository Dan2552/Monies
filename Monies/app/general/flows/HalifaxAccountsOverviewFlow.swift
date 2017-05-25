import then

class HalifaxAccountsOverviewFlow: WebDriverFlow {
    let url = "https://secure.halifax-online.co.uk/personal/a/mobile/account_overview"

    override func startFlow() -> Bool {
        driver.visit(url)
        return true
    }

    override func startActionForPage(_ page: String) -> Bool {
        if page.hasPrefix(url) {
            getAccounts()
            return true
        }
        return false
    }

    fileprivate func getAccounts() {
        print("Accounts")
        
        run(
            driver.run("$('.balance').length").chain { accountCountStr in
                if let accountCount = Int(accountCountStr) {
                    for i in 0..<accountCount {
                        self.parseAccount(i)
                    }
                }
            }
        )
    }

    private func parseAccount(_ index: Int) {
        let account = "$($('.des-m-sat-xx-account-information')[\(index)]).find('.account-number').text()"
        let balance = "$($('.des-m-sat-xx-account-information')[\(index)]).find('.balance span').text()"
        let available = "$($('.des-m-sat-xx-account-information')[\(index)]).find('.available-balance').text()"
        let title = "$($('.des-m-sat-xx-account-information')[\(index)]).find('.account-name a').text()"
        
        let creator = AsyncronousAccountCreator()
        
        run(
            driver.run(account).chain({ creator.accountNumber = $0 })
                .then(driver.run(balance).chain({ creator.balance = $0 }))
                .then(driver.run(available).chain({ creator.availableBalance = $0.isEmpty ? "-" : $0 }))
                .then(driver.run(title).chain({ creator.title = $0 } ))
        )
    }
}
