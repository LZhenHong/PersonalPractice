//
//  Theme.swift
//  Pet Finder
//
//  Created by LZhenHong on 2021/6/28.
//  Copyright © 2021 Ray Wenderlich. All rights reserved.
//

import UIKit

enum Theme: Int {
    case `default`, dark, graphical
    
    private enum Keys {
        static let SelectedThemeKey = "SelectedTheme"
    }
    
    static var current: Theme {
        let storedTheme = UserDefaults.standard.integer(forKey: Keys.SelectedThemeKey)
        return Theme(rawValue: storedTheme) ?? .default
    }
    
    func apply() {
        UserDefaults.standard.setValue(rawValue, forKey: Keys.SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = mainColor
        
        UINavigationBar.appearance().barStyle = barStyle
        UINavigationBar.appearance().setBackgroundImage(navigationBackgroundImage, for: .default)
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        
        UITabBar.appearance().barStyle = barStyle
        UITabBar.appearance().backgroundImage = tabBarBackgroundImage
        
        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
        
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
        UIStepper.appearance().setDecrementImage(UIImage(named: "morePaws"), for: .normal)
        
        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 6)), for: .normal)
        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?.withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)), for: .normal)
        
        UISwitch.appearance().onTintColor = mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = mainColor
        
        UITableViewCell.appearance().backgroundColor = backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = textColor
    }
    
    var mainColor: UIColor {
        switch self {
        case .default:
            return UIColor(red: 87.0 / 255.0, green: 188.0 / 255.0, blue: 95.0 / 255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 242.0 / 255.0, green: 101.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        case .graphical:
            return UIColor(red: 10.0 / 255.0, green: 10.0 / 255.0, blue: 10.0 / 255.0, alpha: 1.0)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .default, .graphical:
            return .default
        case .dark:
            return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .graphical ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .graphical ? UIImage(named: "taBarBackground") : nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .default, .graphical:
            return UIColor.white
        case .dark:
            return UIColor(white: 0.4, alpha: 1.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .default, .graphical:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .default:
            return UIColor(red: 242.0 / 255.0, green: 101.0 / 255.0, blue: 34.0 / 255.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 34.0 / 255.0, green: 128.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
        case .graphical:
            return UIColor(red: 140.0 / 255.0, green: 50.0 / 255.0, blue: 48.0 / 255.0, alpha: 1.0)
        }
    }
}
