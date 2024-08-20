//
//  FilterVC.swift
//  TipTap
//
//  Created by sriram on 17/11/23.
//

import UIKit

 
protocol filterOptionDelegate {
    func applyFilterInTerendigThisWeekVC(_ vc : FilterVC, option:String)
}


class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
     var delegate : filterOptionDelegate?
    var FromItems = false
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var filterTableView: UITableView!
    var selectedIndexPath: IndexPath?
    var filterData = ["Top Rated", "Nearest Me", "Most Popular", "Favourite"]
    
    var filterItemData = ["Top Rated", "Most Popular", "Favourite"]
    var selectedOption = ""
 
    override func viewDidLoad() {
        super.viewDidLoad()
    
        backView.layer.cornerRadius = 10
        filterTableView.layer.cornerRadius = 10
        filterTableView.delegate = self
        filterTableView.dataSource = self
        
    }
    
    @IBAction func closeBtnAct(_ sender: Any) {
        self.dismiss(animated: true)
    }
 
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        self.delegate?.applyFilterInTerendigThisWeekVC(self, option: selectedOption)
        
        
        self.dismiss(animated: true)
        
    }
 
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "SORT BY"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.black,
            ]
            
            header.textLabel?.attributedText = NSAttributedString(string: header.textLabel?.text ?? "", attributes: attributes)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if FromItems{
            return filterItemData.count
        }else{
            return filterData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterCell", for: indexPath) as! filterTVC
        var data : [String] = []
        
        if FromItems{
            data = filterItemData
        }else{
            data = filterData
        }
        cell.titleLabel.text = data[indexPath.row]
        cell.Circlebutton.tag = indexPath.row
        if indexPath == selectedIndexPath {
            cell.Circlebutton.setImage(UIImage(named: "circle.red"), for: .normal)
        } else {
            cell.Circlebutton.setImage(UIImage(named: "circle.black"), for: .normal)
        }
    
        cell.radioButtonTapped = { [weak self, weak cell] in
            guard let indexPath = tableView.indexPath(for: cell!) else { return }
            // Update the selected index path and reload the table
            self?.selectedIndexPath = indexPath
            var data : [String] = []
            if self!.FromItems{
                data = self?.filterItemData ?? []
            }else{
                data = self?.filterData ?? []
            }
            self?.selectedOption = data[indexPath.row]
            tableView.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data : [String] = []
        
        if FromItems{
            data = filterItemData
        }else{
            data = filterData
        }
        selectedIndexPath = indexPath
        selectedOption = data[indexPath.row]
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
 
