//
//  FavoriteViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//
/*
import Foundation
import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    
    private var post: PostData?
    var refreshControl = UIRefreshControl()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var manageObjectContext: NSManagedObjectContext!
    private var fetchResultController: NSFetchedResultsController<NSFetchRequestResult>?
    
    
    private let background: UIImageView = {
        let back = UIImageView()
        back.clipsToBounds = true
        back.image = UIImage(named: "tekstura")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    //    private lazy var tableView: UITableView = {
    //        let tableView = UITableView(frame: .zero, style: .insetGrouped)
    //        tableView.translatesAutoresizingMaskIntoConstraints = false
    //        tableView.backgroundColor = .clear
    //        tableView.sectionHeaderHeight = UITableView.automaticDimension
    //        tableView.refreshControl = refreshControl
    //        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier: "FavoriteTableViewCell")
    //        return tableView
    //    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshControl
        collectionView.register(FavoriteCollectionViewCell.self, forCellWithReuseIdentifier: "FavoriteCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "favorites.title".localized
        //        tableView.dataSource = self
        //        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        refreshControl.attributedTitle = NSAttributedString(string: "refresh.update".localized)
        refreshControl.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        view.backgroundColor = .white
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchAction))
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(cancelFilteredSearchAction))
        manageObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        CoreDataManager.shared.outFromCoreData()
        collectionView.reloadData()
    }
    
    
    
    @objc func didTapRefresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func layout() {
        
        [background, collectionView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: background.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: background.bottomAnchor)
        ])
    }
    //доработать поиск по автору
    @objc func searchAction() {
        
        let alertController = UIAlertController(title: "Search author post", message: "", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter author"
        }
        
        let searchAction = UIAlertAction(title: "Search", style: .default, handler: { alert -> Void in
            if let textFileds = alertController.textFields {
                let newTextFiled = textFileds as [UITextField]
                let enterText = newTextFiled[0].text
                self.fetchFilter(enterText ?? "")
                self.collectionView.reloadData()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil )
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func fetchFilter(_ author: String) {
        //            let appDelegate = UIApplication.shared.delegate as? AppDelegate
        //
        //            let entityDescription = NSEntityDescription.entity(forEntityName: "PostData", in: appDelegate!.persistentContainer.viewContext)
        //
        //            let request = NSFetchRequest<NSFetchRequestResult>()
        //            request.entity = entityDescription
        //
        //            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        //            request.sortDescriptors = [sortDescriptor]
        //
        //            let predicate = NSPredicate(format: "authorCell == %@", author)
        //            request.predicate = predicate
        //
        //            fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: appDelegate!.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        //            fetchResultController?.delegate = self
        //
        //                do {
        //                    try fetchResultController?.performFetch()
        //
        //                } catch let error as NSError {
        //                    print(error.userInfo)
        //                }
        //            collectionView.reloadData()
        //        }
        //
        //        @objc func cancelFilteredSearchAction() {
        //
        //        }
    }
}

////MARK: ПРИМЕР С ТАБЛИЦЕЙ*/
//extension FavoriteViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//            let appDelegate = UIApplication.shared.delegate as? AppDelegate
//            let managedContext = appDelegate!.persistentContainer.viewContext
//            let person = CoreDataManager.shared.favoritePost[indexPath.row]
//
//            let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completionHandler) in
//                managedContext.delete(person as NSManagedObject)
//                CoreDataManager.shared.favoritePost.remove(at: indexPath.row)
//
//                do {
//                    try managedContext.save()
//                } catch
//                    let error as NSError {
//                    print("Could not save. \(error),\(error.userInfo)")
//                }
//                self.tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//
//            let swipeActionsConfig = UISwipeActionsConfiguration(actions: [delete])
//            swipeActionsConfig.performsFirstActionWithFullSwipe = true
//
//            return swipeActionsConfig
//        }
//}/*
//
//extension FavoriteViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return CoreDataManager.shared.favoritePost.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteTableViewCell", for: indexPath) as? FavoriteTableViewCell else { return UITableViewCell() }
//        let post = CoreDataManager.shared.favoritePost[indexPath.row]
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        cell.backgroundColor = .white
//        cell.myCells(post)
//        return cell
//    }
//}
//
//extension FavoriteViewController: NSFetchedResultsControllerDelegate {
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.beginInteractiveMovementForItem(at: IndexPath())
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//        switch type {
//        case .insert:
//            collectionView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
//        case .delete:
//            collectionView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
//        case .update:
//            collectionView.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
//        default:
//            return
//        }
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        switch type {
//        case .insert:
//            if let indexPath = indexPath {
//                collectionView.insertItems(at: [indexPath])
//            }
//        case .delete:
//            if let indexPath = indexPath {
//                collectionView.deleteItems(at: [indexPath])
//            }
//        case .update:
//            if let indexPath = indexPath {
////                let post = CoreDataManager.shared.favoritePost[indexPath.row]
//                guard let cell = collectionView.cellForItem(at: indexPath as IndexPath) as? FavoriteCollectionViewCell else { break }
////                cell.myCells(post)
//
//            }
//        case .move:
//            if let indexPath = indexPath {
//                collectionView.deleteItems(at: [indexPath])
//            }
//            if let newIndexPath = newIndexPath {
//                collectionView.insertItems(at: [newIndexPath])
//            }
//
//        @unknown default:
//            fatalError()
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.endInteractiveMovement()
//    }
//}
//
////MARK: ПРИМЕР С КОЛЛЕКЦИЕЙ
//extension FavoriteViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return CoreDataManager.shared.favoritePost.count
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCollectionViewCell", for: indexPath) as! FavoriteCollectionViewCell
////        let post = CoreDataManager.shared.favoritePost[indexPath.row]
//        cell.backgroundColor = .white
////        cell.myCells(post)
//        return cell
//    }
//*/
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        let managedContext = appDelegate!.persistentContainer.viewContext
//        let person = CoreDataManager.shared.favoritePost[indexPath.row]
//        let personTextForShare = CoreDataManager.shared.favoritePost[indexPath.row].authorCell
//        let personImageForShare = CoreDataManager.shared.favoritePost[indexPath.row].imageCell
//
//        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
//            
//            let share = UIAction(title: "Share", image: UIImage(systemName:"square.and.arrow.up.circle")) { _ in
//                
//                let avc = UIActivityViewController(activityItems: [personTextForShare as Any, personImageForShare as Any], applicationActivities: nil)
//        
//                self.present(avc, animated: true)
//            }
//            let remove = UIAction(title: "Remove Favorite", image: UIImage(systemName: "trash.circle"), attributes: .destructive) { _ in
//                
//                managedContext.delete(person as NSManagedObject)
//                CoreDataManager.shared.favoritePost.remove(at: indexPath.row)
//                
//                do {
//                    try managedContext.save()
//                } catch
//                    let error as NSError {
//                    print("Could not save. \(error),\(error.userInfo)")
//                }
//                self.collectionView.deleteItems(at: [indexPath])
//            }
//            
//            let menu = UIMenu(title: "", children: [share, remove])
//            return menu
//        })
//        return configuration
//    }
//}
/*
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {

    private var interSpace: CGFloat { return 8 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.bounds.width - interSpace * 4) / 3

        return CGSize(width: width, height: width)
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return interSpace

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        UIEdgeInsets(top: interSpace, left: interSpace, bottom: interSpace, right: interSpace)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return interSpace

    }
}
*/
