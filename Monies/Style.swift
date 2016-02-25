import UIKit

class TintColorLabel: UILabel {}
class MinorDetailLabel: UILabel {}

class Style {
    func setDark() {
        let navbarTint = UIColor(red: 14/255, green: 13/255, blue: 23/255, alpha: 1)
        let tint = UIColor(red: 228/255, green: 197/255, blue: 23/255, alpha: 1)

        let backgroundImage = UIImage(named: "moniesback.png")!
        let imageView = UIImageView(image: backgroundImage)

        UITableViewHeaderFooterView.appearance().tintColor = UIColor.blackColor()
        UITableView.appearance().backgroundView = imageView
        UITableView.appearance().separatorStyle = .None
        UITableView.appearance().separatorColor = UIColor.blackColor()
        UILabel.appearanceWhenContainedInInstancesOfClasses([UITableViewHeaderFooterView.self]).textColor = UIColor.whiteColor()

        UITableViewCell.appearance().backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.03)
        UITableViewCell.appearance().textLabel?.backgroundColor = UIColor.whiteColor()

        UILabel.appearance().textColor = UIColor.whiteColor()
        TintColorLabel.appearance().textColor = tint
        MinorDetailLabel.appearance().textColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)

        UINavigationBar.appearance().barTintColor = navbarTint
        UINavigationBar.appearance().tintColor = tint
        UINavigationBar.appearance().translucent = false

        UITabBar.appearance().barStyle = .Black
        UITabBar.appearance().tintColor = tint

        UIScrollView.appearance().backgroundColor = UIColor.clearColor()
    }

}