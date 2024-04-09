//
//  PlaylistByGenreViewController.swift
//  Lesson12HW
//

//

import UIKit

class PlaylistByGenreViewController: UIViewController {
    
    @IBOutlet weak var contentView: PlaylistByGenreView!
    var model: PlaylistByGenreModel!
    var genres: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        model.loadData()
        
        genres = Array(Set(model.items.map { $0.genre }))
    }
    
    private func setupInitialState() {
        
        model = PlaylistByGenreModel()
        model.delegate = self
        
        contentView.delegate = self
        
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
}


extension PlaylistByGenreViewController: PlaylistByGenreModelDelegate {
    
    func dataDidLoad() {
        contentView.tableView.reloadData()
    }
}

extension PlaylistByGenreViewController: PlaylistByGenreViewDelegate {
    
}

extension PlaylistByGenreViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
                return genres.count
      }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

         return genres[section]
     }
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let genre = genres[section]
        let songsInSection = model.items.filter { $0.genre == genre }
        return songsInSection.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainPlaylistCell")
            else {
                assertionFailure()
                return UITableViewCell()
            }
            
            let genre = genres[indexPath.section]
            let songsInSection = model.items.filter { $0.genre == genre }
            
            cell.textLabel?.text = songsInSection[indexPath.row].songTitle
            cell.detailTextLabel?.text = "\(songsInSection[indexPath.row].author) -  \(songsInSection[indexPath.row].albumTitle) -  \(songsInSection[indexPath.row].genre)"
            
            return cell
        }
}

extension PlaylistByGenreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
