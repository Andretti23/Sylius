@ui-cart
Feature: Apply different taxes for variants with different tax category
    In order to pay proper amount when buying goods with variants from different tax categories
    As a Visitor
    I want to have correct taxes applied to my order

    Background:
        Given the store is operating on a single channel
        And there is "EU" zone containing all members of European Union
        And default currency is "EUR"
        And default tax zone is "EU"
        And the store has "EU VAT" tax rate of 23% for "Mugs" within "EU" zone
        And the store has "Low VAT" tax rate of 5% for "Cheap Mugs" within "EU" zone
        And the store has a product "PHP Mug"
        And it comes in the following variations:
            | name       | price   |
            | Medium Mug | €100.00 |
            | Large Mug  | €40.00  |
        And "Medium Mug" variant of product "PHP Mug" belongs to "Cheap Mugs" tax category
        And "Large Mug" variant of product "PHP Mug" belongs to "Mugs" tax category

    Scenario: Proper taxes for different taxed variants
        When I add "Medium Mug" variant of product "PHP Mug" to the cart
        And I add "Large Mug" variant of product "PHP Mug" to the cart
        Then my cart total should be "€154.20"
        And my cart taxes should be "€14.20"
