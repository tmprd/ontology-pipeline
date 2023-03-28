# Advanced Pipeline Architecture
### Purpose
* This is a model of the pipeline used in OBI's Makefile by James Overton: https://github.com/obi-ontology/obi/blob/master/Makefile
* This pipeline runs automated tests, builds reports, creates modules from templates, and builds base, release, and core versions of the ontology.
* Differences with the basic ontology pipeline:
	* "Templates" are used for quickly adding many terms at once
		* "Template Modules" are then generated and merged together with the "Edited Ontology", then tested
	* A "Base Build" removes imports and only a "Base Report" is created
	* A "Core Build" contains a selected subset of "Core Terms"
	* "SPARQL Constructs" are inserted terms

### Classification
* "Edited Ontology" is a http://purl.obolibrary.org/obo/IAO_8000002 "editors ontology module"
* "Release Build" is a http://purl.obolibrary.org/obo/IAO_8000003 "main release ontology module"
* "Base Build" is a http://purl.obolibrary.org/obo/IAO_8000001 "base ontology module"
* "Core Build" is a http://purl.obolibrary.org/obo/IAO_8000014 "generated ontology module"
* "Imported Modules" are instances of http://purl.obolibrary.org/obo/IAO_8000005 "import ontology module"
* "Template/Temporary/Merged Modules" are instances of http://purl.obolibrary.org/obo/IAO_8000015 "template generated ontology module"

### Diagram Key
* Hexagons are ontologies
* Rectangles are SPARQL or text files
* Rounded boxes are spreadsheets
* Dotted lines involve automated tests
* ":" prefix means ROBOT command

```mermaid
graph
	%%%% Entities
	Edited{{Edited Ontology}}
	Merged{{Merged Build}}
	Release{{Release Build}}
	Base{{Base Build}}
	ImportedModules{{Imported Modules}}
	Core{{Core Build}}

	Constructs[SPARQL Constructs]
	Queries[SPARQL Queries]
	ImportedTerms[Imported Terms]
	Templates[Templates]

	TemplateModules{{Template Modules}}
	PhonyModules{{Temporary Modules}}
	MergedModules{{Merged Modules}}

	BaseReport(Base Report)


	%%%% Relations
	ImportedTerms --> |OntoFox:export| ImportedModules
	Edited --> |owl:import| ImportedModules

	Edited --> |:merge| TemplateModules
	Templates --> |:merge, :template, :annotate| TemplateModules
		TemplateModules --> |:remove annotations| PhonyModules
			PhonyModules --> |:remove imports, :merge, :reason ELK| MergedModules
			Edited --> |:merge| MergedModules
			Queries -.-> |:verify| MergedModules

	Edited ----> |:merge| Merged
	TemplateModules --> |:merge| Base
	Constructs --> |:merge| Merged
		Merged -.-> |:reason ELK| Merged
		Queries -.-> |:verify| Merged
			Merged --> |:reason HermiT, :annotate | Release
			Merged --> |:remove imports, :annotate| Base
				Base -.-> |:report| BaseReport

	CoreTerms[Core Terms] --> |:extract core terms| Core
	Release --> |:remove terms, :annotate| Core
```