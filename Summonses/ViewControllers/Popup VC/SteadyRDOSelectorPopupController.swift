//
//  AddVocationPopupController.swift
//  Summonses
//
//  Created by Smikun Denis on 08.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import JTAppleCalendar

class SteadyRDOSelectorPopupController: BasePopupViewController {
    var tabBarHeight: CGFloat!
    var calendarFrame : CGRect!
    
    var calendarCell : CalendarTableViewCell!
        
    @IBOutlet weak var weekDaysView: UIView!
    
    @IBOutlet weak var weekDaysTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var firstDay: UILabel!
    @IBOutlet weak var secondDay: UILabel!
    @IBOutlet weak var thirdDay: UILabel!
    @IBOutlet weak var fourthDay: UILabel!
    @IBOutlet weak var fifthDay: UILabel!
    @IBOutlet weak var sixthDay: UILabel!
    @IBOutlet weak var seventhDay: UILabel!
    
    @IBOutlet weak var firstCheckBox: CheckBox!
    @IBOutlet weak var secondCheckBox: CheckBox!
    @IBOutlet weak var thirdCheckBox: CheckBox!
    @IBOutlet weak var fourthCheckBox: CheckBox!
    @IBOutlet weak var fifthCheckBox: CheckBox!
    @IBOutlet weak var sixthCheckBox: CheckBox!
    @IBOutlet weak var seventhCheckBox: CheckBox!
    
    @IBOutlet weak var saveBtnBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var saveBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var alertViewHeight: NSLayoutConstraint!
    @IBOutlet weak var alertViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var weekdaysViewHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var onSaveButtonPressed : (()->())?
    var onWillAppear: (()->())?
    var onWillDisappear: (()->())?
    
    var displayDaysOptions: DaysDisplayedModel! 
    
    var localWeekends : [Bool]!
    
    var isMondayFirstDay = SettingsManager.shared.isMondayFirstDay
    
    
    //MARK: Variables
    @IBAction func saveButtonPressed(_ sender: Any) {
        if let onSaveButtonPressed = onSaveButtonPressed {
            onSaveButtonPressed()
        }
        if let onWillDisappear = onWillDisappear {
            onWillDisappear()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
  //MARK: IBOutlet's
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let onWillAppear = onWillAppear {
        onWillAppear()
    }
    
    changeWeekLabels()
    setupViews()
   
  }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        SheduleManager.shared.weekendsInSteadyRDO = [false, false, false, false, false, false, false]
        setupCheckBoxes()
        calendarCell.calendarView.reloadData()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        SheduleManager.shared.weekendsInSteadyRDO = localWeekends
        if let onWillDisappear = onWillDisappear {
            onWillDisappear()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
  func setupViews() {
    
    localWeekends = SheduleManager.shared.weekendsInSteadyRDO
    
    setupCheckBoxes()
    
    if UIScreen.main.bounds.height <= 568.0 {
        saveBtnHeight.constant *= 0.5
        saveBtnBottomConstraint.constant *= 0.3
        alertViewHeight.constant *= 0.7
        alertViewBottomConstraint.constant *= 0.5
        weekdaysViewHeight.constant *= 0.7
        textView.font = UIFont.systemFont(ofSize: 9.0)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0, weight: .semibold)
    } else if UIScreen.main.bounds.height >= 812.0 {
        
    } else {
        saveBtnHeight.constant *= 0.8
        saveBtnBottomConstraint.constant *= 0.8
        //alertViewHeight.constant *= 0.8
        //alertViewBottomConstraint.constant *= 0.8
        weekdaysViewHeight.constant *= 0.8
        textView.font = UIFont.systemFont(ofSize: 11.4)
    }
    
    if let calendarCell = Bundle.main.loadNibNamed("CalendarTableViewCell", owner: self, options: nil)?.first as? CalendarTableViewCell {
        calendarCell.selectionStyle = .none
        calendarCell.separatorInset.left = 2000
        calendarCell.displayDaysOptions = displayDaysOptions
        calendarCell.backgroundColor = .clear
        
        calendarFrame.size.width += 30
        
        calendarCell.frame = calendarFrame
        calendarCell.customBackgoundColor = .clear
        calendarCell.whiteView.backgroundColor = .clear
        calendarCell.bottomWhiteView.backgroundColor = UIColor.white.withAlphaComponent(0.90)
       popupView.addSubview(calendarCell)
        if #available(iOS 11.0, *){
            weekDaysTopConstraint.constant = calendarFrame.origin.y + calendarFrame.height
        } else {
            weekDaysTopConstraint.constant = calendarFrame.origin.y + calendarFrame.height - 0.3
        }
        self.calendarCell = calendarCell
    }
  }
    
