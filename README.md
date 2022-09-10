
**Last updated on: 10 September 2022. This project is now archived and will only see ad-hoc updates.** 

---

<img align="center" src="./misc/banner.jpg" width="1000">

[![forthebadge cc-nc](http://ForTheBadge.com/images/badges/cc-nc.svg)](https://creativecommons.org/licenses/by-nc/4.0)


[**Click here for an interactive dashboard**](https://asjadnaqvi.github.io/COVID19-European-Regional-Tracker/)

# Overview
This repository takes a stock of COVID-19 datasets for 26 European countries at the regional NUTS3 or NUTS2 level. 

The Tracker is now published in [Nature Scientific Data](https://www.nature.com/sdata/): [![DOI:s41597-021-00950-7](https://zenodo.org/badge/DOI/s41597-021-00950-7.svg)](https://www.nature.com/articles/s41597-021-00950-7)

The data is released monthly on [Zenodo](https://zenodo.org/): [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4244878.svg)](https://doi.org/10.5281/zenodo.4244878)


This repository is updated every four weeks. All raw data and scripts are available here in case more frequent updates are required. Otherwise, please feel free to request one. It takes about 30-40 minutes to run all the scripts and upload them to GitHub. Please cite the above DOIs if you are using this dataset. The underlying data structures are constantly being updated and there might be still undetected issues in the final files. For error reporting, open up an [issue](https://github.com/asjadnaqvi/COVID19-European-Regional-Tracker/issues). For comments, feedback, and other queries please e-mail at *asjadnaqvi@gmail.com* or *naqvi@iiasa.ac.at*.


This project is supported by:

[<img src="./misc/IIASA_logo.png" width="200" title="IIASA">](https://iiasa.ac.at/)



# Challenges with data access


* Almost all countries in Europe showcase COVID-19 data in the form of heatmaps and trend graphs. Access to data behind these visualizations varies from country to country. The responsibility of providing the data ranges from official government websites, to national statistical agencies, and to health ministries. While countries host the data on these websites, some just export it to third-party repositories, for example, [ArcGIS Hub](https://hub.arcgis.com/) and [GitHub](https://github.com/). As a result, each country has to be dealt with individually. While most countries allow access to regional data in some form, others do not release this information publicly. In case of the latter, one can likely find data scraped from websites especially on platforms like GitHub.

* Information provided by countries is also not consistent. Not all countries release regional data on deaths, tests performed, hospitalization rates, vaccination rates, or information by gender and age groups. Therefore, this database currently only focuses on reported cases, even though for most countries other information exists in the raw files as well. These can be easily extracted from the scripts provided.



## Combining data across countries

* Countries in European define regions differently, and therefore, making data homogeneous is a challenging task. For consistency, the European Commission and the Eurostat, have homogenous units called NOMENCLATURE OF TERRITORIAL UNITS FOR STATISTICS or [NUTS](https://ec.europa.eu/eurostat/web/nuts/background). NUTS0 are countries, NUTS1 are typically provinces, NUTS2 are typically districts, and NUTS3 are typically sub-districts. Most countries release information at administrative units lower than NUTS3. These are referred to as Local Administrative Units or [LAUs](https://ec.europa.eu/eurostat/web/nuts/local-administrative-units), where LAU1 (districts) and LAU2 (municipalities) were formerly NUTS4 and NUTS5 regions respectively. Currently only one level of LAU is documented by the European Commission. Several countries provide data at finer LAU levels.

* The NUTS regions are redefined every afew years (2013, 2016, 2021). Currently the 2021 NUTS regions have come into effect since 1st January 2021. But since most of the regional data on Eurostat is at the 2016 level, this tracker homogenizes data records also at the NUTS 2016 boundaries. The process of homogenization has its own set of challenges. While some countries just rename regions, others actually change, merge, and shift boundaries. Not all countries match perfectly to NUTS 2016 boundaries. For example, the data for Italy was always released at the 2021 NUTS boundaries definitions. This causes problems with a couple of small regions on the islands. Similarly, data for Finland is released at the hospital district level. These do not perfectly align with NUTS 3 boundaries. The rate of error is minimial since most of the regions affected by boundary shifts are very small. Additionally, the raw data is available which allows the data to be used as it is or aggregated to other administrative levels.

* Not all countries in Europe are in the [European Union](https://europa.eu/european-union/about-eu/countries_en), and hence are not subject to Eurostat reporting/data sharing requirements. While all countries have correspondence tables between their own region definitions and NUTS, providing NUTS level information is not mandatory for non-EU countries. This list includes, the UK (post Brexit), Norway, and the Switzerland. While some countries provide detailed regional information on COVID-19 (for example, Norway), they don't have the latest LAU-NUTS correspondence tables available. They way around this problem is to spatially overlay LAU and NUTS boundaries and extract the information based on boundary overlaps. While in theory the overlaps should be perfect, in practice, small errors might persist based on slight differences in boundaries, differences in resolution of spatial files, and simply some LAUs might cut across NUTS boundaries (UK is a good example of this problem).



## European regions and availability of COVID-19 data

The table below shows the national regional classifications that correspond to NUTS tables. Number of regions for each NUTS level are given in brackets and the NUTS level at which the data is available is highlighted in bold. For smaller countries, NUTS 0 and NUTS 1 are the same administrative regions. 

| Country (NUTS 0) | Code | NUTS 1 | NUTS 2 | NUTS 3 | LAU | 
| --- | --- | --- | --- | --- | --- | 
| Austria | AT  | Gruppen von Bundesländern (3) | Bundesländer (9) | **Bezirke (35)** | Gemeniden (2096) | 
| Belgium | BE  | Gewesten / Régions (3) | Provincies / Provinces (11) | Arrondissementen / Arrondissements (44) | **Gemeenten/Communes (581)** | 
| Croatia | HR  | -  | Regija (4)    | **Županija (21)** | Gradovi i općine (556)  | 
| Czechia | CZ  | Území(1) | Regiony soudržnosti (8) | **Kraje (14)** | Obce (6258) | 
| Denmark | DK  | - | Regioner (5) | Landsdele (11) | **Kommuner (99)** | 
| Estonia | EE  | - | - | Maakondade grupid (5) | **Linn, vald (79)** | 
| Finland | FI  | Manner-Suomi, Ahvenananmaa / Fasta Finland, Åland (2) | Suuralueet/Storområden (5)  |  **Maakunnat/Landskap (19)** | Kunnat / Kommuner (311) |
| France | FR  | Zones d'études et d'aménagement du territoire (14) | Régions (27) | **Départements (101)** | Communes (34970) | 
| Germany | DE  | Länder (3) | Regierungsbezirke (38) | **Kreise (401)** | Gemeniden (11087) | 
| Greece | EL  | Geografikes Perioches (4) | **Periferies (13)** | Periferiakon Enotiton (52) | Topikes Koinotites (6134) | 
| Hungary | HU  | Statisztikai nagyrégiók (3) | Tervezési-statisztikai régiók (8) | **Megyék + Budapest (20)** | Települések (3155) | 
| Ireland | IE  | - | Regions (3) | **Regional Authority Regions (8)** | Local Election Areas (166) | 
| Italy | IT  | Gruppi di regioni (5) | Regioni (21) | **Provincie (107)** | Comuni (7926) | 
| Latvia | LV  | - | - | Statistiskie reģioni (6) | **Republikas pilsētas, novadi (119)** | 
| Netherlands | NL  | Landsdelen (4) | Provincies (12) | NUTS3 (40) | **Gemeenten (355)** | 
| Norway | NO  | - | Landsdeler (7) | Fylker (18) | **Kommuner (356)** | 
| Poland | PL  | Makroregiony (7) | **Regiony (17)** | Podregiony (73) | Gminy (2478) | 
| Portugal | PT  | Continente + Regiões Autónomas (3) | Grupos de Entidades Intermunicipais + Regiões Autónomas (7) | **Entidades Intermunicipais + Regiões Autónomas (25)** | Freguesias (3098) | 
| Romania | RO | Macroregiuni (4) | Regiuni (8) | **Judet + Bucuresti (42)** | Comuni + Municipiu + Orase (3181) |
| Slovenia | SI  | - | Kohezijske regije (2) | Statistične regije (12) | **Občine (212)** | 
| Slovak Republic | SK  | - | Oblasti (4) | **Kraje (8)** | Obce (2927) | 
| Spain | ES  | Agrupación de comunidades autónomas (7) | Comunidades y ciudades Autónomas (19) | **Provincias + islas + Ceuta, Melilla (59)** | Municipios (8131) | 
| Sweden | SE | Grupper av riksområden (3) | Riksområden (8) | **Län (21)** | Kommuner (290) |
| Switzerland | CH  | - | Grossregionen (7) | **Kantone (26)** | Gemeinden/Communes (2222) | 
| United Kingdom | UK  | Government Office Regions (12) | Counties (41) | Upper tier authorities (179) | **Lower Authority Districts (LADs/LTLAs) (315)** | 

*Source:* Extended from [Eurostat LAU page](https://ec.europa.eu/eurostat/web/nuts/national-structures). 


## Sources of country datasets


The table below shows the links of the official insitutions that are responsible for COVID-19 data in their respective countries, and links to the actual databases from where the data is pulled.

| Country | Code  | Official institution | Data source |
| --- |  --- |  --- |  --- | 
| Austria | AT  | [AGES](https://covid19-dashboard.ages.at/)  | [Link](https://covid19-dashboard.ages.at/)  | 
| Belgium | BE  | [Sciensano](https://epistat.wiv-isp.be/covid/covid-19.html)  | [Link](https://epistat.wiv-isp.be/covid/)  | 
| Croatia | HR | [Ministry of Health](https://zdravlje.gov.hr/) | [Link](https://www.koronavirus.hr/podaci/otvoreni-strojno-citljivi-podaci/526)   |
| Czechia | CZ  | [MZCR](https://onemocneni-aktualne.mzcr.cz/covid-19)  | [Link](https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19)  | 
| Denmark | DK | [SSI](https://en.ssi.dk/) | [Link](https://covid19.ssi.dk/overvagningsdata/ugentlige-opgorelser-med-overvaagningsdata)   | 
| Estonia | EE | [Health Board](https://www.terviseamet.ee/et/koroonaviirus/avaandmed) | [Link](https://www.terviseamet.ee/et/koroonaviirus/avaandmed)   | 
| Finland | FI | [THL](https://thl.fi/en/web/infectious-diseases-and-vaccinations/what-s-new/coronavirus-covid-19-latest-updates)  | [Link](https://github.com/HS-Datadesk/koronavirus-avoindata)   | 
| France | FR | [Santé publique France](https://www.santepubliquefrance.fr/)  | [Link](https://www.data.gouv.fr/fr/datasets/donnees-relatives-aux-resultats-des-tests-virologiques-covid-19/)  | 
| Germany | DE | [Robert Koch Institute (RKI)](https://www.rki.de/EN/Home/homepage.html)  | [Link](https://github.com/jgehrcke/covid-19-germany-gae)  |  
| Greece | EL | [EODY](https://eody.gov.gr/epidimiologika-statistika-dedomena/ektheseis-covid-19/) | [Link](https://github.com/Sandbird/covid19-Greece)  | 
| Hungary | HU | [Government of Hungary](https://koronavirus.gov.hu/) | [Link](https://github.com/nickgon/Hungary-COVID19-Data)   | 
| Ireland | IE | [Department of Health](https://www.gov.ie/en/organisation/department-of-health/)  | [Link](https://opendata-geohive.hub.arcgis.com/datasets/d9be85b30d7748b5b7c09450b8aede63_0)  | 
| Italy | IT | [Ministero della Salute](http://www.salute.gov.it/portale/nuovocoronavirus/homeNuovoCoronavirus.jsp?lingua=english)  | [Link](https://github.com/pcm-dpc/COVID-19)  | 
| Latvia | LV | [Government of Latvia](https://covid19.gov.lv/) | [Link](https://data.gov.lv/dati/lv/dataset/covid-19-pa-adm-terit/resource/492931dd-0012-46d7-b415-)  |
| Netherlands | NL | [RIVM](https://www.rivm.nl/en) | [Link](https://nlcovid-19-esrinl-content.hub.arcgis.com/datasets/covid-19-historische-gegevens-rivm-vlakken)  | 
| Norway | NO | [NIPH](https://www.fhi.no/en/id/infectious-diseases/coronavirus/) | [Link](https://github.com/thohan88/covid19-nor-data) |  
| Poland | PL | [Government of Poland](https://www.gov.pl/web/koronawirus/) | [Link](https://github.com/covid19-eu-zh/covid19-eu-data)  |
| Portugal | PT | [DSG](https://www.dgs.pt/) | [Link](https://github.com/dssg-pt/covid19pt-data)  | 
| Romania  | RO  | [The National Institute of Public Health (CNSCBT)](https://www.cnscbt.ro/)  | [Link](https://datelazi.ro/)    |
| Slovak Republic | SK | [NHIC](http://www.nczisk.sk/en/Pages/default.aspx) |  [Link](https://github.com/radoondas/covid-19-slovakia/)   | 
| Slovenia | SI | [Republic of Slovenia website](https://www.gov.si/en/topics/coronavirus-disease-covid-19/)  | [Link](https://github.com/sledilnik/data)  |  
| Spain | ES | [National Center for Epidemiology](https://cnecovid.isciii.es/)  | [Link](https://cnecovid.isciii.es/covid19/)  | 
| Sweden | SE | [The Public Health Agency of Sweden](https://www.folkhalsomyndigheten.se/the-public-health-agency-of-sweden/)  | [Link](https://experience.arcgis.com/experience/a6d20c1544f34d33b60026f45b786230)  | 
| Switzerland | CH  | [Bundesamt für Gesundheit](https://www.bag.admin.ch/bag/de/home.html) | [Link](https://experience.arcgis.com/experience/115cd04485904fa7a5629b683a949390)  | 
| United Kingdom | UK  | [The UK Government](https://coronavirus.data.gov.uk/)   |    |   
| England |   | [National Health Service (NHS)](https://www.england.nhs.uk/coronavirus/)   | [Link](https://coronavirus.data.gov.uk/details/download)   |    
| North Ireland |  | [Department of Health North Ireland](https://www.health-ni.gov.uk/coronavirus)  |   | 
| Scotland |   | [The Scottish Government](https://www.gov.scot/coronavirus-covid-19/)  | [Link](https://public.tableau.com/profile/phs.covid.19#!/vizhome/COVID-19DailyDashboard_15960160643010/Overview)   |   
| Wales |   |  [The Welsh Government](https://www.gov.scot/coronavirus-covid-19/)  |    |   

*Note:* The links are subject to change. If you find an error or a better data source, then please let me know.


# Workflow
The following workflow is used to compile the data at the NUTS3 or NUTS2 level:

<img src="./05_figures/workflow.png" width="800" title="Workflow">

The date range for countries:
<img src="./05_figures/range_date.png" width="800" title="">

The scatter plot of daily cases per 10k population at the NUTS level:
<img src="./05_figures/range_newcasepop.png" width="800" title="">

Policy stringency index:
<img src="./05_figures/policystringency.png" width="800" title="">


## Data validation

In order to validate the data, the regional level information is aggregated up to country-level totals. These are compared with Our World in Data's (OWID) [COVID-19 tracker](https://ourworldindata.org/coronavirus) numbers. OWID is a key source for COVID-19-related information and is referenced frequently in scientific research and the media. OWID was utilizing country-level information provided by the [European Center for Disease Control (ECDC)](https://www.ecdc.europa.eu/en) till November 2020. In November 2020, ECDC announced that it will switch to weekly data releases under [The European Surveillance System (TESSy)](https://covid19-surveillance-report.ecdc.europa.eu/) where countries submit NUTS2-level data. As a response, [OWID switched](https://coronavirus.jhu.edu/map.html) to the John Hopkins University's (JHU) [data](https://coronavirus.jhu.edu/map.html), which provides COVID-19 information at the global level. 

<img src="./05_figures/validation.png" width="800" title="Tracker comparison with OWID data">

For validation, both this Tracker and OWID data is merged on a country-date combination and the difference between the daily cases is calculated. The figure above plots these differences by countries. After October 2020, the mismatch in the totals goes up significantly and persists till today. Two explanations for these trends. First, before October 2020, daily data was provided by ECDC which was taking information directly from European countries. Since this Tracker is pulling data from the countries directly, the match pre-October 2020 is very close with the exception of a few outliers. Second, since the data source of this Tracker remains unchanged, while OWID updated its source to broader (less-verified) database after October 2020, this Tracker provides a more accurate picture of country-level aggregates including regional variations. As of March 2021, ECDC is again releasing daily country-level data but gaps exist between the latest data series and the pre-November 2020 updates.


# Graphs

## Share of cases and deaths in Tracker countries

The Tracker countries are shown in orange, while the rest of Europe and Central Asia is shown in yellow.

<img src="./05_figures/tracker_cases.png" width="800" title="Share of cases in Tracker countries">

<img src="./05_figures/tracker_deaths.png" width="800" title="Share of cases in Tracker deaths">

## All data points (Jan 2020 to present):
<img src="./05_figures/COVID19_EUROPE_cases_total.png" width="400" title="Cumulative COVID-19 cases"><img src="./05_figures/COVID19_EUROPE_casespop_total.png" width="400" title="Cumulative COVID-19 per 10k population">

## Cases on the last data point for each NUTS region:
<img src="./05_figures/COVID19_EUROPE_cases_today.png" width="400" title="COVID-19 cases (last observation)"><img src="./05_figures/COVID19_EUROPE_casespop_today.png" width="400" title="COVID-19 per 10k population (last observation)">

## Change in cases in the past 14 days:

<img src="./05_figures/COVID19_EUROPE_change14_abs.png" width="400" title="Absolute change in COVID-19 cases (past 14 days)"><img src="./05_figures/COVID19_EUROPE_change14_abs_pop.png" width="400" title="Absolute change in COVID-19 cases per 10k population (past 14 days)">

<!--- use this to mark out codes  -->

<!--- For the maps above, the last available data point is used. The video below shows the evolution of cases over time for data available till 7th December 2020:
[![](http://img.youtube.com/vi/QTbUUhLiKrQ/0.jpg)](https://youtu.be/Yql1HFUUYTM "December 2020 update") 
Countries with data only at the NUTS-2 level have not been added to the video above. See below for individual countries maps which are updated weekly. -->


## Animation

[Jan Kühn](https://yotka.org/) has made a Python animation using the data from the tracker:

[![Watch the video](https://img.youtube.com/vi/sBfaL9V16Uk/default.jpg)](https://www.youtube.com/watch?v=sBfaL9V16Uk)



# Individual country maps:
Here, country-level maps and figures are shown as sanity checks on the data. These are mostly to ensure data consistency and the level of completeness for NUTS regions. Notes are added to invidual countries where necessary.

## Austria (AT)

<img src="./05_figures/covid19_AT.png" width="300"><img src="./05_figures/covid19_AT_pop.png" width="300">

<img src="./05_figures/range_date_Austria.png" width="400">


## Belgium (BE)

<img src="./05_figures/covid19_BE.png" width="300"><img src="./05_figures/covid19_BE_pop.png" width="300">

<img src="./05_figures/range_date_Belgium.png" width="400">


## Switzerland (CH)

<img src="./05_figures/covid19_CH.png" width="300"><img src="./05_figures/covid19_CH_pop.png" width="300">

<img src="./05_figures/range_date_Switzerland.png" width="400">


## Czechia (CZ)

<img src="./05_figures/covid19_CZ.png" width="300"><img src="./05_figures/covid19_CZ_pop.png" width="300">

<img src="./05_figures/range_date_Czechia.png" width="400">


## Germany (DE)

<img src="./05_figures/covid19_DE.png" width="300"><img src="./05_figures/covid19_DE_pop.png" width="300">

<img src="./05_figures/range_date_Germany.png" width="400">

## Denmark (DK)
<img src="./05_figures/covid19_DK.png" width="300"><img src="./05_figures/covid19_DK_pop.png" width="300">

<img src="./05_figures/range_date_Denmark.png" width="400">

## Estonia (EE)

<img src="./05_figures/covid19_EE.png" width="300"><img src="./05_figures/covid19_EE_pop.png" width="300">

<img src="./05_figures/range_date_Estonia.png" width="400">


## Greece (EL)

<img src="./05_figures/covid19_EL.png" width="300"><img src="./05_figures/covid19_EL_pop.png" width="300" >

<img src="./05_figures/range_date_Greece.png" width="400">

## Spain (ES)

<img src="./05_figures/covid19_ES.png" width="300"><img src="./05_figures/covid19_ES_pop.png" width="300">

<img src="./05_figures/range_date_Spain.png" width="400">

## Finland (FI)

<img src="./05_figures/covid19_FI.png" width="300"><img src="./05_figures/covid19_FI_pop.png" width="300">

<img src="./05_figures/range_date_Finland.png" width="400">

## France (FR)

<img src="./05_figures/covid19_FR.png" width="300"><img src="./05_figures/covid19_FR_pop.png" width="300">

<img src="./05_figures/range_date_France.png" width="400">

## Croatia (HR)

<img src="./05_figures/covid19_HR.png" width="300"><img src="./05_figures/covid19_HR_pop.png" width="300">

<img src="./05_figures/range_date_Croatia.png" width="400">

## Hungary (HU)

<img src="./05_figures/covid19_HU.png" width="300"><img src="./05_figures/covid19_HU_pop.png" width="300">

<img src="./05_figures/range_date_Hungary.png" width="400">

## Ireland (IE)

<img src="./05_figures/covid19_IE.png" width="300"><img src="./05_figures/covid19_IE_pop.png" width="300">

<img src="./05_figures/range_date_Ireland.png" width="400">

## Italy (IT)

<img src="./05_figures/covid19_IT.png" width="300"><img src="./05_figures/covid19_IT_pop.png" width="300">

<img src="./05_figures/range_date_Italy.png" width="400">


## Latvia (LV)

<img src="./05_figures/covid19_LV.png" width="300"><img src="./05_figures/covid19_LV_pop.png" width="300">

<img src="./05_figures/range_date_Latvia.png" width="400">

## Netherlands (NL)

<img src="./05_figures/covid19_NL.png" width="300"><img src="./05_figures/covid19_NL_pop.png" width="300">

<img src="./05_figures/range_date_Netherlands.png" width="400">

## Norway (NO)

<img src="./05_figures/covid19_NO.png" width="300"><img src="./05_figures/covid19_NO_pop.png" width="300">

<img src="./05_figures/range_date_Norway.png" width="400">


## Poland (PO)

<img src="./05_figures/covid19_PL.png" width="300"><img src="./05_figures/covid19_PL_pop.png" width="300">

<img src="./05_figures/range_date_Poland.png" width="400">


## Portugal (PT)

<img src="./05_figures/covid19_PT.png" width="300"><img src="./05_figures/covid19_PT_pop.png" width="300">

<img src="./05_figures/range_date_Portugal.png" width="400">


## Romania (RO)

<img src="./05_figures/covid19_RO.png" width="300"><img src="./05_figures/covid19_RO_pop.png" width="300">

<img src="./05_figures/range_date_Romania.png" width="400">

## Sweden (SE)

<img src="./05_figures/covid19_SE.png" width="300"><img src="./05_figures/covid19_SE_pop.png" width="300">

<img src="./05_figures/range_date_Sweden.png" width="400">

## Slovenia (SI)

<img src="./05_figures/covid19_SI.png" width="300"><img src="./05_figures/covid19_SI_pop.png" width="300">

<img src="./05_figures/range_date_Slovenia.png" width="400">

## Slovak Republic (SK)

<img src="./05_figures/covid19_SK.png" width="300"><img src="./05_figures/covid19_SK_pop.png" width="300">

<img src="./05_figures/range_date_Slovak Republic.png" width="400">

## England and Scotland (UK)

<img src="./05_figures/covid19_UK.png" width="300"><img src="./05_figures/covid19_UK_pop.png" width="300">

<img src="./05_figures/range_date_England (UK).png" width="400">




# In the media

Articles in the press related to the Tracker:

https://idw-online.de/de/news772852

https://kurier.at/wissen/wissenschaft/oesterreichische-forscher-veroeffentlichen-covid-19-datenbank/401444512

https://science.apa.at/power-search/7815872667735462217

https://sciencenewsnet.in/tracking-covid-19-across-europe/

https://www.newswise.com/coronavirus/tracking-covid-19-across-europe/?article_id=754373

https://www.miragenews.com/tracking-covid-19-across-europe-596568/

https://www.eurekalert.org/pub_releases/2021-07/iifa-tca071521.php

https://science.orf.at/stories/3207633/



# Change Log
* 10 Sep 2022: All countries updated. Currently few countries are still regularly reporting their data. Portugal data fixed. All links checked and updated. Year format switched to 2 digits to avoid error in Stata exports. UK data link is now dead. Date entries, where a country had zero cases, were being dropped. This was showing up in the dataset as missing values. These entries have been put back in the dataset to avoid suprious interpolations. 
* 24 Jun 2022: All countries updated. Denmark and France have slightly changed their data structures. Around half the countries are reporting regularly. This is the last update and the project will be archived. If you are interested in continuing with country-level updates, the scripts and the links are provided in the repository. Otherwise, message me and I can update whatever can be updated.
* 15 Mar 2022: All countries updated. Several fixes to scripts and graphs. Data quality is declining across some countries. Notably Poland and Scotland don't have regular updates. Several other countries now have data gaps.
* 10 Feb 2022: All countries updated. Several fixes to scripts, paths, miscellaneous improvements to code. Gaps are starting to appear in the daily data for several countries. Ireland's data has ad-hoc updates where several weeks or months of data might be missing. Poland's data that is scraped, has irregular updates.
* 08 Jan 2022: All countries updated. Minor fixes to the scripts.
* 15 Dec 2021: All countries updated. Minor improvements to the scripts. GIF animation added to the Tracker. This will be the last update of 2021.
* 25 Nov 2021: All countries updated. Poland fixed again. Interactive map updated to show change in the last 14 days. Legends and color schemes improved. Minor code optimizations. The master tracker file is now at 750,000 data points.
* 01 Nov 2021: All countries updated. Romania data switched to a GitHub repository which cleans up the data. An error corrected in stream plot where Czechia was being dropped. Script for regional data range check graphs improved. A lot of redundant code cleaned up.
* 03 Oct 2021: All countries updated. Ireland has been released and has been added back in the maps. Latvia data is available in the raw files but the mapping of the new administrative units to the old ones is not clear. Code in several files cleaned up. NUTS names added to the master file for various figures and maps. An [interactive dashboard](https://asjadnaqvi.github.io/COVID19-European-Regional-Tracker/) at the NUTS 3 level has been added.
* 30 Aug 2021: All countries updated. Latvia has completely revamped its administrative structure and the official correspondence from the new to the old boundaries is not clear. The links to the new data has been added to the country dofile but it has been removed for now from the EU-level maps. Ireland data is still not updated.
* 01 Aug 2021: All countries updated. Latvia has switched to a new region system. This will be incorporated in the next update once the correspondence to NUTS 3 2016 is figured out. Added a heat plot on policy stringency. Add individual country hex plots at the NUTS level as checks on the data. This update is the official July 2021 Zenodo release.
* 22 Jul 2021: All countries updated. Changes to the map script to automatically drop regions which don't hav updates for the past 14 days. Since Portugal data is released every two weeks, it contains information on daily cases for the day of the data release. This allows us to calculate bi-weekly changes in cases. NUTS regions which are fall off the maps will be checked. Either their data is not updated or they have issues in their names in the original data files.
* 01 Jul 2021: All countries updated. Ireland's data is still not being updated so it has been dropped from Europe maps. New dedicated webpage created for this repository: https://asjadnaqvi.github.io/COVID19-European-Regional-Tracker/. In the maps the rise of the delta variant is also visible.
* 12 Jun 2021: England data source changed to the offical ONS data at the LTLA level which maps to NUTS 3. Since the raw files are very large the original version has been removed from the directories. Please see the dofiles for the links. All countries updated. This will be the official May/June 2021 release version.
* 31 May 2021: All countries updated. Minor fixes to Ireland's dofile. England's data from ODI Leeds is no longer being updated regularly. For this update, England's data is still the old version from April. One option is to replace England data with the official ONS information but its mapping to NUTS2/NUTS3 needs to be checked.
* 18 May 2021: Negative change in daily cases were being dropped in the master file. These have been added back in. It is up to the users to decide on how to deal with them. Negative changes in daily cases exist in the raw files and are mostly likely corrections to the data. A flag variable has been added to the master file which equals 1 if the daily_cases variable is negative. These are 0.18% of the data at the time of this update. Other minor fixes include dropping redundant variables and ordering the columns. The scatter plot for daily NUTS cases per 10k population now shows the complete data series.
* 13 May 2021: Fixed Poland's (PL) repository. The underlying data structure changed for the files were not compiling correctly. Switzerland's (CH) data file had missing data points wrongly showing up as 0 cases. These have been fixed.
* 01 May 2021: All files updated for the May release. Minor errors fixed in dofiles. Population file has been updated to include 2020 regional population data. For the UK 2019 values are used since regional information no longer exists in the Eurostat database due to Brexit.
* 06 Apr 2021: All files updated for the April release. Maps switched back to Viridis color scheme.
* 22 Mar 2021: Scotland data is now from the official NHS website. The code has also been corrected. Other minor fixes to the remaining countries. I am taking out Portugal from the maps. Portugal's data is bi-weekly and it is not possible to elicit daily information. The raw data files are still in the database. Region names from the maps have been removed. A new map has been added which shows percentage change in cases in the last 14 days. Note that for Europe maps, the last available data entry of each NUTS region is used. This is to ensure that maps are as complete as possible since some data points for the latest date are missing.
* 04 Mar 2021: All files checked and updated. Minor fixes to the code. Path to access raw data for Spain fixed. Folders cleaned up further.
* 13 Feb 2021: All files checked and updated. Major fixes to the code. Raw data is now in the 04_master folder in .csv and .dta format. Daily cases fixed for several countries. Previously they were calculated as the difference between the observations and not the dates. Thus if a country had skipped several days, the daily cases would show a huge jump. These observations are now set to missing. As aa result there are more gaps now. If a country has 0 cases for a given date, that date is now dropped from the homogenized dataset. For example, Portugal which changed the reported to weekly and bi-weekly frequeny now has large gaps. The original data still contains all the dates and the values. Estonia's data fixed and it now reflects the correct values. A validation file added which aggregates country level data for each date and compares it with Our World in Data (OWID) values. This update is released as v1.3 on Zenodo.
* 25 Jan 2021: All files checked and updated. Minor fixes to code. Some file paths changed. Country level graphs now show the last data point for a region. This is just for presentation. Please see the data files for actual information.
* 05 Jan 2021: All files checked and updated. Data for Poland, Greece, Switzerland fixed. Portugal is releasing data at weekly intervals only and therefore daily cases per capita need to be imputed correctly. The scripts have been updated to Stata 16. There should not be compatibility issues with earlier versions but please report if the files don't compile. New maps added for cumulative cases and cumulative cases per capita for 2020.
* 07 Dec 2020: All files updated. Romania JSON has been scripted in Stata. Portugal status remains the same. Last regional updated was 26 Oct 2020. Portugal and Greece have been removed from the Europe map but individual files remain in the database.
* 25 Nov 2020: All files updated. Portugal has not updated the official dataset since 26 Oct, 2020. Greece data is also patchy. Maps are now organized in alphabetical order of the 2-letter country code rather than when they were added to this repository.
* 17 Nov 2020: All files added to the directory for public release. Zenodo badge created. Tables have been updated. All dofiles were checked and reworked for updates, new datasets, paths. Dofiles for country level maps will be added soon. 
* 01 Nov 2020: Scotland and Romania added. All data files and scripts were rechecked. The maps were homogenized across countries. The data range of countries was fixed. Some countries only release data periodically at regional levels.
* 25 Oct 2020: Deprecated links fixed. Date ranges removed from table and replace with a figure. If data sources for missing countries are not found, they will be replace by country level data from ECDC to complete the map.
* 17 Oct 2020: Ireland repository fixed. New Youtube video uploaded. Maps are now mix-domain NUTS3 and NUTS2 so populations are normalized accordingly.
* 04 Oct 2020: Countries with JSON datasets have been now been automated. Ireland dataset is no longer being updated on Github but the official website now provides more accurate information. This will be added soon. Still looking for UK minus England data. Potentially also looking for Lithania, Bulgaria, Romania and other countries missing from Europe.
* 21 Sep 2020: Croatia and Denmark added to the maps. Ireland data is no longer updating since the Github repository is now dormant. NUTS2 population needs to be added to cases per population map.
* 16 Sep 2020: Poland and Greece NUTS2 data has been merged with the main file and added to the map. Data for Croatia and Denmark will be integrated next. Next task is to find Lithuania and Ukraine data sets.
* 07 Sep 2020: Improved documentation of the maps. All maps are now displayed above. Youtube video of changes in NUTS-3 level cases added. Map of cases and cases per pop added.
* 31 Aug 2020: Estonia, Latvia, Slovakia added to the database.
     * Estonia only provides case ranges in bands of 10 (0-10, 11-20, etc). NUTS 3 level data is approximated by taking mid-points of each range for each date/region combination and then aggregating to the NUTS 3.
* 29 Aug 2020: Switzerland and Greece added to the database. Greece is data is only available at the NUTS 2 level.
* 27 Aug 2020: 
    * Portugal: taken out for now for data checking since there are issues with the series continuity.
    * France: Historical data before 13th May added. There is a huge jump in the number of tests and reported cases for the few observations that overlap. This is because before 13th May, data was only being collected from 3 labs before proper testing protocols were introduced. There is no way of back correcting this information but maybe some form of data interpolation might help.
* 26 Aug 2020: Github repository created with documentation of regions in European countries.






