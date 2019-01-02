//
//  OvertimeViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 8/8/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class OvertimeViewController: BasePageViewController {
    
    let overtimeCalculatorVCIdentifier = "OvertimeCalculatorViewController"
    let overtimeHistoryVCIdentifier = "OvertimeHistoryViewController"
    let overtimeTotalsVCIdentifier = "OvertimeTotalViewController"
    
    private lazy var pages: [UIViewController] = {
        return [self.addViewController(withIdentifier: overtimeCalculatorVCIdentifier),
                self.addViewController(withIdentifier: overtimeHistoryVCIdentifier),
                self.addViewController(withIdentifier: overtimeTotalsVCIdentifier)]
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title = "Overtime"
        self.tabBarItem.title = "Overtime"
        self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_overtime")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageViewController()
        
        self.dataSource = self
        if let firstVC = pages.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    private func setupPageViewController() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControl.currentPageIndicatorTintColor = .darkBlue
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.numberOfPages = pages.count
        pageControl.backgroundColor = .clear
        pageControl.isUserInteractionEnabled = false
    }
}

extension OvertimeViewController: UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let indexVC = pages.firstIndex(of: viewController) else {return nil}
        guard indexVC > 0 else { return nil }
        let prevIndex = indexVC - 1
        guard pages.count > prevIndex else { return nil }
        return pages[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let indexVC = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = indexVC + 1
        guard pages.count > nextIndex else { return nil }
        return pages[nextIndex]
    }
    
    
}