  func setupCheckBoxes() {
    let weekends = SheduleManager.shared.weekendsInSteadyRDO
    if isMondayFirstDay {
        firstCheckBox.isChecked   = weekends[1]
        secondCheckBox.isChecked  = weekends[2]
        thirdCheckBox.isChecked   = weekends[3]
        fourthCheckBox.isChecked  = weekends[4]
        fifthCheckBox.isChecked   = weekends[5]
        sixthCheckBox.isChecked   = weekends[6]
        seventhCheckBox.isChecked = weekends[0]
        
        firstDay.textColor = weekends[1] ?  UIColor.darkBlue3 : UIColor.customBlue4
        secondDay.textColor = weekends[2] ? UIColor.darkBlue3 : UIColor.customBlue4
        thirdDay.textColor = weekends[3] ? UIColor.darkBlue3 : UIColor.customBlue4
        fourthDay.textColor = weekends[4] ? UIColor.darkBlue3 : UIColor.customBlue4
        fifthDay.textColor = weekends[5] ? UIColor.darkBlue3 : UIColor.customBlue4
        sixthDay.textColor = weekends[6] ? UIColor.darkBlue3 : UIColor.customBlue4
        seventhDay.textColor = weekends[0] ? UIColor.darkBlue3 : UIColor.customBlue4
    } else {
        firstCheckBox.isChecked   = weekends[0]
        secondCheckBox.isChecked  = weekends[1]
        thirdCheckBox.isChecked   = weekends[2]
        fourthCheckBox.isChecked  = weekends[3]
        fifthCheckBox.isChecked   = weekends[4]
        sixthCheckBox.isChecked   = weekends[5]
        seventhCheckBox.isChecked = weekends[6]
        
        firstDay.textColor = weekends[0] ?  UIColor.darkBlue3 : UIColor.customBlue4
        secondDay.textColor = weekends[1] ? UIColor.darkBlue3 : UIColor.customBlue4
        thirdDay.textColor = weekends[2] ? UIColor.darkBlue3 : UIColor.customBlue4
        fourthDay.textColor = weekends[3] ? UIColor.darkBlue3 : UIColor.customBlue4
        fifthDay.textColor = weekends[4] ? UIColor.darkBlue3 : UIColor.customBlue4
        sixthDay.textColor = weekends[5] ? UIColor.darkBlue3 : UIColor.customBlue4
        seventhDay.textColor = weekends[6] ? UIColor.darkBlue3 : UIColor.customBlue4
    }
  }
    
  func changeWeekLabels() {
      if SettingsManager.shared.isMondayFirstDay {
          firstDay.text   = "MON"
          secondDay.text  = "TUE"
          thirdDay.text   = "WED"
          fourthDay.text  = "THU"
          fifthDay.text   = "FRI"
          sixthDay.text   = "SAT"
          seventhDay.text = "SUN"
      } else {
          firstDay.text   = "SUN"
          secondDay.text  = "MON"
          thirdDay.text   = "TUE"
          fourthDay.text  = "WED"
          fifthDay.text   = "THU"
          sixthDay.text   = "FRI"
          seventhDay.text = "SAT"
      }
  }

