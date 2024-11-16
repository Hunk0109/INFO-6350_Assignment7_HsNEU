import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func artistButton(_ sender: UIButton) {
        let artistVC = CustomerViewController(nibName: "CustomerViewScreen", bundle: nil)
        self.present(artistVC, animated: true, completion: nil)
    }
    
    @IBAction func albumButton(_ sender: UIButton) {
        let albumVC = PolicyViewController(nibName: "PolicyViewScreen", bundle: nil)
        self.present(albumVC, animated: true, completion: nil)
    }
    
    @IBAction func songButton(_ sender: UIButton) {
        let songVC = ClaimViewController(nibName: "ClaimViewScreen", bundle: nil)
        self.present(songVC, animated: true, completion: nil)
    }
    
    @IBAction func genreButton(_ sender: UIButton) {
        let genreVC = PaymentViewController(nibName: "PaymentViewScreen", bundle: nil)
        self.present(genreVC, animated: true, completion: nil)
    }
}
