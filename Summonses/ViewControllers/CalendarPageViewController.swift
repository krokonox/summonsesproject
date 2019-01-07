//
//  PageViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 18.12.2018.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

let pageVCIdentifier = "CalendarPageViewController"
let rdoVCIdentifier = "RDOViewController"
let fullCalendarVCIdentifier = "FullCalendarViewController"
let vocationDaysVCIdentifier = "VocationDaysViewController"

class CalendarPageViewController: BasePageViewController {
    
    lazy var pages: [UIViewController] = {
        
        return [self.addViewController(withIdentifier: rdoVCIdentifier),
                self.addViewController(withIdentifier: fullCalendarVCIdentifier),
                self.addViewController(withIdentifier: vocationDaysVCIdentifier)]
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "RDO Calendar"
        self.tabBarItem.title = "RDO"
        self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_rdo")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self

        setupView()
        setupPageControl()

        if let firstVC = pages.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.bgMainCell
    }
    
    private func setupPageControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        pageControl.currentPageIndicatorTintColor = UIColor.darkBlue
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.numberOfPages = pages.count
        pageControl.backgroundColor = .clear
        pageControl.isUserInteractionEnabled = false
    }

}


extension CalendarPageViewController : UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let indexVC = pages.firstIndex(of: viewController) else { return nil }
        guard indexVC > 0 else { return nil }
        
        let previousIndex = indexVC - 1
        
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let indexVC = pages.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = indexVC + 1
        
        guard pages.count > nextIndex else { return nil }
    
        return pages[nextIndex]
    }
    
}

