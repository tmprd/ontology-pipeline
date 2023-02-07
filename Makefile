#### Basic Ontology Pipeline
# Heavily adapted from https://github.com/obi-ontology/obi/blob/master/Makefile
# Tim Prudhomme <tmprdh@gmail.com>

# ----------------------------------------
#### Configuration / details about our project
# Project essentials
config.ONTOLOGY_FILE	:= src/ontology/bfo.owl
config.ONTOLOGY_PREFIX	:= bfo
config.ONTOLOGY-IRI		:= http://purl.obolibrary.org/obo/bfo/2.0
config.BASE_IRI			:= $(config.ONTOLOGY-IRI)_
config.DEV_IRI			:= $(config.ONTOLOGY-IRI)/dev
config.MODULES_IRI		:= $(config.DEV_IRI)/modules

# Local project directories
config.SOURCE_DIR		:= src/ontology
config.TEMP_DIR			:= build/artifacts
config.RELEASE_DIR		:= /
config.REPORTS_DIR		:= $(config.TEMP_DIR)
config.QUERIES_DIR		:= $(config.SOURCE_DIR)/sparql
config.LIBRARY_DIR		:= build/lib

# Settings
config.FAIL_ON_TEST_FAILURES := true
config.REPORT_FAIL_ON := ERROR

# Other constants
TODAY  := $(shell date +%Y-%m-%d)

# Generic files
EDITOR_BUILD_FILE = $(config.ONTOLOGY_FILE) # "editors ontology module" http://purl.obolibrary.org/obo/IAO_8000002
RELEASE_BUILD_FILE = $(config.ONTOLOGY_PREFIX).owl # "main release ontology module" http://purl.obolibrary.org/obo/IAO_8000003
RELEASE_REPORT_FILE = $(config.TEMP_DIR)/$(config.ONTOLOGY_PREFIX)-report.tsv

# Generic directories to create if needed
REQUIRED_DIRS = $(config.TEMP_DIR) $(config.LIBRARY_DIR) $(config.SOURCE_DIR) $(config.QUERIES_DIR) $(config.REPORTS_DIR)


# ----------------------------------------
#### Targets / main "goals" of this Makefile
.PHONY: all
all: test-edit release

release: $(RELEASE_BUILD_FILE) test-release

# These use Target-Specific Variables as parameters of reusable targets
.PHONY: 				test-edit test-release
test-edit: 				TEST_INPUT = $(EDITOR_BUILD_FILE)
test-release:				TEST_INPUT = $(RELEASE_BUILD_FILE)
# (This is a disjunction mapped to a conjunction: either target will run all of these targets)
test-edit test-release: reason verify report

report-edit:				TEST_INPUT = $(EDITOR_BUILD_FILE)
report-release:				TEST_INPUT = $(RELEASE_BUILD_FILE)
report-edit report-release: report


# ----------------------------------------
#### Setup / configure Make to use with our project
# Make configuration --- Ignore this section unless curious
# <http://clarkgrubb.com/makefile-style-guide#toc2>
MAKEFLAGS += --warn-undefined-variables
SHELL := bash # need bash to use `pipefail`
# `-e` causes exit if a command fails. `-u` causes exit for undefined variables. `-c` passes Make script to bash
# `pipefail` causes a chain of piped commands to fail if any of its commands fail
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all # default target running Make without arguments
.DELETE_ON_ERROR: # delete target if recipe fails
.SUFFIXES: # ?
.SECONDARY: # ?

# Create any of these directories if they don't exist
$(REQUIRED_DIRS):
	mkdir -p $@

# ROBOT
ROBOT_FILE := $(config.LIBRARY_DIR)/robot.jar
$(ROBOT_FILE): | $(config.LIBRARY_DIR)
	curl -L -o $@ https://github.com/ontodev/robot/releases/download/v1.8.4/robot.jar

ROBOT := java -jar $(ROBOT_FILE)

# Cleanup
.PHONY: clean
clean:
	@[ "${config.TEMP_DIR}" ] || ( echo ">> config.TEMP_DIR is not set"; exit 1 )
	rm -rf $(config.TEMP_DIR)
	rm -rf $(RELEASE_BUILD_FILE)


# ----------------------------------------
#### Build / different versions of the ontology
$(RELEASE_BUILD_FILE): $(EDITOR_BUILD_FILE)
	$(ROBOT) reason --input $< --reasoner HermiT \
	annotate ${call annotation-inputs,$@}

# Function using parameter `$@` to build arguments for `annnotate`, which could be reused in other builds
define annotation-inputs
	--ontology-iri "$(config.ONTOLOGY-IRI)/$1" \
	--version-iri "$(config.ONTOLOGY-IRI)/$(TODAY)/$1" \
	--annotation owl:versionInfo "$(TODAY)" \
	--output $@ 
endef


# ----------------------------------------
#### Test / test ontology with reasoners and queries
QUERIES = $(wildcard $(config.QUERIES_DIR)/*.rq)

# Check for inconsistency
.PHONY: reason
reason: $(TEST_INPUT) | $(ROBOT_FILE)
	$(ROBOT) reason --input $(TEST_INPUT) --reasoner ELK

# Test using specific queries
.PHONY: verify
verify: $(TEST_INPUT) $(QUERIES) | $(config.QUERIES_DIR) $(config.TEMP_DIR) $(ROBOT_FILE)
ifeq ($(QUERIES),)
	$(error No query files found in $(config.QUERIES_DIR))
endif
	$(ROBOT) verify --input $(TEST_INPUT) --output-dir $(config.TEMP_DIR) --queries $(QUERIES) --fail-on-violation $(config.FAIL_ON_TEST_FAILURES)

# Report using built-in ROBOT queries
.PHONY: report
report: $(TEST_INPUT) | $(config.REPORTS_DIR) $(ROBOT_FILE)
	$(ROBOT) report --input $(TEST_INPUT) \
	--labels true \
	--base-iri $(config.BASE_IRI) \
	--fail-on $(config.REPORT_FAIL_ON) \
	--print 10 \
	--output $@


# ----------------------------------------
#### Make syntax cheatsheet

# automatic variables
# $@ means target
# $< means first prerequisite
# $^ means all prerequisites

# := means simply expand
# = means recursively/lazily expand
