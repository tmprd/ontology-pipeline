# Advanced Pipeline
* Import, Template, Test, Release, Report
* Key
	* Rectangles are plural entities
	* Hexagons are singular ontologies
	* Bubbles are reports
	* NOTE: links rendered in Github must be opened in another tab/window
	
```mermaid
flowchart
	%%%% Definitions

	Ontology{{Updated Ontology}}
		click Ontology "http://purl.obolibrary.org/obo/IAO_8000002"

	Merged{{Merged}}
		click Merged "http://purl.obolibrary.org/obo/IAO_8000015"


	Main{{Main Release}}
		click Main "http://purl.obolibrary.org/obo/IAO_8000003"

	Base{{Base}}
		click Base "http://purl.obolibrary.org/obo/IAO_8000001"

	Core{{Core}}


	Templates

	ImportedOntology[Imported Ontology]
	ImportedTerms[Imported Terms]
	ImportedModules[Imported Modules]
		click ImportedModules "http://purl.obolibrary.org/obo/IAO_8000005"

	Modules[Template Modules]
		click Modules "http://purl.obolibrary.org/obo/IAO_8000015"

	PhonyModules[Temporary Modules]
		click PhonyModules "http://purl.obolibrary.org/obo/IAO_8000014"

	MergedModules
		click MergedModules "http://purl.obolibrary.org/obo/IAO_8000014"


		click Imports "http://purl.obolibrary.org/obo/IAO_8000011"


	Constructs[SPARQL Constructs]
	Queries[SPARQL Queries]
	BaseReport(Base Report)

	%%%% Relations

	ImportedOntology --> |extract| ImportedModules
	ImportedTerms --> |OntoFox| ImportedModules
		ImportedModules --> |merge| Ontology

	Ontology --> |merge| Modules
	Templates --> |merge, template, annotate| Modules
		Modules --> |remove annotations| PhonyModules
			PhonyModules --> |remove imports, merge, reason| MergedModules
			Ontology --> |merge| MergedModules
			Queries -.-> |verify| MergedModules

	Ontology ----> |merge| Merged
	Modules --> |merge| Base
	Constructs --> |merge| Merged
		Merged -.-> |reason ELK| Merged
		Queries -.-> |verify| Merged
			Merged --> |reason HermiT, annotate | Main
			Merged --> |remove imports, annotate| Base
				Base --> |report| BaseReport

	Main --> |remove, extract core terms, annotate| Core
```