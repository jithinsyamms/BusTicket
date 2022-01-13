//
//  TicketFooterView.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import UIKit

protocol TicketFooterProtocol: AnyObject {
    func bookButtonPressed()
}

class TicketFooterView: UICollectionReusableView {

    @IBOutlet weak var bookButton: UIButton!
    weak var delegate: TicketFooterProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        bookButton.layer.cornerRadius = 10
    }

    func setData(selectedId: Int) {
        bookButton.isEnabled = selectedId > 0 ? true : false
        bookButton.backgroundColor = selectedId > 0 ? UIColor.init(named: "AccentColor") : UIColor.systemGray 
    }

    @IBAction func buttonPresssed(_ sender: Any) {
        delegate?.bookButtonPressed()
    }

}
