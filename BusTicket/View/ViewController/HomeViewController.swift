//
//  HomeViewController.swift
//  BusTicket
//
//  Created by Jithin on 12/01/22.
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var bookTicketButton: UIButton!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        bookTicketButton.layer.cornerRadius = 5
        
        registerKeyboardNotification()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
                tap.cancelsTouchesInView = false
                view.addGestureRecognizer(tap)
        setNavBar()
    }

    func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    func setNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.purple
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }

    @objc func dismissKeyboard() {
            view.endEditing(true)
        }

    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }


    @IBAction func buttonTapped(_ sender: UIButton) {
        
    }


}
