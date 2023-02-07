# Basic Pipeline
* Test, Release, Report
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

	Main{{Main Release Build}}
		click Main "http://purl.obolibrary.org/obo/IAO_8000003"
		
	Queries[SPARQL Queries]
	Report(Release Report)


	%%%% Relations

	Queries -.-> |verify| Ontology
	Ontology -.-> |reason ELK| Ontology
		Ontology --> |reason HermiT, annotate | Main
		Ontology --> |report| Report
```