#Load Libraries
library(SPARQL)
library(ggplot2)


#tell R where the endpoint is:
endpoint <- 'http://statistics.gov.scot/sparql'

#Create query
query <- 'PREFIX qb: <http://purl.org/linked-data/cube#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sdmx: <http://purl.org/linked-data/sdmx/2009/concept#>
PREFIX data: <http://statistics.gov.scot/data/>
PREFIX sdmxd: <http://purl.org/linked-data/sdmx/2009/dimension#>
PREFIX mp: <http://statistics.gov.scot/def/measure-properties/>
PREFIX stat: <http://statistics.data.gov.uk/def/statistical-entity#>
SELECT ?areaname ?nratio ?yearname ?areatypename WHERE {
?indicator qb:dataSet data:alcohol-related-discharge ;
sdmxd:refArea ?area ;
sdmxd:refPeriod ?year ;
mp:ratio ?nratio .
?year rdfs:label ?yearname .

?area stat:code ?areatype ;
rdfs:label ?areaname .
?areatype rdfs:label ?areatypename .
}'

#LOading the filr
qd <- SPARQL(endpoint,query)

#Viewing the data
head(qd)

df <- qd$results

head(df)

#Selecting the years who's data you wnat eg 2010/211
df2010 <- df[(df$areatypename == 'Council Areas' & df$yearname == '2010/2011'), ]

#PLoting the data
c <- ggplot(data = df2010, aes(x=areaname, y=nratio)) + geom_bar(stat='identity')

#Sorting the data from highest to lowest
c <- ggplot(data = df2010, aes(x=reorder(areaname, -nratio), y=nratio, fill=areaname)) + theme_bw() + geom_bar(stat='identity') + theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5)) + ggtitle('Alcohol-related Hospital Discharges 2010–2011 (Rate per 10,000 people)') + labs(x='Council Area', y='Rate per 100,000 people') + theme(legend.position='none')

c
