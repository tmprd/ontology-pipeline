# Intermediate Pipeline
* Import, Test, Release, Report
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

	ImportedOntology[Imported Ontology]
	ImportedTerms[Imported Terms]
	ImportedModules[Imported Modules]
		click ImportedModules "http://purl.obolibrary.org/obo/IAO_8000005"

	Constructs[SPARQL Constructs]
	Queries[SPARQL Queries]
	BaseReport(Base Report)


	%%%% Relations

	ImportedOntology --> |extract| ImportedModules
		ImportedTerms --> |OntoFox| ImportedModules
			ImportedModules --> |merge| Ontology

	Ontology ----> |merge| Merged
	Constructs --> |merge| Merged
		Queries -.-> |verify| Merged
		Merged -.-> |reason ELK| Merged
			Merged --> |reason HermiT, annotate | Main
			Merged --> |remove imports, annotate| Base
				Base --> |report| BaseReport
```