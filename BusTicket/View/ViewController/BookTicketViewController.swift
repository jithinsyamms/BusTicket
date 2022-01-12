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
    var tickets:[TicketInfo]?

    private var horizontalSpacing:CGFloat = 0
    private var verticalSpacing:CGFloat = 0
    private var sectionInsets:UIEdgeInsets!

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        setNavBar()
        setDimension()
        ticketDataModel.delegate = self
        ticketDataModel.fetchTicketInfo()

    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setDimension()
    }

    func setDimension() {
        horizontalSpacing = collectionView.bounds.width / 4.0
        verticalSpacing = horizontalSpacing / 2
        sectionInsets = UIEdgeInsets(
            top: 0.0,
            left: horizontalSpacing,
            bottom: 0.0,
            right: horizontalSpacing)
    }

    func registerCells(){
        collectionView.register(UINib(nibName: "TicketItemCell", bundle: nil), forCellWithReuseIdentifier: "TicketItemCell")
        collectionView.register(UINib(nibName: "TicketHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TicketHeaderView")
        collectionView.register(UINib(nibName: "TicketFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "TicketFooterView")
    }

    func setNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

extension BookTicketViewController: TicketDataModelDelegate {
    func dataLoaded() {
        if let ticket = ticketDataModel.getTickets() {
           tickets = ticket
            collectionView.reloadData()
        }
    }
}

extension BookTicketViewController: UICollectionViewDelegate {

}

extension BookTicketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tickets?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "TicketItemCell", for: indexPath) as? TicketItemCell {
            cell.setData(ticketInfo: tickets?[indexPath.row])
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
            }
        }
        return reusableView
    }
}
extension BookTicketViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width/8.0
        let height = width
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return verticalSpacing
    }

    public func collectionView(_ collectionView: UICollectionView, layout
                               collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
}
