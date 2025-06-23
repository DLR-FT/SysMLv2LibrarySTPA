# About

The development of complex transport systems presents significant safety challenges. While safety-driven and model-based approaches show promise, their adoption is still in its early stages. One hazard analysis method that is gaining traction is the System Theoretic Process Analysis (STPA). Integrating STPA with the Systems Modeling Language (SysML) holds great potential, thanks to their shared system-theoretic foundation. Simultaneously, SysML v2, with extensibility features such as libraries, offers new integration opportunities. Accordingly, this repo proposes an open-source SysML v2 library for STPA.

This repo contains:
- A library for STPA in the textual notation of SysML v2 - [LinkToLibrary](Library/LibrarySTPA.sysml)
- A corresponding example project that uses the library - [LinkToExample](Library/ExampleSTPA.sysml)
- A jupyter notebook version that showcases the application - [LinkToNotebook](Jupyter/LibrarySTPA.ipynb)

The library is devided into six packages. For each of the four STPA steps, one dedicated package is used. The fifth and sixth package includes the metadata types and view/viewpoint definitions that facilitate the application of the library.

![Library Packages 1 to 3](Images/LibraryPackages1to3.svg)
![Library Packages 4 to 6](Images/LibraryPackages4to6.svg)

-----------------------------------------------------------------------------------------------

# Usage

The LibrarySTPA.sysml and ExampleSTPA.sysml files of the library can be used with any SysML v2 tool. The LibrarySTPA.ipynb file is recommended to be used in combination with the pilot-implementation for [Jupyter](https://github.com/Systems-Modeling/SysML-v2-Release/tree/master/install/jupyter). Some open-source tools for trying out the library are:

- Jupyter - [LinkToGithub](https://github.com/Systems-Modeling/SysML-v2-Release/tree/master/install/jupyter)
- SysIDE (VSC Plugin) - [LinkToWebsite](https://sensmetry.com/syside/)
- SysON [LinkToWebsite](https://mbse-syson.org/)

More information on the goals and conecepts behind the library is planned to be published in a complementary article.

-----------------------------------------------------------------------------------------------

# Related Material

Recommended STPA Literature:
- [MIT Partnership for Systems Approaches to Safety and Security (PSASS)](http://psas.scripts.mit.edu/home/materials/)
- [STPA Handbook 2018](http://psas.scripts.mit.edu/home/get_file.php?name=STPA_handbook.pdf)
- [Engineering A Safer World](https://direct.mit.edu/books/book/2908/Engineering-a-Safer-WorldSystems-Thinking-Applied)
- [STPA Standard for All Industries](https://www.sae.org/standards/content/j3307_202503/)
- [SAE J3187 STPA Guidance](https://www.sae.org/standards/content/j3187_202202/)
- [Podcasts about STPA](https://safetycorner.wagnerflorian.eu/index.php/en/)

Related References from Contributors:
- [A System-Theoretic Assurance Framework for Safety-Driven Systems Engineering](https://link.springer.com/article/10.1007/s10270-024-01209-6)
- [Integrating Safety into MBSE Processes with Formal Methods](https://ieeexplore.ieee.org/document/9594315)
- [Evaluating System Architecture Safety in Early Phases of Development with MBSE and STPA](https://ieeexplore.ieee.org/document/9582542)
- [Model-Based STPA: Enabling Safety Analysis Coverage Assessment with Formalization](https://ieeexplore.ieee.org/document/9925883)
- [Model-Based STPA: Towards Agile Safety-Guided Design with Formalization](https://ieeexplore.ieee.org/abstract/document/10005396)
- [Master's Thesis - German](https://www.researchgate.net/publication/354599682_Erweiterung_von_MBSE_Prozessen_bei_der_Entwicklung_sicherheitskritischer_Systemarchitekturen_durch_die_Nutzung_Formaler_Methoden)

-----------------------------------------------------------------------------------------------

# License and Copyright

For this library the copyright belongs to the German Aerospace Center / Deutsches Zentrum für Luft- und Raumfahrt e.V. (DLR):

Copyright (c) 2025 Deutsches Zentrum für Luft- und Raumfahrt e.V. (DLR)

Licensed under MIT + Apache 2.0. That means, as a downstream consumer of this software you may
choose to either use it under MIT or under Apache 2.0 license, at your discretion. All contributions
from upstream must be licensed under both MIT and Apache 2.0; if you contribute code to this project
you agree to license your code under both the MIT and the Apache 2.0 license.

-----------------------------------------------------------------------------------------------

# Contact Information

The main contributor of the profile is Alexander Ahlbrecht:
- [LinkedIn](https://www.linkedin.com/in/alexander-ahlbrecht-411907225/)
- [ResearchGate](https://www.researchgate.net/profile/Alexander-Ahlbrecht)
- [GoogleScholar](https://scholar.google.com/citations?user=XildzN5o6jAC&hl=de&oi=ao)

In case of questions, you can also write a mail to: alexander.ahlbrecht@dlr.de
