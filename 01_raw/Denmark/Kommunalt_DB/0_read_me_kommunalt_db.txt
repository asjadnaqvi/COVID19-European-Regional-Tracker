*******************************************************************************
**************************	  READ ME	  *****************************
*******************************************************************************

NOTE 10. FEBRUAR 2022: Fra og med denne dag inkluderer alle opgørelser reinfektioner. I denne forbindelse omnavngives "bekræftede tilfælde" til "første infektion".



Her finder du en beskrivelse af indeholdet af det kommunale dashboard,
herunder beskrivelser af tabellerne med tilhørende variabelnavne (søjlenavne).

Opdateret: 2022-02-10

Forkortelser:
_______________________________________________________________________________
TCD = Test Center Danmark (Statens Serum Institut)
KMA = Klinisk Mikrobiologisk Afdeling (hospitaler)


Generel struktur:
_______________________________________________________________________________
Rækkerne i filerne er som udgangspunkt opdelt efter relevante 
parametre, eksempelvis aldersgruppering eller tidsopdeling. 
Der opdeles generelt efter variablen i første søjle. 
Enkelte tabeller kan have rækker, som afviger fra dette mønster. 
I disse tabeller specificeres dette i "Noter" under tabellens 
variabelbeskrivelse. De enkelte kolonner er semikolonseparerede.

Definitioner: 
_______________________________________________________________________________
Definitioner der benyttes i dette og datafilerne er beskrevet på SSI's COVID-19-
side under Datakilder og definitioner. 
https://covid19.ssi.dk/datakilder-og-definitioner
Den 8. december 2021 ændredes definitionen af "seneste 7 dage". 

Opdateringer:
_______________________________________________________________________________
Filerne bliver opdateret hver dag. I den forbindelse kan tidsserier også 
ændre sig tilbage i tiden, hvis nyere data foreligger. Derfor anbefales det 
altid at benytte det senest tilgængelige data og så vidt muligt, 
ikke at gemme filer og lave tidsserier på basis af gamle filer.


Typer af tests:
_______________________________________________________________________________
Filerne baseres primært på PCR-opgørelser, medmindre andet er angivet. 
PCR-prøver bruges til at bekræfte covid-19-smitte under et aktivt sygdomsforløb. 
En positiv antigentest giver mistanke om covid-19-smitte.
Begreberne "PCR-prøver" og "PCR-test" betyder det samme og refererer til
antallet af podninger. Det samme gælder for begreberne "antigentest" og 
"antigenprøver".
Data indeholder ikke serologitest. Serologitest er den test, der udføres, 
når man skal undersøge, om raske mennesker tidligere har haft covid-19.

01_Noegletal
-------------------------------------------------------------------------------
Denne fil indeholder dagens nøgletal for covid-19-epidemien, som er de tal der også vises øverst på det kommunale dashboard.
Både totaler og ændringer siden sidste opdatering er inkluderet. Tallene er nationale.

