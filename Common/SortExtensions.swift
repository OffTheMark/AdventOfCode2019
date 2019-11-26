//
//  SortExtensions.swift
//  Common
//
//  Created by Marc-Antoine Malépart on 2019-11-26.
//  Copyright © 2019 Marc-Antoine Malépart. All rights reserved.
//

import Foundation

// MARK: SortOrder

///
/// Ordre permettant de trier des éléments d'une liste.
///
/// Ce type est inspiré de (cet article](https://www.swiftbysundell.com/tips/passing-operators-as-functions/) de John Sundell.
///
public enum SortOrder {
    /// Ordre croissant.
    case ascending

    /// Ordre décroissant.
    case descending

    /// Retourne la fonction de comparaison permettant de comparer deux valeurs de type `T`.
    func makeComparator<T: Comparable>() -> (T, T) -> Bool {
        switch self {
        case .ascending:
            return (<)

        case .descending:
            return (>)
        }
    }

    /// Retourne la fonction de comparaison permettant de comparer deux valeurs de type `Optional<T>`.
    func makeComparator<T: Comparable>() -> (Optional<T>, Optional<T>) -> Bool {
        let valueComparator: (T, T) -> Bool = makeComparator()

        return { first, second in
            switch (first, second) {
            case (let first?, let second?):
                return valueComparator(first, second)

            case (.some, .none):
                return self == .ascending

            case (.none, .some):
                return self == .descending

            case (.none, .none):
                return false
            }
        }
    }
}

// MARK: - SortCriterion

///
/// Critère de tri permettant de trier des éléments de type `Element`.
///
public struct SortCriterion<Element> {
    // MARK: Propriétés

    /// Prédicat indiquant si le premier argument devrait être ordonné avant le second argument.
    public let areInIncreasingOrder: (Element, Element) -> Bool

    /// Prédicat indiquant si le premier argument est dans le même ordre que le second argument.
    public let areInEqualOrder: (Element, Element) -> Bool

    // MARK: Créer un SortCriterion

    /// Crée un nouveau critère de tri avec les prédicats fournis.
    ///
    /// - Parameters:
    ///   - areInIncreasingOrder: Prédicat indiquant si le premier argument devrait être ordonné avant le second argument.
    ///   - areInEqualOrder: Prédicat indiquant si le premier argument est dans le même ordre que le second argument.
    ///
    /// Le prédicat indiquant si les arguments sont en ordre croissant doit être un _tri strict faible_. C'est-à-dire que pour n'importe quel élément
    /// `a`, `b` et `c`, ces conditions doivent être vraies:
    /// - `areInIncreasingOrder(a, a) est toujours `false`. (Irréflexivité)
    /// - Si `areInIncreasingOrder(a, b)` et `areInIncreasingOrder(b, c)` sont tous deux `true`, alors `areInIncreasingOrder(a, c)` est aussi `true`.
    /// (Comparabilité transitive)
    /// - Deux éléments sont incomparables si ni l'un ni l'autre ne peut être triés avant l'autre en fonction du prédicat. Si `a` et `b` sont
    /// incomparables et que `b` et `c` sont incomparables alors `a` et `c` sont aussi incomparables. (Incomparabilité transitive)
    ///
    public init(
        areInIncreasingOrder: @escaping (Element, Element) -> Bool,
        areInEqualOrder: @escaping (Element, Element) -> Bool
        ) {

        self.areInIncreasingOrder = areInIncreasingOrder
        self.areInEqualOrder = areInEqualOrder
    }

    /// Crée un nouveau critère de tri en fonction de la valeur représentée par `keyPath` et dans l'ordre représenté par `order`.
    ///
    /// - Parameters:
    ///   - keyPath: Valeur des éléments en fonction de laquelle on veut trier.
    ///   - order: Ordre dans lequel trier les éléments.
    public init<Value: Comparable>(keyPath: KeyPath<Element, Value>, order: SortOrder = .ascending) {
        let valueComparator: (Value, Value) -> Bool = order.makeComparator()
        let areInIncreasingOrder: (Element, Element) -> Bool = { first, second in
            return valueComparator(first[keyPath: keyPath], second[keyPath: keyPath])
        }

        let areInEqualOrder: (Element, Element) -> Bool = { first, second in
            return first[keyPath: keyPath] == second[keyPath: keyPath]
        }

        self.init(areInIncreasingOrder: areInIncreasingOrder, areInEqualOrder: areInEqualOrder)
    }

    /// Crée un nouveau critère de tri en fonction de la valeur optionnelle représentée par `keyPath` et dans l'ordre représenté par `order`.
    ///
    /// - Parameters:
    ///   - keyPath: Valeur optionnelle des éléments en fonction de laquelle on veut trier.
    ///   - order: Ordre dans lequel trier les éléments.
    public init<Value: Comparable>(keyPath: KeyPath<Element, Value?>, order: SortOrder = .ascending) {
        let optionalValueComparator: (Value?, Value?) -> Bool = order.makeComparator()
        let areInIncreasingOrder: (Element, Element) -> Bool = { first, second in
            return optionalValueComparator(first[keyPath: keyPath], second[keyPath: keyPath])
        }

        let areInEqualOrder: (Element, Element) -> Bool = { first, second in
            return first[keyPath: keyPath] == second[keyPath: keyPath]
        }

        self.init(areInIncreasingOrder: areInIncreasingOrder, areInEqualOrder: areInEqualOrder)
    }
}

