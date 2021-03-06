## Program:  Combine_RIBS_EDDs_v5.R
## Purpose: Combnines multiple RIBS EDD files ("sample" and "result" files) and adds column headers. 
##            First merges result and sample files for single EDD, then binds all files.
##            Outputs separate merged EDD sample/result files in addition to a single bound files for all input EDDs.
## Author: Gavin Lemley
## Created 3/6/2018
## Last updated: 9/27/2018

## Instructions: Specify input and output directories. Place EDD folders in input directory.
  ##### BE SURE TO CLEAR WORKSPACE BEFORE RUNNING #####

library(plyr)

####### Define input/output directories  #########
  
  input_dir <- "C:/Rscripts/RIBS.Data/data/2018/FL_RAS/EDDs/"
  ouput_dir <- "C:/Rscripts/RIBS.Data/data/2018/FL_RAS/Script_output/"

##################################################
    
# Set working dir to input dir
setwd(input_dir)

folder_list <- list.files()
nfolder_list = length(folder_list)
RSfile_list <- list()

for (i in 1:nfolder_list){
  print(folder_list[i])
  setwd(paste(input_dir,folder_list[i],sep=""))

  temp_result <- read.table("TestResultQC_v3.txt",sep=",",fill=TRUE,header=FALSE,stringsAsFactors=FALSE,
                    col.names = c("sys_sample_code","lab_anl_method_name","analysis_date","fraction","column_number",
                                  "test_type","lab_matrix_code","analysis_location","basis","container_id","dilution_factor",
                                  "prep_method","prep_date","leachate_method","leachate_date","lab_name_code","qc_level",
                                  "lab_sample_id","percent_moisture","subsample_amount","subsample_amount_unit","analyst_name",
                                  "instrument_id","comment","preservative","final_volume","final_volume_unit","cas_rn","chemical_name",
                                  "result_value","result_error_delta","result_type_code","reportable_result","detect_flag",
                                  "lab_qualifiers","validator_qualifiers","interpreted_qualifiers","validated_yn",
                                  "method_detection_limit","reporting_detection_limit","quantitation_limit","result_unit",
                                  "detection_limit_unit","tic_retention_time","minimum_detectable_conc","counting_error","uncertainty",
                                  "critical_value","validation_level","result_comment","qc_original_conc","qc_spike_added",
                                  "qc_spike_measured","qc_spike_recovery","qc_dup_original_conc","qc_dup_spike_added",
                                  "qc_dup_spike_measured","qc_dup_spike_recovery","qc_rpd","qc_spike_lcl","qc_spike_ucl","qc_rpd_cl",
                                  "qc_spike_status","qc_dup_spike_status","qc_rpd_status","lab_sdg")
                    )
 
   ### ABOVE BRINGS IN FACTOR AS LOGICAL. Below converts all "T"s to "TRUE"s. May want to specify all column classes instead.  ###
   temp_result$fraction <- as.character(temp_result$fraction)
   temp_result$fraction <- revalue(temp_result$fraction, c("TRUE" = "T"))
   
  
  temp_sample <- read.table("Sample_v3.txt",sep=",",fill=TRUE,header=FALSE, stringsAsFactors=FALSE,
                    col.names = c("#data_provider","sys_sample_code","sample_name","sample_matrix_code","sample_type_code",
                                  "sample_source","parent_sample_code","sample_delivery_group","sample_date","sys_loc_code",
                                  "start_depth","end_depth","depth_unit","chain_of_custody","sent_to_lab_date","sample_receipt_date",
                                  "sampler","sampling_company_code","sampling_reason","sampling_technique","task_code",
                                  "collection_quarter","composite_yn","composite_desc","sample_class","custom_field_1","custom_field_2",
                                  "custom_field_3","comment"))
  # NOTE THAT ROW ORDER OF INPUT FILE IS NOT RETAINED
  temp_RSmerge <- merge(temp_result,temp_sample,by="sys_sample_code", all=TRUE)
  
  filenm <- paste(ouput_dir,folder_list[i],"_RSmerge.csv", sep="")
  print(filenm)

  if ((nrow(temp_result)) < (nrow(temp_RSmerge))) {
    stop('SCRIPT STOPPED: Extra records created in merge. Check EDD for errors.')
  }
  if ((nrow(temp_result)) > (nrow(temp_RSmerge))) {
    stop('SCRIPT STOPPED: Not enough records created with merge. Check for errors.')
  }
  
  # Create name using EDD and added suffix, and assign to current data frame 
  mergenm <- paste0(folder_list[i], "_RSmerge")
  mergefile <- assign(mergenm, temp_RSmerge)
  
  #Add current data frame to the list of all dataframes
  RSfile_list[[i]] <- mergefile

  ### Export each merged EDD as CSVs (optional, for troubleshooting)
  # write.table(temp_RSmerge, file=filenm,sep=",", row.names = FALSE)
    
}


# Bind all data frames in "list of data frames" together into a single data frame and write to a CSV
setwd(ouput_dir)
RIBSdata = do.call(rbind, RSfile_list)
write.table(RIBSdata, file="Combine_EDDs_output.csv",sep=",", row.names = FALSE)













































