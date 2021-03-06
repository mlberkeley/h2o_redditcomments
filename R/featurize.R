if (file.exists("R")) setwd("R")
source("function_library.R")

load_libraries()

# Connect to SQLite file database.
db = dbConnect(drv=RSQLite::SQLite(), dbname="inbound/sample.sqlite")

# Load all data into a dataframe.
raw_data = dbGetQuery(conn=db, statement="SELECT * FROM may2015_sample")
dim(raw_data)
names(raw_data)

save(raw_data, file="data/raw-data-sample.RData")

rm(db)

# Subset to 1% to reduce computation time during development.
# Create features; raw feature processing is especially slow and needs to be optimized.
# NOTE: this returns a list, where $data contains the actual dataframe.
ptm <- proc.time()
#data_processed = featurize(raw_data, downsample_pct = 0.01)
data_processed = featurize(raw_data, downsample_pct = 0.01)
#data_processed = featurize(raw_data)
proc.time() - ptm

# Save our results.
save(data_processed, file="data/data-featurized.RData")

# Can run this line to generate a CSV export if desired.
if (F) {
  write.csv(data_processed$data, file="exports/data-featurized.csv", row.names=F)
}

# Clean up.
rm(raw_data)
gc()
