//
//  PlaylistModesViewController.swift
//  Lesson12HW
//

//

import UIKit

class PlaylistModesViewController: UIViewController {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var contentView: PlaylistModesView!
    var model: PlaylistModesModel!
    var selectedMode: PlaylistMode = .all
    
    var genres: [String] = []
    var authors: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        model.loadData()
    
        genres = Array(Set(model.items.map { $0.genre }))
        authors = Array(Set(model.items.map { $0.author }))
        
    }
    
    private func setupInitialState() {
        
        model = PlaylistModesModel()
        model.delegate = self
        
        contentView.delegate = self
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
        setupSegmentControl()
    }
    
    func setupSegmentControl(){
        let items = ["All", "Genre", "Author"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        navigationItem.titleView = segmentedControl
        segmentedControl.selectedSegmentIndex = 0

    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedMode = .all
        case 1:
            selectedMode = .genre
        case 2:
            selectedMode = .author
        default:
            break
        }
        
        contentView.tableView.reloadData()
    }
}

extension PlaylistModesViewController: PlaylistModesModelDelegate {
    
    func dataDidLoad() {
        contentView.tableView.reloadData()
    }
}

extension PlaylistModesViewController: PlaylistModesViewDelegate {
    
}


extension PlaylistModesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedMode {
        case .all:
            return 1
        case .genre:
            return genres.count
        case .author:
            return authors.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedMode {
        case .all:
            return nil
        case .genre:
            return genres[section]
        case .author:
            return authors[section]
        }
    }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedMode {
        case .all:
            return model.items.count
        case .genre:
            let genre = genres[section]
            let songsInSection = model.items.filter { $0.genre == genre }
            return songsInSection.count
            
        case .author:
            let author = authors[section]
            let songsInSection = model.items.filter { $0.author == author }
            return songsInSection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainPlaylistCell")
        else {
            assertionFailure()
            return UITableViewCell()
        }
        
        switch selectedMode {
            
        case .all:
            cell.textLabel?.text = model.items[indexPath.row].songTitle
            cell.detailTextLabel?.text = "\(model.items[indexPath.row].author) - \(model.items[indexPath.row].albumTitle) - \(model.items[indexPath.row].genre)"
            
        case .genre:
            let genre = genres[indexPath.section]
            let songsInSection = model.items.filter { $0.genre == genre }
            
            cell.textLabel?.text = songsInSection[indexPath.row].songTitle
            cell.detailTextLabel?.text = "\(songsInSection[indexPath.row].author) -  \(songsInSection[indexPath.row].albumTitle) -  \(songsInSection[indexPath.row].genre)"
            
        case .author:
            let author = authors[indexPath.section]
            let songsInSection = model.items.filter { $0.author == author }
            cell.textLabel?.text = songsInSection[indexPath.row].songTitle
            cell.detailTextLabel?.text = "\(songsInSection[indexPath.row].author) - \(songsInSection[indexPath.row].albumTitle) - \(songsInSection[indexPath.row].genre)"
        }
        
        return cell
    }
}


extension PlaylistModesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

enum PlaylistMode {
    case all
    case genre
    case author
}
