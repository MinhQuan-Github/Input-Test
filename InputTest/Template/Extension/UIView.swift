//
//  UIView.swift
//  InputTest
//
//  Created by Minh Quan on 06/01/2023.
//

import UIKit

extension UIView {
    
    enum Corner:Int {
        case bottomRight = 0,
        topRight,
        bottomLeft,
        topLeft
    }
    
    func setBlurShadow() {
//        let radius: CGFloat = self.frame.width / 2.0 //change it to .height if you need spread for height
//        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 2.1 * radius, height: self.frame.height))
//        //Change 2.1 to amount of spread you need and for height replace the code for height
//
//        self.layer.cornerRadius = 2
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowRadius = 5.0 //Here your control your blur
//        self.layer.masksToBounds =  false
//        self.layer.shadowPath = shadowPath.cgPath

        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.rasterizationScale = UIScreen.main.scale
//        self.layer.masksToBounds = true
//        self.layer.shouldRasterize = true
    }

    func setBlurShadow(_ frame: CGRect) {
        self.clipsToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(rect: frame).cgPath
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    func setGradientBlueColor() {
        let colorTop = UIColor(red: 0.0 / 255.0, green: 23.0 / 255.0, blue: 91.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 0.0 / 255.0, green: 34.0 / 255.0, blue: 135.0 / 255.0, alpha: 1.0).cgColor

        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)

        self.layer.insertSublayer(gradient, at: 0)
    }

    var left: CGFloat {
        return self.frame.origin.x
    }

    var top: CGFloat {
        return self.frame.origin.y
    }

    var right: CGFloat {
        return self.frame.origin.x + width
    }

    var bottom: CGFloat {
        return self.frame.origin.y + height
    }

    var width: CGFloat {
        return self.frame.size.width
    }

    var height: CGFloat {
        return self.frame.size.height
    }

    func shake(count: Float? = nil, for duration: TimeInterval? = nil, withTranslation translation: Float? = nil) {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

        animation.repeatCount = count ?? 4
        animation.duration = (duration ?? 0.1)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        let value = translation ?? 5

        animation.fromValue = NSValue.init(cgPoint: CGPoint(x: center.x - CGFloat(value), y: center.y))
        animation.toValue = NSValue.init(cgPoint: CGPoint(x: center.x + CGFloat(value), y: center.y))
        layer.add(animation, forKey: "position")
    }
    
    private func parseCorner(corner: Corner) -> CACornerMask.Element {
        let corners: [CACornerMask.Element] = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        return corners[corner.rawValue]
    }
    
    private func createMask(corners: [Corner]) -> UInt {
        return corners.reduce(0, { (a, b) -> UInt in
            return a + parseCorner(corner: b).rawValue
        })
    }
    
    func roundCorners(corners: [Corner], amount: CGFloat = 5) {
        layer.cornerRadius = amount
        let maskedCorners: CACornerMask = CACornerMask(rawValue: createMask(corners: corners))
        layer.maskedCorners = maskedCorners
    }
}

extension UIView {
    func open(animation: Bool = true) {
        if animation {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1.0
            }
        } else {
            self.alpha = 1.0
        }
    }

    func close(animation: Bool = true) {
        if animation {
            UIView.animate(withDuration: 0.3) {
                self.alpha = 0.0
            }
        } else {
            self.alpha = 0.0
        }
    }

    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}

extension UIView {
    func removeAllSubViews() {
        if !self.subviews.isEmpty {
            for view in self.subviews {
                view.removeFromSuperview()
            }
        }
    }
}

// MARK: Load Nib
extension UIView {
    @discardableResult   // Using a discardable return value since the returned view is mostly of no interest to caller when all outlets are already connected.
    func fromNib<T: UIView>() -> T? {   // 2
        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {    // 3
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)     // 4
        return contentView   // 7
    }
}
