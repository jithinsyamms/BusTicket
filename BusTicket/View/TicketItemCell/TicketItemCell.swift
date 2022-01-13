//
//  TicketItemCell.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import UIKit

class TicketItemCell: UICollectionViewCell {

    @IBOutlet weak var rootView: UIView!
    @IBOutlet weak var ticketView: UIView!
    @IBOutlet weak var ticketLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ticketView.layer.cornerRadius = 8
        ticketView.layer.borderWidth = 0.3
        ticketView.layer.borderColor = UIColor.gray.cgColor

    }

    func setData(ticketInfo:TicketInfo?, selectedTicketId:Int) {


        guard let ticket = ticketInfo else {
            return
        }
        if ticket.isBooked {
            ticketView.backgroundColor = UIColor.systemOrange
        } else if ticket.ticketId == selectedTicketId {
            ticketView.backgroundColor = UIColor.systemBlue
        } else {
            ticketView.backgroundColor = UIColor.systemGreen
        }
        ticketLabel.text = String(ticket.ticketId)
    }
}
