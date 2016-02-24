import UIKit

extension UIViewController {

    func styleTableView(view: UITableView) {
        let imageView = UIImageView(image: UIImage(named: "moniesback.png"))
        view.backgroundView = imageView
        view.separatorStyle = .None
    }

}