//
//  ThreeDotsVC.swift
//  TipTap
//
//  Created by sriram on 04/11/23.
//

import UIKit
protocol MenuPopoverDelegateForAdmin: class {
    func numberOfCells()-> Int
    func valueForRow(atIndexpath indexPath: IndexPath) -> String
}
class ThreeDotsVC: UIViewController,UIPopoverPresentationControllerDelegate {
    
    var barbuttonItem: UIBarButtonItem?
    var navnController: UINavigationController = UINavigationController()
    var sourceRect: CGRect? = CGRect()
    var sourceView: UIView? = UIView()
    var contentSize: CGSize? = CGSize()
    weak var delegate: MenuPopoverDelegateForAdmin!
    var popoverdirection: UIPopoverArrowDirection = .up
    
    @IBOutlet weak var threeDotsotTableView: UITableView!
    var data = ["Feedback","Enquiry","Report an app","Terms and Conditions","Privacy PolicyPrivacy Policy","Logout"]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.delegate = self
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        threeDotsotTableView.delegate = self
        threeDotsotTableView.dataSource = self
        
        let tableViewWidth: CGFloat = 200.0
        let tableViewHeight: CGFloat = 40.0 * CGFloat(data.count)
        let tableViewY: CGFloat = self.view.frame.width // This will position it off-screen to the right
        let bottomHeightIncrease: CGFloat = 10

        threeDotsotTableView.frame = CGRect(x: 200, y:tableViewY, width: tableViewWidth, height: tableViewHeight + bottomHeightIncrease)


//        threeDotsotTableView.delegate = self
//        threeDotsotTableView.dataSource = self
// 
//        let tableViewWidth: CGFloat = 200.0
//        let tableViewHeight: CGFloat = 40.0 * CGFloat(data.count)
//        let tableViewX: CGFloat = self.view.frame.width - tableViewWidth - 50
//        let bottomHeightIncrease: CGFloat = 10
// 
//        threeDotsotTableView.frame = CGRect(x: tableViewX, y: tableViewHeight - bottomHeightIncrease, width: tableViewWidth, height: tableViewHeight + bottomHeightIncrease)
//        contentSize = CGSize(width: tableViewX + tableViewWidth + 50, height: tableViewHeight + 10)
//        sourceView = self.view
    }
 
}
extension ThreeDotsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "3dotsCell", for: indexPath)
 
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .right
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
        self.popoverPresentationController?.sourceRect = self.sourceRect!
        self.popoverPresentationController?.permittedArrowDirections = []
        self.popoverPresentationController?.sourceView = self.sourceView!
        preferredContentSize = self.contentSize!
        
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
