# This script has to be launched by a bash script in which
# there is a loop that takes into account the names of all the taxa

# Libraries

library(tidyverse)
library(dbplyr)

x <- 0
#Importing the global_database file and the arthemis file

bold <- as.data.frame(
    read.csv("/lustre/pajotb/blasting_data/database/concatenation/Bold.csv",
        sep = ";",
        header = TRUE,
        stringsAsFactors = TRUE)
    )

arthemis <- as.data.frame(
    read.csv("/lustre/pajotb/blasting_data/database/Orders/Arthemis.csv",
    sep = ";",
    header = TRUE,
    stringsAsFactors = TRUE)
    )

print("import_ok")

# Reorganising the arthemis dataframe

arthemis <- arthemis %>%
    select(- c(Seq_ID, Species)) %>%       # Taking out some unused columns
# Renaming these columns for them to be in the same format as the bold dataframe
    rename(Species = Taxon_name,
        Taxon_name_id = Taxon_name_ID) %>%
# Filtering only the right data (valid and right size on the next line)
    filter(Sequence_validity == "Valid",
    Seq_length == 658) %>%
    select(- Sequence_validity)

# Filtering the sequences that are the right size for the bold sequences too

bold <- bold  %>%
    filter(Seq_length == 658)

# Putting the columns in the right order in the two dataframes

bold <- bold[,
    c("Phylum",
        "Class",
        "Order",
        "Family",
        "Genus",
        "Species",
        "Sequence",
        "Provenance")
    ]

arthemis <- arthemis[,
    c("Phylum",
        "Class",
        "Order",
        "Family",
        "Genus",
        "Species",
        "Sequence",
        "Provenance")]

print("modif_ok")

# Binding the two databases into one dataframe and filtering it to be sure there
# is no empty spots in the taxonomy of the database

global <- rbind(arthemis, bold) %>%
    filter(Phylum != "NA",
        Class != "NA",
        Order != "NA",
        Family != "NA",
        Sequence != "NA")

print("bind_ok")

# Looking for cases where there is a species name, but no genus name

for (i in seq_len(nrow(global))) {
    if (toString(global$Genus[i]) == "NA") {
         if (toString(global$Species) != "NA") {
            global <- global[- i, ]
            x <- x + 1
        }
    }
}



# Exporting the final as a tsv file
print(x)
write.table(global,
    file = "Final_database.csv",
    sep = ";",
    na = "NA",
    dec = ".",
    row.names = FALSE,
    col.names = TRUE)
