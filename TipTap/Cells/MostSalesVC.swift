//
//  MostSalesVC.swift
//  TipTapHome_MostSales
//
//  Created by Toqsoft on 31/10/23.
//

import UIKit

class MostSalesVC: UIViewController {
    let imageArray = ["delicious-indian-food-tray (1)","penne-pasta-tomato-sauce-with-chicken-tomatoes-wooden-table","pizza-pizza-filled-with-tomatoes-salami-olives","top-view-delicious-noodles-concept"]
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var MostSalesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setUI()
        MostSalesTableView.delegate = self
        MostSalesTableView.dataSource = self
    }
    
    func setUI(){
        TitleLabel.applyTitleStyle()
        TitleLabel.text = "Most Sales"
      //  titleButton.setTitleButtonStyle(title: "26 Places >>")

        
    }
 
}
extension MostSalesVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let salesCell = MostSalesTableView.dequeueReusableCell(withIdentifier: "MostSalesTVC", for: indexPath)as! MostSalesTVC
        let imageName = imageArray[indexPath.row]
        salesCell.configure(with: imageName)
        return salesCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
