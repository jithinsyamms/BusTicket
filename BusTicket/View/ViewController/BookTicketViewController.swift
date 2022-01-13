//
//  BookTicketViewController.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import UIKit

class BookTicketViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var ticketDataModel = TicketDataModel()
    private var tickets: [TicketInfo]?
    private var numberOfTicketsInRow = 4
    var selectedTicket  = 0
    private var displayName = "User"
    private var canUserBookTicket = true

    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermission()
        registerCells()
        setNavBar()
        ticketDataModel.delegate = self
        ticketDataModel.fetchTicketInfo()
        canUserBookTicket = ticketDataModel.canUserBookTicket()
    }

    func requestPermission() {
        NotificationManager.shared.requestAuthorization { _ in
        }
    }

    func sendNotification(date: Date, remindBefore: Int) {
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                NotificationManager.shared.scheduleNotification(displayName: self.displayName,
                                                                bookedDate: date, remindBefore: remindBefore)
            }
        }
    }

    func registerCells() {
        collectionView.register(UINib(nibName: "TicketItemCell", bundle: nil),
                                forCellWithReuseIdentifier: "TicketItemCell")
        collectionView.register(UINib(nibName: "TicketHeaderView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "TicketHeaderView")
        collectionView.register(UINib(nibName: "TicketFooterView", bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "TicketFooterView")
    }

    func setNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    func bookTicket(date: Date, remindBefore: Int) {
        ticketDataModel.bookTicket(ticketId: selectedTicket, bookedDate: date, remindBefore: remindBefore)
        showTicketBookedAlert()
        sendNotification(date: date, remindBefore: remindBefore)
    }

    func showAlreadyBookedAlert() {
        let alert = UIAlertController(title: "Booked", message: "Ticket Already Booked",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showTicketBookedAlert() {
        let alert = UIAlertController(title: "Booked",
                                      message: "Congrats \(displayName) You have successfully booked a ticket",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BookTicketViewController: TicketDataModelDelegate {
    func dataChanged() {
        canUserBookTicket = ticketDataModel.canUserBookTicket()
        if let ticket = ticketDataModel.getTickets() {
            tickets = ticket
            collectionView.reloadData()
        }
    }
}

extension BookTicketViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tickets?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TicketItemCell", for: indexPath) as? TicketItemCell {
            cell.setData(ticketInfo: tickets?[indexPath.row], selectedTicketId: selectedTicket)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        var reusableView = UICollectionReusableView()

        if kind == UICollectionView.elementKindSectionHeader {
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                withReuseIdentifier: "TicketHeaderView",
                                for: indexPath) as? TicketHeaderView {
                reusableView = headerView
            }
        } else if kind == UICollectionView.elementKindSectionFooter {
            if let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "TicketFooterView", for: indexPath) as? TicketFooterView {
                reusableView = footerView
                footerView.delegate = self
                footerView.setData(selectedId: selectedTicket, canUserBookTicket: canUserBookTicket)
            }
        }
        return reusableView
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if !canUserBookTicket {
          showAlreadyBookedAlert()
          return
        }

        if let ticketSelected = tickets?[indexPath.row] {
            if selectedTicket == ticketSelected.ticketId {
                selectedTicket = 0
                collectionView.reloadData()
            } else if !ticketSelected.isBooked {
                selectedTicket = Int(ticketSelected.ticketId)
                collectionView.reloadData()
            }
        }
    }

}
extension BookTicketViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
            var totalSpace: CGFloat = 0
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                    totalSpace = flowLayout.sectionInset.left
                    + flowLayout.sectionInset.right
                    + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfTicketsInRow - 1))
            }
            let width = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfTicketsInRow))
            let height = Int(Double(width) * 0.7)
            return CGSize(width: width, height: height )
    }

    public func collectionView(_ collectionView: UICollectionView, layout
                               collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
}

extension BookTicketViewController: TicketFooterProtocol {
    func bookButtonPressed() {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let dateController = storyboard.instantiateViewController(withIdentifier:
                                                                        "DateViewController") as? DateViewController {
            dateController.preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.height / 2)
            let alertView = UIAlertController(title: "Select Date", message: "",
                                              preferredStyle: UIAlertController.Style.alert)
            alertView.setValue(dateController, forKey: "contentViewController")
            alertView.addAction(UIAlertAction(title: "Book Ticket",
                                              style: .default, handler: { _ in
                let date = dateController.datePicker.date
                self.bookTicket(date: date, remindBefore: dateController.remindMeMinutes[dateController.selectedRow])
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertView, animated: true)
        }
    }
}
