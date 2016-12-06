
//  ligandsTableViewController.swift
//  proteins
//
//  Created by Celine DANNAPPE on 10/25/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit

class ligandsTableViewController: UITableViewController, UISearchResultsUpdating {

    var ligand_list: [String]?
    var ligand_list_filter = [String]()
    let searchController = UISearchController(searchResultsController: nil)
    
    func arrayFromContentsOfFileWithName(_ fileName: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch _ as NSError {
            return nil
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchFilterLigand(searchController.searchBar.text!)
    }
    
    func testForeground() {
        performSegue(withIdentifier: "goback", sender: nil)
        AuthentificationManager.sharedInstance.needsAuthentication = true
        if (AuthentificationManager.sharedInstance.needsAuthentication) {
            _ = navigationController?.popToRootViewController(animated: true)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //POUR QUAND ON REVIENT DU BACKGROOUND
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ligandsTableViewController.testForeground), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        ligand_list = arrayFromContentsOfFileWithName("ligands")
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

    }
    
    func searchFilterLigand(_ searchText: String, scope: String = "All") {
        ligand_list_filter = ligand_list!.filter { lig in
            return lig.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return ligand_list_filter.count        }
        return ligand_list!.count
        // #warning Incomplete implementation, return the number of rows
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCell", for: indexPath)
        
        
        cell.textLabel?.text = ligand_list![indexPath.row]
        if searchController.isActive && searchController.searchBar.text != "" {
            cell.textLabel?.text = ligand_list_filter[indexPath.row]
        }
        else {
            cell.textLabel?.text = ligand_list![indexPath.row]
        }

        return cell
    }
    
    func treatLine(_ line:String) -> Bool {
        var words = line.components(separatedBy: " ")
        words = words.filter { !($0 ).isEmpty }
        if words.isEmpty || words[0] == "END" {
            return true
        }
        if words.count == 12 && words[0] == "ATOM"{
            guard let a = AtomData(k: words[1], px: words[6], py: words[7], pz: words[8], elem: words[11]) else{
                print("error in atom construction")
                return false
            }
            AtomData.all[a.key] = a
            return true
        }
        else if words[0] == "CONECT" {
            let main = words[1]
            words.remove(at: 1)
            words.remove(at: 0)
            guard let c = ConectData(main:main, connects: words)  else{
                print("error in atom construction")
                return false
            }
            ConectData.all[c.mainAtomKey] = c
            return true
        }
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let lig = ligand_list?[indexPath.row]
        let q = DispatchQueue.global(qos: .userInteractive)
        let parturl = "http://ligand-expo.rcsb.org/reports/\(lig!.characters.first!)/\(lig!)/\(lig!)_ideal.pdb"
        let url = URL(string: parturl)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        q.async() {
            do {
                print (parturl)
                let file =  try String(contentsOf: url!, encoding:String.Encoding.utf8)
                let lines = file.components(separatedBy: "\n")
                for line in lines {
                    if self.treatLine(line) == false {
                        DispatchQueue.main.async() {
                            let alertController = UIAlertController(title: "Error", message:"The file has datas malformed : "+String(line), preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "Too bad", style: UIAlertActionStyle.default,handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                        return
                    }
                }
                DispatchQueue.main.async() {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.performSegue(withIdentifier: "toVisu", sender: self)
                }
            }
            catch {
                DispatchQueue.main.async() {
                    let alertController = UIAlertController(title: "Error", message:"Cannot access to "+parturl, preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Too bad", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
}
