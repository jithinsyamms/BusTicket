//
//  TicketDataModel.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import Foundation
import CoreData


protocol TicketDataModelDelegate: AnyObject {
    func dataChanged()
}

class TicketDataModel {

    static let uniqueuserId = "User-1001"

    let totalTicketsCount = 21
    var coreDataStack: CoreDataStack!
    var tickets: [TicketInfo]?
    weak var delegate: TicketDataModelDelegate?


    init() {
        coreDataStack = CoreDataStack.shared
    }

    func fetchTicketInfo() {
        if getTicketsCount() <= 0 {
            loadRandomTicketInfo()
        }

        let fetchRequest:NSFetchRequest<TicketInfo> = TicketInfo.fetchRequest()
        let sortDescriptors = [NSSortDescriptor(key: "ticketId", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            tickets = try coreDataStack.getManagedContext().fetch(fetchRequest)
            delegate?.dataChanged()
        } catch let error {
            print(error)
        }
    }

    func bookTicket(ticketId: Int, bookedDate: Date, remindBefore: Int) {
        let fetchRequest: NSFetchRequest<TicketInfo> = TicketInfo.fetchRequest()
        let predicate = NSPredicate(format: "ticketId == %d", ticketId)
        fetchRequest.predicate = predicate
        if let ticketInfo = try? coreDataStack.getManagedContext().fetch(fetchRequest).first {
            ticketInfo.isBooked = true
            ticketInfo.bookdedData = bookedDate
            ticketInfo.remindBefore = Int16(remindBefore)
            ticketInfo.bookedUserId = TicketDataModel.uniqueuserId

            do {
                try coreDataStack.getManagedContext().save()
                delegate?.dataChanged()
            } catch let error {
                print(error)
            }
        }

    }

    func getTicketsCount() -> Int {
        let request:NSFetchRequest<TicketInfo> = TicketInfo.fetchRequest()
        if let totalTickets = try? coreDataStack.getManagedContext().fetch(request) {
            return totalTickets.count
        } else {
           return 0
        }
    }

    func loadRandomTicketInfo(){
        let context = coreDataStack.getManagedContext()
        for ticketId in 1 ... totalTicketsCount {
            let ticketInfo = TicketInfo(context: context)
            ticketInfo.ticketId = Int16(ticketId)
            ticketInfo.isBooked = Utils.getRandomBool()
            ticketInfo.bookedUserId = ""
        }
        coreDataStack.saveContext()
    }

    func getTickets() -> [TicketInfo]? {
       return tickets
    }

    func canUserBookTicket() -> Bool {
        if getUserTicket() != nil {
            return false
        }
        return true
    }

    func getUserTicket() -> TicketInfo? {
        let fetchRequest: NSFetchRequest<TicketInfo> = TicketInfo.fetchRequest()
        let predicate = NSPredicate(format: "bookedUserId == %@", TicketDataModel.uniqueuserId)
        fetchRequest.predicate = predicate
        return try? coreDataStack.getManagedContext().fetch(fetchRequest).first
    }

}
