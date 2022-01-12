//
//  TicketDataModel.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import Foundation
import CoreData


protocol TicketDataModelDelegate: AnyObject {
    func dataLoaded()
}

class TicketDataModel {

    let totalTicketsCount = 21

    var coreDataStack: CoreDataStack!
    var tickets: [TicketInfo]?
    weak var delegate:TicketDataModelDelegate?

    init() {
        coreDataStack = CoreDataStack.shared
    }

    func fetchTicketInfo(){
        if getTicketsCount() == 0 {
            loadRandomTicketInfo()
        }

        let fetchRequest:NSFetchRequest<TicketInfo> = TicketInfo.fetchRequest()
        do {
            tickets = try coreDataStack.getManagedContext().fetch(fetchRequest)
            delegate?.dataLoaded()
        } catch let error {
            print(error)
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

//    func checkUserInfoExists() -> Bool {
//
//        let request:NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
//        let context = coreDataStack.getManagedContext()
//        do {
//            if try context.fetch(request).first != nil{
//                return true
//            }
//        } catch let error {
//            print(error)
//        }
//        return false
//    }

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
}
