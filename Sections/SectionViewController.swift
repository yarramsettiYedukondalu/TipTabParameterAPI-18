//
//  SectionViewController.swift
//  TipTap
//
//  Created by yarramsetti yedukondalu on 13/11/23.
//

import UIKit

class SectionViewController: UIViewController {
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var SectionTableview: UITableView!
    var waiterImageArray = ["waiter3","waiter4","waiter"]
    var waiterName = ["Rsfi shaik","Reshma begam","Nagurmeravali"]
    var Date  = ["14-08-2023","20-09-2023","25-10-2023"]
    var amount = ["SAR 100","SAR 400","SAR 800"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setUI()
        SectionTableview.dataSource = self
        SectionTableview.delegate = self
        SectionTableview.register(UINib(nibName: "SectionTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        sectionView.layer.cornerRadius = 10
        sectionView.clipsToBounds = true
    }
    func setUI(){
        titleLabel.applyLabelStyle(for: .headingBlack)
    }
    @IBAction func buttonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

    extension SectionViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return waiterImageArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SectionTableViewCell
            
           
            cell.sectrionImage.image = UIImage(named: waiterImageArray[indexPath.row])
            cell.nameLabel.text = waiterName[indexPath.row]
            cell.amountLabel.text = amount[indexPath.row]
            cell.dateLabel.text = Date[indexPath.row]
           
            cell.backView.layer.cornerRadius = 3
            cell.backView.layer.masksToBounds = true
            cell.backView.layer.shadowColor = UIColor.black.cgColor
            cell.backView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cell.backView.layer.shadowRadius = 2
            cell.backView.layer.shadowOpacity = 0.3
            cell.backView.layer.masksToBounds = false
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        }
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
               return 15
           }
    }



