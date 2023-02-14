# Ontology Pipeline

[![Powered by the ROBOT](https://img.shields.io/static/v1?label=Powered%20by&message=ROBOT&color=green&style=flat)](http://robot.obolibrary.org/)

* Minimal infrastructure for automatically testing and building released versions of ontologies
* Made with [ROBOT](https://robot.obolibrary.org/) and automated with [GNU Make](https://www.gnu.org/software/make/)
* Continuously tested, built, and deployed using [Github Actions](https://github.com/tmprd/ontology-pipeline/actions)
* Inspired by [ongoing efforts](https://oboacademy.github.io/obook/lesson/automating-ontology-workflows/) to use simple and sustainable techniques for ontology engineering

# Usage 
* Set the ontology details and metadata in the [Makefile](/Makefile)
* Add an ontology file and SPARQL query files to the locations specified
    * By default, the sample ontology included in this repo is a copy of http://purl.obolibrary.org/obo/bfo/2.0/bfo.owl 
* Currently, commits on any branch will trigger the test automations
    * The results of tests are visible in each executed Github Action and also downloadable as "artifacts". See examples [here](https://github.com/tmprd/ontology-pipeline/actions/runs/4139471243/jobs/7157070130#step:4:16) and [here](https://github.com/tmprd/ontology-pipeline/actions/runs/4139471243).
* Commits to the master branch trigger the test and release automations
    * The release automation will draft a [Github Release here](https://github.com/tmprd/ontology-pipeline/releases) with the release build of the ontology attached, which contains annotations of the version metadata.
    
# Setup
* There are 3 different ways this repo can be used:
   * Option 1: Fork this repo and replace the sample ontology and Makefile settings with your own. Updates to this repo can be automatically synced to yours.
   * Option 2: Copy the Makefile, Github Action files, and license into your own repo. Updates to this repo would need to be manually copied to yours.
   * Upcoming Option 3: This repo could be published as a Github Action that you may reference in your repo, without needing a Makefile. However, this would make your project more dependent on Github. (The Makefile is intended to be completely usable without Github.)
    
# Architecture
* This basic pipeline & other upcoming advanced versions are documented [here](/docs/)
* Downloaded dependencies like ROBOT are [cached](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows) for re-use in the Github Actions. The cache is currently cleared after 7 days of no use.
* The Makefile can be used independently of a Github Action by running it locally with Make

# Related Tools
* For more advanced ontology engineering automation, see [ODK](https://github.com/INCATools/ontology-development-kit) and [OAK](https://github.com/INCATools/ontology-access-kit)
