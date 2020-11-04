//
//  OvertimeViewController.swift
//  Summonses
//
//  Created by Igor Shavlovsky on 8/8/18.
//  Copyright © 2018 neoviso. All rights reserved.
//

import UIKit

class OvertimePageViewController: BasePageViewController {
  
  let overtimeCalculatorVCIdentifier = "OvertimeCalculatorViewController"
  let overtimeHistoryVCIdentifier = "OvertimeHistoryViewController"
  let overtimeTotalsVCIdentifier = "OvertimeTotalViewController"
  let overtimePaidDetailTotalsVCIdentifier = "OvertimePaidDetailTotalViewController"
  private var pageControl = UIPageControl()
  
	lazy var pages: [UIViewController] = {
		return [self.addViewController(withIdentifier: overtimeCalculatorVCIdentifier),
						self.addViewController(withIdentifier: overtimeHistoryVCIdentifier),
						self.addViewController(withIdentifier: overtimeTotalsVCIdentifier),
						self.addViewController(withIdentifier: overtimePaidDetailTotalsVCIdentifier)]
	}()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    title = "Overtime"
    self.tabBarItem.title = "Overtime"
    self.tabBarItem.image = #imageLiteral(resourceName: "tabbar_overtime")
  }
	
  override func viewDidLoad() {
    super.viewDidLoad()
		
		self.dataSource = self
        NotificationCenter.default.addObserver(self, selector:#selector(reloadView), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func reloadView() {
      if SettingsManager.shared.needsOpenOvertimeHistory == true {
          if let secondVC = pages.dropFirst().first {
              SettingsManager.shared.needsOpenOvertimeHistory = false
              self.setViewControllers([secondVC], direction: .forward, animated: true, completion: nil)
          }
      } else if SettingsManager.shared.needsOpenOvertimeCalculator == true {
          if let firstVC = pages.first {
              self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
          }
      }
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if !SettingsManager.shared.paidDetail {
			if pages.count == 4 {
				pages.removeLast()
			}
		} else {
			if pages.count == 3{
				pages.append(self.addViewController(withIdentifier: overtimePaidDetailTotalsVCIdentifier))
			}
		}
        if SettingsManager.shared.needsOpenOvertimeHistory == true {
            if let secondVC = pages.dropFirst().first {
                SettingsManager.shared.needsOpenOvertimeHistory = false
                self.setViewControllers([secondVC], direction: .forward, animated: true, completion: nil)
            }
        } else {
            if let firstVC = pages.first {
                self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            }
        }
		setupPageViewController()
		self.loadView()
	}
	
  private func setupPageViewController() {
    pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    pageControl.currentPageIndicatorTintColor = .darkBlue
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.numberOfPages = pages.count
    pageControl.backgroundColor = .clear
    pageControl.isUserInteractionEnabled = false
  }
}

extension OvertimePageViewController: UIPageViewControllerDataSource {
  
  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    return pages.count
  }
  
  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    if let _ = pageViewController.viewControllers?.first as? OvertimeCalculatorViewController {
      return 0
    }
    if let _ = pageViewController.viewControllers?.first as? OvertimeHistoryViewController {
      return 1
    }
    if let _ = pageViewController.viewControllers?.first as? OvertimeTotalViewController {
      return 2
    }
		if let _ = pageViewController.viewControllers?.first as? OvertimePaidDetailTotalViewController {
			return 3
		}
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
