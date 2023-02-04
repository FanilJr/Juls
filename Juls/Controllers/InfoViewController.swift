//
//  InfoViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.02.2023.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.clipsToBounds = true
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .clear
        return scroll
    }()
    
    let contentView: UIView = {
        let content = UIView()
        content.backgroundColor = .clear
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    let labelView: UILabel = {
        let label = UILabel()
        label.text = "Важная информация"
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = #"""
            Все что исправить:\#n
            1. Загрузка нового поста происходит старой картинки, добавляется сначала другая картинка, почему так? из-за фильтра?\#n
            2. Не нашел куда запихнуть код обновления массива поста (удаления), чтобы получить обновленный массив. Происходит это так: при обновлении появляется пустой экран, затем новые посты\#n
            3. Как запихнуть картинки поста в весь их рост, а не обрезая их под конкретный height\#n
            4. Обновление количества (именно цифры), подписчиков происходит его наполнением - нумерация (1,2,3,4) из-за этого появляется большой массив - нашел применение закинуть в set, но это не правильно\#n
            5. Не сделал комментарии, лайки постов\#n
            """#
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Информация"
        view.backgroundColor = .white
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        setup()
    }
    
    func blure() {
        let bluer = UIBlurEffect(style: .light)
        let bluerView = UIVisualEffectView(effect: bluer)
        
        bluerView.frame = (tabBarController?.tabBar.bounds)!
    }
    
    
    
    func setup() {
        [labelView, infoLabel].forEach { contentView.addSubview($0) }
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 22),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            infoLabel.topAnchor.constraint(equalTo: labelView.bottomAnchor,constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
            
        ])
    }
}
