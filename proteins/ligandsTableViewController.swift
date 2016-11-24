//
//  ligandsTableViewController.swift
//  proteins
//
//  Created by Celine DANNAPPE on 10/25/16.
//  Copyright © 2016 Celine DANNAPPE. All rights reserved.
//

import UIKit

class ligandsTableViewController: UITableViewController {
    var ligand_list: [String]?
    var atoms = [Int: AtomData]()
    var conects = [Int: ConectData]()
    
    func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
        guard let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") else {
            return nil
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
            return content.componentsSeparatedByString("\n")
        } catch _ as NSError {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ligand_list = arrayFromContentsOfFileWithName("ligands")
        print("*")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ligand_list!.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ligandCell", forIndexPath: indexPath)
        cell.textLabel?.text = ligand_list![indexPath.row]

        // Configure the cell...

        return cell
    }
    
    func treatLine(line:String) -> Bool {
        var words = line.componentsSeparatedByString(" ")
        words = words.filter { !($0 ?? "").isEmpty }
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
            words.removeAtIndex(1)
            words.removeAtIndex(0)
            guard let c = ConectData(main:main, connects: words)  else{
                print("error in atom construction")
                return false
            }
            conects[c.mainAtomKey] = c
            return true
        }
        return false
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        let url = NSURL(string: parturl)
        do {
            let file =  try String(contentsOfURL: url!, encoding:NSUTF8StringEncoding)
            let lines = file.componentsSeparatedByString("\n")
            for line in lines {
                if treatLine(line) == false {
                    print("error " + String(line))
                    return
                }
            }
            performSegueWithIdentifier("toVisu", sender: self)
            
        }
        catch {
            print("error")
        }
        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let ctrl = segue.destinationViewController as? ModelizationViewController {
            ctrl.atoms = self.atoms
            ctrl.conects = self.conects
        }
    }
    
}
