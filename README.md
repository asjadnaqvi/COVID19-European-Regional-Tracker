# Overview
This respository takes a stock of existing datasets at the regional level for European countries. [ECDC](https://www.ecdc.europa.eu/) is releasing information at the country level but there is no centralized database that collates this information at the regional level. There is also no indication that this information will be collected, even though most countries are providing or showcasing this information on this official websites. 

## Challenges with data access


* If data exists, it is not clear where or how to access it. Some countries keep it on the websites of official government websites, national statistical agencies, health departments, and some just export it to third-party repositories (e.g. ArcGIS datahub, Github etc). Thus each country has to be dealt with on a case-by-case basis. Due to the rise in popularity in data visualizations, a of people are scripting and collecting this information and can also be found in GitHub repositories. These will be referenced as necessary.
* Information provided by countries is not consistent. Not all countries release data on deaths, tests performed, hospitalization rates, gender and age breakdowns etc. So the lowest common homogenous unit is usually cases.
* The information on official website is not always accessible in machine-readible formats (.csv, .xls, .txt etc.). It can also exist as pdfs, entries on websites, twitter feeds etc. Hence a lot of effort has been put in put independent coders to scrap this information, or at least, archieve it for access later. These will be referenced as necessary.


## Combining data across countries

* Countries in European define regions differently. Making this information homogeneous is also a challenging task. For consistency, the European Commission/Eurostat, have homogenous units called NOMENCLATURE OF TERRITORIAL UNITS FOR STATISTICS or [NUTS](https://ec.europa.eu/eurostat/web/nuts/background). NUTS0 are countries, NUTS1 are typically provinces, NUTS2 are typically districts, and NUTS3 are typically sub-districts. Most countries release information at adminstrative units lower than NUTS3. These are referred to as Local Administrative Units [LAU](https://ec.europa.eu/eurostat/web/nuts/local-administrative-units), where LAU1 (districts) and LAU2 (municipalities) were formerly NUTS4 and NUTS5 regions respectively. Currently only one level of LAU is documented by the European Commission even though countries themselves might document data at finer level.

* The NUTS regions are redefined every afew years (2013, 2016, 2021). Currently the 2016 definitions are used but the list of 2021 NUTS regions has already been released. This has its own set of challenges. While some countries just rename regions, others actually change, merge, and shift boundaries. Data released at LAU level can be aggregated to the NUTS3 level. For this database, 2016 values are used. The switch from 2016 to 2021 definition on January 2020 might itself pose a challenge esepcially if boundaries of LAUs change. This happens farily frequently especially around local and regional elections.

* Not all European countries are in the [European Union](https://europa.eu/european-union/about-eu/countries_en), and hence are not subject to Eurostat reporting/data sharing requirements. While all countries have correspondence tables between their own region definitions and NUTS, providing NUTS level information is not mandatory for non-EU countries. This list includes, the UK (post Brexit), Norway, Switzerland, and accession countries in the east of Europe. While some countries have data in a very neat format (Norway for example), they don't have the latest LAU-NUTS correspondence avaiable. They way around this problem is to spatially overlay LAU and NUTS boundaries and spatially join them based on boundary overlaps. While in theory the overlaps should be perfect, in practice, small errors might persist based on slight differences in boundaries, differences in resolution of spatial files, and simply some LAUs might cut across NUTS boundaries. These will be highlighted as required.


# European regions and availability of COVID-19 data

| Country (NUTS 0) | Code | NUTS 1 | NUTS 2 | NUTS 3 | LAU | 
| --- | --- | --- | --- | --- | --- | 
| Austria | AT  | Gruppen von Bundesländern (3) | Bundesländer (9) | **Bezirke (35)** | Gemeniden (2096) | 
| Belgium | BE  | Gewesten / Régions (3) | Provincies / Provinces (11) | Arrondissementen / Arrondissements (44) | **Gemeenten / Communes (581)** | 
| Czechia | CZ  | Území(1) | Regiony soudržnosti (8) | **Kraje (14)** | Obce (6258) | 
| *Denmark* | DK  | Country (1) | Regioner (5) | Landsdele (11) | Kommuner (99) | 
| France | FR  | Zones d'études et d'aménagement du territoire (14) | Régions (27) | **Départements (101)** | Communes (34970) | 
| Germany | DE  | Länder (3) | Regierungsbezirke (38) | **Kreise (401)** | Gemeniden (11087) | 
| *Greece* | EL  | Geografikes Perioches (4) | Periferies (13) | Periferiakon Enotiton (52) | Topikes Koinotites (6134) | 
| Ireland | IE  | Country (1) | Regions (3) | **Regional Authority Regions (8)** | Local Election Areas (166) | 
| Netherlands | NL  | Landsdelen (4) | Provincies (12) | NUTS3 (40) | **Gemeenten (355)** | 
| Norway * | NO  | Country (1) | Landsdeler (7) | Fylker (18) | **Kommuner (356)** | 
| Poland | PL  | Makroregiony (7) | **Regiony (17)** | Podregiony (73) | Gminy (2478) | 
| Portugal | PT  | Continente + Regiões Autónomas (3) | Grupos de Entidades Intermunicipais + Regiões Autónomas (7) | Entidades Intermunicipais + Regiões Autónomas (25) | Freguesias (3098) | 
| Slovenia | SI  | Country (1) | Kohezijske regije (2) | Statistične regije (12) | **Občine (212)** | 
| Spain | ES  | Agrupación de comunidades autónomas (7) | Comunidades y ciudades Autónomas (19) | **Provincias + islas + Ceuta, Melilla (59)** | Municipios (8131) | 
| *United Kingdom* * | UK  | Government Office Regions (12) | Counties (41) | Upper tier authorities (179) | Lower tier authorities (400) | 

Source: Extended from [Eurostat LAU page](https://ec.europa.eu/eurostat/web/nuts/national-structures). Number of regions are given in brackets. The region at which the data is available is highlighted in bold. For some countries, NUTS 0 and NUTS 1 are the same. Countries marked with a * are not in the EU and do not have to provide data at consistent NUTS3/LAU levels. *Italicized* countries are still being processed. 

# Sources of country level datasets


| Country | Code  | Official institute providing data | Data source | Date range  | 
| --- |  --- |  --- |  --- |  --- | 
| Austria | AT  | [BMSGPK](https://www.sozialministerium.at/)  | [Website](https://info.gesundheitsministerium.at/)  | 22 Mar - *t*  | 
| Belgium | BE  | [Sciensano](https://epistat.wiv-isp.be/covid/)  | [Website](https://epistat.sciensano.be/data)  | 31 Mar - *t*  | 
| Czechia | CZ  | [MZCR](https://onemocneni-aktualne.mzcr.cz/covid-19)  | [Github: Google](https://github.com/GoogleCloudPlatform/covid-19-open-data#sources-of-data)  | 01 Mar - *t*  | 
| Denmark | DK | []() | []()   |   | 
| France | FR | [Santé publique France](https://www.data.gouv.fr/fr/organizations/sante-publique-france/)  | [Website](https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-resultats-des-tests-virologiques-covid-19/)  |  13 May - *(t-1)*  |
| Germany | DE | [Robert Koch Institute](https://www.rki.de/EN/Home/homepage.html)  | [jgehrcke](https://github.com/jgehrcke/covid-19-germany-gae)  |  02 Mar - *(t-2)*  | 
| Greece | EL | []() | []()   |   | 
| Ireland | IE | [Department of Health](https://www.gov.ie/en/organisation/department-of-health/)  | [Github: mathsnuig](https://github.com/mathsnuig/coronaviz)  |  16 Mar - *(t-8)*  | 
| Netherlands | NL | [RIVM](https://www.rivm.nl/en) | [ArcGIS datahub](https://nlcovid-19-esrinl-content.hub.arcgis.com/)   |  15 Apr - *t*  | 
| Norway | NO | [NIPH](https://www.fhi.no/en/id/infectious-diseases/coronavirus/) | [Github: thohan88](https://github.com/thohan88/covid19-nor-data)   |  26 Mar - *t*  | 
| Poland | PL | [Government of Poland](https://www.gov.pl/web/koronawirus/) | [Github: Google](https://github.com/GoogleCloudPlatform/covid-19-open-data#sources-of-data)   | 18 Mar - *t*  | 
| Portugal | PT | [DSG](https://www.dgs.pt/) | [Github: dssg-pt](https://github.com/dssg-pt/covid19pt-data)   | 23 Apr - *t*  | 
| Slovenia | SI | [Republic of Slovenia website](https://www.gov.si/en/topics/coronavirus-disease-covid-19/)  | [Github: sledilnik](https://github.com/sledilnik/data)  |  03 Apr - *(t-1)*  |
| Spain | ES | [National Center for Epidemiology](https://cnecovid.isciii.es/)  | [Website](https://cnecovid.isciii.es/covid19/)  |  31 Jan - *(t-10)*  |
| United Kingdom | UK  | []() | []()   |   | 

Notes: In the dates column *t* stands for today, and *t-x* (where *x > 0*) where *x* are the number of days. For example, *t-2*, means that today, data from two days ago is released. Some countries released data after some time gap for various reasons.
