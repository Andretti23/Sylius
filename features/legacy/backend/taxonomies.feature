@taxonomies
Feature: taxonomies
    In order to categorize my merchandise
    As a store owner
    I want to be able to manage taxonomies

    Background:
        Given store has default configuration
        And there are following taxonomies defined:
            | code | name     |
            | RTX1 | Category |
            | RTX2 | Brand    |
        And taxonomy "Category" has following taxons:
            | Electronics[TX1] > Featured[TX3]          |
            | Electronics[TX1]  > Mac[TX4]  > iMac[TX5] |
            | Electronics[TX1]  > Mac[TX4]  > MBP[TX6]  |
            | Clothing[TX2]  > Gloves[TX7]              |
            | Clothing[TX2]  > Hats[TX8]                |
        And I am logged in as administrator

    Scenario: Seeing index of all taxonomies
        Given I am on the dashboard page
        When I follow "Categorization"
        Then I should be on the taxonomy index page
        And I should see 2 taxonomies in the list

    Scenario: Seeing empty index of taxonomies
        Given there are no taxonomies
        When I go to the taxonomy index page
        Then I should see "There are no taxonomies defined"

    Scenario: Accessing the taxonomy creation form
        Given I am on the dashboard page
        When I follow "Categorization"
        And I follow "Create taxonomy"
        Then I should be on the taxonomy creation page

    Scenario: Submitting form without specifying the name
        Given I am on the taxonomy creation page
        When I press "Create"
        Then I should still be on the taxonomy creation page
        And I should see "Please enter taxonomy name"

    Scenario: Creating new taxonomy
        Given I am on the taxonomy creation page
        When I fill in "Name" with "Vendor"
        And I fill in "Code" with "RTX3"
        And I press "Create"
        Then I should be on the page of taxonomy "Vendor"
        And I should see "Taxonomy has been successfully created"

    Scenario: Created taxonomies appear in the list
        Given I created taxonomy "Food" with code "RTX4"
        When I go to the taxonomy index page
        Then I should see 3 taxonomies in the list
        And I should see taxonomy with name "Food" in that list

    Scenario: Accessing the editing form from the list
        Given I am on the taxonomy index page
        When I click "Edit" near "Category"
        Then I should be editing taxonomy "Category"

    Scenario: Updating the taxonomy
        Given I am editing taxonomy "Brand"
        When I fill in "Name" with "Brands"
        And I press "Save changes"
        Then I should be on the page of taxonomy "Brands"
        And I should see "Taxonomy has been successfully updated"

    @javascript
    Scenario: Deleting taxonomy
        Given I am on the taxonomy index page
        When I click "Delete" near "Brand"
        And I click "Delete" from the confirmation modal
        Then I should be on the taxonomy index page
        And I should see "Taxonomy has been successfully deleted"

    @javascript
    Scenario: Deleted taxonomy disappears from the list
        Given I am on the taxonomy index page
        When I click "Delete" near "Category"
        And I click "Delete" from the confirmation modal
        Then I should be on the taxonomy index page
        And I should not see taxonomy with name "Category" in that list

    Scenario: Accessing taxonomy tree via the list
        Given I am on the taxonomy index page
        When I click "Category"
        Then I should be on the page of taxonomy "Category"

    Scenario: Seeing index of all taxonomy taxons
        Given I am on the taxonomy index page
        When I click "Category"
        Then I should be on the page of taxonomy "Category"
        And I should see 8 taxons in the list

    Scenario: Creating new taxon under given taxonomy
        Given I am on the page of taxonomy "Category"
        And I follow "Create taxon"
        When I fill in "Name" with "Cars"
        And I fill in "Code" with "TX9"
        And I press "Create"
        Then I should be on the page of taxonomy "Category"
        And I should see "Taxon has been successfully created"
#    TODO
#    Scenario: Creating new taxon with existing name under given taxonomy
#        Given I am on the page of taxonomy "Category"
#          And I follow "Create taxon"
#         When I fill in "Name" with "Electronics"
#          And I press "Create"
#          And I should see "Name already in use in the parent taxon"

    Scenario: Creating new taxon with existing name under different taxon
        Given I am on the page of taxonomy "Category"
        And I follow "Create taxon"
        When I fill in "Name" with "Electronics"
        And I fill in "Code" with "TX9"
        And I select "Clothing" from "Parent"
        And I press "Create"
        Then I should be on the page of taxonomy "Category"
        And I should see "Taxon has been successfully created"
        And I should see 9 taxons in the list

    Scenario: Creating new taxon with parent
        Given I am on the page of taxonomy "Category"
        And I follow "Create taxon"
        When I fill in "Name" with "iPods"
        And I fill in "Code" with "TR9"
        And I select "Electronics" from "Parent"
        And I press "Create"
        Then I should be on the page of taxonomy "Category"
        And I should see "Taxon has been successfully created"

    Scenario: Renaming the taxon
        Given I am on the page of taxonomy "Category"
        And I click "Edit" near "Clothing"
        When I fill in "Name" with "Clothing and accessories"
        And I press "Save changes"
        Then I should be on the page of taxonomy "Category"
        And I should see "Taxon has been successfully updated"

    Scenario: Changing taxon slug
        Given permalink of taxon "Clothing" in "Category" taxonomy has been changed to "super-clothing"
        And I am on the page of taxonomy "Category"
        When I click "Edit" near "Clothing"
        Then I should see "category/super-clothing" in "Permalink" field

    Scenario: Changing taxon slug with parent slug prefix
        Given permalink of taxon "Clothing" in "Category" taxonomy has been changed to "category/super-clothing-category/best"
        And I am on the page of taxonomy "Category"
        When I click "Edit" near "Clothing"
        Then I should see "category/super-clothing-category-best" in "Permalink" field

    @javascript
    Scenario: Deleting taxons
        Given I am on the page of taxonomy "Category"
        When I click "Delete" near "Electronics"
        And I click "Delete" from the confirmation modal
        Then I should still be on the page of taxonomy "Category"
        And I should see "Taxon has been successfully deleted"

    @javascript
    Scenario: Deleted taxons disappear from the list
        Given I am on the page of taxonomy "Category"
        When I click "Delete" near "Clothing"
        And I click "Delete" from the confirmation modal
        Then I should still be on the page of taxonomy "Category"
        And "Taxon has been successfully deleted" should appear on the page
        And I should see 5 taxons in the list

    Scenario: Cannot update taxon code
        When I am editing taxon "Electronics" from taxonomy "Category"
        Then the code field should be disabled

    Scenario: Try create taxon with existing code
        Given I am on the page of taxonomy "Category"
        And I follow "Create taxon"
        When I fill in "Name" with "Cars"
        And I fill in "Code" with "TX1"
        And I press "Create"
        Then I should still be on the taxon creation page from taxonomy "Category"
        And I should see "Taxon with given code already exists"

    Scenario: Try create taxon without code
        Given I am on the page of taxonomy "Category"
        And I follow "Create taxon"
        When I fill in "Name" with "Cars"
        And I press "Create"
        Then I should still be on the taxon creation page from taxonomy "Category"
        And I should see "Please enter taxon code"
