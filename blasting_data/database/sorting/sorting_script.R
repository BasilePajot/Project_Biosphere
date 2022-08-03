# This script has to be launched by a bash script in which
# there is a loop that takes into account the names of all the taxa

# Libraries
# Uncode if needed: install.packages("anyLib")
# This library is used to install the named packages if they are not installed and load them after that or if they are already installed
library(anyLib)
anyLib(c("dbplyr", "tydiverse"))

#Importing the bold file and the arthemis file
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

# Filtering the bold database to keep only the useful sequences (size = 658 bp)
bold <- bold %>%
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

# Binding the two databases into one dataframe and filtering it to be sure there is no empty spots in the taxonomy of the database
global <- rbind(arthemis, bold) %>%
    filter(Phylum != "NA",
        Class != "NA",
        Order != "NA",
        Family != "NA",
        Sequence != "NA")

print("bind_ok")

# Looking for cases where there is a species name, but no genus name by doing a double verification on the genus and the species
for (i in seq_len(nrow(global))) {
    if (toString(global$Genus[i]) == "NA") {
         if (toString(global$Species) != "NA") {
            global <- global[- i, ]
            print(i)
        }
    }
}

print("loop_ok")
print(global)

# Exporting the final as a csv file
write.table(global,
    file = "Final_database.csv",
    sep = ";",
    na = "NA",
    dec = ".",
    row.names = FALSE,
    col.names = TRUE)

print("done")