// MARK: - Sequence

public extension Sequence {
    /// Retourne les éléments de la séquence triés en fonction de la valeur représentée par `keyPath` et dans l'ordre représenté par `order`.
    ///
    /// - Parameters:
    ///   - keyPath: Valeur des éléments en fonction de laquelle on veut trier.
    ///   - order: Ordre dans lequel trier les éléments.
    ///
    /// - Returns: Une liste triée des éléments de la séquence.
    ///
    /// Dans ce premier exemple, on trie une séquence de `String` en ordre croissant de `count`.
    /// ````
    /// let names: [String] = ["Adam", "John", "Eve", "Michael"]
    /// let sorted = names.sorted(by: \.count, order: .ascending)
    /// print(sorted)
    /// // Imprime "["Eve", "Adam", "John", "Michael"]"
    /// ````
    ///
    /// Dans ce second exemple, on trie cette méme séquence en ordre décroissant de `count`.
    /// ````
    /// let names: [String] = ["Adam", "John", "Eve", "Michael"]
    /// let sorted = names.sorted(by: \.count, order: .descending)
    /// print(sorted)
    /// // Imprime "["Michael", "Adam", "John", "Eve"]"
    /// ````
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>, order: SortOrder = .ascending) -> [Element] {
        let criterion = SortCriterion(keyPath: keyPath, order: order)

        return sorted(by: [criterion])
    }

    /// Retourne les éléments de la séquence triés en fonction de la valeur optionnelle représentée par `keyPath` et dans l'ordre représenté par
    /// `order`.
    ///
    /// - Parameters:
    ///   - keyPath: Valeur optionnelle des éléments en fonction de laquelle on veut trier.
    ///   - order: Ordre dans lequel trier les éléments.
    ///
    /// - Returns: Une liste triée des éléments de la séquence.
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value?>, order: SortOrder = .ascending) -> [Element] {
        let criterion = SortCriterion(keyPath: keyPath, order: order)

        return sorted(by: [criterion])
    }

    /// Retourne les éléments de la séquence trié en fonction des critères de tri fournis.
    ///
    /// - Parameters:
    ///   - criteria: Critères de tri.
    ///
    /// - Returns: Une liste triée des éléments de la séquence.
    func sorted(by criteria: [SortCriterion<Element>]) -> [Element] {
        let areInIncreasingOrder: (Element, Element) -> Bool = { first, second in
            for criterion in criteria {
                if criterion.areInEqualOrder(first, second) {
                    continue
                }

                return criterion.areInIncreasingOrder(first, second)
            }

            return false
        }

        return sorted(by: areInIncreasingOrder)
    }
}

// MARK: - MutableCollection

public extension MutableCollection where Self: RandomAccessCollection {
    /// Trie la collection en fonction de la valeur représentée par `keyPath` et dans l'ordre représenté par `order`.
    ///
    /// - Parameters:
    ///   - keyPath: Valeur des éléments en fonction de laquelle on veut trier.
    ///   - order: Ordre dans lequel trier les éléments.
    ///
    /// Dans ce premier exemple, on trie une collection de `String` en ordre croissant de `count`.
    /// ````
    /// var names: [String] = ["Adam", "John", "Eve", "Michael"]
    /// names.sort(by: \.count, order: .ascending)
    /// print(names)
    /// // Imprime "["Eve", "Adam", "John", "Michael"]"
    /// ````
    ///
    /// Dans ce second exemple, on trie cette méme collection en ordre décroissant de `count`.
    /// ````
    /// var names: [String] = ["Adam", "John", "Eve", "Michael"]
    /// names.sort(by: \.count, order: .descending)
    /// print(names)
    /// // Imprime "["Michael", "Adam", "John", "Eve"]"
    /// ````
    mutating func sort<Value: Comparable>(by keyPath: KeyPath<Element, Value>, order: SortOrder = .ascending) {
        let criterion = SortCriterion(keyPath: keyPath, order: order)

        sort(by: [criterion])
    }

    /// Trie la collection en fonction de la valeur optionnelle représentée par `keyPath` et dans l'ordre représenté par `order`.
    ///
    /// - Parameters:
    ///   - keyPath: Valeur optionnelle des éléments en fonction de laquelle on veut trier.
    ///   - order: Ordre dans lequel trier les éléments.
    mutating func sort<Value: Comparable>(by keyPath: KeyPath<Element, Value?>, order: SortOrder = .ascending) {
        let criterion = SortCriterion(keyPath: keyPath, order: order)

        sort(by: [criterion])
    }

    /// Trie la collection en fonction des critères de tri fournis.
    ///
    /// - Parameter criteria: Critères de tri.
    mutating func sort(by criteria: [SortCriterion<Element>]) {
        let areInIncreasingOrder: (Element, Element) -> Bool = { first, second in
            for criterion in criteria {
                if criterion.areInEqualOrder(first, second) {
                    continue
                }

                return criterion.areInIncreasingOrder(first, second)
            }

            return false
        }

        sort(by: areInIncreasingOrder)
    }
}
