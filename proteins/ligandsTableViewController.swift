//
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
    var atoms = [Int: AtomData]()
    var conects = [Int: ConectData]()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if (AuthentificationManager.sharedInstance.needsAuthentication) {
            // call authentication methods
            print("show auth method")
        }
        ligand_list = arrayFromContentsOfFileWithName("ligands")
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
         definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        print("*")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            
        // Configure the cell...

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
            atoms[a.key] = a
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
            conects[c.mainAtomKey] = c
            return true
        }
        return false
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lig = ligand_list?[indexPath.row]
        print(lig!)
        
       /* let lines = arrayFromContentsOfFileWithName("ATP_ideal")
        for line in lines! {
            print(line)
            if treatLine(line) == false {
                print("error " + String(line))
                return
            }
        }
        performSegueWithIdentifier("toVisu", sender: self)*/
        let parturl = "http://ligand-expo.rcsb.org/reports/\(lig!.characters.first!)/\(lig!)/\(lig!)_ideal.pdb"
        let url = URL(string: parturl)
        do {
            print (parturl)
            let file =  try String(contentsOf: url!, encoding:String.Encoding.utf8)
            let lines = file.components(separatedBy: "\n")
            for line in lines {
                if self.treatLine(line) == false {
                    print("error " + String(line))
                    return
                }
            }
            self.performSegue(withIdentifier: "toVisu", sender: self)
        }
        catch {
            print("error")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ctrl = segue.destination as? ModelizationViewController {
            ctrl.atoms = self.atoms
            ctrl.conects = self.conects
        }
    }
    
}