Dato								: Opgørelsesdato for nøgletal
Sidste opdatering						: Nøgletal siden sidste opdatering er opjgort i forhold til denne dato
PCR-tests							: Antal PCR-tests i alt	
Antigen-tests							: Antal antigen-tests i alt
Bekræftede tilfælde i alt					: Bekræftede covid-19-tilfælde fra både førstegangsinfektioner og reinfektioner ("Bekræftede tilfælde i alt" = "Første infektion" + "Reinfektioner")
Første infektion						: Bekræftede covid-19-tilfælde (kun førstegangsinfektioner)
Reinfektioner							: Bekræftede covid-19-tilfælde (kun reinfektioner)
Dødsfald							: Dødsfald med covid-19 i alt
Nyindlæggelser							: Nyindlagte med covid-19 i alt
Indlæggelser i dag						: Indlagte med covid-19 på opgørelsesdatoen (i alt)
Indlæggelser i dag (intensiv)					: Indlagte med covid-19 på opgørelsesdatoen (kun intensiv)
Indlæggelser i dag (respirator)					: Indlagte med covid-19 på opgørelsesdatoen (kun respirator)
Indlæggelser i dag (psykiatri)					: Indlagte med covid-19 på opgørelsesdatoen (kun i psykiatriske afdelinger)
PRC-tests siden sidste opdatering				: Antal nye PCR-tests siden sidste opdatering
Antigen-tests siden sidste opdatering				: Antal nye antigen-tests siden sidste opdatering
Bekræftede tilfælde i alt siden sidste opdatering		: Nye registrerede covid-19-tilfælde siden sidste opdatering fra både førstegangsinfektioner og reinfektioner
Antal med første infektion siden sidste opdatering		: Nye registrerede covid-19-tilfælde siden sidste opdatering (kun førstegangsinfektioner)
Reinfektioner siden sidste opdatering				: Nye registrerede covid-19-tilfælde siden sidste opdatering (kun reinfektioner)
Dødsfald siden sidste opdatering				: Nye registrerede dødsfald med covid-19 siden sidste opdatering
Nyindlæggelser siden sidste opdatering				: Nye indlæggelser med covid-19 siden sidste opdatering
Ændring i indlæggelser siden sidste opdatering			: Ændring i antal indlagte med covid-19 siden sidste opdatering (i alt)
Ændring i indlæggelser (intensiv) siden sidste opdatering	: Ændring i antal indlagte med covid-19 siden sidste opdatering (kun intensiv)
Ændring i indlæggelser (respirator) siden sidste opdatering	: Ændring i antal indlagte med covid-19 siden sidste opdatering (kun respirator)
Ændring i indlæggelser (psykiatri) siden sidste opdatering	: Ændring i antal indlagte med covid-19 siden sidste opdatering (kun i psykiatriske afdelinger)



02_indlaeggelser_pr_dag_kummulativt
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af indlagte pr. dag kummulativt.

Dato					: Dato for indlæggelse
Indlæggelser kumuleret			: Antallet af indlagte


03_indlæggelser_pr_aldersgrp
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af indlagte pr. aldersgruppe.

Aldersgruppe			: Den aldersgruppe en person tilhørte ved
				  prøvetagningen
Indlæggelser			: Antallet af indlagte


04_bekraeftede_tilfaelde_doed_pr_aldersgrp
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde i alt og døde pr.
aldersgruppe.

Aldersgruppe			: Den aldersgruppe en person tilhørte ved prøvetagningen
Bekræftede tilfælde i alt	: Antallet af bekræftede tilælde
Døde				: Antallet af døde



05_nye_indlaeggelser_pr_dag
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af nye indlæggelser pr. dag.

Indlæggelsesdato		: Datoen for indlæggelse
Indlæggelser		: Antallet af nye indlæggelser


06_doed_pr_dag_kumuleret
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af døde pr. dag kummuleret

Dato			: Dato for dødsfald registreret i det Dødsårsagsregisteret
Kummuleret antal døde	: Kummulerede antal døde siden pandemiens start


07_bekraeftede_tilfaelde_pr_dag_pr_kommune
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde i alt pr. dag pr.
kommune.

Kommune				: Bopælskommunekode (kommune man boede i ved prøvetagningen)
Dato				: Dato for dødsfald registreret i Dødsårsagsregisteret
Bekræftede tilfælde i alt	: Antallet af bekræftede tilfælde i alt


09_tilfaelde_aldersgrp_kommuner
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde i alt pr. aldersgruppe 
pr. kommune.

Kommune				: Bopælskommunekode (kommune man boede i ved prøvetagning)	
Aldersgruppe			: Den aldersgruppe en person tilhørte ved prøvetagningen
Bekræftede tilfælde i alt	: Antallet af bekræftede tilælde i alt
Dagsdato			: Prøvetagnings dato

10_Kommune_kort.csv
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde, incidens, bekræftede tilfælde
de seneste 7 dage, incidens de seneste 7 dage, Antal testede personer, Testestede pr. 100.000
, PCR-testede de seneste 7 dage, Testede pr. 100.000 de seneste 7 dage samt antal borgere.

