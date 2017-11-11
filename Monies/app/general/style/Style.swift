import UIKit
import ChameleonFramework

class TintColorLabel: UILabel {}
class MinorDetailLabel: UILabel {}

enum StyleTextSize: Int {
    case small = 10
    case normal = 14
    case large = 24
}

class Style {
    let fontName = "HelveticaNeue-Light"
    let primaryColor = FlatWhite()
    let secondaryColor = UIColor.white
    
    func setGlobalTheme() {
        Chameleon.setGlobalThemeUsingPrimaryColor(primaryColor,
                                                  withSecondaryColor: secondaryColor,
                                                  usingFontName: fontName,
                                                  andContentStyle: .contrast)
        
        UITabBar.appearance().barTintColor = .black
    }

    func font(size: StyleTextSize) -> UIFont {
        return UIFont(name: fontName, size: CGFloat(size.rawValue))!
    }
}
