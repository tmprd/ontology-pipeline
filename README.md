# Ontology Pipeline

[![Powered by the ROBOT](https://img.shields.io/static/v1?label=Powered%20by&message=ROBOT&color=green&style=flat)](http://robot.obolibrary.org/)

* Minimal infrastructure for automatically testing and building released versions of ontologies
* Made with [ROBOT](https://robot.obolibrary.org/) and [GNU Make](https://www.gnu.org/software/make/)
* Continuously tested and built using [Github Actions](https://github.com/tmprd/ontology-pipeline/actions)

# Usage 
* Set the ontology details and metadata in the [Makefile](/Makefile)
* Currently, commits on any branch will trigger the test automations
* Commits to the master branch trigger the test and release automations

# Architecture
* This basic pipeline & other advanced versions are documented [here](/docs/)
