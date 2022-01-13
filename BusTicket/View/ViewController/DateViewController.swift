//
//  DateViewController.swift
//  BusTicket
//
//  Created by Jithin on 13/01/22.
//

import UIKit

class DateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!

    var remindMeBeofre: [String] = ["5 Min", "15 Min", "25 Min", "45 Min"]
    var remindMeMinutes: [Int] = [5, 15, 25, 45]
    var selectedRow = 0

    // Can book ticket for buses departs after 15 mins
    private var minTimeToBookTicket = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode  = .dateAndTime
        datePicker.locale = Locale.current
        datePicker.timeZone = TimeZone.autoupdatingCurrent
        let date = Calendar.current.date(byAdding: .minute, value: minTimeToBookTicket, to: Date())
        datePicker.minimumDate = date
    }
}

extension DateViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        remindMeBeofre.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        remindMeBeofre[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
}
