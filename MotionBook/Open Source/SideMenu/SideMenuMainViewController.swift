//
//  MainViewController.swift
//
//  Created by Jon Kent on 11/12/15.
//  Copyright © 2015 Jon Kent. All rights reserved.
//

import SideMenu

class SideMenuMainViewController: UIViewController {
    
    @IBOutlet fileprivate weak var presentModeSegmentedControl:UISegmentedControl!
    @IBOutlet fileprivate weak var blurSegmentControl:UISegmentedControl!
    @IBOutlet fileprivate weak var darknessSlider:UISlider!
    @IBOutlet fileprivate weak var shadowOpacitySlider:UISlider!
    @IBOutlet fileprivate weak var screenWidthSlider:UISlider!
    @IBOutlet fileprivate weak var shrinkFactorSlider:UISlider!
    @IBOutlet fileprivate weak var blackOutStatusBar:UISwitch!
    
    deinit {
        SideMenuManager.default.menuLeftNavigationController = nil
        SideMenuManager.default.menuRightNavigationController = nil
        SideMenuManager.default.menuEnableSwipeGestures = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSideMenu()
        setDefaults()
        
        self.initOpenSourceView(self)
    }
    
    fileprivate func setupSideMenu() {
        // Enable Swipe Gestures
        SideMenuManager.default.menuEnableSwipeGestures = true
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // Set up a cool background image for demo purposes
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    }
    
    fileprivate func setDefaults() {
        let modes:[SideMenuManager.MenuPresentMode] = [.menuSlideIn, .viewSlideOut, .menuDissolveIn]
        presentModeSegmentedControl.selectedSegmentIndex = modes.index(of: SideMenuManager.default.menuPresentMode)!
        
        let styles:[UIBlurEffectStyle] = [.dark, .light, .extraLight]
        if let menuBlurEffectStyle = SideMenuManager.default.menuBlurEffectStyle {
            blurSegmentControl.selectedSegmentIndex = styles.index(of: menuBlurEffectStyle) ?? 0
        } else {
            blurSegmentControl.selectedSegmentIndex = 0
        }
        
        darknessSlider.value = Float(SideMenuManager.default.menuAnimationFadeStrength)
        shadowOpacitySlider.value = Float(SideMenuManager.default.menuShadowOpacity)
        shrinkFactorSlider.value = Float(SideMenuManager.default.menuAnimationTransformScaleFactor)
        screenWidthSlider.value = Float(SideMenuManager.default.menuWidth / view.frame.width)
        blackOutStatusBar.isOn = SideMenuManager.default.menuFadeStatusBar
    }
    
    @IBAction fileprivate func changeSegment(_ segmentControl: UISegmentedControl) {
        switch segmentControl {
        case presentModeSegmentedControl:
            let modes:[SideMenuManager.MenuPresentMode] = [.menuSlideIn, .viewSlideOut, .viewSlideInOut, .menuDissolveIn]
            SideMenuManager.default.menuPresentMode = modes[segmentControl.selectedSegmentIndex]
        case blurSegmentControl:
            if segmentControl.selectedSegmentIndex == 0 {
                SideMenuManager.default.menuBlurEffectStyle = nil
            } else {
                let styles:[UIBlurEffectStyle] = [.dark, .light, .extraLight]
                SideMenuManager.default.menuBlurEffectStyle = styles[segmentControl.selectedSegmentIndex - 1]
            }
        default: break;
        }
    }
    
    @IBAction fileprivate func changeSlider(_ slider: UISlider) {
        switch slider {
        case darknessSlider:
            SideMenuManager.default.menuAnimationFadeStrength = CGFloat(slider.value)
        case shadowOpacitySlider:
            SideMenuManager.default.menuShadowOpacity = slider.value
        case shrinkFactorSlider:
            SideMenuManager.default.menuAnimationTransformScaleFactor = CGFloat(slider.value)
        case screenWidthSlider:
            SideMenuManager.default.menuWidth = view.frame.width * CGFloat(slider.value)
        default: break;
        }
    }
    
    @IBAction fileprivate func changeSwitch(_ switchControl: UISwitch) {
        SideMenuManager.default.menuFadeStatusBar = switchControl.isOn
    }
}
