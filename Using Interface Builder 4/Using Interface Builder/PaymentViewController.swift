import UIKit

class PaymentViewController: UIViewController {
    
    var genres: [Genre] {
        get { SharedData.shared.genres }
        set { SharedData.shared.genres = newValue }
    }
    
    var songs: [Song] {
        get { SharedData.shared.songs }
        set { SharedData.shared.songs = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var genreNameTextField: UITextField!
    @IBOutlet weak var genreIdTextField: UITextField!
    @IBOutlet weak var paymentAmountTextField: UITextField!
    @IBOutlet weak var paymentDateTextField: UITextField!
    @IBOutlet weak var paymentMethodTextField: UITextField!
    @IBOutlet weak var paymentStatusTextField: UITextField!

    @IBOutlet weak var paymentTextView: UITextView!
    
    @IBAction func addGenre(_ sender: UIButton) {
        guard let name = genreNameTextField?.text, !name.isEmpty,
              let amount = paymentAmountTextField?.text, !amount.isEmpty,
              let date = paymentDateTextField?.text, !date.isEmpty,
              let method = paymentMethodTextField?.text, !method.isEmpty,
              let status = paymentStatusTextField?.text, !status.isEmpty,

              let idString = genreIdTextField?.text, let id = Int(idString) else {
            showAlert(title: "Error", message: "Please Enter Both Name And ID.")
            return
        }
        
        if genres.contains(where: { $0.id == id }) {
            showAlert(title: "Error", message: "Payment With ID: \(id) already exists.")
            return
        }
        
        genres.append(Genre(id: id, name: name, paymentAmount: amount, paymentDate: date, paymentMethod: method, paymentStatus: status))
        genreNameTextField.text = ""
        genreIdTextField.text = ""
        paymentAmountTextField.text = ""
        paymentDateTextField.text = ""
        paymentMethodTextField.text = ""
        paymentStatusTextField.text = ""
        showAlert(title: "Success", message: "Payment Successfully Added.")
    }
    
    @IBAction func deleteGenre(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Payment To Delete", message: nil, preferredStyle: .actionSheet)
        for genre in genres {
            let action = UIAlertAction(title: genre.name, style: .default) { _ in
                if self.songs.contains(where: { $0.genre_id == genre.id }) {
                    self.showAlert(title: "Error", message: "Cannot Delete Payment With Associated Claims.")
                } else {
                    if let index = self.genres.firstIndex(where: { $0.id == genre.id }) {
                        self.genres.remove(at: index)
                        self.showAlert(title: "Success", message: "Payment Successfully Deleted.")
                    }
                }
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func updateGenre(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Payment To Update", message: nil, preferredStyle: .actionSheet)
        for genre in genres {
            let action = UIAlertAction(title: genre.name, style: .default) { _ in
                let alert = UIAlertController(title: "Enter New Name", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "New Name"
                    textField.text = genre.name
                }
                alert.addTextField { textField in
                    textField.placeholder = "New Status"
                    textField.text = genre.paymentStatus
                }
                alert.addTextField { textField in
                    textField.placeholder = "New Method"
                    textField.text = genre.paymentMethod 
                }
                let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
                    if let newAmount = alert.textFields?.first?.text, let newPaymentStatus = alert.textFields?[1].text, let newPaymentMethod = alert.textFields?.last?.text, !newAmount.isEmpty {
                        if let index = self.genres.firstIndex(where: { $0.id == genre.id }) {
                            self.genres[index].paymentAmount = newAmount
                            self.genres[index].paymentStatus = newPaymentStatus
                            self.genres[index].paymentMethod = newPaymentMethod
                            self.showAlert(title: "Success", message: "Payment Successfully Updated.")
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(updateAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func displayGenre(_ sender: UIButton) {
        var displayText = "Payment:\n"
        
        for genre in genres {
            displayText += """
            ID: \(genre.id),
            Name: \(genre.name),
            Amount: \(genre.paymentAmount),
            Date: \(genre.paymentDate),
            Method: \(genre.paymentMethod),
            Status: \(genre.paymentStatus)
            
            """
        }
        
        // Assuming you have a UITextView in your storyboard named `paymentTextView`
        paymentTextView.text = displayText
        paymentTextView.isHidden = false // Make sure the text view is visible
    }

    
    
//    @IBAction func searchGenre(_ sender: UIButton) {
//        guard let searchText = genreNameTextField?.text, !searchText.isEmpty else {
//            showAlert(title: "Error", message: "Please Enter A Search Term.")
//            return
//        }
//        
//        let searchResults = SharedData.shared.genres.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
//        
//        if searchResults.isEmpty {
//            showAlert(title: "No Results", message: "No Genres Found Matching The Search Term.")
//        } else {
//            var displayText = "Search Results:\n"
//            for genre in searchResults {
//                displayText += "ID: \(genre.id), Name: \(genre.name)\n"
//            }
//            
//            genreNameTextField?.text = ""
//            genreIdTextField?.text = ""
//            showAlert(title: "Search Results", message: displayText)
//        }
//    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
