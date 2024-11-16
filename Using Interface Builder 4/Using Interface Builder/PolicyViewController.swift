import UIKit

class PolicyViewController: UIViewController {
    
    var artists: [Artist] {
        get { SharedData.shared.artists }
        set { SharedData.shared.artists = newValue }
    }
    
    var albums: [Album] {
        get { SharedData.shared.albums }
        set { SharedData.shared.albums = newValue }
    }
    
    var artistAlbumsDict: [Int: [Album]] {
        get { SharedData.shared.artistAlbumsDict }
        set { SharedData.shared.artistAlbumsDict = newValue }
    }
    
    @IBOutlet weak var albumTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var premiumAmountTextField: UITextField!
    @IBOutlet weak var policyTypeTextField: UITextField!
    @IBOutlet weak var policyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addAlbum(_ sender: UIButton) {
        guard let title = albumTextField?.text, !title.isEmpty,
              let premium_amount = premiumAmountTextField?.text, !premium_amount.isEmpty,
              let endDate = endDateTextField?.text, !endDate.isEmpty,
              let policyType = policyTypeTextField?.text, !policyType.isEmpty,
              let releaseDate = releaseDateTextField?.text, !releaseDate.isEmpty else {
            showAlert(title: "Error", message: "Please Enter Both Title, Start Date, End Date and Amount.")
            return
        }
        
        let actionSheet = UIAlertController(title: "Choose Customer", message: nil, preferredStyle: .actionSheet)
        for artist in artists {
            let action = UIAlertAction(title: artist.name, style: .default) { _ in
                self.handleArtistSelectionForAlbum(artist: artist, title: title, releaseDate: releaseDate, endDate: endDate, premiumAmount: premium_amount, policyType: policyType)
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)
    }
    
    func handleArtistSelectionForAlbum(artist: Artist, title: String, releaseDate: String, endDate: String, premiumAmount: String, policyType: String) {
        if let albumsForArtist = artistAlbumsDict[artist.id], albumsForArtist.contains(where: { $0.title == title && $0.releaseDate == releaseDate }) {
            showAlert(title: "Error", message: "Policy with title '\(title)' and start date '\(releaseDate)' already exists for \(artist.name).")
            return
        }
        
        let albumId = SharedData.shared.albums.map { $0.id }.max() ?? 0 + 1
        let album = Album(id: albumId, artistId: artist.id, title: title, releaseDate: releaseDate, endDate: endDate, premium_amoumt: premiumAmount, policyType: policyType)
        SharedData.shared.albums.append(album)
        
        if var albumsForArtist = SharedData.shared.artistAlbumsDict[artist.id] {
            albumsForArtist.append(album)
            SharedData.shared.artistAlbumsDict[artist.id] = albumsForArtist
        } else {
            SharedData.shared.artistAlbumsDict[artist.id] = [album]
        }
        
        albumTextField.text = ""
        releaseDateTextField.text = ""
        premiumAmountTextField.text = ""
        endDateTextField.text = ""
        policyTypeTextField.text = ""
        
        showAlert(title: "Success", message: "Policy Successfully Added To \(artist.name).")
    }
    
    @IBAction func deleteAlbum(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Policy To Delete", message: nil, preferredStyle: .actionSheet)
        for album in SharedData.shared.albums {
            let action = UIAlertAction(title: album.title, style: .default) { [unowned self] _ in
                if SharedData.shared.songs.contains(where: { $0.album_id == album.id }) {
                    self.showAlert(title: "Error", message: "Cannot Delete Policy With Associated Claims.")
                } else {
                    if let index = SharedData.shared.albums.firstIndex(where: { $0.id == album.id }) {
                        
                        SharedData.shared.albums.remove(at: index)
                        
                        if var artistAlbums = SharedData.shared.artistAlbumsDict[album.artistId] {
                            artistAlbums.removeAll { $0.id == album.id }
                            SharedData.shared.artistAlbumsDict[album.artistId] = artistAlbums
                        }
                        
                        self.showAlert(title: "Success", message: "Policy Successfully Deleted.")
                    }
                }
            }
            actionSheet.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func updateAlbum(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Policy To Update", message: nil, preferredStyle: .actionSheet)
        for album in albums {
            let action = UIAlertAction(title: album.title, style: .default) { [unowned self] _ in
                let alert = UIAlertController(title: "Enter New Details", message: nil, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.placeholder = "New Title"
                    textField.text = album.title
                }
                alert.addTextField { textField in
                    textField.placeholder = "New Release Date"
                    textField.text = album.releaseDate
                }
                alert.addTextField { textField in
                    textField.placeholder = "New Premium Amount"
                    textField.text = album.premium_amoumt
                }
                alert.addTextField { textField in
                    textField.placeholder = "New Policy Type"
                    textField.text = album.policyType
                }
                let updateAction = UIAlertAction(title: "Update", style: .default) { [unowned self] _ in
                    if let newTitle = alert.textFields?[0].text, !newTitle.isEmpty,
                       let newReleaseDate = alert.textFields?[1].text, !newReleaseDate.isEmpty,
                       let newPremiumAmount = alert.textFields?[2].text, !newPremiumAmount.isEmpty,
                       let newPolicyType = alert.textFields?[3].text, !newPolicyType.isEmpty,


                       let index = self.albums.firstIndex(where: { $0.id == album.id }) {
                        self.albums[index].title = newTitle
                        self.albums[index].releaseDate = newReleaseDate
                        self.albums[index].premium_amoumt = newPremiumAmount
                        self.albums[index].policyType = newPolicyType


                        SharedData.shared.albums[index] = self.albums[index]
                        self.showAlert(title: "Success", message: "Policy Successfully Updated.")
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
    
    @IBAction func displayAlbum(_ sender: UIButton) {
        var displayText = "Policy:\n"
        for album in SharedData.shared.albums {
            let artistName = SharedData.shared.artists.first { $0.id == album.artistId }?.name ?? "Unknown Artist"
            displayText += """
            ID: \(album.id),
            Customer: \(artistName),
            Title: \(album.title),
            Start Date: \(album.releaseDate),
            End Date: \(album.endDate),
            Premium Amount: \(album.premium_amoumt),
            Policy Type: \(album.policyType)
            
            """
        }
        
        // Assuming you have a UITextView in your storyboard named `policyTextView`
        policyTextView.text = displayText
        policyTextView.isHidden = false // Make sure the text view is visible
    }

    
//    @IBAction func searchAlbum(_ sender: UIButton) {
//        guard let searchText = albumTextField?.text, !searchText.isEmpty else {
//            showAlert(title: "Error", message: "Please Enter A Search Term.")
//            return
//        }
//        
//        let searchResults = SharedData.shared.albums.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
//        
//        if searchResults.isEmpty {
//            showAlert(title: "No Results", message: "No Policy Found Matching The Search Term.")
//        } else {
//            var displayText = "Search Results:\n"
//            for album in searchResults {
//                displayText += "ID: \(album.id), Artist ID: \(album.artistId), Title: \(album.title), Release Date: \(album.releaseDate)\n"
//            }
//            albumTextField?.text = ""
//            releaseDateTextField?.text = ""
//            showAlert(title: "Search Results", message: displayText)
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


