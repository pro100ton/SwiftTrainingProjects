//
//  BasicCollectionViewController.swift
//  BasicCollectionView
//
//  Created by Антон Шалимов on 30.03.2023.
//

import UIKit

private let reuseIdentifier = "Cell"
private let items = [
    "Alabama", "Alaska", "Arizona", "Arkansas", "California",
        "Colorado", "Connecticut", "Delaware", "Florida",
        "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
        "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
        "Massachusetts", "Michigan", "Minnesota", "Mississippi",
        "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
        "New Jersey", "New Mexico", "New York", "North Carolina",
        "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
        "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
        "Texas", "Utah", "Vermont", "Virginia", "Washington",
        "West Virginia", "Wisconsin", "Wyoming"
]

class BasicCollectionViewController: UICollectionViewController {
    
    // MARK: Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Сообщаем нашему CV чтобы он использовал наш сгенерированный ниже layout
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    
    
    /// Метод генерации kayout'a нашего collection view
    private func generateLayout() -> UICollectionViewLayout {
        /// Первым делом надо установить параметры самого низкоуровневого объекта - item'a
        ///
        /// Для начала определяем размер нашего item'a
        /// Он по сути равен полной ширине и высоте группы
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        /// Далее создаем item путем вызова  `NSCollectionLayoutItem` с заданными выше
        /// параметрами размера
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        /// Настраиваем рассатояние между группами
        let spacing: CGFloat = 10
        
        /// Далее нам необходимо провести настройку размеров group нашей коллекции
        /// В этом примере мы устанавливаем ширину равной полной ширине нашей секции,
        /// а высоту равной 70 пунктам
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(70.0)
        )
        
        /// Далее создаем нашу группу с горизаонтальным layout'ом путем передачи внутрь
        /// размера layout'a = нашему размеру `groupSize` и указываем какие объекты будут лежать внутри этой группы
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        
        /// Задаем отступы контента нашей группы
        group.contentInsets = NSDirectionalEdgeInsets(
            top: spacing, leading: spacing, bottom: 0, trailing: spacing
        )
        
        /// Предпоследним шагом является создание секции, в которой будет содержаться наша группа
        let section = NSCollectionLayoutSection(group: group)
        
        /// В конце мы задаем `layout`, которому передаем нашу секцию и возвращаем его
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    /*
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
     */
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath) as! BasicCollectionViewCell
        
        cell.label.text = items[indexPath.item]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
