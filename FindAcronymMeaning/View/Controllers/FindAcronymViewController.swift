//
//  FindAcronymViewController.swift
//  FindAcronymMeaning
//
//  Created by TCS on 10/07/23.
//

import Foundation
import UIKit

class FindAcronymViewController: UIViewController {
    
    var findAcronymViewModel: FindAcronymViewModelProtcol = FindAcronymViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
}

extension FindAcronymViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return findAcronymViewModel.prodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //define custom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }
        cell.title.text = findAcronymViewModel.prodArray[indexPath.row].title
        cell.price.text = "\(findAcronymViewModel.prodArray[indexPath.row].price)"
        return cell
    }
}

extension FindAcronymViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        findAcronymViewModel.getListOfAcronymMeaning(searchString: searchText) { result in
            DispatchQueue.main.async {
                if result {
                    self.tableView.reloadData()
                } else {
                    // show alert (we can show error in alert form so user can
                    let alert = UIAlertController(title: "Error Alert!", message: "Error Occured No Data Found !!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension FindAcronymViewController {
    static func instantiate() -> Self? {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FindAcronymViewController") as? Self else {
            return nil
        }
        return vc
    }
    
}
