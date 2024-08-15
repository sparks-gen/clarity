setwd("/Users/anelsparks/Documents/Clarity/MKP041")

mkp041 <- read.delim("providedStr.csv", sep = ',', header = T)
str1kg <- read.delim("Data/1KGPstrPos.txt", sep = " ")
strhgd <- read.delim("Data/HGDPstrPos.txt", sep = "\t")

# Get all strs from HGDP (seeing as they have start and end positions)
commonSTRs <- Reduce(intersect, list(mkp041$name, strhgd$name))
completeSTRs <- strhgd[strhgd$name %in% commonSTRs, ]

# Get all strs from 1KGP
thousandSTR <- Reduce(intersect, list(mkp041$name, str1kg$str))
thousandSTR <- setdiff(thousandSTR, commonSTRs)
tmp <- str1kg[str1kg$str %in% thousandSTR, ]
colnames(tmp) <- c("name", "chr", "start")
tmp$end <- NA

foundSTRs <- rbind(completeSTRs, tmp)

# Save progress
write.csv(foundSTRs, file = "1kgp_hgdp.txt", row.names = F, quote = F)
todo <- setdiff(mkp041$name, foundSTRs$name)
write.csv(todo, file = "Data/MKP041/todo.txt", row.names = F, quote = F)
