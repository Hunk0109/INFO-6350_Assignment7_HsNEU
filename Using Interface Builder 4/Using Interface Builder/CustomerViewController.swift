import UIKit

class CustomerViewController: UIViewController {
    
    var artists: [Artist] {
        get { SharedData.shared.artists }
        set { SharedData.shared.artists = newValue }
    }
    
    var albums: [Album] {
        get { SharedData.shared.albums }
        set { SharedData.shared.albums = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!

    @IBOutlet weak var displayTextView: UITextView!
    
    @IBAction func addArtistButton(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let age = ageTextField.text, !age.isEmpty,
              let idString = idTextField.text, let id = Int(idString) else {
            showAlert(title: "Error", message: "Please Enter Both Name And ID.")
            return
        }
        
        if artists.contains(where: { $0.id == id }) {
            showAlert(title: "Error", message: "Customer With ID: \(id) Already Exists.")
            return
        }
        
        artists.append(Artist(id: id, name: name, age: age, email: email))
        nameTextField.text = ""
        idTextField.text = ""
        emailTextField.text = ""
        ageTextField.text = ""
        
        showAlert(title: "Success", message: "Customer Added Successfully With ID: \(id), Email: \(email), Age: \(age) and Name: \(name).")
    }
    
    
    @IBAction func deleteArtistButton(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Customer To Delete", message: nil, preferredStyle: .actionSheet)
        for artist in artists {
            let action = UIAlertAction(title: artist.name, style: .default) { _ in
                if let index = self.artists.firstIndex(where: { $0.id == artist.id }) {
                    if SharedData.shared.albums.contains(where: { $0.artistId == artist.id }) {
                        self.showAlert(title: "Error", message: "Cannot Delete Customer With Associated Policy.")
                    } else {
                        self.artists.remove(at: index)
                        self.showAlert(title: "Success", message: "Customer Successfully Deleted.")
                    }
                }
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func updateArtistButton(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Customer To Update", message: nil, preferredStyle: .actionSheet)
        for artist in artists {
            let action = UIAlertAction(title: artist.name, style: .default) { _ in
                let alert = UIAlertController(title: "Enter New Name", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "New Name"
                }
                alert.addTextField { textField in
                    textField.placeholder = "New Age"
                }
                let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
                    if let newName = alert.textFields?.first?.text, let newAge = alert.textFields?.last?.text , !newName.isEmpty, let index = self.artists.firstIndex(where: { $0.id == artist.id }) {
                        self.artists[index].age = newAge
                        self.artists[index].name = newName
                        self.showAlert(title: "Success", message: "Customer Successfully Updated.")
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
    
    
    @IBAction func displayArtistButton(_ sender: UIButton) {
        var displayText = "Customers:\n"
        for artist in artists {
            displayText += "ID: \(artist.id), Name: \(artist.name)\n"
        }
        
        // Assuming you have a UITextView in your storyboard named `displayTextView`
        displayTextView.text = displayText
        displayTextView.isHidden = false // Make sure the text view is visible
    }

    
//    @IBAction func searchArtist(_ sender: UIButton) {
//        guard let searchText = nameTextField?.text, !searchText.isEmpty else {
//            showAlert(title: "Error", message: "Please Enter A Search Term [ID Is Not Required].")
//            return
//        }
//        
//        let searchResults = SharedData.shared.artists.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
//        
//        if searchResults.isEmpty {
//            showAlert(title: "No Results", message: "No Artists Found Matching The Search Term.")
//        } else {
//            var displayText = "Search Results:\n"
//            for artist in searchResults {
//                displayText += "ID: \(artist.id), Name: \(artist.name)\n"
//            }
//            nameTextField?.text = ""
//            idTextField?.text = ""
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
