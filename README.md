# Ontology Pipeline

[![Powered by the ROBOT](https://img.shields.io/static/v1?label=Powered%20by&message=ROBOT&color=green&style=flat)](http://robot.obolibrary.org/)

* Minimal infrastructure for automatically testing and building released versions of ontologies
* Made with [ROBOT](https://robot.obolibrary.org/) and automated with [GNU Make](https://www.gnu.org/software/make/)
* Continuously tested, built, and deployed using [Github Actions](https://github.com/tmprd/ontology-pipeline/actions)

# Usage 
* Set the ontology details and metadata in the [Makefile](/Makefile)
* Add an ontology file and SPARQL query files to the locations specified
    * By default, the sample ontology included in this repo is a copy of http://purl.obolibrary.org/obo/bfo/2.0/bfo.owl 
* Currently, commits on any branch will trigger the test automations
* Commits to the master branch trigger the test and release automations
* The results of tests are visible in each executed Github Action and also downloadable as "artifacts"

# Architecture
* This basic pipeline & other advanced versions are documented [here](/docs/)
* Downloaded dependencies like ROBOT are [cached](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows) for re-use in the Github Actions. The cache is currently cleared after 7 days of no use.
* The Makefile can be used independently of a Github Action by running it locally with GNU Make