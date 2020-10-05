#Comparison by name
source1<-read.csv('[path_to_your_source1.csv]')
source2<-read.csv('[path_to_your_source2.csv]')
colnames(source1)[2]<-"name"
colnames(source2)[2]<-"name"
source1$name<-as.character(source1$name)
source2$name<-as.character(source2$name)

# It creates a matrix with the Standard Levenshtein distance between the name fields of both sources
dist.name<-adist(source1$name,source2$name, partial = TRUE, ignore.case = TRUE)

# We now take the pairs with the minimum distance
min.name<-apply(dist.name, 1, min)
match.s1.s2<-NULL  
for(i in 1:nrow(dist.name))
{
  s2.i<-match(min.name[i],dist.name[i,])
  s1.i<-i
  match.s1.s2<-rbind(data.frame(s2.i=s2.i,s1.i=s1.i,s2name=source2[s2.i,], s1name=source1[s1.i,], adist=min.name[i]),match.s1.s2)
}
View(match.s1.s2)