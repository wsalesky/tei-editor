
# tei-editor
Sandbox for tei forms. Built in eXistdb, uses xsltforms and xsltforms specific javascript. 

POC only, not fully functional. Current implementation relies heavily on srophe-data [https://github.com/srophe/srophe-app-data]  and possibly some work from srophe-eXist-app [https://github.com/srophe/srophe-eXist-app]. 

## Review of existing editors
Personal notes on some of the xml webbased editing tools I have looked at in the past few weeks. 

##TEI
####TEILiteEditor
Javascript and XSLTForms to add support for mixed content editing. Based on an earlier version of Teian, works with xsltforms.

Code: [https://github.com/jdickie/TEILiteEditor]

Credit: 

Notes: This project is the closest to what we are hoping to get working. So far still debugging the demo. It uses a CKEditor plugin to add TEI tags as classes to html:span elements, spans get translated back to TEI. 

####Teiann
Javascript and XSLT for editing/annotating complex TEI records. 

Code: [http://sourceforge.net/projects/teian/]

Documentation: [http://teian.sourceforge.net/latest/documentation/index.html]

Credit: Claudius Teodorescu

Notes: We are looking for more flexibility, like the mixed content handling, would like to be able to plug it in only when needed, such as in textarea editing. 


Notes: 

####CWRC-Writer
The Canadian Writing Research Collaboratory (CWRC) is developing an in-browser text markup editor (CWRC-Writer) for use by collaborative scholarly editing projects.

Demo: 

Code: [https://github.com/cwrc/CWRC-Writer]

Credit: [https://github.com/cwrc]

Notes: Looks interesting from the demo and documentation, have not yet tried to install and test the code. 

####Islandora TEI editor
A javascript based TEI editor. BETA - not supported.

Code: [https://github.com/Islandora/islandora_tei_editor]

Notes: Untested. 

####ANGLES
A lightweight, online XML editor. 

Code: [https://github.com/umd-mith/angles]

Notes: Untested

## Generic XML editors

###XML Tree style editors
####xml.edit.xml
A simple XML Editor web-interface. Client-side solution based on the 'XSLTForms' XForms project.

Demo: [http://forms.collinta.com.au/xml.edit.xml]

Code: [http://sourceforge.net/projects/xmleditxml/]

Credit: Stephen Cameron [http://sourceforge.net/u/stevecam62/profile/]

Notes: Interesting, but not the direction we are looking to go in. 

####LiveXmlEdit
JQuery webbased XML editor XML tree view. 
LiveXMLEdit is a tool for inline editing of XML files. It renders the uploaded XML file and lets you create and delete nodes and attributes, as well as update their values by clicking on them directly.

Demo: [http://www.subchild.com/liveXmlEdit/index.php?attrName=&attrValue=]

Code: [https://github.com/subchild/liveXmlEdit]

Credit: [https://github.com/subchild]

