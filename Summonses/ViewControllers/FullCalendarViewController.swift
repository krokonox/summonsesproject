//
//  FullCalendarViewController.swift
//  Summonses
//
//  Created by Smikun Denis on 02.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit

let fullCalendarCellIdentfier = "FullCalendarCollectionViewCell"

class FullCalendarViewController: BaseViewController {
  
  @IBOutlet weak var yearsSegmentControl: YearsSegmentControl!
  @IBOutlet weak var headerCalendarView: UIView!
  @IBOutlet weak var calendarView: UICollectionView!
  
  let years = Date().getVisibleYears()
  
  let monthsYear: [String] = ["January", "February", "March", "April", "May",
                              "June", "July", "August", "September", "October", "November", "December"]
  
  let minimumInterItemSpacing: CGFloat = 10
  let minimumLineSpacing: CGFloat = 10
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.parent?.navigationItem.title = "RDO Calendar"
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    DispatchQueue.main.async {
      NotificationCenter.default.post(name: NSNotification.Name.VDDateFullCalendarUpdate, object: nil)
    }
  }
  
  
  private func setupViews() {
    
    self.yearsSegmentControl.setItems(items: years)
    self.yearsSegmentControl.selectedSegmentIndex = 1
    
    headerCalendarView.layer.cornerRadius = 4.0
    calendarView.layer.cornerRadius = 4.0
    self.view.backgroundColor = UIColor.bgMainCell
    
    setupCalendarView()
  }
  
  private func setupCalendarView() {
    self.calendarView.delegate = self
    self.calendarView.dataSource = self
  }
  
  @IBAction func selectYearAction(_ sender: YearsSegmentControl) {
    print("\(years[sender.selectedSegmentIndex])")
    calendarView.reloadData()
  }
  
  private func getMonthAndYearString(month: String) -> String {
    let selectYear = years[yearsSegmentControl.selectedSegmentIndex]
    let string = "\(month) \(selectYear)"
    return string
  }
  
  
}


extension FullCalendarViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    guard let pageVC = self.parent as? CalendarPageViewController else { return }
    
    if let vc = pageVC.pages.first as? RDOViewController {
      pageVC.setViewControllers([vc], direction: .reverse, animated: true, completion: { (completion) in
        let monthName = self.monthsYear[indexPath.row]
        vc.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        vc.selectMonthToCalendar(selectMonth: self.getMonthAndYearString(month: monthName))
      })
    }
  }
  
}


extension FullCalendarViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return monthsYear.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let calendarViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: fullCalendarCellIdentfier, for: indexPath) as? FullCalendarCollectionViewCell else { fatalError() }
    
    calendarViewCell.monthAndYearGenerate = getMonthAndYearString(month: monthsYear[indexPath.row])
    calendarViewCell.layer.shouldRasterize = true
    calendarViewCell.layer.rasterizationScale = UIScreen.main.scale
    
    return calendarViewCell
  }
  
}

extension FullCalendarViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = calendarView.bounds.width / 3 - minimumInterItemSpacing - 5
    let height = calendarView.bounds.height / 4 - minimumLineSpacing - 3
    
    let size = CGSize(width: width, height: height)
    
    return size
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return minimumLineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return minimumInterItemSpacing
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
}

