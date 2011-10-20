Relevancy Driven Development
============================

The aim of RDD is to allow the business users to gain confidence in the relevancy of the search query results.

**This is a placeholder repository for a Solr RDD implementation as the code is pre-alpha with a lot still to do.**

_It can be achieved with EasyB, but needs a lot of polish/meta-programming to mask a the SolrJ boilerplate code._

How is this done?
-----------------

The trick is that the business users can use a constrained data set, define a query and the results they expect in the order that they expect.

The approach leans on the BDD behaviour story approach:

    scenario "Exercise bikes"
       given "standard product data set"
       when "I search for 'exercise bike'"
       and when "I sort by price descending"
       then "I get results with ids [PRD-123,PRD-234]"


Constrained data
----------------

Constraining the data set allows us to be able to reliably make assertions (think DbUnit). 

There are a couple of ways that this can be used:

1. Standalone Solr instance that is flattened and primed with the known data set (would only want to do this at the whole test level)
2. Embedded Solr (could be done per story with small datasets).

Data changes
------------

There is a Groovy script to assist with handling the case of schema changes (assuming the use of Solr update XML format).

What still needs to be done?
----------------------------

The custom DSL implementation over SolrJ...
