//
//  PokeSearchResultsController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/8.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit
import PokemonKit

class PokeSearchResultsController: UITableViewController {

    var filteredCountries = [PKMPokemon]()
    
    // MARK: Types
    
    static let nibName = "CountryTableViewCell"
    static let cellIdentifier = "cellID"
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let nib = UINib(nibName: CountryBaseController.nibName, bundle: nil)
        
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        //tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func configureCell(cell: UITableViewCell, forPokemon pokemon: PKMPokemon) {
        cell.textLabel?.text = pokemon.name
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PokeSearchResultsController.cellIdentifier)!
        
        let pokemon = filteredCountries[indexPath.row]
        configureCell(cell, forPokemon: pokemon)
        
        return cell
    }
}
