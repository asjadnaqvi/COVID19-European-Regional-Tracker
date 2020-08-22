# Overview
This respository takes a stock of existing datasets at the regional level for European countries. [ECDC](https://www.ecdc.europa.eu/) is releasing information at the country level but there is no centralized database that collates this information at the regional level. There is also no indication that this information will be collected, even though most countries are providing or showcasing this information on this official websites. 

## Challenges with data access


* If data exists, it is not clear where or how to access it. Some countries keep it on the websites of official government websites, national statistical agencies, health departments, and some just export it to third-party repositories (e.g. ArcGIS datahub, Github etc). Thus each country has to be dealt with on a case-by-case basis. Due to the rise in popularity in data visualizations, a of people are scripting and collecting this information and can also be found in GitHub repositories. These will be referenced as necessary.
* Information provided by countries is not consistent. Not all countries release data on deaths, tests performed, hospitalization rates, gender and age breakdowns etc. So the lowest common homogenous unit is usually cases.
* The information on official website is not always accessible in machine-readible formats (.csv, .xls, .txt etc.). It can also exist as pdfs, entries on websites, twitter feeds etc. Hence a lot of effort has been put in put independent coders to scrap this information, or at least, archieve it for access later. These will be referenced as necessary.


## Combining data across countries

* Countries in European define regions differently. Making this information homogeneous is also a challenging task. For consistency, the European Commission/Eurostat, have homogenous units called NOMENCLATURE OF TERRITORIAL UNITS FOR STATISTICS or [NUTS](https://ec.europa.eu/eurostat/web/nuts/background). NUTS0 are countries, NUTS1 are typically provinces, NUTS2 are typically districts, and NUTS3 are typically sub-districts. Most countries release information at units lower than NUTS3. These are referred to as Local Administrative Units [LAU](https://ec.europa.eu/eurostat/web/nuts/local-administrative-units), where LAU1 (districts) and LAU2 (municipalities) are formerly NUTS4 and NUTS5 regions respectively.
* The NUTS regions are redefined every afew years (2016, 2021). Currently the 2016 definitions are used but the list of 2021 NUTS regions has already been released. This has its own set of challenges. While some countries just rename regions, others actually change, merge, and shift boundaries. Data released at LAU1 or LAU2 level can be aggregated to typically any NUTS3 definition. For the sake of consistency, we use the 2016 definition. Which might pose a serious challenge is changes in boundaries of LAUs which happens farily frequently in some countries and around around elections. If COVID19 persists in 2021 (which is most likely to happen), then switch to 2021 definitions and changes in LAU might get problematic but such errors are expected in fine grained datasets.
* Not all European countries are in the [European Union](https://europa.eu/european-union/about-eu/countries_en), and hence are not subject to Eurostat reporting/data sharing requirements. While all countries have correspondence tables between their own region definitions and NUTS, providing NUTS level information is not mandatory for non-EU countries. This list includes, the UK (post Brexit), Norway, Switzerland, and accession countries in the east of Europe. While some countries have data in a very neat format (Norway for example), they don't have the latest LAU-NUTS correspondence avaiable. They way around this problem is to overlay LAU and NUTS boundaries in some GIS software and map them based on spatial overlaps. While this should in theory perfectly overlap, small errors might persist based on boundary shifts, differences in resolution of GIS files, and simple due to some LAUs cutting across NUTS boundaries. These will be highlighted as required.



| Country | Code | NUTS 1                        | NUTS 2           | NUTS 3                        | LAU  | Other levels | Notes |
| Austria | AT           | Gruppen von Bundesländern (3) | Bundesländer (9) | Gruppen von Gemeniden (35)    | Gemeniden (2096) | Bezirke  | Data is released at the District (Bezirk) level which is between LAU and NUTS 3 regions. | 


# Country levle datasets

|Country | Code | Data source | Repository access | Level of data | Date range | Notes |
| ----- | 



| First Header  | Second Header |
| ------------- | ------------- |
| Content Cell  | Content Cell  |
| Content Cell  | Content Cell  |
