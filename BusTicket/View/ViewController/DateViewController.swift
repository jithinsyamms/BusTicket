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

    var remindMeBeofre: [String] = ["15 Min", "30 Min", "45 min","1 hour"]
    var remindMeMinutes: [Int] = [15, 30, 60, 240]
    var selectedRow = -1
    var selectedDate = Date()
    // Can book ticket for buses departs after 15 mins
    private var minTimeToBookTicket = 120

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode  = .dateAndTime
        let date = Calendar.current.date(byAdding: .minute, value: minTimeToBookTicket, to: Date())
        datePicker.minimumDate = date

    }

    @IBAction func dateSelected(_ sender: Any) {
        selectedDate = datePicker.date
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


