//
//  WeekDayChooser.swift
//  Weather
//
//  Created by Антон Чечевичкин on 23.10.2020.
//  Copyright © 2020 Антон Чечевичкин. All rights reserved.
//

import UIKit

enum Days: Int {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    
    static let allDays: [Days] = [Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday]
 
    var title: String {
        switch self {
        case .Monday:
            return "Пн"
        case .Tuesday:
            return "Вт"
        case .Wednesday:
            return "Ср"
        case .Thursday:
            return "Чт"
        case .Friday:
            return "Пт"
        case .Saturday:
            return "Сб"
        case .Sunday:
            return "Вс"
        }
    }
}

@IBDesignable class WeekDayChooser: UIControl {

    var selectedDay: Days? = nil {
        didSet {
            self.updateSelectedDay()
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    
    private func setupView() {
        for day in Days.allDays {
            let button = UIButton(type: .system)
            button.setTitle(day.title, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectedDay(_:)), for: .touchUpInside)
            self.buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        
        self.addSubview(stackView)
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        
    }
    
    
    private func updateSelectedDay() {
        for (index, button) in self.buttons.enumerated() {
            guard let day = Days(rawValue: index) else {
                continue
            }
            
            button.isSelected = day == self.selectedDay

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    
    @objc private func selectedDay(_ sender: UIButton) {
        guard let index = self.buttons.index(of: sender) else {
            return
        }
        
        guard let day = Days(rawValue: index) else {
            return
        }
        
        self.selectedDay = day
        
    }
    
    

}
