//
//  TicketItemCell.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import UIKit

class TicketItemCell: UICollectionViewCell {

    @IBOutlet weak var rootView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setData(ticketInfo:TicketInfo?) {
        guard let ticket = ticketInfo else {
            return
        }
        if ticket.isBooked {
            rootView.backgroundColor = UIColor.systemOrange
        } else {
            rootView.backgroundColor = UIColor.systemGreen
        }
    }
}
