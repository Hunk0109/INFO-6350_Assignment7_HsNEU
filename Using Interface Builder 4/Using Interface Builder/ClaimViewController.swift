import UIKit

class ClaimViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumPicker?.delegate = self
        albumPicker?.dataSource = self
        genrePicker?.delegate = self
        genrePicker?.dataSource = self
    }
    
    var selectedAlbum: Album?
    var selectedGenre: Genre?
    
    @IBOutlet weak var songIDTextField: UITextField!
    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var songDuration: UITextField!
    @IBOutlet weak var songFavorite: UITextField!
    @IBOutlet weak var albumPicker: UIPickerView!
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var dateOfClaimTextField: UITextField!
    
    @IBOutlet weak var claimsTextView: UITextView!
    @IBAction func addSong(_ sender: UIButton) {
        guard let songTitle = songTitleTextField?.text,
              let dateOfClaim = dateOfClaimTextField?.text,
              let durationText = songDuration?.text,
              let duration = Double(durationText),
              
                let selectedAlbum = selectedAlbum,
              let selectedGenre = selectedGenre else {
            showAlert(title: "Error", message: "Please Enter All Fields And Select An Policy And Payment.")
            return
        }
        let isFavorite = songFavorite?.text?.lowercased() == "true"
        
        if SharedData.shared.songs.contains(where: { $0.title == songTitle && $0.album_id == selectedAlbum.id }) {
            showAlert(title: "Error", message: "Claim With Title: '\(songTitle)' Already Exists For This Policy.")
            return
        }
        
        let newSong = Song(id: SharedData.shared.songs.count + 1,
                           artist_id: selectedAlbum.artistId,
                           album_id: selectedAlbum.id,
                           genre_id: selectedGenre.id,
                           title: songTitle,
                           duration: duration,
                           favorite: isFavorite,
                           dateOfClaim: dateOfClaim)
        SharedData.shared.songs.append(newSong)
        
        // Display success message
        showAlert(title: "Success", message: "Claim Successfully Added.")
        // Reset the form
        songIDTextField?.text = ""
        songTitleTextField?.text = ""
        songDuration?.text = ""
        songFavorite?.text = ""
        dateOfClaimTextField?.text = ""
    }
    
    @IBAction func deleteSong(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Claim To Delete", message: nil, preferredStyle: .actionSheet)
        for song in SharedData.shared.songs { // Assuming you use SharedData for global access
            let action = UIAlertAction(title: song.title, style: .default) { [unowned self] _ in
                if let index = SharedData.shared.songs.firstIndex(where: { $0.id == song.id }) {
                    SharedData.shared.songs.remove(at: index)
                    self.showAlert(title: "Success", message: "Claim Successfully Deleted.")
                }
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func updateSong(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Claim To Update", message: nil, preferredStyle: .actionSheet)
        for song in SharedData.shared.songs {
            let action = UIAlertAction(title: song.title, style: .default) { [unowned self] _ in
                let alert = UIAlertController(title: "Enter New Details", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "New Title"
                    textField.text = song.title
                }
                alert.addTextField { textField in
                    textField.placeholder = "New Amount"
                    textField.text = "\(song.duration)"
                }
                alert.addTextField { textField in
                    textField.placeholder = "Status (Approved/Rejected)"
                    textField.text = song.favorite ? "Approved" : "Rejected"
                }
                let updateAction = UIAlertAction(title: "Update", style: .default) { [unowned self] _ in
                    if let newTitle = alert.textFields?[0].text, !newTitle.isEmpty,
                       let newDurationString = alert.textFields?[1].text,
                       let newDuration = Double(newDurationString),
                       let newFavoriteString = alert.textFields?[2].text,
                       let newFavorite = Bool(newFavoriteString.lowercased()) {
                        if let index = SharedData.shared.songs.firstIndex(where: { $0.id == song.id }) {
                            SharedData.shared.songs[index].title = newTitle
                            SharedData.shared.songs[index].duration = newDuration
                            SharedData.shared.songs[index].favorite = newFavorite
                            self.showAlert(title: "Success", message: "Claim Successfully Updated.")
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(updateAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func displaySong(_ sender: UIButton) {
        var displayText = "Claims:\n"
        
        for song in SharedData.shared.songs {
            let albumName = SharedData.shared.albums.first { $0.id == song.album_id }?.title ?? "Unknown Policy"
            let genreName = SharedData.shared.genres.first { $0.id == song.genre_id }?.name ?? "Unknown Payment"
            
            displayText += """
            Title: \(song.title),
            Amount: \(song.duration),
            Date: \(song.dateOfClaim),
            Status: \(song.favorite ? "Approved" : "Rejected"),
            Policy: \(albumName),
            Payment: \(genreName)
            
            """
        }
        
        // Assuming you have a UITextView in your storyboard named `claimsTextView`
        claimsTextView.text = displayText
        claimsTextView.isHidden = false // Make sure the text view is visible
    }

    
    
//    @IBAction func searchSong(_ sender: UIButton) {
//        guard let searchText = songTitleTextField?.text, !searchText.isEmpty else {
//            showAlert(title: "Error", message: "Please Enter Song Title.")
//            return
//        }
//        
//        let searchResults = SharedData.shared.songs.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//        
//        if searchResults.isEmpty {
//            showAlert(title: "No Results", message: "No Songs Found Matching The Search Term.")
//        } else {
//            var displayText = "Search Results:\n"
//            for song in searchResults {
//                displayText += "ID: \(song.id), Title: \(song.title), Duration: \(song.duration) minutes, Favorite: \(song.favorite ? "Yes" : "No")\n"
//            }
//            showAlert(title: "Search Results", message: displayText)
//            songIDTextField?.text = ""
//            songTitleTextField?.text = ""
//            songDuration?.text = ""
//            songFavorite?.text = ""
//        }
//    }
//    
    
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

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension ClaimViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == albumPicker {
            return SharedData.shared.albums.count
        } else if pickerView == genrePicker {
            return SharedData.shared.genres.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == albumPicker {
            return SharedData.shared.albums[row].title
        } else if pickerView == genrePicker {
            return SharedData.shared.genres[row].name
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == albumPicker {
            selectedAlbum = SharedData.shared.albums[row]
        } else if pickerView == genrePicker {
            selectedGenre = SharedData.shared.genres[row]
        }
    }
}