Kommune: kommunekode
Kommunenavn: Kommunes navn
Bekræftede tilfælde i alt: Bekræftede tilfælde i alt over hele perioden
Incidens: incidens tilfælde over hele perioden
Bekræftede tilfælde i alt de seneste 7 dage
Incidens de seneste 7 dage
Antal testede personer: Antal testede personer i kommunen over hele perioden
Testestede pr. 100.000: antal testede pr. 100.000 personer i kommunen
Testede de seneste 7 dage: Antal testede de seneste 7 dage 
Testede pr. 100.000 de seneste 7 dage: Antal testede pr. 100.000 de seneste 7 dage i kommunen
Antal borgere: Antal borgere i kommunen

11_kort_pr_kommune
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde, bekræftede tilfælde
de seneste 7 dage, PCR-testede de seneste 7 dage samt positivprocenten de seneste
7 dag.

Kommune						: Bopælskommunekode (kommune man boede i ved prøvetagning)
Bekræftede tilfælde i alt de seneste 7 dage	: Antallet af bekræftede tilfælde i alt de seneste 7 dage
Testede de seneste 7 dage			: Antallet af PCR-testede personer de seneste 7 dage 	
Positivprocent de seneste 7 dage		: (antal covid-19-bekræftede personer/antallet af PCR-testede personer) *100 for de seneste 7 dage


12_pcr_og_antigen_test_pr_kommune
-------------------------------------------------------------------------------
Uge		: Årstal og ugenummer
Kommunekode	: Kommunekode
Kommunenavn	: Kommunenavn
Prøver		: Antal prøver foretaget
Metode		: Prøvetagningsmetode (Antigen eller PCR)

Note: Der forekommer rækker uden Kommunenavn. Det kan fx forekomme, hvis testede personer har et CPR-nummer, men ikke er bosat i Danmark. 

13_mistaenkte_pos_pr_kommune_pr_dag
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af mistænkte tilfælde (læs mere om opgørelsesmetoden her: https://covid19.ssi.dk/datakilder-og-definitioner)
Prøvedato				: Dato for prøvetagningen
Kommunekode				: Kommunekode
Kommunenavn				: Kommunenavn
Mistænkte positive antigen tests	: Antal personer med en positiv antigentest

Note: Der forekommer rækker uden Kommunenavn. Det kan fx forekomme, hvis testede personer har et CPR-nummer, men ikke er bosat i Danmark. 

14_tilfaelde_aldersgrp_kommuner_7dage
-------------------------------------------------------------------------------
Kommune				: Kommunekode
Aldersgruppe			: Den aldersgruppe en person tilhørte ved prøvetagningen
Bekræftede tilfælde i alt	: Antallet af bekræftede tilfælde i alt de seneste 7 dage
Dagsdato			: Datoen som dataudtrækket er fra.

15_indlæggelser_pr_fnkt_alder
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af indlagte pr. aldersgruppe.

Aldersgruppe			: Den aldersgruppe en person tilhørte ved prøvetagningen
Indlæggelser			: Antallet af indlagte

16_bekraeftede_tilfaelde_fnkt_alder
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde i alt pr. aldersgruppe.

Aldersgruppe			: Den aldersgruppe en person tilhørte ved prøvetagningen
Bekræftede tilfælde i alt			: Antallet af bekræftede tilælde i alt

17_tilfaelde_fnkt_alder_kommuner
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde i alt pr. aldersgruppe 
pr. kommune.

Kommune				: Bopælskommunekode (kommune man boede i ved prøvetagning)	
Aldersgruppe			: Den aldersgruppe en person tilhørte ved prøvetagningen
Bekræftede tilfælde i alt	: Antallet af bekræftede tilælde i alt
Dagsdato			: Prøvetagnings dato

18_tilfaelde_fnkt_alder_kommuner_7dage
-------------------------------------------------------------------------------
Dette er en opgørelse over antallet af bekræftede tilfælde i alt de seneste 7 dage pr. aldersgruppe 
pr. kommune.

Kommune				: Bopælskommunekode (kommune man boede i ved prøvetagning)	
Aldersgruppe			: Den aldersgruppe en person tilhørte ved prøvetagningen
Bekræftede tilfælde i alt	: Antallet af bekræftede tilælde i alt de seneste 7 dage
Dagsdato			: Prøvetagnings dato