  @IBAction func firstCheckBoxTapped(_ sender: Any) {
      if let checkBox = sender as? CheckBox {
          if checkBox.isChecked {
              firstDay.textColor = UIColor.customBlue4
          } else {
              firstDay.textColor = UIColor.darkBlue3
          }
          var temp = SheduleManager.shared.weekendsInSteadyRDO
          let index = isMondayFirstDay ? 1 : 0
          temp[index] = !checkBox.isChecked
          SheduleManager.shared.weekendsInSteadyRDO = temp
          calendarCell.calendarView.reloadData()
      }
  }
    
  @IBAction func secondCheckBoxTapped(_ sender: Any) {
      if let checkBox = sender as? CheckBox {
          if checkBox.isChecked {
              secondDay.textColor = UIColor.customBlue4
          } else {
              secondDay.textColor = UIColor.darkBlue3
          }
          var temp = SheduleManager.shared.weekendsInSteadyRDO
          let index = isMondayFirstDay ? 2 : 1
          temp[index] = !checkBox.isChecked
          SheduleManager.shared.weekendsInSteadyRDO = temp
          calendarCell.calendarView.reloadData()
      }
  }
    
  @IBAction func thirdCheckBoxTapped(_ sender: Any) {
      if let checkBox = sender as? CheckBox {
          if checkBox.isChecked {
              thirdDay.textColor = UIColor.customBlue4
          } else {
              thirdDay.textColor = UIColor.darkBlue3
          }
          var temp = SheduleManager.shared.weekendsInSteadyRDO
          let index = isMondayFirstDay ? 3 : 2
          temp[index] = !checkBox.isChecked
          SheduleManager.shared.weekendsInSteadyRDO = temp
          calendarCell.calendarView.reloadData()
      }
  }
    
  @IBAction func fourthCheckBoxTapped(_ sender: Any) {
      if let checkBox = sender as? CheckBox {
          if checkBox.isChecked {
              fourthDay.textColor = UIColor.customBlue4
          } else {
              fourthDay.textColor = UIColor.darkBlue3
          }
          var temp = SheduleManager.shared.weekendsInSteadyRDO
          let index = isMondayFirstDay ? 4 : 3
          temp[index] = !checkBox.isChecked
          SheduleManager.shared.weekendsInSteadyRDO = temp
          calendarCell.calendarView.reloadData()
      }
  }
    
  @IBAction func fifthCheckBoxTapped(_ sender: Any) {
      if let checkBox = sender as? CheckBox {
          if checkBox.isChecked {
              fifthDay.textColor = UIColor.customBlue4
          } else {
              fifthDay.textColor = UIColor.darkBlue3
          }
          var temp = SheduleManager.shared.weekendsInSteadyRDO
         let index = isMondayFirstDay ? 5 : 4
          temp[index] = !checkBox.isChecked
          SheduleManager.shared.weekendsInSteadyRDO = temp
          calendarCell.calendarView.reloadData()
      }
  }
    
  @IBAction func sixthCheckBoxTapped(_ sender: Any) {
      if let checkBox = sender as? CheckBox {
          if checkBox.isChecked {
              sixthDay.textColor = UIColor.customBlue4
          } else {
              sixthDay.textColor = UIColor.darkBlue3
          }
          var temp = SheduleManager.shared.weekendsInSteadyRDO
          let index = isMondayFirstDay ? 6 : 5
          temp[index] = !checkBox.isChecked
          SheduleManager.shared.weekendsInSteadyRDO = temp
          calendarCell.calendarView.reloadData()
      }
  }
    
  @IBAction func seventhCheckBoxTapped(_ sender: Any) {
      if let checkBox = sender as? CheckBox {
          if checkBox.isChecked {
              seventhDay.textColor = UIColor.customBlue4
          } else {
              seventhDay.textColor = UIColor.darkBlue3
          }
          var temp = SheduleManager.shared.weekendsInSteadyRDO
          let index = isMondayFirstDay ? 0 : 6
          temp[index] = !checkBox.isChecked
          SheduleManager.shared.weekendsInSteadyRDO = temp
          calendarCell.calendarView.reloadData()
      }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  
}

