//
//  MonthYearPickerView.swift
//  MonthYearPicker
//
//  Created by AlexBezkopylnyi on 25.07.2023.
//

import UIKit

class MonthYearPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - Properties
    static let DefaultHeight: CGFloat = 200.0
    
    private var months = [String]()
    private var years = [Int]()
    
    private var month = Date().month {
        didSet {
            selectRow(month - 1, inComponent: 0, animated: true)
        }
    }
    
    private var year = Date().year {
        didSet {
            if let firstYearIndex = years.firstIndex(of: year) {
                selectRow(firstYearIndex, inComponent: 1, animated: true)
            }
        }
    }
    
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    //MARK: - Setup
    private func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = Date().year - 50 // 50 years before
            for _ in -50...50 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        // population months with localized names
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
        self.months = months
        
        delegate = self
        dataSource = self
        
        let currentMonth = Date().month
        selectRow(currentMonth - 1, inComponent: 0, animated: false)
        
        let currentYear = Date().year
        selectRow(self.years.firstIndex(of: currentYear) ?? 0, inComponent: 1, animated: false)
    }
    
    // MARK: - UIPicker Delegate / Data Source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = selectedRow(inComponent: 0) + 1
        let year = years[selectedRow(inComponent: 1)]
        if let callback = onDateSelected {
            callback(month, year)
        }
        
        self.month = month
        self.year = year
    }
    
    //MARK: - Public
    func scrollToToday() {
        year = Date().year
        month = Date().month
        if let callback = onDateSelected {
            callback(month, year)
        }
    }
    
    func setSelected(month: Int, year: Int) {
        self.month = month
        self.year = year
        if let callback = onDateSelected {
            callback(month, year)
        }
    }
}
